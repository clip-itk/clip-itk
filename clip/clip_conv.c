/*
 $Log$
 Revision 1.1  2006/06/22 19:01:32  itk
 uri: initial

 Revision 1.2  2002/01/24 10:10:04  clip
 add convertion to utf-8
 paul

 Revision 1.1  2002/01/24 08:33:32  clip
 add clip_conv
 paul
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#include "clipcfg.h"
#include "screen/charset.h"

char *CLIPROOT = CLIP_ROOT;

static void
make_utbl(unsigned short *utbl, cons_CharsetEntry * cs, int len)
{
	int i, j;

	for(i=0; i<128; i++)
        	utbl[i] = i;

	for(i=128; i<256; i++)
        {
        	utbl[i] = 0;

		for(j=0; j<len; j++)
                {
                	if (cs[j].ch == i)
                        {
                        	utbl[i] = cs[j].unich;
                                break;
                        }
                }
	}
}

static void
put_utf8(unsigned long wc)
{
	int count, i;
        unsigned char r[6];

	if (wc < 0x80)
		count = 1;
	else if (wc < 0x800)
		count = 2;
	else if (wc < 0x10000)
		count = 3;
	else if (wc < 0x200000)
		count = 4;
	else if (wc < 0x4000000)
		count = 5;
	else if (wc <= 0x7fffffff)
		count = 6;
	else
		return;
	switch (count)
	{			/* note: code falls through cases! */
	case 6:
		r[5] = 0x80 | (wc & 0x3f);
		wc = wc >> 6;
		wc |= 0x4000000;
	case 5:
		r[4] = 0x80 | (wc & 0x3f);
		wc = wc >> 6;
		wc |= 0x200000;
	case 4:
		r[3] = 0x80 | (wc & 0x3f);
		wc = wc >> 6;
		wc |= 0x10000;
	case 3:
		r[2] = 0x80 | (wc & 0x3f);
		wc = wc >> 6;
		wc |= 0x800;
	case 2:
		r[1] = 0x80 | (wc & 0x3f);
		wc = wc >> 6;
		wc |= 0xc0;
	case 1:
		r[0] = wc;
	}

	for(i=0; i<count;i++)
        	putchar(r[i]);
}

static void
put_ucs2(unsigned long wc)
{
	putchar((wc >> 8) & 0xff);
	putchar(wc & 0xff);
}

int
main(int argc, char **argv)
{
	char *p1, *p2;
	cons_CharsetEntry *cs1 = 0, *cs2 = 0;
	int len1 = 0, len2 = 0;
	unsigned char tbl[256];
	int ch;
	char *s;

	s = getenv("CLIPROOT");
	if (s && *s)
		CLIPROOT = s;

	if (argc < 3)
	{
		fprintf(stderr, "usage: %s source_charset target_charset\n", argv[0]);
		return 1;
	}

	p1 = argv[1];
	p2 = argv[2];

	if (load_charset_name(p1, &cs1, &len1))
	{
		fprintf(stderr, "cannot load charset file '%s': %s", p1, strerror(errno));
		return 2;
	}

	if (!strcasecmp(p2, "utf-8"))
	{
		unsigned short *utbl = (unsigned short *) malloc(sizeof(unsigned short) * 256);

		make_utbl(utbl, cs1, len1);
		while ((ch = getchar()) != EOF)
			put_utf8(utbl[ch & 0xff]);

		return 0;
	}

	if (!strcasecmp(p2, "ucs-2"))
	{
		unsigned short *utbl = (unsigned short *) malloc(sizeof(unsigned short) * 256);

		make_utbl(utbl, cs1, len1);
		while ((ch = getchar()) != EOF)
			put_ucs2(utbl[ch & 0xff]);

		return 0;
	}

	if (load_charset_name(p2, &cs2, &len2))
	{
		fprintf(stderr, "cannot load charset file '%s': %s", p2, strerror(errno));
		return 3;
	}

	make_translation(cs1, len1, cs2, len2, tbl);

	while ((ch = getchar()) != EOF)
	{
		putchar(tbl[ch & 0xff]);
	}

	return 0;
}
