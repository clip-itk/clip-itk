/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

*/
/*
	$Log$
	Revision 1.1  2006/06/22 19:35:31  itk
	uri: init sf.net repository
	
	Revision 1.10  2004/05/21 11:22:19  clip
	rust: minor fix for 'configure -m'
	
	Revision 1.9  2004/03/01 13:01:57  clip
	uri: add some support UTF-8 to screen output

	Revision 1.8  2002/04/09 12:14:04  clip
	screen patches by Przemyslaw Czerpak
	paul

	Revision 1.7  2002/02/01 09:02:15  clip
	pgchars
	paul

	Revision 1.6  2002/01/28 07:31:49  clip
	C/unknown charset cleanup
	paul

	Revision 1.5  2002/01/16 15:29:08  clip
	chinese patch
	preproc bugs
	some pseudographic chars < 32
	paul

*/
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

#include "../clip.h"

#include "charset.h"
#include "screen.h"

extern char *CLIPROOT;

/*
 * Skip spaces and read U+1234 or return -1 for error.
 * Return first non-read position in *p0 (unchanged on error).
 */
static int
getunicode(char **p0)
{
	char *p = *p0;

	while (*p == ' ' || *p == '\t')
		p++;
	if (*p != 'U' || p[1] != '+' || !isxdigit(p[2]) || !isxdigit(p[3]) ||
		!isxdigit(p[4]) || !isxdigit(p[5]) || isxdigit(p[6]))
		return -1;
	*p0 = p + 6;
	return strtol(p + 2, 0, 16);
}

static void
addpair(int fp, unsigned long un, cons_CharsetEntry ** list, int *len)
{
	int pos = *len;

	(*len)++;
	*list = (cons_CharsetEntry *) realloc(*list, (*len) * sizeof(cons_CharsetEntry));
	(*list)[pos].ch = fp;
	(*list)[pos].unich = un;
}

int
load_charset(FILE * mapf, cons_CharsetEntry ** cp, int *lenp)
{
	int r = -1;
	char buffer[1024];
	int i;
	int fp0, fp1;
	long un0, un1;
	char *p, *p1;
	int line = 0;

	if (!mapf)
		goto ret;

	while (fgets(buffer, sizeof(buffer), mapf) != NULL)
	{
		line++;
		if ((p = strchr(buffer, '\n')) != NULL)
			*p = '\0';
		else
			fprintf(stderr, "load_charset: Warning: line %d too long\n", line);

		p = buffer;

/*
 * Syntax accepted:
 *      <fontpos>       <unicode> <unicode> ...
 *      <range>         idem
 *      <range>         <unicode range>
 *
 * where <range> ::= <fontpos>-<fontpos>
 * and <unicode> ::= U+<h><h><h><h>
 * and <h> ::= <hexadecimal digit>
 */

		while (*p == ' ' || *p == '\t')
			p++;
		if (!*p || *p == '#')
			continue;	/* skip comment or blank line */

		fp0 = strtol(p, &p1, 0);
		if (p1 == p)
		{
			fprintf(stderr, "Bad input line: %s\n", buffer);
			goto ret;
		}
		p = p1;

		while (*p == ' ' || *p == '\t')
			p++;
		if (*p == '-')
		{
			p++;
			fp1 = strtol(p, &p1, 0);
			if (p1 == p)
			{
				fprintf(stderr, "Bad input line: %s\n", buffer);
				goto ret;
			}
			p = p1;
		}
		else
			fp1 = 0;

		if (fp0 < 0 || fp0 > 65535)
		{
			continue;
		}
		if (fp1 && (fp1 < fp0 || fp1 > 65535))
		{
			fprintf(stderr, "line %d: Bad end of range (0x%x)\n", line, fp1);
			goto ret;
		}

		if (fp1)
		{
			/* we have a range; expect the word "idem" or a Unicode range of the
			   same length */
			while (*p == ' ' || *p == '\t')
				p++;
			if (!strncmp(p, "idem", 4))
			{
				for (i = fp0; i <= fp1; i++)
					addpair(i, i, cp, lenp);
				p += 4;
			}
			else
			{
				un0 = getunicode(&p);
				while (*p == ' ' || *p == '\t')
					p++;
				if (*p != '-')
				{
					fprintf(stderr,
						"line %d: Corresponding to a range of font positions, "
						"there should be a Unicode range\n", line);
					goto ret;
				}
				p++;
				un1 = getunicode(&p);
				if (un0 < 0 || un1 < 0)
				{
					fprintf(stderr,
						"line %d: Bad Unicode range corresponding to "
						"font position range 0x%x-0x%x\n", line, fp0, fp1);
					goto ret;
				}
				if (un1 - un0 != fp1 - fp0)
				{
					fprintf(stderr,
						"line %d: Unicode range U+%lx-U+%lx not of the same length"
						"as font position range 0x%x-0x%x\n", line, un0, un1, fp0, fp1);
					goto ret;
				}
				for (i = fp0; i <= fp1; i++)
					addpair(i, un0 - fp0 + i, cp, lenp);
			}
		}
		else
		{
			/* no range; expect a list of unicode values
			   for a single font position */

			while ((un0 = getunicode(&p)) >= 0)
				addpair(fp0, un0, cp, lenp);
		}
		while (*p == ' ' || *p == '\t')
			p++;
		if (*p && *p != '#')
			fprintf(stderr, "line %d: trailing junk (%s) ignored\n", line, p);
	}

	r = 0;
	  ret:

	return r;
}

int
make_translation(cons_CharsetEntry * cp1, int len1, cons_CharsetEntry * cp2, int len2, unsigned char buf[256])
{
	int i;

	for (i = 0; i < 256; i++)
		buf[i] = i;

	for (i = 0; i < len1; i++)
	{
		int ch;
		unsigned long unich;
		cons_CharsetEntry *cp;
		int j;

		cp = cp1 + i;

		ch = cp->ch;
		unich = cp->unich;

		if (ch >= 256)
			continue;

		for (j = 0; j < len2; j++)
		{
			cons_CharsetEntry *cpo = cp2 + j;

			if (cpo->unich == unich && cpo->ch < 256)
			{
				buf[ch] = cpo->ch;
				break;
			}
		}

	}

	for (i = 0; i < 32; i++)
		buf[i] = i;

	return 0;
}

int
make_uniTable(cons_CharsetEntry * cp, int len, unsigned long buf[256])
{
	int i;

	for (i = 0; i < 256; i++)
		buf[i] = i < len ? cp[i].unich : (unsigned long) i;

	return 0;
}

int
u32toutf8( char *utf8, unsigned long uc32 )
{
	int n;

	if ( uc32 <  0x00000080L )
	{
		utf8[0] = uc32 & 0xff;
		n = 1;
	}
	else if ( uc32 <  0x00000800L )
	{
		utf8[0] = 0xc0 | ( ( uc32 >> 6 ) & 0x1f );
		utf8[1] = 0x80 | ( uc32 & 0x3f );
		n = 2;
	}
	else if ( uc32 < 0x00010000L )
	{
		utf8[0] = 0xe0 | ( ( uc32 >> 12 ) & 0x0f);
		utf8[1] = 0x80 | ( ( uc32 >> 6 ) & 0x3f);
		utf8[2] = 0x80 | ( uc32 & 0x3f );
		n = 3;
	}
	else if ( uc32 < 0x00200000L )
	{
		utf8[0] = 0xf0 | ( ( uc32 >> 18 ) & 0x07);
		utf8[1] = 0x80 | ( ( uc32 >> 12 ) & 0x3f);
		utf8[2] = 0x80 | ( ( uc32 >> 6 ) & 0x3f);
		utf8[3] = 0x80 | ( uc32 & 0x3f );
		n = 4;
	}
	else if ( uc32 < 0x04000000L )
	{
		utf8[0] = 0xf8 | ( ( uc32 >> 24 ) & 0x03);
		utf8[1] = 0x80 | ( ( uc32 >> 18 ) & 0x3f);
		utf8[2] = 0x80 | ( ( uc32 >> 12 ) & 0x3f);
		utf8[3] = 0x80 | ( ( uc32 >> 6 ) & 0x3f);
		utf8[4] = 0x80 | ( uc32 & 0x3f );
		n = 5;
	}
	else if ( uc32 < 0x80000000L )
	{
		utf8[0] = 0xfc | ( ( uc32 >> 30 ) & 0x01);
		utf8[1] = 0x80 | ( ( uc32 >> 24 ) & 0x3f);
		utf8[2] = 0x80 | ( ( uc32 >> 18 ) & 0x3f);
		utf8[3] = 0x80 | ( ( uc32 >> 12 ) & 0x3f);
		utf8[4] = 0x80 | ( ( uc32 >> 6 ) & 0x3f);
		utf8[5] = 0x80 | ( uc32 & 0x3f );
		n = 6;
	}
	else
	{
		n = 0;
	}
	return n;
}

int
load_charset_name(char *bname, cons_CharsetEntry ** cp, int *lenp)
{
	char path[256];
		char *name, *s;
	FILE *file;
	int r;

		name = strdup(bname);
		for(s=name; *s; s++)
			*s = tolower(*s);

	snprintf(path, sizeof(path), "%s/charsets/%s", CLIPROOT, name);
	file = fopen(path, "r");
	if (!file)
	{
		snprintf(path, sizeof(path), "%s/charsets/%s.uni", CLIPROOT, name);
		file = fopen(path, "r");
	}
	if (!file)
	{
		snprintf(path, sizeof(path), "%s/charsets/%s.sfm", CLIPROOT, name);
		file = fopen(path, "r");
	}

	if (!file)
		return -1;

	r = load_charset(file, cp, lenp);
	fclose(file);
		free(name);
	return r;
}

static int
get_str(FILE * file, char *buf, int bufsize)
{
	char *s;
	int l, i;

	  again:
	s = fgets(buf, bufsize, file);
	if (!s)
		return -1;

	l = strlen(s);
	if (l <= 1 || s[0] == '\n')
		goto again;

	l--;
	buf[l] = 0;

	for (i = 0; i < l; i++)
	{
		switch (buf[i])
		{
		case ' ':
		case '\t':
			continue;
		case '#':
			goto again;
		}
		break;
	}

	if (i)
		memmove(buf, buf + i, l - i + 1);

	return 0;
}

int
load_charset_tables(char *bname, unsigned char *cmptbl, unsigned char *uptbl, unsigned char *lowtbl, unsigned char *alphatbl,
			unsigned char *pgtbl)
{
	char buf[256];
	FILE *file;
	int i;
	int r = 0;
	int val;
		char *name, *s;

		name = strdup(bname);
		for(s=name; *s; s++)
			*s = tolower(*s);

	for(i=0; i<256; i++)
		{
			if (cmptbl)
					cmptbl[i] = i;
			if (uptbl)
					uptbl[i] = toupper(i);
			if (lowtbl)
					lowtbl[i] = tolower(i);
			if (alphatbl)
					alphatbl[i] = isalpha(i);
			if (pgtbl)
					pgtbl[i] = 0;
		}


	snprintf(buf, sizeof(buf), "%s/charsets/%s.tbl", CLIPROOT, name);
	file = fopen(buf, "r");

	if (!file)
		{
			r = -1;
		goto err;
	}


	for (i = 0; i < 256; i++)
	{
		if (get_str(file, buf, sizeof(buf)))
			goto err;
		if (sscanf(buf, "%d", &val) != 1)
			goto err;
		if (cmptbl)
			cmptbl[i] = val;
	}

	for (i = 0; i < 256; i++)
	{
		if (get_str(file, buf, sizeof(buf)))
			goto err;
		if (sscanf(buf, "%d", &val) != 1)
			goto err;
		if (uptbl)
			uptbl[i] = val;
	}

	for (i = 0; i < 256; i++)
	{
		if (get_str(file, buf, sizeof(buf)))
			goto err;
		if (sscanf(buf, "%d", &val) != 1)
			goto err;
		if (lowtbl)
			lowtbl[i] = val;
	}

	for (i = 0; i < 256; i++)
	{
		if (get_str(file, buf, sizeof(buf)))
			goto err;
		if (sscanf(buf, "%d", &val) != 1)
			goto err;
		if (alphatbl)
			alphatbl[i] = val;
	}

	for (i = 0; i < 256; i++)
	{
		if (get_str(file, buf, sizeof(buf)))
			goto err;
		if (sscanf(buf, "%d", &val) != 1)
			goto err;
		if (pgtbl)
			pgtbl[i] = val;
	}


	goto ret;
	  err:
	r = -1;
	  ret:
	if (pgtbl)
	{
		if (!pgtbl[PGCH_HLINE])     pgtbl[PGCH_HLINE] = PG_HLINE;
		if (!pgtbl[PGCH_LLCORNER])  pgtbl[PGCH_LLCORNER] = PG_LLCORNER;
		if (!pgtbl[PGCH_LRCORNER])  pgtbl[PGCH_LRCORNER] = PG_LRCORNER;
		if (!pgtbl[PGCH_TTEE])      pgtbl[PGCH_TTEE] = PG_TTEE;
		if (!pgtbl[PGCH_RTEE])      pgtbl[PGCH_RTEE] = PG_RTEE;
		if (!pgtbl[PGCH_LTEE])      pgtbl[PGCH_LTEE] = PG_LTEE;
		if (!pgtbl[PGCH_BTEE])      pgtbl[PGCH_BTEE] = PG_BTEE;
		if (!pgtbl[PGCH_ULCORNER])  pgtbl[PGCH_ULCORNER] = PG_ULCORNER;
		if (!pgtbl[PGCH_URCORNER])  pgtbl[PGCH_URCORNER] = PG_URCORNER;
		if (!pgtbl[PGCH_VLINE])     pgtbl[PGCH_VLINE] = PG_VLINE;

		if (!pgtbl[PGCH_HLINE2])    pgtbl[PGCH_HLINE2] = PG_HLINE2;
		if (!pgtbl[PGCH_LLCORNER2]) pgtbl[PGCH_LLCORNER2] = PG_LLCORNER2;
		if (!pgtbl[PGCH_LRCORNER2]) pgtbl[PGCH_LRCORNER2] = PG_LRCORNER2;
		if (!pgtbl[PGCH_TTEE2])     pgtbl[PGCH_TTEE2] = PG_TTEE2;
		if (!pgtbl[PGCH_RTEE2])     pgtbl[PGCH_RTEE2] = PG_RTEE2;
		if (!pgtbl[PGCH_LTEE2])     pgtbl[PGCH_LTEE2] = PG_LTEE2;
		if (!pgtbl[PGCH_BTEE2])     pgtbl[PGCH_BTEE2] = PG_BTEE2;
		if (!pgtbl[PGCH_ULCORNER2]) pgtbl[PGCH_ULCORNER2] = PG_ULCORNER2;
		if (!pgtbl[PGCH_URCORNER2]) pgtbl[PGCH_URCORNER2] = PG_URCORNER2;
		if (!pgtbl[PGCH_VLINE2])    pgtbl[PGCH_VLINE2] = PG_VLINE2;

		if (!pgtbl[PGCH_PLUS])      pgtbl[PGCH_PLUS] = PG_PLUS;
		if (!pgtbl[PGCH_PLUS2])     pgtbl[PGCH_PLUS2] = PG_PLUS2;
		if (!pgtbl[PGCH_BLOCK])     pgtbl[PGCH_BLOCK] = PG_BLOCK;

		if (!pgtbl[PGCH_LARROW])    pgtbl[PGCH_LARROW] = PG_LARROW;
		if (!pgtbl[PGCH_RARROW])    pgtbl[PGCH_RARROW] = PG_RARROW;
	}
		if (file)
		fclose(file);
	free(name);
	return r;
}

int
charset_have_pg(cons_CharsetEntry * cs, int len)
{
	int i;

	for (i = 0; i < len; i++, cs++)
	{
		if (cs->ch > 128 && cs->ch < 256 && cs->unich >= 0x2500 && cs->unich <= 0x25FF)
			return 0;
	}

	return 1;
}
