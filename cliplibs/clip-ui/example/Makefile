# CLIP-UI library examples Makefile
# Copyright (C) 2003-2005, E/AS Software Foundation
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
PRG1=test_ui
PRG2=form_ui
LIBS=-lclip-ui
EXTRALIBS=

all: $(PRG1) $(PRG2)

clean:
	rm -f *.o core* *core $(PRG1) $(PRG2) *.log *.nm *.ex *.exe $(OUTPUT)

$(PRG1): test_ui.prg
	$(CLIP) -eslM $(CLIPINCLUDE) test_ui.prg $(LIBS) $(EXTRALIBS) 

$(PRG2): form_ui.prg
	$(CLIP) -esl $(CLIPINCLUDE) form_ui.prg $(LIBS) $(EXTRALIBS)

#.prg.o:
#	$(CLIP) -l $(CLIPINCLUDE) $<
