include $(CLIPROOT)/include/Makefile.inc

TARGET=libclip-nanfor$(DLLSUFF)
RTARGET=libclip-nanfor$(DLLREALSUFF)
LIBS=libclip-nanfor.a

all: $(TARGET)

$(TARGET):
	cd prg && $(MAKE)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(LIBS)

clean distclean:
	cd prg && $(MAKE) clean
	rm -f $(LIBS) $(TARGET) $(RTARGET) *.ex *.nm *.bak

install:  $(TARGET)
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(DESTDIR)$(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	$(CLIPROOT)/bin/clip_cp $(LIBS) $(DESTDIR)$(CLIPROOT)/lib
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/clip-oasis/nanfor
#	cp doc/netto*.* $(CLIPROOT)/doc/clip-oasis/nanfor
#	cp doc/readme*.* $(CLIPROOT)/doc/clip-oasis/nanfor
	mkdir -p $(DESTDIR)$(CLIPROOT)/include/nanfor
	cp include/*.ch $(DESTDIR)$(CLIPROOT)/include/nanfor
	cp include/*.h $(DESTDIR)$(CLIPROOT)/include/nanfor

