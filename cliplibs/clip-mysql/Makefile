#  GNU make makefile
#

ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif
include $(CLIPROOT)/include/Makefile.inc

TARGET=libclip-mysql$(DLLSUFF)
ATARGET=libclip-mysql.a
RTARGET=libclip-mysql$(DLLREALSUFF)
CFLAGS=-fPIC $(C_FLAGS) -I/usr/include/mysql -I/usr/local/include/mysql
OBJS=ms_clip.o ms.o
LIBS=-L/usr/lib/mysql -lmysqlclient $(C_LIBS)

all:  have_lib	$(TARGET) $(ATARGET)

have_lib:
	test -f /usr/include/mysql/mysql.h -o -f /usr/local/include/mysql/mysql.h

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) $(LIBS)

$(ATARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makelib $(ATARGET) $(OBJS) $(LIBS)

ms_clip.o: ms_clip.c
	$(CC) $(CFLAGS) -c ms_clip.c

ms.o: ms.prg mysql.ch
	$(CLIPROOT)/bin/clip -l ms.prg

install:
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(DESTDIR)$(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/clip-mysql
	cp *.html $(DESTDIR)$(CLIPROOT)/doc/clip-mysql
	cp mysql.ch $(DESTDIR)$(CLIPROOT)/include
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/example/clip-mysql
	cp -R example/* $(DESTDIR)$(CLIPROOT)/doc/example/clip-mysql/

clean:
	rm -rf *.o ms.c *.s *.bak *.a *.so *.dll *.exe *.ex *.nm
