ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -Obl -I./include
CLIPLIBS  = -lclip-codb -lclip-gtk

OBJS  = abx_obj.o abx_menu.o abx_events.o abx_funcs.o abx_meta_browse.o abx_getobj.o \
	abx_data_browse.o

BIN = codb_abx

.SUFFIXES: .prg .o .po

all: $(BIN)

install: all
	mkdir -p $(DESTDIR)$(CLIPROOT)/codb_abx/plugins
	tar cf - plugins | (cd $(DESTDIR)$(CLIPROOT)/codb_abx && tar xf -)
	#cp plugins/*.prg $(DESTDIR)$(CLIPROOT)/codb_abx/plugins
	#cp plugins/*.po $(DESTDIR)$(CLIPROOT)/codb_abx/plugins
	[ ! -f codb_abx$(EXESUFF) ] || ( cp codb_abx$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/ )
	#cp codb_abx$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/

clean:
	rm -rf *.exe *.o *.c *.s *.a *.so *.po *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core $(BIN)
	rm -rf *.ex *.nm
	cd plugins && rm -rf *.out *.ex *.nm *.po *.bak

$(BIN): $(BIN).prg $(OBJS)
	[ ! -f $(CLIPROOT)/include/clip-gtk.ch ] || ( cd plugins; $(CLIP) -pw *.prg )
	[ ! -f $(CLIPROOT)/include/clip-gtk.ch ] || ( $(CLIP) $(CLIPFLAGS) -se $(BIN).prg $(OBJS) $(CLIPLIBS) )

commit:
	_cvs commit

.prg.o:
	[ ! -f $(CLIPROOT)/include/clip-gtk.ch ] || ( $(CLIP) $(CLIPFLAGS) $< )

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<
