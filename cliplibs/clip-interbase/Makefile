#  GNU make makefile
#
ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc

IBROOT=/opt/interbase

TARGET=libclip-interbase$(DLLSUFF)
RTARGET=libclip-interbase$(DLLREALSUFF)
CFLAGS=$(C_FLAGS) -I$(IBROOT)/include
OBJS=ib_clip.o ib.o

all:  have_lib	$(TARGET)
#all: $(OBJS)

have_lib:
	test -f $(IBROOT)/include/ibase.h -o -f /usr/include/ibase.h

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) -lgds -L$(IBROOT)/lib -lcrypt

ib_clip.o: ib_clip.c interbase.ch
	$(CC) $(CFLAGS) -c ib_clip.c

ib.o: ib.prg interbase.ch
	$(CLIPROOT)/bin/clip -l ib.prg

install:
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(DESTDIR)$(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(DESTDIR)$(CLIPROOT)/lib
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/clip-interbase
	cp *.html $(DESTDIR)$(CLIPROOT)/doc/clip-interbase
	cp interbase.ch $(DESTDIR)$(CLIPROOT)/include
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/example/clip-interbase
	cp -R example/* $(DESTDIR)$(CLIPROOT)/doc/example/clip-interbase/

clean:
	rm -rf *.o ib.c *.s *.bak *.a *.so *.dll *.exe *.log *.ex *.nm
