/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log$
   Revision 1.2  2007/01/09 11:41:30  itk
   uri: add set(_SET_IDLE_INKEY) for minimize traffic from terminal

   Revision 1.1  2006/06/22 19:01:36  itk
   uri: initial

   Revision 1.101  2006/06/19 08:49:16  clip
   uri: make support printing to LPTx with x>3

   Revision 1.100  2005/09/30 06:25:12  clip
   uri: small fix

   Revision 1.99  2005/03/09 14:36:50  clip
   uri: small fix

   Revision 1.98  2005/03/04 06:45:44  clip
   uri: small fix about colorRect() and tBrowse:defColor

   Revision 1.97  2004/12/07 09:14:03  clip
   uri: added invertAttr()

   Revision 1.96  2004/10/27 09:43:09  clip
   uri: fix in setcolor() about sync 2&5 pairs, and clear all pairs for "X".

   Revision 1.95  2004/10/26 07:21:47  clip
   uri: small fix in setcolor()

   Revision 1.94  2004/10/20 17:22:17  clip
   uri: add set(_SET_UTF8TERM) for terminal with UTF-8

   Revision 1.93  2004/10/07 07:52:26  clip
   uri: some fixes and few short func names

   Revision 1.92  2004/09/28 08:25:27  clip
   uri: small fix

   Revision 1.91  2004/09/03 07:17:54  clip
   uri: small fix

   Revision 1.90  2004/09/03 07:04:01  clip
   uri: small fixes from John Smyth <js@w-e.ru>

   Revision 1.89  2004/08/12 12:32:14  clip
   uri: small fix

   Revision 1.88  2004/06/11 14:05:21  clip
   uri: small fix

   Revision 1.87  2004/06/11 11:47:27  clip
   uri: small fix in "set printer to membuf"

   Revision 1.86  2004/06/11 10:15:14  clip
   rust: SET PRINTER TO MEMBUF

   Revision 1.85  2004/02/25 09:12:19  clip
   uri: SIGSEGV fixed in set(_SET_ROOTPATH)

   Revision 1.84  2004/02/05 11:03:46  clip
   rust: common ClipMachine->kbdbuf

   Revision 1.83  2004/01/04 10:24:50  clip
   uri: add set(_SET_ROOTPATH,"rootpath") for add "rootpath" to all filenames,
		via "/var/www/htdocs" in apache.

   Revision 1.82  2003/11/20 13:59:35  clip
   uri: small fix

   Revision 1.81  2003/11/19 11:48:25  clip
   add FLUSHOUT_FLAG, _SET_FLUSHOUT to set
   paul

   Revision 1.80  2003/09/08 15:06:03  clip
   uri: next step fixes for mingw from uri

   Revision 1.79  2003/09/04 14:04:41  clip
   *** empty log message ***

   Revision 1.78  2003/09/02 14:27:42  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.77  2003/08/04 12:50:33  clip
   uri: get object support datetime type and small fix in set(_SET_SECONDS)

   Revision 1.76  2003/02/18 11:02:05  clip
   uri: small fix

   Revision 1.75  2003/02/10 13:04:47  clip
   rust: SET MULTILOCKS ON|OFF (FlagShip extension)

   Revision 1.74  2003/02/02 12:23:36  clip
   uri: FT_COLOR2N() added

   Revision 1.73  2002/11/20 09:18:16  clip
   SET(_SET_ESC_DELAY[, <nMilliseconds>]) -> nOldMilliseconds
   get/set Esc timeout in milliseconds; default == 300 ms
   closes #50
   paul

   Revision 1.72  2002/10/29 13:29:45  clip
   rust: SET INDEX BUFFER LIMIT [TO] <n_Megabytes>
	  SET MAP FILE ON|OFF

   Revision 1.71  2002/10/02 12:21:55  clip
   uri: added "set buffring on|off" and changed fileIO functions for it.

   Revision 1.70  2002/09/02 06:16:26  clip
   uri:small fix

   Revision 1.69  2002/09/02 06:15:50  clip
   uri: add default extensions for printfile,altfile,extrafile

   Revision 1.68  2002/09/02 05:41:03  clip
   uri: small fix in achoice, setmode(O_BINARY) for print,alt,extra file fopen()

   Revision 1.67  2002/08/12 09:38:59  clip
   uri: added ntocolor()

   Revision 1.66  2002/06/10 06:22:29  clip
   uri: small fix for "set devaice to PRINT | PRINTER | SCREEN"

   Revision 1.65  2002/05/27 09:52:41  clip
   uri: added "set fopen mode DOS|POSIX"

   Revision 1.64  2002/05/20 12:01:48  clip
   make _clip_fullsceen  global
   paul

   Revision 1.63  2002/05/16 09:07:43  clip
   possible to disable expansion in strings:
   SET MACRO_IN_STRING OFF
   paul

   Revision 1.62  2002/04/30 07:37:55  clip
   uri: fix inkey(NIL,mask)

   Revision 1.61  2002/04/28 13:50:43  clip
   SET HOURS [TO] 12|24
   SET SECONDS ON|OFF
   rust

   Revision 1.60  2002/04/24 09:51:13  clip
   _SET_DISPBOX turn off pg char translation
   paul

   Revision 1.59  2002/04/11 15:42:23  clip
   uri: set(_SET_DISPBOX) - dispbox over dispout()

   Revision 1.58  2002/02/28 11:05:49  clip
   uri: bugs in bummash fixed

   Revision 1.57  2002/02/28 08:50:10  clip
   add _SET_MAPERR
   with .t. map fetch will return NIL if no index instead of error generation
   paul

   Revision 1.56  2002/02/14 12:31:58  clip
   uri: fixed bug in CURDIR()

   Revision 1.55  2002/02/03 10:32:35  clip
   uri: iscolor() & fullscreen()

   Revision 1.54  2002/01/16 15:29:08  clip
   chinese patch
   preproc bugs
   some pseudographic chars < 32
   paul

   Revision 1.53  2001/12/12 15:34:09  clip
   SET LOCKSTYLE [TO] CLIPPER | CLIPPER50 | CLIPPER52 | CLIPPER53 | FOXPRO | SIX
   rust

   Revision 1.52  2001/12/10 08:08:51  clip
   uri: setcleara(), getcleara() added

   Revision 1.51  2001/11/27 11:44:46  clip
   add mouse control functions:

   INKEY(timeout, [nEventMask])
   NEXTKEY - use system eventMask
   SET(_SET_EVENTMASK)
   MPRESENT() --> lIsPresent
   MHIDE()
		  note: not fully compatible (parameters are ignored)
   MSHOW()
		  note: not fully compatible (parameters are ignored)
   MSETCURSOR( [<lVisible>] ) --> lIsVisible
   MROW() --> nMouseRow
   MCOL() --> nMouseCol
   MLEFTDOWN() --> lIsPressed
   MRIGHTDOWN() --> lIsPressed
   MSETBOUNDS( [<nTop>], [<nLeft>], [<nBottom>], [<nRight>] ) --> NIL
   MSAVESTATE() --> cSaveState
   MRESTSTATE( <cSaveState> ) --> NIL
   MDBLCLK([<nNewSpeed>]) --> nSpeed
		  note: really not work
   MSETPOS( <nRow>, <nCol> ) --> NIL
		  note: really not work
   MSTATE() --> aState | 0

   paul

   Revision 1.50  2001/11/21 09:14:32  clip
   uri: remake __setCenture & set(_SET_DATEFORMAT)

   Revision 1.49  2001/11/13 12:23:00  clip
   SET DEFAULT TO without path sets "." now
   rust

   Revision 1.48  2001/11/01 14:54:40  clip
   _clip_path() - makes absolute path respecting SET DEFAULT, SET PATH etc
   rust

   Revision 1.47  2001/10/31 13:26:30  clip
   uri: set default && set alternate bugs fixed

   Revision 1.46  2001/09/28 13:58:29  clip
   SET OPTIMIZE LEVEL [TO] <1|2>
   rust

   Revision 1.45  2001/09/26 11:40:02  clip
   uri: setcancel() bug fixed

   Revision 1.44  2001/09/09 08:57:24  clip
   uri: bugs:  free(mp->altfile) with NULL value

   Revision 1.43  2001/09/07 10:39:58  clip
   uri: fixed bug "set default && set alternate"

   Revision 1.42  2001/09/01 11:24:34  clip
   uri: bug in set.c with parameters "OFF"

   Revision 1.41  2001/09/01 11:07:31  clip
   uri: bug in set_flagX with parameter NIL

   Revision 1.40  2001/08/02 07:15:18  clip
   uri: set printer to, altFile,ExatraFile && fileCreateMode

   Revision 1.39  2001/07/31 09:25:46  clip
   uri: add FILE&DIR CREATE MODE in format "nnn"

   Revision 1.38  2001/07/31 08:21:50  clip
   uri: add SET_FILECREATEMODE & SET_DIRCREATEMODE and fixed in functions

   Revision 1.37  2001/07/27 12:16:23  clip
   SET PRINTER OFF force printer stream flushing
   paul

   Revision 1.36  2001/07/26 11:48:37  clip
   after
   set ('PRINTER_CHARSET', 'cp866')
   and
   set printer to asdf
   all output to printer will be recoded from CLIP_HOSTCS to PRINTER_CHARSET
   if PRINTER_CHARSET is not setted, recode from CLIP_HOSTCS to CLIP_CLIENTCS
   paul

   Revision 1.35  2001/06/18 11:30:44  clip
   fixes in SET DEFAULT ...
   rust

   Revision 1.34  2001/06/11 10:31:20  clip
   _SET_OPTIMIZE, OPTIMIZE_FLAG added
   rust

   Revision 1.33  2001/06/06 13:41:41  clip
   fix in SET DEFAULT TO ...
   rust

   Revision 1.32  2001/06/03 13:15:16  clip
   _SET_MBLOCKSIZE added. Default is 64.
   rust

   Revision 1.31  2001/05/03 10:38:01  clip
   *** empty log message ***

   Revision 1.30  2001/04/22 12:50:57  clip
   autoopen, autoorder added
   rust

   Revision 1.29  2001/04/11 07:39:54  clip
   set alternate cleanup
   paul

   Revision 1.28  2001/04/10 12:11:19  clip
   uri: add command "set translate path"

   Revision 1.27  2001/04/03 09:17:01  clip
   license errors
   paul

   Revision 1.26  2001/03/30 11:51:03  clip
   add copyright

   Revision 1.25  2000/11/04 11:08:29  clip
   bug in set(_SET_CANCEL), заткнут но не выправил
   from uri:

   Revision 1.24  2000/10/31 11:50:07  clip
   setcancel and set(_SET_CANCEL)
   paul

   Revision 1.23  2000/10/27 07:57:16  clip
   rational gluks
   paul

   Revision 1.22  2000/10/20 08:03:24  clip
   Вкрутил rational везде где упоминается NUMERIC_t
   может чего и осталось неотловленное, но это может быть только в тех
   местах где нет использования NUMERIC_t !!!!!
   from uri:

   Revision 1.21  2000/05/30 22:46:09  clip
   uri: print logging

   Revision 1.20  2000/05/30 19:22:58  clip
   uri: make function getclearb()

   Revision 1.19  2000/05/30 19:10:15  clip
   uri: make function setclearb()

   Revision 1.18  2000/05/30 15:22:50  clip
   uri: function colorselect and io color

   Revision 1.17  2000/05/24 18:34:40  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.16  2000/05/23 18:59:55  clip
   append window functions
   Paul Lasarev <paul@itk.ru>

   Revision 1.15  2000/05/19 20:23:21  clip
   setcolor
   Paul Lasarev <paul@itk.ru>

   Revision 1.14  2000/05/19 19:35:54  clip
   add colors 5/10
   SETCOLOR(,.t.) produce color string in NUM/NUM format
   Paul Lasarev <paul@itk.ru>

   Revision 1.13  2000/05/03 21:39:16  clip
   add set cursor shape

   Revision 1.12  2000/05/03 19:32:42  clip
   add prefix 'clip_' to all clip functions

   Revision 1.11  2000/04/28 19:01:12  clip
   tmpname fix

   Revision 1.10  2000/04/28 17:55:29  clip

   bsd fixes

   Revision 1.9  2000/03/30 17:04:09  uri
   переделал под новые вызовы ошибок

   Revision 1.8  2000/03/24 19:49:59  uri
   set(_SET_LOGFILE)

   Revision 1.7  2000/03/24 17:27:59  uri
   bug in set(_SET_LOGLEVEL) and _clip_loglevel

   Revision 1.6  2000/03/24 17:22:48  uri
   make set(_SET_LOGLEVEL)

   Revision 1.5  2000/03/09 21:50:28  paul
   warnigns

   Revision 1.4  2000/03/03 21:37:42  paul
   preprocessor bug fix, warnings removed

   Revision 1.3  1999/11/17 22:27:23  uri
   Немного стринг-функций из тоолсов сделал

   Revision 1.2  1999/10/26 19:11:37  paul
   start cvs logging

 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <limits.h>
#include <fcntl.h>

#include "clip.h"
#include "clipcfg.h"

#ifdef OS_CYGWIN
	#include <io.h>
#endif

#include "set.ch"
#include "screen/screen.h"
#include "hashcode.h"
#include "rational.h"
#include "screen/charset.h"

extern char *_get_unix_name(ClipMachine * cm, char *dname);
static void set_printer_charset(ClipMachine * mp);

static void
set_flag0(ClipMachine * mp, int flag, int beg)
{
	_clip_retl(mp, mp->flags & flag);
	if (mp->argc > beg)
	{
		int lp = -1;
		ClipVar *vp;

		vp = _clip_par(mp, beg + 1);
		switch (vp->t.type)
		{
		case LOGICAL_t:
			lp = vp->l.val;
			break;
		case NUMERIC_t:
			lp = _clip_double(vp);
			lp = (lp != 0);
			break;
		case CHARACTER_t:
			{
				char *s = _clip_parc(mp, beg + 1);

				if (!strcasecmp(s, "on"))
					lp = 1;
				else
					lp = 0;
			}
			break;
		default:
			break;
		}

		if (lp != -1)
		{
			if (lp)
				mp->flags |= flag;
			else
				mp->flags &= ~flag;
		}
	}
}

static void
set_flag(ClipMachine * mp, int flag)
{
	return set_flag0(mp, flag, 1);
}

static void
set_flag1(ClipMachine * mp, int flag, int beg, int inverse)
{
	_clip_retl(mp, mp->flags1 & flag);
	if (mp->argc > beg)
	{
		int lp = -1;
		ClipVar *vp;

		vp = _clip_par(mp, beg + 1);
		switch (vp->t.type)
		{
		case LOGICAL_t:
			lp = vp->l.val;
			break;
		case NUMERIC_t:
			lp = _clip_double(vp);
			lp = (lp != 0);
			break;
		case CHARACTER_t:
			{
				char *s = _clip_parc(mp, beg + 1);

				if (!strcasecmp(s, "on"))
					lp = 1;
				else
					lp = 0;
			}
			break;

		default:
			break;
		}

		if (lp != -1)
		{
			if (inverse)
			{
				if (lp)
					mp->flags1 &= ~flag;
				else
					mp->flags1 |= flag;
			}
			else
			{
				if (lp)
					mp->flags1 |= flag;
				else
					mp->flags1 &= ~flag;
			}
		}
	}
}

static int
_clip_addExtToFile(char *buf,int maxlen, const char *sExt)
{
	int len=strlen(buf);
	int len2=strlen(sExt);
	int i=len,j;
		int extExist = 0;
		/* filename begin from end string*/
		for (; i>=0; i--)
		{
			if (buf[i] == '/')
					break;
			if (buf[i] == '\\')
					break;
			if (buf[i] == ':')
					break;
		}
		/* ext exist ? */
		for (; i < len ; i++)
		{
			if ( buf[i] == '.' )
					extExist = 1;
		}
	i=len;
		if (!extExist && i < (maxlen-(len2+1)) )
		{
			buf[i] = '.';
				for (j=0,i++; j<len2; j++, i++)
				buf[i] = sExt[j];
				buf[i]=0;
				extExist = 1;
		}
		else
			extExist = 0;
		return extExist;
}

static void
set_color(ClipMachine * mp, char *str)
{
	char *s;
	int no = 0, attr, ls, l;

	if ( strchr(str,'X') || strchr(str,'x') )
	{
		mp->attr.standard = 0;
		mp->attr.enhanced = 0;
		mp->attr.border = 0;
		mp->attr.background = 0;
		mp->attr.unselected = 0;
		mp->attr.u1 = 0;
		mp->attr.u2 = 0;
		mp->attr.u3 = 0;
		mp->attr.u4 = 0;
		mp->attr.u5 = 0;
	}
	for (s = str; s && *s && no < 10; ++no)
	{
		ls = strspn(s, " \t\n\r");
		l = strcspn(s, ",");

		if (l != ls)
		{
			attr = _clip_str2attr(s, l);
			s += l;
			if (*s)
				++s;
		}
		else
		{
			s += l;
			if (*s)
				++s;
			continue;
		}

		switch (no)
		{
		case 0:
			mp->attr.standard = attr;
			break;
		case 1:
			mp->attr.enhanced = attr;
			mp->attr.unselected = attr;
			break;
		case 2:
			mp->attr.border = attr;
			break;
		case 3:
			mp->attr.background = attr;
			break;
		case 4:
			mp->attr.unselected = attr;
			break;
		case 5:
			mp->attr.u1 = attr;
			break;
		case 6:
			mp->attr.u2 = attr;
			break;
		case 7:
			mp->attr.u3 = attr;
			break;
		case 8:
			mp->attr.u4 = attr;
			break;
		case 9:
			mp->attr.u5 = attr;
			break;
		}
	}
}

static void
get_color(ClipMachine * mp, char *buf, int buflen, int get_num)
{
	int no;
	char *s, *e;
	int l;

	for (no = 0, s = buf, e = buf + buflen - 1; s < e && no < 10; ++no)
	{
		int attr = 0;

		if (no)
			*s++ = ',';

		switch (no)
		{
		case 0:
			attr = mp->attr.standard;
			break;
		case 1:
			attr = mp->attr.enhanced;
			break;
		case 2:
			attr = mp->attr.border;
			break;
		case 3:
			attr = mp->attr.background;
			break;
		case 4:
			attr = mp->attr.unselected;
			break;
		case 5:
			attr = mp->attr.u1;
			break;
		case 6:
			attr = mp->attr.u2;
			break;
		case 7:
			attr = mp->attr.u3;
			break;
		case 8:
			attr = mp->attr.u4;
			break;
		case 9:
			attr = mp->attr.u5;
			break;
		}

		l = _clip_attr2str(attr, s, e - s, get_num);

		s += l;
	}
	*s = 0;
}

int
_clip_close_printer(ClipMachine * mp)
{
	FILE *printer = (FILE *) mp->printer;

	if (!printer)
		return 0;

	fclose(printer);
	mp->printer = 0;
	if (mp->real_prfile != mp->prfile)
	{
		char buf[256], *sp = mp->prfile;
		int prno = 0;

		char *p_prog;
		/*setenv("CLIP_PRINT_PROG","lpr",0);*/
		p_prog = getenv("CLIP_PRINT_PROG");
		if (!p_prog || !*p_prog)
			p_prog = "lpr";

#if 0
		if (!strcasecmp(sp, "lpt2") || !strcasecmp(sp, "lpt2:"))
			prno = 2;
		else if (!strcasecmp(sp, "lpt3") || !strcasecmp(sp, "lpt3:"))
			prno = 3;
/*
		elseif (!strcasecmp(sp, "lpt1") || !strcasecmp(sp, "lpt1:"))
			prno = 1;
*/
#else
		if (!strncasecmp(sp, "lpt",3) && strlen(sp) >3 && sp[3]>='1' && sp[3]<='9' )
			prno = atoi(sp+3);
		if ( prno <= 1 )
			prno = 0;
#endif
#ifndef _WIN32
		if (prno)
		       snprintf(buf, sizeof(buf), "%s -P lp%d %s 2>&1 >/dev/null", p_prog, prno, mp->real_prfile);
		else
		       snprintf(buf, sizeof(buf), "%s %s 2>&1 >/dev/null", p_prog, mp->real_prfile);
#else
		snprintf(buf, sizeof(buf), "copy /b %s %s >null", mp->real_prfile, mp->prfile);
#endif
		system(buf);
		_clip_logg(2, "close printer:%s", buf);
		remove(mp->real_prfile);
		free(mp->real_prfile);
	}
	free(mp->prfile);

	mp->prfile = 0;
	mp->real_prfile = 0;
	return 0;
}

int
clip___SETCENTURY(ClipMachine * mp)
{
	int c_flag = (mp->flags & CENTURY_FLAG);
	char *s, *e, *new_format, ch = 'y';
	int i, j, pos[10];

	set_flag0(mp, CENTURY_FLAG, 0);

	/* remake data of SET DATE FORMAT */
	new_format = calloc(1, 11);
	e = mp->date_format + strlen(mp->date_format);
	for (i = 0, s = mp->date_format; s < e; s++)
	{
		if (*s != 'y' && *s != 'Y')
			continue;
		if (*s == 'Y')
			ch = 'Y';
		pos[i] = s - mp->date_format;
		i++;
	}
	/* new CENTURY setting -> ON */
	if (mp->flags & CENTURY_FLAG)
	{
		if (i != 2)
		{
			_clip_retl(mp, c_flag);
			return 0;
		}
		strcpy(new_format, mp->date_format);
		new_format[pos[1] + 1] = ch;
		new_format[pos[1] + 2] = ch;
		for (i = pos[1] + 3, s = mp->date_format + pos[1] + 1; s < e; s++, i++)
			new_format[i] = *s;
		new_format[i] = 0;
	}
	/* new CENTURY setting -> OFF */
	else
	{
		if (i < 4)
		{
			_clip_retl(mp, c_flag);
			return 0;
		}
		for (i = 0, j = 0, s = mp->date_format; s < e; s++, i++)
		{
			if (i == pos[2] || i == pos[3])
				continue;

			new_format[j] = *s;
			j++;
		}
		new_format[j] = 0;
	}

	if (mp->date_format != NULL)
		free(mp->date_format);

	mp->date_format = new_format;
	_clip_retl(mp, c_flag);
	return 0;
}

int
clip_SETCANCEL(ClipMachine * mp)
{
	int l = -1;
	char *str = NULL;

	_clip_retl(mp, !mp->notcancel);

	if (_clip_parinfo(mp, 1) == LOGICAL_t)
		l = _clip_parl(mp, 1);
	if (_clip_parinfo(mp, 1) == CHARACTER_t)
		str = _clip_parc(mp, 1);

	if (_clip_parinfo(mp, 2) == LOGICAL_t)
		l = _clip_parl(mp, 2);
	if (_clip_parinfo(mp, 2) == CHARACTER_t)
		str = _clip_parc(mp, 2);

	if (str != NULL)
		l = !strcasecmp(str, "on");

	if (l >= 0)
	{
		if (mp->fullscreen)
			setCtrlBreak_Screen(mp->screen, l);
		mp->notcancel = !l;
	}

	return 0;
}

int
clip_SET(ClipMachine * mp)
{
	int opt = _clip_parni(mp, 1);
	int lp;
	int argc = mp->argc;
	char *sp;

	switch (opt)
	{
	case _SET_LOGLEVEL:
		if (_clip_parinfo(mp, 2) == NUMERIC_t)
			_clip_retni(mp, _clip_loglevel(_clip_parni(mp, 2)));
		else
			_clip_retni(mp, _clip_loglevel(-1));
		break;
	case _SET_LOGFILE:
		if (_clip_parinfo(mp, 2) == CHARACTER_t)
		{
			sp = _get_unix_name(mp, _clip_parc(mp, 2));
			_clip_log_init(sp);
			free(sp);
			_clip_retl(mp, 1);
		}
		else
			_clip_retl(mp, 0);

		break;
	case _SET_EXACT:
		set_flag(mp, EXACT_FLAG);
		break;
	case _SET_FIXED:
		set_flag(mp, FIXED_FLAG);
		break;
	case _SET_DECIMALS:
		_clip_retni(mp, mp->decimals);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			mp->decimals = lp;
		}
		break;
	case _SET_FILECREATEMODE:
		_clip_retni(mp, mp->fileCreateMode);
		lp = -1;
		if (argc > 1)
		{
			if (_clip_parinfo(mp, 2) == CHARACTER_t)
				lp = _clip_fileStrModeToNumMode(_clip_parc(mp, 2));
			if (_clip_parinfo(mp, 2) == NUMERIC_t)
				lp = _clip_parni(mp, 2);
			if (lp > 0)
				mp->fileCreateMode = lp;
		}
		break;
	case _SET_DIRCREATEMODE:
		_clip_retni(mp, mp->dirCreateMode);
		lp = -1;
		if (argc > 1)
		{
			if (_clip_parinfo(mp, 2) == CHARACTER_t)
				lp = _clip_fileStrModeToNumMode(_clip_parc(mp, 2));
			if (_clip_parinfo(mp, 2) == NUMERIC_t)
				lp = _clip_parni(mp, 2);
			if (lp > 0)
				mp->dirCreateMode = lp;
		}
		break;
	case _SET_DATEFORMAT:
		_clip_retc(mp, mp->date_format);
		if (argc > 1 && (sp = _clip_parc(mp, 2)))
		{
			int i, ycount = 0;

			free(mp->date_format);
			mp->date_format = strdup(sp);
			for (i = 0; sp[i] != 0; i++)
			{
				if (sp[i] == 'y' || sp[i] == 'Y')
					ycount++;
			}
			if (ycount > 3)
				mp->flags |= CENTURY_FLAG;
			else
				mp->flags &= ~CENTURY_FLAG;
		}
		break;
	case _SET_EPOCH:
		_clip_retni(mp, mp->epoch);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			mp->epoch = lp;
		}
		break;
	case _SET_PATH:
		_clip_retc(mp, mp->path);
		if (argc > 1 && (sp = _clip_parc(mp, 2)))
		{
			free(mp->path);
			mp->path = strdup(sp);
		}
		break;
	case _SET_DEFAULT:
		_clip_retc(mp, mp->defaul);
		if (argc > 1 && (sp = _clip_parc(mp, 2)))
		{
			if (mp->defaul)
				free(mp->defaul);
			if (sp[0])
				mp->defaul = strdup(sp);
			else
				mp->defaul = strdup(".");
		}
		break;
	case _SET_EXCLUSIVE:
		set_flag(mp, EXCLUSIVE_FLAG);
		break;
	case _SET_SOFTSEEK:
		set_flag(mp, SOFTSEEK_FLAG);
		break;
	case _SET_UNIQUE:
		set_flag(mp, UNIQUE_FLAG);
		break;
	case _SET_DELETED:
		set_flag(mp, DELETED_FLAG);
		_clip_set_deleted(mp, !(mp->flags & DELETED_FLAG));
		break;
	case _SET_CANCEL:
		return clip_SETCANCEL(mp);
		break;
	case _SET_DEBUG:
		set_flag(mp, DEBUG_FLAG);
		break;
	case _SET_TYPEAHEAD:
		_clip_retni(mp, mp->typeahead);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			if (lp < 16)
				lp = 16;
			mp->typeahead = lp;
			mp->kbdbuf = (int *) realloc(mp->kbdbuf, lp * sizeof(int));

			*mp->kbdptr = mp->kbdbuf;
		}
		break;

	case _SET_COLOR:
		{
			char buf[64];

			get_color(mp, buf, sizeof(buf), 0);
			_clip_retc(mp, buf);
			if (argc > 1 && (sp = _clip_parc(mp, 2)))
			{
				if (*sp)
					set_color(mp, sp);
				else
					set_color(mp, DEFAULT_COLOR);
			}
		}
		break;
	case _SET_CURSOR:
		_clip_retni(mp, mp->cursor);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			mp->cursor = lp;
		}
		break;
	case _SET_CONSOLE:
		set_flag(mp, CONSOLE_FLAG);
		break;
	case _SET_ALTERNATE:
		set_flag(mp, ALTERNATE_FLAG);
		break;
	case _SET_ALTFILE:
		_clip_retc(mp, mp->altfile);
		if (argc > 1 && (sp = _clip_parc(mp, 2)))
		{
			FILE *alt = (FILE *) mp->alt;
			char *mode;
			char buf[PATH_MAX];

			if (_clip_parl(mp, 3))
				mode = "a";
			else
				mode = "w";
			if (alt && alt != stdout)
				fclose(alt);
			if (sp && sp[0])
			{
				if (_clip_path(mp, sp, buf, sizeof(buf), 1))
				{
					_clip_trap_printf(mp, __FILE__, __LINE__, "%s: '%s'", strerror(errno), buf);
					return 1;
				}

								_clip_addExtToFile(buf,PATH_MAX,"txt");
				sp = strdup(buf);

				if (access(sp, F_OK) != 0)
					close(creat(sp, mp->fileCreateMode));
				alt = fopen(sp, mode);
				if (!alt)
				{
					_clip_trap_printf(mp, __FILE__, __LINE__, "%s: '%s'", strerror(errno), sp);
					return 1;
				}
#ifdef _WIN32
				setmode(fileno(alt),O_BINARY);
#endif
				if (mp->altfile != NULL)
					free(mp->altfile);
				mp->altfile = sp;
				mp->alt = alt;
			}
			else
			{
				if (mp->altfile != NULL)
					free(mp->altfile);
				mp->alt = 0;
				mp->altfile = 0;
			}
		}
		break;
	case _SET_DEVICE:
		_clip_retc(mp, (mp->flags & DEVICE_FLAG) ? "PRINTER" : "SCREEN");
		if (argc > 1 && (sp = _clip_parc(mp, 2)))
		{
			if (!strcasecmp(sp, "PRINTER"))
				mp->flags |= DEVICE_FLAG;
			else if (!strcasecmp(sp, "PRINT"))
				mp->flags |= DEVICE_FLAG;
			else
				mp->flags &= ~DEVICE_FLAG;
		}
		break;
	case _SET_EXTRA:
		set_flag(mp, EXTRA_FLAG);
		break;
	case _SET_EXTRAFILE:
		_clip_retc(mp, mp->extrafile);
		if (argc > 1 && (sp = _clip_parc(mp, 2)))
		{
			FILE *extra = (FILE *) mp->extra;
			char *mode;
			char buf[PATH_MAX];

			if (_clip_parl(mp, 3))
				mode = "a";
			else
				mode = "w";
			if (extra && extra != stdout)
				fclose(extra);
			if (sp && sp[0])
			{
				if (_clip_path(mp, sp, buf, sizeof(buf), 1))
				{
					_clip_trap_printf(mp, __FILE__, __LINE__, "%s: '%s'", strerror(errno), buf);
					return 1;
				}

								_clip_addExtToFile(buf,PATH_MAX,"txt");
				sp = strdup(buf);

				if (access(sp, F_OK) != 0)
					close(creat(sp, mp->fileCreateMode));
				extra = fopen(sp, mode);
				if (!extra)
				{
					_clip_trap_printf(mp, __FILE__, __LINE__, "%s: '%s'", strerror(errno), sp);
					return 1;
				}
				if (mp->extrafile != NULL)
					free(mp->extrafile);
#ifdef _WIN32
				setmode(fileno(extra),O_BINARY);
#endif
				mp->extrafile = sp;
				mp->extra = extra;
			}
			else
			{
				if (mp->extrafile != NULL)
					free(mp->extrafile);
				mp->extra = 0;
				mp->extrafile = 0;
			}
		}
		break;
	case _SET_PRINTER:
		set_flag(mp, PRINTER_FLAG);
		if (!(mp->flags & PRINTER_FLAG) && mp->printer)
			fflush((FILE *) mp->printer);
		break;
	case _SET_PRINTFILE:
		_clip_retc(mp, mp->prfile);
		if (argc <= 1)
			break;

		_clip_close_printer(mp);

		if(_clip_parinfo(mp,2) != CHARACTER_t)
			break;

		sp = _clip_parc(mp, 2);
		if ( !sp || !(*sp) )
			break;

		if(mp->pbuf)
		{
			destroy_Buf(mp->pbuf);
			free(mp->pbuf);
			mp->pbuf = 0;
		}
		if( strncmp(sp,"MEMBUF",6) == 0)
		{
			mp->pbuf = calloc(1,sizeof(OutBuf));
			init_Buf(mp->pbuf);
		}
		else
		{
			/* create file for printer output */
			FILE *printer;
			char *mode;

			if (_clip_parl(mp, 3))
				mode = "a";
			else
				mode = "w";

			if (!strcasecmp(sp, "prn") || !strcasecmp(sp, "prn:")
#if 0
				|| !strcasecmp(sp, "lpt1") || !strcasecmp(sp, "lpt1:")
				|| !strcasecmp(sp, "lpt2") || !strcasecmp(sp, "lpt2:")
				|| !strcasecmp(sp, "lpt3") || !strcasecmp(sp, "lpt3:")
#else
				|| (!strncasecmp(sp, "lpt", 3) && strlen(sp)>3 && sp[3]>='1' && sp[3]<='9' )
#endif
				)
			{
				char buf[256];

				snprintf(buf, sizeof(buf), "prn-%s-%lx%lx", _clip_progname,
					 (long) getpid(), (long) random());
				mp->real_prfile = strdup(buf);
				mp->prfile = strdup(sp);
			}
			else
			{
				char buf[PATH_MAX];

				_clip_translate_path(mp, sp, buf, sizeof(buf));
				_clip_addExtToFile(buf,PATH_MAX,"prn");
				mp->real_prfile = mp->prfile = strdup(buf);
			}

			if (access(mp->real_prfile, F_OK) != 0)
				close(creat(mp->real_prfile, mp->fileCreateMode));
			printer = fopen(mp->real_prfile, mode);
			_clip_logg(2, "set print to:%s,%s", mp->real_prfile, mp->prfile);

			if (!printer)
			{
				_clip_trap_printf(mp, __FILE__, __LINE__,
				"cannot open printer file '%s': %s", sp, strerror(errno));
				if (mp->real_prfile != mp->prfile)
					free(mp->real_prfile);
				free(mp->prfile);
				mp->real_prfile = 0;
				mp->prfile = 0;
				return 1;
			}
#ifdef _WIN32
			setmode(fileno(printer),O_BINARY);
#endif
			mp->printer = printer;
			set_printer_charset(mp);
		}
		break;
	case _SET_MARGIN:
		_clip_retni(mp, mp->margin);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			if (lp < 0)
				lp = 0;
			mp->margin = lp;
		}
		break;

	case _SET_BELL:
		set_flag(mp, BELL_FLAG);
		break;
	case _SET_CONFIRM:
		set_flag(mp, CONFIRM_FLAG);
		break;
	case _SET_ESCAPE:
		set_flag(mp, ESCAPE_FLAG);
		break;
	case _SET_INSERT:
		set_flag(mp, INSERT_FLAG);
		break;
	case _SET_EXIT:
		set_flag(mp, EXIT_FLAG);
		break;
	case _SET_INTENSITY:
		set_flag(mp, INTENSITY_FLAG);
		break;
	case _SET_SCOREBOARD:
		set_flag(mp, SCOREBOARD_FLAG);
		break;
	case _SET_DELIMITERS:
		set_flag(mp, DELIMITERS_FLAG);
		break;
	case _SET_DELIMCHARS:
		_clip_retc(mp, mp->delimchars);
		if (argc > 1 && (sp = _clip_parc(mp, 2)))
		{
			free(mp->delimchars);
			mp->delimchars = strdup(sp);
		}
		break;

	case _SET_WRAP:
		set_flag(mp, WRAP_FLAG);
		break;
	case _SET_MESSAGE:
		_clip_retni(mp, mp->msgline);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			if (lp < 0)
				lp = 0;
			mp->msgline = lp;
		}
		break;
	case _SET_MCENTER:
		set_flag(mp, MCENTER_FLAG);
		break;
	case _SET_SCROLLBREAK:
		set_flag(mp, SCROLLBREAK_FLAG);
		break;
	case _SET_RATIONAL:
		set_flag(mp, RATIONAL_FLAG);
		break;
	case _SET_TRANSLATE_PATH:
		set_flag(mp, TRANSLATE_FLAG);
		break;
	case _SET_AUTOPEN:
		set_flag1(mp, AUTOPEN_FLAG, 1, 0);
		break;
	case _SET_AUTORDER:
		_clip_retni(mp, mp->autorder);
		mp->autorder = _clip_parni(mp, 2);
		break;
	case _SET_MBLOCKSIZE:
		_clip_retni(mp, mp->mblocksize);
		mp->mblocksize = _clip_parni(mp, 2);
		break;
	case _SET_MAPERR:
		set_flag1(mp, MAPERR_FLAG, 1, 0);
		break;
	case _SET_UTF8TERM:
		set_flag1(mp, UTF8TERM_FLAG, 1, 0);
		break;
	case _SET_IDLE_INKEY:
		set_flag1(mp, IDLEINKEY_FLAG, 1, 0);
		break;
	case _SET_DISPBOX:
		set_flag1(mp, DISPBOX_FLAG, 1, 0);
		if (mp->fullscreen)
		{
			_clip_fullscreen(mp);
			setPgMode_Screen(mp->screen, !(mp->flags1 & DISPBOX_FLAG) );
		}
		break;
	case _SET_OPTIMIZE:
		set_flag1(mp, OPTIMIZE_FLAG, 1, 0);
		break;
	case _SET_MACRO_IN_STRING:
		set_flag1(mp, NOEXPAND_MACRO_FLAG, 1, 1);
		break;
	case _SET_FOPENMODE:
		set_flag1(mp, FOPENMODE_FLAG, 1, 0);
		break;
	case _SET_BUFFERING:
		set_flag1(mp, BUFFERING_FLAG, 1, 0);
		break;
	case _SET_MAP_FILE:
		set_flag1(mp, MAP_FILE_FLAG, 1, 0);
		break;
	case _SET_MULTILOCKS:
		set_flag1(mp, MULTILOCKS_FLAG, 1, 0);
		break;
	case _SET_FLUSHOUT:
		set_flag1(mp, FLUSHOUT_FLAG, 1, 0);
		break;
	case _SET_OPTIMIZELEVEL:
		_clip_retni(mp, mp->optimizelevel + 1);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			if (lp == 1 || lp == 2)
				mp->optimizelevel = lp - 1;
		}
		break;
	case _SET_LOCKSTYLE:
		_clip_retni(mp, mp->lockstyle);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			mp->lockstyle = lp;
		}
		break;
	case _SET_HOURS:
		_clip_retni(mp, mp->hours);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			mp->hours = lp;
		}
		break;
	case _SET_SECONDS:
		_clip_retl(mp, mp->seconds);
		if (argc > 1)
		{
			lp = 0;
			if ( _clip_parinfo(mp,2) == LOGICAL_t )
			{
				lp = _clip_parl(mp, 2);
			//printf("\nset=logical,lp=%d\n",lp);
			}
			if ( _clip_parinfo(mp,2) == CHARACTER_t )
			{
				if ( strncasecmp("ON",_clip_parc(mp,2),2) == 0)
					lp = 1;
			//printf("\nset=%s,lp=%d\n",_clip_parc(mp,2),lp);
			}
			mp->seconds = lp;
		}
		break;
	case _SET_EVENTMASK:
		_clip_retni(mp, mp->eventmask);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			if (lp < 0)
				lp = 0;
			mp->eventmask = lp;
		}
		break;
	case _SET_INDEX_BUFFER_LIMIT:
		_clip_retni(mp, mp->index_buffer_limit);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			if (lp < 0)
				lp = 0;
			mp->index_buffer_limit = lp;
		}
		break;
	case _SET_ESC_DELAY:
		_clip_retni(mp, esc_delay_Screen);
		if (argc > 1)
		{
			lp = _clip_parni(mp, 2);
			if (lp > 0)
				esc_delay_Screen = lp;
		}
		break;

	case _SET_ROOTPATH:
		_clip_retc(mp, mp->rootpath);
		if ( mp->rootpath==NULL && argc > 1 && (sp = _clip_parc(mp, 2)))
		{
			int len;
			len = strlen(sp);
			mp->rootpath = malloc(len+2);
			strcpy(mp->rootpath,sp);
			if (sp[len-1] == '/' || sp[len-1] == '\\')
				;
			else
			{
#ifdef _WIN32
				mp->rootpath[len] = '\\';
#else
				mp->rootpath[len] = '/';
#endif
				mp->rootpath[len+1] = 0;
			}
		}
		break;
	default:
		{
			char *name = _clip_parc(mp, 1);

			if (name)
			{
				char *val;
				long hash;
				hash = _clip_hashstr(name);
				val = _clip_fetch_item(mp, hash);
				if (val)
					_clip_retc(mp, val);
				else
					_clip_retc(mp, "");

				if (argc > 1)
				{
					int len;

					val = _clip_parcl(mp, 2, &len);
					if (val)
						_clip_store_item(mp, hash, _clip_memdup(val, len));
				}

				if ( strlen(name)==2 && name[1]==':' && name[0]>='A' && name[0]<='Z' )
				{
					int clip_INIT__CTOOLS_DISKFUNC(ClipMachine * mp);
					clip_INIT__CTOOLS_DISKFUNC(mp);
				}
			}
		}
	}

	return 0;
}

int
clip_SETCOLOR(ClipMachine * mp)
{
	char buf[64], *sp;
	int get_num = _clip_parl(mp, 2);

	get_color(mp, buf, sizeof(buf), get_num);
	_clip_retc(mp, buf);
	if (mp->argc > 0 && (sp = _clip_parc(mp, 1)))
	{
		if (*sp)
			set_color(mp, sp);
		else
			set_color(mp, DEFAULT_COLOR);
	}
	return 0;
}

int
clip_COLORTON(ClipMachine * mp)
{
	int l, attr = _clip_parni(mp, 1);
	char *s = _clip_parcl(mp, 1, &l);

	if (s != NULL)
		attr = _clip_str2attr(s, l);
	_clip_retni(mp, attr);
	return 0;
}


int
clip_FT_COLOR2N(ClipMachine * mp)
{
	return clip_COLORTON(mp);
}

int
clip_NTOCOLOR(ClipMachine * mp)
{
	int attr = _clip_parni(mp, 1);
		int num_format = _clip_parl(mp,2);
	char *buf ;
		if (attr <0 || attr>0xff)
		{
			_clip_retc(mp,"");
				return 0;
		}
	buf = malloc(32);
	memset(buf,0,32);
	_clip_attr2str(attr, buf, 31, !num_format);
	_clip_retc(mp, buf);
		free(buf);
	return 0;
}

int
clip_INVERTATTR(ClipMachine * mp)
{
	int l,t, attr = _clip_parni(mp, 1);
	char *s = _clip_parcl(mp, 1, &l);

	_clip_retni(mp, 0);
	t = _clip_parinfo(mp,1);

	if (t != NUMERIC_t && t != CHARACTER_t)
		return 0;
	if (t == CHARACTER_t)
		attr = _clip_str2attr(s, l);
	attr = ((attr&0x88)+ ((attr&0x07) << 4) + ((attr&0x70)>>4));
	_clip_retni(mp, attr);
	return 0;
}

int
clip_COLORSELECT(ClipMachine * mp)
{
	mp->colorSelect = _clip_parni(mp, 1);
	return 0;
}

int
clip_STANDARD(ClipMachine * mp)
{
	mp->colorSelect = 0;
	_clip_retc(mp, "");
	return 0;
}

int
clip_UNSELECT(ClipMachine * mp)
{
	mp->colorSelect = 4;
	_clip_retc(mp, "");
	return 0;
}

int
clip_ENHANCED(ClipMachine * mp)
{
	mp->colorSelect = 1;
	_clip_retc(mp, "");
	return 0;
}

int
clip_SETCLEARB(ClipMachine * mp)
{
	int ch = _clip_parni(mp, 1);
	char *s = _clip_parc(mp, 1);
	int *set = _clip_fetch_item(mp, HASH_setclearb);

	if (s != NULL)
		ch = (*s);
	ch = (ch % 0xff);
	*((char *) set) = (char) ch;
	_clip_retc(mp, "");

	return 0;
}

int
clip_GETCLEARB(ClipMachine * mp)
{
	_clip_retni(mp, *((int *) _clip_fetch_item(mp, HASH_setclearb)));
	return 0;
}

int
clip_SETCLEARA(ClipMachine * mp)
{
	int l, attr = _clip_parni(mp, 1);
	char *s = _clip_parcl(mp, 1, &l);
	int *set = _clip_fetch_item(mp, HASH_setcleara);

	if (s != NULL)
		attr = _clip_str2attr(s, l);
	*set = attr;
	_clip_retc(mp, "");
	return 0;
}

int
clip_GETCLEARA(ClipMachine * mp)
{
	_clip_retni(mp, *((int *) _clip_fetch_item(mp, HASH_setcleara)));
	return 0;
}

static void
set_printer_charset(ClipMachine * mp)
{
	char *p1, *p2;
	cons_CharsetEntry *cs1 = 0, *cs2 = 0;
	int len1 = 0, len2 = 0;

	p2 = (char *) _clip_fetch_item(mp, _clip_hashstr("PRINTER_CHARSET"));
	p1 = _clip_getenv("CLIP_HOSTCS");
	if (!p2)
		p2 = _clip_getenv("CLIP_CLIENTCS");
	if (!p1 || !p2 || !*p1 || !*p2)
		goto norm;

	_clip_logg(2, "set printer translation  %s -> %s", p1, p2);

	if (load_charset_name(p1, &cs1, &len1))
	{
		_clip_logg(0, "cannot load charset file '%s': %s", p1, strerror(errno));
		return;
	}

	if (load_charset_name(p2, &cs2, &len2))
	{
		free(cs1);
		_clip_logg(0, "cannot load charset file '%s': %s", p2, strerror(errno));
		return;
	}

	make_translation(cs1, len1, cs2, len2, mp->prntbl);

	free(cs1);
	free(cs2);
	  norm:
		;
}
