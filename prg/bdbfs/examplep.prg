/*
    Copyright (C) 2001  ITK
    Author  : Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

//Слегка оптимизированные версии стандартного Examplep.prg


/***
 StrZero( <nNumber>, <nLength>, <nDecimals> ) --> cNumber

 Преобразование числа к строке фиксированной длины с ведущими нулями
*/

FUNC StrZero( n, nLength, nDecimals )
LOCAL cNumber

IF EMPTY(nDecimals)
	nDecimals=0
ENDIF
IF EMPTY(nLength)
	nLength=10
ENDIF

cNumber:=LTRIM(STR(ABS(n),nLength,nDecimals))
RETURN	IF(n<0,'-','')+REPL('0',nLength-LEN(cNumber))+cNumber

/***
	DAYS( <nSeconds> )

 Возвращает целое число дней исходя из заданного числа секунд

 Замечание: Остаток от деления на 24 часа возвращается функцией TSTRING().
*/

FUNC DAYS(cl_secs)
RETURN INT( cl_secs / 86400 )

/***
	DBF()

 Возвращает алиас текущей базы данных (перенесено в ASM)

*/
EXTERNAL DBF


/***
	ELAPTIME( <nStartTime>, <nEndTime> )

 Возвращает строку с разницей времени между начальным и конечным

* Замечание:	Если начальное время больше конечного, предполагается
		переход на новые сутки. Только для 24-часового формата.
		в 24 часах 86400 секунд.
*/

FUNC ELAPTIME(cl_start, cl_end)

RETURN TSTRING( IF( cl_end < cl_start, 86400, 0) + ;
		SECS(cl_end) - SECS(cl_start) )

/***
	LENNUM( <nNum> )
 Возвращает длину при преобразовании числа в строку
*/

FUNC LENNUM(cl_number)
RETURN	LEN(LTRIM(STR(cl_number)))

/***
	MOD( <expN1>, <expN2> )

 Возвращает остаток от деления <expN1> на <expN2> в соответствии
 с алгоритмом dBASE-функции MOD()

 Замечание: Различие между dBASE и Clipper, остатком от деления,
 индицируется стрелками "<-->":

	Clipper-оператор:        dBASE-функция:
	-----------------        -----------------
	 3 %  0 ::=  0.00  <-->  MOD( 3, 0) ::=  3
	 3 % -2 ::=  1.00  <-->  MOD( 3,-2) ::= -1

	-3 %  2 ::= -1.00  <-->  MOD(-3, 2) ::=  1
	-3 %  0 ::=  0.00  <-->  MOD(-3, 0) ::= -3

	-1 %  3 ::= -1.00  <-->  MOD(-1, 3) ::=  2
	-2 %  3 ::= -2.00  <-->  MOD(-2, 3) ::=  1

	 2 % -3 ::=  2.00  <-->  MOD( 2,-3) ::= -1
	 1 % -3 ::=  1.00  <-->  MOD( 1,-3) ::= -2
*/

FUNC MOD(cl_num, cl_base)
LOCAL cl_result:= cl_num % cl_base

RETURN IF( cl_base = 0, ;
	   cl_num,;
	   IF(cl_result * cl_base < 0, cl_result + cl_base, cl_result) )


/***
	READKEY()

 Возвращает номер, представляющий нажатую клавишу при выходе из режима
 полноэкранного редактирования - Эмуляция dBASE-функции READKEY().

 Замечание: Далее представлены различия dBASE-функции READKEY() и
 Clipper-функции LASTKEY():

	Клавиша выхода:    dBASE:      Clipper:
	--------------     ------      --------
	Забой                  0       нет выхода
	^D, ^L                 1       нет выхода
	влево                  2       нет выхода
	вправо                 3       нет выхода
	вверх                  4       нет выхода
	вниз                   5       нет выхода
	PgUp                   6          18
	PgDn                   7           3
	Esc, ^Q               12          27 (только Esc)
	^End, ^W              14          23 (только ^W)
	набор после конца     15       ASCII-код последнего символа
	Enter                 15          13
	^Home                 33       нет выхода
	^PgUp                 34       нет выхода
	^PgDn                 35       нет выхода
	F1                    36       нет выхода

 dBASE III добавляет 256 к выходному коду, если пользователь изменил
 что-либо. Clipper использует свою функцию UPDATED() для определения,
 были ли изменения.
*/
FUNC READKEY()
LOCAL _res:=0,_lk:=LASTKEY()
DO CASE
	CASE _lk = 18 			// PgUp
		_res:= 6
	CASE _lk =  3 			// PgDn
		_res:= 7
	CASE _lk = 27 			// Esc
		_res:=12
	CASE _lk = 23 			// ^W
		_res:=14
	CASE _lk = 13 .OR. _lk>=32	// Enter,Набор после конца поля
		_res:=15
	CASE _lk = 31 			// ^PgUp
		_res:=34
	CASE _lk = 30 			// ^PgDn
		_res:=35
ENDCASE

RETURN	_res+IF(UPDATED(),256,0)


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


/***
	TSTRING( <seconds> )

 Преобразует секунды в строку времени

 Время превышающее 24 часа возвращается функцией DAYS().
*/

FUNC TSTRING(cl_secs)

RETURN	STRZERO( INT(MOD(cl_secs/3600, 24)), 2 ) +':'+;
	STRZERO( INT(MOD(cl_secs/  60, 60)), 2 ) +':'+;
	STRZERO( INT(MOD(cl_secs     , 60)), 2 )
