#!/bin/sh
arname=clip.tgz
echo creating archive \'$arname\' ...
echo
dirs=". dbu mapbase screen mapfile dbf sys memdebug include tests"

suflist=".sh .cc .c .h .y .lex .prg .PRG .ch .CH .txt .LNK .RMK .DBF .HLP .cliprc .orig"
inclist="Makefile makefile
"exclude="y.tab.c\\|lex.yy.c"

flist=""

for i in $dirs
do
   for j in $suflist
   do
       flist="$flist `ls $i/*$j 2>/dev/null|grep -v $exclude`"
   done
   for j in $inclist
   do
       flist="$flist `ls $i/$j 2>/dev/null`"
   done
done


gtar czvf $arname $flist

if [ $? != 0 ] ; then
  echo errors!
  exit 1
fi

echo
echo archive \'$arname\' succesfully created
ls -l $arname
if [ $# != 0 ] ; then
   rm -f $arname.tmp
   mdel a:$arname
   mcopy -n $arname a: && mcopy a:$arname ./$arname.tmp
   mdir a:
   rm -f $arname.tmp
fi

