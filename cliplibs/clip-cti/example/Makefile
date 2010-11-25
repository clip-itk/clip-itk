ifdef CLIPROOT
	CLIP	= $(CLIPROOT)/bin/clip
	CLIPFLAGS = -nwgl
else
	CLIP=clip
	CLIPFLAGS = -nw
endif
CLIPLIBS  =-lclip-cti
OBJS  =
ADD_OBJS =
POBJS  =
.SUFFIXES: .prg .o .po

all: ctitest ctifd browsecombo

clean:
	rm -rf *.o *.c *.a *.so *.po *.pa *.log *.b *.ex *.exe *.nm *.BAK *.bak *~ core* *core
	rm -f ctitest ctifd browsecombo

ctitest: ctitest.prg $(OBJS)
	$(CLIP) -swe ctitest.prg $(OBJS) $(ADD_OBJS) $(CLIPLIBS)

ctifd: ctifd.prg $(OBJS)
	$(CLIP) -swe -M  ctifd.prg $(OBJS) $(ADD_OBJS) $(CLIPLIBS)

ctit: ctit.prg $(OBJS)
#	$(CLIP) -swe -M  ctit.prg $(OBJS) $(ADD_OBJS) $(CLIPLIBS)
	$(CLIP) -swe  ctit.prg $(OBJS) $(ADD_OBJS) $(CLIPLIBS) -lclip-fw

browsecombo: browsecombo.prg $(OBJS)
	$(CLIP) -swe browsecombo.prg $(OBJS) $(ADD_OBJS) $(CLIPLIBS)

depend:
	makedepend -w80 -- *.prg 2>/dev/null

.prg.o:
	$(CLIP) $(CLIPFLAGS) $< $(CLIPLIBS)

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $< $(CLIPLIBS)

