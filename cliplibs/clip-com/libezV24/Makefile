#  $Id$
#  -----------------------------------------------------------------------
#  Copyright  (c) Joerg Desch <jd@die-deschs.de>
#  -----------------------------------------------------------------------
#  PROJECT.: ezV24 -- easy RS232/V24 access
#  AUTHOR..: Joerg Desch <jd@die-deschs.de>
#  COMPILER: g++ 2.95.x / Linux
#
#

# the version of the library
VERSION = 0.1
# the release of the library; a change here means, that the API has
# changes. This number is the major number of the above version
SORELEASE = 0
# the patchlevel is the lowest release information. It is incremented
# with each released bugfix.
PATCHLEVEL = 0
# the base name of the library
SOBASE = ezV24

# define the destination OS (currently only linux)
PLATFORM=__LINUX__

# the base path where the file should be installed to.
PREFIX = /usr/local

# generate the name of the output file in dependence of the development state.
#
ifeq "${RELEASE}" "DEBUG"
NAME = lib$(SOBASE).so.$(SORELEASE).dbg
else
NAME = lib$(SOBASE).so.$(VERSION)
endif
SONAME = lib$(SOBASE).so.$(SORELEASE)
LIBNAME = lib$(SOBASE)-$(SORELEASE).a
PLAINNAME = lib$(SOBASE).so

# basename of the project
PROJECTNAME = libezV24-$(VERSION).$(PATCHLEVEL)

OBJS = ezV24.o snprintf.o
LIBS = 


ifeq "${RELEASE}" "DEBUG"
C_FLAG = -c -Wall -fPIC -D$(PLATFORM) $(INCDIR)
C_DEFS = -DDEBUG -DBETA
LFLAGS = $(LIBDIR)
else 
ifeq "${RELEASE}" "BETA"
C_FLAG = -c -Wall -fPIC -O2 -D$(PLATFORM) $(INCDIR)
C_DEFS = -DBETA
LFLAGS = $(LIBDIR)
else
C_FLAG = -c -Wall  -fPIC -O2 -D$(PLATFORM) $(INCDIR)
C_DEFS = -DFINAL
LFLAGS = -s $(LIBDIR)
endif
endif

# tools to build the static library
ARFLAGS = cru
AR = ar
RANLIB = ranlib

# concatinate the compile flags
CFLAGS = $(C_FLAG) $(C_DEFS)



# ------------------------------------------------------------------------
# AUTOMATISCHE COMPILE-ANWEISUNGEN
# ------------------------------------------------------------------------

.c.o:
		gcc $(CFLAGS) $<


# --------------------------------------------------------------------------
# ANHÄNGIGKEITEN
# --------------------------------------------------------------------------

all:		shared static

shared:		$(NAME)

static:		$(LIBNAME)



$(NAME):	$(OBJS)
		gcc -shared -W1,soname,$(SONAME) -o $(NAME) $(OBJS)

$(LIBNAME):	$(OBJS)
		$(AR) $(ARFLAGS) $(LIBNAME) $(OBJS)
		$(RANLIB) $(LIBNAME)


# Abhängigkeiten des Source, jedoch dann ohne Generierungsanweisung, wenn
# die Extension durch obigen Automatismus abgedeckt wird!
#

ezV24.o:	ezV24.c ezV24.h ezV24_config.h snprintf.h

snprintf.o:	snprintf.c snprintf.h



# This install / uninstall the library into the given directories.
#

install:
		install -d -m 755 $(PREFIX)/include/$(SOBASE)/;
		install -m 644 ezV24.h $(PREFIX)/include/$(SOBASE)/
		install -m 644 -s $(LIBNAME) $(PREFIX)/lib/$(LIBNAME)
		install -m 755 -s $(NAME) $(PREFIX)/lib/$(NAME)
		rm -f $(PREFIX)/lib/$(SONAME) $(PREFIX)/lib/$(PLAINNAME)
		ln -s $(PREFIX)/lib/$(NAME) $(PREFIX)/lib/$(SONAME);\
		ln -s $(PREFIX)/lib/$(SONAME) $(PREFIX)/lib/$(PLAINNAME);\
		ldconfig

uninstall:
		rm -f $(PREFIX)/include/ezV24/*
		rmdir $(PREFIX)/include/ezV24
		rm -f $(PREFIX)/lib/$(LIBNAME)
		rm -f $(PREFIX)/lib/$(NAME)
		rm -f $(PREFIX)/lib/$(SONAME) $(PREFIX)/lib/$(PLAINNAME)
		ldconfig


# This entry is for packing a distribution tarball
#
tarball:
		if test -d $(PROJECTNAME); then\
		  rm -fR $(PROJECTNAME)/*;\
		  rmdir $(PROJECTNAME);\
		fi
		mkdir $(PROJECTNAME)
		cp ezV24.h ezV24_config.h ezV24.c $(PROJECTNAME)/
		cp snprintf.h snprintf.c test-v24.c $(PROJECTNAME)/
		cp Makefile Makefile.cygwin README $(PROJECTNAME)/
		cp AUTHORS HISTORY COPY* BUGS $(PROJECTNAME)/
		cp doc++.conf manual.dxx $(PROJECTNAME)/
		cp -r --parents api-html $(PROJECTNAME)/
		tar cfz $(PROJECTNAME).tar.gz $(PROJECTNAME)
		rm -fR $(PROJECTNAME)/*
		rmdir $(PROJECTNAME)

# build the api reference
#
api-ref:	doc++.conf manual.dxx ezV24.h
		doc++

# The ezV24-Test program. To compile this file, the library must be
# installed!

test-v24:	test-v24.c ezV24.h
		gcc -o test-v24 -Wall test-v24.c -l$(SOBASE)
#		# to use the static library call:
#		# gcc -o test-v24 -Wall test-v24.c -L./ $(LIBNAME)


# --------------------------------------------------------------------------
# ANDERE AUFGABEN
# --------------------------------------------------------------------------

clean:
		rm -f *.o core

clean-all:
		rm -f *.o core $(NAME) $(LIBNAME)
		rm -f $(PROJECTNAME).tar.gz
		rm -f api-html/*
		rmdir api-html


# --[end of file]-----------------------------------------------------------

