/* A Bison parser, made from clic.y
   by GNU bison 1.35.  */

#define YYBISON 1  /* Identify Bison output.  */

# define	STRING	257
# define	NUMBER	258
# define	ISTRING	259
# define	NAME	260
# define	CTEXT	261
# define	DATE	262
# define	KEYS	263
# define	PREPROC	264
# define	RETURN	265
# define	FUNCTION	266
# define	PROCEDURE	267
# define	IPROCEDURE	268
# define	EPROCEDURE	269
# define	EXTERN	270
# define	PARAMETERS	271
# define	SFUNCTION	272
# define	SPROCEDURE	273
# define	TEXT	274
# define	PUBLIC	275
# define	PRIVATE	276
# define	STATIC	277
# define	LOCAL	278
# define	DIMENSION	279
# define	NIL	280
# define	END	281
# define	TRUE	282
# define	FALSE	283
# define	WHILE	284
# define	DO	285
# define	ENDDO	286
# define	EXIT	287
# define	LOOP	288
# define	WITH	289
# define	CALL	290
# define	IF	291
# define	IIF	292
# define	ENDIF	293
# define	ELSE	294
# define	ELSEIF	295
# define	DOCASE	296
# define	CASE	297
# define	OTHERWISE	298
# define	ENDCASE	299
# define	SWITCH	300
# define	ENDSWITCH	301
# define	FIELD	302
# define	MEMVAR	303
# define	IN	304
# define	MEMVARPTR	305
# define	FIELDPTR	306
# define	PCOUNT	307
# define	PARBEG	308
# define	PARAMBEG	309
# define	PSHIFT	310
# define	PALL	311
# define	FOR	312
# define	STEP	313
# define	TO	314
# define	NEXT	315
# define	FOREACH	316
# define	BEGSEQ	317
# define	RECOVER	318
# define	USING	319
# define	BREAK	320
# define	EBREAK	321
# define	ANNOUNCE	322
# define	REQUEST	323
# define	IFNL	324
# define	IFEXPR	325
# define	CODESTR	326
# define	CODEBLOCK	327
# define	AS	328
# define	REF	329
# define	ASSIGN	330
# define	ADDA	331
# define	SUBA	332
# define	DIVA	333
# define	MODA	334
# define	MULA	335
# define	POWA	336
# define	POSTINCR	337
# define	OR	338
# define	AND	339
# define	NOT	340
# define	GE	341
# define	LE	342
# define	EQ	343
# define	NE	344
# define	POW	345
# define	MINUS	346
# define	INCR	347
# define	DECR	348
# define	RPTR	349
# define	REPTR	350
# define	DSEMICOLON	351

#line 7 "clic.y"

/*
 * $Log: clic.y,v $
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


#line 374 "clic.y"
#ifndef YYSTYPE
typedef union
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
} yystype;
# define YYSTYPE yystype
# define YYSTYPE_IS_TRIVIAL 1
#endif
#ifndef YYDEBUG
# define YYDEBUG 0
#endif



#define	YYFINAL		617
#define	YYFLAG		-32768
#define	YYNTBASE	121

/* YYTRANSLATE(YYLEX) -- Bison token number corresponding to YYLEX. */
#define YYTRANSLATE(x) ((unsigned)(x) <= 351 ? yytranslate[x] : 199)

/* YYTRANSLATE[YYLEX] -- Bison token number corresponding to YYLEX. */
static const char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     111,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,   120,    95,   100,   115,     2,
     112,   113,    98,    96,   114,    97,   107,    99,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,   105,     2,
      90,    94,    88,     2,    84,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,   106,     2,   119,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   116,   118,   117,     2,     2,     2,     2,
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
       2,     2,     2,     2,     2,     2,     1,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
      66,    67,    68,    69,    70,    71,    72,    73,    74,    75,
      76,    77,    78,    79,    80,    81,    82,    83,    85,    86,
      87,    89,    91,    92,    93,   101,   102,   103,   104,   108,
     109,   110
};

#if YYDEBUG
static const short yyprhs[] =
{
       0,     0,     1,     5,     8,    12,    14,    17,    19,    22,
      24,    26,    27,    31,    32,    36,    37,    42,    47,    50,
      51,    55,    56,    60,    61,    65,    66,    70,    71,    75,
      78,    82,    85,    87,    90,    93,    96,    98,   100,   104,
     108,   112,   119,   125,   131,   138,   145,   150,   156,   164,
     172,   182,   191,   200,   211,   218,   224,   229,   235,   242,
     243,   250,   254,   258,   262,   266,   268,   270,   271,   283,
     284,   294,   295,   296,   304,   307,   316,   317,   326,   332,
     339,   340,   343,   346,   348,   353,   354,   357,   360,   364,
     366,   368,   370,   371,   373,   379,   385,   386,   388,   389,
     396,   397,   398,   401,   402,   405,   407,   409,   411,   413,
     414,   420,   421,   425,   427,   429,   430,   433,   435,   441,
     442,   446,   448,   450,   452,   454,   455,   458,   460,   463,
     466,   468,   471,   474,   477,   481,   485,   490,   494,   499,
     501,   503,   505,   507,   509,   513,   516,   521,   526,   528,
     532,   536,   540,   547,   552,   558,   561,   565,   568,   574,
     579,   584,   590,   597,   601,   609,   615,   621,   630,   637,
     644,   648,   653,   659,   666,   670,   675,   681,   688,   695,
     700,   706,   714,   722,   732,   741,   750,   761,   768,   774,
     779,   785,   792,   796,   800,   804,   808,   812,   816,   820,
     824,   828,   832,   836,   840,   844,   848,   852,   856,   859,
     862,   865,   868,   871,   874,   877,   881,   885,   892,   894,
     896,   900,   904,   905,   911,   912,   918,   919,   926,   935,
     939,   940,   944,   945,   947,   949,   951,   953,   956,   959,
     961,   964,   967,   969,   971,   973,   975,   977,   979,   981,
     983,   984,   987,   992,   997,  1001,  1004,  1008,  1011,  1016,
    1018,  1022,  1025,  1028,  1032,  1037,  1039,  1042,  1046,  1050,
    1052,  1055,  1059,  1063,  1067,  1072,  1073,  1076,  1081,  1082,
    1084,  1088,  1090,  1094,  1096,  1100,  1102,  1103,  1106,  1108,
    1112,  1113,  1115,  1117,  1121,  1125,  1129,  1131,  1135,  1136,
    1138,  1140,  1144,  1146,  1148,  1150,  1152,  1154,  1156
};
static const short yyrhs[] =
{
      -1,   121,   126,   111,     0,   121,     7,     0,   121,    23,
       7,     0,    12,     0,    23,    12,     0,    13,     0,    23,
      13,     0,    14,     0,    15,     0,     0,   112,   185,   113,
       0,     0,   125,   126,   111,     0,     0,   122,     6,   124,
     138,     0,   123,     6,   124,   138,     0,    16,   186,     0,
       0,    24,   127,   179,     0,     0,    23,   128,   179,     0,
       0,    21,   129,   179,     0,     0,    22,   130,   179,     0,
       0,    25,   131,   180,     0,    49,   187,     0,    48,   187,
     161,     0,    17,   187,     0,    11,     0,    11,   165,     0,
      69,   186,     0,    68,     6,     0,     1,     0,   165,     0,
     162,    94,   165,     0,   164,    94,   165,     0,   178,    94,
     165,     0,     6,   112,   188,   113,    94,   165,     0,   112,
     196,   113,    94,   165,     0,     6,   108,     6,   175,   165,
       0,   172,     6,   108,     6,   175,   165,     0,   172,     6,
     108,   164,   175,   165,     0,   172,     6,   175,   165,     0,
     164,   108,     6,   175,   165,     0,   112,   196,   113,   108,
       6,   175,   165,     0,   112,   196,   113,   108,   164,   175,
     165,     0,   112,   196,   113,   108,   112,   196,   113,   175,
     165,     0,   172,   112,   196,   113,   108,     6,   175,   165,
       0,   172,   112,   196,   113,   108,   164,   175,   165,     0,
     172,   112,   196,   113,   108,   112,   196,   113,   175,   165,
       0,   172,   164,   108,     6,   175,   165,     0,     6,   108,
     164,   175,   165,     0,   172,   164,   175,   165,     0,   164,
     108,   164,   175,   165,     0,   172,   164,   108,   164,   175,
     165,     0,     0,    30,   132,   165,   111,   125,   151,     0,
      31,     6,   189,     0,    31,   164,   189,     0,    36,     6,
     189,     0,    36,   164,   189,     0,    33,     0,    34,     0,
       0,   142,   162,   171,   165,    60,   165,   150,   111,   133,
     125,   143,     0,     0,   142,   162,    50,   165,   144,   111,
     134,   125,   143,     0,     0,     0,    63,   148,   135,   125,
     136,   146,    27,     0,    66,   195,     0,    37,   112,   170,
     114,   170,   114,   170,   113,     0,     0,    37,   165,   111,
     137,   125,   153,   154,   155,     0,    42,   111,   157,   158,
     159,     0,    46,   165,   111,   139,   158,   160,     0,     0,
      74,     6,     0,    75,     6,     0,   140,     0,   139,   141,
     111,   125,     0,     0,   140,   111,     0,    43,   198,     0,
     141,   114,   198,     0,    58,     0,    61,     0,    27,     0,
       0,     9,     0,   122,     6,   124,   138,   111,     0,   123,
       6,   124,   138,   111,     0,     0,   145,     0,     0,    64,
     148,   149,   111,   147,   125,     0,     0,     0,    65,   162,
       0,     0,    59,   165,     0,    27,     0,    32,     0,    38,
       0,    37,     0,     0,   153,    41,   165,   111,   125,     0,
       0,    40,   111,   125,     0,    27,     0,    39,     0,     0,
     156,   111,     0,   156,     0,   157,    43,   165,   111,   125,
       0,     0,    44,   111,   125,     0,    27,     0,    45,     0,
      27,     0,    47,     0,     0,    50,     6,     0,     6,     0,
     173,     6,     0,   173,   164,     0,     6,     0,   173,     6,
       0,   172,     6,     0,   115,   163,     0,   115,   163,   107,
       0,     6,   115,   163,     0,   115,   163,   107,     6,     0,
     115,   163,     4,     0,   115,   112,   165,   113,     0,   197,
       0,     5,     0,     8,     0,   162,     0,   164,     0,   112,
     196,   113,     0,    84,   165,     0,     6,   112,   188,   113,
       0,   164,   112,   188,   113,     0,   178,     0,   162,   174,
     165,     0,   178,   174,   165,     0,   164,   174,   165,     0,
     165,   105,     6,   112,   188,   113,     0,   178,   112,   188,
     113,     0,   110,     6,   112,   188,   113,     0,   172,     6,
       0,     6,   108,     6,     0,   172,   164,     0,     6,   109,
     112,   165,   113,     0,   172,     6,   108,     6,     0,   172,
       6,   108,   164,     0,     6,   108,   112,   196,   113,     0,
     172,     6,   108,   112,   196,   113,     0,     6,   108,   164,
       0,   112,   196,   113,   108,   112,   196,   113,     0,   112,
     196,   113,   108,   164,     0,   112,   196,   113,   108,     6,
       0,   172,   112,   196,   113,   108,   112,   196,   113,     0,
     172,   112,   196,   113,   108,   164,     0,   172,   112,   196,
     113,   108,     6,     0,   164,   108,     6,     0,   172,   164,
     108,     6,     0,   164,   108,   112,   196,   113,     0,   172,
     164,   108,   112,   196,   113,     0,   164,   108,   164,     0,
     172,   164,   108,   164,     0,     6,   108,     6,   174,   165,
       0,   172,     6,   108,     6,   174,   165,     0,   172,     6,
     108,   164,   174,   165,     0,   172,     6,   174,   165,     0,
     164,   108,     6,   174,   165,     0,   112,   196,   113,   108,
       6,   174,   165,     0,   112,   196,   113,   108,   164,   174,
     165,     0,   112,   196,   113,   108,   112,   196,   113,   174,
     165,     0,   172,   112,   196,   113,   108,     6,   174,   165,
       0,   172,   112,   196,   113,   108,   164,   174,   165,     0,
     172,   112,   196,   113,   108,   112,   196,   113,   174,   165,
       0,   172,   164,   108,     6,   174,   165,     0,     6,   108,
     164,   174,   165,     0,   172,   164,   174,   165,     0,   164,
     108,   164,   174,   165,     0,   172,   164,   108,   164,   174,
     165,     0,   165,    94,   165,     0,   165,    92,   165,     0,
     165,    93,   165,     0,   165,    90,   165,     0,   165,    88,
     165,     0,   165,    91,   165,     0,   165,    89,   165,     0,
     165,    96,   165,     0,   165,    95,   165,     0,   165,    97,
     165,     0,   165,    98,   165,     0,   165,    99,   165,     0,
     165,   100,   165,     0,   165,   101,   165,     0,   165,    86,
     165,     0,   165,    85,   165,     0,    87,   165,     0,   103,
     165,     0,   165,   103,     0,   104,   165,     0,   165,   104,
       0,    97,   165,     0,    96,   165,     0,   116,   194,   117,
       0,   116,   192,   117,     0,   116,   118,   176,   177,   194,
     117,     0,    53,     0,    56,     0,    54,   165,   119,     0,
      55,   165,   113,     0,     0,    72,   169,   166,   194,   113,
       0,     0,    73,   169,   167,   194,   113,     0,     0,    24,
     112,   176,   168,   179,   113,     0,   152,   112,   170,   114,
     170,   114,   170,   113,     0,    67,   195,   113,     0,     0,
     118,   185,   118,     0,     0,   165,     0,    76,     0,    94,
       0,    52,     0,   172,    52,     0,   173,    52,     0,    51,
       0,   172,    51,     0,   173,    51,     0,    76,     0,    77,
       0,    78,     0,    81,     0,    79,     0,    80,     0,    82,
       0,    94,     0,     0,   185,   118,     0,   165,   106,   196,
     119,     0,   178,   106,   196,   119,     0,   165,   105,     6,
       0,   110,     6,     0,   178,   105,     6,     0,   183,   138,
       0,   179,   114,   183,   138,     0,   181,     0,   180,   114,
     181,     0,     6,   182,     0,   164,   182,     0,   112,   196,
     113,     0,   182,   112,   196,   113,     0,     6,     0,     6,
     184,     0,     6,    76,   165,     0,   162,    94,   165,     0,
     164,     0,   164,   184,     0,   164,    76,   165,     0,   164,
      94,   165,     0,   106,   196,   119,     0,   184,   106,   196,
     119,     0,     0,     6,   138,     0,   185,   114,     6,   138,
       0,     0,     6,     0,   186,   114,     6,     0,     6,     0,
     187,   114,     6,     0,   190,     0,   190,   114,    57,     0,
      57,     0,     0,    35,   188,     0,   191,     0,   190,   114,
     191,     0,     0,   165,     0,   193,     0,   192,   114,   193,
       0,     6,   120,   165,     0,     4,   120,   165,     0,   195,
       0,   194,   114,   195,     0,     0,   165,     0,   165,     0,
     196,   114,   165,     0,     3,     0,    28,     0,    29,     0,
      26,     0,     4,     0,   197,     0,    97,   197,     0
};

#endif

#if YYDEBUG
/* YYRLINE[YYN] -- source line where rule number YYN was defined. */
static const short yyrline[] =
{
       0,   461,   484,   493,   500,   505,   506,   509,   510,   511,
     512,   515,   516,   519,   520,   532,   533,   547,   561,   582,
     582,   593,   593,   605,   605,   616,   616,   627,   627,   649,
     650,   651,   652,   653,   655,   667,   677,   678,   680,   681,
     682,   683,   697,   700,   701,   702,   703,   704,   706,   707,
     708,   709,   710,   711,   713,   714,   715,   716,   717,   718,
     718,   731,   733,   735,   737,   739,   746,   753,   753,   760,
     760,   767,   767,   767,   789,   792,   801,   801,   825,   831,
     837,   838,   839,   842,   843,   854,   857,   860,   865,   872,
     880,   881,   884,   885,   888,   889,   892,   899,   906,   906,
     920,   923,   924,   927,   928,   931,   932,   935,   936,   939,
     940,   949,   950,   957,   958,   961,   962,   965,   966,   975,
     976,   983,   984,   987,   988,   991,   992,   995,   996,   999,
    1002,  1003,  1004,  1007,  1008,  1009,  1010,  1011,  1013,  1016,
    1017,  1039,  1044,  1045,  1046,  1050,  1052,  1053,  1055,  1056,
    1057,  1058,  1060,  1061,  1076,  1080,  1081,  1082,  1084,  1087,
    1088,  1089,  1090,  1091,  1093,  1094,  1095,  1096,  1097,  1098,
    1100,  1102,  1103,  1104,  1105,  1106,  1108,  1109,  1110,  1111,
    1112,  1114,  1115,  1116,  1117,  1118,  1119,  1121,  1122,  1123,
    1124,  1125,  1127,  1128,  1129,  1130,  1131,  1132,  1133,  1134,
    1135,  1137,  1138,  1139,  1140,  1141,  1142,  1143,  1145,  1147,
    1148,  1149,  1150,  1151,  1152,  1154,  1155,  1156,  1177,  1178,
    1179,  1180,  1182,  1182,  1184,  1184,  1187,  1187,  1202,  1211,
    1216,  1217,  1220,  1221,  1224,  1225,  1228,  1229,  1230,  1233,
    1234,  1235,  1238,  1239,  1240,  1241,  1242,  1243,  1244,  1247,
    1251,  1254,  1257,  1258,  1259,  1265,  1272,  1279,  1287,  1300,
    1304,  1311,  1312,  1315,  1316,  1319,  1320,  1321,  1322,  1324,
    1325,  1326,  1327,  1330,  1331,  1334,  1335,  1343,  1354,  1355,
    1359,  1373,  1377,  1384,  1385,  1386,  1389,  1390,  1407,  1412,
    1423,  1424,  1429,  1430,  1433,  1434,  1438,  1450,  1465,  1466,
    1469,  1470,  1473,  1474,  1475,  1476,  1477,  1480,  1481
};
#endif


#if (YYDEBUG) || defined YYERROR_VERBOSE

/* YYTNAME[TOKEN_NUM] -- String name of the token TOKEN_NUM. */
static const char *const yytname[] =
{
  "$", "error", "$undefined.", "STRING", "NUMBER", "ISTRING", "NAME", 
  "CTEXT", "DATE", "KEYS", "PREPROC", "RETURN", "FUNCTION", "PROCEDURE", 
  "IPROCEDURE", "EPROCEDURE", "EXTERN", "PARAMETERS", "SFUNCTION", 
  "SPROCEDURE", "TEXT", "PUBLIC", "PRIVATE", "STATIC", "LOCAL", 
  "DIMENSION", "NIL", "END", "TRUE", "FALSE", "WHILE", "DO", "ENDDO", 
  "EXIT", "LOOP", "WITH", "CALL", "IF", "IIF", "ENDIF", "ELSE", "ELSEIF", 
  "DOCASE", "CASE", "OTHERWISE", "ENDCASE", "SWITCH", "ENDSWITCH", 
  "FIELD", "MEMVAR", "IN", "MEMVARPTR", "FIELDPTR", "PCOUNT", "PARBEG", 
  "PARAMBEG", "PSHIFT", "PALL", "FOR", "STEP", "TO", "NEXT", "FOREACH", 
  "BEGSEQ", "RECOVER", "USING", "BREAK", "EBREAK", "ANNOUNCE", "REQUEST", 
  "IFNL", "IFEXPR", "CODESTR", "CODEBLOCK", "AS", "REF", "ASSIGN", "ADDA", 
  "SUBA", "DIVA", "MODA", "MULA", "POWA", "POSTINCR", "'@'", "OR", "AND", 
  "NOT", "'>'", "GE", "'<'", "LE", "EQ", "NE", "'='", "'$'", "'+'", "'-'", 
  "'*'", "'/'", "'%'", "POW", "MINUS", "INCR", "DECR", "':'", "'['", 
  "'.'", "RPTR", "REPTR", "DSEMICOLON", "'\\n'", "'('", "')'", "','", 
  "'&'", "'{'", "'}'", "'|'", "']'", "'#'", "file", "function", 
  "procedure", "paramlist", "operlist", "oper", "@1", "@2", "@3", "@4", 
  "@5", "@6", "@7", "@8", "@9", "@10", "@11", "type_def", "switchlist", 
  "switchbeg", "switchlabel", "for", "next", "keys", "recoverr", 
  "recover", "@12", "curseq", "using", "step", "enddo", "iif", "elseif", 
  "else", "endif", "casebeg", "caselist", "otherwise", "endcase", 
  "endswitch", "inalias", "name", "iname", "mname", "expr", "@13", "@14", 
  "@15", "bparam_list", "nilexpr", "eassign", "fieldptr", "memvarptr", 
  "assign", "ass_op", "func", "code", "arr", "vardef", "dimdef", "dim", 
  "dim_list", "var", "arr_list", "param_list", "namelist", "varlist", 
  "arglist", "with", "arg_list", "arg", "pairlist", "pair", "exprlist", 
  "nexpr", "expr_list", "constant", "mconstant", 0
};
#endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives. */
static const short yyr1[] =
{
       0,   121,   121,   121,   121,   122,   122,   123,   123,   123,
     123,   124,   124,   125,   125,   126,   126,   126,   126,   127,
     126,   128,   126,   129,   126,   130,   126,   131,   126,   126,
     126,   126,   126,   126,   126,   126,   126,   126,   126,   126,
     126,   126,   126,   126,   126,   126,   126,   126,   126,   126,
     126,   126,   126,   126,   126,   126,   126,   126,   126,   132,
     126,   126,   126,   126,   126,   126,   126,   133,   126,   134,
     126,   135,   136,   126,   126,   126,   137,   126,   126,   126,
     138,   138,   138,   139,   139,   140,   140,   141,   141,   142,
     143,   143,   144,   144,   145,   145,   146,   146,   147,   146,
     148,   149,   149,   150,   150,   151,   151,   152,   152,   153,
     153,   154,   154,   155,   155,   156,   156,   157,   157,   158,
     158,   159,   159,   160,   160,   161,   161,   162,   162,   162,
     163,   163,   163,   164,   164,   164,   164,   164,   164,   165,
     165,   165,   165,   165,   165,   165,   165,   165,   165,   165,
     165,   165,   165,   165,   165,   165,   165,   165,   165,   165,
     165,   165,   165,   165,   165,   165,   165,   165,   165,   165,
     165,   165,   165,   165,   165,   165,   165,   165,   165,   165,
     165,   165,   165,   165,   165,   165,   165,   165,   165,   165,
     165,   165,   165,   165,   165,   165,   165,   165,   165,   165,
     165,   165,   165,   165,   165,   165,   165,   165,   165,   165,
     165,   165,   165,   165,   165,   165,   165,   165,   165,   165,
     165,   165,   166,   165,   167,   165,   168,   165,   165,   165,
     169,   169,   170,   170,   171,   171,   172,   172,   172,   173,
     173,   173,   174,   174,   174,   174,   174,   174,   174,   175,
     176,   177,   178,   178,   178,   178,   178,   179,   179,   180,
     180,   181,   181,   182,   182,   183,   183,   183,   183,   183,
     183,   183,   183,   184,   184,   185,   185,   185,   186,   186,
     186,   187,   187,   188,   188,   188,   189,   189,   190,   190,
     191,   191,   192,   192,   193,   193,   194,   194,   195,   195,
     196,   196,   197,   197,   197,   197,   197,   198,   198
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN. */
static const short yyr2[] =
{
       0,     0,     3,     2,     3,     1,     2,     1,     2,     1,
       1,     0,     3,     0,     3,     0,     4,     4,     2,     0,
       3,     0,     3,     0,     3,     0,     3,     0,     3,     2,
       3,     2,     1,     2,     2,     2,     1,     1,     3,     3,
       3,     6,     5,     5,     6,     6,     4,     5,     7,     7,
       9,     8,     8,    10,     6,     5,     4,     5,     6,     0,
       6,     3,     3,     3,     3,     1,     1,     0,    11,     0,
       9,     0,     0,     7,     2,     8,     0,     8,     5,     6,
       0,     2,     2,     1,     4,     0,     2,     2,     3,     1,
       1,     1,     0,     1,     5,     5,     0,     1,     0,     6,
       0,     0,     2,     0,     2,     1,     1,     1,     1,     0,
       5,     0,     3,     1,     1,     0,     2,     1,     5,     0,
       3,     1,     1,     1,     1,     0,     2,     1,     2,     2,
       1,     2,     2,     2,     3,     3,     4,     3,     4,     1,
       1,     1,     1,     1,     3,     2,     4,     4,     1,     3,
       3,     3,     6,     4,     5,     2,     3,     2,     5,     4,
       4,     5,     6,     3,     7,     5,     5,     8,     6,     6,
       3,     4,     5,     6,     3,     4,     5,     6,     6,     4,
       5,     7,     7,     9,     8,     8,    10,     6,     5,     4,
       5,     6,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     2,     2,
       2,     2,     2,     2,     2,     3,     3,     6,     1,     1,
       3,     3,     0,     5,     0,     5,     0,     6,     8,     3,
       0,     3,     0,     1,     1,     1,     1,     2,     2,     1,
       2,     2,     1,     1,     1,     1,     1,     1,     1,     1,
       0,     2,     4,     4,     3,     2,     3,     2,     4,     1,
       3,     2,     2,     3,     4,     1,     2,     3,     3,     1,
       2,     3,     3,     3,     4,     0,     2,     4,     0,     1,
       3,     1,     3,     1,     3,     1,     0,     2,     1,     3,
       0,     1,     1,     3,     3,     3,     1,     3,     0,     1,
       1,     3,     1,     1,     1,     1,     1,     1,     2
};

/* YYDEFACT[S] -- default rule to reduce with in state S when YYTABLE
   doesn't specify something else to do.  Zero means the default is an
   error. */
static const short yydefact[] =
{
       1,     0,    36,   302,   306,   140,   127,     3,   141,    32,
       5,     7,     9,    10,   278,     0,    23,    25,    21,    19,
      27,   305,   303,   304,    59,     0,    65,    66,     0,     0,
     107,     0,     0,     0,     0,   239,   236,   218,     0,     0,
     219,    89,   100,   298,   298,     0,   278,   230,   230,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   298,     0,
       0,     0,     0,     0,   142,   143,    37,     0,     0,   148,
     139,     0,     0,   290,     0,   127,     0,   108,     0,   142,
     143,    33,     0,   148,   279,    18,   281,    31,     0,     0,
       4,     6,     8,     0,   250,     0,     0,     0,   286,   286,
     286,   286,   232,     0,   115,     0,   125,    29,     0,     0,
      71,   299,    74,     0,    35,    34,   275,   222,   224,   145,
     208,   214,   213,   209,   211,   255,   300,     0,   130,     0,
     133,     0,     0,   306,   127,   250,     0,   292,     0,   296,
      11,    11,     2,   127,     0,     0,   232,   242,   243,   244,
     246,   247,   245,   248,     0,     0,     0,     0,   290,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   210,   212,     0,     0,
     155,   240,   237,     0,   157,   128,   241,   238,   129,     0,
       0,     0,   290,     0,   156,     0,   163,     0,   285,   291,
       0,   283,   288,   135,     0,   290,     0,     0,   155,     0,
     157,     0,     0,   265,     0,   269,    24,    80,    26,    22,
     226,    20,     0,     0,    28,   259,     0,   290,    61,    62,
      63,    64,   233,     0,    76,   117,   119,    85,     0,    30,
     220,   221,    13,   229,    80,     0,   298,   298,   290,   144,
       0,     0,   137,   134,   132,   131,     0,     0,   275,     0,
     216,   298,   215,   275,    80,    80,     0,   234,   235,     0,
     233,     0,    38,   149,    39,   170,     0,   174,     0,   151,
     207,   206,   196,   198,   195,   197,   193,   194,   192,   200,
     199,   201,   202,   203,   204,   205,   254,     0,   249,     0,
       0,     0,     0,     0,     0,     0,    40,   256,     0,     0,
     150,     0,     0,     0,     0,     0,     0,   146,   290,   156,
     163,     0,   144,   170,   174,     0,     0,     0,   280,   282,
       0,     0,   266,     0,     0,     0,   270,     0,     0,     0,
     257,     0,     0,   261,   262,     0,    13,   287,   232,    13,
     116,     0,     0,     0,   119,    83,   126,     0,   276,     0,
     231,     0,     0,     0,     0,     0,   301,   138,   136,   295,
     294,   298,     0,     0,     0,   293,   297,     0,    16,    17,
      92,     0,   232,     0,     0,     0,     0,     0,   147,   290,
     252,   159,     0,   160,   179,    46,     0,   171,     0,   175,
     189,    56,   253,   153,   176,    43,   161,   188,    55,   158,
       0,   284,   289,   146,     0,   159,   160,     0,   171,   175,
     267,     0,     0,   268,   271,   272,    80,    81,    82,     0,
       0,     0,   260,     0,     0,     0,     0,    13,   121,   122,
      78,     0,     0,     0,    86,    21,     0,    96,    80,   223,
     225,   154,    42,   166,     0,   165,     0,   251,    12,    93,
       0,     0,     0,   180,    47,   172,   190,    57,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      41,   166,     0,   165,     0,   273,     0,   258,   227,   263,
       0,   105,   106,    60,   232,   111,    13,     0,     0,   307,
      87,    13,     0,   123,   124,    79,    14,     0,   100,     0,
       0,    97,     0,   277,     0,     0,     0,     0,     0,   217,
      69,   103,   232,   152,   177,    44,   162,   178,    45,   169,
       0,   168,   187,    54,   173,   191,    58,     0,   169,     0,
     168,   274,   264,     0,     0,     0,     0,     0,   308,     0,
      88,   101,    11,    11,    73,   181,    48,   164,   182,    49,
      13,     0,     0,     0,     0,     0,     0,     0,     0,   164,
       0,    75,    13,     0,   113,   114,    77,     0,     0,    80,
      80,     0,     0,     0,   104,    67,   228,   184,    51,   167,
     185,    52,   167,     0,    13,   102,    98,     0,     0,   183,
      50,    91,    90,    70,    13,     0,     0,     0,    13,    94,
      95,     0,   186,    53,     0,    68,     0,     0
};

static const short yydefgoto[] =
{
       1,    59,    60,   264,   357,   446,    95,    93,    88,    89,
      96,    97,   604,   560,   242,   447,   349,   340,   354,   355,
     442,    62,   603,   460,   511,   512,   608,   110,   578,   562,
     493,    63,   495,   546,   576,   235,   236,   353,   440,   505,
     239,    79,   130,    80,   126,   246,   247,   341,   117,   233,
     269,    82,    68,   155,   301,   220,   371,    83,   216,   224,
     225,   343,   217,   332,   245,    85,    87,   200,   228,   201,
     202,   136,   137,   138,   139,   206,    70,   500
};

static const short yypact[] =
{
  -32768,   940,-32768,-32768,-32768,-32768,   112,-32768,-32768,  2469,
  -32768,-32768,-32768,-32768,     8,    29,-32768,-32768,   105,   -14,
  -32768,-32768,-32768,-32768,-32768,    24,-32768,-32768,    26,  2554,
  -32768,     0,  2469,    29,    29,-32768,-32768,-32768,  2469,  2469,
  -32768,-32768,-32768,  2469,  2469,   114,     8,    93,    93,  2469,
    2469,  2469,  2469,  2469,  2469,   195,  2469,    28,  2214,   213,
     229,    39,    34,   132,   758,   693,  2842,    11,    14,   627,
  -32768,    12,   136,  2299,    48,   211,   -14,-32768,  2469,   952,
     830,  2842,    23,   941,-32768,   155,-32768,   159,    16,    16,
  -32768,-32768,-32768,    16,-32768,    16,    33,  2469,   -10,   222,
     -10,   222,  2469,  2722,-32768,  2746,   -24,   159,  2586,  2618,
  -32768,  2842,-32768,   162,-32768,   155,   296,-32768,-32768,  2842,
    2882,   254,   254,   254,   254,   204,  2842,   -31,-32768,  2469,
       3,    55,    63,   198,   181,-32768,   -73,-32768,   120,-32768,
     209,   209,-32768,-32768,   139,   130,  2469,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,  2469,  2469,  2469,    21,  2299,  2469,
    2469,  2469,  2469,  2469,  2469,  2469,  2469,  2469,  2469,  2469,
    2469,  2469,  2469,  2469,  2469,  2469,-32768,-32768,   318,  2469,
     200,-32768,-32768,  2469,   841,   216,-32768,-32768,-32768,  2469,
     331,  2469,  2299,  2469,   456,  2469,   952,  2469,-32768,  2842,
     228,   235,-32768,-32768,    64,  2299,   184,    65,   574,  2469,
     850,   355,   359,    15,   277,    19,   264,   253,   264,   264,
  -32768,   264,     7,   272,   273,-32768,  2770,  2299,-32768,-32768,
  -32768,-32768,  2644,   276,-32768,   285,   292,-32768,   404,-32768,
  -32768,-32768,-32768,-32768,   253,   -54,  2469,  2469,  2299,   -21,
    2469,  2670,-32768,   409,-32768,-32768,  2469,  2469,   296,   219,
  -32768,  2469,-32768,   296,   253,   253,  2469,-32768,-32768,  2469,
    2842,   312,  2842,  2842,  2842,   456,  2469,   952,   326,  2842,
    2863,  2882,  2127,  2127,  2127,  2127,  2127,  2127,  2127,  2127,
     299,   299,   239,   239,   239,   254,   319,    18,-32768,    71,
    2469,  2469,   240,    72,  2469,  2469,  2842,-32768,    32,   329,
    2842,  2469,  2469,   255,  2469,  2469,  2696,   351,  2384,   596,
     952,   354,   362,   596,   952,    78,   262,    82,-32768,-32768,
    2469,  2469,   367,  2469,  2469,  2469,   367,    16,   470,   473,
  -32768,    16,  2469,   371,   371,    33,-32768,-32768,  2469,-32768,
  -32768,  2469,   379,    31,   350,   381,-32768,  1636,-32768,   493,
  -32768,   294,   304,   388,  2469,    83,  2842,-32768,-32768,  2842,
    2842,  2469,    38,   198,   398,-32768,-32768,   306,-32768,-32768,
     358,   765,  2469,  2469,  2469,   308,  2469,  2469,-32768,  2299,
  -32768,   456,  2469,   952,  2842,  2842,   407,   456,  2469,   952,
    2842,  2842,-32768,-32768,  2842,  2842,-32768,  2842,  2842,-32768,
    2469,-32768,-32768,-32768,    87,   596,   952,   411,   596,   952,
    2842,   144,  2469,  2842,  2842,  2842,   253,-32768,-32768,   311,
     315,  2469,-32768,  1752,   406,  1056,  2794,-32768,-32768,-32768,
  -32768,   225,   160,     9,-32768,   423,   401,   227,   253,-32768,
  -32768,-32768,  2842,   456,  2469,   952,   178,-32768,-32768,-32768,
     412,  2469,   408,  2842,  2842,-32768,  2842,  2842,   413,  2469,
    2469,   352,  2469,  2469,    91,  2469,  2469,   368,  2469,  2469,
    2842,   596,  2469,   952,    97,-32768,   145,-32768,-32768,-32768,
     372,-32768,-32768,-32768,  2469,   454,-32768,  1520,   258,-32768,
  -32768,-32768,   225,-32768,-32768,-32768,-32768,   423,-32768,   518,
     519,-32768,   501,-32768,  2469,  2469,   384,  2469,  2469,-32768,
  -32768,   718,  2469,-32768,  2842,  2842,-32768,  2842,  2842,   456,
    2469,   952,  2842,  2842,-32768,  2842,  2842,   390,   596,  2469,
     952,-32768,-32768,   416,   419,  2469,     6,  1172,-32768,  1288,
  -32768,   474,   209,   209,-32768,  2842,  2842,  1054,  2842,  2842,
  -32768,  2469,   429,   432,  2469,  2469,   392,  2469,  2469,   952,
     395,-32768,-32768,  2818,-32768,-32768,-32768,    34,   431,   253,
     253,  2469,  2469,  1868,  2842,-32768,-32768,  2842,  2842,  1054,
    2842,  2842,   952,  1984,-32768,-32768,-32768,   436,   438,  2842,
    2842,-32768,-32768,-32768,-32768,  2469,  2469,  1404,-32768,-32768,
  -32768,  1868,  2842,  2842,  2100,-32768,   553,-32768
};

static const short yypgoto[] =
{
  -32768,   109,   111,  -139,  -171,   558,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,-32768,  -241,-32768,-32768,
  -32768,-32768,   -50,-32768,-32768,-32768,-32768,    57,-32768,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,-32768,   208,-32768,-32768,
  -32768,    54,   494,   284,    -1,-32768,-32768,-32768,   521,  -130,
  -32768,   143,   156,   347,  -183,   435,-32768,     5,   -74,-32768,
     230,   349,   236,   364,    25,   528,   477,  -146,   206,-32768,
     259,-32768,   325,  -237,   -39,   451,  -394,    84
};


#define	YYLAST		2988


static const short yytable[] =
{
      66,   305,   265,   358,   112,   113,    69,   252,    81,   361,
     362,   312,   278,   315,    84,   218,   271,   180,   194,   219,
     185,   221,   213,   378,   379,   227,   238,   275,   103,   208,
      98,   105,   100,   574,   128,    86,   503,   108,   109,   222,
     143,   259,   111,   111,   260,   575,   309,   499,   119,   120,
     121,   122,   123,   124,   128,    64,   504,   111,   438,   321,
     359,   254,   181,   182,   360,   186,   187,    35,    36,   255,
     319,   323,   199,   364,   181,   182,   439,   391,   397,    35,
      36,   347,   249,   250,   415,    35,    36,   365,   418,   453,
     212,   330,   384,   481,   387,   334,   226,   529,    94,    35,
      36,   232,   363,   538,   548,    74,   181,   182,   499,  -127,
     253,   104,    90,   335,   186,   187,   144,    91,    92,   342,
     114,   331,    74,   183,   195,   331,    57,    57,   251,    57,
      74,    57,   250,   276,   456,   209,    57,   390,    57,    57,
     129,    57,   214,   214,    67,   270,   250,   214,    57,   214,
     142,   402,   359,   272,   273,   274,   457,   199,   279,   280,
     281,   282,   283,   284,   285,   286,   287,   288,   289,   290,
     291,   292,   293,   294,   295,   433,   195,   276,   435,    57,
      57,   181,   182,   392,   398,   487,    57,    57,   306,   266,
     392,   199,   310,    57,   398,   454,   316,    57,    57,   482,
     131,   125,    57,   530,   199,   145,    57,   513,   470,   539,
     473,   116,    57,   132,   476,   267,   479,   131,   434,   140,
      71,    72,   376,   373,    73,   374,   199,    74,     3,     4,
     132,   145,   145,   268,   261,   141,   145,   262,   145,    10,
      11,    12,    13,   468,   146,   111,   111,   199,   197,   366,
     507,    21,   462,    22,    23,   369,   370,   227,   250,   250,
     111,     3,     4,   485,   541,   380,   497,   429,   381,   211,
     515,   501,   518,   212,   502,   243,   147,   148,   149,   150,
     151,   152,   153,   372,    21,    65,    22,    23,   377,   204,
      72,   508,   261,   205,   298,   519,    74,   322,   250,   394,
     395,   257,   244,   400,   401,   229,   230,   231,   299,    99,
     404,   405,   101,   407,   408,    74,   248,   199,   256,   204,
      72,   263,   498,   205,   296,   547,    74,   338,   339,   420,
     549,    74,   423,   424,   425,   351,   352,   307,   597,   598,
     175,   317,   176,   177,   178,   179,   565,   270,   568,   318,
     436,   184,   188,   396,   250,   196,    66,   176,   177,   178,
     179,   328,    69,   452,   543,   329,   210,   459,   406,   250,
     111,   333,   215,   215,   582,   417,   250,   215,   337,   215,
     223,   270,   463,   464,   342,   466,   467,   345,   199,   583,
     348,   214,   563,   441,   352,   214,   350,   172,   173,   174,
     175,   593,   176,   177,   178,   179,   606,   449,   261,   480,
     356,    64,   159,   579,   580,   368,   193,   450,   261,   458,
     359,   465,   250,   607,   488,   337,   382,   159,   489,   250,
     193,   389,    66,   611,    66,    91,    92,   614,    69,   388,
      69,   277,   403,   160,   161,   410,   162,   163,   164,   165,
     166,   167,   168,   169,   170,   171,   172,   173,   174,   175,
     521,   176,   177,   178,   179,   526,   250,   413,   524,   525,
     414,   527,   528,   422,   532,   533,   427,   535,   536,   428,
     145,   534,   250,   431,   145,   542,   250,    64,   320,    64,
     437,   324,   444,   270,   544,   545,    66,   557,   250,   448,
      67,   451,    69,   569,   250,   589,   250,   127,   592,   250,
     106,   107,   506,   555,   556,   474,   558,   559,   257,   484,
     494,   270,   522,   520,   552,   553,   523,   300,   554,   571,
     572,   304,   147,   148,   149,   150,   151,   152,   153,   577,
     585,   311,   596,   314,   573,   586,    66,   609,    66,   610,
     298,    64,    69,   617,    69,   300,   509,   304,   510,    61,
     584,   615,   443,   587,   588,   551,   590,   591,   203,   118,
     258,    74,   344,   426,   115,   432,    67,   412,    67,   336,
     599,   600,    66,   393,   375,     0,   550,   399,    69,     0,
       0,     0,    66,     0,     0,     0,     0,     0,    69,     0,
       0,    64,     0,    64,   612,   613,    66,     0,     0,   416,
      66,   419,    69,    66,     0,     0,    69,     0,     0,    69,
       0,   215,   383,     0,   386,   215,     0,     0,     0,   223,
     297,   595,     0,     0,   302,     0,     0,    64,     0,     0,
      67,    65,   308,     0,     0,     0,   313,    64,     0,   455,
     147,   148,   149,   150,   151,   152,   153,     0,     0,     0,
     326,    64,     0,     0,     0,    64,   311,   314,    64,     0,
     383,   386,   147,   148,   149,   150,   151,   152,   153,     0,
       0,     0,   325,     0,     0,     0,     0,     0,     0,    74,
      67,     0,    67,     0,     0,     0,     0,     0,   483,     0,
       0,     0,     0,   147,   148,   149,   150,   151,   152,   153,
       0,    74,     0,     0,     0,     0,     0,    65,     0,    65,
     145,   189,     0,     0,     0,     0,    67,   385,     0,     0,
       0,     0,   190,   191,     0,     0,    67,     0,   469,   192,
     472,     0,     0,     0,   475,     0,   478,     0,     0,     0,
      67,     0,     0,     0,    67,     0,     0,    67,   531,     0,
       0,     0,   469,   472,     0,   475,   478,     0,   540,   147,
     148,   149,   150,   151,   152,   153,     0,   561,     0,     0,
       0,    65,   421,     0,     0,     0,     0,   156,     0,     0,
       0,     0,     0,   430,     0,     0,     0,     0,     0,     0,
     514,   157,   517,   160,   161,   158,   162,   163,   164,   165,
     166,   167,   168,   169,   170,   171,   172,   173,   174,   175,
       0,   176,   177,   178,   179,   461,     0,     0,   514,     0,
     517,    65,     0,    65,   147,   148,   149,   150,   151,   152,
     153,     0,     0,   471,     0,     0,     0,     0,     0,   477,
     160,   161,   154,   162,   163,   164,   165,   166,   167,   168,
     169,   170,   171,   172,   173,   174,   175,    65,   176,   177,
     178,   179,     0,   486,     0,     0,   564,    65,   567,     0,
       0,     0,   490,     0,     0,   564,     0,   567,     0,     0,
       0,    65,     0,     0,     0,    65,     0,     0,    65,     0,
       0,     0,     0,     0,   581,   516,   147,   148,   149,   150,
     151,   152,   153,     0,     0,     0,   581,   147,   148,   149,
     150,   151,   152,   153,     0,     0,   147,   148,   149,   150,
     151,   152,   153,   537,     0,   298,   605,     0,   207,   605,
     616,     2,   158,     3,     4,     5,     6,     7,     8,   303,
       0,     9,    10,    11,    12,    13,    14,    15,   327,     0,
       0,    16,    17,    18,    19,    20,    21,     0,    22,    23,
      24,    25,     0,    26,    27,     0,    28,    29,    30,     0,
       0,   566,    31,     0,     0,     0,    32,     0,    33,    34,
     570,    35,    36,    37,    38,    39,    40,     0,    41,     0,
       0,     0,     0,    42,     0,     0,    43,    44,    45,    46,
       0,     0,    47,    48,     0,     0,     0,   147,   148,   149,
     150,   151,   152,   153,    49,     0,     0,    50,   147,   148,
     149,   150,   151,   152,   153,     0,    51,    52,     0,     0,
       0,     0,     0,    53,    54,     0,   190,   191,     0,     0,
      55,   -15,    56,   192,     0,    57,    58,     2,     0,     3,
       4,     5,     6,     0,     8,     0,     0,     9,    10,    11,
      12,    13,    14,    15,     0,     0,     0,    16,    17,   445,
      19,    20,    21,  -109,    22,    23,    24,    25,     0,    26,
      27,     0,    28,    29,    30,  -109,  -109,  -109,    31,     0,
       0,     0,    32,     0,    33,    34,     0,    35,    36,    37,
      38,    39,    40,     0,    41,     0,     0,     0,     0,    42,
       0,     0,    43,    44,    45,    46,     0,     0,    47,    48,
     147,   148,   149,   150,   151,   152,   153,     0,     0,     0,
      49,     0,     0,    50,     0,     0,     0,     0,   298,     0,
       0,     0,    51,    52,     0,     0,     0,     0,     0,    53,
      54,     0,     0,     0,     0,     0,    55,   -15,    56,     0,
       0,    57,    58,     2,     0,     3,     4,     5,     6,     0,
       8,     0,     0,     9,    10,    11,    12,    13,    14,    15,
       0,     0,     0,    16,    17,   445,    19,    20,    21,  -118,
      22,    23,    24,    25,     0,    26,    27,     0,    28,    29,
      30,     0,     0,     0,    31,  -118,  -118,  -118,    32,     0,
      33,    34,     0,    35,    36,    37,    38,    39,    40,     0,
      41,     0,     0,     0,     0,    42,     0,     0,    43,    44,
      45,    46,     0,     0,    47,    48,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    49,     0,     0,    50,
       0,     0,     0,     0,     0,     0,     0,     0,    51,    52,
       0,     0,     0,     0,     0,    53,    54,     0,     0,     0,
       0,     0,    55,   -15,    56,     0,     0,    57,    58,     2,
       0,     3,     4,     5,     6,     0,     8,     0,     0,     9,
      10,    11,    12,    13,    14,    15,     0,     0,     0,    16,
      17,   445,    19,    20,    21,   -84,    22,    23,    24,    25,
       0,    26,    27,     0,    28,    29,    30,     0,     0,     0,
      31,   -84,   -84,     0,    32,   -84,    33,    34,     0,    35,
      36,    37,    38,    39,    40,     0,    41,     0,     0,     0,
       0,    42,     0,     0,    43,    44,    45,    46,     0,     0,
      47,    48,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    49,     0,     0,    50,     0,     0,     0,     0,
       0,     0,     0,     0,    51,    52,     0,     0,     0,     0,
       0,    53,    54,     0,     0,     0,     0,     0,    55,   -15,
      56,     0,     0,    57,    58,     2,     0,     3,     4,     5,
       6,     0,     8,     0,     0,     9,    10,    11,    12,    13,
      14,    15,     0,     0,     0,    16,    17,   445,    19,    20,
      21,  -110,    22,    23,    24,    25,     0,    26,    27,     0,
      28,    29,    30,  -110,  -110,  -110,    31,     0,     0,     0,
      32,     0,    33,    34,     0,    35,    36,    37,    38,    39,
      40,     0,    41,     0,     0,     0,     0,    42,     0,     0,
      43,    44,    45,    46,     0,     0,    47,    48,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    49,     0,
       0,    50,     0,     0,     0,     0,     0,     0,     0,     0,
      51,    52,     0,     0,     0,     0,     0,    53,    54,     0,
       0,     0,     0,     0,    55,   -15,    56,     0,     0,    57,
      58,     2,     0,     3,     4,     5,     6,     0,     8,     0,
       0,     9,    10,    11,    12,    13,    14,    15,     0,     0,
       0,    16,    17,   445,    19,    20,    21,  -120,    22,    23,
      24,    25,     0,    26,    27,     0,    28,    29,    30,     0,
       0,     0,    31,     0,     0,  -120,    32,  -120,    33,    34,
       0,    35,    36,    37,    38,    39,    40,     0,    41,     0,
       0,     0,     0,    42,     0,     0,    43,    44,    45,    46,
       0,     0,    47,    48,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    49,     0,     0,    50,     0,     0,
       0,     0,     0,     0,     0,     0,    51,    52,     0,     0,
       0,     0,     0,    53,    54,     0,     0,     0,     0,     0,
      55,   -15,    56,     0,     0,    57,    58,     2,     0,     3,
       4,     5,     6,     0,     8,     0,     0,     9,    10,    11,
      12,    13,    14,    15,     0,     0,     0,    16,    17,   445,
      19,    20,    21,   -72,    22,    23,    24,    25,     0,    26,
      27,     0,    28,    29,    30,     0,     0,     0,    31,     0,
       0,     0,    32,     0,    33,    34,     0,    35,    36,    37,
      38,    39,    40,     0,    41,     0,     0,     0,     0,    42,
     -72,     0,    43,    44,    45,    46,     0,     0,    47,    48,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      49,     0,     0,    50,     0,     0,     0,     0,     0,     0,
       0,     0,    51,    52,     0,     0,     0,     0,     0,    53,
      54,     0,     0,     0,     0,     0,    55,   -15,    56,     0,
       0,    57,    58,     2,     0,     3,     4,     5,     6,     0,
       8,     0,     0,     9,    10,    11,    12,    13,    14,    15,
       0,     0,     0,    16,    17,   445,    19,    20,    21,   491,
      22,    23,    24,    25,   492,    26,    27,     0,    28,    29,
      30,     0,     0,     0,    31,     0,     0,     0,    32,     0,
      33,    34,     0,    35,    36,    37,    38,    39,    40,     0,
      41,     0,     0,     0,     0,    42,     0,     0,    43,    44,
      45,    46,     0,     0,    47,    48,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    49,     0,     0,    50,
       0,     0,     0,     0,     0,     0,     0,     0,    51,    52,
       0,     0,     0,     0,     0,    53,    54,     0,     0,     0,
       0,     0,    55,   -15,    56,     0,     0,    57,    58,     2,
       0,     3,     4,     5,     6,     0,     8,     0,     0,     9,
      10,    11,    12,    13,    14,    15,     0,     0,     0,    16,
      17,   445,    19,    20,    21,   601,    22,    23,    24,    25,
       0,    26,    27,     0,    28,    29,    30,     0,     0,     0,
      31,     0,     0,     0,    32,     0,    33,    34,     0,    35,
      36,    37,    38,    39,    40,     0,    41,     0,     0,   602,
       0,    42,     0,     0,    43,    44,    45,    46,     0,     0,
      47,    48,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    49,     0,     0,    50,     0,     0,     0,     0,
       0,     0,     0,     0,    51,    52,     0,     0,     0,     0,
       0,    53,    54,     0,     0,     0,     0,     0,    55,   -15,
      56,     0,     0,    57,    58,     2,     0,     3,     4,     5,
       6,     0,     8,     0,     0,     9,    10,    11,    12,    13,
      14,    15,     0,     0,     0,    16,    17,   445,    19,    20,
      21,  -112,    22,    23,    24,    25,     0,    26,    27,     0,
      28,    29,    30,  -112,     0,     0,    31,     0,     0,     0,
      32,     0,    33,    34,     0,    35,    36,    37,    38,    39,
      40,     0,    41,     0,     0,     0,     0,    42,     0,     0,
      43,    44,    45,    46,     0,     0,    47,    48,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    49,     0,
       0,    50,     0,     0,     0,     0,     0,     0,     0,     0,
      51,    52,     0,     0,     0,     0,     0,    53,    54,     0,
       0,     0,     0,     0,    55,   -15,    56,     0,     0,    57,
      58,     2,     0,     3,     4,     5,     6,     0,     8,     0,
       0,     9,    10,    11,    12,    13,    14,    15,     0,     0,
       0,    16,    17,   445,    19,    20,    21,   -99,    22,    23,
      24,    25,     0,    26,    27,     0,    28,    29,    30,     0,
       0,     0,    31,     0,     0,     0,    32,     0,    33,    34,
       0,    35,    36,    37,    38,    39,    40,     0,    41,     0,
       0,     0,     0,    42,     0,     0,    43,    44,    45,    46,
       0,     0,    47,    48,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    49,     0,     0,    50,     0,     0,
       0,     0,     0,     0,     0,     0,    51,    52,     0,     0,
       0,     0,     0,    53,    54,     0,     0,     0,     0,     0,
      55,   -15,    56,     0,     0,    57,    58,     3,   133,     5,
     134,     0,     8,   170,   171,   172,   173,   174,   175,     0,
     176,   177,   178,   179,     0,     0,     0,     0,    76,     0,
      21,     0,    22,    23,     0,     0,     0,     0,     0,     0,
       0,    77,    30,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    35,    36,    37,    38,    39,
      40,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    44,     0,     0,     0,     0,    47,    48,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    49,     0,
       0,    50,     3,     4,     5,    75,     0,     8,     0,     0,
      51,    52,     0,     0,     0,     0,     0,    53,    54,     0,
       0,     0,     0,    76,    55,    21,    78,    22,    23,    57,
      58,     0,   135,     0,     0,     0,    77,    30,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      35,    36,    37,    38,    39,    40,   198,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    44,     0,     0,     0,
       0,    47,    48,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    49,     0,     0,    50,     3,     4,     5,
      75,     0,     8,     0,     0,    51,    52,     0,     0,     0,
       0,     0,    53,    54,     0,     0,     0,     0,    76,    55,
      21,    78,    22,    23,    57,    58,     0,     0,     0,     0,
       0,    77,    30,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    35,    36,    37,    38,    39,
      40,   411,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    44,     0,     0,     0,     0,    47,    48,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    49,     0,
       0,    50,     3,     4,     5,    75,     0,     8,     0,     0,
      51,    52,     0,     0,     0,     0,     0,    53,    54,     0,
       0,     0,     0,    76,    55,    21,    78,    22,    23,    57,
      58,     0,     0,     0,     0,     0,    77,    30,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      35,    36,    37,    38,    39,    40,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    44,     0,     0,     0,
       0,    47,    48,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    49,     0,     0,    50,     3,     4,     5,
      75,     0,     8,     0,     0,    51,    52,     0,     0,     0,
       0,     0,    53,    54,     0,     0,     0,     0,    76,    55,
      21,    78,    22,    23,    57,    58,     0,     0,     0,     0,
       0,    77,    30,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    35,    36,    37,    38,    39,
      40,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    44,     0,     0,     0,     0,    47,    48,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    49,     0,
       0,    50,     0,     0,     0,     0,     0,     0,     0,     0,
      51,    52,     0,     0,     0,     0,     0,    53,    54,     0,
       0,     0,     0,     0,    55,     0,   102,     0,     0,    57,
      58,   160,   161,     0,   162,   163,   164,   165,   166,   167,
     168,   169,   170,   171,   172,   173,   174,   175,     0,   176,
     177,   178,   179,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   160,   161,   240,   162,   163,   164,   165,
     166,   167,   168,   169,   170,   171,   172,   173,   174,   175,
       0,   176,   177,   178,   179,     0,     0,     0,     0,   160,
     161,   241,   162,   163,   164,   165,   166,   167,   168,   169,
     170,   171,   172,   173,   174,   175,     0,   176,   177,   178,
     179,     0,     0,     0,     0,   160,   161,  -300,   162,   163,
     164,   165,   166,   167,   168,   169,   170,   171,   172,   173,
     174,   175,     0,   176,   177,   178,   179,     0,     0,     0,
       0,   160,   161,   367,   162,   163,   164,   165,   166,   167,
     168,   169,   170,   171,   172,   173,   174,   175,     0,   176,
     177,   178,   179,     0,     0,     0,     0,   160,   161,   409,
     162,   163,   164,   165,   166,   167,   168,   169,   170,   171,
     172,   173,   174,   175,     0,   176,   177,   178,   179,     0,
       0,   160,   161,   234,   162,   163,   164,   165,   166,   167,
     168,   169,   170,   171,   172,   173,   174,   175,     0,   176,
     177,   178,   179,     0,     0,   160,   161,   237,   162,   163,
     164,   165,   166,   167,   168,   169,   170,   171,   172,   173,
     174,   175,     0,   176,   177,   178,   179,     0,     0,   160,
     161,   346,   162,   163,   164,   165,   166,   167,   168,   169,
     170,   171,   172,   173,   174,   175,     0,   176,   177,   178,
     179,     0,     0,   160,   161,   496,   162,   163,   164,   165,
     166,   167,   168,   169,   170,   171,   172,   173,   174,   175,
       0,   176,   177,   178,   179,     0,     0,   160,   161,   594,
     162,   163,   164,   165,   166,   167,   168,   169,   170,   171,
     172,   173,   174,   175,     0,   176,   177,   178,   179,   161,
       0,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   175,     0,   176,   177,   178,   179,
     162,   163,   164,   165,   166,   167,   168,   169,   170,   171,
     172,   173,   174,   175,     0,   176,   177,   178,   179
};

static const short yycheck[] =
{
       1,   184,   141,   244,    43,    44,     1,     4,     9,   246,
     247,   194,   158,   196,     6,    89,   146,     6,     6,    93,
       6,    95,     6,   264,   265,    35,    50,     6,    29,     6,
       6,    32,     6,    27,     6,     6,    27,    38,    39,     6,
       6,   114,    43,    44,   117,    39,   192,   441,    49,    50,
      51,    52,    53,    54,     6,     1,    47,    58,    27,   205,
     114,     6,    51,    52,   118,    51,    52,    51,    52,     6,
       6,     6,    73,    94,    51,    52,    45,     6,     6,    51,
      52,   227,   113,   114,     6,    51,    52,   108,     6,     6,
     114,    76,   275,     6,   277,    76,    97,     6,   112,    51,
      52,   102,   248,     6,   498,   115,    51,    52,   502,    94,
     107,   111,     7,    94,    51,    52,    62,    12,    13,   112,
       6,   106,   115,   112,   112,   106,   115,   115,   129,   115,
     115,   115,   114,   112,   371,   112,   115,   119,   115,   115,
     112,   115,    88,    89,     1,   146,   114,    93,   115,    95,
     111,   119,   114,   154,   155,   156,   118,   158,   159,   160,
     161,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   175,   346,   112,   112,   349,   115,
     115,    51,    52,   112,   112,   426,   115,   115,   189,    50,
     112,   192,   193,   115,   112,   112,   197,   115,   115,   112,
      57,     6,   115,   112,   205,    62,   115,   448,   391,   112,
     393,   118,   115,    57,   397,    76,   399,    74,   348,     6,
     108,   109,   261,     4,   112,     6,   227,   115,     3,     4,
      74,    88,    89,    94,   114,     6,    93,   117,    95,    12,
      13,    14,    15,   389,   112,   246,   247,   248,   112,   250,
      23,    26,   382,    28,    29,   256,   257,    35,   114,   114,
     261,     3,     4,   119,   119,   266,   437,   341,   269,   114,
     453,   111,   455,   114,   114,   113,    76,    77,    78,    79,
      80,    81,    82,   258,    26,     1,    28,    29,   263,   108,
     109,    64,   114,   112,    94,   117,   115,   113,   114,   300,
     301,   120,     6,   304,   305,    99,   100,   101,   108,    25,
     311,   312,    28,   314,   315,   115,   112,   318,   120,   108,
     109,   112,    97,   112,     6,   496,   115,    74,    75,   330,
     501,   115,   333,   334,   335,    43,    44,     6,   579,   580,
     101,   113,   103,   104,   105,   106,   529,   348,   531,   114,
     351,    67,    68,   113,   114,    71,   357,   103,   104,   105,
     106,     6,   357,   364,   494,     6,    82,     9,   113,   114,
     371,    94,    88,    89,   557,   113,   114,    93,   114,    95,
      96,   382,   383,   384,   112,   386,   387,   114,   389,   560,
     114,   337,   522,    43,    44,   341,   111,    98,    99,   100,
     101,   572,   103,   104,   105,   106,   589,   113,   114,   410,
       6,   357,    65,   552,   553,     6,    69,   113,   114,   113,
     114,   113,   114,   594,   113,   114,   114,    80,   113,   114,
      83,   112,   433,   604,   435,    12,    13,   608,   433,   113,
     435,   157,   113,    85,    86,    94,    88,    89,    90,    91,
      92,    93,    94,    95,    96,    97,    98,    99,   100,   101,
     461,   103,   104,   105,   106,   113,   114,   113,   469,   470,
     108,   472,   473,   106,   475,   476,     6,   478,   479,     6,
     337,   113,   114,   112,   341,   113,   114,   433,   204,   435,
     111,   207,   111,   494,    40,    41,   497,   113,   114,     6,
     357,   113,   497,   113,   114,   113,   114,    56,   113,   114,
      33,    34,   111,   514,   515,   108,   517,   518,   120,   108,
     114,   522,   114,   111,     6,     6,   113,   180,    27,   113,
     111,   184,    76,    77,    78,    79,    80,    81,    82,    65,
     111,   194,   111,   196,   545,   113,   547,   111,   549,   111,
      94,   497,   547,     0,   549,   208,   447,   210,   447,     1,
     561,   611,   354,   564,   565,   508,   567,   568,    74,    48,
     135,   115,   223,   337,    46,   345,   433,   318,   435,   215,
     581,   582,   583,   299,   259,    -1,   502,   303,   583,    -1,
      -1,    -1,   593,    -1,    -1,    -1,    -1,    -1,   593,    -1,
      -1,   547,    -1,   549,   605,   606,   607,    -1,    -1,   325,
     611,   327,   607,   614,    -1,    -1,   611,    -1,    -1,   614,
      -1,   337,   275,    -1,   277,   341,    -1,    -1,    -1,   345,
     179,   577,    -1,    -1,   183,    -1,    -1,   583,    -1,    -1,
     497,   357,   191,    -1,    -1,    -1,   195,   593,    -1,   365,
      76,    77,    78,    79,    80,    81,    82,    -1,    -1,    -1,
     209,   607,    -1,    -1,    -1,   611,   319,   320,   614,    -1,
     323,   324,    76,    77,    78,    79,    80,    81,    82,    -1,
      -1,    -1,   108,    -1,    -1,    -1,    -1,    -1,    -1,   115,
     547,    -1,   549,    -1,    -1,    -1,    -1,    -1,   414,    -1,
      -1,    -1,    -1,    76,    77,    78,    79,    80,    81,    82,
      -1,   115,    -1,    -1,    -1,    -1,    -1,   433,    -1,   435,
     577,    94,    -1,    -1,    -1,    -1,   583,   276,    -1,    -1,
      -1,    -1,   105,   106,    -1,    -1,   593,    -1,   391,   112,
     393,    -1,    -1,    -1,   397,    -1,   399,    -1,    -1,    -1,
     607,    -1,    -1,    -1,   611,    -1,    -1,   614,   474,    -1,
      -1,    -1,   415,   416,    -1,   418,   419,    -1,   484,    76,
      77,    78,    79,    80,    81,    82,    -1,    59,    -1,    -1,
      -1,   497,   331,    -1,    -1,    -1,    -1,    94,    -1,    -1,
      -1,    -1,    -1,   342,    -1,    -1,    -1,    -1,    -1,    -1,
     453,   108,   455,    85,    86,   112,    88,    89,    90,    91,
      92,    93,    94,    95,    96,    97,    98,    99,   100,   101,
      -1,   103,   104,   105,   106,    60,    -1,    -1,   481,    -1,
     483,   547,    -1,   549,    76,    77,    78,    79,    80,    81,
      82,    -1,    -1,   392,    -1,    -1,    -1,    -1,    -1,   398,
      85,    86,    94,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   583,   103,   104,
     105,   106,    -1,   422,    -1,    -1,   529,   593,   531,    -1,
      -1,    -1,   431,    -1,    -1,   538,    -1,   540,    -1,    -1,
      -1,   607,    -1,    -1,    -1,   611,    -1,    -1,   614,    -1,
      -1,    -1,    -1,    -1,   557,   454,    76,    77,    78,    79,
      80,    81,    82,    -1,    -1,    -1,   569,    76,    77,    78,
      79,    80,    81,    82,    -1,    -1,    76,    77,    78,    79,
      80,    81,    82,   482,    -1,    94,   589,    -1,   108,   592,
       0,     1,   112,     3,     4,     5,     6,     7,     8,   108,
      -1,    11,    12,    13,    14,    15,    16,    17,   108,    -1,
      -1,    21,    22,    23,    24,    25,    26,    -1,    28,    29,
      30,    31,    -1,    33,    34,    -1,    36,    37,    38,    -1,
      -1,   530,    42,    -1,    -1,    -1,    46,    -1,    48,    49,
     539,    51,    52,    53,    54,    55,    56,    -1,    58,    -1,
      -1,    -1,    -1,    63,    -1,    -1,    66,    67,    68,    69,
      -1,    -1,    72,    73,    -1,    -1,    -1,    76,    77,    78,
      79,    80,    81,    82,    84,    -1,    -1,    87,    76,    77,
      78,    79,    80,    81,    82,    -1,    96,    97,    -1,    -1,
      -1,    -1,    -1,   103,   104,    -1,   105,   106,    -1,    -1,
     110,   111,   112,   112,    -1,   115,   116,     1,    -1,     3,
       4,     5,     6,    -1,     8,    -1,    -1,    11,    12,    13,
      14,    15,    16,    17,    -1,    -1,    -1,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    -1,    33,
      34,    -1,    36,    37,    38,    39,    40,    41,    42,    -1,
      -1,    -1,    46,    -1,    48,    49,    -1,    51,    52,    53,
      54,    55,    56,    -1,    58,    -1,    -1,    -1,    -1,    63,
      -1,    -1,    66,    67,    68,    69,    -1,    -1,    72,    73,
      76,    77,    78,    79,    80,    81,    82,    -1,    -1,    -1,
      84,    -1,    -1,    87,    -1,    -1,    -1,    -1,    94,    -1,
      -1,    -1,    96,    97,    -1,    -1,    -1,    -1,    -1,   103,
     104,    -1,    -1,    -1,    -1,    -1,   110,   111,   112,    -1,
      -1,   115,   116,     1,    -1,     3,     4,     5,     6,    -1,
       8,    -1,    -1,    11,    12,    13,    14,    15,    16,    17,
      -1,    -1,    -1,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    -1,    33,    34,    -1,    36,    37,
      38,    -1,    -1,    -1,    42,    43,    44,    45,    46,    -1,
      48,    49,    -1,    51,    52,    53,    54,    55,    56,    -1,
      58,    -1,    -1,    -1,    -1,    63,    -1,    -1,    66,    67,
      68,    69,    -1,    -1,    72,    73,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    84,    -1,    -1,    87,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    97,
      -1,    -1,    -1,    -1,    -1,   103,   104,    -1,    -1,    -1,
      -1,    -1,   110,   111,   112,    -1,    -1,   115,   116,     1,
      -1,     3,     4,     5,     6,    -1,     8,    -1,    -1,    11,
      12,    13,    14,    15,    16,    17,    -1,    -1,    -1,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
      -1,    33,    34,    -1,    36,    37,    38,    -1,    -1,    -1,
      42,    43,    44,    -1,    46,    47,    48,    49,    -1,    51,
      52,    53,    54,    55,    56,    -1,    58,    -1,    -1,    -1,
      -1,    63,    -1,    -1,    66,    67,    68,    69,    -1,    -1,
      72,    73,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    96,    97,    -1,    -1,    -1,    -1,
      -1,   103,   104,    -1,    -1,    -1,    -1,    -1,   110,   111,
     112,    -1,    -1,   115,   116,     1,    -1,     3,     4,     5,
       6,    -1,     8,    -1,    -1,    11,    12,    13,    14,    15,
      16,    17,    -1,    -1,    -1,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    -1,    33,    34,    -1,
      36,    37,    38,    39,    40,    41,    42,    -1,    -1,    -1,
      46,    -1,    48,    49,    -1,    51,    52,    53,    54,    55,
      56,    -1,    58,    -1,    -1,    -1,    -1,    63,    -1,    -1,
      66,    67,    68,    69,    -1,    -1,    72,    73,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    84,    -1,
      -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      96,    97,    -1,    -1,    -1,    -1,    -1,   103,   104,    -1,
      -1,    -1,    -1,    -1,   110,   111,   112,    -1,    -1,   115,
     116,     1,    -1,     3,     4,     5,     6,    -1,     8,    -1,
      -1,    11,    12,    13,    14,    15,    16,    17,    -1,    -1,
      -1,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    -1,    33,    34,    -1,    36,    37,    38,    -1,
      -1,    -1,    42,    -1,    -1,    45,    46,    47,    48,    49,
      -1,    51,    52,    53,    54,    55,    56,    -1,    58,    -1,
      -1,    -1,    -1,    63,    -1,    -1,    66,    67,    68,    69,
      -1,    -1,    72,    73,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    84,    -1,    -1,    87,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    96,    97,    -1,    -1,
      -1,    -1,    -1,   103,   104,    -1,    -1,    -1,    -1,    -1,
     110,   111,   112,    -1,    -1,   115,   116,     1,    -1,     3,
       4,     5,     6,    -1,     8,    -1,    -1,    11,    12,    13,
      14,    15,    16,    17,    -1,    -1,    -1,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    -1,    33,
      34,    -1,    36,    37,    38,    -1,    -1,    -1,    42,    -1,
      -1,    -1,    46,    -1,    48,    49,    -1,    51,    52,    53,
      54,    55,    56,    -1,    58,    -1,    -1,    -1,    -1,    63,
      64,    -1,    66,    67,    68,    69,    -1,    -1,    72,    73,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      84,    -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    96,    97,    -1,    -1,    -1,    -1,    -1,   103,
     104,    -1,    -1,    -1,    -1,    -1,   110,   111,   112,    -1,
      -1,   115,   116,     1,    -1,     3,     4,     5,     6,    -1,
       8,    -1,    -1,    11,    12,    13,    14,    15,    16,    17,
      -1,    -1,    -1,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    -1,    36,    37,
      38,    -1,    -1,    -1,    42,    -1,    -1,    -1,    46,    -1,
      48,    49,    -1,    51,    52,    53,    54,    55,    56,    -1,
      58,    -1,    -1,    -1,    -1,    63,    -1,    -1,    66,    67,
      68,    69,    -1,    -1,    72,    73,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    84,    -1,    -1,    87,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    96,    97,
      -1,    -1,    -1,    -1,    -1,   103,   104,    -1,    -1,    -1,
      -1,    -1,   110,   111,   112,    -1,    -1,   115,   116,     1,
      -1,     3,     4,     5,     6,    -1,     8,    -1,    -1,    11,
      12,    13,    14,    15,    16,    17,    -1,    -1,    -1,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
      -1,    33,    34,    -1,    36,    37,    38,    -1,    -1,    -1,
      42,    -1,    -1,    -1,    46,    -1,    48,    49,    -1,    51,
      52,    53,    54,    55,    56,    -1,    58,    -1,    -1,    61,
      -1,    63,    -1,    -1,    66,    67,    68,    69,    -1,    -1,
      72,    73,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    96,    97,    -1,    -1,    -1,    -1,
      -1,   103,   104,    -1,    -1,    -1,    -1,    -1,   110,   111,
     112,    -1,    -1,   115,   116,     1,    -1,     3,     4,     5,
       6,    -1,     8,    -1,    -1,    11,    12,    13,    14,    15,
      16,    17,    -1,    -1,    -1,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    -1,    33,    34,    -1,
      36,    37,    38,    39,    -1,    -1,    42,    -1,    -1,    -1,
      46,    -1,    48,    49,    -1,    51,    52,    53,    54,    55,
      56,    -1,    58,    -1,    -1,    -1,    -1,    63,    -1,    -1,
      66,    67,    68,    69,    -1,    -1,    72,    73,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    84,    -1,
      -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      96,    97,    -1,    -1,    -1,    -1,    -1,   103,   104,    -1,
      -1,    -1,    -1,    -1,   110,   111,   112,    -1,    -1,   115,
     116,     1,    -1,     3,     4,     5,     6,    -1,     8,    -1,
      -1,    11,    12,    13,    14,    15,    16,    17,    -1,    -1,
      -1,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    -1,    33,    34,    -1,    36,    37,    38,    -1,
      -1,    -1,    42,    -1,    -1,    -1,    46,    -1,    48,    49,
      -1,    51,    52,    53,    54,    55,    56,    -1,    58,    -1,
      -1,    -1,    -1,    63,    -1,    -1,    66,    67,    68,    69,
      -1,    -1,    72,    73,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    84,    -1,    -1,    87,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    96,    97,    -1,    -1,
      -1,    -1,    -1,   103,   104,    -1,    -1,    -1,    -1,    -1,
     110,   111,   112,    -1,    -1,   115,   116,     3,     4,     5,
       6,    -1,     8,    96,    97,    98,    99,   100,   101,    -1,
     103,   104,   105,   106,    -1,    -1,    -1,    -1,    24,    -1,
      26,    -1,    28,    29,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    37,    38,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    51,    52,    53,    54,    55,
      56,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    67,    -1,    -1,    -1,    -1,    72,    73,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    84,    -1,
      -1,    87,     3,     4,     5,     6,    -1,     8,    -1,    -1,
      96,    97,    -1,    -1,    -1,    -1,    -1,   103,   104,    -1,
      -1,    -1,    -1,    24,   110,    26,   112,    28,    29,   115,
     116,    -1,   118,    -1,    -1,    -1,    37,    38,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      51,    52,    53,    54,    55,    56,    57,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    67,    -1,    -1,    -1,
      -1,    72,    73,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    84,    -1,    -1,    87,     3,     4,     5,
       6,    -1,     8,    -1,    -1,    96,    97,    -1,    -1,    -1,
      -1,    -1,   103,   104,    -1,    -1,    -1,    -1,    24,   110,
      26,   112,    28,    29,   115,   116,    -1,    -1,    -1,    -1,
      -1,    37,    38,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    51,    52,    53,    54,    55,
      56,    57,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    67,    -1,    -1,    -1,    -1,    72,    73,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    84,    -1,
      -1,    87,     3,     4,     5,     6,    -1,     8,    -1,    -1,
      96,    97,    -1,    -1,    -1,    -1,    -1,   103,   104,    -1,
      -1,    -1,    -1,    24,   110,    26,   112,    28,    29,   115,
     116,    -1,    -1,    -1,    -1,    -1,    37,    38,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      51,    52,    53,    54,    55,    56,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    67,    -1,    -1,    -1,
      -1,    72,    73,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    84,    -1,    -1,    87,     3,     4,     5,
       6,    -1,     8,    -1,    -1,    96,    97,    -1,    -1,    -1,
      -1,    -1,   103,   104,    -1,    -1,    -1,    -1,    24,   110,
      26,   112,    28,    29,   115,   116,    -1,    -1,    -1,    -1,
      -1,    37,    38,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    51,    52,    53,    54,    55,
      56,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    67,    -1,    -1,    -1,    -1,    72,    73,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    84,    -1,
      -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      96,    97,    -1,    -1,    -1,    -1,    -1,   103,   104,    -1,
      -1,    -1,    -1,    -1,   110,    -1,   112,    -1,    -1,   115,
     116,    85,    86,    -1,    88,    89,    90,    91,    92,    93,
      94,    95,    96,    97,    98,    99,   100,   101,    -1,   103,
     104,   105,   106,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    85,    86,   119,    88,    89,    90,    91,
      92,    93,    94,    95,    96,    97,    98,    99,   100,   101,
      -1,   103,   104,   105,   106,    -1,    -1,    -1,    -1,    85,
      86,   113,    88,    89,    90,    91,    92,    93,    94,    95,
      96,    97,    98,    99,   100,   101,    -1,   103,   104,   105,
     106,    -1,    -1,    -1,    -1,    85,    86,   113,    88,    89,
      90,    91,    92,    93,    94,    95,    96,    97,    98,    99,
     100,   101,    -1,   103,   104,   105,   106,    -1,    -1,    -1,
      -1,    85,    86,   113,    88,    89,    90,    91,    92,    93,
      94,    95,    96,    97,    98,    99,   100,   101,    -1,   103,
     104,   105,   106,    -1,    -1,    -1,    -1,    85,    86,   113,
      88,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,    -1,   103,   104,   105,   106,    -1,
      -1,    85,    86,   111,    88,    89,    90,    91,    92,    93,
      94,    95,    96,    97,    98,    99,   100,   101,    -1,   103,
     104,   105,   106,    -1,    -1,    85,    86,   111,    88,    89,
      90,    91,    92,    93,    94,    95,    96,    97,    98,    99,
     100,   101,    -1,   103,   104,   105,   106,    -1,    -1,    85,
      86,   111,    88,    89,    90,    91,    92,    93,    94,    95,
      96,    97,    98,    99,   100,   101,    -1,   103,   104,   105,
     106,    -1,    -1,    85,    86,   111,    88,    89,    90,    91,
      92,    93,    94,    95,    96,    97,    98,    99,   100,   101,
      -1,   103,   104,   105,   106,    -1,    -1,    85,    86,   111,
      88,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,    -1,   103,   104,   105,   106,    86,
      -1,    88,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,    -1,   103,   104,   105,   106,
      88,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,    -1,   103,   104,   105,   106
};
/* -*-C-*-  Note some compilers choke on comments on `#line' lines.  */
#line 3 "/usr/share/bison/bison.simple"

/* Skeleton output parser for bison,

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002 Free Software
   Foundation, Inc.

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

/* This is the parser code that is written into each bison parser when
   the %semantic_parser declaration is not specified in the grammar.
   It was written by Richard Stallman by simplifying the hairy parser
   used when %semantic_parser is specified.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

#if ! defined (yyoverflow) || defined (YYERROR_VERBOSE)

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# if YYSTACK_USE_ALLOCA
#  define YYSTACK_ALLOC alloca
# else
#  ifndef YYSTACK_USE_ALLOCA
#   if defined (alloca) || defined (_ALLOCA_H)
#    define YYSTACK_ALLOC alloca
#   else
#    ifdef __GNUC__
#     define YYSTACK_ALLOC __builtin_alloca
#    endif
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
#  define YYSTACK_ALLOC malloc
#  define YYSTACK_FREE free
# endif
#endif /* ! defined (yyoverflow) || defined (YYERROR_VERBOSE) */


#if (! defined (yyoverflow) \
     && (! defined (__cplusplus) \
	 || (YYLTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  short yyss;
  YYSTYPE yyvs;
# if YYLSP_NEEDED
  YYLTYPE yyls;
# endif
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAX (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# if YYLSP_NEEDED
#  define YYSTACK_BYTES(N) \
     ((N) * (sizeof (short) + sizeof (YYSTYPE) + sizeof (YYLTYPE))	\
      + 2 * YYSTACK_GAP_MAX)
# else
#  define YYSTACK_BYTES(N) \
     ((N) * (sizeof (short) + sizeof (YYSTYPE))				\
      + YYSTACK_GAP_MAX)
# endif

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if 1 < __GNUC__
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
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAX;	\
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (0)

#endif


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
#define YYEMPTY		-2
#define YYEOF		0
#define YYACCEPT	goto yyacceptlab
#define YYABORT 	goto yyabortlab
#define YYERROR		goto yyerrlab1
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
      yychar1 = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { 								\
      yyerror ("syntax error: cannot back up");			\
      YYERROR;							\
    }								\
while (0)

#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Compute the default location (before the actions
   are run).

   When YYLLOC_DEFAULT is run, CURRENT is set the location of the
   first token.  By default, to implement support for ranges, extend
   its range to the last symbol.  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)       	\
   Current.last_line   = Rhs[N].last_line;	\
   Current.last_column = Rhs[N].last_column;
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#if YYPURE
# if YYLSP_NEEDED
#  ifdef YYLEX_PARAM
#   define YYLEX		yylex (&yylval, &yylloc, YYLEX_PARAM)
#  else
#   define YYLEX		yylex (&yylval, &yylloc)
#  endif
# else /* !YYLSP_NEEDED */
#  ifdef YYLEX_PARAM
#   define YYLEX		yylex (&yylval, YYLEX_PARAM)
#  else
#   define YYLEX		yylex (&yylval)
#  endif
# endif /* !YYLSP_NEEDED */
#else /* !YYPURE */
# define YYLEX			yylex ()
#endif /* !YYPURE */


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
/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
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

#if YYMAXDEPTH == 0
# undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif

#ifdef YYERROR_VERBOSE

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
#endif

#line 315 "/usr/share/bison/bison.simple"


/* The user can define YYPARSE_PARAM as the name of an argument to be passed
   into yyparse.  The argument should have type void *.
   It should actually point to an object.
   Grammar actions can access the variable by casting it
   to the proper pointer type.  */

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
#  define YYPARSE_PARAM_ARG void *YYPARSE_PARAM
#  define YYPARSE_PARAM_DECL
# else
#  define YYPARSE_PARAM_ARG YYPARSE_PARAM
#  define YYPARSE_PARAM_DECL void *YYPARSE_PARAM;
# endif
#else /* !YYPARSE_PARAM */
# define YYPARSE_PARAM_ARG
# define YYPARSE_PARAM_DECL
#endif /* !YYPARSE_PARAM */

/* Prevent warning if -Wstrict-prototypes.  */
#ifdef __GNUC__
# ifdef YYPARSE_PARAM
int yyparse (void *);
# else
int yyparse (void);
# endif
#endif

/* YY_DECL_VARIABLES -- depending whether we use a pure parser,
   variables are global, or local to YYPARSE.  */

#define YY_DECL_NON_LSP_VARIABLES			\
/* The lookahead symbol.  */				\
int yychar;						\
							\
/* The semantic value of the lookahead symbol. */	\
YYSTYPE yylval;						\
							\
/* Number of parse errors so far.  */			\
int yynerrs;

#if YYLSP_NEEDED
# define YY_DECL_VARIABLES			\
YY_DECL_NON_LSP_VARIABLES			\
						\
/* Location data for the lookahead symbol.  */	\
YYLTYPE yylloc;
#else
# define YY_DECL_VARIABLES			\
YY_DECL_NON_LSP_VARIABLES
#endif


/* If nonreentrant, generate the variables here. */

#if !YYPURE
YY_DECL_VARIABLES
#endif  /* !YYPURE */

int
yyparse (YYPARSE_PARAM_ARG)
     YYPARSE_PARAM_DECL
{
  /* If reentrant, generate the variables here. */
#if YYPURE
  YY_DECL_VARIABLES
#endif  /* !YYPURE */

  register int yystate;
  register int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Lookahead token as an internal (translated) token number.  */
  int yychar1 = 0;

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack. */
  short	yyssa[YYINITDEPTH];
  short *yyss = yyssa;
  register short *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  register YYSTYPE *yyvsp;

#if YYLSP_NEEDED
  /* The location stack.  */
  YYLTYPE yylsa[YYINITDEPTH];
  YYLTYPE *yyls = yylsa;
  YYLTYPE *yylsp;
#endif

#if YYLSP_NEEDED
# define YYPOPSTACK   (yyvsp--, yyssp--, yylsp--)
#else
# define YYPOPSTACK   (yyvsp--, yyssp--)
#endif

  YYSIZE_T yystacksize = YYINITDEPTH;


  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
#if YYLSP_NEEDED
  YYLTYPE yyloc;
#endif

  /* When reducing, the number of symbols on the RHS of the reduced
     rule. */
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
#if YYLSP_NEEDED
  yylsp = yyls;
#endif
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

  if (yyssp >= yyss + yystacksize - 1)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack. Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	short *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  */
# if YYLSP_NEEDED
	YYLTYPE *yyls1 = yyls;
	/* This used to be a conditional around just the two extra args,
	   but that might be undefined if yyoverflow is a macro.  */
	yyoverflow ("parser stack overflow",
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yyls1, yysize * sizeof (*yylsp),
		    &yystacksize);
	yyls = yyls1;
# else
	yyoverflow ("parser stack overflow",
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);
# endif
	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyoverflowlab;
# else
      /* Extend the stack our own way.  */
      if (yystacksize >= YYMAXDEPTH)
	goto yyoverflowlab;
      yystacksize *= 2;
      if (yystacksize > YYMAXDEPTH)
	yystacksize = YYMAXDEPTH;

      {
	short *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyoverflowlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);
# if YYLSP_NEEDED
	YYSTACK_RELOCATE (yyls);
# endif
# undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
#if YYLSP_NEEDED
      yylsp = yyls + yysize - 1;
#endif

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyssp >= yyss + yystacksize - 1)
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
  if (yyn == YYFLAG)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* yychar is either YYEMPTY or YYEOF
     or a valid token in external form.  */

  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  /* Convert token to internal form (in yychar1) for indexing tables with */

  if (yychar <= 0)		/* This means end of input. */
    {
      yychar1 = 0;
      yychar = YYEOF;		/* Don't call YYLEX any more */

      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yychar1 = YYTRANSLATE (yychar);

#if YYDEBUG
     /* We have to keep this `#if YYDEBUG', since we use variables
	which are defined only if `YYDEBUG' is set.  */
      if (yydebug)
	{
	  YYFPRINTF (stderr, "Next token is %d (%s",
		     yychar, yytname[yychar1]);
	  /* Give the individual parser a way to print the precise
	     meaning of a token, for further debugging info.  */
# ifdef YYPRINT
	  YYPRINT (stderr, yychar, yylval);
# endif
	  YYFPRINTF (stderr, ")\n");
	}
#endif
    }

  yyn += yychar1;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != yychar1)
    goto yydefault;

  yyn = yytable[yyn];

  /* yyn is what to do for this token type in this state.
     Negative => reduce, -yyn is rule number.
     Positive => shift, yyn is new state.
       New state is final state => don't bother to shift,
       just return success.
     0, or most negative number => error.  */

  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrlab;

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */
  YYDPRINTF ((stderr, "Shifting token %d (%s), ",
	      yychar, yytname[yychar1]));

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;
#if YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

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

     Otherwise, the following line sets YYVAL to the semantic value of
     the lookahead token.  This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

#if YYLSP_NEEDED
  /* Similarly for the default location.  Let the user run additional
     commands if for instance locations are ranges.  */
  yyloc = yylsp[1-yylen];
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
#endif

#if YYDEBUG
  /* We have to keep this `#if YYDEBUG', since we use variables which
     are defined only if `YYDEBUG' is set.  */
  if (yydebug)
    {
      int yyi;

      YYFPRINTF (stderr, "Reducing via rule %d (line %d), ",
		 yyn, yyrline[yyn]);

      /* Print the symbols being reduced, and their result.  */
      for (yyi = yyprhs[yyn]; yyrhs[yyi] > 0; yyi++)
	YYFPRINTF (stderr, "%s ", yytname[yyrhs[yyi]]);
      YYFPRINTF (stderr, " -> %s\n", yytname[yyr1[yyn]]);
    }
#endif

  switch (yyn) {

case 1:
#line 461 "clic.y"
{ ;
    break;}
case 2:
#line 485 "clic.y"
{
			if (yyvsp[-1].node)
			{
				if ( yyvsp[-1].node->isExec )
					curFunction->lastExec=1;
				append_Node( curFunction->body, yyvsp[-1].node);
			}
		;
    break;}
case 3:
#line 494 "clic.y"
{
			if (curFunction==curFile->main)
				append_Node(curFile->ctext, new_LangNode(yyvsp[0].string));
			else
				append_Node(curFunction->body, new_LangNode(yyvsp[0].string));
		;
    break;}
case 4:
#line 501 "clic.y"
{
			append_Node(curFile->ctextStatic, new_LangNode(yyvsp[0].string));
		;
    break;}
case 5:
#line 505 "clic.y"
{yyval.i=1; lex_vardef(1);;
    break;}
case 6:
#line 506 "clic.y"
{yyval.i=0; lex_vardef(1);;
    break;}
case 7:
#line 509 "clic.y"
{yyval.i=1;lex_vardef(1);;
    break;}
case 8:
#line 510 "clic.y"
{yyval.i=0;lex_vardef(1);;
    break;}
case 9:
#line 511 "clic.y"
{yyval.i=2;lex_vardef(1);;
    break;}
case 10:
#line 512 "clic.y"
{yyval.i=3;lex_vardef(1);;
    break;}
case 11:
#line 515 "clic.y"
{yyval.varcoll=new_VarColl();;
    break;}
case 12:
#line 516 "clic.y"
{ yyval.varcoll=yyvsp[-1].varcoll;;
    break;}
case 13:
#line 519 "clic.y"
{ yyval.node=new_OperListNode(); push_operlist(yyval.node); ;
    break;}
case 14:
#line 521 "clic.y"
{
			yyval.node=yyvsp[-2].node;
			if (yyvsp[-1].node)
			{
				if ( yyvsp[-1].node->isExec )
					curFunction->lastExec=1;
				append_Node( yyval.node, yyvsp[-1].node);
			}
		;
    break;}
case 15:
#line 532 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 16:
#line 534 "clic.y"
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
		;
    break;}
case 17:
#line 548 "clic.y"
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
		;
    break;}
case 18:
#line 561 "clic.y"
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
		;
    break;}
case 19:
#line 582 "clic.y"
{
			lex_vardef(1);
			def_node=new_LocalDefNode1;
		;
    break;}
case 20:
#line 587 "clic.y"
{
		  	/*$$=new_LocalDefNode($3, 1);*/
                        yyval.node=NULL;
		 	lex_vardef(0); CM;
		 	def_node=0;
		;
    break;}
case 21:
#line 594 "clic.y"
{
			lex_vardef(1);
                        def_node = new_StaticDefNode;
		;
    break;}
case 22:
#line 599 "clic.y"
{
			/*$$=new_StaticDefNode($3);*/
                        yyval.node=NULL;
			lex_vardef(0);
		 	def_node=0;
		;
    break;}
case 23:
#line 606 "clic.y"
{
                        def_node = new_PublicDefNode;
		;
    break;}
case 24:
#line 610 "clic.y"
{
			/*$$=new_PublicDefNode($2);*/
			yyval.node=NULL;
			CM;
		 	def_node=0;
		;
    break;}
case 25:
#line 617 "clic.y"
{
                        def_node = new_PrivateDefNode;
		;
    break;}
case 26:
#line 621 "clic.y"
{
	 		/*$$=new_PrivateDefNode($2);*/
	 		yyval.node=NULL;
	 		CM;
		 	def_node=0;
	 	;
    break;}
case 27:
#line 628 "clic.y"
{
                        def_node = new_PrivateDefNode;
		;
    break;}
case 28:
#line 632 "clic.y"
{
	 		/*$$=new_PrivateDefNode($2);*/
	 		yyval.node=NULL;
	 		CM;
		 	def_node=0;
	 	;
    break;}
case 29:
#line 649 "clic.y"
{ yyval.node=new_MemvarDefNode(yyvsp[0].varcoll); ;
    break;}
case 30:
#line 650 "clic.y"
{ yyval.node=new_FieldDefNode(yyvsp[-1].varcoll, yyvsp[0].string); ;
    break;}
case 31:
#line 651 "clic.y"
{ yyval.node=new_ParametersDefNode(yyvsp[0].varcoll); CM;;
    break;}
case 32:
#line 652 "clic.y"
{ yyval.node=new_ReturnNode(NULL,0); CM;;
    break;}
case 33:
#line 653 "clic.y"
{ yyval.node=new_ReturnNode(yyvsp[0].node,0); CM;;
    break;}
case 34:
#line 656 "clic.y"
{
				Coll *cp = yyvsp[0].coll;
				int i;

				yyval.node=NULL;
				for(i=0; i< cp->count; ++i)
					append_Coll(&curFile->externModules, cp->items[i]);

				removeAll_Coll(cp);
				delete_Coll(cp);
			;
    break;}
case 35:
#line 667 "clic.y"
{
				char *s = yyvsp[0].string;

				yyval.node=NULL;
				free(curFile->main->name);
				curFile->main->name = s;
				for(; *s; ++s)
					*s = toupper(*s);
			;
    break;}
case 36:
#line 677 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 37:
#line 678 "clic.y"
{ yyval.node=new_OperExprNode(yyvsp[0].node); CM;;
    break;}
case 38:
#line 680 "clic.y"
{ CM;yyval.node=new_OperExprNode(new_AssignNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;
    break;}
case 39:
#line 681 "clic.y"
{ CM;yyval.node=new_OperExprNode(new_AssignNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;
    break;}
case 40:
#line 682 "clic.y"
{ CM;yyval.node=new_OperExprNode(new_ArrElNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;
    break;}
case 41:
#line 683 "clic.y"
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
        		;
    break;}
case 42:
#line 697 "clic.y"
{ yyval.node=new_OperExprNode(new_AssignNode(new_MacroNode(yyvsp[-3].node,0),yyvsp[0].node,'=')); ;
    break;}
case 43:
#line 700 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 44:
#line 701 "clic.y"
{ CM; yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 45:
#line 702 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 46:
#line 703 "clic.y"
{CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,NULL,yyvsp[-2].string,0,yyvsp[0].node));;
    break;}
case 47:
#line 704 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 48:
#line 706 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 49:
#line 707 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,0, yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 50:
#line 708 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-7].node,0,yyvsp[-3].node,yyvsp[0].node)); ;
    break;}
case 51:
#line 709 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 52:
#line 710 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,0, yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 53:
#line 711 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-7].node,0,yyvsp[-3].node,yyvsp[0].node)); ;
    break;}
case 54:
#line 713 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 55:
#line 714 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 56:
#line 715 "clic.y"
{CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,NULL,0,yyvsp[-2].node,yyvsp[0].node));;
    break;}
case 57:
#line 716 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 58:
#line 717 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 59:
#line 719 "clic.y"
{ CM;
			if (!curFunction->inLoop)
				{ loop_line = cl_line; loop_file = currentFile(); }
			curFunction->inLoop++;
		;
    break;}
case 60:
#line 725 "clic.y"
{
			curFunction->inLoop--;
			yyval.node=new_WhileNode(yyvsp[-3].node,yyvsp[-1].node);
			pop_operlist();
		;
    break;}
case 61:
#line 731 "clic.y"
{ CM; yyval.node = new_OperExprNode(new_CallNode(yyvsp[-1].string, yyvsp[0].arglist.coll, yyvsp[0].arglist.haveRest)); ;
    break;}
case 62:
#line 733 "clic.y"
{ CM; yyval.node = new_OperExprNode(new_CallNameNode(yyvsp[-1].node, yyvsp[0].arglist.coll)); ;
    break;}
case 63:
#line 735 "clic.y"
{ CM; yyval.node = new_OperExprNode(new_CallNode(yyvsp[-1].string, yyvsp[0].arglist.coll, yyvsp[0].arglist.haveRest)); ;
    break;}
case 64:
#line 737 "clic.y"
{ CM; yyval.node = new_OperExprNode(new_CallNameNode(yyvsp[-1].node, yyvsp[0].arglist.coll)); ;
    break;}
case 65:
#line 739 "clic.y"
{
			CM;
			if (!curFunction->inLoop)
				yyerror("EXIT statement out of loop");
			yyval.node=new_LoopExitNode(0);
		;
    break;}
case 66:
#line 746 "clic.y"
{
			CM;
			if (!curFunction->inLoop)
				yyerror("LOOP statement out of loop");
			yyval.node=new_LoopExitNode(1);
		;
    break;}
case 67:
#line 753 "clic.y"
{ lex_initial(); ;
    break;}
case 68:
#line 754 "clic.y"
{
			curFunction->inLoop--;
			yyval.node=new_ForNode(yyvsp[-9].node,yyvsp[-7].node,yyvsp[-5].node,yyvsp[-4].node,yyvsp[-1].node);
			pop_operlist();
		;
    break;}
case 69:
#line 760 "clic.y"
{ lex_initial(); ;
    break;}
case 70:
#line 761 "clic.y"
{
			curFunction->inLoop--;
			yyval.node=new_ForeachNode(yyvsp[-7].node,yyvsp[-5].node,yyvsp[-1].node,yyvsp[-4].i);
			pop_operlist();
		;
    break;}
case 71:
#line 767 "clic.y"
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
		;
    break;}
case 72:
#line 780 "clic.y"
{
			pop_operlist();
		;
    break;}
case 73:
#line 784 "clic.y"
{
			CM;
			yyval.node=new_SeqNode(yyvsp[-3].node,yyvsp[-1].recover.using,yyvsp[-1].recover.operlist,yyvsp[-1].recover.curseq);
		;
    break;}
case 74:
#line 790 "clic.y"
{  CM; yyval.node=new_BreakNode(yyvsp[0].node, 1); ;
    break;}
case 75:
#line 793 "clic.y"
{
			Coll *cp=new_Coll(NULL,NULL);
			append_Coll(cp,yyvsp[-5].node);
			append_Coll(cp,yyvsp[-3].node);
			yyval.node=new_OperExprNode(new_IfNode(cp,yyvsp[-1].node));
			CM;
		;
    break;}
case 76:
#line 802 "clic.y"
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
		;
    break;}
case 77:
#line 816 "clic.y"
{
			CM;
			prepend_Coll(yyvsp[-2].coll,yyvsp[-3].node);
			prepend_Coll(yyvsp[-2].coll,yyvsp[-6].node);
			yyval.node=new_IfNode( yyvsp[-2].coll, yyvsp[-1].node);
			if_depth--;
			pop_operlist();
		;
    break;}
case 78:
#line 826 "clic.y"
{
			CM;
			yyval.node=new_IfNode( yyvsp[-2].coll, yyvsp[-1].node);
		;
    break;}
case 79:
#line 832 "clic.y"
{
			yyval.node=new_SwitchNode(yyvsp[-4].node, yyvsp[-2].coll, yyvsp[-1].node);
		;
    break;}
case 80:
#line 837 "clic.y"
{ yyval.string=0; ;
    break;}
case 81:
#line 838 "clic.y"
{ yyval.string=yyvsp[0].string; ;
    break;}
case 82:
#line 839 "clic.y"
{ yyval.string=yyvsp[0].string; ;
    break;}
case 84:
#line 844 "clic.y"
{
			SwitchEl *nl = NEW(SwitchEl);
			nl->labels = yyvsp[-2].coll;
			nl->operlist = yyvsp[0].node;
			insert_Coll(yyvsp[-3].coll, nl);
			yyval.coll = yyvsp[-3].coll;
			pop_operlist();
		;
    break;}
case 85:
#line 854 "clic.y"
{
			yyval.coll = new_Coll(0, 0);
		;
    break;}
case 87:
#line 861 "clic.y"
{
			yyval.coll = new_Coll(0,0);
			append_Coll(yyval.coll, yyvsp[0].node);
		;
    break;}
case 88:
#line 866 "clic.y"
{
			yyval.coll = yyvsp[-2].coll;
			append_Coll(yyval.coll, yyvsp[0].node);
		;
    break;}
case 89:
#line 873 "clic.y"
{  CM;
			if (!curFunction->inLoop)
				{ loop_line = cl_line; loop_file = currentFile(); }
			curFunction->inLoop++;
		;
    break;}
case 92:
#line 884 "clic.y"
{ yyval.i = 0; ;
    break;}
case 93:
#line 885 "clic.y"
{ yyval.i = 1; ;
    break;}
case 94:
#line 888 "clic.y"
{;
    break;}
case 95:
#line 889 "clic.y"
{;
    break;}
case 96:
#line 892 "clic.y"
{
			yyval.recover.curseq = curFunction->seqNo;
			yyval.recover.operlist = 0;
			yyval.recover.using = 0;
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
		;
    break;}
case 97:
#line 900 "clic.y"
{
			yyerror("unclosed BEGIN SEQUENCE");
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
			YYERROR;
		;
    break;}
case 98:
#line 907 "clic.y"
{
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
		;
    break;}
case 99:
#line 912 "clic.y"
{
			yyval.recover.operlist = yyvsp[0].node;
			yyval.recover.using = yyvsp[-3].node;
			yyval.recover.curseq = yyvsp[-4].i;
			pop_operlist();
		;
    break;}
case 100:
#line 920 "clic.y"
{yyval.i = curFunction->seqNo; ;
    break;}
case 101:
#line 923 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 102:
#line 924 "clic.y"
{ yyval.node=yyvsp[0].node; ;
    break;}
case 103:
#line 927 "clic.y"
{ yyval.node=new_NumberConstNode(strdup("1"),0); ;
    break;}
case 104:
#line 928 "clic.y"
{ yyval.node=yyvsp[0].node; ;
    break;}
case 109:
#line 939 "clic.y"
{ yyval.coll=new_Coll(NULL,NULL); ;
    break;}
case 110:
#line 941 "clic.y"
{
			yyval.coll=yyvsp[-4].coll;
			append_Coll(yyval.coll, yyvsp[-2].node);
			append_Coll(yyval.coll, yyvsp[0].node);
			pop_operlist();
		;
    break;}
case 111:
#line 949 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 112:
#line 951 "clic.y"
{
			yyval.node=yyvsp[0].node;
			pop_operlist();
		;
    break;}
case 115:
#line 961 "clic.y"
{ yyval.coll=new_Coll(NULL,NULL); ;
    break;}
case 118:
#line 967 "clic.y"
{
			yyval.coll=yyvsp[-4].coll;
			append_Coll(yyval.coll, yyvsp[-2].node);
			append_Coll(yyval.coll, yyvsp[0].node);
			pop_operlist();
		;
    break;}
case 119:
#line 975 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 120:
#line 977 "clic.y"
{
			yyval.node=yyvsp[0].node;
			pop_operlist();
		;
    break;}
case 125:
#line 991 "clic.y"
{ yyval.string=NULL; ;
    break;}
case 126:
#line 992 "clic.y"
{ yyval.string=yyvsp[0].string; ;
    break;}
case 127:
#line 995 "clic.y"
{ yyval.node=installName(yyvsp[0].string); ;
    break;}
case 128:
#line 996 "clic.y"
{ yyval.node=new_MemvarNode(new_Var(yyvsp[0].string)); ;
    break;}
case 129:
#line 999 "clic.y"
{ yyval.node=yyvsp[0].node; ;
    break;}
case 130:
#line 1002 "clic.y"
{ yyval.node=installName(yyvsp[0].string); ;
    break;}
case 131:
#line 1003 "clic.y"
{ yyval.node=new_MemvarNode(new_Var(yyvsp[0].string)); ;
    break;}
case 132:
#line 1004 "clic.y"
{ yyval.node=new2_FieldNode(NULL,NULL,yyvsp[0].string,NULL); ;
    break;}
case 133:
#line 1007 "clic.y"
{ yyval.node=new_MacroNode(yyvsp[0].node,0); ;
    break;}
case 134:
#line 1008 "clic.y"
{ yyval.node=new_MacroNode(yyvsp[-1].node,0); ;
    break;}
case 135:
#line 1009 "clic.y"
{ yyval.node=new_MacroNode(new_OpNode(new_StringConstNode(yyvsp[-2].string),yyvsp[0].node,'+'),0);  ;
    break;}
case 136:
#line 1010 "clic.y"
{ yyval.node=new_MacroNode(new_OpNode(yyvsp[-2].node,new_StringConstNode(yyvsp[0].string),'+'),0); ;
    break;}
case 137:
#line 1011 "clic.y"
{ char *s = yyvsp[0].string+strspn(yyvsp[0].string,",.-+");
			yyval.node=new_MacroNode(new_OpNode(yyvsp[-1].node,new_StringConstNode(s),'+'),0); ;
    break;}
case 138:
#line 1013 "clic.y"
{ yyval.node=new_MacroNode(yyvsp[-1].node,1); ;
    break;}
case 140:
#line 1017 "clic.y"
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
			;
    break;}
case 141:
#line 1039 "clic.y"
{
        			Coll *cp = new_Coll(0,0);
                                append_Coll(cp, new_StringConstNode(yyvsp[0].string));
				yyval.node=new_CallNode(strdup("CTOD"), cp, 0);
			;
    break;}
case 144:
#line 1046 "clic.y"
{
		/*((ExprListNode*)$2)->last=1; ; */
                yyval.node=reduce_ExprListNode(yyvsp[-1].node);
		;
    break;}
case 145:
#line 1050 "clic.y"
{ yyval.node=new_RefNode(yyvsp[0].node); ;
    break;}
case 146:
#line 1052 "clic.y"
{ yyval.node=new_CallNode( yyvsp[-3].string, yyvsp[-1].arglist.coll, yyvsp[-1].arglist.haveRest); ;
    break;}
case 147:
#line 1053 "clic.y"
{ yyval.node=new_CallNameNode(yyvsp[-3].node,yyvsp[-1].arglist.coll); ;
    break;}
case 148:
#line 1055 "clic.y"
{ yyval.node=new_ArrElNode(yyvsp[0].node,NULL,0); ;
    break;}
case 149:
#line 1056 "clic.y"
{ yyval.node=new_AssignNode(yyvsp[-2].node,yyvsp[0].node,yyvsp[-1].i); ;
    break;}
case 150:
#line 1057 "clic.y"
{ yyval.node=new_ArrElNode(yyvsp[-2].node,yyvsp[0].node,yyvsp[-1].i); ;
    break;}
case 151:
#line 1058 "clic.y"
{ yyval.node=new_AssignNode(yyvsp[-2].node,yyvsp[0].node,yyvsp[-1].i); ;
    break;}
case 152:
#line 1060 "clic.y"
{ yyval.node=new_MethodNode(yyvsp[-5].node,yyvsp[-3].string,yyvsp[-1].arglist.coll, yyvsp[-1].arglist.haveRest); ;
    break;}
case 153:
#line 1062 "clic.y"
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
		;
    break;}
case 154:
#line 1076 "clic.y"
{
		add_self();
		yyval.node=new_MethodNode(installName(strdup("__SELF__")),yyvsp[-3].string,yyvsp[-1].arglist.coll, yyvsp[-1].arglist.haveRest);
		;
    break;}
case 155:
#line 1080 "clic.y"
{yyval.node=new2_FieldNode(NULL,NULL,yyvsp[0].string,NULL);;
    break;}
case 156:
#line 1081 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,yyvsp[0].string,NULL); ;
    break;}
case 157:
#line 1082 "clic.y"
{ yyval.node=new2_FieldNode(NULL,NULL,NULL,yyvsp[0].node); ;
    break;}
case 158:
#line 1084 "clic.y"
{ yyval.node=yyvsp[-1].node; ;
    break;}
case 159:
#line 1087 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,yyvsp[0].string,NULL); ;
    break;}
case 160:
#line 1088 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,NULL,yyvsp[0].node); ;
    break;}
case 161:
#line 1089 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-4].string,NULL,NULL,reduce_ExprListNode(yyvsp[-1].node)); ;
    break;}
case 162:
#line 1090 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-4].string,NULL,NULL,reduce_ExprListNode(yyvsp[-1].node)); ;
    break;}
case 163:
#line 1091 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,NULL,yyvsp[0].node); ;
    break;}
case 164:
#line 1093 "clic.y"
{yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-5].node),NULL,reduce_ExprListNode(yyvsp[-1].node));;
    break;}
case 165:
#line 1094 "clic.y"
{ yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),NULL,yyvsp[0].node); ;
    break;}
case 166:
#line 1095 "clic.y"
{ yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].string,NULL); ;
    break;}
case 167:
#line 1096 "clic.y"
{yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-5].node),NULL,reduce_ExprListNode(yyvsp[-1].node));;
    break;}
case 168:
#line 1097 "clic.y"
{ yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),NULL,yyvsp[0].node); ;
    break;}
case 169:
#line 1098 "clic.y"
{ yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].string,NULL); ;
    break;}
case 170:
#line 1100 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,yyvsp[0].string,NULL);;
    break;}
case 171:
#line 1102 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,yyvsp[0].string,NULL);;
    break;}
case 172:
#line 1103 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-4].node,NULL,reduce_ExprListNode(yyvsp[-1].node));;
    break;}
case 173:
#line 1104 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-4].node,NULL,reduce_ExprListNode(yyvsp[-1].node));;
    break;}
case 174:
#line 1105 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,NULL,yyvsp[0].node);;
    break;}
case 175:
#line 1106 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,NULL,yyvsp[0].node);;
    break;}
case 176:
#line 1108 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 177:
#line 1109 "clic.y"
{ CM; yyval.node=(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 178:
#line 1110 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 179:
#line 1111 "clic.y"
{CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,NULL,yyvsp[-2].string,0,yyvsp[0].node));;
    break;}
case 180:
#line 1112 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 181:
#line 1114 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 182:
#line 1115 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),0, yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 183:
#line 1116 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-7].node),0,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].node)); ;
    break;}
case 184:
#line 1117 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 185:
#line 1118 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),0, yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 186:
#line 1119 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-7].node),0,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].node)); ;
    break;}
case 187:
#line 1121 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 188:
#line 1122 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 189:
#line 1123 "clic.y"
{CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,NULL,0,yyvsp[-2].node,yyvsp[0].node));;
    break;}
case 190:
#line 1124 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 191:
#line 1125 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 192:
#line 1127 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'e');  ;
    break;}
case 193:
#line 1128 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'E');  ;
    break;}
case 194:
#line 1129 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'N');  ;
    break;}
case 195:
#line 1130 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'<');  ;
    break;}
case 196:
#line 1131 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'>');  ;
    break;}
case 197:
#line 1132 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'L');  ;
    break;}
case 198:
#line 1133 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'G');  ;
    break;}
case 199:
#line 1134 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'+');  ;
    break;}
case 200:
#line 1135 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'$');  ;
    break;}
case 201:
#line 1137 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'-');  ;
    break;}
case 202:
#line 1138 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'*');  ;
    break;}
case 203:
#line 1139 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'/');  ;
    break;}
case 204:
#line 1140 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'%');  ;
    break;}
case 205:
#line 1141 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'^');  ;
    break;}
case 206:
#line 1142 "clic.y"
{ yyval.node=new_AndNode(yyvsp[-2].node,yyvsp[0].node);  ;
    break;}
case 207:
#line 1143 "clic.y"
{ yyval.node=new_OrNode(yyvsp[-2].node,yyvsp[0].node);  ;
    break;}
case 208:
#line 1145 "clic.y"
{ yyval.node=new_NotNode(yyvsp[0].node);  ;
    break;}
case 209:
#line 1147 "clic.y"
{ yyval.node=new_IncrNode(yyvsp[0].node,1,0); ;
    break;}
case 210:
#line 1148 "clic.y"
{ yyval.node=new_IncrNode(yyvsp[-1].node,1,1); ;
    break;}
case 211:
#line 1149 "clic.y"
{ yyval.node=new_IncrNode(yyvsp[0].node,0,0); ;
    break;}
case 212:
#line 1150 "clic.y"
{ yyval.node=new_IncrNode(yyvsp[-1].node,0,1); ;
    break;}
case 213:
#line 1151 "clic.y"
{ yyval.node=new_MinusNode(yyvsp[0].node); ;
    break;}
case 214:
#line 1152 "clic.y"
{ yyval.node=yyvsp[0].node; ;
    break;}
case 215:
#line 1154 "clic.y"
{yyval.node=new_ArrayInitNode(yyvsp[-1].node); ;
    break;}
case 216:
#line 1155 "clic.y"
{yyval.node=new_ArrayInitNode(yyvsp[-1].node); ;
    break;}
case 217:
#line 1156 "clic.y"
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
		;
    break;}
case 218:
#line 1177 "clic.y"
{ yyval.node=new_PcountNode(); ;
    break;}
case 219:
#line 1178 "clic.y"
{ yyval.node=new_PshiftNode(); ;
    break;}
case 220:
#line 1179 "clic.y"
{ yyval.node=new_ParnNode(yyvsp[-1].node); ;
    break;}
case 221:
#line 1180 "clic.y"
{ yyval.node=new_ParnNode(yyvsp[-1].node); ;
    break;}
case 222:
#line 1182 "clic.y"
{  curFunction->code_params=yyvsp[0].varcoll; ;
    break;}
case 223:
#line 1183 "clic.y"
{ yyval.node=new_CodestrNode(yyvsp[-1].node,0,yyvsp[-3].varcoll); curFunction->code_params=0; ;
    break;}
case 224:
#line 1184 "clic.y"
{  curFunction->code_params=yyvsp[0].varcoll; ;
    break;}
case 225:
#line 1185 "clic.y"
{ yyval.node=new_MacroNode(new_CodestrNode(yyvsp[-1].node,1,yyvsp[-3].varcoll),0); curFunction->code_params=0; ;
    break;}
case 226:
#line 1188 "clic.y"
{
			if (curFunction->upfunc)
				curFunction = curFunction->upfunc;
		;
    break;}
case 227:
#line 1193 "clic.y"
{
			Node *np;
			curFunction = yyvsp[-3].func;
			np = new_LocalDefNode(yyvsp[-1].varcoll, 0);
			prepend_Node(curFunction->body, np);
			yyval.node = new_NilConstNode();
			CM;
		;
    break;}
case 228:
#line 1203 "clic.y"
{
			Coll *cp=new_Coll(NULL,NULL);
			append_Coll(cp,yyvsp[-5].node);
			append_Coll(cp,yyvsp[-3].node);
			yyval.node=new_IfNode(cp,yyvsp[-1].node);
		;
    break;}
case 229:
#line 1212 "clic.y"
{  yyval.node=new_BreakNode(yyvsp[-1].node,0); ;
    break;}
case 230:
#line 1216 "clic.y"
{ yyval.varcoll=0; ;
    break;}
case 231:
#line 1217 "clic.y"
{ yyval.varcoll=yyvsp[-1].varcoll; ;
    break;}
case 232:
#line 1220 "clic.y"
{ yyval.node=new_NilConstNode(); ;
    break;}
case 233:
#line 1221 "clic.y"
{ yyval.node=yyvsp[0].node; ;
    break;}
case 242:
#line 1238 "clic.y"
{ yyval.i='='; ;
    break;}
case 243:
#line 1239 "clic.y"
{ yyval.i='+'; ;
    break;}
case 244:
#line 1240 "clic.y"
{ yyval.i='-'; ;
    break;}
case 245:
#line 1241 "clic.y"
{ yyval.i='*'; ;
    break;}
case 246:
#line 1242 "clic.y"
{ yyval.i='/'; ;
    break;}
case 247:
#line 1243 "clic.y"
{ yyval.i='%'; ;
    break;}
case 248:
#line 1244 "clic.y"
{ yyval.i='^'; ;
    break;}
case 249:
#line 1247 "clic.y"
{ yyval.i='='; ;
    break;}
case 250:
#line 1251 "clic.y"
{ yyval.func=curFunction; ;
    break;}
case 251:
#line 1254 "clic.y"
{ yyval.node=new_CodeNode(yyvsp[-1].varcoll); ;
    break;}
case 252:
#line 1257 "clic.y"
{ yyval.node=yyvsp[-1].node; prepend_Node(yyvsp[-1].node,yyvsp[-3].node); ;
    break;}
case 253:
#line 1258 "clic.y"
{ yyval.node=yyvsp[-3].node; join_Node(yyvsp[-3].node,yyvsp[-1].node); ;
    break;}
case 254:
#line 1259 "clic.y"
{
		yyval.node=new_ExprListNode();
		append_Node(yyval.node, yyvsp[-2].node);
		upstr(yyvsp[0].string);
		append_Node(yyval.node, new_HashConstNode(yyvsp[0].string));
		;
    break;}
case 255:
#line 1265 "clic.y"
{
		yyval.node=new_ExprListNode();
		add_self();
		append_Node(yyval.node, installName(strdup("__SELF__")));
		upstr(yyvsp[0].string);
		append_Node(yyval.node, new_HashConstNode(yyvsp[0].string));
		;
    break;}
case 256:
#line 1272 "clic.y"
{
		yyval.node=yyvsp[-2].node;
		upstr(yyvsp[0].string);
		append_Node(yyval.node,new_HashConstNode(yyvsp[0].string));
	;
    break;}
case 257:
#line 1279 "clic.y"
{
			yyval.varcoll=new_VarColl();
                        yyvsp[-1].var->type = yyvsp[0].string;
			add_VarColl(yyval.varcoll, yyvsp[-1].var);
                        if (def_node)
				append_Node( curr_operlist, def_node(yyval.varcoll));

		;
    break;}
case 258:
#line 1288 "clic.y"
{
                	if (def_node)
				yyval.varcoll=new_VarColl();
                        else
				yyval.varcoll=yyvsp[-3].varcoll;
                        yyvsp[-1].var->type = yyvsp[0].string;
			add_VarColl(yyval.varcoll, yyvsp[-1].var);
                        if (def_node)
				append_Node( curr_operlist, def_node(yyval.varcoll));
		;
    break;}
case 259:
#line 1300 "clic.y"
{
			yyval.varcoll=new_VarColl();
			add_VarColl(yyval.varcoll, yyvsp[0].var);
		;
    break;}
case 260:
#line 1305 "clic.y"
{
			yyval.varcoll=yyvsp[-2].varcoll;
			add_VarColl(yyval.varcoll, yyvsp[0].var);
		;
    break;}
case 261:
#line 1311 "clic.y"
{ yyval.var=newArrInit_Var(yyvsp[-1].string,yyvsp[0].node); ;
    break;}
case 262:
#line 1312 "clic.y"
{ yyval.var=mnewArrInit_Var(yyvsp[-1].node,yyvsp[-1].node); ;
    break;}
case 263:
#line 1315 "clic.y"
{ yyval.node=yyvsp[-1].node; ;
    break;}
case 264:
#line 1316 "clic.y"
{ yyval.node=yyvsp[-3].node; join_Node(yyvsp[-3].node,yyvsp[-1].node); ;
    break;}
case 265:
#line 1319 "clic.y"
{ yyval.var=new_Var(yyvsp[0].string); ;
    break;}
case 266:
#line 1320 "clic.y"
{ yyval.var=newArrInit_Var(yyvsp[-1].string,yyvsp[0].node); ;
    break;}
case 267:
#line 1321 "clic.y"
{ yyval.var=newInit_Var(yyvsp[-2].string,yyvsp[0].node); ;
    break;}
case 268:
#line 1322 "clic.y"
{ yyerror("only inline assign := allowed in initialisation"); yyval.var=NULL; ;
    break;}
case 269:
#line 1324 "clic.y"
{ yyval.var=mnew_Var(yyvsp[0].node); ;
    break;}
case 270:
#line 1325 "clic.y"
{ yyval.var=mnewArrInit_Var(yyvsp[-1].node,yyvsp[-1].node); ;
    break;}
case 271:
#line 1326 "clic.y"
{ yyval.var=mnewInit_Var(yyvsp[-2].node,yyvsp[0].node);  ;
    break;}
case 272:
#line 1327 "clic.y"
{ yyerror("only inline assign := allowed in initialisation"); yyval.var=NULL; ;
    break;}
case 273:
#line 1330 "clic.y"
{ yyval.node=yyvsp[-1].node; ;
    break;}
case 274:
#line 1331 "clic.y"
{ yyval.node=yyvsp[-3].node; join_Node(yyvsp[-3].node,yyvsp[-1].node); ;
    break;}
case 275:
#line 1334 "clic.y"
{ yyval.varcoll=new_VarColl(); ;
    break;}
case 276:
#line 1335 "clic.y"
{
		Var *vp=new_Var(yyvsp[-1].string);
                vp->type = yyvsp[0].string;
		yyval.varcoll=new_VarColl();
		vp->no=0;
		insert_Coll( &yyval.varcoll->coll, vp);
		insert_Coll( &yyval.varcoll->unsorted, vp);
		;
    break;}
case 277:
#line 1343 "clic.y"
{
		Var *vp=new_Var(yyvsp[-1].string);
                vp->type = yyvsp[0].string;
		yyval.varcoll=yyvsp[-3].varcoll;
		vp->no = yyval.varcoll->unsorted.count;
		insert_Coll( &yyval.varcoll->coll, vp);
		insert_Coll( &yyval.varcoll->unsorted, vp);
		;
    break;}
case 278:
#line 1354 "clic.y"
{yyval.coll=new_Coll(free,strcmp);;
    break;}
case 279:
#line 1355 "clic.y"
{
			yyval.coll=new_Coll(free,strcmp);
			insert_Coll(yyval.coll, yyvsp[0].string);
		;
    break;}
case 280:
#line 1360 "clic.y"
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
		;
    break;}
case 281:
#line 1373 "clic.y"
{
			yyval.varcoll=new_VarColl();
			add_VarColl(yyval.varcoll, new_Var(yyvsp[0].string));
		;
    break;}
case 282:
#line 1378 "clic.y"
{
			yyval.varcoll=yyvsp[-2].varcoll;
			add_VarColl(yyval.varcoll, new_Var(yyvsp[0].string));
		;
    break;}
case 283:
#line 1384 "clic.y"
{ yyval.arglist.coll=yyvsp[0].coll; yyval.arglist.haveRest=0; ;
    break;}
case 284:
#line 1385 "clic.y"
{ yyval.arglist.coll=yyvsp[-2].coll; yyval.arglist.haveRest=1; ;
    break;}
case 285:
#line 1386 "clic.y"
{ yyval.arglist.coll=new_Coll(NULL,NULL); yyval.arglist.haveRest=1;  ;
    break;}
case 286:
#line 1389 "clic.y"
{ yyval.arglist.coll=new_Coll(NULL,NULL); yyval.arglist.haveRest=0; ;
    break;}
case 287:
#line 1390 "clic.y"
{
			Coll *cp;
			int i;
			Node *np;

			yyval.arglist=yyvsp[0].arglist;
			cp = yyval.arglist.coll;
			for(i=0; i<cp->count; i++)
			{
				np = (Node*) cp->items[i];
				if (np->isRef||np->isConst||(!np->isLval && !np->isField))
					continue;
				cp->items[i] = new_RefNode(np);
			}
		;
    break;}
case 288:
#line 1407 "clic.y"
{
			yyval.coll=new_Coll(NULL,NULL);
			if (yyvsp[0].node)
				insert_Coll(yyval.coll,yyvsp[0].node);
		;
    break;}
case 289:
#line 1412 "clic.y"
{
			yyval.coll=yyvsp[-2].coll;
			if (!yyval.coll->count)
				insert_Coll(yyval.coll,new_ArgNode(new_NilConstNode(),0));
			if (yyvsp[0].node)
				insert_Coll(yyval.coll,yyvsp[0].node);
			else
				insert_Coll(yyval.coll,new_ArgNode(new_NilConstNode(),0));
		;
    break;}
case 290:
#line 1423 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 291:
#line 1424 "clic.y"
{ yyval.node=yyvsp[0].node; /*$$=new_ArgNode($1,0);*/ ;
    break;}
case 292:
#line 1429 "clic.y"
{;
    break;}
case 293:
#line 1430 "clic.y"
{;
    break;}
case 294:
#line 1433 "clic.y"
{;
    break;}
case 295:
#line 1434 "clic.y"
{;
    break;}
case 296:
#line 1438 "clic.y"
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
				;
    break;}
case 297:
#line 1450 "clic.y"
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
				;
    break;}
case 298:
#line 1465 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 300:
#line 1469 "clic.y"
{ yyval.node=new_ExprListNode(); append_Node(yyval.node, yyvsp[0].node); ;
    break;}
case 301:
#line 1470 "clic.y"
{ yyval.node=yyvsp[-2].node; append_Node(yyval.node, yyvsp[0].node); ;
    break;}
case 302:
#line 1473 "clic.y"
{ yyval.node=new_StringConstNode(yyvsp[0].string); ;
    break;}
case 303:
#line 1474 "clic.y"
{ yyval.node=new_LogicConstNode(1); ;
    break;}
case 304:
#line 1475 "clic.y"
{ yyval.node=new_LogicConstNode(0); ;
    break;}
case 305:
#line 1476 "clic.y"
{ yyval.node=new_NilConstNode(); ;
    break;}
case 306:
#line 1477 "clic.y"
{ yyval.node=new_NumberConstNode(yyvsp[0].string,0); ;
    break;}
case 308:
#line 1481 "clic.y"
{ yyval.node=yyvsp[0].node; yyval.node->isMinus = 1; ;
    break;}
}

#line 705 "/usr/share/bison/bison.simple"


  yyvsp -= yylen;
  yyssp -= yylen;
#if YYLSP_NEEDED
  yylsp -= yylen;
#endif

#if YYDEBUG
  if (yydebug)
    {
      short *yyssp1 = yyss - 1;
      YYFPRINTF (stderr, "state stack now");
      while (yyssp1 != yyssp)
	YYFPRINTF (stderr, " %d", *++yyssp1);
      YYFPRINTF (stderr, "\n");
    }
#endif

  *++yyvsp = yyval;
#if YYLSP_NEEDED
  *++yylsp = yyloc;
#endif

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTBASE] + *yyssp;
  if (yystate >= 0 && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTBASE];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;

#ifdef YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (yyn > YYFLAG && yyn < YYLAST)
	{
	  YYSIZE_T yysize = 0;
	  char *yymsg;
	  int yyx, yycount;

	  yycount = 0;
	  /* Start YYX at -YYN if negative to avoid negative indexes in
	     YYCHECK.  */
	  for (yyx = yyn < 0 ? -yyn : 0;
	       yyx < (int) (sizeof (yytname) / sizeof (char *)); yyx++)
	    if (yycheck[yyx + yyn] == yyx)
	      yysize += yystrlen (yytname[yyx]) + 15, yycount++;
	  yysize += yystrlen ("parse error, unexpected ") + 1;
	  yysize += yystrlen (yytname[YYTRANSLATE (yychar)]);
	  yymsg = (char *) YYSTACK_ALLOC (yysize);
	  if (yymsg != 0)
	    {
	      char *yyp = yystpcpy (yymsg, "parse error, unexpected ");
	      yyp = yystpcpy (yyp, yytname[YYTRANSLATE (yychar)]);

	      if (yycount < 5)
		{
		  yycount = 0;
		  for (yyx = yyn < 0 ? -yyn : 0;
		       yyx < (int) (sizeof (yytname) / sizeof (char *));
		       yyx++)
		    if (yycheck[yyx + yyn] == yyx)
		      {
			const char *yyq = ! yycount ? ", expecting " : " or ";
			yyp = yystpcpy (yyp, yyq);
			yyp = yystpcpy (yyp, yytname[yyx]);
			yycount++;
		      }
		}
	      yyerror (yymsg);
	      YYSTACK_FREE (yymsg);
	    }
	  else
	    yyerror ("parse error; also virtual memory exhausted");
	}
      else
#endif /* defined (YYERROR_VERBOSE) */
	yyerror ("parse error");
    }
  goto yyerrlab1;


/*--------------------------------------------------.
| yyerrlab1 -- error raised explicitly by an action |
`--------------------------------------------------*/
yyerrlab1:
  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      /* return failure if at end of input */
      if (yychar == YYEOF)
	YYABORT;
      YYDPRINTF ((stderr, "Discarding token %d (%s).\n",
		  yychar, yytname[yychar1]));
      yychar = YYEMPTY;
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */

  yyerrstatus = 3;		/* Each real token shifted decrements this */

  goto yyerrhandle;


/*-------------------------------------------------------------------.
| yyerrdefault -- current state does not do anything special for the |
| error token.                                                       |
`-------------------------------------------------------------------*/
yyerrdefault:
#if 0
  /* This is wrong; only states that explicitly want error tokens
     should shift them.  */

  /* If its default is to accept any token, ok.  Otherwise pop it.  */
  yyn = yydefact[yystate];
  if (yyn)
    goto yydefault;
#endif


/*---------------------------------------------------------------.
| yyerrpop -- pop the current state because it cannot handle the |
| error token                                                    |
`---------------------------------------------------------------*/
yyerrpop:
  if (yyssp == yyss)
    YYABORT;
  yyvsp--;
  yystate = *--yyssp;
#if YYLSP_NEEDED
  yylsp--;
#endif

#if YYDEBUG
  if (yydebug)
    {
      short *yyssp1 = yyss - 1;
      YYFPRINTF (stderr, "Error: state stack now");
      while (yyssp1 != yyssp)
	YYFPRINTF (stderr, " %d", *++yyssp1);
      YYFPRINTF (stderr, "\n");
    }
#endif

/*--------------.
| yyerrhandle.  |
`--------------*/
yyerrhandle:
  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yyerrdefault;

  yyn += YYTERROR;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != YYTERROR)
    goto yyerrdefault;

  yyn = yytable[yyn];
  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrpop;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrpop;

  if (yyn == YYFINAL)
    YYACCEPT;

  YYDPRINTF ((stderr, "Shifting error token, "));

  *++yyvsp = yylval;
#if YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

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

/*---------------------------------------------.
| yyoverflowab -- parser overflow comes here.  |
`---------------------------------------------*/
yyoverflowlab:
  yyerror ("parser stack overflow");
  yyresult = 2;
  /* Fall through.  */

yyreturn:
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  return yyresult;
}
#line 1484 "clic.y"


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
	char path[256];
	const char *s=strrchr(filename, '/');
	char *e;
	if (s)
		s++;
	else
		s=filename;
	/*snprintf(path, sizeof(path), "_main_%s", s);*/
	snprintf(path, sizeof(path), "%s", s);
	e=strrchr(path, '.');
	if (e)
		*e=0;
	for (e = path; *e; ++e)
		*e = toupper(*e);
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
	do {
		ret = get_include (&index, &line, &filename);
		if (index>=0)
			fprintf(stdout, "in file '%s',\n\tincluded at line %d ", filename, line);
		else
			fprintf(stdout, "in file '%s'\n", filename);
	} while (ret!=0);
}

int
yyerror(const char *s, ... )
{
	if (!clic_warncount && !clic_errorcount)
		fprintf(stdout, "\n");
	clic_errorcount++;
	if (s)
	{
		va_list ap;
		va_start(ap, s);
		fprintf(stdout, "error %d: ", clic_errorcount);
		vfprintf(stdout, s, ap);
		va_end(ap);

		fprintf(stdout,"\n\tline %ld pos %ld (yychar=%d, '%c') ", cl_line+corr_line, cl_pos, yychar, (yychar>32&&yychar<256)?yychar:' ');
		/*fprintf(stdout,"\n\tline %d pos %d ", cl_line+corr_line, cl_pos);*/
	}
	else
		fprintf(stdout, "error %d, (yychar=%d) ", clic_errorcount, yychar);

	print_file();
	fflush(stdout);
	return 0;
}

int
yywarning(const char *s, ... )
{
	if (!clic_warncount && !clic_errorcount)
		fprintf(stdout, "\n");
	clic_warncount++;
	if (s)
	{
		va_list ap;
		va_start(ap, s);
		fprintf(stdout, "warning %d: ", clic_warncount);
		vfprintf(stdout, s, ap);
		va_end(ap);

		fprintf(stdout,"\n\tline %ld, pos %ld, ", cl_line+corr_line, cl_pos);
	}
	else
		fprintf(stdout, "warning %d, ", clic_warncount);
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

