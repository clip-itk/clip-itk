#!/bin/sh
if [ -z "$OSTYPE" ]
then
	OSTYPE=`uname`
fi

case "$OSTYPE" in
	BSD/OS*|bsdi*)	name=BSDI ;;
  	[lL][iI][nN][uU][xX]*)	name=LINUX ;;
	[fF][rR][eE][eE][bB][sS][dD]*)	name=FREEBSD ;;
	[nN][eE][tT][bB][sS][dD]*)	name=NETBSD ;;
esac


echo $name
