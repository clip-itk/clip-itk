#!/bin/sh

a="$OSTYPE"
[ -z "$a" ] && a=`uname -s`
[ -z "$a" ] && a=unknown

echo $a
