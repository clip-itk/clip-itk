/*
$Log: mapfile.h,v $
Revision 1.3  1999/11/09 22:50:11  axl
Created DBFMEM - dbf in memory (fix for zero file handler).

Revision 1.2  1999/11/02 23:05:42  axl
start of logging

*/


#ifndef MAPFILE_H
#define MAPFILE_H

struct MapFile;

int is_anon(struct MapFile *fp);
struct MapFile *create_MapFile(const char *name, int headerSize, int recSize, char *errbuf, int errbuflen);
struct MapFile *open_MapFile(const char *name, int headerSize, int writeFl, char *errbuf, int errbuflen);
int setRecSize_MapFile(struct MapFile *fp, int recSize);
int setHeaderSize_MapFile(struct MapFile *fp, int headerSize);
int close_MapFile(struct MapFile *fp);
int sync_MapFile(struct MapFile *fp);
int remap_MapFile(struct MapFile *fp);	/* fp must be locked */

void getError_MapFile(struct MapFile *fp, char *buf, int buflen);
long headerSize_MapFile(struct MapFile *fp);
int recSize_MapFile(struct MapFile *fp);
long recCount_MapFile(struct MapFile *fp);
long fileSize_MapFile(struct MapFile *fp);	/* real file size */
long mapLen_MapFile(struct MapFile *fp);	/* mapped file size */
int fd_MapFile(struct MapFile *fp);

void *getHeader_MapFile(struct MapFile *fp);
void *getData_MapFile(struct MapFile *fp);

int lockHeader_MapFile(struct MapFile *fp, int writeFl, void **buf);
int unlockHeader_MapFile(struct MapFile *fp);

char *getMap_MapFile(struct MapFile *fp);
char *getRec_MapFile(struct MapFile *fp, long recno);
int lockRec_MapFile(struct MapFile *fp, int writeFl, long recno, char **bufp);
int unlockRec_MapFile(struct MapFile *fp, long recno);

int lock_MapFile(struct MapFile *fp, int writeFl);
int unlock_MapFIle(struct MapFile *fp);

/* fp must be explicitly locked for next functions */
int incr_MapFile(struct MapFile *fp, long *recno, long num, long addnum);

/* phisically decrease file size */
int decr_MapFile(struct MapFile *fp, long reccount);

#endif
