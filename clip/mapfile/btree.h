/*
$Log: btree.h,v $
Revision 1.2  1999/11/02 23:05:38  axl
start of logging

*/

#ifndef BTREE_H
#define BTREE_H

struct BtreeFile;
#define BTREE_FILEID 0x4479695a
#define BTREE_BOF	-2
#define BTREE_EOF	-3
#define BTREE_ERR	-1

struct BtreeFile *create_BtreeFile(const char *name, int invOrder, int pageSize, char *errbuf, int errbuflen );
struct BtreeFile *open_BtreeFile(const char *name, int invOrder, int writeFl, char *errbuf, int errbuflen );
int close_BtreeFile(struct BtreeFile *fp);

int pageSize_BtreeFile(struct BtreeFile *fp);
int numTrees_BtreeFile(struct BtreeFile *fp, int *nump);
void getError_BtreeFile(struct BtreeFile *fp, char *buf, int buflen);

int addTree_BtreeFile(struct BtreeFile *fp, int unique, int *btno);
int delTree_BtreeFile(struct BtreeFile *fp, int btno);

int addKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int keylen, long value, int *ok);
int delKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int keylen, long value, int *ok);

int seekKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int *keylen, int keysize, long *valuep, int *found);
int firstKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int *keylen, int keysize, long *valuep);
int lastKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int *keylen, int keysize, long *valuep);
int nextKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int *keylen, int keysize, long *valuep, int *found);
int prevKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int *keylen, int keysize, long *valuep, int *found);

#endif
