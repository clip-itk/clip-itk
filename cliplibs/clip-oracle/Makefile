#  GNU make makefile
#

ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
else
CLIPROOT=/usr/local/clip
endif

ifndef ORACLE_HOME
ORACLE_HOME=/usr/local/oracle_home
endif

CLIPINCLUDE=-I$(CLIPROOT)/include
#C_FLAGS=-Wall -g -I. $(CLIPINCLUDE)
#CC=gcc

TARGET=libclip-oracle$(DLLSUFF)
RTARGET=libclip-oracle$(DLLREALSUFF)
ORINC = -I$(ORACLE_HOME)/rdbms/demo -I$(ORACLE_HOME)/network/public -I$(ORACLE_HOME)/rdbms/public
OBJS=or_clip.o or.o

all:  have_lib	$(TARGET)

have_lib:
	test -f $(ORACLE_HOME)/rdbms/demo/oci.h

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS) $(ORACLE_HOME)/lib/libclntsh.so

or_clip.o: or_clip.c
	$(CC) $(C_FLAGS) $(CLIPINCLUDE) $(ORINC) -c or_clip.c

or.o: or.prg oracle.ch
	$(CLIPROOT)/bin/clip -l or.prg

install: all
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(CLIPROOT)/lib
	mkdir -p $(CLIPROOT)/doc/clip-oracle
	cp *.html $(CLIPROOT)/doc/clip-oracle
	cp oracle.ch $(CLIPROOT)/include
	mkdir -p $(CLIPROOT)/doc/example/clip-oracle
	cp -R example/* $(CLIPROOT)/doc/example/clip-oracle/

clean:
	rm -rf *.o *.bak *.a *.so *.dll *.exe *.ex *.nm
