PRG=my_mysql
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.ex *.nm

my_mysql: my_mysql.prg
	clip -eMs my_mysql.prg -lclip-mysql

