ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc

CLIPINCLUDE=-I$(CLIPROOT)/include

CLIP=$(CLIPROOT)/bin/clip
CLIPFLAGS = -w -a -O -n -I .. #-I ../include
TARGET=libclip-txtprn$(DLLSUFF)
RTARGET=libclip-txtprn$(DLLREALSUFF)
OBJS=txtprn_o.o

all:  $(TARGET)

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS)

txtprn_o.o: txtprn_o.prg
	$(CLIP) $(CLIPFLAGS) $(CLIPINCLUDE) txtprn_o.prg

install:
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(DESTDIR)$(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(DESTDIR)$(CLIPROOT)/lib
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/clip-txtprn
	cp doc/*.html $(DESTDIR)$(CLIPROOT)/doc/clip-txtprn
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/example/clip-txtprn
	cp -R example/* $(DESTDIR)$(CLIPROOT)/doc/example/clip-txtprn
	mkdir -p $(DESTDIR)$(CLIPROOT)/print
	cp install/*.ini $(DESTDIR)$(CLIPROOT)/print

clean:
	cd example; make clean
	rm -rf *.o *.bak doc/*.bak install/*.bak *.a *.so *.dll *.exe *.ex *.nm
