PRG=my_sqlplus
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.ex *.nm

my_sqlplus: my_sqlplus.prg
	clip -eMs my_sqlplus.prg -lclip-oracle

