/*
	Copyright (C) 2001  ITK
	Author  : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: btree.h,v $
	Revision 1.10  2003/03/05 09:56:35  clip
	rust: bug with unique indexes fixed,
	reported by Stas I. Litovka <root@depot.pharm.sumy.ua>
	
	Revision 1.9  2002/10/29 13:29:46  clip
	rust: SET INDEX BUFFER LIMIT [TO] <n_Megabytes>
		  SET MAP FILE ON|OFF

	Revision 1.8  2002/10/24 13:53:36  clip
	rust: new btree implementation

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
	int (*bt_compare)(void* op,void* key1,void* key2,int* uniqfound);
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

BTREE* bt_create(int unique,int count,int size,int (*compare)(void* op,void* key1,void* key2,int* uniqfound));
void bt_destroy(BTREE* bt);

int bt_add(BTREE* bt,void* op,void* key);
int bt_del(BTREE* bt);

int bt_first(BTREE* bt);
int bt_last(BTREE* bt);

int bt_next(BTREE* bt);
int bt_prev(BTREE* bt);

int bt_seek(BTREE* bt,void* op,void* key);

void* bt_key(BTREE* bt);

#define NKEYS(p) *(short*)(p)
#define POS(p,i) *(short*)(((char*)(p))+2*sizeof(short)+sizeof(void*)+(i)*sizeof(short))
#define KEY(p,i) (void*)((char*)(p)+(POS((p),(i))))
#define LEFT(p,i) *(void**)((char*)(KEY((p),(i)))+bt->keysize)
#define PARENT(p) *(void**)((char*)(p)+sizeof(short))
#define PARPOS(p) *(short*)((char*)(p)+sizeof(short)+sizeof(void*))

typedef struct _BTREE1_ {
	int (*bt_compare)(void* op,void* key1,void* key2,int* uniqfound);
	int keysize;
	int recsize;
	size_t pagesize;
	int keysonpage;
	int halfpage;
	void* root;
	void* cur;
	short curpos;
	int limit;
	int memused;
	int unique;
} BTREE1;

int bt1_first(BTREE1* bt);
int bt1_last(BTREE1* bt);
int bt1_add(BTREE1* bt,void* op,void* key);
int bt1_seek(BTREE1* bt,void* op,void* key);
int bt1_next(BTREE1* bt);
BTREE1* bt1_create(int unique,int keysize,int (*compare)(void* op,void* key1,void* key2,int* uniqfound),int limit);
int bt1_destroy(BTREE1* bt);
void* bt1_key(BTREE1* bt);
