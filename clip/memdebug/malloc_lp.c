/*
 * leap-frog point to allow malloc-debug on/off via relink.
 *
 * Copyright 1992 by Gray Watson and the Antaire Corporation
 *
 * This file is part of the malloc-debug package.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library (see COPYING-LIB); if not, write to the
 * Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * The author of the program may be contacted at gray.watson@antaire.com
 */

/*
 * If anyone can think of a better way to do this *please* let me know.
 *
 * The goal is to allow people to use the debug library during development
 * and then disable and return to the system (or more efficient) malloc
 * functions by just relinking with another library.
 *
 * The problem is that we want to provide the library with file/line
 * information with each call.  Backtracing the stack-frame is neither
 * portable or necessarily easy so the cpp __FILE__ and __LINE__ directives
 * are used instead.  But how to pass this information to the library is
 * the challange.  How can we do this in a graceful and sane manner while
 * still providing the "quick-release" functionality above?
 *
 * I have decided on this leap-frog file that will have to *always* be
 * compiled in.  It will have the special _malloc_file and _malloc_line
 * variables and will set them whether malloc-debug routines are linked
 * in to use them or not.
 *
 * This *will* mean an extra function call per memory interaction but on
 * most systems this is pretty cheap.  It will also mean that this file
 * needs to be compiled into your programs whether or not they use the
 * debug library unless you want to recompile all .c files with
 * -DMALLOC_DEBUG_DISABLE.
 *
 * Please mail me with any reasonable ideas.
 */

#define MALLOC_DEBUG_DISABLE

#include "malloc.h"

#if INCLUDE_RCS_IDS
static	char	*rcs_id =
  "$Id: malloc_lp.c,v 1.2 2001/05/15 07:02:17 clip Exp $";
#endif

/*
 * exported variables
 */
/* to inform the malloc-debug library from which file the call comes from */
EXPORT	char		*_malloc_file = MALLOC_DEFAULT_FILE;

/* to inform the library from which line-number the call comes from */
EXPORT	unsigned int	_malloc_line = MALLOC_DEFAULT_LINE;

/*
 * leap routine to calloc
 */
EXPORT	void	*_calloc_leap(const char * file, const int line,
			      unsigned int elen, unsigned int size)
{
  char	*ret;

  _malloc_file = (char *)file;
  _malloc_line = line;

  ret = calloc(elen, size);

  _malloc_file = MALLOC_DEFAULT_FILE;
  _malloc_line = MALLOC_DEFAULT_LINE;

  return ret;
}

/*
 * leap routine to free
 */
EXPORT	int	_free_leap(const char * file, const int line, void * pnt)
{
  int	ret;

  _malloc_file = (char *)file;
  _malloc_line = line;

  ret = free(pnt);

  _malloc_file = MALLOC_DEFAULT_FILE;
  _malloc_line = MALLOC_DEFAULT_LINE;

  return ret;
}

/*
 * leap routine to malloc
 */
EXPORT	void	*_malloc_leap(const char * file, const int line,
			      unsigned int size)
{
  char	*ret;

  _malloc_file = (char *)file;
  _malloc_line = line;

  ret = malloc(size);

  _malloc_file = MALLOC_DEFAULT_FILE;
  _malloc_line = MALLOC_DEFAULT_LINE;

  return ret;
}

/*
 * leap routine to realloc
 */
EXPORT	void	*_realloc_leap(const char * file, const int line, void * oldp,
			       unsigned int new_size)
{
  char	*ret;

  _malloc_file = (char *)file;
  _malloc_line = line;

  ret = realloc(oldp, new_size);

  _malloc_file = MALLOC_DEFAULT_FILE;
  _malloc_line = MALLOC_DEFAULT_LINE;

  return ret;
}
