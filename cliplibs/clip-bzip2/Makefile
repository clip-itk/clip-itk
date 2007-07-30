ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc

TARGET=libclip-bzip2$(DLLSUFF)
ATARGET=libclip-bzip2.a
RTARGET=libclip-bzip2$(DLLREALSUFF)
OBJS=bzip2.o
LIBS= -lbz2 $(C_LIBS)

all:  have_lib $(TARGET) $(ATARGET)

have_lib:
	test -f /usr/include/bzlib.h

bzpref.h:
	if grep BZ2_bzopen /usr/include/bzlib.h >/dev/null 2>&1;\
	then\
		echo '#define BZPREF(c) BZ2_##c' >bzpref.h;\
	else\
		echo '#define BZPREF(c) c' >bzpref.h;\
	fi

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) $(LIBS)

$(ATARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makelib $(ATARGET) $(OBJS) $(LIBS)

bzip2.o: bzip2.c hashcode.h bzpref.h
	$(CC) $(C_FLAGS) -c bzip2.c

hashcode.h:
	echo '#define HASH_ferror ' $$(echo ferror| $(CLIPROOT)/bin/cliphash | cut -d' ' -f2) >hashcode.h

install:
	$(CLIPROOT)/bin/clip_cp libclip-bzip2 $(DESTDIR)$(CLIPROOT)/lib
	#mkdir -p $(CLIPROOT)/doc/clip-bzip2
	#cp *.html $(CLIPROOT)/doc/clip-bzip2
	#-cd tdoc && $(MAKE) install
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/example/clip-bzip2
	cp -R example/* $(DESTDIR)$(CLIPROOT)/doc/example/clip-bzip2/

clean:
	rm -rf *.o *.bak *.a *.so hashcode.h *.dll *.exe bzpref.h *.ex *.nm
	#-cd tdoc && $(MAKE) clean

distclean: clean
	#-cd tdoc && $(MAKE) distclean

