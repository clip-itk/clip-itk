/*
$Log: integer.h,v $
Revision 1.2  2000/09/12 08:50:41  clip
DMALLOC disabled
from uri:

Revision 1.1  2000/09/12 07:28:31  clip
add integer & rational source
from uri:

*/
/*
   note russian
   класс integer - число с неограниченным кол-вом разрядов
   деление на ноль - дает ноль !!!
   никаких ошибочных ситуаций не создает !!!

   (c) itk 2000, www.itk.ru
   autor - uri, uri@itk.ru

*/

#ifndef __ITK_INTEGER_H

#define __ITK_INTEGER_H

                /* malloc debiging */
/* #define DMALLOC */

               /* реализовать на 32 разрядах или на 64 разрядах */
#define INTEGER_SHORTB
               /*  код символа 0 */
#define INTEGER_SYM_NULL  48
#define INTEGER_SYM_A     65
#define INTEGER_SYM_MINUS 45
#define INTEGER_SYM_PLUS  43

#ifdef INTEGER_SHORTB
                        /* половинная точность - short */
   #define  INTEGER_HALF       16
                        /* полная точность - int */
   #define  INTEGER_FULL       32
                        /* максимальное число для 16 разряда */
   #define  INTEGER_MAXNUM     0xffffL

   typedef  unsigned short *   INTEGER_VECTOR     ;
   typedef  unsigned short     INTEGER_HALF_TYPE  ;
   typedef  unsigned int       INTEGER_FULL_TYPE  ;
#else
                        /* половинная точность - int */
   #define  INTEGER_HALF       32
                        /* полная точность -long */
   #define  INTEGER_FULL       64
                        /* максимальное число для 32 разряда */
   #define  INTEGER_MAXNUM     0xffffffffL

   typedef  unsigned int *     INTEGER_VECTOR    ;
   typedef  unsigned int       INTEGER_HALF_TYPE ;
   typedef  unsigned long      INTEGER_FULL_TYPE ;
#endif

#define  EXTRACT(x) ( x & INTEGER_MAXNUM )
#define  UP(x)      ( x << INTEGER_HALF )
#define  DOWN(x)    ( ( x >> INTEGER_HALF ) & INTEGER_MAXNUM )

typedef struct
{
   int	sign;		/* sign, nonzero is negative */
   int	len;		/* number of values in array */
   INTEGER_VECTOR vec;	/* pointer to array of values */
}
integer;

char *      integer_toString(integer * data, int base);
		/*
		переводит значение в строковое представление
		base - в каком исчислении, но не более 16
		*/

char *      integer_toString2(integer *data);
		/*
		переводит значение в строковое представление
		в виде 999999 999999 999999 ..... в кол-ве равном
		размерности объекта
		*/

long        integer_toLong(integer * data);
		/*возвращает "свернутое" в 64 бита значение длинного целого */

void        integer_destroy(integer *data);
		/* уничтожает объект */

integer *   integer_init ( );
		/* создает пустой объект  */

integer *   integer_long_init ( long i);
		/* создает объект и заполняет его значением
		из знакового long объекта */

integer *   integer_long2_init ( long low,long high);
		/* создает объект и заполняет его значением
		из long объектов
		младший считается безнаковым,
		старший знаковым */

integer *   integer_fromString(const char * s);
		/* создает объект и заполняет его значением
		из строкового выражения */

integer *   integer_mul(integer * d1, integer * d2);
		/* d1 * d2 */

integer *   integer_mula(integer *d1, integer * d2);
                /* d1 *= d2 */

integer *   integer_long_mul(integer * data, long y);
		/* return (data*y) */

integer *   integer_long_mula(integer * data, long y);
		/* data*=y */

integer *   integer_pow(integer * data, long y );
		/* return ( pow(data,y) */

integer *   integer_powa(integer * data, long y );
		/* data=pow(data,y) */

integer *  integer_gcd(integer * data, integer * y);
		/* возвращает наибольший общий делитель текущего
		объекта и integer y */

integer *   integer_unscale(integer *data, INTEGER_HALF_TYPE y, INTEGER_HALF_TYPE * ost);
integer *   integer_sunscale(integer *data, INTEGER_HALF_TYPE y, INTEGER_HALF_TYPE * ost);
                /* делит себя на y, остаток записывает в ost */

integer *   integer_sdivide(integer * data, integer * y, integer ** div);
                /* делит себя на y, остаток записывает в div */

integer *   integer_div(integer * data, integer * y);
		/*  return (data/y)  */

integer *   integer_diva(integer * data, integer * y);
		/*  (data/=y)  */

integer *   integer_mod(integer * data, integer * y);
		/*  return (data%y) */

int         integer_lg(integer * data);
		/* возвращает логарифм двойки */

integer *   integer_sqrt(integer * data);
		/* возвращает квадратный корень числа,
		корень из отрицательного числа дает 0 */

integer *   integer_sadd(integer * d1, integer * d2);
		/*  d1 += d2   без учета знака чисел */

integer *   integer_long_add(integer * data, long y);
		/* return (data+y) */

integer *   integer_long_adda(integer * data, long y);
		/* data+=y */

integer *   integer_add(integer * d1, integer * d2);
		/* return (d1+d2) */

integer *   integer_adda(integer * d1, integer * d2);
		/* d1+=d2 */

integer *   integer_inv(integer * data);
		/* возвращает обратный объект, т.е. x=(-y); */

integer *   integer_inverse(integer * data);
	        /* изменяет знак текущего объекта */

integer *   integer_ssub(integer * d1, integer * d2);
		/* d1-=d2 без учета знака числа */

integer *   integer_long_sub(integer * data, long y);
		/* return (data-y) */

integer *   integer_long_suba(integer * data, long y);
		/* data-=y */

integer *   integer_sub(integer * d1, integer * d2);
		/* return (d1-d2) */

integer *   integer_suba(integer *d1, integer * d2);
		/* d1-=d2 */

integer *   integer_lshift(integer * data, int y);
		/* return (data<<y) */

integer *   integer_lshifta(integer * data, int y);
		/* data<<=y */

integer *   integer_rshift(integer * data, int y);
		/* return (data>>y) */

integer *   integer_rshifta(integer * data, int y);
		/* data>>=y */

int         integer_getBit(integer * data, int ind);
		/*возвращает значение бита с номером ind ( 0 || 1 )*/

integer *   integer_setBit (integer * data, int ind, int value);
integer *   integer_setBita(integer * data, int ind, int value);
		/* устанавливает бит с номером ind в
		значение value ( 0 || 1 ) */

integer *   integer_or(integer * d1, integer * d2);
integer *   integer_long_or(integer * d1, long y);
integer *   integer_ora(integer * d1, integer * d2);
		/* побитовое OR */

integer *   integer_and(integer * d1, integer * d2);
integer *   integer_long_and(integer * d1, long y);
integer *   integer_anda(integer * d1, integer * d2);
		/* побитовое AND */

integer *   integer_xor(integer * d1, integer * d2);
integer *   integer_long_xor(integer * d1, long y);
integer *   integer_xora(integer * d1, integer * d2);
		/* побитовое XOR */

int         integer_abscmp(integer * d1, integer * d2);
		/* сравнивает два integer по абсолютным значениям, возвращает:
		-1 если объект меньше параметра
		0 если равны
		1 если объект больше параметра */

int         integer_cmp(integer * d1, integer * d2);
		/*сравнивает два integer, возвращает:
		-1 если объект меньше параметра
		0 если равны
		1 если объект больше параметра*/

integer *   integer_abs(integer * data);
		/*возвращает абсолютное значение*/

int         integer_even(integer * data);
		/* возвращает 1 - если четное число */

integer *   integer_clear(integer * data);
		/* очищает все составляющие числа в 0,
		не освобождает и не перераспределяет память */

integer *   integer_copy (integer * data);
		/* перекопирует объект */

integer *   integer_assign (integer * dst, integer * src);
		/* перекопирует src to dst */

int	    integer_empty(integer * data);
		/* проверяет пустой ли объект, все члены==0 */

int         integer_len(integer * data);
		/* возвращает длину объекта */

INTEGER_VECTOR integer_vec(integer * data);
		/* vec() возвращает массив элементов */

int         integer_realLen(integer * data);
		/*  возвращает реальную длину т.е.
		только значащие элементы  */

int         integer_sign(integer * data);
		/* возвращает 0- если объект равен 0,
		-1 -если меньше нуля, 1 -если больше */

integer *   integer_resize(integer * data, int newlen);
		/* изменить размер объекта  */

#endif
