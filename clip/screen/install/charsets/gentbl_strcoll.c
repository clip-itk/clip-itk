/* gentbl_strcoll.c 
 * 2003 György Szombathelyi <gyurco@freemail.hu>
 *
 * This program and source code is in the public domain, you can do anything
 * with it.
 */
 
#include <locale.h>
#include <stdio.h>

int main(int argc,char *argv[]) {

    unsigned char buf[256],buf2[256];
    char cmp1[2],cmp2[2];
    int i,j;
    int flipped = 0;
    char *lc;
    
    cmp1[1]=cmp2[1]=0;
    
    lc = setlocale(LC_ALL,"");
    if (lc == NULL) {
	fprintf(stderr,"Cannot set locale! Check LC_XXX variables!\n");
	return -1;
    }
    if (argc>1) {
	if (!strcmp(argv[1],"--help") || !strcmp(argv[1],"-h")) {
	    printf("%s: .tbl file generator using libc locale\n",argv[0]);
	    printf("Usage: %s > xxx.tbl\n\n",argv[0]);
	    printf("Generates .tbl file for clip (www.itk.ru) using the locale settings\n");
	    printf("of the system (LC_XXX variables). The result can be used for determining the\n");
	    printf("string collation and upper-lower case conversion (cmptbl,uptbl,lowtbl,isalpha).\n");
	    printf("Pgtable (pseudo-graphic chars) are not implemented, because in clip you should\n");
	    printf("always use PGCH_XXX constants for pseudo-graphic characters (see pgch.ch).\n");
	    printf("Also, ISO 8859 tables have very limited (or not existent) support for\n");
	    printf("such charaters.\n\n");
	    printf("Watch out for the character set used by the locale!\n");
	    printf("For example the hu_HU locale uses the ISO 8859-2 charset and\n");
	    printf("not the once-so-popular IBM CP852!\n\n");
	    return 0;
	} else {
	    printf("Invalid parameters!\n");
	    return -1;
	}
    }
    for (i=0;i<256;i++) {
	buf[i]=i;
    }
    for (i = 255; --i>=0; ) { 
	for (j = 0; j<i; j++) { 
	    cmp1[0]=buf[j];cmp2[0]=buf[j+1];
	    if ( strcoll(&cmp1,&cmp2)>0 ) {
		char T = buf[j]; buf[j] = buf[j+1]; buf[j+1] = T; flipped = 1; 
	    } 
	}
	if (!flipped) { break; } 
    }    

    for (i = 0; i<256; i++ ) {
	j=0;
	while (j<256 && buf[j]!=i) j++;
	if (j>255) j=0;
	buf2[i]=j;
    }

    printf("# Generated using %s libc locale\n",lc);
    printf("# cmptbl\n");
    for (i=0;i<256;i++) {
	printf("%d\n",buf2[i]);    
    }

    for (i=0;i<256;i++) {
	buf[i]=i;
    }

    printf("# uptbl\n");
    for (i=0;i<256;i++) {
	printf("%d\n",toupper(buf[i]));    
    }
    
    printf("# lowtbl\n");
    for (i=0;i<256;i++) {
	printf("%d\n",tolower(buf[i]));    
    }

    printf("# isalpha\n");
    for (i=0;i<256;i++) {
	printf("%d\n",isalpha(buf[i]) ? 1:0);    
    }

    printf("# pgtbl\n");
    for (i=0;i<256;i++) {
	printf("0\n");    
    }
    return 0;
}
