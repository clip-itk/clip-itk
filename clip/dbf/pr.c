/*
$Log: pr.c,v $
Revision 1.3  2000/04/28 17:55:34  clip

bsd fixes

Revision 1.2  1999/10/26 19:19:20  axl
start cvs logging (./dbf)

*/
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

#include "dbf.h"

int
main(int argc, char **argv)
{
	char errbuf[256];
	struct DbfFile *fp;
        int r;

	unlink("_a.ntx");
	fp = open_DbfFile("_a.dbf", DBF_NTX | DBF_DBT, 0, 1, dbf_calc, 0, errbuf, sizeof(errbuf));

	if (!fp)
        {
        	printf("%s\n", errbuf);
        	return 1;
	}

	r = createIndex_DbfFile(fp, "_a", 0, "_a", "ODATE", 0);

	if (r)
        {
		getError_DbfFile(fp, errbuf, sizeof(errbuf));
        	printf("%s\n", errbuf);
                return 2;
        }

	close_DbfFile(fp);

	return 0;
}
