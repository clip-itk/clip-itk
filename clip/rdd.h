/*
	Copyright (C) 2001  ITK
	Author   : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: rdd.h,v $
	Revision 1.116  2002/10/11 10:33:10  clip
	rust: m6_IsOptimize()
	
	Revision 1.115  2002/10/01 13:16:51  clip
	rust: build filter list

	Revision 1.114  2002/09/25 13:17:03  clip
	rust: compatibility of INDEX ON behavior and some cleanups

	Revision 1.113  2002/09/17 09:54:21  clip
	rust: flex fpt

	Revision 1.112  2002/09/02 11:34:19  clip
	rust: rddsetfilter() with aliasing improved

	Revision 1.111  2002/08/30 10:16:35  clip
	rust: rddsetfilter(<handle>,<cFilter>,<aAliases>) (<aAliases> added)

	Revision 1.110  2002/08/26 11:41:30  clip
	rust: rdd_open() added

	Revision 1.109  2002/05/23 11:50:30  clip
	rust: low level locking compatiblity with clipper (NTX)

	Revision 1.108  2002/05/18 11:12:32  clip
	rust: clipper-style indexes locking (NTX)

	Revision 1.107  2002/05/15 09:42:29  clip
	rust: exclusive skip with optimization level 1

	Revision 1.106  2002/04/30 09:10:25  clip
	rust: 'X' field type support

	Revision 1.105  2002/04/27 13:23:34  clip
	rust: record buffering

	Revision 1.104  2002/04/24 13:33:28  clip
	rust: some cleanups

	Revision 1.103  2002/04/21 11:22:23  clip
	rust: added 2 elements to dbstruct - binary (5th) and nullable (6th)

	Revision 1.102  2002/04/19 12:19:00  clip
	rust: index on binary fields (VFP support)

	Revision 1.101  2002/04/19 10:48:36  clip
	rust: VFP support

	Revision 1.100  2002/04/19 08:36:05  clip
	rust: initial support of VFP DBF format, "VFPCDX" driver

	Revision 1.99  2002/04/17 12:21:18  clip
	rust: some fixes

	Revision 1.98  2002/04/16 14:56:02  clip
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

	Revision 1.97  2002/04/15 11:19:42  clip
	rust: CHECKOPT3 macros

	Revision 1.96  2002/04/08 08:22:12  clip
	rust: some fixes

	Revision 1.95  2002/04/03 09:37:43  clip
	rust: .DBF signature with various memo formats is corrected

	Revision 1.94  2002/03/21 12:29:32  clip
	rust: small fix

	Revision 1.93  2002/03/21 11:55:15  clip
	rust: big cleaning

	Revision 1.92  2002/03/15 14:16:04  clip
	rust: big cleaning

	Revision 1.91  2002/02/22 13:36:32  clip
	rust: Win32 locking bug

	Revision 1.90  2002/01/16 12:04:56  clip
	rust: some fixes

	Revision 1.89  2002/01/16 11:20:51  clip
	EG_OPEN with appropriate description
	rust

	Revision 1.88  2002/01/09 12:39:33  clip
	HiPer-SEEK started
	rust

	Revision 1.87  2002/01/04 12:27:14  clip
	some fixes
	rust

	Revision 1.86  2001/12/25 10:48:22  clip
	Sx_RollBack()
	rust

	Revision 1.85  2001/12/24 13:47:30  clip
	Sx_KillTag()
	rust

	Revision 1.84  2001/12/22 13:09:45  clip
	Virtual BOF
	rust

	Revision 1.83  2001/12/22 11:01:40  clip
	Sx_KeysIncluded()
	rust

	Revision 1.82  2001/12/22 10:01:21  clip
	some changes
	rust

	Revision 1.81  2001/12/12 15:34:09  clip
	SET LOCKSTYLE [TO] CLIPPER | CLIPPER50 | CLIPPER52 | CLIPPER53 | FOXPRO | SIX
	rust

	Revision 1.80  2001/12/12 13:30:09  clip
	Low level locking - DBF
	rust

	Revision 1.79  2001/12/10 09:21:21  clip
	Locking global reviewing...
	rust

	Revision 1.78  2001/12/06 13:53:46  clip
	Sx_IsDBT() (always .F.), Sx_IsFLocked(), Sx_IsLocked()
	rust

	Revision 1.77  2001/12/05 14:23:34  clip
	Sx_I_IndexName(), Sx_I_TagName(), Sx_IsReindex()
	rust

	Revision 1.76  2001/11/27 14:06:57  clip
	speed optimizations (exclusive skipping with index)
	rust

	Revision 1.75  2001/11/23 13:01:34  clip
	clip___RDDCOPY(), rdd_rawread(), rdd_rawwrite()
	rust

	Revision 1.74  2001/11/23 11:20:42  clip
	_rdd_(case)hashstr() -> _clip_(case)hashword()
	rust

	Revision 1.73  2001/11/20 14:10:42  clip
	WILDSEEK, WILDSEEKNEXT, rm_WildMatch()
	rust

	Revision 1.72  2001/11/11 14:46:23  clip
	'alltrim' all field, alias, tag names.
	Bug in rdd_create()
	rust

	Revision 1.71  2001/11/09 11:51:39  clip
	Six: rm_Chill(), rm_Freeze(), rm_Warm(), rm_Thermometer()
	rust

	Revision 1.70  2001/11/06 10:42:44  clip
	SIX: RDD_Count(), RDD_Info(), RDD_Name()
	rust

	Revision 1.69  2001/11/05 12:39:02  clip
	Date of last update in .dbf
	rust

	Revision 1.68  2001/10/30 08:41:38  clip
	many changes
	rust

	Revision 1.67  2001/10/24 12:12:08  clip
	Six: VariFields
	rust

	Revision 1.66  2001/10/24 08:48:47  clip
	Six types: V3, V4
	rust

	Revision 1.65  2001/10/23 12:01:34  clip
	rm_MemoPack()
	rust

	Revision 1.64  2001/10/22 12:07:05  clip
	many fixes and bugs :)
	rust

	Revision 1.63  2001/10/12 10:05:19  clip
	some fixes
	rust

	Revision 1.62  2001/10/10 15:04:58  clip
	many fixes
	rust

	Revision 1.61  2001/09/25 15:55:38  clip
	some changes
	rust

	Revision 1.60  2001/09/22 13:20:53  clip
	some optimizations
	rust

	Revision 1.59  2001/09/12 10:51:16  clip
	Quick dbCreateIndex() using BTree
	rust

	Revision 1.58  2001/09/04 09:41:44  clip
	rest of SIX functions
	rust

	Revision 1.57  2001/08/24 12:26:03  clip
	LOCATE with SET FILTER and LOCAL
	rust

	Revision 1.56  2001/08/23 14:45:56  clip
	Undepended indices (II_*** functions)
	rust

*/
#include "clip.h"
#include "hash.h"
#include "ordinfo.ch"

#ifdef CLIPPER50_COMPATIBLE
#define CHECKWA(wa) if(!wa || !wa->used) return 0;
#else
#define CHECKWA(wa) if(!wa || !wa->used) return rdd_err(cm,EG_NOTABLE,0,__FILE__,__LINE__,__PROC__,"Workarea not in use")
#endif

extern const char* bad_arg;

#define CHECKARG1(n,t) \
	if(_clip_parinfo(cm,n)!=t){ \
		char err[100]; \
		sprintf(err,bad_arg,n); \
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,err); \
		goto err; \
	}

#define CHECKARG2(n,t1,t2) \
	if(_clip_parinfo(cm,n)!=t1 && _clip_parinfo(cm,n)!=t2){ \
		char err[100]; \
		sprintf(err,bad_arg,n); \
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,err); \
		goto err; \
	}

#define CHECKARG3(n,t1,t2,t3) \
	if(_clip_parinfo(cm,n)!=t1 && _clip_parinfo(cm,n)!=t2 && _clip_parinfo(cm,n)!=t3){ \
		char err[100]; \
		sprintf(err,bad_arg,n); \
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,err); \
		goto err; \
	}

#define CHECKOPT1(n,t) \
	if((_clip_parinfo(cm,n)!=t)&&(_clip_parinfo(cm,n)!=UNDEF_t)){ \
		char err[100]; \
		sprintf(err,bad_arg,n); \
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,err); \
		goto err; \
	}

#define CHECKOPT2(n,t1,t2) \
	if((_clip_parinfo(cm,n)!=t1)&&(_clip_parinfo(cm,n)!=t2)&&(_clip_parinfo(cm,n)!=UNDEF_t)){ \
		char err[100]; \
		sprintf(err,bad_arg,n); \
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,err); \
		goto err; \
	}

#define CHECKOPT3(n,t1,t2,t3) \
	if((_clip_parinfo(cm,n)!=t1)&&(_clip_parinfo(cm,n)!=t2)&&(_clip_parinfo(cm,n)!=t3)&&(_clip_parinfo(cm,n)!=UNDEF_t)){ \
		char err[100]; \
		sprintf(err,bad_arg,n); \
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,err); \
		goto err; \
	}

#ifndef min
#define min(a,b) ((a)<(b)?(a):(b))
#endif
#ifndef max
#define max(a,b) ((a)>(b)?(a):(b))
#endif

#define _rm_setbit(m,b,r) ((r)<=(b))?((m)[((r)-1)>>5] = (m)[((r)-1)>>5] | (1<<((r-1)%32))):0
#define _rm_clrbit(m,b,r) ((r)<=(b))?((m)[((r)-1)>>5] = (m)[((r)-1)>>5] & ~(1<<((r-1)%32))):0
#define _rm_getbit(m,b,r) (((r)<=(b))?(((m)[((r)-1)>>5] & (1<<((r-1)%32)))):0)

#define RM_END_EXPR	0
#define RM_WORD		1
#define RM_LP		2
#define RM_RP		3
#define RM_OR		4
#define RM_AND		5
#define RM_LAR		6
#define RM_LARE		7
#define RM_LES		8
#define RM_LESE		9
#define RM_NEQU		10
#define RM_EQU		11
#define RM_EEQU		12
#define RM_NOT		13
#define RM_AL		14

#define RM_ERROR	100

#define MAX_BTREE_DEEP 64

#define DBFLS_CLIPPER53	0
#define DBFLS_SIX3		1

typedef struct
{
	unsigned char cmp[128];
	unsigned char upper[128];
	unsigned char lower[128];
	unsigned char read[128];
	unsigned char write[128];
}
DbfLocale;

typedef struct _RDD_FILE_ {
	int fd;
	caddr_t md;
	size_t mapsize;
} RDD_FILE;

typedef struct _RDD_STACK_ {
	unsigned int page;
	int pos;
} RDD_STACK;

struct _RDD_INDEX_;
struct _RDD_INDEX_VTBL_;
typedef struct _RDD_ORDER_ {
	char* name;
	int orderno;
	char* expr;
	unsigned int header;
	char simpexpr;	/* Simple expression (just a fieldname) */
	int simpfno;	/* No of key field (for simple expressions) */
	ClipVar block;	/* Compiled key expression */

	char type;
	char unique;
	char descend;
	char custom;
	char canadd;
	int keysize;
	int bufsize;
	int dec;
	short int fullpage;
	short int halfpage;

	struct _RDD_INDEX_* index;
	struct _RDD_INDEX_VTBL_* vtbl;

	char* scopetop;
	char* scopebottom;
	ClipVar scopetopvar;
	ClipVar scopebottomvar;

	char* cforexpr;
	ClipVar bforexpr;

	unsigned int keyno;
	char* key;
	char* foundkey;

	RDD_STACK stack[MAX_BTREE_DEEP];
	int level;
	char valid_stack;

	char binary;
	char wlocked;
	/* Independed indices */
	char* iikey;
	unsigned char id[12];
	char bof;
	char eof;
	int c_item;
} RDD_ORDER;

struct _RDD_DATA_;
typedef struct _RDD_INDEX_ {
	char* name;
	char* path;
	int indexno;
	ino_t inode;
	int structural;
	RDD_FILE file;
	RDD_ORDER** orders;
	int norders;
	DbfLocale* loc;
	struct _RDD_INDEX_VTBL_* vtbl;
	struct _RDD_DATA_* rd;
} RDD_INDEX;

struct _RDD_MEMO_VTBL_;
typedef struct _RDD_MEMO_ {
	char* name;
	char* path;
	RDD_FILE file;

	int blocksize;
	DbfLocale* loc;
	struct _RDD_MEMO_VTBL_* vtbl;
} RDD_MEMO;

typedef struct _RDD_FIELD_ {
	char type;
	char name[11];
	int len;
	int dec;
	int offs;
	char binary;
	char nullable;
} RDD_FIELD;

typedef struct _RDD_ORDSTATE_ {
	char* cForCondition;
	ClipVar bForCondition;
	int lAll;
	ClipVar bWhileCondition;
	ClipVar bEval;
	int nInterval;
	int nStart;
	int nNext;
	int nRecord;
	int lRest;
	int lDescend;
	int lAdditive;
	int lCurrent;
	int lCustom;
	int lNoOptimize;
} RDD_ORDSTATE;

struct _RDD_DATA_VTBL_;
struct _RDD_RELATION_;
struct _RDD_FILTER_;
typedef struct _RDD_DATA_ {
	char* name;
	char* path;

	int area;
	int rdhandle;

	struct _RDD_DATA_VTBL_* vtbl;

	DbfLocale* loc;

	RDD_ORDER** orders;
	int curord;
	int ords_opened;

	RDD_INDEX** indices;
	int idxs_opened;

	struct _RDD_RELATION_** relations;
	int rels_opened;

	RDD_MEMO* memo;

	RDD_FILE file;

	RDD_FIELD* fields;
	int nfields;
	HashTable* hashes;
	int nulloffs;

	struct _RDD_FILTER_* filter;
	char* yylval;
	char* ptr;
	char* word;
	int wlen;
	int curlex;
	char* rmfilter;
	int rmflen;

	int hdrsize;
	int recsize;

	char shared;
	char readonly;
	char tempo;

	char bof;
	char eof;
	char v_bof;
	unsigned int recno;

	char newrec;
	char flocked;

	unsigned int* locks;
	int nlocks;

	RDD_ORDSTATE os;

	ClipVar* locate_wpar;
	int locate_next;
	struct _RDD_FILTER_* locate_filter;

	char updated;

	char* indexing;
	char* tagindexing;
	int reindexing;
	unsigned int keysincluded;

	char lockstyle;
	char locked; /* fucking Win32 file locking */

	ClipVar** data;
	void* record;
	char valid;
	char changed; /* record */
	char x; /* 'X' field type */
} RDD_DATA;

typedef struct _RDD_FPS_ {
	ClipVar bfilter;
	int op;
} RDD_FPS;

typedef struct _RDD_FILTER_ {
	int handle;
	char active;
	char custom;
	char optimize;
	RDD_FPS* fps;
	int nfps;
	char* sfilter;
	unsigned int* rmap;
	int size;
	unsigned int* list;
	unsigned int listlen;
	unsigned int cursor;
	RDD_DATA* rd;
} RDD_FILTER;

typedef struct _RDD_RELATION_ {
	char* expr;
	char simpexpr;	/* Simple expression (just a fieldname) */
	int simpfno;	/* No of key field (for simple expressions) */
	ClipVar block;	/* Compiled key expression */
	int scoped;
	RDD_DATA* child;
} RDD_RELATION;

typedef struct _RDD_STRUCT_ {
	char name[11];
	char type;
	int len;
	int dec;
	char binary;
	char nullable;
} RDD_STRUCT;

struct _RDD_DATA_VTBL_;
typedef struct _RDD_DATA_VTBL_ {
	char id[4];
	char suff[5];
	char desc[81];
	int version;
	unsigned char dbfsig;
	unsigned char dbfwithmemosig;
	/* open/close */
	int (*open)		(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*close)	(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	/* create */
	int (*create)	(ClipMachine* cm,struct _RDD_DATA_VTBL_* vtbl,char* name,RDD_STRUCT* rddstru,int nfields,const char* __PROC__);
	int (*pack)		(ClipMachine* cm,RDD_DATA* rd,int tfd,const char* __PROC__);
	int (*zap)		(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	/* info */
	int (*lastrec)	(ClipMachine* cm,RDD_DATA* rd,int* lastrec,const char* __PROC__);
	int (*deleted)	(ClipMachine* cm,RDD_DATA* rd,int* deleted,const char* __PROC__);
	int (*lupdate)	(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	/* navigation */
	int (*gotop)	(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*gobottom) (ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*next)		(ClipMachine* cm,RDD_DATA* rd,int filtok,const char* __PROC__);
	int (*prev)		(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*go)		(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,const char* __PROC__);
	int (*rawgo)	(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,char valid_stack,const char* __PROC__);
	/* locking */
	int (*rlock)	(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int* r,const char* __PROC__);
	int (*flock)	(ClipMachine* cm,RDD_DATA* rd,int* r,const char* __PROC__);
	int (*ulock)	(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int flock,const char* __PROC__);
	int (*rlocked)	(ClipMachine* cm,RDD_DATA* rd,int* r,const char* __PROC__);
	/* low level locking */
	int (*_wlock)	(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*_rlock)	(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*_ulock)	(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	/* data */
	int (*append)	(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*getrecord)(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*getvalue)	(ClipMachine* cm,RDD_DATA* rd,int no,ClipVar* vp,const char* __PROC__);
	int (*setrecord)(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*setvalue)	(ClipMachine* cm,RDD_DATA* rd,int no,ClipVar* vp,int binary,const char* __PROC__);
	int (*getmemoid)(ClipMachine* cm,RDD_DATA* rd,int no,unsigned int* memoid,unsigned short int* vlen,const char* __PROC__);
	int (*setmemoid)(ClipMachine* cm,RDD_DATA* rd,int no,unsigned int memoid,const char* __PROC__);
	int (*delete)	(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*recall)	(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
	int (*info)		(ClipMachine* cm,RDD_DATA* rd,int cmd,const char* __PROC__);
	/* for filter optimization */
	int (*calcfiltlist)	(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
} RDD_DATA_VTBL;

typedef struct _RDD_INDEX_VTBL_ {
	char id[4];
	char suff[5];
	char desc[81];
	int version;
	char ismulti; /* is multi orderal RDD */
	/* open/close */
	int (*open)		(ClipMachine* cm,RDD_DATA* rd,RDD_INDEX* ri,const char* tag,const char* __PROC__);
	int (*close)	(ClipMachine* cm,RDD_DATA* rd,RDD_INDEX* ri,const char* __PROC__);
	int (*create)	(ClipMachine* cm,RDD_DATA* rd,RDD_INDEX* ri,RDD_ORDER** rop,const char* tag,const char* expr,ClipVar* block,int unique,int first,unsigned int header,const char* __PROC__);
	int (*reindex)	(ClipMachine* cm,RDD_DATA* rd,RDD_INDEX* ri,const char* __PROC__);
	int (*zap)		(ClipMachine* cm,RDD_DATA* rd,RDD_INDEX* ri,const char* __PROC__);
	/* navigation */
	int (*gotop)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__);
	int (*gobottom)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__);
	int (*next)		(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__);
	int (*prev)		(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__);
	int (*seek)		(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,ClipVar* v,int soft,int last,int* found,const char* __PROC__);
	int (*gotokey)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,unsigned int keyno,int* ok,const char* __PROC__);
	int (*descend)	(ClipMachine* cm,RDD_ORDER* ro,int descend,int* res,const char* __PROC__);
	int (*buildtree)(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__);
	/* update */
	int (*addkey)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,ClipVar* v,const char* __PROC__);
	int (*delkey)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__);
	int (*destroy)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__);
	/* format key */
	int (*formatkey)(ClipMachine* cm,RDD_ORDER* ro,ClipVar* v,void* res,const char* __PROC__);
	/* info */
	int (*keyno)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,int* keyno,const char* __PROC__);
	int (*lastkey)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,int* lastkey,const char* __PROC__);
	int (*info)		(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,int cmd,const char* __PROC__);
	int (*keyvalue)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,ClipVar* v,const char* __PROC__);
	/* rushmore */
	int (*setscope)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,ClipVar* top,ClipVar* bottom,unsigned int* map,int bytes,const char* __PROC__);
	/* Independed Indexes */
	int (*ii_create)	(ClipMachine* cm,RDD_INDEX* ri,const char* __PROC__);
	int (*ii_createtag)	(ClipMachine* cm,RDD_INDEX* ri,const char* tag,const char* expr,RDD_ORDER** rop,const char* __PROC__);
	int (*ii_open)		(ClipMachine* cm,RDD_INDEX* ri,const char* __PROC__);
	int (*ii_opentag)	(ClipMachine* cm,RDD_INDEX* ri,const char* tag,RDD_ORDER** rop,const char* __PROC__);
	int (*ii_addkey)	(ClipMachine* cm,RDD_ORDER* ro,const char* id,ClipVar* key,const char* __PROC__);
	int (*ii_delkey)	(ClipMachine* cm,RDD_ORDER* ro,const char* __PROC__);
	int (*ii_gotop)		(ClipMachine* cm,RDD_ORDER* ro,const char* __PROC__);
	int (*ii_gobottom)	(ClipMachine* cm,RDD_ORDER* ro,const char* __PROC__);
	int (*ii_id)		(ClipMachine* cm,RDD_ORDER* ro,ClipVar* v,const char* __PROC__);
	int (*ii_key)		(ClipMachine* cm,RDD_ORDER* ro,ClipVar* v,const char* __PROC__);
	int (*ii_next)		(ClipMachine* cm,RDD_ORDER* ro,const char* __PROC__);
	int (*ii_prev)		(ClipMachine* cm,RDD_ORDER* ro,const char* __PROC__);
	/* for filter optimization */
	int (*calcfiltlist)	(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__);
	/* index locks */
	int (*_rlock)		(ClipMachine* cm,RDD_ORDER* ro,const char* __PROC__);
	int (*_wlock)		(ClipMachine* cm,RDD_ORDER* ro,const char* __PROC__);
	int (*_ulock)		(ClipMachine* cm,RDD_ORDER* ro,const char* __PROC__);
} RDD_INDEX_VTBL;

typedef struct _RDD_MEMO_VTBL_ {
	char id[4];
	char suff[5];
	char desc[81];
	int version;
	int (*create)	(ClipMachine* cm,char* name,const char* __PROC__);
	int (*pack)		(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,int tmpfd,int bsize,ClipVar* block,int step,const char* __PROC__);
	int (*zap)		(ClipMachine* cm,RDD_MEMO* rm,const char* __PROC__);
	int (*open)		(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,const char* __PROC__);
	int (*close)	(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,const char* __PROC__);
	int (*getvalue)	(ClipMachine* cm,RDD_MEMO* rm,int id,ClipVar* vp,const char* __PROC__);
	int (*setvalue)	(ClipMachine* cm,RDD_MEMO* rm,int* id,ClipVar* vp,int binary,const char* __PROC__);
	int (*getvchar)	(ClipMachine* cm,RDD_MEMO* rm,int len,unsigned int id,char* buf,const char* __PROC__);
	int (*setvchar)	(ClipMachine* cm,RDD_MEMO* rm,int len,int oldlen,unsigned int* id,char* buf,const char* __PROC__);
	int (*info)		(ClipMachine* cm,RDD_DATA* rd,RDD_MEMO* rm,int cmd,const char* __PROC__);
} RDD_MEMO_VTBL;

typedef struct _RDD_PSEUDO_ {
	char* alias;
	char* name;
} RDD_PSEUDO;

void rdd_registerdatadriver(ClipMachine* cm,RDD_DATA_VTBL* vtbl);
void rdd_registerindexdriver(ClipMachine* cm,RDD_INDEX_VTBL* vtbl);
void rdd_registermemodriver(ClipMachine* cm,RDD_MEMO_VTBL* vtbl);
RDD_DATA_VTBL* rdd_datadriver(ClipMachine* cm,const char* driver,const char* __PROC__);
RDD_INDEX_VTBL* rdd_indexdriver(ClipMachine* cm,const char* driver,const char* __PROC__);
RDD_MEMO_VTBL* rdd_memodriver(ClipMachine* cm,const char* driver,const char* __PROC__);

void loc_read(DbfLocale* loc,unsigned char* buf,int len);
void loc_write(DbfLocale* loc,unsigned char* buf,int len);
int loc_cmp(DbfLocale* loc,unsigned char* s1,unsigned char* s2,int len);

inline unsigned int _rdd_uint(unsigned char s[]);
inline unsigned short int _rdd_ushort(unsigned char s[]);
inline void _rdd_put_uint(unsigned char s[],unsigned int v);
inline void _rdd_put_ushort(unsigned char s[],unsigned short int v);
inline unsigned int _rdd_backuint(unsigned char s[]);
inline unsigned short int _rdd_backushort(unsigned char s[]);
inline void _rdd_put_backuint(unsigned char s[],unsigned int v);
inline void _rdd_put_backushort(unsigned char s[],unsigned short int v);

int rdd_open(ClipMachine* cm,char* path,int readonly,int shared,int* fd,const char* __PROC__);

int rdd_err(ClipMachine* cm,int genCode,int osCode,const char* subSystem,
			 int line,const char* operation,const char* desc);

void rdd_expandmacro(int area,int r,const char* key,char* expr);

int rdd_calcfilter(ClipMachine* cm,RDD_DATA* rd,int* fok,const char* __PROC__);
int rdd_checkfilter(ClipMachine* cm,RDD_DATA* rd,int* ok,const char* __PROC__);
int rdd_childs(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
int rdd_checkifnew(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);

int rdd_event(ClipMachine* cm,int nEvent,int nArea,int nFieldPos,ClipVar* xTrigVal,int* re,const char* __PROC__);

int rdd_calc(ClipMachine* cm,int area,ClipVar* block,ClipVar* var,int noerror);
int rdd_takevalue(ClipMachine* cm,RDD_DATA* rd,int no,ClipVar* vv,const char* __PROC__);
int _rdd_fieldno(RDD_DATA* rd,long hash);

int _rdd_parsepath(ClipMachine* cm,const char* toopen,const char* suff,char** path,char** name,int oper,const char* __PROC__);

int rdd_read(ClipMachine* cm,RDD_FILE* file,int pos,int len,void* buf,const char* __PROC__);
int rdd_write(ClipMachine* cm,RDD_FILE* file,int pos,int len,void* buf,const char* __PROC__);
int rdd_trunc(ClipMachine* cm,RDD_FILE* file,unsigned int len,const char* __PROC__);

int rdd_create(ClipMachine* cm,const char* driver,const char* memo_driver,const char* name,ClipVar* stru,const char* __PROC__);
int rdd_creatememo(ClipMachine* cm,const char* driver,const char* name,const char* __PROC__);

int rdd_pack(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
int rdd_zap(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);

int rdd_usearea(ClipMachine* cm,const char* driver,const char* name,int shared,int readonly,int tempo,RDD_DATA** rdp,const char* __PROC__);
int rdd_setindex(ClipMachine* cm,RDD_DATA* rd,RDD_INDEX** rip,const char* driver,const char* name,const char* tag,const char* __PROC__);
int rdd_setmemo(ClipMachine* cm,RDD_DATA* rd,const char* driver,const char* name,const char* __PROC__);
int rdd_closearea(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);

int rdd_createindex(ClipMachine* cm,RDD_DATA* rd,const char* driver,const char* name,const char* tag,const char* expr,ClipVar* block,int unique,const char* __PROC__);
int rdd_reindex(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);

int rdd_setorder(ClipMachine* cm,RDD_DATA*rd,int order,const char* __PROC__);

int rdd_gotop(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
int rdd_gobottom(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
int rdd_skip(ClipMachine* cm,RDD_DATA* rd,int recs, const char* __PROC__);
int rdd_seek(ClipMachine* cm,RDD_DATA* rd,ClipVar* v,int soft,int last,int* found,const char* __PROC__);
int rdd_goto(ClipMachine* cm,RDD_DATA* rd,int rec,const char* __PROC__);
int rdd_gotokey(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,unsigned int keyno,int* ok,const char* __PROC__);

int rdd_bof(ClipMachine* cm,RDD_DATA* rd,int* bof,const char* __PROC__);
int rdd_eof(ClipMachine* cm,RDD_DATA* rd,int* eof,const char* __PROC__);
int rdd_recno(ClipMachine* cm,RDD_DATA* rd,int* recno,const char* __PROC__);
int rdd_lastrec(ClipMachine* cm,RDD_DATA* rd,int* lastrec,const char* __PROC__);
int rdd_keyno(ClipMachine* cm,RDD_DATA* rd,int* keyno,const char* __PROC__);
int rdd_lastkey(ClipMachine* cm,RDD_DATA* rd,int* lastkey,const char* __PROC__);
int rdd_fieldname(ClipMachine* cm,RDD_DATA* rd,int fno,const char* __PROC__);

int rdd_append(ClipMachine* cm,RDD_DATA* rd,int* neterr,const char* __PROC__);
int rdd_getvalue(ClipMachine* cm,RDD_DATA* rd,int no,const char* __PROC__);
int rdd_getvaluebn(ClipMachine* cm,RDD_DATA* rd,const char* fname,const char* __PROC__);
int rdd_setvalue(ClipMachine* cm,RDD_DATA* rd,int no,ClipVar* vp,const char* __PROC__);
int rdd_setvaluebn(ClipMachine* cm,RDD_DATA* rd,const char* fname,ClipVar* vp,const char* __PROC__);
int rdd_delete(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
int rdd_recall(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
int rdd_deleted(ClipMachine* cm,RDD_DATA* rd,int* deleted,const char* __PROC__);
int rdd_keyvalue(ClipMachine* cm,RDD_DATA* rd,ClipVar* v,const char* __PROC__);

int rdd_keyadd(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,ClipVar* v,const char* __PROC__);
int rdd_keydel(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__);

int rdd_orddestroy(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__);

int rdd_setrelation(ClipMachine* cm,RDD_DATA* rd,RDD_DATA* child,ClipVar* block,const char* expr,int scoped,const char* __PROC__);

int rdd_scopetop(ClipMachine* cm,RDD_DATA* rd,ClipVar* v,const char* __PROC__);
int rdd_scopebottom(ClipMachine* cm,RDD_DATA* rd,ClipVar* v,const char* __PROC__);

int rdd_createuserfilter(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER** fpp,unsigned int size,const char* __PROC__);
int rdd_createfilter(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER** fpp,ClipVar* _block,const char* str,ClipVar* pseudo,const char* __PROC__);

int rdd_clearindex(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
int rdd_destroyfilter(ClipMachine* cm,RDD_FILTER* fp,const char* __PROC__);
int rdd_clearfilter(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
int rdd_clearrelation(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);

int rdd_rlock(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int* r,const char* __PROC__);
int rdd_flock(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
int rdd_ulock(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int flock,const char* __PROC__);

int rdd_commit(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);

int rdd_dbread(ClipMachine* cm,RDD_DATA* rd,ClipVar* vp,const char* __PROC__);
int rdd_dbwrite(ClipMachine* cm,RDD_DATA* rd,ClipVar* ap,const char* __PROC__);

int rdd_locate(ClipMachine* cm,RDD_DATA* rd,char* cfor,ClipVar* fexpr,ClipVar* wexpr,ClipVar* vnext,ClipVar* vrec,ClipVar* vrest,int* found,const char* __PROC__);
int rdd_continue(ClipMachine* cm,RDD_DATA* rd,int* found,const char* __PROC__);

int rdd_wildseek(ClipMachine* cm,RDD_DATA* rd,const char* pattern,int cont,int* found,const char* __PROC__);

int rdd_ii_create(ClipMachine* cm,const char* driver,const char* name,const char* __PROC__);
int rdd_ii_createtag(ClipMachine* cm,int h,const char* tag,const char* expr,const char* __PROC__);
int rdd_ii_open(ClipMachine* cm,const char* driver,const char* name,const char* __PROC__);
int rdd_ii_opentag(ClipMachine* cm,int h,const char* tag,const char* __PROC__);
int rdd_ii_close(ClipMachine* cm,int h,const char* __PROC__);
int rdd_ii_closetag(ClipMachine* cm,int h,const char* __PROC__);
int rdd_ii_addkey(ClipMachine* cm,int h,const char* id,ClipVar* key,const char* __PROC__);
int rdd_ii_delkey(ClipMachine* cm,int h,const char* __PROC__);
int rdd_ii_gotop(ClipMachine* cm,int h,const char* __PROC__);
int rdd_ii_gobottom(ClipMachine* cm,int h,const char* __PROC__);
int rdd_ii_bof(ClipMachine* cm,int h,const char* __PROC__);
int rdd_ii_eof(ClipMachine* cm,int h,const char* __PROC__);
int rdd_ii_id(ClipMachine* cm,int h,const char* __PROC__);
int rdd_ii_key(ClipMachine* cm,int h,const char* __PROC__);
int rdd_ii_skip(ClipMachine* cm,int h,int recs,const char* __PROC__);

int rdd_rawread(ClipMachine* cm,RDD_DATA* rd,void* buf,const char* __PROC__);
int rdd_rawwrite(ClipMachine* cm,RDD_DATA* rd,void* buf,int append,const char* __PROC__);

void destroy_rdd_data(void*);
void destroy_rdd_index(void*);
void destroy_rdd_order(ClipMachine* cm,RDD_ORDER* ro);
void destroy_rdd_i_order(void* order);
void destroy_rdd_memo(RDD_MEMO* rm);
void destroy_ryo(void*);

int rdd_initrushmore(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER* fp,ClipVar* remap,int test,const char* __PROC__);
int rm_yylex(RDD_DATA* rd);
int rm_init(ClipMachine* cm,RDD_DATA* rd,char* str,const char* __PROC__);
unsigned int* rm_expr(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER* fp,int bytes,int* optimize,int npseudo,RDD_PSEUDO* pseudo,int test,const char* __PROC__);
int rm_checkjoin(ClipMachine* cm,RDD_FILTER* f1,RDD_FILTER* f2,const char* __PROC__);
int rm_union(ClipMachine* cm,RDD_FILTER* f1,RDD_FILTER* f2,const char* __PROC__);
int rm_intersect(ClipMachine* cm,RDD_FILTER* f1,RDD_FILTER* f2,const char* __PROC__);
int rm_difference(ClipMachine* cm,RDD_FILTER* f1,RDD_FILTER* f2,const char* __PROC__);
int rm_evalpartial(ClipMachine* cm,RDD_FILTER* fp,ClipVar* _block,unsigned int* ret,unsigned int* cnt,const char* __PROC__);
int rm_inverse(ClipMachine* cm,RDD_FILTER* fp,const char* __PROC__);
int rm_copyfilter(ClipMachine* cm,RDD_FILTER* fp,RDD_FILTER** ret,const char* __PROC__);
int rm_isfiltrec(ClipMachine* cm,RDD_FILTER* fp,unsigned int rec,int* r,const char* __PROC__);

DbfLocale* dbf_get_locale(ClipMachine* cm);

int _rdd_calcfiltlist(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
