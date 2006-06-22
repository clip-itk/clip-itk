/*
	$Log$
	Revision 1.1  2006/06/22 19:01:32  itk
	uri: initial
	
	Revision 1.7  2001/10/29 06:51:21  clip
	fix text fopen modes
	paul
	
	Revision 1.6  2001/10/14 11:22:05  clip
	uri: small bugs in freebsd

	Revision 1.5  2001/09/20 14:05:37  clip
	take CLIPROOT default from clipcfg.h
	paul

	Revision 1.4  2001/09/20 13:49:53  clip
	long options
	paul

*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

#include "clipcfg.h"

char *CLIPROOT = CLIP_ROOT;

int load_unicode_table(char *name  ,int *unitbl );
int print_unicode_table(int *);

int main( int argc, char ** argv)
{
	int i,j,k,ch,len=0,ret;
	FILE * f;
	char * buffer=NULL;
	int * tbl1;
	int * tbl2;
	int unich;
	char *e;

	tbl1=calloc(sizeof(int),256);
	tbl2=calloc(sizeof(int),256);

	if (argc<3)
	{
		printf("translation file from SOURCE codepage to TARGET codepage\n");
		printf("Usage: clip_trans CP_source CP_target file1 .... fileN\n");
		return 1;
	}

	e = getenv("CLIPROOT");
	if (e && *e)
		CLIPROOT = e;
	if (CLIPROOT==NULL || *CLIPROOT == 0)
	{
		printf("error:CLIPROOT is empty in environment.\n");
		return -1;
	}
	printf("\nsearch info of codepages in directory %s/charsets", CLIPROOT );
	printf("\nload info of codepage %s ... ", argv[1]);

	if ( load_unicode_table( argv[1], tbl1 ) <0 )
	{
		printf("error:%s\n",strerror(errno));
		return 1;
	}
	printf("O`k");
	//print_unicode_table(tbl1);
	printf("\nload info of codepage %s ... ", argv[2]);

	if ( load_unicode_table( argv[2], tbl2 ) <0 )
	{
		printf("error:%s\n",strerror(errno));
		return 1;
	}
	printf("O`k");
	//print_unicode_table(tbl2);
	printf("\ntranslate %d files from %s to %s\n", argc-3, argv[1], argv[2]);
	for (i=4; i<=argc; i++)
	{
		printf("\n%s...",argv[i-1]);
		f=fopen(argv[i-1],"r+t");
		if (f==NULL)
		{
			printf("error open for reading:%s\n",strerror(errno));
			continue;
		}
		if (buffer!=NULL)
			free(buffer);
		if ( fseek(f,0,SEEK_END) < 0 || (len=ftell(f)) < 0 || fseek(f,0,SEEK_SET) <0 )
		{
			printf("error length:%d:%s\n",len,strerror(errno));
			fclose(f);
			continue;
		}
		buffer=malloc(len);
		if ( buffer==NULL )
		{
			printf("error allocated memory:%d:%s\n",len,strerror(errno));
			fclose(f);
			continue;
		}
		if ( (ret=fread(buffer,1,len,f)) != len )
		{
			printf("error read:%d:%d:%s\n",ret,len,strerror(errno));
			fclose(f);
			continue;
		}
		printf("read %d bytes ...",len);
		for (j=0; j<len; j++)
		{
			ch=buffer[j];
			if (ch < 0 ) ch+=256;
			if ( ch<32 )
				continue;
			unich=tbl1[ ch ];
			for (k=0; k<256; k++)
			{
				if ( unich == tbl2[k] )
				{
					buffer[j] = k;
					break;
				}
			}
		}
		/* writing */
		fclose(f);
		f=fopen(argv[i-1],"w+b");
		if (f==NULL)
		{
			printf("error open for writing:%s\n",strerror(errno));
			continue;
		}
		if ( (ret=fwrite(buffer,1,len,f)) != len )
		{
			printf("error write:%d:%d:%s\n",ret,len,strerror(errno));
			fclose(f);
			continue;
		}
		printf("write %d bytes ...",len);
		printf("O`k");
		fclose(f);
	}
	printf("\nO`k\n");
	return 0;
}


static int freadstr( FILE * f, char * buf, int maxlen)
{
	int ret=0;
	int ch;
	while ( !feof(f) && ret<maxlen )
	{
		ch=fgetc(f);
		if ( ch=='\n' )
			break;
		buf[ret]=ch;
		ret++;
	}
	if ( ret>0 && buf[ret-1]=='\r' )
		ret--;
	if ( ret>=0 )
		buf[ret]=0;
	return ret;
}

#define PATH_MAX 4096

int load_unicode_table(char *name  ,int *tbl )
{
	char buf[ PATH_MAX ];
	char sbuf [4096];
	FILE * f;
	int len;
	unsigned int ch, uch;

	snprintf(buf,PATH_MAX,"%s/charsets/%s.uni",CLIPROOT,name);

	f=fopen(buf,"rt");

	if ( f == NULL )     	return -1;

	while ( !feof(f) )
	{
		len=freadstr(f,sbuf,4096);
		if (len==0)
			continue;
		/* first spaces */
		for (len=0; sbuf[len]!=0 && (sbuf[len]==' ' || sbuf[len]=='\t'); len++);
		/* comments */
		if ( sbuf[len]=='#' || sbuf[len] < 32 )
			continue ;
		ch=strtol(sbuf+len, NULL, 16);
		for (; sbuf[len]!=0 && sbuf[len]!='+'; len++);
		uch=strtol(sbuf+len, NULL, 16);
		if (ch>256)
		{
			printf("char code >255\n");
			continue ;
		}
		tbl[ch]=uch;
	}

	fclose(f);
	return 0;
}

int print_unicode_table(int * tbl)
{
	int i,j;
	for (i=0; i<32; i++)
	{
		for (j=0; j<8; j++)
		{
			if ( j>2 )
				printf(" %c=%4d",(char)j*32+i,tbl[j*32+i]);
			else
				printf("   =%4d",tbl[j*32+i]);

		}
		printf("\n");
	}
	printf("\n");
	return 0;
}
