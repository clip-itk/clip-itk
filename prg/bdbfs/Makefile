ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -v2 -l -a -O -n -I .. -I $(CLIPROOT)/include -I $(CLIPROOT)/include/netto
CLIPLIBS  =

LIBS  = -lclip-netto -lclip-nanfor
OBJS  =	getsys.o common.o \
	help.o print.o \
	mdbedit.o mainmenu.o aktions.o examplep.o obsolete.o \
	cliplib.o filer.o viewer.o editor.o foxpro.o \
	tb2html.o menu.o \
        _clip.o modistru.o vkrz.o \
        nanfor.o nettos.o \
        errorsys.o \
        config.o
#	 m6.o

.SUFFIXES: .prg .o

bdbf$(EXESUFF):	bdbf.prg common.ch bdbfmsg.ch $(OBJS)
	$(CLIP) $(CLIPFLAGS) -s -e -l bdbf.prg $(OBJS) $(LIBS)

clean:
	rm -rf *.o *.ppo *.c *.a *.so *.b *.BAK *.bak *.log bdbf *~ core* *core
	rm -rf *.ex *.nm

install:
	cp bdbf$(EXESUFF) $(CLIPROOT)/bin/bdbf$(EXESUFF)

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<


