#!/bin/sh
echo
echo Generating .uni from .cp files
codepages=*.cp
if [ -n "$codepages" ]
then
for ii in codepages
do
(
	i=${ii%.cp}
	echo -n $i' ' 1>&2
	echo
	tail +3 $i.cp | \
		( while read l p c
                do
                	if [ -z "$l" ]
                        then
                        	continue
			fi
                        case "$l" in
                        	\#*)   	echo $l $p $c
                                        ;;
                        	0x*)   	if [ -z "$p" ]
                        		then
                        			continue
                        		fi
                                        case "$p" in
                                        	\#*) continue ;;
                                        esac
                			echo $l'	'U+${p#0x}'	'$c
                                	;;
                        esac
                done )

) | sed 's///g' > $i.uni
done

fi
echo
