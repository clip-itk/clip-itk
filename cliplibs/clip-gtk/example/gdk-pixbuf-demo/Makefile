SRC=pixbuf_demo pixbuf_scale zoomimage

all: $(SRC)

clean:
	rm -f *.c *.o *.log *.bak
	rm -f $(SRC)
	rm -rf *.ex *.nm

pixbuf_demo: pixbuf_demo.prg
	clip -ews pixbuf_demo.prg -lclip-gtk

pixbuf_scale: pixbuf_scale.prg
	clip -ews pixbuf_scale.prg -lclip-gtk

zoomimage: zoomimage.prg
	clip -ews zoomimage.prg -lclip-gtk

