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
		rname=`uname -r 2>/dev/null`
                case "$rname" in
                	"5.7")
                              	osname=SOLARIS_7
                              	;;
                	"5.8")
                              	osname=SOLARIS_8
                              	;;
                	"5.9")
                              	osname=SOLARIS_9
                              	;;
                esac
		;;
	CYGWIN*)
		osname=CYGWIN
		;;
esac

echo $osname
