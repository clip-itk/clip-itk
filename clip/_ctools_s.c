/*
   Copyright (C) 2001  ITK
   Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
   $Log$
   Revision 1.1  2006/06/22 19:01:29  itk
   uri: initial

   Revision 1.76  2006/04/03 12:53:34  clip
   uri: some speed up for htmlParser

   Revision 1.75  2005/08/08 09:00:30  clip
   alena: fix for gcc 4

   Revision 1.74  2005/07/13 07:11:37  clip
   uri: small fix in token() about 2th and 3th parameters

   Revision 1.73  2005/02/22 08:04:39  clip
   uri: small fix

   Revision 1.72  2005/02/21 10:56:56  clip
   uri: small fix in *token()

   Revision 1.71  2005/02/15 10:46:40  clip
   uri: small fix in attoken()

   Revision 1.70  2005/02/13 06:52:42  clip
   uri: small fix in attoken()

   Revision 1.69  2004/11/29 06:57:07  clip
   uri: small fix in tokennext()

   Revision 1.68  2004/11/25 10:04:07  clip
   uri: fix in numtoken() about numeric parameters

   Revision 1.67  2004/10/27 09:08:50  clip
   uri: small fix for setPxlat()

   Revision 1.66  2004/05/19 08:32:17  clip
   rust: fix for ./configure -m

   Revision 1.65  2003/09/02 14:27:41  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.64  2002/10/08 12:13:43  clip
   uri: fix in remright()

   Revision 1.63  2002/07/04 09:16:47  clip
   uri: smakk fix in ATREPL(): recursively repl string

   Revision 1.62  2002/05/26 15:36:21  clip
   uri: warning fix

   Revision 1.61  2002/05/04 14:17:37  clip
   uri: fix in token*() functions

   Revision 1.60  2002/04/03 13:24:10  clip
   uri: small fix

   Revision 1.59  2002/04/03 11:39:30  clip
   uri: small fix

   Revision 1.58  2002/02/11 08:32:12  clip
   uri: center() && wopen()

   Revision 1.57  2002/01/28 13:01:52  clip
   uri: warning fixed

   Revision 1.56  2002/01/25 08:56:06  clip
   uri: small fix in crypt()

   Revision 1.55  2002/01/23 11:15:22  clip
   uri: new variant crypt() from Konstantin Sukhorabski <kos@walk.chernigov.ua>

   Revision 1.54  2002/01/17 10:33:22  clip
   uri: warning fix

   Revision 1.53  2001/12/21 09:06:00  clip
   uri: token() fix

   Revision 1.52  2001/12/10 08:08:51  clip
   uri: setcleara(), getcleara() added

   Revision 1.51  2001/11/20 13:19:52  clip
   uri: setTxlat(), setPxlat() added

   Revision 1.50  2001/11/14 11:25:50  clip
   small fix
   paul

   Revision 1.49  2001/11/14 11:18:59  clip
   add OUTBYTE, OUTWORD, INBYTE, INWORD functions
   paul

   Revision 1.48  2001/10/29 11:37:40  clip
   uri: bug in token()

   Revision 1.47  2001/09/20 15:51:40  clip
   uri: function crypt by  Timur Khusainov <khusainov@fort.aval.kiev.ua>

   Revision 1.46  2001/09/10 07:41:33  clip
   uri: CSETREF && tools function with @parameters

   Revision 1.45  2001/06/13 13:05:46  clip
   uri: add case flag in _clip_glob_match(), fixed all calls  this functions

   Revision 1.44  2001/05/11 05:19:19  clip
   uri: bug in center()

   Revision 1.43  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.42  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.41  2000/12/11 11:37:17  clip
   cmptbl in search

   Revision 1.40  2000/12/11 09:47:15  clip
   append setlocale() call
   all libC string functions now must work correct with correct charsets
   paul

   Revision 1.39  2000/12/10 14:25:33  clip
   weighttable,asc,chr

   Revision 1.38  2000/12/10 12:49:58  clip
   _clip_cmptbl in search and weightchr

   Revision 1.37  2000/12/06 13:13:00  clip
   loadable charset tables. size 256
   paul

   Revision 1.36  2000/11/13 15:47:51  clip
   mp->decimals in dStrToN(),fStrToN()

   Revision 1.35  2000/11/13 05:58:02  clip
   dStrToN(),fStrToN()

   Revision 1.34  2000/07/06 19:56:07  clip
   uri: bug in tabpack
   from uri:

   Revision 1.33  2000/05/30 19:10:11  clip
   uri: make function setclearb()

   Revision 1.32  2000/05/26 19:43:16  clip
   uri: small bug in tabexpand

   Revision 1.31  2000/05/24 18:33:50  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.30  2000/05/20 18:37:19  clip
   change hash function
   append HASH_xxxx extraction into hashcode.h
   Paul Lasarev <paul@itk.ru>

   Revision 1.29  2000/05/17 01:21:58  clip
   uri: я не помнню что я тут сделал - sorry !

   Revision 1.28  2000/05/16 15:12:49  clip
   uri: (ret=) realloc

   Revision 1.27  2000/05/03 19:32:17  clip
   add prefix 'clip_' to all clip functions

   Revision 1.26  2000/04/21 18:16:52  clip
   мелкий глюк в remall

   Revision 1.25  2000/04/14 19:11:40  uri
   кучка функций num* из tools

   Revision 1.24  2000/03/30 17:04:08  uri
   переделал под новые вызовы ошибок

   Revision 1.23  2000/03/21 19:20:26  uri
   bug in tabexpand, tabpack

   Revision 1.22  1999/12/13 21:21:36  uri
   добавил unsigned в стринковских функциях

   Revision 1.21  1999/12/10 21:16:34  uri
   в typename добавил MEMO_t

   Revision 1.20  1999/12/10 17:28:28  uri
   убрал предупреждения в cliprt, добавил MEMO_t, сделал несколько misc
   функций из тулзов

   Revision 1.19  1999/12/09 21:19:19  uri
   убрал warnings и начал misc functions of tools

   Revision 1.18  1999/12/08 21:01:21  uri
   доделал фйнкции с датами из тулзов

   Revision 1.17  1999/12/04 22:16:34  uri
   вычистил все предупреждения

   Revision 1.16  1999/12/04 20:43:06  uri
   bug in tokennext()

   Revision 1.15  1999/12/04 19:15:03  uri
   новый gcc

   Revision 1.14  1999/12/04 16:41:19  uri
   доделал все (кроме strdiff,pack,crypt) строковы функции из тулзов

   Revision 1.13  1999/12/02 22:03:23  uri
   еще не доделал token*

   Revision 1.12  1999/12/01 17:29:28  uri
   functions word*, token

   Revision 1.11  1999/11/30 22:18:44  uri
   остановился на tabpack

   Revision 1.10  1999/11/30 18:02:19  uri
   strswap problems

   Revision 1.9  1999/11/29 22:48:39  uri
   еще немного функций из тулзов

   Revision 1.8  1999/11/27 20:28:49  uri
   test for logged _ctools_s.c
*/

#include <string.h>
#include "clip.h"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>
#include <errno.h>

#include "screen/screen.h"
#include "error.ch"
#include "hashcode.h"

#ifdef HAVE_SYS_IO_H
#include <sys/io.h>
#endif

#ifdef OS_FREEBSD
#include <machine/cpufunc.h>
#include <machine/sysarch.h>
#endif

#define  CLIP_TOKEN_CHARACTERS " .,:;!?\\/<<>>()^#&%+-*\t\n\r\0x0"
#define  CLIP_TOKEN_CHARS_NUM  26
#define  CLIP_TOKEN_MAXLEN     1024

/* static data for TOKEN functions INIT, NEXT, END, AT, SEP */

int
clip_INIT_CTOOLS_STRING_SETS(ClipMachine * mp)
{
	char *status, *setref, *atlike, *atsep, *delims, *dayweek, *numcount;
	int *charsort, *clearb, *cleara;

	clearb = calloc(sizeof(int), 1);
	cleara = calloc(sizeof(int), 1);

	*((char *) clearb) = ' ';
	_clip_store_item(mp, HASH_setclearb, clearb);
	*cleara = 7;
	_clip_store_item(mp, HASH_setcleara, cleara);

	numcount = calloc(sizeof(long), 1);

	_clip_store_item(mp, HASH_numcount, numcount);

	status = calloc(2, 1);
	status[0] = 't';
	_clip_store_item(mp, HASH_csetatmupa, status);

	charsort = calloc(4, sizeof(int));

	_clip_store_item(mp, HASH_charsort_param, charsort);

	setref = calloc(2, 1);
	setref[0] = 't';
	_clip_store_item(mp, HASH_csetref, setref);

	atlike = calloc(2, 1);
	atlike[1] = '?';
	_clip_store_item(mp, HASH_setatlike, atlike);

	/* 5th int value and 2 strins with len==1 plus 0 character */
	/*
	   1 int value for current position tokennext(),
	   2 int value for tokenat(), tokenat(.t.),
	   2 string value tokensep()+chr(0), tokensep(.t.)+chr(0),
	   int value string length for first parameter tokeninit(),
	   int value for 3th parameter tokeninit()
	 */
	atsep = calloc(5 * sizeof(int) + 4, 1);

	_clip_store_item(mp, HASH_token_atsep, atsep);
	/* string for 1th parameter tokeninit() */
	_clip_store_item(mp, HASH_token_string, NULL);
	/* 256 flags of delimiters characters for 2th parameter tokeninit() */
	delims = calloc(256, 1);
	_clip_store_item(mp, HASH_token_delimiters, delims);
	dayweek = calloc(2, 1);
	dayweek[0] = '1';
	_clip_store_item(mp, HASH_first_day_week, dayweek);
	return 0;
}

int
clip_ADDASCII(ClipMachine * mp)
{
	int l;
	unsigned char *ret;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int asc = _clip_parni(mp, 2);
	int t2 = _clip_parinfo(mp, 2);
	int pos = _clip_parni(mp, 3);
	int rset = (*(unsigned char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL || t2 != NUMERIC_t)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "ADDASCII");
	}
	if (_clip_parinfo(mp, 0) < 3)
		pos = l;
	if (pos <= 0)
		pos = 1;
	if (pos > l)
		pos = l;
	pos--;
	ret = malloc(l + 1);
	memcpy(ret, str, l);
	ret[l] = 0;
	ret[pos] = str[pos] + asc;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CSETATMUPA(ClipMachine * mp)
{
	char *status;

	status = _clip_fetch_item(mp, HASH_csetatmupa);
	_clip_retl(mp, *status == 't');
	if (_clip_parinfo(mp, 0) > 0)
	{
		if (_clip_parl(mp, 1))
			*status = 't';
		else
			*status = 'f';
	}
	return 0;
}

int
clip_ASCIISUM(ClipMachine * mp)
{
	int l, i;
	long ret = 0;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);

	if (str == NULL)
	{
		_clip_retnl(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "ASCIISUM");
	}
	for (i = 0; i < l; i++)
		ret += str[i];
	_clip_retnl(mp, ret);
	return 0;
}

int
clip_ASCPOS(ClipMachine * mp)
{
	int l;
	int ret = 0;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int num = _clip_parni(mp, 2);

	if (str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "ASCPOS");
	}
	if (_clip_parinfo(mp, 0) < 2)
		num = l;
	if (num > 0 && num <= l)
		ret = str[num - 1];
	_clip_retni(mp, ret);
	return 0;
}

unsigned char *
_clip_atmupa(ClipMachine * mp, unsigned char *sstr, int l1, unsigned char *str, int l2, int ignore, int count, int flag)
{
	unsigned char *e1, *e2, *s, *beg, *end, *send;
	int cset = (*(unsigned char *) _clip_fetch_item(mp, HASH_csetatmupa)) == 't';
	char *atlike = _clip_fetch_item(mp, HASH_setatlike);
	int atlike0, atlike1;
	int sovp = 0;

	atlike0 = atlike[0];
	atlike1 = atlike[1];
	end = str + l2 - l1 + 1;
	beg = str + l2;
	if (l1 == 0)
		return beg;
	send = sstr + l1;
	if (ignore < 0)
		ignore = 0;
	for (e1 = str + ignore; e1 < end; e1++)
	{
		if (*e1 != *sstr)
			continue;
		for (s = sstr, e2 = e1; s < send && (*s == *e2 || (atlike0 && *s == atlike1)); s++, e2++);
		if (s != send)
			continue;
		if (flag)
			beg = e1;
		if (!cset)
			e1 = e2 - 1;
		if (!flag)
		{
			if (count != 0 || (cset && count == 0))
				beg = e2;
			else
				beg = e1;
		}
		sovp++;
		if (count != 0 && sovp >= count)
			break;
	}
	if ((count != 0 && sovp < count) || sovp == 0)
		beg = str + l2;
	return beg;
}

int
clip_AFTERATNUM(ClipMachine * mp)
{
	int l, l1, l2;
	unsigned char *ret, *beg;
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int count = _clip_parni(mp, 3);
	int ignore = _clip_parni(mp, 4);

	if (sstr == NULL || str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "AFTERATNUM");
	}
	beg = _clip_atmupa(mp, sstr, l1, str, l2, ignore, count, 0);
	l = str + l2 - beg;
	ret = malloc(l + 1);
	memcpy(ret, beg, l);
	ret[l] = 0;
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_ATADJUST(ClipMachine * mp)
{
	int l, le, l1, l2;
	unsigned char fillchr = ' ', *beg, *ret;
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int newpos = _clip_parni(mp, 3);
	int count = _clip_parni(mp, 4);
	int ignore = _clip_parni(mp, 5);
	int t6 = _clip_parinfo(mp, 6);

	if (sstr == NULL || str == NULL || _clip_parinfo(mp, 0) < 3)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "ATADJUST");
	}
	if (t6 == NUMERIC_t)
		fillchr = _clip_parni(mp, 6);
	if (t6 == CHARACTER_t)
		fillchr = *(_clip_parc(mp, 6));

	beg = _clip_atmupa(mp, sstr, l1, str, l2, ignore, count, 1);
	if (beg < str + l2)
	{
		le = beg - str;
		if (le >= newpos)
			le = newpos - 1;
		l = newpos + str + l2 - beg;
		ret = malloc(l + 1);
		memcpy(ret, str, le);
		for (; le < newpos; le++)
			ret[le] = fillchr;
		memcpy(ret + le, beg, l - le);
		ret[l] = 0;
		_clip_retcn_m(mp, (char *)ret, l);
	}
	else
		_clip_retcn(mp, (char *)str, l2);
	return 0;
}

int
clip_ATNUM(ClipMachine * mp)
{
	int l1, l2;
	unsigned char *beg;
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int count = _clip_parni(mp, 3);
	int ignore = _clip_parni(mp, 4);

	if (sstr == NULL || str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "ATNUM");
	}
	beg = _clip_atmupa(mp, sstr, l1, str, l2, ignore, count, 1);
	if (beg < str + l2)
		_clip_retni(mp, beg - str + 1);
	else
		_clip_retni(mp, 0);
	return 0;
}

int
clip_ATREPL(ClipMachine * mp)
{
	int l, l1, l2, l3, sovp = 0, rcur, atlike0, atlike1;
	unsigned char *ret, *cur, *s, *e1, *e2, *end, *send, *buf;
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 2, &l2);
	unsigned char *rstr = (unsigned char *)_clip_parcl(mp, 3, &l3);
	int count = _clip_parni(mp, 4);
	int flag = _clip_parl(mp, 5);
	char *atlike = _clip_fetch_item(mp, HASH_setatlike);
	int cset = (*(unsigned char *) _clip_fetch_item(mp, HASH_csetatmupa)) == 't';
	int rset = (*(unsigned char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	atlike0 = atlike[0];
	atlike1 = atlike[1];

	if (sstr == NULL || str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "ATREPL");
	}
		/* check recursively at */
		for(s = rstr, end = rstr+l3; s<end; s++)
		{
			sovp=0;
			for (cur = sstr, e1 = s, send=sstr+l1; cur<send && e1<end; cur++,e1++)
					if ( *e1 == *cur)
							sovp++;
				if ( sovp == l1)
				{
					cset = 0;
						break;
				}
		}
	if (count < 0)
		count = 0;
	buf = str;
	if (l1 == 0)
	{
		_clip_retcn(mp, (char *)str, l2);
		return 0;
	}
	while (1)
	{
		l = 0;
		ret = malloc(l + 1);
		e1 = buf;
		cur = buf;
		end = buf + l2;
		send = sstr + l1;
		for (sovp = 0, rcur = 0; e1 < end; e1++)
		{
			if (*e1 != *sstr)
				continue;
			for (s = sstr, e2 = e1; s < send && e2 < end && (*s == *e2 || (atlike0 && *s == atlike1)); s++, e2++);
			if (s != send)
				continue;
			sovp++;
			if (flag && sovp != count)
				continue;
			l += e1 - cur + l3;
			ret = realloc(ret, l + 1);
			memcpy(ret + rcur, cur, e1 - cur);
			rcur += e1 - cur;
			memcpy(ret + rcur, rstr, l3);
			rcur += l3;
			e1 = e2 - 1;
			cur = e2;
			if (count != 0 && sovp == count)
			{
				e1 = end;
				break;
			}
		}
		l += e1 - cur;
		ret = realloc(ret, l + 1);
		memcpy(ret + rcur, cur, e1 - cur);
		ret[l] = 0;
		if (buf != str)
			free(buf);
		if (!cset || sovp == 0 || flag || count != 0)
			break;
		buf = malloc(l + 1);
		memcpy(buf, ret, l);
		l2 = l;
		free(ret);
	}
	if (rset && _clip_par_isref(mp, 2))
		_clip_par_assign_str(mp, 2, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_BEFORATNUM(ClipMachine * mp)
{
	int l, l1, l2;
	unsigned char *ret, *beg;
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int count = _clip_parni(mp, 3);
	int ignore = _clip_parni(mp, 4);

	if (sstr == NULL || str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "BEFORATNUM");
	}
	beg = _clip_atmupa(mp, sstr, l1, str, l2, ignore, count, 1);
	l = beg - str;
	ret = malloc(l + 1);
	memcpy(ret, str, l);
	ret[l] = 0;
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}


int
clip_CHARADD(ClipMachine * mp)
{
	int l1, l2;
	unsigned char *ret, *e, *end;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int asc = _clip_parni(mp, 2);
	int t2 = _clip_parinfo(mp, 2);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARADD");
	}
	if (t2 == CHARACTER_t)
		asc = *s;
	ret = malloc(l1 + 1);
	memcpy(ret, str, l1);
	ret[l1] = 0;
	for (e = ret, end = ret + l1; e < end; e++)
		*e += asc;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l1);
	_clip_retcn_m(mp, (char *)ret, l1);
	return 0;
}

int
clip_CHARAND(ClipMachine * mp)
{
	int l1, l2;
	unsigned char *ret, *e, *end, *e2, *end2;
	unsigned char *str =(unsigned char *) _clip_parcl(mp, 1, &l1);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL || s == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARAND");
	}
	ret = malloc(l1 + 1);
	memcpy(ret, str, l1);
	ret[l1] = 0;
	end2 = s + l2;
	for (e = ret, end = ret + l1; e < end;)
		for (e2 = s; e2 < end2 && e < end; e++, e2++)
			*e = (*e & *e2);
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l1);
	_clip_retcn_m(mp, (char *)ret, l1);
	return 0;
}

int
clip_CHAREVEN(ClipMachine * mp)
{
	int l, l1, i;
	unsigned char *ret, *e, *end;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHAREVEN");
	}
	l = l1 / 2;
	ret = malloc(l + 1);
	for (i = 0, e = str + 1, end = str + l1; e < end; e += 2, i++)
		ret[i] = *e;
	ret[l] = 0;
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CHARLIST(ClipMachine * mp)
{
	int l, l1, i;
	unsigned char *ret, *buf, *e, *end, *s;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARLIST");
	}
	l = 0;
	buf = calloc(256, 1);
	for (e = str, end = str + l1; e < end; e++)
	{
		s = buf + (*e);
		if (*s == 0)
			l++;
		*s = 1;
	}
	ret = malloc(l + 1);
	for (i = 0, e = buf, end = buf + 256; e < end; e++)
	{
		if (*e == 0)
			continue;
		ret[i] = e - buf;
		i++;
	}
	ret[l] = 0;
	free(buf);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CHARMIRR(ClipMachine * mp)
{
	int l, l1, i;
	unsigned char *ret;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARMIRR");
	}
	l = l1;
	ret = malloc(l + 1);
	for (l = 0, i = l1; i >= 0; i--, l++)
		ret[l] = str[i];
	ret[l] = 0;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CHARMIX(ClipMachine * mp)
{
	int l1, l2, i;
	unsigned char *ret;
	unsigned char *str1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str2 = (unsigned char *)_clip_parcl(mp, 2, &l2);

	if (str1 == NULL || str2 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARMIX");
	}
	if (l2 == 0)
	{
		_clip_retcn(mp, (char *)str1, l1);
		return 0;
	}

	ret = malloc(l1 * 2 + 1);
	for (i = 0; i < l1; i++)
	{
		ret[i * 2] = str1[i % l1];
		ret[i * 2 + 1] = str2[i % l2];
	}
	ret[l1 * 2] = 0;
	_clip_retcn_m(mp, (char *)ret, l1 * 2);
	return 0;
}

int
clip_CHARNOLIST(ClipMachine * mp)
{
	int l, l1, i;
	unsigned char *ret, *buf, *e, *end, *s;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);

	if (str == NULL)
	{
		l = 256;
		ret = malloc(l + 1);
		for (i = 0; i < 256; i++)
			ret[i] = i;
		ret[l] = 0;
		_clip_retcn_m(mp, (char *)ret, l);
		return 0;
	}
	l = 0;
	buf = calloc(256, 1);
	for (e = str, end = str + l1; e < end; e++)
	{
		s = buf + (*e);
		if (*s == 0)
			l++;
		*s = 1;
	}
	l = 256 - l;
	ret = malloc(l + 1);
	for (i = 0, e = buf, end = buf + 256; e < end; e++)
	{
		if (*e == 1)
			continue;
		ret[i] = e - buf;
		i++;
	}
	ret[l] = 0;
	free(buf);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CHARNOT(ClipMachine * mp)
{
	int l, l1, i;
	unsigned char *ret;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARNOT");
	}
	l = l1;
	ret = malloc(l + 1);
	for (i = 0; i < l1; i++)
		ret[i] = (~(str[i]));
	ret[l] = 0;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CHARODD(ClipMachine * mp)
{
	int l, l1, i;
	unsigned char *ret, *e, *end;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARODD");
	}
	l = (l1 + 1) / 2;
	ret = malloc(l + 2);
	for (i = 0, e = str, end = str + l1; e < end; e += 2, i++)
		ret[i] = *e;
	ret[l] = 0;
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CHARONE(ClipMachine * mp)
{
	int l, l1, l2, i;
	unsigned char *ret, *str, *s, *e, *end, *f, p;
	unsigned char *str1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str2 = (unsigned char *)_clip_parcl(mp, 2, &l2);

	if (str1 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARONE");
	}
	s = calloc(256, 1);
	if (str2 != NULL)
	{
		l = l2;
		str = str2;
		for (e = str1, end = str1 + l1; e < end; e++)
			s[(int) (*e)] = 1;
	}
	else
	{
		l = l1;
		str = str1;
		memset(s, 1, 256);
	}
	ret = malloc(l + 1);
	for (p = 0, e = str, end = str + l, i = 0; e < end; e++)
	{
		f = s + (*e);
		if ((*f) == 0 || ((*f) == 1 && p != *e))
		{
			ret[i] = *e;
			i++;
		}
		p = *e;
	}
	free(s);
	ret[i] = 0;
	_clip_retcn_m(mp, (char *)ret, i);
	return 0;
}

int
clip_CHARONLY(ClipMachine * mp)
{
	int l, l1, l2, i;
	unsigned char *ret, *e, *end, *s;
	unsigned char *str1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str2 = (unsigned char *)_clip_parcl(mp, 2, &l2);

	if (str1 == NULL || str2 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARONLY");
	}
	l = l2;
	ret = malloc(l + 1);
	s = calloc(256, 1);
	for (e = str1, end = str1 + l1; e < end; e++)
		s[(int) (*e)] = 1;
	for (i = 0, e = str2, end = str2 + l2; e < end; e++)
	{
		if (s[(int) (*e)] == 1)
		{
			ret[i] = *e;
			i++;
		}
	}
	free(s);
	ret[i] = 0;
	_clip_retcn_m(mp, (char *)ret, i);
	return 0;
}

int
clip_CHAROR(ClipMachine * mp)
{
	int l1, l2;
	unsigned char *ret, *e, *end, *e2, *end2;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL || s == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHAROR");
	}
	ret = malloc(l1 + 1);
	memcpy(ret, str, l1);
	ret[l1] = 0;
	end2 = s + l2;
	for (e = ret, end = ret + l1; e < end;)
		for (e2 = s; e2 < end2 && e < end; e++, e2++)
			*e = (*e | *e2);
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l1);
	_clip_retcn_m(mp, (char *)ret, l1);
	return 0;
}

int
clip_CHARRELA(ClipMachine * mp)
{
	int l1, l2, l3, l4, ret = 0;
	unsigned char *e1, *e2, *e3=NULL, *e4;
	unsigned char *ee1, *ee3;
	unsigned char *end1, *end2, *end3, *end4;
	unsigned char *str1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str2 = (unsigned char *)_clip_parcl(mp, 2, &l2);
	unsigned char *str3 = (unsigned char *)_clip_parcl(mp, 3, &l3);
	unsigned char *str4 = (unsigned char *)_clip_parcl(mp, 4, &l4);

	if (str1 == NULL || str2 == NULL || str3 == NULL || str4 == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARRELA");
	}
	if (l1 == 0 || l3 == 0)
	{
		_clip_retni(mp, 0);
		return 0;
	}
	end1 = str1 + l1;
	end3 = str3 + l3;
	end2 = str2 + l2 - l1 + 1;
	end4 = str4 + l4 - l3 + 1;
	for (e2 = str2, e4 = str4; e2 < end2; e2++, e4++)
	{
		for (e1 = str1, ee1 = e2; e1 < end1 && *e1 == *ee1; e1++, ee1++);
		if (e1 == end1)
			for (e3 = str3, ee3 = e4; e3 < end3 && *e3 == *ee3; e3++, ee3++);
		if (e1 == end1 && e3 == end3)
		{
			ret = e2 - str2 + 1;
			break;
		}

	}
	_clip_retni(mp, ret);
	return 0;
}

int
clip_CHARRELREP(ClipMachine * mp)
{
	int l, l1, l2, l3, l4, l5, cpos;
	unsigned char *e1, *e2, *e3=NULL, *e4;
	unsigned char *ee1, *ee3, *cur, *ret;
	unsigned char *end1, *end2, *end3, *end4;
	unsigned char *str1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str2 = (unsigned char *)_clip_parcl(mp, 2, &l2);
	unsigned char *str3 = (unsigned char *)_clip_parcl(mp, 3, &l3);
	unsigned char *str4 = (unsigned char *)_clip_parcl(mp, 4, &l4);
	unsigned char *str5 = (unsigned char *)_clip_parcl(mp, 5, &l5);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str1 == NULL || str2 == NULL || str3 == NULL || str4 == NULL || str5 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARRELREP");
	}
	if (l1 == 0 || l3 == 0)
	{
		_clip_retcn(mp, (char *)str4, l4);
		return 0;
	}
	l = 0;
	cpos = 0;
	ret = malloc(l + 1);
	cur = str4;
	end1 = str1 + l1;
	end3 = str3 + l3;
	end2 = str2 + l2 - l1 + 1;
	end4 = str4 + l4 - l3 + 1;
	for (e2 = str2, e4 = str4; e2 < end2 && e4 < end4; e2++, e4++)
	{
		for (e1 = str1, ee1 = e2; e1 < end1 && *e1 == *ee1; e1++, ee1++);
		if (e1 == end1)
			for (e3 = str3, ee3 = e4; e3 < end3 && *e3 == *ee3; e3++, ee3++);
		if (e1 == end1 && e3 == end3)
		{
			l += e4 - cur + l5;
			ret = realloc(ret, l + 1);
			memcpy(ret + cpos, cur, e4 - cur);
			cpos += e4 - cur;
			memcpy(ret + cpos, str5, l5);
			cpos += l5;
			e2 += l3;
			e4 += l3;
			cur = e4;
		}

	}
	l += str4 + l4 - cur;
	ret = realloc(ret, l + 1);
	memcpy(ret + cpos, cur, str4 + l4 - cur);
	ret[l] = 0;
	if (rset && _clip_par_isref(mp, 4))
		_clip_par_assign_str(mp, 4, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CHARREM(ClipMachine * mp)
{
	int l, l1, l2, i;
	unsigned char *ret, *e, *end, *s;
	unsigned char *str1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str2 = (unsigned char *)_clip_parcl(mp, 2, &l2);

	if (str1 == NULL || str2 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARREM");
	}
	l = l2;
	ret = malloc(l + 1);
	s = calloc(256, 1);
	for (e = str1, end = str1 + l1; e < end; e++)
		s[(int) (*e)] = 1;
	for (i = 0, e = str2, end = str2 + l2; e < end; e++)
	{
		if (s[(int) (*e)] == 1)
			continue;
		ret[i] = *e;
		i++;
	}
	free(s);
	ret[i] = 0;
	_clip_retcn_m(mp, (char *)ret, i);
	return 0;
}

int
clip_CHARREPL(ClipMachine * mp)
{
	int l, l1, l2, l3, pos, sovp;
	unsigned char *ret, *s, *e1, *end, *send;
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 2, &l2);
	unsigned char *rstr = (unsigned char *)_clip_parcl(mp, 3, &l3);
	int flag = _clip_parl(mp, 4);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (sstr == NULL || str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARREPL");
	}
	l = l2;
	ret = malloc(l + 1);
	memcpy(ret, str, l);
	ret[l] = 0;
	if (l1 == 0)
	{
		_clip_retcn_m(mp, (char *)ret, l);
		return 0;
	}
	while (1)
	{
		end = ret + l;
		send = sstr + l1;
		for (e1 = ret, sovp = 0; e1 < end; e1++)
		{
			for (s = sstr; s < send && *s != *e1; s++);
			if (s == send)
				continue;
			sovp++;
			pos = s - sstr;
			if (pos >= l3)
				pos = l3 - 1;
			*e1 = rstr[pos];

		}
		if (flag || sovp == 0)
			break;
	}
	if (rset && _clip_par_isref(mp, 2))
		_clip_par_assign_str(mp, 2, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

static ClipMachine *_clip_charsort_mp;

int
_clip_charsort(const void *a1, const void *a2)
{
	int ret = 0, *set, i;

	set = _clip_fetch_item(_clip_charsort_mp, HASH_charsort_param);
	for (i = set[2]; i < set[3] && ret == 0; i++)
		ret = (((unsigned char *) a1)[i] >= ((unsigned char *) a2)[i]);
	if (set[0])
		return !ret;
	else
		return ret;
}

int
clip_CHARSORT(ClipMachine * mp)
{
	int l, i, nsort, epos;
	int *set;
	unsigned char *ret, *beg, *end;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int elen = _clip_parni(mp, 2);
	int clen = _clip_parni(mp, 3);
	int ignore = _clip_parni(mp, 4);
	int bpos = _clip_parni(mp, 5);
	int slen = _clip_parni(mp, 6);
	int flag = _clip_parl(mp, 7);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARSORT");
	}
	for (i = 2; i < 7; i++)
	{
		if (_clip_parinfo(mp, i) != LOGICAL_t)
			continue;
		flag = _clip_parl(mp, i);
		break;
	}
	ret = malloc(l + 1);
	memcpy(ret, str, l);
	ret[l] = 0;
	if (elen <= 0)
		elen = 1;
	if (bpos <= 0)
		bpos = 0;
	if (clen <= 0)
		clen = elen - bpos;
	if ((clen + bpos) > elen)
		clen = elen - bpos;
	epos = bpos + clen;
	if (_clip_parinfo(mp, 6) != NUMERIC_t)
		slen = l;
	if (slen <= 0)
		slen = 0;
	if (ignore <= 0)
		ignore = 0;
	beg = ret + ignore;
	end = beg + slen;
	end -= ((end - beg) % elen);
	if (end > (ret + l))
		end = ret + l;
	if (elen > l || ignore > l || beg == end)
	{
		_clip_retcn_m(mp, (char *)ret, l);
		return 0;
	}
	nsort = (end - beg) / elen;
	set = _clip_fetch_item(mp, HASH_charsort_param);
	set[0] = flag;
	set[1] = elen;
	set[2] = bpos;
	set[3] = epos;
	_clip_charsort_mp = mp;
	qsort(beg, nsort, elen, _clip_charsort);
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CHARSPREAD(ClipMachine * mp)
{
	int i, l1, l2, nl = 0, sl, cpos = 0, nch, och;
	unsigned char *e, *end, *ret, *cur;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	int l = _clip_parni(mp, 2);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 3, &l2);
	int ch = _clip_parni(mp, 3);

	if (str == NULL || l == 0)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARSPREAD");
	}
	if (s != NULL)
		ch = *s;
	if (ch == 0)
		ch = ' ';
	ret = malloc(l + 1);
	memcpy(ret, str, l1);
	ret[l1] = 0;
	for (e = str, end = str + l1; e < end;)
	{
		for (; *e != ch && e < end; e++);
		if (*e != ch)
			continue;
		nl++;
		for (; *e == ch && e < end; e++);
	}
	if (nl == 0)
	{
		_clip_retcn_m(mp, (char *)ret, l1);
		return 0;
	}
	sl = l - l1;
	nch = sl / nl;
	och = sl % nl;
	cur = str;
	for (e = str, cur = str, end = str + l1; e < end;)
	{
		for (; *e != ch && e < end; e++);
		if (*e != ch)
			break;
		memcpy(ret + cpos, cur, e - cur);
		cpos += e - cur;
		for (i = 0; i < nch; i++, cpos++)
			ret[cpos] = ch;
		if (och > 0)
		{
			ret[cpos] = ch;
			cpos++;
			och--;
		}
		cur = e;
		for (; *e == ch && e < end; e++);
	}
	memcpy(ret + cpos, cur, e - cur);
	ret[l] = 0;
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CHARSWAP(ClipMachine * mp)
{
	int l, i;
	unsigned char *ret, ch;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARSWAP");
	}
	ret = str;
	ret = malloc(l + 1);
	for (i = 0; i < l; i += 2)
	{
		if (i < l - 1)
		{
			ch = str[i];
			ret[i] = str[i + 1];
			ret[i + 1] = ch;
		}
		else
			ret[i] = str[i];
	}
	ret[l] = 0;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_CHARXOR(ClipMachine * mp)
{
	int l1, l2;
	unsigned char *ret, *e, *end, *e2, *end2;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL || s == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHARXOR");
	}
	ret = malloc(l1 + 1);
	memcpy(ret, str, l1);
	ret[l1] = 0;
	end2 = s + l2;
	for (e = ret, end = ret + l1; e < end;)
		for (e2 = s; e2 < end2 && e < end; e++, e2++)
			*e = (*e ^ *e2);
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l1);
	_clip_retcn_m(mp, (char *)ret, l1);
	return 0;
}

int
clip_CHECKSUM(ClipMachine * mp)
{
	unsigned char *str = (unsigned char *)_clip_parc(mp, 1);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CHECKSUM");
	}
	_clip_retnl(mp, _clip_hashstr((char *)str));
	return 0;
}

int
clip_COUNTLEFT(ClipMachine * mp)
{
	int l1, l2, ret = 0;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int ch = _clip_parni(mp, 2);

	if (str == NULL || l1 == 0)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "COUNTLEFT");
	}
	if (s != NULL)
		ch = *s;
	if (ch == 0)
		ch = ' ';

	for (ret = 0; ret < l1 && str[ret] == ch; ret++);

	_clip_retni(mp, ret);
	return 0;
}

int
clip_COUNTRIGHT(ClipMachine * mp)
{
	int l1, l2, ret = 0;
	unsigned char *e;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int ch = _clip_parni(mp, 2);

	if (str == NULL || l1 == 0)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "COUNTRIGHT");
	}
	if (s != NULL)
		ch = *s;
	if (ch == 0)
		ch = ' ';

	for (ret = 0, e = str + l1 - 1; e > str && *e == ch; e--, ret++);

	_clip_retni(mp, ret);
	return 0;
}

int
clip_CSETREF(ClipMachine * mp)
{
	char *status;

	status = _clip_fetch_item(mp, HASH_csetref);
	_clip_retl(mp, *status == 't');
	if (_clip_parinfo(mp, 0) > 0)
	{
		if (_clip_parl(mp, 1))
			*status = 't';
		else
			*status = 'f';
	}
	return 0;
}

int
clip_EXPAND(ClipMachine * mp)
{
	int l = 0, l1, l2, i;
	unsigned char *e, *ret, *cur, *end, ch = ' ';
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	int kol = _clip_parni(mp, 2);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 2, &l2);

	if (_clip_parinfo(mp, 2) != CHARACTER_t)
		s = (unsigned char *)_clip_parcl(mp, 3, &l2);
	if (s != NULL)
		ch = *s;
	if (kol <= 0)
		kol = 1;

	if (str == NULL || l1 == 0)
	{
		_clip_retc(mp, "");
		return 0;
	}
	l = (l1 - 1) * (kol + 1) + 1;
	ret = malloc(l + 1);
	ret[l] = 0;
	for (cur = ret, e = str, end = str + l1 - 1; e < end; e++)
	{
		*cur = *e;
		for (i = 0, cur++; i < kol; i++, cur++)
			*cur = ch;
	}
	*cur = *e;
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_JUSTLEFT(ClipMachine * mp)
{
	int l1, l2, i;
	unsigned char *e, *ret, *end, *cur;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	int ch = _clip_parni(mp, 2);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (s != NULL)
		ch = *s;
	if (ch == 0)
		ch = ' ';

	if (str == NULL || l1 == 0)
	{
		_clip_retc(mp, "");
		return 0;
	}
	ret = malloc(l1 + 1);
	for (e = str, end = str + l1; e < end && *e == ch; e++);
	i = e - str;
	for (cur = ret; e < end; e++, cur++)
		*cur = *e;
	for (; i > 0; i--, cur++)
		*cur = ch;
	ret[l1] = 0;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l1);
	_clip_retcn_m(mp, (char *)ret, l1);
	return 0;
}

int
clip_JUSTRIGHT(ClipMachine * mp)
{
	int l1, l2, i;
	unsigned char *e, *ret, *end, *cur;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	int ch = _clip_parni(mp, 2);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (s != NULL)
		ch = *s;
	if (ch == 0)
		ch = ' ';

	if (str == NULL || l1 == 0)
	{
		_clip_retc(mp, "");
		return 0;
	}
	ret = malloc(l1 + 1);
	for (e = str + l1 - 1, end = str; e > end && *e == ch; e--);
	i = str + l1 - e - 1;
	end = str + l1 - i;
	for (cur = ret; i > 0; i--, cur++)
		*cur = ch;
	for (e = str; e < end; e++, cur++)
		*cur = *e;
	ret[l1] = 0;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l1);
	_clip_retcn_m(mp, (char *)ret, l1);
	return 0;
}

int
clip_LIKE(ClipMachine * mp)
{
	int sl, l;
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 1, &sl);
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 2, &l);

	if (str == 0 || s == 0)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "LIKE");
	}
	_clip_retl(mp, _clip_glob_match((char *)str, (char *)s, mp->flags & TRANSLATE_FLAG) > 0);
	return 0;
}

int
clip_LTOC(ClipMachine * mp)
{
	if (_clip_parl(mp, 1))
		_clip_retc(mp, "T");
	else
		_clip_retc(mp, "F");
	return 0;
}

int
clip_DSTRTON(ClipMachine * mp)
{

	char *s = _clip_parc(mp, 1);

	if (s != NULL)
		_clip_retndp(mp, *((double *) s), 0, mp->decimals);
	else
		_clip_retni(mp, 0);

	return 0;
}

int
clip_FSTRTON(ClipMachine * mp)
{

	char *s = _clip_parc(mp, 1);

	if (s != NULL)
		_clip_retndp(mp, *((float *) s), 0, mp->decimals);
	else
		_clip_retni(mp, 0);

	return 0;
}

int
clip_MAXLINE(ClipMachine * mp)
{
	int l, ret = 0;
	unsigned char *e, *beg, *end;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);

	if (str == 0)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "MAXLINE");
	}
	for (e = str, beg = str, end = str + l; e <= end; e++)
	{
		if (*e == '\r')
			beg++;
		if (*e != '\n' && *e != 0)
			continue;
		if (ret < (e - beg))
			ret = e - beg;
		beg = e + 1;
	}
	_clip_retni(mp, ret);
	return 0;
}

int
clip_NUMAT(ClipMachine * mp)
{
	int l1, l2, ret = 0, atlike0, atlike1;
	unsigned char *e1, *e2, *s, *beg, *end, *send;
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int ignore = _clip_parni(mp, 3);
	char *atlike = _clip_fetch_item(mp, HASH_setatlike);
	int cset = (*(unsigned char *) _clip_fetch_item(mp, HASH_csetatmupa)) == 't';

	atlike0 = atlike[0];
	atlike1 = atlike[1];

	if (sstr == NULL || str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMAT");
	}
	end = str + l2 - l1 + 1;
	beg = str + l2;
	send = sstr + l1;
	if (ignore < 0)
		ignore = 0;
	for (e1 = str + ignore; e1 < end; e1++)
	{
		for (s = sstr, e2 = e1; s < send && (*s == *e2 || (atlike0 && *s == atlike1)); s++, e2++);
		if (s != send)
			continue;
		ret++;
		if (!cset)
			e1 = e2 - 1;
	}
	_clip_retni(mp, ret);
	return 0;
}

int
clip_NUMLINE(ClipMachine * mp)
{
	int i, l, ret = 0;
	unsigned char *e, *beg, *end;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int len = _clip_parni(mp, 2);

	if (len <= 0)
		len = 80;

	if (str == 0)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMLINE");
	}
	for (e = str, beg = str, end = str + l; e <= end; e++)
	{
		for (i = 1; e < end && i < len && *e != '\n'; e++, i++)
			if (*e == '\r')
				i--;
		ret++;
	}
	_clip_retni(mp, ret);
	return 0;
}

int clip_PADL(ClipMachine * mp);

int
clip_PADLEFT(ClipMachine * mp)
{
	return clip_PADL(mp);
}

int clip_PADR(ClipMachine * mp);

int
clip_PADRIGHT(ClipMachine * mp)
{
	return clip_PADR(mp);
}

int
clip_POSALPHA(ClipMachine * mp)
{
	int l;
	unsigned char *e, *end;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int flag = _clip_parl(mp, 2);
	int ignore = _clip_parni(mp, 3);

	if (str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "POSALPHA");
	}
	if (ignore < 0)
		ignore = 0;
	for (e = str + ignore, end = str + l; e < end && !(_clip_isalpha(*e) ^ flag); e++);
	if (e == end)
		_clip_retni(mp, 0);
	else
		_clip_retni(mp, e - str + 1);
	return 0;
}

int
clip_POSCHAR(ClipMachine * mp)
{
	int l;
	unsigned char *ret;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	unsigned char *s = (unsigned char *)_clip_parc(mp, 2);
	int ch = _clip_parni(mp, 2);
	int pos = _clip_parni(mp, 3);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "POSCHAR");
	}
	if (pos <= 0)
		pos = l;
	pos--;
	if (ch <= 0)
		ch = *s;
	ret = malloc(l + 1);
	memcpy(ret, str, l);
	ret[pos] = ch;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_POSDEL(ClipMachine * mp)
{
	int l, rl, i;
	unsigned char *ret;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int pos = _clip_parni(mp, 2);
	int num = _clip_parni(mp, 3);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "POSDEL");
	}
	if (num <= 0)
		num = 1;
	if (pos <= 0)
		pos = l - num + 1;
	if (pos > l)
	{
		pos = l;
		num = 0;
	}
	pos--;
	rl = l - num;
	ret = malloc(rl + 1);
	memcpy(ret, str, pos);
	for (i = pos + num; i < l; i++, pos++)
		ret[pos] = str[i];
	ret[rl] = 0;
	_clip_retcn_m(mp, (char *)ret, rl);
	return 0;
}

int
clip_POSDIFF(ClipMachine * mp)
{
	int l1, l2;
	unsigned char *e1, *e2, *beg, *end;
	unsigned char *s1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *s2 = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int ignore = _clip_parni(mp, 3);

	if (s1 == NULL || s2 == NULL)
	{
		_clip_retni(mp, -1);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "POSDIFF");
	}
	if (l1 > l2)
	{
		beg = s2;
		end = s2 + l2;
		e1 = s2;
		e2 = s1;
	}
	else
	{
		beg = s1;
		end = s1 + l1;
		e1 = s1;
		e2 = s2;
	}
	e1 += ignore;
	for (; e1 < end && *e1 == *e2; e1++, e2++);
	if (l1 == l2 && e1 == end)
		_clip_retni(mp, 0);
	else
		_clip_retni(mp, e1 - beg + 1);
	return 0;
}

int
clip_POSEQUAL(ClipMachine * mp)
{
	int l1, l2, sovp = 0;
	unsigned char *e1, *e2, *end1, *end2, *beg = NULL;
	unsigned char *s1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *s2 = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int count = _clip_parni(mp, 3);
	int ignore = _clip_parni(mp, 4);

	if (s1 == NULL || s2 == NULL)
	{
		_clip_retni(mp, -1);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "POSEQUAL");
	}
	if (count <= 0)
		count = l1 > l2 ? l2 : l1;
	end1 = s1 + l1;
	end2 = s2 + l2;
	for (e1 = s1 + ignore, e2 = s2 + ignore; e1 < end1 && e2 < end2; e1++, e2++)
	{
		if (*e1 == *e2)
		{
			sovp++;
			if (beg == 0)
				beg = e1;
		}
		else
		{
			beg = 0;
			sovp = 0;
		}
		if (sovp == count)
			break;
	}
	if (sovp < count)
		_clip_retni(mp, 0);
	else
		_clip_retni(mp, beg - s1 + 1);
	return 0;
}

int
clip_POSINS(ClipMachine * mp)
{
	int l1, l2, rl;
	unsigned char *ret;
	unsigned char *s1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *s2 = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int pos = _clip_parni(mp, 3);

	if (s1 == NULL || s2 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "POSINS");
	}
	if (pos <= 0)
		pos = l1;
	if (pos > l1)
	{
		_clip_retcn(mp, (char *)s1, l1);
		return 0;
	}
	pos--;
	rl = l1 + l2;
	ret = malloc(rl + 1);
	memcpy(ret, s1, pos);
	memcpy(ret + pos, s2, l2);
	memcpy(ret + pos + l2, s1 + pos, l1 - pos + 1);
	ret[rl] = 0;
	_clip_retcn_m(mp, (char *)ret, rl);
	return 0;
}

int
clip_POSLOWER(ClipMachine * mp)
{
	int l, x;
	unsigned char *e, *end;
	unsigned char ch;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int flag = _clip_parl(mp, 2);
	int ignore = _clip_parni(mp, 3);

	if (str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "POSLOWER");
	}
	if (ignore < 0)
		ignore = 0;
	for (e = str + ignore, end = str + l; e < end; e++)
	{
		ch = *e;
		x = (ch >= 'a' && ch <= 'z') || (ch == _clip_lowtbl[ch] && _clip_isalpha_tbl[ch]);
		if (x != flag)
			break;
	}
	if (e == end)
		_clip_retni(mp, 0);
	else
		_clip_retni(mp, e - str + 1);
	return 0;
}

int
clip_POSUPPER(ClipMachine * mp)
{
	int l, x;
	unsigned char *e, *end;
	unsigned char ch;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int flag = _clip_parl(mp, 2);
	int ignore = _clip_parni(mp, 3);

	if (str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "POSUPPER");
	}
	if (ignore < 0)
		ignore = 0;
	for (e = str + ignore, end = str + l; e < end; e++)
	{
		ch = *e;
		x = (ch >= 'A' && ch <= 'Z') || (ch == _clip_uptbl[ch] && _clip_isalpha_tbl[ch]);
		if (x != flag)
			break;
	}
	if (e == end)
		_clip_retni(mp, 0);
	else
		_clip_retni(mp, e - str + 1);
	return 0;
}

int
clip_POSRANGE(ClipMachine * mp)
{
	int l, x;
	unsigned char *e, *end;
	unsigned char ch, ch1, ch2;

	unsigned char *s1 = (unsigned char *)_clip_parc(mp, 1);
	unsigned char *s2 = (unsigned char *)_clip_parc(mp, 2);
	int t1 = _clip_parni(mp, 1);
	int t2 = _clip_parni(mp, 2);

	unsigned char *str = (unsigned char *)_clip_parcl(mp, 3, &l);
	int flag = _clip_parl(mp, 4);
	int ignore = _clip_parni(mp, 5);

	if (str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "POSRANGE");
	}
	if (ignore < 0)
		ignore = 0;
	ch1 = s1 == NULL ? t1 : *s1;
	ch2 = s2 == NULL ? t2 : *s2;
	ch1 = _clip_cmptbl[ch1];
	ch2 = _clip_cmptbl[ch2];
	if (ch1 > ch2)
	{
		ch = ch1;
		ch1 = ch2;
		ch1 = ch;
	}
	for (e = str + ignore, end = str + l; e < end; e++)
	{
		ch = _clip_cmptbl[*e];
		x = (ch >= ch1 && ch <= ch2);
		if (x != flag)
			break;
	}
	if (e == end)
		_clip_retni(mp, 0);
	else
		_clip_retni(mp, e - str + 1);
	return 0;
}

int
clip_POSREPL(ClipMachine * mp)
{
	int l1, l2, rl, i;
	unsigned char *ret;
	unsigned char *s1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *s2 = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int pos = _clip_parni(mp, 3);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (s1 == NULL || s2 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "POSREPL");
	}
	if (pos <= 0)
		pos = l1 - l2 + 1;
	if (pos > l1)
	{
		_clip_retcn(mp, (char *)s1, l1);
		return 0;
	}
	pos--;
	rl = (pos + l2) > l1 ? pos + l2 : l1;
	ret = malloc(rl + 1);
	memcpy(ret, s1, pos);
	memcpy(ret + pos, s2, l2);
	for (i = pos + l2; i < l1; i++)
		ret[i] = s1[i];
	ret[rl] = 0;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, rl);
	_clip_retcn_m(mp, (char *)ret, rl);
	return 0;
}

int
clip_RANGEREM(ClipMachine * mp)
{
	int l;
	unsigned char *e, *end, *r, *ret;
	unsigned char ch, ch1, ch2;

	unsigned char *s1 = (unsigned char *)_clip_parc(mp, 1);
	unsigned char *s2 = (unsigned char *)_clip_parc(mp, 2);
	int t1 = _clip_parni(mp, 1);
	int t2 = _clip_parni(mp, 2);

	unsigned char *str = (unsigned char *)_clip_parcl(mp, 3, &l);

	if (str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "RANGEREM");
	}
	ch1 = s1 == NULL ? t1 : *s1;
	ch2 = s2 == NULL ? t2 : *s2;
	ch1 = _clip_cmptbl[ch1];
	ch2 = _clip_cmptbl[ch2];
	if (ch1 > ch2)
	{
		ch = ch1;
		ch1 = ch2;
		ch1 = ch;
	}
	ret = malloc(l + 1);
	for (e = str, r = ret, end = str + l; e < end; e++)
	{
		ch = _clip_cmptbl[*e];
		if (ch >= ch1 && ch <= ch2)
			continue;
		*r = *e;
		r++;
	}
	*r = 0;
	_clip_retcn_m(mp, (char *)ret, r - ret);
	return 0;
}

int
clip_RANGEREPL(ClipMachine * mp)
{
	int l;
	unsigned char *e, *end, *r, *ret;
	unsigned char ch, ch1, ch2, ch3;

	unsigned char *s1 = (unsigned char *)_clip_parc(mp, 1);
	int t1 = _clip_parni(mp, 1);
	unsigned char *s2 = (unsigned char *)_clip_parc(mp, 2);
	int t2 = _clip_parni(mp, 2);
	unsigned char *str =(unsigned char *) _clip_parcl(mp, 3, &l);
	unsigned char *s3 = (unsigned char *)_clip_parc(mp, 4);
	int t3 = _clip_parni(mp, 4);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "RANGEREPL");
	}
	ch1 = s1 == NULL ? t1 : *s1;
	ch1 = _clip_cmptbl[ch1];
	ch2 = s2 == NULL ? t2 : *s2;
	ch2 = _clip_cmptbl[ch2];
	ch3 = s3 == NULL ? t3 : *s3;
	ch3 = ch3 == 0 ? ' ' : ch3;
	ch3 = _clip_cmptbl[ch3];
	if (ch1 > ch2)
	{
		ch = ch1;
		ch1 = ch2;
		ch1 = ch;
	}
	ret = malloc(l + 1);
	for (e = str, r = ret, end = str + l; e < end; e++, r++)
	{
		ch = _clip_cmptbl[*e];
		if (ch >= ch1 && ch <= ch2)
			*r = ch3;
		else
			*r = *e;
	}
	ret[l] = 0;
	if (rset && _clip_par_isref(mp, 2))
		_clip_par_assign_str(mp, 2, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_REMALL(ClipMachine * mp)
{
	int l, rl;
	unsigned char *ret, *e, *end;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	unsigned char *s = (unsigned char *)_clip_parc(mp, 2);
	int ch = _clip_parni(mp, 2);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "REMALL");
	}
	ch = s == NULL ? ch : *s;
	ch = ch == 0 ? ' ' : ch;
	ret = malloc(l + 1);
	for (e = str, end = str + l; e < end && (*e == ch); e++);
	rl = l - (e - str);
	memcpy(ret, e, rl);
	for (e = ret + rl - 1; e >= ret && (*e == ch); e--, rl--)
		ret[rl] = 0;
	ret = realloc(ret, rl + 1);
	ret[rl] = 0;
	_clip_retcn_m(mp, (char *)ret, rl);
	return 0;
}

int
clip_REMLEFT(ClipMachine * mp)
{
	int l, rl;
	unsigned char *ret, *e, *end;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	unsigned char *s = (unsigned char *)_clip_parc(mp, 2);
	int ch = _clip_parni(mp, 2);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "REMLEFT");
	}
	ch = s == NULL ? ch : *s;
	ch = ch == 0 ? ' ' : ch;
	ret = malloc(l + 1);
	for (e = str, end = str + l; e < end && (*e == ch); e++);
	rl = l - (e - str);
	memcpy(ret, e, rl);
	_clip_retcn_m(mp, (char *)ret, rl);
	return 0;
}

int
clip_REMRIGHT(ClipMachine * mp)
{
	int l, rl;
	unsigned char *ret, *e;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	unsigned char *s = (unsigned char *)_clip_parc(mp, 2);
	int ch = _clip_parni(mp, 2);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "REMRIGHT");
	}
	ch = s == NULL ? ch : *s;
	ch = ch == 0 ? ' ' : ch;
	for (e = str + l - 1; e >= str && (*e == ch); e--);
	rl = e - str + 1;
	ret = (unsigned char *) malloc(rl + 1);
	memcpy(ret, str, rl);
	ret[rl] = 0;
	_clip_retcn_m(mp, (char *)ret, rl);
	return 0;
}

int
clip_REPLALL(ClipMachine * mp)
{
	int l;
	unsigned char *ret, *e, *end;
	unsigned char *str =(unsigned char *) _clip_parcl(mp, 1, &l);
	unsigned char *s1 = (unsigned char *)_clip_parc(mp, 2);
	int ch1 = _clip_parni(mp, 2);
	unsigned char *s2 = (unsigned char *)_clip_parc(mp, 3);
	int ch2 = _clip_parni(mp, 3);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL || s1 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "REPLALL");
	}
	ch1 = s1 == NULL ? ch1 : *s1;
	ch1 = ch1 == 0 ? ' ' : ch1;
	ch2 = s2 == NULL ? ch2 : *s2;
	ch2 = ch2 == 0 ? ' ' : ch2;
	ret = malloc(l + 1);
	memcpy(ret, str, l);
	for (e = ret, end = ret + l; e < end && (*e == ch2); e++)
		*e = ch1;
	for (e = ret + l - 1; e >= ret && (*e == ch2); e--)
		*e = ch1;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_REPLLEFT(ClipMachine * mp)
{
	int l;
	unsigned char *ret, *e, *end;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	unsigned char *s1 = (unsigned char *)_clip_parc(mp, 2);
	int ch1 = _clip_parni(mp, 2);
	unsigned char *s2 = (unsigned char *)_clip_parc(mp, 3);
	int ch2 = _clip_parni(mp, 3);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL || s1 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "REPLLEFT");
	}
	ch1 = s1 == NULL ? ch1 : *s1;
	ch1 = ch1 == 0 ? ' ' : ch1;
	ch2 = s2 == NULL ? ch2 : *s2;
	ch2 = ch2 == 0 ? ' ' : ch2;
	ret = malloc(l + 1);
	memcpy(ret, str, l);
	for (e = ret, end = ret + l; e < end && (*e == ch2); e++)
		*e = ch1;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_REPLRIGHT(ClipMachine * mp)
{
	int l;
	unsigned char *ret, *e;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	unsigned char *s1 = (unsigned char *)_clip_parc(mp, 2);
	int ch1 = _clip_parni(mp, 2);
	unsigned char *s2 = (unsigned char *)_clip_parc(mp, 3);
	int ch2 = _clip_parni(mp, 3);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL || s1 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "REPLRIGHT");
	}
	ch1 = s1 == NULL ? ch1 : *s1;
	ch1 = ch1 == 0 ? ' ' : ch1;
	ch2 = s2 == NULL ? ch2 : *s2;
	ch2 = ch2 == 0 ? ' ' : ch2;
	ret = malloc(l + 1);
	memcpy(ret, str, l);
	for (e = ret + l - 1; e >= ret && (*e == ch2); e--)
		*e = ch1;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l);
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_SETATLIKE(ClipMachine * mp)
{
	char *atlike;

	atlike = _clip_fetch_item(mp, HASH_setatlike);
	_clip_retni(mp, atlike[0]);
	if (_clip_parinfo(mp, 1) == NUMERIC_t)
		atlike[0] = _clip_parni(mp, 1);
	if (_clip_parinfo(mp, 1) == LOGICAL_t)
		atlike[0] = _clip_parl(mp, 1);
	if (_clip_parinfo(mp, 2) == NUMERIC_t)
		atlike[1] = _clip_parni(mp, 2);
	if (_clip_parinfo(mp, 2) == CHARACTER_t)
		atlike[1] = *(_clip_parc(mp, 2));
	return 0;
}

int
clip_STRSWAP(ClipMachine * mp)
{
	int l1, l2, l, i;
	unsigned char ch;
	unsigned char *s1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *s2 = (unsigned char *)_clip_parcl(mp, 2, &l2);

	if (s1 == NULL || s2 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "STRSWAP");
	}
	l = l1 < l2 ? l1 : l2;
	for (i = 0; i < l; i++)
	{
		ch = s1[i];
		s1[i] = s2[i];
		s2[i] = ch;
	}
	_clip_retc(mp, "");
	return 0;
}

int
clip_TABEXPAND(ClipMachine * mp)
{
	int l, rl, cur = 0, nt, nl, pos = 0;
	unsigned char *e, *end, *beg, *ret, cch;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int tlen = _clip_parni(mp, 2);
	unsigned char *s = (unsigned char *)_clip_parc(mp, 3);
	int ch = _clip_parni(mp, 3);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return 0;
	}
	ch = s == NULL ? ch : *s;
	ch = ch == 0 ? ' ' : ch;
	tlen = tlen <= 0 ? 8 : tlen;
	rl = 0;
	ret = malloc(rl + 1);
	for (e = str, beg = str, end = str + l; e < end; e++, cur++)
	{

		cch = *e;
		if (cch == '\n')
			cur = -1;
		if (cch == '\t')
		{
			nt = tlen - (cur % tlen);
			cur += nt - 1;
			nl = e - beg + nt;
			rl += nl;
			ret = realloc(ret, rl + 1);
			memcpy(ret + pos, beg, e - beg);
			pos += e - beg;
			memset(ret + pos, ch, nt);
			pos += nt;
			beg = e + 1;
		}
	}
	nl = e - beg;
	rl += nl;
	ret = realloc(ret, rl + 1);
	memcpy(ret + pos, beg, nl);
	ret[rl] = 0;
	_clip_retcn_m(mp, (char *)ret, rl);
	return 0;
}

int
clip_TABPACK(ClipMachine * mp)
{
	int l, rl, cur = 1, pos = 0, kol = 0;
	unsigned char *e, *end, *beg, *ret, cch;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int tlen = _clip_parni(mp, 2);
	unsigned char *s = (unsigned char *)_clip_parc(mp, 3);
	int ch = _clip_parni(mp, 3);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return 0;
	}
	ch = s == NULL ? ch : *s;
	ch = ch == 0 ? ' ' : ch;
	tlen = tlen <= 0 ? 8 : tlen;
	rl = l;
	ret = malloc(rl + 1);
	for (e = str, beg = str, end = str + l + 1; e < end; e++, cur++)
	{
		cch = *e;
		if (cch == '\n' || cch == '\t')
		{
			cur = -1;
			kol = 0;
			continue;
		}
		if (cch == ch)
			kol++;
		else
		{
			kol = 0;
			continue;
		}
		//if (((cur + tlen) % tlen) != 0 && kol < tlen)
		if (((cur + tlen) % tlen) != 0 /*&& kol < 2 */ )
			continue;
		if (kol < 2)
			continue;
		if (cch == ch)
			kol--;
		else if (cch != 0)
		{
			kol = 0;
			continue;
		}
		memcpy(ret + pos, beg, e - beg - kol);
		pos += e - beg - kol;
		ret[pos] = '\t';
		pos++;
		beg = e + (cch != 0);
		kol = 0;

	}
	memcpy(ret + pos, beg, e - beg);
	pos += e - beg - 1;
	ret[pos] = 0;
	_clip_retcn_m(mp, (char *)ret, pos);
	return 0;
}

int
clip_VALPOS(ClipMachine * mp)
{
	int l;
	int ret = 0;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l);
	int num = _clip_parni(mp, 2);

	if (str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "VALPOS");
	}
	if (_clip_parinfo(mp, 0) < 2)
		num = l;
	if (num > 0 && num <= l)
		ret = str[num - 1];
	if (ret >= '0' && ret <= '9')
		ret = ret - '0';
	else
		ret = 0;
	_clip_retni(mp, ret);
	return 0;
}

int
clip_WORDONE(ClipMachine * mp)
{
	int l, l1, l2, i;
	short *ret, *str, *e, *end, word = 0, cword = 0;
	short *str1 = (short *) _clip_parcl(mp, 1, &l1);
	short *str2 = (short *) _clip_parcl(mp, 2, &l2);

	l1 = l1 >> 1;
	l2 = l2 >> 1;

	if (str1 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "WORDONE");
	}
	if (str2 != NULL)
	{
		l = l2;
		str = str2;
		word = *str1;
	}
	else
	{
		l = l1;
		str = str1;
	}
	ret = malloc((l + 1) * 2);
	cword = *str;
	ret[0] = *str;
	for (e = str + 1, end = str + l, i = 1; e < end; e++)
	{
		if (*e == cword && (word == 0 || cword == word))
			continue;
		ret[i] = *e;
		i++;
		cword = *e;
	}
	ret[i] = 0;
	_clip_retcn_m(mp, (char *) ret, i * 2);
	return 0;
}

int
clip_WORDONLY(ClipMachine * mp)
{
	int l1, l2, i = 0;
	short *ret, *e1, *end1, *e2, *end2;
	short *str1 = (short *) _clip_parcl(mp, 1, &l1);
	short *str2 = (short *) _clip_parcl(mp, 2, &l2);

	if (str1 == NULL || str2 == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "WORDONLY");
	}
	l1 = l1 >> 1;
	l2 = l2 >> 1;
	ret = malloc((l2 + 1) * 2);
	for (e2 = str2, end2 = str2 + l2; e2 < end2; e2++)
	{
		for (e1 = str1, end1 = str1 + l1; e1 < end1 && *e2 != *e1; e1++);
		if (*e1 != *e2)
			continue;
		ret[i] = *e2;
		i++;
	}
	ret[i] = 0;
	_clip_retcn_m(mp, (char *) ret, i * 2);
	return 0;
}

int
clip_WORDREPL(ClipMachine * mp)
{
	int l, l1, l2, l3, sovp = 0, rcur;
	short *ret, *cur, *s, *e1, *e2, *end, *send, *buf;
	short *sstr = (short *) _clip_parcl(mp, 1, &l1);
	short *str = (short *) _clip_parcl(mp, 2, &l2);
	short *rstr = (short *) _clip_parcl(mp, 3, &l3);
	int flag = _clip_parl(mp, 4);
	int count = _clip_parni(mp, 5);
	int cset = (*(unsigned char *) _clip_fetch_item(mp, HASH_csetatmupa)) == 't';
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (sstr == NULL || str == NULL || rstr == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "WORDREPL");
	}
	if (count < 0)
		count = 0;
	buf = str;
	if (l1 == 0)
	{
		_clip_retcn(mp, (char *) str, l2);
		return 0;
	}
	l1 = l1 >> 1;
	l2 = l2 >> 1;
	l3 = l3 >> 1;
	while (1)
	{
		l = 0;
		ret = malloc((l + 1) * 2);
		e1 = buf;
		cur = buf;
		end = buf + l2;
		send = sstr + l1;
		for (sovp = 0, rcur = 0; e1 < end; e1++)
		{
			if (*e1 != *sstr)
				continue;
			for (s = sstr, e2 = e1; s < send && e2 < end && *s == *e2; s++, e2++);
			if (s != send)
				continue;
			sovp++;
			/*
			   if (flag && (sovp!=count || count==0))
			   continue;
			 */
			l += e1 - cur + l3;
			ret = realloc(ret, (l + 1) * 2);
			memcpy(ret + rcur, cur, (e1 - cur) * 2);
			rcur += e1 - cur;
			memcpy(ret + rcur, rstr, l3 * 2);
			rcur += l3;
			e1 = e2 - 1;
			cur = e2;
			if (count != 0 && sovp == count)
			{
				e1 = end;
				break;
			}
		}
		l += e1 - cur;
		ret = realloc(ret, (l + 1) * 2);
		memcpy(ret + rcur, cur, (e1 - cur) * 2);
		ret[l] = 0;
		if (buf != str)
			free(buf);
		if (!cset || sovp == 0 || flag || count != 0)
			break;
		buf = malloc((l + 1) * 2);
		memcpy(buf, ret, l * 2);
		l2 = l;
		free(ret);
	}
	if (rset && _clip_par_isref(mp, 2))
		_clip_par_assign_str(mp, 2, (char *) ret, l * 2);
	_clip_retcn_m(mp, (char *) ret, l * 2);
	return 0;
}

int
clip_WORDSWAP(ClipMachine * mp)
{
	int l, i;
	short *ret = 0, ch;
	short *str = (short *) _clip_parcl(mp, 1, &l);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	l = l >> 1;

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "WORDSWAP");
	}
	ret = malloc((l + 1) * 2);
	for (i = 0; i < l; i += 2)
	{
		if (i < l - 1)
		{
			ch = str[i];
			ret[i] = str[i + 1];
			ret[i + 1] = ch;
		}
		else
			ret[i] = str[i];
	}
	ret[l] = 0;
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *) ret, l * 2);
	_clip_retcn_m(mp, (char *) ret, l * 2);
	return 0;
}
int
clip_WORDTOCHAR(ClipMachine * mp)
{
	return clip_ATREPL(mp);
}

// token family function

unsigned char *
_clip_attoken(unsigned char *str, int l1, unsigned char *str2, int l2, int count)
{
	unsigned char *e1, *e2, *s, *dstr, *end, *send, *ret, *ret1;
	int sovp = 1;

	if (str2 == NULL)
	{
		dstr = (unsigned char *)CLIP_TOKEN_CHARACTERS;
		l2 = CLIP_TOKEN_CHARS_NUM;
	}
	else
		dstr = str2;
	end = str + l1;
	send = dstr + l2;
	ret = str; ret1 = NULL;
	for (e1 = str; e1 <= end-l2; e1++)
	{
		for (e2 = e1, s = dstr; s <= send && e2 <= end && *s != *e2; s++, e2++);
		if (*e2 != *s)
			continue;
		if ( sovp == count)
			break;
		if (e1 != str)
			sovp++;
		ret = e1+l2;
		if ( e2 >= end-l2 )
			break;
		if ( ret < end )
			ret1 = ret;
	/*
	printf("\ncount=%d,l1=%d,e2=%d,ret1=%d,ret=%d",count,l1,e2-end,ret1-str,ret-str);
	*/

	}
	/*
	printf("\ncount=%d,ret1=%d,ret=%d\n",count,ret1-str,ret-str);
	*/
	if ( count == 0xFFFF)
		ret = ret1;
	else
		if ( sovp != count)
			ret = NULL;
	return ret;
}

int
clip_ATTOKEN(ClipMachine * mp)
{
	int l1, l2, ret;
	/*int lflag = 0 ;*/
	unsigned char *beg;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *dstr = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int count = 0xffff;

	if ( _clip_parinfo(mp,2) == NUMERIC_t )
		count = _clip_parni(mp, 2);
	if ( _clip_parinfo(mp,3) == NUMERIC_t )
		count = _clip_parni(mp, 3);

	if ( str == NULL )
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "ATTOKEN");
	}
	if ( dstr == NULL )
	{
		dstr = (unsigned char *)("\\ \t\n\r,.;:!?/<<>>()^#&%+-*" );
		l2 = strlen((const char *)dstr);
	}

	if ( count <= 0 )
		{
		_clip_retni(mp,0);
		return 0;
		}

		/*
	if ( count != 0xFFFF )
	{
		if ( l2 == 1 && dstr[0] == 10 )
		{
			count --;
			lflag = 1;
		}
		if ( l2 == 2 && dstr[0] == 13 && dstr[1] == 10 )
		{
			count --;
			lflag = 1;
		}
		//count --;
	}
		*/
	beg = _clip_attoken(str, l1, dstr, l2, count);
	/*
	printf("\ncount=%d,l1=%d,beg=%s,n=%d\n",count,l1,beg,beg +l2 - (str + l1));
	*/
	ret = 0;
	if (beg != NULL )
		ret = beg - str+1;
	/*
		if ( beg + l2 + (count==0xFFFF ? -1: 0) < str + l1)
			ret = beg - str + l2+1;
	*/
	if ( ret > l1 )
		ret = l1;
	_clip_retni(mp, ret);
	return 0;
}

int
clip_NUMTOKEN(ClipMachine * mp)
{
	int l1, l2, ret = 0, nt;
	unsigned char *e, *end, *send, *dstr, *buf;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int tlen = _clip_parni(mp, 3);

	if (str == NULL)
	{
		_clip_retni(mp, 0);
		return 0;
		/*
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMTOKEN");
		*/
	}

	if (sstr == NULL)
	{
		dstr = (unsigned char *)CLIP_TOKEN_CHARACTERS;
		l2 = CLIP_TOKEN_CHARS_NUM;
	}
	else
		dstr = sstr;

	if (tlen <= 0)
		tlen = CLIP_TOKEN_MAXLEN;

	end = str + l1;
	send = dstr + l2;

	buf = calloc(256, 1);
	for (e = dstr; e < send; e++)
		buf[(int) (*e)] = 1;

	for (e=str; e < end && buf[(int) (*e)]; e++);
	for (; e < end;)
	{
		for (; e < end && !buf[(int) (*e)]; e++);
		for (nt = 0; nt < tlen && e < end && buf[(int) (*e)]; e++, nt++);
		ret++;

	}
	free(buf);
	_clip_retni(mp, ret);
	return 0;
}

int
_clip_token_case(ClipMachine * mp, int flag)
{
	int l1, l2, count = 0;
	unsigned char *e, *end, *dstr, *buf, *ret;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int num = _clip_parni(mp, 3);
	int rset = (*(char *) (_clip_fetch_item(mp, HASH_csetref)) == 't');

	if (str == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CLIP_TOKEN");
	}

	if (sstr == NULL)
	{
		dstr = (unsigned char *)CLIP_TOKEN_CHARACTERS;
		l2 = CLIP_TOKEN_CHARS_NUM;
	}
	else
		dstr = sstr;

	buf = calloc(256, 1);
	for (e = dstr; e < dstr + l2; e++)
		buf[(int) (*e)] = 1;
	ret = malloc(l1 + 1);
	memcpy(ret, str, l1);
	ret[l1] = 0;
	end = ret + l1;

	for (; end > ret && buf[(int) (*end)]; end--);
	end++;
	for (e = ret; e < end;)
	{
		for (; e < end && !buf[(int) (*e)]; e++);
		for (; e < end && buf[(int) (*e)]; e++);
		if (e == end)
			break;
		count++;
		if (count > num && num != 0)
			break;

		if (flag)
			*e = _clip_uptbl[*e];
		else
			*e = _clip_lowtbl[*e];

	}
	free(buf);
	if (rset && _clip_par_isref(mp, 1))
		_clip_par_assign_str(mp, 1, (char *)ret, l1);
	_clip_retcn_m(mp, (char *)ret, l1);
	return 0;
}

int
clip_TOKENLOWER(ClipMachine * mp)
{
	return _clip_token_case(mp, 0);
}

int
clip_TOKENUPPER(ClipMachine * mp)
{
	return _clip_token_case(mp, 1);
}

int
clip_TOKENSEP(ClipMachine * mp)
{
	int flag = _clip_parl(mp, 1);
	void *atsep = _clip_fetch_item(mp, HASH_token_atsep);
	atsep += 3 * sizeof(int);

	if (flag)
		atsep += 2;
	_clip_retcn(mp, atsep, 1);
	return 0;
}

int
clip_TOKENAT(ClipMachine * mp)
{
	int flag = _clip_parl(mp, 1);
	int *atsep = _clip_fetch_item(mp, HASH_token_atsep);

	atsep++;
	if (flag)
		atsep++;
	_clip_retni(mp, *atsep);
	return 0;
}

int
clip_TOKENINIT(ClipMachine * mp)
{
	int l1, l2, aaa = 3 * sizeof(int) + 4;
	unsigned char *e, *dstr, *tstr;
	int * tmp;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int tlen = _clip_parni(mp, 3);
	void *atsep = _clip_fetch_item(mp, HASH_token_atsep);
	unsigned char *buf = _clip_fetch_item(mp, HASH_token_delimiters);

	if (_clip_parinfo(mp, 0) == 0)
	{
		memset(atsep, 0, aaa);
		_clip_retl(mp, 1);
		return 0;
	}

	if (str == NULL)
	{
		_clip_retl(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "TOKENINIT");
	}
	memset(atsep, 0, 5 * sizeof(int) + 4);

	_clip_free_item(mp, HASH_token_string);
	tstr = malloc(l1 + 1);
	memcpy(tstr, str, l1);
	tstr[l1] = 0;
	_clip_store_item(mp, HASH_token_string, tstr);
	tmp = (int *) (atsep + aaa);
	*tmp = l1;

	if (sstr == NULL)
	{
		dstr = (unsigned char *)CLIP_TOKEN_CHARACTERS;
		l2 = CLIP_TOKEN_CHARS_NUM;
	}
	else
		dstr = sstr;

	memset(buf, 0, 256);
	for (e = dstr; e < dstr + l2; e++)
		buf[(int) (*e)] = 1;
	tmp = ( int * ) (atsep + aaa + sizeof(int));

	*tmp = tlen;

	_clip_retl(mp, 1);
	return 0;
}

int
clip_SAVETOKEN(ClipMachine * mp)
{
	int l, len_str, tmp = 3 * sizeof(int) + 4;
	unsigned char *ret;
	void *atsep = _clip_fetch_item(mp, HASH_token_atsep);
	void *str = _clip_fetch_item(mp, HASH_token_string);
	void *del = _clip_fetch_item(mp, HASH_token_delimiters);

	len_str = *((int *) (atsep + tmp));
	l = tmp + 2 * sizeof(int) + len_str + 256;

	ret = malloc(l + 1);
	tmp = 5 * sizeof(int) + 4;

	memcpy(ret, atsep, tmp);
	memcpy(ret + tmp, str, len_str);
	memcpy(ret + tmp + len_str, del, 256);
	ret[l] = 0;
	_clip_retcn_m(mp, (char *)ret, l);
	return 0;
}

int
clip_RESTTOKEN(ClipMachine * mp)
{
	int l, len_str, tmp1 = 3 * sizeof(int) + 4, tmp2 = 5 * sizeof(int) + 4;
	void *atsep, *del;
	unsigned char *str;
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 1, &l);

	if (s == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "RESTTOKEN");
	}
	_clip_free_item(mp, HASH_token_atsep);
	_clip_free_item(mp, HASH_token_string);
	_clip_free_item(mp, HASH_token_delimiters);
	atsep = calloc(tmp2, 1);
	memcpy(atsep, s, tmp2);
	_clip_store_item(mp, HASH_token_atsep, atsep);
	len_str = *((int *) (s + tmp1));
	str = malloc(len_str + 1);
	memcpy(str, s + tmp2, len_str);
	str[len_str] = 0;
	_clip_store_item(mp, HASH_token_string, str);
	del = malloc(256);
	memcpy(del, s + tmp2 + len_str, 256);
	_clip_store_item(mp, HASH_token_delimiters, del);

	_clip_retc(mp, "");
	return 0;
}

int
clip_TOKEN(ClipMachine * mp)
{
	int l1, l2, count = 1, nt, *tmp1;
	unsigned char *e, *end, *dstr, *buf, *ret, *tbeg, *tend, *tmp2, tsep;
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *sstr = (unsigned char *)_clip_parcl(mp, 2, &l2);
	int num = _clip_parni(mp, 3);
	int tlen = _clip_parni(mp, 4);
	int ignore = _clip_parni(mp, 5);
	void *atsep = _clip_fetch_item(mp, HASH_token_atsep);
	tmp2 = atsep + 3 * sizeof(int);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "TOKEN");
	}

	if (_clip_parinfo(mp,2) == NUMERIC_t )
	{
		num = _clip_parni(mp, 2);
		sstr = NULL;
	}
	if (_clip_parinfo(mp,3) == CHARACTER_t )
		sstr = (unsigned char *)_clip_parcl(mp, 3, &l2);

	if (sstr == NULL)
	{
		dstr = (unsigned char *)CLIP_TOKEN_CHARACTERS;
		l2 = CLIP_TOKEN_CHARS_NUM;
	}
	else
		dstr = sstr;
	if (tlen <= 0)
		tlen = CLIP_TOKEN_MAXLEN;
	buf = calloc(256, 1);
	for (e = dstr; e < dstr + l2; e++)
		buf[(int) (*e)] = 1;
	end = str + l1;
	for (nt = 0; nt < tlen && end > str + ignore && buf[(int) (*end)]; end--, nt++);
	if (*end != 0)
		end++;
	tend = end;
	tbeg = num <= 2 ? str + ignore : end;
	*tmp2 = 0;
	*(tmp2 + 2) = *tend;
	for (e = str + ignore; e < end;)
	{
		for (; e < end && !buf[(int) (*e)]; e++);
		if (e == end)
			break;
		tsep = *e;
		if (count == num && num != 0)
		{
			*(tmp2 + 2) = *(e);
			tend = e;
		}
		for (nt = 0; nt < tlen && e < end && buf[(int) (*e)]; e++, nt++);
		count++;
		if (count == num || num == 0)
		{
			*tmp2 = tsep;
			tbeg = e;
		}
	}
		if ( count < num )
		{
			free(buf);
			_clip_retc(mp,"");
				return 0;
		}
	tbeg = tbeg > tend ? tend : tbeg;
	ret = malloc(tend - tbeg + 1);
	memcpy(ret, tbeg, tend - tbeg);
	ret[tend - tbeg] = 0;
	/* set data for tokenat,tokensep */
	tmp1 = (int *) atsep;
	tmp1++;
	*tmp1 = tbeg - str + 1;
	tmp1++;
	*tmp1 = tend - str + 1;

	_clip_retcn_m(mp, (char *)ret, tend - tbeg);
	free(buf);
	return 0;
}

int
clip_TOKENNEXT(ClipMachine * mp)
{
	int l1, nt, *tmp1, tlen;
	unsigned char ch,*e, *end, *ret, *tbeg, *tend, *tmp2;
	void *atsep = _clip_fetch_item(mp, HASH_token_atsep);
	unsigned char *str = _clip_fetch_item(mp, HASH_token_string);
	unsigned char *buf = (unsigned char *) _clip_fetch_item(mp, HASH_token_delimiters);
	int ignore = *((int *) atsep);
	tmp2 = atsep + 3 * sizeof(int);

	l1 = *(int *) (tmp2 + 4);
	tlen = *((int *) (tmp2 + 4) + 1);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "TOKENNEXT");
	}

	if (tlen <= 0)
		tlen = CLIP_TOKEN_MAXLEN;

	*tmp2 = 0;
	*(tmp2 + 2) = 0;

	e = str + ignore;
	end = str + l1;
	for (nt = 0; nt < tlen && e < end && buf[(int) (*e)]; e++, nt++);
	if (e != str)
		*tmp2 = *(e - 1);
	tbeg = e;
	for (; e < end && !buf[(int) (*e)]; e++);
	*(tmp2 + 2) = *(e);
	tend = e;
/*        for(nt=0; nt<tlen && e<end && buf[*e];  e++,nt++);*/
	*((int *) atsep) = e - str;

	tbeg = tbeg > tend ? tend : tbeg;
	ret = malloc(tend - tbeg + 1);
	memcpy(ret, tbeg, tend - tbeg);
	ret[tend - tbeg] = 0;
	_clip_retcn_m(mp, (char *)ret, tend - tbeg);
	for (ch=*e; e < end && ch == *e; e++);
	tend = e;
	*((int *) atsep) = tend - str;
	tmp1 = (int *) atsep;
	tmp1++;
	*tmp1 = tbeg - str + 1;
	tmp1++;
	*tmp1 = tend - str + 1;
	return 0;
}

int
clip_TOKENEND(ClipMachine * mp)
{
	int end, len;
	void *atsep = _clip_fetch_item(mp, HASH_token_atsep);
	atsep += 2 * sizeof(int);

	end = *((int *) atsep);
	atsep += sizeof(int) + 4;

	len = *((int *) atsep);
	_clip_retl(mp, end >= len);
	return 0;
}

int
clip_BLANK(ClipMachine * mp)
{
	int l;
	unsigned char *str, *ret;
	int t = _clip_parinfo(mp, 1);
	int flag = _clip_parl(mp, 2);

	if (t == UNDEF_t || t == LOGICAL_t)
		_clip_retl(mp, 0);

	if (t == NUMERIC_t)
		_clip_retndp(mp, 0, 10, 0);

	if (t == DATE_t)
		_clip_retdj(mp, 0);

	if (t == CHARACTER_t && !flag)
		_clip_retc(mp, "");

	if (t == CHARACTER_t && flag)
	{
		str = (unsigned char *)_clip_parcl(mp, 1, &l);
		ret = malloc(l + 1);
		memset(ret, ' ', l);
		ret[l] = 0;
		_clip_retcn_m(mp, (char *)ret, l);
	}
	return 0;
}

int
clip_COMPLEMENT(ClipMachine * mp)
{
	int len, dec;
	long d1, d2;
	int t = _clip_parinfo(mp, 1);

	switch (t)
	{
	case LOGICAL_t:
		_clip_retl(mp, _clip_parl(mp, 1));
		break;
	case NUMERIC_t:
		_clip_parp(mp, 1, &len, &dec);
		_clip_retndp(mp, 0.00 - _clip_parnd(mp, 1), len, dec);
		break;
	case CHARACTER_t:
		clip_CHARNOT(mp);
		break;
	case DATE_t:
		d1 = _clip_jdate(1, 1, 3000);
		d2 = _clip_pardj(mp, 1);
		if (d2 == 0)
			_clip_retdj(mp, d1);
		else
			_clip_retdj(mp, d1 - d2 + _clip_jdate(7, 1, 0));
		break;
	}
	return 0;
}

int
clip_NUL(ClipMachine * mp)
{
	_clip_retc(mp, "");
	return 0;
}

int
clip_TOOLVER(ClipMachine * mp)
{
	_clip_retc(mp, "0.00");
	return 0;
}

int
clip_NUMCOUNT(ClipMachine * mp)
{
	long *count = (long *) _clip_fetch_item(mp, HASH_numcount);
	int par = _clip_parinfo(mp, 0);

	if (par == 1)
		*count += _clip_parnl(mp, 1);
	if (par == 2)
		*count = _clip_parnl(mp, 1);
	_clip_retnl(mp, *count);
	return 0;
}

int
clip_CSCOUNT(ClipMachine * mp)
{
	int i, j, l1, l2;
	unsigned char ch;
	unsigned char *str1 = (unsigned char *)_clip_parcl(mp, 1, &l1);
	unsigned char *str2 = (unsigned char *)_clip_parcl(mp, 2, &l2);

	if (str1 == NULL || str2 == NULL)
	{
		_clip_retni(mp, 0);
		return 0;
	}

	ch = *str1;
	for (i = 0, j = 0; i < l2; i++)
		if (ch == str2[i])
			j++;
	_clip_retni(mp, j);
	return 0;
}

int
clip_WEIGHTTABLE(ClipMachine * mp)
{
	_clip_retcn(mp, (char *)_clip_cmptbl, 256);
	return 0;
}

int
clip_WEIGHTCHR(ClipMachine * mp)
{
	int i;
	unsigned char ch = _clip_parni(mp, 1);

	for (i = 0; i < 256 && _clip_cmptbl[i] != ch; i++)
		;
	_clip_retcn(mp, (char *) &i, 1);
	return 0;
}

int
clip_WEIGHTASC(ClipMachine * mp)
{
	char *s = _clip_parc(mp, 1);

	if (s == NULL)
		_clip_retni(mp, 0);
	else
	{
		int ch = *(unsigned char *) s;

		_clip_retni(mp, _clip_cmptbl[ch]);
	}
	return 0;
}

#if 1
/*
   variante from Konstantin Sukhorabski <kos@walk.chernigov.ua>
*/
#define BYTE char
#define ULONG unsigned long
#define USHORT unsigned short

#define HB_LOBYTE( w )          ( ( BYTE ) ( (w) & 0xFF ) )
#define HB_HIBYTE( w )          ( ( BYTE ) ( ( ( USHORT ) ( w ) >> 8 ) & 0xFF ) )
#define HB_MKUSHORT( lo, hi )   ( ( USHORT ) ( ( ( USHORT ) ( hi ) ) << 8 ) | ( (lo) & 0xFF ) )

int
clip_CRYPT(ClipMachine * mp)
{
	/*
	ULONG ulCryptLen;
	ULONG ulStringLen;
	*/
	int ulCryptLen, ulStringLen;
	ULONG ulCryptPos = 0;
	ULONG ulStringPos;

	BYTE *pbyCrypt = (BYTE *) _clip_parcl(mp, 2, &ulCryptLen);

	BYTE *pbyString = (BYTE *) _clip_parcl(mp, 1, &ulStringLen);
	if(ulCryptLen>1)
	{

		BYTE *pbyResult = (BYTE *) malloc(ulStringLen + 1);

		USHORT uiCount2 = (((USHORT) (pbyCrypt[ulCryptPos] +
							(USHORT) (pbyCrypt[ulCryptPos + 1] * 256)
						   )) & 0xFFFF) ^ ((USHORT) ulCryptLen & 0xFFFF);
		USHORT uiCount1 = 0xAAAA;

		for (ulStringPos = 0; ulStringPos < ulStringLen;)
		{
				USHORT uiTmpCount1 = uiCount1;
				USHORT uiTmpCount2 = uiCount2;
				BYTE byte = pbyString[ulStringPos] ^ pbyCrypt[ulCryptPos++];
				USHORT tmp;

				uiTmpCount2 = HB_MKUSHORT( ( HB_LOBYTE( uiTmpCount2 ) ^
											 HB_HIBYTE( uiTmpCount2 ) ),
										   HB_HIBYTE( uiTmpCount2 )     );

				for (tmp = HB_LOBYTE(uiTmpCount2); tmp; tmp--)
						uiTmpCount2 = (uiTmpCount2 >> 1) |
									  ((uiTmpCount2 & 1) << 15);

				uiTmpCount2 ^= uiTmpCount1;
				uiTmpCount2 += 16;

				uiCount2 = uiTmpCount2;

				uiTmpCount2 &= 0x1E;
				uiTmpCount2 += 2;

				do
				{
						BYTE byTmp;

						uiTmpCount2--;

						for (tmp = HB_LOBYTE(uiTmpCount2); tmp; tmp--)
								uiTmpCount1 = (uiTmpCount1 >> 1) |
											  ((uiTmpCount1 & 1) << 15);

						uiTmpCount1 = HB_MKUSHORT(HB_HIBYTE(uiTmpCount1),
												  HB_LOBYTE(uiTmpCount1));
						uiTmpCount1 = HB_MKUSHORT((HB_LOBYTE(uiTmpCount1) ^ 0xFF),
												  HB_HIBYTE(uiTmpCount1));
						uiTmpCount1 = (uiTmpCount1 << 1) |
									  ((uiTmpCount1 & 0x8000) >> 15);
						uiTmpCount1 ^= 0xAAAA;

						byTmp = HB_LOBYTE(uiTmpCount1);
						byTmp = (byTmp << 1) | ((byTmp & 0x80) >> 7);

						uiTmpCount1 = HB_MKUSHORT(byTmp,
												  HB_HIBYTE(uiTmpCount1));

				}
				while (--uiTmpCount2);

				uiCount1 = uiTmpCount1;

				pbyResult[ulStringPos++] = byte ^ HB_LOBYTE(uiTmpCount1);

				if (ulCryptPos == ulCryptLen)
						ulCryptPos = 0;
		}

		_clip_retcn(mp, (char *) pbyResult, ulStringLen);
		free(pbyResult);
	}
	else
	{
		_clip_retcn(mp, (char *) pbyString, ulStringLen);
	}
	return 0;
}

#else

#define BYTE char
#define ULONG unsigned int
#define USHORT unsigned short

#define HB_LOBYTE( w )          ( ( BYTE ) ( w ) )
#define HB_HIBYTE( w )          ( ( BYTE ) ( ( ( USHORT ) ( w ) >> 8 ) & 0xFF ) )
#define HB_MKUSHORT( lo, hi )   ( ( USHORT ) ( ( ( USHORT ) ( hi ) ) << 8 ) | ( lo ) )


int
clip_CRYPT(ClipMachine * mp)
{
	ULONG ulCryptLen;
	BYTE *pbyCrypt = (BYTE *) _clip_parcl(mp, 2, &ulCryptLen);
	ULONG ulCryptPos = 0;

	ULONG ulStringLen;
	BYTE *pbyString = (BYTE *) _clip_parcl(mp, 1, &ulStringLen);
	ULONG ulStringPos;

	BYTE *pbyResult = (BYTE *) malloc(ulStringLen + 1);

	USHORT uiCount2 = (((USHORT) (pbyCrypt[ulCryptPos] + (USHORT) (pbyCrypt[ulCryptPos + 1] * 256)
				)) & 0xFFFF) ^ ((USHORT) ulCryptLen & 0xFFFF);
	USHORT uiCount1 = 0xAAAA;

	for (ulStringPos = 0; ulStringPos < ulStringLen;)
	{
		USHORT uiTmpCount1 = uiCount1;
		USHORT uiTmpCount2 = uiCount2;
		BYTE byte = pbyString[ulStringPos] ^ pbyCrypt[ulCryptPos++];
		USHORT tmp;

		uiTmpCount2 = HB_MKUSHORT((HB_LOBYTE(uiTmpCount2) ^ HB_HIBYTE(uiTmpCount2)), HB_HIBYTE(
														  uiTmpCount2));

		for (tmp = HB_LOBYTE(uiTmpCount2); tmp; tmp--)
			uiTmpCount2 = (uiTmpCount2 >> 1) | ((uiTmpCount2 & 1) << 15);

		uiTmpCount2 ^= uiTmpCount1;
		uiTmpCount2 += 16;

		uiCount2 = uiTmpCount2;

		uiTmpCount2 &= 0x1E;
		uiTmpCount2 += 2;

		do
		{
			BYTE byTmp;

			uiTmpCount2--;

			for (tmp = HB_LOBYTE(uiTmpCount2); tmp; tmp--)
				uiTmpCount1 = (uiTmpCount1 >> 1) | ((uiTmpCount1 & 1) << 15);

			uiTmpCount1 = HB_MKUSHORT(HB_HIBYTE(uiTmpCount1), HB_LOBYTE(uiTmpCount1));
			uiTmpCount1 = HB_MKUSHORT((HB_LOBYTE(uiTmpCount1) ^ 0xFF), HB_HIBYTE(uiTmpCount1));
			uiTmpCount1 = (uiTmpCount1 << 1) | ((uiTmpCount1 & 0x8000) >> 15);
			uiTmpCount1 ^= 0xAAAA;

			byTmp = HB_LOBYTE(uiTmpCount1);
			byTmp = (byTmp << 1) | ((byTmp & 0x80) >> 7);

			uiTmpCount1 = HB_MKUSHORT(byTmp, HB_HIBYTE(uiTmpCount1));

		}
		while (--uiTmpCount2);

		uiCount1 = uiTmpCount1;

		pbyResult[ulStringPos++] = byte ^ HB_LOBYTE(uiTmpCount1);

		if (ulCryptPos == ulCryptLen)
			ulCryptPos = 0;
	}

	_clip_retcn(mp, (char *) pbyResult, ulStringLen);
	free(pbyResult);
	return 0;
}
#endif

#ifdef OS_LINUX
	static int plevel = 0;
#endif

static int
take_permissions(ClipMachine *mp, int port)
{
#ifdef OS_LINUX
	if (plevel > 2)
		return 0;
	if (port >= 0x400)
	{
		if (plevel < 3)
		{
			  try_iopl:
			if (iopl(3))
			{
				_clip_trap_printf(mp, __FILE__, __LINE__, "Cannot take io permissons: %s", strerror(errno));
				return _clip_call_errblock(mp, -1);
			}
			plevel = 3;
			return 0;
		}
	}
	else
	{
		if (ioperm(port, 1, 1))
			goto try_iopl;
	}
#endif

#ifdef OS_FREEBSD
#ifdef ARCH_i386
	if (i386_set_ioperm(port, 1, 1))
	{
		_clip_trap_printf(mp, __FILE__, __LINE__, "Cannot take io permissons: %s", strerror(errno));
		return _clip_call_errblock(mp, -1);
	}
#endif
#endif

#ifdef OS_GYGWIN
#endif

	return 0;
}

static int
m_out_portb(ClipMachine *mp, int port, int val)
{
	int r;

	r = take_permissions(mp, port);
	if (r)
		return r;

#if defined(OS_LINUX) || defined(OS_FREEBSD)
	outb(val, port);
#endif

	return 0;
}

static int
m_in_portb(ClipMachine *mp, int port)
{
	int r;

	r = take_permissions(mp, port);
	if (r)
		return r;

#if defined(OS_LINUX) || defined(OS_FREEBSD)
	r = inb(port);
#endif

	return r;
}

static int
m_out_portw(ClipMachine *mp, int port, int val)
{
	int r;

	r = take_permissions(mp, port);
	if (r)
		return r;

#if defined(OS_LINUX) || defined(OS_FREEBSD)
	outw(val, port);
#endif

	return 0;
}

static int
m_in_portw(ClipMachine *mp, int port)
{
	int r;

	r = take_permissions(mp, port);
	if (r)
		return r;

#if defined(OS_LINUX) || defined(OS_FREEBSD)
	r = inw(port);
#endif

	return r;
}

/*
   OUTBYTE(<nPort|cHexPort>,<nOutByte|cHexOutByte>) --> lSuccessful
 */
int
clip_OUTBYTE(ClipMachine * mp)
{
	int port, val, r;
	char *portc, *valc;

	if (mp->argc < 2)
		return EG_ARG;

	portc = _clip_parc(mp, 1);
	valc = _clip_parc(mp, 2);

	if (portc)
		port = strtol(portc, 0, 16);
	else
		port = _clip_parni(mp, 1);
	if (valc)
		val = strtol(valc, 0, 16);
	else
		val = _clip_parni(mp, 2);

	r = m_out_portb(mp, port, val);

	_clip_retl(mp, !r);

	return 0;
}

/*
   OUTWORD(<nPort|cHexPort>,<nOutByte|cHexOutByte>) --> lSuccessful
 */
int
clip_OUTWORD(ClipMachine * mp)
{
	int port, val, r;
	char *portc, *valc;

	if (mp->argc < 2)
		return EG_ARG;

	portc = _clip_parc(mp, 1);
	valc = _clip_parc(mp, 2);

	if (portc)
		port = strtol(portc, 0, 16);
	else
		port = _clip_parni(mp, 1);
	if (valc)
		val = strtol(valc, 0, 16);
	else
		val = _clip_parni(mp, 2);

	r = m_out_portw(mp, port, val);

	_clip_retl(mp, !r);

	return 0;
}

/*
   INBYTE(<nPort|cHexPort>) --> nByte
 */
int
clip_INBYTE(ClipMachine * mp)
{
	int port, r;
	char *portc;

	if (mp->argc < 1)
		return EG_ARG;

	portc = _clip_parc(mp, 1);

	if (portc)
		port = strtol(portc, 0, 16);
	else
		port = _clip_parni(mp, 1);

	r = m_in_portb(mp, port);

	_clip_retni(mp, r);

	return 0;
}

/*
   INWORD(<nPort|cHexPort>) --> nByte
 */
int
clip_INWORD(ClipMachine * mp)
{
	int port, r;
	char *portc;

	if (mp->argc < 1)
		return EG_ARG;

	portc = _clip_parc(mp, 1);

	if (portc)
		port = strtol(portc, 0, 16);
	else
		port = _clip_parni(mp, 1);

	r = m_in_portw(mp, port);

	_clip_retni(mp, r);

	return 0;
}

int
_clip_setxlat(ClipMachine * mp, unsigned char * data)
{
	int no = _clip_parni(mp,1) % 256;
	unsigned char * s = (unsigned char *)_clip_parc(mp,1);
	_clip_retl(mp,0);
	if ( s!=NULL )
		no = *s;
	if ( _clip_parinfo(mp,0) == 0)
	{
		int i;
		for ( i = 0; i<256; i++)
			data[i] = i;
		_clip_retl(mp,1);
		return 0;
	}
	if ( _clip_parinfo(mp,0) >= 2)
	{
		int len;
		unsigned char * str = (unsigned char *)_clip_parcl(mp,2,&len);
		if ( ( no + len) > 256 )
			len = 256 - no;
		memcpy(data+no, str, len);
		_clip_retl(mp,1);
		return 0;
	}
	return 0;
}

int
_clip_getxlat(ClipMachine * mp, unsigned char * data)
{
	_clip_retcn(mp, (char *)data, 256);
	return 0;
}

int
clip_SETTXLAT(ClipMachine * mp)
{
	return _clip_setxlat(mp,mp->term_xlat);
}

int
clip_GETTXLAT(ClipMachine * mp)
{
	return _clip_getxlat(mp,mp->term_xlat);
}

int
clip_SETPXLAT(ClipMachine * mp)
{
	return _clip_setxlat(mp,mp->prn_xlat);
}

int
clip_GETPXLAT(ClipMachine * mp)
{
	return _clip_getxlat(mp,mp->prn_xlat);
}
