include $(CLIPROOT)/include/Makefile.inc

CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -n -I .. -I ../include
CLIPLIBS  =
OBJS  = aading.o aavg.o acctadj.o acctmnth.o acctqtr.o acctweek.o \
	acctyear.o adessort.o aemaxlen.o aeminlen.o amedian.o \
	ach2tb.o \
	anomatch.o any2any.o aredit.o asum.o at2.o bitclr.o bitset.o \
	blink.o byt2bit.o byt2hex.o byteand.o byteneg.o bytenot.o \
	byteor.o bytexor.o calendar.o cntryset.o d2e.o \
	datecnfg.o dayofyr.o daytobow.o dectobin.o diskfunc.o \
	dispmsg.o e2d.o easter.o elapmil.o elapsed.o \
	eltime.o findith.o firstday.o gcd.o hex2dec.o \
	invclr.o isbit.o isbiton.o lastday.o linked.o \
	madd.o menu1.o metaph.o miltime.o min2dhm.o month.o \
	netpv.o nooccur.o ntow.o \
	nwuid.o pchr.o pegs.o pending.o pickday.o popadder.o \
	prtesc.o pvid.o qtr.o rand1.o restsets.o round.o \
	savearr.o savesets.o scregion.o setdate.o settime.o \
	sinkey.o sleep.o sqzn.o sysmem.o tbwhile.o tempfile.o \
	vertmenu.o wda.o week.o workdays.o woy.o \
	xbox.o year.o \
	dosver.o floptst.o isshare.o mouse1.o nwlstat.o nwsem.o \
	page.o scancode.o  vidcur.o  vidmode.o \
	clrsel.o menuto.o
	# dfile.o


.SUFFIXES: .prg .o

all:    $(OBJS)
	$(CLIPROOT)/bin/clip_makelib ../libclip-nanfor.a *.o
	rm -rf *.c

clean:
	rm -rf *.o *.c *.s *.a *.so *.b *.BAK *.bak *~ core* *core *.ex *.nm


.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

