/*
	Copyright (C) 2001  ITK
	Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>, Sergey Rosenfeld <serg@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log: _file.c,v $
   Revision 1.154  2004/03/25 12:56:45  clip
   rust: no timeout on F_SETLKW in _clip_setlock()

   Revision 1.153  2004/03/03 11:59:57  clip
   rust: don't erase file on FERASE() if file isn't closed

   Revision 1.152  2004/02/03 09:48:32  clip
   rust: fix in _clip_close()

   Revision 1.151  2003/12/16 08:23:37  clip
   uri: fwrite(NIL,...) by default have stdout handle.

   Revision 1.150  2003/12/10 09:20:09  clip
   uri: memory leak fixed in directory()

   Revision 1.149  2003/12/02 10:10:48  clip
   uri: small fix in _clip_fwrite

   Revision 1.148  2003/11/20 13:59:35  clip
   uri: small fix

   Revision 1.147  2003/09/09 14:36:14  clip
   uri: fixes for mingw from Mauricio and Uri

   Revision 1.146  2003/09/04 13:05:53  clip
   *** empty log message ***

   Revision 1.145  2003/09/02 14:27:42  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.144  2003/08/04 08:08:52  clip
   rust: DBUSEAREA() looking for neterrors in mp->HASH_ferror, not errno

   Revision 1.143  2003/07/03 07:15:55  clip
   fix a lot of warnings
   paul

   Revision 1.142  2003/06/19 10:43:38  clip
   rust: close() -> _clip_close in MEMOWRIT(READ)

   Revision 1.141  2003/06/16 13:37:35  clip
   rust: FO_DENYWRITE(READ) as FO_EXCLUSIVE (clipper compatiblity)

   Revision 1.140  2003/06/14 09:56:24  clip
   uri: small fix for directory("/")

   Revision 1.139  2003/05/19 09:07:47  clip
   uri: small fix

   Revision 1.138  2003/05/19 08:24:40  clip
   uri: tempfile() rewrited and moved from diskutils.c to ftools.prg
	C-level  mkstemp() not compatibility with:
	- len of file name is not 8 bites
	- file name have lower and upper characters

   Revision 1.137  2003/04/15 08:05:10  clip
   uri: fix for fopen(FO_TRUNC)

   Revision 1.136  2003/04/14 14:01:24  clip
   rust: bug in fclose(), reported by IstvАn FЖldi <foldii@terrasoft.hu>

   Revision 1.135  2003/04/14 07:37:37  clip
   uri: small fix in ftrunc()

   Revision 1.134  2003/04/03 14:05:14  clip
   *** empty log message ***

   Revision 1.133  2003/04/03 13:52:47  clip
   rust: Cygwin fixes

   Revision 1.132  2003/04/02 13:09:11  clip
   rust: small fix

   Revision 1.131  2003/04/02 10:53:19  clip
   rust: _clip_close() added

   Revision 1.130  2003/03/26 10:00:56  clip
   rust: __off_t -> off_t

   Revision 1.129  2003/03/25 10:58:11  clip
   rust: _clip_setlock() added

   Revision 1.128  2003/03/21 11:49:39  clip
   rust: RDD locks with tasks (DOS compatibility)

   Revision 1.127  2003/02/07 06:18:38  clip
   uri: small fix in FCREATE

   Revision 1.126  2003/02/02 12:04:11  clip
   uri: ftrunc() added

   Revision 1.125  2003/01/21 11:01:50  clip
   uri: small fix in file IO nonbuffering

   Revision 1.124  2002/11/26 10:21:22  clip
   OpenBSD fixes
   paul

   Revision 1.123  2002/11/12 09:47:11  clip
   *** empty log message ***

   Revision 1.122  2002/11/05 11:19:09  clip
   *** empty log message ***

   Revision 1.121  2002/11/05 10:07:13  clip
   uri: added FO_TRUNC mode to fopen()

   Revision 1.120  2002/11/05 09:20:20  clip
   *** empty log message ***

   Revision 1.119  2002/10/24 10:39:10  clip
   uri: small fix for freebsd:

   Revision 1.118  2002/10/21 09:54:32  clip
   uri: small fix for cygwin

   Revision 1.117  2002/10/21 09:32:56  clip
   uri: changes from druzus.

   Revision 1.116  2002/10/19 12:39:13  clip
   uri: small fix in directory() for cygwin

   Revision 1.115  2002/10/10 08:49:44  clip
   uri: fileeof(-1) bug fixed

   Revision 1.114  2002/10/08 07:55:23  clip
   uri: small fix

   Revision 1.113  2002/10/03 12:13:23  clip
   uri: fixes in filegetstr()

   Revision 1.112  2002/10/03 11:19:23  clip
   uri: fixes in ftell(), fseek(), fileeof() for non buffering mode file IO

   Revision 1.111  2002/10/02 12:21:55  clip
   uri: added "set buffring on|off" and changed fileIO functions for it.

   Revision 1.110  2002/10/02 11:02:20  clip
   uri: small fix

   Revision 1.109  2002/10/02 07:41:29  clip
   uri: fileno() added

   Revision 1.108  2002/10/02 07:18:09  clip
   uri: added type of opened file control, ftype() added.

   Revision 1.107  2002/09/30 11:22:58  clip
   uri: small fix

   Revision 1.106  2002/09/02 06:39:20  clip
   uri: freadstr() read only to chr(0)

   Revision 1.105  2002/08/23 08:57:32  clip
   uri: small fix in file()

   Revision 1.104  2002/08/02 08:48:27  clip
   uri: fixed bug in FILE("c:fname") with default current directory

   Revision 1.103  2002/07/07 11:55:32  clip
   uri: fix in fread() with string len==0

   Revision 1.102  2002/05/27 09:52:41  clip
   uri: added "set fopen mode DOS|POSIX"

   Revision 1.101  2002/05/26 15:33:00  clip
   uri: small fix for cygwin

   Revision 1.100  2002/05/26 10:36:18  clip
   uri: FILENO() added

   Revision 1.99  2002/05/24 12:49:22  clip
   uri: O_BINARY & stdin/stdout under cygwin

   Revision 1.98  2002/04/30 09:52:20  clip
   uri: small fix

   Revision 1.97  2002/04/24 09:51:13  clip
   _SET_DISPBOX turn off pg char translation
   paul

   Revision 1.96  2002/04/23 14:24:16  clip
   uri: fix in doserror()

   Revision 1.95  2002/04/23 11:42:37  clip
   append _clip_open
   paul

   Revision 1.94  2002/04/23 08:23:56  clip
   _clip_creat fix
   paul

   Revision 1.93  2002/04/22 14:05:12  clip
   add _clip_creat
   creat & open modes on ncpfs
   paul

   Revision 1.92  2002/04/22 12:03:42  clip
   uri: small fix for fopen(" | program")

   Revision 1.91  2002/04/22 11:11:20  clip
   remove ncp code from rdd/dbf.c
   create ncp module
   add ncp usage in _file/diskutil _set_lock call
   paul

   Revision 1.90  2002/04/04 05:55:07  clip
   uri: flockf() added

   Revision 1.89  2002/04/04 05:17:27  clip
   uri: add opened files 0-stdin, 1-stdout, 2-stderr.

   Revision 1.88  2002/04/03 13:01:01  clip
   uri: fix in fopen() from druzus.

   Revision 1.87  2002/03/18 09:17:02  clip
   uri: O_BINARY in fcreate()

   Revision 1.86  2002/02/28 11:05:49  clip
   uri: bugs in bummash fixed

   Revision 1.85  2002/02/27 10:51:07  clip
   uri: fwrite() && datalen==0

   Revision 1.84  2002/02/26 17:05:27  clip
   uri: bug in fcreate(), doc about "full SIX"

   Revision 1.83  2002/02/14 12:31:57  clip
   uri: fixed bug in CURDIR()

   Revision 1.82  2002/02/06 15:01:30  clip
   uri: fopen() for raw devices, freadready, fwriteready() added

   Revision 1.81  2002/01/23 10:53:14  clip
   uri: UAT() added

   Revision 1.80  2001/12/19 13:41:02  clip
   uri: GETE() added

   Revision 1.79  2001/11/19 10:43:52  clip
   bad realloc size in FILE()
   rust

   Revision 1.78  2001/11/16 13:02:37  clip
   uri: fix for cygwin for detect current drive

   Revision 1.77  2001/11/12 12:24:19  clip
   uri: small fix

   Revision 1.76  2001/11/12 12:20:49  clip
   uri: O_BINARY & FOPEN()

   Revision 1.75  2001/11/10 11:47:01  clip
   uri: small bug in file()

   Revision 1.74  2001/11/01 14:54:40  clip
   _clip_path() - makes absolute path respecting SET DEFAULT, SET PATH etc
   rust

   Revision 1.73  2001/10/28 07:41:56  clip
   uri: add support "set path to " in file()

   Revision 1.72  2001/09/24 15:35:01  clip
   ferase && locking files

   Revision 1.71  2001/08/13 13:22:17  clip
   uri: tcpclose(), HASH_ferror & errno fixed

   Revision 1.70  2001/07/31 09:25:46  clip
   uri: add FILE&DIR CREATE MODE in format "nnn"

   Revision 1.69  2001/07/31 08:21:50  clip
   uri: add SET_FILECREATEMODE & SET_DIRCREATEMODE and fixed in functions

   Revision 1.68  2001/06/19 08:10:00  clip
   uri: bug in FILE()

   Revision 1.67  2001/06/19 07:43:27  clip
   uri: small bug in FILE with not exist path in parameter

   Revision 1.66  2001/06/18 12:07:13  clip
   uri: added to FILE() support "set default to "

   Revision 1.65  2001/06/13 16:42:39  clip
   uri:bug in memowrite() with empty output string

   Revision 1.64  2001/06/13 13:05:47  clip
   uri: add case flag in _clip_glob_match(), fixed all calls  this functions

   Revision 1.63  2001/06/07 09:52:26  clip
   uri:bugs

   Revision 1.62  2001/05/15 07:46:23  clip
   uri: memory leak in directory(), var empty not freeded

   Revision 1.61  2001/05/15 07:20:43  clip
   alena function("ls -l -|")

   Revision 1.60  2001/05/15 07:17:18  clip
   *** empty log message ***

   Revision 1.59  2001/05/04 10:29:25  clip
   params and locals
   paul

   Revision 1.58  2001/05/03 10:38:01  clip
   *** empty log message ***

   Revision 1.57  2001/04/29 12:55:20  clip
   uri: bug in directory() with mask "C:/ *"

   Revision 1.56  2001/04/16 13:41:49  clip
   serg: исправления в fopen в режимах share

   Revision 1.55  2001/04/15 11:25:07  clip
   serg: в fopen добавлены share режимы для блокировок

   Revision 1.54  2001/04/05 11:17:41  clip
   remake function round()

   Revision 1.53  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.52  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.51  2001/03/28 14:20:52  clip
   restScreen() with none parameters, file() with NIL parameter

   Revision 1.50  2001/03/22 16:00:53  clip
   bug in fwrite , new #define in dbinfo.ch

   Revision 1.49  2001/01/24 14:02:29  clip
   serg: подправлены блокировки файлов

   Revision 1.48  2001/01/24 13:14:46  clip
   serg: добавлена обработка блокировок на файлы

   Revision 1.47  2001/01/22 13:31:43  clip
   bugfixes
   paul

   Revision 1.46  2001/01/16 14:54:25  clip
   NONBLOCK in fopen()

   Revision 1.45  2001/01/16 10:12:02  clip
   alena: new function in _string.c clip_RGCOMP, clip_RGEXEC, clip_RGCANCEL

   Revision 1.44  2000/12/25 14:15:11  clip
   uri: gzip*() вынесены в отдельный файл, Makefile -> EXTOBJS

   Revision 1.43  2000/12/20 11:09:36  clip
   HAVE_ZLIB_H

   Revision 1.42  2000/12/19 10:07:39  clip
   uri: gzip* functions

   Revision 1.41  2000/12/02 12:46:56  clip
   scancodes
   paul

   Revision 1.40  2000/11/23 15:00:18  clip
   GETENV(NIL) теперь возвращает обЪект со значениями всех переменных окружения

   Revision 1.39  2000/11/23 09:35:10  clip
   INIT -> INI_ctools_diskfunc()

   Revision 1.38  2000/11/23 06:50:23  clip
   load(name [,array])
   paul

   Revision 1.37  2000/11/21 11:31:12  clip
   io
   paul

   Revision 1.36  2000/11/09 12:56:12  clip
   serg: fopen() small fix

   Revision 1.35  2000/11/08 13:49:42  clip
   serg: добавлена возможность работы с потоками в семейство fopen:
   fopen( "-|" ) - стандартный ввод
   fopen( "|-" ) - стандартный вывод
   fopen( "ls -l |" ) - на стандартном вводе вывод команды
   fopen( "| gzip > a.gz" ) - stdout через gzip складывается в файл.

   Revision 1.34  2000/10/27 07:50:17  clip
   rational NUMERIC_t gluks
   paul

   Revision 1.33  2000/10/16 09:51:05  clip
   create() remake as 'container'
   bug in fwrite()
   from uri:

   Revision 1.32  2000/08/31 12:46:33  clip
   *** empty log message ***

   Revision 1.31  2000/08/24 14:37:42  clip
   fflush, ftell, flength

   Revision 1.30  2000/08/24 14:12:42  clip
   serg: fileeof

   Revision 1.29  2000/08/24 13:54:23  clip
   serg: container, fopen, fread, fwrite, ...

   Revision 1.28  2000/08/14 11:40:03  clip
   small bug in filegetstr
   from uri:

   Revision 1.27  2000/08/14 10:55:19  clip
   small bug in FWRITE
   from uri:

   Revision 1.26  2000/07/06 19:56:08  clip
   uri: bug in tabpack
   from uri:

   Revision 1.25  2000/05/27 19:16:32  clip
   uri: small bugs in ferror()

   Revision 1.24  2000/05/27 18:29:26  clip
   uri: small bug in memoread

   Revision 1.23  2000/05/24 18:33:53  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.22  2000/05/23 23:05:36  clip
   uri: не помню чего ломал

   Revision 1.21  2000/05/20 18:37:22  clip
   change hash function
   append HASH_xxxx extraction into hashcode.h
   Paul Lasarev <paul@itk.ru>

   Revision 1.20  2000/05/16 19:21:44  clip
   uri: bug in FILE

   Revision 1.19  2000/05/16 02:24:03  clip
   small bug in alltrim

   Revision 1.18  2000/05/12 01:20:21  clip
   setfattr, filestr

   Revision 1.17  2000/05/11 22:02:50  clip
   uri: curdir translate "\\" to "/" in path

   Revision 1.16  2000/05/03 19:32:22  clip
   add prefix 'clip_' to all clip functions

   Revision 1.15  2000/04/30 19:29:38  clip
   size buffer for fread

   Revision 1.14  2000/04/30 18:26:45  clip
   #translate fix

   Revision 1.13  2000/04/27 22:55:43  clip
   freebsd fix

   Revision 1.12  2000/03/30 19:44:06  uri
   новый error

   Revision 1.11  2000/03/22 19:10:00  uri
   *** empty log message ***

   Revision 1.10  2000/03/17 20:41:37  serg
   *** empty log message ***

   Revision 1.9  1999/12/28 20:36:49  serg
   *** empty log message ***

   Revision 1.6  1999/12/09 21:19:20  uri
   убрал warnings и начал misc functions of tools

   Revision 1.5  1999/12/04 22:16:36  uri
   вычистил все предупреждения

   Revision 1.4  1999/12/04 20:08:26  uri
   убрал warning нового компилятора

   Revision 1.3  1999/10/26 19:11:08  paul
   start cvs logging

 */
#include "clip.h"
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <time.h>
#include <stdarg.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#ifndef OS_MINGW
	#include <sys/wait.h>
#endif
#include <sys/time.h>
#include <fcntl.h>
#include <dirent.h>
#include <limits.h>
#include "hash.h"
#include "hashcode.h"

#include "error.ch"
#include "fileio.ch"

#ifdef _WIN32
	#include <io.h>
#endif

#ifdef OS_CYGWIN
	#include <io.h>
	#include <w32api/windows.h>
	#include <sys/cygwin.h>
#endif


#include "ncp.h"

#ifdef USE_TASKS
#include "task/task.h"
#endif

typedef struct {
	off_t pos;
	int write;
	int fd;
} OneTaskLock;

typedef struct {
	OneTaskLock* locks;
	int count;
	int flockfd;
} TaskLock;

/* everytime buffering or not */
/* #define FILEIO_BUFFERING */

/* always read until buffer is full or timeout */
/* #define FILEIO_FULLREAD */

/* always write until whole buffer is flushed or timeout */
#define FILEIO_FULLWRITE


void
destroy_c_file(void *item)
{
	C_FILE *cf = (C_FILE *) item;

	if (cf == NULL )
		return;

	if ( cf->f != NULL )
	{
		fflush(cf->f);
		fclose(cf->f);
	}
	else if ( cf->type == FT_FILE )
		_clip_close(cf->cm,cf->hash,cf->fileno);
	else
		close(cf->fileno);

#ifndef OS_MINGW
	if (cf->pid > 0)
		waitpid(cf->pid, NULL, 0);
#endif
	/* TODO? it can hang up main clip process.
	   maybe some simple signal handler for caching children PIDs?
	   Under Linux you can set SIGCHLD to SIG_IGN and this signal
	   will be redirected to pid=1 process (init) or maybe we should
	   use timeout value from C_FILE, too?
	*/

	free(cf);
}

int
_set_lock(int fd, int l_type)
{
	struct flock fl;
	int r;

	fl.l_type = l_type;
	fl.l_whence = SEEK_SET;
	fl.l_start = 0x7fffffff;
	fl.l_len = 1;
#ifndef OS_MINGW
	fl.l_pid = 0;
#endif
	r = fcntl(fd, F_SETLK, &fl);

#ifdef USE_NCPFS
	if (r)
		return !r;
	r = ncp_openmode(fd, l_type == F_WRLCK ? 1 : 0);
#endif

	return !r;
}

/*
int _check_lock( int fd, int l_type )
{
	struct flock fl;
	fl.l_type = l_type;
	fl.l_whence = SEEK_SET;
	fl.l_start  = 0x7fffffff;
	fl.l_len = 1;
	fl.l_pid = 0;
	if ( fcntl( fd, F_GETLK, &fl ) != 0 || fl.l_type != F_UNLCK )
		return 1;

	return 0;
}
*/

int
_clip_creat(ClipMachine* cm,char *file, int flags, mode_t mode, int exclusive)
{
#ifndef OS_CYGWIN
	int fd, fl, lock;
	long hash = _clip_hashstr(file);
	int *fileopen;
	int* err = _clip_fetch_item(cm,HASH_ferror);

	*err = 0;

	fl = flags & ~(O_TRUNC|O_CREAT|O_EXCL);
	lock = exclusive?F_WRLCK:F_RDLCK;

	fd = open(file, fl);

	if (fd>=0)
	{
		fileopen = HashTable_fetch(cm->fileopens,hash);
		if(fileopen){
			(*fileopen)++;
		} else {
			fileopen = malloc(sizeof(int));
			*fileopen = 1;
			HashTable_store(cm->fileopens,fileopen,hash);
		}
		if(_clip_setlock(cm,hash,fd,0x7fffffff,
			(exclusive?CLIP_LOCK_WRITE:CLIP_LOCK_READ)))
		{
			_clip_close(cm,hash,fd);
			return -1;
		}
#ifdef USE_NCPFS
		if(ncp_openmode(fd, exclusive)){
			_clip_unlock(cm,hash,fd,0x7fffffff,0);
			_clip_close(cm,hash,fd);
			return -1;
		}
#endif
		_clip_unlock(cm,hash,fd,0x7fffffff,0);
		_clip_close(cm,hash,fd);
		unlink(file);
	}

	/* creat call work buggy on network filesystems...
	   druzus:
	   and this is important for secure reason, hacker can
	   create link form file to /any/other/important/file
	   so we always should use pair of functions:
	   unlink() and open(file, fl|O_EXCL, mode)
	 */
	unlink(file);
	fd = open(file, fl|O_CREAT|O_EXCL, mode);
	if(fd != -1){
		fileopen = HashTable_fetch(cm->fileopens,hash);
		if(fileopen){
			(*fileopen)++;
		} else {
			fileopen = malloc(sizeof(int));
			*fileopen = 1;
			HashTable_store(cm->fileopens,fileopen,hash);
		}
	}

	if (fd != -1)
	{
		if(_clip_setlock(cm,hash,fd,0x7fffffff,
			(exclusive?CLIP_LOCK_WRITE:CLIP_LOCK_READ)))
		{
			_clip_unlock(cm,hash,fd,0x7fffffff,0);
			_clip_close(cm,hash,fd);
			return -1;
		}
#ifdef USE_NCPFS
		if(ncp_openmode(fd, exclusive)){
			_clip_unlock(cm,hash,fd,0x7fffffff,0);
			_clip_close(cm,hash,fd);
			return -1;
		}
#endif
		errno = 0;
	}
	return fd;
#else
	HANDLE h;
	char* wp = malloc(PATH_MAX);
	int fd = -1;

	cygwin_conv_to_full_win32_path(file,wp);
	h = CreateFile(wp,GENERIC_READ|GENERIC_WRITE,
		exclusive?0:(FILE_SHARE_READ|FILE_SHARE_WRITE),
		NULL,
		CREATE_ALWAYS,
		FILE_ATTRIBUTE_NORMAL,
		NULL);
	setmode((int)h,O_BINARY);
	if(h==INVALID_HANDLE_VALUE){
		if(GetLastError()){
			free(wp);
			return -1;
		}
	}
	fd = cygwin_attach_handle_to_fd(wp,-1,h,1,0);
	free(wp);
	return fd;
#endif
}

int
_clip_open(ClipMachine* cm,char *file, int flags, mode_t mode, int exclusive)
{
#ifndef OS_CYGWIN
	int fd, fl;
	long hash = _clip_hashstr(file);
	int *fileopen;
	int* err = _clip_fetch_item(cm,HASH_ferror);

	*err = 0;

	if ( (flags & (O_CREAT|O_TRUNC)) == (O_CREAT|O_TRUNC) )
		return _clip_creat(cm,file, flags, mode, exclusive);

	/* 20031504 - fix for fopen(FO_TRUNC)
	fl = flags & ~(O_TRUNC|O_CREAT|O_EXCL);
	*/
	fl = flags & ~(O_CREAT|O_EXCL);

	fd = open(file, fl, mode);

	if (fd != -1)
	{
		fileopen = HashTable_fetch(cm->fileopens,hash);
		if(fileopen){
			(*fileopen)++;
		} else {
			fileopen = malloc(sizeof(int));
			*fileopen = 1;
			HashTable_store(cm->fileopens,fileopen,hash);
		}
		if(_clip_setlock(cm,hash,fd,0x7fffffff,
			(exclusive?CLIP_LOCK_WRITE:CLIP_LOCK_READ)))
		{
			_clip_close(cm,hash,fd);
			err = _clip_fetch_item(cm,HASH_ferror);
			*err = 32;
			return -1;
		}
#ifdef USE_NCPFS
		if(ncp_openmode(fd, exclusive)){
			_clip_unlock(cm,hash,fd,0x7fffffff,0);
			_clip_close(cm,hash,fd);
			return -1;
		}
#endif
		errno = 0;
	}
	if(fd == -1)
		*err = 2;
	return fd;
#else
	HANDLE h;
	char* wp = malloc(PATH_MAX);
	int fd = -1;
	DWORD access = GENERIC_READ | GENERIC_WRITE;

	if(flags & O_RDONLY)
		access &= ~GENERIC_WRITE;
	else if(flags & O_WRONLY)
		access &= ~GENERIC_READ;

	cygwin_conv_to_full_win32_path(file,wp);
	h = CreateFile(wp,access,
		exclusive?0:(FILE_SHARE_READ|FILE_SHARE_WRITE),
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL);
	setmode((int)h,O_BINARY);
	if(h==INVALID_HANDLE_VALUE){
		if(GetLastError()){
			free(wp);
			return -1;
		}
	}
	fd = cygwin_attach_handle_to_fd(wp,-1,h,1,0);
	free(wp);
	return fd;
#endif
}

int
_clip_close(ClipMachine *cm,long hash,int fd)
{
#ifndef OS_CYGWIN
	int *fileopen = HashTable_fetch(cm->fileopens,hash);
	int* err = _clip_fetch_item(cm,HASH_ferror);

	*err = 0;

	if(!fileopen)
		return -1;

	(*fileopen)--;
	if(!*fileopen){
		TaskLock* tl = HashTable_fetch(cm->tasklocks,hash);
		if(tl){
			if(tl->locks)
				free(tl->locks);
			HashTable_remove(cm->tasklocks,hash);
			free(tl);
		}
		HashTable_remove(cm->fileopens,hash);
		free(fileopen);
		_clip_unlock(cm,hash,fd,0x7fffffff,0);
	}
	return close(fd);
#else
	return close(fd);
#endif
}

/* TODO? the macros below are used in different files (eg. I copied it
   from screen.c - I think it is better to put all of them in one
   header file, isn't it? */

#define	timer_add(a, b, result)							  \
  do {										  \
	(result)->tv_sec = (a)->tv_sec + (b)->tv_sec;				  \
	(result)->tv_usec = (a)->tv_usec + (b)->tv_usec;				  \
	if ((result)->tv_usec >= 1000000)						  \
	  {										  \
	++(result)->tv_sec;							  \
	(result)->tv_usec -= 1000000;						  \
	  }										  \
  } while (0)

#define timer_sub(a, b, result) \
   do {                         \
	   (result)->tv_sec = (a)->tv_sec - (b)->tv_sec;     \
	   (result)->tv_usec = (a)->tv_usec - (b)->tv_usec;  \
	   if ((result)->tv_usec < 0) {                      \
		  --(result)->tv_sec;                        \
		  (result)->tv_usec += 1000000;              \
	   }                                                 \
   } while (0)


/* TODO? For native Windows port (no CygWin) this function should
   use different mechanism for differ type of handles, select()
   is a WinSock function and operates only on sockets. */
int
_clip_select(int n, fd_set *rfds, fd_set *wfds, fd_set *efds, struct timeval *tv)
{
	int ret;

	if (tv == NULL || (tv->tv_sec == 0 && tv->tv_usec == 0))
		ret = select(n, rfds, wfds, efds, tv);
	else
	{
		/* Linux decrease timeval struct in timeout parameter to
		   indicate how much time was left. Other system doesn't
		   do that so we have consider timeout to be undefined and
		   decrease it ourself. */
#if defined(HAVE_GETTIMEOFDAY) && !defined(OS_LINUX)
		struct timeval beg, end;
		gettimeofday(&beg, NULL);
		timer_add(&beg, tv, &end);
#endif

#ifdef USE_TASKS
		ret = task_select(n, rfds, wfds, efds, tv);
#else
		ret = select(n, rfds, wfds, efds, tv);
#endif

#ifndef OS_LINUX
		if ((ret == -1 && errno != EINTR) || ret == 0)
#else
		if (ret == -1 && errno != EINTR)
#endif
		{
			/* Bad handle, parameters error or out of memory,
			   in any of such cases we shouldn't wait longer
			   (or select finished with no event) */
			tv->tv_sec = tv->tv_usec = 0;
		}
#if defined(HAVE_GETTIMEOFDAY) && !defined(OS_LINUX)
		else
		{
			gettimeofday(&beg, NULL);
			timer_sub(&end, &beg, tv);
			if (tv->tv_sec < 0)
				tv->tv_sec = tv->tv_usec = 0;
		}
#endif
	}
	return ret;
}

int
_clip_read(C_FILE *cf, void *buf, size_t count)
{
	int n = 0, i = 0;

	errno = 0;
	if (count > 0)
	{
		fd_set rfds;
		struct timeval tv, *ptv = NULL;

		if (cf->timeout >= 0)
		{
			tv.tv_sec = cf->timeout / 1000;
			tv.tv_usec = (cf->timeout % 1000) * 1000;
			ptv = &tv;
		}

		do
		{
			if (ptv == NULL)
				i = 1;
			else
			{
				FD_ZERO(&rfds);
				FD_SET(cf->fileno, &rfds);

				i = _clip_select(cf->fileno+1, &rfds, NULL, NULL, ptv);

				if (i == 0 && (cf->type == FT_SOCKET ||
						   cf->type == FT_PIPE))
				{
					errno = EAGAIN;
					i = -1;
				}
			}
			if (i > 0)
			{
				i = read(cf->fileno, buf + n, count - n);
				if (i > 0)
				{
					n += i;
#ifndef FILEIO_FULLREAD
					break;
#endif
				}
				else if (i == 0 &&
					 (cf->type == FT_SOCKET ||
					  cf->type == FT_PIPE))
				{	/* if other side close a connection
					   (pipe or socket) select allow to
					   read but read() returns 0. It's
					   POSIX systems behavior, Windows
					   (WinSock) does not respect it.
					*/
					errno = EPIPE;
					i = -1;
				}
			}
			if (i == -1 && errno == EINTR)
				i = 1; /* operation interrupted by signal,
					  Let's try again, _clip_select
					  should decrease tv to avoid
					  infinite loop. */
		} while (i != -1 && i != 0 && n < count);

		if (i == -1 && errno == EPIPE)
			cf->stat |= FS_EOF;
	}
	return n > 0 ? n : i; /* POSIX allow to return -1 when some bytes
				 was read/written and then appear
				 error/interrupts(unblocked signal)
				 (it's undefined) but such behavior is
				 rather seldom and it complicates high level
				 code, so let's inform programmer about
				 bytes read/written even the whole operation
				 wasn't completed */
}

int
_clip_write(C_FILE *cf, void *buf, size_t count)
{
	int n = 0, i = 0;

	errno = 0;
	if (count > 0)
	{
		fd_set wfds;
		struct timeval tv, *ptv = NULL;

		if (cf->timeout >= 0)
		{
			tv.tv_sec = cf->timeout / 1000;
			tv.tv_usec = (cf->timeout % 1000) * 1000;
			ptv = &tv;
		}

		do
		{
			if (ptv == NULL)
				i = 1;
			else
			{
				FD_ZERO(&wfds);
				FD_SET(cf->fileno, &wfds);

				i = _clip_select(cf->fileno+1, NULL, &wfds, NULL, ptv);

				if (i == 0 && (cf->type == FT_SOCKET ||
						   cf->type == FT_PIPE))
				{
					errno = EAGAIN;
					i = -1;
				}
			}
			if (i > 0)
			{
				i = write(cf->fileno, buf + n, count - n);
				if (i > 0)
				{
					n += i;
#ifndef FILEIO_FULLWRITE
					break;
#endif
				}
			}
			if (i == -1 && errno == EINTR)
				i = 1; /* operation interrupted by signal,
					  Let's try again, _clip_select
					  should decrease tv to avoid
					  infinite loop. */
		} while (i != -1 && i != 0 && n < count);
	}
	return n > 0 ? n : i;
}

int
_clip_ftype(int fd)
{
	int retval = FT_ERROR;
	struct stat st;

	if (fstat(fd, &st) != -1)
	{
		if (S_ISREG(st.st_mode))
			retval = FT_FILE;
		else if (S_ISFIFO(st.st_mode))
			retval = FT_PIPE;
#ifndef OS_MINGW
		else if (S_ISSOCK(st.st_mode))
			retval = FT_SOCKET;
		else if (S_ISLNK(st.st_mode))
			retval = FT_LINK;
#endif
		else if (S_ISCHR(st.st_mode))
			retval = FT_CHARDEV;
		else if (S_ISBLK(st.st_mode))
			retval = FT_BLOCKDEV;
		else if (S_ISDIR(st.st_mode))
			retval = FT_DIRECTORY;
		else
			retval = FT_UNKNOWN;
		/*
		TODO: For native windows code we should check for other
		type of	handle
		Unimplemented so far:
		For COM_* function use FT_TERM
		For GZIP* -> FT_GZIP
		For BZIP2 -> FT_BZIP2
		It needs changes in clip-* libs.
		*/
	}
	return retval;
}

int
clip_INIT_FILE_SETS(ClipMachine * mp)
{
	C_FILE *cf = NULL;
	int fd;

	int *err;
	err = calloc(sizeof(int), 1);

	_clip_store_item(mp, HASH_ferror, err);
	err = calloc(sizeof(int), 1);

#ifdef _WIN32
	setmode(0,O_BINARY);
	setmode(1,O_BINARY);
#endif

	/*setvbuf(stdout, (char *)NULL, _IOFBF, 0);*/
	/* open stdin, stdout, stderr */
	for (fd = 0; fd < 3; fd++)
	{
		cf = (C_FILE *) calloc(1, sizeof(C_FILE));
		if (fd == 0)
			cf->f = stdin;
		else if (fd == 1)
			cf->f = stdout;
		else if (fd == 2)
			cf->f = stderr;
		cf->fileno = fd;
		cf->pid = -1;
		cf->type = _clip_ftype(fd);
		cf->timeout = -1;
		cf->stat = 0;
		_clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);
	}
	return 0;
}

int
clip_CURDIR(ClipMachine * mp)
{
	int i;
	char *dir, *disk = _clip_fetch_item(mp, CLIP_CUR_DRIVE);

	dir = _clip_fetch_item(mp, _hash_cur_dir[*disk - 65]);
	if (dir == NULL /* || *dir==0 */ )
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CURDIR: undefined or bad name of current disk");
	}
	for (i = 0; dir[i] != 0; i++)
		if (dir[i] == '\\')
			dir[i] = '/';
	if (*dir == '/')
		dir++;
	_clip_retc(mp, dir);
	return 0;
}

int
clip_CURRDRIVE(ClipMachine * mp)
{
	char *s = _clip_fetch_item(mp, CLIP_CUR_DRIVE);

	_clip_retc(mp, s ? s : "");
	return 0;
}

int
clip_STARTPATH(ClipMachine * mp)
{
	char buf[PATH_MAX];

	memset(buf,0,PATH_MAX);

	if (_clip_argv[0][0] == '/')
	{
		memcpy(buf, _clip_argv[0], strlen((char *) _clip_argv[0]));
	}
	else
	{
		getcwd(buf, sizeof(buf));
		memcpy(buf + strlen(buf) + 1, _clip_argv[0], strlen((char *) _clip_argv[0]) + 1);
		buf[strlen(buf)] = '/';
	}
#ifdef OS_CYGWIN
	{
	char ch[MAXPATHLEN];
	cygwin_posix_to_win32_path_list(buf,ch);
	_clip_retc(mp, ch);
	}
#else
	_clip_retc(mp, buf);
#endif
	return 0;
}

int
clip_EXENAME(ClipMachine * mp)
{
	return clip_STARTPATH(mp);
}

int
clip_FOPEN(ClipMachine * mp)
{
	FILE *f = NULL;
	C_FILE *cf = NULL;
	int fd = -1, ret = -1, *err = NULL;
	int mode = 0, share_mode = 0, type = FT_NONE;
	pid_t pid = -1;
	char buf[PATH_MAX];
	char *fmode = NULL, *fname = _clip_parc(mp, 1);
	int m = _clip_parni(mp, 2);
	int lbuf, lposix;

	share_mode = m & 0xfff8;
	m &= 7;		/* read/write access */

	lposix = ((share_mode & FO_POSIX) != 0 ||
		  (FOPENMODE_FLAG & mp->flags1) != 0);
		 /* set fopen mode to POSIX */

	if ((share_mode & FO_NOBUFF) != 0)
		lbuf = 1; /*((share_mode & FO_NOBUFF) != 0);*/
	else
	{
	if ((share_mode & FO_BUFFERED) != 0)
		lbuf = 0; /*((share_mode & FO_BUFFERED) != 0);*/
	else
		lbuf = ((BUFFERING_FLAG & mp->flags1) != 0);
	}

	_clip_translate_path(mp, fname, buf, sizeof(buf));

	switch (m)
	{
	case 0:
		mode = O_RDONLY;	/* это чтобы блокировки ниже могли работать */
/*mode = O_RDWR; *//* например при открытии файла на чтение */
		fmode = "r";	/* в exclusive ставится блокировка на */
		break;		/* запись, это коряво, но надо Юрке */
	case 1:
		mode = O_WRONLY;
		/*mode = O_RDWR; */
		fmode = "w";
		break;
	case 2:
		mode = O_RDWR;
		fmode = "r+";
		break;
	default:
		_clip_retni(mp, -1);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "FOPEN");
	}

	if (!strcmp(buf, "-|"))
	{			/* stdin */
		if (mode != O_RDONLY)
		{
			errno = EACCES;
			goto err;
		}
		fd = dup(0);
		type = FT_PIPE;
	}
	else if (!strcmp(buf, "|-"))
	{			/* stdout */
		if (mode != O_WRONLY)
		{
			errno = EACCES;
			goto err;
		}
		fd = dup(1);
		type = FT_PIPE;
	}
	else
	{
		int blen = strlen(buf);

		if (buf[0] == '|')
		{		/* output to child */
			if (mode != O_WRONLY)
			{
				errno = EACCES;
				goto err;
			}
			type = FT_PIPE;
			memmove(buf, buf + 1, blen);
		}
		else if (buf[blen - 1] == '|')
		{		/* input from child */
			mode = O_RDONLY;
			/*
			   if (mode != O_RDONLY)
			   {
			   errno = EACCES;
			   goto err;
			   }
			 */
			type = FT_PIPE;
			buf[blen - 1] = 0;
		}
	}

	if (type == FT_NONE)
		type = FT_FILE;


	if (fd == -1)
	{
#ifndef OS_MINGW
		if (type == FT_PIPE)
		{
			int pfd[2];

			if (pipe(pfd) == -1)
				goto err;

			if ((pid = fork()) == -1)
			{
				close(pfd[0]);
				close(pfd[1]);
				goto err;
			}
			else if (pid == 0)
			{	/* child */
				int i = 0;

				setuid(getuid());
				setgid(getgid());
				if (mode == O_WRONLY)
				{	/* input from parent */
					dup2(pfd[0], 0);
					close(pfd[0]);
				}
				else if (mode == O_RDONLY)
				{	/* output to parent */
					dup2(pfd[1], 1);
					dup2(pfd[1], 2);
					close(pfd[1]);
				}
				for (i = getdtablesize() - 1; i >= 3; i--)
					close(i);

				execlp("sh", "sh", "-c", buf, NULL);
				exit(0);
			}

			if (mode == O_WRONLY)
			{	/* output to child */
				close(pfd[0]);
				fd = pfd[1];
			}
			else if (mode == O_RDONLY)
			{	/* input from child */
				close(pfd[1]);
				fd = pfd[0];
			}
			if ((mode = fcntl(fd, F_GETFL, 0)) == -1)
				goto err;
			fcntl(fd, F_SETFL, mode | O_NONBLOCK);
		}
		else if (type == FT_FILE)
#else
		if (type == FT_FILE)
#endif
		{
#define FO_COMPAT	 0	/* Режим совместимости (по умолчанию) */
#define FO_EXCLUSIVE	16	/* Монопольное использование (Exclusive) */
#define FO_DENYWRITE	32	/* Предупреждение от записи другими процессами */
#define FO_DENYREAD	48	/* Предупреждение от чтения другими процессами */
#define FO_SHARED	64	/* Разрешение чтения и записи другими процессами */
#define FO_DENYNONE	64	/* (то же самое, что и FO_SHARED) */
			/*int l_type = F_WRLCK; */
			int l_type = -1;

			if (!lposix)
			{
				switch (share_mode & 0x70)
				{
				case FO_DENYREAD:
				case FO_EXCLUSIVE:
				case FO_DENYWRITE:
					l_type = F_WRLCK;
					break;
				case FO_COMPAT:
				case FO_SHARED:
					l_type = F_RDLCK;
					break;
				}
			}
#ifdef _WIN32
			mode |= ((share_mode & FO_TEXT) != 0) ? O_TEXT: O_BINARY;
#endif
			mode |= O_NONBLOCK;
			mode |= ((share_mode & FO_TRUNC) != 0) ? O_TRUNC: 0;

			fd = _clip_open(mp, buf, mode, 0, l_type == F_WRLCK);
		}
	}

	if (fd != -1)
	{
		if (lbuf)
		{
			if ((f = fdopen(fd, fmode)) == NULL)
				goto err;
		}
		if (type == FT_FILE && m == 1)	/* O_WRONLY */
		{
			if (lbuf)
				fseek(f, 0, SEEK_SET);
			else
				lseek(fd, 0, SEEK_SET);
		}
		cf = (C_FILE *) calloc(1, sizeof(C_FILE));
		cf->fileno = fd;
		cf->f = f;
		cf->stat = (lbuf ? FS_BUFFERED : 0);
		cf->type = _clip_ftype(fd);
		cf->pid = pid;
		cf->timeout = 0; /* (type == FT_FILE) ? 0 : -1; */
		cf->hash = _clip_hashstr(buf);
		cf->cm = mp;
		ret = _clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);
	}

	err:
	err = _clip_fetch_item(mp, HASH_ferror);
	if (ret != -1)
		*err = 0;
	else
	{
		*err = errno;
		if (f != NULL)
			fclose(f);
		else if (fd != -1)
			close(fd);
	}
	_clip_retni(mp, ret);

	return 0;
}

int
clip_FCREATE(ClipMachine * mp)
{
	FILE *f = NULL;
	C_FILE *cf = NULL;
	int fd = -1, ret = -1, *err = _clip_fetch_item(mp, HASH_ferror);
	char buf[PATH_MAX];
	char *fname = _clip_parc(mp, 1);
	int share_mode = _clip_parni(mp, 2);
	int lbuf; /*, lposix; */

	/* TODO: How to create file without locking?
	   We need to extend last param in _clip_creat for new mode
	 */
	/*
	lposix = ((share_mode & FO_POSIX) != 0 ||
		  (FOPENMODE_FLAG & mp->flags1) != 0);
	*/

	if ((share_mode & FO_NOBUFF) != 0)
		lbuf = 1; /*((share_mode & FO_NOBUFF) != 0);*/
	else
	{
	if ((share_mode & FO_BUFFERED) != 0)
		lbuf = 0; /*((share_mode & FO_BUFFERED) != 0);*/
	else
		lbuf = ((BUFFERING_FLAG & mp->flags1) != 0);
	}

	*err = 0;

	if (fname == NULL)
	{
		_clip_retni(mp, -1);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "FCREATE");
	}
	_clip_translate_path(mp, fname, buf, sizeof(buf));

	if ((fd = _clip_creat(mp, buf, O_RDWR|O_BINARY, mp->fileCreateMode, 1)) != -1 )
	{
		if (!lbuf || (f = fdopen(fd, "r+")) != NULL)
		{
			cf = (C_FILE *) calloc(1, sizeof(C_FILE));
			cf->type = _clip_ftype(fd);
			cf->fileno = fd;
			cf->f = f;
			cf->stat = (lbuf ? FS_BUFFERED : 0);
			cf->pid = -1;
			cf->timeout = 0;
			cf->hash = _clip_hashstr(buf);
			cf->cm = mp;
			ret = _clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);
		}
	}
	if (ret == -1)
	{
		*err = errno;
		if (fd != -1)
			close(fd);
	}
	_clip_retni(mp, ret);
	return 0;
}

int
clip_FCLOSE(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	int ret = -1, *err = _clip_fetch_item(mp, HASH_ferror);

	if (cf == NULL)
	{
		*err = EBADF;
	}
	else if (_clip_destroy_c_item(mp, fd, _C_ITEM_TYPE_FILE))
	{
		*err = 0;
		ret = 0;
	}

	_clip_retl(mp, (ret == 0));
	return 0;
}

int
clip_FILENO(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1), *err = _clip_fetch_item(mp, HASH_ferror);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL)
	{
		*err = EBADF;
		_clip_retni(mp, -1);
	}
	else
	{
		*err = 0;
		_clip_retni(mp,cf->fileno);
	}
	return 0;
}

int
clip_FTYPE(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1), *err = _clip_fetch_item(mp, HASH_ferror);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL)
	{
		*err = EBADF;
		_clip_retni(mp, -1);
	}
	else
	{
		*err = 0;
		_clip_retni(mp,cf->type);
	}
	return 0;
}

int
clip_FTIMEOUT(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1), *err = _clip_fetch_item(mp, HASH_ferror);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL)
	{
		*err = EBADF;
		_clip_retni(mp, -1);
	}
	else
	{
		*err = 0;
		_clip_retni(mp, cf->timeout);
		if (_clip_parinfo(mp, 2) == NUMERIC_t)
			cf->timeout = _clip_parni(mp, 2);
	}
	return 0;
}

int
_clip_fready(ClipMachine * mp, int rmode)
{
	int ret = -1, *err = _clip_fetch_item(mp, HASH_ferror);
	fd_set set;
	struct timeval tv;
	int fd = _clip_parni(mp, 1), timeout;
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	_clip_retl(mp, 0);

	if (cf == NULL)
	{
		*err = EBADF;
		return 0;
	}

	if (_clip_parinfo(mp, 2) == NUMERIC_t)
		timeout = _clip_parni(mp, 2);
	else
		timeout = cf->timeout;

	if (timeout < 0)
		timeout = 0;	/* TODO?: maybe we should set in such case
				   infinit timeout (&tv=NULL)? */

	fd = cf->fileno;

	FD_ZERO(&set);
	FD_SET(fd, &set);

	tv.tv_sec = timeout / 1000;
	tv.tv_usec = (timeout % 1000) * 1000;

	switch (rmode)
	{
	case 1:
		ret = _clip_select(fd + 1, &set, NULL, NULL, &tv);
		break;
	case 2:
		ret = _clip_select(fd + 1, NULL, &set, NULL, &tv);
		break;
	}

	*err = ret == -1 ? errno : 0;
	if (ret > 0)
		_clip_retl(mp, 1);

	return 0;
}

int
clip_FREADREADY(ClipMachine * mp)
{
	return _clip_fready(mp, 1);
}

int
clip_FWRITEREADY(ClipMachine * mp)
{
	return _clip_fready(mp, 2);
}

int
clip_FREAD(ClipMachine * mp)
{
#if 0
	int ret, *err, bl;
	int fh = _clip_parni(mp, 1);
	char *buf = _clip_parcl(mp, 2, &bl);
	int kol = _clip_parni(mp, 3);

	if (bl < kol)
		kol = bl;

	ret = read(fh, buf, kol);
	err = _clip_fetch_item(mp, HASH_ferror);

	if (ret < 0)
		*err = errno;
	else
		*err = 0;
#else
	int *err = _clip_fetch_item(mp, HASH_ferror);
	int fd = _clip_parni(mp, 1), lenbuf = 0;
	char *buf = _clip_parcl(mp, 2, &lenbuf);
	long ret = -1, nb = _clip_parnl(mp, 3);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	_clip_retnl(mp, -1);

	if (cf == NULL )
	{
		*err = EBADF;
		return 0;
	}

	if (lenbuf < nb)
		nb = lenbuf;

	if ( nb>0 )
	{
		if (cf->f == NULL || (cf->stat & FS_BUFFERED) == 0)
			ret = _clip_read(cf, buf, nb);
		else
			ret = fread(buf, 1, nb, cf->f);
	}
	else
		ret = 0;

	*err = ret < 0 ? errno : 0;
#endif

	_clip_retnl(mp, ret);
	return 0;
}

int
clip_FREADSTR(ClipMachine * mp)
{
#if 0
	int *err;
	int fh = _clip_parni(mp, 1);
	int kol = _clip_parni(mp, 2);
	char *buf = malloc(kol + 1);
	int ret = read(fh, buf, kol);

	if (ret >= 0)
	{
		buf[ret] = 0;
		_clip_retcn_m(mp, buf, ret);
	}
	else
		_clip_retc(mp, "");

	err = _clip_fetch_item(mp, HASH_ferror);

	if (ret < 0)
		*err = errno;
	else
		*err = 0;
#else
	int *err = _clip_fetch_item(mp, HASH_ferror);
	int fd = _clip_parni(mp, 1);
	long ret = -1, nb = _clip_parnl(mp, 2);
	char *buf;
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	_clip_retc(mp, "");

	if (cf == NULL )
	{
		*err = EBADF;
		return 0;
	}

	buf = malloc(nb + 1);
	if (cf->f == NULL || (cf->stat & FS_BUFFERED) == 0)
		ret = _clip_read(cf, buf, nb);
	else
		ret = fread(buf, 1, nb, cf->f);

	if (ret >= 0)
	{
		buf[ret] = 0;
		_clip_retc(mp, buf);
	}
	free(buf);

	*err = ret < 0 ? errno : 0;
#endif
	return 0;
}

int
clip_FILEGETSTR(ClipMachine * mp)
{
#if 0
	char *buf, *e;
	int *err;
	int h = _clip_parni(mp, 1);
	int kol = _clip_parni(mp, 2);
	int oldmesto = lseek(h, 0, SEEK_CUR);

	if (kol <= 0)
		kol = 256;

	buf = malloc(kol + 1);
	kol = read(h, buf, kol);

	err = _clip_fetch_item(mp, HASH_ferror);

	if (kol < 0)
		*err = errno;
	else
		*err = 0;

	if (kol < 0)
	{
		_clip_retc(mp, "");
		lseek(h, oldmesto, SEEK_SET);
		return 0;
	}
	for (e = buf; e < buf + kol && *e != '\n'; e++);
	if (e == buf + kol)
	{
		_clip_retcn_m(mp, buf, kol);
		return 0;
	}
	if (*(e - 1) == '\r')
	{
		*(e - 1) = 0;
		_clip_retcn_m(mp, buf, e - buf - 1);
		lseek(h, oldmesto + e - buf + 2, SEEK_SET);
		return 0;
	}
	*e = 0;
	_clip_retcn_m(mp, buf, e - buf);
	lseek(h, oldmesto + e - buf + 1, SEEK_SET);
#else
	int *err = _clip_fetch_item(mp, HASH_ferror);
	char *buf = NULL;
	int fd = _clip_parni(mp, 1);
	int i, c = 0, n = _clip_parni(mp, 2);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL)
	{
		*err = EBADF;
		_clip_retc(mp, "");
	}
	else
	{
		*err = 0;
		if (n <= 0)
			n = 256;
		buf = calloc(n + 1,1);
		if (cf->f == NULL || (cf->stat & FS_BUFFERED) == 0)
		{
			if (cf->type == FT_FILE)
			{
				int j;
				j = _clip_read(cf, buf, n);
				if (j < n)
					n = j;
				for(i = j = 0; j < n; )
				{
					c = *(buf + j++);
					if (c == '\n')
						break;
					if (c != '\r')
						*(buf + i++) = c;
				}
				if (n > 0 && j < n)
					lseek(cf->fileno, j - n, SEEK_CUR);
				else if (n == -1)
					*err = errno;
			}
			else
			{
				for (i = 0; i < n; )
				{
					if ( _clip_read(cf, buf+i, 1) <= 0 )
						break;
					c = *(buf + i);
					if (c == '\n')
						break;
					if (c != '\r')
						++i;
				}
			}
		}
		else
		{
/*
			if (fgets(buf, n + 1, cf->f) != NULL)
			{
				for (i = strlen(buf); i; )
				{
					c = *(buf + --i);
					if (c != EOF && c != '\n' && c != '\r')
						break;
				}
				*(buf + i) = '\0';
			}
*/
			for (i = 0; i < n;)
			{
				c = fgetc(cf->f);
				if ( c == EOF || c == '\n')
					break;
				if (c != '\r')
					buf[i++] = c;
			}
		}
		if (i > 0)
		{
			buf = (char *) realloc(buf, i + 1);
			_clip_retcn_m(mp, buf, i);
		}
		else
		{
			free(buf);
			_clip_retc(mp, "");
		}
	}
#endif
	return 0;
}

int
clip_FWRITE(ClipMachine * mp)
{
#if 0
	int ret, sl, *err;
	int h = _clip_parni(mp, 1);
	char *str = _clip_parcl(mp, 2, &sl);
	int kol = _clip_parni(mp, 3);

	if (kol <= 0)
		kol = sl;
	if (sl < kol)
		kol = sl;

	ret = write(h, str, kol);

	err = _clip_fetch_item(mp, HASH_ferror);

	if (ret < 0)
		*err = errno;
	else
		*err = 0;
	_clip_retni(mp, ret);
#else
	int *err = _clip_fetch_item(mp, HASH_ferror);
	int fd = _clip_parni(mp, 1), len = 0;
	char *buf = _clip_parcl(mp, 2, &len);
	long ret = -1, n = _clip_parnl(mp, 3);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (_clip_parinfo(mp,1) == UNDEF_t )
		fd = 1;

	cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	if (cf == NULL)
		*err = EBADF;
	else
	{
		if (_clip_parinfo(mp, 3) != NUMERIC_t)
			n = len;
		if (n > len)
			n = len;

		if (n <= 0)
			ret = 0;
		else
		{
			if (cf->f == NULL || (cf->stat & FS_BUFFERED) == 0)
				ret = _clip_write(cf, buf, n);
			else
				ret = fwrite(buf, 1, n, cf->f);
		}
		*err = ret < 0 ? errno : 0;
	}
	_clip_retnl(mp, ret);
#endif
	return 0;
}

int
clip_FWRITELN(ClipMachine * mp)
{
#if 0
	int ret = -1, sl, *err;
	int h = _clip_parni(mp, 1);
	char *str = _clip_parcl(mp, 2, &sl);
	int kol = _clip_parni(mp, 3);

	if (sl < kol)
		kol = sl;

	ret = write(h, str, kol);
	ret += write(h, "\n", 1);

	err = _clip_fetch_item(mp, HASH_ferror);

	if (ret < 0)
		*err = errno;
	else
		*err = 0;
#else
	int ret = -1, len = 0, *err = _clip_fetch_item(mp, HASH_ferror);
	int fd = _clip_parni(mp, 1);
	char *buf = _clip_parcl(mp, 2, &len);
	int n = _clip_parni(mp, 3);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL)
		*err = EBADF;
	else
	{
		if (n <= 0)
			n = len;
		if (len < n)
			n = len;

		if (cf->f == NULL || (cf->stat & FS_BUFFERED) == 0)
		{
			ret = _clip_write(cf, buf, n);
			if (ret == n)
				if (_clip_write(cf, "\n", 1) == 1)
					++ret;
		}
		else
		{
			ret = fwrite(buf, 1, n, cf->f);
			if(ret == n)
				if (fwrite("\n", 1, 1, cf->f) == 1)
					++ret;
		}
		*err = ret < 0 ? errno : 0;
	}
#endif
	_clip_retni(mp, ret);

	return 0;
}

int
clip_FFLUSH(ClipMachine * mp)
{
	int ret = 0, fd = _clip_parni(mp, 1);
	int *err = _clip_fetch_item(mp, HASH_ferror);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL)
		*err = EBADF;
	else
	{
		*err = 0;
		if (cf->f != NULL && (cf->stat & FS_BUFFERED) != 0)
		{
			if (fflush(cf->f) == 0)
				ret = 1;
			else
				*err = errno;
		}
		else
			ret = 1;
	}
	_clip_retl(mp, ret);
	return 0;
}

int
clip_FSEEK(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1);
	long nb = _clip_parnl(mp, 2);
	int whence = SEEK_SET, w = _clip_parni(mp, 3), *err, ret = -1;
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	err = _clip_fetch_item(mp, HASH_ferror);
	*err = 0;
	_clip_retnl(mp, -1);

	if (cf == NULL )
	{
		*err = EBADF;
		return 0;
	}
	else if (cf->type == FT_FIFO || cf->type == FT_SOCKET)
	{
		*err = ESPIPE;
		return 0;
	}

	switch (w)
	{
	case 0:
		whence = SEEK_SET;
		break;
	case 1:
		whence = SEEK_CUR;
		break;
	case 2:
		whence = SEEK_END;
		break;
	}
	if (cf->f==NULL || (cf->stat & FS_BUFFERED) == 0)
	{
		if ((ret = lseek(cf->fileno, nb, whence)) == -1)
			*err = errno;
	}
	else
	{
		if ((ret = fseek(cf->f, nb, whence)) == -1)
			*err = errno;
		else
			ret = ftell(cf->f);
	}
	_clip_retnl(mp, ret);
	return 0;
}

int
clip_FTRUNC(ClipMachine * mp)
{
	int *err = _clip_fetch_item(mp, HASH_ferror);
	int fd = _clip_parni(mp, 1), fno = -1;
	long len = _clip_parnl(mp,2);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL)
	{
		*err = EBADF;
		_clip_retl(mp, 0);
		return 0;
	}

	if (cf->f == NULL || (cf->stat & FS_BUFFERED) == 0)
		fno = cf->fileno;
	else
		fno = fileno(cf->f);

	if ( fno == -1)
	{
		*err = EBADF;
		_clip_retl(mp, 0);
		return 0;
	}

	if (_clip_parinfo(mp, 0) < 2)
		len = lseek(fno,0,SEEK_CUR);

	//if ( len > 0 )
	len = ftruncate(fno, len);

	*err = len < 0 ? errno : 0;

	_clip_retl(mp, len>=0 );
	return 0;
}

int
clip_FILEEOF(ClipMachine * mp)
{
	int ret = 1, fd = _clip_parni(mp, 1);
	int *err = _clip_fetch_item(mp, HASH_ferror);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	*err = 0;
	if (cf == NULL )
		*err = EBADF;
	else if (cf->type == FT_FIFO || cf->type == FT_SOCKET)
		ret = (cf->stat & FS_EOF) ? 1 : 0;
	else
	{
		if (cf->f == NULL || (cf->stat & FS_BUFFERED) == 0)
		{
			int i, j;
			i = lseek(cf->fileno, 0, SEEK_CUR);
			j = lseek(cf->fileno, 0, SEEK_END);
			ret = (i >= j);
			lseek(cf->fileno, i, SEEK_SET);
		}
		else
			ret = feof(cf->f) ? 1 : 0;
	}
	_clip_retl(mp, ret);
	return 0;
}

int
clip_FTELL(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1), *err = _clip_fetch_item(mp, HASH_ferror);
	long ret = -1;
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	_clip_retni(mp,ret);
	if (cf == NULL)
		*err = EBADF;
	else
	{
		if (cf->f == NULL || (cf->stat & FS_BUFFERED) == 0)
			ret = lseek(cf->fileno,0,SEEK_CUR);
		else
			ret = ftell(cf->f);

		*err = ret < 0 ? errno : 0;
	}
	_clip_retnl(mp, ret);
	return 0;
}

int
clip_FLOCKF(ClipMachine * mp)
{
	/*
	   ( nFhandle, nLckType, nSize ) -> nRet
	   where:
	   nLckType
	   0    FF_UNLCK        Unlock the whole file
	   1    FF_RDLCK        Lock for reading by currrent process,
	   prevents others from writing
	   2    FF_WRLCK        Lock for writing by current porcess,
	   prevents others from reading

	   nSize
	   is a positive byte count to be locked from the current position.
	   If omitted, or zero is specified, the rest of the file is locked
	   until end-of-file.

	   nRet
	   is set to zero, if the required locking is successful,
	   nonzero otherwise

	   (this syntax of FLOCKF is FlagShip compatible)
	 */

	int ret, l_type = 0, l_cmd = 0;
	int *err = _clip_fetch_item(mp, HASH_ferror);
	struct flock fl;
	int fd = _clip_parni(mp, 1);
	int type = _clip_parni(mp, 2);
	long size = _clip_parnl(mp, 3);
	C_FILE *cf;

	_clip_retni(mp, -1);
	if (_clip_parinfo(mp, 0) < 2)
	{
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "FLOCKF");
	}

	cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL)
	{
		*err = EBADF;
		return 0;
	}
	else if (cf->type == FT_FIFO || cf->type == FT_SOCKET)
	{
		*err = ESPIPE;
		return 0;
	}

	l_cmd = (type == 0 ? F_UNLCK : F_SETLK);
	l_type = (type == 1 ? F_RDLCK : F_WRLCK);
	if (size == 0)
		size = 0xFFFFFFFF;

	fl.l_type = l_type;
	fl.l_whence = SEEK_SET;
	fl.l_start = lseek(cf->fileno, 0, SEEK_CUR);
	fl.l_len = size;
#ifndef OS_MINGW
	fl.l_pid = 0;
#endif
	ret = fcntl(cf->fileno, l_cmd, &fl);

	*err = ret == -1 ? errno : 0;
	_clip_retni(mp, ret);
	return 0;
}

int
clip_FLENGTH(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1), *err = _clip_fetch_item(mp, HASH_ferror);
	long ret = -1;
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	struct stat st;

	if (cf == NULL)
		*err = EBADF;
	else
	{
		if (fstat(cf->fileno, &st) == 0)
			ret = st.st_size;
		else
			*err = errno;
	}
	_clip_retnl(mp, ret);
	return 0;
}

int
clip_FERASE(ClipMachine * mp)
{
	int ret, *err = _clip_fetch_item(mp, HASH_ferror);
	char buf[PATH_MAX];
	char *fname = _clip_parc(mp, 1);

	if (fname == NULL)
	{
		_clip_retni(mp, -1);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "FERASE");
	}
	_clip_translate_path(mp, fname, buf, sizeof(buf));

#if 1
	/* I think I know what you wanted to do but this is very
	   dangerous. POSIX defined that if process close a file
	   all locks set by this process are removed. Kernel recognize
	   locks by pair INODE & PID not by file handle. It means that
	   if you run FERASE() on file which is opened database by
	   the same process you remove all locks made by RDD :-(.
	   The same happened if you try to remove any link
	   (soft or hard) to this file.
	 */
	{
	int fd;

	fd = _clip_open(mp,buf,O_RDWR,0,1);
	if (fd < 0)
	{
		*err = errno;
		_clip_retni(mp, -1);
		return 0;
	}
	_clip_close(mp,_clip_hashstr(buf),fd);
	}
#endif

	ret = unlink(buf);

	if (ret == -1)
		*err = errno;
	else
		*err = 0;
	_clip_retni(mp, ret);
	return 0;
}

int
clip_FRENAME(ClipMachine * mp)
{
	int ret, *err;
	char buf1[PATH_MAX];
	char buf2[PATH_MAX];
	char *fname1 = _clip_parc(mp, 1);
	char *fname2 = _clip_parc(mp, 2);

	if (fname1 == NULL || fname2 == NULL)
	{
		_clip_retni(mp, -1);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "FRENAME");
	}
	_clip_translate_path(mp, fname1, buf1, sizeof(buf1));
	_clip_translate_path(mp, fname2, buf2, sizeof(buf1));
	ret = rename(buf1, buf2);

	err = _clip_fetch_item(mp, HASH_ferror);

	if (ret < 0)
		*err = errno;
	else
		*err = 0;

	_clip_retni(mp, ret);
	return 0;
}

int
clip_GETENV(ClipMachine * mp)
{
	ClipVar *rp;
	char *str = _clip_parc(mp, 1);
	int i = 0;

	if (str)
	{
		_clip_retc(mp, _clip_getenv(str));
	}
	else
	{
		rp = RETPTR(mp);
		_clip_map(mp, rp);
		while (_clip_envp[i])
		{
			int l;
			char *s = _clip_envp[i];

			l = strcspn(s, "=");
			_clip_mputc(mp, rp, _clip_casehashbytes(0, s, l), s + l + 1, strlen(s + l + 1));
			i++;
		}
	}
	return 0;
}

int
clip_GETE(ClipMachine * mp)
{
	return clip_GETENV(mp);
}

int
clip_PUTENV(ClipMachine * mp)
{
	char *str = _clip_parc(mp, 1);

	if (str)
	{
		_clip_retni(mp, _clip_putenv(str));
	}
	return 0;
}

int
_clip_parse_path(char *fullpath, char *path, char *name)
{
	int len, i, j;

	len = strlen(fullpath);
	for (i = len; i >= 0 && fullpath[i] != '/' && fullpath[i] != '\\' && fullpath[i] != ':'; i--);
	for (j = i + 1; j <= len; j++)
		name[j - i - 1] = fullpath[j];
	if (i == 0)
	{
		path[0] = fullpath[0];
		path[1] = 0;
	}
	else if (i > 0)
	{
#ifdef _WIN32
		if ( (i>1 && fullpath[i-1]==':' && fullpath[i]=='\\') || fullpath[i]==':' )
			i++;
#endif
		path[i] = 0;
		for (i--; i >= 0; i--)
			path[i] = fullpath[i];
		i++;
	}
	else
		path[0] = 0;
	return i;
}

int
clip_PARSEFILEPATH(ClipMachine * mp)
{
	char *path;
	char name[PATH_MAX];
	char *fullpath = _clip_parc(mp, 1);

	if (_clip_parinfo(mp, 1) != 1)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "PARSEFILEPATH");
	}
	path = malloc(PATH_MAX);

	_clip_parse_path(fullpath, path, name);
	_clip_retcn_m(mp, path, strlen(path));
	return 0;
}

int
clip_PARSEFILENAME(ClipMachine * mp)
{
	char *name;
	char path[PATH_MAX];
	char *fullpath = _clip_parc(mp, 1);

	if (_clip_parinfo(mp, 1) != 1)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "PARSEFILENAME");
	}
	name = malloc(PATH_MAX);

	_clip_parse_path(fullpath, path, name);
	_clip_retcn_m(mp, name, strlen(name));
	return 0;
}

int
clip_ISPRINTER(ClipMachine * mp)
{
	_clip_retl(mp, 1);
	return 0;
}

int
clip_OS(ClipMachine * mp)
{
	_clip_retc(mp, OSNAME);
	return 0;
}

int
clip_MAKEPATH(ClipMachine * mp)
{
	char *path = _clip_parc(mp, 1);

	if (path)
	{
		char buf[PATH_MAX];

		_clip_translate_path(mp, path, buf, sizeof(buf));
		_clip_retc(mp, buf);
	}
	return 0;
}

int
clip_MEMOREAD(ClipMachine * mp)
{
	unsigned mode = 0;
	char buf[PATH_MAX];
	int fh, *err;
	char *ret;
	long len;
	char *fname = _clip_parc(mp, 1);

	if (fname == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "MEMOREAD");
	}
	_clip_translate_path(mp, fname, buf, sizeof(buf));
	mode |= O_RDONLY;
	fh = _clip_open(mp, buf, mode, 0, mode != O_RDONLY);

	err = _clip_fetch_item(mp, HASH_ferror);
	if (fh < 0)
	{
		*err = errno;
		close(fh);
		fh = -1;
	}
	else
	{
		*err = 0;
	}
	if (fh < 0)
	{
		_clip_retc(mp, "");
		return 0;
	}
	len = lseek(fh, 0, SEEK_END);
	lseek(fh, 0, SEEK_SET);
	ret = malloc(len + 1);
	len = read(fh, ret, len);

	if (len < 0)
		*err = errno;
	else
		*err = 0;
	_clip_close(mp,_clip_hashstr(buf),fh);
	if (len <= 0)
	{
		free(ret);
		_clip_retc(mp, "");
		return 0;
	}
	if (len > 1 && ret[len - 1] == 0x1A)	/* Ctrl+Z */
		len--;
	ret[len] = 0;
	_clip_retcn_m(mp, ret, len);
	return 0;
}

int
clip_MEMOWRIT(ClipMachine * mp)
{
	mode_t mode = mp->fileCreateMode;
	char buf[PATH_MAX];
	int len, fh = -1, *err = _clip_fetch_item(mp, HASH_ferror);
	char *fname = _clip_parc(mp, 1);
	char *str = _clip_parcl(mp, 2, &len);

	if (fname == NULL || str == NULL)
	{
		_clip_retl(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "MEMOWRIT");
	}
	_clip_translate_path(mp, fname, buf, sizeof(buf));

	fh = _clip_creat(mp, buf, O_WRONLY, mode, 1);
	if (fh < 0)
	{
		*err = errno;
		_clip_retl(mp, 0);
		return 0;
	}
	else
	{
		*err = 0;
	}
	len = write(fh, str, len);

	err = _clip_fetch_item(mp, HASH_ferror);

	if (len < 0)
		*err = errno;
	else
		*err = 0;
	_clip_close(mp,_clip_hashstr(buf),fh);
	close(fh);
	if (len < 0)
	{
		*err = errno;
		_clip_retl(mp, 0);
		return 0;
	}
	_clip_retl(mp, 1);
	return 0;
}

int
clip_FERROR(ClipMachine * mp)
{
	int *err;

	err = _clip_fetch_item(mp, HASH_ferror);
	_clip_retni(mp, *err);
	return 0;
}

int
clip_FERRORSTR(ClipMachine * mp)
{
	int *err;

	err = _clip_fetch_item(mp, HASH_ferror);
	_clip_retc(mp, strerror(*err));
	return 0;
}

int
clip_DOSERROR(ClipMachine * mp)
{
	/*_clip_retni(mp, errno);*/
	_clip_retni(mp,0);
	return 0;
}

int
clip_FILE(ClipMachine * mp)
{
	char **paths;
	const char *filename = _clip_parc(mp, 1);
	int *err = _clip_fetch_item(mp, HASH_ferror);
	char p[PATH_MAX], fn[PATH_MAX];
	char fullname[PATH_MAX + 1];
	const char *s, *s1 = NULL;
	int npaths = 0, i;
	int ret = 0;
	char *c, *c1;
	char *fname;
	struct dirent *dirp = NULL;
	struct stat statbuf;
	DIR *dirh;


	if (filename == NULL || *filename == 0)
	{
		_clip_retl(mp, 0);
		return 0;
	}

	paths = malloc(sizeof(char *));

	if ( strlen(filename)>2 && filename[1]==':' && filename[2] !='/' && filename[2] !='\\' )
	{
		/* drive with default path */
		char * def_path;
		def_path = _clip_fetch_item(mp, _hash_cur_dir[ toupper(*filename)-65 ]);
		snprintf(fn,PATH_MAX,"%c:%s/%s",*filename,def_path,filename+2);
	}
	else
	{
		strncpy(fn,filename,PATH_MAX-1);
	}
	if ((s = strrchr(fn, '\\')) || (s1 = strrchr(fn, '/')))
	{
		if (!s1)
			s1 = strrchr(fn, '/');
		s = (s > s1) ? s : s1;
		paths[0] = malloc(s - fn + 1);
		memcpy(paths[0], fn, s - fn);
		paths[0][s - fn] = 0;
		npaths++;
		fname = strdup(s + 1);
	}
	else
	{
		paths[0] = strdup(mp->defaul);
		npaths++;
		strncpy(p, mp->path, sizeof(p) - 1);
		c1 = p;
		do
		{
			c = strchr(c1, ';');
			if (c)
			{
				*c = 0;
			}
			else
			{
				c = strchr(c1, ',');
				if (c)
					*c = 0;
			}
			paths = realloc(paths, sizeof(char *) * (npaths + 1));

			paths[npaths] = strdup(c1);
			npaths++;
			c1 = c + 1;
		}
		while (c);
		fname = strdup(fn);
	}
	_clip_unix_path(fname, mp->flags & TRANSLATE_FLAG);

	for (i = 0; i < npaths; i++)
	{
		_clip_absolute_path(mp, paths[i], p, sizeof(p));

		dirh = opendir(p);

		if (dirh == NULL)
			*err = errno;
		else
			*err = 0;

		if (dirh != NULL)
			dirp = readdir(dirh);
		while (dirh != NULL && dirp != NULL)
		{
#ifdef _WIN32
			if (_clip_glob_match(dirp->d_name, fname, 1) > 0)
#else
			if (_clip_glob_match(dirp->d_name, fname, 0) > 0)
#endif
			{
				snprintf(fullname, sizeof(fullname), "%s%s", p, dirp->d_name);
				stat(fullname, &statbuf);
				if (!(S_ISDIR(statbuf.st_mode)))
				{
					ret = 1;
					break;
				}
			}
			dirp = readdir(dirh);
		}
		if (dirh != NULL)
			closedir(dirh);
		if (ret == 1)
			break;
	}

	for (i = 0; i < npaths; i++)
		free(paths[i]);
	free(paths);
	free(fname);
	_clip_retl(mp, ret);
	return 0;
}

int
clip_DIRECTORY(ClipMachine * mp)
{
	char *str = _clip_parc(mp, 1);
	char *attr = _clip_parc(mp, 2);
	int i, *err, flag_dir = 0;
	char buf[PATH_MAX];
	char dirn[PATH_MAX + 1];
	char filen[PATH_MAX + 1];
	char fullname[PATH_MAX + 1];
	char buftime[9];
	struct dirent *dirp;
	struct stat statbuf;
	DIR *dirh;
	ClipVar var, *empty;
	ClipVar *rp = RETPTR(mp);
	struct tm *sysTime;

	long vect[2];

	vect[0] = 0;
	vect[1] = 0;
	_clip_array(mp, rp, 1, vect);

	if (attr == NULL || strlen(attr) == 0)
		/*     flag_dir = 1 */ ;
	else
	{
		for (i = 0; i < strlen(attr) && !flag_dir; i++)
			flag_dir = (attr[i] == 'D');
	}

	if (str == NULL || strlen(str) == 0)
	{
		strcpy(filen, "*.*");
		getcwd(dirn, sizeof(dirn));
	}
	else
	{
		_clip_translate_path(mp, str, buf, sizeof(buf));
		i = _clip_parse_path(buf, dirn, filen);
#ifdef _WIN32
		if (i < 0)
			GetCurrentDirectory(PATH_MAX, dirn);
#else
		if (i < 0)
			getcwd(dirn, sizeof(dirn));
#endif
	}
	dirh = opendir(*dirn == 0 ? "/" : dirn);

	err = _clip_fetch_item(mp, HASH_ferror);

	if (dirh == NULL)
		*err = errno;
	else
		*err = 0;

	if (dirh == NULL)
	{
		return 0;
	}
	dirp = readdir(dirh);
	i = 0;
	while (dirp != NULL)
	{
#ifdef _WIN32
		if (_clip_glob_match(dirp->d_name, filen, 1) <= 0)
#else
		if (_clip_glob_match(dirp->d_name, filen, 0) <= 0)
#endif
		{
			dirp = readdir(dirh);
			continue;
		}
		snprintf(fullname, sizeof(fullname), "%s/%s", dirn, dirp->d_name);
		stat(fullname, &statbuf);
		if (S_ISDIR(statbuf.st_mode) && !flag_dir)
		{
			dirp = readdir(dirh);
			continue;
		}
		empty = malloc(sizeof(ClipVar));
		vect[0] = 5;
		_clip_array(mp, empty, 1, vect);
		vect[0] = i + 1;
		_clip_asize(mp, rp, 1, vect);
		vect[0] = i;
		_clip_aset(mp, rp, empty, 1, vect);

		vect[1] = 0;
		memset(&var, 0, sizeof(ClipVar));
		var.t.type = CHARACTER_t;
		var.s.str.buf = dirp->d_name;
		var.s.str.len = strlen(dirp->d_name);
		_clip_aset(mp, rp, &var, 2, vect);

		memset(&var, 0, sizeof(ClipVar));
		var.t.type = NUMERIC_t;
		var.t.memo = 0;
		var.n.d = statbuf.st_size;
		vect[1] = 1;
		_clip_aset(mp, rp, &var, 2, vect);

		memset(&var, 0, sizeof(ClipVar));

		sysTime = localtime(&statbuf.st_mtime);
		var.t.type = DATE_t;
		var.d.julian = _clip_jdate(sysTime->tm_mday, sysTime->tm_mon + 1, sysTime->tm_year + 1900);
		vect[1] = 2;
		_clip_aset(mp, rp, &var, 2, vect);

		memset(&var, 0, sizeof(ClipVar));
		snprintf(buftime, 9, "%02d:%02d:%02d", sysTime->tm_hour, sysTime->tm_min, sysTime->tm_sec);
		var.t.type = CHARACTER_t;
		var.s.str.buf = buftime;
		var.s.str.len = 8;
		vect[1] = 3;
		_clip_aset(mp, rp, &var, 2, vect);

		memset(&var, 0, sizeof(ClipVar));
		buftime[1] = 0;
		if (S_ISDIR(statbuf.st_mode))
			buftime[0] = 'D';
		else
			buftime[0] = 'A';
		var.t.type = CHARACTER_t;
		var.s.str.buf = buftime;
		var.s.str.len = 1;
		vect[1] = 4;
		_clip_aset(mp, rp, &var, 2, vect);
		_clip_destroy(mp,empty);
		free(empty);

		dirp = readdir(dirh);
		i++;
	}
	closedir(dirh);

	return 0;
}

int
_clip_fileStrModeToNumMode(char *mode)
{
	int ret = 0;
	int tmp, m1, m2, m3;

	/* user access mode */
	tmp = *mode - '0';
	m1 = tmp & 0x0001;
	tmp = tmp >> 1;
	m2 = tmp & 0x0001;
	tmp = tmp >> 1;
	m3 = tmp & 0x0001;
	if (m1)
		ret += S_IEXEC;
	if (m2)
		ret += S_IWRITE;
	if (m3)
		ret += S_IREAD;

#ifndef OS_MINGW
	/* group access mode */
	tmp = *(mode + 1) - '0';
	m1 = tmp & 0x0001;
	tmp = tmp >> 1;
	m2 = tmp & 0x0001;
	tmp = tmp >> 1;
	m3 = tmp & 0x0001;
	if (m1)
		ret += S_IXGRP;
	if (m2)
		ret += S_IWGRP;
	if (m3)
		ret += S_IRGRP;

	/* other access mode */
	tmp = *(mode + 2) - '0';
	m1 = tmp & 0x0001;
	tmp = tmp >> 1;
	m2 = tmp & 0x0001;
	tmp = tmp >> 1;
	m3 = tmp & 0x0001;
	if (m1)
		ret += S_IXOTH;
	if (m2)
		ret += S_IWOTH;
	if (m3)
		ret += S_IROTH;
#endif
	return ret;
}

static int _clip_wrlock(HashTable* locks,long hash,int fd,struct flock* fl,int lowlevel){
	int i;
	TaskLock* tl = HashTable_fetch(locks,hash);
	OneTaskLock* lck;
	int flock = (fl->l_len != 1);

	if(flock){
		if(tl && tl->flockfd){
			if(tl->flockfd == fd)
				return 1;
			return 0;
		}
		if(!fcntl(fd,F_SETLK,fl)){
			tl->flockfd = fd;
			return 1;
		}
		return 0;
	}
	if(tl && tl->flockfd && !lowlevel)
		return (fd == tl->flockfd);

	if(!tl){
		if(!fcntl(fd,F_SETLK,fl)){
			tl = calloc(1,sizeof(TaskLock));
			tl->count = 1;
			lck = tl->locks = calloc(1,sizeof(OneTaskLock));
			lck->pos = fl->l_start;
			lck->write = 1;
			lck->fd = fd;
			HashTable_store(locks,tl,hash);
			return 1;
		}
		return 0;
	}
	for(i=0;i<tl->count;i++){
		lck = tl->locks+i;
		if(lck->pos == fl->l_start){
			if(lck->fd == fd){
				if(lck->write){
					return 1;
				} else {
					if(!fcntl(fd,F_SETLK,fl)){
						lck->write = 1;
						return 1;
					}
					return 0;
				}
			} else {
				return 0;
			}
		}
	}
	if(!fcntl(fd,F_SETLK,fl)){
		tl->count++;
		tl->locks = realloc(tl->locks,sizeof(OneTaskLock)*tl->count);
		lck = tl->locks + tl->count - 1;
		lck->pos = fl->l_start;
		lck->write = 1;
		lck->fd = fd;
		return 1;
	}
	return 0;
}

static int _clip_rdlock(HashTable* locks,long hash,int fd,struct flock* fl,int lowlevel){
	int i;
	TaskLock* tl = HashTable_fetch(locks,hash);
	OneTaskLock* lck;

	if(tl && tl->flockfd && !lowlevel)
		return (fd == tl->flockfd);

	if(!tl){
		if(!fcntl(fd,F_SETLK,fl)){
			tl = calloc(1,sizeof(TaskLock));
			tl->count = 1;
			lck = tl->locks = calloc(1,sizeof(OneTaskLock));
			lck->pos = fl->l_start;
			lck->write = 0;
			lck->fd = fd;
			HashTable_store(locks,tl,hash);
			return 1;
		}
		return 0;
	}
	for(i=0;i<tl->count;i++){
		lck = tl->locks+i;
		if(lck->pos == fl->l_start){
			if(lck->fd == fd){
				if(!lck->write){
					return 1;
				} else {
					if(!fcntl(fd,F_SETLK,fl)){
						lck->write = 0;
						return 1;
					}
					return 0;
				}
			} else {
				if(lck->write)
					return 0;
			}
		}
	}
	if(!fcntl(fd,F_SETLK,fl)){
		tl->count++;
		tl->locks = realloc(tl->locks,sizeof(OneTaskLock)*tl->count);
		lck = tl->locks + tl->count - 1;
		lck->pos = fl->l_start;
		lck->write = 0;
		lck->fd = fd;
		return 1;
	}
	return 0;
}

int _clip_setlock(ClipMachine* cm,long hash,int fd,off_t pos,int flags){
	int ok = 0;
	struct flock fl;

	fl.l_type = (flags & CLIP_LOCK_WRITE)?F_WRLCK:F_RDLCK;
	fl.l_whence = SEEK_SET;
	fl.l_start = pos;
	fl.l_len = (flags & CLIP_LOCK_FLOCK)?pos-1:1;

	while(1){
		if(fl.l_type == F_WRLCK)
			ok = _clip_wrlock(cm->tasklocks,hash,fd,&fl,
				!(flags & CLIP_LOCK_HILEVEL));
		else
			ok = _clip_rdlock(cm->tasklocks,hash,fd,&fl,
				!(flags & CLIP_LOCK_HILEVEL));

		if(ok || !(flags & CLIP_LOCK_WAIT))
			break;
		Task_sleep(1);
	}
	return !ok;
}

int _clip_unlock(ClipMachine* cm,long hash,int fd,off_t pos,int flags){
	int i;
	TaskLock* tl = HashTable_fetch(cm->tasklocks,hash);
	OneTaskLock* lck;
	struct flock fl;

	fl.l_type = F_UNLCK;
	fl.l_whence = SEEK_SET;
	fl.l_start = pos;
	fl.l_len = (flags & CLIP_LOCK_FLOCK)?pos-1:1;

	if(flags & CLIP_LOCK_FLOCK){
		if(tl && tl->flockfd != fd)
			return 0;
		if(!fcntl(fd,F_SETLK,&fl)){
			tl->flockfd = 0;
			return 0;
		}
		return 1;
	}
	if(!tl)
		return 0;
	for(i=0;i<tl->count;i++){
		lck = tl->locks+i;
		if(lck->pos == fl.l_start){
			if(lck->fd == fd){
				if(!fcntl(fd,F_SETLK,&fl)){
					memmove(tl->locks+i,tl->locks+i+1,(tl->count-i-1)*sizeof(OneTaskLock));
					tl->count--;
					tl->locks = realloc(tl->locks,tl->count*sizeof(OneTaskLock));
					i--;
				}
			}
		}
	}
	return 0;
}
