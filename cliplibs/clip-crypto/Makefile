CLIPINCLUDE=-I$(CLIPROOT)/include
CLIPROOT ?= ../../../cliproot

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

TARGET=libclip-crypto$(DLLSUFF)
RTARGET=libclip-crypto$(DLLREALSUFF)
OBJS=crypto.o

all: have_lib	$(TARGET)


have_lib:
	test -f /usr/include/openssl/evp.h
	awk 'BEGIN{FS="\""} /^#define[ \t]+[SL]N_/{print "\""$$2"\","}' /usr/include/openssl/objects.h > names.h

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) -lcrypto

crypto.o: crypto.c hashcode.h
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) -c crypto.c

hashcode.h:
	echo '#define HASH_ferror ' $$(echo ferror| $(CLIPROOT)/bin/cliphash | cut -d' ' -f2) >hashcode.h

install: all
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-crypto
	cp *.html $(CLIPROOT)/doc/clip-crypto
	mkdir -p $(CLIPROOT)/doc/example/clip-crypto
	cp -R example/* $(CLIPROOT)/doc/example/clip-crypto/

clean:
	rm -rf *.o *.bak *.a *.so hashcode.h *.dll *.exe names.h *.ex *.nm
