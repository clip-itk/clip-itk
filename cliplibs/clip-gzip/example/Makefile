PRG=gz
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.gz *.ex *.nm

gz: gz.prg
	clip -e -s -l -M gz.prg -lclip-gzip

