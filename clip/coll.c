/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log$
   Revision 1.2  2007/01/22 12:39:29  itk
   uri: some fix for new task model

   Revision 1.1  2006/06/22 19:01:34  itk
   uri: initial

   Revision 1.7  2004/05/21 11:22:18  clip
   rust: minor fix for 'configure -m'

   Revision 1.6  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.5  2001/03/30 11:51:03  clip
   add copyright

   Revision 1.4  2000/05/24 18:34:20  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.3  1999/12/28 22:03:05  serg
   *** empty log message ***

   Revision 1.2  1999/10/26 19:11:26  paul
   start cvs logging

 */

#include <stdlib.h>
#include <string.h>

/*#include "clip.h"*/

#include "coll.h"

#define FIRST_SIZE 4
#define DELTA_SIZE 8

void
init_Coll(Coll * coll, void (*Free) (void *),
	  int (*compare) ( /* void*,void* */ ))
{
	coll->count = 0;
	coll->size = FIRST_SIZE;
	coll->items = (void **) malloc(sizeof(void *) * FIRST_SIZE);

	coll->_free = Free;
	coll->compare = compare;
	coll->duplicates = 0;
}

Coll *
new_Coll(void (*Free) (void *),
	 int (*Compare) ())
{
	Coll *ret = (Coll *) malloc(sizeof(Coll));

	init_Coll(ret, Free, Compare);
	return ret;
}

void
destroy_Coll(Coll * coll)
{
	freeAll_Coll(coll);
	free(coll->items);
}

void
delete_Coll(void *coll)
{
	if (!coll)
		return;
	destroy_Coll((Coll *) coll);
	free(coll);
}

void
freeAll_Coll(Coll * coll)
{
	int i;

	if (coll->_free)
		for (i = coll->count - 1; i >= 0; i--)
			coll->_free(coll->items[i]);
	coll->count = 0;
}

void
removeAll_Coll(Coll * coll)
{
	coll->count = 0;
}

int
indexOf_Coll(Coll * coll, void *item, int *index)
{
	int i;

	for (i = coll->count - 1; i >= 0; i--)
		if (coll->items[i] == item)
		{
			if (index)
				*index = i;
			return 1;
		}
	return 0;
}

void
append_Coll(Coll * coll, void *item)
{
	atInsert_Coll(coll, item, coll->count);
}

void
prepend_Coll(Coll * coll, void *item)
{
	atInsert_Coll(coll, item, 0);
}

static void
setSize(Coll * coll, int size)
{
	void **aItems;
	aItems = (void **) malloc(size * sizeof(void *));

	if (coll->count != 0)
		memcpy(aItems, coll->items, coll->count * sizeof(void *));

	free(coll->items);
	coll->items = aItems;
	coll->size = size;
}

int
atInsert_Coll(Coll * coll, void *item, int index)
{
	if (coll->count == coll->size)
	{
		int le = coll->count / 4;

		if (le < DELTA_SIZE)
			le = DELTA_SIZE;
		setSize(coll, coll->count + le);
	}
	if (index != coll->count)
		memmove(coll->items + index + 1, coll->items + index, (coll->count - index) * sizeof(void *));

	coll->count++;
	coll->items[index] = item;
	return index;
}

void
atRemove_Coll(Coll * coll, int index)
{
	coll->count--;
	memmove(coll->items + index, coll->items + index + 1, (coll->count - index) * sizeof(void *));
}

void
atFree_Coll(Coll * coll, int pos)
{
	if (coll->_free)
		coll->_free(coll->items[pos]);
	atRemove_Coll(coll, pos);
}

int
insert_Coll(Coll * coll, void *item)
{
	return Insert_Coll(coll, item, 0);
}

int
Insert_Coll(Coll * coll, void *item, int *index)
{
	int i;

	if (!coll->compare)
	{
		append_Coll(coll, item);
		return 1;
	}

	if (search_Coll(coll, item, &i) == 0 || coll->duplicates)
	{
		atInsert_Coll(coll, item, i);
		if (index)
			*index = i;
		return 1;
	}
	return 0;
}

int
remove_Coll(Coll * coll, void *item)
{

	int index;

	if (indexOf_Coll(coll, item, &index))
	{
		atRemove_Coll(coll, index);
		return 1;
	}
	return 0;
}

int
free_Coll(Coll * coll, void *item)
{
	int index;

	if (indexOf_Coll(coll, item, &index))
	{
		atFree_Coll(coll, index);
		return 1;
	}
	return 0;
}

int
search_Coll(Coll * coll, void *key, int *index)
{
	/*void *p; */
	int l, h, res, i, c;

	if (!coll->compare)
		return 0;
	l = 0;
	h = coll->count - 1;
	res = 0;
	while (l <= h)
	{
		i = (l + h) >> 1;
		c = coll->compare(coll->items[i], key);
		if (c < 0)
			l = i + 1;
		else
		{
			h = i - 1;
			if (c == 0)
			{
				res = 1;
				if (!coll->duplicates)
					l = i;
			}
		}
	}
	if (index)
		*index = l;
	return res;
}
