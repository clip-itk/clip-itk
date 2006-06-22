/*
$Log$
Revision 1.1  2006/06/22 19:35:17  itk
uri: init sf.net repository

Revision 1.4  2000/10/20 08:03:24  clip
Вкрутил rational везде где упоминается NUMERIC_t
может чего и осталось неотловленное, но это может быть только в тех
местах где нет использования NUMERIC_t !!!!!
from uri:

Revision 1.3  2000/10/18 10:56:17  clip
append rationals
Paul Lasarev <paul@itk.ru>

Revision 1.2  2000/09/12 07:45:47  clip
add func rational_toDouble()
from uri:

Revision 1.1  2000/09/12 07:28:31  clip
add integer & rational source
from uri:

*/

/*
   note russian
   класс rational - число с плавающей точкой, представляемое
   в виде рациональной дроби из двух объектов integer x/y
   с неограниченным кол-вом разрядов,
   деление на ноль - дает ноль !!!
   никаких ошибочных ситуаций не создает !!!

   (c) itk 2000, www.itk.ru
   autor - uri, uri@itk.ru

*/

#include "integer.h"

#ifndef __ITK_RATIONAL_H

#define __ITK_RATIONAL_H


typedef struct rational
{
   integer * num;       /*  numerator */
   integer * den;       /*  denumerator */
}
rational;

rational *  rational_init ();
		/* создает пустой объект */

rational *  rational_fromString ( char * s );
		/* создает объект и заполняет его значением из
		строковой переменной возможены форматы в двоичном,
		восьмиричном, десятичном и шестнадцатиричном виде */

rational *  rational_long_init ( long i);
		/* создает объект и заполняет его значением из
		знакового long объекта */

rational *  rational_double_init( double i);
		/* создает объект и заполняет его значением из
		double объекта */

rational *  rational_long2_init ( long n,long d);
		/* создает объект и заполняет его значением из long объектов
      		в виде дроби n/d */

rational *  rational_integer_init (integer * i);
		/*создает объект и заполняет его значением из integer объекта */

rational *  rational_integer2_init (integer * n, integer * d);
		/* создает объект и заполняет его значением из integer
		объектов в виде рациональной дроби n/d */

void        rational_destroy(rational * data) ;
		/* уничтожает объект */

rational *  rational_copy(rational * y);
		/*создает объект и заполняет его значением из rational объекта */

rational *  rational_assign(rational * data, rational * y);
		/* заполняет data значением из rational объекта */

rational *  rational_inv(rational * data);
		/* возвращает обратный объект, т.е. x=(-y); */

rational *  rational_inverse(rational * data);
      		/* изменяет знак текущего объекта на обратный */

void        rational_normalize(rational * data);
		/* уменьшение длин на общий делитель */

int         rational_empty(rational * data);
		/* проверяет пустой ли объект, все int члены==0 */

int         rational_sign(rational * data);
		/* возвращает 0 - если объект равен 0,
		-1 - если меньше нуля, 1-если больше */

int         rational_cmp(rational * data, rational * y);
		/* сравнивает два rational, возвращает:
		-1 если объект меньше параметра
		0 если равны
		1 если объект больше параметра
                */

int         rational_abscmp(rational * data, rational * y);
		/* сравнивает два rational по абсолютным значениям, возвращает:
		-1 если объект меньше параметра
		0 если равны
		1 если объект больше параметра
                */

rational *  rational_abs(rational * data);
		/* возвращает абсолютное значение */

rational *  rational_pow(rational * data, long y );
		/* return pow(data,y) */

rational *  rational_powa(rational * data, long y );
		/* data=pow(data,y) */

rational *  rational_sqr(rational * data);
		/* возвращает квадрат объекта */

rational *  rational_sqrt(rational * data);
		/* возвращает квадратный корень объекта
      		точность не "абсолютная", но вполне достаточная */

integer  *  rational_toInteger(rational * data);
		/* возвращает "свернутое" в длинное целое значение */

rational *  rational_double_adda(rational * data, double y);
rational *  rational_adda(rational * data, rational * y);
		 /* увеличивает себя на знаковый y */

rational *  rational_double_add(rational * data, double y);
rational *  rational_add(rational * data, rational * y);
		/* прибавляет знаковый y */

rational *  rational_double_suba(rational * data, double y);
rational *  rational_suba(rational * data, rational * y);
		/* уменьшает себя на знаковый y */

rational *  rational_double_sub(rational * data, double y);
rational *  rational_sub(rational * data, rational * y);
		/* вычитает знаковый y */

rational *  rational_double_mula(rational * data, double y);
rational *  rational_mula(rational * data, rational * y);
		/* умножает себя на y */

rational *  rational_double_mul(rational * data, double y);
rational *  rational_mul(rational * data, rational * y);
		/* умножает  на y */

rational *  rational_double_diva(rational * data, double y);
rational *  rational_diva(rational * data, rational * y);
		/* делит себя на y */

rational *  rational_double_div(rational * data, double y);
rational *  rational_div(rational * data, rational * y);
		/* делит  на y */

rational *  rational_fmod(rational * data, rational * y);
		/* возвращает остаток от деления */

char *      rational_toString2(rational * data);
		/* переводит значение в строковое представление
		в виде 999999/999999 */

char *      rational_toString(rational * data, int base, int dec, int group);
		/* переводит значение в строковое представление
		base - в каком исчислении, но не более 16 */

double      rational_toDouble(rational * data);
		/* переводит значение в double */

#endif




