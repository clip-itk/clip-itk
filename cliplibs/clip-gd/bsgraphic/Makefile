CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -b

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

GDLIB  = libclip-gd.a
GDSLIB = libclip-gd$(DLLSUFF)
GDLIBREAL = libclip-gd$(DLLREALSUFF)

OBJS  =  circle.o hist.o bgtools.o histcumul.o histnorm.o hist3d.o line.o linecumul.o linenorm.o ring.o bggraph.o
.SUFFIXES: .prg .o .po

all: $(OBJS)

clean:
	rm -rf *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak *~ core* *core
	rm -rf *.ex *.nm

test: test.prg
	$(CLIP) $(CLIPFLAGS) -e -M test.prg -lclip-gd
	rm -f test.log

circle.o: circle.prg
	$(CLIP) $(CLIPFLAGS) circle.prg $(GDSLIB)
circle.po: circle.prg
	$(CLIP) $(CLIPFLAGS)  -p circle.prg $(GDSLIB)

hist.o: hist.prg
	$(CLIP) $(CLIPFLAGS) hist.prg $(GDSLIB)
hist.po: hist.prg
	$(CLIP) $(CLIPFLAGS)  -p hist.prg $(GDSLIB)

histcumul.o: histcumul.prg
	$(CLIP) $(CLIPFLAGS) histcumul.prg $(GDSLIB)
histcumul.po: histcumul.prg
	$(CLIP) $(CLIPFLAGS)  -p histcumul.prg $(GDSLIB)

histnorm.o: histnorm.prg
	$(CLIP) $(CLIPFLAGS) histnorm.prg $(GDSLIB)
histnorm.po: histnorm.prg
	$(CLIP) $(CLIPFLAGS)  -p histnorm.prg $(GDSLIB)

hist3d.o: hist3d.prg
	$(CLIP) $(CLIPFLAGS) hist3d.prg $(GDSLIB)
hist3d.po: hist3d.prg
	$(CLIP) $(CLIPFLAGS)  -p hist3d.prg $(GDSLIB)

line.o: line.prg
	$(CLIP) $(CLIPFLAGS) line.prg $(GDSLIB)
line.po: line.prg
	$(CLIP) $(CLIPFLAGS)  -p line.prg $(GDSLIB)

linecumul.o: linecumul.prg
	$(CLIP) $(CLIPFLAGS) linecumul.prg $(GDSLIB)
linecumul.po: linecumul.prg
	$(CLIP) $(CLIPFLAGS)  -p linecumul.prg $(GDSLIB)

linenorm.o: linenorm.prg
	$(CLIP) $(CLIPFLAGS) linenorm.prg $(GDSLIB)
linenorm.po: linenorm.prg
	$(CLIP) $(CLIPFLAGS)  -p linenorm.prg $(GDSLIB)

ring.o: ring.prg
	$(CLIP) $(CLIPFLAGS) ring.prg $(GDSLIB)
ring.po: ring.prg
	$(CLIP) $(CLIPFLAGS)  -p ring.prg $(GDSLIB)

bgtools.o: bgtools.prg
	$(CLIP) $(CLIPFLAGS) bgtools.prg $(GDSLIB)
bgtools.po: bgtools.prg
	$(CLIP) $(CLIPFLAGS) -p bgtools.prg $(GDSLIB)

bggraph.o: bggraph.prg
	$(CLIP) $(CLIPFLAGS) bggraph.prg $(GDSLIB)
bggraph.po: bggraph.prg
	$(CLIP) $(CLIPFLAGS) -p bggraph.prg $(GDSLIB)


