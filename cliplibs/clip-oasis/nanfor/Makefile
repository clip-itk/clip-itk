
ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

TARGET=libclip-nanfor$(DLLSUFF)
RTARGET=libclip-nanfor$(DLLREALSUFF)
LIBS=libclip-nanfor.a

all: $(TARGET)

$(TARGET):
	cd prg && $(MAKE)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(LIBS)

clean distclean:
	cd prg && $(MAKE) clean
	rm -f $(LIBS) $(TARGET) $(RTARGET) *.ex *.nm

install:  $(TARGET)
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	$(CLIPROOT)/bin/clip_cp $(LIBS) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-oasis/nanfor
#	cp doc/netto*.* $(CLIPROOT)/doc/clip-oasis/nanfor
#	cp doc/readme*.* $(CLIPROOT)/doc/clip-oasis/nanfor
	mkdir -p $(CLIPROOT)/include/nanfor
	cp include/*.ch $(CLIPROOT)/include/nanfor
	cp include/*.h $(CLIPROOT)/include/nanfor

