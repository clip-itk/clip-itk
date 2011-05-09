#!/bin/sh

seq_no=0
if [ -f seq_no.txt ]
then
	read seq_no < cat seq_no.txt
	if [ X$seq_no = X ]
	then
		seq_no=0
	fi
fi

echo $seq_no
seq_no=`expr $seq_no + 1`
echo $seq_no >seq_no.txt
