/*
 * functions for testing of string routines arguments.
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
 * This file contains functions to be used to verify the arguments of
 * string functions.   If enabled these can discover problems with
 * heap-based strings (such as fence errors) much closer to the error.
 */

#define MALLOC_DEBUG_DISABLE

#include "malloc.h"
#include "malloc_loc.h"

#include "conf.h"
#include "chunk.h"
#include "dbg_values.h"
#include "error.h"
#include "malloc_str.h"

#if INCLUDE_RCS_IDS
LOCAL	char	*rcs_id =
  "$Id$";
#endif

#if HAVE_BCMP
/*
 * dummy function for checking bcmp's arguments.
 */
EXPORT	int	_malloc_bcmp(const char *msg, const void * b1, const void * b2, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, b1, 1, len) != NOERROR
	|| _chunk_pnt_check(msg, b2, 1, len) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return bcmp(b1, b2, len);
}
#endif

#if HAVE_BCOPY
/*
 * dummy function for checking bcopy's arguments.
 */
EXPORT	void	_malloc_bcopy(const char *msg, const void * from, void * to, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, from, 1, len) != NOERROR
	|| _chunk_pnt_check(msg, to, 1, len) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  bcopy(from, to, len);
}
#endif

#if HAVE_MEMCMP
/*
 * dummy function for checking memcmp's arguments.
 */
EXPORT	int	_malloc_memcmp(const char *msg, const void * b1,
			       const void * b2, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, b1, 1, len) != NOERROR
	|| _chunk_pnt_check(msg, b2, 1, len) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return memcmp(b1, b2, len);
}
#endif

#if HAVE_MEMCPY
/*
 * dummy function for checking memcpy's arguments.
 */
EXPORT	char	*_malloc_memcpy(const char *msg, void * to, const void * from, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, to, 1, len) != NOERROR
	|| _chunk_pnt_check(msg, from, 1, len) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)memcpy(to, from, len);
}
#endif

#if HAVE_MEMSET
/*
 * dummy function for checking memset's arguments.
 */
EXPORT	char	*_malloc_memset(const char *msg, void * buf, char ch, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, buf, 1, len) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)memset(buf, ch, len);
}
#endif

#if HAVE_INDEX
/*
 * dummy function for checking index's arguments.
 */
EXPORT	char	*_malloc_index(const char *msg, const char * str, char ch)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, str, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)index(str, ch);
}
#endif

#if HAVE_RINDEX
/*
 * dummy function for checking rindex's arguments.
 */
EXPORT	char	*_malloc_rindex(const char *msg, const char * str, char ch)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, str, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)rindex(str, ch);
}
#endif

#if HAVE_STRCAT
/*
 * dummy function for checking strcat's arguments.
 */
EXPORT	char	*_malloc_strcat(const char *msg, char * to, const char * from)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    /* maybe should check to, strlen(to) + strlen(from) */
    if (_chunk_pnt_check(msg, to, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, from, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)strcat(to, from);
}
#endif

#if HAVE_STRCMP
/*
 * dummy function for checking strcmp's arguments.
 */
EXPORT	int	_malloc_strcmp(const char *msg, const char * s1,
			       const char * s2)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, s1, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, s2, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return strcmp(s1, s2);
}
#endif

#if HAVE_STRLEN
/*
 * dummy function for checking strlen's arguments.
 */
EXPORT	int	_malloc_strlen(const char *msg, const char * str)
{
  if (BIT_IS_SET(_malloc_debug,
		 DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, str, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return strlen(str);
}
#endif

#if HAVE_STRTOK
/*
 * dummy function for checking strtok's arguments.
 */
EXPORT	char	*_malloc_strtok(const char *msg, char * str, const char * sep)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, str, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, sep, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)strtok(str, sep);
}
#endif

#if HAVE_BZERO
/*
 * dummy function for checking bzero's arguments.
 */
EXPORT	void	_malloc_bzero(const char *msg, void * buf,
			      int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, buf, 1, len) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  bzero(buf, len);
}
#endif

#if HAVE_MEMCCPY
/*
 * dummy function for checking memccpy's arguments.
 */
EXPORT	char	*_malloc_memccpy(const char *msg, void * s1, const void * s2, char ch, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    /* maybe len maybe first ch */
    if (_chunk_pnt_check(msg, s1, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, s2, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)memccpy(s1, s2, ch, len);
}
#endif

#if HAVE_MEMCHR
/*
 * dummy function for checking memchr's arguments.
 */
EXPORT	char	*_malloc_memchr(const char *msg, const void * s1, char ch, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, s1, 1, len) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)memchr(s1, ch, len);
}
#endif

#if HAVE_STRCHR
/*
 * dummy function for checking strchr's arguments.
 */
EXPORT	char	*_malloc_strchr(const char *msg, const char * str, char ch)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, str, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)strchr(str, ch);
}
#endif

#if HAVE_STRRCHR
/*
 * dummy function for checking strrchr's arguments.
 */
EXPORT	char	*_malloc_strrchr(const char *msg, const char * str, char ch)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, str, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)strrchr(str, ch);
}
#endif

#if HAVE_STRCPY
/*
 * dummy function for checking strcpy's arguments.
 */
EXPORT	char	*_malloc_strcpy(const char *msg, char * to, const char * from)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    /* maybe to, strlen(from) */
    if (_chunk_pnt_check(msg, to, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, from, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)strcpy(to, from);
}
#endif

#if HAVE_STRNCPY
/*
 * dummy function for checking strncpy's arguments.
 */
EXPORT	char	*_malloc_strncpy(const char *msg, char * to, const char * from, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    /* len or until nullc */
    if (_chunk_pnt_check(msg, to, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, from, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)strncpy(to, from, len);
}
#endif

#if HAVE_STRCASECMP
/*
 * dummy function for checking strcasecmp's arguments.
 */
EXPORT	int	_malloc_strcasecmp(const char *msg, const char * s1, const char * s2)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, s1, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, s2, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return strcasecmp(s1, s2);
}
#endif

#if HAVE_STRNCASECMP
/*
 * dummy function for checking strncasecmp's arguments.
 */
EXPORT	int	_malloc_strncasecmp(const char *msg, const char * s1, const char * s2, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    /* len or until nullc */
    if (_chunk_pnt_check(msg, s1, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, s2, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return strncasecmp(s1, s2, len);
}
#endif

#if HAVE_STRSPN
/*
 * dummy function for checking strspn's arguments.
 */
EXPORT	int	_malloc_strspn(const char *msg, const char * str, const char * list)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, str, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, list, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return strspn(str, list);
}
#endif

#if HAVE_STRCSPN
/*
 * dummy function for checking strcspn's arguments.
 */
EXPORT	int	_malloc_strcspn(const char *msg, const char * str, const char * list)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, str, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, list, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return strcspn(str, list);
}
#endif

#if HAVE_STRNCAT
/*
 * dummy function for checking strncat's arguments.
 */
EXPORT	char	*_malloc_strncat(const char *msg, char * to, const char * from, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    /* either len or nullc */
    if (_chunk_pnt_check(msg, to, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, from, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)strncat(to, from, len);
}
#endif

#if HAVE_STRNCMP
/*
 * dummy function for checking strncmp's arguments.
 */
EXPORT	int	_malloc_strncmp(const char *msg, const char * s1, const char * s2, int len)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    /* either len or nullc */
    if (_chunk_pnt_check(msg, s1, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, s2, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return strncmp(s1, s2, len);
}
#endif

#if HAVE_STRPBRK
/*
 * dummy function for checking strpbrk's arguments.
 */
EXPORT	char	*_malloc_strpbrk(const char *msg, const char * str, const char * list)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, str, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, list, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)strpbrk(str, list);
}
#endif

#if HAVE_STRSTR
/*
 * dummy function for checking strstr's arguments.
 */
EXPORT	char	*_malloc_strstr(const char *msg, const char * str, const char * pat)
{
  if (BIT_IS_SET(_malloc_debug, DEBUG_CHECK_FUNCS)) {
    if (_chunk_pnt_check(msg, str, 1, 0) != NOERROR
	|| _chunk_pnt_check(msg, pat, 1, 0) != NOERROR)
      if (BIT_IS_SET(_malloc_debug, DEBUG_LOG_BAD_POINTER))
	_malloc_message("bad pointer argument found in %s", msg);
  }
  return (char *)strstr(str, pat);
}
#endif
