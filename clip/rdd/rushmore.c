/*
	Copyright (C) 2001  ITK
	Author  : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: rushmore.c,v $
	Revision 1.35  2002/10/11 10:33:10  clip
	rust: m6_IsOptimize()
	
	Revision 1.34  2002/10/09 11:35:47  clip
	rust: some cleanups

	Revision 1.33  2002/09/27 13:50:42  clip
	rust: m6_RecCount()

	Revision 1.32  2002/09/02 11:34:19  clip
	rust: rddsetfilter() with aliasing improved

	Revision 1.31  2002/08/30 10:16:35  clip
	rust: rddsetfilter(<handle>,<cFilter>,<aAliases>) (<aAliases> added)

	Revision 1.30  2002/04/30 09:10:26  clip
	rust: 'X' field type support

	Revision 1.29  2002/01/18 12:29:35  clip
	rust: fixes

	Revision 1.28  2001/12/23 15:09:53  clip
	bug in rm_setscope()
	rust

	Revision 1.27  2001/12/20 10:20:06  clip
	optimize bug
	rust

	Revision 1.26  2001/11/18 11:18:29  clip
	Don't use UNIQUE indexes by optimize
	rust

	Revision 1.25  2001/10/24 10:16:28  clip
	uri: move ch-files to include, fixed configure and Makefie`s for it.

	Revision 1.24  2001/10/22 12:07:05  clip
	many fixes and bugs :)
	rust

	Revision 1.23  2001/10/10 15:04:58  clip
	many fixes
	rust

	Revision 1.22  2001/10/03 10:04:09  clip
	Ignoring FOR-indexes for optimizing
	rust

	Revision 1.21  2001/10/01 10:32:58  clip
	bug in parsing filter expression (SET OPTIMIZE ON)
	rust

	Revision 1.20  2001/09/28 10:02:40  clip
	Bug in rm_init() (rm_checkpair())
	rust

	Revision 1.19  2001/09/25 15:55:39  clip
	some changes
	rust

	Revision 1.18  2001/09/22 13:20:54  clip
	some optimizations
	rust

	Revision 1.17  2001/09/12 10:51:16  clip
	Quick dbCreateIndex() using BTree
	rust

	Revision 1.16  2001/09/04 09:41:44  clip
	rest of SIX functions
	rust

	Revision 1.15  2001/08/24 12:26:03  clip
	LOCATE with SET FILTER and LOCAL
	rust

	Revision 1.14  2001/08/23 14:44:49  clip
	Logging started
	rust

*/
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include "error.ch"
#include "../rdd.h"

#define ADDLEX(lex) if(rd->rmfilter) astrcat(&rd->rmfilter,&rd->rmflen,(lex))

static void astrcat(char** d,int* l,char* s){
	int ls = strlen(s);

	*d = realloc(*d,*l+ls+1);
	strcpy(*d+*l,s);
	*l += ls;
}

int rm_yylex(RDD_DATA* rd){
	int r = 0;
	char c = *rd->ptr;
	char quote = 0;

	if(!c)
		return RM_END_EXPR;

	if(rd->yylval){
		free(rd->yylval);
		rd->yylval = NULL;
	}

	while(*(++rd->ptr)==' ');
	while(!r){
		if(quote){
			if(c==quote){
				quote=0;
/*				while(*(rd->ptr)==' ') rd->ptr++;
				c = *rd->ptr;
				rd->ptr++;*/
			}
		} else {
			if(c=='"' || c== '\'')
				quote = c;
		}
		if(c == RM_END_EXPR){
			if(rd->word){
				rd->word = realloc(rd->word,rd->wlen+1);
				rd->word[rd->wlen] = 0;
				rd->yylval = strdup(rd->word);
				r = RM_WORD;
				free(rd->word);
				rd->word = NULL;
				while(*(--rd->ptr)==' ');
			} else {
				r = RM_ERROR;
			}
		} else if(!quote && (c == RM_LP)){
			r = RM_LP;
		} else if(!quote && (c == RM_RP)){
			if(rd->word){
				rd->word = realloc(rd->word,rd->wlen+1);
				rd->word[rd->wlen] = 0;
				rd->yylval = strdup(rd->word);
				r = RM_WORD;
				free(rd->word);
				rd->word = NULL;
				while(*(--rd->ptr)==' ');
			} else {
				r = RM_RP;
			}
		} else if(!quote && (c == '.' && isalpha(*rd->ptr) && *(rd->ptr+1)!='.')){
			if(rd->word){
				rd->word = realloc(rd->word,rd->wlen+1);
				rd->word[rd->wlen] = 0;
				rd->yylval = strdup(rd->word);
				r = RM_WORD;
				free(rd->word);
				rd->word = NULL;
				while(*(--rd->ptr)==' ');
			} else if(strncasecmp(rd->ptr,"OR.",3)==0){
				r = RM_OR;
				rd->ptr += 3;
				while(*rd->ptr==' ') rd->ptr++;
			} else if(strncasecmp(rd->ptr,"AND.",4)==0){
				r = RM_AND;
				rd->ptr += 4;
				while(*rd->ptr==' ') rd->ptr++;
			}
		} else if(!quote && (c == '=')){
			if(rd->word){
				rd->word = realloc(rd->word,rd->wlen+1);
				rd->word[rd->wlen] = 0;
				rd->yylval = strdup(rd->word);
				r = RM_WORD;
				free(rd->word);
				rd->word = NULL;
				while(*(--rd->ptr)==' ');
			} else if(*rd->ptr == '='){
				r = RM_EEQU;
				rd->ptr++;
				while(*rd->ptr==' ') rd->ptr++;
			} else {
				r = RM_EQU;
				while(*rd->ptr==' ') rd->ptr++;
			}
		} else if(!quote && (c == '>')){
			if(rd->word){
				rd->word = realloc(rd->word,rd->wlen+1);
				rd->word[rd->wlen] = 0;
				rd->yylval = strdup(rd->word);
				r = RM_WORD;
				free(rd->word);
				rd->word = NULL;
				while(*(--rd->ptr)==' ');
			} else if(*rd->ptr == '='){
				r = RM_LARE;
				rd->ptr++;
				while(*rd->ptr==' ') rd->ptr++;
			} else {
				r = RM_LAR;
				while(*rd->ptr==' ') rd->ptr++;
			}
		} else if(!quote && (c == '<')){
			if(rd->word){
				rd->word = realloc(rd->word,rd->wlen+1);
				rd->word[rd->wlen] = 0;
				rd->yylval = strdup(rd->word);
				r = RM_WORD;
				free(rd->word);
				rd->word = NULL;
				while(*(--rd->ptr)==' ');
			} else if(*rd->ptr == '='){
				r = RM_LESE;
				rd->ptr++;
				while(*rd->ptr==' ') rd->ptr++;
			} else if(*rd->ptr == '>'){
				r = RM_NEQU;
				rd->ptr++;
				while(*rd->ptr==' ') rd->ptr++;
			} else {
				r = RM_LES;
				while(*rd->ptr==' ') rd->ptr++;
			}
		} else if(!quote && (c == '!')){
			if(rd->word){
				rd->word = realloc(rd->word,rd->wlen+1);
				rd->word[rd->wlen] = 0;
				rd->yylval = strdup(rd->word);
				r = RM_WORD;
				free(rd->word);
				rd->word = NULL;
				while(*(--rd->ptr)==' ');
			} else if(*rd->ptr == '='){
				r = RM_NEQU;
				rd->ptr++;
				while(*rd->ptr==' ') rd->ptr++;
			} else {
				r = RM_NOT;
				while(*rd->ptr==' ') rd->ptr++;
			}
		} else {
			if(!rd->word){
				rd->word = malloc(1);
				rd->wlen = 1;
			} else {
				rd->wlen++;
				rd->word = realloc(rd->word,rd->wlen);
			}
			rd->word[rd->wlen-1] = c;
			r = 0;
			c = *rd->ptr;
			rd->ptr++;
		}
	}
	return r;
}

static void rm_checkpar(char* c,char* end){
	int ps = 1;
	char* b = c;
	int squote = 0;
	int dquote = 0;

	while(ps && (++c < end)){
		if(*c=='\"'){
			dquote = !dquote;
		} else if(*c=='\''){
			squote = !squote;
		}
		if(squote || dquote)
			continue;
		if(*c==')'){
			ps--;
		} else if(*c=='('){
			ps++;
		} else if(*c=='<' || (*c=='>' && *(c-1)!='-') || *c=='!' || *c=='=' ||
			(*c=='.' && isalpha(*(c+1)))){
			return;
		}
	}
	if(!ps){
		(*b) = RM_LP;
		(*c) = RM_RP;
	}
}

int rm_init(ClipMachine* cm,RDD_DATA* rd,char* str,const char* __PROC__){
	char* end = str+strlen(str);
	int squote = 0;
	int dquote = 0;

	for(rd->ptr=str;rd->ptr<end;rd->ptr++){
		if(*rd->ptr=='\"'){
			dquote = !dquote;
		} else if(*rd->ptr=='\''){
			squote = !squote;
		}
		if(squote || dquote)
			continue;
		if(*rd->ptr=='('){
			rm_checkpar(rd->ptr,end);
		}
	}
	for(rd->ptr=str;rd->ptr<end;rd->ptr++){
		if(*rd->ptr=='(')
			*rd->ptr = RM_LP;
		else if(*rd->ptr==')')
			*rd->ptr = RM_RP;
		else if(*rd->ptr==RM_LP)
			*rd->ptr = '(';
		else if(*rd->ptr==RM_RP)
			*rd->ptr = ')';
		else if(*rd->ptr=='>' && rd->ptr != str && *(rd->ptr-1)=='-')
			*rd->ptr = RM_AL;
	}
	rd->ptr = str;
	rd->word = 0;
	rd->wlen = 0;
	rd->yylval = 0;
	return 0;
}

static void rm_and(unsigned int* lval,unsigned int* rval,int* lopt,int ropt,int bytes){
	int i;

	for(i=0;i<bytes;i++)
		lval[i] = lval[i] & rval[i];
	free(rval);
	*lopt += ropt;
	if(*lopt==4)
		*lopt = 2;
	else if(*lopt>0)
		*lopt = 1;
}

static void rm_or(unsigned int* lval,unsigned int* rval,int* lopt,int ropt,int bytes){
	int i;

	for(i=0;i<bytes;i++)
		lval[i] = lval[i] | rval[i];
	free(rval);
	if(*lopt==2 && ropt==2)
		*lopt = 2;
	else if((*lopt==2 && ropt==1) || (*lopt==1 && ropt==2))
		*lopt = 1;
	else if(*lopt==1 && ropt==1)
		*lopt = 1;
	else
		*lopt = 0;
}

static void rm_not(unsigned int* lval,unsigned int* rval,int bytes){
	int i;

	for(i=0;i<bytes;i++)
		lval[i] = ~rval[i];
	free(rval);
}

static int rm_invoper(int oper){
	switch(oper){
		case RM_LAR:
			return RM_LES;
		case RM_LARE:
			return RM_LESE;
		case RM_LES:
			return RM_LAR;
		case RM_LESE:
			return RM_LARE;
	}
	return oper;
}

static void rm_inc(DbfLocale* loc,ClipVar* v,ClipVar* vv){
	if(v->t.type!=vv->t.type)
		return;
	switch(v->t.type){
		case CHARACTER_t:
			v->s.str.buf = realloc(v->s.str.buf,vv->s.str.len+1);
			if(v->s.str.len < vv->s.str.len)
				memset(v->s.str.buf+v->s.str.len,' ',vv->s.str.len-v->s.str.len);
			v->s.str.len = vv->s.str.len;
			v->s.str.buf[v->s.str.len] = 0;
			if((unsigned char)v->s.str.buf[v->s.str.len-1]<128)
				v->s.str.buf[v->s.str.len-1]++;
			break;
		case NUMERIC_t:
			v->n.d += pow(v->n.d,-v->t.dec);
			break;
		case DATE_t:
			v->d.julian++;
			break;
		case LOGICAL_t:
			v->l.val = !v->l.val;
			break;
		default:
			break;
	}
}

static void rm_dec(DbfLocale* loc,ClipVar* v,ClipVar* vv){
	if(v->t.type!=vv->t.type)
		return;
	switch(v->t.type){
		case CHARACTER_t:
			v->s.str.buf = realloc(v->s.str.buf,vv->s.str.len+1);
			if(v->s.str.len < vv->s.str.len)
				memset(v->s.str.buf+v->s.str.len,' ',vv->s.str.len-v->s.str.len);
			v->s.str.len = vv->s.str.len;
			v->s.str.buf[v->s.str.len] = 0;
			if((unsigned char)v->s.str.buf[v->s.str.len-1]<128)
				v->s.str.buf[v->s.str.len-1]--;
			break;
		case NUMERIC_t:
			v->n.d -= pow(v->n.d,-v->t.dec);
			break;
		case DATE_t:
			v->d.julian--;
			break;
		case LOGICAL_t:
			v->l.val = !v->l.val;
			break;
		default:
			break;
	}
}

static int rm_setscope(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER* fp,unsigned int* map,int oper,char* lval,char* rval,int bytes,int* optimize,int test,const char* __PROC__){
	int i,er;
	ClipVar v,vv;
	char* b = NULL;
	char* e = NULL;
	char* l = malloc(strlen(lval)+1);
	char* r = malloc(strlen(rval)+1);
	char *s,*d,*l1,*r1;

	memset(&v,0,sizeof(ClipVar));
	memset(&vv,0,sizeof(ClipVar));
	*optimize = 0;
	for(s=lval,d=l;*s;s++){
		if(*s != ' ')
			*(d++) = *s;
	}
	*d = 0;
	while((d = strstr(l,"FIELD->")))
		memmove(d,d+7,strlen(d+7)+1);
	for(s=rval,d=r;*s;s++){
		if(*s != ' ')
			*(d++) = *s;
	}
	*d = 0;
	while((d = strstr(r,"FIELD->")))
		memmove(d,d+7,strlen(d+7)+1);
	l1 = strdup(l);
	l1[strlen(l1)-1]=0;
	r1 = strdup(r);
	r1[strlen(r1)-1]=0;
	for(i=0;i<rd->ords_opened;i++){
		if(rd->orders[i]->bforexpr.t.type != UNDEF_t)
			continue;
		if(rd->orders[i]->unique)
			continue;
		if((strcasecmp(rd->orders[i]->expr,l)==0) ||
			(strcasecmp(rd->orders[i]->expr,l1+1)==0)){
			b = rval;
			e = lval;
		} else if((strcasecmp(rd->orders[i]->expr,r)==0) ||
			(strcasecmp(rd->orders[i]->expr,r1+1)==0)){
			b = lval;
			e = rval;
			oper = rm_invoper(oper);
		}
		if(b){
			cm->noerrblock++;
			er = _clip_eval_macro(cm,b,strlen(b),&v);
			cm->noerrblock--;
			if(er)
				break;
			if(_clip_vptr(&v)->t.type==UNDEF_t)
				break;
/*			{
				char err[100];
				sprintf(err,"Bad expression: %s",b);
				rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,err);
				goto err;
			}*/
			if(!test){
				if(oper == RM_EQU || oper == RM_EEQU){
					if(rd->orders[i]->vtbl->setscope(cm,rd,rd->orders[i],&v,&v,map,
						fp->size,__PROC__)) goto err;
				} else if(oper == RM_NEQU){
					unsigned int* tm = calloc(sizeof(unsigned int),bytes);
					if(rd->orders[i]->vtbl->setscope(cm,rd,rd->orders[i],&v,&v,tm,
						fp->size,__PROC__)) goto err;
					rm_not(map,tm,bytes);
				} else if(oper == RM_LAR){
					if(_clip_eval_macro(cm,e,strlen(e),&vv))
						break;
					rm_inc(rd->loc,&v,_clip_vptr(&vv));
					if(rd->orders[i]->vtbl->setscope(cm,rd,rd->orders[i],&v,NULL,map,
						fp->size,__PROC__)) goto err;
				} else if(oper == RM_LARE){
					if(rd->orders[i]->vtbl->setscope(cm,rd,rd->orders[i],&v,NULL,map,
						fp->size,__PROC__)) goto err;
				} else if(oper == RM_LES){
					if(_clip_eval_macro(cm,e,strlen(e),&vv))
						break;
					rm_dec(rd->loc,&v,_clip_vptr(&vv));
					if(rd->orders[i]->vtbl->setscope(cm,rd,rd->orders[i],NULL,&v,map,
						fp->size,__PROC__)) goto err;
				} else if(oper == RM_LESE){
					if(rd->orders[i]->vtbl->setscope(cm,rd,rd->orders[i],NULL,&v,map,
						fp->size,__PROC__)) goto err;
				}
			}
			*optimize = 2;
			break;
		}
	}
	_clip_destroy(cm,&v);
	_clip_destroy(cm,&vv);
	free(l); free(r);
	free(l1); free(r1);
	if(!(*optimize))
		memset(map,0xff,bytes >> 2);
	return 0;
err:
	_clip_destroy(cm,&v);
	_clip_destroy(cm,&vv);
	free(l); free(r);
	free(l1); free(r1);
	return 1;
}

static char* rm_alias2name(int npseudo,RDD_PSEUDO* pseudo,char* alias){
	int i;

	for(i=0;i<npseudo;i++){
		if(strcasecmp(alias,pseudo[i].alias) == 0)
			return strdup(pseudo[i].name);
	}
	return strdup(alias);
}

static unsigned int* rm_prim(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER* fp,int bytes,int* optimize,int npseudo,RDD_PSEUDO* pseudo,int test,const char* __PROC__){
	unsigned int* bm = calloc(sizeof(unsigned int),bytes);
	int oper;
	char* lval;
	char* rval;
	char* p;

	rd->curlex = rm_yylex(rd);
	switch(rd->curlex){
		case RM_NOT:
			ADDLEX("!");
			rm_not(bm,rm_prim(cm,rd,fp,bytes,optimize,npseudo,pseudo,test,__PROC__),bytes);
			return bm;
		case RM_LP:
			ADDLEX("(");
			free(bm);
			bm = rm_expr(cm,rd,fp,bytes,optimize,npseudo,pseudo,test,__PROC__);
			if(rd->curlex!=RM_RP){
				free(bm); // Right bracket expected
				return NULL;
			}
			ADDLEX(")");
			break;
		case RM_WORD:
		{
			ClipVar lb,rb,lv,rv;
			char expr[1024];
			int er;

			p = lval = rm_alias2name(npseudo,pseudo,rd->yylval);
			oper = rd->curlex = rm_yylex(rd);
			while(*p){
				if(*p==RM_AL)
					*p = '>';
				p++;
			}
			if(oper != RM_EQU && oper != RM_EEQU && oper != RM_NEQU
				&& oper != RM_LAR && oper != RM_LARE
				&& oper != RM_LES && RM_LESE)
			{
				rdd_expandmacro(rd->area,rd->rdhandle,lval,expr);
				cm->noerrblock++;
				er = _clip_eval_macro(cm,expr,strlen(expr),&lb);
				cm->noerrblock--;
				er = _clip_eval(cm,_clip_vptr(&lb),0,NULL,&lv);
				_clip_destroy(cm,&lb);
				_clip_destroy(cm,&lv);
				if(er){
					ADDLEX(".T.");
					memset(bm,0xff,bytes >> 2);
				} else {
					ADDLEX(lval);
					if(rm_setscope(cm,rd,fp,bm,RM_EEQU,lval,".T.",bytes,
						optimize,test,__PROC__)) return NULL;
				}
				free(lval);
				return bm;
			}
			rd->curlex = rm_yylex(rd);
			if(rd->curlex != RM_WORD){
				rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
					"Expression expected");
				return NULL;
			}
			rval = rm_alias2name(npseudo,pseudo,rd->yylval);
			rdd_expandmacro(rd->area,rd->rdhandle,lval,expr);
			cm->noerrblock++;
			_clip_eval_macro(cm,expr,strlen(expr),&lb);
			er = _clip_eval(cm,_clip_vptr(&lb),0,NULL,&lv);
			_clip_destroy(cm,&lb);
			_clip_destroy(cm,&lv);
			if(!er){
				rdd_expandmacro(rd->area,rd->rdhandle,rval,expr);
				_clip_eval_macro(cm,expr,strlen(expr),&rb);
				er = _clip_eval(cm,_clip_vptr(&rb),0,NULL,&rv);
				_clip_destroy(cm,&rb);
				_clip_destroy(cm,&rv);
			}
			cm->noerrblock--;
			if(er){
				ADDLEX(".T.");
				memset(bm,0xff,bytes >> 2);
			} else {
				ADDLEX(lval);
				switch(oper){
					case RM_EQU:
						ADDLEX("="); break;
					case RM_EEQU:
						ADDLEX("=="); break;
					case RM_NEQU:
						ADDLEX("!="); break;
					case RM_LAR:
						ADDLEX(">"); break;
					case RM_LARE:
						ADDLEX(">="); break;
					case RM_LES:
						ADDLEX("<"); break;
					case RM_LESE:
						ADDLEX("<="); break;
				}
				ADDLEX(rval);
				if(rm_setscope(cm,rd,fp,bm,oper,lval,rval,bytes,
					optimize,test,__PROC__)) return NULL;
			}
			free(lval);
			free(rval);
			break;
		}
		default:
			return NULL;
	}
	rd->curlex = rm_yylex(rd);
	return bm;
}

static unsigned int* rm_term(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER* fp,int bytes,int* optimize,int npseudo,RDD_PSEUDO* pseudo,int test,const char* __PROC__){
	unsigned int* bm = rm_prim(cm,rd,fp,bytes,optimize,npseudo,pseudo,test,__PROC__);
	unsigned int* bm2;
	int opt2;

	for(;;){
		if(rd->curlex == RM_AND){
			ADDLEX(" .and. ");
			if(!(bm2 = rm_prim(cm,rd,fp,bytes,&opt2,npseudo,pseudo,test,__PROC__))) return NULL;
			rm_and(bm,bm2,optimize,opt2,bytes);
		} else
			break;
	}
	return bm;
}

unsigned int* rm_expr(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER* fp,int bytes,int* optimize,int npseudo,RDD_PSEUDO* pseudo,int test,const char* __PROC__){
	unsigned int* bm = rm_term(cm,rd,fp,bytes,optimize,npseudo,pseudo,test,__PROC__);
	unsigned int* bm2;
	int opt2;

	for(;;){
		if(rd->curlex == RM_OR){
			ADDLEX(" .or. ");
			if(!(bm2 = rm_term(cm,rd,fp,bytes,&opt2,npseudo,pseudo,test,__PROC__))) return NULL;
			rm_or(bm,bm2,optimize,opt2,bytes);
		} else
			break;
	}
	return bm;
}

int rm_checkjoin(ClipMachine* cm,RDD_FILTER* f1,RDD_FILTER* f2,const char* __PROC__){
	if(!f1 || !f2){
		rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
			"Invalid handle to filter");
		goto err;
	}
	if(f1->custom != f2->custom){
		rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
			"Trying to join custom and ordinary filter");
		goto err;
	}
	if(f1->rd != f2->rd){
		rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
			"Trying to join different areas filters");
		goto err;
	}
	if((f1->rmap && !f2->rmap) || (!f1->rmap && f2->rmap)){
		rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
			"Trying to join optimized and non-optimized filters");
		goto err;
	}
	if(f1->size != f2->size){
		rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
			"Trying to join filters of different lengths");
		goto err;
	}
	if(!f1->custom){
		if(!f1->sfilter || !f2->sfilter){
			rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
				"No expression on filter");
			goto err;
		}
	}
	return 0;
err:
	return 1;
}

int rm_union(ClipMachine* cm,RDD_FILTER* f1,RDD_FILTER* f2,const char* __PROC__){
	int i;
	unsigned int bytes = ((f1->size+1) >> 5) + 1;

	if(f1->rmap){
		for(i=0;i<bytes;i++){
			f1->rmap[i] |= f2->rmap[i];
		}
	}
	if(f1->sfilter && f2->sfilter){
		char* tmp = strdup(f1->sfilter);

		f1->sfilter = realloc(f1->sfilter,
			strlen(f1->sfilter)+strlen(f2->sfilter)+11);
		sprintf(f1->sfilter,"(%s) .OR. (%s)",tmp,f2->sfilter);
		free(tmp);
	} else {
		if(f1->sfilter)
			free(f1->sfilter);
		f1->sfilter = NULL;
	}
	f1->nfps++;
	f1->fps = (RDD_FPS*)realloc(f1->fps,f1->nfps*sizeof(RDD_FPS));
	_clip_clone(cm,&f1->fps[f1->nfps-1].bfilter,&f2->fps->bfilter);
	f1->fps[f1->nfps-1].op = 1;

	if(f1->optimize==2 && f2->optimize==2)
		f1->optimize = 2;
	else if((f1->optimize==2 && f2->optimize==1) || (f1->optimize==1 && f2->optimize==2))
		f1->optimize = 1;
	else if(f1->optimize==1 && f2->optimize==1)
		f1->optimize = 1;
	else
		f1->optimize = 0;
	return 0;
}

int rm_intersect(ClipMachine* cm,RDD_FILTER* f1,RDD_FILTER* f2,const char* __PROC__){
	int i;
	unsigned int bytes = ((f1->size+1) >> 5) + 1;

	if(f1->rmap){
		for(i=0;i<bytes;i++){
			f1->rmap[i] &= f2->rmap[i];
		}
	}
	if(f1->sfilter && f2->sfilter){
		char* tmp = strdup(f1->sfilter);

		f1->sfilter = realloc(f1->sfilter,
			strlen(f1->sfilter)+strlen(f2->sfilter)+12);
		sprintf(f1->sfilter,"(%s) .AND. (%s)",tmp,f2->sfilter);
		free(tmp);
	} else {
		if(f1->sfilter)
			free(f1->sfilter);
		f1->sfilter = NULL;
	}
	f1->nfps++;
	f1->fps = (RDD_FPS*)realloc(f1->fps,f1->nfps*sizeof(RDD_FPS));
	_clip_clone(cm,&f1->fps[f1->nfps-1].bfilter,&f2->fps->bfilter);
	f1->fps[f1->nfps-1].op = 2;

	f1->optimize += f1->optimize;
	if(f1->optimize==4)
		f1->optimize = 2;
	else if(f1->optimize>0)
		f1->optimize = 1;
	return 0;
}

int rm_difference(ClipMachine* cm,RDD_FILTER* f1,RDD_FILTER* f2,const char* __PROC__){
	int i;
	unsigned int bytes = ((f1->size+1) >> 5) + 1;

	if(f1->rmap){
		for(i=0;i<bytes;i++){
			f1->rmap[i] ^= f2->rmap[i];
		}
	}
	return 0;
}

int rm_evalpartial(ClipMachine* cm,RDD_FILTER* fp,ClipVar* block,unsigned int* ret,unsigned int* cnt,const char* __PROC__){
	ClipVar v;
	unsigned int oldrecno = fp->rd->recno;
	int oldbof = fp->rd->bof;
	int oldeof = fp->rd->eof;

	*ret = 0;
	if(cnt)
		*cnt = 0;

	if(!fp->rmap && cnt){
		if(fp->list)
			*cnt = fp->listlen;
		else
			if(rdd_lastrec(cm,fp->rd,cnt,__PROC__)) goto err;
		return 0;
	}

	memset(&v,0,sizeof(ClipVar));
	fp->rd->bof = fp->rd->eof = 0;
	for(fp->rd->recno=1;fp->rd->recno<=fp->size;fp->rd->recno++){
		if(_rm_getbit(fp->rmap,fp->size,fp->rd->recno)){
			if(fp->optimize==2){
				if(cnt)
					(*cnt)++;
			} else {
				int fok;

				if(rdd_childs(cm,fp->rd,__PROC__)) return 1;
				if(block){
					ClipVar v,*vp;

					if(rdd_calc(cm,fp->rd->area,block,&v,0)) goto err;
					vp = _clip_vptr(&v);
					if(vp->t.type!=LOGICAL_t){
						_clip_destroy(cm,&v);
						rdd_err(cm,EG_SYNTAX,0,__FILE__,__LINE__,__PROC__,
							"Codeblock returns non-logical value");
						goto err;
					}
					fok = vp->l.val;
					_clip_destroy(cm,&v);
				} else {
					if(rdd_calcfilter(cm,fp->rd,&fok,__PROC__)) return 1;
				}
				if(!fok)
					_rm_clrbit(fp->rmap,fp->size,fp->rd->recno);
				else if(cnt)
					(*cnt)++;
			}
			(*ret)++;
		}
	}
	fp->rd->recno = oldrecno;
	fp->rd->bof = oldbof;
	fp->rd->eof = oldeof;
	if(rdd_childs(cm,fp->rd,__PROC__)) return 1;
	return 0;
err:
	return 1;
}

int rm_inverse(ClipMachine* cm,RDD_FILTER* fp,const char* __PROC__){
	int i;
	unsigned int bytes = ((fp->size+1) >> 5) + 1;

	if(fp->rmap){
		for(i=0;i<bytes;i++){
			fp->rmap[i] = ~fp->rmap[i];
		}
	}
	if(fp->sfilter){
		char* tmp = strdup(fp->sfilter);

		fp->sfilter = realloc(fp->sfilter,
			strlen(fp->sfilter)+4);
		sprintf(fp->sfilter,"!(%s)",tmp);
		free(tmp);
	}
	fp->fps->op = 4;
	return 0;
}

int rm_copyfilter(ClipMachine* cm,RDD_FILTER* fp,RDD_FILTER** ret,const char* __PROC__){
	RDD_FILTER* r = calloc(sizeof(RDD_FILTER),1);
	int i;

	r->custom = fp->custom;
	r->optimize = fp->optimize;
	r->nfps = fp->nfps;
	r->fps = calloc(fp->nfps,sizeof(RDD_FPS));
	for(i=0;i<fp->nfps;i++){
		_clip_clone(cm,&r->fps[i].bfilter,&fp->fps[i].bfilter);
		r->fps[i].op = fp->fps[i].op;
	}
	if(fp->sfilter)
		r->sfilter = strdup(fp->sfilter);
	r->size = fp->size;
	if(fp->rmap){
		int i;
		int bytes = ((r->size+1) >> 5) + 1;

		r->rmap = calloc(sizeof(unsigned int),bytes);
		for(i=0;i<bytes;i++)
			r->rmap[i] = fp->rmap[i];
	}
	r->rd = fp->rd;
	r->handle = _clip_store_c_item(cm,r,_C_ITEM_TYPE_RYO,destroy_ryo);
	*ret = r;
	return 0;
}

int rm_isfiltrec(ClipMachine* cm,RDD_FILTER* fp,unsigned int rec,int* r,const char* __PROC__){
	*r = 0;
	if(fp->rmap && _rm_getbit(fp->rmap,fp->size,rec)){
		unsigned int oldrecno = fp->rd->recno;
		fp->rd->recno = rec;
		if(rdd_calcfilter(cm,fp->rd,r,__PROC__)) return 1;
		fp->rd->recno = oldrecno;
	}
	return 0;
}

