#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/timeb.h>
#include "libpq-fe.h"
#include "clip.h"
#include "postgres.ch"
#include "dbfsql.h"
#include "error.ch"

static const char subsys[] = "DBFSQL";
static const char er_nosql[] = "No SQL statement";
static const char er_nostatement[] = "No statement. PG_PREPARE must be executed first";
static const char er_norowset[] = "No such rowset";
static const char er_badorders[] = "Bad orders";

int pg_createconn(ClipMachine* mp);

struct tagPG_CONN;

typedef struct tagPG_STMT {
	struct tagPG_STMT* next;
	int stmt_item;
	struct tagPG_CONN* conn;
	char* sql;
	PGresult* res;
} PG_STMT;

// Rowset abstract structure
typedef struct tagPG_ROWSET {
	int rowset_item;
	struct tagPG_CONN* conn;
	struct tagPG_ROWSET* next;
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
	SQLORDER* curord;
	int binary;
	void*** data;
} PG_ROWSET;

// Connection abstract structure
typedef struct tagPG_CONN {
	SQLVTBL* vtbl;
	PG_STMT* stmts;
	PG_ROWSET* rowsets;
	SQLLocale* loc;
	PGconn* conn;
} PG_CONN;

void pg_destroyconn(SQLCONN* conn);
int pg_prepare(ClipMachine* mp,SQLCONN* conn,char* sql);
int pg_command(ClipMachine* mp,SQLSTMT* stmt,ClipVar* ap);
int pg_createrowset(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* stmt,ClipVar* ap,const char* idname,const char* gen_idSQL);
char* pg_testparser(ClipMachine* mp,char* sql,ClipVar* ap);
char* pg_getvalue(SQLROWSET* rowset,int fieldno,int* len);
void pg_setvalue(SQLROWSET* rowset,int fieldno,char* value,int len);
void pg_append(SQLROWSET* rowset);
void pg_delete(SQLROWSET* rowset);
void pg_newid(ClipMachine* mp,SQLSTMT* stmt);
int pg_refresh(ClipMachine* mp,SQLROWSET* rowset,SQLSTMT* stmt,ClipVar* ap,const char* idname);

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
	NULL
};

int clip_INIT_POSTGRES(ClipMachine* mp){
	mp->pg_connect = pg_createconn;
	return 0;
}

static void destroy_pg_stmt(void* stmt){
	if(stmt){
		if(((PG_STMT*)(stmt))->res){
			PQclear(((PG_STMT*)(stmt))->res);
		}
		if(((PG_STMT*)(stmt))->sql){
			free(((PG_STMT*)(stmt))->sql);
		}
		free(stmt);
	}
}

// Helper function used by _clip_destroy_c_item to release rowset.
static void destroy_pg_rowset(void* rowset){
	int i,j;
	if(rowset){
		if(((PG_ROWSET*)(rowset))->fields){
			free(((PG_ROWSET*)(rowset))->fields);
		}
		if(((PG_ROWSET*)(rowset))->data){
			for(i=0;i<((PG_ROWSET*)(rowset))->lastrec;i++){
				for(j=0;j<((PG_ROWSET*)(rowset))->nfields;j++){
					if(((PG_ROWSET*)(rowset))->data[i][j]){
						free(((PG_ROWSET*)(rowset))->data[i][j]);
					}
				}
				free(((PG_ROWSET*)(rowset))->data[i]);
			}
			free(((PG_ROWSET*)(rowset))->data);
		}
		free(rowset);
	}
	return;
}

// Helper function used by _clip_destroy_c_item to release connect.
// All opened rowsets are released too.
static void destroy_pg_conn(void* conn){
	PG_ROWSET* currowset = ((PG_CONN*)(conn))->rowsets;
	PG_ROWSET* nextrowset;
	PG_STMT* curstmt = ((PG_CONN*)(conn))->stmts;
	PG_STMT* nextstmt;
	if(conn){
		while(currowset){
			nextrowset = currowset->next;
			destroy_pg_rowset(currowset);
			currowset = nextrowset;
		}
		while(curstmt){
			nextstmt = curstmt->next;
			destroy_pg_stmt(curstmt);
			curstmt = nextstmt;
		}
		free(conn);
	}
	return;
}

void pg_bindpars(PG_STMT* stmt,ClipVar* ap){
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

int pg_createconn(ClipMachine* mp){
	char* pghost	= _clip_parc(mp,2);
	char* pgport	= _clip_parc(mp,3);
	char* login		= _clip_parc(mp,4);
	char* pwd		= _clip_parc(mp,5);
	char* dbName	= _clip_parc(mp,6);
	char* pgtty		= _clip_parc(mp,7);
	char* pgoptions = _clip_parc(mp,8);
	PGconn* tmpconn;
	PGresult* res;
	PG_CONN* conn;

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
	stmt->next = ((PG_CONN*)conn)->stmts;
	((PG_CONN*)conn)->stmts = stmt;

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

int pg_createrowset(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* stmt,ClipVar* ap,const char* idname,const char* gen_idSQL){
	PG_ROWSET* rowset = (PG_ROWSET*)rs;
	int i,j,len;
	void** rec;

	pg_bindpars((PG_STMT*)stmt,ap);
	if(!((PG_STMT*)stmt)->sql){
		_clip_trap_err(mp,0,0,0,subsys,ER_NOSQL,er_nosql);
		return 1;
	}

	((PG_STMT*)stmt)->res = PQexec(((PG_STMT*)stmt)->conn->conn,
		((PG_STMT*)stmt)->sql);
	if(!((PG_STMT*)stmt)->res){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,
			PQresultErrorMessage(((PG_STMT*)stmt)->res));
		return 1;
	}
	if(PQresultStatus(((PG_STMT*)stmt)->res)!=PGRES_TUPLES_OK){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSELECT,
			PQresultErrorMessage(((PG_STMT*)stmt)->res));
		return 1;
	}

	rowset->rowset_item =
		_clip_store_c_item(mp,rowset,_C_ITEM_TYPE_SQL,destroy_pg_rowset);

	rowset->binary = PQbinaryTuples(((PG_STMT*)stmt)->res);
	rowset->nfields = PQnfields(((PG_STMT*)stmt)->res);
	rowset->fields = calloc(1,rowset->nfields*sizeof(SQLFIELD));
	rowset->id = -1;
	for(i=0;i<rowset->nfields;i++){
		strncpy(rowset->fields[i].name,PQfname(((PG_STMT*)stmt)->res,i),
			MAXFIELDNAME);
		rowset->fields[i].name[MAXFIELDNAME] = 0;
		rowset->fields[i].type = PQftype(((PG_STMT*)stmt)->res,i);
		rowset->fields[i].len = PQfsize(((PG_STMT*)stmt)->res,i);
		rowset->fields[i].dec = 0;
		rowset->fields[i].ops = 0;
		if(rowset->fields[i].type == PGT_OID){
			rowset->id = i;
		}
	}

	rowset->lastrec = PQntuples(((PG_STMT*)stmt)->res);
	rowset->data = malloc(sizeof(void*)*rowset->lastrec);
	for(i=0;i<rowset->lastrec;i++){
		rec = malloc(sizeof(void*)*rowset->nfields);
		for(j=0;j<rowset->nfields;j++){
			if(!PQgetisnull(((PG_STMT*)stmt)->res,i,j)){
				len = PQgetlength(((PG_STMT*)stmt)->res,i,j);
				if(rowset->binary){
					rec[j] = malloc(len+4);
					*((int*)(rec[j])) = len;
					memcpy(((char*)rec[j])+4,
						PQgetvalue(((PG_STMT*)stmt)->res,i,j),len);
				} else {
					rec[j] = malloc(len+1);
					memcpy(rec[j],PQgetvalue(((PG_STMT*)stmt)->res,i,j),len);
					((char*)(rec[j]))[len] = 0;
				}
			} else {
				rec[j] = NULL;
			}
		}
		rowset->data[i] = rec;
	}
	return 0;
}

int pg_refresh(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap,const char* idname){
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
			_clip_retni(mp,atoi(str));
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

