CLIPINCLUDE=-I$(CLIPROOT)/include -I./gd
C_FLAGS=-Wall -g -I.
CC=gcc

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif


XLIB=libclip-gd.a
XSLIB=libclip-gd$(DLLSUFF)
XSLIBREAL=libclip-gd$(DLLREALSUFF)

all: build_gd

build_gd:
	cd gd && ./configure &&	$(MAKE)
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) -c _gd.c
	$(CLIPROOT)/bin/clip -l gd_obj.prg
	cd bsgraphic && $(MAKE)
	rm -f $(XLIB)
	$(CLIPROOT)/bin/clip_makelib $(XLIB) _gd.o gd_obj.o ./bsgraphic/*.o
	./makegd.sh $(XLIB)
	touch build_gd

install: all
	$(CLIPROOT)/bin/clip_cp $(XLIB) $(XSLIB) $(CLIPROOT)/lib
	cp ./gd/libgd.a $(CLIPROOT)/lib
	#[ "$(XSLIBREAL)" = "$(XSLIB)" ] || cp $(XSLIBREAL) $(CLIPROOT)/lib
	chmod 0644 $(CLIPROOT)/lib/$(XLIB)
	chmod 0644 $(CLIPROOT)/lib/libgd.a
	chmod 0755 $(CLIPROOT)/lib/$(XSLIB)
	cp gdinfo.ch $(CLIPROOT)/include
	cp bsgraphic/bggraph.ch $(CLIPROOT)/include
	mkdir -p $(CLIPROOT)/doc/clip-gd
	mkdir -p $(CLIPROOT)/doc/clip-gd/rus
	mkdir -p $(CLIPROOT)/doc/clip-gd/eng
	cp ./doc/rus/*.html $(CLIPROOT)/doc/clip-gd/rus
	cp ./doc/rus/*.png $(CLIPROOT)/doc/clip-gd/rus
	cp ./doc/eng/*.html $(CLIPROOT)/doc/clip-gd/eng
	cp ./doc/eng/*.png $(CLIPROOT)/doc/clip-gd/eng
	mkdir -p $(CLIPROOT)/doc/example/clip-gd
	cp -R example/* $(CLIPROOT)/doc/example/clip-gd/

clean:
	-cd gd; $(MAKE) clean
	cd bsgraphic && $(MAKE) clean
	cd example; $(MAKE) clean
	rm -rf *.o *.bak *.a *.so gd_obj.c *.dll build_gd  *.ex *.nm
