/*
	Copyright (C) 2001  ITK
	Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log: _util.c,v $
   Revision 1.141  2004/12/01 08:13:05  clip
   alena: fix return value for _clip_translate_toutf

   Revision 1.140  2004/11/30 13:51:31  clip
   alena: fix convert to utf and from utf

   Revision 1.139  2004/11/23 13:15:58  clip
   alena: add to clip_TTRANSLATE_CHARSET translating to/from utf8

   Revision 1.138  2004/11/03 10:22:49  clip
   uri: small fix in len() without params

   Revision 1.137  2004/10/28 11:47:33  clip
   uri: fix formatiing in STR(), pad*() for numeric data and constants.

   Revision 1.136  2004/10/20 17:22:16  clip
   uri: add set(_SET_UTF8TERM) for terminal with UTF-8

   Revision 1.135  2004/08/13 13:54:37  clip
   uri: wimexec(cCommand) added

   Revision 1.134  2004/08/13 13:42:53  clip
   *** empty log message ***

   Revision 1.133  2004/08/09 15:51:37  clip
   uri: small fix

   Revision 1.132  2004/07/06 09:48:15  clip
   uri: small fix in acopy()

   Revision 1.131  2004/05/17 12:05:58  clip
   uri: small fix: added DT_ISDT()

   Revision 1.130  2004/02/03 08:47:59  clip
   uri: some fix in "run <cmd> and setcursor() restoring"

   Revision 1.129  2003/11/26 13:58:17  clip
   uri: small fix in __RUN for non-fullscreen mode

   Revision 1.128  2003/10/29 11:40:03  clip
   small fix for #160 (clear screen)
   paul

   Revision 1.127  2003/10/29 08:49:29  clip
   fix terminal restoring in scanmode
   fix restore screen after run
   closes #160
   paul

   Revision 1.126  2003/10/13 06:08:48  clip
   uri: fix for "errorlevel(3); quit" code

   Revision 1.125  2003/09/09 15:10:02  clip
   uri: USE_AS & CLIP_ASM is "yes" by default

   Revision 1.124  2003/09/08 15:06:02  clip
   uri: next step fixes for mingw from uri

   Revision 1.123  2003/09/02 14:27:42  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.122  2003/09/02 08:57:04  clip
   uri: glob() return logical value

   Revision 1.121  2003/07/17 13:10:55  clip
   uri: added cygwinroot()

   Revision 1.120  2003/07/17 12:16:46  clip
   uri: fix cliproot() for cygwin

   Revision 1.119  2003/07/17 11:51:01  clip
   uri: small fix for cygwin

   Revision 1.118  2003/07/02 06:35:39  clip
   uri: small fix

   Revision 1.117  2003/06/24 07:23:06  clip
   rust: minor fix

   Revision 1.116  2003/06/24 07:19:49  clip
   uri: memory leak in get_str()

   Revision 1.115  2003/03/20 12:22:36  clip
   uri: errorLevel() small fix.

   Revision 1.114  2003/03/12 10:20:45  clip
   call Task_killAll()
   in clip__QUIT
   paul

   Revision 1.113  2003/03/10 14:45:25  clip
   uri: strtod -> _clip_strtod in str2var()

   Revision 1.112  2003/01/22 14:27:34  clip
   uri: warning fix

   Revision 1.111  2003/01/22 10:33:38  clip
   dosparam() function
   closes #111
   paul

   Revision 1.110  2002/12/02 09:24:08  clip
   map obj fetch for simple name
   closes #65
   paul

   Revision 1.109  2002/11/26 12:42:36  clip
   rust: added parameter 'method' to _clip_var2str() and _clip_str2var()

   Revision 1.108  2002/10/31 10:33:59  clip
   plural form runtime messages support:
   gettext(cMsgid [,cModule])->cTranslated
   ngettext(cMsgid, cMsgid_plural, nNum, [,cModule]) ->cTranslated
   paul

   Revision 1.107  2002/09/25 11:47:25  clip
   add function: loadModuleMsg(cModule, cFilename_mo) -> bResult
   predefined macro: __CLIP_MODULE__  expands to current module name as "modname"
   new accepted environment var: CLIP_LOCALE_ROOT
	used by clip, clip_msgmerge, clip_msgfmt, and at runtime
   paul

   Revision 1.106  2002/09/16 09:36:59  clip
   alexey: function clip_CLIP_HOSTCS added

   Revision 1.105  2002/08/28 11:01:07  clip
   uri: empty help() added

   Revision 1.104  2002/08/18 12:10:00  clip
   uri: fix in afill()

   Revision 1.103  2002/08/15 11:52:45  clip
   fix for ASIZE(a,nl<0)
   paul

   Revision 1.102  2002/08/09 08:09:47  clip
   ains, aadd, adel now can work with non-numeric indexes
   paul

   Revision 1.101  2002/08/05 09:28:06  clip
   MAPEVAL()
   paul

   Revision 1.100  2002/07/25 12:45:52  clip
   newline in string errors
   paul

   Revision 1.99  2002/05/30 11:30:22  clip
   uri: small fixes

   Revision 1.98  2002/05/15 12:55:39  clip
   restore tty mode on __RUN
   paul

   Revision 1.97  2002/01/31 08:35:53  clip
   LOADLIB now append dll's suffix automatically
   paul

   Revision 1.96  2002/01/28 13:52:35  clip
   ALTD() ignore arguments
   paul

   Revision 1.95  2002/01/28 13:43:23  clip
   add ALTD func

   ALTD(0) - disable debugging
   ALTD(1) - enable debugging
   ALTD(2) - enable debugging and wait connection

   paul

   Revision 1.94  2002/01/18 13:48:28  clip
   uri: acopy with len(array)==0, remove "return EG_ARG;"

   Revision 1.93  2002/01/16 15:29:08  clip
   chinese patch
   preproc bugs
   some pseudographic chars < 32
   paul

   Revision 1.92  2001/12/20 13:19:33  clip
   *** empty log message ***

   Revision 1.91  2001/11/08 14:20:55  clip
   move _clip_translate_charset into cliprt.c
   paul

   Revision 1.90  2001/11/08 14:00:06  clip
   auto recoding of i18n messages
   paul

   Revision 1.89  2001/10/31 08:26:45  clip
   fixes
   paul

   Revision 1.88  2001/10/30 14:09:07  clip
   add TRANSLATE_CHARSET

   Revision 1.87  2001/10/29 11:56:34  clip
   fix for BLINK(intensitive background)
   paul

   Revision 1.86  2001/10/28 16:33:01  clip
   uri: aeval & NIL parameters

   Revision 1.85  2001/10/28 16:17:04  clip
   uri: start & count in aeval()

   Revision 1.84  2001/10/17 14:41:42  clip
   uri: smal fix in _procline

   Revision 1.83  2001/10/17 10:23:13  clip
   uri: _retc -> retni in procline with overstack

   Revision 1.82  2001/10/11 13:01:24  clip
   str2var automatically call function (if exist) with name
   "_RECOVER_"+v:classname  , with restored var as argument

   Revision 1.81  2001/09/24 15:35:02  clip
   ferase && locking files

   Revision 1.80  2001/09/20 14:14:16  clip
   uri: add function CLIPROOT

   Revision 1.79  2001/09/05 11:19:29  clip
   cygwin
   paul

   Revision 1.78  2001/09/04 05:52:56  clip
   cyclic reference detection in var2str
   paul

   Revision 1.77  2001/08/24 08:04:38  clip
   macro assign to array/map members
   paul

   Revision 1.76  2001/08/23 13:52:06  clip
   merge with NEWLOCALS
   paul

   Revision 1.75.2.3  2001/08/23 12:20:21  clip
   ISPRIVATE(cName) ->lVal
   ISPUBLIC(cName) ->lVal
   paul

   Revision 1.75.2.2  2001/08/23 08:21:15  clip
   fix
   paul

   Revision 1.75.2.1  2001/08/21 08:29:54  clip
   reference assign (like b:=@a[1])
   paul

   Revision 1.75  2001/07/03 15:40:20  clip
   uri: add function MEMVARGET(varname), MEMVARSET(varname,data)

   Revision 1.74  2001/06/20 08:20:01  clip
   добавила в ains() третий параметр - что именно вставляем в массив или map
   alena

   Revision 1.73  2001/06/15 11:32:11  clip
   uri:bug in afill() with parameters count

   Revision 1.72  2001/06/14 10:20:12  clip
   LOADBLOCK(<cName>) -> code
   paul

   Revision 1.71  2001/06/14 09:38:59  clip
   ascan
   paul

   Revision 1.70  2001/06/13 13:05:47  clip
   uri: add case flag in _clip_glob_match(), fixed all calls  this functions

   Revision 1.69  2001/06/07 09:52:26  clip
   uri:bugs

   Revision 1.68  2001/05/29 08:10:48  clip
   ulimit
   paul

   Revision 1.67  2001/05/11 09:11:57  clip
   errorblock & pcode
   paul

   Revision 1.66  2001/05/07 10:38:40  clip
   uri:val() add params len and dec

   Revision 1.65  2001/05/04 07:05:15  clip
   procline filename
   paul

   Revision 1.64  2001/04/23 10:01:10  clip
   drop functions call in type()
   paul

   Revision 1.63  2001/04/20 09:48:56  clip
   uplocals in _clip_clone
   paul

   Revision 1.62  2001/04/16 11:27:08  clip
   afill and arrays
   paul

   Revision 1.61  2001/04/09 11:12:27  clip
   ASORT,ASCAN work with mishalleous types in array
   add additional parameter to _clip_cmp
   paul

   Revision 1.60  2001/04/05 07:41:24  clip
   asort
   paul

   Revision 1.59  2001/04/05 07:30:47  clip
   asort with codeblock order
   paul

   Revision 1.58  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.57  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.56  2001/03/19 08:14:26  clip
   -binary flag in expr_command
   CODE type in var2str/str2var
   paul

   Revision 1.55  2001/03/13 09:30:26  clip
   bug in STR2VAR
   paul

   Revision 1.54  2001/03/13 09:11:31  clip
   bug in STR2VAR
   paul

   Revision 1.53  2001/03/12 13:47:18  clip
   VAR2STR, STR2VAR funcs
   paul

   Revision 1.52  2001/03/07 14:14:52  clip
   UUDECODE, UUENCODE funcs
   paul

   Revision 1.51  2001/02/23 09:20:10  clip
   GLOB function
   trailing ?? are valid
   paul

   Revision 1.50  2001/02/22 09:53:35  clip
   dbg: expr command
   paul

   Revision 1.49  2001/02/21 12:52:58  clip
   append HASHNAME(hash) - inverce to HASHSTR(str)

   append obj:modify() trigger:
   modify(obj,hash,newval) -> real new val
   MAPMODIFY(obj, enable) switch modify processing

   paul

   Revision 1.48  2000/12/27 13:13:05  clip
   add LOADLIB
   paul

   Revision 1.47  2000/12/07 07:19:38  clip
   [ string_constants ] - prepare for i18n
   linear sequence of func names in .po
   paul

   Revision 1.46  2000/11/23 12:56:18  clip
   keys, ADEL
   paul

   Revision 1.45  2000/11/23 06:59:55  clip
   load name order
   paul

   Revision 1.44  2000/11/23 06:50:23  clip
   load(name [,array])
   paul

   Revision 1.43  2000/11/22 14:52:19  clip
   .po now can be start with any (for example #!/usr/bin/cliprun) string
   paul

   Revision 1.42  2000/11/20 10:36:38  clip
   ISFUNCTION(name)
   paul

   Revision 1.41  2000/10/27 07:50:17  clip
   rational NUMERIC_t gluks
   paul

   Revision 1.40  2000/10/20 08:03:23  clip
   Вкрутил rational везде где упоминается NUMERIC_t
   может чего и осталось неотловленное, но это может быть только в тех
   местах где нет использования NUMERIC_t !!!!!
   from uri:

   Revision 1.39  2000/10/11 06:30:55  clip
   index in AEVAL block
   Paul Lasarev <paul@itk.ru>

   Revision 1.38  2000/10/11 06:17:53  clip
   add index to AEVAL block
   paul

   Revision 1.37  2000/05/30 15:22:48  clip
   uri: function colorselect and io color

   Revision 1.36  2000/05/25 19:29:37  clip
   restscreen in window
   Paul Lasarev <paul@itk.ru>

   Revision 1.35  2000/05/24 17:51:10  clip
   -1.. say in windows
   Paul Lasarev <paul@itk.ru>

   Revision 1.34  2000/05/24 16:56:30  clip
   bugs
   Paul Lasarev <paul@itk.ru>

   Revision 1.33  2000/05/15 21:01:00  clip
   ACOPY now work; _MSAVE, _MRESTORE .mem will appended automatically
   Paul Lasarev <paul@itk.ru>

   Revision 1.32  2000/05/15 14:28:36  clip
   to ASCAN appended parameter lBack - backward search
   Paul Lasarev <paul@itk.ru>

   Revision 1.31  2000/05/12 19:44:33  clip
   memory leak
   Paul Lasarev <paul@itk.ru>

   Revision 1.30  2000/05/10 18:33:46  clip
   AADD now clone arrays
   terminal initialization fail only in fullscreen mode
   Paul Lasarev <paul@itk.ru>

   Revision 1.29  2000/05/06 19:40:32  clip
   test
   Paul Lasarev <paul@itk.ru>

   Revision 1.28  2000/05/06 19:01:23  clip
   ASORT

   Revision 1.27  2000/05/06 18:49:32  clip
   paul: change from qsort to swap sort

   Revision 1.26  2000/05/06 18:36:55  clip
   gluk in asort

   Revision 1.23  2000/05/06 17:23:37  clip
   paul: _clip_cmp now return in *ret <0 0 >0

   Revision 1.20  2000/05/03 19:32:29  clip
   add prefix 'clip_' to all clip functions

   Revision 1.19  2000/04/26 22:35:44  clip
   t.memo = 0 in _clip_destroy

   Revision 1.18  2000/04/14 16:17:49  uri
   param count in a* functions

   Revision 1.17  2000/04/08 23:41:19  uri
   bug in ascan (parameter COUNT not used)

   Revision 1.16  2000/04/07 20:13:32  paul
   memo flag

   Revision 1.15  2000/04/07 14:42:37  paul
   empty

   Revision 1.14  2000/04/07 14:37:22  paul
   EMPTY

   Revision 1.13  2000/03/31 16:53:21  paul
   memfile rw

   Revision 1.12  2000/03/30 16:25:08  paul
   PARAM

   Revision 1.11  2000/03/29 21:15:52  paul
   errorblock nest limited

   Revision 1.10  2000/03/29 20:29:16  paul
   BREAK function

   Revision 1.9  2000/03/29 18:26:10  paul
   errorblock

   Revision 1.8  2000/03/10 15:55:51  paul
   memory leak, xon/xoff gluk

   Revision 1.7  2000/03/09 21:50:25  paul
   warnigns

   Revision 1.6  2000/03/07 20:03:13  paul
   add CLONE

   Revision 1.5  1999/12/28 20:34:15  uri
   *** empty log message ***

   Revision 1.4  1999/12/10 17:28:30  uri
   убрал предупреждения в cliprt, добавил MEMO_t, сделал несколько misc
   функций из тулзов

   Revision 1.3  1999/10/27 19:48:12  uri
   type & mptr

   Revision 1.2  1999/10/26 19:11:13  paul
   start cvs logging

 */

#include "clipcfg.h"
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>
#include <sys/time.h>
#ifdef OS_MINGW
	#include <ltdl.h>
#else
	#include <dlfcn.h>
	#include <netinet/in.h>
	#include <sys/resource.h>
#endif
#include <errno.h>

#include "clip.h"
#include "error.ch"
#include "rational.h"
#include "coll.h"
#include "hashcode.h"
#include "screen/charset.h"
#include "screen/screen.h"
#include "task/task.h"

extern char *CLIPROOT;

#define NEW(type) ((type*)calloc(sizeof(type),1))
#define NEWVECT(type,len) ((type*)calloc(sizeof(type),(len)))

#ifndef RTLD_NOW
#define RTLD_NOW DL_LAZY
#endif
#ifndef RTLD_GLOBAL
#define RTLD_GLOBAL DL_LAZY
#endif

#if 0
static void
decount(ClipVar * vp)
{
	switch (vp->t.flags)
	{
	case F_MPTR:
	case F_MREF:
		vp->p.vp->t.count--;
	default:
	}
}
#endif

int
clip_INIT_CLIPINIT(ClipMachine * mp)
{
	/*printf("CLIPINIT\n"); */

	/* for colorselect function */
	mp->colorSelect = 0;
	return 0;
}

static char * _clip_cygwinroot()
{
#ifdef OS_CYGWIN
	/* need change to WIN32 registry data*/
	char * s = "c:\\cygwin";
#else
	char * s = "";
#endif
	return s;
}

int
clip_CYGWINROOT(ClipMachine * mp)
{
	_clip_retc(mp,_clip_cygwinroot());
	return 0;
}

int
clip_CLIPROOT(ClipMachine * mp)
{
	char * ret;
	int len1,len2;
	char * s1 = _clip_cygwinroot();
	char * s2 = getenv("CLIPROOT");
	if (s2 == NULL)
		s2 = CLIPROOT;

	len1 = strlen(s1);
	len2 = strlen(s2);
	ret = malloc(len1+len2+1);
	memcpy(ret,s1,len1);
	memcpy(ret+len1,s2,len2);
	ret[len1+len2] = 0;

	_clip_retcn_m(mp, ret,len1+len2);
	return 0;
}

int
clip_CLIP_HOSTCS(ClipMachine * mp)
{
	_clip_retc(mp, _clip_hostcs);
	return 0;
}

int
clip_ERRORBLOCK(ClipMachine * mp)
{
	ClipVar *vp = _clip_spar(mp, 1);

	if (mp->errorblock)
		_clip_clone(mp, RETPTR(mp), mp->errorblock);
	if (vp)
	{
		_clip_delete(mp, mp->errorblock);
		mp->errorblock = (ClipVar *) calloc(1, sizeof(ClipVar));
		_clip_clone(mp, mp->errorblock, vp);
	}
	return 0;
}

int
clip_BREAK(ClipMachine * mp)
{
	ClipVar *vp = _clip_spar(mp, 1);
	ClipVar *np = NEW(ClipVar);

	if (!vp)
	{
		_clip_trap_str(mp, mp->fp->filename, mp->fp->line, "BREAK function requare argument");
		return EG_ARG;
	}

	_clip_clone(mp, np, vp);
	_clip_trap_var(mp, mp->fp->filename, mp->fp->line, np);

	return -1;
}

int
clip_DATATYPE(ClipMachine * mp)
{
	int rc = 0;
	int t = _clip_parinfo(mp, 1);

	switch (t)
	{
	case CHARACTER_t:
		rc = 1;
		break;
	case NUMERIC_t:
		rc = 2;
		break;
	case LOGICAL_t:
		rc = 4;
		break;
	case DATE_t:
		rc = 8;
		break;
	case MEMO_t:
		rc = 64;
		break;
	case OBJECT_t:
		rc = 8192;
		break;
	case PCODE_t:
	case CCODE_t:
		rc = 4096;
		break;
	case ARRAY_t:
		rc = 512;
		break;
	case MAP_t:
		rc = 1024;
		break;
	}
	_clip_retni(mp, rc);
	return 0;
}

int
clip_VALTYPE(ClipMachine * mp)
{
	_clip_retc(mp, _clip_type_name(_clip_par(mp, 1)));
	return 0;
}

int
clip_TYPE(ClipMachine * mp)
{
	int len;
	char *str = _clip_parcl(mp, 1, &len);
	char *rc = "UI";
	ClipVar var;
	int r;

	if (!str)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "TYPE");
	}
	else
	{
		char *s, *e;

		for (s = str, e = str + len; s < e; ++s)
			if (*s == '(' || *s == ')')
			{
				_clip_retc(mp, rc);
				return 0;
			}

		var.t.type = UNDEF_t;
		var.t.flags = F_NONE;
		mp->noerrblock++;
		r = _clip_eval_macro(mp, str, len, &var);
		mp->noerrblock--;
		if (r < 0)
			rc = "UE";
		else if (r > 0)
			rc = "U";
		else
			rc = _clip_type_name(&var);
		_clip_destroy(mp, &var);
	}

	_clip_retc(mp, rc);
	return 0;
}

int
clip_PROCNAME(ClipMachine * mp)
{
	int level = _clip_parni(mp, 1), l;
	ClipFrame *fp;

	for (fp = mp->fp, l = 0; fp && l < level; fp = fp->up, l++)
		;

	if (!fp)
	{
#if 1
		_clip_retc(mp, "");
		return 0;
#else
		_clip_trap_printf(mp, __FILE__, __LINE__, "PROCNAME: invalid call level '%d'", level);
		return 1;
#endif
	}

	_clip_retc(mp, (char *) fp->procname);

	return 0;
}

int
clip_PROCLINE(ClipMachine * mp)
{
	int level = _clip_parni(mp, 1), l;
	ClipFrame *fp;

	for (fp = mp->fp, l = 0; fp && l < level; fp = fp->up, l++)
		;

	if (!fp)
	{
#if 1
		_clip_retni(mp, 0);
		return 0;
#else
		_clip_trap_printf(mp, __FILE__, __LINE__, "PROCNAME: invalid call level '%d'", level);
		return 1;
#endif
	}

	_clip_retni(mp, fp->line);
	return 0;
}

int
clip_FILENAME(ClipMachine * mp)
{
	int level = _clip_parni(mp, 1), l;
	ClipFrame *fp;

	for (fp = mp->fp, l = 0; fp && l < level; fp = fp->up, l++)
		;

	if (!fp)
	{
#if 1
		_clip_retc(mp, "");
		return 0;
#else
		_clip_trap_printf(mp, __FILE__, __LINE__, "FILENAME: invalid call level '%d'", level);
		return 1;
#endif
	}

	_clip_retc(mp, (char *) fp->filename);

	return 0;
}

/*
   block = compile("{||qout('asdf')}")
 */
int
clip_COMPILE(ClipMachine * mp)
{
	char *str;
	int len, r;
	ClipBlock block;
	ClipVar *rp, *vp;

	str = _clip_parcl(mp, 1, &len);

	if (!str)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "COMPILE: non-character parameter");
		return 1;
	}

	r = _clip_compile_Block(mp, str, len, &block);

	if (r)
	{
		_clip_trap(mp, __FILE__, __LINE__);
		return r;
	}
	rp = RETPTR(mp);

	vp = NEW(ClipVar);
	vp->t.type = PCODE_t;
	vp->t.flags = F_NONE;
	vp->t.count = 1;
	vp->c.u.block = NEW(ClipBlock);
	*vp->c.u.block = block;

	CLEAR_CLIPVAR(rp);
	rp->t.type = PCODE_t;
	rp->t.flags = F_MPTR;
	rp->p.vp = vp;

	return 0;
}

int
BLOCK2STR(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);
	ClipBlock *bp;
	ClipVar *rp;
	int l;

	if (!vp || vp->t.type != PCODE_t)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "block2str: non-pcode parameter");
		return 1;
	}

	bp = vp->c.u.block;
	rp = RETPTR(mp);
	rp->t.type = CHARACTER_t;
	rp->t.flags = F_NONE;
	rp->s.str.len = l = bp->file->bodySize;
	rp->s.str.buf = (char *) malloc(l);
	memcpy(rp->s.str.buf, bp->file->body, l);

	return 0;
}

int
clip_LEN(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);
	int rn = 0,l,d;

	if (_clip_parinfo(mp,0) == 0)
	{
		_clip_retndp(mp, 0,10,0);
		return 0;
	}

	vp = _clip_par(mp, 1);

	switch (vp->t.type)
	{
	case CHARACTER_t:
		rn = vp->s.str.len;
		break;
	case ARRAY_t:
		rn = vp->a.count;
		break;
	case MAP_t:
		rn = vp->m.count;
		break;
	case NUMERIC_t:
		rn = vp->t.len;
		if (_clip_parinfo(mp,2) == NUMERIC_t)
			vp->t.len = _clip_parni(mp, 2);
		break;
	default:
		;
	}

	l = 10; d=0;
	if (mp->flags & FIXED_FLAG)
	{
		d = mp->decimals;
		l += mp->decimals+1;
	}
	_clip_retndp(mp, rn,l,d);
	return 0;
}

int
clip_DEC(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);
	int rn = 0;

	switch (vp->t.type)
	{
	case NUMERIC_t:
		rn = vp->t.dec;
		break;
	default:
		;
	}

	_clip_retni(mp, rn);
	return 0;
}

int
clip_ARRAY(ClipMachine * mp)
{
	int i, ndim, r;
	long *dims;
	ClipVar *rp;

	rp = RETPTR(mp);

	ndim = mp->argc;
#ifdef OS_MINGW
	dims = (long *) malloc(ndim * sizeof(long));
#else
	dims = (long *) alloca(ndim * sizeof(long));
#endif

	for (i = 1; i <= ndim; ++i)
		dims[i - 1] = _clip_parni(mp, i);

	r = _clip_array(mp, rp, ndim, dims);

	/*decount(rp); */

#ifdef OS_MINGW
	free(dims);
#endif
	return r;
}

int
clip_MAP(ClipMachine * mp)
{
	ClipVar *rp;

	rp = RETPTR(mp);
	_clip_map(mp, rp);
	/*decount(rp); */

	return 0;
}

/*  mapkeys(map) --> array of map keys */
int
clip_MAPKEYS(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);
	ClipVar *rp, *ap;
	int size, i;

	if (vp->t.type != MAP_t)
		return 0;

	rp = RETPTR(mp);

	CLEAR_CLIPVAR(rp);
	rp->t.type = ARRAY_t;
	rp->t.flags = F_MPTR;
	rp->p.vp = ap = (ClipVar *) calloc(sizeof(ClipVar), 1);
	ap->t.type = ARRAY_t;
	ap->t.flags = F_NONE;
	size = ap->a.count = vp->m.count;
	ap->a.items = (ClipVar *) calloc(sizeof(ClipVar), size);
	ap->t.count = 1;

	for (i = 0; i < size; ++i)
	{
		ClipVar *vpp = ap->a.items + i;

		vpp->t.type = NUMERIC_t;
		vpp->n.d = (vp->m.items + i)->no;
		vpp->t.memo = 0;
	}

	return 0;
}

/*
   enable/disable auto-call of map:modify for map modification

   MAPMODIFY(map [, lNewVal]) -> lPrevVal

   modify will be called as:
   modify(map, nFieldHash, newVal) -> valToAssign
 */
int
clip_MAPMODIFY(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);
	int ret;

	if (vp->t.type != MAP_t)
		return 0;

	ret = vp->t.memo;
	if (mp->argc > 1)
		vp->t.memo = _clip_parl(mp, 2);

	_clip_retl(mp, ret);

	return 0;
}

int
clip_EVAL(ClipMachine * mp)
{
	ClipVar *bp = _clip_par(mp, 1);

	if (!bp || (bp->t.type != CCODE_t && bp->t.type != PCODE_t))
		return 0;

	return _clip_eval(mp, bp, mp->argc - 1, ARGPTR(mp, 2), RETPTR(mp));
}

int
clip_MAPEVAL(ClipMachine * mp)
{
	ClipVar *obj = _clip_par(mp, 1);
	ClipVar *bp = _clip_par(mp, 2);
	ClipVar *sobj;
	int ret;

	if (!obj || (obj->t.type != MAP_t))
		return EG_ARG;

	if (!bp || (bp->t.type != CCODE_t && bp->t.type != PCODE_t && bp->t.type != CHARACTER_t))
		return EG_ARG;

	sobj = mp->obj;
	mp->obj = obj;
	if (bp->t.type == CHARACTER_t)
		ret = _clip_eval_macro(mp, bp->s.str.buf, bp->s.str.len, RETPTR(mp));
	else
		ret = _clip_eval(mp, bp, mp->argc - 2, ARGPTR(mp, 3), RETPTR(mp));
	mp->obj = sobj;

	return ret;
}

/* LOAD(pobj-name [, array-for-names]) -> Logical */
int
clip_LOAD(ClipMachine * mp)
{
	char *name = _clip_parc(mp, 1);
	ClipVar *ap = _clip_par(mp, 2);
	int r;
	Coll names;

	if (!name)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "no name given");
		return 1;
	}
	init_Coll(&names, free, 0);

	r = _clip_load(mp, name, &names, 0);
	_clip_retl(mp, !r);

	if (!r && ap && ap->t.type == ARRAY_t)
	{
		int i;

		for (i = 0; i < names.count; i++)
		{
			ClipVar v;
			char *s = (char *) names.items[i];

			_clip_var_str(s, strlen(s), &v);
			_clip_aadd(mp, ap, &v);
			_clip_destroy(mp, &v);
		}
	}

	destroy_Coll(&names);

	return r;
}

/* LOADBLOCK(pobj-name) -> codeblock */
int
clip_LOADBLOCK(ClipMachine * mp)
{
	char *name = _clip_parc(mp, 1);
	int r;

	if (!name)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "no name given");
		return 1;
	}

	r = _clip_load(mp, name, 0, RETPTR(mp));

	return r;
}

/* load system DLL */
int
clip_LOADLIB(ClipMachine * mp)
{
	/*void *hp; */
	char *name = _clip_parc(mp, 1);
	char buf[256], *e, *s;
	int r;

	if (!name)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "no name given");
		return 1;
	}

#if 0
	hp = dlopen(name, RTLD_NOW | RTLD_GLOBAL);
	if (!hp)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "ELF '%s' loading problem: %s", name, dlerror());
		return 1;
	}
#else
	snprintf(buf, sizeof(buf), "%s", name);
	e = strrchr(buf, '.');
	s = strrchr(buf, '/');
	if (e && (!s || e > s))
		*e = 0;
	else
		e = buf + strlen(buf);
	strncpy(e, DLLREALSUFF, sizeof(buf) - strlen(buf));

	r = _clip_load(mp, buf, 0, 0);

#endif
	_clip_retl(mp, !r);

	return 0;
}

int
clip_EMPTY(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);
	int r = 1, l;

	if (vp)
	{
		switch (vp->t.type)
		{
		case CHARACTER_t:
			if ((l = vp->s.str.len))
			{
				char *s;
				int i;

				for (i = 0, s = vp->s.str.buf; i < l; ++i, ++s)
				{
					switch (*s)
					{
					case ' ':
					case '\t':
					case '\r':
					case '\n':
						continue;
					}
					r = 0;
					break;
				}
			}
			break;
		case NUMERIC_t:
			{
				double d = _clip_double(vp);

				r = (d == 0 ? 1 : 0);
			}
			break;
		case DATE_t:
			r = (vp->d.julian == 0 ? 1 : 0);
			break;
		case LOGICAL_t:
			r = (vp->l.val ? 0 : 1);
			break;
		case ARRAY_t:
			r = (vp->a.count == 0 ? 1 : 0);
			break;
		case MAP_t:
			r = (vp->m.count == 0 ? 1 : 0);
			break;
		default:
			r = 0;
			break;
		case UNDEF_t:
			r = 1;
			break;
		}
	}

	_clip_retl(mp, r);
	return 0;
}

int
clip_AADD(ClipMachine * mp)
{
	ClipVar *ap = _clip_par(mp, 1);
	ClipVar *vp = _clip_spar(mp, 2);
	long no;
	int c;
	ClipVar *vp3 = _clip_par(mp, 3);

	if (!ap || !vp)
		return EG_ARG;

	if (vp3)
		no = _clip_hash(mp, vp3);
	else
		no = 0;

	if (ap->t.type == ARRAY_t)
	{
		c = ++ap->a.count;
		ap->a.items = (ClipVar *) realloc(ap->a.items, sizeof(ClipVar) * c);
		memset(ap->a.items + c - 1, 0, sizeof(ClipVar));
		_clip_clone(mp, ap->a.items + c - 1, vp);
		_clip_clone(mp, RETPTR(mp), vp);
	}
	else if (ap->t.type == MAP_t)
	{
		if (!no)
			no = ap->m.count;
		_clip_clone(mp, RETPTR(mp), ARGPTR(mp, 1));
		return _clip_madd(mp, ap, no, vp);
	}
	else
		return EG_ARG;

	return 0;
}

int
clip_ADEL(ClipMachine * mp)
{
	int r;
	long n;
	ClipVar *ap = _clip_par(mp, 1);
	ClipVar *vp = _clip_par(mp, 2);

	if (!ap || !vp)
		return EG_ARG;

	n = _clip_hash(mp, vp);

	if (ap->t.type == ARRAY_t)
	{
		long vect = n - 1;

		r = _clip_adel(mp, ap, 1, &vect);
		if (r)
			return r;
	}
	else if (ap->t.type == MAP_t)
	{
		r = _clip_mdel(mp, ap, n);
		if (r)
			return r;
	}
	else
		return EG_ARG;

	_clip_clone(mp, RETPTR(mp), ARGPTR(mp, 1));

	return 0;
}

int
clip_ASIZE(ClipMachine * mp)
{
	ClipVar *ap = _clip_par(mp, 1);
	int nl = _clip_parni(mp, 2);
	int r;
	ClipVar *rp;

	if (!ap)
		return 0;

	if (nl < 0)
		nl = 0;

	if (ap->t.type == ARRAY_t)
	{
		long vect = nl;

		r = _clip_asize(mp, ap, 1, &vect);
		if (r)
			return r;
	}

	rp = RETPTR(mp);
	_clip_clone(mp, rp, ARGPTR(mp, 1));

	return 0;
}

int
clip_AINS(ClipMachine * mp)
{
	ClipVar *ap = _clip_par(mp, 1);
	ClipVar *vp1 = _clip_par(mp, 2);
	ClipVar *vp = _clip_spar(mp, 3);
	int r;
	long n;

	if (!ap || !vp1)
		return 0;

	n = _clip_hash(mp, vp1);

	if (ap->t.type == ARRAY_t)
	{
		long vect = n - 1;

		r = _clip_ains(mp, ap, 1, &vect);
		if (r)
			return r;
		if (vp)
			_clip_clone(mp, ap->a.items + n - 1, vp);
	}
	else if (ap->t.type == MAP_t)
	{
		ClipVar zero;

		memset(&zero, 0, sizeof(zero));

		if (vp)
			r = _clip_madd(mp, ap, n, vp);
		else
			r = _clip_madd(mp, ap, n, &zero);
		if (r)
			return r;
	}
	else
		return EG_ARG;

	_clip_clone(mp, RETPTR(mp), ARGPTR(mp, 1));
	return 0;
}

int
clip_ATAIL(ClipMachine * mp)
{
	ClipVar *ap = _clip_par(mp, 1);
	int c;

	if (!ap)
		return 0;

	if (ap->t.type == ARRAY_t && (c = ap->a.count) > 0)
	{
		if (c > 0)
			_clip_clone(mp, RETPTR(mp), ap->a.items + c - 1);
	}

	return 0;
}

int
clip_AFILL(ClipMachine * mp)
{
	ClipVar *ap = _clip_par(mp, 1);
	ClipVar *vp = _clip_spar(mp, 2);
	int start = _clip_parni(mp, 3) - 1;
	int count = _clip_parni(mp, 4);
	int c, i, end, r;
	ClipVar *retp = RETPTR(mp), *arrp = ARGPTR(mp, 1);

	_clip_clone(mp, retp, arrp);

	if (!ap || !vp || ap->t.type != ARRAY_t)
		return 0;

	c = ap->a.count;
	if (start >= c)
		return 0;

	if (start < 0)
		start = 0;
	if (_clip_parinfo(mp, 0) < 4 || count > (c - start))
		count = c - start;

	for (i = start, end = start + count; i < end; ++i)
	{
		ClipVar *dp = ap->a.items + i;

		_clip_destroy(mp, dp);
		r = _clip_clone(mp, dp, vp);
		if (r)
			return r;
	}
	return 0;
}

int
clip_ACOPY(ClipMachine * mp)
{
	ClipVar *ap = _clip_par(mp, 1);
	ClipVar *dp = _clip_par(mp, 2);
	ClipVar *tp = _clip_spar(mp, 2);
	ClipVar *rp;
	int start = _clip_parni(mp, 3) - 1;
	int count;
	int dstart = _clip_parni(mp, 5) - 1;
	int c, i, end, r, j;

	if (!ap || !dp)
		return EG_ARG;

	if (mp->argc < 4)
		count = -1;
	else
		count = _clip_parni(mp, 4);

	rp = RETPTR(mp);

	if (ap->t.type == ARRAY_t && dp->t.type == ARRAY_t)
	{
		c = ap->a.count;
		if (start >= c)
			return 0;
		if (start < 0)
			start = 0;
		if (count < 0 || count > (c - start))
			count = c - start;
		c = dp->a.count;
		if (dstart >= c)
			return 0;	/*EG_ARG; */
		if (dstart < 0)
			dstart = 0;
		if (count > (c - dstart))
			count = c - dstart;

		for (i = start, j = dstart, end = start + count; i < end; ++i, ++j)
		{
			ClipVar *app = ap->a.items + i;
			ClipVar *dpp = dp->a.items + j;

			_clip_destroy(mp, dpp);
			r = _clip_clone(mp, dpp, app);
			if (r)
				return r;
		}
	}
	else if (ap->t.type == MAP_t && dp->t.type == MAP_t)
	{
		c = ap->m.count;
		if (start >= c)
			return 0;
		if (start < 0)
			start = 0;
		if (count < 0 || count > (c - start))
			count = c - start;
		c = dp->m.count;
		if (start >= c)
			return 0;
		if (dstart < 0)
			dstart = 0;
		if (count > (c - dstart))
			count = c - dstart;

		for (i = start, j = dstart, end = start + count; i < end; ++i, ++j)
		{
			ClipVarEl *app = ap->m.items + i;
			ClipVarEl *dpp = dp->m.items + j;

			_clip_destroy(mp, &dpp->v);
			r = _clip_clone(mp, &dpp->v, &app->v);
			if (r)
				return r;
			dpp->no = app->no;
		}
	}

	_clip_clone(mp, rp, tp);
	return 0;
}

int
clip_ACLONE(ClipMachine * mp)
{
	ClipVar *ap = _clip_par(mp, 1);
	ClipVar *rp;

	if (!ap || ap->t.type != ARRAY_t)
		return 0;

	rp = RETPTR(mp);

	return _clip_dup(mp, rp, ap);
}

int
clip_AEVAL(ClipMachine * mp)
{
	ClipVar *ap = _clip_par(mp, 1);
	ClipVar *bp = _clip_par(mp, 2);
	int start = _clip_parni(mp, 3) - 1;
	int count = _clip_parni(mp, 4);
	ClipVar *rp;
	int c, i, r;

	if (!ap)
		return 0;
	if (!bp || (bp->t.type != CCODE_t && bp->t.type != PCODE_t))
		return 0;

	if (ap->t.type == ARRAY_t)
	{
		c = ap->a.count;
		if (start >= c)
			return 0;
		if (start < 0)
			start = 0;
		if (count < 0 || count > (c - start) || _clip_parinfo(mp, 4) == UNDEF_t)
			count = c - start;

		for (i = start; i < start + count; ++i)
		{
			ClipVar *app = ap->a.items + i;
			ClipVar res, stack[2];

			memset(&res, 0, sizeof(ClipVar));
			memset(stack, 0, sizeof(stack));

			stack[0] = *app;
			stack[1].t.type = NUMERIC_t;
			stack[1].t.memo = 0;
			stack[1].n.d = i + 1;

			r = _clip_eval(mp, bp, 2, stack, &res);
			_clip_destroy(mp, &res);
			if (r)
				return r;
		}

		rp = RETPTR(mp);
		ap = ARGPTR(mp, 1);
		_clip_clone(mp, rp, ap);
	}
	else if (ap->t.type == MAP_t)
	{
		c = ap->m.count;
		if (start >= c)
			return 0;
		if (start < 0)
			start = 0;
		if (count < 0 || count > (c - start))
			count = c - start;

		for (i = 0; i < c; ++i)
		{
			ClipVar *app = &ap->m.items[i].v;
			long no = ap->m.items[i].no;
			ClipVar res, stack[2];

			memset(&res, 0, sizeof(ClipVar));
			memset(stack, 0, sizeof(stack));

			stack[0] = *app;
			stack[1].t.type = NUMERIC_t;
			stack[1].t.memo = 0;
			stack[1].n.d = no;

			r = _clip_eval(mp, bp, 2, stack, &res);
			_clip_destroy(mp, &res);
			if (r)
				return r;
		}

		rp = RETPTR(mp);
		ap = ARGPTR(mp, 1);
		_clip_clone(mp, rp, ap);
	}

	return 0;
}

int
clip_ASCAN(ClipMachine * mp)
{
	ClipVar *ap = _clip_par(mp, 1);
	ClipVar *bp = _clip_par(mp, 2);
	int start = _clip_parni(mp, 3) - 1;
	int count = _clip_parni(mp, 4);
	int back = _clip_parl(mp, 5);
	int c, i, r, code = 0, no = 0, end;

	if (!ap || ap->t.type != ARRAY_t || !bp)
	{
#if 0
		return EG_ARG;
#else
		_clip_retni(mp, 0);
		return 0;
#endif
	}
	if (bp->t.type == CCODE_t || bp->t.type == PCODE_t)
		code = 1;

	if (ap->t.type == ARRAY_t)
	{
		c = ap->a.count;
		if (start >= c)
			goto _ret;
		if (start < 0)
			start = 0;
		if (count <= 0 || count > (c - start))
			count = c - start;
		end = start + count;

		if (code)
		{
			if (back)
				i = end - 1;
			else
				i = start;
			for (;;)
			{
				ClipVar res, *app;

				if (back)
				{
					if (i <= start)
						break;
				}
				else
				{
					if (i >= end)
						break;
				}

				app = ap->a.items + i;
				memset(&res, 0, sizeof(res));

				r = _clip_eval(mp, bp, 1, app, &res);
				if (!r && res.t.type == LOGICAL_t && res.l.val)
					no = i + 1;
				_clip_destroy(mp, &res);
				if (r)
					return r;
				if (no)
					break;

				if (back)
					i--;
				else
					i++;
			}
		}
		else
		{
			if (back)
				i = end - 1;
			else
				i = start;
			for (;;)
			{
				ClipVar *app;
				int res = 0;

				if (back)
				{
					if (i <= start)
						break;
				}
				else
				{
					if (i >= end)
						break;
				}

				app = ap->a.items + i;

				r = _clip_cmp(mp, app, bp, &res, 1);
				if (r)
					return r;
				if (!res)
				{
					no = i + 1;
					break;
				}
				if (back)
					i--;
				else
					i++;
			}
		}

	}
	else if (ap->t.type == MAP_t)
	{
		c = ap->m.count;
		if (start >= c)
			goto _ret;
		if (start < 0)
			start = 0;
		if (count <= 0 || count > (c - start))
			count = c - start;
		end = start + count;

		if (code)
		{
			if (back)
				i = end - 1;
			else
				i = start;
			for (;;)
			{
				ClipVar res, *app;

				if (back)
				{
					if (i <= start)
						break;
				}
				else
				{
					if (i >= end)
						break;
				}

				app = &ap->m.items[i].v;
				memset(&res, 0, sizeof(res));

				r = _clip_eval(mp, bp, 1, app, &res);
				if (!r && res.t.type == LOGICAL_t && res.l.val)
					no = i + 1;
				_clip_destroy(mp, &res);
				if (r)
					return r;
				if (no)
					break;

				if (back)
					i--;
				else
					i++;
			}
		}
		else
		{
			end = start + count;

			if (code)
			{
				if (back)
					i = end - 1;
				else
					i = start;
				for (;;)
				{
					ClipVar *app;
					int res = 0;

					if (back)
					{
						if (i <= start)
							break;
					}
					else
					{
						if (i >= end)
							break;
					}

					app = &ap->m.items[i].v;

					r = _clip_cmp(mp, app, bp, &res, 1);
					if (r)
						return r;
					if (!res)
					{
						no = i + 1;
						break;
					}

					if (back)
						i--;
					else
						i++;
				}
			}
		}
	}

	  _ret:
	_clip_retni(mp, no);

	return 0;
}

typedef int (*q_cmp) (ClipVar * p1, ClipVar * p2, ClipMachine * mp, void *par);
static void q_sort(ClipVar * a, int n, q_cmp cmp, ClipMachine * mp, void *par);
static void swap_sort(ClipVar * a, int n, q_cmp cmp, ClipMachine * mp, void *par);

static int
compare_var(ClipVar * p1, ClipVar * p2, ClipMachine * mp, void *par)
{
	int ret = 0;

	if (!par)
	{
		_clip_cmp(mp, p1, p2, &ret, 1);
	}
	else
	{
		ClipVar res, stack[2];

		memset(&res, 0, sizeof(ClipVar));
		stack[0] = *p1;
		stack[1] = *p2;
		_clip_eval(mp, (ClipVar *) par, 2, stack, &res);
		switch (res.t.type)
		{
		case LOGICAL_t:
			ret = !res.l.val;
			break;
		case NUMERIC_t:
			ret = _clip_double(&res);
			break;
		default:
			;
		}
		_clip_destroy(mp, &res);
	}
	return ret;
}

int
clip_ASORT(ClipMachine * mp)
{

	ClipVar *rp;
	ClipVar *ap = _clip_par(mp, 1);
	int start = _clip_parni(mp, 2) - 1;
	int count = _clip_parni(mp, 3);
	ClipVar *bp = _clip_par(mp, 4);
	int c;

	if (!ap || ap->t.type != ARRAY_t)
		return 0;
	if (bp && bp->t.type != CCODE_t && bp->t.type != PCODE_t)
		bp = 0;

	c = ap->a.count;
	if (start >= c)
		return 0;
	if (start < 0)
		start = 0;
	if (count <= 0 || count > (c - start))
		count = c - start;

	if (bp)
		swap_sort(ap->a.items + start, count, compare_var, mp, bp);
	else
		q_sort(ap->a.items + start, count, compare_var, mp, bp);

	rp = RETPTR(mp);
	ap = ARGPTR(mp, 1);
	_clip_clone(mp, rp, ap);

	return 0;
}

/* [ */
#define q_swap(a,b) { ClipVar t = *(a); *(a)=*(b); *(b)=t; }
static void
swap_sort(ClipVar * a, int n, q_cmp cmp, ClipMachine * mp, void *par)
{
	ClipVar *pl, *pm;

	for (pm = a + 1; pm < a + n; pm++)
		for (pl = pm; pl > a && cmp((pl - 1), pl, mp, par) > 0; pl--)
			q_swap(pl, pl - 1);
}

/* ] */
/* [ */

/* standard qsort(3) realisation with additional parameters to cmp function */

#define q_min(a,b)	((a)<(b)?(a):(b))

static void
q_vecswap(ClipVar * pi, ClipVar * pj, int i)
{
	while (i > 0)
	{
		ClipVar t = *pi;

		*pi++ = *pj;
		*pj++ = t;
		i--;
	}
}

static ClipVar *
med3(ClipVar * a, ClipVar * b, ClipVar * c, q_cmp cmp, ClipMachine * mp, void *par)
{
	return cmp(a, b, mp, par) < 0 ?
		(cmp(b, c, mp, par) < 0 ? b : (cmp(a, c, mp, par) < 0 ? c : a))
		: (cmp(b, c, mp, par) > 0 ? b : (cmp(a, c, mp, par) < 0 ? a : c));
}

static void
q_sort(ClipVar * a, int n, q_cmp cmp, ClipMachine * mp, void *par)
{
	ClipVar *pa, *pb, *pc, *pd, *pl, *pm, *pn;
	int d, r, swap_cnt;

	  loop:
	swap_cnt = 0;
	if (n < 7)
	{
		for (pm = a + 1; pm < a + n; pm++)
			for (pl = pm; pl > a && cmp((pl - 1), pl, mp, par) > 0; pl--)
				q_swap(pl, pl - 1);
		return;
	}
	pm = a + (n / 2);
	if (n > 7)
	{
		pl = a;
		pn = a + (n - 1);
		if (n > 40)
		{
			d = (n / 8);
			pl = med3(pl, pl + d, pl + 2 * d, cmp, mp, par);
			pm = med3(pm - d, pm, pm + d, cmp, mp, par);
			pn = med3(pn - 2 * d, pn - d, pn, cmp, mp, par);
		}
		pm = med3(pl, pm, pn, cmp, mp, par);
	}
	q_swap(a, pm);
	pa = pb = a + 1;

	pc = pd = a + (n - 1);
	for (;;)
	{
		while (pb <= pc && (r = cmp(pb, a, mp, par)) <= 0)
		{
			if (r == 0)
			{
				swap_cnt = 1;
				q_swap(pa, pb);
				pa += 1;
			}
			pb += 1;
		}
		while (pb <= pc && (r = cmp(pc, a, mp, par)) >= 0)
		{
			if (r == 0)
			{
				swap_cnt = 1;
				q_swap(pc, pd);
				pd -= 1;
			}
			pc -= 1;
		}
		if (pb > pc)
			break;
		q_swap(pb, pc);
		swap_cnt = 1;
		pb += 1;
		pc -= 1;
	}
	if (swap_cnt == 0)
	{			/* Switch to insertion sort */
		for (pm = a + 1; pm < a + n; pm += 1)
			for (pl = pm; pl > a && cmp((pl - 1), pl, mp, par) > 0; pl -= 1)
				q_swap(pl, pl - 1);
		return;
	}

	pn = a + n;
	r = q_min(pa - a, pb - pa);
	q_vecswap(a, pb - r, r);
	r = q_min(pd - pc, pn - pd - 1);
	q_vecswap(pb, pn - r, r);
	if ((r = pb - pa) > 1)
		q_sort(a, r, cmp, mp, par);
	if ((r = pd - pc) > 1)
	{
		/* Iterate rather than recurse to save stack space */
		a = pn - r;
		n = r;
		goto loop;
	}
}

int
clip___RUN(ClipMachine * mp)
{
	char *com = _clip_parc(mp, 1);
	int old_cursor;

	if (com == NULL)
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "invalid argument");
		_clip_retc(mp, "");
		return 1;
	}

	if (mp->fullscreen)
	{
		old_cursor = mp->screen->cursor;
		restore_tty(mp->screen_base);	/* restore start mode */
	}

	system(com);

	if (mp->fullscreen)
		restart_tty(mp->screen_base);	/* set work mode */
	if (mp->fullscreen)
	{
		redraw_Screen(mp->screen, mp->flags1 & UTF8TERM_FLAG );
		mp->screen->cursor = !mp->screen->cursor;
		sync_Screen(mp->screen, mp->flags1 & UTF8TERM_FLAG );
		mp->screen->cursor = old_cursor;
		sync_Screen(mp->screen, mp->flags1 & UTF8TERM_FLAG );
	}

	return 0;
}

int
clip_CLONE(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);
	ClipVar *rp;

	if (!vp)
		return 0;

	rp = RETPTR(mp);
	_clip_dup(mp, rp, vp);
	return 0;
}

int
clip_ISFUNCTION(ClipMachine * mp)
{
	ClipFunction *fp;
	ClipBlock *bp;
	long hash;
	ClipVar *vp = _clip_par(mp, 1);

	hash = _clip_casehash(mp, vp);

	if (_clip_get_function(mp, hash, &fp, &bp))
		_clip_retl(mp, 1);
	else
		_clip_retl(mp, 0);

	return 0;
}

int
clip_GLOB(ClipMachine * mp)
{
	char *str = _clip_parc(mp, 1);
	char *pattern = _clip_parc(mp, 2);
	int caseflag = _clip_parl(mp, 3);

	if (!str || !*pattern)
		_clip_retl(mp, 0);
	else
		_clip_retl(mp, _clip_glob_match(str, pattern, caseflag) >=0 );

	return 0;
}

static void
put_str(OutBuf * bp, char *str, long len)
{
	putLong_Buf(bp, htonl(len));
	putBuf_Buf(bp, str, len);
}

static void
put_var(ClipMachine * mp, ClipVar * vp, OutBuf * bp, Coll * refs)
{
	vp = _clip_vptr(vp);

	if (search_Coll(refs, vp, 0))
	{
		putByte_Buf(bp, UNDEF_t);
		return;
	}

	putByte_Buf(bp, vp->t.type);
	switch (vp->t.type)
	{
	case UNDEF_t:
		break;
	case NUMERIC_t:
		{
			putByte_Buf(bp, vp->t.dec);
			putByte_Buf(bp, vp->t.len);
			putByte_Buf(bp, vp->t.memo);
			if (vp->t.memo)
			{
				char *buf;

				if (vp->t.dec)
					buf = rational_toString(vp->r.r, 10, vp->t.dec, 0);
				else
					buf = rational_toString(vp->r.r, 10, mp->decimals, 0);
				put_str(bp, buf, strlen(buf));
				free(buf);
			}
			else
			{
				char buf[48];

				if (vp->t.len < sizeof(buf))
				{
					char *s;
					snprintf(buf, sizeof(buf), "%*.*f", vp->t.len, vp->t.dec, vp->n.d);
					for (s = buf + strlen(buf); s > buf; --s)
						if ((*s) == ',')
							(*s) = '.';
				}
				else
					_clip_dtos(vp->n.d, buf, sizeof(buf), 0);
				put_str(bp, buf, strlen(buf));
			}
		}
		break;
	case CHARACTER_t:
		put_str(bp, vp->s.str.buf, vp->s.str.len);
		break;
	case LOGICAL_t:
		putByte_Buf(bp, vp->l.val);
		break;
	case DATE_t:
		putLong_Buf(bp, htonl(vp->d.julian));
		break;
	case OBJECT_t:
		vp->o.rtti->print(mp, vp->o.obj, vp->o.rtti, &mp->buf, &mp->buflen);
		put_str(bp, mp->buf, mp->buflen);
		break;
	case PCODE_t:
	case CCODE_t:
		/*out_any(mp, "CODE", 4, attr, dev); */
		break;
	case ARRAY_t:
		{
			int i;

			insert_Coll(refs, vp);
			putLong_Buf(bp, htonl(vp->a.count));
			for (i = 0; i < vp->a.count; ++i)
				put_var(mp, vp->a.items + i, bp, refs);
		}
		break;
	case MAP_t:
		{
			int i;

			insert_Coll(refs, vp);
			putLong_Buf(bp, htonl(vp->m.count));
			for (i = 0; i < vp->m.count; ++i)
			{
				putLong_Buf(bp, htonl(vp->m.items[i].no));
				put_var(mp, &(vp->m.items[i].v), bp, refs);
			}
		}
		break;
	default:
		;
	}
}

static int
refcmp(const void *p1, const void *p2)
{
	if (p1 < p2)
		return -1;
	else if (p1 > p2)
		return 1;
	else
		return 0;
}

void
_clip_var2str(ClipMachine * mp, ClipVar * vp, char **strp, long *lenp, int method)
{
	OutBuf buf;
	Coll refs;

	init_Buf(&buf);
	init_Coll(&refs, 0, refcmp);

	put_var(mp, vp, &buf, &refs);
	switch (method)
	{
	case 1:		/* uuencode */
		_clip_uuencode(buf.buf, buf.ptr - buf.buf, strp, lenp, 1);
		break;
	case 2:		/* compress */
	default:		/* no either uuencode nor compress */
		*strp = buf.buf;
		*lenp = buf.ptr - buf.buf;
		break;
	}

	if (method == 1 /*|| method == 2 */ )
		destroy_Buf(&buf);

	destroy_Coll(&refs);
}

/*
   var2str(any_var) -> cStringRepresentation
 */
int
clip_VAR2STR(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);
	char *str = 0;
	long len = 0;

	if (!vp)
	{
		_clip_retc(mp, "");
		return 0;
	}

	_clip_var2str(mp, vp, &str, &len, 1);
	_clip_retcn_m(mp, str, len);

	return 0;
}

static int
get_byte(char **buf, long *buflen, int *resp)
{
	if (*buflen < 1)
		return 0;
	*resp = *((unsigned char *) *buf);

	(*buf)++;
	(*buflen)--;

	return 1;
}

static int
get_long(char **buf, long *buflen, long *resp)
{
	if (*buflen < 4)
		return 0;
	*resp = ntohl(*((long *) *buf));

	(*buf) += 4;
	(*buflen) -= 4;

	return 4;
}

static int
get_str(char **buf, long *buflen, char **strp, long *lenp)
{
	long l;

	if (get_long(buf, buflen, &l) != 4)
		return 0;
	if (*buflen < l)
		return 0;

	*lenp = l;
	*strp = (char *) calloc(1/**strp*/, l + 1);
	memcpy(*strp, *buf, l);
	(*strp)[l] = 0;

	(*buf) += l;
	(*buflen) -= l;

	return l + 4;
}

static int
null_func(ClipMachine * mp)
{
	return 0;
}

static int
get_var(ClipMachine * mp, ClipVar * vp, char **str, long *len)
{
	int type;

	memset(vp, 0, sizeof(ClipVar));
	if (!get_byte(str, len, &type))
		return -1;

	switch (type)
	{
	case UNDEF_t:
		break;
	case NUMERIC_t:
		{
			int dec, l, memo;
			char *s = 0;
			long sl = 0;

			if (!get_byte(str, len, &dec))
				return -1;
			if (!get_byte(str, len, &l))
				return -1;
			if (!get_byte(str, len, &memo))
				return -1;
			if (!get_str(str, len, &s, &sl))
				return -1;

			vp->t.type = NUMERIC_t;
			vp->t.flags = F_NONE;
			vp->t.len = l;
			vp->t.dec = dec;
			vp->t.memo = memo;
			if (memo)
				vp->r.r = rational_fromString(s);
			else
			{
				int dec;
				vp->n.d = _clip_strtod(s, &dec);;
			}
			free(s);
		}
		break;
	case CHARACTER_t:
		{
			char *s = 0;
			long sl = 0;

			if (!get_str(str, len, &s, &sl))
				return -1;
			vp->t.type = CHARACTER_t;
			vp->t.flags = F_NONE;

			/*
			vp->s.str.buf = malloc(sl);
			memcpy(vp->s.str.buf,s,sl);
			free(s);
			*/
			vp->s.str.buf = s;
			vp->s.str.len = sl;
		}
		break;
	case LOGICAL_t:
		{
			int n;

			if (!get_byte(str, len, &n))
				return -1;
			vp->t.type = LOGICAL_t;
			vp->t.flags = F_NONE;
			vp->l.val = n;
		}
		break;
	case DATE_t:
		{
			long n;

			if (!get_long(str, len, &n))
				return -1;
			vp->t.type = DATE_t;
			vp->t.flags = F_NONE;
			vp->d.julian = n;
		}
		break;
	case OBJECT_t:
		{
			char *s = 0;
			long sl = 0;

			if (!get_str(str, len, &s, &sl))
				return -1;
			/*vp->o.rtti->print(mp, vp->o.obj, vp->o.rtti, &mp->buf, &mp->buflen); */
			free(s);
		}
		break;
	case PCODE_t:
	case CCODE_t:
		{
			/*ClipVar *sp = (ClipVar *) calloc(1, sizeof(ClipVar)); */
			/*
			   vp->t.flags = F_MPTR;
			   vp->t.type = CCODE_t;
			   vp->p.vp = sp;
			 */

			/*sp->t.count = 1; */
			vp->t.type = CCODE_t;
			vp->t.flags = F_NONE;
			vp->c.u.func = null_func;
		}
		break;
	case ARRAY_t:
		{
			long i, size;
			ClipVar *ap;

			if (!get_long(str, len, &size))
				return -1;

			ap = (ClipVar *) calloc(1, sizeof(ClipVar));
			vp->t.type = ARRAY_t;
			vp->t.flags = F_MPTR;
			vp->p.vp = ap;
			ap->t.type = ARRAY_t;
			ap->t.flags = F_NONE;
			ap->t.count = 1;
			ap->a.items = (ClipVar *) malloc(sizeof(ClipVar) * size);
			ap->a.count = size;

			for (i = 0; i < size; ++i)
				if (get_var(mp, ap->a.items + i, str, len) < 0)
					return -1;
		}
		break;
	case MAP_t:
		{
			int i;
			long size;
			ClipVar *ap;

			if (!get_long(str, len, &size))
				return -1;

			ap = (ClipVar *) calloc(1, sizeof(ClipVar));
			vp->t.type = MAP_t;
			vp->t.flags = F_MPTR;
			vp->p.vp = ap;
			ap->t.type = MAP_t;
			ap->t.flags = F_NONE;
			ap->t.count = 1;
			ap->m.items = (ClipVarEl *) calloc(sizeof(ClipVarEl), size);
			ap->m.count = size;

			for (i = 0; i < size; ++i)
			{
				if (!get_long(str, len, &(ap->m.items[i].no)))
					return -1;
				if (get_var(mp, &(ap->m.items[i].v), str, len) < 0)
					return -1;
			}
		}
		break;
	default:
		;
	}
	return 0;
}

#define RECOVER_PREFIX "_recover_"
#define RECOVER_PREFIX_LEN (sizeof(RECOVER_PREFIX)-1)

void
_clip_str2var(ClipMachine * mp, ClipVar * vp, char *str, long len, int method)
{
	char *buf = 0, *b;
	long buflen = 0;

	switch (method)
	{
	case 1:		/* uuencode */
		_clip_uudecode(str, len, &buf, &buflen);
		break;
	case 2:		/* compress */
	default:		/* no either uuencode nor compress */
		buf = str;
		buflen = len;
		break;
	}

	b = buf;
	get_var(mp, vp, &buf, &buflen);

	if (_clip_type(vp) == MAP_t)
	{
		ClipVar *np;
		char *s = 0;
		int l = 0;

		np = _clip_mget(mp, vp, HASH_CLASSNAME);
		if (!_clip_strFromVar(mp, np, &s, &l) && l)
		{
			buflen = l + RECOVER_PREFIX_LEN + 1;
			b = (char *) realloc(b, buflen);
			memcpy(b, RECOVER_PREFIX, RECOVER_PREFIX_LEN);
			memcpy(b + RECOVER_PREFIX_LEN, s, l);
			b[RECOVER_PREFIX_LEN + l] = 0;

			_clip_clip(mp, b, 1, vp, 0);
		}
		free(s);
	}
	if (method == 1 /*|| method == 2 */ )
		free(b);
}

/*
   str2var(cStrRepresentation) -> var
 */
int
clip_STR2VAR(ClipMachine * mp)
{
	int len;
	char *str = _clip_parcl(mp, 1, &len);

	if (!str)
		return EG_ARG;

	_clip_str2var(mp, RETPTR(mp), str, len, 1);

	return 0;
}

/* Single character decode.  */
#define DEC(ch) (((ch) - ' ') & 077)
/* ENC is the basic 1 character encoding function to make a char printing.  */
#define ENC(ch) (uu_std[(ch) & 077])

const char uu_std[64] = {
	'`', '!', '"', '#', '$', '%', '&', '\'',
	'(', ')', '*', '+', ',', '-', '.', '/',
	'0', '1', '2', '3', '4', '5', '6', '7',
	'8', '9', ':', ';', '<', '=', '>', '?',
	'@', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
	'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
	'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
	'X', 'Y', 'Z', '[', '\\', ']', '^', '_'
};

int
_clip_uuencode(char *sstr, long l, char **strp, long *lenp, int without_newline)
{
	OutBuf buf;
	int nl, n, ch, ll;
	unsigned char *str = (unsigned char *) sstr;
	unsigned char *p;

	init_Buf(&buf);
	nl = l / 45;
	for (n = 0, p = str; n < l; n += 45)
	{
		int nn;
		unsigned char c1, c2;

		ll = (l - n < 45) ? (l - n) : 45;
		putByte_Buf(&buf, ENC(ll));

		for (nn = ll; nn > 2; nn -= 3, p += 3)
		{
			ch = *p >> 2;
			ch = ENC(ch);
			putByte_Buf(&buf, ch);
			ch = ((*p << 4) & 060) | ((p[1] >> 4) & 017);
			ch = ENC(ch);
			putByte_Buf(&buf, ch);
			ch = ((p[1] << 2) & 074) | ((p[2] >> 6) & 03);
			ch = ENC(ch);
			putByte_Buf(&buf, ch);
			ch = p[2] & 077;
			ch = ENC(ch);
			putByte_Buf(&buf, ch);
		}

		if (nn)
		{
			c1 = *p;
			c2 = (nn == 1) ? 0 : p[1];

			ch = c1 >> 2;
			ch = ENC(ch);
			putByte_Buf(&buf, ch);

			ch = ((c1 << 4) & 060) | ((c2 >> 4) & 017);
			ch = ENC(ch);
			putByte_Buf(&buf, ch);

			if (nn == 1)
				ch = ENC('\0');
			else
			{
				ch = (c2 << 2) & 074;
				ch = ENC(ch);
			}
			putByte_Buf(&buf, ch);
			ch = ENC('\0');
			putByte_Buf(&buf, ch);
			if (!without_newline)
				putByte_Buf(&buf, '\n');
		}
		else if (!without_newline)
			putByte_Buf(&buf, '\n');
	}

	ch = ENC('\0');
	putByte_Buf(&buf, ch);
	if (!without_newline)
		putByte_Buf(&buf, '\n');

	*lenp = buf.ptr - buf.buf;
	*strp = (char *) realloc(*strp, *lenp + 1);
	memcpy(*strp, buf.buf, *lenp);
	(*strp)[*lenp] = 0;

	destroy_Buf(&buf);
	return 0;
}

int
_clip_uudecode(char *sstr, long l, char **strp, long *lenp)
{
	OutBuf buf;
	int n, ch;
	unsigned char *str = (unsigned char *) sstr;
	unsigned char *p, *e;

	init_Buf(&buf);

	for (p = str, e = str + l; p < e;)
	{
		if (*p == '\n')
		{
			p++;
			continue;
		}

		n = DEC(*p);
		if (n < 0)
			return -1;

		for (++p; n > 0; p += 4, n -= 3)
		{

			if (p >= e)
				return -1;

			if (n >= 3)
			{
				if (p + 3 >= e)
					return -1;

				ch = DEC(p[0]) << 2 | DEC(p[1]) >> 4;
				putByte_Buf(&buf, ch);
				ch = DEC(p[1]) << 4 | DEC(p[2]) >> 2;
				putByte_Buf(&buf, ch);
				ch = DEC(p[2]) << 6 | DEC(p[3]);
				putByte_Buf(&buf, ch);
			}
			else
			{
				if (n >= 1)
				{
					if (p + 1 >= e)
						return -1;
					ch = DEC(p[0]) << 2 | DEC(p[1]) >> 4;
					putByte_Buf(&buf, ch);
				}
				if (n >= 2)
				{
					if (p + 2 >= e)
						return -1;
					ch = DEC(p[1]) << 4 | DEC(p[2]) >> 2;
					putByte_Buf(&buf, ch);
				}
			}
		}
	}

	*lenp = buf.ptr - buf.buf;
	*strp = (char *) realloc(*strp, *lenp + 1);
	memcpy(*strp, buf.buf, *lenp);
	(*strp)[*lenp] = 0;

	destroy_Buf(&buf);
	return 0;
}

/*
   UUENCODE(cVar [,without_newline]) -> cVar
 */

int
clip_UUENCODE(ClipMachine * mp)
{
	char *str, *out = 0;
	long ol;
	int l;
	int without_newline = _clip_parl(mp, 2);

	str = _clip_parcl(mp, 1, &l);
	if (!str)
		return EG_ARG;

	_clip_uuencode(str, l, &out, &ol, without_newline);
	_clip_retcn_m(mp, out, ol);

	return 0;
}

int
clip_UUDECODE(ClipMachine * mp)
{
	char *str, *out = 0;
	long ol;
	int l;

	str = _clip_parcl(mp, 1, &l);
	if (!str)
		return EG_ARG;

	if (_clip_uudecode(str, l, &out, &ol))
		return EG_ARG;
	_clip_retcn_m(mp, out, ol);

	return 0;
}

/*
	ULIMIT(cResource [, nNewValue]) -> nValue

	cResource is a one of:
	"CPU"      CPU time in seconds
	"FSIZE"    Maximum filesize
	"DATA"     max data size
	"STACK"    max stack size
	"CORE"     max core file size
	"RSS"      max resident set size
	"NPROC"    max number of processes
	"NOFILE"   max number of open files
	"MEMLOCK"  max locked-in-memory address space
	"AS"       address space (virtual memory) limit
*/
int
clip_ULIMIT(ClipMachine * mp)
{
#ifdef OS_MINGW
	return EG_ARG;
#else
	char *res = _clip_parc(mp, 1);
	long newval;
	int resource;
	int r;
	struct rlimit rlimit;

	if (!res)
		return EG_ARG;

#ifdef RLIMIT_CPU
	if (!strcasecmp(res, "CPU"))
		resource = RLIMIT_CPU;
#else
	if (0)
		;
#endif
#ifdef RLIMIT_FSIZE
	else if (!strcasecmp(res, "FSIZE"))
		resource = RLIMIT_FSIZE;
#endif
#ifdef RLIMIT_DATA
	else if (!strcasecmp(res, "DATA"))
		resource = RLIMIT_DATA;
#endif
#ifdef RLIMIT_STACK
	else if (!strcasecmp(res, "STACK"))
		resource = RLIMIT_STACK;
#endif
#ifdef RLIMIT_CORE
	else if (!strcasecmp(res, "CORE"))
		resource = RLIMIT_CORE;
#endif
#ifdef RLIMIT_RSS
	else if (!strcasecmp(res, "RSS"))
		resource = RLIMIT_RSS;
#endif
#ifdef RLIMIT_NPROC
	else if (!strcasecmp(res, "NPROC"))
		resource = RLIMIT_NPROC;
#endif
#ifdef RLIMIT_NOFILE
	else if (!strcasecmp(res, "NOFILE"))
		resource = RLIMIT_NOFILE;
#endif
#ifdef RLIMIT_MEMLOCK
	else if (!strcasecmp(res, "MEMLOCK"))
		resource = RLIMIT_MEMLOCK;
#endif
#ifdef RLIMIT_AS
	else if (!strcasecmp(res, "AS"))
		resource = RLIMIT_AS;
#else
#ifdef RLIMIT_DATA
	else if (!strcasecmp(res, "AS"))
		resource = RLIMIT_DATA;
#endif
#endif
	else
		return EG_ARG;

	if (mp->argc > 1)
	{
		newval = _clip_parnl(mp, 2);
		getrlimit(resource, &rlimit);
		if (newval < 0)
			rlimit.rlim_cur = RLIM_INFINITY;
		else if (rlimit.rlim_max != RLIM_INFINITY && newval > rlimit.rlim_max)
			newval = rlimit.rlim_max;
		rlimit.rlim_cur = newval;
		setrlimit(resource, &rlimit);
	}

	r = getrlimit(resource, &rlimit);
	if (r)
		_clip_retnl(mp, -1);
	else
		_clip_retnl(mp, rlimit.rlim_cur);

	return 0;
#endif
}

int
clip_MEMVARGET(ClipMachine * mp)
{
	int l;
	char *name = _clip_parcl(mp, 1, &l);
	ClipVar *var;
	ClipVar *ret = RETPTR(mp);

	var = _clip_ref_memvar_noadd(mp, _clip_casehashbytes(0, name, l));
	if (var)
		_clip_clone(mp, ret, var);
	return 0;
}

int
clip_MEMVARSET(ClipMachine * mp)
{
	int l;
	char *name = _clip_parcl(mp, 1, &l);
	ClipVar *var;
	ClipVar *data = _clip_par(mp, 2);

	var = _clip_ref_memvar_noadd(mp, _clip_casehashbytes(0, name, l));
	_clip_retl(mp, 0);
	if (var)
	{
		_clip_clone(mp, var, data);
		_clip_retl(mp, 1);
	}
	return 0;
}

int
clip_ISPRIVATE(ClipMachine * cm)
{
	int l, ret = 0;
	char *name = _clip_parcl(cm, 1, &l);

	if (name)
	{
		if (!_clip_is_private(cm, _clip_casehashbytes(0, name, l)))
			ret = 1;
	}

	_clip_retl(cm, ret);
	return 0;
}

int
clip_ISPUBLIC(ClipMachine * cm)
{
	int l, ret = 0;
	char *name = _clip_parcl(cm, 1, &l);

	if (name)
	{
		if (!_clip_is_public(cm, _clip_casehashbytes(0, name, l)))
			ret = 1;
	}

	_clip_retl(cm, ret);
	return 0;
}

int
clip_ISMEMVAR(ClipMachine * cm)
{
	int l, ret = 0;
	char *name = _clip_parcl(cm, 1, &l);

	if (name)
	{
		if (!_clip_is_memvar(cm, _clip_casehashbytes(0, name, l)))
			ret = 1;

		if (!ret)
		{
			ret = _clip_parse_name(name, l, 0, 0, 0, 0, 0, 0);
			if (ret == 1 || ret == 3)
				ret = 1;
			else
				ret = 0;
		}
	}
	_clip_retl(cm, ret);
	return 0;
}

int
clip_HOST_CHARSET(ClipMachine * cm)
{
	_clip_retc(cm, _clip_hostcs);
	return 0;
}

/* Translate_ToUtf8([source codepage], string) */
int
_clip_translate_toutf8(char *p1, unsigned char *str, int len, char **result)
{
	int i, j, clen, total_len, wclen, first, len1=0;
	unsigned long *wcs, wc;
	char  *res, *bp;
	const unsigned long *wcp;
	cons_CharsetEntry *cs1 = 0;


	if (!p1 || !str)
		return EG_ARG;


	wclen = strlen(str);
	wcs = calloc(wclen,sizeof(unsigned long));
	if (load_charset_name(p1, &cs1, &len1))
	{
		_clip_logg(2, "translate_charset: cannot load charset file '%s': %s", p1, strerror(errno));
	}
	if (cs1)
	{
		for(i=0; i<wclen; i++)
		{
			for(j=0; j<len1; j++)
			{
				cons_CharsetEntry *cp;

				cp = cs1 + j;
				if (cp->ch == str[i])
					wcs[i] = cp->unich;
			}
		}
		free(cs1);
	}
	else
	{
		free(wcs);
		return -1;
	}

	wcp = wcs;
	total_len = 0;
	for (i = 0; i < wclen; i++)
	{
		wc = *wcp++;
		if (wc < 0x80)
			total_len += 1;
		else if (wc < 0x800)
			total_len += 2;
		else if (wc < 0x10000)
			total_len += 3;
		else if (wc < 0x200000)
			total_len += 4;
		else if (wc < 0x4000000)
			total_len += 5;
		else
			total_len += 6;
	}

	*result = calloc(total_len+1, sizeof(char));
	res = *result;

	wcp = wcs;
	bp = res;
	for (i = 0; i < wclen; i++)
	{
		wc = *wcp++;

		if (wc < 0x80)
		{
			first = 0;
			clen = 1;
		}
		else if (wc < 0x800)
		{
			first = 0xc0;
			clen = 2;
		}
		else if (wc < 0x10000)
		{
			first = 0xe0;
			clen = 3;
		}
		else if (wc < 0x200000)
		{
			first = 0xf0;
			clen = 4;
		}
		else if (wc < 0x4000000)
		{
			first = 0xf8;
			clen = 5;
		}
		else
		{
			first = 0xfc;
			clen = 6;
		}

		switch (clen)
		{
			case 6: bp[5] = (wc & 0x3f) | 0x80; wc >>= 6;
			case 5: bp[4] = (wc & 0x3f) | 0x80; wc >>= 6;
			case 4: bp[3] = (wc & 0x3f) | 0x80; wc >>= 6;
			case 3: bp[2] = (wc & 0x3f) | 0x80; wc >>= 6;
			case 2: bp[1] = (wc & 0x3f) | 0x80; wc >>= 6;
			case 1: bp[0] = wc | first;
		}

		bp += clen;
	}
	*bp = 0;

	free (wcs);

	return 0;
}

/* Translate_FromUtf8(string, [source codepage]) */
int
_clip_translate_fromutf8(char * p1, char * str, int len, char **result)
{
	int i, j, mask, clen, len1 = 0;
	unsigned long *wcs, *wcp;
	unsigned char *cp, *end, c;
	char *res;
	int n;
	cons_CharsetEntry *cs1 = 0;


	if (!p1 || !str)
		return EG_ARG;


	cp = (unsigned char *) str;
	end = cp + len;
	n = 0;
	wcs = calloc(len + 1, sizeof(unsigned long));
	wcp = wcs;
	while (cp != end)
	{
		mask = 0;
		c = *cp;
		if (c < 0x80)
		{
			clen = 1;
			mask = 0x7f;
		}
		else if ((c & 0xe0) == 0xc0)
		{
			clen = 2;
			mask = 0x1f;
		}
		else if ((c & 0xf0) == 0xe0)
		{
			clen = 3;
			mask = 0x0f;
		}
		else if ((c & 0xf8) == 0xf0)
		{
			clen = 4;
			mask = 0x07;
		}
		else if ((c & 0xfc) == 0xf8)
		{
			clen = 5;
			mask = 0x03;
		}
		else if ((c & 0xfc) == 0xfc)
		{
			clen = 6;
			mask = 0x01;
		}
		else
		{
			free (wcs);
			return -1;
		}

		if (cp + clen > end)
		{
			free (wcs);
			return -1;
		}

		*wcp = (cp[0] & mask);
		for (i = 1; i < clen; i++)
		{
			if ((cp[i] & 0xc0) != 0x80)
			{
				free (wcs);
				return -1;
			}
			*wcp <<= 6;
			*wcp |= (cp[i] & 0x3f);
		}

		cp += clen;
		wcp++;
		n++;
	}
	if (cp != end)
	{
		free (wcs);
		return -1;
	}

	/* n is the number of wide chars constructed */

	*result = calloc(n + 1, sizeof(char));
	res = *result;
	res[n] = 0;

	if (load_charset_name(p1, &cs1, &len1))
	{
		_clip_logg(2, "translate_charset: cannot load charset file '%s': %s", p1, strerror(errno));
	}
	wcp = wcs;
	if (cs1)
	{
		for(i=0; i<n; i++)
			for(j=0; j<len1; j++)
			{
				cons_CharsetEntry *cp;
				cp = cs1 + j;
				if (wcs[i] == cp->unich)
				{
					res[i] = cp->ch;
					break;
				}
			}
	}
	else
		strcpy(res, str);
	free (cs1);
	free (wcs);

	return 0;
}

int
clip_TRANSLATE_CHARSET(ClipMachine * mp)
{
	int len = 0, r;
	char *p1 = _clip_parc(mp, 1);
	char *p2 = _clip_parc(mp, 2);
	unsigned char *str = (unsigned char *) _clip_parcl(mp, 3, &len);
	unsigned char *s;

	if (!p1 || !p2 || !str)
		return EG_ARG;

	if (!strcasecmp(p1, p2))
	{
		_clip_retcn(mp, str, len);
		return 0;
	}


	if (!strcasecmp(p1, "utf-8"))
	{
		char *result;
		if (!_clip_translate_fromutf8(p2, str, len, &result))
		{
			_clip_retc(mp, result);
			free(result);
		}
		else
			_clip_retc(mp, str);
		return 0;
	}

	if (!strcasecmp(p2, "utf-8"))
	{
		char *result;
		if (!_clip_translate_toutf8(p1, str, len, &result))
		{
			_clip_retc(mp, result);
			free(result);
		}
		else
			_clip_retc(mp, str);
		return 0;
	}

	s = (unsigned char *) malloc(len + 1);
	s[len] = 0;

	if ((r = _clip_translate_charset(p1, p2, str, s, len)))
		return r;

	_clip_retcn_m(mp, s, len);

	return 0;
}

int
clip_REFCOUNT(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);

	if (!vp)
		_clip_retni(mp, 0);
	else
		_clip_retni(mp, vp->t.count);

	return 0;
}

int
clip_HELP(ClipMachine * mp)
{
	return 0;
}

/*
	loadModuleMsg(cModule, cFilename_mo) -> bResult
*/
int
clip_LOADMODULEMSG(ClipMachine * mp)
{
	char *module = _clip_parc(mp, 1);
	char *filename = _clip_parc(mp, 2);
	int r;

	if (!module || !filename)
		return EG_ARG;

	r = _clip_module_locale(module, filename);

	_clip_retl(mp, !r);
	return 0;
}

/*
	GETTEXT(cMsg [,cModule])->cTranslated
*/
int
clip_GETTEXT(ClipMachine * mp)
{
	char *msgid = _clip_parc(mp, 1);
	char *module = _clip_parc(mp, 2);

	if (msgid && module)
	{
		char *rp = 0;
		int l;

		_clip_locale_msg(module, msgid, &rp);
		l = strlen(rp);
		_clip_retcn_m(mp, rp, l);
	}
	else
		_clip_retc(mp, msgid);

	return 0;
}

/*
	NGETTEXT(cSingleMsg, cPluralMsg, nNum [,cModule])->cTranslated
*/
int
clip_NGETTEXT(ClipMachine * mp)
{
	char *msgid = _clip_parc(mp, 1);
	char *msgid_plural = _clip_parc(mp, 2);
	long n = _clip_parnl(mp, 3);
	char *module = _clip_parc(mp, 4);

	if (msgid && msgid_plural && module)
	{
		char *rp = 0;
		int l;

		_clip_locale_msg_plural(module, msgid, msgid_plural, n, &rp);
		l = strlen(rp);
		_clip_retcn_m(mp, rp, l);
	}
	else if (msgid && msgid_plural)
	{
		if (n == 1)
			_clip_retc(mp, msgid);
		else
			_clip_retc(mp, msgid_plural);
	}
	else if (msgid)
		_clip_retc(mp, msgid);

	return 0;
}

int
clip_DOSPARAM(ClipMachine * mp)
{
	char *s;
	int i, l;

	for (i = 0, l = 0; i < _clip_raw_argc; i++)
		l += strlen(_clip_raw_argv[i]) + 1;

	s = (char *) malloc(l + 1);

	for (i = 0, l = 0; i < _clip_raw_argc; i++)
	{
		char *p = _clip_raw_argv[i];
		int l1 = strlen(p);

		memcpy(s + l, p, l1);
		s[l + l1] = ' ';
		l += l1 + 1;
	}

	if (l)
		l--;
	s[l] = 0;

	_clip_retcn_m(mp, s, l);

	return 0;
}


