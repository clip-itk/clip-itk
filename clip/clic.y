/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/* [ */
%{
/*
 * $Log$
 * Revision 1.1  2006/06/22 19:35:15  itk
 * uri: init sf.net repository
 *
 * Revision 1.84  2006/01/04 08:06:04  clip
 * uri: small fix
 *
 * Revision 1.82  2005/12/19 10:59:04  clip
 * uri: some fix about output compiler messages to stderr
 *
 * Revision 1.81  2004/07/19 13:41:31  clip
 * rust: DO proc WITH ... didn't respect () (pass by value)
 *
 * Revision 1.80  2003/12/17 09:46:42  clip
 * uri: "f->fname" as "alias->fname" not as "field->fname"
 *
 * Revision 1.79  2003/03/25 14:20:59  clip
 * uri: *gettext changed to _clic_*gettext
 *
 * Revision 1.78  2003/01/05 12:32:25  clip
 * possible fixes #95,#98
 * paul
 *
 * Revision 1.77  2003/01/05 10:34:22  clip
 * possible fixes #98
 * paul
 *
 * Revision 1.76  2003/01/05 07:45:44  clip
 * fix sigsegv on compile
 * closes #96
 * paul
 *
 * Revision 1.75  2002/12/05 09:41:01  clip
 * use '=' at operator level as assign
 * closes #68
 * paul
 *
 * Revision 1.74  2002/12/04 09:05:52  clip
 * possible profile cleanup in _clip_eval
 * paul
 *
 * Revision 1.73  2002/11/27 13:40:44  clip
 * initial _CGET_ pseudofunction(bug 62):
 * _CGET_(var[i1,i2,i3,...]) -> __CGET__(@var[i1,i2,i3],{i1,i2,i3},"var",...)
 * paul
 *
 * Revision 1.72  2002/11/06 12:03:41  clip
 * add plural locale construction:
 * [asdf] ^ num_expr == ngettext("asdf", "asdf", num_expr)
 * paul
 *
 * Revision 1.71  2002/10/25 11:54:33  clip
 * localized messages for clip itself
 * paul
 *
 * Revision 1.70  2002/10/11 10:27:11  clip
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
 * Revision 1.69  2002/10/10 08:30:37  clip
 * &(expr) do not auto-codestr in codeblocks.
 * Closes #16
 * paul
 *
 * Revision 1.68  2002/08/15 12:18:34  clip
 * fix warnings in new bison
 * paul
 *
 * Revision 1.67  2002/08/15 07:46:52  clip
 * comm
 * paul
 *
 * Revision 1.66  2002/08/13 06:44:14  clip
 * fix for empty msgid in i18n strings
 * paul
 *
 * Revision 1.65  2002/08/08 09:33:24  clip
 * preproc fix for define/command priority
 * paul
 *
 * Revision 1.64  2002/06/30 08:08:31  clip
 * new preprocessor code
 * paul
 *
 * Revision 1.63  2002/05/16 07:05:22  clip
 * fix for _field->(a)->... syntax
 * paul
 *
 * Revision 1.62  2002/04/16 14:56:15  clip
 * bug in exprlist node - wrong stack fixup
 * paul
 *
 * Revision 1.61  2002/04/05 12:34:14  clip
 * "&()" preproc fix
 * "&a[1]" runtime fix
 * vardef place
 * paul
 *
 * Revision 1.60  2002/04/05 07:24:33  clip
 * wrong init in vardefs in func body
 * paul
 *
 * Revision 1.59  2002/04/03 13:32:53  clip
 * now possible use in init vars, declared in the same operator:
 * local a:=1, b:=a+1
 * paul
 *
 * Revision 1.58  2002/02/28 13:08:38  clip
 * split static func & static proc states
 * paul
 *
 * Revision 1.57  2002/02/05 08:30:57  clip
 * #translate directive improvements
 * paul
 *
 * Revision 1.56  2002/01/31 10:00:02  clip
 * &NAME.NUMBER fix
 * paul
 *
 * Revision 1.55  2002/01/14 12:39:59  clip
 * REF keyword in vardef
 * paul
 *
 * Revision 1.54  2002/01/07 07:26:35  clip
 * AS syntax cleanup
 * paul
 *
 * Revision 1.53  2002/01/05 12:50:48  clip
 * LOCAL a,b AS typename
 * STATIC a,b AS typename
 * func( a AS typename, b)
 * recognized, but yet not used
 * paul
 *
 * Revision 1.52  2002/01/04 09:12:46  clip
 * field +=
 * paul
 *
 * Revision 1.51  2001/12/24 13:51:01  clip
 * bad commands like
 * APEND BLANK
 * now will generate syntax error
 * paul
 *
 * Revision 1.50  2001/12/21 12:53:30  clip
 * +=, ... for fields
 * paul
 *
 * Revision 1.49  2001/12/21 11:48:20  clip
 *  (cAlias)->&(cf) := nSum    // this was not
 * paul
 *
 * Revision 1.48  2001/12/18 10:23:17  clip
 * field declaration
 * paul
 *
 * Revision 1.47  2001/12/10 13:40:31  clip
 * fox-compatible operators:
 * dimension a1(1),a2(1,2),a3(1,2,3)
 * a1(1) = "asdasd"
 * a2(1,1) = "32142"
 *
 * paul
 *
 * Revision 1.46  2001/12/10 12:09:30  clip
 * reduce '(' expr ')' to expr
 * paul
 *
 * Revision 1.45  2001/12/10 08:44:50  clip
 * {n.n.n} as DATE expression
 * paul
 *
 * Revision 1.44  2001/11/22 10:44:19  clip
 * expr: '(' expr_list ')' stack fix
 * paul
 *
 * Revision 1.43  2001/10/31 06:11:21  clip
 * DO func WITH x
 * take arguments by reference
 *
 * Revision 1.42  2001/10/29 06:51:21  clip
 * fix text fopen modes
 * paul
 *
 * Revision 1.41  2001/10/28 14:17:31  clip
 * (asdf)->fld := expr
 *
 * Revision 1.40  2001/10/15 11:12:28  clip
 * negative constants in CASE labels
 *
 * Revision 1.39  2001/09/05 05:30:26  clip
 * CODEBLOCK/CODESTR now can have paramters, f.e:
 * CODESTR(|a| f->first==a) will generate string
 * {|A|FIELD->FIRST==A}
 * paul
 *
 * Revision 1.38  2001/09/04 08:26:59  clip
 * CODEBLOCK pseudofunction
 * process codeblocks with macro calls as CODEBLOCK
 * paul
 *
 * Revision 1.37  2001/08/27 09:45:30  clip
 * switch operator
 * paul
 *
 * Revision 1.36  2001/08/24 14:38:46  clip
 * CODESTR pseudofunction
 * paul
 *
 * Revision 1.35  2001/08/23 13:52:06  clip
 * merge with NEWLOCALS
 * paul
 *
 * Revision 1.34.2.6  2001/08/21 13:20:11  clip
 * fix
 * paul
 *
 * Revision 1.34.2.5  2001/08/21 12:10:35  clip
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
 * Revision 1.34.2.4  2001/08/21 09:33:09  clip
 * runtime macro blocks {||&s}
 * paul
 *
 * Revision 1.34.2.3  2001/08/20 12:32:09  clip
 * macro in blocks
 * paul
 *
 * Revision 1.34.2.2  2001/08/20 10:43:09  clip
 * macro in blocks
 * paul
 *
 * Revision 1.34.2.1  2001/08/20 07:13:47  clip
 * block with macro
 * fields with macro
 * paul
 *
 * Revision 1.34  2001/07/25 13:47:26  clip
 * wrong /PROCNAME file procedure name
 * paul
 *
 * Revision 1.33  2001/06/22 08:29:50  clip
 * wrong op orger in 'NAME & mname'  macro
 * paul
 *
 * Revision 1.32  2001/06/09 08:13:28  clip
 * unary +
 * paul
 *
 * Revision 1.31  2001/05/30 09:45:43  clip
 * for .. in .. [keys]
 * paul
 *
 * Revision 1.30  2001/05/04 07:05:15  clip
 * procline filename
 * paul
 *
 * Revision 1.29  2001/04/16 07:29:39  clip
 * -> ( expr_list )
 * paul
 *
 * Revision 1.28  2001/04/03 09:17:00  clip
 * license errors
 * paul
 *
 * Revision 1.27  2001/03/30 11:51:02  clip
 * add copyright
 *
 * Revision 1.26  2001/02/22 14:09:11  clip
 * FOREACH take off
 * paul
 *
 * Revision 1.25  2001/02/21 12:52:58  clip
 * append HASHNAME(hash) - inverce to HASHSTR(str)
 *
 * append obj:modify() trigger:
 * modify(obj,hash,newval) -> real new val
 * MAPMODIFY(obj, enable) switch modify processing
 *
 * paul
 *
 * Revision 1.24  2000/12/09 12:13:28  clip
 * locale
 * paul
 *
 * Revision 1.23  2000/12/08 11:55:27  clip
 * start localisation
 * paul
 *
 * Revision 1.22  2000/12/07 07:19:38  clip
 * [ string_constants ] - prepare for i18n
 * linear sequence of func names in .po
 * paul
 *
 * Revision 1.21  2000/11/29 08:20:39  clip
 * x call
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.20  2000/11/20 13:46:50  clip
 * (asdf)->(expr)
 * paul
 *
 * Revision 1.19  2000/08/01 12:05:38  clip
 * append _thread.c
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.18  2000/05/27 00:15:16  clip
 * (asdf)=expr
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.17  2000/05/26 23:50:42  clip
 * (name)=expr
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.16  2000/05/25 16:00:38  clip
 * macro in codeblocks
 * break
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.15  2000/05/20 18:37:26  clip
 * change hash function
 * append HASH_xxxx extraction into hashcode.h
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.14  2000/05/12 20:57:02  clip
 * '(' expr_list ')'
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.13  2000/05/11 15:02:34  clip
 * {,,} now is 3 element-array
 * Paul Lasarev <paul@itk.ru>
 *
 * Revision 1.12  2000/04/29 20:13:56  clip
 * *** empty log message ***
 *
 * Revision 1.11  2000/04/29 20:08:48  clip
 * '(' expr ')' -> '(' expr ')'
 *
 * Revision 1.10  2000/04/29 19:49:32  clip
 * array elment object call
 *
 * Revision 1.9  2000/04/15 20:57:31  paul
 * mandrake fixes
 *
 * Revision 1.8  2000/03/30 16:25:10  paul
 * PARAM
 *
 * Revision 1.7  2000/03/20 18:59:45  paul
 * __field__ directive
 *
 * Revision 1.6  2000/03/18 21:58:09  paul
 * *** empty log message ***
 *
 * Revision 1.5  2000/03/16 19:29:11  paul
 * f->m-> , m->f-> fixed
 *
 * Revision 1.4  2000/03/03 21:37:33  paul
 * preprocessor bug fix, warnings removed
 *
 * Revision 1.3  1999/10/29 19:28:30  paul
 * bug in macroassign (stack was corrupted)
 *
 * Revision 1.2  1999/10/26 15:42:15  paul
 * change NOT priority
 *
 * Revision 1.1  1999/10/25 16:39:27  paul
 * first entry
 *
 */

#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <float.h>
#include <math.h>
#include <stdarg.h>

#include "clic.h"
#include "node.h"
#include "nodepriv.h"

#define YYERROR_VERBOSE
static int if_depth=0, if_line, if_file, loop_line, loop_file, seq_line, seq_file;
int traplevel;
static void check_main();
#define CM check_main()
int ifexpr_flag=0;
int iif_expr=0;
int field_flag=0;
static void upstr(char *str);
static void push_operlist(Node *operlist);
static void pop_operlist(void);
Node *curr_operlist;
static Node *reduce_ExprListNode(Node *np);
static Node *assop_node( int assop, char *area, Node *areaExpr, char*name, Node *nameExpr, Node *expr);
static Node *(*def_node)(VarColl *cp) = 0;

%}

/* ][ grammar section */


%union
{
	char *string;
	void *ptr;
	Coll *coll;
	struct {
		Coll *coll;
		int haveRest;
	} arglist;
	VarColl *varcoll;
	Var *var;
	List *list;
	Node *node;
	Function *func;
	int i;
	struct
	{
		int curseq;
		Node *using;
		Node *operlist;
	}
	recover;
	SwitchEl *switchel;
}

/* ISTRING is in18n string - as [ str] */

%token <string> STRING NUMBER ISTRING
%token <string>	NAME CTEXT
%token <string>	DATE
%token <i>	KEYS

%token PREPROC

%token RETURN FUNCTION PROCEDURE IPROCEDURE EPROCEDURE EXTERN PARAMETERS
%token SFUNCTION SPROCEDURE TEXT
%token PUBLIC PRIVATE STATIC LOCAL DIMENSION
%token NIL END TRUE FALSE
%token WHILE DO ENDDO EXIT LOOP WITH CALL
%token IF IIF ENDIF ELSE ELSEIF
%token DOCASE CASE OTHERWISE ENDCASE SWITCH ENDSWITCH
%token FIELD MEMVAR IN MEMVARPTR FIELDPTR
%token PCOUNT PARBEG PARAMBEG PSHIFT PALL CGET
%token FOR STEP TO NEXT FOREACH
%token BEGSEQ RECOVER USING BREAK EBREAK
%token ANNOUNCE REQUEST
%token IFNL IFEXPR CODESTR CODEBLOCK
%token AS REF

%type <i>	function procedure assign curseq keys ass_op
/*
%type <i>	assop eassop
*/
%type <node>	oper operlist name mname else step using otherwise iname
%type <node>	constant expr nexpr nilexpr exprlist arg expr_list code mconstant
%type <coll>	namelist arg_list with_arg_list elseif caselist casebeg
%type <arglist> arglist with_arglist
%type <var>	var dim
%type <varcoll> paramlist param_list vardef varlist bparam_list dimdef
%type <string>	inalias
%type <func>	func
%type <recover> recover
%type <node>	arr arr_list dim_list
%type <node>	pairlist pair
%type <coll>	switchlist switchlabel switchbeg
%type <string>	type_def

%right ASSIGN ADDA SUBA DIVA MODA MULA POWA
%right POSTINCR
%left '@'
%left OR
%left AND
%right NOT
%left '>' GE '<' LE EQ NE '=' '$'
%left '+' '-'
%left '*' '/' '%'
%left POW
%right MINUS
%right INCR DECR
%left ':' '[' '.'
%left RPTR REPTR
%right DSEMICOLON


%%


file:		{ }
/*
	| file function NAME paramlist type_def '\n'
		{
			curFunction=new_Function($3,$4,$2,0,0,0);
			curFunction->typename = $5;
			lex_vardef(0);
			add_Function(curFile, curFunction);
			curStatics=curFunction->statics;
			fin_Function(curFunction);
		}

	| file procedure NAME paramlist type_def '\n'
		{
			curFunction=new_Function($3,$4,$2,0,0,0);
			curFunction->isProc=1;
			curFunction->typename = $5;
			lex_vardef(0);
			add_Function(curFile, curFunction);
			curStatics=curFunction->statics;
			fin_Function(curFunction);
		}
*/
	| file oper '\n'
		{
			if ($2)
			{
				if ( $2->isExec )
					curFunction->lastExec=1;
				append_Node( curFunction->body, $2);
			}
		}
	| file CTEXT
		{
			if (curFunction==curFile->main)
				append_Node(curFile->ctext, new_LangNode($2));
			else
				append_Node(curFunction->body, new_LangNode($2));
		}
	| file STATIC CTEXT
		{
			append_Node(curFile->ctextStatic, new_LangNode($3));
		};

function:	FUNCTION	{$$=1; lex_vardef(1);}
	| STATIC FUNCTION	{$$=0; lex_vardef(1);}
		;

procedure:	PROCEDURE	{$$=1;lex_vardef(1);}
	| STATIC PROCEDURE	{$$=0;lex_vardef(1);}
	| IPROCEDURE	{$$=2;lex_vardef(1);}
	| EPROCEDURE	{$$=3;lex_vardef(1);}
		;

paramlist:                  {$$=new_VarColl();}
	| '('  param_list ')' { $$=$2;}
		;

operlist:	{ $$=new_OperListNode(); push_operlist($$); }
	| operlist oper '\n'
		{
			$$=$1;
			if ($2)
			{
				if ( $2->isExec )
					curFunction->lastExec=1;
				append_Node( $$, $2);
			}
		}
		;

oper:                	{ $$=NULL; }
	| function NAME paramlist type_def
		{
			eof_checks();
			curFunction=new_Function($2,$3,$1,0,0,0);
			curFunction->typename = $4;
			lex_vardef(0);
			add_Function(curFile, curFunction);
			curStatics=curFunction->statics;
			fin_Function(curFunction);
			pop_operlist();
			push_operlist(curFunction->body);
			$$=NULL;
		}

	| procedure NAME paramlist type_def
		{
			eof_checks();
			curFunction=new_Function($2,$3,$1,0,0,0);
			curFunction->isProc=1;
			curFunction->typename = $4;
			lex_vardef(0);
			add_Function(curFile, curFunction);
			curStatics=curFunction->statics;
			fin_Function(curFunction);
			pop_operlist();
			push_operlist(curFunction->body);
			$$=NULL;
		}
	| EXTERN namelist	{
			int i;
			char *s;
			for(i=0;i<$2->count;i++)
			{
				VAR(char, vp, $2->items[i]);
				if (insert_Coll( &curFile->externFunctions, vp)<0)
					free(vp);
				else
				{
					for(s=vp; *s; ++s)
						*s=toupper(*s);
					insert_Coll( &curFile->undeclExternFunctions, strdup(vp));
				}
			}
			removeAll_Coll($2);
			delete_Coll($2);
			$$=NULL;
			if (curFunction->lastExec)
				yyerror("EXTERN after executable statements");
		}
	| LOCAL {
			lex_vardef(1);
			def_node=new_LocalDefNode1;
		}
	 vardef
		{
			/*$$=new_LocalDefNode($3, 1);*/
			$$=NULL;
			lex_vardef(0); CM;
			def_node=0;
		}
	| STATIC
		{
			lex_vardef(1);
			def_node = new_StaticDefNode;
		}
	vardef
		{
			/*$$=new_StaticDefNode($3);*/
			$$=NULL;
			lex_vardef(0);
			def_node=0;
		}
	| PUBLIC
		{
			def_node = new_PublicDefNode;
		}
	vardef
		{
			/*$$=new_PublicDefNode($2);*/
			$$=NULL;
			CM;
			def_node=0;
		}
	| PRIVATE
		{
			def_node = new_PrivateDefNode;
		}
	 vardef
		{
			/*$$=new_PrivateDefNode($2);*/
			$$=NULL;
			CM;
			def_node=0;
		}
	| DIMENSION
		{
			def_node = new_PrivateDefNode;
		}
	 dimdef
		{
			/*$$=new_PrivateDefNode($2);*/
			$$=NULL;
			CM;
			def_node=0;
		}
/*
	| NAME varlist	{
				if (!strcasecmp($1, "field"))
					$$=new_FieldDefNode($2, 0);
				else if (!strcasecmp($1, "memvar"))
					$$=new_MemvarDefNode($2);
				else
					$$=new_NamespaceDefNode($1,$2);
				CM;
			}
*/
	| MEMVAR varlist	{ $$=new_MemvarDefNode($2); }
	| FIELD varlist inalias { $$=new_FieldDefNode($2, $3); }
	| PARAMETERS varlist	{ $$=new_ParametersDefNode($2); CM;}
	| RETURN		{ $$=new_ReturnNode(NULL,0); CM;}
	| RETURN  expr		{ $$=new_ReturnNode($2,0); CM;}

	| REQUEST namelist
			{
				Coll *cp = $2;
				int i;

				$$=NULL;
				for(i=0; i< cp->count; ++i)
					append_Coll(&curFile->externModules, cp->items[i]);

				removeAll_Coll(cp);
				delete_Coll(cp);
			}
	| ANNOUNCE NAME	{
				char *s = $2;

				$$=NULL;
				free(curFile->main->name);
				curFile->main->name = s;
				for(; *s; ++s)
					*s = toupper(*s);
			}

	| error 		{ $$=NULL; }

	/*| '(' expr_list ')' '=' expr %prec ASSIGN { $$=new_OperExprNode(new_AssignNode($2,$5,'=')); }*/

	| expr '=' expr { CM;$$=new_OperExprNode(new_AssignNode($1,$3,'=')); }
	| NAME RPTR NAME ass_op expr %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($4,$1,NULL,$3,0,$5)); }
	| NAME RPTR mname ass_op expr %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($4,$1,NULL,0,$3,$5)); }
	| fieldptr NAME RPTR NAME ass_op expr  %prec ASSIGN { CM; $$=new_OperExprNode(assop_node($5, $2,NULL,$4,0,$6)); }
	| fieldptr NAME RPTR mname ass_op expr  %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($5, $2,NULL,0,$4,$6)); }
	| fieldptr NAME ass_op expr  %prec ASSIGN {CM;$$=new_OperExprNode(assop_node($3,NULL,NULL,$2,0,$4));}
	| mname RPTR NAME ass_op expr  %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($4,NULL,$1,$3,0,$5)); }

	| '(' expr_list ')' RPTR NAME ass_op expr  %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($6,NULL,$2,$5,0,$7)); }
	| '(' expr_list ')' RPTR mname ass_op expr  %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($6,NULL,$2,0, $5,$7)); }
	| '(' expr_list ')' RPTR '(' expr_list ')' ass_op expr  %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($8,NULL,$2,0,$6,$9)); }
	| fieldptr '(' expr_list ')' RPTR NAME ass_op expr  %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($7,NULL,$3,$6,0,$8)); }
	| fieldptr '(' expr_list ')' RPTR mname ass_op expr  %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($7,NULL,$3,0, $6,$8)); }
	| fieldptr '(' expr_list ')' RPTR '(' expr_list ')' ass_op expr  %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($9,NULL,$3,0,$7,$10)); }

	| fieldptr mname RPTR NAME ass_op expr  %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($5,NULL,$2,$4,0,$6)); }
	| fieldptr mname ass_op expr  %prec ASSIGN {CM;$$=new_OperExprNode(assop_node($3,NULL,NULL,0,$2,$4));}
	| mname RPTR mname ass_op expr  %prec ASSIGN { CM;$$=new_OperExprNode(assop_node($4,NULL,$1,0,$3,$5)); }
	| fieldptr mname RPTR mname ass_op expr %prec ASSIGN  { CM;$$=new_OperExprNode(assop_node($5,NULL,$2,0,$4,$6)); }

	| name '=' expr 	{ CM;$$=new_OperExprNode(new_AssignNode($1,$3,'=')); }
	| mname '=' expr  	{ CM;$$=new_OperExprNode(new_AssignNode($1,$3,'=')); }
	| arr '=' expr 		{ CM;$$=new_OperExprNode(new_ArrElNode($1,$3,'=')); }
	| expr  		{ $$=new_OperExprNode($1); CM;}
	| NAME '(' arglist ')' '=' expr {
				Node *np;
				int i;
				CM;
				np = new_ExprListNode();
				append_Node(np, installName($1));
				for(i=0; i< $3.coll->count; i++)
				{
					Node *p = (Node*) $3.coll->items[i];
					append_Node(np, p);
				}
				$$=new_OperExprNode(new_ArrElNode(np, $6,'='));
			}

	| '(' expr_list ')' '=' expr %prec ASSIGN { $$=new_OperExprNode(new_AssignNode(new_MacroNode($2,0),$5,'=')); }

	| WHILE
		{ CM;
			if (!curFunction->inLoop)
				{ loop_line = cl_line; loop_file = currentFile(); }
			curFunction->inLoop++;
		}
	  expr '\n' operlist enddo
		{
			curFunction->inLoop--;
			$$=new_WhileNode($3,$5);
			pop_operlist();
		}

	| DO NAME with_arglist { CM; $$ = new_OperExprNode(new_CallNode($2, $3.coll, $3.haveRest)); }

	| DO mname with_arglist	{ CM; $$ = new_OperExprNode(new_CallNameNode($2, $3.coll)); }

	| CALL NAME with_arglist { CM; $$ = new_OperExprNode(new_CallNode($2, $3.coll, $3.haveRest)); }

	| CALL mname with_arglist	{ CM; $$ = new_OperExprNode(new_CallNameNode($2, $3.coll)); }

	| EXIT  {
			CM;
			if (!curFunction->inLoop)
				yyerror("EXIT statement out of loop");
			$$=new_LoopExitNode(0);
		}

	| LOOP  {
			CM;
			if (!curFunction->inLoop)
				yyerror("LOOP statement out of loop");
			$$=new_LoopExitNode(1);
		}

	|  for name eassign expr TO expr step '\n' { lex_initial(); } operlist next
		{
			curFunction->inLoop--;
			$$=new_ForNode($2,$4,$6,$7,$10);
			pop_operlist();
		}

	| for name IN expr keys '\n' { lex_initial(); } operlist next
		{
			curFunction->inLoop--;
			$$=new_ForeachNode($2,$4,$8,$5);
			pop_operlist();
		}

	| BEGSEQ curseq {
			CM;
			curFunction->seqNo = ++curFunction->allSeqNo;
			if (!curFunction->seqLevel)
			{
				seq_line = cl_line;
				seq_file = currentFile();
			}
			curFunction->seqLevel++;
			ARR_REALLOC(int, curFunction->seqStack, curFunction->seqLevel);
			curFunction->seqStack[curFunction->seqLevel-1]=$2;
		}
	  operlist
		{
			pop_operlist();
		}
	  recover
	  END   {
			CM;
			$$=new_SeqNode($4,$6.using,$6.operlist,$6.curseq);
		}

	| BREAK nexpr
		{  CM; $$=new_BreakNode($2, 1); }

	| IF '(' nilexpr ',' nilexpr ',' nilexpr ')'
		{
			Coll *cp=new_Coll(NULL,NULL);
			append_Coll(cp,$3);
			append_Coll(cp,$5);
			$$=new_OperExprNode(new_IfNode(cp,$7));
			CM;
		}

	| IF expr '\n'
		{
			if ($2->isExprList && getCount_Node($2)>1 )
			{
				yyerror("please, use IIF function (not IF) on operator level to avoid conflicts");
				YYERROR;
			}
			if (!if_depth)
			{
				if_line = cl_line;
				if_file = currentFile();
			}
			if_depth++;
		}
	  operlist  elseif  else  endif
		{
			CM;
			prepend_Coll($6,$5);
			prepend_Coll($6,$2);
			$$=new_IfNode( $6, $7);
			if_depth--;
			pop_operlist();
		}

	| DOCASE '\n' caselist  otherwise  endcase
		{
			CM;
			$$=new_IfNode( $3, $4);
		}

	| SWITCH expr '\n' switchlist otherwise endswitch
		{
			$$=new_SwitchNode($2, $4, $5);
		}
	;

type_def:	{ $$=0; }
	| AS NAME { $$=$2; }
	| REF NAME { $$=$2; }
	;

switchlist:	switchbeg
	| switchlist switchlabel '\n' operlist
		{
			SwitchEl *nl = NEW(SwitchEl);
			nl->labels = $2;
			nl->operlist = $4;
			insert_Coll($1, nl);
			$$ = $1;
			pop_operlist();
		}
	;

switchbeg:	{
			$$ = new_Coll(0, 0);
		}
	| switchbeg '\n'
	;

switchlabel: CASE mconstant
		{
			$$ = new_Coll(0,0);
			append_Coll($$, $2);
		}
	| switchlabel ',' mconstant
		{
			$$ = $1;
			append_Coll($$, $3);
		}
	;

for: FOR
		{  CM;
			if (!curFunction->inLoop)
				{ loop_line = cl_line; loop_file = currentFile(); }
			curFunction->inLoop++;
		}
	;

next:	NEXT
	| END
	;

keys:		{ $$ = 0; }
	| KEYS	{ $$ = 1; }
	;

recoverr:  function NAME paramlist type_def '\n'	{}
	| procedure NAME paramlist type_def '\n'	{}
	;

recover:	{
			$$.curseq = curFunction->seqNo;
			$$.operlist = 0;
			$$.using = 0;
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
		}
	| recoverr
		{
			yyerror("unclosed BEGIN SEQUENCE");
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
			YYERROR;
		}
	| RECOVER curseq using '\n'
		{
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
		}
	 operlist
		{
			$$.operlist = $6;
			$$.using = $3;
			$$.curseq = $2;
			pop_operlist();
		}
	;

curseq:		{$$ = curFunction->seqNo; }
	;

using:		{ $$=NULL; }
	| USING name { $$=$2; }
	;

step:			{ $$=new_NumberConstNode(strdup("1"),0); }
	| STEP expr	{ $$=$2; }
	;

enddo:	  END
	| ENDDO
	;

iif:	  IIF
	| IF
	;

elseif:		{ $$=new_Coll(NULL,NULL); }
	| elseif ELSEIF expr '\n'  operlist
		{
			$$=$1;
			append_Coll($$, $3);
			append_Coll($$, $5);
			pop_operlist();
		}
	;

else:		{ $$=NULL; }
	| ELSE '\n' operlist
		{
			$$=$3;
			pop_operlist();
		}
	;

endif: 	  END
	| ENDIF
	;

casebeg:		{ $$=new_Coll(NULL,NULL); }
	| casebeg '\n'
	;

caselist: casebeg
	| caselist CASE expr '\n'  operlist
		{
			$$=$1;
			append_Coll($$, $3);
			append_Coll($$, $5);
			pop_operlist();
		}
	;

otherwise:	{ $$=NULL; }
	| OTHERWISE '\n' operlist
		{
			$$=$3;
			pop_operlist();
		}
	;

endcase:	END
	|	ENDCASE
	;

endswitch:	END
	|	ENDSWITCH
	;

inalias:  		{ $$=NULL; }
	| IN NAME	{ $$=$2; }
	;

name: NAME	{ $$=installName($1); }
	| memvarptr NAME	{ $$=new_MemvarNode(new_Var($2)); }
	/*| FIELDPTR NAME		{ $$=new2_FieldNode(NULL,NULL,$2,NULL); }*/
	/*| FIELDPTR mname	{  }*/
	| memvarptr mname	{ $$=$2; }
	;

iname: NAME	{ $$=installName($1); }
	| memvarptr NAME	{ $$=new_MemvarNode(new_Var($2)); }
	| fieldptr NAME		{ $$=new2_FieldNode(NULL,NULL,$2,NULL); }
	;

mname:	 '&' iname 	{ $$=new_MacroNode($2,0); }
	| '&' iname '.'	{ $$=new_MacroNode($2,0); }
	| NAME '&' iname	{ $$=new_MacroNode(new_OpNode(new_StringConstNode($1),$3,'+'),0);  }
	| '&' iname '.' NAME	{ $$=new_MacroNode(new_OpNode($2,new_StringConstNode($4),'+'),0); }
	| '&' iname NUMBER	{ char *s = $3+strspn($3,",.-+");
			$$=new_MacroNode(new_OpNode($2,new_StringConstNode(s),'+'),0); }
	| '&' '(' expr ')'	{ $$=new_MacroNode($3,1); }
	;

expr:	constant
	| ISTRING	{
				int i, l, bad;
				l = strlen($1);
				bad = 0;
				for(i=0; i<l; i++)
				{
					if ( $1[i] & 0x80 )
					{
						bad = 1;
						break;
					}
				}
				if (l && !bad)
				{
					put_locale_string($1);
					$$=new_LocaleStringNode($1);
				}
				else
				{
					$$=new_StringConstNode($1);
				}
			}
	| ISTRING POW expr {
				Node *e1 = new_StringConstNode($1);
				Node *e2 = new_StringConstNode(strdup($1));
				$$ = new3_CallNode("_clic_ngettext", e1, e2, $3);
			}
	| DATE		{
				Coll *cp = new_Coll(0,0);
				append_Coll(cp, new_StringConstNode($1));
				$$=new_CallNode(strdup("CTOD"), cp, 0);
			}
	| name
	| mname
	| '(' expr_list ')' 	{
		/*((ExprListNode*)$2)->last=1; ; */
		$$=reduce_ExprListNode($2);
		}
	| '@' expr { $$=new_RefNode($2); }

	| NAME '(' arglist ')' { $$=new_CallNode( $1, $3.coll, $3.haveRest); }
	| mname '(' arglist ')' { $$=new_CallNameNode($1,$3.coll); }

	| arr	{ $$=new_ArrElNode($1,NULL,0); }
	| name assign expr  %prec ASSIGN	{ $$=new_AssignNode($1,$3,$2); }
	| arr assign expr %prec ASSIGN	{ $$=new_ArrElNode($1,$3,$2); }
	| mname assign expr  %prec ASSIGN	{ $$=new_AssignNode($1,$3,$2); }

	| expr ':' NAME '(' arglist ')' { $$=new_MethodNode($1,$3,$5.coll, $5.haveRest); }
	| arr '(' arglist ')'
		{
			Node *arr = $1;
			Node *last;
			char *name;
			last_List(&arr->list);
			last = (Node *) arr->list.current;
			if( !last || strcmp(last->name, "const") || !(name=((ConstNode*)last)->rval) )
			{
				yyerror("invalid array call");
				YYERROR;
			}
			remove_List(&arr->list);
			$$ = new_MethodNode(new_ArrElNode(arr,0,0), name, $3.coll, $3.haveRest);
		}
	| DSEMICOLON NAME '(' arglist ')' {
		add_self();
		$$=new_MethodNode(installName(strdup("__SELF__")),$2,$4.coll, $4.haveRest);
		}
	| fieldptr NAME	{$$=new2_FieldNode(NULL,NULL,$2,NULL);}
	| NAME RPTR NAME  {$$=new2_FieldNode($1,NULL,$3,NULL); }
	| fieldptr mname { $$=new2_FieldNode(NULL,NULL,NULL,$2); }

	| NAME	REPTR '(' expr ')'	{ $$=$4; }

	/* !!!!!! */
	| fieldptr NAME RPTR NAME	 { $$=new2_FieldNode($2,NULL,$4,NULL); }
	| fieldptr NAME RPTR mname { $$=new2_FieldNode($2,NULL,NULL,$4); }
	| NAME RPTR '(' expr_list ')' { $$=new2_FieldNode($1,NULL,NULL,reduce_ExprListNode($4)); }
	| fieldptr NAME RPTR '(' expr_list ')' { $$=new2_FieldNode($2,NULL,NULL,reduce_ExprListNode($5)); }
	| NAME RPTR mname { $$=new2_FieldNode($1,NULL,NULL,$3); }

	| '(' expr_list ')' RPTR '(' expr_list ')' {$$=new2_FieldNode(NULL,reduce_ExprListNode($2),NULL,reduce_ExprListNode($6));}
	| '(' expr_list ')' RPTR mname { $$=new2_FieldNode(NULL,reduce_ExprListNode($2),NULL,$5); }
	| '(' expr_list ')' RPTR NAME { $$=new2_FieldNode(NULL,reduce_ExprListNode($2),$5,NULL); }
	| fieldptr '(' expr_list ')' RPTR '(' expr_list ')' {$$=new2_FieldNode(NULL,reduce_ExprListNode($3),NULL,reduce_ExprListNode($7));}
	| fieldptr '(' expr_list ')' RPTR mname { $$=new2_FieldNode(NULL,reduce_ExprListNode($3),NULL,$6); }
	| fieldptr '(' expr_list ')' RPTR NAME { $$=new2_FieldNode(NULL,reduce_ExprListNode($3),$6,NULL); }

	| mname RPTR NAME	{$$=new2_FieldNode(NULL,$1,$3,NULL);}
	/* !!!!!!! */
	| fieldptr mname RPTR NAME	{$$=new2_FieldNode(NULL,$2,$4,NULL);}
	| mname RPTR '(' expr_list ')'	{$$=new2_FieldNode(NULL,$1,NULL,reduce_ExprListNode($4));}
	| fieldptr mname RPTR '(' expr_list ')'	{$$=new2_FieldNode(NULL,$2,NULL,reduce_ExprListNode($5));}
	| mname RPTR mname	{$$=new2_FieldNode(NULL,$1,NULL,$3);}
	| fieldptr mname RPTR mname	{$$=new2_FieldNode(NULL,$2,NULL,$4);}

	| NAME RPTR NAME assign expr %prec ASSIGN { CM;$$=(assop_node($4,$1,NULL,$3,0,$5)); }
	| fieldptr NAME RPTR NAME assign expr  %prec ASSIGN { CM; $$=(assop_node($5, $2,NULL,$4,0,$6)); }
	| fieldptr NAME RPTR mname assign expr  %prec ASSIGN { CM;$$=(assop_node($5, $2,NULL,0,$4,$6)); }
	| fieldptr NAME assign expr  %prec ASSIGN {CM;$$=(assop_node($3,NULL,NULL,$2,0,$4));}
	| mname RPTR NAME assign expr  %prec ASSIGN { CM;$$=(assop_node($4,NULL,$1,$3,0,$5)); }

	| '(' expr_list ')' RPTR NAME assign expr  %prec ASSIGN { CM;$$=(assop_node($6,NULL,reduce_ExprListNode($2),$5,0,$7)); }
	| '(' expr_list ')' RPTR mname assign expr  %prec ASSIGN { CM;$$=(assop_node($6,NULL,reduce_ExprListNode($2),0, $5,$7)); }
	| '(' expr_list ')' RPTR '(' expr_list ')' assign expr  %prec ASSIGN { CM;$$=(assop_node($8,NULL,reduce_ExprListNode($2),0,reduce_ExprListNode($6),$9)); }
	| fieldptr '(' expr_list ')' RPTR NAME assign expr  %prec ASSIGN { CM;$$=(assop_node($7,NULL,reduce_ExprListNode($3),$6,0,$8)); }
	| fieldptr '(' expr_list ')' RPTR mname assign expr  %prec ASSIGN { CM;$$=(assop_node($7,NULL,reduce_ExprListNode($3),0, $6,$8)); }
	| fieldptr '(' expr_list ')' RPTR '(' expr_list ')' assign expr  %prec ASSIGN { CM;$$=(assop_node($9,NULL,reduce_ExprListNode($3),0,reduce_ExprListNode($7),$10)); }

	| fieldptr mname RPTR NAME assign expr  %prec ASSIGN { CM;$$=(assop_node($5,NULL,$2,$4,0,$6)); }
	| NAME RPTR mname assign expr  %prec ASSIGN { CM;$$=(assop_node($4,$1,NULL,0,$3,$5)); }
	| fieldptr mname assign expr  %prec ASSIGN {CM;$$=(assop_node($3,NULL,NULL,0,$2,$4));}
	| mname RPTR mname assign expr  %prec ASSIGN { CM;$$=(assop_node($4,NULL,$1,0,$3,$5)); }
	| fieldptr mname RPTR mname assign expr %prec ASSIGN  { CM;$$=(assop_node($5,NULL,$2,0,$4,$6)); }

	| expr '=' expr		{ $$=new_OpNode($1,$3,'e');  }
	| expr EQ expr		{ $$=new_OpNode($1,$3,'E');  }
	| expr NE expr		{ $$=new_OpNode($1,$3,'N');  }
	| expr '<' expr		{ $$=new_OpNode($1,$3,'<');  }
	| expr '>' expr		{ $$=new_OpNode($1,$3,'>');  }
	| expr LE expr		{ $$=new_OpNode($1,$3,'L');  }
	| expr GE expr		{ $$=new_OpNode($1,$3,'G');  }
	| expr '+' expr		{ $$=new_OpNode($1,$3,'+');  }
	| expr '$' expr		{ $$=new_OpNode($1,$3,'$');  }
	/*| expr NOT '$' expr		{ $$=new_OpNode($1,$4,'$');  }*/
	| expr '-' expr		{ $$=new_OpNode($1,$3,'-');  }
	| expr '*' expr		{ $$=new_OpNode($1,$3,'*');  }
	| expr '/' expr		{ $$=new_OpNode($1,$3,'/');  }
	| expr '%' expr		{ $$=new_OpNode($1,$3,'%');  }
	| expr POW expr		{ $$=new_OpNode($1,$3,'^');  }
	| expr AND expr		{ $$=new_AndNode($1,$3);  }
	| expr OR expr		{ $$=new_OrNode($1,$3);  }

	| NOT expr	{ $$=new_NotNode($2);  }

	| INCR expr	{ $$=new_IncrNode($2,1,0); }
	| expr INCR %prec POSTINCR	{ $$=new_IncrNode($1,1,1); }
	| DECR expr	{ $$=new_IncrNode($2,0,0); }
	| expr DECR %prec POSTINCR	{ $$=new_IncrNode($1,0,1); }
	| '-' expr %prec MINUS	{ $$=new_MinusNode($2); }
	| '+' expr %prec MINUS	{ $$=$2; }

	| '{' exprlist '}'	{$$=new_ArrayInitNode($2); }
	| '{' pairlist '}'	{$$=new_ArrayInitNode($2); }
	| '{' '|' func code  exprlist '}'	{
			Node *np=$4;
			Node *el=$5;
			CodeNode *npp = (CodeNode*)np;
			int haveMacro = 0;
			fin_Function(curFunction);

			append_Node(curFunction->body,new_ReturnNode(el,1));

			npp->func->body->pass(npp->func->body, SearchMacro, 0, &haveMacro);

			if (haveMacro)
			{
				/* transform into CODEBLOCK(exprlist)" */
				remove_Coll(&curFile->codeblocks, npp->func);
				np = new_MacroNode(new_CodestrNode(el,1,curFunction->params),0);
			}
			curFunction = $3;

			$$=np;
		}
	| CGET '(' arg_list ')'	{ $$=new_CGetNode($3); }
	| PCOUNT	{ $$=new_PcountNode(); }
	| PSHIFT	{ $$=new_PshiftNode(); }
	| PARBEG expr ']' { $$=new_ParnNode($2); }
	| PARAMBEG expr ')' { $$=new_ParnNode($2); }

	| CODESTR bparam_list {  curFunction->code_params=$2; }
		exprlist ')' { $$=new_CodestrNode($4,0,$2); curFunction->code_params=0; }
	| CODEBLOCK bparam_list {  curFunction->code_params=$2; }
		exprlist ')' { $$=new_MacroNode(new_CodestrNode($4,1,$2),0); curFunction->code_params=0; }

	| LOCAL '(' func
		{
			if (curFunction->upfunc)
				curFunction = curFunction->upfunc;
		}
		vardef ')'
		{
			Node *np;
			curFunction = $3;
			np = new_LocalDefNode($5, 0, 1);
			prepend_Node(curFunction->body, np);
			$$ = new_NilConstNode();
			CM;
		}

	| iif '(' nilexpr ',' nilexpr ',' nilexpr ')'
		{
			Coll *cp=new_Coll(NULL,NULL);
			append_Coll(cp,$3);
			append_Coll(cp,$5);
			$$=new_IfNode(cp,$7);
		}


	| EBREAK  nexpr ')'
		{  $$=new_BreakNode($2,0); }
	;


bparam_list:	{ $$=0; }
	| '|' param_list '|' { $$=$2; }
	;

nilexpr:	{ $$=new_NilConstNode(); }
	| expr	{ $$=$1; }
	;

eassign: ASSIGN
	| '='
	;

fieldptr: FIELDPTR
	| fieldptr FIELDPTR
	| memvarptr FIELDPTR
	;

memvarptr: MEMVARPTR
	| fieldptr MEMVARPTR
	| memvarptr MEMVARPTR
	;

assign: ASSIGN	{ $$='='; }
	| ADDA	{ $$='+'; }
	| SUBA	{ $$='-'; }
	| MULA	{ $$='*'; }
	| DIVA	{ $$='/'; }
	| MODA	{ $$='%'; }
	| POWA	{ $$='^'; }
	;

ass_op: '=' { $$='='; }
	;


func:	{ $$=curFunction; }
	;

code:	param_list '|' { $$=new_CodeNode($1); }
	;

arr:	 expr '[' expr_list ']' { $$=$3; prepend_Node($3,$1); }
	| arr '[' expr_list ']'	{ $$=$1; join_Node($1,$3); }
	| expr ':' NAME	{
		$$=new_ExprListNode();
		append_Node($$, $1);
		upstr($3);
		append_Node($$, new_HashConstNode($3));
		}
	| DSEMICOLON NAME	{
		$$=new_ExprListNode();
		add_self();
		append_Node($$, installName(strdup("__SELF__")));
		upstr($2);
		append_Node($$, new_HashConstNode($2));
		}
	| arr ':' NAME  	{
		$$=$1;
		upstr($3);
		append_Node($$,new_HashConstNode($3));
	}
	;

vardef:  var  type_def	{
			$$=new_VarColl();
			$1->type = $2;
			add_VarColl($$, $1);
			if (def_node)
				append_Node( curr_operlist, def_node($$));

		}
	| vardef ',' var type_def
		{
			if (def_node)
				$$=new_VarColl();
			else
				$$=$1;
			$3->type = $4;
			add_VarColl($$, $3);
			if (def_node)
				append_Node( curr_operlist, def_node($$));
		}
	;

dimdef:  dim	{
			$$=new_VarColl();
			add_VarColl($$, $1);
		}
	| dimdef ',' dim
		{
			$$=$1;
			add_VarColl($$, $3);
		}
	;

dim:	NAME dim_list	{ $$=newArrInit_Var($1,$2); }
	| mname dim_list	{ $$=mnewArrInit_Var($1,$1); }
	;

dim_list:  '(' expr_list ')' { $$=$2; }
	| dim_list '(' expr_list ')'	{ $$=$1; join_Node($1,$3); }
	;

var:	  NAME		{ $$=new_Var($1); }
	| NAME arr_list	{ $$=newArrInit_Var($1,$2); }
	| NAME ASSIGN expr	{ $$=newInit_Var($1,$3); }
	| name '=' expr	{ yyerror("only inline assign := allowed in initialisation"); $$=new_Var(strdup("")); }

	| mname		{ $$=mnew_Var($1); }
	| mname arr_list	{ $$=mnewArrInit_Var($1,$1); }
	| mname ASSIGN expr	{ $$=mnewInit_Var($1,$3);  }
	| mname '=' expr	{ yyerror("only inline assign := allowed in initialisation"); $$=new_Var(strdup("")); }
	;

arr_list:  '[' expr_list ']' { $$=$2; }
	| arr_list '[' expr_list ']'	{ $$=$1; join_Node($1,$3); }
	;

param_list:  { $$=new_VarColl(); }
	| NAME type_def	{
		Var *vp=new_Var($1);
		vp->type = $2;
		$$=new_VarColl();
		vp->no=0;
		insert_Coll( &$$->coll, vp);
		insert_Coll( &$$->unsorted, vp);
		}
	| param_list ',' NAME type_def{
		Var *vp=new_Var($3);
		vp->type = $4;
		$$=$1;
		vp->no = $$->unsorted.count;
		insert_Coll( &$$->coll, vp);
		insert_Coll( &$$->unsorted, vp);
		}
	;


namelist: 	{$$=new_Coll(free,strcmp);}
	| NAME  {
			$$=new_Coll(free,strcmp);
			insert_Coll($$, $1);
		}
	| namelist ',' NAME
		{
			int no;
			$$=$1;
			if ( search_Coll( $$, $3, &no) )
			{
				yyerror("name '%s' duplication", $3);
				free($3);
			}
			else
				insert_Coll( $$, $3 );
		}
	;

varlist:  NAME	{
			$$=new_VarColl();
			add_VarColl($$, new_Var($1));
		}
	| varlist ',' NAME
		{
			$$=$1;
			add_VarColl($$, new_Var($3));
		}
	;

arglist: arg_list		{ $$.coll=$1; $$.haveRest=0; }
	| arg_list ',' PALL	{ $$.coll=$1; $$.haveRest=1; }
	| PALL	{ $$.coll=new_Coll(NULL,NULL); $$.haveRest=1;  }
	;

with_arglist: { $$.coll=new_Coll(NULL,NULL); $$.haveRest=0; }
	| WITH with_arg_list		{ $$.coll=$2; $$.haveRest=0; }
	| WITH with_arg_list ',' PALL	{ $$.coll=$2; $$.haveRest=1; }
	| WITH PALL	{ $$.coll=new_Coll(NULL,NULL); $$.haveRest=1;  }
	;
/*
with:			{ $$.coll=new_Coll(NULL,NULL); $$.haveRest=0; }
	| WITH with_arglist; 	{
			Coll *cp;
			int i;
			Node *np;

			$$=$2;
			cp = $$.coll;
			for(i=0; i<cp->count; i++)
			{
				np = (Node*) cp->items[i];
				if (np->isRef||np->isConst||(!np->isLval && !np->isField))
					continue;
				cp->items[i] = new_RefNode(np);
			}
		}
	;
*/
with_arg_list: arg	{
			$$=new_Coll(NULL,NULL);
			if ($1) {
				Coll *cp;
				Node *np;

				insert_Coll($$,$1);
				cp = $$;
				np = (Node*) cp->items[0];
				if(!(np->isRef||np->isConst||(!np->isLval && !np->isField)))
					cp->items[0] = new_RefNode(np);
			}
		}
	| '(' arg ')' {
			$$=new_Coll(NULL,NULL);
			if ($2)
				insert_Coll($$,$2);
	}
	| with_arg_list ',' arg 	{
			$$=$1;
			if (!$$->count)
				insert_Coll($$,new_ArgNode(new_NilConstNode(),0));
			if ($3) {
				Coll *cp;
				Node *np;
				insert_Coll($$,$3);
				cp = $$;
				np = (Node*) cp->items[cp->count-1];
				if(!(np->isRef||np->isConst||(!np->isLval && !np->isField)))
					cp->items[cp->count-1] = new_RefNode(np);
			}
			else
				insert_Coll($$,new_ArgNode(new_NilConstNode(),0));
		}
	| with_arg_list ',' '(' arg ')'	{
			$$=$1;
			if (!$$->count)
				insert_Coll($$,new_ArgNode(new_NilConstNode(),0));
			if ($4)
				insert_Coll($$,$4);
			else
				insert_Coll($$,new_ArgNode(new_NilConstNode(),0));
		}
	;

arg_list: arg	{
			$$=new_Coll(NULL,NULL);
			if ($1)
				insert_Coll($$,$1);
		}
	| arg_list ',' arg 	{
			$$=$1;
			if (!$$->count)
				insert_Coll($$,new_ArgNode(new_NilConstNode(),0));
			if ($3)
				insert_Coll($$,$3);
			else
				insert_Coll($$,new_ArgNode(new_NilConstNode(),0));
		}
	;

arg:		{ $$=NULL; }
	| expr	{ $$=$1; /*$$=new_ArgNode($1,0);*/ }
	/*| '@' expr { $$=new_ArgNode($2,1); }*/
	;


pairlist: pair {}
	| pairlist ',' pair 	{}
	;

pair:	  NAME '#'  expr	{}
	| NUMBER '#'  expr	{}
	;


exprlist: nexpr			{
					$$=new_ExprListNode();
					$$->isConst=1;
					if ($1)
					{
						append_Node($$, $1);
						if (!$1->isConst)
							$$->isConst=0;
						else
							$$->isConst=1;
					}
				}
	| exprlist ',' nexpr 	{
					$$=$1;
					if (getCount_Node($$) == 0)
						append_Node($$,new_NilConstNode());
					if ($3)
					{
						append_Node($$, $3);
						if (!$3->isConst)
							$$->isConst=0;
					}
					else
						append_Node($$,new_NilConstNode());
				}
	;

nexpr:		{ $$=NULL; }
	| expr
	;

expr_list: expr	{ $$=new_ExprListNode(); append_Node($$, $1); }
	| expr_list ',' expr { $$=$1; append_Node($$, $3); }
	;

constant: STRING		{ $$=new_StringConstNode($1); }
	| TRUE			{ $$=new_LogicConstNode(1); }
	| FALSE			{ $$=new_LogicConstNode(0); }
	| NIL			{ $$=new_NilConstNode(); }
	| NUMBER		{ $$=new_NumberConstNode($1,0); }
	;

mconstant: constant
	| '-' constant	{ $$=$2; $$->isMinus = 1; }
	;

%%

/* ][ */

int clic_errorcount=0, clic_warncount;

int
clic_parse(const char *filename, FILE *stream)
{
  int ret=0;
  FILE *file;

  clic_errorcount=0;

  clic_warncount=0;

  curFile=new_File(strdup(filename));
  {
	char path[256], ch;
	const char *s;
	char *e;

#if 0
	*s=strrchr(filename, '/'); */
	if (s)
		s++;
	else
		s=filename;
#else
		s=filename;
#endif
	/*snprintf(path, sizeof(path), "_main_%s", s);*/
	snprintf(path, sizeof(path), "%s", s);
	e=strrchr(path, '.');
	if (e)
		*e=0;
	for (e = path; *e; ++e)
	{
		ch = *e;
		switch(ch)
		{
			case '.':
			case '/':
			case '\\':
			case '-':
			case '+':
				*e = '_';
		}
		*e = toupper(*e);
	}
	curFile->mname = strdup(path);
	if (nomain_flag)
		strncat(path,"_m",sizeof(path));

	curFunction=curFile->main=mainFunction=new_Function(strdup(path),new_VarColl(),nomain_flag?0:1,1,0,0);
	fin_Function(curFunction);
	fileStatics=curStatics=mainFunction->statics;
	push_operlist(curFunction->body);
	if (nomain_flag)
		mainFunction = 0;
	add_Function(curFile, curFunction);
  }

  if (stream)
	file=stream;
  else
	file=fopen(filename, "rt");

  if (file)
   {
	if (!lex_new_file(file, filename))
	{
	if (preproc_flag)
	{
		while( (ret=yylex())>0 )
			;
	}
	else
		ret=yyparse();
	}
	else
	{
		fclose(file);
		return -1;
	}
   }
  else
   {
	 yyerror("cannot open file '%s'", filename);
	 ret=-1;
   }

  if (ret==0)
   { /* test for all function definitions */
   }

  if (!stream && file)
	fclose(file);
  return ret;
}

static void
check_main()
{
	if (!mainFunction && curFunction==curFile->main)
		yyerror("executable operator outside of function (-n flag is active)");
}

static void
print_file()
{
	int index=-1, line, ret;
	char *filename;
	char *workingdirectory ;
	workingdirectory = getenv("PWD");

	do {
		ret = get_include (&index, &line, &filename);
		if (index>=0)
			fprintf(stderr, _clic_gettext("in file '%s',\n\tincluded at line %d "), filename, line);/*angelo*/
		else
			fprintf(stderr, _clic_gettext("in file '%s'\n"), filename);
	} while (ret!=0);
	fprintf(stderr, _clic_gettext("  working directory : '%s'\n"), workingdirectory);   /*angelo*/
}

int
yyerror(const char *s, ... )
{
	if (!clic_warncount && !clic_errorcount)
		fprintf(stderr, "\n");
	clic_errorcount++;
	if (s)
	{
		va_list ap;
		va_start(ap, s);
		fprintf(stderr, _clic_gettext("error %d: "), clic_errorcount);/*angelo*/
		vfprintf(stderr, _clic_gettext(s), ap);
		va_end(ap);

		fprintf(stderr,_clic_gettext("\n\tline %ld pos %ld (yychar=%d, '%c') "), cl_line+corr_line, cl_pos, yychar, (yychar>32&&yychar<256)?yychar:' ');/*angelo*/
	}
	else
		fprintf(stderr, _clic_gettext("error %d, (yychar=%d) "), clic_errorcount, yychar);/*angelo*/

	print_file();
	fflush(stdout);
	return 0;
}

int
yywarning(const char *s, ... )
{
	if (!clic_warncount && !clic_errorcount)
		fprintf(stderr, "\n");
	clic_warncount++;
	if (s)
	{
		va_list ap;
		va_start(ap, s);
		fprintf(stderr, _clic_gettext("warning %d: "), clic_warncount);/*angelo*/
		vfprintf(stderr, _clic_gettext(s), ap);
		va_end(ap);

		fprintf(stderr, _clic_gettext("\n\tline %ld, pos %ld, "), cl_line+corr_line, cl_pos);/*angelo*/
	}
	else
		fprintf(stderr, _clic_gettext("warning %d, "), clic_warncount);/*angelo*/
	print_file();
	fflush(stdout);
	return 0;
}

void
eof_checks(void)
{
	if (curFunction->inLoop>0)
	{
		yyerror("unclosed loop statement (level %d, begin at line %d file %s)",
			curFunction->inLoop, loop_line, fileName(loop_file) );
		/*curFunction->inLoop = 0;*/
	}
	if (if_depth)
	{
		yyerror("unclosed IF statement (level %d, begin at line %d file %s)",
			if_depth, if_line, fileName(if_file) );
		if_depth = 0;
	}
	if (curFunction->seqLevel>0)
	{
		yyerror("unclosed SEQUENCE statement (level %d, begin at line %d file %s)",
			curFunction->seqLevel, seq_line, fileName(seq_file) );
		/*curFunction->seqLevel = 0;*/
	}
}

static void upstr(char *str)
{
	char *s;
	for(s=str; *s; ++s)
		*s=toupper(*s);
}

Node *curr_operlist;
static Coll *operlist_stack=0;

static void
init_operlist_stack(void)
{
	if (!operlist_stack)
		operlist_stack = new_Coll(0,0);
}

static void
push_operlist(Node *operlist)
{
	init_operlist_stack();
	append_Coll(operlist_stack, operlist);
	curr_operlist = operlist;
}

static void
pop_operlist(void)
{
/*	init_operlist_stack();*/
	if (operlist_stack->count>0)
	{
		atRemove_Coll (operlist_stack, operlist_stack->count-1);
		curr_operlist = (Node*) operlist_stack->items[operlist_stack->count-1];
	}
}

static Node *
reduce_ExprListNode(Node *np)
{
	if (strcmp(np->name, "exprlist"))
		return np;
	if (getCount_Node(np) == 1)
	{
		Node *p = (Node*) np->list.head;
		return p;
	}
	else
	{
		((ExprListNode*)np)->last = 1;
		return np;
	}
}

static Node *
assop_node( int assop, char *area, Node *areaExpr, char*name, Node *nameExpr, Node *expr)
{
	switch(assop)
	{
	case '=':
	default:
		return new_AssignFieldNode(area, areaExpr, name, nameExpr, expr);
	case '+':
	case '-':
	case '*':
	case '/':
	case '^':
	case '%':
		return new_AssignFieldNode(area, areaExpr, name, nameExpr,
			new_OpNode(new2_FieldNode(area, areaExpr, name, nameExpr), expr, assop));
	}
}

