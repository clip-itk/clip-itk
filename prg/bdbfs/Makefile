ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -l -b -a -O -n -I .. -I $(CLIPROOT)/include -I $(CLIPROOT)/include/netto
CLIPLIBS  =

LIBS  = -lclip-netto -lclip-nanfor
OBJS  =	getsys.o common.o \
	help.o print.o \
	mdbedit.o mainmenu.o aktions.o obsolete.o \
	cliplib.o filer.o viewer.o editor.o foxpro.o \
	tb2html.o menu.o \
	_clip.o modistru.o vkrz.o \
	nanfor.o nettos.o \
	errorsys.o \
	config.o examplep.o

.SUFFIXES: .prg .o

#LANG=ru_RU.KOI8-R
#export LANG

bdbf$(EXESUFF):	bdbf.prg common.ch bdbfmsg.ch $(OBJS)
	$(CLIP) $(CLIPFLAGS) -s -e -l bdbf.prg $(OBJS) $(LIBS)

clean:
	rm -rf *.o *.ppo *.c *.s *.a *.so *.b *.BAK *.bak *.log
	rm -rf bdbf *.exe *~ core* *core *.nm *.ex test

install:
	cp bdbf$(EXESUFF) $(CLIPROOT)/bin/bdbf$(EXESUFF)
	cp *.hlp $(CLIPROOT)/bin/

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<


