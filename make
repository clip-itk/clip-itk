#!/bin/sh

if [ -n "$MAKE" ]
then
	MAKE="$MAKE"
elif [ -x /usr/local/bin/gmake  ]
then
	MAKE=/usr/local/bin/gmake
elif [ -x /usr/bin/gmake ]
then
	MAKE=/usr/bin/gmake
else
	MAKE=/usr/bin/make
fi

export MAKE
#unset CLIPROOT

$MAKE $*
