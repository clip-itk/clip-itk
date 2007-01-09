# CLIP-UI library examples Makefile
# Copyright (C) 2003-2006, E/AS Software Foundation
# Web: http://eas.lrn.ru
ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc
CLIPINCLUDE = -I$(CLIPROOT)/include
CLIP = $(CLIPROOT)/bin/clip

.SUFFIXES: .prg .o .po
.PHONY: all clean

# Widget tests
PRG1=uitest
PRG2=uiform
LIBS=-lclip-ui -lclip-xml -lexpat
EXTRALIBS=

all: $(PRG1) $(PRG2)

clean:
	rm -f *.o *.bak core* *core $(PRG1) $(PRG2) *.log *.nm *.ex *.exe $(OUTPUT) image[0-9]*

$(PRG1): uitest.prg
	$(CLIP) -ewslM $(CLIPINCLUDE) uitest.prg $(LIBS) $(EXTRALIBS)

$(PRG2): uiform.prg
	$(CLIP) -ewsln $(CLIPINCLUDE) uiform.prg $(LIBS) $(EXTRALIBS)

#.prg.o:
#	$(CLIP) -l $(CLIPINCLUDE) $<
