CLIPINCLUDE=-I$(CLIPROOT)/include

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

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

install: all
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-txtprn
	cp doc/*.html $(CLIPROOT)/doc/clip-txtprn
	mkdir -p $(CLIPROOT)/doc/example/clip-txtprn
	cp -R example/* $(CLIPROOT)/doc/example/clip-txtprn
	mkdir -p $(CLIPROOT)/print
	cp install/*.ini $(CLIPROOT)/print

clean:
	cd example; make clean
	rm -rf *.o *.bak doc/*.bak install/*.bak *.a *.so *.dll *.exe *.ex *.nm
