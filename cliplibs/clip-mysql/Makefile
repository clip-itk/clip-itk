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

TARGET=libclip-mysql$(DLLSUFF)
RTARGET=libclip-mysql$(DLLREALSUFF)
MSINC = -I/usr/include/mysql -I/usr/local/include/mysql
OBJS=ms_clip.o ms.o

all:  have_lib	$(TARGET)

have_lib:
	test -f /usr/include/mysql/mysql.h -o -f /usr/local/include/mysql/mysql.h

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) -lmysqlclient -L/usr/lib/mysql

ms_clip.o: ms_clip.c
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) $(MSINC) -c ms_clip.c

ms.o: ms.prg mysql.ch
	$(CLIPROOT)/bin/clip -l ms.prg

install: all
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-mysql
	cp *.html $(CLIPROOT)/doc/clip-mysql
	cp mysql.ch $(CLIPROOT)/include
	mkdir -p $(CLIPROOT)/doc/example/clip-mysql
	cp -R example/* $(CLIPROOT)/doc/example/clip-mysql/

clean:
	rm -rf *.o *.bak *.a *.so *.dll *.exe *.ex *.nm
