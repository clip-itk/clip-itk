#include <stdio.h>
#include <unistd.h>
#include <string.h>
// ----------------------------------------------------------------------

#define SEARCH_STR "/tmp/clip"
#define REPLACE_STR "/usr/clip"
#define SIZE_BUFF 1024*1024*64

char buff[SIZE_BUFF];

// ----------------------------------------------------------------------
int main(void){
    int readBytes, loop1;
    char *pntr;
    
    while (1){
	readBytes = read(0,buff,SIZE_BUFF);
	if (readBytes == -1){
	    perror("alert: ");
	    return 1;
	}
	if (readBytes == 0){
	    return 0;
	}
	loop1=readBytes; pntr=buff;
	while (loop1--){
	    if (memcmp(pntr,SEARCH_STR,strlen(SEARCH_STR)) == 0){
		memcpy(pntr,REPLACE_STR,strlen(SEARCH_STR));
	    }
	    pntr++;
	}
	write(1,buff,readBytes);
    }
    
    return 0;
}
// ----------------------------------------------------------------------
