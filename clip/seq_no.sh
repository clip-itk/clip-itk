#!/bin/sh

seq_no=
if [ -s seq_no.txt ]; then
	read seq_no < seq_no.txt
fi

if [ "X$seq_no" = X ]; then
	echo 0
else
	expr "$seq_no" + 1
fi | tee seq_no.txt
