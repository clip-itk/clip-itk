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
# define	CGET	312
# define	FOR	313
# define	STEP	314
# define	TO	315
# define	NEXT	316
# define	FOREACH	317
# define	BEGSEQ	318
# define	RECOVER	319
# define	USING	320
# define	BREAK	321
# define	EBREAK	322
# define	ANNOUNCE	323
# define	REQUEST	324
# define	IFNL	325
# define	IFEXPR	326
# define	CODESTR	327
# define	CODEBLOCK	328
# define	AS	329
# define	REF	330
# define	ASSIGN	331
# define	ADDA	332
# define	SUBA	333
# define	DIVA	334
# define	MODA	335
# define	MULA	336
# define	POWA	337
# define	POSTINCR	338
# define	OR	339
# define	AND	340
# define	NOT	341
# define	GE	342
# define	LE	343
# define	EQ	344
# define	NE	345
# define	POW	346
# define	MINUS	347
# define	INCR	348
# define	DECR	349
# define	RPTR	350
# define	REPTR	351
# define	DSEMICOLON	352

#line 7 "clic.y"

/*
 * $Log: clic.tab.c,v $
 * Revision 1.2  2004/04/29 07:29:19  clip
 * uri: fix backward output in command TEXT. Closes #172
 *
 * Revision 1.1  2004/04/26 06:43:41  clip
 * uri: small fix about new flex bugs
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


#line 416 "clic.y"
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



#define	YYFINAL		626
#define	YYFLAG		-32768
#define	YYNTBASE	122

/* YYTRANSLATE(YYLEX) -- Bison token number corresponding to YYLEX. */
#define YYTRANSLATE(x) ((unsigned)(x) <= 352 ? yytranslate[x] : 200)

/* YYTRANSLATE[YYLEX] -- Bison token number corresponding to YYLEX. */
static const char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     112,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,   121,    96,   101,   116,     2,
     113,   114,    99,    97,   115,    98,   108,   100,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,   106,     2,
      91,    95,    89,     2,    85,     2,     2,     2,     2,     2,
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
       2,     2,     2,     2,     2,     2,     1,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
      66,    67,    68,    69,    70,    71,    72,    73,    74,    75,
      76,    77,    78,    79,    80,    81,    82,    83,    84,    86,
      87,    88,    90,    92,    93,    94,   102,   103,   104,   105,
     109,   110,   111
};

#if YYDEBUG
static const short yyprhs[] =
{
       0,     0,     1,     5,     8,    12,    14,    17,    19,    22,
      24,    26,    27,    31,    32,    36,    37,    42,    47,    50,
      51,    55,    56,    60,    61,    65,    66,    70,    71,    75,
      78,    82,    85,    87,    90,    93,    96,    98,   102,   108,
     114,   121,   128,   133,   139,   147,   155,   165,   174,   183,
     194,   201,   206,   212,   219,   223,   227,   231,   233,   240,
     246,   247,   254,   258,   262,   266,   270,   272,   274,   275,
     287,   288,   298,   299,   300,   308,   311,   320,   321,   330,
     336,   343,   344,   347,   350,   352,   357,   358,   361,   364,
     368,   370,   372,   374,   375,   377,   383,   389,   390,   392,
     393,   400,   401,   402,   405,   406,   409,   411,   413,   415,
     417,   418,   424,   425,   429,   431,   433,   434,   437,   439,
     445,   446,   450,   452,   454,   456,   458,   459,   462,   464,
     467,   470,   472,   475,   478,   481,   485,   489,   494,   498,
     503,   505,   507,   511,   513,   515,   517,   521,   524,   529,
     534,   536,   540,   544,   548,   555,   560,   566,   569,   573,
     576,   582,   587,   592,   598,   605,   609,   617,   623,   629,
     638,   645,   652,   656,   661,   667,   674,   678,   683,   689,
     696,   703,   708,   714,   722,   730,   740,   749,   758,   769,
     776,   782,   787,   793,   800,   804,   808,   812,   816,   820,
     824,   828,   832,   836,   840,   844,   848,   852,   856,   860,
     864,   867,   870,   873,   876,   879,   882,   885,   889,   893,
     900,   905,   907,   909,   913,   917,   918,   924,   925,   931,
     932,   939,   948,   952,   953,   957,   958,   960,   962,   964,
     966,   969,   972,   974,   977,   980,   982,   984,   986,   988,
     990,   992,   994,   996,   997,  1000,  1005,  1010,  1014,  1017,
    1021,  1024,  1029,  1031,  1035,  1038,  1041,  1045,  1050,  1052,
    1055,  1059,  1063,  1065,  1068,  1072,  1076,  1080,  1085,  1086,
    1089,  1094,  1095,  1097,  1101,  1103,  1107,  1109,  1113,  1115,
    1116,  1119,  1121,  1125,  1126,  1128,  1130,  1134,  1138,  1142,
    1144,  1148,  1149,  1151,  1153,  1157,  1159,  1161,  1163,  1165,
    1167,  1169
};
static const short yyrhs[] =
{
      -1,   122,   127,   112,     0,   122,     7,     0,   122,    23,
       7,     0,    12,     0,    23,    12,     0,    13,     0,    23,
      13,     0,    14,     0,    15,     0,     0,   113,   186,   114,
       0,     0,   126,   127,   112,     0,     0,   123,     6,   125,
     139,     0,   124,     6,   125,   139,     0,    16,   187,     0,
       0,    24,   128,   180,     0,     0,    23,   129,   180,     0,
       0,    21,   130,   180,     0,     0,    22,   131,   180,     0,
       0,    25,   132,   181,     0,    49,   188,     0,    48,   188,
     162,     0,    17,   188,     0,    11,     0,    11,   166,     0,
      70,   187,     0,    69,     6,     0,     1,     0,   166,    95,
     166,     0,     6,   109,     6,   176,   166,     0,     6,   109,
     165,   176,   166,     0,   173,     6,   109,     6,   176,   166,
       0,   173,     6,   109,   165,   176,   166,     0,   173,     6,
     176,   166,     0,   165,   109,     6,   176,   166,     0,   113,
     197,   114,   109,     6,   176,   166,     0,   113,   197,   114,
     109,   165,   176,   166,     0,   113,   197,   114,   109,   113,
     197,   114,   176,   166,     0,   173,   113,   197,   114,   109,
       6,   176,   166,     0,   173,   113,   197,   114,   109,   165,
     176,   166,     0,   173,   113,   197,   114,   109,   113,   197,
     114,   176,   166,     0,   173,   165,   109,     6,   176,   166,
       0,   173,   165,   176,   166,     0,   165,   109,   165,   176,
     166,     0,   173,   165,   109,   165,   176,   166,     0,   163,
      95,   166,     0,   165,    95,   166,     0,   179,    95,   166,
       0,   166,     0,     6,   113,   189,   114,    95,   166,     0,
     113,   197,   114,    95,   166,     0,     0,    30,   133,   166,
     112,   126,   152,     0,    31,     6,   190,     0,    31,   165,
     190,     0,    36,     6,   190,     0,    36,   165,   190,     0,
      33,     0,    34,     0,     0,   143,   163,   172,   166,    61,
     166,   151,   112,   134,   126,   144,     0,     0,   143,   163,
      50,   166,   145,   112,   135,   126,   144,     0,     0,     0,
      64,   149,   136,   126,   137,   147,    27,     0,    67,   196,
       0,    37,   113,   171,   115,   171,   115,   171,   114,     0,
       0,    37,   166,   112,   138,   126,   154,   155,   156,     0,
      42,   112,   158,   159,   160,     0,    46,   166,   112,   140,
     159,   161,     0,     0,    75,     6,     0,    76,     6,     0,
     141,     0,   140,   142,   112,   126,     0,     0,   141,   112,
       0,    43,   199,     0,   142,   115,   199,     0,    59,     0,
      62,     0,    27,     0,     0,     9,     0,   123,     6,   125,
     139,   112,     0,   124,     6,   125,   139,   112,     0,     0,
     146,     0,     0,    65,   149,   150,   112,   148,   126,     0,
       0,     0,    66,   163,     0,     0,    60,   166,     0,    27,
       0,    32,     0,    38,     0,    37,     0,     0,   154,    41,
     166,   112,   126,     0,     0,    40,   112,   126,     0,    27,
       0,    39,     0,     0,   157,   112,     0,   157,     0,   158,
      43,   166,   112,   126,     0,     0,    44,   112,   126,     0,
      27,     0,    45,     0,    27,     0,    47,     0,     0,    50,
       6,     0,     6,     0,   174,     6,     0,   174,   165,     0,
       6,     0,   174,     6,     0,   173,     6,     0,   116,   164,
       0,   116,   164,   108,     0,     6,   116,   164,     0,   116,
     164,   108,     6,     0,   116,   164,     4,     0,   116,   113,
     166,   114,     0,   198,     0,     5,     0,     5,   102,   166,
       0,     8,     0,   163,     0,   165,     0,   113,   197,   114,
       0,    85,   166,     0,     6,   113,   189,   114,     0,   165,
     113,   189,   114,     0,   179,     0,   163,   175,   166,     0,
     179,   175,   166,     0,   165,   175,   166,     0,   166,   106,
       6,   113,   189,   114,     0,   179,   113,   189,   114,     0,
     111,     6,   113,   189,   114,     0,   173,     6,     0,     6,
     109,     6,     0,   173,   165,     0,     6,   110,   113,   166,
     114,     0,   173,     6,   109,     6,     0,   173,     6,   109,
     165,     0,     6,   109,   113,   197,   114,     0,   173,     6,
     109,   113,   197,   114,     0,     6,   109,   165,     0,   113,
     197,   114,   109,   113,   197,   114,     0,   113,   197,   114,
     109,   165,     0,   113,   197,   114,   109,     6,     0,   173,
     113,   197,   114,   109,   113,   197,   114,     0,   173,   113,
     197,   114,   109,   165,     0,   173,   113,   197,   114,   109,
       6,     0,   165,   109,     6,     0,   173,   165,   109,     6,
       0,   165,   109,   113,   197,   114,     0,   173,   165,   109,
     113,   197,   114,     0,   165,   109,   165,     0,   173,   165,
     109,   165,     0,     6,   109,     6,   175,   166,     0,   173,
       6,   109,     6,   175,   166,     0,   173,     6,   109,   165,
     175,   166,     0,   173,     6,   175,   166,     0,   165,   109,
       6,   175,   166,     0,   113,   197,   114,   109,     6,   175,
     166,     0,   113,   197,   114,   109,   165,   175,   166,     0,
     113,   197,   114,   109,   113,   197,   114,   175,   166,     0,
     173,   113,   197,   114,   109,     6,   175,   166,     0,   173,
     113,   197,   114,   109,   165,   175,   166,     0,   173,   113,
     197,   114,   109,   113,   197,   114,   175,   166,     0,   173,
     165,   109,     6,   175,   166,     0,     6,   109,   165,   175,
     166,     0,   173,   165,   175,   166,     0,   165,   109,   165,
     175,   166,     0,   173,   165,   109,   165,   175,   166,     0,
     166,    95,   166,     0,   166,    93,   166,     0,   166,    94,
     166,     0,   166,    91,   166,     0,   166,    89,   166,     0,
     166,    92,   166,     0,   166,    90,   166,     0,   166,    97,
     166,     0,   166,    96,   166,     0,   166,    98,   166,     0,
     166,    99,   166,     0,   166,   100,   166,     0,   166,   101,
     166,     0,   166,   102,   166,     0,   166,    87,   166,     0,
     166,    86,   166,     0,    88,   166,     0,   104,   166,     0,
     166,   104,     0,   105,   166,     0,   166,   105,     0,    98,
     166,     0,    97,   166,     0,   117,   195,   118,     0,   117,
     193,   118,     0,   117,   119,   177,   178,   195,   118,     0,
      58,   113,   191,   114,     0,    53,     0,    56,     0,    54,
     166,   120,     0,    55,   166,   114,     0,     0,    73,   170,
     167,   195,   114,     0,     0,    74,   170,   168,   195,   114,
       0,     0,    24,   113,   177,   169,   180,   114,     0,   153,
     113,   171,   115,   171,   115,   171,   114,     0,    68,   196,
     114,     0,     0,   119,   186,   119,     0,     0,   166,     0,
      77,     0,    95,     0,    52,     0,   173,    52,     0,   174,
      52,     0,    51,     0,   173,    51,     0,   174,    51,     0,
      77,     0,    78,     0,    79,     0,    82,     0,    80,     0,
      81,     0,    83,     0,    95,     0,     0,   186,   119,     0,
     166,   107,   197,   120,     0,   179,   107,   197,   120,     0,
     166,   106,     6,     0,   111,     6,     0,   179,   106,     6,
       0,   184,   139,     0,   180,   115,   184,   139,     0,   182,
       0,   181,   115,   182,     0,     6,   183,     0,   165,   183,
       0,   113,   197,   114,     0,   183,   113,   197,   114,     0,
       6,     0,     6,   185,     0,     6,    77,   166,     0,   163,
      95,   166,     0,   165,     0,   165,   185,     0,   165,    77,
     166,     0,   165,    95,   166,     0,   107,   197,   120,     0,
     185,   107,   197,   120,     0,     0,     6,   139,     0,   186,
     115,     6,   139,     0,     0,     6,     0,   187,   115,     6,
       0,     6,     0,   188,   115,     6,     0,   191,     0,   191,
     115,    57,     0,    57,     0,     0,    35,   189,     0,   192,
       0,   191,   115,   192,     0,     0,   166,     0,   194,     0,
     193,   115,   194,     0,     6,   121,   166,     0,     4,   121,
     166,     0,   196,     0,   195,   115,   196,     0,     0,   166,
       0,   166,     0,   197,   115,   166,     0,     3,     0,    28,
       0,    29,     0,    26,     0,     4,     0,   198,     0,    98,
     198,     0
};

#endif

#if YYDEBUG
/* YYRLINE[YYN] -- source line where rule number YYN was defined. */
static const short yyrline[] =
{
       0,   503,   526,   535,   542,   547,   548,   551,   552,   553,
     554,   557,   558,   561,   562,   574,   575,   589,   603,   624,
     624,   635,   635,   647,   647,   658,   658,   669,   669,   691,
     692,   693,   694,   695,   697,   709,   719,   723,   724,   725,
     726,   727,   728,   729,   731,   732,   733,   734,   735,   736,
     738,   739,   740,   741,   743,   744,   745,   746,   747,   761,
     763,   763,   776,   778,   780,   782,   784,   791,   798,   798,
     805,   805,   812,   812,   812,   834,   837,   846,   846,   870,
     876,   882,   883,   884,   887,   888,   899,   902,   905,   910,
     917,   925,   926,   929,   930,   933,   934,   937,   944,   951,
     951,   965,   968,   969,   972,   973,   976,   977,   980,   981,
     984,   985,   994,   995,  1002,  1003,  1006,  1007,  1010,  1011,
    1020,  1021,  1028,  1029,  1032,  1033,  1036,  1037,  1040,  1041,
    1044,  1047,  1048,  1049,  1052,  1053,  1054,  1055,  1056,  1058,
    1061,  1062,  1084,  1089,  1094,  1095,  1096,  1100,  1102,  1103,
    1105,  1106,  1107,  1108,  1110,  1111,  1126,  1130,  1131,  1132,
    1134,  1137,  1138,  1139,  1140,  1141,  1143,  1144,  1145,  1146,
    1147,  1148,  1150,  1152,  1153,  1154,  1155,  1156,  1158,  1159,
    1160,  1161,  1162,  1164,  1165,  1166,  1167,  1168,  1169,  1171,
    1172,  1173,  1174,  1175,  1177,  1178,  1179,  1180,  1181,  1182,
    1183,  1184,  1185,  1187,  1188,  1189,  1190,  1191,  1192,  1193,
    1195,  1197,  1198,  1199,  1200,  1201,  1202,  1204,  1205,  1206,
    1227,  1228,  1229,  1230,  1231,  1233,  1233,  1235,  1235,  1238,
    1238,  1253,  1262,  1267,  1268,  1271,  1272,  1275,  1276,  1279,
    1280,  1281,  1284,  1285,  1286,  1289,  1290,  1291,  1292,  1293,
    1294,  1295,  1298,  1302,  1305,  1308,  1309,  1310,  1316,  1323,
    1330,  1338,  1351,  1355,  1362,  1363,  1366,  1367,  1370,  1371,
    1372,  1373,  1375,  1376,  1377,  1378,  1381,  1382,  1385,  1386,
    1394,  1405,  1406,  1410,  1424,  1428,  1435,  1436,  1437,  1440,
    1441,  1458,  1463,  1474,  1475,  1480,  1481,  1484,  1485,  1489,
    1501,  1516,  1517,  1520,  1521,  1524,  1525,  1526,  1527,  1528,
    1531,  1532
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
  "PARAMBEG", "PSHIFT", "PALL", "CGET", "FOR", "STEP", "TO", "NEXT",
  "FOREACH", "BEGSEQ", "RECOVER", "USING", "BREAK", "EBREAK", "ANNOUNCE",
  "REQUEST", "IFNL", "IFEXPR", "CODESTR", "CODEBLOCK", "AS", "REF",
  "ASSIGN", "ADDA", "SUBA", "DIVA", "MODA", "MULA", "POWA", "POSTINCR",
  "'@'", "OR", "AND", "NOT", "'>'", "GE", "'<'", "LE", "EQ", "NE", "'='",
  "'$'", "'+'", "'-'", "'*'", "'/'", "'%'", "POW", "MINUS", "INCR",
  "DECR", "':'", "'['", "'.'", "RPTR", "REPTR", "DSEMICOLON", "'\\n'",
  "'('", "')'", "','", "'&'", "'{'", "'}'", "'|'", "']'", "'#'", "file",
  "function", "procedure", "paramlist", "operlist", "oper", "@1", "@2",
  "@3", "@4", "@5", "@6", "@7", "@8", "@9", "@10", "@11", "type_def",
  "switchlist", "switchbeg", "switchlabel", "for", "next", "keys",
  "recoverr", "recover", "@12", "curseq", "using", "step", "enddo", "iif",
  "elseif", "else", "endif", "casebeg", "caselist", "otherwise",
  "endcase", "endswitch", "inalias", "name", "iname", "mname", "expr",
  "@13", "@14", "@15", "bparam_list", "nilexpr", "eassign", "fieldptr",
  "memvarptr", "assign", "ass_op", "func", "code", "arr", "vardef",
  "dimdef", "dim", "dim_list", "var", "arr_list", "param_list",
  "namelist", "varlist", "arglist", "with", "arg_list", "arg", "pairlist",
  "pair", "exprlist", "nexpr", "expr_list", "constant", "mconstant", 0
};
#endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives. */
static const short yyr1[] =
{
       0,   122,   122,   122,   122,   123,   123,   124,   124,   124,
     124,   125,   125,   126,   126,   127,   127,   127,   127,   128,
     127,   129,   127,   130,   127,   131,   127,   132,   127,   127,
     127,   127,   127,   127,   127,   127,   127,   127,   127,   127,
     127,   127,   127,   127,   127,   127,   127,   127,   127,   127,
     127,   127,   127,   127,   127,   127,   127,   127,   127,   127,
     133,   127,   127,   127,   127,   127,   127,   127,   134,   127,
     135,   127,   136,   137,   127,   127,   127,   138,   127,   127,
     127,   139,   139,   139,   140,   140,   141,   141,   142,   142,
     143,   144,   144,   145,   145,   146,   146,   147,   147,   148,
     147,   149,   150,   150,   151,   151,   152,   152,   153,   153,
     154,   154,   155,   155,   156,   156,   157,   157,   158,   158,
     159,   159,   160,   160,   161,   161,   162,   162,   163,   163,
     163,   164,   164,   164,   165,   165,   165,   165,   165,   165,
     166,   166,   166,   166,   166,   166,   166,   166,   166,   166,
     166,   166,   166,   166,   166,   166,   166,   166,   166,   166,
     166,   166,   166,   166,   166,   166,   166,   166,   166,   166,
     166,   166,   166,   166,   166,   166,   166,   166,   166,   166,
     166,   166,   166,   166,   166,   166,   166,   166,   166,   166,
     166,   166,   166,   166,   166,   166,   166,   166,   166,   166,
     166,   166,   166,   166,   166,   166,   166,   166,   166,   166,
     166,   166,   166,   166,   166,   166,   166,   166,   166,   166,
     166,   166,   166,   166,   166,   167,   166,   168,   166,   169,
     166,   166,   166,   170,   170,   171,   171,   172,   172,   173,
     173,   173,   174,   174,   174,   175,   175,   175,   175,   175,
     175,   175,   176,   177,   178,   179,   179,   179,   179,   179,
     180,   180,   181,   181,   182,   182,   183,   183,   184,   184,
     184,   184,   184,   184,   184,   184,   185,   185,   186,   186,
     186,   187,   187,   187,   188,   188,   189,   189,   189,   190,
     190,   191,   191,   192,   192,   193,   193,   194,   194,   195,
     195,   196,   196,   197,   197,   198,   198,   198,   198,   198,
     199,   199
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN. */
static const short yyr2[] =
{
       0,     0,     3,     2,     3,     1,     2,     1,     2,     1,
       1,     0,     3,     0,     3,     0,     4,     4,     2,     0,
       3,     0,     3,     0,     3,     0,     3,     0,     3,     2,
       3,     2,     1,     2,     2,     2,     1,     3,     5,     5,
       6,     6,     4,     5,     7,     7,     9,     8,     8,    10,
       6,     4,     5,     6,     3,     3,     3,     1,     6,     5,
       0,     6,     3,     3,     3,     3,     1,     1,     0,    11,
       0,     9,     0,     0,     7,     2,     8,     0,     8,     5,
       6,     0,     2,     2,     1,     4,     0,     2,     2,     3,
       1,     1,     1,     0,     1,     5,     5,     0,     1,     0,
       6,     0,     0,     2,     0,     2,     1,     1,     1,     1,
       0,     5,     0,     3,     1,     1,     0,     2,     1,     5,
       0,     3,     1,     1,     1,     1,     0,     2,     1,     2,
       2,     1,     2,     2,     2,     3,     3,     4,     3,     4,
       1,     1,     3,     1,     1,     1,     3,     2,     4,     4,
       1,     3,     3,     3,     6,     4,     5,     2,     3,     2,
       5,     4,     4,     5,     6,     3,     7,     5,     5,     8,
       6,     6,     3,     4,     5,     6,     3,     4,     5,     6,
       6,     4,     5,     7,     7,     9,     8,     8,    10,     6,
       5,     4,     5,     6,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       2,     2,     2,     2,     2,     2,     2,     3,     3,     6,
       4,     1,     1,     3,     3,     0,     5,     0,     5,     0,
       6,     8,     3,     0,     3,     0,     1,     1,     1,     1,
       2,     2,     1,     2,     2,     1,     1,     1,     1,     1,
       1,     1,     1,     0,     2,     4,     4,     3,     2,     3,
       2,     4,     1,     3,     2,     2,     3,     4,     1,     2,
       3,     3,     1,     2,     3,     3,     3,     4,     0,     2,
       4,     0,     1,     3,     1,     3,     1,     3,     1,     0,
       2,     1,     3,     0,     1,     1,     3,     3,     3,     1,
       3,     0,     1,     1,     3,     1,     1,     1,     1,     1,
       1,     2
};

/* YYDEFACT[S] -- default rule to reduce with in state S when YYTABLE
   doesn't specify something else to do.  Zero means the default is an
   error. */
static const short yydefact[] =
{
       1,     0,    36,   305,   309,   141,   128,     3,   143,    32,
       5,     7,     9,    10,   281,     0,    23,    25,    21,    19,
      27,   308,   306,   307,    60,     0,    66,    67,     0,     0,
     108,     0,     0,     0,     0,   242,   239,   221,     0,     0,
     222,     0,    90,   101,   301,   301,     0,   281,   233,   233,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   301,
       0,     0,     0,     0,     0,   144,   145,    57,     0,     0,
     150,   140,     0,     0,     0,   293,     0,   128,     0,   109,
       0,   144,   145,    33,     0,   150,   282,    18,   284,    31,
       0,     0,     4,     6,     8,     0,   253,     0,     0,     0,
     289,   289,   289,   289,   235,     0,   116,     0,   126,    29,
       0,     0,   293,    72,   302,    75,     0,    35,    34,   278,
     225,   227,   147,   210,   216,   215,   211,   213,   258,   303,
       0,   131,     0,   134,     0,     0,   309,   128,   253,     0,
     295,     0,   299,    11,    11,     2,   128,     0,     0,   235,
     245,   246,   247,   249,   250,   248,   251,     0,     0,     0,
       0,   293,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   212,
     214,     0,     0,   157,   243,   240,     0,   159,   129,   244,
     241,   130,     0,     0,     0,   293,     0,   142,   158,     0,
     165,     0,   288,   294,     0,   286,   291,   136,     0,   293,
       0,     0,     0,   157,     0,   159,     0,     0,   268,     0,
     272,    24,    81,    26,    22,   229,    20,     0,     0,    28,
     262,     0,   293,    62,    63,    64,    65,   236,     0,    77,
     118,   120,    86,     0,    30,   223,   224,     0,    13,   232,
      81,     0,   301,   301,   293,   146,     0,     0,   138,   135,
     133,   132,     0,     0,   278,     0,   218,   301,   217,   278,
      81,    81,     0,   237,   238,     0,   236,     0,    54,   151,
      55,   172,     0,   176,     0,   153,   209,   208,   198,   200,
     197,   199,   195,   196,   194,   202,   201,   203,   204,   205,
     206,   207,   257,     0,   252,     0,     0,     0,     0,     0,
       0,     0,    56,   259,     0,     0,   152,     0,     0,     0,
       0,     0,     0,   148,   293,   158,   165,     0,   146,   172,
     176,   194,     0,     0,     0,   283,   285,     0,     0,   269,
       0,     0,     0,   273,     0,     0,     0,   260,     0,     0,
     264,   265,     0,    13,   290,   235,    13,   117,     0,     0,
       0,   120,    84,   127,   220,   293,     0,   279,     0,   234,
       0,     0,     0,     0,     0,   304,   139,   137,   298,   297,
     301,     0,     0,     0,   296,   300,     0,    16,    17,    93,
       0,   235,     0,     0,     0,     0,     0,   149,   293,   255,
     161,     0,   162,   181,    42,     0,   173,     0,   177,   191,
      51,   256,   155,   178,    38,   163,   190,    39,   160,     0,
     287,   292,   148,     0,   161,   162,     0,   173,   177,   270,
       0,     0,   271,   274,   275,    81,    82,    83,     0,     0,
       0,   263,     0,     0,     0,     0,    13,   122,   123,    79,
       0,     0,     0,    87,    21,     0,    97,    81,   226,   228,
     156,    59,   168,     0,   167,     0,   254,    12,    94,     0,
       0,     0,   182,    43,   174,   192,    52,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    58,
     168,     0,   167,     0,   276,     0,   261,   230,   266,     0,
     106,   107,    61,   235,   112,    13,     0,     0,   310,    88,
      13,     0,   124,   125,    80,    14,     0,   101,     0,     0,
      98,     0,   280,     0,     0,     0,     0,     0,   219,    70,
     104,   235,   154,   179,    40,   164,   180,    41,   171,     0,
     170,   189,    50,   175,   193,    53,     0,   171,     0,   170,
     277,   267,     0,     0,     0,     0,     0,   311,     0,    89,
     102,    11,    11,    74,   183,    44,   166,   184,    45,    13,
       0,     0,     0,     0,     0,     0,     0,     0,   166,     0,
      76,    13,     0,   114,   115,    78,     0,     0,    81,    81,
       0,     0,     0,   105,    68,   231,   186,    47,   169,   187,
      48,   169,     0,    13,   103,    99,     0,     0,   185,    46,
      92,    91,    71,    13,     0,     0,     0,    13,    95,    96,
       0,   188,    49,     0,    69,     0,     0
};

static const short yydefgoto[] =
{
       1,    60,    61,   270,   366,   455,    97,    95,    90,    91,
      98,    99,   613,   569,   248,   456,   356,   347,   361,   362,
     451,    63,   612,   469,   520,   521,   617,   113,   587,   571,
     502,    64,   504,   555,   585,   240,   241,   360,   449,   514,
     244,    81,   133,    82,   129,   252,   253,   348,   120,   238,
     275,    84,    69,   158,   307,   225,   380,    85,   221,   229,
     230,   350,   222,   339,   251,    87,    89,   204,   233,   205,
     206,   139,   140,   141,   142,   210,    71,   509
};

static const short yypact[] =
{
  -32768,  1050,-32768,-32768,-32768,   -68,   120,-32768,-32768,  2421,
  -32768,-32768,-32768,-32768,    51,   102,-32768,-32768,    75,     4,
  -32768,-32768,-32768,-32768,-32768,    12,-32768,-32768,    13,  2507,
  -32768,    39,  2421,   102,   102,-32768,-32768,-32768,  2421,  2421,
  -32768,    28,-32768,-32768,  2421,  2421,   149,    51,    87,    87,
    2421,  2421,  2421,  2421,  2421,  2421,   240,  2421,    29,   745,
     270,   278,   182,    14,   191,   377,   603,  2839,    11,    21,
     565,-32768,  2421,     9,   209,   879,    53,   177,     4,-32768,
    2421,   819,   468,  2861,    17,   812,-32768,   198,-32768,   211,
      24,    24,-32768,-32768,-32768,    24,-32768,    24,    18,  2421,
     -22,   289,   -22,   289,  2421,  2719,-32768,  2743,   -29,   211,
    2583,  2615,  2421,-32768,  2861,-32768,   215,-32768,   198,   328,
  -32768,-32768,  2861,  2901,   262,   262,   262,   262,   229,  2861,
     -67,-32768,  2421,    42,    61,   153,   252,   154,-32768,   -23,
  -32768,   170,-32768,   267,   267,-32768,-32768,   173,   133,  2421,
  -32768,-32768,-32768,-32768,-32768,-32768,-32768,  2421,  2421,  2421,
      10,   879,  2421,  2421,  2421,  2421,  2421,  2421,  2421,  2421,
    2421,  2421,  2421,  2421,  2421,  2421,  2421,  2421,  2421,-32768,
  -32768,   381,  2421,   219,-32768,-32768,  2421,   711,   273,-32768,
  -32768,-32768,  2421,   387,  2421,   879,  2421,   262,   266,  2421,
     819,  2421,-32768,  2861,   282,   283,-32768,-32768,    19,   879,
     123,    23,  2421,   322,  2421,   746,   411,   417,   -17,   349,
     150,   312,   256,   312,   312,-32768,   312,   156,   353,   364,
  -32768,  2767,   879,-32768,-32768,-32768,-32768,  2641,   367,-32768,
     330,   294,-32768,   462,-32768,-32768,-32768,   238,-32768,-32768,
     256,   -74,  2421,  2421,   879,   -69,  2421,  2667,-32768,   464,
  -32768,-32768,  2421,  2421,   328,   250,-32768,  2421,-32768,   328,
     256,   256,  2421,-32768,-32768,  2421,  2861,   376,  2861,  2861,
    2861,   266,  2421,   819,   380,  2861,  2882,  2901,  2247,  2247,
    2247,  2247,  2247,  2247,   914,  2247,   822,   822,    76,    76,
      76,   262,   382,     1,-32768,    30,  2421,  2421,   241,    36,
    2421,  2421,  2861,-32768,   145,   383,  2861,  2421,  2421,   248,
    2421,  2421,  2693,   403,  2335,   329,   819,   385,   392,   329,
     819,  2247,    73,   271,    77,-32768,-32768,  2421,  2421,   397,
    2421,  2421,  2421,   397,    24,   500,   502,-32768,    24,  2421,
     398,   398,    18,-32768,-32768,  2421,-32768,-32768,  2421,   400,
      74,   327,   401,-32768,-32768,  2421,  1752,-32768,   503,-32768,
     299,   301,   402,  2421,    83,  2861,-32768,-32768,  2861,  2861,
    2421,   -13,   252,   406,-32768,-32768,   307,-32768,-32768,   941,
    2561,  2421,  2421,  2421,   311,  2421,  2421,-32768,   879,-32768,
     266,  2421,   819,  2861,  2861,   410,   266,  2421,   819,  2861,
    2861,-32768,-32768,  2861,  2861,-32768,  2861,  2861,-32768,  2421,
  -32768,-32768,-32768,    85,   329,   819,   415,   329,   819,  2861,
     158,  2421,  2861,  2861,  2861,   256,-32768,-32768,   315,   318,
    2421,-32768,  1869,   413,  1167,  2791,-32768,-32768,-32768,-32768,
      81,   180,    50,-32768,   422,   419,   268,   256,-32768,-32768,
  -32768,  2861,   266,  2421,   819,   200,-32768,-32768,-32768,   420,
    2421,   414,  2861,  2861,-32768,  2861,  2861,   423,  2421,  2421,
     325,  2421,  2421,   108,  2421,  2421,   332,  2421,  2421,  2861,
     329,  2421,   819,   112,-32768,   188,-32768,-32768,-32768,   334,
  -32768,-32768,-32768,  2421,   396,-32768,  1635,   355,-32768,-32768,
  -32768,    81,-32768,-32768,-32768,-32768,   422,-32768,   528,   532,
  -32768,   512,-32768,  2421,  2421,   347,  2421,  2421,-32768,-32768,
    2539,  2421,-32768,  2861,  2861,-32768,  2861,  2861,   266,  2421,
     819,  2861,  2861,-32768,  2861,  2861,   350,   329,  2421,   819,
  -32768,-32768,   426,   429,  2421,   205,  1284,-32768,  1401,-32768,
     477,   267,   267,-32768,  2861,  2861,   757,  2861,  2861,-32768,
    2421,   432,   438,  2421,  2421,   359,  2421,  2421,   819,   361,
  -32768,-32768,  2815,-32768,-32768,-32768,    14,   442,   256,   256,
    2421,  2421,  1986,  2861,-32768,-32768,  2861,  2861,   757,  2861,
    2861,   819,  2103,-32768,-32768,-32768,   444,   446,  2861,  2861,
  -32768,-32768,-32768,-32768,  2421,  2421,  1518,-32768,-32768,-32768,
    1986,  2861,  2861,  2220,-32768,   559,-32768
};

static const short yypgoto[] =
{
  -32768,   104,   106,  -142,  -292,   564,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,-32768,  -238,-32768,-32768,
  -32768,-32768,   -53,-32768,-32768,-32768,-32768,    54,-32768,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,-32768,   207,-32768,-32768,
  -32768,   152,   494,   119,    -1,-32768,-32768,-32768,   525,  -143,
  -32768,   144,   164,   451,   408,   440,-32768,     8,   -90,-32768,
     227,   352,   239,   362,    43,   537,   456,  -139,   274,   473,
    -310,-32768,   333,  -242,   -41,   321,  -411,    82
};


#define	YYLAST		3008


static const short yytable[] =
{
      67,   223,   271,   115,   116,   224,   277,   226,    83,    70,
     370,   371,   367,   232,   421,   198,   281,   183,   100,   102,
     146,   243,   284,   213,   227,   325,   373,   188,   105,   329,
     218,   107,   387,   388,    72,   131,   400,   110,   111,   508,
     374,   368,   406,   114,   114,   369,   258,   255,   256,   122,
     123,   124,   125,   126,   127,   421,   315,    86,   114,   131,
     337,   442,   184,   185,   444,    35,    36,   260,   184,   185,
     327,   197,   189,   190,   203,    35,    36,   512,  -128,   424,
      35,    36,    92,   427,     3,     4,   217,    93,    94,   462,
     338,   490,   265,   354,    76,   266,   557,   513,   231,    76,
     508,   447,   368,   237,    35,    36,   466,    21,    88,    22,
      23,   203,   184,   185,   538,   372,   256,    96,   547,   448,
      66,   399,   199,   282,   186,    58,    58,    58,    58,    58,
     214,   257,   199,    58,    58,    58,   282,    58,   465,    58,
      58,   112,   132,   401,   101,    68,    58,   103,   276,   407,
     259,   106,    58,    65,   506,   117,   278,   279,   280,   261,
     203,   285,   286,   287,   288,   289,   290,   291,   292,   293,
     294,   295,   296,   297,   298,   299,   300,   301,   178,   507,
     179,   180,   181,   182,   184,   185,   401,   187,   191,    58,
     407,   312,   200,    58,   203,   316,   463,   496,   491,    58,
     322,    58,   134,   215,   189,   190,   119,   148,   203,   220,
     220,   331,   443,   556,   220,   147,   220,   228,   558,   522,
     134,   539,   135,   272,    58,   548,   385,   341,    58,    73,
      74,   203,   583,    75,   148,   148,    76,   328,   256,   148,
     135,   148,   219,   219,   584,   342,   128,   219,   471,   219,
     273,   114,   114,   203,   382,   375,   383,   338,   438,   477,
     256,   378,   379,   208,    74,   411,   114,   209,   274,   349,
      76,   389,    76,   256,   390,   263,   143,   592,   494,   283,
      10,    11,    12,    13,   144,   267,   208,    74,   268,   602,
     209,   516,   510,    76,   145,   511,   150,   151,   152,   153,
     154,   155,   156,   256,   149,   403,   404,   381,   550,   409,
     410,   616,   386,   216,   304,   267,   413,   414,   528,   416,
     417,   620,   201,   203,   232,   623,   217,   326,   305,   249,
     330,   345,   346,   517,   250,    76,   429,   358,   359,   432,
     433,   434,   254,   150,   151,   152,   153,   154,   155,   156,
     606,   607,   364,   365,   276,   405,   256,   445,     3,     4,
     552,   304,   415,   256,   203,    67,   179,   180,   181,   182,
     450,   359,   461,   262,    70,   234,   235,   236,   130,   114,
     269,    21,    76,    22,    23,   426,   256,   302,   572,    76,
     276,   472,   473,   313,   475,   476,   323,   203,   324,   150,
     151,   152,   153,   154,   155,   156,   150,   151,   152,   153,
     154,   155,   156,   458,   267,   459,   267,   335,   489,   588,
     589,   467,   368,   336,   402,   474,   256,   344,   408,   497,
     344,   332,   498,   256,    93,    94,   553,   554,    76,   535,
     256,    67,   357,    67,   340,    76,   543,   256,   551,   256,
      70,   425,    70,   428,   150,   151,   152,   153,   154,   155,
     156,   566,   256,   220,   578,   256,   349,   220,   363,   530,
     377,   228,   157,   598,   256,   601,   256,   533,   534,   352,
     536,   537,   355,   541,   542,    66,   544,   545,   148,   108,
     109,   391,   148,   464,   397,   398,   219,   412,   419,   422,
     219,   423,   276,   303,   431,    67,   436,   308,   437,   457,
      68,   440,   446,   453,    70,   314,   460,   162,    65,   483,
     319,   196,   564,   565,   493,   567,   568,   263,   503,   531,
     276,   515,   529,   162,   561,   333,   196,   532,   562,   563,
     580,   581,   492,   586,   594,   150,   151,   152,   153,   154,
     155,   156,   595,   582,   605,    67,   618,    67,   619,   626,
     518,    66,   519,    66,    70,    62,    70,   624,   452,   593,
     207,   560,   596,   597,   121,   599,   600,   211,   264,   441,
     351,   161,   343,   435,   118,   247,    68,     0,    68,   608,
     609,    67,     0,   559,    65,   311,    65,     0,   384,     0,
      70,    67,   540,   394,     0,     0,   318,     0,   321,     0,
      70,     0,   549,   621,   622,    67,     0,     0,     0,    67,
       0,     0,    67,     0,    70,    66,     0,     0,    70,     0,
       0,    70,     0,     0,   306,     0,     0,     0,   310,     0,
       0,     0,   150,   151,   152,   153,   154,   155,   156,   317,
      68,   320,     0,     0,     0,     0,     0,     0,    65,   430,
     192,     0,     0,     0,   306,     0,   310,     0,     0,     0,
     439,   193,   194,     0,     0,    66,     0,    66,   195,     0,
     150,   151,   152,   153,   154,   155,   156,     0,     0,   393,
       0,   396,     0,     0,     0,     0,     0,     0,   159,     0,
      68,     0,    68,     0,     0,     0,     0,     0,    65,     0,
      65,    66,   160,     0,     0,     0,   161,     0,     0,     0,
       0,    66,   480,     0,     0,     0,     0,     0,   486,     0,
     148,     0,   392,     0,   395,    66,    68,     0,   604,    66,
       0,     0,    66,     0,    65,     0,    68,     0,     3,   136,
       5,   137,   495,     8,    65,     0,     0,     0,     0,     0,
      68,   499,     0,     0,    68,     0,     0,    68,    65,    78,
       0,    21,    65,    22,    23,    65,   317,   320,     0,     0,
     392,   395,    79,    30,   525,     0,     0,     0,   150,   151,
     152,   153,   154,   155,   156,     0,    35,    36,    37,    38,
      39,    40,     0,    41,     0,     0,   304,     0,   479,     0,
     482,     0,   546,    45,   485,     0,   488,     0,    48,    49,
     309,     0,     0,   150,   151,   152,   153,   154,   155,   156,
      50,     0,     0,    51,   150,   151,   152,   153,   154,   155,
     156,     0,    52,    53,     0,     0,     0,     0,     0,    54,
      55,   478,   304,   481,     0,   334,    56,   484,    80,   487,
     575,    58,    59,     0,   138,     0,     0,     0,     0,   579,
     524,     0,   527,     0,     0,   478,   481,     0,   484,   487,
       0,     0,     3,     4,     5,    77,     0,     8,     0,   150,
     151,   152,   153,   154,   155,   156,   150,   151,   152,   153,
     154,   155,   156,    78,     0,    21,     0,    22,    23,     0,
       0,     0,     0,   523,     0,   526,    79,    30,   193,   194,
       0,   175,   176,   177,   178,   195,   179,   180,   181,   182,
      35,    36,    37,    38,    39,    40,   202,    41,     0,     0,
       0,   523,     0,   526,     0,     0,   574,    45,   577,     0,
     468,     0,    48,    49,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    50,     0,     0,    51,     0,     0,
       0,     0,     0,     0,   591,     0,    52,    53,     0,     0,
       0,     0,     0,    54,    55,     0,     0,     0,     0,   573,
      56,   576,    80,     0,     0,    58,    59,     0,   573,     0,
     576,     0,     0,     0,     0,     0,   615,     0,     0,     0,
       0,   173,   174,   175,   176,   177,   178,   590,   179,   180,
     181,   182,     0,     0,     0,     0,   -37,   163,   164,   590,
     165,   166,   167,   168,   169,   170,   212,   172,   173,   174,
     175,   176,   177,   178,     0,   179,   180,   181,   182,   614,
     625,     2,   614,     3,     4,     5,     6,     7,     8,     0,
       0,     9,    10,    11,    12,    13,    14,    15,     0,     0,
       0,    16,    17,    18,    19,    20,    21,     0,    22,    23,
      24,    25,     0,    26,    27,     0,    28,    29,    30,     0,
       0,     0,    31,     0,     0,     0,    32,     0,    33,    34,
       0,    35,    36,    37,    38,    39,    40,     0,    41,    42,
       0,     0,     0,     0,    43,     0,     0,    44,    45,    46,
      47,     0,     0,    48,    49,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    50,     0,     0,    51,     0,
       0,     0,     0,     0,     0,     0,     0,    52,    53,     0,
       0,     0,     0,     0,    54,    55,     0,     0,     0,     0,
       0,    56,   -15,    57,     0,     0,    58,    59,     2,     0,
       3,     4,     5,     6,     0,     8,     0,     0,     9,    10,
      11,    12,    13,    14,    15,     0,     0,     0,    16,    17,
     454,    19,    20,    21,  -110,    22,    23,    24,    25,     0,
      26,    27,     0,    28,    29,    30,  -110,  -110,  -110,    31,
       0,     0,     0,    32,     0,    33,    34,     0,    35,    36,
      37,    38,    39,    40,     0,    41,    42,     0,     0,     0,
       0,    43,     0,     0,    44,    45,    46,    47,     0,     0,
      48,    49,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    50,     0,     0,    51,     0,     0,     0,     0,
       0,     0,     0,     0,    52,    53,     0,     0,     0,     0,
       0,    54,    55,     0,     0,     0,     0,     0,    56,   -15,
      57,     0,     0,    58,    59,     2,     0,     3,     4,     5,
       6,     0,     8,     0,     0,     9,    10,    11,    12,    13,
      14,    15,     0,     0,     0,    16,    17,   454,    19,    20,
      21,  -119,    22,    23,    24,    25,     0,    26,    27,     0,
      28,    29,    30,     0,     0,     0,    31,  -119,  -119,  -119,
      32,     0,    33,    34,     0,    35,    36,    37,    38,    39,
      40,     0,    41,    42,     0,     0,     0,     0,    43,     0,
       0,    44,    45,    46,    47,     0,     0,    48,    49,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    50,
       0,     0,    51,     0,     0,     0,     0,     0,     0,     0,
       0,    52,    53,     0,     0,     0,     0,     0,    54,    55,
       0,     0,     0,     0,     0,    56,   -15,    57,     0,     0,
      58,    59,     2,     0,     3,     4,     5,     6,     0,     8,
       0,     0,     9,    10,    11,    12,    13,    14,    15,     0,
       0,     0,    16,    17,   454,    19,    20,    21,   -85,    22,
      23,    24,    25,     0,    26,    27,     0,    28,    29,    30,
       0,     0,     0,    31,   -85,   -85,     0,    32,   -85,    33,
      34,     0,    35,    36,    37,    38,    39,    40,     0,    41,
      42,     0,     0,     0,     0,    43,     0,     0,    44,    45,
      46,    47,     0,     0,    48,    49,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    50,     0,     0,    51,
       0,     0,     0,     0,     0,     0,     0,     0,    52,    53,
       0,     0,     0,     0,     0,    54,    55,     0,     0,     0,
       0,     0,    56,   -15,    57,     0,     0,    58,    59,     2,
       0,     3,     4,     5,     6,     0,     8,     0,     0,     9,
      10,    11,    12,    13,    14,    15,     0,     0,     0,    16,
      17,   454,    19,    20,    21,  -111,    22,    23,    24,    25,
       0,    26,    27,     0,    28,    29,    30,  -111,  -111,  -111,
      31,     0,     0,     0,    32,     0,    33,    34,     0,    35,
      36,    37,    38,    39,    40,     0,    41,    42,     0,     0,
       0,     0,    43,     0,     0,    44,    45,    46,    47,     0,
       0,    48,    49,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    50,     0,     0,    51,     0,     0,     0,
       0,     0,     0,     0,     0,    52,    53,     0,     0,     0,
       0,     0,    54,    55,     0,     0,     0,     0,     0,    56,
     -15,    57,     0,     0,    58,    59,     2,     0,     3,     4,
       5,     6,     0,     8,     0,     0,     9,    10,    11,    12,
      13,    14,    15,     0,     0,     0,    16,    17,   454,    19,
      20,    21,  -121,    22,    23,    24,    25,     0,    26,    27,
       0,    28,    29,    30,     0,     0,     0,    31,     0,     0,
    -121,    32,  -121,    33,    34,     0,    35,    36,    37,    38,
      39,    40,     0,    41,    42,     0,     0,     0,     0,    43,
       0,     0,    44,    45,    46,    47,     0,     0,    48,    49,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      50,     0,     0,    51,     0,     0,     0,     0,     0,     0,
       0,     0,    52,    53,     0,     0,     0,     0,     0,    54,
      55,     0,     0,     0,     0,     0,    56,   -15,    57,     0,
       0,    58,    59,     2,     0,     3,     4,     5,     6,     0,
       8,     0,     0,     9,    10,    11,    12,    13,    14,    15,
       0,     0,     0,    16,    17,   454,    19,    20,    21,   -73,
      22,    23,    24,    25,     0,    26,    27,     0,    28,    29,
      30,     0,     0,     0,    31,     0,     0,     0,    32,     0,
      33,    34,     0,    35,    36,    37,    38,    39,    40,     0,
      41,    42,     0,     0,     0,     0,    43,   -73,     0,    44,
      45,    46,    47,     0,     0,    48,    49,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    50,     0,     0,
      51,     0,     0,     0,     0,     0,     0,     0,     0,    52,
      53,     0,     0,     0,     0,     0,    54,    55,     0,     0,
       0,     0,     0,    56,   -15,    57,     0,     0,    58,    59,
       2,     0,     3,     4,     5,     6,     0,     8,     0,     0,
       9,    10,    11,    12,    13,    14,    15,     0,     0,     0,
      16,    17,   454,    19,    20,    21,   500,    22,    23,    24,
      25,   501,    26,    27,     0,    28,    29,    30,     0,     0,
       0,    31,     0,     0,     0,    32,     0,    33,    34,     0,
      35,    36,    37,    38,    39,    40,     0,    41,    42,     0,
       0,     0,     0,    43,     0,     0,    44,    45,    46,    47,
       0,     0,    48,    49,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    50,     0,     0,    51,     0,     0,
       0,     0,     0,     0,     0,     0,    52,    53,     0,     0,
       0,     0,     0,    54,    55,     0,     0,     0,     0,     0,
      56,   -15,    57,     0,     0,    58,    59,     2,     0,     3,
       4,     5,     6,     0,     8,     0,     0,     9,    10,    11,
      12,    13,    14,    15,     0,     0,     0,    16,    17,   454,
      19,    20,    21,   610,    22,    23,    24,    25,     0,    26,
      27,     0,    28,    29,    30,     0,     0,     0,    31,     0,
       0,     0,    32,     0,    33,    34,     0,    35,    36,    37,
      38,    39,    40,     0,    41,    42,     0,     0,   611,     0,
      43,     0,     0,    44,    45,    46,    47,     0,     0,    48,
      49,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    50,     0,     0,    51,     0,     0,     0,     0,     0,
       0,     0,     0,    52,    53,     0,     0,     0,     0,     0,
      54,    55,     0,     0,     0,     0,     0,    56,   -15,    57,
       0,     0,    58,    59,     2,     0,     3,     4,     5,     6,
       0,     8,     0,     0,     9,    10,    11,    12,    13,    14,
      15,     0,     0,     0,    16,    17,   454,    19,    20,    21,
    -113,    22,    23,    24,    25,     0,    26,    27,     0,    28,
      29,    30,  -113,     0,     0,    31,     0,     0,     0,    32,
       0,    33,    34,     0,    35,    36,    37,    38,    39,    40,
       0,    41,    42,     0,     0,     0,     0,    43,     0,     0,
      44,    45,    46,    47,     0,     0,    48,    49,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    50,     0,
       0,    51,     0,     0,     0,     0,     0,     0,     0,     0,
      52,    53,     0,     0,     0,     0,     0,    54,    55,     0,
       0,     0,     0,     0,    56,   -15,    57,     0,     0,    58,
      59,     2,     0,     3,     4,     5,     6,     0,     8,     0,
       0,     9,    10,    11,    12,    13,    14,    15,     0,     0,
       0,    16,    17,   454,    19,    20,    21,  -100,    22,    23,
      24,    25,     0,    26,    27,     0,    28,    29,    30,     0,
       0,     0,    31,     0,     0,     0,    32,     0,    33,    34,
       0,    35,    36,    37,    38,    39,    40,     0,    41,    42,
       0,     0,     0,     0,    43,     0,     0,    44,    45,    46,
      47,     0,     0,    48,    49,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    50,     0,     0,    51,     0,
       0,     0,     0,     0,     0,     0,     0,    52,    53,     0,
       0,     0,     0,     0,    54,    55,     0,     0,     0,     0,
       0,    56,   -15,    57,     0,     0,    58,    59,     3,     4,
       5,    77,     0,     8,   173,   174,   175,   176,   177,   178,
       0,   179,   180,   181,   182,     0,     0,     0,     0,    78,
       0,    21,     0,    22,    23,     0,     0,     0,     0,     0,
       0,     0,    79,    30,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    35,    36,    37,    38,
      39,    40,   420,    41,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    45,     0,     0,     0,     0,    48,    49,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      50,     0,     0,    51,     3,     4,     5,    77,     0,     8,
       0,     0,    52,    53,     0,     0,     0,     0,     0,    54,
      55,     0,     0,     0,     0,    78,    56,    21,    80,    22,
      23,    58,    59,     0,     0,     0,     0,     0,    79,    30,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    35,    36,    37,    38,    39,    40,     0,    41,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    45,
       0,     0,     0,     0,    48,    49,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    50,     0,     0,    51,
       3,     4,     5,    77,     0,     8,     0,     0,    52,    53,
       0,     0,     0,     0,     0,    54,    55,     0,     0,     0,
       0,    78,    56,    21,    80,    22,    23,    58,    59,     0,
       0,     0,     0,     0,    79,    30,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    35,    36,
      37,    38,    39,    40,     0,    41,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    45,     0,     0,     0,     0,
      48,    49,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    50,     0,     0,    51,     0,     0,     0,   570,
       0,     0,     0,     0,    52,    53,     0,     0,     0,     0,
       0,    54,    55,     0,     0,     0,     0,     0,    56,     0,
     104,     0,   470,    58,    59,   163,   164,     0,   165,   166,
     167,   168,   169,   170,   212,   172,   173,   174,   175,   176,
     177,   178,     0,   179,   180,   181,   182,   163,   164,     0,
     165,   166,   167,   168,   169,   170,   212,   172,   173,   174,
     175,   176,   177,   178,     0,   179,   180,   181,   182,   163,
     164,     0,   165,   166,   167,   168,   169,   170,   212,   172,
     173,   174,   175,   176,   177,   178,     0,   179,   180,   181,
     182,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   163,   164,   245,   165,   166,   167,   168,   169,   170,
     212,   172,   173,   174,   175,   176,   177,   178,     0,   179,
     180,   181,   182,     0,     0,     0,     0,   163,   164,   246,
     165,   166,   167,   168,   169,   170,   212,   172,   173,   174,
     175,   176,   177,   178,     0,   179,   180,   181,   182,     0,
       0,     0,     0,   163,   164,  -303,   165,   166,   167,   168,
     169,   170,   212,   172,   173,   174,   175,   176,   177,   178,
       0,   179,   180,   181,   182,     0,     0,     0,     0,   163,
     164,   376,   165,   166,   167,   168,   169,   170,   212,   172,
     173,   174,   175,   176,   177,   178,     0,   179,   180,   181,
     182,     0,     0,     0,     0,   163,   164,   418,   165,   166,
     167,   168,   169,   170,   212,   172,   173,   174,   175,   176,
     177,   178,     0,   179,   180,   181,   182,     0,     0,   163,
     164,   239,   165,   166,   167,   168,   169,   170,   212,   172,
     173,   174,   175,   176,   177,   178,     0,   179,   180,   181,
     182,     0,     0,   163,   164,   242,   165,   166,   167,   168,
     169,   170,   212,   172,   173,   174,   175,   176,   177,   178,
       0,   179,   180,   181,   182,     0,     0,   163,   164,   353,
     165,   166,   167,   168,   169,   170,   212,   172,   173,   174,
     175,   176,   177,   178,     0,   179,   180,   181,   182,     0,
       0,   163,   164,   505,   165,   166,   167,   168,   169,   170,
     212,   172,   173,   174,   175,   176,   177,   178,     0,   179,
     180,   181,   182,     0,     0,   163,   164,   603,   165,   166,
     167,   168,   169,   170,   171,   172,   173,   174,   175,   176,
     177,   178,     0,   179,   180,   181,   182,   163,   164,     0,
     165,   166,   167,   168,   169,   170,   212,   172,   173,   174,
     175,   176,   177,   178,     0,   179,   180,   181,   182,   164,
       0,   165,   166,   167,   168,   169,   170,   212,   172,   173,
     174,   175,   176,   177,   178,     0,   179,   180,   181,   182,
     165,   166,   167,   168,   169,   170,   212,   172,   173,   174,
     175,   176,   177,   178,     0,   179,   180,   181,   182
};

static const short yycheck[] =
{
       1,    91,   144,    44,    45,    95,   149,    97,     9,     1,
     252,   253,   250,    35,   324,     6,     6,     6,     6,     6,
       6,    50,   161,     6,     6,     6,    95,     6,    29,     6,
       6,    32,   270,   271,   102,     6,     6,    38,    39,   450,
     109,   115,     6,    44,    45,   119,     4,   114,   115,    50,
      51,    52,    53,    54,    55,   365,   195,     6,    59,     6,
      77,   353,    51,    52,   356,    51,    52,     6,    51,    52,
     209,    72,    51,    52,    75,    51,    52,    27,    95,     6,
      51,    52,     7,     6,     3,     4,   115,    12,    13,     6,
     107,     6,   115,   232,   116,   118,   507,    47,    99,   116,
     511,    27,   115,   104,    51,    52,   119,    26,     6,    28,
      29,   112,    51,    52,     6,   254,   115,   113,     6,    45,
       1,   120,   113,   113,   113,   116,   116,   116,   116,   116,
     113,   132,   113,   116,   116,   116,   113,   116,   380,   116,
     116,   113,   113,   113,    25,     1,   116,    28,   149,   113,
     108,   112,   116,     1,   446,     6,   157,   158,   159,     6,
     161,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   175,   176,   177,   178,   102,    98,
     104,   105,   106,   107,    51,    52,   113,    68,    69,   116,
     113,   192,    73,   116,   195,   196,   113,   435,   113,   116,
     201,   116,    58,    84,    51,    52,   119,    63,   209,    90,
      91,   212,   355,   505,    95,    63,    97,    98,   510,   457,
      76,   113,    58,    50,   116,   113,   267,    77,   116,   109,
     110,   232,    27,   113,    90,    91,   116,   114,   115,    95,
      76,    97,    90,    91,    39,    95,     6,    95,   391,    97,
      77,   252,   253,   254,     4,   256,     6,   107,   348,   398,
     115,   262,   263,   109,   110,   120,   267,   113,    95,   113,
     116,   272,   116,   115,   275,   121,     6,   569,   120,   160,
      12,    13,    14,    15,     6,   115,   109,   110,   118,   581,
     113,    23,   112,   116,   112,   115,    77,    78,    79,    80,
      81,    82,    83,   115,   113,   306,   307,   264,   120,   310,
     311,   603,   269,   115,    95,   115,   317,   318,   118,   320,
     321,   613,   113,   324,    35,   617,   115,   208,   109,   114,
     211,    75,    76,    65,     6,   116,   337,    43,    44,   340,
     341,   342,   113,    77,    78,    79,    80,    81,    82,    83,
     588,   589,   114,   115,   355,   114,   115,   358,     3,     4,
     503,    95,   114,   115,   365,   366,   104,   105,   106,   107,
      43,    44,   373,   121,   366,   101,   102,   103,    57,   380,
     113,    26,   116,    28,    29,   114,   115,     6,   531,   116,
     391,   392,   393,     6,   395,   396,   114,   398,   115,    77,
      78,    79,    80,    81,    82,    83,    77,    78,    79,    80,
      81,    82,    83,   114,   115,   114,   115,     6,   419,   561,
     562,   114,   115,     6,   305,   114,   115,   115,   309,   114,
     115,   109,   114,   115,    12,    13,    40,    41,   116,   114,
     115,   442,   112,   444,    95,   116,   114,   115,   114,   115,
     442,   332,   444,   334,    77,    78,    79,    80,    81,    82,
      83,   114,   115,   344,   114,   115,   113,   348,     6,   470,
       6,   352,    95,   114,   115,   114,   115,   478,   479,   115,
     481,   482,   115,   484,   485,   366,   487,   488,   344,    33,
      34,   115,   348,   374,   114,   113,   344,   114,    95,   114,
     348,   109,   503,   182,   107,   506,     6,   186,     6,     6,
     366,   113,   112,   112,   506,   194,   114,    66,   366,   109,
     199,    70,   523,   524,   109,   526,   527,   121,   115,   115,
     531,   112,   112,    82,     6,   214,    85,   114,     6,    27,
     114,   112,   423,    66,   112,    77,    78,    79,    80,    81,
      82,    83,   114,   554,   112,   556,   112,   558,   112,     0,
     456,   442,   456,   444,   556,     1,   558,   620,   361,   570,
      76,   517,   573,   574,    49,   576,   577,   109,   138,   352,
     228,   113,   220,   344,    47,   112,   442,    -1,   444,   590,
     591,   592,    -1,   511,   442,   187,   444,    -1,   265,    -1,
     592,   602,   483,   282,    -1,    -1,   198,    -1,   200,    -1,
     602,    -1,   493,   614,   615,   616,    -1,    -1,    -1,   620,
      -1,    -1,   623,    -1,   616,   506,    -1,    -1,   620,    -1,
      -1,   623,    -1,    -1,   183,    -1,    -1,    -1,   187,    -1,
      -1,    -1,    77,    78,    79,    80,    81,    82,    83,   198,
     506,   200,    -1,    -1,    -1,    -1,    -1,    -1,   506,   338,
      95,    -1,    -1,    -1,   213,    -1,   215,    -1,    -1,    -1,
     349,   106,   107,    -1,    -1,   556,    -1,   558,   113,    -1,
      77,    78,    79,    80,    81,    82,    83,    -1,    -1,   281,
      -1,   283,    -1,    -1,    -1,    -1,    -1,    -1,    95,    -1,
     556,    -1,   558,    -1,    -1,    -1,    -1,    -1,   556,    -1,
     558,   592,   109,    -1,    -1,    -1,   113,    -1,    -1,    -1,
      -1,   602,   401,    -1,    -1,    -1,    -1,    -1,   407,    -1,
     586,    -1,   281,    -1,   283,   616,   592,    -1,   586,   620,
      -1,    -1,   623,    -1,   592,    -1,   602,    -1,     3,     4,
       5,     6,   431,     8,   602,    -1,    -1,    -1,    -1,    -1,
     616,   440,    -1,    -1,   620,    -1,    -1,   623,   616,    24,
      -1,    26,   620,    28,    29,   623,   325,   326,    -1,    -1,
     329,   330,    37,    38,   463,    -1,    -1,    -1,    77,    78,
      79,    80,    81,    82,    83,    -1,    51,    52,    53,    54,
      55,    56,    -1,    58,    -1,    -1,    95,    -1,   400,    -1,
     402,    -1,   491,    68,   406,    -1,   408,    -1,    73,    74,
     109,    -1,    -1,    77,    78,    79,    80,    81,    82,    83,
      85,    -1,    -1,    88,    77,    78,    79,    80,    81,    82,
      83,    -1,    97,    98,    -1,    -1,    -1,    -1,    -1,   104,
     105,   400,    95,   402,    -1,   109,   111,   406,   113,   408,
     539,   116,   117,    -1,   119,    -1,    -1,    -1,    -1,   548,
     462,    -1,   464,    -1,    -1,   424,   425,    -1,   427,   428,
      -1,    -1,     3,     4,     5,     6,    -1,     8,    -1,    77,
      78,    79,    80,    81,    82,    83,    77,    78,    79,    80,
      81,    82,    83,    24,    -1,    26,    -1,    28,    29,    -1,
      -1,    -1,    -1,   462,    -1,   464,    37,    38,   106,   107,
      -1,    99,   100,   101,   102,   113,   104,   105,   106,   107,
      51,    52,    53,    54,    55,    56,    57,    58,    -1,    -1,
      -1,   490,    -1,   492,    -1,    -1,   538,    68,   540,    -1,
       9,    -1,    73,    74,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    85,    -1,    -1,    88,    -1,    -1,
      -1,    -1,    -1,    -1,   566,    -1,    97,    98,    -1,    -1,
      -1,    -1,    -1,   104,   105,    -1,    -1,    -1,    -1,   538,
     111,   540,   113,    -1,    -1,   116,   117,    -1,   547,    -1,
     549,    -1,    -1,    -1,    -1,    -1,   598,    -1,    -1,    -1,
      -1,    97,    98,    99,   100,   101,   102,   566,   104,   105,
     106,   107,    -1,    -1,    -1,    -1,   112,    86,    87,   578,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,    -1,   104,   105,   106,   107,   598,
       0,     1,   601,     3,     4,     5,     6,     7,     8,    -1,
      -1,    11,    12,    13,    14,    15,    16,    17,    -1,    -1,
      -1,    21,    22,    23,    24,    25,    26,    -1,    28,    29,
      30,    31,    -1,    33,    34,    -1,    36,    37,    38,    -1,
      -1,    -1,    42,    -1,    -1,    -1,    46,    -1,    48,    49,
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
      33,    34,    -1,    36,    37,    38,    39,    40,    41,    42,
      -1,    -1,    -1,    46,    -1,    48,    49,    -1,    51,    52,
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
      36,    37,    38,    -1,    -1,    -1,    42,    43,    44,    45,
      46,    -1,    48,    49,    -1,    51,    52,    53,    54,    55,
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
      -1,    -1,    -1,    42,    43,    44,    -1,    46,    47,    48,
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
      -1,    33,    34,    -1,    36,    37,    38,    39,    40,    41,
      42,    -1,    -1,    -1,    46,    -1,    48,    49,    -1,    51,
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
      45,    46,    47,    48,    49,    -1,    51,    52,    53,    54,
      55,    56,    -1,    58,    59,    -1,    -1,    -1,    -1,    64,
      -1,    -1,    67,    68,    69,    70,    -1,    -1,    73,    74,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      85,    -1,    -1,    88,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    97,    98,    -1,    -1,    -1,    -1,    -1,   104,
     105,    -1,    -1,    -1,    -1,    -1,   111,   112,   113,    -1,
      -1,   116,   117,     1,    -1,     3,     4,     5,     6,    -1,
       8,    -1,    -1,    11,    12,    13,    14,    15,    16,    17,
      -1,    -1,    -1,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    -1,    33,    34,    -1,    36,    37,
      38,    -1,    -1,    -1,    42,    -1,    -1,    -1,    46,    -1,
      48,    49,    -1,    51,    52,    53,    54,    55,    56,    -1,
      58,    59,    -1,    -1,    -1,    -1,    64,    65,    -1,    67,
      68,    69,    70,    -1,    -1,    73,    74,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    85,    -1,    -1,
      88,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    97,
      98,    -1,    -1,    -1,    -1,    -1,   104,   105,    -1,    -1,
      -1,    -1,    -1,   111,   112,   113,    -1,    -1,   116,   117,
       1,    -1,     3,     4,     5,     6,    -1,     8,    -1,    -1,
      11,    12,    13,    14,    15,    16,    17,    -1,    -1,    -1,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    -1,    36,    37,    38,    -1,    -1,
      -1,    42,    -1,    -1,    -1,    46,    -1,    48,    49,    -1,
      51,    52,    53,    54,    55,    56,    -1,    58,    59,    -1,
      -1,    -1,    -1,    64,    -1,    -1,    67,    68,    69,    70,
      -1,    -1,    73,    74,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    85,    -1,    -1,    88,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    97,    98,    -1,    -1,
      -1,    -1,    -1,   104,   105,    -1,    -1,    -1,    -1,    -1,
     111,   112,   113,    -1,    -1,   116,   117,     1,    -1,     3,
       4,     5,     6,    -1,     8,    -1,    -1,    11,    12,    13,
      14,    15,    16,    17,    -1,    -1,    -1,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    -1,    33,
      34,    -1,    36,    37,    38,    -1,    -1,    -1,    42,    -1,
      -1,    -1,    46,    -1,    48,    49,    -1,    51,    52,    53,
      54,    55,    56,    -1,    58,    59,    -1,    -1,    62,    -1,
      64,    -1,    -1,    67,    68,    69,    70,    -1,    -1,    73,
      74,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    85,    -1,    -1,    88,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    97,    98,    -1,    -1,    -1,    -1,    -1,
     104,   105,    -1,    -1,    -1,    -1,    -1,   111,   112,   113,
      -1,    -1,   116,   117,     1,    -1,     3,     4,     5,     6,
      -1,     8,    -1,    -1,    11,    12,    13,    14,    15,    16,
      17,    -1,    -1,    -1,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    31,    -1,    33,    34,    -1,    36,
      37,    38,    39,    -1,    -1,    42,    -1,    -1,    -1,    46,
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
      30,    31,    -1,    33,    34,    -1,    36,    37,    38,    -1,
      -1,    -1,    42,    -1,    -1,    -1,    46,    -1,    48,    49,
      -1,    51,    52,    53,    54,    55,    56,    -1,    58,    59,
      -1,    -1,    -1,    -1,    64,    -1,    -1,    67,    68,    69,
      70,    -1,    -1,    73,    74,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    85,    -1,    -1,    88,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    97,    98,    -1,
      -1,    -1,    -1,    -1,   104,   105,    -1,    -1,    -1,    -1,
      -1,   111,   112,   113,    -1,    -1,   116,   117,     3,     4,
       5,     6,    -1,     8,    97,    98,    99,   100,   101,   102,
      -1,   104,   105,   106,   107,    -1,    -1,    -1,    -1,    24,
      -1,    26,    -1,    28,    29,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    37,    38,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    51,    52,    53,    54,
      55,    56,    57,    58,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    68,    -1,    -1,    -1,    -1,    73,    74,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      85,    -1,    -1,    88,     3,     4,     5,     6,    -1,     8,
      -1,    -1,    97,    98,    -1,    -1,    -1,    -1,    -1,   104,
     105,    -1,    -1,    -1,    -1,    24,   111,    26,   113,    28,
      29,   116,   117,    -1,    -1,    -1,    -1,    -1,    37,    38,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    51,    52,    53,    54,    55,    56,    -1,    58,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    68,
      -1,    -1,    -1,    -1,    73,    74,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    85,    -1,    -1,    88,
       3,     4,     5,     6,    -1,     8,    -1,    -1,    97,    98,
      -1,    -1,    -1,    -1,    -1,   104,   105,    -1,    -1,    -1,
      -1,    24,   111,    26,   113,    28,    29,   116,   117,    -1,
      -1,    -1,    -1,    -1,    37,    38,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    51,    52,
      53,    54,    55,    56,    -1,    58,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    68,    -1,    -1,    -1,    -1,
      73,    74,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    85,    -1,    -1,    88,    -1,    -1,    -1,    60,
      -1,    -1,    -1,    -1,    97,    98,    -1,    -1,    -1,    -1,
      -1,   104,   105,    -1,    -1,    -1,    -1,    -1,   111,    -1,
     113,    -1,    61,   116,   117,    86,    87,    -1,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,    -1,   104,   105,   106,   107,    86,    87,    -1,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,    -1,   104,   105,   106,   107,    86,
      87,    -1,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,    -1,   104,   105,   106,
     107,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    86,    87,   120,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,    -1,   104,
     105,   106,   107,    -1,    -1,    -1,    -1,    86,    87,   114,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,    -1,   104,   105,   106,   107,    -1,
      -1,    -1,    -1,    86,    87,   114,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
      -1,   104,   105,   106,   107,    -1,    -1,    -1,    -1,    86,
      87,   114,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,    -1,   104,   105,   106,
     107,    -1,    -1,    -1,    -1,    86,    87,   114,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,    -1,   104,   105,   106,   107,    -1,    -1,    86,
      87,   112,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,    -1,   104,   105,   106,
     107,    -1,    -1,    86,    87,   112,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
      -1,   104,   105,   106,   107,    -1,    -1,    86,    87,   112,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,    -1,   104,   105,   106,   107,    -1,
      -1,    86,    87,   112,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,    -1,   104,
     105,   106,   107,    -1,    -1,    86,    87,   112,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,    -1,   104,   105,   106,   107,    86,    87,    -1,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,    -1,   104,   105,   106,   107,    87,
      -1,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,   102,    -1,   104,   105,   106,   107,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,    -1,   104,   105,   106,   107
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
#line 503 "clic.y"
{ ;
    break;}
case 2:
#line 527 "clic.y"
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
#line 536 "clic.y"
{
			if (curFunction==curFile->main)
				append_Node(curFile->ctext, new_LangNode(yyvsp[0].string));
			else
				append_Node(curFunction->body, new_LangNode(yyvsp[0].string));
		;
    break;}
case 4:
#line 543 "clic.y"
{
			append_Node(curFile->ctextStatic, new_LangNode(yyvsp[0].string));
		;
    break;}
case 5:
#line 547 "clic.y"
{yyval.i=1; lex_vardef(1);;
    break;}
case 6:
#line 548 "clic.y"
{yyval.i=0; lex_vardef(1);;
    break;}
case 7:
#line 551 "clic.y"
{yyval.i=1;lex_vardef(1);;
    break;}
case 8:
#line 552 "clic.y"
{yyval.i=0;lex_vardef(1);;
    break;}
case 9:
#line 553 "clic.y"
{yyval.i=2;lex_vardef(1);;
    break;}
case 10:
#line 554 "clic.y"
{yyval.i=3;lex_vardef(1);;
    break;}
case 11:
#line 557 "clic.y"
{yyval.varcoll=new_VarColl();;
    break;}
case 12:
#line 558 "clic.y"
{ yyval.varcoll=yyvsp[-1].varcoll;;
    break;}
case 13:
#line 561 "clic.y"
{ yyval.node=new_OperListNode(); push_operlist(yyval.node); ;
    break;}
case 14:
#line 563 "clic.y"
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
#line 574 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 16:
#line 576 "clic.y"
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
#line 590 "clic.y"
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
#line 603 "clic.y"
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
#line 624 "clic.y"
{
			lex_vardef(1);
			def_node=new_LocalDefNode1;
		;
    break;}
case 20:
#line 629 "clic.y"
{
			/*$$=new_LocalDefNode($3, 1);*/
			yyval.node=NULL;
			lex_vardef(0); CM;
			def_node=0;
		;
    break;}
case 21:
#line 636 "clic.y"
{
			lex_vardef(1);
			def_node = new_StaticDefNode;
		;
    break;}
case 22:
#line 641 "clic.y"
{
			/*$$=new_StaticDefNode($3);*/
			yyval.node=NULL;
			lex_vardef(0);
			def_node=0;
		;
    break;}
case 23:
#line 648 "clic.y"
{
			def_node = new_PublicDefNode;
		;
    break;}
case 24:
#line 652 "clic.y"
{
			/*$$=new_PublicDefNode($2);*/
			yyval.node=NULL;
			CM;
			def_node=0;
		;
    break;}
case 25:
#line 659 "clic.y"
{
			def_node = new_PrivateDefNode;
		;
    break;}
case 26:
#line 663 "clic.y"
{
			/*$$=new_PrivateDefNode($2);*/
			yyval.node=NULL;
			CM;
			def_node=0;
		;
    break;}
case 27:
#line 670 "clic.y"
{
			def_node = new_PrivateDefNode;
		;
    break;}
case 28:
#line 674 "clic.y"
{
			/*$$=new_PrivateDefNode($2);*/
			yyval.node=NULL;
			CM;
			def_node=0;
		;
    break;}
case 29:
#line 691 "clic.y"
{ yyval.node=new_MemvarDefNode(yyvsp[0].varcoll); ;
    break;}
case 30:
#line 692 "clic.y"
{ yyval.node=new_FieldDefNode(yyvsp[-1].varcoll, yyvsp[0].string); ;
    break;}
case 31:
#line 693 "clic.y"
{ yyval.node=new_ParametersDefNode(yyvsp[0].varcoll); CM;;
    break;}
case 32:
#line 694 "clic.y"
{ yyval.node=new_ReturnNode(NULL,0); CM;;
    break;}
case 33:
#line 695 "clic.y"
{ yyval.node=new_ReturnNode(yyvsp[0].node,0); CM;;
    break;}
case 34:
#line 698 "clic.y"
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
#line 709 "clic.y"
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
#line 719 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 37:
#line 723 "clic.y"
{ CM;yyval.node=new_OperExprNode(new_AssignNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;
    break;}
case 38:
#line 724 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 39:
#line 725 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 40:
#line 726 "clic.y"
{ CM; yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 41:
#line 727 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 42:
#line 728 "clic.y"
{CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,NULL,yyvsp[-2].string,0,yyvsp[0].node));;
    break;}
case 43:
#line 729 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 44:
#line 731 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 45:
#line 732 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,0, yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 46:
#line 733 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-7].node,0,yyvsp[-3].node,yyvsp[0].node)); ;
    break;}
case 47:
#line 734 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 48:
#line 735 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-5].node,0, yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 49:
#line 736 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-7].node,0,yyvsp[-3].node,yyvsp[0].node)); ;
    break;}
case 50:
#line 738 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 51:
#line 739 "clic.y"
{CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,NULL,0,yyvsp[-2].node,yyvsp[0].node));;
    break;}
case 52:
#line 740 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 53:
#line 741 "clic.y"
{ CM;yyval.node=new_OperExprNode(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 54:
#line 743 "clic.y"
{ CM;yyval.node=new_OperExprNode(new_AssignNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;
    break;}
case 55:
#line 744 "clic.y"
{ CM;yyval.node=new_OperExprNode(new_AssignNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;
    break;}
case 56:
#line 745 "clic.y"
{ CM;yyval.node=new_OperExprNode(new_ArrElNode(yyvsp[-2].node,yyvsp[0].node,'=')); ;
    break;}
case 57:
#line 746 "clic.y"
{ yyval.node=new_OperExprNode(yyvsp[0].node); CM;;
    break;}
case 58:
#line 747 "clic.y"
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
case 59:
#line 761 "clic.y"
{ yyval.node=new_OperExprNode(new_AssignNode(new_MacroNode(yyvsp[-3].node,0),yyvsp[0].node,'=')); ;
    break;}
case 60:
#line 764 "clic.y"
{ CM;
			if (!curFunction->inLoop)
				{ loop_line = cl_line; loop_file = currentFile(); }
			curFunction->inLoop++;
		;
    break;}
case 61:
#line 770 "clic.y"
{
			curFunction->inLoop--;
			yyval.node=new_WhileNode(yyvsp[-3].node,yyvsp[-1].node);
			pop_operlist();
		;
    break;}
case 62:
#line 776 "clic.y"
{ CM; yyval.node = new_OperExprNode(new_CallNode(yyvsp[-1].string, yyvsp[0].arglist.coll, yyvsp[0].arglist.haveRest)); ;
    break;}
case 63:
#line 778 "clic.y"
{ CM; yyval.node = new_OperExprNode(new_CallNameNode(yyvsp[-1].node, yyvsp[0].arglist.coll)); ;
    break;}
case 64:
#line 780 "clic.y"
{ CM; yyval.node = new_OperExprNode(new_CallNode(yyvsp[-1].string, yyvsp[0].arglist.coll, yyvsp[0].arglist.haveRest)); ;
    break;}
case 65:
#line 782 "clic.y"
{ CM; yyval.node = new_OperExprNode(new_CallNameNode(yyvsp[-1].node, yyvsp[0].arglist.coll)); ;
    break;}
case 66:
#line 784 "clic.y"
{
			CM;
			if (!curFunction->inLoop)
				yyerror("EXIT statement out of loop");
			yyval.node=new_LoopExitNode(0);
		;
    break;}
case 67:
#line 791 "clic.y"
{
			CM;
			if (!curFunction->inLoop)
				yyerror("LOOP statement out of loop");
			yyval.node=new_LoopExitNode(1);
		;
    break;}
case 68:
#line 798 "clic.y"
{ lex_initial(); ;
    break;}
case 69:
#line 799 "clic.y"
{
			curFunction->inLoop--;
			yyval.node=new_ForNode(yyvsp[-9].node,yyvsp[-7].node,yyvsp[-5].node,yyvsp[-4].node,yyvsp[-1].node);
			pop_operlist();
		;
    break;}
case 70:
#line 805 "clic.y"
{ lex_initial(); ;
    break;}
case 71:
#line 806 "clic.y"
{
			curFunction->inLoop--;
			yyval.node=new_ForeachNode(yyvsp[-7].node,yyvsp[-5].node,yyvsp[-1].node,yyvsp[-4].i);
			pop_operlist();
		;
    break;}
case 72:
#line 812 "clic.y"
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
case 73:
#line 825 "clic.y"
{
			pop_operlist();
		;
    break;}
case 74:
#line 829 "clic.y"
{
			CM;
			yyval.node=new_SeqNode(yyvsp[-3].node,yyvsp[-1].recover.using,yyvsp[-1].recover.operlist,yyvsp[-1].recover.curseq);
		;
    break;}
case 75:
#line 835 "clic.y"
{  CM; yyval.node=new_BreakNode(yyvsp[0].node, 1); ;
    break;}
case 76:
#line 838 "clic.y"
{
			Coll *cp=new_Coll(NULL,NULL);
			append_Coll(cp,yyvsp[-5].node);
			append_Coll(cp,yyvsp[-3].node);
			yyval.node=new_OperExprNode(new_IfNode(cp,yyvsp[-1].node));
			CM;
		;
    break;}
case 77:
#line 847 "clic.y"
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
case 78:
#line 861 "clic.y"
{
			CM;
			prepend_Coll(yyvsp[-2].coll,yyvsp[-3].node);
			prepend_Coll(yyvsp[-2].coll,yyvsp[-6].node);
			yyval.node=new_IfNode( yyvsp[-2].coll, yyvsp[-1].node);
			if_depth--;
			pop_operlist();
		;
    break;}
case 79:
#line 871 "clic.y"
{
			CM;
			yyval.node=new_IfNode( yyvsp[-2].coll, yyvsp[-1].node);
		;
    break;}
case 80:
#line 877 "clic.y"
{
			yyval.node=new_SwitchNode(yyvsp[-4].node, yyvsp[-2].coll, yyvsp[-1].node);
		;
    break;}
case 81:
#line 882 "clic.y"
{ yyval.string=0; ;
    break;}
case 82:
#line 883 "clic.y"
{ yyval.string=yyvsp[0].string; ;
    break;}
case 83:
#line 884 "clic.y"
{ yyval.string=yyvsp[0].string; ;
    break;}
case 85:
#line 889 "clic.y"
{
			SwitchEl *nl = NEW(SwitchEl);
			nl->labels = yyvsp[-2].coll;
			nl->operlist = yyvsp[0].node;
			insert_Coll(yyvsp[-3].coll, nl);
			yyval.coll = yyvsp[-3].coll;
			pop_operlist();
		;
    break;}
case 86:
#line 899 "clic.y"
{
			yyval.coll = new_Coll(0, 0);
		;
    break;}
case 88:
#line 906 "clic.y"
{
			yyval.coll = new_Coll(0,0);
			append_Coll(yyval.coll, yyvsp[0].node);
		;
    break;}
case 89:
#line 911 "clic.y"
{
			yyval.coll = yyvsp[-2].coll;
			append_Coll(yyval.coll, yyvsp[0].node);
		;
    break;}
case 90:
#line 918 "clic.y"
{  CM;
			if (!curFunction->inLoop)
				{ loop_line = cl_line; loop_file = currentFile(); }
			curFunction->inLoop++;
		;
    break;}
case 93:
#line 929 "clic.y"
{ yyval.i = 0; ;
    break;}
case 94:
#line 930 "clic.y"
{ yyval.i = 1; ;
    break;}
case 95:
#line 933 "clic.y"
{;
    break;}
case 96:
#line 934 "clic.y"
{;
    break;}
case 97:
#line 937 "clic.y"
{
			yyval.recover.curseq = curFunction->seqNo;
			yyval.recover.operlist = 0;
			yyval.recover.using = 0;
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
		;
    break;}
case 98:
#line 945 "clic.y"
{
			yyerror("unclosed BEGIN SEQUENCE");
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
			YYERROR;
		;
    break;}
case 99:
#line 952 "clic.y"
{
			curFunction->seqNo=curFunction->seqStack[curFunction->seqLevel-1];
			curFunction->seqLevel--;
		;
    break;}
case 100:
#line 957 "clic.y"
{
			yyval.recover.operlist = yyvsp[0].node;
			yyval.recover.using = yyvsp[-3].node;
			yyval.recover.curseq = yyvsp[-4].i;
			pop_operlist();
		;
    break;}
case 101:
#line 965 "clic.y"
{yyval.i = curFunction->seqNo; ;
    break;}
case 102:
#line 968 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 103:
#line 969 "clic.y"
{ yyval.node=yyvsp[0].node; ;
    break;}
case 104:
#line 972 "clic.y"
{ yyval.node=new_NumberConstNode(strdup("1"),0); ;
    break;}
case 105:
#line 973 "clic.y"
{ yyval.node=yyvsp[0].node; ;
    break;}
case 110:
#line 984 "clic.y"
{ yyval.coll=new_Coll(NULL,NULL); ;
    break;}
case 111:
#line 986 "clic.y"
{
			yyval.coll=yyvsp[-4].coll;
			append_Coll(yyval.coll, yyvsp[-2].node);
			append_Coll(yyval.coll, yyvsp[0].node);
			pop_operlist();
		;
    break;}
case 112:
#line 994 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 113:
#line 996 "clic.y"
{
			yyval.node=yyvsp[0].node;
			pop_operlist();
		;
    break;}
case 116:
#line 1006 "clic.y"
{ yyval.coll=new_Coll(NULL,NULL); ;
    break;}
case 119:
#line 1012 "clic.y"
{
			yyval.coll=yyvsp[-4].coll;
			append_Coll(yyval.coll, yyvsp[-2].node);
			append_Coll(yyval.coll, yyvsp[0].node);
			pop_operlist();
		;
    break;}
case 120:
#line 1020 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 121:
#line 1022 "clic.y"
{
			yyval.node=yyvsp[0].node;
			pop_operlist();
		;
    break;}
case 126:
#line 1036 "clic.y"
{ yyval.string=NULL; ;
    break;}
case 127:
#line 1037 "clic.y"
{ yyval.string=yyvsp[0].string; ;
    break;}
case 128:
#line 1040 "clic.y"
{ yyval.node=installName(yyvsp[0].string); ;
    break;}
case 129:
#line 1041 "clic.y"
{ yyval.node=new_MemvarNode(new_Var(yyvsp[0].string)); ;
    break;}
case 130:
#line 1044 "clic.y"
{ yyval.node=yyvsp[0].node; ;
    break;}
case 131:
#line 1047 "clic.y"
{ yyval.node=installName(yyvsp[0].string); ;
    break;}
case 132:
#line 1048 "clic.y"
{ yyval.node=new_MemvarNode(new_Var(yyvsp[0].string)); ;
    break;}
case 133:
#line 1049 "clic.y"
{ yyval.node=new2_FieldNode(NULL,NULL,yyvsp[0].string,NULL); ;
    break;}
case 134:
#line 1052 "clic.y"
{ yyval.node=new_MacroNode(yyvsp[0].node,0); ;
    break;}
case 135:
#line 1053 "clic.y"
{ yyval.node=new_MacroNode(yyvsp[-1].node,0); ;
    break;}
case 136:
#line 1054 "clic.y"
{ yyval.node=new_MacroNode(new_OpNode(new_StringConstNode(yyvsp[-2].string),yyvsp[0].node,'+'),0);  ;
    break;}
case 137:
#line 1055 "clic.y"
{ yyval.node=new_MacroNode(new_OpNode(yyvsp[-2].node,new_StringConstNode(yyvsp[0].string),'+'),0); ;
    break;}
case 138:
#line 1056 "clic.y"
{ char *s = yyvsp[0].string+strspn(yyvsp[0].string,",.-+");
			yyval.node=new_MacroNode(new_OpNode(yyvsp[-1].node,new_StringConstNode(s),'+'),0); ;
    break;}
case 139:
#line 1058 "clic.y"
{ yyval.node=new_MacroNode(yyvsp[-1].node,1); ;
    break;}
case 141:
#line 1062 "clic.y"
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
case 142:
#line 1084 "clic.y"
{
				Node *e1 = new_StringConstNode(yyvsp[-2].string);
				Node *e2 = new_StringConstNode(strdup(yyvsp[-2].string));
				yyval.node = new3_CallNode("_clic_ngettext", e1, e2, yyvsp[0].node);
			;
    break;}
case 143:
#line 1089 "clic.y"
{
				Coll *cp = new_Coll(0,0);
				append_Coll(cp, new_StringConstNode(yyvsp[0].string));
				yyval.node=new_CallNode(strdup("CTOD"), cp, 0);
			;
    break;}
case 146:
#line 1096 "clic.y"
{
		/*((ExprListNode*)$2)->last=1; ; */
		yyval.node=reduce_ExprListNode(yyvsp[-1].node);
		;
    break;}
case 147:
#line 1100 "clic.y"
{ yyval.node=new_RefNode(yyvsp[0].node); ;
    break;}
case 148:
#line 1102 "clic.y"
{ yyval.node=new_CallNode( yyvsp[-3].string, yyvsp[-1].arglist.coll, yyvsp[-1].arglist.haveRest); ;
    break;}
case 149:
#line 1103 "clic.y"
{ yyval.node=new_CallNameNode(yyvsp[-3].node,yyvsp[-1].arglist.coll); ;
    break;}
case 150:
#line 1105 "clic.y"
{ yyval.node=new_ArrElNode(yyvsp[0].node,NULL,0); ;
    break;}
case 151:
#line 1106 "clic.y"
{ yyval.node=new_AssignNode(yyvsp[-2].node,yyvsp[0].node,yyvsp[-1].i); ;
    break;}
case 152:
#line 1107 "clic.y"
{ yyval.node=new_ArrElNode(yyvsp[-2].node,yyvsp[0].node,yyvsp[-1].i); ;
    break;}
case 153:
#line 1108 "clic.y"
{ yyval.node=new_AssignNode(yyvsp[-2].node,yyvsp[0].node,yyvsp[-1].i); ;
    break;}
case 154:
#line 1110 "clic.y"
{ yyval.node=new_MethodNode(yyvsp[-5].node,yyvsp[-3].string,yyvsp[-1].arglist.coll, yyvsp[-1].arglist.haveRest); ;
    break;}
case 155:
#line 1112 "clic.y"
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
case 156:
#line 1126 "clic.y"
{
		add_self();
		yyval.node=new_MethodNode(installName(strdup("__SELF__")),yyvsp[-3].string,yyvsp[-1].arglist.coll, yyvsp[-1].arglist.haveRest);
		;
    break;}
case 157:
#line 1130 "clic.y"
{yyval.node=new2_FieldNode(NULL,NULL,yyvsp[0].string,NULL);;
    break;}
case 158:
#line 1131 "clic.y"
{yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,yyvsp[0].string,NULL); ;
    break;}
case 159:
#line 1132 "clic.y"
{ yyval.node=new2_FieldNode(NULL,NULL,NULL,yyvsp[0].node); ;
    break;}
case 160:
#line 1134 "clic.y"
{ yyval.node=yyvsp[-1].node; ;
    break;}
case 161:
#line 1137 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,yyvsp[0].string,NULL); ;
    break;}
case 162:
#line 1138 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,NULL,yyvsp[0].node); ;
    break;}
case 163:
#line 1139 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-4].string,NULL,NULL,reduce_ExprListNode(yyvsp[-1].node)); ;
    break;}
case 164:
#line 1140 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-4].string,NULL,NULL,reduce_ExprListNode(yyvsp[-1].node)); ;
    break;}
case 165:
#line 1141 "clic.y"
{ yyval.node=new2_FieldNode(yyvsp[-2].string,NULL,NULL,yyvsp[0].node); ;
    break;}
case 166:
#line 1143 "clic.y"
{yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-5].node),NULL,reduce_ExprListNode(yyvsp[-1].node));;
    break;}
case 167:
#line 1144 "clic.y"
{ yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),NULL,yyvsp[0].node); ;
    break;}
case 168:
#line 1145 "clic.y"
{ yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].string,NULL); ;
    break;}
case 169:
#line 1146 "clic.y"
{yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-5].node),NULL,reduce_ExprListNode(yyvsp[-1].node));;
    break;}
case 170:
#line 1147 "clic.y"
{ yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),NULL,yyvsp[0].node); ;
    break;}
case 171:
#line 1148 "clic.y"
{ yyval.node=new2_FieldNode(NULL,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].string,NULL); ;
    break;}
case 172:
#line 1150 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,yyvsp[0].string,NULL);;
    break;}
case 173:
#line 1152 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,yyvsp[0].string,NULL);;
    break;}
case 174:
#line 1153 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-4].node,NULL,reduce_ExprListNode(yyvsp[-1].node));;
    break;}
case 175:
#line 1154 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-4].node,NULL,reduce_ExprListNode(yyvsp[-1].node));;
    break;}
case 176:
#line 1155 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,NULL,yyvsp[0].node);;
    break;}
case 177:
#line 1156 "clic.y"
{yyval.node=new2_FieldNode(NULL,yyvsp[-2].node,NULL,yyvsp[0].node);;
    break;}
case 178:
#line 1158 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 179:
#line 1159 "clic.y"
{ CM; yyval.node=(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 180:
#line 1160 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i, yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 181:
#line 1161 "clic.y"
{CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,NULL,yyvsp[-2].string,0,yyvsp[0].node));;
    break;}
case 182:
#line 1162 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 183:
#line 1164 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 184:
#line 1165 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),0, yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 185:
#line 1166 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-7].node),0,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].node)); ;
    break;}
case 186:
#line 1167 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 187:
#line 1168 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-5].node),0, yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 188:
#line 1169 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,reduce_ExprListNode(yyvsp[-7].node),0,reduce_ExprListNode(yyvsp[-3].node),yyvsp[0].node)); ;
    break;}
case 189:
#line 1171 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,yyvsp[-2].string,0,yyvsp[0].node)); ;
    break;}
case 190:
#line 1172 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,yyvsp[-4].string,NULL,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 191:
#line 1173 "clic.y"
{CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,NULL,0,yyvsp[-2].node,yyvsp[0].node));;
    break;}
case 192:
#line 1174 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 193:
#line 1175 "clic.y"
{ CM;yyval.node=(assop_node(yyvsp[-1].i,NULL,yyvsp[-4].node,0,yyvsp[-2].node,yyvsp[0].node)); ;
    break;}
case 194:
#line 1177 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'e');  ;
    break;}
case 195:
#line 1178 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'E');  ;
    break;}
case 196:
#line 1179 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'N');  ;
    break;}
case 197:
#line 1180 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'<');  ;
    break;}
case 198:
#line 1181 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'>');  ;
    break;}
case 199:
#line 1182 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'L');  ;
    break;}
case 200:
#line 1183 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'G');  ;
    break;}
case 201:
#line 1184 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'+');  ;
    break;}
case 202:
#line 1185 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'$');  ;
    break;}
case 203:
#line 1187 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'-');  ;
    break;}
case 204:
#line 1188 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'*');  ;
    break;}
case 205:
#line 1189 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'/');  ;
    break;}
case 206:
#line 1190 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'%');  ;
    break;}
case 207:
#line 1191 "clic.y"
{ yyval.node=new_OpNode(yyvsp[-2].node,yyvsp[0].node,'^');  ;
    break;}
case 208:
#line 1192 "clic.y"
{ yyval.node=new_AndNode(yyvsp[-2].node,yyvsp[0].node);  ;
    break;}
case 209:
#line 1193 "clic.y"
{ yyval.node=new_OrNode(yyvsp[-2].node,yyvsp[0].node);  ;
    break;}
case 210:
#line 1195 "clic.y"
{ yyval.node=new_NotNode(yyvsp[0].node);  ;
    break;}
case 211:
#line 1197 "clic.y"
{ yyval.node=new_IncrNode(yyvsp[0].node,1,0); ;
    break;}
case 212:
#line 1198 "clic.y"
{ yyval.node=new_IncrNode(yyvsp[-1].node,1,1); ;
    break;}
case 213:
#line 1199 "clic.y"
{ yyval.node=new_IncrNode(yyvsp[0].node,0,0); ;
    break;}
case 214:
#line 1200 "clic.y"
{ yyval.node=new_IncrNode(yyvsp[-1].node,0,1); ;
    break;}
case 215:
#line 1201 "clic.y"
{ yyval.node=new_MinusNode(yyvsp[0].node); ;
    break;}
case 216:
#line 1202 "clic.y"
{ yyval.node=yyvsp[0].node; ;
    break;}
case 217:
#line 1204 "clic.y"
{yyval.node=new_ArrayInitNode(yyvsp[-1].node); ;
    break;}
case 218:
#line 1205 "clic.y"
{yyval.node=new_ArrayInitNode(yyvsp[-1].node); ;
    break;}
case 219:
#line 1206 "clic.y"
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
case 220:
#line 1227 "clic.y"
{ yyval.node=new_CGetNode(yyvsp[-1].coll); ;
    break;}
case 221:
#line 1228 "clic.y"
{ yyval.node=new_PcountNode(); ;
    break;}
case 222:
#line 1229 "clic.y"
{ yyval.node=new_PshiftNode(); ;
    break;}
case 223:
#line 1230 "clic.y"
{ yyval.node=new_ParnNode(yyvsp[-1].node); ;
    break;}
case 224:
#line 1231 "clic.y"
{ yyval.node=new_ParnNode(yyvsp[-1].node); ;
    break;}
case 225:
#line 1233 "clic.y"
{  curFunction->code_params=yyvsp[0].varcoll; ;
    break;}
case 226:
#line 1234 "clic.y"
{ yyval.node=new_CodestrNode(yyvsp[-1].node,0,yyvsp[-3].varcoll); curFunction->code_params=0; ;
    break;}
case 227:
#line 1235 "clic.y"
{  curFunction->code_params=yyvsp[0].varcoll; ;
    break;}
case 228:
#line 1236 "clic.y"
{ yyval.node=new_MacroNode(new_CodestrNode(yyvsp[-1].node,1,yyvsp[-3].varcoll),0); curFunction->code_params=0; ;
    break;}
case 229:
#line 1239 "clic.y"
{
			if (curFunction->upfunc)
				curFunction = curFunction->upfunc;
		;
    break;}
case 230:
#line 1244 "clic.y"
{
			Node *np;
			curFunction = yyvsp[-3].func;
			np = new_LocalDefNode(yyvsp[-1].varcoll, 0, 1);
			prepend_Node(curFunction->body, np);
			yyval.node = new_NilConstNode();
			CM;
		;
    break;}
case 231:
#line 1254 "clic.y"
{
			Coll *cp=new_Coll(NULL,NULL);
			append_Coll(cp,yyvsp[-5].node);
			append_Coll(cp,yyvsp[-3].node);
			yyval.node=new_IfNode(cp,yyvsp[-1].node);
		;
    break;}
case 232:
#line 1263 "clic.y"
{  yyval.node=new_BreakNode(yyvsp[-1].node,0); ;
    break;}
case 233:
#line 1267 "clic.y"
{ yyval.varcoll=0; ;
    break;}
case 234:
#line 1268 "clic.y"
{ yyval.varcoll=yyvsp[-1].varcoll; ;
    break;}
case 235:
#line 1271 "clic.y"
{ yyval.node=new_NilConstNode(); ;
    break;}
case 236:
#line 1272 "clic.y"
{ yyval.node=yyvsp[0].node; ;
    break;}
case 245:
#line 1289 "clic.y"
{ yyval.i='='; ;
    break;}
case 246:
#line 1290 "clic.y"
{ yyval.i='+'; ;
    break;}
case 247:
#line 1291 "clic.y"
{ yyval.i='-'; ;
    break;}
case 248:
#line 1292 "clic.y"
{ yyval.i='*'; ;
    break;}
case 249:
#line 1293 "clic.y"
{ yyval.i='/'; ;
    break;}
case 250:
#line 1294 "clic.y"
{ yyval.i='%'; ;
    break;}
case 251:
#line 1295 "clic.y"
{ yyval.i='^'; ;
    break;}
case 252:
#line 1298 "clic.y"
{ yyval.i='='; ;
    break;}
case 253:
#line 1302 "clic.y"
{ yyval.func=curFunction; ;
    break;}
case 254:
#line 1305 "clic.y"
{ yyval.node=new_CodeNode(yyvsp[-1].varcoll); ;
    break;}
case 255:
#line 1308 "clic.y"
{ yyval.node=yyvsp[-1].node; prepend_Node(yyvsp[-1].node,yyvsp[-3].node); ;
    break;}
case 256:
#line 1309 "clic.y"
{ yyval.node=yyvsp[-3].node; join_Node(yyvsp[-3].node,yyvsp[-1].node); ;
    break;}
case 257:
#line 1310 "clic.y"
{
		yyval.node=new_ExprListNode();
		append_Node(yyval.node, yyvsp[-2].node);
		upstr(yyvsp[0].string);
		append_Node(yyval.node, new_HashConstNode(yyvsp[0].string));
		;
    break;}
case 258:
#line 1316 "clic.y"
{
		yyval.node=new_ExprListNode();
		add_self();
		append_Node(yyval.node, installName(strdup("__SELF__")));
		upstr(yyvsp[0].string);
		append_Node(yyval.node, new_HashConstNode(yyvsp[0].string));
		;
    break;}
case 259:
#line 1323 "clic.y"
{
		yyval.node=yyvsp[-2].node;
		upstr(yyvsp[0].string);
		append_Node(yyval.node,new_HashConstNode(yyvsp[0].string));
	;
    break;}
case 260:
#line 1330 "clic.y"
{
			yyval.varcoll=new_VarColl();
			yyvsp[-1].var->type = yyvsp[0].string;
			add_VarColl(yyval.varcoll, yyvsp[-1].var);
			if (def_node)
				append_Node( curr_operlist, def_node(yyval.varcoll));

		;
    break;}
case 261:
#line 1339 "clic.y"
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
case 262:
#line 1351 "clic.y"
{
			yyval.varcoll=new_VarColl();
			add_VarColl(yyval.varcoll, yyvsp[0].var);
		;
    break;}
case 263:
#line 1356 "clic.y"
{
			yyval.varcoll=yyvsp[-2].varcoll;
			add_VarColl(yyval.varcoll, yyvsp[0].var);
		;
    break;}
case 264:
#line 1362 "clic.y"
{ yyval.var=newArrInit_Var(yyvsp[-1].string,yyvsp[0].node); ;
    break;}
case 265:
#line 1363 "clic.y"
{ yyval.var=mnewArrInit_Var(yyvsp[-1].node,yyvsp[-1].node); ;
    break;}
case 266:
#line 1366 "clic.y"
{ yyval.node=yyvsp[-1].node; ;
    break;}
case 267:
#line 1367 "clic.y"
{ yyval.node=yyvsp[-3].node; join_Node(yyvsp[-3].node,yyvsp[-1].node); ;
    break;}
case 268:
#line 1370 "clic.y"
{ yyval.var=new_Var(yyvsp[0].string); ;
    break;}
case 269:
#line 1371 "clic.y"
{ yyval.var=newArrInit_Var(yyvsp[-1].string,yyvsp[0].node); ;
    break;}
case 270:
#line 1372 "clic.y"
{ yyval.var=newInit_Var(yyvsp[-2].string,yyvsp[0].node); ;
    break;}
case 271:
#line 1373 "clic.y"
{ yyerror("only inline assign := allowed in initialisation"); yyval.var=new_Var(strdup("")); ;
    break;}
case 272:
#line 1375 "clic.y"
{ yyval.var=mnew_Var(yyvsp[0].node); ;
    break;}
case 273:
#line 1376 "clic.y"
{ yyval.var=mnewArrInit_Var(yyvsp[-1].node,yyvsp[-1].node); ;
    break;}
case 274:
#line 1377 "clic.y"
{ yyval.var=mnewInit_Var(yyvsp[-2].node,yyvsp[0].node);  ;
    break;}
case 275:
#line 1378 "clic.y"
{ yyerror("only inline assign := allowed in initialisation"); yyval.var=new_Var(strdup("")); ;
    break;}
case 276:
#line 1381 "clic.y"
{ yyval.node=yyvsp[-1].node; ;
    break;}
case 277:
#line 1382 "clic.y"
{ yyval.node=yyvsp[-3].node; join_Node(yyvsp[-3].node,yyvsp[-1].node); ;
    break;}
case 278:
#line 1385 "clic.y"
{ yyval.varcoll=new_VarColl(); ;
    break;}
case 279:
#line 1386 "clic.y"
{
		Var *vp=new_Var(yyvsp[-1].string);
		vp->type = yyvsp[0].string;
		yyval.varcoll=new_VarColl();
		vp->no=0;
		insert_Coll( &yyval.varcoll->coll, vp);
		insert_Coll( &yyval.varcoll->unsorted, vp);
		;
    break;}
case 280:
#line 1394 "clic.y"
{
		Var *vp=new_Var(yyvsp[-1].string);
		vp->type = yyvsp[0].string;
		yyval.varcoll=yyvsp[-3].varcoll;
		vp->no = yyval.varcoll->unsorted.count;
		insert_Coll( &yyval.varcoll->coll, vp);
		insert_Coll( &yyval.varcoll->unsorted, vp);
		;
    break;}
case 281:
#line 1405 "clic.y"
{yyval.coll=new_Coll(free,strcmp);;
    break;}
case 282:
#line 1406 "clic.y"
{
			yyval.coll=new_Coll(free,strcmp);
			insert_Coll(yyval.coll, yyvsp[0].string);
		;
    break;}
case 283:
#line 1411 "clic.y"
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
case 284:
#line 1424 "clic.y"
{
			yyval.varcoll=new_VarColl();
			add_VarColl(yyval.varcoll, new_Var(yyvsp[0].string));
		;
    break;}
case 285:
#line 1429 "clic.y"
{
			yyval.varcoll=yyvsp[-2].varcoll;
			add_VarColl(yyval.varcoll, new_Var(yyvsp[0].string));
		;
    break;}
case 286:
#line 1435 "clic.y"
{ yyval.arglist.coll=yyvsp[0].coll; yyval.arglist.haveRest=0; ;
    break;}
case 287:
#line 1436 "clic.y"
{ yyval.arglist.coll=yyvsp[-2].coll; yyval.arglist.haveRest=1; ;
    break;}
case 288:
#line 1437 "clic.y"
{ yyval.arglist.coll=new_Coll(NULL,NULL); yyval.arglist.haveRest=1;  ;
    break;}
case 289:
#line 1440 "clic.y"
{ yyval.arglist.coll=new_Coll(NULL,NULL); yyval.arglist.haveRest=0; ;
    break;}
case 290:
#line 1441 "clic.y"
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
case 291:
#line 1458 "clic.y"
{
			yyval.coll=new_Coll(NULL,NULL);
			if (yyvsp[0].node)
				insert_Coll(yyval.coll,yyvsp[0].node);
		;
    break;}
case 292:
#line 1463 "clic.y"
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
case 293:
#line 1474 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 294:
#line 1475 "clic.y"
{ yyval.node=yyvsp[0].node; /*$$=new_ArgNode($1,0);*/ ;
    break;}
case 295:
#line 1480 "clic.y"
{;
    break;}
case 296:
#line 1481 "clic.y"
{;
    break;}
case 297:
#line 1484 "clic.y"
{;
    break;}
case 298:
#line 1485 "clic.y"
{;
    break;}
case 299:
#line 1489 "clic.y"
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
case 300:
#line 1501 "clic.y"
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
case 301:
#line 1516 "clic.y"
{ yyval.node=NULL; ;
    break;}
case 303:
#line 1520 "clic.y"
{ yyval.node=new_ExprListNode(); append_Node(yyval.node, yyvsp[0].node); ;
    break;}
case 304:
#line 1521 "clic.y"
{ yyval.node=yyvsp[-2].node; append_Node(yyval.node, yyvsp[0].node); ;
    break;}
case 305:
#line 1524 "clic.y"
{ yyval.node=new_StringConstNode(yyvsp[0].string); ;
    break;}
case 306:
#line 1525 "clic.y"
{ yyval.node=new_LogicConstNode(1); ;
    break;}
case 307:
#line 1526 "clic.y"
{ yyval.node=new_LogicConstNode(0); ;
    break;}
case 308:
#line 1527 "clic.y"
{ yyval.node=new_NilConstNode(); ;
    break;}
case 309:
#line 1528 "clic.y"
{ yyval.node=new_NumberConstNode(yyvsp[0].string,0); ;
    break;}
case 311:
#line 1532 "clic.y"
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
#line 1535 "clic.y"


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
			fprintf(stdout, _clic_gettext("in file '%s',\n\tincluded at line %d "), filename, line);
		else
			fprintf(stdout, _clic_gettext("in file '%s'\n"), filename);
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
		fprintf(stdout, _clic_gettext("error %d: "), clic_errorcount);
		vfprintf(stdout, _clic_gettext(s), ap);
		va_end(ap);

		fprintf(stdout,_clic_gettext("\n\tline %ld pos %ld (yychar=%d, '%c') "), cl_line+corr_line, cl_pos, yychar, (yychar>32&&yychar<256)?yychar:' ');
		/*fprintf(stdout,"\n\tline %d pos %d ", cl_line+corr_line, cl_pos);*/
	}
	else
		fprintf(stdout, _clic_gettext("error %d, (yychar=%d) "), clic_errorcount, yychar);

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
		fprintf(stdout, _clic_gettext("warning %d: "), clic_warncount);
		vfprintf(stdout, _clic_gettext(s), ap);
		va_end(ap);

		fprintf(stdout, _clic_gettext("\n\tline %ld, pos %ld, "), cl_line+corr_line, cl_pos);
	}
	else
		fprintf(stdout, _clic_gettext("warning %d, "), clic_warncount);
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

