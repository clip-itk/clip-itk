/*
$Log: listfile.h,v $
Revision 1.2  1999/11/02 23:05:40  axl
start of logging

*/

#ifndef LISTFILE_H
#define LISTFILE_H

struct ListFile;
#define LISTFILE_FILEID 0x488a90ba

struct ListFile *create_ListFile(const char *name, int pageSize, int recSize, char *errbuf, int errbuflen );
struct ListFile *open_ListFile(const char *name, int writeFl, char *errbuf, int errbuflen );
int close_ListFile(struct ListFile *fp);

int recSize_ListFile(struct ListFile *fp);
void getError_ListFile(struct ListFile *fp, char *buf, int buflen);

int add_ListFile(struct ListFile *fp, long *head, char **vect, int num);
int del_ListFile(struct ListFile *fp, long head );
int put_ListFile(struct ListFile *fp, long *head, char **vect, int num);
int append_ListFile(struct ListFile *fp, long *head, char *rec);
int get_ListFile(struct ListFile *fp, long head, char ***vectp, int *num );
	/* realloc *vectp */
int getNext_ListFile(struct ListFile *fp, long *head, char **recp );

#endif
