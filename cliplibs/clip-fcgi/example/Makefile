PRG=clip_echo.fcgi
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.ex *.nm

$(PRG): $(PRG).prg
	clip -e -M $(PRG).prg -lclip-fcgi

