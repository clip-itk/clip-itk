ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc
CLIPINCLUDE=-I$(CLIPROOT)/include

TARGET=libclip-ctcom$(DLLSUFF)
RTARGET=libclip-ctcom$(DLLREALSUFF)
OBJS=ct_com.o serial.o

all: $(TARGET)


$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS)

ct_com.o: ct_com.c ctcom.ch
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) -c ct_com.c

serial.o: serial.c ctcom.ch
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) -c serial.c

hashcode.h:
	echo '#define HASH_ferror ' $$(echo ferror| $(CLIPROOT)/bin/cliphash | cut -d' ' -f2) >hashcode.h

install:
	cp $(TARGET) $(DESTDIR)$(CLIPROOT)/lib
	cp *.ch $(DESTDIR)$(CLIPROOT)/include
	[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(DESTDIR)$(CLIPROOT)/lib
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/clip-ctcom
	cp *.html $(DESTDIR)$(CLIPROOT)/doc/clip-ctcom
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/example/clip-ctcom
	cp -R example/* $(DESTDIR)$(CLIPROOT)/doc/example/clip-ctcom/

clean:
	rm -rf *.o *.bak *.a *.so hashcode.h *.dll *.exe names.h *.ex *.nm
