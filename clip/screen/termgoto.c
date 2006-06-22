
/*
   $Log$
   Revision 1.1  2006/06/22 19:35:31  itk
   uri: init sf.net repository

   Revision 1.6  2004/05/21 11:22:19  clip
   rust: minor fix for 'configure -m'

   Revision 1.5  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.4  2000/03/10 17:45:01  paul
   *** empty log message ***

   Revision 1.3  2000/03/10 15:56:11  paul
   xon/xoff gluk

   Revision 1.2  1999/11/02 23:05:58  axl
   start of logging CVS

 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#include "../clip.h"

#define MAXRETURNSIZE 64
	   /* max length of 'goto' string */
#define TPARMERR(c)     { strcpy (outp, (c)); return; }

static void tparm(char *outp, char *cp, int p1, int p2);

/*
   // Routine to perform cursor addressing.
   // CM is a string containing printf type escapes to allow
   // cursor addressing.  We start out ready to print the destination
   // line, and switch each time we print row or column.
   // The following escapes are defined for substituting row/column:
   //
   //      %d      as in printf
   //      %2      like %2d
   //      %3      like %3d
   //      %.      gives %c hacking special case characters
   //      %+x     like %c but adding x first
   //
   //      The codes below affect the state but don't use up a value.
   //
   //      %>xy    if value > x add y
   //      %r      reverses row/column
   //      %i      increments row/column (for one origin indexing)
   //      %%      gives %
   //      %B      BCD (2 decimal digits encoded in one byte)
   //      %D      Delta Data (backwards bcd)
   //
   // all other characters are ``self-inserting''.
 */

static void
do_delay(int ms)
{
	if (ms)
		usleep(ms * 1000);
}

void
scr_tgoto(char *CM, int destcol, int destline, char *buf, int buflen)
{
	char *cp, *dp, *ep;
	int c, which, oncol;

#ifdef DEBUG
	printf("CM='%s'\n", CM);
#endif
	cp = CM;
	if (!cp)
		  toohard:
		return;
	dp = buf;
	ep = dp + buflen - 1;
	oncol = 0;
	which = destline;
	while (dp < ep && (c = *cp++))
	{
		switch (c)
		{
		default:
			*dp++ = c;
			continue;

		case '%':
			switch (c = *cp++)
			{
			case 'n':
				destcol ^= 0140;
				destline ^= 0140;
				goto setwhich;
			case 'd':
				if (which < 10)
					goto one;
				if (which < 100)
					goto two;
				/* fall into... */
			case '3':
				*dp++ = (which / 100) | '0';
				which %= 100;
				/* fall into... */
			case '2':
				  two:
				*dp++ = which / 10 | '0';
				  one:
				*dp++ = which % 10 | '0';
				  swap:
				oncol = 1 - oncol;
				  setwhich:
				which = oncol ? destcol : destline;
				continue;
			case '>':
				if (which > *cp++)
					which += *cp++;
				else
					cp++;
				continue;
			case '+':
				which += *cp++;
				/* fall into... */
			case '.':
				*dp++ = which;
				goto swap;
			case 'r':
				oncol = 1;
				goto setwhich;
			case 'i':
				destcol++;
				destline++;
				which++;
				continue;
			case '%':
				*dp++ = c;
				continue;
			case '/':
				c = *cp;
				*dp++ = which / c | '0';
				which %= *cp++;
				continue;
			case 'B':
				which = (which / 10 << 4) + which % 10;
				continue;
			case 'D':
				which = which - 2 * (which % 16);
				continue;
			case 'p':
			case 'P':
			case '\'':
			case '{':	/* } */
			case '?':
				/* string is in tparm format... */
				tparm(dp, cp - 2, destline, destcol);
				return;
			default:
				goto toohard;
			}
		}
	}
	*dp = 0;
}

#if 0
char *
tgoto(char *CM, int destcol, int destline)
{
	static char result[MAXRETURNSIZE];

	scr_tgoto(CM, destcol, destline, result, MAXRETURNSIZE);
	return result;
}
#endif

int
scr_tputs(const char *str, int affcnt, int (*put_c) (int, void *), void *par)
{
	int delay = 0, c;

#if 1
	/* termcap style delay */
	delay = atoi(str);
	for (; (c = *str); ++str)
	{
		switch (c)
		{
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
		case '.':
			continue;
		}
		break;
	}

	while ((c = *str++))
	{
		switch (c)
		{
		case '$':
			if (*str == '<')
			{
				++str;
				delay = atoi(str);
				while ((c = *str++) != '>' && str)
					;
				break;
			}
		default:
			put_c(c, par);
			break;
		}
	}
#endif
	while (affcnt-- > 0)
		do_delay(delay);

	return 0;
}

static char *
branchto(char *cp, int to)
{
	int c, level;

	level = 0;
	while ((c = *cp++))
	{
		if (c == '%')
		{
			if ((c = *cp++) == to || c == ';')
			{
				if (level == 0)
				{
					return cp;
				}
			}
			if (c == '?')
				level++;
			if (c == ';')
				level--;
		}
	}
	return ("no matching ENDIF");
}

/*
   // Routine to perform parameter substitution.
   // instring is a string containing printf type escapes.
   // The whole thing uses a stack, much like an HP 35.
   // The following escapes are defined for substituting row/column:
   //
   //      %d      print pop() as in printf
   //      %[0]2d  print pop() like %2d
   //      %[0]3d  print pop() like %3d
   //      %c      print pop() like %c
   //
   //      %p[1-0] push ith parm
   //      %P[a-z] set variable
   //      %g[a-z] get variable
   //      %'c'    char constant c
   //      %{nn}   integer constant nn
   //
   //      %+ %- %* %/ %m         arithmetic (%m is mod): push(pop() op pop())
   //      %& %| %^             bit operations:  push(pop() op pop())
   //      %= %> %<             logical operations:     push(pop() op pop())
   //      %! %~                   unary operations     push(op pop())
   //      %b                 unary BCD conversion
   //      %d                 unary Delta Data conversion
   //
   //      %? expr %t thenpart %e elsepart %;
   //                         if-then-else, %e elsepart is optional.
   //                         else-if's are possible ala Algol 68:
   //                         %? c1 %t %e c2 %t %e c3 %t %e c4 %t %e %;
   //
   // all other characters are ``self-inserting''.  %% gets % output.
 */

static void
tparm(char *outp, char *cp, int p1, int p2)
{
	int c, op, vars[26], stack[10], top, sign;

#define PUSH(i) (stack [++top] = (i))
#define POP()   (stack [top--])

	if (!cp)
		TPARMERR("null arg");
	top = 0;
	while ((c = *cp++))
	{
		if (c != '%')
		{
			*outp++ = c;
			continue;
		}
		op = stack[top];
		if (*cp == '0')
			++cp;
		switch (c = *cp++)
		{
		case 'd':	/* PRINTING CASES */
			if (op < 10)
				goto one;
			if (op < 100)
				goto two;
			/* fall into... */
		case '3':
			  three:
			if (c == '3' && *cp++ != 'd')
				TPARMERR("bad char after %3");
			*outp++ = (op / 100) | '0';
			op %= 100;
			/* fall into... */
		case '2':
			if (op >= 100)
				goto three;
			if (c == '2' && *cp++ != 'd')
				TPARMERR("bad char after %2");
			  two:
			*outp++ = op / 10 | '0';
			  one:
			*outp++ = op % 10 | '0';
			(void) POP();
			continue;
		case 'c':
			*outp++ = op;
			(void) POP();
			break;
		case '%':
			*outp++ = c;
			break;

			/*
			   // %i: shorthand for increment first two parms.
			   // Useful for terminals that start numbering from
			   // one instead of zero (like ANSI terminals).
			 */
		case 'i':
			p1++;
			p2++;
			break;
		case 'p':	/* %pi: push the ith parameter */
			switch (c = *cp++)
			{
			case '1':
				PUSH(p1);
				break;
			case '2':
				PUSH(p2);
				break;
			default:
				TPARMERR("bad parm number");
			}
			break;
		case 'P':	/* %Pi: pop from stack into variable i (a-z) */
			vars[*cp++ - 'a'] = POP();
			break;
		case 'g':	/* %gi: push variable i (a-z) */
			PUSH(vars[*cp++ - 'a']);
			break;
		case '\'':	/* %'c' : character constant */
			PUSH(*cp++);
			if (*cp++ != '\'')
				TPARMERR("missing closing quote");
			break;
		case '{':	/* %{nn} : integer constant. */
			op = 0;
			sign = 1;
			if (*cp == '-')
			{
				sign = -1;
				cp++;
			}
			else if (*cp == '+')
				cp++;
			while ((c = *cp++) >= '0' && c <= '9')
			{
				op = 10 * op + c - '0';
			}
			if (c != '}')
				TPARMERR("missing closing brace");
			PUSH(sign * op);
			break;
			/* binary operators */
		case '+':
			c = POP();
			op = POP();
			PUSH(op + c);
			break;
		case '-':
			c = POP();
			op = POP();
			PUSH(op - c);
			break;
		case '*':
			c = POP();
			op = POP();
			PUSH(op * c);
			break;
		case '/':
			c = POP();
			op = POP();
			PUSH(op / c);
			break;
		case 'm':
			c = POP();
			op = POP();
			PUSH(op % c);
			break;
		case '&':
			c = POP();
			op = POP();
			PUSH(op & c);
			break;
		case '|':
			c = POP();
			op = POP();
			PUSH(op | c);
			break;
		case '^':
			c = POP();
			op = POP();
			PUSH(op ^ c);
			break;
		case '=':
			c = POP();
			op = POP();
			PUSH(op = c);
			break;
		case '>':
			c = POP();
			op = POP();
			PUSH(op > c);
			break;
		case '<':
			c = POP();
			op = POP();
			PUSH(op < c);
			break;
			/* Unary operators. */
		case '!':
			stack[top] = !stack[top];
			break;
		case '~':
			stack[top] = ~stack[top];
			break;
			/* Sorry, no unary minus, because minus is binary. */

			/*
			   If-then-else.  Implemented by a low level hack of
			   skipping forward until the match is found, counting
			   nested if-then-elses.
			 */
		case '?':	/* IF - just a marker */
			break;
		case 't':	/* THEN - branch if false */
			if (!POP())
				cp = branchto(cp, 'e');
			break;
		case 'e':	/* ELSE - branch to ENDIF */
			cp = branchto(cp, ';');
			break;
		case ';':	/* ENDIF - just a marker */
			break;
		default:
			TPARMERR("bad % sequence");
		}
	}
	*outp = 0;
}
