# Generated automatically from Makefile.in by configure.
###############################################################################
# Makefile for the Malloc library.
# $Id$
###############################################################################

# default root installation directory
prefix = /usr/local

srcdir = .
bindir = $(prefix)/bin
libdir = $(prefix)/lib
incdir = $(prefix)/inc
infodir = $(prefix)/info

# default c-compiler
CC = gcc

DEFS =
INCS = -I$(srcdir)
LIBS =  -L$(srcdir) memdebug.a

LIBRARY	= memdebug.a
UTIL = malloc_dbg
INFOFILE = malloc.info

CCFLAGS = -g
LDFLAGS = -g

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

###############################################################################
# End of system configuration section.
###############################################################################

SHELL = /bin/sh

HFLS = malloc.h
OBJS = chunk.o compat.o error.o heap.o malloc.o malloc_lp.o malloc_str.o

CFLAGS = $(CCFLAGS)
TESTS = malloc_t

# .PHONY : all
all : $(LIBRARY) $(UTIL)

# .PHONY : clean
clean :
	rm -f a.out core *.o *.t *.a

# .PHONY : clobber
clobber : clean
	rm -f $(LIBRARY) $(TESTS) $(UTIL)

# .PHONY : realclean
realclean : clobber

# .PHONY : distclean
distclean : clobber
	rm -f Makefile conf.h config.status
#	rm -f configure

# .PHONY : install
install : $(HFLS) $(UTIL) $(LIBRARY) $(INFOFILES)
	$(INSTALL_DATA) $(HFLS) $(incdir)
	$(INSTALL_PROGRAM) $(UTIL) $(bindir)
	$(INSTALL_DATA) $(LIBRARY) $(libdir)
	ranlib $(libdir)/$(LIBRARY)
#	$(INSTALL_DATA) $(INFOFILES) $(infodir)

$(LIBRARY) : $(OBJS)
	ar cr $(LIBRARY) $?
	ranlib $@
	- chmod 660 $@

$(UTIL) : malloc_dbg.o $(LIBRARY)
	rm -f $@
	$(CC) $(LDFLAGS) $@.o $(LIBS)
	mv a.out $@

# .PHONY : tests
tests : $(TESTS)

malloc_t : malloc_t.o $(LIBRARY)
	rm -f $@
	$(CC) $(LDFLAGS) malloc_t.o $(LIBS)
	mv a.out $@

.c.o :
	rm -f $@
	$(CC) $(CFLAGS) $(CPPFLAGS) $(DEFS) $(INCS) -c $< -o $@

.texi.info :
	makeinfo $<

###############################################################################
#
# These dependencies are automatically generated.  Do not edit by hand.
#

chunk.o : chunk.c malloc.h malloc_loc.h chunk.h chunk_loc.h compat.h conf.h \
  dbg_values.h error.h error_val.h heap.h version.h
compat.o : compat.c malloc.h malloc_loc.h compat.h conf.h
error.o : error.c malloc.h malloc_loc.h chunk.h compat.h conf.h dbg_values.h \
  error.h
heap.o : heap.c malloc.h malloc_loc.h chunk.h compat.h conf.h error.h error_val.h \
  heap.h
malloc.o : malloc.c malloc.h malloc_loc.h chunk.h compat.h conf.h dbg_values.h \
  error.h error_str.h error_val.h heap.h malloc_lp.h
malloc_dbg.o : malloc_dbg.c malloc.h malloc_loc.h compat.h conf.h dbg_tokens.h \
  dbg_values.h version.h
malloc_lp.o : malloc_lp.c malloc.h
malloc_str.o : malloc_str.c malloc.h malloc_loc.h conf.h chunk.h dbg_values.h \
  error.h malloc_str.h
malloc_t.o : malloc_t.c malloc.h
sample.o : sample.c malloc.h

