/*
$Log: mtest.c,v $
Revision 1.2  1999/11/02 23:05:43  axl
start of logging

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mapfile.h"
#include "btree.h"
#include "listfile.h"

static
int test_MapFile(int num)
{
	char buf[128];
	char *name ="t.db";
	struct MapFile *fp = create_MapFile(name, 0, 1000, buf, sizeof(buf));
	char *rp;
	long recno;
	int i;

	if (!fp)
	{
		fprintf(stderr, "cannot create file '%s': %s\n", name, buf);
		return 0;
	}

	for(i=0;i<num;++i)
	{
		void *hp;
		if (lockHeader_MapFile(fp, 1, &hp))
			return 0;
		if (incr_MapFile(fp, &recno, 1, 0))
			return 0;
		if (lockRec_MapFile(fp, 1, recno, &rp))
			return 0;
		sprintf(rp, "i=%d", i);
		/*printf("i=%d\n",i);*/
		unlockRec_MapFile(fp,recno);
		unlockHeader_MapFile(fp);
	}


	if (close_MapFile(fp))
		return 0;

	return 1;
}

static
int test_BtreeFile(int num)
{
	char buf[256];
	long  l;
	int i, found;
	int btno;
	char *name = "t.btree";
	struct BtreeFile *fp = create_BtreeFile(name, 0, 0,buf, sizeof(buf));
	char key[256];
	long val;
	int keylen, res, r;

	if (!fp)
	{
		fprintf(stderr, "cannot create file '%s': %s\n", name, buf);
		return 0;
	}

	if (addTree_BtreeFile(fp, 0, &btno))
		return 0;

	for(i=0;i<num;++i)
	{
		l=random();
		l=i;
		sprintf(buf, "i=%010ld", l);
		/*printf("%s\n",buf);*/
		r = addKey_BtreeFile(fp, btno, buf, strlen(buf), l, &res);
		if (r || !res)
			return 0;
	}

	l=102;
	sprintf(buf, "i=%010ld", l);
	r = delKey_BtreeFile(fp, btno, buf, strlen(buf), l, &res);

/*
	keylen =sizeof(key);
	firstKey_BtreeFile(fp, 0, key, &keylen, sizeof(key), &val);

	i =0;
	do {
		printf("key='%s' val=%ld (i=%d)\n", key, val, i++);
		nextKey_BtreeFile(fp, btno, key, &keylen, sizeof(key), &val, &found);
	} while (found);
*/
	keylen =sizeof(key);
	lastKey_BtreeFile(fp, 0, key, &keylen, sizeof(key), &val);

	i =0;
	do {
		printf("key='%s' val=%ld (i=%d)\n", key, val, i++);
		prevKey_BtreeFile(fp, btno, key, &keylen, sizeof(key), &val, &found);
	} while (found);

	if (close_BtreeFile(fp))
		return 0;

	return 1;
}

#define LREC_SIZE 64
#define LREC_NUM 16

static
int test_ListFile(int num)
{
	char buf[128];
	char *name ="t.dbl";
	struct ListFile *fp = create_ListFile(name, 0, LREC_SIZE, buf, sizeof(buf));
	long recno;
	int i;

	if (!fp)
	{
		fprintf(stderr, "cannot create file '%s': %s\n", name, buf);
		return 0;
	}

	for(i=0; i<num; ++i)
	{
		char arr[LREC_NUM][LREC_SIZE];
		char *vect[LREC_NUM];
		int j;

		for(j=0;j<LREC_NUM;++j)
		{
			vect[j] = arr[j];
			memset(vect[j],' ',LREC_SIZE);
			snprintf(vect[j], LREC_SIZE, "%d:%d", i, j);
		}

		if (add_ListFile(fp, &recno, vect, LREC_NUM))
			return 0;
	}

	if (close_ListFile(fp))
		return 0;

	return 1;
}


int
main(int argc, char *argv[])
{
	int res, num=1000;
	printf("test MapFile:\n");
	res = test_MapFile(10);
	printf("result = %d\n", res);
	printf("test BtreeFile:\n");
	if (argc>1)
		num=atoi(argv[1]);
	res =test_BtreeFile(num);
	printf("result = %d\n", res);
	res =test_ListFile(num);
	printf("result = %d\n", res);
	return 0;
}
