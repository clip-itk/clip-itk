#!/bin/sh

a="$HOSTTYPE"
[ -z "$a" ] && a=`uname -m 2>/dev/null`
[ -z "$a" ] && a=`uname -p 2>/dev/null`
[ -z "$a" ] && a=unknown

case "$a" in
i?86)
	echo i386
	;;
*)
	echo $a
	;;
esac

