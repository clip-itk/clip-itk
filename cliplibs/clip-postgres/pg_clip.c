#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/timeb.h>
#include "libpq-fe.h"
#include "clip.h"
#include "postgres.ch"
#include "dbfsql.h"
#include "error.ch"

#define INV_WRITE               0x00020000
#define INV_READ                0x00040000


static const char subsys[]          = "DBFSQL";
static const char er_nosql[]        = "No SQL statement";
static const char er_nostatement[]  = "No statement. PG_PREPARE must be executed first";
static const char er_norowset[]     = "No such rowset";
static const char er_badorders[]    = "Bad orders";
static const char er_start[]        = "Can't start transaction";
static const char er_commit[]       = "Can't commit transaction";
static const char er_rollback[]     = "Can't roll transaction back";

static const char er_blob_create[]	= "Can't create Large Object";
static const char er_blob_open[]        = "Can't open Large Object";
static const char er_blob_import[]      = "Can't import Large Object";
static const char er_blob_export[]	= "Can't export Large Object";
static const char er_blob_write[]	= "Can't write Large Object";
static const char er_blob_read[]	= "Can't read Large Object";
static const char er_blob_seek[]	= "Can't seek Large Object";
static const char er_blob_tell[]	= "Can't tell Large Object";
static const char er_blob_close[]	= "Can't close Large Object";
static const char er_blob_unlink[]	= "Can't unlink Large Object";


int pg_createconn(ClipMachine* mp);

struct tagPG_CONN;

typedef struct tagPG_STMT {
	int stmt_item;
	struct tagPG_CONN* conn;
	char* sql;
	PGresult* res;
} PG_STMT;

// Rowset abstract structure
typedef struct tagPG_ROWSET {
	int rowset_item;
	struct tagPG_CONN* conn;
	struct tagPG_STMT* stmt;
	int recno;
	int lastrec;
	int loaded;
	int unknownrows;
	int done;
	int bof;
	int eof;
	int nfields;
	SQLFIELD* fields;
	int id;
	int nids;
	int* ids;
	HashTable* orders;
	long* taghashes;
	int ntags;
	BTREE* bt;
	SQLORDER* curord;
	int hot;
	int newrec;
	int binary;
	void*** data;
} PG_ROWSET;

// Connection abstract structure
typedef struct tagPG_CONN {
	SQLVTBL* vtbl;
	SQLLocale* loc;
	int at;
	PGconn* conn;
} PG_CONN;

void pg_destroyconn(SQLCONN* conn);
int pg_prepare(ClipMachine* mp,SQLCONN* conn,char* sql);
int pg_command(ClipMachine* mp,SQLSTMT* stmt,ClipVar* ap);
int pg_createrowset(ClipMachine* mp,SQLROWSET* rs,ClipVar* ap,ClipVar* idname,const char* gen_idSQL);
char* pg_testparser(ClipMachine* mp,char* sql,ClipVar* ap);
char* pg_getvalue(SQLROWSET* rowset,int fieldno,int* len);
void pg_setvalue(SQLROWSET* rowset,int fieldno,char* value,int len);
void pg_append(SQLROWSET* rowset);
void pg_delete(SQLROWSET* rowset);
void pg_newid(ClipMachine* mp,SQLSTMT* stmt);
int pg_refresh(ClipMachine* mp,SQLROWSET* rowset,SQLSTMT* stmt,ClipVar* ap);
int pg_start(ClipMachine* mp,SQLCONN* conn,const char* p1,const char* p2);
int pg_commit(ClipMachine* mp,SQLCONN* conn);
int pg_rollback(ClipMachine* mp,SQLCONN* conn);
int pg_fetch(ClipMachine* mp,SQLROWSET* rs,int recs,ClipVar* eval,int every,ClipVar* ors);

int pg_lo_create(ClipMachine* mp, SQLCONN* c, unsigned int OID);
int pg_lo_open(ClipMachine* mp, SQLCONN* c, unsigned int OID, int mode);
int pg_lo_import(ClipMachine* mp, SQLCONN* c, const char *filename);
int pg_lo_export(ClipMachine* mp, SQLCONN* c, unsigned int OID, const char *filename);
int pg_lo_write(ClipMachine* mp, SQLCONN* c, int oid_fd, const char *buffer, int length);
int pg_lo_read(ClipMachine* mp, SQLCONN* c, int oid_fd, char *buffer, int length);
int pg_lo_seek(ClipMachine* mp, SQLCONN* c, int oid_fd, int offset, int whence);
int pg_lo_tell(ClipMachine* mp, SQLCONN* c, int oid_fd);
int pg_lo_close(ClipMachine* mp, SQLCONN* c, int oid_fd);
int pg_lo_unlink(ClipMachine* mp, SQLCONN* c, unsigned int OID);



static SQLVTBL vtbl = {
	sizeof(PG_ROWSET),
	pg_destroyconn,
	pg_prepare,
	pg_command,
	pg_createrowset,
	pg_testparser,
	pg_getvalue,
	pg_setvalue,
	pg_append,
	pg_delete,
	pg_newid,
	pg_refresh,
	NULL,
	pg_start,
	pg_commit,
	pg_rollback,
	pg_fetch,
	pg_lo_create,
	pg_lo_import,
	pg_lo_export,
	pg_lo_open,
	pg_lo_write,
	pg_lo_read,
	pg_lo_seek,
	pg_lo_tell,
	pg_lo_close,
	pg_lo_unlink
};

int clip_INIT_POSTGRES(ClipMachine* mp){
	(*mp->nsqldrivers)++;
	*mp->sqldrivers = realloc(*mp->sqldrivers,sizeof(SQLDriver)*(*mp->nsqldrivers));
	strcpy((*mp->sqldrivers)[*mp->nsqldrivers-1].id,"PG");
	strcpy((*mp->sqldrivers)[*mp->nsqldrivers-1].name,"PostgreSQL");
	strcpy((*mp->sqldrivers)[*mp->nsqldrivers-1].desc,
		"Generic PostgreSQL for CLIP driver v.1.0");
	(*mp->sqldrivers)[*mp->nsqldrivers-1].connect = pg_createconn;
	return 0;
}

static void destroy_pg_stmt(void* s){
	PG_STMT* stmt = (PG_STMT*)s;
	if(stmt){
		if(stmt->res){
			PQclear(stmt->res);
		}
		if(stmt->sql){
			free(stmt->sql);
		}
		free(stmt);
	}
}

// Helper function used by _clip_destroy_c_item to release rowset.
static void destroy_pg_rowset(void* rs){
	PG_ROWSET* rowset = (PG_ROWSET*)rs;
	int i,j;

	if(rowset){
		if(rowset->fields){
			free(rowset->fields);
		}
		if(rowset->data){
			for(i=0;i<rowset->loaded;i++){
				if(rowset->data[i]){
					for(j=0;j<rowset->nfields;j++){
						if(rowset->data[i][j]){
							free(rowset->data[i][j]);
						}
					}
					free(rowset->data[i]);
				}
			}
			free(rowset->data);
		}
		free(rowset);
	}
	return;
}

// Helper function used by _clip_destroy_c_item to release connect.
static void destroy_pg_conn(void* conn){
	free(conn);
	return;
}

void pg_bindpars(PG_STMT* stmt,ClipVar* ap){
	char* sql = stmt->sql;
	int initlen = strlen(sql);
	int len = initlen;
	int i;
	ClipVar *tp,*vp = 0;
	char parnamebuf[MAXFIELDNAME+2] = ":";
	char* parname = parnamebuf+1;
	char* b;
	char* e;
	char* t;
	char* res;
	const char delims[] = " ,;)'\"";

	if(!sql) return;

	if (!ap || ap->t.type != ARRAY_t) return;
	ap = _clip_vptr(ap);
	for(i=0;i<ap->a.count;i++){
		if(!&ap->a.items[i]
			|| (ap->a.items[i].t.type != ARRAY_t)) return;
		tp = _clip_vptr(&ap->a.items[i]);
		vp = _clip_vptr(&tp->a.items[1]);
		tp = _clip_vptr(&tp->a.items[0]);
		strcpy(parname,tp->s.str.buf);
		b = sql;
		while((b = strstr(b,parnamebuf))){
			if(!(strchr(delims,*(b+tp->s.str.len+1)) || !(*(b+tp->s.str.len+1)))){
				b++;
				continue;
			}
			e = strpbrk(b,delims);
			if(e){
				if(e-b==strlen(parnamebuf)){
					len += (vp->t.type==CHARACTER_t)?strlen(vp->s.str.buf):4 - (e - b);
				}
			} else {
				len += (vp->t.type==CHARACTER_t)?strlen(vp->s.str.buf):4 - (initlen - (b-sql));
			}
			b++;
		}
	}
	t = res = malloc(len+1);
	b = sql;
	while((e = strchr(b,':'))){
		memcpy(t,b,e-b);
		t += e-b;
		b = strpbrk(e,delims);
		if(!b)
			b = e+strlen(e);
		for(i=0;i<ap->a.count;i++){
			tp = _clip_vptr(&ap->a.items[i]);
			vp = _clip_vptr(&tp->a.items[1]);
			tp = _clip_vptr(&tp->a.items[0]);
			if(vp->t.type == CHARACTER_t){
				if(strncmp(e+1,tp->s.str.buf,b-e-1)==0){
					if(b-e-1==strlen(tp->s.str.buf)) break;
				}
			}
		}
		if(i == ap->a.count){
			strcpy(t,"null");
			t += 4;
		} else {
			strcpy(t,vp->s.str.buf);
			t += strlen(vp->s.str.buf);
		}
	}
	if(t!=&res[len] && b){
		strcpy(t,b);
		t += strlen(b);
	}
	res[len] = 0;
	free(sql);
	stmt->sql = res;
	return;
}

int pg_createconn(ClipMachine* mp){
	char* pghost	= _clip_parc(mp,2);
	char* pgport	= _clip_parc(mp,3);
	char* login		= _clip_parc(mp,4);
	char* pwd		= _clip_parc(mp,5);
	char* dbName	= _clip_parc(mp,6);
	char* pgtty		= _clip_parc(mp,7);
	char* pgoptions = _clip_parc(mp,8);
	char* trpars	= _clip_parc(mp,10);
	PGconn* tmpconn;
	PGresult* res;
	PG_CONN* conn;
	char str[256];

	tmpconn = PQsetdbLogin(pghost,pgport,pgoptions,pgtty,dbName,login,pwd);
	if(PQstatus(tmpconn)!=CONNECTION_OK){
		_clip_trap_err(mp,0,0,0,subsys,ER_CONNECT,PQerrorMessage(tmpconn));
		return -1;
	}
	conn = malloc(sizeof(PG_CONN));
	memset(conn,0,sizeof(PG_CONN));
	conn->conn = tmpconn;
	conn->vtbl = &vtbl;
	res = PQexec(tmpconn,"SET DATESTYLE='ISO'");
	if(PQresultStatus(res) != PGRES_COMMAND_OK){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,
			PQresultErrorMessage(res));
		return -1;
	}

	if(!trpars)
		trpars = _clip_fetch_item(mp, _clip_hashstr("PG_ISOLATION_LEVEL"));
	if(!trpars)
		trpars = _clip_fetch_item(mp, _clip_hashstr("SQL_ISOLATION_LEVEL"));
	if(trpars){
		snprintf(str,sizeof(str),"set session characteristics as transaction isolation level %s",trpars);
		res = PQexec(tmpconn,str);
		if(PQresultStatus(res) != PGRES_COMMAND_OK){
			_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,
				PQresultErrorMessage(res));
			return -1;
		}
	}


	return _clip_store_c_item(mp,(void*)conn,_C_ITEM_TYPE_SQL,destroy_pg_conn);
}

void pg_destroyconn(SQLCONN* conn){
	PQfinish(((PG_CONN*)conn)->conn);
}

int pg_prepare(ClipMachine* mp,SQLCONN* conn,char* sql){
	PG_STMT* stmt;

	stmt = malloc(sizeof(PG_STMT));
	memset(stmt,0,sizeof(PG_STMT));
	stmt->stmt_item =
		_clip_store_c_item(mp,stmt,_C_ITEM_TYPE_SQL,destroy_pg_stmt);

	stmt->sql = malloc(strlen(sql)+1);
	strcpy(stmt->sql,sql);

	stmt->conn = (PG_CONN*)conn;

	return stmt->stmt_item;
}

int pg_command(ClipMachine* mp,SQLSTMT* stmt,ClipVar* ap){
	int status;
	const char* tups;

	pg_bindpars((PG_STMT*)stmt,ap);
	((PG_STMT*)stmt)->res = PQexec(((PG_STMT*)stmt)->conn->conn,
		((PG_STMT*)stmt)->sql);
	status = PQresultStatus(((PG_STMT*)stmt)->res);

	if(status != PGRES_COMMAND_OK){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,
			PQresultErrorMessage(((PG_STMT*)stmt)->res));
		return -1;
	}
	tups = PQcmdTuples(((PG_STMT*)stmt)->res);
	return atoi(tups);
}

char* pg_testparser(ClipMachine* mp,char* sql,ClipVar* ap){
	PG_STMT stmt;

	stmt.sql = sql;
	pg_bindpars(&stmt,ap);
	return stmt.sql;
}

static char _pg_ctype(int type){
	switch(type){
		case PGT_INT4:
		case PGT_CID:
		case PGT_OID:
		case PGT_XID:
		case PGT_INT2:
		case PGT_MONEY:
		case PGT_INT8:
		case PGT_FLOAT4:
		case PGT_FLOAT8:
		case PGT_NUMERIC:
		case PGT_RELTIME:
		case PGT_TIMESPAN:
			return 'N';

		case PGT_VARCHAR:
		case PGT_TEXT:
		case PGT_BPCHAR:
		case PGT_BYTEA:
		case PGT_NAME:
		case PGT_FILENAME:
		case PGT_ABSTIME:
			return 'C';

		case PGT_DATE:
		case PGT_TIMESTAMP:
			return 'D';

		case PGT_BOOL:
			return 'L';

		case PGT_DATETIME:
			return 'T';

		case PGT_BOX:
		case PGT_LSEG:
		case PGT_CIDR:
		case PGT_CIRCLE:
		case PGT_INET:
		case PGT_INT28:
		case PGT_OID8:
		case PGT_PATH:
		case PGT_POINT:
		case PGT_POLYGON:
		case PGT_TIME:
			return 'A';
	}
	return 'U';
}

int pg_createrowset(ClipMachine* mp,SQLROWSET* rs,ClipVar* ap,ClipVar* idname,const char* gen_idSQL){
	PG_ROWSET* rowset = (PG_ROWSET*)rs;
	PG_STMT* stmt = rowset->stmt;
	PG_CONN* conn = rowset->conn;
	int i,mod;

	pg_bindpars(stmt,ap);
	if(!stmt->sql){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOSQL,er_nosql);
		return 1;
	}

	stmt->res = PQexec(conn->conn,stmt->sql);
	if(!stmt->res){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,
			PQresultErrorMessage(stmt->res));
		return 1;
	}
	if(PQresultStatus(stmt->res)!=PGRES_TUPLES_OK){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSELECT,
			PQresultErrorMessage(stmt->res));
		return 1;
	}

	rowset->rowset_item =
		_clip_store_c_item(mp,rowset,_C_ITEM_TYPE_SQL,destroy_pg_rowset);

	rowset->binary = PQbinaryTuples(stmt->res);
	rowset->nfields = PQnfields(stmt->res);
	rowset->fields = calloc(1,rowset->nfields*sizeof(SQLFIELD));
	rowset->id = -1;
	for(i=0;i<rowset->nfields;i++){
		strncpy(rowset->fields[i].name,PQfname(stmt->res,i),
			MAXFIELDNAME);
		rowset->fields[i].name[MAXFIELDNAME] = 0;
		rowset->fields[i].type = PQftype(stmt->res,i);
		rowset->fields[i].ctype[0] = _pg_ctype(rowset->fields[i].type);
		rowset->fields[i].dec = 0;
		mod = PQfmod(stmt->res,i);
		switch(rowset->fields[i].type){
			case PGT_VARCHAR:
				rowset->fields[i].len = mod-4;
				break;
			case PGT_NUMERIC:
				rowset->fields[i].len = (mod >> 16);
				rowset->fields[i].dec = (mod & 0xffff)-4;
				break;
			default:
				rowset->fields[i].len = PQfsize(stmt->res,i);
				break;
		}
		rowset->fields[i].ops = 0;
		if(idname && idname->t.type == CHARACTER_t && idname->s.str.buf){
			if(!strcasecmp(rowset->fields[i].name,idname->s.str.buf)){
				rowset->id = i;
			}
		} else if(rowset->fields[i].type == PGT_OID){
			rowset->id = i;
		}
	}

	rowset->lastrec = PQntuples(stmt->res);
	rowset->data = calloc(rowset->lastrec,sizeof(void*));
	return 0;
}

int pg_refresh(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap){
	PG_ROWSET* rowset = (PG_ROWSET*)rs;
	PG_STMT* stmt = (PG_STMT*)s;
	int i,j,len;
	void** rec;

	pg_bindpars(stmt,ap);

	if(!stmt->sql){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOSQL,er_nosql);
		return -1;
	}

	stmt->res = PQexec(stmt->conn->conn,stmt->sql);
	if(!stmt->res){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,
			PQresultErrorMessage(stmt->res));
		return -1;
	}
	if(PQresultStatus(stmt->res)!=PGRES_TUPLES_OK){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSELECT,
			PQresultErrorMessage(stmt->res));
		return -1;
	}
	if(PQntuples(stmt->res)>0){
		rec = malloc(sizeof(void*)*rowset->nfields);
		for(j=0;j<rowset->nfields;j++){
			if(!PQgetisnull(stmt->res,0,j)){
				len = PQgetlength(stmt->res,0,j);
				if(rowset->binary){
					rec[j] = malloc(len+4);
					*((int*)(rec[j])) = len;
					memcpy(((char*)rec[j])+4,PQgetvalue(stmt->res,0,j),len);
				} else {
					rec[j] = malloc(len+1);
					memcpy(rec[j],PQgetvalue(stmt->res,0,j),len);
					((char*)(rec[j]))[len] = 0;
				}
			} else {
				rec[j] = NULL;
			}
		}
		for(i=0;i<rowset->nfields;i++)
			free(rowset->data[rowset->recno-1][i]);
		free(rowset->data[rowset->recno-1]);
		rowset->data[rowset->recno-1] = rec;
	} else {
		pg_delete((SQLROWSET*)rowset);
		rowset->lastrec--;
		if(rowset->recno > rowset->lastrec)
			rowset->recno = rowset->lastrec;
	}
	return 0;
}

char* pg_getvalue(SQLROWSET* rowset,int fieldno,int* len){
	if(((PG_ROWSET*)rowset)->data[((PG_ROWSET*)rowset)->recno-1][fieldno]){
		if(!((PG_ROWSET*)rowset)->binary){
			*len = strlen((char*)((PG_ROWSET*)rowset)->data[
				((PG_ROWSET*)rowset)->recno-1][fieldno]);
			return (char*)((PG_ROWSET*)rowset)->data[
				((PG_ROWSET*)rowset)->recno-1][fieldno];
		} else {
			*len = *((int*)(((PG_ROWSET*)rowset)->data[
				((PG_ROWSET*)rowset)->recno-1][fieldno]));
			return (char*)(((PG_ROWSET*)rowset)->data[
				((PG_ROWSET*)rowset)->recno-1][fieldno])+4;
		}
	}
	return NULL;
}

void pg_setvalue(SQLROWSET* rowset,int fieldno,char* value,int len){
	if(((PG_ROWSET*)rowset)->data[((PG_ROWSET*)rowset)->recno-1][fieldno]){
		free(((PG_ROWSET*)rowset)->data[
			((PG_ROWSET*)rowset)->recno-1][fieldno]);
	}
	if(value){
		if(((PG_ROWSET*)rowset)->binary){
			((PG_ROWSET*)rowset)->data[
				((PG_ROWSET*)rowset)->recno-1][fieldno] = malloc(len+4);
			*((int*)(((PG_ROWSET*)rowset)->data[
				((PG_ROWSET*)rowset)->recno-1][fieldno])) = len;
			memcpy(((char*)(((PG_ROWSET*)rowset)->data[
				((PG_ROWSET*)rowset)->recno-1][fieldno]))+4,value,len);
		} else {
			((PG_ROWSET*)rowset)->data[
				((PG_ROWSET*)rowset)->recno-1][fieldno] = malloc(len+1);
			memcpy(((PG_ROWSET*)rowset)->data[
				((PG_ROWSET*)rowset)->recno-1][fieldno],value,len);
			((char*)(((PG_ROWSET*)rowset)->data[
				((PG_ROWSET*)rowset)->recno-1][fieldno]))[len] = 0;
		}
	} else {
		((PG_ROWSET*)rowset)->data[
			((PG_ROWSET*)rowset)->recno-1][fieldno] = NULL;
	}
}

void pg_append(SQLROWSET* rowset){
	void** row;
	int len;

	len = sizeof(void*)*((PG_ROWSET*)rowset)->nfields;

	((PG_ROWSET*)rowset)->lastrec++;
	((PG_ROWSET*)rowset)->loaded++;
	((PG_ROWSET*)rowset)->data = realloc(((PG_ROWSET*)rowset)->data,
		sizeof(void*)*((PG_ROWSET*)rowset)->lastrec);
	row = malloc(len);
	memset(row,0,len);
	((PG_ROWSET*)rowset)->data[((PG_ROWSET*)rowset)->lastrec-1] = row;
}

void pg_delete(SQLROWSET* rowset){
	int i;

	for(i=0;i<((PG_ROWSET*)rowset)->nfields;i++){
		if(((PG_ROWSET*)rowset)->data[((PG_ROWSET*)rowset)->recno-1][i]){
			free(((PG_ROWSET*)rowset)->data[((PG_ROWSET*)rowset)->recno-1][i]);
		}
	}
	free(((PG_ROWSET*)rowset)->data[((PG_ROWSET*)rowset)->recno-1]);
	for(i=((PG_ROWSET*)rowset)->recno;i<((PG_ROWSET*)rowset)->lastrec;i++){
		((PG_ROWSET*)rowset)->data[i-1]=((PG_ROWSET*)rowset)->data[i];
	}
	((PG_ROWSET*)rowset)->data = realloc(((PG_ROWSET*)rowset)->data,
		sizeof(void*)*(((PG_ROWSET*)rowset)->lastrec-1));
}

void pg_newid(ClipMachine* mp,SQLSTMT* stmt){
	char* oidstr = (char*)PQoidStatus(((PG_STMT*)stmt)->res);

	if(oidstr){
		_clip_retni(mp,atoi(oidstr));
	}
}

int clip_PG_ISBINARY(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	_clip_retl(mp,rowset->binary);
	return 0;
}

int clip_PG_IN_INT4(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	char* str;
	int len;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->binary){
		str = _clip_parcl(mp,2,&len);
		if(str){
			_clip_retni(mp,*((int*)str));
		}
	} else {
		str = _clip_parc(mp,2);
		if(str){
			_clip_retndp(mp,(double)atoi(str),strlen(str),0);
		}
	}
	return 0;
}

int clip_PG_IN_INT2(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	char* str;
	int len;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->binary){
		str = _clip_parcl(mp,2,&len);
		if(str){
			_clip_retni(mp,*((short int*)str));
		}
	} else {
		str = _clip_parc(mp,2);
		if(str){
			_clip_retni(mp,atoi(str));
		}
	}
	return 0;
}

int clip_PG_IN_INT8(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	char* str;
	int len;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->binary){
		str = _clip_parcl(mp,2,&len);
		if(str){
			_clip_retnd(mp,(double)*((long long*)str));
		}
	} else {
		str = _clip_parc(mp,2);
		if(str){
			_clip_retnd(mp,strtod(str,NULL));
		}
	}
	return 0;
}

int clip_PG_IN_FLOAT(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int dec = _clip_parni(mp,3);
	char* str;
	int len;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->binary){
		str = _clip_parcl(mp,2,&len);
		if(str){
			_clip_retndp(mp,*((float*)str),0,dec);
		}
	} else {
		str = _clip_parc(mp,2);
		if(str){
			_clip_retndp(mp,_clip_strtod(str,&len),0,dec);
		}
	}
	return 0;
}

int clip_PG_IN_DOUBLE(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int dec = _clip_parni(mp,3);
	char* str;
	int len;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->binary){
		str = _clip_parcl(mp,2,&len);
		if(str){
			_clip_retndp(mp,*((double*)str),0,dec);
		}
	} else {
		str = _clip_parc(mp,2);
		if(str){
			_clip_retndp(mp,_clip_strtod(str,&len),0,dec);
		}
	}
	return 0;
}

int clip_PG_IN_ABSTIME(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	char* date;
	int len;
	struct tm* time;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->binary){
		date = _clip_parcl(mp,2,&len);
		time = gmtime((time_t*)date);
		_clip_retdc(mp,time->tm_year+1900,time->tm_mon+1,time->tm_mday);
	} else {
		date = _clip_parc(mp,2);
//		_pg_in_date(mp,rowset->conn->datestyle,rowset->conn->textdate,date);
	}
	return 0;
}

int clip_PG_IN_TIMESTAMP(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	char* date;
	int len;
	struct tm* time;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->binary){
		date = _clip_parcl(mp,2,&len);
		if(date){
			time = gmtime((time_t*)date);
			_clip_retdc(mp,time->tm_year+1900,time->tm_mon+1,time->tm_mday);
		}
	} else {
		date = _clip_parc(mp,2);
		if(date){
//			_pg_in_date(mp,rowset->conn->datestyle,rowset->conn->textdate,date);
		}
	}
	return 0;
}

int clip_PG_IN_DATE(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	char* date;
	int len;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->binary){
		date = _clip_parcl(mp,2,&len);
		if(date){
			_clip_retdj(mp,*((int*)date)+2451545);	// 2451545 - julian date
		}											// for 01/01/2000
	} else {
		int m,d,y;
		date = _clip_parc(mp,2);
		if(date){
			y = atoi(date);
			m = atoi(date+5);
			d = atoi(date+8);
			_clip_retdc(mp,y,m,d);
		} else {
			_clip_retdj(mp,0);
		}
	}
	return 0;
}

void _pg_in_iso_datetime(char* date,int l,long* ddd,long* ttt){
	int m,d,y;
	long dd,tt;
	int z;
	if(date){
		y = atoi(date);
		m = atoi(date+5);
		d = atoi(date+8);
		dd = _clip_jdate(d,m,y);

		tt = atoi(date+11)*60*60*1000;
		tt += atoi(date+14)*60*1000;
		tt += atoi(date+17)*1000;
		if(date[19]=='.'){
			tt += atoi(date+20)*10;
			date += 3;
		}

		z = atoi(date+20);
		if(z > 12){ /* +0930 f.e. */
			z = (z/100)*60*60*1000 + (z%100)*60*1000;
		} else {
			z = z*60*60*1000;
		}
		if(date[19]=='+')
			tt -= z;
		else
			tt += z;
		if(tt < 0){
			dd--;
			tt += 24*60*60*1000;
		} else if(tt >= 24*60*60*1000){
			dd++;
			tt -= 24*60*60*1000;
		}
		*ddd = dd;
		*ttt = tt;
	} else {
		*ddd = 0;
		*ttt = 0;
	}
}

int clip_PG_IN_DATETIME(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	char* date;
	long dd,tt;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if(rowset->binary){
		double d;
		int l;

		date = _clip_parcl(mp,2,&l);
		d = *(double*)date;
		dd = _clip_jdate(1,1,2000)+d/(24*60*60);
		tt = ((long long)d*1000) % (24*60*60*1000);
		if(tt < 0)
			tt += 24*60*60*1000;
		_clip_retdtj(mp,dd,tt);
	} else {
		int l;
		date = _clip_parcl(mp,2,&l);
		_pg_in_iso_datetime(date,l,&dd,&tt);
		_clip_retdtj(mp,dd,tt);
	}
	return 0;
}

int clip_PG_OUT_ABSTIME(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int totext = _clip_parl(mp,3);
	struct tm time;
	time_t date;

	memset(&time,0,sizeof(time));
	_clip_pardc(mp,2,&time.tm_year,&time.tm_mon,&time.tm_mday,&time.tm_wday);
	time.tm_year -= 1900;
	time.tm_mon--;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if((!totext)&&rowset->binary){
		date = mktime(&time);
		_clip_retcn(mp,(char*)(&date),4);
	} else {
		char str[25];
//		_pg_out_date(mp,str,rowset->conn->datestyle,rowset->conn->textdate,_clip_pardj(mp,2));
		_clip_retc(mp,str);
	}
	return 0;
}

int clip_PG_OUT_TIMESTAMP(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	int totext = _clip_parl(mp,3);
	struct tm time;
	time_t date;

	memset(&time,0,sizeof(time));
	_clip_pardc(mp,2,&time.tm_year,&time.tm_mon,&time.tm_mday,&time.tm_wday);
	time.tm_year -= 1900;
	time.tm_mon--;

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if((!totext)&&rowset->binary){
		date = mktime(&time);
		_clip_retcn(mp,(char*)(&date),4);
	} else {
		char str[25];
//		_pg_out_date(mp,str,rowset->conn->datestyle,rowset->conn->textdate,_clip_pardj(mp,2));
		_clip_retc(mp,str);
	}
	return 0;
}

int clip_PG_OUT_INT4(ClipMachine* mp){
	int i = _clip_parnd(mp,1);
	_clip_retcn(mp,(char*)&i,4);
	return 0;
}

int clip_PG_OUT_INT2(ClipMachine* mp){
	short int s = (short int)_clip_parnd(mp,1);
	_clip_retcn(mp,(char*)&s,2);
	return 0;
}

int clip_PG_OUT_INT8(ClipMachine* mp){
	double d = _clip_parnd(mp,1);
	long long l = (long long)d;
	_clip_retcn(mp,(char*)&l,8);
	return 0;
}

int clip_PG_OUT_DOUBLE(ClipMachine* mp){
	double d = _clip_parnd(mp,1);
	_clip_retcn(mp,(char*)&d,8);
	return 0;
}

int clip_PG_OUT_FLOAT(ClipMachine* mp){
	float f = (float)_clip_parnd(mp,1);
	_clip_retcn(mp,(char*)&f,4);
	return 0;
}

int clip_PG_OUT_DATE(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	long date = _clip_pardj(mp,2);
	int totext = _clip_parl(mp,3);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if((!totext)&&rowset->binary){
		long d = date-2451545;
		_clip_retcn(mp,(char*)&d,4);
	} else {
		char str[11];
		int y,m,d,w;

		_clip_cdate(date,&d,&m,&y,&w);
		snprintf(str,sizeof(str),"%04d-%02d-%02d",y,m,d);
		_clip_retc(mp,str);
	}
	return 0;
}

int clip_PG_OUT_DATETIME(ClipMachine* mp){
	PG_ROWSET* rowset = (PG_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	long time;
	long date = _clip_pardtj(mp,2,&time);
	int totext = _clip_parl(mp,3);

	if(!rowset){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOROWSET,er_norowset);
		return 1;
	}
	if((!totext)&&rowset->binary){
		long l = date - _clip_jdate(1,1,2000);
		double d = l*(24*60*60) + time/1000;
		_clip_retcn(mp,(char*)&d,8);
	} else {
		char str[26];
		int y,m,d,w,h,mm,s,t,q;

		_clip_cdate(date,&d,&m,&y,&w);
		h = time/(60*60*1000);
		q = time%(60*60*1000);
		mm = q/(60*1000);
		q %= 60*1000;
		s = q/(1000);
		t = q%1000;
		snprintf(str,sizeof(str),"%04d-%02d-%02d %02d:%02d:%02d.%02d+00",y,m,d,h,mm,s,t);
		_clip_retc(mp,str);
	}
	return 0;
}

/* ------------------------------------------------------------------ */

int pg_fetch(ClipMachine* mp,SQLROWSET* rs,int recs,ClipVar* eval,int every,ClipVar* ors){
	PG_ROWSET* rowset = (PG_ROWSET*)rs;
	PG_STMT* stmt = rowset->stmt;
	int i,j,er = 0,len;
	void **rec;

	if(rowset->done)
		return 0;

	if(!recs)
		recs = 0x7fffffff;

	for(i=0;i<recs;i++){
		if(rowset->loaded == rowset->lastrec)
			goto done;
		rec = calloc(rowset->nfields,sizeof(void*));
		for(j=0;j<rowset->nfields;j++){
			if(!PQgetisnull(stmt->res,rowset->loaded,j)){
				len = PQgetlength(stmt->res,rowset->loaded,j);
				if(rowset->binary){
					rec[j] = malloc(len+4);
					*((int*)(rec[j])) = len;
					memcpy(((char*)rec[j])+4,
						PQgetvalue(stmt->res,rowset->loaded,j),len);
				} else {
					rec[j] = malloc(len+1);
					memcpy(rec[j],PQgetvalue(stmt->res,rowset->loaded,j),len);
					((char*)(rec[j]))[len] = 0;
				}
			} else {
				rec[j] = NULL;
			}
		}
		rowset->data[rowset->loaded] = rec;
		rowset->loaded++;
		if(eval && (eval->t.type == CCODE_t || eval->t.type == PCODE_t) && !(rowset->loaded % every)){
			ClipVar var,*v;
			if(_clip_eval(mp,eval,1,ors,&var)){
				_clip_destroy(mp,&var);
				er = 1;
				goto done;
			}
			v = _clip_vptr(&var);
			if(v->t.type == LOGICAL_t && !v->l.val){
				_clip_destroy(mp,&var);
				goto done;
			}
			_clip_destroy(mp,&var);
		}
	}
	return 0;
done:
	rowset->lastrec = rowset->loaded;
	rowset->done = 1;
	if(!rowset->lastrec){
		rowset->bof = rowset->eof = 1;
		rowset->recno = 0;
	}
	_clip_destroy_c_item(mp,stmt->stmt_item,_C_ITEM_TYPE_SQL);
	return er;
}

int pg_start(ClipMachine* mp,SQLCONN* c,const char* p1,const char* p2){
	PG_CONN* conn = (PG_CONN*)c;
	PGresult* res;

	if(conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	res = PQexec(conn->conn,"begin");
	if(PQresultStatus(res) != PGRES_COMMAND_OK){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,
			PQresultErrorMessage(res));
		return 1;
	}
	if(p1){
		char str[256];
		snprintf(str,sizeof(str),"set transaction isolation level %s",p1);
		res = PQexec(conn->conn,str);
		if(PQresultStatus(res) != PGRES_COMMAND_OK){
			_clip_trap_err(mp,0,0,0,subsys,ER_START,
				PQresultErrorMessage(res));
			return 1;
		}
	}
	conn->at = 1;
	return 0;
}

int pg_commit(ClipMachine* mp,SQLCONN* c){
	PG_CONN* conn = (PG_CONN*)c;
	PGresult* res;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	res = PQexec(conn->conn,"commit");
	if(PQresultStatus(res) != PGRES_COMMAND_OK){
		_clip_trap_err(mp,0,0,0,subsys,ER_COMMIT,
			PQresultErrorMessage(res));
		return 1;
	}
	conn->at = 0;
	return 0;
}

int pg_rollback(ClipMachine* mp,SQLCONN* c){
	PG_CONN* conn = (PG_CONN*)c;
	PGresult* res;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	res = PQexec(conn->conn,"rollback");
	if(PQresultStatus(res) != PGRES_COMMAND_OK){
		_clip_trap_err(mp,0,0,0,subsys,ER_ROLLBACK,
			PQresultErrorMessage(res));
		return 1;
	}
	conn->at = 0;
	return 0;
}
/* ************************************************************************* */
/*
  Some functionality for BLOB's (LO - Large Objects)
*/
/* ************************************************************************* */
int pg_lo_create(ClipMachine* mp, SQLCONN* c, unsigned int OID){
	PG_CONN		*conn = (PG_CONN*)c;
	Oid		lobjId;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	lobjId = lo_creat(conn->conn, OID);
	if (lobjId == 0){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_create);
		return 1;
	}
	_clip_retni(mp, lobjId);
	return 0;
}
/* ************************************************************************* */
int pg_lo_open(ClipMachine* mp, SQLCONN* c, unsigned int OID, int mode){
	PG_CONN		*conn = (PG_CONN*)c;
	int 		oid_fd;
	int lo_mode=0;
	if ((mode&1) == 1) lo_mode |= INV_READ;
	if ((mode&2) == 2) lo_mode |= INV_WRITE;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	oid_fd = lo_open(conn->conn, OID, lo_mode);
	if (oid_fd < 0){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_open);
		return 1;
	}
	_clip_retni(mp,oid_fd);
	return 0;
}
/* ************************************************************************* */
int pg_lo_import(ClipMachine* mp, SQLCONN* c, const char *filename){
	PG_CONN		*conn = (PG_CONN*)c;
	Oid		lobjId;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	lobjId = lo_import(conn->conn, filename);
	if (lobjId == 0){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_import);
		return 1;
	}
	_clip_retni(mp,(unsigned int) lobjId);
	return 0;
}
/* ************************************************************************* */
int pg_lo_export(ClipMachine* mp, SQLCONN* c, unsigned int OID, const char *filename){
	PG_CONN		*conn = (PG_CONN*)c;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	if (lo_export(conn->conn, OID, filename) > 0){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_export);
		return 1;
	}
	return 0;
}
/* ************************************************************************* */
int pg_lo_write(ClipMachine* mp, SQLCONN* c, int oid_fd, const char *buffer, int length){
	PG_CONN		*conn = (PG_CONN*)c;
	int rt;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	rt = lo_write(conn->conn, oid_fd, (char*)buffer, (size_t) length);
	if (rt < 0){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_write);
		return 1;
	}
	_clip_retni(mp,(unsigned int) rt);
	return 0;
}
/* ************************************************************************* */
int pg_lo_read(ClipMachine* mp, SQLCONN* c, int oid_fd, char *buffer, int length){
	PG_CONN		*conn = (PG_CONN*)c;
	int rt;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	rt = lo_read(conn->conn, oid_fd, buffer, (size_t) length);
	if (rt < 0){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_read);
		return 1;
	}
	_clip_retni(mp,(unsigned int) rt);
	return 0;
}
/* ************************************************************************* */
int pg_lo_seek(ClipMachine* mp, SQLCONN* c, int oid_fd, int offset, int whence){
	PG_CONN		*conn = (PG_CONN*)c;
	int rt;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	switch(whence){
		case SQLBLOB_SEEKTOP:
		whence = SEEK_SET;
		break;
		case SQLBLOB_SEEKCURRENT:
		whence = SEEK_CUR;
		break;
		case SQLBLOB_SEEKBOTTOM:
		whence = SEEK_END;
		break;
		default:
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_seek);
			return 1;
	}
	rt = lo_lseek(conn->conn, oid_fd, offset, whence);
	if (rt < 0){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_seek);
		return 1;
	}
	_clip_retni(mp,(unsigned int) rt);
	return 0;
}
/* ************************************************************************* */
int pg_lo_tell(ClipMachine* mp, SQLCONN* c, int oid_fd){
	PG_CONN		*conn = (PG_CONN*)c;
	int rt;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	rt = lo_tell(conn->conn, oid_fd);
	if (rt < 0){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_tell);
		return 1;
	}
	_clip_retni(mp,(unsigned int) rt);
	return 0;
}
/* ************************************************************************* */
int pg_lo_close(ClipMachine* mp, SQLCONN* c, int oid_fd){
	PG_CONN		*conn = (PG_CONN*)c;
	int rt;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	rt = lo_close(conn->conn, oid_fd);
	if (rt < 0){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_close);
		return 1;
	}
	return 0;
}
/* ************************************************************************* */
int pg_lo_unlink(ClipMachine* mp, SQLCONN* c, unsigned int OID){
	PG_CONN		*conn = (PG_CONN*)c;
	int rt;
	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	rt = lo_unlink(conn->conn, OID);
	if (rt < 0){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_blob_unlink);
		return 1;
	}
	return 0;
}
/* ************************************************************************* */
