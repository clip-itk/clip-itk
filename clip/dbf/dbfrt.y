%{
/*
$Log: dbfrt.y,v $
Revision 1.4  2000/05/27 20:03:19  clip
fix index on RDD recno()
Alex Vorontsov <axl@itk.ru>

Revision 1.3  2000/05/27 16:05:10  clip
add RECNO() builtin
Paul Lasarev <paul@itk.ru>

Revision 1.2  1999/10/26 19:19:08  axl
start cvs logging (./dbf)

*/

#include "dbf.h"
#include "dbfpriv.h"

#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdarg.h>
#include <ctype.h>
#include <math.h>

typedef enum
{
	L_norm,
	L_name,
	L_num,
	L_string,
} LexState;

typedef struct DbfParser
{
	char *beg;
	char *end;
	char *ptr;

	struct DbfFile *fp;

	int errcount;

	char *obuf;
	char *optr;
	char *oend;

	int deep;
	int maxdeep;

	LexState lex_state;
	int last_tok;

} DbfParser;

#define RETP (sp-argc-1)
#define ARGP(i) (sp-argc+(i))


#define NEW(type) ((type*)calloc(sizeof(type),1))
#define NEWVECT(type,len) ((type*)calloc(sizeof(type),(len)))
#define REALLOC(type,ptr,len) ((ptr)=(type*)realloc((ptr),sizeof(type)*(len)))

#define YYPARSE_PARAM parser
#define YYLEX_PARAM parser
#define	YYINITDEPTH 64
#define PARSER ((DbfParser*)parser)
#undef __GNUC__

static int dbflex();
static void dbfrt_error(DbfParser *parser, char *fmt,...);
#define dbferror(msg) dbfrt_error(PARSER, "%s", msg);
static int dbfparse(void *parser);

static int gen_call(DbfParser *parser, char *name, int len, int argc);
static int dbf_run(struct DbfFile *fp, DbfData *vp, char *str, char *compiled);

static int put_byte(DbfParser *parser, unsigned char byte);
static int put_ushort(DbfParser *parser, unsigned short s);
static int put_str(DbfParser *parser, char *beg, unsigned short len);
static int put_ptr(DbfParser *parser, void *ptr );
static int put_double(DbfParser *parser, double d);
static void add_deep(DbfParser *parser, int num);
static void sub_deep(DbfParser *parser, int num);
static int get_pos(DbfParser *parser);
static char *memmem( char *src, char *dst, int slen, int dlen );

#define CMD_END 0

#define CMD_CALL 1

#define CMD_NIL 10
#define CMD_NUM 11
#define CMD_STR 12
#define CMD_TRUE 13
#define CMD_FALSE 14
#define CMD_FLD 15

#define CMD_ADD 20
#define CMD_SUB 21
#define CMD_MUL 22
#define CMD_DIV 23
#define CMD_MOD 24
#define CMD_AND 25
#define CMD_OR 26
#define CMD_LT 27
#define CMD_LE 28
#define CMD_GT 29
#define CMD_GE 30
#define CMD_EQ 31
#define CMD_EEQ 32
#define CMD_NE 33
#define CMD_NOT 34
#define CMD_MINUS 35
#define CMD_CONTAIN 36
#define CMD_POW 37


%}

%union
{
	struct {
		char *beg;
		char *end;
	} string;
	struct {
		double d;
		int len;
		int dec;
	} doub;
	int pos;
	int i;
}

%pure_parser

%token <string> STRING
%token <doub> NUMBER
%token <string> NAME
%token TRUE FALSE NIL

%type <pos> expr pos
%type <i> arglist
%type <i> deep /*dexpr*/

%left OR
%left AND
%left '>' GE '<' LE EEQ EQ NE
%left '+' '-' '$'
%left '*' '/' '%'
%left POW
%right MINUS '!' NOT

%%

file:	expr
		{
			put_byte(PARSER, CMD_END);
		}

deep:	{ $$ = PARSER->deep; }

expr:	 NUMBER	{
			$$ = put_byte(PARSER, CMD_NUM);
			put_byte(PARSER, $1.len);
			put_byte(PARSER, $1.dec);
			put_double(PARSER, $1.d);
			add_deep(PARSER,1);
		}
	| STRING {
			$$ = put_byte(PARSER, CMD_STR);
			put_str(PARSER, $1.beg, $1.end-$1.beg);
			add_deep(PARSER,1);
		}
	| TRUE	{
			$$ = put_byte(PARSER, CMD_TRUE);
			add_deep(PARSER,1);
		}
	| FALSE	{
			$$ = put_byte(PARSER, CMD_FALSE);
			add_deep(PARSER,1);
		}
	| NIL	{
			$$ = put_byte(PARSER, CMD_NIL);
			add_deep(PARSER,1);
		}
	| NAME	{
			int r = fieldNo_DbfFile( PARSER->fp, $1.beg, $1.end-$1.beg);
			if (r<0)
			{
				dbfrt_error(PARSER, "invalid field name: '%.*s'", $1.end-$1.beg, $1.beg);
			}
			else
			{
				$$ = put_byte(PARSER, CMD_FLD);
				put_byte(PARSER, r);
				add_deep(PARSER,1);
			}
		}

	| '(' expr ')' 		{ $$=$2; }

	| NAME '(' pos deep arglist ')'
		{
			$$ = $3;
			gen_call(PARSER, $1.beg, $1.end-$1.beg, $5);
			/*sub_deep(PARSER, $5);*/
			PARSER->deep = $4;
		}

	| expr EQ expr		{ $$ = put_byte(PARSER, CMD_EQ); sub_deep(PARSER,1); }
	| expr EEQ expr		{ $$ = put_byte(PARSER, CMD_EEQ); sub_deep(PARSER,1); }
	| expr NE expr		{ $$ = put_byte(PARSER, CMD_NE); sub_deep(PARSER,1); }
	| expr '>' expr		{ $$ = put_byte(PARSER, CMD_GT); sub_deep(PARSER,1); }
	| expr '<' expr		{ $$ = put_byte(PARSER, CMD_LT); sub_deep(PARSER,1); }
	| expr LE expr		{ $$ = put_byte(PARSER, CMD_LE); sub_deep(PARSER,1); }
	| expr GE expr		{ $$ = put_byte(PARSER, CMD_GE); sub_deep(PARSER,1); }
	| expr '+' expr		{ $$ = put_byte(PARSER, CMD_ADD); sub_deep(PARSER,1); }
	| expr '$' expr		{ $$ = put_byte(PARSER, CMD_CONTAIN); sub_deep(PARSER,1); }
	| expr '-' expr		{ $$ = put_byte(PARSER, CMD_SUB); sub_deep(PARSER,1); }
	| expr '*' expr		{ $$ = put_byte(PARSER, CMD_MUL); sub_deep(PARSER,1); }
	| expr '/' expr		{ $$ = put_byte(PARSER, CMD_DIV); sub_deep(PARSER,1); }
	| expr '%' expr		{ $$ = put_byte(PARSER, CMD_MOD); sub_deep(PARSER,1); }
	| expr AND expr		{ $$ = put_byte(PARSER, CMD_AND); sub_deep(PARSER,1); }
	| expr OR expr		{ $$ = put_byte(PARSER, CMD_OR); sub_deep(PARSER,1); }
	| expr POW expr		{ $$ = put_byte(PARSER, CMD_POW); sub_deep(PARSER,1); }
	| '!' expr		{ $$ = put_byte(PARSER, CMD_NOT); }
	| '-' expr %prec MINUS	{ $$ = put_byte(PARSER, CMD_MINUS); }

/*dexpr:  expr	{$$=PARSER->deep;}*/

pos:	{ $$ = put_byte(PARSER, CMD_NIL); add_deep(PARSER, 1); }

arglist:			{ $$=0; }
	| expr			{ $$=1; }
	| arglist ',' expr 	{ $$=$1+1; }

%%

static int
nextn(DbfParser *pp, int n)
{
	if (pp->ptr<pp->end-n)
		return pp->ptr[n];
	else
		return 0;
}

static int
dbflex(yylvalp, pp)
	YYSTYPE *yylvalp;
	DbfParser *pp;
{
	int ch, next, tok=0, quot=0;
	char *beg = 0;

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
				case 'f':
				case 'F':
				case 'n':
				case 'N':
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
					tok = EEQ;
					pp->ptr++;
				}
				else
					tok = EQ;
				break;
			case '^':
				tok = POW;
				break;
			case '!':
				if (next=='=')
				{
					tok = NE;
					pp->ptr++;
				}
				else
					tok = '!';
				break;
			case '<':
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
				if (isalpha(ch)||ch=='_')
				{
					beg=pp->ptr;
					pp->lex_state=L_name;
				}
				else if (isdigit(ch))
				{
					beg=pp->ptr;
					pp->lex_state=L_num;
				}
				else
					tok=ch;
				break;
			}
			break;
		case L_name:
			if (isalnum(ch) || ch=='_')
				;
			else
			{
				yylvalp->string.beg=beg;
				yylvalp->string.end=pp->ptr;
				tok = NAME;
				pp->lex_state = L_norm;
				goto ret;
			}
			break;
		case L_num:
			if (isdigit(ch) || ch=='.')
				;
			else
			{
				int dec=0, len, i;

				len = pp->ptr-beg;
				for(i=0;i<len;++i)
					if (beg[i]=='.')
					{
						dec = len-i-1;
						break;
					}
				pp->lex_state = L_norm;
				yylvalp->doub.d = strtod(beg, NULL);
				yylvalp->doub.len = len;
				yylvalp->doub.dec = dec;
				tok = NUMBER;
				goto ret;
			}
			break;
		case L_string:
			if (ch == quot )
			{
				pp->lex_state = L_norm;
				yylvalp->string.beg = beg+1;
				yylvalp->string.end = pp->ptr;
				tok = STRING;
			}
			else if (!ch)
			{
				dbfrt_error(pp, "unterminated character string");
			}

			break;
		}
		if (!ch)
			return 0;
		++ pp->ptr;
ret:		if (tok)
		{
			pp->last_tok=tok;
			return tok;
		}
	}
}


static void
dbfrt_error(DbfParser *parser, char *fmt,...)
{
	int l;
	va_list ap;

	++parser->errcount;

	l = strlen(parser->fp->errbuf);

	snprintf(parser->fp->errbuf+l, ERRBUFSIZE-l, "%d: pos %d: ", parser->errcount, (parser->ptr-parser->beg)+1);
	l = strlen(parser->fp->errbuf);
	va_start(ap, fmt);
	vsnprintf(parser->fp->errbuf+l, ERRBUFSIZE-l, fmt, ap);
	va_end(ap);
	l = strlen(parser->fp->errbuf);
	snprintf(parser->fp->errbuf+l, ERRBUFSIZE-l, "\n");
}

static void put_error(struct DbfFile *fp, char *fmt,...)
{
	va_list ap;
	va_start(ap, fmt);
	vsnprintf(fp->errbuf, ERRBUFSIZE, fmt, ap);
	va_end(ap);
}


int
dbf_calc(struct DbfFile *fp, DbfData *vp, char *str, void **par)
{
	DbfParser parser;
	int ret=0;
	int len;

	if (par && *par)
		return dbf_run(fp, vp, str, (char*) *par);

	len = strlen(str);
	memset(&parser, 0, sizeof(parser));
	parser.beg = parser.ptr = str;
	parser.end = str+len;
	parser.fp=fp;
	parser.lex_state = L_norm;

	parser.obuf = (char*)malloc(64);
	parser.optr = parser.obuf;
	parser.oend = parser.obuf+64;

	put_byte(&parser, 0); /* stack deep */

	ret = dbfparse(&parser);

	if (ret || parser.errcount)
	{
		free(parser.obuf);
		ret = -1;
	}
	else
	{
		char *p = parser.obuf;
		p[0] = parser.maxdeep;
		ret = dbf_run(fp, vp, str, p);
		if (par)
			*par = p;
		else
			free(p);
	}

	return ret;
}

typedef struct
{
	char *name;
	DbfBuiltin func;
} BuiltinBucket;

static BuiltinBucket builtins[];

static int
gen_call(DbfParser *parser, char *name, int len, int argc)
{
	BuiltinBucket *bp;

	for(bp = builtins; bp->name; ++bp)
	{
		if (!strncasecmp(name, bp->name,len))
		{
			int r = put_byte(parser, CMD_CALL);
			put_byte(parser, argc);
			put_ptr(parser,bp->func);
			return r;
		}
	}

	dbfrt_error(parser, "unknown function '%.*s'", len, name);

	return get_pos(parser);
}

static int
make_buf(DbfParser *parser, int len)
{
	int l, r;

	r = parser->optr-parser->obuf;
	l = parser->oend - parser->optr;
	if (l<len)
	{
		int ll, lp, delta;

		ll = parser->oend - parser->obuf;
		lp = parser->optr - parser->obuf;

		delta = ll/4;
		if (delta<=l)
			delta = l+1;

		ll += delta;
		parser->obuf = (char*) realloc(parser->obuf, ll);
		parser->oend = parser->obuf+ll;
		parser->optr = parser->obuf+lp;
	}

	return r;
}

static int
put_byte(DbfParser *parser, unsigned char byte)
{
	int r;

	r = make_buf(parser,1);
	*parser->optr = byte;
	++parser->optr;
	return r;
}

static int
put_ushort(DbfParser *parser, unsigned short len)
{
	int r = make_buf(parser, sizeof(unsigned short));
	*(unsigned short*) parser->optr = len;
	parser->optr +=	sizeof(unsigned short);
	return r;
}


static int
put_str(DbfParser *parser, char *beg, unsigned short len)
{
	int r = put_ushort(parser, len);
	put_ptr(parser, beg);
	return r;
}

static int
put_ptr(DbfParser *parser, void *ptr)
{
	int r = make_buf(parser, sizeof(void*));
	*(void **)parser->optr = ptr;
	parser->optr += sizeof(void*);
	return r;
}

static int
put_double(DbfParser *parser, double d)
{
	int r = make_buf(parser, sizeof(double));
	*(double*) parser->optr = d;
	parser->optr +=	sizeof(double);
	return r;
}

static int
get_pos(DbfParser *parser)
{
	return parser->optr - parser->obuf;
}

static void
add_deep(DbfParser *parser, int num)
{
	parser->deep += num;
	if (parser->deep > parser->maxdeep)
		parser->maxdeep = parser->deep;
}

static void
sub_deep(DbfParser *parser, int num)
{
	parser->deep -= num;
}

static void
pop( DbfData **sp, int n)
{
	while(n)
	{
		--(*sp);
		destroy_DbfData(*sp);
		--n;
	}
}

static int
dbf_run(struct DbfFile *fp, DbfData *vp, char *str, char *compiled)
{
	unsigned char *pc;
	int i, deep, r=0, cmd;
	DbfData *stack, *sp;

	pc = (unsigned char *) compiled;
	deep = (*pc);
	stack = (DbfData *)alloca(deep*sizeof(DbfData));
	memset(stack, 0, deep*sizeof(DbfData));
	sp = stack;

	++pc;

	for(;;)
	{
		cmd = *pc++;
		switch( cmd )
		{
		case CMD_END:
			goto ret;
		case CMD_CALL:
			{
				int argc, r, i;
				DbfBuiltin func;
				argc = *pc;
				++pc;
				func = *(DbfBuiltin*)pc;
				pc +=  sizeof(DbfBuiltin);
				r = func(fp, argc, sp);
				if (r)
					goto err;
				for(i=0; i<argc; ++i)
					destroy_DbfData(--sp);
			}
			break;
		case CMD_NIL:
			sp->type = 'U';
			++sp;
			break;
		case CMD_NUM:
			sp->type = 'N';
			sp->len = *pc;
			++pc;
			sp->dec = *pc;
			++pc;
			sp->u.n = *(double*)pc;
			pc += sizeof(double);
			++sp;
			break;
		case CMD_STR:
			sp->type = 'C';
			sp->flags = DBFDATA_NONFREE;
			sp->u.c.len = *(unsigned short *)pc;
			pc += sizeof(unsigned short);
			sp->u.c.str = *(char **)pc;
			pc += sizeof(char*);
			++sp;
			break;
		case CMD_TRUE:
			sp->type = 'L';
			sp->u.l = 1;
			++sp;
			break;
		case CMD_FALSE:
			sp->type = 'L';
			sp->u.l = 0;
			++sp;
			break;
		case CMD_FLD:
			{
				int no = *pc;
				++pc;
				r = getVal_DbfFile(fp,no,sp);
				if (r)
					goto err;
				++sp;
			}
			break;
		case CMD_ADD:
			{
				DbfData *lp=sp-2, *rp=sp-1, *resp=sp-2;

				if (lp->type == 'C' && rp->type=='C')
				{
					int l;
					char *str;

					l = lp->u.c.len+rp->u.c.len;
					str = (char*) malloc(l+1);
					memcpy(str, lp->u.c.str, lp->u.c.len);
					memcpy(str+lp->u.c.len, rp->u.c.str, rp->u.c.len);

					str[l]=0;
					destroy_DbfData(resp);
					resp->type = 'C';
					resp->u.c.len = l;
					resp->u.c.str = str;
				}
				else if (lp->type == 'N' && rp->type == 'N')
				{
					resp->type = 'N';
					resp->u.n = lp->u.n + rp->u.n;
					resp->len = 0;
					resp->dec = 0;
				}
				else if (lp->type == 'D' && rp->type == 'N')
				{
					resp->type = 'D';
					resp->u.d = lp->u.d + rp->u.n;
				}
				else
				{
					put_error(fp, "invalid type in operator '+'");
					goto err;
				}

				pop(&sp, 1);
			}
			break;
		case CMD_SUB:
			{
				DbfData *lp=sp-2, *rp=sp-1, *resp=sp-2;

				if (lp->type == 'C' && rp->type=='C')
				{
					int l, ll=lp->u.c.len;
					char *s, *str;
					for(s=lp->u.c.str+ll; ll; --ll, --s)
						if ( *s!=' ' && *s!='\t' )
							break;
					l = ll+rp->u.c.len;
					str = (char*) malloc(l+1);
					memcpy(str, lp->u.c.str, ll);
					memcpy(str+ll, rp->u.c.str, rp->u.c.len);

					destroy_DbfData(resp);
					str[l] = 0;
					resp->type = 'C';
					resp->u.c.len = l;
					resp->u.c.str = str;
				}
				else if (lp->type == 'N' && rp->type == 'N')
				{
					resp->type = 'N';
					resp->u.n = lp->u.n - rp->u.n;
					resp->len = 0;
					resp->dec = 0;
				}
				else if (lp->type == 'D' && rp->type == 'N')
				{
					resp->type = 'D';
					resp->u.d = lp->u.d - rp->u.n;
				}
				else if (lp->type == 'D' && rp->type == 'D')
				{
					resp->type = 'N';
					resp->u.n = lp->u.d - rp->u.d;
					resp->len = 0;
					resp->dec = 0;
				}
				else
				{
					put_error(fp, "invalid type in operator '-'");
					goto err;
				}
				pop(&sp, 1);

			}
			break;
		case CMD_MUL:
			{
				DbfData *lp=sp-2, *rp=sp-1, *resp=sp-2;

				if (lp->type == 'N' && rp->type == 'N')
				{
					resp->type = 'N';
					resp->u.n = lp->u.n * rp->u.n;
					resp->len = 0;
					resp->dec = 0;
				}
				else
				{
					put_error(fp, "invalid type in operator '*'");
					goto err;
				}
				pop(&sp, 1);
			}
			break;
		case CMD_DIV:
			{
				DbfData *lp=sp-2, *rp=sp-1, *resp=sp-2;

				if (lp->type == 'N' && rp->type == 'N')
				{
					resp->type = 'N';
					resp->u.n = lp->u.n / rp->u.n;
					resp->len = 0;
					resp->dec = 0;
				}
				else
				{
					put_error(fp, "invalid type in operator '/'");
					goto err;
				}
				pop(&sp, 1);
			}
			break;
		case CMD_MOD:
			{
				DbfData *lp=sp-2, *rp=sp-1, *resp=sp-2;

				if (lp->type == 'N' && rp->type == 'N')
				{
					resp->type = 'N';
					resp->u.n = fmod(lp->u.n, rp->u.n);
					resp->len = 0;
					resp->dec = 0;
				}
				else
				{
					put_error(fp, "invalid type in operator '%%'");
					goto err;
				}
				pop(&sp, 1);
			}
			break;
		case CMD_POW:
			{
				DbfData *lp=sp-2, *rp=sp-1, *resp=sp-2;

				if (lp->type == 'N' && rp->type == 'N')
				{
					resp->type = 'N';
					resp->u.n = pow(lp->u.n, rp->u.n);
					resp->len = 0;
					resp->dec = 0;
				}
				else
				{
					put_error(fp, "invalid type in operator '%%'");
					goto err;
				}
				pop(&sp, 1);
			}
			break;
		case CMD_CONTAIN:
			{
				DbfData *lp=sp-2, *rp=sp-1, *resp=sp-2;

				if (lp->type == 'C' && rp->type == 'C')
				{
					int res;
					/*res = (strstr(rp->u.c.str, lp->u.c.str))?1:0;*/
					res = (memmem(rp->u.c.str, lp->u.c.str, rp->u.c.len, lp->u.c.len)?1:0);
					/*printf("$: %s $ %s\n", lp->u.c.str, rp->u.c.str);*/
					destroy_DbfData(resp);
					resp->u.l=res;
					resp->type = 'L';
				}
				else
				{
					put_error(fp, "invalid type in operator '$'");
					goto err;
				}
				pop(&sp, 1);
			}
			break;
		case CMD_AND:
			{
				DbfData *lp=sp-2, *rp=sp-1, *resp=sp-2;

				if (lp->type == 'L' && rp->type == 'L')
				{
					resp->type = 'L';
					resp->u.l = (lp->u.l && rp->u.l);
				}
				else
				{
					put_error(fp, "invalid type in operator '.AND.'");
					goto err;
				}
				pop(&sp, 1);
			}
			break;
		case CMD_OR:
			{
				DbfData *lp=sp-2, *rp=sp-1, *resp=sp-2;

				if (lp->type == 'L' && rp->type == 'L')
				{
					resp->type = 'L';
					resp->u.l = (lp->u.l || rp->u.l);
				}
				else
				{
					put_error(fp, "invalid type in operator '.OR.'");
					goto err;
				}
				pop(&sp, 1);
			}
			break;
		case CMD_LE:
		case CMD_LT:
		case CMD_GE:
		case CMD_GT:
		case CMD_EQ:
		case CMD_EEQ:
		case CMD_NE:
			{
				DbfData *lp=sp-2, *rp=sp-1, *resp=sp-2;
				int l=0;

				if (lp->type == 'C' && rp->type == 'C')
				{
					int ll = lp->u.c.len;
					int rl = rp->u.c.len;
					int cl = rl;
					char *sl = lp->u.c.str;
					char *sr = rp->u.c.str;
					char *el, *er;

					el = sl+ll;
					er = sr+rl;

					while(el>sl)
					{
						--el;
						if (*el!=' ' && *el!='\t')
							break;
					}
					++el;

					while(er>sr)
					{
						--er;
						if (*er!=' ' && *er!='\t')
							break;
					}
					++er;

					ll = el-sl;
					rl = er-sr;

					if (ll<rl)
						cl = ll;

					switch(cmd)
					{
					default:
						/*l = strncmp(sl, sr, cl);
						break;*/
					case CMD_EEQ:
						l = strncmp(sl, sr, cl);
						if (!l)
						{
							if (ll<rl)
								l = -1;
							else if (ll>rl)
								l = 1;
						}
						break;
					case CMD_EQ:
						{
							if (!rl)
							{
								l = 0;
								break;
							}

							if (rl>ll)
							{
								l = -1;
								break;
							}

							l = strncmp(sl, sr, rl);

						}
						break;
					}
					destroy_DbfData(resp);
				}
				else if (lp->type == 'N' && rp->type == 'N')
				{
					if (lp->u.n < rp->u.n)
						l = -1;
					else if (lp->u.n > rp->u.n)
						l = 1;
				}
				else if (lp->type == 'D' && rp->type == 'D')
				{
					if (lp->u.d < rp->u.d)
						l = -1;
					else if (lp->u.d > rp->u.d)
						l = 1;
				}
				else if (lp->type == 'U' && rp->type == 'U')
				{
				}
				else if (lp->type == 'L' && rp->type == 'L')
				{
					if (!lp->u.l && rp->u.l)
						l = 1;
					else if (lp->u.l && !rp->u.l)
						l = -1;
				}
				else
				{
					put_error(fp, "invalid type in compare operator");
					goto err;
				}

				resp->type = 'L';
				switch(cmd)
				{
				case CMD_LE:
					resp->u.l = (l<=0);
					break;
				case CMD_LT:
					resp->u.l = (l<0);
					break;
				case CMD_GE:
					resp->u.l = (l>=0);
					break;
				case CMD_GT:
					resp->u.l = (l>0);
					break;
				case CMD_EQ:
				case CMD_EEQ:
					resp->u.l = (l==0);
					break;
				case CMD_NE:
					resp->u.l = (l!=0);
					break;
				}
				pop(&sp, 1);
			}
			break;
		case CMD_NOT:
			{
				DbfData *lp=sp-1, *resp=sp-1;

				if (lp->type == 'L')
				{
					resp->type = 'L';
					resp->u.l = !lp->u.l;
				}
				else
				{
					put_error(fp, "invalid type in NOT operator");
					goto err;
				}
			}
			break;
		case CMD_MINUS:
			{
				DbfData *lp=sp-1, *resp=sp-1;

				if (lp->type == 'N')
				{
					resp->type = 'N';
					resp->u.n = -lp->u.n;
				}
				else
				{
					put_error(fp, "invalid type in MINUS operator");
					goto err;
				}
			}
			break;
		}
	}

ret:
	destroy_DbfData(vp);
	*vp = *stack;
	goto norm;
err:
	destroy_DbfData(stack);
norm:
	for(i=1; i<deep; ++i)
		destroy_DbfData(stack+i);

	return r;
}

#define parni(no) f_parni(argc,sp,(no))
#define parnd(no) f_parnd(argc,sp,(no))
#define parl(no) f_parl(argc,sp,(no))
#define par(no) f_par(argc,sp,(no))

#define retc(s) f_retc(argc,sp,(s),-1)
#define retcn(s,n) f_retc(argc,sp,(s),(n))
#define retni(i) f_retni(argc,sp,(i))
#define retnd(d) f_retnd(argc,sp,(d))
#define retl(l) f_retl(argc,sp,(l))

static DbfData *
f_par(int argc, DbfData *sp, int no)
{
	DbfData *vp;

	if (no>argc)
		return 0;

	vp = ARGP(no-1);

	return vp;
}

static int
f_parni(int argc, DbfData *sp, int no)
{
	DbfData *vp;

	if (no>argc)
		return 0;

	vp = ARGP(no-1);
	if (vp->type!='N')
		return 0;

	return vp->u.n;
}

static double
f_parnd(int argc, DbfData *sp, int no)
{
	DbfData *vp;

	if (no>argc)
		return 0;

	vp = ARGP(no-1);
	if (vp->type!='N')
		return 0;

	return vp->u.n;
}

static int
f_parl(int argc, DbfData *sp, int no)
{
	DbfData *vp;

	if (no>argc)
		return 0;

	vp = ARGP(no-1);
	if (vp->type!='L')
		return 0;

	return vp->u.l;
}

static int
f_parc(int argc, DbfData *sp, int no, char **strp, int *lenp)
{
	DbfData *vp;

	if (no>argc)
		return 0;

	vp = ARGP(no-1);
	if (vp->type!='C')
		return 0;

	*strp = vp->u.c.str;
	*lenp = vp->u.c.len;

	return 1;
}

static void
f_retc(int argc, DbfData *sp, char *s, int l)
{
	DbfData *rp = RETP;

	if (l<0)
		l = strlen(s);
	rp->type = 'C';
	rp->u.c.str = dbf_mem_dup(s, l);
	rp->u.c.len = l;
}

static void
trim(int ltrim, int rtrim, char *s, int l, char **rs, int *rl)
{
	int b=0;
	if (rtrim)
		for(; l>0; --l)
		{
			switch(s[l-1])
			{
			case ' ':
			case '\t':
				continue;
			}
			break;
		}
	if (ltrim)
		for(; b<l; ++b)
		{
			switch(s[b])
			{
			case ' ':
			case '\t':
				continue;
			}
			break;
		}

	*rs = dbf_mem_dup(s+b, l-b);
	*rl = l-b;
}

static int
f_rtrim(struct DbfFile *fp, int argc, DbfData *sp)
{
	DbfData *vp, *rp;

	if (argc<1)
		return 0;

	vp = ARGP(0);
	if (vp->type!='C')
		return 0;

	rp = RETP;
	rp->type = 'C';
	trim (0,1, vp->u.c.str, vp->u.c.len, &rp->u.c.str, &rp->u.c.len);

	return 0;
}

static int
f_ltrim(struct DbfFile *fp, int argc, DbfData *sp)
{
	DbfData *vp, *rp;

	if (argc<1)
		return 0;

	vp = ARGP(0);
	if (vp->type!='C')
		return 0;

	rp = RETP;
	rp->type = 'C';
	trim (1,0, vp->u.c.str, vp->u.c.len, &rp->u.c.str, &rp->u.c.len);

	return 0;
}

static int
f_alltrim(struct DbfFile *fp, int argc, DbfData *sp)
{
	DbfData *vp, *rp;

	if (argc<1)
		return 0;

	vp = ARGP(0);
	if (vp->type!='C')
		return 0;

	rp = RETP;
	rp->type = 'C';
	trim (1,1, vp->u.c.str, vp->u.c.len, &rp->u.c.str, &rp->u.c.len);

	return 0;
}

static int
f_val(struct DbfFile *fp, int argc, DbfData *sp)
{
	DbfData *vp, *rp;
	char *p, *spp, *e=0;
	int dec, len;
	double d;

	if (argc<1)
		return 0;

	vp = ARGP(0);
	if (vp->type!='C')
		return 0;

	for(p=vp->u.c.str; *p && !isdigit(*p); ++p)
			;
	spp = p;

	d = strtod( spp, &e );
	if (e)
		len = (e-spp);
	else
		len = strlen(spp);

	p = strchr( spp, '.' );
	if (p)
		dec = len-(p-spp)-1;
	else
		dec = 0;
	if (dec<0)
		dec = 0;

	rp = RETP;
	rp->type = 'N';
	rp->u.n = d;
	rp->dec = dec;
	rp->len = len;

	return 0;
}

static void
dtos(double d, char *buf, int buflen, int *dp)
{
	int dl;
	char *s;

	snprintf( buf, buflen, "%.0f", d );
	dl=strlen(buf);
	if (dp)
		*dp = dl;
	snprintf( buf, buflen, "%.*f", buflen-dl-1, d );
	for(s = buf+strlen(buf); s>buf ; --s)
		if ( s[-1]!='0' )
			break;
	if (s>buf && s[-1]=='.')
		--s;
	*s = 0;
}

static int
f_str(struct DbfFile *fp, int argc, DbfData *sp)
{
	char buf[32];
	double d = parnd(1);
	int len=0, dec=0;

	if (argc==1)
	{
		DbfData *vp;
		vp = par(1);
		len = vp->len;
		dec = vp->dec;
	}
	if (argc>1)
		len = parni(2);
	if (argc>2)
		dec = parni(3);

	if(len)
		snprintf(buf, sizeof(buf), "%*.*f", len, dec, d);
	else
		dtos(d,buf,sizeof(buf),0);
	retc(buf);

	return 0;
}

static int
f_dtos(struct DbfFile *fp, int argc, DbfData *sp)
{
	DbfData *vp;
	int dd, mm, yy, ww;
	char buf[9];

	if (argc<1)
	{
err:		retc("        ");
		return 0;
	}
	vp = ARGP(0);
	if (vp->type != 'D')
		goto err;

	if (vp->u.d == 0)
		goto err;

	dbf_cdate( vp->u.d, &dd, &mm, &yy, &ww);
	sprintf(buf, "%04d%02d%02d", yy, mm, dd);

	retcn(buf,8);

	return 0;
}

static int
f_ctod(struct DbfFile *fp, int argc, DbfData *sp)
{
	DbfData *rp;
	char *s;
	int l, cl, yy=0, mm=0, dd=0;
	long julian=0;
	char buf[5];

	if (! f_parc(argc,sp,1, &s, &l))
		goto ret;

	if (l<4)
		goto ret;
	cl = 4;
	memcpy(buf, s, cl);
	buf[cl] = 0;
	sscanf(buf, "%d", &yy);

	l-=cl;
	s+=cl;
	if (l<2)
		goto ret;
	cl = 2;
	memcpy(buf, s, cl);
	buf[cl] = 0;
	sscanf(buf, "%d", &mm);

	l-=cl;
	s+=cl;
	if (l<2)
		goto ret;
	cl = 2;
	memcpy(buf, s, cl);
	buf[cl] = 0;
	sscanf(buf, "%d", &dd);

	julian = dbf_jdate(dd, mm, yy);

ret:
	rp = RETP;
	rp->type = 'D';
	rp->u.d = julian;

	return 0;
}

static int
f_asc(struct DbfFile *fp, int argc, DbfData *sp)
{
	DbfData *rp;
	char *s;
	int l;
	double d = 0;

	if (!f_parc(argc,sp,1, &s, &l))
		goto ret;

	d = s[0];

ret:
	rp = RETP;
	rp->type = 'N';
	rp->u.n = d;

	return 0;

}

static int
f_chr(struct DbfFile *fp, int argc, DbfData *sp)
{
	char buf[8];
	int ch = parni(1);

	snprintf(buf, sizeof(buf), "%d", ch);
	retc(buf);

	return 0;
}

static int
f_substr(struct DbfFile *fp, int argc, DbfData *sp)
{
	char *s;
	DbfData *rp;
	int start, count, l;

	if (! f_parc(argc, sp, 1, &s, &l))
	{
err:		retc("");
		return 0;
	}

	start = parni(2);
	count = parni(3);

	if (start>l)
		goto err;
	if (start+count>l)
		count = l-start;

	rp = RETP;
	rp->type = 'C';
	rp->u.c.len = count;
	rp->u.c.str = dbf_mem_dup(s+start, count);

	return 0;
}

static int
f_pad(struct DbfFile *fp, int argc, DbfData *sp, int lpad, int rpad )
{
	char *s, *rs;
	DbfData *rp;
	int len, ch, l, ll=0, rl=0, diff;

	len = parni(2);
	ch = parni(3);

	if (! f_parc(argc, sp, 1, &s, &l))
	{
err:
		rp = RETP;
		rp->type = 'C';
		rs = rp->u.c.str = (char*) malloc(len+1);
		rp->u.c.len = len;
		memset(rs, ' ', len);
		rs[len] = 0;
		return 0;
	}

	if (!len)
		goto err;
	if (!ch)
		ch = ' ';

	if (len<=l)
	{
		retcn(s,len);
		return 0;
	}

	diff = len-l;
	if (lpad && !rpad)
		ll = diff;
	else if (!lpad && rpad)
		rl = diff;
	else
	{
		ll = diff/2;
		rl = diff - ll;
	}


	rp = RETP;
	rs = rp->u.c.str = (char*) malloc(len+1);
	rp->u.c.len = len;
	rs[len]=0;

	memset(rs, ch, ll);
	memcpy(rs+ll, s, l);
	memset(rs+ll+l, ch, rl);

	return 0;
}

static int
f_padr(struct DbfFile *fp, int argc, DbfData *sp )
{
	return f_pad(fp, argc, sp, 0, 1);
}

static int
f_padl(struct DbfFile *fp, int argc, DbfData *sp )
{
	return f_pad(fp, argc, sp, 1, 0);
}

static int
f_padc(struct DbfFile *fp, int argc, DbfData *sp )
{
	return f_pad(fp, argc, sp, 1, 1);
}

static int
f_empty(struct DbfFile *fp, int argc, DbfData *sp )
{
	int r=0, l;
	DbfData *rp, *vp;
	char *s;

	if (argc<1)
		goto ret;

	vp = ARGP(0);
	switch(vp->type)
	{
	case 'U':
		r = 1;
		break;
	case 'N':
		r = (vp->u.n==0?1:0);
		break;
	case 'L':
		r = !vp->u.l;
		break;
	case 'D':
		r = (vp->u.d==0?1:0);
		break;
	case 'C':
		l = vp->u.c.len;
		s = vp->u.c.str;
		r=1;
		for(; l; ++s, --l)
		{
			switch(*s)
			{
			case ' ':
			case '\t':
			case '\r':
			case '\n':
				continue;
			}
			r = 0;
			break;
		}

		break;
	}

ret:
	rp = RETP;
	rp->type = 'L';
	rp->u.l = r;

	return 0;
}

static int
f_len(struct DbfFile *fp, int argc, DbfData *sp)
{
	char *s;
	DbfData *rp;
	int l, r=0;

	if ( f_parc(argc, sp, 1, &s, &l) )
		r = l;

	rp = RETP;
	rp->type = 'N';
	rp->u.n = r;

	return 0;
}

static int
f_repl(struct DbfFile *fp, int argc, DbfData *sp)
{
	char *s=" ", *rs;
	DbfData *rp;
	int l, n = 0;

	n = parni(2);
	f_parc(argc, sp, 1, &s, &l);

	rp = RETP;
	rp->type = 'C';
	rs = rp->u.c.str = (char *) malloc(n+1);
	rs[n]=0;
	rp->u.c.len = n;

	return 0;
}

static int
f_iif(struct DbfFile *fp, int argc, DbfData *sp)
{
	DbfData *rp;
	int n = 0;

	if (argc<3)
		return 0;

	n = parl(1);
	if (n)
		rp = ARGP(1);
	else
		rp = ARGP(2);

	rp = dup_DbfData(rp);

	*RETP = *rp;

	return 0;
}

static int
f_upper(struct DbfFile *fp, int argc, DbfData *sp)
{
	char *s;
	unsigned char *rs;
	DbfData *rp;
	int l;

	if ( !f_parc(argc, sp, 1, &s, &l))
	{
		retc("");
		return 0;
	}

	rp = RETP;
	rp->type = 'C';
	rs = rp->u.c.str = dbf_mem_dup(s, l);
	rp->u.c.len = l;

	for(; l; ++rs, --l)
	{
		if (*rs<128)
			*rs = toupper(*rs);
		else if (fp->cmptbl)
			*rs = fp->cmptbl->upper[*rs - 128];
	}

	return 0;
}

static int
f_lower(struct DbfFile *fp, int argc, DbfData *sp)
{
	char *s;
	unsigned char *rs;
	DbfData *rp;
	int l;

	if ( !f_parc(argc, sp, 1, &s, &l))
	{
		retc("");
		return 0;
	}

	rp = RETP;
	rp->type = 'C';
	rs = rp->u.c.str = dbf_mem_dup(s, l);
	rp->u.c.len = l;

	for(; l; ++rs, --l)
	{
		if (*rs<128)
			*rs = tolower(*rs);
		else if (fp->cmptbl)
			*rs = fp->cmptbl->lower[*rs - 128];
	}

	return 0;
}


static char *
memmem( char *src, char *dst, int slen, int dlen )
{
	char *end, *de, *s=src, *d=dst;

	for( end=src+slen, de=dst+dlen-1; src < end; src++ )
	if ( *src == *d )
	{
		s = src;
		for( ; src < end && d < de && *(++src) == *(++d); )
			;
		if ( d == de && *src == *d )
			return s;
		src = s;
		d = dst;
	}
	return 0;
}

static int
f_atl(struct DbfFile *fp, int argc, DbfData *sp )
{
	char *s1, *s2, *s3;
	int l1, l2;
	DbfData *rp;

	if ( !f_parc(argc, sp, 1, &s1, &l1)
		|| !f_parc(argc, sp, 2, &s2, &l2)
		)
		s3 = 0;
	else
		s3 = memmem(s1, s2, l1, l2);

	rp = RETP;
	rp->type = 'N';
	rp->u.n = (s3?s3-s1+1:0);
	rp->dec = 0;
	rp->len = 0;

	return 0;
}

static int
f_atr(struct DbfFile *fp, int argc, DbfData *sp )
{
	char *src, *dst, *s3=0;
	int slen, dlen;
	DbfData *rp;

	if ( f_parc(argc, sp, 1, &src, &slen)
		&& f_parc(argc, sp, 2, &dst, &dlen) )
	{
		char *s=src+slen-1, *d=dst+dlen-1, *ss=s;
		for( ; s >= src; s-- )
		{
			if ( *s == *d )
			{
				ss = s;
				for( ; s >= src && d >= dst && *(--s) == *(--d); )
					;
				if ( d == dst-1 )
				{
					s3 = s+1;
					break;
				}
				s = ss;
				d = dst+dlen-1;
			}
		}
	}

	rp = RETP;
	rp->type = 'N';
	rp->u.n = (s3?s3-src+1:0);
	rp->dec = 0;
	rp->len = 0;

	return 0;
}

static int
f_recno(struct DbfFile *fp, int argc, DbfData *sp )
{
	DbfData *rp;
	long recno = -1;

	recNo_DbfFile(fp, &recno);

	rp = RETP;
	rp->type = 'N';
	rp->u.n = recno;
	rp->dec = 0;
	rp->len = 7;

	return 0;
}

static BuiltinBucket builtins[] =
{
	{ "TRIM",	f_rtrim },
	{ "RTRIM",	f_rtrim },
	{ "LTRIM",	f_ltrim },
	{ "ALLTRIM",	f_alltrim },
	{ "VAL",	f_val },
	{ "STR",	f_str },
	{ "DTOS",	f_dtos },
	{ "DTOC",	f_dtos },
	{ "CTOD",	f_ctod },
	{ "STOD",	f_ctod },
	{ "ASC",	f_asc },
	{ "CHR",	f_chr },
	{ "SUBSTR",	f_substr },
	{ "PAD",	f_padr },
	{ "PADR",	f_padr },
	{ "PADL",	f_padl },
	{ "PADC",	f_padc },
	{ "EMPTY",	f_empty },
	{ "LEN",	f_len },
	{ "REPLICATE",	f_repl },
	{ "IIF",	f_iif },
	{ "IF",		f_iif },
	{ "LOWER",	f_lower },
	{ "UPPER",	f_upper },
	{ "AT",		f_atl },
	{ "RAT",	f_atr },
	{ "RECNO",	f_recno },
	{ 0, 0 }
};

