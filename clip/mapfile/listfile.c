/*
$Log: listfile.c,v $
Revision 1.2  1999/11/02 23:05:39  axl
start of logging

*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "mapfile.h"
#include "listfile.h"

#define ERRBUFSIZE 256
#define NEW(type) ((type*)calloc(sizeof(type),1))
#define NEWVAR(type,var) type *var=(type*)calloc(sizeof(type),1)

typedef struct ListFile
{
	struct MapFile *mp;
	int recSize;
	int pageSize;
	int writeFl;
	int recOnPage;
	long pageCount;
	char buf[ERRBUFSIZE];
} ListFile;

typedef struct
{
	long fileId;
	long pageSize;
	long recSize;
	long freePage;
	long pageCount;
} Header;

typedef struct
{
	long next;	/* page with free slots */
	long prev;	/* page with free slots */
	short first;	/* free slot in this page */
	short num;	/* free slots in this page */
} PageHeader;

typedef struct
{
	long next;	/* recno */
} RecHeader;

static RecHeader *getRec(struct ListFile *fp, long head);
static PageHeader *getPage(struct ListFile *fp, long page);


static Header *
getHeader(struct ListFile *fp)
{
	return (Header* ) getHeader_MapFile(fp->mp);
}

static int
lockHeader(struct ListFile *fp, Header ** hpp, int writeFl)
{
	int ret = lockHeader_MapFile(fp->mp, writeFl, (void **) hpp);

	if (ret)
		getError_MapFile(fp->mp, fp->buf, ERRBUFSIZE);
	else
	{
		Header *hp = getHeader(fp);

		if (hp->pageCount != fp->pageCount)
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
unlockHeader(struct ListFile *fp)
{
	int ret = unlockHeader_MapFile(fp->mp);

	if (ret)
		getError_MapFile(fp->mp, fp->buf, ERRBUFSIZE);
	return ret;
}


struct ListFile *
create_ListFile(const char *name, int pageSize, int recSize, char *errbuf, int errbuflen )
{
	struct ListFile *fp;
	Header *hp;
	struct MapFile *mp;
	int ps = getpagesize();

	if (pageSize && pageSize<= recSize+sizeof(PageHeader))
		pageSize = recSize * 2 + sizeof(PageHeader);

	if (pageSize<ps)
		pageSize = ps;
	else
		pageSize = (pageSize/ps + (pageSize%ps?1:0)) * ps;

	mp = create_MapFile(name, sizeof(Header), pageSize, errbuf, errbuflen);
	if (!mp)
		return 0;
	fp = NEW(struct ListFile);
	fp->mp = mp;
	fp->pageSize = pageSize;
	fp->recSize = recSize;
	fp->writeFl = 1;
	fp->recOnPage = (fp->pageSize-sizeof(PageHeader))/(fp->recSize+sizeof(RecHeader));

	if (lockHeader(fp, &hp, 1))
	{
		snprintf(errbuf, errbuflen, "%s", fp->buf);
		close_MapFile(fp->mp);
		free(fp);
		return 0;
	}
	hp->fileId = LISTFILE_FILEID;
	hp->freePage = -1;
	hp->recSize = recSize;
	hp->pageSize = pageSize;
	fp->pageCount = hp->pageCount = 0;

	unlockHeader(fp);

	return fp;
}

struct ListFile *
open_ListFile(const char *name, int writeFl, char *errbuf, int errbuflen )
{
	Header *hp;
	NEWVAR(struct ListFile, fp);

	fp->mp = open_MapFile(name, sizeof(Header), writeFl, errbuf, errbuflen);
	if (!fp->mp)
	{
		free(fp);
		return 0;
	}
	fp->writeFl = writeFl;

	if ( lockHeader(fp, &hp, 0) )
	{
err:
		close_MapFile(fp->mp);
		free(fp);
		return 0;
	}

	if(hp->fileId != LISTFILE_FILEID)
	{
		snprintf(fp->buf, ERRBUFSIZE, "'%s': invalid file id", name);
		goto err;
	}

	fp->pageSize = hp->pageSize;
	fp->pageCount = hp->pageCount;
	fp->recSize = hp->recSize;
	setRecSize_MapFile(fp->mp, fp->pageSize);
	fp->recOnPage = (fp->pageSize-sizeof(PageHeader))/(fp->recSize+sizeof(RecHeader));

	if ( unlockHeader(fp) )
		goto err;

	return fp;
}

int
close_ListFile(struct ListFile *fp)
{
	int ret = close_MapFile(fp->mp);

	free(fp);

	return ret;
}

int
recSize_ListFile(struct ListFile *fp)
{
	return fp->recSize;
}

void
getError_ListFile(struct ListFile *fp, char *buf, int buflen)
{
	snprintf(buf, buflen, "%s", fp->buf);
}

void
exclude_page(struct ListFile *fp, PageHeader *pp)
{
	long prev = pp->prev;
	long next = pp->next;
	if (prev == -1)
	{
		Header *hp = getHeader(fp);
		hp->freePage = next;
	}
	else
	{
		PageHeader *ppp = getPage(fp, prev);
		ppp->next = next;
	}

	if ( next != -1 )
	{
		PageHeader *ppp = getPage(fp, next);
		ppp->prev = prev;
	}
}

long
take_rec(struct ListFile *fp, long page)
{
	long recno;
	int rs = fp->recSize;
	PageHeader *pp = getPage(fp, page);
	RecHeader *rp;

	recno = page*fp->recOnPage + pp->first;
	rp = (RecHeader*)(((char*)(pp+1))+(sizeof(RecHeader)+rs)*pp->first);
	pp->first = rp->next;
	rp->next=-1;
	--pp->num;
	if (pp->num==0)
		exclude_page(fp,pp);

	return recno;
}

static long
get_free_rec(struct ListFile *fp, long hint)
{
	long recno=-1, page;
	Header *hp = getHeader(fp);
	int i, rs = fp->recSize, rop = fp->recOnPage;
	PageHeader *pp;
	RecHeader *rp;

	if (hp->freePage == -1)
	{
		char *bp;

		/*addBlock_MapFile(fp->mp, &page, &bp, 1);*/
		incr_MapFile(fp->mp, &page, 1, 0);
		bp = getRec_MapFile(fp->mp, page);

		hp = getHeader(fp);
		pp = (PageHeader *)bp;
		bp += sizeof(PageHeader);
		for(i=0; i<rop; ++i)
		{
			rp = (RecHeader*)(bp+(sizeof(RecHeader)+rs)*i);
			if (i==0)
			{
				rp->next = -1;
				recno = page*rop+i;
			}
			else if (i<rop-1)
				rp->next = i+1;
			else
				rp->next = -1;
		}
		pp->next = -1;
		pp->prev = -1;
		pp->num	= rop-1;
		pp->first = 1;
		hp->freePage = page;
	}
	else
	{
		if (hint>=0)
		{
			page = hint/rop;
			pp = getPage(fp, page);
			if (pp->num)
			{
				recno = take_rec(fp,page);
				goto ret;
			}
		}

		page = hp->freePage;
		recno = take_rec(fp,page);
	}
ret:
	return recno;
}

static int
put_free_rec(struct ListFile *fp, long recno)
{
	Header *hp;
	int rs = fp->recSize;
	int rop = fp->recOnPage;
	long page = recno/rop;
	int rec = recno % rop;
	PageHeader *pp = getPage(fp, page);
	RecHeader *rp = (RecHeader*) (((char*)(pp+1))+rec*(rs+sizeof(RecHeader)));

	if (pp->num==0)
	{
		hp = getHeader(fp);
		if (hp->freePage == -1)
		{
			pp->next = -1;
			pp->prev = -1;
			hp->freePage = page;
		}
		else
		{
			long next = hp->freePage;
			PageHeader *ppp = getPage(fp, next);
			pp->next = next;
			pp->prev = -1;
			ppp->prev = page;
			hp->freePage = page;
		}

		pp->num++;
		pp->first = rec;
		rp->next = -1;
	}
	else
	{
		rp->next = pp->first;
		pp->first = rec;
		pp->num++;
	}

	return 0;
}

static RecHeader *
getRec(struct ListFile *fp, long head)
{
	long page = head/fp->recOnPage;
	int rec = head%fp->recOnPage;
	char *basep = getRec_MapFile(fp->mp, page);

	return (RecHeader*) ((basep+sizeof(PageHeader))+rec*(fp->recSize+sizeof(RecHeader)));
}

static PageHeader *
getPage(struct ListFile *fp, long page)
{
	return (PageHeader*) getRec_MapFile(fp->mp, page);
}

int
add_ListFile(struct ListFile *fp, long *head, char **vect, int num)
{
	long recno, prev;
	int i;
	RecHeader *rp=0;
	Header *hp;

	if(!fp->writeFl)
	{
		snprintf(fp->buf, ERRBUFSIZE, "write operation on read-only ListFile");
		return 1;
	}

	if (lockHeader(fp, &hp, 1))
		return 1;

	for(i=0, prev=-1 ; i<num ; ++i)
	{
		recno = get_free_rec(fp, prev);
		if (i)
		{
			rp = getRec(fp,prev);
			rp->next = recno;
		}
		else
			*head = recno;
		rp = getRec(fp,recno);
		memcpy(rp+1,vect[i],fp->recSize);
		prev = recno;
	}

	if (unlockHeader(fp))
		return 1;

	return 0;
}

int
del_ListFile(struct ListFile *fp, long head )
{
	long recno;
	RecHeader *rp=0;
	Header *hp;

	if(!fp->writeFl)
	{
		snprintf(fp->buf, ERRBUFSIZE, "write operation on read-only ListFile");
		return 1;
	}

	if (lockHeader(fp, &hp, 1))
		return 1;

	while( head >= 0 )
	{
		rp = getRec(fp,head);
		recno = head;
		head = rp->next;
		put_free_rec(fp, recno);
	}

	if (unlockHeader(fp))
		return 1;

	return 0;
}


int
put_ListFile(struct ListFile *fp, long *head, char **vect, int num)
{
	long recno, prev, entry, hea;
	int i;
	RecHeader *rp=0;
	Header *hp;

	if(!fp->writeFl)
	{
		snprintf(fp->buf, ERRBUFSIZE, "write operation on read-only ListFile");
		return 1;
	}

	if (lockHeader(fp, &hp, 1))
		return 1;

	entry = hea = *head;

	while( hea >= 0 )
	{
		rp = getRec(fp,hea);
		recno = hea;
		hea = rp->next;
		put_free_rec(fp, recno);
	}

	for(i=0, prev=-1 ; i<num ; ++i)
	{
		recno = get_free_rec(fp, prev<0?entry:prev);
		if (i)
		{
			rp = getRec(fp,prev);
			rp->next = recno;
		}
		else
			*head = recno;

		rp = getRec(fp,recno);
		memcpy(rp+1,vect[i],fp->recSize);
		prev = recno;
	}

	if (unlockHeader(fp))
		return 1;

	return 0;
}

int
append_ListFile(struct ListFile *fp, long *head, char *rec)
{
	long recno;
	RecHeader *rp=0;
	Header *hp;

	if(!fp->writeFl)
	{
		snprintf(fp->buf, ERRBUFSIZE, "write operation on read-only ListFile");
		return 1;
	}

	if (lockHeader(fp, &hp, 1))
		return 1;

	recno = get_free_rec(fp, *head);
	if (*head>=0)
	{
		rp = getRec(fp,*head);
		rp->next = recno;
	}

	rp = getRec(fp,recno);
	memcpy(rp+1,rec,fp->recSize);
	*head = recno;

	if (unlockHeader(fp))
		return 1;

	return 0;
}


int
get_ListFile(struct ListFile *fp, long head, char ***vectp, int *num )
{
	long recno;
	RecHeader *rp=0;
	Header *hp;

	if (lockHeader(fp, &hp, 0))
		return 1;

	for( *num=0; head >= 0; ++ *num )
	{
		rp = getRec(fp,head);
		recno = head;
		head = rp->next;

		*vectp = (char **) realloc(*vectp, (*num+1)*sizeof(char *));
		(*vectp)[*num] = (char*)(rp+1);
	}

	if (unlockHeader(fp))
		return 1;

	return 0;
}

int
getNext_ListFile(struct ListFile *fp, long *head, char **recp )
{
	RecHeader *rp=0;
	Header *hp;

	if (lockHeader(fp, &hp, 0))
		return 1;

	rp = getRec(fp,*head);
	*head = rp->next;
	if (*head>=0)
	{
		rp = getRec(fp,*head);
		*recp = (char*)(rp+1);
	}
	else
		*recp = 0;

	if (unlockHeader(fp))
		return 1;

	return 0;
}

