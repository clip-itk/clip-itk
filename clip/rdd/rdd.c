/*
	Copyright (C) 2001  ITK
	Author  : Rushad Nabiullin <rust@itk.ru>,Pavel Lasarev (paul@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html

	$Log: rdd.c,v $
	Revision 1.308  2004/04/29 09:27:18  clip
	rust: recalculate filter's codeblock if expression is changed for any reason
	
	Revision 1.307  2004/04/08 13:04:49  clip
	rust: fix in filter parsing; suppres generating error when expression is
	not optimizable and contains syntax errors

	Revision 1.306  2004/03/17 09:14:41  clip
	rust: drop/add index key on DELETE and RECALL

	Revision 1.305  2004/02/16 09:03:46  clip
	rust: perform 'child duty' at RECNO()

	Revision 1.304  2004/01/28 11:17:31  clip
	rust: RLOCK() required for DELETE and RECALL

	Revision 1.303  2004/01/21 14:48:28  clip
	rust: resolve M_REF in rdd_setvalue

	Revision 1.302  2004/01/19 15:09:40  clip
	rust: wrong length of numeric keys

	Revision 1.301  2003/12/29 11:12:52  clip
	rust: bug in cascade relations, reported by marco bernardi <bernx@tin.it>

	Revision 1.300  2003/12/01 12:04:23  clip
	rust: RDDCLOSEALL() closes only tables of current task

	Revision 1.299  2003/09/30 10:36:17  clip
	rust: perform "child duty" before SKIP

	Revision 1.298  2003/09/29 10:15:22  clip
	rust: cancel "child duty" on move, reported by Marco Bernardi <bernx@tin.it>

	Revision 1.297  2003/09/22 12:17:34  clip
	rust: update record buffer on rlock()

	Revision 1.296  2003/09/04 14:04:41  clip
	*** empty log message ***

	Revision 1.295  2003/09/02 14:27:43  clip
	changes for MINGW from
	Mauricio Abre <maurifull@datafull.com>
	paul

	Revision 1.294  2003/08/27 07:24:46  clip
	rust: rdd_checkifnew() in rdd_clearindex()

	Revision 1.293  2003/07/03 07:15:56  clip
	fix a lot of warnings
	paul

	Revision 1.292  2003/06/24 08:03:15  clip
	rust: perform child duty on eof() and found() also (clipper compatible)

	Revision 1.291  2003/06/21 08:54:47  clip
	rust: CMF (CLIP Memo File) with 64-bit file support started

	Revision 1.290  2003/06/17 09:00:16  clip
	rust: 'structural index present' attribute in .dbf header

	Revision 1.289  2003/06/11 12:14:58  clip
	rust: don't rebuild list of recs on setting to the same order (OL2)

	Revision 1.288  2003/06/05 13:20:28  clip
	rust: avoid 'unsafe read' warning and reduntant "gotop()"

	Revision 1.287  2003/06/03 14:02:46  clip
	rust: no pending seek after parent is closed

	Revision 1.286  2003/05/27 10:44:05  clip
	rust: force moving child on set relation

	Revision 1.285  2003/05/27 09:36:41  clip
	rust: child locking bug fixed

	Revision 1.284  2003/05/27 08:39:08  clip
	rust: relations bug reported by Marco Bernardi <bernx@tin.it> fixed

	Revision 1.283  2003/05/20 10:05:27  clip
	rust: minor fix

	Revision 1.282  2003/05/15 14:39:30  clip
	rust: some speed optimizations for relations

	Revision 1.281  2003/05/07 14:56:30  clip
	rust: memory leak in rdd_dbwrite()

	Revision 1.280  2003/04/30 13:53:12  clip
	rust: more compatible NTX and some speed optimizations

	Revision 1.279  2003/04/16 10:19:58  clip
	rust: #include "btree.h" -> "./btree.h" and some other fixes for BeOS

	Revision 1.278  2003/04/14 11:07:25  clip
	rust: small fix in rdd_closearea(), reported by Marco Bernardi <bernx@tin.it>

	Revision 1.277  2003/04/11 08:31:44  clip
	rust: #ifdef HAVE_MMAN_H (BeOS)

	Revision 1.276  2003/04/03 14:05:14  clip
	*** empty log message ***

	Revision 1.275  2003/04/02 10:53:20  clip
	rust: _clip_close() added

	Revision 1.274  2003/03/26 10:00:57  clip
	rust: __off_t -> off_t

	Revision 1.273  2003/03/25 12:19:27  clip
	rust: unlock FOR-index on update that excludes the key,
	reported by M&MS <berezniki@smtp.ru>

	Revision 1.272  2003/03/25 10:58:11  clip
	rust: _clip_setlock() added

	Revision 1.271  2003/03/25 09:50:59  clip
	rust: destroy relation on child close, reported by Sergey Mudry <upx@pisem.net>

	Revision 1.270  2003/03/21 11:49:40  clip
	rust: RDD locks with tasks (DOS compatibility)

	Revision 1.269  2003/03/12 12:50:43  clip
	rust: tasks share RDDs and subdrivers

	Revision 1.268  2003/03/05 13:08:34  clip
	rust: locking childs

	Revision 1.267  2003/02/28 11:50:14  clip
	rust: flushing buffers of child tables, reported by M&MS <berezniki@smtp.ru>

	Revision 1.266  2003/02/26 09:16:28  clip
	rust: ignore filter in INDEX ... WHILE (Clipper compatible)

	Revision 1.265  2003/02/25 09:50:10  clip
	rust: LOCATE optimized

	Revision 1.264  2003/02/24 15:08:41  clip
	rust: assigning at EOF does not generate error

	Revision 1.263  2003/02/23 17:18:34  clip
	rust: small fixes

	Revision 1.262  2003/02/15 14:29:35  clip
	rust: small fix

	Revision 1.261  2003/02/15 12:34:17  clip
	rust: open index with suffix

	Revision 1.260  2003/02/11 16:12:27  clip
	rust: optional parameter to m6_addscoped(); eval or regex

	Revision 1.259  2003/02/10 16:32:56  clip
	rust: CLIP_REGEXSEEK( <regex> )

	Revision 1.258  2003/02/10 13:05:41  clip
	rust: _SEEK_EVAL( <bBlock> ) (FlagShip extension)

	Revision 1.257  2003/01/31 11:52:00  clip
	rust: sx_islocked() with foreign locks, reported by druzus@polbox.com

	Revision 1.256  2003/01/22 10:59:51  clip
	rust: touch updated memo and index on close

	Revision 1.255  2003/01/22 08:47:24  clip
	rust: small fix in rdd_createindex()

	Revision 1.254  2003/01/21 11:09:28  clip
	rust: small fix

	Revision 1.253  2003/01/21 11:04:45  clip
	rust: DBFCDX operates with .idx, DBFCTX - with .ntx

	Revision 1.252  2003/01/20 09:35:11  clip
	rust: set update flag in rdd_rawwrite()

	Revision 1.251  2003/01/17 15:44:46  clip
	rust: INDEX FOR bug reported and fixed by István Földi" <foldii@terrasoft.hu>

	Revision 1.250  2003/01/15 10:42:34  clip
	rust: small fix in rdd_createindex()

	Revision 1.249  2003/01/13 13:16:46  clip
	rust: support tag names with NTX

	Revision 1.248  2002/12/24 09:55:29  clip
	rust: SET SCOPE bug fixed

	Revision 1.247  2002/12/10 15:13:39  clip
	rust: few error messages are corrected

	Revision 1.246  2002/12/09 13:41:13  clip
	rust: rdd_dbwrite() optimized

	Revision 1.245  2002/12/06 10:56:25  clip
	rust: set order bug fixed

	Revision 1.244  2002/12/02 13:48:33  clip
	rust: ignoring case in CDX;
	RDDCREATEINDEX(...,lIgnoreCase) (7th parameter)
	ORDCONDSET(...,lIgnoreCase) (16th parameter)

	Revision 1.243  2002/11/27 12:13:38  clip
	rust: small fix

	Revision 1.242  2002/11/22 13:25:20  clip
	rust: small fix

	Revision 1.241  2002/11/14 10:47:23  clip
	rust: SIGSEGV in __DbSetLocate()

	Revision 1.240  2002/11/11 13:12:15  clip
	rust: m6_Error(), m6_Set()

	Revision 1.239  2002/11/06 10:57:44  clip
	rust: CYGWIN fix

	Revision 1.238  2002/11/05 15:50:53  clip
	rust: small fix

	Revision 1.237  2002/11/05 15:25:30  clip
	rust: small fix

	Revision 1.236  2002/11/05 14:54:17  clip
	rust: small fix

	Revision 1.235  2002/11/05 14:46:30  clip
	rust: some fixes

	Revision 1.234  2002/11/04 13:56:30  clip
	rust: CYGWIN fix

	Revision 1.233  2002/11/04 10:44:07  clip
	rust: small fixes

	Revision 1.232  2002/10/30 13:04:38  clip
	rust: m6_SetFilter()

	Revision 1.231  2002/10/30 10:30:55  clip
	rust: small fix

	Revision 1.230  2002/10/30 10:29:50  clip
	rust: small fix

	Revision 1.229  2002/10/30 10:12:22  clip
	rust: small fix

	Revision 1.228  2002/10/29 13:29:46  clip
	rust: SET INDEX BUFFER LIMIT [TO] <n_Megabytes>
		  SET MAP FILE ON|OFF

	Revision 1.227  2002/10/26 11:10:02  clip
	initial support for localized runtime messages
	messages are in module 'cliprt'
	paul

	Revision 1.226  2002/10/18 13:23:11  clip
	rust: setmode(...,O_BINARY) for CYGWIN

	Revision 1.225  2002/10/11 10:33:10  clip
	rust: m6_IsOptimize()

	Revision 1.224  2002/10/11 09:11:13  clip
	rust: m6_FiltSave()/m6_FiltRestore()

	Revision 1.223  2002/10/04 11:03:15  clip
	rust: set filter to ... clears previous filter first (optimize level 2)

	Revision 1.222  2002/10/01 13:16:51  clip
	rust: build filter list

	Revision 1.221  2002/10/01 11:04:36  clip
	rust: m6_ChgOwner()

	Revision 1.220  2002/09/27 13:50:42  clip
	rust: m6_RecCount()

	Revision 1.219  2002/09/27 10:57:58  clip
	rust: ignore non-LOGICAL 5th and 6th elements of fields array in dbcreate()

	Revision 1.218  2002/09/25 13:17:03  clip
	rust: compatibility of INDEX ON behavior and some cleanups

	Revision 1.217  2002/09/17 09:54:21  clip
	rust: flex fpt

	Revision 1.216  2002/09/06 09:50:54  clip
	rust: cygwin fix

	Revision 1.215  2002/08/30 10:16:35  clip
	rust: rddsetfilter(<handle>,<cFilter>,<aAliases>) (<aAliases> added)

	Revision 1.214  2002/08/26 14:37:28  clip
	rust: warnings avoided

	Revision 1.213  2002/08/26 11:36:44  clip
	rust: cygwin fixes (rdd_open() added)

	Revision 1.212  2002/08/09 08:58:40  clip
	rust: msync() before munmap()

	Revision 1.211  2002/08/02 06:52:01  clip
	call _clip_call_errorblock from rdd_err func
	paul

	Revision 1.210  2002/07/15 14:34:49  clip
	rust: bug in rdd_dbwrite()

	Revision 1.209  2002/06/17 12:19:16  clip
	rust: rdd_takevalue() for memofield at eof

	Revision 1.208  2002/05/23 13:16:10  clip
	uri: add environment CLIP_LANG as LANG processing

	Revision 1.207  2002/05/23 09:34:55  clip
	rust: CONTINUE bug

	Revision 1.206  2002/05/18 11:12:32  clip
	rust: clipper-style indexes locking (NTX)

	Revision 1.205  2002/05/16 08:21:34  clip
	rust: LOCATE locates from beginning by default

	Revision 1.204  2002/05/15 09:52:37  clip
	rust: locate with __dblocate() and optimiziation

	Revision 1.203  2002/04/30 13:55:50  clip
	rust: respecting 'type weight' for 'X' fields

	Revision 1.202  2002/04/30 09:10:26  clip
	rust: 'X' field type support

	Revision 1.201  2002/04/27 13:20:58  clip
	rust: record buffering

	Revision 1.200  2002/04/24 13:33:29  clip
	rust: some cleanups

	Revision 1.199  2002/04/23 12:37:58  clip
	rust: ncpfs fix

	Revision 1.198  2002/04/23 12:03:39  clip
	rust: use _clip_open()

	Revision 1.197  2002/04/23 11:42:38  clip
	rust: use _clip_creat

	Revision 1.196  2002/04/23 11:15:04  clip
	rust: ncpfs fixes

	Revision 1.195  2002/04/22 11:11:20  clip
	remove ncp code from rdd/dbf.c
	create ncp module
	add ncp usage in _file/diskutil _set_lock call
	paul

	Revision 1.194  2002/04/22 07:39:40  clip
	fix cvs conflict in dbf.c
	paul

	Revision 1.193  2002/04/21 11:22:23  clip
	rust: added 2 elements to dbstruct - binary (5th) and nullable (6th)

	Revision 1.192  2002/04/19 12:19:00  clip
	rust: index on binary fields (VFP support)

	Revision 1.191  2002/04/19 08:36:05  clip
	rust: initial support of VFP DBF format, "VFPCDX" driver

	Revision 1.190  2002/04/17 12:20:15  clip
	rust: bug in _clip_parsepath() fixed

	Revision 1.189  2002/04/16 14:56:02  clip
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

	Revision 1.188  2002/04/03 09:37:44  clip
	rust: .DBF signature with various memo formats is corrected

	Revision 1.187  2002/03/21 13:55:55  clip
	rust: error messages

	Revision 1.186  2002/03/21 11:55:15  clip
	rust: big cleaning

	Revision 1.185  2002/03/19 11:43:34  clip
	rust: big cleaning

	Revision 1.184  2002/03/17 13:30:54  clip
	rust: error handling corrected

	Revision 1.183  2002/03/15 14:16:04  clip
	rust: big cleaning

	Revision 1.182  2002/03/06 15:03:13  clip
	rust: small typo

	Revision 1.181  2002/03/06 10:37:34  clip
	rust: small Cygwin fix

	Revision 1.180  2002/03/05 13:52:11  clip
	rust: small typo

	Revision 1.179  2002/03/05 13:51:28  clip
	rust: Cygwin bug

	Revision 1.178  2002/03/03 14:20:41  clip
	rust: small fixes

	Revision 1.177  2002/03/01 12:45:45  clip
	rust: dbwrite() with reference

	Revision 1.176  2002/01/16 15:29:08  clip
	chinese patch
	preproc bugs
	some pseudographic chars < 32
	paul

	Revision 1.175  2002/01/16 11:20:51  clip
	EG_OPEN with appropriate description
	rust

	Revision 1.174  2001/12/26 15:41:31  clip
	Sx_TagCount()
	rust

	Revision 1.173  2001/12/26 12:12:17  clip
	share container for ClipMachine's
	paul

	Revision 1.172  2001/12/25 10:48:23  clip
	Sx_RollBack()
	rust

	Revision 1.171  2001/12/24 13:47:30  clip
	Sx_KillTag()
	rust

	Revision 1.170  2001/12/22 13:09:45  clip
	Virtual BOF
	rust

	Revision 1.169  2001/12/22 10:28:01  clip
	index on <expr> tag <tag> to <index> does not close opened tags of <index> now
	rust

	Revision 1.168  2001/12/22 10:01:21  clip
	some changes
	rust

	Revision 1.167  2001/12/19 09:55:50  clip
	REPLACE with flock()
	rust

	Revision 1.166  2001/12/12 15:40:52  clip
	SIGSEGV when CONTINUE without LOCATE
	rust

	Revision 1.165  2001/12/12 15:34:09  clip
	SET LOCKSTYLE [TO] CLIPPER | CLIPPER50 | CLIPPER52 | CLIPPER53 | FOXPRO | SIX
	rust

	Revision 1.164  2001/12/12 13:30:09  clip
	Low level locking - DBF
	rust

	Revision 1.163  2001/12/11 10:30:18  clip
	locking bug
	rust

	Revision 1.162  2001/12/10 14:02:38  clip
	New locking...
	rust

	Revision 1.161  2001/12/10 09:21:22  clip
	Locking global reviewing...
	rust

	Revision 1.160  2001/12/06 09:49:43  clip
	use readonly bug
	rust

	Revision 1.159  2001/12/05 14:23:34  clip
	Sx_I_IndexName(), Sx_I_TagName(), Sx_IsReindex()
	rust

	Revision 1.158  2001/11/30 12:09:07  clip
	CygWin bug
	rust

	Revision 1.157  2001/11/30 11:55:29  clip
	FLOCK() bug in CygWin
	rust

	Revision 1.156  2001/11/29 14:48:29  clip
	exclusive SET ORDER TO bug
	rust

	Revision 1.155  2001/11/29 14:37:06  clip
	CYGWIN locks
	rust

	Revision 1.154  2001/11/27 14:06:57  clip
	speed optimizations (exclusive skipping with index)
	rust

	Revision 1.153  2001/11/23 14:01:26  clip
	speed optimizations
	rust

	Revision 1.152  2001/11/23 13:01:34  clip
	clip___RDDCOPY(), rdd_rawread(), rdd_rawwrite()
	rust

	Revision 1.151  2001/11/23 11:20:43  clip
	_rdd_(case)hashstr() -> _clip_(case)hashword()
	rust

	Revision 1.150  2001/11/22 12:06:41  clip
	some fixes
	rust

	Revision 1.149  2001/11/20 15:22:20  clip
	simple indexes optimizations
	rust

	Revision 1.148  2001/11/20 14:10:42  clip
	WILDSEEK, WILDSEEKNEXT, rm_WildMatch()
	rust

	Revision 1.147  2001/11/19 13:25:43  clip
	Shared open (Cygwin)
	rust

	Revision 1.146  2001/11/19 11:07:56  clip
	fixes
	rust

	Revision 1.145  2001/11/18 13:06:31  clip
	Cygwin changes
	rust

	Revision 1.144  2001/11/17 13:11:48  clip
	some changes
	rust

	Revision 1.143  2001/11/14 13:07:21  clip
	add TASKSENDMSG, TASKPEEKMSG, TASKGETMSG functions
	paul

	Revision 1.142  2001/11/14 11:13:45  clip
	GETAREA(<file>,[<driver>]) - if <file> is USEd returns area number, else 0
	rust

	Revision 1.141  2001/11/11 14:46:23  clip
	'alltrim' all field, alias, tag names.
	Bug in rdd_create()
	rust

	Revision 1.140  2001/11/09 12:40:37  clip
	bug in _rdd_parsepath()
	rust

	Revision 1.139  2001/11/09 11:51:39  clip
	Six: rm_Chill(), rm_Freeze(), rm_Warm(), rm_Thermometer()
	rust

	Revision 1.138  2001/11/08 12:39:19  clip
	Six: rmChar(), rmNum(), rmDate(), rmLog()
	rust

	Revision 1.137  2001/11/07 08:52:58  clip
	fixes
	rust

	Revision 1.136  2001/11/06 10:42:45  clip
	SIX: RDD_Count(), RDD_Info(), RDD_Name()
	rust

	Revision 1.135  2001/11/05 16:21:39  clip
	RM_SETTRIGGER(), USE ... TRIGGER
	rust

	Revision 1.134  2001/11/05 09:43:48  clip
	Six: rest of trigger events...
	rust

	Revision 1.133  2001/11/03 22:42:55  clip
	fixes
	rust

	Revision 1.132  2001/11/03 12:21:46  clip
	Six features: trigger-mechanism started;
	events implemented: EVENT_PREUSE, EVENT_POSTUSE,
	EVENT_PRECLOSE, EVENT_POSTCLOSE, EVENT_GET, EVENT_PUT
	rust

	Revision 1.131  2001/11/01 14:54:40  clip
	_clip_path() - makes absolute path respecting SET DEFAULT, SET PATH etc
	rust

	Revision 1.130  2001/10/30 13:54:32  clip
	bug in dbappend()
	rust

	Revision 1.129  2001/10/30 12:03:20  clip
	locking
	rust

	Revision 1.128  2001/10/30 10:48:19  clip
	bug in _rdd_parse_path
	rust

	Revision 1.127  2001/10/30 08:41:38  clip
	many changes
	rust

	Revision 1.126  2001/10/29 08:54:28  clip
	uri: dec >= len-1 in checking DBF structure

	Revision 1.125  2001/10/24 08:48:47  clip
	Six types: V3, V4
	rust

	Revision 1.124  2001/10/22 12:07:05  clip
	many fixes and bugs :)
	rust

	Revision 1.123  2001/10/16 13:08:39  clip
	optimizations
	rust

	Revision 1.122  2001/10/16 11:15:01  clip
	speed optimizations
	rust

	Revision 1.121  2001/10/12 10:05:20  clip
	some fixes
	rust

	Revision 1.120  2001/10/10 15:44:47  clip
	DbfLocale in memo (PACK)
	rust

	Revision 1.119  2001/10/10 15:04:58  clip
	many fixes
	rust

	Revision 1.118  2001/10/08 10:49:40  clip
	new indexing algorithm (NTX)
	rust

	Revision 1.117  2001/10/05 13:43:41  clip
	some EXCLUSIVE optimizations
	rust

	Revision 1.116  2001/10/04 07:50:52  clip
	another FOR-index related bug
	rust

	Revision 1.115  2001/10/04 06:54:06  clip
	bug regarding to FOR-indexes
	rust

	Revision 1.114  2001/10/03 12:16:56  clip
	update checks FOR clause of index
	rust

	Revision 1.113  2001/10/01 11:24:22  clip
	memory usage optimized
	rust

	Revision 1.112  2001/10/01 10:32:58  clip
	bug in parsing filter expression (SET OPTIMIZE ON)
	rust

	Revision 1.111  2001/09/28 13:58:29  clip
	SET OPTIMIZE LEVEL [TO] <1|2>
	rust

	Revision 1.110  2001/09/25 15:55:39  clip
	some changes
	rust

	Revision 1.109  2001/09/22 13:20:53  clip
	some optimizations
	rust

	Revision 1.108  2001/09/17 12:15:00  clip
	ordscope() with no controlling order isn't error
	rust

	Revision 1.107  2001/09/17 12:11:33  clip
	sync childs before skip using index
	rust

	Revision 1.106  2001/09/12 12:12:46  clip
	"Trying to open an index twice" error generation removed
	rust

	Revision 1.105  2001/09/05 11:33:45  clip
	cygwin
	paul

	Revision 1.104  2001/09/05 11:19:30  clip
	cygwin
	paul

	Revision 1.103  2001/08/31 11:34:07  clip
	LOCATE with WHILE locates from current record now
	rust

	Revision 1.102  2001/08/30 11:35:44  clip
	Optimize for shared mode
	rust

	Revision 1.101  2001/08/28 06:18:35  clip
	-s configure flag
	uninitalized var warnings with optimesed compile
	paul

	Revision 1.100  2001/08/26 10:10:54  clip
	_clip_vptr
	paul

	Revision 1.99  2001/08/26 09:55:00  clip
	absent _clip_vptr
	paul

	Revision 1.98  2001/08/24 12:26:03  clip
	LOCATE with SET FILTER and LOCAL
	rust

	Revision 1.97  2001/08/23 14:45:56  clip
	Undepended indices (II_*** functions)
	rust

	Revision 1.96  2001/08/23 13:58:08  clip
	_clip_vptr fix
	paul

	Revision 1.95  2001/08/23 13:52:06  clip
	merge with NEWLOCALS
	paul



*/
#include <ctype.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <string.h>
#include <limits.h>
#include <time.h>
#include "../clipbase.h"
#include "../rdd.h"
#include "coll.h"
#include "../screen/charset.h"
#include "error.ch"
#include "six.ch"
#include "btree.h"
#ifdef USE_TASKS
#include "../task/task.h"
#endif
#ifdef HAVE_MMAN_H
#include <sys/mman.h>
#endif

#include "../ncp.h"

#ifdef USE_NCPFS
#define fcntl ncp_fcntl
#endif


#define CHECKII(i) \
	if(!(i)) \
		return rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,"Bad independed index handle"); \

#define CHECKIO(o) \
	if(!(o)) \
		return rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,"Bad independed order handle"); \

#define er_badinstance      _clip_gettext("Bad RDD instance")
#define er_badfilterexpr    _clip_gettext("Bad filter expression")
#define er_badrelationexpr  _clip_gettext("Bad relation expression")
#define er_badforexpr       _clip_gettext("Bad FOR expression")
#define er_ioerror          _clip_gettext("I/O error")
#define er_badstructure     _clip_gettext("Bad table structure")
#define er_badfield         _clip_gettext("Bad field")
#define er_notpermitted     _clip_gettext("Operation not permitted")
#define er_noorder          _clip_gettext("No controlling order")
#define er_nofield          _clip_gettext("No such field")

int rdd_flushbuffer(ClipMachine* cm, RDD_DATA* rd, const char* __PROC__){
	int i,er;

	if(rd->changed){
		if((er = rd->vtbl->_wlock(cm,rd,__PROC__))) goto err;
		if((er = rd->vtbl->setrecord(cm,rd,__PROC__))) goto err_unlock;
		if((er = rd->vtbl->_ulock(cm,rd,__PROC__))) goto err;
		rd->changed = 0;
	}
	for(i=0;i<rd->rels_opened;i++){
		if((er = rdd_flushbuffer(cm,rd->relations[i]->child,__PROC__)))
			goto err;
	}
	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
err:
	return er;
}

int clip_INIT_RDD(ClipMachine* cm){
	strncpy(cm->def_data_driver,"DBF",3);
	strncpy(cm->def_idx_driver,"NTX",3);
	strncpy(cm->def_memo_driver,"DBT",3);
	strncpy(cm->def_db_driver,"DBFNTX",6);
	return 0;
}

void rdd_registerdatadriver(ClipMachine* cm,RDD_DATA_VTBL* vtbl){
	if(!*cm->ndata_drivers)
		*cm->data_drivers = (RDD_DATA_VTBL**)malloc(sizeof(RDD_DATA_VTBL*));
	else
		*cm->data_drivers = (RDD_DATA_VTBL**)realloc(*cm->data_drivers,
			sizeof(RDD_DATA_VTBL*)*(*cm->ndata_drivers+1));
	(*cm->ndata_drivers)++;
	(*cm->data_drivers)[*cm->ndata_drivers-1] = vtbl;
}

void rdd_registerindexdriver(ClipMachine* cm,RDD_INDEX_VTBL* vtbl){
	if(!*cm->nidx_drivers)
		*cm->idx_drivers = (RDD_INDEX_VTBL**)malloc(sizeof(RDD_INDEX_VTBL*));
	else
		*cm->idx_drivers = (RDD_INDEX_VTBL**)realloc(*cm->idx_drivers,
			sizeof(RDD_INDEX_VTBL*)*(*cm->nidx_drivers+1));
	(*cm->nidx_drivers)++;
	(*cm->idx_drivers)[*cm->nidx_drivers-1] = vtbl;
}

void rdd_registermemodriver(ClipMachine* cm,RDD_MEMO_VTBL* vtbl){
	if(!*cm->nmemo_drivers)
		*cm->memo_drivers = (RDD_MEMO_VTBL**)malloc(sizeof(RDD_MEMO_VTBL*));
	else
		*cm->memo_drivers = (RDD_MEMO_VTBL**)realloc(*cm->memo_drivers,
			sizeof(RDD_MEMO_VTBL*)*(*cm->nmemo_drivers+1));
	(*cm->nmemo_drivers)++;
	(*cm->memo_drivers)[*cm->nmemo_drivers-1] = vtbl;
}

RDD_DATA_VTBL* rdd_datadriver(ClipMachine* cm,const char* driver,const char* __PROC__){
	int i;
	char err[256];
	if(!driver || !driver[0])
		driver = cm->def_data_driver;
	for(i=0;i<*cm->ndata_drivers;i++){
		if((strlen(driver)==strlen((*cm->data_drivers)[i]->id)) &&
			(strncasecmp((*cm->data_drivers)[i]->id,driver,
			sizeof((*cm->data_drivers)[i]->id))==0))

			return (*cm->data_drivers)[i];
	}
	snprintf(err,sizeof(err),_clip_gettext("No data file driver linked: %s"),driver);
	rdd_err(cm,EG_UNSUPPORTED,0,__FILE__,__LINE__,__PROC__,err);
	return NULL;
}

RDD_INDEX_VTBL* rdd_indexdriver(ClipMachine* cm,const char* driver,const char* __PROC__){
	int i;
	char err[256];
	if(!driver || !driver[0])
		driver = cm->def_idx_driver;
	for(i=0;i<*cm->nidx_drivers;i++){
		if((strlen(driver)==strlen((*cm->idx_drivers)[i]->id)) &&
			(strncasecmp((*cm->idx_drivers)[i]->id,driver,
			sizeof((*cm->idx_drivers)[i]->id))==0))

			return (*cm->idx_drivers)[i];
	}
	snprintf(err,sizeof(err),_clip_gettext("No index file driver linked: %s"),driver);
	rdd_err(cm,EG_UNSUPPORTED,0,__FILE__,__LINE__,__PROC__,err);
	return NULL;
}

RDD_MEMO_VTBL* rdd_memodriver(ClipMachine* cm,const char* driver,const char* __PROC__){
	int i;
	char err[256];
	if(!driver || !driver[0])
		driver = cm->def_memo_driver;
	for(i=0;i<*cm->nmemo_drivers;i++){
		if((strlen(driver)==strlen((*cm->memo_drivers)[i]->id)) &&
			(strncasecmp((*cm->memo_drivers)[i]->id,driver,
			sizeof((*cm->memo_drivers)[i]->id))==0))

			return (*cm->memo_drivers)[i];
	}
	snprintf(err,sizeof(err),_clip_gettext("No memo file driver linked: %s"),driver);
	rdd_err(cm,EG_UNSUPPORTED,0,__FILE__,__LINE__,__PROC__,err);
	return NULL;
}

void loc_read(DbfLocale* loc,unsigned char* buf,int len){
	unsigned char* c = buf;
	unsigned char* e = c+len;

	for(;c<e;c++)
		if(*c&0x80)
			*c = loc->read[*c&0x7f];
}

void loc_write(DbfLocale* loc,unsigned char* buf,int len){
	unsigned char* c = buf;
	unsigned char* e = c+len;

	for(;c<e;c++)
		if(*c&0x80)
			*c = loc->write[*c&0x7f];
}

int loc_cmp(DbfLocale* loc,unsigned char* s1,unsigned char* s2,int len){
	int r = 0;
	unsigned int ch;
	unsigned char *ss1,*ss2;
	unsigned char* e = s1+len;
	int ch1,ch2;

	for(ss1=s1,ss2=s2;ss1<e && !r;ss1++,ss2++){
		ch = *ss1;
		if(ch >> 7)
			ch = loc->read[ch & 0x7F];
		ch1 = _clip_cmptbl[ch];
		ch2 = _clip_cmptbl[*ss2];
		r = ch1-ch2;
	}
	return r;
}

int _rdd_fieldno(RDD_DATA* rd,long hash){
	RDD_FIELD* fp = (RDD_FIELD*)HashTable_fetch(rd->hashes,hash);
	int fno = fp-rd->fields;

	if((fno>=rd->nfields) || (fno<0)) return -1;

	return fno;
}

int _clip_rddfieldno(ClipMachine* cm,int h,long hash){
	RDD_DATA* rd = (RDD_DATA*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RDD);

	if(!rd)
		return -1;
	return _rdd_fieldno(rd,hash);
}

static void _rdd_freebuf(ClipMachine* cm,RDD_DATA* rd){
	int i;

	for(i=0;i<rd->nfields;i++){
		if(rd->data[i]){
			_clip_destroy(cm,rd->data[i]);
			free(rd->data[i]);
			rd->data[i] = NULL;
		}
	}
}

int rdd_open(ClipMachine* cm,char* path,int readonly,int shared,int* fd,const char* __PROC__){
	*fd = _clip_open(cm,path,readonly?O_RDONLY:O_RDWR,0,!shared);
	if(*fd == -1){
		return rdd_err(cm,EG_OPEN,errno,__FILE__,__LINE__,__PROC__,path);
	}
	return 0;
}

int rdd_calc(ClipMachine* cm,int area,ClipVar* block,ClipVar* var,int noerror){
	int oldarea = 0;
	int er;

	if(area!=-1){
		oldarea = cm->curArea;
		cm->curArea = area;
	}
	if(noerror){
		cm->noerrblock++;
		if((er = _clip_eval(cm,block,0,0,var))){
			var->t.type = LOGICAL_t;
			var->l.val = 0;
		}
		cm->noerrblock--;
	} else {
		if((er = _clip_eval(cm,block,0,0,var))) return er;
	}
	if(area!=-1)
		cm->curArea = oldarea;
	return 0;
}

int rdd_takevalue(ClipMachine* cm,RDD_DATA* rd,int no,ClipVar* vv,
			   const char* __PROC__){
	int r,er;

	if(rd->pending_child_parent)
		if((er = rdd_child_duty(cm,rd,__PROC__))) return er;

	if(rd->eof){
		switch(rd->fields[no].type){
			case 'C':
				vv->t.type = CHARACTER_t;
				vv->t.flags = F_NONE;
				vv->t.memo = 0;
				vv->s.str.len = rd->fields[no].len;
				vv->s.str.buf = (char*)malloc(vv->s.str.len+1);
				memset(vv->s.str.buf,32,vv->s.str.len);
				vv->s.str.buf[vv->s.str.len] = 0;
				break;
			case 'M':
				vv->t.type = CHARACTER_t;
				vv->t.flags = F_NONE;
				vv->t.memo = 1;
				vv->s.str.len = 0;
				vv->s.str.buf = (char*)calloc(1,1);
				break;
			case 'N':
				vv->t.type = NUMERIC_t;
				vv->t.flags = F_NONE;
				vv->t.memo = 0;
				vv->t.len = rd->fields[no].len;
				vv->t.dec = rd->fields[no].dec;
				vv->n.d = 0;
				break;
			case 'D':
				vv->t.type = DATE_t;
				vv->t.flags = F_NONE;
				vv->t.memo = 0;
				vv->d.julian = 0;
				break;
			case 'L':
				vv->t.type = LOGICAL_t;
				vv->t.flags = F_NONE;
				vv->t.memo = 0;
				vv->l.val = 0;
				break;
			case 'V':
				if(rd->fields[no].len == 3){
					vv->t.type = DATE_t;
					vv->t.flags = F_NONE;
					vv->t.memo = 0;
					vv->d.julian = 0;
				} else if(rd->fields[no].len == 4){
					vv->t.type = NUMERIC_t;
					vv->t.flags = F_NONE;
					vv->t.memo = 0;
					vv->t.len = 10;
					vv->t.dec = 0;
					vv->n.d = 0;
				} else if(rd->fields[no].len >= 6){
					vv->t.type = CHARACTER_t;
					vv->t.flags = F_NONE;
					vv->t.memo = 0;
					vv->s.str.len = rd->fields[no].len-6;
					vv->s.str.buf = (char*)malloc(vv->s.str.len+1);
					memset(vv->s.str.buf,32,vv->s.str.len);
					vv->s.str.buf[vv->s.str.len] = 0;
				}
				break;
		}
	} else {
		if((er = rd->vtbl->getvalue(cm,rd,no,vv,__PROC__)))
			return er;
	}
	if((er = rdd_event(cm,EVENT_GET,rd->area,no+1,vv,&r,__PROC__)))
		return er;
	return 0;
}

int _clip_rddfield(ClipMachine* cm,int h,int no){
	const char* __PROC__ = "_clip_rddfield";
	RDD_DATA* rd = (RDD_DATA*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_RDD);
	ClipVar vv;
	int er;

	CLEAR_CLIPVAR(&vv);

	if(!rd){
		rdd_err(cm,EG_NOTABLE,0,__FILE__,__LINE__,__PROC__,er_badinstance);
		return -1;
	}
	if((er = rdd_takevalue(cm,rd,no,&vv,__PROC__))) return er;
	_clip_push(cm,&vv);
	_clip_destroy(cm, &vv);
	return 0;
}

int rdd_err(ClipMachine* cm,int genCode,int osCode,const char* subSystem,
			 int line,const char* operation,const char* desc){
	char buf[256];
	if(osCode){
#ifndef OS_MINGW
		strcpy(cm->syserr,strerror(osCode));
#else
		FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,NULL,GetLastError(),
			MAKELANGID(LANG_NEUTRAL,SUBLANG_SYS_DEFAULT),
			cm->syserr,sizeof(cm->syserr),NULL);
		_clip_translate_charset("cp1251",_clip_hostcs,cm->syserr,
			cm->syserr,strlen(cm->syserr));
#endif
	}
	_clip_logg(0,"RDD layer error: %s/%d: %s: %s",subSystem,line,desc,operation);
	snprintf(buf,sizeof(buf),"%s: %s",desc,operation);
	_clip_trap_err(cm, genCode, osCode, 0, subSystem, line, buf);
	/*return genCode;*/
	return _clip_call_errblock(cm, genCode);
}

void rdd_expandmacro(int area,int r,const char* key,char* expr){
	if(area!=-1){
		sprintf(expr,"{|| %s}",key);
		return;
	}
	sprintf(expr,"{|| __rdd__ %d %s __rdd__}",r,key);
	return;
}

int rdd_calcfilter(ClipMachine* cm,RDD_DATA* rd,int* fok,const char* __PROC__){
	int i,er;

	*fok = 1;
	if(!rd->filter)
		return 0;
	for(i=0;i<rd->filter->nfps;i++){
		ClipVar v,*vp;

		if((er = rdd_calc(cm,rd->area,&rd->filter->fps[i].bfilter,&v,rd->x)))
			return er;
		vp = _clip_vptr(&v);
		if(vp->t.type!=LOGICAL_t){
			_clip_destroy(cm,&v);
			return rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,
				er_badfilterexpr);
		}
		switch(rd->filter->fps[i].op){
			case 0:
				*fok = vp->l.val;
				break;
			case 1:
				*fok = *fok || vp->l.val;
				break;
			case 2:
				*fok = *fok && vp->l.val;
				break;
			case 3:
				*fok = (*fok && !vp->l.val) || (!(*fok) && vp->l.val);
				break;
			case 4:
				*fok = !vp->l.val;
		}
		_clip_destroy(cm,&v);
	}
	return 0;
}

int rdd_checkfilter(ClipMachine* cm,RDD_DATA* rd,int* ok,const char* __PROC__){
	/*1:true,0:false,-1:error*/
	int hidedeleted = cm->flags & DELETED_FLAG;
	int filterok = 1;
	int deletedok = 1;
	int er;

	*ok = 1;
	if(rd->indexing) return 0;
	if((!rd->filter) && !hidedeleted) return 0;

	if(hidedeleted){
		int deleted;
		if((er = rd->vtbl->deleted(cm,rd,&deleted,__PROC__))) return er;
		deletedok = !deleted;
	}
	if(deletedok && rd->filter){
		int lastrec;
		if((er = rdd_lastrec(cm,rd,&lastrec,__PROC__))) return er;
		if(rd->recno>lastrec){
			*ok = 0;
			return 0;
		}
		if(!rd->filter->custom && rd->filter->fps[0].bfilter.t.type != UNDEF_t){
			if(rd->filter->rmap){
				filterok = _rm_getbit(rd->filter->rmap,rd->filter->size,rd->recno);
			}
			if(filterok){
				if((er = rdd_calcfilter(cm,rd,&filterok,__PROC__))) return er;
			}
		} else {
			filterok = _rm_getbit(rd->filter->rmap,rd->filter->size,rd->recno);
		}
	}
	*ok = filterok && deletedok;
	return 0;
}

int rdd_checkifnew(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	RDD_ORDER* ro;
	int i,er = 0;

	_rdd_freebuf(cm,rd);
	if(rd->newrec){
		if(rd->ords_opened>0){
			for(i=0;i<rd->ords_opened;i++){
				ro = rd->orders[i];
				if(!ro->custom && rd->orders[i]->canadd){
					if((er = rdd_event(cm,EVENT_UPDATE,rd->area,0,NULL,NULL,
						__PROC__))) return er;
					if((er = ro->vtbl->_wlock(cm,ro,__PROC__))) goto unlock;
					if((er = ro->vtbl->addkey(cm,rd,ro,NULL,__PROC__)))
						goto unlock;
					if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) goto unlock;
				}
			}
		}
		rd->newrec = 0;
	}
	return 0;
unlock:
	for(i=0;i<rd->ords_opened;i++){
		ro = rd->orders[i];
		if(!ro->custom && rd->orders[i]->canadd){
			ro->vtbl->_ulock(cm,ro,__PROC__);
		}
	}
	return er;
}

int rdd_childs(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	RDD_DATA* child;
	int i,er;

	for(i=0;i<rd->rels_opened;i++){
		child = rd->relations[i]->child;
		child->pending_child_parent = rd;
		if((er = rdd_childs(cm,child,__PROC__)))
			return er;
	}
	return 0;
}

int rdd_child_duty(ClipMachine* cm,RDD_DATA* child,const char* __PROC__){
	int i,er=0,found;
	ClipVar v, *vp;
	RDD_DATA* rd = child->pending_child_parent;
	RDD_RELATION* rel = NULL;
	int locked = child->file.rlocked || child->file.wlocked;

	CLEAR_CLIPVAR(&v);
	child->pending_child_parent = NULL;

	if(!rd) goto err;
	for(i=0;i<child->pars_opened;i++){
		if(child->parents[i]->parent == rd){
			rel = child->parents[i];
			break;
		}
	}
	if(!rel) goto err;

	if(!locked){
		if((er = child->vtbl->_rlock(cm,child,__PROC__))) goto err;
	}
	if(rel->simpexpr){
		if((er = rdd_takevalue(cm,rd,rel->simpfno,&v,__PROC__)))
			goto err_unlock;
	} else {
		if((er = rdd_calc(cm,rd->area,&rel->block,&v,0)))
			goto err_unlock;
	}
	vp = _clip_vptr(&v);
	if((child->ords_opened>0) && (child->curord != -1)){
		if((er = rdd_checkifnew(cm,child,__PROC__))) goto err_unlock;
		if(rel->scoped){
			if((er = rdd_scopetop(cm,child,vp,__PROC__))) goto err_unlock;
			if((er = rdd_scopebottom(cm,child,vp,__PROC__))) goto err_unlock;
		}
		if(rd->eof){
			unsigned int lastrec;

			child->orders[child->curord]->valid_stack = 0;
			child->eof = 1;
			if((er = rdd_lastrec(cm,child,&lastrec,__PROC__))) return er;
			child->recno = lastrec+1;
		} else {
			if((er = child->orders[child->curord]->vtbl->seek(cm,child,
				child->orders[child->curord],vp,0,0,&found,__PROC__)))
				goto err_unlock;
		}
	} else {
		if(vp->t.type!=NUMERIC_t){
			er = rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,er_badrelationexpr);
			goto err_unlock;
		}
		if((er = child->vtbl->go(cm,child,vp->n.d,__PROC__))) goto err_unlock;
	}
	if(!locked){
		if((er = child->vtbl->_ulock(cm,child,__PROC__))) goto err;
	}

	_clip_destroy(cm,&v);
	return 0;

err_unlock:
	if(!locked)
		child->vtbl->_ulock(cm,child,__PROC__);
err:
	_clip_destroy(cm,&v);
	return er;
}

int _rdd_read(ClipMachine* cm,RDD_FILE* file,int pos,int len,void* buf,const char* __PROC__){
#ifdef HAVE_MMAN_H
	struct stat st;
	int realen;
#endif
	if(file->dbf && !file->rlocked && !file->wlocked){
		char buf[256];
		time_t tt;
		struct tm *tp;

		tt = time(0);
		tp = localtime(&tt);
		snprintf(buf,sizeof(buf),
			"%02d:%02d:%02d: Warning: unsafe DBF read: wlocked=%d; %s(%s)\n",
			tp->tm_hour,tp->tm_min,tp->tm_sec,file->wlocked,__PROC__,file->dbf);
		_clip_out_log(buf,strlen(buf));
		_clip_flush_log();
	}
#ifdef HAVE_MMAN_H
	if((int)file->md!=-1){
		if(pos+len>file->mapsize){
			if(fstat(file->fd,&st)==-1) goto err;
			if(file->mapsize < st.st_size){
				if(munmap(file->md,file->mapsize)==-1) goto err;
				file->mapsize = st.st_size;
				file->md = (caddr_t)mmap(0,file->mapsize,
					PROT_READ|PROT_WRITE,MAP_SHARED,
					file->fd,0);
				if(file->md==(caddr_t)-1){
					if(lseek(file->fd,pos,SEEK_SET)==-1) goto err;
					if(read(file->fd,buf,len)==-1) goto err;
					return 0;
				}
			}
		}
		realen = (pos+len > file->mapsize)?file->mapsize-pos:len;
		realen = realen<0?0:realen;
		memcpy(buf,file->md+pos,realen);
		memset(buf+realen,0,len-realen);
	} else {
#endif
		if(lseek(file->fd,pos,SEEK_SET)==-1) goto err;
		if(read(file->fd,buf,len)==-1) goto err;
#ifdef HAVE_MMAN_H
	}
#endif
	return 0;
err:
	return rdd_err(cm,EG_READ,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
}

int _rdd_write(ClipMachine* cm,RDD_FILE* file,int pos,int len,void* buf,
			  const char* __PROC__){
	struct stat st;

	if(file->dbf && !file->wlocked){
		char buf[256];
		time_t tt;
		struct tm *tp;

		tt = time(0);
		tp = localtime(&tt);
		snprintf(buf,sizeof(buf),
			"%02d:%02d:%02d: Warning: unsafe DBF write: rlocked=%d; %s(%s)\n",
			tp->tm_hour,tp->tm_min,tp->tm_sec,file->rlocked,__PROC__,file->dbf);
		_clip_out_log(buf,strlen(buf));
		_clip_flush_log();
	}
#ifdef HAVE_MMAN_H
	if((int)file->md!=-1){
		if(pos+len>file->mapsize){
			if(munmap(file->md,file->mapsize)==-1) goto err;
#ifdef _WIN32
			{
				void* bf;
				int p;
				if((p = lseek(file->fd,0,SEEK_END))==-1) goto err;
				bf = calloc(1,pos+len-p);
				if(write(file->fd,bf,pos+len-p)==-1) goto err;
				free(bf);
			}
#else
			if(lseek(file->fd,pos+len-1,SEEK_SET)==-1) goto err;
			if(write(file->fd,"",1)==-1) goto err;
#endif
			file->mapsize = pos+len;
			file->md = (caddr_t)mmap(0,file->mapsize,
				PROT_READ|PROT_WRITE,MAP_SHARED,
				file->fd,0);
			if(file->md==(caddr_t)-1){
				if(lseek(file->fd,pos,SEEK_SET)==-1) goto err;
				if(write(file->fd,buf,len)==-1) goto err;
				return 0;
			}
		}
		memcpy(file->md+pos,buf,len);
	} else {
#endif
		/* ext2 fs issue */
		if(len == 0){
			if(fstat(file->fd,&st)==-1) goto err;
			if(pos > st.st_size){
				if(lseek(file->fd,pos-1,SEEK_SET)==-1) goto err;
				if(write(file->fd,"",1)==-1) goto err;
			}
		} else {
			if(lseek(file->fd,pos,SEEK_SET)==-1) goto err;
			if(write(file->fd,buf,len)==-1) goto err;
		}
#ifdef HAVE_MMAN_H
	}
#endif
	return 0;
err:
	return rdd_err(cm,EG_WRITE,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
}

int _rdd_trunc(ClipMachine* cm,RDD_FILE* file,unsigned int len,const char* __PROC__){
#ifdef HAVE_MMAN_H
	if((int)file->md!=-1){
		if(munmap(file->md,file->mapsize)==-1) goto err;
		if(ftruncate(file->fd,len)==-1) goto err;
		file->mapsize = len;
		file->md = (caddr_t)mmap(0,file->mapsize,
			PROT_READ|PROT_WRITE,MAP_SHARED,
			file->fd,0);
	} else {
#endif
		if(ftruncate(file->fd,len)==-1) goto err;
#ifdef HAVE_MMAN_H
	}
#endif
	return 0;
err:
	return rdd_err(cm,EG_WRITE,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
}

int _rdd_read64(ClipMachine* cm,RDD_FILE* file,u8 pos,int len,void* buf,const char* __PROC__){
	return 0;
}

int _rdd_write64(ClipMachine* cm,RDD_FILE* file,u8 pos,int len,void* buf,const char* __PROC__){
	return 0;
}

int _rdd_trunc64(ClipMachine* cm,RDD_FILE* file,u8 len,const char* __PROC__){
	return 0;
}

int rdd_create(ClipMachine* cm,const char* driver,const char* memo_driver,const char* name,ClipVar* stru,const char* __PROC__){
	int count = stru->a.count;
	RDD_STRUCT* rddstru = NULL;
	int i,j,er = EG_UNSUPPORTED;
	RDD_DATA_VTBL* vtbl;
	char* path = NULL;

	if(count < 1){
		er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,er_badstructure);
		goto err;
	}
	rddstru = calloc(count,sizeof(RDD_STRUCT));
	for(i=0;i<count;i++){
		ClipVar* vp;
		ClipVar* name;
		ClipVar* type;
		ClipVar* len;
		ClipVar* dec;
		ClipVar* binary;
		ClipVar* nullable;

		vp = _clip_vptr(stru->a.items+i);
		if((vp->t.type != ARRAY_t) || (vp->a.count < 4)){
			er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,er_badfield);
			goto err;
		}

		name = _clip_vptr(vp->a.items+0);
		if(name->t.type != CHARACTER_t){
			er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,er_badfield);
			goto err;
		}
		strncpy(rddstru[i].name,name->s.str.buf,sizeof(rddstru[i].name));
		rddstru[i].name[sizeof(rddstru[i].name)-1] = 0;
		for(j=0;j<name->s.str.len;j++)
			rddstru[i].name[j] = toupper(rddstru[i].name[j]);

		type = _clip_vptr(vp->a.items+1);
		if(type->t.type != CHARACTER_t){
			er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,er_badfield);
			goto err;
		}
		rddstru[i].type = toupper(type->s.str.buf[0]);

		if(rddstru[i].type=='D'){
			rddstru[i].len = 8;
			rddstru[i].dec = 0;
		} else if(rddstru[i].type=='L'){
			rddstru[i].len = 1;
			rddstru[i].dec = 0;
		} else if(rddstru[i].type=='M'){
			rddstru[i].len = 10;
			rddstru[i].dec = 0;
		} else {
			len = _clip_vptr(vp->a.items+2);
			if(len->t.type != NUMERIC_t){
				er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,er_badfield);
				goto err;
			}
			rddstru[i].len = (int)(len->n.d+0.5);

			dec = _clip_vptr(vp->a.items+3);
			if(dec->t.type != NUMERIC_t){
				er = rdd_err(cm,EG_CREATE,0,__FILE__,__LINE__,__PROC__,er_badfield);
				goto err;
			}
			rddstru[i].dec = (int)(dec->n.d+0.5);
		}
		if(vp->a.count >= 5){
			binary = _clip_vptr(vp->a.items+4);
			if(binary->t.type == LOGICAL_t)
				rddstru[i].binary = binary->l.val;
		}
		if(vp->a.count >= 6){
			nullable = _clip_vptr(vp->a.items+5);
			if(nullable->t.type == LOGICAL_t)
				rddstru[i].nullable = nullable->l.val;
		}
	}
	if(!(vtbl = rdd_datadriver(cm,driver,__PROC__))) goto err;

	if((er = _rdd_parsepath(cm,name,vtbl->suff,&path,NULL,EG_CREATE,__PROC__)))
		goto err;

	if((er = vtbl->create(cm,vtbl,path,rddstru,count,__PROC__))) goto err;
	free(path);
	free(rddstru);
	return 0;
err:
	if(path)
		free(path);
	if(rddstru)
		free(rddstru);
	return er;
}

int rdd_creatememo(ClipMachine* cm,const char* driver,const char* name,const char* __PROC__){
	RDD_MEMO_VTBL* vtbl;
	char* path = NULL;
	int er = EG_UNSUPPORTED;

	if(!(vtbl = rdd_memodriver(cm,driver,__PROC__))) goto err;

	if((er = _rdd_parsepath(cm,name,vtbl->suff,&path,NULL,EG_CREATE,__PROC__)))
		goto err;

	if((er = vtbl->create(cm,path,__PROC__))) goto err;
	free(path);
	return 0;
err:
	if(path)
		free(path);
	return er;
}

int rdd_pack(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	char* s;
	char tmp[PATH_MAX];
	int tmpfd;
	struct stat st;
	int r,er;

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if((er = rdd_event(cm,EVENT_PACK,rd->area,0,NULL,&r,__PROC__))) return er;
	if(!r)
		return 0;

	if(rd->shared)
		return rdd_err(cm,EG_SHARED,0,__FILE__,__LINE__,__PROC__,er_notpermitted);

	if(rd->readonly)
		return rdd_err(cm,EG_READONLY,0,__FILE__,__LINE__,__PROC__,er_notpermitted);

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;

#ifdef HAVE_MMAN_H
	if((int)rd->file.md != -1){
		if(munmap(rd->file.md,rd->file.mapsize)==-1) goto err;
	}
#endif
	if(_clip_close(cm,rd->file.filehash,rd->file.fd)==-1) goto err;

	strcpy(tmp,rd->path);
	s = strrchr(tmp,'/');
	sprintf(s+1,"data%lx",(long)getpid());
	sprintf(s+9,".%lx",(long)random());
	s[13] = 0;

	if(rename(rd->path,tmp)==-1) goto err;

#ifdef _WIN32
	rd->file.fd = _clip_creat(cm,rd->path,O_RDWR|O_BINARY,cm->fileCreateMode,!rd->shared);
#else
	rd->file.fd = _clip_creat(cm,rd->path,O_RDWR,cm->fileCreateMode,!rd->shared);
#endif
	if(rd->file.fd == -1) goto err_create;
	rd->vtbl->_wlock(cm,rd,__PROC__);
	if((er = rdd_open(cm,tmp,0,0,&tmpfd,__PROC__))) return er;

	if((er = rd->vtbl->pack(cm,rd,tmpfd,__PROC__))) return er;
	if(_clip_close(cm,_clip_hashstr(tmp),tmpfd)==-1) goto err;

	if(fstat(rd->file.fd,&st)==-1) goto err;
	rd->file.mapsize = st.st_size;
	rd->file.md = (caddr_t)-1;
#ifdef HAVE_MMAN_H
	if(cm->flags1 & MAP_FILE_FLAG)
		rd->file.md = (caddr_t)mmap(0,rd->file.mapsize,
			PROT_READ|PROT_WRITE,MAP_SHARED,rd->file.fd,0);
#endif
	if(remove(tmp)==-1) goto err;
	rd->eof = 1;
	if((er =  rdd_reindex(cm,rd,__PROC__))) return er;
	return 0;
err:
	return rdd_err(cm,EG_WRITE,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
err_create:
	return rdd_err(cm,EG_CREATE,errno,__FILE__,__LINE__,__PROC__,rd->path);
}

int rdd_zap(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int i,r,er;

	if((er = rdd_event(cm,EVENT_ZAP,rd->area,0,NULL,&r,__PROC__))) return er;
	if(!r)
		return 0;

	if(rd->shared)
		return rdd_err(cm,EG_SHARED,0,__FILE__,__LINE__,__PROC__,er_notpermitted);
	if(rd->readonly)
		return rdd_err(cm,EG_READONLY,0,__FILE__,__LINE__,__PROC__,er_notpermitted);

	if((er = rd->vtbl->zap(cm,rd,__PROC__))) return er;
	for(i=0;i<rd->idxs_opened;i++)
		if((er = rd->indices[i]->vtbl->zap(cm,rd,rd->indices[i],__PROC__)))
			return er;
	if(rd->memo)
		if((er = rd->memo->vtbl->zap(cm,rd->memo,__PROC__))) return er;
	rd->bof = rd->v_bof = rd->eof = 1;
	rd->recno = 1;
	rd->newrec = 0;
	rd->valid = 0;
	return 0;
}

int rdd_usearea(ClipMachine* cm,const char* driver,const char* name,int shared,
				int readonly,int tempo,RDD_DATA** rdp,const char* __PROC__){
	RDD_DATA* rd = (RDD_DATA*)calloc(1,sizeof(RDD_DATA));
	struct stat st;
	int er = EG_UNSUPPORTED;

	rd->file.fd = -1;
	rd->file.md = (char*)-1;
	rd->locate_next = -1;
	rd->cm = cm;

	*rdp = NULL;
	if(!(rd->vtbl = rdd_datadriver(cm,driver,__PROC__))) {er = 1;goto err;}
	rd->loc = dbf_get_locale(cm);
	rd->lockstyle = cm->lockstyle;

	if((er = _rdd_parsepath(cm,name,rd->vtbl->suff,&rd->path,&rd->name,EG_OPEN,
		__PROC__)))	goto err;

	if(readonly && !shared)
		shared = 1;
	rd->shared = shared;
	rd->readonly = readonly;
	rd->tempo = tempo;

	rd->file.dbf = rd->path;
	rd->file.filehash = _clip_hashstr(rd->path);

	if((er = rdd_open(cm,rd->path,rd->readonly,rd->shared,&rd->file.fd,__PROC__)))
		goto err;

	if(fstat(rd->file.fd,&st)==-1) goto err_open;
	rd->file.mapsize = st.st_size;
	rd->hashes = new_HashTable();

	rd->file.md = (caddr_t)-1;
#ifdef HAVE_MMAN_H
	if((cm->flags1 & MAP_FILE_FLAG) && !HashTable_fetch(cm->tasklocks,rd->file.filehash))
		rd->file.md = (caddr_t)mmap(0,rd->file.mapsize,
			PROT_READ|(readonly?0:PROT_WRITE),MAP_SHARED,rd->file.fd,0);
#endif
	/* If failed use non-mapped file (md==-1) */

	if((er = rd->vtbl->_rlock(cm,rd,__PROC__))) goto err;
	if((er = rd->vtbl->open(cm,rd,__PROC__))) goto err_unlock;

	rd->curord = -1;
	rd->idxs_opened = 0;
	rd->ords_opened = 0;
	rd->rels_opened = 0;
	rd->indices = NULL;
	rd->orders = NULL;
	rd->relations = NULL;
	rd->locks = NULL;
	rd->nlocks = 0;
	rd->data = (ClipVar**)calloc(rd->nfields,sizeof(ClipVar*));

	if((er = rd->vtbl->gotop(cm,rd,__PROC__))) goto err_unlock;
	if((er = rd->vtbl->_ulock(cm,rd,__PROC__))) goto err;
	*rdp = rd;

	return 0;
err_unlock:
	rd->vtbl->_ulock(cm,rd,__PROC__);
	goto err;
err_open:
	er = rdd_err(cm,EG_OPEN,errno,__FILE__,__LINE__,__PROC__,rd->path);
err:
#ifdef HAVE_MMAN_H
	if(rd && rd->file.md != (char*)-1)
		munmap(rd->file.md,rd->file.mapsize);
#endif
	if(rd && rd->file.fd != -1)
		_clip_close(cm,rd->file.filehash,rd->file.fd);
	if(rd && rd->name)
		free(rd->name);
	if(rd && rd->path)
		free(rd->path);
	if(rd)
		free(rd);
	return er;
}

int rdd_setindex(ClipMachine* cm,RDD_DATA* rd,RDD_INDEX** rip,const char* driver,const char* name,const char* tag,int structural,const char* __PROC__){
	RDD_INDEX* ri = (RDD_INDEX*)calloc(1,sizeof(RDD_INDEX));
	struct stat st;
	int i,er = EG_UNSUPPORTED;
	int l = strlen(name);

	if(!name || !l) return 0;

	ri->file.fd = -1;
	ri->file.md = (char*)-1;
	ri->rd = rd;

	if(!structural){
		if(!(l>4 && isalnum(name[l-1]) && isalnum(name[l-2])
			&& isalnum(name[l-3]) && name[l-4] == '.')){

			if(!tag && (rd->area !=-1) && (strcasecmp(driver,"CDX")==0)){
				if(!(ri->vtbl = rdd_indexdriver(cm,"IDX",__PROC__))) goto err;
				if((er = _rdd_parsepath(cm,name,ri->vtbl->suff,&ri->path,&ri->name,EG_OPEN,__PROC__)))
					goto err;
				if(access(ri->path,F_OK)){
					free(ri->path); ri->path = NULL;
					free(ri->name); ri->name = NULL;
					if(!(ri->vtbl = rdd_indexdriver(cm,driver,__PROC__))) goto err;
					if((er = _rdd_parsepath(cm,name,ri->vtbl->suff,&ri->path,&ri->name,EG_OPEN,__PROC__)))
						goto err;
				}
			} else if(!tag && (rd->area !=-1) && (strcasecmp(driver,"CTX")==0)){
				if(!(ri->vtbl = rdd_indexdriver(cm,"NTX",__PROC__))) goto err;
				if((er = _rdd_parsepath(cm,name,ri->vtbl->suff,&ri->path,&ri->name,EG_OPEN,__PROC__)))
					goto err;
				if(access(ri->path,F_OK)){
					free(ri->path); ri->path = NULL;
					free(ri->name); ri->name = NULL;
					if(!(ri->vtbl = rdd_indexdriver(cm,driver,__PROC__))) goto err;
					if((er = _rdd_parsepath(cm,name,ri->vtbl->suff,&ri->path,&ri->name,EG_OPEN,__PROC__)))
						goto err;
				}
			} else {
				if(!(ri->vtbl = rdd_indexdriver(cm,driver,__PROC__))) goto err;
				if((er = _rdd_parsepath(cm,name,ri->vtbl->suff,&ri->path,&ri->name,EG_OPEN,__PROC__)))
					goto err;
			}
		} else {
			if(!(ri->vtbl = rdd_indexdriver(cm,driver,__PROC__))) goto err;
			if((er = _rdd_parsepath(cm,name,ri->vtbl->suff,&ri->path,&ri->name,EG_OPEN,__PROC__)))
				goto err;
		}
	} else {
		if(!(ri->vtbl = rdd_indexdriver(cm,driver,__PROC__))) goto err;
		ri->path = strdup(name);
		ri->name = strdup(rd->name);
	}

	for(i=0;i<rd->idxs_opened;i++)
		if(strcmp(rd->indices[i]->path,ri->path)==0){
			free(ri->name);
			free(ri->path);
			free(ri);
			if(rip)
				*rip = rd->indices[i];
			return 0;
		}

	ri->file.filehash = _clip_hashstr(ri->path);

	if((er = rdd_open(cm,ri->path,rd->readonly,rd->shared,&ri->file.fd,__PROC__)))
		goto err;

	if(fstat(ri->file.fd,&st) == -1) goto err_open;
	ri->file.mapsize = st.st_size;
	ri->file.md = (caddr_t)-1;
#ifdef HAVE_MMAN_H
	if((cm->flags1 & MAP_FILE_FLAG) && !HashTable_fetch(cm->tasklocks,rd->file.filehash))
		ri->file.md = (caddr_t)mmap(0,ri->file.mapsize,
			PROT_READ|(rd->readonly?0:PROT_WRITE),MAP_SHARED,ri->file.fd,0);
	/* If failed use non-mapped file (md==-1) */
#endif
	if((er = ri->vtbl->open(cm,rd,ri,tag,__PROC__))) goto err;
	if(rd->curord==-1){
		rd->curord = ri->orders[0]->orderno;
	}
	rd->idxs_opened++;
	rd->indices = (RDD_INDEX**)realloc(rd->indices,sizeof(RDD_INDEX*)*rd->idxs_opened);
	rd->indices[rd->idxs_opened-1] = ri;
	ri->indexno = rd->idxs_opened-1;

	for(i=0;i<ri->norders;i++){
		RDD_ORDER* ro = ri->orders[i];
		if(ro->cforexpr && ro->cforexpr[0]){
			int r = _clip_parni(cm,1);
			char expr[1024];

			memset(expr,0,sizeof(expr));
			rdd_expandmacro(rd->area,r,ro->cforexpr,expr);

			if((er = _clip_eval_macro(cm,expr,strlen(expr),&ro->bforexpr)))
				goto err;
		}
	}
	if(rip)
		*rip = ri;
	return 0;
err_open:
	er = rdd_err(cm,EG_OPEN,errno,__FILE__,__LINE__,__PROC__,ri->path);
err:
	if(ri && ri->name)
		free(ri->name);
	if(ri && ri->path)
		free(ri->path);
#ifdef HAVE_MMAN_H
	if(ri && ri->file.md != (char*)-1)
		munmap(ri->file.md,ri->file.mapsize);
#endif
	if(ri && ri->file.fd != -1)
		_clip_close(cm,ri->file.filehash,ri->file.fd);
	if(ri)
		free(ri);
	return er;
}

int rdd_setmemo(ClipMachine* cm,RDD_DATA* rd,const char* driver,const char* name,const char* __PROC__){
	RDD_MEMO* rm = (RDD_MEMO*)calloc(1,sizeof(RDD_MEMO));
	struct stat st;
	int er = EG_UNSUPPORTED;

	if(rd->memo){
		er = rdd_err(cm,EG_OPEN,0,__FILE__,__LINE__,__PROC__,
			"Memo file is already opened");
		goto err;
	}

	memset(rm,0,sizeof(RDD_MEMO));
	rm->loc = rd->loc;
	if(!(rm->vtbl = rdd_memodriver(cm,driver,__PROC__))) goto err;

	if((er = _rdd_parsepath(cm,name,rm->vtbl->suff,&rm->path,&rm->name,EG_OPEN,__PROC__)))
		goto err;

	rm->file.filehash = _clip_hashstr(rm->path);

	if((er = rdd_open(cm,rm->path,rd->readonly,rd->shared,&rm->file.fd,__PROC__)))
		goto err;

	if(fstat(rm->file.fd,&st)==-1) goto err_open;
	rm->file.mapsize = st.st_size;

	rm->file.md = (caddr_t)-1;
#ifdef HAVE_MMAN_H
	if((cm->flags1 & MAP_FILE_FLAG) && !HashTable_fetch(cm->tasklocks,rd->file.filehash))
		rm->file.md = (caddr_t)mmap(0,rm->file.mapsize,
			PROT_READ|(rd->readonly?0:PROT_WRITE),MAP_SHARED,rm->file.fd,0);
		/* If failed use non-mapped file (md==-1) */
#endif
	rd->memo = rm;

	if((er = rm->vtbl->open(cm,rd,rm,__PROC__))) goto err;

	return 0;
err_open:
	er = rdd_err(cm,EG_OPEN,errno,__FILE__,__LINE__,__PROC__,rm->path);
err:
	if(rm && rm->name)
		free(rm->name);
	if(rm && rm->path)
		free(rm->path);
#ifdef HAVE_MMAN_H
	if(rm && rm->file.md != (char*)-1)
		munmap(rm->file.md,rm->file.mapsize);
#endif
	if(rm && rm->file.fd != -1)
		_clip_close(cm,rm->file.filehash,rm->file.fd);
	if(rm)
		free(rm);
	rd->memo = NULL;
	return er;
}

int rdd_createindex(ClipMachine* cm,RDD_DATA* rd,const char* driver,
					const char* name,const char* tag,const char* expr,
					ClipVar* block,int unique,const char* __PROC__){
	RDD_INDEX* ri = NULL;
	RDD_ORDER* ro = NULL;
	int alreadyopened = 0;
	int cr = 0,er = EG_UNSUPPORTED;
	int i,j;
	char tagname[11];

	ri = (RDD_INDEX*)calloc(1,sizeof(RDD_INDEX));
	if(rd->area != -1){
		if(!tag && strcasecmp(driver,"CDX")==0){
			if(!(ri->vtbl = rdd_indexdriver(cm,"IDX",__PROC__))) goto err;
		} else if(!tag && strcasecmp(driver,"CTX")==0){
			if(!(ri->vtbl = rdd_indexdriver(cm,"NTX",__PROC__))) goto err;
		} else {
			if(!(ri->vtbl = rdd_indexdriver(cm,driver,__PROC__))) goto err;
		}
	} else {
		if(!(ri->vtbl = rdd_indexdriver(cm,driver,__PROC__))) goto err;
	}
	if((er = _rdd_parsepath(cm,name,ri->vtbl->suff,&ri->path,&ri->name,EG_CREATE,__PROC__)))
		goto err;

	ri->file.filehash = _clip_hashstr(ri->path);

	if(ri->vtbl->ismulti && (access(ri->path,F_OK)==0)){
		free(ri->path);
		free(ri->name);
		free(ri);
		if((er = rdd_setindex(cm,rd,&ri,driver,name,NULL,0,__PROC__))) goto err;
		alreadyopened = ri->indexno+1;
	}

	ri->rd = rd;
	ri->loc = rd->loc;

	if(!alreadyopened){
		struct stat st;
		ri->file.fd = _clip_creat(cm,ri->path,O_RDWR,cm->fileCreateMode,rd->shared);
		if(ri->file.fd == -1) goto err_create;
		ri->file.mapsize = 1024;
		if(fstat(ri->file.fd,&st) == -1) goto err_open;
		if(lseek(ri->file.fd,ri->file.mapsize-1,SEEK_SET)==-1) goto err_create;
		if(write(ri->file.fd,"",1)==-1) goto err_create;
		ri->file.md = (caddr_t)-1;
#ifdef HAVE_MMAN_H
		if((cm->flags1 & MAP_FILE_FLAG) && !HashTable_fetch(cm->tasklocks,rd->file.filehash))
			ri->file.md = (caddr_t)mmap(0,ri->file.mapsize,
				PROT_READ|PROT_WRITE,MAP_SHARED,ri->file.fd,0);
			/* If failed use non-mapped file (md==-1) */
#endif
		cr = 1;
	}

	if((er = rdd_checkifnew(cm,rd,__PROC__))) goto err;

	if(tag){
		strncpy(tagname,tag,10);
		tagname[10] = 0;
		_clip_upstr(tagname,10);
	}
	rd->indexing = ri->name;
	if((er = ri->vtbl->create(cm,rd,ri,&ro,tag?tagname:NULL,expr,block,unique,cr,0,__PROC__))) goto err;
	rd->indexing = NULL;

	if(ri->structural && !rd->readonly){
		if((er = rd->vtbl->setstruct(cm,rd,__PROC__))) goto err;
	}

	if(!rd->os.lAdditive){
		j = rd->idxs_opened;
		for(i=0;i<j;i++){
			if(rd->indices[i]->structural || rd->indices[i]->indexno == alreadyopened-1)
				continue;
			rd->idxs_opened--;
			rd->ords_opened -= rd->indices[i]->norders;
			if(rd->indices[i] != ri){
#ifdef HAVE_MMAN_H
				if((int)(rd->indices[i]->file.md)!=-1){
					if(munmap(rd->indices[i]->file.md,rd->indices[i]->file.mapsize)==-1)
						goto err_close;
				}
#endif
				if(_clip_close(cm,rd->indices[i]->file.filehash,rd->indices[i]->file.fd)==-1)
					goto err_close;
				if((er = rd->indices[i]->vtbl->close(cm,rd,rd->indices[i],__PROC__)))
					goto err;
			}
		}
	}
	if(!alreadyopened){
		rd->idxs_opened++;
		rd->indices = realloc(rd->indices,rd->idxs_opened*sizeof(RDD_INDEX*));
		rd->indices[rd->idxs_opened-1] = ri;
	}
	rd->ords_opened = 0;
	for(i=0;i<rd->idxs_opened;i++){
		for(j=0;j<rd->indices[i]->norders;j++){
			rd->orders = realloc(rd->orders,(rd->ords_opened+1)* sizeof(RDD_ORDER*));
			rd->orders[rd->ords_opened] = rd->indices[i]->orders[j];
			rd->orders[rd->ords_opened]->orderno = rd->ords_opened;
			if(rd->orders[rd->ords_opened] == ro)
				rd->curord = rd->ords_opened;
			rd->ords_opened++;
		}
	}
	if(rd->ords_opened == 1)
		if((er = ri->vtbl->gotop(cm,rd,ro,__PROC__))) goto err;
	return 0;
err_open:
	er = rdd_err(cm,EG_OPEN,errno,__FILE__,__LINE__,__PROC__,ri->path);
	goto err;
err_create:
	er = rdd_err(cm,EG_CREATE,errno,__FILE__,__LINE__,__PROC__,ri->path);
	goto err;
err_close:
	er = rdd_err(cm,EG_CLOSE,errno,__FILE__,__LINE__,__PROC__,rd->indices[i]->path);
err:
	if(!alreadyopened){
		if(ri && ri->name)
			free(ri->name);
		if(ri && ri->path)
			free(ri->path);
#ifdef HAVE_MMAN_H
		if(ri && ri->file.md != (char*)-1)
			munmap(ri->file.md,ri->file.mapsize);
#endif
		if(ri && ri->file.fd != -1)
			_clip_close(cm,ri->file.filehash,ri->file.fd);
		if(ri)
			free(ri);
	}
	return er;
}

int rdd_reindex(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int i,er;

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if(rd->shared)
		return rdd_err(cm,EG_SHARED,0,__FILE__,__LINE__,__PROC__,er_notpermitted);
	if(rd->readonly)
		return rdd_err(cm,EG_READONLY,0,__FILE__,__LINE__,__PROC__,er_notpermitted);

	for(i=0;i<rd->idxs_opened;i++){
		RDD_INDEX* ri = rd->indices[i];
		rd->indexing = ri->name;
		rd->reindexing = 1;
		if((er = ri->vtbl->reindex(cm,rd,ri,__PROC__))) return er;
		rd->indexing = NULL;
		rd->reindexing = 0;
	}
	rd->newrec = 0;
	return rdd_gotop(cm,rd,__PROC__);
}

int rdd_orddestroy(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__){
	int i,er;

	if((er = ro->vtbl->destroy(cm,rd,ro,__PROC__))) return er;

	for(i=0;i<rd->ords_opened;i++){
		if(rd->orders[i]==ro){
			for(i++;i<rd->ords_opened;i++){
				rd->orders[i-1] = rd->orders[i];
				rd->orders[i-1]->orderno = i-1;
			}
			rd->ords_opened--;
			rd->orders = (RDD_ORDER**)realloc(rd->orders,
				rd->ords_opened*sizeof(RDD_ORDER*));
			break;
		}
	}

	for(i=0;i<ro->index->norders;i++){
		if(ro->index->orders[i]==ro){
			for(i++;i<ro->index->norders;i++){
				ro->index->orders[i-1] = ro->index->orders[i];
			}
			ro->index->norders--;
			ro->index->orders = (RDD_ORDER**)realloc(ro->index->orders,
				ro->index->norders*sizeof(RDD_ORDER*));
			break;
		}
	}

	destroy_rdd_order(cm,ro);
	rd->curord = -1;
	return 0;
}

int rdd_setorder(ClipMachine* cm,RDD_DATA*rd,int order,const char* __PROC__){
	int er;

	if(order < 0 || order>rd->ords_opened || order-1 == rd->curord)
		return 0;
	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	rd->curord = order-1;
	if(rd->curord != -1)
		rd->orders[rd->curord]->valid_stack = 0;
	if((er = _rdd_calcfiltlist(cm,rd,__PROC__))) return er;
	return 0;
}

int rdd_closearea(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int i,k,er;
#ifdef HAVE_MMAN_H
	int fd;
	char upd;
#endif

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
#ifdef HAVE_MMAN_H
	if((int)(rd->file.md)!=-1){
		if(msync(rd->file.md,rd->file.mapsize,MS_SYNC|MS_INVALIDATE)) goto err;
		if(munmap(rd->file.md,rd->file.mapsize)==-1) goto err;
		rd->file.md = (caddr_t)-1;
	}
	if((rd->memo) && ((int)(rd->memo->file.md)!=-1)){
		if(msync(rd->memo->file.md,rd->memo->file.mapsize,MS_SYNC|MS_INVALIDATE)) goto err;
		if(munmap(rd->memo->file.md,rd->memo->file.mapsize)==-1) goto err;
		if(rd->memo->updated){
			fd = rd->memo->file.fd;
			if(lseek(fd,0,SEEK_SET)) goto err;
			if(read(fd,&upd,1)!=1) goto err;
			if(lseek(fd,0,SEEK_SET)) goto err;
			if(write(fd,&upd,1)!=1) goto err;
		}
	}
	for(i=0;i<rd->idxs_opened;i++){
		if((int)(rd->indices[i]->file.md)!=-1){
			if(msync(rd->indices[i]->file.md,rd->indices[i]->file.mapsize,
				MS_SYNC|MS_INVALIDATE)) goto err;
			if(munmap(rd->indices[i]->file.md,rd->indices[i]->file.mapsize)==-1)
				goto err;
			if(rd->indices[i]->updated){
				fd = rd->indices[i]->file.fd;
				if(lseek(fd,0,SEEK_SET)) goto err;
				if(read(fd,&upd,1)!=1) goto err;
				if(lseek(fd,0,SEEK_SET)) goto err;
				if(write(fd,&upd,1)!=1) goto err;
			}
		}
	}
#endif
	if(rd->memo){
		if(_clip_close(cm,rd->memo->file.filehash,rd->memo->file.fd)==-1)
			goto err;
		if(rd->tempo){
			if(remove(rd->memo->path)==-1) goto err;
		}
	}
	for(i=0;i<rd->idxs_opened;i++){
		if(_clip_close(cm,rd->indices[i]->file.filehash,rd->indices[i]->file.fd)==-1)
			goto err;
		if(rd->tempo){
			if(remove(rd->indices[i]->path)==-1) goto err;
		}
	}
	if(rd->filter){
		if(rd->filter->active){
			if((er = rdd_destroyfilter(cm,rd->filter,__PROC__))) return er;
		}
	}
	for(k=0;k<rd->rels_opened;k++){
		RDD_DATA* rel = rd->relations[k]->child;
		rel->pending_child_parent = NULL;
		for(i=0;i<rel->pars_opened;i++){
			if(rel->parents[i]->parent == rd){
				if(rel->parents[i]->expr)
					free(rel->parents[i]->expr);
				_clip_destroy(cm,&rel->parents[i]->block);
				free(rel->parents[i]);
				memmove(rel->parents+i,rel->parents+i+1,
					(rel->pars_opened-i-1)*sizeof(RDD_RELATION*));
				rel->pars_opened--;
				rel->parents = realloc(rel->parents,rel->pars_opened*sizeof(void*));
				i--;
			}
		}
	}
	if(rd->relations)
		free(rd->relations);

	for(k=0;k<rd->pars_opened;k++){
		RDD_DATA* par = rd->parents[k]->parent;
		for(i=0;i<par->rels_opened;i++){
			if(par->relations[i]->child == rd){
				if(par->relations[i]->expr)
					free(par->relations[i]->expr);
				_clip_destroy(cm,&par->relations[i]->block);
				free(par->relations[i]);
				memmove(par->relations+i,par->relations+i+1,
					(par->rels_opened-i-1)*sizeof(RDD_RELATION*));
				par->rels_opened--;
				par->relations = realloc(par->relations,par->rels_opened*sizeof(void*));
				i--;
			}
		}
	}
	if(rd->parents)
		free(rd->parents);

	_clip_destroy(cm,&rd->os.bForCondition);
	_clip_destroy(cm,&rd->os.bWhileCondition);
	_clip_destroy(cm,&rd->os.bEval);

	if((er = rd->vtbl->close(cm,rd,__PROC__))) return er;
	if((er = rdd_ulock(cm,rd,0,1,__PROC__))) return er;
	if((er = rd->vtbl->_ulock(cm,rd,__PROC__))) return er;
	if(_clip_close(cm,rd->file.filehash,rd->file.fd)==-1) goto err;
	if(rd->tempo){
		if(remove(rd->path)==-1) goto err;
	}
	return 0;
err:
	return rdd_err(cm,EG_CLOSE,errno,__FILE__,__LINE__,__PROC__,rd->path);
}

int rdd_gotop(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	RDD_ORDER* ro;
	int er;

	rd->pending_child_parent = NULL;
	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if(rd->curord==-1){
		if((er = rd->vtbl->gotop(cm,rd,__PROC__))) return er;
	} else {
		ro = rd->orders[rd->curord];
		if((er = ro->vtbl->_rlock(cm,ro,__PROC__))) return er;
		if((er = ro->vtbl->gotop(cm,rd,ro,__PROC__))) goto unlock;
		if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) return er;
	}
	return 0;
unlock:
	ro->vtbl->_ulock(cm,ro,__PROC__);
	return er;
}

int rdd_gobottom(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	RDD_ORDER* ro;
	int er;

	rd->pending_child_parent = NULL;
	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if(rd->curord==-1){
		if((er = rd->vtbl->gobottom(cm,rd,__PROC__))) return er;
	} else {
		ro = rd->orders[rd->curord];
		if((er = ro->vtbl->_rlock(cm,ro,__PROC__))) return er;
		if((er = ro->vtbl->gobottom(cm,rd,ro,__PROC__))) goto unlock;
		if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) return er;
	}
	return 0;
unlock:
	ro->vtbl->_ulock(cm,ro,__PROC__);
	return er;
}

int rdd_skip(ClipMachine* cm,RDD_DATA* rd,int recs, const char* __PROC__){
	RDD_ORDER* ro;
	int i,er;

	if(rd->pending_child_parent)
		if((er = rdd_child_duty(cm,rd,__PROC__))) return er;
	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if((er = rdd_childs(cm,rd,__PROC__))) return er;
	if(rd->curord==-1){
		if(recs>0){
			for(i=0;i<recs;i++){
				if((er = rd->vtbl->next(cm,rd,0,__PROC__))) return er;
			}
		} else {
			for(i=0;i>recs;i--){
				if((er = rd->vtbl->prev(cm,rd,__PROC__))) return er;
			}
		}
	} else {
		ro = rd->orders[rd->curord];
		if((er = ro->vtbl->_rlock(cm,ro,__PROC__))) return er;
		if(recs>0){
			for(i=0;i<recs;i++){
				if((er = ro->vtbl->next(cm,rd,ro,__PROC__))) goto unlock;
			}
		} else {
			for(i=0;i>recs;i--){
				if((er = ro->vtbl->prev(cm,rd,ro,__PROC__))) goto unlock;
			}
		}
		if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) return er;
	}
	if(recs==0){
		rd->valid = 0;
	}
	return 0;
unlock:
	ro->vtbl->_ulock(cm,ro,__PROC__);
	return er;
}

int rdd_seek(ClipMachine* cm,RDD_DATA* rd,ClipVar* v,int soft,int last,int* found,const char* __PROC__){
	RDD_ORDER* ro;
	int er;

	if((rd->ords_opened<1) || (rd->curord==-1))
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);

	rd->pending_child_parent = NULL;
	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;

	ro = rd->orders[rd->curord];
	if((er = ro->vtbl->_rlock(cm,ro,__PROC__))) return er;
	if((er = ro->vtbl->seek(cm,rd,ro,v,soft,last,found,__PROC__))) goto unlock;
	if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) return er;
	return 0;
unlock:
	ro->vtbl->_ulock(cm,ro,__PROC__);
	return er;
}

int rdd_goto(ClipMachine* cm,RDD_DATA* rd,int rec,const char* __PROC__){
	int er;

	rd->pending_child_parent = NULL;
	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;

	if((er = rd->vtbl->go(cm,rd,rec,__PROC__))) return er;
/*	if(rd->curord != -1){
		if((er = rd->orders[rd->curord]->vtbl->buildtree(
			cm,rd,rd->orders[rd->curord],__PROC__))) return er;
	}*/
	return 0;
}

int rdd_gotokey(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,unsigned int keyno,int* ok,const char* __PROC__){
	int er;

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if((er = ro->vtbl->_rlock(cm,ro,__PROC__))) return er;
	if((er = ro->vtbl->gotokey(cm,rd,ro,keyno,ok,__PROC__))) goto unlock;
	if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) return er;
	return 0;
unlock:
	ro->vtbl->_ulock(cm,ro,__PROC__);
	return er;
}

int rdd_bof(ClipMachine* cm,RDD_DATA* rd,int* bof,const char* __PROC__){
	*bof = rd->bof | rd->v_bof;
	return 0;
}

int rdd_eof(ClipMachine* cm,RDD_DATA* rd,int* eof,const char* __PROC__){
	int er;

	if(rd->pending_child_parent)
		if((er = rdd_child_duty(cm,rd,__PROC__))) return er;
	*eof = rd->eof;
	return 0;
}

int rdd_recno(ClipMachine* cm,RDD_DATA* rd,int* recno,const char* __PROC__){
	int er;

	if(rd->pending_child_parent)
		if((er = rdd_child_duty(cm,rd,__PROC__))) return er;
	*recno = rd->recno;
	return 0;
}

int rdd_lastrec(ClipMachine* cm,RDD_DATA* rd,int* lastrec,const char* __PROC__){
	return rd->vtbl->lastrec(cm,rd,lastrec,__PROC__);
}

int rdd_keyno(ClipMachine* cm,RDD_DATA* rd,int* keyno,const char* __PROC__){
	int er;

	if((rd->ords_opened<1) || (rd->curord==-1))
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if((er = rd->orders[rd->curord]->vtbl->keyno(cm,rd,rd->orders[rd->curord],
		keyno,__PROC__))) return er;
	return 0;
}

int rdd_lastkey(ClipMachine* cm,RDD_DATA* rd,int* lastkey,const char* __PROC__){
	int er;

	if((rd->ords_opened<1) || (rd->curord==-1))
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if((er = rd->orders[rd->curord]->vtbl->lastkey(cm,rd,rd->orders[rd->curord],
		lastkey,__PROC__))) return er;
	return 0;
}

int rdd_fieldname(ClipMachine* cm,RDD_DATA* rd,int fno,const char* __PROC__){
	if(fno<0 || fno>=rd->nfields)
		_clip_retc(cm,"");

	_clip_retc(cm,rd->fields[fno].name);
	return 0;
}

int rdd_append(ClipMachine* cm,RDD_DATA* rd,int* neterr,const char* __PROC__){
	int r,er;
	int lastrec;

	rd->pending_child_parent = NULL;
	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if((er = rdd_event(cm,EVENT_APPEND,rd->area,0,NULL,&r,__PROC__))) return er;
	if(!r)
		return 0;
	if((er = rdd_lastrec(cm,rd,&lastrec,__PROC__))) return er;
	if((er = rd->vtbl->rlock(cm,rd,lastrec+1,&r,__PROC__))) return er;
	*neterr = 0;
	if(!r){ // neterr()
		*neterr = 1;
		return 0;
	}
	if((er = rd->vtbl->append(cm,rd,__PROC__))) return er;
	if(rd->filter && rd->filter->rmap){
		unsigned int bytes = ((lastrec+1) >> 5) + 1;
		int fok;

		if(((lastrec) >> 5)+1 < bytes){
			rd->filter->rmap = realloc(rd->filter->rmap,bytes<<2);
			rd->filter->size = lastrec;
		}
		if((er = rdd_calcfilter(cm,rd,&fok,__PROC__))) return er;
		if(fok){
			_rm_setbit(rd->filter->rmap,rd->filter->size,rd->recno);
		} else {
			_rm_clrbit(rd->filter->rmap,rd->filter->size,rd->recno);
		}
	}
	rd->newrec = 1;
	return 0;
}

int rdd_getvaluebn(ClipMachine* cm,RDD_DATA* rd,const char* fname,const char* __PROC__){
	int fno = _rdd_fieldno(rd,_clip_casehashword(fname,strlen(fname)));

	if(fno<0)
		return rdd_err(cm,EG_NOVAR,0,__FILE__,__LINE__,__PROC__,er_nofield);

	return rdd_getvalue(cm,rd,fno,__PROC__);
}

int rdd_getvalue(ClipMachine* cm,RDD_DATA* rd,int no,const char* __PROC__){
	int eof,r,er;

	if(rd->pending_child_parent)
		if((er = rdd_child_duty(cm,rd,__PROC__))) return er;

	if((er = rdd_eof(cm,rd,&eof,__PROC__))) return er;
	if(eof){
		char* str;
		switch(rd->fields[no].type){
			case 'C':
				str = (char*)malloc(rd->fields[no].len+1);
				memset(str,32,rd->fields[no].len);
				str[rd->fields[no].len] = 0;
				_clip_retcn_m(cm,str,rd->fields[no].len);
				break;
			case 'M':
				_clip_retcn(cm,"",0);
				break;
			case 'N':
				_clip_retndp(cm,0,rd->fields[no].len,rd->fields[no].dec);
				break;
			case 'D':
				_clip_retdj(cm,0);
				break;
			case 'L':
				_clip_retl(cm,0);
				break;
		}
	} else {
		if((er = rd->vtbl->getvalue(cm,rd,no,RETPTR(cm),__PROC__))) return er;
	}
	if((er = rdd_event(cm,EVENT_GET,rd->area,no+1,RETPTR(cm),&r,__PROC__)))
		return er;
	return 0;
}

int rdd_setvaluebn(ClipMachine* cm,RDD_DATA* rd,const char* fname,ClipVar* vp,const char* __PROC__){
	int fno = _rdd_fieldno(rd,_clip_casehashword(fname,strlen(fname)));

	if(fno<0)
		return rdd_err(cm,EG_NOVAR,0,__FILE__,__LINE__,__PROC__,er_nofield);

	return rdd_setvalue(cm,rd,fno,vp,__PROC__);
}

int rdd_setvalue(ClipMachine* cm,RDD_DATA* rd,int no,ClipVar* vp,const char* __PROC__){
	ClipVar* v = _clip_vptr(vp);
	RDD_ORDER* ro;
	int eof,i,r,er;

	if(rd->pending_child_parent)
		if((er = rdd_child_duty(cm,rd,__PROC__))) return er;

	if((er = rdd_event(cm,EVENT_PUT,rd->area,no+1,v,&r,__PROC__)))
		return er;
	if(!r)
		return 0;

	if((er = rdd_eof(cm,rd,&eof,__PROC__))) return er;
	if(eof){
		return 0;
	}

	if((er = rd->vtbl->rlocked(cm,rd,rd->recno,&r,__PROC__))) return er;
	if(!r && !rd->flocked)
		return rdd_err(cm,EG_UNLOCKED,0,__FILE__,__LINE__,__PROC__,er_notpermitted);

	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			ro = rd->orders[i];
			if(!ro->custom){
				if((ro->bforexpr.t.type == UNDEF_t) && ro->simpexpr
					&& (ro->simpfno != no))
					continue;
				if((er = rdd_event(cm,EVENT_UPDATE,rd->area,0,NULL,NULL,__PROC__)))
					goto unlock;
				if((er = ro->vtbl->_wlock(cm,ro,__PROC__))) goto unlock;
				if((er = ro->vtbl->delkey(cm,rd,ro,__PROC__))) goto unlock;
				ro->index->updated = 1;
			}
		}
		rd->eof = 0;
	}

	if((er = rd->vtbl->setvalue(cm,rd,no,v,0,__PROC__))) goto unlock;
/*	if((er = rdd_childs(cm,rd,__PROC__))) return er; */
	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			RDD_ORDER* ro = rd->orders[i];
			ClipVar vv,*vp;
			if(ro->bforexpr.t.type!=UNDEF_t){
				if((er = rdd_calc(cm,rd->area,&ro->bforexpr,&vv,0))) goto unlock;
				vp = _clip_vptr(&vv);
				if(vp->t.type!=LOGICAL_t){
					er = rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,
						er_badforexpr);
					goto unlock;
				}
				if(!vp->l.val){
					_clip_destroy(cm,&vv);
					if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) goto unlock;
					continue;
				}
				_clip_destroy(cm,&vv);
			}
			if(!ro->custom){
				if((ro->bforexpr.t.type == UNDEF_t) && ro->simpexpr
					&& (ro->simpfno != no))
					continue;
				if((er = rdd_event(cm,EVENT_UPDATE,rd->area,0,NULL,NULL,__PROC__)))
					goto unlock;
				if(ro->simpexpr && ro->simpfno == no){
					if((er = ro->vtbl->addkey(cm,rd,ro,v,__PROC__)))
						goto unlock;
				} else {
					if((er = ro->vtbl->addkey(cm,rd,ro,NULL,__PROC__)))
						goto unlock;
				}
				if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) goto unlock;
			}
		}
	}
	if(rd->filter && rd->filter->rmap){
		int fok;

		if((er = rdd_calcfilter(cm,rd,&fok,__PROC__))) return er;
		if(fok)
			_rm_setbit(rd->filter->rmap,rd->filter->size,rd->recno);
		else
			_rm_clrbit(rd->filter->rmap,rd->filter->size,rd->recno);
	}
	return 0;
unlock:
	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			ro = rd->orders[i];
			if(!ro->custom){
				if(ro->simpexpr && (ro->simpfno != no))
					continue;
				ro->vtbl->_ulock(cm,ro,__PROC__);
			}
		}
	}
	return er;
}

int _rdd_calcfiltlist(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int er;

	if(rd->filter && rd->filter->optimize==2 && cm->optimizelevel>0){
		if(rd->curord==-1){
			if((er = rd->vtbl->calcfiltlist(cm,rd,__PROC__))) return er;
		} else {
			RDD_ORDER* ro = rd->orders[rd->curord];
			if(ro->vtbl->calcfiltlist){
				if((er = ro->vtbl->calcfiltlist(cm,rd,ro,__PROC__))) return er;
			}
		}
/*		if(rd->filter->rmap)
			free(rd->filter->rmap);
		rd->filter->rmap = NULL;*/
		if((er = rdd_gotop(cm,rd,__PROC__))) return er;
	}
	return 0;
}

int rdd_initrushmore(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER* fp,ClipVar* a,int test,const char* __PROC__){
	unsigned int lastrec;
	unsigned int bytes;
	int optimize = 0;
	char* str = strdup(fp->sfilter);
	int er = EG_UNSUPPORTED;
	RDD_PSEUDO* pseudo = NULL;
	int npseudo = 0;

	if(a){
		ClipVar *e,*alias,*name;
		long i[1],j[1];

		npseudo = a->a.count;
		pseudo = calloc(npseudo,sizeof(RDD_PSEUDO));
		for(i[0]=0;i[0]<npseudo;i[0]++){
			e = _clip_vptr(_clip_aref(cm,a,1,i));
			if(e->t.type == ARRAY_t && e->a.count == 2){
				j[0] = 0;
				alias = _clip_vptr(_clip_aref(cm,e,1,j));
				j[0] = 1;
				name = _clip_vptr(_clip_aref(cm,e,1,j));
				if(alias->t.type != CHARACTER_t || name->t.type != CHARACTER_t)
					goto err_pseudo;
				pseudo[i[0]].alias = alias->s.str.buf;
				pseudo[i[0]].name = name->s.str.buf;
			} else
				goto err_pseudo;
		}
	}

	if((er = rd->vtbl->lastrec(cm,rd,&lastrec,__PROC__))) goto err;

	bytes = (lastrec >> 5) + 1;

	if((er = rm_init(cm,rd,str,__PROC__))) goto err;
	if(fp->rmap)
		free(fp->rmap);
	fp->size = lastrec;

	rd->rmflen = 0;
	rd->rmfilter = malloc(1);
	if(!(fp->rmap = rm_expr(cm,rd,fp,bytes,&optimize,npseudo,pseudo,test,__PROC__))){
		er = 1;
		goto err;
	}
	free(fp->sfilter);
	fp->sfilter = rd->rmfilter;
	rd->rmfilter = NULL;

	fp->optimize = optimize;
	if(fp->optimize==0){
		free(fp->rmap);
		fp->rmap = NULL;
	}
	if((er = _rdd_calcfiltlist(cm,rd,__PROC__))) goto err;
	free(str);
	if(pseudo)
		free(pseudo);
	if(test && fp->rmap){
		free(fp->rmap);
		fp->rmap = NULL;
	}
	return 0;
err_pseudo:
	free(pseudo);
	er = rdd_err(cm,EG_ARG,0,__FILE__,__LINE__,__PROC__,"Bad argument");
err:
	free(str);
	return er;
}

int rdd_createuserfilter(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER** fpp,unsigned int size,const char* __PROC__){
	RDD_FILTER* fp = calloc(sizeof(RDD_FILTER),1);
	int bytes;
	int er;

	fp->rd = rd;
	if(size){
		bytes = ((size+1) >> 5) + 1;
		fp->size = size;
	} else {
		int lastrec;
		if((er = rdd_lastrec(cm,rd,&lastrec,__PROC__))) goto err;
		bytes = ((lastrec+1) >> 5) + 1;
		fp->size = lastrec;
	}
	fp->rmap = calloc(sizeof(unsigned int),bytes);
	fp->handle = _clip_store_c_item(cm,fp,_C_ITEM_TYPE_RYO,destroy_ryo);
	fp->custom = 1;
	*fpp = fp;
	return 0;
err:
	free(fp);
	return er;
}

int rdd_createfilter(ClipMachine* cm,RDD_DATA* rd,RDD_FILTER** fpp,ClipVar* _block,const char* str,ClipVar* remap,int lNoOptimize,const char* __PROC__){
	char expr[PATH_MAX];
	RDD_FILTER* fp = calloc(sizeof(RDD_FILTER),1);
	int er;

	*fpp = NULL;
	fp->fps = calloc(1,sizeof(RDD_FPS));
	fp->rd = rd;
	if(str){
		fp->sfilter = strdup(str);
	}
	if((cm->flags1 & OPTIMIZE_FLAG) && !lNoOptimize && str){
		er = rdd_initrushmore(cm,rd,fp,remap,0,__PROC__);
		_clip_destroy(cm,_block);
	} else if(str && remap && remap->t.type == ARRAY_t){
		er = rdd_initrushmore(cm,rd,fp,remap,1,__PROC__);
		_clip_destroy(cm,_block);
	}
	fp->nfps = 1;
	if((!_block || _block->t.type == UNDEF_t) && str){
		rdd_expandmacro(rd->area,_clip_parni(cm,1),fp->sfilter,expr);
		if((er = _clip_eval_macro(cm,expr,strlen(expr),&fp->fps->bfilter)))
			goto err;
	} else {
		_clip_clone(cm,&fp->fps->bfilter,_block);
	}
	fp->handle = _clip_store_c_item(cm,fp,_C_ITEM_TYPE_RYO,destroy_ryo);
	*fpp = fp;
	return 0;
err:
	free(fp);
	return er;
}

int rdd_setrelation(ClipMachine* cm,RDD_DATA* rd,RDD_DATA* child,ClipVar* block,
					const char* expr,int scoped,const char* __PROC__){
	RDD_RELATION* rel = (RDD_RELATION*)calloc(1,sizeof(RDD_RELATION));
	int r = _clip_parni(cm,1);
	int er;

	rel->scoped = scoped;
	rel->child = child;
	rel->parent = rd;
	if(!expr)
		expr = "";
	rel->expr = (char*)malloc(strlen(expr)+1);
	strcpy(rel->expr,expr);
	if(block){
		_clip_clone(cm,&rel->block,block);
	} else {
		if((rel->simpfno = _rdd_fieldno(rd,_clip_casehashword(expr,strlen(expr))))!=-1)
			rel->simpexpr = 1;
		if(!rel->simpexpr){
			char expexp[PATH_MAX];
			memset(expexp,0,sizeof(expexp));
			rdd_expandmacro(rd->area,r,expr,expexp);
			if((er = _clip_eval_macro(cm,expexp,strlen(expexp),&rel->block)))
				goto err;
		}
	}
	rd->rels_opened++;
	rd->relations = (RDD_RELATION**)realloc(rd->relations,
		rd->rels_opened*sizeof(RDD_RELATION*));
	rd->relations[rd->rels_opened-1] = rel;

	child->pars_opened++;
	child->parents = (RDD_RELATION**)realloc(child->parents,
		child->pars_opened*sizeof(RDD_RELATION*));
	child->parents[child->pars_opened-1] = rel;
	if((er = rdd_childs(cm,rd,__PROC__))) return er;
	return 0;
err:
	free(rel->expr);
	free(rel);
	return er;
}

int rdd_delete(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int i,r,er;
	RDD_ORDER* ro;

	if(rd->pending_child_parent)
		if((er = rdd_child_duty(cm,rd,__PROC__))) return er;

	if((er = rdd_event(cm,EVENT_DELETE,rd->area,0,NULL,&r,__PROC__))) return er;
	if(!r)
		return 0;
	if(rd->eof)
		return 0;

	if((er = rd->vtbl->rlocked(cm,rd,rd->recno,&r,__PROC__))) return er;
	if(!r && !rd->flocked)
		return rdd_err(cm,EG_UNLOCKED,0,__FILE__,__LINE__,__PROC__,er_notpermitted);

	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			ro = rd->orders[i];
			if(!ro->custom){
				if((ro->bforexpr.t.type == UNDEF_t) && ro->simpexpr)
				if((er = ro->vtbl->_wlock(cm,ro,__PROC__))) goto unlock;
				if((er = ro->vtbl->delkey(cm,rd,ro,__PROC__))) goto unlock;
				ro->index->updated = 1;
			}
		}
		rd->eof = 0;
	}
	if((er = rd->vtbl->delete(cm,rd,__PROC__))) return er;
	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			RDD_ORDER* ro = rd->orders[i];
			ClipVar vv,*vp;
			if(ro->bforexpr.t.type!=UNDEF_t){
				if((er = rdd_calc(cm,rd->area,&ro->bforexpr,&vv,0))) goto unlock;
				vp = _clip_vptr(&vv);
				if(vp->t.type!=LOGICAL_t){
					er = rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,
						er_badforexpr);
					goto unlock;
				}
				if(!vp->l.val){
					_clip_destroy(cm,&vv);
					if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) goto unlock;
					continue;
				}
				_clip_destroy(cm,&vv);
			}
			if(!ro->custom){
				if((er = ro->vtbl->addkey(cm,rd,ro,NULL,__PROC__)))
						goto unlock;
				if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) goto unlock;
			}
		}
	}
	if(rd->filter && rd->filter->rmap){
		int fok;

		if((er = rdd_calcfilter(cm,rd,&fok,__PROC__))) return er;
		if(fok)
			_rm_setbit(rd->filter->rmap,rd->filter->size,rd->recno);
		else
			_rm_clrbit(rd->filter->rmap,rd->filter->size,rd->recno);
	}
	return 0;
unlock:
	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			ro = rd->orders[i];
			if(!ro->custom){
				ro->vtbl->_ulock(cm,ro,__PROC__);
			}
		}
	}
	return er;
}

int rdd_recall(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int i,r,er;
	RDD_ORDER* ro;

	if(rd->pending_child_parent)
		if((er = rdd_child_duty(cm,rd,__PROC__))) return er;

	if((er = rdd_event(cm,EVENT_RECALL,rd->area,0,NULL,&r,__PROC__))) return er;
	if(!r)
		return 0;
	if(rd->eof)
		return 0;

	if((er = rd->vtbl->rlocked(cm,rd,rd->recno,&r,__PROC__))) return er;
	if(!r && !rd->flocked)
		return rdd_err(cm,EG_UNLOCKED,0,__FILE__,__LINE__,__PROC__,er_notpermitted);

	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			ro = rd->orders[i];
			if(!ro->custom){
				if((ro->bforexpr.t.type == UNDEF_t) && ro->simpexpr)
				if((er = ro->vtbl->_wlock(cm,ro,__PROC__))) goto unlock;
				if((er = ro->vtbl->delkey(cm,rd,ro,__PROC__))) goto unlock;
				ro->index->updated = 1;
			}
		}
		rd->eof = 0;
	}
	if((er = rd->vtbl->recall(cm,rd,__PROC__))) return er;
	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			RDD_ORDER* ro = rd->orders[i];
			ClipVar vv,*vp;
			if(ro->bforexpr.t.type!=UNDEF_t){
				if((er = rdd_calc(cm,rd->area,&ro->bforexpr,&vv,0))) goto unlock;
				vp = _clip_vptr(&vv);
				if(vp->t.type!=LOGICAL_t){
					er = rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,
						er_badforexpr);
					goto unlock;
				}
				if(!vp->l.val){
					_clip_destroy(cm,&vv);
					if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) goto unlock;
					continue;
				}
				_clip_destroy(cm,&vv);
			}
			if(!ro->custom){
				if((er = ro->vtbl->addkey(cm,rd,ro,NULL,__PROC__)))
						goto unlock;
				if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) goto unlock;
			}
		}
	}
	if(rd->filter && rd->filter->rmap){
		int fok;

		if((er = rdd_calcfilter(cm,rd,&fok,__PROC__))) return er;
		if(fok)
			_rm_setbit(rd->filter->rmap,rd->filter->size,rd->recno);
		else
			_rm_clrbit(rd->filter->rmap,rd->filter->size,rd->recno);
	}
	return 0;
unlock:
	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			ro = rd->orders[i];
			if(!ro->custom){
				ro->vtbl->_ulock(cm,ro,__PROC__);
			}
		}
	}
	return er;
}

int rdd_deleted(ClipMachine* cm,RDD_DATA* rd,int* deleted,const char* __PROC__){
	int eof,er;

	if((er = rdd_eof(cm,rd,&eof,__PROC__))) return er;
	if(eof)
		*deleted = 0;
	else
		if((er = rd->vtbl->deleted(cm,rd,deleted,__PROC__))) return er;
	return 0;
}

int rdd_clearindex(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int i,er;
	int structural = -1;

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	for(i=0;i<rd->idxs_opened;i++){
		if(rd->indices[i]->structural){
			structural = i;
		} else {
#ifdef HAVE_MMAN_H
			if((int)(rd->indices[i]->file.md)!=-1){
				if(munmap(rd->indices[i]->file.md,rd->indices[i]->file.mapsize)==-1)
					return rdd_err(cm,EG_CLOSE,errno,__FILE__,__LINE__,__PROC__,rd->indices[i]->path);
			}
#endif
			if(_clip_close(cm,rd->indices[i]->file.filehash,rd->indices[i]->file.fd)==-1)
				return rdd_err(cm,EG_CLOSE,errno,__FILE__,__LINE__,__PROC__,rd->indices[i]->path);
			if((er = rd->indices[i]->vtbl->close(cm,rd,rd->indices[i],__PROC__)))
				return er;
		}
	}
	if(structural == -1){
		if(rd->indices)
			free(rd->indices);
		rd->indices = NULL;
		if(rd->orders)
			free(rd->orders);
		rd->orders = NULL;
		rd->idxs_opened = 0;
		rd->ords_opened = 0;
		rd->newrec = 0;
	} else {
		rd->indices[0] = rd->indices[structural];
		rd->indices = (RDD_INDEX**)realloc(rd->indices,sizeof(RDD_INDEX*));
		rd->idxs_opened = 1;
		rd->ords_opened = rd->indices[0]->norders;
		rd->orders = (RDD_ORDER**)realloc(rd->orders,rd->ords_opened*sizeof(RDD_ORDER*));
		for(i=0;i<rd->ords_opened;i++){
			rd->orders[i] = rd->indices[0]->orders[i];
			rd->orders[i]->orderno = i;
		}
	}
	rd->curord = -1;
	return 0;
}

int rdd_destroyfilter(ClipMachine* cm,RDD_FILTER* fp,const char* __PROC__){
	int i;
	for(i=0;i<fp->nfps;i++)
		_clip_destroy(cm,&fp->fps[i].bfilter);
	_clip_destroy_c_item(cm,fp->handle,_C_ITEM_TYPE_RYO);
	return 0;
}

int rdd_clearfilter(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int er;
	if(rd->filter){
		if(rd->filter->active){
			if((er = rdd_destroyfilter(cm,rd->filter,__PROC__))) return er;
		}
		rd->filter = NULL;
	}
	return 0;
}

static int _rdd_clearparent(ClipMachine* cm,RDD_DATA* rd,RDD_DATA* parent){
	int i;
	for(i=0;i<rd->pars_opened;i++){
		if(rd->parents[i]->parent == parent){
			memcpy(rd->parents+i,rd->parents+i+1,(rd->pars_opened-1)*sizeof(void*));
			rd->pars_opened--;
			rd->parents = realloc(rd->parents,rd->pars_opened*sizeof(void*));
		}
	}
	return 0;
}

int rdd_clearrelation(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int i;
	for(i=0;i<rd->rels_opened;i++){
		rd->relations[i]->child->pending_child_parent = NULL;
		_rdd_clearparent(cm,rd->relations[i]->child,rd);
		if(rd->relations[i]->expr)
			free(rd->relations[i]->expr);
		_clip_destroy(cm,&rd->relations[i]->block);
		free(rd->relations[i]);
	}
	free(rd->relations);
	rd->relations = NULL;
	rd->rels_opened = 0;
	return 0;
}

int rdd_rlock(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int* r,const char* __PROC__){
	rd->valid = 0;
	if(rec<=0)
		return 0;
	return rd->vtbl->rlock(cm,rd,rec,r,__PROC__);
}

int rdd_flock(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int r,er;

	if((er = rd->vtbl->flock(cm,rd,&r,__PROC__))) return er;
	_clip_retl(cm,r);
	return 0;
}

int rdd_ulock(ClipMachine* cm,RDD_DATA* rd,unsigned int rec,int flock,const char* __PROC__){
/*
	int i;
#ifdef HAVE_MMAN_H
	if(rd->shared && (int)rd->file.md!=-1){
		if(msync(rd->file.md,rd->file.mapsize,MS_ASYNC)==-1)
			return rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
		if(rd->memo){
			if(msync(rd->memo->file.md,rd->memo->file.mapsize,MS_ASYNC)==-1)
				return rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
		}
		for(i=0;i<rd->idxs_opened;i++){
			if(msync(rd->indices[i]->file.md,rd->indices[i]->file.mapsize,MS_ASYNC)==-1)
				return rdd_err(cm,EG_LOCK,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
		}
	}
#endif
*/
	if(rec<0)
		return 0;
	return rd->vtbl->ulock(cm,rd,rec,flock,__PROC__);
}

int rdd_commit(ClipMachine* cm,RDD_DATA* rd,const char* __PROC__){
	int er;
#ifdef HAVE_MMAN_H
	int i;
#endif

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if(rd->changed){
		if((er = rd->vtbl->setrecord(cm,rd,__PROC__))) return er;
		rd->changed = 0;
	}
#ifdef HAVE_MMAN_H
	if(rd->shared && (int)rd->file.md!=-1){
		if(msync(rd->file.md,rd->file.mapsize,MS_ASYNC)==-1)
			return rdd_err(cm,EG_WRITE,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
		if(rd->memo){
			if(msync(rd->memo->file.md,rd->memo->file.mapsize,MS_ASYNC)==-1)
				return rdd_err(cm,EG_WRITE,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
		}
		for(i=0;i<rd->idxs_opened;i++){
			if(msync(rd->indices[i]->file.md,rd->indices[i]->file.mapsize,MS_ASYNC))
				return rdd_err(cm,EG_WRITE,errno,__FILE__,__LINE__,__PROC__,er_ioerror);
		}
	}
#endif
	return 0;
}

int rdd_dbread(ClipMachine* cm,RDD_DATA* rd,ClipVar* ap,const char* __PROC__){
	ClipVar vv;
	int i,er;

	CLEAR_CLIPVAR(&vv);

	_clip_map(cm,ap);
	for(i=0;i<rd->nfields;i++){
		if((er = rdd_takevalue(cm,rd,i,&vv,__PROC__))) return er;
		_clip_madd(cm,ap,_clip_casehashword(rd->fields[i].name,strlen(rd->fields[i].name)),&vv);
		_clip_destroy(cm,&vv);
	}
	return 0;
}

int rdd_dbwrite(ClipMachine* cm,RDD_DATA* rd,ClipVar* ap,const char* __PROC__){
	RDD_ORDER* ro;
	ClipVar* vp;
	ClipVar old;
	int eof;
	int i,j,r,er;
	int* fs = NULL;

	if(rd->pending_child_parent)
		if((er = rdd_child_duty(cm,rd,__PROC__))) return er;

	if((er = rd->vtbl->rlocked(cm,rd,rd->recno,&r,__PROC__))) return er;
	if(!r && !rd->flocked)
		return rdd_err(cm,EG_UNLOCKED,0,__FILE__,__LINE__,__PROC__,er_notpermitted);

	if((er = rdd_eof(cm,rd,&eof,__PROC__))) return er;
	if(eof)
		return 0;

	fs = calloc(rd->nfields,sizeof(int));
	for(i=0;i<rd->nfields;i++){
		vp = _clip_vptr(_clip_mget(cm,ap,_clip_casehashword(rd->fields[i].name,strlen(rd->fields[i].name))));
		if(vp){
			if((er = rd->vtbl->getvalue(cm,rd,i,&old,__PROC__))) goto err;
			_clip_cmp(cm,&old,vp,&(fs[i]),1);
			_clip_destroy(cm,&old);
		}
	}
	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			ro = rd->orders[i];
			if(!ro->custom){
				if(ro->simpexpr){
					for(j=0;j<rd->nfields;j++)
						if(fs[j] && ro->simpfno == j)
							break;
					if(j==rd->nfields)
						continue;
				}
				if((er = rdd_event(cm,EVENT_UPDATE,rd->area,0,NULL,NULL,__PROC__)))
					goto unlock;
				if((er = ro->vtbl->_wlock(cm,ro,__PROC__))) goto unlock;
				if((er = ro->vtbl->delkey(cm,rd,ro,__PROC__)))
					goto unlock;
			}
		}
	}
	for(i=0;i<rd->nfields;i++){
		if(fs[i]){
			vp = _clip_vptr(_clip_mget(cm,ap,_clip_casehashword(rd->fields[i].name,strlen(rd->fields[i].name))));
			if((er = rd->vtbl->setvalue(cm,rd,i,vp,0,__PROC__))) goto unlock;
		}
	}
	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			ro = rd->orders[i];
			if(!ro->custom){
				if(ro->simpexpr){
					for(j=0;j<rd->nfields;j++)
						if(fs[j] && ro->simpfno == j)
							break;
					if(j==rd->nfields)
						continue;
				}
				if((er = rdd_event(cm,EVENT_UPDATE,rd->area,0,NULL,NULL,__PROC__)))
					goto unlock;
				if((er = ro->vtbl->addkey(cm,rd,ro,NULL,__PROC__)))
					goto unlock;
				if((er = ro->vtbl->_ulock(cm,ro,__PROC__))) goto unlock;
			}
		}
	}
	free(fs); fs = NULL;

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	if(rd->filter && rd->filter->rmap){
		int fok;

		if((er = rdd_calcfilter(cm,rd,&fok,__PROC__))) return er;
		if(fok)
			_rm_setbit(rd->filter->rmap,rd->filter->size,rd->recno);
		else
			_rm_clrbit(rd->filter->rmap,rd->filter->size,rd->recno);
	}
	return 0;
unlock:
	if(!rd->newrec){
		for(i=0;i<rd->ords_opened;i++){
			ro = rd->orders[i];
			ro->vtbl->_ulock(cm,ro,__PROC__);
		}
	}
err:
	if(fs)
		free(fs);
	return er;
}

int rdd_scopetop(ClipMachine* cm,RDD_DATA* rd,ClipVar* v,const char* __PROC__){
	RDD_ORDER* ro;
	int er;

	if(rd->curord==-1)
		return 0;

	ro = rd->orders[rd->curord];
	if(ro->scopetop){
		free(ro->scopetop);
		ro->scopetop = NULL;
		_clip_destroy(cm,&ro->scopetopvar);
	}
	if(v && v->t.type!=UNDEF_t){
		ro->scopetop = malloc(ro->keysize);
		if((er = ro->vtbl->formatkey(cm,ro,v,ro->scopetop,__PROC__))) return er;
		_clip_clone(cm,&ro->scopetopvar,v);
		if(v->t.type == CHARACTER_t)
			ro->stoplen = min(v->s.str.len,ro->keysize);
		else
			ro->stoplen = ro->keysize;
	}
	return 0;
}

int rdd_scopebottom(ClipMachine* cm,RDD_DATA* rd,ClipVar* v,const char* __PROC__){
	RDD_ORDER* ro;
	int er;

	if(rd->curord==-1)
		return 0;

	ro = rd->orders[rd->curord];
	if(ro->scopebottom){
		free(ro->scopebottom);
		ro->scopebottom = NULL;
		_clip_destroy(cm,&ro->scopebottomvar);
	}
	if(v && v->t.type!=UNDEF_t){
		ro->scopebottom = malloc(ro->keysize);
		if((er = ro->vtbl->formatkey(cm,ro,v,ro->scopebottom,__PROC__))) return er;
		_clip_clone(cm,&ro->scopebottomvar,v);
		if(v->t.type == CHARACTER_t)
			ro->sbotlen = min(v->s.str.len,ro->keysize);
		else
			ro->sbotlen = ro->keysize;
	}
	return 0;
}

int rdd_keyadd(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,ClipVar* v,const char* __PROC__){
	if(!ro->custom)
		return rdd_err(cm,EG_UNSUPPORTED,0,__FILE__,__LINE__,__PROC__,
			"Trying to add key to automatic (non-custom) order");
	return ro->vtbl->addkey(cm,rd,ro,NULL,__PROC__);
}

int rdd_keydel(ClipMachine* cm,RDD_DATA* rd,RDD_ORDER* ro,const char* __PROC__){
	if(!ro->custom)
		return rdd_err(cm,EG_UNSUPPORTED,0,__FILE__,__LINE__,__PROC__,
			"Trying to delete key from automatic (non-custom) order");
	return ro->vtbl->delkey(cm,rd,ro,__PROC__);
}

int rdd_keyvalue(ClipMachine* cm,RDD_DATA* rd,ClipVar* v,const char* __PROC__){
	if(rd->curord==-1)
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);
	return rd->orders[rd->curord]->vtbl->keyvalue(cm,rd,rd->orders[rd->curord],
		v,__PROC__);
}

int rdd_locate(ClipMachine* cm,RDD_DATA* rd,char* cfor,ClipVar* fexpr,ClipVar* wexpr,ClipVar* vnext,ClipVar* vrec,ClipVar* vrest,int* found,const char* __PROC__){
	RDD_FILTER* old = NULL;
	int next = -1, rec = 0, rest = 0, r = 0, er;

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;
	*found = 0;
	if(!fexpr || (fexpr->t.type != CCODE_t && fexpr->t.type != PCODE_t))
		fexpr = 0;

	if(!wexpr || (wexpr->t.type != CCODE_t && wexpr->t.type != PCODE_t))
		wexpr = 0;

	if(vnext && vnext->t.type == NUMERIC_t){
		next = _clip_double(vnext);
		next = next ? next - 1 : 0;
	}
	if(vrec && vrec->t.type == NUMERIC_t){
		rec = _clip_double(vrec);
	}
	if(vrest && vrest->t.type == LOGICAL_t)
		rest = vrest->l.val;
	else if(fexpr)
		rest = 0;
	else
		rest = 1;

	if(!fexpr && !wexpr && !rd->locate_filter && !rd->locate_wpar)
		return 0;

	if(!wexpr){
		if(!rest){
			if(rec)
				er = rdd_goto(cm,rd,rec,__PROC__);
			else
				er = rdd_gotop(cm,rd,__PROC__);
			if(er)
				return er;
			rd->locate_next = next;
		}
	}

	if(fexpr){
		ClipVar *dest = (ClipVar*)calloc(1,sizeof(ClipVar));
		if(rd->locate_wpar)
			_clip_destroy(cm,rd->locate_wpar);
		if(rd->locate_filter)
			if((er = rdd_destroyfilter(cm,rd->locate_filter,__PROC__)))
				return er;
		if((er = rdd_createfilter(cm,rd,&rd->locate_filter,fexpr,cfor,NULL,0,__PROC__)))
			return er;
		if(rd->filter)
			if((er = rm_intersect(cm,rd->locate_filter,rd->filter,__PROC__)))
				return er;
		if(wexpr){
			_clip_clone(cm,dest,wexpr);
			rd->locate_wpar = dest;
		} else {
			rd->locate_wpar = NULL;
		}
		rd->locate_next = next;
	}

	if(!rd->locate_wpar){
		if(rd->filter){
			old = rd->filter;
			old->active = 0;
		}
		rd->filter = rd->locate_filter;
		rd->filter->active = 1;
	}

	while(1){
		int wcond = 1;

		if((er = rdd_eof(cm,rd,&r,__PROC__)))
			return er;

		if(r || !rd->locate_next){
			/* wa->locate_next = -1; */
			break;
		}

		if(rd->locate_wpar){
			ClipVar data;

			_clip_eval(cm,rd->locate_wpar,0,0,&data);

			if(data.t.type != LOGICAL_t)
				break;
			else
				wcond = data.l.val;

			_clip_destroy(cm,&data);
		}

		if(!wcond)
			break;

		if(rd->locate_wpar){
			ClipVar data;

			_clip_eval(cm,&rd->locate_filter->fps->bfilter,0,0,&data);

			if(data.t.type != LOGICAL_t)
				break;
			else
				*found = data.l.val;

			_clip_destroy(cm,&data);
		} else {
			if((er = rdd_calcfilter(cm,rd,found,__PROC__))) return er;
		}

		if(*found)
			break;

		if((er = rdd_skip(cm,rd,1,__PROC__)))
			return er;

		if(rd->locate_next > 0)
			rd->locate_next--;
	}

	if(!rd->locate_wpar){
		if(rd->locate_filter)
			rd->locate_filter->active = 0;
		rd->filter = NULL;
		if(old){
			rd->filter = old;
			rd->filter->active = 1;
		}
	}
	return 0;
}

int rdd_continue(ClipMachine* cm,RDD_DATA* rd,int* found,const char* __PROC__){
	RDD_FILTER* old = NULL;
	int er;

	if(!rd->locate_filter)
		return 0;
	if(rd->filter){
		old = rd->filter;
		old->active = 0;
	}
	rd->filter = rd->locate_filter;
	rd->filter->active = 1;

	if((er = rdd_skip(cm,rd,1,__PROC__)))
		return er;

	if(rd->locate_filter)
		rd->locate_filter->active = 0;
	rd->filter = NULL;
	if(old){
		rd->filter = old;
		rd->filter->active = 1;
	}

	return rdd_locate(cm,rd,NULL,NULL,NULL,NULL,NULL,NULL,found,__PROC__);
}

void destroy_rdd_data(void* data){
	RDD_DATA* rd = (RDD_DATA*)data;
	if(rd){
		if(rd->name)
			free(rd->name);
		if(rd->path)
			free(rd->path);
		if(rd->fields)
			free(rd->fields);
		if(rd->indices)
			free(rd->indices);
		if(rd->orders)
			free(rd->orders);
		if(rd->word)
			free(rd->word);
		if(rd->yylval)
			free(rd->yylval);
		if(rd->locks)
			free(rd->locks);
		if(rd->os.cForCondition)
			free(rd->os.cForCondition);
		if(rd->data)
			free(rd->data);
		if(rd->record)
			free(rd->record);
		delete_HashTable(rd->hashes);
		free(rd);
	}
}

void destroy_rdd_index(void* index){
	RDD_INDEX* ri = (RDD_INDEX*)index;
	if(ri){
		if(ri->name)
			free(ri->name);
		if(ri->path)
			free(ri->path);
		if(ri->orders)
			free(ri->orders);
		free(ri);
	}
}

void destroy_rdd_memo(RDD_MEMO* rm){
	if(rm){
		if(rm->name)
			free(rm->name);
		if(rm->path)
			free(rm->path);
		free(rm);
	}
}

void destroy_rdd_order(ClipMachine* cm,RDD_ORDER* ro){
	if(ro){
		if(ro->name)
			free(ro->name);
		if(ro->expr)
			free(ro->expr);
		if(ro->scopetop)
			free(ro->scopetop);
		if(ro->scopebottom)
			free(ro->scopebottom);
		if(ro->cforexpr)
			free(ro->cforexpr);
		if(ro->key)
			free(ro->key);
		if(ro->curpage)
			free(ro->curpage);
		_clip_destroy(cm,&ro->block);
		_clip_destroy(cm,&ro->scopetopvar);
		_clip_destroy(cm,&ro->scopebottomvar);
		_clip_destroy(cm,&ro->bforexpr);
		free(ro);
	}
}

void destroy_rdd_i_order(void* order){
	RDD_ORDER* ro = (RDD_ORDER*)order;
	if(ro)
		free(ro);
}

void destroy_ryo(void* data){
	RDD_FILTER* fp = (RDD_FILTER*)data;

	if(fp){
		if(fp->sfilter)
			free(fp->sfilter);
		if(fp->rmap)
			free(fp->rmap);
		if(fp->fps)
			free(fp->fps);
		if(fp->list)
			free(fp->list);
		free(fp);
	}
}

inline unsigned int _rdd_uint(unsigned char* s){
	unsigned int r;

	r = *(s+3);
	r = r << 8;
	r += *(s+2);
	r = r << 8;
	r += *(s+1);
	r = r << 8;
	r += *s;
	return r;
}

inline unsigned short int _rdd_ushort(unsigned char* s){
	unsigned short int r;

	r = *(s+1);
	r = r << 8;
	r += *s;
	return r;
}

inline void _rdd_put_uint(unsigned char s[],unsigned int v){
	s[0] = v & 0x000000ff;
	v = v >> 8;
	s[1] = v & 0x000000ff;
	v = v >> 8;
	s[2] = v & 0x000000ff;
	v = v >> 8;
	s[3] = v & 0x000000ff;
}

inline void _rdd_put_ushort(unsigned char s[],unsigned short int v){
	s[0] = v & 0x00ff;
	s[1] = (v & 0xff00) >> 8;
}

inline unsigned int _rdd_backuint(unsigned char* s){
	unsigned int r;

	r = *s;
	r = r << 8;
	r += *(s+1);
	r = r << 8;
	r += *(s+2);
	r = r << 8;
	r += *(s+3);
	return r;
}

inline unsigned short int _rdd_backushort(unsigned char* s){
	unsigned short int r;

	r = *s;
	r = r << 8;
	r += *(s+1);
	return r;
}

inline void _rdd_put_backuint(unsigned char s[],unsigned int v){
	s[3] = v & 0x000000ff;
	v = v >> 8;
	s[2] = v & 0x000000ff;
	v = v >> 8;
	s[1] = v & 0x000000ff;
	v = v >> 8;
	s[0] = v & 0x000000ff;
}

inline void _rdd_put_backushort(unsigned char s[],unsigned short int v){
	s[1] = v & 0x00ff;
	s[0] = (v & 0xff00) >> 8;
}

static DbfLocale koi_locale =
{
/*unsigned char _koi_cmptbl[] = */
	{
		0xc4, 0xb3, 0xda, 0xbf, 0xc0, 0xd9, 0xc3, 0xb4,
		0xc2, 0xc1, 0xc5, 0xdf, 0xdc, 0xdb, 0xdd, 0xde,
		0xb0, 0xb1, 0xb2, 0xf4, 0xfe, 0xf9, 0xfb, 0xf7,
		0xf3, 0xf2, 0xff, 0xf5, 0xf8, 0xfd, 0xfa, 0xf6,
		0xcd, 0xba, 0xd5, 0xf1, 0xd6, 0xc9, 0xb8, 0xb7,
		0xbb, 0xd4, 0xd3, 0xc8, 0xbe, 0xbd, 0xbc, 0xc6,
		0xc7, 0xcc, 0xb5, 0xf0, 0xb6, 0xb9, 0xd1, 0xd2,
		0xcb, 0xcf, 0xd0, 0xca, 0xd8, 0xd7, 0xce, 0xfc,
		0xee, 0xa0, 0xa1, 0xe6, 0xa4, 0xa5, 0xe4, 0xa3,
		0xe5, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae,
		0xaf, 0xef, 0xe0, 0xe1, 0xe2, 0xe3, 0xa6, 0xa2,
		0xec, 0xeb, 0xa7, 0xe8, 0xed, 0xe9, 0xe7, 0xea,
		0x9e, 0x80, 0x81, 0x96, 0x84, 0x85, 0x94, 0x83,
		0x95, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e,
		0x8f, 0x9f, 0x90, 0x91, 0x92, 0x93, 0x86, 0x82,
		0x9c, 0x9b, 0x87, 0x98, 0x9d, 0x99, 0x97, 0x9a
	},

/*unsigned char _koi_uptbl[] = */
	{
		0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
		0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
		0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
		0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
		0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
		0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
		0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7,
		0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf,
		0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7,
		0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,
		0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7,
		0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff,
		0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7,
		0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,
		0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7,
		0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff,
	},

/*unsigned char _koi_lowtbl[] = */
	{
		0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
		0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
		0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
		0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
		0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
		0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
		0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7,
		0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf,
		0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
		0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
		0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,
		0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf,
		0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
		0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
		0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,
		0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf,
	},
	{
		0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
		0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
		0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
		0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
		0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
		0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
		0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7,
		0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf,
		0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
		0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
		0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,
		0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf,
		0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7,
		0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,
		0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7,
		0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff,
	},
	{
		0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
		0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
		0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
		0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
		0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
		0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
		0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7,
		0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf,
		0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
		0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
		0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,
		0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf,
		0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7,
		0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,
		0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7,
		0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff,
	}
};

typedef struct
{
	char *name;
	DbfLocale *locale;
}
LocData;

static int
cmp_locale(void *p1, void *p2)
{
	return strcmp(((LocData *) p1)->name, ((LocData *) p2)->name);
}

DbfLocale *
dbf_get_locale(ClipMachine * mp)
{
#if 1
	char *dbfcs;
	DbfLocale *dbf_locale;
	static Coll locales =
	{0, 0, 0, 0, 0, 0};
	LocData ld, *lp;
	int ind;
	char *hostcs;
	cons_CharsetEntry *cs1 = 0, *cs2 = 0;
	int len1 = 0, len2 = 0;
	unsigned char *buf;

	dbfcs = (char *) _clip_fetch_item(mp, _clip_hashstr("DBF_CHARSET"));
	if (!dbfcs)
	{
		_clip_logg(2, "no item DBF_CHARSET, revert to KOI charset");
		return &koi_locale;
	}

	if (!locales.compare)
		init_Coll(&locales, 0, cmp_locale);

	ld.name = dbfcs;
	if (search_Coll(&locales, &ld, &ind))
	{
		lp = (LocData *) locales.items[ind];
		return lp->locale;
	}

	hostcs = _clip_getenv("CLIP_HOSTCS");
	if (!hostcs)
	{
		char *s;

		s = _clip_getenv("LC_ALL");
		if (s && *s)
		{
			hostcs = strrchr(s, '.');
			if (hostcs)
				hostcs++;
			else if (strcmp(s, "C") && strcmp(s, "POSIX"))
				hostcs = s;
		}
	}
	if (!hostcs)
		hostcs = _clip_getenv("CLIP_LANG");
				if ( hostcs == NULL )
		hostcs = _clip_getenv("LANG");

	if (!hostcs)
	{
		_clip_logg(0, "dbf: cannot determine host charset, revert to koi_locale");
		return &koi_locale;
	}

	_clip_logg(2, "load host charset '%s'", hostcs);
	if (load_charset_name(hostcs, &cs1, &len1))
	{
		_clip_logg(0, "dbf: cannot load charset '%s': %s, revert to koi_locale",
			   hostcs, strerror(errno));
		return &koi_locale;
	}

	_clip_logg(2, "load dbf charset '%s'", dbfcs);
	if (load_charset_name(dbfcs, &cs2, &len2))
	{
		_clip_logg(0, "dbf: cannot load charset '%s': %s, revert to koi_locale",
			   dbfcs, strerror(errno));
		return &koi_locale;
	}

	buf = (char *) calloc(256, 3);

	make_translation(cs1, len1, cs2, len2, buf);
	make_translation(cs2, len2, cs1, len1, buf + 256);

	free(cs1);
	free(cs2);

	dbf_locale = (DbfLocale *) calloc(1, sizeof(DbfLocale));
	lp = (LocData *) calloc(1, sizeof(LocData));
	lp->locale = dbf_locale;
	lp->name = strdup(dbfcs);

	memcpy(dbf_locale->read, buf + 256 + 128, 128);
	memcpy(dbf_locale->write, buf + 128, 128);

#if 1
	memcpy(dbf_locale->cmp, _clip_cmptbl + 128, 128);
	memcpy(dbf_locale->upper, _clip_uptbl + 128, 128);
	memcpy(dbf_locale->lower, _clip_lowtbl + 128, 128);
#else
	load_charset_tables(dbfcs, buf, buf+256, buf+512, 0, 0);
	memcpy(dbf_locale->cmp, buf + 128, 128);
	memcpy(dbf_locale->upper, buf + 256 + 128, 128);
	memcpy(dbf_locale->lower, buf + 512 + 128, 128);
#endif

	free(buf);
	insert_Coll(&locales, lp);
	return dbf_locale;

#else
	char *s;
	DbfLocale *dbf_locale = &koi_locale;

	s
		= (char *) _clip_fetch_item(mp, _clip_hashstr("DBF_CHARSET"));
	if (s && (!strcasecmp(s, "alt") || !strcasecmp(s, "866")))
		dbf_locale = &alt_locale;
	if (s && (!strcasecmp(s, "win") || !strcasecmp(s, "1251")))
		dbf_locale = &win_locale;
	if (s && (!strcasecmp(s, "main") || !strcasecmp(s, "459")))
		dbf_locale = &main_locale;

	return dbf_locale;
#endif
}

int rdd_ii_create(ClipMachine* cm,const char* driver,const char* name,const char* __PROC__){
	RDD_INDEX* ri = NULL;
	int er = EG_UNSUPPORTED;

	ri = (RDD_INDEX*)calloc(1,sizeof(RDD_INDEX));

	memset(ri,0,sizeof(RDD_INDEX));
	if(!(ri->vtbl = rdd_indexdriver(cm,driver,__PROC__))) goto err;

	if((er = _rdd_parsepath(cm,name,ri->vtbl->suff,&ri->path,&ri->name,EG_CREATE,__PROC__)))
		goto err;

	ri->file.filehash = _clip_hashstr(ri->path);

	ri->file.fd = _clip_creat(cm,ri->path,O_RDWR,cm->fileCreateMode,1);
	if(ri->file.fd == -1) goto err_create;
	ri->file.mapsize = 1024;
	if(lseek(ri->file.fd,ri->file.mapsize-1,SEEK_SET)==-1) goto err_create;
	if(write(ri->file.fd,"",1)==-1) goto err_create;
	ri->file.md = (caddr_t)-1;
#ifdef HAVE_MMAN_H
	if(cm->flags1 & MAP_FILE_FLAG)
		ri->file.md = (caddr_t)mmap(0,ri->file.mapsize,
			PROT_READ|PROT_WRITE,MAP_SHARED,ri->file.fd,0);
#endif
	if((er = ri->vtbl->ii_create(cm,ri,__PROC__))) goto err;

	_clip_retni(cm,_clip_store_c_item(cm,ri,_C_ITEM_TYPE_I_INDEX,destroy_rdd_index));
	return 0;
err_create:
	er = rdd_err(cm,EG_CREATE,errno,__FILE__,__LINE__,__PROC__,ri->path);
err:
	if(ri && ri->name)
		free(ri->name);
	if(ri && ri->path)
		free(ri->path);
#ifdef HAVE_MMAN_H
	if(ri && ri->file.md != (char*)-1)
		munmap(ri->file.md,ri->file.mapsize);
#endif
	if(ri && ri->file.fd != -1)
		_clip_close(cm,ri->file.filehash,ri->file.fd);
	if(ri)
		free(ri);
	return er;
}

int rdd_ii_createtag(ClipMachine* cm,int h,const char* tag,const char* expr,const char* __PROC__){
	RDD_INDEX* ri = (RDD_INDEX*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_INDEX);
	RDD_ORDER* ro;
	int er;

	CHECKII(ri);

	if((er = ri->vtbl->ii_createtag(cm,ri,tag,expr,&ro,__PROC__))) return er;

	ro->c_item = _clip_store_c_item(cm,ro,_C_ITEM_TYPE_I_ORDER,destroy_rdd_i_order);
	_clip_retni(cm,ro->c_item);
	return 0;
}

int rdd_ii_open(ClipMachine* cm,const char* driver,const char* name,const char* __PROC__){
	RDD_INDEX* ri = NULL;
	struct stat st;
	int er = EG_UNSUPPORTED;

	ri = (RDD_INDEX*)calloc(1,sizeof(RDD_INDEX));
	memset(ri,0,sizeof(RDD_INDEX));
	if(!(ri->vtbl = rdd_indexdriver(cm,driver,__PROC__))) goto err;

	if((er = _rdd_parsepath(cm,name,ri->vtbl->suff,&ri->path,&ri->name,EG_CREATE,__PROC__)))
		goto err;

	ri->file.filehash = _clip_hashstr(ri->path);

	if((er = rdd_open(cm,ri->path,0,0,&ri->file.fd,__PROC__)))
		goto err;

	if(fstat(ri->file.fd,&st)==-1) goto err_open;
	ri->file.mapsize = st.st_size;
	ri->file.md = (caddr_t)-1;
#ifdef HAVE_MMAN_H
	if(cm->flags1 & MAP_FILE_FLAG)
		ri->file.md = (caddr_t)mmap(0,ri->file.mapsize,
			PROT_READ|PROT_WRITE,MAP_SHARED,ri->file.fd,0);
#endif
	if((er = ri->vtbl->ii_open(cm,ri,__PROC__))) goto err;

	_clip_retni(cm,_clip_store_c_item(cm,ri,_C_ITEM_TYPE_I_INDEX,destroy_rdd_index));
	return 0;
err_open:
	er = rdd_err(cm,EG_OPEN,errno,__FILE__,__LINE__,__PROC__,ri->path);
err:
	if(ri && ri->name)
		free(ri->name);
	if(ri && ri->path)
		free(ri->path);
#ifdef HAVE_MMAN_H
	if(ri && ri->file.md != (char*)-1)
		munmap(ri->file.md,ri->file.mapsize);
#endif
	if(ri && ri->file.fd != -1)
		_clip_close(cm,ri->file.filehash,ri->file.fd);
	if(ri)
		free(ri);
	return er;
}

int rdd_ii_opentag(ClipMachine* cm,int h,const char* tag,const char* __PROC__){
	RDD_INDEX* ri = (RDD_INDEX*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_INDEX);
	RDD_ORDER* ro;
	int er;

	CHECKII(ri);

	if((er = ri->vtbl->ii_opentag(cm,ri,tag,&ro,__PROC__))) return er;

	ro->c_item = _clip_store_c_item(cm,ro,_C_ITEM_TYPE_I_ORDER,destroy_rdd_i_order);
	_clip_retni(cm,ro->c_item);
	return 0;
}

int rdd_ii_close(ClipMachine* cm,int h,const char* __PROC__){
	RDD_INDEX* ri = (RDD_INDEX*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_INDEX);
	int i;
	int er;

	CHECKII(ri);
	for(i=0;i<ri->norders;i++){
		if((er = rdd_ii_closetag(cm,ri->orders[i]->c_item,__PROC__))) return er;
	}
	_clip_destroy_c_item(cm,h,_C_ITEM_TYPE_I_INDEX);
	return 0;
}

int rdd_ii_closetag(ClipMachine* cm,int h,const char* __PROC__){
	RDD_ORDER* ro = (RDD_ORDER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);
	int i;

	CHECKIO(ro);
	for(i=0;i<ro->index->norders;i++){
		if(ro->index->orders[i]==ro){
			for(i++;i<ro->index->norders;i++){
				ro->index->orders[i-1] = ro->index->orders[i];
			}
		}
	}
	ro->index->norders--;
	ro->index->orders = (RDD_ORDER**)realloc(ro->index->orders,ro->index->norders*sizeof(RDD_ORDER*));
	destroy_rdd_order(cm,ro);
	_clip_destroy_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);
	return 0;
}

int rdd_ii_addkey(ClipMachine* cm,int h,const char* id,ClipVar* key,const char* __PROC__){
	RDD_ORDER* ro = (RDD_ORDER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);

	CHECKIO(ro);
	if((key->t.type==CHARACTER_t && ro->type!='C') ||
		(key->t.type==NUMERIC_t && ro->type!='N') ||
		(key->t.type==DATE_t && ro->type!='D') ||
		(key->t.type==LOGICAL_t && ro->type!='L'))
		return rdd_err(cm,EG_DATATYPE,0,__FILE__,__LINE__,__PROC__,"Type mismatch");

	return ro->vtbl->ii_addkey(cm,ro,id,key,__PROC__);
}

int rdd_ii_delkey(ClipMachine* cm,int h,const char* __PROC__){
	RDD_ORDER* ro = (RDD_ORDER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);

	CHECKIO(ro);
	if(ro->eof)
		return 0;
	return ro->vtbl->ii_delkey(cm,ro,__PROC__);
}

int rdd_ii_gotop(ClipMachine* cm,int h,const char* __PROC__){
	RDD_ORDER* ro = (RDD_ORDER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);

	CHECKIO(ro);
	return ro->vtbl->ii_gotop(cm,ro,__PROC__);
}

int rdd_ii_gobottom(ClipMachine* cm,int h,const char* __PROC__){
	RDD_ORDER* ro = (RDD_ORDER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);

	CHECKIO(ro);
	return ro->vtbl->ii_gobottom(cm,ro,__PROC__);
}

int rdd_ii_bof(ClipMachine* cm,int h,const char* __PROC__){
	RDD_ORDER* ro = (RDD_ORDER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);

	CHECKIO(ro);
	_clip_retl(cm,ro->bof);
	return 0;
}

int rdd_ii_eof(ClipMachine* cm,int h,const char* __PROC__){
	RDD_ORDER* ro = (RDD_ORDER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);

	CHECKIO(ro);
	_clip_retl(cm,ro->eof);
	return 0;
}

int rdd_ii_id(ClipMachine* cm,int h,const char* __PROC__){
	ClipVar* id = RETPTR(cm);
	RDD_ORDER* ro = (RDD_ORDER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);

	CHECKIO(ro);
	return ro->vtbl->ii_id(cm,ro,id,__PROC__);
}

int rdd_ii_key(ClipMachine* cm,int h,const char* __PROC__){
	ClipVar* key = RETPTR(cm);
	RDD_ORDER* ro = (RDD_ORDER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);

	CHECKIO(ro);
	return ro->vtbl->ii_key(cm,ro,key,__PROC__);
}

int rdd_ii_skip(ClipMachine* cm,int h,int recs,const char* __PROC__){
	RDD_ORDER* ro = (RDD_ORDER*)_clip_fetch_c_item(cm,h,_C_ITEM_TYPE_I_ORDER);
	int i;
	int er;

	CHECKIO(ro);

	if(recs>0){
		for(i=0;i<recs;i++){
			if((er = ro->vtbl->ii_next(cm,ro,__PROC__))) return er;
		}
	} else {
		for(i=0;i>recs;i--){
			if((er = ro->vtbl->ii_prev(cm,ro,__PROC__))) return er;
		}
	}
	return 0;
}

int rdd_event(ClipMachine* cm,int nEvent,int nArea,int nFieldPos,ClipVar* xTrigVal,int* re,const char* __PROC__){
	ClipFunction *fp;
	ClipBlock *bp;
	ClipVar tres;
	ClipVar args[4];
	DBWorkArea* wa;
	int er;

	if(re)
		*re = 1;
	if(nArea<0)
		return 0;

	wa = cm->areas->items[nArea];
	if(!wa->trig_active)
		return 0;

	if(_clip_get_function(cm,wa->trighash,&fp,&bp)){
		memset(args,0,sizeof(args));
		args[0].t.type = NUMERIC_t;
		args[0].t.flags = F_NONE;
		args[0].t.memo = 0;
		args[0].n.d = nEvent;
		args[1].t.type = NUMERIC_t;
		args[1].t.flags = F_NONE;
		args[1].t.memo = 0;
		args[1].n.d = nArea+1;
		args[2].t.type = NUMERIC_t;
		args[2].t.flags = F_NONE;
		args[2].t.memo = 0;
		args[2].n.d = nFieldPos;
		if(xTrigVal){
			args[3].t.type = xTrigVal->t.type;
			args[3].t.flags = F_MREF;
			args[3].p.vp = xTrigVal;
		}
		if((er = _clip_clip(cm,wa->trigger,4,args,&tres))) return er;
		if(re)
			*re = tres.l.val;
		_clip_destroy(cm,&tres);
	} else {
		wa->trig_active = 0;
	}
	return 0;
}

int _rdd_parsepath(ClipMachine* cm,const char* toopen,const char* suff,char** path,char** name,int oper,const char* __PROC__){
	char p[PATH_MAX];
	char ret[PATH_MAX];
	char *c,*e;

	strncpy(p,toopen,sizeof(p)-1);
	c = strrchr(p,'\\');
	e = strrchr(p,'/');
	e = max(c,e);
	if(!((c = strrchr(p,'.')) && (*(c+1) != '/') && (*(c+1) != '\\') && (c >= e))){
		strncat(p,suff,sizeof(p)-strlen(p)-1);
	}
	if(_clip_path(cm,p,ret,sizeof(ret),oper==EG_CREATE))
		return rdd_err(cm,oper,errno,__FILE__,__LINE__,__PROC__,toopen);
	*path = strdup(ret);
	if(name){
		c = strrchr(ret,'/');
		if(!c)
			c = strrchr(ret,'\\');
		e = strrchr(ret,'.');
		*e = 0;
		*name = strdup(c+1);
	}
	return 0;
}

int rdd_seekeval(ClipMachine* cm,RDD_DATA* rd,ClipVar* block,int* found,const char* __PROC__){
	RDD_ORDER* ro;
	int er;

	if((rd->ords_opened<1) || (rd->curord==-1))
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);

	ro = rd->orders[rd->curord];
	if(!ro->vtbl->wildskip)
		return rdd_err(cm,EG_UNSUPPORTED,0,__FILE__,__LINE__,__PROC__,
			"Operation is not supported by current RDD");

	if((er = rdd_checkifnew(cm,rd,__PROC__))) return er;

	if((er = ro->vtbl->wildskip(cm,rd,ro,NULL,0,NULL,block,found,__PROC__)))
		return er;
	if(!(*found)){
		unsigned int lastrec;

		if((er = rdd_lastrec(cm,rd,&lastrec,__PROC__))) return er;
		rd->eof = 1;
		if((er = rd->vtbl->rawgo(cm,rd,lastrec+1,0,__PROC__))) return er;
	}
	return 0;
}

static int _rdd_wildskip(ClipMachine* cm,RDD_DATA* rd,const char* pattern,int regular,const char* s,int* found,const char* __PROC__){
	RDD_ORDER* ro = rd->orders[rd->curord];
	int er;

	if(ro->vtbl->wildskip){
		if((er = ro->vtbl->wildskip(cm,rd,ro,pattern,regular,s,NULL,found,__PROC__)))
			return er;
	} else {
		ClipVar v,*vp;
		char* e;

		*found = 1;
		memset(&v,0,sizeof(ClipVar));
		if((er = rdd_calc(cm,rd->area,&ro->block,&v,0))) return er;
		vp = _clip_vptr(&v);
		e = vp->s.str.buf+vp->s.str.len;
		while((--e >= vp->s.str.buf) && *e == ' ');
		*(e+1) = 0;
		while(!rd->eof && (memcmp(vp->s.str.buf,pattern,s-pattern)==0) &&
			 (_clip_glob_match(vp->s.str.buf,pattern,1) == -1)){

			_clip_destroy(cm,&v);
			if((er = rdd_skip(cm,rd,1,__PROC__))) return er;
			if((er = rdd_calc(cm,rd->area,&ro->block,&v,0))) return er;
			vp = _clip_vptr(&v);
			e = vp->s.str.buf+vp->s.str.len;
			while((--e >= vp->s.str.buf) && *e == ' ');
			*(e+1) = 0;
		}
		if(rd->eof || (memcmp(vp->s.str.buf,pattern,s-pattern)!=0))
			*found = 0;

		_clip_destroy(cm,&v);
	}
	return 0;
}

int rdd_wildseek(ClipMachine* cm,RDD_DATA* rd,const char* pat,int regular,int cont,int* found,const char* __PROC__){
	char* e;
	char* s;
	char* q;
	char* b = NULL;
	char* pattern;
	int er;

	if((rd->ords_opened<1) || (rd->curord==-1))
		return rdd_err(cm,EG_NOORDER,0,__FILE__,__LINE__,__PROC__,er_noorder);

	if(rd->orders[rd->curord]->type != 'C')
		return rdd_err(cm,EG_UNSUPPORTED,0,__FILE__,__LINE__,__PROC__,
			"Order is not CHARACTER");

	pattern = strdup(pat);
	if((er = rdd_checkifnew(cm,rd,__PROC__))) goto err;

	e = (char*)pattern + strlen(pattern);
	loc_write(rd->loc,pattern,e-pattern);
	if(!regular){
		s = strchr(pattern,'*');
		q = strchr(pattern,'?');
		if(!s) s = e; if(!q) q = e; if(!b) b = e;
		s = min(min(s,q),b);
	} else {
		s = NULL;
	}

	if(!cont){
		ClipVar v;
		int fnd;

		if((s == pattern) || regular){
			if((er = rd->orders[rd->curord]->vtbl->gotop(cm,rd,rd->orders[rd->curord],
				__PROC__))) goto err;
		} else {
			memset(&v,0,sizeof(ClipVar));
			v.t.type = CHARACTER_t;
			v.s.str.buf = malloc(s-pattern+1);
			memcpy(v.s.str.buf,pat,s-pattern);
			v.s.str.buf[s-pattern] = 0;
			v.s.str.len = s - pattern;
			if((er = rd->orders[rd->curord]->vtbl->seek(cm,rd,rd->orders[rd->curord],
				&v,0,0,&fnd,__PROC__))) goto err;
			free(v.s.str.buf);
		}
	} else {
		if((er = rdd_skip(cm,rd,1,__PROC__))) goto err;
	}
	if(rd->eof){
		*found = 0;
	} else {
		if((er = _rdd_wildskip(cm,rd,pattern,regular,s,found,__PROC__))) goto err;
		if(!(*found)){
			unsigned int lastrec;

			if((er = rdd_lastrec(cm,rd,&lastrec,__PROC__))) goto err;
			rd->eof = 1;
			if((er = rd->vtbl->rawgo(cm,rd,lastrec+1,0,__PROC__))) goto err;
		}
	}
	free(pattern);
	return 0;
err:
	free(pattern);
	return er;
}

int rdd_rawread(ClipMachine* cm,RDD_DATA* rd,void* buf,const char* __PROC__){
	return rdd_read(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1),rd->recsize,
		buf,__PROC__);
}

int rdd_rawwrite(ClipMachine* cm,RDD_DATA* rd,void* buf,int append,const char* __PROC__){
	int er;

	if((er = rdd_write(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno-1),rd->recsize,
		buf,__PROC__))) return er;
	if(append){
		unsigned char lr[4];
		int flen;

		_rdd_put_uint(lr,rd->recno);
		if((er = rdd_write(cm,&rd->file,4,4,lr,__PROC__))) return er;
		rd->recno++;

		flen = rd->hdrsize+rd->recsize*rd->recno+1;
		if((int)rd->file.md!=-1){
			if(flen>rd->file.mapsize){
				int delta = rd->recno/5;
				if((er = rdd_write(cm,&rd->file,rd->hdrsize+rd->recsize*(rd->recno+delta)-1,
					1,"",__PROC__))) return er;
			}
		}
	}
	rd->updated = 1;
	return 0;
}
