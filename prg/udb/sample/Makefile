CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -b
CLIPLIBS  = -lclip-codb

PROGS = my001 cgi_currency


.SUFFIXES: .prg .o .po

all: $(PROGS)

clean:
	rm -rf *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak *~ core* *core
	rm -rf $(PROGS) *.ex *.nm

my001:  my001.prg
	$(CLIP) $(CLIPFLAGS) -esl -M my001.prg $(CLIPLIBS)

cgi_currency: cgi_currency.prg
	$(CLIP) $(CLIPFLAGS) -e -M cgi_currency.prg $(CLIPLIBS)

