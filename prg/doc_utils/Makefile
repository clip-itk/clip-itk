ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -v2 -l -a -O -n -I .. -I $(CLIPROOT)/include
CLIPLIBS  =

LIBS  =
OBJS  =

.SUFFIXES: .prg .o

all: ftosgml$(EXESUFF) ctosgml$(EXESUFF)

ftosgml$(EXESUFF):	ftosgml.prg $(OBJS)
	$(CLIP) -esl ftosgml.prg $(OBJS) $(LIBS)

ctosgml$(EXESUFF):	ctosgml.prg $(OBJS)
	$(CLIP) -esl ctosgml.prg $(OBJS) $(LIBS)

clean:
	rm -rf *.o *.ppo *.c *.s *.a *.so *.b *.BAK *.bak *.log ftosgml ctosgml *~ core* *core
	rm -rf *.ex *.nm *.exe

install:
	cp ftosgml$(EXESUFF) $(CLIPROOT)/bin/ftosgml$(EXESUFF)
	cp ctosgml$(EXESUFF) $(CLIPROOT)/bin/ctosgml$(EXESUFF)

#.prg.o:
#	$(CLIP) $(CLIPFLAGS) $<

#.prg.po:
#	$(CLIP) $(CLIPFLAGS) -p $<
