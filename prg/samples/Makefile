CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -b
CLIPLIBS  =
#GUILIB  = $(CLIPROOT)/lib/libxclip.a
SQLLIB	= $(CLIPROOT)/lib/libdbfsql.a
PGLIBS	= $(CLIPROOT)/lib/libpgclip.a /usr/lib/libpq.a /usr/lib/libcrypt.a
MSLIBS	= $(CLIPROOT)/lib/libmsclip.a /usr/lib/libmysqlclient.a
ORLIBS	= $(CLIPROOT)/lib/liborclip.a $(ORACLE_HOME)/lib/libclntsh.so
POBJS  = menu.po getfile.po
PAOBJS  = menu.po getfile.po
CLIP_LOCALE_ROOT=.
export CLIP_LOCALE_ROOT
.SUFFIXES: .prg .o .po

all: menu fw_menu getfile tb_test big_num multilang pluralmsg

clean:
	rm -rf *.exe *.uri *.c *.s *.o *.a *.so *.log *.pa *.b *.BAK *.bak *~ core* *core
	rm -rf locale.pot locale.mo *.ex *.nm
	rm -f menu getfile big_num tb_test fw_menu multilang pluralmsg

menu:	menu.prg
	$(CLIP) $(CLIPFLAGS) -e -M menu.prg $(CLIPLIBS)

fw_menu: fw_menu.prg
	$(CLIP) $(CLIPFLAGS) -e -M fw_menu.prg $(CLIPLIBS)

getfile: getfile.prg
	$(CLIP) $(CLIPFLAGS) -e -M getfile.prg $(CLIPLIBS)

tb_test: tb_test.prg
	$(CLIP) $(CLIPFLAGS) -e -M tb_test.prg $(CLIPLIBS)

big_num: big_num.prg
	$(CLIP) $(CLIPFLAGS) -e -M big_num.prg $(CLIPLIBS)

multilang: multilang.prg
	$(CLIP) $(CLIPFLAGS) -e -M -E CLIP_MODULE="ml1" multilang.prg $(CLIPLIBS)
	clip_msgmerge
	clip_msgfmt

pluralmsg: pluralmsg.prg
#	$(CLIP) $(CLIPFLAGS) -E CLIP_MODULE="ml2" pluralmsg.prg
	$(CLIP) $(CLIPFLAGS) -e -M -E CLIP_MODULE="ml2" pluralmsg.prg $(CLIPLIBS)
	clip_msgmerge
	clip_msgfmt

mypsql: mypsql.prg
	$(CLIP) $(CLIPFLAGS) -e mypsql.prg $(SQLLIB) $(PGLIBS)

mymysql: mymysql.prg
	$(CLIP) $(CLIPFLAGS) -e mymysql.prg $(SQLLIB) $(MSLIBS)

mysqlplus: mysqlplus.prg
	$(CLIP) $(CLIPFLAGS) -e mysqlplus.prg $(SQLLIB) $(ORLIBS)

#gui_test: gui_test.prg $(GUILIB)
#	$(CLIP) $(CLPFLAGS) -e -s -M gui_test.prg `gtk-config --libs` $(GUILIB) -lz
