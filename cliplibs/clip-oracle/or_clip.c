#include "clip.h"
#include "string.h"
#include "time.h"
#include "ctype.h"
#include "ociap.h"
#include "dbfsql.h"

#define PIECEBUFLEN		1024*4
#define TIMEOUT			30

OCILobLocator* lob = NULL;

char gRowid[18];

static const char subsys[] = "DBFSQL";
static const char er_connect[] = "Can't connect to database server";
static const char er_nosql[] = "No SQL statement";
static const char er_norowset[] = "No such rowset";
static const char er_nofield[] = "No such field";
static const char er_typemismatch[] = "RDBMS and Clipper types are incompatible or RDBMS type is not supported";
static const char er_badstatement[] = "Non SELECT statement expected";
static const char er_badselect[] = "SELECT statement expected";

int or_createconn(ClipMachine* mp);

struct tagOR_CONN;

typedef struct tagOR_STMT {
	struct tagOR_STMT* next;
	int stmt_item;
	struct tagOR_CONN* conn;
	char* sql;
	OCIStmt* stmt;
} OR_STMT;

// Rowset abstract structure
typedef struct tagOR_ROWSET {
	int rowset_item;
	struct tagOR_CONN* conn;
	struct tagOR_ROWSET* next;
	int recno;
	int lastrec;
	int bof;
	int eof;
	int nfields;
	SQLFIELD* fields;
	int id;
	HashTable* orders;
	long* taghashes;
	int ntags;
	BTREE* bt;
	struct tagSQLORDER* curord;
	void*** data;
} OR_ROWSET;

// Connection abstract structure
typedef struct tagOR_CONN {
	SQLVTBL* vtbl;
	OR_STMT* stmts;
	OR_ROWSET* rowsets;
	SQLLocale* loc;
	OCIEnv* env;
	OCIServer* serv;
	OCISession* sess;
	OCISvcCtx* context;
	OCIError* err;
} OR_CONN;

void or_destroyconn(SQLCONN* conn);
int or_prepare(ClipMachine* mp,SQLCONN* conn,char* sql);
int or_command(ClipMachine* mp,SQLSTMT* stmt,ClipVar* ap);
int or_createrowset(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* stmt,ClipVar* ap,const char* idname,const char* gen_idSQL);
char* or_testparser(ClipMachine* mp,char* sql,ClipVar* ap);
char* or_getvalue(SQLROWSET* rowset,int fieldno,int* len);
void or_setvalue(SQLROWSET* rowset,int fieldno,char* value,int len);
void or_append(SQLROWSET* rowset);
void or_delete(SQLROWSET* rowset);
void or_newid(ClipMachine* mp,SQLSTMT* stmt);
int or_refresh(ClipMachine* mp,SQLROWSET* rowset,SQLSTMT* stmt,ClipVar* ap,const char* idname);

static SQLVTBL vtbl = {
	sizeof(OR_ROWSET),
	or_destroyconn,
	or_prepare,
	or_command,
	or_createrowset,
	or_testparser,
	or_getvalue,
	or_setvalue,
	or_append,
	or_delete,
	or_newid,
	or_refresh,
	NULL
};

int clip_INIT_ORACLE(ClipMachine* mp){
	mp->or_connect = or_createconn;
	return 0;
}

static void destroy_or_stmt(void* stmt){
	if(stmt){
		OCIHandleFree(((OR_STMT*)stmt)->stmt,OCI_HTYPE_STMT);
		if(((OR_STMT*)(stmt))->sql){
			free(((OR_STMT*)(stmt))->sql);
		}
		free(stmt);
	}
}

// Helper function used by _clip_destroy_c_item to release rowset.
static void destroy_or_rowset(void* rs){
	OR_ROWSET* rowset = (OR_ROWSET*)rs;
	int i,j;
	if(rowset){
		if(rowset->fields){
			free(rowset->fields);
		}
		if(rowset->data){
			for(i=0;i<rowset->lastrec;i++){
				for(j=0;j<rowset->nfields;j++){
					if(rowset->data[i][j]){
						if(rowset->fields[j].type==SQLT_CLOB ||
							rowset->fields[j].type==SQLT_BLOB ||
							rowset->fields[j].type==SQLT_FILE){

							OCIDescriptorFree(
								*(OCILobLocator**)((char*)rowset->data[i][j]+4),
								OCI_DTYPE_LOB);
						}
						free(rowset->data[i][j]);
					}
				}
				free(rowset->data[i]);
			}
			free(rowset->data);
		}
		free(rowset);
	}
	return;
}

// Helper function used by _clip_destroy_c_item to release connect.
// All opened rowsets and statements are released too.
static void destroy_or_conn(void* conn){
	OR_ROWSET* currowset = ((OR_CONN*)(conn))->rowsets;
	OR_ROWSET* nextrowset;
	OR_STMT* curstmt = ((OR_CONN*)(conn))->stmts;
	OR_STMT* nextstmt;
	if(conn){
		OCIHandleFree(((OR_CONN*)conn)->env,OCI_HTYPE_ENV);
		OCIHandleFree(((OR_CONN*)conn)->serv,OCI_HTYPE_SERVER);
		OCIHandleFree(((OR_CONN*)conn)->sess,OCI_HTYPE_SESSION);
		OCIHandleFree(((OR_CONN*)conn)->context,OCI_HTYPE_SVCCTX);
		OCIHandleFree(((OR_CONN*)conn)->err,OCI_HTYPE_ERROR);
		while(currowset){
			nextrowset = currowset->next;
			destroy_or_rowset(currowset);
			currowset = nextrowset;
		}
		while(curstmt){
			nextstmt = curstmt->next;
			destroy_or_stmt(curstmt);
			curstmt = nextstmt;
		}
		free(conn);
	}
	return;
}

static int checkerr(dvoid* err,char* msg,int len,ub4 type,sword res){
	sb4 errcode;
	if(res){
//		printf("res=%d\n",res);
		OCIErrorGet(err,1,NULL,&errcode,msg,len,type);
		msg[strlen(msg)-1] = 0;
//		printf("%s\n",msg);
		return errcode;
	}
	return 0;
}

#define CHECKENV(e,b,r,a) if(checkerr((dvoid*)(e),msg,sizeof(msg),OCI_HTYPE_ENV, \
	(a))){_clip_trap_err(mp,0,0,0,subsys,(b),msg);return (r);}

#define CHECKERR(e,b,r,a) if(checkerr((dvoid*)(e),msg,sizeof(msg),OCI_HTYPE_ERROR, \
	(a))){_clip_trap_err(mp,0,0,0,subsys,(b),msg);return (r);}

int or_oracletype(dvoid** ordata,ClipVar cldata,double* type,sb4* len,OR_STMT* stmt,ClipMachine* mp,sb2* ind){
	char num[100];
	int year,mon,day,week;
	char* month[] = {"JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"};
	sword res;
	ub4 lobempty = 0;
	char msg[256];
	ub1 csfrm;
	ub2 csid;
	ub4 chunksize;
	int wrote = 0;
	ub4 towrite;

	if((cldata.t.type==CHARACTER_t) && (cldata.s.str.len==4)
		&& (strncmp(cldata.s.str.buf,"null",4)==0)){
		*len = 0;
		if(*type!=SQLT_CLOB && *type!=SQLT_BLOB){
			*ordata = malloc(0);
			*ind = -1;
			return 0;
		}
	} else {
		*ind = 0;
	}
	if(*type==SQLT_RDD || *type==SQLT_RID){
		*len = 18;
		*ordata = malloc(*len);
		*type = SQLT_CHR;
		memcpy(*ordata,cldata.s.str.buf,*len);
	} else if(*type==SQLT_NUM || *type==SQLT_INT ||
		*type==SQLT_FLT || *type==SQLT_VNU || *type==SQLT_UIN){
		char* comma;

		sprintf(num,"%f",cldata.n.d);
		comma = strchr(num,',');
		if(comma)
			*comma = '.';
		*len = strlen(num);
		*ordata = malloc(*len+1);
		*type = SQLT_CHR;
		strcpy(*ordata,num);
	} else if(*type==SQLT_DAT || *type==SQLT_ODT){
		_clip_cdate(cldata.d.julian,&day,&mon,&year,&week);
		sprintf(num,"%2d-%s-%4d",day,month[mon-1],year);
		*len = strlen(num+1);
		*ordata = malloc(*len+1);
		*type = SQLT_CHR;
		strcpy(*ordata,num);
	} else if(*type==SQLT_LNG || *type==SQLT_LBI
		|| *type==SQLT_LVC || *type==SQLT_LVB){

		*len = cldata.s.str.len;
		*ordata = malloc(*len);
		memcpy(*ordata,cldata.s.str.buf,*len);
	} else if(*type==SQLT_CLOB || *type==SQLT_BLOB){
		CHECKENV(stmt->conn->env,ER_RDBMSERROR,-1,
			res = OCIDescriptorAlloc((dvoid*)stmt->conn->env,(dvoid**)&lob,
			OCI_DTYPE_LOB,0,NULL))
		if(*len==0){
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				res = OCIAttrSet((dvoid*)lob,OCI_DTYPE_LOB,&lobempty,0,
				OCI_ATTR_LOBEMPTY,stmt->conn->err))
		} else {
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCILobAssign(stmt->conn->env,stmt->conn->err,
				*(OCILobLocator**)cldata.s.str.buf,&lob))
			lob = *(OCILobLocator**)cldata.s.str.buf;
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCILobCharSetForm(stmt->conn->env,stmt->conn->err,lob,&csfrm))
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCILobCharSetId(stmt->conn->env,stmt->conn->err,lob,&csid))
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCILobTrim(stmt->conn->context,stmt->conn->err,lob,0));
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCILobGetChunkSize(stmt->conn->context,stmt->conn->err,
				lob,&chunksize))
			towrite = min(cldata.s.str.len-4,chunksize);
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCILobOpen(stmt->conn->context,stmt->conn->err,
				lob,OCI_LOB_READWRITE))
			while(wrote<cldata.s.str.len-4){
				OCILobWrite(stmt->conn->context,stmt->conn->err,lob,
					&towrite,1+wrote,cldata.s.str.buf+4+wrote,towrite,OCI_ONE_PIECE,
					NULL,NULL,csid,csfrm);
				wrote += chunksize;
				towrite = min(cldata.s.str.len-4-wrote,chunksize);
			}
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCILobClose(stmt->conn->context,stmt->conn->err,lob))
		}
		*len = sizeof(OCILobLocator*);
		*ordata = malloc(*len);
		*(OCILobLocator**)*ordata = lob;
	} else if(*type==SQLT_CHR || *type==SQLT_STR || *type==SQLT_VCS ||
		*type==SQLT_AFC || *type==SQLT_AVC || *type==SQLT_VST){

		*type = SQLT_CHR;
		*len = cldata.s.str.len;
		*ordata = malloc(*len);
		memcpy(*ordata,cldata.s.str.buf,*len);
	} else if(*type==SQLT_BIN || *type==SQLT_VBI){
		*type = SQLT_BIN;
		*len = cldata.s.str.len;
		*ordata = malloc(*len);
		memcpy(*ordata,cldata.s.str.buf,*len);
	} else {
		_clip_trap_err(mp,0,0,0,subsys,ER_TYPEMISMATCH,er_typemismatch);
		return -1;
	}
	return 0;
}

int or_createconn(ClipMachine* mp){
	OR_CONN* conn;
	OCIEnv* env;
	OCIServer* serv;
	OCISession* sess;
	OCISvcCtx* context;
	OCIError* err;
	char msg[256];
	char* login = _clip_parc(mp,4);
	char* passwd = _clip_parc(mp,5);
	char* db = _clip_parc(mp,6);

	CHECKENV(env,ER_CONNECT,-1,
		OCIEnvCreate(&env,OCI_DEFAULT,NULL,NULL,NULL,NULL,0,NULL))
	CHECKENV(env,ER_CONNECT,-1,
		OCIHandleAlloc((dvoid*)env,(dvoid**)&err,OCI_HTYPE_ERROR,0,NULL))
	CHECKENV(env,ER_CONNECT,-1,
		OCIHandleAlloc((dvoid*)env,(dvoid**)&serv,OCI_HTYPE_SERVER,0,NULL))
	CHECKERR(err,ER_CONNECT,-1,OCIServerAttach(serv,err,db,
		db?strlen(db):0,OCI_DEFAULT))
	CHECKENV(env,ER_CONNECT,-1,
		OCIHandleAlloc((dvoid*)env,(dvoid**)&context,OCI_HTYPE_SVCCTX,0,NULL))
	CHECKERR(err,ER_CONNECT,-1,
		OCIAttrSet((dvoid*)context,OCI_HTYPE_SVCCTX,
		(dvoid*)serv,0,OCI_ATTR_SERVER,err))
	CHECKENV(env,ER_CONNECT,-1,
		OCIHandleAlloc((dvoid*)env,(dvoid**)&sess,OCI_HTYPE_SESSION,0,NULL))
	CHECKERR(err,ER_CONNECT,-1,
		OCIAttrSet((dvoid*)sess,OCI_HTYPE_SESSION,(dvoid*)login,
		login?strlen(login):0,
		OCI_ATTR_USERNAME,err))
	CHECKERR(err,ER_CONNECT,-1,
		OCIAttrSet((dvoid*)sess,OCI_HTYPE_SESSION,(dvoid*)passwd,
		passwd?strlen(passwd):0,
		OCI_ATTR_PASSWORD,err))
	CHECKERR(err,ER_CONNECT,-1,
		OCISessionBegin(context,err,sess,OCI_CRED_RDBMS,OCI_DEFAULT))
	CHECKERR(err,ER_CONNECT,-1,
		OCIAttrSet((dvoid*)context,OCI_HTYPE_SVCCTX,(dvoid*)sess,0,
		OCI_ATTR_SESSION,err))

	conn = malloc(sizeof(OR_CONN));
	memset(conn,0,sizeof(OR_CONN));
	conn->env = env;
	conn->serv = serv;
	conn->sess = sess;
	conn->context = context;
	conn->err = err;
	conn->vtbl = &vtbl;

	return _clip_store_c_item(mp,(void*)conn,
		_C_ITEM_TYPE_SQL,destroy_or_conn);
}

void or_destroyconn(SQLCONN* conn){
	OCISessionEnd(((OR_CONN*)conn)->context,
		((OR_CONN*)conn)->err,((OR_CONN*)conn)->sess,OCI_DEFAULT);
	OCIServerDetach(((OR_CONN*)conn)->serv,((OR_CONN*)conn)->err,OCI_DEFAULT);
}

int or_prepare(ClipMachine* mp,SQLCONN* conn,char* sql){
	OR_STMT* stmt;
	char msg[256];
	char* iter = sql;
	char* pos;

	stmt = malloc(sizeof(OR_STMT));
	memset(stmt,0,sizeof(OR_STMT));
	stmt->stmt_item =
		_clip_store_c_item(mp,stmt,_C_ITEM_TYPE_SQL,destroy_or_stmt);

	stmt->sql = malloc(strlen(sql)+1);
	strcpy(stmt->sql,sql);

	while(*iter){
		*iter = (char)toupper((int)*iter);
		iter++;
	}
	if((pos=strstr(sql,":ROWID"))){
		iter = stmt->sql+(pos-sql);
		memcpy(iter,":ID___",6);
	}
	stmt->conn = (OR_CONN*)conn;
	stmt->next = ((OR_CONN*)conn)->stmts;
	((OR_CONN*)conn)->stmts = stmt;

	CHECKENV(((OR_CONN*)conn)->env,ER_RDBMSERROR,-1,
		OCIHandleAlloc((dvoid*)((OR_CONN*)conn)->env,
		(dvoid**)&stmt->stmt,OCI_HTYPE_STMT,0,NULL))
	CHECKERR(((OR_CONN*)conn)->err,ER_BADSTATEMENT,-1,
		OCIStmtPrepare(stmt->stmt,
		((OR_CONN*)conn)->err,stmt->sql,strlen(stmt->sql),OCI_NTV_SYNTAX,
		OCI_DEFAULT))

	return stmt->stmt_item;
}

static int or_bindpars(ClipMachine* mp,OR_STMT* stmt,dvoid*** ordata,sb2** ind,ClipVar* ap,int* isrowid,int* islong,int* longlen,int* longfield){
	char msg[256];
	int i;
	OCIBind* bind;
	ClipVar *tp,*pn,*pv,*pl;
	sb4 ordatalen;
	ub2 stmttype;

	if(ap && (ap->t.type == ARRAY_t) && (ap->a.count)){
		CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
			OCIAttrGet((dvoid*)stmt->stmt,OCI_HTYPE_STMT,(dvoid*)&stmttype,
			0,OCI_ATTR_STMT_TYPE,stmt->conn->err))
		if(isrowid) *isrowid = 0;
		if(islong) *islong = 0;
		*ordata = malloc(0);
		*ind = malloc(sizeof(sb2)*ap->a.count);
		for(i=0;i<ap->a.count;i++){
			*ordata = realloc(*ordata,sizeof(dvoid*)*(i+1));
			(*ordata)[i] = NULL;
			tp = _clip_vptr(&ap->a.items[i]);
			pn = _clip_vptr(&tp->a.items[0]);
			pv = _clip_vptr(&tp->a.items[1]);
			pl = _clip_vptr(&tp->a.items[2]);
			if(or_oracletype(&((*ordata)[i]),*pv,
				&pl->n.d,&ordatalen,stmt,mp,&(*ind)[i])){
				return -1;
			}
			if(strcasecmp(pn->s.str.buf,"rowid")==0){
				strcpy(pn->s.str.buf,"ID___");
				if(isrowid) *isrowid = 1;
				if(stmttype==OCI_STMT_INSERT) return 0;
			}
			if((stmttype==OCI_STMT_INSERT || stmttype==OCI_STMT_UPDATE) &&
				(pl->n.d==SQLT_LNG || pl->n.d==SQLT_LBI ||
				pl->n.d==SQLT_LVC || pl->n.d==SQLT_LVB)){
				if(islong) *islong = 1;
				if(longlen) *longlen = pv->s.str.len;
				if(longfield) *longfield = i;
				CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
					OCIBindByName(stmt->stmt,&bind,stmt->conn->err,
					pn->s.str.buf,strlen(pn->s.str.buf),
					NULL,*longlen,(ub2)pl->n.d,
					&(*ind)[i],NULL,NULL,0,NULL,OCI_DATA_AT_EXEC))
				continue;
			}
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCIBindByName(stmt->stmt,&bind,stmt->conn->err,
				pn->s.str.buf,strlen(pn->s.str.buf),
				(*ordata)[i],ordatalen,(ub2)pl->n.d,
				&(*ind)[i],NULL,NULL,0,NULL,OCI_DEFAULT))
		}
	}
	return 0;
}

static void or_freebinds(dvoid*** ordata,sb2** ind,int len){
	int i;
	if(*ordata){
		for(i=0;i<len;i++){
			if((*ordata)[i]){
				free((*ordata)[i]);
			}
		}
		free(*ordata);
	}
	if(*ind) free(*ind);
	if(lob){
		OCIDescriptorFree(lob,OCI_DTYPE_LOB);
		lob = NULL;
	}
}

int or_command(ClipMachine* mp,SQLSTMT* sqlstmt,ClipVar* ap){
	OR_STMT* stmt = (OR_STMT*)sqlstmt;
	dvoid** ordata = NULL;
	sb2* ind = NULL;
	char msg[256];
	ub2 stmttype;
	OCIBind* bind = NULL;
	int isrowid = 0;
	int islong = 0;
	sword res;
	int longlen;
	int longfield;
	ub4 type;
	ub1 in_out;
	ub4 iter;
	ub4 idx;
	ub1 piece;
	int longno;
	ub4 piecelen;
	ub4 rows;

	CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
		OCIAttrGet((dvoid*)stmt->stmt,OCI_HTYPE_STMT,(dvoid*)&stmttype,
		0,OCI_ATTR_STMT_TYPE,stmt->conn->err))
	if(stmttype==OCI_STMT_SELECT){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,er_badstatement);
		return -1;
	}

	if(or_bindpars(mp,stmt,&ordata,&ind,ap,&isrowid,&islong,&longlen,&longfield)==-1) return -1;
	if(stmttype==OCI_STMT_INSERT && isrowid){
		CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
			OCIBindByName(stmt->stmt,&bind,stmt->conn->err,
			"ID___",5,&gRowid,18,SQLT_CHR,
			NULL,NULL,NULL,0,0,OCI_DEFAULT))
	}
	if(islong){
		res = OCIStmtExecute(stmt->conn->context,stmt->stmt,
			stmt->conn->err,1,0,NULL,NULL,OCI_DEFAULT);
		longno = 0;
		while(res){
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCIStmtGetPieceInfo(stmt->stmt,stmt->conn->err,(dvoid**)&bind,&type,
				&in_out,&iter,&idx,&piece))
			piecelen = min(PIECEBUFLEN,longlen-PIECEBUFLEN*longno);
			piece = OCI_NEXT_PIECE;
			if(longno==0) piece = OCI_FIRST_PIECE;
			if(longlen-PIECEBUFLEN*(longno+1) <= 0){
				if(piece==OCI_FIRST_PIECE) piece = OCI_ONE_PIECE;
				else piece = OCI_LAST_PIECE;
			}
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCIStmtSetPieceInfo(bind,type,stmt->conn->err,
				(char*)ordata[longfield]+PIECEBUFLEN*longno,
				&piecelen,piece,NULL,NULL))
			res = OCIStmtExecute(stmt->conn->context,stmt->stmt,
				stmt->conn->err,1,0,NULL,NULL,OCI_DEFAULT);
			longno++;
		}
	} else {
		CHECKERR(stmt->conn->err,ER_BADSTATEMENT,-1,
			OCIStmtExecute(stmt->conn->context,stmt->stmt,
			stmt->conn->err,1,0,NULL,NULL,OCI_DEFAULT))
	}
	or_freebinds(&ordata,&ind,ap->a.count);
	CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
		OCIAttrGet((dvoid*)stmt->stmt,OCI_HTYPE_STMT,(dvoid*)&rows,
		0,OCI_ATTR_ROW_COUNT,stmt->conn->err))
	return rows;
}

char* or_testparser(ClipMachine* mp,char* sql,ClipVar* ap){
	return sql;
}

int or_createrowset(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* sqlstmt,ClipVar* ap,const char* idname,const char* gen_idSQL){
	OR_STMT* stmt = (OR_STMT*)sqlstmt;
	OR_ROWSET* rowset = (OR_ROWSET*)rs;
	int i;
	void** rec;
	char msg[256];
	ub2 stmttype;
	OCIParam* param;
	sword res;
	ub2 datatype;
	char* col_name;
	ub4 col_name_len;
	dvoid** ordata = NULL;
	ub2 datalen;
	ub2 dataprecision;
	sb1 datascale;
	sb2* inds = NULL;
	ub2* rlen = NULL;
	dvoid** defbuf;
	OCIDefine* define = NULL;
	sb2* indin = NULL;
	ub4 type;
	ub1 in_out;
	ub4 iter;
	ub4 idx;
	ub1 piece;
	ub4 piecelen;
	sb2 ind;
	int longlen;
	int longfield = -1;
	ub4 loblen;
	boolean inited = 0;
	ub4 chunksize;
	dvoid* chunk;
	ub4 offset;
	ub4 lobread;

	rowset->rowset_item =
		_clip_store_c_item(mp,rowset,_C_ITEM_TYPE_SQL,destroy_or_rowset);

	CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
		OCIAttrGet((dvoid*)stmt->stmt,OCI_HTYPE_STMT,(dvoid*)&stmttype,
		0,OCI_ATTR_STMT_TYPE,stmt->conn->err))
	if(stmttype!=OCI_STMT_SELECT){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSELECT,er_badselect);
		return 1;
	}

	if(or_bindpars(mp,stmt,&ordata,&indin,ap,NULL,NULL,NULL,NULL)==-1)
		return 1;
	CHECKERR(stmt->conn->err,ER_BADSELECT,1,
		OCIStmtExecute(stmt->conn->context,stmt->stmt,
		stmt->conn->err,0,0,NULL,NULL,OCI_DEFAULT))
	or_freebinds(&ordata,&indin,ap->a.count);

	rowset->fields = malloc(0*sizeof(SQLFIELD));

	rowset->id = -1;
	i = 0;
	CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
		res = OCIParamGet(stmt->stmt,OCI_HTYPE_STMT,stmt->conn->err,
		(dvoid**)&param,(ub4)i+1))
	while(res==OCI_SUCCESS){
		rowset->fields = realloc(rowset->fields,(i+1)*sizeof(SQLFIELD));
		CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
			OCIAttrGet((dvoid*)param,OCI_DTYPE_PARAM,
			(dvoid*)&datatype,0,OCI_ATTR_DATA_TYPE,
			stmt->conn->err))
		CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
			OCIAttrGet((dvoid*)param,OCI_DTYPE_PARAM,
			(dvoid*)&col_name,&col_name_len,OCI_ATTR_NAME,
			stmt->conn->err))
		CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
			OCIAttrGet((dvoid*)param,OCI_DTYPE_PARAM,
			(dvoid*)&dataprecision,0,OCI_ATTR_PRECISION,
			stmt->conn->err))
		CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
			OCIAttrGet((dvoid*)param,OCI_DTYPE_PARAM,
			(dvoid*)&datascale,0,OCI_ATTR_SCALE,
			stmt->conn->err))
		CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
			OCIAttrGet((dvoid*)param,OCI_DTYPE_PARAM,
			(dvoid*)&datalen,0,OCI_ATTR_DATA_SIZE,
			stmt->conn->err))

		strncpy(rowset->fields[i].name,col_name,MAXFIELDNAME);
		rowset->fields[i].name[min(MAXFIELDNAME,col_name_len)] = 0;
		rowset->fields[i].type = datatype;
		rowset->fields[i].unsign = 0;
		rowset->fields[i].notnull = 0;
		rowset->fields[i].binary = 0;
		if(datatype==SQLT_NUM || datatype==SQLT_INT || datatype==SQLT_FLT ||
			datatype==SQLT_UIN || datatype==SQLT_VNU){

			rowset->fields[i].len = dataprecision;
		} else {
			rowset->fields[i].len = datalen;
		}
		rowset->fields[i].dec = datascale;
		rowset->fields[i].ops = datalen;
		if(datatype==SQLT_RDD){
			rowset->id = i;
		}
		i++;
		res = OCIParamGet(stmt->stmt,OCI_HTYPE_STMT,stmt->conn->err,
			(dvoid**)&param,(ub4)i+1);
	}
	rowset->nfields = i;
	defbuf = malloc(sizeof(void*)*rowset->nfields);
	memset(defbuf,0,sizeof(void*)*rowset->nfields);
	inds = malloc(sizeof(sb2)*rowset->nfields);
	rlen = malloc(sizeof(ub2)*rowset->nfields);
	for(i=0;i<rowset->nfields;i++){
		if(rowset->fields[i].type==SQLT_NUM ||
			rowset->fields[i].type==SQLT_INT ||
			rowset->fields[i].type==SQLT_UIN ||
			rowset->fields[i].type==SQLT_FLT ||
			rowset->fields[i].type==SQLT_VNU){

			defbuf[i] = malloc(sizeof(double));
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
				OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,defbuf[i],
				sizeof(double),SQLT_FLT,(dvoid*)&(inds[i]),
				&rlen[i],NULL,OCI_DEFAULT))
		} else if(rowset->fields[i].type==SQLT_RDD ||
			rowset->fields[i].type==SQLT_RID){
			defbuf[i] = malloc(18);
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
				OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,defbuf[i],
				18,SQLT_CHR,(dvoid*)&inds[i],
				&rlen[i],NULL,OCI_DEFAULT))
		} else if(rowset->fields[i].type==SQLT_LNG ||
			rowset->fields[i].type==SQLT_LBI ||
			rowset->fields[i].type==SQLT_LVC ||
			rowset->fields[i].type==SQLT_LVB){
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
				OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,NULL,
				0x7fffffff,rowset->fields[i].type,(dvoid*)&inds[i],
				&rlen[i],NULL,OCI_DYNAMIC_FETCH))
			longfield = i;
		} else if(rowset->fields[i].type==SQLT_CLOB ||
			rowset->fields[i].type==SQLT_BLOB ||
			rowset->fields[i].type==SQLT_FILE){
			defbuf[i] = malloc(sizeof(OCILobLocator*));
			if(rowset->fields[i].type==SQLT_FILE){
				CHECKENV(stmt->conn->env,ER_RDBMSERROR,1,
					OCIDescriptorAlloc((dvoid*)stmt->conn->env,(dvoid**)defbuf[i],OCI_DTYPE_FILE,0,NULL))
			} else {
				CHECKENV(stmt->conn->env,ER_RDBMSERROR,1,
					OCIDescriptorAlloc((dvoid*)stmt->conn->env,(dvoid**)defbuf[i],OCI_DTYPE_LOB,0,NULL))
			}
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
				OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,defbuf[i],
				sizeof(OCILobLocator*),rowset->fields[i].type,(dvoid*)&inds[i],
				&rlen[i],NULL,OCI_DEFAULT))
		} else if(rowset->fields[i].type==SQLT_NTY ||
			rowset->fields[i].type==SQLT_REF){
			_clip_trap_err(mp,0,0,0,subsys,ER_TYPEMISMATCH,er_typemismatch);
			return 1;
		} else {
			defbuf[i] = malloc(rowset->fields[i].ops);
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
				OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,defbuf[i],
				rowset->fields[i].ops,rowset->fields[i].type,(dvoid*)&inds[i],
				&rlen[i],NULL,OCI_DEFAULT))
		}
	}
	rowset->lastrec = 0;
	rowset->data = malloc(0);
	res = OCIStmtFetch(stmt->stmt,stmt->conn->err,1,OCI_FETCH_NEXT,OCI_DEFAULT);
	while(res==OCI_SUCCESS || res==OCI_NEED_DATA){
		if(res==OCI_NEED_DATA && longfield!=-1){
			longlen = 0;
			defbuf[longfield] = malloc(0);
			while(res){
				CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
					OCIStmtGetPieceInfo(stmt->stmt,stmt->conn->err,(dvoid**)&define,&type,
					&in_out,&iter,&idx,&piece))
				piecelen = PIECEBUFLEN;
				defbuf[longfield] = realloc(defbuf[longfield],longlen+piecelen);
				CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
					OCIStmtSetPieceInfo(define,type,stmt->conn->err,
					(char*)defbuf[longfield]+longlen,
					&piecelen,piece,&ind,NULL))
				res = OCIStmtFetch(stmt->stmt,stmt->conn->err,1,OCI_FETCH_NEXT,OCI_DEFAULT);
				longlen += piecelen;
			}
		}
		rowset->lastrec++;
		rowset->data = realloc(rowset->data,sizeof(void*)*rowset->lastrec);
		rec = malloc(sizeof(void*)*rowset->nfields);
		for(i=0;i<rowset->nfields;i++){
			if(rowset->fields[i].type==SQLT_RDD ||
				rowset->fields[i].type==SQLT_RID){
				rec[i] = malloc(18+4);
				*((unsigned int*)(rec[i])) = 18;
				memcpy((char*)rec[i]+4,defbuf[i],18);
			} else if(rowset->fields[i].type==SQLT_CLOB ||
				rowset->fields[i].type==SQLT_BLOB ||
				rowset->fields[i].type==SQLT_FILE){

				CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
					OCILobLocatorIsInit(stmt->conn->env,stmt->conn->err,
					*(OCILobLocator**)defbuf[i],&inited))
				if(inited){
					if(rowset->fields[i].type==SQLT_FILE){
						CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
							OCILobFileOpen(stmt->conn->context,stmt->conn->err,
							*(OCILobLocator**)defbuf[i],OCI_FILE_READONLY))
					} else {
						CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
							OCILobOpen(stmt->conn->context,stmt->conn->err,
							*(OCILobLocator**)defbuf[i],OCI_LOB_READONLY))
					}
					CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
						OCILobGetChunkSize(stmt->conn->context,stmt->conn->err,
						*(OCILobLocator**)defbuf[i],&chunksize))
					CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
						OCILobGetLength(stmt->conn->context,stmt->conn->err,
						*(OCILobLocator**)defbuf[i],&loblen))
					rec[i] = malloc(loblen+8);
					*((unsigned int*)(rec[i])) = loblen;
					*((OCILobLocator**)((char*)rec[i]+4)) =
						*(OCILobLocator**)defbuf[i];
					if(loblen){
						chunk = malloc(chunksize);
						offset = 1;
						lobread = chunksize;
						do{
							res = OCILobRead(stmt->conn->context,stmt->conn->err,
								*(OCILobLocator**)defbuf[i],&lobread,offset,chunk,
								chunksize,NULL,NULL,0,0);
							memcpy((char*)rec[i]+8+offset-1,chunk,lobread);
							offset += lobread;
							lobread = min(chunksize,loblen-offset+1);
						} while(offset<loblen);
						free(chunk);
					}
					if(rowset->fields[i].type==SQLT_FILE){
						CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
							OCILobFileClose(stmt->conn->context,stmt->conn->err,
							*(OCILobLocator**)defbuf[i]))
					} else {
						CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
							OCILobClose(stmt->conn->context,stmt->conn->err,
							*(OCILobLocator**)defbuf[i]))
					}

					free(defbuf[i]);
					defbuf[i] = malloc(sizeof(OCILobLocator*));
					if(rowset->fields[i].type==SQLT_FILE){
						CHECKENV(stmt->conn->env,ER_RDBMSERROR,1,
							OCIDescriptorAlloc((dvoid*)stmt->conn->env,(dvoid**)defbuf[i],OCI_DTYPE_FILE,0,NULL))
					} else {
						CHECKENV(stmt->conn->env,ER_RDBMSERROR,1,
							OCIDescriptorAlloc((dvoid*)stmt->conn->env,(dvoid**)defbuf[i],OCI_DTYPE_LOB,0,NULL))
					}
					CHECKERR(stmt->conn->err,ER_RDBMSERROR,1,
						OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,defbuf[i],
						sizeof(OCILobLocator*),rowset->fields[i].type,(dvoid*)&inds[i],
						&rlen[i],NULL,OCI_DEFAULT))
				} else {
					rec[i] = NULL;
				}
			} else if(i==longfield){
				if(longlen){
					rec[i] = malloc(longlen+4);
					*((unsigned int*)(rec[i])) = longlen;
					memcpy(((char*)rec[i])+4,defbuf[i],longlen);
				} else {
					rec[i] = NULL;
				}
				free(defbuf[i]);
				defbuf[i] = NULL;
			} else {
				if(!inds[i]){
					rec[i] = malloc(rowset->fields[i].ops+4);
					*((unsigned int*)(rec[i])) = rlen[i];
					memcpy(((char*)rec[i])+4,defbuf[i],rowset->fields[i].ops);
				} else if(inds[i]==-1){
					rec[i] = NULL;
				}
			}
		}
		rowset->data[rowset->lastrec-1] = rec;
		res = OCIStmtFetch(stmt->stmt,stmt->conn->err,1,OCI_FETCH_NEXT,OCI_DEFAULT);
	}
	if(defbuf){
		for(i=0;i<rowset->nfields;i++){
			if(defbuf[i]){
				if(rowset->fields[i].type==SQLT_CLOB ||
					rowset->fields[i].type==SQLT_BLOB){
					CHECKENV(stmt->conn->env,ER_RDBMSERROR,1,
						OCIDescriptorFree(*(OCILobLocator**)defbuf[i],OCI_DTYPE_LOB))
				} else if(rowset->fields[i].type==SQLT_FILE){
					CHECKENV(stmt->conn->env,ER_RDBMSERROR,1,
						OCIDescriptorFree(*(OCILobLocator**)defbuf[i],OCI_DTYPE_FILE))
				}
				free(defbuf[i]);
			}
		}
		free(defbuf);
	}
	if(inds) free(inds);
	if(rlen) free(rlen);

	return 0;
}

int or_refresh(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap,const char* idname){
	OR_STMT* stmt = (OR_STMT*)s;
	OR_ROWSET* rowset = (OR_ROWSET*)rs;
	int i;
	void** rec;
	char msg[256];
	ub2 stmttype;
	sword res;
	dvoid** ordata = NULL;
	sb2* inds = NULL;
	ub2* rlen = NULL;
	dvoid** defbuf;
	OCIDefine* define = NULL;
	sb2* indin = NULL;
	ub4 type;
	ub1 in_out;
	ub4 iter;
	ub4 idx;
	ub1 piece;
	ub4 piecelen;
	sb2 ind;
	int longlen;
	int longfield = -1;
	ub4 loblen;
	boolean inited = 0;
	ub4 chunksize;
	dvoid* chunk;
	ub4 offset;
	ub4 lobread;

	CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
		OCIAttrGet((dvoid*)stmt->stmt,OCI_HTYPE_STMT,(dvoid*)&stmttype,
		0,OCI_ATTR_STMT_TYPE,stmt->conn->err))
	if(stmttype!=OCI_STMT_SELECT){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSELECT,er_badselect);
		return -1;
	}

	if(or_bindpars(mp,stmt,&ordata,&indin,ap,NULL,NULL,NULL,NULL)==-1)
		return -1;
	CHECKERR(stmt->conn->err,ER_BADSELECT,-1,
		OCIStmtExecute(stmt->conn->context,stmt->stmt,
		stmt->conn->err,0,0,NULL,NULL,OCI_DEFAULT))
	or_freebinds(&ordata,&indin,ap->a.count);

	defbuf = calloc(rowset->nfields,sizeof(void*));
	inds = malloc(sizeof(sb2)*rowset->nfields);
	rlen = malloc(sizeof(ub2)*rowset->nfields);
	for(i=0;i<rowset->nfields;i++){
		if(rowset->fields[i].type==SQLT_NUM ||
			rowset->fields[i].type==SQLT_INT ||
			rowset->fields[i].type==SQLT_UIN ||
			rowset->fields[i].type==SQLT_FLT ||
			rowset->fields[i].type==SQLT_VNU){

			defbuf[i] = malloc(sizeof(double));
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,defbuf[i],
				sizeof(double),SQLT_FLT,(dvoid*)&(inds[i]),
				&rlen[i],NULL,OCI_DEFAULT))
		} else if(rowset->fields[i].type==SQLT_RDD ||
			rowset->fields[i].type==SQLT_RID){
			defbuf[i] = malloc(18);
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,defbuf[i],
				18,SQLT_CHR,(dvoid*)&inds[i],
				&rlen[i],NULL,OCI_DEFAULT))
		} else if(rowset->fields[i].type==SQLT_LNG ||
			rowset->fields[i].type==SQLT_LBI ||
			rowset->fields[i].type==SQLT_LVC ||
			rowset->fields[i].type==SQLT_LVB){
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,NULL,
				0x7fffffff,rowset->fields[i].type,(dvoid*)&inds[i],
				&rlen[i],NULL,OCI_DYNAMIC_FETCH))
			longfield = i;
		} else if(rowset->fields[i].type==SQLT_CLOB ||
			rowset->fields[i].type==SQLT_BLOB ||
			rowset->fields[i].type==SQLT_FILE){
			defbuf[i] = malloc(sizeof(OCILobLocator*));
			if(rowset->fields[i].type==SQLT_FILE){
				CHECKENV(stmt->conn->env,ER_RDBMSERROR,-1,
					OCIDescriptorAlloc((dvoid*)stmt->conn->env,(dvoid**)defbuf[i],OCI_DTYPE_FILE,0,NULL))
			} else {
				CHECKENV(stmt->conn->env,ER_RDBMSERROR,-1,
					OCIDescriptorAlloc((dvoid*)stmt->conn->env,(dvoid**)defbuf[i],OCI_DTYPE_LOB,0,NULL))
			}
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,defbuf[i],
				sizeof(OCILobLocator*),rowset->fields[i].type,(dvoid*)&inds[i],
				&rlen[i],NULL,OCI_DEFAULT))
		} else if(rowset->fields[i].type==SQLT_NTY ||
			rowset->fields[i].type==SQLT_REF){
			_clip_trap_err(mp,0,0,0,subsys,ER_TYPEMISMATCH,er_typemismatch);
			return -1;
		} else {
			defbuf[i] = malloc(rowset->fields[i].ops);
			CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
				OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,defbuf[i],
				rowset->fields[i].ops,rowset->fields[i].type,(dvoid*)&inds[i],
				&rlen[i],NULL,OCI_DEFAULT))
		}
	}
	res = OCIStmtFetch(stmt->stmt,stmt->conn->err,1,OCI_FETCH_NEXT,OCI_DEFAULT);
	if(res == OCI_SUCCESS || res == OCI_NEED_DATA){
		if(res==OCI_NEED_DATA && longfield!=-1){
			longlen = 0;
			defbuf[longfield] = malloc(0);
			while(res){
				CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
					OCIStmtGetPieceInfo(stmt->stmt,stmt->conn->err,(dvoid**)&define,&type,
					&in_out,&iter,&idx,&piece))
				piecelen = PIECEBUFLEN;
				defbuf[longfield] = realloc(defbuf[longfield],longlen+piecelen);
				CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
					OCIStmtSetPieceInfo(define,type,stmt->conn->err,
					(char*)defbuf[longfield]+longlen,
					&piecelen,piece,&ind,NULL))
				res = OCIStmtFetch(stmt->stmt,stmt->conn->err,1,OCI_FETCH_NEXT,OCI_DEFAULT);
				longlen += piecelen;
			}
		}
		rec = malloc(sizeof(void*)*rowset->nfields);
		for(i=0;i<rowset->nfields;i++){
			if(rowset->fields[i].type==SQLT_RDD ||
				rowset->fields[i].type==SQLT_RID){
				rec[i] = malloc(18+4);
				*((unsigned int*)(rec[i])) = 18;
				memcpy((char*)rec[i]+4,defbuf[i],18);
			} else if(rowset->fields[i].type==SQLT_CLOB ||
				rowset->fields[i].type==SQLT_BLOB ||
				rowset->fields[i].type==SQLT_FILE){

				CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
					OCILobLocatorIsInit(stmt->conn->env,stmt->conn->err,
					*(OCILobLocator**)defbuf[i],&inited))
				if(inited){
					if(rowset->fields[i].type==SQLT_FILE){
						CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
							OCILobFileOpen(stmt->conn->context,stmt->conn->err,
							*(OCILobLocator**)defbuf[i],OCI_FILE_READONLY))
					} else {
						CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
							OCILobOpen(stmt->conn->context,stmt->conn->err,
							*(OCILobLocator**)defbuf[i],OCI_LOB_READONLY))
					}
					CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
						OCILobGetChunkSize(stmt->conn->context,stmt->conn->err,
						*(OCILobLocator**)defbuf[i],&chunksize))
					CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
						OCILobGetLength(stmt->conn->context,stmt->conn->err,
						*(OCILobLocator**)defbuf[i],&loblen))
					rec[i] = malloc(loblen+8);
					*((unsigned int*)(rec[i])) = loblen;
					*((OCILobLocator**)((char*)rec[i]+4)) =
						*(OCILobLocator**)defbuf[i];
					if(loblen){
						chunk = malloc(chunksize);
						offset = 1;
						lobread = chunksize;
						do{
							res = OCILobRead(stmt->conn->context,stmt->conn->err,
								*(OCILobLocator**)defbuf[i],&lobread,offset,chunk,
								chunksize,NULL,NULL,0,0);
							memcpy((char*)rec[i]+8+offset-1,chunk,lobread);
							offset += lobread;
							lobread = min(chunksize,loblen-offset+1);
						} while(offset<loblen);
						free(chunk);
					}
					if(rowset->fields[i].type==SQLT_FILE){
						CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
							OCILobFileClose(stmt->conn->context,stmt->conn->err,
							*(OCILobLocator**)defbuf[i]))
					} else {
						CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
							OCILobClose(stmt->conn->context,stmt->conn->err,
							*(OCILobLocator**)defbuf[i]))
					}

					free(defbuf[i]);
					defbuf[i] = malloc(sizeof(OCILobLocator*));
					if(rowset->fields[i].type==SQLT_FILE){
						CHECKENV(stmt->conn->env,ER_RDBMSERROR,-1,
							OCIDescriptorAlloc((dvoid*)stmt->conn->env,(dvoid**)defbuf[i],OCI_DTYPE_FILE,0,NULL))
					} else {
						CHECKENV(stmt->conn->env,ER_RDBMSERROR,-1,
							OCIDescriptorAlloc((dvoid*)stmt->conn->env,(dvoid**)defbuf[i],OCI_DTYPE_LOB,0,NULL))
					}
					CHECKERR(stmt->conn->err,ER_RDBMSERROR,-1,
						OCIDefineByPos(stmt->stmt,&define,stmt->conn->err,i+1,defbuf[i],
						sizeof(OCILobLocator*),rowset->fields[i].type,(dvoid*)&inds[i],
						&rlen[i],NULL,OCI_DEFAULT))
				} else {
					rec[i] = NULL;
				}
			} else if(i==longfield){
				if(longlen){
					rec[i] = malloc(longlen+4);
					*((unsigned int*)(rec[i])) = longlen;
					memcpy(((char*)rec[i])+4,defbuf[i],longlen);
				} else {
					rec[i] = NULL;
				}
				free(defbuf[i]);
				defbuf[i] = NULL;
			} else {
				if(!inds[i]){
					rec[i] = malloc(rowset->fields[i].ops+4);
					*((unsigned int*)(rec[i])) = rlen[i];
					memcpy(((char*)rec[i])+4,defbuf[i],rowset->fields[i].ops);
				} else if(inds[i]==-1){
					rec[i] = NULL;
				}
			}
		}
		for(i=0;i<rowset->nfields;i++)
			free(rowset->data[rowset->recno-1][i]);
		free(rowset->data[rowset->recno-1]);
		rowset->data[rowset->recno-1] = rec;
	} else {
		or_delete((SQLROWSET*)rowset);
		rowset->lastrec--;
		if(rowset->recno > rowset->lastrec)
			rowset->recno = rowset->lastrec;
	}
	if(defbuf){
		for(i=0;i<rowset->nfields;i++){
			if(defbuf[i]){
				if(rowset->fields[i].type==SQLT_CLOB ||
					rowset->fields[i].type==SQLT_BLOB){
					CHECKENV(stmt->conn->env,ER_RDBMSERROR,-1,
						OCIDescriptorFree(*(OCILobLocator**)defbuf[i],OCI_DTYPE_LOB))
				} else if(rowset->fields[i].type==SQLT_FILE){
					CHECKENV(stmt->conn->env,ER_RDBMSERROR,-1,
						OCIDescriptorFree(*(OCILobLocator**)defbuf[i],OCI_DTYPE_FILE))
				}
				free(defbuf[i]);
			}
		}
		free(defbuf);
	}
	if(inds) free(inds);
	if(rlen) free(rlen);

	return 0;
}

char* or_getvalue(SQLROWSET* rowset,int fieldno,int* len){
	if(((OR_ROWSET*)rowset)->data[((OR_ROWSET*)rowset)->recno-1][fieldno]){
		*len = *((int*)(((OR_ROWSET*)rowset)->data[
			((OR_ROWSET*)rowset)->recno-1][fieldno]));
		if(((OR_ROWSET*)rowset)->fields[fieldno].type==SQLT_CLOB ||
			((OR_ROWSET*)rowset)->fields[fieldno].type==SQLT_BLOB ||
			((OR_ROWSET*)rowset)->fields[fieldno].type==SQLT_FILE){
			return (char*)(((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno])+8;
		} else {
			return (char*)(((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno])+4;
		}
	}
	return NULL;
}

void or_setvalue(SQLROWSET* rowset,int fieldno,char* value,int len){
	if(((OR_ROWSET*)rowset)->fields[fieldno].type==SQLT_CLOB ||
		((OR_ROWSET*)rowset)->fields[fieldno].type==SQLT_BLOB){
		if(((OR_ROWSET*)rowset)->data[((OR_ROWSET*)rowset)->recno-1][fieldno]){
			((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno] =
				realloc(((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno],len+8);
		} else {
			((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno] = malloc(len+8);
			memset(((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno],0,8);
		}
		*((int*)(((OR_ROWSET*)rowset)->data[
			((OR_ROWSET*)rowset)->recno-1][fieldno])) = len;
		memcpy(((char*)(((OR_ROWSET*)rowset)->data[
			((OR_ROWSET*)rowset)->recno-1][fieldno]))+8,value,len);
	} else {
		if(((OR_ROWSET*)rowset)->data[((OR_ROWSET*)rowset)->recno-1][fieldno]){
			free(((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno]);
		}
		if(value){
			((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno] = malloc(len+4);
			*((int*)(((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno])) = len;
			memcpy(((char*)(((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno]))+4,value,len);
		} else {
			((OR_ROWSET*)rowset)->data[
				((OR_ROWSET*)rowset)->recno-1][fieldno] = NULL;
		}
	}
}

void or_append(SQLROWSET* rowset){
	void** row;
	int len;

	len = sizeof(void*)*((OR_ROWSET*)rowset)->nfields;

	((OR_ROWSET*)rowset)->lastrec++;
	((OR_ROWSET*)rowset)->data = realloc(((OR_ROWSET*)rowset)->data,
		sizeof(void*)*((OR_ROWSET*)rowset)->lastrec);
	row = malloc(len);
	memset(row,0,len);
	((OR_ROWSET*)rowset)->data[((OR_ROWSET*)rowset)->lastrec-1] = row;
}

void or_delete(SQLROWSET* rowset){
	int i;
	for(i=0;i<((OR_ROWSET*)rowset)->nfields;i++){
		if(((OR_ROWSET*)rowset)->data[((OR_ROWSET*)rowset)->recno-1][i]){
			free(((OR_ROWSET*)rowset)->data[((OR_ROWSET*)rowset)->recno-1][i]);
		}
	}
	free(((OR_ROWSET*)rowset)->data[((OR_ROWSET*)rowset)->recno-1]);
	for(i=((OR_ROWSET*)rowset)->recno;i<((OR_ROWSET*)rowset)->lastrec;i++){
		((OR_ROWSET*)rowset)->data[i-1]=((OR_ROWSET*)rowset)->data[i];
	}
	((OR_ROWSET*)rowset)->data = realloc(((OR_ROWSET*)rowset)->data,
		sizeof(void*)*(((OR_ROWSET*)rowset)->lastrec-1));
}

void or_newid(ClipMachine* mp,SQLSTMT* stmt){
	_clip_retcn(mp,gRowid,18);
}

int clip_OR_IN_DOUBLE(ClipMachine* mp){
	int len;
	double d = *(double*)_clip_parcl(mp,1,&len);
	int dec = _clip_parni(mp,2);

	_clip_retndp(mp,d,0,dec);
	return 0;
}

int clip_OR_IN_DATE(ClipMachine* mp){
	int len;
	unsigned char* d = _clip_parcl(mp,1,&len);
	int year = (int)(d[0]-100)*100+d[1]-100;
	int mon = d[2];
	int day = d[3];

	_clip_retdc(mp,year,mon,day);
	return 0;
}

int clip_OR_GETLOBLOC(ClipMachine* mp){
	OR_ROWSET* rowset = (OR_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int fieldno = _clip_parni(mp,2)-1;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(fieldno>=rowset->nfields || fieldno<0){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOFIELD,er_nofield);
		return 1;
	}
	if(rowset->recno==0 || (rowset->fields[fieldno].type!=SQLT_CLOB &&
		rowset->fields[fieldno].type!=SQLT_BLOB)){
		return 0;
	}
	_clip_retcn(mp,(char*)rowset->data[rowset->recno-1][fieldno]+4,4);
	return 0;
}
