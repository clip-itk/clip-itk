#  GNU make makefile
#

IBROOT=/opt/interbase

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
else
CLIPROOT=/usr/local/clip
endif

CLIPINCLUDE=-I$(CLIPROOT)/include

TARGET=libclip-interbase$(DLLSUFF)
RTARGET=libclip-interbase$(DLLREALSUFF)
IBINC = -I$(IBROOT)/include
OBJS=ib_clip.o ib.o

all:  have_lib	$(TARGET)
#all: $(OBJS)

have_lib:
	test -f $(IBROOT)/include/ibase.h

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) -lgds -L$(IBROOT)/lib -lcrypt

ib_clip.o: ib_clip.c interbase.ch
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) $(IBINC) -c ib_clip.c

ib.o: ib.prg interbase.ch
	$(CLIPROOT)/bin/clip -l ib.prg

install: all
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-interbase
	cp *.html $(CLIPROOT)/doc/clip-interbase
	cp interbase.ch $(CLIPROOT)/include
	mkdir -p $(CLIPROOT)/doc/example/clip-interbase
	cp -R example/* $(CLIPROOT)/doc/example/clip-interbase/

clean:
	rm -rf *.o *.bak *.a *.so *.dll *.exe *.log *.ex *.nm
