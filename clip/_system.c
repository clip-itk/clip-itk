/*
    Copyright (C) 2001  ITK
    Author   : Paul Lasarev <paul@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
   $Log: _system.c,v $
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

#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>

#include "clip.h"
#include "error.ch"

#undef SYSTEM

/*
 *    exitcode := system(command_str, stdin_str, @stdout_str[, @stderr_str])
 */
int
clip_SYSCMD(ClipMachine * mp)
{
	char *cmd;
	int lcmd;
	char *in;
	int lin;
	ClipVar *out, *err;
	OutBuf obuf, ebuf;
	int have_err = 0;
	pid_t pid;
	int status;
	int infd, outfd, errfd;
	int inpipe[2], outpipe[2], errpipe[2];
	fd_set r_fds, w_fds;
	int arg = 0, r = 0;

	cmd = _clip_parcl(mp, 1, &lcmd);
	in = _clip_parcl(mp, 2, &lin);
	out = _clip_par(mp, 3);
	err = _clip_par(mp, 4);

	if (!cmd || !lcmd || !in || !out)
		return EG_ARG;

	if (out && (out->t.type != CHARACTER_t || out->t.flags == F_MSTAT))
		return EG_ARG;

	if (err && (err->t.type != CHARACTER_t || err->t.flags == F_MSTAT))
		return EG_ARG;

	if (err)
		have_err = 1;

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

		/*setsid(); */
		setgid(getgid());
		setuid(getuid());
		execlp("/bin/sh", "/bin/sh", "-c", cmd, 0);
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
	/*destroy_Buf(&obuf); */

	if (have_err)
	{
		free(err->s.str.buf);
		putByte_Buf(&ebuf, 0);
		err->s.str.buf = ebuf.buf;
		err->s.str.len = ebuf.ptr - ebuf.buf - 1;
		/*destroy_Buf(&ebuf); */
	}
	return 0;
}

int
clip_PID(ClipMachine * mp)
{
	_clip_retnl(mp,getpid());
        return 0;
}

