# This is a part of CLIP-UI library
#
# Copyright (C) 2003 by E/AS Software Foundation
# Author: Andrey Cherepanov <sibskull@mail.ru>

include $(CLIPROOT)/include/Makefile.inc
#include ../../Makefile.var
CLIPINCLUDE = -I$(CLIPROOT)/include
CLIP = $(CLIPROOT)/bin/clip

.SUFFIXES: .prg .o .po

# Here you can define appropriate compile settings
#C_FLAGS=-Wall -g -I. $(CLIPINCLUDE)
#CC=gcc
OBJS    = driver-gtk.po

.PHONY: all clean uninstall distclean

all: $(OBJS)

clean:
	rm -f $(OBJS) *.bak *.nm *.ex *.ppo *.dll.a *.log *.dll

install: all
	mkdir -p $(DESTDIR)$(CLIPROOT)/lib/drivers
	$(CLIPROOT)/bin/clip_cp $(OBJS) $(DESTDIR)$(CLIPROOT)/lib/drivers

uninstall:
	rm -f $(CLIPROOT)/lib/drivers/$(OBJS)

distclean: clean

dist: distclean

.prg.po:
	$(CLIP) $(CLIPFLAGS) -n -p $<
