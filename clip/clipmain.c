
/*
   $Log$
   Revision 1.2  2007/02/12 16:13:08  itk
   uri: some fix about task_select and some fix for amd64

   Revision 1.1  2006/06/22 19:01:33  itk
   uri: initial

   Revision 1.7  2004/01/25 10:23:40  clip
   uri: fix bug in exit procedures and inkey()

   Revision 1.6  2000/05/24 18:34:14  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.5  2000/05/20 18:37:29  clip
   change hash function
   append HASH_xxxx extraction into hashcode.h
   Paul Lasarev <paul@itk.ru>

   Revision 1.4  2000/04/04 17:37:46  paul
   main

   Revision 1.3  2000/03/29 18:26:13  paul
   errorblock

   Revision 1.2  1999/10/26 19:11:22  paul
   start cvs logging

 */

#include "clip.h"
#include "hashcode.h"

/*extern void *alloca(); */
extern int printf();
extern char **environ;

int
main(int argc, char **argv)
{
	int ret;
	ClipMachine *mp = new_ClipMachine(0);

	Task_INIT();
	ret = _clip_main(mp, HASH_main, argc, argv, environ);
	return ret;
}
