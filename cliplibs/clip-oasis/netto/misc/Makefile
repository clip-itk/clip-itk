include $(CLIPROOT)/include/Makefile.inc

CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -n -I .. -I ../include
CLIPLIBS  =
OBJS  = fnbin2i.o fnbit.o fndpve.o fnerr.o fnhex.o fnpeek.o \
	fnpfeval.o is3x.o isnet.o namel.o nonull.o \
	nwdate.o reg2l.o ssfp.o \
	ipxinit.o request.o

.SUFFIXES: .prg .o

all:    $(OBJS)
	$(CLIPROOT)/bin/clip_makelib ../libclip-netto.a *.o
	rm -rf *.c

clean:
	rm -rf *.o *.c *.s *.a *.so *.b *.BAK *.bak *~ core* *core *.ex *.nm


.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

