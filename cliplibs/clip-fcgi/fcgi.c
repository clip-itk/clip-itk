/*
   Copyright (C) 2002  ITK
   Authors  : Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */

/*
   $Log$
   Revision 1.1  2006/06/22 20:12:03  itk
   uri: init sf.net

   Revision 1.3  2005/01/05 11:22:16  clip
   uri: small fix

   Revision 1.2  2005/01/03 11:08:11  clip
   uri: small fix

   Revision 1.1  2002/04/24 13:14:43  clip
   initial
   paul

 */

#include <errno.h>
#include <limits.h>
#include <string.h>

#include <fcgi_config.h>
/*#include <fcgi_stdio.h>*/
#include <fcgiapp.h>

#include "clip.h"
#include "error.ch"

extern char **environ;

static FCGX_Stream *in = 0, *out = 0, *err = 0;
static FCGX_ParamArray envp;
static OutBuf obuf, ebuf;
static int inited = 0;
static int flush_bufs(void);

int
clip_FCGI_ACCEPT(ClipMachine *mp)
{
	int r;

	if (inited)
	{
		flush_bufs();
		FCGX_Finish();
	}

	r = FCGX_Accept(&in, &out, &err, &envp);
	/*r = FCGI_Accept();*/
	_clip_retl(mp, (r >= 0) ? 1 : 0);

	if (!inited)
	{
		inited = 1;

		init_Buf(&obuf);
		init_Buf(&ebuf);

		mp->obuf = &obuf;
		mp->ebuf = &ebuf;
	}

	return 0;
}

static int
flush_bufs(void)
{
	int r;

	r = obuf.ptr - obuf.buf;
	if (r)
	{
		FCGX_PutStr(obuf.buf, r, out);
		/*FCGI_fwrite(obuf.buf, 1, r, FCGI_stdout);*/
		obuf.ptr = obuf.buf;
	}
	r = ebuf.ptr - ebuf.buf;
	if (r)
	{
		FCGX_PutStr(ebuf.buf, r, err);
		/*FCGI_fwrite(ebuf.buf, 1, r, FCGI_stderr);*/
		ebuf.ptr = ebuf.buf;
	}

	/*r = FCGX_FFlush(out);*/
	/*r = FCGI_fflush(FCGI_stdout);*/
	/*FCGX_FFlush(err);*/
	/*FCGI_fflush(FCGI_stderr);*/

	return r;
}

int
clip_FCGI_FLUSH(ClipMachine *mp)
{
	int r;

	if (!inited)
		return EG_ARG;

	r = flush_bufs();

	_clip_retl(mp, !r);

	return 0;
}

int
clip_FCGI_GETENV(ClipMachine *mp)
{
	ClipVar *rp;
	char *str = _clip_parc(mp, 1);
	int i = 0;

	if (!inited)
		return EG_ARG;

	if (str)
	{
		_clip_retc(mp, FCGX_GetParam(str, envp));
		/*_clip_retc(mp, getenv(str));*/
	}
	else
	{
		rp = RETPTR(mp);
		_clip_map(mp, rp);
		while (envp[i])
		{
			int l;
			char *s = envp[i];
			char *e;
			/*char *s = environ[i];*/

			l = strcspn(s, "=");
			if (s[l]=='=')
				e = s+l+1;
			else
				e = "";
			_clip_mputc(mp, rp, _clip_casehashbytes(0, s, l), e, strlen(e));
			i++;
		}
	}
	return 0;
}

/*
 * read CONTENT_LENGTH input and return as string
 */
int
clip_FCGI_READ(ClipMachine *mp)
{
	char *clen;
	int len;

	if (!inited)
		return EG_ARG;

	clen =  FCGX_GetParam("CONTENT_LENGTH", envp);
	/*clen =  getenv("CONTENT_LENGTH");*/

	if (clen)
		len = strtol(clen, NULL, 10);
	else
		len = 0;

	if(len)
	{
		OutBuf buf;
		int i, ch, l;

		init_Buf(&buf);
		for (i = 0; i < len; i++)
		{
			if ((ch = FCGX_GetChar(in)) < 0)
			/*if ((ch = FCGI_fgetc(FCGI_stdin)) < 0)*/
				break;
			putByte_Buf(&buf, ch);
		}
		l = buf.ptr - buf.buf;
		putByte_Buf(&buf, 0);
		_clip_retcn_m(mp, buf.buf, l);
	}
	else
		_clip_retc(mp, "");

	return 0;
}


