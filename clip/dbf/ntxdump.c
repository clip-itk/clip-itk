/*
$Log: ntxdump.c,v $
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
#include "ntx.h"

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

static NtxBucket *
get_ntx_bucket(NtxPage * pp, int no)
{
	int boffs = dbf_get_ushort(pp->ref + no * 2);
	NtxBucket *bp = (NtxBucket *) (((char *) pp) + boffs);

	return bp;
}

static int
dump_page(FILE * file, long root)
{
	char buf[1024];
	NtxPage *pp = (NtxPage *) buf;
	NtxBucket *bp;
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
	printf("\nPAGE %ld: count=%d\n\n", root, count);

	for (i = 0; i < count + 1; ++i)
	{
		long page, record;
		int offs;

		bp = get_ntx_bucket(pp, i);
		page = dbf_get_long(bp->page);
		record = dbf_get_long(bp->record);
		offs = dbf_get_ushort(pp->ref + i * 2);
		if (i < count)
			printf("%2d: offs: %4d page: %10ld record: %7ld key: '%.*s'\n", i, offs, page, record, key_size, bp->key);
		else
			printf("%2d: offs: %4d page: %10ld record: %7ld\n", i, offs, page, record);
	}

	for (i = 0; i < count + 1; ++i)
	{
		long page;

		bp = get_ntx_bucket(pp, i);
		page = dbf_get_long(bp->page);
		dump_page(file, page);
	}

	return 0;
}

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

int
main(int argc, char **argv)
{
	FILE *file;
	NtxHeader *hp;
	char buf[1024];
	long root, freePage;
	struct stat st;

	if (argc < 2)
	{
		printf("usage: %s ntx_file_name\n", argv[0]);
		return 1;
	}

	file = fopen(argv[1], "r");

	if (fread(&buf, sizeof(buf), 1, file) != 1)
		error("cannot read header");
	hp = (NtxHeader *) buf;

	fstat(fileno(file), &st);
	max_root = st.st_size - 1024;

	printf("file '%s' dump:\n", argv[1]);
	printf("signature: %d\n", dbf_get_ushort(hp->signature));
	printf("version: %d\n", dbf_get_ushort(hp->version));
	printf("root: %ld\n", root = dbf_get_long(hp->root));
	printf("freePage: %ld\n", freePage = dbf_get_long(hp->empty));
	printf("item_size: %d\n", dbf_get_ushort(hp->item_size));
	printf("key_size: %d\n", key_size = dbf_get_ushort(hp->key_size));
	printf("key_dec: %d\n", dbf_get_ushort(hp->key_dec));
	printf("max_items: %d\n", dbf_get_ushort(hp->max_items));
	printf("half_page: %d\n", dbf_get_ushort(hp->half_page));
	printf("key_expr: '%s'\n", hp->key_expr);
	printf("unique: %d\n", hp->unique);

	dump_page(file, root);

	dump_free_page(file, freePage);

	fclose(file);

	return 0;
}
