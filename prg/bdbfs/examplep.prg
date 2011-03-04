/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/***
	DAYS( <nSeconds> )

 Returns an integer number of days based on the specified number of seconds

 Note: The remainder of the division by 24 is returned by TSTRING() function.
*/

FUNC DAYS(cl_secs)
RETURN INT( cl_secs / 86400 )

/***
	LENNUM( <nNum> )
 Returns length of string while nubmer convert to string
*/

FUNC LENNUM(cl_number)
RETURN	LEN(LTRIM(STR(cl_number)))


/***
 SECS( <time string>)

 Returns the number of seconds contained in the parameter

	The number of seconds in the period
	-------    -----------
	     60    1 minute
	   3600    1 hour
	  86400    1 day
*/

FUNC SECS(cl_time)

RETURN	VAL( cl_time ) * 3600 +;
	VAL(SUBSTR(cl_time,4)) * 60 +;
	VAL(SUBSTR(cl_time,7))

