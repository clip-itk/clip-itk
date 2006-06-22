/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
	$Log$
	Revision 1.1  2006/06/22 19:01:29  itk
	uri: initial
	
	Revision 1.18  2004/05/19 08:32:18  clip
	rust: fix for ./configure -m
	
	Revision 1.17  2003/09/09 14:36:14  clip
	uri: fixes for mingw from Mauricio and Uri

	Revision 1.16  2003/09/02 14:27:42  clip
	changes for MINGW from
	Mauricio Abre <maurifull@datafull.com>
	paul

	Revision 1.15  2001/10/29 06:51:21  clip
	fix text fopen modes
	paul

	Revision 1.14  2001/09/05 11:19:29  clip
	cygwin
	paul

	Revision 1.13  2001/04/03 09:17:00  clip
	license errors
	paul

	Revision 1.12  2001/03/30 11:51:02  clip
	add copyright

	Revision 1.11  2001/03/27 11:10:58  clip
	err if map wrond map index
	paul

	Revision 1.10  2001/03/26 10:57:38  clip
	1usec delay after kill()
	paul

	Revision 1.9  2001/03/26 09:47:47  clip
	continue
	paul

	Revision 1.8  2001/03/23 14:30:48  clip
	fd
	paul

	Revision 1.7  2001/03/23 13:50:20  clip
	xdefine
	paul

	Revision 1.6  2001/03/23 12:47:37  clip
	buffering
	paul

	Revision 1.5  2001/03/23 12:09:36  clip
	ASORT
	paul

	Revision 1.4  2001/03/15 09:53:50  clip
	signal/write sequences
	paul

	Revision 1.3  2001/03/02 12:57:27  clip
	DBG functions
	paul

	Revision 1.2  2001/03/02 07:41:27  clip
	initial
	paul

	Revision 1.1  2001/03/02 07:40:57  clip
	initial
	paul
*/

#include <string.h>
#include "clip.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
#include <errno.h>
#include <signal.h>
#include <stdarg.h>
#include <fcntl.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>
#ifndef OS_MINGW
	#include <sys/wait.h>
#endif
#include <sys/time.h>

#include "error.ch"

#ifndef _WIN32
static char in_path[256] =
{0};
static char out_path[256] =
{0};
static FILE *fin = 0;
static FILE *fout = 0;


static pid_t pid = 0, tpid = 0;
static int cleanup_installed = 0;

static void
cleanup(void)
{
	if (fin)
	{
		fclose(fin);
		fin = 0;
	}
	if (fout)
	{
		fclose(fout);
		fout = 0;
	}
	if (in_path[0])
	{
		remove(in_path);
		in_path[0] = 0;
	}
	if (out_path[0])
	{
		remove(out_path);
		out_path[0] = 0;
	}
	if (tpid != 0)
	{
		int status;

		kill(tpid, SIGTERM);
		waitpid(tpid, &status, 0);
		tpid = 0;
	}
}


static void
dbg_signal(int sig)
{
}
#endif

/*
	dbgconnect(cProgramNname|nPid) -> lResult
*/
int
clip_DBGCONNECT(ClipMachine *mp)
{
#ifdef _WIN32
	return EG_ARG;
#else
	ClipVar *vp = _clip_par(mp,1);
	pid_t dpid = 0;

	if (!vp)
		return EG_ARG;

	if (vp->t.type == NUMERIC_t)
		dpid = _clip_double(vp);
	else if (vp->t.type == CHARACTER_t)
	{
		char path[256];
		FILE *file;
		char *s = _clip_parc(mp, 1);

		if (!s || !*s)
			return EG_ARG;

		snprintf(path, sizeof(path), "pidof -s %s", s);
		file = popen(path, "r");
		if (file)
		{
			unsigned long ul;

			if (fscanf(file, "%lu", &ul) == 1)
				dpid = ul;
			pclose(file);
		}
	}

	if (!dpid)
		return EG_ARG;

	pid = dpid;

	if (!cleanup_installed)
	{
		cleanup_installed = 1;
		signal(SIGPIPE, dbg_signal);
		atexit(cleanup);
	}

	snprintf(in_path, sizeof(in_path), "/tmp/clip_dbg.%lu.in", (unsigned long) pid);
	remove(in_path);
	if (mkfifo(in_path, 0600))
	{
		_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "DBGCONNECT: cannot create FIFO '%s': %s\n",
			in_path, strerror(errno));
		cleanup();
		return -1;
	}

	_clip_logg(1, "fifo %s created successfully", in_path);

	snprintf(out_path, sizeof(out_path), "/tmp/clip_dbg.%lu.out", (unsigned long) pid);
	remove(out_path);
	if (mkfifo(out_path, 0600))
	{
		_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "DBGCONNECT: cannot create FIFO '%s': %s\n",
			out_path, strerror(errno));
		cleanup();
		return -1;
	}
	_clip_logg(1, "fifo %s created successfully", out_path);

	if (kill(pid, SIGUSR1))
	{
		_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "DBGCONNECT: cannot send signal SIGUSR1 to pid %lu: %s\n",
			(unsigned long) pid, strerror(errno));
		cleanup();
		return -1;
	}
	_clip_logg(1, "signal SIGUSR1 sent to pid %lu", (unsigned long) pid);

	fin = fopen(in_path, "wt");
	if (!fin)
	{
		_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "DBGCONNECT: cannot open FIFO '%s': %s\n",
			in_path, strerror(errno));
		cleanup();
		return -1;
	}
	setvbuf(fin, 0, _IOLBF, 0);
	fwrite("\n", 1, 1, fin);
	_clip_logg(1, "fifo %s opened for writing", in_path);


	fout = fopen(out_path, "rt");
	if (!fout)
	{
		_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "DBGCONNECT: cannot open FIFO '%s': %s\n",
			out_path, strerror(errno));
		cleanup();
		return -1;
	}
	/*setvbuf(fout, 0, _IOLBF, 0);*/

	_clip_logg(1, "fifo %s opened for reading", out_path);
	_clip_retl(mp, 1);

	for(;;)
	{
		char buf[4096];
		if (!fgets(buf, 4096, fout))
		{
			_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "DBGCOMMAND: cannot read data");
			cleanup();
			return -1;
		}
		if (!strcmp(buf, ".\n"))
			break;
	}


	return 0;
#endif
}

int
clip_DBGCLOSE(ClipMachine *mp)
{
	return 0;
}


/*
	dbgcommand(cCommand) -> cResponce
*/
int
clip_DBGCOMMAND(ClipMachine *mp)
{
#ifdef _WIN32
		return EG_ARG;
#else
	char *str = _clip_parc(mp, 1);
	char *buf, *obuf=0;

	if (!str)
		return EG_ARG;

	if (!fin)
	{
		_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "DBGCOMMAND: no connection");
		return -1;
	}

	buf = (char*) malloc(4096);
	memset(buf, 0, 4096);

#if 0
	/* read all possible input */
	for(;;)
	{
		fd_set rfds;
		int r, fno = fileno(fout);
		struct timeval tv;

		FD_ZERO(&rfds);
		FD_SET(fno, &rfds);
		tv.tv_sec = 0;
		tv.tv_usec = 0;

		r = select(fno+1, &rfds, 0, 0, &tv);

		if (r<=0)
			break;

		for(;;)
		{
			if (!fgets(buf, 4096, fout))
			{
				_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "DBGCOMMAND: cannot read data");
				cleanup();
				free(buf);
				return -1;
			}
			/*printf("got: %s", buf);*/
			if (!strcmp(buf, ".\n"))
			{
				fflush(fout);
				break;
			}
		}
	}
#endif

	fprintf(fin, "%s\n", str);
	fflush(fin);

	if (kill(pid, SIGUSR1))
	{
		_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "DBGCOMMAND: cannot send signal to PID %lu\n",
			(unsigned long) pid);
		cleanup();
		free(buf);
		return -1;
	}

	usleep(1);

	/* read input up to '.' line */
	obuf = (char*) malloc(1);
	*obuf = 0;

	for(;;)
	{
		int l, ol;
		if (!fgets(buf, 4096, fout))
		{
			_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "DBGCOMMAND: cannot read data");
			cleanup();
			free(buf);
			free(obuf);
			return -1;
		}
		/*printf("got: %s", buf);*/
		if (!strcmp(buf, ".\n"))
			break;
		l = strlen(buf);
		ol = strlen(obuf);
		obuf = (char*) realloc(obuf, ol+l+1);
		memcpy(obuf+ol, buf, l);
		obuf[ol+l] = 0;
	}

	_clip_retcn_m(mp, obuf, strlen(obuf));
	free(buf);
	return 0;
#endif
}


