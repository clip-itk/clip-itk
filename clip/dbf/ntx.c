/*
$Log: ntx.c,v $
Revision 1.9  2000/05/01 18:54:41  clip
fix error delkey in indexes

Revision 1.8  2000/03/24 21:45:44  axl
small fix in seek_ntx

Revision 1.7  2000/03/24 21:12:48  axl
fix bug in seek_ntx (soft seek)

Revision 1.6  2000/03/14 00:06:48  axl
fix SEEK, make allign in ntxdump

Revision 1.5  2000/03/07 20:29:11  axl
Fix bug in indexes (seek)

Revision 1.4  2000/02/13 00:20:33  axl
fix skip in ntx

Revision 1.3  2000/02/11 20:19:00  axl
fix softseek in ntx, creating of idx

Revision 1.2  1999/10/26 19:19:16  axl
start cvs logging (./dbf)

*/


#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

#include "dbfpriv.h"
#include "ntx.h"

typedef struct
{
	long pageoffs;
	int buckno;
}
NtxStack;

/* max deep of NTX btree */
#define NTX_DEEP 64

static int destroy_ntx(struct DbfFile *fp, DbfIndex * ip);
static int create_ntx(struct DbfFile *fp, DbfIndex * ip);
static int open_ntx(struct DbfFile *fp, DbfIndex * ip);
static int addkey_ntx(struct DbfFile *fp, DbfIndex * ip, Tuple * tp);
static int delkey_ntx(struct DbfFile *fp, DbfIndex * ip, Tuple * tp);
static int seek_ntx(struct DbfFile *fp, DbfIndex * ip, Tuple * tp);

static int first_ntx(struct DbfFile *fp, DbfIndex * ip);
static int last_ntx(struct DbfFile *fp, DbfIndex * ip);
static int next_ntx(struct DbfFile *fp, DbfIndex * ip);
static int prev_ntx(struct DbfFile *fp, DbfIndex * ip);
static int bprev_ntx(struct DbfFile *fp, DbfIndex * ip);

static int zap_ntx(struct DbfFile *fp, DbfIndex * ip);

static NtxHeader *get_ntx_header(DbfIndex * ip);
static int last_node(struct DbfFile *fp, DbfIndex * ip, long root);
static int first_node(struct DbfFile *fp, DbfIndex * ip, long root);

DbfIndexVtbl ntxVtbl =
{
	"ntx",

	".ntx",
	destroy_ntx,

	create_ntx,
	open_ntx,
	zap_ntx,

	delkey_ntx,
	addkey_ntx,

	first_ntx,
	last_ntx,
	prev_ntx,
	next_ntx,

	seek_ntx,
};

static int split_ntx_node(struct DbfFile *fp, DbfIndex * ip, Tuple * tp, NtxStack * stack, int *level);
static int add_ntx_node(struct DbfFile *fp, DbfIndex * ip, Tuple * tp, NtxStack * stack, int *level);
static int del_node(struct DbfFile *fp, DbfIndex * ip, NtxStack * stack, int *level);
static int init_ntx_page(DbfIndex * ip, long page, long rchield);

/* [ NTX */

static int
ntx_merror(struct DbfFile *fp, struct MapFile *mp, int line)
{
	int l;

	snprintf(fp->errbuf, ERRBUFSIZE, "NTX: %s, line %d: ", __FILE__, line);
	l = strlen(fp->errbuf);
	getError_MapFile(mp, fp->errbuf + l, ERRBUFSIZE - l);
	return 1;
}

static int
ntx_error(struct DbfFile *fp, int line, const char *fmt,...)
{
	int l;
	va_list ap;

	va_start(ap, fmt);
	snprintf(fp->errbuf, ERRBUFSIZE, "NTX: %s, line %d: ", __FILE__, line);
	l = strlen(fp->errbuf);
	vsnprintf(fp->errbuf + l, ERRBUFSIZE - l, fmt, ap);
	va_end(ap);
	return 1;
}

static NtxPage *
get_ntx_page(DbfIndex * ip, long pageoffs)
{
	return (NtxPage *) (getMap_MapFile(ip->mp) + pageoffs);
}

static int
create_ntx(struct DbfFile *fp, DbfIndex * ip)
{
	struct MapFile *mp;
	NtxHeader *hp;
	long recno;
	int r = 0;

	mp = create_MapFile(ip->filename, 1024, 1024, fp->errbuf, ERRBUFSIZE);
	if (!mp)
		return 1;

	if ((r = dbf_wlock(fp, mp, 0)))
	{
	      err:
		ntx_merror(fp, mp, __LINE__);
		close_MapFile(mp);
		return r;
	}
	hp = (NtxHeader *) getHeader_MapFile(mp);

	/*ip->max_items = (((1024 - 2 - (2 * 4 + 2)) / (ip->len + 2 * 4 + 2)) / 2) * 2; */
	ip->max_items = ((((1024 - 2) / (ip->len + 2 * 4 + 2)) - 1) / 2) * 2;
	ip->half_page = ip->max_items / 2;

	dbf_put_ushort(hp->signature, 6);
	dbf_put_ushort(hp->version, 1);
	dbf_put_long(hp->root, 1024);
	dbf_put_long(hp->empty, 0);
	dbf_put_ushort(hp->item_size, ip->len + 2 * 4);
	dbf_put_ushort(hp->key_size, ip->len);
	dbf_put_ushort(hp->key_dec, ip->dec);
	dbf_put_ushort(hp->max_items, ip->max_items);
	dbf_put_ushort(hp->half_page, ip->half_page);
	strncpy(hp->key_expr, ip->expr, 255);
	hp->unique = (ip->unique ? 1 : 0);

	if ((r = incr_MapFile(mp, &recno, 1, 0)))
		goto err;

	ip->mp = mp;
	init_ntx_page(ip, 1024, 0);

	r = dbf_ulock(fp, mp, 0);

	return r;
}

static int
zap_ntx(struct DbfFile *fp, DbfIndex * ip)
{
	NtxHeader *hp;
	int r = 0, r1;

	if ((r = dbf_wlock(fp, ip->mp, 0)))
		return r;

	hp = get_ntx_header(ip);
	dbf_put_long(hp->root, 1024);
	dbf_put_long(hp->empty, 0);

	init_ntx_page(ip, 1024, 0);
	if ((r = decr_MapFile(ip->mp, 1)))
		ntx_merror(fp, ip->mp, __LINE__);

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
destroy_ntx(struct DbfFile *fp, DbfIndex * ip)
{
	return 0;
}

static int
open_ntx(struct DbfFile *fp, DbfIndex * ip)
{
	struct MapFile *mp;
	NtxHeader *hp;
	int r = 0;

	mp = open_MapFile(ip->filename, 1024, !fp->readonly, fp->errbuf, ERRBUFSIZE);
	if (!mp)
		return 1;

	setRecSize_MapFile(mp, 1024);

	if ((r = dbf_rlock(fp, mp, 0)))
	{
		ntx_merror(fp, mp, __LINE__);
		close_MapFile(mp);
		return r;
	}

	hp = (NtxHeader *) getHeader_MapFile(mp);
	ip->max_items = dbf_get_ushort(hp->max_items);
	ip->half_page = dbf_get_ushort(hp->half_page);
	ip->expr = strdup(hp->key_expr);
	ip->len = dbf_get_ushort(hp->key_size);
	ip->dec = dbf_get_ushort(hp->key_dec);
	ip->unique = hp->unique;

	r = dbf_ulock(fp, mp, 0);

	ip->mp = mp;

	return r;
}

static NtxHeader *
get_ntx_header(DbfIndex * ip)
{
	return (NtxHeader *) getHeader_MapFile(ip->mp);
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

static NtxBucket *
get_ntx_bucket(NtxPage * pp, int no)
{
	int boffs = dbf_get_ushort(pp->ref + no * 2);
	NtxBucket *bp = (NtxBucket *) (((char *) pp) + boffs);

	return bp;
}

static int
search_ntx_bucket(struct DbfFile *fp, DbfIndex * ip, NtxPage * pp, Tuple * tp, int *no)
{
	int l, h, i = 0, c = 0;
	int count;
	NtxBucket *bp;

	count = dbf_get_ushort(pp->count);

	l = 0;
	h = count - 1;
	while (l <= h)
	{
		i = (l + h) / 2;
		bp = get_ntx_bucket(pp, i);
		c = compare_key(ip->unique, bp->key, ip->len, dbf_get_long(bp->record), tp->key, tp->len, tp->value);
		if (c < 0)
			l = i + 1;
		else if (c > 0)
			h = i - 1;
		else
		{
			while (!c && i--)
			{
				bp = get_ntx_bucket(pp, i);
				c = compare_key(ip->unique, bp->key, ip->len, dbf_get_long(bp->record), tp->key, tp->len, tp->value);
			}
			*no = i+1;
			return 1;
		}
	}

	if (c < 0)
		i++;
	*no = i;

	return 0;
}

static void
set_ntx_key(DbfIndex * ip, NtxBucket * bp, Tuple * tp)
{
	//int n = tp->size - 1;
	int n = tp->size;

	if (ip->len < n)
		n = ip->len;

	memcpy(tp->key, bp->key, n);
	//tp->key[n] = 0;
	tp->len = n;

	tp->value = dbf_get_long(bp->record);
}

static int
search_ntx_tree(struct DbfFile *fp, DbfIndex * ip, Tuple * tp, NtxStack * stack, int *level)
{
	NtxPage *pp;
	NtxBucket *bp;
	int r, no;
	long offs = stack[*level].pageoffs;

	pp = get_ntx_page(ip, offs);

	r = search_ntx_bucket(fp, ip, pp, tp, &no);

	if (r)
	{
		bp = get_ntx_bucket(pp, no);
		set_ntx_key(ip, bp, tp);
		stack[*level].buckno = no;
		tp->ok = 1;
		return 0;
	}

	bp = get_ntx_bucket(pp, no);

	stack[*level].buckno = no;

	offs = dbf_get_long(bp->page);
	if (!offs)
	{
		int count;

		count = dbf_get_ushort(pp->count);
		if (no == count)
		{
		/*
			if (!(*level))
			{
		*/
				tp->value = ip->keypos = DBF_EOF_POS;
				memset(tp->key, 0xff, ip->len);
				tp->len = ip->len;
		/*
			}
			else
				no = -1;
		*/
		}
		else
			set_ntx_key(ip, bp, tp);

		stack[*level].buckno = no;
		tp->ok = 0;
		return 0;
	}

	(*level)++;
	if (*level >= NTX_DEEP)
		return ntx_error(fp, __LINE__, "NTX btree too deep: %d", *level);

	stack[*level].pageoffs = offs;

	r = search_ntx_tree(fp, ip, tp, stack, level);
/*
	if( stack[*level].buckno == -1 )
	{
		(*level)--;
		set_ntx_key(ip, bp, tp);
		//pp = get_ntx_page(ip, stack[*level].pageoffs);
		//stack[*level].buckno = dbf_get_ushort(pp->count);
		tp->ok = 0;
		return 0;
	}
*/
	return r;
}

static int
seek_ntx(struct DbfFile *fp, DbfIndex * ip, Tuple * tp)
{
	NtxHeader *hp;
	NtxStack stack[NTX_DEEP];
	int level = 0, r = 0, r1;

	if ((r = dbf_rlock(fp, ip->mp, 0)))
		return r;

	hp = get_ntx_header(ip);
	stack[0].pageoffs = dbf_get_long(hp->root);

	r = search_ntx_tree(fp, ip, tp, stack, &level);

	if (!hp->unique && !r && tp->ok)
	{
#if 1
		long lpos;

		ip->keypos = tp->value;
		memcpy(ip->keybuf, tp->key, ip->len);
		for(;;)
		{
			lpos = ip->keypos;
			if (lpos <0)
				break;
			r = bprev_ntx(fp, ip);
			if (r)
				break;
			if (memcmp(tp->key, ip->keybuf, fp->keylen))
			{
				next_ntx(fp, ip);
				tp->value = lpos;
				memcpy(tp->key, ip->keybuf, ip->len);
				break;
			}
		}
#else
		long page, lpage, lpos;
		int buckno, lbuckno;
		int nextf = 0;
		unsigned short count;
		NtxPage *pp;
		NtxBucket *bp;

		ip->keypos = tp->value;
		memcpy(ip->keybuf, tp->key, ip->len);
	      next:
		lpage = page = stack[level].pageoffs;
		lbuckno = buckno = stack[level].buckno;
		lpos = ip->keypos;

		if (!page)
		{
		      bof_l:
			/*ip->keypos = DBF_BOF_POS;
			   memset(ip->keybuf, 0xff, ip->len); */
		}
		else
		{
			pp = get_ntx_page(ip, page);
			count = dbf_get_ushort(pp->count);

			bp = get_ntx_bucket(pp, buckno);
			page = dbf_get_long(bp->page);

			if (!nextf && page)
			{
				last_node(fp, ip, page);
				if (!memcmp(tp->key, ip->keybuf, ip->len))
					first_node(fp, ip, page);
				else
					ip->keypos = tp->value = lpos;
			}
			else
			{
				/*printf("ntx: skip back 0\n"); */
				if (!buckno)
				{
					--level;
					if (level < 0)
						goto bof_l;
					nextf = 1;
					goto next;
				}
				--buckno;
				bp = get_ntx_bucket(pp, buckno);
				page = dbf_get_long(bp->page);

				if (page)
				{
					last_node(fp, ip, page);
					if (!memcmp(tp->key, ip->keybuf, ip->len))
						first_node(fp, ip, page);
					else
						ip->keypos = tp->value = lpos;
				}
				else
				{
					/*printf("ntx: skip back 1\n"); */
					ip->keypos = dbf_get_long(bp->record);
					/*printf("ipkey: %.*s\n", ip->len, tp->key);
					   printf("bpkey: %.*s\n", ip->len, bp->key); */
					if (!memcmp(tp->key, bp->key, ip->len))
					{
						/*printf("ntx: pos=%ld lpos=%ld\n", ip->keypos, lpos); */
						stack[level].buckno = buckno;
						goto next;
					}
					ip->keypos = tp->value = lpos;
				}
			}
		}
#endif
	}
/**/
	else if ( !r && !tp->ok )
	{
		NtxPage *pp = get_ntx_page(ip, stack[level].pageoffs);
		int no = stack[level].buckno;
		if( no == dbf_get_ushort(pp->count) )
		{
			level--;
			while( level && no == dbf_get_ushort(pp->count) )
			{
				pp = get_ntx_page(ip, stack[level].pageoffs);
				no = stack[level].buckno;
				level--;
			}
			if( level < 0 )
			{
				ip->keypos = DBF_EOF_POS;
				memset(ip->keybuf, 0xff, ip->len);
			}
			else
			{
				NtxBucket *bp = get_ntx_bucket(pp, no);
				set_ntx_key(ip, bp, tp);
			}
		}
	}
/**/
	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
first_node(struct DbfFile *fp, DbfIndex * ip, long root)
{
	NtxPage *pp;
	NtxBucket *bp;
	long left;
	int count;

	if (!root)
		goto bof_l;

	pp = get_ntx_page(ip, root);
	bp = get_ntx_bucket(pp, 0);

	left = dbf_get_long(bp->page);
	if (left)
		return first_node(fp, ip, left);

	count = dbf_get_ushort(pp->count);
	if (count)
	{
		memcpy(ip->keybuf, bp->key, ip->len);
		ip->keypos = dbf_get_long(bp->record);
	}
	else
	{
	      bof_l:
		memset(ip->keybuf, 0, ip->len);
		ip->keypos = DBF_EOF_POS;
	}
	return 0;
}

static int
first_ntx(struct DbfFile *fp, DbfIndex * ip)
{
	int r = 0, r1;
	NtxHeader *hp;
	long root;

	if ((r = dbf_rlock(fp, ip->mp, 0)))
		return r;

	hp = get_ntx_header(ip);
	root = dbf_get_long(hp->root);

	r = first_node(fp, ip, root);

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
last_node(struct DbfFile *fp, DbfIndex * ip, long root)
{
	NtxPage *pp;
	NtxBucket *bp;
	long right;
	int count;

	if (!root)
		goto eof_l;

	pp = get_ntx_page(ip, root);
	count = dbf_get_ushort(pp->count);
	bp = get_ntx_bucket(pp, count);

	right = dbf_get_long(bp->page);
	if (right)
		return last_node(fp, ip, right);

	if (count)
	{
		bp = get_ntx_bucket(pp, count - 1);
		memcpy(ip->keybuf, bp->key, ip->len);
		ip->keypos = dbf_get_long(bp->record);
	}
	else
	{
	      eof_l:
		memset(ip->keybuf, 0xff, ip->len);
		ip->keypos = DBF_BOF_POS;
	}
	return 0;
}

static int
last_ntx(struct DbfFile *fp, DbfIndex * ip)
{
	int r = 0, r1;
	NtxHeader *hp;
	long root;

	if ((r = dbf_rlock(fp, ip->mp, 0)))
		return r;

	hp = get_ntx_header(ip);
	root = dbf_get_long(hp->root);

	r = last_node(fp, ip, root);

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
next_ntx(struct DbfFile *fp, DbfIndex * ip)
{
	Tuple tup;
	NtxStack stack[NTX_DEEP];
	int level = 0, r = 0, r1, nextf = 0;
	NtxPage *pp;
	long page;
	int buckno, count;
	NtxBucket *bp;
	NtxHeader *hp;

	if ((r = dbf_rlock(fp, ip->mp, 0)))
		return r;

	memset(&tup, 0, sizeof(tup));
	tup.key = ip->keybuf;
	tup.len = tup.size = ip->len;
	tup.value = ip->keypos;

	hp = get_ntx_header(ip);
	stack[0].pageoffs = dbf_get_long(hp->root);

	if ((r = search_ntx_tree(fp, ip, &tup, stack, &level)))
		return r;

      next:
	page = stack[level].pageoffs;
	buckno = stack[level].buckno;

	if (!page)
	{
	      eof_l:
		ip->keypos = DBF_EOF_POS;
		memset(ip->keybuf, 0xff, ip->len);
	}
	else
	{
		pp = get_ntx_page(ip, page);
		count = dbf_get_ushort(pp->count);

		if (!nextf)
			++buckno;
		if (buckno > count)
		{
		      up:if (level < 1)
				goto eof_l;
			else
			{
				--level;
				nextf = 1;
				goto next;
			}
		}

		bp = get_ntx_bucket(pp, buckno);
		page = dbf_get_long(bp->page);
		if (!nextf && page)
			first_node(fp, ip, page);
		else if (buckno < count)
		{
			ip->keypos = dbf_get_long(bp->record);
			memcpy(ip->keybuf, bp->key, ip->len);
		}
		else
			goto up;
	}

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
prev_ntx(struct DbfFile *fp, DbfIndex * ip)
{
	int r, r1;

	if ((r = dbf_rlock(fp, ip->mp, 0)))
		return r;

	r = bprev_ntx(fp, ip);
	if (r)
		return r;

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
bprev_ntx(struct DbfFile *fp, DbfIndex * ip)
{
	Tuple tup;
	NtxStack stack[NTX_DEEP];
	int level = 0, r = 0;
	NtxPage *pp;
	long page;
	int buckno, count;
	NtxBucket *bp;
	NtxHeader *hp;
	int nextf = 0;

	memset(&tup, 0, sizeof(tup));
	tup.key = ip->keybuf;
	tup.len = tup.size = ip->len;
	tup.value = ip->keypos;

	hp = get_ntx_header(ip);
	stack[0].pageoffs = dbf_get_long(hp->root);

	if ((r = search_ntx_tree(fp, ip, &tup, stack, &level)))
		return r;
      next:
	page = stack[level].pageoffs;
	buckno = stack[level].buckno;

	if (!page)
	{
	      bof_l:
		ip->keypos = DBF_BOF_POS;
		memset(ip->keybuf, 0xff, ip->len);
	}
	else
	{
		pp = get_ntx_page(ip, page);
		count = dbf_get_ushort(pp->count);

		bp = get_ntx_bucket(pp, buckno);
		page = dbf_get_long(bp->page);

		if (!nextf && page)
			last_node(fp, ip, page);
		else
		{
			if (!buckno)
			{
				--level;
				if (level < 0)
					goto bof_l;
				nextf = 1;
				goto next;
			}
			--buckno;
			bp = get_ntx_bucket(pp, buckno);
			page = dbf_get_long(bp->page);

			if (!nextf && page)
				last_node(fp, ip, page);
			else
			{
				ip->keypos = dbf_get_long(bp->record);
				memcpy(ip->keybuf, bp->key, ip->len);
			}
		}
	}

	return r;
}

static int
put_ntx_node(DbfIndex * ip, NtxPage * pp, int buckno, Tuple * tp)
{
	int count = dbf_get_ushort(pp->count);
	NtxBucket *bp;
	char *basep = (char *) pp;
	int offs, boffs = dbf_get_ushort(pp->ref + (count + 1) * 2);

	offs = 2 + buckno * 2;
	memmove(basep + offs + 2, basep + offs, (count + 1 - buckno) * 2);
	dbf_put_ushort(basep + offs, boffs);

	bp = (NtxBucket *) (basep + boffs);
	dbf_put_long(bp->page, tp->chield);
	dbf_put_long(bp->record, tp->value);
	if (buckno <= count)
		memcpy(bp->key, tp->key, tp->len);

	dbf_put_ushort(pp->count, count + 1);
	return 0;
}

static int
get_free_page(struct DbfFile *fp, DbfIndex * ip, long *page)
{
	long freePage;
	NtxHeader *hp = get_ntx_header(ip);

	freePage = dbf_get_long(hp->empty);
	if (!freePage)
	{
		long i, recno;
		int r;

		long delta = (mapLen_MapFile(ip->mp) / 1024 - 1) / 5;

		if (delta < 1)
			delta = 1;
		if ((r = incr_MapFile(ip->mp, &recno, delta, 0)))
			return r;

		hp = get_ntx_header(ip);

		if (delta > 1)
		{
			dbf_put_long(hp->empty, (recno + 1) * 1024 + 1024);
			for (i = 1; i < delta; ++i)
			{
				NtxFreePage *fhp = (NtxFreePage *) getRec_MapFile(ip->mp, recno + i);

				if (i < delta - 1)
					dbf_put_long(fhp->next, (recno + i + 1) * 1024 + 1024);
				else
					dbf_put_long(fhp->next, 0);
			}
		}
		*page = recno * 1024 + 1024;
	}
	else
	{
		*page = freePage;
		freePage = dbf_get_long(((NtxFreePage *) (getMap_MapFile(ip->mp) + freePage))->next);
		dbf_put_long(hp->empty, freePage);
	}

	/*init_ntx_page(ip, *page,0); */

	return 0;
}

static int
init_ntx_page(DbfIndex * ip, long page, long rchield)
{
	NtxPage *pp;
	NtxBucket *bp;
	unsigned short offs = 2 * (ip->max_items + 2);
	int i, m, size;

	m = ip->max_items;
	size = ip->len + 8;
	pp = get_ntx_page(ip, page);
	memset(pp, 0, 1024);
	dbf_put_ushort(pp->count, 0);
	/* dbf_put_ushort(pp->ref, offs); */

	bp = (NtxBucket *) (((char *) pp) + offs);
	dbf_put_long(bp->page, rchield);
	dbf_put_long(bp->record, 0);

	for (i = 0; i <= m; ++i, offs += size)
		dbf_put_ushort(pp->ref + i * 2, offs);

	return 0;
}

static int
put_free_page(struct DbfFile *fp, DbfIndex * ip, long page)
{
	NtxFreePage *fhp;
	NtxHeader *hp = get_ntx_header(ip);
	long freePage = dbf_get_long(hp->empty);

	fhp = (NtxFreePage *) (getMap_MapFile(ip->mp) + page);
	dbf_put_long(fhp->next, freePage);
	dbf_put_long(hp->empty, page);

	return 0;
}

static int
split_ntx_node(struct DbfFile *fp, DbfIndex * ip, Tuple * tp, NtxStack * stack, int *level)
{
	NtxPage *pp, *lpp, *rpp;
	int r = 0, count, mediane, i, j;
	long lnode, rchield;
	long rnode = stack[*level].pageoffs;
	int buckno = stack[*level].buckno;
	char *pbuf = (char *) malloc(1024);
	Tuple tup, mtup;
	NtxBucket *bp;

	if ((r = get_free_page(fp, ip, &lnode)))
		goto ret;

	rpp = get_ntx_page(ip, rnode);
	memcpy(pbuf, rpp, 1024);

	pp = (NtxPage *) pbuf;
	count = dbf_get_ushort(pp->count);
	mediane = count / 2;

	lpp = get_ntx_page(ip, lnode);

	if (buckno == mediane)
	{
		tup = *tp;
		rchield = tp->chield;
	}
	else
	{
		bp = get_ntx_bucket(pp, mediane);
		tup.len = ip->len;
		tup.size = ip->len;
		tup.key = dbf_mem_dup(bp->key, tup.len);
		tup.freemem = 1;
		tup.ok = 0;
		tup.value = dbf_get_long(bp->record);
		rchield = dbf_get_long(bp->page);
	}

	tup.chield = lnode;

	bp = get_ntx_bucket(pp, count);
	init_ntx_page(ip, rnode, dbf_get_long(bp->page));
	init_ntx_page(ip, lnode, rchield);

	memset(&mtup, 0, sizeof(mtup));
	mtup.len = ip->len;

	for (i = 0, j = 0; i < mediane; ++i, ++j)
	{
		if (i == buckno)
			put_ntx_node(ip, lpp, j++, tp);
		bp = get_ntx_bucket(pp, i);
		mtup.value = dbf_get_long(bp->record);
		mtup.chield = dbf_get_long(bp->page);
		mtup.key = bp->key;
		put_ntx_node(ip, lpp, j, &mtup);
	}
	j=0;
	if (buckno == mediane)
	{
		bp = get_ntx_bucket(pp, mediane);
		mtup.value = dbf_get_long(bp->record);
		mtup.chield = dbf_get_long(bp->page);
		mtup.key = bp->key;
		put_ntx_node(ip, rpp, j++, &mtup);
	}
	for (i = mediane + 1; i < count; ++i, ++j)
	{
		if (i == buckno)
			put_ntx_node(ip, rpp, j++, tp);
		bp = get_ntx_bucket(pp, i);
		mtup.value = dbf_get_long(bp->record);
		mtup.chield = dbf_get_long(bp->page);
		mtup.key = bp->key;
		put_ntx_node(ip, rpp, j, &mtup);
	}

	if (buckno == count)
		put_ntx_node(ip, rpp, j, tp);

	if (*level < 1)
	{
		/* add root node */
		long root;
		NtxHeader *hp;

		if ((r = get_free_page(fp, ip, &root)))
			goto ret;
		init_ntx_page(ip, root, rnode);
		stack[0].pageoffs = root;
		stack[0].buckno = 0;
		r = add_ntx_node(fp, ip, &tup, stack, level);

		hp = get_ntx_header(ip);
		dbf_put_long(hp->root, root);
	}
	else
	{
		--(*level);
		r = add_ntx_node(fp, ip, &tup, stack, level);
	}

      ret:
	free(pbuf);
	if (tup.freemem && tup.key != tp->key)
		free(tup.key);

	return r;
}

static int
add_ntx_node(struct DbfFile *fp, DbfIndex * ip, Tuple * tp, NtxStack * stack, int *level)
{
	NtxPage *pp;
	int r = 0, no, count;
	long offs = stack[*level].pageoffs;

	pp = get_ntx_page(ip, offs);
	count = dbf_get_ushort(pp->count);
	no = stack[*level].buckno;

	if (count < ip->max_items)
		r = put_ntx_node(ip, pp, no, tp);
	else
		r = split_ntx_node(fp, ip, tp, stack, level);

	return r;
}

static int
addkey_ntx(struct DbfFile *fp, DbfIndex * ip, Tuple * tp)
{
	NtxHeader *hp;
	NtxStack stack[NTX_DEEP];
	int level = 0, r = 0, r1;
	Tuple tup;

	if ((r = dbf_wlock(fp, ip->mp, 0)))
		return r;

	hp = get_ntx_header(ip);
	stack[0].pageoffs = dbf_get_long(hp->root);

	tp->ok = 0;
	memset(&tup, 0, sizeof(tup));
	tup.key = strdup(tp->key);
	tup.len = tp->len;
	tup.size = tp->len;
	tup.value = tp->value;
	tup.ok = 1;

	r = search_ntx_tree(fp, ip, tp, stack, &level);
	if (r)
	{
		free(tup.key);
		return r;
	}

	if (tp->ok)
	{
		if (ip->unique)
			r = ntx_error(fp, __LINE__, "addkey: duplication key-value pair: tag '%s' key '%s' value '%ld'",
				      ip->tag, tp->key, tp->value);
	}
	else
	{
		tp->ok = 1;
		r = add_ntx_node(fp, ip, &tup, /*tp, */ stack, &level);
	}

	memcpy(tp->key, tup.key, tup.len);
	tp->value=tup.value;
	free(tup.key);
	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

static int
remove_ntx_node(DbfIndex * ip, NtxPage * pp, int buckno)
{
	int count = dbf_get_ushort(pp->count);
	char *basep = (char *) pp;
	int offs, boffs = dbf_get_ushort(pp->ref + buckno * 2);

	offs = 2 + buckno * 2;
	memmove(basep + offs, basep + offs + 2, (count - buckno) * 2);
	dbf_put_ushort(basep + 2 + count * 2, boffs);

	dbf_put_ushort(pp->count, count - 1);
	return 0;
}

static int
balance_node(struct DbfFile *fp, DbfIndex * ip, NtxStack * stack, int *level)
{
	NtxPage *pp, *upp, *rpp, *tpp;
	int count, uno, ucount, rno, rcount, tno;
	long page, upage, rpage, right, tpage;
	NtxBucket *bp, *ubp, *rbp, *tbp;

	page = stack[*level].pageoffs;
	pp = get_ntx_page(ip, page);
	count = dbf_get_ushort(pp->count);

	if (*level < 1)
		return 0;
	if (count >= ip->half_page)
		return 0;

	upage = stack[*level - 1].pageoffs;
	uno = stack[*level - 1].buckno;
	upp = get_ntx_page(ip, upage);
	ucount = dbf_get_ushort(upp->count);
	ubp = get_ntx_bucket(upp, ucount);
	right = dbf_get_long(ubp->page);

	if (ucount < 1 && !right)	/* last page in this level */
	{
		int i;

		dbf_put_long(ubp->page, 0);
		for (i = 0; i < count; ++i)
		{
			Tuple tup;

			memset(&tup, 0, sizeof(tup));
			bp = get_ntx_bucket(pp, i);
			tup.key = bp->key;
			tup.value = dbf_get_long(bp->record);
			put_ntx_node(ip, upp, i, &tup);
		}

		put_free_page(fp, ip, page);
		return 0;
	}

	if (uno > 0)
		rno = uno - 1;
	else if (uno < ucount - 1)
		rno = uno + 1;
	else if (uno < ucount && right)
		rno = ucount;
	else
		return ntx_error(fp, __LINE__, "invalid NTX BTREE node");

	rbp = get_ntx_bucket(upp, rno);
	rpage = dbf_get_long(rbp->page);

	rpp = get_ntx_page(ip, rpage);
	rcount = dbf_get_ushort(rpp->count);

	if (uno > rno)
	{
		/* swap pointers */
		tpage = rpage;
		rpage = page;
		page = tpage;

		tpp = rpp;
		rpp = pp;
		pp = tpp;

		tno = rno;
		rno = uno;
		uno = tno;

		tno = rcount;
		rcount = count;
		count = tno;

		tbp = rbp;
		rbp = ubp;
		ubp = tbp;
	}

	if (count + rcount < ip->max_items)
	{
		/* join pages */
		int i, j, sum;
		Tuple tup;
		NtxBucket *bp;

		sum = count + rcount + 1;

		dbf_put_long(rbp->page, page);

		memset(&tup, 0, sizeof(tup));
		bp = get_ntx_bucket(pp, count);

		tup.key = ubp->key;
		tup.value = dbf_get_long(ubp->record);
		tup.chield = dbf_get_long(bp->page);

		put_ntx_node(ip, pp, count, &tup);

		for (i = count + 1, j = 0; i <= sum; ++i, ++j)
		{
			bp = get_ntx_bucket(rpp, j);
			tup.key = bp->key;
			tup.value = dbf_get_long(bp->record);
			tup.chield = dbf_get_long(bp->page);
			put_ntx_node(ip, pp, i, &tup);
		}

		remove_ntx_node(ip, upp, uno);
		put_free_page(fp, ip, rpage);
	}
	else
	{
		/* balance pages */
		int i, j, sum, mediane;
		Tuple tup;
		NtxBucket *bp;

		sum = count + rcount;
		mediane = sum / 2;
		memset(&tup, 0, sizeof(tup));

		if (mediane < count)
		{
			/* move from pp to rpp */

			bp = get_ntx_bucket(pp, count);
			tup.key = ubp->key;
			tup.value = dbf_get_long(ubp->record);
			tup.chield = dbf_get_long(bp->page);
			put_ntx_node(ip, rpp, 0, &tup);

			for (i = count - 1; i > mediane; --i)
			{
				bp = get_ntx_bucket(pp, i);
				tup.key = bp->key;
				tup.value = dbf_get_long(bp->record);
				tup.chield = dbf_get_long(bp->page);
				put_ntx_node(ip, rpp, 0, &tup);
			}

			bp = get_ntx_bucket(pp, mediane);
			memcpy(ubp->key, bp->key, ip->len);
			dbf_put_long(ubp->record, dbf_get_long(bp->record));

			for (i = count; i > mediane; --i)
				remove_ntx_node(ip, pp, i);
		}
		else if (mediane > count)
		{
			/* move from rpp to pp */

			bp = get_ntx_bucket(pp, count);
			memcpy(bp->key, ubp->key, ip->len);
			dbf_put_long(bp->record, dbf_get_long(ubp->record));

			for (i = count + 1, j = 0; i < mediane; ++i, ++j)
			{
				bp = get_ntx_bucket(rpp, j);
				tup.key = bp->key;
				tup.value = dbf_get_long(bp->record);
				tup.chield = dbf_get_long(bp->page);
				put_ntx_node(ip, pp, i, &tup);
			}

			bp = get_ntx_bucket(rpp, mediane);
			memcpy(ubp->key, bp->key, ip->len);

			for (i = count + 1, j = 0; i <= mediane; ++i, ++j)
				remove_ntx_node(ip, rpp, j);
		}
	}

	--(*level);

	return balance_node(fp, ip, stack, level);
}

static int
find_last(struct DbfFile *fp, DbfIndex * ip, NtxStack * stack, int *level)
{
	NtxPage *pp;
	NtxBucket *bp;
	long right;
	int count;
	long page = stack[*level].pageoffs;

	pp = get_ntx_page(ip, page);
	count = dbf_get_ushort(pp->count);
	bp = get_ntx_bucket(pp, count);
	right = dbf_get_long(bp->page);

	if (right)
	{
		stack[*level].buckno = count;
		(*level)++;
		if (*level >= NTX_DEEP)
			return ntx_error(fp, __LINE__, "NTX btree too deep: %d", *level);
		stack[*level].pageoffs = right;
		return find_last(fp, ip, stack, level);
	}

	stack[*level].buckno = count - 1;
	return 0;
}

static int
del_node(struct DbfFile *fp, DbfIndex * ip, NtxStack * stack, int *level)
{
	NtxPage *pp;
	int r = 0, no, count;
	long page = stack[*level].pageoffs;
	long chield;
	NtxBucket *bp;

	pp = get_ntx_page(ip, page);
	count = dbf_get_ushort(pp->count);
	no = stack[*level].buckno;
	bp = get_ntx_bucket(pp, no);
	chield = dbf_get_long(bp->page);

	if (chield)
	{
		/* pop up chield key */
		long cpage;
		int cno;
		NtxBucket *cbp;
		NtxPage *cpp;
		long record;

		(*level)++;
		if (*level >= NTX_DEEP)
			return ntx_error(fp, __LINE__, "NTX btree too deep: %d", *level);
		stack[*level].pageoffs = chield;

		r = find_last(fp, ip, stack, level);
		if (r)
			return r;
		cpage = stack[*level].pageoffs;
		cno = stack[*level].buckno;
		cpp = get_ntx_page(ip, cpage);
		cbp = get_ntx_bucket(pp, cno);
		record = dbf_get_long(cbp->record);
		memcpy(bp->key, cbp->key, ip->len);
		dbf_put_long(bp->record, record);

		remove_ntx_node(ip, cpp, cno);
	}
	else
	{
		remove_ntx_node(ip, pp, no);
	}

	/* balance */
	r = balance_node(fp, ip, stack, level);

	return r;
}

static int
delkey_ntx(struct DbfFile *fp, DbfIndex * ip, Tuple * tp)
{
	NtxHeader *hp;
	NtxStack stack[NTX_DEEP];
	int level = 0, r = 0, r1;

	if ((r = dbf_wlock(fp, ip->mp, 0)))
		return r;

	hp = get_ntx_header(ip);
	stack[0].pageoffs = dbf_get_long(hp->root);

	tp->ok = 0;
	r = search_ntx_tree(fp, ip, tp, stack, &level);
	if (r)
		return r;

	if (tp->ok)
	{
		tp->ok = 1;
		r = del_node(fp, ip, stack, &level);
	}

	if ((r1 = dbf_ulock(fp, ip->mp, 0)))
		return r1;

	return r;
}

/* ] NTX */
