
/*
   $Log: version.c,v $
   Revision 1.5  2002/02/20 09:51:40  clip
   change VERSION to CLIP_VERSION
   paul

   Revision 1.4  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.3  2000/05/24 18:34:41  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.2  2000/04/28 17:55:30  clip

   bsd fixes

   Revision 1.1  1999/10/25 16:39:28  paul
   first entry

   * Revision 1.1  1997/03/12  14:51:51  paul
   * initial
   *
 */

#include <stdio.h>
#include "clipcfg.h"

void
printVersion(FILE * file)
{
	fprintf(file, "%s.%s", CLIP_VERSION, SEQ_NO);
}
