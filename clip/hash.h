/*
   $Log: hash.h,v $
   Revision 1.3  2000/05/24 18:34:30  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.2  1999/10/26 19:11:32  paul
   start cvs logging

 */

#ifndef HASH_H
#define HASH_H

typedef struct _HashTable HashTable;

HashTable *new_HashTable();
void delete_HashTable(HashTable * self);

int HashTable_len(HashTable * self);
void HashTable_clear(HashTable * self);
void HashTable_Clear(HashTable * self);		/* decrease table size to initial */
int HashTable_insert(HashTable * self, void *item, long hash);
int HashTable_store(HashTable * self, void *item, long hash);
void *HashTable_fetch(HashTable * self, long hash);
void *HashTable_remove(HashTable * self, long hash);

int HashTable_first(HashTable * self);
int HashTable_next(HashTable * self);
void *HashTable_current(HashTable * self);

#endif
