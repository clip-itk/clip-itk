ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
#CLIP	= clip
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -w -O -b -l
CLIPLIBS  = -lclip-codb -lcodb-query
TARGET = codb$(EXESUFF)
OBJS  = codb.o
.SUFFIXES: .prg .o .po

all: $(TARGET)

clean:
	rm -rf *.exe *.o *.s *.c *.a *.so *.po *.pa *.log *.uri *.b *.BAK *.bak *~ core* *core
	rm -rf $(TARGET) *.ex *.nm

$(TARGET): $(OBJS)
	$(CLIP) $(CLIPFLAGS) -eslM -o $(TARGET) $(OBJS) $(CLIPLIBS)

install:
	mkdir -p $(DESTDIR)$(CLIPROOT)/bin
	cp $(TARGET) $(DESTDIR)$(CLIPROOT)/bin

.prg.o:
	$(CLIP) $(CLIPFLAGS) -n $<

