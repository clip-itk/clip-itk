/* A Bison parser, made by GNU Bison 2.0.  */

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
#define YYPURE 1

/* Using locations.  */
#define YYLSP_NEEDED 0

/* Substitute the variable and function names.  */
#define yyparse rtparse
#define yylex   rtlex
#define yyerror rterror
#define yylval  rtlval
#define yychar  rtchar
#define yydebug rtdebug
#define yynerrs rtnerrs


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     STRING = 258,
     NUMBER = 259,
     NAME = 260,
     RPTR = 261,
     FIELD_PTR = 262,
     MEMVAR_PTR = 263,
     TRUE = 264,
     FALSE = 265,
     NIL = 266,
     PCOUNT = 267,
     PARAM = 268,
     IF = 269,
     RDDBEG = 270,
     RDDEND = 271,
     POWA = 272,
     MULA = 273,
     MODA = 274,
     DIVA = 275,
     SUBA = 276,
     ADDA = 277,
     ASSIGN = 278,
     POSTINCR = 279,
     OR = 280,
     AND = 281,
     NOT = 282,
     NE = 283,
     EQ = 284,
     LE = 285,
     GE = 286,
     POW = 287,
     DECR = 288,
     INCR = 289,
     MINUS = 290
   };
#endif
#define STRING 258
#define NUMBER 259
#define NAME 260
#define RPTR 261
#define FIELD_PTR 262
#define MEMVAR_PTR 263
#define TRUE 264
#define FALSE 265
#define NIL 266
#define PCOUNT 267
#define PARAM 268
#define IF 269
#define RDDBEG 270
#define RDDEND 271
#define POWA 272
#define MULA 273
#define MODA 274
#define DIVA 275
#define SUBA 276
#define ADDA 277
#define ASSIGN 278
#define POSTINCR 279
#define OR 280
#define AND 281
#define NOT 282
#define NE 283
#define EQ 284
#define LE 285
#define GE 286
#define POW 287
#define DECR 288
#define INCR 289
#define MINUS 290




/* Copy the first part of user declarations.  */
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
#line 408 "rt.y"
typedef union YYSTYPE {
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
} YYSTYPE;
/* Line 190 of yacc.c.  */
#line 314 "rt.tab.c"
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 213 of yacc.c.  */
#line 326 "rt.tab.c"

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
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   else
#    define YYSTACK_ALLOC alloca
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
#define YYFINAL  49
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   570

/* YYNTOKENS -- Number of terminals. */
#define YYNTOKENS  57
/* YYNNTS -- Number of nonterminals. */
#define YYNNTS  38
/* YYNRULES -- Number of rules. */
#define YYNRULES  120
/* YYNRULES -- Number of states. */
#define YYNSTATES  210

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   290

#define YYTRANSLATE(YYX) 						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const unsigned char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,    37,    40,    54,     2,
      48,    49,    38,    35,    47,    36,    55,    39,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    45,     2,
      29,    30,    28,     2,    56,     2,     2,     2,     2,     2,
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
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    31,    32,    33,    34,    41,    42,    43,
      44
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const unsigned short int yyprhs[] =
{
       0,     0,     3,     5,     7,     8,    13,    15,    17,    19,
      21,    23,    25,    27,    32,    35,    36,    43,    44,    51,
      52,    61,    62,    71,    73,    80,    81,    87,    92,    96,
     100,   101,   107,   111,   112,   117,   123,   129,   133,   137,
     141,   145,   149,   153,   157,   161,   165,   169,   173,   177,
     181,   185,   188,   191,   194,   197,   200,   203,   206,   207,
     213,   217,   218,   226,   230,   235,   236,   237,   250,   251,
     257,   258,   264,   266,   269,   272,   274,   277,   280,   281,
     282,   285,   287,   289,   291,   293,   295,   297,   299,   304,
     309,   313,   317,   318,   320,   324,   326,   329,   332,   336,
     341,   343,   347,   348,   350,   351,   353,   354,   359,   363,
     364,   366,   368,   371,   373,   374,   375,   380,   381,   383,
     385
};

/* YYRHS -- A `-1'-separated list of the rules' RHS. */
static const yysigned_char yyrhs[] =
{
      58,     0,    -1,    59,    -1,    61,    -1,    -1,    59,    47,
      60,    93,    -1,     4,    -1,     3,    -1,     9,    -1,    10,
      -1,    11,    -1,    83,    -1,    85,    -1,    75,    48,    61,
      49,    -1,    75,    84,    -1,    -1,     5,    48,    77,    62,
      87,    49,    -1,    -1,    84,    48,    77,    63,    87,    49,
      -1,    -1,    61,    45,     5,    48,    77,    64,    87,    49,
      -1,    -1,    81,    45,     5,    48,    77,    65,    87,    49,
      -1,    81,    -1,    75,    48,    61,    49,    23,    61,    -1,
      -1,    75,    84,    66,    23,    61,    -1,    83,    80,    77,
      61,    -1,    81,    80,    61,    -1,     5,     6,     5,    -1,
      -1,     5,     6,    77,    67,    85,    -1,    85,     6,     5,
      -1,    -1,    85,     6,    68,    85,    -1,     5,     6,     5,
      23,    61,    -1,    85,     6,     5,    23,    61,    -1,    61,
      30,    61,    -1,    61,    32,    61,    -1,    61,    31,    61,
      -1,    61,    28,    61,    -1,    61,    29,    61,    -1,    61,
      33,    61,    -1,    61,    34,    61,    -1,    61,    35,    61,
      -1,    61,    37,    61,    -1,    61,    36,    61,    -1,    61,
      38,    61,    -1,    61,    39,    61,    -1,    61,    40,    61,
      -1,    61,    41,    61,    -1,    27,    61,    -1,    36,    61,
      -1,    35,    61,    -1,    43,    61,    -1,    61,    43,    -1,
      42,    61,    -1,    61,    42,    -1,    -1,    15,     4,    69,
      61,    16,    -1,    50,    91,    51,    -1,    -1,    50,    52,
      70,    78,    79,    59,    51,    -1,    12,    48,    49,    -1,
      13,    48,    61,    49,    -1,    -1,    -1,    14,    48,    93,
      47,    77,    71,    93,    47,    77,    72,    93,    49,    -1,
      -1,    61,    26,    77,    73,    61,    -1,    -1,    61,    25,
      77,    74,    61,    -1,     7,    -1,    75,     7,    -1,    76,
       7,    -1,     8,    -1,    75,     8,    -1,    76,     8,    -1,
      -1,    -1,    82,    52,    -1,    23,    -1,    22,    -1,    21,
      -1,    18,    -1,    20,    -1,    19,    -1,    17,    -1,    61,
      46,    94,    53,    -1,    81,    46,    94,    53,    -1,    61,
      45,     5,    -1,    81,    45,     5,    -1,    -1,     5,    -1,
      82,    47,     5,    -1,     5,    -1,    76,     5,    -1,    75,
       5,    -1,    54,    83,    86,    -1,    54,    48,    61,    49,
      -1,    84,    -1,    48,    61,    49,    -1,    -1,    55,    -1,
      -1,    90,    -1,    -1,    47,    77,    88,    89,    -1,    87,
      47,    89,    -1,    -1,    90,    -1,    61,    -1,    56,    83,
      -1,    61,    -1,    -1,    -1,    91,    47,    92,    93,    -1,
      -1,    61,    -1,    61,    -1,    94,    47,    61,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const unsigned short int yyrline[] =
{
       0,   467,   467,   473,   474,   474,   482,   506,   528,   531,
     534,   538,   541,   545,   550,   559,   558,   572,   571,   584,
     583,   604,   603,   626,   633,   641,   641,   651,   679,   701,
     708,   708,   719,   727,   726,   735,   744,   751,   752,   753,
     754,   755,   756,   757,   758,   759,   760,   761,   762,   763,
     764,   765,   766,   767,   768,   769,   770,   771,   772,   772,
     781,   787,   787,   802,   806,   811,   816,   810,   828,   827,
     840,   839,   852,   853,   854,   857,   858,   859,   862,   865,
     873,   895,   896,   897,   898,   899,   900,   901,   904,   905,
     906,   912,   920,   921,   926,   936,   937,   938,   941,   946,
     952,   953,   956,   957,   960,   961,   962,   962,   964,   967,
     970,   973,   974,   983,   984,   985,   985,   998,  1001,  1004,
    1005
};
#endif

#if YYDEBUG || YYERROR_VERBOSE
/* YYTNME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals. */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "STRING", "NUMBER", "NAME", "RPTR",
  "FIELD_PTR", "MEMVAR_PTR", "TRUE", "FALSE", "NIL", "PCOUNT", "PARAM",
  "IF", "RDDBEG", "RDDEND", "POWA", "MULA", "MODA", "DIVA", "SUBA", "ADDA",
  "ASSIGN", "POSTINCR", "OR", "AND", "NOT", "'>'", "'<'", "'='", "NE",
  "EQ", "LE", "GE", "'+'", "'-'", "'$'", "'*'", "'/'", "'%'", "POW",
  "DECR", "INCR", "MINUS", "':'", "'['", "','", "'('", "')'", "'{'", "'}'",
  "'|'", "']'", "'&'", "'.'", "'@'", "$accept", "file", "fexpr_list", "@1",
  "expr", "@2", "@3", "@4", "@5", "@6", "@7", "@8", "@9", "@10", "@11",
  "@12", "@13", "@14", "fieldptr", "memvarptr", "pos", "func", "code",
  "assign", "arr", "param_list", "name", "mname", "mename", "dot",
  "arglist", "@15", "earg", "arg", "exprlist", "@16", "nexpr", "expr_list", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const unsigned short int yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,    62,    60,
      61,   283,   284,   285,   286,    43,    45,    36,    42,    47,
      37,   287,   288,   289,   290,    58,    91,    44,    40,    41,
     123,   125,   124,    93,    38,    46,    64
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const unsigned char yyr1[] =
{
       0,    57,    58,    59,    60,    59,    61,    61,    61,    61,
      61,    61,    61,    61,    61,    62,    61,    63,    61,    64,
      61,    65,    61,    61,    61,    66,    61,    61,    61,    61,
      67,    61,    61,    68,    61,    61,    61,    61,    61,    61,
      61,    61,    61,    61,    61,    61,    61,    61,    61,    61,
      61,    61,    61,    61,    61,    61,    61,    61,    69,    61,
      61,    70,    61,    61,    61,    71,    72,    61,    73,    61,
      74,    61,    75,    75,    75,    76,    76,    76,    77,    78,
      79,    80,    80,    80,    80,    80,    80,    80,    81,    81,
      81,    81,    82,    82,    82,    83,    83,    83,    84,    84,
      85,    85,    86,    86,    87,    87,    88,    87,    87,    89,
      89,    90,    90,    91,    91,    92,    91,    93,    93,    94,
      94
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const unsigned char yyr2[] =
{
       0,     2,     1,     1,     0,     4,     1,     1,     1,     1,
       1,     1,     1,     4,     2,     0,     6,     0,     6,     0,
       8,     0,     8,     1,     6,     0,     5,     4,     3,     3,
       0,     5,     3,     0,     4,     5,     5,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     2,     2,     2,     2,     2,     2,     2,     0,     5,
       3,     0,     7,     3,     4,     0,     0,    12,     0,     5,
       0,     5,     1,     2,     2,     1,     2,     2,     0,     0,
       2,     1,     1,     1,     1,     1,     1,     1,     4,     4,
       3,     3,     0,     1,     3,     1,     2,     2,     3,     4,
       1,     3,     0,     1,     0,     1,     0,     4,     3,     0,
       1,     1,     2,     1,     0,     0,     4,     0,     1,     1,
       3
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const unsigned char yydefact[] =
{
       0,     7,     6,    95,    72,    75,     8,     9,    10,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   114,
       0,     0,     2,     3,     0,     0,    23,    11,   100,    12,
      78,    78,     0,     0,   117,    58,    51,    53,    52,    56,
      54,     0,    61,   113,     0,    95,     0,     0,   102,     1,
       4,    78,    78,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    57,    55,     0,
       0,    97,    73,    76,     0,    14,    96,    74,    77,    87,
      84,    86,    85,    83,    82,    81,     0,     0,     0,    78,
      78,    33,    29,    30,    15,    63,     0,   118,     0,     0,
     101,    79,   115,    60,     0,   103,    98,   117,    70,    68,
      40,    41,    37,    39,    38,    42,    43,    44,    46,    45,
      47,    48,    49,    50,    90,   119,     0,     0,     0,    91,
       0,    28,     0,    17,    32,     0,     0,     0,   104,    64,
      78,     0,    92,   117,    99,     5,     0,     0,    78,     0,
      88,    13,     0,    78,    89,    27,   104,     0,   100,    34,
      35,    31,    78,     0,   111,     0,   105,    65,    59,    93,
       0,     0,   116,    71,    69,    19,   120,     0,    26,    21,
       0,    36,   106,   112,   109,    16,   117,     0,     0,    80,
     104,    24,   104,    18,   109,   108,   110,     0,    62,    94,
       0,     0,   107,    78,    20,    22,    66,   117,     0,    67
};

/* YYDEFGOTO[NTERM-NUM]. */
static const short int yydefgoto[] =
{
      -1,    21,    22,   107,   164,   138,   156,   190,   192,   128,
     137,   135,    99,   101,   186,   207,   147,   146,    24,    25,
      93,   142,   170,    88,    26,   171,    27,    28,    29,   106,
     165,   194,   195,   166,    44,   143,    98,   126
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -153
static const short int yypact[] =
{
     344,  -153,  -153,    -1,  -153,  -153,  -153,  -153,  -153,   -28,
     -20,    33,    48,   344,   344,   344,   344,   344,   344,   292,
       3,    72,    38,   484,    30,    98,     4,   141,    41,    96,
     106,  -153,    70,   344,   344,  -153,   524,    84,    84,    34,
      34,   396,  -153,   484,    -3,  -153,   344,   130,    78,  -153,
    -153,  -153,  -153,   344,   344,   344,   344,   344,   344,   344,
     344,   344,   344,   344,   344,   344,   344,  -153,  -153,   129,
     344,  -153,  -153,  -153,   344,   132,  -153,  -153,  -153,  -153,
    -153,  -153,  -153,  -153,  -153,  -153,   160,   344,   344,  -153,
    -153,   161,   144,  -153,  -153,  -153,   418,   484,   121,   344,
    -153,  -153,  -153,  -153,   440,  -153,  -153,   344,  -153,  -153,
      55,    55,    55,    55,    55,    55,    55,    82,    82,    82,
      67,    67,    67,    34,   123,   484,   -41,   462,   146,   124,
      -8,   484,   344,  -153,   150,    21,   344,    21,   184,  -153,
    -153,   374,   169,   344,  -153,  -153,   344,   344,  -153,   344,
    -153,   152,   344,  -153,  -153,   484,   184,   344,  -153,  -153,
     484,  -153,  -153,   134,   484,    24,  -153,  -153,  -153,  -153,
     344,   -16,  -153,   505,   524,  -153,   484,   344,   484,  -153,
      68,   484,  -153,  -153,   238,  -153,   344,    35,   171,  -153,
     184,   484,   184,  -153,   238,  -153,  -153,   131,  -153,  -153,
     101,   104,  -153,  -153,  -153,  -153,  -153,   344,   133,  -153
};

/* YYPGOTO[NTERM-NUM].  */
static const short int yypgoto[] =
{
    -153,  -153,     9,  -153,     0,  -153,  -153,  -153,  -153,  -153,
    -153,  -153,  -153,  -153,  -153,  -153,  -153,  -153,   -19,  -153,
     -22,  -153,  -153,   153,  -153,  -153,   -18,   -21,    19,  -153,
    -149,  -153,   -11,  -152,  -153,  -153,  -103,    97
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -26
static const short int yytable[] =
{
      23,    47,    48,    75,   145,    30,   149,   180,    45,    94,
       4,     5,   150,    36,    37,    38,    39,    40,    41,    43,
      32,    79,    80,    81,    82,    83,    84,    85,    33,   108,
     109,   188,   196,    96,    97,    71,   189,    72,    73,   149,
     172,   200,   196,   201,   102,   154,   104,    31,   103,    86,
      87,    46,    35,   110,   111,   112,   113,   114,   115,   116,
     117,   118,   119,   120,   121,   122,   123,   132,   133,    18,
     125,   184,    49,   185,   127,    20,    67,    68,    74,    69,
      70,    34,    50,   197,    20,    50,   198,   125,   131,    90,
      60,    61,    62,    63,    64,    65,    66,    67,    68,   141,
      69,    70,    91,    76,   208,    77,    78,    97,    66,    67,
      68,    92,    69,    70,   158,   184,   158,   193,   167,    95,
      63,    64,    65,    66,    67,    68,   175,    69,    70,    69,
      70,   179,   155,   105,   124,    71,   160,    72,    73,    45,
     182,     4,     5,    97,    47,   183,   173,   174,   184,   176,
     204,   184,   178,   205,   159,   -25,   161,   181,    79,    80,
      81,    82,    83,    84,    85,   129,   134,   136,   140,   152,
      23,   148,   153,   157,   169,   177,   199,   191,   203,   187,
      89,   206,   209,   202,   130,     0,    97,     1,     2,     3,
       0,     4,     5,     6,     7,     8,     9,    10,    11,    12,
       0,     0,     0,     0,     0,     0,     0,    97,     0,     0,
       0,    13,     0,     0,     0,     0,     0,     0,     0,    14,
      15,     0,     0,     0,     0,     0,    16,    17,     0,     0,
       0,   162,    18,     0,    19,     0,     0,     0,    20,     0,
     163,     1,     2,     3,     0,     4,     5,     6,     7,     8,
       9,    10,    11,    12,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    13,     0,     0,     0,     0,
       0,     0,     0,    14,    15,     0,     0,     0,     0,     0,
      16,    17,     0,     0,     0,     0,    18,     0,    19,     0,
       0,     0,    20,     0,   163,     1,     2,     3,     0,     4,
       5,     6,     7,     8,     9,    10,    11,    12,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    13,
       0,     0,     0,     0,     0,     0,     0,    14,    15,     0,
       0,     0,     0,     0,    16,    17,     0,     0,     0,     0,
      18,     0,    19,     0,    42,     0,    20,     1,     2,     3,
       0,     4,     5,     6,     7,     8,     9,    10,    11,    12,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    13,     0,     0,     0,     0,     0,     0,     0,    14,
      15,     0,     0,     0,     0,     0,    16,    17,     0,     0,
     168,     0,    18,     0,    19,     0,     0,     0,    20,    51,
      52,     0,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    67,    68,     0,    69,
      70,    51,    52,     0,    53,    54,    55,    56,    57,    58,
      59,    60,    61,    62,    63,    64,    65,    66,    67,    68,
       0,    69,    70,    51,    52,   100,    53,    54,    55,    56,
      57,    58,    59,    60,    61,    62,    63,    64,    65,    66,
      67,    68,     0,    69,    70,    51,    52,   139,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,     0,    69,    70,    51,    52,   144,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    66,    67,    68,     0,    69,    70,    51,
      52,   151,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    67,    68,     0,    69,
      70,    52,     0,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,    67,    68,     0,
      69,    70,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    67,    68,     0,    69,
      70
};

static const short int yycheck[] =
{
       0,    20,    20,    24,   107,     6,    47,   156,     5,    31,
       7,     8,    53,    13,    14,    15,    16,    17,    18,    19,
      48,    17,    18,    19,    20,    21,    22,    23,    48,    51,
      52,    47,   184,    33,    34,     5,    52,     7,     8,    47,
     143,   190,   194,   192,    47,    53,    46,    48,    51,    45,
      46,    48,     4,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,    89,    90,    48,
      70,    47,     0,    49,    74,    54,    42,    43,    48,    45,
      46,    48,    47,   186,    54,    47,    51,    87,    88,    48,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    99,
      45,    46,     6,     5,   207,     7,     8,   107,    41,    42,
      43,     5,    45,    46,   135,    47,   137,    49,   140,    49,
      38,    39,    40,    41,    42,    43,   148,    45,    46,    45,
      46,   153,   132,    55,     5,     5,   136,     7,     8,     5,
     162,     7,     8,   143,   163,   163,   146,   147,    47,   149,
      49,    47,   152,    49,   135,    23,   137,   157,    17,    18,
      19,    20,    21,    22,    23,     5,     5,    23,    47,    23,
     170,    48,    48,    23,     5,    23,     5,   177,    47,   170,
      27,   203,    49,   194,    87,    -1,   186,     3,     4,     5,
      -1,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   207,    -1,    -1,
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
      36,    37,    38,    39,    40,    41,    42,    43,    -1,    45,
      46,    25,    26,    -1,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      -1,    45,    46,    25,    26,    49,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
      42,    43,    -1,    45,    46,    25,    26,    49,    28,    29,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    42,    43,    -1,    45,    46,    25,    26,    49,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43,    -1,    45,    46,    25,
      26,    49,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    -1,    45,
      46,    26,    -1,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    -1,
      45,    46,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    -1,    45,
      46
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const unsigned char yystos[] =
{
       0,     3,     4,     5,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    27,    35,    36,    42,    43,    48,    50,
      54,    58,    59,    61,    75,    76,    81,    83,    84,    85,
       6,    48,    48,    48,    48,     4,    61,    61,    61,    61,
      61,    61,    52,    61,    91,     5,    48,    75,    83,     0,
      47,    25,    26,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    45,
      46,     5,     7,     8,    48,    84,     5,     7,     8,    17,
      18,    19,    20,    21,    22,    23,    45,    46,    80,    80,
      48,     6,     5,    77,    77,    49,    61,    61,    93,    69,
      49,    70,    47,    51,    61,    55,    86,    60,    77,    77,
      61,    61,    61,    61,    61,    61,    61,    61,    61,    61,
      61,    61,    61,    61,     5,    61,    94,    61,    66,     5,
      94,    61,    77,    77,     5,    68,    23,    67,    62,    49,
      47,    61,    78,    92,    49,    93,    74,    73,    48,    47,
      53,    49,    23,    48,    53,    61,    63,    23,    84,    85,
      61,    85,    47,    56,    61,    87,    90,    77,    16,     5,
      79,    82,    93,    61,    61,    77,    61,    23,    61,    77,
      87,    61,    77,    83,    47,    49,    71,    59,    47,    52,
      64,    61,    65,    49,    88,    89,    90,    93,    51,     5,
      87,    87,    89,    47,    49,    49,    77,    72,    93,    49
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


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (N)								\
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (0)
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
              (Loc).first_line, (Loc).first_column,	\
              (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (&yylval, YYLEX_PARAM)
#else
# define YYLEX yylex (&yylval)
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

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)		\
do {								\
  if (yydebug)							\
    {								\
      YYFPRINTF (stderr, "%s ", Title);				\
      yysymprint (stderr, 					\
                  Type, Value);	\
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
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
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
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);


# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
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
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

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
  /* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;

  register int yystate;
  register int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
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


  yyvsp[0] = yylval;

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
/* Read a look-ahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to look-ahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
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
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
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

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

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
#line 467 "rt.y"
    {
		(yyval.pos) = (yyvsp[0].pos);
		putByte_Buf(PARSER->out,CLIP_RETURN_POP);
	;}
    break;

  case 4:
#line 474 "rt.y"
    {
			putByte_Buf(PARSER->out,CLIP_POP);
		;}
    break;

  case 5:
#line 477 "rt.y"
    {
			(yyval.pos)=(yyvsp[-3].pos);
		;}
    break;

  case 6:
#line 482 "rt.y"
    {
			int no, num=PARSER->numbers_count;
			for(no=0;no<num;++no)
				if ( PARSER->numbers[no]==(yyvsp[0].Double).d
					 &&	PARSER->lendec[no].len == (yyvsp[0].Double).len
					 &&	PARSER->lendec[no].dec == (yyvsp[0].Double).dec
				   )
				{
					break;
				}
			if (no==num)
			{
				M_REALLOC(double,PARSER->numbers, no+1);
				M_REALLOC(LenDec,PARSER->lendec, no+1);
				PARSER->numbers[no]=(yyvsp[0].Double).d;
				PARSER->lendec[no].len=(yyvsp[0].Double).len;
				PARSER->lendec[no].dec=(yyvsp[0].Double).dec;
				++PARSER->numbers_count;
			}
			(yyval.pos).pos=POS;
			putByte_Buf(PARSER->out,CLIP_PUSH_NUM);
			putShort_Buf(PARSER->out,no);
			 add_deep(PARSER->curFunction, 1);
		;}
    break;

  case 7:
#line 506 "rt.y"
    {
			int no, num=PARSER->strings_count;
			char *beg = (yyvsp[0].string).beg, *end = (yyvsp[0].string).end;
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
			(yyval.pos).pos=POS;
			putByte_Buf(PARSER->out,CLIP_PUSH_STRDUP);
			putShort_Buf(PARSER->out,no);
			add_deep(PARSER->curFunction, 1);
		;}
    break;

  case 8:
#line 528 "rt.y"
    { (yyval.pos).pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_TRUE);
			 add_deep(PARSER->curFunction, 1);
		;}
    break;

  case 9:
#line 531 "rt.y"
    { (yyval.pos).pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_FALSE);
			 add_deep(PARSER->curFunction, 1);
		;}
    break;

  case 10:
#line 534 "rt.y"
    { (yyval.pos).pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_NIL);
			 add_deep(PARSER->curFunction, 1);
		;}
    break;

  case 11:
#line 538 "rt.y"
    { (yyval.pos).pos=POS; installName(PARSER, (yyvsp[0].name).hash, (yyvsp[0].name).memvar, 0, -1, 0);
			 add_deep(PARSER->curFunction, 1);
		;}
    break;

  case 12:
#line 541 "rt.y"
    { (yyval.pos)=(yyvsp[0].pos);
			 add_deep(PARSER->curFunction, 1);
		;}
    break;

  case 13:
#line 545 "rt.y"
    {
			(yyval.pos)=(yyvsp[-1].pos);
			putByte_Buf(PARSER->out, CLIP_FIELD_POP_NAME);
		;}
    break;

  case 14:
#line 550 "rt.y"
    {
			(yyval.pos)=(yyvsp[0].pos);
			PARSER->out->ptr[-1] = CLIP_NOP;
			putByte_Buf(PARSER->out, CLIP_FIELD_POP_NAME);
		;}
    break;

  case 15:
#line 559 "rt.y"
    { putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
			(yyvsp[0].pos).i = PARSER->curFunction->curdeep;
		;}
    break;

  case 16:
#line 564 "rt.y"
    {
			PARSER->curFunction->curdeep = (yyvsp[-3].pos).i;
			putByte_Buf(PARSER->out, CLIP_FUNC);
			putByte_Buf(PARSER->out, (yyvsp[-1].pos).i);
			putLong_Buf(PARSER->out, (yyvsp[-5].Long));
			(yyval.pos)=(yyvsp[-3].pos);
		;}
    break;

  case 17:
#line 572 "rt.y"
    { putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
			(yyvsp[0].pos).i = PARSER->curFunction->curdeep;
		;}
    break;

  case 18:
#line 576 "rt.y"
    {
			PARSER->curFunction->curdeep = (yyvsp[-3].pos).i;
			(yyval.pos)=(yyvsp[-5].pos);
			putByte_Buf(PARSER->out, CLIP_FUNC_NAME);
			putByte_Buf(PARSER->out, (yyvsp[-1].pos).i);
		;}
    break;

  case 19:
#line 584 "rt.y"
    {
			(yyvsp[0].pos).i = PARSER->curFunction->curdeep;
		;}
    break;

  case 20:
#line 588 "rt.y"
    {
			PARSER->curFunction->curdeep = (yyvsp[-3].pos).i;

			putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);

			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, (yyvsp[-1].pos).i+1);

			putByte_Buf(PARSER->out,CLIP_CALL);
			putByte_Buf(PARSER->out,(yyvsp[-1].pos).i+1);
			putLong_Buf(PARSER->out,(yyvsp[-5].Long));
			(yyval.pos)=(yyvsp[-7].pos);
		;}
    break;

  case 21:
#line 604 "rt.y"
    {
			putByte_Buf(PARSER->out,CLIP_IFETCH);
			putByte_Buf(PARSER->out,(yyvsp[-4].pos).i-1);
			add_deep(PARSER->curFunction, 1);
			(yyvsp[0].pos).i = PARSER->curFunction->curdeep;
		;}
    break;

  case 22:
#line 611 "rt.y"
    {
			PARSER->curFunction->curdeep = (yyvsp[-3].pos).i;

			putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);

			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, (yyvsp[-1].pos).i+1);

			putByte_Buf(PARSER->out,CLIP_CALL);
			putByte_Buf(PARSER->out,(yyvsp[-1].pos).i+1);
			putLong_Buf(PARSER->out,(yyvsp[-5].Long));
			(yyval.pos)=(yyvsp[-7].pos);
		;}
    break;

  case 23:
#line 626 "rt.y"
    {
			(yyval.pos)=(yyvsp[0].pos);
			putByte_Buf(PARSER->out,CLIP_IFETCH);
			putByte_Buf(PARSER->out,(yyvsp[0].pos).i-1);
			add_deep(PARSER->curFunction, 1);
		;}
    break;

  case 24:
#line 633 "rt.y"
    {
			(yyval.pos)=(yyvsp[-3].pos);
			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_PFIELD);
			putLong_Buf(PARSER->out, -1);
		;}
    break;

  case 25:
#line 641 "rt.y"
    {
			PARSER->out->ptr[-1] = CLIP_NOP;
		;}
    break;

  case 26:
#line 643 "rt.y"
    {
			(yyval.pos)=(yyvsp[-3].pos);
			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_PFIELD);
			putLong_Buf(PARSER->out, -1);
		;}
    break;

  case 27:
#line 653 "rt.y"
    {
			add_deep(PARSER->curFunction, 1);
			if ((yyvsp[-2].i) == '=' && PARSER->field_flag && (yyvsp[-3].name).memvar==0)
			{
				/*installName(PARSER, $1.hash, 0, 1, 0, 1);*/
				putByte_Buf(PARSER->out,CLIP_FM_IASSIGN);
				putLong_Buf(PARSER->out, (yyvsp[-3].name).hash);
			}
			else
			{
				int r;
				r = installName(PARSER, (yyvsp[-3].name).hash, (yyvsp[-3].name).memvar, 1, -1, 0);
				if (!r)
				{
					if ((yyvsp[-2].i)=='=')
						putByte_Buf(PARSER->out,CLIP_IASSIGN);
					else
					{
						putByte_Buf(PARSER->out,CLIP_OPIASSIGN);
						putByte_Buf(PARSER->out,(yyvsp[-2].i));
					}
				}
			}
			(yyval.pos)=(yyvsp[-1].pos);
		;}
    break;

  case 28:
#line 680 "rt.y"
    {
			int count = (yyvsp[-2].pos).i;

			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out,CLIP_SWAP);
			putByte_Buf(PARSER->out,count);
			if ((yyvsp[-1].i)=='=')
			{
				putByte_Buf(PARSER->out,CLIP_ISTORE);
				putByte_Buf(PARSER->out,0);
				putByte_Buf(PARSER->out,count-1);
			}
			else
			{
				putByte_Buf(PARSER->out,CLIP_OPISTORE);
				putByte_Buf(PARSER->out,count-1);
				putByte_Buf(PARSER->out,(yyvsp[-1].i));
			}
			(yyval.pos)=(yyvsp[-2].pos);
		;}
    break;

  case 29:
#line 701 "rt.y"
    {
			(yyval.pos).pos=POS;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_FIELD);
			putLong_Buf(PARSER->out, (yyvsp[0].Long));
			putLong_Buf(PARSER->out, (yyvsp[-2].Long));
		;}
    break;

  case 30:
#line 708 "rt.y"
    {
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PUSH_AREA);
			putLong_Buf(PARSER->out, (yyvsp[-2].Long));
		;}
    break;

  case 31:
#line 714 "rt.y"
    {
			putByte_Buf(PARSER->out, CLIP_POP_AREA);
			(yyval.pos)=(yyvsp[-2].pos);
		;}
    break;

  case 32:
#line 720 "rt.y"
    {
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_FIELD_POP);
			putLong_Buf(PARSER->out, (yyvsp[0].Long));
			(yyval.pos)=(yyvsp[-2].pos);
		;}
    break;

  case 33:
#line 727 "rt.y"
    { putByte_Buf(PARSER->out, CLIP_PUSH_AREA_POP);	;}
    break;

  case 34:
#line 729 "rt.y"
    {
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_POP_AREA);
			(yyval.pos)=(yyvsp[-3].pos);
		;}
    break;

  case 35:
#line 736 "rt.y"
    {
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_FIELD);
			putLong_Buf(PARSER->out, (yyvsp[-2].Long));
			putLong_Buf(PARSER->out, (yyvsp[-4].Long));
			(yyval.pos)=(yyvsp[0].pos);
		;}
    break;

  case 36:
#line 744 "rt.y"
    {
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_FIELD_POP);
			putLong_Buf(PARSER->out, (yyvsp[-2].Long));
			(yyval.pos)=(yyvsp[-4].pos);
		;}
    break;

  case 37:
#line 751 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, 'e'); ;}
    break;

  case 38:
#line 752 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, 'E'); ;}
    break;

  case 39:
#line 753 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, 'N'); ;}
    break;

  case 40:
#line 754 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, '>'); ;}
    break;

  case 41:
#line 755 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, '<'); ;}
    break;

  case 42:
#line 756 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, 'L'); ;}
    break;

  case 43:
#line 757 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, 'G'); ;}
    break;

  case 44:
#line 758 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, '+'); ;}
    break;

  case 45:
#line 759 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, '$'); ;}
    break;

  case 46:
#line 760 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, '-'); ;}
    break;

  case 47:
#line 761 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, '*'); ;}
    break;

  case 48:
#line 762 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, '/'); ;}
    break;

  case 49:
#line 763 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, '%'); ;}
    break;

  case 50:
#line 764 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); gen_op(PARSER, '^'); ;}
    break;

  case 51:
#line 765 "rt.y"
    { (yyval.pos)=(yyvsp[0].pos); putByte_Buf(PARSER->out, CLIP_NOT); ;}
    break;

  case 52:
#line 766 "rt.y"
    { (yyval.pos)=(yyvsp[0].pos); putByte_Buf(PARSER->out, CLIP_MINUS); ;}
    break;

  case 53:
#line 767 "rt.y"
    { (yyval.pos)=(yyvsp[0].pos); ;}
    break;

  case 54:
#line 768 "rt.y"
    { (yyval.pos)=(yyvsp[0].pos); ;}
    break;

  case 55:
#line 769 "rt.y"
    { (yyval.pos)=(yyvsp[-1].pos); ;}
    break;

  case 56:
#line 770 "rt.y"
    { (yyval.pos)=(yyvsp[0].pos); ;}
    break;

  case 57:
#line 771 "rt.y"
    { (yyval.pos)=(yyvsp[-1].pos); ;}
    break;

  case 58:
#line 772 "rt.y"
    {
				PARSER->rdd_no = (yyvsp[0].Double).d;
				PARSER->rdd_flag1 = 1;
			;}
    break;

  case 59:
#line 776 "rt.y"
    {
				(yyval.pos)=(yyvsp[-1].pos);
				PARSER->rdd_flag1 = 0;
			;}
    break;

  case 60:
#line 781 "rt.y"
    {
			add_deep(PARSER->curFunction, (yyvsp[-1].pos).i+1);
			(yyval.pos)=(yyvsp[-1].pos);
			putByte_Buf(PARSER->out, CLIP_ARRAY);
			putLong_Buf(PARSER->out, (yyvsp[-1].pos).i);
		;}
    break;

  case 61:
#line 787 "rt.y"
    {
			putByte_Buf(PARSER->out, CLIP_PUSH_CODE);
			putShort_Buf(PARSER->out, PARSER->codeblocks_count+1);
			putByte_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, 0);
			/* uplocals */
			/*putShort_Buf(PARSER->out, 0);*/
		;}
    break;

  case 62:
#line 795 "rt.y"
    {
			putByte_Buf(PARSER->out,CLIP_RETURN_POP);
			PARSER->curFunction = ((yyvsp[-3].pos).i==-1?&PARSER->main:PARSER->codeblocks+(yyvsp[-3].pos).i);
			PARSER->out = &PARSER->curFunction->out;
			add_deep(PARSER->curFunction, 1);
			(yyval.pos).pos = (yyvsp[-3].pos).pos;
		;}
    break;

  case 63:
#line 802 "rt.y"
    { (yyval.pos).pos=POS;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PCOUNT);
		;}
    break;

  case 64:
#line 806 "rt.y"
    { (yyval.pos)=(yyvsp[-1].pos);
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PARN);
		;}
    break;

  case 65:
#line 811 "rt.y"
    {
			putByte_Buf(PARSER->out, CLIP_COND);
			putShort_Buf(PARSER->out, 0);
		;}
    break;

  case 66:
#line 816 "rt.y"
    {
			putByte_Buf(PARSER->out, CLIP_GOTO);
			putShort_Buf(PARSER->out, 0);
			*(short*)(PARSER->out->buf+(yyvsp[-4].pos).pos+1) = (POS-((yyvsp[-4].pos).pos+1+sizeof(short)));
		;}
    break;

  case 67:
#line 822 "rt.y"
    {
			*(short*)(PARSER->out->buf+(yyvsp[-3].pos).pos+1) = (POS-((yyvsp[-3].pos).pos+1+sizeof(short)));
			(yyval.pos)=(yyvsp[-9].pos);
		;}
    break;

  case 68:
#line 828 "rt.y"
    {
			putByte_Buf(PARSER->out, CLIP_TCOND);
			putShort_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, CLIP_POP);
		;}
    break;

  case 69:
#line 834 "rt.y"
    {
			(yyval.pos)=(yyvsp[-4].pos);
			*(short*)(PARSER->out->buf+(yyvsp[-2].pos).pos+1) = (POS-((yyvsp[-2].pos).pos+1+sizeof(short)));
		;}
    break;

  case 70:
#line 840 "rt.y"
    {
			putByte_Buf(PARSER->out, CLIP_ITCOND);
			putShort_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, CLIP_POP);
		;}
    break;

  case 71:
#line 846 "rt.y"
    {
			(yyval.pos)=(yyvsp[-4].pos);
			*(short*)(PARSER->out->buf+(yyvsp[-2].pos).pos+1) = (POS-((yyvsp[-2].pos).pos+1+sizeof(short)));
		;}
    break;

  case 78:
#line 862 "rt.y"
    { (yyval.pos).pos = POS; ;}
    break;

  case 79:
#line 865 "rt.y"
    { 	if (PARSER->curFunction==&PARSER->main)
			(yyval.pos).i=-1;
		else
			(yyval.pos).i=PARSER->curFunction-PARSER->codeblocks;
		(yyval.pos).pos=POS;
	;}
    break;

  case 80:
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
			fp->params = (yyvsp[-1].longvect).vect;
			fp->params_count = (yyvsp[-1].longvect).count;
			for(i=0;i<fp->params_count;i++)
			{
				putByte_Buf(PARSER->out, CLIP_PUSH_PARAM);
				putByte_Buf(PARSER->out, i);
				putShort_Buf(PARSER->out, i);
			}
		;}
    break;

  case 81:
#line 895 "rt.y"
    { (yyval.i)='='/*ASSIGN*/; ;}
    break;

  case 82:
#line 896 "rt.y"
    { (yyval.i)='+'/*ADDA*/; ;}
    break;

  case 83:
#line 897 "rt.y"
    { (yyval.i)='-'/*SUBA*/; ;}
    break;

  case 84:
#line 898 "rt.y"
    { (yyval.i)='*'/*MULA*/; ;}
    break;

  case 85:
#line 899 "rt.y"
    { (yyval.i)='/'/*DIVA*/; ;}
    break;

  case 86:
#line 900 "rt.y"
    { (yyval.i)='%'/*MODA*/; ;}
    break;

  case 87:
#line 901 "rt.y"
    { (yyval.i)='^'/*POWA*/; ;}
    break;

  case 88:
#line 904 "rt.y"
    { (yyval.pos)=(yyvsp[-3].pos); (yyval.pos).i=(yyvsp[-1].pos).i+1; ;}
    break;

  case 89:
#line 905 "rt.y"
    { (yyval.pos)=(yyvsp[-3].pos); (yyval.pos).i=(yyvsp[-3].pos).i+(yyvsp[-1].pos).i; ;}
    break;

  case 90:
#line 907 "rt.y"
    {
			(yyval.pos)=(yyvsp[-2].pos); (yyval.pos).i=2;
			putByte_Buf(PARSER->out,CLIP_PUSH_HASH);
			putLong_Buf(PARSER->out,(yyvsp[0].Long));
		;}
    break;

  case 91:
#line 913 "rt.y"
    {
			(yyval.pos)=(yyvsp[-2].pos); (yyval.pos).i++;
			putByte_Buf(PARSER->out,CLIP_PUSH_HASH);
			putLong_Buf(PARSER->out,(yyvsp[0].Long));
		;}
    break;

  case 92:
#line 920 "rt.y"
    { (yyval.longvect).count=0; (yyval.longvect).vect=0; ;}
    break;

  case 93:
#line 921 "rt.y"
    {
			(yyval.longvect).vect=NEW(long);
			(yyval.longvect).count=1;
			(yyval.longvect).vect[0]= (yyvsp[0].Long);
		;}
    break;

  case 94:
#line 926 "rt.y"
    {
			int i = ++ (yyval.longvect).count;
			(yyval.longvect).vect=M_REALLOC(long,(yyval.longvect).vect,i);
			(yyval.longvect).vect[i-1] = (yyvsp[0].Long);
			for(i=0;i<(yyval.longvect).count-1;++i)
				if ((yyval.longvect).vect[i]==(yyvsp[0].Long))
					rterror("duplicate name in parameter list");
		;}
    break;

  case 95:
#line 936 "rt.y"
    { (yyval.name).hash = (yyvsp[0].Long); (yyval.name).memvar=0; ;}
    break;

  case 96:
#line 937 "rt.y"
    { (yyval.name).hash = (yyvsp[0].Long); (yyval.name).memvar=1; ;}
    break;

  case 97:
#line 938 "rt.y"
    { (yyval.name).hash = (yyvsp[0].Long); (yyval.name).memvar=2; ;}
    break;

  case 98:
#line 941 "rt.y"
    {
			installName(PARSER, (yyvsp[-1].name).hash, (yyvsp[-1].name).memvar, 0, -1, 0);
			(yyval.pos).pos=POS;
			putByte_Buf(PARSER->out, CLIP_MACRO);
		;}
    break;

  case 99:
#line 946 "rt.y"
    {
			(yyval.pos)=(yyvsp[-1].pos);
			putByte_Buf(PARSER->out, CLIP_MACRO);
		;}
    break;

  case 101:
#line 953 "rt.y"
    { (yyval.pos)=(yyvsp[-1].pos);;}
    break;

  case 104:
#line 960 "rt.y"
    {(yyval.pos).pos=POS;(yyval.pos).i=0;;}
    break;

  case 105:
#line 961 "rt.y"
    { (yyval.pos)=(yyvsp[0].pos); (yyval.pos).i=1; ;}
    break;

  case 106:
#line 962 "rt.y"
    { putByte_Buf(PARSER->out, CLIP_PUSH_NIL); ;}
    break;

  case 107:
#line 963 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); (yyval.pos).i=2; ;}
    break;

  case 108:
#line 964 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); (yyval.pos).i+=1; ;}
    break;

  case 109:
#line 967 "rt.y"
    { (yyval.pos).pos=POS; putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
		;}
    break;

  case 110:
#line 970 "rt.y"
    { (yyval.pos)=(yyvsp[0].pos); ;}
    break;

  case 111:
#line 973 "rt.y"
    { (yyval.pos)=(yyvsp[0].pos); ;}
    break;

  case 112:
#line 974 "rt.y"
    {
			(yyval.pos).pos=POS;
			installName(PARSER, (yyvsp[0].name).hash, (yyvsp[0].name).memvar, 1, -1, 0);
			putByte_Buf(PARSER->out, CLIP_MAKE_REF);
			putByte_Buf(PARSER->out, 0);
			add_deep(PARSER->curFunction, 1);
		 ;}
    break;

  case 113:
#line 983 "rt.y"
    { (yyval.pos) = (yyvsp[0].pos); (yyval.pos).i = 1; ;}
    break;

  case 114:
#line 984 "rt.y"
    {(yyval.pos).pos = POS; (yyval.pos).i = 0; ;}
    break;

  case 115:
#line 985 "rt.y"
    {
			if ((yyvsp[-1].pos).i == 0)
			{
				putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
				add_deep(PARSER->curFunction, 1);
				(yyvsp[-1].pos).i = 1;
			}
		;}
    break;

  case 116:
#line 992 "rt.y"
    {
			(yyval.pos) = (yyvsp[-3].pos);
			(yyval.pos).i += 1;
		;}
    break;

  case 117:
#line 998 "rt.y"
    {(yyval.pos).pos=POS; putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
		 add_deep(PARSER->curFunction, 1);
		;}
    break;

  case 118:
#line 1001 "rt.y"
    {(yyval.pos)=(yyvsp[0].pos);;}
    break;

  case 119:
#line 1004 "rt.y"
    { (yyval.pos)=(yyvsp[0].pos); (yyval.pos).i=1;  ;}
    break;

  case 120:
#line 1005 "rt.y"
    { (yyval.pos)=(yyvsp[-2].pos); (yyval.pos).i+=1; ;}
    break;


    }

/* Line 1037 of yacc.c.  */
#line 2385 "rt.tab.c"

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
      /* If just tried and failed to reuse look-ahead token after an
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
		 yydestruct ("Error: popping",
                             yystos[*yyssp], yyvsp);
	       }
        }
      else
	{
	  yydestruct ("Error: discarding", yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse look-ahead token after shifting the error
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


      yydestruct ("Error: popping", yystos[yystate], yyvsp);
      YYPOPSTACK;
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  *++yyvsp = yylval;


  /* Shift the error token. */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

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
  yydestruct ("Error: discarding lookahead",
              yytoken, &yylval);
  yychar = YYEMPTY;
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



