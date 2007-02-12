# CLIP-POSTSCRIPT library examples Makefile
# Copyright (C) 2007, E/AS Software Foundation
# Web: http://eas.lrn.ru
ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc
CLIPINCLUDE = -I$(CLIPROOT)/include
CLIP = $(CLIPROOT)/bin/clip

.SUFFIXES: .prg .o .po
.PHONY: all clean

# Form test
PRG=testform
LIBS=-lclip-postscript -lclip-xml -lexpat

all: $(PRG)

clean:
	rm -f *.o *.bak core* *core $(PRG) *.log *.nm *.ex *.exe

$(PRG): testform.prg
	$(CLIP) -ewsln $(CLIPINCLUDE) testform.prg $(LIBS)
