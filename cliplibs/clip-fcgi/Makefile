CLIPINCLUDE=-I$(CLIPROOT)/include
CLIPROOT ?= ../../../cliproot

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

TARGET=libclip-fcgi$(DLLSUFF)
RTARGET=libclip-fcgi$(DLLREALSUFF)
OBJS=fcgi.o

all: have_lib	$(TARGET)


have_lib:
	test -f /usr/include/fcgi_config.h

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) -lfcgi

fcgi.o: fcgi.c hashcode.h
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) -c fcgi.c

hashcode.h:
	echo '#define HASH_ferror ' $$(echo ferror| $(CLIPROOT)/bin/cliphash | cut -d' ' -f2) >hashcode.h

install: all
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	cp *.ch $(CLIPROOT)/include/
	mkdir -p $(CLIPROOT)/doc/clip-fcgi
	cp *.html $(CLIPROOT)/doc/clip-fcgi
	mkdir -p $(CLIPROOT)/doc/example/clip-fcgi
	cp -R example/* $(CLIPROOT)/doc/example/clip-fcgi/

clean:
	rm -rf *.o *.bak *.a *.so hashcode.h *.dll *.exe names.h *.ex *.nm
	cd example && $(MAKE) clean

distclean: clean
