/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>, rust <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log: clipbase.h,v $
   Revision 1.19  2001/11/05 16:21:39  clip
   RM_SETTRIGGER(), USE ... TRIGGER
   rust

   Revision 1.18  2001/10/30 08:41:38  clip
   many changes
   rust

   Revision 1.17  2001/06/04 11:05:48  clip
   enhancing RDD (rddlocate(),rddcontinue(),rddstruct(),rddfieldname(),...
   rust

   Revision 1.16  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.15  2001/03/30 11:51:03  clip
   add copyright

   Revision 1.14  2001/03/19 13:45:56  clip
   TABLEEXT(),MEMOEXT()
   rust

   Revision 1.13  2001/03/09 11:44:00  clip
   New RDD added
   Rust

   Revision 1.12  2000/05/24 18:34:11  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.11  2000/04/12 13:39:52  axl
   make external eval for dbf

   Revision 1.10  2000/04/07 03:43:49  axl
   start DBREAD & DBWRITE

   Revision 1.9  2000/03/30 20:56:59  axl
   _clip_translate_path -> full unix file name
   remove dbrename & dbremove from _dbf.c

   Revision 1.8  2000/03/17 16:57:47  axl
   change DBEVAL --> RDDCALC, fix __DBCONTINUE

   Revision 1.7  2000/03/17 16:19:20  axl
   add DBEVAL, __DBLOCATE

   Revision 1.6  2000/03/13 20:11:43  axl
   __RDDLOCATE & __RDDCONTINUE

   Revision 1.5  2000/01/14 18:05:35  axl
   Some changes :) (don't remember)

   Revision 1.4  1999/10/29 19:08:22  axl
   add RLOCK, DBUNLOCK, FLOCK, UNLOCK

   Revision 1.3  1999/10/26 23:56:56  axl
   change RDD ext to iext - index file extension
   add RDD dext - data file extension

   Revision 1.2  1999/10/26 19:11:21  paul
   start cvs logging

 */

#ifndef CLIPBASE_H
#define CLIPBASE_H

#include "clip.h"

typedef struct DBField
{
	char *name;
	char *strtype;
	short type;
	short type1;
	long otype;
	int offs;
	int len;
	int dec;
	int no;
}
DBField;

typedef struct
{
	char *name;
	char *expr;
	ClipVar bexpr;
	int no;
	int unique;
	void *data;
}
DBIndex;

struct DBWorkArea;

typedef struct DBFuncTable
{
	char *name;
	char *iext;
	char *dext;
	char *info;

	/* open/close */
	int (*create) (ClipMachine * mp, char *name, int nfield, DBField * fields
			   ,int argc, ClipVar * argv);
	int (*open) (struct DBWorkArea * ap, ClipMachine * mp, char *name, int shared, int readonly
			 ,int argc, ClipVar * argv);
	int (*close) (struct DBWorkArea * ap, ClipMachine * mp);
/*      int (*remove)( ClipMachine *mp, char *name );
   int (*rename)( ClipMachine *mp, char *name, char *newname );
 */ int (*access) (ClipMachine * mp, char *name, char *mode);

	/* indexes */
	int (*createIndex) (struct DBWorkArea * ap, ClipMachine * mp, DBIndex * index);
	int (*openIndex) (struct DBWorkArea * ap, ClipMachine * mp, DBIndex * index);
	int (*closeIndex) (struct DBWorkArea * ap, ClipMachine * mp, DBIndex * index);
	int (*setIndex) (struct DBWorkArea * ap, ClipMachine * mp, DBIndex * index);

	/* file */
	int (*reindex) (struct DBWorkArea * ap, ClipMachine * mp);
	int (*zap) (struct DBWorkArea * ap, ClipMachine * mp);
	int (*pack) (struct DBWorkArea * ap, ClipMachine * mp);

	/* records */
	int (*append) (struct DBWorkArea * ap, ClipMachine * mp);
	int (*delete) (struct DBWorkArea * ap, ClipMachine * mp);
	int (*recall) (struct DBWorkArea * ap, ClipMachine * mp);
	int (*flush) (struct DBWorkArea * ap, ClipMachine * mp);

	/* fields */
	int (*getVal) (struct DBWorkArea * ap, ClipMachine * mp, int no, ClipVar * vp);
	int (*setVal) (struct DBWorkArea * ap, ClipMachine * mp, int no, ClipVar * vp);
	int (*read) (struct DBWorkArea * ap, ClipMachine * mp, ClipVar * vp);
	int (*write) (struct DBWorkArea * ap, ClipMachine * mp, ClipVar * vp);

	/* group */
	/*
	   int (*nappend)( struct DBWorkArea *ap, ClipMachine *mp, long num, int nfld, int *flds, ClipVar **vect );
	   int (*nread)( struct DBWorkArea *ap, ClipMachine *mp, long *num, int nfld, int *flds, ClipVar **vect );
	 */

	/* info */
	int (*bof) (struct DBWorkArea * ap, ClipMachine * mp, int *val);
	int (*eof) (struct DBWorkArea * ap, ClipMachine * mp, int *val);
	int (*deleted) (struct DBWorkArea * ap, ClipMachine * mp, int *val);
	int (*recNo) (struct DBWorkArea * ap, ClipMachine * mp, long *val);
	int (*recCount) (struct DBWorkArea * ap, ClipMachine * mp, long *val);

	/* move */
	int (*skip) (struct DBWorkArea * ap, ClipMachine * mp, long nskip);
	int (*goTop) (struct DBWorkArea * ap, ClipMachine * mp);
	int (*goBottom) (struct DBWorkArea * ap, ClipMachine * mp);
	int (*goTo) (struct DBWorkArea * ap, ClipMachine * mp, long recno);
	int (*seek) (struct DBWorkArea * ap, ClipMachine * mp, ClipVar * vp, int softseek, int *found);
	int (*locate) (struct DBWorkArea * ap, ClipMachine * mp, ClipVar * fp, ClipVar * wp, int next, int rec, int rest, int *found);
	/*int (*locate)( struct DBWorkArea *ap, ClipMachine *mp, ClipVar *fp, ClipVar *wp, int *found ); */

	/* lock */
	int (*lock) (struct DBWorkArea * ap, ClipMachine * mp, long recno);
	int (*unlock) (struct DBWorkArea * ap, ClipMachine * mp, long recno);
	int (*unlockAll) (struct DBWorkArea * ap, ClipMachine * mp);
	int (*lockFile) (struct DBWorkArea * ap, ClipMachine * mp);
	int (*unlockFile) (struct DBWorkArea * ap, ClipMachine * mp);

	int (*showDeleted) (struct DBWorkArea * ap, ClipMachine * mp, int value);

	int (*lupDate) (struct DBWorkArea * ap, ClipMachine * mp, int *yy, int *mm, int *dd);
	int (*recSize) (struct DBWorkArea * ap, ClipMachine * mp, long *val);
	int (*headerSize) (struct DBWorkArea * ap, ClipMachine * mp, long *val);

	/* set filter to ap->filter_expr; if 0 then clear one */
	int (*setFilter) (struct DBWorkArea * ap, ClipMachine * mp);

	int (*setRange) (struct DBWorkArea * ap, ClipMachine * mp, char *indexalias, ClipVar * low, ClipVar * hi);

	int (*eval) (struct DBWorkArea * ap, ClipMachine * mp, ClipVar * vexpr, ClipVar * res);

}
DBFuncTable;

struct DBRelation;
struct _HashTable;

struct _RDD_DATA_;

typedef struct DBWorkArea
{
	int rd_item;
	struct _RDD_DATA_ *rd;

	char driver[7];
	char idx_driver[4];
	char memo_driver[4];
	long trighash;
	char* trigger;
	char trig_active;
/* ------------------------ */
	DBFuncTable *vtbl;

	/* names */
	char *name;
	char *alias;
	long aliasHash;
	int no;

	/* flags */
	int shared:1;
	int readonly:1;
	int used:1;
	int found:1;

	/* structure */
	DBField *fields;
	int nfield;
	struct _HashTable *fnames;

	/* indexes */
	int nindex;
	DBIndex **indexes;
	int curIndex;

	/* relations */
	struct DBWorkArea *parent;
	int relnum;
	struct DBRelation *relations;

	/* filters */
	char *filter_expr;
	ClipVar filter_bexpr;

	/* driver data */
	void *data;
}
DBWorkArea;

typedef struct DBRelation
{
	DBWorkArea *chield;
	char *expr;
	ClipVar block;
	int fldno;
}
DBRelation;

int _clip_filter(void *mp);

#endif
