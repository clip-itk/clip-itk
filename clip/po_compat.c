/*
 $Log: po_compat.c,v $
 Revision 1.2  2003/07/03 07:15:56  clip
 fix a lot of warnings
 paul

 Revision 1.1  2002/11/04 10:21:57  clip
 po compatability mode for old gettext utils
 paul

*/

#include <string.h>
#include "po_util.h"

int
main(int argc, char **argv)
{
	PoEntry *ep;
	int from_flag;

	if (argc != 2)
	{
	      usage:
		printf("usage: %s [-t]|[-f]  < source >target\n", argv[0]);
		printf("\t-t\tto translate to plural compat form\n");
		printf("\t-f\tto translate from plural compat form\n");
		return 1;
	}

	if (!strcmp(argv[1], "-f"))
		from_flag = 1;
	else if (!strcmp(argv[1], "-t"))
		from_flag = 0;
	else
		goto usage;

	for (;;)
	{
		if (from_flag)
			ep = po_read_entry_compat(stdin);
		else
			ep = po_read_entry(stdin);

		if (!ep)
			break;

		if (from_flag)
			po_write_entry(stdout, ep, 0);
		else
			po_write_entry_compat(stdout, ep, 0);

		fprintf(stdout, "\n");

	}

	return 0;

}
