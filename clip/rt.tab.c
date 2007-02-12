/* A Bison parser, made from rt.y
   by GNU bison 1.35.  */

#define YYBISON 1  /* Identify Bison output.  */

#define yyparse rtparse
#define yylex rtlex
#define yyerror rterror
#define yylval rtlval
#define yychar rtchar
#define yydebug rtdebug
#define yynerrs rtnerrs
# define	STRING	257
# define	NUMBER	258
# define	NAME	259
# define	RPTR	260
# define	FIELD_PTR	261
# define	MEMVAR_PTR	262
# define	TRUE	263
# define	FALSE	264
# define	NIL	265
# define	PCOUNT	266
# define	PARAM	267
# define	IF	268
# define	RDDBEG	269
# define	RDDEND	270
# define	ASSIGN	271
# define	ADDA	272
# define	SUBA	273
# define	DIVA	274
# define	MODA	275
# define	MULA	276
# define	POWA	277
# define	POSTINCR	278
# define	OR	279
# define	AND	280
# define	NOT	281
# define	GE	282
# define	LE	283
# define	EQ	284
# define	NE	285
# define	POW	286
# define	INCR	287
# define	DECR	288
# define	MINUS	289

#line 274 "rt.y"


#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdarg.h>
#include <ctype.h>
#include "hashcode.h"
#include "hash.h"
#include "clipcfg.h"
#include "clip.h"
#include "clipvm.h"

#ifdef FORCEALIGN

static void
SETLONG(void *ptr, long l)
{
	memcpy(ptr, &l, sizeof(l));
}

static void
SETSHORT(void *ptr, short l)
{
	memcpy(ptr, &l, sizeof(l));
}

#else

#define SETLONG(ptr,l) (*(long*)(ptr)=(l))
#define SETSHORT(ptr,l) (*(short*)(ptr)=(l))

#endif


typedef struct
{
	int maxdeep;
	int curdeep;
	long *params;
	int params_count;
	long *memvars;
	int memvars_count;
	OutBuf out;
} Function;

static void init_Function(Function *fp);
static void destroy_Function(Function *fp);

typedef enum
{
	L_norm,
	L_name,
	L_num,
	L_xnum,
	L_string,
} LexState;

typedef struct
{
	unsigned char len;
	unsigned char dec;
} LenDec;

typedef struct Parser
{
	char *beg;
	char *end;
	char *ptr;
	ClipMachine *mp;
	char *func;
	int errcount;
	char *errbuf;

	LexState lex_state;
	int last_tok;

	double *numbers;
	LenDec *lendec;
	int numbers_count;
	char **strings;
	char **strings_end;
	int strings_count;
	Function *codeblocks;
	int codeblocks_count;

	Function main;
	Function *curFunction;
	OutBuf *out;
	int field_flag;
	int rdd_flag;
	int rdd_flag1;
	int rdd_no;
} Parser;

#define ERRBUFSIZE 256

#define NEW(type) ((type*)calloc(sizeof(type),1))
#define NEWVECT(type,len) ((type*)calloc(sizeof(type),(len)))
#define M_REALLOC(type,ptr,len) ((ptr)=(type*)realloc((ptr),sizeof(type)*(len)))

#define MODBEG (bp->buf+8+2*sizeof(long))
#define BEGOFFS (bp->ptr-MODBEG)
#define CUROFFS (bp->ptr-bp->buf)

#if 1
#define LONGVAL(offs,val) (SETLONG(bp->buf+(offs),(val)))
#define SHORTVAL(offs,val) (SETSHORT(bp->buf+(offs),(val)))
#define LONGINCR(offs) ((offs)+=sizeof(long));
#define SHORTINCR(offs) ((offs)+=sizeof(short));
#else
#define LONGVAL(offs) (*(long*)(bp->buf+(offs)))
#define SHORTVAL(offs) (*(short*)(bp->buf+(offs)))
#define LONGINCR(offs) ((offs)+=sizeof(long));
#define SHORTINCR(offs) ((offs)+=sizeof(short));
#endif

#define YYPARSE_PARAM parser
#define YYLEX_PARAM parser
#define	YYINITDEPTH 64
#define PARSER ((Parser*)parser)
#undef __GNUC__
#define POS (PARSER->out->ptr-PARSER->out->buf)

int rtlex();
void rt_error(Parser *parser, char *fmt,...);
#define rterror(msg) rt_error(PARSER, "%s", msg);
static int installName(Parser *parser, long hash, int memvar, int lval, long area, int fld);
static void gen_op(Parser *parser, int op);
static void add_deep(Function *fp, int no);


#line 407 "rt.y"
#ifndef YYSTYPE
typedef union
{
	struct {
		char *beg;
		char *end;
	} string;
	long Long;
	struct {
		double d;
		unsigned char len;
		unsigned char dec;
	} Double;
	Function *func;
	struct {
		long *vect;
		int count;
	} longvect;
	struct {
		long hash;
		int memvar;
	} name;
	struct {
		int pos;
		int i;
	} pos;
	int i;
} yystype;
# define YYSTYPE yystype
# define YYSTYPE_IS_TRIVIAL 1
#endif
#ifndef YYDEBUG
# define YYDEBUG 0
#endif



#define	YYFINAL		210
#define	YYFLAG		-32768
#define	YYNTBASE	57

/* YYTRANSLATE(YYLEX) -- Bison token number corresponding to YYLEX. */
#define YYTRANSLATE(x) ((unsigned)(x) <= 289 ? yytranslate[x] : 94)

/* YYTRANSLATE[YYLEX] -- Bison token number corresponding to YYLEX. */
static const char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,    37,    40,    54,     2,
      48,    49,    38,    35,    47,    36,    55,    39,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    45,     2,
      30,    34,    28,     2,    56,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    46,     2,    53,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    50,    52,    51,     2,     2,     2,     2,
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
      26,    27,    29,    31,    32,    33,    41,    42,    43,    44
};

#if YYDEBUG
static const short yyprhs[] =
{
       0,     0,     2,     4,     5,    10,    12,    14,    16,    18,
      20,    22,    24,    29,    32,    33,    40,    41,    48,    49,
      58,    59,    68,    70,    77,    78,    84,    89,    93,    97,
      98,   104,   108,   109,   114,   120,   126,   130,   134,   138,
     142,   146,   150,   154,   158,   162,   166,   170,   174,   178,
     182,   185,   188,   191,   194,   197,   200,   203,   204,   210,
     214,   215,   223,   227,   232,   233,   234,   247,   248,   254,
     255,   261,   263,   266,   269,   271,   274,   277,   278,   279,
     282,   284,   286,   288,   290,   292,   294,   296,   301,   306,
     310,   314,   315,   317,   321,   323,   326,   329,   333,   338,
     340,   344,   345,   347,   348,   350,   351,   356,   360,   361,
     363,   365,   368,   370,   371,   372,   377,   378,   380,   382
};
static const short yyrhs[] =
{
      58,     0,    60,     0,     0,    58,    47,    59,    92,     0,
       4,     0,     3,     0,     9,     0,    10,     0,    11,     0,
      82,     0,    84,     0,    74,    48,    60,    49,     0,    74,
      83,     0,     0,     5,    48,    76,    61,    86,    49,     0,
       0,    83,    48,    76,    62,    86,    49,     0,     0,    60,
      45,     5,    48,    76,    63,    86,    49,     0,     0,    80,
      45,     5,    48,    76,    64,    86,    49,     0,    80,     0,
      74,    48,    60,    49,    17,    60,     0,     0,    74,    83,
      65,    17,    60,     0,    82,    79,    76,    60,     0,    80,
      79,    60,     0,     5,     6,     5,     0,     0,     5,     6,
      76,    66,    84,     0,    84,     6,     5,     0,     0,    84,
       6,    67,    84,     0,     5,     6,     5,    17,    60,     0,
      84,     6,     5,    17,    60,     0,    60,    34,    60,     0,
      60,    32,    60,     0,    60,    33,    60,     0,    60,    28,
      60,     0,    60,    30,    60,     0,    60,    31,    60,     0,
      60,    29,    60,     0,    60,    35,    60,     0,    60,    37,
      60,     0,    60,    36,    60,     0,    60,    38,    60,     0,
      60,    39,    60,     0,    60,    40,    60,     0,    60,    41,
      60,     0,    27,    60,     0,    36,    60,     0,    35,    60,
       0,    42,    60,     0,    60,    42,     0,    43,    60,     0,
      60,    43,     0,     0,    15,     4,    68,    60,    16,     0,
      50,    90,    51,     0,     0,    50,    52,    69,    77,    78,
      58,    51,     0,    12,    48,    49,     0,    13,    48,    60,
      49,     0,     0,     0,    14,    48,    92,    47,    76,    70,
      92,    47,    76,    71,    92,    49,     0,     0,    60,    26,
      76,    72,    60,     0,     0,    60,    25,    76,    73,    60,
       0,     7,     0,    74,     7,     0,    75,     7,     0,     8,
       0,    74,     8,     0,    75,     8,     0,     0,     0,    81,
      52,     0,    17,     0,    18,     0,    19,     0,    22,     0,
      20,     0,    21,     0,    23,     0,    60,    46,    93,    53,
       0,    80,    46,    93,    53,     0,    60,    45,     5,     0,
      80,    45,     5,     0,     0,     5,     0,    81,    47,     5,
       0,     5,     0,    75,     5,     0,    74,     5,     0,    54,
      82,    85,     0,    54,    48,    60,    49,     0,    83,     0,
      48,    60,    49,     0,     0,    55,     0,     0,    89,     0,
       0,    47,    76,    87,    88,     0,    86,    47,    88,     0,
       0,    89,     0,    60,     0,    56,    82,     0,    60,     0,
       0,     0,    90,    47,    91,    92,     0,     0,    60,     0,
      60,     0,    93,    47,    60,     0
};

#endif

#if YYDEBUG
/* YYRLINE[YYN] -- source line where rule number YYN was defined. */
static const short yyrline[] =
{
       0,   467,   473,   474,   474,   482,   506,   528,   531,   534,
     538,   541,   545,   550,   558,   558,   571,   571,   583,   583,
     603,   603,   626,   633,   641,   641,   651,   679,   701,   708,
     708,   719,   726,   726,   735,   744,   751,   752,   753,   754,
     755,   756,   757,   758,   759,   760,   761,   762,   763,   764,
     765,   766,   767,   768,   769,   770,   771,   772,   772,   781,
     787,   787,   802,   806,   810,   810,   810,   827,   827,   839,
     839,   852,   853,   854,   857,   858,   859,   862,   865,   873,
     895,   896,   897,   898,   899,   900,   901,   904,   905,   906,
     912,   920,   921,   926,   936,   937,   938,   941,   946,   952,
     953,   956,   957,   960,   961,   962,   962,   964,   967,   970,
     973,   974,   983,   984,   985,   985,   998,  1001,  1004,  1005
};
#endif


#if (YYDEBUG) || defined YYERROR_VERBOSE

/* YYTNAME[TOKEN_NUM] -- String name of the token TOKEN_NUM. */
static const char *const yytname[] =
{
  "$", "error", "$undefined.", "STRING", "NUMBER", "NAME", "RPTR", 
  "FIELD_PTR", "MEMVAR_PTR", "TRUE", "FALSE", "NIL", "PCOUNT", "PARAM", 
  "IF", "RDDBEG", "RDDEND", "ASSIGN", "ADDA", "SUBA", "DIVA", "MODA", 
  "MULA", "POWA", "POSTINCR", "OR", "AND", "NOT", "'>'", "GE", "'<'", 
  "LE", "EQ", "NE", "'='", "'+'", "'-'", "'$'", "'*'", "'/'", "'%'", 
  "POW", "INCR", "DECR", "MINUS", "':'", "'['", "','", "'('", "')'", 
  "'{'", "'}'", "'|'", "']'", "'&'", "'.'", "'@'", "file", "fexpr_list", 
  "@1", "expr", "@2", "@3", "@4", "@5", "@6", "@7", "@8", "@9", "@10", 
  "@11", "@12", "@13", "@14", "fieldptr", "memvarptr", "pos", "func", 
  "code", "assign", "arr", "param_list", "name", "mname", "mename", "dot", 
  "arglist", "@15", "earg", "arg", "exprlist", "@16", "nexpr", 
  "expr_list", 0
};
#endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives. */
static const short yyr1[] =
{
       0,    57,    58,    59,    58,    60,    60,    60,    60,    60,
      60,    60,    60,    60,    61,    60,    62,    60,    63,    60,
      64,    60,    60,    60,    65,    60,    60,    60,    60,    66,
      60,    60,    67,    60,    60,    60,    60,    60,    60,    60,
      60,    60,    60,    60,    60,    60,    60,    60,    60,    60,
      60,    60,    60,    60,    60,    60,    60,    68,    60,    60,
      69,    60,    60,    60,    70,    71,    60,    72,    60,    73,
      60,    74,    74,    74,    75,    75,    75,    76,    77,    78,
      79,    79,    79,    79,    79,    79,    79,    80,    80,    80,
      80,    81,    81,    81,    82,    82,    82,    83,    83,    84,
      84,    85,    85,    86,    86,    87,    86,    86,    88,    88,
      89,    89,    90,    90,    91,    90,    92,    92,    93,    93
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN. */
static const short yyr2[] =
{
       0,     1,     1,     0,     4,     1,     1,     1,     1,     1,
       1,     1,     4,     2,     0,     6,     0,     6,     0,     8,
       0,     8,     1,     6,     0,     5,     4,     3,     3,     0,
       5,     3,     0,     4,     5,     5,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       2,     2,     2,     2,     2,     2,     2,     0,     5,     3,
       0,     7,     3,     4,     0,     0,    12,     0,     5,     0,
       5,     1,     2,     2,     1,     2,     2,     0,     0,     2,
       1,     1,     1,     1,     1,     1,     1,     4,     4,     3,
       3,     0,     1,     3,     1,     2,     2,     3,     4,     1,
       3,     0,     1,     0,     1,     0,     4,     3,     0,     1,
       1,     2,     1,     0,     0,     4,     0,     1,     1,     3
};

/* YYDEFACT[S] -- default rule to reduce with in state S when YYTABLE
   doesn't specify something else to do.  Zero means the default is an
   error. */
static const short yydefact[] =
{
       0,     6,     5,    94,    71,    74,     7,     8,     9,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   113,
       0,     1,     2,     0,     0,    22,    10,    99,    11,    77,
      77,     0,     0,   116,    57,    50,    52,    51,    53,    55,
       0,    60,   112,     0,    94,     0,     0,   101,     3,    77,
      77,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    54,    56,     0,     0,    96,
      72,    75,     0,    13,    95,    73,    76,    80,    81,    82,
      84,    85,    83,    86,     0,     0,     0,    77,    77,    32,
      28,    29,    14,    62,     0,   117,     0,     0,   100,    78,
     114,    59,     0,   102,    97,   116,    69,    67,    39,    42,
      40,    41,    37,    38,    36,    43,    45,    44,    46,    47,
      48,    49,    89,   118,     0,     0,     0,    90,     0,    27,
       0,    16,    31,     0,     0,     0,   103,    63,    77,     0,
      91,   116,    98,     4,     0,     0,    77,     0,    87,    12,
       0,    77,    88,    26,   103,     0,    99,    33,    34,    30,
      77,     0,   110,     0,   104,    64,    58,    92,     0,     0,
     115,    70,    68,    18,   119,     0,    25,    20,     0,    35,
     105,   111,   108,    15,   116,     0,     0,    79,   103,    23,
     103,    17,   108,   107,   109,     0,    61,    93,     0,     0,
     106,    77,    19,    21,    65,   116,     0,    66,     0,     0,
       0
};

static const short yydefgoto[] =
{
     208,    21,   105,   162,   136,   154,   188,   190,   126,   135,
     133,    97,    99,   184,   205,   145,   144,    23,    24,    91,
     140,   168,    86,    25,   169,    26,    27,    28,   104,   163,
     192,   193,   164,    43,   141,    96,   124
};

static const short yypact[] =
{
     342,-32768,-32768,    -1,-32768,-32768,-32768,-32768,-32768,   -42,
     -12,    -6,    26,   342,   342,   342,   342,   342,   342,   290,
       2,    20,   482,    30,    36,    72,    89,     1,    69,    76,
  -32768,    33,   342,   342,-32768,   522,    42,    42,    34,    34,
     394,-32768,   482,    49,-32768,   342,   114,    48,-32768,-32768,
  -32768,   342,   342,   342,   342,   342,   342,   342,   342,   342,
     342,   342,   342,   342,   342,-32768,-32768,   109,   342,-32768,
  -32768,-32768,   342,   103,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,   122,   342,   342,-32768,-32768,   123,
     115,-32768,-32768,-32768,   416,   482,    92,   342,-32768,-32768,
  -32768,-32768,   438,-32768,-32768,   342,-32768,-32768,   121,   121,
     121,   121,   121,   121,   121,   131,   131,   131,    28,    28,
      28,    34,   101,   482,   -27,   460,   119,   104,   -24,   482,
     342,-32768,   134,   -23,   342,   -23,   182,-32768,-32768,   372,
     135,   342,-32768,-32768,   342,   342,-32768,   342,-32768,   136,
     342,-32768,-32768,   482,   182,   342,-32768,-32768,   482,-32768,
  -32768,   118,   482,   -25,-32768,-32768,-32768,-32768,   342,   -13,
  -32768,   503,   522,-32768,   482,   342,   482,-32768,    52,   482,
  -32768,-32768,   236,-32768,   342,    51,   149,-32768,   182,   482,
     182,-32768,   236,-32768,-32768,   133,-32768,-32768,    84,    88,
  -32768,-32768,-32768,-32768,-32768,   342,   116,-32768,   178,   181,
  -32768
};

static const short yypgoto[] =
{
  -32768,    14,-32768,     0,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,-32768,   -19,-32768,   -22,
  -32768,-32768,   157,-32768,-32768,   -18,   -20,    13,-32768,  -142,
  -32768,    -4,  -171,-32768,-32768,  -101,   113
};


#define	YYLAST		568


static const short yytable[] =
{
      22,    46,    47,    73,   143,    29,    31,    44,    92,     4,
       5,   194,   178,    35,    36,    37,    38,    39,    40,    42,
     147,   194,   182,   147,   183,    18,   148,   106,   107,   152,
      34,    20,    94,    95,   186,    69,    32,    70,    71,   187,
     170,    74,    33,    75,    76,   102,   198,    30,   199,    88,
      45,   108,   109,   110,   111,   112,   113,   114,   115,   116,
     117,   118,   119,   120,   121,   130,   131,    48,   123,    64,
      65,    66,   125,    67,    68,    89,    65,    66,    72,    67,
      68,    90,    93,   195,    20,   123,   129,    67,    68,    77,
      78,    79,    80,    81,    82,    83,   100,   139,    48,   182,
     101,   191,   196,   103,   206,    95,    77,    78,    79,    80,
      81,    82,    83,   156,   122,   156,   165,    84,    85,    69,
     -24,    70,    71,    44,   173,     4,     5,   127,   132,   177,
     153,   182,   134,   202,   158,   182,   150,   203,   180,   138,
     167,    95,    46,   181,   171,   172,   157,   174,   159,   146,
     176,   155,   151,   175,   197,   179,    58,    59,    60,    61,
      62,    63,    64,    65,    66,   207,    67,    68,    22,    61,
      62,    63,    64,    65,    66,   189,    67,    68,   209,   204,
     201,   210,   185,    87,    95,     1,     2,     3,   200,     4,
       5,     6,     7,     8,     9,    10,    11,    12,   128,     0,
       0,     0,     0,     0,     0,    95,     0,     0,     0,    13,
       0,     0,     0,     0,     0,     0,     0,    14,    15,     0,
       0,     0,     0,     0,    16,    17,     0,     0,     0,   160,
      18,     0,    19,     0,     0,     0,    20,     0,   161,     1,
       2,     3,     0,     4,     5,     6,     7,     8,     9,    10,
      11,    12,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    13,     0,     0,     0,     0,     0,     0,
       0,    14,    15,     0,     0,     0,     0,     0,    16,    17,
       0,     0,     0,     0,    18,     0,    19,     0,     0,     0,
      20,     0,   161,     1,     2,     3,     0,     4,     5,     6,
       7,     8,     9,    10,    11,    12,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    13,     0,     0,
       0,     0,     0,     0,     0,    14,    15,     0,     0,     0,
       0,     0,    16,    17,     0,     0,     0,     0,    18,     0,
      19,     0,    41,     0,    20,     1,     2,     3,     0,     4,
       5,     6,     7,     8,     9,    10,    11,    12,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    13,
       0,     0,     0,     0,     0,     0,     0,    14,    15,     0,
       0,     0,     0,     0,    16,    17,     0,     0,   166,     0,
      18,     0,    19,     0,     0,     0,    20,    49,    50,     0,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,     0,    67,    68,    49,
      50,     0,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    61,    62,    63,    64,    65,    66,     0,    67,
      68,    49,    50,    98,    51,    52,    53,    54,    55,    56,
      57,    58,    59,    60,    61,    62,    63,    64,    65,    66,
       0,    67,    68,    49,    50,   137,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,     0,    67,    68,    49,    50,   142,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    66,     0,    67,    68,    49,    50,   149,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,     0,    67,    68,    50,
       0,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,     0,    67,    68,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,     0,    67,    68
};

static const short yycheck[] =
{
       0,    20,    20,    23,   105,     6,    48,     5,    30,     7,
       8,   182,   154,    13,    14,    15,    16,    17,    18,    19,
      47,   192,    47,    47,    49,    48,    53,    49,    50,    53,
       4,    54,    32,    33,    47,     5,    48,     7,     8,    52,
     141,     5,    48,     7,     8,    45,   188,    48,   190,    48,
      48,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    87,    88,    47,    68,    41,
      42,    43,    72,    45,    46,     6,    42,    43,    48,    45,
      46,     5,    49,   184,    54,    85,    86,    45,    46,    17,
      18,    19,    20,    21,    22,    23,    47,    97,    47,    47,
      51,    49,    51,    55,   205,   105,    17,    18,    19,    20,
      21,    22,    23,   133,     5,   135,   138,    45,    46,     5,
      17,     7,     8,     5,   146,     7,     8,     5,     5,   151,
     130,    47,    17,    49,   134,    47,    17,    49,   160,    47,
       5,   141,   161,   161,   144,   145,   133,   147,   135,    48,
     150,    17,    48,    17,     5,   155,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    49,    45,    46,   168,    38,
      39,    40,    41,    42,    43,   175,    45,    46,     0,   201,
      47,     0,   168,    26,   184,     3,     4,     5,   192,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    85,    -1,
      -1,    -1,    -1,    -1,    -1,   205,    -1,    -1,    -1,    27,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    35,    36,    -1,
      -1,    -1,    -1,    -1,    42,    43,    -1,    -1,    -1,    47,
      48,    -1,    50,    -1,    -1,    -1,    54,    -1,    56,     3,
       4,     5,    -1,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    27,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    35,    36,    -1,    -1,    -1,    -1,    -1,    42,    43,
      -1,    -1,    -1,    -1,    48,    -1,    50,    -1,    -1,    -1,
      54,    -1,    56,     3,     4,     5,    -1,     7,     8,     9,
      10,    11,    12,    13,    14,    15,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    27,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    35,    36,    -1,    -1,    -1,
      -1,    -1,    42,    43,    -1,    -1,    -1,    -1,    48,    -1,
      50,    -1,    52,    -1,    54,     3,     4,     5,    -1,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    27,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    35,    36,    -1,
      -1,    -1,    -1,    -1,    42,    43,    -1,    -1,    16,    -1,
      48,    -1,    50,    -1,    -1,    -1,    54,    25,    26,    -1,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43,    -1,    45,    46,    25,
      26,    -1,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    -1,    45,
      46,    25,    26,    49,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      -1,    45,    46,    25,    26,    49,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
      42,    43,    -1,    45,    46,    25,    26,    49,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    42,    43,    -1,    45,    46,    25,    26,    49,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43,    -1,    45,    46,    26,
      -1,    28,    29,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    -1,    45,    46,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43,    -1,    45,    46
};
#define YYPURE 1

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
#line 467 "rt.y"
{
		yyval.pos = yyvsp[0].pos;
		putByte_Buf(PARSER->out,CLIP_RETURN_POP);
	;
    break;}
case 3:
#line 474 "rt.y"
{
			putByte_Buf(PARSER->out,CLIP_POP);
		;
    break;}
case 4:
#line 477 "rt.y"
{
			yyval.pos=yyvsp[-3].pos;
		;
    break;}
case 5:
#line 482 "rt.y"
{
			int no, num=PARSER->numbers_count;
			for(no=0;no<num;++no)
				if ( PARSER->numbers[no]==yyvsp[0].Double.d
					 &&	PARSER->lendec[no].len == yyvsp[0].Double.len
					 &&	PARSER->lendec[no].dec == yyvsp[0].Double.dec
				   )
				{
					break;
				}
			if (no==num)
			{
				M_REALLOC(double,PARSER->numbers, no+1);
				M_REALLOC(LenDec,PARSER->lendec, no+1);
				PARSER->numbers[no]=yyvsp[0].Double.d;
				PARSER->lendec[no].len=yyvsp[0].Double.len;
				PARSER->lendec[no].dec=yyvsp[0].Double.dec;
				++PARSER->numbers_count;
			}
			yyval.pos.pos=POS;
			putByte_Buf(PARSER->out,CLIP_PUSH_NUM);
			putShort_Buf(PARSER->out,no);
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 6:
#line 506 "rt.y"
{
			int no, num=PARSER->strings_count;
			char *beg = yyvsp[0].string.beg, *end = yyvsp[0].string.end;
			/*
			for(no=0;no<num;++no)
				if (!memcmp(PARSER->strings[no],$1.beg,len))
					break;
			*/
			no = num;
			if (no==num)
			{
				M_REALLOC(char*,PARSER->strings, no+1);
				M_REALLOC(char*,PARSER->strings_end, no+1);
				PARSER->strings[no] = beg;
				PARSER->strings_end[no] = end;
				PARSER->strings_count++;
			}
			yyval.pos.pos=POS;
			putByte_Buf(PARSER->out,CLIP_PUSH_STRDUP);
			putShort_Buf(PARSER->out,no);
			add_deep(PARSER->curFunction, 1);
		;
    break;}
case 7:
#line 528 "rt.y"
{ yyval.pos.pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_TRUE);
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 8:
#line 531 "rt.y"
{ yyval.pos.pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_FALSE);
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 9:
#line 534 "rt.y"
{ yyval.pos.pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_NIL);
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 10:
#line 538 "rt.y"
{ yyval.pos.pos=POS; installName(PARSER, yyvsp[0].name.hash, yyvsp[0].name.memvar, 0, -1, 0);
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 11:
#line 541 "rt.y"
{ yyval.pos=yyvsp[0].pos;
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 12:
#line 545 "rt.y"
{
			yyval.pos=yyvsp[-1].pos;
			putByte_Buf(PARSER->out, CLIP_FIELD_POP_NAME);
		;
    break;}
case 13:
#line 550 "rt.y"
{
			yyval.pos=yyvsp[0].pos;
			PARSER->out->ptr[-1] = CLIP_NOP;
			putByte_Buf(PARSER->out, CLIP_FIELD_POP_NAME);
		;
    break;}
case 14:
#line 559 "rt.y"
{ putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
			yyvsp[0].pos.i = PARSER->curFunction->curdeep;
		;
    break;}
case 15:
#line 564 "rt.y"
{
			PARSER->curFunction->curdeep = yyvsp[-3].pos.i;
			putByte_Buf(PARSER->out, CLIP_FUNC);
			putByte_Buf(PARSER->out, yyvsp[-1].pos.i);
			putLong_Buf(PARSER->out, yyvsp[-5].Long);
			yyval.pos=yyvsp[-3].pos;
		;
    break;}
case 16:
#line 572 "rt.y"
{ putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
			yyvsp[0].pos.i = PARSER->curFunction->curdeep;
		;
    break;}
case 17:
#line 576 "rt.y"
{
			PARSER->curFunction->curdeep = yyvsp[-3].pos.i;
			yyval.pos=yyvsp[-5].pos;
			putByte_Buf(PARSER->out, CLIP_FUNC_NAME);
			putByte_Buf(PARSER->out, yyvsp[-1].pos.i);
		;
    break;}
case 18:
#line 584 "rt.y"
{
			yyvsp[0].pos.i = PARSER->curFunction->curdeep;
		;
    break;}
case 19:
#line 588 "rt.y"
{
			PARSER->curFunction->curdeep = yyvsp[-3].pos.i;

			putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);

			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, yyvsp[-1].pos.i+1);

			putByte_Buf(PARSER->out,CLIP_CALL);
			putByte_Buf(PARSER->out,yyvsp[-1].pos.i+1);
			putLong_Buf(PARSER->out,yyvsp[-5].Long);
			yyval.pos=yyvsp[-7].pos;
		;
    break;}
case 20:
#line 604 "rt.y"
{
			putByte_Buf(PARSER->out,CLIP_IFETCH);
			putByte_Buf(PARSER->out,yyvsp[-4].pos.i-1);
			add_deep(PARSER->curFunction, 1);
			yyvsp[0].pos.i = PARSER->curFunction->curdeep;
		;
    break;}
case 21:
#line 611 "rt.y"
{
			PARSER->curFunction->curdeep = yyvsp[-3].pos.i;

			putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);

			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, yyvsp[-1].pos.i+1);

			putByte_Buf(PARSER->out,CLIP_CALL);
			putByte_Buf(PARSER->out,yyvsp[-1].pos.i+1);
			putLong_Buf(PARSER->out,yyvsp[-5].Long);
			yyval.pos=yyvsp[-7].pos;
		;
    break;}
case 22:
#line 626 "rt.y"
{
			yyval.pos=yyvsp[0].pos;
			putByte_Buf(PARSER->out,CLIP_IFETCH);
			putByte_Buf(PARSER->out,yyvsp[0].pos.i-1);
			add_deep(PARSER->curFunction, 1);
		;
    break;}
case 23:
#line 633 "rt.y"
{
			yyval.pos=yyvsp[-3].pos;
			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_PFIELD);
			putLong_Buf(PARSER->out, -1);
		;
    break;}
case 24:
#line 641 "rt.y"
{
			PARSER->out->ptr[-1] = CLIP_NOP;
		;
    break;}
case 25:
#line 643 "rt.y"
{
			yyval.pos=yyvsp[-3].pos;
			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_PFIELD);
			putLong_Buf(PARSER->out, -1);
		;
    break;}
case 26:
#line 653 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			if (yyvsp[-2].i == '=' && PARSER->field_flag && yyvsp[-3].name.memvar==0)
			{
				/*installName(PARSER, $1.hash, 0, 1, 0, 1);*/
				putByte_Buf(PARSER->out,CLIP_FM_IASSIGN);
				putLong_Buf(PARSER->out, yyvsp[-3].name.hash);
			}
			else
			{
				int r;
				r = installName(PARSER, yyvsp[-3].name.hash, yyvsp[-3].name.memvar, 1, -1, 0);
				if (!r)
				{
					if (yyvsp[-2].i=='=')
						putByte_Buf(PARSER->out,CLIP_IASSIGN);
					else
					{
						putByte_Buf(PARSER->out,CLIP_OPIASSIGN);
						putByte_Buf(PARSER->out,yyvsp[-2].i);
					}
				}
			}
			yyval.pos=yyvsp[-1].pos;
		;
    break;}
case 27:
#line 680 "rt.y"
{
			int count = yyvsp[-2].pos.i;

			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out,CLIP_SWAP);
			putByte_Buf(PARSER->out,count);
			if (yyvsp[-1].i=='=')
			{
				putByte_Buf(PARSER->out,CLIP_ISTORE);
				putByte_Buf(PARSER->out,0);
				putByte_Buf(PARSER->out,count-1);
			}
			else
			{
				putByte_Buf(PARSER->out,CLIP_OPISTORE);
				putByte_Buf(PARSER->out,count-1);
				putByte_Buf(PARSER->out,yyvsp[-1].i);
			}
			yyval.pos=yyvsp[-2].pos;
		;
    break;}
case 28:
#line 701 "rt.y"
{
			yyval.pos.pos=POS;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_FIELD);
			putLong_Buf(PARSER->out, yyvsp[0].Long);
			putLong_Buf(PARSER->out, yyvsp[-2].Long);
		;
    break;}
case 29:
#line 708 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PUSH_AREA);
			putLong_Buf(PARSER->out, yyvsp[-2].Long);
		;
    break;}
case 30:
#line 714 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_POP_AREA);
			yyval.pos=yyvsp[-2].pos;
		;
    break;}
case 31:
#line 720 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_FIELD_POP);
			putLong_Buf(PARSER->out, yyvsp[0].Long);
			yyval.pos=yyvsp[-2].pos;
		;
    break;}
case 32:
#line 727 "rt.y"
{ putByte_Buf(PARSER->out, CLIP_PUSH_AREA_POP);	;
    break;}
case 33:
#line 729 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_POP_AREA);
			yyval.pos=yyvsp[-3].pos;
		;
    break;}
case 34:
#line 736 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_FIELD);
			putLong_Buf(PARSER->out, yyvsp[-2].Long);
			putLong_Buf(PARSER->out, yyvsp[-4].Long);
			yyval.pos=yyvsp[0].pos;
		;
    break;}
case 35:
#line 744 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_FIELD_POP);
			putLong_Buf(PARSER->out, yyvsp[-2].Long);
			yyval.pos=yyvsp[-4].pos;
		;
    break;}
case 36:
#line 751 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, 'e'); ;
    break;}
case 37:
#line 752 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, 'E'); ;
    break;}
case 38:
#line 753 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, 'N'); ;
    break;}
case 39:
#line 754 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '>'); ;
    break;}
case 40:
#line 755 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '<'); ;
    break;}
case 41:
#line 756 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, 'L'); ;
    break;}
case 42:
#line 757 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, 'G'); ;
    break;}
case 43:
#line 758 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '+'); ;
    break;}
case 44:
#line 759 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '$'); ;
    break;}
case 45:
#line 760 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '-'); ;
    break;}
case 46:
#line 761 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '*'); ;
    break;}
case 47:
#line 762 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '/'); ;
    break;}
case 48:
#line 763 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '%'); ;
    break;}
case 49:
#line 764 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '^'); ;
    break;}
case 50:
#line 765 "rt.y"
{ yyval.pos=yyvsp[0].pos; putByte_Buf(PARSER->out, CLIP_NOT); ;
    break;}
case 51:
#line 766 "rt.y"
{ yyval.pos=yyvsp[0].pos; putByte_Buf(PARSER->out, CLIP_MINUS); ;
    break;}
case 52:
#line 767 "rt.y"
{ yyval.pos=yyvsp[0].pos; ;
    break;}
case 53:
#line 768 "rt.y"
{ yyval.pos=yyvsp[0].pos; ;
    break;}
case 54:
#line 769 "rt.y"
{ yyval.pos=yyvsp[-1].pos; ;
    break;}
case 55:
#line 770 "rt.y"
{ yyval.pos=yyvsp[0].pos; ;
    break;}
case 56:
#line 771 "rt.y"
{ yyval.pos=yyvsp[-1].pos; ;
    break;}
case 57:
#line 772 "rt.y"
{
				PARSER->rdd_no = yyvsp[0].Double.d;
				PARSER->rdd_flag1 = 1;
			;
    break;}
case 58:
#line 776 "rt.y"
{
				yyval.pos=yyvsp[-1].pos;
				PARSER->rdd_flag1 = 0;
			;
    break;}
case 59:
#line 781 "rt.y"
{
			add_deep(PARSER->curFunction, yyvsp[-1].pos.i+1);
			yyval.pos=yyvsp[-1].pos;
			putByte_Buf(PARSER->out, CLIP_ARRAY);
			putLong_Buf(PARSER->out, yyvsp[-1].pos.i);
		;
    break;}
case 60:
#line 787 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_PUSH_CODE);
			putShort_Buf(PARSER->out, PARSER->codeblocks_count+1);
			putByte_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, 0);
			/* uplocals */
			/*putShort_Buf(PARSER->out, 0);*/
		;
    break;}
case 61:
#line 795 "rt.y"
{
			putByte_Buf(PARSER->out,CLIP_RETURN_POP);
			PARSER->curFunction = (yyvsp[-3].pos.i==-1?&PARSER->main:PARSER->codeblocks+yyvsp[-3].pos.i);
			PARSER->out = &PARSER->curFunction->out;
			add_deep(PARSER->curFunction, 1);
			yyval.pos.pos = yyvsp[-3].pos.pos;
		;
    break;}
case 62:
#line 802 "rt.y"
{ yyval.pos.pos=POS;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PCOUNT);
		;
    break;}
case 63:
#line 806 "rt.y"
{ yyval.pos=yyvsp[-1].pos;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PARN);
		;
    break;}
case 64:
#line 811 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_COND);
			putShort_Buf(PARSER->out, 0);
		;
    break;}
case 65:
#line 816 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_GOTO);
			putShort_Buf(PARSER->out, 0);
			*(short*)(PARSER->out->buf+yyvsp[-4].pos.pos+1) = (POS-(yyvsp[-4].pos.pos+1+sizeof(short)));
		;
    break;}
case 66:
#line 822 "rt.y"
{
			*(short*)(PARSER->out->buf+yyvsp[-3].pos.pos+1) = (POS-(yyvsp[-3].pos.pos+1+sizeof(short)));
			yyval.pos=yyvsp[-9].pos;
		;
    break;}
case 67:
#line 828 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_TCOND);
			putShort_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, CLIP_POP);
		;
    break;}
case 68:
#line 834 "rt.y"
{
			yyval.pos=yyvsp[-4].pos;
			*(short*)(PARSER->out->buf+yyvsp[-2].pos.pos+1) = (POS-(yyvsp[-2].pos.pos+1+sizeof(short)));
		;
    break;}
case 69:
#line 840 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_ITCOND);
			putShort_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, CLIP_POP);
		;
    break;}
case 70:
#line 846 "rt.y"
{
			yyval.pos=yyvsp[-4].pos;
			*(short*)(PARSER->out->buf+yyvsp[-2].pos.pos+1) = (POS-(yyvsp[-2].pos.pos+1+sizeof(short)));
		;
    break;}
case 77:
#line 862 "rt.y"
{ yyval.pos.pos = POS; ;
    break;}
case 78:
#line 865 "rt.y"
{ 	if (PARSER->curFunction==&PARSER->main)
			yyval.pos.i=-1;
		else
			yyval.pos.i=PARSER->curFunction-PARSER->codeblocks;
		yyval.pos.pos=POS;
	;
    break;}
case 79:
#line 874 "rt.y"
{
			int i;
			int count=PARSER->codeblocks_count;
			Function *fp;

			M_REALLOC(Function, PARSER->codeblocks, count+1);
			fp = PARSER->curFunction = PARSER->codeblocks+count;
			PARSER->out = &fp->out;
			init_Function(fp);
			++ (PARSER->codeblocks_count);
			fp->params = yyvsp[-1].longvect.vect;
			fp->params_count = yyvsp[-1].longvect.count;
			for(i=0;i<fp->params_count;i++)
			{
				putByte_Buf(PARSER->out, CLIP_PUSH_PARAM);
				putByte_Buf(PARSER->out, i);
				putShort_Buf(PARSER->out, i);
			}
		;
    break;}
case 80:
#line 895 "rt.y"
{ yyval.i='='/*ASSIGN*/; ;
    break;}
case 81:
#line 896 "rt.y"
{ yyval.i='+'/*ADDA*/; ;
    break;}
case 82:
#line 897 "rt.y"
{ yyval.i='-'/*SUBA*/; ;
    break;}
case 83:
#line 898 "rt.y"
{ yyval.i='*'/*MULA*/; ;
    break;}
case 84:
#line 899 "rt.y"
{ yyval.i='/'/*DIVA*/; ;
    break;}
case 85:
#line 900 "rt.y"
{ yyval.i='%'/*MODA*/; ;
    break;}
case 86:
#line 901 "rt.y"
{ yyval.i='^'/*POWA*/; ;
    break;}
case 87:
#line 904 "rt.y"
{ yyval.pos=yyvsp[-3].pos; yyval.pos.i=yyvsp[-1].pos.i+1; ;
    break;}
case 88:
#line 905 "rt.y"
{ yyval.pos=yyvsp[-3].pos; yyval.pos.i=yyvsp[-3].pos.i+yyvsp[-1].pos.i; ;
    break;}
case 89:
#line 907 "rt.y"
{
			yyval.pos=yyvsp[-2].pos; yyval.pos.i=2;
			putByte_Buf(PARSER->out,CLIP_PUSH_HASH);
			putLong_Buf(PARSER->out,yyvsp[0].Long);
		;
    break;}
case 90:
#line 913 "rt.y"
{
			yyval.pos=yyvsp[-2].pos; yyval.pos.i++;
			putByte_Buf(PARSER->out,CLIP_PUSH_HASH);
			putLong_Buf(PARSER->out,yyvsp[0].Long);
		;
    break;}
case 91:
#line 920 "rt.y"
{ yyval.longvect.count=0; yyval.longvect.vect=0; ;
    break;}
case 92:
#line 921 "rt.y"
{
			yyval.longvect.vect=NEW(long);
			yyval.longvect.count=1;
			yyval.longvect.vect[0]= yyvsp[0].Long;
		;
    break;}
case 93:
#line 926 "rt.y"
{
			int i = ++ yyval.longvect.count;
			yyval.longvect.vect=M_REALLOC(long,yyval.longvect.vect,i);
			yyval.longvect.vect[i-1] = yyvsp[0].Long;
			for(i=0;i<yyval.longvect.count-1;++i)
				if (yyval.longvect.vect[i]==yyvsp[0].Long)
					rterror("duplicate name in parameter list");
		;
    break;}
case 94:
#line 936 "rt.y"
{ yyval.name.hash = yyvsp[0].Long; yyval.name.memvar=0; ;
    break;}
case 95:
#line 937 "rt.y"
{ yyval.name.hash = yyvsp[0].Long; yyval.name.memvar=1; ;
    break;}
case 96:
#line 938 "rt.y"
{ yyval.name.hash = yyvsp[0].Long; yyval.name.memvar=2; ;
    break;}
case 97:
#line 941 "rt.y"
{
			installName(PARSER, yyvsp[-1].name.hash, yyvsp[-1].name.memvar, 0, -1, 0);
			yyval.pos.pos=POS;
			putByte_Buf(PARSER->out, CLIP_MACRO);
		;
    break;}
case 98:
#line 946 "rt.y"
{
			yyval.pos=yyvsp[-1].pos;
			putByte_Buf(PARSER->out, CLIP_MACRO);
		;
    break;}
case 100:
#line 953 "rt.y"
{ yyval.pos=yyvsp[-1].pos;;
    break;}
case 103:
#line 960 "rt.y"
{yyval.pos.pos=POS;yyval.pos.i=0;;
    break;}
case 104:
#line 961 "rt.y"
{ yyval.pos=yyvsp[0].pos; yyval.pos.i=1; ;
    break;}
case 105:
#line 962 "rt.y"
{ putByte_Buf(PARSER->out, CLIP_PUSH_NIL); ;
    break;}
case 106:
#line 963 "rt.y"
{ yyval.pos=yyvsp[-2].pos; yyval.pos.i=2; ;
    break;}
case 107:
#line 964 "rt.y"
{ yyval.pos=yyvsp[-2].pos; yyval.pos.i+=1; ;
    break;}
case 108:
#line 967 "rt.y"
{ yyval.pos.pos=POS; putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
		;
    break;}
case 109:
#line 970 "rt.y"
{ yyval.pos=yyvsp[0].pos; ;
    break;}
case 110:
#line 973 "rt.y"
{ yyval.pos=yyvsp[0].pos; ;
    break;}
case 111:
#line 974 "rt.y"
{
			yyval.pos.pos=POS;
			installName(PARSER, yyvsp[0].name.hash, yyvsp[0].name.memvar, 1, -1, 0);
			putByte_Buf(PARSER->out, CLIP_MAKE_REF);
			putByte_Buf(PARSER->out, 0);
			add_deep(PARSER->curFunction, 1);
		 ;
    break;}
case 112:
#line 983 "rt.y"
{ yyval.pos = yyvsp[0].pos; yyval.pos.i = 1; ;
    break;}
case 113:
#line 984 "rt.y"
{yyval.pos.pos = POS; yyval.pos.i = 0; ;
    break;}
case 114:
#line 985 "rt.y"
{
			if (yyvsp[-1].pos.i == 0)
			{
				putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
				add_deep(PARSER->curFunction, 1);
				yyvsp[-1].pos.i = 1;
			}
		;
    break;}
case 115:
#line 992 "rt.y"
{
			yyval.pos = yyvsp[-3].pos;
			yyval.pos.i += 1;
		;
    break;}
case 116:
#line 998 "rt.y"
{yyval.pos.pos=POS; putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
		 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 117:
#line 1001 "rt.y"
{yyval.pos=yyvsp[0].pos;;
    break;}
case 118:
#line 1004 "rt.y"
{ yyval.pos=yyvsp[0].pos; yyval.pos.i=1;  ;
    break;}
case 119:
#line 1005 "rt.y"
{ yyval.pos=yyvsp[-2].pos; yyval.pos.i+=1; ;
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
#line 1007 "rt.y"


static int
nextn(Parser *pp, int n)
{
	if (pp->ptr<pp->end-n)
		return pp->ptr[n];
	else
		return 0;
}

static int
findnext(Parser *pp, int ch)
{
	char *p;
		for(p = pp->ptr; p<pp->end; p++)
		{
			switch(*p)
				{
				case ' ':
				case '\t':
					continue;
				}
				if (*p == ch)
					return 1;
			else
					return 0;
		}
		return 0;
}


static int
find_rptr(Parser *pp)
{
	int wt, ch;
	for(wt=0;;wt++)
	{
		ch = nextn(pp, wt);
		if (ch==' ' || ch=='\t')
			continue;
		if (ch=='-' && nextn(pp,wt+1)=='>')
		{
			pp->ptr += wt+2;
			return 1;
		}
		return 0;
	}

	return 0;
}

int
rtlex(yylvalp, pp)
	YYSTYPE *yylvalp;
	Parser *pp;
{
	int ch, next, tok=0, quot=0;
	char *beg=0;

	if (pp->ptr>=pp->end)
		return 0;

	for(;;)
	{
		ch = nextn(pp,0);
		next = nextn(pp,1);

		switch(pp->lex_state)
		{
		case L_norm:
			switch(ch)
			{
			case ' ':
			case '\t':
				break;
			case '.':
				switch(next)
				{
				case 't':
				case 'T':
				case 'y':
				case 'Y':
					if (nextn(pp,2)=='.')
					{
						pp->ptr+=2;
						tok=TRUE;
					}
					break;
				case 'n':
				case 'N':
					if (nextn(pp,4)=='.' && !strncasecmp(pp->ptr, ".NOT.",5))
					{
						pp->ptr+=4;
						tok=NOT;
					}
				case 'f':
				case 'F':
					if (nextn(pp,2)=='.')
					{
						pp->ptr+=2;
						tok=FALSE;
					}
					break;
				case 'a':
				case 'A':
					if (nextn(pp,4)=='.' && !strncasecmp(pp->ptr, ".AND.",5))
					{
						pp->ptr+=4;
						tok=AND;
					}
					break;
				case 'o':
				case 'O':
					if (nextn(pp,3)=='.' && !strncasecmp(pp->ptr, ".OR.",4))
					{
						pp->ptr+=3;
						tok=OR;
					}
					break;
				default:
					if (isdigit(next))
					{
						pp->lex_state = L_num;
						beg = pp->ptr;
						continue;
					}
					break;
				}
				if (!tok)
					tok='.';
				break;
			case '=':
				if (next=='=')
				{
					tok = EQ;
					pp->ptr++;
				}
				else
					tok = '=';
				break;
			case ':':
				if (next=='=')
				{
					tok = ASSIGN;
					pp->ptr++;
				}
				else
					tok = ':';
				break;
			case '*':
				if (next=='*')
				{
					tok = POW;
					pp->ptr++;
				}
				else if (next=='=')
				{
					tok = MULA;
					pp->ptr++;
				}
				else
					tok = '*';
				break;
			case '/':
				if (next=='=')
				{
					tok = DIVA;
					pp->ptr++;
				}
				else
					tok = '/';
				break;
			case '%':
				if (next=='=')
				{
					tok = MODA;
					pp->ptr++;
				}
				else
					tok = '%';
				break;
			case '+':
				if (next=='=')
				{
					tok = ADDA;
					pp->ptr++;
				}
				else if (next=='+')
				{
					tok = INCR;
					pp->ptr++;
				}
				else
					tok = '+';
				break;
			case '-':
				switch(next)
				{
				case '=':
					tok = SUBA;
					pp->ptr++;
					break;
				case '-':
					tok = INCR;
					pp->ptr++;
					break;
				case '>':
					tok = RPTR;
					pp->ptr++;
					break;
				default:
					tok='-';
					break;
				}
				break;
			case '^':
				if (next=='=')
				{
					tok = POWA;
					pp->ptr++;
				}
				else
					tok = POW;
				break;
			case '!':
				if (next=='=')
				{
					tok = NE;
					pp->ptr++;
				}
				else
					tok = NOT;
				break;
			case '#':
				tok = NE;
							break;
			case '<':
				tok = (next=='=' ? LE : (next=='>' ? NE: '<'));
				if (next=='=')
				{
					tok = LE;
					pp->ptr++;
				}
				else if (next=='>')
				{
					tok = NE;
					pp->ptr++;
				}
				else
					tok = '<';
				break;
			case '>':
				if (next=='=')
				{
					tok = GE;
					pp->ptr++;
				}
				else
					tok = '>';
				break;
			case '"':
				beg = pp->ptr;
				pp->lex_state = L_string;
				quot = '"';
				break;
			case '\'':
				beg = pp->ptr;
				pp->lex_state = L_string;
				quot = '\'';
				break;
			case '[':	/* ] */
				switch(pp->last_tok)
				{
				case '[':
				case ']':
				case NAME:
				case '&':
				case '.':
					tok='[';
					break;
				default:
					beg = pp->ptr;
					pp->lex_state = L_string;
					quot = ']';
					break;
				}
				break;
			default:
				if (isalpha(ch) || ch=='_' || (ch & 0x80) )
				{
					beg=pp->ptr;
					pp->lex_state=L_name;
				}
				else if (isdigit(ch))
				{
					beg=pp->ptr;
					if (ch=='0' && (next=='x'||next=='X'))
						pp->lex_state=L_xnum;
					else
						pp->lex_state=L_num;
				}
				else
					tok=ch;
				break;
			}
			break;
		case L_name:
			if (isalnum(ch) || ch=='_'|| (ch & 0x80) )
				;
			else
			{
				long l = _clip_casehashbytes(0, beg, pp->ptr-beg);
				pp->lex_state = L_norm;
				switch(l)
				{
				/* memvar */
				case HASH_memvar:
				/* m */
				case HASH_memva:
				case HASH_memv:
				case HASH_m:
					if (find_rptr(pp))
						tok = MEMVAR_PTR;
					else
						goto nam;
					break;
				/* field */
				case HASH_field:
				/* _field */
				case HASH__field:
				/* f */
				case HASH_f:
					if (find_rptr(pp))
						tok = FIELD_PTR;
					else
						goto nam;
					break;
				/* _field_ */
				case HASH___field__:
					pp->field_flag = !pp->field_flag;
					break;
				case HASH___rdd__:
					pp->rdd_flag = !pp->rdd_flag;
					if (pp->rdd_flag)
						tok=RDDBEG;
					else
						tok=RDDEND;
					break;
				case HASH_nil:
					tok = NIL;
					break;
				case HASH_pcount:
									if (!findnext(pp, '('))
											goto nam;
					tok = PCOUNT;
					break;
				case HASH_param:
									if (!findnext(pp, '('))
											goto nam;
					tok = PARAM;
					break;
				case HASH_if:
				case HASH_iif:
					tok = IF;
					break;
				default:
				nam:
					{
						char *s;
						int l = pp->ptr - beg;
						long hash;

						hash = yylvalp->Long = _clip_casehashbytes(0, beg, l);
						s = (char *) HashTable_fetch(pp->mp->hashnames, hash);
						if (!s)
						{
							s = _clip_memdup(beg, l);
							HashTable_store(pp->mp->hashnames, s, hash);
						}
					}
					tok = NAME;
				}
				goto ret;
			}
			break;
		case L_num:
			{
				char *s, *ss;
				int len,dec=0;

				if ( (isdigit(ch) || ( ch=='.' && isdigit(next))) )
					break;

				if (ch == '-' && next == '>')
								{
									pp->lex_state = L_norm;
					yylvalp->Long = atol(beg);
					tok = NAME;
										goto ret;
								}

				pp->lex_state = L_norm;
				tok = NUMBER;
				len = pp->ptr - beg;
				ss = _clip_memdup(beg, len);
				yylvalp->Double.d = _clip_strtod(ss, NULL);
				free(ss);
				for(s=beg; s<pp->ptr; s++)
					if (*s=='.')
						break;
				if (s<pp->ptr)
					dec = len-(s-beg)-1;
				if (len<10)
					len = 10;
				/*if (dec<2)
					dec = 2;*/
				if (dec>len)
					len = dec+1;
				yylvalp->Double.dec = dec;
				yylvalp->Double.len = len;
				goto ret;
			}
			break;
		case L_xnum:
			if (isxdigit(ch) || ch=='x' || ch=='X')
				;
			else
			{
				char *ss;
				int len;

				pp->lex_state = L_norm;
				tok = NUMBER;
				len = pp->ptr - beg;
				ss = _clip_memdup(beg, len);
				yylvalp->Double.d = strtoul(ss, NULL, 16);
				free(ss);
				yylvalp->Double.dec = 0;
				yylvalp->Double.len = len-2;
				goto ret;
			}
			break;
		case L_string:
			if (ch == quot )
			{
				pp->lex_state = L_norm;
				yylvalp->string.beg=beg+1;
				yylvalp->string.end=pp->ptr;
				tok = STRING;
			}
			else if (!ch)
			{
				rt_error(pp, "unterminated character string");
			}

			break;
		}
		if (!ch)
			return 0;
		pp->ptr++;
ret:		if (tok)
		{
			pp->last_tok=tok;
			return tok;
		}
	}
}


void
rt_error(Parser *parser, char *fmt,...)
{
	int l;
	va_list ap;

	++parser->errcount;
	if (!parser->errbuf)
	{
		parser->errbuf = (char*)malloc(ERRBUFSIZE);
		snprintf(parser->errbuf, ERRBUFSIZE, "runtime compiler error:");
	}

	l = strlen(parser->errbuf);

	snprintf(parser->errbuf, ERRBUFSIZE-l, "\n%ld: pos %ld: ", (long)(parser->errcount), (long)((parser->ptr-parser->beg)+1));
	l = strlen(parser->errbuf);
	va_start(ap, fmt);
	vsnprintf(parser->errbuf, ERRBUFSIZE-l, fmt, ap);
	va_end(ap);
	l = strlen(parser->errbuf);
}

static void
put_function( OutBuf *bp, Function *fp, long *loffs, int isPub)
{
	int codelen=fp->out.ptr-fp->out.buf;
	int lp, i;

	LONGVAL(*loffs,0);
	LONGINCR(*loffs);
	LONGVAL(*loffs,BEGOFFS);
	LONGINCR(*loffs);
	putLong_Buf(bp, BEGOFFS);
	lp=CUROFFS;
	putLong_Buf(bp, 0);
	putLong_Buf(bp, codelen);
	putByte_Buf(bp, isPub);
	putShort_Buf(bp, fp->params_count); /* no locals!!! */
	putShort_Buf(bp, 1); /* no uplocals!!! */
	putShort_Buf(bp, fp->maxdeep+1);
	putShort_Buf(bp, fp->memvars_count); /* num of declared privates/parameters */
	putShort_Buf(bp, fp->params_count);
	for(i=0;i<fp->memvars_count;++i)
		putLong_Buf(bp, fp->memvars[i]);
	putByte_Buf(bp, 16); /* length of name */
	putBuf_Buf(bp, "RUNTIME_COMPILED", 17);
	putByte_Buf(bp, 0); /* null-terminated func name */

	LONGVAL(lp,BEGOFFS);
	putBuf_Buf(bp, fp->out.buf, codelen);
}

static void
init_Function(Function *fp)
{
	memset(fp,0,sizeof(Function));
	init_Buf( &fp->out);
}

static void
destroy_Function(Function *fp)
{
	free(fp->memvars);
	destroy_Buf(& fp->out);
}

int
_clip_compile_Block(ClipMachine * mp, char *str, int len, ClipBlock * dest)
{
	Parser parser;
	int ret=0,i;

	memset(&parser, 0, sizeof(parser));
	parser.beg = parser.ptr = str;
	parser.end = str+len;
	parser.mp=mp;
	init_Function(&parser.main);
	parser.curFunction = &parser.main;
	parser.lex_state = L_norm;
	parser.out=&parser.main.out;

	ret = rtparse(&parser);

	if (ret)
	{
		dest->file = 0;
		dest->func = 0;
		_clip_trap_printf( mp, mp->fp->filename, mp->fp->line,
			"runtime codeblock compiler: '%.*s': %s",
			len, str, parser.errbuf);
	}
	else
	{
		/* generate full module */
		ClipFile *file = dest->file = NEW(ClipFile);
		int l, foffs, soffs;
		long loffs;
		time_t ts;
		int numOffs, strOffs;
		int funcOffs, modlen;
		OutBuf mod, *bp=&mod;

		file->refCount = 1;
		file->bodyMem = 1;
		file->staticsMem = 3;

		init_Buf(bp);

		putBuf_Buf(bp, "!<pobj>\n", 8);
		time(&ts);
		putLong_Buf(bp,ts);
		modlen = CUROFFS;
		putLong_Buf(bp,0);
		/* modbeg */
		putLong_Buf(bp,0);
		putLong_Buf(bp,0); /* 1?? */
		putShort_Buf(bp, parser.numbers_count);
		putShort_Buf(bp, parser.strings_count);
		putLong_Buf(bp,1); /* pubcount */
		putLong_Buf(bp,parser.codeblocks_count+1); /* allcount */
		numOffs = CUROFFS;
		putShort_Buf(bp, 0);
		strOffs = CUROFFS;
		putShort_Buf(bp, 0);
		/* init offs */
		putLong_Buf(bp, 0);
		funcOffs = CUROFFS;
		putLong_Buf(bp, 0);
		/* initcount */
		putShort_Buf(bp, 0);
		/* exitcount */
		putShort_Buf(bp, 0);
		/* filename */
		putBuf_Buf(bp, str, len);
		putByte_Buf(bp, 0);

		SHORTVAL(numOffs,BEGOFFS);
		for(i=0; i<parser.numbers_count; ++i)
			putDouble_Buf(bp,parser.numbers[i]);
		for(i=0; i<parser.numbers_count; ++i)
			putByte_Buf(bp,parser.lendec[i].len);
		for(i=0; i<parser.numbers_count; ++i)
			putByte_Buf(bp,parser.lendec[i].dec);
		SHORTVAL(strOffs,BEGOFFS);
		soffs = CUROFFS;
		for(i=0; i<parser.strings_count; ++i)
		{
			putLong_Buf(bp, 0);
			putLong_Buf(bp, 0);
		}
		for(i=0; i<parser.strings_count; ++i)
		{
			char *s = parser.strings[i];
			char *e = parser.strings_end[i];
			int len = e-s;
			LONGVAL(soffs,len);
			LONGINCR(soffs);
			LONGVAL(soffs,BEGOFFS);
			LONGINCR(soffs);
			putBuf_Buf(bp, s, len);
			putByte_Buf(bp, 0);
		}
		loffs = CUROFFS;
		LONGVAL(funcOffs,BEGOFFS);
		for(i=0; i<parser.codeblocks_count+1; ++i)
		{
			putLong_Buf(bp, 0);
			putLong_Buf(bp, 0);
		}
		foffs = bp->ptr - bp->buf /*BEGOFFS*/ ;
		put_function(bp, &parser.main, &loffs, 1);
		for(i=0;i<parser.codeblocks_count;++i)
			put_function(bp, parser.codeblocks+i, &loffs, 0);
		LONGVAL(modlen,BEGOFFS);

		l = file->bodySize = CUROFFS;
		file->mem = file->body = (char*)realloc(bp->buf, l);
		dest->func = file->body+foffs;
	}

/*_return:*/

	free(parser.numbers);
	free(parser.strings);
	free(parser.strings_end);
	free(parser.lendec);
	destroy_Function(&parser.main);

	for(i=0;i<parser.codeblocks_count;++i)
		destroy_Function(parser.codeblocks+i);
	free(parser.codeblocks);
	free(parser.errbuf);

	return ret;
}

static int
installName(Parser *parser, long hash, int memvar, int lval, long area, int fld)
{
	int no, num, ret=0;

	switch(memvar)
	{
	case 0:
		for(no=0,num=parser->curFunction->params_count;no<num;++no)
			if ( parser->curFunction->params[no]==hash )
				break;
		if (no!=num)
		{
			if (lval)
				putByte_Buf(parser->out, CLIP_PUSH_REF_LOCAL);
			else
				putByte_Buf(parser->out, CLIP_PUSH_LOCAL);
			putShort_Buf(parser->out, no);
			break;
		}
		if (lval)
		{
			if (fld)
			{
				putByte_Buf(parser->out, CLIP_FM_IASSIGN);
				putLong_Buf(parser->out, hash);
			}
			else
				putByte_Buf(parser->out, CLIP_PUSH_REF_MEMVAR);
		}
		else
		{
			int fno;
			if (parser->rdd_flag1 && (fno=_clip_rddfieldno(parser->mp, parser->rdd_no, hash)) >= 0)
			{
				putByte_Buf(parser->out, CLIP_RDDFIELD);
				putShort_Buf(parser->out, parser->rdd_no);
				putShort_Buf(parser->out, fno);
				break;
			}
			else
				putByte_Buf(parser->out, CLIP_PUSH_FMEMVAR);
		}
		putLong_Buf(parser->out, hash);
		break;
	case 1:
		if (lval)
			putByte_Buf(parser->out, CLIP_PUSH_REF_MEMVAR);
		else
			putByte_Buf(parser->out, CLIP_PUSH_MEMVAR);
		putLong_Buf(parser->out, hash);
		break;
	case 2:
		if (lval)
		{
			putByte_Buf(parser->out, CLIP_IASSIGN_FIELD);
			ret = 1;
		}
		else
			putByte_Buf(parser->out, CLIP_FIELD);
		putLong_Buf(parser->out, hash);
		putLong_Buf(parser->out, area);
		break;
	}
	return ret;
}

static void
gen_op(Parser *parser, int op)
{
	putByte_Buf(parser->out, CLIP_OP);
	putByte_Buf(parser->out, op);
}


static void
add_deep(Function *fp, int no)
{
	fp->curdeep+=no;
	if (fp->curdeep>fp->maxdeep)
		fp->maxdeep=fp->curdeep;
}


