ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
#CLIP	= clip
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -b -l -w
CLIPLIBS  = -lclip-codb -lclip-r2d2
OBJS  = #cobra_conn.o
CHS  = #corba_serv.ch
MODULES = #module1.po codbtview.po
.SUFFIXES: .prg .o .po

all: kamache $(MODULES) #AUTH WRAP

clean:
	rm -rf *.exe *.o *.c *.s *.a *.so *.po *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core
	rm -rf kamache *.ex *.nm *.pro
	cd mod-ini; $(MAKE) clean
	cd mod-clip; $(MAKE) clean
	#cd tcp-wrap; $(MAKE) clean

kamache:kamache.prg $(CHS) $(OBJS)
	$(CLIP) $(CLIPFLAGS) -esl kamache.prg $(OBJS) $(CLIPLIBS)
	cd mod-ini; $(MAKE)
	cd mod-clip; $(MAKE)

install:
	mkdir -p $(DESTDIR)$(CLIPROOT)/kamache
	mkdir -p $(DESTDIR)$(CLIPROOT)/kamache/mod-cache
	cp kamache$(EXESUFF) $(DESTDIR)$(CLIPROOT)/kamache
	cp kamache.ini $(DESTDIR)$(CLIPROOT)/kamache
	cd mod-ini; $(MAKE) install
	cd mod-clip; $(MAKE) install

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -n -p $<

