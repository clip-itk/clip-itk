#include "hash.h"
#include "btree.h"

#ifndef DBFSQL_H
#define DBFSQL_H

/* Errors (e:subCode) */
#define ER_NOLIB		1000
#define ER_CONNECT		1001
#define ER_NOCONNECT	1002
#define ER_NOSQL		1003
#define ER_NOSTATEMENT	1004
#define ER_BADSTATEMENT	1005
#define ER_BADSELECT	1006
#define ER_NOROWSET		1007
#define ER_NOFIELD		1008
#define ER_TYPEMISMATCH	1009
#define ER_RDBMSERROR	1010
#define ER_ORDEREXIST	1011
#define ER_NOORDER		1012
#define ER_BADORDERLEN	1013
#define ER_BADORDERTYPE	1014
#define ER_INTERNAL		1015

#define MAXFIELDNAME	20		// (without terminating zero)

#ifndef min
#define min(a,b) (a)<(b)?(a):(b)
#endif
#ifndef max
#define max(a,b) (a)<(b)?(a):(b)
#endif

struct tagSQLVTBL;

typedef struct
{
	unsigned char cmp[128];
	unsigned char upper[128];
	unsigned char lower[128];
	unsigned char read[128];
	unsigned char write[128];
}
SQLLocale;

typedef struct tagSQLFIELD {
	char name[MAXFIELDNAME+1];
	int type;
	int len;
	int dec;
	unsigned int ops;
	int buflen;
	int unsign;
	int notnull;
	int binary;
	void* cargo;
} SQLFIELD;

typedef struct tagSQLSTMT {
	struct tagSQLSTMT* next;
	int stmt_item;
	struct tagSQLCONN* conn;
} SQLSTMT;

struct tagSQLORDER;
typedef struct tagSQLROWSET {
	int rowset_item;
	struct tagSQLCONN* conn;
	struct tagSQLROWSET* next;
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
} SQLROWSET;

typedef struct tagSQLCONN {
	struct tagSQLVTBL* vtbl;
	struct tagSQLSTMT* stmts;
	struct tagSQLROWSET* rowsets;
	SQLLocale* loc;
} SQLCONN;

typedef struct tagSQLORDER {
	char* name;
	SQLLocale* loc;
	ClipVar* block;
	ClipVar* rmap;
	BTREE* bt;
	int len;
} SQLORDER;

typedef struct tagSQLVTBL {
	int sizeof_rowset;
	void (*destroyconn)(SQLCONN* conn);
	int (*prepare)(ClipMachine* mp,SQLCONN* conn,char* sql);
	int (*command)(ClipMachine* mp,SQLSTMT* stmt,ClipVar* ap);
	int (*createrowset)(ClipMachine* mp,SQLROWSET* rs,SQLSTMT* stmt,ClipVar* ap,const char* idname,const char* gen_idSQL);
	char* (*testparser)(ClipMachine* mp,char* sql,ClipVar* ap);
	char* (*getvalue)(SQLROWSET* rowset,int fieldno,int* len);
	void (*setvalue)(SQLROWSET* rowset,int fieldno,char* value,int len);
	void (*append)(SQLROWSET* rowset);
	void (*delete_)(SQLROWSET* rowset);
	void (*newid)(ClipMachine* mp,SQLSTMT* stmt);
	int (*refresh)(ClipMachine* mp,SQLROWSET* rowset,SQLSTMT* stmt,ClipVar* ap,const char* idname);
	int (*genid)(ClipMachine* mp,SQLROWSET* rowset);
} SQLVTBL;

SQLLocale * SQL_get_locale(ClipMachine * mp, const char* sqlcs);
int sql_createorder(ClipMachine* mp,ClipVar* rmap,SQLROWSET* rowset,char* tagname,ClipVar* expr,int len);
int sql_orderadd(ClipMachine* mp,SQLROWSET* rowset,long taghash);

#endif
