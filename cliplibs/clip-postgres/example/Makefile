PRG=my_psql
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.ex *.nm

my_psql: my_psql.prg
	clip -eMs my_psql.prg -lclip-postgres

