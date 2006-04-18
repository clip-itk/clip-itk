/*
	$Log: dbtcp_clip.c,v $
	Revision 1.11  2006/03/23 10:41:06  clip
	rust: BLOB functions for PG (thanks Slava Zanko <slavaz@cis.by>)
	
	Revision 1.9  2004/02/26 12:59:55  clip
	rust: bindpars with NIL
	
	Revision 1.8  2003/06/09 13:10:14  clip
	rust: multiple column PRIMARY KEY as row ID

	Revision 1.7  2003/04/29 08:51:12  clip
	rust: small fixes

	Revision 1.6  2003/04/09 08:48:08  clip
	rust: increase loaded rows counter on append

	Revision 1.5  2003/03/12 12:49:36  clip
	rust: tasks share SQL drivers

	Revision 1.4  2003/02/17 13:29:24  clip
	rust: some cleanings

	Revision 1.3  2003/02/17 12:59:45  clip
	rust: all functionality implemented

	Revision 1.2  2003/02/14 10:01:16  clip
	rust: SQLFieldType() -> SQLFieldTypeSQL()

	Revision 1.1  2003/02/13 16:35:20  clip
	rust: clip-dbtcp started

*/

#include <string.h>
#include <protocol.h>

#include "clip.h"
#include "dbfsql.h"

int dbtcp_createconn(ClipMachine * mp);

struct tagDBTCP_CONN;

typedef struct tagDBTCP_STMT
{
	int stmt_item;
	struct tagDBTCP_CONN *conn;
	char *sql;
}
DBTCP_STMT;

typedef struct tagDBTCP_ROWSET
{
	int rowset_item;
	struct tagDBTCP_CONN *conn;
	struct tagDBTCP_STMT *stmt;
	int recno;
	int lastrec;
	int loaded;
	int unknownrows;
	int done;
	int bof;
	int eof;
	int nfields;
	SQLFIELD *fields;
	int id;
	int nids;
	int* ids;
	HashTable* orders;
	long* taghashes;
	int ntags;
	BTREE* bt;
	struct tagSQLORDER* curord;
	int hot;
	int newrec;
	void ***data;
}
DBTCP_ROWSET;

/* Connection abstract structure */
typedef struct tagDBTCP_CONN
{
	SQLVTBL *vtbl;
	SQLLocale* loc;
	int at;
	dbftp_result* conn;
}
DBTCP_CONN;

static const char subsys[]          = "DBFSQL";
static const char er_connect[]      = "Can't connect to database server";
static const char er_nosql[]        = "Not SELECT statement";
static const char er_badselect[]    = "Bad SELECT statement";
static const char er_start[]        = "Can't start transaction";
static const char er_commit[]       = "Can't commit transaction";
static const char er_rollback[]     = "Can't roll transaction back";

void dbtcp_destroyconn(SQLCONN* c);
int dbtcp_prepare(ClipMachine* cm,SQLCONN* c,char* sql);
int dbtcp_command(ClipMachine* cm,SQLSTMT* s,ClipVar* ap);
int dbtcp_createrowset(ClipMachine* cm,SQLROWSET* rs,ClipVar* ap,ClipVar* idname,const char* gen_idSQL);
char* dbtcp_testparser(ClipMachine* cm,char* sql,ClipVar* ap);
char* dbtcp_getvalue(SQLROWSET* rs,int fieldno,int *len);
void dbtcp_setvalue(SQLROWSET* rs,int fieldno,char* value,int len);
void dbtcp_append(SQLROWSET* rs);
void dbtcp_delete(SQLROWSET* rs);
void dbtcp_newid(ClipMachine * cm, SQLSTMT * stmt);
int dbtcp_refresh(ClipMachine* cm,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap);
int dbtcp_start(ClipMachine* cm,SQLCONN* c,const char* p1,const char* p2);
int dbtcp_commit(ClipMachine* cm,SQLCONN* c);
int dbtcp_rollback(ClipMachine* cm,SQLCONN* c);
int dbtcp_fetch(ClipMachine* cm,SQLROWSET* rs,int recs,ClipVar* eval,int every,ClipVar* ors);

static SQLVTBL vtbl =
{
	sizeof(DBTCP_ROWSET),
	dbtcp_destroyconn,
	dbtcp_prepare,
	dbtcp_command,
	dbtcp_createrowset,
	dbtcp_testparser,
	dbtcp_getvalue,
	dbtcp_setvalue,
	dbtcp_append,
	dbtcp_delete,
	dbtcp_newid,
	dbtcp_refresh,
	NULL,
	dbtcp_start,
	dbtcp_commit,
	dbtcp_rollback,
	dbtcp_fetch,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL

};

void dbtcp_bindpars(DBTCP_STMT* stmt,ClipVar* ap){
	char* sql = stmt->sql;
	int initlen = strlen(sql);
	int len = initlen;
	int i;
	ClipVar *tp, *vp = 0;
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
		if(vp->t.type == CHARACTER_t){
			strcpy(t,vp->s.str.buf);
			t += strlen(vp->s.str.buf);
		} else {
			strcpy(t,"null");
			t += 4;
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

int clip_INIT_DBTCP(ClipMachine* mp){
	(*mp->nsqldrivers)++;
	*mp->sqldrivers = realloc(*mp->sqldrivers,sizeof(SQLDriver)*(*mp->nsqldrivers));
	strcpy((*mp->sqldrivers)[*mp->nsqldrivers-1].id,"DBTCP");
	strcpy((*mp->sqldrivers)[*mp->nsqldrivers-1].name,"DBTCP");
	strcpy((*mp->sqldrivers)[*mp->nsqldrivers-1].desc,"Generic DBTCP proxy for CLIP driver, v.1.0");
	(*mp->sqldrivers)[*mp->nsqldrivers-1].connect = dbtcp_createconn;
	return 0;
}

static void destroy_dbtcp_conn(void *c){
	DBTCP_CONN* conn = (DBTCP_CONN*)c;
	free_dbftp_result(conn->conn);
	free(conn);
	return;
}

static void destroy_dbtcp_stmt(void* s){
	DBTCP_STMT* stmt = (DBTCP_STMT*)s;
	if(stmt){
		if(stmt->sql)
			free(stmt->sql);
		free(stmt);
	}
}

static void destroy_dbtcp_rowset(void *r){
	DBTCP_ROWSET* rowset = (DBTCP_ROWSET*)r;
	int i, j;

	if(rowset){
		if(rowset->fields)
			free(rowset->fields);
		if(rowset->data){
			for(i=0;i<rowset->loaded;i++){
				for(j=0;j<rowset->nfields;j++){
					if(rowset->data[i][j])
						free(rowset->data[i][j]);
				}
				free(rowset->data[i]);
			}
			free(rowset->data);
		}
		free(rowset);
	}
	return;
}

void dbtcp_error(ClipMachine* cm,SQLLocale* loc,int code,dbftp_result* res,const char* str){
	char *err,*c,*e;
	if(res){
		err = strdup(dbftp_error_string(res));
		c = err;
		e = err+strlen(err);
		for(;c<e;c++)
			if(*c&0x80)
				*c = loc->read[*c&0x7f];
	} else {
		err = (char*)str;
	}
	_clip_trap_err(cm,0,0,0,subsys,code,err);
	if(res)
		free(err);
}

int dbtcp_createconn(ClipMachine* cm){
	char *host      = _clip_parc(cm,2);
	char *portstr   = _clip_parc(cm,3);
	char *user      = _clip_parc(cm,4);
	char *passwd    = _clip_parc(cm,5);
	char *db        = _clip_parc(cm,6);
	char* sqlcs     = _clip_parc(cm,9);
	/* char *trpars    = _clip_parc(cm,10);*/
	char buf[256];
	unsigned int port     = portstr ? atoi(portstr) : 0;
	DBTCP_CONN *conn      = NULL;
	dbftp_result* tmpconn = NULL;

	if(!host)   host = "";
	if(!db)		db = "";
	if(!user)   user = "";
	if(!passwd) passwd = "";
	if(!port) port = 3000;

	snprintf(buf,sizeof(buf),"DSN=%s;UID=%s;PWD=%s;",db,user,passwd);

	if(!(tmpconn = init_dbftp_result())) goto err;

	if(dbftp_connect(tmpconn,host,port,buf) != OK) goto err;

	conn = calloc(1,sizeof(DBTCP_CONN));
	conn->conn = tmpconn;
	conn->vtbl = &vtbl;

	return _clip_store_c_item(cm,(void*)conn,_C_ITEM_TYPE_SQL,destroy_dbtcp_conn);
err:
	dbtcp_error(cm,SQL_get_locale(cm,sqlcs),ER_CONNECT,tmpconn,er_connect);
	if(tmpconn)
		free_dbftp_result(tmpconn);
	if(conn)
		free(conn);
	return -1;
}

void dbtcp_destroyconn(SQLCONN* c){}

int dbtcp_prepare(ClipMachine* cm,SQLCONN* c,char* sql){
	DBTCP_CONN* conn = (DBTCP_CONN*)c;
	DBTCP_STMT* stmt;

	stmt = calloc(1,sizeof(DBTCP_STMT));
	stmt->stmt_item =
		_clip_store_c_item(cm,stmt,_C_ITEM_TYPE_SQL,destroy_dbtcp_stmt);

	stmt->sql = strdup(sql);
	stmt->conn = conn;

	return stmt->stmt_item;
}

int dbtcp_command(ClipMachine* cm,SQLSTMT* s,ClipVar* ap){
	DBTCP_STMT* stmt = (DBTCP_STMT*)s;
	DBTCP_CONN* conn = stmt->conn;

	dbtcp_bindpars(stmt,ap);
	if(dbftp_sql(conn->conn,stmt->sql) != OK) goto err;
	return 0;
err:
	dbtcp_error(cm,conn->loc,ER_BADSTATEMENT,conn->conn,NULL);
	return -1;
}

static char _dbtcp_ctype(int type){
	char r;
	switch(type){
		case 'C': r = 'C'; break;
		case 'N': r = 'N'; break;
		case 'D': r = 'D'; break;
		case 'd': r = 'T'; break;
		default: r = 'U'; break;
	}
	return r;
}

int dbtcp_createrowset(ClipMachine* cm,SQLROWSET* rs,ClipVar* ap,ClipVar* idname,const char* gen_idSQL){
	DBTCP_ROWSET* rowset = (DBTCP_ROWSET*)rs;
	DBTCP_STMT* stmt = rowset->stmt;
	DBTCP_CONN* conn = rowset->conn;
	int i;

	dbtcp_bindpars(stmt,ap);
	rowset->rowset_item =
		_clip_store_c_item(cm,rowset,_C_ITEM_TYPE_SQL,destroy_dbtcp_rowset);

	if(dbftp_sql(conn->conn,stmt->sql) != OK) goto err;
	rowset->nfields = dbftp_num_field(conn->conn);
	if(!rowset->nfields){
		dbtcp_error(cm,conn->loc,ER_NOSQL,NULL,er_nosql);
		return 1;
	}

	rowset->unknownrows = 1;
	rowset->lastrec = 0;
	rowset->fields = calloc(1,rowset->nfields * sizeof(SQLFIELD));
	if(dbftp_fetch_fields(conn->conn) != OK) goto err;
	for(i=0;i<rowset->nfields;i++){
		strncpy(rowset->fields[i].name,dbftp_field_name(conn->conn,i),MAXFIELDNAME);
		rowset->fields[i].name[MAXFIELDNAME] = 0;
		rowset->fields[i].type = dbftp_field_type(conn->conn,i);
		rowset->fields[i].ctype[0] = _dbtcp_ctype(rowset->fields[i].type);
		rowset->fields[i].len = dbftp_field_len(conn->conn,i);
		rowset->fields[i].ops = 0;

		if(idname->t.type == CHARACTER_t){
			if(idname->s.str.buf && !strcasecmp(rowset->fields[i].name,idname->s.str.buf)){
				rowset->id = i;
				rowset->nids = 1;
			}
		} else if(idname->t.type == ARRAY_t){
			int j;
			for(j=0;j<idname->a.count;j++){
				ClipVar* vp = idname->a.items+j;
				if(vp->t.type == CHARACTER_t && vp->s.str.buf
					&& !strcasecmp(rowset->fields[i].name,vp->s.str.buf)){

					rowset->nids++;
					rowset->ids = realloc(rowset->ids,rowset->nids*sizeof(int));
					rowset->ids[rowset->nids-1] = i;
				}
			}
		}
	}
	rowset->data = calloc(rowset->lastrec,sizeof(void*));
	return 0;
err:
	if(rowset->fields)
		free(rowset->fields);
	dbtcp_error(cm,conn->loc,ER_BADSTATEMENT,conn->conn,NULL);
	return 1;
}

char* dbtcp_testparser(ClipMachine* mp,char* sql,ClipVar* ap){
	DBTCP_STMT stmt;

	stmt.sql = sql;
	dbtcp_bindpars(&stmt,ap);
	return stmt.sql;
}

char* dbtcp_getvalue(SQLROWSET* rs,int fieldno,int *len){
	DBTCP_ROWSET* rowset = (DBTCP_ROWSET*)rs;
	if(rowset->data[rowset->recno-1][fieldno]){
		char* tmp = rowset->data[rowset->recno-1][fieldno];
		*len = *(int*)tmp;
		return (char*)(tmp+4);
	}
	return NULL;
}

void dbtcp_setvalue(SQLROWSET* rs,int fieldno,char* value,int len){
	DBTCP_ROWSET* rowset = (DBTCP_ROWSET*)rs;
	char** tmp = (char**)&rowset->data[rowset->recno-1][fieldno];

	if(*tmp)
		free(*tmp);
	if(value){
		*tmp = malloc(len + 4);
		*(int*)(*tmp) = len;
		memcpy(*tmp+4,value,len);
	} else {
		*tmp = NULL;
	}
}

void dbtcp_append(SQLROWSET* rs){
	DBTCP_ROWSET* rowset = (DBTCP_ROWSET*)rs;
	void **row;

	rowset->lastrec++;
	rowset->loaded++;
	rowset->data = realloc(rowset->data,sizeof(void*) * rowset->lastrec);

	row = calloc(rowset->nfields,sizeof(void*));
	rowset->data[rowset->lastrec-1] = row;
}

void dbtcp_delete(SQLROWSET* rs){
	DBTCP_ROWSET* rowset = (DBTCP_ROWSET*)rs;
	int i;

	for(i=0;i<rowset->nfields;i++){
		if(rowset->data[rowset->recno-1][i]){
			free(rowset->data[rowset->recno-1][i]);
		}
	}
	free(rowset->data[rowset->recno-1]);
	for(i=rowset->recno;i<rowset->lastrec;i++){
		rowset->data[i-1] = rowset->data[i];
	}
	rowset->data = realloc(rowset->data,sizeof(void*)*(rowset->lastrec-1));
}

void dbtcp_newid(ClipMachine * cm, SQLSTMT * stmt){}

int dbtcp_refresh(ClipMachine* cm,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap){
	DBTCP_ROWSET* rowset = (DBTCP_ROWSET*)rs;
	DBTCP_CONN* conn = rowset->conn;
	DBTCP_STMT* stmt = (DBTCP_STMT*)s;
	int r,i,nfields;
	void **rec;

	dbtcp_bindpars(stmt,ap);

	if(dbftp_sql(conn->conn,stmt->sql) != OK) goto err;
	nfields = dbftp_num_field(conn->conn);
	if(!nfields){
		dbtcp_error(cm,conn->loc,ER_NOSQL,NULL,er_nosql);
		return -1;
	}
	if(nfields != rowset->nfields){
		dbtcp_error(cm,conn->loc,ER_BADSELECT,NULL,er_badselect);
		return -1;
	}

	r = dbftp_fetch_row(conn->conn);
	if(r == FETCH_OK){
		rec = calloc(rowset->nfields,sizeof(void*));
		for(i=0;i<rowset->nfields;i++){
			char* tmp = dbftp_fetch_value(conn->conn,i);
			int len = strlen(tmp);
			rec[i] = calloc(1,len+sizeof(int));
			*(int*)rec[i] = len;
			memcpy((char*)rec[i]+4,tmp,len);
			if(rowset->data[rowset->recno-1][i])
				free(rowset->data[rowset->recno-1][i]);
		}
		free(rowset->data[rowset->recno-1]);
		rowset->data[rowset->recno-1] = rec;
	} else {
		dbtcp_delete((SQLROWSET*)rowset);
		rowset->lastrec--;
		if(rowset->recno > rowset->lastrec)
			rowset->recno = rowset->lastrec;
	}
	return 0;
err:
	dbtcp_error(cm,conn->loc,ER_BADSELECT,conn->conn,NULL);
	return -1;
}

int dbtcp_fetch(ClipMachine* cm,SQLROWSET* rs,int recs,ClipVar* eval,int every,ClipVar* ors){
	DBTCP_ROWSET* rowset = (DBTCP_ROWSET*)rs;
	DBTCP_CONN* conn = rowset->conn;
	DBTCP_STMT* stmt = rowset->stmt;
	int i,j,er = 0,r;
	void **rec;

	if(rowset->done)
		return 0;

	if(!recs)
		recs = 0x7fffffff;
	for(j=0;j<recs;j++){
		r = dbftp_fetch_row(conn->conn);
		if(r == FETCH_EOF)
			goto done;
		else if(r == FETCH_ERROR){
			dbtcp_error(cm,conn->loc,ER_FETCH,conn->conn,NULL);
			er = 1;
			goto done;
		}
		rowset->loaded++;
		rec = calloc(rowset->nfields,sizeof(void*));

		for(i=0;i<rowset->nfields;i++){
			char* tmp = dbftp_fetch_value(conn->conn,i);
			int len = strlen(tmp);
			rec[i] = calloc(1,len+sizeof(int));
			*(int*)rec[i] = len;
			memcpy((char*)rec[i]+4,tmp,len);
		}

		rowset->data = realloc(rowset->data,rowset->loaded*sizeof(void*));
		rowset->data[rowset->loaded - 1] = rec;
		if(eval && (eval->t.type == CCODE_t || eval->t.type == PCODE_t) && !(rowset->loaded % every)){
			ClipVar var,*v;
			if(_clip_eval(cm,eval,1,ors,&var)){
				_clip_destroy(cm,&var);
				er = 1;
				goto done;
			}
			v = _clip_vptr(&var);
			if(v->t.type == LOGICAL_t && !v->l.val){
				_clip_destroy(cm,&var);
				goto done;
			}
			_clip_destroy(cm,&var);
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
	_clip_destroy_c_item(cm,stmt->stmt_item,_C_ITEM_TYPE_SQL);
	return er;
}

int dbtcp_start(ClipMachine* cm,SQLCONN* c,const char* p1,const char* p2){
	DBTCP_CONN* conn = (DBTCP_CONN*)c;
	int r;

	if(conn->at){
		dbtcp_error(cm,conn->loc,ER_START,NULL,er_start);
		return 1;
	}
	r = dbftp_sql(conn->conn,"START");
	if(r != OK){
		dbtcp_error(cm,conn->loc,ER_START,conn->conn,NULL);
		return 1;
	}
	conn->at = 1;
	return 0;
}

int dbtcp_commit(ClipMachine* cm,SQLCONN* c){
	DBTCP_CONN* conn = (DBTCP_CONN*)c;
	int r;

	if(!conn->at){
		dbtcp_error(cm,conn->loc,ER_COMMIT,NULL,er_commit);
		return 1;
	}
	r = dbftp_sql(conn->conn,"COMMIT");
	conn->at = 0;
	if(r != OK){
		dbtcp_error(cm,conn->loc,ER_COMMIT,conn->conn,NULL);
		return 1;
	}
	return 0;
}

int dbtcp_rollback(ClipMachine* cm,SQLCONN* c){
	DBTCP_CONN* conn = (DBTCP_CONN*)c;
	int r;

	if(!conn->at){
		dbtcp_error(cm,conn->loc,ER_ROLLBACK,NULL,er_rollback);
		return 1;
	}
	r = dbftp_sql(conn->conn,"ROLLBACK");
	conn->at = 0;
	if(r != OK){
		dbtcp_error(cm,conn->loc,ER_ROLLBACK,conn->conn,NULL);
		return 1;
	}
	return 0;
}


