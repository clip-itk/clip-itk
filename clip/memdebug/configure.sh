#!/bin/sh
# Guess values for system-dependent variables and create Makefiles.
# Generated automatically using autoconf.
# Copyright (C) 1991, 1992, 1993 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

# Usage: configure [--srcdir=DIR] [--host=HOST] [--gas] [--nfp] [--no-create]
#        [--prefix=PREFIX] [--exec-prefix=PREFIX] [--with-PACKAGE] [TARGET]
# Ignores all args except --srcdir, --prefix, --exec-prefix, --no-create, and
# --with-PACKAGE unless this script has special code to handle it.


for arg
do
  # Handle --exec-prefix with a space before the argument.
  if test x$next_exec_prefix = xyes; then exec_prefix=$arg; next_exec_prefix=
  # Handle --host with a space before the argument.
  elif test x$next_host = xyes; then next_host=
  # Handle --prefix with a space before the argument.
  elif test x$next_prefix = xyes; then prefix=$arg; next_prefix=
  # Handle --srcdir with a space before the argument.
  elif test x$next_srcdir = xyes; then srcdir=$arg; next_srcdir=
  else
    case $arg in
     # For backward compatibility, also recognize exact --exec_prefix.
     -exec-prefix=* | --exec_prefix=* | --exec-prefix=* | --exec-prefi=* | --exec-pref=* | --exec-pre=* | --exec-pr=* | --exec-p=* | --exec-=* | --exec=* | --exe=* | --ex=* | --e=*)
	exec_prefix=`echo $arg | sed 's/[-a-z_]*=//'` ;;
     -exec-prefix | --exec_prefix | --exec-prefix | --exec-prefi | --exec-pref | --exec-pre | --exec-pr | --exec-p | --exec- | --exec | --exe | --ex | --e)
	next_exec_prefix=yes ;;

     -gas | --gas | --ga | --g) ;;

     -host=* | --host=* | --hos=* | --ho=* | --h=*) ;;
     -host | --host | --hos | --ho | --h)
	next_host=yes ;;

     -nfp | --nfp | --nf) ;;

     -no-create | --no-create | --no-creat | --no-crea | --no-cre | --no-cr | --no-c | --no- | --no)
        no_create=1 ;;

     -prefix=* | --prefix=* | --prefi=* | --pref=* | --pre=* | --pr=* | --p=*)
	prefix=`echo $arg | sed 's/[-a-z_]*=//'` ;;
     -prefix | --prefix | --prefi | --pref | --pre | --pr | --p)
	next_prefix=yes ;;

     -srcdir=* | --srcdir=* | --srcdi=* | --srcd=* | --src=* | --sr=* | --s=*)
	srcdir=`echo $arg | sed 's/[-a-z_]*=//'` ;;
     -srcdir | --srcdir | --srcdi | --srcd | --src | --sr | --s)
	next_srcdir=yes ;;

     -with-* | --with-*)
       package=`echo $arg|sed 's/-*with-//'`
       # Delete all the valid chars; see if any are left.
       if test -n "`echo $package|sed 's/[-a-zA-Z0-9_]*//g'`"; then
         echo "configure: $package: invalid package name" >&2; exit 1
       fi
       eval "with_`echo $package|sed s/-/_/g`=1" ;;

     *) ;;
    esac
  fi
done

trap 'rm -f conftest* core; exit 1' 1 3 15

rm -f conftest*
compile='${CC-cc} $DEFS conftest.c -o conftest $LIBS >/dev/null 2>&1'

# A filename unique to this package, relative to the directory that
# configure is in, which we can look for to find out if srcdir is correct.
unique_file=malloc.c

# Find the source files, if location was not specified.
if test -z "$srcdir"; then
  srcdirdefaulted=yes
  # Try the directory containing this script, then `..'.
  prog=$0
  confdir=`echo $prog|sed 's%/[^/][^/]*$%%'`
  test "X$confdir" = "X$prog" && confdir=.
  srcdir=$confdir
  if test ! -r $srcdir/$unique_file; then
    srcdir=..
  fi
fi
if test ! -r $srcdir/$unique_file; then
  if test x$srcdirdefaulted = xyes; then
    echo "configure: Can not find sources in \`${confdir}' or \`..'." 1>&2
  else
    echo "configure: Can not find sources in \`${srcdir}'." 1>&2
  fi
  exit 1
fi
# Preserve a srcdir of `.' to avoid automounter screwups with pwd.
# But we can't avoid them for `..', to make subdirectories work.
case $srcdir in
  .|/*|~*) ;;
  *) srcdir=`cd $srcdir; pwd` ;; # Make relative path absolute.
esac


echo Configuring for the malloc-debug library
echo .
echo checking programs:
if test -z "$CC"; then
  echo checking for gcc
  saveifs="$IFS"; IFS="${IFS}:"
  for dir in $PATH; do
    test -z "$dir" && dir=.
    if test -f $dir/gcc; then
      CC="gcc"
      break
    fi
  done
  IFS="$saveifs"
fi
test -z "$CC" && CC="cc"

# Find out if we are using GNU C, under whatever name.
cat > conftest.c <<EOF
#ifdef __GNUC__
  yes
#endif
EOF
${CC-cc} -E conftest.c > conftest.out 2>&1
if egrep yes conftest.out >/dev/null 2>&1; then
  GCC=1 # For later tests.
fi
rm -f conftest*

# Make sure to not get the incompatible SysV /etc/install and
# /usr/sbin/install, which might be in PATH before a BSD-like install,
# or the SunOS /usr/etc/install directory, or the AIX /bin/install,
# or the AFS install, which mishandles nonexistent args.  (Sigh.)
if test -z "$INSTALL"; then
  echo checking for install
  saveifs="$IFS"; IFS="${IFS}:"
  for dir in $PATH; do
    test -z "$dir" && dir=.
    case $dir in
    /etc|/usr/sbin|/usr/etc|/usr/afsws/bin) ;;
    *)
      if test -f $dir/install; then
	if grep dspmsg $dir/install >/dev/null 2>&1; then
	  : # AIX
	else
	  INSTALL="$dir/install -c"
	  INSTALL_PROGRAM='$(INSTALL)'
	  INSTALL_DATA='$(INSTALL) -m 644'
	  break
	fi
      fi
      ;;
    esac
  done
  IFS="$saveifs"
fi
INSTALL=${INSTALL-cp}
INSTALL_PROGRAM=${INSTALL_PROGRAM-'$(INSTALL)'}
INSTALL_DATA=${INSTALL_DATA-'$(INSTALL)'}

if test -z "$RANLIB"; then
  echo checking for ranlib
  saveifs="$IFS"; IFS="${IFS}:"
  for dir in $PATH; do
    test -z "$dir" && dir=.
    if test -f $dir/ranlib; then
      RANLIB="ranlib"
      break
    fi
  done
  IFS="$saveifs"
fi
test -z "$RANLIB" && RANLIB="@:"

echo .
echo checking functions:
for func in bcmp bcopy memcmp memcpy memset
do
trfunc=HAVE_`echo $func | tr '[a-z]' '[A-Z]'`
echo checking for ${func}
cat > conftest.c <<EOF
#include <stdio.h>
main() { exit(0); } 
t() { 
#ifdef __stub_${func}
choke me
#else
/* Override any gcc2 internal prototype to avoid an error.  */
extern char ${func}(); ${func}();
#endif
 }
EOF
if eval $compile; then
  DEFS="$DEFS -D${trfunc}=1"
SEDDEFS="${SEDDEFS}\${SEDdA}${trfunc}\${SEDdB}${trfunc}\${SEDdC}1\${SEDdD}
\${SEDuA}${trfunc}\${SEDuB}${trfunc}\${SEDuC}1\${SEDuD}
\${SEDeA}${trfunc}\${SEDeB}${trfunc}\${SEDeC}1\${SEDeD}
"
fi
rm -f conftest*
#endif
done

echo checking for _index
cat > conftest.c <<EOF

main() { exit(0); }
t() {
#ifdef __stub_index
choke me
#else
/* Override any gcc2 internal prototype to avoid an error.  */
extern char index(); index();
#endif
 }

EOF
eval $compile
if test -s conftest && (./conftest; exit) 2>/dev/null; then
  
DEFS="$DEFS -DHAVE_INDEX=1"
SEDDEFS="${SEDDEFS}\${SEDdA}HAVE_INDEX\${SEDdB}HAVE_INDEX\${SEDdC}1\${SEDdD}
\${SEDuA}HAVE_INDEX\${SEDuB}HAVE_INDEX\${SEDuC}1\${SEDuD}
\${SEDeA}HAVE_INDEX\${SEDeB}HAVE_INDEX\${SEDeC}1\${SEDeD}
"

else
  
DEFS="$DEFS -DHAVE_INDEX=0"
SEDDEFS="${SEDDEFS}\${SEDdA}HAVE_INDEX\${SEDdB}HAVE_INDEX\${SEDdC}0\${SEDdD}
\${SEDuA}HAVE_INDEX\${SEDuB}HAVE_INDEX\${SEDuC}0\${SEDuD}
\${SEDeA}HAVE_INDEX\${SEDeB}HAVE_INDEX\${SEDeC}0\${SEDeD}
"

fi
rm -f conftest*
for func in rindex
do
trfunc=HAVE_`echo $func | tr '[a-z]' '[A-Z]'`
echo checking for ${func}
cat > conftest.c <<EOF
#include <stdio.h>
main() { exit(0); } 
t() { 
#ifdef __stub_${func}
choke me
#else
/* Override any gcc2 internal prototype to avoid an error.  */
extern char ${func}(); ${func}();
#endif
 }
EOF
if eval $compile; then
  DEFS="$DEFS -D${trfunc}=1"
SEDDEFS="${SEDDEFS}\${SEDdA}${trfunc}\${SEDdB}${trfunc}\${SEDdC}1\${SEDdD}
\${SEDuA}${trfunc}\${SEDuB}${trfunc}\${SEDuC}1\${SEDuD}
\${SEDeA}${trfunc}\${SEDeB}${trfunc}\${SEDeC}1\${SEDeD}
"
fi
rm -f conftest*
#endif
done

for func in strcat strcmp strlen strtok
do
trfunc=HAVE_`echo $func | tr '[a-z]' '[A-Z]'`
echo checking for ${func}
cat > conftest.c <<EOF
#include <stdio.h>
main() { exit(0); } 
t() { 
#ifdef __stub_${func}
choke me
#else
/* Override any gcc2 internal prototype to avoid an error.  */
extern char ${func}(); ${func}();
#endif
 }
EOF
if eval $compile; then
  DEFS="$DEFS -D${trfunc}=1"
SEDDEFS="${SEDDEFS}\${SEDdA}${trfunc}\${SEDdB}${trfunc}\${SEDdC}1\${SEDdD}
\${SEDuA}${trfunc}\${SEDuB}${trfunc}\${SEDuC}1\${SEDuD}
\${SEDeA}${trfunc}\${SEDeB}${trfunc}\${SEDeC}1\${SEDeD}
"
fi
rm -f conftest*
#endif
done

echo .
echo checking various functions for string checking
for func in bzero
do
trfunc=HAVE_`echo $func | tr '[a-z]' '[A-Z]'`
echo checking for ${func}
cat > conftest.c <<EOF
#include <stdio.h>
main() { exit(0); } 
t() { 
#ifdef __stub_${func}
choke me
#else
/* Override any gcc2 internal prototype to avoid an error.  */
extern char ${func}(); ${func}();
#endif
 }
EOF
if eval $compile; then
  DEFS="$DEFS -D${trfunc}=1"
SEDDEFS="${SEDDEFS}\${SEDdA}${trfunc}\${SEDdB}${trfunc}\${SEDdC}1\${SEDdD}
\${SEDuA}${trfunc}\${SEDuB}${trfunc}\${SEDuC}1\${SEDuD}
\${SEDeA}${trfunc}\${SEDeB}${trfunc}\${SEDeC}1\${SEDeD}
"
fi
rm -f conftest*
#endif
done

for func in memccpy memchr
do
trfunc=HAVE_`echo $func | tr '[a-z]' '[A-Z]'`
echo checking for ${func}
cat > conftest.c <<EOF
#include <stdio.h>
main() { exit(0); } 
t() { 
#ifdef __stub_${func}
choke me
#else
/* Override any gcc2 internal prototype to avoid an error.  */
extern char ${func}(); ${func}();
#endif
 }
EOF
if eval $compile; then
  DEFS="$DEFS -D${trfunc}=1"
SEDDEFS="${SEDDEFS}\${SEDdA}${trfunc}\${SEDdB}${trfunc}\${SEDdC}1\${SEDdD}
\${SEDuA}${trfunc}\${SEDuB}${trfunc}\${SEDuC}1\${SEDuD}
\${SEDeA}${trfunc}\${SEDeB}${trfunc}\${SEDeC}1\${SEDeD}
"
fi
rm -f conftest*
#endif
done

for func in strchr strrchr strcpy strncpy strcasecmp strncasecmp
do
trfunc=HAVE_`echo $func | tr '[a-z]' '[A-Z]'`
echo checking for ${func}
cat > conftest.c <<EOF
#include <stdio.h>
main() { exit(0); } 
t() { 
#ifdef __stub_${func}
choke me
#else
/* Override any gcc2 internal prototype to avoid an error.  */
extern char ${func}(); ${func}();
#endif
 }
EOF
if eval $compile; then
  DEFS="$DEFS -D${trfunc}=1"
SEDDEFS="${SEDDEFS}\${SEDdA}${trfunc}\${SEDdB}${trfunc}\${SEDdC}1\${SEDdD}
\${SEDuA}${trfunc}\${SEDuB}${trfunc}\${SEDuC}1\${SEDuD}
\${SEDeA}${trfunc}\${SEDeB}${trfunc}\${SEDeC}1\${SEDeD}
"
fi
rm -f conftest*
#endif
done

for func in strspn strcspn strncat strncmp strpbrk strstr
do
trfunc=HAVE_`echo $func | tr '[a-z]' '[A-Z]'`
echo checking for ${func}
cat > conftest.c <<EOF
#include <stdio.h>
main() { exit(0); } 
t() { 
#ifdef __stub_${func}
choke me
#else
/* Override any gcc2 internal prototype to avoid an error.  */
extern char ${func}(); ${func}();
#endif
 }
EOF
if eval $compile; then
  DEFS="$DEFS -D${trfunc}=1"
SEDDEFS="${SEDDEFS}\${SEDdA}${trfunc}\${SEDdB}${trfunc}\${SEDdC}1\${SEDdD}
\${SEDuA}${trfunc}\${SEDuB}${trfunc}\${SEDuC}1\${SEDuD}
\${SEDeA}${trfunc}\${SEDeB}${trfunc}\${SEDeC}1\${SEDeD}
"
fi
rm -f conftest*
#endif
done

echo .
echo PLEASE WATCH: checking for very important functionality:
for func in sbrk
do
trfunc=HAVE_`echo $func | tr '[a-z]' '[A-Z]'`
echo checking for ${func}
cat > conftest.c <<EOF
#include <stdio.h>
main() { exit(0); } 
t() { 
#ifdef __stub_${func}
choke me
#else
/* Override any gcc2 internal prototype to avoid an error.  */
extern char ${func}(); ${func}();
#endif
 }
EOF
if eval $compile; then
  DEFS="$DEFS -D${trfunc}=1"
SEDDEFS="${SEDDEFS}\${SEDdA}${trfunc}\${SEDdB}${trfunc}\${SEDdC}1\${SEDdD}
\${SEDuA}${trfunc}\${SEDuB}${trfunc}\${SEDuC}1\${SEDuD}
\${SEDeA}${trfunc}\${SEDeB}${trfunc}\${SEDeC}1\${SEDeD}
"
fi
rm -f conftest*
#endif
done

echo checking for heap ordering...
cat > conftest.c <<EOF

main()
{
  char	* first, *next;
  first = sbrk(1024);
  next = sbrk(1024);
  if (next > first)
    exit(0);
  else
    exit(1);
}

EOF
eval $compile
if test -s conftest && (./conftest; exit) 2>/dev/null; then
  
DEFS="$DEFS -DHEAP_GROWS_UP=1"
SEDDEFS="${SEDDEFS}\${SEDdA}HEAP_GROWS_UP\${SEDdB}HEAP_GROWS_UP\${SEDdC}1\${SEDdD}
\${SEDuA}HEAP_GROWS_UP\${SEDuB}HEAP_GROWS_UP\${SEDuC}1\${SEDuD}
\${SEDeA}HEAP_GROWS_UP\${SEDeB}HEAP_GROWS_UP\${SEDeC}1\${SEDeD}
"
echo '   FYI: your heap seems to grow up.'

else
  
DEFS="$DEFS -DHEAP_GROWS_UP=0"
SEDDEFS="${SEDDEFS}\${SEDdA}HEAP_GROWS_UP\${SEDdB}HEAP_GROWS_UP\${SEDdC}0\${SEDdD}
\${SEDuA}HEAP_GROWS_UP\${SEDuB}HEAP_GROWS_UP\${SEDuC}0\${SEDuD}
\${SEDeA}HEAP_GROWS_UP\${SEDeB}HEAP_GROWS_UP\${SEDeC}0\${SEDeD}
"
echo '   FYI: your heap seems to grow down.'
echo '   WARNING: the library has little support for this.'

fi
rm -f conftest*
echo .
if test -n "$prefix"; then
  test -z "$exec_prefix" && exec_prefix='${prefix}'
  prsub="s%^prefix\\([ 	]*\\)=\\([ 	]*\\).*$%prefix\\1=\\2$prefix%"
fi
if test -n "$exec_prefix"; then
  prsub="$prsub
s%^exec_prefix\\([ 	]*\\)=\\([ 	]*\\).*$%\
exec_prefix\\1=\\2$exec_prefix%"
fi

trap 'rm -f config.status; exit 1' 1 3 15
echo creating config.status
rm -f config.status
cat > config.status <<EOF
#!/bin/sh
# Generated automatically by configure.
# Run this file to recreate the current configuration.
# This directory was configured as follows,
# on host `(hostname || uname -n) 2>/dev/null`:
#
# $0 $*

for arg
do
  case "\$arg" in
    -recheck | --recheck | --rechec | --reche | --rech | --rec | --re | --r)
    exec /bin/sh $0 $* ;;
    *) echo "Usage: config.status --recheck" 2>&1; exit 1 ;;
  esac
done

trap 'rm -f Makefile conf.h conftest*; exit 1' 1 3 15
CC='$CC'
INSTALL='$INSTALL'
INSTALL_PROGRAM='$INSTALL_PROGRAM'
INSTALL_DATA='$INSTALL_DATA'
RANLIB='$RANLIB'
LIBS='$LIBS'
srcdir='$srcdir'
prefix='$prefix'
exec_prefix='$exec_prefix'
prsub='$prsub'
EOF
cat >> config.status <<\EOF

top_srcdir=$srcdir
for file in .. Makefile; do if [ "x$file" != "x.." ]; then
  srcdir=$top_srcdir
  # Remove last slash and all that follows it.  Not all systems have dirname.
  dir=`echo $file|sed 's%/[^/][^/]*$%%'`
  if test "$dir" != "$file"; then
    test "$top_srcdir" != . && srcdir=$top_srcdir/$dir
    test ! -d $dir && mkdir $dir
  fi
  echo creating $file
  rm -f $file
  echo "# Generated automatically from `echo $file|sed 's|.*/||'`.in by configure." > $file
  sed -e "
$prsub
s%@CC@%$CC%g
s%@INSTALL@%$INSTALL%g
s%@INSTALL_PROGRAM@%$INSTALL_PROGRAM%g
s%@INSTALL_DATA@%$INSTALL_DATA%g
s%@RANLIB@%$RANLIB%g
s%@LIBS@%$LIBS%g
s%@srcdir@%$srcdir%g
s%@DEFS@%-DHAVE_CONFIG_H%" $top_srcdir/${file}.in >> $file
fi; done

echo creating conf.h
# These sed commands are put into SEDDEFS when defining a macro.
# They are broken into pieces to make the sed script easier to manage.
# They are passed to sed as "A NAME B NAME C VALUE D", where NAME
# is the cpp macro being defined and VALUE is the value it is being given.
# Each defining turns into a single global substitution command.
#
# SEDd sets the value in "#define NAME VALUE" lines.
SEDdA='s@^\([ 	]*\)#\([ 	]*define[ 	][ 	]*\)'
SEDdB='\([ 	][ 	]*\)[^ 	]*@\1#\2'
SEDdC='\3'
SEDdD='@g'
# SEDu turns "#undef NAME" with trailing blanks into "#define NAME VALUE".
SEDuA='s@^\([ 	]*\)#\([ 	]*\)undef\([ 	][ 	]*\)'
SEDuB='\([ 	]\)@\1#\2define\3'
SEDuC=' '
SEDuD='\4@g'
# SEDe turns "#undef NAME" without trailing blanks into "#define NAME VALUE".
SEDeA='s@^\([ 	]*\)#\([ 	]*\)undef\([ 	][ 	]*\)'
SEDeB='$@\1#\2define\3'
SEDeC=' '
SEDeD='@g'
rm -f conftest.sed
cat > conftest.sed <<CONFEOF
EOF
# Turn off quoting long enough to insert the sed commands.
cat >> config.status <<EOF
$SEDDEFS
EOF
cat >> config.status <<\EOF
CONFEOF
rm -f conftest.h
# Break up the sed commands because old seds have small limits.
cp $top_srcdir/conf.h.in conftest.h1
while :
do
  lines=`grep -c . conftest.sed`
  if test -z "$lines" || test "$lines" -eq 0; then break; fi
  rm -f conftest.s1 conftest.s2 conftest.h2
  sed 40q conftest.sed > conftest.s1 # Like head -40.
  sed 1,40d conftest.sed > conftest.s2 # Like tail +41.
  sed -f conftest.s1 < conftest.h1 > conftest.h2
  rm -f conftest.s1 conftest.h1 conftest.sed
  mv conftest.h2 conftest.h1
  mv conftest.s2 conftest.sed
done
rm -f conftest.sed conftest.h
echo "/* conf.h.  Generated automatically by configure.  */" > conftest.h
cat conftest.h1 >> conftest.h
rm -f conftest.h1
if cmp -s conf.h conftest.h 2>/dev/null; then
  # The file exists and we would not be changing it.
  rm -f conftest.h
else
  rm -f conf.h
  mv conftest.h conf.h
fi

EOF
chmod +x config.status
test -n "$no_create" || ./config.status

echo .
echo Done!!
echo created conf.h and Makefile.
echo Please check-out Makefile and especially conf.h to make sure that
echo     sane configuration values were a result.
