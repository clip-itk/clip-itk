ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -pw
MODULES = hello.po
.SUFFIXES: .prg .o .po

all: $(MODULES)

clean:
	rm -rf *.ex *.nm *.c *.s *.po *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core

install:
	mkdir -p $(DESTDIR)$(CLIPROOT)/kamache/mod-clip
	cp Makefile *.po *.prg $(DESTDIR)$(CLIPROOT)/kamache/mod-clip


.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) $<

