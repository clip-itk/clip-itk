/*
	Copyright (C) 2001  ITK
	Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
   $Log: _date.c,v $
   Revision 1.43  2002/08/15 07:15:40  clip
   rust: DATETIME fixes

   Revision 1.42  2002/07/30 15:46:39  clip
   uri: small fix

   Revision 1.41  2002/07/30 15:45:17  clip
   uri: small fix

   Revision 1.40  2002/07/30 15:36:15  clip
   uri: small fix

   Revision 1.39  2002/07/30 15:04:11  clip
   uri: small fixes

   Revision 1.38  2002/05/14 07:46:43  clip
   rust: TTOS() -> string in format 'yyyy-mm-dd hh:mm:ss'

   Revision 1.37  2002/04/28 13:50:42  clip
   SET HOURS [TO] 12|24
   SET SECONDS ON|OFF
   rust

   Revision 1.36  2002/04/22 15:29:55  clip
   rust: initial support of DATETIME type

   Revision 1.35  2002/04/12 15:25:14  clip
   uri: seconds() & secondsCPU()

   Revision 1.34  2002/03/27 08:29:58  clip
   uri: usearrow in listbox

   Revision 1.33  2002/01/15 14:49:01  clip
   uri: small fix in timetosec()

   Revision 1.32  2001/12/21 13:54:38  clip
   uri: small fix

   Revision 1.31  2001/12/14 11:36:00  clip
   uri: small fix in dt_() fuctions

   Revision 1.30  2001/12/08 09:22:03  clip
   uri: dtoj(), jtod() added

   Revision 1.29  2001/12/04 11:49:55  clip
   DTOC() : YYYYDDMM -> YYYYMMDD
   rust

   Revision 1.28  2001/12/01 09:57:21  clip
   uri: dtoc && FOX compatible

   Revision 1.27  2001/11/23 08:59:03  clip
   uri: small fix for default numeric format in STR()

   Revision 1.26  2001/10/16 13:04:33  clip
   uri: add _clip_datetostr

   Revision 1.25  2001/10/09 15:21:22  clip
   uri: small fix in DT_ functions

   Revision 1.24  2001/10/09 15:03:58  clip
   uri: new features in DT_ functions

   Revision 1.23  2001/10/09 08:19:10  clip
   uri: datetime support functions

   Revision 1.22  2001/10/08 13:16:34  clip
   uri: add extensions to SECTOTIME()

   Revision 1.21  2001/07/31 04:53:19  clip
   uri: result value format in date functions

   Revision 1.20  2001/06/19 08:58:20  clip
   uri: add function addYear()

   Revision 1.19  2001/05/11 13:33:26  clip
   uri: bug in dtos()

   Revision 1.18  2001/05/03 10:38:01  clip
   *** empty log message ***

   Revision 1.17  2001/04/13 06:10:05  clip
   year() and empty date

   Revision 1.16  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.15  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.14  2001/01/22 09:44:41  clip
   small bug in seconds()

   Revision 1.13  2000/05/24 18:33:52  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.12  2000/05/22 22:19:01  clip
   глюк в clip_DTOC, не освобождалась выделенная память

   Revision 1.11  2000/05/20 18:37:20  clip
   change hash function
   append HASH_xxxx extraction into hashcode.h
   Paul Lasarev <paul@itk.ru>

   Revision 1.10  2000/05/03 19:32:18  clip
   add prefix 'clip_' to all clip functions

   Revision 1.9  2000/03/30 19:00:57  uri
   переделал под новые вызовы error

   Revision 1.8  2000/03/30 18:13:19  paul
   fields in macro

   Revision 1.7  1999/12/10 21:16:35  uri
   в typename добавил MEMO_t

   Revision 1.6  1999/12/08 21:01:22  uri
   доделал фйнкции с датами из тулзов

   Revision 1.5  1999/12/04 22:16:35  uri
   вычистил все предупреждения

   Revision 1.4  1999/12/04 21:25:35  uri
   немного *DATE* функций из тулзов

   Revision 1.3  1999/12/04 19:15:04  uri
   новый gcc

   Revision 1.2  1999/10/26 19:11:05  paul
   start cvs logging

 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <time.h>
#include <stdarg.h>
#include <sys/time.h>
#include <sys/times.h>

#include "clip.h"
#include "error.ch"
#include "hashcode.h"

#ifdef OS_CYGWIN
#include <w32api/windows.h>
#endif

int
clip_STOD(ClipMachine * mp)
{
	long d, m, y;
	char *str = _clip_parc(mp, 1);

	if (str == NULL)
	{
		_clip_retdj(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "STOD");
	}
	if (str[0] == ' ' || str[0] == '\t')
	{
		_clip_retdj(mp, 0);
		return 0;
	}
	y = atol(str) / 10000;
	m = atol(str + 4) / 100;
	d = atol(str + 6);
	_clip_retdj(mp, _clip_jdate(d, m, y));
	return 0;
}

int
clip_CTOD(ClipMachine * mp)
{
	char *str = _clip_parc(mp, 1);
	char *format = _clip_parc(mp, 2);

	if (str == NULL)
	{
		_clip_retdj(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CTOD");
	}
	if (format == NULL)
		format = mp->date_format;
	_clip_retdj(mp, _clip_str_to_date(str, format, mp->epoch));
	return 0;
}

struct tm *
_clip_sysdate()
{
	//#if !defined( __ZTC__ ) || !defined(__MSDOS__)
	struct tm *sysTime;
	time_t t = time(0);
	sysTime = malloc(sizeof(struct tm));
	memcpy(sysTime, localtime(&t), sizeof(struct tm));

	return sysTime;
	/*
	   #else
	   time_t t=time(0);
	   struct tm sysTime;
	   REGS regs;
	   regs.h.ah=0x2a;
	   intdos(&regs, &regs);
	   sysTime->tm_year=regs.x.cx-1900;
	   sysTime->tm_wday=regs.h.al;
	   sysTime->tm_mon=regs.h.dh-1;
	   sysTime->tm_mday=regs.h.dl;
	   regs.h.ah=0x2c;
	   intdos(&regs, &regs);
	   sysTime->tm_hour=regs.h.ch;
	   sysTime->tm_min=regs.h.cl;
	   sysTime->tm_sec=regs.h.dh;
	   sysTime->tm_yday=0;
	   sysTime->tm_isdst=-1;
	   mktime(sysTime);
	   return &sysTime;
	   #endif
	 */
}

int
clip_DATE(ClipMachine * mp)
{
	struct tm *sysTime;

	sysTime = _clip_sysdate();
	_clip_retdc(mp, sysTime->tm_year + 1900, sysTime->tm_mon + 1, sysTime->tm_mday);
	free(sysTime);
	return 0;
}

int
clip_DTOC(ClipMachine * mp)
{
	long d = _clip_pardj(mp, 1);
		int flag1=0, flag2=0,flag3=0;
		int fox=0, i,len;
		int pcount = _clip_parinfo(mp,0);
	char *format = _clip_parcl(mp, 2, &len);
	char *dtoc = NULL, ch;

	if ( pcount == 1 )
			format = mp->date_format;
		else
		{
			if ( _clip_parinfo(mp,2) == CHARACTER_t )
				{
					fox = 1;
					for ( i=0; i<len; i++)
						{
							ch=format[i];
								switch (ch)
								{
									case 'Y':
									case 'y':
											flag1 ++;
											break;
									case 'M':
									case 'm':
											flag2 ++;
											break;
									case 'D':
									case 'd':
											flag3 ++;
											break;
								}
						}
						if ( flag1 && flag2 && flag3 )
							fox=0;
				}
				else
					fox=1;

		}

		if ( fox )
		dtoc = _clip_date_to_str(d, "YYYYMMDD");
		else
		dtoc = _clip_date_to_str(d, format);

	_clip_retcn_m(mp, dtoc, strlen(dtoc));
	return 0;
}

int
clip_DAY(ClipMachine * mp)
{
	int dd, mm, yy, ww;

	if ( _clip_pardj(mp,1) == 0 )
		{
			_clip_retndp(mp,0,3,0);
				return 0;
		}

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	_clip_retndp(mp, dd, 3, 0 );
	return 0;
}

int
clip_DOW(ClipMachine * mp)
{
	int week;
	long d = _clip_pardj(mp, 1);
	char *buf = _clip_fetch_item(mp, HASH_first_day_week);

	week = (d + (*buf)) % 7 + 1;
	if (d == 0)
		_clip_retndp(mp, 0,1,0);
	else
		_clip_retndp(mp, week,1,0);
	return 0;
}

int
clip_DTOS(ClipMachine * mp)
{
	char *ret;
	long d = _clip_pardj(mp, 1);

	ret = malloc(9);
		_clip_datetostr(d,ret);
	_clip_retcn_m(mp, ret, 8);
	return 0;
}

int
clip_MONTH(ClipMachine * mp)
{
	int dd, mm, yy, ww;

	if ( _clip_pardj(mp,1) == 0 )
		{
			_clip_retndp(mp,0,3,0);
				return 0;
		}

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	_clip_retndp(mp, mm,3,0);
	return 0;
}

static double
_clip_seconds()
{
	double ret;

#if !defined( __ZTC__ ) || !defined(__MSDOS__)
	struct timeval tv;
	struct timezone tz;

	gettimeofday(&tv, &tz);
#ifdef OS_CYGWIN
	ret = (tv.tv_sec ) % 86400 +
		  (double) tv.tv_usec / 1000000;
#else
	ret = (tv.tv_sec - tz.tz_minuteswest * 60 ) % 86400 +
		  (double) tv.tv_usec / 1000000;
#endif
#else
	time_t t = time(0);
	struct tm sysTime;
	struct timeval tv;
	{
		REGS regs;

		regs.h.ah = 0x2a;
		intdos(&regs, &regs);
		sysTime.tm_year = regs.x.cx - 1900;
		sysTime.tm_wday = regs.h.al;
		sysTime.tm_mon = regs.h.dh - 1;
		sysTime.tm_mday = regs.h.dl;
		regs.h.ah = 0x2c;
		intdos(&regs, &regs);
		sysTime.tm_hour = regs.h.ch;
		sysTime.tm_min = regs.h.cl;
		sysTime.tm_sec = regs.h.dh;
		sysTime.tm_yday = 0;
		sysTime.tm_isdst = -1;
		mktime(&sysTime);
	}
	gettimeofday(&tv, 0);
	ret = (sysTime.tm_hour * 3600 + sysTime.tm_min * 60 + sysTime.tm_sec) * 1000;
	ret = (ret + tv.tv_usec / 1000) / 1000;
#endif
		return ret;
}

int
clip_SECONDS(ClipMachine * mp)
{
	_clip_retndp(mp, _clip_seconds(), 10, 2);
	return 0;
}

int
clip_SECONDSCPU(ClipMachine * mp)
{
	int n = _clip_parni(mp, 1);
	double d = 0;
	struct tms tm;

	times(&tm);

	if ((n < 1 || n > 3) && (n < 11 || n > 13))
		n = 3;

	if (n > 10)
	{
		n -= 10;
		if (n & 1)
			d += tm.tms_cutime;
		if (n & 2)
			d += tm.tms_cstime;
	}
	if (n & 1)
		d += tm.tms_utime;
	if (n & 2)
		d += tm.tms_stime;

	d /= CLK_TCK;
	_clip_retndp(mp, d, 10, 2);
	return 0;
}

int
clip_TIME(ClipMachine * mp)
{
	char *ret = (char *) malloc(9);
#ifdef OS_CYGWIN
		SYSTEMTIME st;
		GetLocalTime( &st );
		snprintf( ret, 9, "%02d:%02d:%02d", st.wHour, st.wMinute, st.wSecond );
#else
	time_t t = time(0);

#if 0
	struct tm sysTime;

	sysTime = *(localtime(&t));
	snprintf(ret, 9, "%02d:%02d:%02d", sysTime.tm_hour, sysTime.tm_min, sysTime.tm_sec);
#else
	struct tm *sysTime;

	sysTime = localtime(&t);
	snprintf(ret, 9, "%02d:%02d:%02d", sysTime->tm_hour, sysTime->tm_min, sysTime->tm_sec);
#endif
#endif
	_clip_retcn_m(mp, ret, 8);

	return 0;
}

int
clip_YEAR(ClipMachine * mp)
{
	int dd, mm, yy, ww;

	if ( _clip_pardj(mp,1) == 0 )
		{
			_clip_retndp(mp,0,5,0);
				return 0;
		}

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	_clip_retndp(mp, yy,5,0);
	return 0;
}

int
clip_ADDMONTH(ClipMachine * mp)
{
	int dd, mm, yy, ww;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);
	int nummon = _clip_parni(mp, 1);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		_clip_retdj(mp, 0);
		return 0;
	}
	if (numpar == 1)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	if (numpar > 1)
		nummon = _clip_parni(mp, 2);
	mm += nummon;
	_clip_retdc(mp, yy, mm, dd);
	return 0;
}

int
clip_ADDYEAR(ClipMachine * mp)
{
	int dd, mm, yy, ww;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);
	int numyear = _clip_parni(mp, 1);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		_clip_retdj(mp, 0);
		return 0;
	}
	if (numpar == 1)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1901;
		mm = sysTime->tm_mon ;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	if (numpar > 1)
		numyear = _clip_parni(mp, 2);
	yy += numyear;
	_clip_retdc(mp, yy, mm, dd);
	return 0;
}

int
clip_BOM(ClipMachine * mp)
{
	int dd, mm, yy, ww;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	_clip_retdc(mp, yy, mm, 1);
	return 0;
}

int
clip_BOQ(ClipMachine * mp)
{
	int dd, mm, yy, ww;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	_clip_retdc(mp, yy, (mm / 4) * 3 + 1, 1);
	return 0;
}

int
clip_BOY(ClipMachine * mp)
{
	int dd, mm, yy, ww;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	_clip_retdc(mp, yy, 1, 1);
	return 0;
}

int
clip_DOY(ClipMachine * mp)
{
	int dd, mm, yy, ww;
	struct tm *sysTime;
	long d1, d2;
	int numpar = _clip_parinfo(mp, 0);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	d1 = _clip_jdate(1, 1, yy);
	d2 = _clip_jdate(dd, mm, yy);
	_clip_retndp(mp, d2 - d1,3,0);
	return 0;
}

int
clip_EOM(ClipMachine * mp)
{
	int dd, mm, yy, ww, mm1;
	struct tm *sysTime;
	long d;
	int numpar = _clip_parinfo(mp, 0);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	d = _clip_jdate(1, mm + 1, yy);
	_clip_cdate(d, &dd, &mm1, &yy, &ww);
	while (mm != mm1)
	{
		d--;
		_clip_cdate(d, &dd, &mm1, &yy, &ww);
	}
	_clip_retdc(mp, yy, mm, dd);
	return 0;
}

int
clip_EOQ(ClipMachine * mp)
{
	int dd, mm, yy, ww, mm1;
	long d;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	mm = (mm / 4 + 1) * 3;
	d = _clip_jdate(1, mm + 1, yy);
	_clip_cdate(d, &dd, &mm1, &yy, &ww);
	while (mm != mm1)
	{
		d--;
		_clip_cdate(d, &dd, &mm1, &yy, &ww);
	}
	_clip_retdc(mp, yy, mm, dd);
	return 0;
}

int
clip_EOY(ClipMachine * mp)
{
	int dd, mm, yy, ww;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	_clip_retdc(mp, yy, 12, 31);
	return 0;
}

int
clip_ISLEAP(ClipMachine * mp)
{
	int dd, mm, yy, ww;
	long d1, d2;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	d1 = _clip_jdate(1, 1, yy);
	d2 = _clip_jdate(31, 12, yy);
	_clip_retl(mp, (d2 - d1) == 365);
	return 0;
}

int
clip_LASTDAYOM(ClipMachine * mp)
{
	int dd, mm, yy, ww, mm1;
	struct tm *sysTime;
	long d;
	int numpar = _clip_parinfo(mp, 0);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	mm1 = _clip_parni(mp, 1);
	if (numpar == 0 || mm1 != 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	if (mm1 != 0)
		mm = mm1;
	d = _clip_jdate(1, mm + 1, yy);
	_clip_cdate(d, &dd, &mm1, &yy, &ww);
	while (mm != mm1)
	{
		d--;
		_clip_cdate(d, &dd, &mm1, &yy, &ww);
	}
	_clip_retndp(mp, dd, 2, 0);
	return 0;
}

int
clip_QUARTER(ClipMachine * mp)
{
	int dd, mm, yy, ww;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	_clip_retndp(mp, mm / 4 + 1,2,0);
	return 0;
}

int
clip_SECTOTIME(ClipMachine * mp)
{
	int hour, min, sec, msec, len;
	char *ret;
	double d = _clip_parnd(mp, 1);
	int flag = _clip_parl(mp, 2);

	len = 32; /*flag ? 11 : 8;*/
	ret = malloc(len + 1);
	sec = d;
	msec = (d - sec) * 100;
	min = sec / 60;
	hour = min / 60;
	sec = sec % 60;
	min = min % 60;
	if (flag)
		snprintf(ret, len, "%02d:%02d:%02d:%02d", hour, min, sec, msec);
	else
		snprintf(ret, len, "%02d:%02d:%02d", hour, min, sec);
	len = strlen(ret);
	_clip_retcn_m(mp, ret, len);
	return 0;
}

int
clip_TIMETOSEC(ClipMachine * mp)
{
	int l, hour = 0, min = 0, sec = 0, msec = 0;
	double ret;
	char *str = _clip_parcl(mp, 1, &l);

	if (str == NULL)
	{
		_clip_retndp(mp,_clip_seconds(),10,2);
				return 0;
	}
	sscanf(str, "%02d:%02d:%02d:%02d", &hour, &min, &sec, &msec);
	ret = hour * 3600 + min * 60 + sec;
	ret = (ret * 100 + msec) / 100;
	_clip_retndp(mp, ret, 10, 2);
	return 0;
}
int
clip_VALIDTIME(ClipMachine * mp)
{
	int l, hour = 0, min = 0, sec = 0, msec = 0, ret = 1;
	char *str = _clip_parcl(mp, 1, &l);

	if (str == NULL)
	{
		_clip_retl(mp, 0);
		return 0;
	}
	sscanf(str, "%02d:%02d:%02d:%02d", &hour, &min, &sec, &msec);
	if (hour < 0 || hour > 23)
		ret = 0;
	if (min < 0 || min > 59)
		ret = 0;
	if (sec < 0 || sec > 59)
		ret = 0;
	if (msec < 0 || msec > 99)
		ret = 0;
	_clip_retl(mp, ret);
	return 0;
}

int
clip_WEEK(ClipMachine * mp)
{
	int dd, mm, yy, ww, week1, week2, ret;
	long d1, d2;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);
	int weekday = *((char *) _clip_fetch_item(mp, HASH_first_day_week));

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	d1 = _clip_jdate(1, 1, yy);
	week1 = (d1 + weekday) % 7 + 1;
	d2 = _clip_jdate(dd, mm, yy);
	week2 = (d2 + weekday) % 7 + 1;
	ret = (week2 < week1);
	ret = ((d2 - d1) / 7) + ret + 1;
	_clip_retndp(mp, ret,2,0);
	return 0;
}

int
clip_WOM(ClipMachine * mp)
{
	int dd, mm, yy, ww, week1, week2, ret;
	long d1, d2;
	struct tm *sysTime;
	int numpar = _clip_parinfo(mp, 0);
	int weekday = *((char *) _clip_fetch_item(mp, HASH_first_day_week));

	_clip_pardc(mp, 1, &yy, &mm, &dd, &ww);
	if (numpar == 0)
	{
		sysTime = _clip_sysdate();
		yy = sysTime->tm_year + 1900;
		mm = sysTime->tm_mon + 1;
		dd = sysTime->tm_mday;
		free(sysTime);
	}
	d1 = _clip_jdate(1, mm, yy);
	week1 = (d1 + weekday) % 7 + 1;
	d2 = _clip_jdate(1, mm + 1, yy) - 1;
	week2 = (d2 + weekday) % 7 + 1;
	ret = (week2 < week1);
	ret = ((d2 - d1) / 7) + ret + 1;
	_clip_retndp(mp, ret,2,0);
	return 0;
}
/****************************************/
/* date & time class support */
typedef struct
{
	int sign; /* check data of _C_ITEM_TYPE_DATETIME */
		int year;
		int month;
		int day;
		int hour;
		int min;
		int sec;
		int msec;
		char null;
}
ClipDateTime;

int
_clip_dt_normalize(ClipDateTime * dt)
{
	int ii,jj,ww;
	long d;

	ii=dt->msec%1000;
	jj=dt->msec/1000;
	if ( ii<0 )
	{
		jj--;
		ii=1000+ii;
	}
	dt->msec=ii;
	dt->sec+=jj;

	ii=dt->sec%60;
	jj=dt->sec/60;
	if ( ii<0 )
	{
		jj--;
		ii=60+ii;
	}
	dt->sec=ii;
	dt->min+=jj;

	ii=dt->min%60;
	jj=dt->min/60;
	if ( ii<0 )
	{
		jj--;
		ii=60+ii;
	}
	dt->min=ii;
	dt->hour+=jj;

	ii=dt->hour%24;
	jj=dt->hour/24;
	if ( ii<0 )
	{
		jj--;
		ii=24+ii;
	}
	dt->hour=ii;
	dt->day+=jj;

	d=_clip_jdate(dt->day,dt->month,dt->year);
	_clip_cdate(d, &(dt->day), &(dt->month), &(dt->year), &ww);
	return 0;
}

int
clip_DT_CREATE(ClipMachine * mp)
{
	int ww;
	ClipDateTime * dt;

	dt=malloc( sizeof(ClipDateTime) );
	memset(dt, 0, sizeof(ClipDateTime) );
	dt->sign=_C_ITEM_TYPE_DATETIME;

	if ( _clip_parinfo(mp,1)==DATE_t )
		_clip_pardc(mp, 1, &(dt->year), &(dt->month), &(dt->day), &ww);

	if ( _clip_parinfo(mp,1)==CHARACTER_t )
	{
		char * tmp=_clip_parc(mp,1);
		dt->year=atol(tmp);
		for(tmp++; *tmp!=0 && *tmp>='0' && *tmp<='9'; tmp++ );
			if ( *tmp !=0 )
				dt->month=atol(tmp+1);
		for(tmp++; *tmp!=0 && *tmp>='0' && *tmp<='9'; tmp++ );
			if ( *tmp !=0 )
				dt->day=atol(tmp+1);
	}
	dt->hour = _clip_parni(mp,2);
	dt->min  = _clip_parni(mp,3);
	dt->sec  = _clip_parni(mp,4);
	dt->msec = _clip_parni(mp,5);

	if ( _clip_parinfo(mp,2)==CHARACTER_t )
	{
		char * tmp=_clip_parc(mp,2);
		dt->hour=atol(tmp);
		for(tmp++; *tmp!=0 && *tmp>='0' && *tmp<='9'; tmp++ );
			if ( *tmp !=0 )
				dt->min=atol(tmp+1);
		for(tmp++; *tmp!=0 && *tmp>='0' && *tmp<='9'; tmp++ );
			if ( *tmp !=0 )
				dt->sec=atol(tmp+1);
		for(tmp++; *tmp!=0 && *tmp>='0' && *tmp<='9'; tmp++ );
			if ( *tmp !=0 )
				dt->msec=atol(tmp+1);
	}

	if ( _clip_parinfo(mp,1)==NUMERIC_t )
	{
		dt->year  = _clip_parni(mp,1);
		dt->month = _clip_parni(mp,2);
		dt->day   = _clip_parni(mp,3);
		dt->hour  = _clip_parni(mp,4);
		dt->min   = _clip_parni(mp,5);
		dt->sec   = _clip_parni(mp,6);
		dt->msec  = _clip_parni(mp,7);
	}
		/*
	_clip_dt_normalize(dt);
		*/
	_clip_retcn_m(mp, (char *)dt, sizeof(ClipDateTime)-1 );
	return 0;
}

int
clip_DT_NORMALIZE(ClipMachine * mp)
{
	int len;
	ClipDateTime * dt;
	ClipDateTime * dt2;

	char * tmp=_clip_parcl(mp,1,&len);
	if ( tmp==NULL || len!=sizeof(ClipDateTime)-1 || *tmp!=_C_ITEM_TYPE_DATETIME )
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "DT_DATE");

	dt=(ClipDateTime *)tmp;

	_clip_dt_normalize(dt);

	dt2=malloc( sizeof(ClipDateTime) );
	memcpy(dt2, dt, sizeof(ClipDateTime) );

	_clip_retcn_m(mp,(char *)dt2,sizeof(ClipDateTime)-1);
	return 0;
}

int
clip_DT_DATE(ClipMachine * mp)
{
	int len;
	ClipDateTime * dt, *dt2;
	char * tmp=_clip_parcl(mp,1,&len);
	if ( tmp==NULL || len!=sizeof(ClipDateTime)-1 || *tmp!=_C_ITEM_TYPE_DATETIME )
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "DT_DATE");

	dt=(ClipDateTime *)tmp;
	dt2=malloc( sizeof(ClipDateTime) );
	memcpy(dt2, dt, sizeof(ClipDateTime) );
	_clip_dt_normalize(dt2);
	_clip_retdc(mp, dt2->year, dt2->month, dt2->day);
		free(dt2);
	return 0;
}


int
clip_DT_TIME(ClipMachine * mp)
{
	int len;
	ClipDateTime * dt, *dt2;
	char buf[32];
	char * tmp=_clip_parcl(mp,1,&len);
	if ( tmp==NULL || len!=sizeof(ClipDateTime)-1 || *tmp!=_C_ITEM_TYPE_DATETIME )
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "DT_DATE");

	dt=(ClipDateTime *)tmp;
	dt2=malloc( sizeof(ClipDateTime) );
	memcpy(dt2, dt, sizeof(ClipDateTime) );
	_clip_dt_normalize(dt2);
	snprintf(buf, 31, "%02d:%02d:%02d:%02d", dt2->hour, dt2->min, dt2->sec, dt2->msec);
		free(dt2);
	_clip_retc(mp, buf);
	return 0;
}

int
_clip_dt_info(ClipMachine * mp, int info)
{
	int len;
	ClipDateTime * dt;
	char * tmp=_clip_parcl(mp,1,&len);
	if ( tmp==NULL || len!=sizeof(ClipDateTime)-1 || *tmp!=_C_ITEM_TYPE_DATETIME )
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "DT_DATE");

	dt=(ClipDateTime *)tmp;
	switch ( info )
	{
		case 1:
			_clip_retni(mp, dt->year);
			break;
		case 2:
			_clip_retni(mp, dt->month);
			break;
		case 3:
			_clip_retni(mp, dt->day);
			break;
		case 4:
			_clip_retni(mp, dt->hour);
			break;
		case 5:
			_clip_retni(mp, dt->min);
			break;
		case 6:
			_clip_retni(mp, dt->sec);
			break;
		case 7:
			_clip_retni(mp, dt->msec);
			break;
		default:
			_clip_retni(mp, 0);
			break;
		}
	return 0;
}

int
clip_DT_YEAR(ClipMachine * mp)
{
		_clip_dt_info(mp,1);
		return 0;
}

int
clip_DT_MONTH(ClipMachine * mp)
{
		_clip_dt_info(mp,2);
		return 0;
}

int
clip_DT_DAY(ClipMachine * mp)
{
		_clip_dt_info(mp,3);
		return 0;
}


int
clip_DT_HOUR(ClipMachine * mp)
{
		_clip_dt_info(mp,4);
		return 0;
}


int
clip_DT_MIN(ClipMachine * mp)
{
		_clip_dt_info(mp,5);
		return 0;
}

int
clip_DT_SEC(ClipMachine * mp)
{
		_clip_dt_info(mp,6);
		return 0;
}

int
clip_DT_MSEC(ClipMachine * mp)
{
		_clip_dt_info(mp,7);
		return 0;
}

int
clip_DT_ADD(ClipMachine * mp)
{
	int len1,len2;
	ClipDateTime * dt1, *dt2, *dt;
	char * tmp1=_clip_parcl(mp,1,&len1);
	char * tmp2=_clip_parcl(mp,2,&len2);
	if ( tmp1==NULL || len1!=sizeof(ClipDateTime)-1 || *tmp1!=_C_ITEM_TYPE_DATETIME )
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "DT_DATE");
	if ( tmp2==NULL || len2!=sizeof(ClipDateTime)-1 || *tmp2!=_C_ITEM_TYPE_DATETIME )
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "DT_DATE");

	dt1=(ClipDateTime *)tmp1;
	dt2=(ClipDateTime *)tmp2;

	dt=malloc( sizeof(ClipDateTime) );
	dt->sign  = _C_ITEM_TYPE_DATETIME;
	dt->year  = dt1->year  + dt2->year;
	dt->month = dt1->month + dt2->month;
	dt->day   = dt1->day   + dt2->day;
	dt->hour  = dt1->hour  + dt2->hour;
	dt->min   = dt1->min   + dt2->min;
	dt->sec   = dt1->sec   + dt2->sec;
	dt->msec  = dt1->msec  + dt2->msec;

	/*
	_clip_dt_normalize(dt);
		*/

	_clip_retcn_m(mp,(char *)dt,sizeof(ClipDateTime)-1);
	return 0;
}

int
clip_DT_SUB(ClipMachine * mp)
{
	int len1,len2;
	ClipDateTime * dt1, *dt2, *dt;
	char * tmp1=_clip_parcl(mp,1,&len1);
	char * tmp2=_clip_parcl(mp,2,&len2);
	if ( tmp1==NULL || len1!=sizeof(ClipDateTime)-1 || *tmp1!=_C_ITEM_TYPE_DATETIME )
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "DT_DATE");
	if ( tmp2==NULL || len2!=sizeof(ClipDateTime)-1 || *tmp2!=_C_ITEM_TYPE_DATETIME )
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "DT_DATE");

	dt1=(ClipDateTime *)tmp1;
	dt2=(ClipDateTime *)tmp2;

	dt=malloc( sizeof(ClipDateTime) );
	dt->sign  = _C_ITEM_TYPE_DATETIME;
	dt->year  = dt1->year  - dt2->year;
	dt->month = dt1->month - dt2->month;
	dt->day   = dt1->day   - dt2->day;
	dt->hour  = dt1->hour  - dt2->hour;
	dt->min   = dt1->min   - dt2->min;
	dt->sec   = dt1->sec   - dt2->sec;
	dt->msec  = dt1->msec  - dt2->msec;
		/*
	_clip_dt_normalize(dt);
		*/

	_clip_retcn_m(mp,(char *)dt,sizeof(ClipDateTime)-1);
	return 0;
}

int
clip_DTOJ(ClipMachine * mp)
{
	if ( _clip_parinfo(mp,0) == 0 )
	{
			struct tm *sysTime;

		sysTime = _clip_sysdate();
		_clip_retndp(mp, _clip_jdate( sysTime->tm_mday, sysTime->tm_mon + 1, sysTime->tm_year + 1900),7,0);
		free(sysTime);
		return 0;
	}

	_clip_retndp(mp, _clip_pardj(mp, 1), 7, 0 );
	return 0;
}

int
clip_JTOD(ClipMachine * mp)
{
	_clip_retdj(mp, _clip_parnl(mp, 1) );
	return 0;
}

/* Visual FoxPro DateTime */

long
_clip_str_to_time(char* str)
{
	int len, am = 0, pm = 0;
	char *t = str, *e;
	long r;
	int h = 0, m = 0, s = 0, d = 0;

	if(!str)
		return 0;

	while(*t==' ') t++;
	len = strlen(t);
	e = t+len-1;
	while (*e==' ') {e--; len--;}
	*(e+1) = 0;

	if (len < 5 || len > 13 || len%3 == 0)
		return -1;
	h = atoi(t);
	m = atoi(t+3);
	if(len%3==1){
		if (toupper(*e) != 'M')
			return -1;
		if (toupper(*(e-1)) == 'A')
			am = 1;
		else if (toupper(*(e-1)) == 'P')
			pm = 1;
		else
			return -1;
	}
	if ((am || pm) && (h > 12))
		return -1;

	if (len > 7)
		s = atoi(t+6);
	if (len > 10)
		d = atoi(t+9);

	if (h == 12 && (am || pm))
		h = 0;
	if (pm)
		h += 12;
	if (h == 24)
		h = 0;

	if (h < 0 || h > 23)
		return -1;
	if (m < 0 || m > 59)
		return -1;
	if (s < 0 || s > 59)
		return -1;
	if (d <0 || d > 99)
		return -1;

	r = h*60*60*1000 + m*60*1000 + s*1000 + d*10;
	return r;
}

int
_clip_ctot(ClipMachine * mp, char* ctime, long *date, long *time)
{
	char* s = ctime;
	*date = 0;
	*time = 0;

	if (!ctime)
		return 1;

	while(*s==' ') s++;
	if(strlen(s) < 5) /* 11:12 */
		return 1;

	if (s[2] == ':')
	{
		*date = 0/*2415019*/;
		*time = _clip_str_to_time(s);
		if (*time == -1)
			return 1;
	}
	else
	{
		char* t = strchr(s,' ');

		*date = _clip_str_to_date(s, mp->date_format, mp->epoch);
		if (*date == 0)
			return 1;
		*time = _clip_str_to_time(t);
		if (*time == -1)
			return 1;
	}
	return 0;
}

int
clip_CTOT(ClipMachine * mp)
{
	char* ctime = _clip_parc(mp, 1);
	long date,time;
	int er;

	er = _clip_ctot(mp,ctime,&date,&time);
	if (er)
	{
		_clip_retdtj(mp, 0, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CTOT");
	}
	_clip_retdtj(mp,date,time);
	return er;
}

char*
_clip_ttoc(ClipMachine *mp, long julian, long time, int *retlen, char* date_format, int hours, int seconds)
{
	char* r = _clip_date_to_str(julian, date_format);
	int len = strlen(r);
	int h,m,s;
	long t;
	int pm = 0;

	r = realloc(r,len+13);
	r[len] = ' ';
	h = time / (60*60*1000);
	t = time % (60*60*1000);
	m = t / (60*1000);
	t = t % (60*1000);
	s = t / 1000;
	if(!hours){
		if(h >= 12)
			pm = 1;
		if(h > 12)
			h -= 12;
	}

	if(seconds){
		if(hours)
			snprintf(r+len+1,9,"%02d:%02d:%02d",h,m,s);
		else if(pm)
			snprintf(r+len+1,11,"%02d:%02d:%02dpm",h,m,s);
		else
			snprintf(r+len+1,11,"%02d:%02d:%02dam",h,m,s);
	} else {
		if(hours)
			snprintf(r+len+1,6,"%02d:%02d",h,m);
		else if(pm)
			snprintf(r+len+1,8,"%02d:%02dpm",h,m);
		else
			snprintf(r+len+1,8,"%02d:%02dam",h,m);
	}
	if(retlen)
		*retlen = len+6+(seconds?3:0)+(hours?0:2);
	return r;
}

int clip_TTOC(ClipMachine * mp)
{
	ClipVar *r = RETPTR(mp);
	long time;
	long julian = _clip_pardtj(mp, 1, &time);

	memset(r,0,sizeof(ClipVar));
	r->t.type = CHARACTER_t;
	r->s.str.buf = _clip_ttoc(mp, julian, time, &r->s.str.len, mp->date_format, mp->hours, mp->seconds);
	return 0;
}

int clip_TTOS(ClipMachine * mp)
{
	ClipVar *r = RETPTR(mp);
	long time;
	long julian = _clip_pardtj(mp, 1, &time);

	memset(r,0,sizeof(ClipVar));
	r->t.type = CHARACTER_t;
	r->s.str.buf = _clip_ttoc(mp, julian, time, &r->s.str.len, "yyyy-mm-dd", 1, 1);
	return 0;
}

