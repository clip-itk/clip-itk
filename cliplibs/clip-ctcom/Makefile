CLIPINCLUDE=-I$(CLIPROOT)/include
CLIPROOT ?= ../../../cliproot

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif

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

install: all
	cp $(TARGET) $(CLIPROOT)/lib
	cp *.ch $(CLIPROOT)/include
	[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-ctcom
	cp *.html $(CLIPROOT)/doc/clip-ctcom
	mkdir -p $(CLIPROOT)/doc/example/clip-ctcom
	cp -R example/* $(CLIPROOT)/doc/example/clip-ctcom/

clean:
	rm -rf *.o *.bak *.a *.so hashcode.h *.dll *.exe names.h *.ex *.nm
