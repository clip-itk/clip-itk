/*
$Log: dbf.h,v $
Revision 1.6  2000/04/12 13:39:58  axl
make external eval for dbf

Revision 1.5  2000/04/08 18:44:36  axl
fix read a MEMO fields

Revision 1.4  2000/03/13 20:11:51  axl
__RDDLOCATE & __RDDCONTINUE

Revision 1.3  2000/01/14 18:06:11  axl
Some changes :) (don't remember)

Revision 1.2  1999/10/26 19:19:06  axl
start cvs logging (./dbf)

*/


#ifndef	_DBF_H_
#define	_DBF_H_

struct DbfFile;

#define	DBF_NAMELEN	11

/* str not in free memory */
#define DBFDATA_NONFREE 0x1

typedef struct
{
	unsigned char type;	/* 'C' 'N' 'D' 'L' 'M' */
	unsigned char len;
	unsigned char dec;
	unsigned char flags;
	union
	{
		double n;
		struct
		{
			char *str;
			int len;
		}
		c;
		int l;
		long d;		/* julian */
	}
	u;
}
DbfData;

typedef struct
{
	unsigned char name[DBF_NAMELEN];
	unsigned char type;	/* 'C' 'N' 'D' 'L' 'M' */
	unsigned short len;
	unsigned short dec;
	unsigned short offs;
}
DbfField;

typedef int (*DbfCalcExpr) (struct DbfFile * fp, DbfData * vp, char *expr, void **par);
typedef int (*ClipEval) (void *mp);

#define DBF_INVALID_POS -1L
#define DBF_BOF_POS 0L
#define DBF_EOF_POS -2L

#define DBF_NDX 0x0
#define DBF_NTX 0x1
#define DBF_IDX 0x2
#define DBF_MDX 0x3
#define DBF_CIDX 0x4
#define DBF_CDX 0x5

#define DBF_DBT 0x10
#define DBF_FPT 0x20

void destroy_DbfData(DbfData * vp);
DbfData *dup_DbfData(DbfData * vp);

typedef struct
{
	unsigned char cmp[128];
	unsigned char upper[128];
	unsigned char lower[128];
	unsigned char read[128];
	unsigned char write[128];
}
DbfLocale;

struct DbfFile *create_DbfFile(const char *name, int type, int exclusive,
			       int nfield, DbfField * fields,
			       DbfCalcExpr calc, DbfLocale * cmptbl,
			       char *errbuf, int errbuflen);
struct DbfFile *open_DbfFile(const char *name, int type, int exclusive, int writeFl,
			     DbfCalcExpr calc, DbfLocale * cmptbl,
			     char *errbuf, int errbuflen);
int close_DbfFile(struct DbfFile *fp);
void getError_DbfFile(struct DbfFile *fp, char *errbuf, int errbuflen);

int nfield_DbfFile(struct DbfFile *fp);
DbfField *field_DbfFile(struct DbfFile *fp, int no);
int fieldNo_DbfFile(struct DbfFile *fp, char *name, int len);
char *name_DbfFile(struct DbfFile *fp);
void getSize_DbfFile(struct DbfFile *fp, int *recsize, int *headersize, long *filesize);

/* indices */
int createIndex_DbfFile(struct DbfFile *fp, char *tag, char *file, char *alias,
			char *expr, int unique);
int openIndex_DbfFile(struct DbfFile *fp, char *tag, char *file, char *alias);
int closeIndex_DbfFile(struct DbfFile *fp, char *alias);
int setIndex_DbfFile(struct DbfFile *fp, char *alias);

/* return current index alias */
char *getIndex_DbfFile(struct DbfFile *fp);

/* *bufp will be realloc'ed */
int indexExpr_DbfFile(struct DbfFile *fp, char *alias, char **bufp);

/* calculate index expression for current record */
int calcIndex_DbfFile(struct DbfFile *fp, char *alias, DbfData * dp);

/* file */
int reindex_DbfFile(struct DbfFile *fp);
int zap_DbfFile(struct DbfFile *fp);
int pack_DbfFile(struct DbfFile *fp);

/* records */
int append_DbfFile(struct DbfFile *fp);
int delete_DbfFile(struct DbfFile *fp);
int recall_DbfFile(struct DbfFile *fp);
int flush_DbfFile(struct DbfFile *fp);

/* fields */
int getVal_DbfFile(struct DbfFile *fp, int fld_no, DbfData * dp);
int setVal_DbfFile(struct DbfFile *fp, int fld_no, DbfData * dp);

/* info */
int lupDate_DbfFile(struct DbfFile *fp, int *yy, int *mm, int *dd);
int recCount_DbfFile(struct DbfFile *fp, long *val);
int recNo_DbfFile(struct DbfFile *fp, long *val);
int bof_DbfFile(struct DbfFile *fp, int *val);
int eof_DbfFile(struct DbfFile *fp, int *val);
int deleted_DbfFile(struct DbfFile *fp, int *val);
int showdel_DbfFile(struct DbfFile *fp, int newval);

	/* return previous state of showdel; newval==-1 query only */

/* move */
int skip_DbfFile(struct DbfFile *fp, long nskip);
int goTop_DbfFile(struct DbfFile *fp);
int goBottom_DbfFile(struct DbfFile *fp);
int goTo_DbfFile(struct DbfFile *fp, long recno);
int seek_DbfFile(struct DbfFile *fp, DbfData * dp, int softseek, int *found);
int locate_DbfFile(struct DbfFile *fp, char *for_expr, char *while_expr, int next, int rec, int rest, int *found);
/*int locate_DbfFile(struct DbfFile *fp, char *for_expr, char *while_expr, int *found);*/

/* lock */
int lock_DbfFile(struct DbfFile *fp, long recno);
int unlock_DbfFile(struct DbfFile *fp, long recno);
int unlockAll_DbfFile(struct DbfFile *fp);
int lockF_DbfFile(struct DbfFile *fp);
int unlockF_DbfFile(struct DbfFile *fp);

int setFilter_DbfFile(struct DbfFile *fp, char *expr);
int setEval_DbfFile(struct DbfFile *fp, void *machine, ClipEval eval);
int setRange_DbfFile(struct DbfFile *fp, char *index, DbfData * low, DbfData * hi);
int eval_DbfFile(struct DbfFile *fp, char *expr, DbfData *result);

/* internal calculator */
int dbf_calc(struct DbfFile *fp, DbfData * vp, char *str, void **par);
typedef int (*DbfBuiltin) (struct DbfFile * fp, int argc, DbfData * sp);

/* calendar -> julian */
long dbf_jdate(int dd, int mm, int yy);

/* julian -> calendar */
void dbf_cdate(long ju, int *dd, int *mm, int *yy, int *ww);

/* .mem files */
int read_MemFile(const char *path, DbfLocale * tbl,
		/* memory pointed by *resp and *names will be realloc'ed */
		 DbfData ** resp, char ***names, int *rescount,
		 char *errbuf, int errbuflen);
int write_MemFile(const char *path, DbfLocale * tbl,
		  DbfData * arr, char **names, int acount,
		  char *errbuf, int errbuflen);

#endif /* _DBF_H_ */
