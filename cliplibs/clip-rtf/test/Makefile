INCLUDEDIRS=-I. -I$(CLIPROOT)/include

ifdef CLIPROOT
	CLIP	= $(CLIPROOT)/bin/clip
else
	CLIP = clip
endif
CLIPFLAGS = -l -n -w
CLIPLIBS  =
BINS = rtfdemo

.SUFFIXES: .prg .o .po

all: $(BINS)

rtfdemo: rtfdemo.prg
	$(CLIP) -e -s -l -M rtfdemo.prg -lclip-rtf


clean:
	rm -f *.exe *.c *.o *.po *.log *.bak *.rtf $(BINS) *.ex *.nm

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

