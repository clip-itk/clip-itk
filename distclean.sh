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
	MAKE=make
fi

export MAKE
unset CLIPROOT
pwd=`pwd`

rm -rf debian/tmp debian/clip-lib clip-dev.spec

cd clip
	$MAKE distclean || true
cd $pwd
cd prg
	./Clean.sh || true
cd $pwd
cd cliplibs
$MAKE distclean
rm -f clip-dev.spec _lst _nlst
cd $pwd
#find . -name '*.ex' -or -name '*.nm' |  xargs rm -f

