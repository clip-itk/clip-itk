#!/bin/sh
# script to change old style clip function names to new one
# ( with prefix clip_ )

for i in $*
do
	printf "$i .. "
	cp $i $i.bak
	if [ $? != 0 ]
	then
		echo error: cannot backup file $i
		exit 1
	fi
	sed -e 's/^[A-Z_][A-Z_]*(/clip_\0/' $i.bak >$i
	echo done
done
