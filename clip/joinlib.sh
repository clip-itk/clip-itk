#!/bin/sh
if [ $# = 0 ]
then
	echo "usage: `basename $0` target.a src1.a .. srcN.a"
	exit 1
fi

pwd=`pwd`
arch=$pwd/$1
target=`echo "$pwd/$1" | sed -e 's/\.[A-Za-z0-9]*$//'`
shift

dir=/tmp/$$
mkdir -p $dir

cd $dir

for i in $*
do
	ar -x $pwd/$i
    	name=`echo "$pwd/$i" | sed -e 's/\.[A-Za-z0-9]*$//'`
	test -r "$name.ex" && cp "$name.ex" .
	test -r "$name.nm" && cp "$name.nm" .
done

rm -f $arch
ar -q $arch *.o
ranlib $arch

case "$CLIP_NAMES" in
1|[yY][eE][sS]|[oO][nN])

	cat *.nm 2>/dev/null | grep -v '^#\|^$' | sort -u > $target.nm

	if join --version >/dev/null 2>&1
	then
		cat *.ex 2>/dev/null | grep -v '^#\|^$' | sort -u > _ex
		join -v 1 _ex $target.nm > $target.ex
	else
		cat *.ex 2>/dev/null | grep -v '^#\|^$' | sort -u > $target.ex
	fi
	
	;;
esac



cd $pwd

rm -rf $dir
