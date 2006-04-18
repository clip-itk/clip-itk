ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

ifdef CLIPROOT
	CLIP = $(CLIPROOT)/bin/clip
	CLIP_MAKESLIB = $(CLIPROOT)/bin/clip_makeslib
	CLIPFLAGS = -nwl -I./include
	include $(CLIPROOT)/include/Makefile.inc
else
	CLIP = clip
	CLIP_MAKESLIB = clip_makeslib
	CLIPFLAGS = -nwl -I./include
endif

OBJS  =	ctiapp.o ctibin.o ctibox.o ctibrowsecombo.o cticalendar.o \
	cticheckbox.o cticontainer.o cticontrol.o ctientry.o ctievents.o \
	ctifiled.o ctifuncs.o ctihbox.o ctilabel.o ctilayout.o ctilist.o \
	ctimain.o ctimenubar.o ctimenuitem.o ctimenu.o ctimenushell.o \
	ctiobjectlist.o ctiobject.o ctioptionmenu.o ctipalette.o \
	ctipushbutton.o ctiradiobutton.o ctiradiogroup.o ctisignal.o \
	ctistatusbar.o ctitbrowse.o ctivbox.o ctiwidget.o ctiwindow.o ctizorder.o

LIB_NAME = libclip-cti

CLIPLIBS =
ADD_OBJS =
POBJS	=
LIB 	= $(LIB_NAME).a
SLIB	= $(LIB_NAME)$(DLLSUFF)
SLIBREAL = $(LIB_NAME)$(DLLREALSUFF)
.SUFFIXES: .prg .o .po

all: links rm_include $(OBJS) $(LIB) $(SLIB)

d: set_dbg

export CFLAGS

set_dbg: CLIPDBGFLAG=-g
set_dbg: all

example_clean:
	-cd example && $(MAKE) clean

test_clean:
	-cd test && $(MAKE) clean

clean: example_clean
	rm -rf *.o *.c *.s *.a *.so *.po *.pa *.log *.b *.BAK *.bak include/*.bak \
	include/*.BAK *~ core* *core *.ex *.nm

commit:
	_cvs commit .

update:
	_cvs update -dP
	make depend

ucommit: update commit

depend:
	makedepend -w80 -I./include -- *.prg 2>/dev/null

install:
	$(CLIPROOT)/bin/clip_cp libclip-cti $(DESTDIR)$(CLIPROOT)/lib
	chmod 0755  $(DESTDIR)$(CLIPROOT)/lib/$(SLIB)
	[ "$(SLIBREAL)" = "$(SLIB)" ] || cp $(SLIBREAL) $(DESTDIR)$(CLIPROOT)/lib
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/example/clip-cti
	cp example/*.prg example/Makefile example/test.dbf $(DESTDIR)$(CLIPROOT)/doc/example/clip-cti
	mkdir -p $(DESTDIR)$(CLIPROOT)/include/cti
	cp include/*.ch $(DESTDIR)$(CLIPROOT)/include/cti
	cp include/cti.ch $(DESTDIR)$(CLIPROOT)/include
	-cp ./.calendar $(DESTDIR)$(CLIPROOT)/etc

rm_include:
	rm -rf $(CLIPROOT)/include/cti
	rm -f $(CLIPROOT)/cti.ch

links:
	#[ -d include/cti ] || (cd include && ln -sf . cti)

$(LIB): $(OBJS)
	rm -f $(LIB)
	$(CLIPROOT)/bin/clip_makelib $(LIB) $(OBJS)

$(SLIB): $(LIB)
	$(CLIP_MAKESLIB) $(SLIB) $(LIB)

.prg.o:
	$(CLIP) $(CLIPFLAGS) $(CLIPDBGFLAG) $< $(CLIPLIBS)

.prg.po:
	$(CLIP) $(CLIPFLAGS) $(CLIPDBGFLAG) -p $< $(CLIPLIBS)

arc: example_clean test_clean clean
	tar cjfv cti.tar.bz2 . --exclude cti.tar.bz2 --exclude *.bak --exclude *.o

# DO NOT DELETE

ctiapp.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctiapp.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctiapp.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctiapp.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctiapp.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctiapp.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctiapp.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctiapp.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctiapp.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctiapp.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctiapp.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctiapp.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctiapp.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctiapp.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctiapp.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctiapp.o: ./include/cti/ctizorder.ch
ctibin.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctibin.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctibin.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctibin.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctibin.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctibin.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctibin.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctibin.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctibin.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctibin.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctibin.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctibin.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctibin.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctibin.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctibin.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctibin.o: ./include/cti/ctizorder.ch
ctibox.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctibox.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctibox.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctibox.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctibox.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctibox.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctibox.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctibox.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctibox.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctibox.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctibox.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctibox.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctibox.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctibox.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctibox.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctibox.o: ./include/cti/ctizorder.ch
ctibrowsecombo.o: ./include/cti.ch ./include/cti/clipcti.ch
ctibrowsecombo.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
ctibrowsecombo.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
ctibrowsecombo.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
ctibrowsecombo.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
ctibrowsecombo.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
ctibrowsecombo.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
ctibrowsecombo.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
ctibrowsecombo.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
ctibrowsecombo.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
ctibrowsecombo.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
ctibrowsecombo.o: ./include/cti/ctipushbutton.ch
ctibrowsecombo.o: ./include/cti/ctiradiobutton.ch
ctibrowsecombo.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
ctibrowsecombo.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
ctibrowsecombo.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
ctibrowsecombo.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
cticalendar.o: ./include/cti.ch ./include/cti/clipcti.ch
cticalendar.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
cticalendar.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
cticalendar.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
cticalendar.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
cticalendar.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
cticalendar.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
cticalendar.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
cticalendar.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
cticalendar.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
cticalendar.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
cticalendar.o: ./include/cti/ctipushbutton.ch ./include/cti/ctiradiobutton.ch
cticalendar.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
cticalendar.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
cticalendar.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
cticalendar.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
cticalendar.o: ./include/ctievents.ch
cticheckbox.o: ./include/cti.ch ./include/cti/clipcti.ch
cticheckbox.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
cticheckbox.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
cticheckbox.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
cticheckbox.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
cticheckbox.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
cticheckbox.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
cticheckbox.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
cticheckbox.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
cticheckbox.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
cticheckbox.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
cticheckbox.o: ./include/cti/ctipushbutton.ch ./include/cti/ctiradiobutton.ch
cticheckbox.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
cticheckbox.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
cticheckbox.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
cticheckbox.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
cticontainer.o: ./include/cti.ch ./include/cti/clipcti.ch
cticontainer.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
cticontainer.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
cticontainer.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
cticontainer.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
cticontainer.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
cticontainer.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
cticontainer.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
cticontainer.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
cticontainer.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
cticontainer.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
cticontainer.o: ./include/cti/ctipushbutton.ch ./include/cti/ctiradiobutton.ch
cticontainer.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
cticontainer.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
cticontainer.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
cticontainer.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
cticontrol.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
cticontrol.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
cticontrol.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
cticontrol.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
cticontrol.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
cticontrol.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
cticontrol.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
cticontrol.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
cticontrol.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
cticontrol.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
cticontrol.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
cticontrol.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
cticontrol.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
cticontrol.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
cticontrol.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
cticontrol.o: ./include/cti/ctizorder.ch
ctientry.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctientry.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctientry.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctientry.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctientry.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctientry.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctientry.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctientry.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctientry.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctientry.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctientry.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctientry.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctientry.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctientry.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctientry.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctientry.o: ./include/cti/ctizorder.ch
ctievents.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctievents.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctievents.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctievents.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctievents.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctievents.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctievents.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctievents.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctievents.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctievents.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctievents.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctievents.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctievents.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctievents.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctievents.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctievents.o: ./include/cti/ctizorder.ch
ctifiled.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctifiled.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctifiled.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctifiled.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctifiled.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctifiled.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctifiled.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctifiled.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctifiled.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctifiled.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctifiled.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctifiled.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctifiled.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctifiled.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctifiled.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctifiled.o: ./include/cti/ctizorder.ch ./include/ctievents.ch
ctifuncs.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctifuncs.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctifuncs.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctifuncs.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctifuncs.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctifuncs.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctifuncs.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctifuncs.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctifuncs.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctifuncs.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctifuncs.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctifuncs.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctifuncs.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctifuncs.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctifuncs.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctifuncs.o: ./include/cti/ctizorder.ch
ctihbox.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctihbox.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctihbox.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctihbox.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctihbox.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctihbox.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctihbox.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctihbox.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctihbox.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctihbox.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctihbox.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctihbox.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctihbox.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctihbox.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctihbox.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctihbox.o: ./include/cti/ctizorder.ch
ctilabel.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctilabel.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctilabel.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctilabel.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctilabel.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctilabel.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctilabel.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctilabel.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctilabel.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctilabel.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctilabel.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctilabel.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctilabel.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctilabel.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctilabel.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctilabel.o: ./include/cti/ctizorder.ch
ctilayout.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctilayout.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctilayout.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctilayout.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctilayout.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctilayout.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctilayout.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctilayout.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctilayout.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctilayout.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctilayout.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctilayout.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctilayout.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctilayout.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctilayout.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctilayout.o: ./include/cti/ctizorder.ch
ctilist.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctilist.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctilist.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctilist.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctilist.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctilist.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctilist.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctilist.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctilist.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctilist.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctilist.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctilist.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctilist.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctilist.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctilist.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctilist.o: ./include/cti/ctizorder.ch
ctimain.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctimain.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctimain.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctimain.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctimain.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctimain.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctimain.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctimain.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctimain.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctimain.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctimain.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctimain.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctimain.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctimain.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctimain.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctimain.o: ./include/cti/ctizorder.ch
ctimenubar.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctimenubar.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctimenubar.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctimenubar.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctimenubar.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctimenubar.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctimenubar.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctimenubar.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctimenubar.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctimenubar.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctimenubar.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctimenubar.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctimenubar.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctimenubar.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctimenubar.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctimenubar.o: ./include/cti/ctizorder.ch
ctimenuitem.o: ./include/cti.ch ./include/cti/clipcti.ch
ctimenuitem.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
ctimenuitem.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
ctimenuitem.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
ctimenuitem.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
ctimenuitem.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
ctimenuitem.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
ctimenuitem.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
ctimenuitem.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
ctimenuitem.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
ctimenuitem.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
ctimenuitem.o: ./include/cti/ctipushbutton.ch ./include/cti/ctiradiobutton.ch
ctimenuitem.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
ctimenuitem.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
ctimenuitem.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
ctimenuitem.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
ctimenu.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctimenu.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctimenu.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctimenu.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctimenu.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctimenu.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctimenu.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctimenu.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctimenu.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctimenu.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctimenu.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctimenu.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctimenu.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctimenu.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctimenu.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctimenu.o: ./include/cti/ctizorder.ch
ctimenushell.o: ./include/cti.ch ./include/cti/clipcti.ch
ctimenushell.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
ctimenushell.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
ctimenushell.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
ctimenushell.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
ctimenushell.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
ctimenushell.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
ctimenushell.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
ctimenushell.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
ctimenushell.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
ctimenushell.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
ctimenushell.o: ./include/cti/ctipushbutton.ch ./include/cti/ctiradiobutton.ch
ctimenushell.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
ctimenushell.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
ctimenushell.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
ctimenushell.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
ctiobjectlist.o: ./include/cti.ch ./include/cti/clipcti.ch
ctiobjectlist.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
ctiobjectlist.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
ctiobjectlist.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
ctiobjectlist.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
ctiobjectlist.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
ctiobjectlist.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
ctiobjectlist.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
ctiobjectlist.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
ctiobjectlist.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
ctiobjectlist.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
ctiobjectlist.o: ./include/cti/ctipushbutton.ch ./include/cti/ctiradiobutton.ch
ctiobjectlist.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
ctiobjectlist.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
ctiobjectlist.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
ctiobjectlist.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
ctiobject.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctiobject.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctiobject.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctiobject.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctiobject.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctiobject.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctiobject.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctiobject.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctiobject.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctiobject.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctiobject.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctiobject.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctiobject.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctiobject.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctiobject.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctiobject.o: ./include/cti/ctizorder.ch
ctioptionmenu.o: ./include/cti.ch ./include/cti/clipcti.ch
ctioptionmenu.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
ctioptionmenu.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
ctioptionmenu.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
ctioptionmenu.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
ctioptionmenu.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
ctioptionmenu.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
ctioptionmenu.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
ctioptionmenu.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
ctioptionmenu.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
ctioptionmenu.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
ctioptionmenu.o: ./include/cti/ctipushbutton.ch ./include/cti/ctiradiobutton.ch
ctioptionmenu.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
ctioptionmenu.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
ctioptionmenu.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
ctioptionmenu.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
ctipushbutton.o: ./include/cti.ch ./include/cti/clipcti.ch
ctipushbutton.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
ctipushbutton.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
ctipushbutton.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
ctipushbutton.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
ctipushbutton.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
ctipushbutton.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
ctipushbutton.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
ctipushbutton.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
ctipushbutton.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
ctipushbutton.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
ctipushbutton.o: ./include/cti/ctipushbutton.ch ./include/cti/ctiradiobutton.ch
ctipushbutton.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
ctipushbutton.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
ctipushbutton.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
ctipushbutton.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
ctiradiobutton.o: ./include/cti.ch ./include/cti/clipcti.ch
ctiradiobutton.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
ctiradiobutton.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
ctiradiobutton.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
ctiradiobutton.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
ctiradiobutton.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
ctiradiobutton.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
ctiradiobutton.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
ctiradiobutton.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
ctiradiobutton.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
ctiradiobutton.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
ctiradiobutton.o: ./include/cti/ctipushbutton.ch
ctiradiobutton.o: ./include/cti/ctiradiobutton.ch
ctiradiobutton.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
ctiradiobutton.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
ctiradiobutton.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
ctiradiobutton.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
ctiradiogroup.o: ./include/cti.ch ./include/cti/clipcti.ch
ctiradiogroup.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
ctiradiogroup.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
ctiradiogroup.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
ctiradiogroup.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
ctiradiogroup.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
ctiradiogroup.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
ctiradiogroup.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
ctiradiogroup.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
ctiradiogroup.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
ctiradiogroup.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
ctiradiogroup.o: ./include/cti/ctipushbutton.ch ./include/cti/ctiradiobutton.ch
ctiradiogroup.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
ctiradiogroup.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
ctiradiogroup.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
ctiradiogroup.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
ctisignal.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctisignal.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctisignal.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctisignal.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctisignal.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctisignal.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctisignal.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctisignal.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctisignal.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctisignal.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctisignal.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctisignal.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctisignal.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctisignal.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctisignal.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctisignal.o: ./include/cti/ctizorder.ch
ctistatusbar.o: ./include/cti.ch ./include/cti/clipcti.ch
ctistatusbar.o: ./include/cti/ctiapp.ch ./include/cti/ctibin.ch
ctistatusbar.o: ./include/cti/ctibox.ch ./include/cti/ctibrowsecombo.ch
ctistatusbar.o: ./include/cti/cticheckbox.ch ./include/cti/cticontainer.ch
ctistatusbar.o: ./include/cti/cticontrol.ch ./include/cti/ctientry.ch
ctistatusbar.o: ./include/cti/ctievents.ch ./include/cti/ctihbox.ch
ctistatusbar.o: ./include/cti/ctilabel.ch ./include/cti/ctilayout.ch
ctistatusbar.o: ./include/cti/ctilist.ch ./include/cti/ctimenubar.ch
ctistatusbar.o: ./include/cti/ctimenu.ch ./include/cti/ctimenuitem.ch
ctistatusbar.o: ./include/cti/ctimenushell.ch ./include/cti/ctiobject.ch
ctistatusbar.o: ./include/cti/ctioptionmenu.ch ./include/cti/ctipopupmenu.ch
ctistatusbar.o: ./include/cti/ctipushbutton.ch ./include/cti/ctiradiobutton.ch
ctistatusbar.o: ./include/cti/ctiradiogroup.ch ./include/cti/ctisignal.ch
ctistatusbar.o: ./include/cti/ctistatusbar.ch ./include/cti/ctitbrowse.ch
ctistatusbar.o: ./include/cti/ctivbox.ch ./include/cti/ctiwidget.ch
ctistatusbar.o: ./include/cti/ctiwindow.ch ./include/cti/ctizorder.ch
ctitbrowse.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctitbrowse.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctitbrowse.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctitbrowse.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctitbrowse.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctitbrowse.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctitbrowse.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctitbrowse.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctitbrowse.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctitbrowse.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctitbrowse.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctitbrowse.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctitbrowse.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctitbrowse.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctitbrowse.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctitbrowse.o: ./include/cti/ctizorder.ch
ctivbox.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctivbox.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctivbox.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctivbox.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctivbox.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctivbox.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctivbox.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctivbox.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctivbox.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctivbox.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctivbox.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctivbox.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctivbox.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctivbox.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctivbox.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctivbox.o: ./include/cti/ctizorder.ch
ctiwidget.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctiwidget.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctiwidget.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctiwidget.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctiwidget.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctiwidget.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctiwidget.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctiwidget.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctiwidget.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctiwidget.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctiwidget.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctiwidget.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctiwidget.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctiwidget.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctiwidget.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctiwidget.o: ./include/cti/ctizorder.ch
ctiwindow.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctiwindow.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctiwindow.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctiwindow.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctiwindow.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctiwindow.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctiwindow.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctiwindow.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctiwindow.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctiwindow.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctiwindow.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctiwindow.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctiwindow.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctiwindow.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctiwindow.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctiwindow.o: ./include/cti/ctizorder.ch
ctizorder.o: ./include/cti.ch ./include/cti/clipcti.ch ./include/cti/ctiapp.ch
ctizorder.o: ./include/cti/ctibin.ch ./include/cti/ctibox.ch
ctizorder.o: ./include/cti/ctibrowsecombo.ch ./include/cti/cticheckbox.ch
ctizorder.o: ./include/cti/cticontainer.ch ./include/cti/cticontrol.ch
ctizorder.o: ./include/cti/ctientry.ch ./include/cti/ctievents.ch
ctizorder.o: ./include/cti/ctihbox.ch ./include/cti/ctilabel.ch
ctizorder.o: ./include/cti/ctilayout.ch ./include/cti/ctilist.ch
ctizorder.o: ./include/cti/ctimenubar.ch ./include/cti/ctimenu.ch
ctizorder.o: ./include/cti/ctimenuitem.ch ./include/cti/ctimenushell.ch
ctizorder.o: ./include/cti/ctiobject.ch ./include/cti/ctioptionmenu.ch
ctizorder.o: ./include/cti/ctipopupmenu.ch ./include/cti/ctipushbutton.ch
ctizorder.o: ./include/cti/ctiradiobutton.ch ./include/cti/ctiradiogroup.ch
ctizorder.o: ./include/cti/ctisignal.ch ./include/cti/ctistatusbar.ch
ctizorder.o: ./include/cti/ctitbrowse.ch ./include/cti/ctivbox.ch
ctizorder.o: ./include/cti/ctiwidget.ch ./include/cti/ctiwindow.ch
ctizorder.o: ./include/cti/ctizorder.ch
