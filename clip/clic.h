/*
    Copyright (C) 2001  ITK
    Author   : Paul Lasarev <paul@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
 * $Log$
 * Revision 1.1  2006/06/22 19:35:15  itk
 * uri: init sf.net repository
 *
 * Revision 1.47  2005/08/25 08:36:33  clip
 * uri: small fix for AMD64 (added -fPIC option for gcc)
 *
 * Revision 1.46  2005/07/07 12:32:53  clip
 * uri: small fix for gcc4
 *
 * Revision 1.45  2003/05/16 11:08:01  clip
 * initial support for using assembler instead C
 * now activated if environment variable CLIP_ASM is defined to any value
 * paul
 *
 * Revision 1.44  2003/03/25 14:20:59  clip
 * uri: *gettext changed to _clic_*gettext
 *
 * Revision 1.43  2002/11/12 10:51:51  clip
 * convert charset of output messages
 * paul
 *
 * Revision 1.42  2002/10/31 10:33:59  clip
 * plural form runtime messages support:
 * gettext(cMsgid [,cModule])->cTranslated
 * ngettext(cMsgid, cMsgid_plural, nNum, [,cModule]) ->cTranslated
 * paul
 *
 * Revision 1.41  2002/10/30 12:17:26  clip
 * support for plural forms in i18n messages
 * paul
 *
 * Revision 1.40  2002/10/25 11:54:33  clip
 * localized messages for clip itself
 * paul
 *
 * Revision 1.39  2002/10/11 10:27:11  clip
 * primary support for search of unresolved function names:
 * clip compler flag -N and/or envar CLIP_NAMES=yes will generate
 * files .ex (external refs) and .nm (defined names)
 * clip_makeslib will join .ex and .nm files if CLIP_NAMES=yes
 * new util clip_makelib also will join .ex .nm
 * new util clip_cp may be used to copy lib/obj files and correspond
 * .ex .nm files automatic
 * Closes: #17
 * paul
 *
 * Revision 1.38  2002/09/25 11:47:25  clip
 * add function: loadModuleMsg(cModule, cFilename_mo) -> bResult
 * predefined macro: __CLIP_MODULE__  expands to current module name as "modname"
 * new accepted environment var: CLIP_LOCALE_ROOT
 * 	used by clip, clip_msgmerge, clip_msgfmt, and at runtime
 * paul
 *
 * Revision 1.37  2002/08/08 09:33:24  clip
 * preproc fix for define/command priority
 * paul
 *
 * Revision 1.36  2002/03/02 11:24:54  clip
 * add compatability option:
 * -q <word>
 * --compat=<word>
 * possible words:
 * 	as-word  	- default value
 *         no-as-word
 * paul
 *
 * Revision 1.35  2002/01/18 09:47:10  clip
 * -d<outdir>, --outdir=<outdir> option
 * -o<oname> work correct
 * fw install fix
 * paul
 *
 * Revision 1.34  2002/01/07 07:26:35  clip
 * AS syntax cleanup
 * paul
 *
 * Revision 1.33  2002/01/05 12:50:47  clip
 * LOCAL a,b AS typename
 * STATIC a,b AS typename
 * func( a AS typename, b)
 * recognized, but yet not used
 * paul
 *
 * Revision 1.32  2001/12/18 09:42:41  clip
 * memvar/private declarations may be mixed
 * paul
 *
 * Revision 1.31  2001/10/08 09:07:45  clip
 * expr match
 *
 * Revision 1.30  2001/09/28 09:55:44  clip
 * add compiler pragma:
 * *reference [name1 ... nameN]
 * to force call-by-reference for function's  name1..nameN arguments
 * paul
 *
 * Revision 1.29  2001/09/27 06:44:24  clip
 * add -R (--noremove-c) option, defaults to remove temporary .c files
 * paul
 *
 * Revision 1.28  2001/09/21 09:53:24  clip
 * charsets handling
 * paul
 *
 * Revision 1.27  2001/09/20 13:09:59  clip
 * add long options
 * paul
 *
 * Revision 1.26  2001/09/10 05:32:05  clip
 * _clip_par_*   functions
 * paul
 *
 * Revision 1.25  2001/09/08 07:16:23  clip
 * paths
 * paul
 *
 * Revision 1.24  2001/09/06 12:17:30  clip
 * cygwin
 * paul
 *
 * Revision 1.23  2001/09/05 05:30:26  clip
 * CODEBLOCK/CODESTR now can have paramters, f.e:
 * CODESTR(|a| f->first==a) will generate string
 * {|A|FIELD->FIRST==A}
 * paul
 *
 * Revision 1.22  2001/08/30 14:37:53  clip
 * new library binding
 * paul
 *
 * Revision 1.21  2001/08/27 09:45:30  clip
 * switch operator
 * paul
 *
 * Revision 1.20  2001/08/26 09:10:06  clip
 * references
 * paul
 *
 * Revision 1.19  2001/08/24 14:38:46  clip
 * CODESTR pseudofunction
 * paul
 *
 * Revision 1.18  2001/08/23 13:52:06  clip
 * merge with NEWLOCALS
 * paul
 *
 * Revision 1.17.2.4  2001/08/21 13:00:37  clip
 * fix
 * paul
 *
 * Revision 1.17.2.3  2001/08/21 12:10:35  clip
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
 * Revision 1.17.2.2  2001/08/20 12:32:09  clip
 * macro in blocks
 * paul
 *
 * Revision 1.17.2.1  2001/08/20 10:43:09  clip
 * macro in blocks
 * paul
 *
 * Revision 1.17  2001/04/11 06:49:02  clip
 * main.prg
 * paul
 *
 * Revision 1.16  2001/04/03 09:17:00  clip
 * license errors
 * paul
 *
 * Revision 1.15  2001/03/30 11:51:02  clip
 * add copyright
 *
 * Revision 1.14  2000/12/26 10:03:42  clip
 * load now can load .so
 * -s generate .so
 * paul
 *
 * Revision 1.13  2000/12/08 11:55:27  clip
 * start localisation
 * paul
 *
 * Revision 1.12  2000/12/06 13:13:00  clip
 * loadable charset tables. size 256
 * paul
 *
 * Revision 1.11  2000/12/02 13:47:40  clip
 * CLIPROOT now may be envar
 * paul
 *
 * Revision 1.10  2000/05/25 16:00:36  clip
 * macro in codeblocks
 * break
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.9  2000/05/24 18:34:04  clip
 * _clip_push_area
 * indents all
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.8  2000/05/20 18:37:24  clip
 * change hash function
 * append HASH_xxxx extraction into hashcode.h
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.7  2000/05/03 19:32:30  clip
 * add prefix 'clip_' to all clip functions
 *
 * Revision 1.6  2000/04/10 20:21:57  paul
 * $HOME/.cliprc
 *
 * Revision 1.5  2000/04/07 18:23:14  paul
 * -a flag
 *
 * Revision 1.4  2000/03/22 17:11:50  paul
 * parameters by reference
 *
 * Revision 1.3  2000/03/20 18:59:43  paul
 * __field__ directive
 *
 * Revision 1.2  2000/03/16 19:29:09  paul
 * f->m-> , m->f-> fixed
 *
 * Revision 1.1  1999/10/25 16:39:27  paul
 * first entry
 *
 */

#ifndef YUVM_H
#define YUVM_H

#include <stdio.h>
#include <ctype.h>

#include "clitypes.h"
#include "coll.h"
#include "node.h"
#include "cliphash.h"

extern int clic_errorcount, clic_warncount;
extern int preproc_flag, pcode_flag, pc_flag, asm_flag;
extern int command_flag, main_flag;
extern const char *std_ch_filename;
extern Coll include_files;
extern int namespace_warning;
extern int nomain_flag;
extern int ifexpr_flag;
extern int iif_expr;
extern int field_flag;
extern int auto_memvar;
extern char *clic_charset;
extern int rmc_flag;
extern char *outdir;

int clic_parse(const char *filename, FILE * stream);
int yyerror(const char *s,...);
int yywarning(const char *s,...);
int yyparse();
int yylex();
int v_printf(int level, const char *fmt,...);
int vr_printf(int level, const char *fmt,...); /* raw version */
extern int v_neednl;

void printVersion(FILE * file);

#define hashstr(x) _clip_hashstr(x)

/* lex analizer part */

int lex_new_file(FILE * file, const char *filename);
void init_lex();
void resume_lex();
void clear_lex();
int get_include(int *index, int *line, char **filename);
extern Coll includePaths;
extern Coll predefines;
extern Coll poName;
extern Coll paName;
extern Coll lib_dirs;
extern Coll reffuncs;

 /* return 0 if no more files; on first call index must be -1, then will keep
    state */
int currentFile();
char *fileName(int file);

void print_Var(Var * vp, int level);
void fprintfOffs(FILE * out, int offs, const char *format,...);

extern long clic_line, corr_line, all_lines, clic_pos, cl_line, cl_pos;
extern int clic_notexpand_macro;

extern Coll fileList;

extern VarColl *curStatics, *fileStatics;

 /* keep incremental file name list */

void printString(FILE * stream, const char *str);
void assign_String(char **oldstr, char *newstr);
void assign_constString(char **oldstr, const char *newstr);

typedef struct Function
{
	char *name;
	VarColl *params;
	VarColl *locals;
	VarColl *statics;
	VarColl *memvars;
	VarColl *fields;
	VarColl *fmemvars;
	VarColl *parameters;
	VarColl *privates;
	VarColl *publics;

	struct File *File;

	Node *body;
	Node *staticInit;
	int isPublic,		/* 0-static; 1-public; 2-init; 3-exit */
	 isProc:1, isMain:1, lastExec:1
	;
	int maxdeep;
	int deep;
	int line;
	int file;
	int no;
	int offs;
	int goto_trap;
	int mno;
	int labelNo;
	int inLoop;
	int seqNo;
	int allSeqNo;
	int seqLevel;
	int *seqStack;
	int haveSelf;

	struct Function *upfunc;
	int reflocals;
	int nlocals;
	int uplocals;

	int haveIf;
	int haveReturn;
	int isCodeblock;
	VarColl *code_params;

	char *typename;
}
Function;

typedef struct File
{
	char *name;
	char *cname;
	char *s_cname;
	char *mname;
	char *origname;

	Coll functions;
	Coll unsortedFunctions;
	Coll externFunctions;
	Coll undeclExternFunctions;
	Coll externModules;

	Coll numbers;
	Coll unsortedNumbers;
	Coll strings;
	Coll unsortedStrings;

	Coll codeblocks;

	Function *main;
	Function *init;
	Node *ctext;
	Node *ctextStatic;
	int seq_no;
	int staticNo;
	int pubcount;
	int allcount;
	int initcount;
	int exitcount;

	Coll names;

	int haveNil;
	int haveTrue;
	int haveFalse;
}
File;

typedef struct
{
	Coll *labels;
	Node *operlist;
	int offs;
	int end;
}
SwitchEl;


extern int genDebug;
/*extern int optLevel;*/
extern int vmLongJmps;
extern int verbose;

File *new_File(char *name);
void delete_File(File * file);

void add_Function(File * file, Function * func);
void print_File(File * file);
void codegen_File(File * file);
void write_File(File * file);
void write_OFile(File * file, long *len);
void compile_File(const char *name);
void share_File(const char *name);
void test_File(File * mp);
void write_Cfunc(const char *fname, int num, char **vect, Coll *ex, Coll *nm);

void add_HashName(long hash, const char *name);
const char *get_HashName(long hash);

Function *new_Function(char *name, VarColl * params, int isPublic, int isMain, Function * upfunc, int isCodeblock);
void delete_Function(void *f);
int equal_Function(Function * f1, Function * f2);

extern char *clic_outpath;

extern File *curFile;
extern Function *curFunction, *mainFunction;

extern Coll *fileIncludes;

void init_parser();
void resume_parser();

Node *installName(char *name);
int undeclaredName(const char *name, int memvar);
void add_self(void);

Node *genAssign(char *name, Node * expr, int in_line);
Node *genCall(const char *name, Node * exprlist);

char *getName(const char *name);
char *setName(const char *name);
char *GetName(char *name);
char *SetName(char *name);

extern int traplevel;

void printCString(FILE * file, char *str);

/* recode str into appropiate charset */
void recodeString(char *str);

extern char *sourceCharset;
extern char *targetCharset;
extern int changeCharset;
extern char *out_charset;


extern char *CC, *COMPILE_FLAG, *CFLAGS, *ADDCFLAGS, *COPT, *CDBG, *OUT_FLAG,
	*INCLUDE_FLAG, *OBJSUF, *LIBSUF, *SLIBSUF, *SOBJSUF, *SFLAGS;
extern char *CLIPLIB, *CLIPSLIB;
extern char *CLIPROOT;
extern char *CLIP_MODULE;
extern char *CLIP_LOCALE_ROOT;

int put_locale_string(char *name);
int put_locale_string_plural(char *singular, char *plural);
int set_locale_name(char *filename);
int resume_locale(void);
int preprocCFile(char *iname, char *oname);
void compile_CFile(char *name);
int haveMacro(char *s);

typedef struct
{
	char *buf;
	char *ptr;
	char *end;
	int size;
}
StrBuf;

StrBuf *new_StrBuf();
void delete_StrBuf(StrBuf * bp);
void putByte_StrBuf(StrBuf * bp, unsigned char b);
void putInt_StrBuf(StrBuf * bp, int i);
void putShort_StrBuf(StrBuf * bp, short s);
void putLong_StrBuf(StrBuf * bp, long l);
void putDouble_StrBuf(StrBuf * bp, double d);
void putStr_StrBuf(StrBuf * bp, const char *str);
void putString_StrBuf(StrBuf * bp, const char *str);
void write_StrBuf(StrBuf * bp, void *p, int len);

extern StrBuf bracket_buf;

#ifdef MEMDBG

#define malloc m_malloc
#define free m_free
#define calloc m_calloc
#define realloc m_realloc
#define strdup m_strdup
extern int c_sum, s_sum, m_sum, m_num, s_num, c_num;

void *m_calloc(size_t nmemb, size_t size);
void *m_malloc(size_t size);
void m_free(void *ptr);
void *m_realloc(void *ptr, size_t size);
char *m_strdup(const char *s);

#endif

void eof_checks(void);
Node *curr_operlist;
void fin_Function(Function *fpp);
int choose_quot(char *str,int *lquot, int *rquot, int simple);
char *quot_str(char *str, int simple);
extern int shared_flag, eshared_flag;
char *strsuff(const char *str, const char *suff);
void get_opt(int argc, char **argv);
void lex_vardef(int set);
void lex_initial(void);

extern int compat_as_word;
extern int names_flag;
extern char *_clic_gettext(const char *msg);
extern char *_clic_ngettext(const char *msg, const char *nmsg, int n);

#endif
