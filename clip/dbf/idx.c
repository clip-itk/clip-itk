/*
$Log: idx.c,v $
Revision 1.12  2000/05/26 21:07:41  clip
fix positioning of a current record
start of idxdump
Alex Vorontsov <axl@itk.ru>

Revision 1.11  2000/05/22 23:41:50  clip
IDX RDD is WORKED!!! Begin of find a gluk's :)
Alex Vorontsov <axl@itk.ru>

Revision 1.8  2000/05/18 19:23:50  clip
fix dbselectarea, make dbunlockall
continue idx RDD

Revision 1.6  2000/05/12 21:39:02  clip
fix error messages return & idx continue (axl)

Revision 1.5  2000/04/28 17:55:33  clip

bsd fixes

Revision 1.4  2000/03/07 20:29:10  axl
Fix bug in indexes (seek)

Revision 1.3  2000/02/13 16:58:25  axl
fix exclusive locking (not locking :)

Revision 1.2  2000/02/11 20:18:59  axl
fix softseek in ntx, creating of idx

Revision 1.1  2000/01/14 18:15:45  axl
start cvs logging

*/

#define IDX_DEBUG

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

#include "dbfpriv.h"
#include "idx.h"

#define MAX(a, b) (a > b ? a : b)
#define MIN(a, b) (a <= b ? a : b)

typedef struct
{
	long pageoffs;
	int buckno;
}
IdxStack;

/* max deep of IDX btree */
#define IDX_DEEP 64

static int idx_destroy(struct DbfFile *fp, DbfIndex *ip);
static int idx_create(struct DbfFile *fp, DbfIndex *ip);
static int idx_open(struct DbfFile *fp, DbfIndex *ip);
static int idx_zap(struct DbfFile *fp, DbfIndex *ip);

static int idx_del(struct DbfFile *fp, DbfIndex *ip, Tuple *tp);
static int idx_add(struct DbfFile *fp, DbfIndex *ip, Tuple *tp);

static int idx_first(struct DbfFile *fp, DbfIndex *ip);
static int idx_last(struct DbfFile *fp, DbfIndex *ip);
static int idx_next(struct DbfFile *fp, DbfIndex *ip);
static int idx_prev(struct DbfFile *fp, DbfIndex *ip);

static int idx_seek(struct DbfFile *fp, DbfIndex *ip, Tuple *tp);

static IdxHeader *idx_get_header(DbfIndex *ip);

DbfIndexVtbl idxVtbl =
{
	"idx",

	".idx",
	idx_destroy,

	idx_create,
	idx_open,
	idx_zap,

	idx_del,
	idx_add,

	idx_first,
	idx_last,
	idx_prev,
	idx_next,

	idx_seek,
};

static int idx_init_page(DbfIndex *ip, IdxPage *pp, long left, long right, unsigned long rlen);
static int idx_add_node(struct DbfFile *fp, DbfIndex *ip, IdxStack *stack, int *level, IdxPage *page);
static int idx_put_node(struct DbfFile *fp, DbfIndex *ip, IdxStack *stack, int *level, IdxPage *page, int mode);
static int idx_add_key(struct DbfFile *fp, DbfIndex *ip, Tuple *tp, IdxStack *stack, int *level);
static int idx_del_key(struct DbfFile *fp, DbfIndex *ip, IdxStack *stack, int *level);

/* [ IDX */

static int
idx_merror(struct DbfFile *fp, struct MapFile *mp, int line)
{
	int l;

	snprintf(fp->errbuf, ERRBUFSIZE, "IDX: %s, line %d: ", __FILE__, line);
	l = strlen(fp->errbuf);
	getError_MapFile(mp, fp->errbuf + l, ERRBUFSIZE - l);
	return 1;
}

static int
idx_error(struct DbfFile *fp, int line, const char *fmt,...)
{
	int l;
	va_list ap;

	va_start(ap, fmt);
	snprintf(fp->errbuf, ERRBUFSIZE, "IDX: %s, line %d: ", __FILE__, line);
	l = strlen(fp->errbuf);
	vsnprintf(fp->errbuf + l, ERRBUFSIZE - l, fmt, ap);
	va_end(ap);
	return 1;
}

static IdxPage *
idx_get_page(DbfIndex *ip, long pageoffs)
{
	return (IdxPage *) (getMap_MapFile(ip->mp) + pageoffs);
}
/*
static long
idx_get_pageoffs(DbfIndex *ip, IdxPage *pp)
{
	return (long) pp - (long) getMap_MapFile(ip->mp);
}
*/
static int
idx_create(struct DbfFile *fp, DbfIndex *ip)
{
	struct MapFile *mp;
	IdxHeader *hp;
	long recno;
	int flen, klen, r = 0;

	mp = create_MapFile(ip->filename, IDX_HEADER_SIZE, IDX_PAGE_SIZE, fp->errbuf, ERRBUFSIZE);
	if (!mp)
		return 1;

	if ((r = dbf_wlock(fp, mp, 0)))
	{
	      err:
		idx_merror(fp, mp, __LINE__);
		close_MapFile(mp);
		return r;
	}
	hp = (IdxHeader *) getHeader_MapFile(mp);

	dbf_put_long(hp->root, 1024);
	dbf_put_long(hp->empty, 0);
	dbf_put_long(hp->version, 0);
	dbf_put_ushort(hp->key_size, ip->len);
	hp->options = IDX_COMPACT + (ip->unique ? IDX_UNIQUE : 0) + (ip->fexpr ? IDX_FOREXPR : 0);
	hp->signature = 0;
	dbf_put_ushort(hp->order, 0);
	klen = strlen(ip->expr) + 1;
	flen = (ip->fexpr ? strlen(ip->fexpr) : 0) + 1;
	dbf_put_ushort(hp->key_len, klen);
	dbf_put_ushort(hp->for_len, flen);
	memcpy(hp->expr, ip->expr, klen);
	if (flen>1)
	{
		memcpy(hp->expr+klen, ip->fexpr, flen);
		klen += flen;
	}
	dbf_put_ushort(hp->total_len, klen);

	if ((r = incr_MapFile(mp, &recno, 1, 0)))
		goto err;

	ip->mp = mp;
	idx_init_page(ip, idx_get_page(ip, 1024), -1, -1, 0);
	dbf_put_ushort(idx_get_page(ip, 1024)->attr, IDX_KEY_ROOT|IDX_KEY_LEAF);

	r = dbf_ulock(fp, mp, 0);

	return r;
}

static int
idx_zap(struct DbfFile *fp, DbfIndex *ip)
{
	IdxHeader *hp;
	int r = 0, r1;

	if ((r = dbf_wlock(fp, ip->mp, 0)))
		return r;

	hp = idx_get_header(ip);
	dbf_put_long(hp->root, 1024);
	dbf_put_long(hp->empty, 0);

	idx_init_page(ip, idx_get_page(ip, 1024), -1, -1, 0);
	if ((r = decr_MapFile(ip->mp, 1)))
		idx_merror(fp, ip->mp, __LINE__);

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
idx_destroy(struct DbfFile *fp, DbfIndex *ip)
{
	free(ip->fexpr);
	return 0;
}

static int
idx_open(struct DbfFile *fp, DbfIndex *ip)
{
	struct MapFile *mp;
	IdxHeader *hp;
	int r = 0, klen, flen;

	mp = open_MapFile(ip->filename, IDX_HEADER_SIZE, !fp->readonly, fp->errbuf, ERRBUFSIZE);
	if (!mp)
		return 1;

	setRecSize_MapFile(mp, IDX_PAGE_SIZE);

	if ((r = dbf_rlock(fp, mp, 0)))
	{
		idx_merror(fp, mp, __LINE__);
		close_MapFile(mp);
		return r;
	}

	hp = (IdxHeader *) getHeader_MapFile(mp);
	klen = dbf_get_ushort(hp->key_len)-1;
	flen = dbf_get_ushort(hp->for_len)-1;
	ip->expr = dbf_mem_dup(hp->expr, klen);
	if (flen)
		ip->fexpr = dbf_mem_dup( hp->expr + klen + 1, flen);
	ip->len = dbf_get_ushort(hp->key_size);
	ip->unique = hp->options & IDX_UNIQUE;

	r = dbf_ulock(fp, mp, 0);

	ip->mp = mp;

	return r;
}

static IdxHeader *
idx_get_header(DbfIndex *ip)
{
	return (IdxHeader *) getHeader_MapFile(ip->mp);
}

static long
idx_get_long(unsigned char *c)
{
	long ret = *c;
	ret = (ret << 8) + *(c+1);
	ret = (ret << 8) + *(c+2);
	ret = (ret << 8) + *(c+3);
	return ret;
}

void
idx_put_long(unsigned char *cp, long lval)
{
	*cp++ = (lval >> 24) & 0xff;
	*cp++ = (lval >> 16) & 0xff;
	*cp++ = (lval >> 8) & 0xff;
	*cp++ = lval & 0xff;
}

static int
compare_key(int unique, char *s1, int l1, long val1, char *s2, int l2, long val2)
{
	int l = (l1 < l2 ? l1 : l2);
	int r = memcmp(s1, s2, l);

	if (r)
		return r;
	else
	{
		if (unique || val1 == 0 || val2 == 0)
			return 0;
		if (val1 < val2)
			return -1;
		else if (val1 > val2)
			return 1;
		else
			return 0;
	}
}

void
idx_get_bucket(IdxPage *ip, IdxBucket *it, unsigned char *c)
{
	unsigned long long r = dbf_get_long(c);

	if ( ip->keybytes > 4)
		r += dbf_get_ushort(c+4);
	it->record = (unsigned long) (r & dbf_get_long(ip->rmask));
	r = r >> ip->rbits;
	it->dup = (unsigned int) (r & ip->dmask);
	r = r >> ip->dbits;
	it->trail = (unsigned int) (r & ip->tmask);

	return;
}

void
idx_put_bucket(IdxPage *ip, IdxBucket *it, unsigned char *c)
{
	unsigned long long r;
	r = it->record + (((it->trail << ip->dbits) + it->dup) << ip->rbits);
	if ( ip->keybytes < 4 )
	{
		dbf_put_ushort(c, (unsigned short) (r & 0xFFFF));
		if ( ip->keybytes == 3 )
			*(c+2) = (unsigned char) (r>>16);
	}
	else
	{
		dbf_put_long(c, (unsigned long) (r & 0xFFFFFFFF));
		r = r >> 32;
		if ( ip->keybytes == 5 )
			*(c+2) = (unsigned char) r;
		else if ( ip->keybytes == 6 )
			dbf_put_ushort(c+4, (unsigned short) r);
	}

	return;
}

void
idx_get_leaf(IdxPage *pp, int no, Tuple *tp)
{
	unsigned char *offs = (unsigned char*) pp + IDX_LEAF_OFFS;
	unsigned char *kp = (char*) pp + IDX_PAGE_SIZE;
	IdxBucket bp;
	int i, klen;

	for (i = 0; i <= no; i++)
	{
		idx_get_bucket(pp, &bp, offs);
		klen = tp->len-bp.dup-bp.trail;
		kp -= klen;
		memcpy(tp->key+bp.dup, kp, klen);
		memset(tp->key+klen+bp.dup, 32, bp.trail);
		offs += pp->keybytes;
	}

	tp->value = bp.record;
}

static int
idx_search_tree(struct DbfFile *fp, DbfIndex *ip, Tuple *tp, IdxStack *stack, int *level)
{
	IdxHeader *hp = idx_get_header(ip);
	unsigned long page = dbf_get_long(hp->root);
	IdxPage *pp = idx_get_page(ip, page);
	unsigned char *offs;
	IdxBucket bp;
	unsigned char str[ip->len];
	unsigned char *kp;
	int i = 1, count = 0, c = -1, blen = ip->len + 8;

	(*level) = 0;

	while (!(dbf_get_ushort(pp->attr) & IDX_KEY_LEAF))
	{
		offs = (unsigned char *)pp + IDX_INDEX_OFFS;
		count = dbf_get_ushort(pp->count);

		for (c = 0, i = 0; i < count; i++)
		{
			c = compare_key(ip->unique, offs, ip->len, idx_get_long(offs+ip->len), tp->key, tp->len, tp->value);
			if (c >= 0) break;
			offs += blen;
		}

		stack[*level].pageoffs = page;
		stack[*level].buckno = i;

		if (c < 0 && i == count)
		{
			i = count - 1;
			offs -= blen;
		}

		if (++(*level) >= IDX_DEEP)
			return idx_error(fp, __LINE__, "IDX btree too deep: %d", *level);

		page = idx_get_long(offs + ip->len +4);
		pp = idx_get_page(ip, page);
	}

	if (i != count)
	{
		offs = (unsigned char *)pp + IDX_LEAF_OFFS;
		count = dbf_get_ushort(pp->count);
		kp = (char*) pp + IDX_PAGE_SIZE;

		for (i = 0; i < count; i++)
		{
			idx_get_bucket(pp, &bp, offs);
			blen = ip->len-bp.dup-bp.trail;
			kp -= blen;
			memcpy(str+bp.dup, kp, blen);
			memset(str+blen+bp.dup, 32, bp.trail);
			c = compare_key(ip->unique, str, ip->len, bp.record, tp->key, tp->len, tp->value);
			if (c >= 0) break;
			offs += pp->keybytes;
		}
	}

	stack[*level].pageoffs = page;
	stack[*level].buckno = i;
	tp->ok = c ? 0 : 1;
	if ( c < 0 )
	{
		tp->value = ip->keypos = DBF_EOF_POS;
		memset(tp->key, 0xff, ip->len);
	}
	else
	{
		memcpy(tp->key, str, tp->len);
		tp->value = bp.record;
	}

	return 0;
}

static int
idx_seek(struct DbfFile *fp, DbfIndex *ip, Tuple *tp)
{
	IdxStack stack[IDX_DEEP];
	int level, r = 0, r1;

	if ((r = dbf_rlock(fp, ip->mp, 0)))
		return r;

	r = idx_search_tree(fp, ip, tp, stack, &level);

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
idx_first(struct DbfFile *fp, DbfIndex *ip)
{
	unsigned char *offs, *kp;
	IdxHeader *hp;
	IdxPage *pp;
	IdxBucket bp;
	long node;
	unsigned int i, klen, count;

	if ((i = dbf_rlock(fp, ip->mp, 0)))
		return i;

	hp = idx_get_header(ip);
	node = dbf_get_long(hp->root);
	for(;;)
	{
		pp = idx_get_page(ip, node);
		if(dbf_get_ushort(pp->attr) & IDX_KEY_LEAF)
			break;
		offs = (unsigned char*)pp + IDX_INDEX_OFFS;
		if (dbf_get_ushort(hp->order))
			node = idx_get_long(offs + (ip->len + 8)*dbf_get_ushort(pp->count) - 4);
		else
			node = idx_get_long(offs + ip->len + 4);
	}

	offs = (unsigned char*) pp + IDX_LEAF_OFFS;
	kp = (char*) pp + IDX_PAGE_SIZE;
	if (dbf_get_ushort(hp->order))
		count = dbf_get_ushort(pp->count);
	else
		count = 1;

	for (i = 0; i < count; i++)
	{
		idx_get_bucket(pp, &bp, offs);
		klen = ip->len-bp.dup-bp.trail;
		kp -= klen;
		memcpy(ip->keybuf+bp.dup, kp, klen);
		memset(ip->keybuf+klen+bp.dup, 32, bp.trail);
		ip->keypos = bp.record;
		offs += pp->keybytes;
	}

	i = dbf_ulock(fp, ip->mp, 0);

	return i;
}

static int
idx_last(struct DbfFile *fp, DbfIndex *ip)
{
	unsigned char *offs, *kp;
	IdxHeader *hp;
	IdxPage *pp;
	IdxBucket bp;
	long node;
	unsigned int i, klen, count;

	if ((i = dbf_rlock(fp, ip->mp, 0)))
		return i;

	hp = idx_get_header(ip);
	node = dbf_get_long(hp->root);
	for(;;)
	{
		pp = idx_get_page(ip, node);
		if(dbf_get_ushort(pp->attr) & IDX_KEY_LEAF)
			break;
		offs = (unsigned char*)pp + IDX_INDEX_OFFS;
		if (!dbf_get_ushort(hp->order))
			node = idx_get_long(offs + (ip->len + 8)*dbf_get_ushort(pp->count) - 4);
		else
			node = idx_get_long(offs + ip->len + 4);
	}

	offs = (unsigned char*) pp + IDX_LEAF_OFFS;
	kp = (char*) pp + IDX_PAGE_SIZE;
	if (!dbf_get_ushort(hp->order))
		count = dbf_get_ushort(pp->count);
	else
		count = 1;

	for (i = 0; i < count; i++)
	{
		idx_get_bucket(pp, &bp, offs);
		klen = ip->len-bp.dup-bp.trail;
		kp -= klen;
		memcpy(ip->keybuf+bp.dup, kp, klen);
		memset(ip->keybuf+klen+bp.dup, 32, bp.trail);
		ip->keypos = bp.record;
		offs += pp->keybytes;
	}

	i = dbf_ulock(fp, ip->mp, 0);

	return i;
}

static int
idx_next(struct DbfFile *fp, DbfIndex *ip)
{
	Tuple tup;
	IdxStack stack[IDX_DEEP];
	int level, r = 0, r1;
	IdxPage *pp;
	unsigned long page;
	int no, count;

	if ((r = dbf_rlock(fp, ip->mp, 0)))
		return r;

	memset(&tup, 0, sizeof(tup));
	tup.key = ip->keybuf;
	tup.len = ip->len;
	tup.size = ip->len;
	tup.value = ip->keypos;

	if ((r = idx_search_tree(fp, ip, &tup, stack, &level)))
		return r;

	page = stack[level].pageoffs;
	no = stack[level].buckno+1;

	pp = idx_get_page(ip, page);
	count = dbf_get_ushort(pp->count);

	if (no == count)
	{
		page = dbf_get_long(pp->right);
		if (page == -1)
		{
			ip->keypos = DBF_EOF_POS;
			memset(ip->keybuf, 0xff, ip->len);
		}
		pp = idx_get_page(ip, page);
		no = 0;
	}

	if (page != -1)
	{
		idx_get_leaf(pp, no, &tup);
		ip->keypos = tup.value;
		memcpy(ip->keybuf, tup.key, ip->len);
	}

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
idx_prev(struct DbfFile *fp, DbfIndex *ip)
{
	Tuple tup;
	IdxStack stack[IDX_DEEP];
	int level, r = 0, r1;
	IdxPage *pp;
	unsigned long page;
	int no, count;

	if ((r = dbf_rlock(fp, ip->mp, 0)))
		return r;

	memset(&tup, 0, sizeof(tup));
	tup.key = ip->keybuf;
	tup.len = ip->len;
	tup.size = ip->len;
	tup.value = ip->keypos;

	if ((r = idx_search_tree(fp, ip, &tup, stack, &level)))
		return r;

	page = stack[level].pageoffs;
	no = stack[level].buckno-1;

	pp = idx_get_page(ip, page);
	count = dbf_get_ushort(pp->count);

	if (no == -1)
	{
		page = dbf_get_long(pp->left);
		if (page == -1)
		{
			ip->keypos = DBF_BOF_POS;
			memset(ip->keybuf, 0, ip->len);
		}
		pp = idx_get_page(ip, page);
		no = dbf_get_ushort(pp->count)-1;
	}

	if (page != -1)
	{
		idx_get_leaf(pp, no, &tup);
		ip->keypos = tup.value;
		memcpy(ip->keybuf, tup.key, ip->len);
	}

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
idx_put_free_node(struct DbfFile *fp, DbfIndex *ip, unsigned long page)
{
	IdxHeader *hp;
	int r = 0, r1;
	unsigned long pg;
	IdxPage *pp = idx_get_page(ip, page);

	if ((r = dbf_wlock(fp, ip->mp, 0)))
		return r;

	hp = idx_get_header(ip);
	pg = dbf_get_long(hp->empty);
	dbf_put_long(pp->right, pg);
	dbf_put_long(hp->empty, page);

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
idx_get_free_node(struct DbfFile *fp, DbfIndex *ip, unsigned long *page)
{
	IdxHeader *hp;
	int r = 0, r1;
	unsigned long pg;
	IdxPage *pp;

	if ((r = dbf_wlock(fp, ip->mp, 0)))
		return r;

	hp = idx_get_header(ip);
	pg = dbf_get_long(hp->empty);

	if ( pg )
	{
		*page = pg;
		pp = idx_get_page(ip, pg);
		pg = dbf_get_long(pp->right);
		if ( pg == 0xFFFFFFFFl )
			pg = 0;
		dbf_put_long(hp->empty, pg);
	}
	else
	{
		if ((r = incr_MapFile(ip->mp, &pg, 1, 0)))
			idx_merror(fp, ip->mp, __LINE__);
		*page = pg * IDX_PAGE_SIZE + IDX_HEADER_SIZE;
	}

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

#define Get_Tmp_Node()		(IdxPage*) malloc(IDX_PAGE_SIZE)
#define Free_Tmp_Node(page)	free(page)

static int
idx_init_page(DbfIndex *ip, IdxPage *pp, long left, long right, unsigned long rlen)
{
	unsigned long len = ip->len;
	unsigned long i;
	memset(pp, 0, IDX_PAGE_SIZE);
	dbf_put_ushort(pp->attr, IDX_KEY_LEAF);
	dbf_put_ushort(pp->count, 0);
	dbf_put_long(pp->left, left);
	dbf_put_long(pp->right, right);
	dbf_put_ushort(pp->free, IDX_PAGE_SIZE - IDX_LEAF_OFFS);

	for(i = 0; len; i++) len >>= 1;
	pp->dmask = pp->tmask = (char)((1l << i) - 1);
	pp->dbits = pp->tbits = i;

	len = i * 2;

	if (rlen < (1l << 16))
		i = 16;
	else
		for(i = 0; rlen; i++) rlen >>= 1;

	rlen = len + i;
	for( i = 24 ; rlen > i ; i += 8 );
	pp->rbits = i - len;
	dbf_put_long(pp->rmask, 0xFFFFFFFFul >> (32 - pp->rbits));
	pp->keybytes = i >> 3;

	return 0;
}

#if 0
static int
put_free_page(struct DbfFile *fp, DbfIndex *ip, long page)
{
	return 0;
}

static int
striplen(char *str, int len)
{
	while ( len-- && *(str+len)==32 ) ;
	return len+1;
}
#endif

static int
idx_split_node(struct DbfFile *fp, DbfIndex *ip, IdxStack *stack, int *level)
{
	IdxPage *pp = idx_get_page(ip, stack[*level].pageoffs);
	IdxPage *pp1 = Get_Tmp_Node();
	IdxPage *pp2 = Get_Tmp_Node();
	unsigned long count = dbf_get_ushort(pp->count);
	unsigned long no = count - (count/2);

	if (dbf_get_ushort(pp->attr) & IDX_KEY_LEAF)
	{
		unsigned long klen = 0;
		unsigned long i = dbf_get_long(pp->rmask);
		unsigned char* s_pp = (unsigned char*)pp + IDX_LEAF_OFFS;
		unsigned char* e_pp = (unsigned char*)pp + IDX_PAGE_SIZE;
		/*
		unsigned char* s_np = (unsigned char*)pp1 + IDX_LEAF_OFFS;
		unsigned char* e_np = (unsigned char*)pp1 + IDX_PAGE_SIZE;
		*/
		unsigned char *buf = (unsigned char*) malloc(ip->len);
		IdxBucket bp;

		idx_init_page(ip, pp1, dbf_get_long(pp->left), 0, i);
		dbf_put_ushort(pp1->count, no);

		for ( i = 0; i < no; i++ )
		{
			idx_get_bucket(pp, &bp, s_pp);
			klen = ip->len-bp.dup-bp.trail;
			e_pp -= klen;
			memcpy(buf + bp.dup, e_pp, klen);
			s_pp += pp->keybytes;
		}

		memcpy((char*)pp1+IDX_LEAF_OFFS, (char*)pp+IDX_LEAF_OFFS, no*pp->keybytes);
		klen = (unsigned char*)pp + IDX_PAGE_SIZE - e_pp;
		memcpy((char*)pp1+IDX_PAGE_SIZE - klen, e_pp, klen);
		dbf_put_ushort(pp1->free, e_pp - s_pp);

		no = count - no;
		idx_init_page(ip, pp2, 0, dbf_get_long(pp->right), i);
		dbf_put_ushort(pp2->count, no);

		memcpy((char*)pp2+IDX_LEAF_OFFS, s_pp, no*pp->keybytes);
		idx_get_bucket(pp, &bp, s_pp);
		no *= pp->keybytes;
		s_pp += no + dbf_get_ushort(pp->free);
		i = ip->len-bp.dup-bp.trail;
		e_pp -= i;
		memcpy((char*)pp2+IDX_PAGE_SIZE-i, e_pp, i);
		i += bp.dup;
		memcpy((char*)pp2+IDX_PAGE_SIZE-i, buf, bp.dup);
		bp.dup = 0;
		idx_put_bucket(pp2, &bp, (unsigned char*)pp2+IDX_LEAF_OFFS);
		klen = e_pp - s_pp;
		memcpy((char*)pp2+IDX_PAGE_SIZE-klen-i, e_pp-klen, klen);
		dbf_put_ushort(pp2->free, IDX_PAGE_SIZE-IDX_LEAF_OFFS-no-klen-i);
		free(buf);
	}
	else
	{
		unsigned char *offset = (unsigned char*) pp + IDX_INDEX_OFFS;
		long bucklen = ip->len + 2 * sizeof(unsigned long);

		memset(pp1, 0, IDX_PAGE_SIZE);
		memset(pp2, 0, IDX_PAGE_SIZE);

		memcpy(pp1, (unsigned char*)pp, IDX_INDEX_OFFS);
		memcpy(pp2, (unsigned char*)pp, IDX_INDEX_OFFS);

		dbf_put_ushort(pp1->attr, IDX_KEY_NODE);
		dbf_put_ushort(pp2->attr, IDX_KEY_NODE);
		dbf_put_ushort(pp1->count, no);
		memcpy(pp1 + IDX_INDEX_OFFS, offset, bucklen * no);

		offset += bucklen * no;

		no = count - no;
		dbf_put_ushort(pp2->count, no);
		memcpy(pp2 + IDX_INDEX_OFFS, offset, bucklen * no);
	}

	if (idx_get_free_node(fp, ip, &no))
		return 1;

	dbf_put_long(pp1->right, no);

	if (*level)
	{
		(*level)--;

		if (idx_put_node(fp, ip, stack, level, pp1, 0 /* put */))
			return 1;

		stack[(*level)].buckno++;
		stack[(*level)+1].pageoffs = no;
		if (idx_add_node(fp, ip, stack, level, pp2))
			return 1;

		dbf_put_long(pp2->left, stack[*level].pageoffs);
	}
	else
	{
		//split a root page !!!
		memset((char*)pp+IDX_INDEX_OFFS, 0, IDX_PAGE_SIZE-IDX_INDEX_OFFS);
		dbf_put_ushort(pp->attr, IDX_KEY_ROOT);
		dbf_put_ushort(pp->count, 0);

		stack[(*level)+1].pageoffs = no;
		stack[(*level)].buckno = 0;
		if (idx_put_node(fp, ip, stack, level, pp1, 1))
			return 1;

		pp = idx_get_page(ip, no);
		dbf_put_long(pp2->left, no);
		if (idx_get_free_node(fp, ip, &no))
			return 1;

		stack[(*level)+1].pageoffs = no;
		stack[(*level)].buckno = 1;
		if (idx_put_node(fp, ip, stack, level, pp2, 1))
			return 1;

		dbf_put_long(pp1->right, no);
	}

	memcpy(pp, pp1, IDX_PAGE_SIZE);

	Free_Tmp_Node(pp1);
	pp = idx_get_page(ip, no);
	memcpy(pp, pp2, IDX_PAGE_SIZE);
	Free_Tmp_Node(pp2);

	return 0;
}

static int
idx_put_node(struct DbfFile *fp, DbfIndex *ip, IdxStack *stack, int *level, IdxPage *page, int insert)
{
	IdxPage *pp = idx_get_page(ip, stack[*level].pageoffs);
	long buckno = stack[*level].buckno;
	long no, count = dbf_get_ushort(page->count);
	long koffs, blen = ip->len + 8;
	IdxPage *np = Get_Tmp_Node();
	char *buf = (char*) malloc(ip->len);

	memcpy(np, pp, IDX_PAGE_SIZE);

	if (dbf_get_ushort(page->attr) & IDX_KEY_LEAF)
	{
		Tuple tup;
		memset(&tup, 0, sizeof(tup));
		tup.key = buf;
		tup.len = ip->len;
		tup.size = ip->len;
		idx_get_leaf(page, count-1, &tup);
		no = tup.value;
	}
	else
	{
		koffs = IDX_INDEX_OFFS + blen * (count - 1);
		memcpy(buf, (char*)page + koffs, ip->len);
		no = idx_get_long( (unsigned char*) page + koffs + ip->len);
	}

	count = dbf_get_ushort(pp->count);
	koffs = IDX_INDEX_OFFS + blen * buckno;

	if (insert)
	{
		dbf_put_ushort(np->count, count+1);
		memcpy((char*)np + koffs + blen, (char*)pp + koffs, blen * (count - buckno));
	}

	memcpy((char*)np + koffs, buf, ip->len);

	koffs += ip->len;
	idx_put_long((unsigned char*)np + koffs, no);
	idx_put_long((unsigned char*)np + koffs + 4, stack[(*level)+1].pageoffs);

	if (buckno == count && *level)
	{
		(*level)--;
		idx_put_node(fp, ip, stack, level, np, 0);
	}

	memcpy(pp, np, IDX_PAGE_SIZE);
	free(buf);
	Free_Tmp_Node(np);

	return 0;
}

static int
idx_add_node(struct DbfFile *fp, DbfIndex *ip, IdxStack *stack, int *level, IdxPage *page)
{
	if ( dbf_get_ushort(page->count) * ip->len + IDX_INDEX_OFFS < ip->len + 8 )
		idx_split_node(fp, ip, stack, level);

	idx_put_node(fp, ip, stack, level, page, 1);

	return 0;
}

static int
idx_put_key(struct DbfFile *fp, DbfIndex *ip, IdxPage *pp, int no, Tuple *tp)
{
	unsigned long count = dbf_get_ushort(pp->count);
	IdxPage *np = Get_Tmp_Node();
	unsigned char *s_pp = (unsigned char*) pp + IDX_LEAF_OFFS;
	unsigned char *e_pp = (unsigned char*) pp + IDX_PAGE_SIZE;
	unsigned char *s_np = (unsigned char*) np + IDX_LEAF_OFFS;
	unsigned char *e_np = (unsigned char*) np + IDX_PAGE_SIZE;
	unsigned char *buf = (unsigned char*) malloc(ip->len);
	IdxBucket bp;
	unsigned long i, addkey = dbf_get_long(pp->rmask);
	unsigned long klen = 0, keylen = tp->len;

	while ( keylen-- && tp->key[keylen]==' ' ) ;
	keylen++;

	if (addkey < tp->value)
	{
		addkey = tp->value;	/* New size of buckets */
		if ((np->keybytes - pp->keybytes) * count > dbf_get_long(pp->free))
			goto split; /* Split node before append key */
	}

	idx_init_page(ip, np, dbf_get_long(pp->left), dbf_get_long(pp->right), addkey);
	dbf_put_ushort(np->count, count+1);

	for ( i = 0; i < no; i++ )
	{
		idx_get_bucket(pp, &bp, s_pp);
		klen = ip->len-bp.dup-bp.trail;
		e_pp -= klen;
		memcpy(buf+bp.dup, e_pp, klen);
		klen += bp.dup;
		memset(buf+klen, 32, bp.trail);
		idx_put_bucket(pp, &bp, s_np);
		s_pp += pp->keybytes;
		s_np += np->keybytes;
	}

	if (i)
	{
		klen = (unsigned char*)pp + IDX_PAGE_SIZE - e_pp;
		e_np -= klen;
		memcpy(e_np, e_pp, klen);
		for( i = 0; i < keylen; i++ )
			if ( *(tp->key+i)-buf[i] )
				break;
	}

	bp.record = tp->value;
	bp.dup = i;
	bp.trail = ip->len - keylen;
	idx_put_bucket(np, &bp, s_np);
	s_np += np->keybytes;
	addkey = keylen - bp.dup;
	e_np -= addkey;
	memcpy(e_np, tp->key+bp.dup, addkey);

	if (no < count)
	{
		idx_get_bucket(pp, &bp, s_pp);
		klen = ip->len-bp.dup-bp.trail;
		e_pp -= klen;
		memcpy(buf+bp.dup, e_pp, klen);
		memset(buf+klen+bp.dup, 32, bp.trail);
		s_pp += pp->keybytes;
		klen += bp.dup;

		for( i = 0; i < keylen; i++ )
			if ( *(tp->key+i)-buf[i] )
				break;
		bp.dup = i;
		bp.trail = ip->len - klen;
		idx_put_bucket(np, &bp, s_np);
		s_np += pp->keybytes;
		e_np -= klen - bp.dup;
		memcpy(e_np, buf+bp.dup, klen-bp.dup);

		no = count - no - 1;
		keylen = (unsigned char*)pp + IDX_PAGE_SIZE - e_pp;
		for ( i = 0; i < no; i++ )
		{
			idx_get_bucket(pp, &bp, s_pp);
			klen = ip->len-bp.dup-bp.trail;
			e_pp -= klen;
			memcpy(buf+bp.dup, e_pp, klen);
			klen += bp.dup;
			memset(buf+klen, 32, bp.trail);
			idx_put_bucket(pp, &bp, s_np);
			s_pp += pp->keybytes;
			s_np += np->keybytes;
		}
		klen = (unsigned char*)pp + IDX_PAGE_SIZE - e_pp - keylen;
		e_np -= klen;
		memcpy(e_np, e_pp, klen);
	}

	if (e_np<s_np)	/* Oops! Not empty space for new key! */
	{
      split:
		Free_Tmp_Node(np);
		free(buf);
		return 1;
	}

	dbf_put_ushort(np->free, e_np - s_np);

	memcpy(pp, np, IDX_PAGE_SIZE);
	Free_Tmp_Node(np);
	free(buf);

	return 0;
}

static int
idx_add_key(struct DbfFile *fp, DbfIndex *ip, Tuple *tp, IdxStack *stack, int *level)
{
	long page = stack[*level].pageoffs;
	IdxPage *pp = idx_get_page(ip, page);
	short needup = dbf_get_ushort(pp->count) - stack[*level].buckno;

	if ( dbf_get_ushort(pp->free) < pp->keybytes)
	{
		// make node with new sizes of record|dup|trail bits
		// with save keys compressed
		idx_split_node(fp, ip, stack, level);
		return 1;
	}

	if (idx_put_key(fp, ip, pp, stack[*level].buckno, tp))
	{
		idx_split_node(fp, ip, stack, level);
		return 1;
	}

	if (!needup && *level)
	{
		(*level)--;
		idx_put_node(fp, ip, stack, level, pp, 0);
	}

	return 0;
}

static int
idx_add(struct DbfFile *fp, DbfIndex *ip, Tuple *tp)
{
	Tuple tup;
	IdxStack stack[IDX_DEEP];
	int level, r = 0, r1;

	if ((r = dbf_wlock(fp, ip->mp, 0)))
		return r;

	tp->ok = 0;
	memset(&tup, 0, sizeof(tup));
	tup.key = dbf_mem_dup(tp->key, tp->len);
	tup.len = tp->len;
	tup.size = tp->len;
	tup.value = tp->value;
	tup.ok = 1;

	r = idx_search_tree(fp, ip, tp, stack, &level);
	if (r)
	{
		free(tup.key);
		return r;
	}

	if (tp->ok)
	{
		if (ip->unique)
			r = idx_error(fp, __LINE__, "addkey: duplication key-value pair: tag '%s' key '%s' value '%ld'",
				      ip->tag, tp->key, tp->value);
	}
	else
	{
		tp->ok = 1;
		if (idx_add_key(fp, ip, &tup, stack, &level))
		{
			free(tp->key);
			tp->key = dbf_mem_dup(tup.key, tup.len);
			tp->value = tup.value;
			idx_search_tree(fp, ip, tp, stack, &level);
			tp->ok = 1;
			r = idx_add_key(fp, ip, &tup, stack, &level);
		}
	}

	memcpy(tp->key, tup.key, tup.len);
	tp->value=tup.value;
	free(tup.key);
	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}
/*
static int
idx_remove_key(DbfIndex *ip, IdxPage *pp, int no)
{
	long count = dbf_get_ushort(pp->count);
	unsigned char node[512];
	IdxPage *np = (IdxPage*) node;				 // new node page
	unsigned char *pn = node + IDX_LEAF_OFFS;		 // new ptr offs
	unsigned char *kn;					 // new key offs
	unsigned char *po = (unsigned char*) pp + IDX_LEAF_OFFS; // ptr offs
	unsigned char *ko = (unsigned char*) pp + IDX_PAGE_SIZE; // key offs
	unsigned char buf[ip->len];
	unsigned char buf2[ip->len];
	IdxBucket bp;
	IdxBucket bp2;
	long rmkey, i, klen = 0, klen2;

	memcpy(node, (unsigned char*)pp, IDX_PAGE_SIZE);
	dbf_put_ushort(np->count, count - 1);

	idx_get_bucket(pp, &bp, po);
	if (!no && bp.trail == ip->len)
	{
		klen = (count - 1) * pp->keybytes;
		memcpy(pn, po + pp->keybytes, klen);
		pn += klen;
		memset(pn, 0, pp->keybytes);
		dbf_put_ushort(np->free, dbf_get_ushort(pp->free) + pp->keybytes);
		memcpy(pp, node, IDX_PAGE_SIZE);
		return 0;
	}

//seek key
	for ( i = 0; i <= no; i++ )
	{
		idx_get_bucket(pp, &bp, po);
		klen = ip->len - bp.dup - bp.trail;
		ko -= klen;
		memcpy(buf + bp.dup, ko, klen);
		po += pp->keybytes;
	}
	memset(buf + klen + bp.dup, 32, bp.trail);
	rmkey = klen;
	pn += no * pp->keybytes;

// if removed last key of node
	if ( no == count )
	{
		rmkey = ko + rmkey - po;
		memset(pn, 0, rmkey);
		dbf_put_ushort(np->free, rmkey);

		memcpy(pp, np, IDX_PAGE_SIZE);

		return 0;
	}

//get_next_key
	idx_get_bucket(pp, &bp2, po);
	klen2 = ip->len - bp2.dup - bp2.trail;
	ko -= klen2;
	memcpy(buf2, buf, ip->len);
	memcpy(buf2 + bp2.dup, ko, klen2);
	memset(buf2 + klen2 + bp2.dup, 32, bp2.trail);
	po += pp->keybytes;

// insert modifyed next key
	if (bp.dup<bp2.dup)
	{
		rmkey -= bp2.dup - bp.dup;
		bp2.dup = bp.dup;
	}
	idx_put_bucket(np, &bp2, pn);
	pn += pp->keybytes;
	klen = ip->len - bp2.dup - bp2.trail; // new size of compressed key
	kn = node + (unsigned long)ko - (unsigned long)pp + rmkey;
	memcpy(kn, buf2+bp2.dup, klen);

//copy old keys
	klen = 0;
	klen2 = 0;
	for (i++; i<count; i++)
	{
		idx_get_bucket(pp, &bp, po + klen2);
		klen += ip->len - bp.dup - bp.trail;
		klen2 += pp->keybytes;
	}
	memcpy(pn, po, klen2);
	memcpy(kn - klen, ko - klen, klen);
	memset(kn - klen - rmkey, 0, rmkey);
	rmkey += dbf_get_ushort(pp->free) + pp->keybytes;
	dbf_put_ushort(np->free, rmkey);

	memcpy(pp, np, IDX_PAGE_SIZE);

	return 0;
}
*/
static int
idx_remove_key(DbfIndex *ip, IdxPage *pp, int no)
{
	long count = dbf_get_ushort(pp->count);
	unsigned char node[512];
	IdxPage *np = Get_Tmp_Node();
	unsigned char *pn = (unsigned char*) np + IDX_LEAF_OFFS;
	unsigned char *kn = (unsigned char*) np + IDX_PAGE_SIZE;
	unsigned char *po = (unsigned char*) pp + IDX_LEAF_OFFS;
	unsigned char *ko = (unsigned char*) pp + IDX_PAGE_SIZE;
	unsigned char *buf = (unsigned char*) malloc(ip->len);
	IdxBucket bp;
	long rmkey, i, klen = 0, dup;

	memset(pn, 0, IDX_PAGE_SIZE);
	memcpy(pn, pp, IDX_LEAF_OFFS);
	dbf_put_ushort(np->count, count - 1);

	idx_get_bucket(pp, &bp, po);
	if (!no && bp.trail == ip->len)
	{
		klen = (count - 1) * pp->keybytes;
		memcpy(pn, po + pp->keybytes, klen);
		pn += klen;
		memset(pn, 0, pp->keybytes);
		dbf_put_ushort(np->free, dbf_get_ushort(pp->free) + pp->keybytes);
		memcpy(pp, node, IDX_PAGE_SIZE);
		return 0;
	}

//seek key
	for ( i = 0; i <= no; i++ )
	{
		idx_get_bucket(pp, &bp, po);
		klen = ip->len - bp.dup - bp.trail;
		ko -= klen;
		memcpy(buf + bp.dup, ko, klen);
		po += pp->keybytes;
	}
	memset(buf + klen + bp.dup, 32, bp.trail);
	ko += klen;
	rmkey = klen;
	pn += no * pp->keybytes;
	klen = (unsigned char*)pp + IDX_PAGE_SIZE - ko;
	kn -= klen;
	memcpy(kn, ko, klen);

// if removed last key of node
	if ( no == count )
	{
		rmkey = ko + rmkey - po;
		memset(pn, 0, rmkey);
		dbf_put_ushort(np->free, rmkey);

		memcpy(pp, np, IDX_PAGE_SIZE);

		return 0;
	}

//get_next_key
	dup = bp.dup;
	idx_get_bucket(pp, &bp, po);
	klen = ip->len - bp.dup - bp.trail;
	memcpy(buf + bp.dup, ko - klen - rmkey, klen);
	memset(buf + klen + bp.dup, 32, bp.trail);
	po += pp->keybytes;

// insert modifyed next key
	if ( dup < bp.dup )
	{
		rmkey -= bp.dup - dup;
		bp.dup = dup;
	}
	idx_put_bucket(np, &bp, pn);
	pn += pp->keybytes;
	klen = ip->len - bp.dup - bp.trail; // new size of compressed key
	kn -= rmkey;
	memcpy(kn, buf + bp.dup, klen);

//copy old keys
	klen = pp->keybytes * (count - i);
	memcpy(pn, po, klen);
	pn += klen;
	po += dbf_get_ushort(pp->free) + klen;
	klen = ko - po;
	kn -= klen;
	memcpy(kn, ko - klen, klen);
	dbf_put_ushort(np->free, kn - pn);

	memcpy(pp, np, IDX_PAGE_SIZE);
	Free_Tmp_Node(np);
	free(buf);

	return 0;
}

static int
idx_del_key(struct DbfFile *fp, DbfIndex *ip, IdxStack *stack, int *level)
{
	long page = stack[*level].pageoffs;
	IdxPage *pp = idx_get_page(ip, page);

	if ( dbf_get_ushort(pp->count) == 1 )
		return idx_put_free_node(fp, ip, page);
	else
		return idx_remove_key(ip, pp, stack[*level].buckno);
}

static int
idx_del(struct DbfFile *fp, DbfIndex *ip, Tuple *tp)
{
	IdxStack stack[IDX_DEEP];
	int level, r = 0, r1;

	if ((r = dbf_wlock(fp, ip->mp, 0)))
		return r;

	tp->ok = 0;
	r = idx_search_tree(fp, ip, tp, stack, &level);
	if (r)
		return r;

	if (tp->ok)
	{
		tp->ok = 1;
		r = idx_del_key(fp, ip, stack, &level);
	}

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

/* ] IDX */
