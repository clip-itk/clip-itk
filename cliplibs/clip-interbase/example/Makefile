PRG=my_isql
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.ex *.nm

my_isql: my_isql.prg
	clip -eMs my_isql.prg -lclip-interbase

