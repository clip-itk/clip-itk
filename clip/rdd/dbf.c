/*
	Copyright (C) 2001  ITK
	Author  : Rushad Nabiullin <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log$
	Revision 1.2  2007/02/12 09:13:17  itk
	uri: many fixes for amd64
	
	Revision 1.1  2006/06/22 19:35:30  itk
	uri: init sf.net repository
	
	Revision 1.187  2006/02/27 11:54:10  clip
	rust: avoid some compilers' warnings
	
	Revision 1.186  2005/08/08 09:00:31  clip
	alena: fix for gcc 4

	Revision 1.185  2005/05/25 14:30:19  clip
	rust: failing DBCREATE() when file exists and USEd by another process

	Revision 1.184  2005/02/02 14:22:24  clip
	rust: minor fix for SET OPTIMIZE LEVEL 2

	Revision 1.183  2005/01/12 13:52:09  clip
	rust: major fix in dbf_ulock()

	Revision 1.182  2004/11/17 14:08:20  clip
	rust: "Duplicate field name" error message added

	Revision 1.181  2004/07/12 11:04:43  clip
	rust: unlink(filename) before creat() (fixes file permissions)

	Revision 1.180  2004/05/06 11:28:34  clip
	rust: fixed typo in dbf_close()

	Revision 1.179  2004/02/03 20:51:24  clip
	rust: debug output removed

	Revision 1.178  2004/02/03 09:48:33  clip
	rust: fix in _clip_close()

	Revision 1.177  2004/01/26 13:16:07  clip
	rust: small fix

	Revision 1.176  2003/12/19 09:27:43  clip
	rust: translation of field names from DBF_CHARSET

	Revision 1.175  2003/11/09 10:36:50  clip
	rust: signal() removed

	Revision 1.174  2003/10/13 09:23:03  clip
	rust: RLOCK() with USE ... READONLY

	Revision 1.173  2003/09/02 14:27:43  clip
	changes for MINGW from
	Mauricio Abre <maurifull@datafull.com>
	paul

	Revision 1.172  2003/07/16 09:03:54  clip
	rust: exclude deleted records from filter with OL2 and SET DELETED ON

	Revision 1.171  2003/06/21 08:54:47  clip
	rust: CMF (CLIP Memo File) with 64-bit file support started

	Revision 1.170  2003/06/17 09:00:16  clip
	rust: 'structural index present' attribute in .dbf header

	Revision 1.169  2003/06/13 12:07:04  clip
	uri: HZ, ������� ����

	Revision 1.168  2003/06/11 09:57:08  clip
	rust: speed up optimization level 2

	Revision 1.167  2003/06/10 10:27:54  clip
	rust: speed up optimization level 2

	Revision 1.166  2003/05/15 14:39:30  clip
	rust: some speed optimizations for relations

	Revision 1.165  2003/05/06 10:16:29  clip
	rust: extended 'bad datawidth' error message

	Revision 1.164  2003/05/06 09:59:08  clip
	rust: minor fixes and cleanings

	Revision 1.163  2003/04/30 13:53:12  clip
	rust: more compatible NTX and some speed optimizations

	Revision 1.162  2003/04/16 10:19:58  clip
	rust: #include "btree.h" -> "./btree.h" and some other fixes for BeOS

	Revision 1.161  2003/04/11 08:31:44  clip
	rust: #ifdef HAVE_MMAN_H (BeOS)

	Revision 1.160  2003/04/02 12:52:26  clip
	rust: small fix

	Revision 1.159  2003/04/02 10:53:20  clip
	rust: _clip_close() added

	Revision 1.158  2003/03/26 14:20:19  clip
	uri: small fix for round(0.644999999,2)

	Revision 1.157  2003/03/24 15:22:34  clip
	rust: no child moving on dbappend(), reported by M&MS <berezniki@smtp.ru>

	Revision 1.156  2003/03/21 11:49:40  clip
	rust: RDD locks with tasks (DOS compatibility)

	Revision 1.155  2003/03/12 12:50:43  clip
	rust: tasks share RDDs and subdrivers

	Revision 1.154  2003/03/04 10:36:08  clip
	rust: 'P', 'G' - always binary

	Revision 1.153  2003/03/04 10:31:24  clip
	rust: some cleanings

	Revision 1.152  2003/03/04 10:00:57  clip
	rust: bug in get_value() with DATE_t of 'X' type fixed

	Revision 1.151  2003/02/28 09:26:50  clip
	rust: checking record size in dbcreate()

	Revision 1.150  2003/02/23 17:18:34  clip
	rust: small fixes

	Revision 1.149  2003/02/22 11:18:44  clip
	rust: charset translation in getvalue() with 'V' field during indexing

	Revision 1.148  2003/02/10 13:05:41  clip
	rust: _SEEK_EVAL( <bBlock> ) (FlagShip extension)

	Revision 1.147  2003/01/31 11:52:00  clip
	rust: sx_islocked() with foreign locks, reported by druzus@polbox.com

	Revision 1.146  2003/01/20 13:47:49  clip
	rust: small changes

	Revision 1.145  2003/01/18 12:47:54  clip
	rust: dbseek() with DBFNTX bug fixed

	Revision 1.144  2003/01/18 11:34:03  clip
	rust: small bug in record buffering

	Revision 1.143  2003/01/14 13:01:26  clip
	rust: small fixes

	Revision 1.142  2003/01/14 09:50:37  clip
	rust: small fix in reading memo

	Revision 1.141  2003/01/13 15:25:02  clip
	rust: 'Y' type related bug fixed

	Revision 1.140  2003/01/13 12:32:13  clip
	rust: discern DBF-type on signature; FOXCDX driver added

	Revision 1.139  2003/01/04 11:59:21  clip
	rust: currency bug

	Revision 1.138  2002/11/28 12:27:20  clip
	rust: assigning NIL to 'X'-field fixed

	Revision 1.137  2002/11/26 10:21:23  clip
	OpenBSD fixes
	paul

	Revision 1.136  2002/11/04 10:44:07  clip
	rust: small fixes

	Revision 1.135  2002/10/26 11:10:02  clip
	initial support for localized runtime messages
	messages are in module 'cliprt'
	paul

	Revision 1.134  2002/09/20 09:06:41  clip
	rust: trim spaces in field name in dbf_create

	Revision 1.133  2002/09/05 13:49:23  clip
	rust: V4 processing fixed

	Revision 1.132  2002/09/05 11:26:25  clip
	rust: V3 date processing fixed

	Revision 1.131  2002/07/19 10:48:44  clip
	rust: FoxPro 2.* signature (dbf+fpt)

	Revision 1.130  2002/06/24 10:04:26  clip
	rust: memoid length == 10 characters

	Revision 1.129  2002/05/23 11:50:30  clip
	rust: low level locking compatiblity with clipper (NTX)

	Revision 1.128  2002/05/21 11:57:38  clip
	rust: small fix

	Revision 1.127  2002/05/21 11:51:37  clip
	rust: record buffer len ++

	Revision 1.126  2002/05/18 11:12:32  clip
	rust: clipper-style indexes locking (NTX)

	Revision 1.125  2002/05/15 09:42:29  clip
	rust: exclusive skip with optimization level 1

	Revision 1.124  2002/05/12 11:19:39  clip
	rust: some fixes

	Revision 1.123  2002/05/09 18:38:09  clip
	rust: another record buffering bug reported by P.Cherpak

	Revision 1.122  2002/05/08 08:47:36  clip
	rust: FreeBSD locking

	Revision 1.121  2002/05/06 10:50:11  clip
	rust: record buffering bug reported by P.Cherpak

	Revision 1.120  2002/04/30 13:55:50  clip
	rust: respecting 'type weight' for 'X' fields

	Revision 1.119  2002/04/30 09:10:25  clip
	rust: 'X' field type support

	Revision 1.118  2002/04/29 09:24:22  clip
	rust: record buffering with RDD mechanism

	Revision 1.117  2002/04/28 15:51:18  clip
	rust: 'X' field type - 'C','D','N' are implemented

	Revision 1.116  2002/04/27 13:20:57  clip
	rust: record buffering

	Revision 1.115  2002/04/24 13:33:28  clip
	rust: some cleanups

	Revision 1.114  2002/04/22 15:29:56  clip
	rust: initial support of DATETIME type

	Revision 1.113  2002/04/22 11:11:20  clip
	remove ncp code from rdd/dbf.c
	create ncp module
	add ncp usage in _file/diskutil _set_lock call
	paul

	Revision 1.112  2002/04/22 07:39:40  clip
	fix cvs conflict in dbf.c
	paul

	Revision 1.111  2002/04/19 11:30:08  clip
	rust: VFP fixes

	Revision 1.110  2002/04/19 11:11:59  clip
	rust: nullable fields can take NIL values now (VFP support)

	Revision 1.109  2002/04/19 10:48:36  clip
	rust: VFP support

	Revision 1.108  2002/04/19 08:36:05  clip
	rust: initial support of VFP DBF format, "VFPCDX" driver

	Revision 1.107  2002/04/18 13:11:56  clip
	initial support for ncpfs
	paul

	Revision 1.106  2002/04/17 12:21:59  clip
	rust: some fixes

	Revision 1.105  2002/04/16 14:56:02  clip
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

	Revision 1.104  2002/04/15 10:39:16  clip
	rust: debug function removed

	Revision 1.103  2002/04/08 08:22:12  clip
	rust: some fixes

	Revision 1.102  2002/04/03 09:37:44  clip
	rust: .DBF signature with various memo formats is corrected

	Revision 1.101  2002/04/03 08:30:59  clip
	rust: memo flag in header with VariFields

	Revision 1.100  2002/03/21 14:27:46  clip
	rust: error messages

	Revision 1.99  2002/03/17 13:59:54  clip
	rust: small fix

	Revision 1.98  2002/03/17 12:53:08  clip
	rust: big cleaning

	Revision 1.97  2002/03/15 14:16:04  clip
	rust: big cleaning

	Revision 1.96  2002/03/03 11:30:56  clip
	rust: small fix

	Revision 1.95  2002/02/23 22:30:11  clip
	rust: small typo

	Revision 1.94  2002/02/22 13:36:32  clip
	rust: Win32 locking bug

	Revision 1.93  2002/02/17 11:09:34  clip
	rust: small fix

	Revision 1.92  2002/02/15 11:31:00  clip
	rust: -O warnings cleanup

	Revision 1.91  2002/01/21 09:53:49  clip
	rust: minor changes

	Revision 1.90  2001/12/25 10:48:22  clip
	Sx_RollBack()
	rust

	Revision 1.89  2001/12/22 13:09:45  clip
	Virtual BOF
	rust

	Revision 1.88  2001/12/21 08:23:46  clip
	dbf_deleted() with recno==0
	rust

	Revision 1.87  2001/12/14 11:45:42  clip
	indexing speed optimization
	rust

	Revision 1.86  2001/12/12 15:34:09  clip
	SET LOCKSTYLE [TO] CLIPPER | CLIPPER50 | CLIPPER52 | CLIPPER53 | FOXPRO | SIX
	rust

	Revision 1.85  2001/12/12 13:30:09  clip
	Low level locking - DBF
	rust

	Revision 1.84  2001/12/10 14:02:38  clip
	New locking...
	rust

	Revision 1.83  2001/12/10 10:16:34  clip
	CygWin locking bug
	rust

	Revision 1.82  2001/12/10 09:21:22  clip
	Locking global reviewing...
	rust

	Revision 1.81  2001/12/06 13:53:46  clip
	Sx_IsDBT() (always .F.), Sx_IsFLocked(), Sx_IsLocked()
	rust

	Revision 1.80  2001/12/06 09:49:43  clip
	use readonly bug
	rust

	Revision 1.79  2001/11/30 12:09:07  clip
	CygWin bug
	rust

	Revision 1.78  2001/11/30 11:55:28  clip
	FLOCK() bug in CygWin
	rust

	Revision 1.77  2001/11/27 16:04:45  clip
	fix
	rust

	Revision 1.76  2001/11/27 14:06:57  clip
	speed optimizations (exclusive skipping with index)
	rust

	Revision 1.75  2001/11/23 14:01:26  clip
	speed optimizations
	rust

	Revision 1.74  2001/11/23 11:26:49  clip
	LUPDATE() fixes
	rust

	Revision 1.73  2001/11/23 11:20:43  clip
	_rdd_(case)hashstr() -> _clip_(case)hashword()
	rust

	Revision 1.72  2001/11/23 10:09:10  clip
	bug
	rust

	Revision 1.71  2001/11/23 10:08:08  clip
	some fixes
	rust

	Revision 1.70  2001/11/22 12:06:41  clip
	some fixes
	rust

	Revision 1.69  2001/11/19 11:07:56  clip
	fixes
	rust

	Revision 1.68  2001/11/17 13:11:48  clip
	some changes
	rust

	Revision 1.67  2001/11/11 14:46:23  clip
	'alltrim' all field, alias, tag names.
	Bug in rdd_create()
	rust

	Revision 1.66  2001/11/09 09:48:31  clip
	bug in dbf_append()
	rust

	Revision 1.65  2001/11/06 10:42:45  clip
	SIX: RDD_Count(), RDD_Info(), RDD_Name()
	rust

	Revision 1.64  2001/11/05 12:39:02  clip
	Date of last update in .dbf
	rust

	Revision 1.63  2001/10/30 12:36:18  clip
	bug in dbf_ulock()
	rust

	Revision 1.62  2001/10/30 12:03:20  clip
	locking
	rust

	Revision 1.61  2001/10/30 11:49:08  clip
	new locks
	rust

	Revision 1.60  2001/10/30 08:41:38  clip
	many changes
	rust

	Revision 1.59  2001/10/29 12:20:30  clip
	rust: F_UNLOCK fixed for cygwin

	Revision 1.58  2001/10/29 08:54:28  clip
	uri: dec >= len-1 in checking DBF structure

	Revision 1.57  2001/10/24 12:12:08  clip
	Six: VariFields
	rust

	Revision 1.56  2001/10/24 08:48:47  clip
	Six types: V3, V4
	rust

	Revision 1.55  2001/10/23 12:01:34  clip
	rm_MemoPack()
	rust

	Revision 1.54  2001/10/22 12:07:05  clip
	many fixes and bugs :)
	rust

	Revision 1.53  2001/10/16 13:22:50  clip
	optimizations
	rust

	Revision 1.52  2001/10/16 13:08:39  clip
	optimizations
	rust

	Revision 1.51  2001/10/16 11:15:01  clip
	speed optimizations
	rust

	Revision 1.50  2001/10/12 10:05:20  clip
	some fixes
	rust

	Revision 1.49  2001/10/10 15:04:58  clip
	many fixes
	rust

	Revision 1.48  2001/10/08 11:36:06  clip
	some fixes
	rust

	Revision 1.47  2001/10/05 13:43:41  clip
	some EXCLUSIVE optimizations
	rust

	Revision 1.46  2001/10/05 10:13:29  clip
	EG_DATAWIDTH is generated when trying to REPLACE wrong numeric value
	rust

	Revision 1.45  2001/09/28 07:15:18  clip
	no trailng space in .dbf
	rust

	Revision 1.44  2001/09/25 09:33:53  clip
	decimal_point="." (for compatibility with Clipper)
	rust

	Revision 1.43  2001/09/22 13:20:53  clip
	some optimizations
	rust

	Revision 1.42  2001/09/17 12:11:33  clip
	sync childs before skip using index
	rust

	Revision 1.41  2001/09/14 14:47:23  clip
	Ingnore SET RELATION in GO TO
	rust

	Revision 1.40  2001/09/06 12:44:27  clip
	bug in dbf_prev()
	rust

	Revision 1.39  2001/09/05 11:33:45  clip
	cygwin
	paul

	Revision 1.38  2001/09/05 11:19:30  clip
	cygwin
	paul

	Revision 1.37  2001/08/30 11:35:44  clip
	Optimize for shared mode
	rust

	Revision 1.36  2001/08/23 14:44:49  clip
	Logging started
	rust

*/
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <ctype.h>
#include <sys/file.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>
#include <limits.h>
#include "../rdd.h"
#include "./btree.h"
#include "error.ch"
#include "dbinfo.ch"
#ifdef HAVE_MMAN_H
#include <sys/mman.h>
#endif

#include "../ncp.h"

#ifdef USE_NCPFS
#define fcntl ncp_fcntl
#endif

typedef struct _DBF_HEADER_ {
	unsigned char version;
	unsigned char yy;
	unsigned char mm;
	unsigned char dd;
	unsigned char recs[4];
	unsigned char hdrsize[2];
	unsigned char recsize[2];
	unsigned char reserved1[2];
	unsigned char trans;
	unsigned char encrypted;
	unsigned char thread[4];
	unsigned char reserved2[8];
	unsigned char mdx;
	unsigned char lang;
	unsigned char reserved3[2];
} DBF_HEADER;

typedef struct _DBF_FIELD_ {
	char name[11];
	char type;
	unsigned char offs[4];
	union {
		char len[2];
		struct {
			char len;
			char dec;
		} num;
	} len;
	char flags;
	char flags2;
	char waid;
	char reserved2[2];
	char setfields;
	char reserved3[7];
	char indexed;
} DBF_FIELD;

static RDD_DATA_VTBL* dbf_vtbl();
static RDD_DATA_VTBL* vfp_vtbl();
static RDD_DATA_VTBL* fox_vtbl();

static int dbf_open(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_create(ClipMachine* cm,RDD_DATA_VTBL* vtbl,char* name,RDD_STRUCT* rddstru,int nfields,const char* __PROC__);
static int dbf_pack(ClipMachine* cm,RDD_DATA* rd,int tfd,const char* __PROC__);
static int dbf_zap(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_close(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_lastrec(ClipMachine* cm,RDD_DATA* rd,unsigned* lastrec,const char* __PROC__);
static int dbf_deleted(ClipMachine* cm,RDD_DATA* rd,int* deleted,const char* __PROC__);
static int dbf_gotop(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_gobottom(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_next(ClipMachine* cm,RDD_DATA* rd,int filtok,const char* __PROC__);
static int dbf_prev(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_goto(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,const char* __PROC__);
static int dbf_rawgoto(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,char valid_stack,const char* __PROC__);

static int dbf_rlock(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int* r,const char* __PROC__);
static int dbf_flock(ClipMachine* cm,RDD_DATA* rd,int* r,const char* __PROC__);
static int dbf_ulock(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int flock,const char* __PROC__);
static int dbf_rlocked(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int* r,const char* __PROC__);
static int dbf_forlock(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int* r,const char* __PROC__);
static int dbf__rlock(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf__wlock(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf__ulock(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);

static int dbf_append(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_getrecord(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_getvalue(ClipMachine* cm,RDD_DATA* rd,int no,ClipVar* vp,const char* __PROC__);
static int dbf_setrecord(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_setvalue(ClipMachine* cm,RDD_DATA* rd,int no,ClipVar* vp,int binary,const char* __PROC__);
static int dbf_getmemoid(ClipMachine* cm,RDD_DATA* rd,int no,unsigned int* memoid,unsigned short int* vlen,const char* __PROC__);
static int dbf_setmemoid(ClipMachine* cm,RDD_DATA* rd,int no,unsigned int memoid,const char* __PROC__);
static int dbf_delete(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_recall(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);

static int dbf_lupdate(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);
static int dbf_info(ClipMachine* cm,RDD_DATA* rd,int cmd,const char* __PROC__);
static int dbf_setstruct(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__);

static int dbf_calcfiltlist(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER* fp,const char* __PROC__);

static int vfp_create(ClipMachine* cm,RDD_DATA_VTBL* vtbl,char* name,RDD_STRUCT* rddstru,int nfields,const char* __PROC__);

static int dbf_verify(ClipMachine* cm,RDD_DATA* rd,int* r,const char* __PROC__);

#define  er_unlock          _clip_gettext("Unlock error")
#define  er_readlock        _clip_gettext("Shared lock error")
#define  er_writelock       _clip_gettext("Exclusive lock error")
#define  er_badheader       _clip_gettext("Table header corrupted")
#define  er_badstructure    _clip_gettext("Bad table structure")
#define  er_fielduplicate	_clip_gettext("Duplicate field name")
#define  er_notpermitted    _clip_gettext("Operation not permitted")
#define  er_corruption      _clip_gettext("Corruption detected")
#define  er_nomemo          _clip_gettext("Memo file not opened")
#define  er_baddata         _clip_gettext("Bad data")
#define  er_type            _clip_gettext("Type mismatch")
#define  er_ioerror         _clip_gettext("I/O error")

int clip_INIT_DBF(ClipMachine* cm){
	rdd_registerdatadriver(cm,dbf_vtbl());
	return 0;
}

int clip_INIT_VFP(ClipMachine* cm){
	rdd_registerdatadriver(cm,vfp_vtbl());
	return 0;
}

int clip_INIT_FOX(ClipMachine* cm){
	rdd_registerdatadriver(cm,fox_vtbl());
	return 0;
}

static RDD_DATA_VTBL* dbf_vtbl(){
	RDD_DATA_VTBL* vtbl = (RDD_DATA_VTBL*)malloc(sizeof(RDD_DATA_VTBL));

	memset(vtbl,0,sizeof(RDD_DATA_VTBL));
	strcpy(vtbl->id,"DBF");
	strcpy(vtbl->suff,".dbf");
	strcpy(vtbl->desc,"Generic DBF data files driver v0.0.1 (c) 2001 Copyright ITK Ltd.");
	vtbl->dbfsig = 0x03;
	vtbl->dbfwithmemosig = 0x83;

	vtbl->open          = dbf_open;
	vtbl->create        = dbf_create;
	vtbl->pack          = dbf_pack;
	vtbl->zap           = dbf_zap;
	vtbl->close         = dbf_close;
	vtbl->lastrec       = dbf_lastrec;
	vtbl->deleted       = dbf_deleted;
	vtbl->gotop         = dbf_gotop;
	vtbl->gobottom      = dbf_gobottom;
	vtbl->next          = dbf_next;
	vtbl->prev          = dbf_prev;
	vtbl->go            = dbf_goto;
	vtbl->rawgo         = dbf_rawgoto;
	vtbl->append        = dbf_append;
	vtbl->getrecord     = dbf_getrecord;
	vtbl->getvalue      = dbf_getvalue;
	vtbl->setrecord     = dbf_setrecord;
	vtbl->setvalue      = dbf_setvalue;
	vtbl->getmemoid     = dbf_getmemoid;
	vtbl->setmemoid     = dbf_setmemoid;
	vtbl->delete        = dbf_delete;
	vtbl->recall        = dbf_recall;
	vtbl->rlock         = dbf_rlock;
	vtbl->flock         = dbf_flock;
	vtbl->ulock         = dbf_ulock;
	vtbl->rlocked       = dbf_rlocked;
	vtbl->forlock       = dbf_forlock;
	vtbl->_rlock        = dbf__rlock;
	vtbl->_wlock        = dbf__wlock;
	vtbl->_ulock        = dbf__ulock;
	vtbl->lupdate       = dbf_lupdate;
	vtbl->info          = dbf_info;
	vtbl->setstruct     = dbf_setstruct;
	vtbl->verify        = dbf_verify;
	vtbl->calcfiltlist  = dbf_calcfiltlist;
	return vtbl;
}

static RDD_DATA_VTBL* vfp_vtbl(){
	RDD_DATA_VTBL* vtbl = (RDD_DATA_VTBL*)malloc(sizeof(RDD_DATA_VTBL));

	memset(vtbl,0,sizeof(RDD_DATA_VTBL));
	strcpy(vtbl->id,"VFP");
	strcpy(vtbl->suff,".dbf");
	strcpy(vtbl->desc,"Generic Visial FoxPro data files driver v0.0.1 (c) 2002 Copyright ITK Ltd.");
	vtbl->dbfsig = 0x30;
	vtbl->dbfwithmemosig = 0x30;

	vtbl->open          = dbf_open;
	vtbl->create        = vfp_create;
	vtbl->pack          = dbf_pack;
	vtbl->zap           = dbf_zap;
	vtbl->close         = dbf_close;
	vtbl->lastrec       = dbf_lastrec;
	vtbl->deleted       = dbf_deleted;
	vtbl->gotop         = dbf_gotop;
	vtbl->gobottom      = dbf_gobottom;
	vtbl->next          = dbf_next;
	vtbl->prev          = dbf_prev;
	vtbl->go            = dbf_goto;
	vtbl->rawgo         = dbf_rawgoto;
	vtbl->append        = dbf_append;
	vtbl->getrecord     = dbf_getrecord;
	vtbl->getvalue      = dbf_getvalue;
	vtbl->setrecord     = dbf_setrecord;
	vtbl->setvalue      = dbf_setvalue;
	vtbl->getmemoid     = dbf_getmemoid;
	vtbl->setmemoid     = dbf_setmemoid;
	vtbl->delete        = dbf_delete;
	vtbl->recall        = dbf_recall;
	vtbl->rlock         = dbf_rlock;
	vtbl->flock         = dbf_flock;
	vtbl->ulock         = dbf_ulock;
	vtbl->rlocked       = dbf_rlocked;
	vtbl->forlock       = dbf_forlock;
	vtbl->_rlock        = dbf__rlock;
	vtbl->_wlock        = dbf__wlock;
	vtbl->_ulock        = dbf__ulock;
	vtbl->lupdate       = dbf_lupdate;
	vtbl->info          = dbf_info;
	vtbl->setstruct     = dbf_setstruct;
	vtbl->verify        = dbf_verify;
	vtbl->calcfiltlist  = dbf_calcfiltlist;
	return vtbl;
}

static RDD_DATA_VTBL* fox_vtbl(){
	RDD_DATA_VTBL* vtbl = (RDD_DATA_VTBL*)malloc(sizeof(RDD_DATA_VTBL));

	memset(vtbl,0,sizeof(RDD_DATA_VTBL));
	strcpy(vtbl->id,"FOX");
	strcpy(vtbl->suff,".dbf");
	strcpy(vtbl->desc,"Generic FoxPro data files driver v0.0.1 (c) 2002 Copyright ITK Ltd.");
	vtbl->dbfsig = 0x03;
	vtbl->dbfwithmemosig = 0xF5;

	vtbl->open          = dbf_open;
	vtbl->create        = dbf_create;
	vtbl->pack          = dbf_pack;
	vtbl->zap           = dbf_zap;
	vtbl->close         = dbf_close;
	vtbl->lastrec       = dbf_lastrec;
	vtbl->deleted       = dbf_deleted;
	vtbl->gotop         = dbf_gotop;
	vtbl->gobottom      = dbf_gobottom;
	vtbl->next          = dbf_next;
	vtbl->prev          = dbf_prev;
	vtbl->go            = dbf_goto;
	vtbl->rawgo         = dbf_rawgoto;
	vtbl->append        = dbf_append;
	vtbl->getrecord     = dbf_getrecord;
	vtbl->getvalue      = dbf_getvalue;
	vtbl->setrecord     = dbf_setrecord;
	vtbl->setvalue      = dbf_setvalue;
	vtbl->getmemoid     = dbf_getmemoid;
	vtbl->setmemoid     = dbf_setmemoid;
	vtbl->delete        = dbf_delete;
	vtbl->recall        = dbf_recall;
	vtbl->rlock         = dbf_rlock;
	vtbl->flock         = dbf_flock;
	vtbl->ulock         = dbf_ulock;
	vtbl->rlocked       = dbf_rlocked;
	vtbl->forlock       = dbf_forlock;
	vtbl->_rlock        = dbf__rlock;
	vtbl->_wlock        = dbf__wlock;
	vtbl->_ulock        = dbf__ulock;
	vtbl->lupdate       = dbf_lupdate;
	vtbl->info          = dbf_info;
	vtbl->setstruct     = dbf_setstruct;
	vtbl->verify        = dbf_verify;
	vtbl->calcfiltlist  = dbf_calcfiltlist;
	return vtbl;
}

static int dbf_rlock(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int* r,const char* __PROC__){
	*r = 1;
	if(rd->shared){
		int i;

		for(i=0;i<rd->nlocks;i++){
			if(rd->locks[i]==rec)
				return 0;
		}
		if(!rd->flocked){
			if(_clip_setlock(cm,rd->file.filehash,rd->file.fd,
				(rd->lockstyle?0x10000000:1000000000)+rec,
				(rd->readonly?CLIP_LOCK_READ:CLIP_LOCK_WRITE) | CLIP_LOCK_HILEVEL))

				*r = 0;

			if(*r){
				rd->locks = realloc(rd->locks,(rd->nlocks+1)*sizeof(unsigned int));
				rd->locks[rd->nlocks] = rec;
				rd->nlocks++;
			}
		}
	}
	return 0;
}

static int dbf_flock(ClipMachine* cm,RDD_DATA* rd,int* r,const char* __PROC__){
	int er;

	*r = 1;
	if(rd->shared){
		int i;

		if(rd->flocked)
			return 0;
		for(i=0;i<rd->nlocks;i++)
			if((er = dbf_ulock(cm,rd,rd->locks[i],0,__PROC__))) return er;

		if(_clip_setlock(cm,rd->file.filehash,rd->file.fd,
			(rd->lockstyle?0x10000000:1000000000)+1,
			CLIP_LOCK_WRITE | CLIP_LOCK_FLOCK | CLIP_LOCK_HILEVEL))

			*r = 0;

		if(*r)
			rd->flocked = 1;
	}
	return 0;
}

static int dbf_ulock(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int flock,const char* __PROC__){
	if(rd->shared){
		int i;

		if(rec){
			for(i=0;i<rd->nlocks;i++){
				if(rd->locks[i]==rec)
					break;
			}
			if(i==rd->nlocks)
				return 0;
			if(!rd->flocked){
				if(_clip_unlock(cm,rd->file.filehash,rd->file.fd,
					(rd->lockstyle?0x10000000:1000000000)+rec,0))

					return rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,
						er_unlock);
			}
			rd->nlocks--;
			for(;i<rd->nlocks;i++)
				rd->locks[i] = rd->locks[i+1];
			rd->locks = realloc(rd->locks,rd->nlocks*sizeof(unsigned int));
		} else {
			if(rd->flocked){
				if(flock){
					if(_clip_unlock(cm,rd->file.filehash,rd->file.fd,
						(rd->lockstyle?0x10000000:1000000000)+1,
						CLIP_LOCK_FLOCK))

						return rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,
							er_unlock);

					rd->flocked = 0;
					rd->locks = realloc(rd->locks,0);
					rd->nlocks = 0;
				}
			} else {
				for(i=0;i<rd->nlocks;i++){
					if(_clip_unlock(cm,rd->file.filehash,rd->file.fd,
						(rd->lockstyle?0x10000000:1000000000)+rd->locks[i],0))

						return rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,
							er_unlock);
				}
				rd->locks = realloc(rd->locks,0);
				rd->nlocks = 0;
			}
		}
	}
	return 0;
}

static int dbf_rlocked(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int* r,const char* __PROC__){
	int i;

	*r = 1;
	if(!rd->shared)
		return 0;
	for(i=0;i<rd->nlocks;i++){
		if(rd->locks[i]==rec)
			break;
	}
	if(i==rd->nlocks)
		*r = 0;
	return 0;
}

static int dbf_forlock(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int* r,const char* __PROC__){
	*r = _clip_setlock(cm,rd->file.filehash,rd->file.fd,
		(rd->lockstyle?0x10000000:1000000000)+rec,
		CLIP_LOCK_WRITE | CLIP_LOCK_HILEVEL);
	if(!*r){
		if(_clip_unlock(cm,rd->file.filehash,rd->file.fd,
			(rd->lockstyle?0x10000000:1000000000)+rec,0))

			return rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,
				er_unlock);
	}
	return 0;
}

static int dbf__rlock(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	if(rd->shared){
		if(!rd->locked){
			if(_clip_setlock(cm,rd->file.filehash,rd->file.fd,
				rd->lockstyle?0x10000000:1000000000,
				CLIP_LOCK_READ | CLIP_LOCK_LOWLEVEL | CLIP_LOCK_WAIT))

				return rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,
					er_readlock);
		}
		rd->locked++;
	}
	rd->file.rlocked = 1;
	return 0;
}

static int dbf__wlock(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	if(rd->shared){
		if(!rd->locked){
			if(_clip_setlock(cm,rd->file.filehash,rd->file.fd,
				rd->lockstyle?0x10000000:1000000000,
				CLIP_LOCK_WRITE | CLIP_LOCK_LOWLEVEL | CLIP_LOCK_WAIT))

				return rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,
					er_writelock);
		}
		rd->locked++;
	}
	rd->file.wlocked = 1;
	return 0;
}

static int dbf__ulock(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	if(rd->shared){
		if(rd->locked==1){
			if(_clip_unlock(cm,rd->file.filehash,rd->file.fd,
				rd->lockstyle?0x10000000:1000000000,0))

				return rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,
					er_unlock);
		}
		rd->locked--;
	}
	rd->file.rlocked = 0;
	rd->file.wlocked = 0;
	return 0;
}

static int dbf_open(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	DBF_HEADER hdr;
	DBF_FIELD field;
	int i;
	int offs = 1;
	char* s;
	int er;

	if((er = rdd_read(cm,&rd->file,0,sizeof(DBF_HEADER),(char*)&hdr,__PROC__)))
		return er;
	rd->hdrsize = _rdd_ushort(hdr.hdrsize);
	rd->recsize = _rdd_ushort(hdr.recsize);
	rd->record = calloc(1,rd->recsize+1);
	rd->recno = 0;
	rd->bof = rd->v_bof = 0;
	rd->eof = 0;

	if((hdr.version!=0x03)&&(hdr.version!=0x83)&&(hdr.version!=0xF5)
		&&(hdr.version!=0x30))
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,
			er_badheader);

	rd->sig = hdr.version;

	if(rd->sig == 0x30) /* VFP */
		rd->nfields = (rd->hdrsize-263-sizeof(DBF_HEADER))/sizeof(DBF_FIELD);
	else
		rd->nfields = (rd->hdrsize-sizeof(DBF_HEADER))/sizeof(DBF_FIELD);
	rd->fields = (RDD_FIELD*)calloc(rd->nfields,sizeof(RDD_FIELD));
	for(i=0;i<rd->nfields;i++){
		if((er = rdd_read(cm,&rd->file,sizeof(DBF_HEADER)+sizeof(DBF_FIELD)*i,
			sizeof(DBF_FIELD),(char*)&field,__PROC__))) return er;
		if(field.type == '0'){
			rd->nulloffs = offs;
			rd->nfields--;
			rd->fields = (RDD_FIELD*)realloc(rd->fields,sizeof(RDD_FIELD)*rd->nfields);
			break;
		}
		rd->fields[i].type = field.type;
		strcpy(rd->fields[i].name,field.name);
		s = rd->fields[i].name+strlen(rd->fields[i].name);
		while(((--s) >= rd->fields[i].name) && *s == ' ') *s = 0;
		loc_read(rd->loc,(unsigned char *)(rd->fields[i].name),strlen(rd->fields[i].name));
		if(strchr("NBFYX",field.type)){
			if(field.type=='X')
				rd->x = 1;
			rd->fields[i].len = field.len.num.len;
			rd->fields[i].dec = field.len.num.dec;
		} else if(field.type == 'C'){
			rd->fields[i].len = _rdd_ushort((unsigned char *)(field.len.len));
			rd->fields[i].dec = 0;
		} else {
			rd->fields[i].len = field.len.num.len;
			rd->fields[i].dec = 0;
		}
		if(rd->sig == 0x30){ /* VFP */
			rd->fields[i].binary = (field.flags & 0x04) != 0;
			if(rd->fields[i].type == 'P')
				rd->fields[i].binary = 1;
			rd->fields[i].nullable = (field.flags & 0x02) != 0;
		}
		if(strchr("PG",rd->fields[i].type))
			rd->fields[i].binary = 1;
		rd->fields[i].offs = offs;
		offs += rd->fields[i].len;
		if(!HashTable_insert(rd->hashes,&rd->fields[i],
			_clip_casehashword(rd->fields[i].name,strlen(rd->fields[i].name)))){
			return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,
				er_badheader);
		}
	}
	return 0;
}

static int dbf_create(ClipMachine* cm,RDD_DATA_VTBL* vtbl,char* name,RDD_STRUCT* stru,int nfields,const char* __PROC__){
	RDD_FILE file;
	DBF_HEADER* hdr = malloc(sizeof(DBF_HEADER));
	char *chdr,*s;
	DBF_FIELD* fld;
	int i,offs;
	time_t ltm;
	struct tm *date;
	HashTable* hashes;
	int er;
	unsigned int recsize;

	memset(hdr,0,sizeof(DBF_HEADER));
	hdr->version = vtbl->dbfsig;
	for(i=0;i<nfields;i++)
		if(strchr("MPG",stru[i].type) ||
			(stru[i].type=='V' && stru[i].len != 3 && stru[i].len != 4))
		{
			hdr->version = vtbl->dbfwithmemosig;
			break;
		}
	ltm = time(NULL);
	date = gmtime(&ltm);
	hdr->yy = date->tm_year;
	hdr->mm = date->tm_mon+1;
	hdr->dd = date->tm_mday;
	_rdd_put_uint(hdr->recs,0);
	_rdd_put_ushort(hdr->hdrsize,sizeof(DBF_HEADER)+nfields*sizeof(DBF_FIELD)+2);
	recsize = 1;
	hdr = realloc(hdr,_rdd_ushort(hdr->hdrsize)+1);
	hashes = new_HashTable();
	offs = 1;
	for(i=0;i<nfields;i++){
		recsize += stru[i].len;
		fld = (DBF_FIELD*)((char*)hdr+sizeof(DBF_HEADER)+i*sizeof(DBF_FIELD));
		memset(fld,0,sizeof(DBF_FIELD));
		strncpy(fld->name,stru[i].name,10);
		for(s=fld->name;*s && *s!=' ';s++);
		*s = 0;
		loc_write(dbf_get_locale(cm),(unsigned char *)(fld->name),strlen(fld->name));
		fld->type = stru[i].type;
		if(stru[i].type == 'V' && stru[i].len!=3 && stru[i].len!=4 && stru[i].len<6){
			er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,
				er_badstructure);
			goto err;
		}
		_rdd_put_uint(fld->offs,offs);
		offs += stru[i].len;
		if(fld->type=='N'){
			if(stru[i].dec >= stru[i].len-(stru[i].dec!=0)){
				er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,
					er_badstructure);
				goto err;
			}
			fld->len.num.len = stru[i].len;
			fld->len.num.dec = stru[i].dec;
		} else if(fld->type=='X'){
			if(stru[i].len < 10 || stru[i].len > 127){
				er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,
					er_badstructure);
				goto err;
			}
			fld->len.num.len = stru[i].len;
			fld->len.num.dec = stru[i].dec;
		} else {
			_rdd_put_ushort((unsigned char *)(fld->len.len),stru[i].len);
		}
		if(!HashTable_insert(hashes,fld,_clip_casehashword(fld->name,strlen(fld->name)))){
			er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,
				er_fielduplicate);
			goto err;
		}
	}
	if(recsize > 0xffff){
		er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,
			er_badstructure);
		goto err;
	}
	_rdd_put_ushort(hdr->recsize,recsize);
	delete_HashTable(hashes);

	chdr = (char*)hdr;
	chdr[_rdd_ushort(hdr->hdrsize)-2] = 0x0D;
	chdr[_rdd_ushort(hdr->hdrsize)-1] = 0x00;
	chdr[_rdd_ushort(hdr->hdrsize)] = 0x1A;

	memset(&file,0,sizeof(RDD_FILE));
	file.md = (char*)-1;
	file.fd = _clip_creat(cm,name,O_RDWR,cm->fileCreateMode,1);
	if(file.fd==-1) goto err_create;
	if((er = rdd_write(cm,&file,0,_rdd_ushort(hdr->hdrsize)+1,(char*)hdr,__PROC__)))
		goto err;
	if(_clip_close(cm,_clip_hashstr(name),file.fd)==-1)
		goto err_create;

	free(hdr);
	return 0;
err_create:
	er = rdd_err(cm,EG_CREATE,errno,__FILE__,__LINE__,__PROC__,name);
err:
	free(hdr);
	return er;
}

static int vfp_create(ClipMachine* cm,RDD_DATA_VTBL* vtbl,char* name,RDD_STRUCT* stru,int nfields,const char* __PROC__){
	RDD_FILE file;
	DBF_HEADER* hdr = malloc(sizeof(DBF_HEADER));
	char *chdr,*s;
	DBF_FIELD* fld;
	int i,offs;
	time_t ltm;
	struct tm *date;
	HashTable* hashes;
	int nulls = 0,er;

	memset(hdr,0,sizeof(DBF_HEADER));
	hdr->version = vtbl->dbfsig;
	for(i=0;i<nfields;i++)
		if(strchr("MPG",stru[i].type) ||
			(stru[i].type=='V' && stru[i].len != 3 && stru[i].len != 4))
		{
			hdr->version = vtbl->dbfwithmemosig;
			break;
		}
	ltm = time(NULL);
	date = gmtime(&ltm);
	hdr->yy = date->tm_year;
	hdr->mm = date->tm_mon+1;
	hdr->dd = date->tm_mday;
	_rdd_put_uint(hdr->recs,0);
	_rdd_put_ushort(hdr->hdrsize,sizeof(DBF_HEADER)+nfields*sizeof(DBF_FIELD)+2+263);
	_rdd_put_ushort(hdr->recsize,1);
	hdr = realloc(hdr,_rdd_ushort(hdr->hdrsize)+1);
	hashes = new_HashTable();
	offs = 1;
	for(i=0;i<nfields;i++){
		if(stru[i].nullable)
			nulls  = 1;
		_rdd_put_ushort(hdr->recsize,_rdd_ushort(hdr->recsize)+stru[i].len);
		fld = (DBF_FIELD*)((char*)hdr+sizeof(DBF_HEADER)+i*sizeof(DBF_FIELD));
		memset(fld,0,sizeof(DBF_FIELD));
		strncpy(fld->name,stru[i].name,10);
		for(s=fld->name;*s && *s!=' ';s++);
		*s = 0;
		loc_write(dbf_get_locale(cm),(unsigned char *)(fld->name),strlen(fld->name));
		fld->type = stru[i].type;
		if(stru[i].type == 'V' && stru[i].len!=3 && stru[i].len!=4 && stru[i].len<6){
			er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,
				er_badstructure);
			goto err;
		}
		if(strchr("PG",stru[i].type))
			stru[i].binary = 1;
		_rdd_put_uint(fld->offs,offs);
		offs += stru[i].len;
		if(fld->type=='N'){
			if(stru[i].dec >= stru[i].len-(stru[i].dec!=0)){
				er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,
					er_badstructure);
				goto err;
			}
			fld->len.num.len = stru[i].len;
			fld->len.num.dec = stru[i].dec;
		} else if(fld->type=='X'){
			if(stru[i].len < 10 || stru[i].len > 127){
				er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,
					er_badstructure);
				goto err;
			}
			fld->len.num.len = stru[i].len;
			fld->len.num.dec = stru[i].dec;
		} else if(fld->type=='Y'){
			fld->len.num.len = 8;
			fld->len.num.dec = stru[i].dec;
		} else {
			_rdd_put_ushort((unsigned char *)(fld->len.len),stru[i].len);
		}
		fld->flags = (stru[i].binary?0x04:0)|(stru[i].nullable?0x02:0);
		if(!HashTable_insert(hashes,fld,_clip_casehashword(fld->name,strlen(fld->name)))){
			er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,
				er_fielduplicate);
			goto err;
		}
	}
	if(nulls){
		int len = (nfields+7)/8;
		_rdd_put_ushort(hdr->hdrsize,_rdd_ushort(hdr->hdrsize)+sizeof(DBF_FIELD));
		hdr = realloc(hdr,_rdd_ushort(hdr->hdrsize)+1);
		_rdd_put_ushort(hdr->recsize,_rdd_ushort(hdr->recsize)+len);
		fld = (DBF_FIELD*)((char*)hdr+sizeof(DBF_HEADER)+i*sizeof(DBF_FIELD));
		memset(fld,0,sizeof(DBF_FIELD));
		strcpy(fld->name,"_NullFlags");
		fld->type = '0';
		_rdd_put_uint(fld->offs,offs);
		fld->len.num.len = len;
		fld->len.num.dec = 0;
		fld->flags = 0x05;
	}
	delete_HashTable(hashes);

	chdr = (char*)hdr;
	chdr[_rdd_ushort(hdr->hdrsize)-2-263] = 0x0D;
	chdr[_rdd_ushort(hdr->hdrsize)-1-263] = 0x00;
	chdr[_rdd_ushort(hdr->hdrsize)] = 0x1A;

	memset(&file,0,sizeof(RDD_FILE));
	file.md = (char*)-1;
#ifdef _WIN32
	file.fd = open(name,O_CREAT|O_TRUNC|O_RDWR|O_BINARY,cm->fileCreateMode);
#else
	file.fd = open(name,O_CREAT|O_TRUNC|O_RDWR,cm->fileCreateMode);
#endif
	if(file.fd==-1) goto err_create;
	if((er = rdd_write(cm,&file,0,_rdd_ushort(hdr->hdrsize)+1,(char*)hdr,__PROC__)))
		goto err;
	if(close(file.fd)==-1) goto err_create;

	free(hdr);
	return 0;
err_create:
	er = rdd_err(cm,EG_CREATE,errno,__FILE__,__LINE__,__PROC__,name);
err:
	free(hdr);
	return er;
}

static int dbf_zap(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	DBF_HEADER hdr;
	char end = 0x1A;
	int er;

	if(rd->readonly)
		return rdd_err(cm,EG_READONLY,0,__FILE__,__LINE__,__PROC__,
			er_notpermitted);
	rd->updated = 1;
	if((er = rdd_read(cm,&rd->file,0,sizeof(DBF_HEADER),&hdr,__PROC__)))
		return er;
	_rdd_put_uint(hdr.recs,0);
	if((er = rdd_write(cm,&rd->file,0,sizeof(DBF_HEADER),&hdr,__PROC__)))
		return er;
	if((er = rdd_trunc(cm,&rd->file,_rdd_ushort(hdr.hdrsize)+1,__PROC__)))
		return er;
	if((er = rdd_write(cm,&rd->file,_rdd_ushort(hdr.hdrsize),1,&end,__PROC__)))
		return er;
	return 0;
}

static int dbf_close(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int i;
	unsigned int lastrec;
	DBF_HEADER hdr;
	char end = 0x1A;
	time_t ltm;
	struct tm *date;
	int er;

	for(i=0;i<rd->idxs_opened;i++){
		if((er = rd->indices[i]->vtbl->close(cm,rd,rd->indices[i],__PROC__)))
			return er;
	}
	if(rd->memo){
		if((er = rd->memo->vtbl->close(cm,rd,rd->memo,__PROC__))) return er;
		rd->memo = NULL;
	}
	if((er = rdd_read(cm,&rd->file,0,sizeof(DBF_HEADER),&hdr,__PROC__)))
		return er;
	if((er = dbf_lastrec(cm,rd,&lastrec,__PROC__))) return er;
	if(!rd->readonly && rd->updated){
		if(!rd->shared){
			if((er = rdd_trunc(cm,&rd->file,_rdd_ushort(hdr.hdrsize)+_rdd_ushort(hdr.recsize)*lastrec+1,__PROC__)))
				return er;
		}
		if((er = rdd_write(cm,&rd->file,_rdd_ushort(hdr.hdrsize)+_rdd_ushort(hdr.recsize)*lastrec,1,&end,__PROC__)))
			return er;
	}
	if(rd->updated){
		ltm = time(NULL);
		date = gmtime(&ltm);
		hdr.yy = date->tm_year<100?date->tm_year:date->tm_year-100;
		hdr.mm = date->tm_mon+1;
		hdr.dd = date->tm_mday;
		if((er = rdd_write(cm,&rd->file,1,3,&hdr.yy,__PROC__))) return er;
	}
/*
	if(_clip_unlock(cm,rd->file.filehash,rd->file.fd,0x7fffffff,0))
		return rdd_err(cm,EG_CLOSE,errno,__FILE__,__LINE__,__PROC__,
			er_unlock);
*/
	return 0;
}

static int dbf_lastrec(ClipMachine* cm,RDD_DATA* rd,unsigned* lastrec,const char* __PROC__){
	char recs[4];
	int er;
	struct stat st;

	if(rd->shared){
		fstat(rd->file.fd,&st);
		*lastrec = (st.st_size-rd->hdrsize)/rd->recsize;
	} else {
		if((er = rdd_read(cm,&rd->file,4,4,recs,__PROC__))) return er;
		*lastrec = _rdd_uint((unsigned char *)recs);
	}
	return 0;
}

static int dbf_deleted(ClipMachine* cm,RDD_DATA* rd,int* deleted,const char* __PROC__){
	int er;

	*deleted = 0;
	if(rd->recno == 0)
		return 0;
	if(!rd->valid)
		if((er = dbf_getrecord(cm,rd,__PROC__))) return er;
	*deleted = (((char*)rd->record)[0] != 0x20);
	return 0;
}

static int dbf_gotop(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	unsigned int lastrec;
	int res,deleted,er;

	if((er = dbf_lastrec(cm,rd,&lastrec,__PROC__))) return er;

	rd->bof = rd->v_bof = rd->eof = 0;

	if(rd->filter && rd->filter->list){
		if(rd->filter->listlen==0){
			rd->bof = rd->v_bof = rd->eof = 1;
			if((er = dbf_rawgoto(cm,rd,lastrec+1,0,__PROC__))) return er;
			rd->filter->cursor = 0;
		} else {
			rd->filter->cursor = -1;
			while(++rd->filter->cursor < rd->filter->listlen){
				if((er = dbf_rawgoto(cm,rd,rd->filter->list[rd->filter->cursor],
					0,__PROC__))) return er;
				if(!(cm->flags & DELETED_FLAG))
					return 0;
				if((er = rdd_deleted(cm,rd,&deleted,__PROC__))) return er;
				if(!deleted)
					return 0;
			}
			rd->eof = rd->bof = rd->v_bof = 1;
			if((er = dbf_rawgoto(cm,rd,lastrec+1,0,__PROC__))) return er;
		}
		return 0;
	}

	rd->recno = 1;

	if(rd->filter && rd->filter->rmap){
		while(rd->recno<=lastrec &&
			!_rm_getbit(rd->filter->rmap,rd->filter->size,rd->recno))
			rd->recno++;
	}
	if(lastrec==0 || rd->recno > lastrec){
		rd->eof = 1;
		rd->bof = rd->v_bof = (lastrec == 0);
		if((er = dbf_rawgoto(cm,rd,lastrec+1,0,__PROC__))) return er;
		return 0;
	}
	if((er = dbf_rawgoto(cm,rd,rd->recno,0,__PROC__))) return er;
	if((er = rdd_checkfilter(cm,rd,&res,__PROC__))) return er;
	if(!res){
		if((er = dbf_next(cm,rd,0,__PROC__))) return er;
		if(rd->eof){
			rd->bof = rd->v_bof =1;
			if((er = dbf_rawgoto(cm,rd,lastrec+1,0,__PROC__))) return er;
		}
		return 0;
	}
	return 0;
}

static int dbf_gobottom(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	unsigned int lastrec;
	int res,deleted,er;

	if((er = dbf_lastrec(cm,rd,&lastrec,__PROC__))) return er;
	rd->bof = rd->v_bof = rd->eof = 0;

	if(rd->filter && rd->filter->list){
		if(rd->filter->listlen==0){
			rd->bof = rd->v_bof =rd->eof = 1;
			if((er = dbf_rawgoto(cm,rd,lastrec+1,0,__PROC__))) return er;
			rd->filter->cursor = 0;
		} else {
			rd->filter->cursor = rd->filter->listlen;
			while(rd->filter->cursor > 0){
				if((er = dbf_rawgoto(cm,rd,rd->filter->list[--rd->filter->cursor],
					0,__PROC__))) return er;
				if(!(cm->flags & DELETED_FLAG))
					return 0;
				if((er = rdd_deleted(cm,rd,&deleted,__PROC__))) return er;
				if(!deleted)
					return 0;
			}
			rd->eof = rd->bof = rd->v_bof = 1;
			if((er = dbf_lastrec(cm,rd,&lastrec,__PROC__))) return er;
			if((er = dbf_rawgoto(cm,rd,lastrec+1,0,__PROC__))) return er;
		}
		return 0;
	}

	if(lastrec==0){
		rd->bof = rd->v_bof = rd->eof = 1;
		if((er = dbf_rawgoto(cm,rd,1,0,__PROC__))) return er;
		return 0;
	}

	rd->bof = rd->v_bof = rd->eof = 0;
	rd->recno = lastrec;
	if(rd->filter && rd->filter->rmap){
		while(rd->recno>=1 &&
			!_rm_getbit(rd->filter->rmap,rd->filter->size,rd->recno))
			rd->recno--;
	}
	if(rd->recno < 1){
		rd->eof = 1;
		if((er = dbf_rawgoto(cm,rd,lastrec+1,0,__PROC__))) return er;
		return 0;
	}
	if((er = dbf_rawgoto(cm,rd,rd->recno,0,__PROC__))) return er;

	if((er = rdd_checkfilter(cm,rd,&res,__PROC__))) return er;
	if(!res){
		if((er = dbf_prev(cm,rd,__PROC__))) return er;
		if(rd->bof){
			rd->eof = 1;
			if((er = dbf_rawgoto(cm,rd,lastrec+1,0,__PROC__))) return er;
		}
		return 0;
	}
	return 0;
}

static int dbf_next(ClipMachine* cm,RDD_DATA* rd,int filtok,const char* __PROC__){
	unsigned lastrec;
	int res,er,deleted;

	if(rd->eof) return 0;
	rd->bof = rd->v_bof = rd->eof = 0;

	if((er = dbf_lastrec(cm,rd,&lastrec,__PROC__))) return er;
	if(rd->filter && rd->filter->list){
		while(++rd->filter->cursor < rd->filter->listlen){
			if((er = dbf_rawgoto(cm,rd,rd->filter->list[rd->filter->cursor],
				0,__PROC__))) return er;
			if(!(cm->flags & DELETED_FLAG))
				return 0;
			if((er = rdd_deleted(cm,rd,&deleted,__PROC__))) return er;
			if(!deleted)
				return 0;
		}
		rd->eof = 1;
		if((er = dbf_rawgoto(cm,rd,lastrec+1,0,__PROC__))) return er;
		if(rd->filter->listlen==0){
			rd->bof = rd->v_bof = 1;
			rd->filter->cursor = 0;
		}
		return 0;
	}
	while(1){
		rd->recno++;
		if(rd->filter && rd->filter->rmap)
			while(rd->recno<=lastrec &&
				!_rm_getbit(rd->filter->rmap,rd->filter->size,rd->recno))
				rd->recno++;
		if((er = dbf_rawgoto(cm,rd,rd->recno,0,__PROC__))) return er;
		if(rd->recno>lastrec){
			rd->eof = 1;
			return 0;
		}
		if(filtok)
			break;
		if((er = rdd_checkfilter(cm,rd,&res,__PROC__))) return er;
		if(res)
			break;
	}
	return 0;
}

static int dbf_prev(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int res,deleted,er;
	unsigned lastrec;

	if(rd->bof) return 0;
	rd->bof = rd->v_bof =rd->eof = 0;

	if(rd->filter && rd->filter->list){
		int oldcursor = rd->filter->cursor;
		while(rd->filter->cursor > 0){
			if((er = dbf_rawgoto(cm,rd,rd->filter->list[--rd->filter->cursor],
				0,__PROC__))) return er;
			if(!(cm->flags & DELETED_FLAG))
				return 0;
			if((er = rdd_deleted(cm,rd,&deleted,__PROC__))) return er;
			if(!deleted)
				return 0;
		}
		rd->bof = rd->v_bof = 1;
		if(rd->filter->listlen==0){
			rd->eof = 1;
			if((er = dbf_lastrec(cm,rd,&lastrec,__PROC__))) return er;
			if((er = dbf_rawgoto(cm,rd,lastrec+1,0,__PROC__))) return er;
		} else {
			rd->filter->cursor = oldcursor;
			if((er = dbf_rawgoto(cm,rd,rd->filter->list[oldcursor],
				0,__PROC__))) return er;
		}
		return 0;
	}

	while(1){
		rd->recno--;
		if(rd->filter && rd->filter->rmap)
			while(rd->recno>0 &&
				!_rm_getbit(rd->filter->rmap,rd->filter->size,rd->recno))
				rd->recno--;
		if(rd->recno<=0){
			if((er = dbf_gotop(cm,rd,__PROC__))) return er;
			rd->bof = rd->v_bof =1;
			return 0;
		}
		if((er = dbf_rawgoto(cm,rd,rd->recno,0,__PROC__))) return er;
		if((er = rdd_checkfilter(cm,rd,&res,__PROC__))) return er;
		if(res)
			break;
	}
	return 0;
}

static int dbf_rawgoto(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,char valid_stack,const char* __PROC__){
	int er;

	if(rd->valid && rd->changed)
		if((er = dbf_setrecord(cm,rd,__PROC__))) return er;
	rd->valid = 0;
	rd->recno = rec;
	if(rd->curord >= 0)
		rd->orders[rd->curord]->valid_stack = valid_stack;
	return rdd_childs(cm,rd,__PROC__);
}

static int dbf_goto(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,const char* __PROC__){
	unsigned lastrec;
	int er;

/*	printf("goto %d\n? 'goto %d',recno(),bof()\n",rec,rec);*/
	if((er = dbf_lastrec(cm,rd,&lastrec,__PROC__))) return er;

	rd->recno = rec;
	rd->bof = rd->v_bof = rd->eof = 0;
	if((rec<1)||(rec>lastrec)){
		rd->v_bof = rd->eof = 1;
		rd->recno = lastrec+1;
	}
	return dbf_rawgoto(cm,rd,rd->recno,0,__PROC__);
}

static int dbf_append(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	char recs[4];
	unsigned lastrec, flen;
	int i, er;

	if(rd->readonly){
		er = rdd_err(cm,EG_READONLY,0,__FILE__,__LINE__,__PROC__,
			er_notpermitted);
		goto err;
	}
	if((er = dbf_lastrec(cm,rd,&lastrec,__PROC__))) goto err;
	rd->recno = lastrec+1;
	if(rd->curord >= 0)
		rd->orders[rd->curord]->valid_stack = 0;
	rd->updated = 1;

	if(!rd->shared){
		flen = rd->hdrsize+rd->recsize*(lastrec+1)+1;
		if(rd->file.md!=(caddr_t)-1){
			if(flen>rd->file.mapsize){
				int delta = lastrec/5;
				if((er = rdd_write(cm,&rd->file,rd->hdrsize+rd->recsize*(lastrec+1+delta)-1,
					1,"",__PROC__))) goto err;
			}
		}
	}

	if(rd->sig != 0x30){
		memset(rd->record,32,rd->recsize);
		for(i=0;i<rd->nfields;i++)
			if(rd->fields[i].type == 'V' || rd->fields[i].type == 'X')
				memset(rd->record+rd->fields[i].offs,0,rd->fields[i].len);
	}
	((char*)rd->record)[0] = 0x20;
	((char*)rd->record)[rd->recsize] = 0x1a;
	rd->valid = 1;
	rd->changed = 0;
	lastrec++;
	_rdd_put_uint((unsigned char *)recs,lastrec);
	if((er = rdd_write(cm,&rd->file,rd->hdrsize+rd->recsize*(lastrec-1),
		rd->recsize+1,rd->record,__PROC__))) goto err;
	if((er = rdd_write(cm,&rd->file,4,4,recs,__PROC__))) goto err;
	rd->bof = rd->v_bof = rd->eof = 0;
	return 0;
err:
	return er;
}

static int dbf_getmemoid(ClipMachine* cm,RDD_DATA* rd,int no,unsigned int* memoid,unsigned short int* vlen,const char* __PROC__){
	char memo[11];
	int er;

	*memoid = 0;
	if(strchr("MPG",rd->fields[no].type)){
		if(rd->sig != 0x30){
			if((er = rdd_read(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1)+
				rd->fields[no].offs,10,memo,__PROC__))) return er;
			memo[10] = 0;
			*memoid = atoi(memo);
		} else {
			if((er = rdd_read(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1)+
				rd->fields[no].offs,4,memo,__PROC__))) return er;
			*memoid = _rdd_uint((unsigned char *)memo);
		}
	} else if(rd->fields[no].type == 'V'){
		if((er = rdd_read(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1)+
			rd->fields[no].offs+rd->fields[no].len-6,4,memo,__PROC__)))
			return er;
		*memoid = _rdd_uint((unsigned char *)memo);
		if(vlen){
			if((er = rdd_read(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1)+
				rd->fields[no].offs+rd->fields[no].len-2,2,memo,__PROC__)))
				return er;
			*vlen = _rdd_ushort((unsigned char *)memo);
		}
	} else {
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,
			er_corruption);
	}
	return 0;
}

static int dbf_setmemoid(ClipMachine* cm,RDD_DATA* rd,int no,unsigned int memoid,const char* __PROC__){
	char memo[11];
	int er;

	if(rd->readonly)
		return rdd_err(cm,EG_READONLY,0,__FILE__,__LINE__,__PROC__,
			er_notpermitted);
	rd->updated = 1;
	if(strchr("MPG",rd->fields[no].type)){
		if(rd->sig != 0x30){
			snprintf(memo,sizeof(memo),"%d",memoid);
			if((er = rdd_write(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1)+
				rd->fields[no].offs,10,memo,__PROC__))) return er;
		} else {
			_rdd_put_uint((unsigned char *)memo,memoid);
			if((er = rdd_write(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1)+
				rd->fields[no].offs,4,memo,__PROC__))) return er;
		}
	} else if(rd->fields[no].type == 'V'){
		_rdd_put_uint((unsigned char *)memo,memoid);
		if((er = rdd_write(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1)+
			rd->fields[no].offs+rd->fields[no].len-6,4,memo,__PROC__)))
			return er;
	} else {
		return rdd_err(cm,EG_CORRUPTION,0,__FILE__,__LINE__,__PROC__,
			er_corruption);
	}
	return 0;
}

static int dbf_getrecord(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	rd->valid = 1;
	return rdd_read(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1),
		rd->recsize,rd->record,__PROC__);
}

static int dbf_setrecord(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	rd->changed = 0;
	return rdd_write(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1),
		rd->recsize,rd->record,__PROC__);
}

static int dbf_verify(ClipMachine* cm,RDD_DATA* rd,int* r,const char* __PROC__){
	void* buf = malloc(rd->recsize);
	int er;

	if(!rd->valid){
		if((er = dbf_getrecord(cm,rd,__PROC__))) return er;
		*r = 1;
		return 0;
	}
	if((er = rdd_read(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1),
		rd->recsize,buf,__PROC__))) return er;
	*r = !memcmp(rd->record,buf,rd->recsize);
	return 0;
}

static int dbf_getvalue(ClipMachine* cm,RDD_DATA* rd,int no,ClipVar* vp,const char* __PROC__){
	char* str;
	char l;
	char date[9];
	int yy=0,mm=0,dd=0;
	char memo[11];
	int er;

	if(!rd->valid)
		if((er = dbf_getrecord(cm,rd,__PROC__))) return er;

	if(rd->fields[no].nullable){
		int nbyte = no>>3;
		unsigned char byte;

		memcpy(&byte,(char*)rd->record+rd->nulloffs+nbyte,1);
		if(byte & (1 << (no - (nbyte << 3)))){
			memset(vp,0,sizeof(ClipVar));
			return 0;
		}
	}
	switch(rd->fields[no].type){
		case 'C':
			vp->t.type = CHARACTER_t;
			vp->t.flags = F_NONE;
			vp->t.memo = 0;
			str = (char*)malloc(rd->fields[no].len+1);
			memcpy(str,(char*)rd->record+rd->fields[no].offs,rd->fields[no].len);
			str[rd->fields[no].len] = 0;
			vp->s.str.buf = str;
			vp->s.str.len = rd->fields[no].len;
			if(!rd->fields[no].binary)
				loc_read(rd->loc,(unsigned char *)(vp->s.str.buf),vp->s.str.len);
			break;
		case 'M':
		case 'P':
		case 'G':
			vp->t.type = CHARACTER_t;
			vp->t.flags = F_NONE;
			vp->t.memo = 1;
			if(rd->memo){
				if(rd->sig != 0x30){ /* Not VFP */
					memcpy(memo,(char*)rd->record+rd->fields[no].offs,10);
					memo[10] = 0;
					if((er = rd->memo->vtbl->getvalue(cm,rd->memo,atoi(memo),vp,__PROC__)))
						return er;
				} else {
					memcpy(memo,(char*)rd->record+rd->fields[no].offs,4);
					if((er = rd->memo->vtbl->getvalue(cm,rd->memo,
						_rdd_uint((unsigned char *)memo),vp,__PROC__)))
						return er;
				}
			} else {
				vp->s.str.buf = strdup("!!! Memo file not opened");
				vp->s.str.len = 24;
			}
			break;
		case 'N':
		case 'F': /* Visual FoxPro type */
			vp->t.type = NUMERIC_t;
			vp->t.flags = F_NONE;
			vp->t.memo = 0;
			str = (char*)malloc(rd->fields[no].len+1);
			str[rd->fields[no].len] = 0;
			memcpy(str,(char*)rd->record+rd->fields[no].offs,rd->fields[no].len);
			vp->n.d = _clip_strtod(str,&yy);
			free(str);
			vp->t.len = rd->fields[no].len;
			vp->t.dec = rd->fields[no].dec;
			break;
		case 'D':
			vp->t.type = DATE_t;
			vp->t.flags = F_NONE;
			vp->t.memo = 0;
			memcpy(date,(char*)rd->record+rd->fields[no].offs,rd->fields[no].len);
			if(!isdigit(date[0])){
				dd = 0;
			} else {
				dd = (date[7]-'0');
				dd += (date[6]-'0')*10;
				mm = (date[5]-'0');
				mm += (date[4]-'0')*10;
				yy = (date[3]-'0');
				yy += (date[2]-'0')*10;
				yy += (date[1]-'0')*100;
				yy += (date[0]-'0')*1000;
			}
			if(dd)
				vp->d.julian = _clip_jdate(dd,mm,yy);
			else
				vp->d.julian = 0;
			break;
		case 'V':
		{
			if(rd->fields[no].len==3){
				unsigned char vd[4];
				unsigned int vi;
				vp->t.type = DATE_t;
				vp->t.flags = F_NONE;
				vp->t.memo = 0;
				memcpy(vd+1,(char*)rd->record+rd->fields[no].offs,rd->fields[no].len);
				*vd = 0;
				if(vd[1] == ' ' || vd[1] == 0)
					vp->d.julian = 0;
				else {
					vi = _rdd_backuint(vd);
					vp->d.julian = _clip_jdate((vi&0x1f),(vi&0x1e0)>>5,vi>>9);
				}
			} else if(rd->fields[no].len==4){
				unsigned char vi[4];
				vp->t.type = NUMERIC_t;
				vp->t.flags = F_NONE;
				vp->t.memo = 0;
				memcpy(vi,(char*)rd->record+rd->fields[no].offs,rd->fields[no].len);
				vp->n.d = (double)_rdd_uint(vi);
				vp->t.len = 11;
				vp->t.dec = 0;
			} else {
				unsigned char vlen[4];

				if(rd->memo){
					vp->t.type = CHARACTER_t;
					vp->t.flags = F_NONE;
					vp->t.memo = 0;
					if(rd->indexing){
						char* s;
						vp->s.str.len = rd->fields[no].len-6;
						vp->s.str.buf = malloc(vp->s.str.len+1);
						vp->s.str.buf[vp->s.str.len] = 0;
						memcpy(vp->s.str.buf,
							(char*)rd->record+rd->fields[no].offs,vp->s.str.len);
						s = vp->s.str.buf+vp->s.str.len;
						while(!(*(--s))) *s = ' ';
						if(!rd->fields[no].binary)
							loc_read(rd->loc,(unsigned char *)(vp->s.str.buf),vp->s.str.len);
						return 0;
					}
					memcpy(vlen,(char*)rd->record+rd->fields[no].offs+rd->fields[no].len-2,2);
					vp->s.str.len = _rdd_ushort(vlen);
					vp->s.str.buf = malloc(vp->s.str.len+1);
					vp->s.str.buf[vp->s.str.len] = 0;
					if(vp->s.str.len <= rd->fields[no].len-2){
						memcpy(vp->s.str.buf,(char*)rd->record+
							rd->fields[no].offs,vp->s.str.len);
					} else {
						memcpy(vp->s.str.buf,(char*)rd->record+
							rd->fields[no].offs,rd->fields[no].len-6);
						memcpy(vlen,(char*)rd->record+
							rd->fields[no].offs+rd->fields[no].len-6,4);
						if(rd->memo->vtbl->getvchar){
							if((er = rd->memo->vtbl->getvchar(cm,rd->memo,
								vp->s.str.len-(rd->fields[no].len-6),_rdd_uint(vlen),
								vp->s.str.buf+rd->fields[no].len-6,__PROC__)))
								return er;
						}
					}
				} else {
					vp->s.str.buf = strdup("!!! Memo file not opened");
					vp->s.str.len = 24;
				}
				if(!rd->fields[no].binary)
					loc_read(rd->loc,(unsigned char *)(vp->s.str.buf),vp->s.str.len);
			}
			break;
		}
		case 'L':
			vp->t.type = LOGICAL_t;
			vp->t.flags = F_NONE;
			vp->t.memo = 0;
			memcpy(&l,(char*)rd->record+rd->fields[no].offs,1);
			vp->l.val = (l=='T'?1:0);
			break;
		case 'X':
		{
			memset(vp,0,sizeof(ClipVar));
			switch(((char*)rd->record)[rd->fields[no].offs]){
				case 'N':
				{
					vp->t.type = NUMERIC_t;
					memcpy(&vp->n.d,(char*)rd->record+rd->fields[no].offs+2,8);
					vp->t.len = ((char*)rd->record)[rd->fields[no].offs+1];
					vp->t.dec = rd->fields[no].dec;
					break;
				}
				case 'C':
				{
					vp->t.type = CHARACTER_t;
					vp->s.str.len = ((unsigned char*)rd->record)[rd->fields[no].offs+1];
					vp->s.str.buf = malloc(vp->s.str.len+1);
					memcpy(vp->s.str.buf,(char*)rd->record+rd->fields[no].offs+2,
						vp->s.str.len);
					vp->s.str.buf[vp->s.str.len] = 0;
					if(!rd->fields[no].binary)
						loc_read(rd->loc,(unsigned char *)(vp->s.str.buf),vp->s.str.len);
					break;
				}
				case 'D':
				{
					unsigned char vd[4];

					vp->t.type = DATE_t;
					memcpy(vd+1,(char*)rd->record+rd->fields[no].offs+2,3);
					*vd = 0;
					if(vd[1] == ' ' || vd[1] == 0)
						vp->d.julian = 0;
					else
						vp->d.julian = _rdd_backuint(vd)+0x15d971;
					break;
				}
				case 'T':
				{
					char t[8];

					vp->t.type = DATETIME_t;
					memcpy(t,(char*)rd->record+rd->fields[no].offs+2,8);
					vp->dt.julian = _rdd_uint((unsigned char *)t);
					vp->dt.time = _rdd_uint((unsigned char *)(t+4));
					break;
				}
				case 'L':
				{
					vp->t.type = LOGICAL_t;
					vp->l.val =
						(((char*)rd->record)[rd->fields[no].offs+2]=='T')?1:0;
					break;
				}
				default:
					break;
			}
			break;
		}
/* Visual FoxPro types */
		case 'I':
		{
			unsigned char u4[4];
			vp->t.type = NUMERIC_t;
			vp->t.flags = F_NONE;
			vp->t.memo = 0;
			memcpy(u4,(char*)rd->record+rd->fields[no].offs,4);
			vp->n.d = (double)((int)_rdd_uint(u4));
			vp->t.len = 11;
			vp->t.dec = 0;
			break;
		}
		case 'B':
		case 'Y':
		{
			vp->t.type = NUMERIC_t;
			vp->t.flags = F_NONE;
			vp->t.memo = 0;
			memcpy(&vp->n.d,(char*)rd->record+rd->fields[no].offs,8);
			if(rd->fields[no].type == 'Y')
				vp->n.d = (double)(*(long long*)&vp->n.d)/10000;
			vp->t.len = 20;
			vp->t.dec = rd->fields[no].dec;
			break;
		}
		case 'T':
		{
			char t[8];

			vp->t.type = DATETIME_t;
			vp->t.flags = F_NONE;
			vp->t.memo = 0;
			memcpy(t,(char*)rd->record+rd->fields[no].offs,8);
			vp->dt.julian = _rdd_uint((unsigned char *)t);
			vp->dt.time = _rdd_uint((unsigned char *)(t+4));
			break;
		}
	}
	return 0;
}

int dbf_setvalue(ClipMachine* cm,RDD_DATA* rd,int no,ClipVar* vp,int binary,const char* __PROC__){
	int er;

	if(rd->readonly)
		return rdd_err(cm,EG_READONLY,0,__FILE__,__LINE__,__PROC__,
			er_notpermitted);

	if(!rd->valid)
		if((er = dbf_getrecord(cm,rd,__PROC__))) return er;

	if(!rd->data[no]){
		rd->data[no] = calloc(1,sizeof(ClipVar));
		if((er = dbf_getvalue(cm,rd,no,rd->data[no],__PROC__))) return er;
	}
	rd->updated = rd->changed = 1;
	if(rd->fields[no].nullable){
		int nbyte = no>>3;
		unsigned char byte;

		memcpy(&byte,rd->record+rd->nulloffs+nbyte,1);
		if(vp->t.type == UNDEF_t)
			byte |= (1 << (no - (nbyte << 3)));
		else
			byte &= ~(1 << (no - (nbyte << 3)));
		memcpy(rd->record+rd->nulloffs+nbyte,&byte,1);
		if(vp->t.type == UNDEF_t)
			return 0;
	}
	switch(rd->fields[no].type){
		case 'C':
		{
			char* str;
			int l;

			if(vp->t.type != CHARACTER_t)
				goto err;
			str = malloc(rd->fields[no].len);
			l = min(rd->fields[no].len,vp->s.str.len);

			memcpy(str,vp->s.str.buf,l);
			if(!rd->fields[no].binary)
				loc_write(rd->loc,(unsigned char *)str,l);
			memset(str+l,' ',rd->fields[no].len-l);
			memcpy(rd->record+rd->fields[no].offs,str,rd->fields[no].len);
			free(str);
			break;
		}
		case 'M':
		case 'P':
		case 'G':
		{
			char memoid[11];
			int memo;

			if(!rd->memo)
				return rdd_err(cm,EG_WRITE,0,__FILE__,__LINE__,__PROC__,
					er_nomemo);
			if(rd->fields[no].type == 'P' || rd->fields[no].type == 'G')
				binary = 1;
			if(rd->sig != 0x30){ /* Not VFP */
				memcpy(memoid,rd->record+rd->fields[no].offs,10);
				memoid[10] = 0;
				memo = atoi(memoid);
				if((er = rd->memo->vtbl->setvalue(cm,rd->memo,&memo,vp,binary,__PROC__)))
					return er;
				snprintf(memoid,sizeof(memoid),"%10d",memo);
				memcpy(rd->record+rd->fields[no].offs,memoid,10);
			} else {
				memcpy(memoid,rd->record+rd->fields[no].offs,4);
				memo = _rdd_uint((unsigned char *)memoid);
				if((er = rd->memo->vtbl->setvalue(cm,rd->memo,&memo,vp,binary,__PROC__)))
					return er;
				_rdd_put_uint((unsigned char *)memoid,memo);
				memcpy(rd->record+rd->fields[no].offs,memoid,4);
			}
			break;
		}
		case 'N':
		case 'F': /* Visual FoxPro type */
		{
			char* n;
			int len = rd->fields[no].len;
			int dec = rd->fields[no].dec;

			if(vp->t.type != NUMERIC_t)
				goto err;
			n = calloc(1,len+1);
			if(_clip_dtostr(n,len,dec,vp->n.d,0)){
				char buf[PATH_MAX];
				snprintf(buf,sizeof(buf),"%s: %s",rd->path,rd->fields[no].name);
				free(n);
				return rdd_err(cm,EG_DATAWIDTH,0,__FILE__,__LINE__,buf,
					er_baddata);
			}
			memcpy(rd->record+rd->fields[no].offs,n,len);
			free(n);
			break;
		}
		case 'D':
		{
			char d[] = "00000000";

			if(vp->t.type != DATE_t)
				goto err;
			if(vp->d.julian){
				_clip_datetostr(vp->d.julian,d);
			}
			memcpy(rd->record+rd->fields[no].offs,d,8);
			break;
		}
		case 'L':
			if(vp->t.type != LOGICAL_t)
				goto err;
			memcpy(rd->record+rd->fields[no].offs,vp->l.val?"T":"F",1);
			break;
		case 'V':
		{
			if(rd->fields[no].len==3){
				unsigned char vd[4];
				unsigned int vi;
				int dd,mm,yy,ww;

				if(vp->t.type != DATE_t)
					goto err;

				_clip_cdate(vp->d.julian,&dd,&mm,&yy,&ww);
				vi = (yy<<9)+(mm<<5)+dd;

				_rdd_put_backuint(vd,vi);
				memcpy(rd->record+rd->fields[no].offs,vd+1,3);
			} else if(rd->fields[no].len==4){
				unsigned char vi[4];
				if(vp->t.type != NUMERIC_t)
					goto err;
				_rdd_put_uint(vi,(int)vp->n.d);
				memcpy(rd->record+rd->fields[no].offs,vi,4);
			} else {
				unsigned char vlen[4];
				char* str;
				unsigned short int oldlen;
				unsigned int memoid = 0;

				if(!rd->memo)
					return rdd_err(cm,EG_WRITE,0,__FILE__,__LINE__,__PROC__,
						er_nomemo);
				if(vp->t.type != CHARACTER_t)
					goto err;
				memcpy(vlen,rd->record+rd->fields[no].offs+rd->fields[no].len-2,2);
				oldlen = max((int)_rdd_ushort(vlen)-(rd->fields[no].len-6),0);
				if(oldlen > rd->fields[no].len-6){
					memcpy(vlen,rd->record+rd->fields[no].offs+rd->fields[no].len-6,4);
					memoid = _rdd_uint(vlen);
				}
				_rdd_put_ushort(vlen,vp->s.str.len);
				memcpy(rd->record+rd->fields[no].offs+rd->fields[no].len-2,vlen,2);
				str = calloc(1,vp->s.str.len);
				memcpy(str,vp->s.str.buf,vp->s.str.len);
				if(!rd->fields[no].binary)
					loc_write(rd->loc,(unsigned char *)str,vp->s.str.len);
				if(vp->s.str.len <= rd->fields[no].len-2){
					memcpy(rd->record+rd->fields[no].offs,str,vp->s.str.len);
				} else {
					memcpy(rd->record+rd->fields[no].offs,str,rd->fields[no].len-6);
					if(rd->memo->vtbl->setvchar){
						if((er = rd->memo->vtbl->setvchar(cm,rd->memo,
							vp->s.str.len-(rd->fields[no].len-6),
							oldlen,&memoid,str+rd->fields[no].len-6,__PROC__))){
							free(str);
							return er;
						}
					}
					_rdd_put_uint(vlen,memoid);
					memcpy(rd->record+rd->fields[no].offs+rd->fields[no].len-6,vlen,4);
				}
				free(str);
			}
			break;
		}
		case 'X':
		{
			memset((char*)rd->record+rd->fields[no].offs,0,
				rd->fields[no].len);
			switch(vp->t.type){
				case NUMERIC_t:
				{
					((char*)rd->record)[rd->fields[no].offs] = 'N';
					((unsigned char*)rd->record)[rd->fields[no].offs+1] = vp->t.len;
					memcpy(rd->record+rd->fields[no].offs+2,&vp->n.d,8);
					break;
				}
				case CHARACTER_t:
				{
					unsigned int len =
						(unsigned char)min(rd->fields[no].len-2,vp->s.str.len);
					((char*)rd->record)[rd->fields[no].offs] = 'C';
					((unsigned char*)rd->record)[rd->fields[no].offs+1] = len;
					memcpy((char*)rd->record+rd->fields[no].offs+2,
						vp->s.str.buf,len);
					if(!rd->fields[no].binary)
						loc_write(rd->loc,(unsigned char*)rd->record+rd->fields[no].offs+2,len);
					break;
				}
				case DATE_t:
				{
					unsigned char vd[4];

					((char*)rd->record)[rd->fields[no].offs] = 'D';
					((unsigned char*)rd->record)[rd->fields[no].offs+1] = 3;
					_rdd_put_backuint(vd,vp->d.julian-0x15d971);
					memcpy(rd->record+rd->fields[no].offs+2,vd+1,3);
					break;
				}
				case DATETIME_t:
				{
					char t[8];

					((char*)rd->record)[rd->fields[no].offs] = 'T';
					((unsigned char*)rd->record)[rd->fields[no].offs+1] = 8;
					_rdd_put_uint((unsigned char *)t,vp->dt.julian);
					_rdd_put_uint((unsigned char *)(t+4),vp->dt.time);
					memcpy((char*)rd->record+rd->fields[no].offs+2,t,8);
					break;
				}
				case LOGICAL_t:
				{
					((char*)rd->record)[rd->fields[no].offs] = 'L';
					((unsigned char*)rd->record)[rd->fields[no].offs+1] = 1;
					((char*)rd->record)[rd->fields[no].offs+2] = (vp->l.val?'T':'F');
					break;
				}
				case UNDEF_t:
					break;
				default:
					goto err;
			}
			break;
		}
/* Visual FoxPro types */
		case 'I':
		{
			unsigned char u4[4];

			if(vp->t.type != NUMERIC_t)
				goto err;
			_rdd_put_uint(u4,(int)vp->n.d);
			memcpy(rd->record+rd->fields[no].offs,u4,4);
			break;
		}
		case 'B':
		case 'Y':
		{
			if(vp->t.type != NUMERIC_t)
				goto err;
			if(rd->fields[no].type=='Y'){
				long long tmp;
				double d = vp->n.d;
#ifdef ARCH_i386
				long long *lld = (long long*)&d;

				(*lld)++;
#endif
				tmp = d*10000;
				memcpy(rd->record+rd->fields[no].offs,&tmp,8);
			} else
				memcpy(rd->record+rd->fields[no].offs,&vp->n.d,8);
			break;
		}
		case 'T':
		{
			char t[8];

			if(vp->t.type != DATETIME_t)
				goto err;
			_rdd_put_uint((unsigned char *)t,vp->dt.julian);
			_rdd_put_uint((unsigned char *)(t+4),vp->dt.time);
			memcpy((char*)rd->record+rd->fields[no].offs,t,8);
			break;
		}
	}
	return 0;
err:
	return rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,
		er_type);
}

static int dbf_delete(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	char d = 0x2a;
	int er;

	if(rd->readonly)
		return rdd_err(cm,EG_READONLY,0,__FILE__,__LINE__,__PROC__,
			er_notpermitted);
	if(!rd->valid)
		if((er = dbf_getrecord(cm,rd,__PROC__))) return er;
	rd->updated = rd->changed = 1;
	((char*)rd->record)[0] = d;
	return 0;
}

static int dbf_recall(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	char d = 0x20;
	int er;

	if(rd->readonly)
		return rdd_err(cm,EG_READONLY,0,__FILE__,__LINE__,__PROC__,
			er_notpermitted);
	if(!rd->valid)
		if((er = dbf_getrecord(cm,rd,__PROC__))) return er;
	rd->updated = rd->changed = 1;
	((char*)rd->record)[0] = d;
	return 0;
}

static int dbf_lupdate(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	DBF_HEADER hdr;
	int er;

	if((er = rdd_read(cm,&rd->file,0,sizeof(DBF_HEADER),&hdr,__PROC__)))
		return er;
	_clip_retdc(cm,1900+(hdr.yy>80?hdr.yy:hdr.yy+100),hdr.mm,hdr.dd);
	return 0;
}

static int dbf_info(ClipMachine* cm,RDD_DATA* rd,int cmd,const char* __PROC__){
	switch(cmd){
		case DBI_ISDBF:
		{
			_clip_retl(cm,1);
			break;
		}
		case DBI_LOCKOFFSET:
		{
			_clip_retni(cm,rd->lockstyle?0x10000000:1000000000);
			break;
		}
		case DBI_VALIDBUFFER:
		{
			_clip_retl(cm,1);
			break;
		}
	}
	return 0;
}

static int dbf_setstruct(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	return rdd_write(cm,&rd->file,28,1,"\001",__PROC__);
}

static int _dbf_compare(void* op,void* lp,void* rp,int* uniq){
	if((unsigned long)lp < (unsigned long)rp)
		return -1;
	if((unsigned long)lp > (unsigned long)rp)
		return 1;
	return 0;
}

static int dbf_calcfiltlist(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER* fp,const char* __PROC__){
	BTREE* bt;
	unsigned i,j;
	unsigned int recno;

	if(fp->list){
		bt = bt_create(0,fp->listlen,sizeof(unsigned int),
			_dbf_compare);
		for(i=0;i<fp->listlen;i++){
			recno = fp->list[i];
			bt_add(bt,NULL,(void*)&recno);
		}
		free(fp->list);
		fp->list = malloc(sizeof(unsigned int)*fp->listlen);
		bt_first(bt);
		i = 0;
		fp->list[i] = *(unsigned int*)bt_key(bt);
		while(!bt_next(bt)){
			i++;
			fp->list[i] = *(unsigned int*)bt_key(bt);
		}
		bt_destroy(bt);
	} else {
#if 1
		unsigned int bytes = ((fp->size+1) >> 5) + 1;
		int b,bb,t,tt;

		fp->listlen = 0;
		for(i=0;i<bytes;i++){
			if(fp->rmap[i]){
				for(b=(i<<2),bb=0;bb<4;b++,bb++){
					if(((char*)fp->rmap)[b]){
						for(t=(b<<3)+1,tt=0;tt<8;t++,tt++){
							if(_rm_getbit(fp->rmap,fp->size,t))
								fp->listlen++;
						}
					}
				}
			}
		}
		if(fp->listlen > 100)
			return 0;
#else
		fp->listlen = 0;
		for(i=1;i<=fp->size;i++)
			if(_rm_getbit(fp->rmap,fp->size,i))
				fp->listlen++;
#endif
		fp->list = malloc(sizeof(unsigned int)*(fp->listlen+1));
#if 1
		for(i=0,j=0;i<bytes;i++){
			if(fp->rmap[i]){
				for(b=(i<<2),bb=0;bb<4;b++,bb++){
					if(((char*)fp->rmap)[b]){
						for(t=(b<<3)+1,tt=0;tt<8;t++,tt++){
							if(_rm_getbit(fp->rmap,fp->size,t))
								fp->list[j++] = t;
						}
					}
				}
			}
		}
#else
		for(i=1;i<=fp->size;i++){
			if(_rm_getbit(fp->rmap,fp->size,i))
				fp->list[j++] = i;
		}
#endif
	}
	return 0;
}

static int dbf_pack(ClipMachine* cm,RDD_DATA* rd,int tfd,const char* __PROC__){
	DBF_HEADER hdr;
	unsigned char* buf = NULL;
	unsigned int oldnrecs, i;
	unsigned int newnrecs = 0;
	int rs, s;

	if(read(tfd,&hdr,sizeof(DBF_HEADER)) != sizeof(DBF_HEADER)) goto err;
	oldnrecs = _rdd_uint(hdr.recs);
	_rdd_put_uint(hdr.recs,0);
	if(write(rd->file.fd,&hdr,sizeof(DBF_HEADER)) != sizeof(DBF_HEADER)) goto err;
	s = _rdd_ushort(hdr.hdrsize)-sizeof(DBF_HEADER);
	buf = malloc(s);
	if(read(tfd,buf,s) != s) goto err;
	if(write(rd->file.fd,buf,s) != s) goto err;
	free(buf);
	rs = _rdd_ushort(hdr.recsize);
	buf = malloc(rs);
	for(i=0;i<oldnrecs;i++){
		if(read(tfd,buf,rs) != rs) goto err;
		if(*buf == 0x20){
			if(write(rd->file.fd,buf,rs) != rs) goto err;
			newnrecs++;
		}
	}
	free(buf); buf = NULL;
	if(lseek(rd->file.fd,0,SEEK_SET)==-1) goto err;
	if(read(rd->file.fd,&hdr,sizeof(DBF_HEADER)) != sizeof(DBF_HEADER)) goto err;
	_rdd_put_uint(hdr.recs,newnrecs);
	if(lseek(rd->file.fd,0,SEEK_SET)==-1) goto err;
	if(write(rd->file.fd,&hdr,sizeof(DBF_HEADER)) != sizeof(DBF_HEADER)) goto err;
	return 0;
err:
	if(buf)
		free(buf);
	return rdd_err(cm,EG_WRITE,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
}
