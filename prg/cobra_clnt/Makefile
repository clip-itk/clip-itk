ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
#CLIP	= clip
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -w -O -b -l
CLIPLIBS  = #-lclip-codb
OBJS  = objbrowse.o tviewbrowse.o
.SUFFIXES: .prg .o .po

all: cobra_clnt1

clean:
	rm -rf *.exe *.o *.s *.c *.a *.so *.po *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core
	rm -rf cobra_clnt1 *.ex *.nm

cobra_clnt1:cobra_clnt1.prg $(OBJS)
	$(CLIP) $(CLIPFLAGS) -esl cobra_clnt1.prg $(OBJS) $(CLIPLIBS)

install:
	cp cobra_clnt1$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	mkdir -p $(DESTDIR)$(CLIPROOT)/cobra
	#ln -sf $(DESTDIR)$(CLIPROOT)/bin/cobra_clnt1$(EXESUFF)  $(DESTDIR)$(CLIPROOT)/cobra/cobra_clnt1$(EXESUFF)
	cp cobra_clnt.ini $(DESTDIR)$(CLIPROOT)/cobra

.prg.o:
	$(CLIP) $(CLIPFLAGS) -n $<

