/*
$Log: dbf.c,v $
Revision 1.52  2000/06/14 02:07:18  clip
fix PACK with DBT file
Alex Vorontsov <axl@itk.ru>

Revision 1.51  2000/06/13 21:55:19  clip
fix error in update_indexes
Alex Vorontsov <axl@itk.ru>

Revision 1.50  2000/06/08 19:24:56  clip
fix replace on BOF & EOF
Alex Vorontsov <axl@itk.ru>

Revision 1.49  2000/06/07 19:24:41  clip
fix read field on BOF
Alex Vorontsov <axl@itk.ru>

Revision 1.48  2000/06/06 18:23:08  clip
fix write_dirty on EOF
Alex Vorontsov <axl@itk.ru>

Revision 1.47  2000/06/01 18:53:04  clip
fix replace with index (not simple)
Alex Vorontsov <axl@itk.ru>

Revision 1.46  2000/05/31 01:53:18  clip
fix dbseek
Alex Vorontsov <axl@itk.ru>

Revision 1.45  2000/05/27 20:03:18  clip
fix index on RDD recno()
Alex Vorontsov <axl@itk.ru>

Revision 1.44  2000/05/26 23:57:57  clip
fix goto 0 error
Alex Vorontsov <axl@itk.ru>

Revision 1.40  2000/05/18 20:36:25  clip
fix dbseek for empty expression
continue idx RDD
Alex Vorontsov <axl@itk.ru>

Revision 1.38  2000/05/16 01:14:35  clip
fix translate_path in indexes & continue idx (axl)

Revision 1.37  2000/05/01 18:54:40  clip
fix error delkey in indexes

Revision 1.36  2000/04/28 19:01:13  clip
tmpname fix

Revision 1.35  2000/04/28 17:55:32  clip

bsd fixes

Revision 1.34  2000/04/12 13:39:57  axl
make external eval for dbf

Revision 1.33  2000/04/10 23:59:47  axl
fix make_index_name

Revision 1.32  2000/04/08 18:44:35  axl
fix read a MEMO fields

Revision 1.31  2000/04/07 21:03:39  axl
fix translate path for open & create databases & indexes

Revision 1.30  2000/04/07 01:52:54  axl
fix stabilize

Revision 1.29  2000/04/07 01:38:53  axl
fix stabilize after append blank

Revision 1.28  2000/04/07 00:38:37  axl
fix update_indexes

Revision 1.27  2000/04/06 20:52:06  axl
fix addel_index (skip after replace)

Revision 1.26  2000/04/04 22:50:30  axl
fix bug in skip_DbfFile (with open index)

Revision 1.25  2000/03/30 21:37:15  axl
fix pack_DbfFile (small gluk :)

Revision 1.24  2000/03/30 20:58:01  axl
fix pack_DbfFile (save full unix file path)

Revision 1.23  2000/03/29 16:27:43  axl
fix indexes close

Revision 1.22  2000/03/28 17:29:51  axl
fix recno() & append blank (for empty DBF)

Revision 1.21  2000/03/27 19:56:49  axl
fix empty database bof() & eof()

Revision 1.20  2000/03/23 01:55:46  axl
some fix

Revision 1.19  2000/03/23 01:40:15  axl
fix bug in skip_DbfFile

Revision 1.18  2000/03/22 18:43:31  axl
fix some return messages about errors

Revision 1.17  2000/03/20 19:43:04  axl
fix create_DbfFile (delete dbf-file before create)

Revision 1.16  2000/03/14 18:55:48  axl
fix bug in closeIndex_DbfFile

Revision 1.15  2000/03/14 00:07:21  axl
delete printf in LOCATE

Revision 1.14  2000/03/13 22:35:31  axl
fix RDDLOCATE

Revision 1.13  2000/03/13 20:11:49  axl
__RDDLOCATE & __RDDCONTINUE

Revision 1.12  2000/02/13 17:32:37  axl
fix back exclusive (sorry :)

Revision 1.11  2000/02/13 16:58:24  axl
fix exclusive locking (not locking :)

Revision 1.10  2000/02/13 00:20:32  axl
fix skip in ntx

Revision 1.9  2000/01/14 18:06:10  axl
Some changes :) (don't remember)

Revision 1.8  1999/11/09 22:49:25  axl
Created DBFMEM - dbf in memory.

Revision 1.7  1999/10/29 23:31:25  axl
fix deleted_DbfFile

Revision 1.6  1999/10/29 22:19:42  axl
fix deleted_DbfFile (error reccount control)

Revision 1.5  1999/10/29 19:10:16  axl
fix dbf_rlock, dbf_wlock (flag: F_SETLKW -> F_SETLK)

Revision 1.4  1999/10/26 22:08:25  axl
fix closeIndex_DbfFile

Revision 1.3  1999/10/26 21:07:15  axl
fix addel_index

Revision 1.2  1999/10/26 19:19:05  axl
start cvs logging (./dbf)

*/


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <ctype.h>
#include <stdarg.h>
#include <fcntl.h>
#include <errno.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "mapfile.h"
#include "dbfpriv.h"

#if 0
#define free mfree
static void
mfree(void *p)
{
}
#endif

#define MIN(arg1,arg2) arg1<arg2 ? arg1 : arg2

/* [ declarations */
static int write_dirty(struct DbfFile *fp);
static int make_valid(struct DbfFile *fp);

static char *make_index_name(struct DbfFile *fp, char *name);

static int skip_index(struct DbfFile *fp, DbfIndex * ip, int nskip);
static int seek_index(struct DbfFile *fp, DbfIndex * ip, DbfData * dp, int *found);

static int delete_index(struct DbfFile *fp, DbfIndex * ip);
static int update_indexes(struct DbfFile *fp);
static int addel_index(struct DbfFile *fp, DbfIndex * ip, int del, int prev);
static int put_key(struct DbfFile *fp, DbfIndex * ip, DbfData * vp);
static int test_filter(struct DbfFile *fp, int *res);
static int test_key(struct DbfFile *fp, DbfIndex * ip, DbfData * vp, int *res);

static DbfIndex *find_index(struct DbfFile *fp, char *alias);
static int calc_index(struct DbfFile *fp, DbfIndex * ip, int prev);
static int act_index(struct DbfFile *fp, DbfIndex * ip);
static void read_translate(struct DbfFile *fp, unsigned char *str, int len);
static void write_translate(struct DbfFile *fp, unsigned char *str, int len);

/* ] declarations */
/* [ utils */

static void
str_up(char *s, int l)
{
	for (; l; ++s, --l)
		*s = toupper(*s);
}

static void
str_low(char *s, int l)
{
	for (; l; ++s, --l)
		*s = tolower(*s);
}

long
dbf_get_long(unsigned char *cp)
{
	long ret;

	ret = *cp++;
	ret += ((*cp++) << 8);
	ret += ((*cp++) << 16);
	ret += ((*cp++) << 24);

	return ret;
}

void
dbf_put_long(unsigned char *cp, long lval)
{
	*cp++ = lval & 0xff;
	*cp++ = (lval >> 8) & 0xff;
	*cp++ = (lval >> 16) & 0xff;
	*cp++ = (lval >> 24) & 0xff;
}

unsigned short
dbf_get_ushort(unsigned char *cp)
{
	unsigned short ret;

	ret = *cp++;
	ret += ((*cp++) << 8);

	return ret;
}

void
dbf_put_ushort(unsigned char *cp, unsigned short sval)
{
	*cp++ = sval & 0xff;
	*cp++ = (sval >> 8) & 0xff;
}

static int
dbf_merror(struct DbfFile *fp, struct MapFile *mp, int line)
{
	int l;

	snprintf(fp->errbuf, ERRBUFSIZE, "DBF: %s, line %d: ", __FILE__, line);
	l = strlen(fp->errbuf);
	getError_MapFile(mp, fp->errbuf + l, ERRBUFSIZE - l);
	return 1;
}

static int
dbf_error(struct DbfFile *fp, int line, const char *fmt,...)
{
	int l;
	va_list ap;

	va_start(ap, fmt);
	snprintf(fp->errbuf, ERRBUFSIZE, "DBF: %s, line %d: ", __FILE__, line);
	l = strlen(fp->errbuf);
	vsnprintf(fp->errbuf + l, ERRBUFSIZE - l, fmt, ap);
	va_end(ap);
	return 1;
}

int
dbf_rlock(struct DbfFile *fp, struct MapFile *mp, long recno)
{
	int cmd = F_SETLK;
	struct flock fl;
	int r;

	if (is_anon(fp->mp))
		return 0;

	fl.l_type = F_RDLCK;
	fl.l_whence = SEEK_SET;
	fl.l_start = recno + 1000000000;
	fl.l_len = 1;

	r = fcntl(fd_MapFile(mp), cmd, &fl);

	if (r)
		snprintf(fp->errbuf, ERRBUFSIZE, "read lock: recno: %ld: %s", recno, strerror(errno));

	return r;
}

int
dbf_wlock(struct DbfFile *fp, struct MapFile *mp, long recno)
{
	int cmd = F_SETLK;
	struct flock fl;
	int r;

	if (is_anon(fp->mp))
		return 0;

	fl.l_type = F_WRLCK;
	fl.l_whence = SEEK_SET;
	fl.l_start = recno + 1000000000;
	fl.l_len = 1;

	r = fcntl(fd_MapFile(mp), cmd, &fl);

	if (r)
		snprintf(fp->errbuf, ERRBUFSIZE, "write lock: recno: %ld: %s", recno, strerror(errno));

	return r;
}

int
dbf_ulock(struct DbfFile *fp, struct MapFile *mp, long recno)
{
	int cmd = F_SETLK;
	struct flock fl;
	int r;

	if (is_anon(fp->mp))
		return 0;

	fl.l_type = F_UNLCK;
	fl.l_whence = SEEK_SET;
	fl.l_start = recno + 1000000000;
	fl.l_len = 1;

	r = fcntl(fd_MapFile(mp), cmd, &fl);

	if (r)
		snprintf(fp->errbuf, ERRBUFSIZE, "unlock: recno: %ld: %s", recno, strerror(errno));

	return r;
}

static int
lock_header(struct DbfFile *fp, int wrflag, DbfHeader ** hpp)
{
	int r;

	if (wrflag)
		r = dbf_wlock(fp, fp->mp, 0);
	else
		r = dbf_rlock(fp, fp->mp, 0);

	if (r)
		return r;

	if (hpp)
		*hpp = (DbfHeader *) getHeader_MapFile(fp->mp);

	return r;
}

static int
unlock_header(struct DbfFile *fp)
{
	return dbf_ulock(fp, fp->mp, 0);
}

static int
lock_rec(struct DbfFile *fp, int wrflag, long recno, char **bp)
{
	int r=0;

	if (wrflag)
		r = dbf_wlock(fp, fp->mp, recno);
	/*else
		r = dbf_rlock(fp, fp->mp, recno);*/

	if (bp)
		*bp = getRec_MapFile(fp->mp, recno - 1);

	return r;
}

static int
unlock_rec(struct DbfFile *fp, long recno)
{
	return dbf_ulock(fp, fp->mp, recno);
}

/* ] utils */
/* [ DbfFile */

static DbfHeader *
getHeader(struct DbfFile *fp)
{
	return (DbfHeader *) getHeader_MapFile(fp->mp);
}

static long
recCount(DbfHeader * hp)
{
	return dbf_get_long(hp->recCount);
}

static int
fieldCount(DbfHeader * hp)
{
	int hlen, nfield;

	hlen = dbf_get_ushort(hp->header_len);
	nfield = (hlen - sizeof(DbfHeader)) / sizeof(DbfFieldImage);

	return nfield;
}

void
destroy_DbfData(DbfData * vp)
{
	if (!vp)
		return;
	switch (vp->type)
	{
	case 'C':
	case 'M':
		if (!(vp->flags & DBFDATA_NONFREE))
			free(vp->u.c.str);
		break;
	}
	vp->type = 'U';
	vp->flags = 0;
}

DbfData *
dup_DbfData(DbfData * vp)
{
	DbfData *ret = NEW(DbfData);

	memset(ret, 0, sizeof(DbfData));
	ret->type = vp->type;
	ret->dec = vp->dec;
	ret->len = vp->len;

	switch (vp->type)
	{
	case 'C':
	case 'M':
		ret->u.c.str = dbf_mem_dup(vp->u.c.str, vp->u.c.len);
		ret->u.c.len = vp->u.c.len;
		break;
	case 'N':
		ret->u.n = vp->u.n;
		break;
	case 'D':
		ret->u.d = vp->u.d;
		break;
	case 'L':
		ret->u.l = vp->u.l;
		break;
	}

	return ret;
}

static int
lock_file(struct DbfFile *fp, int exclusive)
{
	int cmd = F_SETLK;
	struct flock fl;
	int r;

	if (is_anon(fp->mp))
		return 0;

	fl.l_type = (exclusive ? F_WRLCK : F_RDLCK);
	fl.l_whence = SEEK_SET;
	fl.l_start = 0x7fffffff;
	fl.l_len = 1;

	r = fcntl(fd_MapFile(fp->mp), cmd, &fl);

	if (r)
		snprintf(fp->errbuf, ERRBUFSIZE, "%s open-mode lock: %s", exclusive ? "exclusive" : "shared", strerror(errno));

	return r;
}

struct DbfFile *
create_DbfFile(const char *name, int type, int exclusive, int nfield, DbfField * fields,
	       DbfCalcExpr calc, DbfLocale * cmptbl, char *errbuf, int errbuflen)
{
	DbfHeader *hp, *hpp;
	struct DbfFile *fp;
	int i, hlen, rlen, memo = 0;
	struct tm *ctm;
	time_t c_time;
	DbfField *lfields;
	DbfIndexVtbl *itbl = 0;
	DbfMemoVtbl *mtbl = 0;

	switch (type & 0xf)
	{
	case DBF_NTX:
		itbl = &ntxVtbl;
		break;
	case DBF_IDX:
		itbl = &idxVtbl;
		break;
	default:
		snprintf(errbuf, errbuflen, "unsuppoted INDEX type: %d", type & 0xf);
		return 0;
	}

	switch (type & 0xf0)
	{
	case DBF_DBT:
		mtbl = &dbtVtbl;
		break;
	case DBF_FPT:
	default:
		snprintf(errbuf, errbuflen, "unsuppoted MEMO type: %d", type & 0xf0);
		return 0;
	}

	i = sizeof(DbfField) * nfield;
	lfields = (DbfField *) malloc(i);
	memcpy(lfields, fields, i);

	for (i = 0, hlen = sizeof(DbfHeader), rlen = 1; i < nfield; ++i)
	{
		DbfField *fld = lfields + i;

		fld->offs = rlen;
		switch (fld->type)
		{
		case 'C':
			rlen += fld->len;
			break;
		case 'N':
			rlen += fld->len;
			break;
		case 'L':
			rlen += 1;
			fld->len = 1;
			break;
		case 'D':
			rlen += 8;
			fld->len = 8;
			break;
		case 'M':
			rlen += 10;
			fld->len = 10;
			memo++;
			break;
		default:
			snprintf(errbuf, errbuflen, "unknown field type:'%c'", fld->type);
			free(lfields);
			return 0;
		}
		str_up(fld->name, DBF_NAMELEN);
		hlen += sizeof(DbfFieldImage);
	}
	++hlen;
	++hlen;

	fp = NEW(struct DbfFile);

	fp->recSize = rlen;
	fp->headerSize = hlen;
	if ( name )
		if ( !access(name, F_OK) )
		{
			fp->mp = open_MapFile(name, sizeof(DbfHeader), 1, errbuf, errbuflen);

			if (!fp->mp || lock_file(fp, exclusive) || lock_header(fp, 0, &hp))
			{
				if (fp->mp)
				{
					close_MapFile(fp->mp);
					snprintf(errbuf, errbuflen, "%s", fp->errbuf);
				}
				free(fp);
				return 0;
			}

			close_MapFile(fp->mp);

			if (unlink(name) < 0)
			{
				free(fp);
				snprintf(errbuf, errbuflen, "file '%s' already exist and not be deleted", name);
				return 0;
			}
		}

	fp->mp = create_MapFile(name, hlen, rlen, errbuf, errbuflen);
	fp->itbl = itbl;

	if (!fp->mp || lock_file(fp, exclusive) || lock_header(fp, 1, &hpp))
	{
		if (fp->mp)
		{
			getError_MapFile(fp->mp, errbuf, errbuflen);
			close_MapFile(fp->mp);
			snprintf(errbuf, errbuflen, "%s", fp->errbuf);
		}
		free(fp);
		return 0;
	}

	if (memo)
	{
		int r;
		void *p;

		if (!mtbl)
		{
			close_MapFile(fp->mp);
			snprintf(errbuf, errbuflen, "record have memo fields, but memo type not specified");
			free(fp);
			return 0;
		}
		p = mtbl->create();
		r = mtbl->fcreate(p, name);
		if (r)
		{
			mtbl->error(p, errbuf, errbuflen);
			mtbl->destroy(p);
			close_MapFile(fp->mp);
			free(fp);
			return 0;
		}
		fp->mtbl = mtbl;
		fp->memo = p;
	}
	fp->exclusive = exclusive;
	if ( name )
		fp->name = strdup(name);
	fp->nfield = nfield;
	fp->fields = lfields;
	fp->type = type;
	fp->calc = calc;
	fp->cmptbl = cmptbl;
	fp->fileSize = mapLen_MapFile(fp->mp);

	hp = (DbfHeader *) calloc(hlen, 1);

	hp->version = 0x03;

	switch (type & 0xf)
	{
	case DBF_MDX:
		hp->version |= 0x08;
		break;
	case DBF_CDX:
		hp->version |= 0x08;
		break;
	}

	if (memo)
		switch (type & 0xf0)
		{
		case DBF_DBT:
			hp->version |= 0x80;
			break;
		case DBF_FPT:
			hp->version = 0xF5;
			break;
		}

	c_time = time(0);
	ctm = localtime(&c_time);

	hp->yy = ctm->tm_year /* - 1900 */ ;
	hp->mm = ctm->tm_mon + 1;
	hp->dd = ctm->tm_mday;

	dbf_put_long(hp->recCount, 0);
	dbf_put_ushort(hp->header_len, hlen);
	dbf_put_ushort(hp->record_len, rlen);

	for (i = 0; i < nfield; ++i)
	{
		DbfFieldImage *ip = ((DbfFieldImage *) (hp + 1)) + i;
		DbfField *fld = fp->fields + i;

		memcpy(ip->name, fld->name, DBF_NAMELEN);
		ip->type = fld->type;
		switch (fld->type)
		{
		case 'N':
			ip->len = fld->len;
			ip->dec = fld->dec;
			break;
		default:
			dbf_put_ushort(&ip->len, fld->len);
			break;
		}
	}
	((char *) hp)[hlen - 2] = 0x0d;
	((char *) hp)[hlen - 1] = 0x0;

	memcpy(hpp, hp, hlen);

	sync_MapFile(fp->mp);

	fp->validpos = 1;
	fp->pos = recCount(hp) ? 1 : DBF_BOF_POS;

	unlock_header(fp);
	fp->recbuf = (char *) calloc(1, fp->recSize + 1);
	fp->precbuf = (char *) calloc(1, fp->recSize + 1);
	fp->buf = (char *) malloc(64);
	fp->buflen = 64;

	free(hp);

	return fp;
}

char *
name_DbfFile(struct DbfFile *fp)
{
	return fp->name;
}

struct DbfFile *
open_DbfFile(const char *name, int type, int exclusive, int writeFl,
	     DbfCalcExpr calc, DbfLocale * cmptbl, char *errbuf, int errbuflen)
{
	DbfHeader *hp;
	struct DbfFile *fp;
	int i, rlen;
	DbfIndexVtbl *itbl = 0;

	switch (type & 0xf)
	{
	case DBF_NTX:
		itbl = &ntxVtbl;
		break;
	case DBF_IDX:
		itbl = &idxVtbl;
		break;
	default:
		snprintf(errbuf, errbuflen, "unsuppoted INDEX type: %d", type & 0xf);
		return 0;
	}
	if (exclusive && !writeFl)
	{
		snprintf(errbuf, errbuflen, "conflict between READONLY and EXCLUSIVE mode");
		return 0;
	}

	fp = NEW(struct DbfFile);

	fp->mp = open_MapFile(name, sizeof(DbfHeader), writeFl, errbuf, errbuflen);

	if (!fp->mp || lock_file(fp, exclusive) || lock_header(fp, 0, &hp))
	{
		if (fp->mp)
		{
			close_MapFile(fp->mp);
			snprintf(errbuf, errbuflen, "%s", fp->errbuf);
		}
		free(fp);
		return 0;
	}

	if (hp->version & 0x80)
	{
		DbfMemoVtbl *mtbl;
		void *p;
		int r;

		switch (type & 0xf0)
		{
		case DBF_DBT:
			mtbl = &dbtVtbl;
			break;
		case DBF_FPT:
		default:
			snprintf(errbuf, errbuflen, "unsupported MEMO type: %d", type & 0xf0);
			close_MapFile(fp->mp);
			free(fp);
			return 0;
		}

		p = mtbl->create();
		r = mtbl->fopen(p, name, writeFl);
		if (r)
		{
			mtbl->error(p, errbuf, errbuflen);
			mtbl->destroy(p);
			close_MapFile(fp->mp);
			free(fp);
			return 0;
		}

		fp->memo = p;
		fp->mtbl = mtbl;
	}
	else
	{
		fp->memo = 0;
		fp->mtbl = 0;
	}

	fp->itbl = itbl;
	fp->type = type;
	fp->exclusive = exclusive;
	fp->recSize = dbf_get_ushort(hp->record_len);
	fp->headerSize = dbf_get_ushort(hp->header_len);
	fp->readonly = !writeFl;
	fp->calc = calc;
	fp->cmptbl = cmptbl;
	fp->fileSize = mapLen_MapFile(fp->mp);

	/*switch(hp->version & 0xf)
	   {
	   case 0xb:
	   fp->indextype =  DBF_MDX;
	   break;
	   case 0x5:
	   fp->indextype =  DBF_CDX;
	   break;
	   default:
	   fp->indextype =  DBF_NTX;
	   break;
	   } */

	fp->nfield = fieldCount(hp);
	/* some checks */
	if (fp->recSize < 1 || fp->nfield < 1 || recCount(hp) < 0)
	{
		snprintf(errbuf, errbuflen, "invalid DBF header");
	      somewrong:
		if (fp->name)
			free(fp->name);
		if (fp->fields)
			free(fp->fields);
		if (fp->recbuf)
			free(fp->recbuf);
		if (fp->precbuf)
			free(fp->precbuf);
		if (fp->memo)
			fp->mtbl->destroy(fp->memo);

		close_MapFile(fp->mp);
		free(fp);
		return NULL;
	}

	fp->name = strdup(name);
	fp->fields = (DbfField *) calloc(fp->nfield, sizeof(DbfField));
	fp->recbuf = (char *) calloc(1, fp->recSize + 1);
	fp->precbuf = (char *) calloc(1, fp->recSize + 1);

	for (i = 0, rlen = 1; i < fp->nfield; ++i)
	{
		DbfFieldImage *ip = ((DbfFieldImage *) (hp + 1)) + i;
		DbfField *fld = fp->fields + i;

		memcpy(fld->name, ip->name, DBF_NAMELEN);
		fld->type = ip->type;
		fld->offs = rlen;
		switch (fld->type)
		{
		case 'N':
		case 'L':
		case 'D':
		case 'M':
			fld->len = ip->len;
			fld->dec = ip->dec;
			break;
		case 'C':
		default:
			fld->len = dbf_get_ushort(&ip->len);
			break;
		case 0:	/* error!! */
			snprintf(errbuf, errbuflen, "invalid field %d type", i);
			goto somewrong;
			break;
		}
		rlen += fld->len;
	}

	fp->validpos = 1;
	fp->pos = recCount(hp) ? 1: DBF_BOF_POS;

	unlock_header(fp);

	setRecSize_MapFile(fp->mp, fp->recSize);
	setHeaderSize_MapFile(fp->mp, fp->headerSize);
	fp->buf = (char *) malloc(64);
	fp->buflen = 64;

/*
   open memo & structured index files...
 */

	return fp;
}

static int
close_dbf(struct DbfFile *fp)
{
	int r, i;

	write_dirty(fp);
	if (fp->memo)
		r = fp->mtbl->destroy(fp->memo);
	r = close_MapFile(fp->mp);

	for (i = 0; i < fp->nindex; ++i)
		delete_index(fp, fp->indexes[i]);

	free(fp->indexes);
	free(fp->buf);
	free(fp->name);
	free(fp->fields);
	free(fp->recbuf);
	free(fp->precbuf);

	free(fp->fexpr);
	free(fp->fpar);
	free(fp->locate_fpar);
	free(fp->locate_wpar);
	memset(fp, 0, sizeof(struct DbfFile));

	return r;
}

int
close_DbfFile(struct DbfFile *fp)
{
	if (!fp)
		return 0;

	close_dbf(fp);

	free(fp);

	return 0;
}

void
getError_DbfFile(struct DbfFile *fp, char *buf, int buflen)
{
	snprintf(buf, buflen, "%s", fp->errbuf);
}

int
lupDate_DbfFile(struct DbfFile *fp, int *yy, int *mm, int *dd)
{
	DbfHeader *hp;
	int r;

	if ((r = write_dirty(fp)))
		return r;

	if (lock_header(fp, 0, &hp))
		return dbf_merror(fp, fp->mp, __LINE__);

	*(yy) = hp->yy + (hp->yy > 37 ? 1900 : 2000);
	*(mm) = hp->mm;
	*(dd) = hp->dd;

	unlock_header(fp);

	return 0;
}

int
recCount_DbfFile(struct DbfFile *fp, long *val)
{
	DbfHeader *hp;
	int r;

	if ((r = write_dirty(fp)))
		return r;

	if (lock_header(fp, 0, &hp))
		return dbf_merror(fp, fp->mp, __LINE__);

	*val = recCount(hp);

	unlock_header(fp);

	return 0;
}

void
getSize_DbfFile(struct DbfFile *fp, int *recsize, int *headersize, long *filesize)
{
	if (recsize)
		*recsize = fp->recSize;
	if (headersize)
		*headersize = fp->headerSize;
	if (filesize)
		*filesize = fp->fileSize;
}


int
nfield_DbfFile(struct DbfFile *fp)
{
	return fp->nfield;
}

DbfField *
field_DbfFile(struct DbfFile * fp, int no)
{
	return fp->fields + no;
}

int
fieldNo_DbfFile(struct DbfFile *fp, char *name, int len)
{
	int i;

	for (i = 0; i < fp->nfield; ++i)
	{
		DbfField *fpp = fp->fields + i;

		if (!strncasecmp(name, fpp->name, len))
			return i;
	}

	return -1;
}

static char *
get_alias(char *tag, char *alias)
{
	char *ret, *s, *e;
	int l;

	if (alias)
		return strdup(alias);

	if (!(e = strrchr(tag, '.')))
		e = tag + strlen(tag);

	if (!(s = strrchr(tag, '/')) || (s + 1 > e))
		s = tag;
	else
		++s;

	l = e - s;
	ret = (char *) malloc(l + 1);
	memcpy(ret, s, l);
	ret[l] = 0;

	return ret;
}

int
createIndex_DbfFile(struct DbfFile *fp, char *tag, char *file, char *alias,
		    char *expr, int unique)
{
	int i, r = 0;
	DbfIndex *ip, *mip = 0;
	long pos, last, recno;

	if ((r = write_dirty(fp)))
		return r;

	for (i = 0; i < fp->nindex; ++i)
	{
		DbfIndex *ipp = fp->indexes[i];

		if (!strcasecmp(ipp->tag, tag) && ((!file && !ipp->file) || (file && ipp->file && !strcasecmp(file, ipp->file))))
		{
			if (file)
				snprintf(fp->errbuf, ERRBUFSIZE, "tag '%s' of '%s' already exist", tag, file);
			else
				snprintf(fp->errbuf, ERRBUFSIZE, "tag '%s' already exist", tag);
			return -1;
		}
		if (file && ipp->file && !strcasecmp(file, ipp->file) && !ipp->main)
			mip = ipp;
	}

	ip = NEW(DbfIndex);
	/*ip->len = len;
	   ip->dec = dec;
	   ip->type = type; */
	ip->unique = unique;
	/*ip->keybuf = (char*)malloc(len+1); */
	ip->keypos = 0;

	ip->tag = strdup(tag);
	str_low(ip->tag, strlen(ip->tag));
	ip->file = (file ? strdup(file) : 0);
	if (ip->file)
		str_low(ip->file, strlen(ip->file));
	ip->expr = strdup(expr);
	if (!is_anon(fp->mp)) {
		if (ip->file)
			ip->filename = make_index_name(fp, ip->file);
		else
			ip->filename = make_index_name(fp, ip->tag);

	}

	ip->alias = get_alias(tag, alias);

	if (mip)
		ip->main = mip;

	{
		char *s;

		for (s = ip->expr; *s; ++s)
			if (!isalnum(*s) && *s != '_')
				break;
		if (!*s)
		{
			for (i = 0; i < fp->nfield; ++i)
			{
				DbfField *fldp = fp->fields + i;

				if (!strcasecmp(fldp->name, ip->expr))
				{
					ip->simple = 1;
					ip->fld_no = i;
					ip->len = fldp->len;
					ip->dec = fldp->dec;
					ip->type = fldp->type;
					break;
				}
			}
		}
	}

	if (!ip->simple)
	{
		DbfData data;

		data.type = 'U';
		if (!fp->calc)
			return dbf_error(fp, __LINE__, "tag %s: non-simple key expression and empty DbfFIle key calculation function", tag);
		r = fp->calc(fp, &data, ip->expr, &ip->par);
		if (data.type == 'C')
			ip->len = data.u.c.len;
		else
			ip->len = data.len;
		ip->dec = data.dec;
		ip->type = data.type;
		destroy_DbfData(&data);
	}

	r = fp->itbl->create(fp, ip);

	if (r)
	{
		delete_index(fp, ip);
		return r;
	}

	fp->indexes = (DbfIndex **) realloc(fp->indexes, sizeof(DbfIndex *) * (fp->nindex + 1));
	fp->indexes[fp->nindex] = ip;
	fp->nindex++;
	fp->index = ip;

	recCount_DbfFile(fp, &last);

	if (last > 0)
	{
		write_dirty(fp);
		pos = fp->pos;
		if (dbf_wlock(fp, ip->mp, 0))
			return dbf_merror(fp, ip->mp, __LINE__);
		for (recno = 1, r = 0; !r && recno <= last; ++recno)
		{
			fp->validpos = fp->pos = recno;
			fp->valid = 0;
			r = addel_index(fp, ip, 0, 0);
		}

		dbf_ulock(fp, ip->mp, 0);
		fp->valid = 0;
		fp->pos = pos;
	}

	ip->keybuf = (char *) malloc(ip->len + 1);

	if (fp->buflen <= ip->len)
	{
		fp->buflen = ip->len + 1;
		fp->buf = (char *) realloc(fp->buf, fp->buflen);
	}

	return r;
}

static int
delete_index(struct DbfFile *fp, DbfIndex * ip)
{
	int r = 0;

	if (!ip)
		return 0;

	fp->itbl->destroy(fp, ip);

	if (ip->mp && !ip->main)
		r = close_MapFile(ip->mp);

	free(ip->tag);
	free(ip->file);
	free(ip->alias);
	free(ip->expr);
	free(ip->filename);
	free(ip->par);
	free(ip->keybuf);

	free(ip);

	return r;
}

static DbfIndex *
find_index(struct DbfFile *fp, char *alias)
{
	int i;

	for (i = 0; i < fp->nindex; ++i)
	{
		DbfIndex *ipp = fp->indexes[i];

		if (!strcasecmp(ipp->alias, alias))
			return ipp;
	}

	return 0;
}

int
indexExpr_DbfFile(struct DbfFile *fp, char *alias, char **bufp)
{
	int r, l;
	DbfIndex *ip;

	if ((r = write_dirty(fp)))
		return r;

	ip = find_index(fp, alias);
	if (!ip)
		return dbf_error(fp, __LINE__, "no index '%s'", alias);

	l = strlen(ip->expr);
	*bufp = (char *) realloc(*bufp, l + 1);
	memcpy(*bufp, ip->expr, l + 1);

	return 0;
}

int
calcIndex_DbfFile(struct DbfFile *fp, char *alias, DbfData * dp)
{
	int r;
	DbfIndex *ip;

	if ((r = write_dirty(fp)))
		return r;

	ip = find_index(fp, alias);
	if (!ip)
		return dbf_error(fp, __LINE__, "no index '%s'", alias);

	if (ip->simple)
		r = getVal_DbfFile(fp, ip->fld_no, dp);
	else
		r = fp->calc(fp, dp, ip->expr, &ip->par);

	return r;
}

int
openIndex_DbfFile(struct DbfFile *fp, char *tag, char *file, char *alias)
{
	int i, r = 0;
	DbfIndex *ip, *mip = 0;

	write_dirty(fp);

	for (i = 0; i < fp->nindex; ++i)
	{
		DbfIndex *ipp = fp->indexes[i];

		if (!strcasecmp(ipp->tag, tag) && ((!file && !ipp->file) || (file && ipp->file && !strcasecmp(file, ipp->file))))
		{
			if (file)
				snprintf(fp->errbuf, ERRBUFSIZE, "tag '%s' of '%s' already opened", tag, file);
			else
				snprintf(fp->errbuf, ERRBUFSIZE, "tag '%s' already exist", tag);
			return -1;
		}
		if (file && ipp->file && !strcasecmp(file, ipp->file) && !ipp->main)
			mip = ipp;
	}

	ip = NEW(DbfIndex);

	ip->tag = strdup(tag);
	str_low(ip->tag, strlen(ip->tag));
	ip->file = (file ? strdup(file) : 0);
	if (ip->file)
		str_low(ip->file, strlen(ip->file));
	if (ip->file)
		ip->filename = make_index_name(fp, ip->file);
	else
		ip->filename = make_index_name(fp, ip->tag);
	ip->alias = get_alias(tag, alias);

	if (mip)
		ip->main = mip;

	r = fp->itbl->open(fp, ip);

	if (r)
	{
		delete_index(fp, ip);
		return r;
	}

	fp->indexes = (DbfIndex **) realloc(fp->indexes, sizeof(DbfIndex *) * (fp->nindex + 1));
	fp->indexes[fp->nindex] = ip;
	fp->nindex++;
	if (fp->nindex==1)
		fp->index = ip;

	{
		char *s;

		for (s = ip->expr; *s; ++s)
			if (!isalnum(*s) && *s != '_')
				break;
		if (!*s)
		{
			for (i = 0; i < fp->nfield; ++i)
			{
				DbfField *fldp = fp->fields + i;

				if (!strcasecmp(fldp->name, ip->expr))
				{
					ip->simple = 1;
					ip->fld_no = i;
					ip->len = fldp->len;
					ip->dec = fldp->dec;
					ip->type = fldp->type;
					break;
				}
			}
		}
	}

#if 0
	if (!ip->simple && !fp->calc)
		return dbf_error(fp, __LINE__, "tag %s: non-simple key expression and empty DbfFIle key calculation function", tag);
#endif
	if (!ip->simple)
	{
		DbfData data;

		data.type = 'U';
		if (!fp->calc)
			return dbf_error(fp, __LINE__, "tag %s: non-simple key expression and empty DbfFIle key calculation function", tag);
		r = fp->calc(fp, &data, ip->expr, &ip->par);
		if (data.type == 'C')
			ip->len = data.u.c.len;
		else
			ip->len = data.len;
		ip->dec = data.dec;
		ip->type = data.type;
		destroy_DbfData(&data);
	}

	if (fp->buflen <= ip->len)
	{
		fp->buflen = ip->len + 1;
		fp->buf = (char *) realloc(fp->buf, fp->buflen);
	}

	ip->keybuf = (char *) malloc(ip->len + 1);
	ip->keypos = 0;

	return r;
}

int
closeIndex_DbfFile(struct DbfFile *fp, char *alias)
{
	DbfIndex *ip;
	int r = 0, i;

	if ((r = write_dirty(fp)))
		return r;

	ip = find_index(fp, alias);
	if (!ip)
		return dbf_error(fp, __LINE__, "no index '%s'", alias);

	for (i = 0; i < fp->nindex; ++i)
	{
		DbfIndex *ipp = fp->indexes[i];

		if (ipp == ip)
		{
			memmove(fp->indexes + i, fp->indexes + i + 1, (fp->nindex - i - 1) * sizeof(DbfIndex *));
			if (ip==fp->index && fp->nindex-1)
				fp->index = fp->indexes[1];
			else
				fp->index = 0;
			r = delete_index(fp, ip);
			fp->nindex--;
			break;
		}
	}

	if (!fp->nindex)
	{
		free(fp->indexes);
		fp->indexes = 0;
	}

	return r;
}

int
setIndex_DbfFile(struct DbfFile *fp, char *alias)
{
	DbfIndex *ip;
	int r;

	if ((r = write_dirty(fp)))
		return r;

	if (!alias)
	{
		fp->index = 0;
		return 0;
	}

	ip = find_index(fp, alias);
	if (!ip)
		return dbf_error(fp, __LINE__, "no index '%s'", alias);

	fp->index = ip;
	act_index(fp, ip);

	return 0;
}

char *
getIndex_DbfFile(struct DbfFile *fp)
{
	if (!fp->index)
		return 0;
	return fp->index->alias;
}

int
reindex_DbfFile(struct DbfFile *fp)
{
	DbfHeader *hp;
	long last, recno, pos = fp->pos;
	int i, r = 0;
	DbfIndex *ip;

	if ((r = write_dirty(fp)))
		return r;

	if (lock_header(fp, 0, &hp))
		return dbf_merror(fp, fp->mp, __LINE__);

	for (i = 0; i < fp->nindex; ++i)
	{
		ip = fp->indexes[i];
		if ((r = fp->itbl->zap(fp, ip)))
			goto ierr;

		if ((r = dbf_wlock(fp, ip->mp, 0)))
		{
			dbf_merror(fp, ip->mp, __LINE__);
			goto ierr;
		}
	}

	last = recCount(hp);
	for (recno = 1; recno <= last; ++recno)
	{
		fp->pos = recno;
		fp->valid = 0;
		for (i = 0; i < fp->nindex; ++i)
		{
			ip = fp->indexes[i];
			if ((r = addel_index(fp, ip, 0, 0)))
				goto ierr;
		}
	}

      ierr:
	fp->valid = 0;
	fp->pos = pos;

	for (i = 0; i < fp->nindex; ++i)
	{
		ip = fp->indexes[i];
		dbf_ulock(fp, ip->mp, 0);
	}

	unlock_header(fp);
	return r;
}

int
zap_DbfFile(struct DbfFile *fp)
{
	DbfHeader *hp;
	int i, r = 0;
	DbfIndex *ip;

	if ((r = write_dirty(fp)))
		return r;
	if (lock_header(fp, 1, &hp))
		return dbf_merror(fp, fp->mp, __LINE__);

	dbf_put_long(hp->recCount, 0);

	if ((r = decr_MapFile(fp->mp, 0)))
	{
		dbf_merror(fp, fp->mp, __LINE__);
		goto err;
	}

/*
   bp = getRec_MapFile(fp->mp, 0);
   *bp = 0x1a;
 */

	for (i = 0; i < fp->nindex; ++i)
	{
		ip = fp->indexes[i];
		if ((r = fp->itbl->zap(fp, ip)))
			goto err;
	}

      err:
	fp->blank = 0;
	fp->dirty = 0;
	fp->valid = 0;
	fp->pos = DBF_BOF_POS;
	fp->fileSize = mapLen_MapFile(fp->mp);

	unlock_header(fp);
	return r;
}

int
pack_DbfFile(struct DbfFile *fp)
{

	DbfHeader *hp;
	int i, r = 0;
	long last, recno;
	struct DbfFile *tmp;
	char tmpname[256], *bp;
	DbfData data;

	if ((r = write_dirty(fp)))
		return r;

	if (lock_header(fp, 1, &hp))
		return dbf_merror(fp, fp->mp, __LINE__);

	last = recCount(hp);

	/* create tmp base */

	bp = strrchr(fp->name, '/');
	*bp = 0;
	/*tmpname = tempnam(fp->name, "tmp");*/
	snprintf(tmpname, sizeof(tmpname), "%s/tmp%lx%lx", fp->name, (long)getpid(), (long)random());
	/*mktemp(tmpname);*/
	*bp = '/';
	tmp = create_DbfFile(tmpname, fp->type, fp->exclusive, fp->nfield, fp->fields,
			     fp->calc, fp->cmptbl, fp->errbuf, ERRBUFSIZE);

	if (!tmp)
	{
		r = 1;
		unlock_header(fp);
		goto ret;
	}

	tmp->nindex = fp->nindex;
	tmp->indexes = fp->indexes;
	fp->nindex = 0;
	fp->indexes = 0;
	reindex_DbfFile(tmp);

	/* add undeleted records */
	for (recno = 1; recno <= last; ++recno)
	{
		bp = getRec_MapFile(fp->mp, recno - 1);
		if (*bp != ' ')
			continue;
		fp->pos = recno;
		fp->valid = 0;
		append_DbfFile(tmp);
		for (i = 0; i < fp->nfield; ++i)
		{
			getVal_DbfFile(fp, i, &data);
			setVal_DbfFile(tmp, i, &data);
		}
	}

	unlock_header(fp);

	strncpy(tmpname, fp->name, sizeof(tmpname));

	close_dbf(fp);
	if ((r = rename(tmp->name, tmpname)))
	{
		dbf_error(fp, __LINE__, "cannot rename tmp file '%s' to '%s'", tmp->name, tmpname);
		unlink(tmp->name);
		goto ret;
	}

	memcpy(fp, tmp, sizeof(struct DbfFile));

	free(fp->name);
	fp->name = strdup(tmpname);
	free(tmp);
	tmp = 0;

	if (fp->mtbl)
	{
		bp = strrchr(fp->name, '.');
		*bp = 0;
		snprintf(tmpname, sizeof(tmpname), "%s", fp->name);
		*bp = '.';
		r = fp->mtbl->frename(fp->memo, tmpname);
	}

      ret:
	destroy_DbfData(&data);
	if (tmp)
		close_DbfFile(tmp);

	return r;
}

static int
write_dirty(struct DbfFile *fp)
{
	long recno;
	int r;
	char *bp;
	struct tm *ctm;
	time_t c_time;

	if (!fp->dirty || fp->pos == DBF_EOF_POS)
		return 0;

	if (fp->blank)
	{
		DbfHeader *hp;
		long count, delta, mcount;

		if (lock_header(fp, 1, &hp))
			return dbf_merror(fp, fp->mp, __LINE__);

		count = recCount(hp);
		mcount = (fp->fileSize - fp->headerSize) / fp->recSize;

		if (mcount < count + 1)
		{
			delta = count / 4;
			if (delta < 16)
				delta = 16;
			if (incr_MapFile(fp->mp, &recno, delta, 0))
				return dbf_merror(fp, fp->mp, __LINE__);
			fp->fileSize = mapLen_MapFile(fp->mp);
			hp = getHeader(fp);
		}

		recno = count + 1;
		dbf_put_long(hp->recCount, count + 1);

		c_time = time(0);
		ctm = localtime(&c_time);

		hp->yy = ctm->tm_year /* - 1900 */ ;
		hp->mm = ctm->tm_mon + 1;
		hp->dd = ctm->tm_mday;
		unlock_header(fp);

		if (lock_rec(fp, 1, recno, &bp))
			return dbf_merror(fp, fp->mp, __LINE__);

		bp[fp->recSize] = 0x1a;

		fp->validpos = fp->pos = recno;
	}
	else
	{
		recno = fp->validpos;
		if (lock_rec(fp, 1, recno, &bp))
			return dbf_merror(fp, fp->mp, __LINE__);
	}

	fp->dirty = 0;
	fp->blank = 0;
	fp->valid = 0;

	r = update_indexes(fp);

	memcpy(bp, fp->recbuf, fp->recSize);

	/*memcpy(fp->precbuf, fp->recbuf, fp->recSize);*/

	if (unlock_rec(fp, recno))
		return dbf_merror(fp, fp->mp, __LINE__);

	return r;
}

int
append_DbfFile(struct DbfFile *fp)
{
	int r, i;

	if (fp->readonly)
		return dbf_error(fp, __LINE__, "append operation on read-only base '%s'", fp->name);

	if ((r = write_dirty(fp)))
		return r;

	memset(fp->recbuf, ' ', fp->recSize);

	for (i = 0; i < fp->nfield; ++i)
	{
		DbfField *f = fp->fields + i;
		char *bp = fp->recbuf + f->offs;

		switch (f->type)
		{
		case 'L':
			*bp = 'F';
			break;
		case 'D':
		case 'N':
			memset(bp, '0', f->len);
			break;
		}
	}

	fp->dirty = 1;
	fp->blank = 1;
	fp->valid = 1;

	return 0;
}

static int
delflag(struct DbfFile *fp, int set)
{
	long recno, last;
	char *bp;
	DbfHeader *hp;

	if (fp->readonly)
		return dbf_error(fp, __LINE__, "write operation on read-only base '%s'", fp->name);

	recno = fp->pos;

	if (lock_header(fp, 0, &hp))
		return dbf_merror(fp, fp->mp, __LINE__);

	last = recCount(hp);

	if (recno <= 0 || recno > last)
		return dbf_error(fp, __LINE__, "invalid postion: %ld", recno);

	if (lock_rec(fp, 1, recno, &bp))
		return dbf_merror(fp, fp->mp, __LINE__);

	if (set)
		*bp = '*';
	else
		*bp = ' ';

	if (unlock_rec(fp, recno))
		return dbf_merror(fp, fp->mp, __LINE__);

	if (unlock_header(fp))
		return dbf_merror(fp, fp->mp, __LINE__);

	return 0;
}

int
delete_DbfFile(struct DbfFile *fp)
{
	int r;

	if ((r = write_dirty(fp)))
		return r;

	return delflag(fp, 1);
}

int
recall_DbfFile(struct DbfFile *fp)
{
	int r;

	if ((r = write_dirty(fp)))
		return r;

	return delflag(fp, 0);
}

int
flush_DbfFile(struct DbfFile *fp)
{
	return write_dirty(fp);
}

static int
make_valid(struct DbfFile *fp)
{
	long recno, last;
	char *bp;
	DbfHeader *hp;

	recno = fp->pos;

	if (fp->blank || fp->valid)
		return 0;
/*
	if (recno == DBF_EOF_POS || recno == DBF_BOF_POS)
	{
		if (fp->validpos == DBF_EOF_POS || fp->validpos == DBF_BOF_POS)
		{
			memset(fp->recbuf, ' ', fp->recSize);
			memset(fp->precbuf, ' ', fp->recSize);
			goto ret;
		}
		recno = fp->validpos;
	}
*/
	if (recno == DBF_EOF_POS || !fp->validpos/* || recno == DBF_BOF_POS*/)
	{
		memset(fp->recbuf, ' ', fp->recSize);
		memset(fp->precbuf, ' ', fp->recSize);
		goto ret;
	}

	if (lock_header(fp, 0, &hp))
		return dbf_merror(fp, fp->mp, __LINE__);

	last = recCount(hp);
	/*last = recCount_MapFile(fp->mp);*/

	if (recno == DBF_BOF_POS)
	{
		if (fp->validpos>last)
		{
			memset(fp->recbuf, ' ', fp->recSize);
			memset(fp->precbuf, ' ', fp->recSize);
			goto ret;
		}
		else
			recno = fp->validpos;
	}

	if (recno <= 0 || (recno > last && last))
		return dbf_error(fp, __LINE__, "invalid position: %ld, last=%ld", recno, last);

	if (lock_rec(fp, 0, recno, &bp))
		return dbf_merror(fp, fp->mp, __LINE__);

	memcpy(fp->recbuf, bp, fp->recSize);
	/*memcpy(fp->precbuf, fp->recbuf, fp->recSize);*/

	if (unlock_rec(fp, recno))
		return dbf_merror(fp, fp->mp, __LINE__);

	fp->validpos = recno;

      ret:
	fp->valid = 1;

	if (unlock_header(fp))
		return dbf_merror(fp, fp->mp, __LINE__);

	return 0;
}

char *
dbf_mem_dup(char *mem, int len)
{
	char *ret = (char *) malloc(len + 1);

	memcpy(ret, mem, len);
	ret[len] = 0;
	return ret;
}

/*
 *    Юлианская -> Календарная
 *    ww - номер дня недели (0 - Вск, 1 - Пнд и т.д.)
 */
void
dbf_cdate(long ju, int *dd, int *mm, int *yy, int *ww)
{
	long alf, a, b, c, d, e;

	alf = (long) ((ju - 1867216.25) / 36524.25);
	a = ju < 2299161L ? ju : ju + 1L + alf - alf / 4;
	b = a + 1524;
	c = (long) ((b - 122.1) / 365.25);
	d = (long) (365.25 * c);
	e = (long) ((b - d) / 30.6001);
	*dd = b - d - (long) (30.6001 * e);
	if (e < 14)
		*mm = e - 1;
	else
		*mm = e - 13;
	if (*mm > 2)
		*yy = c - 4716;
	else
		*yy = c - 4715;
	*ww = (ju + 1) % 7L;
}

/*
 *    Календарная -> Юлианская
 */
long
dbf_jdate(int dd, int mm, int yy)
{
	int a, b;

	b = 0;
	if (mm <= 2)
	{
		yy--;
		mm += 12;
	}
	if ((yy * 10000.0 + mm * 100.0 + dd) >= 15821015.0)
	{
		a = yy / 100;
		b = 2 - a + a / 4;
	}
	return ((long) (365.25 * yy - (yy ? 0.0 : 0.75))
		+ (long) (30.6001 * (mm + 1) + dd + 1720995 + b));
}

int
getVal_DbfFile(struct DbfFile *fp, int fld_no, DbfData * vp)
{
	int r;
	DbfField *f = fp->fields + fld_no;
	char *bp = fp->recbuf + f->offs;
	char *buf;
	int len = f->len;

	if (fp->blank)
		if ((r = write_dirty(fp)))
			return r;

	if ((r = make_valid(fp)))
		return r;

	destroy_DbfData(vp);

	switch (f->type)
	{
	case 'C':
		vp->type = 'C';
		vp->u.c.str = (char *) dbf_mem_dup(bp, len);
		vp->u.c.len = len;
		read_translate(fp, vp->u.c.str, vp->u.c.len);
		vp->flags = 0;
		break;
	case 'M':
		{
			long block;
			char *s;
			int r;

			buf = fp->buf;
			memcpy(buf, bp, 10);
			buf[10] = 0;
			for (s = buf; *s && *s == ' '; ++s)
				;
			block = atol(s);
			vp->u.c.str = 0;
			vp->u.c.len = 0;
			r = fp->mtbl->get(fp->memo, &vp->u.c.str, &vp->u.c.len, block);
			if (r)
			{
				fp->mtbl->error(fp->memo, fp->errbuf, ERRBUFSIZE);
				return r;
			}

			read_translate(fp, vp->u.c.str, vp->u.c.len);
			vp->type = 'M';
			vp->flags = 0;
		}
		break;
	case 'N':
		vp->type = 'N';
		vp->len = f->len;
		vp->dec = f->dec;
		buf = fp->buf;
		memcpy(buf, bp, len);
		buf[len] = 0;
		vp->u.n = strtod(buf, 0);
		break;
	case 'L':
		vp->type = 'L';
		vp->u.l = (*bp == 'T' ? 1 : 0);
		break;
	case 'D':
		{
			int yy = 0, mm = 0, dd = 0;

			if (memcmp(bp, "        ", 8))
			{
				buf = fp->buf;
				memcpy(buf, bp, 4);
				buf[4] = 0;
				sscanf(buf, "%d", &yy);
				memcpy(buf, bp + 4, 2);
				buf[2] = 0;
				sscanf(buf, "%d", &mm);
				memcpy(buf, bp + 6, 2);
				buf[2] = 0;
				sscanf(buf, "%d", &dd);
				vp->u.d = dbf_jdate(dd, mm, yy);
			}
			else
			{
				vp->u.d = 0;
			}

			vp->type = 'D';
		}
		break;
	}

	return 0;
}

int
setVal_DbfFile(struct DbfFile *fp, int fld_no, DbfData * vp)
{
	DbfField *f = fp->fields + fld_no;
	char *bp = fp->recbuf + f->offs;
	char *buf;
	int len = f->len;
	int l;
	int r;

	if (fp->blank)
		if ((r = write_dirty(fp)))
			return r;

	if (!fp->dirty)
	{
		if ((r = make_valid(fp)))
			return r;
		memcpy(fp->precbuf, fp->recbuf, fp->recSize);
		fp->dirty = 1;
	}

	if (fp->pos == DBF_BOF_POS || fp->pos == DBF_EOF_POS)
		return 0;

	switch (f->type)
	{
	case 'C':
		if (vp->type != 'C')
			return dbf_error(fp, __LINE__, "assignment to CHARACTER field '%s' from non-character var", f->name);
		l = vp->u.c.len;
		if (l > len)
			l = len;
		else
			memset(bp + l, ' ', len - l);
		memcpy(bp, vp->u.c.str, l);
		write_translate(fp, bp, l);
		break;
	case 'M':
		{
			long block;
			char *s;
			int r;

			if (vp->type != 'C' && vp->type != 'M')
				return dbf_error(fp, __LINE__, "assignment to MEMO field '%s' from non-character var", f->name);

			buf = fp->buf;
			memcpy(buf, bp, 10);
			buf[10] = 0;
			for (s = buf; *s && *s == ' '; ++s)
				;
			block = atol(s);
			write_translate(fp, vp->u.c.str, vp->u.c.len);

			r = fp->mtbl->put(fp->memo, vp->u.c.str, vp->u.c.len, &block);
			if (r)
			{
				fp->mtbl->error(fp->memo, fp->errbuf, ERRBUFSIZE);
				return r;
			}
			sprintf(buf, "%10ld", block);
			memcpy(bp, buf, 10);
		}
		break;
	case 'N':
		if (vp->type != 'N')
			return dbf_error(fp, __LINE__, "assignment to NUMERIC field '%s' from non-numeric var", f->name);
		buf = fp->buf;
		snprintf(buf, fp->buflen, "%*.*f", len, f->dec, vp->u.n);
		memcpy(bp, buf, len);
		break;
	case 'L':
		if (vp->type != 'L')
			return dbf_error(fp, __LINE__, "assignment to LOGICAL field '%s' from non-logical var", f->name);
		*bp = (vp->u.l ? 'T' : 'F');
		break;
	case 'D':
		{
			int yy, mm, dd, ww;

			if (vp->type != 'D')
				return dbf_error(fp, __LINE__, "assignment to DATE field '%s' from non-date var", f->name);

			buf = fp->buf;
			dbf_cdate(vp->u.d, &dd, &mm, &yy, &ww);
			snprintf(buf, fp->buflen, "%04d%02d%02d", yy, mm, dd);
			memcpy(bp, buf, 8);
		}
		break;
	}

	return 0;
}

int
bof_DbfFile(struct DbfFile *fp, int *val)
{
	int r;

	if ((r = write_dirty(fp)))
		return r;
	*val = (fp->pos == DBF_BOF_POS ? 1 : 0);
	return 0;
}

int
eof_DbfFile(struct DbfFile *fp, int *val)
{
	int r;

	if ((r = write_dirty(fp)))
		return r;

	*val = (fp->pos == DBF_EOF_POS ? 1 : 0);

	if (!(*val))
	{
		DbfHeader *hp;
		if ((r = lock_header(fp, 0, &hp)))
			return r;

		*val = fp->validpos > recCount(hp) ? 1 : 0;
		if (!(*val) && !fp->validpos)
			*val = fp->pos == DBF_BOF_POS ? 1 : 0;

		if ((r = unlock_header(fp)))
			return r;
	}
	return 0;
}

int
deleted_DbfFile(struct DbfFile *fp, int *val)
{
	long recno, last;
	char *bp;
	DbfHeader *hp;
	int r;

	if ((r = write_dirty(fp)))
		return r;

	recno = fp->pos;

	if (lock_header(fp, 0, &hp))
		return dbf_merror(fp, fp->mp, __LINE__);

	last = recCount(hp);

	if (recno < 1 || recno > last)
	{
//		return dbf_error(fp, __LINE__, "invalid postion: %ld", recno);
		*val = 0;
		return 0;
	}

	if (lock_rec(fp, 0, recno, &bp))
		return dbf_merror(fp, fp->mp, __LINE__);

	*val = (*bp == ' ' ? 0 : 1);

	if (unlock_rec(fp, recno))
		return dbf_merror(fp, fp->mp, __LINE__);

	if (unlock_header(fp))
		return dbf_merror(fp, fp->mp, __LINE__);

	return 0;
}

int
showdel_DbfFile(struct DbfFile *fp, int newval)
{
	int r;

	r = fp->showdel;

	if (newval >= 0)
		fp->showdel = newval;

	return r;
}

int
recNo_DbfFile(struct DbfFile *fp, long *val)
{
	int r;

	if ((r = write_dirty(fp)))
		return r;
	*val = fp->validpos ? fp->validpos : 1;
	return 0;
}

static int
skip_index(struct DbfFile *fp, DbfIndex * ip, int nskip)
{
	int r = 0, i;

	if (nskip > 0)
	{
		for (i = 0; !r && i < nskip; ++i)
		{
			int res;

			if (fp->pos == DBF_BOF_POS /*&& fp->validpos == DBF_BOF_POS*/)
			{
				if (ip->low)
				{
					int found;

					r = seek_index(fp, ip, ip->low, &found);
				}
				else
				{
					r = fp->itbl->first(fp, ip);
					if (!r)
						fp->pos = ip->keypos;
				}
				/*
				if (ip->keypos!=DBF_EOF_POS && ip->keypos!=DBF_BOF_POS)
					fp->validpos = ip->keypos;
				*/
				if (r)
					return r;
//				continue;
			}
			else if (fp->pos == DBF_EOF_POS)
			{
				ip->keypos = DBF_EOF_POS;
				break;
			}

			if (ip->hi)
			{

				if ((r = test_key(fp, ip, ip->hi, &res)))
					return r;
				if (res > 0)
				{
					fp->pos = DBF_EOF_POS;
					return 0;
				}
			}
/*
			calc_index(fp, ip, 0);
			memcpy(ip->keybuf, fp->buf, MIN(fp->keylen,ip->len));
*/
			r = fp->itbl->next(fp, ip);
			if ( !r && ip->keypos!=DBF_EOF_POS && ip->keypos!=DBF_BOF_POS)
				fp->validpos = ip->keypos;
			else
			{
				fp->validpos++;
				break;
			}
		}
	}
	else if (nskip < 0)
	{
		for (i = 0; !r && i > nskip; --i)
		{
			int res;

			if (fp->pos == DBF_EOF_POS /*&& fp->validpos == DBF_EOF_POS*/)
			{
				if (ip->hi)
				{
					int found;

					r = seek_index(fp, ip, ip->hi, &found);
				}
				else
				{
					r = fp->itbl->last(fp, ip);
					if (!r)
						fp->pos = ip->keypos;
				}
				/*
				if (ip->keypos!=DBF_EOF_POS && ip->keypos!=DBF_BOF_POS)
					fp->validpos = ip->keypos;
				*/
				if (r)
					return r;
				continue;
			}
			else if (fp->pos == DBF_BOF_POS)
			{
				ip->keypos = DBF_BOF_POS;
				break;
			}

			if (ip->low)
			{
				if ((r = test_key(fp, ip, ip->low, &res)))
					return r;
				if (res < 0)
				{
					fp->pos = DBF_BOF_POS;
					return 0;
				}
			}
/*
			calc_index(fp, ip, 0);
			memcpy(ip->keybuf, fp->buf, MIN(fp->keylen,ip->len));
*/
			r = fp->itbl->prev(fp, ip);

			if (! r && ip->keypos!=DBF_EOF_POS && ip->keypos!=DBF_BOF_POS)
				fp->validpos = ip->keypos;
			else
				break;
		}
	}

	fp->pos = ip->keypos;
	if (ip->keypos!=DBF_EOF_POS && ip->keypos!=DBF_BOF_POS)
		fp->validpos = ip->keypos;
	if (!r)
		fp->valid = 0;

	return r;
}

static int
seek_index(struct DbfFile *fp, DbfIndex * ip, DbfData * dp, int *found)
{
	int r;
	Tuple tup;

	if ((r = put_key(fp, ip, dp)))
		return r;

	memset(&tup, 0, sizeof(tup));
	tup.key = fp->buf;
	tup.len = fp->keylen;
	tup.size = fp->buflen;
	tup.value = 0;
	tup.ok = 0;

	r = fp->itbl->seek(fp, ip, &tup);

	if (r)
		goto ret;

	*found = (tup.ok ? 1 : 0);

	ip->keypos = tup.value;
	memcpy(ip->keybuf, tup.key, ip->len);
	ip->keybuf[ip->len] = 0;

	fp->pos = ip->keypos;
	fp->valid = 0;

      ret:
	if (tup.freemem)
		free(tup.key);

	return r;
}

int
seek_DbfFile(struct DbfFile *fp, DbfData *dp, int softseek, int *found)
{
	DbfIndex *ip = fp->index;
	int r;

	if ((r = write_dirty(fp)))
		return r;

	if (!ip)
		return dbf_error(fp, __LINE__, "no active index");

/*
	if (dp->type == 'C' && dp->u.c.len)
*/
		r = seek_index(fp, ip, dp, found);
/*
	else
		r = goTop_DbfFile(fp);
*/
	if (!*found && !softseek)
		fp->pos = DBF_EOF_POS;
	else
	{
		int res;

		r = test_filter(fp, &res);
		if (r)
			return r;
		if (!res)
		{
			if (!softseek)
				fp->pos = DBF_EOF_POS;
			else
				r = skip_DbfFile(fp, 1);
		}
	}

	return r;
}

int
goTop_DbfFile(struct DbfFile *fp)
{
	DbfHeader *hp;
	int r, res;
	long last;

	if ((r = write_dirty(fp)))
		return r;

	fp->valid = 0;

	if (fp->index)
	{
		if (fp->index->low)
		{
			int found;

			r = seek_index(fp, fp->index, fp->index->low, &found);
		}
		else
		{
			r = fp->itbl->first(fp, fp->index);
			if (!r)
				fp->validpos = fp->pos = fp->index->keypos;
		}
		if (r)
			return r;
		goto filt;
	}

	if ((r = lock_header(fp, 0, &hp)))
		return r;

	last = recCount(hp);

	if ((r = unlock_header(fp)))
		return r;

	if (last)
		fp->validpos = fp->pos = 1;
	else
		fp->pos = DBF_BOF_POS;

      filt:
	fp->valid = 0;
	if (fp->pos < 1)
		return 0;
	r = test_filter(fp, &res);
	if (r)
		return r;
	if (res)
		return 0;

	return skip_DbfFile(fp, 1);
}

int
goBottom_DbfFile(struct DbfFile *fp)
{
	DbfHeader *hp;
	int r, res;
	long last;

	if ((r = write_dirty(fp)))
		return r;

	fp->valid = 0;
	if (fp->index)
	{
		if (fp->index->hi)
		{
			int found;

			r = seek_index(fp, fp->index, fp->index->hi, &found);
		}
		else
		{
			r = fp->itbl->last(fp, fp->index);
			if (!r)
				fp->validpos = fp->pos = fp->index->keypos;
		}
		if (r)
			return r;
		goto filt;
	}

	if ((r = lock_header(fp, 0, &hp)))
		return r;

	last = recCount(hp);

	if ((r = unlock_header(fp)))
		return r;

	if (last)
		fp->validpos = fp->pos = last /*- 1*/ ;
	else
		fp->pos = DBF_BOF_POS;

      filt:
	fp->valid = 0;
	if (fp->pos < 1)
		return 0;
	r = test_filter(fp, &res);
	if (r)
		return r;
	if (res)
		return 0;

	return skip_DbfFile(fp, -1);
}

int
goTo_DbfFile(struct DbfFile *fp, long recno)
{
	DbfHeader *hp;
	int r;
	long last;

	if ((r = write_dirty(fp)))
		return r;

	fp->valid = 0;
	if (recno == DBF_EOF_POS)
	{
		fp->pos = recno;
		return 0;
	}

	if ((r = lock_header(fp, 0, &hp)))
		return r;

	last = recCount(hp);

	if ((r = unlock_header(fp)))
		return r;

	if (recno <= 0 || recno > last)
	{
		recno = DBF_BOF_POS;
		fp->validpos = last+1;
	}

	fp->pos = recno;
	if ((r = make_valid(fp)))
		return r;

	if (fp->index)
		r = act_index(fp, fp->index);

	return r;
}

int
skip_DbfFile(struct DbfFile *fp, long nskip)
{
	DbfHeader *hp;
	int r, res;
	long last, newpos;

	if ((r = write_dirty(fp)))
		return r;

	for (;;)
	{

		fp->valid = 0;

		if ((r = lock_header(fp, 0, &hp)))
			return r;

		last = recCount(hp);

		if ((r = unlock_header(fp)))
			return r;

		if (fp->index)
		{
			r = skip_index(fp, fp->index, nskip);
			if (r)
				return r;
			if (fp->pos == DBF_EOF_POS)
				fp->validpos = last + 1;

			goto filt;
		}

		if (fp->pos == DBF_BOF_POS)
			/*newpos = 0 + nskip;*/
			newpos = 1 + nskip;
		else if (fp->pos == DBF_EOF_POS)
			/*newpos = last + nskip;*/
			newpos = last + nskip + 1;
		else
			newpos = fp->pos + nskip;

		if (newpos < 1)
		{
			fp->pos = DBF_BOF_POS;
			fp->validpos = 1;
		}
		else if (newpos > last)
		{
			fp->validpos = last + (last ? 1 : 0);
			if (last)
				fp->pos = DBF_EOF_POS;
			else
				fp->pos = DBF_BOF_POS;
		}
		else
			fp->pos = newpos;
	      filt:
		if (fp->pos < 1)
			break;
		r = test_filter(fp, &res);
		if (r)
			return r;
		if (res)
			break;
	}

	return 0;
}

int
lock_DbfFile(struct DbfFile *fp, long recno)
{
	char *bp;
	DbfHeader *hp;
	long last;
	int r;

	if ((r = write_dirty(fp)))
		return r;

	if ((r = lock_header(fp, 0, &hp)))
		return r;

	last = recCount(hp);

	if ((r = unlock_header(fp)))
		return r;

	if (recno <= 0 || recno > last)
		return dbf_error(fp, __LINE__, "invalid postion: %ld", recno);

	if (lock_rec(fp, 1, recno, &bp))
		return dbf_merror(fp, fp->mp, __LINE__);
	return 0;
}

int
unlock_DbfFile(struct DbfFile *fp, long recno)
{
	DbfHeader *hp;
	long last;
	int r;

	if ((r = write_dirty(fp)))
		return r;

	if ((r = lock_header(fp, 0, &hp)))
		return r;

	last = recCount(hp);

	if ((r = unlock_header(fp)))
		return r;

	if (recno <= 0 || recno > last)
		return dbf_error(fp, __LINE__, "invalid postion: %ld", recno);

	if (unlock_rec(fp, recno))
		return dbf_merror(fp, fp->mp, __LINE__);
	return 0;
}

int
unlockAll_DbfFile(struct DbfFile *fp)
{
	DbfHeader *hp;
	long last;
	int cmd = F_SETLK;
	struct flock fl;
	int r;

	if ((r = write_dirty(fp)))
		return r;

	if ((r = lock_header(fp, 0, &hp)))
		return r;

	last = recCount(hp);

	if ((r = unlock_header(fp)))
		return r;

	fl.l_type = F_UNLCK;
	fl.l_whence = SEEK_SET;
	fl.l_start = 1000000000;
	fl.l_len = 1000000000;

	r = fcntl(fd_MapFile(fp->mp), cmd, &fl);

	if (r)
		snprintf(fp->errbuf, ERRBUFSIZE, "unlockAll: %s", strerror(errno));

	return r;
}

int
lockF_DbfFile(struct DbfFile *fp)
{
	DbfHeader *hp;
	int r;

	if ((r = write_dirty(fp)))
		return r;

	if (lock_header(fp, 1, &hp))
		return dbf_merror(fp, fp->mp, __LINE__);
	return 0;
}

int
unlockF_DbfFile(struct DbfFile *fp)
{
	int r;

	if ((r = write_dirty(fp)))
		return r;
	if (unlock_header(fp))
		return dbf_merror(fp, fp->mp, __LINE__);
	return 0;
}

/* ] DbfFile */
/* [ indexes */
static char *
make_index_name(struct DbfFile *fp, char *name)
{
	char *s;
	char buf[256];
	char *ext = ".ind";

	memset(buf, 0, 256);
	strncpy(buf, name, MIN(strlen(buf) - 5, 251));
	s = strrchr(name, '/');
	if (!s)
		s = buf;
	s = strrchr(s, '.');
	if (!s)
		s = buf + strlen(buf);
	if (s && !s[1])
	{
		*s = 0;
		if (fp->itbl)
			ext = (char *) fp->itbl->name_suffix;
		strcpy(buf + strlen(buf), ext);
	}

	return strdup(buf);
}

static void
translate(struct DbfFile *fp, unsigned char *str, int len)
{
	if (!fp->cmptbl)
		return;
	while (len)
	{
		int s = *str;

		if (s > 127)
			*str = fp->cmptbl->cmp[s - 128];
		--len;
		++str;
	}
}

static void
read_translate(struct DbfFile *fp, unsigned char *str, int len)
{
	if (!fp->cmptbl)
		return;
	while (len)
	{
		int s = *str;

		if (s > 127)
			*str = fp->cmptbl->read[s - 128];
		--len;
		++str;
	}
}

static void
write_translate(struct DbfFile *fp, unsigned char *str, int len)
{
	if (!fp->cmptbl)
		return;
	while (len)
	{
		int s = *str;

		if (s > 127)
			*str = fp->cmptbl->write[s - 128];
		--len;
		++str;
	}
}

static int
put_key(struct DbfFile *fp, DbfIndex * ip, DbfData * vp)
{
	switch (vp->type)
	{
	case 'C':
	case 'M':
		{
			int l;

			l = vp->u.c.len;
			if (l >= ip->len)
				l = ip->len;
			memcpy(fp->buf, vp->u.c.str, l);
			translate(fp, fp->buf, l);
			fp->buf[l] = 0;
			fp->keylen = l;
			return 0;
		}
		break;
	case 'N':
		{
			int len = ip->len;
			int dec = ip->dec;

			if (!len)
			{
				len = 18;
				dec = 18;
			}
			if (vp->u.n >= 0)
				snprintf(fp->buf, fp->buflen, "%0*.*f", len, dec, vp->u.n);
			else
			{
				char *s;

				snprintf(fp->buf, fp->buflen, "%0*.*f", len, dec, -vp->u.n);
				for (s = fp->buf; *s; ++s)
					switch (*s)
					{
					case '0':
						*s = ',';
						break;
					case '1':
						*s = '+';
						break;
					case '2':
						*s = '*';
						break;
					case '3':
						*s = ')';
						break;
					case '4':
						*s = '(';
						break;
					case '5':
						*s = '\'';
						break;
					case '6':
						*s = '&';
						break;
					case '7':
						*s = '%';
						break;
					case '8':
						*s = '$';
						break;
					case '9':
						*s = '#';
						break;
					}
			}
			fp->keylen = strlen(fp->buf);
			return 0;
		}
		break;
	case 'D':
		{
			int yy, mm, dd, ww;

			dbf_cdate(vp->u.d, &dd, &mm, &yy, &ww);
			snprintf(fp->buf, fp->buflen, "%04d%02d%02d", yy, mm, dd);
			fp->keylen = strlen(fp->buf);
			return 0;
		}
		break;
	case 'L':
		{
			fp->buf[0] = (vp->u.l ? 'T' : 'F');
			fp->buf[1] = 0;
			fp->keylen = 1;
			return 0;
		}
		break;
	}
	snprintf(fp->errbuf, ERRBUFSIZE, "unknown DbfData type '%c'", vp->type);
	return 1;
}

static int
act_index(struct DbfFile *fp, DbfIndex * ip)
{
	int r, l;

	if ((r = calc_index(fp, ip, 0)))
		return r;

	l = fp->keylen;
	if (l > ip->len)
		l = ip->len;

	memset(ip->keybuf, ' ', ip->len);
	ip->keybuf[ip->len] = 0;
	memcpy(ip->keybuf, fp->buf, l);

	ip->keypos = fp->pos;

	return r;
}

static int
calc_index(struct DbfFile *fp, DbfIndex * ip, int prev)
{
	int r;
	DbfData data;
	char *p;

	data.type = 'U';

	if (prev && fp->dirty)
	{
		p = fp->recbuf;
		fp->recbuf = fp->precbuf;
		fp->precbuf = p;
	}

	if (ip->simple)
		r = getVal_DbfFile(fp, ip->fld_no, &data);
	else
		r = fp->calc(fp, &data, ip->expr, &ip->par);

	if (r)
		goto ret;

	if ((r = put_key(fp, ip, &data)))
	{
		dbf_error(fp, __LINE__, "cannot convert index expression value into string (tag='%s', recno=%d)", ip->tag, fp->pos);
		goto ret;
	}

      ret:
	destroy_DbfData(&data);
	if (prev && fp->dirty)
	{
		p = fp->recbuf;
		fp->recbuf = fp->precbuf;
		fp->precbuf = p;
	}

	return r;
}

static int
addel_index(struct DbfFile *fp, DbfIndex * ip, int del, int prev)
{
	int r;
	Tuple tup;

	if ((r = calc_index(fp, ip, prev)))
		return r;

	memset(&tup, 0, sizeof(tup));
	tup.key = fp->buf;
	tup.len = fp->keylen;
	tup.size = fp->buflen;
	tup.value = fp->pos;
	tup.ok = 0;

	if (del)
		r = fp->itbl->delkey(fp, ip, &tup);
	else
		r = fp->itbl->addkey(fp, ip, &tup);
	if (r)
		return r;

	if (!del && !tup.ok)
	{
		r = dbf_error(fp, __LINE__, "invalid (duplicated?) expression value (tag='%s', recno=%d)", ip->tag, fp->pos);
		return r;
	}

	/**/
	if (!del && fp->validpos!=tup.value)
	{
		ip->keypos = tup.value;
		memcpy(ip->keybuf, tup.key, ip->len);
		ip->keybuf[ip->len] = 0;
	}
	/**/

	return r;
}

static int
update_indexes(struct DbfFile *fp)
{
	int i, r = 0, prev;

	if (fp->dirty)
		prev = 1;
	else
		prev = 0;

	for (i = 0; i < fp->nindex; ++i)
	{
		DbfIndex *ip = fp->indexes[i];

		if (!ip)
			continue;

		if (fp->blank)
		{
			if ((r = addel_index(fp, ip, 0, 0)))
				break;
		}
		else
		{
			if (ip->simple)
			{
				DbfField *fldp = fp->fields + ip->fld_no;

				if (!memcmp(fp->recbuf + fldp->offs, fp->precbuf + fldp->offs, fldp->len))
					continue;

			}

			fp->dirty = 1;
			prev = 1;

			if ((r = addel_index(fp, ip, 1, prev)))
				break;
			if ((r = addel_index(fp, ip, 0, 0)))
				break;

			fp->dirty = 0;
			memcpy(ip->keybuf, fp->buf, MIN(fp->keylen,ip->len));
		}
	}

	return r;
}

/* ] indexes */
/* [ filter */

int
setFilter_DbfFile(struct DbfFile *fp, char *expr)
{
	write_dirty(fp);
	if (fp->fexpr)
	{
		free(fp->fexpr);
		fp->fexpr = 0;
	}
	if (fp->fpar)
	{
		free(fp->fpar);
		fp->fpar = 0;
	}

	if (!expr)
		return 0;

	fp->fexpr = strdup(expr);
	return 0;
}

int
setEval_DbfFile(struct DbfFile *fp, void *machine, ClipEval eval)
{
	write_dirty(fp);
	fp->clipmach = machine;
	fp->eval = eval;
	return 0;
}

int
setRange_DbfFile(struct DbfFile *fp, char *index, DbfData * low, DbfData * hi)
{
	DbfIndex *ip;

	write_dirty(fp);
	ip = find_index(fp, index);
	if (!ip)
		return dbf_error(fp, __LINE__, "no index '%s'", index);

	if (ip->low)
	{
		destroy_DbfData(ip->low);
		free(ip->low);
	}
	if (ip->hi)
	{
		destroy_DbfData(ip->hi);
		free(ip->hi);
	}

	if (low)
		ip->low = dup_DbfData(low);
	else
		ip->low = 0;

	if (hi)
		ip->hi = dup_DbfData(hi);
	else
		ip->hi = 0;

	return 0;
}

static int
test_filter(struct DbfFile *fp, int *res)
{
	DbfData data;
	int r;

	make_valid(fp);
	*res = 1;


	if (!fp->showdel && fp->recbuf[0] != ' ')
	{
		*res = 0;
		return 0;
	}

	if(fp->clipmach && fp->eval)
	{
		*res = fp->eval(fp->clipmach);
		return 0;
	}

	if (!fp->fexpr)
		return 0;

	if (!fp->calc)
		return dbf_error(fp, __LINE__, "no calculation function");

	memset(&data, 0, sizeof(data));

	r = fp->calc(fp, &data, fp->fexpr, &fp->fpar);

	if (!r)
	{
		if (data.type != 'L')
			r = dbf_error(fp, __LINE__, "non-logical result of expression");
		else
			*res = data.u.l;
	}

	destroy_DbfData(&data);

	return r;
}

static int
cmp_DbfData(DbfData * lp, DbfData * rp)
{
	if (lp->type != rp->type)
	{
		return lp->type - rp->type;
	}

	switch (lp->type)
	{
	default:
		return 0;
	case 'N':
		if (lp->u.n < rp->u.n)
			return -1;
		else if (lp->u.n > rp->u.n)
			return 1;
		else
			return 0;
	case 'L':
		if (!lp->u.l && rp->u.l)
			return 1;
		else if (lp->u.l && !rp->u.l)
			return -1;
		else
			return 0;
	case 'D':
		if (lp->u.d < rp->u.d)
			return -1;
		else if (lp->u.d > rp->u.d)
			return 1;
		else
			return 0;
	case 'C':
		{
			int ll = lp->u.c.len;
			int rl = rp->u.c.len;
			int cl = rl;
			int l = 0;

			l = strncmp(lp->u.c.str, rp->u.c.str, cl);
			if (!l)
			{
				if (ll < rl)
					l = -1;
				else if (ll > rl)
					l = 1;
			}
			return l;
		}
	}
}

static int
test_key(struct DbfFile *fp, DbfIndex * ip, DbfData * vp, int *res)
{
	int r;
	DbfData data;

	if (ip->simple)
		r = getVal_DbfFile(fp, ip->fld_no, &data);
	else
		r = fp->calc(fp, &data, ip->expr, &ip->par);

	if (r)
		goto ret;

	*res = cmp_DbfData(&data, vp);

      ret:
	destroy_DbfData(&data);
	return r;
}

int
locate_DbfFile(struct DbfFile *fp, char *fexpr, char *wexpr, int next, int rec, int rest, int *found)
{
	int r = 0;

	*found = 0;

	if ((r = write_dirty(fp)))
		return r;

	if (!fp->calc)
		return dbf_error(fp, __LINE__, "no calculation function");

	if (!fexpr && !wexpr && !fp->locate_fpar && !fp->locate_wpar)
		return 0;

	if (!rest)
	{
		if (rec)
			r = goTo_DbfFile(fp, rec);
		else
			r = goTop_DbfFile(fp);
		if (r)
			goto ret;
		make_valid(fp);
		fp->locate_next = next;
	}

	if (fexpr)
	{
		if (fp->locate_fpar)
		{
			free(fp->locate_fpar);
			fp->locate_fpar = 0;
		}
		if (fp->locate_wpar)
		{
			free(fp->locate_wpar);
			fp->locate_wpar = 0;
		}
		fp->locate_next = next;
	}

	while (fp->pos >= 0)
	{
		int wcond = 1;

		if (!fp->locate_next)
		{
			/* fp->locate_next = -1; */
			break;
		}

		if (!fp->showdel && fp->recbuf[0] != ' ')
			goto next;

		if (wexpr||fp->locate_wpar)
		{
			DbfData data;

			memset(&data, 0, sizeof(data));
			r = fp->calc(fp, &data, wexpr, &fp->locate_wpar);

			if (!r)
			{
				if (data.type != 'L')
					r = dbf_error(fp, __LINE__, "non-logical result of expression");
				else
					wcond = data.u.l;
			}
			destroy_DbfData(&data);
			if (r)
				goto ret;
		}

		if (!wcond)
			break;

		if (fexpr||fp->locate_fpar)
		{
			DbfData data;

			memset(&data, 0, sizeof(data));
			r = fp->calc(fp, &data, fexpr, &fp->locate_fpar);

			if (!r)
			{
				if (data.type != 'L')
					r = dbf_error(fp, __LINE__, "non-logical result of expression");
				else
					*found = data.u.l;
			}
			destroy_DbfData(&data);
			if (r)
				goto ret;
		}

		if (*found)
			goto ret;

	      next:
		if (fp->locate_next > 0)
			fp->locate_next--;
		r = skip_DbfFile(fp, 1);
		make_valid(fp);
		if (r)
			goto ret;
	}

      ret:
	return r;
}

/* ] filter */

int
eval_DbfFile(struct DbfFile *fp, char *expr, DbfData *result)
{
	int r;
	void *compiled;

	if (!fp->calc)
		return dbf_error(fp, __LINE__, "cannot do eval: no calculator");

	compiled=0;
	r = fp->calc(fp, result, expr, &compiled);

	free(compiled);
	return r;
}

