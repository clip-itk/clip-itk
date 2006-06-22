/*
 * sample malloc library usage program.
 */

#include "malloc.h"

static	char	*rcs_id =
  "$Id$";

main(int argc, char ** argv)
{
  char	*pnt;
  long	*longp;
  
  /* allocate 10-bytes */
  pnt = MALLOC(10);
  
  /* free the pointer */
  FREE(pnt);
  
  /* allocate 50-longs */
  longp = ALLOC(long, 50);
  
  /* realloc to 100-longs */
  longp = REALLOC(longp, long, 100);
  /* don't free them */
  
#ifdef MALLOC_DEBUG
  /* check out the heap and shut everything down if we are in debug mode */
  malloc_verify(0);
  malloc_shutdown();
#endif
  
  exit(0);
}
