ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -n -a -O -b
CLIPLIBS  = ../procs.a
OBJS  = move.o modistru.o commands.o view.o query.o pechdbc.o prcmenu.o
.SUFFIXES: .prg .o


dbc$(EXESUFF): dbc.prg $(OBJS)
	$(CLIP) $(CLIPFLAGS) -e -s dbc.prg $(OBJS) $(CLIPLIBS)

clean:
	rm -rf *.so *.c *.s *.o *.po *.bak *.uri dbc dbc.exe *.log *.ntx *.ex *.nm

install:
	cp dbc$(EXESUFF) $(CLIPROOT)/bin/

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<
