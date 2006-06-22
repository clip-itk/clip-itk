/*
   $Log$
   Revision 1.1  2006/06/22 19:35:16  itk
   uri: init sf.net repository

   Revision 1.5  2004/05/21 11:22:18  clip
   rust: minor fix for 'configure -m'

   Revision 1.4  2000/11/23 06:50:23  clip
   load(name [,array])
   paul

   Revision 1.3  2000/05/24 18:34:21  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.2  1999/10/26 19:11:27  paul
   start cvs logging

 */

#ifndef COLL_H
#define COLL_H

#define ARR_ALLOC(type,len)       ((type*)malloc(sizeof(type)*(len)))
#define ARR_REALLOC(type,ptr,len) ((ptr)=(type*)realloc(ptr,sizeof(type)*(len)))
#define ARR_SEARCH(type,ptr,len)  ((type*)bsearch(ptr,len,sizeof(type),compare_##type))
#define ARR_SORT(type,ptr,len)    qsort(ptr,len,sizeof(type),compare_##type)

typedef struct Coll
{
	int count;
	int size;
	int duplicates;
	void **items;
	void (*_free) (void *);
	int (*compare) (void *, void *);
}
Coll;

Coll *new_Coll(void (*_free) (void *), int (*compare) ());
void delete_Coll(void *coll);

void init_Coll(Coll * coll, void (*_free) (void *), int (*compare) ());
void destroy_Coll(Coll * coll);

void freeAll_Coll(Coll * coll);
void removeAll_Coll(Coll * coll);

int indexOf_Coll(Coll * coll, void *item, int *index);

int insert_Coll(Coll * coll, void *item);
int Insert_Coll(Coll * coll, void *item, int *index);
int remove_Coll(Coll * coll, void *item);
int free_Coll(Coll * coll, void *item);

void append_Coll(Coll * coll, void *item);
void prepend_Coll(Coll * coll, void *item);

int atInsert_Coll(Coll * coll, void *item, int index);
void atRemove_Coll(Coll * coll, int index);
void atFree_Coll(Coll * coll, int index);

int search_Coll(Coll * coll, void *item, int *index);

#endif
