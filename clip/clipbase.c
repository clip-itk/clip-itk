/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>, rust <rust@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
	$Log: clipbase.c,v $
	Revision 1.289  2002/10/11 09:11:12  clip
	rust: m6_FiltSave()/m6_FiltRestore()
	
	Revision 1.288  2002/10/01 13:16:51  clip
	rust: build filter list

	Revision 1.287  2002/09/27 12:09:49  clip
	rust: INDEX ON ... CUSTOM [EMPTY in Six]

	Revision 1.286  2002/09/25 13:17:02  clip
	rust: compatibility of INDEX ON behavior and some cleanups

	Revision 1.285  2002/09/17 09:54:21  clip
	rust: flex fpt

	Revision 1.284  2002/09/11 12:29:00  clip
	build fixes
	paul

	Revision 1.283  2002/08/30 10:16:35  clip
	rust: rddsetfilter(<handle>,<cFilter>,<aAliases>) (<aAliases> added)

	Revision 1.282  2002/08/26 14:52:12  clip
	rust: DBCreateInd()

	Revision 1.281  2002/08/06 13:18:11  clip
	rust: bug in get_area()

	Revision 1.280  2002/08/02 11:38:21  clip
	mclone in _clip_nameassign
	paul

	Revision 1.279  2002/08/02 11:09:21  clip
	rust: RM_*() => SX_*(), M6_*()

	Revision 1.278  2002/07/27 08:21:49  clip
	uri: undocumented params added to dbcreate()

	Revision 1.277  2002/06/11 10:15:58  clip
	rust: bug in dbcreate()

	Revision 1.276  2002/05/18 11:12:31  clip
	rust: clipper-style indexes locking (NTX)

	Revision 1.275  2002/05/14 09:23:23  clip
	rust: (nil)->(...)

	Revision 1.274  2002/05/12 11:19:39  clip
	rust: some fixes

	Revision 1.273  2002/05/12 09:12:10  clip
	rust: UNLOCK flushes record buffer

	Revision 1.272  2002/04/30 13:03:24  clip
	rust: DELE() == DELETED()

	Revision 1.271  2002/04/30 09:10:25  clip
	rust: 'X' field type support

	Revision 1.270  2002/04/27 13:23:34  clip
	rust: record buffering

	Revision 1.269  2002/04/21 11:22:23  clip
	rust: added 2 elements to dbstruct - binary (5th) and nullable (6th)

	Revision 1.268  2002/04/19 08:36:05  clip
	rust: initial support of VFP DBF format, "VFPCDX" driver

	Revision 1.267  2002/04/17 12:21:59  clip
	rust: some fixes

	Revision 1.266  2002/04/12 12:04:58  clip
	rust: fix

	Revision 1.265  2002/04/12 10:53:44  clip
	rust: small fix

	Revision 1.264  2002/04/12 10:40:21  clip
	rust: small fix

	Revision 1.263  2002/04/12 10:24:09  clip
	rust: small fix

	Revision 1.262  2002/04/10 10:05:16  clip
	rust: SET AUTOPEN affects only on CDX and CTX, not NTX

	Revision 1.261  2002/04/03 11:29:08  clip
	rust: [ORD|SX_]KEY[COUNT|NO] without controlling order return [LASTREC|RECNO]()

	Revision 1.260  2002/04/03 11:11:45  clip
	rust: SIXCDX == DBFCDX

	Revision 1.259  2002/04/03 09:37:43  clip
	rust: .DBF signature with various memo formats is corrected

	Revision 1.258  2002/03/22 13:15:48  clip
	rust: error messages

	Revision 1.257  2002/03/21 11:55:15  clip
	rust: big cleaning

	Revision 1.256  2002/03/20 14:57:18  clip
	rust: OrdFor() without parameter and no order opened

	Revision 1.255  2002/03/17 12:17:59  clip
	rust: __DBSETFOUND()

	Revision 1.254  2002/03/12 12:53:30  clip
	a->b now will try a:b if no area a, for memvars
	paul

	Revision 1.253  2002/03/11 16:37:21  clip
	uri: small fix

	Revision 1.252  2002/03/11 13:52:51  clip
	rust: __dbSetLoc(), __dbSetLocate()

	Revision 1.251  2002/03/10 12:34:00  clip
	uri: small fixes

	Revision 1.250  2002/02/28 13:58:33  clip
	rust: COMMIT in readonly mode bug

	Revision 1.249  2002/02/28 11:46:33  clip
	rust: small fix

	Revision 1.248  2002/02/28 10:56:03  clip
	rust: bug in DBCOMMITALL()

	Revision 1.247  2002/02/04 12:59:28  clip
	rust: tagname with trailing spaces bug fixed

	Revision 1.246  2002/01/16 12:04:56  clip
	rust: some fixes

	Revision 1.245  2002/01/15 10:20:32  clip
	Alias > 10 characters
	rust

	Revision 1.244  2002/01/09 13:53:47  clip
	small fix
	rust

	Revision 1.243  2002/01/09 12:38:20  clip
	EG_NOTABLE handling -> the same as in Clipper 5.3
	rust

	Revision 1.242  2002/01/04 12:27:14  clip
	some fixes
	rust

	Revision 1.241  2001/12/26 12:12:17  clip
	share container for ClipMachine's
	paul

	Revision 1.240  2001/12/25 10:48:22  clip
	Sx_RollBack()
	rust

	Revision 1.239  2001/12/25 08:43:04  clip
	bug in get_orderno()
	rust

	Revision 1.238  2001/12/22 13:09:45  clip
	Virtual BOF
	rust

	Revision 1.237  2001/12/22 10:01:21  clip
	some changes
	rust

	Revision 1.236  2001/12/21 12:21:32  clip
	some fixes
	rust

	Revision 1.235  2001/12/12 15:34:09  clip
	SET LOCKSTYLE [TO] CLIPPER | CLIPPER50 | CLIPPER52 | CLIPPER53 | FOXPRO | SIX
	rust

	Revision 1.234  2001/12/12 13:30:09  clip
	Low level locking - DBF
	rust

	Revision 1.233  2001/12/10 09:21:21  clip
	Locking global reviewing...
	rust

	Revision 1.232  2001/12/07 12:14:51  clip
	fixes
	rust

	Revision 1.231  2001/12/07 10:31:46  clip
	fixes
	rust

	Revision 1.230  2001/12/06 13:53:45  clip
	Sx_IsDBT() (always .F.), Sx_IsFLocked(), Sx_IsLocked()
	rust

	Revision 1.229  2001/12/06 13:01:10  clip
	get_orderno() with numeric index id
	rust

	Revision 1.228  2001/11/29 16:20:31  clip
	bug in DBRSELECT()
	rust

	Revision 1.227  2001/11/27 14:06:57  clip
	speed optimizations (exclusive skipping with index)
	rust

	Revision 1.226  2001/11/23 14:01:26  clip
	speed optimizations
	rust

	Revision 1.225  2001/11/23 13:23:25  clip
	__rddcopy() -> __dbcopyraw()
	rust

	Revision 1.224  2001/11/23 13:01:34  clip
	clip___RDDCOPY(), rdd_rawread(), rdd_rawwrite()
	rust

	Revision 1.223  2001/11/23 11:20:42  clip
	_rdd_(case)hashstr() -> _clip_(case)hashword()
	rust

	Revision 1.222  2001/11/23 11:08:17  clip
	add _clip_hashword(str,len), _clip_casehashword(str,len), which trim
	str before calc hash
	paul

	Revision 1.221  2001/11/23 09:14:21  clip
	uri: small fix

	Revision 1.220  2001/11/23 08:59:03  clip
	uri: small fix for default numeric format in STR()

	Revision 1.219  2001/11/22 15:12:55  clip
	uri: __dbsort() && small bugs

	Revision 1.218  2001/11/15 13:16:41  clip
	err on badalias
	paul

	Revision 1.217  2001/11/12 11:14:48  clip
	rddHandle() parameters
	rust

	Revision 1.216  2001/11/12 10:21:55  clip
	rddHandle()
	rust

	Revision 1.215  2001/11/11 14:46:23  clip
	'alltrim' all field, alias, tag names.
	Bug in rdd_create()
	rust

	Revision 1.214  2001/11/09 12:46:56  clip
	rddsetdefault() sets default data, index and memo drivers too now
	rust

	Revision 1.213  2001/11/09 11:51:39  clip
	Six: rm_Chill(), rm_Freeze(), rm_Warm(), rm_Thermometer()
	rust

	Revision 1.212  2001/11/06 10:42:44  clip
	SIX: RDD_Count(), RDD_Info(), RDD_Name()
	rust

	Revision 1.211  2001/11/05 16:21:39  clip
	RM_SETTRIGGER(), USE ... TRIGGER
	rust

	Revision 1.210  2001/11/05 09:43:47  clip
	Six: rest of trigger events...
	rust

	Revision 1.209  2001/11/03 12:18:14  clip
	bug in ORDSETFOCUS()
	rust

	Revision 1.208  2001/10/30 13:54:32  clip
	bug in dbappend()
	rust

	Revision 1.207  2001/10/30 11:49:08  clip
	new locks
	rust

	Revision 1.206  2001/10/30 08:41:38  clip
	many changes
	rust

	Revision 1.205  2001/10/24 12:12:08  clip
	Six: VariFields
	rust

	Revision 1.204  2001/10/22 12:07:05  clip
	many fixes and bugs :)
	rust

	Revision 1.203  2001/10/16 11:15:01  clip
	speed optimizations
	rust

	Revision 1.202  2001/10/12 10:19:05  clip
	memo bug
	rust

	Revision 1.201  2001/10/11 07:04:42  clip
	- set default target in Makefile to "all" instead "install"
	- bug in _clip_assign_field

	Revision 1.200  2001/10/10 15:04:58  clip
	many fixes
	rust

	Revision 1.199  2001/09/22 13:20:53  clip
	some optimizations
	rust

	Revision 1.198  2001/09/12 10:50:42  clip
	stream output recoding
	paul

	Revision 1.197  2001/09/06 13:30:54  clip
	bug in dbusearea()
	rust

	Revision 1.196  2001/09/05 04:54:28  clip
	bug in _clip_nameassign in case ALIAS->FIELDNAME
	paul

	Revision 1.195  2001/09/04 09:41:44  clip
	rest of SIX functions
	rust

	Revision 1.194  2001/08/31 07:04:31  clip
	bug in _clip_parse_name

	Revision 1.193  2001/08/27 12:09:06  clip
	M_REF's mistake in dbcreate() with memo fields
	rust

	Revision 1.192  2001/08/26 09:55:00  clip
	absent _clip_vptr
	paul

	Revision 1.191  2001/08/24 08:04:38  clip
	macro assign to array/map members
	paul

	Revision 1.190  2001/08/23 14:45:56  clip
	Undepended indices (II_*** functions)
	rust

	Revision 1.189  2001/08/23 13:52:06  clip
	merge with NEWLOCALS
	paul


	Revision 1.188  2001/08/20 10:38:05  clip
	ORDDESTROY() added
	rust

	Revision 1.187  2001/08/16 09:19:56  clip
	RM_FILTINFO() added
	rust

	Revision 1.186  2001/08/03 09:51:24  clip
	__DBLocateOptimize()
	rust

	Revision 1.185  2001/08/02 13:59:44  clip
	some fixes
	rust

	Revision 1.184  2001/08/02 12:34:01  clip
	some error messages corrected
	rust

	Revision 1.183  2001/07/27 13:33:52  clip
	optimized locate & continue, sum, average, count etc...
	rust

	Revision 1.182  2001/07/27 09:16:47  clip
	some machsix features
	rust

	Revision 1.181.2.4  2001/08/23 12:20:21  clip
	ISPRIVATE(cName) ->lVal
	ISPUBLIC(cName) ->lVal
	paul

	Revision 1.181.2.3  2001/08/23 10:42:44  clip
	rdd2clip
	paul

	Revision 1.181.2.2  2001/08/22 13:52:39  clip
	assign to field
	paul

	Revision 1.181.2.1  2001/08/22 08:45:20  clip
	fix
	paul

	Revision 1.181  2001/07/10 10:53:05  clip
	Another bugs from Kresin in functions ORDSETFOCUS(),ORDKEY(),ORDBAGNAME()
	rust

	Revision 1.180  2001/07/05 08:22:08  clip
	Bugs from Kresin:
	1. USE <file>.dbf with SET AUTOPEN ON
	2. ORDBAGNAME() with no controlling order
	rust

	Revision 1.179  2001/06/29 13:09:55  clip
	Many various changes, optimizations...
	rust

	Revision 1.178  2001/06/21 08:41:50  clip
	Bug in ORDNAME()
	rust

	Revision 1.177  2001/06/15 09:15:55  clip
	Stupid virtual aliases (A-K)...
	rust

	Revision 1.176  2001/06/14 09:23:57  clip
	DBRSELECT()
	rust

	Revision 1.175  2001/06/13 13:22:06  clip
	added dummy clip_DBFNTX(), clip_DBFCTX(), clip_DBFCDX(), clip__DBFCDX()
	for REQUEST command
	rust

	Revision 1.174  2001/06/10 10:39:10  clip
	FIELDBLANK()
	rust

	Revision 1.173  2001/06/10 09:27:50  clip
	Bug while indexing parent with key based on child
	rust

	Revision 1.172  2001/06/10 09:01:50  clip
	fixes in afields()
	rust

	Revision 1.171  2001/06/07 11:44:07  clip
	Logging RDD layer errors added
	rust

	Revision 1.170  2001/06/04 11:05:48  clip
	enhancing RDD (rddlocate(),rddcontinue(),rddstruct(),rddfieldname(),...
	rust

	Revision 1.169  2001/06/01 11:15:07  clip
	some fixes...
	rust

	Revision 1.168  2001/05/29 10:32:08  clip
	orddescend()
	rust

	Revision 1.167  2001/05/28 14:04:36  clip
	cdx is working now...
	rust

	Revision 1.166  2001/05/24 12:22:07  clip
	small bug
	rust

	Revision 1.165  2001/05/15 13:42:51  clip
	memory leaks in errors
	rust

	Revision 1.164  2001/05/15 11:32:23  clip
	small bug
	rust

	Revision 1.163  2001/05/15 11:04:05  clip
	small bug
	rust

	Revision 1.162  2001/05/15 07:02:17  clip
	modify memdebug call interface
	paul

	Revision 1.161  2001/05/11 09:32:11  clip
	clip_spar & blocks
	paul

	Revision 1.160  2001/05/07 09:39:27  clip
	memory leak in DBSELECTAREA()
	rust

	Revision 1.159  2001/04/25 11:04:40  clip
	const ... _clip_parc()
	rust

	Revision 1.158  2001/04/25 09:28:44  clip
	memory bug
	rust

	Revision 1.157  2001/04/25 08:39:52  clip
	*** empty log message ***

	Revision 1.156  2001/04/23 10:07:29  clip
	get_area
	paul

	Revision 1.155  2001/04/23 08:55:38  clip
	small bug
	rust

	Revision 1.154  2001/04/23 07:11:10  clip
	push_area, procname for statics
	paul

	Revision 1.153  2001/04/22 12:58:47  clip
	autoopen, autoorder added
	rust

	Revision 1.152  2001/04/22 10:48:46  clip
	dbfilter() with no current area
	rust

	Revision 1.151  2001/04/20 09:48:57  clip
	uplocals in _clip_clone
	paul

	Revision 1.150  2001/04/19 09:17:50  clip
	Bug calculating block when current area is another
	rust

	Revision 1.149  2001/04/19 07:48:32  clip
	DBGOTO(), DBGOTOP(), DBGOBOTTOM() with no alias
	rust

	Revision 1.148  2001/04/17 13:23:52  clip
	ORDCREATE() with no file name (index file name = data file name)
	rust

	Revision 1.147  2001/04/17 12:29:35  clip
	DBFCTX added
	rust

	Revision 1.146  2001/04/11 10:07:19  clip
	bug in SET PATH && SET DEFAULT
	rust

	Revision 1.145  2001/04/10 11:44:45  clip
	ordkey() for (nOrder < orders opened) returns "" now
	rust

	Revision 1.144  2001/04/09 11:12:27  clip
	ASORT,ASCAN work with mishalleous types in array
	add additional parameter to _clip_cmp
	paul

	Revision 1.143  2001/04/05 13:11:17  clip
	bug in memo-opening
	rust

	Revision 1.142  2001/04/05 12:31:13  clip
	another small bug
	rust

	Revision 1.141  2001/04/05 08:50:35  clip
	small bug
	rust

	Revision 1.140  2001/04/04 09:30:51  clip
	DBSEEK( , , <lLast>)
	rust

	Revision 1.139  2001/04/03 09:17:00  clip
	license errors
	paul

	Revision 1.138  2001/04/02 15:49:19  clip
	__DBPACK()
	rust

	Revision 1.137  2001/03/31 12:34:39  clip
	rest of ORD*() functions, including ORDSETRELATION() and ORDSKIPUNIQUE()
	rust

	Revision 1.136  2001/03/30 14:54:38  clip
	small bug
	rust

	Revision 1.135  2001/03/30 13:44:22  clip
	another ORD*() functions
	rust

	Revision 1.134  2001/03/30 11:51:03  clip
	add copyright

	Revision 1.133  2001/03/30 09:10:38  clip
	DBAPPEND() with map
	rust

	Revision 1.132  2001/03/29 11:56:46  clip
	Custom indexes
	rust

	Revision 1.131  2001/03/29 10:31:30  clip
	bug in afields()
	rust

	Revision 1.130  2001/03/28 11:17:03  clip
	small bug
	rust

	Revision 1.129  2001/03/28 10:44:21  clip
	small bug
	rust

	Revision 1.128  2001/03/28 10:35:46  clip
	DBSETORDER(<invalid order>) not fails now
	rust

	Revision 1.127  2001/03/28 09:18:56  clip
	indexing charset bug fixed
	rust

	Revision 1.126  2001/03/27 12:16:11  clip
	another small bug
	rust

	Revision 1.125  2001/03/27 08:46:32  clip
	DBRELATION()
	rust

	Revision 1.124  2001/03/26 14:10:47  clip
	One more small bug
	rust

	Revision 1.123  2001/03/26 09:14:08  clip
	Some new bugs...
	rust

	Revision 1.122  2001/03/22 13:47:05  clip
	ORDCONDSET(),FIELDDECI(),FIELDNUM(),FIELDSIZE(),FIELDTYPE()
	rust

	Revision 1.121  2001/03/21 14:49:43  clip
	ORDBAGEXT(),ORDBAGNAME()
	rust

	Revision 1.120  2001/03/21 14:27:16  clip
	ORDSETFOCUS()
	rust

	Revision 1.119  2001/03/21 12:39:35  clip
	ORDSCOPE()
	rust

	Revision 1.118  2001/03/20 15:25:50  clip
	DBORDERINFO()
	rust

	Revision 1.117  2001/03/20 12:47:21  clip
	DBRECORDINFO()
	rust

	Revision 1.116  2001/03/20 12:23:42  clip
	DBFIELDINFO()
	rust

	Revision 1.115  2001/03/20 11:09:34  clip
	DBINFO()
	rust

	Revision 1.114  2001/03/20 08:39:03  clip
	DBRUNLOCK()
	rust

	Revision 1.113  2001/03/19 15:17:01  clip
	one more small bug in dbstruct() :-)
	rust

	Revision 1.112  2001/03/19 15:12:48  clip
	small bug in dbstruct()
	rust

	Revision 1.111  2001/03/19 15:05:39  clip
	small bug in dbstruct()
	rust

	Revision 1.110  2001/03/19 14:40:39  clip
	DBSTRUCT() with parameter - workarea number
	rust

	Revision 1.109  2001/03/19 14:34:59  clip
	RDDLIST(),NETERR()
	rust

	Revision 1.108  2001/03/19 13:45:55  clip
	TABLEEXT(),MEMOEXT()
	rust

	Revision 1.107  2001/03/19 13:20:05  clip
	ISFIELD(),ISMEMVAR()
	DBREAD(),DBWRITE()
	rust

	Revision 1.106  2001/03/16 08:41:21  clip
	DBCOMMIT(),DBCOMMITALL()
	rust

	Revision 1.105  2001/03/16 08:06:17  clip
	DBRLOCK(),DBRLOCKLIST()
	rust

	Revision 1.104  2001/03/13 10:22:47  clip
	RLOCK(),FLOCK(),DBUNLOCK(),DBUNLOCKALL()
	rust

	Revision 1.103  2001/03/12 15:56:11  clip
	*** empty log message ***

	Revision 1.102  2001/03/12 15:39:48  clip
	*** empty log message ***

	Revision 1.101  2001/03/12 15:24:18  clip
	DBCLEARREL()
	rust

	Revision 1.100  2001/03/12 15:10:05  clip
	HEADER(),RECSIZE()
	rust

	Revision 1.99  2001/03/12 15:01:10  clip
	INDEXORD()
	rust

	Revision 1.98  2001/03/12 14:54:45  clip
	INDEXKEY()
	rust

	Revision 1.97  2001/03/12 14:29:25  clip
	FIELDPOS(),FIELDGET(),FIELDPUT(),INDEXEXT()
	rust

	Revision 1.96  2001/03/12 13:36:24  clip
	FIELDPOS()
	rust

	Revision 1.95  2001/03/12 13:05:59  clip
	bugs in filtering
	rust

	Revision 1.94  2001/03/12 12:49:40  clip
	DBSETFILTER()
	rust

	Revision 1.93  2001/03/12 12:11:57  clip
	changes to _clip_nameassign() for new RDD
	rust

	Revision 1.92  2001/03/11 16:14:23  clip
	dbsetrelation()

	Revision 1.91  2001/03/11 15:27:27  clip
	dbfilter()
	rust

	Revision 1.90  2001/03/11 12:10:42  clip
	bug in set filter
	rust

	Revision 1.89  2001/03/11 10:36:16  clip
	some fixes
	rust

	mindent
	function _clip_nameassign was empty - revert to previous
	paul

*/

#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <errno.h>
#include "clipbase.h"
#include "rdd.h"
#include "hash.h"
#include "error.ch"
#include "hashcode.h"
#include "rational.h"
#include "six.ch"
#include "dbinfo.ch"
#include "dbstruct.ch"

#define NEW(type) ((type*)calloc(sizeof(type),1))
#define VAR(type,var,ini) type *var=(type*)(ini)

#define HIWORD(dw) (unsigned short)((dw)>>16)
#define LOWORD(dw) (unsigned short)((dw))

#define READLOCK	if((er = wa->rd->vtbl->_rlock(cm,wa->rd,__PROC__))) goto err
#define WRITELOCK	if((er = wa->rd->vtbl->_wlock(cm,wa->rd,__PROC__))) goto err
#define UNLOCK		if((er = wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__))) goto err

static int close_area(ClipMachine * cm, DBWorkArea * wa, const char *__PROC__);

DBWorkArea *cur_area(ClipMachine * cm);
DBWorkArea *get_area(ClipMachine * cm, long area, int any, int* no);

static long A_K_aliasHashes[11];

static const char* er_badalias		= "Bad alias";
static const char* er_nofield		= "No such field";
static const char* er_notable		= "Workarea not in use";
static const char* er_noalias		= "No alias";
static const char* er_noorder		= "No controlling order";
static const char* er_badforexpr	= "Bad FOR expression";

static int
_clip_flushbuffer(ClipMachine* cm, DBWorkArea* wa, const char* __PROC__)
{
	int er;

	if(wa->rd->changed){
		WRITELOCK;
		if((er = wa->rd->vtbl->setrecord(cm,wa->rd,__PROC__))) goto err_unlock;
		UNLOCK;
		wa->rd->changed = 0;
	}
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

static int
_rdd_takevalue(ClipMachine* cm, DBWorkArea* wa, int fno, long fhash, ClipVar* vv, const char* nm)
{
	ClipVar *vp;
	int r,er;

	if (vv->t.flags & F_MPTR)
	{
		if(!wa->rd->valid){
			if ((er = wa->rd->vtbl->_rlock(cm, wa->rd, nm))) return er;
			r = rdd_takevalue(cm, wa->rd, fno, vv->p.vp, nm);
			if ((er = wa->rd->vtbl->_ulock(cm, wa->rd, nm))) return er;
		} else {
			r = rdd_takevalue(cm, wa->rd, fno, vv->p.vp, nm);
		}

		vv->t.field = 1;
		vv->p.fp = _clip_get_fielddef (cm, wa->aliasHash, fhash);
		return r;
	}

	if(!wa->rd->valid){
		if ((er = wa->rd->vtbl->_rlock(cm, wa->rd, nm))) return er;
		r = rdd_takevalue(cm, wa->rd, fno, vv, nm);
		if ((er = wa->rd->vtbl->_ulock(cm, wa->rd, nm))) return er;
	} else {
		r = rdd_takevalue(cm, wa->rd, fno, vv, nm);
	}
	if (r)
		return r;

	vp = NEW(ClipVar);
	*vp = *vv;
	vp->t.count = 1;
	CLEAR_CLIPVAR(vv);
	vv->t.flags = F_MREF;
	vv->t.memo = vp->t.memo;
	vv->t.field = 1;
	vv->t.type = vp->t.type;
	vv->p.vp = vp;
	vv->p.fp = _clip_get_fielddef (cm, wa->aliasHash, fhash);

	return 0;
}


void
register_dbdriver(ClipMachine * cm, char *id, char *data, char *idx, char *memo)
{
	if (!cm->dbdrivers)
		cm->ndbdrivers = 0;
	if (!cm->ndbdrivers)
		cm->dbdrivers = (DBDriver *) malloc(sizeof(DBDriver));
	else
		cm->dbdrivers = (DBDriver *) realloc(cm->dbdrivers,
							 sizeof(DBDriver) * (cm->ndbdrivers + 1));
	cm->ndbdrivers++;
	strcpy(cm->dbdrivers[cm->ndbdrivers - 1].id, id);
	strcpy(cm->dbdrivers[cm->ndbdrivers - 1].data, data);
	strcpy(cm->dbdrivers[cm->ndbdrivers - 1].idx, idx);
	strcpy(cm->dbdrivers[cm->ndbdrivers - 1].memo, memo);
}

int
db_driver(ClipMachine * cm, const char *driver, char *data, char *idx, char *memo, const char *__PROC__)
{
	int i;
	char err[256];

	if (!driver || !driver[0])
		driver = cm->def_db_driver;
	for (i = 0; i < cm->ndbdrivers; i++)
	{
		if ((strlen(driver) == strlen(cm->dbdrivers[i].id)) &&
			(strncasecmp(cm->dbdrivers[i].id, driver,
				 sizeof(cm->dbdrivers[i].id)) == 0))
		{
			if(data)
				strcpy(data, cm->dbdrivers[i].data);
			if(idx)
				strcpy(idx, cm->dbdrivers[i].idx);
			if(memo)
				strcpy(memo, cm->dbdrivers[i].memo);
			return 0;
		}
	}
	snprintf(err, sizeof(err), "No driver linked: %s", driver);
	return rdd_err(cm, EG_ARG, 0, __FILE__, __LINE__, __PROC__, err);
}

int
clip_INIT_DBFNTX(ClipMachine * cm)
{
	char a[2];
	int i;

	a[1] = 0;
	for(i=0;i<11;i++){
		a[0] = 'A'+i;
		A_K_aliasHashes[i] = _clip_hashstr(a);
	}
	register_dbdriver(cm, "DBFNTX", "DBF", "NTX", "DBT");
	return 0;
}

int
clip_INIT_DBFCTX(ClipMachine * cm)
{
	register_dbdriver(cm, "DBFCTX", "DBF", "CTX", "DBT");
	return 0;
}

int
clip_INIT_DBFCDX(ClipMachine * cm)
{
	register_dbdriver(cm, "DBFCDX", "DBF", "CDX", "FPT");
	return 0;
}

int
clip_INIT_SIXCDX(ClipMachine * cm)
{
	register_dbdriver(cm, "SIXCDX", "DBF", "CDX", "FPT");
	return 0;
}

int
clip_INIT_VFPCDX(ClipMachine * cm)
{
	register_dbdriver(cm, "VFPCDX", "VFP", "CDX", "FPT");
	return 0;
}

int
clip_DBFNTX(ClipMachine* cm)
{
	return 0;
}

int
clip_DBFCTX(ClipMachine* cm)
{
	return 0;
}

int
clip_DBFCDX(ClipMachine* cm)
{
	return 0;
}

int
clip__DBFCDX(ClipMachine* cm)
{
	return 0;
}

int
clip_SIXCDX(ClipMachine* cm)
{
	return 0;
}

int
clip_VFPCDX(ClipMachine* cm)
{
	return 0;
}

/* [ fields */
#if 0
static ClipVar *
space_var(ClipMachine * cm, int line, long area, long hash)
{
	HashTable *hp = _clip_space(cm, area);
	ClipVar *vp;

	if (!hp)
	{
		_clip_trap_printf(cm, __FILE__, line, "no namespace %lx", area);
		return 0;
	}

	vp = _clip_memvar_space(cm, hp, hash, 1);
	if (!vp)
	{
		_clip_trap_printf(cm, __FILE__, line, "no namespace var %lx", hash);
		return 0;
	}

	return vp;
}
#endif

CLIP_DLLEXPORT int
_clip_field(ClipMachine * cm, long hash, long area)
{
	ClipVar *sp = cm->fp->sp;
	DBWorkArea *wa;
	const char nm[] = "_clip_field";
	int no;

	if (!(wa = get_area(cm, area, 0, 0)))
	{
			ClipVar *ap = _clip_ref_memvar_noadd(cm, area);
				if (ap)
				{
					ClipVar *vp = _clip_mget(cm, ap, hash);
						if (vp)
						{
							_clip_push(cm, vp);
								return 0;
						}
				}

		return rdd_err(cm, EG_NOVAR, 0, __FILE__, __LINE__, nm, er_nofield);
	}
	if ((no = _rdd_fieldno(wa->rd, hash)) == -1){
		char buf[11];
		_clip_hash_name(cm,hash,buf,sizeof(buf));
		return rdd_err(cm, EG_NOVAR, 0, __FILE__, __LINE__, buf, er_nofield);
	}
	sp->t.type = UNDEF_t;
	sp->t.flags = F_NONE;
	++(cm->fp->sp);
	return _rdd_takevalue(cm, wa, no, hash, sp, nm);
}

CLIP_DLLEXPORT int
_clip_try_field(ClipMachine * cm, long hash)
{
	ClipVar *sp = cm->fp->sp;
	DBWorkArea *wa;
	const char nm[] = "_clip_try_field";
	int no;

	if (!(wa = cur_area(cm)))
		return 1;

	if ((no = _rdd_fieldno(wa->rd, hash)) == -1)
		return 1;

	sp->t.type = UNDEF_t;
	sp->t.flags = F_NONE;
	++(cm->fp->sp);
	if (_rdd_takevalue(cm, wa, no, hash, sp, nm))
		return 1;

	return 0;
}

CLIP_DLLEXPORT int
_clip_take_field(ClipMachine * cm, long hash, long area, ClipVar * dest)
{
	DBWorkArea *wa;
	const char nm[] = "_clip_take_field";
	int fno,er;

	if (!(wa = get_area(cm, area, 0, 0)))
		return 1;

	if ((fno = _rdd_fieldno(wa->rd, hash)) == -1)
		return 1;

	dest->t.type = UNDEF_t;
	dest->t.flags = F_NONE;

	if ((er = _rdd_takevalue(cm, wa, fno, hash, dest, nm)))
		return er;
	return 0;
}

CLIP_DLLEXPORT int
_clip_fm_assign(ClipMachine * cm, long hash)
{
	ClipVar *sp = cm->fp->sp - 1;
	int r = _clip_fm_iassign(cm, hash);

	_clip_destroy(cm, sp);
	--cm->fp->sp;
	return r;
}

CLIP_DLLEXPORT int
_clip_fm_iassign(ClipMachine * cm, long hash)
{
	const char nm[] = "_clip_fm_iassign";
	int r = 0;
	ClipVar *sp = _clip_vptr(cm->fp->sp - 1);
	DBWorkArea *wa;
	int fno;

	if ((wa = cur_area(cm)) && (fno = _rdd_fieldno(wa->rd, hash)) != -1)
	{
		r = rdd_setvalue(cm, wa->rd, fno, sp, nm);
	}
	else
	{
		r = _clip_iassign(cm, _clip_ref_memvar(cm, hash));
	}
	return r;
}

CLIP_DLLEXPORT int
_clip_assign_field(ClipMachine * cm, long hash, long area)
{
	ClipVar *sp = cm->fp->sp - 1;
	int r = _clip_iassign_field(cm, hash, area);

	_clip_destroy(cm, sp);
	--cm->fp->sp;
	return r;
}

CLIP_DLLEXPORT int
_clip_iassign_field(ClipMachine * cm, long hash, long area)
{
	ClipVar *sp = _clip_vptr(cm->fp->sp - 1);
	DBWorkArea *wa;
	const char nm[] = "_clip_iassign_field";
	int fno,er;

	if (!(wa = get_area(cm, area, 0, 0)))
	{
		if (area < 0)
				{
			return rdd_err(cm, EG_BADALIAS, 0, __FILE__, __LINE__, nm, er_badalias);
		}
		else
		{
#if 1
				ClipVar *ap = _clip_ref_memvar_noadd(cm, area);
					if (ap)
					{
						ClipVar *vp = _clip_mget(cm, ap, hash);
							if (vp)
							{
					return _clip_iassign(cm, vp);
							}
					}
			return rdd_err(cm, EG_BADALIAS, 0, __FILE__, __LINE__, nm, er_badalias);
#else
			ClipVar *vp = space_var(cm, __LINE__, area, hash);

			if (!vp)
				return 1;
			else
				return _clip_iassign(cm, vp);
#endif
		}
	}

	if ((fno = _rdd_fieldno(wa->rd, hash)) == -1)
		return rdd_err(cm, EG_NOVAR, 0, __FILE__, __LINE__, nm, er_nofield);

	if ((er = rdd_setvalue(cm, wa->rd, fno, sp, nm))) return er;
	return 0;
}

CLIP_DLLEXPORT int
_clip_push_area(ClipMachine * cm, long area)
{
	DBWorkArea *wa;
	const char nm[] = "_clip_push_area";
	int no;

	add_ClipVect((cm->areaStack), (void *) (cm->curArea));

	if (!(wa = get_area(cm, area, 0, &no)) && area)
		return rdd_err(cm, EG_BADALIAS, 0, __FILE__, __LINE__, nm, er_badalias);

	cm->curArea = no;
	return 0;
}

CLIP_DLLEXPORT int
_clip_pop_area(ClipMachine * cm)
{
	int no = cm->areaStack->count;

	if (no < 1)
		return rdd_err(cm, EG_NOALIAS, 0, __FILE__, __LINE__, "_clip_pop_area", er_noalias);

	cm->areaStack->count--;
	cm->curArea = (int) cm->areaStack->items[no - 1];
	return 0;
}

CLIP_DLLEXPORT int
_clip_set_area(ClipMachine * cm, long area)
{
	DBWorkArea *wa;
	const char nm[] = "_clip_set_area";
	int no;

	if (!(wa = get_area(cm, area, 0, &no)) && area)
		return rdd_err(cm, EG_BADALIAS, 0, __FILE__, __LINE__, nm, er_badalias);

	cm->curArea = no;
	return 0;
}

CLIP_DLLEXPORT void
_clip_close_all(ClipMachine * cm)
{
	int i;

	for (i = 0; i < cm->areas->count; i++)
		close_area(cm, (DBWorkArea *) cm->areas->items[i], "DBCLOSEALL");
}

/* ] fields */
/* [ work area */
CLIP_DLLEXPORT int
_clip_register_driver(ClipMachine * cm, struct DBFuncTable *vtbl)
{
	return 0;
}

CLIP_DLLEXPORT struct DBFuncTable *
_clip_get_driver(ClipMachine * cm, const char *driver)
{
	return NULL;
}

DBWorkArea *
cur_area(ClipMachine * cm)
{
	DBWorkArea *wa = 0;

	if (!cm->areas->count)
		return NULL;
	wa = (DBWorkArea *) cm->areas->items[cm->curArea];
	if (wa && !wa->used)
		return NULL;
	return wa;
}

DBWorkArea *
get_area(ClipMachine * cm, long area, int any, int* no)
{
	DBWorkArea *wa = NULL;
	int n;

	if (no)
		*no = 0;

	if (!cm->areas->count)
		return 0;

	if (area == 0)
	{
		for (n = 0; n < cm->areas->count; n++)
		{
			DBWorkArea *wa;

			wa = (DBWorkArea *) cm->areas->items[n];
			if (wa == NULL || !wa->used)
				break;
		}
		if (n == cm->areas->count)
			add_ClipVect(cm->areas, NULL);
		if (no)
			*no = n;
		return cm->areas->items[n];
	}
	else if (area == -1)
		wa = (DBWorkArea *) cm->areas->items[cm->curArea];
	else
	{
		wa = (DBWorkArea *) HashTable_fetch(cm->aliases, area);
		if (!wa)
		{
			area -= 1;
			if (area >= 0 && area < cm->areas->count)
				wa = (DBWorkArea *) cm->areas->items[area];
			else {
				int i,l;

				area += 1;
				l = min(11,cm->areas->count);
				for(i=0;i<l;i++){
					if(A_K_aliasHashes[i]==area){
						wa = (DBWorkArea *) cm->areas->items[i];
						break;
					}
				}
			}
		}
	}

	if (!wa || (!wa->used && !any))
		return 0;

	if (no)
		*no = wa->no;
	return wa;
}

static int
close_area(ClipMachine * cm, DBWorkArea * wa, const char *__PROC__)
{
	int er;

	if (wa)
	{
		if (wa->rd)
		{
			int re;
			if((er = rdd_event(cm,EVENT_PRECLOSE,wa->rd->area,0,NULL,&re,__PROC__)))
				return er;
			if(!re)
				return 0;

			if((er = _clip_flushbuffer(cm,wa,__PROC__))) return er;
			if ((er = rdd_closearea(cm, wa->rd, __PROC__)))
				return er;
			if((er = rdd_event(cm,EVENT_POSTCLOSE,wa->rd->area,0,NULL,&re,__PROC__)))
				return er;
			wa->rd = NULL;
		}
		_clip_destroy_c_item(cm, wa->rd_item, _C_ITEM_TYPE_RDD);
		HashTable_remove(cm->aliases, wa->aliasHash);
		cm->areas->items[wa->no] = NULL;
		if(wa->trigger)
			free(wa->trigger);
		free(wa->name);
		free(wa->alias);
		free(wa);
	}
	return 0;
}

void
_clip_set_deleted(ClipMachine * cm, int value)
{
}

int
_clip_relation_chields(ClipMachine * cm, DBWorkArea * wa)
{
	return 0;
}

/* ] work area */
/* [ user interface */

int
clip_DBSETDRIVER(ClipMachine * cm)
{
	const char* __PROC__ = "DBSETDRIVER";
	const char* driver = _clip_parc(cm,1);
	int er;

	CHECKOPT1(1,CHARACTER_t);

	_clip_retc(cm,cm->def_db_driver);

	if(driver && driver[0]){
		int i;
		for(i=0;i<cm->ndbdrivers;i++){
			if(strncasecmp(driver,cm->dbdrivers[i].id,
				sizeof(cm->dbdrivers[i].id))==0){
				strncpy(cm->def_db_driver,driver,sizeof(cm->dbdrivers[i].id));
				break;
			}
		}
	}
	return 0;
err:
	return er;
}

int
clip__DBCREATE(ClipMachine * cm)
{
	const char *__PROC__ = "DBCREATE";
	const char *name = _clip_parc(cm, 1);
	ClipVar *stru = _clip_par(cm, 2);
	const char *driver = _clip_parc(cm, 3);
	char data_driver[4];
	char idx_driver[4];
	char memo_driver[4];
	int i,er;

	CHECKARG1(1, CHARACTER_t);
	CHECKARG1(2, ARRAY_t);
	CHECKOPT1(3, CHARACTER_t);

	if ((er = db_driver(cm, driver, data_driver, idx_driver, memo_driver, __PROC__)))
		return er;

	if ((er = rdd_create(cm, data_driver, memo_driver, name, stru, __PROC__)))
		return er;
	for (i = 0; i < stru->a.count; i++)
	{
		ClipVar *ap,*lp;
		ap = _clip_vptr(stru->a.items+i);
		if (ap->t.type!=ARRAY_t||ap->a.count<4)
			continue;
		lp = _clip_vptr(ap->a.items+2);
		ap = _clip_vptr(ap->a.items+1);
		if (ap->t.type!=CHARACTER_t)
			continue;

		/*if (toupper(stru->a.items[i].a.items[0].a.items[1].s.str.buf[0]) == 'M')*/
		if (toupper(ap->s.str.buf[0]) == 'M' ||
			(toupper(ap->s.str.buf[0]) == 'V' && lp->n.d >= 6))
		{
			char* mname = malloc(strlen(name)+1);
			char* s;

			strcpy(mname,name);
			if((s=strrchr(mname,'.')) && strrchr(mname,'/') < s)
				*s = 0;
			if ((er = rdd_creatememo(cm, memo_driver, mname, __PROC__))){
				free(mname);
				return er;
			}
			free(mname);
			break;
		}
	}
	return 0;
err:
	return er;
}

int
clip_DBACCESS(ClipMachine * cm)
{
/* empty */
	return 0;
}

int
clip_DBUSEAREA(ClipMachine * cm)
{
	const char *__PROC__ = "DBUSEAREA";
	int newArea = _clip_parl(cm, 1);
	const char *driver = _clip_parc(cm, 2);
	const char *name = _clip_parc(cm, 3);
	const char *alias = _clip_parc(cm, 4);
	int shared = _clip_parl(cm, 5);
	int readonly = _clip_parl(cm, 6);
	int tempo = _clip_parl(cm,7);
	char data_driver[4];
	DBWorkArea *wa = NULL;
	int no, i, re, er;
	const char deftrig[] = "SX_DEFTRIGGER";

	CHECKOPT1(1, LOGICAL_t);
	CHECKOPT1(2, CHARACTER_t);
	CHECKARG1(3, CHARACTER_t);
	CHECKOPT1(4, CHARACTER_t);
	CHECKOPT1(5, LOGICAL_t);
	CHECKOPT1(6, LOGICAL_t);
	CHECKOPT1(7, LOGICAL_t);

	if (_clip_parinfo(cm, 5) == UNDEF_t)
		shared = !(cm->flags & EXCLUSIVE_FLAG);

	if (cm->areas->count == 0)
		newArea = 1;
	if (!newArea)
	{
		no = cm->curArea;
		wa = (DBWorkArea *) cm->areas->items[no];
		if ((er = close_area(cm, wa, __PROC__)))
			return er;
	}
	else
	{
		for (no = 0; no < cm->areas->count; no++)
			if (cm->areas->items[no] == NULL)
				break;
	}

	wa = (DBWorkArea *) calloc(1,sizeof(DBWorkArea));
	if ((er = db_driver(cm, driver, data_driver, wa->idx_driver, wa->memo_driver, __PROC__)))
		goto err;
	if (!driver || !driver[0])
		driver = cm->def_db_driver;
	strcpy(wa->driver,driver);

	wa->name = malloc(strlen(name) + 1);
	strcpy(wa->name, name);

	if ((er = rdd_usearea(cm, data_driver, name, shared, readonly, tempo, &wa->rd, __PROC__)))
		goto err;

	if (alias)
	{
		wa->alias = malloc(strlen(alias) + 1);
		strcpy(wa->alias, alias);
	} else {
		char* s;
		wa->alias = malloc(strlen(wa->rd->name) + 1);
		strcpy(wa->alias, wa->rd->name);
		s = wa->alias;
		while ((s = strchr(s, '.')))
			*s = '_';
	}

	wa->rd->area = no;

	_clip_upstr(wa->alias, strlen(wa->alias));

	for (i = 0; i < wa->rd->nfields; i++)
	{
		if (wa->rd->fields[i].type == 'M' ||
			(wa->rd->fields[i].type == 'V' && wa->rd->fields[i].len >= 6))
		{
			char* s;
			char* tmpname = strdup(name);

			if((s=strrchr(tmpname,'.')))
				if(s[1]!='/' && s[1]!='\\')
					*s = 0;
			if ((er = rdd_setmemo(cm, wa->rd, wa->memo_driver, tmpname, __PROC__))){
				free(tmpname);
				goto err;
			}
			free(tmpname);
			break;
		}
	}

	wa->used = 1;
	wa->found = 0;
	wa->rd_item = _clip_store_c_item(cm, (void *) wa->rd, _C_ITEM_TYPE_RDD,
					 destroy_rdd_data);

	wa->no = cm->curArea = no;

	if (no == cm->areas->count)
		add_ClipVect(cm->areas, wa);
	else
		cm->areas->items[no] = wa;

	wa->aliasHash = _clip_casehashword(wa->alias, strlen(wa->alias));
	if(!HashTable_insert(cm->aliases, wa, wa->aliasHash) ||
		(strlen(wa->alias)==1 && wa->alias[0]>='A' && wa->alias[0]<='L')){
		char ermsg[100];

		_clip_destroy_c_item(cm, wa->rd_item, _C_ITEM_TYPE_RDD);
		HashTable_remove(cm->aliases, wa->aliasHash);
		cm->areas->items[wa->no] = NULL;
		sprintf(ermsg,"Alias already in use: %s",wa->alias);
		er = rdd_err(cm,EG_OPEN,0,__FILE__,__LINE__,__PROC__,ermsg);
		goto err;
	}

	if(cm->flags1 & AUTOPEN_FLAG){
		char iname[1024];
		char* s;
		int i;
		RDD_INDEX_VTBL* ivtbl = rdd_indexdriver(cm,wa->idx_driver,__PROC__);

		if(ivtbl && ivtbl->ismulti){
			strcpy(iname,wa->rd->path);
			if((s=strrchr(iname,'.')))
				if(s[1]!='/' && s[1]!='\\')
					*s = 0;
			for(i=0;i<cm->nidx_drivers;i++)
				if(strcasecmp(wa->idx_driver,cm->idx_drivers[i]->id)==0){
					strcat(iname,cm->idx_drivers[i]->suff);
					break;
				}
			if(access(iname,F_OK)==0){
				if ((er = rdd_setindex(cm, wa->rd, NULL, wa->idx_driver, iname, NULL, __PROC__)))
					goto err;
				wa->rd->indices[0]->structural = 1;
				if((er = rdd_setorder(cm,wa->rd,cm->autorder,__PROC__))) goto err;
				if((er = rdd_gotop(cm,wa->rd,__PROC__))) goto err;
			}
		}
	}

	wa->trighash = _clip_hashstr(deftrig);
	wa->trigger = strdup(deftrig);
	wa->trig_active = 1;
	if((er = rdd_event(cm,EVENT_PREUSE,wa->rd->area,0,NULL,&re,__PROC__))) goto err;
	if(re){
		if((er = rdd_event(cm,EVENT_POSTUSE,wa->rd->area,0,NULL,&re,__PROC__)))
			goto err;
	} else {
		if ((er = rdd_closearea(cm, wa->rd, __PROC__))) goto err;
		wa->rd = NULL;
		_clip_destroy_c_item(cm, wa->rd_item, _C_ITEM_TYPE_RDD);
		HashTable_remove(cm->aliases, wa->aliasHash);
		cm->areas->items[wa->no] = NULL;
		er = rdd_err(cm,EG_OPEN,0,__FILE__,__LINE__,__PROC__,
			"EVENT_PREUSE discarded");
		goto err;
	}
	_clip_retni(cm, wa->rd_item);
	return 0;

err:
	if(wa && wa->trigger)
		free(wa->trigger);
	if(wa && wa->name)
		free(wa->name);
	if(wa && wa->alias)
		free(wa->alias);
	if(wa)
		free(wa);
	return er;
}

int
clip_DBCLOSEAREA(ClipMachine * cm)
{
	const char *__PROC__ = "DBCLOSEAREA";
	DBWorkArea *wa = cur_area(cm);

	if (!wa) return 0;

	return close_area(cm, wa, __PROC__);
}

int
clip_DBCLOSEALL(ClipMachine * cm)
{
	_clip_close_all(cm);
	return 0;
}

int
clip_DBSELECTAREA(ClipMachine * cm)
{
	ClipVar *vp = _clip_par(cm, 1);
	ClipVar *data;
	int ret = -1,er;

	if (!vp)
	{
		_clip_retni(cm, cm->curArea + 1);
		return 0;
	}

	data = NEW(ClipVar);
	if (vp->t.type == CCODE_t || vp->t.type == PCODE_t)
	{
		_clip_eval(cm, _clip_vptr(vp), 0, 0, data);
		vp = data;
	}
	else if (vp->t.type == CHARACTER_t)
	{
		char ch = toupper(vp->s.str.buf[0]);

		if (ch >= '0' && ch <= '9')
			ret = atol(vp->s.str.buf);
		else if((vp->s.str.len==1) && (ch >= 'A') && (ch <= 'L'))
			ret = ch-'A'+1;
	}

	if (ret >= 0 || vp->t.type == NUMERIC_t)
	{
		int n;

		if (ret >= 0)
			n = ret;
		else
			n = _clip_double(vp);

		if (n)
		{
			ret = n - 1;
			if (n > cm->areas->count)
			{
				n -= cm->areas->count;
				while (n--)
					add_ClipVect(cm->areas, NULL);
			}
		}
		else
		{
			for (; n < cm->areas->count; n++)
			{
				DBWorkArea *wa;

				wa = (DBWorkArea *) cm->areas->items[n];
				if (wa == NULL || !wa->used)
					break;
			}
			ret = n;
			if (ret == cm->areas->count)
				add_ClipVect(cm->areas, NULL);
		}
		cm->curArea = ret;
	}
	else if (vp->t.type == CHARACTER_t)
	{
		long hash = _clip_casehashword(vp->s.str.buf,vp->s.str.len);
		DBWorkArea *wa = HashTable_fetch(cm->aliases, hash);

		if (wa)
			cm->curArea = wa->no;
		else {
			char err[100];
			sprintf(err,"Alias does not exist: %s",vp->s.str.buf);
			er = rdd_err(cm,EG_NOALIAS,0,__FILE__,__LINE__,vp->s.str.buf,err);
			goto err;
		}
	}

	_clip_retni(cm, ret + 1);
	_clip_destroy(cm, data);
	free(data);
	return 0;
err:
	_clip_destroy(cm, data);
	free(data);
	return er;
}

int
clip_DBCREATEINDEX(ClipMachine * cm)
{
	const char *__PROC__ = "DBCREATEINDEX";
	DBWorkArea *wa	= cur_area(cm);
	const char *name = _clip_parc(cm, 1);
	const char *expr = _clip_parc(cm, 2);
	ClipVar* block	= _clip_spar(cm, 3);
	int unique		= _clip_parl(cm, 4);
	int er;

	CHECKWA(wa);
	CHECKARG1(1, CHARACTER_t);
	CHECKARG1(2, CHARACTER_t);
	CHECKOPT2(3, CCODE_t, PCODE_t);
	CHECKOPT1(4, LOGICAL_t);

	if (_clip_parinfo(cm, 4) == UNDEF_t)
		unique = cm->flags & UNIQUE_FLAG;

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if ((er = rdd_createindex(cm, wa->rd, wa->idx_driver, name, NULL, expr, block, unique, __PROC__)))
		goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBCREATEIND(ClipMachine * cm)
{
	return clip_DBCREATEINDEX(cm);
}

int
clip_ORDCREATE(ClipMachine * cm)
{
	const char *__PROC__ = "ORDCREATE";
	DBWorkArea *wa = cur_area(cm);
	const char *name = _clip_parc(cm, 1);
	const char *tag  = _clip_parc(cm, 2);
	const char *expr = _clip_parc(cm, 3);
	ClipVar* block = _clip_spar(cm,4);
	int unique = _clip_parl(cm, 5);
	int er;

	CHECKWA(wa);
	CHECKOPT1(1, CHARACTER_t);
	CHECKOPT1(2, CHARACTER_t);
	CHECKARG1(3, CHARACTER_t);
	CHECKOPT2(4, CCODE_t, PCODE_t);
	CHECKOPT1(5, LOGICAL_t);

	if (_clip_parinfo(cm, 4) == UNDEF_t)
		unique = cm->flags & UNIQUE_FLAG;

	if(!name)
		name = wa->rd->name;

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if ((er = rdd_createindex(cm, wa->rd, wa->idx_driver, name, tag, expr, block, unique, __PROC__)))
		goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBSETINDEX(ClipMachine * cm)
{
	const char *__PROC__ = "DBSETINDEX";
	DBWorkArea *wa = cur_area(cm);
	const char *name = _clip_parc(cm, 1);
	int er;

	CHECKWA(wa);
	CHECKARG1(1, CHARACTER_t);

	return rdd_setindex(cm, wa->rd, NULL, wa->idx_driver, name, NULL, __PROC__);
err:
	return er;
}

int
clip_DBSETORDER(ClipMachine * cm)
{
	const char *__PROC__ = "DBSETORDER";
	DBWorkArea *wa = cur_area(cm);
	int order = _clip_parni(cm, 1);
	int er;

	CHECKWA(wa);
	CHECKOPT1(1, NUMERIC_t);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	return rdd_setorder(cm, wa->rd, order, __PROC__);
err:
	return er;
}

int
clip_DBCLEARINDEX(ClipMachine * cm)
{
	const char *__PROC__ = "DBCLEARINDEX";
	DBWorkArea *wa = cur_area(cm);

	CHECKWA(wa);

	return rdd_clearindex(cm, wa->rd, __PROC__);
}

int
clip_DBREINDEX(ClipMachine * cm)
{
	const char *__PROC__ = "DBREINDEX";
	DBWorkArea *wa = cur_area(cm);
	int er;

	CHECKWA(wa);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	return rdd_reindex(cm, wa->rd, __PROC__);
err:
	return er;
}

int
clip___DBPACK(ClipMachine * cm)
{
	const char* __PROC__ = "__DBPACK";
	DBWorkArea* wa = cur_area(cm);
	int er;

	CHECKWA(wa);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	return rdd_pack(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip___DBZAP(ClipMachine * cm)
{
	const char *__PROC__ = "__DBZAP";
	DBWorkArea *wa = cur_area(cm);

	CHECKWA(wa);
	return rdd_zap(cm, wa->rd, __PROC__);
}

int
clip_DBGOTOP(ClipMachine * cm)
{
	const char *__PROC__ = "DBGOTOP";
	DBWorkArea *wa = cur_area(cm);
	int er;

	CHECKWA(wa);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if ((er = rdd_gotop(cm, wa->rd, __PROC__)))
		goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBAPPEND(ClipMachine * cm)
{
	const char *__PROC__ = "DBAPPEND";
	DBWorkArea *wa = cur_area(cm);
	int rellocks = _clip_parl(cm,1);
	ClipVar* ap = _clip_par(cm,2);
	int* neterr = _clip_fetch_item(cm, HASH_neterror);
	int er;

	CHECKWA(wa);
	CHECKOPT1(1,LOGICAL_t);
	CHECKOPT1(2,MAP_t);

	if(_clip_parinfo(cm,1)==UNDEF_t)
		rellocks = 1;

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	WRITELOCK;
	if(rellocks){
		if((er = rdd_ulock(cm,wa->rd,0,0,__PROC__))) goto err_unlock;
	}
	if((er = rdd_append(cm, wa->rd, neterr, __PROC__))) goto err_unlock;
	if(!(*neterr)){
		if(ap && ap->t.type!=UNDEF_t)
			if((er = rdd_dbwrite(cm,wa->rd,ap,__PROC__))) goto err_unlock;
	}
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBDELETE(ClipMachine * cm)
{
	const char *__PROC__ = "DBDELETE";
	DBWorkArea *wa = cur_area(cm);
	int er;

	CHECKWA(wa);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	if ((er = rdd_delete(cm, wa->rd, __PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_DBRECALL(ClipMachine * cm)
{
	const char *__PROC__ = "DBRECALL";
	DBWorkArea *wa = cur_area(cm);
	int er;

	CHECKWA(wa);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	if ((er = rdd_recall(cm, wa->rd, __PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_DBGOBOTTOM(ClipMachine * cm)
{
	const char *__PROC__ = "DBGOBOTTOM";
	DBWorkArea *wa = cur_area(cm);
	int er;

	CHECKWA(wa);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if ((er = rdd_gobottom(cm, wa->rd, __PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBGOTO(ClipMachine * cm)
{
	const char *__PROC__ = "DBGOTO";
	DBWorkArea *wa = cur_area(cm);
	int rec = _clip_parni(cm, 1);
	int er;

	CHECKWA(wa);
	CHECKARG1(1, NUMERIC_t);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if ((er = rdd_goto(cm, wa->rd, rec, __PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBSKIP(ClipMachine * cm)
{
	const char *__PROC__ = "DBSKIP";
	int recs = _clip_parni(cm, 1);
	DBWorkArea *wa = cur_area(cm);
	int er;

	CHECKWA(wa);
	CHECKOPT1(1, NUMERIC_t);

	if (_clip_parinfo(cm, 1) == UNDEF_t)
		recs = 1;

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if ((er = rdd_skip(cm, wa->rd, recs, __PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBSEEK(ClipMachine * cm)
{
	const char *__PROC__ = "DBSEEK";
	DBWorkArea *wa = cur_area(cm);
	ClipVar *v = _clip_par(cm, 1);
	int soft = _clip_parl(cm, 2);
	int last = _clip_parl(cm,3);
	int found,er;

	_clip_retl(cm,0);
	CHECKWA(wa);
	CHECKOPT1(2, LOGICAL_t);
	CHECKOPT1(3,LOGICAL_t);

	if (_clip_parinfo(cm, 2) == UNDEF_t)
		soft = (cm->flags & SOFTSEEK_FLAG);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if ((er = rdd_seek(cm, wa->rd, v, soft, last, &found, __PROC__)))
		goto err_unlock;
	UNLOCK;
	wa->found = (found?1:0);
	_clip_retl(cm, found);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip___DBLOCATE(ClipMachine * cm)
{
	const char *__PROC__ = "__DBLOCATE";
	ClipVar *fexpr = _clip_spar(cm, 1);
	ClipVar *wexpr = _clip_spar(cm, 2);
	ClipVar *vnext = _clip_par(cm, 3);
	ClipVar *vrec = _clip_par(cm, 4);
	ClipVar *vrest = _clip_par(cm, 5);
	DBWorkArea *wa = cur_area(cm);
	int found,er;

	if(!wa)
		return 0;

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_locate(cm,wa->rd,NULL,fexpr,wexpr,vnext,vrec,vrest,&found,__PROC__)))
		goto err_unlock;
	UNLOCK;

	wa->found = found;
	_clip_retl(cm,found);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip___DBSETLOCATE(ClipMachine* cm)
{
	const char* __PROC__ = "__DBSETLOCATE";
	ClipVar* fexpr = _clip_spar(cm,1);
	ClipVar* rp = RETPTR(cm);
	DBWorkArea *wa = cur_area(cm);
	int er;

	if(!wa)
		return 0;

	CHECKOPT2(1,PCODE_t,CCODE_t);

	if(_clip_parinfo(cm,1) == UNDEF_t){
		if(wa->rd->locate_filter && wa->rd->locate_filter->fps)
			_clip_dup(cm,rp,&wa->rd->locate_filter->fps->bfilter);
	} else {
		if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
		READLOCK;
		if(wa->rd->locate_filter)
			if((er = rdd_destroyfilter(cm,wa->rd->locate_filter,__PROC__)))
				goto err_unlock;
		if((er = rdd_createfilter(cm,wa->rd,&wa->rd->locate_filter,fexpr,NULL,NULL,__PROC__)))
			goto err_unlock;
		if(wa->rd->filter)
			if((er = rm_intersect(cm,wa->rd->locate_filter,wa->rd->filter,__PROC__)))
				goto err_unlock;
		UNLOCK;
	}
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip___DBSETLOC(ClipMachine* cm)
{
	return clip___DBSETLOCATE(cm);
}

int
clip___DBLOCATEOPTIMIZE(ClipMachine * cm)
{
	const char *__PROC__ = "__DBLOCATE";
	char *cfor = _clip_parc(cm, 1);
	ClipVar *bfor = _clip_spar(cm, 2);
	ClipVar *wexpr = _clip_spar(cm, 3);
	ClipVar *vnext = _clip_par(cm, 4);
	ClipVar *vrec = _clip_par(cm, 5);
	ClipVar *vrest = _clip_par(cm, 6);
	DBWorkArea *wa = cur_area(cm);
	int found,er;

	if(!wa)
		return 0;

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_locate(cm,wa->rd,cfor,bfor,wexpr,vnext,vrec,vrest,&found,__PROC__)))
		goto err_unlock;
	UNLOCK;

	wa->found = found;
	_clip_retl(cm,found);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip___DBCONTINUE(ClipMachine * cm)
{
	const char *__PROC__ = "__DBCONTINUE";
	DBWorkArea *wa = cur_area(cm);
	int found,er;

	if(!wa)
		return 0;

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_continue(cm,wa->rd,&found,__PROC__))) goto err_unlock;
	UNLOCK;

	wa->found = found;
	_clip_retl(cm,found);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_BOF(ClipMachine * cm)
{
	const char *__PROC__ = "BOF";
	DBWorkArea *wa = cur_area(cm);
	int bof,er;

	_clip_retl(cm,0);
	if(!wa) return 0;
	if((er = rdd_bof(cm,wa->rd,&bof,__PROC__))) return er;
	_clip_retl(cm,bof);
	return 0;
}

int
clip_EOF(ClipMachine * cm)
{
	const char *__PROC__ = "EOF";
	DBWorkArea *wa = cur_area(cm);
	int eof,er;

	_clip_retl(cm,0);
	if(!wa) return 0;
	if((er = rdd_eof(cm,wa->rd,&eof,__PROC__)))	return er;
	_clip_retl(cm,eof);
	return 0;
}

int
clip_USED(ClipMachine * cm)
{
	DBWorkArea *wa = cur_area(cm);
	int ret = 0;

	if(wa)
		ret = wa->used;

	_clip_retl(cm, ret);
	return 0;
}

int
clip_DELETED(ClipMachine * cm)
{
	const char *__PROC__ = "DELETED";
	DBWorkArea *wa = cur_area(cm);
	int deleted,er;

	_clip_retl(cm,0);
	if(!wa) return 0;

	if((er = rdd_deleted(cm,wa->rd,&deleted,__PROC__))) goto err;
	_clip_retl(cm,deleted);
	return 0;
err:
	return er;
}

int
clip_DELE(ClipMachine * cm)
{
	return clip_DELETED(cm);
}

int
clip_RECNO(ClipMachine * cm)
{
	const char *__PROC__ = "RECNO";
	DBWorkArea *wa = cur_area(cm);
	int recno,er;

	_clip_retndp(cm,0,7,0);
	if(!wa) return 0;

	if((er = rdd_recno(cm,wa->rd,&recno,__PROC__))) return er;
	_clip_retndp(cm,recno,7,0);
	return 0;
}

int
clip_RECCOUNT(ClipMachine * cm)
{
	const char *__PROC__ = "RECCOUNT";
	DBWorkArea *wa = cur_area(cm);
	int lastrec,er;

	_clip_retni(cm,0);
	if(!wa) return 0;
	READLOCK;
	if((er = rdd_lastrec(cm,wa->rd,&lastrec,__PROC__))) goto err_unlock;
	UNLOCK;
	_clip_retni(cm,lastrec);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_LASTREC(ClipMachine * cm)
{
	const char *__PROC__ = "LASTREC";
	DBWorkArea *wa = cur_area(cm);
	int lastrec,er;

	_clip_retni(cm,0);
	if(!wa) return 0;
	READLOCK;
	if((er = rdd_lastrec(cm,wa->rd,&lastrec,__PROC__))) goto err_unlock;
	UNLOCK;
	_clip_retni(cm,lastrec);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBSTRUCT(ClipMachine * cm)
{
	const char* __PROC__ = "DBSTRUCT";
	DBWorkArea *wa;
	int nfld, i;
	ClipVar *rp = RETPTR(cm);
	long vect[2];
	int area = _clip_parni(cm,1);
	int er;

	CHECKOPT1(1,NUMERIC_t);

	if(_clip_parinfo(cm,1)==UNDEF_t)
		wa = cur_area(cm);
	else
		wa = get_area(cm,area,0,0);

	if(!wa){
		vect[0] = 0;
		return _clip_array(cm, rp, 1, vect);
	}

	nfld = wa->rd->nfields;
	vect[0] = nfld;
	vect[1] = 4 + ((wa->rd->vtbl->dbfsig == 0x03)?0:2);
	_clip_array(cm, rp, 2, vect);

	for (i = 0; i < nfld; i++)
	{
		ClipVar var;
		RDD_FIELD *fp = &wa->rd->fields[i];

		vect[0] = i;
		memset(&var, 0, sizeof(ClipVar));

		var.t.type = CHARACTER_t;
		var.s.str.buf = fp->name;
		var.s.str.len = strlen(fp->name);
		vect[1] = 0;
		_clip_aset(cm, rp, &var, 2, vect);

		var.s.str.buf = malloc(2);
		var.s.str.buf[0] = fp->type;
		var.s.str.buf[1] = 0;
		var.s.str.len = 1;
		vect[1] = 1;
		_clip_aset(cm, rp, &var, 2, vect);
		free(var.s.str.buf);

		var.t.type = NUMERIC_t;
		var.n.d = fp->len;
		var.t.memo = 0;
		vect[1] = 2;
		_clip_aset(cm, rp, &var, 2, vect);

		var.n.d = fp->dec;
		vect[1] = 3;
		_clip_aset(cm, rp, &var, 2, vect);

		if(wa->rd->vtbl->dbfsig == 0x30){
			var.t.type = LOGICAL_t;
			var.l.val = fp->binary;
			vect[1] = 4;
			_clip_aset(cm,rp,&var,2,vect);

			var.l.val = fp->nullable;
			vect[1] = 5;
			_clip_aset(cm,rp,&var,2,vect);
		}
	}
	return 0;
err:
	return er;
}

int
clip_AFIELDS(ClipMachine * cm)
{
	DBWorkArea *wa = cur_area(cm);
	int nfld, i;
	long vect[1];
	ClipVar *name_ap = _clip_par(cm, 1);
	ClipVar *type_ap = _clip_par(cm, 2);
	ClipVar *len_ap = _clip_par(cm, 3);
	ClipVar *dec_ap = _clip_par(cm, 4);
	int r;

	if(!wa){
		_clip_retni(cm,0);
		return 0;
	}

	nfld = wa->rd->nfields;

	vect[0] = nfld;
	if (name_ap && name_ap->t.type != ARRAY_t)
		name_ap = NULL;
	if (type_ap && type_ap->t.type != ARRAY_t)
		type_ap = NULL;
	if (len_ap && len_ap->t.type != ARRAY_t)
		len_ap = NULL;
	if (dec_ap && dec_ap->t.type != ARRAY_t)
		dec_ap = NULL;

	for (i = 0; i < nfld; i++)
	{
		ClipVar var;
		RDD_FIELD *fp = &wa->rd->fields[i];

		vect[0] = i;
		memset(&var, 0, sizeof(ClipVar));

		if (name_ap && i < name_ap->a.count)
		{
			var.t.type = CHARACTER_t;
			var.s.str.buf = fp->name;
			var.s.str.len = strlen(fp->name);
			_clip_aset(cm, name_ap, &var, 1, vect);
		}

		if (type_ap && i < type_ap->a.count)
		{
			var.t.type = CHARACTER_t;
			var.s.str.buf = malloc(2);
			var.s.str.buf[0] = fp->type;
			var.s.str.buf[1] = 0;
			var.s.str.len = 1;
			_clip_aset(cm, type_ap, &var, 1, vect);
		}

		if (len_ap && i < len_ap->a.count)
		{
			var.t.type = NUMERIC_t;
			var.t.flags = F_NONE;
			var.n.d = fp->len;
			var.t.memo = 0;
			_clip_aset(cm, len_ap, &var, 1, vect);
		}

		if (dec_ap && i < dec_ap->a.count)
		{
			var.t.type = NUMERIC_t;
			var.n.d = fp->dec;
			var.t.memo = 0;
			_clip_aset(cm, dec_ap, &var, 1, vect);
		}
	}
	r = 0x7fffffff;
	if(name_ap)
		if(name_ap->a.count<r)
			r = name_ap->a.count;
	if(type_ap)
		if(type_ap->a.count<r)
			r = type_ap->a.count;
	if(len_ap)
		if(len_ap->a.count<r)
			r = len_ap->a.count;
	if(dec_ap)
		if(dec_ap->a.count<r)
			r = dec_ap->a.count;
	_clip_retni(cm,r);
	return 0;
}

int clip_FCOUNT(ClipMachine * cm){
	DBWorkArea* wa = cur_area(cm);

	_clip_retni(cm,0);
	if(!wa) return 0;

	_clip_retni(cm,wa->rd->nfields);
	return 0;
}

int
clip_FIELDNAME(ClipMachine * cm)
{
	const char* __PROC__ = "FIELDNAME";
	DBWorkArea* wa = cur_area(cm);
	int fld = _clip_parni(cm, 1) - 1;

	if(!wa){
		_clip_retc(cm, "");
		return 0;
	}

	return rdd_fieldname(cm, wa->rd, fld, __PROC__);
}

int
clip_FIELD(ClipMachine * cm)
{
	return clip_FIELDNAME(cm);
}

int
clip_FIELDPOS(ClipMachine * cm)
{
	const char* __PROC__ = "FIELDPOS";
	DBWorkArea* wa = cur_area(cm);
	const char* name = _clip_parc(cm,1);
	int er;

	_clip_retni(cm,0);
	if(!wa) return 0;

	CHECKARG1(1,CHARACTER_t);

	_clip_retni(cm,_rdd_fieldno(wa->rd,_clip_casehashword(name,strlen(name)))+1);
	return 0;
err:
	return er;
}

static int
is_dig(const char *s, int l)
{
	int i;

	for (i = 0; i < l; i++)
		if (!isdigit(s[i]))
			return 0;
	return 1;
}

static int
is_id(int c)
{
	if (isalnum(c))
		return 1;
	if (c=='_')
		return 1;
	return 0;
}


/*
	return 1 if memvar, 2 if field name, 3 if array/map selector
		, 0 if unspecified (field/memvar)
	*fnamep name of field or memvar
	*anamep alias (if exist)
	*dimp - realloc'able array index vector
	*ndimp - it's length
*/
CLIP_DLLEXPORT int
_clip_parse_name(char *name, int l, char **anamep, int *alp, char **fnamep
		, int *flp, long **dimp, int *ndimp)
{
	char *s, *e, *p, *ep;
	int ret = 0;
	char *aname = 0, *fname = 0;
	int al = 0, fl = 0;
	long val;
	int ll;

	for (e = name + l; e>name && isspace(e[-1]); e--,l--)
		;
	fname = name;
	fl = l;

	for (s = name; s < e; s++)
	{
		int el, c = 0;

		for (; s < e && isspace(*s); s++)
			;
		p = s;
		for (ep = p; ep < e && is_id((c = *ep)); ep++)
			;
		if (ep == e)
			break;
		if (c != ' ' && c != '\t' && c != '-'
			&& c != '[' && c != ']' && c != ':')
			continue;

		el = ep - p;
		if ((el == 5 && !strncasecmp(p, "field", 5))
			|| (el == 6 && !strncasecmp(p, "_field", 6))
			|| (el == 1 && !strncasecmp(p, "f", 1)))
		{
			for (; ep < e && (c = *ep) != '-'; ep++)
				;
			if (c == '-' && ep < e && ep[1] == '>')
			{
				for (p = ep + 2; (p < e && *p == ' ') || *p == '\n'; p++)
					;
				fname = p;
				fl = e - p;
				ret = 2;
			}
		}
		else if ((el == 6 && !strncasecmp(p, "memvar", 6))
			 || (el == 1 && !strncasecmp(p, "m", 1)))
		{
			for (; ep < e && (c = *ep) != '-'; ep++)
				;
			if (c == '-' && ep < e && ep[1] == '>')
			{
				for (p = ep + 2; (p < e && *p == ' ') || *p == '\n'; p++)
					;
				fname = p;
				fl = e - p;
				ret = 1;
			}
		}
		else if (!strncasecmp(ep, "::", 2))
		{
			fname = "__SELF__";
			fl = 8;
			ep += 2;
		}

		if (!ret)
		{
			fname = p;
			fl = ep - p;
			ll = strspn(ep, " \t\n\r");
			ep += ll;
			ll = strspn(ep, "[]:->");
			if (ll == 2 && ep[0] == '-' && ep[1] == '>')
			{
				al = el;
				aname = p;
				p = ep + 2;
				ll = strspn(p, " \t\n\r");
				p += ll;
				fname = p;
				fl = strcspn(p, " \t\r\n[]:-");
				ret = 2;
			}
		}

		if (!ret)
		{
			while (ep < e)
			{
				ll = strspn(ep, " \t\n\r[]:");
				ep += ll;
				ll = strcspn(ep, " \t\n\r[]:");
				if (!ll)
					break;

				ret = 3;

				if (dimp && ndimp)
					*dimp = (long *) realloc(*dimp, sizeof(long) * (1 + *ndimp));

				if (is_dig(ep, ll))
					val = atoi(ep) - 1;
				else
					val = _clip_casehashbytes(0, ep, ll);
				if (dimp && ndimp)
				{
					(*dimp)[*ndimp] = val;
					(*ndimp)++;
				}
				ep += ll;
			}
		}
	}

	if (anamep && alp)
	{
		*anamep = aname;
		*alp = al;
	}
	if (fnamep && flp)
	{
		*fnamep = fname;
		*flp = fl;
	}

	return ret;
}

int
clip_ISFIELD(ClipMachine * cm)
{
	DBWorkArea *wa = cur_area(cm);
	int l, ret = 0;
	char *name = _clip_parcl(cm, 1, &l);
	char *aname, *fname;
	int al, fl;

	if (name)
	{
	if (wa)
	{
		if (_rdd_fieldno(wa->rd,_clip_casehashword(name, l))!=-1)
			ret = 1;
	}

	if (!ret)
	{
		if (_clip_parse_name(name, l, &aname, &al, &fname, &fl, 0, 0) == 2)
		{
			if (aname)
				wa = get_area(cm, _clip_casehashword(aname, al), 0, 0);
			else
				wa = cur_area(cm);
			if (wa && fname)
			{
				if (_rdd_fieldno(wa->rd,_clip_casehashword(fname, fl))!=-1)
					ret = 1;
			}
		}
	}
	}

	_clip_retl(cm, ret);
	return 0;
}

CLIP_DLLEXPORT int
_clip_nameassign(ClipMachine * cm, char *name, int l, ClipVar * vp, int fieldprec)
{
	int r;
	char *aname, *fname;
	int al, fl;
	DBWorkArea *wa;
	char nm[] = "_clip_nameassign";
	long *dim = 0;
	int ndim = 0;

	if (fieldprec)
	{
		wa = cur_area(cm);
		if (wa)
		{
			r = rdd_setvaluebn(cm,wa->rd,name,vp,nm);
			if(!r)
				return 0;
		}
		else
			return rdd_err(cm, EG_NOALIAS, 0, __FILE__, __LINE__, nm,
				er_noalias);
	}

	r = _clip_parse_name(name, l, &aname, &al, &fname, &fl, &dim, &ndim);
	if (r == 2)
	{
		if (aname)
			wa = get_area(cm, _clip_casehashword(aname, al), 0, 0);
		else
			wa = cur_area(cm);
		if (wa && fname)
		{
			r = rdd_setvaluebn(cm, wa->rd, fname, vp, nm);
			if(r)
				return r;
		}
		else
			return EG_NOALIAS;
	}
	else if (r==3)
	{
		int r = EG_NOVAR;
		ClipVar *rp;

		rp = _clip_ref_memvar(cm, _clip_casehashword(fname, fl));
		if (rp)
			r = _clip_aset(cm, rp, vp, ndim, dim);
		free(dim);

		return r;
	}
	else
	{
		ClipVar *rp;

		rp = _clip_ref_memvar(cm, _clip_casehashword(fname, fl));
		if (rp)
		{
			if (_clip_mclone(cm, rp, vp))
				return EG_NOVAR;
		}
		else
			return EG_NOVAR;

	}

	return 0;
}

int
clip_SETFIELD(ClipMachine * cm)
{
	int l;
	char *name = _clip_parcl(cm, 1, &l);
	ClipVar *vp = _clip_par(cm, 2);

	if (!vp || !name)
		return 0;

	return _clip_nameassign(cm, name, l, vp, 1);
}

int
clip_FIELDGET(ClipMachine * cm)
{
	const char* __PROC__ = "FIELDGET";
	DBWorkArea* wa = cur_area(cm);
	int fno = _clip_parni(cm,1);
	int er;

	if(!wa) return 0;
	CHECKARG1(1,NUMERIC_t);

	if(fno < 1 || fno > wa->rd->nfields)
		return 0;

	if((er = rdd_getvalue(cm,wa->rd,fno-1,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_FIELDPUT(ClipMachine * cm)
{
	const char* __PROC__ = "FIELDPUT";
	DBWorkArea* wa = cur_area(cm);
	int fno = _clip_parni(cm,1);
	ClipVar* vp = _clip_par(cm,2);
	int er;

	if(!wa) return 0;

	CHECKARG1(1,NUMERIC_t);

	if(fno < 1 || fno > wa->rd->nfields)
		return 0;

	if((er = rdd_setvalue(cm,wa->rd,fno-1,vp,__PROC__))) goto err;
	_clip_clone(cm,RETPTR(cm),vp);
	return 0;
err:
	return er;
}

int
clip_DBREAD(ClipMachine * cm)
{
	const char* __PROC__ = "DBREAD";
	DBWorkArea *wa = cur_area(cm);
	int er;

	if (!wa)
		return rdd_err(cm, EG_NOTABLE, 0, __FILE__, __LINE__, __PROC__,
			er_notable);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_dbread(cm,wa->rd,RETPTR(cm),__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBWRITE(ClipMachine * cm)
{
	const char* __PROC__ = "DBWRITE";
	DBWorkArea *wa = cur_area(cm);
	ClipVar* ap = _clip_par(cm,1);
	int er;

	if (!wa)
		return rdd_err(cm, EG_NOTABLE, 0, __FILE__, __LINE__, __PROC__,
			er_notable);
	CHECKARG1(1,MAP_t);

	WRITELOCK;
	if((er = rdd_dbwrite(cm,wa->rd,ap,__PROC__))) goto err_unlock;
	UNLOCK;
	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ALIAS(ClipMachine * cm)
{
	int nwa = _clip_parni(cm, 1);
	DBWorkArea *wa;

	if (nwa > 0)
		wa = get_area(cm, nwa, 0, 0);
	else
		wa = cur_area(cm);

	if (!wa)
	{
		_clip_retc(cm, "");
		return 0;
	}

	_clip_retc(cm, wa->alias);
	return 0;
}

int
clip_DBF(ClipMachine * cm)
{
	return clip_ALIAS(cm);
}

int
clip_SELECT(ClipMachine * cm)
{
	const char *alias = _clip_parc(cm, 1);
	DBWorkArea *wa;
	int i, ret = 0;
	char *al,*e;

	if (!alias)
	{
		_clip_retni(cm, cm->curArea + 1);
		return 0;
	}

	al = strdup(alias);
	e = al+strlen(al);
	while(*(--e)==' ');
	*(e+1) = 0;
	for (i = 0; i < cm->areas->count; i++)
	{
		wa = (DBWorkArea *) cm->areas->items[i];
		if (wa && wa->alias && !strcasecmp(al, wa->alias))
		{
			ret = i + 1;
			break;
		}
	}
	free(al);

	_clip_retni(cm, ret);
	return 0;
}

int
clip_INDEXKEY(ClipMachine * cm)
{
	const char* __PROC__ = "INDEXKEY";
	DBWorkArea* wa = cur_area(cm);
	int ord = _clip_parni(cm,1);
	int er;

	_clip_retc(cm,"");
	CHECKWA(wa);
	CHECKOPT1(1,NUMERIC_t);

	if(ord == 0)
		ord = wa->rd->curord+1;

	if(ord < 1 || ord > wa->rd->ords_opened)
		return 0;

	_clip_retc(cm,wa->rd->orders[ord-1]->expr);
	return 0;
err:
	return er;
}

int
clip_INDEXORD(ClipMachine * cm)
{
	DBWorkArea* wa = cur_area(cm);

	_clip_retni(cm,0);
	if(!wa) return 0;

	_clip_retni(cm,wa->rd->curord+1);
	return 0;
}

int
clip_RDDSETDEFAULT(ClipMachine * cm)
{
	const char* __PROC__ = "RDDSETDEFAULT";
	const char* driver = _clip_parc(cm,1);
	int er;

	CHECKOPT1(1,CHARACTER_t);

	_clip_retc(cm,cm->def_db_driver);

	if(driver && driver[0]){
		int i;
		for(i=0;i<cm->ndbdrivers;i++){
			if(strncasecmp(driver,cm->dbdrivers[i].id,
				sizeof(cm->dbdrivers[i].id))==0){
				strncpy(cm->def_db_driver,driver,sizeof(cm->dbdrivers[i].id));
				cm->def_db_driver[6] = 0;
				strcpy(cm->def_data_driver,cm->dbdrivers[i].data);
				strcpy(cm->def_idx_driver,cm->dbdrivers[i].idx);
				strcpy(cm->def_memo_driver,cm->dbdrivers[i].memo);
				break;
			}
		}
	}
	return 0;
err:
	return er;
}

int
clip_INDEXEXT(ClipMachine * cm)
{
	int i,j;
	for(i=0;i<cm->ndbdrivers;i++){
		if(strncasecmp(cm->def_db_driver,cm->dbdrivers[i].id,
			sizeof(cm->def_db_driver))==0){
			for(j=0;j<cm->nidx_drivers;j++){
				if(strncasecmp(cm->idx_drivers[j]->id,cm->dbdrivers[i].idx,
					sizeof(cm->idx_drivers[j]->id))==0){

					_clip_retc(cm,cm->idx_drivers[j]->suff);
					break;
				}
			}
			break;
		}
	}
	return 0;
}

int
clip_ORDBAGEXT(ClipMachine* cm)
{
	return clip_INDEXEXT(cm);
}

int
clip_TABLEEXT(ClipMachine * cm)
{
	int i,j;
	for(i=0;i<cm->ndbdrivers;i++){
		if(strncasecmp(cm->def_db_driver,cm->dbdrivers[i].id,
			sizeof(cm->def_db_driver))==0){
			for(j=0;j<cm->ndata_drivers;j++){
				if(strncasecmp(cm->data_drivers[j]->id,cm->dbdrivers[i].data,
					sizeof(cm->data_drivers[j]->id))==0){

					_clip_retc(cm,cm->data_drivers[j]->suff);
					break;
				}
			}
			break;
		}
	}
	return 0;
}

int
clip_MEMOEXT(ClipMachine * cm)
{
	int i,j;
	for(i=0;i<cm->ndbdrivers;i++){
		if(strncasecmp(cm->def_db_driver,cm->dbdrivers[i].id,
			sizeof(cm->def_db_driver))==0){
			for(j=0;j<cm->nmemo_drivers;j++){
				if(strncasecmp(cm->memo_drivers[j]->id,cm->dbdrivers[i].memo,
					sizeof(cm->memo_drivers[j]->id))==0){

					_clip_retc(cm,cm->memo_drivers[j]->suff);
					break;
				}
			}
			break;
		}
	}
	return 0;
}

int
clip_RDDNAME(ClipMachine * cm)
{
#ifndef CLIPPER50_COMPATIBLE
	const char* __PROC__ = "RDDNAME";
#endif
	DBWorkArea* wa = cur_area(cm);

	_clip_retc(cm,"");
	CHECKWA(wa);

	_clip_retc(cm,wa->driver);
	return 0;
}

int
clip_RDDLIST(ClipMachine * cm)
{
	ClipVar* rp = RETPTR(cm);
	long vect[1];
	int i;

	vect[0] = cm->ndbdrivers;
	_clip_array(cm,rp,1,vect);

	for(i=0;i<cm->ndbdrivers;i++){
		ClipVar var;
		var.t.type = CHARACTER_t;
		var.t.flags = F_NONE;
		var.t.memo = 0;
		var.s.str.len = strlen(cm->dbdrivers[i].id);
		var.s.str.buf = cm->dbdrivers[i].id;
		vect[0] = i;
		_clip_aset(cm, rp, &var, 1, vect);
	}
	return 0;
}

int
clip_LUPDATE(ClipMachine * cm)
{
	const char* __PROC__ = "LUPDATE";
	DBWorkArea* wa = cur_area(cm);
	int er;

	if(!wa) return 0;

	READLOCK;
	if((er = wa->rd->vtbl->lupdate(cm,wa->rd,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_RECSIZE(ClipMachine * cm)
{
	DBWorkArea* wa = cur_area(cm);

	_clip_retni(cm,0);
	if(!wa) return 0;

	_clip_retni(cm,wa->rd->recsize);
	return 0;
}

int
clip_HEADER(ClipMachine * cm)
{
	DBWorkArea* wa = cur_area(cm);

	_clip_retni(cm,0);
	if(!wa) return 0;

	_clip_retni(cm,wa->rd->hdrsize);
	return 0;
}

CLIP_DLLEXPORT int
_clip_filter(void *cm)
{
	return 0;
}

int
clip_DBCLEARFILTER(ClipMachine * cm)
{
	const char* __PROC__ = "DBCLEARFILTER";
	DBWorkArea *wa = cur_area(cm);

	CHECKWA(wa);

	return rdd_clearfilter(cm,wa->rd,__PROC__);
}

int
clip_DBSETFILTER(ClipMachine * cm)
{
	const char* __PROC__ = "DBSETFILTER";
	DBWorkArea *wa = cur_area(cm);
	ClipVar* block = _clip_spar(cm,1);
	const char* str = _clip_parc(cm,2);
	RDD_FILTER* fp;
	int er;

	CHECKWA(wa);

	CHECKARG2(1,CCODE_t,PCODE_t);
	CHECKOPT1(2,CHARACTER_t);

	if((er = rdd_clearfilter(cm,wa->rd,__PROC__))) goto err;

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_createfilter(cm,wa->rd,&fp,block,str,NULL,__PROC__)))
		goto err_unlock;
	fp->active = 1;
	wa->rd->filter = fp;
	if((er = _rdd_calcfiltlist(cm,wa->rd,__PROC__)))
		goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBFILTER(ClipMachine * cm)
{
	DBWorkArea* wa = cur_area(cm);

	if(!wa) return 0;

	_clip_retc(cm,"");
	if(wa->rd->filter && wa->rd->filter->sfilter)
		_clip_retc(cm,wa->rd->filter->sfilter);
	return 0;
}

int
clip_ISFILTERED(ClipMachine* cm)
{
	DBWorkArea* wa = cur_area(cm);

	_clip_retl(cm,0);
	if(!wa) return 0;

	_clip_retl(cm,wa->rd->filter!=NULL);
	return 0;
}

int
clip_DBRELATION(ClipMachine* cm)
{
	const char* __PROC__ = "DBRELATION";
	DBWorkArea* wa = cur_area(cm);
	int rel = _clip_parni(cm,1);
	int er;

	_clip_retc(cm,"");
	if(!wa) return 0;

	CHECKARG1(1,NUMERIC_t);

	if(!(rel < 1 || rel > wa->rd->rels_opened))
		_clip_retc(cm,wa->rd->relations[rel-1]->expr);
	return 0;
err:
	return er;
}

int
clip_FOUND(ClipMachine * cm)
{
	DBWorkArea *wa = cur_area(cm);

	_clip_retl(cm, 0);
	if (!wa)
		return 0;

	_clip_retl(cm, wa->found ? 1 : 0);
	return 0;
}

int
clip_DBCLEARRELATION(ClipMachine * cm)
{
	const char* __PROC__ = "DBCLEARRELATION";
	DBWorkArea* wa = cur_area(cm);

	if(!wa) return 0;
	return rdd_clearrelation(cm,wa->rd,__PROC__);
}

int clip_DBCLEARREL(ClipMachine* cm)
{
	return clip_DBCLEARRELATION(cm);
}

int
clip_DBSETRELATION(ClipMachine * cm)
{
	const char* __PROC__ = "DBSETRELATION";
	int type = _clip_parinfo(cm,1);
	ClipVar* block = _clip_spar(cm,2);
	const char* expr = _clip_parc(cm,3);
	DBWorkArea* wa = cur_area(cm);
	DBWorkArea* childwa;
	int er;

	CHECKWA(wa);
	CHECKARG2(1,NUMERIC_t,CHARACTER_t);
	CHECKARG2(2,CCODE_t,PCODE_t);
	CHECKOPT1(3,CHARACTER_t);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if(type==NUMERIC_t){
		childwa = get_area(cm,_clip_parni(cm,1),0,0);
	} else {
		int i;
		DBWorkArea* twa;
		const char* alias = _clip_parc(cm,1);
		for (i = 0; i < cm->areas->count; i++)
		{
			twa = (DBWorkArea *) cm->areas->items[i];
			if (twa && twa->alias && !strcasecmp(alias, twa->alias))
				break;
		}
		childwa = get_area(cm,i+1,0,0);
	}

	CHECKWA(childwa);

	if((er = rdd_setrelation(cm,wa->rd,childwa->rd,block,expr,0,__PROC__)))
		goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_RLOCK(ClipMachine * cm)
{
	const char* __PROC__ = "RLOCK";
	DBWorkArea* wa = cur_area(cm);
	int r,er;

	if(!wa) return 0;

	if((er = rdd_ulock(cm,wa->rd,0,0,__PROC__))) return er;
	if((er = rdd_rlock(cm,wa->rd,wa->rd->recno,&r,__PROC__))) return er;
	_clip_retl(cm,r);
	return 0;
}

int
clip_DBRLOCK(ClipMachine* cm)
{
	const char* __PROC__ = "DBRLOCK";
	DBWorkArea* wa = cur_area(cm);
	int rno = _clip_parni(cm,1);
	int r,er;

	_clip_retl(cm,0);
	if(!wa) return 0;

	CHECKOPT1(1,NUMERIC_t);

	if(_clip_parinfo(cm,1)==UNDEF_t)
		return clip_RLOCK(cm);
	if((er = rdd_rlock(cm,wa->rd,rno,&r,__PROC__))) goto err;
	_clip_retl(cm,r);
	return 0;
err:
	return er;
}

int
clip_DBRUNLOCK(ClipMachine* cm)
{
	const char* __PROC__ = "DBRUNLOCK";
	DBWorkArea* wa = cur_area(cm);
	unsigned int rec = _clip_parni(cm,1);
	int er;

	if(!wa) return 0;
	CHECKOPT1(1,NUMERIC_t);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	if((er = rdd_ulock(cm,wa->rd,rec,0,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_DBUNLOCK(ClipMachine * cm)
{
	const char* __PROC__ = "DBUNLOCK";
	DBWorkArea* wa = cur_area(cm);
	int er;

	CHECKWA(wa);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) return er;
	return rdd_ulock(cm,wa->rd,0,1,__PROC__);
}

int
clip_DBUNLOCKALL(ClipMachine * cm)
{
	const char* __PROC__ = "DBUNLOCKALL";
	DBWorkArea* wa;
	int i,er;

	for(i=0;i<cm->areas->count;i++){
		wa = get_area(cm,i+1,0,0);
		if(!wa)
			continue;
		if((er = _clip_flushbuffer(cm, wa, __PROC__))) return er;
		if((er = rdd_ulock(cm,wa->rd,0,1,__PROC__))) return er;
	}
	return 0;
}

int
clip_FLOCK(ClipMachine * cm)
{
	const char* __PROC__ = "FLOCK";
	DBWorkArea* wa = cur_area(cm);

	if(!wa) return 0;

	return rdd_flock(cm,wa->rd,__PROC__);
}

int
clip_NETERR(ClipMachine * cm)
{
	const char* __PROC__ = "NETERR";
	int *err,r;
	int neterr = _clip_parl(cm,1);
	int er;

	CHECKOPT1(1,LOGICAL_t);
	err = _clip_fetch_item(cm, HASH_neterror);
	r = *err;

	if(_clip_parinfo(cm,1)!=UNDEF_t)
		*err = neterr;

	_clip_retl(cm, r);
	return 0;
err:
	return er;
}

int clip_DBCOMMIT(ClipMachine* cm)
{
	const char* __PROC__ = "DBCOMMIT";
	DBWorkArea* wa = cur_area(cm);
	int er;

	CHECKWA(wa);

	WRITELOCK;
	if((er = rdd_commit(cm,wa->rd,__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBCOMMITALL(ClipMachine * cm)
{
	const char* __PROC__ = "DBCOMMITALL";
	DBWorkArea* wa;
	int i,er;

	for(i=0;i<cm->areas->count;i++){
		wa = (DBWorkArea *) cm->areas->items[i];
		if(!wa || !wa->used || wa->rd->readonly)
			continue;
		WRITELOCK;
		if((er = rdd_commit(cm,wa->rd,__PROC__))) goto err_unlock;
		UNLOCK;
	}
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBRLOCKLIST(ClipMachine* cm)
{
#ifndef CLIPPER50_COMPATIBLE
	const char* __PROC__ = "DBRLOCKLIST";
#endif
	DBWorkArea* wa = cur_area(cm);
	ClipVar* rp = RETPTR(cm);
	long vect[1];
	int i;

	CHECKWA(wa);

	vect[0] = wa->rd->nlocks;
	_clip_array(cm,rp,1,vect);

	for(i=0;i<wa->rd->nlocks;i++){
		ClipVar var;
		var.t.flags = F_NONE;
		var.t.type = NUMERIC_t;
		var.t.memo = 0;
		var.n.d = wa->rd->locks[i];
		var.t.dec = 0;
		var.t.len = 7;
		vect[0] = i;
		_clip_aset(cm, rp, &var, 1, vect);
	}
	return 0;
}

int
clip_DBINFO(ClipMachine* cm)
{
	const char* __PROC__ = "DBINFO";
	DBWorkArea* wa = cur_area(cm);
	int cmd = _clip_parni(cm,1);
	int er;

	CHECKWA(wa);
	CHECKARG1(1,NUMERIC_t);

	switch(cmd){
		case DBI_ALIAS:
		{
			_clip_retc(cm,wa->alias);
			break;
		}
		case DBI_GETDELIMITER:
		case DBI_SETDELIMITER:
		case DBI_ISDBF:
		case DBI_VALIDBUFFER:
		case DBI_LOCKOFFSET:
		{
			if((er = wa->rd->vtbl->info(cm,wa->rd,cmd,__PROC__))) goto err;
			break;
		}
		case DBI_BLOB_DIRECT_LEN:
		case DBI_BLOB_DIRECT_TYPE:
		case DBI_BLOB_INTEGRITY:
		case DBI_BLOB_OFFSET:
		case DBI_BLOB_RECOVER:
		case DBI_MEMOBLOCKSIZE:
		{
			if(wa->rd->memo)
				if((er = wa->rd->memo->vtbl->info(cm,wa->rd,wa->rd->memo,cmd,
					__PROC__))) goto err;
			break;
		}
		case DBI_BOF:
		{
			int bof;
			if((er = rdd_bof(cm,wa->rd,&bof,__PROC__))) goto err;
			_clip_retl(cm,bof);
			break;
		}
		case DBI_CANPUTREC:
		{
			_clip_retl(cm,!wa->rd->readonly);
			break;
		}
		case DBI_CHILDCOUNT:
		{
			_clip_retni(cm,wa->rd->rels_opened);
			break;
		}
		case DBI_DB_VERSION:
		case DBI_RDD_VERSION:
		{
			char ver[101];
			int opt = _clip_parni(cm,2);
			if(_clip_parinfo(cm,2)==NUMERIC_t && opt==1){
				sprintf(ver,"%d.%d (%s)",HIWORD(wa->rd->vtbl->version),
					LOWORD(wa->rd->vtbl->version),wa->rd->vtbl->desc);
			} else {
				sprintf(ver,"%d.%d",HIWORD(wa->rd->vtbl->version),
					LOWORD(wa->rd->vtbl->version));
			}
			_clip_retc(cm,ver);
			break;
		}
		case DBI_DBFILTER:
		{
			_clip_retc(cm,"");
			if(wa->rd->filter && wa->rd->filter->sfilter)
				_clip_retc(cm,wa->rd->filter->sfilter);
			break;
		}
		case DBI_EOF:
		{
			int eof;
			if((er = rdd_eof(cm,wa->rd,&eof,__PROC__))) goto err;
			_clip_retl(cm,eof);
			break;
		}
		case DBI_FCOUNT:
		{
			_clip_retni(cm,wa->rd->nfields);
			break;
		}
		case DBI_FILEHANDLE:
		{
			_clip_retni(cm,-1);
			break;
		}
		case DBI_FOUND:
		{
			_clip_retl(cm,wa->found);
			break;
		}
		case DBI_FULLPATH:
		{
			_clip_retc(cm,wa->rd->path);
			break;
		}
		case DBI_GETHEADERSIZE:
		{
			_clip_retni(cm,wa->rd->hdrsize);
			break;
		}
		case DBI_GETLOCKARRAY:
		{
			return clip_DBRLOCKLIST(cm);
		}
		case DBI_GETRECSIZE:
		{
			_clip_retni(cm,wa->rd->recsize);
			break;
		}
		case DBI_ISFLOCK:
		{
			_clip_retl(cm,wa->rd->flocked);
			break;
		}
		case DBI_LASTUPDATE:
		{
			return clip_LUPDATE(cm);
		}
		case DBI_LOCKCOUNT:
		{
			_clip_retni(cm,wa->rd->nlocks);
			break;
		}
		case DBI_MEMOEXT:
		{
			return clip_MEMOEXT(cm);
		}
		case DBI_MEMOHANDLE:
		{
			_clip_retni(cm,-1);
			break;
		}
		case DBI_SHARED:
		{
			_clip_retl(cm,wa->rd->shared);
			break;
		}
		case DBI_TABLEEXT:
		{
			return clip_TABLEEXT(cm);
		}
	}
	return 0;
err:
	return er;
}

int
clip_DBFIELDINFO(ClipMachine* cm)
{
	const char* __PROC__ = "DBFIELDINFO";
	DBWorkArea* wa = cur_area(cm);
	int cmd = _clip_parni(cm,1);
	int fno = _clip_parni(cm,2)-1;
	int er;

	CHECKWA(wa);
	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,NUMERIC_t);

	switch(cmd){
		case DBS_BLOB_LEN:
		case DBS_BLOB_OFFSET:
		case DBS_BLOB_POINTER:
		case DBS_BLOB_TYPE:
		{
/*			if(wa->rd->memo && wa->rd->fields[fno].type=='M')
				if(wa->rd->memo->vtbl->fieldinfo(cm,wa->rd,wa->rd->memo,cmd,
					__PROC__)) return 1;*/
			break;
		}
		case DBS_DEC:
		{
			_clip_retni(cm,wa->rd->fields[fno].dec);
			break;
		}
		case DBS_LEN:
		{
			_clip_retni(cm,wa->rd->fields[fno].len);
			break;
		}
		case DBS_NAME:
		{
			_clip_retc(cm,wa->rd->fields[fno].name);
			break;
		}
		case DBS_TYPE:
		{
			char t[2];
			t[0] = wa->rd->fields[fno].type;
			t[1] = 0;
			_clip_retc(cm,t);
			break;
		}
	}
	return 0;
err:
	return er;
}

int
clip_DBRECORDINFO(ClipMachine* cm)
{
	const char* __PROC__ = "DBRECORDINFO";
	DBWorkArea* wa = cur_area(cm);
	int cmd = _clip_parni(cm,1);
	unsigned int rec = _clip_parni(cm,2);
	int oldrecno,er;

	CHECKWA(wa);
	CHECKARG1(1,NUMERIC_t);
	CHECKOPT1(2,NUMERIC_t);

	oldrecno = wa->rd->recno;

	if(rec)
		wa->rd->recno = rec;

	switch(cmd){
		case DBRI_DELETED:
		{
			int d;
			if((er = rdd_deleted(cm,wa->rd,&d,__PROC__))) goto err;
			_clip_retl(cm,d);
			break;
		}
		case DBRI_LOCKED:
		{
			int r=0,i;

			for(i=0;i<wa->rd->nlocks;i++){
				if(wa->rd->locks[i]==wa->rd->recno){
					r = 1;
					break;;
				}
			}
			_clip_retl(cm,r);
			break;
		}
		case DBRI_RECSIZE:
		{
			_clip_retni(cm,wa->rd->recsize);
			break;
		}
		case DBRI_RECNO:
		{
			_clip_retni(cm,wa->rd->recno);
			break;
		}
		case DBRI_UPDATED:
		{
			_clip_retl(cm,0);
			break;
		}
	}
	wa->rd->recno = oldrecno;
	return 0;
err:
	return er;
}

int get_orderno(DBWorkArea* wa,ClipVar* order,ClipVar* index){
	int ord = -1;
	int indno = 0;

	if((!order || (order->t.type == UNDEF_t)) && (!index || (index->t.type == UNDEF_t)))
		return wa->rd->curord;
	if(index && (index->t.type==CHARACTER_t || index->t.type == NUMERIC_t)){
		if(index->t.type == NUMERIC_t){
			indno = index->n.d - 1;
		} else {
			char* i = strdup(index->s.str.buf);
			char* e = i+strlen(i);
			int l;

			while(*(--e)==' ');
			*(e+1) = 0;
			l = e-i+1;
			for(indno=0;indno<wa->rd->idxs_opened;indno++){
				if(strcasecmp(wa->rd->indices[indno]->name,i)==0)
					break;
			}
		}
		if(indno<wa->rd->idxs_opened && indno >=0){
			RDD_INDEX* ri = wa->rd->indices[indno];
			if(order && order->t.type==NUMERIC_t){
				if(order->n.d>=1 && order->n.d<=ri->norders)
					ord = ri->orders[(int)order->n.d-1]->orderno;
			} else if(order && order->t.type==CHARACTER_t){
				int ordno;
				char* o = strdup(order->s.str.buf);
				char* e = o+strlen(o);
				int l;

				while(*(--e)==' ');
				*(e+1) = 0;
				l = e-o+1;
				for(ordno=0;ordno<ri->norders;ordno++){
					if(strcasecmp(ri->orders[ordno]->name,o)==0){
						ord = ri->orders[ordno]->orderno;
						break;
					}
				}
			} else {
				ord = ri->orders[0]->orderno;
			}
		}
	} else if(order){
		if(order->t.type==NUMERIC_t){
			if(order->n.d>=1 && order->n.d<=wa->rd->ords_opened)
				ord = order->n.d-1;
		} else {
			int ordno;
			char* o = strdup(order->s.str.buf);
			char* e = o+strlen(o);
			int l;

			while(*(--e)==' ');
			*(e+1) = 0;
			l = e-o+1;
			for(ordno=0;ordno<wa->rd->ords_opened;ordno++){
				if(strcasecmp(wa->rd->orders[ordno]->name,o)==0){
					ord = ordno;
					break;
				}
			}
		}
	}
	return ord;
}

int
clip_DBORDERINFO(ClipMachine* cm)
{
	const char* __PROC__ = "DBORDERINFO";
	DBWorkArea* wa = cur_area(cm);
	int cmd = _clip_parni(cm,1);
	ClipVar* index = _clip_par(cm,2);
	ClipVar* order = _clip_par(cm,3);
	RDD_ORDER* ro;
	int ord,er;

	CHECKWA(wa);
	CHECKARG1(1,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);
	CHECKOPT2(3,NUMERIC_t,CHARACTER_t);

	ord = get_orderno(wa,order,index);
	if(ord==-1)
		ord = wa->rd->curord;
	if(ord==-1)
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);

	ro = wa->rd->orders[ord];
	switch(cmd){
		case DBOI_CONDITION:
		case DBOI_CUSTOM:
		case DBOI_HPLOCKING:
		case DBOI_ISCOND:
		case DBOI_ISDESC:
		case DBOI_KEYADD:
		case DBOI_KEYDELETE:
		case DBOI_KEYGOTO:
		case DBOI_LOCKOFFSET:
		case DBOI_ORDERCOUNT:
		case DBOI_SCOPEBOTTOM:
		case DBOI_SCOPEBOTTOMCLEAR:
		case DBOI_SCOPETOP:
		case DBOI_SCOPETOPCLEAR:
		case DBOI_SKIPUNIQUE:
		{
			if((er = wa->rd->orders[ord]->vtbl->info(cm,wa->rd,ro,cmd,__PROC__)))
				goto err;
			break;
		}
		case DBOI_EXPRESSION:
		{
			_clip_retc(cm,ro->expr);
			break;
		}
		case DBOI_FILEHANDLE:
		{
			_clip_retni(cm,-1);
			break;
		}
		case DBOI_INDEXEXT:
		{
			_clip_retc(cm,ro->vtbl->suff);
			break;
		}
		case DBOI_INDEXNAME:
		{
			_clip_retc(cm,ro->index->name);
			break;
		}
		case DBOI_KEYCOUNT:
		case DBOI_KEYSINCLUDED:
		{
			int c;
			if((er = ro->vtbl->lastkey(cm,wa->rd,ro,&c,__PROC__))) goto err;
			_clip_retni(cm,c);
			break;
		}
		case DBOI_KEYDEC:
		{
			_clip_retni(cm,ro->dec);
			break;
		}
		case DBOI_KEYSIZE:
		{
			_clip_retni(cm,ro->keysize);
			break;
		}
		case DBOI_KEYTYPE:
		{
			ClipVar vv;
			char t[2];
			if((er = _clip_eval(cm,&ro->block,0,0,&vv))) goto err;
			if(vv.t.type==CHARACTER_t)
				t[0] = 'C';
			else if(vv.t.type==NUMERIC_t)
				t[0] = 'N';
			else if(vv.t.type==DATE_t)
				t[0] = 'D';
			else if(vv.t.type==LOGICAL_t)
				t[0] = 'L';
			else
				t[0] = 'U';
			t[1] = 0;
			_clip_destroy(cm,&vv);
			_clip_retc(cm,t);
			break;
		}
		case DBOI_KEYVAL:
		{
			if((er = _clip_eval(cm,&ro->block,0,0,RETPTR(cm)))) goto err;
			break;
		}
		case DBOI_NAME:
		{
			_clip_retc(cm,ro->name);
			break;
		}
		case DBOI_NUMBER:
		{
			_clip_retni(cm,ord+1);
			break;
		}
		case DBOI_RECNO:
		{
			int n;
			if((er = ro->vtbl->keyno(cm,wa->rd,ro,&n,__PROC__))) goto err;
			_clip_retni(cm,n);
			break;
		}
		case DBOI_SETCODEBLOCK:
		{
			_clip_clone(cm,RETPTR(cm),&ro->block);
			break;
		}
		case DBOI_UNIQUE:
		{
			_clip_retl(cm,ro->unique);
			break;
		}
	}
	return 0;
err:
	return er;
}

int
clip_ORDSCOPE(ClipMachine* cm)
{
	const char* __PROC__ = "ORDSCOPE";
	DBWorkArea* wa = cur_area(cm);
	int scope = _clip_parni(cm,1);
	ClipVar* v = _clip_par(cm,2);
	int er;

	CHECKWA(wa);
	CHECKARG1(1,NUMERIC_t);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if(scope==0){
		if((er = rdd_scopetop(cm,wa->rd,v,__PROC__))) goto err_unlock;
	} else if(scope==1){
		if((er = rdd_scopebottom(cm,wa->rd,v,__PROC__))) goto err_unlock;
	} else {
		er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,
			"Bad argument (1)");
		goto err_unlock;
	}
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ORDSETFOCUS(ClipMachine* cm)
{
	const char* __PROC__ = "ORDSETFOCUS";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int ord,er;

	_clip_retc(cm,"");
	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	if(wa->rd->curord!=-1)
		_clip_retc(cm,wa->rd->orders[wa->rd->curord]->name);

	ord = get_orderno(wa,order,index);
	if(ord < -1 || ord>=wa->rd->ords_opened || _clip_parinfo(cm,0)==0)
		return 0;

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if ((er = rdd_setorder(cm, wa->rd, ord+1, __PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ORDBAGNAME(ClipMachine* cm)
{
	const char* __PROC__ = "ORDBAGNAME";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	int ord,er;

	_clip_retc(cm,"");
	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);

	ord = get_orderno(wa,order,NULL);
	if((ord==-1) && _clip_parinfo(cm,1)!=NUMERIC_t)
		ord = wa->rd->curord;
	if(ord==-1)
		return 0;

	_clip_retc(cm,wa->rd->orders[ord]->index->name);
	return 0;
err:
	return er;
}

int
clip_ORDCONDSET(ClipMachine* cm)
{
	const char* __PROC__ = "ORDCONDSET";
	DBWorkArea* wa = cur_area(cm);
	const char* cForCondition	= _clip_parc(cm,1);
	ClipVar* bForCondition		= _clip_spar(cm,2);
	int lAll					= _clip_parl(cm,3);
	ClipVar* bWhileCondition	= _clip_spar(cm,4);
	ClipVar* bEval				= _clip_spar(cm,5);
	int nInterval				= _clip_parni(cm,6);
	int nStart					= _clip_parni(cm,7);
	int nNext					= _clip_parni(cm,8);
	int nRecord					= _clip_parni(cm,9);
	int lRest					= _clip_parl(cm,10);
	int lDescend				= _clip_parl(cm,11);
	int lAdditive				= _clip_parl(cm,12);
	int lCurrent				= _clip_parl(cm,13);
	int lCustom					= _clip_parl(cm,14);
	int lNoOptimize				= _clip_parl(cm,15);
	int er;

	if(!wa) return 0;

	CHECKOPT1(1,CHARACTER_t);
	CHECKOPT2(2,CCODE_t,PCODE_t);
	CHECKOPT1(3,LOGICAL_t);
	CHECKOPT2(4,CCODE_t,PCODE_t);
	CHECKOPT2(5,CCODE_t,PCODE_t);
	CHECKOPT1(6,NUMERIC_t);
	CHECKOPT1(7,NUMERIC_t);
	CHECKOPT1(8,NUMERIC_t);
	CHECKOPT1(9,NUMERIC_t);
	CHECKOPT1(10,LOGICAL_t);
	CHECKOPT1(11,LOGICAL_t);
	CHECKOPT1(12,LOGICAL_t);
	CHECKOPT1(13,LOGICAL_t);
	CHECKOPT1(14,LOGICAL_t);
	CHECKOPT1(15,LOGICAL_t);

	if(wa->rd->os.cForCondition){
		free(wa->rd->os.cForCondition);
		wa->rd->os.cForCondition = NULL;
	}
	_clip_destroy(cm,&wa->rd->os.bForCondition);
	_clip_destroy(cm,&wa->rd->os.bWhileCondition);
	_clip_destroy(cm,&wa->rd->os.bEval);

	if(cForCondition){
		wa->rd->os.cForCondition = malloc(strlen(cForCondition)+1);
		strcpy(wa->rd->os.cForCondition,cForCondition);
	}

	if(bForCondition)
		_clip_clone(cm,&wa->rd->os.bForCondition,bForCondition);
	wa->rd->os.lAll = lAll;
	if(bWhileCondition)
		_clip_clone(cm,&wa->rd->os.bWhileCondition,bWhileCondition);
	if(bEval)
		_clip_clone(cm,&wa->rd->os.bEval,bEval);
	wa->rd->os.nInterval = nInterval;
	wa->rd->os.nStart = (lAll?0:nStart);
	wa->rd->os.nNext = nNext;
	wa->rd->os.nRecord = nRecord;
	wa->rd->os.lRest = lRest;
	wa->rd->os.lDescend = lDescend;
	wa->rd->os.lAdditive = lAdditive;
	wa->rd->os.lCurrent = lCurrent;
	wa->rd->os.lCustom = lCustom;
	wa->rd->os.lNoOptimize = lNoOptimize;

	_clip_retl(cm,1);
	return 0;
err:
	return er;
}

int
clip_SIXCONDSET(ClipMachine* cm)
{
	const char* __PROC__ = "ORDCONDSET";
	DBWorkArea* wa = cur_area(cm);
	const char* cForCondition	= _clip_parc(cm,1);
	ClipVar* bForCondition		= _clip_spar(cm,2);
	int lAll					= _clip_parl(cm,3);
	ClipVar* bWhileCondition	= _clip_spar(cm,4);
	ClipVar* bEval				= _clip_spar(cm,5);
	int nInterval				= _clip_parni(cm,6);
	int nStart					= _clip_parni(cm,7);
	int nNext					= _clip_parni(cm,8);
	int nRecord					= _clip_parni(cm,9);
	int lRest					= _clip_parl(cm,10);
	int lDescend				= _clip_parl(cm,11);
	int lAdditive				= _clip_parl(cm,13);
	int lCurrent				= _clip_parl(cm,14);
	int lCustom					= _clip_parl(cm,15);
	int lNoOptimize				= _clip_parl(cm,16);
	int er;

	if(!wa) return 0;

	CHECKOPT1(1,CHARACTER_t);
	CHECKOPT2(2,CCODE_t,PCODE_t);
	CHECKOPT1(3,LOGICAL_t);
	CHECKOPT2(4,CCODE_t,PCODE_t);
	CHECKOPT2(5,CCODE_t,PCODE_t);
	CHECKOPT1(6,NUMERIC_t);
	CHECKOPT1(7,NUMERIC_t);
	CHECKOPT1(8,NUMERIC_t);
	CHECKOPT1(9,NUMERIC_t);
	CHECKOPT1(10,LOGICAL_t);
	CHECKOPT1(11,LOGICAL_t);
	CHECKOPT1(13,LOGICAL_t);
	CHECKOPT1(14,LOGICAL_t);
	CHECKOPT1(15,LOGICAL_t);
	CHECKOPT1(16,LOGICAL_t);

	if(wa->rd->os.cForCondition){
		free(wa->rd->os.cForCondition);
		wa->rd->os.cForCondition = NULL;
	}
	_clip_destroy(cm,&wa->rd->os.bForCondition);
	_clip_destroy(cm,&wa->rd->os.bWhileCondition);
	_clip_destroy(cm,&wa->rd->os.bEval);

	if(cForCondition){
		wa->rd->os.cForCondition = malloc(strlen(cForCondition)+1);
		strcpy(wa->rd->os.cForCondition,cForCondition);
	}

	if(bForCondition)
		_clip_clone(cm,&wa->rd->os.bForCondition,bForCondition);
	wa->rd->os.lAll = lAll;
	if(bWhileCondition)
		_clip_clone(cm,&wa->rd->os.bWhileCondition,bWhileCondition);
	if(bEval)
		_clip_clone(cm,&wa->rd->os.bEval,bEval);
	wa->rd->os.nInterval = nInterval;
	wa->rd->os.nStart = (lAll?0:nStart);
	wa->rd->os.nNext = nNext;
	wa->rd->os.nRecord = nRecord;
	wa->rd->os.lRest = lRest;
	wa->rd->os.lDescend = lDescend;
	wa->rd->os.lAdditive = lAdditive;
	wa->rd->os.lCurrent = lCurrent;
	wa->rd->os.lCustom = lCustom;
	wa->rd->os.lNoOptimize = lNoOptimize;

	_clip_retl(cm,1);
	return 0;
err:
	return er;
}

int
clip_FIELDDECI(ClipMachine* cm)
{
	const char* __PROC__ = "FIELDDECI";
	DBWorkArea* wa = cur_area(cm);
	int fno = _clip_parni(cm,1)-1;
	int dec = 0,er;

	CHECKARG1(1,NUMERIC_t);

	if(wa){
		if(fno >= 0 && fno < wa->rd->nfields)
			dec = wa->rd->fields[fno].dec;
	}
	_clip_retni(cm,dec);
	return 0;
err:
	return er;
}

int
clip_FIELDNUM(ClipMachine* cm)
{
	return clip_FIELDPOS(cm);
}

int
clip_FIELDSIZE(ClipMachine* cm)
{
	const char* __PROC__ = "FIELDSIZE";
	DBWorkArea* wa = cur_area(cm);
	int fno = _clip_parni(cm,1)-1;
	int len = 0,er;

	CHECKARG1(1,NUMERIC_t);

	if(wa){
		if(fno >= 0 && fno < wa->rd->nfields)
			len = wa->rd->fields[fno].len;
	}
	_clip_retni(cm,len);
	return 0;
err:
	return er;
}

int
clip_FIELDTYPE(ClipMachine* cm)
{
	const char* __PROC__ = "FIELDTYPE";
	DBWorkArea* wa = cur_area(cm);
	int fno = _clip_parni(cm,1)-1;
	char type[2] = " ";
	int er;

	CHECKARG1(1,NUMERIC_t);

	if(wa){
		if(fno >= 0 && fno < wa->rd->nfields)
			type[0] = wa->rd->fields[fno].type;
	}

	_clip_retc(cm,type);
	return 0;
err:
	return er;
}

int
clip_FIELDBLANK(ClipMachine* cm)
{
	const char* __PROC__ = "FIELDBLANK";
	DBWorkArea* wa = cur_area(cm);
	int fno = _clip_parni(cm,1)-1;
	ClipVar* r = RETPTR(cm);
	int er;

	_clip_retc(cm,"");
	CHECKWA(wa);
	CHECKARG1(1,NUMERIC_t);

	if(fno<0 || fno>=wa->rd->nfields)
		return rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,er_nofield);

	if(wa->rd->fields[fno].type=='M')
		return 0;

	if(!wa->rd->valid){
		READLOCK;
		if((er = rdd_takevalue(cm,wa->rd,fno,r,__PROC__))) goto err_unlock;
		UNLOCK;
	} else {
		if((er = rdd_takevalue(cm,wa->rd,fno,r,__PROC__))) goto err;
	}
	if(r->t.type==CHARACTER_t){
		memset(r->s.str.buf,' ',r->s.str.len);
	} else if(r->t.type==NUMERIC_t){
		r->n.d = 0;
	} else if(r->t.type==DATE_t){
		r->d.julian = 0;
	} else if(r->t.type==LOGICAL_t){
		r->l.val = 0;
	}
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ORDKEYADD(ClipMachine* cm)
{
	const char* __PROC__ = "ORDKEYADD";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	ClipVar* v = _clip_par(cm,3);
	int ord,er;

	_clip_retl(cm,0);
	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	ord = get_orderno(wa,order,index);
	if(ord==-1)
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_keyadd(cm,wa->rd,wa->rd->orders[ord],v,__PROC__)))
		goto err_unlock;
	UNLOCK;
	_clip_retl(cm,1);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ORDKEYDEL(ClipMachine* cm)
{
	const char* __PROC__ = "ORDKEYDEL";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int ord,er;

	_clip_retl(cm,0);
	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	ord = get_orderno(wa,order,index);
	if(ord==-1)
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_keydel(cm,wa->rd,wa->rd->orders[ord],__PROC__)))
		goto err_unlock;
	UNLOCK;
	_clip_retl(cm,1);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ORDDESCEND(ClipMachine* cm)
{
	const char* __PROC__ = "ORDDESCEND";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int descend = _clip_parl(cm,3);
	int res,ord,er;

	_clip_retl(cm,0);
	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);
	CHECKOPT1(3,LOGICAL_t);

	ord = get_orderno(wa,order,index);
	if(ord==-1)
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);

	if(_clip_parinfo(cm,3) == UNDEF_t)
		descend = -1;
	if((er = wa->rd->orders[ord]->vtbl->descend(cm,wa->rd->orders[ord],descend,&res,
		__PROC__))) goto err;
	_clip_retl(cm,res);
	return 0;
err:
	return er;
}

int
clip_ORDDESTROY(ClipMachine* cm)
{
	const char* __PROC__ = "ORDDESTROY";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int ord,er;

	if(!wa) return 0;

	CHECKARG1(1,CHARACTER_t);
	CHECKOPT1(2,CHARACTER_t);

	ord = get_orderno(wa,order,index);
	if(ord==-1)
		return 0;

	if((er = rdd_orddestroy(cm,wa->rd,wa->rd->orders[ord],__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_ORDFOR(ClipMachine* cm)
{
	const char* __PROC__ = "ORDFOR";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int ord,er;

	_clip_retc(cm,"");
	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	ord = get_orderno(wa,order,index);
	if(ord==-1)
		ord = wa->rd->curord;
	if(ord==-1)
		return 0;

	_clip_retc(cm,wa->rd->orders[ord]->cforexpr);
	return 0;
err:
	return er;
}

int
clip_ORDISUNIQUE(ClipMachine* cm)
{
	const char* __PROC__ = "ORDISUNIQUE";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int ord,er;

	_clip_retl(cm,0);
	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	ord = get_orderno(wa,order,index);
	if(ord==-1)
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);

	_clip_retl(cm,wa->rd->orders[ord]->unique);
	return 0;
err:
	return er;
}

int
clip_ORDKEY(ClipMachine* cm)
{
	const char* __PROC__ = "ORDKEY";
	DBWorkArea* wa = cur_area(cm);
	int ord = _clip_parni(cm,1);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int er;

	_clip_retc(cm,"");
	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	if(_clip_parinfo(cm,1)==NUMERIC_t && !ord)
		ord = wa->rd->curord;
	else
		ord = get_orderno(wa,order,index);

	if(!(ord<0 || ord>=wa->rd->ords_opened))
		_clip_retc(cm,wa->rd->orders[ord]->expr);
	return 0;
err:
	return er;
}

int
clip_ORDKEYCOUNT(ClipMachine* cm)
{
	const char* __PROC__ = "ORDKEYCOUNT";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int ord = _clip_parni(cm,1);
	int r,er;

	_clip_retni(cm,0);
	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	if(_clip_parinfo(cm,1)==NUMERIC_t && !ord)
		ord = wa->rd->curord;
	else
		ord = get_orderno(wa,order,index);
	if(ord==-1)
		return clip_LASTREC(cm);
/*		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);*/

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_checkifnew(cm,wa->rd,__PROC__))) goto err_unlock;
	if((er = wa->rd->orders[ord]->vtbl->lastkey(cm,wa->rd,wa->rd->orders[ord],&r,__PROC__)))
		goto err_unlock;
	UNLOCK;

	_clip_retni(cm,r);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ORDKEYGOTO(ClipMachine* cm)
{
	const char* __PROC__ = "ORDKEYGOTO";
	DBWorkArea* wa = cur_area(cm);
	unsigned int nkey = _clip_parni(cm,1);
	int ok,er;

	_clip_retl(cm,0);
	if(!wa) return 0;

	CHECKARG1(1,NUMERIC_t);

	if(wa->rd->curord == -1)
		return 0;

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_gotokey(cm,wa->rd,wa->rd->orders[wa->rd->curord],nkey,&ok,__PROC__)))
		goto err_unlock;
	UNLOCK;
	_clip_retl(cm,ok);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ORDKEYNO(ClipMachine* cm)
{
	const char* __PROC__ = "ORDKEYNO";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int ord = _clip_parni(cm,1);
	int r,er;

	_clip_retni(cm,0);
	CHECKWA(wa);
	CHECKOPT2(1,CHARACTER_t,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	if(_clip_parinfo(cm,1)==NUMERIC_t && !ord)
		ord = wa->rd->curord;
	else
		ord = get_orderno(wa,order,index);
	if(ord==-1){
		_clip_retni(cm,wa->rd->recno);
		return 0;
	}

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_checkifnew(cm,wa->rd,__PROC__))) goto err_unlock;
	if((er = wa->rd->orders[ord]->vtbl->keyno(cm,wa->rd,wa->rd->orders[ord],&r,__PROC__)))
		goto err_unlock;
	UNLOCK;

	_clip_retni(cm,r);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ORDKEYVAL(ClipMachine* cm)
{
	const char* __PROC__ = "ORDKEYVAL";
	DBWorkArea* wa = cur_area(cm);
	int er;

	CHECKWA(wa);

	READLOCK;
	if((er = rdd_keyvalue(cm,wa->rd,RETPTR(cm),__PROC__))) goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ORDLISTADD(ClipMachine* cm)
{
	const char* __PROC__ = "ORDLISTADD";
	DBWorkArea* wa = cur_area(cm);
	const char* bag = _clip_parc(cm,1);
	const char* ord = _clip_parc(cm,2);
	int er;

	CHECKWA(wa);
	CHECKARG1(1,CHARACTER_t);
	CHECKOPT1(2,CHARACTER_t);

	return rdd_setindex(cm,wa->rd,NULL,wa->idx_driver,bag,ord,__PROC__);
err:
	return er;
}

int
clip_ORDLISTCLEAR(ClipMachine* cm)
{
	const char *__PROC__ = "ORDLISTCLEAR";
	DBWorkArea *wa = cur_area(cm);

	CHECKWA(wa);
	return rdd_clearindex(cm, wa->rd, __PROC__);
}

int
clip_ORDLISTREBUILD(ClipMachine * cm)
{
	const char *__PROC__ = "ORDLISTREBUILD";
	DBWorkArea *wa = cur_area(cm);

	CHECKWA(wa);
	return rdd_reindex(cm, wa->rd, __PROC__);
}

int
clip_ORDNAME(ClipMachine* cm)
{
	const char* __PROC__ = "ORDNAME";
	DBWorkArea* wa = cur_area(cm);
	int ord = _clip_parni(cm,1);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int er;

	_clip_retc(cm,"");
	CHECKWA(wa);
	CHECKOPT1(1,NUMERIC_t);
	CHECKOPT1(2,CHARACTER_t);

	if(!ord)
		ord = wa->rd->curord;
	else
		ord = get_orderno(wa,order,index);
	if(ord==-1)
		return 0;

	_clip_retc(cm,wa->rd->orders[ord]->name);
	return 0;
err:
	return er;
}

int
clip_ORDNUMBER(ClipMachine* cm)
{
	const char* __PROC__ = "ORDNUMBER";
	DBWorkArea* wa = cur_area(cm);
	ClipVar* order = _clip_par(cm,1);
	ClipVar* index = _clip_par(cm,2);
	int ord,er;

	_clip_retni(cm,wa->rd->curord+1);
	CHECKWA(wa);
	CHECKOPT1(1,CHARACTER_t);
	CHECKOPT1(2,CHARACTER_t);

	ord = get_orderno(wa,order,index);
	if(ord==-1)
		return 0;

	_clip_retni(cm,ord+1);
	return 0;
err:
	return er;
}

int
clip_ORDSETRELATION(ClipMachine * cm)
{
	const char* __PROC__ = "ORDSETRELATION";
	int type = _clip_parinfo(cm,1);
	ClipVar* block = _clip_spar(cm,2);
	const char* expr = _clip_parc(cm,3);
	DBWorkArea* wa = cur_area(cm);
	DBWorkArea* childwa = 0;
	int er;

	CHECKWA(wa);
	CHECKARG2(1,NUMERIC_t,CHARACTER_t);
	CHECKARG2(2,CCODE_t,PCODE_t);
	CHECKOPT1(3,CHARACTER_t);

	if(type==NUMERIC_t){
		childwa = get_area(cm,_clip_parni(cm,1),0,0);
	} else if(type == CHARACTER_t){
		int i;
		DBWorkArea* twa;
		const char* alias = _clip_parc(cm,1);
		for (i = 0; i < cm->areas->count; i++)
		{
			twa = (DBWorkArea *) cm->areas->items[i];
			if (twa && twa->alias && !strcasecmp(alias, twa->alias))
				break;
		}
		childwa = get_area(cm,i+1,0,0);
	}

	CHECKWA(childwa);

	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if((er = rdd_setrelation(cm,wa->rd,childwa->rd,block,expr,1,__PROC__)))
		goto err_unlock;
	UNLOCK;
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_ORDSKIPUNIQUE(ClipMachine * cm)
{
	const char *__PROC__ = "ORDSKIPUNIQUE";
	int recs = _clip_parni(cm, 1);
	DBWorkArea *wa = cur_area(cm);
	ClipVar prev;
	ClipVar curr;
	int c,er;

	_clip_retl(cm,0);
	CHECKWA(wa);
	CHECKOPT1(1, NUMERIC_t);

	if(recs>=0)
		recs = 1;
	else
		recs = -1;

	_clip_retl(cm,1);

	READLOCK;
	if((er = rdd_keyvalue(cm,wa->rd,&prev,__PROC__))) goto err_unlock;
	while(1){
		if(wa->rd->bof || wa->rd->eof)
			return 0;
		if((er = rdd_skip(cm, wa->rd, recs, __PROC__))) goto err_unlock;
		if((er = rdd_keyvalue(cm,wa->rd,&curr,__PROC__))) goto err_unlock;
		_clip_cmp(cm,&prev,&curr,&c,1);
		_clip_destroy(cm,&prev);
		_clip_clone(cm,&prev,&curr);
		if(!c)
			break;
	}
	UNLOCK;
	_clip_destroy(cm,&prev);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
err:
	return er;
}

int
clip_DBRSELECT(ClipMachine* cm)
{
	int rno = _clip_parni(cm,1)-1;
	DBWorkArea *wa = cur_area(cm);

	_clip_retni(cm,0);
	if(!wa) return 0;

	if(rno<0 || rno >= wa->rd->rels_opened)
		return 0;
	_clip_retni(cm,wa->rd->relations[rno]->child->area+1);
	return 0;
}
/* ] user interface */

/* [ Independed Index */
int
clip_II_CREATE(ClipMachine* cm)
{
	const char* __PROC__ = "II_CREATE";
	const char* driver = _clip_parc(cm,1);
	const char* name = _clip_parc(cm,2);
	int er;

	CHECKOPT1(1,CHARACTER_t);
	CHECKARG1(2,CHARACTER_t);

	if(driver && driver[0]){
		if((er = rdd_ii_create(cm,driver,name,__PROC__))) goto err;
	} else {
		char idx[4];
		if((er = db_driver(cm,NULL,NULL,idx,NULL,__PROC__))) goto err;
		if((er = rdd_ii_create(cm,idx,name,__PROC__))) goto err;
	}

	return 0;
err:
	return er;
}

int
clip_II_OPEN(ClipMachine* cm)
{
	const char* __PROC__ = "II_OPEN";
	const char* driver = _clip_parc(cm,1);
	const char* name = _clip_parc(cm,2);
	int er;

	CHECKOPT1(1,CHARACTER_t);
	CHECKARG1(2,CHARACTER_t);

	if(driver && driver[0]){
		if((er = rdd_ii_open(cm,driver,name,__PROC__))) goto err;
	} else {
		char idx[4];
		if((er = db_driver(cm,NULL,NULL,idx,NULL,__PROC__))) goto err;
		if((er = rdd_ii_open(cm,idx,name,__PROC__))) goto err;
	}
	return 0;
err:
	return er;
}

int
clip_II_CREATETAG(ClipMachine* cm)
{
	const char* __PROC__ = "II_CREATETAG";
	int h = _clip_parni(cm,1);
	const char* tag = _clip_parc(cm,2);
	const char* expr = _clip_parc(cm,3);
	int er;

	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,CHARACTER_t);
	CHECKARG1(3,CHARACTER_t);

	if((er = rdd_ii_createtag(cm,h,tag,expr,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_OPENTAG(ClipMachine* cm)
{
	const char* __PROC__ = "II_OPENTAG";
	int h = _clip_parni(cm,1);
	const char* tag = _clip_parc(cm,2);
	int er;

	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,CHARACTER_t);

	if((er = rdd_ii_opentag(cm,h,tag,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_CLOSE(ClipMachine* cm)
{
	const char* __PROC__ = "II_CLOSE";
	int h = _clip_parni(cm,1);
	int er;

	CHECKARG1(1,NUMERIC_t);

	if((er = rdd_ii_close(cm,h,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_CLOSETAG(ClipMachine* cm)
{
	const char* __PROC__ = "II_CLOSETAG";
	int h = _clip_parni(cm,1);
	int er;

	CHECKARG1(1,NUMERIC_t);

	if((er = rdd_ii_closetag(cm,h,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_ADDKEY(ClipMachine* cm)
{
	const char* __PROC__ = "II_ADDKEY";
	int h = _clip_parni(cm,1);
	const char* id = _clip_parc(cm,2);
	ClipVar* key = _clip_par(cm,3);
	int er;

	CHECKARG1(1,NUMERIC_t);
	CHECKARG1(2,CHARACTER_t);

	if((er = rdd_ii_addkey(cm,h,id,key,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_DELKEY(ClipMachine* cm)
{
	const char* __PROC__ = "II_DELKEY";
	int h = _clip_parni(cm,1);
	int er;

	CHECKARG1(1,NUMERIC_t);

	if((er = rdd_ii_delkey(cm,h,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_GOTOP(ClipMachine* cm)
{
	const char* __PROC__ = "II_GOTOP";
	int h = _clip_parni(cm,1);
	int er;

	CHECKARG1(1,NUMERIC_t);
	if((er = rdd_ii_gotop(cm,h,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_GOBOTTOM(ClipMachine* cm)
{
	const char* __PROC__ = "II_GOBOTTOM";
	int h = _clip_parni(cm,1);
	int er;

	CHECKARG1(1,NUMERIC_t);
	if((er = rdd_ii_gobottom(cm,h,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_BOF(ClipMachine* cm)
{
	const char* __PROC__ = "II_BOF";
	int h = _clip_parni(cm,1);
	int er;

	CHECKARG1(1,NUMERIC_t);
	if((er = rdd_ii_bof(cm,h,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_EOF(ClipMachine* cm)
{
	const char* __PROC__ = "II_EOF";
	int h = _clip_parni(cm,1);
	int er;

	CHECKARG1(1,NUMERIC_t);
	if((er = rdd_ii_eof(cm,h,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_ID(ClipMachine* cm)
{
	const char* __PROC__ = "II_ID";
	int h = _clip_parni(cm,1);
	int er;

	CHECKARG1(1,NUMERIC_t);
	if((er = rdd_ii_id(cm,h,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_KEY(ClipMachine* cm)
{
	const char* __PROC__ = "II_KEY";
	int h = _clip_parni(cm,1);
	int er;

	CHECKARG1(1,NUMERIC_t);
	if((er = rdd_ii_key(cm,h,__PROC__))) goto err;
	return 0;
err:
	return er;
}

int
clip_II_SKIP(ClipMachine* cm)
{
	const char* __PROC__ = "II_SKIP";
	int h = _clip_parni(cm,1);
	int recs = _clip_parni(cm,2);
	int er;

	CHECKARG1(1,NUMERIC_t);
	CHECKOPT1(2,NUMERIC_t);

	if(_clip_parinfo(cm,2)==UNDEF_t)
		recs = 1;

	if((er = rdd_ii_skip(cm,h,recs,__PROC__))) goto err;
	return 0;
err:
	return er;
}
/* ] Independed Index */

int
clip_RDDHANDLE(ClipMachine* cm)
{
	const char* __PROC__ = "RDDHANDLE";
	int area = _clip_parni(cm,1);
	DBWorkArea *wa = NULL;
	int er;

	CHECKOPT1(1,NUMERIC_t);

	_clip_retni(cm,-1);
	if(_clip_parinfo(cm,1)!=UNDEF_t)
		wa = get_area(cm,area,0,0);
	if(!wa)
		wa = cur_area(cm);
	if(wa)
		_clip_retni(cm,wa->rd_item);
	return 0;
err:
	return er;
}

int clip_GETAREA(ClipMachine* cm){
	const char* __PROC__ = "GETAREA";
	const char* fname = _clip_parc(cm,1);
	const char* driver = _clip_parc(cm,2);
	RDD_DATA_VTBL* vtbl;
	char* path = NULL;
	DBWorkArea* wa;
	int i,er = EG_UNSUPPORTED;

	CHECKARG1(1,CHARACTER_t);
	CHECKOPT1(2,CHARACTER_t);

	_clip_retni(cm,0);
	if(!(vtbl = rdd_datadriver(cm,driver,__PROC__))) goto err;

	if((er = _rdd_parsepath(cm,fname,vtbl->suff,&path,NULL,EG_OPEN,__PROC__)))
		goto err;
	for(i=0;i<cm->areas->count;i++){
		wa = cm->areas->items[i];
		if(!wa || !wa->used)
			continue;
		if(strcmp(wa->rd->path,path)==0){
			_clip_retni(cm,i+1);
			break;
		}
	}
	free(path);
	return 0;
err:
	if(path)
		free(path);
	return er;
}

int clip___DBCOPYRAW(ClipMachine* cm){
	const char* __PROC__ = "__RDDCOPY";
	int destwa = _clip_parni(cm,1);
	ClipVar* bfor = _clip_spar(cm,2);
	ClipVar* bwhile = _clip_spar(cm,3);
	int next = _clip_parni(cm,4);
	DBWorkArea* wa = cur_area(cm);
	DBWorkArea* dwa;
	void* buf = NULL;
	ClipVar v,*vp;
	int cnt = 0,er;

	_clip_retni(cm,0);
	CHECKWA(wa);
	CHECKARG1(1,NUMERIC_t);
	dwa = get_area(cm,destwa,0,0);
	CHECKWA(dwa);
	CHECKOPT2(2,CCODE_t,PCODE_t);
	CHECKOPT2(3,CCODE_t,PCODE_t);
	CHECKOPT1(4,NUMERIC_t);

	if(bfor && bfor->t.type == UNDEF_t)
		bfor = NULL;
	if(bwhile && bwhile->t.type == UNDEF_t)
		bwhile = NULL;

	buf = malloc(wa->rd->recsize);
	if((er = _clip_flushbuffer(cm, wa, __PROC__))) goto err;
	READLOCK;
	if (dwa->rd->vtbl->_wlock(cm, dwa->rd, __PROC__)) goto err_unlock;
	while(!wa->rd->eof){
		if(bwhile){
			if((er = rdd_calc(cm,wa->rd->area,bwhile,&v,0))) goto err_unlock;
			vp = _clip_vptr(&v);
			if(vp->t.type!=LOGICAL_t){
				er = rdd_err(cm,EG_SYNTAX,0,__FILE__,__LINE__,__PROC__,
					er_badforexpr);
				goto err_unlock;
			}
			if(!vp->l.val){
				_clip_destroy(cm,&v);
				break;
			}
			_clip_destroy(cm,&v);
		}
		if(bfor){
			if((er = rdd_calc(cm,wa->rd->area,bfor,&v,0))) goto err_unlock;
			vp = _clip_vptr(&v);
			if(vp->t.type!=LOGICAL_t){
				er = rdd_err(cm,EG_SYNTAX,0,__FILE__,__LINE__,__PROC__,
					er_badforexpr);
				goto err_unlock;
			}
			if(!vp->l.val){
				_clip_destroy(cm,&v);
				if((er = rdd_skip(cm,wa->rd,1,__PROC__))) goto err_unlock;
				continue;
			}
			_clip_destroy(cm,&v);
		}
		if((er = rdd_rawread(cm,wa->rd,buf,__PROC__))) goto err_unlock;
		if((er = rdd_rawwrite(cm,dwa->rd,buf,1,__PROC__))) goto err_unlock;
		if(++cnt >= next)
			break;
		if((er = rdd_skip(cm,wa->rd,1,__PROC__))) goto err_unlock;
	}
	UNLOCK;
	if (dwa->rd->vtbl->_ulock(cm, dwa->rd, __PROC__)) goto err;
	free(buf);
	_clip_retni(cm,cnt);
	return 0;
err_unlock:
	wa->rd->vtbl->_ulock(cm,wa->rd,__PROC__);
	dwa->rd->vtbl->_ulock(cm,dwa->rd,__PROC__);
err:
	if(buf)
		free(buf);
	return er;
}

int clip___DBSETFOUND(ClipMachine* cm){
	const char* __PROC__ = "__DBSETFOUND";
	int f = _clip_parl(cm,1);
	DBWorkArea *wa = cur_area(cm);
	int er;

	CHECKWA(wa);
	CHECKOPT1(1,LOGICAL_t);

	_clip_retl(cm, wa->found ? 1 : 0);
	if(_clip_parinfo(cm,1) == LOGICAL_t)
		wa->found = f;
	return 0;
err:
	return er;
}

int clip___DBSETFOU(ClipMachine* cm){
	return clip___DBSETFOUND(cm);
}
