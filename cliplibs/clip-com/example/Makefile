PRG=com
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.bz2 *.ex *.nm

$(PRG): $(PRG).prg
	clip -e -M $(PRG).prg -lclip-$(PRG)

