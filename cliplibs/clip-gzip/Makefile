CLIPINCLUDE=-I$(CLIPROOT)/include

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

#C_FLAGS=-Wall -g -I. $(CLIPINCLUDE)
#CC=gcc
TARGET=libclip-gzip$(DLLSUFF)
RTARGET=libclip-gzip$(DLLREALSUFF)
OBJS=gzip.o

all:	$(TARGET)

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) -lz

gzip.o: gzip.c hashcode.h
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) -c gzip.c

hashcode.h:
	echo '#define HASH_ferror ' $$(echo ferror| $(CLIPROOT)/bin/cliphash | cut -d' ' -f2) >hashcode.h

install: all
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-gzip
	cp *.html $(CLIPROOT)/doc/clip-gzip
	mkdir -p $(CLIPROOT)/doc/example/clip-gzip
	cp -R example/* $(CLIPROOT)/doc/example/clip-gzip/

clean:
	rm -rf *.o *.bak *.a *.so hashcode.h *.dll *.exe *.ex *.nm
