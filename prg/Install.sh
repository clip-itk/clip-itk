#!/bin/sh
WRKDIR=`pwd`
echo $WRKDIR
echo $CLIPROOT

[ -n "$MAKE" ] || MAKE=make
export MAKE
set -e
if [ "$NODBU" = yes ]
then
	nodbu=yes
else
	nodbu=
fi
for arg in $*
do
	case "$arg" in
	-nodbu)
		nodbu=yes
		;;
	esac
done

if [ -d utils ]
then
	cd utils; $MAKE install; cd ..
fi

if [ -d debug ]
then
	cd debug; $MAKE install; cd ..
fi

if [ -d pp ]
then
	cd pp; $MAKE install; cd ..
fi

rm -f $CLIPROOT/bin/dbu*

if [ "$nodbu" != 'yes' ]
then

	if [ -d ca_dbu ]
	then
		cd ca_dbu
		$MAKE install
		cd ..
	fi
	if [ -d ca_dbu53 ]
	then
		cd ca_dbu53
		$MAKE install
		cd ..
	fi

fi

if [ -d hiper ]
then
	cd hiper
	$MAKE install
	cd ..
fi

if [ -d bdbfs ]
then
	cd bdbfs
	$MAKE install
	cd ..
fi

#
if [ "$CLIPROOT" != "$WRKDIR" ]
then
	cp -R locale.po $CLIPROOT
fi
$CLIPROOT/bin/clip_msgmerge
$CLIPROOT/bin/clip_msgfmt

