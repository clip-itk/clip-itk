ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

ifdef CLIPROOT
	CLIP = $(CLIPROOT)/bin/clip
	CLIP_MAKESLIB = $(CLIPROOT)/bin/clip_makeslib
	CLIPFLAGS = -nwl -I./include
	include $(CLIPROOT)/include/Makefile.inc
else
	CLIP = clip
	CLIP_MAKESLIB = clip_makeslib
	CLIPFLAGS = -nw -I./include
endif

OBJS  =	ctiobject.o ctifuncs.o ctievents.o ctisignal.o ctiapp.o \
	ctiwidget.o ctiwindow.o ctizorder.o ctimain.o ctipalette.o \
	cticontrol.o ctientry.o ctipushbutton.o ctimenuitem.o \
	ctimenushell.o ctimenubar.o ctimenu.o ctistatusbar.o \
	ctilabel.o ctitbrowse.o cticheckbox.o ctiradiogroup.o \
	ctiradiobutton.o ctilist.o ctioptionmenu.o

CLIPLIBS =
ADD_OBJS =
POBJS	=
LIB 	= libclip-cti.a
SLIB	= libclip-cti$(DLLSUFF)
SLIBREAL = libclip-cti$(DLLREALSUFF)
.SUFFIXES: .prg .o .po

all: $(OBJS) $(LIB) $(SLIB)

d: set_dbg

set_dbg: CLIPDBGFLAG=-g
set_dbg: all

example_clean:
	-cd example && $(MAKE) clean

test_clean:
	-cd test && $(MAKE) clean

clean: example_clean
	rm -rf *.o *.c *.a *.so *.po *.pa *.log *.b *.BAK *.bak include/*.bak \
	include/*.BAK *~ core* *core *.ex *.nm 

commit:
	cvs commit .

update:
	cvs update -dP

ucommit: update commit

depend:
	makedepend -w80 -I./include -- *.prg 2>/dev/null

install: all
#	cp $(LIB) $(CLIPROOT)/lib
	$(CLIPROOT)/bin/clip_cp $(SLIB) $(CLIPROOT)/lib
#	chmod 0644  $(CLIPROOT)/lib/$(LIB)
	chmod 0755  $(CLIPROOT)/lib/$(SLIB)
	[ "$(SLIBREAL)" = "$(SLIB)" ] || cp $(SLIBREAL) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/example/clip-cti
	cp example/ctitest.prg example/Makefile example/test.dbf $(CLIPROOT)/doc/example/clip-cti

$(LIB): $(OBJS)
	rm -f $(LIB)
	$(CLIPROOT)/bin/clip_makelib $(LIB) $(OBJS)
	ranlib $(LIB)

$(SLIB): $(LIB)
	$(CLIP_MAKESLIB) $(SLIB) $(LIB) $(CLIPLIBS)

.prg.o:
	$(CLIP) $(CLIPFLAGS) $(CLIPDBGFLAG) $< $(CLIPLIBS)

.prg.po:
	$(CLIP) $(CLIPFLAGS) $(CLIPDBGFLAG) -p $< $(CLIPLIBS)

arc: example_clean test_clean clean
	tar cjfv cti.tar.bz2 . --exclude cti.tar.bz2 --exclude *.bak --exclude *.o

# DO NOT DELETE
