/*
   $Log: cbase.c,v $
   Revision 1.3  2000/05/24 18:34:03  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.2  1999/10/26 19:11:16  paul
   start cvs logging

 */

#include "clipbase.h"

static int
create(ClipMachine * mp, char *name
       ,int nfields, DBField * fields
       ,int argc, ClipVar * argv)
{
}

static int
open(struct DBWorkArea *ap, ClipMachine * mp, char *name, int shared, int readonly
     ,int argc, ClipVar * argv)
{
}

static int
close(struct DBWorkArea *ap, ClipMachine * mp)
{
}

static int
remove(struct DBWorkArea *ap, ClipMachine * mp, char *name)
{
}

static int
rename(struct DBWorkArea *ap, ClipMachine * mp, char *name, char *newname)
{
}

static int
createIndex(struct DBWorkArea *ap, ClipMachine * mp, DBIndex * index)
{
}

static int
openIndex(struct DBWorkArea *ap, ClipMachine * mp, DBIndex * index)
{
}

static int
closeIndex(struct DBWorkArea *ap, ClipMachine * mp, DBIndex * index)
{
}

static int
setIndex(struct DBWorkArea *ap, ClipMachine * mp, DBIndex * index)
{
}

	/* file */
static int
reindex(struct DBWorkArea *ap, ClipMachine * mp, DBIndex * index)
{
}

static int
zap(struct DBWorkArea *ap, ClipMachine * mp)
{
}
static int
pack(struct DBWorkArea *ap, ClipMachine * mp)
{
}

	/* records */
static int
append(struct DBWorkArea *ap, ClipMachine * mp)
{
}
static int
delete(struct DBWorkArea *ap, ClipMachine * mp)
{
}
static int
recall(struct DBWorkArea *ap, ClipMachine * mp)
{
}
static int
flush(struct DBWorkArea *ap, ClipMachine * mp)
{
}

/* fields */
static int
getVal(struct DBWorkArea *ap, ClipMachine * mp, int no, ClipVar * vp)
{
}

static int
setVal(struct DBWorkArea *ap, ClipMachine * mp, int no, ClipVar * vp)
{
}

static int
beforeSet(struct DBWorkArea *ap, ClipMachine * mp)
{
}

static int
afterSet(struct DBWorkArea *ap, ClipMachine * mp)
{
}

/* info */
static int 
bof(struct DBWorkArea *ap, ClipMachine * mp, int *val)
{
}

static int 
eof(struct DBWorkArea *ap, ClipMachine * mp, int *val)
{
}

static int 
deleted(struct DBWorkArea *ap, ClipMachine * mp, int *val)
{
}

static int 
recNo(struct DBWorkArea *ap, ClipMachine * mp, long *val)
{
}

static int 
recCount(struct DBWorkArea *ap, ClipMachine * mp, long *val)
{
}

/* move */
static int 
skip(struct DBWorkArea *ap, ClipMachine * mp, long nskip)
{
}

static int 
goTop(struct DBWorkArea *ap, ClipMachine * mp)
{
}

static int 
goBottom(struct DBWorkArea *ap, ClipMachine * mp)
{
}

static int 
goTo(struct DBWorkArea *ap, ClipMachine * mp, long recno)
{
}

static int 
seek(struct DBWorkArea *ap, ClipMachine * mp, ClipVar * vp, int softseek, int *found)
{
}

/* lock */
static int 
lock(struct DBWorkArea *ap, ClipMachine * mp, long recno, int exlusive, int *result)
{
}

static int 
unlock(struct DBWorkArea *ap, ClipMachine * mp, long recno)
{
}

static int 
lockFile(struct DBWorkArea *ap, ClipMachine * mp, int exlusive, int *result)
{
}

static int 
unlockFile(struct DBWorkArea *ap, ClipMachine * mp, long recno)
{
}

DBFuncTable _RDD_MAPBASE =
{
	"MAPBASE",
	"used mmap(2) based library",
	create,
	open,
	close,
	remove,
	rename,
	createIndex,
	openIndex,
	closeIndex,
	setIndex,
	reindex,
	zap,
	pack,
	append,
	delete,
	recall,
	flush,
	getVal,
	setVal,
	beforeSet,
	afterSet,
	bof,
	eof,
	deleted,
	recNo,
	recCount,
	skip,
	goTop,
	goBottom,
	goTo,
	seek,
	lock,
	unlock,
	lockFile,
	unlockFile,
};
