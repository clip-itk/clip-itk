/*
   Copyright (C) 2001  ITK
   Author   : Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
   $Log$
   Revision 1.4  2007/02/12 09:13:17  itk
   uri: many fixes for amd64

   Revision 1.3  2007/01/30 07:55:25  itk
   uri: small fix

   Revision 1.2  2006/10/17 08:01:32  itk
   uri: small fixes

   Revision 1.99  2006/08/23 11:55:40  clip
   uri: small fix

   Revision 1.98  2006/01/03 13:33:54  clip
   uri: small fix about _clip_MODULE := modulename

   Revision 1.97  2005/12/30 13:32:21  clip
   uri: small fix, module name include path of file.prg

   Revision 1.96  2005/08/25 08:36:33  clip
   uri: small fix for AMD64 (added -fPIC option for gcc)

   Revision 1.95  2005/07/07 12:32:53  clip
   uri: small fix for gcc4

   Revision 1.94  2004/11/02 12:05:54  clip
   uri: small fix for 13.2 format detecting for numeric constants.

   Revision 1.93  2004/10/28 11:47:33  clip
   uri: fix formatiing in STR(), pad*() for numeric data and constants.

   Revision 1.92  2004/05/26 09:52:23  clip
   rust: some cleanings

   Revision 1.91  2003/09/08 15:06:03  clip
   uri: next step fixes for mingw from uri

   Revision 1.90  2003/09/02 14:27:42  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.89  2003/06/20 08:21:25  clip
   possible fixes #144
   paul

   Revision 1.88  2003/05/22 15:18:07  clip
   cygwin fix
   asdf

   Revision 1.87  2003/05/20 09:46:13  clip
   fix for static build with assembler
   paul

   Revision 1.86  2003/05/16 11:08:02  clip
   initial support for using assembler instead C
   now activated if environment variable CLIP_ASM is defined to any value
   paul

   Revision 1.85  2003/03/17 08:24:59  clip
   Solaris 8 patches
   paul

   Revision 1.84  2002/12/23 13:57:47  clip
   reference to temporary object
   frame structure extended!
   closes #90
   paul

   Revision 1.83  2002/12/18 10:02:51  clip
   memleak in C mode fixed
   closes #84
   paul

   Revision 1.82  2002/11/19 14:33:28  clip
   main in C code duplication in -M p1.prg.. pN.prg in C mode
   closes #51
   paul

   Revision 1.81  2002/11/18 13:09:37  clip
   fix searching .nm .ex under cygwin
   closes #40
   asdf

   Revision 1.80  2002/10/11 10:27:11  clip
   primary support for search of unresolved function names:
   clip compler flag -N and/or envar CLIP_NAMES=yes will generate
   files .ex (external refs) and .nm (defined names)
   clip_makeslib will join .ex and .nm files if CLIP_NAMES=yes
   new util clip_makelib also will join .ex .nm
   new util clip_cp may be used to copy lib/obj files and correspond
   .ex .nm files automatic
   Closes: #17
   paul

   Revision 1.79  2002/07/02 07:03:13  clip
   leave dec < 2
   paul

   Revision 1.78  2002/07/01 13:06:03  clip
   preproc fixes
   number constants len.dec 10.2
   paul

   Revision 1.77  2002/06/03 06:25:30  clip
   fix init warning in C mode and -Wall
   paul

   Revision 1.76  2002/04/30 12:52:01  clip
   add -stack flag to configure to enable runtime stack check
   paul

   Revision 1.75  2002/03/27 13:33:01  clip
   SHORT overflow in .po with too much STRINGs.
   .po format changed
   paul

   Revision 1.74  2002/01/29 13:12:17  clip
   load( dll)
   tested under linux
   paul

   Revision 1.73  2002/01/07 07:26:35  clip
   AS syntax cleanup
   paul

   Revision 1.72  2002/01/04 10:29:48  clip
   big module
   paul

   Revision 1.71  2001/12/21 11:40:17  clip
   static inits in C code
   paul

   Revision 1.70  2001/11/08 05:58:07  clip
   wrong initialisation of ClipFile structure in po modules
   paul

   Revision 1.69  2001/11/07 10:48:31  clip
   fixes for use mmap in win32
   paul

   Revision 1.68  2001/10/25 06:26:35  clip
   fixes
   paul
   paul
   paul

   Revision 1.67  2001/10/22 07:27:51  clip
   SPARC fixes
   paul

   Revision 1.66  2001/09/28 09:55:44  clip
   add compiler pragma:
   *reference [name1 ... nameN]
   to force call-by-reference for function's  name1..nameN arguments
   paul

   Revision 1.65  2001/09/27 06:44:24  clip
   add -R (--noremove-c) option, defaults to remove temporary .c files
   paul

   Revision 1.64  2001/09/21 09:53:25  clip
   charsets handling
   paul

   Revision 1.63  2001/09/20 13:55:15  clip
   C level error partial explanation
   paul

   Revision 1.62  2001/09/12 11:19:02  clip
   compile modes
   paul

   Revision 1.61  2001/09/10 07:09:20  clip
   libraries
   paul

   Revision 1.60  2001/09/10 05:32:05  clip
   _clip_par_*   functions
   paul

   Revision 1.59  2001/09/08 07:16:23  clip
   paths
   paul

   Revision 1.58  2001/09/07 08:18:36  clip
   main
   paul

   Revision 1.57  2001/09/07 08:03:00  clip
   binding
   paul

   Revision 1.56  2001/09/07 06:31:48  clip
   dll bindings
   paul

   Revision 1.55  2001/09/06 14:01:06  clip
   -L flag
   paul

   Revision 1.54  2001/09/06 12:17:30  clip
   cygwin
   paul

   Revision 1.53  2001/09/05 08:25:28  clip
   cygwin write underscored symbols in objs
   paul

   Revision 1.52  2001/09/04 04:27:45  clip
   -s flag and .a libraries
   paul

   Revision 1.51  2001/08/30 15:58:39  clip
   library bindings
   paul

   Revision 1.50  2001/08/30 14:37:53  clip
   new library binding
   paul

   Revision 1.49  2001/08/29 15:13:59  clip
   STD_LIBDIR
   paul

   Revision 1.48  2001/08/29 14:37:24  clip
   STD_LIBDIR fix
   paul

   Revision 1.47  2001/08/29 14:09:27  clip
   STD_LIBDIR
   paul

   Revision 1.46  2001/08/28 09:49:09  clip
   shared libs
   paul

   Revision 1.45  2001/08/28 06:18:34  clip
   -s configure flag
   uninitalized var warnings with optimesed compile
   paul

   Revision 1.44  2001/08/26 12:11:59  clip
   reflocals
   paul

   Revision 1.43  2001/08/26 11:37:01  clip
   selfref detection in local(b:=@localvar)
   paul

   Revision 1.42  2001/08/26 09:10:06  clip
   references
   paul

   Revision 1.41  2001/08/25 12:30:33  clip
   memleak in @func()
   paul

   Revision 1.40  2001/08/24 16:48:51  clip
   privates/paramters
   paul

   Revision 1.39  2001/08/24 14:38:47  clip
   CODESTR pseudofunction
   paul

   Revision 1.38  2001/08/23 13:52:06  clip
   merge with NEWLOCALS
   paul

   Revision 1.37.2.12  2001/08/23 11:38:06  clip
   paramters in block
   paul

   Revision 1.37.2.11  2001/08/21 13:20:11  clip
   fix
   paul

   Revision 1.37.2.10  2001/08/21 13:00:37  clip
   fix
   paul

   Revision 1.37.2.9  2001/08/21 12:23:49  clip
   fix
   paul

   Revision 1.37.2.8  2001/08/21 12:10:36  clip
   local init in codeblock, f.e.:

   local a:={1,2,3}
   cb:={|x|local(b:=a[2]),iif(x==NIL,b,b:=x)}
   ? eval(cb)
   ? a
   ? eval(cb,'dddd')
   ? a
   ?

   paul

   Revision 1.37.2.7  2001/08/16 14:50:19  clip
   fix
   paul

   Revision 1.37.2.6  2001/08/16 13:41:54  clip
   fix
   paul

   Revision 1.37.2.5  2001/08/15 13:34:45  clip
   fix
   paul

   Revision 1.37.2.4  2001/08/13 13:37:27  clip
   fix
   paul

   Revision 1.37.2.3  2001/08/12 09:56:15  clip
   fix
   paul

   Revision 1.37.2.2  2001/08/06 06:41:04  clip
   PCODE
   paul

   Revision 1.37.2.1  2001/08/03 12:07:59  clip
   NEWLOCALS initial
   paul

   Revision 1.37  2001/05/04 10:29:25  clip
   params and locals
   paul

   Revision 1.36  2001/04/23 07:11:10  clip
   push_area, procname for statics
   paul

   Revision 1.35  2001/04/11 06:49:02  clip
   main.prg
   paul

   Revision 1.34  2001/04/03 09:17:01  clip
   license errors
   paul

   Revision 1.33  2001/03/30 11:51:03  clip
   add copyright

   Revision 1.32  2001/03/26 05:48:16  clip
   privates
   paul

   Revision 1.31  2001/02/08 06:35:54  clip
   static defs in .po
   paul

   Revision 1.30  2001/02/06 13:07:25  clip
   hash in .po, dbg
   paul

   Revision 1.29  2000/12/26 10:03:42  clip
   load now can load .so
   -s generate .so
   paul

   Revision 1.28  2000/12/07 10:33:26  clip
   static procs in .po
   paul

   Revision 1.27  2000/12/07 07:19:38  clip
   [ string_constants ] - prepare for i18n
   linear sequence of func names in .po
   paul

   Revision 1.26  2000/12/06 13:13:01  clip
   loadable charset tables. size 256
   paul

   Revision 1.25  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.24  2000/11/22 14:52:20  clip
   .po now can be start with any (for example #!/usr/bin/cliprun) string
   paul

   Revision 1.23  2000/11/22 11:50:44  clip
   pcode link sequence
   paul

   Revision 1.22  2000/11/22 09:03:54  clip
   statics pcode
   paul

   Revision 1.21  2000/11/21 13:25:08  clip
   -l
   paul

   Revision 1.20  2000/11/21 11:31:13  clip
   io
   paul

   Revision 1.19  2000/11/20 12:59:01  clip
   10.2 default decimals
   destroy method in objs
   paul

   Revision 1.18  2000/10/26 08:11:57  clip
   rationals bugs
   paul

   Revision 1.17  2000/05/24 18:34:25  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.16  2000/05/20 19:18:22  clip
   bug with new hashstr
   Paul Lasarev <paul@itk.ru>

   Revision 1.15  2000/05/03 19:32:40  clip
   add prefix 'clip_' to all clip functions

   Revision 1.14  2000/05/01 19:40:53  clip
   SunOS port

   Revision 1.13  2000/04/28 19:01:11  clip
   tmpname fix

   Revision 1.12  2000/04/28 17:55:27  clip

   bsd fixes

   Revision 1.11  2000/04/15 20:57:34  paul
   mandrake fixes

   Revision 1.10  2000/03/24 18:10:13  paul
   trace

   Revision 1.9  2000/03/22 17:11:52  paul
   parameters by reference

   Revision 1.8  2000/03/18 21:58:11  paul
   *** empty log message ***

   Revision 1.7  2000/03/16 19:29:12  paul
   f->m-> , m->f-> fixed

   Revision 1.6  2000/03/03 21:37:37  paul
   preprocessor bug fix, warnings removed

   Revision 1.5  1999/11/27 20:02:03  uri
   added _clip_isalpha_tbl to *_ref.c files

   Revision 1.4  1999/10/27 20:01:04  paul
   gluk in param & local initalization

   Revision 1.3  1999/10/27 17:29:35  paul
   change param handling

   Revision 1.2  1999/10/26 19:11:28  paul
   start cvs logging

 */

#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include "clic.h"
#include "nodepriv.h"
#include "clipcfg.h"
#include "clip.h"

#if 0
typedef struct
{
	long hash;
	long offs;
}
ClipHashBucket;
#endif

extern int optLevel;

/* name underscore */
#ifdef NM_UNDERSCORE
#define US "_"
#else
#define US ""
#endif


/* dll import prefix */
#ifdef _WIN32
#define IMP "__imp_"
#else
#define IMP ""
#endif


static void print_Function(Function * fp);
static void print_VarColl(VarColl * cp, char *msg);
static void print_Constants(Coll * cp, char *msg);

/* [ print syntax tree  */

void
print_File(File * file)
{
	int i, count;

	printf("\nFile '%s' (%d functions):\n", file->name, file->functions.count);

	count = file->externFunctions.count;
	printf("external functions: %d:\n", count);
	for (i = 0; i < count; ++i)
	{
		VAR(char, sp, file->externFunctions.items[i]);

		printf("\t%s\n", sp);
	}

	/*
	   count = file->undeclExternFunctions.count;
	   printf( "implicit declared external functions: %d:\n", count);
	   for (i = 0; i < count; ++i)
	   {
	   VAR(char, sp, file->undeclExternFunctions.items[i]);
	   printf( "\t%s\n", sp);
	   }
	 */

	print_Constants(&file->unsortedNumbers, "numbers");
	print_Constants(&file->unsortedStrings, "strings");
	printf("codeblocks: %d\n", file->codeblocks.count);
	for (i = 0; i < file->codeblocks.count; ++i)
	{
		VAR(Function, fp, file->codeblocks.items[i]);
		print_Function(fp);
	}

	/*print_Function( file->main); */
	count = file->unsortedFunctions.count;
	for (i = 0; i < count; ++i)
	{
		VAR(Function, fp, file->unsortedFunctions.items[i]);
		print_Function(fp);
	}

}

static void
print_Function(Function * fp)
{
	printf("\n");
	if (!fp->isPublic)
		printf("STATIC ");
	printf("%s %s\n", fp->isProc ? "PROCEDURE" : "FUNCTION", fp->isPublic ? fp->name : fp->name + 3);
	printf("\tAS %s\n", fp->typename ? fp->typename : "undef");
	printf("nlocals = %d reflocals = %d uplocals=%d\n", fp->nlocals, fp->reflocals, fp->uplocals);
	print_VarColl(fp->params, "params");
	print_VarColl(fp->locals, "locals");
	print_VarColl(fp->statics, "statics");
	print_VarColl(fp->memvars, "memvars");
	print_VarColl(fp->fields, "fields");
	print_VarColl(fp->fmemvars, "fmemvars");
	print_VarColl(fp->parameters, "paramteres");
	print_VarColl(fp->privates, "privates");
	print_VarColl(fp->publics, "publics");

	if (fp->body)
	{
		printf("body:\n");
		fp->body->pass(fp->body, Print, 0, NULL);
	}
}

static void
print_VarColl(VarColl * cp, char *msg)
{
	int i, count;

	count = cp->unsorted.count;
	printf("%s (%d):\n", msg, count);
	for (i = 0; i < count; ++i)
	{
		VAR(Var, vp, cp->unsorted.items[i]);
		print_Var(vp, 1);
	}
}

static void
print_Constants(Coll * cp, char *msg)
{
	int i, count;

	count = cp->count;
	printf("%s (%d):\n", msg, count);
	for (i = 0; i < count; ++i)
	{
		VAR(ConstNode, s, cp->items[i]);
		printf("\t'%s'\n", s->val);
	}
}

/* ] print syntax tree  */
/* [ codegen  */

static void
codegen_Function(Function * fp)
{
	int i, j;

	fp->seqNo = 0;
	curFunction = fp;
	fp->nlocals = 0;
	fp->reflocals = 0;

	pass_Node(fp->body, Codegen2, 0, fp);
	pass_Node(fp->body, Codegen1, 0, fp);

#if 0
	for (j = fp->locals->unsorted.count - 1; j >= 0; --j)
	{
		VAR(Var, vp, fp->locals->unsorted.items[j]);

		Node *ip = 0;

		if (vp->init && (vp->isRef || pcode_flag || !vp->init->isConst || vp->init->isArray))
		{
			ip = vp->init;
		}
		else if (vp->arr)
		{
			ip = new_NewArrayNode(vp->arr);
		}

		if (ip)
		{
			Node *lp = new_LocalNode(vp);
			Node *np = new_OperExprNode(new_AssignNode(lp, ip, '='));

			np->line = vp->line;
			prepend_Node(fp->body, np);
		}

	}
#endif

	for (j = fp->locals->unsorted.count - 1; j >= 0; --j)
		/*for (j = 0; j < fp->locals->unsorted.count; ++j) */
	{
		VAR(Var, vp, fp->locals->unsorted.items[j]);
		if (!vp->isRef)
		{
			vp->no = fp->nlocals++;

			if (vp->refvar)
				vp->refvar->no = vp->no;
		}
	}

	for (j = fp->locals->unsorted.count - 1; j >= 0; --j)
		/*for (j = 0; j < fp->locals->unsorted.count; ++j) */
	{
		VAR(Var, vp, fp->locals->unsorted.items[j]);
		if (vp->isRef)
		{
			if (vp->isParam)
				continue;
			/*if (fp->uplocals)
			   yyerror("reflocals and uplocals"); */
			vp->no = fp->nlocals + fp->reflocals;
			fp->reflocals++;
			if (vp->refvar)
				vp->refvar->no = vp->no;
		}

	}

	for (j = fp->locals->unsorted.count - 1; j >= 0; --j)
		/*for (j = 0; j < fp->locals->unsorted.count; ++j) */
	{
		VAR(Var, vp, fp->locals->unsorted.items[j]);
		if (vp->isRef)
		{
			if (!vp->isParam)
				continue;
			vp->no = fp->nlocals + fp->reflocals;
			fp->reflocals++;
			if (vp->refvar)
				vp->refvar->no = vp->no;
		}

	}

#if 0
	for (j = fp->parameters->unsorted.count - 1; j >= 0; --j)
	{
		VAR(Var, vp, fp->parameters->unsorted.items[j]);
		if (vp->isParameter && vp->init)
		{
			prepend_Node(fp->body, vp->init);
			continue;
		}

	}
#endif

	for (j = fp->statics->unsorted.count - 1; j >= 0; --j)
	{
		VAR(Var, vp, fp->statics->unsorted.items[j]);
		if (vp->init /*&& (pcode_flag || vp->init->isArray) */ )
		{
			Node *np = new_OperExprNode(new_AssignNode(new_StaticNode(vp), vp->init, '='));

			np->line = vp->init->line;
			prepend_Node(fp->staticInit, np);
		}
		else if (vp->arr)
		{
			Node *np = new_OperExprNode(new_AssignNode(new_StaticNode(vp),
								   new_NewArrayNode(vp->arr), '='));

			np->line = vp->line;
			prepend_Node(fp->staticInit, np);
		}
	}

	for (i = 0; i < fp->params->unsorted.count; i++)
	{
		VAR(Var, vp, fp->params->unsorted.items[i]);
		prepend_Node(fp->body, new_ParamNode(vp));
	}

	if (fp->uplocals)
	{
		fp->nlocals = 0;
		fp->reflocals = 0;
	}

	pass_Node(fp->body, CalcDeep, 0, fp);

}

static int
add_goto_trap(Node * np, void *par)
{
	Function *fp = (Function *) par;

	if (!np->isConst || np->isArray)
		fp->goto_trap++;

	return 0;
}

void
codegen_File(File * file)
{
	int i, j;

	for (i = 0; i < file->unsortedFunctions.count; i++)
	{
		VAR(Function, fp, file->unsortedFunctions.items[i]);
		codegen_Function(fp);
	}

	file->init = new_Function(strdup("_init"), new_VarColl(), 0, 0, 0, 0);
	file->init->body = new_Node();
	/*join_Node(file->init->body, file->main->staticInit); */
	for (i = 0; i < file->unsortedFunctions.count; i++)
	{
		VAR(Function, fp, file->unsortedFunctions.items[i]);
		traverse_Node(fp->staticInit, add_goto_trap, file->init);
		join_Node(file->init->body, fp->staticInit);
	}

	codegen_Function(file->init);

	for (i = 0; i < file->codeblocks.count; i++)
	{
		VAR(Function, fp, file->codeblocks.items[i]);
		codegen_Function(fp);
	}

	i = 0;
	file->pubcount = 0;
	file->initcount = 0;
	file->exitcount = 0;
	file->allcount = file->functions.count + file->codeblocks.count;
	for (j = 0; j < file->unsortedFunctions.count; ++j)
	{
		VAR(Function, fp, file->unsortedFunctions.items[j]);
		switch (fp->isPublic)
		{
		case 1:
			fp->mno = i++;
			file->pubcount++;
			break;
		case 2:
			fp->mno = i++;
			file->initcount++;
			break;
		case 3:
			fp->mno = i++;
			++file->exitcount;
			break;
		}
	}
	for (j = 0; j < file->unsortedFunctions.count; ++j)
	{
		VAR(Function, fp, file->unsortedFunctions.items[j]);
		if (!fp->isPublic)
			fp->mno = i++;
	}
	for (j = 0; j < file->codeblocks.count; ++j)
	{
		VAR(Function, fp, file->codeblocks.items[j]);
		fp->mno = i++;
	}

}

/* ] codegen  */
/* [ write C file  */

static void
write_Function(FILE * out, File * file, Function * fp)
{
	int j;
	int namelen;
	int local_locals = 0;

	clic_line = fp->line;
	if (file->init != fp)
		fprintf(out, "\n%sint\nclip_%s(ClipMachine *_mp)\n{\n", fp->isPublic ? "" : "static ",
			fp != file->init ? fp->name : "_init");
	else
		fprintf(out, "\nstatic int\n_init(ClipMachine *_mp, ClipFrame *_frame_p)\n{\n");

	fprintf(out, "\tint _ret = 0;\n");
	if (fp->haveIf)
		fprintf(out, "\tint _if;\n");
	fprintf(out, "\tClipVar _stack [ %d ];\n", fp->maxdeep + 1);

#if 0
	if (fp->reflocals)
	{
		fprintf(out, "\tClipVar _reflocals [ %d ];\n", fp->reflocals);
	}
#else
	for (namelen = 1, j = 0; j < fp->locals->unsorted.count; j++)
	{
		VAR(Var, vp, fp->locals->unsorted.items[j]);
		namelen += strlen(vp->name) + 1;
	}

	if (!fp->nlocals && !fp->reflocals)
	{
		fprintf(out, "\tClipVarFrame *_localvars = _mp->fp->localvars;\n");
	}
	else if (fp->reflocals)
	{
		int i, l;

		fprintf(out,
			"\tClipVarFrame *_localvars = (ClipVarFrame*) calloc(1, sizeof(ClipVarFrame)+%d*sizeof(ClipVar));\n",
			fp->locals->unsorted.count);
		fprintf(out, "\tstatic const char _localnames[] = {");
		for (j = 0; j < fp->locals->unsorted.count; j++)
		{
			VAR(Var, vp, fp->locals->unsorted.items[j]);
			if (vp->isRef)
				continue;
			l = strlen(vp->name);
			for (i = 0; i <= l; i++)
				fprintf(out, "%d, ", vp->name[i]);
			fprintf(out, " /* %s */ ", vp->name);
		}
		for (j = 0; j < fp->locals->unsorted.count; j++)
		{
			VAR(Var, vp, fp->locals->unsorted.items[j]);
			if (!vp->isRef)
				continue;
			l = strlen(vp->name);
			for (i = 0; i <= l; i++)
				fprintf(out, "%d, ", vp->name[i]);
			fprintf(out, " /* %s */ ", vp->name);
		}
		fprintf(out, "0 };\n");
	}
	else
	{
		int numlocals = fp->locals->unsorted.count;
		int i, l;

		local_locals = 1;
		fprintf(out, "\tClipVar _vlocals [ %d ] = { ", numlocals);
		for (j = 0; j < numlocals - 1; j++)
			fprintf(out, "{ {UNDEF_t, 0,0,0,0} }, ");
		if (numlocals)
			fprintf(out, "{ {UNDEF_t, 0,0,0,0} } ");
		fprintf(out, "};\n");
		fprintf(out, "\tconst char _localnames[] = { ");
		for (j = 0; j < fp->locals->unsorted.count; j++)
		{
			VAR(Var, vp, fp->locals->unsorted.items[j]);
			if (vp->isRef)
				continue;
			l = strlen(vp->name);
			for (i = 0; i <= l; i++)
				fprintf(out, "%d, ", vp->name[i]);
			fprintf(out, " /* %s */ ", vp->name);
		}
		for (j = 0; j < fp->locals->unsorted.count; j++)
		{
			VAR(Var, vp, fp->locals->unsorted.items[j]);
			if (!vp->isRef)
				continue;
			l = strlen(vp->name);
			for (i = 0; i <= l; i++)
				fprintf(out, "%d, ", vp->name[i]);
			fprintf(out, " /* %s */ ", vp->name);
		}
		fprintf(out, "0 };\n");
		fprintf(out, "\tClipVarFrame _local_vars = { 0, %d, _vlocals, _localnames }, *_localvars = &_local_vars;\n",
			fp->locals->unsorted.count);
	}
#endif

#if 0
	for (j = 0; j < fp->locals->unsorted.count; j++)
	{
		VAR(Var, vp, fp->locals->unsorted.items[j]);
		if (vp->isRef)
			continue;
		if (!vp->init)
			fprintf(out, "\tClipVar %s = { {UNDEF_t, 0, 0,0,0} };\n", vp->name);
		else if (vp->init->isConst && !vp->init->isArray)
		{
			if (vp->init->isNum)
				fprintf(out, "\tClipVarNum %s = ", vp->name);
			else if (vp->init->isStr)
				fprintf(out, "\tClipVarStr %s = ", vp->name);
			else if (vp->init->isLog)
				fprintf(out, "\tClipVarLog %s = ", vp->name);
			else if (vp->init->isCode)
				fprintf(out, "\tClipVarCode %s = ", vp->name);
			else
				fprintf(out, "\tClipVar %s = ", vp->name);
			vp->init->pass(vp->init, CTextInit, 0, out);
			fprintf(out, ";\n");
		}
		else
			fprintf(out, "\tClipVar %s = { {UNDEF_t, 0, 0,0,0} };\n", vp->name);
	}
#endif
	/*
	   if (fp->params->coll.count)
	   {
	   int i, c=fp->params->coll.count;

	   fprintf(out, "\tClipVar _params[%d] = { ", c);
	   for(i=0; i<c; ++i)
	   fprintf(out, "{ UNDEF_t, 0, 0,0,0 },");
	   fprintf(out, " };\n");
	   }
	 */

#if 0
	{
		fprintf(out, "\tClipVarDef _locals[] =\n\t{\n");
		fprintf(out, "\t\t{ %d, 0 },\n", fp->locals->coll.count);
		for (j = 0; j < fp->locals->coll.count; j++)
		{
			VAR(Var, vp, fp->locals->coll.items[j]);
			if (vp->isRef)
				fprintf(out, "\t\t{ 0x%lx, _reflocals+%d },\n", hashstr(vp->name), -vp->no);
			else
				fprintf(out, "\t\t{ 0x%lx, &%s },\n", hashstr(vp->name), vp->name);
		}
		fprintf(out, "\t};\n");
	}
#else
#endif

	fprintf(out, "\tClipFrame _frame = { _stack, _stack, _file, %d, 0, %s, 0, _statics, 0, &_hash_names,\"%s\", %d, 0 };\n",
		fp->line, "_localvars", fp->isPublic ? fp->name : fp->name + 3, fp->maxdeep + 1);

	if (file->init != fp && !fp->nlocals && !fp->reflocals)
	{
		fprintf(out, "\tif (_localvars && _localvars->refcount)\n\t\t_localvars->refcount++;\n");
	}
	else if (fp->reflocals)
	{
		fprintf(out, "\t_localvars->vars = (ClipVar*) (_localvars + 1);\n");
		fprintf(out, "\t_localvars->refcount = 1;\n");
		fprintf(out, "\t_localvars->size = %d;\n", fp->nlocals + fp->reflocals);
		fprintf(out, "\t_localvars->names = _localnames;\n");
	}

	if (file->init != fp)
	{
		fprintf(out, "\t_init( _mp, &_frame );\n");
		fprintf(out, "\t_clip_log_call( _mp );\n\n");
	}
	else
	{
		fprintf(out, "\t_frame_p->up = _mp->fp;\n");
		fprintf(out, "\tif (_init_flag)\n\t{\n");
		fprintf(out, "\t\t_mp->fp = _frame_p;\n");
		fprintf(out, "\t\treturn 0;\n\t}\n");
		fprintf(out, "\telse if (_localvars && _localvars->refcount)\n\t\t_localvars->refcount++;\n");
		fprintf(out, "\t_frame.up = _mp->fp;\n");
		fprintf(out, "\t_mp->fp = &_frame;\n");
		fprintf(out, "\t_init_flag = 1;\n");

		/*
		   for(i=0;i<file->unsortedFunctions.count;i++)
		   {
		   VAR(Function, fp, file->unsortedFunctions.items[i]);
		   if (fp->isPublic)
		   fprintf(out, "\t_clip_register( %s, \"%s\" );\n", fp->name, fp->name);
		   }
		 */
		fprintf(out, "\n");
	}

#if 0
	if (fp->reflocals)
		fprintf(out, "\t_clip_mptr(_mp, _reflocals, %d);\n", fp->reflocals);
#endif

	pass_Node(fp->body, CText, 0, out);

	if (file->init == fp)
		file->ctextStatic->pass(file->ctextStatic, CText, 0, out);

	if ( /*file->init!=fp && */ fp->goto_trap)
	{
		fprintf(out, "\n\tgoto _return;\n");
		fprintf(out, "_trap_0:\n");
		/*fprintf(out, "\t_ret = 1;\n"); */
		fprintf(out, "\t_clip_trap(_mp, _file, _frame.line);\n");
	}

	fprintf(out, "_return:\n");
#if 1
	if (local_locals)
		fprintf(out, "\t_clip_destroy_locals( _mp );\n");
	fprintf(out, "\t_clip_resume( _mp, %d, %d );\n", fp->nlocals, fp->reflocals);
#else
	fprintf(out, "\t_clip_resume( _mp, %d ", fp->nlocals);
	if (fp->nlocals)
	{
		for (j = fp->locals->unsorted.count - 1; j >= 0; --j)
		{
			VAR(Var, vp, fp->locals->unsorted.items[j]);
			if (vp->isRef)
				continue;
			fprintf(out, ", &%s", vp->name);
		}
	}
	fprintf(out, " );\n");
#if 0
	if (fp->reflocals)
	{
		fprintf(out, "\t_clip_vresume(_mp, %d, _reflocals);\n", fp->reflocals);
	}
#endif
#endif
	/*
	   if (fp->params->coll.count)
	   {
	   int c=fp->params->coll.count;
	   fprintf(out, "\t_clip_vresume(_mp, %d, _params);\n", c);
	   }
	 */

#if 0
	if ((fp->privates->unsorted.count + fp->parameters->unsorted.count) > 0)
	{
		fprintf(out, "\t_clip_remove_privates( _mp, %d", fp->privates->unsorted.count + fp->parameters->unsorted.count);
		for (j = fp->privates->unsorted.count - 1; j >= 0; --j)
		{
			VAR(Var, vp, fp->privates->unsorted.items[j]);
			fprintf(out, ", 0x%lx", hashstr(vp->name));
		}
		for (j = fp->parameters->unsorted.count - 1; j >= 0; --j)
		{
			VAR(Var, vp, fp->parameters->unsorted.items[j]);
			fprintf(out, ", 0x%lx", hashstr(vp->name));
		}
		fprintf(out, ");\n");
	}
#endif

	if (file->init == fp)
	{
		/*fprintf(out, "\t_frame_p->up = _mp->fp;\n"); */
		fprintf(out, "\t_mp->fp = _frame_p;\n");
	}
	fprintf(out, "\treturn _ret;\n}\n");
}

static void
write_statics(FILE * out, VarColl * statics)
{
	int j;

	for (j = 0; j < statics->unsorted.count; j++)
	{
		VAR(Var, vp, statics->unsorted.items[j]);
#if 1
		fprintf(out, "static ClipVar s_%s_%s = { {UNDEF_t, 0, 0,0,0} }", vp->func->name, vp->name);
#else
		if (!vp->init)
			fprintf(out, "static ClipVar s_%s_%s = { {UNDEF_t, 0, 0,0,0} }", vp->func->name, vp->name);
		else if (vp->init->isArray)
		{
			fprintf(out, "static ClipVar s_%s_%s", vp->func->name, vp->name);
		}
		else
		{
			if (vp->init->isNum)
				fprintf(out, "static ClipVarNum s_%s_%s = ", vp->func->name, vp->name);
			else if (vp->init->isStr)
				fprintf(out, "static ClipVarStr s_%s_%s = ", vp->func->name, vp->name);
			else if (vp->init->isLog)
				fprintf(out, "static ClipVarLog s_%s_%s = ", vp->func->name, vp->name);
			else if (vp->init->isCode)
				fprintf(out, "static ClipVarCode s_%s_%s = ", vp->func->name, vp->name);
			else
				fprintf(out, "static ClipVar s_%s_%s = ", vp->func->name, vp->name);
			vp->init->pass(vp->init, CTextInit, 0, out);
		}
#endif
		fprintf(out, ";\n");
	}

}

static void
write_staticDefs(FILE * out, VarColl * statics)
{
	int j;

	for (j = 0; j < statics->coll.count; j++)
	{
		VAR(Var, vp, statics->coll.items[j]);
		fprintf(out, "\t{ 0x%lx, &s_%s_%s },\n", hashstr(vp->name), vp->func->name, vp->name);
	}
}

static int wrote_main = 0;

void
write_Main(File * file, FILE * out, const char *start)
{
	if (wrote_main)
		return;
	fprintf(out, "\n\nextern char **environ;\n");
	fprintf(out, "void _clip_init_dll(void);\n");
	fprintf(out, "\nint\nmain(int argc, char **argv)\n{\n");
	fprintf(out, "\tClipMachine *mp;\n\n");
	fprintf(out, "\t_clip_init_dll();\n");
	fprintf(out, "\tmp = new_ClipMachine(0);\n");
	fprintf(out, "\treturn _clip_main_func( mp, clip_%s, argc, argv, environ);\n", start);
	fprintf(out, "}\n");
	wrote_main = 1;
}

void
write_File(File * file)
{
	int i, j, sum;
	FILE *out;
	time_t tbuf;

	out = fopen(file->cname, "wb");
	if (!out)
	{
		yyerror("cannot open output file '%s'", file->cname);
		return;
	}

	fprintf(out, "/*\n");
	fprintf(out, " *\tfile '%s', \n", file->cname);
	fprintf(out, " *\tautomatically generated by clip-");
	printVersion(out);
	fprintf(out, "\n");
	fprintf(out, " *\tfrom source '%s', \n", file->name);
	time(&tbuf);
	fprintf(out, " *\tat %s", ctime(&tbuf));
	fprintf(out, " */\n");

	fprintf(out, "\n#include \"clip.h\"\n\n");

	fprintf(out, "static const char *_file = \"%s\";\n\n", file->name);

	fprintf(out, "/* extern functions */\n");
	for (i = 0; i < file->externFunctions.count; i++)
	{
		VAR(char, sp, file->externFunctions.items[i]);

		fprintf(out, "ClipFunction clip_%s;\n", sp);
	}

	fprintf(out, "\n/* forced references to external functions */\n");
	for (i = 0; i < file->externFunctions.count; i++)
	{
		VAR(char, sp, file->externFunctions.items[i]);

		fprintf(out, "static ClipFunction *__%s = clip_%s;\n", sp, sp);
	}

	fprintf(out, "\n/* forced references to external modules */\n");
	for (i = 0; i < file->externModules.count; i++)
	{
		VAR(char, sp, file->externModules.items[i]);

		fprintf(out, "extern ClipModule clip__MODULE_%s;\n", sp);
		fprintf(out, "static ClipModule *%s_module_ref = &%s_module;\n", sp, sp);
	}

#if 0
	fprintf(out, "\n/* implicit declared functions */\n");
	for (i = 0; i < file->undeclExternFunctions.count; i++)
	{
		VAR(char, sp, file->undeclExternFunctions.items[i]);

		fprintf(out, "ClipFunction %s;\n", sp);
	}
#endif

	fprintf(out, "\n/* file functions */\n");
	/*fprintf(out, "ClipFunction %s;\n", file->main->name); */
	for (i = 0; i < file->unsortedFunctions.count; i++)
	{
		VAR(Function, fp, file->unsortedFunctions.items[i]);
		fprintf(out, "%sClipFunction clip_%s;\n", fp->isPublic ? "" : "static ", fp->name);
	}

	fprintf(out, "\n/* entry table */\n");

	fprintf(out, "static ClipNameEntry __cfunctions[] =\n{\n");
	for (i = 0; i < file->functions.count; i++)
	{
		VAR(Function, fp, file->functions.items[i]);
		if (fp->isPublic == 1)
			fprintf(out, "\t{ 0x%lx, clip_%s },\n", hashstr(fp->name), fp->name);
	}
	fprintf(out, "\t{ 0, 0 }\n};\n\n");

	fprintf(out, "static ClipFunction *__inits[] =\n{\n");
	for (i = 0; i < file->functions.count; i++)
	{
		VAR(Function, fp, file->functions.items[i]);
		if (fp->isPublic == 2)
			fprintf(out, "\tclip_%s,\n", fp->name);
	}
	fprintf(out, "\t0\n};\n\n");

	fprintf(out, "static ClipFunction *__exits[] =\n{\n");
	for (i = 0; i < file->functions.count; i++)
	{
		VAR(Function, fp, file->functions.items[i]);
		if (fp->isPublic == 3)
			fprintf(out, "\tclip_%s,\n", fp->name);
	}
	fprintf(out, "\t0\n};\n\n");

	fprintf(out, "ClipModule clip__MODULE_%s=\n{\n", file->mname);

	fprintf(out, "\t\"%s\",\n", file->mname);
	fprintf(out, "\t__cfunctions,\n");
	fprintf(out, "\t__inits,\n");
	fprintf(out, "\t__exits,\n");
	fprintf(out, "\t0,\n");
	fprintf(out, "\t0,\n");
	fprintf(out, "\t0,\n");
	fprintf(out, "\t0,\n");

	fprintf(out, "};\n");

	/*if (genDebug) */
	{
		char buf[256];
		Coll coll;

		init_Coll(&coll, free, strcmp);

		fprintf(out, "\nstatic ClipHashBucket _hash_buckets[%d]=\n{\n", file->names.count);
		for (sum = 0, i = 0; i < file->names.count; ++i)
		{
			int l;
			char *s = (char *) file->names.items[i];

			snprintf(buf, sizeof(buf), "\t{ 0x%08lx, %d }, /* %s */\n", hashstr(s), sum, s);
			insert_Coll(&coll, strdup(buf));
			l = strlen(s) + 1;
			sum += l;

		}

		for (i = 0; i < coll.count; ++i)
			fprintf(out, "%s", (char *) coll.items[i]);

		fprintf(out, "};\n");

		fprintf(out, "\nstatic char _hash_mem[%d] =\n{\n", sum);
		for (i = 0; i < file->names.count; ++i)
		{
			int l, j;
			char *s = (char *) file->names.items[i];

			l = strlen(s) + 1;
			fprintf(out, "\t");
			for (j = 0; j < l; ++j)
				fprintf(out, "%d, ", s[j]);
			fprintf(out, "\n");
		}
		fprintf(out, "};\n");

		fprintf(out, "\nstatic ClipHashNames _hash_names =\n{\n");
		fprintf(out, "\t%d,\n", file->names.count);
		fprintf(out, "\t_hash_buckets,\n");
		fprintf(out, "\t_hash_mem,\n");
		fprintf(out, "};\n");

		destroy_Coll(&coll);
	}

	fprintf(out, "\n");

	for (j = 0; j < file->unsortedNumbers.count; j++)
	{
		VAR(ConstNode, sp, file->unsortedNumbers.items[j]);
		char *s = strchr(sp->val, '.');
		int len, dec = 0;

		len = strlen(sp->val);
		if (s)
			dec = len - (s - sp->val) - 1;
		if (!s)
			s = strchr(sp->val, 'e');
		if (!s)
			s = strchr(sp->val, 'E');
		if (len < 10)
		{
			if ( dec > 0 )
				len = 11+dec;
			else
				len = 10;
		}
		/*if (dec < 2)
		   dec = 2; */
		if (dec > len)
			len = dec + 1;
		fprintf(out, "static ClipVarNum _num_%d = { { { NUMERIC_t,%d,%d,0,0,0 } , %s%s } };\n", j, len, dec, sp->val,
			s ? "" : ".0");
	}

	for (j = 0; j < file->unsortedStrings.count; j++)
	{
		VAR(ConstNode, sp, file->unsortedStrings.items[j]);
		fprintf(out, "static ClipVarStr _str_%d = { { { CHARACTER_t,%d,0,F_MSTAT,0 }, { ", j, haveMacro(sp->val));
		printString(out, sp->val);
		fprintf(out, ", %ld } } };\n", (long)strlen(sp->val));
	}

	if (main_flag)
		write_Main(file, out, file->main->name);

	file->ctext->pass(file->ctext, CText, 0, out);

	if (file->codeblocks.count)
	{

		fprintf(out, "\n");
		for (j = 0; j < file->codeblocks.count; ++j)
		{
			VAR(Function, fp, file->codeblocks.items[j]);
			fprintf(out, "static ClipFunction clip_%s;\n", fp->name);
		}
	}

	fprintf(out, "\n/* file statics */\n");
	/*write_statics(out, file->main->statics); */
	for (i = 0; i < file->unsortedFunctions.count; i++)
	{
		VAR(Function, fp, file->unsortedFunctions.items[i]);
		write_statics(out, fp->statics);
	}

	{
		int nstatics = 0;

		fprintf(out, "static ClipVarDef _statics[] =\n{\n");
		for (i = 0; i < file->unsortedFunctions.count; i++)
		{
			VAR(Function, fp, file->unsortedFunctions.items[i]);
			nstatics += fp->statics->coll.count;
		}
		fprintf(out, "\t{ %d, 0 },\n ", nstatics);
		for (i = 0; i < file->unsortedFunctions.count; i++)
		{
			VAR(Function, fp, file->unsortedFunctions.items[i]);
			write_staticDefs(out, fp->statics);
		}
		fprintf(out, "};\n");
	}

	fprintf(out, "\nstatic int _init_flag=0;\n");
	write_Function(out, file, file->init);

	if (file->codeblocks.count)
	{

		fprintf(out, "\n");

		for (j = 0; j < file->codeblocks.count; j++)
		{
			VAR(Function, fp, file->codeblocks.items[j]);
			write_Function(out, file, fp);
		}

	}

	/*write_Function(out, file, file->main); */
	for (i = 0; i < file->unsortedFunctions.count; i++)
	{
		VAR(Function, fp, file->unsortedFunctions.items[i]);
		write_Function(out, file, fp);
	}

	fclose(out);
}

void
compile_File(const char *cname)
{
	char cmd[1024], oname[256], *e, *s;
	int i;

	strcpy(oname, cname);
	s = strrchr(cname, '.');
	e = strrchr(oname, '.');
	strcpy(e, OBJSUF);

#ifdef USE_AS
	if (asm_flag && !strcmp(s, ".s"))
	{
		snprintf(cmd, sizeof(cmd), "%s -o %s %s", AS_PRG, oname, cname);
	}
	else
#endif
	{

		snprintf(cmd, sizeof(cmd), "%s", CC);
		for (e = cmd + strlen(cmd), i = 0; i < includePaths.count; ++i)
		{
			snprintf(e, sizeof(cmd) - (e - cmd), " %s %s", INCLUDE_FLAG, (char *) includePaths.items[i]);
			e = cmd + strlen(cmd);
		}
		snprintf(e, sizeof(cmd) - (e - cmd), " %s %s %s %s %s %s %s %s", optLevel ? COPT : "", genDebug ? CDBG : "",
			 CFLAGS, ADDCFLAGS, COMPILE_FLAG, cname, OUT_FLAG, oname);

	}

	v_printf(2, "%s\n", cmd);
	if (system(cmd))
		yyerror("C level error in command: %s", cmd);
	else if (rmc_flag)
		unlink(cname);
}

void
share_File(const char *cname)
{
	char cmd[1024], oname[256], soname[256], *e;

	strcpy(oname, cname);
	e = strrchr(oname, '.');
	strcpy(e, OBJSUF);

	strcpy(soname, cname);
	e = strrchr(soname, '.');
	strcpy(e, SOBJSUF);

	sprintf(cmd, "%s", CC);
/*
   for (e = cmd + strlen(cmd), i = 0; i < includePaths.count; ++i)
   {
   sprintf(e, " %s %s", INCLUDE_FLAG, (char *) includePaths.items[i]);
   e = cmd + strlen(cmd);
   }
 */
	e = cmd + strlen(cmd);
	sprintf(e, " %s %s %s %s %s %s %s", optLevel ? COPT : "", genDebug ? CDBG : "",
		CFLAGS, SFLAGS, oname, OUT_FLAG, soname);

	v_printf(2, "%s\n", cmd);
	if (system(cmd))
		yyerror("C level error in command: %s", cmd);
}

void
compile_CFile(char *name)
{
	char cmd[1024], cname[256], oname[256], *e;
	int i;

	if (preproc_flag)
	{
		preprocCFile(name, NULL);
		return;
	}

	/*snprintf(cname, sizeof(cname), "/tmp/clip.XXXXXX");
	   mktemp(cname);
	   strcat(cname, ".c"); */
	//snprintf(cname, sizeof(cname), "/tmp/clipar.%lx%lx.pa", (long) getpid(), (long) random());
	snprintf(cname, sizeof(cname), "/tmp/clipar.%lx%lx.c", (long) getpid(), (long) random());

	preprocCFile(name, cname);
	if (clic_errorcount)
		return;

	strcpy(oname, name);
	e = strrchr(oname, '.');
	strcpy(e, OBJSUF);

	sprintf(cmd, "%s", CC);
	for (e = cmd + strlen(cmd), i = 0; i < includePaths.count; ++i)
	{
		sprintf(e, " %s %s", INCLUDE_FLAG, (char *) includePaths.items[i]);
		e = cmd + strlen(cmd);
	}
	sprintf(e, " %s %s %s %s %s %s %s", optLevel ? COPT : "", genDebug ? CDBG : "",
		CFLAGS, COMPILE_FLAG, cname, OUT_FLAG, oname);

	v_printf(2, "%s\n", cmd);
	if (system(cmd))
		yyerror("C level error in command: %s", cmd);

	unlink(cname);
}

/* ] write C file  */
/* [ write PO file  */

#define MODBEG (bp->buf+8+2*sizeof(long))
#define BEGOFFS (bp->ptr-MODBEG)
#define CUROFFS (bp->ptr-bp->buf)

#ifdef FORCEALIGN

static void
SETLONG(StrBuf * bp, long offs, long val)
{
	memcpy(bp->buf + offs, &val, sizeof(long));
}

static void
SETSHORT(StrBuf * bp, long offs, short val)
{
	memcpy(bp->buf + offs, &val, sizeof(short));
}

#else

#define SETLONG(bp, offs, val) (*(long*)((bp)->buf+(offs))=(val))
#define SETSHORT(bp, offs, val) (*(short*)((bp)->buf+(offs))=(val))

#endif

#define LONGINCR(offs) ((offs)+=sizeof(long));
#define SHORTINCR(offs) ((offs)+=sizeof(short));

static void
put_function(File * file, StrBuf * bp, Function * fp, long *loffs)
{
	int j, count, namelen;
	long lp, blp;

	/*printf("put_function: beg: %s\n", fp->name);fflush(stdout); */
	if (loffs)
	{
		SETLONG(bp, *loffs, hashstr(fp->name));
		LONGINCR(*loffs);
		SETLONG(bp, *loffs, BEGOFFS);
		LONGINCR(*loffs);
	}
	/* offs from beg of module */
	putLong_StrBuf(bp, BEGOFFS);
	lp = CUROFFS;
	/* body offs (from BOM) */
	/* 1l */
	putLong_StrBuf(bp, 0);
	/* body len */
	/* 2l */
	putLong_StrBuf(bp, 0);
	/* 3l */
	putByte_StrBuf(bp, fp->isPublic);
	/* 3l,0s,1b */
	putShort_StrBuf(bp, fp->nlocals);
	/* 3l,1s,1b */
	putShort_StrBuf(bp, fp->reflocals);
	/* 3l,2s,1b */
	putShort_StrBuf(bp, fp->maxdeep + 1);
	count = fp->privates->unsorted.count + fp->parameters->unsorted.count;
	/* 3l,3s,1b */
	putShort_StrBuf(bp, count);
/*!!! *//* 3l,4s,1b */
	putShort_StrBuf(bp, fp->params->unsorted.count);

	/* 3l,5s,1b */
	for (j = 0; j < fp->privates->unsorted.count; ++j)
	{
		VAR(Var, vp, fp->privates->unsorted.items[j]);
		putLong_StrBuf(bp, hashstr(vp->name));
	}
	for (j = 0; j < fp->parameters->unsorted.count; ++j)
	{
		VAR(Var, vp, fp->parameters->unsorted.items[j]);
		putLong_StrBuf(bp, hashstr(vp->name));
	}

	for (j = 0; j < fp->locals->coll.count; ++j)
	{
		VAR(Var, vp, fp->locals->coll.items[j]);
		putLong_StrBuf(bp, hashstr(vp->name));
	}
	for (j = 0; j < fp->locals->coll.count; ++j)
	{
		VAR(Var, vp, fp->locals->coll.items[j]);
		putShort_StrBuf(bp, vp->no);
	}

	for (namelen = 1, j = 0; j < fp->locals->unsorted.count; j++)
	{
		VAR(Var, vp, fp->locals->unsorted.items[j]);
		namelen += strlen(vp->name) + 1;
	}

	if (fp->isPublic == 0)
	{
		putByte_StrBuf(bp, strlen(fp->name + 3));
		putStr_StrBuf(bp, fp->name + 3);
	}
	else
	{
		putByte_StrBuf(bp, strlen(fp->name));
		putStr_StrBuf(bp, fp->name);
	}

	for (j = 0; j < fp->locals->unsorted.count; j++)
	{
		VAR(Var, vp, fp->locals->unsorted.items[j]);
		if (vp->isRef)
			continue;
		putStr_StrBuf(bp, vp->name);
	}
	for (j = 0; j < fp->locals->unsorted.count; j++)
	{
		VAR(Var, vp, fp->locals->unsorted.items[j]);
		if (!vp->isRef)
			continue;
		putStr_StrBuf(bp, vp->name);
	}

	SETLONG(bp, lp, BEGOFFS);
	lp += sizeof(long);

	blp = CUROFFS;
	/*printf("put_function: body: %s\n", fp->name);fflush(stdout); */
	pass_Node(fp->body, OText, 0, bp);
	SETLONG(bp, lp, CUROFFS - blp);
	/*printf("put_function: end: %s\n", fp->name);fflush(stdout); */
}

static int
cmp_hash_bucket(void *p1, void *p2)
{
	unsigned long h1 = (unsigned long) ((ClipHashBucket *) p1)->hash;
	unsigned long h2 = (unsigned long) ((ClipHashBucket *) p2)->hash;

	if (h1 < h2)
		return -1;
	else if (h1 > h2)
		return 1;
	else
		return 0;
}

void
write_OFile(File * file, long *len)
{
	int i, j, count;
	FILE *out;
	time_t timestamp;
	StrBuf *bp;
	char *s;
	long modbeg;
	long modlen;
	long loffs, funcOffs;
	long strOffs, numOffs, initOffs;
	long soffs;
	char *hash_buckets_buf = 0;
	int hash_buckets_len = 0;

	/*printf("write_OFile: %s\n", file->name);fflush(stdout); */

/* generate hash-buckets string */
	{
		Coll coll;
		int sum = 0;
		int count = file->names.count;
		StrBuf str_buf = { 0, 0, 0, 0 };
		StrBuf *hbp = &str_buf;
		int l;
		int nstatics = 0;

		for (i = 0; i < file->unsortedFunctions.count; i++)
		{
			VAR(Function, fp, file->unsortedFunctions.items[i]);
			nstatics += fp->statics->coll.count;
		}

		init_Coll(&coll, free, cmp_hash_bucket);
		hbp = new_StrBuf();

		for (i = 0; i < count; ++i)
		{
			char *s = (char *) file->names.items[i];
			ClipHashBucket *buck = NEW(ClipHashBucket);

			buck->hash = hashstr(s);
			buck->offs = sum;
			insert_Coll(&coll, buck);
			l = strlen(s) + 1;
			sum += l;
		}
		putLong_StrBuf(hbp, count);
		putLong_StrBuf(hbp, nstatics);

		for (i = 0; i < file->unsortedFunctions.count; i++)
		{
			VAR(Function, fp, file->unsortedFunctions.items[i]);
			for (j = 0; j < fp->statics->coll.count; j++)
			{
				VAR(Var, vp, fp->statics->coll.items[j]);
				putLong_StrBuf(hbp, hashstr(vp->name));
			}
		}

		for (i = 0; i < count; ++i)
		{
			ClipHashBucket *buck = (ClipHashBucket *) coll.items[i];

			putLong_StrBuf(hbp, buck->hash);
			putLong_StrBuf(hbp, buck->offs);
		}
		for (i = 0; i < count; ++i)
		{
			char *s = (char *) file->names.items[i];

			putStr_StrBuf(hbp, s);
		}

		putByte_StrBuf(hbp, 0);
		hash_buckets_len = hbp->ptr - hbp->buf - 1;
		hash_buckets_buf = hbp->buf;

		destroy_Coll(&coll);
	}

	time(&timestamp);
	bp = new_StrBuf();
	*len = 0;

	if (getCount_Node(file->ctext) || getCount_Node(file->ctextStatic))
	{
		yyerror("cannot write PCODE module with c-texts");
		goto _ret;
	}

	out = fopen(file->cname, "wb");
	if (!out)
	{
		yyerror("cannot open output file '%s'", file->cname);
		goto _ret;
	}

	if (pc_flag)
	{
		fprintf(out, "/*\n");
		fprintf(out, " *\tfile '%s', \n", file->cname);
		fprintf(out, " *\tautomatically generated by clip\n");
		fprintf(out, " *\tfrom source %s\n", file->origname);
		fprintf(out, " *\tat %s", ctime(&timestamp));
		fprintf(out, " */\n\n");

#ifdef USE_AS
		if (asm_flag)
		{
			fprintf(out, "\t.file\t\"%s\"\n\n", file->cname);
		}
		else
#endif
		{
			fprintf(out, "#include \"clip.h\"\n\n");
		}

	}

	/* magic */
	write_StrBuf(bp, "!<pobj>\n", 8);
	/* 8 */
	putLong_StrBuf(bp, timestamp);
	modlen = CUROFFS;
	/* 8, 1l */
	putLong_StrBuf(bp, 0);
	modbeg = CUROFFS;
	/* 8,2l == modbeg */
	putLong_StrBuf(bp, 0);	/* static Offs */
	/* 8, 3l */
	putLong_StrBuf(bp, file->staticNo + 1);	/* 1 for init flag */
	/* 8,4l */
	putShort_StrBuf(bp, file->unsortedNumbers.count);
	/* 8,4l,1s */
	putShort_StrBuf(bp, file->unsortedStrings.count + 1);
	/* 8,4l,2s */
	putLong_StrBuf(bp, file->pubcount);
	/* 8,5l,2s */
	putLong_StrBuf(bp, file->allcount);
	/* 8,6l,2s */
	numOffs = CUROFFS;
	putShort_StrBuf(bp, 0);
	/* 8,6l,3s */
	strOffs = CUROFFS;
	putShort_StrBuf(bp, 0);
	/* 8,6l,4s */
	initOffs = CUROFFS;
	putLong_StrBuf(bp, 0);
	/* 8, 7l, 4s */
	funcOffs = CUROFFS;
	putLong_StrBuf(bp, 0);
	/* 8, 8l, 4s */
/* add */
	putShort_StrBuf(bp, file->initcount);
	putShort_StrBuf(bp, file->exitcount);
/* eadd */
	/* 8, 8l, 6s */
	putStr_StrBuf(bp, file->origname);
	SETSHORT(bp, numOffs, BEGOFFS);
	for (j = 0; j < file->unsortedNumbers.count; j++)
	{
		VAR(ConstNode, sp, file->unsortedNumbers.items[j]);
		putDouble_StrBuf(bp, strtod(sp->val, NULL));
	}
	for (j = 0; j < file->unsortedNumbers.count; j++)
	{
		VAR(ConstNode, sp, file->unsortedNumbers.items[j]);
		int dec = 0;
		char *s = strchr(sp->val, '.');
		int len = strlen(sp->val);

		if (s)
			dec = len - (s - sp->val) - 1;
		if (len < 10)
		{
			if ( dec > 0 )
				len = 11+dec;
			else
				len = 10;
		}
		/*if (dec < 2)
		   dec = 2; */
		if (dec > len)
			len = dec + 1;
		putByte_StrBuf(bp, len);
	}
	for (j = 0; j < file->unsortedNumbers.count; j++)
	{
		VAR(ConstNode, sp, file->unsortedNumbers.items[j]);
		int dec = 0;
		char *s = strchr(sp->val, '.');
		int len = strlen(sp->val);

		if (s)
			dec = len - (s - sp->val) - 1;
		if (len < 10)
			len = 10;
		/*if (dec < 2)
		   dec = 2; */
		if (dec > len)
			len = dec + 1;
		putByte_StrBuf(bp, dec);
	}

	count = file->unsortedStrings.count;
	SETSHORT(bp, strOffs, BEGOFFS);
	soffs = CUROFFS;
	for (j = 0; j < count + 1; j++)
	{
		putLong_StrBuf(bp, 0);
		putLong_StrBuf(bp, 0);
	}
	for (j = 0; j < count; j++)
	{
		VAR(ConstNode, sp, file->unsortedStrings.items[j]);
		int le = strlen(sp->val);

		/*int le = sp->len; */

		SETLONG(bp, soffs, le);
		LONGINCR(soffs);
		SETLONG(bp, soffs, BEGOFFS);
		LONGINCR(soffs);
		write_StrBuf(bp, sp->val, le + 1);
	}

	{
		SETLONG(bp, soffs, hash_buckets_len);
		LONGINCR(soffs);
		SETLONG(bp, soffs, BEGOFFS);
		LONGINCR(soffs);
		write_StrBuf(bp, hash_buckets_buf, hash_buckets_len + 1);
	}

	SETLONG(bp, initOffs, BEGOFFS);
	put_function(file, bp, file->init, 0);
	loffs = CUROFFS;
	SETLONG(bp, funcOffs, BEGOFFS);
	for (j = 0; j < file->allcount; ++j)
	{
		putLong_StrBuf(bp, 0);	/* hash */
		putLong_StrBuf(bp, 0);	/* offs */
	}
	for (j = 0; j < file->unsortedFunctions.count; ++j)
	{
		VAR(Function, fp, file->unsortedFunctions.items[j]);
		if (fp->isPublic == 1)
			put_function(file, bp, fp, &loffs);
	}
	for (j = 0; j < file->unsortedFunctions.count; ++j)
	{
		VAR(Function, fp, file->unsortedFunctions.items[j]);
		if (fp->isPublic == 2)
			put_function(file, bp, fp, &loffs);
	}
	for (j = 0; j < file->unsortedFunctions.count; ++j)
	{
		VAR(Function, fp, file->unsortedFunctions.items[j]);
		if (fp->isPublic == 3)
			put_function(file, bp, fp, &loffs);
	}
	for (j = 0; j < file->unsortedFunctions.count; ++j)
	{
		VAR(Function, fp, file->unsortedFunctions.items[j]);
		if (!fp->isPublic)
			put_function(file, bp, fp, &loffs);
	}
	for (j = 0; j < file->codeblocks.count; ++j)
	{
		VAR(Function, fp, file->codeblocks.items[j]);
		put_function(file, bp, fp, &loffs);
	}

	SETLONG(bp, modlen, BEGOFFS);

#ifdef USE_AS
	if (asm_flag)
	{
		char *mp;
		long j, modlen, size;
		char *name = strdup(file->name), *upname;
		char *s;

		s = strchr(name, '.');
		if (s)
			*s = 0;

		upname = strdup(name);
		for (i = 0; i < strlen(name); ++i)
			upname[i] = toupper(name[i]);

		fprintf(out, ".data\n");
		fprintf(out, "\t.align 4\n");
		/*fprintf(out, "\t.type %s_statics,@object\n", name);*/
		fprintf(out, "%s_statics:\n", name);

		for (i = 0; i < file->staticNo + 1; ++i)
		{
			fprintf(out, ".byte 0x0\n");
			fprintf(out, ".byte 0x0\n");
			fprintf(out, "\t.zero 2\n");
			fprintf(out, "\t.zero 12\n");
		}
/*		fprintf(out, "\t.size %s_statics,%d\n", name, (file->staticNo + 1) * sizeof(ClipVar));*/
		fprintf(out, ".section\t.rodata\n");
		/*fprintf(out, "\t.type %s_body,@object\n", name);*/
		fprintf(out, "%s_body:\n", name);

		mp = bp->buf;
		modlen = bp->ptr - bp->buf;
		size = 0;

		for (j = 0; j < modlen; j++)
			fprintf(out, ".byte %d\n", mp[j]);

/*		fprintf(out, "\t.size %s_body,%ld\n", name, modlen);*/

		fprintf(out, ".globl %sclip__PCODE_%s\n", US, upname);
		fprintf(out, ".data\n");
		fprintf(out, "\t.align 32\n");
		/*fprintf(out, "\t.type clip__PCODE_%s,@object\n", upname);*/
/*		fprintf(out, "\t.size clip__PCODE_%s,%d\n", upname, sizeof(ClipFile));*/
		fprintf(out, US"clip__PCODE_%s:\n", upname);

		fprintf(out, "\t.long 1\n");
		fprintf(out, "\t.long %s_body\n", name);
		fprintf(out, "\t.long %s_body\n", name);
		fprintf(out, "\t.long %ld\n", size);
		fprintf(out, "\t.long 3\n");
		fprintf(out, "\t.long .LC0\n");
		fprintf(out, "\t.long %s_statics\n", name);
		fprintf(out, "\t.long 3\n");
		fprintf(out, "\t.long %d\n", file->staticNo);
		fprintf(out, "\t.long 0\n");
		fprintf(out, "\t.long 0\n");
		fprintf(out, "\t.long 0\n");
		fprintf(out, "\t.long 0\n");
		fprintf(out, "\t.long 0\n");
		fprintf(out, "\t.long -1\n");

		fprintf(out, ".section\t.rodata\n");
		fprintf(out, ".LC0:\n\t.string \"%s\"\n", name);

		fprintf(out, ".data\n");

		fprintf(out, "\t.align 4\n");
		/*fprintf(out, "\t.type %s_cpfiles,@object\n", upname);*/
		fprintf(out, "%s_cpfiles:\n", upname);
		fprintf(out, "\t.long %sclip__PCODE_%s\n", US, upname);
		fprintf(out, "\t.long 0\n");
/*		fprintf(out, "\t.size %s_cpfiles,%d\n", upname, sizeof(ClipFile *) * 2);*/
/*		fprintf(out, ".globl %sclip__MODULE_%s\n", US, upname);*/
		fprintf(out, ".globl %sclip__MODULE_%s\n", US, file->mname);
		fprintf(out, "\t.align 32\n");
/*		fprintf(out, "\t.type clip__MODULE_%s,@object\n", upname);*/
/*		fprintf(out, "\t.size clip__MODULE_%s,%d\n", upname, sizeof(ClipModule));*/
/*		fprintf(out, US"clip__MODULE_%s:\n ", upname);      */
		fprintf(out, US"clip__MODULE_%s:\n ", file->mname);
		fprintf(out, "\t.long .LC0\n");
		fprintf(out, "\t.long 0\n");
		fprintf(out, "\t.long 0\n");
		fprintf(out, "\t.long 0\n");

		fprintf(out, "\t.long %s_cpfiles\n", upname);
		fprintf(out, "\t.long 0\n");
		fprintf(out, "\t.long 0\n");
		fprintf(out, "\t.long 0\n");

		free(name);
		free(upname);
	}
	else
#endif
	if (pc_flag)
	{
		char *mp;
		long j, k, modlen, size;
		char *name = strdup(file->name);
		char *s;

		s = strchr(name, '.');
		if (s)
			*s = 0;
		fprintf(out, "static ClipVar %s_statics[] =\n{\n", name);
		for (i = 0; i < file->staticNo + 1; ++i)
			fprintf(out, "\t{{0, 0}},\n");
		fprintf(out, "\n};\n");
		fprintf(out,"/*body1 of module %s*/\n",name);
		fprintf(out, "\nstatic const char %s_body[]=\n{\n", name);

		mp = bp->buf;
		modlen = bp->ptr - bp->buf;
		size = 0;
		j = 0;

		while (j < modlen)
		{
			fprintf(out, "\t");
			for (k = 0; k < 32 && j < modlen; ++j, ++k, ++size)
				fprintf(out, "%ld,", (long)mp[j]);
			fprintf(out, "\n");
		}

		fprintf(out, "\n};\n");
		fprintf(out, "\nstruct ClipFile clip__PCODE_");
		for (i = 0; i < strlen(name); ++i)
			fputc(toupper(name[i]), out);
		fprintf(out, " =\n{\n");
		fprintf(out, "\t1,\n");
		fprintf(out, "\t(char*)%s_body,\n", name);
		fprintf(out, "\t(char*)%s_body,\n", name);
		fprintf(out, "\t%ld,\n", size);
		fprintf(out, "\t3,\n");
		fprintf(out, "\t\"%s\",\n", /*arname */ name);
		fprintf(out, "\t%s_statics,\n", name);
		fprintf(out, "\t3,\n");
		fprintf(out, "\t%d,\n", file->staticNo);
		fprintf(out, "\t0,\n");
		fprintf(out, "\t0,\n");
		fprintf(out, "\t0,\n");
		fprintf(out, "\t0,\n");
		fprintf(out, "\t0,\n");
		fprintf(out, "\t-1,\n");
		fprintf(out, "};\n\n");

		for (i = 0; i < strlen(name); ++i)
			name[i] = toupper(name[i]);

		fprintf(out, "static ClipFile *%s_cpfiles[]=\n{\n", name);
		fprintf(out, "\t&clip__PCODE_%s,\n", name);
		fprintf(out, "\t0\n};\n");

/*		fprintf(out, "\nClipModule clip__MODULE_%s =\n{\n ", name);*/
		fprintf(out, "\nClipModule clip__MODULE_%s =\n{\n ", file->mname);
		fprintf(out, "\t\"%s\",\n", name);
		fprintf(out, "\t0,\n");
		fprintf(out, "\t0,\n");
		fprintf(out, "\t0,\n");
		/*fprintf(out, "\t&clip__PCODE_%s,\n", name); */

		fprintf(out, "\t%s_cpfiles,\n", name);
		fprintf(out, "\t0,\n");
		fprintf(out, "\t0,\n");
		fprintf(out, "\t0,\n");
		fprintf(out, "};\n\n");

		free(name);
	}
	else
	{
		for (s = bp->buf; s < bp->ptr; s += 4096)
		{
			int size = 4096, rest = bp->ptr - s;

			if (rest < 4096)
				size = rest;
			if (fwrite(s, size, 1, out) != 1)
			{
				yyerror("error writing file '%s', %s", file->cname, strerror(errno));
				break;
			}
		}
	}

	*len = ftell(out);
	fclose(out);
      _ret:
	delete_StrBuf(bp);
}

/* ] write PO file  */

char *
strsuff(const char *str, const char *suff)
{
	const char *e;
	int l = strlen(str);
	int ls = strlen(suff);

	for (e = str + l - ls; e >= str; e--)
		if (!memcmp(e, suff, ls))
			return (char *) e;
	return 0;
}

void
test_File(File * mp)
{
}

static void
add_name(Coll * cp, char *s)
{
	int no;

	if (!names_flag)
		return;
	if (!search_Coll(cp, s, &no))
		atInsert_Coll(cp, strdup(s), no);
}

static void
read_file(char *path, Coll * coll)
{
	FILE *f;
	char buf[128];

	f = fopen(path, "r");
	if (!f)
		return;

	while (fgets(buf, sizeof(buf), f))
	{
		int l;

		l = strlen(buf);
		while (l > 0 && (buf[l - 1] == '\n' || buf[l - 1] == '\r'))
			l--;
		buf[l] = 0;
		if (!l || buf[0] == '#')
			continue;

		add_name(coll, buf);
	}

	fclose(f);
}

static void
read_names(char *s, Coll * ex, Coll * nm)
{
	int al;
	char path[256], *e, *b;

	if (!names_flag)
		return;

	b = strrchr(s, '/');
	if (b)
		b++;
	else
		b = s;
	e = strchr(b, '.');

	if (e && (e > b))
		al = e - s;
	else
		al = strlen(s);

	snprintf(path, sizeof(path), "%s", s);
	snprintf(path + al, sizeof(path) - al, ".ex");
	read_file(path, ex);
	snprintf(path + al, sizeof(path) - al, ".nm");
	read_file(path, nm);
}


typedef struct
{
	long hash;
	int label;
	int branch;
	char *str;
}
Label;

static int
cmp_Label(void *p1, void *p2)
{
	Label *l1 = (Label *)p1;
	Label *l2 = (Label *)p2;

	if (l1->hash < l2->hash)
		return -1;
	else if (l1->hash > l2->hash)
		return 1;
	else
		return 0;
}

static Label *
new_Label(char *str)
{
	Label *ret;

	ret = (Label *)calloc(1, sizeof(Label));
	ret->hash = hashstr(str + 5);
	ret->str = str;


	return ret;
}


static void
print_tree(FILE *out, Coll *tree, int beg, int end)
{
	int med;
	Label *lp, *rp, *cp;

	if (beg>end)
		return;

	med = (beg+end)/2;

	fprintf(out, "#1234/%d/%d/%d\n", beg, med, end);

	if (beg == end)
	{
		cp = (Label*) tree->items[beg];

		/*fprintf(out, "\t.p2align 4,,7\n");*/
		fprintf(out, ".L%d:\n", cp->branch);
		fprintf(out, "\tcmpl $%ld,%%eax\n", cp->hash );
		fprintf(out, "\tje .L%d\n", cp->label);
		fprintf(out, "\tjmp .L1\n");
		return;
	}
	else if ( (beg+1) == med && (end-1) == med )
	{
		cp = (Label*) tree->items[med];
		lp = (Label*) tree->items[beg];
		rp = (Label*) tree->items[end];

		/*fprintf(out, "\t.p2align 4,,7\n");*/
		fprintf(out, ".L%d:\n", cp->branch);
		fprintf(out, "\tcmpl $%ld,%%eax\n", lp->hash );
		fprintf(out, "\tje .L%d\n", lp->label);
		fprintf(out, "\tcmpl $%ld,%%eax\n", cp->hash );
		fprintf(out, "\tje .L%d\n", cp->label);
		fprintf(out, "\tcmpl $%ld,%%eax\n", rp->hash );
		fprintf(out, "\tje .L%d\n", rp->label);

		fprintf(out, "\tjmp .L1\n");
		return;
	}
	else if (beg == (end-1))
	{
		cp = (Label*) tree->items[beg];
		rp = (Label*) tree->items[end];

		/*fprintf(out, "\t.p2align 4,,7\n");*/
		fprintf(out, ".L%d:\n", cp->branch);
		fprintf(out, "\tcmpl $%ld,%%eax\n", cp->hash );
		fprintf(out, "\tje .L%d\n", cp->label);
		fprintf(out, "\tcmpl $%ld,%%eax\n", rp->hash );
		fprintf(out, "\tje .L%d\n", rp->label);

		fprintf(out, "\tjmp .L1\n");
		return;
	}
	else
	{
		cp = (Label*) tree->items[med];
		lp = (Label*) tree->items[(beg+med-1)/2];
		rp = (Label*) tree->items[(med+1+end)/2];

		/*fprintf(out, "\t.p2align 4,,7\n");*/
		fprintf(out, ".L%d:\n", cp->branch);
		fprintf(out, "\tcmpl $%ld,%%eax\n", cp->hash );
		fprintf(out, "\tje .L%d\n", cp->label);
		fprintf(out, "\tcmpl $%ld,%%eax\n", cp->hash );
		fprintf(out, "\tjl .L%d\n", lp->branch);
		fprintf(out, "\tcmpl $%ld,%%eax\n", cp->hash );
		fprintf(out, "\tjg .L%d\n", rp->branch);

		fprintf(out, "\tjmp .L1\n");
	}

	print_tree(out, tree, beg, med-1);
	print_tree(out, tree, med+1, end);
}

static void
print_labels(FILE *out, Coll *tree)
{
	int i, count;

	for(i = 0, count = tree->count; i<count; i++)
	{
		Label *cp = (Label*) tree->items[i];
		/*fprintf(out, "\t.p2align 4,,7\n");*/
		fprintf(out, ".L%d:\n", cp->label);
		fprintf(out, "\tmovl $%s%s,%%eax\n", US, cp->str );
		fprintf(out, "\tjmp .L2\n");
	}
}

void
write_Cfunc(const char *name, int argc, char **argv, Coll * ex, Coll * nm)
{
	char buf[1024 * 8];
	char word1[80], word2[80], word3[80];
	int i, use_asm = 0, count;
	FILE *in = 0, *out = 0;
	int shared = shared_flag || eshared_flag;
	time_t tbuf;
	Coll names;
	Coll fnames;
	Coll dnames;
	Coll rnames;
	Coll objs;
	Coll libs;
	Coll nlibs, slibs;
	Coll alibs;
	int labn, labcn;

	init_Coll(&names, free, strcmp);
	init_Coll(&fnames, free, 0 /*strcmp */ );
	init_Coll(&dnames, free, strcmp);
	init_Coll(&rnames, free, strcmp);
	init_Coll(&objs, free, 0);
	init_Coll(&libs, free, 0);
	init_Coll(&nlibs, free, 0);
	init_Coll(&slibs, 0, strcmp);
	init_Coll(&alibs, 0, 0);

	strcpy(buf, NM_PRG);

	for (i = 0; i < argc; i++)
	{
		char *a = argv[i];

		if (a[0] == '-' && a[1] == 'l')
		{
			char path[256];

			snprintf(path, sizeof(path), "%s/lib/lib%s%s", CLIPROOT, a + 2, SLIBSUF);
			if (!access(path, R_OK))
				append_Coll(&libs, strdup(path));

			continue;
		}
		if (a[0] == '-')
		{
			continue;
		}
		if (strsuff(a, SLIBSUF) || strsuff(a, LIBSUF))
		{
			if (a[0] == '/' || (a[0] == '.' && a[1] == '/') || (a[0] == '.' && a[1] == '.' && a[2] == '/'))
			{
				append_Coll(&libs, strdup(a));
			}
			else
			{
				char path[256];

				snprintf(path, sizeof(path), "%s/lib/%s", CLIPROOT, a);
				if (!access(path, R_OK))
					append_Coll(&libs, strdup(path));
			}
		}
		else if (strsuff(a, SOBJSUF) || strsuff(a, OBJSUF))
			append_Coll(&objs, strdup(a));
	}

	for (i = libs.count - 1; i >= 0; i--)
	{
		char *s = (char *) libs.items[i];
		char *e, *r, *b;
		int l, j, ind, isA = 0;

		e = strsuff(s, SLIBSUF);

		if (!e)
		{
			e = strsuff(s, LIBSUF);
			isA = 1;
		}
		b = strrchr(s, '/');
		if (!b)
			b = s;
		else
			b++;
		if (e && e > b + 1)
			l = e - b;
		else
			l = strlen(b);
		r = (char *) malloc(l + 1);
		for (j = 0; j < l; j++)
		{
			switch (b[j])
			{
			case '-':
				r[j] = '_';
				break;
			default:
				r[j] = b[j];
				break;
			}
		}
		r[l] = 0;
		if (!search_Coll(&slibs, s, &ind))
		{
			insert_Coll(&slibs, r);
			if (isA)
			{
				append_Coll(&alibs, s);
				free(r);
			}
			else
				append_Coll(&nlibs, r);
		}
		else
			free(r);

		read_names(s, ex, nm);
	}

	if (!shared)
	{
		for (i = 0; i < libs.count; i++)
		{
			char *s = (char *) libs.items[i];

			strcat(buf, " ");
			strcat(buf, s);
		}
	}
	else
	{
		for (i = 0; i < alibs.count; i++)
		{
			char *s = (char *) alibs.items[i];

			strcat(buf, " ");
			strcat(buf, s);
		}
	}

	for (i = 0; i < objs.count; i++)
	{
		char *s = (char *) objs.items[i];

		strcat(buf, " ");
		strcat(buf, s);

		read_names(s, ex, nm);
	}

	v_printf(2, "%s\n", buf);

	in = popen(buf, "r");

	if (!in)
	{
		yyerror("cannot open pipe '%s'", buf);
		goto end;
	}

#ifdef USE_AS
	{
		char *s = strrchr(name, '.');

		if (asm_flag && s && !strcmp(s, ".s"))
			use_asm = 1;
	}
#endif

	out = fopen(name, "wb");
	if (!out)
	{
		yyerror("cannot open output file '%s'", name);
		goto end;
	}

	fprintf(out, "/*\n");
	fprintf(out, " *\tautomatically generated by clip-");
	printVersion(out);
	fprintf(out, "\n");
	time(&tbuf);
	fprintf(out, " *\tat %s", ctime(&tbuf));
	fprintf(out, " *\tfrom sources:\n");
	for (i = 0; i < argc; ++i)
		fprintf(out, " *\t%s\n", argv[i]);
	fprintf(out, " */\n");

	if (!use_asm)
	{
		fprintf(out, "\n#include \"clip.h\"\n");
	}
	else
	{
		fprintf(out, "\n\t.file \"%s\"\n", name);
	}

	while (fgets(buf, sizeof(buf), in) != NULL)
	{
		char *s, *sp;
		int br;
		int n = sscanf(buf, "%s %s %s", word1, word2, word3);
		int l;

		if (n == 3)
		{
			if (!strcmp(word2, "T"))
				br = 1;
			else if (!strcmp(word2, "D"))
				br = 2;
			else
				continue;
			sp = word3;
		}
		else if (n == 2)
		{
			if (strcmp(word1, "U"))
				continue;
			sp = word2;
			br = 3;
		}
		else
			continue;
#ifdef NM_UNDERSCORE
		sp++;
#endif
		l = strlen(sp);
		if (l < 6 || memcmp(sp, "clip_", 5))
			goto next;

		for (s = sp + 5; *s; ++s)
			if (!isupper(*s) && !isdigit(*s) && *s != '_')
				goto next;
		if (br == 2)
		{
			if (!memcmp(sp + 5, "_PCODE_", 7))
				insert_Coll(&fnames, strdup(sp));
			else if (!memcmp(sp + 5, "_RDD_", 4))
				insert_Coll(&dnames, strdup(sp));
			else if (!memcmp(sp + 5, "_RTTI_", 6))
				insert_Coll(&rnames, strdup(sp));
		}
		else
			insert_Coll(&names, strdup(sp));
	      next:
			;
	}
	if (in)
	{
		pclose(in);
		in = 0;
	}

	for (i = 0; i < names.count; ++i)
	{
		VAR(char, s, names.items[i]);

		if (!use_asm)
			fprintf(out, "ClipFunction %s;\n", s);
		add_name(nm, s);
	}

	if (shared)
	{
		for (i = nlibs.count - 1; i >= 0; i--)
		{
			char *s = (char *) nlibs.items[i];

			if (!use_asm)
				fprintf(out, "CLIP_DLLIMPORT ClipFunction *_clip_builtin_%s ( long hash );\n", s);
		}
	}

	labn = 3;
	labcn = 0;
	if (!use_asm)
	{
		fprintf(out, "\nstatic ClipFunction *\n_builtins(long hash)\n{\n");

		if (shared)
		{
			fprintf(out, "\tClipFunction *rp = 0;\n");
			for (i = nlibs.count - 1; i >= 0; i--)
			{
				char *s = (char *) nlibs.items[i];

				fprintf(out, "\trp = _clip_builtin_%s ( hash );\n", s);
				fprintf(out, "\tif ( rp )\n\t\treturn rp;\n");
			}
		}

		fprintf(out, "\n\tswitch( hash )\n\t{\n");
		for (i = 0; i < names.count; ++i)
		{
			VAR(char, s, names.items[i]);

			if (!memcmp(s + 5, "INIT_", 5) || !memcmp(s + 5, "EXIT_", 5))
				continue;
			fprintf(out, "\tcase 0x%lx:\n", hashstr(s + 5));
			fprintf(out, "\t\treturn %s;\n", s);
		}
		fprintf(out, "\tdefault:\n\t\treturn 0;\n");
		fprintf(out, "\t}\n");
		fprintf(out, "};\n\n");
	}
	else
	{

		fprintf(out, ".text\n\t.align 4\n");
/*		fprintf(out, "\t.type\t_builtins,@function\n");*/
		fprintf(out, US"_builtins:\n");

		fprintf(out, "\tpushl %%ebp\n");
		fprintf(out, "\tmovl %%esp,%%ebp\n");
#ifdef _WIN32
		fprintf(out, "\tsubl $36,%%esp\n");
		fprintf(out, "\tpushl %%ebx\n");
#else
		fprintf(out, "\tsubl $24,%%esp\n");
#endif
		fprintf(out, "\tmovl $0,-4(%%ebp)\n");

		if (shared)
		{
			for (i = nlibs.count - 1; i >= 0; i--)
			{
				char *s = (char *) nlibs.items[i];

				fprintf(out, "\taddl $-12,%%esp\n");
				fprintf(out, "\tmovl 8(%%ebp),%%eax\n");
				fprintf(out, "\tpushl %%eax\n");
#ifdef _WIN32
				fprintf(out, "\tmovl %s%s_clip_builtin_%s, %%ebx\n", IMP, US, s);
				fprintf(out, "\tcall *%%ebx\n");
#else
				fprintf(out, "\tcall %s%s_clip_builtin_%s\n", IMP, US, s);
#endif
				fprintf(out, "\taddl $16,%%esp\n");
				fprintf(out, "\tmovl %%eax,%%eax\n");
				fprintf(out, "\tmovl %%eax,-4(%%ebp)\n");
				fprintf(out, "\tcmpl $0,-4(%%ebp)\n");
				fprintf(out, "\tje .L%d\n", labn);
				fprintf(out, "\tmovl -4(%%ebp),%%edx\n");
				fprintf(out, "\tmovl %%edx,%%eax\n");
				fprintf(out, "\tjmp .L2\n");
				fprintf(out, "\t.p2align 4,,7\n");
				fprintf(out, ".L%d:\n", labn);
				labn++;
			}
		}
		if (names.count)
		{
			/* tree create */
			Coll tree;
			int i;

			init_Coll(&tree, free, cmp_Label);

			fprintf(out, "\tmovl 8(%%ebp),%%eax\n");

			for(i=0; i<names.count; i++)
				insert_Coll(&tree, new_Label((char*)(names.items[i])));

			for(i=0; i<tree.count; i++)
				((Label*)(tree.items[i]))->branch = labn++;
			for(i=0; i<tree.count; i++)
				((Label*)(tree.items[i]))->label = labn++;

			print_tree(out, &tree, 0, names.count-1);
			print_labels(out, &tree);

			destroy_Coll(&tree);
		}
		fprintf(out, "\t.p2align 4,,7\n");
		fprintf(out, ".L1:\n");
		fprintf(out, "\txorl %%eax,%%eax\n");
		fprintf(out, "\tjmp .L2\n");
		fprintf(out, "\t.p2align 4,,7\n");
		fprintf(out, ".L2:\n");
#ifdef _WIN32
			fprintf(out, "\tmovl -40(%%ebp),%%ebx\n");
			fprintf(out, "\tmovl %%ebp,%%esp\n");
			fprintf(out, "\tpopl %%ebp\n");
#else
			fprintf(out, "\tleave\n");
#endif
		fprintf(out, "\tret\n");

		fprintf(out, ".L%d:\n", labn);
/*		fprintf(out, "\t.size\t_builtins,.L%d-_builtins\n", labn);*/
		labn++;

	}

	if (!use_asm)
	{
		fprintf(out, "\nstatic ClipFunction *_inits[]=\n{\n");
	}
	else
	{
		fprintf(out, ".data\n");
		fprintf(out, "\t.align 4\n");
/*		fprintf(out, "\t.type\t_inits,@object\n");*/
		fprintf(out, US"_inits:\n");
	}

	/* CLIPINIT, if defined, _must_ be first */
	count = 0;
	for (i = 0; i < names.count; ++i)
	{
		VAR(char, s, names.items[i]);

		if (strcmp(s + 5, "INIT_CLIPINIT"))
			continue;
		if (!use_asm)
			fprintf(out, "\t%s,\n", s);
		else
			fprintf(out, "\t.long %s%s\n", US, s);
		count++;
	}
	for (i = 0; i < names.count; ++i)
	{
		VAR(char, s, names.items[i]);

		if (memcmp(s + 5, "INIT_", 5) || !strcmp(s + 5, "INIT_CLIPINIT"))
			continue;
		if (!use_asm)
			fprintf(out, "\t%s,\n", s);
		else
			fprintf(out, "\t.long %s%s\n", US, s);
		count++;
	}
	if (!use_asm)
	{
		fprintf(out, "\t0,\n");
		fprintf(out, "};\n\n");
	}
	else
	{
		fprintf(out, "\t.long 0\n");
/*		fprintf(out, "\t.size _inits,%d\n", (count + 1) * sizeof(ClipFunction *));*/
	}

	if (!use_asm && shared)
	{
		for (i = 0; i < nlibs.count; ++i)
		{
			VAR(char, s, nlibs.items[i]);

			fprintf(out, "CLIP_DLLIMPORT extern ClipFunction **_libinits_%s;\n", s);
		}
	}

	if (!use_asm)
		fprintf(out, "\nstatic ClipFunction ***_libinits[]=\n{\n");
	else
	{
		fprintf(out, "\t.align 4\n");
/*		fprintf(out, "\t.type\t_libinits,@object\n");*/
		fprintf(out, US"_libinits:\n");
	}

	if (shared)
	{
		for (i = 0; i < nlibs.count; ++i)
		{
			if (!use_asm)
				fprintf(out, "\t0,\n");
			else
				fprintf(out, "\t.long 0\n");
		}
	}
	if (!use_asm)
	{
		fprintf(out, "\t0,\n");
		fprintf(out, "};\n\n");
	}
	else
	{
		fprintf(out, "\t.long 0\n");
/*		fprintf(out, "\t.size _libinits,%d\n", ((shared ? nlibs.count : 0) + 1) * sizeof(ClipFunction ***));*/
	}

	if (!use_asm)
	{
		fprintf(out, "\nstatic ClipFunction *_exits[]=\n{\n");
	}
	else
	{
		fprintf(out, "\t.align 4\n");
/*		fprintf(out, "\t.type\t_exits,@object\n");*/
		fprintf(out, US"_exits:\n");
	}

	count = 0;
	for (i = 0; i < names.count; ++i)
	{
		VAR(char, s, names.items[i]);

		if (memcmp(s + 5, "EXIT_", 5))
			continue;
		if (!use_asm)
			fprintf(out, "\t%s,\n", s);
		else
			fprintf(out, "\t.long %s\n", s);
		count++;
	}
	if (!use_asm)
	{
		fprintf(out, "\t0\n");
		fprintf(out, "};\n\n");
	}
	else
	{
		fprintf(out, "\t.long 0\n");
/*		fprintf(out, "\t.size _exits,%d\n", (count + 1) * sizeof(ClipFunction *));*/
	}

	if (!use_asm && shared)
	{
		for (i = 0; i < nlibs.count; ++i)
		{
			VAR(char, s, nlibs.items[i]);

			fprintf(out, "CLIP_DLLIMPORT extern ClipFunction **_libexits_%s;\n", s);
		}
	}
	if (!use_asm)
		fprintf(out, "\nstatic ClipFunction ***_libexits[]=\n{\n");
	else
	{
		fprintf(out, "\t.align 4\n");
/*		fprintf(out, "\t.type\t_libexits,@object\n");*/
		fprintf(out, US"_libexits:\n");
	}

	if (shared)
	{
		for (i = 0; i < nlibs.count; ++i)
		{
			if (!use_asm)
				fprintf(out, "\t0,\n");
			else
				fprintf(out, "\t.long 0\n");
		}
	}
	if (!use_asm)
	{
		fprintf(out, "\t0,\n");
		fprintf(out, "};\n\n");
	}
	else
	{
		fprintf(out, "\t.long 0\n");
/*		fprintf(out, "\t.size _libexits,%d\n", (nlibs.count + 1) * sizeof(ClipFunction ***));*/
	}

	if (!use_asm)
		fprintf(out, "\nstatic const char *_pfunctions[]=\n{\n");
	else
	{
		fprintf(out, "\t.align 4\n");
/*		fprintf(out, "\t.type\t_pfunctions,@object\n");*/
/*		fprintf(out, "\t.size\t_pfunctions,%d\n", (poName.count + paName.count + 1) * sizeof(char *));*/
		fprintf(out, US"_pfunctions:\n");
	}
	count = 0;
	for (i = 0; i < poName.count; ++i)
	{
		VAR(char, name, poName.items[i]);

		if (!use_asm)
			fprintf(out, "\t\"%s\",\n", name);
		else
			fprintf(out, "\t.long .LC%d\n", labcn + count);
		count++;
	}
	for (i = 0; i < paName.count; ++i)
	{
		VAR(char, name, paName.items[i]);

		if (!use_asm)
			fprintf(out, "\t\"%s\",\n", name);
		else
			fprintf(out, "\t.long .LC%d\n", labcn + count);
		count++;
	}
	if (!use_asm)
	{
		fprintf(out, "\t0\n");
		fprintf(out, "};\n\n");
	}
	else
	{
		fprintf(out, "\t.long 0\n");
		if (count)
		{
			fprintf(out, ".section\t.rodata\n");
			count = 0;
			for (i = 0; i < poName.count; ++i)
			{
				VAR(char, name, poName.items[i]);

				fprintf(out, ".LC%d:\n\t.string \"%s\"\n", labcn + count, name);
				count++;
			}
			for (i = 0; i < paName.count; ++i)
			{
				VAR(char, name, paName.items[i]);

				fprintf(out, ".LC%d:\n\t.string \"%s\"\n", labcn + count, name);
				count++;
			}
			fprintf(out, ".data\n");
			labcn += count;
		}
	}

	if (!use_asm)
	{
		for (i = 0; i < fnames.count; ++i)
		{
			VAR(char, s, fnames.items[i]);

			fprintf(out, "extern ClipFile %s;\n", s);
		}
	}

	if (!use_asm)
	{
		fprintf(out, "\nstatic struct ClipFile *_cpfiles[]=\n");
		fprintf(out, "{\n");
	}
	else
	{
		fprintf(out, "\t.align 4\n");
/*		fprintf(out, "\t.type\t_cpfiles,@object\n");*/
		fprintf(out, US"_cpfiles:\n");
	}

	for (i = 0; i < fnames.count; ++i)
	{
		VAR(char, s, fnames.items[i]);

		if (!use_asm)
			fprintf(out, "\t&%s,\n", s);
		else
			fprintf(out, "\t.long %s%s\n", US, s);
	}
	if (!use_asm)
	{
		fprintf(out, "\t0\n");
		fprintf(out, "};\n\n");
	}
	else
	{
		fprintf(out, "\t.long 0\n");
/*		fprintf(out, "\t.size _cpfiles,%d\n", (fnames.count + 1) * sizeof(ClipFile *));*/
	}

	if (!use_asm && shared)
	{
		for (i = 0; i < nlibs.count; ++i)
		{
			VAR(char, s, nlibs.items[i]);

			fprintf(out, "CLIP_DLLIMPORT extern ClipFile **_libcpfiles_%s;\n", s);
		}
	}
	if (!use_asm)
		fprintf(out, "\nstatic ClipFile ***_libcpfiles[]=\n{\n");
	else
	{
		fprintf(out, "\t.align 4\n");
/*		fprintf(out, "\t.type\t_libcpfiles,@object\n");*/
		fprintf(out, US"_libcpfiles:\n");
	}
	if (shared)
	{
		for (i = 0; i < nlibs.count; ++i)
		{
			if (!use_asm)
				fprintf(out, "\t0,\n");
			else
				fprintf(out, "\t.long 0\n");
		}
	}
	if (!use_asm)
	{
		fprintf(out, "\t0,\n");
		fprintf(out, "};\n\n");
	}
	else
	{
		fprintf(out, "\t.long 0\n");
/*		fprintf(out, "\t.size _cpfiles,%d\n", ((shared ? nlibs.count : 0) + 1) * sizeof(ClipFile *));*/
	}

	if (!use_asm)
	{
		for (i = 0; i < dnames.count; ++i)
		{
			VAR(char, s, dnames.items[i]);

			fprintf(out, "extern struct DBFuncTable %s;\n", s);
		}
	}

	if (!use_asm)
	{
		fprintf(out, "\nstatic struct DBFuncTable *_dbdrivers[]=\n");
		fprintf(out, "{\n");
	}
	else
	{
		fprintf(out, "\t.align 4\n");
/*		fprintf(out, "\t.type\t_dbdrivers,@object\n");*/
		fprintf(out, US"_dbdrivers:\n");
	}

	for (i = 0; i < dnames.count; ++i)
	{
		VAR(char, s, dnames.items[i]);

		if (!use_asm)
			fprintf(out, "\t&%s,\n", s);
		else
			fprintf(out, "\t.long %s\n", s);
	}

	if (!use_asm)
	{
		fprintf(out, "\t0\n");
		fprintf(out, "};\n\n");
	}
	else
	{
		fprintf(out, "\t.long 0\n");
/*		fprintf(out, "\t.size _dbdrivers,%d\n", (dnames.count + 1) * sizeof(DBFuncTable *));*/
	}

	if (!use_asm)
	{
		for (i = 0; i < rnames.count; ++i)
		{
			VAR(char, s, rnames.items[i]);

			fprintf(out, "extern struct ClipObjRtti %s;\n", s);
		}

		fprintf(out, "\nstatic struct ClipObjRtti *_objrtti[]=\n");
		fprintf(out, "{\n");
	}
	else
	{
		fprintf(out, "\t.align 4\n");
/*		fprintf(out, "\t.type\t_objrtti,@object\n");*/
		fprintf(out, US"_objrtti:\n");
	}

	for (i = 0; i < rnames.count; ++i)
	{
		VAR(char, s, rnames.items[i]);

		if (!use_asm)
			fprintf(out, "\t&%s,\n", s);
		else
			fprintf(out, "\t.long %s\n", s);
	}
	if (!use_asm)
	{
		fprintf(out, "\t0\n");
		fprintf(out, "};\n\n");
	}
	else
	{
		fprintf(out, "\t.long 0\n");
/*		fprintf(out, "\t.size _objrtti,%d\n", (rnames.count + 1) * sizeof(ClipObjRtti *));*/
	}

	if (!use_asm)
	{
		fprintf(out, "static ClipInitStruct _init_struct =\n{\n");
		fprintf(out, "\t_builtins,\n");
		fprintf(out, "\t_inits,\n\t_libinits,\n\t_exits,\n\t_libexits,\n\t_pfunctions,\n");
		fprintf(out, "\t_cpfiles,\n\t_libcpfiles,\n\t_objrtti,\n\t(void**)_dbdrivers,\n");
		fprintf(out, "\t\"%s\"\n", targetCharset);
		fprintf(out, "};\n\n");
		fprintf(out, "%svoid _clip_init_struct(ClipInitStruct *sp);\n", shared ? "CLIP_DLLIMPORT " : "");
		fprintf(out, "void\n_clip_init_dll(void)\n{\n");
		if (shared)
		{
			for (i = 0; i < nlibs.count; ++i)
			{
				VAR(char, s, nlibs.items[i]);

				fprintf(out, "\t_libinits[%d] = &_libinits_%s,\n", i, s);
				fprintf(out, "\t_libexits[%d] = &_libexits_%s,\n", i, s);
				fprintf(out, "\t_libcpfiles[%d] = &_libcpfiles_%s,\n", i, s);
			}
		}
		fprintf(out, "\t_clip_init_struct(&_init_struct);\n");
		fprintf(out, "}\n\n");
	}
	else
	{
/*		fprintf(out, "\t.type\t_init_struct,@object\n");*/
/*		fprintf(out, "\t.size\t_init_struct,%d\n", sizeof(ClipInitStruct));*/
		fprintf(out, US"_init_struct:\n");

		fprintf(out, "\t.long %s_builtins\n", US);
		fprintf(out, "\t.long %s_inits\n", US);
		fprintf(out, "\t.long %s_libinits\n", US);
		fprintf(out, "\t.long %s_exits\n", US);
		fprintf(out, "\t.long %s_libexits\n", US);
		fprintf(out, "\t.long %s_pfunctions\n", US);
		fprintf(out, "\t.long %s_cpfiles\n", US);
		fprintf(out, "\t.long %s_libcpfiles\n", US);
		fprintf(out, "\t.long %s_objrtti\n", US);
		fprintf(out, "\t.long %s_dbdrivers\n", US);
		fprintf(out, "\t.long .LC%d\n", labcn);

		fprintf(out, ".section\t.rodata\n");
		fprintf(out, ".LC%d:\n\t.string \"%s\"\n", labcn, targetCharset);
		labcn++;

		fprintf(out, ".text\n");
		fprintf(out, "\t.align 4\n");
		fprintf(out, ".globl %s_clip_init_dll\n", US);
/*		fprintf(out, "\t.type _clip_init_dll,@function\n");*/
		fprintf(out, US"_clip_init_dll:\n");

		fprintf(out, "\tpushl %%ebp\n");
		fprintf(out, "\tmovl %%esp,%%ebp\n");
#ifdef _WIN32
		fprintf(out, "\tsubl $20,%%esp\n");
		fprintf(out, "\tpushl %%ebx\n");
#else
		fprintf(out, "\tsubl $8,%%esp\n");
#endif
		if (shared)
		{
			for (i = 0; i < nlibs.count; ++i)
			{
				VAR(char, s, nlibs.items[i]);

#ifdef _WIN32
				fprintf(out, "\tmovl %s%s_libinits_%s,%%eax\n", IMP, US, s);
				fprintf(out, "\tmovl %%eax,%s_libinits+%d\n", US, i * sizeof(ClipFunction ***));

				fprintf(out, "\tmovl %s%s_libexits_%s,%%eax\n", IMP, US, s);
				fprintf(out, "\tmovl %%eax,%s_libexits+%d\n", US, i * sizeof(ClipFunction ***));

				fprintf(out, "\tmovl %s%s_libcpfiles_%s,%%eax\n", IMP, US, s);
				fprintf(out, "\tmovl %%eax,%s_libcpfiles+%d\n", US, i * sizeof(ClipFile ***));
#else
				fprintf(out, "\tmovl $%s%s_libinits_%s,%s_libinits+%ld\n", IMP, US, s, US, (long)(i * sizeof(ClipFunction ***)));
				fprintf(out, "\tmovl $%s%s_libexits_%s,%s_libexits+%ld\n", IMP, US, s, US, (long)(i * sizeof(ClipFunction ***)));
				fprintf(out, "\tmovl $%s%s_libcpfiles_%s,%s_libcpfiles+%ld\n", IMP, US, s, US, (long)(i * sizeof(ClipFile ***)));
#endif
			}
		}
		fprintf(out, "\taddl $-12,%%esp\n");
		fprintf(out, "\tpushl $%s_init_struct\n", US);
		fprintf(out, "\tcall %s_clip_init_struct\n", US);
		fprintf(out, "\taddl $16,%%esp\n");
#ifdef _WIN32
			fprintf(out, "\tmovl -24(%%ebp),%%ebx\n");
			fprintf(out, "\tmovl %%ebp,%%esp\n");
			fprintf(out, "\tpopl %%ebp\n");
#else
			fprintf(out, "\tleave\n");
#endif
		fprintf(out, "\tret\n");
		fprintf(out, ".L%d:\n", labn);
/*		fprintf(out, "\t.size	 _clip_init_dll,.L%d-_clip_init_dll\n", labn);*/
		labn++;
	}

	if ((pcode_flag || pc_flag || !main_flag) && !wrote_main)
	{

		if (!use_asm)
		{
			fprintf(out, "\n\
\n\
extern char **environ;\n\
\n\
int\n\
main(int argc, char **argv)\n\
{\n\
	ClipMachine *mp;\n\
	_clip_init_dll();\n\
\n\
	mp = new_ClipMachine(0);\n\
	return _clip_main(mp, 0x%lx, argc, argv, environ);\n\
}\n\
", hashstr("MAIN"));

		}
		else
		{
			fprintf(out, "\t.align 4\n");
			fprintf(out, ".globl %smain\n",US);
/*			fprintf(out, "\t.type	 main,@function\n");*/
			fprintf(out, US"main:\n");
			fprintf(out, "\tpushl %%ebp\n");
			fprintf(out, "\tmovl %%esp,%%ebp\n");
			fprintf(out, "\tsubl $24,%%esp\n");
#ifdef _WIN32
			fprintf(out, "\tcall ___main\n");
#endif
			fprintf(out, "\tcall %s_clip_init_dll\n",US);
			fprintf(out, "\taddl $-12,%%esp\n");
			fprintf(out, "\tpushl $0\n");
			fprintf(out, "\tcall %snew_ClipMachine\n",US);
			fprintf(out, "\taddl $16,%%esp\n");
			fprintf(out, "\tmovl %%eax,-4(%%ebp)\n");
			fprintf(out, "\taddl $-12,%%esp\n");
			fprintf(out, "\tmovl %senviron,%%eax\n", US);
			fprintf(out, "\tpushl %%eax\n");
			fprintf(out, "\tmovl 12(%%ebp),%%eax\n");
			fprintf(out, "\tpushl %%eax\n");
			fprintf(out, "\tmovl 8(%%ebp),%%eax\n");
			fprintf(out, "\tpushl %%eax\n");
			fprintf(out, "\tpushl $%ld\n", hashstr("MAIN"));
			fprintf(out, "\tmovl -4(%%ebp),%%eax\n");
			fprintf(out, "\tpushl %%eax\n");
			fprintf(out, "\tcall %s_clip_main\n", US);
			fprintf(out, "\taddl $32,%%esp\n");
			fprintf(out, "\tmovl %%eax,%%edx\n");
			fprintf(out, "\tmovl %%edx,%%eax\n");
			fprintf(out, "\tjmp .L%d\n", labn);
/*			fprintf(out, "\t.p2align 4,,7\n");*/
			fprintf(out, "\t.align 4\n");
			fprintf(out, ".L%d:\n", labn);
			labn++;
#ifdef _WIN32
			fprintf(out, "\tmovl %%ebp,%%esp\n");
			fprintf(out, "\tpopl %%ebp\n");
#else
			fprintf(out, "\tleave\n");
#endif
			fprintf(out, "\tret\n");
			fprintf(out, ".L%d:\n", labn);
/*			fprintf(out, "\t.size	 main,.L%d-main\n", labn);*/

		}
	}

      end:
	if (in)
		pclose(in);
	if (out)
		fclose(out);
	destroy_Coll(&names);
	destroy_Coll(&fnames);
	destroy_Coll(&dnames);
	destroy_Coll(&objs);
	destroy_Coll(&libs);
	destroy_Coll(&nlibs);
	destroy_Coll(&slibs);
	destroy_Coll(&alibs);
}
