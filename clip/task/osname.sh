#!/bin/sh
uname=`uname -s 2>/dev/null`
osname=$uname
case "$uname" in
	BSD/OS*|bsdi*)
		osname=BSDI
		;;
	[lL]inux*)
		osname=LINUX
		;;
	FreeBSD*)
		osname=FREEBSD
		STATICLINK=-static
		;;
	NetBSD*)
		osname=NETBSD
		;;
	OpenBSD*)
		osname=OPENBSD
		;;
	SunOS*)
		osname=SUNOS
		;;
	CYGWIN*)
		osname=CYGWIN
		;;
esac

echo $osname
