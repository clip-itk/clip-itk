
ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

TARGET=libclip-netto$(DLLSUFF)
RTARGET=libclip-netto$(DLLREALSUFF)
LIBS=libclip-netto.a

all: $(TARGET)

$(TARGET):
	cd misc && $(MAKE)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(LIBS)

clean distclean*:
	cd misc && $(MAKE) clean
	rm -f $(LIBS) $(TARGET) $(RTARGET) *.ex *.nm

install: $(TARGET)
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	$(CLIPROOT)/bin/clip_cp $(LIBS) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-oasis/netto
	cp doc/netto*.* $(CLIPROOT)/doc/clip-oasis/netto
	cp doc/readme*.* $(CLIPROOT)/doc/clip-oasis/netto
	mkdir -p $(CLIPROOT)/include/netto
	cp include/*.ch $(CLIPROOT)/include/netto
	cp include/*.h $(CLIPROOT)/include/netto

