ifndef CLIPROOT
	CLIPROOT=$(shell echo pwd; cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc
CLIPINCLUDE=-I$(CLIPROOT)/include


#C_FLAGS=-Wall -g -I. $(CLIPINCLUDE)
#CC=gcc
TARGET=libclip-gzip$(DLLSUFF)
ATARGET=libclip-gzip.a
RTARGET=libclip-gzip$(DLLREALSUFF)
OBJS=gzip.o

all:	$(TARGET) $(ATARGET)

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) -lz

$(ATARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makelib $(ATARGET) $(OBJS) -lz

gzip.o: gzip.c hashcode.h
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) -c gzip.c

hashcode.h:
	echo '#define HASH_ferror ' $$(echo ferror| $(CLIPROOT)/bin/cliphash | cut -d' ' -f2) >hashcode.h

install:
	$(CLIPROOT)/bin/clip_cp libclip-gzip $(DESTDIR)$(CLIPROOT)/lib
	#mkdir -p $(CLIPROOT)/doc/clip-gzip
	#cp *.html $(CLIPROOT)/doc/clip-gzip
	-cd tdoc && $(MAKE) install
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/example/clip-gzip
	cp -R example/* $(DESTDIR)$(CLIPROOT)/doc/example/clip-gzip/

clean:
	rm -rf *.o *.bak *.a *.so hashcode.h *.dll *.exe *.ex *.nm
	cd example && $(MAKE) clean
	-cd tdoc && make clean

distclean: clean
	-cd tdoc && make distclean
