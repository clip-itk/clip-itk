#  GNU make makefile
#

ifdef CLIPROOT
	CLIP	= $(CLIPROOT)/bin/clip
	include $(CLIPROOT)/include/Makefile.inc
else
	CLIP = clip
endif
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
	$(CLIPROOT)/bin/clip_makeslib $(RTFLIB) $(RTLIB)

clean:
	rm -f *.exe *.c *.o *.po *.log *.bak *.a *.so *.ex *.nm
	cd test && $(MAKE) clean

install: $(RTFLIB)
	$(CLIPROOT)/bin/clip_cp $(RTLIB) $(CLIPROOT)/lib
	$(CLIPROOT)/bin/clip_cp $(RTFLIB) $(CLIPROOT)/lib
	chmod 0755 $(CLIPROOT)/lib/$(RTFLIB)
	#[ "$(RTFLIBREAL)" = "$(RTFLIB)" ] || cp $(RTFLIBREAL) $(CLIPROOT)/lib
	cp ./richtext.ch $(CLIPROOT)/include
	cp ./objects.ch $(CLIPROOT)/include

	mkdir -p $(CLIPROOT)/doc/example/clip-rtf
	cp -R test/Makefile test/*.prg $(CLIPROOT)/doc/example/clip-rtf/
	cp -R test/*.dbf test/*.dbt $(CLIPROOT)/doc/example/clip-rtf/

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

