/*
$Log: mapfile.c,v $
Revision 1.7  2000/05/01 19:40:57  clip
SunOS port

Revision 1.6  2000/04/30 19:29:39  clip
size buffer for fread

Revision 1.5  2000/04/27 22:55:52  clip
freebsd fix

Revision 1.4  2000/04/15 20:57:52  paul
mandrake fixes

Revision 1.3  1999/11/09 22:50:10  axl
Created DBFMEM - dbf in memory (fix for zero file handler).

Revision 1.2  1999/11/02 23:05:41  axl
start of logging

*/

#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/file.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

#include "mapfile.h"


#define INCR_PART 4
#define ERRBUFSIZE 256

#define NEW(type) ((type*)calloc(sizeof(type),1))
#define REALLOC(type,ptr,len) ((ptr)=(type*)realloc((ptr),sizeof(type)*(len)))
#define VAR(type,var,ini) type *var=(type*)(ini)
#define NEWVAR(type,var) type *var=(type*)calloc(sizeof(type),1)


typedef struct MapFile
{
	int fd;
	char *map;
	long mapLen;
	int headerSize;
	int recSize;
	int readonly;
	int exclusive;
	long recCount;
	char buf[ERRBUFSIZE];
} MapFile;

int
is_anon( MapFile *fp )
{
	return fp->fd==-1 ? 1 : 0;
}

static int
lock( MapFile *fp, long beg, long len, int writeFl, int wait)
{
	int cmd = (wait?F_SETLKW:F_SETLK);
	struct flock fl;
	int ret;

	if (is_anon(fp))
		return 0;

	fl.l_type = (writeFl?F_WRLCK:F_RDLCK);
	fl.l_whence = SEEK_SET;
	fl.l_start = beg;
	fl.l_len = len;

	ret = fcntl(fp->fd, cmd, &fl);
	if (ret)
		snprintf(fp->buf, ERRBUFSIZE, "lock: %s", strerror(errno));
	return ret;
}

static int
unlock( MapFile *fp, int beg, int len)
{
	int cmd = F_SETLK;
	struct flock fl;
	int ret;

	if (is_anon(fp))
		return 0;

	fl.l_type = F_UNLCK;
	fl.l_whence = SEEK_SET;
	fl.l_start = beg;
	fl.l_len = len;

	ret = fcntl(fp->fd, cmd, &fl);
	if (ret)
		snprintf(fp->buf, ERRBUFSIZE, "unlock: %s", strerror(errno));
	return ret;
}

static int
lockF(MapFile *fp, int writeFl, int wait)
{
	int ret;

	if (is_anon(fp))
		return 0;

#if defined(LOCK_EX) && defined(LOCK_SH) && defined(LOCK_NB) && defined(LOCK_UN)
	ret = flock(fp->fd, (writeFl?LOCK_EX:LOCK_SH)|(wait?0:LOCK_NB) );
#else
	ret = lock(fp, 0, fp->mapLen, writeFl, wait);
#endif
	if (ret)
		snprintf(fp->buf, ERRBUFSIZE, "lockF: %s", strerror(errno));
	return ret;
}

static int
unlockF(MapFile *fp)
{
	int ret;

	if (is_anon(fp))
		return 0;

#if defined(LOCK_EX) && defined(LOCK_SH) && defined(LOCK_NB) && defined(LOCK_UN)
	ret = flock(fp->fd, LOCK_UN);
#else
	ret = unlock(fp, 0, fp->mapLen);
#endif
	if (ret)
		snprintf(fp->buf, ERRBUFSIZE, "unlockF: %s", strerror(errno));
	return ret;
}

struct MapFile *
create_MapFile(const char *name, int headerSize, int recSize, char *errbuf, int errbuflen )
{
	MapFile *fp;

	if (headerSize<0 || recSize<0 /*|| !name*/)
	{
		snprintf(errbuf, errbuflen, "invalid arguments");
		return 0;
	}

	fp = NEW(MapFile);

	fp->mapLen = fp->headerSize = headerSize;
	fp->recSize = recSize;
	fp->recCount = 0;

	if (name)
	{
		fp->fd = open(name, O_CREAT | O_RDWR | O_TRUNC, 0660);
		if (fp->fd<0)
		{
			free(fp);
			snprintf(errbuf, errbuflen, "cannot open file '%s': %s", name, strerror(errno));
			return 0;
		}
		fp->map = mmap(0, headerSize, PROT_READ|PROT_WRITE, MAP_SHARED,
			fp->fd, 0);
	}
	else
	{
#ifdef MAP_ANON
		fp->fd = -1;
		fp->map = mmap(0, headerSize, PROT_READ|PROT_WRITE,
			MAP_PRIVATE|MAP_ANON, fp->fd, 0);
#else
		free(fp);
		snprintf(errbuf, errbuflen, "system does not support MAP_ANON");
		return 0;
#endif
	}

	if ( fp->map == (caddr_t)-1 )
	{
		snprintf(errbuf, errbuflen, "cannot mmap file '%s': %s", name, strerror(errno));
err:
		if (!is_anon(fp))
			close(fp->fd);
		free(fp);
		return 0;
	}

	if (!is_anon(fp) && headerSize>0)
	{
		lseek(fp->fd, headerSize-1, SEEK_SET);
		write(fp->fd, "", 1);
	}

	if (lock(fp, 0, headerSize, 1, 1))
	{
		munmap(fp->map, fp->mapLen);
		snprintf(errbuf, errbuflen, "cannot lock file '%s': %s", name, fp->buf);
		goto err;
	}

	if (headerSize>0)
		memset(fp->map, 0, headerSize);

	sync_MapFile(fp);

	unlock(fp,0, headerSize);

	return fp;
}

int
setRecSize_MapFile(struct MapFile *fp, int recSize)
{
	fp->recSize = recSize;
	fp->recCount = (fp->mapLen-fp->headerSize)/fp->recSize;
	return 0;
}

int
setHeaderSize_MapFile(struct MapFile *fp, int headerSize)
{
	fp->headerSize = headerSize;
	fp->recCount = (fp->mapLen-fp->headerSize)/fp->recSize;
	return 0;
}

struct MapFile *
open_MapFile(const char *name, int headerSize, int writeFl, char *errbuf, int errbuflen )
{
	struct stat st;
	MapFile *fp;

	if (headerSize<0 || !name)
	{
		snprintf(errbuf, errbuflen, "invalid arguments");
		return 0;
	}

	fp = NEW(MapFile);
	fp->headerSize = headerSize;
	fp->recSize = 0;

	fp->fd = open(name, (writeFl?O_RDWR:O_RDONLY) );
	fp->map = (caddr_t)-1;
	fp->mapLen = 0;
	fp->readonly = !writeFl;
	if (fp->fd<0)
	{
		snprintf(errbuf, errbuflen, "cannot open file '%s': %s", name, strerror(errno));
err:
		if (!is_anon(fp))
			close(fp->fd);
		if (fp->mapLen)
			munmap(fp->map, fp->mapLen);
		free(fp);
		return 0;
	}

	fstat(fp->fd, &st);
	if (st.st_size<headerSize)
	{
		snprintf(errbuf, errbuflen, "invalid file '%s': size < headerSize (%d)", name, headerSize);
		goto err;
	}

	fp->map = mmap(0, st.st_size, PROT_READ|(writeFl?PROT_WRITE:0), MAP_SHARED,
			fp->fd, 0);
	if ( fp->map == (caddr_t)-1 )
	{
		snprintf(errbuf, errbuflen, "cannot mmap file '%s': %s", name, strerror(errno));
		goto err;
	}

	fp->mapLen = st.st_size;
	fp->recCount = 0;

	return fp;
}

int
close_MapFile(struct MapFile *fp)
{
	if (!fp)
		return -1;
	sync_MapFile(fp);
	munmap(fp->map, fp->mapLen);
	if (!is_anon(fp))
		close(fp->fd);
	return 0;
}

int
sync_MapFile(struct MapFile *fp)
{
	int ret;

/*
	if (is_anon(fp))
		return 0;
*/
	ret = msync( fp->map, fp->mapLen, MS_ASYNC);
	return ret;
}

int
remap_MapFile(struct MapFile *fp)
{
	struct stat st;

	if (is_anon(fp))
		return 0;

	fstat(fp->fd, &st);
	if (st.st_size==fp->mapLen)
		return 0;

	munmap(fp->map, fp->mapLen);
	fp->mapLen = st.st_size;
	fp->map = mmap(fp->map, fp->mapLen, PROT_READ|(!fp->readonly ? PROT_WRITE : 0),
		MAP_SHARED, fp->fd, 0);
	if ( fp->map == (caddr_t)-1 )
	{
		snprintf(fp->buf, ERRBUFSIZE, "mmap: %s", strerror(errno));
		return -1;
	}
	fp->recCount = (fp->mapLen-fp->headerSize)/fp->recSize;

	return 0;
}

void
getError_MapFile(struct MapFile *fp, char *buf, int buflen)
{
	snprintf(buf, buflen, "%s", fp->buf);
}

int
recSize_MapFile(struct MapFile *fp)
{
	return fp->recSize;
}

long
headerSize_MapFile(struct MapFile *fp)
{
	return fp->headerSize;
}

long
recCount_MapFile(struct MapFile *fp)
{
	return fp->recCount;
}

long
fileSize_MapFile(struct MapFile *fp)
{
	struct stat st;

	if (is_anon(fp))
		return fp->mapLen;

	fstat(fp->fd, &st);
	return st.st_size;
}

long
mapLen_MapFile(struct MapFile *fp)
{
	return fp->mapLen;
}


int
fd_MapFile(struct MapFile *fp)
{
	return fp->fd;
}


int
lockHeader_MapFile(struct MapFile *fp, int writeFl, void **buf )
{
	int ret = lock(fp, 0, fp->headerSize, writeFl, 1);
	*buf = fp->map;
	return ret;
}

void *
getHeader_MapFile(struct MapFile *fp)
{
	return (void*)fp->map;
}

void *
getData_MapFile(struct MapFile *fp)
{
	return (void*)(fp->map+fp->headerSize);
}


int
unlockHeader_MapFile(struct MapFile *fp)
{
	int ret = unlock(fp, 0, fp->headerSize);
	return ret;
}

char *
getRec_MapFile(struct MapFile *fp, long recno)
{
	long offs = fp->headerSize + recno * fp->recSize;
	return fp->map+offs;
}

char *
getMap_MapFile(struct MapFile *fp)
{
	return fp->map;
}

int
lockRec_MapFile(struct MapFile *fp, int writeFl, long recno, char **bufp)
{
	int rs = fp->recSize;
	long offs = fp->headerSize + recno * rs;
	int ret = lock(fp, offs, rs, writeFl, 1);

	*bufp = fp->map+offs;

	return ret;
}

int
unlockRec_MapFile(struct MapFile *fp, long recno)
{
	int rs = fp->recSize;
	long offs = fp->headerSize + recno * rs;
	int ret = unlock(fp, offs, rs);
	return ret;
}


int
lock_MapFile(struct MapFile *fp, int writeFl)
{
	return lockF(fp, writeFl, 1);
}

int
unlock_MapFIle(struct MapFile *fp)
{
	return unlockF(fp);
}


int
incr_MapFile(struct MapFile *fp, long *recno, long num, long addnum)
{
	long size, nsize, count;
	int rs = fp->recSize;
	int hs = fp->headerSize;
	struct stat st;

	if (fp->readonly)
	{
		snprintf(fp->buf, ERRBUFSIZE, "file opened read-only");
		return -1;
	}

	if (!is_anon(fp))
	{
		fstat(fp->fd, &st);
		size = st.st_size;
	}
	else size = fp->mapLen;

	count = (size-hs)/rs;

	*recno = count;

	nsize = size+num*rs;

	if (nsize> fp->mapLen)
	{
		if (!is_anon(fp))
		{
			munmap(fp->map, fp->mapLen);
			fp->map = mmap(fp->map, nsize+addnum*rs,
				PROT_READ|PROT_WRITE, MAP_SHARED, fp->fd, 0);
		}
		else
		{
#ifdef MREMAP_MAYMOVE
			fp->map = mremap(fp->map, fp->mapLen, nsize+addnum*rs, MREMAP_MAYMOVE);
#else
#ifdef MAP_ANON
			fp->map = mmap(fp->map, nsize+addnum*rs,
				PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANON, fp->fd, 0);
#endif
#endif
		}
		if ( fp->map == (caddr_t)-1 )
		{
			snprintf(fp->buf, ERRBUFSIZE, "mmap: %s", strerror(errno));
			return -1;
		}

		fp->mapLen = nsize+addnum*rs;
	}
	if (!is_anon(fp))
	{
		lseek(fp->fd, nsize-1, SEEK_SET);
		write(fp->fd, "", 1);
	}
	sync_MapFile(fp);

	fp->recCount=count+num;

	return 0;
}

int
decr_MapFile(struct MapFile *fp, long reccount)
{
	long size, nsize;
	int rs = fp->recSize;
	int hs = fp->headerSize;
	struct stat st;

	if (fp->readonly)
	{
		snprintf(fp->buf, ERRBUFSIZE, "file opened read-only");
		return -1;
	}

	if (!is_anon(fp))
	{
		fstat(fp->fd, &st);
		size = st.st_size;
	}
	else size = fp->mapLen;

	nsize = reccount*rs + hs;

	if (nsize==size)
		return 0;
	else if (nsize>size)
	{
		snprintf(fp->buf, ERRBUFSIZE, "file already truncated");
		return -1;
	}



	if (!is_anon(fp))
	{
		munmap(fp->map, fp->mapLen);
		if (ftruncate(fp->fd, nsize))
		{
			snprintf(fp->buf, ERRBUFSIZE, "truncate: %s", strerror(errno));
			return -1;
		}
		lseek(fp->fd, nsize-1, SEEK_SET);
		write(fp->fd, "", 1);
		fp->map = mmap(fp->map, nsize, PROT_READ|PROT_WRITE,
			MAP_SHARED, fp->fd, 0);
	}
	else
	{
#ifdef MREMAP_MAYMOVE
		fp->map = mremap(fp->map, fp->mapLen, nsize, MREMAP_MAYMOVE);
#else
#ifdef MAP_ANON
		fp->map = mmap(fp->map, nsize, PROT_READ|PROT_WRITE,
			MAP_PRIVATE|MAP_ANON, fp->fd, 0);
#endif
#endif
	}

	if ( fp->map == (caddr_t)-1 )
	{
		snprintf(fp->buf, ERRBUFSIZE, "mmap: %s", strerror(errno));
		return -1;
	}

	fp->mapLen = nsize;

	sync_MapFile(fp);

	fp->recCount=reccount;

	return 0;
}


