PRG=gr
all: $(PRG)

clean:
	rm -f *.exe *.uri *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak \
		*~ core* *core $(PRG) *.ex *.nm

gr: gr.prg
	clip -s -e -M gr.prg -lclip-gd

