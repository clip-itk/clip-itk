/*
   $Log: glob.c,v $
   Revision 1.3  2000/05/24 18:34:28  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.2  1999/10/26 19:11:30  paul
   start cvs logging

 */

#include <stdlib.h>
#include <string.h>

int glob_match2(char *string, char *pattern);
int glob_match(char *string, char *pattern, int *offset);

#define FALSE 0
#define TRUE 1

/* The following functions implement glob-style string matching */
/* glob_match allow's implements the unanchored front (or conversely */
/* the '^') feature.  glob_match2 does the rest of the work. */
/* offset from beginning of string where pattern matches */
/* returns # of chars that matched */

int
glob_match(char *string, char *pattern, int *offset)
{
	char *s;
	int sm;			/* count of chars matched or -1 */
	int caret = FALSE;
	int star = FALSE;

	*offset = 0;

	if (pattern[0] == '^')
	{
		caret = TRUE;
		pattern++;
	}
	else if (pattern[0] == '*')
	{
		star = TRUE;
	}

	/*
	 * test if pattern matches in initial position.
	 * This handles front-anchor and 1st iteration of non-front-anchor.
	 * Note that 1st iteration must be tried even if string is empty.
	 */

	sm = glob_match2(string, pattern);
	if (sm >= 0)
		return (sm);

	if (caret)
		return -1;
	if (star)
		return -1;

	if (*string == '\0')
		return -1;

	for (s = string + 1; *s; s++)
	{
		sm = glob_match2(s, pattern);
		if (sm != -1)
		{
			*offset = s - string;
			return (sm);
		}
	}
	return -1;
}

/* glob_match2 --

   Like Tcl_StringMatch except that
   1) returns number of characters matched, -1 if failed.
   (Can return 0 on patterns like "" or "$")
   2) does not require pattern to match to end of string
   3) much of code is stolen from Tcl_StringMatch
   4) front-anchor is assumed (Tcl_StringMatch retries for non-front-anchor)
 */

int
glob_match2(char *string, char *pattern)
{
	char c2;
	int match = 0;		/* # of chars matched */

	while (1)
	{
		/* If at end of pattern, success! */
		if (*pattern == 0)
		{
			return match;
		}

		/* If last pattern character is '$', verify that entire
		 * string has been matched.
		 */
		if ((*pattern == '$') && (pattern[1] == 0))
		{
			if (*string == 0)
				return (match);
			else
				return (-1);
		}

		/* Check for a "*" as the next pattern character.  It matches
		 * any substring.  We handle this by calling ourselves
		 * recursively for each postfix of string, until either we
		 * match or we reach the end of the string.
		 */

		if (*pattern == '*')
		{

			int head_len;
			char *tail;

			pattern += 1;
			if (*pattern == 0)
			{
				return (strlen(string) + match);	/* DEL */
			}

			/* find longest match - switched to this on 12/31/93 */
			head_len = strlen(string);	/* length before tail */
			tail = string + head_len;
			/*printf("pattern='%s' tail='%s'\n", pattern, tail); */
			while (head_len >= 0)
			{
				int rc;

				if (-1 != (rc = glob_match2(tail, pattern)))
				{
					/*printf("rc=%d match=%d head_len=%d tail='%s' str='%s' patt='%s'\n", rc, match, head_len, tail,
					   sstr, patt); */
					return rc + match + head_len;	/* DEL */
				}
				tail--;
				head_len--;
			}

			return -1;	/* DEL */
		}

		/*
		 * after this point, all patterns must match at least one
		 * character, so check this
		 */

		if (*string == 0)
			return -1;

		/* Check for a "?" as the next pattern character.  It matches
		 * any single character.
		 */

		if (*pattern == '?')
		{
			goto thisCharOK;
		}

		/* Check for a "[" as the next pattern character.  It is followed
		 * by a list of characters that are acceptable, or by a range
		 * (two characters separated by "-").
		 */

		if (*pattern == '[')
		{
			pattern += 1;
			while (1)
			{
				if ((*pattern == ']') || (*pattern == 0))
				{
					return -1;	/* was 0; DEL */
				}
				if (*pattern == *string)
				{
					break;
				}
				if (pattern[1] == '-')
				{
					c2 = pattern[2];
					if (c2 == 0)
					{
						return -1;	/* DEL */
					}
					if ((*pattern <= *string) && (c2 >= *string))
					{
						break;
					}
					if ((*pattern >= *string) && (c2 <= *string))
					{
						break;
					}
					pattern += 2;
				}
				pattern += 1;
			}

/* OOPS! Found a bug in vanilla Tcl - have sent back to Ousterhout */
/* but he hasn't integrated it yet. - DEL */

#if 0
			while ((*pattern != ']') && (*pattern != 0))
			{
#else
			while (*pattern != ']')
			{
				if (*pattern == 0)
				{
					pattern--;
					break;
				}
#endif
				pattern += 1;
			}
			goto thisCharOK;
		}

		/* If the next pattern character is backslash, strip it off
		 * so we do exact matching on the character that follows.
		 */

		if (*pattern == '%')
		{
			pattern += 1;
			if (*pattern == 0)
			{
				return -1;
			}
			switch (*pattern)
			{
			case 'r':
				if (*string != '\r')
					return -1;
				break;
			case 'n':
				if (*string != '\n')
					return -1;
				break;
			case 's':
				if (*string != ' ')
					return -1;
				break;
			case 'e':
				if (*string != '\033')
					return -1;
				break;
			default:
				if (*string != *pattern)
					return -1;
				break;
			}
		}
		else if (*pattern != *string)
		{
			return -1;
		}

	      thisCharOK:pattern += 1;
		string += 1;
		match++;
	}
}
