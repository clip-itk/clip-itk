# CLIP-XML library examples Makefile
# Copyright (C) 2006, E/AS Software Foundation
# Web: http://eas.lrn.ru
# Copyright (C) 2006, ITK
# Web: http://www.itk.ru
ifndef CLIPROOT
	CLIPROOT=$(shell cd ../../../../; pwd)/cliproot
endif

include $(CLIPROOT)/include/Makefile.inc
CLIPINCLUDE = -I$(CLIPROOT)/include
CLIP = $(CLIPROOT)/bin/clip
C_FLAGS=-g

.SUFFIXES: .prg .o .po
.PHONY: all clean

# Widget tests
LIBS=-lclip-xml

PROGS=test_xml test

EXTRALIBS=

all: $(PROGS)

clean:
	rm -f *.o core* *core $(PROGS) *.log *.nm *.ex *.exe $(OUTPUT)
	rm -f *.exe *.c *.o *.a *.so *.po *.log *.pa *.b *.BAK *.bak *~ core* *core
	rm -rf *.ex *.nm

test_xml: test_xml.prg
	$(CLIP) -ewsln  $(C_FLAGS) $(CLIPINCLUDE) test_xml.prg $(LIBS) $(EXTRALIBS)

test: test.prg
	clip -esg test.prg $(LIBS)

