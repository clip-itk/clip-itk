ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -s -l

all:		clip_hindex$(EXESUFF) clip_hseek$(EXESUFF)
install:	all
	cp clip_hindex$(EXESUFF) $(CLIPROOT)/bin/clip_hindex$(EXESUFF)
	cp clip_hseek$(EXESUFF) $(CLIPROOT)/bin/clip_hseek$(EXESUFF)


clean:
	rm -rf clip_hindex clip_hseek *.exe *.s *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak *~ core* *core
	rm -rf *.ex *.nm

clip_hindex$(EXESUFF):	clip_hindex.prg
	$(CLIP) $(CLIPFLAGS) -e clip_hindex.prg

clip_hseek$(EXESUFF):	clip_hseek.prg
	$(CLIP) $(CLIPFLAGS) -e clip_hseek.prg
