#!/bin/sh

GLIBC=`grep '^#define[ 	]*__GLIBC__' /usr/include/features.h 2>/dev/null | tr -s ' 	' ' ' | cut -d' ' -f3`
GLIBC_MINOR=`grep '^#define[ 	]*__GLIBC_MINOR__' /usr/include/features.h 2>/dev/null | tr -s ' 	' ' ' | cut -d' ' -f3`
GNU_LIBRARY=`grep '^#define[ 	]*__GNU_LIBRARY__' /usr/include/features.h 2>/dev/null | tr -s ' 	' ' ' | cut -d' ' -f3`

#echo $GLIBC $GLIBC_MINOR $GNU_LIBRARY
if [ -n "$GLIBC" -a -n "$GLIBC_MINOR" ]
then
	echo "glibc$GLIBC.$GLIBC_MINOR"
elif [ -n "$GNU_LIBRARY" ]
then
	echo "libc$GNU_LIBRARY"
else
	name="`uname -r`"
	if [ -n "$name" ]
	then
		echo "$name"
	else
		echo "libc_unknown"
	fi
fi
