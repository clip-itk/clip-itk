#!/bin/sh

[ -z "$CLIPROOT" ] && CLIPROOT=$1
[ -z "$BINDIR" ] && BINDIR=$2

[ -n "$BINDIR" -a -n "$CLIPROOT" ] || exit 1

#[ `id -u` = 0 ] || exit 0

chown -R root $DESTDIR$CLIPROOT 2>/dev/null || exit 0
chmod -R a+r,go-w $DESTDIR$CLIPROOT

cd  $DESTDIR/usr/share/terminfo \
	|| cd $DESTDIR/usr/lib/terminfo \
	|| exit 0

cd l || exit 0

#ln -sf linux-koi8 linux-stelnet
#ln -sf linux-koi8 linux-trans
#ln -sf linux linux-console

exit 0
