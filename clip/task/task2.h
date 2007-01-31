/*
   Copyright (C) 2007  ITK
   Author   : Uri <uri@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
 $Log$
 Revision 1.4  2007/01/31 13:48:21  itk
 uri:some new code for pth

 Revision 1.3  2007/01/30 13:43:06  itk
 *** empty log message ***

 Revision 1.2  2007/01/23 14:12:12  itk
 uri: some new code for new tasks

 Revision 1.1  2007/01/23 10:46:23  itk
 uri: some redisign for new task model

 */


#define TASK_STACK_MIN        16384
#define NEW(typ) ((typ*) calloc(sizeof(typ),1))

#include <setjmp.h>
#include "../list.h"
#include "../coll.h"
#include "../hash.h"



