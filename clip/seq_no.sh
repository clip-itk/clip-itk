
#!/bin/sh

./_cvs history -w -D `cat release_date` -a -c | awk '{print $2,$3,$4,$8}' | \
	 grep -w clip | cut -b 1-16 |  uniq | wc -l | tr -d ' \t'


#seq_no=0
#if [ -f seq_no.txt ]
#then
#	seq_no=`cat seq_no.txt`
#	if [ X$seq_no = X ]
#	then
#		seq_no=0
#	fi
#fi
#
#echo $seq_no
#seq_no=`expr $seq_no + 1`
#echo $seq_no >seq_no.txt
