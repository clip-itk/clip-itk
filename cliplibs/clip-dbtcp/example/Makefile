PRG=my_dbtcp
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.ex *.nm

my_dbtcp: my_dbtcp.prg
	clip -eMs my_dbtcp.prg -lclip-dbtcp

