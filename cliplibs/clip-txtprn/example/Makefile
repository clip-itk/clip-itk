CLIPINCLUDE=-I$(CLIPROOT)/include

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif


PRG=prn1
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.bz2 *.exe *.ex *.nm

prn1: prn1.prg
	clip -e -l -s -M prn1.prg -lclip-txtprn

