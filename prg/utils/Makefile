ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -b
CLIPLIBS  =
PGLIBS	= libpgclip.a libpq.a libcrypt.a
MSLIBS	= libmsclip.a libmysqlclient.a
ORLIBS	= liborclip.a $(ORACLE_HOME)/lib/libclntsh.so
# WWWLIBS - links all RDBMS libraries. Remove unused ones.
#WWWLIBS	= libdbfsql.a $(PGLIBS) $(MSLIBS) $(ORLIBS)
WWWLIBS	=
POBJS	= menu.po getfile.po
PAOBJS	= menu.po getfile.po
.SUFFIXES: .prg .o .po

all: clip_run clip_prg clip_we clip_bl www_clip wcl2prg clip_blank sqlrun \
	clip_hv clip_fl clip_dbf2txt

clean:
	rm -rf *.uri *.c *.s *.o *.a *.po *.log *.pa *.b *.BAK *.bak *~ core* *core \
		clip_run clip_prg clip_bl www_clip wcl2prg sqlrun \
		clip_blank clip_we clip_hv clip_fl clip_dbf2txt *.exe
	rm -rf *.ex *.nm

clip_run: clip_run.prg
	$(CLIP) $(CLIPFLAGS) -e -M clip_run.prg $(CLIPLIBS)
#	$(CLIP) -p test.prg
#	mv test.po test.po.0
#	#echo "#!./clip_run" >test.po
#	echo "#!"$(CLIPROOT)/bin/clip_run >test.po
#	cat test.po.0 >>test.po
#	chmod +x test.po

install:
	cp clip_run$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	cp clip_prg$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	cp clip_bl$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	cp clip_we$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	cp .macro $(DESTDIR)$(CLIPROOT)/etc
	cp .templ $(DESTDIR)$(CLIPROOT)/etc
	cp clip_hv$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	cp clip_fl$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	cp clip_dbf2txt$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	cp clip_blank$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	cp www_clip$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	cp wcl2prg$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin
	cp sqlrun$(EXESUFF) $(DESTDIR)$(CLIPROOT)/bin


clip_prg: clip_prg.prg
	$(CLIP) $(CLIPFLAGS) -e -M clip_prg.prg $(CLIPLIBS)

clip_bl: clip_bl.prg
	$(CLIP) $(CLIPFLAGS) -e -M clip_bl.prg $(CLIPLIBS)

clip_we: clip_we.prg
	$(CLIP) $(CLIPFLAGS) -e -M clip_we.prg $(CLIPLIBS)

clip_hv: clip_hv.prg
	$(CLIP) $(CLIPFLAGS) -e -M clip_hv.prg $(CLIPLIBS)

clip_fl: clip_fl.prg
	$(CLIP) $(CLIPFLAGS) -e -M clip_fl.prg $(CLIPLIBS)

clip_dbf2txt: clip_dbf2txt.prg
	$(CLIP) $(CLIPFLAGS) -e -M clip_dbf2txt.prg $(CLIPLIBS)

clip_blank: clip_blank.prg
	$(CLIP) $(CLIPFLAGS) -e clip_blank.prg $(CLIPLIBS)

www_clip: www_clip.prg
	$(CLIP) $(CLIPFLAGS) -e www_clip.prg $(CLIPLIBS)  $(WWWLIBS)

wcl2prg: wcl2prg.prg
	$(CLIP) $(CLIPFLAGS) -e wcl2prg.prg $(CLIPLIBS)

sqlrun: sqlrun.prg
	$(CLIP) $(CLIPFLAGS) -e sqlrun.prg $(CLIPLIBS)  $(WWWLIBS)

