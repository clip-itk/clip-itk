/*
$Log: btree.c,v $
Revision 1.2  1999/11/02 23:05:37  axl
start of logging

*/

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include "mapfile.h"
#include "btree.h"

/* maximum num of btree's in one file */
/* 126 ==> header size == 1024 */
#define MAX_TREES 126
#define ERRBUFSIZE 256
#define PAGE_SIZE  4096

#define NEW(type) ((type*)calloc(sizeof(type),1))
#define REALLOC(type,ptr,len) ((ptr)=(type*)realloc((ptr),sizeof(type)*(len)))
#define VAR(type,var,ini) type *var=(type*)(ini)
#define NEWVAR(type,var) type *var=(type*)calloc(sizeof(type),1)
#define MZERO(var) memset((var),0,sizeof(*(var)));

typedef struct
{
	long root;
	char unique;
	char f1;
	char f2;
	char f3;
} Root;

typedef struct
{
	long fileId;
	long pageCount;
	long freePage;
	unsigned short pageSize;
	short ntree;
	Root roots[MAX_TREES];
}
Header;

typedef struct BtreeFile
{
	struct MapFile *mp;
	unsigned short pageSize;
	long pageCount;
	int invOrder;
	int writeFl;
	char buf[ERRBUFSIZE];
	char *pbuf;
}
BtreeFile;

typedef struct
{
	unsigned short len;
	unsigned short offs;
	long value;
	long chield;
}
Bucket;

typedef struct
{
	unsigned short len;
	unsigned short offs;
	long value;
}
LeapBucket;

typedef struct
{
	short numBuck;
	short endData;
	short flags;
	short align;
	long lChield;
}
PageHeader;

#define LEAP_FLAG 0x1

typedef struct
{
	long next;
}
FreePageHeader;

typedef struct
{
	char *key;
	int keylen;
	int keysize;
	int found;
	int freeMem;
	long value;
	long chield;
} Tuple;

static int next_tree(struct BtreeFile *fp, int invOrder, long root, int isRoot, Tuple *tp);

static void
mem_move (void *dest, void *src, int len)
{
	memmove(dest,src,len);
}

static char *
mem_dup(char *mem, int len)
{
	char *ret = (char*)malloc(len);
	memcpy(ret, mem, len);
	return ret;
}

static Header *
getHeader(struct BtreeFile *fp)
{
	return (Header* ) getHeader_MapFile(fp->mp);
}

static int
lockHeader(struct BtreeFile *fp, Header ** hpp, int writeFl)
{
	int ret = lockHeader_MapFile(fp->mp, writeFl, (void **) hpp);

	if (ret)
		getError_MapFile(fp->mp, fp->buf, ERRBUFSIZE);
	else
	{
		Header *hp = getHeader(fp);
		if ( hp->pageCount!= fp->pageCount)
		{
			remap_MapFile(fp->mp);
			hp = getHeader(fp);
			fp->pageCount = hp->pageCount;
		}
		*hpp = hp;
	}

	return ret;
}

static int
unlockHeader(struct BtreeFile *fp)
{
	int ret = unlockHeader_MapFile(fp->mp);

	if (ret)
		getError_MapFile(fp->mp, fp->buf, ERRBUFSIZE);
	return ret;
}

struct BtreeFile *
create_BtreeFile(const char *name, int invOrder, int pageSize, char *errbuf, int errbuflen)
{
	struct BtreeFile *fp;
	Header *hp;
	struct MapFile *mp;
	int ps = getpagesize();

	/* align pageSize */
	if (pageSize<ps)
		pageSize = ps;
	else
		pageSize = (pageSize/ps + (pageSize%ps?1:0)) * ps;

	mp = create_MapFile(name, sizeof(Header), pageSize, errbuf, errbuflen);
	if (!mp)
		return 0;
	fp = NEW(struct BtreeFile);
	fp->mp = mp;
	fp->pageSize = pageSize;
	fp->invOrder = invOrder;
	fp->writeFl = 1;

	if (lockHeader(fp, &hp, 1))
	{
		snprintf(errbuf, errbuflen, "%s", fp->buf);
		close_MapFile(fp->mp);
		free(fp);
		return 0;
	}

	hp->fileId = BTREE_FILEID;
	hp->freePage = -1;
	hp->pageCount = 0;
	hp->pageSize = pageSize;
	hp->ntree = 0;

	fp->pageCount = 0;
	fp->pbuf = 0;

	unlockHeader(fp);

	return fp;
}

struct BtreeFile *
open_BtreeFile(const char *name, int invOrder, int writeFl, char *errbuf, int errbuflen)
{
	NEWVAR(struct BtreeFile, fp);
	Header *hp;

	fp->mp = open_MapFile(name, sizeof(Header), writeFl, errbuf, errbuflen);
	if (!fp->mp)
	{
		free(fp);
		return 0;
	}

	if (lockHeader(fp, &hp, 1))
	{
		snprintf(errbuf, errbuflen, "%s", fp->buf);
		close_MapFile(fp->mp);
		free(fp);
		return 0;
	}

	fp->invOrder = invOrder;
	fp->writeFl = writeFl;
	fp->pageSize = hp->pageSize;
	fp->pageCount = hp->pageCount;
	setRecSize_MapFile(fp->mp, fp->pageSize);
	fp->pbuf = 0;

	unlockHeader(fp);

	return fp;
}

int
close_BtreeFile(struct BtreeFile *fp)
{
	int ret = close_MapFile(fp->mp);

	if (fp->pbuf)
		free(fp->pbuf);
	free(fp);

	return ret;
}

int
pageSize_BtreeFile(struct BtreeFile *fp)
{
	return fp->pageSize;
}


int
numTrees_BtreeFile(struct BtreeFile *fp, int *nump)
{
	Header *hp;

	if (lockHeader(fp, &hp, 0))
		return -1;

	*nump = hp->ntree;

	if (unlockHeader(fp))
		return -1;
	return 0;
}

void
getError_BtreeFile(struct BtreeFile *fp, char *buf, int buflen)
{
	snprintf(buf, buflen, "%s", fp->buf);
}


static long
get_free_page(struct BtreeFile *fp)
{
	long recno;
	Header *hp = getHeader(fp);

	if (hp->freePage == -1)
	{
		long i;
		long delta = fp->pageCount/4;

		if (delta<1)
			delta = 1;
		incr_MapFile(fp->mp, &recno, delta, 0);

		hp = getHeader(fp);

		if (delta>1)
		{
			hp->freePage = recno+1;
			for(i=1;i<delta;++i)
			{
				FreePageHeader *fhp = (FreePageHeader *) getRec_MapFile(fp->mp, recno+i);
				if (i<delta-1)
					fhp->next = recno+i+1;
				else
					fhp->next = -1;
			}
		}
	}
	else
	{
		recno = hp->freePage;
		hp->freePage = ((FreePageHeader *) getRec_MapFile(fp->mp, recno))->next;
	}
	return recno;
}

static int
put_free_page(struct BtreeFile *fp, long recno)
{
	FreePageHeader *fhp;
	Header *hp = getHeader(fp);

	if (hp->freePage == -1)
	{
		fhp = (FreePageHeader *) getRec_MapFile(fp->mp, recno);
		fhp->next = -1;
		hp->freePage = recno;
	}
	else
	{
		fhp = (FreePageHeader *) getRec_MapFile(fp->mp, recno);
		fhp->next = hp->freePage;
		hp->freePage = recno;
	}
	return 0;
}

int
addTree_BtreeFile(struct BtreeFile *fp, int unique, int *btno)
{
	Header *hp;
	PageHeader *pp;
	long root;
	int i;

	if (lockHeader(fp, &hp, 1))
		return -1;

	if (hp->ntree == MAX_TREES)
	{
		sprintf(fp->buf, "too many trees (%d)", hp->ntree);
		unlockHeader(fp);
		return -1;
	}

	root = get_free_page(fp);
	if (root == -1)
	{
		unlockHeader(fp);
		return -1;
	}

	hp=getHeader(fp);
	for (i = 0; i < hp->ntree; ++i)
		if (hp->roots[i].root == -1)
			break;
	*btno = i;
	hp->roots[i].root = root;
	hp->roots[i].unique = unique;
	if (i == hp->ntree)
		hp->ntree++;

	pp = (PageHeader *) getRec_MapFile(fp->mp, root);
	pp->numBuck = 0;
	pp->endData = sizeof(PageHeader);
	pp->flags = LEAP_FLAG;
	pp->lChield = -1;

	sync_MapFile(fp->mp);

	unlockHeader(fp);
	return 0;
}

static Bucket *
get_bucket(PageHeader *pp, int pageSize, int no)
{
	Bucket *bp;

	if (no<0 || no>=pp->numBuck)
		return 0;

	bp = (Bucket *) (((char *) pp) + pageSize);
	return bp - (no + 1);
}

static Bucket *
get_lbucket(PageHeader *pp, int pageSize, int no)
{
	LeapBucket *bp;

	if (no<0 || no>=pp->numBuck)
		return 0;

	bp = (LeapBucket *) (((char *) pp) + pageSize);
	return (Bucket *) (bp - (no + 1));
}

static long
get_chield(PageHeader *pp, int ps, int no)
{
	if (no>=pp->numBuck)
		no = pp->numBuck-1;
	if (no<0)
		return pp->lChield;
	if (pp->flags & LEAP_FLAG)
		return -1;
	else
		return get_bucket(pp,ps,no)->chield;
}

static Bucket *
get_buck(PageHeader *pp, int ps, int no)
{
	return (pp->flags&LEAP_FLAG?get_lbucket(pp,ps,no):get_bucket(pp,ps,no));
}

#define GET_DATA(pp,bp) (((char*)(pp))+(bp)->offs)

static void
del_tree(struct BtreeFile *fp, Header * hp, long root)
{
	PageHeader *pp;

	if (root == -1)
		return;

	pp = (PageHeader *) getRec_MapFile(fp->mp, root);

	if (!(pp->flags & LEAP_FLAG))
	{
		int i, ps = fp->pageSize;

		for (i = 0; i < pp->numBuck; ++i)
		{
			Bucket *bp = get_bucket(pp, ps, i);

			del_tree(fp, hp, bp->chield);
		}
	}

	put_free_page(fp, root);
}

int
delTree_BtreeFile(struct BtreeFile *fp, int btno)
{
	Header *hp;
	long root;

	if (lockHeader(fp, &hp, 1))
		return -1;

	if (btno < 0 || btno >= hp->ntree || hp->roots[btno].root == -1)
	{
		unlockHeader(fp);
		sprintf(fp->buf, "invalid btno (%d)", btno);
		return -1;
	}

	root = hp->roots[btno].root;

	del_tree(fp, hp, root);

	hp = getHeader(fp);
	hp->roots[btno].root = -1;
	if (btno == hp->ntree - 1)
		hp->ntree--;

	unlockHeader(fp);
	return 0;
}

typedef Bucket *GetBuckFunc(PageHeader *pp, int pageSze, int no);

int
compare_key(int unique, char *s1, int l1, long val1, char *s2, int l2, long val2)
{
	int l = (l1 < l2 ? l1 : l2);
	int r = memcmp(s1, s2, l);

	if (r)
		return r;
	else
	{
		if (unique || val1 == -1 || val2 == -1)
			return 0;
		if (val1 < val2)
			return -1;
		else if (val1 > val2)
			return 1;
		else
			return 0;
	}
}

static int
search_bucket(PageHeader * pp, int pageSize, int invOrder, Tuple *tp, int *no, int unique )
{
	int num = pp->numBuck;
	int isLeap = pp->flags & LEAP_FLAG;
	GetBuckFunc *gb = (isLeap ? get_lbucket : get_bucket);
	Bucket *bp;
	int l, h, i=-1, c=0;

	l = 0;
	h = num - 1;
	while (l <= h)
	{
		i = (l + h) >> 1;
		bp = gb(pp, pageSize, i);
		c = compare_key(unique, (((char *) pp) + bp->offs), bp->len, bp->value, tp->key, tp->keylen, tp->value );
		if (c < 0)
			l = i + 1;
		else if (c > 0)
			h = i - 1;
		else
		{
			*no = i;
			return 1;
		}
	}

	/*if (invOrder)
	{
		if (c<0)
			i++;
	}
	else*/
	{
		if (c>0)
			i--;

	}

	*no =i;
	return 0;
}

static void
set_key(PageHeader * pp, Bucket * bp, char *key, int keylen)
{
	int n = keylen;
	if (!bp)
		*key=0;

	if (bp->len < n)
		n = bp->len;
	memcpy(key, (((char *) pp) + bp->offs), n);
	key[n] = 0;
}



static void
seek_tree(struct BtreeFile *fp, long root, int invOrder, Tuple *tp)
{
	PageHeader *pp = (PageHeader *) getRec_MapFile(fp->mp, root);
	int isLeap = pp->flags & LEAP_FLAG, r, no;
	long chield;
	int ps = fp->pageSize;
	Bucket *bp;

	r = search_bucket(pp, fp->pageSize, invOrder, tp, &no, 0);
	if (r)
	{
		bp = get_buck(pp,ps,no);
		tp->found = 1;
		tp->value = bp->value;
		return;
	}

	if (isLeap)
	{
		tp->found = 0;
		if (no>=0 && no<pp->numBuck)
		{
			bp = get_lbucket(pp,ps,no);
			tp->value = bp->value;
			set_key(pp, bp, tp->key, tp->keysize);
		}
		return;
	}

	if (no<0)
		chield = pp->lChield;
	else
		chield = get_bucket(pp,ps,no)->chield;
	seek_tree(fp, chield, invOrder, tp);
}

int
seekKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int *keylen, int keysize, long *valuep, int *found)
{
	Header *hp;
	long root;
	Tuple tup;

	if (lockHeader(fp, &hp, 0))
		return -1;

	if (btno < 0 || btno >= hp->ntree || hp->roots[btno].root == -1)
	{
		unlockHeader(fp);
		sprintf(fp->buf, "invalid btno (%d)", btno);
		return -1;
	}

	root = hp->roots[btno].root;
	tup.key = key;
	tup.keylen = *keylen;
	tup.value = *valuep;
	tup.keysize = keysize;
	seek_tree(fp, root, fp->invOrder, &tup);
	*keylen = tup.keylen;
	*valuep = tup.value;
	*found = tup.found;

	unlockHeader(fp);
	return 0;
}

static void last_key(struct BtreeFile *fp, Header * hp, long root, char *key, int *keylen, int keysize, long *valuep);

static void
first_key(struct BtreeFile *fp, Header * hp, long root, char *key, int *keylen, int keysize, long *valuep)
{
	PageHeader *pp = (PageHeader *) getRec_MapFile(fp->mp, root);
	int isLeap = pp->flags & LEAP_FLAG;
	int num = pp->numBuck;
	Bucket *bp;

	if (isLeap)
	{
		if (num)
		{
			bp = get_lbucket(pp, fp->pageSize, 0);
			set_key(pp, bp, key, keysize);
			*keylen = bp->len;
			*valuep = bp->value;
		}
		else
		{
			*key = 0;
			*keylen = 0;
			*valuep = -3;
		}
	}
	else
		first_key(fp, hp, pp->lChield, key, keylen, keysize, valuep);
}

int
firstKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int *keylen, int keysize, long *valuep)
{
	Header *hp;
	long root;

	if (lockHeader(fp, &hp, 0))
		return -1;

	if (btno < 0 || btno >= hp->ntree || hp->roots[btno].root == -1)
	{
		unlockHeader(fp);
		sprintf(fp->buf, "invalid btno (%d)", btno);
		return -1;
	}

	root = hp->roots[btno].root;
	if (fp->invOrder)
		last_key(fp, hp, root, key, keylen, keysize, valuep);
	else
		first_key(fp, hp, root, key, keylen, keysize, valuep);

	if ( *valuep==-1 )
	{
		Tuple tup;
		MZERO(&tup);
		tup.key = key;
		tup.keylen = *keylen;
		tup.keysize = keysize;
		tup.value = *valuep;
		tup.found = 0;
		do {
			next_tree(fp, fp->invOrder, root, 1, &tup);
		} while ( tup.found && tup.value==-1 );
		*valuep = tup.value;
		*keylen = tup.keylen;
	}


	unlockHeader(fp);
	return 0;
}

static void
last_key(struct BtreeFile *fp, Header * hp, long root, char *key, int *keylen, int keysize, long *valuep)
{
	PageHeader *pp = (PageHeader *) getRec_MapFile(fp->mp, root);
	int isLeap = pp->flags & LEAP_FLAG;
	int num = pp->numBuck;
	Bucket *bp;

	if (isLeap)
	{
		if (num)
		{
			bp = get_lbucket(pp, fp->pageSize, num - 1);
			set_key(pp, bp, key, keysize);
			*keylen = bp->len;
			*valuep = bp->value;
		}
		else
		{
			memset(key, 0xff, keysize);
			*keylen=keysize;
			*valuep = -2;
		}
	}
	else
	{
		bp = get_bucket(pp, fp->pageSize, num - 1);
		last_key(fp, hp, bp->chield, key, keylen, keysize, valuep);
	}
}

int
lastKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int *keylen, int keysize, long *valuep)
{
	Header *hp;
	long root;

	if (lockHeader(fp, &hp, 0))
		return -1;

	if (btno < 0 || btno >= hp->ntree || hp->roots[btno].root == -1)
	{
		unlockHeader(fp);
		sprintf(fp->buf, "invalid btno (%d)", btno);
		return -1;
	}

	root = hp->roots[btno].root;
	if (fp->invOrder)
		first_key(fp, hp, root, key, keylen, keysize, valuep);
	else
		last_key(fp, hp, root, key, keylen, keysize, valuep);
	if (*valuep==-1)
	{
		Tuple tup;
		MZERO(&tup);
		tup.key = key;
		tup.keylen = *keylen;
		tup.keysize = keysize;
		tup.value = *valuep;
		tup.found = 0;
		do {
			next_tree(fp, !fp->invOrder, root, 1, &tup);
		} while ( tup.found && tup.value==-1 );
		*valuep = tup.value;
		*keylen = tup.keylen;
	}

	unlockHeader(fp);
	return 0;
}


static int
next_buck(struct BtreeFile *fp, int invOrder, PageHeader *pp, int isRoot, int buckno, Tuple *tp, int deep)
{
	int isLeap = pp->flags & LEAP_FLAG;
	int num = pp->numBuck;
	int ps = fp->pageSize;
	Bucket *bp;

	if (isLeap)
	{
		if (!invOrder)
		{
			if ( buckno < num - 1)
				bp = get_lbucket(pp, ps, buckno + 1);
			else if (isRoot)
			{
				tp->value = -2;
				tp->found = 0;
				return 0;
			}
			else
				return 1;
		}
		else
		{
			if (buckno > 0)
				bp = get_lbucket(pp, ps, buckno - 1);
			else if (isRoot)
			{
				tp->value = -3;
				tp->found = 0;
				return 0;
			}
			else
				return 1;
		}
		tp->found = 1;
		set_key(pp, bp, tp->key, tp->keysize);
		tp->keylen = bp->len;
		tp->value = bp->value;
		return 0;
	}
	else if (deep)
	{
		long chield;
		if (invOrder)
			buckno--;
		if (buckno<0)
			chield = pp->lChield;
		else if (buckno<num)
		{
			bp = get_bucket(pp, ps, buckno);
			chield = bp->chield;
		}
		else if (isRoot)
		{
			tp->value = (invOrder?-3:-2);
			tp->found = 0;
			return 0;
		}
		else
			return 1;

		if (invOrder)
			last_key(fp, getHeader(fp), chield, tp->key, &tp->keylen, tp->keysize, &tp->value);
		else
			first_key(fp, getHeader(fp), chield, tp->key, &tp->keylen, tp->keysize, &tp->value);
		tp->found = 1;
		return 0;
	}
	else
	{
		if (!invOrder)
		{
			if (buckno<num-1)
				bp = get_bucket(pp, ps, buckno + 1);
			else if (isRoot)
			{
				tp->value = -2;
				tp->found = 0;
				return 0;
			}
			else
				return 1;

			tp->found = 1;
			set_key(pp, bp, tp->key, tp->keysize);
			tp->keylen = bp->len;
			tp->value = bp->value;
			return 0;
		}
		else
		{
			if (buckno>=0)
				bp = get_bucket(pp, ps, buckno);
			else if (isRoot)
			{
				tp->value = -3;
				tp->found = 0;
				return 0;
			}
			else
				return 1;

			tp->found = 1;
			set_key(pp, bp, tp->key, tp->keysize);
			tp->keylen = bp->len;
			tp->value = bp->value;
			return 0;
		}
		return 0;
	}
}

static int
next_tree(struct BtreeFile *fp, int invOrder, long root, int isRoot, Tuple *tp)
{
	PageHeader *pp = (PageHeader *) getRec_MapFile(fp->mp, root);
	int isLeap = pp->flags & LEAP_FLAG;
	int ps = fp->pageSize;
	Bucket *bp;
	int r,buckno, buck_no;
	long chield;

	r = search_bucket(pp, ps, invOrder, tp, &buckno, 0);
	if (r)
	{
		return next_buck(fp, invOrder, pp, isRoot, buckno, tp, 1);
	}

	if (isLeap)
	{
		bp=get_lbucket(pp,ps,buckno+(invOrder?-1:1));
		if (bp)
		{
			set_key(pp, bp, tp->key, tp->keysize);
			tp->keylen = bp->len;
			tp->value = bp->value;
			tp->found = 1;
		}
		else
		{
			tp->value = (invOrder ? -3 : -2);
			tp->found = 0;
		}

		return 0;
	}

	if (invOrder)
		buck_no = buckno;
	else
		buck_no = buckno;
	if (buck_no<0)
		chield = pp->lChield;
	else
		chield = get_chield(pp,ps,buck_no);
	r = next_tree(fp, invOrder, chield, 0, tp );
	if (r==1)
	{
		return next_buck(fp, invOrder, pp, isRoot, buckno, tp, 0);
	}
	return r;
}

int
nextKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int *keylen, int keysize, long *valuep, int *found)
{
	Header *hp;
	long root;
	Tuple tup;
	int r;

	if (lockHeader(fp, &hp, 0))
		return -1;

	if (btno < 0 || btno >= hp->ntree || hp->roots[btno].root == -1)
	{
		unlockHeader(fp);
		sprintf(fp->buf, "invalid btno (%d)", btno);
		return -1;
	}

	root = hp->roots[btno].root;
	MZERO(&tup);
	tup.key = key;
	tup.keylen = *keylen;
	tup.keysize = keysize;
	tup.value = *valuep;
	tup.found = 0;
	do {
		r = next_tree(fp, fp->invOrder, root, 1, &tup);
	} while ( tup.found && tup.value==-1 );
	*valuep = tup.value;
	*keylen = tup.keylen;
	*found = tup.found;

	unlockHeader(fp);
	return 0;
}

int
prevKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int *keylen, int keysize, long *valuep, int *found)
{
	Header *hp;
	long root;
	Tuple tup;
	int r;

	if (lockHeader(fp, &hp, 0))
		return -1;

	if (btno < 0 || btno >= hp->ntree || hp->roots[btno].root == -1)
	{
		unlockHeader(fp);
		sprintf(fp->buf, "invalid btno (%d)", btno);
		return -1;
	}

	root = hp->roots[btno].root;
	MZERO(&tup);
	tup.key = key;
	tup.keylen = *keylen;
	tup.keysize = keysize;
	tup.value = *valuep;
	tup.found = 0;
	do {
		r = next_tree(fp, !fp->invOrder, root, 1, &tup);
	} while ( tup.found && tup.value==-1 );
	*valuep = tup.value;
	*keylen = tup.keylen;
	*found = tup.found;

	unlockHeader(fp);
	return 0;
}

static void
get_tuple(PageHeader *pp, int ps, int isLeap, int i, Tuple *tp)
{
	Bucket *bp;
	long ch=-1;

	if (isLeap)
		bp = get_lbucket(pp, ps, i);
	else
	{
		bp = get_bucket(pp, ps, i);
		ch = bp->chield;
	}

	tp->key=GET_DATA(pp,bp);
	tp->keylen = bp->len;
	tp->freeMem = 0;
	tp->value = bp->value;
	tp->chield = ch;
}

static void
destroy_Tuple(Tuple *tp)
{
	if (tp->freeMem)
		free(tp->key);
	memset(tp,0,sizeof(Tuple));
}

static int add_node(struct BtreeFile *fp, int btno, long recno, Tuple *tp, int unique);
static int add_root(struct BtreeFile *fp, int btno, Tuple *tp, long lchield );
static void put_node(PageHeader *pp, int pageSize, int bucketSize, int buckno, Tuple *tp);

static int
split_node(struct BtreeFile *fp, int btno, long recno, int buckno, Tuple *tp)
{
	char *basep;
	PageHeader *pp, *lp, *rp;
	int isLeap, ps, bs, num, mediane, i, j ;
	long lnode, rnode;
	Tuple tup;
	Bucket *bp;

	ps = fp->pageSize;
	lnode = recno;
	rnode = get_free_page(fp);
	rp = (PageHeader*) getRec_MapFile(fp->mp, rnode);
	basep = getRec_MapFile(fp->mp, recno);
	lp = (PageHeader*)basep;
	if (!fp->pbuf)
		fp->pbuf = (char *)malloc(ps);
	memcpy(fp->pbuf,basep,ps);
	basep=fp->pbuf;
	pp = (PageHeader *) basep;
	isLeap = pp->flags & LEAP_FLAG;
	bs = (isLeap ? sizeof(LeapBucket) : sizeof(Bucket));
	num = pp->numBuck;
	mediane = (num+1) / 2;
	tup = *tp;
	memset(lp, 0, ps);

	lp->flags = pp->flags;
	lp->endData = sizeof(PageHeader);
	lp->numBuck = 0;
	lp->lChield = pp->lChield;

	rp->flags = pp->flags;
	rp->endData = sizeof(PageHeader);
	rp->numBuck = 0;
	rp->lChield = -1;

	/* pop up media key */
	if (isLeap)
		bp = get_lbucket(pp, ps, mediane);
	else
		bp = get_bucket(pp, ps, mediane);
	if (buckno == mediane)
	{
		rp->lChield = tp->chield;
		tp->chield = rnode;
	}
	else
	{
		tp->key = mem_dup(GET_DATA(basep,bp),bp->len);
		tp->freeMem = 1;
		tp->keylen = bp->len;
		tp->value = bp->value;
		tp->chield = rnode;
		rp->lChield = bp->chield;
	}

	j=0;
	if (buckno<0)
		put_node(lp,ps,bs,j++,&tup);

	for ( i = 0; i < mediane; ++i, ++j)
	{
		Tuple tuple;
		get_tuple(pp,ps,isLeap,i,&tuple);
		put_node(lp,ps,bs,j,&tuple);

		if (i==buckno)
			put_node(lp,ps,bs,j++,&tup);
	}

	for (j=0, i = mediane + 1; i < num; ++i, ++j)
	{
		Tuple tuple;
		get_tuple(pp,ps,isLeap,i,&tuple);
		put_node(rp,ps,bs,j,&tuple);

		if (i==buckno)
			put_node(rp,ps,bs,j++,&tup);
	}

	if (buckno==num)
		put_node(rp,ps,bs,j++,&tup);

	if (tup.key!=tp->key)
		destroy_Tuple(&tup);
	return 1;
}

static int
add_root(struct BtreeFile *fp, int btno, Tuple *tp, long lchield)
{
	char *basep;
	PageHeader *pp;
	int ps, beg;
	Bucket *bp;
	long recno;
	Header *hp;

	ps = fp->pageSize;

	recno  = get_free_page(fp);
	basep = getRec_MapFile(fp->mp, recno);
	pp = (PageHeader *) basep;
	bp = ((Bucket *) (basep + ps))-1;
	beg = sizeof(PageHeader);

	bp->value = tp->value;
	bp->len = tp->keylen;
	bp->offs = beg;
	bp->chield = tp->chield;
	memcpy(basep + beg, tp->key, tp->keylen);

	pp->endData = beg + tp->keylen;
	pp->numBuck = 1;
	pp->lChield = lchield;
	pp->flags = 0;

	hp = getHeader(fp);
	hp->roots[btno].root = recno;

	return 0;
}

static void
put_node(PageHeader *pp, int ps, int bs, int buckno, Tuple *tp)
{
	char *basep = (char*)pp;
	int num = pp->numBuck;
	Bucket *bp;
	int end = ps - bs * num;
	int isLeap = pp->flags & LEAP_FLAG;
	int beg = pp->endData;

	if (buckno<0)
	{
		/*pp->lChield = tp->chield;
		tp->chield = lch;
		bp = (Bucket *) (basep + ps - bs*(num+1));*/
		bp = (Bucket *) (basep + ps - (bs*(0+1)));
		mem_move(basep + (end - bs), basep + end, (num - 0) * bs);
	}
	else
	{
		bp = (Bucket *) (basep + ps - (bs*(buckno+1)));
		mem_move(basep + (end - bs), basep + end, (num - buckno) * bs);
	}

	if (!isLeap)
		bp->chield = tp->chield;
	bp->value = tp->value;
	bp->len = tp->keylen;
	bp->offs = beg;
	memcpy(basep + beg, tp->key, tp->keylen);
	pp->endData = beg + tp->keylen;
	pp->numBuck++;
}

static int
add_node(struct BtreeFile *fp, int btno, long recno, Tuple *tp, int unique )
{
	char *basep;
	PageHeader *pp;
	int isLeap, ps, bs, num, beg, end, size, buckno, r;
	Bucket *bp;
	long root;

	root = getHeader(fp)->roots[btno].root;
	ps = fp->pageSize;
	basep = getRec_MapFile(fp->mp, recno);
	pp = (PageHeader *) basep;
	isLeap = pp->flags & LEAP_FLAG;
	bs = (isLeap ? sizeof(LeapBucket) : sizeof(Bucket));
	num = pp->numBuck;
	beg = pp->endData;
	end = ps - bs * num;
	size = end -bs - beg;

	r = search_bucket(pp, ps, 0, tp, &buckno, unique);

	if (r)
	{
		bp = get_buck(pp,ps,buckno);
		if (bp->value == -1)
		{
			bp->value = tp->value;
			tp->found = 1;
		}
		else
			tp->found = 0;
		return 0;
	}

	if (!isLeap)
	{
		long chield = get_chield(pp,ps,buckno);

		r = add_node(fp,btno,chield, tp, unique);
		if (r==1)
		{
			/* add popped key */
		}
		else
		{
			return r;
		}
	}

	if (size > tp->keylen)
	{
		/* ok, just insert in this page */
		pp = (PageHeader*) getRec_MapFile(fp->mp, recno);
		put_node(pp,ps,bs,buckno+1,tp);
		tp->found = 1;
		return 0;
	}

	/* split this node */
	r = split_node(fp, btno, recno, buckno+1, tp);

	if (recno==root)
	{
		add_root(fp, btno, tp, recno );
		tp->found = 1;
		return 0;
	}

	return r;
}


int
addKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int keylen, long value, int *result)
{
	Header *hp;
	long root;
	int ret;
	Tuple tuple;

	if (lockHeader(fp, &hp, 1))
		return -1;

	if (btno < 0 || btno >= hp->ntree || hp->roots[btno].root == -1)
	{
		unlockHeader(fp);
		sprintf(fp->buf, "invalid btno (%d)", btno);
		return -1;
	}

	root = hp->roots[btno].root;

	tuple.key = key;
	tuple.keylen = keylen;
	tuple.keysize = keylen;
	tuple.freeMem = 0;
	tuple.value = value;
	tuple.chield = -1;
	tuple.found = 0;
	ret = add_node(fp, btno, root, &tuple, hp->roots[btno].unique);
	*result = tuple.found;
	destroy_Tuple(&tuple);

	unlockHeader(fp);
	return ret;
}


static int
del_node(struct BtreeFile *fp, int btno, long recno, Tuple *tp )
{
	PageHeader *pp;
	int isLeap, ps, buckno, r;
	Bucket *bp;

	ps = fp->pageSize;
	pp = (PageHeader *)getRec_MapFile(fp->mp, recno);
	isLeap = pp->flags & LEAP_FLAG;

	r = search_bucket(pp, ps, 0, tp, &buckno, 0);

	if (r)
	{
		bp = get_buck(pp,ps,buckno);
		if (bp->value == -1)
			tp->found = 0;
		else
		{
			tp->found = 1;
			bp->value = -1;
		}
		return 0;
	}

	if (isLeap)
	{
		tp->found = 0;
		return 0;
	}
	else
	{
		long chield = get_chield(pp,ps,buckno);
		return del_node(fp,btno,chield,tp);
	}
}


int
delKey_BtreeFile(struct BtreeFile *fp, int btno, char *key, int keylen, long value, int *result)
{
	Header *hp;
	long root;
	int ret;
	Tuple tuple;

	if (lockHeader(fp, &hp, 1))
		return -1;

	if (btno < 0 || btno >= hp->ntree || hp->roots[btno].root == -1)
	{
		unlockHeader(fp);
		sprintf(fp->buf, "invalid btno (%d)", btno);
		return -1;
	}

	root = hp->roots[btno].root;

	tuple.key = key;
	tuple.keylen = keylen;
	tuple.keysize = keylen;
	tuple.freeMem = 0;
	tuple.value = value;
	tuple.chield = -1;
	tuple.found = 0;
	ret = del_node(fp, btno, root, &tuple);
	*result = tuple.found;
	destroy_Tuple(&tuple);

	unlockHeader(fp);
	return ret;
}
