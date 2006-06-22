/*
$Log$
Revision 1.1  2006/06/22 19:01:36  itk
uri: initial

Revision 1.6  2004/05/21 11:22:19  clip
rust: minor fix for 'configure -m'

Revision 1.5  2000/10/27 10:40:56  clip
bug in rational_adda
from uri:

Revision 1.4  2000/10/20 11:45:49  clip
round() and round in str() small bugs
from uri:

Revision 1.3  2000/10/20 08:03:24  clip
Вкрутил rational везде где упоминается NUMERIC_t
может чего и осталось неотловленное, но это может быть только в тех
местах где нет использования NUMERIC_t !!!!!
from uri:

Revision 1.2  2000/09/12 07:45:47  clip
add func rational_toDouble()
from uri:

Revision 1.1  2000/09/12 07:28:31  clip
add integer & rational source
from uri:

*/
/*

   small documentation see in rational.h

   (c) itk 2000, www.itk.ru
   autor - uri, uri@itk.ru

*/

#include "rational.h"

#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "clip.h"

/*********************************************/
rational * rational_init()
{
	rational * ret=(rational *) calloc( sizeof(rational),1 );
	ret->num= integer_long_init(0L);
	ret->den= integer_long_init(1L);
		return ret;
}

/*********************************************/
rational * rational_fromString(char * s)
{
	int i,lenstr;
	int base=10;
		integer * tmp=NULL;
	rational * ret=(rational *) calloc( sizeof(rational),1 );
	ret->den=integer_long_init(1L);
		lenstr=strlen(s);
		for ( ; lenstr>0 && s[lenstr]==' ' ; lenstr--);
		for (i=0; i<lenstr && s[i]!='/'; i++);
	if ( i<lenstr )
	{
		ret->num=integer_fromString(s);
				integer_destroy(ret->den);
		ret->den=integer_fromString(s+i+1);
		rational_normalize(ret);
				return ret;
	}
		for (i=0; i<lenstr && (s[i]!=' ' || s[i]==0); i++);
	switch (s[i])
	{    // если не в десятичном формате, а в формате 0x1234...
			case 'b': base=2;  break;
			case 'o': base=8;  break;
			case 'd': base=10; break;
			case 'x': base=16; break;
			default:  base=10;
		}
		for (i=0; i<lenstr && s[i]!='.'; i++);
	if ( i<lenstr )
	{
			integer_destroy(ret->den);
			ret->den=integer_long_init(base);
				integer_powa(ret->den,lenstr-i-1);
		ret->num=integer_fromString(s);
				integer_mula(ret->num,ret->den);

				tmp=integer_fromString(s+i+1);
				integer_adda(ret->num,tmp);
				integer_destroy(tmp);
		rational_normalize(ret);
				return ret;
	}
	ret->num=integer_fromString(s);
		return ret;
}

/*********************************************/
rational * rational_long_init(long y)
{
	rational * ret=(rational *) calloc( sizeof(rational),1 );
	ret->num=integer_long_init(y);
	ret->den=integer_long_init(1L);
		return ret;
}

/*********************************************/
rational * rational_long2_init(long i, long j)
{
	rational * ret=(rational *) calloc( sizeof(rational),1 );
	ret->num=integer_long_init(i);
	ret->den=integer_long_init(j);
	rational_normalize(ret);
		return ret;
}

/*********************************************/
rational * rational_integer_init(integer * y)
{
	rational * ret=(rational *) calloc( sizeof(rational),1 );
	ret->num=integer_copy(y);
	ret->den=integer_long_init(1L);
		return ret;
}

/*********************************************/
rational * rational_integer2_init(integer * y, integer * z)
{
	rational * ret=(rational *) calloc( sizeof(rational),1 );
	ret->num=integer_copy(y);
	ret->den=integer_copy(z);
		rational_normalize(ret);
		return ret;
}

/*********************************************/
rational * rational_copy(rational * y)
{
	rational * ret=(rational *) calloc( sizeof(rational),1 );
	ret->num=integer_copy(y->num);
	ret->den=integer_copy(y->den);
		rational_normalize(ret);
		return ret;
}

/**********************************************/
rational * rational_assign(rational * data, rational * y)
{
	integer_destroy(data->num);
	integer_destroy(data->den);
	data->num=integer_copy(y->num);
	data->den=integer_copy(y->den);
		rational_normalize(data);
		return data;
}

/**********************************************/
rational * rational_double_init( double x)
{
	int sgn=x<0;
	int expt,k;
		long exponent;
	double  mantissa;
		double intpart;
		integer *z;
	rational * ret=(rational *) calloc( sizeof(rational),1 );
	ret->num=integer_long_init(0L);
	ret->den=integer_long_init(1L);
	if (x==0.0)
		return ret;
	if (sgn) x=-x;
	mantissa = frexp(x, &expt);
	exponent = expt;
	for (k=0; k < 20 && mantissa!=0.0 ; k++)
	{
		mantissa *= 32768.0;
		mantissa = modf(mantissa,&intpart);
		integer_lshifta(ret->num,15);
		z=integer_long_init((long)intpart);
			integer_adda(ret->num,z);
			integer_destroy(z);
		exponent -= 15;
	}
	if (exponent > 0)
		integer_lshifta(ret->num,exponent);
	if (exponent < 0)
		{
		integer_lshifta(ret->den, -exponent);
		}
	if (sgn)
		integer_inverse(ret->num);
	rational_normalize(ret);
		return ret;
}
/***********************************************/
int rational_empty(rational * data)
{
	return ( integer_empty(data->num) );
}

/**********************************************/
int rational_cmp(rational * data, rational * y)
{
		integer * tmp1, * tmp2;
	int xsgn = data->num->sign;
	int ysgn = y->num->sign;
	int d = xsgn - ysgn;

		if ( xsgn && !ysgn )
			return -1;
		if ( !xsgn && ysgn )
			return 1;
		tmp1=integer_copy(data->num);
		integer_mula(tmp1,y->den);
		tmp2=integer_copy(data->den);
		integer_mula(tmp2,y->num);
		d=integer_cmp(tmp1,tmp2);

		integer_destroy(tmp1);
		integer_destroy(tmp2);

	return d;
}
/**********************************************/
int rational_abscmp(rational * data, rational * y)
{
	int ret;
		integer * tmp1, * tmp2;
		tmp1=integer_copy(data->num);
		integer_mula(tmp1,y->den);
		tmp2=integer_copy(data->den);
		integer_mula(tmp1,y->num);
		ret=integer_abscmp(tmp1,tmp2);
		integer_destroy(tmp1);
		integer_destroy(tmp2);
	return ret;
}

/*********************************************/
rational * rational_abs(rational * data)
{
	rational * ret=rational_copy(data);
	if ( ret->num->sign )
		integer_inverse(ret->num);
	return ret;
}

/*********************************************/
rational * rational_pow(rational * data, long y)
{
	rational * ret=rational_copy(data);
		rational_powa(ret,y);
	return ret;
}

/*********************************************/
rational * rational_powa(rational * data, long y)
{
	if (y>=0)
	{
		integer_powa(data->num,y);
		integer_powa(data->den,y);
	}
		return data;
}

/*********************************************/
rational * rational_sqr(rational * data)
{
	rational * ret = rational_copy(data);
	integer_mula(ret->num,data->num);
	integer_mula(ret->den,data->den);
	rational_normalize(ret);
		return ret;
}

/*********************************************/
rational * rational_sqrt(rational * data)
{
	integer * tmp;
	rational * ret = rational_copy(data);
		if ( integer_realLen(ret->den)<3 )
		{
			integer_lshifta(ret->num,64L);
			integer_lshifta(ret->den,64L);
		}

		tmp=integer_sqrt(ret->num);
		ret->num=integer_copy(tmp);
		integer_destroy(tmp);

		tmp=integer_sqrt(ret->den);
		ret->den=integer_copy(tmp);
		integer_destroy(tmp);

	rational_normalize(ret);
		return ret;
}

/*********************************************/
integer * rational_toInteger(rational * data)
{
	integer * ret = integer_copy(data->num);
	integer_diva(ret,data->den);
	return ret;
}

/*********************************************/
rational * rational_double_adda(rational * data,double y)
{
		rational * a= rational_double_init(y);
		rational_adda(data,a);
		rational_destroy(a);
		return data;

}

/*********************************************/
rational * rational_adda(rational * data, rational * a)
{
		integer * tmp;

		tmp=integer_copy(a->num);
	integer_mula(data->num,a->den);
		integer_mula(data->den,a->den);
		integer_mula(tmp,data->den);
		integer_adda(data->num,tmp);
		integer_destroy(tmp);

	integer_mula(data->den,a->den);
	rational_normalize(data);
		return data;
}

/***********************************************/
rational * rational_double_add(rational * data, double y)
{
	rational * ret = rational_copy(data);
		rational * a   = rational_double_init(y);
		rational_adda(ret,a);
		rational_destroy(a);
	return ret;
}

/***********************************************/
rational * rational_add(rational * data, rational * y)
{
	rational * ret = rational_copy(data);
		rational_adda(ret,y);
	return ret;
}

/*********************************************/
rational * rational_double_suba(rational * data,double y)
{
		rational * a= rational_double_init(y);
		rational_adda(data,a);
		rational_destroy(a);
		return data;
}

/*********************************************/
rational * rational_suba(rational * data, rational * a)
{
		integer * tmp;

		tmp=integer_copy(a->num);
	integer_mula(data->num,a->den);
		integer_mula(data->den,a->den);
		integer_mula(tmp,data->den);
		integer_suba(data->num,tmp);
		integer_destroy(tmp);

	rational_normalize(data);
		return data;
}

/***********************************************/
rational * rational_double_sub(rational * data, double y)
{
	rational * ret = rational_copy(data);
		rational * a   = rational_double_init(y);
		rational_suba(ret,a);
		rational_destroy(a);
	return ret;
}

/***********************************************/
rational * rational_sub(rational * data, rational * y)
{
	rational * ret = rational_copy(data);
		rational_suba(ret,y);
	return ret;
}

/***********************************************/
rational * rational_double_mula(rational * data, double y)
{
		rational * a= rational_double_init(y);
		rational_mula(data,a);
		rational_destroy(a);
		return data;
}

/***********************************************/
rational * rational_mula(rational * data, rational * y)
{
	integer_mula(data->num,y->num);
	integer_mula(data->den,y->den);
	rational_normalize(data);
	return  data;
}

/***********************************************/
rational * rational_double_mul(rational * data, double y)
{
	rational * ret = rational_copy(data);
		rational * a   = rational_double_init(y);
		rational_mula(ret,a);
		rational_destroy(a);
	return ret;
}

/***********************************************/
rational * rational_mul(rational * data, rational * y)
{
	rational * ret = rational_copy(data);
		rational_mula(ret,y);
	return ret;
}

/***********************************************/
rational * rational_double_diva(rational * data, double y)
{
		rational * a= rational_double_init(y);
		rational_diva(data,a);
		rational_destroy(a);
		return data;
}

/***********************************************/
rational * rational_diva(rational * data, rational * y)
{
	integer_mula(data->num,y->den);
	integer_mula(data->den,y->num);
	rational_normalize(data);
	return  data;
}

/***********************************************/
rational * rational_fmod(rational * data, rational * y)
{
	integer *itmp;
		rational *tmp;
	rational *ret=rational_copy(data);

	integer_mula(ret->num,y->den);
	integer_mula(ret->den,y->num);
	rational_normalize(ret);
		itmp=rational_toInteger(ret);
		tmp=rational_integer_init(itmp);
		integer_destroy(itmp);
		rational_mula(tmp,y);
		rational_destroy(ret);
		ret=rational_copy(data);
		rational_suba(ret,tmp);
		rational_destroy(tmp);
	return ret;
}

/***********************************************/
rational * rational_double_div(rational * data, double y)
{
	rational * ret = rational_copy(data);
		rational * a   = rational_double_init(y);
		rational_diva(ret,a);
		rational_destroy(a);
	return ret;
}

/***********************************************/
rational * rational_div(rational * data, rational * y)
{
	rational * ret = rational_copy(data);
		rational_diva(ret,y);
	return ret;
}

/*********************************************/
void rational_destroy(rational * data)
{
	if (data==NULL)
			return;
	integer_destroy(data->num);
		integer_destroy(data->den);
		free(data);
		return;
}

/*********************************************/
rational * rational_inv(rational * data)
{
	rational * ret = rational_copy(data);
		integer_inverse(ret->num);
	return ret;
}

/*********************************************/
rational * rational_inverse(rational * data)
{
		integer_inverse(data->num);
	return data;
}

/*********************************************/
void rational_normalize(rational * data)
{
	integer *g;
	int s = integer_sign(data->den);
	if ( s==0 )
	{
		integer_clear(data->num);
		integer_clear(data->den);
		return;
	}
		if ( integer_empty(data->num) )
		{
			integer_clear(data->den);
				return;
		}
	if ( s<0  )
	{
		integer_inverse(data->num);
		integer_inverse(data->den);
	}
	g=integer_gcd(data->num,data->den);
	integer_diva(data->num,g);
	integer_diva(data->den,g);
		integer_destroy(g);
		return;
}

/*********************************************/
int rational_sign(rational * data)
{
	return integer_sign(data->num);
}

/**********************************************/
char *  rational_toString2(rational * data)
{
	char * s1, * s2, * buf;
		int lenstr,len1,len2;
	s1=integer_toString(data->num,10);
	s2=integer_toString(data->den,10);
		len1=strlen(s1);
		len2=strlen(s2);
		lenstr=len1+len2+1;
		buf=calloc(lenstr+1,1);
		memcpy(buf,s1,len1);
		buf[len1]='/';
		memcpy(buf+len1+1,s2,len2);
		free(s1); free(s2);
	return buf;
}

/****************************************************/
char * rational_toString(rational * data ,int base, int dec, int group)
{
	int i,ptr=0;
	char * ret, * buf;
	integer * koef=integer_long_init(base);
		if (dec<0) dec=0;
	integer_powa(koef,dec+1);
	integer_mula(koef,data->num);
	integer_diva(koef,data->den);
		if ( integer_empty(data->num) || integer_empty(koef) )
		{
			ret=calloc(dec+3,1);
				ret[0]='0';
				ret[1]='.';
				for (i=0; i<dec; i++)
					ret[i+2]='0';
		}
		else
		{
		buf=integer_toString(koef,base);
			i=strlen(buf);
		if ( i>1 )
				{
					if (buf[i-1]>='5')
						buf[i-2]++;
				}
				if (dec!=0)
				{
					dec++;
						if ( dec==i )
							ptr++;
				ret=calloc(i+2+ptr,1);
						if ( dec==i )
							ret[0]='0';
				memcpy(ret+ptr,buf,i-dec);
				ret[i-dec+ptr]='.';
				memcpy(ret+ptr+i-dec+1,buf+i-dec,dec-1);
				}
				else
				{
					dec++;
						if ( dec==i )
						{
					ret=calloc(2,1);
								ret[0]='0';
						}
						else
						{
					ret=calloc(i,1);
					memcpy(ret,buf,i-1);
						}
				}
			free(buf);
		}
		integer_destroy(koef);
	return ret;
}

/****************************************************/
double      rational_toDouble(rational * data)
{
	int i;
	double ret,d1=0,d2=0,base;

		for (i=0; i<data->num->len; i++)
		{
			base=pow( (double)2, (double)(i*INTEGER_HALF));
				d1+=base*data->num->vec[i];
		}
		for (i=0; i<data->den->len; i++)
		{
			base=pow((double)2,(double)(i*INTEGER_HALF));
				d2+=base*data->den->vec[i];
		}
		ret=d1/d2;
		return ret;
}


