/*
    Copyright (C) 2005  ITK
    Author  : Kornilova E.V. <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include <string.h>
#include <errno.h>
#include <expat.h>

#include "clip.h"
#include "screen/charset.h"

#include "hashxml.h"
#include "clip-expat.h"
#include "clip-expat.ch"


static ClipVar _xml_list;
static ClipVar *xml_list = &_xml_list;


CLIP_DLLEXPORT C_parser*
_list_get_cparser(ClipMachine * cm, void *pointer)
{
	double d;
	if (pointer && xml_list->t.type == MAP_t)
		if (_clip_mgetn(cm, xml_list, (long) pointer, &d) == 0)
			return (C_parser *) ((long) d);
	return NULL;
}

CLIP_DLLEXPORT void
_list_put_cparser(ClipMachine * cm, void *pointer, C_parser * cpar)
{
	if (xml_list->t.type != MAP_t)
		_clip_map(cm, xml_list);
	if (pointer)
		_clip_mputn(cm, xml_list, (long) pointer, (long) cpar);
}

CLIP_DLLEXPORT void
_list_remove_cparser(ClipMachine * cm, void * pointer)
{
	if (pointer && xml_list->t.type == MAP_t)
		_clip_mdel(cm, xml_list, (long) pointer);
}

CLIP_DLLEXPORT void
_destroy_c_parser(void *obj)
{
	C_parser * cpar = (C_parser *)obj;

	_list_remove_cparser(cpar->cmachine, cpar->parser);


	_clip_destroy(cpar->cmachine, cpar->userData);

	_clip_destroy(cpar->cmachine, &cpar->characterDataHandler);
	_clip_destroy(cpar->cmachine, &cpar->startElementHandler);
	_clip_destroy(cpar->cmachine, &cpar->endElementHandler);
	_clip_destroy(cpar->cmachine, &cpar->startCdataSectionHandler);
	_clip_destroy(cpar->cmachine, &cpar->endCdataSectionHandler);
	_clip_destroy(cpar->cmachine, &cpar->commentHandler);
	_clip_destroy(cpar->cmachine, &cpar->defaultHandler);

	_clip_destroy_c_item(cpar->cmachine, cpar->handle, _C_ITEM_TYPE_XML_PARSER);
	free(cpar);


}

CLIP_DLLEXPORT C_parser *
_register_parser(ClipMachine * cm, XML_Parser parser)
{
	int handle = -1;
	C_parser * cpar = (C_parser*)calloc(1,sizeof(C_parser));
	cpar->cmachine = cm;
    cpar->parser = parser;

	_clip_map(cm, &cpar->obj);

	/* Saving widget info into CLIP state machine
	 * and it`s handle to a map HANDLE property */
	handle = _clip_store_c_item(cm, cpar, _C_ITEM_TYPE_XML_PARSER, NULL);
	cpar->handle = handle;
	_clip_mputn(cm, &cpar->obj, HASH_HANDLE, handle);

	/* Store C_parser pointer in list of parsers */
	_list_put_cparser(cm, parser, cpar);

	return cpar;
}

CLIP_DLLEXPORT C_parser*
_fetch_c_arg(ClipMachine* cm)
{
	C_parser* cpar;

	if (_clip_parinfo(cm,1)==NUMERIC_t)
	{
		cpar = (C_parser*)_clip_fetch_c_item(cm,_clip_parni(cm,1),
			_C_ITEM_TYPE_XML_PARSER);
	}
	else
	{
		if (_clip_parinfo(cm,1)==MAP_t)
		{
			double h;
			_clip_mgetn(cm, _clip_spar(cm,1), HASH_HANDLE, &h);
			cpar = (C_parser *) _clip_fetch_c_item(cm, (int) h,
				_C_ITEM_TYPE_XML_PARSER);
		}
		else
		{
			_clip_trap_err(cm,EG_ARG,0,0,"CLIP_EXPAT",
				EG_ARG,"Bad parser descriptor");
			return NULL;
		}
	}
	if(!cpar)
	{
		_clip_trap_err(cm,EG_ARG,0,0,"CLIP_EXPAT",
			EG_ARG,"Bad parser descriptor");
		return NULL;
	}
	return cpar;
}

static int XMLCALL
unknownEncoding(void *encodingHandlerData,
		const XML_Char *name,
		XML_Encoding *info)
{
	int i,len1 = 0;
	cons_CharsetEntry *cs1 = 0;

	if (load_charset_name((char*) name, &cs1, &len1))
	{
		_clip_logg(2, "translate_charset: cannot load charset file '%s': %s", (char *)name, strerror(errno));
		return XML_STATUS_ERROR;
	}

	for(i=0; i<256; i++)
		info->map[i] = i;

	for (i = 0; i < len1; i++)
	{
		int ch;
		unsigned long unich;
		cons_CharsetEntry *cp;

		cp = cs1 + i;
		ch = cp->ch;
		unich = cp->unich;

		if (ch >= 256 || ch<0x80)
			continue;

		info->map[i] =	unich	;
	}
	free(cs1);

	for (i = 0; i < 32; i++)
		info->map[i] = i;


	info->data = 0;
	info->convert = 0;
	info->release = 0;

	return XML_STATUS_OK;
}


int
clip_XML_PARSERCREATE(ClipMachine *cm)
{
	char * encoding = _clip_parc(cm, 1);
	XML_Parser parser = NULL;
	C_parser *cpar;

	CHECKOPT(1,CHARACTER_t);

	parser = XML_ParserCreate((encoding?encoding:NULL));
    XML_SetUnknownEncodingHandler(parser, unknownEncoding, NULL);
    XML_SetParamEntityParsing(parser, XML_PARAM_ENTITY_PARSING_NEVER);
	cpar = _register_parser(cm, parser);

	_clip_mclone(cm,RETPTR(cm),&cpar->obj);

	return 0;
err:
	return 1;
}

int
clip_XML_PARSERFREE(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
    XML_Parser parser = cpar->parser;

	CHECKCPARSER(cpar);

	_destroy_c_parser(cpar);
	XML_ParserFree(parser);

	return 0;
err:
	return 1;
}

int
clip_XML_SETUSERDATA(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
    ClipVar *userData = _clip_par(cm, 2);

	CHECKCPARSER(cpar);

    cpar->userData = userData;

	XML_SetUserData(cpar->parser, cpar);

	return 0;
err:
	return 1;
}

int
clip_XML_SETPARAMENTITYPARSING(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
    int flag = _clip_parni(cm, 2);

	CHECKCPARSER(cpar);

	XML_SetParamEntityParsing(cpar->parser, flag);
	return 0;
err:
	return 1;
}

int
clip_XML_PARSE(ClipMachine *cm)
{
	C_parser  *cpar = _fetch_c_arg(cm);
    const char *str = _clip_parc(cm, 2);
    int         len = _clip_parni(cm, 3);
    int     isFinal = _clip_parl(cm, 4);

	CHECKCPARSER(cpar);
	CHECKARG(2, CHARACTER_t);
    CHECKARG(3, NUMERIC_t);
    CHECKARG(4, LOGICAL_t);

	_clip_retni(cm, (int)XML_Parse(cpar->parser, str, len, isFinal));

	return 0;
err:
	return 1;
}



int
clip_XML_GETERRORCODE(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);

	CHECKCPARSER(cpar);

    _clip_retni(cm,XML_GetErrorCode(cpar->parser));

    return 0;
err:
	return 1;
}
int
clip_XML_ERRORSTRING(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
	CHECKCPARSER(cpar);

    _clip_retc(cm,(char *) XML_ErrorString(XML_GetErrorCode(cpar->parser)));
    return 0;
err:
	return 1;
}

int
clip_XML_GETCURRENTBYTEINDEX(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
	CHECKCPARSER(cpar);

    _clip_retni(cm,XML_GetCurrentByteIndex(cpar->parser));
    return 0;
err:
	return 1;
}

int
clip_XML_GETCURRENTLINENUMBER(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
	CHECKCPARSER(cpar);

    _clip_retni(cm,XML_GetCurrentLineNumber(cpar->parser));
    return 0;
err:
	return 1;
}

int
clip_XML_GETCURRENTCOLUMNNUMBER(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
	CHECKCPARSER(cpar);

    _clip_retni(cm,XML_GetCurrentColumnNumber(cpar->parser));
    return 0;
err:
	return 1;
}

static int
_character_data_handler(void * userData, const XML_Char * s, int len)
{
	C_parser *cud = (C_parser *)userData;
    ClipVar str;
    ClipVar n;
    ClipVar stack[3], *app, *nv = 0;
	ClipVar res;
    int ret=1;
    unsigned l=0;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
    memset(&res, 0, sizeof(ClipVar));
    memset(&str, 0, sizeof(ClipVar));
    memset(&n, 0, sizeof(ClipVar));
    _clip_var_str(s, len, &str);

    n.t.type = NUMERIC_t;
    n.n.d = len;

	app = cud->userData;
	if (!(app->t.flags & F_MREF))
	{
		l =1;
		nv = NEW(ClipVar);

		*nv = *app;

		nv->t.count = 2;
		app->t.flags = F_MREF;
		app->p.vp = nv;
		app->t.field = 0;
		app->p.fp = 0;

	}

	stack[0] = *app;
	_clip_mclone(cud->cmachine, &stack[1], &str);
	_clip_mclone(cud->cmachine, &stack[2], &n);

	if ( _clip_eval( cud->cmachine, &(cud->characterDataHandler), 3, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;

	_clip_destroy(cud->cmachine, &res);

	if (l)
		--(nv->t.count);

	_clip_destroy(cud->cmachine, &stack[1]);
	_clip_destroy(cud->cmachine, &stack[2]);

	_clip_destroy(cud->cmachine, &str);
	_clip_destroy(cud->cmachine, &n);

	return ret;
}

int
clip_XML_SETCHARACTERDATAHANDLER(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
    ClipVar  *func = _clip_spar(cm, 2);

	CHECKCPARSER(cpar);
    CHECKARG2(2, PCODE_t, CCODE_t);

	_clip_mclone(cm, &cpar->characterDataHandler, func);
    XML_SetCharacterDataHandler(cpar->parser, (XML_CharacterDataHandler)_character_data_handler);

    return 0;
err:
	return 1;
}


static int
_start_element_handler(void * userData, const XML_Char * name, const XML_Char ** attrs)
{
	C_parser *cud = (C_parser *)userData;
    ClipVar str;
    ClipVar *eattr, *item;
    ClipVar stack[3], *app, *nv = 0;
	ClipVar res;
    int ret=1, i, j;
    unsigned l=0;
    long vect[2];

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
    memset(&str, 0, sizeof(ClipVar));
    eattr = malloc(sizeof(ClipVar));
    _clip_var_str(name, strlen(name), &str);

	vect[0] = 0;
    vect[1] = 0;
	_clip_array(cud->cmachine, eattr, 1, vect);
	for(i=0, j=0; attrs[i]; i+=2, j++)
    {
	ClipVar var;
	item = malloc(sizeof(ClipVar));

		vect[0] = 2;
	_clip_array(cud->cmachine, item, 1, vect);
	vect[0] = j+1;
	_clip_asize(cud->cmachine, eattr, 1, vect);
	vect[0] = j;
	_clip_aset(cud->cmachine, eattr, item, 1, vect);

	memset(&var, 0, sizeof(var));
	var.t.type = CHARACTER_t;
	var.s.str.buf = (char *)attrs[i];
	var.s.str.len = strlen(attrs[i]);
	vect[1] = 0;
	_clip_aset(cud->cmachine, eattr, &var, 2, vect);

	memset(&var, 0, sizeof(var));
	var.t.type = CHARACTER_t;
	var.s.str.buf = (char *)attrs[i+1];
	var.s.str.len = strlen(attrs[i+1]);
	vect[1] = 1;
	_clip_aset(cud->cmachine, eattr, &var, 2, vect);

		_clip_destroy(cud->cmachine, item);
	free(item);

    }

	app = cud->userData;
	if (!(app->t.flags & F_MREF))
	{
		l =1;
		nv = NEW(ClipVar);

		*nv = *app;

		nv->t.count = 2;
		app->t.flags = F_MREF /*mptr?F_MPTR:F_MREF */ ;
		app->p.vp = nv;
		app->t.field = 0;
		app->p.fp = 0;

	}
	stack[0] = *app;
	_clip_mclone(cud->cmachine, &stack[1], &str);
	_clip_mclone(cud->cmachine, &stack[2], eattr);

	if ( _clip_eval( cud->cmachine, &(cud->startElementHandler), 3, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;

	_clip_destroy(cud->cmachine, &res);

	if (l)
	   --(nv->t.count);

	_clip_destroy(cud->cmachine, &stack[1]);
	_clip_destroy(cud->cmachine, &stack[2]);

	_clip_destroy(cud->cmachine, &str);
    _clip_destroy(cud->cmachine, eattr);
    free(eattr);
	return ret;
}

int
clip_XML_SETSTARTELEMENTHANDLER(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
    ClipVar  *func = _clip_spar(cm, 2);

	CHECKCPARSER(cpar);
    CHECKARG2(2, PCODE_t, CCODE_t);

	_clip_mclone(cm, &cpar->startElementHandler, func);
    XML_SetStartElementHandler(cpar->parser, (XML_StartElementHandler)_start_element_handler);

    return 0;
err:
	return 1;
}

static int
_end_element_handler(void * userData, const XML_Char * name)
{
	C_parser *cud = (C_parser *)userData;
    ClipVar str;
    ClipVar stack[2], *app, *nv = 0;
	ClipVar res;
    int ret=1;
    unsigned l=0;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
    memset(&str, 0, sizeof(ClipVar));
    _clip_var_str(name, strlen(name), &str);

	app = cud->userData;
	if (!(app->t.flags & F_MREF))
	{
		l =1;
		nv = NEW(ClipVar);

		*nv = *app;

		nv->t.count = 2;
		app->t.flags = F_MREF /*mptr?F_MPTR:F_MREF */ ;
		app->p.vp = nv;
		app->t.field = 0;
		app->p.fp = 0;

	}
	stack[0] = *app;
	_clip_mclone(cud->cmachine, &stack[1], &str);

	if ( _clip_eval( cud->cmachine, &(cud->endElementHandler), 2, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;

	_clip_destroy(cud->cmachine, &res);

	if (l)
	   --(nv->t.count);

	_clip_destroy(cud->cmachine, &stack[1]);

	_clip_destroy(cud->cmachine, &str);
	return ret;
}

int
clip_XML_SETENDELEMENTHANDLER(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
    ClipVar  *func = _clip_spar(cm, 2);

	CHECKCPARSER(cpar);
    CHECKARG2(2, PCODE_t, CCODE_t);

	_clip_mclone(cm, &cpar->endElementHandler, func);
    XML_SetEndElementHandler(cpar->parser, (XML_EndElementHandler)_end_element_handler);

    return 0;
err:
	return 1;
}

int
clip_XML_SETELEMENTHANDLER(ClipMachine *cm)
{
	C_parser  *cpar = _fetch_c_arg(cm);
    ClipVar  *sfunc = _clip_spar(cm, 2);
    ClipVar  *efunc = _clip_spar(cm, 3);

	CHECKCPARSER(cpar);
    CHECKARG2(2, PCODE_t, CCODE_t);
    CHECKARG2(3, PCODE_t, CCODE_t);

	_clip_mclone(cm, &cpar->startElementHandler, sfunc);
	_clip_mclone(cm, &cpar->endElementHandler, efunc);
    XML_SetElementHandler(cpar->parser, (XML_StartElementHandler)_start_element_handler, (XML_EndElementHandler)_end_element_handler);

    return 0;
err:
	return 1;
}

static int
_comment_handler(void * userData, const XML_Char * data)
{
	C_parser *cud = (C_parser *)userData;
    ClipVar str;
    ClipVar stack[2], *app, *nv = 0;
	ClipVar res;
    int ret=1;
    unsigned l=0;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
    memset(&str, 0, sizeof(ClipVar));
    _clip_var_str(data, strlen(data), &str);

	app = cud->userData;
	if (!(app->t.flags & F_MREF))
	{
		l =1;
		nv = NEW(ClipVar);

		*nv = *app;

		nv->t.count = 2;
		app->t.flags = F_MREF /*mptr?F_MPTR:F_MREF */ ;
		app->p.vp = nv;
		app->t.field = 0;
		app->p.fp = 0;

	}
	stack[0] = *app;
	_clip_mclone(cud->cmachine, &stack[1], &str);

	if ( _clip_eval( cud->cmachine, &(cud->commentHandler), 2, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;

	_clip_destroy(cud->cmachine, &res);

	if (l)
	   --(nv->t.count);

	_clip_destroy(cud->cmachine, &stack[1]);

	_clip_destroy(cud->cmachine, &str);
	return ret;
}

int
clip_XML_SETCOMMENTHANDLER(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
    ClipVar  *func = _clip_spar(cm, 2);

	CHECKCPARSER(cpar);
    CHECKARG2(2, PCODE_t, CCODE_t);

	_clip_mclone(cm, &cpar->commentHandler, func);
    XML_SetCommentHandler(cpar->parser, (XML_CommentHandler)_comment_handler);

    return 0;
err:
	return 1;
}


static int
_start_cdata_section_handler(void * userData)
{
	C_parser *cud = (C_parser *)userData;
    ClipVar stack[1], *app, *nv = 0;
	ClipVar res;
    int ret=1;
    unsigned l=0;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );

	app = cud->userData;
	if (!(app->t.flags & F_MREF))
	{
		l =1;
		nv = NEW(ClipVar);

		*nv = *app;

		nv->t.count = 2;
		app->t.flags = F_MREF /*mptr?F_MPTR:F_MREF */ ;
		app->p.vp = nv;
		app->t.field = 0;
		app->p.fp = 0;

	}
	stack[0] = *app;

	if ( _clip_eval( cud->cmachine, &(cud->startCdataSectionHandler), 1, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;

	_clip_destroy(cud->cmachine, &res);

	if (l)
	   --(nv->t.count);

	return ret;
}

int
clip_XML_SETSTARTCDATASECTIONHANDLER(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
    ClipVar  *func = _clip_spar(cm, 2);

	CHECKCPARSER(cpar);
    CHECKARG2(2, PCODE_t, CCODE_t);

	_clip_mclone(cm, &cpar->startCdataSectionHandler, func);
    XML_SetStartCdataSectionHandler(cpar->parser, (XML_StartCdataSectionHandler)_start_cdata_section_handler);

    return 0;
err:
	return 1;
}


static int
_end_cdata_section_handler(void * userData)
{
	C_parser *cud = (C_parser *)userData;
    ClipVar stack[1], *app, *nv = 0;
	ClipVar res;
    int ret=1;
    unsigned l=0;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );

	app = cud->userData;
	if (!(app->t.flags & F_MREF))
	{
		l =1;
		nv = NEW(ClipVar);

		*nv = *app;

		nv->t.count = 2;
		app->t.flags = F_MREF /*mptr?F_MPTR:F_MREF */ ;
		app->p.vp = nv;
		app->t.field = 0;
		app->p.fp = 0;

	}
	stack[0] = *app;

	if ( _clip_eval( cud->cmachine, &(cud->endCdataSectionHandler), 1, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;

	_clip_destroy(cud->cmachine, &res);

	if (l)
	   --(nv->t.count);

	return ret;
}

int
clip_XML_SETENDCDATASECTIONHANDLER(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
    ClipVar  *func = _clip_spar(cm, 2);

	CHECKCPARSER(cpar);
    CHECKARG2(2, PCODE_t, CCODE_t);

	_clip_mclone(cm, &cpar->endCdataSectionHandler, func);
    XML_SetEndCdataSectionHandler(cpar->parser, (XML_EndCdataSectionHandler)_end_cdata_section_handler);

    return 0;
err:
	return 1;
}


int
clip_XML_SETCDATASECTIONHANDLER(ClipMachine *cm)
{
	C_parser  *cpar = _fetch_c_arg(cm);
    ClipVar  *sfunc = _clip_spar(cm, 2);
    ClipVar  *efunc = _clip_spar(cm, 3);

	CHECKCPARSER(cpar);
    CHECKARG2(2, PCODE_t, CCODE_t);
    CHECKARG2(3, PCODE_t, CCODE_t);

	_clip_mclone(cm, &cpar->startCdataSectionHandler, sfunc);
	_clip_mclone(cm, &cpar->endCdataSectionHandler, efunc);
    XML_SetCdataSectionHandler(cpar->parser, (XML_StartCdataSectionHandler)_start_cdata_section_handler, (XML_EndCdataSectionHandler)_end_cdata_section_handler);

    return 0;
err:
	return 1;
}

static int
_default_handler(void * userData, const XML_Char * s, int len)
{
	C_parser *cud = (C_parser *)userData;
    ClipVar str;
    ClipVar n;
    ClipVar stack[3], *app, *nv = 0;
	ClipVar res;
    int ret=1;
    unsigned l=0;

	memset(&stack,0,sizeof(stack)); memset( &res, 0, sizeof(ClipVar) );
    memset(&str, 0, sizeof(ClipVar));
    memset(&n, 0, sizeof(ClipVar));
    _clip_var_str(s, len, &str);

    n.t.type = NUMERIC_t;
    n.n.d = len;

	app = cud->userData;
	if (!(app->t.flags & F_MREF))
	{
		l =1;
		nv = NEW(ClipVar);

		*nv = *app;

		nv->t.count = 2;
		app->t.flags = F_MREF /*mptr?F_MPTR:F_MREF */ ;
		app->p.vp = nv;
		app->t.field = 0;
		app->p.fp = 0;

	}
	stack[0] = *app;
	_clip_mclone(cud->cmachine, &stack[1], &str);
	_clip_mclone(cud->cmachine, &stack[2], &n);

	if ( _clip_eval( cud->cmachine, &(cud->defaultHandler), 3, stack, &res ) == 0 )
		ret = res.t.type == LOGICAL_t ? res.l.val : ret;

	_clip_destroy(cud->cmachine, &res);

	if (l)
	   --(nv->t.count);

	_clip_destroy(cud->cmachine, &stack[1]);
	_clip_destroy(cud->cmachine, &stack[2]);

	_clip_destroy(cud->cmachine, &str);
	_clip_destroy(cud->cmachine, &n);
	return ret;
}

int
clip_XML_SETDEFAULTHANDLER(ClipMachine *cm)
{
	C_parser *cpar = _fetch_c_arg(cm);
    ClipVar  *func = _clip_spar(cm, 2);

	CHECKCPARSER(cpar);
    CHECKARG2(2, PCODE_t, CCODE_t);

	_clip_mclone(cm, &cpar->defaultHandler, func);
    XML_SetDefaultHandler(cpar->parser, (XML_DefaultHandler)_default_handler);

    return 0;
err:
	return 1;
}

