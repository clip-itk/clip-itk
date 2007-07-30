ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc

TARGET=libclip-fcgi$(DLLSUFF)
ATARGET=libclip-fcgi.a
RTARGET=libclip-fcgi$(DLLREALSUFF)
OBJS=fcgi.o
LIBS= -lfcgi $(C_LIBS)

all: have_lib	$(TARGET) $(ATARGET)


have_lib:
	test -f /usr/include/fcgi_config.h

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) $(LIBS)

$(ATARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makelib $(ATARGET) $(OBJS) $(LIBS)

fcgi.o: fcgi.c hashcode.h
	$(CC) $(C_FLAGS) -c fcgi.c

hashcode.h:
	echo '#define HASH_ferror ' $$(echo ferror| $(CLIPROOT)/bin/cliphash | cut -d' ' -f2) >hashcode.h

install:
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(DESTDIR)$(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(DESTDIR)$(CLIPROOT)/lib
	cp *.ch $(DESTDIR)$(CLIPROOT)/include/
	#mkdir -p $(CLIPROOT)/doc/clip-fcgi
	#cp *.html $(CLIPROOT)/doc/clip-fcgi
	#-cd tdoc && $(MAKE) install
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/example/clip-fcgi
	cp -R example/* $(DESTDIR)$(CLIPROOT)/doc/example/clip-fcgi/

clean:
	rm -rf *.o *.bak *.a *.so hashcode.h *.dll *.exe names.h *.ex *.nm
	cd example && $(MAKE) clean
	#-cd tdoc && $(MAKE) clean

distclean: clean
	#-cd tdoc && $(MAKE) distclean

