/*
	$Log: ib_clip.c,v $
	Revision 1.5  2002/10/08 07:57:28  clip
	rust: small fix
	
	Revision 1.4  2002/10/07 14:05:33  clip
	rust: bug in ib_createrowset() reported by <sneshka@online.bryansk.ru>

	Revision 1.3  2002/08/21 09:49:02  clip
	rust: all features implemented

	Revision 1.2  2002/08/02 13:44:12  clip
	rust: fixes

	Revision 1.1  2002/07/22 13:33:34  clip
	rust: Interbase started

*/
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include <ibase.h>
#include "clip.h"
#include "dbfsql.h"

#define DPB_SIZE 256

#define CHUNKSIZE 4096

/* ??? Array item's types (there is no such defines in ibase.h) */
#define DTYPE_SHORT     7
#define DTYPE_INT       8
#define DTYPE_INT64     16
#define DTYPE_FLOAT     10
#define DTYPE_DOUBLE    27
#define DTYPE_CHAR      14
#define DTYPE_VARCHAR   37
#define DTYPE_TIMESTAMP 35
#define DTYPE_DATE      12
#define DTYPE_TIME      13

#define CHECKERR(s,c,m,f,r) \
	if((s)[0] == 1 && (s)[1]){ \
		char err[1024]; \
		char mes[1024]; \
		char chunk[256]; \
		long* p = (s); \
		long sqlcode = isc_sqlcode((s)); \
		mes[0] = 0; \
		while(isc_interprete(chunk,&p)){ \
			strcat(mes,chunk); \
			strcat(mes,";"); \
		} \
		snprintf(err,sizeof(err),";%s:;SQLCODE = %d;%s;",(m),(int)sqlcode,mes); \
		_clip_trap_err(mp,0,0,0,subsys,(c),err); \
		if(f); \
		return (r); \
	}

static const char subsys[] = "DBFSQL";
static const char er_connect[] = "Can't connect to database server";
static const char er_internal[] = "Internal error";

struct tagIB_CONN;

static long _newid;

typedef struct tagIB_STMT
{
	struct tagIB_STMT *next;
	int stmt_item;
	struct tagIB_CONN *conn;
	char *sql;
	char *parsed_sql;
	int npars;
	char **pars;
	isc_stmt_handle res;
	isc_tr_handle tr;
	int ok;
}
IB_STMT;

/* Rowset abstract structure */
typedef struct tagIB_ROWSET
{
	int rowset_item;
	struct tagIB_CONN *conn;
	struct tagIB_ROWSET *next;
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
	char* gen_idSQL;
}
IB_ROWSET;

/* Connection abstract structure */
typedef struct tagIB_CONN
{
	SQLVTBL *vtbl;
	IB_STMT *stmts;
	IB_ROWSET *rowsets;
	SQLLocale* loc;
	isc_db_handle conn;
	ISC_STATUS status[20];
}
IB_CONN;

int ib_createconn(ClipMachine* mp);
void ib_destroyconn(SQLCONN* c);
int ib_prepare(ClipMachine* mp,SQLCONN* c,char* sql);
int ib_command(ClipMachine* mp,SQLSTMT* s,ClipVar* ap);
int ib_createrowset(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap,const char* idname,const char* gen_idSQL);
char* ib_testparser(ClipMachine* mp,char* sql,ClipVar* ap);
char* ib_getvalue(SQLROWSET* rs,int fieldno,int *len);
void ib_setvalue(SQLROWSET* rs,int fieldno,char *value,int len);
void ib_append(SQLROWSET* rs);
void ib_delete(SQLROWSET* rs);
void ib_newid(ClipMachine* mp,SQLSTMT* stmt);
int ib_refresh(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap,const char* idname);
int ib_genid(ClipMachine* mp,SQLROWSET* rs);


static SQLVTBL vtbl =
{
	sizeof(IB_ROWSET),
	ib_destroyconn,
	ib_prepare,
	ib_command,
	ib_createrowset,
	ib_testparser,
	ib_getvalue,
	ib_setvalue,
	ib_append,
	ib_delete,
	ib_newid,
	ib_refresh,
	ib_genid
};

int clip_INIT_FIREBIRD(ClipMachine* mp)
{
	mp->ib_connect = ib_createconn;
	return 0;
}

static void destroy_ib_stmt(void* s)
{
	IB_STMT* stmt = (IB_STMT*)s;
	if(stmt){
		if(stmt->ok)
			isc_dsql_free_statement(stmt->conn->status,&stmt->res,DSQL_drop);
		free(stmt->sql);
		free(stmt->parsed_sql);
		free(stmt);
	}
}

static void destroy_ib_rowset(void *r)
{
	IB_ROWSET* rowset = (IB_ROWSET*)r;
	int i,j;

	if(rowset){
		if(rowset->fields){
			for(i=0;i<rowset->nfields;i++){
				if(rowset->fields[i].cargo){
					free(rowset->fields[i].cargo);
				}
			}
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
		if(rowset->gen_idSQL)
			free(rowset->gen_idSQL);
		free(rowset);
	}
	return;
}

static void destroy_ib_conn(void *c)
{
	IB_CONN* conn = (IB_CONN*)c;
	IB_ROWSET* currowset = conn->rowsets;
	IB_ROWSET* nextrowset;
	IB_STMT* curstmt = conn->stmts;
	IB_STMT* nextstmt;

	if(conn)
	{
		while (currowset)
		{
			nextrowset = currowset->next;
			destroy_ib_rowset(currowset);
			currowset = nextrowset;
		}
		while (curstmt)
		{
			nextstmt = curstmt->next;
			destroy_ib_stmt(curstmt);
			curstmt = nextstmt;
		}
		free(conn);
	}
	return;
}

static void ib_parsepars(IB_STMT* stmt)
{
	char *s,*d;
	char quote = 0;

	stmt->parsed_sql = malloc(strlen(stmt->sql)+1);
	s = stmt->sql;
	d = stmt->parsed_sql;
	while(*s){
		if(quote){
			if(*s==quote)
				quote = 0;
		} else {
			if(*s == '\'' || *s == '"')
				quote = *s;
			if(*s == ':'){
				char* c;

				stmt->npars++;
				stmt->pars = realloc(stmt->pars,stmt->npars*sizeof(char*));
				stmt->pars[stmt->npars-1] = malloc(51);
				c = stmt->pars[stmt->npars-1];
				*d++ = '?';
				while(*(++s) && *s != ' ' && *s != ',' && *s != ')')
					*c++ = *s;
				*c = 0;
				if(!*s)
					break;
			}
		}
		*d++ = *s++;
	}
	*d = 0;
}

static int ib_bindpar(ClipMachine* mp,IB_STMT* stmt,char* parname,ClipVar* ap,XSQLVAR* v)
{
	int i;
	ClipVar *tp,*vp;

	if (!ap || ap->t.type != ARRAY_t) return 0;
	ap = _clip_vptr(ap);
	for(i=0;i<ap->a.count;i++){
		if(!&ap->a.items[i] || (ap->a.items[i].t.type != ARRAY_t)) return 0;
		tp = _clip_vptr(&ap->a.items[i]);
		if(tp->a.count < 2) return 0;
		vp = _clip_vptr(&tp->a.items[1]);
		tp = _clip_vptr(&tp->a.items[0]);
		if(tp->t.type == CHARACTER_t){
			if(!strcasecmp(tp->s.str.buf,parname)){
				v->sqlind = calloc(1,sizeof(void*));
				switch(vp->t.type){
					case CHARACTER_t:
						if((v->sqltype & ~0x1) == SQL_BLOB){
							int l = 0;
							isc_blob_handle bh = NULL;
							ISC_QUAD* bid = calloc(1,sizeof(ISC_QUAD));
							isc_create_blob2(stmt->conn->status,
								&stmt->conn->conn,&stmt->tr,&bh,bid,0,NULL);
							CHECKERR(stmt->conn->status,ER_CONNECT,er_connect,(free(bid),0),-1);
							while(l<vp->s.str.len){
								isc_put_segment(stmt->conn->status,&bh,
									min(CHUNKSIZE,vp->s.str.len-l),
									vp->s.str.buf+l);
							CHECKERR(stmt->conn->status,ER_CONNECT,er_connect,(free(bid),0),-1);
								l += CHUNKSIZE;
							}
							isc_close_blob(stmt->conn->status,&bh);
							CHECKERR(stmt->conn->status,ER_CONNECT,er_connect,(free(bid),0),-1);

							v->sqldata = (char*)bid;
						} else if((v->sqltype & ~0x1) == SQL_ARRAY){
							ISC_ARRAY_DESC ad;
							ISC_QUAD* aid = calloc(1,sizeof(ISC_QUAD));
							long size;
							int k;

							isc_array_lookup_bounds(stmt->conn->status,&stmt->conn->conn,
								&stmt->tr,v->relname,v->sqlname,
								&ad);
							CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);

							size = ad.array_desc_length+2;
							for(k=0;k<ad.array_desc_dimensions;k++)
								size *=
									ad.array_desc_bounds[k].array_bound_upper
									- ad.array_desc_bounds[k].array_bound_lower+1;

							isc_array_put_slice(stmt->conn->status,&stmt->conn->conn,
								&stmt->tr,aid,&ad,vp->s.str.buf,&size);
							CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);

							v->sqldata = (char*)aid;
						} else {
							v->sqltype = SQL_TEXT;
							v->sqllen = vp->s.str.len;
							v->sqldata = vp->s.str.buf;
						}
						break;
					case NUMERIC_t:
						v->sqltype = SQL_DOUBLE;
						v->sqllen = sizeof(double);
						v->sqldata = (char*)&vp->n.d;
						break;
					case DATE_t:
						vp->d.julian -= 2400001;
						v->sqltype = SQL_TYPE_DATE;
						v->sqllen = sizeof(long);
						v->sqldata = (char*)&vp->d.julian;
						break;
					case DATETIME_t:
						vp->dt.time *= 10;
						if(vp->d.julian)
							vp->d.julian -= 2400001;
						v->sqltype = SQL_TIMESTAMP;
						v->sqllen = 2*sizeof(long);
						v->sqldata = (char*)&vp->dt.julian;
						break;
					default:
						*v->sqlind = 1;
						break;
				}
				return 0;
			}
		}
	}
	return 0;
}

static void ib_freepars(IB_STMT* stmt,XSQLDA* p)
{
	int i;
	for(i=0;i<stmt->npars;i++){
		if(p->sqlvar[i].sqltype == SQL_BLOB || p->sqlvar[i].sqltype == SQL_ARRAY)
			free(p->sqlvar[i].sqldata);
		free(p->sqlvar[i].sqlind);
	}
	free(p);
}

int ib_createconn(ClipMachine* mp)
{
	char *user = _clip_parc(mp, 4);
	char *passwd = _clip_parc(mp, 5);
	char *db = _clip_parc(mp, 6);
	IB_CONN* conn = (IB_CONN*)calloc(1,sizeof(IB_CONN));
	char dpb_buffer[256],*dpb,*p;

	conn->conn = 0;
	dpb = dpb_buffer;
	*dpb++ = isc_dpb_version1;
	*dpb++ = isc_dpb_user_name;
	*dpb++ = strlen(user);
	for (p = user; *p;)
		*dpb++ = *p++;
	*dpb++ = isc_dpb_password;
	*dpb++ = strlen(passwd);
	for (p = passwd; *p;)
		*dpb++ = *p++;

	isc_attach_database(conn->status,0,db,&conn->conn,dpb-dpb_buffer,dpb_buffer);

	CHECKERR(conn->status,ER_CONNECT,er_connect,(free(conn),0),-1);

	conn->vtbl = &vtbl;
	return _clip_store_c_item(mp, (void *) conn, _C_ITEM_TYPE_SQL, destroy_ib_conn);
}

void ib_destroyconn(SQLCONN* c)
{
	IB_CONN* conn = (IB_CONN*)c;

	isc_detach_database(conn->status,&conn->conn);
}

int ib_prepare(ClipMachine* mp,SQLCONN* c,char* sql)
{
	IB_CONN* conn = (IB_CONN*)c;
	IB_STMT* stmt;

	stmt = calloc(1,sizeof(IB_STMT));

	stmt->sql = malloc(strlen(sql)+1);
	strcpy(stmt->sql,sql);

	isc_dsql_allocate_statement(conn->status,&conn->conn,&stmt->res);
	CHECKERR(conn->status,ER_INTERNAL,er_internal,
		(free(stmt->sql),free(stmt),0),-1);

	isc_start_transaction(conn->status,&stmt->tr,1,&conn->conn,0,NULL);
	CHECKERR(conn->status,ER_INTERNAL,er_internal,
		(free(stmt->sql),free(stmt),0),-1);

	ib_parsepars(stmt);

	isc_dsql_prepare(conn->status,&stmt->tr,&stmt->res,0,stmt->parsed_sql,
		SQL_DIALECT_CURRENT,NULL);
	CHECKERR(conn->status,ER_INTERNAL,er_internal,
		(free(stmt->sql),free(stmt->parsed_sql),free(stmt),0),-1);

	stmt->conn = conn;
	stmt->next = conn->stmts;
	conn->stmts = stmt;

	stmt->stmt_item =
		_clip_store_c_item(mp,stmt,_C_ITEM_TYPE_SQL,destroy_ib_stmt);
	return stmt->stmt_item;
}

int ib_command(ClipMachine* mp,SQLSTMT* s,ClipVar* ap)
{
	IB_STMT* stmt = (IB_STMT*)s;
	XSQLDA* ip;
	int i;

	ip = malloc(XSQLDA_LENGTH(stmt->npars));
	ip->version = SQLDA_VERSION1;
	ip->sqln = stmt->npars;
	isc_dsql_describe_bind(stmt->conn->status,&stmt->res,1,ip);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(free(ip),0),-1);

	for(i=0;i<stmt->npars;i++){
		if(ib_bindpar(mp,stmt,stmt->pars[i],ap,ip->sqlvar+i)) return -1;
	}

	isc_dsql_execute(stmt->conn->status,&stmt->tr,&stmt->res,1,ip);
	ib_freepars(stmt,ip);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
	stmt->ok = 1;

	isc_commit_transaction(stmt->conn->status,&stmt->tr);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);

	return 0;
}

int ib_createrowset(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap,const char* idname,const char* gen_idSQL)
{
	IB_ROWSET *rowset = (IB_ROWSET*)rs;
	IB_STMT* stmt = (IB_STMT*)s;
	XSQLDA *ip,*op;
	ISC_STATUS r;
	int i;
	void **rec;
	short* ind;

	ip = malloc(XSQLDA_LENGTH(stmt->npars));
	ip->version = SQLDA_VERSION1;
	ip->sqln = stmt->npars;
	isc_dsql_describe_bind(stmt->conn->status,&stmt->res,1,ip);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(free(ip),0),-1);

	for(i=0;i<stmt->npars;i++){
		if(ib_bindpar(mp,stmt,stmt->pars[i],ap,ip->sqlvar+i)) return -1;
	}

	isc_dsql_execute(stmt->conn->status,&stmt->tr,&stmt->res,1,ip);
	ib_freepars(stmt,ip);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
	stmt->ok = 1;

	rowset->rowset_item =
		_clip_store_c_item(mp, rowset, _C_ITEM_TYPE_SQL, destroy_ib_rowset);

	op = malloc(XSQLDA_LENGTH(1));
	op->version = SQLDA_VERSION1;
	op->sqln = 1;
	isc_dsql_describe(stmt->conn->status,&stmt->res,1,op);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(free(op),op=0,0),-1);

	if(op->sqln < op->sqld){
		op = realloc(op,XSQLDA_LENGTH(op->sqld));
		op->sqln = op->sqld;
		isc_dsql_describe(stmt->conn->status,&stmt->res,1,op);
		CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(free(op),op=0,0),-1);
	}

	rowset->nfields = op->sqld;
	rowset->fields = calloc(rowset->nfields,sizeof(SQLFIELD));
	rec = calloc(rowset->nfields,sizeof(void*));
	ind = calloc(rowset->nfields,sizeof(short));
	for(i=0;i<rowset->nfields;i++){
		strncpy(rowset->fields[i].name,op->sqlvar[i].aliasname,MAXFIELDNAME);
		rowset->fields[i].type = op->sqlvar[i].sqltype & ~(0x1);
		rowset->fields[i].len = op->sqlvar[i].sqllen;
		rowset->fields[i].dec = -op->sqlvar[i].sqlscale;

		rec[i] = calloc(1,rowset->fields[i].len+sizeof(int)
			+((rowset->fields[i].type==SQL_TEXT)
			||(rowset->fields[i].type==SQL_VARYING)));
		op->sqlvar[i].sqldata = (char*)rec[i]+sizeof(int);
		rowset->fields[i].notnull = !(op->sqlvar[i].sqltype & 1);
		if(!rowset->fields[i].notnull)
			op->sqlvar[i].sqlind = &(ind[i]);
		if(idname && !strcasecmp(rowset->fields[i].name,idname))
			rowset->id = i;
		if(rowset->fields[i].type == SQL_BLOB
			|| rowset->fields[i].type == SQL_ARRAY
			|| rowset->fields[i].type == SQL_QUAD)
			rowset->fields[i].binary = 1;
		if(rowset->fields[i].type == SQL_ARRAY){
			ISC_ARRAY_DESC* ad = calloc(1,sizeof(ISC_ARRAY_DESC));
			int k;

			rowset->fields[i].cargo = ad;
			isc_array_lookup_bounds(stmt->conn->status,&stmt->conn->conn,
				&stmt->tr,op->sqlvar[i].relname,op->sqlvar[i].sqlname,
				ad);
			CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
			rowset->fields[i].ops = ad->array_desc_length+2;
			for(k=0;k<ad->array_desc_dimensions;k++)
				rowset->fields[i].ops *= ad->array_desc_bounds[k].array_bound_upper
					- ad->array_desc_bounds[k].array_bound_lower + 1;
		}
	}
	rowset->lastrec = 0;
	rowset->data = malloc(0);
	while((r=isc_dsql_fetch(stmt->conn->status,&stmt->res,1,op))==0){
		for(i=0;i<rowset->nfields;i++){
			if(!rowset->fields[i].notnull && ind[i]){
				free(rec[i]);
				rec[i] = NULL;
			} else {
				if(rowset->fields[i].type == SQL_TEXT)
					*(int*)(rec[i]) = strlen((char*)(rec[i])+4);
				else if(rowset->fields[i].type == SQL_BLOB){
					isc_blob_handle bh = NULL;
					char chunk[CHUNKSIZE];
					unsigned short cl;
					isc_open_blob2(stmt->conn->status,&stmt->conn->conn,
						&stmt->tr,&bh,(ISC_QUAD*)((char*)(rec[i])+4),0,NULL);
					CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
					*(int*)(rec[i]) = 0;
					do {
						isc_get_segment(stmt->conn->status,&bh,&cl,sizeof(chunk),
							chunk);
						if(stmt->conn->status[1] != isc_segment)
							CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
						rec[i] = realloc(rec[i],*(int*)rec[i] + 4 + cl);
						memcpy((char*)rec[i] + 4 + *(int*)rec[i],chunk,cl);
						*(int*)(rec[i]) += cl;
					} while(cl == sizeof(chunk));
					isc_close_blob(stmt->conn->status,&bh);
					CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
				} else if(rowset->fields[i].type == SQL_ARRAY){
					ISC_ARRAY_DESC* ad = (ISC_ARRAY_DESC*)rowset->fields[i].cargo;
					void* a = calloc(1,rowset->fields[i].ops);
					long l = rowset->fields[i].ops;
					isc_array_get_slice(stmt->conn->status,&stmt->conn->conn,
						&stmt->tr,(ISC_QUAD*)((char*)(rec[i])+4),ad,
						(char*)a,&l);
					CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
					free(rec[i]);
					rec[i] = a;
				} else
					*(int*)rec[i] = op->sqlvar[i].sqllen;
			}
		}
		rowset->lastrec++;
		rowset->data = realloc(rowset->data,sizeof(void*)*rowset->lastrec);
		rowset->data[rowset->lastrec-1] = rec;
		rec = calloc(rowset->nfields,sizeof(void*));
		for(i=0;i<rowset->nfields;i++){
			rec[i] = calloc(1,rowset->fields[i].len+sizeof(int)
				+(rowset->fields[i].type==SQL_TEXT)
				||(rowset->fields[i].type==SQL_VARYING));
			op->sqlvar[i].sqldata = (char*)rec[i]+sizeof(int);
		}
	}
	for(i=0;i<rowset->nfields;i++)
		free(rec[i]);
	free(rec);
	free(ind);
	free(op);
	if(r != 100){
		CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
	}
	isc_commit_transaction(stmt->conn->status,&stmt->tr);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);

	if(gen_idSQL && gen_idSQL[0])
		rowset->gen_idSQL = strdup(gen_idSQL);
	return 0;
}

char* ib_testparser(ClipMachine* mp,char* sql,ClipVar* ap)
{
	IB_STMT stmt;

	stmt.sql = sql;
	ib_parsepars(&stmt);
	return stmt.parsed_sql;
}

char* ib_getvalue(SQLROWSET* rs,int fieldno,int *len)
{
	IB_ROWSET* rowset = (IB_ROWSET*)rs;
	if(rowset->data[rowset->recno - 1][fieldno]){
		if(rowset->fields[fieldno].type == SQL_ARRAY){
			*len = rowset->fields[fieldno].ops;
			return (char*)rowset->data[rowset->recno-1][fieldno];
		} else{
			*len = *(int*)rowset->data[rowset->recno-1][fieldno];
			return (char*)rowset->data[rowset->recno-1][fieldno]+4;
		}
	}
	return NULL;
}

void ib_setvalue(SQLROWSET* rs,int fieldno,char *value,int len)
{
	IB_ROWSET* rowset = (IB_ROWSET*)rs;

	if(rowset->data[rowset->recno - 1][fieldno]){
		free(rowset->data[rowset->recno - 1][fieldno]);
	}
	if(value){
		if(rowset->fields[fieldno].type == SQL_ARRAY){
			rowset->data[rowset->recno - 1][fieldno] = malloc(len);
			memcpy((char*)rowset->data[rowset->recno - 1][fieldno],value,len);
		} else {
			rowset->data[rowset->recno - 1][fieldno] = malloc(len + 4);
			*(int*)rowset->data[rowset->recno - 1][fieldno] = len;
			memcpy((char*)rowset->data[rowset->recno - 1][fieldno] + 4,value,len);
		}
	} else {
		rowset->data[rowset->recno - 1][fieldno] = NULL;
	}

}

void ib_append(SQLROWSET* rs)
{
	IB_ROWSET* rowset = (IB_ROWSET*)rs;
	void **row;

	rowset->lastrec++;
	rowset->data = realloc(rowset->data,sizeof(void*) * (rowset->lastrec));

	row = calloc(rowset->nfields,sizeof(void*));
	rowset->data[rowset->lastrec - 1] = row;
}

void ib_delete(SQLROWSET* rs)
{
	IB_ROWSET* rowset = (IB_ROWSET*)rs;
	int i;

	for(i=0;i<rowset->nfields;i++){
		if(rowset->data[rowset->recno-1][i])
			free(rowset->data[rowset->recno-1][i]);
	}
	free(rowset->data[rowset->recno-1]);
	memmove((char*)rowset->data + (rowset->recno-1)*sizeof(void*),
		(char*)rowset->data + rowset->recno*sizeof(void*),
		(rowset->lastrec-rowset->recno)*sizeof(void*));

	rowset->data = realloc(rowset->data,sizeof(void*) * (rowset->lastrec-1));
}

void ib_newid(ClipMachine* mp,SQLSTMT* stmt)
{
	_clip_retni(mp,_newid);
}

int ib_refresh(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap,const char* idname)
{
	IB_ROWSET* rowset = (IB_ROWSET*)rs;
	IB_STMT* stmt = (IB_STMT*)s;
	XSQLDA *ip,*op;
	ISC_STATUS r;
	int i;
	void **rec;
	short* ind;

	ip = malloc(XSQLDA_LENGTH(stmt->npars));
	ip->version = SQLDA_VERSION1;
	ip->sqln = stmt->npars;
	isc_dsql_describe_bind(stmt->conn->status,&stmt->res,1,ip);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(free(ip),0),-1);

	for(i=0;i<stmt->npars;i++){
		if(ib_bindpar(mp,stmt,stmt->pars[i],ap,ip->sqlvar+i)) return -1;
	}

	isc_dsql_execute(stmt->conn->status,&stmt->tr,&stmt->res,1,ip);
	ib_freepars(stmt,ip);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
	stmt->ok = 1;

	op = malloc(XSQLDA_LENGTH(1));
	op->version = SQLDA_VERSION1;
	op->sqln = 1;
	isc_dsql_describe(stmt->conn->status,&stmt->res,1,op);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(free(op),op=0,0),-1);

	if(op->sqln < op->sqld){
		op = realloc(op,XSQLDA_LENGTH(op->sqld));
		op->sqln = op->sqld;
		isc_dsql_describe(stmt->conn->status,&stmt->res,1,op);
		CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(free(op),op=0,0),-1);
	}

	rec = calloc(rowset->nfields,sizeof(void*));
	ind = calloc(rowset->nfields,sizeof(short));
	for(i=0;i<rowset->nfields;i++){
		rec[i] = calloc(1,rowset->fields[i].len+sizeof(int)+(rowset->fields[i].type==SQL_TEXT));
		op->sqlvar[i].sqldata = (char*)rec[i]+sizeof(int);
		if(!rowset->fields[i].notnull)
			op->sqlvar[i].sqlind = &(ind[i]);
	}
	r=isc_dsql_fetch(stmt->conn->status,&stmt->res,1,op);
	for(i=0;i<rowset->nfields;i++){
		if(!rowset->fields[i].notnull && ind[i]){
			free(rec[i]);
			rec[i] = NULL;
		} else {
			if(rowset->fields[i].type == SQL_TEXT)
				*(int*)rec[i] = strlen((char*)rec[i]+4);
			else
				*(int*)rec[i] = op->sqlvar[i].sqllen;
		}
	}
	if(!r){
		for(i=0;i<rowset->nfields;i++)
			free(rowset->data[rowset->recno-1][i]);
		free(rowset->data[rowset->recno-1]);
		rowset->data[rowset->recno-1] = rec;
	} else {
		for(i=0;i<rowset->nfields;i++)
			free(rec[i]);
		free(rec);
		ib_delete((SQLROWSET*)rowset);
		rowset->lastrec--;
		if(rowset->recno > rowset->lastrec)
			rowset->recno = rowset->lastrec;
	}
	free(ind);
	free(op);
	if(r != 100){
		CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
	}
	isc_commit_transaction(stmt->conn->status,&stmt->tr);
	CHECKERR(stmt->conn->status,ER_INTERNAL,er_internal,(0),-1);
	return 0;
}

int ib_genid(ClipMachine* mp,SQLROWSET* rs)
{
	IB_ROWSET* rowset = (IB_ROWSET*)rs;
	isc_tr_handle tr = 0;
	XSQLDA* op;
	isc_stmt_handle stmt = 0;
	short ind;

	if(rowset->gen_idSQL){
		isc_dsql_allocate_statement(rowset->conn->status,&rowset->conn->conn,&stmt);
		CHECKERR(rowset->conn->status,ER_INTERNAL,er_internal,(0),1);

		isc_start_transaction(rowset->conn->status,&tr,1,&rowset->conn->conn,0,NULL);
		CHECKERR(rowset->conn->status,ER_INTERNAL,er_internal,(0),1);

		op = malloc(XSQLDA_LENGTH(1));
		op->version = SQLDA_VERSION1;
		op->sqln = 1;

		isc_dsql_prepare(rowset->conn->status,&tr,&stmt,0,rowset->gen_idSQL,
			SQL_DIALECT_CURRENT,op);
		CHECKERR(rowset->conn->status,ER_INTERNAL,er_internal,(free(op),0),1);

		if((op->sqlvar[0].sqltype & ~1) != SQL_LONG){
			free(op);
			_clip_trap_err(mp,0,0,0,subsys,ER_INTERNAL,"Bad row id type (INTEGER expected)");
			return 1;
		}

		op->sqlvar[0].sqldata = (char*)&_newid;
		op->sqlvar[0].sqlind = &ind;

		isc_dsql_execute2(rowset->conn->status,&tr,&stmt,1,NULL,op);
		CHECKERR(rowset->conn->status,ER_INTERNAL,er_internal,(free(op),0),1);
		if(ind)
			_newid = 0;

		isc_commit_transaction(rowset->conn->status,&tr);
		CHECKERR(rowset->conn->status,ER_INTERNAL,er_internal,(free(op),0),1);

		free(op);

		_clip_retni(mp,_newid);
	}
	return 0;
}

int clip_IB_IN_INT64(ClipMachine* mp){
	char* s = _clip_parc(mp,1);

	_clip_retnd(mp,(double)*(long long*)s);
	return 0;
}

int clip_IB_IN_LONG(ClipMachine* mp){
	char* s = _clip_parc(mp,1);

	_clip_retni(mp,*(long*)s);
	return 0;
}

int clip_IB_IN_SHORT(ClipMachine* mp){
	char* s = _clip_parc(mp,1);

	_clip_retni(mp,*(short*)s);
	return 0;
}

int clip_IB_IN_FLOAT(ClipMachine* mp){
	char* s = _clip_parc(mp,1);

	_clip_retnd(mp,*(float*)s);
	return 0;
}

int clip_IB_IN_DOUBLE(ClipMachine* mp){
	char* s = _clip_parc(mp,1);

	_clip_retnd(mp,*(double*)s);
	return 0;
}

int clip_IB_IN_DATE(ClipMachine* mp){
	char* d = _clip_parc(mp,1);

	_clip_retdj(mp,*(long*)d+2400001);
	return 0;
}

int clip_IB_IN_TIME(ClipMachine* mp){
	char* t = _clip_parc(mp,1);

	_clip_retdtj(mp,0,(*(long*)t)/10);
	return 0;
}

int clip_IB_IN_DATETIME(ClipMachine* mp){
	char* t = _clip_parc(mp,1);

	_clip_retdtj(mp,*(long*)t+2400001,(*(long*)(t+sizeof(long)))/10);
	return 0;
}

int clip_IB_IN_VARYING(ClipMachine* mp){
	char* v = _clip_parc(mp,1);

	_clip_retcn(mp,v+sizeof(short),*(short*)v);
	return 0;
}

/* -----------------------------------------------------*/

int clip_IB_OUT_INT64(ClipMachine* mp){
	long long ll = (long long)_clip_parnd(mp,1);

	_clip_retcn(mp,(char*)&ll,sizeof(long long));
	return 0;
}

int clip_IB_OUT_LONG(ClipMachine* mp){
	long l = (long)_clip_parnd(mp,1);

	_clip_retcn(mp,(char*)&l,sizeof(long));
	return 0;
}

int clip_IB_OUT_SHORT(ClipMachine* mp){
	short s = (short)_clip_parnd(mp,1);

	_clip_retcn(mp,(char*)&s,sizeof(short));
	return 0;
}

int clip_IB_OUT_FLOAT(ClipMachine* mp){
	float f = (float)_clip_parnd(mp,1);

	_clip_retcn(mp,(char*)&f,sizeof(float));
	return 0;
}

int clip_IB_OUT_DOUBLE(ClipMachine* mp){
	double d = _clip_parnd(mp,1);

	_clip_retcn(mp,(char*)&d,sizeof(double));
	return 0;
}

int clip_IB_OUT_DATE(ClipMachine* mp){
	long d = _clip_pardj(mp,1)-2400001;

	_clip_retcn(mp,(char*)&d,sizeof(long));
	return 0;
}

int clip_IB_OUT_TIME(ClipMachine* mp){
	long t;
	_clip_pardtj(mp,1,&t);

	t *= 10;
	_clip_retcn(mp,(char*)&t,sizeof(long));
	return 0;
}

int clip_IB_OUT_DATETIME(ClipMachine* mp){
	long dt[2];

	dt[0]  = _clip_pardtj(mp,1,&dt[1]);

	dt[0] -= 2400001;
	dt[1] *= 10;
	_clip_retcn(mp,(char*)dt,2*sizeof(long));
	return 0;
}

static int ib_outarrayitem(ClipMachine* mp,unsigned char dtype,int scale,void* r,ClipVar* v,int len,int ndims,long* dims)
{
	ClipVar* e = _clip_aref(mp,v,ndims,dims);

	if(!e) return 1;

	switch(dtype){
		case DTYPE_SHORT:
		{
			short i;
			double d = e->n.d;

			if(scale)
				d *= pow(10,scale);
			i = (short)d;
			memcpy(r,&i,len);
			break;
		}
		case DTYPE_INT:
		{
			int i;
			double d = e->n.d;

			if(scale)
				d *= pow(10,scale);
			i = (int)d;
			memcpy(r,&i,len);
			break;
		}
		case DTYPE_INT64:
		{
			long long i;
			double d = e->n.d;

			if(scale)
				d *= pow(10,scale);
			i = (long long)d;
			memcpy(r,&i,len);
			break;
		}
		case DTYPE_FLOAT:
		{
			float f = (float)e->n.d;
			memcpy(r,&f,len);
			break;
		}
		case DTYPE_DOUBLE:
		{
			memcpy(r,&e->n.d,len);
			break;
		}
		case DTYPE_CHAR:
		case DTYPE_VARCHAR:
			memset(r,0,len);
			memcpy(r,e->s.str.buf,e->s.str.len);
			break;
		case DTYPE_TIMESTAMP:
		{
			long dt[2];

			dt[0] = e->dt.julian - 2400001;
			dt[1] = e->dt.time * 10;
			memcpy(r,dt,len);
			break;
		}
		case DTYPE_DATE:
		{
			long d = (long)e->d.julian - 2400001;
			memcpy(r,&d,len);
			break;
		}
		case DTYPE_TIME:
		{
			long t;

			t = e->dt.time * 10;
			memcpy(r,&t,len);
			break;
		}
		default:
			return 1;
	}
	return 0;
}

static int ib_inarrayitem(ClipMachine* mp,unsigned char dtype,int scale,void* r,ClipVar* v,int len,int ndims,long* dims)
{
	ClipVar e;

	memset(&e,0,sizeof(ClipVar));
	switch(dtype){
		case DTYPE_SHORT:
		{
			e.t.type = NUMERIC_t;
			e.n.d = (double)*(short*)r;
			if(scale){
				e.n.d /= pow(10,scale);
				e.t.dec = scale;
			}
			if(_clip_aset(mp,v,&e,ndims,dims)) return 1;
			break;
		}
		case DTYPE_INT:
		{
			e.t.type = NUMERIC_t;
			e.n.d = (double)*(int*)r;
			if(scale){
				e.n.d /= pow(10,scale);
				e.t.dec = scale;
			}
			if(_clip_aset(mp,v,&e,ndims,dims)) return 1;
			break;
		}
		case DTYPE_INT64:
		{
			e.t.type = NUMERIC_t;
			e.n.d = (double)*(long long*)r;
			if(scale){
				e.n.d /= pow(10,scale);
				e.t.dec = scale;
			}
			if(_clip_aset(mp,v,&e,ndims,dims)) return 1;
			break;
		}
		case DTYPE_FLOAT:
		{
			e.t.type = NUMERIC_t;
			e.n.d = (double)*(float*)r;
			e.t.dec = mp->decimals;
			if(_clip_aset(mp,v,&e,ndims,dims)) return 1;
			break;
		}
		case DTYPE_DOUBLE:
		{
			e.t.type = NUMERIC_t;
			e.n.d = *(double*)r;
			e.t.dec = mp->decimals;
			if(_clip_aset(mp,v,&e,ndims,dims)) return 1;
			break;
		}
		case DTYPE_CHAR:
		case DTYPE_VARCHAR:
		{
			e.t.type = CHARACTER_t;
			e.s.str.buf = calloc(1,len+1);
			memcpy(e.s.str.buf,r,len);
			e.s.str.len = strlen(e.s.str.buf);
			if(_clip_aset(mp,v,&e,ndims,dims)) return 1;
			free(e.s.str.buf);
			break;
		}
		case DTYPE_TIMESTAMP:
		{
			long dt[2];

			e.t.type = DATETIME_t;
			memcpy(dt,r,len);
			e.dt.julian = dt[0] + 2400001;
			e.dt.time = dt[1] / 10;
			if(_clip_aset(mp,v,&e,ndims,dims)) return 1;
			break;
		}
		case DTYPE_DATE:
		{
			e.t.type = DATE_t;
			memcpy(&e.d.julian,r,len);
			e.d.julian += 2400001;
			if(_clip_aset(mp,v,&e,ndims,dims)) return 1;
			break;
		}
		case DTYPE_TIME:
		{
			e.t.type = DATETIME_t;
			e.dt.julian = 0;
			e.dt.time = *(long*)r / 10;
			if(_clip_aset(mp,v,&e,ndims,dims)) return 1;
			break;
		}
		default:
			return 1;
	}
	return 0;
}

static int ib_outarray(ClipMachine* mp,unsigned char dtype,int scale,void** r,ClipVar* v,int len,int ndims,long* bounds,long* dims,int dim)
{
	for(dims[dim]=0;dims[dim]<bounds[dim];dims[dim]++){
		if(dim == ndims-1){
			if(ib_outarrayitem(mp,dtype,scale,*r,v,len,ndims,dims)) return 1;
			(char*)*r += len + (dtype==37?2:0);
		} else {
			if(ib_outarray(mp,dtype,scale,r,v,len,ndims,bounds,dims,dim+1)) return 1;
		}
	}
	dims[dim] = 0;
	return 0;
}

static int ib_inarray(ClipMachine* mp,unsigned char dtype,int scale,void** r,ClipVar* v,int len,int ndims,long* bounds,long* dims,int dim)
{
	for(dims[dim]=0;dims[dim]<bounds[dim];dims[dim]++){
		if(dim == ndims-1){
			if(ib_inarrayitem(mp,dtype,scale,*r,v,len,ndims,dims)) return 1;
			(char*)*r += len + (dtype==37?2:0);
		} else {
			if(ib_inarray(mp,dtype,scale,r,v,len,ndims,bounds,dims,dim+1)) return 1;
		}
	}
	dims[dim] = 0;
	return 0;
}

int clip_IB_OUT_ARRAY(ClipMachine* mp){
	IB_ROWSET* rowset = (IB_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	ClipVar* v = _clip_par(mp,2);
	ISC_ARRAY_DESC* ad;
	int fieldno = _clip_parni(mp,3)-1;
	char *r,*rr;
	long bounds[16];
	long dims[16];
	int i;

	if(v->t.type != ARRAY_t){
		_clip_trap_err(mp,0,0,0,subsys,ER_INTERNAL,"Array expected");
		return 1;
	}

	rr = r = calloc(1,rowset->fields[fieldno].ops);
	ad = (ISC_ARRAY_DESC*)rowset->fields[fieldno].cargo;

	for(i=0;i<ad->array_desc_dimensions;i++){
		dims[i] = 0;
		bounds[i] = ad->array_desc_bounds[i].array_bound_upper
			- ad->array_desc_bounds[i].array_bound_lower+1;
	}

	if(ib_outarray(mp,ad->array_desc_dtype,-ad->array_desc_scale,(void**)&rr,v,ad->array_desc_length,ad->array_desc_dimensions,bounds,dims,0))
		return 1;

	_clip_retcn_m(mp,r,rowset->fields[fieldno].ops);
	return 0;
}

int clip_IB_IN_ARRAY(ClipMachine* mp){
	IB_ROWSET* rowset = (IB_ROWSET*)_clip_fetch_c_item(
		mp,_clip_parni(mp,1),_C_ITEM_TYPE_SQL);
	ClipVar* v = _clip_par(mp,2);
	ISC_ARRAY_DESC* ad;
	int fieldno = _clip_parni(mp,3)-1;
	ClipVar* a = RETPTR(mp);
	char *r;
	long bounds[16];
	long dims[16];
	int i;

	ad = (ISC_ARRAY_DESC*)rowset->fields[fieldno].cargo;

	for(i=0;i<ad->array_desc_dimensions;i++){
		dims[i] = 0;
		bounds[i] = ad->array_desc_bounds[i].array_bound_upper
			- ad->array_desc_bounds[i].array_bound_lower+1;
	}

	r = v->s.str.buf;
	_clip_array(mp,a,ad->array_desc_dimensions,bounds);
	if(ib_inarray(mp,ad->array_desc_dtype,-ad->array_desc_scale,(void**)&r,a,ad->array_desc_length,ad->array_desc_dimensions,bounds,dims,0))
		return 1;

	return 0;
}
