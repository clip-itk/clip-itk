/*
   Copyright (C) 2001  ITK
   Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */

/*
  $Log: bzip2.c,v $
  Revision 1.4  2003/07/03 07:15:56  clip
  fix a lot of warnings
  paul

  Revision 1.3  2002/01/30 08:20:07  clip
  cigwin PG_CHARS fixes
  bzip2 func prefix auto-configuration
  paul

  Revision 1.2  2001/11/15 13:16:49  clip
  fix
  paul

 */

#include <errno.h>
#include <limits.h>
#include <string.h>

#include "hashcode.h"
#include "clip.h"
#include "error.ch"

#include <bzlib.h>
#include "bzpref.h"


static void
destroy_bzip_file(void *file)
{
	if (file != NULL)
		BZPREF(bzclose)((BZFILE *) file);
}

int
clip_BZIP2OPEN(ClipMachine * mp)
{
	char *fname = _clip_parc(mp, 1);
	char *mode = _clip_parc(mp, 2);
	int *err = NULL, ret;
	char buf[PATH_MAX];
	BZFILE *gz;

	if (fname == NULL)
	{
		_clip_retni(mp, -1);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "GZIPOPEN");
	}
	if (mode == NULL)
		mode = "rb";

	_clip_translate_path(mp, fname, buf, sizeof(buf));
	if (strcmp(buf, "in") == 0)
		gz = BZPREF(bzdopen)(fileno(stdin), "rb");
	else
	{
		if (strcmp(buf, "out") == 0)
			gz = BZPREF(bzdopen)(fileno(stdout), "wb");
		else
			gz = BZPREF(bzopen)(buf, mode);
	}
	if (!gz)
	{
		err = _clip_fetch_item(mp, HASH_ferror);
		*err = errno;
		_clip_retni(mp, -1);
		return 0;
	}
	ret = _clip_store_c_item(mp, gz, _C_ITEM_TYPE_FILE, destroy_bzip_file);
	_clip_retni(mp, ret);
	return 0;
}

int
clip_BZIP2READ(ClipMachine * mp)
{
	BZFILE *gz;
	char *buf;
	int *err = NULL, fd, nb = 0;
	long ret = -1;

	fd = _clip_parni(mp, 1);
	buf = _clip_parcl(mp, 2, &nb);
	gz = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (mp->argc > 2)
		nb = _clip_parnl(mp, 3);

	if (gz == NULL || !buf)
	{
		_clip_retnl(mp, -1);
		return 0;
	}

	buf = (char *) malloc(nb);

	ret = BZPREF(bzread)(gz, buf, nb);
	if (ret >= 0)
		_clip_storclen(mp, buf, ret, 2, 0);
	else
	{
		err = _clip_fetch_item(mp, HASH_ferror);
		*err = errno;
	}

	_clip_retnl(mp, ret);
	free(buf);

	return 0;
}

int
clip_BZIP2WRITE(ClipMachine * mp)
{
	BZFILE *gz;
	int len = 0, *err = NULL;
	int fd = _clip_parni(mp, 1);
	char *str = _clip_parcl(mp, 2, &len);
	long ret = -1, n = _clip_parnl(mp, 3);

	gz = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (gz == NULL || !str)
	{
		_clip_retnl(mp, -1);
		return 0;
	}
	if (n <= 0 || n >= len)
		n = len;
	ret = BZPREF(bzwrite)(gz, (void *) str, n);
	err = _clip_fetch_item(mp, HASH_ferror);
	*err = ret < 0 ? errno : 0;
	_clip_retnl(mp, ret);
	return 0;
}

int
clip_BZIP2CLOSE(ClipMachine * mp)
{
	BZFILE *gz;
	int fd = _clip_parni(mp, 1);
	int ret = -1, *err = _clip_fetch_item(mp, HASH_ferror);

	gz = (BZFILE *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (gz == NULL)
	{
		*err = EBADF;
	}

	else if (_clip_destroy_c_item(mp, fd, _C_ITEM_TYPE_FILE))
	{
		ret = 0;
		*err = 0;
	}

	_clip_retl(mp, (ret == 0));
	return 0;
}


static void
write_ulong(char *dst, unsigned long l)
{
	dst[0] = l & 0xff;
	dst[1] = (l>>8) & 0xff;
	dst[2] = (l>>16) & 0xff;
	dst[3] = (l>>24) & 0xff;
}

static unsigned long
read_ulong(char *src)
{
	return ((unsigned long)src[0])
		| (((unsigned long)src[1]) << 8)
		| (((unsigned long)src[2]) << 16)
		| (((unsigned long)src[3]) << 24)
		;
}

/*
	BZIP2(cStr[, nLevel]) --> cResult
*/
int
clip_BZIP2(ClipMachine * mp)
{
	int l, r;
	unsigned int rl;
	int level = 9;
	char *s, *rp, *rp1;

	s = _clip_parcl(mp, 1, &l);

	if (!s)
		return EG_ARG;

	if ( _clip_parinfo(mp, 1) == 'N' )
		level = _clip_parni(mp, 1);
	if (level < 1 || level > 9)
		level = 9;

	if (l<10)
		rl = l + 1 + 600 ;
	else
		rl = l + (l/10) + 600;
	rp = (char *)malloc( rl + 4 );
	rp1 = rp + sizeof(long);

	r = BZPREF(bzBuffToBuffCompress)( rp1, &rl, s, l, level, 0, 0);

	if (r != BZ_OK )
	{
		free(rp);
		return EG_MEM;
	}

	write_ulong(rp, rl);

	rp = (char*) realloc(rp, rl+5);
	rp[rl+4] = 0;

	_clip_retcn_m(mp, rp, rl + 4);

	return 0;
}


/*
	BUNZIP2(cStr) --> cResult
*/
int
clip_BUNZIP2(ClipMachine * mp)
{
	int l, r;
	unsigned int rl;
	char *s, *rp;

	s = _clip_parcl(mp, 1, &l);

	if (!s || l<4 )
		return EG_ARG;


	rl = read_ulong(s);
	rp = (char *)malloc( rl );

	r = BZPREF(bzBuffToBuffDecompress)( rp, &rl, s + 4, l - 4, 0, 0);

	if (r != BZ_OK )
	{
		free(rp);
		if (r == BZ_DATA_ERROR)
			return EG_ARG;
		else
			return EG_MEM;
	}

	_clip_retcn_m(mp, rp, rl);

	return 0;
}

