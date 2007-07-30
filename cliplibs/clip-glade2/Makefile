# Makefile for clip-libglade2

ifndef CLIPROOT
	CLIPROOT=/usr/local/clip
endif

include $(CLIPROOT)/include/Makefile.inc

# Check libglade version.
LIBGLADE_MIN=2.4.2

LIBGLADE_VER=$(shell pkg-config --modversion libglade-2.0 2> /dev/null )


XTARGET=$(XLIB) $(XSLIB)

CFLAGS = $(C_FLAGS) `pkg-config --cflags libglade-2.0` -I../clip-gtk2

OBJS=clip_glade.o

LIBS=`pkg-config --libs libglade-2.0`

XLIB=libclip-glade2.a
XSLIB=libclip-glade2$(DLLSUFF)



.SUFFIXES: .c .o


all: have_libglade  $(XTARGET)


have_libglade:
	@ test -n "$(LIBGLADE_VER)" || echo libglade2 not found
	@ test -n "$(LIBGLADE_VER)" || exit
	@ test $(LIBGLADE_VER) '>' $(LIBGLADE_MIN) -o $(LIBGLADE_VER) = $(LIBGLADE_MIN)  || echo libglade detected $(LIBGLADE_VER), needed $(LIBGLADE_MIN) or upper && exit
	@ test $(LIBGLADE_VER) '>' $(LIBGLADE_MIN) -o $(LIBGLADE_VER) = $(LIBGLADE_MIN)  && exit



$(XLIB): $(OBJS)
	rm -f $(XLIB)
	clip_makelib $(XLIB) $(OBJS) 
	ranlib $(XLIB)

$(XSLIB): $(XLIB)
	rm -f $(XSLIB)
	clip_makeslib $(XSLIB) $(XLIB) $(LIBS)


install: 
	$(CLIPROOT)/bin/clip_cp $(XLIB) $(SXLIB) $(DESTDIR)$(CLIPROOT)/lib
	chmod 0644 $(DESTDIR)$(CLIPROOT)/lib/$(XLIB)
	chmod 0755 $(DESTDIR)$(CLIPROOT)/lib/$(XSLIB)

.c.o:
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f *.o *~ *$(DLLSUFF) *.a *.nm *.ex

