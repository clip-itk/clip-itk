ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
#CLIP	= clip
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -b -l -w
CLIPLIBS  = -lclip-codb
OBJS  = #cobra_conn.o
CHS  = #corba_serv.ch
MODULES = module1.po codbtview.po
.SUFFIXES: .prg .o .po

all: cobra_serv $(MODULES) #AUTH WRAP

clean:
	rm -rf *.exe *.o *.c *.s *.a *.so *.po *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core
	rm -rf cobra_serv *.ex *.nm *.pro
	cd auth; make clean
	cd tcp-wrap; make clean

cobra_serv:cobra_serv.prg $(CHS) $(OBJS)
	$(CLIP) $(CLIPFLAGS) -esl cobra_serv.prg $(OBJS) $(CLIPLIBS)

AUTH:
	cd auth; make all

WRAP:
	cd tcp-wrap; make all

install:
	cp cobra_serv$(EXESUFF) $(CLIPROOT)/bin
	mkdir -p $(CLIPROOT)/cobra
	#ln -sf $(CLIPROOT)/bin/cobra_serv$(EXESUFF)  $(CLIPROOT)/cobra/cobra_serv$(EXESUFF)
	cp cobra_serv.ini $(CLIPROOT)/cobra
	mkdir -p $(CLIPROOT)/cobra/auth
	cp ./auth/Makefile ./auth/other ./auth/pam* $(CLIPROOT)/cobra/auth
	mkdir -p $(CLIPROOT)/cobra/tcp-wrap
	cp ./tcp-wrap/Makefile ./tcp-wrap/tcp-* $(CLIPROOT)/cobra/tcp-wrap
	cp $(MODULES) $(CLIPROOT)/cobra/
	mkdir -p $(CLIPROOT)/cobra/files
	cp ./auth/pam-err-msg $(CLIPROOT)/cobra/files

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -n -p $<

