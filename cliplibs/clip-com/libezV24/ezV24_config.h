/* -*- Mode: C -*-
 *
 * $Id: ezV24_config.h,v 1.2 2002/09/11 09:11:28 clip Exp $
 * -----------------------------------------------------------------------
 * Copyright  (c) 2001  Joerg Desch <jd@die-deschs.de>
 * -----------------------------------------------------------------------
 * PROJECT: ezV24 -- easy RS232/V24 access
 * MODULE.: EZV24_CONFIG.H: OS Configuration Header
 * AUTOR..: Joerg Desch <jd@die-deschs.de>
 * -----------------------------------------------------------------------
 * DESCRIPTION:
 *
 * Here we have some platform dependend compiler-flags. With this flags, the
 * code of the library is adapted to the selected operation system.
 *
 * -----------------------------------------------------------------------
 * COMPILER-FLAGS:
 *
 * EZV24_WANT_LOCKFILE    This is set to 1 (TRUE), if we need support for
 *                        lock-files to protect the opened device.
 *
 * EZV24_POSIX_STYLE      This is set 1 (TRUE), if we have POSIX complaint
 *                        functions to access the serial port.
 *
 * EZV24_HAVE_CFMAKERAW   If we have termios:cfmakeraw() we can use it by
 *                        define a 1 (true). Use 0 (false) to do the setup
 *                        manual.
 *
 * -----------------------------------------------------------------------
 * $Log: ezV24_config.h,v $
 * Revision 1.2  2002/09/11 09:11:28  clip
 * new upstream verson of eZ library
 * paul
 *
 * Revision 1.1.1.1  2002/06/20 09:51:20  jdesch
 * First CVS import of release 0.0.4
 *
 *
 */

#ifndef __EZV24_CONFIG_H__
#define __EZV24_CONFIG_H__ 1

#ifdef __cplusplus
extern "C" {
#endif


/* This is set to 1 (TRUE), if we need support for lock-files to protect the
 * opened device.
 */
#ifdef __LINUX__ 
# ifdef __CYGWIN__
#  define EZV24_WANT_LOCKFILE 1
# else
#  define EZV24_WANT_LOCKFILE 1
# endif
#else
# define EZV24_WANT_LOCKFILE 0
#endif


/* This is set 1 (TRUE), if we have POSIX complaint functions to access the
 * serial port.
 */
#ifdef __LINUX__
#define EZV24_POSIX_STYLE 1
#else
#define EZV24_POSIX_STYLE 0
#endif


/* If we have termios.h/cfmakeraw() we can use it by define a 1 (true). Use 0
 * (false) to do the setup manual.
 */
#ifdef __CYGWIN__
#define EZV24_HAVE_CFMAKERAW 0
#else
#define EZV24_HAVE_CFMAKERAW 1
#endif

/* This is the place, where the library stores the lock file. So you need to
 * have write access! Note: define the path without a trailing slash!
 */
#define EZV24_LOCK_PATH "/var/lock"


/* This is the file, where the library writes its log messages to. So you need
 * to have write access!
 */
#define EZV24_LOG_FILE "ezv24.log"


/* This is the character, that is used to detect the end of a line in
 * v24Gets().
 */
#define EZV24_END_OF_STRING '\n'



#ifdef __cplusplus
};
#endif

#endif
/* ==[End of file]========================================================== */

