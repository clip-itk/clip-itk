SRC=accel clipgtktest note simple tbrow test test_gtk test_image \
	test_list window  winpic ifactory
all: $(SRC)

clean:
	rm -f *.exe *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak *~ core* *core
	rm -f $(SRC)
	rm -rf *.ex *.nm

clipgtktest: clipgtktest.prg
	clip -es clipgtktest.prg -lclip-gtk
#	clip -esg clipgtktest.prg ./libclip-gtk.so -lgtk -lgdk

accel: accel.prg
	clip -es -M accel.prg -lclip-gtk

note: note.prg
	clip -es -M note.prg -lclip-gtk

tbrow: tbrow.prg
	clip -es -M tbrow.prg -lclip-gtk

simple: simple.prg
	clip -es simple.prg -lclip-gtk

#ext: ext.prg
#	clip -es ext.prg -lclip-gtk

winpic: winpic.prg
	clip -es winpic.prg -lclip-gtk

#winpic1: winpic1.prg
#	clip -es winpic1.prg -lclip-gtk

window: window.prg
	clip -es window.prg -lclip-gtk

test_gtk: test_gtk.prg
	clip -es test_gtk.prg -lclip-gtk
#	clip -esg test_gtk.prg ./libclip-gtk.a -lgtk -lgdk

test_image: test_image.prg
	clip -es test_image.prg -lclip-gtk

test_list: test_list.prg
	clip -es test_list.prg -lclip-gtk

test: test.prg
	clip -es test.prg -lclip-gtk

ifactory: ifactory.prg
	clip -es ifactory.prg -lclip-gtk
#	clip -esg ifactory.prg ./libclip-gtk.so -lgtk -lgdk


