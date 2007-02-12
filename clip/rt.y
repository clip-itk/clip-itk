/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
$Log$
Revision 1.2  2007/02/12 09:13:17  itk
uri: many fixes for amd64

Revision 1.1  2006/06/22 19:35:17  itk
uri: init sf.net repository

Revision 1.62  2003/11/05 11:20:58  clip
fix POW in macro (closes #161)
paul

Revision 1.61  2003/08/13 10:36:42  clip
extend limit of 255 local vars.
fixes #151
paul

Revision 1.60  2003/05/07 11:11:12  clip
rust: memory leak in _clip_compile_Block()

Revision 1.59  2003/03/26 13:40:14  clip
fix for memdebug build
paul

Revision 1.58  2003/03/17 08:24:59  clip
Solaris 8 patches
paul

Revision 1.57  2003/02/07 10:26:10  clip
method call for array elements
closes #121
paul

Revision 1.56  2002/11/25 12:29:46  clip
null expr in lists in runtime compiler
closes #59
paul

Revision 1.55  2002/11/18 12:33:01  clip
memv-> in runtime compiler
closes #46
paul

Revision 1.54  2002/09/12 10:57:30  clip
fix warnings
paul

Revision 1.53  2002/09/12 10:36:30  clip
allow all chars with code > 127 be ident names in runtime compiler
paul

Revision 1.52  2002/05/28 08:43:11  clip
pcount in rt compiler
paul

Revision 1.51  2002/04/15 13:26:10  clip
param & pcount as varname in rt
paul

Revision 1.50  2002/03/27 13:33:01  clip
SHORT overflow in .po with too much STRINGs.
.po format changed
paul

Revision 1.49  2002/03/22 10:36:48  clip
# in runtime compiler fix
paul

Revision 1.48  2002/02/20 15:57:23  clip
fucked strtod locale dependence...
paul

Revision 1.47  2002/01/04 12:14:03  clip
pcode was limited to 1 byte for array count
paul

Revision 1.46  2002/01/04 10:29:48  clip
big module
paul

Revision 1.45  2001/12/26 13:46:42  clip
1->fld
paul

Revision 1.44  2001/11/29 09:01:50  clip
PCODE fix in rt compiler
paul

Revision 1.43  2001/10/31 06:41:15  clip
1000.or.333
now work right in runtime compiler

Revision 1.42  2001/10/03 10:16:04  clip
macro in rt.y

Revision 1.41  2001/10/02 11:40:31  clip
macro in rt compiler
paul

Revision 1.40  2001/09/04 08:26:59  clip
CODEBLOCK pseudofunction
process codeblocks with macro calls as CODEBLOCK
paul

Revision 1.39  2001/08/26 12:11:59  clip
reflocals
paul

Revision 1.38  2001/08/26 09:10:06  clip
references
paul

Revision 1.37  2001/08/23 13:52:06  clip
merge with NEWLOCALS
paul

Revision 1.36.2.4  2001/08/23 12:58:48  clip
assign to field in rt.y
paul

Revision 1.36.2.3  2001/08/21 13:40:00  clip
fix
paul

Revision 1.36.2.2  2001/08/21 12:36:24  clip
fix
paul

Revision 1.36.2.1  2001/08/16 15:35:24  clip
fix
paul

Revision 1.36  2001/06/20 12:26:47  clip
runtime compiler now recognise hex constants like 0xFF
paul

Revision 1.35  2001/06/14 12:36:26  clip
stack deep fix in array constructor
paul

Revision 1.34  2001/06/09 08:13:28  clip
unary +
paul

Revision 1.33  2001/06/06 11:46:41  clip
rdd
paul

Revision 1.32  2001/05/29 07:17:08  clip
register names in macro expr
paul

Revision 1.31  2001/05/15 07:02:17  clip
modify memdebug call interface
paul

Revision 1.30  2001/05/12 11:40:10  clip
strtod in rt.y
paul

Revision 1.29  2001/05/11 08:16:39  clip
memory leak, unary minus, type with field in rt compiler
paul

Revision 1.28  2001/05/04 11:05:04  clip
.or. .and. in runtime compiler
paul

Revision 1.27  2001/04/23 10:19:45  clip
RUNTIME_COMPILED funcname for rt expression
paul

Revision 1.26  2001/04/03 09:17:01  clip
license errors
paul

Revision 1.25  2001/03/30 11:51:03  clip
add copyright

Revision 1.24  2001/01/19 08:43:33  clip
append RDD direct access in rt.y

functions (yet empty):
int _clip_rddfieldno(ClipMachine * mp, int rddno, long namehash);
int _clip_rddfield(ClipMachine * mp, int rddno, int fieldno);

syntax:
_rdd_ 2 <expr> _rdd_
for direct access to RDD 2 in <expr>
That means, rdd field names override normal fields/memvars

paul

Revision 1.23  2000/12/20 12:35:13  clip
privates in macro
empty arrays in macro
paul

Revision 1.22  2000/11/21 11:31:13  clip
io
paul

Revision 1.21  2000/11/20 12:59:01  clip
10.2 default decimals
destroy method in objs
paul

Revision 1.20  2000/11/20 11:46:49  clip
add CLIP_PUSH_STRDUP vm command
rt compiler now use one
paul

Revision 1.19  2000/05/27 18:41:55  clip
push array
Paul Lasarev <paul@itk.ru>

Revision 1.18  2000/05/25 18:03:17  clip
__field__ in rt
Paul Lasarev <paul@itk.ru>

Revision 1.17  2000/05/25 16:49:01  clip
__field__ in rt.y
absolute paths in #include
Paul Lasarev <paul@itk.ru>

Revision 1.16  2000/05/20 18:37:33  clip
change hash function
append HASH_xxxx extraction into hashcode.h
Paul Lasarev <paul@itk.ru>

Revision 1.15  2000/03/30 18:13:21  paul
fields in macro

Revision 1.14  2000/03/30 16:25:16  paul
PARAM

Revision 1.13  2000/03/30 14:46:18  paul
one-letter words

Revision 1.12  2000/03/03 21:37:40  paul
preprocessor bug fix, warnings removed

Revision 1.11  1999/10/29 20:49:59  paul
string constants

Revision 1.10  1999/10/29 19:39:52  paul
Function init

Revision 1.9  1999/10/29 19:28:33  paul
bug in macroassign (stack was corrupted)

Revision 1.8  1999/10/28 21:10:03  paul
runtime compiler: array access, obj calls

Revision 1.7  1999/10/28 16:34:24  paul
fix: .not., iif, multiple strings

Revision 1.6  1999/10/27 17:29:39  paul
change param handling

Revision 1.5  1999/10/26 20:42:48  paul
add_deep

Revision 1.4  1999/10/26 19:11:36  paul
start cvs logging

*/

%{

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

%}

%union
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
}

%pure_parser

%token <string> STRING
%token <Double> NUMBER
%token <Long> NAME
%token RPTR FIELD_PTR MEMVAR_PTR
%token TRUE FALSE NIL
%token PCOUNT PARAM IF
%token RDDBEG RDDEND

%type <longvect> param_list
%type <i> assign
%type <name> name
%type <pos> arglist exprlist expr_list arr func arg earg fexpr_list file
%type <pos> expr mname nexpr pos mename

%right ASSIGN ADDA SUBA DIVA MODA MULA POWA
%right POSTINCR
%left OR
%left AND
%right NOT
%left '>' GE '<' LE EQ NE '='
%left '+' '-' '$'
%left '*' '/' '%'
%left POW
%right INCR DECR
%right MINUS
%left ':' '['
%left RPTR

%%

file:	fexpr_list {
		$$ = $1;
		putByte_Buf(PARSER->out,CLIP_RETURN_POP);
	}
	;

fexpr_list: expr
	| fexpr_list ',' {
			putByte_Buf(PARSER->out,CLIP_POP);
		}
	  nexpr {
			$$=$1;
		}
	;

expr:	 NUMBER	{
			int no, num=PARSER->numbers_count;
			for(no=0;no<num;++no)
				if ( PARSER->numbers[no]==$1.d
					 &&	PARSER->lendec[no].len == $1.len
					 &&	PARSER->lendec[no].dec == $1.dec
				   )
				{
					break;
				}
			if (no==num)
			{
				M_REALLOC(double,PARSER->numbers, no+1);
				M_REALLOC(LenDec,PARSER->lendec, no+1);
				PARSER->numbers[no]=$1.d;
				PARSER->lendec[no].len=$1.len;
				PARSER->lendec[no].dec=$1.dec;
				++PARSER->numbers_count;
			}
			$$.pos=POS;
			putByte_Buf(PARSER->out,CLIP_PUSH_NUM);
			putShort_Buf(PARSER->out,no);
			 add_deep(PARSER->curFunction, 1);
		}
	| STRING {
			int no, num=PARSER->strings_count;
			char *beg = $1.beg, *end = $1.end;
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
			$$.pos=POS;
			putByte_Buf(PARSER->out,CLIP_PUSH_STRDUP);
			putShort_Buf(PARSER->out,no);
			add_deep(PARSER->curFunction, 1);
		}
	| TRUE	{ $$.pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_TRUE);
			 add_deep(PARSER->curFunction, 1);
		}
	| FALSE	{ $$.pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_FALSE);
			 add_deep(PARSER->curFunction, 1);
		}
	| NIL	{ $$.pos=POS; putByte_Buf(PARSER->out,CLIP_PUSH_NIL);
			 add_deep(PARSER->curFunction, 1);
		}

	| name	{ $$.pos=POS; installName(PARSER, $1.hash, $1.memvar, 0, -1, 0);
			 add_deep(PARSER->curFunction, 1);
		}
	| mename	{ $$=$1;
			 add_deep(PARSER->curFunction, 1);
		}

	| fieldptr '(' expr ')' {
			$$=$3;
			putByte_Buf(PARSER->out, CLIP_FIELD_POP_NAME);
		}

	| fieldptr mname {
			$$=$2;
			PARSER->out->ptr[-1] = CLIP_NOP;
			putByte_Buf(PARSER->out, CLIP_FIELD_POP_NAME);
		}
/*
	| '(' expr ')' 		{ $$=$2; }
*/
	| NAME '(' pos
		{ putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
			$3.i = PARSER->curFunction->curdeep;
		}
	  arglist ')'
		{
			PARSER->curFunction->curdeep = $3.i;
			putByte_Buf(PARSER->out, CLIP_FUNC);
			putByte_Buf(PARSER->out, $5.i);
			putLong_Buf(PARSER->out, $1);
			$$=$3;
		}
	| mname '(' pos
		{ putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
			$3.i = PARSER->curFunction->curdeep;
		}
	  arglist ')' {
			PARSER->curFunction->curdeep = $3.i;
			$$=$1;
			putByte_Buf(PARSER->out, CLIP_FUNC_NAME);
			putByte_Buf(PARSER->out, $5.i);
		}

	| expr ':' NAME '(' pos
		{
			$5.i = PARSER->curFunction->curdeep;
		}
	  arglist ')'
		{
			PARSER->curFunction->curdeep = $5.i;

			putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);

			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, $7.i+1);

			putByte_Buf(PARSER->out,CLIP_CALL);
			putByte_Buf(PARSER->out,$7.i+1);
			putLong_Buf(PARSER->out,$3);
			$$=$1;
		}

	| arr ':' NAME '(' pos
		{
			putByte_Buf(PARSER->out,CLIP_IFETCH);
			putByte_Buf(PARSER->out,$1.i-1);
			add_deep(PARSER->curFunction, 1);
			$5.i = PARSER->curFunction->curdeep;
		}
	  arglist ')'
		{
			PARSER->curFunction->curdeep = $5.i;

			putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);

			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, $7.i+1);

			putByte_Buf(PARSER->out,CLIP_CALL);
			putByte_Buf(PARSER->out,$7.i+1);
			putLong_Buf(PARSER->out,$3);
			$$=$1;
		}

	| arr	{
			$$=$1;
			putByte_Buf(PARSER->out,CLIP_IFETCH);
			putByte_Buf(PARSER->out,$1.i-1);
			add_deep(PARSER->curFunction, 1);
		}

	| fieldptr '(' expr ')' ASSIGN expr {
			$$=$3;
			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_PFIELD);
			putLong_Buf(PARSER->out, -1);
		}

	| fieldptr mname {
			PARSER->out->ptr[-1] = CLIP_NOP;
		} ASSIGN expr {
			$$=$2;
			putByte_Buf(PARSER->out, CLIP_SWAP);
			putByte_Buf(PARSER->out, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_PFIELD);
			putLong_Buf(PARSER->out, -1);
		}

	| name assign pos
	  expr  %prec ASSIGN
		{
			add_deep(PARSER->curFunction, 1);
			if ($2 == '=' && PARSER->field_flag && $1.memvar==0)
			{
				/*installName(PARSER, $1.hash, 0, 1, 0, 1);*/
				putByte_Buf(PARSER->out,CLIP_FM_IASSIGN);
				putLong_Buf(PARSER->out, $1.hash);
			}
			else
			{
				int r;
				r = installName(PARSER, $1.hash, $1.memvar, 1, -1, 0);
				if (!r)
				{
					if ($2=='=')
						putByte_Buf(PARSER->out,CLIP_IASSIGN);
					else
					{
						putByte_Buf(PARSER->out,CLIP_OPIASSIGN);
						putByte_Buf(PARSER->out,$2);
					}
				}
			}
			$$=$3;
		}

	| arr assign expr   %prec ASSIGN
		{
			int count = $1.i;

			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out,CLIP_SWAP);
			putByte_Buf(PARSER->out,count);
			if ($2=='=')
			{
				putByte_Buf(PARSER->out,CLIP_ISTORE);
				putByte_Buf(PARSER->out,0);
				putByte_Buf(PARSER->out,count-1);
			}
			else
			{
				putByte_Buf(PARSER->out,CLIP_OPISTORE);
				putByte_Buf(PARSER->out,count-1);
				putByte_Buf(PARSER->out,$2);
			}
			$$=$1;
		}

	| NAME RPTR NAME {
			$$.pos=POS;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_FIELD);
			putLong_Buf(PARSER->out, $3);
			putLong_Buf(PARSER->out, $1);
		}
	| NAME RPTR  pos {
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PUSH_AREA);
			putLong_Buf(PARSER->out, $1);
		}
	  mename
		{
			putByte_Buf(PARSER->out, CLIP_POP_AREA);
			$$=$3;
		}

	| mename RPTR NAME
		{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_FIELD_POP);
			putLong_Buf(PARSER->out, $3);
			$$=$1;
		}
	| mename RPTR
		{ putByte_Buf(PARSER->out, CLIP_PUSH_AREA_POP);	}
	  mename
		{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_POP_AREA);
			$$=$1;
		}

	| NAME RPTR NAME ASSIGN expr
		{
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_FIELD);
			putLong_Buf(PARSER->out, $3);
			putLong_Buf(PARSER->out, $1);
			$$=$5;
		}

	| mename RPTR NAME ASSIGN expr {
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_IASSIGN_FIELD_POP);
			putLong_Buf(PARSER->out, $3);
			$$=$1;
		}

	| expr '=' expr		{ $$=$1; gen_op(PARSER, 'e'); }
	| expr EQ expr		{ $$=$1; gen_op(PARSER, 'E'); }
	| expr NE expr		{ $$=$1; gen_op(PARSER, 'N'); }
	| expr '>' expr		{ $$=$1; gen_op(PARSER, '>'); }
	| expr '<' expr		{ $$=$1; gen_op(PARSER, '<'); }
	| expr LE expr		{ $$=$1; gen_op(PARSER, 'L'); }
	| expr GE expr		{ $$=$1; gen_op(PARSER, 'G'); }
	| expr '+' expr		{ $$=$1; gen_op(PARSER, '+'); }
	| expr '$' expr		{ $$=$1; gen_op(PARSER, '$'); }
	| expr '-' expr		{ $$=$1; gen_op(PARSER, '-'); }
	| expr '*' expr		{ $$=$1; gen_op(PARSER, '*'); }
	| expr '/' expr		{ $$=$1; gen_op(PARSER, '/'); }
	| expr '%' expr		{ $$=$1; gen_op(PARSER, '%'); }
	| expr POW expr		{ $$=$1; gen_op(PARSER, '^'); }
	| NOT expr		{ $$=$2; putByte_Buf(PARSER->out, CLIP_NOT); }
	| '-' expr %prec MINUS	{ $$=$2; putByte_Buf(PARSER->out, CLIP_MINUS); }
	| '+' expr %prec MINUS	{ $$=$2; }
	| INCR expr	{ $$=$2; }
	| expr INCR %prec POSTINCR	{ $$=$1; }
	| DECR expr	{ $$=$2; }
	| expr DECR %prec POSTINCR	{ $$=$1; }
	| RDDBEG NUMBER {
				PARSER->rdd_no = $2.d;
				PARSER->rdd_flag1 = 1;
			}
	  expr RDDEND	{
				$$=$4;
				PARSER->rdd_flag1 = 0;
			}

	| '{' exprlist '}'	{
			add_deep(PARSER->curFunction, $2.i+1);
			$$=$2;
			putByte_Buf(PARSER->out, CLIP_ARRAY);
			putLong_Buf(PARSER->out, $2.i);
		}
	| '{' '|' 	{
			putByte_Buf(PARSER->out, CLIP_PUSH_CODE);
			putShort_Buf(PARSER->out, PARSER->codeblocks_count+1);
			putByte_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, 0);
			/* uplocals */
			/*putShort_Buf(PARSER->out, 0);*/
		}
	  func code  fexpr_list '}'	{
			putByte_Buf(PARSER->out,CLIP_RETURN_POP);
			PARSER->curFunction = ($4.i==-1?&PARSER->main:PARSER->codeblocks+$4.i);
			PARSER->out = &PARSER->curFunction->out;
			add_deep(PARSER->curFunction, 1);
			$$.pos = $4.pos;
		}
	| PCOUNT '(' ')'	{ $$.pos=POS;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PCOUNT);
		}
	| PARAM '(' expr ')'	{ $$=$3;
			add_deep(PARSER->curFunction, 1);
			putByte_Buf(PARSER->out, CLIP_PARN);
		}
	| IF '(' nexpr ',' pos
		{
			putByte_Buf(PARSER->out, CLIP_COND);
			putShort_Buf(PARSER->out, 0);
		}
	  nexpr ',' pos
		{
			putByte_Buf(PARSER->out, CLIP_GOTO);
			putShort_Buf(PARSER->out, 0);
			*(short*)(PARSER->out->buf+$5.pos+1) = (POS-($5.pos+1+sizeof(short)));
		}
	  nexpr ')'
		{
			*(short*)(PARSER->out->buf+$9.pos+1) = (POS-($9.pos+1+sizeof(short)));
			$$=$3;
		}

	| expr AND pos
		{
			putByte_Buf(PARSER->out, CLIP_TCOND);
			putShort_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, CLIP_POP);
		}
	  expr
		{
			$$=$1;
			*(short*)(PARSER->out->buf+$3.pos+1) = (POS-($3.pos+1+sizeof(short)));
		}

	| expr OR pos
		{
			putByte_Buf(PARSER->out, CLIP_ITCOND);
			putShort_Buf(PARSER->out, 0);
			putByte_Buf(PARSER->out, CLIP_POP);
		}
	  expr
		{
			$$=$1;
			*(short*)(PARSER->out->buf+$3.pos+1) = (POS-($3.pos+1+sizeof(short)));
		}
	;

fieldptr: FIELD_PTR
	| fieldptr FIELD_PTR
	| memvarptr FIELD_PTR
	;

memvarptr: MEMVAR_PTR
	| fieldptr MEMVAR_PTR
	| memvarptr MEMVAR_PTR
	;

pos:	{ $$.pos = POS; }
	;

func:	{ 	if (PARSER->curFunction==&PARSER->main)
			$$.i=-1;
		else
			$$.i=PARSER->curFunction-PARSER->codeblocks;
		$$.pos=POS;
	}
	;

code:	param_list '|'
		{
			int i;
			int count=PARSER->codeblocks_count;
			Function *fp;

			M_REALLOC(Function, PARSER->codeblocks, count+1);
			fp = PARSER->curFunction = PARSER->codeblocks+count;
			PARSER->out = &fp->out;
			init_Function(fp);
			++ (PARSER->codeblocks_count);
			fp->params = $1.vect;
			fp->params_count = $1.count;
			for(i=0;i<fp->params_count;i++)
			{
				putByte_Buf(PARSER->out, CLIP_PUSH_PARAM);
				putByte_Buf(PARSER->out, i);
				putShort_Buf(PARSER->out, i);
			}
		}
	;

assign:	ASSIGN	{ $$='='/*ASSIGN*/; }
	| ADDA	{ $$='+'/*ADDA*/; }
	| SUBA	{ $$='-'/*SUBA*/; }
	| MULA	{ $$='*'/*MULA*/; }
	| DIVA  { $$='/'/*DIVA*/; }
	| MODA  { $$='%'/*MODA*/; }
	| POWA  { $$='^'/*POWA*/; }
	;

arr:	expr '[' expr_list ']' { $$=$1; $$.i=$3.i+1; }
	| arr '[' expr_list ']' { $$=$1; $$.i=$1.i+$3.i; }
	| expr ':' NAME
		{
			$$=$1; $$.i=2;
			putByte_Buf(PARSER->out,CLIP_PUSH_HASH);
			putLong_Buf(PARSER->out,$3);
		}
	| arr ':' NAME
		{
			$$=$1; $$.i++;
			putByte_Buf(PARSER->out,CLIP_PUSH_HASH);
			putLong_Buf(PARSER->out,$3);
		}
	;

param_list:  { $$.count=0; $$.vect=0; }
	| NAME	{
			$$.vect=NEW(long);
			$$.count=1;
			$$.vect[0]= $1;
		}
	| param_list ',' NAME {
			int i = ++ $$.count;
			$$.vect=M_REALLOC(long,$$.vect,i);
			$$.vect[i-1] = $3;
			for(i=0;i<$$.count-1;++i)
				if ($$.vect[i]==$3)
					rterror("duplicate name in parameter list");
		}
	;

name: NAME	{ $$.hash = $1; $$.memvar=0; }
	| memvarptr NAME	 { $$.hash = $2; $$.memvar=1; }
	| fieldptr NAME		{ $$.hash = $2; $$.memvar=2; }
	;

mname:	 '&' name dot		{
			installName(PARSER, $2.hash, $2.memvar, 0, -1, 0);
			$$.pos=POS;
			putByte_Buf(PARSER->out, CLIP_MACRO);
		}
	| '&' '(' expr ')'	{
			$$=$3;
			putByte_Buf(PARSER->out, CLIP_MACRO);
		}
	;

mename: mname
	| '(' expr ')' { $$=$2;}
	;

dot:
	| '.'
	;

arglist:	{$$.pos=POS;$$.i=0;}
	|  arg	{ $$=$1; $$.i=1; }
	| ',' pos  { putByte_Buf(PARSER->out, CLIP_PUSH_NIL); }
	  earg  { $$=$2; $$.i=2; }
	| arglist ',' earg { $$=$1; $$.i+=1; }
	;

earg:		{ $$.pos=POS; putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
			add_deep(PARSER->curFunction, 1);
		}
	| arg   { $$=$1; }
	;

arg:	expr	{ $$=$1; }
	| '@' name	{
			$$.pos=POS;
			installName(PARSER, $2.hash, $2.memvar, 1, -1, 0);
			putByte_Buf(PARSER->out, CLIP_MAKE_REF);
			putByte_Buf(PARSER->out, 0);
			add_deep(PARSER->curFunction, 1);
		 }
	;

exprlist: expr	{ $$ = $1; $$.i = 1; }
	|	{$$.pos = POS; $$.i = 0; }
	| exprlist ',' {
			if ($1.i == 0)
			{
				putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
				add_deep(PARSER->curFunction, 1);
				$1.i = 1;
			}
		} nexpr {
			$$ = $1;
			$$.i += 1;
		}
	;

nexpr:		{$$.pos=POS; putByte_Buf(PARSER->out, CLIP_PUSH_NIL);
		 add_deep(PARSER->curFunction, 1);
		}
	| expr	{$$=$1;}
	;

expr_list: expr	{ $$=$1; $$.i=1;  }
	| expr_list ',' expr { $$=$1; $$.i+=1; }
	;
%%

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


