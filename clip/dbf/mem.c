/*
$Log: mem.c,v $
Revision 1.2  1999/10/26 19:19:14  axl
start cvs logging (./dbf)

*/

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>

#include "dbf.h"

typedef struct
{
	unsigned char name[11];
	unsigned char type;
	unsigned char reserved1[4];
	unsigned char len;
	unsigned char dec;
	unsigned char reserved2[14];
}
MemHeader;

static int
mem_error(char *errbuf, int errbuflen, int line, const char *fmt,...)
{
	int l;
	va_list ap;

	va_start(ap, fmt);
	snprintf(errbuf, errbuflen, "MEM: %s, line %d: ", __FILE__, line);
	l = strlen(errbuf);
	vsnprintf(errbuf + l, errbuflen - l, fmt, ap);
	va_end(ap);
	return 1;
}

int
read_MemFile(const char *path, DbfLocale * tbl,
	     DbfData ** resp, char ***names, int *rescount,
	     char *errbuf, int errbuflen)
{
	int r = 0, i, line;
	FILE *file;
	MemHeader mh;
	DbfData *dp;

	file = fopen(path, "rb");
	if (!file)
		return mem_error(errbuf, errbuflen, __LINE__,
				 "cannot open file '%s': %s",
				 path, strerror(errno));

	for (i = 0;; ++i)
	{
		if (fread(&mh, sizeof(mh), 1, file) != 1)
		{
			if (feof(file))
				break;
			line = __LINE__;
		      readerr:
			r = mem_error(errbuf, errbuflen, line,
				      "file '%s' read error: %s", strerror(errno));
			goto ret;
		}

		*resp = (DbfData *) realloc(*resp, ((*rescount) + 1) * sizeof(DbfData));
		*names = (char **) realloc(*names, ((*rescount) + 1) * sizeof(char *));

		dp = (*resp) + (*rescount);
		memset(dp, 0, sizeof(DbfData));
		(*names)[*rescount] = strdup(mh.name);
		++(*rescount);

		switch (mh.type)
		{
		case 0xC3:	/* string */
			{
				char *sp;
				int len;

				len = mh.len | (mh.dec << 8);

				sp = (char *) malloc(len);
				if (fread(sp, len, 1, file) != 1)
				{
					line = __LINE__;
					free(sp);
					goto readerr;
				}

				dp->type = 'C';
				dp->len = mh.len;
				dp->dec = mh.dec;
				dp->flags = 0;
				dp->u.c.str = sp;
				dp->u.c.len = --len;

				while (len)
				{
					int s = *(unsigned char *) sp;

					if (tbl && s > 127)
						*sp = tbl->read[s - 128];
					--len;
					++sp;
				}
			}
			break;
		case 0xCC:	/* logic */
			{
				char ch;

				if (fread(&ch, 1, 1, file) != 1)
				{
					line = __LINE__;
					goto readerr;
				}
				dp->type = 'L';
				dp->len = mh.len;
				dp->dec = mh.dec;
				dp->flags = 0;
				dp->u.l = ch;
			}
			break;
		case 0xCE:	/* numeric */
			{
				double d = 0;
				unsigned char buf[8];
				int j;

				if (fread(buf, 8, 1, file) != 1)
				{
					line = __LINE__;
					goto readerr;
				}
				for (j = 0; j < 8; ++j)
					((unsigned char *) &d)[j] = buf[j];

				dp->type = 'N';
				dp->len = mh.len;
				dp->dec = mh.dec;
				dp->flags = 0;
				dp->u.n = d;
			}
			break;
		case 0xC4:	/* date */
			{
				double d = 0;
				unsigned char buf[8];
				int j;

				if (fread(buf, 8, 1, file) != 1)
				{
					line = __LINE__;
					goto readerr;
				}
				for (j = 0; j < 8; ++j)
					((unsigned char *) &d)[j] = buf[j];

				dp->type = 'D';
				dp->len = mh.len;
				dp->dec = mh.dec;
				dp->flags = 0;
				dp->u.d = d;
			}
			break;

		default:
			r = mem_error(errbuf, errbuflen, __LINE__,
				      "invalid mem field type : 0x%0x", mh.type);
			goto ret;
		}

	}

      ret:
	fclose(file);

	return r;
}

int
write_MemFile(const char *path, DbfLocale * tbl,
	      DbfData * arr, char **names, int acount,
	      char *errbuf, int errbuflen)
{
	int r = 0, i, line;
	FILE *file;
	MemHeader mh;
	DbfData *dp;

	file = fopen(path, "wb");
	if (!file)
		return mem_error(errbuf, errbuflen, __LINE__,
				 "cannot open file '%s': %s",
				 path, strerror(errno));

	for (i = 0; i < acount; ++i)
	{
		dp = arr + i;

		memset(&mh, 0, sizeof(mh));
		strncpy(mh.name, names[i], 10);

		switch (dp->type)
		{
		case 'C':
			{
				int len;

				len = dp->u.c.len + 1;
				mh.type = 0xC3;
				mh.len = len & 0xff;
				mh.dec = (len >> 8) & 0xff;
			}
			break;
		case 'L':
			mh.type = 0xCC;
			mh.len = 1;
			break;
		case 'N':
			mh.type = 0xCE;
			mh.len = dp->len;
			mh.dec = dp->dec;
			break;
		case 'D':
			mh.type = 0xC4;
			mh.len = 1;
			break;
		default:
			continue;
		}

		if (fwrite(&mh, sizeof(mh), 1, file) != 1)
		{
			line = __LINE__;
		      writerr:
			r = mem_error(errbuf, errbuflen, line,
				      "file '%s' write error: %s", strerror(errno));
			goto ret;
		}

		switch (mh.type)
		{
		case 0xC3:	/* string */
			{
				char *sp;
				int len;
				int j;

				len = dp->u.c.len + 1;
				sp = dp->u.c.str;

				for (j = 0; j < len; ++j, ++sp)
				{
					int s = *(unsigned char *) sp;

					if (tbl && s > 127)
						s = tbl->write[s - 128];
					if (fputc(s, file) == EOF)
					{
						line = __LINE__;
						goto writerr;
					}
				}
			}
			break;
		case 0xCC:	/* logic */
			{
				char ch;

				ch = dp->u.l;
				if (fputc(ch, file) == EOF)
				{
					line = __LINE__;
					goto writerr;
				}
			}
			break;
		case 0xCE:	/* numeric */
			{
				double d;
				unsigned char buf[8];
				int j;

				d = dp->u.n;
				for (j = 0; j < 8; ++j)
					buf[j] = ((unsigned char *) &d)[j];
				if (fwrite(buf, 8, 1, file) != 1)
				{
					line = __LINE__;
					goto writerr;
				}
			}
			break;
		case 0xC4:	/* date */
			{
				double d;
				unsigned char buf[8];
				int j;

				d = dp->u.d;
				for (j = 0; j < 8; ++j)
					buf[j] = ((unsigned char *) &d)[j];
				if (fwrite(buf, 8, 1, file) != 1)
				{
					line = __LINE__;
					goto writerr;
				}
			}
			break;
		}
	}

      ret:
	fclose(file);

	return r;
}
