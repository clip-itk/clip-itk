/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/***
	DAYS( <nSeconds> )

 Возвращает целое число дней исходя из заданного числа секунд

 Замечание: Остаток от деления на 24 часа возвращается функцией TSTRING().
*/

FUNC DAYS(cl_secs)
RETURN INT( cl_secs / 86400 )

/***
	LENNUM( <nNum> )
 Возвращает длину при преобразовании числа в строку
*/

FUNC LENNUM(cl_number)
RETURN	LEN(LTRIM(STR(cl_number)))


/***
 SECS( <строка времени>)

 Возвращает число секунд, содержащихся в переданном параметре

	Число секунд в периоде
	-------    -----------
	     60    1 минута
	   3600    1 час
	  86400    1 день
*/

FUNC SECS(cl_time)

RETURN	VAL( cl_time ) * 3600 +;
	VAL(SUBSTR(cl_time,4)) * 60 +;
	VAL(SUBSTR(cl_time,7))

