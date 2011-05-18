/*
	Copyright (C) 2002  ITK
	Author  :Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log$
   Revision 1.1  2006/06/22 19:01:29  itk
   uri: initial

   Revision 1.2  2002/12/27 14:40:29  clip
   DEPSORT fix
   paul

   Revision 1.1  2002/12/27 14:07:54  clip
   DEPSORT(arr={ {{"a"},{"a","b"},"cargo"} } [,target]={{"a"},{"a","b"}})
   closes #94
   paul

*/

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>
#include <errno.h>

#include "clip.h"
#include "error.ch"
#include "coll.h"

extern char *CLIPROOT;

#define NEW(type) ((type*)calloc(sizeof(type),1))
#define NEWVECT(type,len) ((type*)calloc(sizeof(type),(len)))

/*
m:={;
    {"a",{"b","c"},'<commands>'},;
    {"b",{"c","d"},'<commands>'},;
    {"c",{"y"},'<commands>'},;
    {"y",{},'<commands>'};
   }

x := depsort(m [,target])

  ? x
    {;
     {"y",{},'<commands>'},;
     {"c",{"y"},'<commands>'},;
     {"b",{"c","d"},'<commands>'},;
     {"a",{"b","c"},'<commands>'};
    }
*/

typedef struct DepNode
{
	ClipVar *vp;		/* payload */
	long hash;
	int ndeps;
	long *deps;
	int setno;
	int in_cycle;
}
DepNode;

static DepNode *new_DepNode(ClipMachine * mp, ClipVar * vp);
static void delete_DepNode(void *Np);
static int cmp_DepNode(void *p1, void *p2);

static void
delete_DepNode(void *Np)
{
	DepNode *np;

	if (!Np)
		return;
	np = (DepNode *) Np;

	if (np->deps)
		free(np->deps);

	free(np);
}

static int
cmp_DepNode(void *p1, void *p2)
{
	DepNode *np1 = (DepNode *) p1;
	DepNode *np2 = (DepNode *) p2;

	if (np1->hash < np2->hash)
		return -1;
	else if (np1->hash > np2->hash)
		return 1;
	else
		return 0;
}

static DepNode *
new_DepNode(ClipMachine * mp, ClipVar * vp)
{
	DepNode *np;
	ClipVar *ap;

	np = NEW(DepNode);
	np->vp = vp;
	np->setno = -1;

	ap = _clip_vptr(vp);
	if (ap->t.type != ARRAY_t)
	{
		np->hash = _clip_hash(mp, ap);
		return np;
	}

	if (ap->a.count > 0)
		np->hash = _clip_hash(mp, ap->a.items + 0);
	else
		np->hash = (long) ap;

	if (ap->a.count > 1)
	{
		ClipVar *dp = _clip_vptr(ap->a.items + 1);
		if (dp->t.type == ARRAY_t)
		{
			int i;

			np->ndeps = dp->a.count;
			np->deps = (long *) calloc(np->ndeps, sizeof(long));

			for (i = 0; i < np->ndeps; i++)
				np->deps[i] = _clip_hash(mp, dp->a.items + i);
		}
	}

	return np;
}

static DepNode *
find_node(Coll * graph, long hash)
{
	int ind;
	DepNode node;

	node.hash = hash;

	if (search_Coll(graph, &node, &ind))
		return (DepNode *) graph->items[ind];
	return 0;
}

void
set_cycle(Coll * graph, DepNode * node, DepNode * end)
{
	int i;

	if (node->in_cycle)
		return;
	node->in_cycle = 1;
	for (i = 0; i < node->ndeps; i++)
	{
		DepNode *np = find_node(graph, node->deps[i]);

		if (np && np != end)
			set_cycle(graph, np, end);
	}
}

static int
depth_search(Coll * graph, DepNode * start, int *setno)
{
	int i;
	int find = 0;

	start->setno = -3;
	for (i = 0; i < start->ndeps; i++)
	{
		DepNode *np = find_node(graph, start->deps[i]);

		if (!np)
			continue;
		if (np->in_cycle)
			continue;
		switch (np->setno)
		{
		case -1:
			/* unprocessed node */
			depth_search(graph, np, setno);
			find++;
			break;
		case -3:
			/* cycle detected */
			set_cycle(graph, np, np);
			break;
		default:
			/* procecced node */
			break;
		}
	}

	if (!find)		/* terminate node */
		start->setno = (*setno)++;
	else			/* rollback */
		start->setno = -1;

	return find;
}

int
clip_DEPSORT(ClipMachine * mp)
{
	ClipVar *ap = _clip_par(mp, 1);
	ClipVar *tap = _clip_par(mp, 2);
	ClipVar *rp, *rap;
	int i, setno;
	Coll graph;

	if (!ap || ap->t.type != ARRAY_t)
		return EG_ARG;

	init_Coll(&graph, delete_DepNode, cmp_DepNode);

	for (i = 0; i < (int)ap->a.count; i++)
	{
		DepNode *np = new_DepNode(mp, ap->a.items + i);

		insert_Coll(&graph, np);
	}

	setno = 0;

	if (tap)
	{
		DepNode *tp = new_DepNode(mp, tap);
                DepNode *start = find_node(&graph, tp->hash);
                if (!start)
                	start = tp;

		while (depth_search(&graph, start, &setno))
			;

		delete_DepNode(tp);
	}
	else
	{
		for (i = 0; i < graph.count; i++)
		{
			DepNode *dp = (DepNode *) graph.items[i];

			if (dp->setno >= 0)
				continue;

			while (depth_search(&graph, dp, &setno))
				;
		}
	}

	rp = RETPTR(mp);

	CLEAR_CLIPVAR(rp);
	rp->t.type = ARRAY_t;
	rp->t.flags = F_MPTR;
	rp->p.vp = rap = (ClipVar *) calloc(sizeof(ClipVar), 1);
	rap->t.type = ARRAY_t;
	rap->t.flags = F_NONE;
	rap->a.count = 0;
	rap->a.items = 0;
	rap->t.count = 1;

	for (i = 0; i < setno; i++)
	{
		int j;

		for (j = 0; j < graph.count; j++)
		{
			DepNode *dp = (DepNode *) graph.items[j];

			if (dp->setno == i)
			{
				ClipVar *vpp;

				rap->a.items = (ClipVar *) realloc(rap->a.items, (rap->a.count + 1) * sizeof(ClipVar));

				vpp = rap->a.items + rap->a.count;
				(rap->a.count)++;

				CLEAR_CLIPVAR(vpp);
				_clip_mclone(mp, vpp, dp->vp);
			}
		}
	}

#if 0
	/* rest */
	for (i = 0; i < graph.count; i++)
	{
		DepNode *dp = (DepNode *) graph.items[i];

		if (dp->setno < 0)
		{
			ClipVar *vpp;

			rap->a.items = (ClipVar *) realloc(rap->a.items, (rap->a.count + 1) * sizeof(ClipVar));

			vpp = rap->a.items + rap->a.count;
			(rap->a.count)++;

			CLEAR_CLIPVAR(vpp);
			_clip_mclone(mp, vpp, dp->vp);
		}
	}
#endif

	destroy_Coll(&graph);

	return 0;
}
