#  GNU make makefile
#
ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc

ifndef ORACLE_HOME
ORACLE_HOME=/usr/local/oracle_home
endif

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
	$(CC) $(C_FLAGS) $(ORINC) -c or_clip.c

or.o: or.prg oracle.ch
	$(CLIPROOT)/bin/clip -l or.prg

install:
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(DESTDIR)$(CLIPROOT)/lib
	#[ "$(TARGET)" = "$(RTARGET)" ] || cp $(RTARGET) $(DESTDIR)$(CLIPROOT)/lib
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/clip-oracle
	cp *.html $(DESTDIR)$(CLIPROOT)/doc/clip-oracle
	cp oracle.ch $(DESTDIR)$(CLIPROOT)/include
	mkdir -p $(DESTDIR)$(CLIPROOT)/doc/example/clip-oracle
	cp -R example/* $(DESTDIR)$(CLIPROOT)/doc/example/clip-oracle/

clean:
	rm -rf *.o or.c *.s *.bak *.a *.so *.dll *.exe *.ex *.nm
