
/*
   $Log$
   Revision 1.1  2006/06/22 19:01:32  itk
   uri: initial

   Revision 1.10  2003/07/03 07:15:55  clip
   fix a lot of warnings
   paul

   Revision 1.9  2001/10/22 07:44:27  clip
   add -d flag to cliphash
   paul

   Revision 1.8  2000/05/24 18:34:02  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.7  2000/05/20 18:37:23  clip
   change hash function
   append HASH_xxxx extraction into hashcode.h
   Paul Lasarev <paul@itk.ru>

   Revision 1.6  2000/05/19 17:14:37  clip
   test
   Paul Lasarev <paul@itk.ru>

   Revision 1.5  2000/03/30 14:46:17  paul
   one-letter words

   Revision 1.4  2000/03/03 21:37:31  paul
   preprocessor bug fix, warnings removed

   Revision 1.3  1999/12/04 20:08:27  uri
   убрал warning нового компилятора

   Revision 1.2  1999/10/26 19:11:15  paul
   start cvs logging

 */

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "cliphash.h"

int
main(int argc, char **argv)
{
	char buf[256], *beg, *end;
	int dec_flag = 0, i;

	for (i = 1; i < argc; i++)
	{
		char *ap;

		ap = argv[i];

		if (!strcmp(ap, "-d"))
		{
			dec_flag = 1;
		}
		else
		{
			fprintf(stderr, "usage: %s [-d] < inuput_stream >output_stream\n", argv[0]);
			fprintf(stderr, " 	-d for deciman output (default is hex)\n");
			exit(1);
		}
	}

	while (fgets(buf, sizeof(buf), stdin))
	{
		for (beg = buf; *beg && (beg - buf) < sizeof(buf) && (*beg == ' ' || *beg == '\t'); ++beg)
			;
		for (end = buf + strlen(buf) - 1; end >= buf && (*end == ' ' || *end == '\t' || *end == '\r' || *end == '\n'); --end)
			;
		if (end >= beg)
		{
			fputc('\'', stdout);
			fwrite(beg, end - beg + 1, 1, stdout);
			fputc('\'', stdout);
			if (dec_flag)
				fprintf(stdout, ": %ld\n", _clip_casehashbytes(0, beg, end - beg + 1));
			else
				fprintf(stdout, ": 0x%lx\n", _clip_casehashbytes(0, beg, end - beg + 1));
		}
	}
	return 0;
}
