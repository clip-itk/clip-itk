/*
$Log: itest.c,v $
Revision 1.2  1999/10/26 19:19:12  axl
start cvs logging (./dbf)

*/

#include <stdio.h>
#include <unistd.h>
#include <string.h>

#include "dbf.h"


static void
usage(int code)
{
	printf("usage: itest dbf_file ntx_file\n");
	exit(code);
}


int
main(int argc, char **argv)
{
	int r, i;
	struct DbfFile *fp;
	char errbuf[256], *name, *iname;

	if (argc < 3)
		usage(1);

	name = argv[1];
        iname = argv[2];

	fp = open_DbfFile(name, DBF_NTX | DBF_DBT, 0, 0, dbf_calc, 0, errbuf, sizeof(errbuf));

	if (!fp)
	{
		printf("cannot open dbf file '%s': %s\n", name, errbuf);
		return 1;
	}

	r = openIndex_DbfFile(fp, iname, 0, iname);

	if (r)
		goto err;

	for (i = 1, r = goTop_DbfFile(fp); !r; r = skip_DbfFile(fp, 1), ++i)
	{
		int eof;
		long recno;

		if ((r = eof_DbfFile(fp, &eof)))
			goto err;
		if (eof)
			break;
		if ((r = recNo_DbfFile(fp, &recno)))
			goto err;
		printf("no: %d pos: %ld\n", i, recno);
	}

	if (r)
		goto err;

	goto end;
      err:{
		long pos;

		getError_DbfFile(fp, errbuf, sizeof(errbuf));
		recNo_DbfFile(fp, &pos);
		printf("pos: %ld; error : %s\n", pos, errbuf);
		goto end;
	}

      end:
	close_DbfFile(fp);

	return r;
}
