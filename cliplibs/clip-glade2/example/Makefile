# Make for eglade


ifndef CLIPROOT
        CLIPROOT=/usr/local/clip
endif

CCLIP=$(CLIPROOT)/bin/clip

include $(CLIPROOT)/include/Makefile.inc

PRGFLAGS=-w -l

PRGLIBS=-lclip-gtk2 -lclip-glade2

OBJS=dlgopen.o dlgsave.o dlgselfont.o dlgabout.o


.SUFFIXES: .prg .o

all: eglade


eglade: eglade.prg  $(OBJS)
	 $(CCLIP) $(PRGFLAGS) -e $^  $(PRGLIBS)

clean:
	rm -f eglade *.o *.log *~ *.ex *.nm *.po *core


.prg.o:
	$(CCLIP)  -n $(PRGFLAGS) $<

