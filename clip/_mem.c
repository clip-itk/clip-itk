/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log: _mem.c,v $
   Revision 1.20  2002/08/27 13:31:57  clip
   add _clip_ref_public_noadd func
   fix for mem restore
   paul

   Revision 1.19  2002/08/26 07:13:50  clip
   uri: strdup => memcpy in clip2dbf()

   Revision 1.18  2002/08/23 14:43:11  clip
   uri: warning fix

   Revision 1.17  2002/08/23 10:28:03  clip
   uri: small fix

   Revision 1.16  2001/11/10 11:38:29  clip
   uri: new desriptions commands SUM,COUNT, small bug in read_mem

   Revision 1.15  2001/11/01 14:54:40  clip
   _clip_path() - makes absolute path respecting SET DEFAULT, SET PATH etc
   rust

   Revision 1.14  2001/08/23 13:52:06  clip
   merge with NEWLOCALS
   paul

   Revision 1.13.2.1  2001/08/23 13:03:30  clip
   ref bug
   paul

   Revision 1.13  2001/06/13 13:05:47  clip
   uri: add case flag in _clip_glob_match(), fixed all calls  this functions

   Revision 1.12  2001/05/31 12:27:20  clip
   _clip_clip
   paul

   Revision 1.11  2001/05/29 07:17:08  clip
   register names in macro expr
   paul

   Revision 1.10  2001/04/05 10:08:17  clip
   dbf/dbf.h not recured now
   rust

   Revision 1.9  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.8  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.7  2001/03/11 10:36:16  clip
   some fixes
   rust

   Revision 1.6  2000/05/24 18:33:56  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.5  2000/05/15 21:00:59  clip
   ACOPY now work; _MSAVE, _MRESTORE .mem will appended automatically
   Paul Lasarev <paul@itk.ru>

   Revision 1.4  2000/05/03 19:32:26  clip
   add prefix 'clip_' to all clip functions

   Revision 1.3  2000/03/31 17:27:50  paul
   memfile

   Revision 1.2  2000/03/31 17:00:47  paul
   MRESTORE

   Revision 1.1  2000/03/31 16:53:21  paul
   memfile rw

 */
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>
#include <errno.h>

#include "clip.h"
#include "error.ch"
#include "rdd.h"
#include "coll.h"
#include "rational.h"

#define NEW(type) ((type*)calloc(sizeof(type),1))
#define NEWVECT(type,len) ((type*)calloc(sizeof(type),(len)))

#define DBFDATA_NONFREE 0x1

typedef struct
{
	unsigned char name[11];
	unsigned char type;
	unsigned char reserved1[4];
	unsigned char len;
	unsigned char dec;
	unsigned char reserved2[14];
}
MemHeader;

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

DbfLocale *dbf_get_locale(ClipMachine * mp);
int clip2dbf(ClipVar * vp, DbfData * dp);
int dbf2clip(DbfData * dp, ClipVar * vp);

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

int
clip2dbf(ClipVar * vp, DbfData * dp)
{
	if (!vp || !dp)
		return 1;
	vp = _clip_vptr(vp);
	switch (vp->t.type)
	{
	case CHARACTER_t:
		dp->type = 'C';
                /*
		dp->u.c.str = strdup(vp->s.str.buf);
                */
                dp->u.c.str = malloc(vp->s.str.len+1);
		memcpy(dp->u.c.str,vp->s.str.buf,vp->s.str.len+1);
		dp->u.c.len = vp->s.str.len;

		break;
	case NUMERIC_t:
		dp->type = 'N';
		if (vp->t.memo)
			dp->u.n = rational_toDouble(vp->r.r);
		else
			dp->u.n = vp->n.d;
		break;
	case LOGICAL_t:
		dp->type = 'L';
		dp->u.l = vp->l.val;
		break;
	case DATE_t:
		dp->type = 'D';
		dp->u.d = vp->d.julian;
		break;
	default:
		return 1;
	}
	dp->len = (unsigned char) vp->t.len;
	dp->dec = (unsigned char) vp->t.dec;
	dp->flags = 0;
	return 0;
}

int
dbf2clip(DbfData * dp, ClipVar * vp)
{
	if (!dp || !vp)
		return 1;
	memset(vp, 0, sizeof(ClipVar));
	switch (dp->type)
	{
	case 'C':
		vp->t.type = CHARACTER_t;
		vp->s.str.buf = dp->u.c.str;
		dp->u.c.str = 0;
		vp->s.str.len = dp->u.c.len;
		break;
	case 'M':
		vp->t.type = CHARACTER_t;
		vp->s.str.buf = dp->u.c.str;
		dp->u.c.str = 0;
		vp->s.str.len = dp->u.c.len;
		vp->t.memo = 1;
		break;
	case 'N':
		vp->t.type = NUMERIC_t;
		vp->t.memo = 0;
		/*
		   vp->t.memo= 1;
		   vp->r.r = rational_double_init(dp->u.n);
		   vp->t.len = dp->u.c.len;
		 */
		vp->n.d = dp->u.n;
		//vp->t.dec = dp->u.c.dec;   ???????? çÄÅ dec × dbf ?????
		break;
	case 'L':
		vp->t.type = LOGICAL_t;
		vp->l.val = dp->u.l;
		break;
	case 'D':
		vp->t.type = DATE_t;
		vp->d.julian = dp->u.d;
		break;
	default:
		return 1;
	}
	vp->t.len = dp->len;
	vp->t.dec = dp->dec;

	return 0;
}

static int
mem_error(char *errbuf, int errbuflen, int line, const char *fmt,...)
{
	int l;
	va_list ap;

	va_start(ap, fmt);
	snprintf(errbuf, errbuflen, "MEM: %s, line %d: ", __FILE__, line);
	l = strlen(errbuf);
	vsnprintf(errbuf + l, errbuflen - l, fmt, ap);
	va_end(ap);
	return 1;
}

int
read_MemFile(const char *path, DbfLocale * tbl,
		 DbfData ** resp, char ***names, int *rescount,
		 char *errbuf, int errbuflen)
{
	int r = 0, i, line;
	FILE *file;
	MemHeader mh;
	DbfData *dp;

	file = fopen(path, "rb");
	if (!file)
		return mem_error(errbuf, errbuflen, __LINE__,
				 "cannot open file '%s': %s",
				 path, strerror(errno));

	for (i = 0;; ++i)
	{
		if (fread(&mh, sizeof(mh), 1, file) != 1)
		{
			if (feof(file))
				break;
			line = __LINE__;
			  readerr:
			r = mem_error(errbuf, errbuflen, line,
					  "file '%s' read error: %s", strerror(errno));
			goto ret;
		}

		*resp = (DbfData *) realloc(*resp, ((*rescount) + 1) * sizeof(DbfData));
		*names = (char **) realloc(*names, ((*rescount) + 1) * sizeof(char *));

		dp = (*resp) + (*rescount);
		memset(dp, 0, sizeof(DbfData));
		(*names)[*rescount] = strdup(mh.name);
		++(*rescount);

		switch (mh.type)
		{
		case 0xC3:	/* string */
			{
				char *sp;
				int len;

				len = mh.len | (mh.dec << 8);

				sp = (char *) malloc(len);
				if (fread(sp, len, 1, file) != 1)
				{
					line = __LINE__;
					free(sp);
					goto readerr;
				}

				dp->type = 'C';
				dp->len = mh.len;
				dp->dec = mh.dec;
				dp->flags = 0;
				dp->u.c.str = sp;
				dp->u.c.len = --len;

				while (len)
				{
					int s = *(unsigned char *) sp;

					if (tbl && s > 127)
						*sp = tbl->read[s - 128];
					--len;
					++sp;
				}
			}
			break;
		case 0xCC:	/* logic */
			{
				char ch;

				if (fread(&ch, 1, 1, file) != 1)
				{
					line = __LINE__;
					goto readerr;
				}
				dp->type = 'L';
				dp->len = mh.len;
				dp->dec = mh.dec;
				dp->flags = 0;
				dp->u.l = ch;
			}
			break;
		case 0xCE:	/* numeric */
			{
				double d = 0;
				unsigned char buf[8];
				int j;

				if (fread(buf, 8, 1, file) != 1)
				{
					line = __LINE__;
					goto readerr;
				}
				for (j = 0; j < 8; ++j)
					((unsigned char *) &d)[j] = buf[j];

				dp->type = 'N';
				dp->len = mh.len;
				dp->dec = mh.dec;
				dp->flags = 0;
				dp->u.n = d;
			}
			break;
		case 0xC4:	/* date */
			{
				double d = 0;
				unsigned char buf[8];
				int j;

				if (fread(buf, 8, 1, file) != 1)
				{
					line = __LINE__;
					goto readerr;
				}
				for (j = 0; j < 8; ++j)
					((unsigned char *) &d)[j] = buf[j];

				dp->type = 'D';
				dp->len = mh.len;
				dp->dec = mh.dec;
				dp->flags = 0;
				dp->u.d = d;
			}
			break;

		default:
			r = mem_error(errbuf, errbuflen, __LINE__,
					  "invalid mem field type : 0x%0x", mh.type);
			goto ret;
		}

	}

	  ret:
	fclose(file);

	return r;
}

int
write_MemFile(const char *path, DbfLocale * tbl,
		  DbfData * arr, char **names, int acount,
		  char *errbuf, int errbuflen)
{
	int r = 0, i, line;
	FILE *file;
	MemHeader mh;
	DbfData *dp;

	file = fopen(path, "wb");
	if (!file)
		return mem_error(errbuf, errbuflen, __LINE__,
				 "cannot open file '%s': %s",
				 path, strerror(errno));

	for (i = 0; i < acount; ++i)
	{
		dp = arr + i;

		memset(&mh, 0, sizeof(mh));
		strncpy(mh.name, names[i], 10);

		switch (dp->type)
		{
		case 'C':
			{
				int len;

				len = dp->u.c.len + 1;
				mh.type = 0xC3;
				mh.len = len & 0xff;
				mh.dec = (len >> 8) & 0xff;
			}
			break;
		case 'L':
			mh.type = 0xCC;
			mh.len = 1;
			break;
		case 'N':
			mh.type = 0xCE;
			mh.len = dp->len;
			mh.dec = dp->dec;
			break;
		case 'D':
			mh.type = 0xC4;
			mh.len = 1;
			break;
		default:
			continue;
		}

		if (fwrite(&mh, sizeof(mh), 1, file) != 1)
		{
			line = __LINE__;
			  writerr:
			r = mem_error(errbuf, errbuflen, line,
					  "file '%s' write error: %s", strerror(errno));
			goto ret;
		}

		switch (mh.type)
		{
		case 0xC3:	/* string */
			{
				char *sp;
				int len;
				int j;

				len = dp->u.c.len + 1;
				sp = dp->u.c.str;

				for (j = 0; j < len; ++j, ++sp)
				{
					int s = *(unsigned char *) sp;

					if (tbl && s > 127)
						s = tbl->write[s - 128];
					if (fputc(s, file) == EOF)
					{
						line = __LINE__;
						goto writerr;
					}
				}
			}
			break;
		case 0xCC:	/* logic */
			{
				char ch;

				ch = dp->u.l;
				if (fputc(ch, file) == EOF)
				{
					line = __LINE__;
					goto writerr;
				}
			}
			break;
		case 0xCE:	/* numeric */
			{
				double d;
				unsigned char buf[8];
				int j;

				d = dp->u.n;
				for (j = 0; j < 8; ++j)
					buf[j] = ((unsigned char *) &d)[j];
				if (fwrite(buf, 8, 1, file) != 1)
				{
					line = __LINE__;
					goto writerr;
				}
			}
			break;
		case 0xC4:	/* date */
			{
				double d;
				unsigned char buf[8];
				int j;

				d = dp->u.d;
				for (j = 0; j < 8; ++j)
					buf[j] = ((unsigned char *) &d)[j];
				if (fwrite(buf, 8, 1, file) != 1)
				{
					line = __LINE__;
					goto writerr;
				}
			}
			break;
		}
	}

	  ret:
	fclose(file);

	return r;
}
int
clip___MCLEAR(ClipMachine * mp)
{
	return 0;
}

/* cName, ... */
int
clip___MXRELEASE(ClipMachine * mp)
{
	return 0;
}

/* cPattern, bLike */
int
clip___MRELEASE(ClipMachine * mp)
{
	return 0;
}

/* cFilename, bAdditive */
int
clip___MRESTORE(ClipMachine * mp)
{
	char *path = _clip_parc(mp, 1);
        /*
        int l_add  = _clip_parl(mp, 2);
        */

	/*int isAdditive = _clip_parl(mp, 1); */
	char buf[256], errbuf[256], p[256];
	int r, i;
	DbfData *vars = 0;
	char **names = 0;
	int nvars = 0;
	char *e, *s;

	strncpy(p,path,sizeof(p));
	s = strrchr(p, '/');
	e = strrchr(p, '\\');
	s = (s>e)?s:e;
	e = strrchr(p, '.');
	if (!e || (s && e < s))
		strcat(p, ".mem");
	_clip_path(mp, p, buf, sizeof(buf), 0);

	r = read_MemFile(buf, dbf_get_locale(mp),
			 &vars, &names, &nvars, errbuf, sizeof(errbuf));

	if (!r)
	{
		for (i = 0; i < nvars; i++)
		{
			ClipVar *vp;
			long hash = _clip_casehashstr(names[i]);

			vp = _clip_ref_public_noadd(mp, hash);
                        if (!vp)
				vp = _clip_ref_memvar(mp, hash);

			if (!vp)
				continue;
			_clip_destroy(mp, vp);
			dbf2clip(vars + i, vp);
		}
	}

	for (i = 0; i < nvars; i++)
	{
		destroy_DbfData(vars + i);
		free(names[i]);
	}

	free(names);
	free(vars);

	if (r)
	{
		_clip_trap_str(mp, mp->fp->filename, mp->fp->line, errbuf);
		return EG_ARG;
	}

	return 0;
}

/* cFilename, cPattern, bLike */
int
clip___MSAVE(ClipMachine * mp)
{
	char *path = _clip_parc(mp, 1);
	char *pattern = _clip_parc(mp, 2);
	int isLike = _clip_parl(mp, 3);
	char buf[256], errbuf[64];
	int r, i;
	DbfData *vars = 0;
	ClipFrame *fp;
	Coll snames;
	char *e, *s;

	if (!path || !pattern)
		return EG_ARG;

	init_Coll(&snames, 0, strcasecmp);

	for (fp = mp->fp; fp; fp = fp->up)
	{
		if (fp->names)
		{
			ClipHashBucket *bp;

			for (i = 0; i < fp->names->num; i++)
			{
				char *nm;
				int ind;

				bp = fp->names->buckets + i;
				nm = fp->names->mem + bp->offs;
				if (!search_Coll(&snames, nm, &ind))
				{
					int m = (_clip_glob_match(nm, pattern, 1) == -1 ? 0 : 1);

					if ((m && isLike) || (!m && !isLike))
						atInsert_Coll(&snames, nm, ind);
				}
			}
		}
	}

	for(r = HashTable_first(mp->hashnames); r; r = HashTable_next(mp->hashnames))
	{
		char *nm = (char*) HashTable_current(mp->hashnames);
		int ind;
		if (!search_Coll(&snames, nm, &ind))
		{
			int m = (_clip_glob_match(nm, pattern, 1) == -1 ? 0 : 1);
			if ((m && isLike) || (!m && !isLike))
				atInsert_Coll(&snames, nm, ind);
		}
	}

	vars = NEWVECT(DbfData, snames.count);

	for (i = 0; i < snames.count; i++)
	{
		long hash;
		ClipVar *vp;

		hash = _clip_casehashstr(snames.items[i]);

		vp = _clip_ref_memvar(mp, hash);
		clip2dbf(vp, vars + i);
	}

	_clip_path(mp, path, buf, sizeof(buf), 1);

	e = strrchr(buf, '.');
	s = strrchr(buf, '/');
	if (!e || (s && e < s))
		strncat(buf, ".mem", sizeof(buf));

	r = write_MemFile(buf, dbf_get_locale(mp),
			  vars, (char **) snames.items, snames.count, errbuf, sizeof(errbuf));

	for (i = 0; i < snames.count; i++)
		destroy_DbfData(vars + i);

	destroy_Coll(&snames);
	free(vars);

	if (r)
	{
		_clip_trap_str(mp, mp->fp->filename, mp->fp->line, errbuf);
		return EG_ARG;
	}

	return 0;
}
