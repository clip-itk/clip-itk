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

#line 233 "rt.y"


#include <clip.h>
#include <clipvm.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdarg.h>
#include <ctype.h>
#include "hashcode.h"
#include "hash.h"

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

#define LONGVAL(offs) (*(long*)(bp->buf+(offs)))
#define SHORTVAL(offs) (*(short*)(bp->buf+(offs)))
#define LONGINCR(offs) ((offs)+=sizeof(long));
#define SHORTINCR(offs) ((offs)+=sizeof(short));

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


#line 336 "rt.y"
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



#define	YYFINAL		203
#define	YYFLAG		-32768
#define	YYNTBASE	57

/* YYTRANSLATE(YYLEX) -- Bison token number corresponding to YYLEX. */
#define YYTRANSLATE(x) ((unsigned)(x) <= 289 ? yytranslate[x] : 93)

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
      20,    22,    24,    29,    32,    33,    40,    41,    48,    50,
      57,    58,    64,    69,    73,    74,    83,    87,    88,    94,
      98,    99,   104,   110,   116,   120,   124,   128,   132,   136,
     140,   144,   148,   152,   156,   160,   164,   168,   171,   174,
     177,   180,   183,   186,   189,   190,   196,   200,   201,   209,
     213,   218,   219,   220,   233,   234,   240,   241,   247,   249,
     252,   255,   257,   260,   263,   264,   265,   268,   270,   272,
     274,   276,   278,   280,   282,   287,   292,   296,   300,   301,
     303,   307,   309,   312,   315,   319,   324,   326,   330,   331,
     333,   334,   336,   337,   342,   346,   347,   349,   351,   354,
     356,   357,   358,   363,   364,   366,   368
};
static const short yyrhs[] =
{
      58,     0,    60,     0,     0,    58,    47,    59,    60,     0,
       4,     0,     3,     0,     9,     0,    10,     0,    11,     0,
      81,     0,    83,     0,    73,    48,    60,    49,     0,    73,
      82,     0,     0,     5,    48,    75,    61,    85,    49,     0,
       0,    82,    48,    75,    62,    85,    49,     0,    79,     0,
      73,    48,    60,    49,    17,    60,     0,     0,    73,    82,
      63,    17,    60,     0,    81,    78,    75,    60,     0,    79,
      78,    60,     0,     0,    60,    45,     5,    48,    75,    64,
      85,    49,     0,     5,     6,     5,     0,     0,     5,     6,
      75,    65,    83,     0,    83,     6,     5,     0,     0,    83,
       6,    66,    83,     0,     5,     6,     5,    17,    60,     0,
      83,     6,     5,    17,    60,     0,    60,    34,    60,     0,
      60,    32,    60,     0,    60,    33,    60,     0,    60,    28,
      60,     0,    60,    30,    60,     0,    60,    31,    60,     0,
      60,    29,    60,     0,    60,    35,    60,     0,    60,    37,
      60,     0,    60,    36,    60,     0,    60,    38,    60,     0,
      60,    39,    60,     0,    60,    40,    60,     0,    27,    60,
       0,    36,    60,     0,    35,    60,     0,    42,    60,     0,
      60,    42,     0,    43,    60,     0,    60,    43,     0,     0,
      15,     4,    67,    60,    16,     0,    50,    89,    51,     0,
       0,    50,    52,    68,    76,    77,    58,    51,     0,    12,
      48,    49,     0,    13,    48,    60,    49,     0,     0,     0,
      14,    48,    60,    47,    75,    69,    60,    47,    75,    70,
      60,    49,     0,     0,    60,    26,    75,    71,    60,     0,
       0,    60,    25,    75,    72,    60,     0,     7,     0,    73,
       7,     0,    74,     7,     0,     8,     0,    73,     8,     0,
      74,     8,     0,     0,     0,    80,    52,     0,    17,     0,
      18,     0,    19,     0,    22,     0,    20,     0,    21,     0,
      23,     0,    60,    46,    92,    53,     0,    79,    46,    92,
      53,     0,    60,    45,     5,     0,    79,    45,     5,     0,
       0,     5,     0,    80,    47,     5,     0,     5,     0,    74,
       5,     0,    73,     5,     0,    54,    81,    84,     0,    54,
      48,    60,    49,     0,    82,     0,    48,    60,    49,     0,
       0,    55,     0,     0,    88,     0,     0,    47,    75,    86,
      87,     0,    85,    47,    87,     0,     0,    88,     0,    60,
       0,    56,    81,     0,    60,     0,     0,     0,    89,    47,
      90,    91,     0,     0,    60,     0,    60,     0,    92,    47,
      60,     0
};

#endif

#if YYDEBUG
/* YYRLINE[YYN] -- source line where rule number YYN was defined. */
static const short yyrline[] =
{
       0,   396,   402,   403,   403,   411,   435,   457,   460,   463,
     467,   470,   479,   484,   492,   492,   505,   505,   517,   524,
     532,   532,   542,   570,   592,   592,   611,   630,   630,   641,
     658,   658,   667,   676,   683,   684,   685,   686,   687,   688,
     689,   690,   691,   692,   693,   694,   695,   696,   697,   698,
     699,   700,   701,   702,   703,   703,   712,   718,   718,   733,
     737,   741,   741,   741,   758,   758,   770,   770,   783,   784,
     785,   788,   789,   790,   793,   796,   804,   826,   827,   828,
     829,   830,   831,   832,   835,   836,   837,   843,   851,   852,
     857,   867,   868,   869,   872,   877,   883,   884,   887,   888,
     891,   892,   893,   893,   895,   898,   901,   904,   905,   914,
     915,   916,   916,   929,   932,   935,   936
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
  "@11", "@12", "@13", "fieldptr", "memvarptr", "pos", "func", "code", 
  "assign", "arr", "param_list", "name", "mname", "mename", "dot", 
  "arglist", "@14", "earg", "arg", "exprlist", "@15", "nexpr", 
  "expr_list", 0
};
#endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives. */
static const short yyr1[] =
{
       0,    57,    58,    59,    58,    60,    60,    60,    60,    60,
      60,    60,    60,    60,    61,    60,    62,    60,    60,    60,
      63,    60,    60,    60,    64,    60,    60,    65,    60,    60,
      66,    60,    60,    60,    60,    60,    60,    60,    60,    60,
      60,    60,    60,    60,    60,    60,    60,    60,    60,    60,
      60,    60,    60,    60,    67,    60,    60,    68,    60,    60,
      60,    69,    70,    60,    71,    60,    72,    60,    73,    73,
      73,    74,    74,    74,    75,    76,    77,    78,    78,    78,
      78,    78,    78,    78,    79,    79,    79,    79,    80,    80,
      80,    81,    81,    81,    82,    82,    83,    83,    84,    84,
      85,    85,    86,    85,    85,    87,    87,    88,    88,    89,
      89,    90,    89,    91,    91,    92,    92
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN. */
static const short yyr2[] =
{
       0,     1,     1,     0,     4,     1,     1,     1,     1,     1,
       1,     1,     4,     2,     0,     6,     0,     6,     1,     6,
       0,     5,     4,     3,     0,     8,     3,     0,     5,     3,
       0,     4,     5,     5,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     2,     2,     2,
       2,     2,     2,     2,     0,     5,     3,     0,     7,     3,
       4,     0,     0,    12,     0,     5,     0,     5,     1,     2,
       2,     1,     2,     2,     0,     0,     2,     1,     1,     1,
       1,     1,     1,     1,     4,     4,     3,     3,     0,     1,
       3,     1,     2,     2,     3,     4,     1,     3,     0,     1,
       0,     1,     0,     4,     3,     0,     1,     1,     2,     1,
       0,     0,     4,     0,     1,     1,     3
};

/* YYDEFACT[S] -- default rule to reduce with in state S when YYTABLE
   doesn't specify something else to do.  Zero means the default is an
   error. */
static const short yydefact[] =
{
       0,     6,     5,    91,    68,    71,     7,     8,     9,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   110,
       0,     1,     2,     0,     0,    18,    10,    96,    11,    74,
      74,     0,     0,     0,    54,    47,    49,    48,    50,    52,
       0,    57,   109,     0,    91,     0,     0,    98,     3,    74,
      74,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    51,    53,     0,     0,    93,    69,
      72,     0,    13,    92,    70,    73,    77,    78,    79,    81,
      82,    80,    83,     0,     0,     0,    74,    74,    30,    26,
      27,    14,    59,     0,     0,     0,    97,    75,   111,    56,
       0,    99,    94,     0,    66,    64,    37,    40,    38,    39,
      35,    36,    34,    41,    43,    42,    44,    45,    46,    86,
     115,     0,     0,     0,    87,     0,    23,     0,    16,    29,
       0,     0,     0,   100,    60,    74,     0,    88,   113,    95,
       4,     0,     0,    74,     0,    84,    12,     0,    85,    22,
     100,     0,    96,    31,    32,    28,    74,     0,   107,     0,
     101,    61,    55,    89,     0,     0,   114,   112,    67,    65,
      24,   116,     0,    21,     0,    33,   102,   108,   105,    15,
       0,     0,     0,    76,   100,    19,    17,   105,   104,   106,
       0,    58,    90,     0,   103,    74,    25,    62,     0,     0,
      63,     0,     0,     0
};

static const short yydefgoto[] =
{
     201,    21,   103,   158,   133,   150,   123,   184,   132,   130,
      95,    97,   180,   198,   142,   141,    23,    24,    90,   137,
     164,    85,    25,   165,    26,    27,    28,   102,   159,   187,
     188,   160,    43,   138,   167,   121
};

static const short yypact[] =
{
     334,-32768,-32768,    -5,-32768,-32768,-32768,-32768,-32768,   -39,
      32,    35,    27,   334,   334,   334,   334,   334,   334,   282,
      29,     1,   542,    18,    34,    79,    69,    45,    88,   100,
  -32768,    60,   334,   334,-32768,   582,   -24,   -24,     4,     4,
     386,-32768,   542,    -7,-32768,   334,    99,    57,-32768,-32768,
  -32768,   334,   334,   334,   334,   334,   334,   334,   334,   334,
     334,   334,   334,   334,-32768,-32768,   114,   334,-32768,-32768,
  -32768,   334,   105,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,   118,   334,   334,-32768,-32768,   124,   113,
  -32768,-32768,-32768,   408,   496,   334,-32768,-32768,-32768,-32768,
     430,-32768,-32768,   334,-32768,-32768,   117,   117,   117,   117,
     117,   117,   117,    36,    36,    36,     4,     4,     4,    84,
     542,   -41,   452,   116,-32768,   -23,   542,   334,-32768,   119,
     -19,   334,   -19,   174,-32768,-32768,   364,   130,   334,-32768,
     542,   334,   334,-32768,   334,-32768,   120,   334,-32768,   542,
     174,   334,-32768,-32768,   542,-32768,-32768,   103,   542,    21,
  -32768,-32768,-32768,-32768,   334,   -42,   542,-32768,   563,   582,
  -32768,   542,   334,   542,    68,   542,-32768,-32768,   228,-32768,
     334,    22,   138,-32768,   174,   542,-32768,   228,-32768,-32768,
     519,-32768,-32768,    71,-32768,-32768,-32768,-32768,   334,   474,
  -32768,   145,   146,-32768
};

static const short yypgoto[] =
{
  -32768,   -15,-32768,     0,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,   -18,-32768,   -22,-32768,
  -32768,   122,-32768,-32768,   -17,   -16,    -4,-32768,  -146,-32768,
     -37,  -167,-32768,-32768,-32768,    74
};


#define	YYLAST		628


static const short yytable[] =
{
      22,    29,    46,    47,   174,   182,   144,    72,    91,    31,
     183,   189,   145,    35,    36,    37,    38,    39,    40,    42,
     189,    66,    67,    68,   144,    69,    70,   104,   105,    18,
     148,    34,    93,    94,    44,    20,     4,     5,   193,    73,
      98,    74,    75,    30,    99,   100,    64,    65,    48,    66,
      67,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   127,   128,    71,   120,   178,    48,
     179,   122,    20,   191,    61,    62,    63,    45,    64,    65,
      32,    66,    67,    33,   120,   126,    76,    77,    78,    79,
      80,    81,    82,    87,    88,   136,    76,    77,    78,    79,
      80,    81,    82,   140,    68,    89,    69,    70,    44,    92,
       4,     5,   101,   161,   152,   178,   152,   186,   178,   119,
     196,   170,   -20,   124,    83,    84,   153,   149,   155,   129,
     131,   154,   143,   147,   176,   163,   151,   172,   166,    46,
     177,   168,   169,   192,   171,   202,   203,   173,    86,   181,
     194,   175,    58,    59,    60,    61,    62,    63,   125,    64,
      65,     0,    66,    67,    22,     0,     0,     0,     0,     0,
       0,     0,   185,   197,     0,     0,     0,     1,     2,     3,
     190,     4,     5,     6,     7,     8,     9,    10,    11,    12,
       0,     0,     0,     0,     0,     0,     0,     0,   199,     0,
       0,    13,     0,     0,     0,     0,     0,     0,     0,    14,
      15,     0,     0,     0,     0,     0,    16,    17,     0,     0,
       0,   156,    18,     0,    19,     0,     0,     0,    20,     0,
     157,     1,     2,     3,     0,     4,     5,     6,     7,     8,
       9,    10,    11,    12,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    13,     0,     0,     0,     0,
       0,     0,     0,    14,    15,     0,     0,     0,     0,     0,
      16,    17,     0,     0,     0,     0,    18,     0,    19,     0,
       0,     0,    20,     0,   157,     1,     2,     3,     0,     4,
       5,     6,     7,     8,     9,    10,    11,    12,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    13,
       0,     0,     0,     0,     0,     0,     0,    14,    15,     0,
       0,     0,     0,     0,    16,    17,     0,     0,     0,     0,
      18,     0,    19,     0,    41,     0,    20,     1,     2,     3,
       0,     4,     5,     6,     7,     8,     9,    10,    11,    12,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    13,     0,     0,     0,     0,     0,     0,     0,    14,
      15,     0,     0,     0,     0,     0,    16,    17,     0,     0,
     162,     0,    18,     0,    19,     0,     0,     0,    20,    49,
      50,     0,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    61,    62,    63,     0,    64,    65,     0,    66,
      67,    49,    50,     0,    51,    52,    53,    54,    55,    56,
      57,    58,    59,    60,    61,    62,    63,     0,    64,    65,
       0,    66,    67,    49,    50,    96,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,     0,
      64,    65,     0,    66,    67,    49,    50,   134,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,     0,    64,    65,     0,    66,    67,    49,    50,   139,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,     0,    64,    65,     0,    66,    67,    49,
      50,   146,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    61,    62,    63,     0,    64,    65,     0,    66,
      67,    49,    50,   200,    51,    52,    53,    54,    55,    56,
      57,    58,    59,    60,    61,    62,    63,     0,    64,    65,
       0,    66,    67,   135,    49,    50,     0,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
       0,    64,    65,     0,    66,    67,   195,    49,    50,     0,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,     0,    64,    65,     0,    66,    67,    50,
       0,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,     0,    64,    65,     0,    66,    67,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,     0,    64,    65,     0,    66,    67
};

static const short yycheck[] =
{
       0,     6,    20,    20,   150,    47,    47,    23,    30,    48,
      52,   178,    53,    13,    14,    15,    16,    17,    18,    19,
     187,    45,    46,     5,    47,     7,     8,    49,    50,    48,
      53,     4,    32,    33,     5,    54,     7,     8,   184,     5,
      47,     7,     8,    48,    51,    45,    42,    43,    47,    45,
      46,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    86,    87,    48,    67,    47,    47,
      49,    71,    54,    51,    38,    39,    40,    48,    42,    43,
      48,    45,    46,    48,    84,    85,    17,    18,    19,    20,
      21,    22,    23,    48,     6,    95,    17,    18,    19,    20,
      21,    22,    23,   103,     5,     5,     7,     8,     5,    49,
       7,     8,    55,   135,   130,    47,   132,    49,    47,     5,
      49,   143,    17,     5,    45,    46,   130,   127,   132,     5,
      17,   131,    48,    17,   156,     5,    17,    17,   138,   157,
     157,   141,   142,     5,   144,     0,     0,   147,    26,   164,
     187,   151,    35,    36,    37,    38,    39,    40,    84,    42,
      43,    -1,    45,    46,   164,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   172,   195,    -1,    -1,    -1,     3,     4,     5,
     180,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   198,    -1,
      -1,    27,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    35,
      36,    -1,    -1,    -1,    -1,    -1,    42,    43,    -1,    -1,
      -1,    47,    48,    -1,    50,    -1,    -1,    -1,    54,    -1,
      56,     3,     4,     5,    -1,     7,     8,     9,    10,    11,
      12,    13,    14,    15,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    27,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    35,    36,    -1,    -1,    -1,    -1,    -1,
      42,    43,    -1,    -1,    -1,    -1,    48,    -1,    50,    -1,
      -1,    -1,    54,    -1,    56,     3,     4,     5,    -1,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    27,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    35,    36,    -1,
      -1,    -1,    -1,    -1,    42,    43,    -1,    -1,    -1,    -1,
      48,    -1,    50,    -1,    52,    -1,    54,     3,     4,     5,
      -1,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    27,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    35,
      36,    -1,    -1,    -1,    -1,    -1,    42,    43,    -1,    -1,
      16,    -1,    48,    -1,    50,    -1,    -1,    -1,    54,    25,
      26,    -1,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    -1,    42,    43,    -1,    45,
      46,    25,    26,    -1,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    -1,    42,    43,
      -1,    45,    46,    25,    26,    49,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    -1,
      42,    43,    -1,    45,    46,    25,    26,    49,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    -1,    42,    43,    -1,    45,    46,    25,    26,    49,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    -1,    42,    43,    -1,    45,    46,    25,
      26,    49,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    -1,    42,    43,    -1,    45,
      46,    25,    26,    49,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    -1,    42,    43,
      -1,    45,    46,    47,    25,    26,    -1,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      -1,    42,    43,    -1,    45,    46,    47,    25,    26,    -1,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    -1,    42,    43,    -1,    45,    46,    26,
      -1,    28,    29,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    -1,    42,    43,    -1,    45,    46,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    -1,    42,    43,    -1,    45,    46
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
#line 396 "rt.y"
{
		yyval.pos = yyvsp[0].pos;
		putByte_Buf(PARSER->out,CLIP_RETURN_POP);
	;
    break;}
case 3:
#line 403 "rt.y"
{
			putByte_Buf(PARSER->out,CLIP_POP);
		;
    break;}
case 4:
#line 406 "rt.y"
{
			yyval.pos=yyvsp[-3].pos;
		;
    break;}
case 5:
#line 411 "rt.y"
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
#line 435 "rt.y"
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
#line 457 "rt.y"
{ yyval.pos.pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_TRUE);
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 8:
#line 460 "rt.y"
{ yyval.pos.pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_FALSE);
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 9:
#line 463 "rt.y"
{ yyval.pos.pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_NIL);
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 10:
#line 467 "rt.y"
{ yyval.pos.pos=POS; installName(PARSER, yyvsp[0].name.hash, yyvsp[0].name.memvar, 0, -1, 0);
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 11:
#line 470 "rt.y"
{ yyval.pos=yyvsp[0].pos;
			 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 12:
#line 479 "rt.y"
{
			yyval.pos=yyvsp[-1].pos;
			putByte_Buf(PARSER->out, CLIP_FIELD_POP_NAME);
		;
    break;}
case 13:
#line 484 "rt.y"
{
			yyval.pos=yyvsp[0].pos;
			PARSER->out->ptr[-1] = CLIP_NOP;
			putByte_Buf(PARSER->out, CLIP_FIELD_POP_NAME);
		;
    break;}
case 14:
#line 493 "rt.y"
{ putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
			yyvsp[0].pos.i = PARSER->curFunction->curdeep;
		;
    break;}
case 15:
#line 498 "rt.y"
{
			PARSER->curFunction->curdeep = yyvsp[-3].pos.i;
			putByte_Buf(PARSER->out, CLIP_FUNC);
			putByte_Buf(PARSER->out, yyvsp[-1].pos.i);
			putLong_Buf(PARSER->out, yyvsp[-5].Long);
			yyval.pos=yyvsp[-3].pos;
		;
    break;}
case 16:
#line 506 "rt.y"
{ putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
			yyvsp[0].pos.i = PARSER->curFunction->curdeep;
		;
    break;}
case 17:
#line 510 "rt.y"
{
			PARSER->curFunction->curdeep = yyvsp[-3].pos.i;
			yyval.pos=yyvsp[-5].pos;
			putByte_Buf(PARSER->out, CLIP_FUNC_NAME);
			putByte_Buf(PARSER->out, yyvsp[-1].pos.i);
		;
    break;}
case 18:
#line 517 "rt.y"
{
			yyval.pos=yyvsp[0].pos;
			putByte_Buf(PARSER->out,CLIP_IFETCH);
			putByte_Buf(PARSER->out,yyvsp[0].pos.i-1);
			add_deep(PARSER->curFunction, 1);
		;
    break;}
case 19:
#line 524 "rt.y"
{
			yyval.pos=yyvsp[-3].pos;
			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_PFIELD);
			putLong_Buf(PARSER->out, -1);
		;
    break;}
case 20:
#line 532 "rt.y"
{
			PARSER->out->ptr[-1] = CLIP_NOP;
		;
    break;}
case 21:
#line 534 "rt.y"
{
			yyval.pos=yyvsp[-3].pos;
			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_PFIELD);
			putLong_Buf(PARSER->out, -1);
		;
    break;}
case 22:
#line 544 "rt.y"
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
case 23:
#line 571 "rt.y"
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
case 24:
#line 593 "rt.y"
{
			yyvsp[0].pos.i = PARSER->curFunction->curdeep;
		;
    break;}
case 25:
#line 597 "rt.y"
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
case 26:
#line 611 "rt.y"
{
			yyval.pos.pos=POS;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_FIELD);
			putLong_Buf(PARSER->out, yyvsp[0].Long);
			putLong_Buf(PARSER->out, yyvsp[-2].Long);
		;
    break;}
case 27:
#line 630 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PUSH_AREA);
			putLong_Buf(PARSER->out, yyvsp[-2].Long);
		;
    break;}
case 28:
#line 636 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_POP_AREA);
			yyval.pos=yyvsp[-2].pos;
		;
    break;}
case 29:
#line 642 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_FIELD_POP);
			putLong_Buf(PARSER->out, yyvsp[0].Long);
			yyval.pos=yyvsp[-2].pos;
		;
    break;}
case 30:
#line 659 "rt.y"
{ putByte_Buf(PARSER->out, CLIP_PUSH_AREA_POP);	;
    break;}
case 31:
#line 661 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_POP_AREA);
			yyval.pos=yyvsp[-3].pos;
		;
    break;}
case 32:
#line 668 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_FIELD);
			putLong_Buf(PARSER->out, yyvsp[-2].Long);
			putLong_Buf(PARSER->out, yyvsp[-4].Long);
			yyval.pos=yyvsp[0].pos;
		;
    break;}
case 33:
#line 676 "rt.y"
{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_FIELD_POP);
			putLong_Buf(PARSER->out, yyvsp[-2].Long);
			yyval.pos=yyvsp[-4].pos;
		;
    break;}
case 34:
#line 683 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, 'e'); ;
    break;}
case 35:
#line 684 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, 'E'); ;
    break;}
case 36:
#line 685 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, 'N'); ;
    break;}
case 37:
#line 686 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '>'); ;
    break;}
case 38:
#line 687 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '<'); ;
    break;}
case 39:
#line 688 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, 'L'); ;
    break;}
case 40:
#line 689 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, 'G'); ;
    break;}
case 41:
#line 690 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '+'); ;
    break;}
case 42:
#line 691 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '$'); ;
    break;}
case 43:
#line 692 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '-'); ;
    break;}
case 44:
#line 693 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '*'); ;
    break;}
case 45:
#line 694 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '/'); ;
    break;}
case 46:
#line 695 "rt.y"
{ yyval.pos=yyvsp[-2].pos; gen_op(PARSER, '%'); ;
    break;}
case 47:
#line 696 "rt.y"
{ yyval.pos=yyvsp[0].pos; putByte_Buf(PARSER->out, CLIP_NOT); ;
    break;}
case 48:
#line 697 "rt.y"
{ yyval.pos=yyvsp[0].pos; putByte_Buf(PARSER->out, CLIP_MINUS); ;
    break;}
case 49:
#line 698 "rt.y"
{ yyval.pos=yyvsp[0].pos; ;
    break;}
case 50:
#line 699 "rt.y"
{ yyval.pos=yyvsp[0].pos; ;
    break;}
case 51:
#line 700 "rt.y"
{ yyval.pos=yyvsp[-1].pos; ;
    break;}
case 52:
#line 701 "rt.y"
{ yyval.pos=yyvsp[0].pos; ;
    break;}
case 53:
#line 702 "rt.y"
{ yyval.pos=yyvsp[-1].pos; ;
    break;}
case 54:
#line 703 "rt.y"
{
				PARSER->rdd_no = yyvsp[0].Double.d;
				PARSER->rdd_flag1 = 1;
			;
    break;}
case 55:
#line 707 "rt.y"
{
				yyval.pos=yyvsp[-1].pos;
				PARSER->rdd_flag1 = 0;
			;
    break;}
case 56:
#line 712 "rt.y"
{
			add_deep(PARSER->curFunction, yyvsp[-1].pos.i+1);
			yyval.pos=yyvsp[-1].pos;
			putByte_Buf(PARSER->out, CLIP_ARRAY);
			putLong_Buf(PARSER->out, yyvsp[-1].pos.i);
		;
    break;}
case 57:
#line 718 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_PUSH_CODE);
			putShort_Buf(PARSER->out, PARSER->codeblocks_count+1);
			putByte_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, 0);
			/* uplocals */
			/*putShort_Buf(PARSER->out, 0);*/
		;
    break;}
case 58:
#line 726 "rt.y"
{
			putByte_Buf(PARSER->out,CLIP_RETURN_POP);
			PARSER->curFunction = (yyvsp[-3].pos.i==-1?&PARSER->main:PARSER->codeblocks+yyvsp[-3].pos.i);
			PARSER->out = &PARSER->curFunction->out;
			add_deep(PARSER->curFunction, 1);
			yyval.pos.pos = yyvsp[-3].pos.pos;
		;
    break;}
case 59:
#line 733 "rt.y"
{ yyval.pos.pos=POS;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PCOUNT);
		;
    break;}
case 60:
#line 737 "rt.y"
{ yyval.pos=yyvsp[-1].pos;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PARN);
		;
    break;}
case 61:
#line 742 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_COND);
			putShort_Buf(PARSER->out, 0);
		;
    break;}
case 62:
#line 747 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_GOTO);
			putShort_Buf(PARSER->out, 0);
			*(short*)(PARSER->out->buf+yyvsp[-4].pos.pos+1) = (POS-(yyvsp[-4].pos.pos+1+sizeof(short)));
		;
    break;}
case 63:
#line 753 "rt.y"
{
			*(short*)(PARSER->out->buf+yyvsp[-3].pos.pos+1) = (POS-(yyvsp[-3].pos.pos+1+sizeof(short)));
			yyval.pos=yyvsp[-9].pos;
		;
    break;}
case 64:
#line 759 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_TCOND);
			putShort_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, CLIP_POP);
		;
    break;}
case 65:
#line 765 "rt.y"
{
			yyval.pos=yyvsp[-4].pos;
			*(short*)(PARSER->out->buf+yyvsp[-2].pos.pos+1) = (POS-(yyvsp[-2].pos.pos+1+sizeof(short)));
		;
    break;}
case 66:
#line 771 "rt.y"
{
			putByte_Buf(PARSER->out, CLIP_ITCOND);
			putShort_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, CLIP_POP);
		;
    break;}
case 67:
#line 777 "rt.y"
{
			yyval.pos=yyvsp[-4].pos;
			*(short*)(PARSER->out->buf+yyvsp[-2].pos.pos+1) = (POS-(yyvsp[-2].pos.pos+1+sizeof(short)));
		;
    break;}
case 74:
#line 793 "rt.y"
{ yyval.pos.pos = POS; ;
    break;}
case 75:
#line 796 "rt.y"
{ 	if (PARSER->curFunction==&PARSER->main)
			yyval.pos.i=-1;
		else
			yyval.pos.i=PARSER->curFunction-PARSER->codeblocks;
		yyval.pos.pos=POS;
	;
    break;}
case 76:
#line 805 "rt.y"
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
case 77:
#line 826 "rt.y"
{ yyval.i='='/*ASSIGN*/; ;
    break;}
case 78:
#line 827 "rt.y"
{ yyval.i='+'/*ADDA*/; ;
    break;}
case 79:
#line 828 "rt.y"
{ yyval.i='-'/*SUBA*/; ;
    break;}
case 80:
#line 829 "rt.y"
{ yyval.i='*'/*MULA*/; ;
    break;}
case 81:
#line 830 "rt.y"
{ yyval.i='/'/*DIVA*/; ;
    break;}
case 82:
#line 831 "rt.y"
{ yyval.i='%'/*MODA*/; ;
    break;}
case 83:
#line 832 "rt.y"
{ yyval.i='^'/*POWA*/; ;
    break;}
case 84:
#line 835 "rt.y"
{ yyval.pos=yyvsp[-3].pos; yyval.pos.i=yyvsp[-1].pos.i+1; ;
    break;}
case 85:
#line 836 "rt.y"
{ yyval.pos=yyvsp[-3].pos; yyval.pos.i=yyvsp[-3].pos.i+yyvsp[-1].pos.i; ;
    break;}
case 86:
#line 838 "rt.y"
{
			yyval.pos=yyvsp[-2].pos; yyval.pos.i=2;
			putByte_Buf(PARSER->out,CLIP_PUSH_HASH);
			putLong_Buf(PARSER->out,yyvsp[0].Long);
		;
    break;}
case 87:
#line 844 "rt.y"
{
			yyval.pos=yyvsp[-2].pos; yyval.pos.i++;
			putByte_Buf(PARSER->out,CLIP_PUSH_HASH);
			putLong_Buf(PARSER->out,yyvsp[0].Long);
		;
    break;}
case 88:
#line 851 "rt.y"
{ yyval.longvect.count=0; yyval.longvect.vect=0; ;
    break;}
case 89:
#line 852 "rt.y"
{
			yyval.longvect.vect=NEW(long);
			yyval.longvect.count=1;
			yyval.longvect.vect[0]= yyvsp[0].Long;
		;
    break;}
case 90:
#line 857 "rt.y"
{
			int i = ++ yyval.longvect.count;
			yyval.longvect.vect=M_REALLOC(long,yyval.longvect.vect,i);
			yyval.longvect.vect[i-1] = yyvsp[0].Long;
			for(i=0;i<yyval.longvect.count-1;++i)
				if (yyval.longvect.vect[i]==yyvsp[0].Long)
					rterror("duplicate name in parameter list");
		;
    break;}
case 91:
#line 867 "rt.y"
{ yyval.name.hash = yyvsp[0].Long; yyval.name.memvar=0; ;
    break;}
case 92:
#line 868 "rt.y"
{ yyval.name.hash = yyvsp[0].Long; yyval.name.memvar=1; ;
    break;}
case 93:
#line 869 "rt.y"
{ yyval.name.hash = yyvsp[0].Long; yyval.name.memvar=2; ;
    break;}
case 94:
#line 872 "rt.y"
{
			installName(PARSER, yyvsp[-1].name.hash, yyvsp[-1].name.memvar, 0, -1, 0);
			yyval.pos.pos=POS;
			putByte_Buf(PARSER->out, CLIP_MACRO);
		;
    break;}
case 95:
#line 877 "rt.y"
{
			yyval.pos=yyvsp[-1].pos;
			putByte_Buf(PARSER->out, CLIP_MACRO);
		;
    break;}
case 97:
#line 884 "rt.y"
{ yyval.pos=yyvsp[-1].pos;;
    break;}
case 100:
#line 891 "rt.y"
{yyval.pos.pos=POS;yyval.pos.i=0;;
    break;}
case 101:
#line 892 "rt.y"
{ yyval.pos=yyvsp[0].pos; yyval.pos.i=1; ;
    break;}
case 102:
#line 893 "rt.y"
{ putByte_Buf(PARSER->out, CLIP_PUSH_NIL); ;
    break;}
case 103:
#line 894 "rt.y"
{ yyval.pos=yyvsp[-2].pos; yyval.pos.i=2; ;
    break;}
case 104:
#line 895 "rt.y"
{ yyval.pos=yyvsp[-2].pos; yyval.pos.i+=1; ;
    break;}
case 105:
#line 898 "rt.y"
{ yyval.pos.pos=POS; putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
		;
    break;}
case 106:
#line 901 "rt.y"
{ yyval.pos=yyvsp[0].pos; ;
    break;}
case 107:
#line 904 "rt.y"
{ yyval.pos=yyvsp[0].pos; ;
    break;}
case 108:
#line 905 "rt.y"
{
			yyval.pos.pos=POS;
			installName(PARSER, yyvsp[0].name.hash, yyvsp[0].name.memvar, 1, -1, 0);
			putByte_Buf(PARSER->out, CLIP_MAKE_REF);
			putByte_Buf(PARSER->out, 0);
			add_deep(PARSER->curFunction, 1);
		 ;
    break;}
case 109:
#line 914 "rt.y"
{ yyval.pos = yyvsp[0].pos; yyval.pos.i = 1; ;
    break;}
case 110:
#line 915 "rt.y"
{yyval.pos.pos = POS; yyval.pos.i = 0; ;
    break;}
case 111:
#line 916 "rt.y"
{
			if (yyvsp[-1].pos.i == 0)
			{
				putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
				add_deep(PARSER->curFunction, 1);
				yyvsp[-1].pos.i = 1;
			}
		;
    break;}
case 112:
#line 923 "rt.y"
{
			yyval.pos = yyvsp[-3].pos;
			yyval.pos.i += 1;
		;
    break;}
case 113:
#line 929 "rt.y"
{yyval.pos.pos=POS; putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
		 add_deep(PARSER->curFunction, 1);
		;
    break;}
case 114:
#line 932 "rt.y"
{yyval.pos=yyvsp[0].pos;;
    break;}
case 115:
#line 935 "rt.y"
{ yyval.pos=yyvsp[0].pos; yyval.pos.i=1;  ;
    break;}
case 116:
#line 936 "rt.y"
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
#line 938 "rt.y"


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

	snprintf(parser->errbuf, ERRBUFSIZE-l, "\n%d: pos %d: ", parser->errcount, (parser->ptr-parser->beg)+1);
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

	LONGVAL(*loffs) = 0;
	LONGINCR(*loffs);
	LONGVAL(*loffs) = BEGOFFS;
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

	LONGVAL(lp)=BEGOFFS;
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

		SHORTVAL(numOffs) = BEGOFFS;
		for(i=0; i<parser.numbers_count; ++i)
			putDouble_Buf(bp,parser.numbers[i]);
		for(i=0; i<parser.numbers_count; ++i)
			putByte_Buf(bp,parser.lendec[i].len);
		for(i=0; i<parser.numbers_count; ++i)
			putByte_Buf(bp,parser.lendec[i].dec);
		SHORTVAL(strOffs) = BEGOFFS;
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
			LONGVAL(soffs) = len;
			LONGINCR(soffs);
			LONGVAL(soffs) = BEGOFFS;
			LONGINCR(soffs);
			putBuf_Buf(bp, s, len);
			putByte_Buf(bp, 0);
		}
		loffs = CUROFFS;
		LONGVAL(funcOffs) = BEGOFFS;
		for(i=0; i<parser.codeblocks_count+1; ++i)
		{
			putLong_Buf(bp, 0);
			putLong_Buf(bp, 0);
		}
		foffs = bp->ptr - bp->buf /*BEGOFFS*/ ;
		put_function(bp, &parser.main, &loffs, 1);
		for(i=0;i<parser.codeblocks_count;++i)
			put_function(bp, parser.codeblocks+i, &loffs, 0);
		LONGVAL(modlen) = BEGOFFS;

		l = file->bodySize = CUROFFS;
		file->mem = file->body = (char*)realloc(bp->buf, l);
		dest->func = file->body+foffs;
	}

/*_return:*/

	free(parser.numbers);
	free(parser.strings);
	free(parser.strings_end);
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
			putByte_Buf(parser->out, no);
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


