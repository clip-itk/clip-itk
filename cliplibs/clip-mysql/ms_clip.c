/*
	$Log: ms_clip.c,v $
	Revision 1.27  2004/02/26 12:59:55  clip
	rust: bindpars with NIL
	
	Revision 1.26  2003/06/09 13:10:14  clip
	rust: multiple column PRIMARY KEY as row ID

	Revision 1.25  2003/04/29 08:51:12  clip
	rust: small fixes

	Revision 1.24  2003/04/09 08:48:09  clip
	rust: increase loaded rows counter on append

	Revision 1.23  2003/03/12 12:49:36  clip
	rust: tasks share SQL drivers

	Revision 1.22  2003/02/16 16:02:23  clip
	rust: bug in ms_refresh() fixed

	Revision 1.21  2003/02/14 10:08:39  clip
	rust: SQLFieldType() -> SQLFieldTypeSQL()

	Revision 1.20  2003/02/12 14:56:41  clip
	rust: small fix

	Revision 1.19  2002/12/25 14:45:07  clip
	rust: driver registration changed

	Revision 1.18  2002/12/21 11:34:05  clip
	rust: small fixes

	Revision 1.17  2002/11/26 10:56:38  clip
	rust: documentation is up-to-date

	Revision 1.16  2002/11/24 14:31:07  clip
	rust: transactions and smart rows fetching

	Revision 1.15  2002/09/11 12:29:00  clip
	build fixes
	paul

	Revision 1.14  2002/08/21 10:11:04  clip
	rust: firebird required some changes

	Revision 1.13  2002/07/03 12:54:37  clip
	rust: orders in TRowset

	Revision 1.12  2002/05/30 13:04:43  clip
	rust: TRowset:RefreshCurrent()

	Revision 1.11  2002/05/27 10:25:29  clip
	rust: some fixes and ODBC-ODBC bridge support

	Revision 1.10  2002/05/22 09:59:22  clip
	rust: error message

	Revision 1.9  2002/05/14 11:42:46  clip
	rust: parameters parser bug

	Revision 1.8  2002/05/13 10:53:44  clip
	rust: not_null, binary, unsigned flags

	Revision 1.7  2002/05/11 14:52:34  clip
	rust: charsets converting

	Revision 1.6  2002/04/09 12:26:56  clip
	rust: conn:CreateRowset(...,<id_field_name>)

	Revision 1.5  2002/04/08 08:08:35  clip
	rust: 'no statement' error message corrected

	Revision 1.4  2002/01/30 08:58:57  clip
	rust: clip_INIT_... procedure stores connect func's pointer into ClipMachine

	Revision 1.3  2002/01/29 09:51:58  clip
	rust: avoid external error messages

	Revision 1.2  2001/12/10 11:36:27  clip
	connect:TestParser(<sql>,<pars>) -> translated sql
	rust

	Revision 1.1  2001/11/29 10:39:55  clip
	separate clip-mysql package
	paul

*/

#include <string.h>
#include <time.h>

#include "clip.h"
#include "dbfsql.h"
#include "mysql.ch"

#undef UNIQUE_FLAG
#include <mysql.h>

static const char subsys[]          = "DBFSQL";
static const char er_connect[]      = "Can't connect to database server";
static const char er_nosql[]        = "No SQL statement";
static const char er_nostatement[]  = "No statement (not prepared)";
static const char er_norowset[]     = "No such rowset";
static const char er_start[]        = "Can't start transaction";
static const char er_commit[]       = "Can't commit transaction";
static const char er_rollback[]     = "Can't roll transaction back";

int ms_createconn(ClipMachine * mp);

struct tagMS_CONN;

typedef struct tagMS_STMT
{
	int stmt_item;
	struct tagMS_CONN *conn;
	char *sql;
	MYSQL_RES *res;
}
MS_STMT;

/* Rowset abstract structure */
typedef struct tagMS_ROWSET
{
	int rowset_item;
	struct tagMS_CONN *conn;
	struct tagMS_STMT *stmt;
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
MS_ROWSET;

/* Connection abstract structure */
typedef struct tagMS_CONN
{
	SQLVTBL *vtbl;
	SQLLocale* loc;
	int at;
	MYSQL *conn;
}
MS_CONN;

void ms_destroyconn(SQLCONN* conn);
int ms_prepare(ClipMachine* mp,SQLCONN* conn,char* sql);
int ms_command(ClipMachine* mp,SQLSTMT* stmt,ClipVar* ap);
int ms_createrowset(ClipMachine* mp,SQLROWSET* rs,ClipVar* ap,ClipVar* idname,const char* gen_idSQL);
char *ms_testparser(ClipMachine* mp,char* sql,ClipVar* ap);
char *ms_getvalue(SQLROWSET* rowset,int fieldno,int* len);
void ms_setvalue(SQLROWSET* rowset,int fieldno,char* value,int len);
void ms_append(SQLROWSET* rowset);
void ms_delete(SQLROWSET* rowset);
void ms_newid(ClipMachine* mp,SQLSTMT* stmt);
int ms_refresh(ClipMachine* mp,SQLROWSET* rowset,SQLSTMT* stmt,ClipVar* ap);
int ms_start(ClipMachine* mp,SQLCONN* conn,const char* p1,const char* p2);
int ms_commit(ClipMachine* mp,SQLCONN* conn);
int ms_rollback(ClipMachine* mp,SQLCONN* conn);
int ms_fetch(ClipMachine* mp,SQLROWSET* rs,int recs,ClipVar* eval,int every,ClipVar* ors);

static SQLVTBL vtbl =
{
	sizeof(MS_ROWSET),
	ms_destroyconn,
	ms_prepare,
	ms_command,
	ms_createrowset,
	ms_testparser,
	ms_getvalue,
	ms_setvalue,
	ms_append,
	ms_delete,
	ms_newid,
	ms_refresh,
	NULL,
	ms_start,
	ms_commit,
	ms_rollback,
	ms_fetch
};

int clip_INIT_MYSQL(ClipMachine* mp){
	(*mp->nsqldrivers)++;
	*mp->sqldrivers = realloc(*mp->sqldrivers,sizeof(SQLDriver)*(*mp->nsqldrivers));
	strcpy((*mp->sqldrivers)[*mp->nsqldrivers-1].id,"MS");
	strcpy((*mp->sqldrivers)[*mp->nsqldrivers-1].name,"MySQL");
	strcpy((*mp->sqldrivers)[*mp->nsqldrivers-1].desc,"Generic MySQL for CLIP driver, v.1.0");
	(*mp->sqldrivers)[*mp->nsqldrivers-1].connect = ms_createconn;
	return 0;
}

static void destroy_ms_stmt(void* s){
	MS_STMT* stmt = (MS_STMT*)s;

	if(stmt){
		if(stmt->res){
			mysql_free_result(stmt->res);
		}
		if(stmt->sql){
			free(stmt->sql);
		}
		free(stmt);
	}
}

/* Helper function used by _clip_destroy_c_item to release rowset. */
static void
destroy_ms_rowset(void *rowset)
{
	int i, j;

	if (rowset)
	{
		if (((MS_ROWSET *) (rowset))->fields)
		{
			free(((MS_ROWSET *) (rowset))->fields);
		}
		if (((MS_ROWSET *) (rowset))->data)
		{
			for (i = 0; i < ((MS_ROWSET *) (rowset))->loaded; i++)
			{
				for (j = 0; j < ((MS_ROWSET *) (rowset))->nfields; j++)
				{
					if (((MS_ROWSET *) (rowset))->data[i][j])
					{
						free(((MS_ROWSET *) (rowset))->data[i][j]);
					}
				}
				free(((MS_ROWSET *) (rowset))->data[i]);
			}
			free(((MS_ROWSET *) (rowset))->data);
		}
		free(rowset);
	}
	return;

}

/*
 Helper function used by _clip_destroy_c_item to release connect.
 All opened rowsets are released too.
*/
static void
destroy_ms_conn(void *conn)
{
	free(conn);
	return;
}

void
ms_bindpars(MS_STMT * stmt, ClipVar * ap)
{
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

int
ms_createconn(ClipMachine * mp)
{
	char *host = _clip_parc(mp, 2);
	char *portstr = _clip_parc(mp, 3);
	char *user = _clip_parc(mp, 4);
	char *passwd = _clip_parc(mp, 5);
	char *db = _clip_parc(mp, 6);
	char *socket = _clip_parc(mp, 7);
	char *flagstr = _clip_parc(mp, 8);
	char *trpars = _clip_parc(mp, 10);
	unsigned int port = portstr ? atoi(portstr) : 0;
	unsigned int flag = flagstr ? atoi(flagstr) : 0;
	MS_CONN *conn;
	MYSQL *tmpconn;
	char str[256];
	int status;

	tmpconn = mysql_init(NULL);
	tmpconn = mysql_real_connect(tmpconn, host, user, passwd, db, port, socket, flag);
	if (!tmpconn)
	{
		_clip_trap_err(mp, 0, 0, 0, subsys, ER_CONNECT, er_connect);
		return -1;
	}

	conn = calloc(1,sizeof(MS_CONN));
	conn->conn = tmpconn;
	conn->vtbl = &vtbl;

	if(!trpars)
		trpars = _clip_fetch_item(mp, _clip_hashstr("MS_ISOLATION_LEVEL"));
	if(!trpars)
		trpars = _clip_fetch_item(mp, _clip_hashstr("SQL_ISOLATION_LEVEL"));
	if(trpars){
		snprintf(str,sizeof(str),"set session transaction isolation level %s",trpars);
		status = mysql_query(conn->conn,str);
		if(status){
			_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,mysql_error(conn->conn));
			mysql_close(conn->conn);
			return -1;
		}
	}

	return _clip_store_c_item(mp, (void *) conn, _C_ITEM_TYPE_SQL, destroy_ms_conn);
}

void
ms_destroyconn(SQLCONN * conn)
{
	mysql_close(((MS_CONN *) conn)->conn);
}

int ms_prepare(ClipMachine* mp,SQLCONN* c,char* sql){
	MS_CONN* conn = (MS_CONN*)c;
	MS_STMT* stmt;

	stmt = malloc(sizeof(MS_STMT));
	memset(stmt, 0, sizeof(MS_STMT));
	stmt->stmt_item =
		_clip_store_c_item(mp, stmt, _C_ITEM_TYPE_SQL, destroy_ms_stmt);

	stmt->sql = malloc(strlen(sql) + 1);
	strcpy(stmt->sql, sql);

	stmt->conn = conn;

	return stmt->stmt_item;
}

int ms_command(ClipMachine* mp,SQLSTMT* s,ClipVar* ap){
	MS_STMT* stmt = (MS_STMT*)s;
	MS_CONN* conn = stmt->conn;
	int status;
	int rows;

	ms_bindpars(stmt,ap);
	status = mysql_query(conn->conn,stmt->sql);
	if(status){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,mysql_error(conn->conn));
		return -1;
	}
	if((rows = mysql_affected_rows(conn->conn)) == -1){
		_clip_trap_err(mp, 0, 0, 0, subsys, ER_BADSTATEMENT,
			"Unable to determine amount of affected rows");
		return -1;
	}
	return rows;
}

char* ms_testparser(ClipMachine* mp,char* sql,ClipVar* ap){
	MS_STMT stmt;

	stmt.sql = sql;
	ms_bindpars(&stmt,ap);
	return stmt.sql;
}

static char _ms_ctype(int type){
	switch(type){
		case MST_DECIMAL:
		case MST_TINY:
		case MST_SHORT:
		case MST_LONG:
		case MST_FLOAT:
		case MST_DOUBLE:
		case MST_LONGLONG:
		case MST_INT24:
		case MST_YEAR:
			return 'N';

		case MST_TINY_BLOB:
		case MST_MEDIUM_BLOB:
		case MST_LONG_BLOB:
		case MST_BLOB:
		case MST_VAR_STRING:
		case MST_STRING:
		case MST_ENUM:
		case MST_SET:
			return 'C';

		case MST_DATE:
		case MST_DATETIME:
		case MST_TIMESTAMP:
			return 'D';

		case MST_TIME:
			return 'A';
	}
	return 'U';
}

int ms_createrowset(ClipMachine* mp,SQLROWSET* rs,ClipVar* ap,ClipVar* idname,const char* gen_idSQL){
	MS_ROWSET* rowset = (MS_ROWSET*)rs;
	MS_STMT* stmt = rowset->stmt;
	MS_CONN* conn = rowset->conn;
	int i;
	int status;
	MYSQL_FIELD *fields;

	ms_bindpars(stmt,ap);
	rowset->rowset_item =
		_clip_store_c_item(mp,rowset,_C_ITEM_TYPE_SQL,destroy_ms_rowset);

	if(!stmt->sql){
		_clip_trap_err(mp, 0, 0, 0, subsys, ER_NOSQL, er_nosql);
		return 1;
	}

	status = mysql_query(conn->conn,stmt->sql);
	if(status){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,mysql_error(conn->conn));
		return 1;
	}
	stmt->res = mysql_use_result(conn->conn);
	rowset->unknownrows = 1;
	rowset->lastrec = mysql_num_rows(stmt->res);
	rowset->nfields = mysql_field_count(conn->conn);
	if(!rowset->nfields){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSELECT,mysql_error(conn->conn));
		return 1;
	}
	rowset->fields = calloc(1,rowset->nfields * sizeof(SQLFIELD));
	fields = mysql_fetch_fields(stmt->res);
	for(i=0;i<rowset->nfields;i++){
		strncpy(rowset->fields[i].name, fields[i].name, MAXFIELDNAME);
		rowset->fields[i].name[MAXFIELDNAME] = 0;
		rowset->fields[i].type = fields[i].type;
		rowset->fields[i].ctype[0] = _ms_ctype(rowset->fields[i].type);
		rowset->fields[i].len = fields[i].length;
		rowset->fields[i].dec = fields[i].decimals;
		rowset->fields[i].ops = 0;
		rowset->fields[i].unsign = fields[i].flags & UNSIGNED_FLAG;
		rowset->fields[i].notnull = fields[i].flags & NOT_NULL_FLAG;
		rowset->fields[i].binary = fields[i].flags & BINARY_FLAG;
		if (fields[i].flags & AUTO_INCREMENT_FLAG)
		{
			rowset->id = i;
		}
	}
	rowset->data = calloc(rowset->lastrec,sizeof(void*));
	return 0;
}

int ms_refresh(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap){
	MS_ROWSET *rowset = (MS_ROWSET*)rs;
	MS_STMT* stmt = (MS_STMT*)s;
	int i;
	unsigned long *lens;
	void **rec;
	int status;
	MYSQL_ROW row;

	ms_bindpars(stmt,ap);

	if(!stmt->sql){
		_clip_trap_err(mp, 0, 0, 0, subsys, ER_NOSQL, er_nosql);
		return -1;
	}

	status = mysql_query(stmt->conn->conn,stmt->sql);
	if(status){
		_clip_trap_err(mp, 0, 0, 0, subsys, ER_BADSTATEMENT,
			mysql_error(stmt->conn->conn));
		return -1;
	}
	stmt->res = mysql_use_result(stmt->conn->conn);

	row = mysql_fetch_row(stmt->res);
	if(row){
		rec = malloc(sizeof(void *) * rowset->nfields);

		lens = mysql_fetch_lengths(stmt->res);
		for(i=0;i<rowset->nfields;i++){
			if(row[i]){
				rec[i] = malloc(lens[i] + 4);
				*((int *) (rec[i])) = (int) lens[i];
				memcpy(((char *) rec[i]) + 4, row[i], lens[i]);
			} else {
				rec[i] = NULL;
			}
			if(rowset->data[rowset->recno-1][i])
				free(rowset->data[rowset->recno-1][i]);
		}
		free(rowset->data[rowset->recno-1]);
		rowset->data[rowset->recno-1] = rec;
	} else {
		ms_delete((SQLROWSET*)rowset);
		rowset->lastrec--;
		if(rowset->recno > rowset->lastrec)
			rowset->recno = rowset->lastrec;
	}
	return 0;
}

char* ms_getvalue(SQLROWSET* rs,int fieldno,int *len){
	MS_ROWSET* rowset = (MS_ROWSET*)rs;
	if(rowset->data[rowset->recno-1][fieldno]){
		*len = *(int*)rowset->data[rowset->recno-1][fieldno];
		return (char*)(rowset->data[rowset->recno-1][fieldno]) + 4;
	}
	return NULL;
}

void ms_setvalue(SQLROWSET* rs,int fieldno,char* value,int len){
	MS_ROWSET* rowset = (MS_ROWSET*)rs;
	if(rowset->data[rowset->recno-1][fieldno]){
		free(rowset->data[rowset->recno-1][fieldno]);
	}
	if(value){
		rowset->data[rowset->recno-1][fieldno] = malloc(len + 4);
		*(int*)rowset->data[rowset->recno-1][fieldno] = len;
		memcpy((char*)(rowset->data[rowset->recno-1][fieldno])+4,value,len);
	} else {
		rowset->data[rowset->recno-1][fieldno] = NULL;
	}
}

void
ms_append(SQLROWSET * rowset)
{
	void **row;
	int len;

	len = sizeof(void *) * ((MS_ROWSET *) rowset)->nfields;

	((MS_ROWSET *) rowset)->lastrec++;
	((MS_ROWSET *) rowset)->loaded++;
	((MS_ROWSET *) rowset)->data = realloc(((MS_ROWSET *) rowset)->data,
						   sizeof(void *) * ((MS_ROWSET *) rowset)->lastrec);

	row = malloc(len);
	memset(row, 0, len);
	((MS_ROWSET *) rowset)->data[((MS_ROWSET *) rowset)->lastrec - 1] = row;
}

void ms_delete(SQLROWSET* rs){
	MS_ROWSET* rowset = (MS_ROWSET*)rs;
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

void
ms_newid(ClipMachine * mp, SQLSTMT * stmt)
{
	int id = (int) mysql_insert_id(((MS_STMT *) stmt)->conn->conn);

	_clip_retni(mp, id);
}

int
clip_MS_IN_TIMESTAMP(ClipMachine * mp)
{
	char *date = _clip_parc(mp, 1);
	int day, mon, year;

	if (date)
	{
		date[8] = 0;
		day = atoi(&date[6]);
		date[6] = 0;
		mon = atoi(&date[4]);
		date[4] = 0;
		year = atoi(date);
		_clip_retdc(mp, year, mon, day);
	}
	return 0;
}

int
clip_MS_IN_DATE(ClipMachine * mp)
{
	char *date = _clip_parc(mp, 1);
	int day, mon, year;

	if (date)
	{
		date[10] = 0;
		day = atoi(&date[8]);
		date[7] = 0;
		mon = atoi(&date[5]);
		date[4] = 0;
		year = atoi(date);
		_clip_retdc(mp, year, mon, day);
	}
	return 0;
}

/* ------------------------------------------------------------------ */

int ms_fetch(ClipMachine* mp,SQLROWSET* rs,int recs,ClipVar* eval,int every,ClipVar* ors){
	MS_ROWSET* rowset = (MS_ROWSET*)rs;
	MS_STMT* stmt = rowset->stmt;
	MYSQL_ROW row;
	int i,j,er = 0;
	unsigned long *lens;
	void **rec;

	if(rowset->done)
		return 0;

	if(!recs)
		recs = 0x7fffffff;
	for(j=0;j<recs;j++){
		row = mysql_fetch_row(stmt->res);
		if(!row)
			goto done;
		rowset->loaded++;
		rec = calloc(rowset->nfields,sizeof(void*));

		lens = mysql_fetch_lengths(stmt->res);
		for(i=0;i<rowset->nfields;i++){
			if(row[i]){
				rec[i] = malloc(lens[i] + 4);
				*((int *) (rec[i])) = (int) lens[i];
				memcpy(((char *) rec[i]) + 4, row[i], lens[i]);
			} else {
				rec[i] = NULL;
			}
		}
		rowset->data = realloc(rowset->data,rowset->loaded*sizeof(void*));
		rowset->data[rowset->loaded - 1] = rec;
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

int ms_start(ClipMachine* mp,SQLCONN* c,const char* p1,const char* p2){
	MS_CONN* conn = (MS_CONN*)c;
	int status;

	if(conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_START,er_start);
		return 1;
	}
	if(p1){
		char str[256];
		snprintf(str,sizeof(str),"set transaction isolation level %s",p1);
		status = mysql_query(conn->conn,str);
		if(status){
			_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,mysql_error(conn->conn));
			return 1;
		}
	}
	status = mysql_query(conn->conn,"begin");
	if(status){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,mysql_error(conn->conn));
		return 1;
	}
	conn->at = 1;
	return 0;
}

int ms_commit(ClipMachine* mp,SQLCONN* c){
	MS_CONN* conn = (MS_CONN*)c;
	int status;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_COMMIT,er_commit);
		return 1;
	}
	status = mysql_query(conn->conn,"commit");
	conn->at = 0;
	if(status){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,mysql_error(conn->conn));
		return 1;
	}
	return 0;
}

int ms_rollback(ClipMachine* mp,SQLCONN* c){
	MS_CONN* conn = (MS_CONN*)c;
	int status;

	if(!conn->at){
		_clip_trap_err(mp,0,0,0,subsys,ER_COMMIT,er_commit);
		return 1;
	}
	conn->at = 0;
	status = mysql_query(conn->conn,"rollback");
	if(status){
		_clip_trap_err(mp,0,0,0,subsys,ER_BADSTATEMENT,mysql_error(conn->conn));
		return 1;
	}
	return 0;
}


