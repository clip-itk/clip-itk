#!/bin/sh

. $CLIPROOT/include/clipcfg.sh

. gd/Makefile.inc

#ifdef CLIPROOT
#include $(CLIPROOT)/include/Makefile.inc
#endif

XLIB=libclip-gd.a
name=libclip-gd${DLLSUFF}
[ -z "$1" ] || name="$1"

LIBS="-lz -lm $LIBPNG $LIBJPEG $LIBFREETYPE $LIBTTF $LIBXPM"

#CFLAGS='-L/usr/X11R6/lib'
CFLAGS="$LIBDIRS"
export CFLAGS
$CLIPROOT/bin/clip_makeslib $name $XLIB ./gd/libgd.a $LIBS

