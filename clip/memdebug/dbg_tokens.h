/*
 * tokens attributes for the malloc_dbg program
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
 *
 * $Id: dbg_tokens.h,v 1.1 2000/04/20 19:38:45 paul Exp $
 */

#ifndef __DBG_TOKENS_H__
#define __DBG_TOKENS_H__

#include "malloc.h"			/* for LOCAL and bool stuff */
#include "dbg_values.h"			/* for debug codes */

typedef struct {
  char		*at_string;		/* attribute string */
  int		at_value;		/* value for the item*/
} attr_t;

LOCAL	attr_t		attributes[] = {
  { "none",			0 },
  
  { "log-stats",		DEBUG_LOG_STATS },
  { "log-non-free",		DEBUG_LOG_NONFREE },
  { "log-perror",		DEBUG_LOG_PERROR },
  { "log-trans",		DEBUG_LOG_TRANS },
  { "log-bad-pnt",		DEBUG_LOG_BAD_POINTER },
  { "log-admin",		DEBUG_LOG_ADMIN },
  { "log-blocks",		DEBUG_LOG_BLOCKS },
  { "log-unknown",		DEBUG_LOG_UNKNOWN },
  
  { "check-fence",		DEBUG_CHECK_FENCE },
  { "check-heap",		DEBUG_CHECK_HEAP },
  { "check-lists",		DEBUG_CHECK_LISTS },
  { "check-dblock",		DEBUG_CHECK_DBLOCK },
  { "check-dblock-fence",	DEBUG_CHECK_DB_FENCE },
  { "check-free",		DEBUG_CHECK_FREE },
  { "check-funcs",		DEBUG_CHECK_FUNCS },
  
  { "realloc-copy",		DEBUG_REALLOC_COPY },
  { "free-blank",		DEBUG_FREE_BLANK },
  { "error-abort",		DEBUG_ERROR_ABORT },
  { "alloc-blank",		DEBUG_ALLOC_BLANK },
  { "heap-check-map",		DEBUG_HEAP_CHECK_MAP },
  { "print-perror",		DEBUG_PRINT_PERROR },
  
  { NULL }
};

#endif /* ! __DBG_TOKENS_H__ */
