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

   Revision 1.9  2005/08/08 09:00:31  clip
   alena: fix for gcc 4

   Revision 1.8  2004/05/21 11:22:19  clip
   rust: minor fix for 'configure -m'

   Revision 1.7  2001/04/03 09:17:01  clip
   license errors
   paul

   Revision 1.6  2001/03/30 11:51:03  clip
   add copyright

   Revision 1.5  2000/05/24 18:34:29  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.4  2000/05/20 20:18:10  clip
   negative aliases
   Paul Lasarev <paul@itk.ru>

   Revision 1.3  2000/05/20 18:37:32  clip
   change hash function
   append HASH_xxxx extraction into hashcode.h
   Paul Lasarev <paul@itk.ru>

   Revision 1.2  1999/10/26 19:11:31  paul
   start cvs logging

 */

#include <stdlib.h>

/*#include "clip.h"*/
#include "hash.h"

struct _HashTable
{
	int size;
	int num;
	int current;
	unsigned long *hashs;
	char *status;
	void **items;
};

static void resize(HashTable * self, int newsize);
static unsigned long doublehashinc(unsigned long h, unsigned long s);

#define true 1
#define false 0
#define null ((void*)0)

#define EMPTYCELL 0
#define VALIDCELL 1
#define DELETEDCELL 2

#define FIRST_SIZE 16
#define NEED_GROW(c,s) ((c)*5/4>=(s))

#define NEW(type) ((type*)malloc(sizeof(type)))
#define NEWVECT(type,len) ((type*)calloc(sizeof(type),(len)))
#define RESIZE(ptr,type,len) ((type*)realloc(ptr,sizeof(type)*(len)))
#define VAR(type,var,ini) type *var=(type*)(ini)
#define NEWVAR(type,var) type *var=(type*)malloc(sizeof(type))

HashTable *
new_HashTable()
{
	NEWVAR(HashTable, tp);
	tp->num = 0;
	tp->size = FIRST_SIZE;
	tp->current = 0;
	tp->items = NEWVECT(void *, FIRST_SIZE);
	tp->hashs = (unsigned long *)NEWVECT(long, FIRST_SIZE);
	tp->status = NEWVECT(char, FIRST_SIZE);

	HashTable_clear(tp);
	return tp;
}

void
delete_HashTable(HashTable * self)
{
	free(self->items);
	free(self->hashs);
	free(self->status);
	free(self);
}

int
HashTable_len(HashTable * self)
{
	return self->num;
}

void
HashTable_clear(HashTable * self)
{
	int i;

	self->num = 0;
	for (i = 0; i < self->size; i++)
		self->status[i] = EMPTYCELL;
}

void
HashTable_Clear(HashTable * self)
{
	self->size = FIRST_SIZE;
	self->items = RESIZE(self->items, void *, FIRST_SIZE);
	self->hashs = RESIZE(self->hashs, unsigned long, FIRST_SIZE);
	self->status = RESIZE(self->status, char, FIRST_SIZE);

	HashTable_clear(self);
}

static unsigned long
doublehashinc(unsigned long h, unsigned long s)
{
	unsigned long dh = (h / s) % s;

	return dh > 1 ? dh : 1;
}

static void
resize(HashTable * self, int newsize)
{
	int oldsize = self->size, i;
	void **olditems;
	unsigned long *oldhashs;
	char *oldstatus;

	if (newsize <= self->num)
	{
		newsize = FIRST_SIZE;
		while (NEED_GROW(self->num, newsize))
			newsize *= 2;
	}
	self->size = newsize;

	olditems = self->items;
	oldstatus = self->status;
	oldhashs = self->hashs;

	self->items = NEWVECT(void *, newsize);
	self->status = NEWVECT(char, newsize);
	self->hashs = NEWVECT(unsigned long, newsize);

	for (i = 0; i < newsize; i++)
		self->status[i] = EMPTYCELL;

	self->num = 0;
	for (i = 0; i < oldsize; i++)
	{
		if (oldstatus[i] == VALIDCELL)
			HashTable_store(self, olditems[i], oldhashs[i]);
	}

	free(olditems);
	free(oldstatus);
	free(oldhashs);
}

int
HashTable_insert(HashTable * self, void *item, long hash)
{
	if (HashTable_fetch(self, hash))
		return 0;
	return HashTable_store(self, item, hash);
}

int
HashTable_store(HashTable * self, void *item, long hash_val)
{
	int Size = self->size;
	int Num = self->num;
	int bestspot, i;
	unsigned long h, hashval = (unsigned long) hash_val;

	if (NEED_GROW(Num, Size))
	{
		resize(self, 0);
		Size = self->size;
		Num = self->num;
	}
	bestspot = Size;
	h = hashval % Size;
	for (i = 0; i <= Size; ++i)
	{
		/* if (self->status[h] == DELETEDCELL) { if (bestspot >= Size) bestspot
		   = h; } else if (self->status[h] == EMPTYCELL) */
		if (self->status[h] != VALIDCELL)
		{
			if (bestspot >= Size)
				bestspot = h;
			self->items[bestspot] = item;
			self->hashs[bestspot] = hashval;
			self->status[bestspot] = VALIDCELL;
			++self->num;
			return true;
		}
		else if (self->hashs[h] == hashval)
		{		/* replace value */
			self->items[h] = item;
			return true;
		}
		if (i == 0)
			h = (h + doublehashinc(hashval, Size)) % Size;
		else
		{
			++h;
			if (h >= Size)
				h -= Size;
		}
	}
	self->items[bestspot] = item;
	self->hashs[bestspot] = hashval;
	self->status[bestspot] = VALIDCELL;

	++self->num;
	return true;
}

void *
HashTable_fetch(HashTable * self, long hash_val)
{
	int Size = self->size;
	unsigned long hashval = (unsigned long) hash_val;
	unsigned long h = hashval % Size;
	int i;

	for (i = 0; i <= Size; ++i)
	{
		if (self->status[h] == EMPTYCELL)
			return null;
		else if (self->status[h] == VALIDCELL && self->hashs[h] == hashval)
			return self->items[h];
		if (i == 0)
			h = (h + doublehashinc(hashval, Size)) % Size;
		else
		{
			++h;
			if (h >= Size)
				h -= Size;
		}
	}
	return null;
}

void *
HashTable_remove(HashTable * self, long hash_val)
{
	int Size = self->size;
	unsigned long hashval = (unsigned long) hash_val;
	unsigned long h = hashval % Size;
	int i;

	for (i = 0; i <= Size; ++i)
	{
		if (self->status[h] == EMPTYCELL)
			return null;
		else if (self->status[h] == VALIDCELL && self->hashs[h] == hashval)
		{
			self->status[h] = DELETEDCELL;
			--self->num;
			return self->items[h];
		}
		if (i == 0)
			h = (h + doublehashinc(hashval, Size)) % Size;
		else
		{
			++h;
			if (h >= Size)
				h -= Size;
		}
	}
	return null;
}

int
HashTable_first(HashTable * self)
{
	int i;

	if (self->num < 1)
		return 0;
	for (i = 0; i < self->size; i++)
		if (self->status[i] == VALIDCELL)
		{
			self->current = i;
			return true;
		}
	return false;
}

int
HashTable_next(HashTable * self)
{
	int i;

	if (self->num < 1)
		return 0;
	for (i = ++self->current; i < self->size; i++)
		if (self->status[i] == VALIDCELL)
		{
			self->current = i;
			return true;
		}
	return false;
}

void *
HashTable_current(HashTable * self)
{
	return self->items[self->current];
}
