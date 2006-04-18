/* A Bison parser, made by GNU Bison 1.875d.  */

/* Skeleton parser for Yacc-like parsing with Bison,
   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

/* Written by Richard Stallman by simplifying the original so called
   ``semantic'' parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     STRING = 258,
     NUMBER = 259,
     ISTRING = 260,
     NAME = 261,
     CTEXT = 262,
     DATE = 263,
     KEYS = 264,
     PREPROC = 265,
     RETURN = 266,
     FUNCTION = 267,
     PROCEDURE = 268,
     IPROCEDURE = 269,
     EPROCEDURE = 270,
     EXTERN = 271,
     PARAMETERS = 272,
     SFUNCTION = 273,
     SPROCEDURE = 274,
     TEXT = 275,
     PUBLIC = 276,
     PRIVATE = 277,
     STATIC = 278,
     LOCAL = 279,
     DIMENSION = 280,
     NIL = 281,
     END = 282,
     TRUE = 283,
     FALSE = 284,
     WHILE = 285,
     DO = 286,
     ENDDO = 287,
     EXIT = 288,
     LOOP = 289,
     WITH = 290,
     CALL = 291,
     IF = 292,
     IIF = 293,
     ENDIF = 294,
     ELSE = 295,
     ELSEIF = 296,
     DOCASE = 297,
     CASE = 298,
     OTHERWISE = 299,
     ENDCASE = 300,
     SWITCH = 301,
     ENDSWITCH = 302,
     FIELD = 303,
     MEMVAR = 304,
     IN = 305,
     MEMVARPTR = 306,
     FIELDPTR = 307,
     PCOUNT = 308,
     PARBEG = 309,
     PARAMBEG = 310,
     PSHIFT = 311,
     PALL = 312,
     CGET = 313,
     FOR = 314,
     STEP = 315,
     TO = 316,
     NEXT = 317,
     FOREACH = 318,
     BEGSEQ = 319,
     RECOVER = 320,
     USING = 321,
     BREAK = 322,
     EBREAK = 323,
     ANNOUNCE = 324,
     REQUEST = 325,
     IFNL = 326,
     IFEXPR = 327,
     CODESTR = 328,
     CODEBLOCK = 329,
     AS = 330,
     REF = 331,
     POWA = 332,
     MULA = 333,
     MODA = 334,
     DIVA = 335,
     SUBA = 336,
     ADDA = 337,
     ASSIGN = 338,
     POSTINCR = 339,
     OR = 340,
     AND = 341,
     NOT = 342,
     NE = 343,
     EQ = 344,
     LE = 345,
     GE = 346,
     POW = 347,
     MINUS = 348,
     DECR = 349,
     INCR = 350,
     REPTR = 351,
     RPTR = 352,
     DSEMICOLON = 353
   };
#endif
#define STRING 258
#define NUMBER 259
#define ISTRING 260
#define NAME 261
#define CTEXT 262
#define DATE 263
#define KEYS 264
#define PREPROC 265
#define RETURN 266
#define FUNCTION 267
#define PROCEDURE 268
#define IPROCEDURE 269
#define EPROCEDURE 270
#define EXTERN 271
#define PARAMETERS 272
#define SFUNCTION 273
#define SPROCEDURE 274
#define TEXT 275
#define PUBLIC 276
#define PRIVATE 277
#define STATIC 278
#define LOCAL 279
#define DIMENSION 280
#define NIL 281
#define END 282
#define TRUE 283
#define FALSE 284
#define WHILE 285
#define DO 286
#define ENDDO 287
#define EXIT 288
#define LOOP 289
#define WITH 290
#define CALL 291
#define IF 292
#define IIF 293
#define ENDIF 294
#define ELSE 295
#define ELSEIF 296
#define DOCASE 297
#define CASE 298
#define OTHERWISE 299
#define ENDCASE 300
#define SWITCH 301
#define ENDSWITCH 302
#define FIELD 303
#define MEMVAR 304
#define IN 305
#define MEMVARPTR 306
#define FIELDPTR 307
#define PCOUNT 308
#define PARBEG 309
#define PARAMBEG 310
#define PSHIFT 311
#define PALL 312
#define CGET 313
#define FOR 314
#define STEP 315
#define TO 316
#define NEXT 317
#define FOREACH 318
#define BEGSEQ 319
#define RECOVER 320
#define USING 321
#define BREAK 322
#define EBREAK 323
#define ANNOUNCE 324
#define REQUEST 325
#define IFNL 326
#define IFEXPR 327
#define CODESTR 328
#define CODEBLOCK 329
#define AS 330
#define REF 331
#define POWA 332
#define MULA 333
#define MODA 334
#define DIVA 335
#define SUBA 336
#define ADDA 337
#define ASSIGN 338
#define POSTINCR 339
#define OR 340
#define AND 341
#define NOT 342
#define NE 343
#define EQ 344
#define LE 345
#define GE 346
#define POW 347
#define MINUS 348
#define DECR 349
#define INCR 350
#define REPTR 351
#define RPTR 352
#define DSEMICOLON 353




/* Copy the first part of user declarations.  */
#line 7 "clic.y"

/*
 * $Log: clic.tab.c,v $
 * Revision 1.14  2006/04/18 16:32:03  clip
 * admin
 * admin
 * admin
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
 *  (cAlias)->&(cf) := nSum    // этого не было
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



/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

#if ! defined (YYSTYPE) && ! defined (YYSTYPE_IS_DECLARED)
#line 426 "clic.y"
typedef union YYSTYPE {
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
} YYSTYPE;
/* Line 191 of yacc.c.  */
#line 711 "clic.tab.c"
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 214 of yacc.c.  */
#line 723 "clic.tab.c"

#if ! defined (yyoverflow) || YYERROR_VERBOSE

# ifndef YYFREE
#  define YYFREE free
# endif
# ifndef YYMALLOC
#  define YYMALLOC malloc
# endif

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   define YYSTACK_ALLOC alloca
#  endif
# else
#  if defined (alloca) || defined (_ALLOCA_H)
#   define YYSTACK_ALLOC alloca
#  else
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning. */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
# else
#  if defined (__STDC__) || defined (__cplusplus)
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   define YYSIZE_T size_t
#  endif
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
# endif
#endif /* ! defined (yyoverflow) || YYERROR_VERBOSE */


#if (! defined (yyoverflow) \
     && (! defined (__cplusplus) \
	 || (defined (YYSTYPE_IS_TRIVIAL) && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  short int yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (short int) + sizeof (YYSTYPE))			\
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined (__GNUC__) && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  register YYSIZE_T yyi;		\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (0)
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (0)

#endif

#if defined (__STDC__) || defined (__cplusplus)
   typedef signed char yysigned_char;
#else
   typedef short int yysigned_char;
#endif

/* YYFINAL -- State number of the termination state. */
#define YYFINAL  2
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   3295

/* YYNTOKENS -- Number of terminals. */
#define YYNTOKENS  122
/* YYNNTS -- Number of nonterminals. */
#define YYNNTS  80
/* YYNRULES -- Number of rules. */
#define YYNRULES  318
/* YYNRULES -- Number of states. */
#define YYNSTATES  638

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   353

#define YYTRANSLATE(YYX) 						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const unsigned char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     112,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,   121,    92,   101,   116,     2,
     113,   114,    99,    97,   115,    98,   108,   100,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,   106,     2,
      90,    91,    89,     2,    85,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,   107,     2,   120,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   117,   119,   118,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      86,    87,    88,    93,    94,    95,    96,   102,   103,   104,
     105,   109,   110,   111
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const unsigned short int yyprhs[] =
{
       0,     0,     3,     4,     8,    11,    15,    17,    20,    22,
      25,    27,    29,    30,    34,    35,    39,    40,    45,    50,
      53,    54,    58,    59,    63,    64,    68,    69,    73,    74,
      78,    81,    85,    88,    90,    93,    96,    99,   101,   105,
     111,   117,   124,   131,   136,   142,   150,   158,   168,   177,
     186,   197,   204,   209,   215,   222,   226,   230,   234,   236,
     243,   249,   250,   257,   261,   265,   269,   273,   275,   277,
     278,   290,   291,   301,   302,   303,   311,   314,   323,   324,
     333,   339,   346,   347,   350,   353,   355,   360,   361,   364,
     367,   371,   373,   375,   377,   378,   380,   386,   392,   393,
     395,   396,   403,   404,   405,   408,   409,   412,   414,   416,
     418,   420,   421,   427,   428,   432,   434,   436,   437,   440,
     442,   448,   449,   453,   455,   457,   459,   461,   462,   465,
     467,   470,   473,   475,   478,   481,   484,   488,   492,   497,
     501,   506,   508,   510,   514,   516,   518,   520,   524,   527,
     532,   537,   539,   543,   547,   551,   558,   563,   569,   572,
     576,   579,   585,   590,   595,   601,   608,   612,   620,   626,
     632,   641,   648,   655,   659,   664,   670,   677,   681,   686,
     692,   699,   706,   711,   717,   725,   733,   743,   752,   761,
     772,   779,   785,   790,   796,   803,   807,   811,   815,   819,
     823,   827,   831,   835,   839,   843,   847,   851,   855,   859,
     863,   867,   870,   873,   876,   879,   882,   885,   888,   892,
     896,   903,   908,   910,   912,   916,   920,   921,   927,   928,
     934,   935,   942,   951,   955,   956,   960,   961,   963,   965,
     967,   969,   972,   975,   977,   980,   983,   985,   987,   989,
     991,   993,   995,   997,   999,  1000,  1003,  1008,  1013,  1017,
    1020,  1024,  1027,  1032,  1034,  1038,  1041,  1044,  1048,  1053,
    1055,  1058,  1062,  1066,  1068,  1071,  1075,  1079,  1083,  1088,
    1089,  1092,  1097,  1098,  1100,  1104,  1106,  1110,  1112,  1116,
    1118,  1119,  1122,  1127,  1130,  1132,  1136,  1140,  1146,  1148,
    1152,  1153,  1155,  1157,  1161,  1165,  1169,  1171,  1175,  1176,
    1178,  1180,  1184,  1186,  1188,  1190,  1192,  1194,  1196
};

/* YYRHS -- A `-1'-separated list of the rules' RHS. */
static const short int yyrhs[] =
{
     123,     0,    -1,    -1,   123,   128,   112,    -1,   123,     7,
      -1,   123,    23,     7,    -1,    12,    -1,    23,    12,    -1,
      13,    -1,    23,    13,    -1,    14,    -1,    15,    -1,    -1,
     113,   187,   114,    -1,    -1,   127,   128,   112,    -1,    -1,
     124,     6,   126,   140,    -1,   125,     6,   126,   140,    -1,
      16,   188,    -1,    -1,    24,   129,   181,    -1,    -1,    23,
     130,   181,    -1,    -1,    21,   131,   181,    -1,    -1,    22,
     132,   181,    -1,    -1,    25,   133,   182,    -1,    49,   189,
      -1,    48,   189,   163,    -1,    17,   189,    -1,    11,    -1,
      11,   167,    -1,    70,   188,    -1,    69,     6,    -1,     1,
      -1,   167,    91,   167,    -1,     6,   110,     6,   177,   167,
      -1,     6,   110,   166,   177,   167,    -1,   174,     6,   110,
       6,   177,   167,    -1,   174,     6,   110,   166,   177,   167,
      -1,   174,     6,   177,   167,    -1,   166,   110,     6,   177,
     167,    -1,   113,   199,   114,   110,     6,   177,   167,    -1,
     113,   199,   114,   110,   166,   177,   167,    -1,   113,   199,
     114,   110,   113,   199,   114,   177,   167,    -1,   174,   113,
     199,   114,   110,     6,   177,   167,    -1,   174,   113,   199,
     114,   110,   166,   177,   167,    -1,   174,   113,   199,   114,
     110,   113,   199,   114,   177,   167,    -1,   174,   166,   110,
       6,   177,   167,    -1,   174,   166,   177,   167,    -1,   166,
     110,   166,   177,   167,    -1,   174,   166,   110,   166,   177,
     167,    -1,   164,    91,   167,    -1,   166,    91,   167,    -1,
     180,    91,   167,    -1,   167,    -1,     6,   113,   190,   114,
      91,   167,    -1,   113,   199,   114,    91,   167,    -1,    -1,
      30,   134,   167,   112,   127,   153,    -1,    31,     6,   191,
      -1,    31,   166,   191,    -1,    36,     6,   191,    -1,    36,
     166,   191,    -1,    33,    -1,    34,    -1,    -1,   144,   164,
     173,   167,    61,   167,   152,   112,   135,   127,   145,    -1,
      -1,   144,   164,    50,   167,   146,   112,   136,   127,   145,
      -1,    -1,    -1,    64,   150,   137,   127,   138,   148,    27,
      -1,    67,   198,    -1,    37,   113,   172,   115,   172,   115,
     172,   114,    -1,    -1,    37,   167,   112,   139,   127,   155,
     156,   157,    -1,    42,   112,   159,   160,   161,    -1,    46,
     167,   112,   141,   160,   162,    -1,    -1,    75,     6,    -1,
      76,     6,    -1,   142,    -1,   141,   143,   112,   127,    -1,
      -1,   142,   112,    -1,    43,   201,    -1,   143,   115,   201,
      -1,    59,    -1,    62,    -1,    27,    -1,    -1,     9,    -1,
     124,     6,   126,   140,   112,    -1,   125,     6,   126,   140,
     112,    -1,    -1,   147,    -1,    -1,    65,   150,   151,   112,
     149,   127,    -1,    -1,    -1,    66,   164,    -1,    -1,    60,
     167,    -1,    27,    -1,    32,    -1,    38,    -1,    37,    -1,
      -1,   155,    41,   167,   112,   127,    -1,    -1,    40,   112,
     127,    -1,    27,    -1,    39,    -1,    -1,   158,   112,    -1,
     158,    -1,   159,    43,   167,   112,   127,    -1,    -1,    44,
     112,   127,    -1,    27,    -1,    45,    -1,    27,    -1,    47,
      -1,    -1,    50,     6,    -1,     6,    -1,   175,     6,    -1,
     175,   166,    -1,     6,    -1,   175,     6,    -1,   174,     6,
      -1,   116,   165,    -1,   116,   165,   108,    -1,     6,   116,
     165,    -1,   116,   165,   108,     6,    -1,   116,   165,     4,
      -1,   116,   113,   167,   114,    -1,   200,    -1,     5,    -1,
       5,   102,   167,    -1,     8,    -1,   164,    -1,   166,    -1,
     113,   199,   114,    -1,    85,   167,    -1,     6,   113,   190,
     114,    -1,   166,   113,   190,   114,    -1,   180,    -1,   164,
     176,   167,    -1,   180,   176,   167,    -1,   166,   176,   167,
      -1,   167,   106,     6,   113,   190,   114,    -1,   180,   113,
     190,   114,    -1,   111,     6,   113,   190,   114,    -1,   174,
       6,    -1,     6,   110,     6,    -1,   174,   166,    -1,     6,
     109,   113,   167,   114,    -1,   174,     6,   110,     6,    -1,
     174,     6,   110,   166,    -1,     6,   110,   113,   199,   114,
      -1,   174,     6,   110,   113,   199,   114,    -1,     6,   110,
     166,    -1,   113,   199,   114,   110,   113,   199,   114,    -1,
     113,   199,   114,   110,   166,    -1,   113,   199,   114,   110,
       6,    -1,   174,   113,   199,   114,   110,   113,   199,   114,
      -1,   174,   113,   199,   114,   110,   166,    -1,   174,   113,
     199,   114,   110,     6,    -1,   166,   110,     6,    -1,   174,
     166,   110,     6,    -1,   166,   110,   113,   199,   114,    -1,
     174,   166,   110,   113,   199,   114,    -1,   166,   110,   166,
      -1,   174,   166,   110,   166,    -1,     6,   110,     6,   176,
     167,    -1,   174,     6,   110,     6,   176,   167,    -1,   174,
       6,   110,   166,   176,   167,    -1,   174,     6,   176,   167,
      -1,   166,   110,     6,   176,   167,    -1,   113,   199,   114,
     110,     6,   176,   167,    -1,   113,   199,   114,   110,   166,
     176,   167,    -1,   113,   199,   114,   110,   113,   199,   114,
     176,   167,    -1,   174,   113,   199,   114,   110,     6,   176,
     167,    -1,   174,   113,   199,   114,   110,   166,   176,   167,
      -1,   174,   113,   199,   114,   110,   113,   199,   114,   176,
     167,    -1,   174,   166,   110,     6,   176,   167,    -1,     6,
     110,   166,   176,   167,    -1,   174,   166,   176,   167,    -1,
     166,   110,   166,   176,   167,    -1,   174,   166,   110,   166,
     176,   167,    -1,   167,    91,   167,    -1,   167,    94,   167,
      -1,   167,    93,   167,    -1,   167,    90,   167,    -1,   167,
      89,   167,    -1,   167,    95,   167,    -1,   167,    96,   167,
      -1,   167,    97,   167,    -1,   167,    92,   167,    -1,   167,
      98,   167,    -1,   167,    99,   167,    -1,   167,   100,   167,
      -1,   167,   101,   167,    -1,   167,   102,   167,    -1,   167,
      87,   167,    -1,   167,    86,   167,    -1,    88,   167,    -1,
     105,   167,    -1,   167,   105,    -1,   104,   167,    -1,   167,
     104,    -1,    98,   167,    -1,    97,   167,    -1,   117,   197,
     118,    -1,   117,   195,   118,    -1,   117,   119,   178,   179,
     197,   118,    -1,    58,   113,   193,   114,    -1,    53,    -1,
      56,    -1,    54,   167,   120,    -1,    55,   167,   114,    -1,
      -1,    73,   171,   168,   197,   114,    -1,    -1,    74,   171,
     169,   197,   114,    -1,    -1,    24,   113,   178,   170,   181,
     114,    -1,   154,   113,   172,   115,   172,   115,   172,   114,
      -1,    68,   198,   114,    -1,    -1,   119,   187,   119,    -1,
      -1,   167,    -1,    83,    -1,    91,    -1,    52,    -1,   174,
      52,    -1,   175,    52,    -1,    51,    -1,   174,    51,    -1,
     175,    51,    -1,    83,    -1,    82,    -1,    81,    -1,    78,
      -1,    80,    -1,    79,    -1,    77,    -1,    91,    -1,    -1,
     187,   119,    -1,   167,   107,   199,   120,    -1,   180,   107,
     199,   120,    -1,   167,   106,     6,    -1,   111,     6,    -1,
     180,   106,     6,    -1,   185,   140,    -1,   181,   115,   185,
     140,    -1,   183,    -1,   182,   115,   183,    -1,     6,   184,
      -1,   166,   184,    -1,   113,   199,   114,    -1,   184,   113,
     199,   114,    -1,     6,    -1,     6,   186,    -1,     6,    83,
     167,    -1,   164,    91,   167,    -1,   166,    -1,   166,   186,
      -1,   166,    83,   167,    -1,   166,    91,   167,    -1,   107,
     199,   120,    -1,   186,   107,   199,   120,    -1,    -1,     6,
     140,    -1,   187,   115,     6,   140,    -1,    -1,     6,    -1,
     188,   115,     6,    -1,     6,    -1,   189,   115,     6,    -1,
     193,    -1,   193,   115,    57,    -1,    57,    -1,    -1,    35,
     192,    -1,    35,   192,   115,    57,    -1,    35,    57,    -1,
     194,    -1,   113,   194,   114,    -1,   192,   115,   194,    -1,
     192,   115,   113,   194,   114,    -1,   194,    -1,   193,   115,
     194,    -1,    -1,   167,    -1,   196,    -1,   195,   115,   196,
      -1,     6,   121,   167,    -1,     4,   121,   167,    -1,   198,
      -1,   197,   115,   198,    -1,    -1,   167,    -1,   167,    -1,
     199,   115,   167,    -1,     3,    -1,    28,    -1,    29,    -1,
      26,    -1,     4,    -1,   200,    -1,    98,   200,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const unsigned short int yyrline[] =
{
       0,   512,   512,   535,   544,   551,   556,   557,   560,   561,
     562,   563,   566,   567,   570,   571,   583,   584,   598,   612,
     633,   633,   645,   644,   657,   656,   668,   667,   679,   678,
     700,   701,   702,   703,   704,   706,   718,   728,   732,   733,
     734,   735,   736,   737,   738,   740,   741,   742,   743,   744,
     745,   747,   748,   749,   750,   752,   753,   754,   755,   756,
     770,   773,   772,   785,   787,   789,   791,   793,   800,   807,
     807,   814,   814,   821,   834,   821,   843,   846,   856,   855,
     879,   885,   891,   892,   893,   896,   897,   908,   911,   914,
     919,   926,   934,   935,   938,   939,   942,   943,   946,   953,
     961,   960,   974,   977,   978,   981,   982,   985,   986,   989,
     990,   993,   994,  1003,  1004,  1011,  1012,  1015,  1016,  1019,
    1020,  1029,  1030,  1037,  1038,  1041,  1042,  1045,  1046,  1049,
    1050,  1053,  1056,  1057,  1058,  1061,  1062,  1063,  1064,  1065,
    1067,  1070,  1071,  1093,  1098,  1103,  1104,  1105,  1109,  1111,
    1112,  1114,  1115,  1116,  1117,  1119,  1120,  1135,  1139,  1140,
    1141,  1143,  1146,  1147,  1148,  1149,  1150,  1152,  1153,  1154,
    1155,  1156,  1157,  1159,  1161,  1162,  1163,  1164,  1165,  1167,
    1168,  1169,  1170,  1171,  1173,  1174,  1175,  1176,  1177,  1178,
    1180,  1181,  1182,  1183,  1184,  1186,  1187,  1188,  1189,  1190,
    1191,  1192,  1193,  1194,  1196,  1197,  1198,  1199,  1200,  1201,
    1202,  1204,  1206,  1207,  1208,  1209,  1210,  1211,  1213,  1214,
    1215,  1236,  1237,  1238,  1239,  1240,  1242,  1242,  1244,  1244,
    1248,  1247,  1262,  1271,  1276,  1277,  1280,  1281,  1284,  1285,
    1288,  1289,  1290,  1293,  1294,  1295,  1298,  1299,  1300,  1301,
    1302,  1303,  1304,  1307,  1311,  1314,  1317,  1318,  1319,  1325,
    1332,  1339,  1347,  1360,  1364,  1371,  1372,  1375,  1376,  1379,
    1380,  1381,  1382,  1384,  1385,  1386,  1387,  1390,  1391,  1394,
    1395,  1403,  1414,  1415,  1419,  1433,  1437,  1444,  1445,  1446,
    1449,  1450,  1451,  1452,  1473,  1486,  1491,  1507,  1518,  1523,
    1534,  1535,  1540,  1541,  1544,  1545,  1549,  1561,  1576,  1577,
    1580,  1581,  1584,  1585,  1586,  1587,  1588,  1591,  1592
};
#endif

#if YYDEBUG || YYERROR_VERBOSE
/* YYTNME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals. */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "STRING", "NUMBER", "ISTRING", "NAME",
  "CTEXT", "DATE", "KEYS", "PREPROC", "RETURN", "FUNCTION", "PROCEDURE",
  "IPROCEDURE", "EPROCEDURE", "EXTERN", "PARAMETERS", "SFUNCTION",
  "SPROCEDURE", "TEXT", "PUBLIC", "PRIVATE", "STATIC", "LOCAL",
  "DIMENSION", "NIL", "END", "TRUE", "FALSE", "WHILE", "DO", "ENDDO",
  "EXIT", "LOOP", "WITH", "CALL", "IF", "IIF", "ENDIF", "ELSE", "ELSEIF",
  "DOCASE", "CASE", "OTHERWISE", "ENDCASE", "SWITCH", "ENDSWITCH", "FIELD",
  "MEMVAR", "IN", "MEMVARPTR", "FIELDPTR", "PCOUNT", "PARBEG", "PARAMBEG",
  "PSHIFT", "PALL", "CGET", "FOR", "STEP", "TO", "NEXT", "FOREACH",
  "BEGSEQ", "RECOVER", "USING", "BREAK", "EBREAK", "ANNOUNCE", "REQUEST",
  "IFNL", "IFEXPR", "CODESTR", "CODEBLOCK", "AS", "REF", "POWA", "MULA",
  "MODA", "DIVA", "SUBA", "ADDA", "ASSIGN", "POSTINCR", "'@'", "OR", "AND",
  "NOT", "'>'", "'<'", "'='", "'$'", "NE", "EQ", "LE", "GE", "'+'", "'-'",
  "'*'", "'/'", "'%'", "POW", "MINUS", "DECR", "INCR", "':'", "'['", "'.'",
  "REPTR", "RPTR", "DSEMICOLON", "'\\n'", "'('", "')'", "','", "'&'",
  "'{'", "'}'", "'|'", "']'", "'#'", "$accept", "file", "function",
  "procedure", "paramlist", "operlist", "oper", "@1", "@2", "@3", "@4",
  "@5", "@6", "@7", "@8", "@9", "@10", "@11", "type_def", "switchlist",
  "switchbeg", "switchlabel", "for", "next", "keys", "recoverr", "recover",
  "@12", "curseq", "using", "step", "enddo", "iif", "elseif", "else",
  "endif", "casebeg", "caselist", "otherwise", "endcase", "endswitch",
  "inalias", "name", "iname", "mname", "expr", "@13", "@14", "@15",
  "bparam_list", "nilexpr", "eassign", "fieldptr", "memvarptr", "assign",
  "ass_op", "func", "code", "arr", "vardef", "dimdef", "dim", "dim_list",
  "var", "arr_list", "param_list", "namelist", "varlist", "arglist",
  "with_arglist", "with_arg_list", "arg_list", "arg", "pairlist", "pair",
  "exprlist", "nexpr", "expr_list", "constant", "mconstant", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const unsigned short int yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,    64,   340,   341,   342,    62,
      60,    61,    36,   343,   344,   345,   346,    43,    45,    42,
      47,    37,   347,   348,   349,   350,    58,    91,    46,   351,
     352,   353,    10,    40,    41,    44,    38,   123,   125,   124,
      93,    35
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const unsigned char yyr1[] =
{
       0,   122,   123,   123,   123,   123,   124,   124,   125,   125,
     125,   125,   126,   126,   127,   127,   128,   128,   128,   128,
     129,   128,   130,   128,   131,   128,   132,   128,   133,   128,
     128,   128,   128,   128,   128,   128,   128,   128,   128,   128,
     128,   128,   128,   128,   128,   128,   128,   128,   128,   128,
     128,   128,   128,   128,   128,   128,   128,   128,   128,   128,
     128,   134,   128,   128,   128,   128,   128,   128,   128,   135,
     128,   136,   128,   137,   138,   128,   128,   128,   139,   128,
     128,   128,   140,   140,   140,   141,   141,   142,   142,   143,
     143,   144,   145,   145,   146,   146,   147,   147,   148,   148,
     149,   148,   150,   151,   151,   152,   152,   153,   153,   154,
     154,   155,   155,   156,   156,   157,   157,   158,   158,   159,
     159,   160,   160,   161,   161,   162,   162,   163,   163,   164,
     164,   164,   165,   165,   165,   166,   166,   166,   166,   166,
     166,   167,   167,   167,   167,   167,   167,   167,   167,   167,
     167,   167,   167,   167,   167,   167,   167,   167,   167,   167,
     167,   167,   167,   167,   167,   167,   167,   167,   167,   167,
     167,   167,   167,   167,   167,   167,   167,   167,   167,   167,
     167,   167,   167,   167,   167,   167,   167,   167,   167,   167,
     167,   167,   167,   167,   167,   167,   167,   167,   167,   167,
     167,   167,   167,   167,   167,   167,   167,   167,   167,   167,
     167,   167,   167,   167,   167,   167,   167,   167,   167,   167,
     167,   167,   167,   167,   167,   167,   168,   167,   169,   167,
     170,   167,   167,   167,   171,   171,   172,   172,   173,   173,
     174,   174,   174,   175,   175,   175,   176,   176,   176,   176,
     176,   176,   176,   177,   178,   179,   180,   180,   180,   180,
     180,   181,   181,   182,   182,   183,   183,   184,   184,   185,
     185,   185,   185,   185,   185,   185,   185,   186,   186,   187,
     187,   187,   188,   188,   188,   189,   189,   190,   190,   190,
     191,   191,   191,   191,   192,   192,   192,   192,   193,   193,
     194,   194,   195,   195,   196,   196,   197,   197,   198,   198,
     199,   199,   200,   200,   200,   200,   200,   201,   201
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const unsigned char yyr2[] =
{
       0,     2,     0,     3,     2,     3,     1,     2,     1,     2,
       1,     1,     0,     3,     0,     3,     0,     4,     4,     2,
       0,     3,     0,     3,     0,     3,     0,     3,     0,     3,
       2,     3,     2,     1,     2,     2,     2,     1,     3,     5,
       5,     6,     6,     4,     5,     7,     7,     9,     8,     8,
      10,     6,     4,     5,     6,     3,     3,     3,     1,     6,
       5,     0,     6,     3,     3,     3,     3,     1,     1,     0,
      11,     0,     9,     0,     0,     7,     2,     8,     0,     8,
       5,     6,     0,     2,     2,     1,     4,     0,     2,     2,
       3,     1,     1,     1,     0,     1,     5,     5,     0,     1,
       0,     6,     0,     0,     2,     0,     2,     1,     1,     1,
       1,     0,     5,     0,     3,     1,     1,     0,     2,     1,
       5,     0,     3,     1,     1,     1,     1,     0,     2,     1,
       2,     2,     1,     2,     2,     2,     3,     3,     4,     3,
       4,     1,     1,     3,     1,     1,     1,     3,     2,     4,
       4,     1,     3,     3,     3,     6,     4,     5,     2,     3,
       2,     5,     4,     4,     5,     6,     3,     7,     5,     5,
       8,     6,     6,     3,     4,     5,     6,     3,     4,     5,
       6,     6,     4,     5,     7,     7,     9,     8,     8,    10,
       6,     5,     4,     5,     6,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     2,     2,     2,     2,     2,     2,     2,     3,     3,
       6,     4,     1,     1,     3,     3,     0,     5,     0,     5,
       0,     6,     8,     3,     0,     3,     0,     1,     1,     1,
       1,     2,     2,     1,     2,     2,     1,     1,     1,     1,
       1,     1,     1,     1,     0,     2,     4,     4,     3,     2,
       3,     2,     4,     1,     3,     2,     2,     3,     4,     1,
       2,     3,     3,     1,     2,     3,     3,     3,     4,     0,
       2,     4,     0,     1,     3,     1,     3,     1,     3,     1,
       0,     2,     4,     2,     1,     3,     3,     5,     1,     3,
       0,     1,     1,     3,     3,     3,     1,     3,     0,     1,
       1,     3,     1,     1,     1,     1,     1,     1,     2
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const unsigned short int yydefact[] =
{
       2,     0,     1,    37,   312,   316,   142,   129,     4,   144,
      33,     6,     8,    10,    11,   282,     0,    24,    26,    22,
      20,    28,   315,   313,   314,    61,     0,    67,    68,     0,
       0,   109,     0,     0,     0,     0,   243,   240,   222,     0,
       0,   223,     0,    91,   102,   308,   308,     0,   282,   234,
     234,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     308,     0,     0,     0,     0,     0,   145,   146,    58,     0,
       0,   151,   141,     0,     0,     0,   300,     0,   129,     0,
     110,     0,   145,   146,    34,     0,   151,   283,    19,   285,
      32,     0,     0,     5,     7,     9,     0,   254,     0,     0,
       0,   290,   290,   290,   290,   236,     0,   117,     0,   127,
      30,     0,     0,   300,    73,   309,    76,     0,    36,    35,
     279,   226,   228,   148,   211,   217,   216,   214,   212,   259,
     310,     0,   132,     0,   135,     0,     0,   316,   129,   254,
       0,   302,     0,   306,    12,    12,     3,   129,     0,     0,
     236,   252,   249,   251,   250,   248,   247,   246,     0,     0,
       0,     0,   300,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     215,   213,     0,     0,   158,   244,   241,     0,   160,   130,
     245,   242,   131,     0,     0,     0,   300,     0,   143,     0,
     159,     0,   166,   289,   301,     0,   287,   298,   137,     0,
     300,     0,     0,     0,   158,     0,   160,     0,     0,   269,
       0,   273,    25,    82,    27,    23,   230,    21,     0,     0,
      29,   263,     0,   300,    63,    64,    65,    66,   237,     0,
      78,   119,   121,    87,     0,    31,   224,   225,     0,    14,
     233,    82,     0,   308,   308,   300,   147,     0,     0,   139,
     136,   134,   133,     0,     0,   279,     0,   219,   308,   218,
     279,    82,    82,     0,   238,   239,     0,   237,     0,    55,
     152,    56,   173,     0,   177,     0,   154,   210,   209,   199,
     198,   195,   203,   197,   196,   200,   201,   202,   204,   205,
     206,   207,   208,   258,     0,   253,     0,     0,     0,     0,
       0,     0,     0,    57,   260,     0,     0,   153,     0,     0,
       0,     0,     0,     0,   149,   300,   159,   166,     0,   147,
     173,   177,   195,     0,     0,     0,   284,   286,     0,     0,
     270,     0,     0,     0,   274,     0,     0,     0,   261,     0,
       0,   265,   266,     0,    14,   293,   300,   291,   294,   236,
      14,   118,     0,     0,     0,   121,    85,   128,   221,   300,
       0,   280,     0,   235,     0,     0,     0,     0,     0,   311,
     140,   138,   305,   304,   308,     0,     0,     0,   303,   307,
       0,    17,    18,    94,     0,   236,     0,     0,     0,     0,
       0,   150,   300,   256,   162,     0,   163,   182,    43,     0,
     174,     0,   178,   192,    52,   257,   156,   161,   179,    39,
     164,   191,    40,     0,   288,   299,   149,     0,   162,   163,
       0,   174,   178,   271,     0,     0,   272,   275,   276,    82,
      83,    84,     0,     0,     0,   264,     0,   301,     0,   300,
       0,     0,     0,    14,   123,   124,    80,     0,     0,     0,
      88,    22,     0,    98,    82,   227,   229,   157,    60,   169,
       0,   168,     0,   255,    13,    95,     0,     0,     0,   183,
      44,   175,   193,    53,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    59,   169,     0,   168,
       0,   277,     0,   262,   231,   267,     0,   107,   108,    62,
     295,   292,   300,   296,   236,   113,    14,     0,     0,   317,
      89,    14,     0,   125,   126,    81,    15,     0,   102,     0,
       0,    99,     0,   281,     0,     0,     0,     0,     0,   220,
      71,   105,   236,   155,   180,    41,   165,   181,    42,   172,
       0,   171,   190,    51,   176,   194,    54,     0,   172,     0,
     171,   278,   268,     0,     0,     0,     0,     0,     0,   318,
       0,    90,   103,    12,    12,    75,   184,    45,   167,   185,
      46,    14,     0,     0,     0,     0,     0,     0,     0,     0,
     167,     0,   297,    77,    14,     0,   115,   116,    79,     0,
       0,    82,    82,     0,     0,     0,   106,    69,   232,   187,
      48,   170,   188,    49,   170,     0,    14,   104,   100,     0,
       0,   186,    47,    93,    92,    72,    14,     0,     0,     0,
      14,    96,    97,     0,   189,    50,     0,    70
};

/* YYDEFGOTO[NTERM-NUM]. */
static const short int yydefgoto[] =
{
      -1,     1,    61,    62,   271,   370,   462,    98,    96,    91,
      92,    99,   100,   626,   581,   249,   463,   360,   348,   365,
     366,   458,    64,   625,   476,   531,   532,   630,   114,   600,
     583,   509,    65,   515,   567,   598,   241,   242,   364,   456,
     525,   245,    82,   134,    83,   130,   253,   254,   349,   121,
     239,   276,    85,    70,   159,   308,   226,   384,    86,   222,
     230,   231,   351,   223,   340,   252,    88,    90,   205,   234,
     357,   206,   207,   140,   141,   142,   143,   211,    72,   520
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -418
static const short int yypact[] =
{
    -418,  1073,  -418,  -418,  -418,  -418,   -71,   148,  -418,  -418,
    2702,  -418,  -418,  -418,  -418,    52,    78,  -418,  -418,   302,
     -22,  -418,  -418,  -418,  -418,  -418,    30,  -418,  -418,    36,
    2788,  -418,   -14,  2702,    78,    78,  -418,  -418,  -418,  2702,
    2702,  -418,     6,  -418,  -418,  2702,  2702,   133,    52,     9,
       9,  2702,  2702,  2702,  2702,  2702,  2702,   187,  2702,    -4,
     949,   222,   231,   132,    51,   146,   577,   637,  3147,    27,
      19,   540,  -418,  2702,   152,     1,  2358,    55,   176,   -22,
    -418,  2702,   797,   497,  3169,    29,   653,  -418,   158,  -418,
     162,    31,    31,  -418,  -418,  -418,    31,  -418,    31,    40,
    2702,   -23,   246,   -23,   246,  2702,  3027,  -418,  3051,   -28,
     162,  2864,  2923,  2702,  -418,  3169,  -418,   174,  -418,   158,
     328,  -418,  -418,  3169,  3188,   225,   225,   225,   225,   239,
    3169,   -47,  -418,  2702,    12,   199,   228,   191,   261,  -418,
      -7,  -418,     0,  -418,   254,   254,  -418,  -418,   138,   297,
    2702,  -418,  -418,  -418,  -418,  -418,  -418,  -418,  2702,  2702,
    2702,    11,  2358,  2702,  2702,  2702,  2702,  2702,  2702,  2702,
    2702,  2702,  2702,  2702,  2702,  2702,  2702,  2702,  2702,  2702,
    -418,  -418,   353,  2702,   217,  -418,  -418,  2702,   421,   259,
    -418,  -418,  -418,  2702,   375,  2702,  2358,  2702,   225,  2702,
     381,  2702,   797,  -418,  3169,   224,   229,  -418,  -418,    13,
    2358,   236,    20,  2702,   473,  2702,   690,   378,   387,   210,
     309,    47,   282,   290,   282,   282,  -418,   282,    69,   289,
     308,  -418,  3075,  2444,  -418,  -418,  -418,  -418,  2949,   314,
    -418,   319,   329,  -418,   438,  -418,  -418,  -418,   265,  -418,
    -418,   290,   -85,  2702,  2702,  2358,   -25,  2702,  2975,  -418,
     443,  -418,  -418,  2702,  2702,   328,   341,  -418,  2702,  -418,
     328,   290,   290,  2702,  -418,  -418,  2702,  3169,   355,  3169,
    3169,  3169,   381,  2702,   797,   361,  3169,   748,  3188,   697,
     697,   494,   697,   697,   697,   697,   697,   757,   757,   141,
     141,   141,   225,   367,   111,  -418,    21,  2702,  2702,   272,
      35,  2702,  2702,  3169,  -418,   140,   368,  3169,  3001,  2702,
    2702,   275,  2702,  2702,   390,  2530,   481,   797,   369,   376,
     481,   797,   697,    37,   291,    67,  -418,  -418,  2702,  2702,
     382,  2702,  2702,  2702,   382,    31,   490,   500,  -418,    31,
    2702,   394,   394,    40,  -418,  -418,  2702,   393,  -418,  2702,
    -418,  -418,  2702,   397,    65,   364,   398,  -418,  -418,  2702,
    1775,  -418,   508,  -418,   296,   300,   401,  2702,    71,  3169,
    -418,  -418,  3169,  3169,  2702,   -59,   191,   396,  -418,  -418,
     306,  -418,  -418,   819,  2842,  2702,  2702,  2702,   313,  2702,
    2702,  -418,  2358,  -418,   381,  2702,   797,  3169,  3169,   408,
     381,  2702,   797,  3169,  3169,  -418,  -418,  -418,  3169,  3169,
    -418,  3169,  3169,  2702,  -418,  -418,  -418,    84,   481,   797,
     410,   481,   797,  3169,   205,  2702,  3169,  3169,  3169,   290,
    -418,  -418,   322,   324,  2702,  -418,  1892,  2896,   407,  2616,
     411,  1190,  3099,  -418,  -418,  -418,  -418,   207,   201,    22,
    -418,   404,   413,   226,   290,  -418,  -418,  -418,  3169,   381,
    2702,   797,   221,  -418,  -418,  -418,   417,  2702,   415,  3169,
    3169,  -418,  3169,  3169,   424,  2702,  2702,   326,  2702,  2702,
      88,  2702,  2702,   332,  2702,  2702,  3169,   481,  2702,   797,
      90,  -418,   208,  -418,  -418,  -418,   338,  -418,  -418,  -418,
    -418,  -418,  2702,  -418,  2702,   414,  -418,  1658,    60,  -418,
    -418,  -418,   207,  -418,  -418,  -418,  -418,   404,  -418,   516,
     529,  -418,   512,  -418,  2702,  2702,   342,  2702,  2702,  -418,
    -418,  2820,  2702,  -418,  3169,  3169,  -418,  3169,  3169,   381,
    2702,   797,  3169,  3169,  -418,  3169,  3169,   351,   481,  2702,
     797,  -418,  -418,   426,   428,   433,  2702,    86,  1307,  -418,
    1424,  -418,   483,   254,   254,  -418,  3169,  3169,   738,  3169,
    3169,  -418,  2702,   458,   457,  2702,  2702,   354,  2702,  2702,
     797,   359,  -418,  -418,  -418,  3123,  -418,  -418,  -418,    51,
     460,   290,   290,  2702,  2702,  2009,  3169,  -418,  -418,  3169,
    3169,   738,  3169,  3169,   797,  2126,  -418,  -418,  -418,   470,
     474,  3169,  3169,  -418,  -418,  -418,  -418,  2702,  2702,  1541,
    -418,  -418,  -418,  2009,  3169,  3169,  2243,  -418
};

/* YYPGOTO[NTERM-NUM].  */
static const short int yypgoto[] =
{
    -418,  -418,   142,   145,  -139,  -238,   608,  -418,  -418,  -418,
    -418,  -418,  -418,  -418,  -418,  -418,  -418,  -418,  -248,  -418,
    -418,  -418,  -418,   -21,  -418,  -418,  -418,  -418,    83,  -418,
    -418,  -418,  -418,  -418,  -418,  -418,  -418,  -418,   248,  -418,
    -418,  -418,   178,   538,   334,    -1,  -418,  -418,  -418,   566,
    -129,  -418,   122,   130,   461,  -187,   486,  -418,    73,   -78,
    -418,   277,   405,   288,   416,  -110,   588,   444,  -134,   200,
    -418,   525,  -225,  -418,   384,  -243,   -41,     7,  -417,   120
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -311
static const short int yytable[] =
{
      68,   312,   132,   371,   116,   117,   272,   200,   358,    84,
     374,   375,   233,   320,   224,   323,   259,   282,   225,   326,
     227,   278,   244,   391,   392,   189,   330,   404,   285,   106,
     372,    73,   108,   184,   373,   214,   101,   219,   111,   112,
     519,   410,   103,   428,   115,   115,   228,    36,    37,   523,
     123,   124,   125,   126,   127,   128,   372,   147,    87,   115,
     473,   132,   316,     4,     5,   131,   377,   256,   257,   524,
     190,   191,   198,   431,    71,   204,   328,   469,   185,   186,
     185,   186,    36,    37,    89,   378,    22,   218,    23,    24,
     497,    97,   454,    77,   549,   397,   558,   400,   107,   232,
     425,   569,    36,    37,   238,   519,    36,    37,   266,   133,
     455,   267,   204,   596,   201,   268,   446,    59,   269,   113,
     260,   376,   451,    69,   283,   597,   201,    59,   120,    59,
     342,   448,   258,   283,   405,    59,    59,    59,   343,   118,
     187,   472,   215,    59,   425,    59,    59,    59,   411,   277,
     405,    59,    59,    59,   339,   385,    59,   279,   280,   281,
     390,   204,   286,   287,   288,   289,   290,   291,   292,   293,
     294,   295,   296,   297,   298,   299,   300,   301,   302,    66,
     411,   135,   350,    59,   470,    77,   149,    59,   273,   136,
     304,   503,   313,   129,   309,   204,   317,   498,   318,   135,
      59,   550,   315,   559,    59,   261,    59,   136,   321,   204,
       4,     5,   332,   149,   149,   517,   533,   486,   149,   489,
     149,   274,   334,   492,   513,   495,   257,   389,   144,   275,
     450,   403,   204,    22,   262,    23,    24,   145,    11,    12,
      13,    14,   148,   179,   146,   180,   181,   182,   183,   527,
     185,   186,   115,   115,   204,   257,   379,    74,    75,   150,
     415,    76,   382,   383,    77,   199,   478,   115,   484,   220,
     220,   442,   393,   217,   220,   394,   220,   218,   568,   190,
     191,   233,   535,   570,   538,    74,   209,   563,   250,   210,
     398,   528,    77,   338,   151,   152,   153,   154,   155,   156,
     157,  -129,   235,   236,   237,   518,   407,   408,   305,    93,
     413,   414,   263,   521,    94,    95,   522,   339,   418,   419,
     257,   421,   422,   257,   204,   501,    77,   306,   561,   180,
     181,   182,   183,    77,   251,    67,   268,   433,   324,   539,
     436,   437,   438,   605,   325,   386,   434,   387,   185,   186,
     329,   257,   255,   619,   620,   447,   615,   443,   277,   303,
     102,   452,   586,   104,   589,   346,   347,   270,   204,    68,
      74,   209,   362,   363,   210,    77,   468,    77,   629,   368,
     369,   314,   264,   115,   336,   564,   409,   257,   633,   420,
     257,   604,   636,   337,   277,   479,   480,   345,   482,   483,
     341,   204,   350,   188,   192,   430,   257,   457,   363,   202,
     465,   268,   487,   584,   466,   268,    94,    95,   493,   216,
     474,   372,   496,   353,   628,   221,   221,   481,   257,   359,
     221,   361,   221,   229,   601,   602,   504,   345,   505,   257,
     546,   257,   502,    71,   367,    68,   554,   257,   204,   381,
      68,   506,   562,   257,   565,   566,   578,   257,   151,   152,
     153,   154,   155,   156,   157,   590,   257,   149,   611,   257,
     395,   149,   305,   614,   257,   401,   541,   536,   109,   110,
     402,   423,   416,   426,   544,   545,   427,   547,   548,   435,
     552,   553,    69,   555,   556,   284,   440,    77,   151,   152,
     153,   154,   155,   156,   157,   557,   441,   444,   449,   453,
     460,   447,   305,   277,   464,   467,    68,   264,   490,    71,
     500,   510,   573,   220,    71,   526,   514,   220,   163,   540,
     542,   310,   197,   576,   577,   574,   579,   580,   543,   575,
     592,   277,   593,   327,   163,   594,   331,   197,    66,   599,
     151,   152,   153,   154,   155,   156,   157,   587,   151,   152,
     153,   154,   155,   156,   157,   595,   591,    68,    69,    68,
     607,   608,   618,    69,   151,   152,   153,   154,   155,   156,
     157,   606,   631,   333,   609,   610,   632,   612,   613,    77,
      71,   174,   175,   176,   177,   178,   179,    77,   180,   181,
     182,   183,   621,   622,    68,   529,   -38,   212,   530,    63,
     162,   572,   637,   459,    68,   208,   122,   151,   152,   153,
     154,   155,   156,   157,    66,   265,   634,   635,    68,    66,
     445,   193,    68,   439,   352,    68,   119,   344,   248,    69,
     406,    71,   571,    71,   412,   307,   194,   195,     0,   311,
     388,     0,     0,   196,   151,   152,   153,   154,   155,   156,
     157,   319,     0,   322,     0,     0,     0,   429,   158,   432,
       0,     0,     0,     0,     0,   307,     0,   311,    71,   221,
       0,     0,     0,   221,     0,     0,     0,   229,    71,     0,
      69,     0,    69,     0,     0,    66,     0,     0,     0,     0,
       0,     0,    71,     0,    67,     0,    71,     0,     0,    71,
       0,     0,   471,     0,   151,   152,   153,   154,   155,   156,
     157,   149,     0,     0,     0,     0,     0,    69,   160,     0,
     151,   152,   153,   154,   155,   156,   157,    69,     0,     0,
       0,     0,     0,   396,     0,   399,    66,   161,    66,     0,
     162,    69,     0,     0,     0,    69,     0,     0,    69,   194,
     195,   499,     0,     0,     0,     0,   196,   151,   152,   153,
     154,   155,   156,   157,     0,     0,     0,   617,     0,     0,
      67,     0,     0,    66,     0,    67,     0,   319,   322,     0,
       0,   396,   399,    66,   174,   175,   176,   177,   178,   179,
     335,   180,   181,   182,   183,     0,     0,    66,     0,     0,
       0,    66,     0,     0,    66,   151,   152,   153,   154,   155,
     156,   157,     0,     0,   551,     0,     0,     0,   475,   305,
       0,     0,     0,     0,   560,   165,     0,   166,   167,   213,
     169,   170,   171,   172,   173,   174,   175,   176,   177,   178,
     179,    67,   180,   181,   182,   183,   176,   177,   178,   179,
       0,   180,   181,   182,   183,   485,     0,   488,     0,     0,
       0,   491,     0,   494,   151,   152,   153,   154,   155,   156,
     157,     0,     0,     0,     0,     0,     0,     0,     0,   485,
     488,     0,   491,   494,     0,     0,     0,     0,     0,     0,
       0,     0,    67,     0,    67,   164,   165,     0,   166,   167,
     213,   169,   170,   171,   172,   173,   174,   175,   176,   177,
     178,   179,     0,   180,   181,   182,   183,     0,     0,     0,
     534,     0,   537,     0,     0,     0,     0,     0,     0,    67,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    67,
       0,     0,     4,   137,     6,   138,     0,     9,   534,     0,
     537,     0,     0,    67,     0,     0,     0,    67,     0,     0,
      67,     0,     0,    79,     0,    22,     0,    23,    24,     0,
       0,     0,     0,     0,     0,     0,    80,    31,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      36,    37,    38,    39,    40,    41,     0,    42,     0,     0,
     585,     0,   588,     0,     0,     0,     0,    46,     0,   585,
       0,   588,    49,    50,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    51,     0,     0,    52,     0,   603,
       0,     0,     0,     0,     0,     0,    53,    54,     0,     0,
       0,   603,     0,    55,    56,     0,     0,     0,     0,     0,
      57,     0,    81,     0,     0,    59,    60,     0,   139,     0,
       0,     0,   627,     2,     3,   627,     4,     5,     6,     7,
       8,     9,     0,     0,    10,    11,    12,    13,    14,    15,
      16,     0,     0,     0,    17,    18,    19,    20,    21,    22,
       0,    23,    24,    25,    26,     0,    27,    28,     0,    29,
      30,    31,     0,     0,     0,    32,     0,     0,     0,    33,
       0,    34,    35,     0,    36,    37,    38,    39,    40,    41,
       0,    42,    43,     0,     0,     0,     0,    44,     0,     0,
      45,    46,    47,    48,     0,     0,    49,    50,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    51,     0,
       0,    52,     0,     0,     0,     0,     0,     0,     0,     0,
      53,    54,     0,     0,     0,     0,     0,    55,    56,     0,
       0,     0,     0,     0,    57,   -16,    58,     0,     0,    59,
      60,     3,     0,     4,     5,     6,     7,     0,     9,     0,
       0,    10,    11,    12,    13,    14,    15,    16,     0,     0,
       0,    17,    18,   461,    20,    21,    22,  -111,    23,    24,
      25,    26,     0,    27,    28,     0,    29,    30,    31,  -111,
    -111,  -111,    32,     0,     0,     0,    33,     0,    34,    35,
       0,    36,    37,    38,    39,    40,    41,     0,    42,    43,
       0,     0,     0,     0,    44,     0,     0,    45,    46,    47,
      48,     0,     0,    49,    50,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    51,     0,     0,    52,     0,
       0,     0,     0,     0,     0,     0,     0,    53,    54,     0,
       0,     0,     0,     0,    55,    56,     0,     0,     0,     0,
       0,    57,   -16,    58,     0,     0,    59,    60,     3,     0,
       4,     5,     6,     7,     0,     9,     0,     0,    10,    11,
      12,    13,    14,    15,    16,     0,     0,     0,    17,    18,
     461,    20,    21,    22,  -120,    23,    24,    25,    26,     0,
      27,    28,     0,    29,    30,    31,     0,     0,     0,    32,
    -120,  -120,  -120,    33,     0,    34,    35,     0,    36,    37,
      38,    39,    40,    41,     0,    42,    43,     0,     0,     0,
       0,    44,     0,     0,    45,    46,    47,    48,     0,     0,
      49,    50,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    51,     0,     0,    52,     0,     0,     0,     0,
       0,     0,     0,     0,    53,    54,     0,     0,     0,     0,
       0,    55,    56,     0,     0,     0,     0,     0,    57,   -16,
      58,     0,     0,    59,    60,     3,     0,     4,     5,     6,
       7,     0,     9,     0,     0,    10,    11,    12,    13,    14,
      15,    16,     0,     0,     0,    17,    18,   461,    20,    21,
      22,   -86,    23,    24,    25,    26,     0,    27,    28,     0,
      29,    30,    31,     0,     0,     0,    32,   -86,   -86,     0,
      33,   -86,    34,    35,     0,    36,    37,    38,    39,    40,
      41,     0,    42,    43,     0,     0,     0,     0,    44,     0,
       0,    45,    46,    47,    48,     0,     0,    49,    50,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    51,
       0,     0,    52,     0,     0,     0,     0,     0,     0,     0,
       0,    53,    54,     0,     0,     0,     0,     0,    55,    56,
       0,     0,     0,     0,     0,    57,   -16,    58,     0,     0,
      59,    60,     3,     0,     4,     5,     6,     7,     0,     9,
       0,     0,    10,    11,    12,    13,    14,    15,    16,     0,
       0,     0,    17,    18,   461,    20,    21,    22,  -112,    23,
      24,    25,    26,     0,    27,    28,     0,    29,    30,    31,
    -112,  -112,  -112,    32,     0,     0,     0,    33,     0,    34,
      35,     0,    36,    37,    38,    39,    40,    41,     0,    42,
      43,     0,     0,     0,     0,    44,     0,     0,    45,    46,
      47,    48,     0,     0,    49,    50,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    51,     0,     0,    52,
       0,     0,     0,     0,     0,     0,     0,     0,    53,    54,
       0,     0,     0,     0,     0,    55,    56,     0,     0,     0,
       0,     0,    57,   -16,    58,     0,     0,    59,    60,     3,
       0,     4,     5,     6,     7,     0,     9,     0,     0,    10,
      11,    12,    13,    14,    15,    16,     0,     0,     0,    17,
      18,   461,    20,    21,    22,  -122,    23,    24,    25,    26,
       0,    27,    28,     0,    29,    30,    31,     0,     0,     0,
      32,     0,     0,  -122,    33,  -122,    34,    35,     0,    36,
      37,    38,    39,    40,    41,     0,    42,    43,     0,     0,
       0,     0,    44,     0,     0,    45,    46,    47,    48,     0,
       0,    49,    50,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    51,     0,     0,    52,     0,     0,     0,
       0,     0,     0,     0,     0,    53,    54,     0,     0,     0,
       0,     0,    55,    56,     0,     0,     0,     0,     0,    57,
     -16,    58,     0,     0,    59,    60,     3,     0,     4,     5,
       6,     7,     0,     9,     0,     0,    10,    11,    12,    13,
      14,    15,    16,     0,     0,     0,    17,    18,   461,    20,
      21,    22,   -74,    23,    24,    25,    26,     0,    27,    28,
       0,    29,    30,    31,     0,     0,     0,    32,     0,     0,
       0,    33,     0,    34,    35,     0,    36,    37,    38,    39,
      40,    41,     0,    42,    43,     0,     0,     0,     0,    44,
     -74,     0,    45,    46,    47,    48,     0,     0,    49,    50,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      51,     0,     0,    52,     0,     0,     0,     0,     0,     0,
       0,     0,    53,    54,     0,     0,     0,     0,     0,    55,
      56,     0,     0,     0,     0,     0,    57,   -16,    58,     0,
       0,    59,    60,     3,     0,     4,     5,     6,     7,     0,
       9,     0,     0,    10,    11,    12,    13,    14,    15,    16,
       0,     0,     0,    17,    18,   461,    20,    21,    22,   507,
      23,    24,    25,    26,   508,    27,    28,     0,    29,    30,
      31,     0,     0,     0,    32,     0,     0,     0,    33,     0,
      34,    35,     0,    36,    37,    38,    39,    40,    41,     0,
      42,    43,     0,     0,     0,     0,    44,     0,     0,    45,
      46,    47,    48,     0,     0,    49,    50,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    51,     0,     0,
      52,     0,     0,     0,     0,     0,     0,     0,     0,    53,
      54,     0,     0,     0,     0,     0,    55,    56,     0,     0,
       0,     0,     0,    57,   -16,    58,     0,     0,    59,    60,
       3,     0,     4,     5,     6,     7,     0,     9,     0,     0,
      10,    11,    12,    13,    14,    15,    16,     0,     0,     0,
      17,    18,   461,    20,    21,    22,   623,    23,    24,    25,
      26,     0,    27,    28,     0,    29,    30,    31,     0,     0,
       0,    32,     0,     0,     0,    33,     0,    34,    35,     0,
      36,    37,    38,    39,    40,    41,     0,    42,    43,     0,
       0,   624,     0,    44,     0,     0,    45,    46,    47,    48,
       0,     0,    49,    50,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    51,     0,     0,    52,     0,     0,
       0,     0,     0,     0,     0,     0,    53,    54,     0,     0,
       0,     0,     0,    55,    56,     0,     0,     0,     0,     0,
      57,   -16,    58,     0,     0,    59,    60,     3,     0,     4,
       5,     6,     7,     0,     9,     0,     0,    10,    11,    12,
      13,    14,    15,    16,     0,     0,     0,    17,    18,   461,
      20,    21,    22,  -114,    23,    24,    25,    26,     0,    27,
      28,     0,    29,    30,    31,  -114,     0,     0,    32,     0,
       0,     0,    33,     0,    34,    35,     0,    36,    37,    38,
      39,    40,    41,     0,    42,    43,     0,     0,     0,     0,
      44,     0,     0,    45,    46,    47,    48,     0,     0,    49,
      50,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    51,     0,     0,    52,     0,     0,     0,     0,     0,
       0,     0,     0,    53,    54,     0,     0,     0,     0,     0,
      55,    56,     0,     0,     0,     0,     0,    57,   -16,    58,
       0,     0,    59,    60,     3,     0,     4,     5,     6,     7,
       0,     9,     0,     0,    10,    11,    12,    13,    14,    15,
      16,     0,     0,     0,    17,    18,   461,    20,    21,    22,
    -101,    23,    24,    25,    26,     0,    27,    28,     0,    29,
      30,    31,     0,     0,     0,    32,     0,     0,     0,    33,
       0,    34,    35,     0,    36,    37,    38,    39,    40,    41,
       0,    42,    43,     0,     0,     0,     0,    44,     0,     0,
      45,    46,    47,    48,     0,     0,    49,    50,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    51,     0,
       0,    52,     0,     0,     0,     0,     0,     0,     0,     0,
      53,    54,     0,     0,     0,     0,     0,    55,    56,     0,
       0,     0,     0,     0,    57,   -16,    58,     0,     0,    59,
      60,     4,     5,     6,    78,     0,     9,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    79,     0,    22,     0,    23,    24,     0,     0,
       0,     0,     0,     0,     0,    80,    31,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    36,
      37,    38,    39,    40,    41,   203,    42,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    46,     0,     0,     0,
       0,    49,    50,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    51,     0,     0,    52,     4,     5,     6,
      78,     0,     9,     0,     0,    53,    54,     0,     0,     0,
       0,     0,    55,    56,     0,     0,     0,     0,    79,    57,
      22,    81,    23,    24,    59,    60,     0,     0,     0,     0,
       0,    80,    31,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    36,    37,    38,    39,    40,
      41,   355,    42,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    46,     0,     0,     0,     0,    49,    50,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    51,
       0,     0,    52,     4,     5,     6,    78,     0,     9,     0,
       0,    53,    54,     0,     0,     0,     0,     0,    55,    56,
       0,     0,     0,     0,    79,    57,    22,   356,    23,    24,
      59,    60,     0,     0,     0,     0,     0,    80,    31,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    36,    37,    38,    39,    40,    41,   424,    42,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    46,     0,
       0,     0,     0,    49,    50,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    51,     0,     0,    52,     4,
       5,     6,    78,     0,     9,     0,     0,    53,    54,     0,
       0,     0,     0,     0,    55,    56,     0,     0,     0,     0,
      79,    57,    22,    81,    23,    24,    59,    60,     0,     0,
       0,     0,     0,    80,    31,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    36,    37,    38,
      39,    40,    41,   511,    42,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    46,     0,     0,     0,     0,    49,
      50,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    51,     0,     0,    52,     4,     5,     6,    78,     0,
       9,     0,     0,    53,    54,     0,     0,     0,     0,     0,
      55,    56,     0,     0,     0,     0,    79,    57,    22,   512,
      23,    24,    59,    60,     0,     0,     0,     0,     0,    80,
      31,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    36,    37,    38,    39,    40,    41,     0,
      42,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      46,     0,     0,     0,     0,    49,    50,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    51,     0,     0,
      52,     4,     5,     6,    78,     0,     9,     0,     0,    53,
      54,     0,     0,     0,     0,     0,    55,    56,     0,     0,
       0,     0,    79,    57,    22,    81,    23,    24,    59,    60,
       0,     0,     0,     0,     0,    80,    31,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    36,
      37,    38,    39,    40,    41,     0,    42,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    46,     0,     0,     0,
       0,    49,    50,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    51,     0,     0,    52,     0,     0,     0,
     582,     0,     0,     0,     0,    53,    54,     0,     0,     0,
       0,     0,    55,    56,     0,     0,     0,     0,     0,    57,
       0,   105,     0,   477,    59,    60,   164,   165,     0,   166,
     167,   213,   169,   170,   171,   172,   173,   174,   175,   176,
     177,   178,   179,     0,   180,   181,   182,   183,   164,   165,
       0,   166,   167,   213,   169,   170,   171,   172,   173,   174,
     175,   176,   177,   178,   179,     0,   180,   181,   182,   183,
     164,   165,     0,   166,   167,   213,   169,   170,   171,   172,
     173,   174,   175,   176,   177,   178,   179,     0,   180,   181,
     182,   183,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   164,   165,   246,   166,   167,   213,   169,   170,
     171,   172,   173,   174,   175,   176,   177,   178,   179,     0,
     180,   181,   182,   183,     0,     0,     0,     0,     0,   164,
     165,  -310,   166,   167,   213,   169,   170,   171,   172,   173,
     174,   175,   176,   177,   178,   179,     0,   180,   181,   182,
     183,     0,     0,     0,     0,   164,   165,   247,   166,   167,
     213,   169,   170,   171,   172,   173,   174,   175,   176,   177,
     178,   179,     0,   180,   181,   182,   183,     0,     0,     0,
       0,   164,   165,  -310,   166,   167,   213,   169,   170,   171,
     172,   173,   174,   175,   176,   177,   178,   179,     0,   180,
     181,   182,   183,     0,     0,     0,     0,   164,   165,   380,
     166,   167,   213,   169,   170,   171,   172,   173,   174,   175,
     176,   177,   178,   179,     0,   180,   181,   182,   183,     0,
       0,     0,     0,   164,   165,   417,   166,   167,   213,   169,
     170,   171,   172,   173,   174,   175,   176,   177,   178,   179,
       0,   180,   181,   182,   183,     0,     0,   164,   165,   240,
     166,   167,   213,   169,   170,   171,   172,   173,   174,   175,
     176,   177,   178,   179,     0,   180,   181,   182,   183,     0,
       0,   164,   165,   243,   166,   167,   213,   169,   170,   171,
     172,   173,   174,   175,   176,   177,   178,   179,     0,   180,
     181,   182,   183,     0,     0,   164,   165,   354,   166,   167,
     213,   169,   170,   171,   172,   173,   174,   175,   176,   177,
     178,   179,     0,   180,   181,   182,   183,     0,     0,   164,
     165,   516,   166,   167,   213,   169,   170,   171,   172,   173,
     174,   175,   176,   177,   178,   179,     0,   180,   181,   182,
     183,     0,     0,   164,   165,   616,   166,   167,   168,   169,
     170,   171,   172,   173,   174,   175,   176,   177,   178,   179,
       0,   180,   181,   182,   183,   164,   165,     0,   166,   167,
     213,   169,   170,   171,   172,   173,   174,   175,   176,   177,
     178,   179,     0,   180,   181,   182,   183,   166,   167,   213,
     169,   170,   171,   172,   173,   174,   175,   176,   177,   178,
     179,     0,   180,   181,   182,   183
};

static const short int yycheck[] =
{
       1,   188,     6,   251,    45,    46,   145,     6,   233,    10,
     253,   254,    35,   200,    92,   202,     4,     6,    96,     6,
      98,   150,    50,   271,   272,     6,     6,     6,   162,    30,
     115,   102,    33,     6,   119,     6,     6,     6,    39,    40,
     457,     6,     6,     6,    45,    46,     6,    51,    52,    27,
      51,    52,    53,    54,    55,    56,   115,     6,     6,    60,
     119,     6,   196,     3,     4,    58,    91,   114,   115,    47,
      51,    52,    73,     6,     1,    76,   210,     6,    51,    52,
      51,    52,    51,    52,     6,   110,    26,   115,    28,    29,
       6,   113,    27,   116,     6,   282,     6,   284,   112,   100,
     325,   518,    51,    52,   105,   522,    51,    52,   115,   113,
      45,   118,   113,    27,   113,   115,   354,   116,   118,   113,
     108,   255,   360,     1,   113,    39,   113,   116,   119,   116,
      83,   356,   133,   113,   113,   116,   116,   116,    91,     6,
     113,   384,   113,   116,   369,   116,   116,   116,   113,   150,
     113,   116,   116,   116,   107,   265,   116,   158,   159,   160,
     270,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   175,   176,   177,   178,   179,     1,
     113,    59,   113,   116,   113,   116,    64,   116,    50,    59,
     183,   439,   193,     6,   187,   196,   197,   113,   199,    77,
     116,   113,   195,   113,   116,     6,   116,    77,   201,   210,
       3,     4,   213,    91,    92,   453,   464,   404,    96,   406,
      98,    83,   215,   410,   449,   412,   115,   268,     6,    91,
     359,   120,   233,    26,     6,    28,    29,     6,    12,    13,
      14,    15,    64,   102,   112,   104,   105,   106,   107,    23,
      51,    52,   253,   254,   255,   115,   257,   109,   110,   113,
     120,   113,   263,   264,   116,   113,   395,   268,   402,    91,
      92,   349,   273,   115,    96,   276,    98,   115,   516,    51,
      52,    35,   469,   521,   471,   109,   110,   512,   114,   113,
     283,    65,   116,    83,    77,    78,    79,    80,    81,    82,
      83,    91,   102,   103,   104,    98,   307,   308,    91,     7,
     311,   312,   121,   112,    12,    13,   115,   107,   319,   320,
     115,   322,   323,   115,   325,   120,   116,   110,   120,   104,
     105,   106,   107,   116,     6,     1,   115,   338,   114,   118,
     341,   342,   343,   581,   115,     4,   339,     6,    51,    52,
     114,   115,   113,   601,   602,   356,   594,   350,   359,     6,
      26,   362,   549,    29,   551,    75,    76,   113,   369,   370,
     109,   110,    43,    44,   113,   116,   377,   116,   616,   114,
     115,     6,   121,   384,     6,   514,   114,   115,   626,   114,
     115,   578,   630,     6,   395,   396,   397,   115,   399,   400,
      91,   402,   113,    69,    70,   114,   115,    43,    44,    75,
     114,   115,   405,   542,   114,   115,    12,    13,   411,    85,
     114,   115,   423,   115,   611,    91,    92,   114,   115,   115,
      96,   112,    98,    99,   573,   574,   114,   115,   114,   115,
     114,   115,   435,   370,     6,   446,   114,   115,   449,     6,
     451,   444,   114,   115,    40,    41,   114,   115,    77,    78,
      79,    80,    81,    82,    83,   114,   115,   345,   114,   115,
     115,   349,    91,   114,   115,   114,   477,   470,    34,    35,
     113,    91,   114,   114,   485,   486,   110,   488,   489,   107,
     491,   492,   370,   494,   495,   161,     6,   116,    77,    78,
      79,    80,    81,    82,    83,   498,     6,   113,   115,   112,
     112,   512,    91,   514,     6,   114,   517,   121,   110,   446,
     110,   114,     6,   345,   451,   112,   115,   349,    67,   112,
     115,   110,    71,   534,   535,     6,   537,   538,   114,    27,
     114,   542,   114,   209,    83,   112,   212,    86,   370,    66,
      77,    78,    79,    80,    81,    82,    83,   550,    77,    78,
      79,    80,    81,    82,    83,   566,   559,   568,   446,   570,
     112,   114,   112,   451,    77,    78,    79,    80,    81,    82,
      83,   582,   112,   110,   585,   586,   112,   588,   589,   116,
     517,    97,    98,    99,   100,   101,   102,   116,   104,   105,
     106,   107,   603,   604,   605,   463,   112,   110,   463,     1,
     113,   528,   633,   365,   615,    77,    50,    77,    78,    79,
      80,    81,    82,    83,   446,   139,   627,   628,   629,   451,
     353,    91,   633,   345,   229,   636,    48,   221,   113,   517,
     306,   568,   522,   570,   310,   184,   106,   107,    -1,   188,
     266,    -1,    -1,   113,    77,    78,    79,    80,    81,    82,
      83,   200,    -1,   202,    -1,    -1,    -1,   333,    91,   335,
      -1,    -1,    -1,    -1,    -1,   214,    -1,   216,   605,   345,
      -1,    -1,    -1,   349,    -1,    -1,    -1,   353,   615,    -1,
     568,    -1,   570,    -1,    -1,   517,    -1,    -1,    -1,    -1,
      -1,    -1,   629,    -1,   370,    -1,   633,    -1,    -1,   636,
      -1,    -1,   378,    -1,    77,    78,    79,    80,    81,    82,
      83,   599,    -1,    -1,    -1,    -1,    -1,   605,    91,    -1,
      77,    78,    79,    80,    81,    82,    83,   615,    -1,    -1,
      -1,    -1,    -1,   282,    -1,   284,   568,   110,   570,    -1,
     113,   629,    -1,    -1,    -1,   633,    -1,    -1,   636,   106,
     107,   427,    -1,    -1,    -1,    -1,   113,    77,    78,    79,
      80,    81,    82,    83,    -1,    -1,    -1,   599,    -1,    -1,
     446,    -1,    -1,   605,    -1,   451,    -1,   326,   327,    -1,
      -1,   330,   331,   615,    97,    98,    99,   100,   101,   102,
     110,   104,   105,   106,   107,    -1,    -1,   629,    -1,    -1,
      -1,   633,    -1,    -1,   636,    77,    78,    79,    80,    81,
      82,    83,    -1,    -1,   490,    -1,    -1,    -1,     9,    91,
      -1,    -1,    -1,    -1,   500,    87,    -1,    89,    90,    91,
      92,    93,    94,    95,    96,    97,    98,    99,   100,   101,
     102,   517,   104,   105,   106,   107,    99,   100,   101,   102,
      -1,   104,   105,   106,   107,   404,    -1,   406,    -1,    -1,
      -1,   410,    -1,   412,    77,    78,    79,    80,    81,    82,
      83,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   428,
     429,    -1,   431,   432,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   568,    -1,   570,    86,    87,    -1,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,    -1,   104,   105,   106,   107,    -1,    -1,    -1,
     469,    -1,   471,    -1,    -1,    -1,    -1,    -1,    -1,   605,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   615,
      -1,    -1,     3,     4,     5,     6,    -1,     8,   497,    -1,
     499,    -1,    -1,   629,    -1,    -1,    -1,   633,    -1,    -1,
     636,    -1,    -1,    24,    -1,    26,    -1,    28,    29,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    37,    38,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      51,    52,    53,    54,    55,    56,    -1,    58,    -1,    -1,
     549,    -1,   551,    -1,    -1,    -1,    -1,    68,    -1,   558,
      -1,   560,    73,    74,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    85,    -1,    -1,    88,    -1,   578,
      -1,    -1,    -1,    -1,    -1,    -1,    97,    98,    -1,    -1,
      -1,   590,    -1,   104,   105,    -1,    -1,    -1,    -1,    -1,
     111,    -1,   113,    -1,    -1,   116,   117,    -1,   119,    -1,
      -1,    -1,   611,     0,     1,   614,     3,     4,     5,     6,
       7,     8,    -1,    -1,    11,    12,    13,    14,    15,    16,
      17,    -1,    -1,    -1,    21,    22,    23,    24,    25,    26,
      -1,    28,    29,    30,    31,    -1,    33,    34,    -1,    36,
      37,    38,    -1,    -1,    -1,    42,    -1,    -1,    -1,    46,
      -1,    48,    49,    -1,    51,    52,    53,    54,    55,    56,
      -1,    58,    59,    -1,    -1,    -1,    -1,    64,    -1,    -1,
      67,    68,    69,    70,    -1,    -1,    73,    74,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    85,    -1,
      -1,    88,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      97,    98,    -1,    -1,    -1,    -1,    -1,   104,   105,    -1,
      -1,    -1,    -1,    -1,   111,   112,   113,    -1,    -1,   116,
     117,     1,    -1,     3,     4,     5,     6,    -1,     8,    -1,
      -1,    11,    12,    13,    14,    15,    16,    17,    -1,    -1,
      -1,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    -1,    33,    34,    -1,    36,    37,    38,    39,
      40,    41,    42,    -1,    -1,    -1,    46,    -1,    48,    49,
      -1,    51,    52,    53,    54,    55,    56,    -1,    58,    59,
      -1,    -1,    -1,    -1,    64,    -1,    -1,    67,    68,    69,
      70,    -1,    -1,    73,    74,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    85,    -1,    -1,    88,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    97,    98,    -1,
      -1,    -1,    -1,    -1,   104,   105,    -1,    -1,    -1,    -1,
      -1,   111,   112,   113,    -1,    -1,   116,   117,     1,    -1,
       3,     4,     5,     6,    -1,     8,    -1,    -1,    11,    12,
      13,    14,    15,    16,    17,    -1,    -1,    -1,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    -1,
      33,    34,    -1,    36,    37,    38,    -1,    -1,    -1,    42,
      43,    44,    45,    46,    -1,    48,    49,    -1,    51,    52,
      53,    54,    55,    56,    -1,    58,    59,    -1,    -1,    -1,
      -1,    64,    -1,    -1,    67,    68,    69,    70,    -1,    -1,
      73,    74,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    85,    -1,    -1,    88,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    97,    98,    -1,    -1,    -1,    -1,
      -1,   104,   105,    -1,    -1,    -1,    -1,    -1,   111,   112,
     113,    -1,    -1,   116,   117,     1,    -1,     3,     4,     5,
       6,    -1,     8,    -1,    -1,    11,    12,    13,    14,    15,
      16,    17,    -1,    -1,    -1,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    -1,    33,    34,    -1,
      36,    37,    38,    -1,    -1,    -1,    42,    43,    44,    -1,
      46,    47,    48,    49,    -1,    51,    52,    53,    54,    55,
      56,    -1,    58,    59,    -1,    -1,    -1,    -1,    64,    -1,
      -1,    67,    68,    69,    70,    -1,    -1,    73,    74,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    85,
      -1,    -1,    88,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    97,    98,    -1,    -1,    -1,    -1,    -1,   104,   105,
      -1,    -1,    -1,    -1,    -1,   111,   112,   113,    -1,    -1,
     116,   117,     1,    -1,     3,     4,     5,     6,    -1,     8,
      -1,    -1,    11,    12,    13,    14,    15,    16,    17,    -1,
      -1,    -1,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    31,    -1,    33,    34,    -1,    36,    37,    38,
      39,    40,    41,    42,    -1,    -1,    -1,    46,    -1,    48,
      49,    -1,    51,    52,    53,    54,    55,    56,    -1,    58,
      59,    -1,    -1,    -1,    -1,    64,    -1,    -1,    67,    68,
      69,    70,    -1,    -1,    73,    74,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    85,    -1,    -1,    88,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    97,    98,
      -1,    -1,    -1,    -1,    -1,   104,   105,    -1,    -1,    -1,
      -1,    -1,   111,   112,   113,    -1,    -1,   116,   117,     1,
      -1,     3,     4,     5,     6,    -1,     8,    -1,    -1,    11,
      12,    13,    14,    15,    16,    17,    -1,    -1,    -1,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
      -1,    33,    34,    -1,    36,    37,    38,    -1,    -1,    -1,
      42,    -1,    -1,    45,    46,    47,    48,    49,    -1,    51,
      52,    53,    54,    55,    56,    -1,    58,    59,    -1,    -1,
      -1,    -1,    64,    -1,    -1,    67,    68,    69,    70,    -1,
      -1,    73,    74,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    85,    -1,    -1,    88,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    97,    98,    -1,    -1,    -1,
      -1,    -1,   104,   105,    -1,    -1,    -1,    -1,    -1,   111,
     112,   113,    -1,    -1,   116,   117,     1,    -1,     3,     4,
       5,     6,    -1,     8,    -1,    -1,    11,    12,    13,    14,
      15,    16,    17,    -1,    -1,    -1,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    -1,    33,    34,
      -1,    36,    37,    38,    -1,    -1,    -1,    42,    -1,    -1,
      -1,    46,    -1,    48,    49,    -1,    51,    52,    53,    54,
      55,    56,    -1,    58,    59,    -1,    -1,    -1,    -1,    64,
      65,    -1,    67,    68,    69,    70,    -1,    -1,    73,    74,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      85,    -1,    -1,    88,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    97,    98,    -1,    -1,    -1,    -1,    -1,   104,
     105,    -1,    -1,    -1,    -1,    -1,   111,   112,   113,    -1,
      -1,   116,   117,     1,    -1,     3,     4,     5,     6,    -1,
       8,    -1,    -1,    11,    12,    13,    14,    15,    16,    17,
      -1,    -1,    -1,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    -1,    36,    37,
      38,    -1,    -1,    -1,    42,    -1,    -1,    -1,    46,    -1,
      48,    49,    -1,    51,    52,    53,    54,    55,    56,    -1,
      58,    59,    -1,    -1,    -1,    -1,    64,    -1,    -1,    67,
      68,    69,    70,    -1,    -1,    73,    74,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    85,    -1,    -1,
      88,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    97,
      98,    -1,    -1,    -1,    -1,    -1,   104,   105,    -1,    -1,
      -1,    -1,    -1,   111,   112,   113,    -1,    -1,   116,   117,
       1,    -1,     3,     4,     5,     6,    -1,     8,    -1,    -1,
      11,    12,    13,    14,    15,    16,    17,    -1,    -1,    -1,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      31,    -1,    33,    34,    -1,    36,    37,    38,    -1,    -1,
      -1,    42,    -1,    -1,    -1,    46,    -1,    48,    49,    -1,
      51,    52,    53,    54,    55,    56,    -1,    58,    59,    -1,
      -1,    62,    -1,    64,    -1,    -1,    67,    68,    69,    70,
      -1,    -1,    73,    74,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    85,    -1,    -1,    88,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    97,    98,    -1,    -1,
      -1,    -1,    -1,   104,   105,    -1,    -1,    -1,    -1,    -1,
     111,   112,   113,    -1,    -1,   116,   117,     1,    -1,     3,
       4,     5,     6,    -1,     8,    -1,    -1,    11,    12,    13,
      14,    15,    16,    17,    -1,    -1,    -1,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    -1,    33,
      34,    -1,    36,    37,    38,    39,    -1,    -1,    42,    -1,
      -1,    -1,    46,    -1,    48,    49,    -1,    51,    52,    53,
      54,    55,    56,    -1,    58,    59,    -1,    -1,    -1,    -1,
      64,    -1,    -1,    67,    68,    69,    70,    -1,    -1,    73,
      74,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    85,    -1,    -1,    88,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    97,    98,    -1,    -1,    -1,    -1,    -1,
     104,   105,    -1,    -1,    -1,    -1,    -1,   111,   112,   113,
      -1,    -1,   116,   117,     1,    -1,     3,     4,     5,     6,
      -1,     8,    -1,    -1,    11,    12,    13,    14,    15,    16,
      17,    -1,    -1,    -1,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    31,    -1,    33,    34,    -1,    36,
      37,    38,    -1,    -1,    -1,    42,    -1,    -1,    -1,    46,
      -1,    48,    49,    -1,    51,    52,    53,    54,    55,    56,
      -1,    58,    59,    -1,    -1,    -1,    -1,    64,    -1,    -1,
      67,    68,    69,    70,    -1,    -1,    73,    74,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    85,    -1,
      -1,    88,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      97,    98,    -1,    -1,    -1,    -1,    -1,   104,   105,    -1,
      -1,    -1,    -1,    -1,   111,   112,   113,    -1,    -1,   116,
     117,     3,     4,     5,     6,    -1,     8,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    24,    -1,    26,    -1,    28,    29,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    37,    38,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    51,
      52,    53,    54,    55,    56,    57,    58,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    68,    -1,    -1,    -1,
      -1,    73,    74,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    85,    -1,    -1,    88,     3,     4,     5,
       6,    -1,     8,    -1,    -1,    97,    98,    -1,    -1,    -1,
      -1,    -1,   104,   105,    -1,    -1,    -1,    -1,    24,   111,
      26,   113,    28,    29,   116,   117,    -1,    -1,    -1,    -1,
      -1,    37,    38,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    51,    52,    53,    54,    55,
      56,    57,    58,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    68,    -1,    -1,    -1,    -1,    73,    74,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    85,
      -1,    -1,    88,     3,     4,     5,     6,    -1,     8,    -1,
      -1,    97,    98,    -1,    -1,    -1,    -1,    -1,   104,   105,
      -1,    -1,    -1,    -1,    24,   111,    26,   113,    28,    29,
     116,   117,    -1,    -1,    -1,    -1,    -1,    37,    38,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    51,    52,    53,    54,    55,    56,    57,    58,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    68,    -1,
      -1,    -1,    -1,    73,    74,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    85,    -1,    -1,    88,     3,
       4,     5,     6,    -1,     8,    -1,    -1,    97,    98,    -1,
      -1,    -1,    -1,    -1,   104,   105,    -1,    -1,    -1,    -1,
      24,   111,    26,   113,    28,    29,   116,   117,    -1,    -1,
      -1,    -1,    -1,    37,    38,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    51,    52,    53,
      54,    55,    56,    57,    58,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    68,    -1,    -1,    -1,    -1,    73,
      74,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    85,    -1,    -1,    88,     3,     4,     5,     6,    -1,
       8,    -1,    -1,    97,    98,    -1,    -1,    -1,    -1,    -1,
     104,   105,    -1,    -1,    -1,    -1,    24,   111,    26,   113,
      28,    29,   116,   117,    -1,    -1,    -1,    -1,    -1,    37,
      38,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    51,    52,    53,    54,    55,    56,    -1,
      58,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      68,    -1,    -1,    -1,    -1,    73,    74,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    85,    -1,    -1,
      88,     3,     4,     5,     6,    -1,     8,    -1,    -1,    97,
      98,    -1,    -1,    -1,    -1,    -1,   104,   105,    -1,    -1,
      -1,    -1,    24,   111,    26,   113,    28,    29,   116,   117,
      -1,    -1,    -1,    -1,    -1,    37,    38,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    51,
      52,    53,    54,    55,    56,    -1,    58,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    68,    -1,    -1,    -1,
      -1,    73,    74,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    85,    -1,    -1,    88,    -1,    -1,    -1,
      60,    -1,    -1,    -1,    -1,    97,    98,    -1,    -1,    -1,
      -1,    -1,   104,   105,    -1,    -1,    -1,    -1,    -1,   111,
      -1,   113,    -1,    61,   116,   117,    86,    87,    -1,    89,
      90,    91,    92,    93,    94,    95,    96,    97,    98,    99,
     100,   101,   102,    -1,   104,   105,   106,   107,    86,    87,
      -1,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,   102,    -1,   104,   105,   106,   107,
      86,    87,    -1,    89,    90,    91,    92,    93,    94,    95,
      96,    97,    98,    99,   100,   101,   102,    -1,   104,   105,
     106,   107,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    86,    87,   120,    89,    90,    91,    92,    93,
      94,    95,    96,    97,    98,    99,   100,   101,   102,    -1,
     104,   105,   106,   107,    -1,    -1,    -1,    -1,    -1,    86,
      87,   115,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,    -1,   104,   105,   106,
     107,    -1,    -1,    -1,    -1,    86,    87,   114,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,    -1,   104,   105,   106,   107,    -1,    -1,    -1,
      -1,    86,    87,   114,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,    -1,   104,
     105,   106,   107,    -1,    -1,    -1,    -1,    86,    87,   114,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,    -1,   104,   105,   106,   107,    -1,
      -1,    -1,    -1,    86,    87,   114,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
      -1,   104,   105,   106,   107,    -1,    -1,    86,    87,   112,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,    -1,   104,   105,   106,   107,    -1,
      -1,    86,    87,   112,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,    -1,   104,
     105,   106,   107,    -1,    -1,    86,    87,   112,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,    -1,   104,   105,   106,   107,    -1,    -1,    86,
      87,   112,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,    -1,   104,   105,   106,
     107,    -1,    -1,    86,    87,   112,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
      -1,   104,   105,   106,   107,    86,    87,    -1,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,    -1,   104,   105,   106,   107,    89,    90,    91,
      92,    93,    94,    95,    96,    97,    98,    99,   100,   101,
     102,    -1,   104,   105,   106,   107
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const unsigned char yystos[] =
{
       0,   123,     0,     1,     3,     4,     5,     6,     7,     8,
      11,    12,    13,    14,    15,    16,    17,    21,    22,    23,
      24,    25,    26,    28,    29,    30,    31,    33,    34,    36,
      37,    38,    42,    46,    48,    49,    51,    52,    53,    54,
      55,    56,    58,    59,    64,    67,    68,    69,    70,    73,
      74,    85,    88,    97,    98,   104,   105,   111,   113,   116,
     117,   124,   125,   128,   144,   154,   164,   166,   167,   174,
     175,   180,   200,   102,   109,   110,   113,   116,     6,    24,
      37,   113,   164,   166,   167,   174,   180,     6,   188,     6,
     189,   131,   132,     7,    12,    13,   130,   113,   129,   133,
     134,     6,   166,     6,   166,   113,   167,   112,   167,   189,
     189,   167,   167,   113,   150,   167,   198,   198,     6,   188,
     119,   171,   171,   167,   167,   167,   167,   167,   167,     6,
     167,   199,     6,   113,   165,   174,   175,     4,     6,   119,
     195,   196,   197,   198,     6,     6,   112,     6,   164,   174,
     113,    77,    78,    79,    80,    81,    82,    83,    91,   176,
      91,   110,   113,   176,    86,    87,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
     104,   105,   106,   107,     6,    51,    52,   113,   166,     6,
      51,    52,   166,    91,   106,   107,   113,   176,   167,   113,
       6,   113,   166,    57,   167,   190,   193,   194,   165,   110,
     113,   199,   110,    91,     6,   113,   166,   115,   115,     6,
     164,   166,   181,   185,   181,   181,   178,   181,     6,   166,
     182,   183,   167,    35,   191,   191,   191,   191,   167,   172,
     112,   158,   159,   112,    50,   163,   120,   114,   193,   137,
     114,     6,   187,   168,   169,   113,   114,   115,   167,     4,
     108,     6,     6,   121,   121,   178,   115,   118,   115,   118,
     113,   126,   126,    50,    83,    91,   173,   167,   172,   167,
     167,   167,     6,   113,   166,   190,   167,   167,   167,   167,
     167,   167,   167,   167,   167,   167,   167,   167,   167,   167,
     167,   167,   167,     6,   199,    91,   110,   176,   177,   199,
     110,   176,   177,   167,     6,   199,   190,   167,   167,   176,
     177,   199,   176,   177,   114,   115,     6,   166,   190,   114,
       6,   166,   167,   110,   199,   110,     6,     6,    83,   107,
     186,    91,    83,    91,   186,   115,    75,    76,   140,   170,
     113,   184,   184,   115,   112,    57,   113,   192,   194,   115,
     139,   112,    43,    44,   160,   141,   142,     6,   114,   115,
     127,   140,   115,   119,   197,   197,   190,    91,   110,   167,
     114,     6,   167,   167,   179,   187,     4,     6,   196,   198,
     187,   140,   140,   167,   167,   115,   176,   177,   199,   176,
     177,   114,   113,   120,     6,   113,   166,   167,   167,   114,
       6,   113,   166,   167,   167,   120,   114,   114,   167,   167,
     114,   167,   167,    91,    57,   194,   114,   110,     6,   166,
     114,     6,   166,   167,   199,   107,   167,   167,   167,   185,
       6,     6,   181,   199,   113,   183,   127,   167,   194,   115,
     172,   127,   167,   112,    27,    45,   161,    43,   143,   160,
     112,    23,   128,   138,     6,   114,   114,   114,   167,     6,
     113,   166,   197,   119,   114,     9,   146,    61,   172,   167,
     167,   114,   167,   167,   190,   176,   177,   199,   176,   177,
     110,   176,   177,   199,   176,   177,   167,     6,   113,   166,
     110,   120,   199,   140,   114,   114,   199,    27,    32,   153,
     114,    57,   113,   194,   115,   155,   112,   127,    98,   200,
     201,   112,   115,    27,    47,   162,   112,    23,    65,   124,
     125,   147,   148,   140,   176,   177,   199,   176,   177,   118,
     112,   167,   115,   114,   167,   167,   114,   167,   167,     6,
     113,   166,   167,   167,   114,   167,   167,   199,     6,   113,
     166,   120,   114,   194,   172,    40,    41,   156,   127,   200,
     127,   201,   150,     6,     6,    27,   167,   167,   114,   167,
     167,   136,    60,   152,   172,   176,   177,   199,   176,   177,
     114,   199,   114,   114,   112,   167,    27,    39,   157,    66,
     151,   126,   126,   176,   177,   127,   167,   112,   114,   167,
     167,   114,   167,   167,   114,   127,   112,   164,   112,   140,
     140,   167,   167,    27,    62,   145,   135,   176,   177,   127,
     149,   112,   112,   127,   167,   167,   127,   145
};

#if ! defined (YYSIZE_T) && defined (__SIZE_TYPE__)
# define YYSIZE_T __SIZE_TYPE__
#endif
#if ! defined (YYSIZE_T) && defined (size_t)
# define YYSIZE_T size_t
#endif
#if ! defined (YYSIZE_T)
# if defined (__STDC__) || defined (__cplusplus)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# endif
#endif
#if ! defined (YYSIZE_T)
# define YYSIZE_T unsigned int
#endif

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { 								\
      yyerror ("syntax error: cannot back up");\
      YYERROR;							\
    }								\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

/* YYLLOC_DEFAULT -- Compute the default location (before the actions
   are run).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)		\
   ((Current).first_line   = (Rhs)[1].first_line,	\
    (Current).first_column = (Rhs)[1].first_column,	\
    (Current).last_line    = (Rhs)[N].last_line,	\
    (Current).last_column  = (Rhs)[N].last_column)
#endif

/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (0)

# define YYDSYMPRINT(Args)			\
do {						\
  if (yydebug)					\
    yysymprint Args;				\
} while (0)

# define YYDSYMPRINTF(Title, Token, Value, Location)		\
do {								\
  if (yydebug)							\
    {								\
      YYFPRINTF (stderr, "%s ", Title);				\
      yysymprint (stderr, 					\
                  Token, Value);	\
      YYFPRINTF (stderr, "\n");					\
    }								\
} while (0)

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yy_stack_print (short int *bottom, short int *top)
#else
static void
yy_stack_print (bottom, top)
    short int *bottom;
    short int *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (/* Nothing. */; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yy_reduce_print (int yyrule)
#else
static void
yy_reduce_print (yyrule)
    int yyrule;
#endif
{
  int yyi;
  unsigned int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %u), ",
             yyrule - 1, yylno);
  /* Print the symbols being reduced, and their result.  */
  for (yyi = yyprhs[yyrule]; 0 <= yyrhs[yyi]; yyi++)
    YYFPRINTF (stderr, "%s ", yytname [yyrhs[yyi]]);
  YYFPRINTF (stderr, "-> %s\n", yytname [yyr1[yyrule]]);
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (Rule);		\
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YYDSYMPRINT(Args)
# define YYDSYMPRINTF(Title, Token, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   SIZE_MAX < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#if defined (YYMAXDEPTH) && YYMAXDEPTH == 0
# undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined (__GLIBC__) && defined (_STRING_H)
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
#   if defined (__STDC__) || defined (__cplusplus)
yystrlen (const char *yystr)
#   else
yystrlen (yystr)
     const char *yystr;
#   endif
{
  register const char *yys = yystr;

  while (*yys++ != '\0')
    continue;

  return yys - yystr - 1;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined (__GLIBC__) && defined (_STRING_H) && defined (_GNU_SOURCE)
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
#   if defined (__STDC__) || defined (__cplusplus)
yystpcpy (char *yydest, const char *yysrc)
#   else
yystpcpy (yydest, yysrc)
     char *yydest;
     const char *yysrc;
#   endif
{
  register char *yyd = yydest;
  register const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

#endif /* !YYERROR_VERBOSE */



#if YYDEBUG
/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yysymprint (FILE *yyoutput, int yytype, YYSTYPE *yyvaluep)
#else
static void
yysymprint (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  if (yytype < YYNTOKENS)
    {
      YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
# ifdef YYPRINT
      YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
    }
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  switch (yytype)
    {
      default:
        break;
    }
  YYFPRINTF (yyoutput, ")");
}

#endif /* ! YYDEBUG */
/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yydestruct (int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yytype, yyvaluep)
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  switch (yytype)
    {

      default:
        break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
int yyparse (void *YYPARSE_PARAM);
# else
int yyparse ();
# endif
#else /* ! YYPARSE_PARAM */
#if defined (__STDC__) || defined (__cplusplus)
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
int yyparse (void *YYPARSE_PARAM)
# else
int yyparse (YYPARSE_PARAM)
  void *YYPARSE_PARAM;
# endif
#else /* ! YYPARSE_PARAM */
#if defined (__STDC__) || defined (__cplusplus)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  register int yystate;
  register int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  short int yyssa[YYINITDEPTH];
  short int *yyss = yyssa;
  register short int *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  register YYSTYPE *yyvsp;



#define YYPOPSTACK   (yyvsp--, yyssp--)

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* When reducing, the number of symbols on the RHS of the reduced
     rule.  */
  int yylen;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;


  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed. so pushing a state here evens the stacks.
     */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack. Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	short int *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow ("parser stack overflow",
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyoverflowlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyoverflowlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	short int *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyoverflowlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YYDSYMPRINTF ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */
  YYDPRINTF ((stderr, "Shifting token %s, ", yytname[yytoken]));

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;


  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  yystate = yyn;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 512 "clic.y"
    { ;}
    break;

  case 3:
#line 536 "clic.y"
    {
			if (yyvsp[-1].node)
			{
				if ( yyvsp[-1].node->isExec )
					curFunction->lastExec=1;
				append_Node( curFunction->body, yyvsp[-1].node);
			}
		;}
    break;

  case 4:
#line 545 "clic.y"
    {
			if (curFunction==curFile->main)
				append_Node(curFile->ctext, new_LangNode(yyvsp[0].string));
			else
				append_Node(curFunction->body, new_LangNode(yyvsp[0].string));
		;}
    break;

  case 5:
#line 552 "clic.y"
    {
			append_Node(curFile->ctextStatic, new_LangNode(yyvsp[0].string));
		;}
    break;

  case 6:
#line 556 "clic.y"
    {yyval.i=1; lex_vardef(1);;}
    break;

  case 7:
#line 557 "clic.y"
    {yyval.i=0; lex_vardef(1);;}
    break;

  case 8:
#line 560 "clic.y"
    {yyval.i=1;lex_vardef(1);;}
    break;

  case 9:
#line 561 "clic.y"
    {yyval.i=0;lex_vardef(1);;}
    break;

  case 10:
#line 562 "clic.y"
    {yyval.i=2;lex_vardef(1);;}
    break;

  case 11:
#line 563 "clic.y"
    {yyval.i=3;lex_vardef(1);;}
    break;

  case 12:
#line 566 "clic.y"
    {yyval.varcoll=new_VarColl();;}
    break;

  case 13:
#line 567 "clic.y"
    { yyval.varcoll=yyvsp[-1].varcoll;;}
    break;

  case 14:
#line 570 "clic.y"
    { yyval.node=new_OperListNode(); push_operlist(yyval.node); ;}
    break;

  case 15:
#line 572 "clic.y"
    {
			yyval.node=yyvsp[-2].node;
			if (yyvsp[-1].node)
			{
				if ( yyvsp[-1].node->isExec )
					curFunction->lastExec=1;
				append_Node( yyval.node, yyvsp[-1].node);
			}
		;}
    break;

  case 16:
#line 583 "clic.y"
    { yyval.node=NULL; ;}
    break;

  case 17:
#line 585 "clic.y"
    {
			eof_checks();
			curFunction=new_Function(yyvsp[-2].string,yyvsp[-1].varcoll,yyvsp[-3].i,0,0,0);
			curFunction->typename = yyvsp[0].string;
			lex_vardef(0);
			add_Function(curFile, curFunction);
			curStatics=curFunction->statics;
			fin_Function(curFunction);
			pop_operlist();
			push_operlist(curFunction->body);
			yyval.node=NULL;
		;}
    break;

  case 18:
#line 599 "clic.y"
    {
			eof_checks();
			curFunction=new_Function(yyvsp[-2].string,yyvsp[-1].varcoll,yyvsp[-3].i,0,0,0);
			curFunction->isProc=1;
			curFunction->typename = yyvsp[0].string;
			lex_vardef(0);
			add_Function(curFile, curFunction);
			curStatics=curFunction->statics;
			fin_Function(curFunction);
			pop_operlist();
			push_operlist(curFunction->body);
			yyval.node=NULL;
		;}
    break;

  case 19:
#line 612 "clic.y"
    {
			int i;
			char *s;
			for(i=0;i<yyvsp[0].coll->count;i++)
			{
				VAR(char, vp, yyvsp[0].coll->items[i]);
				if (insert_Coll( &curFile->externFunctions, vp)<0)
					free(vp);
				else
				{
					for(s=vp; *s; ++s)
						*s=toupper(*s);
					insert_Coll( &curFile->undeclExternFunctions, strdup(vp));
				}
			}
			removeAll_Coll(yyvsp[0].coll);
			delete_Coll(yyvsp[0].coll);
			yyval.node=NULL;
			if (curFunction->lastExec)
				yyerror("EXTERN after executable statements");
		;}
    break;

  case 20:
#line 633 "clic.y"
    {
			lex_vardef(1);
			def_node=new_LocalDefNode1;
		;}
    break;

  case 21:
#line 638 "clic.y"
    {
			/*$$=new_LocalDefNode($3, 1);*/
			yyval.node=NULL;
			lex_vardef(0); CM;
			def_node=0;
		;}
    break;

  case 22:
#line 645 "clic.y"
    {
			lex_vardef(1);
			def_node = new_StaticDefNode;
		;}
    break;

  case 23:
#line 650 "clic.y"
    {
			/*$$=new_StaticDefNode($3);*/
			yyval.node=NULL;
			lex_vardef(0);
			def_node=0;
		;}
    break;

  case 24:
#line 657 "clic.y"
    {
			def_node = new_PublicDefNode;
		;}
    break;

  case 25:
#line 661 "clic.y"
    {
			/*$$=new_PublicDefNode($2);*/
			yyval.node=NULL;
			CM;
			def_node=0;
		;}
    break;

  case 26:
#line 668 "clic.y"
    {
			def_node = new_PrivateDefNode;
		;}
    break;

  case 27:
#line 672 "clic.y"
    {
			/*$$=new_PrivateDefNode($2);*/
			yyval.node=NULL;
			CM;
			def_node=0;
		;}
    break;

  case 28:
#line 679 "clic.y"
    {
			def_node = new_PrivateDefNode;
		;}
    break;

  case 29:
#line 683 "clic.y"
    {
			/*$$=new_PrivateDefNode($2);*/
			yyval.node=NULL;
			CM;
			def_node=0;
		;}
    break;

  case 30:
#line 700 "clic.y"
    { yyval.node=new_MemvarDefNode(yyvsp[0].varcoll); ;}
    break;

  case 31:
#line 701 "clic.y"
    { yyval.node=new_FieldDefNode(yyvsp[-1].varcoll, yyvsp[0].string); ;}
    break;

  case 32:
#line 702 "clic.y"
    { yyval.node=new_ParametersDefNode(yyvsp[0].varcoll); CM;;}
    break;

  case 33:
#line 703 "clic.y"
    { yyval.node=new_ReturnNode(NULL,0); CM;;}
    break;

  case 34:
#line 704 "clic.y"
    { yyval.node=new_ReturnNode(yyvsp[0].node,0); CM;;}
    break;

  case 35:
#line 707 "clic.y"
    {
				Coll *cp = yyvsp[0].coll;
				int i;

				yyval.node=NULL;
				for(i=0; i< cp->count; ++i)
					append_Coll(&curFile->externModules, cp->items[i]);

				removeAll_Coll(cp);
				delete_Coll(cp);
			;}
    break;

  case 36:
#line 718 "clic.y"
    {
				char *s = yyvsp[0].string;

				yyval.node=NULL;
				free(curFile->main->name);
				curFile->main->name = s;
				for(; *s; ++s)
					*s = toupper(*s);
			;}
    break;

  case 37:
#line 728 "clic.y"
    { yyval.node=NULL; ;}
    break;

  case 38:
#line 732 "clic.y"
    { CM;yyval.node=new_OperExprNode(new_AssignNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;}
    break;

  case 39:
#line 733 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 40:
#line 734 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 41:
#line 735 "clic.y"
    { CM; yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 42:
#line 736 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 43:
#line 737 "clic.y"
    {CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,NULL,yyvsp[-2].string,0,yyvsp[0].node));;}
    break;

  case 44:
#line 738 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 45:
#line 740 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 46:
#line 741 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,0, yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 47:
#line 742 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-7].node,0,yyvsp[-3].node,yyvsp[0].node)); ;}
    break;

  case 48:
#line 743 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 49:
#line 744 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,0, yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 50:
#line 745 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-7].node,0,yyvsp[-3].node,yyvsp[0].node)); ;}
    break;

  case 51:
#line 747 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 52:
#line 748 "clic.y"
    {CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,NULL,0,yyvsp[-2].node,yyvsp[0].node));;}
    break;

  case 53:
#line 749 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 54:
#line 750 "clic.y"
    { CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 55:
#line 752 "clic.y"
    { CM;yyval.node=new_OperExprNode(new_AssignNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;}
    break;

  case 56:
#line 753 "clic.y"
    { CM;yyval.node=new_OperExprNode(new_AssignNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;}
    break;

  case 57:
#line 754 "clic.y"
    { CM;yyval.node=new_OperExprNode(new_ArrElNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;}
    break;

  case 58:
#line 755 "clic.y"
    { yyval.node=new_OperExprNode(yyvsp[0].node); CM;;}
    break;

  case 59:
#line 756 "clic.y"
    {
				Node *np;
				int i;
				CM;
				np = new_ExprListNode();
				append_Node(np, installName(yyvsp[-5].string));
				for(i=0; i< yyvsp[-3].arglist.coll->count; i++)
				{
					Node *p = (Node*) yyvsp[-3].arglist.coll->items[i];
					append_Node(np, p);
				}
				yyval.node=new_OperExprNode(new_ArrElNode(np, yyvsp[0].node,'='));
			;}
    break;

  case 60:
#line 770 "clic.y"
    { yyval.node=new_OperExprNode(new_AssignNode(new_MacroNode(yyvsp[-3].node,0),yyvsp[0].node,'=')); ;}
    break;

  case 61:
#line 773 "clic.y"
    { CM;
			if (!curFunction->inLoop)
				{ loop_line = cl_line; loop_file = currentFile(); }
			curFunction->inLoop++;
		;}
    break;

  case 62:
#line 779 "clic.y"
    {
			curFunction->inLoop--;
			yyval.node=new_WhileNode(yyvsp[-3].node,yyvsp[-1].node);
			pop_operlist();
		;}
    break;

  case 63:
#line 785 "clic.y"
    { CM; yyval.node = new_OperExprNode(new_CallNode(yyvsp[-1].string, yyvsp[0].arglist.coll, yyvsp[0].arglist.haveRest)); ;}
    break;

  case 64:
#line 787 "clic.y"
    { CM; yyval.node = new_OperExprNode(new_CallNameNode(yyvsp[-1].node, yyvsp[0].arglist.coll)); ;}
    break;

  case 65:
#line 789 "clic.y"
    { CM; yyval.node = new_OperExprNode(new_CallNode(yyvsp[-1].string, yyvsp[0].arglist.coll, yyvsp[0].arglist.haveRest)); ;}
    break;

  case 66:
#line 791 "clic.y"
    { CM; yyval.node = new_OperExprNode(new_CallNameNode(yyvsp[-1].node, yyvsp[0].arglist.coll)); ;}
    break;

  case 67:
#line 793 "clic.y"
    {
			CM;
			if (!curFunction->inLoop)
				yyerror("EXIT statement out of loop");
			yyval.node=new_LoopExitNode(0);
		;}
    break;

  case 68:
#line 800 "clic.y"
    {
			CM;
			if (!curFunction->inLoop)
				yyerror("LOOP statement out of loop");
			yyval.node=new_LoopExitNode(1);
		;}
    break;

  case 69:
#line 807 "clic.y"
    { lex_initial(); ;}
    break;

  case 70:
#line 808 "clic.y"
    {
			curFunction->inLoop--;
			yyval.node=new_ForNode(yyvsp[-9].node,yyvsp[-7].node,yyvsp[-5].node,yyvsp[-4].node,yyvsp[-1].node);
			pop_operlist();
		;}
    break;

  case 71:
#line 814 "clic.y"
    { lex_initial(); ;}
    break;

  case 72:
#line 815 "clic.y"
    {
			curFunction->inLoop--;
			yyval.node=new_ForeachNode(yyvsp[-7].node,yyvsp[-5].node,yyvsp[-1].node,yyvsp[-4].i);
			pop_operlist();
		;}
    break;

  case 73:
#line 821 "clic.y"
    {
			CM;
			curFunction->seqNo = ++curFunction->allSeqNo;
			if (!curFunction->seqLevel)
			{
				seq_line = cl_line;
				seq_file = currentFile();
			}
			curFunction->seqLevel++;
			ARR_REALLOC(int, curFunction->seqStack, curFunction->seqLevel);
			curFunction->seqStack[curFunction->seqLevel-1]=yyvsp[0].i;
		;}
    break;

  case 74:
#line 834 "clic.y"
    {
			pop_operlist();
		;}
    break;

  case 75:
#line 838 "clic.y"
    {
			CM;
			yyval.node=new_SeqNode(yyvsp[-3].node,yyvsp[-1].recover.using,yyvsp[-1].recover.operlist,yyvsp[-1].recover.curseq);
		;}
    break;

  case 76:
#line 844 "clic.y"
    {  CM; yyval.node=new_BreakNode(yyvsp[0].node, 1); ;}
    break;

  case 77:
#line 847 "clic.y"
    {
			Coll *cp=new_Coll(NULL,NULL);
			append_Coll(cp,yyvsp[-5].node);
			append_Coll(cp,yyvsp[-3].node);
			yyval.node=new_OperExprNode(new_IfNode(cp,yyvsp[-1].node));
			CM;
		;}
    break;

  case 78:
#line 856 "clic.y"
    {
			if (yyvsp[-1].node->isExprList && getCount_Node(yyvsp[-1].node)>1 )
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
		;}
    break;

  case 79:
#line 870 "clic.y"
    {
			CM;
			prepend_Coll(yyvsp[-2].coll,yyvsp[-3].node);
			prepend_Coll(yyvsp[-2].coll,yyvsp[-6].node);
			yyval.node=new_IfNode( yyvsp[-2].coll, yyvsp[-1].node);
			if_depth--;
			pop_operlist();
		;}
    break;

  case 80:
#line 880 "clic.y"
    {
			CM;
			yyval.node=new_IfNode( yyvsp[-2].coll, yyvsp[-1].node);
		;}
    break;

  case 81:
#line 886 "clic.y"
    {
			yyval.node=new_SwitchNode(yyvsp[-4].node, yyvsp[-2].coll, yyvsp[-1].node);
		;}
    break;

  case 82:
#line 891 "clic.y"
    { yyval.string=0; ;}
    break;

  case 83:
#line 892 "clic.y"
    { yyval.string=yyvsp[0].string; ;}
    break;

  case 84:
#line 893 "clic.y"
    { yyval.string=yyvsp[0].string; ;}
    break;

  case 86:
#line 898 "clic.y"
    {
			SwitchEl *nl = NEW(SwitchEl);
			nl->labels = yyvsp[-2].coll;
			nl->operlist = yyvsp[0].node;
			insert_Coll(yyvsp[-3].coll, nl);
			yyval.coll = yyvsp[-3].coll;
			pop_operlist();
		;}
    break;

  case 87:
#line 908 "clic.y"
    {
			yyval.coll = new_Coll(0, 0);
		;}
    break;

  case 89:
#line 915 "clic.y"
    {
			yyval.coll = new_Coll(0,0);
			append_Coll(yyval.coll, yyvsp[0].node);
		;}
    break;

  case 90:
#line 920 "clic.y"
    {
			yyval.coll = yyvsp[-2].coll;
			append_Coll(yyval.coll, yyvsp[0].node);
		;}
    break;

  case 91:
#line 927 "clic.y"
    {  CM;
			if (!curFunction->inLoop)
				{ loop_line = cl_line; loop_file = currentFile(); }
			curFunction->inLoop++;
		;}
    break;

  case 94:
#line 938 "clic.y"
    { yyval.i = 0; ;}
    break;

  case 95:
#line 939 "clic.y"
    { yyval.i = 1; ;}
    break;

  case 96:
#line 942 "clic.y"
    {;}
    break;

  case 97:
#line 943 "clic.y"
    {;}
    break;

  case 98:
#line 946 "clic.y"
    {
			yyval.recover.curseq = curFunction->seqNo;
			yyval.recover.operlist = 0;
			yyval.recover.using = 0;
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
		;}
    break;

  case 99:
#line 954 "clic.y"
    {
			yyerror("unclosed BEGIN SEQUENCE");
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
			YYERROR;
		;}
    break;

  case 100:
#line 961 "clic.y"
    {
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
		;}
    break;

  case 101:
#line 966 "clic.y"
    {
			yyval.recover.operlist = yyvsp[0].node;
			yyval.recover.using = yyvsp[-3].node;
			yyval.recover.curseq = yyvsp[-4].i;
			pop_operlist();
		;}
    break;

  case 102:
#line 974 "clic.y"
    {yyval.i = curFunction->seqNo; ;}
    break;

  case 103:
#line 977 "clic.y"
    { yyval.node=NULL; ;}
    break;

  case 104:
#line 978 "clic.y"
    { yyval.node=yyvsp[0].node; ;}
    break;

  case 105:
#line 981 "clic.y"
    { yyval.node=new_NumberConstNode(strdup("1"),0); ;}
    break;

  case 106:
#line 982 "clic.y"
    { yyval.node=yyvsp[0].node; ;}
    break;

  case 111:
#line 993 "clic.y"
    { yyval.coll=new_Coll(NULL,NULL); ;}
    break;

  case 112:
#line 995 "clic.y"
    {
			yyval.coll=yyvsp[-4].coll;
			append_Coll(yyval.coll, yyvsp[-2].node);
			append_Coll(yyval.coll, yyvsp[0].node);
			pop_operlist();
		;}
    break;

  case 113:
#line 1003 "clic.y"
    { yyval.node=NULL; ;}
    break;

  case 114:
#line 1005 "clic.y"
    {
			yyval.node=yyvsp[0].node;
			pop_operlist();
		;}
    break;

  case 117:
#line 1015 "clic.y"
    { yyval.coll=new_Coll(NULL,NULL); ;}
    break;

  case 120:
#line 1021 "clic.y"
    {
			yyval.coll=yyvsp[-4].coll;
			append_Coll(yyval.coll, yyvsp[-2].node);
			append_Coll(yyval.coll, yyvsp[0].node);
			pop_operlist();
		;}
    break;

  case 121:
#line 1029 "clic.y"
    { yyval.node=NULL; ;}
    break;

  case 122:
#line 1031 "clic.y"
    {
			yyval.node=yyvsp[0].node;
			pop_operlist();
		;}
    break;

  case 127:
#line 1045 "clic.y"
    { yyval.string=NULL; ;}
    break;

  case 128:
#line 1046 "clic.y"
    { yyval.string=yyvsp[0].string; ;}
    break;

  case 129:
#line 1049 "clic.y"
    { yyval.node=installName(yyvsp[0].string); ;}
    break;

  case 130:
#line 1050 "clic.y"
    { yyval.node=new_MemvarNode(new_Var(yyvsp[0].string)); ;}
    break;

  case 131:
#line 1053 "clic.y"
    { yyval.node=yyvsp[0].node; ;}
    break;

  case 132:
#line 1056 "clic.y"
    { yyval.node=installName(yyvsp[0].string); ;}
    break;

  case 133:
#line 1057 "clic.y"
    { yyval.node=new_MemvarNode(new_Var(yyvsp[0].string)); ;}
    break;

  case 134:
#line 1058 "clic.y"
    { yyval.node=new2_FieldNode(NULL,NULL,yyvsp[0].string,NULL); ;}
    break;

  case 135:
#line 1061 "clic.y"
    { yyval.node=new_MacroNode(yyvsp[0].node,0); ;}
    break;

  case 136:
#line 1062 "clic.y"
    { yyval.node=new_MacroNode(yyvsp[-1].node,0); ;}
    break;

  case 137:
#line 1063 "clic.y"
    { yyval.node=new_MacroNode(new_OpNode(new_StringConstNode(yyvsp[-2].string),yyvsp[0].node,'+'),0);  ;}
    break;

  case 138:
#line 1064 "clic.y"
    { yyval.node=new_MacroNode(new_OpNode(yyvsp[-2].node,new_StringConstNode(yyvsp[0].string),'+'),0); ;}
    break;

  case 139:
#line 1065 "clic.y"
    { char *s = yyvsp[0].string+strspn(yyvsp[0].string,",.-+");
			yyval.node=new_MacroNode(new_OpNode(yyvsp[-1].node,new_StringConstNode(s),'+'),0); ;}
    break;

  case 140:
#line 1067 "clic.y"
    { yyval.node=new_MacroNode(yyvsp[-1].node,1); ;}
    break;

  case 142:
#line 1071 "clic.y"
    {
				int i, l, bad;
				l = strlen(yyvsp[0].string);
				bad = 0;
				for(i=0; i<l; i++)
				{
					if ( yyvsp[0].string[i] & 0x80 )
					{
						bad = 1;
						break;
					}
				}
				if (l && !bad)
				{
					put_locale_string(yyvsp[0].string);
					yyval.node=new_LocaleStringNode(yyvsp[0].string);
				}
				else
				{
					yyval.node=new_StringConstNode(yyvsp[0].string);
				}
			;}
    break;

  case 143:
#line 1093 "clic.y"
    {
				Node *e1 = new_StringConstNode(yyvsp[-2].string);
				Node *e2 = new_StringConstNode(strdup(yyvsp[-2].string));
				yyval.node = new3_CallNode("_clic_ngettext", e1, e2, yyvsp[0].node);
			;}
    break;

  case 144:
#line 1098 "clic.y"
    {
				Coll *cp = new_Coll(0,0);
				append_Coll(cp, new_StringConstNode(yyvsp[0].string));
				yyval.node=new_CallNode(strdup("CTOD"), cp, 0);
			;}
    break;

  case 147:
#line 1105 "clic.y"
    {
		/*((ExprListNode*)$2)->last=1; ; */
		yyval.node=reduce_ExprListNode(yyvsp[-1].node);
		;}
    break;

  case 148:
#line 1109 "clic.y"
    { yyval.node=new_RefNode(yyvsp[0].node); ;}
    break;

  case 149:
#line 1111 "clic.y"
    { yyval.node=new_CallNode( yyvsp[-3].string, yyvsp[-1].arglist.coll, yyvsp[-1].arglist.haveRest); ;}
    break;

  case 150:
#line 1112 "clic.y"
    { yyval.node=new_CallNameNode(yyvsp[-3].node,yyvsp[-1].arglist.coll); ;}
    break;

  case 151:
#line 1114 "clic.y"
    { yyval.node=new_ArrElNode(yyvsp[0].node,NULL,0); ;}
    break;

  case 152:
#line 1115 "clic.y"
    { yyval.node=new_AssignNode(yyvsp[-2].node,yyvsp[0].node,yyvsp[-1].i); ;}
    break;

  case 153:
#line 1116 "clic.y"
    { yyval.node=new_ArrElNode(yyvsp[-2].node,yyvsp[0].node,yyvsp[-1].i); ;}
    break;

  case 154:
#line 1117 "clic.y"
    { yyval.node=new_AssignNode(yyvsp[-2].node,yyvsp[0].node,yyvsp[-1].i); ;}
    break;

  case 155:
#line 1119 "clic.y"
    { yyval.node=new_MethodNode(yyvsp[-5].node,yyvsp[-3].string,yyvsp[-1].arglist.coll, yyvsp[-1].arglist.haveRest); ;}
    break;

  case 156:
#line 1121 "clic.y"
    {
			Node *arr = yyvsp[-3].node;
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
			yyval.node = new_MethodNode(new_ArrElNode(arr,0,0), name, yyvsp[-1].arglist.coll, yyvsp[-1].arglist.haveRest);
		;}
    break;

  case 157:
#line 1135 "clic.y"
    {
		add_self();
		yyval.node=new_MethodNode(installName(strdup("__SELF__")),yyvsp[-3].string,yyvsp[-1].arglist.coll, yyvsp[-1].arglist.haveRest);
		;}
    break;

  case 158:
#line 1139 "clic.y"
    {yyval.node=new2_FieldNode(NULL,NULL,yyvsp[0].string,NULL);;}
    break;

  case 159:
#line 1140 "clic.y"
    {yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,yyvsp[0].string,NULL); ;}
    break;

  case 160:
#line 1141 "clic.y"
    { yyval.node=new2_FieldNode(NULL,NULL,NULL,yyvsp[0].node); ;}
    break;

  case 161:
#line 1143 "clic.y"
    { yyval.node=yyvsp[-1].node; ;}
    break;

  case 162:
#line 1146 "clic.y"
    { yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,yyvsp[0].string,NULL); ;}
    break;

  case 163:
#line 1147 "clic.y"
    { yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,NULL,yyvsp[0].node); ;}
    break;

  case 164:
#line 1148 "clic.y"
    { yyval.node=new2_FieldNode(yyvsp[-4].string,NULL,NULL,reduce_ExprListNode(yyvsp[-1].node)); ;}
    break;

  case 165:
#line 1149 "clic.y"
    { yyval.node=new2_FieldNode(yyvsp[-4].string,NULL,NULL,reduce_ExprListNode(yyvsp[-1].node)); ;}
    break;

  case 166:
#line 1150 "clic.y"
    { yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,NULL,yyvsp[0].node); ;}
    break;

  case 167:
#line 1152 "clic.y"
    {yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-5].node),NULL,reduce_ExprListNode(yyvsp[-1].node));;}
    break;

  case 168:
#line 1153 "clic.y"
    { yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),NULL,yyvsp[0].node); ;}
    break;

  case 169:
#line 1154 "clic.y"
    { yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].string,NULL); ;}
    break;

  case 170:
#line 1155 "clic.y"
    {yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-5].node),NULL,reduce_ExprListNode(yyvsp[-1].node));;}
    break;

  case 171:
#line 1156 "clic.y"
    { yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),NULL,yyvsp[0].node); ;}
    break;

  case 172:
#line 1157 "clic.y"
    { yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].string,NULL); ;}
    break;

  case 173:
#line 1159 "clic.y"
    {yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,yyvsp[0].string,NULL);;}
    break;

  case 174:
#line 1161 "clic.y"
    {yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,yyvsp[0].string,NULL);;}
    break;

  case 175:
#line 1162 "clic.y"
    {yyval.node=new2_FieldNode(NULL,yyvsp[-4].node,NULL,reduce_ExprListNode(yyvsp[-1].node));;}
    break;

  case 176:
#line 1163 "clic.y"
    {yyval.node=new2_FieldNode(NULL,yyvsp[-4].node,NULL,reduce_ExprListNode(yyvsp[-1].node));;}
    break;

  case 177:
#line 1164 "clic.y"
    {yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,NULL,yyvsp[0].node);;}
    break;

  case 178:
#line 1165 "clic.y"
    {yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,NULL,yyvsp[0].node);;}
    break;

  case 179:
#line 1167 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 180:
#line 1168 "clic.y"
    { CM; yyval.node=(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 181:
#line 1169 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 182:
#line 1170 "clic.y"
    {CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,NULL,yyvsp[-2].string,0,yyvsp[0].node));;}
    break;

  case 183:
#line 1171 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 184:
#line 1173 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 185:
#line 1174 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),0, yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 186:
#line 1175 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-7].node),0,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].node)); ;}
    break;

  case 187:
#line 1176 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 188:
#line 1177 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),0, yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 189:
#line 1178 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-7].node),0,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].node)); ;}
    break;

  case 190:
#line 1180 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;}
    break;

  case 191:
#line 1181 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 192:
#line 1182 "clic.y"
    {CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,NULL,0,yyvsp[-2].node,yyvsp[0].node));;}
    break;

  case 193:
#line 1183 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 194:
#line 1184 "clic.y"
    { CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;}
    break;

  case 195:
#line 1186 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'e');  ;}
    break;

  case 196:
#line 1187 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'E');  ;}
    break;

  case 197:
#line 1188 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'N');  ;}
    break;

  case 198:
#line 1189 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'<');  ;}
    break;

  case 199:
#line 1190 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'>');  ;}
    break;

  case 200:
#line 1191 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'L');  ;}
    break;

  case 201:
#line 1192 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'G');  ;}
    break;

  case 202:
#line 1193 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'+');  ;}
    break;

  case 203:
#line 1194 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'$');  ;}
    break;

  case 204:
#line 1196 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'-');  ;}
    break;

  case 205:
#line 1197 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'*');  ;}
    break;

  case 206:
#line 1198 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'/');  ;}
    break;

  case 207:
#line 1199 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'%');  ;}
    break;

  case 208:
#line 1200 "clic.y"
    { yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'^');  ;}
    break;

  case 209:
#line 1201 "clic.y"
    { yyval.node=new_AndNode(yyvsp[-2].node,yyvsp[0].node);  ;}
    break;

  case 210:
#line 1202 "clic.y"
    { yyval.node=new_OrNode(yyvsp[-2].node,yyvsp[0].node);  ;}
    break;

  case 211:
#line 1204 "clic.y"
    { yyval.node=new_NotNode(yyvsp[0].node);  ;}
    break;

  case 212:
#line 1206 "clic.y"
    { yyval.node=new_IncrNode(yyvsp[0].node,1,0); ;}
    break;

  case 213:
#line 1207 "clic.y"
    { yyval.node=new_IncrNode(yyvsp[-1].node,1,1); ;}
    break;

  case 214:
#line 1208 "clic.y"
    { yyval.node=new_IncrNode(yyvsp[0].node,0,0); ;}
    break;

  case 215:
#line 1209 "clic.y"
    { yyval.node=new_IncrNode(yyvsp[-1].node,0,1); ;}
    break;

  case 216:
#line 1210 "clic.y"
    { yyval.node=new_MinusNode(yyvsp[0].node); ;}
    break;

  case 217:
#line 1211 "clic.y"
    { yyval.node=yyvsp[0].node; ;}
    break;

  case 218:
#line 1213 "clic.y"
    {yyval.node=new_ArrayInitNode(yyvsp[-1].node); ;}
    break;

  case 219:
#line 1214 "clic.y"
    {yyval.node=new_ArrayInitNode(yyvsp[-1].node); ;}
    break;

  case 220:
#line 1215 "clic.y"
    {
			Node *np=yyvsp[-2].node;
			Node *el=yyvsp[-1].node;
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
			curFunction = yyvsp[-3].func;

			yyval.node=np;
		;}
    break;

  case 221:
#line 1236 "clic.y"
    { yyval.node=new_CGetNode(yyvsp[-1].coll); ;}
    break;

  case 222:
#line 1237 "clic.y"
    { yyval.node=new_PcountNode(); ;}
    break;

  case 223:
#line 1238 "clic.y"
    { yyval.node=new_PshiftNode(); ;}
    break;

  case 224:
#line 1239 "clic.y"
    { yyval.node=new_ParnNode(yyvsp[-1].node); ;}
    break;

  case 225:
#line 1240 "clic.y"
    { yyval.node=new_ParnNode(yyvsp[-1].node); ;}
    break;

  case 226:
#line 1242 "clic.y"
    {  curFunction->code_params=yyvsp[0].varcoll; ;}
    break;

  case 227:
#line 1243 "clic.y"
    { yyval.node=new_CodestrNode(yyvsp[-1].node,0,yyvsp[-3].varcoll); curFunction->code_params=0; ;}
    break;

  case 228:
#line 1244 "clic.y"
    {  curFunction->code_params=yyvsp[0].varcoll; ;}
    break;

  case 229:
#line 1245 "clic.y"
    { yyval.node=new_MacroNode(new_CodestrNode(yyvsp[-1].node,1,yyvsp[-3].varcoll),0); curFunction->code_params=0; ;}
    break;

  case 230:
#line 1248 "clic.y"
    {
			if (curFunction->upfunc)
				curFunction = curFunction->upfunc;
		;}
    break;

  case 231:
#line 1253 "clic.y"
    {
			Node *np;
			curFunction = yyvsp[-3].func;
			np = new_LocalDefNode(yyvsp[-1].varcoll, 0, 1);
			prepend_Node(curFunction->body, np);
			yyval.node = new_NilConstNode();
			CM;
		;}
    break;

  case 232:
#line 1263 "clic.y"
    {
			Coll *cp=new_Coll(NULL,NULL);
			append_Coll(cp,yyvsp[-5].node);
			append_Coll(cp,yyvsp[-3].node);
			yyval.node=new_IfNode(cp,yyvsp[-1].node);
		;}
    break;

  case 233:
#line 1272 "clic.y"
    {  yyval.node=new_BreakNode(yyvsp[-1].node,0); ;}
    break;

  case 234:
#line 1276 "clic.y"
    { yyval.varcoll=0; ;}
    break;

  case 235:
#line 1277 "clic.y"
    { yyval.varcoll=yyvsp[-1].varcoll; ;}
    break;

  case 236:
#line 1280 "clic.y"
    { yyval.node=new_NilConstNode(); ;}
    break;

  case 237:
#line 1281 "clic.y"
    { yyval.node=yyvsp[0].node; ;}
    break;

  case 246:
#line 1298 "clic.y"
    { yyval.i='='; ;}
    break;

  case 247:
#line 1299 "clic.y"
    { yyval.i='+'; ;}
    break;

  case 248:
#line 1300 "clic.y"
    { yyval.i='-'; ;}
    break;

  case 249:
#line 1301 "clic.y"
    { yyval.i='*'; ;}
    break;

  case 250:
#line 1302 "clic.y"
    { yyval.i='/'; ;}
    break;

  case 251:
#line 1303 "clic.y"
    { yyval.i='%'; ;}
    break;

  case 252:
#line 1304 "clic.y"
    { yyval.i='^'; ;}
    break;

  case 253:
#line 1307 "clic.y"
    { yyval.i='='; ;}
    break;

  case 254:
#line 1311 "clic.y"
    { yyval.func=curFunction; ;}
    break;

  case 255:
#line 1314 "clic.y"
    { yyval.node=new_CodeNode(yyvsp[-1].varcoll); ;}
    break;

  case 256:
#line 1317 "clic.y"
    { yyval.node=yyvsp[-1].node; prepend_Node(yyvsp[-1].node,yyvsp[-3].node); ;}
    break;

  case 257:
#line 1318 "clic.y"
    { yyval.node=yyvsp[-3].node; join_Node(yyvsp[-3].node,yyvsp[-1].node); ;}
    break;

  case 258:
#line 1319 "clic.y"
    {
		yyval.node=new_ExprListNode();
		append_Node(yyval.node, yyvsp[-2].node);
		upstr(yyvsp[0].string);
		append_Node(yyval.node, new_HashConstNode(yyvsp[0].string));
		;}
    break;

  case 259:
#line 1325 "clic.y"
    {
		yyval.node=new_ExprListNode();
		add_self();
		append_Node(yyval.node, installName(strdup("__SELF__")));
		upstr(yyvsp[0].string);
		append_Node(yyval.node, new_HashConstNode(yyvsp[0].string));
		;}
    break;

  case 260:
#line 1332 "clic.y"
    {
		yyval.node=yyvsp[-2].node;
		upstr(yyvsp[0].string);
		append_Node(yyval.node,new_HashConstNode(yyvsp[0].string));
	;}
    break;

  case 261:
#line 1339 "clic.y"
    {
			yyval.varcoll=new_VarColl();
			yyvsp[-1].var->type = yyvsp[0].string;
			add_VarColl(yyval.varcoll, yyvsp[-1].var);
			if (def_node)
				append_Node( curr_operlist, def_node(yyval.varcoll));

		;}
    break;

  case 262:
#line 1348 "clic.y"
    {
			if (def_node)
				yyval.varcoll=new_VarColl();
			else
				yyval.varcoll=yyvsp[-3].varcoll;
			yyvsp[-1].var->type = yyvsp[0].string;
			add_VarColl(yyval.varcoll, yyvsp[-1].var);
			if (def_node)
				append_Node( curr_operlist, def_node(yyval.varcoll));
		;}
    break;

  case 263:
#line 1360 "clic.y"
    {
			yyval.varcoll=new_VarColl();
			add_VarColl(yyval.varcoll, yyvsp[0].var);
		;}
    break;

  case 264:
#line 1365 "clic.y"
    {
			yyval.varcoll=yyvsp[-2].varcoll;
			add_VarColl(yyval.varcoll, yyvsp[0].var);
		;}
    break;

  case 265:
#line 1371 "clic.y"
    { yyval.var=newArrInit_Var(yyvsp[-1].string,yyvsp[0].node); ;}
    break;

  case 266:
#line 1372 "clic.y"
    { yyval.var=mnewArrInit_Var(yyvsp[-1].node,yyvsp[-1].node); ;}
    break;

  case 267:
#line 1375 "clic.y"
    { yyval.node=yyvsp[-1].node; ;}
    break;

  case 268:
#line 1376 "clic.y"
    { yyval.node=yyvsp[-3].node; join_Node(yyvsp[-3].node,yyvsp[-1].node); ;}
    break;

  case 269:
#line 1379 "clic.y"
    { yyval.var=new_Var(yyvsp[0].string); ;}
    break;

  case 270:
#line 1380 "clic.y"
    { yyval.var=newArrInit_Var(yyvsp[-1].string,yyvsp[0].node); ;}
    break;

  case 271:
#line 1381 "clic.y"
    { yyval.var=newInit_Var(yyvsp[-2].string,yyvsp[0].node); ;}
    break;

  case 272:
#line 1382 "clic.y"
    { yyerror("only inline assign := allowed in initialisation"); yyval.var=new_Var(strdup("")); ;}
    break;

  case 273:
#line 1384 "clic.y"
    { yyval.var=mnew_Var(yyvsp[0].node); ;}
    break;

  case 274:
#line 1385 "clic.y"
    { yyval.var=mnewArrInit_Var(yyvsp[-1].node,yyvsp[-1].node); ;}
    break;

  case 275:
#line 1386 "clic.y"
    { yyval.var=mnewInit_Var(yyvsp[-2].node,yyvsp[0].node);  ;}
    break;

  case 276:
#line 1387 "clic.y"
    { yyerror("only inline assign := allowed in initialisation"); yyval.var=new_Var(strdup("")); ;}
    break;

  case 277:
#line 1390 "clic.y"
    { yyval.node=yyvsp[-1].node; ;}
    break;

  case 278:
#line 1391 "clic.y"
    { yyval.node=yyvsp[-3].node; join_Node(yyvsp[-3].node,yyvsp[-1].node); ;}
    break;

  case 279:
#line 1394 "clic.y"
    { yyval.varcoll=new_VarColl(); ;}
    break;

  case 280:
#line 1395 "clic.y"
    {
		Var *vp=new_Var(yyvsp[-1].string);
		vp->type = yyvsp[0].string;
		yyval.varcoll=new_VarColl();
		vp->no=0;
		insert_Coll( &yyval.varcoll->coll, vp);
		insert_Coll( &yyval.varcoll->unsorted, vp);
		;}
    break;

  case 281:
#line 1403 "clic.y"
    {
		Var *vp=new_Var(yyvsp[-1].string);
		vp->type = yyvsp[0].string;
		yyval.varcoll=yyvsp[-3].varcoll;
		vp->no = yyval.varcoll->unsorted.count;
		insert_Coll( &yyval.varcoll->coll, vp);
		insert_Coll( &yyval.varcoll->unsorted, vp);
		;}
    break;

  case 282:
#line 1414 "clic.y"
    {yyval.coll=new_Coll(free,strcmp);;}
    break;

  case 283:
#line 1415 "clic.y"
    {
			yyval.coll=new_Coll(free,strcmp);
			insert_Coll(yyval.coll, yyvsp[0].string);
		;}
    break;

  case 284:
#line 1420 "clic.y"
    {
			int no;
			yyval.coll=yyvsp[-2].coll;
			if ( search_Coll( yyval.coll, yyvsp[0].string, &no) )
			{
				yyerror("name '%s' duplication", yyvsp[0].string);
				free(yyvsp[0].string);
			}
			else
				insert_Coll( yyval.coll, yyvsp[0].string );
		;}
    break;

  case 285:
#line 1433 "clic.y"
    {
			yyval.varcoll=new_VarColl();
			add_VarColl(yyval.varcoll, new_Var(yyvsp[0].string));
		;}
    break;

  case 286:
#line 1438 "clic.y"
    {
			yyval.varcoll=yyvsp[-2].varcoll;
			add_VarColl(yyval.varcoll, new_Var(yyvsp[0].string));
		;}
    break;

  case 287:
#line 1444 "clic.y"
    { yyval.arglist.coll=yyvsp[0].coll; yyval.arglist.haveRest=0; ;}
    break;

  case 288:
#line 1445 "clic.y"
    { yyval.arglist.coll=yyvsp[-2].coll; yyval.arglist.haveRest=1; ;}
    break;

  case 289:
#line 1446 "clic.y"
    { yyval.arglist.coll=new_Coll(NULL,NULL); yyval.arglist.haveRest=1;  ;}
    break;

  case 290:
#line 1449 "clic.y"
    { yyval.arglist.coll=new_Coll(NULL,NULL); yyval.arglist.haveRest=0; ;}
    break;

  case 291:
#line 1450 "clic.y"
    { yyval.arglist.coll=yyvsp[0].coll; yyval.arglist.haveRest=0; ;}
    break;

  case 292:
#line 1451 "clic.y"
    { yyval.arglist.coll=yyvsp[-2].coll; yyval.arglist.haveRest=1; ;}
    break;

  case 293:
#line 1452 "clic.y"
    { yyval.arglist.coll=new_Coll(NULL,NULL); yyval.arglist.haveRest=1;  ;}
    break;

  case 294:
#line 1473 "clic.y"
    {
			yyval.coll=new_Coll(NULL,NULL);
			if (yyvsp[0].node) {
				Coll *cp;
				Node *np;

				insert_Coll(yyval.coll,yyvsp[0].node);
				cp = yyval.coll;
				np = (Node*) cp->items[0];
				if(!(np->isRef||np->isConst||(!np->isLval && !np->isField)))
					cp->items[0] = new_RefNode(np);
			}
		;}
    break;

  case 295:
#line 1486 "clic.y"
    {
			yyval.coll=new_Coll(NULL,NULL);
			if (yyvsp[-1].node)
				insert_Coll(yyval.coll,yyvsp[-1].node);
	;}
    break;

  case 296:
#line 1491 "clic.y"
    {
			yyval.coll=yyvsp[-2].coll;
			if (!yyval.coll->count)
				insert_Coll(yyval.coll,new_ArgNode(new_NilConstNode(),0));
			if (yyvsp[0].node) {
				Coll *cp;
				Node *np;
				insert_Coll(yyval.coll,yyvsp[0].node);
				cp = yyval.coll;
				np = (Node*) cp->items[cp->count-1];
				if(!(np->isRef||np->isConst||(!np->isLval && !np->isField)))
					cp->items[cp->count-1] = new_RefNode(np);
			}
			else
				insert_Coll(yyval.coll,new_ArgNode(new_NilConstNode(),0));
		;}
    break;

  case 297:
#line 1507 "clic.y"
    {
			yyval.coll=yyvsp[-4].coll;
			if (!yyval.coll->count)
				insert_Coll(yyval.coll,new_ArgNode(new_NilConstNode(),0));
			if (yyvsp[-1].node)
				insert_Coll(yyval.coll,yyvsp[-1].node);
			else
				insert_Coll(yyval.coll,new_ArgNode(new_NilConstNode(),0));
		;}
    break;

  case 298:
#line 1518 "clic.y"
    {
			yyval.coll=new_Coll(NULL,NULL);
			if (yyvsp[0].node)
				insert_Coll(yyval.coll,yyvsp[0].node);
		;}
    break;

  case 299:
#line 1523 "clic.y"
    {
			yyval.coll=yyvsp[-2].coll;
			if (!yyval.coll->count)
				insert_Coll(yyval.coll,new_ArgNode(new_NilConstNode(),0));
			if (yyvsp[0].node)
				insert_Coll(yyval.coll,yyvsp[0].node);
			else
				insert_Coll(yyval.coll,new_ArgNode(new_NilConstNode(),0));
		;}
    break;

  case 300:
#line 1534 "clic.y"
    { yyval.node=NULL; ;}
    break;

  case 301:
#line 1535 "clic.y"
    { yyval.node=yyvsp[0].node; /*$$=new_ArgNode($1,0);*/ ;}
    break;

  case 302:
#line 1540 "clic.y"
    {;}
    break;

  case 303:
#line 1541 "clic.y"
    {;}
    break;

  case 304:
#line 1544 "clic.y"
    {;}
    break;

  case 305:
#line 1545 "clic.y"
    {;}
    break;

  case 306:
#line 1549 "clic.y"
    {
					yyval.node=new_ExprListNode();
					yyval.node->isConst=1;
					if (yyvsp[0].node)
					{
						append_Node(yyval.node, yyvsp[0].node);
						if (!yyvsp[0].node->isConst)
							yyval.node->isConst=0;
						else
							yyval.node->isConst=1;
					}
				;}
    break;

  case 307:
#line 1561 "clic.y"
    {
					yyval.node=yyvsp[-2].node;
					if (getCount_Node(yyval.node) == 0)
						append_Node(yyval.node,new_NilConstNode());
					if (yyvsp[0].node)
					{
						append_Node(yyval.node, yyvsp[0].node);
						if (!yyvsp[0].node->isConst)
							yyval.node->isConst=0;
					}
					else
						append_Node(yyval.node,new_NilConstNode());
				;}
    break;

  case 308:
#line 1576 "clic.y"
    { yyval.node=NULL; ;}
    break;

  case 310:
#line 1580 "clic.y"
    { yyval.node=new_ExprListNode(); append_Node(yyval.node, yyvsp[0].node); ;}
    break;

  case 311:
#line 1581 "clic.y"
    { yyval.node=yyvsp[-2].node; append_Node(yyval.node, yyvsp[0].node); ;}
    break;

  case 312:
#line 1584 "clic.y"
    { yyval.node=new_StringConstNode(yyvsp[0].string); ;}
    break;

  case 313:
#line 1585 "clic.y"
    { yyval.node=new_LogicConstNode(1); ;}
    break;

  case 314:
#line 1586 "clic.y"
    { yyval.node=new_LogicConstNode(0); ;}
    break;

  case 315:
#line 1587 "clic.y"
    { yyval.node=new_NilConstNode(); ;}
    break;

  case 316:
#line 1588 "clic.y"
    { yyval.node=new_NumberConstNode(yyvsp[0].string,0); ;}
    break;

  case 318:
#line 1592 "clic.y"
    { yyval.node=yyvsp[0].node; yyval.node->isMinus = 1; ;}
    break;


    }

/* Line 1010 of yacc.c.  */
#line 4669 "clic.tab.c"

  yyvsp -= yylen;
  yyssp -= yylen;


  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (YYPACT_NINF < yyn && yyn < YYLAST)
	{
	  YYSIZE_T yysize = 0;
	  int yytype = YYTRANSLATE (yychar);
	  const char* yyprefix;
	  char *yymsg;
	  int yyx;

	  /* Start YYX at -YYN if negative to avoid negative indexes in
	     YYCHECK.  */
	  int yyxbegin = yyn < 0 ? -yyn : 0;

	  /* Stay within bounds of both yycheck and yytname.  */
	  int yychecklim = YYLAST - yyn;
	  int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
	  int yycount = 0;

	  yyprefix = ", expecting ";
	  for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	      {
		yysize += yystrlen (yyprefix) + yystrlen (yytname [yyx]);
		yycount += 1;
		if (yycount == 5)
		  {
		    yysize = 0;
		    break;
		  }
	      }
	  yysize += (sizeof ("syntax error, unexpected ")
		     + yystrlen (yytname[yytype]));
	  yymsg = (char *) YYSTACK_ALLOC (yysize);
	  if (yymsg != 0)
	    {
	      char *yyp = yystpcpy (yymsg, "syntax error, unexpected ");
	      yyp = yystpcpy (yyp, yytname[yytype]);

	      if (yycount < 5)
		{
		  yyprefix = ", expecting ";
		  for (yyx = yyxbegin; yyx < yyxend; ++yyx)
		    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
		      {
			yyp = yystpcpy (yyp, yyprefix);
			yyp = yystpcpy (yyp, yytname[yyx]);
			yyprefix = " or ";
		      }
		}
	      yyerror (yymsg);
	      YYSTACK_FREE (yymsg);
	    }
	  else
	    yyerror ("syntax error; also virtual memory exhausted");
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror ("syntax error");
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* If at end of input, pop the error token,
	     then the rest of the stack, then return failure.  */
	  if (yychar == YYEOF)
	     for (;;)
	       {
		 YYPOPSTACK;
		 if (yyssp == yyss)
		   YYABORT;
		 YYDSYMPRINTF ("Error: popping", yystos[*yyssp], yyvsp, yylsp);
		 yydestruct (yystos[*yyssp], yyvsp);
	       }
        }
      else
	{
	  YYDSYMPRINTF ("Error: discarding", yytoken, &yylval, &yylloc);
	  yydestruct (yytoken, &yylval);
	  yychar = YYEMPTY;

	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

#ifdef __GNUC__
  /* Pacify GCC when the user code never invokes YYERROR and the label
     yyerrorlab therefore never appears in user code.  */
  if (0)
     goto yyerrorlab;
#endif

  yyvsp -= yylen;
  yyssp -= yylen;
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;

      YYDSYMPRINTF ("Error: popping", yystos[*yyssp], yyvsp, yylsp);
      yydestruct (yystos[yystate], yyvsp);
      YYPOPSTACK;
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  YYDPRINTF ((stderr, "Shifting error token, "));

  *++yyvsp = yylval;


  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*----------------------------------------------.
| yyoverflowlab -- parser overflow comes here.  |
`----------------------------------------------*/
yyoverflowlab:
  yyerror ("parser stack overflow");
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  return yyresult;
}


#line 1595 "clic.y"


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


