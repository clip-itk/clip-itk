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

all: ctitest

clean:
	rm -rf *.o *.c *.a *.so *.po *.pa *.log *.b *.ex *.nm *.BAK *.bak *~ core* *core ctitest

commit:
	cvs commit

update:
	cvs update -dP

ucommit: update commit

ctitest: ctitest.prg $(OBJS)
	$(CLIP) -esw ctitest.prg $(OBJS) $(ADD_OBJS) $(CLIPLIBS)

depend:
	makedepend -w80 -- *.prg 2>/dev/null

.prg.o:
	$(CLIP) $(CLIPFLAGS) $< $(CLIPLIBS)

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $< $(CLIPLIBS)

