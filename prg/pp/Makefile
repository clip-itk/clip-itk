ifndef CLIPROOT
CLIPROOT:=$(shell cd ../../../cliproot;pwd)
endif
include $(CLIPROOT)/include/Makefile.inc
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O
CLIPLIBS  =

pp$(EXESUFF):	pp.prg
	$(CLIP) $(CLIPFLAGS) -e -s pp.prg $(CLIPLIBS)

install:
	cp pp$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/pp_ron$(EXESUFF)
	cp *.ch $(DESTDIR)$(CLIPROOT)/include

clean:
	rm -f *.exe *.so *.c *.s *.o *.po *.bak *.uri *.log *.ntx *.pa pp *.pp?
	rm -f *.ex *.nm

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<
