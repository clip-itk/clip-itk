/*
	Copyright (C) 2001  ITK
	Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log: _string.c,v $
   Revision 1.111  2004/10/28 11:47:32  clip
   uri: fix formatiing in STR(), pad*() for numeric data and constants.

   Revision 1.110  2004/10/07 07:52:25  clip
   uri: some fixes and few short func names

   Revision 1.109  2004/09/06 14:02:55  clip
   uri: added strFindBOL(cData,nBegPos) -> backward search BOL in string

   Revision 1.108  2004/08/30 11:51:41  clip
   uri: add strFinfEol(sData,nBegPos) return position of next line

   Revision 1.107  2004/04/30 14:33:38  clip
   rust: buffer overflow in clip_BASE64ENCODE() fixed

   Revision 1.106  2004/04/30 13:47:58  clip
   rust: clip_BASE64ENCODE(sData) -> sEncodedData

   Revision 1.105  2004/04/19 10:59:56  clip
   rust: clip_SPLITDELIM(<str>,<strdelim>,<flddelim>) -> array

   Revision 1.104  2004/03/03 11:59:06  clip
   rust: small fix in ADDSLASH()

   Revision 1.103  2003/11/27 06:44:50  clip
   uri: first command "GETTFILE" in COBrA server

   Revision 1.102  2003/09/21 07:53:58  clip
   uri: small fix in mlcount()

   Revision 1.101  2003/08/04 09:42:20  clip
   uri: small fix

   Revision 1.100  2003/03/23 13:11:10  clip
   uri: fix in memoline()

   Revision 1.99  2003/03/21 09:18:18  clip
   uri: small fix in mlcount(),memoline(),mlpos()

   Revision 1.98  2003/03/20 14:50:29  clip
   uri: fixes in memoline()

   Revision 1.97  2003/02/07 06:18:38  clip
   uri: small fix in FCREATE

   Revision 1.96  2003/02/06 10:56:03  clip
   uri: added CRC16, reconstructed CRC32.

   Revision 1.95  2003/02/02 11:34:04  clip
   uri: crc32() added

   Revision 1.94  2003/01/15 06:14:12  clip
   uri: small fix in mlcount()

   Revision 1.93  2002/12/16 13:06:02  clip
   rust: XUPPER()

   Revision 1.92  2002/08/30 08:24:58  clip
   fix LOWER, UPPER funcs
   paul

   Revision 1.91  2002/08/08 10:12:42  clip
   fix returns
   paul

   Revision 1.90  2002/08/05 08:14:59  clip
   uri: small fixes

   Revision 1.89  2002/07/16 07:43:47  clip
   uri: set("PRINTER_EOL",chr(13)+chr(10)) added

   Revision 1.88  2002/06/25 14:54:12  clip
   uri: isWord() added, small fix in tbrowse

   Revision 1.87  2002/05/08 08:47:14  clip
   rust: BIN2DW() (to unsigned long)

   Revision 1.86  2002/04/21 10:54:16  clip
   uri: fixes for new dbstruct() and patch from druzus.

   Revision 1.85  2002/04/12 09:35:47  clip
   uri: fixes.

   Revision 1.84  2002/04/03 11:41:31  clip
   uri: small fix

   Revision 1.83  2002/03/15 09:48:44  clip
   rust: BIN2B(), B2BIN()

   Revision 1.82  2002/03/10 09:21:20  clip
   uri: fixes in islower,isupper, _clip_cmp

   Revision 1.81  2002/02/28 11:05:49  clip
   uri: bugs in bummash fixed

   Revision 1.80  2002/01/23 10:53:14  clip
   uri: UAT() added

   Revision 1.79  2002/01/08 09:45:17  clip
   uri: isapha,isdigit small fix

   Revision 1.78  2001/12/16 11:55:18  clip
   uri: small fix

   Revision 1.77  2001/11/22 17:06:38  clip
   uri: bugs in koi8-r.uni

   Revision 1.76  2001/11/22 15:12:55  clip
   uri: __dbsort() && small bugs

   Revision 1.75  2001/11/19 11:05:08  clip
   uri: HZ

   Revision 1.72  2001/10/28 06:29:37  clip
   uri: small fix

   Revision 1.71  2001/10/28 06:24:23  clip
   uri: small bugs

   Revision 1.70  2001/10/27 15:30:49  clip
   uri: bug in stuff

   Revision 1.69  2001/10/22 11:38:44  clip
   uri:small bug in addslash()

   Revision 1.68  2001/10/18 07:17:01  clip
   uri: function addslash - as in php

   Revision 1.67  2001/10/03 07:32:31  clip
   removed from _string.c regex... functions and add file _regex.c
   alena

   Revision 1.66  2001/08/23 09:18:34  clip
   add _clip_cmptbl in functions search and regexec
   alena:

   Revision 1.65  2001/04/23 13:53:54  clip
   set console off, alltrim() & nonstring params

   Revision 1.64  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.63  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.62  2001/03/29 06:22:34  clip
   bug in replicate with len <=0

   Revision 1.61  2001/03/26 09:13:05  clip
   bugs in pad*() with len < 0

   Revision 1.60  2001/02/27 09:13:33  clip
   isupper/islower fix
   paul

   Revision 1.59  2001/02/27 09:11:20  clip
   lower/upper
   paul

   Revision 1.58  2001/02/26 11:20:59  clip
   bug in padl()

   Revision 1.57  2001/02/21 12:52:58  clip
   append HASHNAME(hash) - inverce to HASHSTR(str)

   append obj:modify() trigger:
   modify(obj,hash,newval) -> real new val
   MAPMODIFY(obj, enable) switch modify processing

   paul

   Revision 1.56  2001/01/17 15:12:29  clip
   small bug in RIGHT

   Revision 1.55  2001/01/16 10:12:02  clip
   alena: new function in _string.c clip_RGCOMP, clip_RGEXEC, clip_RGCANCEL

   Revision 1.54  2000/12/25 11:12:49  clip
   bug in atalpha

   Revision 1.53  2000/12/21 14:20:57  clip
   atalpha bugs

   Revision 1.52  2000/12/21 13:18:17  clip
   isalpha_tbl in _clip_isalpha    and  atalpha()

   Revision 1.51  2000/12/18 10:20:01  clip
   SEARCH() теперь ищет с REG_NEWLINE, если в начале регулярного выражения
   стоит ^

   Revision 1.50  2000/12/11 12:37:30  clip
   bug in STUFF()
   rust

   Revision 1.49  2000/12/11 11:56:02  clip
   uri: sorry to paul for bad commit search()

   Revision 1.47  2000/12/11 09:47:15  clip
   append setlocale() call
   all libC string functions now must work correct with correct charsets
   paul

   Revision 1.46  2000/12/10 12:49:58  clip
   _clip_cmptbl in search and weightchr

   Revision 1.42  2000/12/06 10:39:32  clip
   alena: remove clipper-comments

   Revision 1.41  2000/11/20 07:03:44  clip
   alena: исправила search - если массив не передается в функцию, то search
   возвращает только .t. or .f.

   Revision 1.40  2000/11/10 13:33:02  clip
   alena: remove next gluck in search function

   Revision 1.39  2000/10/31 10:35:34  clip
   alena: bug in return value

   Revision 1.38  2000/10/31 08:18:18  clip
   alena: еще подправила search

   Revision 1.37  2000/10/31 06:14:34  clip
   alena:  Исправила пожирание памяти в search

   Revision 1.36  2000/10/27 07:50:17  clip
   rational NUMERIC_t gluks
   paul

   Revision 1.35  2000/10/25 11:44:27  clip

   from uri:

   Revision 1.34  2000/10/24 16:31:54  clip
   bug in substr
   from uri:

   Revision 1.33  2000/10/24 12:57:03  clip
   bug in strtran() - chr(0) is not found
   from uri:

   Revision 1.32  2000/10/24 11:24:23  clip
   bug in substr, two argument with minus value
   from uri:

   Revision 1.31  2000/10/20 08:03:23  clip
   Вкрутил rational везде где упоминается NUMERIC_t
   может чего и осталось неотловленное, но это может быть только в тех
   местах где нет использования NUMERIC_t !!!!!
   from uri:

   Revision 1.30  2000/10/16 09:51:05  clip
   create() remake as 'container'
   bug in fwrite()
   from uri:

   Revision 1.29  2000/10/11 11:22:41  clip
   bug in search
   from alena:

   Revision 1.27  2000/07/31 18:49:14  clip
   Новая функция - поиск по регулярному выражению search

   Revision 1.26  2000/07/06 19:56:09  clip
   uri: bug in tabpack
   from uri:

   Revision 1.25  2000/05/31 18:37:30  clip
   uri: big bug in strtran()

   Revision 1.24  2000/05/24 18:33:57  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.23  2000/05/20 20:55:44  clip
   uri: small bug in stuff

   Revision 1.22  2000/05/18 19:42:04  clip
   uri: small make

   Revision 1.21  2000/05/16 15:11:20  clip
   bad realloc in alltrim
   Paul Lasarev <paul@itk.ru>

   Revision 1.20  2000/05/16 02:24:04  clip
   small bug in alltrim

   Revision 1.19  2000/05/15 18:29:30  clip
   uri: bug in strtran()

   Revision 1.18  2000/05/07 00:44:01  clip
   uri: gluk in ltrim,alltrim

   Revision 1.17  2000/05/03 19:32:27  clip
   add prefix 'clip_' to all clip functions

   Revision 1.16  2000/04/21 18:30:53  clip
   ALLTRIM

   Revision 1.15  2000/03/30 16:12:17  uri
   descend

   Revision 1.14  2000/03/30 01:54:07  uri
   переделал под новый _clip_error

   Revision 1.13  1999/12/08 21:01:24  uri
   доделал фйнкции с датами из тулзов

   Revision 1.12  1999/12/04 22:16:37  uri
   вычистил все предупреждения

   Revision 1.11  1999/12/04 16:41:21  uri
   доделал все (кроме strdiff,pack,crypt) строковы функции из тулзов

   Revision 1.10  1999/11/29 22:48:41  uri
   еще немного функций из тулзов

   Revision 1.9  1999/11/27 20:27:05  uri
   added function _clip_isalpha(unsigned cahr ch) to ISALPHA & POSALPHA clipper
   functions

   Revision 1.8  1999/11/27 20:02:02  uri
   added _clip_isalpha_tbl to *_ref.c files

   Revision 1.7  1999/11/27 19:36:05  uri
   added isalpha table

   Revision 1.6  1999/11/23 22:38:19  uri
   еще немного стринговских тулсов

   Revision 1.5  1999/11/17 22:27:22  uri
   Немного стринг-функций из тоолсов сделал

   Revision 1.4  1999/11/17 19:45:18  uri
   begin ctools.c

   Revision 1.3  1999/10/26 19:11:12  paul
   start cvs logging

 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>
#include <sys/types.h>

#include "clip.h"
#include "error.ch"
#include "rational.h"
#include "hash.h"

#include "koi2alt.h"
#include "koi2win.h"
#include "alt2koi.h"
#include "win2koi.h"

#define CS_KOI	1
#define CS_ALT	2
#define CS_WIN	3
#define CS_MAC	4

#define NEW(type)	((type*)calloc(sizeof(type),1))

const char *
_atl(const char *src, const char *dst, int slen, int dlen)
{
	const char *end, *de, *s = src, *d = dst;

	for (end = src + slen, de = dst + dlen - 1; src < end; src++)
		if (*src == *d)
		{
			s = src;
			for (; src < end && d < de && *(++src) == *(++d););
			if (d == de && *src == *d)
				return s;
			src = s;
			d = dst;
		}
	return 0;
}

const char *
_atr(const char *src, const char *dst, int slen, int dlen)
{
	const char *s = src + slen - 1, *d = dst + dlen - 1, *ss = s;

	for (; s >= src; s--)
		if (*s == *d)
		{
			ss = s;
			for (; s >= src && d >= dst && *(--s) == *(--d););
			if (d == dst - 1)
				return s + 1;
			s = ss;
			d = dst + dlen - 1;
		}
	return 0;
}

int
clip_ALLTRIM(ClipMachine * mp)
{
	int vl = 0, rl = 0;
	char *rp, *e;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return 0;
		//return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "ALLTRIM");
	}
	rp = (char *) malloc(vl + 1);
	for (e = vp; e < vp + vl && (*e == ' ' || *e == '\t'); e++);
	rl = vl - (e - vp);
	memcpy(rp, e, rl);
	for (e = rp + rl - 1; e >= rp && (*e == ' ' || *e == '\t'); e--, rl--);
	rp = (char *) realloc(rp, rl + 1);
	rp[rl] = 0;
	_clip_retcn_m(mp, rp, rl);
	return 0;
}

int
clip_LTRIM(ClipMachine * mp)
{
	int vl = 0, rl = 0;
	char *rp, *e, *end;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "LTRIM");
	}
	for (e = vp, end = vp + vl; e < end && (*e == ' ' || *e == '\t'); e++);
	rl = vl - (e - vp);
	rp = (char *) malloc(rl + 1);
	memcpy(rp, e, rl);
	rp[rl] = 0;
	_clip_retcn_m(mp, rp, rl);
	return 0;
}

int
clip_RTRIM(ClipMachine * mp)
{
	int vl = 0, rl = 0;
	char *rp, *e;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "RTRIM");
	}
	for (e = vp + vl - 1; e >= vp && (*e == ' ' || *e == '\t'); e--);
	rl = e - vp + 1;
	rp = (char *) malloc(rl + 1);
	memcpy(rp, vp, rl);
	rp[rl] = 0;
	_clip_retcn_m(mp, rp, rl);
	return 0;
}

int
clip_TRIM(ClipMachine * mp)
{
	return clip_RTRIM(mp);
}

int
clip_AT(ClipMachine * mp)
{
	int i = 1, sl, l, ll;
	const char *ss;
	char *s = _clip_parcl(mp, 1, &sl);
	char *str = _clip_parcl(mp, 2, &l);
	int kol = _clip_parni(mp, 3);

	if (str == NULL || s == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "AT");
	}
	if (kol <= 0)
		kol = 1;
	ss = str;
	while (1)
	{
		ll = l - (ss - str);
		ss = _atl(ss, s, ll, sl);
		if (i == kol && ss != NULL)
		{
			_clip_retni(mp, ss - str + 1);
			break;
		}
		if (ss == NULL)
		{
			_clip_retni(mp, 0);
			break;
		}
		i++;
		ss++;

	}
	return 0;
}

int
clip_ATL(ClipMachine * mp)
{
	return clip_AT(mp);
}

int
clip_RAT(ClipMachine * mp)
{
	int sl, l, ll, i = 1;
	const char *ss;
	char *s = _clip_parcl(mp, 1, &sl);
	char *str = _clip_parcl(mp, 2, &l);
	int kol = _clip_parni(mp, 3);

	if (str == NULL || s == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "RAT");
	}
	if (kol <= 0)
		kol = 1;
	ss = str + l;
	while (1)
	{
		ll = ss - str;
		ss = _atr(str, s, ll, sl);
		if (i == kol && ss != NULL)
		{
			_clip_retni(mp, ss - str + 1);
			break;
		}
		if (ss == NULL)
		{
			_clip_retni(mp, 0);
			break;
		}
		i++;
		ss--;

	}
	return 0;
}

int
clip_ATR(ClipMachine * mp)
{
	return clip_RAT(mp);
}

int
clip_UAT(ClipMachine * mp)
{
	int sl,l,ll;
	char *s    = _clip_parcl(mp, 1, &sl);
	char *str  = _clip_parcl(mp, 2, &l);
	int from   = _clip_parni(mp, 3);
	int to     = _clip_parni(mp, 4);
	int direct = _clip_parni(mp, 5);
		const char * ss = NULL;

	if (str == NULL || s == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "RAT");
	}

	if ( from <= 0 )
		from = 1;
		from -- ;

		if ( to > l  || to<=0 )
			to = l;
		to -- ;

		if ( direct >=0 )
		ss = _atl(str+from, s, to - from + 1, sl);
		else
		ss = _atr(str+from, s, to - from + 1, sl);

		ll = ss - str;
	if (ss == NULL || (ll+sl) > (to+1) )
				_clip_retni(mp,0);
	else
				_clip_retni(mp,ss - str + 1);

	return 0;
}

int
clip_ATALPHA(ClipMachine * mp)
{
	int i, sl;
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 1, &sl);

	if (s == NULL)
	{
		_clip_retni(mp, 0);
		return 0;
	}
	for ( i=0; i<sl && ( (s[i]>' ' && s[i]<='~') ||
				(s[i]>='!' && s[i]<='9') ||
				s[i]=='_' || s[i]=='>' ); i++);

	if ( i<sl )
		_clip_retni(mp,i+1);
	else
		_clip_retni(mp,0);

	return 0;
}

int
clip_STRFINDEOL(ClipMachine * mp)
{
	int i,sl;
	char *s = _clip_parcl(mp, 1, &sl);
	int begpos = _clip_parni(mp, 2);

	if (s == NULL)
	{
		_clip_retni(mp, 0);
		return 0;
	}
	if (begpos < 1)
		begpos = 1;
	for (i = begpos-1; i < sl; i++)
	{
		if ( s[i] == '\n')
		{
			i++;
			break;
		}
	}
	_clip_retni(mp,i+1);
	return 0;
}

int
clip_STRFINDBOL(ClipMachine * mp)
{
	int i,sl;
	char *s = _clip_parcl(mp, 1, &sl);
	int begpos = _clip_parni(mp, 2);

	if (s == NULL)
	{
		_clip_retni(mp, 0);
		return 0;
	}
	if (begpos < 1 || begpos > sl)
		begpos = sl+1;

	begpos--;
	if (s[begpos] == '\n')
		begpos--;
	for (i=begpos; i>=0 ; i--)
	{
		if ( s[i] == '\n')
		{
			i++;
			break;
		}
	}
	_clip_retni(mp,i+1);
	return 0;
}

int
clip_BIN2I(ClipMachine * mp)
{
	int vl = 0;
	short ret;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "BIN2I");
	}
	ret = *((short *) vp);
	_clip_retni(mp, ret);
	return 0;
}

int
clip_I2BIN(ClipMachine * mp)
{
	char buf[3];
	char *e;
	short i = (short) _clip_parni(mp, 1);

	e = (char *) (&i);
	buf[0] = e[0];
	buf[1] = e[1];
	buf[2] = 0;
	_clip_retcn(mp, buf, 2);
	return 0;
}

int
clip_BIN2B(ClipMachine * mp)
{
	int vl = 0;
	char ret;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "BIN2I");
	}
	ret = *((char *) vp);
	_clip_retni(mp, ret);
	return 0;
}

int
clip_B2BIN(ClipMachine * mp)
{
	char buf[2];
	char i = (char) _clip_parni(mp, 1);

	buf[0] = i;
	buf[2] = 0;
	_clip_retcn(mp, buf, 1);
	return 0;
}

int
clip_L2BIN(ClipMachine * mp)
{
	char buf[5];
	char *e;
	long i = (long) _clip_parnl(mp, 1);

	e = (char *) (&i);
	buf[0] = e[0];
	buf[1] = e[1];
	buf[2] = e[2];
	buf[3] = e[3];
	buf[4] = 0;
	_clip_retcn(mp, buf, 4);
	return 0;
}

int
clip_BIN2L(ClipMachine * mp)
{
	int vl = 0;
	long ret;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "BIN2L");
	}
	ret = *((long *) vp);
	_clip_retni(mp, ret);
	return 0;
}

int
clip_BIN2W(ClipMachine * mp)
{
	int vl = 0;
	unsigned short ret;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "BIN2W");
	}
	ret = *((unsigned short *) vp);
	_clip_retni(mp, ret);
	return 0;
}

int
clip_BIN2DW(ClipMachine * mp)
{
	int vl = 0;
	unsigned long ret;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "BIN2L");
	}
	ret = *((unsigned long *) vp);
	_clip_retni(mp, ret);
	return 0;
}

int
clip_HARDCR(ClipMachine * mp)
{
	int vl = 0;
	char *ret, *e;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "HARDCR");
	}
	ret = malloc(vl + 1);
	memcpy(ret, vp, vl);
	for (e = ret; e < ret + vl; e++)
		if (*e == (char) 141)
			*e = '\n';
	ret[vl] = 0;
	_clip_retcn_m(mp, ret, vl);
	return 0;
}

int
_clip_isalpha(unsigned char ch)
{
#if 0
	int ret = 0;

	if (ch >= 'A' && ch <= 'Z')
		ret = 1;
	if (ch >= 'a' && ch <= 'z')
		ret = 1;
	if (ch > 127)
		ret = _clip_isalpha_tbl[ch - 128];
	return ret;
#else
	return _clip_isalpha_tbl[ch];
#endif
}

int
clip_ISALPHA(ClipMachine * mp)
{
	char *vp = _clip_parc(mp, 1);

	_clip_retl(mp, 0);
	if (vp != NULL)
		_clip_retl(mp, _clip_isalpha(vp[0]));
	return 0;
}

int
clip_ISDIGIT(ClipMachine * mp)
{
	char ch;
	int ret = 0;
	char *vp = _clip_parc(mp, 1);

	_clip_retl(mp, 0);
	if (vp == NULL)
				return 0;
	ch = vp[0];
	if (ch >= '0' && ch <= '9')
		ret = 1;
	_clip_retl(mp, ret > 0);
	return 0;
}

static void
translate(unsigned char *str, int len, int up)
{
	unsigned char *tbl = (up ? _clip_uptbl : _clip_lowtbl);

	while (len)
	{
		int s = *str;

		*str = tbl[s];
		--len;
		++str;
	}
}

int
clip_UPPER(ClipMachine * mp)
{
	int l;
	char *s;
	char *r;

	s = _clip_parcl(mp, 1, &l);
	if (!s)
	{
		_clip_retc(mp, "");
		return 0;
	}

	r = _clip_memdup(s, l);
	translate(r, l, 1);

	_clip_retcn_m(mp, r, l);

	return 0;
}
int
clip_UPPE(ClipMachine * mp)
{
	return clip_UPPER(mp);
}

int
clip_XUPPER(ClipMachine * mp)
{
	if(_clip_parinfo(mp,1) == CHARACTER_t){
		int l;
		char *s;
		char *r;

		s = _clip_parcl(mp, 1, &l);
		if (!s)
		{
			_clip_retc(mp, "");
			return 0;
		}

		r = _clip_memdup(s, l);
		translate(r, l, 1);

		_clip_retcn_m(mp, r, l);
	} else {
		ClipVar* r = RETPTR(mp);
		_clip_dup(mp,r,_clip_par(mp,1));
	}

	return 0;
}

int
clip_LOWER(ClipMachine * mp)
{
	int l;
	char *s;
		char *r;

	s = _clip_parcl(mp, 1, &l);
	if (!s)
		{
		_clip_retc(mp, "");
				return 0;
	}

	r = _clip_memdup(s, l);
	translate(r, l, 0);

		_clip_retcn_m(mp, r, l);

	return 0;
}

int
clip_LOWE(ClipMachine * mp)
{
	return clip_LOWER(mp);
}

int
clip_ISUPPER(ClipMachine * mp)
{
	unsigned char *s = (unsigned char *) _clip_parc(mp, 1);

	if (!s)
		_clip_retl(mp, 0);
	else
	{
		int ch = *s;

		_clip_retl(mp, (_clip_isalpha_tbl[ch] && ch == _clip_uptbl[ch]));
		/* _clip_retl(mp, (ch == _clip_uptbl[ch])); */
	}

	return 0;
}

int
clip_ISLOWER(ClipMachine * mp)
{
	unsigned char *s = (unsigned char *) _clip_parc(mp, 1);

	if (!s)
		_clip_retl(mp, 0);
	else
	{
		int ch = *s;

		_clip_retl(mp, (_clip_isalpha_tbl[ch] && ch == _clip_lowtbl[ch]));
		/*_clip_retl(mp, (ch == _clip_lowtbl[ch]));*/
	}

	return 0;
}

int
clip_ISWORD(ClipMachine * mp)
{
	int ret = 1;
		unsigned char *ptr;
	unsigned char *s = (unsigned char *) _clip_parc(mp, 1);

	if (!s || !(*s))
		{
		_clip_retl(mp, 0);
				return 0;
		}
		for ( ptr=s; (*ptr); ptr++)
		{
			switch (*ptr)
				{
					case '0'...'9':
							if (ptr == s)
									ret = 0;
								break;
					case 'a'...'z':
						case 'A'...'Z':
						case '_':
							break;
						default:
							ret = 0;
								break;
				}
				if ( !ret )
					break;
		}
	_clip_retl(mp, ret);
	return 0;
}

int
clip_LEFT(ClipMachine * mp)
{
	int vl = 0;
	int i;
	char *rp;
	char *vp = _clip_parcl(mp, 1, &vl);
	int nl = _clip_parni(mp, 2);

	if (nl < 0)
		nl = 0;
	if (nl > vl)
		nl = vl;

	if (vp == NULL)
	{
		_clip_retc(mp, "");
				return 0;
	}
	rp = malloc(nl + 1);
	if (nl > vl)
		nl = vl;
	for (i = 0; i < nl; i++)
		rp[i] = vp[i];
	rp[i] = 0;
	_clip_retcn_m(mp, rp, nl);
	return 0;
}

int
clip_MAX(ClipMachine * mp)
{
	int t1 = _clip_parinfo(mp, 1);
	int t2 = _clip_parinfo(mp, 1);

	if (t1 == NUMERIC_t && t2 == NUMERIC_t)
	{
		double n1, n2;
		int l1, l2, d1, d2;

		n1 = _clip_parnd(mp, 1);
		_clip_parp(mp, 1, &l1, &d1);
		n2 = _clip_parnd(mp, 2);
		_clip_parp(mp, 2, &l2, &d2);
		if (n1 > n2)
			_clip_retndp(mp, n1, l1, d1);
		else
			_clip_retndp(mp, n2, l2, d2);
		return 0;
	}
	if (t1 == DATE_t && t2 == DATE_t)
	{
		long ret, n1, n2;

		n1 = _clip_pardj(mp, 1);
		n2 = _clip_pardj(mp, 2);
		if (n1 > n2)
			ret = n1;
		else
			ret = n2;
		_clip_retdj(mp, ret);
		return 0;
	}
	_clip_retni(mp, 0);
	return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "MAX");
}

int
clip_MIN(ClipMachine * mp)
{
	int t1 = _clip_parinfo(mp, 1);
	int t2 = _clip_parinfo(mp, 1);

	if (t1 == NUMERIC_t && t2 == NUMERIC_t)
	{
		double n1, n2;
		int l1, l2, d1, d2;

		n1 = _clip_parnd(mp, 1);
		_clip_parp(mp, 1, &l1, &d1);
		n2 = _clip_parnd(mp, 2);
		_clip_parp(mp, 2, &l2, &d2);
		if (n1 < n2)
			_clip_retndp(mp, n1, l1, d1);
		else
			_clip_retndp(mp, n2, l2, d2);
		return 0;
	}
	if (t1 == DATE_t && t2 == DATE_t)
	{
		long ret, n1, n2;

		n1 = _clip_pardj(mp, 1);
		n2 = _clip_pardj(mp, 2);
		if (n1 < n2)
			ret = n1;
		else
			ret = n2;
		_clip_retdj(mp, ret);
		return 0;
	}
	_clip_retni(mp, 0);
	return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "MIN");
}

int
clip_MEMOLINE(ClipMachine * mp)
{
	int vl = 0, i, j, len, nstr, ntab, wrap;
	char *rp, *e,*e2, *wrappos = NULL;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "MEMOLINE");
	}
	len = _clip_parni(mp, 2);
	if (len <= 4)
		len = 79;
	nstr = _clip_parni(mp, 3);
	if (nstr <= 1)
		nstr = 1;
	ntab = _clip_parni(mp, 4);
	if (ntab < 1)
		ntab = 1;
	if (ntab >= len)
		ntab = len - 1;

	if (_clip_parinfo(mp,5) == LOGICAL_t)
		wrap = _clip_parl(mp,5);
	else
		wrap = 1;
	rp = (char *) malloc(len + 1);
	memset(rp,' ',len);
	rp[len] = 0;

	for (i = 1, j = 1, e = vp; e < vp + vl && i < nstr; e++, j++)
	{
		if (*e == ' ')
			wrappos = e;
		if (j >= len || *e == '\n')
		{
			if ( wrap && wrappos != NULL && e < vp+vl-1 && *e != '\n')
			{
				if ( *(e+1) == ' ')
					e++;
				else
					e = wrappos;
			}
			i++;
			j = 0;
		}
		if (*e == '\t')
			j += ntab - 1;
		if (*e == '\r')
			j--;
	}
	if (i < nstr)
	{
		_clip_retcn_m(mp, rp,len);
		return 0;
	}
	if ( i>1 && j>len )
	{
		if (wrap && wrappos != NULL)
			e = wrappos+1;
		else
			e++;
	}
	wrappos = NULL;
	e2 = rp;
	for (j = 0; e < vp + vl && j <= len && *e != '\n'; e++, j++,e2++)
	{
		if (*e == ' ')
			wrappos = e2;
		if (*e != '\r')
			*e2 = *e;
		else
		{
			j--;
			e2--;
		}
		if (*e == '\t')
			j += ntab - 1;
	}
	if ( j>len )
	{
		if (wrap && wrappos != NULL)
			e2 = wrappos+1;
		else
			e2++;
	}
	e = rp+len;
	for (;e2<=e; e2++)
		*e2 = ' ';
	rp[len] = 0;
	_clip_retcn_m(mp, rp, len);
	return 0;
}

int
clip_MLCOUNT(ClipMachine * mp)
{
	int vl = 0, i, j, len, ntab, wrap;
	char *e, *wrappos=NULL;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retni(mp, 0);
				return 0;
	}
	len = _clip_parni(mp, 2);
	if (len <= 4)
		len = 79;
	ntab = _clip_parni(mp, 3);
	if (ntab < 1)
		ntab = 1;
	if (ntab >= len)
		ntab = len - 1;
	if (_clip_parinfo(mp,5) == LOGICAL_t)
		wrap = _clip_parl(mp,5);
	else
		wrap = 1;

	for (i = 0, j = 1, e = vp; e < vp + vl; e++, j++)
	{
		if (*e == ' ')
			wrappos = e;
		if (j >= len || *e == '\n')
		{
			if ( wrap && wrappos != NULL && e < vp+vl-1 && *e != '\n')
			{
				if ( *(e+1) == ' ')
					e++;
				else
				{
					e = wrappos;
					wrappos = NULL;
				}
			}
			i++;
			j = 0;
		}
		if (*e == '\t')
			j += ntab - 1;
		if (*e == '\r')
			j--;
	}
	_clip_retni(mp, i + (j>1));
	return 0;
}

int
clip_MLPOS(ClipMachine * mp)
{
	int vl = 0, i, j, len, nstr, ntab, npos = 1,wrap;
	char *e,*wrappos = NULL;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "MLPOS");
	}
	len = _clip_parni(mp, 2);
	if (len <= 4)
		len = 79;
	nstr = _clip_parni(mp, 3);
	if (nstr <= 1)
		nstr = 1;
	ntab = _clip_parni(mp, 4);
	if (ntab < 1)
		ntab = 1;
	if (ntab >= len)
		ntab = len - 1;
	if (_clip_parinfo(mp,5) == LOGICAL_t)
		wrap = _clip_parl(mp,5);
	else
		wrap = 1;

	for (i = 1, j = 1, e = vp; e < vp + vl; e++, j++)
	{
		if (*e == ' ')
			wrappos = e;
		if (j >= len || *e == '\n')
		{
			if ( wrap && wrappos != NULL && e < vp+vl-1 && *e != '\n')
			{
				if ( *(e+1) == ' ')
					e++;
				else
					e = wrappos;
			}
			i++;
			j = 0;
		}
		if (*e == '\t')
			j += ntab - 1;
		if (*e == '\r')
			j--;
		if (i >= nstr && j >= npos)
			break;
	}
	_clip_retni(mp, e - vp + 1);
	return 0;
}

int
clip_MLCTOPOS(ClipMachine * mp)
{
	int vl = 0, i, j, len, nstr, ntab, npos;
	char *e;
	char *vp = _clip_parcl(mp, 1, &vl);

	if (vp == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "MLTOPOS");
	}
	len = _clip_parni(mp, 2);
	if (len <= 4)
		len = 79;
	nstr = _clip_parni(mp, 3);
	if (nstr <= 1)
		nstr = 1;
	npos = _clip_parni(mp, 4);
	if (npos <= 1)
		npos = 0;
	npos++;
	ntab = _clip_parni(mp, 5);
	if (ntab < 1)
		ntab = 1;
	if (ntab >= len)
		ntab = len - 1;

	for (i = 1, j = 1, e = vp; e < vp + vl; e++, j++)
	{
		if (j >= len || *e == '\n')
		{
			i++;
			j = 0;
		}
		if (*e == '\t')
			j += ntab - 1;
		if (*e == '\r')
			j--;
		if (i >= nstr && j >= npos)
			break;
	}
	/*printf("%d,%d,%d,%d...",i,j,e,vp);*/
	_clip_retni(mp, e - vp + 1);
	return 0;
}


int
clip_PADR(ClipMachine * mp)
{
	int bl, i;
	int len = _clip_parni(mp, 2);
	char *s = _clip_parc(mp, 3);
	char *buf, *ret, ch;
	int t1 = _clip_parinfo(mp, 1);
	ClipVar *vp = _clip_par(mp, 1);

	if (len<0)
	{
		_clip_retc(mp,"");
		return 0;
	}

	if (s == NULL)
		ch = ' ';
	else
		ch = s[0];
	switch (t1)
	{
	case NUMERIC_t:
		buf = _clip_strFunc(mp,vp,len,vp->t.dec,2);
		bl = strlen(buf);
		break;
	case DATE_t:
		buf = _clip_date_to_str(_clip_pardj(mp, 1), mp->date_format);
		bl = strlen(buf);
		break;
	case CHARACTER_t:
		buf = _clip_parcl(mp, 1, &bl);
		break;
	default:
		_clip_retc(mp, "");
		return 0;
	}
	ret = malloc(len + 1);
	for (i = 0; i < bl && i < len; i++)
		ret[i] = buf[i];
	for (; i < len; i++)
		ret[i] = ch;
	ret[len] = 0;
	_clip_retcn_m(mp, ret, len);

	if (t1 != CHARACTER_t)
		free(buf);
	return 0;
}

int
clip_PAD(ClipMachine * mp)
{
	return clip_PADR(mp);
}

int
clip_PADL(ClipMachine * mp)
{
	int bl, i, j;
	int len = _clip_parni(mp, 2);
	char *s = _clip_parc(mp, 3);
	char *buf, *ret, ch;
	int t1 = _clip_parinfo(mp, 1);
	ClipVar *vp = _clip_par(mp, 1);

	if (len<0)
	{
		_clip_retc(mp,"");
		return 0 ;
	}

	if (s == NULL)
		ch = ' ';
	else
		ch = s[0];
	switch (t1)
	{
	case NUMERIC_t:
		buf = _clip_strFunc(mp,vp,len,vp->t.dec,1);
		bl = strlen(buf);
		break;
	case DATE_t:
		buf = _clip_date_to_str(_clip_pardj(mp, 1), mp->date_format);
		bl = strlen(buf);
		break;
	case CHARACTER_t:
		buf = _clip_parcl(mp, 1, &bl);
		break;
	default:
		_clip_retc(mp, "");
		return 0;
	}
	ret = malloc(len + 1);
	for (i = 0; i < len - bl; i++)
		ret[i] = ch;
	for (j = 0; i < len && j < bl; i++, j++)
		ret[i] = buf[j];
	ret[len] = 0;
	_clip_retcn_m(mp, ret, len);

	if (t1 != CHARACTER_t)
		free(buf);
	return 0;
}

int
clip_PADC(ClipMachine * mp)
{
	int bl, i, j, k;
	int len = _clip_parni(mp, 2);
	char *s = _clip_parc(mp, 3);
	char *buf, *ret, ch;
	int t1 = _clip_parinfo(mp, 1);
	ClipVar *vp = _clip_par(mp, 1);

	if (len<0)
	{
		_clip_retc(mp,"");
		return 0 ;
	}

	if (s == NULL)
		ch = ' ';
	else
		ch = s[0];
	switch (t1)
	{
	case NUMERIC_t:
		buf = _clip_strFunc(mp,vp,len,vp->t.dec,3);
		bl = strlen(buf);
		break;
	case DATE_t:
		buf = _clip_date_to_str(_clip_pardj(mp, 1), mp->date_format);
		bl = strlen(buf);
		break;
	case CHARACTER_t:
		buf = _clip_parcl(mp, 1, &bl);
		break;
	default:
		_clip_retc(mp, "");
		return 0;
	}
	ret = malloc(len + 1);
	k = (len - bl) / 2;
	for (i = 0; i < k && i < len; i++)
		ret[i] = ch;
	for (j = 0; j < bl && i < len; i++, j++)
		ret[i] = buf[j];
	for (; i < len; i++)
		ret[i] = ch;
	ret[len] = 0;
	_clip_retcn_m(mp, ret, len);

	if (t1 != CHARACTER_t)
		free(buf);
	return 0;
}

int
clip_REPLICATE(ClipMachine * mp)
{
	int i, k, j, vl, len;
	char *vp = _clip_parcl(mp, 1, &vl);
	int kol = _clip_parni(mp, 2);
	char *ret;

	if (kol<=0)
	{
		_clip_retc(mp,"");
		return 0;
	}

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "REPLICATE");
	}
	len = vl * kol;
	ret = malloc(len + 1);
	for (i = 0, k = 0; i < kol; i++)
		for (j = 0; j < vl; j++, k++)
			ret[k] = vp[j];
	ret[len] = 0;
	_clip_retcn_m(mp, ret, len);

	return 0;
}

int
clip_REPL(ClipMachine * mp)
{
	return clip_REPLICATE(mp);
}

int
clip_REPLI(ClipMachine * mp)
{
	return clip_REPLICATE(mp);
}

int
clip_REPLIC(ClipMachine * mp)
{
	return clip_REPLICATE(mp);
}

int
clip_REPLICA(ClipMachine * mp)
{
	return clip_REPLICATE(mp);
}

int
clip_REPLICAT(ClipMachine * mp)
{
	return clip_REPLICATE(mp);
}

int
clip_RIGHT(ClipMachine * mp)
{
	int vl = 0;
	int i, j;
	char *rp;
	char *vp = _clip_parcl(mp, 1, &vl);
	int nl = _clip_parni(mp, 2);

	if (vp == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "RIGHT");
	}
	if (nl < 0)
		nl = 0;
	if (nl > vl)
		nl = vl;
	rp = malloc(nl + 1);
	for (i = vl - nl, j = 0; i < vl; i++, j++)
		rp[j] = vp[i];
	rp[j] = 0;
	_clip_retcn_m(mp, rp, nl);
	return 0;
}

int
clip_SPACE(ClipMachine * mp)
{
	int kol = _clip_parni(mp, 1);
	char *ret;

	if (kol <= 0)
		kol = 0;
	ret = malloc(kol + 1);
	if ( !_clip_parl(mp,2) )
		memset(ret, ' ', kol);
	ret[kol] = 0;
	_clip_retcn_m(mp, ret, kol);
	return 0;
}
int
clip_SPAC(ClipMachine * mp)
{
	return clip_SPACE(mp);
}

int
clip_STRTRAN(ClipMachine * mp)
{
	int l, l1, l2, rl = 0, n;
	char *ret, *e, *m, *end, *end1, *end2, *e1, *e2;
	char *str = _clip_parcl(mp, 1, &l);
	char *s1 = _clip_parcl(mp, 2, &l1);
	char *s2 = _clip_parcl(mp, 3, &l2);
	int from = _clip_parni(mp, 4);
	int kol = _clip_parni(mp, 5);

	if (str == NULL || s1 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "STRTRAN");
	}
	if (s2 == NULL)
	{
		s2 = "";
		l2 = 0;
	}
	if (from <= 0)
		from = 1;
	if (kol <= 0)
		kol = 0;
	from--;
	end = str + l;
	end1 = s1 + l1;
	end2 = s2 + l2;
	if (kol == 0)
	{
		for (e = str + from; e < end; e++)
		{
			for (e1 = s1, e2 = e; e1 < end1 && e2 < end && (*e1) == (*e2); e1++, e2++);
			if (e1 == end1)
			{
				kol++;
				e += l1 - 1;
			}
			if (e >= end)
				break;
		}
	}
	if (kol == 0)
	{
		_clip_retcn(mp, str, l);
		return 0;
	}
	rl = l + (l2 - l1) * kol + 1;
	ret = malloc(rl + 1);
	memcpy(ret, str, from);
	for (e = str + from, m = e, n = 0; e < end && n < kol; e++)
	{
		for (e1 = s1, e2 = e; e1 < end1 && e2 < end && (*e1) == (*e2); e1++, e2++);
		if (e1 != end1)
			continue;
		memcpy(ret + from, m, e - m);
		from += e - m;
		memcpy(ret + from, s2, l2);
		from += l2;
		if (e1 == end1)
		{
			e += l1 - 1;
			m = e + 1;
			n++;
		}
	}
	memcpy(ret + from, m, str + l - m);
	from += str + l - m;
	ret[from] = 0;
	_clip_retcn_m(mp, ret, from);
	return 0;
}

int
clip_STUFF(ClipMachine * mp)
{
	int l, l1, rl;
	char *ret;
	char *str = _clip_parcl(mp, 1, &l);
	int from = _clip_parni(mp, 2);
	int kol = _clip_parni(mp, 3);
	char *s1 = _clip_parcl(mp, 4, &l1);

	if (str == NULL || s1 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "STUFF");
	}
	if (from <= 0)
		from = 1;
	if (from > l)
		from = l + 1;
	if (kol <= 0)
		kol = 0;
	if ((from + kol) > l)
		kol = l - from + 1;
	from--;
	rl = l - kol + l1;
	if (rl <= 0)
		{
			_clip_retc(mp,"");
				return 0;
		}
	ret = malloc(rl + 1);
	memcpy(ret, str, from);
	memcpy(ret + from, s1, l1);
	memcpy(ret + from + l1, str + from + kol, l - from - kol);
	ret[rl] = 0;
	_clip_retcn_m(mp, ret, rl);
	return 0;
}


int
clip_SUBSTR(ClipMachine * mp)
{
	int l;
	char *ret;
	char *str = _clip_parcl(mp, 1, &l);
	int from = _clip_parni(mp, 2);
	int kol = _clip_parni(mp, 3);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "SUBSTR");
	}
	if (kol <= 0)
		kol = 0;
	if (from < 0)
	{
		from = l + from;
		if (from < 0)
			from = 0;
	}
	else if (from)
		from--;
	if (_clip_parinfo(mp, 0) < 3)
		kol = l - from;
	if ((kol + from) > l)
		kol = l - from;
	if (kol < 0)
		kol = 0;
	ret = malloc(kol + 1);
	memcpy(ret, str + from, kol);
	ret[kol] = 0;
	_clip_retcn_m(mp, ret, kol);
	return 0;
}

int
clip_SUBS(ClipMachine * mp)
{
	return clip_SUBSTR(mp);
}

int
clip_SUBST(ClipMachine * mp)
{
	return clip_SUBSTR(mp);
}

int
clip_HASHSTR(ClipMachine * mp)
{
	char *s;
	long hash;
	char *str = _clip_parc(mp, 1);

	if (str == NULL)
	{
		_clip_retnl(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "HASHSTR");
	}
	hash =  _clip_hashstr(str);
	_clip_retnl(mp, hash);

	s = (char *) HashTable_fetch(mp->hashnames, hash);
	if (!s)
	{
		s = strdup(str);
		HashTable_store(mp->hashnames, s, hash);
	}
	return 0;
}


static int
_clip_calc_crc(ClipMachine * mp,int type)
{
	long hash;
	int len;
	char *str = _clip_parcl(mp, 1, &len);

	if (str == NULL)
	{
		_clip_retnl(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "HASHSTR");
	}

	if (type==32)
		hash = _clip_hashbytes32(0, str, len);
	else
		hash = _clip_hashbytes16(0, str, len);

	_clip_retnl(mp, hash);

	return 0;
}

int
clip_CRC32(ClipMachine * mp)
{
	return _clip_calc_crc(mp,32);
}

int
clip_CRC16(ClipMachine * mp)
{
	return _clip_calc_crc(mp,16);
}

int
clip_HASHNAME(ClipMachine *mp)
{
	long hash = _clip_parnl(mp,1);
	char buf[256];

	_clip_hash_name(mp, hash, buf, sizeof(buf));
	_clip_retc(mp, buf);

	return 0;
}

int
clip_STRFORMAT(ClipMachine * mp)
{
	int i, len, nw, lw, n, c, c1;
	char *str1;
	char *str2 = _clip_parcl(mp, 1, &len);
	int lend = _clip_parni(mp, 2);

	if (str2 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "STRFORMAT");
	}

	str1 = (char *) malloc(lend + 1);

	for (len--; str2[len] == ' '; len--);
	str2[len + 1] = 0;
	if (len > lend)
		str2[lend + 1] = 0;

	for (i = 0; str2[i] == ' '; i++);
	for (; str2[i] != ' ' && str2[i] != 0; i++);
	n = i;
	for (nw = 0, lw = 0; str2[i] != 0; nw++)
	{
		for (; str2[i] == ' '; i++);
		for (; str2[i] != ' ' && str2[i] != 0; i++, lw++);
	}
	if (nw != 0)
	{
		c = (lend - n - lw) / nw;
		c1 = lend - n - lw - c * nw;
	}
	else
	{
		c = lend - n;
		c1 = 0;
		nw = 1;
	}
	for (i = 0; i < n; i++)
		str1[i] = str2[i];
	for (; nw > 0; nw--)
	{
		for (lw = 0; lw < c; lw++, n++)
			str1[n] = ' ';
		if (c1 > 0)
		{
			str1[n] = ' ';
			n++;
			c1--;
		}
		for (; str2[i] == ' '; i++);
		for (; str2[i] != ' ' && str2[i] != 0; i++, n++)
			str1[n] = str2[i];

	}
	str1[n] = 0;
	_clip_retcn_m(mp, str1, n);
	return 0;
}

int
clip_STRUNFORMAT(ClipMachine * mp)
{
	int i, len, nw;
	char *str1;
	char *str2 = _clip_parcl(mp, 1, &len);

	if (str2 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "STRUNFORMAT");
	}
	for (nw = 0; str2[nw] == ' '; nw++);
	for (i = 0; i < len;)
	{
		nw++;
		if (str2[i] == ' ')
			while (str2[i] == ' ')
				i++;
		else
			i++;
	}
	str1 = (char *) malloc(nw + 1);

	for (i = 0, nw = 0; str2[i] == ' '; i++, nw++)
		str1[nw] = str2[i];
	for (; i < len;)
	{
		str1[nw] = str2[i];
		nw++;
		if (str2[i] == ' ')
			while (str2[i] == ' ')
				i++;
		else
			i++;
	}
	str1[nw] = 0;
	_clip_retcn_m(mp, str1, nw);
	return 0;
}

int
clip_OCCURS(ClipMachine * mp)
{
	int i = 0, sl, l, ll;
	const char *ss;
	char *s = _clip_parcl(mp, 1, &sl);
	char *str = _clip_parcl(mp, 2, &l);

	if (str == NULL || s == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "OCCURS");
	}
	ss = str;
	while (1)
	{
		ll = l - (ss - str);
		ss = _atl(ss, s, ll, sl);
		if (ss == NULL)
			break;
		i++;
		ss++;

	}
	_clip_retni(mp, i);
	return 0;
}

int
clip_DESCEND(ClipMachine * mp)
{
	int i,j, l, d;
	int t = _clip_parinfo(mp, 1);
	ClipVar *vp = _clip_par(mp, 1);
	unsigned char *buf, *str,ch;
	double n;

	switch (t)
	{
	case MEMO_t:
	case CHARACTER_t:
		str = _clip_parcl(mp, 1, &l);
		buf = calloc(l + 1, 1); buf[l] = 0 ;
		for (i = 0; i < l; i++)
				{
					ch = str[i];
			ch = 256 - _clip_cmptbl[ch];
						for ( j=0; j < 256; j++)
								if ( _clip_cmptbl[j] == ch )
										break;
						if ( j < 256 )
				buf[i] = j;
						else
				buf[i] = ch;
				}
		_clip_retcn_m(mp, buf, l);
		break;
	case DATE_t:
		_clip_retdj(mp, 5231808 - _clip_pardj(mp, 1));
		break;
	case NUMERIC_t:
		if (vp->t.memo)
		{
			_clip_retnr(mp, rational_inv(vp->r.r), l, d);
		}
		else
		{
			n = _clip_parnd(mp, 1);
			_clip_parp(mp, 1, &l, &d);
			_clip_retndp(mp, -1 * n, l, d);
		}
		break;
	case LOGICAL_t:
		_clip_retl(mp, !_clip_parl(mp, 1));
		break;
	}
	return 0;
}

void
_clip_recodeString(char *str, int len, int sourceCharset, int targetCharset)
{
	int i;
	unsigned char *s;

	if (sourceCharset == targetCharset)
		return;
	for (i = 0, s = (unsigned char *) str; i < len; ++i, ++s)
	{
		int ch = *s;

		if (ch < 128)
			continue;
		switch (sourceCharset)
		{
		case CS_KOI:
			break;
		case CS_ALT:
			ch = alt2koi[ch - 128];
			break;
		case CS_WIN:
			ch = win2koi[ch - 128];
			break;
		}
		if (ch < 128)
		{
			*s = ch;
			continue;
		}
		switch (targetCharset)
		{
		case CS_KOI:
			break;
		case CS_ALT:
			ch = koi2alt[ch - 128];
			break;
		case CS_WIN:
			ch = koi2win[ch - 128];
			break;
		}
		*s = ch;
	}
}

int
clip_ALT2KOI(ClipMachine * mp)
{

	int l;
	unsigned char *ret;
	unsigned char *str = _clip_parcl(mp, 1, &l);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return 0;
	}
	ret = malloc(l + 1);
	memcpy(ret, str, l);
	ret[l] = 0;
	_clip_recodeString(ret, l, CS_ALT, CS_KOI);
	_clip_retcn_m(mp, ret, l);
	return 0;
}

int
clip_KOI2ALT(ClipMachine * mp)
{

	int l;
	unsigned char *ret;
	unsigned char *str = _clip_parcl(mp, 1, &l);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return 0;
	}
	ret = malloc(l + 1);
	memcpy(ret, str, l);
	ret[l] = 0;
	_clip_recodeString(ret, l, CS_KOI, CS_ALT);
	_clip_retcn_m(mp, ret, l);
	return 0;
}

int
clip_ADDSLASH(ClipMachine * mp)
{
	int count=0,i,l;
	unsigned char *ret;
	unsigned char *str = _clip_parcl(mp, 1, &l);

	if ( str==NULL || l==0 )
	{
		_clip_retc(mp,"");
		return 0;
	}
	for (i=0; i<l; i++)
	{
		switch (str[i])
		{
			case '"' :
			case '\'':
			case 0   :
				if(i==0 || str[i-1] != '\\')
					count++;
				break;
		}
	}
	ret=malloc(l+count+1);
	for (count=0,i=0; i<l; i++,count++)
	{
		switch (str[i])
		{
			case '"' :
			case '\'':
			case 0   :
				if(i==0 || str[i-1] != '\\')
				{
					ret[count] = '\\';
					count++;
				}
				break;
		}
		ret[count] = str[i]?str[i]:'0';
	}
	ret[count] = 0;
	_clip_retcn_m(mp,ret,count);
	return 0;
}

int
clip_SPLITDELIM(ClipMachine * mp)
{
	ClipVar *ap = RETPTR(mp);
	char *str = _clip_parc(mp,1);
	char *fdelim = _clip_parc(mp,2);
	char *rdelim = _clip_parc(mp,3);
	char *b,*p,f,r;
	long dims[1] = {0};
	ClipVar v;

	_clip_array(mp,ap,1,dims);

	if(!str || !str[0])
		return 0;
	if(!fdelim) f = '\"'; else f = fdelim[0];
	if(!rdelim) r = ','; else r = rdelim[0];

	p = str;
	while(*p)
	{
		while(*p && *p == ' ') p++; if(!(*p)) continue;
		b = p;
		if(*p == f)
		{
			while(*p && *(++p) != f); if(!(*p)) continue;
			_clip_var_str(b+1,p-b-1,&v);
			_clip_aadd(mp,ap,&v);
			while(*p && *(p++) != r);
			continue;
		}
		while(*p && *p != r) p++;
		_clip_var_str(b,p-b,&v);
		_clip_aadd(mp,ap,&v);
		if(*p)
			p++;
	}
	return 0;
}

int
clip_BASE64ENCODE(ClipMachine * mp)
{
	int inlen;
	char *str = _clip_parcl(mp,1,&inlen);
	const char base64char[64] =
		"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	char *inp = str;
	int outlen = 0;
	int l = ((inlen+2)/3)*4;
	char *outp,*out;

	l += (inlen+53)/54;
	out = outp = calloc(1,l+1);

	while (inlen >= 3) {
		*outp++ = base64char[(inp[0] >> 2) & 0x3f];
		*outp++ = base64char[((inp[0] & 0x03) << 4) |
					 ((inp[1] >> 4) & 0x0f)];
		*outp++ = base64char[((inp[1] & 0x0f) << 2) |
					 ((inp[2] >> 6) & 0x03)];
		*outp++ = base64char[inp[2] & 0x3f];

		inp += 3;
		inlen -= 3;
		if (++outlen == 18) {
			*outp++ = 10;
			outlen = 0;
		}
	}

	if (inlen > 0) {
		*outp++ = base64char[(inp[0] >> 2) & 0x3f];
		if (inlen == 1) {
			*outp++ = base64char[(inp[0] & 0x03) << 4];
			*outp++ = '=';
		} else {
			*outp++ = base64char[((inp[0] & 0x03) << 4) |
						 ((inp[1] >> 4) & 0x0f)];
			*outp++ = base64char[((inp[1] & 0x0f) << 2)];
		}
		*outp++ = '=';
	}

	_clip_retcn_m(mp,out,l);
	return 0;
}
