/*
   gen-tbl: uptbl, lowtbl, cmptbl, alphatbl, pgcharstbl generator
   Generate all tables from charset->unicode mapping and
   standard unicode data.
   Copyleft Paul Lasarev <paul@itk.ru>, 2000
 */

/*
	$Log: gen_tbl.c,v $
	Revision 1.1  2002/01/16 15:29:08  clip
	chinese patch
	preproc bugs
	some pseudographic chars < 32
	paul
	
	Revision 1.8  2001/06/06 12:00:00  clip
	bug in gen_tbl.c. Tnanks to "Marek Paliwoda" <mpaliwoda@nsw.com.pl> for bugreport!
	paul

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "screen/charset.h"
#include "coll.h"
#include "screen/screen.h"

/*#define DBG*/
/*#define DBG1*/
/*#define DBG3*/

char *CLIPROOT = ".";

typedef struct
{
	char *mem;
	unsigned long no;
	unsigned char ch;
	cons_CharsetEntry *cp;

	char *hex;
	char *name;
	char *cat;
	char *comb;
	char *bidir;
	char *decomp;
	char *dec;
	char *dig;
	char *num;
	char *mirror;
	char *name1;
	char *comment;
	char *upper;
	char *lower;
	char *title;
}
UniRecord;

/* shorten names */
#define PG_H 	PG_HLINE
#define PG_UR 	PG_LLCORNER
#define PG_UL 	PG_LRCORNER
#define PG_HD 	PG_TTEE
#define PG_VL 	PG_RTEE
#define PG_VR 	PG_LTEE
#define PG_HU 	PG_BTEE
#define PG_DR 	PG_ULCORNER
#define PG_DL 	PG_URCORNER
#define PG_V 	PG_VLINE

#define PG_H2 	PG_HLINE2
#define PG_UR2 	PG_LLCORNER2
#define PG_UL2 	PG_LRCORNER2
#define PG_HD2 	PG_TTEE2
#define PG_VL2 	PG_RTEE2
#define PG_VR2 	PG_LTEE2
#define PG_HU2 	PG_BTEE2
#define PG_DR2 	PG_ULCORNER2
#define PG_DL2 	PG_URCORNER2
#define PG_V2	PG_VLINE2

#define PG_HV	PG_PLUS
#define PG_HV2	PG_PLUS2
#define PG_B	PG_BLOCK

#define PG_DP PG_DARROW
#define PG_LP PG_LARROW
#define PG_RP PG_RARROW
#define PG_UP PG_UARROW

/* unicode BOX DRAWING  (U+2500 -:- U+25FF ) to PG_CHARS mapping */
static unsigned char pg_chars[256] = {
/* U+2500 */ PG_H, PG_H, PG_V, PG_V, PG_H2, PG_H2, PG_V2, PG_V2,
/* U+2508 */ PG_H2, PG_H2, PG_V2, PG_V2, PG_DR, PG_DR, PG_DR, PG_DR2,
/* U+2510 */ PG_DL, PG_DL, PG_DL, PG_DL2, PG_UR, PG_UR, PG_UR, PG_UR2,
/* U+2518 */ PG_UL, PG_UL, PG_UL, PG_UL2, PG_VR, PG_VR, PG_VR, PG_VR2,
/* U+2520 */ PG_VR, PG_VR, PG_VR, PG_VR2, PG_VL, PG_VL, PG_VL, PG_VL,
/* U+2528 */ PG_VL, PG_VL, PG_VL, PG_VL2, PG_HD, PG_HD, PG_HD, PG_HD,
/* U+2530 */ PG_HD, PG_HD, PG_HD, PG_HD2, PG_HU, PG_HU, PG_HU, PG_HU,
/* U+2538 */ PG_HU, PG_HU, PG_HU, PG_HU2, PG_HV, PG_HV, PG_HV, PG_HV,
/* U+2540 */ PG_HV, PG_HV, PG_HV, PG_HV, PG_HV, PG_HV, PG_HV, PG_HV,
/* U+2548 */ PG_HV, PG_HV, PG_HV, PG_HV2, PG_H2, PG_H2, PG_V2, PG_V2,
/* U+2550 */ PG_H2, PG_V2, PG_DR, PG_DR, PG_DR2, PG_DL, PG_DL, PG_DL2,
/* U+2558 */ PG_UR, PG_UR, PG_UR2, PG_UL, PG_UL, PG_UL2, PG_VR, PG_VR,
/* U+2560 */ PG_VR2, PG_VL, PG_VL, PG_VL2, PG_HD, PG_HD, PG_HD2, PG_HU,
/* U+2568 */ PG_HU, PG_HU2, PG_HV, PG_HV, PG_HV2, PG_DR, PG_DL, PG_UL,
/* U+2570 */ PG_UR, PG_HV, PG_HV, PG_HV, PG_H, PG_V, PG_H, PG_V,
/* U+2578 */ PG_H2, PG_V2, PG_H2, PG_V2, PG_H, PG_V, PG_H, PG_V,
/* U+2580 */ PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B,
/* U+2588 */ PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B,
/* U+2590 */ PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B,
/* U+2598 */ PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B,
/* U+25a0 */ PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B,
/* U+25a8 */ PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B,
/* U+25b0 */ PG_B, PG_B, PG_UP, PG_UP, PG_UP, PG_UP, PG_RP, PG_RP,
/* U+25b8 */ PG_RP, PG_RP, PG_RP, PG_RP, PG_DP, PG_DP, PG_DP, PG_DP,
/* U+25c0 */ PG_LP, PG_LP, PG_LP, PG_LP, PG_LP, PG_LP, PG_DIAMOND, PG_DIAMOND,
/* U+25c8 */ PG_DIAMOND, 0, 0, 0, 0, 0, 0, 0,
/* U+25d0 */ 0, 0, 0, 0, 0, 0, 0, 0,
/* U+25d8 */ 0, 0, 0, 0, 0, 0, 0, 0,
/* U+25e0 */ 0, 0, 0, 0, 0, 0, 0, PG_B,
/* U+25e8 */ PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B, PG_B,
/* U+25f0 */ 0, 0, 0, 0, 0, 0, 0, 0,
/* U+25f8 */ 0, 0, 0, 0, 0, 0, 0, 0,
};

static int
cmp_UniRecord(void *p1, void *p2)
{
	unsigned long l1, l2;

	l1 = ((UniRecord *) p1)->no;
	l2 = ((UniRecord *) p2)->no;

	if (l1 < l2)
		return -1;
	else if (l1 > l2)
		return 1;
	else
		return 0;
}

static int
cmp_CSRecord(void *p1, void *p2)
{
	unsigned char l1, l2;

	l1 = ((UniRecord *) p1)->cp->ch;
	l2 = ((UniRecord *) p2)->cp->ch;

	if (l1 < l2)
		return -1;
	else if (l1 > l2)
		return 1;
	else
		return 0;
}

static cons_CharsetEntry *
in_map(cons_CharsetEntry * cp, int len, unsigned long no)
{
	int i, ch;

	for (i = len - 1; i >= 0; i--)
	{
		if (no == cp[i].unich)
		{
			int found = i;

			ch = cp[i].ch;

			for (i++; i < len; i++)
				if (cp[i].ch == ch)
					return 0;

			return cp + found;
		}
	}
	return 0;
}

static UniRecord *
find_uni(Coll * uni, unsigned long unich)
{
	int ind;
	UniRecord u;

	u.no = unich;

	if (search_Coll(uni, &u, &ind))
		return (UniRecord *) uni->items[ind];
	else
		return 0;
}

static UniRecord *
find_ch(Coll * cs, unsigned char ch)
{
	int ind;
	UniRecord u;
	cons_CharsetEntry ce;

	u.cp = &ce;
	ce.ch = ch;

	if (search_Coll(cs, &u, &ind))
		return (UniRecord *) cs->items[ind];
	else
		return 0;
}

static int
find_cmp(Coll * cp, int ch)
{
	int i;

	for (i = 0; i < cp->count; i++)
	{
		UniRecord *rp = (UniRecord *) cp->items[i];

		if (rp->cp->ch == ch)
			return i;
	}
	return 0;
}

static int
remove_char(Coll * cp, unsigned char ch)
{
	int i;

	for (i = 0; i < cp->count; i++)
	{
		UniRecord *rp = (UniRecord *) cp->items[i];

		if (rp->cp->ch == ch)
		{
			atRemove_Coll(cp, i);
			return 1;
		}
	}
	return 0;
}

int
main(int argc, char **argv)
{
	FILE *file;
	cons_CharsetEntry *cp = 0;
	int len = 0, i, mb = 0;
	char buf[4096];
	UniRecord *rp;

	/* unicode-order */
	Coll uni;

	/* charset-order */
	Coll cs;
	Coll out;
	Coll cmp;
	char *fname;

	if (argc < 2)
	{
		fprintf(stderr, "usage: %s charset_file [cs_file1...] < unicode_data\n", argv[0]);
		exit(1);
	}

	for (i = 1; i < argc; i++)
	{
		fname = argv[i];
		file = fopen(fname, "r");
		if (!file)
		{
			fprintf(stderr, "cannot open %s: %s\n", fname, strerror(errno));
			exit(2);
		}

		fprintf(stderr, "load charset '%s'\n", fname);
		if (load_charset(file, &cp, &len))
		{
			fprintf(stderr, "cannot read %s: %s\n", fname, strerror(errno));
			exit(3);
		}
		fprintf(stderr, "loaded %d entries\n", len);
		fclose(file);
#ifdef DBG
		fprintf(stderr, "readed %d charset entries\n", len);
#endif
	}

	init_Coll(&uni, 0, cmp_UniRecord);
	init_Coll(&cs, 0, cmp_CSRecord);
	init_Coll(&out, 0, 0);
	init_Coll(&cmp, 0, cmp_UniRecord);

	while (fgets(buf, sizeof(buf), stdin))
	{
		int l;
		char *s;

		rp = (UniRecord *) calloc(1, sizeof(*rp));
		l = strlen(buf);
		if (l > 0 && buf[--l] == '\n')
			buf[l] = 0;
		if (!l)
			break;

		s = strdup(buf);
		rp->mem = s;

		rp->hex = s;
		rp->no = strtoul(s, 0, 16);
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->name = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->cat = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->comb = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->bidir = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->decomp = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->dec = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->dig = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->num = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->mirror = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->name1 = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->comment = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->upper = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->lower = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->title = s;
		l = strcspn(s, ";");
		s += l;
		*s++ = 0;

		rp->cp = in_map(cp, len, rp->no);
		if (rp->cp)
		{
			remove_char(&uni, rp->cp->ch);
			remove_char(&cs, rp->cp->ch);
			insert_Coll(&uni, rp);
			insert_Coll(&cs, rp);
		}
		else
		{
			free(rp->mem);
			free(rp);
		}
	}
	fprintf(stderr, "appended %d uni %d chars\n", uni.count, cs.count);

#ifdef DBG
	fprintf(stderr, "uni: %d\n", uni.count);
	for (i = 0; i < uni.count; i++)
	{
		rp = (UniRecord *) uni.items[i];
		fprintf(stderr, "hex; 	'%s'\n", rp->hex);
		fprintf(stderr, "name;   '%s'\n", rp->name);
		fprintf(stderr, "cat;    '%s'\n", rp->cat);
		fprintf(stderr, "comb;   '%s'\n", rp->comb);
		fprintf(stderr, "bidir;  '%s'\n", rp->bidir);
		fprintf(stderr, "decomp; '%s'\n", rp->decomp);
		fprintf(stderr, "dec;    '%s'\n", rp->dec);
		fprintf(stderr, "dig;    '%s'\n", rp->dig);
		fprintf(stderr, "num;    '%s'\n", rp->num);
		fprintf(stderr, "mirror; '%s'\n", rp->mirror);
		fprintf(stderr, "name1;  '%s'\n", rp->name1);
		fprintf(stderr, "comment;'%s'\n", rp->comment);
		fprintf(stderr, "upper;  '%s'\n", rp->upper);
		fprintf(stderr, "lower;  '%s'\n", rp->lower);
		fprintf(stderr, "title;  '%s'\n", rp->title);
		fprintf(stderr, "\n");
	}
#endif
#ifdef DBG1
	fprintf(stderr, "cs: %d\n", cs.count);
	for (i = 0; i < cs.count; i++)
	{
		rp = (UniRecord *) cs.items[i];
		fprintf(stderr, "ch=%d\n", rp->cp->ch);
		fprintf(stderr, "hex; 	'%s'\n", rp->hex);
		fprintf(stderr, "name;   '%s'\n", rp->name);
		fprintf(stderr, "cat;    '%s'\n", rp->cat);
		fprintf(stderr, "comb;   '%s'\n", rp->comb);
		fprintf(stderr, "bidir;  '%s'\n", rp->bidir);
		fprintf(stderr, "decomp; '%s'\n", rp->decomp);
		fprintf(stderr, "dec;    '%s'\n", rp->dec);
		fprintf(stderr, "dig;    '%s'\n", rp->dig);
		fprintf(stderr, "num;    '%s'\n", rp->num);
		fprintf(stderr, "mirror; '%s'\n", rp->mirror);
		fprintf(stderr, "name1;  '%s'\n", rp->name1);
		fprintf(stderr, "comment;'%s'\n", rp->comment);
		fprintf(stderr, "upper;  '%s'\n", rp->upper);
		fprintf(stderr, "lower;  '%s'\n", rp->lower);
		fprintf(stderr, "title;  '%s'\n", rp->title);
		fprintf(stderr, "\n");
	}
#endif

	for (i = 0; i < 256; i++)
	{
		UniRecord *rp = find_ch(&cs, i);

		if (!rp)
		{
			cons_CharsetEntry *cp = (cons_CharsetEntry *) calloc(sizeof(cons_CharsetEntry *), 1);

			rp = (UniRecord *) calloc(sizeof(UniRecord), 1);
			rp->no = i;
			rp->ch = i;
			cp->ch = i;
			cp->unich = i;
			rp->cp = cp;
			rp->hex = "";
			rp->name = "";
			rp->cat = "";
			rp->comb = "";
			rp->bidir = "";
			rp->decomp = "";
			rp->dec = "";
			rp->dig = "";
			rp->num = "";
			rp->mirror = "";
			rp->name1 = "";
			rp->comment = "";
			rp->upper = "";
			rp->lower = "";
			rp->title = "";
		}
		if (rp->cp->ch < 256)
		{
			append_Coll(&out, rp);
			insert_Coll(&cmp, rp);
		}
	}

#ifdef DBG3
	fprintf(stderr, "cmp: %d\n", cmp.count);
	for (i = 0; i < cmp.count; i++)
	{
		rp = (UniRecord *) cmp.items[i];
		fprintf(stderr, "ch=%d\n", rp->cp->ch);
		fprintf(stderr, "hex; 	'%s'\n", rp->hex);
		fprintf(stderr, "name;   '%s'\n", rp->name);
		fprintf(stderr, "cat;    '%s'\n", rp->cat);
		fprintf(stderr, "comb;   '%s'\n", rp->comb);
		fprintf(stderr, "bidir;  '%s'\n", rp->bidir);
		fprintf(stderr, "decomp; '%s'\n", rp->decomp);
		fprintf(stderr, "dec;    '%s'\n", rp->dec);
		fprintf(stderr, "dig;    '%s'\n", rp->dig);
		fprintf(stderr, "num;    '%s'\n", rp->num);
		fprintf(stderr, "mirror; '%s'\n", rp->mirror);
		fprintf(stderr, "name1;  '%s'\n", rp->name1);
		fprintf(stderr, "comment;'%s'\n", rp->comment);
		fprintf(stderr, "upper;  '%s'\n", rp->upper);
		fprintf(stderr, "lower;  '%s'\n", rp->lower);
		fprintf(stderr, "title;  '%s'\n", rp->title);
		fprintf(stderr, "\n");
	}
#endif

	printf("# generated by gen_tbl from sources");
	for (i = 1; i < argc; i++)
		printf(" %s", argv[i]);
	printf("\n# cmptbl\n");
	for (i = 0; i < 256; i++)
	{
		int ch;

		ch = find_cmp(&cmp, i);
		printf("%d\n", ch);
	}
	printf("# uptbl\n");
	for (i = 0; i < out.count; i++)
	{
		UniRecord *rp1;
		int ch;

		rp = (UniRecord *) out.items[i];
		if (!rp)
		{
			printf("%d\n", i);
			continue;
		}
		if (!strcasecmp(rp->cat, "Ll") && rp->upper)
		{
			unsigned long unich = strtoul(rp->upper, 0, 16);

			rp1 = find_uni(&uni, unich);
			if (rp1)
				ch = rp1->cp->ch;
			else
				ch = rp->cp->ch;
		}
		else
			ch = rp->cp->ch;

		printf("%d\n", ch);
	}

	printf("# lowtbl\n");
	for (i = 0; i < out.count; i++)
	{
		UniRecord *rp1;
		int ch;

		rp = (UniRecord *) out.items[i];
		if (!rp)
		{
			printf("%d\n", i);
			continue;
		}
		if (!strcasecmp(rp->cat, "Lu") && rp->lower)
		{
			unsigned long unich = strtoul(rp->lower, 0, 16);

			rp1 = find_uni(&uni, unich);
			if (rp1)
				ch = rp1->cp->ch;
			else
				ch = rp->cp->ch;
		}
		else
			ch = rp->cp->ch;

		printf("%d\n", ch);
	}

	printf("# isalpha\n");
	for (i = 0; i < out.count; i++)
	{
		int r = 0;
		char *s;

		rp = (UniRecord *) out.items[i];
		if (!rp)
		{
			printf("0\n");
			continue;
		}
		s = rp->cat;
		if (s && s[0] == 'L')
			r = 1;
		printf("%d\n", r);
	}

	printf("# pgtbl\n");
	for (i = 0; i < out.count; i++)
	{
		int r = 0;
		char *s;

		rp = (UniRecord *) out.items[i];
		if (!rp)
		{
			printf("0\n");
			continue;
		}
		s = rp->cat;
		if (!strcmp(s, "So") && rp->no >= 0x2500 && rp->no < 0x25ff)
			r = pg_chars[rp->no - 0x2500];
		printf("%d\n", r);
	}

	printf("# multibyte\n%d\n", mb ? 1 : 0);

	return 0;
}
