ifndef CLIPROOT
	CLIPROOT=../../../cliproot
endif

include $(CLIPROOT)/include/Makefile.inc

CLIPINCLUDE=-I$(CLIPROOT)/include

#C_FLAGS=-Wall -g -I. $(CLIPINCLUDE)
#CC=gcc
TARGET=libclip-com$(DLLSUFF)
RTARGET=libclip-com$(DLLREALSUFF)
OBJS=com.o
CFLAGS+=-IlibezV24 -Wall
LIBEZ=libezV24/libezV24-0.a

all:  have_lib $(TARGET)

have_lib:
	true
#	test -f /usr/include/bzlib.h

$(TARGET): $(OBJS) $(LIBEZ)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) $(LIBEZ)

$(LIBEZ):
	cd libezV24 && $(MAKE)

com.o: com.c hashcode.h
	$(CC) $(CFLAGS) $(CLIPINCLUDE) -c com.c

hashcode.h:
	echo '#define HASH_ferror ' $$(echo ferror| $(CLIPROOT)/bin/cliphash | cut -d' ' -f2) >hashcode.h

install: all
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-com
	-cp -R doc/* $(CLIPROOT)/doc/clip-com/
	mkdir -p $(CLIPROOT)/doc/example/clip-com
	-cp -R example/* $(CLIPROOT)/doc/example/clip-com/

clean distclean:
	rm -rf *.o *.bak *.a *.so hashcode.h *.dll *.exe bzpref.h *.ex *.nm
	-cd libezV24; $(MAKE) clean; rm *.a *.so *.so.* *.exe
	-cd example; $(MAKE) clean
