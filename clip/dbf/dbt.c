/*
$Log: dbt.c,v $
Revision 1.4  2000/06/14 02:07:20  clip
fix PACK with DBT file
Alex Vorontsov <axl@itk.ru>

Revision 1.3  1999/11/09 22:49:26  axl
Created DBFMEM - dbf in memory.

Revision 1.2  1999/10/26 19:19:10  axl
start cvs logging (./dbf)

*/

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "dbfpriv.h"
#define DBT_PAGESIZE 512

/*
   Note: all locking go through owner-dbf
 */

static void *dbt_create(void);
static int dbt_destroy(void *self);
static int dbt_error(void *self, char *errbuf, int errbuflen);
static int dbt_fcreate(void *self, const char *name);
static int dbt_fopen(void *self, const char *name, int wrflag);
static int dbt_frename(void *self, const char *name);
static int dbt_fclose(void *self);
static int dbt_get(void *self, char **strp, int *lenp, long block);
static int dbt_put(void *self, char *str, int len, long *block);

DbfMemoVtbl dbtVtbl =
{
	"dbt",
	".dbt",
	dbt_create,
	dbt_destroy,
	dbt_error,
	dbt_fcreate,
	dbt_fopen,
	dbt_frename,
	dbt_fclose,
	dbt_get,
	dbt_put,
};

#define NEW(type) ((type*)calloc(sizeof(type),1))

typedef struct
{
	char *path;
	struct MapFile *mp;
	long fileSize;
	int wrflag:1;

	char errbuf[ERRBUFSIZE];
}
DbtFile;

typedef struct
{
	unsigned char freeno[4];
	unsigned char reserved1[12];
	unsigned char version;	/* 03 for DBASEIII compatible memo */
	unsigned char reserved2[511];
}
DbtHeader;

static void *
dbt_create(void)
{
	return NEW(DbtFile);
}

static int
dbt_destroy(void *self)
{
	DbtFile *fp = (DbtFile *) self;

	if (fp->mp)
		dbt_fclose(fp);

	free(fp);

	return 0;
}

static int
dbt_error(void *self, char *errbuf, int errbuflen)
{
	DbtFile *fp = (DbtFile *) self;

	strncpy(errbuf, fp->errbuf, errbuflen);

	return 0;
}

static void
make_path(char *path, int plen, const char *name)
{
	char *e;

	e = strrchr(path, '.');
	if (!e)
		e = path + strlen(path);

	strncpy(e, ".dbt", plen - (e - path));
}

static int
dbt_fcreate(void *self, const char *name)
{
	DbtFile *fp = (DbtFile *) self;
	DbtHeader *hp;
	int r = 0;
	char path[256];

	if (fp->mp)
		if ((r = dbt_fclose(fp)))
			return r;
	if (name)
	{
		strncpy(path, name, sizeof(path));
		make_path(path, sizeof(path), name);
		fp->mp = create_MapFile(path, 512, DBT_PAGESIZE, fp->errbuf, ERRBUFSIZE);
	}
	else
		fp->mp = create_MapFile(0, 512, DBT_PAGESIZE, fp->errbuf, ERRBUFSIZE);

	if (!fp->mp)
		return -1;

	if (name)
		fp->path = strdup(path);
	fp->fileSize = mapLen_MapFile(fp->mp);
	fp->wrflag = 1;
	hp = (DbtHeader *) getHeader_MapFile(fp->mp);
	dbf_put_long(hp->freeno, 1);
	hp->version = 0x50;	/* Clipper!? */

	return r;
}

static int
dbt_fopen(void *self, const char *name, int wrflag)
{
	DbtFile *fp = (DbtFile *) self;
	int r = 0;
	char path[256];

	if (fp->mp)
		if ((r = dbt_fclose(fp)))
			return r;
	strncpy(path, name, sizeof(path));

	make_path(path, sizeof(path), name);

	fp->mp = open_MapFile(path, wrflag, 512, fp->errbuf, ERRBUFSIZE);
	if (!fp->mp)
		return -1;

	fp->path = strdup(path);
	fp->fileSize = mapLen_MapFile(fp->mp);
	fp->wrflag = wrflag;
	setRecSize_MapFile(fp->mp, DBT_PAGESIZE);
	setHeaderSize_MapFile(fp->mp, 512);

	return r;
}

static int
dbt_frename(void *self, const char *name)
{
	DbtFile *fp = (DbtFile *) self;
	char path[256];

	strncpy(path, name, sizeof(path));
	make_path(path, sizeof(path), name);

	if (fp->path)
	{
		rename(fp->path, path);
		free(fp->path);
	}

	fp->path = strdup(path);

	return 0;
}

static int
dbt_fclose(void *self)
{
	DbtFile *fp = (DbtFile *) self;
	int r = 0;

	if (!fp->mp)
		return 0;

	r = close_MapFile(fp->mp);
	fp->mp = 0;
	if (fp->path)
		free(fp->path);
	fp->path = 0;

	return r;
}

static int
dbt_get(void *self, char **strp, int *lenp, long block)
{
	DbtFile *fp = (DbtFile *) self;
	DbtHeader *hp;
	long freeno;
	char *ptr, *endp, *limit;
	int len;

	if (block < 1)
	{
		*strp = (char *) malloc(1);
		(*strp)[0] = 0;
		*lenp = 0;
		return 0;
	}

	hp = (DbtHeader *) getHeader_MapFile(fp->mp);
	freeno = dbf_get_long(hp->freeno);

	if (block >= freeno)
	{
		snprintf(fp->errbuf, ERRBUFSIZE, "DBT: invalid block no %ld (must be between 1 and %ld)",
			 block, freeno);
		return -1;
	}

	ptr = getRec_MapFile(fp->mp, block - 1);
	if (!ptr)
	{
		getError_MapFile(fp->mp, fp->errbuf, ERRBUFSIZE);
		return -1;
	}

	limit = getMap_MapFile(fp->mp) + freeno * DBT_PAGESIZE;

	for (endp = ptr; endp < limit && *endp != 0x1a; ++endp)
		;

	len = endp - ptr;
	*lenp = len;
	*strp = (char *) realloc(*strp, len + 1);
	memcpy(*strp, ptr, len);
	(*strp)[len] = 0;

	return 0;
}

static int
dbt_put(void *self, char *str, int len, long *blockp)
{
	DbtFile *fp = (DbtFile *) self;
	DbtHeader *hp;
	long freeno;
	char *ptr, *endp, *limit;
	long dlen, npage, rest;

	if (*blockp < 1)
	{
		long tail, size, maplen;

	      newplace:
		size = fileSize_MapFile(fp->mp);
		maplen = mapLen_MapFile(fp->mp);

		if (maplen != size)
		{
			remap_MapFile(fp->mp);
			maplen = mapLen_MapFile(fp->mp);
		}

		hp = (DbtHeader *) getHeader_MapFile(fp->mp);
		freeno = dbf_get_long(hp->freeno);
		tail = (maplen / DBT_PAGESIZE) - freeno;
		npage = (len + 2) / DBT_PAGESIZE;
		rest = (len + 2) % DBT_PAGESIZE;
		if (rest)
			++npage;

		if (tail < npage)
		{
			int r;
			long pos, delta;

			delta = (maplen / DBT_PAGESIZE) / 3;
			if (delta < npage)
				delta = npage + 1;
			r = incr_MapFile(fp->mp, &pos, delta, 0);
			if (r)
			{
				getError_MapFile(fp->mp, fp->errbuf, ERRBUFSIZE);
				return -1;
			}
		}

		hp = (DbtHeader *) getHeader_MapFile(fp->mp);
		ptr = getRec_MapFile(fp->mp, freeno - 1);
		if (!ptr)
		{
			getError_MapFile(fp->mp, fp->errbuf, ERRBUFSIZE);
			return -1;
		}

		memcpy(ptr, str, len);
		ptr[len] = 0x1a;
		ptr[len + 1] = 0x1a;
		*blockp = freeno;
		dbf_put_long(hp->freeno, freeno + npage);

		return 0;
	}

	hp = (DbtHeader *) getHeader_MapFile(fp->mp);
	freeno = dbf_get_long(hp->freeno);

	if (*blockp >= freeno)
	{
		snprintf(fp->errbuf, ERRBUFSIZE, "DBT: invalid block no %ld (must be between 2 and %ld)",
			 *blockp, freeno);
		return -1;
	}

	ptr = getRec_MapFile(fp->mp, *blockp - 1);
	if (!ptr)
	{
		getError_MapFile(fp->mp, fp->errbuf, ERRBUFSIZE);
		return -1;
	}

	limit = getMap_MapFile(fp->mp) + freeno * DBT_PAGESIZE;

	for (endp = ptr; endp < limit && *endp != 0x1a; ++endp)
		;

	dlen = (endp - ptr) + 2;
	npage = dlen / DBT_PAGESIZE;
	rest = dlen % DBT_PAGESIZE;
	if (rest)
		++npage;

	dlen = npage * DBT_PAGESIZE;
	if (dlen < (len + 2))
		goto newplace;

	memcpy(ptr, str, len);
	ptr[len] = 0x1a;
	ptr[len + 1] = 0x1a;

	return 0;
}
