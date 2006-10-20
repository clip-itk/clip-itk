/*
$Log$
Revision 1.1  2006/06/22 19:35:17  itk
uri: init sf.net repository

Revision 1.2  2003/07/03 07:15:56  clip
fix a lot of warnings
paul

Revision 1.1  2002/10/30 12:17:26  clip
support for plural forms in i18n messages
paul

*/
%{
/* Expression parsing for plural form selection.*/

/*
   This code is based on and use part of
   plural computation sources in intl library copyrighted by

   Copyright (C) 2000, 2001 Free Software Foundation, Inc.
   Written by Ulrich Drepper <drepper@cygnus.com>, 2000.
*/
#include <stdlib.h>
#include <string.h>
#include "plural.h"

#define YYPARSE_PARAM arg
#define YYLEX_PARAM arg
/* #define YYINITDEPTH 64 */
#define PLURAL_DATA ((PluralData*)arg)

/* This is the representation of the expressions to determine the
   plural form.  */
struct expression
{
  int nargs;			/* Number of arguments.  */
  enum operator
  {
    /* Without arguments:  */
    var,			/* The variable "n".  */
    num,			/* Decimal number.  */
    /* Unary operators:  */
    lnot,			/* Logical NOT.  */
    /* Binary operators:  */
    mult,			/* Multiplication.  */
    divide,			/* Division.  */
    module,			/* Modulo operation.  */
    plus,			/* Addition.  */
    minus,			/* Subtraction.  */
    less_than,			/* Comparison.  */
    greater_than,		/* Comparison.  */
    less_or_equal,		/* Comparison.  */
    greater_or_equal,		/* Comparison.  */
    equal,			/* Comparison for equality.  */
    not_equal,			/* Comparison for inequality.  */
    land,			/* Logical AND.  */
    lor,			/* Logical OR.  */
    /* Ternary operators:  */
    qmop			/* Question mark operator.  */
  } operation;
  union
  {
    unsigned long int num;	/* Number value for `num'.  */
    struct expression *args[3];	/* Up to three arguments.  */
  } val;
};


static void free_expression( struct expression *exp);


struct PluralData
{
	char *expr;
        char *pexpr;
	struct expression *res;
};

%}

%pure_parser

%union {
  unsigned long int num;
  enum operator op;
  struct expression *exp;
}

%{
/* Prototypes for local functions.  */
static struct expression *new_exp (int nargs, enum operator op,
					   struct expression * const *args);
static inline struct expression *new_exp_0 (enum operator op);
static inline struct expression *new_exp_1 (enum operator op,
						   struct expression *right);
static struct expression *new_exp_2 (enum operator op,
					     struct expression *left,
					     struct expression *right);
static inline struct expression *new_exp_3 (enum operator op,
						   struct expression *bexp,
						   struct expression *tbranch,
						   struct expression *fbranch);
static int plurallex (YYSTYPE *lval, PluralData *pdata);
static void pluralerror (const char *str);

/* Allocation of expressions.  */

static struct expression *
new_exp (nargs, op, args)
     int nargs;
     enum operator op;
     struct expression * const *args;
{
  int i;
  struct expression *newp;

  /* If any of the argument could not be malloc'ed, just return 0.  */
  for (i = nargs - 1; i >= 0; i--)
    if (args[i] == 0)
      goto fail;

  /* Allocate a new expression.  */
  newp = (struct expression *) malloc (sizeof (*newp));
  if (newp != 0)
    {
      newp->nargs = nargs;
      newp->operation = op;
      for (i = nargs - 1; i >= 0; i--)
	newp->val.args[i] = args[i];
      return newp;
    }

 fail:
  for (i = nargs - 1; i >= 0; i--)
    free_expression (args[i]);

  return 0;
}

static struct expression *
new_exp_0 (op)
     enum operator op;
{
  return new_exp (0, op, 0);
}

static struct expression *
new_exp_1 (op, right)
     enum operator op;
     struct expression *right;
{
  struct expression *args[1];

  args[0] = right;
  return new_exp (1, op, args);
}

static struct expression *
new_exp_2 (op, left, right)
     enum operator op;
     struct expression *left;
     struct expression *right;
{
  struct expression *args[2];

  args[0] = left;
  args[1] = right;
  return new_exp (2, op, args);
}

static struct expression *
new_exp_3 (op, bexp, tbranch, fbranch)
     enum operator op;
     struct expression *bexp;
     struct expression *tbranch;
     struct expression *fbranch;
{
  struct expression *args[3];

  args[0] = bexp;
  args[1] = tbranch;
  args[2] = fbranch;
  return new_exp (3, op, args);
}

%}

/* This declares that all operators have the same associativity and the
   precedence order as in C.  See [Harbison, Steele: C, A Reference Manual].
   There is no unary minus and no bitwise operators.
   Operators with the same syntactic behaviour have been merged into a single
   token, to save space in the array generated by bison.  */
%right '?'		/*   ?		*/
%left '|'		/*   ||		*/
%left '&'		/*   &&		*/
%left EQUOP2		/*   == !=	*/
%left CMPOP2		/*   < > <= >=	*/
%left ADDOP2		/*   + -	*/
%left MULOP2		/*   * / %	*/
%right '!'		/*   !		*/

%token <op> EQUOP2 CMPOP2 ADDOP2 MULOP2
%token <num> NUMBER
%type <exp> exp

%%

start:	  exp
	  {
	    PLURAL_DATA->res = $1;
	  }
	;

exp:	  exp '?' exp ':' exp
	  {
	    $$ = new_exp_3 (qmop, $1, $3, $5);
	  }
	| exp '|' exp
	  {
	    $$ = new_exp_2 (lor, $1, $3);
	  }
	| exp '&' exp
	  {
	    $$ = new_exp_2 (land, $1, $3);
	  }
	| exp EQUOP2 exp
	  {
	    $$ = new_exp_2 ($2, $1, $3);
	  }
	| exp CMPOP2 exp
	  {
	    $$ = new_exp_2 ($2, $1, $3);
	  }
	| exp ADDOP2 exp
	  {
	    $$ = new_exp_2 ($2, $1, $3);
	  }
	| exp MULOP2 exp
	  {
	    $$ = new_exp_2 ($2, $1, $3);
	  }
	| '!' exp
	  {
	    $$ = new_exp_1 (lnot, $2);
	  }
	| 'n'
	  {
	    $$ = new_exp_0 (var);
	  }
	| NUMBER
	  {
	    if (($$ = new_exp_0 (num)) != 0)
	      $$->val.num = $1;
	  }
	| '(' exp ')'
	  {
	    $$ = $2;
	  }
	;

%%

static void
free_expression( struct expression *exp)
{
  	if (exp == 0)
    		return;

  	/* Handle the recursive case.  */
  	switch (exp->nargs)
    	{
    	case 3:
      		free_expression (exp->val.args[2]);
      		/* FALLTHROUGH */
    	case 2:
      		free_expression (exp->val.args[1]);
      		/* FALLTHROUGH */
    	case 1:
      		free_expression (exp->val.args[0]);
      		/* FALLTHROUGH */
    	default:
      		break;
    	}

  	free (exp);
}


static int
plurallex (lval, pdata)
     YYSTYPE *lval;
     PluralData *pdata;
{
  char **pexp = &pdata->pexpr;
  char *exp = *pexp;
  int result;

  while (1)
    {
      if (exp[0] == '\0')
	{
	  *pexp = exp;
	  return YYEOF;
	}

      if (exp[0] != ' ' && exp[0] != '\t')
	break;

      ++exp;
    }

  result = *exp++;
  switch (result)
    {
    case '0': case '1': case '2': case '3': case '4':
    case '5': case '6': case '7': case '8': case '9':
      {
	unsigned long int n = result - '0';
	while (exp[0] >= '0' && exp[0] <= '9')
	  {
	    n *= 10;
	    n += exp[0] - '0';
	    ++exp;
	  }
	lval->num = n;
	result = NUMBER;
      }
      break;

    case '=':
      if (exp[0] == '=')
	{
	  ++exp;
	  lval->op = equal;
	  result = EQUOP2;
	}
      else
	result = YYERRCODE;
      break;

    case '!':
      if (exp[0] == '=')
	{
	  ++exp;
	  lval->op = not_equal;
	  result = EQUOP2;
	}
      break;

    case '&':
    case '|':
      if (exp[0] == result)
	++exp;
      else
	result = YYERRCODE;
      break;

    case '<':
      if (exp[0] == '=')
	{
	  ++exp;
	  lval->op = less_or_equal;
	}
      else
	lval->op = less_than;
      result = CMPOP2;
      break;

    case '>':
      if (exp[0] == '=')
	{
	  ++exp;
	  lval->op = greater_or_equal;
	}
      else
	lval->op = greater_than;
      result = CMPOP2;
      break;

    case '*':
      lval->op = mult;
      result = MULOP2;
      break;

    case '/':
      lval->op = divide;
      result = MULOP2;
      break;

    case '%':
      lval->op = module;
      result = MULOP2;
      break;

    case '+':
      lval->op = plus;
      result = ADDOP2;
      break;

    case '-':
      lval->op = minus;
      result = ADDOP2;
      break;

    case 'n':
    case '?':
    case ':':
    case '(':
    case ')':
      /* Nothing, just return the character.  */
      break;

    case ';':
    case '\n':
    case '\0':
      /* Be safe and let the user call this function again.  */
      --exp;
      result = YYEOF;
      break;

    default:
      result = YYERRCODE;
#if YYDEBUG != 0
      --exp;
#endif
      break;
    }

  *pexp = exp;

  return result;
}


static void
pluralerror (str)
     const char *str;
{
  /* Do nothing.  We don't print error messages here.  */
}



PluralData *
plural_new(char *expr, int elen)
{
	PluralData *pd = (PluralData*) calloc(1, sizeof(PluralData));
        pd->expr = (char*) malloc(elen+1);
        pd->expr[elen] = 0;
        memcpy(pd->expr, expr, elen);
        pd->pexpr = pd->expr;

	pluralparse(pd);

	free(pd->expr);
        pd->expr = 0;
        pd->pexpr = 0;

	return pd;
}

void
plural_delete(PluralData *pd)
{
	if (pd->expr)
        	free(pd->expr);

	if (pd->res)
        	free_expression(pd->res);

	free(pd);
}

static unsigned long int
plural_eval_exp(struct expression *pexp, unsigned long int n)
{
  if (!pexp)
     return 0;

  switch (pexp->nargs)
    {
    case 0:
      switch (pexp->operation)
	{
	case var:
	  return n;
	case num:
	  return pexp->val.num;
	default:
	  break;
	}
      /* NOTREACHED */
      break;
    case 1:
      {
	/* pexp->operation must be lnot.  */
	unsigned long int arg = plural_eval_exp (pexp->val.args[0], n);
	return ! arg;
      }
    case 2:
      {
	unsigned long int leftarg = plural_eval_exp (pexp->val.args[0], n);
	if (pexp->operation == lor)
	  return leftarg || plural_eval_exp (pexp->val.args[1], n);
	else if (pexp->operation == land)
	  return leftarg && plural_eval_exp (pexp->val.args[1], n);
	else
	  {
	    unsigned long int rightarg = plural_eval_exp (pexp->val.args[1], n);

	    switch (pexp->operation)
	      {
	      case mult:
		return leftarg * rightarg;
	      case divide:
		return leftarg / rightarg;
	      case module:
		return leftarg % rightarg;
	      case plus:
		return leftarg + rightarg;
	      case minus:
		return leftarg - rightarg;
	      case less_than:
		return leftarg < rightarg;
	      case greater_than:
		return leftarg > rightarg;
	      case less_or_equal:
		return leftarg <= rightarg;
	      case greater_or_equal:
		return leftarg >= rightarg;
	      case equal:
		return leftarg == rightarg;
	      case not_equal:
		return leftarg != rightarg;
	      default:
		break;
	      }
	  }
	/* NOTREACHED */
	break;
      }
    case 3:
      {
	/* pexp->operation must be qmop.  */
	unsigned long int boolarg = plural_eval_exp (pexp->val.args[0], n);
	return plural_eval_exp (pexp->val.args[boolarg ? 1 : 2], n);
      }
    }
  /* NOTREACHED */
  return 0;
}

int
plural_eval(PluralData *pd, unsigned long int n)
{
  	if (!pd->res)
        	return 0;

	return plural_eval_exp(pd->res, n);
}

