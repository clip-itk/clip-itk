ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -pw
MODULES = cobra_hello.po cobra_codb.po cobra_mod.po mk_tmpdir.po
.SUFFIXES: .prg .o .po

all: $(MODULES)

clean:
	rm -rf *.ex *.nm *.c *.s *.po *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) $<

