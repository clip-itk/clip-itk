#ifndef CHARSET_H
#define CHARSET_H

/* standalone */
typedef struct
{
	unsigned short ch;
	unsigned short unich;
}
cons_CharsetEntry;

int load_charset(FILE *file, cons_CharsetEntry ** cp, int *lenp);
int make_translation(cons_CharsetEntry *cp1, int len1, cons_CharsetEntry *cp2, int len2,
			unsigned char buf[256]);
int load_charset_name(char *name,  cons_CharsetEntry ** cp, int *lenp);
int load_charset_tables(char *name
		, unsigned char *cmptbl
		, unsigned char *uptbl
		, unsigned char *lowtbl
		, unsigned char *alphatbl
		, unsigned char *pgtbl
		);

int charset_have_pg(cons_CharsetEntry *cs, int len);
	/* return 0 if have pg_chars */

#endif
