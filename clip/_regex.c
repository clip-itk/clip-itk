/*
    Copyright (C) 2001  ITK
    Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include <string.h>
#include <sys/types.h>
#include <regex.h>

#include "clip.h"
#include "error.ch"

#define NEW(type)	((type*)calloc(sizeof(type),1))
#ifndef RE_NREGS
#define RE_NREGS	30
#endif

/*
   if found return registers: {start position, end position}
   reg:={}
   search("90 asdf 12 ", "[a-z]+", reg) -->
   reg={{4, 8}}
*/
int
clip_SEARCH(ClipMachine * mp)
{
	int c, sl, length, i;
	unsigned char *s = _clip_parcl(mp, 1, &sl);	/* pattern */
	unsigned char *string = _clip_parcl(mp, 2, &length);	/* string */
	unsigned char *str, *buf;
	int start = _clip_parni(mp, 4) - 1;	/*from (start position) */
	int range = _clip_parni(mp, 5) - 1;	/*range */
	ClipVar *rg = _clip_par(mp, 3);		/*registers */

	regex_t preg;
	regmatch_t rmatch[RE_NREGS];

	if (s == NULL || string == NULL)
	{
		_clip_retl(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "SEARCH");
	}
	if (_clip_parinfo(mp, 0) < 4)
		start = 0;
	if (_clip_parinfo(mp, 0) < 5)
		range = length;
	if (range < 0)
		start += range + 1;
	if (start < 0)
		start = 0;
	range = abs(range) < length ? abs(range) : length;

	str = (char *) malloc(range + 1);
	memcpy(str, string + start, range);
	str[range] = 0;

	buf = (char *) malloc(sl + 1);
	memcpy(buf, s, sl);
	buf[sl] = 0;

	for(i=0; i<sl; i++, s++)
	{
		if ((*s) > 127)
			buf[i] = _clip_cmptbl[(*s)];
	}
	for(i=0; i<range; i++, string++)
	{
		if (*(string+start) > 127)
			str[i] = _clip_cmptbl[*(string+start)];

	}
	memset(&preg, 0, sizeof(preg));

	regcomp(&preg, buf, REG_EXTENDED | (buf[0]=='^'?REG_NEWLINE:0));

	if (regexec(&preg, str, RE_NREGS, rmatch, 0/*REG_NOTBOL*/) == 0)
	{
		int j;

		for (j = 0; j < RE_NREGS; j++)
		{

			ClipVar *st;
			ClipVar *ed;
			ClipVar *el;

			if ((_clip_parinfo(mp, 0) < 3) || rmatch[j].rm_so == -1)
				break;

			st = NEW(ClipVar);
			ed = NEW(ClipVar);
			el = NEW(ClipVar);

			el->t.type = ARRAY_t;
			el->t.flags = F_NONE;

			st->t.type = NUMERIC_t;
			st->t.flags = F_NONE;
			st->t.memo = 0;
			st->n.d = rmatch[j].rm_so + 1 + start;

			c = ++el->a.count;
			el->a.items = (ClipVar *) realloc(el->a.items, sizeof(ClipVar) * c);
			memset(el->a.items + c - 1, 0, sizeof(ClipVar));
			_clip_clone(mp, el->a.items + c - 1, st);

			ed->t.type = NUMERIC_t;
			ed->t.flags = F_NONE;
			ed->t.memo = 0;
			ed->n.d = rmatch[j].rm_eo + 1 + start;

			c = ++el->a.count;
			el->a.items = (ClipVar *) realloc(el->a.items, sizeof(ClipVar) * c);
			memset(el->a.items + c - 1, 0, sizeof(ClipVar));
			_clip_clone(mp, el->a.items + c - 1, ed);
			c = ++rg->a.count;
			rg->a.items = (ClipVar *) realloc(rg->a.items, sizeof(ClipVar) * c);
			memset(rg->a.items + c - 1, 0, sizeof(ClipVar));
			_clip_dup(mp, rg->a.items + c - 1, el);

			_clip_delete(mp, st);
			_clip_delete(mp, ed);
			_clip_delete(mp, el);

		}
		if (_clip_parinfo(mp, 0) > 2)
			_clip_clone(mp, RETPTR(mp), rg);

		_clip_retl(mp, 1);

	}
	else
		_clip_retl(mp, 0);
	regfree(&preg);
	free(str);
	free(buf);
	return 0;
}

void
destroy_c_regex(void *item)
{
	regex_t *preg = (regex_t *)item;

	regfree(preg);
	free(preg);
}

int
clip_RGCOMP(ClipMachine * mp)
{
	int ret, sl, rc, i;
	unsigned char *s = _clip_parcl(mp, 1, &sl);	/* pattern */
	unsigned char *buf;
	regex_t *preg = NULL;

	if (s == NULL)
	{
		_clip_retl(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "RGCOMP");
	}
	preg = (regex_t*)malloc( sizeof(regex_t));

	buf = (char *) malloc(sl + 1);
	memcpy(buf, s, sl);
	buf[sl] = 0;

	for(i=0; i<sl; i++, s++)
	{
		if ((*s) > 127)
			buf[i] = _clip_cmptbl[(*s)];
	}
	rc = regcomp(preg, buf, REG_EXTENDED | (buf[0]=='^'?REG_NEWLINE:0));

	ret = _clip_store_c_item(mp, preg, _C_ITEM_TYPE_REGEX, destroy_c_regex);
	_clip_retni(mp, ret);
	free(buf);

	return 0;
}

int
clip_RGEXEC(ClipMachine * mp)
{
	int c, length, i;
	int item = _clip_parni(mp, 1);		/* container pattern */
	unsigned char *string = _clip_parcl(mp, 2, &length);	/* string */
	unsigned char *str;
	int start = _clip_parni(mp, 4) - 1;	/*from (start position) */
	int range = _clip_parni(mp, 5) - 1;	/*range */
	int rerr;
	ClipVar *rg = _clip_par(mp, 3);		/*registers */

	regex_t *preg = NULL;
	regmatch_t rmatch[RE_NREGS];

	if (string == NULL)
	{
		_clip_retl(mp, 0);
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "SEARCH");
	}
	if (_clip_parinfo(mp, 0) < 4)
		start = 0;
	if (_clip_parinfo(mp, 0) < 5)
		range = length;
	if (range < 0)
		start += range + 1;
	if (start < 0)
		start = 0;
	range = abs(range) < length ? abs(range) : length;

	str = (char *) malloc(range + 1);
	memcpy(str, string + start, range);
	str[range] = 0;

	for(i=0; i<=abs(range)-start; i++, string++)
	{
		if (*(string+start) > 127)
			str[i] = _clip_cmptbl[*(string+start)];

	}

	preg = (regex_t *) _clip_fetch_c_item(mp, item, _C_ITEM_TYPE_REGEX);
	rerr = regexec(preg, str, RE_NREGS, rmatch, 0);
	if ( rerr == 0)
	{
		int j;

		for (j = 0; j < RE_NREGS; j++)
		{

			ClipVar *st;
			ClipVar *ed;
			ClipVar *el;

			if ((_clip_parinfo(mp, 0) < 3) || rmatch[j].rm_so == -1)
				break;

			st = NEW(ClipVar);
			ed = NEW(ClipVar);
			el = NEW(ClipVar);

			el->t.type = ARRAY_t;
			el->t.flags = F_NONE;

			st->t.type = NUMERIC_t;
			st->t.flags = F_NONE;
			st->t.memo = 0;
			st->n.d = rmatch[j].rm_so + 1 + start;

			c = ++el->a.count;
			el->a.items = (ClipVar *) realloc(el->a.items, sizeof(ClipVar) * c);
			memset(el->a.items + c - 1, 0, sizeof(ClipVar));
			_clip_clone(mp, el->a.items + c - 1, st);

			ed->t.type = NUMERIC_t;
			ed->t.flags = F_NONE;
			ed->t.memo = 0;
			ed->n.d = rmatch[j].rm_eo + 1 + start;

			c = ++el->a.count;
			el->a.items = (ClipVar *) realloc(el->a.items, sizeof(ClipVar) * c);
			memset(el->a.items + c - 1, 0, sizeof(ClipVar));
			_clip_clone(mp, el->a.items + c - 1, ed);
			c = ++rg->a.count;
			rg->a.items = (ClipVar *) realloc(rg->a.items, sizeof(ClipVar) * c);
			memset(rg->a.items + c - 1, 0, sizeof(ClipVar));
			_clip_dup(mp, rg->a.items + c - 1, el);

			_clip_delete(mp, st);
			_clip_delete(mp, ed);
			_clip_delete(mp, el);

		}
		if (_clip_parinfo(mp, 0) > 2)
			_clip_clone(mp, RETPTR(mp), rg);

		_clip_retl(mp, 1);

	}
	else
	{
		 regerror(rerr, preg, str, range);
		 _clip_retl(mp, 0);
	}
	free(str);
	return 0;
}

int
clip_RGCANCEL(ClipMachine * mp)
{
	int item = _clip_parni(mp, 1);		/* container pattern */
	_clip_destroy_c_item(mp, item, _C_ITEM_TYPE_REGEX);
	return 0;
}

