/*
   $Log: mapbase.c,v $
   Revision 1.8  2001/10/29 06:51:21  clip
   fix text fopen modes
   paul

   Revision 1.7  2000/12/06 13:13:01  clip
   loadable charset tables. size 256
   paul

   Revision 1.6  2000/10/27 07:57:16  clip
   rational gluks
   paul

   Revision 1.5  2000/10/20 08:03:24  clip
   Вкрутил rational везде где упоминается NUMERIC_t
   может чего и осталось неотловленное, но это может быть только в тех
   местах где нет использования NUMERIC_t !!!!!
   from uri:

   Revision 1.4  2000/05/24 18:34:36  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.3  2000/03/09 21:50:26  paul
   warnigns

   Revision 1.2  1999/10/26 19:11:34  paul
   start cvs logging

 */

#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdarg.h>
#include <errno.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <ctype.h>
#include <stdlib.h>

#include "clipbase.h"
#include "mapfile/mapfile.h"
#include "mapfile/btree.h"
#include "mapfile/listfile.h"
#include "rational.h"

#define BASE_ID 0x40466775

#define INVALID_POS -1
#define BOF_POS -2
#define EOF_POS -3
#define KEYBUFSIZE 1024

#define DELETE_RECORD_FLAG 0x1
#define NEW(type) ((type*)calloc(sizeof(type),1))

typedef struct
{
	long fileId;
	long recCount;
	long recSize;
	long fileCount;
}
BaseHeader;

typedef struct
{
	char *name;
	int nfield;
	int recsize;
	struct MapFile *base;
	struct BtreeFile *btree;
	struct ListFile **subs;
	long pos;
	long fileCount;
	char *recbuf;
	char *buf;
	int buflen;
	char *keybuf;
	int keylen;
	int keysize;
	int valid:1;
	int dirty:1;
	int blank:1;
	DBIndex *index;
}
MapBase;

typedef struct
{
	int btno;
	long simple;
}
IndexData;

static int recCount(struct DBWorkArea *wa, ClipMachine * mp, long *val);
static int write_dirty(struct DBWorkArea *wa, ClipMachine * mp, MapBase * mbase);

static const char __file__[] = __FILE__;

static int
error(ClipMachine * mp, const char *funcname, int line, const char *fmt,...)
{
	char buf[256];
	int l;
	va_list ap;

	va_start(ap, fmt);
	snprintf(buf, sizeof(buf), "RDD: MAPBASE: %s: ", funcname);
	l = strlen(buf);
	vsnprintf(buf + l, sizeof(buf) - l, fmt, ap);
	_clip_trap_str(mp, __file__, line, buf);
	va_end(ap);
	return 1;
}

static int
base_error(ClipMachine * mp, struct MapFile *base, const char *funcname, int line)
{
	char buf[256];
	int l;

	snprintf(buf, sizeof(buf), "RDD: MAPBASE: %s: ", funcname);
	l = strlen(buf);
	getError_MapFile(base, buf + l, sizeof(buf) - l);
	_clip_trap_str(mp, __file__, line, buf);

	return 1;
}

static int
btree_error(ClipMachine * mp, struct BtreeFile *base, const char *funcname, int line)
{
	char buf[256];
	int l;

	snprintf(buf, sizeof(buf), "RDD: MAPBASE: %s: ", funcname);
	l = strlen(buf);
	getError_BtreeFile(base, buf + l, sizeof(buf) - l);
	_clip_trap_str(mp, __file__, line, buf);

	return 1;
}

static int
listfile_error(ClipMachine * mp, struct ListFile *base, const char *funcname, int line, int r)
{
	char buf[256];
	int l;

	snprintf(buf, sizeof(buf), "RDD: MAPBASE: %s: ", funcname);
	l = strlen(buf);
	getError_ListFile(base, buf + l, sizeof(buf) - l);
	_clip_trap_str(mp, __file__, line, buf);

	return r;
}

static void
make_path(char *name, char *path, int pathlen)
{
	if (name[0] == '/')
		snprintf(path, pathlen, "%s.dbf", name);
	else
	{
		int len;

		getcwd(path, pathlen);
		len = strlen(path);
		snprintf(path + len, pathlen - len, "/%s.dbf", name);
	}
}

static int
screate(ClipMachine * mp, char *name
	,int nfields, DBField * fields
	,int argc, ClipVar * argv)
{
	const char nm[] = "create";
	FILE *header;
	struct MapFile *base;
	struct BtreeFile *btree;
	char path[256], errbuf[128];
	int pathlen;
	int recsize;
	int pagesize;
	int i;

	make_path(name, path, sizeof(path));
	pathlen = strlen(path);

	if (mkdir(path, 0750))
		return error(mp, nm, __LINE__, "cannot create database dir '%s': %s", path, strerror(errno));

	/* header */
	snprintf(path + pathlen, sizeof(path) - pathlen, "/header");
	header = fopen(path, "wb");
	if (!header)
		return error(mp, nm, __LINE__, "cannot create header file '%s': %s", path, strerror(errno));

	for (i = 0, recsize = 1; i < nfields; ++i)
	{
		DBField *fp = fields + i;

		fp->offs = recsize;
		switch (fp->type)
		{
		case 'N':
			recsize += (fp->len + 1);
			continue;
		case 'C':
			recsize += fp->len;
			continue;
		case 'D':
			recsize += sizeof(long);

			continue;
		case 'L':
			recsize += 1;
			continue;
		case 'M':
		case 'O':
			recsize += sizeof(long);

			continue;
		case 'A':
			switch (fp->type1)
			{
			case 'C':
			case 'N':
			case 'D':
			case 'L':
				/*case 'M':
				   case 'O': */
				recsize += sizeof(long);

				continue;
			}
		default:
			return error(mp, nm, __LINE__, "invalid field %d type", i + 1);
		}
	}
	fprintf(header, "file \"%s\" nfield=%d recsize=%d\n", name, nfields, recsize);
	for (i = 0; i < nfields; ++i)
	{
		DBField *fp = fields + i;

		fprintf(header, "field no=%d name=%s type=%s", i, fp->name, fp->strtype);
		/*if (fp->type1)
		   fprintf(header, "%c", fp->type1); */
		fprintf(header, " offs=%d len=%d dec=%d\n", fp->offs, fp->len, fp->dec);
	}
	fclose(header);
	chmod(path, 0640);

	snprintf(path + pathlen, sizeof(path) - pathlen, "/base");
	base = create_MapFile(path, sizeof(BaseHeader), recsize, errbuf, sizeof(errbuf));
	if (!base)
		return error(mp, nm, __LINE__, "cannot create database file '%s': %s", path, errbuf);

	{
		BaseHeader *hp;

		if (lockHeader_MapFile(base, 1, (void **) &hp))
		{
			base_error(mp, base, nm, __LINE__);
			close_MapFile(base);
			return -1;
		}
		hp->recSize = recsize;
		hp->recCount = 0;
		hp->fileCount = 0;
		hp->fileId = BASE_ID;
		unlockHeader_MapFile(base);
		sync_MapFile(base);
	}

	close_MapFile(base);
	chmod(path, 0660);

	snprintf(path + pathlen, sizeof(path) - pathlen, "/btree");
	btree = create_BtreeFile(path, 0, 0, errbuf, sizeof(errbuf));
	if (!btree)
		return error(mp, nm, __LINE__, "cannot create index file '%s': %s", path, errbuf);

	close_BtreeFile(btree);

	for (i = 0; i < nfields; ++i)
	{
		DBField *fp = fields + i;
		struct ListFile *lf;

		switch (fp->type)
		{
		case 'M':
			snprintf(path + pathlen, sizeof(path) - pathlen, "/memo_%03d", i + 1);
			recsize = fp->len;
			pagesize = fp->len * 4;
			lf = create_ListFile(path, pagesize, recsize, errbuf, sizeof(errbuf));
			if (!lf)
				return error(mp, nm, __LINE__, "cannot create memo file '%s': %s", path, errbuf);
			close_ListFile(lf);
			chmod(path, 0660);
			break;
		case 'O':
			snprintf(path + pathlen, sizeof(path) - pathlen, "/obj_%03d", i + 1);
			recsize = fp->len;
			pagesize = fp->len * 4;
			lf = create_ListFile(path, pagesize, recsize, errbuf, sizeof(errbuf));
			if (!lf)
				return error(mp, nm, __LINE__, "cannot create obj file '%s': %s", path, errbuf);
			close_ListFile(lf);
			chmod(path, 0660);
			break;
		case 'A':
			snprintf(path + pathlen, sizeof(path) - pathlen, "/arr_%03d", i + 1);
			switch (fp->type1)
			{
			case 'N':
				recsize = (fp->len + 1);
				break;
			case 'C':
				recsize = fp->len;
				break;
			case 'D':
				recsize = sizeof(long);

				break;
			case 'L':
				recsize = 1;
				break;
			default:
				recsize = fp->len;
				break;
			}
			pagesize = fp->len * 4;
			lf = create_ListFile(path, pagesize, recsize, errbuf, sizeof(errbuf));
			if (!lf)
				return error(mp, nm, __LINE__, "cannot create array file '%s': %s", path, errbuf);
			close_ListFile(lf);
			chmod(path, 0660);
			break;
		}
	}

	return 0;
}

static void
split_string(char *str, int max_args, int *argc, char **argv)
{
	int i;
	char *s = str;

	*argc = 0;

	for (i = 0; i < max_args; ++i, ++s)
	{
		while (isspace(*s))
			++s;
		if (!*s)
			break;
		argv[*argc] = s;
		++(*argc);
		if (*s == '{')
		{
			int nbrack;

			for (nbrack = 1; nbrack && *s; ++s)
			{
				switch (*s)
				{
				case '{':
					nbrack++;
					break;
				case '}':
					nbrack--;
					break;
				}
			}
		}
		else
			while (!isspace(*s))
				++s;
		if (!*s)
			break;
		*s = 0;
	}
}

static char *
get_arg(int argc, char **argv, char *name)
{
	int i;
	char *s;
	int ln = strlen(name);

	for (i = 0; i < argc; ++i)
	{
		int l;

		s = argv[i];
		l = strlen(s);
		if (l < ln)
			continue;
		if (strncasecmp(name, s, ln))
			continue;
		s += ln;
		if (!*s)
			return s;
		if (*s == '=')
			return s + 1;
	}

	return 0;
}

static int
sopen(struct DBWorkArea *wa, ClipMachine * mp, char *name, int shared, int readonly
      ,int argc, ClipVar * argv)
{
	const char nm[] = "open";
	FILE *header;
	struct MapFile *base;
	struct BtreeFile *btree;
	char path[256], buf[256];
	int pathlen, nfield = 0, i;
	int nindex = 0;
	MapBase *mbase;
	long recsize = 0, rec_size = 0;

	make_path(name, path, sizeof(path));
	pathlen = strlen(path);
	snprintf(path + pathlen, sizeof(path) - pathlen, "/header");

	header = fopen(path, readonly ? "rb" : "r+b");
	if (!header)
	{
		return error(mp, nm, __LINE__, "cannot open base '%s': cannot open HEADER file '%s'", name, path);
	}

	while (fgets(buf, sizeof(buf), header) != NULL)
	{
		char *words[32], *s;
		int nword;

		split_string(buf, 32, &nword, words);
		if (nword < 1)
			continue;

		if (!strcasecmp(words[0], "file"))
		{
			if (nword < 4)
			      ferr:return error(mp, nm, __LINE__, "HEADER file '%s': invalid 'file' format", path);

			s = get_arg(nword - 2, words + 2, "nfield");
			if (!s)
				goto ferr;
			nfield = atoi(s);
			s = get_arg(nword - 2, words + 2, "recsize");
			if (!s)
				goto ferr;
			recsize = atoi(s);
		}
		else if (!strcasecmp(words[0], "field"))
		{
			DBField *fp;

			if (nword < 7)
			      fierr:return error(mp, nm, __LINE__, "HEADER file '%s'; invalid 'field' format", path);
			wa->nfield++;
			wa->fields = (DBField *) realloc(wa->fields, wa->nfield * sizeof(DBField));
			fp = wa->fields + (wa->nfield - 1);
			memset(fp, 0, sizeof(DBField));
			s = get_arg(nword - 1, words + 1, "name");
			if (!s)
				goto fierr;
			fp->no = wa->nfield - 1;
			fp->name = strdup(s);
			s = get_arg(nword - 1, words + 1, "type");
			if (!s)
				goto fierr;
			fp->type = *s;
			fp->strtype = strdup(s);
			if (fp->type == 'A')
				fp->type1 = s[1];
			s = get_arg(nword - 1, words + 1, "offs");
			if (!s)
				goto fierr;
			fp->offs = atoi(s);
			s = get_arg(nword - 1, words + 1, "len");
			if (!s)
				goto fierr;
			fp->len = atoi(s);
			s = get_arg(nword - 1, words + 1, "dec");
			if (!s)
				goto fierr;
			fp->dec = atoi(s);
		}
		else if (!strcasecmp(words[0], "index"))
		{
			DBIndex *ip;
			IndexData *idp;

			if (nword < 4)
			      ixerr:return error(mp, nm, __LINE__, "HEADER file '%s'; invalid 'index' format", path);
			wa->nindex++;
			wa->indexes = (DBIndex **) realloc(wa->indexes, wa->nindex * sizeof(DBIndex *));
			ip = wa->indexes[wa->nindex - 1] = NEW(DBIndex);
			ip->data = idp = NEW(IndexData);
			s = get_arg(nword - 1, words + 1, "name");
			if (!s)
				goto ixerr;
			ip->no = wa->nindex - 1;
			ip->name = strdup(s);
			s = get_arg(nword - 1, words + 1, "btno");
			if (!s)
				goto ixerr;
			idp->btno = atoi(s);
			s = get_arg(nword - 1, words + 1, "unique");
			if (!s)
				goto ixerr;
			ip->unique = atoi(s);
			s = get_arg(nword - 1, words + 1, "expr");
			if (!s)
				goto ixerr;
			ip->expr = _clip_memdup(s + 1, strlen(s + 1) - 1);
			idp->simple = 1;
			for (s = ip->expr; *s; ++s)
				if (!isalnum(*s) && *s != '_')
					idp->simple = 0;
			if (idp->simple)
				idp->simple = _clip_casehashstr(ip->expr);
			else
			{
				ClipBlock *block = NEW(ClipBlock);

				if (_clip_compile_Block(mp, ip->expr, strlen(ip->expr), block))
					goto ixerr;
				ip->bexpr.t.type = PCODE_t;
				ip->bexpr.t.flags = F_NONE;
				ip->bexpr.c.u.block = block;
			}
		}
	}
	fclose(header);
	/* some checks */
	if (nfield != wa->nfield)
		return error(mp, nm, __LINE__, "HEADER file '%s': invalid nfield", path);
	for (i = 0, rec_size = 1; i < wa->nfield; ++i)
	{
		DBField *fp = wa->fields + i;

		if (fp->offs != rec_size)
			return error(mp, nm, __LINE__, "HEADER file '%s': invalid fields description", path);
		switch (fp->type)
		{
		case 'N':
			rec_size += fp->len + 1;
			continue;
		case 'C':
			rec_size += fp->len;
			continue;
		case 'D':
			rec_size += sizeof(long);

			continue;
		case 'L':
			rec_size += 1;
			continue;
		case 'M':
		case 'O':
			rec_size += sizeof(long);

			continue;
		case 'A':
			switch (fp->type1)
			{
			case 'C':
			case 'N':
			case 'D':
			case 'L':
			case 'M':
			case 'O':
				rec_size += sizeof(long);

				continue;
			}
		default:
			return error(mp, nm, __LINE__, "invalid field %d type", i + 1);
		}

		rec_size += fp->len;
	}
	if (rec_size != recsize)
		return error(mp, nm, __LINE__, "HEADER file '%s': invalid recsize", path);

	snprintf(path + pathlen, sizeof(path) - pathlen, "/base");
	base = open_MapFile(path, sizeof(BaseHeader), !readonly, buf, sizeof(buf));
	if (!base)
		return error(mp, nm, __LINE__, "cannot open BASE file '%s': %s", path, buf);

	wa->data = mbase = calloc(1, sizeof(MapBase));
	{
		BaseHeader *hp;

		if (lockHeader_MapFile(base, 1, (void **) &hp))
		{
			base_error(mp, base, nm, __LINE__);
			close_MapFile(base);
			return -1;
		}
		recsize = hp->recSize;
		if (hp->fileId != BASE_ID)
		{
			error(mp, nm, __LINE__, "'%s': invalid base file id", path);
			close_MapFile(base);
			return -1;
		}
		mbase->fileCount = hp->fileCount;

		setRecSize_MapFile(base, recsize);
		unlockHeader_MapFile(base);
	}

	mbase->base = base;
	mbase->name = strdup(name);
	mbase->nfield = wa->nfield;
	mbase->recsize = recsize;
	mbase->subs = (struct ListFile **) calloc(mbase->nfield, sizeof(struct ListFile *));

	mbase->recbuf = (char *) malloc(recsize + 1);
	mbase->buf = (char *) malloc(recsize + 1);

	if (mbase->recsize != recsize)
		return error(mp, nm, __LINE__, "invalid recsize in BASE file '%s': %d", path, mbase->recsize);

	snprintf(path + pathlen, sizeof(path) - pathlen, "/btree");
	btree = open_BtreeFile(path, 0, !readonly, buf, sizeof(buf));
	if (!btree)
		return error(mp, nm, __LINE__, "cannot open BTREE file '%s': %s", path, buf);

	mbase->btree = btree;
	mbase->keysize = pageSize_BtreeFile(btree);
	mbase->keylen = 0;
	mbase->keybuf = (char *) malloc(mbase->keysize);

	for (i = 0; i < wa->nfield; ++i)
	{
		DBField *fp = wa->fields + i;
		struct ListFile *bp;

		switch (fp->type)
		{
		case 'M':
			snprintf(path + pathlen, sizeof(path) - pathlen, "/memo_%03d", i + 1);
			bp = open_ListFile(path, !readonly, buf, sizeof(buf));
			if (!bp)
				return error(mp, nm, __LINE__, "cannot open memo file '%s': %s", path, buf);
			mbase->subs[i] = bp;
			break;
		case 'A':
			snprintf(path + pathlen, sizeof(path) - pathlen, "/arr_%03d", i + 1);
			bp = open_ListFile(path, !readonly, buf, sizeof(buf));
			if (!bp)
				return error(mp, nm, __LINE__, "cannot open array file '%s': %s", path, buf);
			mbase->subs[i] = bp;
			break;
		case 'O':
			snprintf(path + pathlen, sizeof(path) - pathlen, "/obj_%03d", i + 1);
			bp = open_ListFile(path, !readonly, buf, sizeof(buf));
			if (!bp)
				return error(mp, nm, __LINE__, "cannot open object file '%s': %s", path, buf);
			mbase->subs[i] = bp;
			break;
		}
	}
	mbase->pos = BOF_POS;
	mbase->valid = 0;

	return 0;
}

static int
sclose(struct DBWorkArea *wa, ClipMachine * mp)
{
	int i, r = 0;
	const char nm[] = "close";

	MapBase *mbase = (MapBase *) wa->data;

	write_dirty(wa, mp, mbase);

	for (i = 0; i < mbase->nfield; ++i)
	{
		DBField *fp = wa->fields + i;

		switch (fp->type)
		{
		case 'M':
		case 'O':
		case 'A':
			if (close_ListFile(mbase->subs[i]))
				++r;
			break;
		}
	}

	if (close_BtreeFile(mbase->btree))
		++r;
	if (close_MapFile(mbase->base))
		++r;

	free(mbase->subs);
	free(mbase->name);
	free(mbase->recbuf);
	free(mbase->buf);
	free(mbase->keybuf);
	free(mbase);

	wa->data = 0;
	if (r)
		return error(mp, nm, __LINE__, "error in closing base '%s'", mbase->name);
	return r;
}

static int
s_remove(ClipMachine * mp, char *name)
{
	const char nm[] = "remove";
	struct stat st;

	if (stat(name, &st))
	{
		if (errno == ENOENT)
		{
/*_clip_retl(mp,0);*/
			return 0;
		}
		return error(mp, nm, __LINE__, "cannot stat file '%s': %s", name, strerror(errno));
	}

	if (S_ISDIR(st.st_mode))
	{
		DIR *dir;
		struct dirent *dp;
		char path[256];

		dir = opendir(name);
		if (!dir)
			return error(mp, nm, __LINE__, "cannot open directory '%s': %s", name, strerror(errno));
		while ((dp = readdir(dir)))
		{
			if (!strcmp(dp->d_name, ".") || !strcmp(dp->d_name, ".."))
				continue;
			snprintf(path, sizeof(path), "%s/%s", name, dp->d_name);
			if (s_remove(mp, path))
			{
				closedir(dir);
				return 1;
			}
		}

		closedir(dir);
		if (rmdir(name))
			return error(mp, nm, __LINE__, "cannot remove directory '%s': %s", name, strerror(errno));
	}
	else
	{
		if (unlink(name))
			return error(mp, nm, __LINE__, "cannot remove file '%s': %s", name, strerror(errno));
	}
	return 0;
}

static int
sremove(ClipMachine * mp, char *name)
{
	char path[256];

/*_clip_retl(mp,1);*/
	make_path(name, path, sizeof(path));
	return s_remove(mp, path);
}

static int
saccess(ClipMachine * mp, char *name, char *cmode)
{
	char path[256], *s;
	int l, dmode, fmode, r = 1;

	make_path(name, path, sizeof(path));
	l = strlen(path);

	for (dmode = 0, fmode = 0, s = cmode; *s; ++s)
		switch (*s)
		{
		case 'r':
			dmode |= R_OK;
			fmode |= R_OK;
			break;
		case 'w':
			dmode |= R_OK;
			fmode |= W_OK;
			break;
		case 'e':
			dmode |= F_OK;
			fmode |= F_OK;
			break;
		case 'a':
			dmode |= R_OK;
			fmode |= R_OK;
			fmode |= W_OK;
			break;
		case 'd':
			dmode |= R_OK;
			fmode |= R_OK;
			fmode |= W_OK;
			break;
		case 's':
			dmode |= R_OK;
			dmode |= W_OK;
			fmode |= R_OK;
			fmode |= W_OK;
			break;
		}

	if (access(path, dmode))
	{
		r = 0;
		goto ret;
	}
	snprintf(path + l, sizeof(path) - l, "/header");
	if (access(path, fmode))
	{
		r = 0;
		goto ret;
	}
      ret:
	_clip_retl(mp, r);
	return 0;
}

static int
srename(ClipMachine * mp, char *name, char *newname)
{
	char path[256];
	char npath[256];

	make_path(name, path, sizeof(path));
	make_path(newname, npath, sizeof(npath));

	if (rename(path, npath))
		_clip_retl(mp, 0);
	else
		_clip_retl(mp, 1);

	return 0;
}

static void
translate(unsigned char *str, int len)
{
	while (len)
	{
		int s = *str;

		*str = _clip_cmptbl[s];
		--len;
		++str;
	}
}

static int
put_key(ClipMachine * mp, MapBase * mbase, ClipVar * vp)
{
	if (vp->t.flags == F_MPTR)
		vp = vp->p.vp;

	switch (vp->t.type)
	{
	case CHARACTER_t:
		{
			int l;

			l = vp->s.str.len;
			if (l >= mbase->keysize)
				l = mbase->keysize - 1;
			memcpy(mbase->keybuf, vp->s.str.buf, l);
			translate(mbase->keybuf, l);
			mbase->keybuf[l] = 0;
			mbase->keylen = l;
			return 0;
		}
		break;
	case NUMERIC_t:
		{
			int len = vp->t.len;
			int dec = vp->t.dec;
			double tmp;

			if (!len)
			{
				len = 18;
				dec = 18;
			}
			tmp = _clip_double(vp);
			snprintf(mbase->keybuf, mbase->keysize, "%+*.*f", len + 1, dec, tmp);
			mbase->keylen = strlen(mbase->keybuf);
			return 0;
		}
		break;
	case DATE_t:
		{
			*(long *) (mbase->keybuf) = vp->d.julian;
			mbase->keylen = sizeof(vp->d.julian);
			return 0;
		}
		break;
	case OBJECT_t:
		{
			*mbase->keybuf = 0;
			vp->o.rtti->print(mp, vp->o.obj, vp->o.rtti, &mbase->keybuf, &mbase->keysize);
			mbase->keylen = strlen(mbase->keybuf);
			translate(mbase->keybuf, mbase->keylen);
			return 0;
		}
		break;
	default:
	}
	return 1;
}

static int
addel_index(ClipMachine * mp, MapBase * mbase, DBIndex * index, int del)
{
	int r = 0, ok;
	const char nm[] = "addel_index";
	ClipBlock block;
	ClipVar stack[1], *vp = stack;
	ClipFrame frame =
	{stack, stack + 1, __file__, __LINE__, 0, 0, 0};
	IndexData *idp = (IndexData *) index->data;
	long recno = mbase->pos;

	frame.up = mp->fp;
	mp->fp = &frame;
	stack[0].t.type = UNDEF_t;
	stack[0].t.flags = F_NONE;

	if (idp->simple)
	{
		--(frame.sp);
		r = _clip_fmemvar(mp, idp->simple);
	}
	else
	{
		if (index->bexpr.t.type == PCODE_t)
			r = _clip_code_func(mp, index->bexpr.c.u.block, 0, 0, 0);
		else if (index->bexpr.t.type == CCODE_t)
			r = _clip_func(mp, index->bexpr.c.u.func, 0, 0, 0);
	}
	mp->fp = frame.up;

	if (r)
		goto ret;

	if ((r = put_key(mp, mbase, vp)))
	{
		r = error(mp, nm, __LINE__, "cannot convert index expression value into string (index='%s', recno=%d)", index->name, recno);
		goto ret;
	}

	if (del)
		r = delKey_BtreeFile(mbase->btree, idp->btno, mbase->keybuf, mbase->keylen, recno, &ok);
	else
		r = addKey_BtreeFile(mbase->btree, idp->btno, mbase->keybuf, mbase->keylen, recno, &ok);
	if (r)
	{
		btree_error(mp, mbase->btree, nm, __LINE__);
		goto ret;
	}

	if (!ok)
	{
		r = error(mp, nm, __LINE__, "invalid (duplicated?) expression value (index='%s', recno=%d)", index->name, recno);
		goto ret;
	}

      ret:
	_clip_destroy(mp, stack);
	return r;
}

static int
updateIndexes(struct DBWorkArea *wa, ClipMachine * mp, MapBase * mbase)
{
	int i, r = 0;

	for (i = 0; i < wa->nindex; ++i)
	{
		DBIndex *ip = wa->indexes[i];

		if (!ip)
			continue;
		if (!mbase->blank)
			if ((r = addel_index(mp, mbase, ip, 1)))
				break;
		if ((r = addel_index(mp, mbase, ip, 0)))
			break;
	}

	return r;
}

static int
createIndex(struct DBWorkArea *wa, ClipMachine * mp, DBIndex * index)
{
	char path[256], *s;
	int pathlen, r = 0, btno;
	FILE *header;
	const char nm[] = "createIndex";
	MapBase *mbase = (MapBase *) wa->data;
	long last, recno, pos, simple = 1;
	IndexData *idp = NEW(IndexData);

	for (s = index->expr; *s; ++s)
		if (!isalnum(*s) && *s != '_')
		{
			simple = 0;
			break;
		}

	if (simple)
		simple = _clip_casehashstr(index->expr);

	index->data = idp;
	idp->simple = simple;

	make_path(wa->name, path, sizeof(path));
	pathlen = strlen(path);

	snprintf(path + pathlen, sizeof(path) - pathlen, "/header");
	header = fopen(path, "a+b");
	if (!header)
		return error(mp, nm, __LINE__, "cannot open header file '%s'", path);

	if ((r = addTree_BtreeFile(mbase->btree, index->unique, &btno)))
	{
		btree_error(mp, mbase->btree, nm, __LINE__);
		goto ret;
	}

	idp->btno = btno;
	/* add all records into btno tree */
	pos = mbase->pos;
	recCount(wa, mp, &last);

	for (recno = 0, r = 0; !r && recno < last; ++recno)
	{
		mbase->pos = recno;
		mbase->valid = 0;
		r = addel_index(mp, mbase, index, 0);
	}

	mbase->pos = pos;

	if (!r)
	{
		/* update header info */
		fprintf(header, "index name=%s btno=%d unique=%d expr={%s}\n", index->name, btno, index->unique, index->expr);
		mbase->index = index;
	}
      ret:
	fclose(header);
	return r;
}

static int
openIndex(struct DBWorkArea *wa, ClipMachine * mp, DBIndex * index)
{
	MapBase *mbase = (MapBase *) wa->data;

	mbase->index = index;
	return 0;
}

static int
closeIndex(struct DBWorkArea *wa, ClipMachine * mp, DBIndex * index)
{
	MapBase *mbase = (MapBase *) wa->data;
	IndexData *idp = (IndexData *) index->data;

	if (mbase->index == index)
		mbase->index = 0;
	return 0;
}

static int
setIndex(struct DBWorkArea *wa, ClipMachine * mp, DBIndex * index)
{
	MapBase *mbase = (MapBase *) wa->data;

	mbase->index = index;
	return 0;
}

static int
seek(struct DBWorkArea *wa, ClipMachine * mp, ClipVar * vp, int softseek, int *found)
{
	int r;
	MapBase *mbase = (MapBase *) wa->data;
	const char nm[] = "seek";
	IndexData *idp;
	long recno;

	if (!mbase->index)
		return error(mp, nm, __LINE__, "no active index");

	if ((r = write_dirty(wa, mp, mbase)))
		return r;

	idp = (IndexData *) mbase->index->data;
	r = put_key(mp, mbase, vp);
	if (r)
		return error(mp, nm, __LINE__, "cannot convert seek expression into string form");

	r = seekKey_BtreeFile(mbase->btree, idp->btno, mbase->keybuf, &mbase->keylen, mbase->keysize, &recno, found);
	if (!r)
	{
		mbase->pos = recno;
		mbase->valid = 0;
	}

	return r;
}

static int
skip_index(struct DBWorkArea *wa, ClipMachine * mp, MapBase * mbase, long nskip)
{
	DBIndex *ip = mbase->index;
	IndexData *idp = (IndexData *) ip->data;
	long recno = mbase->pos;
	int r = 0, i, found;
	const char nm[] = "skip_index";

	if (nskip > 0)
	{
		for (i = 0; !r && i < nskip; ++i)
			r = nextKey_BtreeFile(mbase->btree, idp->btno, mbase->keybuf, &mbase->keylen, mbase->keysize, &recno, &found);
	}
	else if (nskip < 0)
	{
		for (i = 0; !r && nskip < i; --i)
			r = prevKey_BtreeFile(mbase->btree, idp->btno, mbase->keybuf, &mbase->keylen, mbase->keysize, &recno, &found);
	}
	else
	{
		mbase->valid = 0;
		return 0;
	}

	if (r)
		btree_error(mp, mbase->btree, nm, __LINE__);
	{
		mbase->pos = recno;
		mbase->valid = 0;
	}
	return r;
}

static int
first_index(struct DBWorkArea *wa, ClipMachine * mp, MapBase * mbase)
{
	DBIndex *ip = mbase->index;
	IndexData *idp = (IndexData *) ip->data;
	long recno;
	int r;
	const char nm[] = "first_index";

	r = firstKey_BtreeFile(mbase->btree, idp->btno, mbase->keybuf, &mbase->keylen, mbase->keysize, &recno);
	if (r)
		btree_error(mp, mbase->btree, nm, __LINE__);
	{
		mbase->pos = recno;
		mbase->valid = 0;
	}
	return r;
}

static int
last_index(struct DBWorkArea *wa, ClipMachine * mp, MapBase * mbase)
{
	DBIndex *ip = mbase->index;
	IndexData *idp = (IndexData *) ip->data;
	long recno;
	int r;
	const char nm[] = "last_index";

	r = lastKey_BtreeFile(mbase->btree, idp->btno, mbase->keybuf, &mbase->keylen, mbase->keysize, &recno);
	if (r)
		btree_error(mp, mbase->btree, nm, __LINE__);
	{
		mbase->pos = recno;
		mbase->valid = 0;
	}
	return r;
}

/* file */
static int
reindex(struct DBWorkArea *wa, ClipMachine * mp)
{
	MapBase *mbase = (MapBase *) wa->data;
	int i, r = 0, pathlen;
	char path[256], errbuf[256];
	const char nm[] = "reindex";
	long pos, recno, last;
	void *hp;

	if (lockHeader_MapFile(mbase->base, 0, &hp))
		return base_error(mp, mbase->base, nm, __LINE__);

	make_path(wa->name, path, sizeof(path));
	pathlen = strlen(path);

	r = close_BtreeFile(mbase->btree);
	if (r)
		return btree_error(mp, mbase->btree, nm, __LINE__);

	snprintf(path + pathlen, sizeof(path) - pathlen, "/btree");

	mbase->btree = create_BtreeFile(path, 0, 0, errbuf, sizeof(errbuf));
	if (!mbase->btree)
		return error(mp, nm, __LINE__, "cannot create index file '%s': %s", path, errbuf);

	pos = mbase->pos;
	recCount(wa, mp, &last);
	for (i = 0, r = 0; !r && i < wa->nindex; ++i)
	{
		DBIndex *ip = wa->indexes[i];
		IndexData *idp = (IndexData *) ip->data;

		if ((r = addTree_BtreeFile(mbase->btree, ip->unique, &idp->btno)))
		{
			btree_error(mp, mbase->btree, nm, __LINE__);
			return -1;
		}
	}

	for (recno = 0; !r && recno < last; ++recno)
	{
		mbase->pos = recno;
		mbase->valid = 0;
		for (i = 0, r = 0; !r && i < wa->nindex; ++i)
		{
			DBIndex *ip = wa->indexes[i];

			r = addel_index(mp, mbase, ip, 0);
		}
	}

	mbase->pos = pos;
	mbase->valid = 0;

	if (unlockHeader_MapFile(mbase->base))
	{
		base_error(mp, mbase->base, nm, __LINE__);
		return -1;
	}

	return r;
}

static int
zap(struct DBWorkArea *wa, ClipMachine * mp)
{
}

static int
pack(struct DBWorkArea *wa, ClipMachine * mp)
{
}

static int
write_dirty(struct DBWorkArea *wa, ClipMachine * mp, MapBase * mbase)
{
	long recno;
	int r;
	char *bp;
	const char nm[] = "write_dirty";

	if (!mbase->dirty)
		return 0;

	if (mbase->blank)
	{
		BaseHeader *hp;
		long count, file;

		lockHeader_MapFile(mbase->base, 1, (void **) &hp);
		count = hp->recCount;
		file = hp->fileCount;
		if (count >= file)
		{
			long delta = file / 4;

			if (delta < 1)
				delta = 1;
			if (incr_MapFile(mbase->base, &recno, delta, 0))
				return base_error(mp, mbase->base, nm, __LINE__);
			hp = (BaseHeader *) getHeader_MapFile(mbase->base);
			hp->fileCount += delta;
			mbase->fileCount = hp->fileCount;
		}

		recno = count;
		hp->recCount++;
		unlockHeader_MapFile(mbase->base);
		if (lockRec_MapFile(mbase->base, 1, recno, &bp))
			return base_error(mp, mbase->base, nm, __LINE__);
		mbase->pos = recno;
	}
	else
	{
		recno = mbase->pos;
		if (lockRec_MapFile(mbase->base, 1, recno, &bp))
			return base_error(mp, mbase->base, nm, __LINE__);
	}

	memcpy(bp, mbase->recbuf, mbase->recsize);

	r = updateIndexes(wa, mp, mbase);

	if (unlockRec_MapFile(mbase->base, recno))
		return base_error(mp, mbase->base, nm, __LINE__);

	mbase->dirty = 0;
	mbase->blank = 0;
	mbase->valid = 0;
	return r;
}

/* records */
static int
append(struct DBWorkArea *wa, ClipMachine * mp)
{
	const char nm[] = "append";
	MapBase *mbase = (MapBase *) wa->data;
	int i, nfield = wa->nfield, r;

	if ((r = write_dirty(wa, mp, mbase)))
		return r;

	memset(mbase->recbuf + 1, ' ', mbase->recsize - 1);
	for (i = 0; i < nfield; ++i)
	{
		DBField *fp = wa->fields + i;
		char *bp = mbase->recbuf + fp->offs;

		switch (fp->type)
		{
		case 'M':
		case 'O':
		case 'A':
			*(long *) bp = -1;
			break;
		case 'L':
			*bp = 0;
			break;
		case 'D':
			*(long *) bp = 0;
		}
	}
	*mbase->recbuf = 0;

	mbase->dirty = 1;
	mbase->blank = 1;
	mbase->valid = 1;
	return 0;
}

static int
recflag(struct DBWorkArea *wa, ClipMachine * mp, const char *nm, int flag, int set)
{
	long recno, last;
	int r;
	char *bp;
	void *hp;
	MapBase *mbase = (MapBase *) wa->data;

	if (wa->readonly)
		return error(mp, nm, __LINE__, "write operation on read-only base '%s'", wa->alias);

	recno = mbase->pos;

	if (lockHeader_MapFile(mbase->base, 0, &hp))
		return base_error(mp, mbase->base, nm, __LINE__);

	recCount(wa, mp, &last);

	if (recno < 0 || recno >= last)
		return error(mp, nm, __LINE__, "invalid postion: %ld", recno);

	if (lockRec_MapFile(mbase->base, 1, recno, &bp))
		return base_error(mp, mbase->base, nm, __LINE__);

	if (set)
		*bp |= flag;
	else
		*bp &= ~flag;

	if (unlockRec_MapFile(mbase->base, recno))
		return base_error(mp, mbase->base, nm, __LINE__);

	if (unlockHeader_MapFile(mbase->base))
		return base_error(mp, mbase->base, nm, __LINE__);

	return 0;
}

static int
readflag(struct DBWorkArea *wa, ClipMachine * mp, const char *nm, int flag, int *val)
{
	long recno, last;
	int r;
	char *bp;
	void *hp;
	MapBase *mbase = (MapBase *) wa->data;

	recno = mbase->pos;

	if (lockHeader_MapFile(mbase->base, 0, &hp))
		return base_error(mp, mbase->base, nm, __LINE__);

	recCount(wa, mp, &last);

	if (recno < 0 || recno >= last)
		return error(mp, nm, __LINE__, "invalid postion: %ld", recno);

	if (lockRec_MapFile(mbase->base, 0, recno, &bp))
		return base_error(mp, mbase->base, nm, __LINE__);

	*val = (*bp & flag);

	if (unlockRec_MapFile(mbase->base, recno))
		return base_error(mp, mbase->base, nm, __LINE__);

	if (unlockHeader_MapFile(mbase->base))
		return base_error(mp, mbase->base, nm, __LINE__);

	return 0;
}

static int
delete(struct DBWorkArea *wa, ClipMachine * mp)
{
	const char nm[] = "delete";

	return recflag(wa, mp, nm, DELETE_RECORD_FLAG, 1);
}

static int
recall(struct DBWorkArea *wa, ClipMachine * mp)
{
	const char nm[] = "recall";

	return recflag(wa, mp, nm, DELETE_RECORD_FLAG, 0);
}

static int
flush(struct DBWorkArea *wa, ClipMachine * mp)
{
	MapBase *mbase = (MapBase *) wa->data;
	int r;

	if ((r = write_dirty(wa, mp, mbase)))
		return r;
	return 0;
}

static int
make_valid(struct DBWorkArea *wa, ClipMachine * mp)
{
	MapBase *mbase = (MapBase *) wa->data;
	const char nm[] = "make_valid";
	long recno, last;
	char *bp;
	void *hp;

	recno = mbase->pos;

	if (mbase->blank || mbase->valid)
		return 0;

	if (lockHeader_MapFile(mbase->base, 0, &hp))
		return base_error(mp, mbase->base, nm, __LINE__);

	recCount(wa, mp, &last);

	if (recno < 0 || recno >= last)
		return error(mp, nm, __LINE__, "invalid postion: %ld", recno);

	if (lockRec_MapFile(mbase->base, 0, recno, &bp))
		return base_error(mp, mbase->base, nm, __LINE__);

	memcpy(mbase->recbuf, bp, mbase->recsize);

	if (unlockRec_MapFile(mbase->base, recno))
		return base_error(mp, mbase->base, nm, __LINE__);

	if (unlockHeader_MapFile(mbase->base))
		return base_error(mp, mbase->base, nm, __LINE__);

	mbase->valid = 1;

	return 0;
}

static int
get_field(struct DBWorkArea *wa, ClipMachine * mp, MapBase * mbase, int no, ClipVar * vp)
{
	DBField *fp = wa->fields + no;
	char *bp = mbase->recbuf + fp->offs;
	char *buf;
	int len = fp->len;
	const char nm[] = "get_field";

	vp->t.flags = F_NONE;
	switch (fp->type)
	{
	case 'C':
		vp->t.type = CHARACTER_t;
		buf = vp->s.str.buf = (char *) _clip_memdup(bp, len);
		vp->s.str.len = len;
		if (strchr(buf, '&'))
			vp->t.MACRO = 1;
		else
			vp->t.MACRO = 0;
		break;
	case 'N':
		vp->t.type = NUMERIC_t;
		vp->t.len = fp->len;
		vp->t.dec = fp->dec;
		vp->t.memo = 0;
		buf = mbase->buf;
		memcpy(buf, bp, len + 1);
		buf[len + 1] = 0;
		vp->n.d = strtod(buf, 0);
		break;
	case 'L':
		vp->t.type = LOGICAL_t;
		vp->l.val = *bp;
		break;
	case 'D':
		vp->t.type = DATE_t;
		vp->d.julian = *(long *) bp;
		break;
	case 'M':
		{
			long recno = *(long *) bp;

			vp->t.type = CHARACTER_t;
			if (recno < 0)
			{
				vp->s.str.buf = "";
				vp->s.str.len = 0;
				vp->t.flags = F_MSTAT;
			}
			else
			{
				char **vect = 0, *s;
				int r, num, i, rs = fp->len, l, vl;
				long len;
				struct ListFile *lf = mbase->subs[no];

				if ((r = get_ListFile(lf, recno, &vect, &num)))
					return listfile_error(mp, lf, nm, __LINE__, r);

				vp->s.str.len = len = *(long *) vect[0];
				vp->s.str.buf = buf = (char *) malloc(len + 1);
				buf[len] = 0;
				for (i = 0, l = 0; i < num; ++i)
				{
					if (!i)
					{
						s = vect[0] + sizeof(long);
						vl = rs - sizeof(long);
					}
					else
					{
						s = vect[i];
						vl = rs;
					}
					if (l + vl > len)
						vl = len - l;
					memcpy(buf, s, vl);
					buf += vl;
					l += vl;
				}
				free(vect);
			}
		}
		break;
	case 'O':
		{
			int rs = fp->len;
			long recno = *(long *) bp;
			struct ListFile *lf = mbase->subs[no];

			if (recno >= 0)
			{
				ClipObjRtti *rtti;
				void *obj;
				char **vect = 0;
				int num = 0, r;

				if (!_clip_find_obj(mp, fp->otype, &rtti))
					return error(mp, nm, __LINE__, "cannot find object '%x' rtti for field '%s'", fp->otype, fp->name);

				if ((r = get_ListFile(lf, recno, &vect, &num)))
					return listfile_error(mp, lf, nm, __LINE__, r);

				if (rtti->load(mp, (void **) &obj, rtti, rs, vect, num))
					return error(mp, nm, __LINE__, "cannot correct load object");
				free(vect);
				vp->t.type = OBJECT_t;
				vp->o.obj = obj;
				vp->o.rtti = rtti;
			}
			else
			{
				vp->t.type = UNDEF_t;
			}
		}
		break;
	case 'A':
		{
			int r, i;
			long recno = *(long *) bp, head;
			struct ListFile *lf = mbase->subs[no];
			ClipVar *ap;

			ap = NEW(ClipVar);
			vp->t.type = ARRAY_t;
			vp->t.flags = F_MPTR;
			vp->p.vp = ap;
			ap->t.type = ARRAY_t;
			ap->t.flags = F_NONE;
			ap->t.count = 1;
			ap->a.items = (ClipVar *) 0;
			ap->a.count = 0;

			for (i = 0, head = recno; head >= 0; ++i)
			{
				ClipVar *vvp;

				if ((r = getNext_ListFile(lf, &head, &bp)))
					return listfile_error(mp, lf, nm, __LINE__, r);

				if (head < 0)
					break;

				ap->a.items = (ClipVar *) realloc(ap->a.items, sizeof(ClipVar) * (i + 1));
				ap->a.count = i + 1;
				/*ap->a.items[i].no=i; */
				vvp = ap->a.items + i;
				vvp->t.flags = F_NONE;

				switch (fp->type1)
				{
				case 'C':
					vvp->t.type = CHARACTER_t;
					buf = vvp->s.str.buf = (char *) _clip_memdup(bp, len);
					vvp->s.str.len = len;
					if (strchr(buf, '&'))
						vvp->t.MACRO = 1;
					else
						vvp->t.MACRO = 0;
					break;
				case 'N':
					vvp->t.type = NUMERIC_t;
					vvp->t.len = fp->len;
					vvp->t.dec = fp->dec;
					vp->t.memo = 0;
					buf = mbase->buf;
					memcpy(buf, bp, len + 1);
					buf[len + 1] = 0;
					vvp->n.d = strtod(buf, 0);
					break;
				case 'L':
					vvp->t.type = LOGICAL_t;
					vvp->l.val = *bp;
					break;
				case 'D':
					vvp->t.type = DATE_t;
					vvp->d.julian = *(long *) bp;
					break;
				case 'M':
					vvp->t.type = UNDEF_t;
					break;
				case 'O':
					vvp->t.type = UNDEF_t;
					break;
				}
			}
		}
		break;
	}
	return 0;
}

static int
set_field(struct DBWorkArea *wa, ClipMachine * mp, MapBase * mbase, int no, ClipVar * vp)
{
	DBField *fp = wa->fields + no;
	char *bp = mbase->recbuf + fp->offs;
	char *buf;
	const char nm[] = "set_field";
	int len = fp->len;
	int l;

	if (vp->t.flags == F_MPTR)
		vp = vp->p.vp;
	switch (fp->type)
	{
	case 'C':
		if (vp->t.type != CHARACTER_t)
			return error(mp, nm, __LINE__, "assignment to CHARACTER_t field '%s' from non-character var", fp->name);
		l = vp->s.str.len;
		if (l > len)
			l = len;
		else
			memset(bp + l, ' ', len - l);
		memcpy(bp, vp->s.str.buf, l);
		break;
	case 'N':
		double tmp;
		if (vp->t.type != NUMERIC_t)
			return error(mp, nm, __LINE__, "assignment to NUMERIC_t field '%s' from non-numeric var", fp->name);
		buf = mbase->buf;
		tmp = _clip_double(vp);
		snprintf(buf, mbase->recsize, "%+*.*f", len + 1, fp->dec, tmp);
		memcpy(bp, buf, len + 1);
		break;
	case 'L':
		if (vp->t.type != LOGICAL_t)
			return error(mp, nm, __LINE__, "assignment to LOGICAL_t field '%s' from non-logical var", fp->name);
		*bp = vp->l.val;
		break;
	case 'D':
		if (vp->t.type != DATE_t)
			return error(mp, nm, __LINE__, "assignment to DATE_t field '%s' from non-date var", fp->name);
		*(long *) bp = vp->d.julian;
		break;
	case 'M':
		if (vp->t.type != CHARACTER_t)
			return error(mp, nm, __LINE__, "assignment to MEMO field '%s' from non-character var", fp->name);
		l = vp->s.str.len;
		{
			int rs = fp->len;
			int fl = l + sizeof(long);
			int num = fl / rs + (fl % rs ? 1 : 0);
			char **vect = (char **) alloca(num * sizeof(char *));
			int i, vl, r;
			long recno = *(long *) bp;
			struct ListFile *lf = mbase->subs[no];

			buf = alloca(fl);
			*(long *) buf = l;
			memcpy(buf + sizeof(long), vp->s.str.buf, l);

			for (i = 0; i < num; ++i)
			{
				vect[i] = buf;
				buf += rs;
			}

			if ((r = put_ListFile(lf, &recno, vect, num)))
				return listfile_error(mp, lf, nm, __LINE__, r);
			*(long *) bp = recno;
		}
		break;
	case 'O':
		if (vp->t.type != OBJECT_t)
			return error(mp, nm, __LINE__, "assignment to OBJECT field '%s' from non-obj var", fp->name);
		if (vp->o.rtti->hashId != fp->otype)
			return error(mp, nm, __LINE__, "assignment to OBJECT field '%s' from invalid obj var", fp->name);
		{
			int rs = fp->len;
			char **vect = 0;
			int i, r, num = 0;
			long recno = *(long *) bp;
			struct ListFile *lf = mbase->subs[no];

			if (vp->o.rtti->save(mp, vp->o.obj, vp->o.rtti, rs, &vect, &num))
				return error(mp, nm, __LINE__, "cannot correct save object");

			if ((r = put_ListFile(lf, &recno, vect, num)))
				return listfile_error(mp, lf, nm, __LINE__, r);

			*(long *) bp = recno;

			for (i = 0; i < num; ++i)
				free(vect[i]);
			free(vect);
		}
		break;
	case 'A':
		if (vp->t.type != ARRAY_t)
			return error(mp, nm, __LINE__, "assignment to ARRAY_t field '%s' from non-array var", fp->name);
		{
			int i, num = vp->a.count, r;
			long recno = *(long *) bp;
			struct ListFile *lf = mbase->subs[no];

			if (recno >= 0)
				if ((r = del_ListFile(lf, recno)))
					return listfile_error(mp, lf, nm, __LINE__, r);
			if (num > 0)
			{
				long head = -1;
				char *bpp = alloca(len + 1);

				for (i = 0; i < num; ++i)
				{
					ClipVar *vvp = vp->a.items + i;

					if (vvp->t.flags == F_MPTR)
						vvp = vvp->p.vp;
					switch (fp->type1)
					{
					case 'C':
						if (vvp->t.type != CHARACTER_t)
							return error(mp, nm, __LINE__, "assignment to CHARACTER field '%s' from non-character var", fp->name);
						l = vvp->s.str.len;
						if (l > len)
							l = len;
						else
							memset(bpp + l, ' ', len - l);
						memcpy(bpp, vvp->s.str.buf, l);
						break;
					case 'N':
						double tmp;
						if (vvp->t.type != NUMERIC_t)
							return error(mp, nm, __LINE__, "assignment to NUMERIC_t field '%s' from non-numeric var", fp->name);
						buf = mbase->buf;
						tmp = _clip_dobule(vvp);
						snprintf(buf, mbase->recsize, "%+*.*f", len + 1, fp->dec, tmp);
						memcpy(bpp, buf, len + 1);
						break;
					case 'L':
						if (vvp->t.type != LOGICAL_t)
							return error(mp, nm, __LINE__, "assignment to LOGICAL field '%s' from non-logical var", fp->name);
						*bpp = vvp->l.val;
						break;
					case 'D':
						if (vvp->t.type != DATE_t)
							return error(mp, nm, __LINE__, "assignment to DATE field '%s' from non-date var", fp->name);
						*(long *) bpp = vvp->d.julian;
						break;
					}
					if ((r = append_ListFile(lf, &head, bpp)))
						return listfile_error(mp, lf, nm, __LINE__, r);
					if (!i)
						recno = head;
				}

				*(long *) bp = recno;
			}
			else
				*(long *) bp = -1;
		}
		break;
	}
	return 0;
}

/* fields */
static int
getVal(struct DBWorkArea *wa, ClipMachine * mp, int no, ClipVar * vp)
{
	const char nm[] = "getVal";
	MapBase *mbase = (MapBase *) wa->data;
	int r;

	if ((r = make_valid(wa, mp)))
		return r;

	return get_field(wa, mp, mbase, no, vp);
}

static int
setVal(struct DBWorkArea *wa, ClipMachine * mp, int no, ClipVar * vp)
{
	const char nm[] = "setVal";
	MapBase *mbase = (MapBase *) wa->data;
	int r;

	if (!mbase->dirty)
	{
		if ((r = make_valid(wa, mp)))
			return r;
		mbase->dirty = 1;
	}

	return set_field(wa, mp, mbase, no, vp);
}

/* info */
static int
bof(struct DBWorkArea *wa, ClipMachine * mp, int *val)
{
	MapBase *mbase = (MapBase *) wa->data;

	*val = (mbase->pos == BOF_POS ? 1 : 0);
	return 0;
}

static int
eof(struct DBWorkArea *wa, ClipMachine * mp, int *val)
{
	MapBase *mbase = (MapBase *) wa->data;

	*val = (mbase->pos == EOF_POS ? 1 : 0);
	return 0;
}

static int
deleted(struct DBWorkArea *wa, ClipMachine * mp, int *val)
{
	const char nm[] = "deleted";

	return readflag(wa, mp, nm, DELETE_RECORD_FLAG, val);
}

static int
recNo(struct DBWorkArea *wa, ClipMachine * mp, long *val)
{
	MapBase *mbase = (MapBase *) wa->data;

	*val = mbase->pos;
	return 0;
}

static int
recCount(struct DBWorkArea *wa, ClipMachine * mp, long *val)
{
	int r;
	MapBase *mbase = (MapBase *) wa->data;
	BaseHeader *hp;

	if ((r = lockHeader_MapFile(mbase->base, 0, (void **) &hp)))
		return r;

	if (hp->fileCount != mbase->fileCount)
	{
		remap_MapFile(mbase->base);
		hp = (BaseHeader *) getHeader_MapFile(mbase->base);
	}
	*val = hp->recCount;

	if ((r = unlockHeader_MapFile(mbase->base)))
		return r;

	return 0;
}

/* move */
static int
skip(struct DBWorkArea *wa, ClipMachine * mp, long nskip)
{
	void *hp;
	int r;
	long last, newpos;
	MapBase *mbase = (MapBase *) wa->data;

	if ((r = write_dirty(wa, mp, mbase)))
		return r;

	mbase->valid = 0;
	if (mbase->index)
		return skip_index(wa, mp, mbase, nskip);

	if ((r = lockHeader_MapFile(mbase->base, 0, &hp)))
		return r;

	recCount(wa, mp, &last);

	if ((r = unlockHeader_MapFile(mbase->base)))
		return r;

	if (mbase->pos == BOF_POS)
		newpos = -1 + nskip;
	else if (mbase->pos == EOF_POS)
		newpos = last + nskip;
	else
		newpos = mbase->pos + nskip;

	if (newpos < 0)
		mbase->pos = BOF_POS;
	else if (newpos >= last)
		mbase->pos = EOF_POS;
	else
		mbase->pos = newpos;
	return 0;
}

static int
goTop(struct DBWorkArea *wa, ClipMachine * mp)
{
	void *hp;
	int r;
	long last;
	MapBase *mbase = (MapBase *) wa->data;

	if ((r = write_dirty(wa, mp, mbase)))
		return r;

	mbase->valid = 0;
	if (mbase->index)
		return first_index(wa, mp, mbase);

	if ((r = lockHeader_MapFile(mbase->base, 0, &hp)))
		return r;

	recCount(wa, mp, &last);

	if ((r = unlockHeader_MapFile(mbase->base)))
		return r;

	if (last < 1)
		mbase->pos = EOF_POS;
	else
	{
		mbase->pos = 0;
		mbase->valid = 0;
	}
	return 0;
}

static int
goBottom(struct DBWorkArea *wa, ClipMachine * mp)
{
	void *hp;
	int r;
	long last;
	MapBase *mbase = (MapBase *) wa->data;

	if ((r = write_dirty(wa, mp, mbase)))
		return r;

	mbase->valid = 0;
	if (mbase->index)
		return last_index(wa, mp, mbase);

	if ((r = lockHeader_MapFile(mbase->base, 0, &hp)))
		return r;

	recCount(wa, mp, &last);

	if ((r = unlockHeader_MapFile(mbase->base)))
		return r;

	if (last < 1)
		mbase->pos = BOF_POS;
	else
	{
		mbase->pos = last - 1;
		mbase->valid = 0;
	}
	return 0;
}

static int
goTo(struct DBWorkArea *wa, ClipMachine * mp, long recno)
{
	void *hp;
	int r;
	long last;
	const char nm[] = "goTo";
	MapBase *mbase = (MapBase *) wa->data;

	if ((r = write_dirty(wa, mp, mbase)))
		return r;

	mbase->valid = 0;
	if (recno == BOF_POS || recno == EOF_POS)
	{
		mbase->pos = recno;
		return 0;
	}

	if ((r = lockHeader_MapFile(mbase->base, 0, &hp)))
		return r;

	recCount(wa, mp, &last);

	if ((r = unlockHeader_MapFile(mbase->base)))
		return r;

	if (recno < 0 || recno >= last)
		return error(mp, nm, __LINE__, "invalid postion: %ld", recno);

	mbase->pos = recno;
	return 0;
}

/* lock */
static int
slock(struct DBWorkArea *wa, ClipMachine * mp, long recno)
{
	char *bp;
	MapBase *mbase = (MapBase *) wa->data;
	const char nm[] = "lock";

	if (lockRec_MapFile(mbase->base, 1, recno, &bp))
		return base_error(mp, mbase->base, nm, __LINE__);

	return 0;
}

static int
sunlock(struct DBWorkArea *wa, ClipMachine * mp, long recno)
{
	char *bp;
	MapBase *mbase = (MapBase *) wa->data;
	const char nm[] = "unlock";

	if (unlockRec_MapFile(mbase->base, recno))
		return base_error(mp, mbase->base, nm, __LINE__);

	return 0;
}

static int
lockFile(struct DBWorkArea *wa, ClipMachine * mp)
{
	void *hp;
	MapBase *mbase = (MapBase *) wa->data;
	const char nm[] = "lockFile";

	if (lockHeader_MapFile(mbase->base, 1, &hp))
		return base_error(mp, mbase->base, nm, __LINE__);

	return 0;
}

static int
unlockFile(struct DBWorkArea *wa, ClipMachine * mp)
{
	void *hp;
	MapBase *mbase = (MapBase *) wa->data;
	const char nm[] = "unlockFile";

	if (unlockHeader_MapFile(mbase->base))
		return base_error(mp, mbase->base, nm, __LINE__);
}

static int
showDeleted(struct DBWorkArea *ap, ClipMachine * mp, int value)
{
	return 0;
}

static int
recSize(struct DBWorkArea *ap, ClipMachine * mp, long *val)
{
	return 0;
}

static int
headerSize(struct DBWorkArea *ap, ClipMachine * mp, long *val)
{
	return 0;
}

DBFuncTable _RDD_MAPBASE =
{
	"MAPBASE",
	".IX",
	"used mmap(2) based library",
	screate,
	sopen,
	sclose,
	sremove,
	srename,
	saccess,
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
	slock,
	sunlock,
	lockFile,
	unlockFile,
	showDeleted,
	recSize,
	headerSize,
};
