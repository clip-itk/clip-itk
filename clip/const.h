/*
   $Log: const.h,v $
   Revision 1.2  2000/05/24 18:34:22  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.1  1999/10/25 16:39:28  paul
   first entry

   * Revision 1.1  1997/03/12  14:51:38  paul
   * initial
   *
 */

#ifndef CONST_H
#define CONST_H

typedef struct
{
	int type;
	char *str;
}
ConstStruct;

ConstStruct *new_ConstStruct(int type);
void delete_ConstStruct(void *cp);

void print_ConstStruct(ConstStruct * cp, FILE * file);
void printString(FILE * stream, const char *str);

#endif
