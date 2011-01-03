/*
$Log$
Revision 1.1  2006/06/22 19:35:16  itk
uri: init sf.net repository

Revision 1.2  2000/09/12 08:50:41  clip
DMALLOC disabled
from uri:

Revision 1.1  2000/09/12 07:28:31  clip
add integer & rational source
from uri:

*/
/*
   note russian
   class integer - number with an unlimited number of digits
   division by zero returns zero !!!
   no any error raising !!!

   (c) itk 2000, www.itk.ru
   autor - uri, uri@itk.ru

*/

#ifndef __ITK_INTEGER_H

#define __ITK_INTEGER_H

                /* malloc debiging */
/* #define DMALLOC */

               /* need implement on 32 bits or 64 bits */
#define INTEGER_SHORTB
               /*  code of symbol 0 */
#define INTEGER_SYM_NULL  48
#define INTEGER_SYM_A     65
#define INTEGER_SYM_MINUS 45
#define INTEGER_SYM_PLUS  43

#ifdef INTEGER_SHORTB
                        /* half-precision - short */
   #define  INTEGER_HALF       16
                        /* full-precision - int */
   #define  INTEGER_FULL       32
                        /* maximum number for 16 bits */
   #define  INTEGER_MAXNUM     0xffffL

   typedef  unsigned short *   INTEGER_VECTOR     ;
   typedef  unsigned short     INTEGER_HALF_TYPE  ;
   typedef  unsigned int       INTEGER_FULL_TYPE  ;
#else
                        /* half-precision - int */
   #define  INTEGER_HALF       32
                        /* full-precision -long */
   #define  INTEGER_FULL       64
                        /* maximum number for 32 bits */
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
		convert 'data' to string
		base - what base of number, but no more than 16
		*/

char *      integer_toString2(integer *data);
		/*
		convert 'data' to string
		as 999999 999999 999999 ..... number is equal to
		object dimension
		*/

long        integer_toLong(integer * data);
		/*returns long value "packed" to 64 bits */

void        integer_destroy(integer *data);
		/* destroy object */

integer *   integer_init ( );
		/* create empty object  */

integer *   integer_long_init ( long i);
		/* 
		 from signed long object */

integer *   integer_long2_init ( long low,long high);
		/* create object and fill his by values
		from long objects
		low is unsigned
		high is signed */

integer *   integer_fromString(const char * s);
		/* create object and fill his by value
		from string expression */

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
		/* returns the greatest common divisor of the current
		object and integer y */

integer *   integer_unscale(integer *data, INTEGER_HALF_TYPE y, INTEGER_HALF_TYPE * ost);
integer *   integer_sunscale(integer *data, INTEGER_HALF_TYPE y, INTEGER_HALF_TYPE * ost);
                /* divides itself by y, the remainder stored to the ost */

integer *   integer_sdivide(integer * data, integer * y, integer ** div);
                /* divides itself by y, the remainder stored to the div */

integer *   integer_div(integer * data, integer * y);
		/*  return (data/y)  */

integer *   integer_diva(integer * data, integer * y);
		/*  (data/=y)  */

integer *   integer_mod(integer * data, integer * y);
		/*  return (data%y) */

int         integer_lg(integer * data);
		/* returns the logarithm of two */

integer *   integer_sqrt(integer * data);
		/* returns the square,
		Square from negative number returns 0 */

integer *   integer_sadd(integer * d1, integer * d2);
		/*  d1 += d2  without sign of numbers */

integer *   integer_long_add(integer * data, long y);
		/* return (data+y) */

integer *   integer_long_adda(integer * data, long y);
		/* data+=y */

integer *   integer_add(integer * d1, integer * d2);
		/* return (d1+d2) */

integer *   integer_adda(integer * d1, integer * d2);
		/* d1+=d2 */

integer *   integer_inv(integer * data);
		/* returns inverse object, ie x=(-y); */

integer *   integer_inverse(integer * data);
	        /* Chenge sign of current object */

integer *   integer_ssub(integer * d1, integer * d2);
		/* d1-=d2 without sign of number */

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
		/*returns value of bit with number ind ( 0 || 1 )*/

integer *   integer_setBit (integer * data, int ind, int value);
integer *   integer_setBita(integer * data, int ind, int value);
		/* Set bit with number ind to
		value ( 0 || 1 ) */

integer *   integer_or(integer * d1, integer * d2);
integer *   integer_long_or(integer * d1, long y);
integer *   integer_ora(integer * d1, integer * d2);
		/* bitwise OR */

integer *   integer_and(integer * d1, integer * d2);
integer *   integer_long_and(integer * d1, long y);
integer *   integer_anda(integer * d1, integer * d2);
		/* bitwise AND */

integer *   integer_xor(integer * d1, integer * d2);
integer *   integer_long_xor(integer * d1, long y);
integer *   integer_xora(integer * d1, integer * d2);
		/* bitwise XOR */

int         integer_abscmp(integer * d1, integer * d2);
		/* compares two integer values by absolute values, returns:
		-1 if object is less than param
		0 if equals
		1 if object is greater than param */

int         integer_cmp(integer * d1, integer * d2);
		/* compares two integer values, returns:
		-1 if object is less than param
		0 if equals
		1 if object is greater than param */

integer *   integer_abs(integer * data);
		/* returns absolute value */

int         integer_even(integer * data);
		/* returns 1 if 'data' is even */

integer *   integer_clear(integer * data);
		/* clear all elements to 0,
		doesn't free or reallocate memory */

integer *   integer_copy (integer * data);
		/* copy object */

integer *   integer_assign (integer * dst, integer * src);
		/* copy src to dst */

int	    integer_empty(integer * data);
		/* check if object is empty, is elements count == 0 */

int         integer_len(integer * data);
		/* returns the length of the object */

INTEGER_VECTOR integer_vec(integer * data);
		/* vec() returns array of elements */

int         integer_realLen(integer * data);
		/*  returns real length, ie
		only meaningful elements  */

int         integer_sign(integer * data);
		/* returns 0 - if object is equal to 0,
		-1 -if is less than zero, 1 - if is greater */

integer *   integer_resize(integer * data, int newlen);
		/* change object size  */

#endif
