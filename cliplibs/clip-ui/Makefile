# Makefile for clip-ui custom variables
RBINDIR=/m6/uri/cliproot/bin
RLIBDIR=/m6/uri/cliproot/lib
# This is a part of CLIP-UI library
#
# Copyright (C) 2003 by E/AS Software Foundation
# Author: Andrey Cherepanov <sibskull@mail.ru>

include $(CLIPROOT)/include/Makefile.inc
include Makefile.var

DRIVERSDIR = $(DESTDIR)$(CLIPROOT)/lib/drivers
CLIPINCLUDE =
#-I$(CLIPROOT)/include
CLIP = $(CLIPROOT)/bin/clip

.SUFFIXES: .prg .o .po

# Here you can define appropriate compile settings
#C_FLAGS=-Wall -g -I. $(CLIPINCLUDE)
#CC=gcc
TARGET  = libclip-ui$(DLLSUFF)
RTARGET = libclip-ui$(DLLREALSUFF)

OBJS    = button.o checkbox.o color.o combobox.o edit.o font.o form.o \
	  frame.o grid.o image.o label.o menu.o special.o table.o timer.o \
	  toolbar.o tree.o utils.o window.o workspace.o

.PHONY: all clean uninstall distclean

all: configure var.ch driver $(TARGET)

configure: Makefile Makefile.var
	./configure

var.ch:
	echo "#define DRIVERSDIR \"$(DRIVERSDIR)\"" >var.ch

driver:
	cd drivers; make all

$(TARGET): $(OBJS)
	$(CLIPROOT)/bin/clip_makeslib $(TARGET) $(OBJS)

clean:
	cd drivers; make clean
	cd examples; make clean
	rm -f $(OBJS) $(TARGET) var.ch *.bak *.nm *.ex *.ppo *.dll.a *.log *.dll


install: all
	cd drivers; make install
	mkdir -p $(DESTDIR)$(CLIPROOT)/lib
	mkdir -p $(DESTDIR)$(CLIPROOT)/include
	$(CLIPROOT)/bin/clip_cp $(TARGET) $(DESTDIR)$(CLIPROOT)/lib
	$(CLIPROOT)/bin/clip_cp clip-ui.ch $(DESTDIR)$(CLIPROOT)/include
	mkdir -p $(CLIPROOT)/doc/example/clip-ui
	cp -RL examples/* $(CLIPROOT)/doc/example/clip-ui/

uninstall:
	cd drivers; make uninstall
	rm -rf $(CLIPROOT)/lib/$(TARGET) $(CLIPROOT)/doc/example/clip-ui/
	rm -f  $(CLIPROOT)/include/clip-ui.ch

distclean: clean
	cd examples; make clean
	rm -f Makefile Makefile.var

dist: distclean

.prg.o: clip-ui.ch
	$(CLIP) $(CLIPINCLUDE) $<

commit:
	_cvs commit

update:
	_cvs update -dP

ucommit:
	_cvs update -dP && _cvs commit

shell:
	sh

