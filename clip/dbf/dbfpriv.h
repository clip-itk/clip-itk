/*
$Log: dbfpriv.h,v $
Revision 1.6  2000/06/14 02:07:19  clip
fix PACK with DBT file
Alex Vorontsov <axl@itk.ru>

Revision 1.5  2000/04/12 13:39:59  axl
make external eval for dbf

Revision 1.4  2000/03/13 20:11:52  axl
__RDDLOCATE & __RDDCONTINUE

Revision 1.3  2000/01/14 18:06:12  axl
Some changes :) (don't remember)

Revision 1.2  1999/10/26 19:19:07  axl
start cvs logging (./dbf)

*/


#ifndef DBFPRIV_H
#define DBFPRIV_H

#include "dbf.h"
#include "mapfile.h"

#define ERRBUFSIZE 256

#define NEW(type) ((type*)calloc(sizeof(type),1))

typedef struct DbfIndex
{
	char *tag;
	char *file;
	char *alias;

	char *expr;
	char *fexpr;

	char *filename;
	struct MapFile *mp;
	struct DbfIndex *main;

	int unique:1;
	int simple:1;

	int len;
	int dec;
	int type;

	char *keybuf;
	long keypos;

	int max_items;
	int half_page;
	int fld_no;
	int tag_no;

	void *par;
	void *data;

	DbfData *low;
	DbfData *hi;
}
DbfIndex;

typedef struct
{
	unsigned char *key;
	long value;
	int len;
	int size;
	long chield;

	int ok:1;
	int freemem:1;
}
Tuple;

typedef struct
{
	const char *name;
	const char *name_suffix;

	int (*destroy) (struct DbfFile * fp, DbfIndex * ip);

	int (*create) (struct DbfFile * fp, DbfIndex * ip);
	int (*open) (struct DbfFile * fp, DbfIndex * ip);
	int (*zap) (struct DbfFile * fp, DbfIndex * ip);

	int (*delkey) (struct DbfFile * fp, DbfIndex * ip, Tuple * tp);
	int (*addkey) (struct DbfFile * fp, DbfIndex * ip, Tuple * tp);

	int (*first) (struct DbfFile * fp, DbfIndex * ip);
	int (*last) (struct DbfFile * fp, DbfIndex * ip);
	int (*prev) (struct DbfFile * fp, DbfIndex * ip);
	int (*next) (struct DbfFile * fp, DbfIndex * ip);

	int (*seek) (struct DbfFile * fp, DbfIndex * ip, Tuple * tp);

}
DbfIndexVtbl;

typedef struct
{
	const char *name;
	const char *name_suffix;

	void *(*create) (void);
	int (*destroy) (void *self);
	int (*error) (void *self, char *errbuf, int errbuflen);

	int (*fcreate) (void *self, const char *name);
	int (*fopen) (void *self, const char *name, int wrflag);
	int (*frename) (void *self, const char *name);
	int (*fclose) (void *self);

	int (*get) (void *self, char **strp, int *lenp, long block);
	int (*put) (void *self, char *str, int len, long *block);
}
DbfMemoVtbl;

struct DbfFile
{
	char *name;
	struct MapFile *mp;
	long fileSize;
	int recSize;
	int headerSize;
	int type;
	DbfIndexVtbl *itbl;

	DbfMemoVtbl *mtbl;
	void *memo;

	char errbuf[ERRBUFSIZE];
	int nfield;
	DbfField *fields;
	int nindex;
	DbfIndex **indexes;
	DbfIndex *index;
	DbfCalcExpr calc;
	char *fexpr;
	void *fpar;
	void *locate_fpar;
	void *locate_wpar;
	int locate_next;

	DbfLocale *cmptbl;

	char *recbuf;
	char *precbuf;
	char *buf;
	int buflen;
	int keylen;

	int exclusive:1;
	int readonly:1;
	int blank:1;
	int dirty:1;
	int valid:1;

	int showdel:1;

	long pos;
	long validpos;

	void *clipmach;
	ClipEval eval;
};

typedef struct
{
	/*
	   0x03  normal  (ndx/ntx)
	   | 0x08 has mdx
	   | 0x80 has memo
	   0x75  Fox memo (fpt)
	 */
	unsigned char version;
	unsigned char yy;
	unsigned char mm;
	unsigned char dd;
	unsigned char recCount[4];
	unsigned char header_len[2];	/* Header Length, Indicates start of data */
	unsigned char record_len[2];
	char zero[16];
	char has_mdx;		/* 1 for true */
	char dummy;
	char zero2[2];
}
DbfHeader;

typedef struct
{
	unsigned char name[DBF_NAMELEN];
	unsigned char type;
	unsigned char filler[4];
	unsigned char len;
	unsigned char dec;
	unsigned char filler2[13];
	unsigned char has_tag;
}
DbfFieldImage;

long dbf_get_long(unsigned char *cp);
void dbf_put_long(unsigned char *cp, long lval);
unsigned short dbf_get_ushort(unsigned char *cp);
void dbf_put_ushort(unsigned char *cp, unsigned short sval);
char *dbf_mem_dup(char *mem, int len);

extern DbfIndexVtbl ntxVtbl;
extern DbfIndexVtbl idxVtbl;
extern DbfMemoVtbl dbtVtbl;

int dbf_rlock(struct DbfFile *fp, struct MapFile *mp, long recno);
int dbf_wlock(struct DbfFile *fp, struct MapFile *mp, long recno);
int dbf_ulock(struct DbfFile *fp, struct MapFile *mp, long recno);

#endif
