/*
	$Log: ms_clip.c,v $
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

#undef UNIQUE_FLAG
#include <mysql.h>

static const char subsys[] = "DBFSQL";
static const char er_connect[] = "Can't connect to database server";
static const char er_nosql[] = "No SQL statement";
static const char er_nostatement[] = "No statement (not prepared)";
static const char er_norowset[] = "No such rowset";

int ms_createconn(ClipMachine * mp);

struct tagMS_CONN;

typedef struct tagMS_STMT
{
	struct tagMS_STMT *next;
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
	struct tagMS_ROWSET *next;
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
MS_ROWSET;

/* Connection abstract structure */
typedef struct tagMS_CONN
{
	SQLVTBL *vtbl;
	MS_STMT *stmts;
	MS_ROWSET *rowsets;
	SQLLocale* loc;
	MYSQL *conn;
}
MS_CONN;

void ms_destroyconn(SQLCONN * conn);
int ms_prepare(ClipMachine * mp, SQLCONN * conn, char *sql);
int ms_command(ClipMachine * mp, SQLSTMT * stmt, ClipVar * ap);
int ms_createrowset(ClipMachine * mp, SQLROWSET* rs,SQLSTMT * stmt, ClipVar * ap,const char* idname,const char* gen_idSQL);
char *ms_testparser(ClipMachine * mp, char * sql, ClipVar * ap);
char *ms_getvalue(SQLROWSET * rowset, int fieldno, int *len);
void ms_setvalue(SQLROWSET * rowset, int fieldno, char *value, int len);
void ms_append(SQLROWSET * rowset);
void ms_delete(SQLROWSET * rowset);
void ms_newid(ClipMachine * mp, SQLSTMT * stmt);
int ms_refresh(ClipMachine* mp,SQLROWSET* rowset,SQLSTMT* stmt,ClipVar* ap,const char* idname);

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
	NULL
};

int clip_INIT_MYSQL(ClipMachine* mp){
	mp->ms_connect = ms_createconn;
	return 0;
}

static void
destroy_ms_stmt(void *stmt)
{

	if (stmt)
	{
		if (((MS_STMT *) (stmt))->res)
		{
			mysql_free_result(((MS_STMT *) (stmt))->res);
		}
		if (((MS_STMT *) (stmt))->sql)
		{
			free(((MS_STMT *) (stmt))->sql);
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
			for (i = 0; i < ((MS_ROWSET *) (rowset))->lastrec; i++)
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
	MS_ROWSET *currowset = ((MS_CONN *) (conn))->rowsets;
	MS_ROWSET *nextrowset;
	MS_STMT *curstmt = ((MS_CONN *) (conn))->stmts;
	MS_STMT *nextstmt;

	if (conn)
	{
		while (currowset)
		{
			nextrowset = currowset->next;
			destroy_ms_rowset(currowset);
			currowset = nextrowset;
		}
		while (curstmt)
		{
			nextstmt = curstmt->next;
			destroy_ms_stmt(curstmt);
			curstmt = nextstmt;
		}
		free(conn);
	}
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
ms_createconn(ClipMachine * mp)
{
	char *host = _clip_parc(mp, 2);
	char *portstr = _clip_parc(mp, 3);
	char *user = _clip_parc(mp, 4);
	char *passwd = _clip_parc(mp, 5);
	char *db = _clip_parc(mp, 6);
	char *socket = _clip_parc(mp, 7);
	char *flagstr = _clip_parc(mp, 8);
	unsigned int port = portstr ? atoi(portstr) : 0;
	unsigned int flag = flagstr ? atoi(flagstr) : 0;
	MS_CONN *conn;
	MYSQL *tmpconn;

	tmpconn = mysql_init(NULL);
	tmpconn = mysql_real_connect(tmpconn, host, user, passwd, db, port, socket, flag);
	if (!tmpconn)
	{
		_clip_trap_err(mp, 0, 0, 0, subsys, ER_CONNECT, er_connect);
		return -1;
	}

	conn = malloc(sizeof(MS_CONN));
	memset(conn, 0, sizeof(MS_CONN));
	conn->conn = tmpconn;
	conn->vtbl = &vtbl;

	return _clip_store_c_item(mp, (void *) conn, _C_ITEM_TYPE_SQL, destroy_ms_conn);
}

void
ms_destroyconn(SQLCONN * conn)
{
	mysql_close(((MS_CONN *) conn)->conn);
}

int
ms_prepare(ClipMachine * mp, SQLCONN * conn, char *sql)
{
	MS_STMT *stmt;

	stmt = malloc(sizeof(MS_STMT));
	memset(stmt, 0, sizeof(MS_STMT));
	stmt->stmt_item =
		_clip_store_c_item(mp, stmt, _C_ITEM_TYPE_SQL, destroy_ms_stmt);

	stmt->sql = malloc(strlen(sql) + 1);
	strcpy(stmt->sql, sql);

	stmt->conn = (MS_CONN *) conn;
	stmt->next = ((MS_CONN *) conn)->stmts;
	((MS_CONN *) conn)->stmts = stmt;

	return stmt->stmt_item;
}

int
ms_command(ClipMachine * mp, SQLSTMT * stmt, ClipVar * ap)
{
	int status;
	int rows;

	ms_bindpars((MS_STMT *) stmt, ap);
	status = mysql_query(((MS_STMT *) stmt)->conn->conn, ((MS_STMT *) stmt)->sql);
	if (status)
	{
		_clip_trap_err(mp, 0, 0, 0, subsys, ER_BADSTATEMENT,
				   mysql_error(((MS_STMT *) stmt)->conn->conn));
		return -1;
	}
	if((rows = mysql_affected_rows(((MS_STMT *) stmt)->conn->conn)) == -1){
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

int
ms_createrowset(ClipMachine * mp, SQLROWSET* rs, SQLSTMT * stmt, ClipVar * ap, const char* idname, const char* gen_idSQL)
{
	MS_ROWSET *rowset = (MS_ROWSET*)rs;
	int i;
	unsigned long *lens;
	void **rec;
	int status;
	MYSQL_FIELD *fields;
	MYSQL_ROW row;

	ms_bindpars((MS_STMT *) stmt, ap);
	rowset->rowset_item =
		_clip_store_c_item(mp, rowset, _C_ITEM_TYPE_SQL, destroy_ms_rowset);

	if (!((MS_STMT *) stmt)->sql)
	{
		_clip_trap_err(mp, 0, 0, 0, subsys, ER_NOSQL, er_nosql);
		return 1;
	}

	status = mysql_query(((MS_STMT *) stmt)->conn->conn, ((MS_STMT *) stmt)->sql);
	if (status)
	{
		_clip_trap_err(mp, 0, 0, 0, subsys, ER_BADSTATEMENT,
				   mysql_error(((MS_STMT *) stmt)->conn->conn));
		return 1;
	}
	((MS_STMT *) stmt)->res = mysql_use_result(((MS_STMT *) stmt)->conn->conn);
	rowset->nfields = mysql_field_count(((MS_STMT *) stmt)->conn->conn);
	if (!rowset->nfields)
	{
		_clip_trap_err(mp, 0, 0, 0, subsys, ER_BADSELECT,
				   mysql_error(((MS_STMT *) stmt)->conn->conn));
		return 1;
	}
	rowset->fields = calloc(1,rowset->nfields * sizeof(SQLFIELD));
	fields = mysql_fetch_fields(((MS_STMT *) stmt)->res);
	for (i = 0; i < rowset->nfields; i++)
	{
		strncpy(rowset->fields[i].name, fields[i].name, MAXFIELDNAME);
		rowset->fields[i].name[MAXFIELDNAME] = 0;
		rowset->fields[i].type = fields[i].type;
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
	rowset->lastrec = 0;
	rowset->data = malloc(0);
	while ((row = mysql_fetch_row(((MS_STMT *) stmt)->res)))
	{
		rowset->lastrec++;
		rowset->data = realloc(rowset->data, sizeof(void *) * rowset->lastrec);
		rec = malloc(sizeof(void *) * rowset->nfields);

		lens = mysql_fetch_lengths(((MS_STMT *) stmt)->res);
		for (i = 0; i < rowset->nfields; i++)
		{
			if (row[i])
			{
				rec[i] = malloc(lens[i] + 4);
				*((int *) (rec[i])) = (int) lens[i];
				memcpy(((char *) rec[i]) + 4, row[i], lens[i]);
			}
			else
			{
				rec[i] = NULL;
			}
		}
		rowset->data[rowset->lastrec - 1] = rec;
	}
	return 0;
}

int ms_refresh(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* s,ClipVar* ap,const char* idname){
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
		}
		ms_delete((SQLROWSET*)rowset);
		rowset->data[rowset->recno-1] = rec;
	} else {
		ms_delete((SQLROWSET*)rowset);
		rowset->lastrec--;
		if(rowset->recno > rowset->lastrec)
			rowset->recno = rowset->lastrec;
	}
	return 0;
}

char *
ms_getvalue(SQLROWSET * rowset, int fieldno, int *len)
{
	if (((MS_ROWSET *) rowset)->data[((MS_ROWSET *) rowset)->recno - 1][fieldno])
	{
		*len = *((int *) (((MS_ROWSET *) rowset)->data[
									  ((MS_ROWSET *) rowset)->recno - 1][fieldno]));
		return (char *) (((MS_ROWSET *) rowset)->data[
									 ((MS_ROWSET *) rowset)->recno - 1][fieldno]) + 4;
	}
	return NULL;
}

void
ms_setvalue(SQLROWSET * rowset, int fieldno, char *value, int len)
{

	if (((MS_ROWSET *) rowset)->data[((MS_ROWSET *) rowset)->recno - 1][fieldno])
	{
		free(((MS_ROWSET *) rowset)->data[
							 ((MS_ROWSET *) rowset)->recno - 1][fieldno]);
	}
	if (value)
	{
		((MS_ROWSET *) rowset)->data[
							((MS_ROWSET *) rowset)->recno - 1][fieldno] = malloc(len + 4);
		*((int *) (((MS_ROWSET *) rowset)->data[
								   ((MS_ROWSET *) rowset)->recno - 1][fieldno])) = len;
		memcpy(((char *) (((MS_ROWSET *) rowset)->data[
								   ((MS_ROWSET *) rowset)->recno - 1][fieldno])) + 4, value, len);
	}
	else
	{
		((MS_ROWSET *) rowset)->data[
							((MS_ROWSET *) rowset)->recno - 1][fieldno] = NULL;
	}

}

void
ms_append(SQLROWSET * rowset)
{
	void **row;
	int len;

	len = sizeof(void *) * ((MS_ROWSET *) rowset)->nfields;

	((MS_ROWSET *) rowset)->lastrec++;
	((MS_ROWSET *) rowset)->data = realloc(((MS_ROWSET *) rowset)->data,
						   sizeof(void *) * ((MS_ROWSET *) rowset)->lastrec);

	row = malloc(len);
	memset(row, 0, len);
	((MS_ROWSET *) rowset)->data[((MS_ROWSET *) rowset)->lastrec - 1] = row;
}

void
ms_delete(SQLROWSET * rowset)
{
	int i;

	for (i = 0; i < ((MS_ROWSET *) rowset)->nfields; i++)
	{
		if (((MS_ROWSET *) rowset)->data[((MS_ROWSET *) rowset)->recno - 1][i])
		{
			free(((MS_ROWSET *) rowset)->data[((MS_ROWSET *) rowset)->recno - 1][i]);
		}
	}
	free(((MS_ROWSET *) rowset)->data[((MS_ROWSET *) rowset)->recno - 1]);
	for (i = ((MS_ROWSET *) rowset)->recno; i < ((MS_ROWSET *) rowset)->lastrec; i++)
	{
		((MS_ROWSET *) rowset)->data[i - 1] = ((MS_ROWSET *) rowset)->data[i];
	}
	((MS_ROWSET *) rowset)->data = realloc(((MS_ROWSET *) rowset)->data,
						   sizeof(void *) * (((MS_ROWSET *) rowset)->lastrec - 1));
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
