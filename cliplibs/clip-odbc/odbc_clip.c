/*
	$Log: odbc_clip.c,v $
	Revision 1.8  2002/08/21 10:13:30  clip
	rust: firebird required some changes
	
	Revision 1.7  2002/07/04 15:46:46  clip
	rust: orders in TRowset

	Revision 1.6  2002/05/30 11:32:41  clip
	rust: TRowset:RefreshCurrent()

	Revision 1.5  2002/05/30 10:45:11  clip
	rust: parameters internationalization, correct treating to binary fields

	Revision 1.4  2002/05/27 10:25:29  clip
	rust: some fixes and ODBC-ODBC bridge support

	Revision 1.3  2002/05/14 12:15:19  clip
	rust: clip-odbc is ready for testing

	Revision 1.2  2002/04/10 12:09:05  clip
	rust: configure added

	Revision 1.1  2002/04/07 20:18:10  clip
	rust: just started

*/

#include <string.h>
#include <time.h>
#include <ctype.h>

#include "clip.h"
#include "dbfsql.h"

#include <sqlext.h>

#define MAX_ERROR_MESSAGE_LEN 256
#define LOWORD(a) (a) & 0xffff
#define HIWORD(a) ((a) & 0xffff0000) >> 16

#define HEXDIGIT(c) (isdigit((c))?(c)-'0':tolower((c))-'a'+10)
#define HEXOCTET(a,b) ((HEXDIGIT((a)) << 4) | HEXDIGIT((b)))

#ifndef SQL_DEFAULT
#define SQL_DEFAULT SQL_C_DEFAULT
#endif

#ifndef SQL_NO_DATA
#define SQL_NO_DATA SQL_NO_DATA_FOUND
#endif

#define _TERM_ZERO (rowset->fields[i].type == SQL_CHAR || \
					rowset->fields[i].type == SQL_VARCHAR || \
					rowset->fields[i].type == SQL_BIGINT || \
					rowset->fields[i].type == SQL_DECIMAL || \
					rowset->fields[i].type == SQL_LONGVARBINARY || \
					rowset->fields[i].type == SQL_LONGVARCHAR)

static const char subsys[] = "DBFSQL";
static const char er_connect[] = "Can't connect to database server";
static const char er_nosql[] = "No SQL statement";
static const char er_nostatement[] = "No statement (not prepared)";
static const char er_norowset[] = "No such rowset";
static const char er_badstatement[] = "Bad statement";
static const char er_execute[] = "Execution error";
static const char er_createrowset[] = "Fetching data error";
static const char er_refresh[] = "Refreshing row data error";

int odbc_createconn(ClipMachine * mp);

struct ODBC_CONN;

typedef struct ODBC_STMT
{
	struct ODBC_STMT *next;
	int stmt_item;
	struct ODBC_CONN *conn;
	char *sql;
	SQLHSTMT hstmt;
}
ODBC_STMT;

/* Rowset abstract structure */
typedef struct ODBC_ROWSET
{
	int rowset_item;
	struct ODBC_CONN *conn;
	struct ODBC_ROWSET *next;
	int recno;
	int lastrec;
	int bof;
	int eof;
	int nfields;
	SQLFIELD *fields;
	int id;
	HashTable* orders;
	long* taghashes;
	int ntags;
	BTREE* bt;
	struct tagSQLORDER* curord;
	void ***data;
}
ODBC_ROWSET;

/* Connection abstract structure */
typedef struct ODBC_CONN
{
	SQLVTBL *vtbl;
	ODBC_STMT *stmts;
	ODBC_ROWSET *rowsets;
	SQLLocale* loc;
	SQLHDBC conn;
	SQLHENV henv;
	char postgres;
}
ODBC_CONN;

void odbc_destroyconn(SQLCONN * conn);
int odbc_prepare(ClipMachine * mp, SQLCONN * conn, char *sql);
int odbc_command(ClipMachine * mp, SQLSTMT * stmt, ClipVar * ap);
int odbc_createrowset(ClipMachine * mp, SQLROWSET* rs, SQLSTMT * stmt, ClipVar * ap,const char* idname,const char* gen_idSQL);
char *odbc_testparser(ClipMachine * mp, char * sql, ClipVar * ap);
char *odbc_getvalue(SQLROWSET * rowset, int fieldno, int *len);
void odbc_setvalue(SQLROWSET * rowset, int fieldno, char *value, int len);
void odbc_append(SQLROWSET * rowset);
void odbc_delete(SQLROWSET * rowset);
void odbc_newid(ClipMachine * mp, SQLSTMT * stmt);
int odbc_refresh(ClipMachine* mp,SQLROWSET* rowset,SQLSTMT* stmt,ClipVar* ap,const char* idname);

static SQLVTBL vtbl =
{
	sizeof(ODBC_ROWSET),
	odbc_destroyconn,
	odbc_prepare,
	odbc_command,
	odbc_createrowset,
	odbc_testparser, // SQLNativeSQL
	odbc_getvalue,
	odbc_setvalue,
	odbc_append,
	odbc_delete,
	odbc_newid,
	odbc_refresh,
	NULL
};

int odbc_error(ClipMachine* cm,SQLLocale* loc,SQLHENV henv,SQLHDBC hdbc,SQLHSTMT hstmt,int line,const char* er_){
	char state[6];
	SQLINTEGER native;
	char error[MAX_ERROR_MESSAGE_LEN];
	SQLSMALLINT errlen;
	char err[MAX_ERROR_MESSAGE_LEN];
	int u;
	char *r,*c,*e;

	u = SQLError(henv,hdbc,hstmt,state,&native,error,MAX_ERROR_MESSAGE_LEN,&errlen);
	while((r = strchr(error,';'))) *r = ' ';
	while((r = strchr(error,'\n'))) *r = ';';
	while((r = strchr(error,'\r'))) *r = ' ';
	if(native)
		snprintf(err,MAX_ERROR_MESSAGE_LEN,";%s; SQLSTATE: %s : Native error %d;%s;",
			er_,state,(int)native,error);
	else
		snprintf(err,MAX_ERROR_MESSAGE_LEN,";%s; SQLSTATE: %s;%s;",
			er_,state,error);
	if(loc){
		c = err;
		e = err+strlen(err);
		for(;c<e;c++)
			if(*c&0x80)
				*c = loc->read[*c&0x7f];
	}
	_clip_trap_err(cm, 0, 0, 0, __FILE__, line, err);
	return -1;
}

int clip_INIT_ODBC(ClipMachine* cm){
	cm->odbc_connect = odbc_createconn;
	return 0;
}

void destroy_odbc_conn(void* data){
	free(data);
}

static void destroy_odbc_stmt(void* stmt){
	if(stmt){
		if(((ODBC_STMT*)(stmt))->hstmt){
			SQLFreeStmt(((ODBC_STMT*)stmt)->hstmt,SQL_DROP);
		}
		if(((ODBC_STMT*)(stmt))->sql){
			free(((ODBC_STMT*)(stmt))->sql);
		}
		free(stmt);
	}
}

static void destroy_odbc_rowset(void* rs){
	ODBC_ROWSET* rowset = (ODBC_ROWSET*)rs;
	int i,j;

	if(rowset){
		if(rowset->fields){
			free(rowset->fields);
		}
		if(rowset->data){
			for(i=0;i<rowset->lastrec;i++){
				for(j=0;j<rowset->nfields;j++){
					if(rowset->data[i][j]){
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

void
odbc_bindpars(ODBC_STMT * stmt, ClipVar * ap)
{
	char* sql = stmt->sql;
	int initlen = strlen(sql);
	int len = initlen;
	int i;
	ClipVar *tp,*vp;
	char parnamebuf[MAXFIELDNAME+1] = ":";
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
		if(vp->t.type == CHARACTER_t){
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
						len += strlen(vp->s.str.buf) - (e - b);
					}
				} else {
					len += strlen(vp->s.str.buf) - (initlen - (b-sql));
				}
				b++;
			}
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
		if(vp->t.type == CHARACTER_t){
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

int
odbc_createconn(ClipMachine * cm)
{
	int dbl,userl,passwdl;
	char* db = _clip_parcl(cm,2,&dbl);
	char* user = _clip_parcl(cm,3,&userl);
	char* passwd = _clip_parcl(cm,4,&passwdl);
	ODBC_CONN *conn = NULL;
	SQLHDBC tmpconn;
	SQLRETURN er;
	SQLHENV henv;
	char dbms[30];

	if(!user)
		userl = 0;
	if(!passwd)
		passwdl = 0;

	if((er = SQLAllocEnv(&henv))) goto err;
	if((er = SQLAllocConnect(henv,&tmpconn))) goto err;
	if((er = SQLConnect(tmpconn,db,dbl,user,userl,passwd,passwdl))) goto err;
	/* silly PostgreSQL's ODBC driver */
	if((er = SQLGetInfo(tmpconn,SQL_DBMS_NAME,dbms,sizeof(dbms),0)))
		goto err;

	conn = calloc(sizeof(ODBC_CONN),1);
	conn->conn = tmpconn;
	conn->vtbl = &vtbl;
	conn->henv = henv;
	if(strcmp(dbms,"PostgreSQL")==0)
		conn->postgres = 1;

	return _clip_store_c_item(cm, (void *) conn, _C_ITEM_TYPE_SQL, destroy_odbc_conn);
err:
	odbc_error(cm,(conn?conn->loc:0),henv,tmpconn,0,__LINE__,er_connect);
	if(conn)
		free(conn);
	return -1;
}

void
odbc_destroyconn(SQLCONN* conn)
{
	SQLDisconnect(((ODBC_CONN*)conn)->conn);
	SQLFreeConnect(((ODBC_CONN*)conn)->conn);
	SQLFreeEnv(((ODBC_CONN*)conn)->henv);
}

int odbc_prepare(ClipMachine* cm,SQLCONN* c,char* sql){
	ODBC_CONN* conn = (ODBC_CONN*)c;
	ODBC_STMT* stmt;

	if(!sql)
		sql = "";
	stmt = calloc(sizeof(ODBC_STMT),1);
	memset(stmt,0,sizeof(ODBC_STMT));
	stmt->stmt_item =
		_clip_store_c_item(cm,stmt,_C_ITEM_TYPE_SQL,destroy_odbc_stmt);

	stmt->sql = strdup(sql);

	stmt->conn = conn;
	stmt->next = conn->stmts;
	conn->stmts = stmt;

	return stmt->stmt_item;
}

int odbc_command(ClipMachine* cm,SQLSTMT* s,ClipVar* ap){
	ODBC_STMT* stmt = (ODBC_STMT*)s;
	SQLRETURN er;
	SDWORD count;

	odbc_bindpars(stmt,ap);
	if((er = SQLAllocStmt(stmt->conn->conn,&stmt->hstmt))) goto err;
	if((er = SQLPrepare(stmt->hstmt,stmt->sql,strlen(stmt->sql)))) goto err;
	if((er = SQLExecute(stmt->hstmt))) goto err;
	if((er = SQLRowCount(stmt->hstmt,&count))) goto err;
	if(count < 0)
		count = 0;
	return count;
err:
	return odbc_error(cm,stmt->conn->loc,0,stmt->conn->conn,stmt->hstmt,__LINE__,er_execute);
}

char* odbc_testparser(ClipMachine* mp,char* sql,ClipVar* ap){
	ODBC_STMT stmt;

	stmt.sql = sql;
	odbc_bindpars(&stmt,ap);
	return stmt.sql;
}

int odbc_createrowset(ClipMachine* cm,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap,const char* idname,const char* gen_idSQL){
	ODBC_STMT* stmt = (ODBC_STMT*)s;
	SQLRETURN er;
	ODBC_ROWSET* rowset = (ODBC_ROWSET*)rs;
	SQLSMALLINT cols;
	SQLINTEGER nullable;
	int i;
	void** rec;

	odbc_bindpars(stmt,ap);
	if((er = SQLAllocStmt(stmt->conn->conn,&stmt->hstmt))) goto err;
	if((er = SQLPrepare(stmt->hstmt,stmt->sql,strlen(stmt->sql)))) goto err;
	rowset->rowset_item =
		_clip_store_c_item(cm,rowset,_C_ITEM_TYPE_SQL,destroy_odbc_rowset);

	if((er = SQLExecute(stmt->hstmt))) goto err;

	if((er = SQLNumResultCols(stmt->hstmt,&cols))) goto err;
	rowset->nfields = cols;
	rowset->fields = calloc(rowset->nfields,sizeof(SQLFIELD));
	rowset->id = -1;

	for(i=0;i<rowset->nfields;i++){
		if((er = SQLColAttributes(stmt->hstmt,i+1,
			SQL_COLUMN_NAME,rowset->fields[i].name,MAXFIELDNAME+1,0,0)))
			goto err;
		if((er = SQLColAttributes(stmt->hstmt,i+1,
			SQL_COLUMN_TYPE,0,0,0,(SQLPOINTER)&rowset->fields[i].type)))
			goto err;
		if((er = SQLColAttributes(stmt->hstmt,i+1,
			SQL_COLUMN_LENGTH,0,0,0,(SQLPOINTER)&rowset->fields[i].buflen)))
			goto err;
		if((er = SQLColAttributes(stmt->hstmt,i+1,
			SQL_COLUMN_DISPLAY_SIZE,0,0,0,(SQLPOINTER)&rowset->fields[i].len)))
			goto err;
		if((er = SQLColAttributes(stmt->hstmt,i+1,
			SQL_COLUMN_SCALE,0,0,0,(SQLPOINTER)&rowset->fields[i].dec)))
			goto err;
		if((er = SQLColAttributes(stmt->hstmt,i+1,
			SQL_COLUMN_UNSIGNED,0,0,0,(SQLPOINTER)&rowset->fields[i].unsign)))
			goto err;
		if((er = SQLColAttributes(stmt->hstmt,i+1,
			SQL_COLUMN_NULLABLE,0,0,0,(SQLPOINTER)&nullable)))
			goto err;
		rowset->fields[i].notnull = (nullable == SQL_NO_NULLS);
		/* silly PostgreSQL's ODBC driver */
		if(stmt->conn->postgres && (rowset->fields[i].type == SQL_NUMERIC ||
			rowset->fields[i].type == SQL_DECIMAL)){

			rowset->fields[i].dec = LOWORD(rowset->fields[i].len);
			rowset->fields[i].len = HIWORD(rowset->fields[i].len);
			rowset->fields[i].buflen = 8;
		}
		if(rowset->fields[i].type == SQL_LONGVARBINARY)
			rowset->fields[i].buflen *= 2;
		if(idname && strcasecmp(rowset->fields[i].name,idname)==0){
			rowset->id = i;
		}
		if(rowset->fields[i].type == SQL_BINARY ||
			rowset->fields[i].type == SQL_VARBINARY ||
			rowset->fields[i].type == SQL_LONGVARBINARY)
		rowset->fields[i].binary = 1;
	}
	rowset->lastrec = 0;
	rowset->data = malloc(sizeof(void*)*rowset->lastrec);

	do {
		rec = malloc(sizeof(void*)*rowset->nfields);
		for(i=0;i<rowset->nfields;i++){
			rec[i] = malloc(rowset->fields[i].buflen+4+_TERM_ZERO);
			if((er = SQLBindCol(stmt->hstmt,i+1,SQL_DEFAULT,
				rec[i]+4,rowset->fields[i].buflen+_TERM_ZERO,rec[i]))) goto err;
		}
		rowset->data = realloc(rowset->data,sizeof(void*)*(rowset->lastrec+1));
		rowset->data[rowset->lastrec] = rec;
		rowset->lastrec++;
	} while (!(er = SQLFetch(stmt->hstmt)));
	if(er != SQL_NO_DATA)
		goto err;
	rowset->lastrec--;
	for(i=0;i<rowset->nfields;i++)
		free(rec[i]);
	free(rec);
	rowset->data = realloc(rowset->data,sizeof(void*)*rowset->lastrec);
	return 0;
err:
	odbc_error(cm,stmt->conn->loc,0,stmt->conn->conn,stmt->hstmt,__LINE__,er_createrowset);
	return 1;
}

int odbc_refresh(ClipMachine* cm,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap,const char* idname){
	ODBC_STMT* stmt = (ODBC_STMT*)s;
	SQLRETURN er;
	ODBC_ROWSET* rowset = (ODBC_ROWSET*)rs;
	SQLSMALLINT cols;
	int i;
	void** rec;

	odbc_bindpars(stmt,ap);
	if((er = SQLAllocStmt(stmt->conn->conn,&stmt->hstmt))) goto err;
	if((er = SQLPrepare(stmt->hstmt,stmt->sql,strlen(stmt->sql)))) goto err;
	if((er = SQLExecute(stmt->hstmt))) goto err;

	if((er = SQLNumResultCols(stmt->hstmt,&cols))) goto err;

	rec = malloc(sizeof(void*)*rowset->nfields);
	for(i=0;i<rowset->nfields;i++){
		rec[i] = malloc(rowset->fields[i].buflen+4+_TERM_ZERO);
		if((er = SQLBindCol(stmt->hstmt,i+1,SQL_DEFAULT,
			rec[i]+4,rowset->fields[i].buflen+_TERM_ZERO,rec[i]))) goto err;
	}
	er = SQLFetch(stmt->hstmt);
	if(er != SQL_NO_DATA){
		for(i=0;i<rowset->nfields;i++)
			free(rowset->data[rowset->recno-1][i]);
		free(rowset->data[rowset->recno-1]);
		rowset->data[rowset->recno-1] = rec;
	} else {
		for(i=0;i<rowset->nfields;i++)
			free(rec[i]);
		free(rec);
		odbc_delete((SQLROWSET*)rowset);
		rowset->lastrec--;
		if(rowset->recno > rowset->lastrec)
			rowset->recno = rowset->lastrec;
	}
	return 0;
err:
	return odbc_error(cm,stmt->conn->loc,0,stmt->conn->conn,stmt->hstmt,__LINE__,er_refresh);
}

char* odbc_getvalue(SQLROWSET* rs,int fieldno,int* len){
	ODBC_ROWSET* rowset = (ODBC_ROWSET*)rs;
	if(rowset->data[rowset->recno-1][fieldno]){
		*len = *(int*)(rowset->data[rowset->recno-1][fieldno]);
		if(*len==SQL_NULL_DATA){
			*len = 0;
			return NULL;
		}
		return (char*)(rowset->data[rowset->recno-1][fieldno])+4;
	}
	return NULL;
}

void
odbc_setvalue(SQLROWSET * rs, int fieldno, char *value, int len)
{
	ODBC_ROWSET* rowset = (ODBC_ROWSET*) rs;
	if(rowset->data[rowset->recno - 1][fieldno]){
		free(rowset->data[rowset->recno - 1][fieldno]);
	}
	if(value){
		rowset->data[rowset->recno - 1][fieldno] = malloc(len + 4);
		*((int*)(rowset->data[rowset->recno - 1][fieldno])) = len;
		memcpy(((char*)(rowset->data[rowset->recno - 1][fieldno])) + 4, value, len);
	}
	else {
		rowset->data[rowset->recno - 1][fieldno] = NULL;
	}
}

void
odbc_append(SQLROWSET * rs)
{
	ODBC_ROWSET* rowset = (ODBC_ROWSET*) rs;
	void **row;

	rowset->lastrec++;
	rowset->data = realloc(rowset->data,sizeof(void*) * rowset->lastrec);

	row = calloc(rowset->nfields,sizeof(void*));
	rowset->data[rowset->lastrec - 1] = row;
}

void
odbc_delete(SQLROWSET * rs)
{
	ODBC_ROWSET* rowset = (ODBC_ROWSET*) rs;
	int i;

	for(i=0;i<rowset->nfields;i++){
		if(rowset->data[rowset->recno - 1][i]){
			free(rowset->data[rowset->recno - 1][i]);
		}
	}
	free(rowset->data[rowset->recno - 1]);
	for(i=rowset->recno;i<rowset->lastrec;i++){
		rowset->data[i - 1] = rowset->data[i];
	}
	rowset->data = realloc(rowset->data,sizeof(void*) * (rowset->lastrec - 1));
}

void
odbc_newid(ClipMachine * mp, SQLSTMT * stmt){}

/* ----------------------------------------------------------------------- */

int clip_ODBC_IN_DOUBLE(ClipMachine* mp){
	char* str = _clip_parc(mp,1);
	if(str){
		_clip_retnd(mp,*((double*)str));
	}
	return 0;
}

int clip_ODBC_IN_FLOAT(ClipMachine* mp){
	char* str = _clip_parc(mp,1);
	if(str){
		_clip_retnd(mp,*((float*)str));
	}
	return 0;
}

int clip_ODBC_IN_DATE(ClipMachine* mp){
	char* str = _clip_parc(mp,1);
	if(str){
		_clip_retdc(mp,*((short*)str),*((short*)str+1),*((short*)str+2));
	}
	return 0;
}

int clip_ODBC_IN_TIME(ClipMachine* mp){
	char* str = _clip_parc(mp,1);
	char ret[9];
	if(str){
		sprintf(ret,"%02d:%02d:%02d",*((short*)str),*((short*)str+1),*((short*)str+2));
		_clip_retc(mp,ret);
	}
	return 0;
}

int clip_ODBC_IN_TIMESTAMP(ClipMachine* mp){
	char* str = _clip_parc(mp,1);
	ClipVar* ret = RETPTR(mp);

	memset(ret,0,sizeof(ClipVar));
	if(str){
		ret->t.type = DATETIME_t;
		ret->dt.julian = _clip_jdate(*((short*)str+2),*((short*)str+1),*((short*)str));
		ret->dt.time = (*((short*)str+3)*60*60*1000) +
			(*((short*)str+4)*60*1000)+(*((short*)str+5)*1000);
	}
	return 0;
}

int clip_ODBC_IN_BLOB(ClipMachine* mp){
	int len;
	unsigned char* str = _clip_parcl(mp,1,&len);
	unsigned char* ret;
	int i;

	if(str){
		len /= 2;
		ret = malloc(len+1);
		for(i=0;i<len;i++){
			ret[i] = HEXOCTET(str[i<<1],str[(i<<1)+1]);
		}
		ret[len] = 0;
		_clip_retcn_m(mp,ret,len);
	}
	return 0;
}

int clip_ODBC_OUT_DOUBLE(ClipMachine* mp){
	double d = _clip_parnd(mp,1);
	_clip_retcn(mp,(char*)&d,8);
	return 0;
}

int clip_ODBC_OUT_FLOAT(ClipMachine* mp){
	float d = _clip_parnd(mp,1);
	_clip_retcn(mp,(char*)&d,4);
	return 0;
}

int clip_ODBC_OUT_TIMESTAMP(ClipMachine* mp){
	long time;
	long julian = _clip_pardtj(mp,1,&time);
	short int s[6] = {0,0,0,0,0,0};
	int yy,mm,dd,ww;
	long t;

	if(_clip_parinfo(mp,1) == DATE_t){
		if(julian){
			_clip_cdate(julian,&dd,&mm,&yy,&ww);
			s[0] = yy; s[1] = mm; s[2] = dd;
		}
		s[3] = time / (60*60*1000);
		t = time % (60*60*1000);
		s[4] = t / (60*1000);
		s[5] = (t % (60*1000)) / 1000;
	}
	_clip_retcn(mp,(char*)s,12);
	return 0;
}

int clip_ODBC_OUT_DATE(ClipMachine* mp){
	long julian = _clip_pardj(mp,1);
	short int s[3] = {0,0,0};
	int yy,mm,dd,ww;

	if((_clip_parinfo(mp,1) == DATE_t) && julian){
		_clip_cdate(julian,&dd,&mm,&yy,&ww);
		s[0] = yy; s[1] = mm; s[2] = dd;
	}
	_clip_retcn(mp,(char*)s,6);
	return 0;
}

int clip_ODBC_OUT_TIME(ClipMachine* mp){
	int len;
	const char* t = _clip_parcl(mp,1,&len);
	short int s[3] = {0,0,0};

	if(!((_clip_parinfo(mp,1) != CHARACTER_t) || !t || (len < 8))){
		s[0] = atoi(t);
		s[1] = atoi(t+3);
		s[2] = atoi(t+6);
	}
	_clip_retcn(mp,(char*)s,6);
	return 0;
}

int clip_ODBC_OUT_BLOB(ClipMachine* mp){
	int len;
	unsigned char* str = _clip_parcl(mp,1,&len);
	unsigned char* ret;
	int i;
	char digs[] = "0123456789ABCDEF";

	if(str){
		ret = malloc(len*2+1);
		for(i=0;i<len;i++){
			ret[i<<1] = digs[str[i] >> 4];
			ret[(i<<1)+1] = digs[str[i] & 0x0F];
		}
		ret[len*2] = 0;
		_clip_retcn_m(mp,ret,len*2);
	} else {
		_clip_retc(mp,"");
	}
	return 0;
}


