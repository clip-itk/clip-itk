#!/bin/sh

if [ $# == 0 ]
then
	echo "usage: $0 from_tags -- to_tags"
	echo "for example: $0 -D 2002-01-01 -- -D 2002-02-01"
	echo "environment variables CVS_RSH and CVSROOT are used"
	exit 1
fi

test -n "$CVSROOT" || CVSROOT=':ext:itk@clip-itk.cvs.sourceforge.net:/cvsroot/clip-itk'
test -n "$CVS_RSH" || CVS_RSH='ssh'

export CVSROOT CVS_RSH

from_tags=''
to_tags=''

tags='from_tags'

for opt in $*
do
	case "$opt" in
	--)
		tags='to_tags'
		;;
	*)
		eval "$tags=\"\$$tags \$opt\""
		;;
	esac
done

from_name=`echo $from_tags|tr -d '-'|tr '. ,/:' '_____'`

if [ -z "$to_tags" ]
then
	to_name=`date +latest_D%Y%m%d`
else
	to_name=`echo $to_tags|tr -d '-'|tr '. ,/:' '_____'`
fi

echo "from: $from_tags: $from_name"
echo "to: $to_tags: $to_name"

pwd=`pwd`
wd="$pwd"
tmp="/tmp/$$dir"

clean()
{
	cd $pwd
	rm -rf $from_name $to_name $tmp
	exit $1
}

set -e

trap clean ERR 1 2 3 4 5 6 7 8 9 10 12 13 14 15

clipdirs="clip prg cliplibs"
mkdir -p $tmp

checkout()
{
	tags="$1"
	name="$2"
	echo "checkout $name"

	cd $wd
	mkdir -p $name
	cd $name

	echo "checkout" $tags $dir
	cvs checkout $tags clip-prg >/dev/null 2>&1
	cd clip-prg

	for dir in $clipdirs
	do
		cvs checkout $tags $dir >/dev/null 2>&1
	done
}

################################

checkout "$from_tags" "$from_name"
checkout "$to_tags" "$to_name"
cd $wd
pwd
cd $to_name/clip-prg/clip; ./seq_no.sh; cd $wd
pwd

################################

echo "comparing $from_name and $to_name"
cd $wd/$to_name
find . \( ! -path '*/CVS/*' -a -type f \) >$tmp/to_list
cd $wd

exec 3>$tmp/p_list

while read name
do
	if ! cmp $from_name/$name $to_name/$name >/dev/null 2>&1
	then
		echo $name >&3
	fi
done < $tmp/to_list

exec 3>&-

cd $wd
echo tar czf "$pwd/patch-$from_name-$to_name.tgz" -T $tmp/p_list  -C $to_name
tar czf "$pwd/patch-$from_name-$to_name.tgz" -T $tmp/p_list  -C $to_name


clean 0
