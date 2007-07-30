#  GNU make makefile
#
ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc

CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -l -n -w
CLIPLIBS  =
OBJS  = richtext.o

RTLIB = libclip-rtf.a
RTFLIB = libclip-rtf$(DLLSUFF)
RTFLIBREAL = libclip-rtf$(DLLREALSUFF)


.SUFFIXES: .prg .o .po

all:    $(RTFLIB)

$(RTFLIB): $(OBJS)
	$(CLIPROOT)/bin/clip_makelib $(RTLIB) $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(RTFLIB) $(RTLIB) $(C_LIBS)

clean:
	rm -f *.exe *.c *.s *.o *.po *.log *.bak *.a *.so *.ex *.nm
	cd test && $(MAKE) clean

install: $(RTFLIB)
	$(CLIPROOT)/bin/clip_cp $(RTLIB) $(DESTDIR)$(CLIPROOT)/lib
	$(CLIPROOT)/bin/clip_cp $(RTFLIB) $(DESTDIR)$(CLIPROOT)/lib
	chmod 0755 $(DESTDIR)$(CLIPROOT)/lib/$(RTFLIB)
	#[ "$(RTFLIBREAL)" = "$(RTFLIB)" ] || cp $(RTFLIBREAL) $(CLIPROOT)/lib
	cp ./richtext.ch $(DESTDIR)$(CLIPROOT)/include
	cp ./objects.ch $(DESTDIR)$(CLIPROOT)/include

	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/example/clip-rtf
	cp -R test/Makefile test/*.prg $(DESTDIR)$(CLIPROOT)/doc/example/clip-rtf/
	cp -R test/*.dbf test/*.dbt $(DESTDIR)$(CLIPROOT)/doc/example/clip-rtf/

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

