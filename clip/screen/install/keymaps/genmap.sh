#!/bin/sh

[ $# != 1 ] && { echo usage: $0 keymap_name; exit 1; }

pwd=`pwd`
tmp=/tmp/$$
src=$1

mkdir -p $tmp

cleanup()
{
	rm -rf $tmp
        [ -n "$1" ] && echo $1 error
        exit $2
}

trap cleanup 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15

cd $tmp
loadkeys -m $1 > kmap.c || cleanup loadkeys 2

cat >gen.c << EOF

#include "kmap.c"

int
main(int argc, char**argv)
{
	int i;

	printf("#max keymap_count\n%d\n", MAX_NR_KEYMAPS);
	printf("#keymap_count\n%d\n", keymap_count);

	for(i=0; i<MAX_NR_KEYMAPS; i++)
        {
        	int j;
		unsigned short *keymap = key_maps[i];

        	printf("#keymap %d:\n%d\n", i, keymap?NR_KEYS:0);
                if (keymap)
                {
                	for(j=0; j<NR_KEYS; j++)
                		printf("%u\n", keymap[j]);
        	}
        }

	printf("#funcbuf\n%d\n", funcbufsize);
        for(i=0; i<funcbufsize; i++)
        	printf("%d\n", func_buf[i]);

	printf("#func_table\n%d\n", MAX_NR_FUNC);
        for(i=0; i<MAX_NR_FUNC; i++)
        	printf( "%d\n", func_table[i]?(func_table[i]-func_buf):-1 );

	printf("#accent_table full size\n%d\n", MAX_DIACR);
	printf("#accent_table_size\n%d\n", accent_table_size);
	for(i=0; i<accent_table_size; i++)
        {
        	struct kbdiacr *kp = &accent_table[i];
                printf("%d %d %d\n", kp->diacr, kp->base, kp->result);
        }


        return 0;
}


EOF


cc -o gen gen.c -D_LOOSE_KERNEL_NAMES  || cleanup cc 3

./gen

cleanup
