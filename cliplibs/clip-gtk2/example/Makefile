LIBS= -lgtk-x11-2.0 -lgdk-x11-2.0 -latk-1.0 -lgdk_pixbuf-2.0 -lm -lpangox-1.0 -lpangoxft-1.0 -lpango-1.0 -lgobject-2.0 -lgmodule-2.0 -ldl -lglib-2.0

SRC =clipgtktest tbrow simple  test_stock test_image accel test_tree test_image \
	test_gtk test_text winpic test note fonttest text container test_dnd drag_and_drop \
        colorbtn pango entrytempl combobox
all: $(SRC)

clean:
	rm -f *.exe *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak *~ core* *core
	rm -f $(SRC)
	rm -rf *.ex *.nm

clipgtktest: clipgtktest.prg
	clip -es clipgtktest.prg -lclip-gtk2
#	clip -esg clipgtktest.prg ./libclip-gtk2.a -lgtk -lgdk
fonttest: fonttest.prg
	clip -es fonttest.prg -lclip-gtk2
#	clip -esg fonttest.prg ./libclip-gtk2.a $(LIBS)

accel: accel.prg
	clip -es -M accel.prg -lclip-gtk2

note: note.prg
	clip -es note.prg -lclip-gtk2

tbrow: tbrow.prg
	clip -es -M tbrow.prg -lclip-gtk2

simple: simple.prg
	clip -es simple.prg -lclip-gtk2

text: text.prg
	clip -es text.prg -lclip-gtk2
#	clip -esg text.prg ./libclip-gtk2.so $(LIBS)

winpic: winpic.prg
	clip -es winpic.prg -lclip-gtk2

test: test.prg
	clip -es test.prg -lclip-gtk2

test_gtk: test_gtk.prg
	clip -es test_gtk.prg -lclip-gtk2
#	clip -esg test_gtk.prg ./libclip-gtk2.a -lgtk -lgdk

test_stock: test_stock.prg
	clip -es test_stock.prg -lclip-gtk2

test_image: test_image.prg
	clip -es test_image.prg -lclip-gtk2

test_tree: test_tree.prg
	clip -es test_tree.prg -lclip-gtk2
#	clip -esg test_tree.prg ./libclip-gtk2.so $(LIBS)

test_text: test_text.prg
	clip -es test_text.prg -lclip-gtk2
#	clip -esg test_text.prg ./libclip-gtk2.so $(LIBS)

container: container.prg
	clip -es container.prg -lclip-gtk2

test_dnd: test_dnd.prg
	clip -es test_dnd.prg -lclip-gtk2
#	clip -esg test_dnd.prg ./libclip-gtk2.so $(LIBS)

drag_and_drop: drag_and_drop.prg
	clip -es drag_and_drop.prg -lclip-gtk2
#	clip -esg drag_and_drop.prg ./libclip-gtk2.so $(LIBS)

colorbtn: colorbtn.prg
	clip -es colorbtn.prg -lclip-gtk2

pango: pango.prg
	clip -es pango.prg -lclip-gtk2

entrytempl: entrytempl.prg
	clip -es entrytempl.prg -lclip-gtk2

combobox: combobox.prg
	clip -es combobox.prg -lclip-gtk2

