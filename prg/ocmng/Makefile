ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -alwO
CLIPLIBS  = -lclip-codb
OBJS = funcs_a.o funcs_c.o funcs_d.o funcs_i.o funcs_w.o funcs_x.o funcs_r.o
INCS = funcs_s.prg ocmng.ch
PROGS = ocmng$(EXESUFF) xml2xmo$(EXESUFF)
#PROGS = ocmng_compil$(EXESUFF) ocmng_dump$(EXESUFF) ocmng_install$(EXESUFF) ocmng$(EXESUFF)

.SUFFIXES: .prg .o .po

all: $(OBJS) $(PROGS)
	#./xml2xmo --profile components

clean:
	rm -f $(PROGS) *.ex *.nm *.uri *.c *.s *.o *.a *.po *.log *.pro *.pa *.b *.BAK *.bak *~ core* *core
	./cleanxmo.sh

ocmng$(EXESUFF): ocmng.prg  $(OBJS) $(INCS)
	$(CLIP) $(CLIPFLAGS) -esM ocmng.prg $(OBJS) $(CLIPLIBS)

xml2xmo$(EXESUFF): xml2xmo.prg  $(OBJS) $(INCS)
	$(CLIP) $(CLIPFLAGS) -esM xml2xmo.prg $(OBJS) $(CLIPLIBS)

install:
	cp $(PROGS) cleanxmo.sh $(DESTDIR)$(CLIPROOT)/bin

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

