/*
 * $Log: clicutil.c,v $
 * Revision 1.43  2004/11/17 12:42:43  clip
 * uri: small fix for '-a' compiler switch
 *
 * Revision 1.42  2003/05/16 11:08:02  clip
 * initial support for using assembler instead C
 * now activated if environment variable CLIP_ASM is defined to any value
 * paul
 *
 * Revision 1.41  2003/03/25 14:20:59  clip
 * uri: *gettext changed to _clic_*gettext
 *
 * Revision 1.40  2002/11/19 11:32:35  clip
 * fix sigsegv on var redefinition
 * closes #52
 * paul
 *
 * Revision 1.39  2002/10/30 12:17:26  clip
 * support for plural forms in i18n messages
 * paul
 *
 * Revision 1.38  2002/10/28 08:22:30  clip
 * done russian translation for clip.po
 * paul
 *
 * Revision 1.37  2002/10/25 11:54:33  clip
 * localized messages for clip itself
 * paul
 *
 * Revision 1.36  2002/08/08 09:49:27  clip
 * -a flag cleanup
 * paul
 *
 * Revision 1.35  2002/08/07 12:08:06  clip
 * fix for -a flag
 * paul
 *
 * Revision 1.34  2002/07/30 08:30:31  clip
 * full path in .prg names
 * paul
 *
 * Revision 1.33  2002/02/06 12:37:33  clip
 * sigsegv
 * paul
 *
 * Revision 1.32  2002/01/18 09:47:10  clip
 * -d<outdir>, --outdir=<outdir> option
 * -o<oname> work correct
 * fw install fix
 * paul
 *
 * Revision 1.31  2002/01/05 12:50:48  clip
 * LOCAL a,b AS typename
 * STATIC a,b AS typename
 * func( a AS typename, b)
 * recognized, but yet not used
 * paul
 *
 * Revision 1.30  2001/12/29 12:45:30  clip
 * fix
 * paul
 *
 * Revision 1.29  2001/12/25 07:39:39  clip
 * field/memvar/private/public declarations visible in codeblocks
 * paul
 *
 * Revision 1.28  2001/12/18 09:42:41  clip
 * memvar/private declarations may be mixed
 * paul
 *
 * Revision 1.27  2001/12/10 14:07:02  clip
 * MEMVAR and FIELD declarations on file level
 * will be used inside the functions
 * paul
 *
 * Revision 1.26  2001/10/02 08:38:29  clip
 * macro from parameters in CODESTR blocks
 * paul
 *
 * Revision 1.25  2001/09/21 09:53:24  clip
 * charsets handling
 * paul
 *
 * Revision 1.24  2001/09/05 05:30:26  clip
 * CODEBLOCK/CODESTR now can have paramters, f.e:
 * CODESTR(|a| f->first==a) will generate string
 * {|A|FIELD->FIRST==A}
 * paul
 *
 * Revision 1.23  2001/08/26 09:10:06  clip
 * references
 * paul
 *
 * Revision 1.22  2001/08/24 14:38:46  clip
 * CODESTR pseudofunction
 * paul
 *
 * Revision 1.21  2001/08/23 13:52:06  clip
 * merge with NEWLOCALS
 * paul
 *
 * Revision 1.20.2.9  2001/08/23 11:38:06  clip
 * paramters in block
 * paul
 *
 * Revision 1.20.2.8  2001/08/21 13:00:37  clip
 * fix
 * paul
 *
 * Revision 1.20.2.7  2001/08/21 12:10:35  clip
 * local init in codeblock, f.e.:
 *
 * local a:={1,2,3}
 * cb:={|x|local(b:=a[2]),iif(x==NIL,b,b:=x)}
 * ? eval(cb)
 * ? a
 * ? eval(cb,'dddd')
 * ? a
 * ?
 *
 * paul
 *
 * Revision 1.20.2.6  2001/08/20 10:43:09  clip
 * macro in blocks
 * paul
 *
 * Revision 1.20.2.5  2001/08/16 15:35:24  clip
 * fix
 * paul
 *
 * Revision 1.20.2.4  2001/08/16 14:59:16  clip
 * fix
 * paul
 *
 * Revision 1.20.2.3  2001/08/16 14:50:19  clip
 * fix
 * paul
 *
 * Revision 1.20.2.2  2001/08/16 09:46:38  clip
 * params
 * paul
 *
 * Revision 1.20.2.1  2001/08/03 12:07:59  clip
 * NEWLOCALS initial
 * paul
 *
 * Revision 1.20  2001/04/11 06:49:02  clip
 * main.prg
 * paul
 *
 * Revision 1.19  2001/02/06 13:07:24  clip
 * hash in .po, dbg
 * paul
 *
 * Revision 1.18  2000/11/22 06:58:21  clip
 * -l fix
 * paul
 *
 * Revision 1.17  2000/11/21 13:25:08  clip
 * -l
 * paul
 *
 * Revision 1.16  2000/10/31 12:21:45  clip
 * приоритет видимости параметров перед локальными переменных в блоках
 * paul
 *
 * Revision 1.15  2000/05/25 17:34:31  clip
 * grow_buf bug
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.14  2000/05/25 16:48:59  clip
 * __field__ in rt.y
 * absolute paths in #include
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.13  2000/05/24 18:34:06  clip
 * _clip_push_area
 * indents all
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.12  2000/04/15 20:57:32  paul
 * mandrake fixes
 *
 * Revision 1.11  2000/04/07 19:46:56  paul
 * aflag
 *
 * Revision 1.10  2000/04/07 18:45:29  paul
 * -a
 *
 * Revision 1.9  2000/04/07 18:23:15  paul
 * -a flag
 *
 * Revision 1.8  2000/03/17 17:38:28  paul
 * private/filed scopey
 *
 * Revision 1.7  2000/03/03 21:37:34  paul
 * preprocessor bug fix, warnings removed
 *
 * Revision 1.6  1999/12/28 22:03:01  serg
 * *** empty log message ***
 *
 * Revision 1.5  1999/10/27 20:01:03  paul
 * gluk in param & local initalization
 *
 * Revision 1.4  1999/10/27 18:13:30  paul
 * __self_ bug
 *
 * Revision 1.3  1999/10/27 18:05:10  paul
 * __SELF__ fix
 *
 * Revision 1.2  1999/10/27 17:29:30  paul
 * change param handling
 *
 * Revision 1.1  1999/10/25 16:39:27  paul
 * first entry
 *
 */

#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "clic.h"
#include "clic.tab.h"
#include "nodepriv.h"

/* [ vars */

char *clic_outpath = 0;

static int compare_Function(void *k1, void *k2);

/* ] vars */
/* [ util */

int v_neednl = 0;

int
v_printf(int level, const char *fmt,...)
{
	va_list ap;
	int ret = 0;

	if (level > verbose)
		return 0;

	for(; v_neednl; v_neednl--)
		fputc('\n', stdout);

	va_start(ap, fmt);
	ret = vfprintf(stdout, _clic_gettext(fmt), ap);
	va_end(ap);
	fflush(stdout);

	return ret;
}

int
vr_printf(int level, const char *fmt,...)
{
	va_list ap;
	int ret = 0;

	if (level > verbose)
		return 0;

	for(; v_neednl; v_neednl--)
		fputc('\n', stdout);

	va_start(ap, fmt);
	ret = vfprintf(stdout, fmt, ap);
	va_end(ap);
	fflush(stdout);

	return ret;
}

void
printString(FILE * stream, const char *str)
{
	const unsigned char *s;

	fputc('\"', stream);
	for (s = (unsigned char *) str; *s; s++)
		switch (*s)
		{
		case '"':
			fputc('\\', stream);
			fputc('"', stream);
			break;
		case '\n':
			fputc('\\', stream);
			fputc('n', stream);
			break;
		case '\t':
			fputc('\\', stream);
			fputc('t', stream);
			break;
		case '\v':
			fputc('\\', stream);
			fputc('v', stream);
			break;
		case '\b':
			fputc('\\', stream);
			fputc('b', stream);
			break;
		case '\r':
			fputc('\\', stream);
			fputc('r', stream);
			break;
		case '\f':
			fputc('\\', stream);
			fputc('f', stream);
			break;
		case '\\':
			fputc('\\', stream);
			fputc('\\', stream);
			break;

		default:
			if (*s >= 32)
				fputc(*s, stream);
			else
				fprintf(stream, "\\%03o", *s);
			break;
		}
	fputc('\"', stream);
}

void
assign_String(char **oldstr, char *newstr)
{
	if (*oldstr)
		free(*oldstr);
	*oldstr = newstr;
}

void
assign_constString(char **oldstr, const char *newstr)
{
	if (*oldstr)
		free(*oldstr);
	*oldstr = strdup(newstr);
}

int
haveMacro(char *str)
{
	char *s;

	for (s = str; *s; ++s)
		if (*s == '&')
			return 1;
	return 0;
}

/* ] ConstStruct */
/* [ Var */

Var *
new_Var(char *name)
{
	char *s;

	NEWVAR(Var, ret);
	for(s=name; (*s); s++)
		*s = toupper(*s);
	ret->name = name;
	ret->no = -1;
	ret->line = cl_line;
	ret->pos = clic_pos;
	ret->file = currentFile();
	ret->func = curFunction;
	return ret;
}

Var *
newInit_Var(char *name, Node * expr)
{
	Var *ret = new_Var(name);

	ret->init = expr;
	return ret;
}

static char *
macro_name(void)
{
	static int no = 0;
	char name[32];

	snprintf(name, sizeof(name), "macro_%d", no++);
	return strdup(name);
}

Var *
mnew_Var(Node * macro)
{
	Var *ret = new_Var(macro_name());

	ret->macro = macro;
	return ret;
}

Var *
mnewInit_Var(Node * macro, struct Node * expr)
{
	Var *ret = newInit_Var(macro_name(), expr);

	ret->macro = macro;
	return ret;
}

Var *
mnewArr_Var(Node * macro, Coll * arr)
{
	Var *ret = newArr_Var(macro_name(), arr);

	ret->macro = macro;
	return ret;
}

Var *
newArr_Var(char *name, Coll * arr)
{
	Var *ret = new_Var(name);

	ret->arr = arr;
	return ret;
}

void
delete_Var(void *item)
{
	VAR(Var, vp, item);
	if (!item)
		return;
	if (vp->arr)
		delete_Coll(vp->arr);
	if (vp->alias)
		free(vp->alias);
	free(vp->name);
	free(item);
}

static int
compare_Var(void *k1, void *k2)
{
	VAR(Var, v1, k1);
	VAR(Var, v2, k2);
	return strcasecmp(v1->name, v2->name);
}

VarColl *
new_VarColl()
{
	NEWVAR(VarColl, ret);
	init_Coll(&ret->coll, delete_Var, compare_Var);
	init_Coll(&ret->unsorted, 0, 0);
	return ret;
}

VarColl *
new_VarColl1(Var * vp)
{
	NEWVAR(VarColl, ret);
	init_Coll(&ret->coll, delete_Var, compare_Var);
	init_Coll(&ret->unsorted, 0, 0);
	add_VarColl(ret, vp);
	return ret;
}

void
delete_VarColl(VarColl * coll)
{
	if (!coll)
		return;
	destroy_Coll(&coll->coll);
	destroy_Coll(&coll->unsorted);
	free(coll);
}

int
search_VarColl(VarColl * coll, char *name, int *index)
{
	Var var;

	var.name = name;
	return search_Coll(&coll->coll, &var, index);
}

void
rm_VarColl(VarColl * coll, Var * var)
{
	int no;

	if (search_Coll(&coll->coll, var, &no))
	{
		/*VAR(Var, vp, coll->coll.items[no]); */
		atRemove_Coll(&coll->coll, no);
		/*remove_Coll(&coll->unsorted, vp); */
	}
}

void
insert_VarColl(VarColl * coll, Var * var)
{
	int no;

	if (!var)
		return;
	if (search_Coll(&coll->coll, var, &no))
	{
		return;
	}

	var->no = coll->coll.count;
	insert_Coll(&coll->coll, var);
	insert_Coll(&coll->unsorted, var);
}

void
add_VarColl(VarColl * coll, Var * var)
{
	int no;

	if (!var)
		return;
	if (search_Coll(&coll->coll, var, &no))
	{
		VAR(Var, vp, coll->coll.items[no]);
		yywarning( "duplicate name '%s', previous name defined near line %d pos %d in file '%s'", vp->name, vp->line, vp->pos, fileName(vp->file));
		#if 0
		remove_Coll(&coll->coll, vp);
		remove_Coll(&coll->unsorted, vp);
		delete_Var(vp);
		#endif
	}

	var->no = coll->coll.count;
	insert_Coll(&coll->coll, var);
	insert_Coll(&coll->unsorted, var);
}

/* ] Var */
/* [  File */

File *curFile = NULL;
Function *curFunction = NULL;
Function *mainFunction = NULL;
VarColl *curParams = NULL;
VarColl *curLocals = NULL;
VarColl *curStatics = NULL;
VarColl *fileStatics = NULL;
VarColl *curPublics = NULL;

Coll *modules = NULL;
Coll *fileModules = NULL;
Coll *fileIncludes = NULL;

File *
new_File(char *name)
{
	char buf[256], *s, *e, *suf;

	NEWVAR(File, ret);
	e = strrchr(name, '/');
	if (e)
		ret->name = strdup(e+1);
	else
		ret->name = strdup(name);
	ret->origname = strdup(name);
	if (name[0] == '/')
		strncpy(buf, name, sizeof(buf) - 3);
	else
		snprintf(buf, sizeof(buf)-3, "%s/%s", outdir, name);
	s = strrchr(buf, '.');
	e = strrchr(buf, '/');
	if (pc_flag)
	{
		if (asm_flag)
			suf = ".s";
		else
			suf = ".c";
	}
	else if (pcode_flag)
		suf = ".po";
	else
		suf = ".c";

	if (s && (!e || e < s))
		strcpy(s, suf);
	else
		strcpy(buf + strlen(buf), suf);
	ret->cname = strdup(buf);
	s = strrchr(buf, '/');
	if(s)
		s++;
	else
		s = buf;
	ret->s_cname = strdup(s);

	if (pcode_flag && main_flag)
	{
		free(name);
		ret->name = strdup("MAIN.prg");
	}

	init_Coll(&ret->functions, NULL, compare_Function);
	init_Coll(&ret->unsortedFunctions, NULL, NULL);
	init_Coll(&ret->externFunctions, free, strcasecmp);
	init_Coll(&ret->externModules, free, strcasecmp);
	init_Coll(&ret->undeclExternFunctions, free, strcasecmp);

	init_Coll(&ret->numbers, NULL, compareConstNode);
	init_Coll(&ret->unsortedNumbers, NULL, NULL);
	init_Coll(&ret->strings, NULL, compareConstNode);
	init_Coll(&ret->unsortedStrings, NULL, NULL);

	init_Coll(&ret->codeblocks, NULL, NULL);
	init_Coll(&ret->names, free, strcmp);

	ret->ctext = new_OperListNode();
	ret->ctextStatic = new_OperListNode();

	return ret;
}

void
delete_File(File * m)
{
	if (!m)
		return;

	free(m->name);
	free(m->cname);

	destroy_Coll(&m->functions);
	destroy_Coll(&m->unsortedFunctions);
	destroy_Coll(&m->externFunctions);
	destroy_Coll(&m->externModules);
	destroy_Coll(&m->undeclExternFunctions);

	destroy_Coll(&m->numbers);
	destroy_Coll(&m->unsortedNumbers);
	destroy_Coll(&m->strings);
	destroy_Coll(&m->unsortedStrings);

	destroy_Coll(&m->codeblocks);
	destroy_Coll(&m->names);

	free(m);
}

void
add_Function(File * file, Function * func)
{
	int no;

	if (search_Coll(&file->functions, func, &no))
	{
		VAR(Function, fp, file->functions.items[no]);
		if (fp == mainFunction)
		{
			char buf[80];

			yywarning( "declaration function with module name '%s'; force -n flag", fp->name);
			remove_Coll(&file->functions, fp);
			snprintf(buf, sizeof(buf), "%s_m", fp->name);
			free(fp->name);
			fp->name = strdup(buf);
			insert_Coll(&file->functions, fp);

			no = insert_Coll(&file->unsortedFunctions, func);
			func->no = no;
			insert_Coll(&file->functions, func);

		}
		else
			yyerror("function '%s' already defined near line %d file %s",
				fp->name, fp->line, fileName(fp->file));
	}
	else if (!func->isPublic && search_Coll(&file->externFunctions, func->name, &no))
	{
		yyerror("static function '%s' already declared as external",
			func->name);
	}
	else
	{
		no = insert_Coll(&file->unsortedFunctions, func);
		func->no = no;
		insert_Coll(&file->functions, func);
	}
}

/* ] File */
/* [ Function */

Function *
new_Function(char *name, VarColl * params, int isPublic, int isMain, Function * upfunc, int isCodeblock)
{
	NEWVAR(Function, ret);
	Function *sfp;
	char *s;
	int l;

	for (s = name; *s; ++s)
		*s = toupper(*s);
	ret->isPublic = isPublic;
	l = strlen(name);

	switch (isPublic)
	{
	case 0:
		ret->name = (char *) malloc(l + 4);
		memcpy(ret->name, "___", 3);
		memcpy(ret->name + 3, name, l + 1);
		break;
	case 1:
		if (isMain && pcode_flag && main_flag)
			ret->name = strdup("MAIN");
		else
			ret->name = name;
		break;
	case 2:
		ret->name = (char *) malloc(l + 6);
		memcpy(ret->name, "INIT_", 5);
		memcpy(ret->name + 5, name, l + 1);
		free(name);
		break;
	case 3:
		ret->name = (char *) malloc(l + 6);
		memcpy(ret->name, "EXIT_", 5);
		memcpy(ret->name + 5, name, l + 1);
		free(name);
		break;
	}
	ret->isMain = isMain;
	ret->params = params;
	ret->locals = new_VarColl();
	ret->publics = new_VarColl();
	ret->privates = new_VarColl();
	ret->privates = new_VarColl();
	ret->parameters = new_VarColl();
	ret->fmemvars = new_VarColl();
	ret->memvars = new_VarColl();
	ret->statics = new_VarColl();
	ret->fields = new_VarColl();
	ret->line = cl_line;
	ret->file = currentFile();
	ret->lastExec = 0;
	ret->File = curFile;
	ret->staticInit = new_Node();
	ret->body = new_OperListNode();
	ret->goto_trap = 0;
	ret->labelNo = 0;
	ret->upfunc = upfunc;
	ret->isCodeblock = isCodeblock;

	sfp = curFunction;
	curFunction = ret;
	curFunction = sfp;

	return ret;
}

void
fin_Function(Function *fpp)
{
	int i;
	for (i = 0; i < fpp->params->unsorted.count; i++)
	{
		Function *fp;
		VAR(Var, vp, fpp->params->unsorted.items[i]);
		int level;
		if (vp->macro)
		{
			yyerror("macro variable name not allowed here");
			continue;
		}

		for ( level=0, fp=fpp ;fp->upfunc ; fp=fp->upfunc, level++ )
			;
		if (!fpp->locals->unsorted.count && fp!=fpp /*&& fp->isPublic*/)
		{
			char buf[128], *nm;
			Var *nv;

			vp->pno = i;
			sprintf(buf, "___param_%d", fp->locals->unsorted.count+1);
			nm = strdup(buf);
			nv = new_Var(nm);
			nv->func = fp;
			nv->pno = vp->pno;
			add_VarColl(fp->locals, nv);
			vp->no = nv->no;
			vp->level = level;
			vp->isParam = 1;
			nv->refvar = vp;
			nv->isParam = 1;
			nv->isRef = 1;
			vp->isRef = 0;
			fp->reflocals++;
		}
		else
		{
			vp->isParam = 1;
			vp->pno = i;
			vp->func = fpp;
			add_VarColl(fpp->locals, vp);
		}

	}
}

void
delete_Function(void *v)
{
	VAR(Function, f, v);
	if (!f)
		return;
	/*delete_Node((Node *) f->body); */
	delete_VarColl(f->params);
	delete_VarColl(f->locals);
	delete_VarColl(f->publics);
	delete_VarColl(f->privates);
	delete_VarColl(f->parameters);
	delete_VarColl(f->statics);
	delete_VarColl(f->memvars);
	delete_VarColl(f->fmemvars);
	delete_VarColl(f->fields);

	free(f->name);
	free(f->seqStack);
	free(f);
}

static int
compare_Function(void *k1, void *k2)
{
	VAR(Function, v1, k1);
	VAR(Function, v2, k2);
	long h1 = hashstr(v1->name + (v1->isPublic == 0 ? 3 : 0));
	long h2 = hashstr(v2->name + (v2->isPublic == 0 ? 3 : 0));

	/*return strcasecmp(v1->name, v2->name); */
	if (h1 < h2)
		return -1;
	else if (h1 > h2)
		return 1;
/*
   else if (!v1->isPublic && v2->isPublic)
   return -1;
   else if (v1->isPublic && !v2->isPublic)
   return 1;
 */
	else
		return 0;
}

/* ] Function */
/* [ parser init/resume */

static Coll hashNames;
typedef void (*free_func) (void *);

static int
cmp_long(void *p1, void *p2)
{
	long l1 = *(long *) p1;
	long l2 = *(long *) p2;

	if (l1 < l2)
		return -1;
	else if (l1 > l2)
		return 1;
	else
		return 0;
}

void
init_parser()
{
	fileIncludes = new_Coll(free, NULL);

	if (!clic_outpath)
		clic_outpath = strdup(".");
	init_Coll(&hashNames, free, cmp_long);
	/* malloc_logpath="_memlog"; */
	/* debug2              log-stats, log-non-free, log-perror, log-trans,
	   log-bad-pnt, \ check-fence, check-heap, check-lists, check-dblock-fence, \
	   error-abort */
	/* malloc_debug( 0x401c1f ); */
	/* malloc_debug(0x405c17); */
}

void
resume_parser()
{
	delete_Coll(modules);
	delete_Coll(fileModules);
	delete_Coll(fileIncludes);
	free(clic_outpath);
	destroy_Coll(&hashNames);
}

void
add_HashName(long hash, const char *name)
{
	int no;
	char *entry;

	if (search_Coll(&hashNames, &hash, &no))
		return;
	no = strlen(name);
	entry = (char *) malloc(sizeof(long) + no + 1);

	*(long *) entry = hash;
	memcpy(entry + sizeof(long), name, no + 1);

	insert_Coll(&hashNames, entry);
}

const char *
get_HashName(long hash)
{
	int no;
	char *entry;

	if (!search_Coll(&hashNames, &hash, &no))
		return 0;
	entry = (char *) hashNames.items[no];
	return entry + sizeof(long);
}

/* ] parser init/resume */
/* [ generation utilites */

#if 0
static int
search_CatchName(Coll * names, char *name, int *index)
{
	int i;

	for (i = names->count - 1; i >= 0; --i)
		if (!strcmp(name, (char *) names->items[i]))
		{
			if (index)
				*index = i;
			return 1;
		}
	return 0;
}
#endif

int
undeclaredName(const char *sp, int memvar)
{
	int no;

	if (search_VarColl(curFunction->locals, (char *) sp, &no))
	{
		VAR(Var, vp, curFunction->locals->coll.items[no]);
		yyerror("name '%s' already declared as LOCAL near line %d pos %d file '%s'", vp->name, vp->line, vp->pos, fileName(vp->file));
		return 0;
	}
	else if (search_VarColl(curFunction->params, (char *) sp, &no))
	{
		VAR(Var, vp, curFunction->params->coll.items[no]);
		yyerror("name '%s' already declared as PARAMETER near line %d pos %d file '%s'", vp->name, vp->line, vp->pos, fileName(vp->file));
		return 0;
	}
	else if ( ! memvar && search_VarColl(curFunction->memvars, (char *) sp, &no))
	{
		VAR(Var, vp, curFunction->memvars->coll.items[no]);
		yywarning("name '%s' already declared as MEMVAR near line %d pos %d file '%s' (previous name will be hidden)", vp->name, vp->line, vp->pos, fileName(vp->file));
		return 0;
	}
	else if (search_VarColl(curFunction->fields, (char *) sp, &no))
	{
		VAR(Var, vp, curFunction->fields->coll.items[no]);
		yyerror("name '%s' already declared as FIELD near line %d pos %d file '%s'", vp->name, vp->line, vp->pos, fileName(vp->file));
		return 0;
	}
	else if (search_VarColl(curFunction->statics, (char *) sp, &no))
	{
		VAR(Var, vp, curFunction->statics->coll.items[no]);
		yyerror("name '%s' already declared as STATIC near line %d pos %d file '%s'", vp->name, vp->line, vp->pos, fileName(vp->file));
		return 0;
	}
	return 1;
}

Node *
installName(char *name)
{
	int no, level = 0;
	Var *vp;
	Function *fp;

	if (curFunction->code_params && search_VarColl(curFunction->code_params, name, &no))
	{
		VAR(Var, vp, curFunction->code_params->coll.items[no]);
		Node *rp;
		rp = new_LocalNode(vp);
		((VarNode *)rp)->vp->isCodeParam = 1;
		((VarNode *)rp)->vp->isParam = 1;
		return rp;
	}
	if (search_VarColl(curFunction->params, name, &no))
	{
		VAR(Var, vp, curFunction->params->coll.items[no]);
		return new_LocalNode(vp);
	}

	fp = curFunction;
	if (!fp->uplocals)
	{
		for ( level=0 ;fp->upfunc ; fp=fp->upfunc, level++ )
			;
	}

	if (search_VarColl(fp->locals, name, &no))
	{
		VAR(Var, vp, fp->locals->coll.items[no]);
		if (level>0)
		{
			vp->isRef = 1;
			fp->reflocals++;
		}
		vp->level = level;
		return new_LocalNode(vp);
	}


	if (search_VarColl(curStatics, name, &no))
	{
		VAR(Var, vp, curStatics->coll.items[no]);
		return new_StaticNode(vp);
	}
	if (curStatics != fileStatics && search_VarColl(fileStatics, name, &no))
	{
		VAR(Var, vp, fileStatics->coll.items[no]);
		return new_StaticNode(vp);
	}
	if (search_VarColl(curFunction->fmemvars, name, &no))
	{
		VAR(Var, vp, curFunction->fmemvars->coll.items[no]);
		return new_FMemvarNode(vp);
	}
	if (fp != curFunction && search_VarColl(fp->fmemvars, name, &no))
	{
		VAR(Var, vp, fp->fmemvars->coll.items[no]);
		return new_FMemvarNode(vp);
	}
	if (search_VarColl(curFunction->memvars, name, &no))
	{
		VAR(Var, vp, curFunction->memvars->coll.items[no]);
		return new_MemvarNode(vp);
	}
	if (fp != curFunction && search_VarColl(fp->memvars, name, &no))
	{
		VAR(Var, vp, fp->memvars->coll.items[no]);
		return new_MemvarNode(vp);
	}
	if (curFunction!=curFile->main && search_VarColl(curFile->main->memvars, name, &no))
	{
		VAR(Var, vp, curFile->main->memvars->coll.items[no]);
		return new_MemvarNode(vp);
	}
	if (search_VarColl(curFunction->fields, name, &no))
	{
		VAR(Var, vp, curFunction->fields->coll.items[no]);
		return new_FieldNode(vp);
	}
	if (fp != curFunction && search_VarColl(fp->fields, name, &no))
	{
		VAR(Var, vp, fp->fields->coll.items[no]);
		return new_FieldNode(vp);
	}
	if (curFunction!=curFile->main && search_VarColl(curFile->main->fields, name, &no))
	{
		VAR(Var, vp, curFile->main->fields->coll.items[no]);
		return new_FieldNode(vp);
	}
	if (search_VarColl(curFunction->parameters, name, &no))
	{
		VAR(Var, vp, curFunction->parameters->coll.items[no]);
		return new_ParameterNode(vp);
	}
	if (fp != curFunction && search_VarColl(fp->parameters, name, &no))
	{
		VAR(Var, vp, fp->parameters->coll.items[no]);
		return new_ParameterNode(vp);
	}

	if (search_VarColl(curFunction->privates, name, &no))
	{
		VAR(Var, vp, curFunction->privates->coll.items[no]);
		/*return new_PrivateNode(vp); */
		if (auto_memvar)
			return new_MemvarNode(vp);
		else
			return new_FMemvarNode(vp);
	}

	if (fp != curFunction && search_VarColl(fp->privates, name, &no))
	{
		VAR(Var, vp, fp->privates->coll.items[no]);
		/*return new_PrivateNode(vp); */
		if (auto_memvar)
			return new_MemvarNode(vp);
		else
			return new_FMemvarNode(vp);
	}

	if (search_VarColl(curFunction->publics, name, &no))
	{
		VAR(Var, vp, curFunction->publics->coll.items[no]);
		/*return new_PublicNode(vp); */
		if (auto_memvar)
			return new_MemvarNode(vp);
		else
			return new_FMemvarNode(vp);
	}
	if (fp != curFunction && search_VarColl(fp->publics, name, &no))
	{
		VAR(Var, vp, fp->publics->coll.items[no]);
		/*return new_PublicNode(vp); */
		if (auto_memvar)
			return new_MemvarFNode(vp);
		else
			return new_FMemvarNode(vp);
	}
	if (namespace_warning)
		yywarning("namespace of name '%s' undeclared, assumed as FIELD-MEMVAR", name);
	vp = new_Var(strdup(name));

	add_VarColl(curFunction->fmemvars, vp);
	return new_FMemvarNode(vp);
	/*
	if (auto_memvar)
		return new_MemvarFNode(vp);
	else
	{
		add_VarColl(curFunction->fmemvars, vp);
		return new_FMemvarNode(vp);
	}
	*/
}

/* add __SELF__ to parameters */
void
add_self(void)
{
	VarColl *params;
	Var *vp;
	int i;

	if (curFunction->haveSelf)
		return;

	curFunction->haveSelf++;
	params = curFunction->params;
	vp = new_Var(strdup("__SELF__"));

	insert_Coll(&params->coll, vp);
	prepend_Coll(&params->unsorted, vp);
	add_VarColl(curFunction->locals, vp);

	for (i = 0; i < params->unsorted.count; ++i)
	{
		vp = (Var *) params->unsorted.items[i];
		vp->pno = i;
	}
}

/* ] generation utilites */
/* [ codegen */

/* ] codegen */
/* [ memdebug */

#ifdef MEMDBG

#undef malloc
#undef free
#undef calloc
#undef realloc

int c_sum = 0, s_sum = 0, m_sum = 0, m_num = 0, c_num = 0, s_num = 0;

void *
m_calloc(size_t nmemb, size_t size)
{
	int l = nmemb * size;
	void *ret = m_malloc(l);

	memset(ret, 0, l);
	c_sum += l;
	c_num++;
	return ret;
}

void *
m_malloc(size_t size)
{
	m_sum += size;
	m_num++;
	return malloc(size);
}

void
m_free(void *ptr)
{
	free(ptr);
}

void *
m_realloc(void *ptr, size_t size)
{
	return realloc(ptr, size);
}

char *
m_strdup(const char *s)
{
	int l = strlen(s) + 1;
	void *ret = m_malloc(l);

	memcpy(ret, s, l);
	s_sum += l;
	s_num++;
	return ret;
}

#endif
/* ] memdebug */
/* [ StrBuf */

StrBuf *
new_StrBuf()
{
	NEWVAR(StrBuf, bp);

	bp->buf = bp->ptr = (char *) malloc(64);
	bp->size = 64;
	bp->end = bp->buf + bp->size;

	return bp;
}

void
delete_StrBuf(StrBuf * bp)
{
	if (!bp)
		return;
	free(bp->buf);
	free(bp);
}

static void
grow_buf(StrBuf * bp, int min)
{
	int dsize = bp->size / 2;
	char *buf = bp->buf;

	if (min < 16)
		min = 16;
	if (dsize < min)
		dsize = min;
	bp->size = bp->size + dsize;

	bp->buf = realloc(bp->buf, bp->size);

	bp->end = bp->buf + bp->size;
	if (buf)
		bp->ptr = bp->buf + (bp->ptr - buf);
	else
		bp->ptr = bp->buf;
}

void
putByte_StrBuf(StrBuf * bp, unsigned char b)
{
	if (! bp->ptr || bp->ptr >= bp->end)
		grow_buf(bp, 1);
	*bp->ptr = b;
	++bp->ptr;
}

void
write_StrBuf(StrBuf * bp, void *p, int len)
{
	if (!bp->buf || (bp->end - bp->ptr) <= len)
		grow_buf(bp, len + 1);
	memcpy(bp->ptr, p, len);
	bp->ptr += len;
}

void
putInt_StrBuf(StrBuf * bp, int i)
{
	long l = i;

	write_StrBuf(bp, &l, sizeof(l));
}

void
putShort_StrBuf(StrBuf * bp, short s)
{
	write_StrBuf(bp, &s, sizeof(s));
}

void
putLong_StrBuf(StrBuf * bp, long i)
{
	long l = i;

	write_StrBuf(bp, &l, sizeof(l));
}

void
putDouble_StrBuf(StrBuf * bp, double d)
{
	/*unsigned char buf[sizeof(double)]; */

	write_StrBuf(bp, &d, sizeof(d));
}

void
putStr_StrBuf(StrBuf * bp, const char *str)
{
	write_StrBuf(bp, (void *) str, strlen(str) + 1);
}

void
putString_StrBuf(StrBuf * bp, const char *str)
{
	write_StrBuf(bp, (void *) str, strlen(str));
}

/* ] StrBuf */
