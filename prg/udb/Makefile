ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -b -w -I ./include
CLIPLIBS  =
#LIBS = ./libclip-codb$(DLLSUFF)
LIBS = -lclip-codb
AB_OBJS  = ab_obj.o ab_menu.o ab_brow.o ab_init.o ab_funcs.o \
		ab_report.o
.SUFFIXES: .prg .o .po

PROGS = codb_pack codb_addobj codb_ab \
	codb_make codb_load codb_export codb_reindex codb_rcheck #test

all: $(PROGS)

commit:
	../_cvs commit
update:
	../_cvs update -dP
clean:
	cd data; rm -f *.bak
	#cd loaders; $(MAKE) clean
	cd sample; $(MAKE) clean
	cd plugins; rm -rf *.po *.bak *.log *.out *.po *core core* *.ex *.nm
	cd reports; rm -rf *.po *.bak *.log *.po *core core* *.ex *.nm
	rm -rf *.exe *.o *.ppo *.c *.s *.a *.so *.dll* *.po *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core
	rm -rf *.pro $(PROGS) test test2
	rm -rf *.ex *.nm

install: all
	mkdir -p $(DESTDIR)$(CLIPROOT)/codb_ab/plugins
	tar cf - plugins | (cd $(DESTDIR)$(CLIPROOT)/codb_ab && tar xf -)
	#cp plugins/*.prg $(DESTDIR)$(CLIPROOT)/codb_ab/plugins
	#cp plugins/*.po $(DESTDIR)$(CLIPROOT)/codb_ab/plugins
	mkdir -p $(DESTDIR)$(CLIPROOT)/codb_ab/reports
	tar cf - reports | (cd $(DESTDIR)$(CLIPROOT)/codb_ab && tar xf -)
	#cp reports/*.prg $(DESTDIR)$(CLIPROOT)/codb_ab/reports
	#cp reports/*.po $(DESTDIR)$(CLIPROOT)/codb_ab/reports
	cp codb_ab$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/
	cp codb_make$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/
	cp codb_load$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/
	cp codb_pack$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/
	cp codb_reindex$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/
	cp codb_rcheck$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/
	cp codb_addobj$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/
	cp codb_export$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin/

test: test.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M test.prg $(CLIPLIBS) $(LIBS)

test2: test2.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M test2.prg $(CLIPLIBS) $(LIBS)

codb_make: codb_make.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M codb_make.prg $(CLIPLIBS) $(LIBS)

codb_load: codb_load.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M codb_load.prg $(CLIPLIBS) $(LIBS)

codb_export: codb_export.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M codb_export.prg $(CLIPLIBS) $(LIBS)

codb_pack: codb_pack.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M codb_pack.prg $(CLIPLIBS) $(LIBS)

codb_reindex: codb_reindex.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M codb_reindex.prg $(CLIPLIBS) $(LIBS)

codb_rcheck: codb_rcheck.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M codb_rcheck.prg $(CLIPLIBS) $(LIBS)

codb_check: codb_check.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M codb_check.prg $(CLIPLIBS) $(LIBS)

codb_addobj: codb_addobj.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M codb_addobj.prg $(CLIPLIBS) $(LIBS)

codb_ab: $(AB_OBJS) codb_ab.prg
	cd plugins; $(CLIP) -pw *.prg
	cd reports; $(CLIP) -pw *.prg
	$(CLIP) $(CLIPFLAGS) -s -e -M codb_ab.prg $(AB_OBJS) $(CLIPLIBS) $(LIBS)

ab_obj.o: ab_obj.prg
	$(CLIP) $(CLIPFLAGS) ab_obj.prg

ab_menu.o: ab_menu.prg
	$(CLIP) $(CLIPFLAGS) ab_menu.prg

ab_brow.o: ab_brow.prg
	$(CLIP) $(CLIPFLAGS) ab_brow.prg

ab_funcs.o: ab_funcs.prg
	$(CLIP) $(CLIPFLAGS) ab_funcs.prg

ab_report.o: ab_report.prg
	$(CLIP) $(CLIPFLAGS) ab_report.prg

ab_init.o: ab_init.prg
	$(CLIP) $(CLIPFLAGS) ab_init.prg

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

