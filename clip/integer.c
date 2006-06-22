/*
	Copyright (C) 2001  ITK
	Author   : Uri Hnykin <uri@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
$Log$
Revision 1.1  2006/06/22 19:01:34  itk
uri: initial

Revision 1.6  2004/05/21 11:22:19  clip
rust: minor fix for 'configure -m'

Revision 1.5  2001/04/03 09:17:01  clip
license errors
paul

Revision 1.4  2001/03/30 11:51:03  clip
add copyright

Revision 1.3  2000/10/27 10:40:56  clip
bug in rational_adda
from uri:

Revision 1.2  2000/10/20 08:03:23  clip
Вкрутил rational везде где упоминается NUMERIC_t
может чего и осталось неотловленное, но это может быть только в тех
местах где нет использования NUMERIC_t !!!!!
from uri:

Revision 1.1  2000/09/12 07:28:31  clip
add integer & rational source
from uri:

*/
/*

   small documentation see in integer.h

   (c) itk 2000, www.itk.ru
   autor - uri, uri@itk.ru

*/

#include "integer.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "clip.h"

/*************************************************/
int integer_sign(integer * data)
{
	return (integer_empty(data) ? 0: (data->sign ? -1:1)) ;
}

/*************************************************/
int integer_len(integer * data)
{
	return data->len;
}

/*************************************************/
INTEGER_VECTOR integer_vec(integer * data)
{
	return data->vec;
}

/**********************************************/
int integer_realLen(integer * data)
{
	int i=data->len-1;
	for(; i>=0 && data->vec[i]==0; i--);
	return i+1;
}

void integer_destroy(integer * data)
{
		if ( data == NULL )
			return;
	if ( data->vec!=NULL)
		free(data->vec);
		if ( data!=0 )
			free(data);
		data=NULL;
}

/**********************************************/
integer * integer_init()
{
	integer * ret=(integer *) calloc(sizeof(integer),1);
	ret->sign=0;
	ret->len=0;
	ret->vec=NULL;
		return ret;
}

/**********************************************/
integer * integer_long_init( long i)
{
	integer * ret=(integer *) calloc(sizeof(integer),1);
	if (i<0)  { ret->sign=1; i=-i; }
		#ifdef INTEGER_SHORTB
	   ret->len=4;
		#else
	   ret->len=2;
		#endif
		ret->vec= ( INTEGER_VECTOR ) calloc( sizeof(INTEGER_HALF_TYPE) * ret->len,1);
	ret->vec[0]=EXTRACT(i);
		i>>=INTEGER_HALF;
	ret->vec[1]=EXTRACT(i);
		#ifdef INTEGER_SHORTB
		  i>>=INTEGER_HALF;
	  ret->vec[2]=EXTRACT(i);
		  i>>=INTEGER_HALF;
	  ret->vec[3]=EXTRACT(i);
		#endif
		return ret;
}

/**********************************************/
integer * integer_long2_init( long i ,long j)
{
	integer * ret=(integer *) calloc(sizeof(integer),1);
	if (j<0)  { ret->sign=1; j=-j; }
		#ifdef INTEGER_SHORTB
	   ret->len=8;
		#else
	   ret->len=4;
		#endif
		ret->vec= ( INTEGER_VECTOR ) calloc( sizeof(INTEGER_HALF_TYPE) * ret->len,1);
		#ifdef INTEGER_SHORTB
	   ret->vec[0]=EXTRACT(i);
		   i>>=INTEGER_HALF;
	   ret->vec[1]=EXTRACT(i);
		   i>>=INTEGER_HALF;
	   ret->vec[2]=EXTRACT(i);
		   i>>=INTEGER_HALF;
	   ret->vec[3]=EXTRACT(i);
	   ret->vec[4]=EXTRACT(j);
		   j>>=INTEGER_HALF;
	   ret->vec[5]=EXTRACT(j);
		   j>>=INTEGER_HALF;
	   ret->vec[6]=EXTRACT(j);
		   j>>=INTEGER_HALF;
	   ret->vec[7]=EXTRACT(j);
		#else
	   ret->vec[0]=EXTRACT(i);
		   i>>=INTEGER_HALF;
	   ret->vec[1]=EXTRACT(i);
	   ret->vec[2]=EXTRACT(j);
		   j>>=INTEGER_HALF;
	   ret->vec[3]=EXTRACT(j);
		#endif
		return ret;
}
/**********************************************/
integer * integer_fromString(const char * s)
{
	integer * ret=integer_long_init(0L);
		integer * a  = integer_init();
	int base=10,k,ch,i,sgn=0,lenstr=strlen(s);
	INTEGER_HALF_TYPE db,j,power;
	long sum;

		for(i=0; i<lenstr && (s[i]==' ' || s[i]=='\t'); i++);

	ch=s[i];
	if ( ch=='-' /*INTEGER_SYM_MINUS*/ )
	{
		sgn=1;
		i++;
	}
	if ( ch==INTEGER_SYM_PLUS ) i++;
	while ( s[i]=='0' ) i++;

	switch ( s[i] )
	{
		case 'b':
		case 'B':
				base=2;
				break;
		case 'o':
		case 'O':
				base=8;
				break;
		case 'd':
		case 'D':
				base=10;
				break;
		case 'x':
		case 'X':
				base=16;
				break;
		default:
				i--;
				break;
	}
	i++;
		db=INTEGER_MAXNUM/base;
		j=base;
	for(power=1; j<db; power++) j*=base;
	power*=2;

	while ( 1 )
	{
		sum=0;
		for(k=0; k<power;i++,k++)
		{
				ch=s[i];
				if (ch >= '0' && ch <= '9')
					j = ch - '0';
				else if (ch >= 'a' && ch <= 'z')
					j = ch - 'a' + 10;
				else if (ch >= 'A' && ch <= 'Z')
					j = ch - 'A' + 10;
				else
					break;
				if (j >= base)
					break;
				sum*=base; sum+=j;
			}
		if (k==0) break;
				integer_destroy(a);
		a=integer_long_init( (long)pow(base,k) );
		integer_mula(ret,a);
				integer_destroy(a);
		a=integer_long_init(sum);
		integer_sadd(ret,a);
	}
		integer_destroy(a);
	ret->sign=sgn;
	return ret;
}

/**********************************************/
integer * integer_mul(integer * d1, integer * d2)
{
	integer * ret=integer_copy(d1);
	integer_mula (ret,d2);
	return ret;
}

/**********************************************/
integer * integer_mula(integer * d1, integer *d2)
{
	int a,b,i,j,k;
	int sgn=d1->sign^d2->sign;
	INTEGER_FULL_TYPE ai,sum;

	for(a=d1->len-1; a>=0 && d1->vec[a]==0; a--);

	if ( a<0 )
			return d1;
	for(b=d2->len-1; b>=0 && d2->vec[b]==0; b--);
	if ( b<0 )
	{
		memset(d1->vec,0, sizeof(INTEGER_HALF_TYPE) * d1->len );
		return d1;
	}
	d1->sign=sgn;
	if ( a==0 && d1->vec[0]  == 1  )
	{
			if ( d1->vec!=NULL )
					free(d1->vec);
				d1->len=d2->len;
				d1->vec=(INTEGER_VECTOR) calloc(d2->len * sizeof(INTEGER_HALF_TYPE),1);
				memcpy(d1->vec,d2->vec, d2->len * sizeof(INTEGER_HALF_TYPE) );
		d1->sign=sgn;
		return d1;
	}
	if ( b==0 && d2->vec[0] == 1  )
		return d1;
		integer_resize(d1,a+b+2);
	for (i=a; i>=0; i--)
	{
		ai=d1->vec[i];
		d1->vec[i]=0;
		if ( ai==0 ) continue;
		sum=0;
		for (j=0,k=i; j<=b; j++,k++)
		{
				sum+=ai*d2->vec[j];
				sum+=d1->vec[k];
				d1->vec[k]=EXTRACT(sum);
				sum>>=INTEGER_HALF;
			}
		for ( ; sum!=0 && k<d1->len; k++ )
		{
				sum+=d1->vec[k];
				d1->vec[k]=EXTRACT(sum);
				sum>>=INTEGER_HALF;
			}
	}
		return d1;
}

/***********************************************/
integer * integer_long_mul(integer * data, long y)
{
	integer * ret= integer_copy(data);
	integer * z= integer_long_init(y);
	integer_mula(ret,z);
		integer_destroy(z);
	return ret;
}

/***********************************************/
integer * integer_long_mula(integer * data, long y)
{
	integer * z=integer_long_init(y);
	integer_mula(data,z);
		integer_destroy(z);
		return data;
}

/*********************************************/
integer * integer_pow(integer * data, long y)
{
	integer * ret = integer_copy(data);
	integer_powa(ret,y);
	return ret;
}

/*********************************************/
integer * integer_powa(integer * data, long y)
{
		integer * r=NULL, * a=NULL;
		int rl;
	int sgn = ( data->sign && (y%2==1) );
	data->sign=0;
	if (y < 0)
	{
			integer_clear(data);
				return data;
		}
	if (y==0)
	{
			integer_resize(data,1);
				data->vec[0]=1;
				return data;
		}

	for(rl=data->len-1; rl>=0 && data->vec[rl]==0; rl--);
	if (rl<0 || y==1)
		return data;

	data->sign=sgn;
	if (rl==0 && data->vec[0]==1)
		return data;

		r= integer_long_init(1L);
		a= integer_long_init(0L);
	while( 1 )
	{
		if ( y & 1 )
				integer_mula(r,data);
		if ( (y >>= 1 )==0 )
				break;
		else
		{
					integer_destroy(a);
					a=integer_copy(data);
				integer_mula(data,a);
			}
	}
	//this=r;
		integer_assign(data,r);
		data->sign=sgn;
		integer_destroy(r);
		integer_destroy(a);
		return data;
}
/*********************************************/
integer * integer_gcd(integer * data, integer * y)
{
	integer * u = integer_copy(data);
	integer * v = NULL, * t=NULL;
	int rl,i,j, br=0;
	int k=0,m;
	INTEGER_FULL_TYPE a,b;

	for(i=data->len-1; i>=0 && data->vec[i]==0; i--);
	for(j=y->len-1; j>=0 && y->vec[j]==0; j--);
	if ( j<0 )
		return u;
	if ( i<0 )
	{
			integer_destroy(u);
		u=integer_copy(y);
		return u;
		}
	rl= j>i ? j: i;

	for(i=0; i<=rl; i++)
	{
		a=data->vec[i];
		b=y->vec[i];
		for(j=0; j<INTEGER_HALF ; j++,k++)
		{
			if ( (a|b) & ((INTEGER_FULL_TYPE)1) )
						{
							br=1;
				break ;
						}
				a>>=1;
				b>>=1;
			}
				if (br)
					break;
	}
	integer_rshifta(u,k);
	v=integer_rshift(y,k);

	u->sign=0;
	v->sign=0;
	if ( u->vec[0] & 1 )
		t=integer_inv(v);
	else
		t=integer_copy(u);

	while ( !integer_empty(t) )
	{
			br=0;
		for (i=0,m=0; i<t->len; i++)
				{
				for (j=0, a=t->vec[i]; j<INTEGER_HALF ; j++, m++, a>>=1)
						{
					if ( a & ((INTEGER_FULL_TYPE)1) )
								{
									br=1;
						break;
								}
						}
						if (br)
							break;
				}
		if (m>0)
			integer_rshifta(t,m);
		if (t->sign)
		{
					integer_destroy(v);
			v=integer_inv(t);
			integer_adda(t,u);
		}
		else
		{
					integer_destroy(u);
			u=integer_copy(t);
			integer_suba(t,v);
		}
	}
	integer_lshifta(u,k);
		integer_destroy(t);
		integer_destroy(v);
	return u;
}

/***********************************************/
integer * integer_sunscale(integer * data, INTEGER_HALF_TYPE y, INTEGER_HALF_TYPE * ost)
{
	long rem = 0, u;
		int i;

	if ( data->len == 0 || y == 1)
	{
		(*ost)=0;
		return data;
	}

	for(i=data->len-1; i>=0; i--)
	{
		rem = UP(rem) | data->vec[i];
		u = rem / y;
		data->vec[i] = EXTRACT(u);
		rem -= u * y;
	}
	(*ost) = EXTRACT(rem);
		return data;
}

/****************************************************/
integer * integer_sdivide(integer * data, integer * y, integer ** div)
{
	int rl1, rl2,cmp,i;
	INTEGER_HALF_TYPE ost;
	integer * var=NULL;
	for(rl1=data->len-1; rl1>=0 && data->vec[rl1]==0; rl1--);
	for(rl2=y->len-1; rl2>=0 && y->vec[rl2]==0; rl2--);
	cmp=integer_abscmp(data,y);
	if ( rl1<0 || rl2<0 || rl1<rl2 || cmp<0 )
	{
			integer_resize(data,1);
		data->vec[0]=0;
		data->len=1;
		return data;
	}
	if (cmp==0)
	{
			integer_resize(data,1);
		data->vec[0]=1;
		data->len=1;
		return data;
		}
	data->sign=data->sign ^ y->sign;
	if ( rl2==0 )
	{
		integer_sunscale(data,y->vec[0],&ost);
		(*div)=integer_long_init(ost);
		return data;
	}
	(*div)=integer_copy(data);
	(*div)->sign=1;
	var=integer_copy(y);
	var->sign=0;
	i=(rl1-rl2)*INTEGER_HALF;
	if ( i>INTEGER_HALF )
		integer_lshifta(var,i);
	else
		i=0;
	for (; integer_abscmp(*div,var) > 0; i++ )
		integer_lshifta(var,1);
	for (; integer_abscmp(*div,var) < 0; i-- )
		integer_rshifta(var,1);
		integer_resize(data,(i/INTEGER_HALF)+1);
		memset(data->vec,0, data->len * sizeof(INTEGER_HALF_TYPE) );
	rl2=var->len-1;
	rl1=(*div)->len-1;
	for ( ;i>=0; i--)
	{
				cmp=integer_abscmp(*div,var);
		if ( cmp>=0 )
		{
				data->vec[i/INTEGER_HALF] |= ( 1 << (INTEGER_HALF_TYPE)(i%INTEGER_HALF) );
						integer_ssub(*div,var);
			}
		if ( cmp==0 )
			break;              // если числа равны
				integer_rshifta(var,1);
	}
		integer_destroy(var);
		return data;
}

/*********************************************/
integer * integer_div(integer * data, integer * y)
{
	integer * ret = integer_copy(data);
		integer * ost = NULL;
	integer_sdivide (ret, y, &ost);
		integer_destroy(ost);
	return ret;
}

/*********************************************/
integer * integer_diva(integer * data, integer * y)
{
		integer * ost = NULL;
	integer_sdivide(data,y, &ost);
		integer_destroy(ost);
		return data;
}

/*********************************************/
integer * integer_mod(integer * data, integer * y)
{
	integer * ret = NULL;
		integer * a = integer_copy(data);
	integer_sdivide(a,y,&ret);
		integer_destroy(a);
	return ret;
}

/*********************************************/
int integer_lg(integer * data)
{
	int rl,ret;
	INTEGER_HALF_TYPE a;
	for(rl=data->len-1; rl>=0 && data->vec[rl]==0; rl--);
	if (rl<0)
		return 0;
	a=data->vec[rl];
	for (ret=(rl)*INTEGER_HALF-1 ;a!=0; ret++ )
		a >>= 1;
	return ret;
}

/*********************************************/
integer * integer_sqrt(integer * data)
{
	integer * ret=integer_copy(data);
	integer * r  =integer_copy(data);
	integer * q = NULL;
	if (data->sign || integer_empty(data) )
		{
			integer_destroy(r);
		return ret;
		}
	integer_rshifta(ret,  integer_lg(ret) / 2 );
	integer_sdivide(r,ret, &q);
	while (integer_abscmp(r,ret)<0 )
	{
			integer_adda(ret,r);
			integer_rshifta(ret,1);
				integer_destroy(r);
				r=integer_copy(data);
			integer_sdivide(r,ret,&q);
		}
		integer_destroy(r);
		integer_destroy(q);
	return ret;
}

/****************************************************/
integer * integer_sadd(integer * d1 ,integer * d2)
{
	int k,i=d2->len;
	INTEGER_FULL_TYPE sum = 0;
	if ( d1->vec[d1->len-1] > (INTEGER_MAXNUM>>1) )
	{
		d1->len++;
		d1->vec=realloc(d1->vec,d1->len * sizeof(INTEGER_HALF_TYPE) );
		d1->vec[d1->len-1]=0;
	}
	for ( k=0; k<i; k++ )
	{
		sum +=((INTEGER_FULL_TYPE)(d1->vec[k])) + \
			  ((INTEGER_FULL_TYPE)(d2->vec[k]));
		d1->vec[k]=EXTRACT(sum);
		sum>>=INTEGER_HALF;
	}
	for( ;sum!=0; k++ )
	{
			sum += d1->vec[k];
			d1->vec[k] = EXTRACT(sum);
			sum>>=INTEGER_HALF;
		}
	return d1;
}
/***********************************************/
integer * integer_long_add(integer * data, long y)
{
	integer * ret=integer_copy(data);
		integer * z  =integer_long_init(y);
		integer_adda(ret,z);
		integer_destroy(z);
		return ret;
}

integer * integer_long_adda(integer * data,long y)
{
	integer * z=integer_long_init(y);
		integer_adda(data,z);
		integer_destroy(z);
		return data;
}

integer * integer_add(integer * d1,integer * d2)
{
	integer *ret=integer_copy(d1);
		integer_adda(ret,d2);
		return ret;
}

integer * integer_adda(integer * data, integer * z)
{
		integer * q = NULL;
		int cmp;
	if ( integer_empty(z) )
		return data;
		if (data->len==0 )
		{
			integer_assign(data,z);
			return data;
		}
		cmp=integer_abscmp(data,z);
		if (cmp==0 && data->sign!=z->sign )
		{
			integer_clear(data);
			return data;
		}
		if (cmp==0 && data->sign==z->sign )
		{
			integer_lshifta(data,1);
			return data;
		}
		if (cmp==1 && data->sign!=z->sign )
		{
			integer_ssub(data,z);
			return data;
		}
		if (cmp==1 && data->sign==z->sign )
		{
			integer_sadd(data,z);
			return data;
		}
		if (cmp==-1 && data->sign!=z->sign )
		{
			q=integer_copy(data);
				integer_assign(data,z);
			integer_ssub(data,q);
				integer_destroy(q);
			return data;
		}
		if (cmp==-1 && data->sign==z->sign )
		{
			integer_sadd(data,z);
			return data;
		}
		return data;
}

/*********************************************/
integer * integer_inv(integer * data)
{
	integer *ret= integer_copy(data);
	ret->sign=!ret->sign;
	return ret;
}

/*********************************************/
integer * integer_inverse(integer * data)
{
	data->sign=!data->sign;
		return data;
}

/****************************************************/
integer * integer_ssub(integer * d1, integer * d2)
{
	int k, i=d2->len;
	INTEGER_FULL_TYPE sum = 1;
	for ( k=0; k<i; k++ )
	{
		sum += INTEGER_MAXNUM - d2->vec[k];
		sum += d1->vec[k];
		d1->vec[k]=EXTRACT(sum);
		sum>>=INTEGER_HALF;
	}
	return d1;
}
/***********************************************/
integer * integer_long_sub(integer * data, long y)
{
	integer * ret = integer_copy(data);
		integer * z   = integer_long_init(y);
		integer_suba(ret,z);
		integer_destroy(z);
		return ret;
}

/***********************************************/
integer * integer_long_suba(integer * data, long y)
{
		integer * z   = integer_long_init(y);
		integer_suba(data,z);
		integer_destroy(z);
		return data;
}

/***********************************************/
integer * integer_sub(integer * data, integer * y)
{
	integer * ret = integer_copy(data);
		integer_suba(ret,y);
		return ret;
}

/****************************************************/
integer * integer_suba(integer *data, integer * y)
{
	int cmp;
		integer * q = NULL;
		if ( y->len==0 )
			return data;
		if ( data->len==0 )
		{
			integer_assign(data,y);
			return data;
		}
		cmp=integer_abscmp(data,y);
		if (cmp==0 && data->sign==y->sign )
		{
			integer_clear(data);
			return data;
		}
		if (cmp==0 && data->sign!=y->sign )
		{
			integer_lshifta(data,1);
			return data;
		}
		if (cmp==1 && data->sign==y->sign )
		{
			integer_ssub(data,y);
			return data;
		}
		if (cmp==1 && data->sign!=y->sign )
		{
			integer_sadd(data,y);
			return data;
		}
		if (cmp==-1 && data->sign==y->sign )
		{
			q=integer_copy(data);
				integer_assign(data,y);
				data->sign=!data->sign;
			integer_ssub(data,q);
				integer_destroy(q);
				return data;
		}
		if (cmp==-1 && data->sign==y->sign )
		{
			integer_sadd(data,y);
			return data;
		}
		return data;
}

/***********************************************/
integer *integer_lshifta(integer * data, int y)
{
	int bw,sw,rl,i,j;
	INTEGER_FULL_TYPE a=0;
	if ( y==0 || data->len==0 )
		return data;
	bw=y/INTEGER_HALF;
	sw=y%INTEGER_HALF;
	y=(y>0 ? y: -y );
	rl = bw + data->len + 1;
	j=data->len;
	if (rl>data->len)
			integer_resize(data,rl);
	for(rl--,i=j-1; i>=0; i--,rl--)
	{
		a=UP(a) |  ((INTEGER_FULL_TYPE )data->vec[i]) << sw;
		data->vec[rl]=EXTRACT(DOWN(a));
	}
	data->vec[rl]=EXTRACT(a);
	if (rl>0)
		memset(data->vec, 0, rl * sizeof(INTEGER_HALF_TYPE) );
		return data;
	}

/**********************************************/
integer * integer_lshift(integer * data, int y)
{
	integer * ret= integer_copy(data);
	integer_lshifta(ret,y);
	return ret;
}
/***********************************************/
integer * integer_rshifta(integer * data,int y)
{
	int bw,sw,rw,rl,i,j;
	INTEGER_FULL_TYPE a;
	if ( y==0 || data->len==0 ) return data;
	y=( y>0 ? y: -y );
	bw=y/INTEGER_HALF; sw=y%INTEGER_HALF; rw=INTEGER_HALF-sw;
	rl = data->len - bw;
	if ( rl<0 )
	{
		memset(data->vec,0, data->len * sizeof(INTEGER_HALF_TYPE) );
		return data;
	}
	a=data->vec[bw] >> sw;
	for (j=0,i=bw+1; i<data->len; i++,j++)
	{
		a|=((INTEGER_FULL_TYPE)data->vec[i]) << rw;
		data->vec[j]=EXTRACT(a);
		a>>=INTEGER_HALF;
	}
	data->vec[j]=EXTRACT(a);
		integer_resize(data,j+1);
		return data;
}

/**********************************************/
integer * integer_rshift(integer * data, int y)
{
	integer * ret = integer_copy(data);
	integer_rshifta(ret,y);
	return ret;
}

/*********************************************/
int integer_getBit(integer * data, int ind)
{
	int bw,sw;
	if ( ind<= 0)
		return 0;
	bw = ind / INTEGER_HALF;
	sw = ind % INTEGER_HALF;
	return ((bw < data->len && ( data->vec[bw] & (1 << sw)) ) != 0 );
}

/*********************************************/
integer * integer_setBit(integer * data, int ind, int value)
{
	integer * ret=integer_copy(data);
		integer_setBita(ret,ind,value);
		return ret;
}

/*********************************************/
integer * integer_setBita(integer * data, int ind, int value)
{
	int bw,sw;
	if ( ind < 0)
		return data;
	bw = ind / INTEGER_HALF;
	sw = ind % INTEGER_HALF;
	if ( value && data->len <= bw )
			integer_resize(data,bw+1);
	if ( data->len>bw )
			data->vec[bw] |= ( (unsigned int)value << sw );
	return data;
}

/**********************************************/
integer * integer_or(integer * d1, integer * d2)
{
	integer * ret=integer_copy(d1);
		integer_ora(ret,d2);
		return ret;
}

/**********************************************/
integer * integer_long_or(integer * d1, long y)
{
	integer * d2  = integer_long_init(y);
	integer * ret = integer_copy(d1);
		integer_ora(ret,d2);
		integer_destroy(d2);
		return ret;
}

/**********************************************/
integer * integer_ora(integer * d1, integer * d2)
{
	int i;
	if ( d1->len<d2->len )
		integer_resize(d1,d2->len);
	for(i=0; i<d1->len; i++)
		d1->vec[i] |= d2->vec[i];
	return d1;
}

/**********************************************/
integer * integer_and(integer * d1, integer * d2)
{
	integer * ret=integer_copy(d1);
		integer_anda(ret,d2);
		return ret;
}

/**********************************************/
integer * integer_long_and(integer * d1, long y)
{
	integer * d2  = integer_long_init(y);
	integer * ret = integer_copy(d1);
		integer_anda(ret,d2);
		integer_destroy(d2);
		return ret;
}

/**********************************************/
integer * integer_xora(integer * d1, integer * d2)
{
	int i;
	if ( d1->len<d2->len )
		integer_resize(d1,d2->len);
	for(i=0; i<d1->len; i++)
		d1->vec[i] ^= d2->vec[i];
	return d1;
}

/**********************************************/
integer * integer_xor(integer * d1, integer * d2)
{
	integer * ret=integer_copy(d1);
		integer_xora(ret,d2);
		return ret;
}

/**********************************************/
integer * integer_long_xor(integer * d1, long y)
{
	integer * d2  = integer_long_init(y);
	integer * ret = integer_copy(d1);
		integer_xora(ret,d2);
		integer_destroy(d2);
		return ret;
}

/**********************************************/
integer * integer_anda(integer * d1, integer * d2)
{
	int i;
	if (d1->len>d2->len)
		integer_resize(d1,d2->len);
	for(i=0; i<d1->len; i++)
		d1->vec[i] &= d2->vec[i];
	return d1;
}

/**********************************************/
integer * integer_copy(integer * data)
{
	integer * ret=(integer *) calloc(sizeof(integer),1);
	ret->len=data->len;
	ret->sign=data->sign;
		ret->vec= ( INTEGER_VECTOR ) calloc( sizeof(INTEGER_HALF_TYPE) * data->len,1);
		memcpy(ret->vec, data->vec, sizeof( INTEGER_HALF_TYPE )*data->len );
		return ret;
}

/**********************************************/
integer * integer_assign(integer * dst, integer * src)
{
		if ( dst->vec!=NULL )
			free(dst->vec);
		dst->vec= (INTEGER_VECTOR) malloc(src->len * sizeof(INTEGER_HALF_TYPE) );
		memcpy(dst->vec,src->vec, src->len * sizeof(INTEGER_HALF_TYPE));
		dst->len=src->len;
	dst->sign=src->sign;
		return dst;
}

/**********************************************/
char * integer_toString2(integer *data)
{
	char *ret=calloc(1,1), buf[25];
		int slen=0,blen,i;
	for(i=0; i<data->len; i++)
			{
				snprintf(buf,25,"%u",data->vec[i]);
				blen=strlen(buf);
				ret=realloc(ret,slen+blen+1);
				memcpy(ret+slen,buf,blen);
				slen+=blen;
				ret[slen]=':';
				slen++;
				}
				ret[slen-1]=0;
	return ret;
}

/****************************************************/
char * integer_toString(integer * data, int base)
{
	integer * z=integer_copy(data);
	char *ret,*buf,*sret;
		int lenstr=0,blen=0;
	INTEGER_HALF_TYPE i=INTEGER_MAXNUM/base;
	INTEGER_HALF_TYPE rem,rem2,db=base,power=1;

	lenstr=(data->len*INTEGER_HALF)*2+1;
		buf=calloc(25,1);
		buf[0]=' '; blen=1;
		ret=malloc(lenstr+1);
	for(i=0; i<lenstr; i++)  ret[i]=' ';
		ret[lenstr]=0;

	while ( db<i )  {  db*=base; power++; }
	if ( !integer_empty(data) )
	{
		lenstr--;
		while( !integer_empty(z) )
		{
				integer_sunscale(z,db,&rem2);
				for (i=0; i<power; i++)
				{
					rem= (rem2%base);
					rem+= (rem<10 ? INTEGER_SYM_NULL : (INTEGER_SYM_A-10) );
					rem2/=base;
					ret[lenstr]=(char)rem;
					lenstr--;
				}
			}
	}
		lenstr=strlen(ret);
		for (i=0; i<lenstr && (ret[i]==' ' || ret[i]=='0'); i++);
	if ( data->sign )
			buf[0]='-';
	switch (base)
	{
		case 2:
					buf[blen]='0';
						buf[blen+1]='b';
						blen+=2;
				break;
		case 8:
					buf[blen]='0';
						buf[blen+1]='o';
						blen+=2;
				break;
		case 16:
					buf[blen]='0';
						buf[blen+1]='x';
						blen+=2;
				break;
	}
	if ((lenstr-i)==0)
		{
		buf[blen]='0';
				blen++;
		}
		sret=malloc(lenstr+blen+data->sign+1);
		sprintf(sret,"%s%s",buf+1-data->sign,ret+i);
		sret[lenstr+blen+data->sign]=0;
		free(buf);
		free(ret);
	integer_destroy(z);
	return sret;
}

/*********************************************/
long integer_toLong(integer * data)
{
	long ret=data->vec[1]*INTEGER_MAXNUM | data->vec[0];
	if (data->sign) ret=-ret;
	return ret;
}

/***********************************************/
int integer_abscmp(integer * d1, integer * d2)
{
	int i,j;
		for(i=d1->len-1; i>=0 && d1->vec[i]==0;i--);
		for(j=d2->len-1; j>=0 && d2->vec[j]==0;j--);
	if ( i>j )     return  1;
	if ( i<j )     return -1;
	for(; i>=0 && d1->vec[i]==d2->vec[i]; i--);
	if (i<0) return 0;
	if ( d1->vec[i]>d2->vec[i]) return 1;
	return -1;
}

/**********************************************/
int integer_cmp(integer * d1, integer * d2 )
{
	if ( d1->sign!=d2->sign )
	{
		if (d1->sign)
			return  1;
		else
			return -1;
	}
		return integer_abscmp(d1,d2);
}

/*********************************************/
integer * integer_abs(integer * data)
{
	integer * ret = integer_copy(data);
	ret->sign=0;
	return ret;
}
/*********************************************/
int integer_even(integer * data)
{
	return (data->vec[0]%2)==0;
}

/***********************************************/
integer * integer_clear(integer * data)
{
	data->sign=0;
	memset(data->vec,0,data->len * sizeof(INTEGER_HALF_TYPE) );
		return data;
}

int integer_empty(integer * data)
{
	int i;
	for(i=data->len-1; i>=0 && data->vec[i]==0 ; i--) ;
	return (i<0);
}

/***********************************************/
void integer_printf(char * str, integer * d)
{
		int i;
		printf(str);
	printf(": sign=%d, len=%d, data=",d->sign, d->len);
		for(i=0; i<d->len; i++)
			printf("%d",d->vec[i]);
		printf("\n");
}


/********************************************************/
integer * integer_unscale(integer *data, INTEGER_HALF_TYPE y, INTEGER_HALF_TYPE * ost)
{
	integer * ret=integer_copy(data);
	integer_sunscale(ret,y,ost);
	return ret;
}

/**********************************************/
integer * integer_resize(integer * data, int newlen)
{
		newlen=newlen > 0 ? newlen: 1;
	data->vec=realloc((void *)data->vec,sizeof(INTEGER_HALF_TYPE) * newlen);
		if (data->len<newlen)
			memset((void *)(data->vec+data->len),0,sizeof(INTEGER_HALF_TYPE) * (newlen-data->len) );
	data->len=newlen;
		return data;
}

