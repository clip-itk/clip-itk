/*
	Copyright (C) 2001  ITK
	Author  : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: btree.c,v $
	Revision 1.28  2003/09/02 14:27:43  clip
	changes for MINGW from
	Mauricio Abre <maurifull@datafull.com>
	paul
	
	Revision 1.27  2003/05/07 11:09:46  clip
	rust: minor fixes

	Revision 1.26  2003/04/16 10:19:58  clip
	rust: #include "btree.h" -> "./btree.h" and some other fixes for BeOS

	Revision 1.25  2003/04/11 08:31:44  clip
	rust: #ifdef HAVE_MMAN_H (BeOS)

	Revision 1.24  2003/03/05 09:56:35  clip
	rust: bug with unique indexes fixed,
	reported by Stas I. Litovka <root@depot.pharm.sumy.ua>

	Revision 1.23  2002/10/29 13:29:46  clip
	rust: SET INDEX BUFFER LIMIT [TO] <n_Megabytes>
		  SET MAP FILE ON|OFF

	Revision 1.22  2002/10/28 11:22:55  clip
	rust: small fix

	Revision 1.21  2002/10/28 10:09:19  clip
	rust: SIGSEGV when indexing an empty dbf; closes #48

	Revision 1.20  2002/10/26 11:10:02  clip
	initial support for localized runtime messages
	messages are in module 'cliprt'
	paul

	Revision 1.19  2002/10/24 14:07:55  clip
	rust: bt1_destroy()

	Revision 1.18  2002/10/24 13:53:36  clip
	rust: new btree implementation

	Revision 1.17  2002/09/11 12:29:00  clip
	build fixes
	paul

	Revision 1.16  2002/07/03 12:16:17  clip
	rust: orders in TRowset

	Revision 1.15  2002/07/01 11:20:10  clip
	rust: small fix

	Revision 1.14  2002/06/21 09:35:18  clip
	rust: some cleanups

	Revision 1.13  2002/04/16 14:56:02  clip
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

	Revision 1.12  2002/04/15 11:42:37  clip
	rust: changes from Alexandr Kresin

	Revision 1.11  2002/04/11 11:58:47  clip
	rust: Changes from Alexander S.Kresin <alex@belacy.belgorod.su>
	avoiding error and warning messages with bcc

	Revision 1.9  2002/01/09 12:38:46  clip
	some fixes
	rust

	Revision 1.8  2001/12/23 12:22:31  clip
	CygWin optimizations
	rust

	Revision 1.7  2001/12/05 12:41:00  clip
	warnings
	rust

	Revision 1.6  2001/11/30 12:04:45  clip
	*** empty log message ***

	Revision 1.5  2001/11/27 10:48:56  clip
	MAP_ANONYMOUS -> MAP_ANON
	rust

	Revision 1.4  2001/11/20 14:54:55  clip
	bug in bt_create()
	rust

	Revision 1.3  2001/11/19 10:18:01  clip
	calloc()/free() -> mmap()/munmap()
	rust

	Revision 1.2  2001/09/17 10:13:38  clip
	might be uninitialized warning
	rust

	Revision 1.1  2001/09/12 10:51:16  clip
	Quick dbCreateIndex() using BTree
	rust

*/

#include "clipcfg.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>
#include <string.h>
#if defined(__GNUC__)
   #include <unistd.h>
#endif
#include "clipbase.h"
#include "rdd.h"
#include "./btree.h"
#include "error.ch"
#ifdef HAVE_MMAN_H
   #include <sys/mman.h>
#endif

typedef unsigned char uchar;
typedef unsigned int u4;

#define er_unknowndata 	_clip_gettext("Unknown data type or bad size of item")
#define er_badtree 	_clip_gettext("Bad BTREE handle")
#define er_nofield 	_clip_gettext("No such field")
#define er_internal 	_clip_gettext("Internal error in BTREE module")

extern DBWorkArea *cur_area(ClipMachine * cm);

#define CHECKBTREE(bt) \
	if(!(bt)){ \
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_badtree); \
		goto err; \
	}

#define NODE(offs) ((BT_NODE*)((uchar*)bt->data+(offs)))

static int _bt_left_size(BTREE* bt,u4 bn){
	int s = 0;
	while(NODE(bn)->left){
		bn = NODE(bn)->left;
		s++;
	}
	return s;
}

static int _bt_right_size(BTREE* bt,u4 bn){
	int s = 0;
	while(NODE(bn)->right){
		bn = NODE(bn)->right;
		s++;
	}
	return s;
}

static int _bt_firstnode(BTREE* bt,u4 root){
	bt->cur = root;
	if(!bt->cur)
		return 1;
	while(NODE(bt->cur)->left)
		bt->cur = NODE(bt->cur)->left;
	return 0;
}

static int _bt_lastnode(BTREE* bt,u4 root){
	bt->cur = root;
	if(!bt->cur)
		return 1;
	while(NODE(bt->cur)->right)
		bt->cur = NODE(bt->cur)->right;
	return 0;
}

static void _bt_left_balance(BTREE* bt,u4 pn){
	u4 t2,t3,t4,t;
	int left = 0;
	u4 bn = NODE(pn)->left;

	t2 = pn; t4 = bn; t = NODE(t2)->parent;

	_bt_lastnode(bt,t4);
	t3 = bt->cur;

	if(t)
		left = (NODE(t)->left == t2);
	NODE(t2)->parent = t3;
	NODE(t2)->left = 0;
	NODE(t3)->right = t2;
	NODE(t4)->parent = t;
	if(t){
		if(left)
			NODE(t)->left = t4;
		else
			NODE(t)->right = t4;
	}
	if(t2 == bt->root)
		bt->root = t4;
	return;
}

static void _bt_right_balance(BTREE* bt,u4 pn){
	u4 t2,t3,t4,t;
	int left = 0;
	u4 bn = NODE(pn)->right;

	t2 = pn; t4 = bn; t = NODE(t2)->parent;

	_bt_firstnode(bt,t4);
	t3 = bt->cur;

	if(t)
		left = (NODE(t)->left == t2);
	NODE(t2)->parent = t3;
	NODE(t2)->right = 0;
	NODE(t3)->left = t2;
	NODE(t4)->parent = t;
	if(t){
		if(left)
			NODE(t)->left = t4;
		else
			NODE(t)->right = t4;
	}
	if(t2 == bt->root)
		bt->root = t4;
	return;
}

static u4 _bt_balance(BTREE* bt,u4 bn){
	int l,r;

	l = _bt_left_size(bt,bn);
	r = _bt_right_size(bt,bn);
	if(l-r > 1)
		_bt_left_balance(bt,bn);
	else if(r-l > 1)
		_bt_right_balance(bt,bn);

	return NODE(bn)->parent;
}

static void _bt_adjust(BTREE* bt,u4 node){
	if(NODE(node)->parent && NODE(NODE(node)->parent)->left == node
		&& NODE(node)->right && !NODE(node)->left){
		unsigned int t1 = node;
		unsigned int t5 = NODE(t1)->parent;
		unsigned int t3 = NODE(t1)->right;
		unsigned int t2;

		_bt_firstnode(bt,t3);
		t2 = bt->cur;

		NODE(t1)->parent = t2;
		NODE(t1)->right = 0;
		NODE(t3)->parent = t5;
		NODE(t5)->left = t3;
		NODE(t2)->left = t1;
	} else
	if(NODE(node)->parent && NODE(NODE(node)->parent)->right == node
		&& NODE(node)->left && !NODE(node)->right){
		unsigned int t9 = node;
		unsigned int t5 = NODE(t9)->parent;
		unsigned int t7 = NODE(t9)->left;
		unsigned int t8;

		_bt_lastnode(bt,t7);
		t8 = bt->cur;

		NODE(t9)->parent = t8;
		NODE(t9)->left = 0;
		NODE(t7)->parent = t5;
		NODE(t5)->right = t7;
		NODE(t8)->right = t9;
	}
}

static void _bt_free(BTREE* bt,u4 node){
	NODE(node)->parent = -(int)bt->fuu;
	bt->fuu = -(int)node;
}

static u4 _bt_getfuu(BTREE* bt){
	u4 r = -(int)bt->fuu;
	if(!r)
		return 0;
	bt->fuu = -(int)(NODE(r)->parent);
	return r;
}

BTREE* bt_create(int unique,int count,int size,int (*compare)(void* op,void* key1,void* key2,int* uniqfound)){
	BTREE* bt = (BTREE*)calloc(1,sizeof(BTREE));

	bt->unique = unique;
	bt->bt_compare = compare;
	bt->size = size;
	bt->count = count;
	bt->in = 0;

	if(bt->data == NULL){
		bt->data = calloc(count+1,(size+sizeof(BT_NODE)));
	}

	if(!bt->data){
		free(bt);
		bt = NULL;
	}
	return bt;
}

void bt_destroy(BTREE* bt){
	if(bt){
		if(bt->data)
			free(bt->data);
		free(bt);
	}
}

int bt_seek(BTREE* bt,void* op,void* key){
	u4* node = &bt->root;
	int r = 0;

	while(*node){
		r = bt->bt_compare(op,key,(void*)((uchar*)NODE(*node)+sizeof(BT_NODE)),NULL);
		bt->cur = *node;
		if(r==0){
			if(!bt->unique){
				while(!bt_prev(bt)){
					r = bt->bt_compare(op,key,bt_key(bt),NULL);
					if(r){
						bt_next(bt);
						break;
					}
				}
			}
			return 1;
		}
		if(r<0)
			node = &(NODE(*node)->left);
		else
			node = &(NODE(*node)->right);
	}
	if(r>0)
		bt_next(bt);
	return 0;
}

int bt_del(BTREE* bt){
	int l = 0, r = 0;
	u4 cur = bt->cur;
	int isroot = (cur == bt->root);
	u4 newroot,pn;
	int left = 0;

	if(!cur)
		return 1;

	pn = NODE(cur)->parent;
	if(!NODE(cur)->left && !NODE(cur)->right){
		if(NODE(cur)->parent){
			if(NODE(NODE(cur)->parent)->left == cur)
				NODE(NODE(cur)->parent)->left = 0;
			else
				NODE(NODE(cur)->parent)->right = 0;
			_bt_adjust(bt,NODE(cur)->parent);
		}
		newroot = 0;
	} else if(NODE(cur)->left && !NODE(cur)->right){
		unsigned int t2 = cur;
		unsigned int t1 = NODE(t2)->left;
		unsigned int t3 = NODE(t2)->parent;

		NODE(t1)->parent = t3;
		if(t3)
			NODE(t3)->left = t1;
		newroot = t1;
	} else if(NODE(cur)->right && !NODE(cur)->left){
		unsigned int t2 = cur;
		unsigned int t3 = NODE(t2)->right;
		unsigned int t1 = NODE(t2)->parent;

		NODE(t3)->parent = t1;
		if(t1)
			NODE(t1)->right = t3;
		newroot = t3;
	} else {
		if(NODE(bt->cur)->left)
			l = _bt_right_size(bt,NODE(cur)->left)+1;
		if(NODE(bt->cur)->right)
			r = _bt_left_size(bt,NODE(cur)->right)+1;

		if(l>=r){
			if(l==1){
				unsigned int t2 = cur;
				unsigned int t1 = NODE(cur)->left;
				unsigned int t3 = NODE(cur)->right;
				unsigned int t = NODE(cur)->parent;

				if(t)
					left = (NODE(t)->left == t2);
				NODE(t1)->parent = t;
				NODE(t1)->right = t3;
				if(t3)
					NODE(t3)->parent = t1;
				if(t){
					if(left)
						NODE(t)->left = t1;
					else
						NODE(t)->right = t1;
				}
				_bt_adjust(bt,t1);
				newroot = t1;
			} else {
				unsigned int t8 = cur,t7,t4,t6,t12,t;

				_bt_lastnode(bt,NODE(cur)->left);
				t7 = bt->cur;
				t4 = NODE(t8)->left;
				t12 = NODE(t8)->right;
				t6 = NODE(t7)->parent;
				t = NODE(cur)->parent;

				if(t)
					left = (NODE(t)->left == t8);
				NODE(t7)->left = t4;
				NODE(t7)->right = t12;
				NODE(t7)->parent = NODE(t8)->parent;
				NODE(t6)->right = 0;
				NODE(t4)->parent = t7;
				NODE(t12)->parent = t7;
				if(t){
					if(left)
						NODE(t)->left = t7;
					else
						NODE(t)->right = t7;
				}
				_bt_adjust(bt,t6);
				newroot = t7;
			}
		} else {
			if(r==1){
				unsigned int t2 = cur;
				unsigned int t1 = NODE(cur)->left;
				unsigned int t3 = NODE(cur)->right;
				unsigned int t = NODE(cur)->parent;

				if(t)
					left = (NODE(t)->left == t2);
				NODE(t3)->parent = NODE(t2)->parent;
				NODE(t3)->left = t1;
				if(t1)
					NODE(t1)->parent = t3;
				if(t){
					if(left)
						NODE(t)->left = t1;
					else
						NODE(t)->right = t1;
				}
				_bt_adjust(bt,t1);
				newroot = t3;
			} else {
				unsigned int t8 = cur,t9,t4,t10,t12,t;

				_bt_firstnode(bt,NODE(cur)->right);
				t9 = bt->cur;
				t12 = NODE(t8)->right;
				t4 = NODE(t8)->left;
				t10 = NODE(t9)->parent;
				t = NODE(cur)->parent;

				if(t)
					left = (NODE(t)->left == t8);

				NODE(t9)->left = t4;
				NODE(t9)->right = t12;
				NODE(t9)->parent = NODE(t8)->parent;
				NODE(t10)->left = 0;
				NODE(t12)->parent = t9;
				NODE(t4)->parent = t9;
				if(t){
					if(left)
						NODE(t)->left = t9;
					else
						NODE(t)->right = t9;
				}
				_bt_adjust(bt,t10);
				newroot = t9;
			}
		}
	}
	if(isroot)
		bt->root = newroot;
	_bt_free(bt,cur);
	while((pn = _bt_balance(bt,pn)));
	bt->in--;
	return 0;
}

int bt_add(BTREE* bt,void* op,void* key){
	u4 bn;
	u4* node = &bt->root;
	u4 parent = 0;
	int r,uniqfound;

	bn = _bt_getfuu(bt);
	bt->in++;
	if((u4)bt->in==bt->count){
		bt->count += bt->count >> 2;
		bt->data = realloc(bt->data,
			(bt->count+1)*(bt->size+sizeof(BT_NODE)));
	}
	if(!bn)
		bn = bt->in*(bt->size+sizeof(BT_NODE));
	memset((char*)NODE(bn),0,sizeof(BT_NODE));
	memcpy((char*)NODE(bn)+sizeof(BT_NODE),key,bt->size);
	while(*node){
		parent = *node;
		r = bt->bt_compare(op,key,(void*)((uchar*)NODE(*node)+sizeof(BT_NODE)),&uniqfound);
		if(bt->unique && !uniqfound)
			return 0;
		if(r<0)
			node = &(NODE(*node)->left);
		else
			node = &(NODE(*node)->right);
	}
	NODE(bn)->parent = parent;
	*node = bn;
	if(parent)
		_bt_adjust(bt,parent);
	while((bn = _bt_balance(bt,bn)));
	return 0;

}

int bt_first(BTREE* bt){
	return _bt_firstnode(bt,bt->root);
}

int bt_last(BTREE* bt){
	return _bt_lastnode(bt,bt->root);
}

int bt_next(BTREE* bt){
	u4 cur = bt->cur;

	if(!bt->cur)
		return 1;
	if(NODE(bt->cur)->right){
		_bt_firstnode(bt,NODE(bt->cur)->right);
	} else {
		while(NODE(bt->cur)->parent
			&& NODE(NODE(bt->cur)->parent)->right == bt->cur)

			bt->cur = NODE(bt->cur)->parent;
		if(!NODE(bt->cur)->parent){
			bt->cur = cur;
			return 1;
		}
		bt->cur = NODE(bt->cur)->parent;
	}
	return 0;
}

int bt_prev(BTREE* bt){
	u4 cur = bt->cur;

	if(!bt->cur)
		return 1;
	if(NODE(bt->cur)->left){
		_bt_lastnode(bt,NODE(bt->cur)->left);
	} else {
		while(NODE(bt->cur)->parent
			&& NODE(NODE(bt->cur)->parent)->left == bt->cur)

			bt->cur = NODE(bt->cur)->parent;
		if(!NODE(bt->cur)->parent){
			bt->cur = cur;
			return 1;
		}
		bt->cur = NODE(bt->cur)->parent;
	}
	return 0;
}

void* bt_key(BTREE* bt){
	return bt->cur?(void*)((uchar*)NODE(bt->cur)+sizeof(BT_NODE)):NULL;
}

static int _comp_uint(void* op,void* key1,void* key2,int* uniqfound){
	return *(u4*)key1 - *(u4*)key2;
}

static void destroy_btree(void* btree){
	bt_destroy((BTREE*)btree);
}

int clip_BT_CREATE(ClipMachine* cm){
	const char* __PROC__ = "BT_CREATE";
	u4 count = _clip_parni(cm,1);
	int itemsize = _clip_parni(cm,2);
	const char* type = _clip_parc(cm,3);
	BTREE* bt;
	int (*compare)(void* op,void* key1,void* key2,int* uniqfound) = NULL;
	int er;

	CHECKARG1(1,NUMERIC_t);
	CHECKOPT1(2,NUMERIC_t);
	CHECKOPT3(3,CHARACTER_t,CCODE_t,PCODE_t);

	if(_clip_parinfo(cm,2)==UNDEF_t)
		itemsize = 4;
	if(_clip_parinfo(cm,3)==UNDEF_t)
		type = "I";

	if(toupper(type[0]) == 'I' && itemsize == 4){
		compare = _comp_uint;
	}

	if(!compare){
		er = rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,er_unknowndata);
		goto err;
	}
	bt = bt_create(1,count,itemsize,compare);
	bt->type = toupper(type[0]);
	_clip_retni(cm,_clip_store_c_item(cm,bt,_C_ITEM_TYPE_BTREE,destroy_btree));
	return 0;
err:
	return er;
}

int clip_BT_FIELDFILL(ClipMachine* cm){
	const char* __PROC__ = "BT_FIELDFILL";
	BTREE* bt = _clip_fetch_c_item(cm,_clip_parni(cm,1),_C_ITEM_TYPE_BTREE);
	DBWorkArea* wa = cur_area(cm);
	u4 oldrecno;
	int oldbof,oldeof,fno,er;
	ClipVar v;

	CHECKWA(wa);
	CHECKARG1(1,NUMERIC_t);
	CHECKARG2(2,CHARACTER_t,NUMERIC_t);
	CHECKBTREE(bt);

	if(_clip_parinfo(cm,2) == NUMERIC_t){
		fno = _clip_parni(cm,2)-1;
	} else {
		int l;
		const char* fname = _clip_parcl(cm,2,&l);
		fno = _rdd_fieldno(wa->rd,_clip_casehashword(fname,l));
	}

	if(fno < 0 || fno >= wa->rd->nfields){
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_nofield);
		goto err;
	}
	oldrecno = wa->rd->recno;
	oldbof = wa->rd->bof;
	oldeof = wa->rd->eof;
	if((er = wa->rd->vtbl->gotop(cm,wa->rd,__PROC__))) goto err;
	while(!wa->rd->eof){
		if((er = wa->rd->vtbl->next(cm,wa->rd,1,__PROC__))) goto err;
		if(wa->rd->eof)
			break;
		if((er = wa->rd->vtbl->getvalue(cm,wa->rd,fno,&v,__PROC__))) goto err;
		if(bt->type == 'I'){
			u4 n = (u4)v.n.d;
			if(bt_add(bt,NULL,&n)){
				er = rdd_err(cm,-1,0,__FILE__,__LINE__,__PROC__,er_internal);
				goto err;
			}
		}
	}
	wa->rd->recno = oldrecno;
	wa->rd->bof = oldbof;
	wa->rd->eof = oldeof;
	if((er = rdd_childs(cm,wa->rd,__PROC__))) return er;
	return 0;
err:
	return er;
}

int clip_BT_INTERSECT(ClipMachine* cm){
	const char* __PROC__ = "BT_INTERSECT";
	BTREE* bt = _clip_fetch_c_item(cm,_clip_parni(cm,1),_C_ITEM_TYPE_BTREE);
	BTREE* b1 = _clip_fetch_c_item(cm,_clip_parni(cm,2),_C_ITEM_TYPE_BTREE);
	BTREE* b2 = _clip_fetch_c_item(cm,_clip_parni(cm,3),_C_ITEM_TYPE_BTREE);
	int e1=0,e2=0,er;
	u4 d1,d2;

	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,NUMERIC_t);
	CHECKARG1(3,NUMERIC_t);
	CHECKBTREE(bt);
	CHECKBTREE(b1);
	CHECKBTREE(b2);

	e1 = bt_first(b1);
	e2 = bt_first(b2);
	while(!e1 && !e2){
		d1 = *(u4*)bt_key(b1);
		d2 = *(u4*)bt_key(b2);
		if(d1==d2){
			if(bt_add(bt,NULL,&d1)){
				er = rdd_err(cm,-1,0,__FILE__,__LINE__,__PROC__,er_internal);
				goto err;
			}
			e1 = bt_next(b1);
			e2 = bt_next(b2);
		} else if(d1<d2){
			e1 = bt_next(b1);
		} else {
			e2 = bt_next(b2);
		}
	}
	return 0;
err:
	return er;
}

int clip_BT_COUNT(ClipMachine* cm){
	const char* __PROC__ = "BT_COUNT";
	BTREE* bt = _clip_fetch_c_item(cm,_clip_parni(cm,1),_C_ITEM_TYPE_BTREE);
	int er;

	CHECKBTREE(bt);
	_clip_retni(cm,bt->in);
	return 0;
err:
	return er;
}

int clip_BT_FIRST(ClipMachine* cm){
	const char* __PROC__ = "BT_FIRST";
	BTREE* bt = _clip_fetch_c_item(cm,_clip_parni(cm,1),_C_ITEM_TYPE_BTREE);
	int er;

	CHECKBTREE(bt);
	_clip_retl(cm,!bt_first(bt));
	return 0;
err:
	return er;
}

int clip_BT_LAST(ClipMachine* cm){
	const char* __PROC__ = "BT_LAST";
	BTREE* bt = _clip_fetch_c_item(cm,_clip_parni(cm,1),_C_ITEM_TYPE_BTREE);
	int er;

	CHECKBTREE(bt);
	_clip_retl(cm,!bt_last(bt));
	return 0;
err:
	return er;
}

int clip_BT_NEXT(ClipMachine* cm){
	const char* __PROC__ = "BT_NEXT";
	BTREE* bt = _clip_fetch_c_item(cm,_clip_parni(cm,1),_C_ITEM_TYPE_BTREE);
	int er;

	CHECKBTREE(bt);
	_clip_retl(cm,!bt_next(bt));
	return 0;
err:
	return er;
}

int clip_BT_PREV(ClipMachine* cm){
	const char* __PROC__ = "BT_PREV";
	BTREE* bt = _clip_fetch_c_item(cm,_clip_parni(cm,1),_C_ITEM_TYPE_BTREE);
	int er;

	CHECKBTREE(bt);
	_clip_retl(cm,!bt_prev(bt));
	return 0;
err:
	return er;
}

int clip_BT_DATA(ClipMachine* cm){
	const char* __PROC__ = "BT_DATA";
	BTREE* bt = _clip_fetch_c_item(cm,_clip_parni(cm,1),_C_ITEM_TYPE_BTREE);
	int er;

	CHECKBTREE(bt);

	if(bt->type == 'I'){
		u4* n = bt_key(bt);
		if(n){
			_clip_retni(cm,*n);
		}
	}
	return 0;
err:
	return er;
}

int clip_BT_ADD(ClipMachine* cm){
	const char* __PROC__ = "BT_ADD";
	BTREE* bt = _clip_fetch_c_item(cm,_clip_parni(cm,1),_C_ITEM_TYPE_BTREE);
	int er;

	CHECKBTREE(bt);

	if(bt->type == 'I'){
		u4 n = _clip_parni(cm,2);
		CHECKARG1(2,NUMERIC_t);

		if(bt_add(bt,NULL,&n)){
			er = rdd_err(cm,-1,0,__FILE__,__LINE__,__PROC__,er_internal);
			goto err;
		}
	}
	return 0;
err:
	return er;
}

int clip_BT_DEL(ClipMachine* cm){
	const char* __PROC__ = "BT_DEL";
	BTREE* bt = _clip_fetch_c_item(cm,_clip_parni(cm,1),_C_ITEM_TYPE_BTREE);
	int er;

	CHECKBTREE(bt);

	if(bt_del(bt)){
		er = rdd_err(cm,-1,0,__FILE__,__LINE__,__PROC__,er_internal);
		goto err;
	}
	return 0;
err:
	return er;
}

int clip_BT_DESTROY(ClipMachine* cm){
	const char* __PROC__ = "BT_DESTROY";
	int h = _clip_parni(cm,1);
	BTREE* bt = _clip_fetch_c_item(cm,h,_C_ITEM_TYPE_BTREE);
	int er;

	CHECKBTREE(bt);

	_clip_destroy_c_item(cm,h,_C_ITEM_TYPE_BTREE);
	return 0;
err:
	return er;
}
/* --------------------------------------------------------- */
static void* _bt_newpage(BTREE1* bt){
	char* page = calloc(1,bt->pagesize);
	short offs = 2*sizeof(short)+sizeof(void*)+bt->keysonpage*sizeof(short);
	int i;

	bt->memused++;
	for(i=0;i<bt->keysonpage;i++){
		*(short*)(page+2*sizeof(short)+sizeof(void*)+i*sizeof(short)) = offs;
		offs += bt->recsize;
	}
	return (void*)page;
}

BTREE1* bt1_create(int unique,int keysize,int (*compare)(void* op,void* key1,void* key2,int* uniqfound),int limit){
	BTREE1* bt;

	if(!limit)
		return NULL;

	bt = calloc(1,sizeof(BTREE1));

	bt->bt_compare = compare;
	bt->keysize = keysize;
	bt->recsize = keysize+sizeof(void*);
	bt->pagesize = getpagesize();
	bt->keysonpage = (bt->pagesize-2*sizeof(short)-sizeof(void*))/(bt->recsize+sizeof(short));
	bt->halfpage = bt->keysonpage/2;
	bt->root = _bt_newpage(bt);
	bt->cur = bt->root;
	bt->curpos = 0;
	bt->limit = (limit*1024*1024)/bt->pagesize;
	bt->unique = unique;
	return bt;
}

static int _bt1_search(BTREE1* bt,void* op,void* page,void* key,int* uniqfound){
	int i = 0;
	int c = 1;
	int l = 0;
	int h = NKEYS(page)-1;

	if(LEFT(page,0))
		h--;
	while(l<=h){
		i = (l+h)/2;
		c = bt->bt_compare(op,KEY(page,i),key,uniqfound);
		if(bt->unique && !*uniqfound)
			return 0;
		if(c<0)
			l = i+1;
		else if(c>0)
			h = i-1;
		else {
			break;
		}
	}
	if(!c || !LEFT(page,i)){
		bt->cur = page;
		bt->curpos = i;
		if(c<0)
			bt->curpos++;
	} else {
		if(c<0)
			i++;
		_bt1_search(bt,op,LEFT(page,i),key,uniqfound);
		if(bt->unique && !*uniqfound)
			return 0;
	}
	return !c;
}

int bt1_seek(BTREE1* bt,void* op,void* key){
	return _bt1_search(bt,op,bt->root,key,NULL);
}

static int _bt1_add(BTREE1* bt,void* page,short pos,void* key,void* left,void** lpar,short* lpos,void** rpar,short* rpos){
	short nkeys = NKEYS(page);
	short ipos = POS(page,nkeys);
	short i;

	memmove(&POS(page,pos+1),&POS(page,pos),
		sizeof(short)*(nkeys-pos));
	POS(page,pos) = ipos;
	memcpy(KEY(page,pos),key,bt->keysize);
	LEFT(page,pos) = left;
	(NKEYS(page))++;
	if(lpar){
		*lpar = *rpar = page;
		*lpos = *rpos = pos;//PARPOS(page);
		(*rpos)++;
	}
	if(LEFT(page,0)){
		for(i=pos+1;i<=nkeys;i++){
			PARPOS(LEFT(page,i)) = i;
		}
	}
	if(nkeys == bt->keysonpage-1){
		void* lp = _bt_newpage(bt);
		void* pp = PARENT(page);
		void *rrpar,*llpar;
		short rrpos,llpos;
		int i,j;

		for(i=0,j=bt->halfpage+1;i<=bt->halfpage;i++,j++){
			memcpy(KEY(lp,i),KEY(page,i),bt->recsize);
			if(j<=nkeys)
				memcpy(KEY(page,i),KEY(page,j),bt->recsize);
			if(LEFT(lp,i)){
				PARENT(LEFT(lp,i)) = lp;
				PARPOS(LEFT(lp,i)) = i;
				if(j<=nkeys)
					PARPOS(LEFT(page,i)) = i;
			}
		}
		if(!pp){
			bt->root = pp = _bt_newpage(bt);
			LEFT(pp,0) = page;
			NKEYS(pp) = 1;
		}
		if(pos/*PARPOS(page)*/ < bt->halfpage){
			if(lpar){
				*lpar = *rpar = lp;
				*lpos = *rpos = pos;//PARPOS(page);
				(*rpos)++;
			}
		} else if(pos/*PARPOS(page)*/ > bt->halfpage){
			if(lpar){
				*lpar = *rpar = page;
				*lpos = *rpos = pos/*PARPOS(page)*/ - bt->halfpage - 1;
				(*rpos)++;
			}
		} else {
			if(lpar){
				*lpar = lp;
				*rpar = page;
				*lpos = pos;//PARPOS(page);
				*rpos = 0;
			}
		}
		NKEYS(lp) = bt->halfpage + (LEFT(lp,0)!=0);
		NKEYS(page) = nkeys-bt->halfpage;
		if(_bt1_add(bt,pp,PARPOS(page),KEY(page,bt->halfpage),lp,&llpar,&llpos,&rrpar,&rrpos)) return 1;
		PARENT(lp) = llpar;
		PARPOS(lp) = llpos;
		PARENT(page) = rrpar;
		PARPOS(page) = rrpos;
	}
	return 0;
}

int bt1_add(BTREE1* bt,void* op,void* key){
	int uniqfound;
	if(bt->memused > bt->limit)
		return 1;
	if(_bt1_search(bt,op,bt->root,key,&uniqfound))
		return 1;
	if(bt->unique && !uniqfound)
		return 0;
	return _bt1_add(bt,bt->cur,bt->curpos,key,0,NULL,NULL,NULL,NULL);
}

static int _bt1_first(BTREE1* bt,void* root){
	bt->cur = root;
	while(LEFT(bt->cur,0))
		bt->cur = LEFT(bt->cur,0);
	bt->curpos = 0;
	return 0;
}

int bt1_first(BTREE1* bt){
	if(!bt->root || !NKEYS(bt->root))
			return 1;
	return _bt1_first(bt,bt->root);
}

static int _bt1_last(BTREE1* bt,void* root){
	bt->cur = root;
	while(LEFT(bt->cur,NKEYS(bt->cur)-1))
		bt->cur = LEFT(bt->cur,NKEYS(bt->cur)-1);
	bt->curpos = NKEYS(bt->cur)-1;
	return 0;
}

int bt1_last(BTREE1* bt){
	if(!NKEYS(bt->root))
		return 1;
	return _bt1_last(bt,bt->root);
}

int bt1_next(BTREE1* bt){
	if(!LEFT(bt->cur,0)){
		bt->curpos++;
		if(NKEYS(bt->cur)<=bt->curpos){
			bt->curpos = PARPOS(bt->cur);
			bt->cur = PARENT(bt->cur);
			while(bt->cur && NKEYS(bt->cur)-1 == bt->curpos){
				bt->curpos = PARPOS(bt->cur);
				bt->cur = PARENT(bt->cur);
			}
			if(!bt->cur)
				return 1;
		}
	} else {
		bt->curpos++;
		_bt1_first(bt,LEFT(bt->cur,bt->curpos));
	}
	return 0;
}

static int _bt1_destroy(BTREE1* bt,void* root){
	int i;
	if(LEFT(root,0)){
		for(i=0;i<NKEYS(root);i++){
			_bt1_destroy(bt,LEFT(root,i));
		}
	}
	free(root);
	return 0;
}

int bt1_destroy(BTREE1* bt){
	_bt1_destroy(bt,bt->root);
	free(bt);
	return 0;
}

void* bt1_key(BTREE1* bt){
	return KEY(bt->cur,bt->curpos);
}
