/*
$Log: idxdump.c,v $
Revision 1.1  2000/05/26 21:07:42  clip
fix positioning of a current record
start of idxdump
Alex Vorontsov <axl@itk.ru>

Revision 1.3  2000/03/14 00:06:49  axl
fix SEEK, make allign in ntxdump

Revision 1.2  1999/10/26 19:19:18  axl
start cvs logging (./dbf)

*/

#include <stdio.h>
#include <stdarg.h>
#include <errno.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#include "dbfpriv.h"
#include "idx.h"

extern void idx_get_bucket(IdxPage *ip, IdxBucket *it, unsigned char *c);
static int key_size;
static long max_root;

static int
error(char *fmt,...)
{
	va_list ap;

	va_start(ap, fmt);
	vfprintf(stdout, fmt, ap);
	va_end(ap);

	fprintf(stdout, ":\n errno==%d, '%s'\n", errno, strerror(errno));
	exit(2);
}

static long
idx_get_long(unsigned char *c)
{
	long ret = *c;
	ret = (ret << 8) + *(c+1);
	ret = (ret << 8) + *(c+2);
	ret = (ret << 8) + *(c+3);
	return ret;
}

static int
dump_page(FILE * file, long root)
{
	char buf[512];
	IdxPage *pp = (IdxPage *) buf;
	int count, i;

	if (!root)
		return 0;

	if (root < 1024 || root > max_root)
		error("invalid root value: %ld (must be between 1024 and %ld)", root, max_root);

	if (fseek(file, root, SEEK_SET))
		error("cannot seek page %ld", root);
	if (fread(&buf, sizeof(buf), 1, file) != 1)
		error("cannot read page %ld", root);
	count = dbf_get_ushort(pp->count);

	if ( dbf_get_ushort(pp->attr) & IDX_KEY_LEAF )
	{
		IdxBucket bp;
		unsigned char str[key_size];
		unsigned char *kp = (char*) pp + IDX_PAGE_SIZE;
		unsigned char *offs = (unsigned char *)pp + IDX_LEAF_OFFS;
		int klen;

		printf("\n%s%s PAGE %ld: count=%d (free=%d)\n\n", dbf_get_ushort(pp->attr)&IDX_KEY_ROOT?"ROOT ":"", "LEAF", root, count, dbf_get_ushort(pp->free));

		for (i = 0; i < count; i++)
		{
			idx_get_bucket(pp, &bp, offs);
			klen = key_size-bp.dup-bp.trail;
			kp -= klen;
			memcpy(str+bp.dup, kp, klen);
			memset(str+klen+bp.dup, 32, bp.trail);
			printf("%2d: record: %7ld key: '%.*s' dup:%3d trail:%3d add:%3d\n", i, bp.record, key_size, str, bp.dup, bp.trail, klen);
			//printf("%7ld key: '%.*s' dup:%3d trail:%3d add:%3d\n", bp.record, key_size, str, bp.dup, bp.trail, klen);
			offs += pp->keybytes;
		}
	}
	else
	{
		unsigned char *offs = (unsigned char *)pp + IDX_INDEX_OFFS;
		long page, record;

		printf("\n%s PAGE %ld: count=%d\n\n", dbf_get_ushort(pp->attr)&IDX_KEY_ROOT?"ROOT":"INDEX", root, count);
		for (i = 0; i < count; i++)
		{
			record = idx_get_long(offs + key_size);
			page = idx_get_long(offs + key_size + 4);
			printf("%2d: page: %10ld record: %7ld key: '%.*s'\n", i, page, record, key_size, offs);
			//printf("%7ld key: '%.*s'\n", record, key_size, offs);
			offs += key_size + 8;
		}
		offs = (unsigned char *)pp + IDX_INDEX_OFFS;
		for (i = 0; i < count; ++i)
		{
			page = idx_get_long(offs + key_size + 4);
			dump_page(file, page);
			offs += key_size + 8;
		}
	}

	return 0;
}
/*
static int
dump_free_page(FILE * file, long root)
{
	char buf[1024];
	NtxFreePage *pp = (NtxFreePage *) buf;

	printf("\nFREE PAGE LIST: root = %ld\n", root);

	while (root)
	{
		if (fseek(file, root, SEEK_SET))
			error("cannot seek free page %ld", root);
		if (fread(&buf, sizeof(buf), 1, file) != 1)
			error("cannot read free page %ld", root);
		root = dbf_get_long(pp->next);
		printf("next page = %ld\n", root);
	}

	return 0;
}
*/
int
main(int argc, char **argv)
{
	FILE *file;
	IdxHeader *hp;
	char buf[1024];
	long root, freePage, opt, klen;
	struct stat st;

	if (argc < 2)
	{
		printf("usage: %s idx_file_name\n", argv[0]);
		return 1;
	}

	file = fopen(argv[1], "r");

	if (fread(&buf, sizeof(buf), 1, file) != 1)
		error("cannot read header");
	hp = (IdxHeader *) buf;

	fstat(fileno(file), &st);
	max_root = st.st_size;

	printf("file '%s' dump:\n", argv[1]);
	printf("root    : %ld\n", root = dbf_get_long(hp->root));
	printf("freePage: %ld\n", freePage = dbf_get_long(hp->empty));
	printf("version : %ld\n", dbf_get_long(hp->version));
	printf("key_size: %d\n", key_size = dbf_get_ushort(hp->key_size));
	opt = hp->options;
	printf("options : %s%s%s\n", opt&IDX_COMPACT?"COMPACT ":"", opt&IDX_UNIQUE?"UNIQUE ":"",  opt&IDX_FOREXPR?"FOREXPR":"");
	printf("order   : %d\n", dbf_get_ushort(hp->order));
	printf("key     : %s\n", (char*)hp->expr);
	klen = dbf_get_ushort(hp->key_len);
	printf("for     : %s\n", (char*)hp->expr+klen);

	dump_page(file, root);
/*
	dump_free_page(file, freePage);
*/
	fclose(file);

	return 0;
}
