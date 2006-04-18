#ifndef _CLIP_EXPAT_
#define _CLIP_EXPAT_

#include <expat.h>
#include <clip.h>
#include <error.ch>

typedef struct _C_parser 	C_parser;

typedef struct _C_parser
{
	XML_Parser  parser;
    ClipVar     obj;
	ClipMachine *cmachine;
	ClipVar     *userData;
	int         handle;
	void        *data;
	ClipVar characterDataHandler; /* start function */
	ClipVar startElementHandler;  /* start function */
	ClipVar endElementHandler;    /* end function */
	ClipVar commentHandler;       /* start function */
	ClipVar startCdataSectionHandler;       /* start function */
	ClipVar endCdataSectionHandler;         /* end function */
	ClipVar defaultHandler;       /* start function */
} _C_parser;


#define NEW(type) ((type*)calloc(sizeof(type),1))

C_parser *_fetch_c_arg(ClipMachine* cm);
C_parser *_register_parser(ClipMachine * cm, XML_Parser parser);
C_parser *_list_get_cparser(ClipMachine * cm, void *pointer);
void _list_put_cparser(ClipMachine * cm, void *pointer, C_parser * cpar);
void _list_remove_cparser(ClipMachine * cm, void * pointer);

#define CHECKCPARSER(cpar) \
  if(!cpar || !cpar->parser) { \
    char err[100]; \
    sprintf(err,"No parser object"); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_EXPAT",EG_NOPARSER,err); \
    goto err; \
    }


#define CHECKARG(n,t) \
  if((_clip_parinfo(cm,n)!=t)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" type",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_EXPAT",EG_ARG,err); \
    goto err; \
    }

#define CHECKARG2(n,t,t2) \
  if((_clip_parinfo(cm,n)!=t) && (_clip_parinfo(cm,n)!=t2)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" or "#t2" type",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_EXPAT",EG_ARG,err); \
    goto err; \
    }

#define CHECKOPT(n,t) \
  if((_clip_parinfo(cm,n)!=t)&&(_clip_parinfo(cm,n)!=UNDEF_t)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" type or NIL",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_EXPAT",EG_ARG,err); \
    goto err; \
    }

#define CHECKOPT2(n,t,t2) \
  if((_clip_parinfo(cm,n)!=t)&&(_clip_parinfo(cm,n)!=t2)&&(_clip_parinfo(cm,n)!=UNDEF_t)){ \
    char err[100]; \
    sprintf(err,"Bad argument (%d), must be a "#t" or "#t2" type or NIL",n); \
    _clip_trap_err(cm,EG_ARG,0,0,"CLIP_EXPAT",EG_ARG,err); \
    goto err; \
    }

#endif
