#  GNU make makefile
#

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
else
CLIPROOT=/usr/local/clip
endif

CLIPINCLUDE=-I$(CLIPROOT)/include
#C_FLAGS=-Wall -g -I. $(CLIPINCLUDE)
#CC=gcc

TARGET=libclip-postgres$(DLLSUFF)
RTARGET=libclip-postgres$(DLLREALSUFF)
PGINC = -I/usr/include/pgsql -I/usr/include/postgresql -I/usr/include/pgsql/server
OBJS=pg_clip.o pg.o

all:  have_lib	$(TARGET)

have_lib:
	test -f /usr/include/pgsql/libpq-fe.h -o -f /usr/include/postgresql/libpq-fe.h -o -f /usr/include/libpq-fe.h

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) -lpq

pg_clip.o: pg_clip.c
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) $(PGINC) -c pg_clip.c

pg.o: pg.prg postgres.ch
	$(CLIPROOT)/bin/clip -l pg.prg

install: all
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-postgres
	cp *.html $(CLIPROOT)/doc/clip-postgres
	cp postgres.ch $(CLIPROOT)/include
	mkdir -p $(CLIPROOT)/doc/example/clip-postgres
	cp -R example/* $(CLIPROOT)/doc/example/clip-postgres/

clean:
	rm -rf *.o *.bak *.a *.so *.dll *.exe *.ex *.nm
