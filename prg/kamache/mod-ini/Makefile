ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -pw
MODULES = kmch_hello.po mk_tmpdir.po #kmch_codb.po
.SUFFIXES: .prg .o .po

all: $(MODULES)

clean:
	rm -rf *.ex *.nm *.c *.s *.po *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core

install:
	mkdir -p $(DESTDIR)$(CLIPROOT)/kamache/mod-ini
	cp Makefile *.po *.prg $(DESTDIR)$(CLIPROOT)/kamache/mod-ini

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) $<

