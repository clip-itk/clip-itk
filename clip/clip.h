/*
	Copyright (C) 2001  ITK
	Author   : Paul Lasarev <paul@itk.ru>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log$
   Revision 1.4  2007/02/12 16:13:08  itk
   uri: some fix about task_select and some fix for amd64

   Revision 1.3  2007/02/12 09:13:17  itk
   uri: many fixes for amd64

   Revision 1.2  2007/01/09 11:41:30  itk
   uri: add set(_SET_IDLE_INKEY) for minimize traffic from terminal

   Revision 1.1  2006/06/22 19:35:15  itk
   uri: init sf.net repository

   Revision 1.244  2006/05/12 06:49:34  clip
   uri: fix bug in macroassing and _clip_parse_name.
	&("m[varname]") := &("m[varname]")

   Revision 1.243  2005/12/22 12:30:05  clip
   alena: add new _C_ITEM_TYPE_PARSER for clip-expat

   Revision 1.242  2005/11/26 16:25:47  clip
   uri: rename task_select_if -> clip_task_select_if
	It is openBsd pheatures.

   Revision 1.241  2005/01/05 11:22:01  clip
   uri: small fix

   Revision 1.240  2004/10/28 11:47:33  clip
   uri: fix formatiing in STR(), pad*() for numeric data and constants.

   Revision 1.239  2004/10/20 17:22:17  clip
   uri: add set(_SET_UTF8TERM) for terminal with UTF-8

   Revision 1.238  2004/09/30 12:07:04  clip
   uri: small fix for str(-1234567890,10)

   Revision 1.237  2004/09/03 07:17:54  clip
   uri: small fix

   Revision 1.236  2004/07/05 08:31:14  clip
   uri: small fix in _storni()

   Revision 1.235  2004/06/11 10:15:14  clip
   rust: SET PRINTER TO MEMBUF

   Revision 1.234  2004/06/01 09:53:02  clip
   uri: small fix

   Revision 1.233  2004/03/17 08:47:26  clip
   uri: bug in colowin() fixed. Reported by Stas

   Revision 1.232  2004/03/01 11:27:13  clip
   uri: add CLIP_DOS_SCRBUF for save/rest screen

   Revision 1.231  2004/02/10 11:14:03  clip
   rust: str_str() -> _clip_strstr() with '"" $ "string"' bugfix

   Revision 1.230  2004/01/28 13:49:00  clip
   rust: common ClipMachine->kbdbuf

   Revision 1.229  2004/01/25 10:23:40  clip
   uri: fix bug in exit procedures and inkey()

   Revision 1.228  2004/01/04 10:24:49  clip
   uri: add set(_SET_ROOTPATH,"rootpath") for add "rootpath" to all filenames,
	via "/var/www/htdocs" in apache.

   Revision 1.227  2003/11/21 11:12:21  clip
   set operation result if errorblock return new value
   paul

   Revision 1.226  2003/11/21 06:21:15  clip
   uri: rewriting generator error for "invalid arguments for %s operation",
	for operation +-*$=%**....

   Revision 1.225  2003/11/19 11:48:25  clip
   add FLUSHOUT_FLAG, _SET_FLUSHOUT to set
   paul

   Revision 1.224  2003/11/04 11:18:34  clip
   post signal handler
   paul

   Revision 1.223  2003/09/05 12:11:52  clip
   uri: initial fixes for mingw+win32 from uri

   Revision 1.222  2003/09/04 14:04:41  clip
   *** empty log message ***

   Revision 1.221  2003/09/02 14:27:42  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.220  2003/06/20 08:21:25  clip
   possible fixes #144
   paul

   Revision 1.219  2003/05/16 11:08:02  clip
   initial support for using assembler instead C
   now activated if environment variable CLIP_ASM is defined to any value
   paul

   Revision 1.218  2003/04/14 14:01:24  clip
   rust: bug in fclose(), reported by Istv� F�di <foldii@terrasoft.hu>

   Revision 1.217  2003/04/02 10:53:19  clip
   rust: _clip_close() added

   Revision 1.216  2003/03/25 10:58:11  clip
   rust: _clip_setlock() added

   Revision 1.215  2003/03/21 11:49:40  clip
   rust: RDD locks with tasks (DOS compatibility)

   Revision 1.214  2003/03/12 12:50:42  clip
   rust: tasks share RDDs and subdrivers

   Revision 1.213  2003/02/13 16:36:44  clip
   rust: STOT()

   Revision 1.212  2003/02/10 13:04:47  clip
   rust: SET MULTILOCKS ON|OFF (FlagShip extension)

   Revision 1.211  2003/02/06 10:56:03  clip
   uri: added CRC16, reconstructed CRC32.

   Revision 1.210  2003/01/22 10:33:38  clip
   dosparam() function
   closes #111
   paul

   Revision 1.209  2002/12/31 08:03:36  clip
   assign to locals
   closes #95
   paul

   Revision 1.208  2002/12/25 14:48:51  clip
   rust: SQL driver registration changed

   Revision 1.207  2002/12/23 13:57:46  clip
   reference to temporary object
   frame structure extended!
   closes #90
   paul

   Revision 1.206  2002/12/04 07:09:59  clip
   simple profiler realised
   start program with --profile will generate <progname>.pro profile
   limitations: manual written C functions are not profiled, bad accuracy
   paul

   Revision 1.205  2002/11/26 12:42:36  clip
   rust: added parameter 'method' to _clip_var2str() and _clip_str2var()

   Revision 1.204  2002/11/26 10:21:22  clip
   OpenBSD fixes
   paul

   Revision 1.203  2002/11/11 13:12:15  clip
   rust: m6_Error(), m6_Set()

   Revision 1.202  2002/10/31 10:33:59  clip
   plural form runtime messages support:
   gettext(cMsgid [,cModule])->cTranslated
   ngettext(cMsgid, cMsgid_plural, nNum, [,cModule]) ->cTranslated
   paul

   Revision 1.201  2002/10/29 13:29:45  clip
   rust: SET INDEX BUFFER LIMIT [TO] <n_Megabytes>
	  SET MAP FILE ON|OFF

   Revision 1.200  2002/10/26 11:10:01  clip
   initial support for localized runtime messages
   messages are in module 'cliprt'
   paul

   Revision 1.199  2002/10/21 11:06:17  clip
   *** empty log message ***

   Revision 1.198  2002/10/21 10:20:10  clip
   uri: small fix for cygwin

   Revision 1.197  2002/10/21 09:32:56  clip
   uri: changes from druzus.

   Revision 1.196  2002/10/02 12:21:55  clip
   uri: added "set buffring on|off" and changed fileIO functions for it.

   Revision 1.195  2002/10/02 11:02:20  clip
   uri: small fix

   Revision 1.194  2002/10/02 07:18:09  clip
   uri: added type of opened file control, ftype() added.

   Revision 1.193  2002/09/27 08:27:14  clip
   alexey: new C_ITEM type

   Revision 1.192  2002/09/25 11:47:25  clip
   add function: loadModuleMsg(cModule, cFilename_mo) -> bResult
   predefined macro: __CLIP_MODULE__  expands to current module name as "modname"
   new accepted environment var: CLIP_LOCALE_ROOT
	used by clip, clip_msgmerge, clip_msgfmt, and at runtime
   paul

   Revision 1.191  2002/09/16 09:37:37  clip
   alexey: function _clip_host_charset() added

   Revision 1.190  2002/08/27 13:31:57  clip
   add _clip_ref_public_noadd func
   fix for mem restore
   paul

   Revision 1.189  2002/08/12 10:16:00  clip
   #defi(n|ne) worked
   paul

   Revision 1.188  2002/08/05 09:28:06  clip
   MAPEVAL()
   paul

   Revision 1.187  2002/07/15 15:16:06  clip
   rust: Interbase (Firebird) started

   Revision 1.186  2002/07/01 13:06:03  clip
   preproc fixes
   number constants len.dec 10.2
   paul

   Revision 1.185  2002/05/27 09:52:41  clip
   uri: added "set fopen mode DOS|POSIX"

   Revision 1.184  2002/05/20 12:01:48  clip
   make _clip_fullsceen  global
   paul

   Revision 1.183  2002/05/16 09:07:43  clip
   possible to disable expansion in strings:
   SET MACRO_IN_STRING OFF
   paul

   Revision 1.182  2002/05/14 07:46:43  clip
   rust: TTOS() -> string in format 'yyyy-mm-dd hh:mm:ss'

   Revision 1.181  2002/05/12 11:19:22  clip
   rust: _clip_fetch_c_item_type() - fetches item of type

   Revision 1.180  2002/04/30 12:52:01  clip
   add -stack flag to configure to enable runtime stack check
   paul

   Revision 1.179  2002/04/28 13:50:43  clip
   SET HOURS [TO] 12|24
   SET SECONDS ON|OFF
   rust

   Revision 1.178  2002/04/24 13:14:43  clip
   initial
   paul

   Revision 1.177  2002/04/23 11:42:37  clip
   append _clip_open
   paul

   Revision 1.176  2002/04/22 15:29:55  clip
   rust: initial support of DATETIME type

   Revision 1.175  2002/04/22 14:05:12  clip
   add _clip_creat
   creat & open modes on ncpfs
   paul

   Revision 1.174  2002/04/15 12:25:58  clip
   Changes from Alexander S.Kresin <alex@belacy.belgorod.su>
   paul

   Revision 1.173  2002/04/15 11:54:55  clip
   rust: #define _C_ITEM_TYPE_BTREE  14

   Revision 1.172  2002/04/11 15:42:23  clip
   uri: set(_SET_DISPBOX) - dispbox over dispout()

   Revision 1.171  2002/04/09 10:58:42  clip
   break array/map limit to 65535 members
   paul

   Revision 1.170  2002/04/07 17:42:26  clip
   rust: odbc_connect

   Revision 1.169  2002/03/06 11:27:52  clip
   string compare
   paul

   Revision 1.168  2002/03/02 11:24:54  clip
   add compatability option:
   -q <word>
   --compat=<word>
   possible words:
	as-word  	- default value
		   no-as-word
   paul

   Revision 1.167  2002/02/28 08:50:10  clip
   add _SET_MAPERR
   with .t. map fetch will return NIL if no index instead of error generation
   paul

   Revision 1.166  2002/02/06 12:37:33  clip
   sigsegv
   paul

   Revision 1.165  2002/02/06 08:30:13  clip
   static codeblocks
   paul

   Revision 1.164  2002/01/30 08:56:33  clip
   rust: int (*pg[|ms|or]_connect)(...) -> ClipMachine structure

   Revision 1.163  2002/01/29 13:12:17  clip
   load( dll)
   tested under linux
   paul

   Revision 1.162  2002/01/04 13:00:09  clip
   #define _C_ITEM_TYPE_HIPER 11
   rust

   Revision 1.161  2001/12/26 12:12:17  clip
   share container for ClipMachine's
   paul

   Revision 1.160  2001/12/24 13:21:53  clip
   _dos_path() - makes DOS path respecting SET DEFAULT, SET PATH etc
   alexey

   Revision 1.159  2001/12/12 15:34:09  clip
   SET LOCKSTYLE [TO] CLIPPER | CLIPPER50 | CLIPPER52 | CLIPPER53 | FOXPRO | SIX
   rust

   Revision 1.158  2001/12/11 07:48:25  clip
   middle mouse button
   paul

   Revision 1.157  2001/11/27 11:44:46  clip
   add mouse control functions:

   INKEY(timeout, [nEventMask])
   NEXTKEY - use system eventMask
   SET(_SET_EVENTMASK)
   MPRESENT() --> lIsPresent
   MHIDE()
		  note: not fully compatible (parameters are ignored)
   MSHOW()
		  note: not fully compatible (parameters are ignored)
   MSETCURSOR( [<lVisible>] ) --> lIsVisible
   MROW() --> nMouseRow
   MCOL() --> nMouseCol
   MLEFTDOWN() --> lIsPressed
   MRIGHTDOWN() --> lIsPressed
   MSETBOUNDS( [<nTop>], [<nLeft>], [<nBottom>], [<nRight>] ) --> NIL
   MSAVESTATE() --> cSaveState
   MRESTSTATE( <cSaveState> ) --> NIL
   MDBLCLK([<nNewSpeed>]) --> nSpeed
		  note: really not work
   MSETPOS( <nRow>, <nCol> ) --> NIL
		  note: really not work
   MSTATE() --> aState | 0

   paul

   Revision 1.156  2001/11/23 13:36:45  clip
   assign by ref to map/array members:
   o:a := @var
   to break reference, use:
   o:a := @nil
   paul

   Revision 1.155  2001/11/23 11:08:17  clip
   add _clip_hashword(str,len), _clip_casehashword(str,len), which trim
   str before calc hash
   paul

   Revision 1.154  2001/11/22 11:33:32  clip
   a:='test->first'
   ? field->&a
   paul

   Revision 1.153  2001/11/21 09:14:32  clip
   uri: remake __setCenture & set(_SET_DATEFORMAT)

   Revision 1.152  2001/11/20 13:19:53  clip
   uri: setTxlat(), setPxlat() added

   Revision 1.151  2001/11/12 14:13:46  clip
   START(cFuncname) now work :)
   paul

   Revision 1.150  2001/11/08 14:00:07  clip
   auto recoding of i18n messages
   paul

   Revision 1.149  2001/11/08 09:50:00  clip
   alexey: add function _clip_mtype, what returns a type of map field

   Revision 1.148  2001/11/07 10:48:31  clip
   fixes for use mmap in win32
   paul

   Revision 1.147  2001/11/06 10:20:40  clip
   _clip_call_errblock in various points
   paul

   Revision 1.146  2001/11/01 14:54:40  clip
   _clip_path() - makes absolute path respecting SET DEFAULT, SET PATH etc
   rust

   Revision 1.145  2001/10/29 11:56:34  clip
   fix for BLINK(intensitive background)
   paul

   Revision 1.144  2001/10/16 13:04:33  clip
   uri: add _clip_datetostr

   Revision 1.143  2001/10/16 11:13:30  clip
   _clip_dtostr()
   rust

   Revision 1.142  2001/10/10 10:26:17  clip
   add cmp functions with using _clip_cmptbl and stadard
   semantic, fix _clip_cmp for using one.
   _clip_strcmp
   _clip_strncmp
   _clip_strcasecmp
   _clip_strncasecmp

   Revision 1.141  2001/10/09 08:19:10  clip
   uri: datetime support functions

   Revision 1.140  2001/10/02 14:21:43  clip
   uri: sys/types.h

   Revision 1.139  2001/09/28 13:58:29  clip
   SET OPTIMIZE LEVEL [TO] <1|2>
   rust

   Revision 1.138  2001/09/28 10:39:25  clip
   reffuncs not applied to FMemvar
   paul

   Revision 1.137  2001/09/21 10:29:15  clip
   memvar priority in macro
   paul

   Revision 1.136  2001/09/21 09:53:25  clip
   charsets handling
   paul

   Revision 1.135  2001/09/20 08:37:38  clip
   add _clip_storclen function
   From: Anton Ustyancev <anton@cinvest.chel.su>
   paul

   Revision 1.134  2001/09/12 10:50:42  clip
   stream output recoding
   paul

   Revision 1.133  2001/09/10 05:32:05  clip
   _clip_par_*   functions
   paul

   Revision 1.132  2001/09/07 06:31:48  clip
   dll bindings
   paul

   Revision 1.131  2001/09/06 14:01:06  clip
   -L flag
   paul

   Revision 1.130  2001/08/30 15:58:39  clip
   library bindings
   paul

   Revision 1.129  2001/08/30 14:37:53  clip
   new library binding
   paul

   Revision 1.128  2001/08/27 09:45:30  clip
   switch operator
   paul

   Revision 1.127  2001/08/26 12:11:59  clip
   reflocals
   paul

   Revision 1.126  2001/08/26 11:37:00  clip
   selfref detection in local(b:=@localvar)
   paul

   Revision 1.125  2001/08/26 09:10:06  clip
   references
   paul

   Revision 1.124  2001/08/25 12:30:33  clip
   memleak in @func()
   paul

   Revision 1.123  2001/08/25 09:07:09  clip
   privates creation/removing in macro
   paul

   Revision 1.122  2001/08/24 14:38:46  clip
   CODESTR pseudofunction
   paul

   Revision 1.121  2001/08/24 08:04:38  clip
   macro assign to array/map members
   paul

   Revision 1.120  2001/08/23 13:52:06  clip
   merge with NEWLOCALS
   paul


   Revision 1.119  2001/08/21 11:05:32  clip
   #define _C_ITEM_TYPE_I_ORDER 9
   Independed order
   rust

   Revision 1.118  2001/08/20 11:21:26  clip
   #define _C_ITEM_TYPE_I_INDEX 8
   Independed index
   rust

   Revision 1.117  2001/08/13 10:30:36  clip
   *** empty log message ***

   Revision 1.116  2001/07/31 09:25:46  clip
   uri: add FILE&DIR CREATE MODE in format "nnn"

   Revision 1.115  2001/07/31 08:21:50  clip
   uri: add SET_FILECREATEMODE & SET_DIRCREATEMODE and fixed in functions

   Revision 1.114.2.9  2001/08/23 12:20:21  clip
   ISPRIVATE(cName) ->lVal
   ISPUBLIC(cName) ->lVal
   paul

   Revision 1.114.2.8  2001/08/23 10:13:42  clip
   fix field/memvar order in references
   paul

   Revision 1.114.2.7  2001/08/22 13:52:38  clip
   assign to field
   paul

   Revision 1.114.2.6  2001/08/22 08:45:20  clip
   fix
   paul

   Revision 1.114.2.5  2001/08/21 14:29:38  clip
   refernce to macro: b:=@&s
   paul

   Revision 1.114.2.4  2001/08/21 12:10:35  clip
   local init in codeblock, f.e.:

   local a:={1,2,3}
   cb:={|x|local(b:=a[2]),iif(x==NIL,b,b:=x)}
   ? eval(cb)
   ? a
   ? eval(cb,'dddd')
   ? a
   ?

   paul

   Revision 1.114.2.3  2001/08/21 08:29:54  clip
   reference assign (like b:=@a[1])
   paul

   Revision 1.114.2.2  2001/08/16 13:41:53  clip
   fix
   paul

   Revision 1.114.2.1  2001/08/03 12:07:59  clip
   NEWLOCALS initial
   paul

   Revision 1.114  2001/07/26 11:48:37  clip
   after
   set ('PRINTER_CHARSET', 'cp866')
   and
   set printer to asdf
   all output to printer will be recoded from CLIP_HOSTCS to PRINTER_CHARSET
   if PRINTER_CHARSET is not setted, recode from CLIP_HOSTCS to CLIP_CLIENTCS
   paul

   Revision 1.113  2001/07/24 08:28:15  clip
   *** empty log message ***

   Revision 1.111  2001/07/20 14:54:52  clip
   #define _C_ITEM_TYPE_RYO 8
   (Roll-Your-Own filter)
   rust

   Revision 1.110  2001/06/15 12:02:36  clip
   implement
   int _clip_storni(ClipMachine * mp, int n, int num, int ind);
   int _clip_stornl(ClipMachine * mp, long n, int num, int ind);
   int _clip_stornd(ClipMachine * mp, double n, int num, int ind);
   int _clip_storc(ClipMachine * mp, const char *str, int num, int ind);
   int _clip_storl(ClipMachine * mp, int l, int num, int ind);
   int _clip_stordj(ClipMachine * mp, long julian, int num, int ind);
   int _clip_stordc(ClipMachine * mp, int yy, int mm, int dd, int num, int ind);

   paul

   Revision 1.109  2001/06/14 10:20:13  clip
   LOADBLOCK(<cName>) -> code
   paul

   Revision 1.108  2001/06/13 13:05:47  clip
   uri: add case flag in _clip_glob_match(), fixed all calls  this functions

   Revision 1.107  2001/06/11 10:31:20  clip
   _SET_OPTIMIZE, OPTIMIZE_FLAG added
   rust

   Revision 1.106  2001/06/03 13:15:15  clip
   _SET_MBLOCKSIZE added. Default is 64.
   rust

   Revision 1.105  2001/05/31 13:15:29  clip
   clip_clip
   paul

   Revision 1.104  2001/05/30 09:45:43  clip
   for .. in .. [keys]
   paul

   Revision 1.103  2001/05/25 12:59:24  clip
   uri: new function in gd

   Revision 1.102  2001/05/15 07:02:17  clip
   modify memdebug call interface
   paul

   Revision 1.101  2001/05/14 13:25:42  clip
   memdebug
   paul

   Revision 1.100  2001/05/13 11:54:50  clip
   uri: _clip_strtod() over strtod()

   Revision 1.99  2001/05/11 09:11:57  clip
   errorblock & pcode
   paul

   Revision 1.98  2001/05/04 08:38:26  clip
   assign_field with macro
   paul

   Revision 1.97  2001/04/22 12:50:37  clip
   autoopen, autoorder added
   rust

   Revision 1.96  2001/04/10 12:45:43  clip
   print deep limit
   paul

   Revision 1.95  2001/04/10 12:11:19  clip
   uri: add command "set translate path"

   Revision 1.94  2001/04/09 11:12:27  clip
   ASORT,ASCAN work with mishalleous types in array
   add additional parameter to _clip_cmp
   paul

   Revision 1.93  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.92  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.91  2001/03/26 09:47:47  clip
   continue
   paul

   Revision 1.90  2001/03/19 10:16:21  clip
   hashnames
   paul

   Revision 1.89  2001/03/16 08:56:10  clip
   next command clenup
   paul

   Revision 1.88  2001/03/12 13:47:18  clip
   VAR2STR, STR2VAR funcs
   paul

   Revision 1.87  2001/03/09 11:43:59  clip
   New RDD added
   Rust

   Revision 1.86  2001/03/07 14:14:52  clip
   UUDECODE, UUENCODE funcs
   paul

   Revision 1.85  2001/02/22 09:53:35  clip
   dbg: expr command
   paul

   Revision 1.84  2001/02/21 12:52:58  clip
   append HASHNAME(hash) - inverce to HASHSTR(str)

   append obj:modify() trigger:
   modify(obj,hash,newval) -> real new val
   MAPMODIFY(obj, enable) switch modify processing

   paul

   Revision 1.83  2001/02/19 13:18:37  clip
   hidden option runtime recognition, currently
   one option: --debug[=debuglevel] - to enable runtime debug connection
   paul

   Revision 1.82  2001/02/16 12:48:50  clip
   breakpoints
   paul

   Revision 1.81  2001/02/13 13:33:57  clip
   dbg bpoints
   paul

   Revision 1.80  2001/02/08 06:35:54  clip
   static defs in .po
   paul

   Revision 1.79  2001/02/06 13:07:24  clip
   hash in .po, dbg
   paul

   Revision 1.78  2001/02/01 13:05:05  clip
   debug links
   paul

   Revision 1.77  2001/01/28 13:15:26  clip
   _clip_mgetl() - get a logical value from object element

   Revision 1.76  2001/01/19 08:43:33  clip
   append RDD direct access in rt.y

   functions (yet empty):
   int _clip_rddfieldno(ClipMachine * mp, int rddno, long namehash);
   int _clip_rddfield(ClipMachine * mp, int rddno, int fieldno);

   syntax:
   _rdd_ 2 <expr> _rdd_
   for direct access to RDD 2 in <expr>
   That means, rdd field names override normal fields/memvars

   paul

   Revision 1.75  2001/01/16 10:12:03  clip
   alena: new function in _string.c clip_RGCOMP, clip_RGEXEC, clip_RGCANCEL

   Revision 1.74  2001/01/05 12:44:30  clip
   serg: ������� �__CopyFile, �����X

   Revision 1.73  2000/12/27 10:13:58  clip
   *** empty log message ***

   Revision 1.72  2000/12/20 12:35:13  clip
   privates in macro
   empty arrays in macro
   paul

   Revision 1.71  2000/12/09 12:13:28  clip
   locale
   paul

   Revision 1.70  2000/12/08 08:29:22  clip
   privates
   paul

   Revision 1.69  2000/12/06 13:13:01  clip
   loadable charset tables. size 256
   paul

   Revision 1.68  2000/12/02 13:47:40  clip
   CLIPROOT now may be envar
   paul

   Revision 1.67  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.66  2000/11/28 14:01:10  clip
   serg: ��������� X-window � GTK,
	����xcreatewindow, xcreatebutton

   Revision 1.65  2000/11/24 12:03:09  clip
   append _clip_mget()
   paul

   Revision 1.64  2000/11/23 06:50:23  clip
   load(name [,array])
   paul

   Revision 1.63  2000/11/22 14:52:19  clip
   .po now can be start with any (for example #!/usr/bin/cliprun) string
   paul

   Revision 1.62  2000/11/22 13:45:14  clip

   paul

   Revision 1.61  2000/11/22 09:37:42  clip
   init procedure in pcode
   paul

   Revision 1.60  2000/11/21 11:31:12  clip
   io
   paul

   Revision 1.59  2000/11/20 10:36:38  clip
   ISFUNCTION(name)
   paul

   Revision 1.58  2000/11/08 13:49:42  clip
   serg: �������������� ����� ������fopen:
	 fopen( "-|" ) - ��������
	 fopen( "|-" ) - ���������	 fopen( "ls -l |" ) - � ����������������	 fopen( "| gzip > a.gz" ) - stdout ���gzip ������ ���.

   Revision 1.57  2000/10/25 12:52:46  clip
   for..next
   Paul Lasarev <paul@itk.ru>

   Revision 1.56  2000/10/24 16:31:54  clip
   bug in substr
   from uri:

   Revision 1.55  2000/10/20 08:03:23  clip
   ����rational �����������NUMERIC_t
   ����� ����� ������� � ������� ��� ���   ��� �����������NUMERIC_t !!!!!
   from uri:

   Revision 1.54  2000/10/18 10:56:17  clip
   append rationals
   Paul Lasarev <paul@itk.ru>

   Revision 1.53  2000/08/31 12:46:33  clip
   *** empty log message ***

   Revision 1.52  2000/08/24 13:54:24  clip
   serg: container, fopen, fread, fwrite, ...

   Revision 1.51  2000/05/30 15:22:49  clip
   uri: function colorselect and io color

   Revision 1.50  2000/05/24 18:34:08  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.49  2000/05/24 16:56:31  clip
   bugs
   Paul Lasarev <paul@itk.ru>

   Revision 1.48  2000/05/23 18:59:53  clip
   append window functions
   Paul Lasarev <paul@itk.ru>

   Revision 1.47  2000/05/20 18:37:27  clip
   change hash function
   append HASH_xxxx extraction into hashcode.h
   Paul Lasarev <paul@itk.ru>

   Revision 1.46  2000/05/19 19:37:30  clip
   &macro->field
   case-independence
   Paul Lasarev <paul@itk.ru>

   Revision 1.45  2000/05/19 01:07:07  clip
   setshare, getshare (serg)
   �� ��� �� ���� ���� �������� ��������
   Revision 1.44  2000/05/14 00:36:20  clip
   setfcreate, strfile (serg)

   Revision 1.43  2000/05/12 21:38:58  clip
   fix error messages return & idx continue (axl)

   Revision 1.42  2000/05/12 17:08:18  clip
   add error:syserr member
   Paul Lasarev <paul@itk.ru>

   Revision 1.41  2000/05/10 18:33:47  clip
   AADD now clone arrays
   terminal initialization fail only in fullscreen mode
   Paul Lasarev <paul@itk.ru>

   Revision 1.40  2000/05/03 19:32:33  clip
   add prefix 'clip_' to all clip functions

   Revision 1.39  2000/04/27 22:55:46  clip
   freebsd fix

   Revision 1.38  2000/04/14 00:51:20  uri
   ���������math+tools

   Revision 1.37  2000/04/11 00:21:22  serg
   ����� FILESEEK - �� ����� ���� �� � � ���
   Revision 1.36  2000/04/10 21:42:14  paul
   field->&asdf := expr

   Revision 1.35  2000/04/07 20:13:33  paul
   memo flag

   Revision 1.34  2000/04/07 19:59:10  paul
   clip_store_item_destroy

   Revision 1.33  2000/04/01 20:16:33  paul
   case-insensitive _clip_glob_match

   Revision 1.32  2000/03/31 16:53:22  paul
   memfile rw

   Revision 1.31  2000/03/30 16:25:11  paul
   PARAM

   Revision 1.30  2000/03/29 22:36:22  paul
   clip_trap_err

   Revision 1.29  2000/03/29 21:15:53  paul
   errorblock nest limited

   Revision 1.28  2000/03/29 18:26:11  paul
   errorblock

   Revision 1.27  2000/03/25 18:02:22  uri
   outlog - first parameter - as level

   Revision 1.26  2000/03/24 19:49:57  uri
   set(_SET_LOGFILE)

   Revision 1.25  2000/03/24 19:02:53  paul
   logg

   Revision 1.24  2000/03/24 18:10:09  paul
   trace

   Revision 1.23  2000/03/21 14:53:25  paul
   macroassign; __FIELD__ with macroassign

   Revision 1.22  2000/03/20 18:59:46  paul
   __field__ directive

   Revision 1.21  2000/03/17 20:41:38  serg
   *** empty log message ***

   Revision 1.20  2000/03/17 16:27:22  paul
   add ISFIELD ISMEMVAR

   Revision 1.19  2000/03/14 18:19:42  paul
   add _clip_take_field, fix bug in _clip_eval_macro with simple fields

   Revision 1.18  2000/03/13 15:16:04  paul
   add _clip_upstr, upper case for ALIAS

   Revision 1.17  2000/03/09 22:24:22  paul
   mem leak

   Revision 1.16  2000/03/09 21:40:30  paul
   memdebug removed

   Revision 1.15  2000/03/09 21:02:51  paul
   memory leak with objs, clip_cmp bug

   Revision 1.14  2000/02/21 23:01:27  serg
   *** empty log message ***

   Revision 1.13  1999/12/28 22:03:03  serg
   *** empty log message ***

   Revision 1.12  1999/12/28 20:36:50  serg
   *** empty log message ***

   Revision 1.11  1999/12/10 17:28:31  uri
   ���������� �cliprt, ����MEMO_t, ��� �����misc
   ����� ���

   Revision 1.10  1999/12/08 21:01:25  uri
   ������������ � ���

   Revision 1.9  1999/12/04 20:05:28  serg
   *** empty log message ***

   Revision 1.8  1999/11/27 20:27:06  uri
   added function _clip_isalpha(unsigned cahr ch) to ISALPHA & POSALPHA clipper
   functions

   Revision 1.7  1999/11/27 19:36:07  uri
   added isalpha table

   Revision 1.6  1999/11/09 22:49:12  axl
   Created DBFMEM - dbf in memory.

   Revision 1.5  1999/10/29 14:02:12  paul
   macroassign now worked

   Revision 1.4  1999/10/27 19:48:13  uri
   type & mptr

   Revision 1.3  1999/10/27 17:29:31  paul
   change param handling

   Revision 1.2  1999/10/26 19:11:18  paul
   start cvs logging

 */

#ifndef CLIP_H
#define CLIP_H

#include "clipcfg.h"
/*
#if defined(OS_MINGW)
	#include "_win32.h"
#else
	#define INT64 long long
#endif
*/

/*#define MEMDEBUG */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/fcntl.h>
#include <sys/time.h>
#ifdef __FreeBSD__
	#include <unistd.h>
#endif

#if defined(__GNUC__)
		#include "clipcfg.h"
#else
		#include "wintypes.h"
#endif


#ifdef MEMDEBUG
#ifdef MALLOC_FUNC_CHECK
	#include "memdebug/malloc_str.h"
#endif
#include "memdebug/malloc.h"
#endif
#ifdef USE_THREADS
	#include <pthread.h>
#endif

union ClipVar;
struct ClipVarEl;
struct ClipMachine;
struct Screen;
struct ScreenBase;
struct rational;

struct ClipMachine *new_ClipMachine(struct Screen *scr);
void delete_ClipMachine(struct ClipMachine *mp);

typedef int ClipFunction(struct ClipMachine *mp);
struct DBFuncTable;

/* valid type values */
enum ClipVarType
{
	UNDEF_t = 0,
	CHARACTER_t = 1,
	NUMERIC_t = 2,
	LOGICAL_t = 3,
	DATE_t = 4,
	ARRAY_t = 5,
	MAP_t = 6,
	OBJECT_t = 7,
	CCODE_t = 8,
	PCODE_t = 9,
	MEMO_t = 10,
	DATETIME_t = 11,
};

enum ClipFlags
{
	F_NONE = 0,
	F_MPTR = 1,
	F_MSTAT = 2,
	F_MREF = 3,
};

#define MACRO len

typedef struct
{
	enum ClipVarType type:4;
	unsigned len:6;
	unsigned dec:6;
	enum ClipFlags flags:2;
	unsigned count:11;
	unsigned memo:1;
	unsigned field:1;
/*	unsigned noref:1;*/
}
ClipType;

typedef struct
{
	char *buf;
	int len;
}
ClipBuf;

typedef struct
{
	void **items;
	int count;
}
ClipVect;

typedef struct
{
	long areahash;
	long fieldhash;
}
ClipFieldDef;

typedef struct
{
	ClipType t;
	union ClipVar *vp;
	ClipFieldDef *fp;
}
ClipRefVar;

typedef struct
{
	ClipType t;
	double d;
}
ClipNumVar;

typedef struct
{
	ClipType t;
	long l;
}
ClipLongVar;

typedef struct
{
	ClipType t;
	struct rational *r;
}
ClipRationalVar;

typedef struct
{
	ClipType t;
	ClipBuf str;
}
ClipStrVar;

typedef struct
{
	ClipType t;
	int val;
}
ClipLogVar;

typedef struct
{
	ClipType t;
	long julian;
}
ClipDateVar;

typedef struct
{
	ClipType t;
	long julian;
	long time;
}
ClipDateTimeVar;

typedef struct
{
	ClipType t;
	union ClipVar *items;
	unsigned long count;
	unsigned long current;
}
ClipArrVar;

typedef struct
{
	ClipType t;
	struct ClipVarEl *items;
	unsigned long count;
	unsigned long current;
}
ClipMapVar;

typedef struct ClipObjRtti
{
	const char *name;
	long hashId;
	void (*destroy) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti);
	void *(*clone) (struct ClipMachine * mp, union ClipVar * dest, union ClipVar * self);
	int (*print) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti, char **buf, int *buflen);
	int (*parse) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti, char *buf, int buflen);
	int (*save) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti, int recsize, char ***vectp, int *num);
	int (*load) (struct ClipMachine * mp, void **obj, struct ClipObjRtti * rtti, int recsize, char **vect, int num);
	int (*call) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti, long hash);
	int (*get) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti, long hash);
	int (*set) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti, long hash);
	long (*hash) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti);
	int (*cmp) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti, union ClipVar * robj);
	int (*fetch) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti, int dim);
	int (*store) (struct ClipMachine * mp, void *obj, struct ClipObjRtti * rtti, int dim);
	void *data;
}
ClipObjRtti;

typedef struct ClipObjVar
{
	ClipType t;
	void *obj;
	ClipObjRtti *rtti;
}
ClipObjVar;

struct ClipFile;
typedef struct ClipBlock
{
	struct ClipFile *file;
	char *func;
}
ClipBlock;

struct ClipVarFrame;

typedef struct
{
	ClipType t;
	union
	{
		ClipFunction *func;
		ClipBlock *block;
	}
	u;
	struct ClipVarFrame *uplocals;
}
ClipCodeVar;

typedef union ClipVar
{
	ClipType t;
	ClipNumVar n;
	ClipLongVar lv;
	ClipRationalVar r;
	ClipStrVar s;
	ClipLogVar l;
	ClipDateVar d;
	ClipObjVar o;
	ClipCodeVar c;
	ClipRefVar p;
	ClipArrVar a;
	ClipMapVar m;
	ClipDateTimeVar dt;
}
ClipVar;

typedef struct ClipVarEl
{
	ClipVar v;
	long no;
}
ClipVarEl;

typedef union
{
	ClipNumVar _v;
	ClipVar v;
}
ClipVarNum;

typedef union
{
	ClipStrVar _v;
	ClipVar v;
}
ClipVarStr;

typedef union
{
	ClipLogVar _v;
	ClipVar v;
}
ClipVarLog;

typedef union
{
	ClipCodeVar _v;
	ClipVar v;
}
ClipVarCode;

typedef struct
{
	/*const char *funcname; */
	long name;		/*const char *name; *//* first contain number */
	void /*ClipVar */ *vp;
}
ClipVarDef;

typedef struct
{
	long hash;
	long offs;
}
ClipHashBucket;

typedef struct
{
	int num;
	ClipHashBucket *buckets;
	char *mem;
}
ClipHashNames;

typedef struct ClipVarFrame
{
	int refcount;
	int size;
	ClipVar *vars;
	const char *names;
}
ClipVarFrame;


typedef struct
{
	int count;
		ClipVar *items;
}
ClipVarVect;


typedef struct ClipFrame
{
	ClipVar *stack;
	ClipVar *sp;
	const char *filename;
	int line;
	long *privates;
	ClipVarFrame *localvars;
	ClipVarDef *locals;
	ClipVarDef *statics;
	struct ClipFrame *up;
	ClipHashNames *names;
	const char *procname;
	int stklen;
		ClipVarVect *tempvars;
}
ClipFrame;



#define SYSERRLEN	128

typedef struct
{
	int top;
	int bottom;
	int left;
	int right;
}
ClipRect;

typedef struct
{
	int standard;
	int enhanced;
	int border;
	int background;
	int unselected;
	int u1;
	int u2;
	int u3;
	int u4;
	int u5;
}
ClipAttr;

typedef struct
{
	ClipRect rect;
	ClipRect format;
	int no;
	void *save;
	int shadow;		/* -1 if none */
}
ClipWindow;

/* Container */

#define _C_ITEM_TYPE_UNKNOWN	0
#define _C_ITEM_TYPE_FILE	1
#define _C_ITEM_TYPE_SQL	2
#define _C_ITEM_TYPE_RDD	3
#define _C_ITEM_TYPE_WIDGET	4
#define _C_ITEM_TYPE_REGEX	5
#define _C_ITEM_TYPE_GDLIB	6
#define _C_ITEM_TYPE_RYO	7
#define _C_ITEM_TYPE_I_INDEX	8
#define _C_ITEM_TYPE_I_ORDER	9
#define _C_ITEM_TYPE_DATETIME	10
#define _C_ITEM_TYPE_HIPER		11
#define _C_ITEM_TYPE_CORBA             12
#define _C_ITEM_TYPE_CORBA_INTERFACE   13
#define _C_ITEM_TYPE_BTREE	14
#define _C_ITEM_TYPE_GTK_TIMEOUT	15
#define _C_ITEM_TYPE_XML_PARSER	16

typedef struct
{
	void *item;
	int key;
	int type;
	void (*destroy)(void*);
}
ContainerItem;

typedef struct
{
	ContainerItem *items;
	int len;
	int key;
}
Container;

/*
 * ������ ��� ����, ��������
 * ������� ������ */
typedef struct
{
	int type;	/* type of opened file, see fileio.ch:FT_* */
	int fileno;	/* real file or socket number */
	FILE *f;	/* STDIO lib buffer */
	pid_t pid;	/* pid for pipe children process */
	int stat;	/* see fileio.ch:FS_* flags */
	int timeout;/* default timeout for eoperations */
	long hash;  /* hash code for the full file name (with path) */
	struct ClipMachine* cm;
} C_FILE;

/* Container end */

struct _RDD_DATA_VTBL_;
struct _RDD_INDEX_VTBL_;
struct _RDD_MEMO_VTBL_;

typedef struct DBDriver
{
	char id[9];
	char data[6];
	char idx[6];
	char memo[6];
} DBDriver;

typedef struct SQLDriver
{
	char id[11];
	char name[21];
	char desc[101];
	int (*connect)(struct ClipMachine*);
} SQLDriver;

typedef struct
{
		long hash;
		char *procname;
		char *filename;
	struct timeval self;
	struct timeval start;
		unsigned long callno;
		int started;
#if 0
	Coll callby;
#endif
}
ProfileBucket;

typedef struct
{
	ProfileBucket *bucket;
		unsigned long count;
}
ProfileCount;

extern int _clip_profiler;

typedef struct ClipMachine
{
	struct ClipMachine *next;
	int inited;
	int deleted;

	ClipVar *bp;
	ClipFrame *fp;
	int argc;

	ClipVar *trapVar;
	ClipVect trapTrace;

	struct _HashTable *publics;
	struct _HashTable *privates;
	struct _HashTable *spaces;

	struct _HashTable *functions;
	int main_func_level;
	ClipVect dlls;
	ClipBlock *exits;
	int nexits;
	ClipFunction **cexits;
	int ncexits;
	struct _HashTable *keys;

	int corba;

	DBDriver **dbdrivers;
	int *ndbdrivers;
	struct _RDD_DATA_VTBL_ ***data_drivers;
	int *ndata_drivers;
	struct _RDD_INDEX_VTBL_ ***idx_drivers;
	int *nidx_drivers;
	struct _RDD_MEMO_VTBL_ ***memo_drivers;
	int *nmemo_drivers;
	char *def_data_driver;
	char *def_idx_driver;
	char *def_memo_driver;
	char *def_db_driver;

	SQLDriver **sqldrivers;
	int *nsqldrivers;

	struct _HashTable *tasklocks;
	struct _HashTable *fileopens;

	int neterr;

	struct _HashTable *aliases;
	ClipVect *areas;
	ClipVect *areaStack;
	long curArea;

	void *driver;

	/* Visual FoxPro's DATETIME format */
	int hours;
	int seconds;

	unsigned long flags;
	unsigned long flags1;
	int optimizelevel;
	int m6_error;
	int index_buffer_limit;
	int lockstyle;
	int mblocksize;
	int autorder;
	char *date_format;
	int decimals;
	int fileCreateMode;
	int dirCreateMode;
	int epoch;
	char *path;
	char *defaul;
	int typeahead;
	int *kbdbuf;
	int **kbdptr;
	int lastkey;
	int cursor;
	char *altfile;
	void *out;		/* std out file */
	void *alt;
	char *extrafile;
	void *extra;
	char *prfile;
	char *real_prfile;
	void *printer;
	char *rootpath;
	int margin;
	char *delimchars;
	int msgline;
	int notcancel;
	int eventmask;

	struct Screen *screen;
	struct ScreenBase *screen_base;
	int fullscreen;
	int update;
	int inkey;
	ClipAttr attr;
	int colorSelect;       /* for colorselect function */
	int prow;
	int pcol;
	char *buf;
	int buflen;

	ClipVect history;

	struct _HashTable *store;
	ClipVar *errorblock;
	int errorlevel;
	int noerrblock;		/* don't call errorblock on errors */
	char syserr[SYSERRLEN];

	ClipWindow *windows;
	int wnum;
	ClipRect wboard;
	int wshadow;

	Container *container;
	ClipFrame *inMacro;

	struct _HashTable *hashnames;
	int print_deep;
	int print_max_deep;

	unsigned char prntbl[256];
	unsigned char prn_xlat[256];
	unsigned char term_xlat[256];

	struct _HashTable *fields;

	/* if not null, all output come here */
	struct OutBuf *obuf;
	struct OutBuf *ebuf;

	/* output to membuf (SET PRINTER TO MEMBUF) */
	struct OutBuf *pbuf;

	ClipVar *obj;
	struct _HashTable *profiler;
		ProfileBucket *pbucket;
}
ClipMachine;

#define CLIP_MAX_ERRORBLOCK_DEEP 128
#define CLIP_MAX_PRINT_DEEP 16


#define CLIP_MAX_HISTORY 32

#define MIN_NUMERIC_DIFF 0.00000000000001

extern long _hash_cur_dir[26];

#define CLIP_OS_NAME "Linux"

#define CLIP_CUR_DRIVE	0x3fffffd0

/* FILESEEK internal buffer */
#define CLIP_FSDATA_HASH_KEY 0x4ef45399		/* hashstr(CLIP_FSDATA_HASH_KEY) */

/* flags */
#define EXACT_FLAG	0x1
#define FIXED_FLAG	0x2
#define EXCLUSIVE_FLAG	0x4
#define SOFTSEEK_FLAG	0x8
#define UNIQUE_FLAG	0x10
#define DELETED_FLAG	0x20
#define CANCEL_FLAG	0x40
#define DEBUG_FLAG	0x80
#define CONSOLE_FLAG	0x100
#define ALTERNATE_FLAG	0x200
#define DEVICE_FLAG	0x400
#define EXTRA_FLAG	0x800
#define PRINTER_FLAG	0x1000
#define BELL_FLAG	0x2000
#define CONFIRM_FLAG	0x4000
#define ESCAPE_FLAG	0x8000
#define INSERT_FLAG	0x10000
#define EXIT_FLAG	0x20000
#define INTENSITY_FLAG	0x40000
#define SCOREBOARD_FLAG	0x80000
#define DELIMITERS_FLAG	0x100000
#define WRAP_FLAG	0x200000
#define MCENTER_FLAG	0x400000
#define SCROLLBREAK_FLAG 0x800000
#define CENTURY_FLAG 	0x1000000
#define RATIONAL_FLAG	0x2000000
#define TRANSLATE_FLAG	0x4000000

/* flags1 */
#define AUTOPEN_FLAG        0x1
#define OPTIMIZE_FLAG       0x2
#define MAPERR_FLAG         0x4
#define DISPBOX_FLAG        0x8
#define NOEXPAND_MACRO_FLAG 0x10
#define FOPENMODE_FLAG      0x20
#define BUFFERING_FLAG      0x40
#define MAP_FILE_FLAG       0x80
#define MULTILOCKS_FLAG     0x100
#define FLUSHOUT_FLAG	    0x200
#define UTF8TERM_FLAG	    0x400
#define IDLEINKEY_FLAG	    0x800

#define DEFAULT_COLOR "W/N,N/W,N,N,N/W"

/* cursor types */
#define SC_NONE		0
#define SC_NORMAL	1
/* lower half */
#define SC_INSERT	2
/* full block */
#define SC_SPECIAL1	3
/* upper half */
#define SC_SPECIAL2	4

ClipMachine *cur_ClipMachine();

void destroy_ClipBuf(ClipBuf * buf);
void setLen_ClipBuf(ClipBuf * buf, int newlen);

void destroy_ClipVect(ClipVect * vect);
void add_ClipVect(ClipVect * vect, void *item);
void clear_ClipVect(ClipVect * vect);
void remove_ClipVect(ClipVect * vect, int no);
void insert_ClipVect(ClipVect * vect, void *item, int pos);

typedef struct ClipFile
{
	int refCount;
	char *body;
	char *mem;
	long bodySize;
	int bodyMem;		/* 0 -> mmap, 1 -> malloc, 3 -> static mem */
	char *name;
	union ClipVar *statics;
	int staticsMem;
	int nstatics;
	long *pos;
	long *end;
	void *cargo;
	ClipHashNames *hash_names;
	ClipVarDef *staticDefs;
	int fd;
}
ClipFile;

void _clear_trap(ClipMachine * mp);

/* return codes */

#define CLIP_SUCCESS	0
#define CLIP_INVARGC	1
#define CLIP_INVARGV	2
#define CLIP_TRAP	3

/* runtime support */

extern char *_clip_progname;
extern int _clip_argc;
extern char **_clip_argv;
extern char **_clip_envp;

extern int _clip_raw_argc;
extern char **_clip_raw_argv;

int _clip_init(ClipMachine * mp, int argc, char **argv, char **envp);
void _clip_exit(void);
void _clip_signal(int sig);
extern int _clip_sig_flag;
void _clip_signal_real(int sig);

long _clip_hashstr(const char *x);
long _clip_casehashstr(const char *x);
long _clip_hashbytes(long seed, const char *bytes, int len);
long _clip_hashbytes16(long seed, const char *bytes, int len);
long _clip_hashbytes32(long seed, const char *bytes, int len);
long _clip_casehashbytes(long seed, const char *bytes, int len);
/* trim head and tail spaces */
long _clip_hashword(const char *x, int l);
long _clip_casehashword(const char *x, int l);

int _clip_isalpha(unsigned char ch);
long _clip_hash(ClipMachine * mp, ClipVar * vp);
long _clip_casehash(ClipMachine * mp, ClipVar * vp);

void *_clip_memdup(const void *src, int len);
const char *_clip_typename(ClipVar * vp);

int _clip_func(struct ClipMachine *mp, ClipFunction f, int argc, int rest, ClipVarFrame * uplocals);
int _clip_proc(struct ClipMachine *mp, ClipFunction f, int argc, int rest, ClipVarFrame * uplocals);
int _clip_func_hash(struct ClipMachine *mp, long hash, int argc, int rest, ClipVarFrame * uplocals);
int _clip_proc_hash(struct ClipMachine *mp, long hash, int argc, int rest, ClipVarFrame * uplocals);
int _clip_func_name(struct ClipMachine *mp, int argc);

int _clip_incr(struct ClipMachine *mp, void *lval, int isIncr, int isPost);

int _clip_call(struct ClipMachine *mp, int argc, long hash);
int _clip_get(struct ClipMachine *mp, long hash);
int _clip_set(struct ClipMachine *mp, long hash);

void _clip_return(ClipMachine * mp);
void _clip_pop(ClipMachine * mp);

void _clip_resume(ClipMachine * mp, int nlocals, int nreflocals);
void _clip_vresume(ClipMachine * mp, int num, ClipVar * vect);
void _clip_destroy(ClipMachine * mp, ClipVar * vp);
ClipVar *_clip_ref_destroy(ClipMachine * mp, ClipVar * vp);
void _clip_delete(ClipMachine * mp, ClipVar * vp);
int _clip_iassign(ClipMachine * mp, void *lval);
int _clip_assign(ClipMachine * mp, void *lval);
int _clip_macroassign(ClipMachine * mp, int op, int isTop, int fieldprec);
int _clip_nameassign(ClipMachine * mp, char *name, int len, ClipVar * vp, int fieldprec);
int _clip_refassign(ClipMachine * mp, void *lval, int isTop);

int _clip_clone(ClipMachine * mp, ClipVar * dest, ClipVar * src);
int _clip_mclone(struct ClipMachine *mp, ClipVar * dest, ClipVar * src);
int _clip_dup(ClipMachine * mp, ClipVar * dest, ClipVar * src);
int _clip_ref(ClipMachine * mp, void *vp, int noadd);
void _clip_unref_arr(ClipMachine * mp);
int _clip_unref(ClipMachine *mp, ClipVar *lval);
int  _clip_refmacro(ClipMachine * mp); /* direct push refvar */

int _clip_opiassign(ClipMachine * mp, void *lval, int op);
int _clip_opassign(ClipMachine * mp, void *lval, int op);
int _clip_op(ClipMachine * mp, int op);
int _clip_not(ClipMachine * mp);
int _clip_minus(ClipMachine * mp);

int _clip_log(ClipVar * vp);
long _clip_long(ClipVar * vp);
double _clip_double(ClipVar * vp);
void _clip_var_num(double num, ClipVar * vp);
void _clip_var_log(int val, ClipVar * vp);

int _clip_macro(ClipMachine * mp);
int _clip_expand(ClipMachine * mp, ClipBuf * dest, ClipBuf * src);
int _clip_strFromVar(ClipMachine * mp, ClipVar * vp, char **newstr, int *lenp);	/* return new str */
void _clip_var_str(const char *str, int len, ClipVar * vp);
int _clip_expand_var(ClipMachine * mp, ClipVar * vp);

long _clip_pop_hash(ClipMachine * mp);	/* pop stack */
long _clip_pop_shash(ClipMachine * mp);	/* pop stack case-sensitive */
ClipVar *_clip_pop_ref(ClipMachine * mp);
void _clip_pop_fieldhash(ClipMachine * mp, long *area, long *field);	/* pop stack, split to alias->field */

void _clip_memvar_private(ClipMachine * mp, long hash);
void _clip_add_private(ClipMachine * mp, long hash);
void _clip_memvar_public(ClipMachine * mp, long hash);
struct _HashTable *_clip_space(ClipMachine * mp, long space);
ClipVar *_clip_memvar_space(ClipMachine * mp, struct _HashTable *space, long hash, int newvar);
void _clip_remove_privates(ClipMachine * mp, int num,... /*long hash */ );
void _clip_vremove_privates(ClipMachine * mp, int num, long *vect);
int _clip_push(ClipMachine * mp, /*ClipVar */ void *vp);
void _clip_push_nil(ClipMachine * mp);
void _clip_push_true(ClipMachine * mp);
void _clip_push_false(ClipMachine * mp);
int _clip_push_static(ClipMachine * mp, /*ClipVar */ void *vp);
void _clip_push_hash(ClipMachine * mp, long hash);
void _clip_push_locale(ClipMachine * mp);
int _clip_push_local(ClipMachine * mp, int no);
ClipVar *_clip_ref_local(ClipMachine * mp, int no);

/* calc hash on stack top */
int _clip_calc_hash(ClipMachine * mp);
int _clip_calc_hash2(ClipMachine * mp, int rev);

/* with stack */
void _clip_sarray(ClipMachine * mp, int n);
void _clip_dimarray(ClipMachine * mp, int ndim);
void _clip_newarray(ClipMachine * mp, int n,...);
void _clip_vnewarray(ClipMachine * mp, int n, long *vect);
int _clip_store(ClipMachine * mp, int dim, int byref);
int _clip_istore(ClipMachine * mp, int dim, int byref);
int _clip_opstore(ClipMachine * mp, int dim, int op);
int _clip_opistore(ClipMachine * mp, int dim, int op);
int _clip_fetch(ClipMachine * mp, int dim);
int _clip_ifetch(ClipMachine * mp, int dim);
ClipVar *_clip_fetchref(ClipMachine * mp, int dim);

/* map access */
int _clip_map(ClipMachine * mp, ClipVar * ap);
int _clip_madd(ClipMachine * mp, ClipVar * ap, long no, ClipVar * vp);
int _clip_mdel(ClipMachine * mp, ClipVar * ap, long no);
int _clip_mind(ClipMachine * mp, ClipVar * ap, long no, int *ind);

ClipVar *_clip_mget(ClipMachine * mp, ClipVar * ap, long no);
int _clip_mtype(ClipMachine * mp, ClipVar * ap, long no);
int _clip_mputn(ClipMachine * mp, ClipVar * ap, long no, double n);
int _clip_mgetn(ClipMachine * mp, ClipVar * ap, long no, double *n);
int _clip_mgetl(ClipMachine * mp, ClipVar * ap, long no, int *n);
int _clip_mputl(ClipMachine * mp, ClipVar * ap, long no, int n);
int _clip_mputc(ClipMachine * mp, ClipVar * ap, long no, char *str, int len);
int _clip_mgetc(ClipMachine * mp, ClipVar * ap, long no, char **strp, int *lenp);

/* array access */
int _clip_array(ClipMachine * mp, ClipVar * resp, int ndim, long *dims);
int _clip_asize(ClipMachine * mp, ClipVar * ap, int ndim, long *dims);
int _clip_adel(ClipMachine * mp, ClipVar * ap, int ndim, long *dims);
int _clip_ains(ClipMachine * mp, ClipVar * ap, int ndim, long *dims);
int _clip_aset(ClipMachine * mp, ClipVar * ap, ClipVar * vp, int ndim, long *dims);
int _clip_aget(ClipMachine * mp, ClipVar * ap, ClipVar * resp, int ndim, long *dims);
ClipVar * _clip_aref(ClipMachine * mp, ClipVar * ap, int ndim, long *dims);
int _clip_aadd(ClipMachine * mp, ClipVar *ap, ClipVar * vp);

int _clip_memvar(ClipMachine * mp, long hash);
int _clip_fmemvar(ClipMachine * mp, long hash);
int _clip_memvarf(ClipMachine * mp, long hash);
int _clip_ref_fmemvar(ClipMachine * mp, long hash);
ClipVar *_clip_ref_memvar(ClipMachine * mp, long hash);
ClipVar *_clip_ref_memvar_noadd(ClipMachine * mp, long hash);
int _clip_public(ClipMachine * mp, long hash);
ClipVar *_clip_ref_public(ClipMachine * mp, long hash);
ClipVar *_clip_ref_public_noadd(ClipMachine * mp, long hash);

int _clip_is_memvar(ClipMachine * mp, long hash);
int _clip_is_private(ClipMachine * mp, long hash);
int _clip_is_public(ClipMachine * mp, long hash);

int _clip_field(ClipMachine * mp, long hash, long area);
int _clip_try_field(ClipMachine * mp, long hash);
int _clip_take_field(ClipMachine * mp, long hash, long area, ClipVar * dest);
int _clip_assign_field(ClipMachine * mp, long hash, long area);
int _clip_iassign_field(ClipMachine * mp, long hash, long area);
int _clip_push_area(ClipMachine * mp, long newarea);
int _clip_pop_area(ClipMachine * mp);
int _clip_set_area(ClipMachine * mp, long area);
void _clip_close_all(ClipMachine * mp);

int _clip_fm_assign(ClipMachine * mp, long hash);
int _clip_fm_iassign(ClipMachine * mp, long hash);

void _clip_param(ClipMachine * mp, int pno, int lno);
ClipVar *_clip_ref_param(ClipMachine * mp, int no, ClipVar * params);
void _clip_memvar_param(ClipMachine * mp, long hash, int no);

int _clip_loglevel(int newlevel);
void _clip_logg(int level, const char *fmt,...);

int _clip_register(ClipMachine * mp, ClipFunction * func, const char *name);
int _clip_register_hash(ClipMachine * mp, ClipFunction * func, long hash);
int _clip_register_block(ClipMachine * mp, ClipBlock block, long hash);

void _clip_trap(ClipMachine * mp, const char *filename, int line);
void _clip_trap_str(ClipMachine * mp, const char *filename, int line, const char *str);
int _clip_trap_operation(ClipMachine * mp, const char *filename, int line, const char *oper, ClipVar *lval);
void _clip_trap_printf(ClipMachine * mp, const char *filename, int line, const char *fmt,...);
void _clip_trap_printv(ClipMachine * mp, const char *filename, int line, const char *fmt, void *vect);
void _clip_trap_var(ClipMachine * mp, const char *filename, int line, ClipVar * var);
void _clip_trap_pop(ClipMachine * mp);
void _clip_trap_invargv(ClipMachine * mp, const char *filename, int line);

int _clip_trap_err(ClipMachine * mp, int genCode, int canDefault, int canRetry,
		   const char *subSystem, int subCode,
		   const char *operation);

struct Coll;
int _clip_load(ClipMachine * mp, const char *name, struct Coll *names, ClipVar *res);

int destroy_ClipFile(ClipMachine * mp, struct ClipFile *fp);
void delete_ClipFile(ClipMachine * mp, struct ClipFile *fp);
int _clip_first_File(struct ClipFile *file, ClipCodeVar * dest, long *hash);
int _clip_next_File(struct ClipFile *file, ClipCodeVar * dest, long *hash);

void _clip_init_Block(ClipMachine * mp, ClipBlock * dest, struct ClipFile *file, char *func);
void destroy_Block(ClipMachine * mp, ClipBlock * bp);
void _clip_dup_Block(ClipMachine * mp, ClipBlock * src, ClipBlock * dest);
int _clip_compile_Block(ClipMachine * mp, char *str, int len, ClipBlock * dest);

int _clip_code_func(ClipMachine * mp, ClipBlock * bp, int argc, int rest, ClipVarFrame * uplocals);
int _clip_code_proc(ClipMachine * mp, ClipBlock * bp, int argc, int rest, ClipVarFrame * uplocals);

void _clip_pcount(ClipMachine * mp);
void _clip_pshift(ClipMachine * mp);
int _clip_parn(ClipMachine * mp);

int _clip_cond(ClipMachine * mp, int *ip);
int _clip_tcond(ClipMachine * mp, int *ip);	/* don't pop stack */

int _clip_find_obj(ClipMachine * mp, long otype, ClipObjRtti ** rtti);

typedef struct
{
	long hash;
	ClipFunction *f;
}
ClipNameEntry;

typedef struct
{
	const char *name;
	ClipNameEntry *cfunctions;
	ClipFunction **inits;
	ClipFunction **exits;
	ClipFile **cpfiles;
	const char **pfunctions;
	ClipObjRtti **objrtti;
	struct DBFuncTable **dbdrivers;
}
ClipModule;

int _clip_register_module(ClipMachine * mp, ClipModule * modp);
struct DBFuncTable *_clip_get_driver(ClipMachine * mp, const char *driver);
int _clip_register_driver(ClipMachine * mp, struct DBFuncTable *vtbl);
int _clip_register_file(ClipMachine * mp, ClipFile * file);

int _clip_main(ClipMachine * mp, long hash, int argc, char **argv, char **envp);
int _clip_main_func(ClipMachine * mp, ClipFunction func, int argc, char **argv, char **envp);
int _clip_main_code(ClipMachine * mp, ClipBlock * block, int argc, char **argv, char **envp);

typedef struct
{
	/*ClipNameEntry _cfunctions[];*/
	ClipFunction *(*_clip_builtin)(long hash);
	ClipFunction **_inits, ****_libinits;
	ClipFunction **_exits, ****_libexits;
	const char **_pfunctions;
	struct ClipFile **_cpfiles, ****_libcpfiles;
	struct ClipObjRtti **_objrtti;
	void **_dbdrivers;
	char *CLIP_HOSTCS;
}
ClipInitStruct;

typedef struct OutBuf
{
	char *buf;
	char *end;
	char *ptr;
}
OutBuf;

void init_Buf(OutBuf * bp);
void destroy_Buf(OutBuf * bp);
void putByte_Buf(OutBuf * bp, unsigned char byte);
void putShort_Buf(OutBuf * bp, short s);
void putLong_Buf(OutBuf * bp, long l);
void putInt32_Buf(OutBuf * bp, long l);
void putDouble_Buf(OutBuf * bp, double d);
void putStr_Buf(OutBuf * bp, char *str);
void putBuf_Buf(OutBuf * bp, char *buf, int len);

void _clip_cdate(long ju, int *dd, int *mm, int *yy, int *ww);
long _clip_jdate(int dd, int mm, int yy);

/* extension system */
int _clip_parinfo(ClipMachine * mp, int num);
int _clip_parni(ClipMachine * mp, int num);
long _clip_parnl(ClipMachine * mp, int num);
double _clip_parnd(ClipMachine * mp, int num);
int _clip_parp(ClipMachine * mp, int num, int *len, int *dec);	/* return 0 on success */
char *_clip_parc(ClipMachine * mp, int num);
char *_clip_parcl(ClipMachine * mp, int num, int *len);
int _clip_parl(ClipMachine * mp, int num);
ClipVar *_clip_par(ClipMachine * mp, int num);
ClipVar *_clip_spar(ClipMachine * mp, int num);
long _clip_pardj(ClipMachine * mp, int num);	/* julian */
long _clip_pardtj(ClipMachine * mp, int num, long *time);
long _clip_pardc(ClipMachine * mp, int num, int *yy, int *mm, int *dd, int *ww);	/* calendar */

int _clip_par_isref(ClipMachine * mp, int num); /* return 1 if parameter sent by ref */
int _clip_par_assign(ClipMachine * mp, int num, ClipVar *vp);
int _clip_par_assign_str(ClipMachine * mp, int num, char *str, int str_len);
int _clip_par_assign_str_m(ClipMachine * mp, int num, char *str, int str_len); /* malloc'ed str */

void _clip_retni(ClipMachine * mp, int n);
void _clip_retnl(ClipMachine * mp, long n);
void _clip_retnd(ClipMachine * mp, double n);
void _clip_retndp(ClipMachine * mp, double n, int len, int dec);
void _clip_retc(ClipMachine * mp, char *str);
void _clip_retcn(ClipMachine * mp, char *str, int len);
void _clip_retcn_m(ClipMachine * mp, char *str, int l);		/* str is malloc'ed */
void _clip_retl(ClipMachine * mp, int l);
void _clip_retdj(ClipMachine * mp, long julian);
void _clip_retdtj(ClipMachine * mp, long julian, long time);
void _clip_retdc(ClipMachine * mp, int yy, int mm, int dd);

void _clip_retnr(ClipMachine * mp, struct rational *r, int len, int dec);

int _clip_storni(ClipMachine * mp, int n, int num, int ind);
int _clip_stornl(ClipMachine * mp, long n, int num, int ind);
int _clip_stornd(ClipMachine * mp, double n, int num, int ind);
int _clip_storclen(ClipMachine * mp, const char *str, int len, int num, int ind);
int _clip_storc(ClipMachine * mp, const char *str, int num, int ind);
int _clip_storl(ClipMachine * mp, int l, int num, int ind);
int _clip_stordj(ClipMachine * mp, long julian, int num, int ind);
int _clip_stordc(ClipMachine * mp, int yy, int mm, int dd, int num, int ind);

#define RETPTR(mp) ((mp)->bp-(mp)->argc - 1)
#define ARGPTR(mp,num) ((mp)->bp-((mp)->argc -((num)-1)))
ClipVar *_clip_unptr(ClipVar * vp);

#define _parinfo(num)	_clip_parinfo(_mp, (num))
#define _pcount()	(_mp->argc)
#define _parni(num)	_clip_parni(_mp, (num))
#define _parnl(num)	_clip_parnl(_mp, (num))
#define _parnd(num)	_clip_parnd(_mp, (num))
#define _parc(num)	_clip_parc(_mp, (num))
#define _parl(num)	_clip_parl(_mp, (num))

#define _retni(n)	_clip_retni(_mp, (n))
#define _retnl(n)	_clip_retnl(_mp, (n))
#define _retnd(n)	_clip_retnd(_mp, (n))
#define _retl(n)	_clip_retl(_mp, (n))
#define _retc(n)	_clip_retc(_mp, (n))

#define _storni(n,num)	_clip_storni(_mp, (n), (num), 0)
#define _stornl(n,num)	_clip_stornl(_mp, (n), (num), 0)
#define _stornd(n,num)	_clip_stornd(_mp, (n), (num), 0)
#define _storl(n,num)	_clip_storl(_mp, (n), (num), 0)
#define _storc(n,num)	_clip_storc(_mp, (n), (num), 0)

int _clip_invoke(ClipMachine * mp, const char *name, void *result, int result_type, const char *fmt,...);

/*
   invoke call of Clip function
   fmt set num and type of args - one char for one arg:
   fmt:    type:                C-type:
   U    UNDEF           int
   C    CHARACTER       char*
   N    NUMERIC         double
   D    DATE            long
   L    LOGICAL         int
 */

/* 128-bytes compare/transform tables */
extern unsigned char *_clip_cmptbl;
extern unsigned char *_clip_uptbl;
extern unsigned char *_clip_lowtbl;
extern unsigned char *_clip_isalpha_tbl;
extern unsigned char *_clip_pgtbl;
extern unsigned char *_clip_intbl;
extern unsigned char *_clip_outtbl;

void _clip_upstr(char *s, int len);
int _clip_toupper(int ch);
int _clip_tolower(int ch);

int _clip_close_printer(ClipMachine * mp);
int _clip_printf(ClipMachine * mp, const char *fmt,...);
int _clip_sprintf(ClipMachine * mp, const char *fmt,...);
int _clip_vsprintf(ClipMachine * mp, const char *fmt, void *vect);
int _clip_init_screen(ClipMachine * mp);
int _clip_resume_screen(ClipMachine * mp);
int _clip_str2attr(char *str, int len);
int _clip_attr2str(int attr, char *buf, int buflen, int num_format);

int _clip_cmp(ClipMachine * mp, ClipVar * lp, ClipVar * rp, int *res, int bytype);

int _clip_eval(ClipMachine * mp, ClipVar * blockp, int argc, ClipVar * stackp, ClipVar * retp);
int _clip_eval_macro(ClipMachine * mp, char *str, int len, ClipVar * dest);

int _clip_key(ClipMachine * mp, int timeout_ms /* <0 ==> unlimited wait */, int event_mask );
/* event_mask values (from inkey.ch) */
#define _CLIP_INKEY_MOVE          1   /*  Mouse movements              */
#define _CLIP_INKEY_LDOWN         2   /*  Mouse left button down       */
#define _CLIP_INKEY_LUP           4   /*  Mouse left button up         */
#define _CLIP_INKEY_RDOWN         8   /*  Mouse right button down      */
#define _CLIP_INKEY_RUP          16   /*  Mouse right button up        */
#define _CLIP_INKEY_MDOWN        32   /*  Mouse middle button down      */
#define _CLIP_INKEY_MUP          64   /*  Mouse middle button up        */
#define _CLIP_INKEY_KEYBOARD    128   /*  Keyboard events              */
#define _CLIP_INKEY_ALL         255	/* 159 */


void _clip_hash_name(ClipMachine * mp, long hash, char *buf, int buflen);

/* item MUST be malloc'ed */
void _clip_store_item(ClipMachine * mp, long hash, void *item);
void _clip_store_item_destroy(ClipMachine * mp, long hash, void *item, void (*destroy) (void *));
void _clip_free_item(ClipMachine * mp, long hash);
void _clip_remove_item(ClipMachine * mp, long hash);
void *_clip_fetch_item(ClipMachine * mp, long hash);

/* container */
void *_clip_fetch_c_item( ClipMachine *cm, int key, int type );
int _clip_destroy_c_item( ClipMachine *cm, int key, int type );
int _clip_store_c_item( ClipMachine *cm, void *item, int type, void (*destroy)(void*) );

void *_clip_fetch_c_item_type( ClipMachine *cm, int type, int *key ); /* first item of type */

#define CLIP_EPOCH_DEFAULT 1930
#define CLIP_DATEFORMAT_DEFAULT "mm/dd/yyyy"
/* if dateformat have 4th "Y" - century have "true" */
#define CLIP_CENTURY_DEFAULT 1

long _clip_str_to_date(char *str, char *format, int epoch);
char *_clip_date_to_str(long date, char *format);
void _clip_datetostr(long date, char *buf); /* as DTOS */

int _clip_ctot(ClipMachine * mp, char* ctime, long *date, long *time, char* format);
char* _clip_ttoc(ClipMachine *mp, long julian, long time, int *retlen, char* date_format, int hours, int seconds);

/* return size of matched portion; -1 if fail */
int _clip_glob_match(const char *string, const char *pattern, int caseflag);

int _clip_translate_path(ClipMachine * mp, const char *string, char *buf, int buflen);

void _clip_unix_path(char* p,int tolow);
int _clip_absolute_path(ClipMachine* cm,const char* path,char* p,int len);
int _clip_path(ClipMachine* cm,const char* fn,char* p,int len,int create);
int _dos_path(ClipMachine* cm,const char* fn,char* p,int len);

#define CLIP_UNDEF_VAR(varp)  memset((varp),0,sizeof(ClipVar))

void _clip_push_func(struct ClipMachine *mp, ClipFunction f, int nlocals, int nolocals);
void _clip_mptr(ClipMachine * mp, ClipVar * refs, int num);
void _clip_set_deleted(ClipMachine * mp, int value);

int _clip_type(ClipVar * vp);
ClipVar *_clip_vptr(ClipVar * vp);
void _clip_log_call(ClipMachine * mp);
void _clip_log_init(char *filename);
void _clip_out_log(char *buf, int len);

int _clip_errorblock(ClipMachine * mp, ClipVar * vp, int genCode);
int _clip_errorblock_res(ClipMachine * mp, ClipVar * vp, int genCode, ClipVar *res);

int _clip_call_errblock(ClipMachine * mp, int r);

/* create the Error object */
ClipVar *_clip_new_error(ClipMachine * mp,
			 const char *description, int severity,
			 int genCode, int osCode,
			 int canDefault, int canRetry, int canSubstitute,
			 int tries,
			 const char *subSystem, int subCode, const char *operation
);

void _clip_flush_log();
char *_clip_unix_name(ClipMachine * cm, char *dname);
int clip___QUIT(ClipMachine * mp);

void _clip_generr(ClipMachine * mp, int code);
const char *_clip_errname(int code);
void _clip_math_operation(ClipMachine *mp, int op, ClipVar * Lvar, ClipVar * Rvar);

int _clip_forstep(ClipMachine *mp, int *_if);
int _clip_map_first(ClipMachine * mp, int keys, int *_if);
int _clip_map_next(ClipMachine * mp, int keys, int *_if);

int _clip_get_function(ClipMachine * mp, long hash, ClipFunction ** fpp, ClipBlock ** bpp);

int _clip_restore_tty(ClipMachine *mp);
int _clip_init_tty(ClipMachine *mp);
int _clip_load_inits(ClipMachine *mp, ClipFile *file);

void _clip_swap(ClipMachine *mp, int offset); /* move sp-offset-1 to sp-1 location*/
int _clip_putenv(char *name);
int _clip_put_env(char *name, char *val);
char *_clip_getenv(char *name);
extern char *CLIPROOT;
extern char *CLIP_LOCALE_ROOT;

void _clip_add_locale(char *locale);
void _clip_locale_msg(char *module, char *msg, char **dst);
void _clip_locale_msg_plural(char *module, char *msg, char *pl, long n, char **dst);
int _clip_module_locale(char *module, char *filename);


int _clip_rddfieldno(ClipMachine * mp, int rddno, long namehash);
int _clip_rddfield(ClipMachine * mp, int rddno, int fieldno);

int _clip_line(ClipMachine *mp);
int _clip_debug(ClipMachine *mp);
void _clip_sigdebug(int sig);
void _clip_sigint(int sig);
void _clip_sigint_real(int sig);
extern FILE *_clip_dbg_in;
extern FILE *_clip_dbg_out;
void _clip_print_dbg(ClipMachine * mp, ClipVar * vp);

typedef struct VarEntry
{
	long hash;
	ClipVar var;
	struct VarEntry *next;
}
VarEntry;

void _clip_hash_buckets(ClipMachine *mp, ClipFile *file);

typedef struct
{
	char *filename;
	int line;
	char *procname;
}
ClipBreakPoint;

extern ClipBreakPoint *_clip_breakpoint;
extern int _clip_debuglevel;
extern int _clip_debugnext;
void _clip_in_breakpoint(void);
char *_clip_type_name(ClipVar * vp);
int _clip_uudecode(char *sstr, long l, char **strp, long *lenp);
int _clip_uuencode(char *sstr, long l, char **strp, long *lenp, int without_newline);

void _clip_var2str(ClipMachine * mp, ClipVar * vp, char **strp, long *lenp, int method);
void _clip_str2var(ClipMachine * mp, ClipVar * vp, char *str, long len, int method);
void _clip_dtos(double d, char *buf, int buflen, int *dp);
char * _clip_strFunc(ClipMachine * mp,ClipVar *v,int len, int dec, int pad);
int _clip_dtostr(char* buf,int len,int dec,double d,int zero);
double _clip_strtod_base(char *str, int base);
double _clip_strtod(char *str, int *decpos);
int _clip_fileStrModeToNumMode(char *mode);

int _clip_clip(ClipMachine * mp, const char *funcname, int argc, ClipVar * stackp, ClipVar * retp);
void _clip_destroy_locals(ClipMachine *mp);

int _clip_parse_name(ClipMachine * mp, char *name, int l, char **anamep, int *alp,
		char **fnamep, int *flp, long **dimp, int *ndimp);

#define CLEAR_CLIPVAR(vp) memset((vp),0,sizeof(ClipVar))

ClipFieldDef *_clip_get_fielddef(ClipMachine *mp, long areahash, long namehash);

int _clip_catstr(ClipMachine *mp, int num);
int _clip_quot(ClipMachine *mp);

int _clip_strcmp(const char *str1, const char *str2);
int _clip_strncmp(const char *str1, const char *str2, int len);
int _clip_strcasecmp(const char *str1, const char *str2);
int _clip_strncasecmp(const char *str1, const char *str2, int len);

int _clip_strnncmp(const char *str1, const char *str2, int len1, int len2);
int _clip_strnncasecmp(const char *str1, const char *str2, int len1, int len2);

const char *_clip_strstr(const char *src, int slen, const char *dst, int dlen);

extern char *_clip_hostcs;
int _clip_translate_charset(char *p1, char *p2, unsigned char *str
	, unsigned char *ostr, int len);

#ifdef USE_TASKS
	#define select(p1,p2,p3,p4,p5) clip_task_select_if(p1,p2,p3,p4,p5)
	int clip_task_select_if(int,void*,void*,void*,void*);
#endif

void _clip_init_localvars(ClipMachine *mp, ClipVarFrame **plocalvars, int num);

int _clip_creat(ClipMachine* cm,char *file, int flags, mode_t mode, int exclusive);
int _clip_open(ClipMachine* cm,char *file, int flags, mode_t mode, int exclusive);
int _clip_close(ClipMachine* cm,long hash,int fd);

#ifdef OS_CYGWIN
	struct timeval;
#endif
int _clip_select(int n, fd_set *rfds, fd_set *wfds, fd_set *efds, struct timeval *tv);
int _clip_read(C_FILE *cf, void *buf, size_t count);
int _clip_write(C_FILE *cf, void *buf, size_t count);
void destroy_c_file(void *item);

char * _clip_host_charset();

#ifndef O_BINARY
#define O_BINARY 0
#endif

void _clip_check_stack(ClipMachine *mp);

#ifdef WITH_CHECK_STACK

#define CLIP_CHECK_STACK _clip_check_stack(mp)

#else

#define CLIP_CHECK_STACK

#endif

void _clip_fullscreen(ClipMachine * mp);

char *_clip_gettext(const char *msg);

int _clip_start_profiler(ClipMachine *mp);
int _clip_stop_profiler(ClipMachine *mp);

/* for manual call */
int _clip_start_profiler_name(ClipMachine *mp, const char *procname, const char *filename);
int _clip_stop_profiler_name(ClipMachine *mp, const char *procname, const char *filename);

ClipVar * _clip_add_tempvar(ClipMachine *mp, ClipVar *vp);

#define CLIP_LOCK_FLOCK     0x01
#define CLIP_LOCK_ONEBYTE   0x00
#define CLIP_LOCK_WRITE     0x02
#define CLIP_LOCK_READ      0x00
#define CLIP_LOCK_HILEVEL   0x04
#define CLIP_LOCK_LOWLEVEL  0x00
#define CLIP_LOCK_WAIT      0x08
#define CLIP_LOCK_NOWAIT    0x00

int _clip_setlock(ClipMachine* cm,long hash,int fd,off_t pos,int flags);
int _clip_unlock(ClipMachine* cm,long hash,int fd,off_t pos,int flags);

#endif
