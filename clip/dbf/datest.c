/*
$Log: datest.c,v $
Revision 1.2  1999/10/26 19:19:04  axl
start cvs logging (./dbf)

*/

#include <stdio.h>

#include "dbf.h"

int
main(int argc, char **argv)
{
	long julian;
	int yy, mm, dd;
	double d;
	int i;

	for (;;)
	{
		printf("Enter: yyyy mm dd: ");
		fflush(stdout);
		scanf("%d %d %d", &yy, &mm, &dd);
		julian = dbf_jdate(dd, mm, yy);
		printf("julian(%d,%d,%d) = %ld (0x%08lx)\n", yy, mm, dd, julian, julian);

		d = julian;
		for (i = 0; i < sizeof(d); ++i)
			printf(" %02x", ((unsigned char *) &d)[i]);
		printf("\n");
	}

}
