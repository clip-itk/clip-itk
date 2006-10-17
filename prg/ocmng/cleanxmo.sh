files=`find . \( -path '*.xmo' -a -type f \)`
echo 'rm -f */*.xmo' $files
rm -f $files

files=`find . \( -path '*.bak' -a -type f \)`
echo 'rm -f */*.bak' $files
rm -f $files

files=`find . \( -path '*.log' -a -type f \)`
echo 'rm -f */*.log' $files
rm -f $files

