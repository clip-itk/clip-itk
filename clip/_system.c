/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
   $Log: _system.c,v $
   Revision 1.21  2006/03/13 07:22:32  clip
   uri: some fix from Angelo Gigardi

   Revision 1.20  2004/11/30 13:45:48  clip
   uri: added UNAME()

   Revision 1.19  2004/10/09 12:38:53  clip
   rust: minor fix for configure -m=...

   Revision 1.18  2004/08/13 14:04:22  clip
   uri: add command winexec

   Revision 1.17  2004/08/13 13:54:37  clip
   uri: wimexec(cCommand) added

   Revision 1.16  2004/08/13 13:44:01  clip
   *** empty log message ***

   Revision 1.15  2004/07/21 14:24:28  clip
   rust: minor fix

   Revision 1.14  2004/07/06 07:18:41  clip
   alena: include file <string.h>

   Revision 1.13  2004/05/12 10:37:13  clip
   uri: small fix in system()

   Revision 1.12  2004/05/06 11:25:23  clip
   rust: minor fix

   Revision 1.11  2004/05/06 10:25:09  clip
   rust: SYSCMD(,,,,[{{"ENVVAR1","value1"},{"ENVVAR2","value2"}}],["/working/dir"])

   Revision 1.10  2003/09/09 14:36:14  clip
   uri: fixes for mingw from Mauricio and Uri

   Revision 1.9  2003/09/02 14:27:42  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.8  2001/09/07 10:13:06  clip
   uri: make _clip_PID() function

   Revision 1.7  2001/08/28 06:18:34  clip
   -s configure flag
   uninitalized var warnings with optimesed compile
   paul

   Revision 1.6  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.5  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.4  2000/05/24 18:33:58  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.3  2000/05/10 18:33:45  clip
   AADD now clone arrays
   terminal initialization fail only in fullscreen mode
   Paul Lasarev <paul@itk.ru>

   Revision 1.2  2000/05/03 19:32:28  clip
   add prefix 'clip_' to all clip functions

   Revision 1.1  2000/04/30 20:56:47  clip
   SYSCMD function

 */

#include <string.h>
#include "clip.h"
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <limits.h>
#ifndef OS_MINGW
	#include <sys/wait.h>
#endif

#include "error.ch"

#undef SYSTEM

int
clip_SYSCMD(ClipMachine * mp)
{
	char *cmd;
	int lcmd;
	char *in;
	int lin;
	ClipVar *out, *err, *cenv;
	int have_err = 0;
	char **env = 0;
	int i;
	char *pwd = 0;
#ifndef OS_MINGW
	OutBuf obuf, ebuf;
	pid_t pid;
	int status;
	int infd, outfd, errfd;
	int inpipe[2], outpipe[2], errpipe[2];
	fd_set r_fds, w_fds;
	int arg = 0, r = 0;
#endif

	cmd = _clip_parcl(mp, 1, &lcmd);
	in = _clip_parcl(mp, 2, &lin);
	out = _clip_par(mp, 3);
	err = _clip_par(mp, 4);
	cenv = _clip_vptr(_clip_par(mp,5));
	pwd = _clip_parc(mp, 6);

	if (!cmd || !lcmd || !in || !out)
		return EG_ARG;

	if (out && (out->t.type != CHARACTER_t || out->t.flags == F_MSTAT))
		return EG_ARG;

	if (err && (err->t.type != CHARACTER_t || err->t.flags == F_MSTAT))
		return EG_ARG;

	if (err)
		have_err = 1;

	if (cenv && cenv->t.type == ARRAY_t)
	{
		ClipVar l,r;
		char* s;
		long dims[2];
		int e1,e2;

		memset(&l,0,sizeof(ClipVar));
		memset(&r,0,sizeof(ClipVar));
		env = calloc(cenv->a.count+1,sizeof(char*));
		for(i=0;i<cenv->a.count;i++)
		{
			dims[0] = i;
			dims[1] = 0;
			e1 = _clip_aget(mp, cenv, &l, 2, dims);
			dims[1] = 1;
			e2 = _clip_aget(mp, cenv, &r, 2, dims);
			if(e1 || e2 || l.t.type != CHARACTER_t || r.t.type != CHARACTER_t)
				continue;
			s = calloc(1,l.s.str.len+r.s.str.len+2);
			memcpy(s,l.s.str.buf,l.s.str.len);
			s[l.s.str.len] = '=';
			memcpy(s+l.s.str.len+1,r.s.str.buf,r.s.str.len);
			env[i] = s;
			_clip_destroy(mp, &l);
			_clip_destroy(mp, &r);
		}
	}
#ifdef OS_MINGW
	execlp("command.com", "/c", cmd, 0);
#else
	pipe(inpipe);
	pipe(outpipe);
	if (have_err)
		pipe(errpipe);

	infd = inpipe[1];
	outfd = outpipe[0];
	if (have_err)
		errfd = errpipe[0];
	else
		errfd = -1;

	if (!(pid = fork()))
	{
		int i;

		dup2(inpipe[0], 0);
		dup2(outpipe[1], 1);
		if (have_err)
			dup2(errpipe[1], 2);
		else
			dup2(outpipe[1], 2);
		close(inpipe[0]);
		close(outpipe[1]);
		if (have_err)
			close(errpipe[1]);

		for (i = 3; i < 256; i++)
			close(i);

		setgid(getgid());
		setuid(getuid());
		if(pwd)
		{
			if(chdir(pwd))
				return EG_ARG;
		}

		if(env)
		{
			execle("/bin/sh", "/bin/sh", "-c", cmd, 0, env, NULL, NULL);
			i = 0;
			while(env[i])
				free(env[i++]);
			free(env);
		}
		else
			execlp("/bin/sh", "/bin/sh", "-c", cmd, 0, NULL);
		exit(111);
	}

	close(inpipe[0]);
	close(outpipe[1]);
	if (have_err)
		close(errpipe[1]);

	FD_ZERO(&r_fds);
	FD_ZERO(&w_fds);

	if (lin)
	{
		FD_SET(infd, &w_fds);
		arg = fcntl(infd, F_GETFL, arg);
		fcntl(infd, F_SETFL, arg | O_NONBLOCK);
	}
	else
	{
		close(infd);
		infd = -1;
	}

	FD_SET(outfd, &r_fds);
	arg = fcntl(outfd, F_GETFL, arg);
	fcntl(outfd, F_SETFL, arg | O_NONBLOCK);

	if (have_err)
	{
		FD_SET(errfd, &r_fds);
		arg = fcntl(errfd, F_GETFL, arg);
		fcntl(errfd, F_SETFL, arg | O_NONBLOCK);
	}

	init_Buf(&obuf);
	if (have_err)
		init_Buf(&ebuf);

	for (;;)
	{
		fd_set rfds, wfds;

		if ((infd < 0 || !FD_ISSET(infd, &w_fds))
			&& (outfd < 0 || !FD_ISSET(outfd, &r_fds)) &&
			(!have_err || errfd < 0 || !FD_ISSET(errfd, &r_fds)))
		{
			break;
		}

		rfds = r_fds;
		wfds = w_fds;

		r = select(FD_SETSIZE, &rfds, &wfds, 0, 0);

		if (r < 0)
			break;

		if (infd >= 0 && FD_ISSET(infd, &wfds))
		{
			if (lin)
			{
				r = write(infd, in, lin);
				if (r <= 0)
					goto clear_in;
				lin -= r;
				in += r;
				if (!lin)
					goto clear_in;
			}
			else
				  clear_in:
			{
				FD_CLR(infd, &w_fds);
				close(infd);
				infd = -1;
			}
		}

		if (outfd >= 0 && FD_ISSET(outfd, &rfds))
		{
			char buf[512];

			r = read(outfd, buf, sizeof(buf));
			if (r <= 0)
			{
				FD_CLR(outfd, &r_fds);
				close(outfd);
				outfd = -1;
			}
			else
			{
				putBuf_Buf(&obuf, buf, r);
			}
		}

		if (have_err && errfd >= 0 && FD_ISSET(errfd, &rfds))
		{
			char buf[512];

			r = read(errfd, buf, sizeof(buf));
			if (r <= 0)
			{
				FD_CLR(errfd, &r_fds);
				close(errfd);
				errfd = -1;
			}
			else
			{
				putBuf_Buf(&ebuf, buf, r);
			}
		}

	}

	if (infd >= 0)
		close(infd);
	if (outfd >= 0)
		close(outfd);
	if (have_err && errfd >= 0)
		close(errfd);

	waitpid(pid, &status, WNOHANG);

	r = WEXITSTATUS(status);
	_clip_retni(mp, r);

	free(out->s.str.buf);
	putByte_Buf(&obuf, 0);
	out->s.str.buf = obuf.buf;
	out->s.str.len = obuf.ptr - obuf.buf - 1;

	if (have_err)
	{
		free(err->s.str.buf);
		putByte_Buf(&ebuf, 0);
		err->s.str.buf = ebuf.buf;
		err->s.str.len = ebuf.ptr - ebuf.buf - 1;
	}
#endif
	return 0;
}

int
clip_PID(ClipMachine * mp)
{
	_clip_retnl(mp,getpid());
		return 0;
}

#ifdef OS_CYGWIN
	#include <w32api/windows.h>
	#include <w32api/winuser.h>

int
clip___WINEXEC(ClipMachine * mp)
{
	char *com = _clip_parc(mp, 1);

	if (com == NULL)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "invalid argument");
		_clip_retni(mp, -1);
		return 1;
	}

	_clip_retni(mp,WinExec(com,1));

	return 0;
}
#endif

#include <sys/utsname.h>

int
clip_UNAME(ClipMachine *mp) {
	int val = _clip_parni(mp,1);
	struct utsname namesys;

	int ret=uname(&namesys);

	_clip_retc(mp,"");
	if ( ret < 0 )
		return 0;
	switch (val)
	{
		case 1:
			_clip_retc(mp,namesys.sysname);
			break;
		case 2:
			_clip_retc(mp,namesys.release);
			break;
		case 3:
			_clip_retc(mp,namesys.version);
			break;
		case 4:
			_clip_retc(mp,namesys.machine);
			break;
#ifdef _GNU_SOURCE
		case 5:
			_clip_retc(mp,namesys.domainname);
			break;
#endif
		default:
			_clip_retc(mp,namesys.nodename);
			break;
	}
	return 0;
}
