/*
	Copyright (C) 2001  ITK
	Author  : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: btree.h,v $
	Revision 1.7  2002/07/01 11:20:10  clip
	rust: small fix
	
	Revision 1.6  2002/06/21 09:35:18  clip
	rust: some cleanups

	Revision 1.5  2002/04/16 14:56:02  clip
	BTREE function's set (sorted multitude):

	BT_CREATE( <supposed_count> [, <item_size>, <item_type> ] ) -> BTREE handle
	BT_ADD( <handle>, <data> )
	BT_FIELDFILL( <handle>, <field_name>|<field_no> )
	BT_INTERSECT( <dest_handle>, <handle1>, <handle2> )
	BT_FIRST( <handle> ) -> .T. when ok, .F. when empty
	BT_LAST( <handle> ) -> .T. when ok, .F. when empty
	BT_NEXT( <handle> ) -> .T. when ok, .F. already on the last element
	BT_PREV( <handle> ) -> .T. when ok, .F. already on the first element
	BT_DATA( <handle> ) -> the value of current element
	BT_DESTROY( <handle> )

	rust

	Revision 1.4  2002/01/09 12:38:46  clip
	some fixes
	rust

	Revision 1.3  2001/12/23 12:22:31  clip
	CygWin optimizations
	rust

	Revision 1.2  2001/11/30 12:04:45  clip
	*** empty log message ***

	Revision 1.1  2001/09/12 10:51:16  clip
	Quick dbCreateIndex() using BTree
	rust

*/

struct _BT_NODE_;
typedef struct _BT_NODE_ {
	unsigned int left;
	unsigned int right;
	unsigned int parent;
} BT_NODE;

typedef struct _BTREE_ {
	int (*bt_compare)(void* op,void* key1,void* key2);
	int unique;
	int size;
	unsigned int count;
	int in;
	char type;
	unsigned int root;
	unsigned int cur;
	unsigned int fuu;
	void* data;
} BTREE;

BTREE* bt_create(int unique,int count,int size,int (*compare)(void* op,void* key1,void* key2));
void bt_destroy(BTREE* bt);

int bt_add(BTREE* bt,void* op,void* key);
int bt_del(BTREE* bt);

int bt_first(BTREE* bt);
int bt_last(BTREE* bt);

int bt_next(BTREE* bt);
int bt_prev(BTREE* bt);

int bt_seek(BTREE* bt,void* op,void* key);

void* bt_key(BTREE* bt);
