PRG=bz2
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.bz2 *.ex *.nm

bz2: bz2.prg
	clip -e -s -l -M bz2.prg -lclip-bzip2

