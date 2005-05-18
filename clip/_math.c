/*
    Copyright (C) 2001  ITK
    Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log: _math.c,v $
   Revision 1.38  2005/03/29 08:09:12  clip
   uri: small fix in random(lValue)

   Revision 1.37  2004/12/21 14:10:55  clip
   uri: small fix

   Revision 1.36  2004/11/05 09:22:07  clip
   uri: add ROUN(),FCOUN() - short func names

   Revision 1.35  2003/10/31 12:51:29  clip
   uri: small fix in INT()

   Revision 1.34  2003/06/25 09:53:56  clip
   uri: fixed int(0.0012*10000)

   Revision 1.33  2003/06/10 10:13:10  clip
   uri: memory leak fixed in ntoc()

   Revision 1.32  2003/03/26 14:20:19  clip
   uri: small fix for round(0.644999999,2)

   Revision 1.31  2002/07/16 07:17:11  clip
   uri: bug in VAL() fixed

   Revision 1.30  2001/12/22 09:25:57  clip
   uri: small fix

   Revision 1.29  2001/11/26 12:59:30  clip
   uri: small bugs

   Revision 1.28  2001/08/30 14:28:23  clip
   uri: small bug

   Revision 1.27  2001/08/21 15:23:35  clip
   uri:bug in NTOC()

   Revision 1.26  2001/06/12 09:26:52  clip
   uri: bug in NTOC function

   Revision 1.25  2001/05/13 11:54:50  clip
   uri: _clip_strtod() over strtod()

   Revision 1.24  2001/05/11 05:22:13  clip
   uri: FLT_MAX in new RH

   Revision 1.23  2001/04/05 11:17:41  clip
   remake function round()

   Revision 1.22  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.21  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.20  2001/03/05 12:14:43  clip
   clip_LOG10

   Revision 1.19  2000/10/20 11:45:49  clip
   round() and round in str() small bugs
   from uri:

   Revision 1.18  2000/10/20 08:03:23  clip
   Вкрутил rational везде где упоминается NUMERIC_t
   может чего и осталось неотловленное, но это может быть только в тех
   местах где нет использования NUMERIC_t !!!!!
   from uri:

   Revision 1.17  2000/05/03 19:32:25  clip
   add prefix 'clip_' to all clip functions

   Revision 1.16  2000/04/27 22:55:44  clip
   freebsd fix

   Revision 1.15  2000/04/14 19:11:42  uri
   кучка функций num* из tools

   Revision 1.14  2000/04/14 00:51:19  uri
   Кучка функций для math+tools

   Revision 1.13  2000/03/30 21:17:09  uri
   переделал под новый error

   Revision 1.12  2000/03/22 21:10:16  uri
   bug in dbselectarea with numeric parameter

   Revision 1.11  2000/03/21 19:20:28  uri
   bug in tabexpand, tabpack

   Revision 1.10  2000/01/25 16:49:21  vlad
   *** empty log message ***

   Revision 1.9  1999/12/23 17:12:39  vlad
   Полная обработка ошибок

   Revision 1.8  1999/12/16 17:43:52  vlad
   SETBIT, ISBIT, NUMXOR, NUMAND, NUMOR, NUMNOT
   Добавлена обработка ошибок

   Revision 1.7  1999/12/10 23:06:28  vlad
   Изменен алгоритм BITTOC

   Revision 1.6  1999/12/10 14:57:50  vlad
   *** empty log message ***

   Revision 1.5  1999/12/09 16:11:05  uri
   доделал несколько math функций

   Revision 1.4  1999/12/09 15:02:01  vlad
   CTOBIT, CELSIUS, FAHRENHEIT

   Revision 1.3  1999/12/08 15:28:17  vlad
   Сделана BITTOC

   Revision 1.2  1999/10/26 19:11:11  paul
   start cvs logging

 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>
#include <time.h>
#include <math.h>
#include "clip.h"
#include "error.ch"
#include "rational.h"

#ifdef HAVE_FLOAT_H
#include <float.h>
#endif

int
clip_EXP(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	if (mp->flags & FIXED_FLAG)
		dec = mp->decimals;
	else
		dec *= 2;
	if (dec <= 0)
		dec = mp->decimals;
	_clip_retndp(mp, exp(d), len, dec);
	return 0;
}

int
clip_LOG(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	if (mp->flags & FIXED_FLAG)
		dec = mp->decimals;
	else
		dec *= 2;
	if (dec <= 0)
		dec = mp->decimals;
	_clip_retndp(mp, log(d), len, dec);
	return 0;
}

int
clip_LOG10(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	if (mp->flags & FIXED_FLAG)
		dec = mp->decimals;
	else
		dec *= 2;
	if (dec <= 0)
		dec = mp->decimals;
	_clip_retndp(mp, log10(d), len, dec);
	return 0;
}

int
clip_POW(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);
	double d2 = _clip_parnd(mp, 2);

	_clip_parp(mp, 1, &len, &dec);
	if (mp->flags & FIXED_FLAG)
		dec = mp->decimals;
	else
		dec *= 2;
	if (dec <= 0)
		dec = mp->decimals;
	_clip_retndp(mp, pow(d, d2), len, dec);
	return 0;
}

int
clip_SQRT(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	if (mp->flags & FIXED_FLAG)
		dec = mp->decimals;
	else
		dec *= 2;
	if (dec <= 0)
		dec = mp->decimals;
	_clip_retndp(mp, sqrt(d), len, dec);
	return 0;
}

int
clip_INT(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = 0;
#ifdef ARCH_i386
		(*(long long*)&d)++;
#endif
	_clip_retndp(mp, d - fmod(d,1.00), len, dec);
	return 0;
}

int
clip_MOD(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);
	double d2 = _clip_parnd(mp, 2);

	_clip_parp(mp, 1, &len, &dec);
	if (mp->flags & FIXED_FLAG)
		dec = mp->decimals;
	else
		dec *= 2;
	if (dec <= 0)
		dec = mp->decimals;
	_clip_retndp(mp, fmod(d, d2), len, dec);
	return 0;
}

int
clip_ROUND(ClipMachine * mp)
{
#if 1
	int len, dec;
	double d = _clip_parnd(mp, 1);
	ClipVar *vp=_clip_par(mp,1);
	int de = _clip_parni(mp, 2);

#ifdef ARCH_i386
	(*(long long*)&d)++;
#endif

	_clip_parp(mp, 1, &len, &dec);
	dec = de;
	if (dec <= 0)
		dec = 0;
	if ( vp->t.memo )
	{
		char *tmp=rational_toString(vp->r.r,10,dec,0);
		_clip_retnr(mp,rational_fromString(tmp),len,dec);
		free(tmp);
		return 0;
	}
	if( d == 0.0 )
	{
		_clip_retndp(mp, d, len, de);
		return 0;
	}
	if( de == 0 )
	{
		if( d < 0.0 )
			d = ceil( d - 0.5 );
		else
			d = floor( d + 0.5 );
		_clip_retndp(mp, d, len, dec);
		return 0;
	}
	if( de < 0 )
	{
		double tmp = pow( 10, -de );
		if( d < 0.0 )
			d = ceil( ( d / tmp ) - 0.5 );
		else
			d = floor( ( d / tmp ) + 0.5 );
		d *= tmp;
	}
	else
	{
		double tmp = pow( 10, de );
		if( d < 0.0 )
			d = ceil( ( d * tmp ) - 0.5 );
		else
			d = floor( ( d * tmp ) + 0.5 );
		 d /= tmp;
	 }
	_clip_retndp(mp, d, len, dec);
	 return 0;
#else
	int len, dec, len1;
	char buf[33],ch;
	double ret, d = _clip_parnd(mp, 1);
	int de = _clip_parni(mp, 2);
	_clip_parp(mp, 1, &len, &dec);

	buf[32]=0;
	if (len > 30 )
		len=30;
	_clip_dtostr(buf, len, de+1, d, 0);
	len1 = strlen(buf)-1;
	ch = buf[len1];
	if ( ch >='5' )
		buf[len1-1] ++;
	buf[len1] = 0;
	ret = _clip_strtod(buf, &dec);
	_clip_retndp(mp, ret, len, de);
	return 0;
#endif
}

int
clip_ROUN(ClipMachine * mp)
{
	return clip_ROUND(mp);
}

int
clip_SIN(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = mp->decimals;
	_clip_retndp(mp, sin(d), len, dec);
	return 0;
}

int
clip_COS(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = mp->decimals;
	_clip_retndp(mp, cos(d), len, dec);
	return 0;
}

int
clip_TAN(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = mp->decimals;
	_clip_retndp(mp, tan(d), len, dec);
	return 0;
}

int
clip_ASIN(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = mp->decimals;
	_clip_retndp(mp, asin(d), len, dec);
	return 0;
}
int
clip_ACOS(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = mp->decimals;
	_clip_retndp(mp, acos(d), len, dec);
	return 0;
}

int
clip_ATAN(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = mp->decimals;
	_clip_retndp(mp, atan(d), len, dec);
	return 0;
}

int
clip_ATN2(ClipMachine * mp)
{
	int len1, dec1, len2, dec2;
	double d1 = _clip_parnd(mp, 1);
	double d2 = _clip_parnd(mp, 2);

	_clip_parp(mp, 1, &len1, &dec1);
	_clip_parp(mp, 2, &len2, &dec2);
	dec1 = mp->decimals;
	_clip_retndp(mp, atan2(d1, d2), len1, dec1);
	return 0;
}

int
clip_ATAN2(ClipMachine * mp)
{
	int len1, dec1, len2, dec2;
	double d1 = _clip_parnd(mp, 1);
	double d2 = _clip_parnd(mp, 2);

	_clip_parp(mp, 1, &len1, &dec1);
	_clip_parp(mp, 2, &len2, &dec2);
	dec1 = mp->decimals;
	_clip_retndp(mp, atan2(d1, d2), len1, dec1);
	return 0;
}

int
clip_ABS(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	_clip_retndp(mp, fabs(d), len, dec);
	return 0;
}

int
clip_CEILING(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = 0;
	_clip_retndp(mp, ceil(d), len, dec);
	return 0;
}

int
clip_FLOOR(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = 0;
	_clip_retndp(mp, floor(d), len, dec);
	return 0;
}

int
clip_PI(ClipMachine * mp)
{
	_clip_retndp(mp, M_PI, 21, 19);
	return 0;
}

int
clip_SIGN(ClipMachine * mp)
{
	int len, dec, ret = 0;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	if (d > 0)
		ret = 1;
	if (d < 0)
		ret = -1;
	_clip_retni(mp, ret);
	return 0;
}

int
clip_DTOR(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = mp->decimals;
	_clip_retndp(mp, M_PI * d / 180, len, dec);
	return 0;
}

int
clip_COT(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = mp->decimals;
	_clip_retndp(mp, 1 / tan(d), len, dec);
	return 0;
}

int
clip_FACT(ClipMachine * mp)
{
	double ret = 1;
	int i;
	int num = _clip_parni(mp, 1);

	if (num > 21)
	{
		_clip_retni(mp, -1);
		return 0;
	}
	for (i = 1; i <= num; i++)
		ret *= i;
	_clip_retndp(mp, ret, num, 0);
	return 0;
}

int
clip_FV(ClipMachine * mp)
{
	int len, dec, i;
	double ret;
	double sum = _clip_parnd(mp, 1);
	double prec = 1.00 + _clip_parnd(mp, 2);
	int per = _clip_parni(mp, 3);

	_clip_parp(mp, 1, &len, &dec);
	dec = mp->decimals;
	for (ret = sum, i = 0; i < per; i++)
		ret *= prec;
	_clip_retndp(mp, ret, len, dec);
	return 0;
}

int
clip_GETPREC(ClipMachine * mp)
{
	_clip_retni(mp, 16);
	return 0;
}

int
clip_SETPREC(ClipMachine * mp)
{
	_clip_retc(mp, "");
	return 0;
}

int
clip_RTOD(ClipMachine * mp)
{
	int len, dec;
	double d = _clip_parnd(mp, 1);

	_clip_parp(mp, 1, &len, &dec);
	dec = mp->decimals;
	_clip_retndp(mp, d * 180 / M_PI, len, dec);
	return 0;
}

int
clip_RANDOM(ClipMachine * mp)
{
	long ret = 0;
	long d = _clip_parnl(mp, 1);
	long l = _clip_parl(mp, 1);

	if (_clip_parinfo(mp,1) == LOGICAL_t )
		d = 0xFFFF;

	if (d != 0)
		ret = random() % d;
	else
		ret = random();
	if (_clip_parinfo(mp,1) == LOGICAL_t && !l)
		ret -= d/2;
	_clip_retnl(mp, ret);
	return 0;
}

int
clip_RAND(ClipMachine * mp)
{
	double ret= ((double) random()) / 0x7FFFFFFF;
	if ( ret < 0 )
		ret = 0-ret;
	_clip_retnd(mp, ret );
	return 0;
}

int
clip_RANDOMIZE(ClipMachine * mp)
{
	srandom(time(0));
	return 0;
}

/*
   #define clip_err(clipvar,iff,msg,retf,ret)   \
   if ((iff)) \
   { \
   _clip_trap_printf((clipvar),__FILE__,__LINE__,(msg)); \
   retf((clipvar),(ret)); \
   return 1; \
   }
 */

int
clip_BITTOC(ClipMachine * mp)
{
	unsigned int Num = _clip_parni(mp, 1);
	int LenPattern;
	char *BitPattern = _clip_parcl(mp, 2, &LenPattern);
	char *p, res[] = "                ";
	unsigned int Mask;
	int Len = _clip_parinfo(mp, 0), RealLen;
	int t1 = _clip_parinfo(mp, 1);
	int t2 = _clip_parinfo(mp, 2);

	if (Len < 2 || t1 != NUMERIC_t || t2 != CHARACTER_t)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "BITTOC");
	}

	if (LenPattern > 16)
		LenPattern = 16;
	if (_clip_parl(mp, 3))
	{
		for (RealLen = LenPattern, Len = 0, Mask = 1 << (LenPattern - 1); Len < LenPattern; Mask >>= 1, Len++)
			if (Num & Mask)
				res[Len] = BitPattern[Len];
	}
	else
	{
		for (RealLen = 0, p = res, Len = 0, Mask = 1 << (LenPattern - 1); Len < LenPattern; Mask >>= 1, Len++)
			if (Num & Mask)
			{
				*p = BitPattern[Len];
				p++;
				RealLen++;
			}
	}
	_clip_retcn(mp, res, RealLen);
	return 0;
}

int
clip_CTOBIT(ClipMachine * mp)
{
	int LSel, LMask, i, j;
	char *CSel = _clip_parcl(mp, 1, &LSel);
	char *CMask = _clip_parcl(mp, 2, &LMask);
	unsigned int Res = 0;

	if (_clip_parinfo(mp, 0) != 2 || CSel == NULL || CMask == NULL)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CTOBIT");
	}

	if (LSel > 16)
		LSel = 16;
	if (LMask > 16)
		LMask = 16;
	for (i = 0; i < LSel; i++)
	{
		for (j = 0; j < LMask && CSel[i] != CMask[j]; j++);
		if (j != LMask)
			Res |= 1 << (LMask - j - 1);
	}
	_clip_retni(mp, Res);
	return 0;
}

int
clip_CELSIUS(ClipMachine * mp)
{
	_clip_retnd(mp, (_clip_parnd(mp, 1) - 32) * 5 / 9);
	return 0;
}

int
clip_FAHRENHEIT(ClipMachine * mp)
{
	_clip_retnd(mp, _clip_parnd(mp, 1) * 9 / 5 + 32);
	return 0;
}

int
StrToInt(char *s, int len, int *res)
{
	unsigned int i;
	int j;

	for (i = j = 0; j < len && j < sizeof(int) * 2; j++)

		switch (s[j])
		{
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			i = (i << 4) + (s[j] - '0');
			break;
		case 'A':
		case 'B':
		case 'C':
		case 'D':
		case 'E':
		case 'F':
			i = (i << 4) + s[j] - 'A' + 10;
			break;
		case 'a':
		case 'b':
		case 'c':
		case 'd':
		case 'e':
		case 'f':
			i = (i << 4) + s[j] - 'a' + 10;
			break;
		default:
			if (j == 0)
				return j + 1;
			else
			{
				*res = i;
				return 0;
			}
		}
	*res = i;
	return 0;
}

int
clip_NUMNOT(ClipMachine * mp)
{
	_clip_retni(mp, ~_clip_parni(mp, 1));
	return 0;
}

int
clip_NUMAND(ClipMachine * mp)
{
	int Num;
	int i = _clip_parinfo(mp, 0);
	int SLen;
	char *S;
	int tmp;

	if (i < 2)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMAND");
	}
	switch (_clip_parinfo(mp, 1))
	{
	case NUMERIC_t:
		Num = _clip_parni(mp, 1);
		break;
	case CHARACTER_t:
		S = _clip_parcl(mp, 1, &SLen);
		StrToInt(S, SLen, &Num);
		break;
	default:
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMAND");
	}
	for (; i > 1; i--)
	{
		switch (_clip_parinfo(mp, i))
		{
		case NUMERIC_t:
			tmp = _clip_parni(mp, i);
			break;
		case CHARACTER_t:
			S = _clip_parcl(mp, i, &SLen);
			StrToInt(S, SLen, &tmp);
			break;
		default:
			_clip_retni(mp, 0);
			return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMAND");
		}
		Num &= tmp;
	}
	_clip_retni(mp, Num);
	return 0;
}

int
clip_NUMOR(ClipMachine * mp)
{
	int Num;
	int i = _clip_parinfo(mp, 0);
	int SLen;
	char *S;
	int tmp;

	if (i < 2)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMOR");
	}
	switch (_clip_parinfo(mp, 1))
	{
	case NUMERIC_t:
		Num = _clip_parni(mp, 1);
		break;
	case CHARACTER_t:
		S = _clip_parcl(mp, 1, &SLen);
		StrToInt(S, SLen, &Num);
		break;
	default:
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMOR");
	}
	for (; i > 1; i--)
	{
		switch (_clip_parinfo(mp, i))
		{
		case NUMERIC_t:
			tmp = _clip_parni(mp, i);
			break;
		case CHARACTER_t:
			S = _clip_parcl(mp, i, &SLen);
			StrToInt(S, SLen, &tmp);
			break;
		default:
			_clip_retni(mp, 0);
			return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMOR");
		}
		Num |= tmp;
	}
	_clip_retni(mp, Num);
	return 0;
}

int
clip_NUMXOR(ClipMachine * mp)
{
	int Num1, Num2, SLen;
	char *S;

	if (_clip_parinfo(mp, 0) != 2)
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMXOR");
	}
	switch (_clip_parinfo(mp, 1))
	{
	case NUMERIC_t:
		Num1 = _clip_parni(mp, 1);
		break;
	case CHARACTER_t:
		S = _clip_parcl(mp, 1, &SLen);
		StrToInt(S, SLen, &Num1);
		break;
	default:
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMXOR");
	}
	switch (_clip_parinfo(mp, 2))
	{
	case NUMERIC_t:
		Num2 = _clip_parni(mp, 2);
		break;
	case CHARACTER_t:
		S = _clip_parcl(mp, 2, &SLen);
		StrToInt(S, SLen, &Num2);
		break;
	default:
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "NUMXOR");
	}
	_clip_retni(mp, Num1 ^ Num2);
	return 0;
}

int
clip_SETBIT(ClipMachine * mp)
{
	int Num, SLen;
	int i = _clip_parinfo(mp, 0), Bit;
	char *S;

	if ((i == 1) || (i > 33))
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "SETBIT");
	}
	switch (_clip_parinfo(mp, 1))
	{
	case NUMERIC_t:
		Num = _clip_parni(mp, 1);
		break;
	case CHARACTER_t:
		S = _clip_parcl(mp, 1, &SLen);
		StrToInt(S, SLen, &Num);
		break;
	default:
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "SETBIT");
	}
	for (; i > 1; i--)
	{
		Bit = _clip_parni(mp, i);
		if (Bit > 0 && Bit <= 32)
			Num |= 1 << (Bit - 1);
	}
	_clip_retni(mp, Num);
	return 0;
}

int
clip_CLEARBIT(ClipMachine * mp)
{
	int Num, SLen;
	int i = _clip_parinfo(mp, 0), Bit;
	char *S;

	if ((i == 1) || (i > 33))
	{
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CLEARBIT");
	}
	switch (_clip_parinfo(mp, 1))
	{
	case NUMERIC_t:
		Num = _clip_parni(mp, 1);
		break;
	case CHARACTER_t:
		S = _clip_parcl(mp, 1, &SLen);
		StrToInt(S, SLen, &Num);
		break;
	default:
		_clip_retni(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CLEARBIT");
	}
	for (; i > 1; i--)
	{
		Bit = _clip_parni(mp, i);
		if (Bit > 0 && Bit <= 32)
			Num &= ~(1 << (Bit - 1));
	}
	_clip_retni(mp, Num);
	return 0;
}

int
clip_ISBIT(ClipMachine * mp)
{
	int Bit, SLen;
	int Num;
	int res = 0;
	char *S;

	if (_clip_parinfo(mp, 0) == 0)
	{
		_clip_retl(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "ISBIT");
	}
	switch (_clip_parinfo(mp, 1))
	{
	case NUMERIC_t:
		Num = _clip_parni(mp, 1);
		break;
	case CHARACTER_t:
		S = _clip_parcl(mp, 1, &SLen);
		StrToInt(S, SLen, &Num);
		break;
	default:
		_clip_retl(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "ISBIT");
	}
	if (_clip_parinfo(mp, 0) == 1)
	{
		res = (Num) ? 1 : 0;
	}
	else
	{
		Bit = _clip_parni(mp, 2) - 1;
		if (Bit > 31 || Bit < 0)
			Bit = 0;
		res = (Num & (1 << Bit)) ? 1 : 0;
	}
	_clip_retl(mp, res);
	return 0;
}

int
clip_CTOF(ClipMachine * mp)
{
	int SLen;
	char *S = _clip_parcl(mp, 1, &SLen);

	_clip_retnd(mp, *((double *) S));
	return 0;
}

int
clip_FTOC(ClipMachine * mp)
{
	double res = _clip_parnd(mp, 1);

	_clip_retcn(mp, (char *) (&res), 8);
	return 0;
}

int
clip_CTON(ClipMachine * mp)
{
	long ret = 0;
	char *str = _clip_parc(mp, 1);
	int base = _clip_parni(mp, 2);

	if (base <= 0 || base > 36)
		base = 10;
	if (str != NULL)
		ret = strtol(str, NULL, base);
	_clip_retnl(mp, ret);
	return 0;
}

int
clip_NTOC(ClipMachine * mp)
{
	int i = 256, b, j, l;
	char *ret, *buf, fill;
	static char base_sym[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	unsigned long data = (unsigned long) _clip_parnl(mp, 1);
	char *sdata = _clip_parc(mp, 1);
	int base = _clip_parni(mp, 2);
	int len = _clip_parni(mp, 3);
	char *str = _clip_parc(mp, 4);
	int neg=0;

	if (base <= 0 || base > 36)
		base = 10;
	if (sdata != NULL)
		data = strtol(sdata, NULL, 16);
	if (data < 0 )
	{
		neg=1;
		data=0-data;
	}
	fill = str == NULL ? ' ' : (*str);
	buf = malloc(i+1);
	buf [i] = 0;
	memset(buf, fill, i);
	for (b = 1; i >= 0; i--, b++)
	{
		j = data % base;
		buf[i] = base_sym[j];
		data = data / base;
		if (data == 0)
			break;
	}
	if (neg) i--;
	l = 256 - i + 1;
	if (len <= 0)	len = l;
	ret = calloc(len + 1, 1);
	if (len < l)
	{
		memset(ret, '*', len);
		free(buf);
		_clip_retcn_m(mp, ret, len);
		return 0;
	}
	memset(ret, fill, len);
	memcpy(ret + len - l, buf + i, l);
	if (neg)
	{
		if ( fill==' ')
			ret[len-l]='-';
		else
			*ret='-';

	}
	free(buf);
	_clip_retcn_m(mp, ret, len);
	return 0;
}

int
clip_INFINITY(ClipMachine * mp)
{
#ifdef FLT_MAX
#else
	#ifdef MAXFLOAT
		#define FLT_MAX MAXFLOAT
	#else
		#ifdef FLOATMAX
			#define FLT_MAX FLOATMAX
		#else
			#define FLT_MAX 3.40282347e+38F
		#endif
	#endif
#endif
	_clip_retnd(mp, FLT_MAX);
	return 0;
}

int
clip_EXPONENT(ClipMachine * mp)
{
	int ret = 0, flag = 0;
	double data = fabs(_clip_parnd(mp, 1));

	if (data == 0)
	{
		_clip_retni(mp, 0);
		return 0;
	}
	if (data < 1)
	{
		flag = 1;
		data = 2 / data;
	}
	for (; data >= 2; ret++)
		data = data / 2;
	if (flag)
		ret = 0 - ret;
	_clip_retni(mp, ret);
	return 0;
}

int
clip_MANTISSA(ClipMachine * mp)
{
	int flag_neg = 0, flag = 0;
	double data = _clip_parnd(mp, 1);

	if (data == 0)
	{
		_clip_retni(mp, 0);
		return 0;
	}
	if (data < 0)
	{
		flag_neg = 1;
		data = fabs(data);
	}
	if (data < 1)
	{
		flag = 1;
		data = 2 / data;
	}
	for (; data >= 2;)
		data = data / 2;
	if (flag_neg)
		data = 0 - data;
	if (flag)
		data = 2 / data;
	_clip_retndp(mp, data, 7, 5);
	return 0;
}

double
_clip_strtod_base(char *str, int base)
{
	int i, val = 0;
	double ret = 0, b;

	if (base <= 0 || base > 36)
		base = 10;
	for (i = 0; str[i] != 0; i++);
	for (i--, b = 1; i >= 0; i--, b *= base)
	{
		switch (str[i])
		{
		case '0'...'9':
			val = str[i] - '0';
			break;
		case 'a'...'z':
			val = str[i] - 'a' + 10;
			break;
		case 'A'...'Z':
			val = str[i] - 'A' + 10;
			break;
		default:
			val = 0;
		}
		if (val < base)
			ret += val * b;
		else
			break;
	}
	return ret;
}

int
clip_INTNEG(ClipMachine * mp)
{
	double data = _clip_parnd(mp, 1);
	char *str = _clip_parc(mp, 1);
	int flag = _clip_parl(mp, 2);

	if (str != NULL)
		data = (double) _clip_strtod_base(str, 16);
	if (data <= 0)
	{
		_clip_retni(mp, 0);
		return 0;
	}
	if (flag)
		_clip_retnl(mp, (unsigned long) data);
	else
		_clip_retnl(mp, (short) data);
	return 0;
}

int
clip_INTPOS(ClipMachine * mp)
{
	double data = _clip_parnd(mp, 1);
	char *str = _clip_parc(mp, 1);
	int flag = _clip_parl(mp, 2);

	if (str != NULL)
		data = (double) _clip_strtod_base(str, 16);
	if (flag)
		_clip_retnd(mp, (unsigned long) data);
	else
		_clip_retnl(mp, (unsigned short) data);
	return 0;
}

int
clip_LTON(ClipMachine * mp)
{
	_clip_retni(mp, _clip_parl(mp, 1));
	return 0;
}

int
clip_NUMHIGH(ClipMachine * mp)
{
	unsigned short data = _clip_parnl(mp, 1);
	int par = _clip_parinfo(mp, 1);

	if (par != NUMERIC_t && par != CHARACTER_t)
	{
		_clip_retni(mp, -1);
		return 0;
	}
	if (par == CHARACTER_t)
		data = strtol(_clip_parc(mp, 1), NULL, 16);
	_clip_retnl(mp, data >> 8);
	return 0;
}

int
clip_NUMLOW(ClipMachine * mp)
{
	unsigned short data = _clip_parnl(mp, 1);
	int par = _clip_parinfo(mp, 1);

	if (par != NUMERIC_t && par != CHARACTER_t)
	{
		_clip_retni(mp, -1);
		return 0;
	}
	if (par == CHARACTER_t)
		data = strtol(_clip_parc(mp, 1), NULL, 16);
	_clip_retnl(mp, data & 0x00FF);
	return 0;
}

int
clip_NUMMIRR(ClipMachine * mp)
{
	int i;
	unsigned short ret = 0, tmp = 0;
	unsigned char bdata, bret = 0, btmp = 0;
	unsigned short data = _clip_parnl(mp, 1);
	int par = _clip_parinfo(mp, 1);

	if (par != NUMERIC_t && par != CHARACTER_t)
	{
		_clip_retni(mp, -1);
		return 0;
	}
	if (par == CHARACTER_t)
		data = strtol(_clip_parc(mp, 1), NULL, 16);
	if (_clip_parl(mp, 2))
	{
		bdata = data & 0xFF;
		for (i = 0; i < 4; i++)
		{
			btmp = (1 << i) & bdata;
			btmp = btmp << (8 - 2 * i);
			bret = bret | btmp;
		}
		for (i = 8; i > 3; i--)
		{
			btmp = (1 << i) & bdata;
			btmp = (btmp >> i) << (7 - i);
			bret = bret | btmp;
		}
		_clip_retnl(mp, bret);
		return 0;
	}
	else
	{
		for (i = 0; i < 8; i++)
		{
			tmp = (1 << i) & data;
			tmp = tmp << (15 - 2 * i);
			ret = ret | tmp;
		}
		for (i = 16; i > 7; i--)
		{
			tmp = (1 << i) & data;
			tmp = (tmp >> i) << (15 - i);
			ret = ret | tmp;
		}
		_clip_retnl(mp, ret);
		return 0;
	}
	return 0;
}

int
clip_NUMROL(ClipMachine * mp)
{
	unsigned long ret = 0, tmp = 0;
	unsigned short data = _clip_parnl(mp, 1);
	int left = _clip_parni(mp, 2);
	int par = _clip_parinfo(mp, 1);

	if (par != NUMERIC_t && par != CHARACTER_t)
	{
		_clip_retni(mp, -1);
		return 0;
	}
	if (par == CHARACTER_t)
		data = strtol(_clip_parc(mp, 1), NULL, 16);

	if (_clip_parl(mp, 3))
	{
		left = left % 8;
		ret = data & 0xFF;
		ret = ret << left;
		tmp = (ret & 0x0F00) >> 8;
		ret = (ret & 0x00FF) | tmp;
		_clip_retnl(mp, ret | (data & 0xFF00));
		return 0;
	}
	else
	{
		left = left % 16;
		ret = data;
		ret = ret << left;
		tmp = (ret & 0x00FF0000) >> 16;
		ret = (ret & 0xFFFF) | tmp;
		_clip_retnl(mp, ret);
		return 0;
	}
	return 0;
}
