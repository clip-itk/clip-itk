/*
 * array of error messages for the malloc internal errors.
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
 * $Id: error_str.h,v 1.1 2000/04/20 19:38:45 paul Exp $
 */

#ifndef __ERROR_STR_H__
#define __ERROR_STR_H__

/* string error codes which apply to error codes in error_val.h */
LOCAL	char	*malloc_errlist[] = {
  "no error",
  
  /* administrative errors */
  "initialization sanity checks on setup values failed",
  "malloc domain has been entered twice",
  "errno value passed in by user is out-of-bounds",
  
  /* pointer verification errors */
  "pointer is null",
  "pointer is not pointing into the heap data space",
  "cannot locate pointer in the heap",
  "found pointer the user was looking for",
  "possibly bad .c filename pointer",
  "possibly bad .c file line-number",
  "failed UNDER picket-fence magic-number checking",
  "failed OVER picket-fence magic-number checking",
  "pointer will exceed allocation",
  
  /* allocation errors */
  "invalid allocation size",
  "largest maximum allocation size exceeded",
  "user allocated space contiguous block error",
  "could allocate more memory, heap extension failed",
  "bad size in information structure",
  
  /* free errors */
  "pointer is not on a block boundary",
  "tried to free pointer which is already freed",
  "pointer does not point to start of user-allocated space",
  "pointer does not point to user-allocated space",
  "inconsistency with free linked-list",
  "free space contiguous block error",
  "bad basic-block memory pointer in the free-list",
  "space that should be free has been overwritten",
  
  /* dblock errors */
  "bad divided-block chunk size",
  "bad divided-block pointer",
  "bad basic-block memory pointer in dblock struct",
  "bad divided-block admin pointer",
  "bad divided-block admin magic numbers",
  "bad divided-block chunk admin information structure",
  
  /* administrative errors */
  "admin structure pointer out of bounds",
  "bad admin structure list",
  "bad magic number in admin structure",
  "bad basic-block count value in admin structure",
  "bad basic-block administration pointer",
  "bad basic-block administration counter",
  
  /* heap check verification */
  "bad basic-block allocation order",
  "basic-block has bad flag value",
  
  "PROBLEM - BAD ERRNO VALUE",
  "PROBLEM - BAD ERRNO VALUE",
  "PROBLEM - BAD ERRNO VALUE",
};

#endif /* ! __ERROR_STR_H__ */
