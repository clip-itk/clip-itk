CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -b -n
CLIPLIBS  =
OBJS  =  procs1.o procs3.o procs5.o procs7.o \
	 procs8.o procini.o procscri.o \
	 procared.o procsay.o

.SUFFIXES: .prg .o

all:    $(OBJS)
	$(CLIPROOT)/bin/clip_makelib ../procs.a *.o
	rm -rf *.c

clean:
	rm -rf *.uri *.o *.c *.s *.a *.so *.po *.pa *.b *.BAK *.bak *~ core* *core *.log *.ex *.nm

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<
