/*
	Copyright (C) 2001  ITK
	Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>, Sergey Rosenfeld <serg@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log: _file.c,v $
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
#include <sys/wait.h>
#include <sys/time.h>
#include <fcntl.h>
#include <dirent.h>
#include <limits.h>
#include "hashcode.h"

#include "clip.h"
#include "error.ch"
#include "fileio.ch"

#ifdef OS_CYGWIN
	#include <io.h>
#endif

#include "ncp.h"

/* everytime buffering or not */
/* #define FILEIO_BUFFERING */

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
        else
        	close(cf->fileno);


	if (cf->pid > 0)
		waitpid(cf->pid, NULL, 0);

	free(cf);
}

int
clip_INIT_FILE_SETS(ClipMachine * mp)
{
	C_FILE *cf = NULL;
#ifdef FILEIO_BUFFERING
	int fd;
	FILE *f = NULL;
#endif
	int *err;
	err = calloc(sizeof(int), 1);

	_clip_store_item(mp, HASH_ferror, err);
	err = calloc(sizeof(int), 1);

	_clip_store_item(mp, HASH_neterror, err);

	/* open stdin */
#ifdef OS_CYGWIN
	setmode(0,O_BINARY);
	setmode(1,O_BINARY);
#endif

	cf = (C_FILE *) calloc(1, sizeof(C_FILE));
#ifdef FILEIO_BUFFERING
	fd = dup(0);
	f = fdopen(fd, "r");
	cf->f = f;
        cf->mode = 1;
#endif
        cf->type = FT_STREAM;
        cf->fileno = 0;
	cf->pid = -1;
	_clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);

	/* open stdout */
	cf = (C_FILE *) calloc(1, sizeof(C_FILE));
#ifdef FILEIO_BUFFERING
	fd = dup(1);
	f = fdopen(fd, "a");
	cf->f = f;
        cf->mode = 1;
#endif
        cf->type = FT_STREAM;
        cf->fileno = 1;
	cf->pid = -1;
	_clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);

	/* open stderr */
	cf = (C_FILE *) calloc(1, sizeof(C_FILE));
#ifdef FILEIO_BUFFERING
	fd = dup(2);
	f = fdopen(fd, "a");
	cf->f = f;
        cf->mode = 1;
#endif
        cf->type = FT_STREAM;
        cf->fileno = 2;
	cf->pid = -1;
	_clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);
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
	_clip_retc(mp, buf);
	return 0;
}

int
clip_EXENAME(ClipMachine * mp)
{
	return clip_STARTPATH(mp);
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

	int ret, l_type = 0, l_cmd = 0, *err = NULL;
	struct flock fl;
	int fd = _clip_parni(mp, 1);
	int type = _clip_parni(mp, 2);
	long size = _clip_parnl(mp, 3);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (_clip_parinfo(mp, 0) < 2 || cf == NULL || cf->f == NULL)
	{
		_clip_retni(mp, -1);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "FLOCKF");
	}

	fd = cf->fileno;

	l_cmd = (type == 0 ? F_UNLCK : F_SETLK);
	l_type = (type == 1 ? F_RDLCK : F_WRLCK);
	if (size == 0)
		size = 0xFfffffff;

	fl.l_type = l_type;
	fl.l_whence = SEEK_SET;
        if ( cf->f== NULL || cf->mode == 0 )
		fl.l_start = lseek(cf->fileno,0,SEEK_CUR);
        else
		fl.l_start = ftell(cf->f);

	fl.l_len = size;
	fl.l_pid = 0;
	ret = fcntl(fd, l_cmd, &fl);

	err = _clip_fetch_item(mp, HASH_ferror);
	*err = ret < 0 ? errno : 0;

	_clip_retni(mp, ret);
	return 0;
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
	fl.l_pid = 0;
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
clip_FOPEN(ClipMachine * mp)
{
	FILE *f = NULL;
	C_FILE *cf = NULL;
	int fd = -1, ret = -1, mode = 0, share_mode = 0, ioflag = -1, *err = NULL;
	pid_t pid = -1;
	char buf[PATH_MAX];
	char *fmode = NULL, *fname = _clip_parc(mp, 1);
	int m = _clip_parni(mp, 2);
	int raw = _clip_parl(mp, 3);

	if ( _clip_parinfo(mp,0) < 3 )
        	raw = (FOPENMODE_FLAG & mp->flags1);

	share_mode = m & 0xfff8;
	m &= 7;

	if (raw)
		memcpy(buf, fname, strlen(fname));
	else
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
	}
	else if (!strcmp(buf, "|-"))
	{			/* stdout */
		if (mode != O_WRONLY)
		{
			errno = EACCES;
			goto err;
		}
		fd = dup(1);
	}
	else
	{
		int blen = strlen(buf);

		if (buf[0] == '|')
		{		/* output to chield */
			if (mode != O_WRONLY)
			{
				errno = EACCES;
				goto err;
			}
			ioflag = 0;
			memmove(buf, buf + 1, blen);
		}
		else if (buf[blen - 1] == '|')
		{		/* input from chield */
			mode = O_RDONLY;
			/*
			   if (mode != O_RDONLY)
			   {
			   errno = EACCES;
			   goto err;
			   }
			 */
			ioflag = 1;
			buf[blen - 1] = 0;
		}

		if (ioflag >= 0)
		{
			int pfd[2];

			pipe(pfd);

			if ((pid = fork()) == 0)
			{	/* chield */
				int i = 0;

				setuid(getuid());
				setgid(getgid());
				if (ioflag == 0)
				{	/* input from parent */
					dup2(pfd[0], 0);
					close(pfd[0]);
				}
				else
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

			if (ioflag == 0)
			{	/* output to chield */
				close(pfd[0]);
				fd = pfd[1];
			}
			else
			{	/* input from chield */
				close(pfd[1]);
				fd = pfd[0];
			}
			mode |= O_NONBLOCK;
		}
	}

#ifdef OS_CYGWIN
	mode |= O_BINARY;
#endif

#if 0
	if (fd >= 0 || (fd = open(buf, mode)) >= 0)
		f = fdopen(fd, fmode);
#else
        if ( raw && ioflag < 0 )
        {
		mode |= O_NONBLOCK;
		fd = open(buf, mode);
	}
	if (fd < 0 && (fd = open(buf, mode)) >= 0)
	{
#define FO_COMPAT	 0	/* Режим совместимости (по умолчанию) */
#define FO_EXCLUSIVE	16	/* Монопольное использование (Exclusive) */
#define FO_DENYWRITE	32	/* Предупреждение от записи другими процессами */
#define FO_DENYREAD	48	/* Предупреждение от чтения другими процессами */
#define FO_SHARED	64	/* Разрешение чтения и записи другими процессами */
#define FO_DENYNONE	64	/* (то же самое, что и FO_SHARED) */
		/*int l_type = F_WRLCK; */
		int l_type = -1;

		switch (share_mode)
		{
			/*
			   case FO_COMPAT:
			   case FO_DENYWRITE:
			 */
		case FO_DENYREAD:
		case FO_EXCLUSIVE:
			l_type = (mode == O_RDONLY ? F_RDLCK : F_WRLCK);
			break;
		case FO_DENYWRITE:
			l_type = (mode != O_WRONLY ? F_RDLCK : F_WRLCK);
			break;
		case FO_COMPAT:
		case FO_SHARED:
			l_type = (mode == O_WRONLY ? F_WRLCK : F_RDLCK);
			break;
		}

		/* if ( ioflag >= 0 || _set_lock(fd, l_type) ) */
		if (ioflag >= 0 || l_type == -1 || _set_lock(fd, l_type))
			f = fdopen(fd, fmode);
	}
	else
	{
		if (fd >= 0)
			f = fdopen(fd, fmode);
	}
#endif
      err:
	err = _clip_fetch_item(mp, HASH_ferror);
	*err = 0;

	if (f == NULL)
	{
		*err = errno;
		if (fd >= 0)
			close(fd);
	}
	else
	{
		*err = 0;
		cf = (C_FILE *) calloc(1, sizeof(C_FILE));
                if ( ioflag >=0 )
                	cf->type = FT_PIPE;
                else
        		cf->type = FT_FILE;
#ifdef FILEIO_BUFFERING
		cf->mode = 1;
#else
        	cf->mode = ( (BUFFERING_FLAG & mp->flags1) !=0 );
#endif
        	cf->fileno = fd;
		cf->f = f;
		cf->pid = pid;
		if (m == 1 && cf->mode == 1)
			fseek(cf->f, 0, SEEK_SET);
		if (m == 1 && cf->mode == 0)
			lseek(cf->fileno, 0, SEEK_SET);
		ret = _clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);
	}

	_clip_retni(mp, ret);

	return 0;
}

int
_clip_fready(ClipMachine * mp, int rmode)
{
	int *err = NULL, ret = -1;
	fd_set set;
	struct timeval tv;
	int fd = _clip_parni(mp, 1);
	int timeout = _clip_parni(mp, 2);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	err = _clip_fetch_item(mp, HASH_ferror);
	*err = 0;

	_clip_retl(mp, 0);

	if (cf == NULL )
		return 0;

	fd = cf->fileno;

	FD_ZERO(&set);
	FD_SET(fd, &set);

	tv.tv_sec = timeout / 1000;
	tv.tv_usec = (timeout % 1000) * 1000;

	switch (rmode)
	{
	case 1:
		ret = select(fd + 1, &set, NULL, NULL, &tv);
		break;
	case 2:
		ret = select(fd + 1, NULL, &set, NULL, &tv);
		break;
	}
	if (ret <= 0)
	{
		*err = errno;
		return 0;
	}
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
clip_FCREATE(ClipMachine * mp)
{
	FILE *f = NULL;
	C_FILE *cf = NULL;
	int fd = -1, ret = -1, *err = NULL;
	char buf[PATH_MAX];
	char *fname = _clip_parc(mp, 1);
	int m = _clip_parni(mp, 2);

	if (fname == NULL)
	{
		_clip_retni(mp, -1);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "FCREATE");
	}
	_clip_translate_path(mp, fname, buf, sizeof(buf));

	err = _clip_fetch_item(mp, HASH_ferror);
	*err = 0;
	if ((fd = _clip_creat(buf, O_RDWR|O_BINARY, mp->fileCreateMode, 1)) >=0 )
	{
		f = fdopen(fd, "r+");
	}
	if (f == NULL)
	{
		*err = errno;
	}
	else
	{
		*err = 0;
		cf = (C_FILE *) calloc(1, sizeof(C_FILE));
        	cf->type = FT_FILE;
        	cf->fileno = fd;
		cf->f = f;
#ifdef FILEIO_BUFFERING
		cf->mode = 1 ;
#else
        	cf->mode = ( (BUFFERING_FLAG & mp->flags1) !=0 );
#endif
		if (m == 1 && cf->mode == 1)
			fseek(cf->f, 0, SEEK_SET);
		if (m == 1 && cf->mode == 1)
			lseek(cf->fileno, 0, SEEK_SET);
		ret = _clip_store_c_item(mp, cf, _C_ITEM_TYPE_FILE, destroy_c_file);
	}

	_clip_retni(mp, ret);
	return 0;
}

int
clip_FCLOSE(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1);
	C_FILE *cf = (C_FILE *) _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);
	int ret = -1, *err = _clip_fetch_item(mp, HASH_ferror);

	if (cf == NULL)
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

int
clip_FERASE(ClipMachine * mp)
{
	int ret, *err, fd;
	char buf[PATH_MAX];
	char *fname = _clip_parc(mp, 1);

	if (fname == NULL)
	{
		_clip_retni(mp, -1);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "FERASE");
	}
	_clip_translate_path(mp, fname, buf, sizeof(buf));
	fd = open(buf, O_WRONLY);
	err = _clip_fetch_item(mp, HASH_ferror);
	if (fd < 0)
	{
		*err = errno;
		_clip_retni(mp, -1);
		return 0;
	}
	if (!_set_lock(fd, F_WRLCK))
	{
		*err = errno;
		_clip_retni(mp, -1);
		return 0;
	}
	close(fd);
	ret = unlink(buf);

	if (ret < 0)
		*err = errno;
	else
		*err = 0;
	_clip_retni(mp, ret);
	return 0;
}

int
clip_FILENO(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

        _clip_retni(mp, -1);
	if (cf == NULL )
        	return 0;
        if ( cf->f == NULL )
        	_clip_retni(mp,cf->fileno);
        else
        	_clip_retni(mp,fileno(cf->f));

        return 0;
}

int
clip_FTYPE(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL)
        	_clip_retni(mp, -1);
        else
        	_clip_retni(mp,cf->type);
        return 0;
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
	int *err = NULL, lenbuf = 0;
	int fd = _clip_parni(mp, 1);
	char *buf = _clip_parcl(mp, 2, &lenbuf);
	long ret = -1, nb = _clip_parnl(mp, 3);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	_clip_retnl(mp, -1);
	if (cf == NULL )
        	return 0;

	if (lenbuf < nb)
		nb = lenbuf;

	if ( nb>0 )
        {
        	if ( cf->f == NULL || cf->mode == 0 )
			ret = read(cf->fileno, buf, nb);
                else
			ret = fread(buf, 1, nb, cf->f);
        }
        else
        	ret = 0;

	err = _clip_fetch_item(mp, HASH_ferror);
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
	int *err = NULL;
	int fd = _clip_parni(mp, 1);
	long ret = -1, nb = _clip_parnl(mp, 2);
	char *buf = malloc(nb + 1);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	_clip_retc(mp, "");
	if (cf == NULL )
        	return 0;

	if (cf->f == NULL || cf->mode == 0)
		ret = read(cf->fileno, buf, nb);
        else
		ret = fread(buf, 1, nb, cf->f);

	if (ret >= 0)
	{
		buf[ret] = 0;
		_clip_retc(mp, buf);
	}
        free(buf);

	err = _clip_fetch_item(mp, HASH_ferror);
	*err = ret < 0 ? errno : 0;
#endif
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
clip_FSEEK(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1);
	long nb = _clip_parnl(mp, 2);
	int whence = SEEK_SET, w = _clip_parni(mp, 3);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	_clip_retnl(mp, -1);
	if (cf == NULL )
        	return 0;

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
        if (cf->f==NULL || cf->mode== 0 )
		_clip_retnl(mp, lseek(cf->fileno, nb, whence) );
        else
        {
		fseek(cf->f, nb, whence);
		_clip_retnl(mp, ftell(cf->f));
        }
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
	int len = 0, *err = NULL;
	int fd = _clip_parni(mp, 1);
	char *str = _clip_parcl(mp, 2, &len);
	long ret = -1, n = _clip_parnl(mp, 3);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf != NULL)
	{
		if (_clip_parinfo(mp, 3) != NUMERIC_t)
			n = len;
		if (n >= len)
			n = len;

		if (n <= 0)
		{
			_clip_retnl(mp, 0);
			return 0;
		}
                if ( cf->f == NULL || cf->mode == 0)
			ret = write(cf->fileno,str, n);
                else
			ret = fwrite(str, 1, n, cf->f);
		err = _clip_fetch_item(mp, HASH_ferror);
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
	int ret = -1, len = 0, *err = NULL;
	int fd = _clip_parni(mp, 1);
	char *str = _clip_parcl(mp, 2, &len);
	int n = _clip_parni(mp, 3);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf != NULL )
	{
		if (n <= 0)
			n = len;
		if (len < n)
			n = len;
                if ( cf->f == NULL || cf->mode == 0)
                {
			ret = write(cf->fileno,str, n);
			ret += write(cf->fileno,"\n", 1);
                }
                else
                {
			ret = fwrite(str, 1, n, cf->f);
			ret += fwrite("\n", 1, 1, cf->f);
                }
		err = _clip_fetch_item(mp, HASH_ferror);
		*err = ret < 0 ? errno : 0;
	}
#endif
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
clip_FILEEOF(ClipMachine * mp)
{
	int fd = _clip_parni(mp, 1);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	_clip_retl(mp,1);

	if (cf == NULL )
        	return 0;

	if ( cf->f == NULL || cf->mode==0 )
        {
        	int i,j;
		i = lseek(cf->fileno, 0, SEEK_CUR);
		j = lseek(cf->fileno, 0, SEEK_END);
		_clip_retl(mp, (i >= j));
		i = lseek(cf->fileno, i, SEEK_SET);
        }
        else
		_clip_retl(mp, feof(cf->f) ? 1 : 0);
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
	char *buf = NULL;
	int *err = _clip_fetch_item(mp, HASH_ferror);
	int fd = _clip_parni(mp, 1);
	int i, c = 0, n = _clip_parni(mp, 2);
	C_FILE *cf = _clip_fetch_c_item(mp, fd, _C_ITEM_TYPE_FILE);

	if (cf == NULL || cf->f == NULL)
	{
		*err = errno;
		_clip_retc(mp, "");
	}
	else
	{
		*err = 0;
		if (n <= 0)
			n = 256;
		buf = calloc(n + 1,1);
                if (cf->f == NULL || cf->mode==0)
                {
			for (i = 0; i < n; )
			{
				if ( read(cf->fileno, buf+i, 1) <= 0 )
                                	break;
                		c = *(buf+i);
				if ( c == '\n')
					break;
				if (c != '\r')
					i++;
			}
                }
                else
                {
			for (i = 0; i < n;)
			{
                		c = fgetc(cf->f);
				if ( c == EOF || c == '\n')
					break;
				if (c != '\r')
					buf[i++] = c;
			}
                }
		buf = (char *) realloc(buf, i + 1);
		_clip_retcn_m(mp, buf, i);
	}
#endif
	return 0;
}

int
clip_FFLUSH(ClipMachine * cm)
{
	int ret = 0, fd = _clip_parni(cm, 1);
	C_FILE *cf = _clip_fetch_c_item(cm, fd, _C_ITEM_TYPE_FILE);

	if (cf != NULL && cf->f != NULL && fflush(cf->f) == 0)
		ret = 1;
	_clip_retl(cm, ret);
	return 0;
}

int
clip_FTELL(ClipMachine * cm)
{
	int fd = _clip_parni(cm, 1);
	long ret = -1;
	C_FILE *cf = _clip_fetch_c_item(cm, fd, _C_ITEM_TYPE_FILE);

	_clip_retni(cm,ret);
	if (cf == NULL )
        	return 0;

	if ( cf->f == NULL || cf->mode == 0 )
        	ret = lseek(cf->fileno,0,SEEK_CUR);
        else
		ret = ftell(cf->f);
	_clip_retnl(cm, ret);
	return 0;
}

int
clip_FLENGTH(ClipMachine * cm)
{
	int fd = _clip_parni(cm, 1);
	long ret = -1;
	C_FILE *cf = _clip_fetch_c_item(cm, fd, _C_ITEM_TYPE_FILE);
	struct stat st;

	if (cf != NULL && cf->f != NULL && fstat(fileno(cf->f), &st) == 0)
	{
		ret = st.st_size;
	}
	_clip_retnl(cm, ret);
	return 0;
}

int
_clip_parse_path(char *fullpath, char *path, char *name)
{
	int len, i, j;

	len = strlen(fullpath);
	for (i = len; i >= 0 && fullpath[i] != '/'; i--);
	for (j = i + 1; j <= len; j++)
		name[j - i - 1] = fullpath[j];
	if (i >= 0)
	{
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
	fh = open(buf, mode);

	err = _clip_fetch_item(mp, HASH_ferror);
	if (fh < 0 || !_set_lock(fh, (mode == O_RDONLY) ? F_RDLCK : F_WRLCK))
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
	close(fh);
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

	fh = _clip_creat(buf, O_WRONLY, mode, 1);
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
	struct dirent *dirp;
	struct stat statbuf;
	DIR *dirh;

	paths = malloc(sizeof(char *));

	if (filename == NULL || *filename == 0)
	{
		_clip_retl(mp, 0);
		return 0;
	}
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
#ifdef OS_CYGWIN
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
		if (i < 0)
			getcwd(dirn, sizeof(dirn));
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
		if (_clip_glob_match(dirp->d_name, filen, 0) <= 0)
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
	return ret;
}


int
_clip_creat(char *file, int flags, mode_t mode, int exclusive)
{
	int fd, fl, lock;

	fl = flags & ~(O_TRUNC|O_CREAT|O_EXCL);
        lock = exclusive?F_WRLCK:F_RDLCK;

	fd = open(file, fl);

        if (fd>=0)
        {
		if (!_set_lock(fd, lock))
                {
        		close(fd);
                	return -1;
                }
        	close(fd);
                unlink(file);
        }

#if 1
	/* creat call work buggy on network filesystems...*/
	unlink(file);
#else
	fd = creat(file, mode);
        if (fd<0)
        	return fd;
	close(fd);
#endif
	fd = open(file, fl|O_CREAT, mode);

	if (fd<0)
        	return fd;

	if (!_set_lock(fd, lock))
        {
        	close(fd);
                return -1;
        }

	errno = 0;

	return fd;
}


int
_clip_open(char *file, int flags, mode_t mode, int exclusive)
{
	int fd, fl, lock;

	if ( (flags & (O_CREAT|O_TRUNC)) == (O_CREAT|O_TRUNC) )
        	return _clip_creat(file, flags, mode, exclusive);

	fl = flags & ~(O_TRUNC|O_CREAT|O_EXCL);
        lock = exclusive?F_WRLCK:F_RDLCK;

	fd = open(file, fl, mode);

        if (fd<0)
        	return -1;

	if (!_set_lock(fd, lock))
	{
       		close(fd);
               	return -1;
	}

	errno = 0;

	return fd;
}


