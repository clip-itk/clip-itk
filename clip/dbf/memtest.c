/*
$Log: memtest.c,v $
Revision 1.2  1999/10/26 19:19:15  axl
start cvs logging (./dbf)

*/


#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>

#include "dbf.h"

static void
printDbfData(char *name, DbfData * dp)
{
	printf("%s: %c: %d.%d: ", name, dp->type, dp->len, dp->dec);
	switch (dp->type)
	{
	case 'C':
		printf("len=%d, str='%*s'", dp->u.c.len, dp->u.c.len, dp->u.c.str);
		break;
	case 'L':
		printf("value=%d", dp->u.l);
		break;
	case 'N':
		printf("value=%*.*f", dp->len, dp->dec, dp->u.n);
		break;
	case 'D':
		{
			int yy = 0, mm = 0, dd = 0, ww = 0;

			dbf_cdate(dp->u.d, &dd, &mm, &yy, &ww);
			printf("julian=%ld (%d/%d/%d,%d)", dp->u.d, yy, mm, dd, ww);
		}
		break;
	}
	printf("\n");
}

int
main(int argc, char **argv)
{
	char errbuf[128];
	int r;

	if (argc < 2 || (argc > 2 && ((argc - 2) % 3) != 0))
	{
		printf("usage: %s mem_filename [name1 type1 value1] [name2 type2 value2]...\n",
		       argv[0]);
		exit(1);
	}

	if (argc == 2)
	{
		/* read test */
		DbfData *data = 0;
		char **names = 0;
		int dnum = 0, i;

		r = read_MemFile(argv[1], 0, &data, &names, &dnum, errbuf, sizeof(errbuf));
		if (r)
		{
			printf("error: %s\n", errbuf);
			exit(2);
		}

		printf("successfully read %d vars:\n", dnum);
		for (i = 0; i < dnum; ++i)
			printDbfData(names[i], data + i);
	}
	else
	{
		DbfData *data;
		char **names;
		int dnum, i;

		dnum = (argc - 2) / 3;
		data = (DbfData *) calloc(dnum, sizeof(DbfData));
		names = (char **) calloc(dnum, sizeof(char *));

		for (i = 0; i < dnum; ++i)
		{
			char *name, *type, *value;
			DbfData *dp;

			name = argv[i * 3 + 2];
			type = argv[i * 3 + 3];
			value = argv[i * 3 + 4];
			dp = data + i;

			names[i] = name;
			dp->type = toupper(*type);

			switch (dp->type)
			{
			case 'C':
				dp->u.c.str = value;
				dp->u.c.len = strlen(value);
				break;
			case 'L':
				dp->u.l = atoi(value);
				break;
			case 'N':
				{
					char *s;
					int l, d = 0;

					l = strlen(value);
					s = strchr(value, '.');
					if (s)
					{
						--l;
						d = l - (s - value);
					}

					dp->u.n = strtod(value, NULL);
					dp->len = l;
					dp->dec = d;
				}
				break;
			case 'D':
				{
					int dd = 0, mm = 0, yy = 0, l;
					char buf[5];

					l = strlen(value);
					strncpy(buf, value, 4);
					buf[4] = 0;
					yy = atoi(buf);

					if (l > 4)
					{
						strncpy(buf, value + 4, 2);
						buf[2] = 0;
						mm = atoi(buf);
					}

					if (l > 6)
					{
						strncpy(buf, value + 6, 2);
						buf[2] = 0;
						dd = atoi(buf);
					}

					dp->u.l = dbf_jdate(dd, mm, yy);
				}
				break;
			default:
				printf("invalid type '%s' (var '%s')\n", type, name);
				exit(1);
			}
		}

		r = write_MemFile(argv[1], 0, data, names, dnum, errbuf, sizeof(errbuf));
		if (r)
		{
			printf("error: %s\n", errbuf);
			exit(2);
		}
		printf("successfully wrote %d vars\n", dnum);
	}

	return 0;
}
