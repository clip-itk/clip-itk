/*
 * defines for the error and message code.
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
 * $Id: error.h,v 1.1 2000/04/20 19:38:45 paul Exp $
 */

#ifndef __ERROR_H__
#define __ERROR_H__

#include <stdarg.h>			/* for ... */
#include "malloc.h"			/* for IMPORT */

/*<<<<<<<<<<  The below prototypes are auto-generated by fillproto */

/* global debug flags that are set my MALLOC_DEBUG environ variable */
IMPORT	int		_malloc_debug;

/*
 * message writer with printf like arguments
 */
IMPORT	void	_malloc_message(const char * format, ...);

/*
 * kill the program because of an internal malloc error
 */
IMPORT	void	_malloc_die(void);

/*
 * malloc version of perror of an error in STR
 */
IMPORT	void	_malloc_perror(const char * func);

/*<<<<<<<<<<   This is end of the auto-generated output from fillproto. */

#endif /* ! __ERROR_H__ */
