CLIPINCLUDE=-I$(CLIPROOT)/include

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

#C_FLAGS=-Wall -g -I. $(CLIPINCLUDE)
#CC=gcc
TARGET=libclip-bzip2$(DLLSUFF)
RTARGET=libclip-bzip2$(DLLREALSUFF)
OBJS=bzip2.o

all:  have_lib $(TARGET)

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
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) -lbz2

bzip2.o: bzip2.c hashcode.h bzpref.h
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) -c bzip2.c

hashcode.h:
	echo '#define HASH_ferror ' $$(echo ferror| $(CLIPROOT)/bin/cliphash | cut -d' ' -f2) >hashcode.h

install: all
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-bzip2
	cp *.html $(CLIPROOT)/doc/clip-bzip2
	mkdir -p $(CLIPROOT)/doc/example/clip-bzip2
	cp -R example/* $(CLIPROOT)/doc/example/clip-bzip2/

clean:
	rm -rf *.o *.bak *.a *.so hashcode.h *.dll *.exe bzpref.h *.ex *.nm
