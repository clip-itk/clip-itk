#include <stdio.h>
#include "charset.h"

char *CLIPROOT=".";

int
main(int argc, char **argv)
{

	if (argc < 2)
	{
		printf("usage:\n");
		printf("%s charmap    - print charmap\n", argv[0]);
		printf("%s charmap1 charmap2    - print translation from charmap1 into charmap2\n", argv[0]);
		return 1;
	}

	if (argc < 3)
	{
		cons_CharsetEntry *cs = 0;
		int len = 0, r, i;
                FILE *file = fopen(argv[1], "r");
                if (!file)
                	return 2;

		r = load_charset(file, &cs, &len);

		if (r)
			return r;

		for (i = 0; i < len; i++)
		{
			printf("%-3d: 0x%X <--> 0x%lX\n", i, cs[i].ch, cs[i].unich);
		}

		return 0;
	}
	else
	{
		cons_CharsetEntry *cs1 = 0, *cs2 = 0;
		int len1 = 0, len2 = 0, r, i;
		unsigned char buf[128];
                FILE *file = fopen(argv[1], "r");
                if (!file)
                	return 2;

		r = load_charset(file, &cs1, &len1);
		if (r)
			return r;
		fclose(file);
                file = fopen(argv[2], "r");
                if (!file)
                	return 2;
		r = load_charset(file, &cs2, &len2);
		if (r)
			return r;

		fclose(file);
		r = make_translation(cs1, len1, cs2, len2, buf);

		for (i = 0; i < 128; i++)
			printf("0x%X --> 0x%X\n", i + 128, buf[i]);
	}

	return 0;
}
