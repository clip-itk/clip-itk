
/*
   $Log: list.c,v $
   Revision 1.2  2000/05/24 18:34:34  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.1  1999/10/25 16:39:28  paul
   first entry

   * Revision 1.1  1997/03/12  14:51:41  paul
   * initial
   *
 */

#include "list.h"

#define PREV(el) ((ListEl *)(el))->prev
#define NEXT(el) ((ListEl *)(el))->next

void
init_List(List * list)
{
	list->head = 0;
	list->current = 0;
}

int
empty_List(List * list)
{
	return list->head == 0;
}

int
first_List(List * list)
{
	if (list->head)
	{
		list->current = list->head;
		return 1;
	}
	return 0;
}

int
last_List(List * list)
{
	if (list->head)
	{
		list->current = PREV(list->head);
		return 1;
	}
	return 0;
}

int
next_List(List * list)
{
	if (list->head)
	{
		void *item = NEXT(list->current);

		if (item != list->head)
		{
			list->current = item;
			return 1;
		}
	}
	return 0;
}

int
Next_List(List * list)
{
	if (list->head)
	{
		list->current = NEXT(list->current);
		return 1;
	}
	return 0;
}

int
prev_List(List * list)
{
	if (list->head && list->current != list->head)
	{
		list->current = PREV(list->current);
		return 1;
	}
	return 0;
}

int
Prev_List(List * list)
{
	if (list->head)
	{
		list->current = PREV(list->current);
		return 1;
	}
	return 0;
}

int
seek_List(List * list, void *item)
{
	void *p;

	if (!list->head)
		return 0;

	for (p = list->head;;)
	{
		if (p == item)
		{
			list->current = p;
			return 1;
		}
		p = NEXT(p);
		if (p == list->head)
			return 0;
	}
	return 0;
}

void
remove_List(List * list)
{
	void *p, *n;

	if (!list->head)
		return;
	p = PREV(list->current);
	n = NEXT(list->current);

	if (p == list->current)	/* last member */
		list->head = list->current = 0;
	else
	{
		NEXT(p) = n;
		PREV(n) = p;
		if (list->head == list->current)
			list->head = list->current = n;
		else
			list->current = n;
	}
}

void
removeIt_List(List * list, void *item)
{
	if (list->current != item)
	{
		void *curr = list->current;

		list->current = item;
		remove_List(list);
		list->current = curr;
	}
	else
		remove_List(list);
}

void
insert_List(List * list, void *item)
{
	if (!list->head)
	{
		list->head = list->current = item;
		NEXT(item) = item;
		PREV(item) = item;
	}
	else
	{
		void *p = NEXT(list->current);

		NEXT(list->current) = item;
		PREV(p) = item;
		PREV(item) = list->current;
		NEXT(item) = p;
		list->current = item;
	}
}

void
insertBefore_List(List * list, void *item)
{
	if (!list->head)
	{
		list->head = list->current = item;
		NEXT(item) = item;
		PREV(item) = item;
	}
	else
	{
		void *p = PREV(list->current);

		PREV(list->current) = item;
		NEXT(p) = item;
		NEXT(item) = list->current;
		PREV(item) = p;

		if (list->current == list->head)
			list->head = item;
		list->current = item;
	}
}

void
append_List(List * list, void *item)
{
	if (!list->head)
	{
		list->head = list->current = item;
		NEXT(item) = item;
		PREV(item) = item;
	}
	else
	{
		void *tail = PREV(list->head);

		NEXT(tail) = item;
		PREV(list->head) = item;
		PREV(item) = tail;
		NEXT(item) = list->head;
	}
}

void
prepend_List(List * list, void *item)
{
	if (!list->head)
	{
		list->head = list->current = item;
		PREV(item) = item;
		NEXT(item) = item;
	}
	else
	{
		void *tail = PREV(list->head);

		PREV(list->head) = item;
		NEXT(tail) = item;
		NEXT(item) = list->head;
		PREV(item) = tail;
		list->head = item;
	}
}

void
removeAll_List(List * list)
{
	list->current = list->head = 0;
}

void
put_List(List * list, void *item)
{
	void *p, *n;

	if (!list->head)
		return;

	p = PREV(list->current);
	n = NEXT(list->current);
	if (p == list->current)	/* last member */
	{
		list->head = list->current = item;
		NEXT(item) = item;
		PREV(item) = item;
	}
	else
	{
		NEXT(p) = item;
		PREV(n) = item;
		NEXT(item) = n;
		PREV(item) = p;
		if (list->head == list->current)
			list->head = item;
		list->current = item;
	}
}
