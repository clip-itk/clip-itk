/*
   Copyright (C) 2001  ITK
   Authors  : Uri Hnykin <uri@itk.ru>, Paul Lasarev <paul@itk.ru>, and other
   License : (GPL) http://www.itk.ru/clipper/license.html
 */
/*
   $Log: cliprt.c,v $
   Revision 1.444  2005/12/02 08:33:33  clip
   uri: small fix

   Revision 1.443  2005/08/08 09:11:39  clip
   alena: restore

   Revision 1.442  2005/08/08 09:00:30  clip
   alena: fix for gcc 4

   Revision 1.441  2005/07/28 05:57:07  clip
   alena: fix clip_ASCAN memory floating

   Revision 1.440  2005/07/25 10:23:21  clip
   alena: fix bug with "floating" memory  in functions AEVAL() and
   _clip_resume()

   Revision 1.439  2005/06/30 11:32:39  clip
   uri: small fix

   Revision 1.438  2004/12/10 10:43:28  clip
   uri: fixed memory leak in _clip_ret*() with twice call.

   Revision 1.437  2004/11/25 08:28:28  clip
   uri: fix for deleting spaces from filenames for DOS-mode files.

   Revision 1.436  2004/11/04 07:37:27  clip
   uri: some fix in numeric format with "+-" operation

   Revision 1.435  2004/11/03 10:12:35  clip
   uri: small fix about "" $ "1234"

   Revision 1.434  2004/11/01 06:39:45  clip
   uri: delete logg.

   Revision 1.433  2004/10/29 09:15:42  clip
   uri: small fix

   Revision 1.432  2004/10/28 11:47:33  clip
   uri: fix formatiing in STR(), pad*() for numeric data and constants.

   Revision 1.431  2004/10/27 14:43:56  clip
   rust: debugging SIG handler

   Revision 1.430  2004/10/25 09:24:12  clip
   uri: small fix for oget:colorSpec

   Revision 1.429  2004/10/13 12:47:37  clip
   uri: small fix for cygwin

   Revision 1.428  2004/09/30 14:37:17  clip
   rust: path parse fix

   Revision 1.426  2004/08/12 12:32:14  clip
   uri: small fix

   Revision 1.425  2004/08/12 10:21:48  clip
   uri: disable stdout buffering by default

   Revision 1.424  2004/07/05 10:12:20  clip
   alena: small bug in _storc()

   Revision 1.423  2004/07/05 09:31:20  clip
   uri: small fix in _storni()

   Revision 1.422  2004/07/05 08:31:14  clip
   uri: small fix in _storni()

   Revision 1.421  2004/06/11 10:57:32  clip
   rust: freeing MEMBUF on delete_ClipMachine()

   Revision 1.420  2004/05/20 14:41:10  clip
   rust: memory leak fixed

   Revision 1.419  2004/04/30 11:50:02  clip
   uri: add mimeTypesLoad(), mimeTypeGet(cType), mimeTypeSet(cType,cData)

   Revision 1.418  2004/04/08 15:01:46  clip
   rust: suppress call to Task_killAll() in clip___QUIT()

   Revision 1.417  2004/02/17 08:39:56  clip
   rust: missing trailing spaces in string substraction ('-' op)

   Revision 1.416  2004/02/16 13:19:53  clip
   rust: sigsegv with RDD drivers fixed

   Revision 1.415  2004/02/10 11:14:03  clip
   rust: str_str() -> _clip_strstr() with '"" $ "string"' bugfix

   Revision 1.414  2004/01/29 13:47:53  clip
   uri: small fix

   Revision 1.413  2004/01/28 13:49:00  clip
   rust: common ClipMachine->kbdbuf

   Revision 1.412  2004/01/25 10:23:40  clip
   uri: fix bug in exit procedures and inkey()

   Revision 1.411  2004/01/23 14:40:19  clip
   uri: small fix for cygwin

   Revision 1.410  2004/01/23 10:24:49  clip
   uri: small fix in find_macro

   Revision 1.409  2004/01/23 09:42:28  clip
   uri: small fix in macro_in_string

   Revision 1.408  2004/01/23 08:29:23  clip
   uri: small fix ROOTPATH for cygwin

   Revision 1.407  2004/01/16 10:04:33  clip
   uri: small fix for ROOTPATH

   Revision 1.406  2004/01/04 10:24:49  clip
   uri: add set(_SET_ROOTPATH,"rootpath") for add "rootpath" to all filenames,
	via "/var/www/htdocs" in apache.

   Revision 1.405  2003/12/20 09:02:18  clip
   uri: small fix for freeBsd

   Revision 1.404  2003/12/16 11:24:05  clip
   uri: support FoxPro syntax aVar[nElement];
	support call codeblock via function cb:={||}; cb()
	redisign error NOFUNC.

   Revision 1.403  2003/11/27 17:11:59  clip
   uri:small fix int ctod()

   Revision 1.402  2003/11/27 12:55:56  clip
   add CLIPA function
   paul

   Revision 1.401  2003/11/21 11:12:21  clip
   set operation result if errorblock return new value
   paul

   Revision 1.400  2003/11/21 06:21:16  clip
   uri: rewriting generator error for "invalid arguments for %s operation",
	for operation +-*$=%**....

   Revision 1.399  2003/11/19 11:48:25  clip
   add FLUSHOUT_FLAG, _SET_FLUSHOUT to set
   paul

   Revision 1.398  2003/11/11 11:58:16  clip
   uri: small fix: called EG_SIGNAL with first_mp

   Revision 1.397  2003/11/11 11:36:58  clip
   uri: call errorblock with EG_SIGNAL if signal from system sended

   Revision 1.396  2003/11/04 11:18:34  clip
   post signal handler
   paul

   Revision 1.395  2003/10/30 10:29:06  clip
   hash conflict in area/field pairs
   closes #159
   paul

   Revision 1.394  2003/10/13 06:08:48  clip
   uri: fix for "errorlevel(3); quit" code

   Revision 1.393  2003/10/03 09:30:22  clip
   uri: obj:onError(self,attr_name) trigger added

   Revision 1.392  2003/09/11 11:18:06  clip
   uri: small fix

   Revision 1.391  2003/09/09 14:36:15  clip
   uri: fixes for mingw from Mauricio and Uri

   Revision 1.390  2003/09/09 09:41:00  clip
   uri: sorry, removed debug info from prev fix

   Revision 1.389  2003/09/09 09:39:05  clip
   uri: small fix in dirChange()

   Revision 1.388  2003/09/08 15:06:02  clip
   uri: next step fixes for mingw from uri

   Revision 1.387  2003/09/05 12:11:52  clip
   uri: initial fixes for mingw+win32 from uri

   Revision 1.386  2003/09/02 14:27:42  clip
   changes for MINGW from
   Mauricio Abre <maurifull@datafull.com>
   paul

   Revision 1.385  2003/09/01 13:34:12  clip
   uri: fix in translate_path() for non-existing directories.

   Revision 1.384  2003/08/04 09:49:23  clip
   generate 'no variable' when call by reference
   paul

   Revision 1.383  2003/07/30 11:06:06  clip

   paul

   Revision 1.382  2003/07/03 06:10:04  clip
   fix for --static, --fullstatic and libs
   paul

   Revision 1.381  2003/07/02 12:13:27  clip
   possible fix sigsegv #141
   paul

   Revision 1.380  2003/07/01 11:32:13  clip
   fix some memleaks
   paul

   Revision 1.379  2003/06/20 08:21:25  clip
   possible fixes #144
   paul

   Revision 1.378  2003/06/14 09:56:24  clip
   uri: small fix for directory("/")

   Revision 1.377  2003/05/16 12:55:43  clip
   uri: small fix in operator "="

   Revision 1.376  2003/05/16 11:08:02  clip
   initial support for using assembler instead C
   now activated if environment variable CLIP_ASM is defined to any value
   paul

   Revision 1.375  2003/04/29 11:09:39  clip
   memleak on start()
   possibly closes #140
   paul

   Revision 1.374  2003/04/14 14:01:24  clip
   rust: bug in fclose(), reported by IstvАn FЖldi <foldii@terrasoft.hu>

   Revision 1.373  2003/04/02 10:53:19  clip
   rust: _clip_close() added

   Revision 1.372  2003/04/02 07:18:44  clip
   uri: containers for all clipMachines

   Revision 1.371  2003/04/01 07:28:12  clip
   str[x], str[x,y] syntax support
   possible closes #130
   paul

   Revision 1.370  2003/04/01 06:08:24  clip
   uri: initial support syntax 'string[pos,len]', but not work really.

   Revision 1.369  2003/03/28 11:24:52  clip
   possible fix for sigsegv in menu and mouse
   paul

   Revision 1.368  2003/03/25 10:31:13  clip
   possible fixes #133
   paul

   Revision 1.367  2003/03/21 11:49:40  clip
   rust: RDD locks with tasks (DOS compatibility)

   Revision 1.366  2003/03/20 12:22:36  clip
   uri: errorLevel() small fix.

   Revision 1.365  2003/03/12 12:50:42  clip
   rust: tasks share RDDs and subdrivers

   Revision 1.364  2003/03/06 07:16:24  clip
   uri: delete right ' ' from filenames for "set translate path on"

   Revision 1.363  2003/01/22 10:33:38  clip
   dosparam() function
   closes #111
   paul

   Revision 1.362  2003/01/21 14:05:17  clip
   license info:
   hidden flag --license print license
   file clip/registration can contain signed license info
   and must be generated by rsa-sign utilite
   paul

   Revision 1.361  2003/01/18 12:04:30  clip
   uri: small fix in oget:varget()

   Revision 1.360  2003/01/05 12:32:25  clip
   possible fixes #95,#98
   paul

   Revision 1.359  2003/01/05 10:34:22  clip
   possible fixes #98
   paul

   Revision 1.358  2002/12/31 08:03:36  clip
   assign to locals
   closes #95
   paul

   Revision 1.357  2002/12/27 12:11:37  clip
   references to arrays
   again closes #85
   paul

   Revision 1.356  2002/12/26 13:10:40  clip
   reference to local param
   possible fixes #13
   paul

   Revision 1.355  2002/12/23 13:57:47  clip
   reference to temporary object
   frame structure extended!
   closes #90
   paul

   Revision 1.354  2002/12/18 11:28:42  clip
   fix reference to array in params
   closes #85
   paul

   Revision 1.353  2002/12/11 13:09:08  clip
   clear t.memo flag on assign
   possibly closes #80
   paul

   Revision 1.352  2002/12/04 09:30:25  clip
   profile sigsegv fix
   paul

   Revision 1.351  2002/12/04 09:05:52  clip
   possible profile cleanup in _clip_eval
   paul

   Revision 1.350  2002/12/04 07:09:59  clip
   simple profiler realised
   start program with --profile will generate <progname>.pro profile
   limitations: manual written C functions are not profiled, bad accuracy
   paul

   Revision 1.349  2002/12/02 09:24:08  clip
   map obj fetch for simple name
   closes #65
   paul

   Revision 1.348  2002/11/27 14:09:14  clip
   rust: _clip_vptr(rval) to _clip_dup in _clip_[i]assign()

   Revision 1.347  2002/11/27 14:06:07  clip
   clear field flag on assign
   possible closes #63
   paul

   Revision 1.346  2002/11/19 13:36:28  clip
   sigsegv in clip_CLIP func
   closes #42
   paul

   Revision 1.345  2002/11/12 09:47:11  clip
   *** empty log message ***

   Revision 1.344  2002/11/12 09:12:17  clip
   uri: small fix for cygwin

   Revision 1.343  2002/11/10 13:20:17  clip
   fix for gcc-3.2 optimisation
   paul

   Revision 1.342  2002/10/31 16:23:24  clip
   *** empty log message ***

   Revision 1.341  2002/10/30 14:58:44  clip
   uri: small tab formatting.

   Revision 1.340  2002/10/30 14:39:32  clip
   rust: some default SETs

   Revision 1.339  2002/10/26 11:10:02  clip
   initial support for localized runtime messages
   messages are in module 'cliprt'
   paul

   Revision 1.338  2002/10/19 14:23:34  clip
   uri:small fix

   Revision 1.337  2002/10/19 14:10:52  clip
   uri: small fix

   Revision 1.336  2002/10/19 14:08:38  clip
   uri: small fix for cygwin

   Revision 1.335  2002/10/19 14:05:37  clip
   uri: hz

   Revision 1.334  2002/10/19 14:03:52  clip
   uri: small fix in _clip_absolute_path for cygwin

   Revision 1.333  2002/10/19 13:36:42  clip
   uri: small fix for cygwin in _clip_translate_path()

   Revision 1.332  2002/09/25 11:47:25  clip
   add function: loadModuleMsg(cModule, cFilename_mo) -> bResult
   predefined macro: __CLIP_MODULE__  expands to current module name as "modname"
   new accepted environment var: CLIP_LOCALE_ROOT
	used by clip, clip_msgmerge, clip_msgfmt, and at runtime
   paul

   Revision 1.331  2002/09/19 08:36:29  clip
   uri : fix bug in operator "   " != "123"

   Revision 1.330  2002/09/16 09:35:10  clip
   alexey: function _clip_host_charset()

   Revision 1.329  2002/09/11 10:05:54  clip
   '$' is now case-sensitive
   paul

   Revision 1.328  2002/08/27 13:31:57  clip
   add _clip_ref_public_noadd func
   fix for mem restore
   paul

   Revision 1.327  2002/08/07 15:07:00  clip
   uri: small fix in _clip_strnncmp

   Revision 1.326  2002/08/05 09:28:07  clip
   MAPEVAL()
   paul

   Revision 1.325  2002/08/05 08:14:59  clip
   uri: small fixes

   Revision 1.324  2002/08/05 07:25:03  clip
   Operator overloading for objects:
	'+' operator_add
	'-' operator_sub
	'*' operator_mul
	'/' operator_div
	'%' operator_mod
	'^' operator_pow
	'|' operator_or
	'&' operator_and
	'$' operator_in
	'=' operator_eq
	'==' operator_eeq
	'!=' operator_neq
	'<'  operator_lt
	'>'  operator_gt
	'<=' operator_le
	'>=' operator_ge
   paul

   Revision 1.323  2002/07/02 10:32:33  clip
   novar err in macro
   paul

   Revision 1.322  2002/05/23 13:16:10  clip
   uri: add environment CLIP_LANG as LANG processing

   Revision 1.321  2002/05/16 09:07:43  clip
   possible to disable expansion in strings:
   SET MACRO_IN_STRING OFF
   paul

   Revision 1.320  2002/05/14 08:12:25  clip
   rust: few new parameters to _clip_ttoc are added

   Revision 1.319  2002/05/12 11:19:23  clip
   rust: _clip_fetch_c_item_type() - fetches item of type

   Revision 1.318  2002/04/30 13:55:50  clip
   rust: respecting 'type weight' for 'X' fields

   Revision 1.317  2002/04/30 12:52:01  clip
   add -stack flag to configure to enable runtime stack check
   paul

   Revision 1.316  2002/04/30 09:07:18  clip
   fetch error verbose
   paul

   Revision 1.315  2002/04/30 08:59:34  clip
   try fetch from non-array verbose
   paul

   Revision 1.314  2002/04/22 15:29:55  clip
   rust: initial support of DATETIME type

   Revision 1.313  2002/04/19 13:01:08  clip
   rust: bug in _clip_path()

   Revision 1.312  2002/04/18 13:11:56  clip
   initial support for ncpfs
   paul

   Revision 1.311  2002/04/18 11:33:26  clip
   uri: num1==num2 small fixes

   Revision 1.310  2002/04/17 11:58:36  clip
   rust: _clip_path() fixed for paths like \\hostname\dir\file.ext

   Revision 1.309  2002/04/17 11:02:04  clip
   rust: _clip_path() fixed for paths like d:test.dbf

   Revision 1.308  2002/04/17 10:30:28  clip
   uri: _clip_translate_path changed for win32 paths "\\host\resource"

   Revision 1.307  2002/04/15 13:04:21  clip
   trim spaces in alias expression
   paul

   Revision 1.306  2002/04/09 10:44:47  clip
   undef ref fix
   paul

   Revision 1.305  2002/04/05 12:34:14  clip
   "&()" preproc fix
   "&a[1]" runtime fix
   vardef place
   paul

   Revision 1.304  2002/03/28 12:26:45  clip
   assign and reference change
   may be followed by lot of problems...
   paul

   Revision 1.303  2002/03/26 09:32:43  clip
   exit procedure sigsegv
   paul

   Revision 1.302  2002/03/25 10:53:46  clip
   wrong i18n messages recoding
   paul

   Revision 1.301  2002/03/22 11:31:41  clip
   dirty fix for static codeblocks
   paul

   Revision 1.300  2002/03/12 14:42:43  clip
   uri: small fixes

   Revision 1.299  2002/03/11 13:50:05  clip
   bad return on namecall fixed
   paul

   Revision 1.298  2002/03/11 09:50:21  clip
   uri: small fix in _clip_cmp for string compare.

   Revision 1.297  2002/03/10 09:21:20  clip
   uri: fixes in islower,isupper, _clip_cmp

   Revision 1.296  2002/03/06 11:27:52  clip
   string compare
   paul

   Revision 1.295  2002/02/28 08:50:10  clip
   add _SET_MAPERR
   with .t. map fetch will return NIL if no index instead of error generation
   paul

   Revision 1.294  2002/02/18 13:19:25  clip
   uri: str1-str2 bug fixed

   Revision 1.293  2002/02/09 11:58:02  clip
   codeblocks params
   paul

   Revision 1.292  2002/02/06 12:37:33  clip
   sigsegv
   paul

   Revision 1.291  2002/02/06 08:30:13  clip
   static codeblocks
   paul

   Revision 1.290  2002/02/03 10:05:37  clip
   uri: num+date; num-date; fixed

   Revision 1.289  2002/02/01 10:00:54  clip
   charset improvments
   paul

   Revision 1.288  2002/02/01 09:02:15  clip
   pgchars
   paul

   Revision 1.287  2002/01/30 13:02:06  clip
   use DLLREALSUFF instead DLLSUFF in clip_makeslib
   eval(b, @l)
   full filename in load error
   paul

   Revision 1.286  2002/01/28 13:52:35  clip
   ALTD() ignore arguments
   paul

   Revision 1.285  2002/01/28 13:43:23  clip
   add ALTD func

   ALTD(0) - disable debugging
   ALTD(1) - enable debugging
   ALTD(2) - enable debugging and wait connection

   paul

   Revision 1.284  2002/01/28 12:55:40  clip
   array by ref
   paul

   Revision 1.283  2002/01/28 09:09:24  clip
   pass array by reference
   paul

   Revision 1.282  2002/01/28 07:31:49  clip
   C/unknown charset cleanup
   paul

   Revision 1.281  2002/01/22 09:28:00  clip
   _clip_stor* funcs force change type of assigned vars
   paul

   Revision 1.280  2002/01/16 15:29:08  clip
   chinese patch
   preproc bugs
   some pseudographic chars < 32
   paul

   Revision 1.279  2002/01/08 12:24:56  clip
   error in error handler
   paul

   Revision 1.278  2002/01/08 10:01:58  clip
   break
   without parameter trap NIL
   paul

   Revision 1.277  2002/01/04 10:29:48  clip
   big module
   paul

   Revision 1.276  2001/12/26 14:35:06  clip
   container sharing
   paul

   Revision 1.275  2001/12/26 12:12:17  clip
   share container for ClipMachine's
   paul

   Revision 1.274  2001/12/22 10:31:56  clip
   uri: small fix in compare doubles

   Revision 1.273  2001/12/22 10:17:21  clip
   uri: small fix in compare double values (very small values ignored)

   Revision 1.272  2001/12/13 10:13:07  clip
   on call a(1) if no func A, try take 1st member of memvar array A
   paul

   Revision 1.271  2001/12/06 13:53:16  clip
   alexey: added CLIP_DLLEXPORT prefix to _clip_path()

   Revision 1.270  2001/11/27 11:44:46  clip
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

   Revision 1.269  2001/11/23 13:36:45  clip
   assign by ref to map/array members:
   o:a := @var
   to break reference, use:
   o:a := @nil
   paul

   Revision 1.268  2001/11/23 12:16:42  clip
   _clip_calc_hash2 defaults to -1
   paul

   Revision 1.267  2001/11/23 11:08:17  clip
   add _clip_hashword(str,len), _clip_casehashword(str,len), which trim
   str before calc hash
   paul

   Revision 1.266  2001/11/22 11:33:32  clip
   a:='test->first'
   ? field->&a
   paul

   Revision 1.265  2001/11/22 08:06:16  clip
   bug in _clip_push_shash for '0' retvalue; ==> switch .. case 0 was'nt work
   paul

   Revision 1.264  2001/11/21 09:14:32  clip
   uri: remake __setCenture & set(_SET_DATEFORMAT)

   Revision 1.263  2001/11/20 13:19:53  clip
   uri: setTxlat(), setPxlat() added

   Revision 1.262  2001/11/16 12:21:29  clip
   process env files now work with
   ?VAR=val? ....
   construction
   paul

   Revision 1.261  2001/11/14 06:38:02  clip
   fix crash on exit after START
   paul

   Revision 1.260  2001/11/13 12:31:01  clip
   share functions between tasks
   TASKID() function
   paul

   Revision 1.259  2001/11/13 10:23:19  clip
   START now share publics and hashnames
   paul

   Revision 1.258  2001/11/12 14:13:46  clip
   START(cFuncname) now work :)
   paul

   Revision 1.257  2001/11/08 14:20:55  clip
   move _clip_translate_charset into cliprt.c
   paul

   Revision 1.256  2001/11/08 14:00:07  clip
   auto recoding of i18n messages
   paul

   Revision 1.255  2001/11/08 09:49:59  clip
   alexey: add function _clip_mtype, what returns a type of map field

   Revision 1.254  2001/11/06 10:20:40  clip
   _clip_call_errblock in various points
   paul

   Revision 1.253  2001/11/02 10:51:39  clip
   type casting in _clip_path()
   rust

   Revision 1.252  2001/11/01 14:54:40  clip
   _clip_path() - makes absolute path respecting SET DEFAULT, SET PATH etc
   rust

   Revision 1.251  2001/10/30 11:56:44  clip
   initial value of public vars to .f.

   Revision 1.250  2001/10/29 11:56:34  clip
   fix for BLINK(intensitive background)
   paul

   Revision 1.249  2001/10/29 06:51:21  clip
   fix text fopen modes
   paul

   Revision 1.248  2001/10/22 07:27:51  clip
   SPARC fixes
   paul

   Revision 1.247  2001/10/17 05:42:21  clip
   uri: bug in cllip_datetostr with empty date

   Revision 1.246  2001/10/16 13:04:34  clip
   uri: add _clip_datetostr

   Revision 1.245  2001/10/11 09:56:52  clip
   uri; :)

   Revision 1.244  2001/10/11 09:12:43  clip
   uri: bug in _glob_match with pattern length < string length

   Revision 1.243  2001/10/10 10:26:17  clip
   add cmp functions with using _clip_cmptbl and stadard
   semantic, fix _clip_cmp for using one.
   _clip_strcmp
   _clip_strncmp
   _clip_strcasecmp
   _clip_strncasecmp

   Revision 1.242  2001/09/28 10:39:26  clip
   reffuncs not applied to FMemvar
   paul

   Revision 1.241  2001/09/21 10:29:15  clip
   memvar priority in macro
   paul

   Revision 1.240  2001/09/21 09:53:25  clip
   charsets handling
   paul

   Revision 1.239  2001/09/20 08:37:38  clip
   add _clip_storclen function
   From: Anton Ustyancev <anton@cinvest.chel.su>
   paul

   Revision 1.238  2001/09/12 10:50:42  clip
   stream output recoding
   paul

   Revision 1.237  2001/09/12 10:13:12  clip
   export some funcs
   paul

   Revision 1.236  2001/09/11 12:28:10  clip
   changes
   paul

   Revision 1.235  2001/09/10 05:32:05  clip
   _clip_par_*   functions
   paul

   Revision 1.234  2001/09/07 09:26:39  clip
   use cygpath
   fix fcntl
   paul

   Revision 1.233  2001/09/07 08:03:00  clip
   binding
   paul

   Revision 1.232  2001/09/07 06:31:48  clip
   dll bindings
   paul

   Revision 1.231  2001/09/06 14:01:06  clip
   -L flag
   paul

   Revision 1.230  2001/09/04 04:03:18  clip
   skip_norm preprocessor match bug with logical constants
   paul

   Revision 1.229  2001/09/03 14:48:50  clip
   absent parameters value
   paul

   Revision 1.228  2001/09/03 13:16:14  clip
   new array & field
   paul

   Revision 1.227  2001/09/03 09:56:56  clip
   refs
   paul

   Revision 1.226  2001/09/01 06:36:46  clip
   simple reference loop detection
   paul

   Revision 1.225  2001/09/01 03:50:00  clip
   possible hanged refs
   paul

   Revision 1.224  2001/08/31 08:56:14  clip
   references

   Revision 1.223  2001/08/30 15:58:39  clip
   library bindings
   paul

   Revision 1.222  2001/08/30 14:37:53  clip
   new library binding
   paul

   Revision 1.221  2001/08/28 07:14:44  clip
   LOGICAL in CODESTR
   paul

   Revision 1.220  2001/08/27 10:18:06  clip
   field flag & parameters
   paul

   Revision 1.219  2001/08/27 09:45:30  clip
   switch operator
   paul

   Revision 1.218  2001/08/26 12:42:48  clip
   reflocals
   paul

   Revision 1.217  2001/08/26 12:11:59  clip
   reflocals
   paul

   Revision 1.216  2001/08/26 11:37:00  clip
   selfref detection in local(b:=@localvar)
   paul

   Revision 1.215  2001/08/26 09:10:06  clip
   references
   paul

   Revision 1.214  2001/08/25 12:30:33  clip
   memleak in @func()
   paul

   Revision 1.213  2001/08/25 10:10:30  clip
   fix
   paul

   Revision 1.212  2001/08/25 09:07:09  clip
   privates creation/removing in macro
   paul

   Revision 1.211  2001/08/25 08:27:28  clip
   private creation in macro
   paul

   Revision 1.210  2001/08/25 08:16:55  clip
   CODESTR fixup
   paul

   Revision 1.209  2001/08/24 16:48:51  clip
   privates/paramters
   paul

   Revision 1.208  2001/08/24 15:59:00  clip
   compare fix
   paul

   Revision 1.207  2001/08/24 14:38:46  clip
   CODESTR pseudofunction
   paul

   Revision 1.206  2001/08/24 12:41:23  clip
   uri: fixed: oper != work as =, not as ==

   Revision 1.205  2001/08/24 08:42:09  clip
   multiple private/parameters operators
   paul

   Revision 1.204  2001/08/24 08:04:38  clip
   macro assign to array/map members
   paul

   Revision 1.203  2001/08/23 13:52:06  clip
   merge with NEWLOCALS
   paul

   Revision 1.199.2.16  2001/08/23 12:20:21  clip
   ISPRIVATE(cName) ->lVal
   ISPUBLIC(cName) ->lVal
   paul

   Revision 1.199.2.15  2001/08/23 10:13:42  clip
   fix field/memvar order in references
   paul

   Revision 1.199.2.14  2001/08/23 08:57:54  clip
   clear field flag in param push
   paul

   Revision 1.199.2.13  2001/08/23 07:47:38  clip
   memfix
   paul

   Revision 1.199.2.12  2001/08/22 14:31:06  clip
   fix
   paul

   Revision 1.199.2.11  2001/08/22 13:52:39  clip
   assign to field
   paul

   Revision 1.199.2.10  2001/08/22 08:45:20  clip
   fix
   paul

   Revision 1.199.2.9  2001/08/22 07:52:06  clip
   ref to macro and parameters
   paul

   Revision 1.199.2.8  2001/08/21 14:29:38  clip
   refernce to macro: b:=@&s
   paul

   Revision 1.199.2.7  2001/08/21 12:10:35  clip
   local init in codeblock, f.e.:

   local a:={1,2,3}
   cb:={|x|local(b:=a[2]),iif(x==NIL,b,b:=x)}
   ? eval(cb)
   ? a
   ? eval(cb,'dddd')
   ? a
   ?

   paul

   Revision 1.199.2.6  2001/08/21 09:33:09  clip
   runtime macro blocks {||&s}
   paul

   Revision 1.199.2.5  2001/08/21 08:29:54  clip
   reference assign (like b:=@a[1])
   paul

   Revision 1.199.2.4  2001/08/20 08:16:59  clip
   fetch from temporary array
   paul

   Revision 1.199.2.3  2001/08/16 13:41:54  clip
   fix
   paul

   Revision 1.199.2.2  2001/08/16 09:46:39  clip
   params
   paul

   Revision 1.199.2.1  2001/08/03 12:07:59  clip
   NEWLOCALS initial
   paul

   Revision 1.202  2001/08/23 04:57:35  clip
   alexey: changes in _clip_str - added *lenp=0 for non-character types

   Revision 1.201  2001/07/31 09:34:01  clip
   uri: added default value for FILE&DIR CREATE MODE

   Revision 1.200  2001/07/31 08:21:50  clip
   uri: add SET_FILECREATEMODE & SET_DIRCREATEMODE and fixed in functions

   Revision 1.199  2001/07/26 11:48:37  clip
   after
   set ('PRINTER_CHARSET', 'cp866')
   and
   set printer to asdf
   all output to printer will be recoded from CLIP_HOSTCS to PRINTER_CHARSET
   if PRINTER_CHARSET is not setted, recode from CLIP_HOSTCS to CLIP_CLIENTCS
   paul

   Revision 1.198  2001/07/24 08:20:28  clip
   alexey: function _clip_mputl added

   Revision 1.197  2001/07/05 08:51:49  clip
   uri: set exact on & right spaces

   Revision 1.196  2001/06/15 12:02:36  clip
   implement
   int _clip_storni(ClipMachine * mp, int n, int num, int ind);
   int _clip_stornl(ClipMachine * mp, long n, int num, int ind);
   int _clip_stornd(ClipMachine * mp, double n, int num, int ind);
   int _clip_storc(ClipMachine * mp, const char *str, int num, int ind);
   int _clip_storl(ClipMachine * mp, int l, int num, int ind);
   int _clip_stordj(ClipMachine * mp, long julian, int num, int ind);
   int _clip_stordc(ClipMachine * mp, int yy, int mm, int dd, int num, int ind);

   paul

   Revision 1.195  2001/06/14 10:20:13  clip
   LOADBLOCK(<cName>) -> code
   paul

   Revision 1.194  2001/06/13 13:05:47  clip
   uri: add case flag in _clip_glob_match(), fixed all calls  this functions

   Revision 1.193  2001/06/13 11:27:38  clip
   BEEP()
   stack deep bug in array init {,,,}
   paul

   Revision 1.192  2001/06/07 09:52:26  clip
   uri:bugs

   Revision 1.191  2001/06/03 13:15:15  clip
   _SET_MBLOCKSIZE added. Default is 64.
   rust

   Revision 1.190  2001/05/31 12:27:20  clip
   _clip_clip
   paul

   Revision 1.189  2001/05/30 09:45:43  clip
   for .. in .. [keys]
   paul

   Revision 1.188  2001/05/25 10:16:22  clip
   small bug in _clip_str_to_date()
   rust

   Revision 1.187  2001/05/14 13:25:42  clip
   memdebug
   paul

   Revision 1.186  2001/05/12 10:23:51  clip
   uri: ctod(" nondigitSymbols dd/mm/gg") bug translate

   Revision 1.185  2001/05/11 09:11:57  clip
   errorblock & pcode
   paul

   Revision 1.184  2001/05/11 08:36:10  clip
   replace & pcode
   paul

   Revision 1.183  2001/05/11 08:16:39  clip
   memory leak, unary minus, type with field in rt compiler
   paul

   Revision 1.182  2001/05/04 10:58:45  clip
   uri: bug in str_to_date with format as " 1. 4.  01"

   Revision 1.181  2001/05/04 08:38:26  clip
   assign_field with macro
   paul

   Revision 1.180  2001/05/04 07:05:15  clip
   procline filename
   paul

   Revision 1.179  2001/04/27 08:07:22  clip
   error handler
   paul

   Revision 1.178  2001/04/24 06:32:30  clip
   change logging format: add PID
   paul

   Revision 1.177  2001/04/23 11:55:29  clip
   break trap
   paul

   Revision 1.176  2001/04/23 10:58:54  clip
   asdf
   paul

   Revision 1.175  2001/04/23 10:27:21  clip
   runtime error
   paul

   Revision 1.174  2001/04/23 10:01:10  clip
   drop functions call in type()
   paul

   Revision 1.173  2001/04/20 09:57:32  clip
   uplocals in _clip_dup
   paul

   Revision 1.172  2001/04/20 09:48:57  clip
   uplocals in _clip_clone
   paul

   Revision 1.171  2001/04/16 07:29:39  clip
   -> ( expr_list )
   paul

   Revision 1.170  2001/04/11 07:42:57  clip
   uri: fix bug "double / 0 == nan"

   Revision 1.169  2001/04/10 12:45:43  clip
   print deep limit
   paul

   Revision 1.168  2001/04/10 12:11:19  clip
   uri: add command "set translate path"

   Revision 1.167  2001/04/09 12:11:40  clip
   _clip_cmp
   paul

   Revision 1.166  2001/04/09 11:21:07  clip
   _clip_cmp bugfix
   paul

   Revision 1.165  2001/04/09 11:12:27  clip
   ASORT,ASCAN work with mishalleous types in array
   add additional parameter to _clip_cmp
   paul

   Revision 1.164  2001/04/05 10:28:48  clip
   for date/iif
   paul

   Revision 1.163  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.162  2001/03/30 11:51:03  clip
   add copyright

   Revision 1.161  2001/03/27 11:10:58  clip
   err if map wrond map index
   paul

   Revision 1.160  2001/03/26 09:47:47  clip
   continue
   paul

   Revision 1.159  2001/03/26 05:48:16  clip
   privates
   paul

   Revision 1.158  2001/03/23 12:09:36  clip
   ASORT
   paul

   Revision 1.157  2001/03/19 10:16:21  clip
   hashnames
   paul

   Revision 1.156  2001/03/16 09:42:16  clip
   next/step cleanups
   paul

   Revision 1.155  2001/03/16 08:56:10  clip
   next command clenup
   paul

   Revision 1.154  2001/03/12 13:47:18  clip
   VAR2STR, STR2VAR funcs
   paul

   Revision 1.153  2001/03/04 12:00:57  clip
   .. in translate_path()

   Revision 1.152  2001/02/24 12:47:52  clip
   wrong dimention order in new_array
   paul

   Revision 1.151  2001/02/23 12:02:37  clip
   TYPE and no-variable
   paul

   Revision 1.150  2001/02/23 11:12:15  clip
   args processing
   paul

   Revision 1.149  2001/02/23 10:57:40  clip
   (null).log bug if --debug option
   paul

   Revision 1.148  2001/02/23 09:20:11  clip
   GLOB function
   trailing ?? are valid
   paul

   Revision 1.147  2001/02/23 07:18:59  clip
   string == bug
   paul

   Revision 1.146  2001/02/22 11:37:38  clip
   start data_command
   paul

   Revision 1.145  2001/02/22 09:53:36  clip
   dbg: expr command
   paul

   Revision 1.144  2001/02/21 12:52:59  clip
   append HASHNAME(hash) - inverce to HASHSTR(str)

   append obj:modify() trigger:
   modify(obj,hash,newval) -> real new val
   MAPMODIFY(obj, enable) switch modify processing

   paul

   Revision 1.143  2001/02/20 11:01:03  clip
   append --stop hidden option - to stop/wait debugger connection before MAIN execution
   paul

   Revision 1.142  2001/02/20 07:38:23  clip
   calls like
   s:substr(2,3)
   are now equivalent to
   substr(s,2,3)
   paul

   Revision 1.141  2001/02/19 13:38:41  clip
   argv[0] bug
   paul

   Revision 1.140  2001/02/19 13:18:37  clip
   hidden option runtime recognition, currently
   one option: --debug[=debuglevel] - to enable runtime debug connection
   paul

   Revision 1.139  2001/02/07 11:47:15  clip
   localdefs
   paul

   Revision 1.138  2001/02/06 13:07:25  clip
   hash in .po, dbg
   paul

   Revision 1.137  2001/02/01 13:05:06  clip
   debug links
   paul

   Revision 1.136  2001/01/28 13:15:26  clip
   _clip_mgetl() - get a logical value from object element

   Revision 1.135  2001/01/26 09:42:20  clip
   small bug in _clip_op(...,'E'): strcmp -> strncmp
   rust

   Revision 1.134  2000/12/26 10:03:42  clip
   load now can load .so
   -s generate .so
   paul

   Revision 1.133  2000/12/25 11:35:18  clip
   call errorblock
   paul

   Revision 1.132  2000/12/20 13:00:37  clip
   privates in macro
   paul

   Revision 1.131  2000/12/20 12:35:13  clip
   privates in macro
   empty arrays in macro
   paul

   Revision 1.130  2000/12/11 10:13:57  clip
   locale setting
   paul

   Revision 1.129  2000/12/11 09:47:15  clip
   append setlocale() call
   all libC string functions now must work correct with correct charsets
   paul

   Revision 1.128  2000/12/10 07:12:01  clip
   locale bug
   paul

   Revision 1.127  2000/12/09 12:13:28  clip
   locale
   paul

   Revision 1.126  2000/12/08 12:59:50  clip
   rus kbd and caps_lock flags

   Revision 1.125  2000/12/08 08:29:22  clip
   privates
   paul

   Revision 1.124  2000/12/07 13:01:27  clip
   privates bug
   paul

   Revision 1.123  2000/12/07 07:36:48  clip
   default BINDIR now $HOME/bin
   add set_sysvars
   paul

   Revision 1.122  2000/12/06 13:13:01  clip
   loadable charset tables. size 256
   paul

   Revision 1.121  2000/12/06 07:34:52  clip
   unicode
   paul

   Revision 1.120  2000/12/04 10:09:49  clip
   keymaps
   paul

   Revision 1.119  2000/12/02 13:47:40  clip
   CLIPROOT now may be envar
   paul

   Revision 1.118  2000/12/02 12:46:57  clip
   scancodes
   paul

   Revision 1.117  2000/11/29 08:20:39  clip
   x call
   Paul Lasarev <paul@itk.ru>

   Revision 1.116  2000/11/28 14:01:10  clip
   serg: начал прикручивать X-window на GTK,
   функции xcreatewindow, xcreatebutton

   Revision 1.115  2000/11/24 12:03:09  clip
   append _clip_mget()
   paul

   Revision 1.114  2000/11/23 12:56:18  clip
   keys, ADEL
   paul

   Revision 1.113  2000/11/23 06:50:23  clip
   load(name [,array])
   paul

   Revision 1.112  2000/11/22 14:52:19  clip
   .po now can be start with any (for example #!/usr/bin/cliprun) string
   paul

   Revision 1.111  2000/11/22 13:52:14  clip
   cpcode init sequence
   paul

   Revision 1.110  2000/11/22 13:45:14  clip

   paul

   Revision 1.109  2000/11/22 11:50:44  clip
   pcode link sequence
   paul

   Revision 1.108  2000/11/22 09:37:42  clip
   init procedure in pcode
   paul

   Revision 1.107  2000/11/21 11:31:12  clip
   io
   paul

   Revision 1.106  2000/11/20 12:59:01  clip
   10.2 default decimals
   destroy method in objs
   paul

   Revision 1.105  2000/11/20 10:36:38  clip
   ISFUNCTION(name)
   paul

   Revision 1.104  2000/11/20 09:59:04  clip
   preprocessor
   #command CMND [<a>] [SIZE <as>] OF <asd> => ....
   paul

   Revision 1.103  2000/11/08 13:49:42  clip
   serg: добавлена возможность работы с потоками в семейство fopen:
   fopen( "-|" ) - стандартный ввод
   fopen( "|-" ) - стандартный вывод
   fopen( "ls -l |" ) - на стандартном вводе вывод команды
   fopen( "| gzip > a.gz" ) - stdout через gzip складывается в файл.

   Revision 1.102  2000/11/04 11:00:11  clip
   sync_mp
   paul

   Revision 1.101  2000/10/31 09:55:02  clip
   obj['ASDF'] now equivalent to obj[`ASDF`]
   paul

   Revision 1.100  2000/10/27 10:40:56  clip
   bug in rational_adda
   from uri:

   Revision 1.99  2000/10/26 08:11:57  clip
   rationals bugs
   paul

   Revision 1.98  2000/10/25 13:33:17  clip
   memleak in < >
   Paul Lasarev <paul@itk.ru>

   Revision 1.97  2000/10/25 12:52:46  clip
   for..next
   Paul Lasarev <paul@itk.ru>

   Revision 1.96  2000/10/20 08:03:23  clip
   Вкрутил rational везде где упоминается NUMERIC_t
   может чего и осталось неотловленное, но это может быть только в тех
   местах где нет использования NUMERIC_t !!!!!
   from uri:

   Revision 1.95  2000/10/18 10:56:17  clip
   append rationals
   Paul Lasarev <paul@itk.ru>

   Revision 1.94  2000/09/27 11:30:55  clip
   small fix decimal точность
   from uri:

   Revision 1.93  2000/09/27 09:33:55  clip
   изменение точности чисел при операциях умножения и деления
   from uri:

   Revision 1.92  2000/09/06 12:16:41  clip
   rust: bug in _clip_destroy_c_item
   rustCVS: ----------------------------------------------------------------------

   Revision 1.91  2000/08/24 13:54:25  clip
   serg: container, fopen, fread, fwrite, ...

   Revision 1.90  2000/05/31 19:19:09  clip
   uri: fix NaN and Inf  for divide by 0

   Revision 1.89  2000/05/26 23:02:28  clip
   0xXXXXXXXX
   Paul Lasarev <paul@itk.ru>

   Revision 1.88  2000/05/25 19:29:38  clip
   restscreen in window
   Paul Lasarev <paul@itk.ru>

   Revision 1.87  2000/05/25 18:30:11  clip
   tmp fix sigsegv on quit
   Paul Lasarev <paul@itk.ru>

   Revision 1.86  2000/05/24 18:34:15  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.85  2000/05/24 16:56:32  clip
   bugs
   Paul Lasarev <paul@itk.ru>

   Revision 1.84  2000/05/23 23:05:38  clip
   uri: не помню чего ломал

   Revision 1.83  2000/05/23 18:59:54  clip
   append window functions
   Paul Lasarev <paul@itk.ru>

   Revision 1.82  2000/05/20 20:18:09  clip
   negative aliases
   Paul Lasarev <paul@itk.ru>

   Revision 1.81  2000/05/20 19:18:21  clip
   bug with new hashstr
   Paul Lasarev <paul@itk.ru>

   Revision 1.80  2000/05/20 18:37:30  clip
   change hash function
   append HASH_xxxx extraction into hashcode.h
   Paul Lasarev <paul@itk.ru>

   Revision 1.79  2000/05/19 21:32:08  clip
   memleak in macro
   Paul Lasarev <paul@itk.ru>

   Revision 1.78  2000/05/19 20:19:20  clip
   attr_uN init
   Paul Lasarev <paul@itk.ru>

   Revision 1.77  2000/05/19 19:37:31  clip
   &macro->field
   case-independence
   Paul Lasarev <paul@itk.ru>

   Revision 1.76  2000/05/19 18:53:11  clip
   macro in alias expression
   Paul Lasarev <paul@itk.ru>

   Revision 1.75  2000/05/16 16:22:18  clip
   memory leak
   Paul Lasarev <paul@itk.ru>

   Revision 1.74  2000/05/16 15:11:21  clip
   bad realloc in alltrim
   Paul Lasarev <paul@itk.ru>

   Revision 1.73  2000/05/12 21:39:01  clip
   fix error messages return & idx continue (axl)

   Revision 1.72  2000/05/12 19:44:35  clip
   memory leak
   Paul Lasarev <paul@itk.ru>

   Revision 1.71  2000/05/12 17:08:19  clip
   add error:syserr member
   Paul Lasarev <paul@itk.ru>

   Revision 1.70  2000/05/11 22:33:28  clip
   &xxx. expand
   Paul Lasarev <paul@itk.ru>

   Revision 1.69  2000/05/10 18:33:48  clip
   AADD now clone arrays
   terminal initialization fail only in fullscreen mode
   Paul Lasarev <paul@itk.ru>

   Revision 1.68  2000/05/06 17:23:38  clip
   paul: _clip_cmp now return in *ret <0 0 >0

   Revision 1.67  2000/05/03 19:32:36  clip
   add prefix 'clip_' to all clip functions

   Revision 1.66  2000/04/30 19:35:36  clip
   #translate; obj attributes

   Revision 1.65  2000/04/28 15:25:35  clip
   memo

   Revision 1.64  2000/04/26 22:35:45  clip
   t.memo = 0 in _clip_destroy

   Revision 1.63  2000/04/15 20:57:33  paul
   mandrake fixes

   Revision 1.62  2000/04/11 15:33:00  paul
   memo

   Revision 1.61  2000/04/10 21:42:15  paul
   field->&asdf := expr

   Revision 1.60  2000/04/07 19:59:11  paul
   clip_store_item_destroy

   Revision 1.59  2000/04/01 20:16:35  paul
   case-insensitive _clip_glob_match

   Revision 1.58  2000/03/31 17:27:51  paul
   memfile

   Revision 1.57  2000/03/31 16:53:23  paul
   memfile rw

   Revision 1.56  2000/03/30 20:57:00  axl
   _clip_translate_path -> full unix file name
   remove dbrename & dbremove from _dbf.c

   Revision 1.55  2000/03/30 18:48:23  paul
   pcount

   Revision 1.54  2000/03/30 18:13:20  paul
   fields in macro

   Revision 1.53  2000/03/30 17:04:25  paul
   param

   Revision 1.52  2000/03/30 16:50:28  paul
   param

   Revision 1.51  2000/03/30 16:25:12  paul
   PARAM

   Revision 1.50  2000/03/29 22:36:23  paul
   clip_trap_err

   Revision 1.49  2000/03/29 21:20:48  paul
   only first errblock

   Revision 1.48  2000/03/29 21:15:54  paul
   errorblock nest limited

   Revision 1.47  2000/03/29 20:43:42  paul
   break loop

   Revision 1.46  2000/03/29 19:35:10  paul
   retcode

   Revision 1.45  2000/03/29 18:26:14  paul
   errorblock

   Revision 1.44  2000/03/25 18:02:23  uri
   outlog - first parameter - as level

   Revision 1.43  2000/03/24 19:49:58  uri
   set(_SET_LOGFILE)

   Revision 1.42  2000/03/24 19:02:54  paul
   logg

   Revision 1.41  2000/03/24 18:47:55  uri
   OUTLOG

   Revision 1.40  2000/03/24 18:10:10  paul
   trace

   Revision 1.39  2000/03/24 17:28:44  paul
   call tracing

   Revision 1.38  2000/03/24 17:27:58  uri
   bug in set(_SET_LOGLEVEL) and _clip_loglevel

   Revision 1.37  2000/03/22 19:39:45  paul
   *** empty log message ***

   Revision 1.36  2000/03/22 19:22:21  paul
   *** empty log message ***

   Revision 1.35  2000/03/22 19:04:16  paul
   *** empty log message ***

   Revision 1.34  2000/03/22 18:58:14  paul
   *** empty log message ***

   Revision 1.33  2000/03/22 18:44:31  paul
   *** empty log message ***

   Revision 1.32  2000/03/22 18:38:36  paul
   set

   Revision 1.31  2000/03/22 17:11:51  paul
   parameters by reference

   Revision 1.30  2000/03/21 16:04:19  paul
   .po call before .c

   Revision 1.29  2000/03/21 14:53:27  paul
   macroassign; __FIELD__ with macroassign

   Revision 1.28  2000/03/17 16:27:24  paul
   add ISFIELD ISMEMVAR

   Revision 1.27  2000/03/14 18:19:44  paul
   add _clip_take_field, fix bug in _clip_eval_macro with simple fields

   Revision 1.26  2000/03/10 15:55:53  paul
   memory leak, xon/xoff gluk

   Revision 1.25  2000/03/09 22:24:23  paul
   mem leak

   Revision 1.24  2000/03/09 21:40:31  paul
   memdebug removed

   Revision 1.23  2000/03/09 21:02:52  paul
   memory leak with objs, clip_cmp bug

   Revision 1.22  2000/03/07 20:57:17  paul
   *** empty log message ***

   Revision 1.21  2000/03/07 20:54:59  paul
   _clip_cmp with zero string

   Revision 1.20  2000/03/06 16:54:30  paul
   gluk with absent map fields fetch

   Revision 1.19  2000/02/21 23:01:28  serg
   *** empty log message ***

   Revision 1.18  1999/12/10 21:16:38  uri
   в typename добавил MEMO_t

   Revision 1.17  1999/12/10 21:14:02  paul
   gluk in _clip_date_to_str()

   Revision 1.16  1999/12/10 17:28:32  uri
   убрал предупреждения в cliprt, добавил MEMO_t, сделал несколько misc
   функций из тулзов

   Revision 1.15  1999/12/04 21:25:36  uri
   немного *DATE* функций из тулзов

   Revision 1.14  1999/11/30 18:39:09  paul
   ref bug

   Revision 1.13  1999/11/30 18:29:39  paul
   ref bug fix

   Revision 1.12  1999/11/09 22:49:14  axl
   Created DBFMEM - dbf in memory.

   Revision 1.11  1999/10/29 19:28:31  paul
   bug in macroassign (stack was corrupted)

   Revision 1.10  1999/10/29 14:02:13  paul
   macroassign now worked

   Revision 1.9  1999/10/27 19:48:14  uri
   type & mptr

   Revision 1.8  1999/10/27 18:49:35  paul
   rptr

   Revision 1.7  1999/10/27 18:36:48  paul
   type of refvars

   Revision 1.6  1999/10/27 17:29:33  paul
   change param handling

   Revision 1.5  1999/10/26 18:38:36  paul
   fff

 */

#include "clipcfg.h"
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <signal.h>
#include <ctype.h>
#include <math.h>
#include <time.h>
#ifdef OS_MINGW
	#include <ltdl.h>
#else
	#include <dlfcn.h>
#endif
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <limits.h>

#include "clip.h"
#include "clipvm.h"
#include "hash.h"
#include "screen/screen.h"
#include "error.ch"
#include "hashcode.h"
#include "rational.h"
#include "screen/charset.h"
#include "coll.h"
#include "license.h"

#ifdef USE_TASKS
#include "task/task.h"
#endif

#define NEW(type) ((type*)calloc(sizeof(type),1))
#define NEWVECT(type,len) ((type*)calloc(sizeof(type),(len)))
#define VAR(type,var,ini) type *var=(type*)(ini)
#define NEWVAR(type,var) type *var=(type*)calloc(sizeof(type),1)
#define c_DELETE(type,var)	{destroy_##type(var);free(var);}

#define EXPAND_MACRO

#define MIN_NUMERIC_DIFF 0.00000000000001

extern CLIP_DLLEXPORT void _clip_close_all(ClipMachine * mp);
extern int clip_RDDCLOSEALL(ClipMachine * mp);

#ifdef FORCEALIGN

static long
GETLONG(void *p)
{
	long r;

	memcpy(&r, p, sizeof(r));
	return r;
}

static void
SETLONG(void *ptr, long l)
{
	memcpy(ptr, &l, sizeof(l));
}

#else

#define GETLONG(p) (*(long*)(p))
#define SETLONG(ptr,l) (*(long*)(ptr)=(l))

#endif

static ClipInitStruct *init_struct = 0;
char *_clip_hostcs = "CP437";

CLIP_DLLEXPORT void
_clip_init_struct(ClipInitStruct * sp)
{
	if (!init_struct)
		init_struct = sp;
}

static const char __file__[] = __FILE__;

int search_map(ClipVarEl * items, int count, long key, int *index);
static ClipVarEl *get_map_el(ClipMapVar * a, long no);
static void remove_private_vect(ClipMachine * mp, int num, void *vect);
static int descr_str(ClipMachine * mp, ClipVar * vp, char **str);
static void delete_ClipVarFrame(ClipMachine * mp, ClipVarFrame * localvars);

char *CLIPROOT = CLIP_ROOT;
char *CLIP_LOCALE_ROOT = CLIP_ROOT;

static VarEntry *add_private(ClipMachine * mp, long hash);
static VarEntry *fetch_var(ClipMachine * mp, long hash);

static void dup_ref(ClipVar * dest, ClipVar * src);
static ClipVar *clip_fetch(ClipMachine * mp, int dim, int push, int store, ClipVar ** mapp, long *hashp);

int _clip_profiler = 0;
static void fini_profiler(ClipMachine *mp);

/* [ ClipBuf */

void
destroy_ClipBuf(ClipBuf * buf)
{
	if (!buf)
		return;
	if (buf->buf)
		free(buf->buf);
}

void
setLen_ClipBuf(ClipBuf * buf, int newlen)
{
	buf->buf = (char *) realloc(buf->buf, newlen);
	buf->len = newlen;
}

CLIP_DLLEXPORT int
_clip_type(ClipVar * vp)
{
	int r = 0;

	if (vp)
		r = _clip_vptr(vp)->t.type;
	return r;
}

CLIP_DLLEXPORT char *
_clip_type_name(ClipVar * vp)
{
	char *rc = "U";

	if (vp)
	{
		switch (_clip_type(vp))
		{
		case NUMERIC_t:
			rc = "N";
			break;
		case CHARACTER_t:
			if (vp->t.memo)
				rc = "M";
			else
				rc = "C";
			break;
		case LOGICAL_t:
			rc = "L";
			break;
		case DATE_t:
			rc = "D";
			break;
		case DATETIME_t:
			rc = "T";
			break;
		case OBJECT_t:
			rc = "O";
			break;
		case PCODE_t:
		case CCODE_t:
			rc = "B";
			break;
		case ARRAY_t:
			rc = "A";
			break;
		case MAP_t:
			rc = "O";
			break;
		}
	}
	return rc;
}

CLIP_DLLEXPORT ClipVar *
_clip_vptr(ClipVar * vp)
{
	if (vp && vp->t.flags & F_MPTR)
		vp = _clip_vptr(vp->p.vp);
	return vp;
}

/* ] ClipBuf */
/* [ ClipVect */

void
destroy_ClipVect(ClipVect * vect)
{
	if (!vect)
		return;
	free(vect->items);
}

void
add_ClipVect(ClipVect * vect, void *item)
{
	int count = ++(vect->count);
	vect->items = realloc(vect->items, sizeof(void *) * count);

	vect->items[count - 1] = item;
}

void
clear_ClipVect(ClipVect * vect)
{
	vect->count = 0;
	free(vect->items);
	vect->items = 0;
	/*vect->items = realloc(vect->items, sizeof(void *) * 4);*/
}

void
remove_ClipVect(ClipVect * vect, int no)
{
	int count = vect->count;

	if (no < 0 || no >= count)
		return;
	vect->count = --count;
	memmove(vect->items + no, vect->items + no + 1, (count - no) * sizeof(void *));
}

void
insert_ClipVect(ClipVect * vect, void *item, int pos)
{
	int count = vect->count;

	if (pos < 0 || pos > count)
		return;
	vect->count = ++count;
	vect->items = realloc(vect->items, sizeof(void *) * count);
	memmove(vect->items + pos + 1, vect->items + pos, (count - pos - 1) * sizeof(void *));

	vect->items[pos] = item;
}

/* ] ClipVect */
/* [ ClipMachine */

static int machineCount = 0;

typedef struct
{
	long hash;
	ClipFunction *f;
	ClipBlock block;
}
FuncEntry;

static ClipMachine *cur_mp = 0;
static ClipMachine *first_mp = 0;

int
_clip_init_tty(ClipMachine * ret)
{
	int r;
	char errbuf[128];

	if (ret->screen)
	{
		restart_tty(ret->screen->base);
		return 0;
	}

	r = init_tty(ret->screen_base, 0, _clip_envp, 0, (ScreenPgChars *) _clip_pgtbl, errbuf, sizeof(errbuf));

	if (r >= 0)
	{
		ret->screen = new_Screen(ret->screen_base);
		if (r > 0)
			_clip_logg(0, "init screen: %s", errbuf);
		r = 0;
	}
	else
	{
		free(ret->screen_base);
		snprintf(ret->syserr, sizeof(ret->syserr), "%s", errbuf);
		ret->screen_base = 0;
		ret->screen = 0;
	}

	if (ret->screen)
	{
		ret->wboard.bottom = ret->windows->rect.bottom = ret->screen->base->Lines - 1;
		ret->wboard.right = ret->windows->rect.right = ret->screen->base->Columns - 1;
		ret->windows->format = ret->windows->rect;
	}

	return r;
}

int
_clip_restore_tty(ClipMachine * mp)
{
	return restore_tty(mp->screen->base);
}

static int errorlevel = 0; /* result of errorlevel() */

static HashTable *all_publics = 0;
static HashTable *all_hashnames = 0;
static HashTable *all_functions = 0;

static HashTable *all_aliases = 0;
static HashTable *all_fields = 0;
static HashTable *all_keys = 0;
static HashTable *all_store = 0;

/*
static ClipVect *all_areas = 0;
static ClipVect *all_areaStack = 0;
*/

static Container *all_container = 0;

static DBDriver *all_dbdrivers = 0;
struct _RDD_DATA_VTBL_ **all_data_drivers;
struct _RDD_INDEX_VTBL_ **all_idx_drivers;
struct _RDD_MEMO_VTBL_ **all_memo_drivers;
static int all_ndbdrivers = 0;
static int all_ndata_drivers = 0;
static int all_nidx_drivers = 0;
static int all_nmemo_drivers = 0;
static char all_def_data_driver[6];
static char all_def_idx_driver[6];
static char all_def_memo_driver[6];
static char all_def_db_driver[9];

static SQLDriver *all_sqldrivers = 0;
static int all_nsqldrivers = 0;

static HashTable *all_tasklocks = 0;
static HashTable *all_fileopens = 0;
/*static ClipWindow *all_windows = 0;*/

static int *all_kbdbuf;
static int *all_kbdptr;

int _clip_sig_flag = 0;
void _clip_signal_real(int sig);


CLIP_DLLEXPORT struct ClipMachine *
new_ClipMachine(struct Screen *screen)
{
	ClipMachine *ret;

#ifdef MEMDEBUG
	{
		static int inited = 0;

		if (!inited)
		{
			malloc_logpath = "_memdebug";
			malloc_debug(MEMDEBUG);
			inited = 1;
		}
	}
#endif

	ret = NEW(ClipMachine);
	if (all_functions)
		ret->functions = all_functions;
	else
		ret->functions = all_functions = new_HashTable();
	++machineCount;

	ret->dbdrivers      = &all_dbdrivers;
	ret->ndbdrivers     = &all_ndbdrivers;
	ret->data_drivers   = &all_data_drivers;
	ret->ndata_drivers  = &all_ndata_drivers;
	ret->idx_drivers    = &all_idx_drivers;
	ret->nidx_drivers   = &all_nidx_drivers;
	ret->memo_drivers   = &all_memo_drivers;
	ret->nmemo_drivers  = &all_nmemo_drivers;
	ret->def_data_driver = all_def_data_driver;
	ret->def_idx_driver  = all_def_idx_driver;
	ret->def_memo_driver = all_def_memo_driver;
	ret->def_db_driver   = all_def_db_driver;

	ret->sqldrivers     = &all_sqldrivers;
	ret->nsqldrivers    = &all_nsqldrivers;

	if(all_tasklocks)
		ret->tasklocks = all_tasklocks;
	else
		ret->tasklocks = all_tasklocks = new_HashTable();

	if(all_fileopens)
		ret->fileopens = all_fileopens;
	else
		ret->fileopens = all_fileopens = new_HashTable();

	if (all_publics)
		ret->publics = all_publics;
	else
		ret->publics = all_publics = new_HashTable();
	ret->privates = new_HashTable();
	ret->spaces = new_HashTable();

/*
	if (all_aliases)
		ret->aliases = all_aliases;
	else
		ret->aliases = all_aliases = new_HashTable();
*/
	ret->aliases = new_HashTable();
/*
	if (all_fields)
		ret->fields = all_fields;
	else
		ret->fields = all_fields = new_HashTable();
*/
	ret->fields = new_HashTable();

	if (all_keys)
		ret->keys = all_keys;
	else
		ret->keys = all_keys = new_HashTable();

	if (all_store)
		ret->store = all_store;
	else
		ret->store = all_store = new_HashTable();

	ret->next = first_mp;
	first_mp = ret;
	ret->decimals = 2;
	ret->fileCreateMode = _clip_fileStrModeToNumMode("664");
	ret->dirCreateMode = _clip_fileStrModeToNumMode("753");
	ret->flags = CONSOLE_FLAG+INTENSITY_FLAG;
	ret->date_format = strdup(CLIP_DATEFORMAT_DEFAULT);
	ret->rootpath = NULL;
	if (CLIP_CENTURY_DEFAULT)
		ret->flags += CENTURY_FLAG;
#ifdef _WIN32
	ret->flags1 += DISPBOX_FLAG;
#endif
	ret->epoch = CLIP_EPOCH_DEFAULT;
	ret->path = strdup(".");
	ret->defaul = strdup(".");
	ret->typeahead = 32;

	if (all_kbdbuf)
		ret->kbdbuf = all_kbdbuf;
	else
		ret->kbdbuf = all_kbdbuf = (int *) calloc(ret->typeahead,sizeof(int));

	ret->kbdptr = &all_kbdptr;
	*(ret->kbdptr) = ret->kbdbuf;

	ret->cursor = SC_NORMAL;
	ret->altfile = 0;
	ret->out = stdout;
	ret->delimchars = strdup("  ");
	ret->eventmask = _CLIP_INKEY_KEYBOARD;
	if (screen)
		ret->screen = screen;
	else
	{
		ret->screen_base = NEW(ScreenBase);
		/*_clip_init_tty(ret);
		_clip_restore_tty(ret);*/
	}
	ret->mblocksize = 64;
	ret->attr.standard = COLOR_WHITE | COLOR_BACK_BLACK;
	ret->attr.enhanced = COLOR_BLACK | COLOR_BACK_WHITE;
	ret->attr.border = COLOR_BLACK | COLOR_BACK_BLACK;
	ret->attr.background = COLOR_BLACK | COLOR_BACK_BLACK;
	ret->attr.unselected = COLOR_BLACK | COLOR_BACK_WHITE;
	ret->attr.u1 = COLOR_BLACK | COLOR_BACK_BLACK;
	ret->attr.u2 = COLOR_BLACK | COLOR_BACK_BLACK;
	ret->attr.u3 = COLOR_BLACK | COLOR_BACK_BLACK;
	ret->attr.u4 = COLOR_BLACK | COLOR_BACK_BLACK;
	ret->attr.u5 = COLOR_BLACK | COLOR_BACK_BLACK;
	ret->buf = (char *) malloc(64);
	ret->buflen = 64;
	ret->driver = init_struct->_dbdrivers[0];
	ret->syserr[0] = 0;

#if 1
	ret->windows = NEW(ClipWindow);
#else
	if (all_windows)
		ret->windows = all_windows;
	else
		ret->windows = all_windows = NEW(ClipWindow);
#endif

	ret->wnum = 0;
	if (ret->screen)
	{
		ret->wboard.bottom = ret->windows->rect.bottom = ret->screen->base->Lines - 1;
		ret->wboard.right = ret->windows->rect.right = ret->screen->base->Columns - 1;
		ret->windows->format = ret->windows->rect;
	}
	ret->wshadow = -1;
#if 1
	if (all_container)
		ret->container = all_container;
	else
		ret->container = all_container = NEW(Container);
#else
	ret->container = NEW(Container);
#endif

	if (all_hashnames)
		ret->hashnames = all_hashnames;
	else
		ret->hashnames = all_hashnames = new_HashTable();
	ret->print_max_deep = CLIP_MAX_PRINT_DEEP;
	ret->print_deep = 0;

	{
		int i;

		for (i = 0; i < 256; i++)
		{
			ret->prntbl[i] = i;
			ret->prn_xlat[i] = i;
			ret->term_xlat[i] = i;
		}
	}

/*
	if (all_areas)
	{
		ret->areas = all_areas;
		ret->areaStack = all_areaStack;
	}
	else
	{
		ret->areas = all_areas = NEW(ClipVect);
		ret->areaStack = all_areaStack = NEW(ClipVect);
	}
*/
	ret->areas = NEW(ClipVect);
	ret->areaStack = NEW(ClipVect);

	ret->index_buffer_limit = 32;

	ret->flags |= ESCAPE_FLAG;
	ret->flags |= EXCLUSIVE_FLAG;
	ret->flags |= TRANSLATE_FLAG;
	ret->flags1 |= OPTIMIZE_FLAG;

	/*
#ifdef OS_LINUX
	if (ret->out && isatty(fileno(ret->out)))
		ret->flags1 |= FLUSHOUT_FLAG;
#endif
	*/
	ret->flags1 |= FLUSHOUT_FLAG;


	return ret;
}

char *_clip_progname = 0;
int _clip_argc = 0;
char **_clip_argv = 0;
char **_clip_envp = 0;
int log_level = 1;
FILE *logg = 0;
static int exited = 0;

int _clip_raw_argc = 0;
char **_clip_raw_argv = 0;

void
_clip_exit(void)
{
	/* close all ClipMachines */

	if (exited)
		return;
	exited = 1;


	while (first_mp)
	{
		ClipMachine *mp = first_mp;

		first_mp = first_mp->next;
		delete_ClipMachine(mp);
	}
	_clip_logg(2, "exit");
	if (logg != stderr)
		fclose(logg);

#ifdef MEMDEBUG
	malloc_shutdown();
#endif

}

#define M_OFFS(base,nl,ns) ((base)+8+nl*sizeof(long)+ns*sizeof(short))

static char *
get_env(char **envp, char *name)
{
	char *s;
	int l;
	int ln = strlen(name);

	for (; envp && (s = *envp); ++envp)
	{
		l = strcspn(s, "=");
		if (ln == l && !memcmp(name, s, l))
		{
			s += l;
			if (*s)
				return s + 1;
			else
				return s;
		}
	}
	return 0;
}

CLIP_DLLEXPORT char *
_clip_getenv(char *name)
{
	char *r;

	r = get_env(_clip_envp, name);
	return r;
}

static int
put_env(char ***envp, char *name)
{
	char *s;
	char **ep;
	int l, len, ln;

	ln = strcspn(name, "=");
	for (ep = *envp, len = 0; ep && (s = *ep); ++ep, ++len)
	{
		l = strcspn(s, "=");
		if (ln == l && !memcmp(name, s, l))
		{
			/* owerwrite */
			free(s);
			*ep = strdup(name);
			return 1;
		}
	}

	*envp = (char **) realloc(*envp, (len + 2) * sizeof(char *));

	(*envp)[len] = strdup(name);
	(*envp)[len + 1] = 0;

	return 0;
}

CLIP_DLLEXPORT int
_clip_putenv(char *name)
{
	int r;

	r = put_env(&_clip_envp, name);
	return r;
}

CLIP_DLLEXPORT int
_clip_put_env(char *name, char *val)
{
	int l1 = strlen(name);
	int l2 = strlen(val);
	int r;

#ifdef OS_MINGW
	char *buf = (char *) malloc(l1 + l2 + 2);
#else
	char *buf = (char *) alloca(l1 + l2 + 2);
#endif

	memcpy(buf, name, l1);
	memcpy(buf + l1 + 1, val, l2);
	buf[l1] = '=';
	buf[l1 + l2 + 1] = 0;
	r = put_env(&_clip_envp, buf);
#ifdef OS_MINGW
	free(buf);
#endif

	return r;
}

static void
set_sysvars(void)
{
	char *e;

	e = get_env(_clip_envp, "CLIP_LOGLEVEL");
	if (e && *e)
		log_level = atoi(e);

}

static void
process_environ(char *root, char *name)
{
	char buf[256];
	FILE *file;

	snprintf(buf, sizeof(buf), "%s/%s", root, name);
	file = fopen(buf, "rt");
	if (!file)
		goto ret;
	while (fgets(buf, sizeof(buf), file))
	{
		char *s, *e, *g;
		int l;
		int overwrite = 0;

		s = buf;

		  again:
		l = strspn(s, " \t");
		s += l;
		l = strlen(s);
		if (l < 2)
			continue;
		s[l - 1] = 0;
		if (s[0] == '#')
			continue;
		if (s[0] == '+')
		{
			s++;
			overwrite = 1;
		}
		else if (s[0] == '?')
		{
			char *g1;

			s++;
			e = strchr(s, '=');
			if (e)
				*e++ = 0;
			else
				continue;
			g = strchr(e + 1, '?');
			if (g)
				*g++ = 0;
			else
				continue;
			g1 = get_env(_clip_envp, s);
			if (!g1)
				continue;
			if (strcmp(e, g1))
				continue;
			/* condition matched */
			s = g;
			goto again;
		}

		if (!overwrite)
		{
			e = strchr(s, '=');
			if (e)
				*e = 0;
			g = get_env(_clip_envp, s);
			/* don't overwrite!! */
			if (g)
				continue;
			if (e)
				*e = '=';
		}
		put_env(&_clip_envp, s);
	}

	fclose(file);
	  ret:
	set_sysvars();
}

int _clip_debuglevel = 0;

static void
debug_enable(char *opt)
{
	char *s;

	s = strchr(opt, '=');
	if (s)
		_clip_debuglevel = atoi(s + 1);
	else
		_clip_debuglevel++;
/*_clip_logg(0, "set debug level to %d", _clip_debuglevel);*/
}

static void
license_on_start(char *opt)
{
	fprintf(stdout, "%s", CLIP_LICENSE);
	exit(0);
}

static void
profile_enable(char *opt)
{
	char *s;

	s = strchr(opt, '=');
	if (s)
		_clip_profiler = atoi(s + 1);
	else
		_clip_profiler++;
/*_clip_logg(0, "set profiledebug level to %d", _clip_debuglevel);*/
}

static int need_stop = 0;

static void
breakpoint_on_start(char *opt)
{
	debug_enable("");
	need_stop = 1;
}

struct OptionAction
{
	const char *name;
	void (*action) (char *opt);
};

static struct OptionAction hidden_options[] = {
	{"--debug", debug_enable},
	{"--profile", profile_enable},
	{"--stop", breakpoint_on_start},
	{"--license", license_on_start},
};

#define HIDDEN_NUM (sizeof(hidden_options)/sizeof(struct OptionAction))

static void
process_args(int argc, char **argv, int *Argcp, char ***Argvp)
{
	int i, j;

	for (i = 0; i < argc; i++)
	{
		int found = 0;

		for (j = 0; j < HIDDEN_NUM; j++)
		{
			struct OptionAction *op;
			int l, l1;
			char *ap;

			op = hidden_options + j;
			ap = argv[i];

			l = strlen(op->name);
			l1 = strlen(ap);
			if ((l <= l1) && (l == l1 || ap[l] == '=') && !memcmp(op->name, ap, l))
			{
				op->action(ap);
				found = 1;
				break;
			}
		}
		if (!found)
		{
			int l;

			l = (*Argcp)++;
			(*Argvp) = (char **) realloc(*Argvp, sizeof(char *) * (l + 1));

			(*Argvp)[l] = argv[i];
		}
	}
}

int
_clip_init(ClipMachine * mp, int Argc, char **Argv, char **envp)
{
	char *e;
	ClipFunction **np, ****npp;
	const char **sp;
	ClipFile **fp, ****fpp;
	int ret;

	if (mp->inited)
		return 0;

	if (!init_struct)
		exit(100);

	mp->inited = 1;

	if (!logg)
		logg = stderr;

	if (!_clip_progname)
	{
		int arg_c = 0;
		char **arg_v = 0;
		char *p1, *p2;

		_clip_put_env("CLIP_HOSTCS", init_struct->CLIP_HOSTCS);

		_clip_raw_argc = Argc;
		_clip_raw_argv = Argv;

		process_args(Argc, Argv, &arg_c, &arg_v);

		_clip_argc = arg_c;
		_clip_argv = arg_v;

		e = strrchr(arg_v[0], '/');

		if (e)
			_clip_progname = e + 1;
		else
			_clip_progname = arg_v[0];

		for (; (e = *envp); ++envp)
			put_env(&_clip_envp, e);

		atexit(_clip_exit);

#ifndef OS_MINGW
		signal(SIGHUP, _clip_signal);
		signal(SIGQUIT, _clip_signal);
		signal(SIGKILL, _clip_signal);
		signal(SIGPIPE, _clip_signal);
		signal(SIGALRM, _clip_signal);
		if (_clip_debuglevel)
			signal(SIGUSR1, _clip_sigdebug);
		else
			signal(SIGUSR1, SIG_IGN);
#endif

		signal(SIGINT, _clip_sigint);
		signal(SIGILL, _clip_signal);
		signal(SIGABRT, _clip_signal);
		signal(SIGFPE, _clip_signal);
		signal(SIGSEGV, _clip_signal);
		signal(SIGTERM, _clip_signal);

		set_sysvars();

		_clip_logg(2, "start");

		/* read CLIPROOT/environment */
		e = get_env(_clip_envp, "CLIPROOT");
		if (e && *e)
			CLIPROOT = strdup(e);

		process_environ(CLIPROOT, "etc/environment");
		e = get_env(_clip_envp, "CLIP_LANG");
		if (e == NULL)
			e = get_env(_clip_envp, "LANG");
		if (e && *e)
		{
			char buf[256];

			snprintf(buf, sizeof(buf), "%s/lang", CLIPROOT);
			_clip_logg(3, "process LANG environ '%s/%s'", buf, e);
			process_environ(buf, e);
		}
		e = get_env(_clip_envp, "CHARSET");
		if (e && *e)
		{
			char buf[256];

			snprintf(buf, sizeof(buf), "%s/lang", CLIPROOT);
			_clip_logg(3, "process CHARSET environ '%s/%s'", buf, e);
			process_environ(buf, e);
		}
		e = get_env(_clip_envp, "TERM");
		if (e && *e)
		{
			char buf[256];

			snprintf(buf, sizeof(buf), "%s/term", CLIPROOT);
			_clip_logg(3, "process TERM environ '%s/%s'", buf, e);
			process_environ(buf, e);
		}

		e = _clip_getenv("CLIP_LOCALE");
		if (!e)
		{
			e = _clip_getenv("CLIP_LANG");
			if (e == NULL)
				e = _clip_getenv("LANG");
			if (e && !strcmp(e, "C"))
				e = 0;
			if (!e)
			{
				e = _clip_getenv("LC_ALL");
				if (e && !strcmp(e, "C"))
					e = 0;
			}
			if (!e)
			{
				e = _clip_getenv("LC_MESSAGES");
				if (e && !strcmp(e, "C"))
					e = 0;
			}
			if (e)
				_clip_put_env("CLIP_LOCALE", e);
		}

		e = _clip_getenv("CLIP_CLIENTCS");
		if (!e || !*e)
		{
			e = _clip_getenv("CLIP_LOCALE");
			if (e)
			{
				char *s;

				s = strrchr(e, '.');
				if (s)
					e = s + 1;
				else
					e = 0;
			}
			if (!e)
				e = _clip_getenv("CLIP_CHARSET");
			if (!e)
				e = _clip_getenv("CHARSET");
			if (e)
			{
				char *s;

				s = strdup(e);
				for (e = s; *e; e++)
					*e = tolower(*e);
				_clip_put_env("CLIP_CLIENTCS", s);
				free(s);
			}
		}
		p1 = _clip_getenv("CLIP_HOSTCS");
		p2 = _clip_getenv("CLIP_CLIENTCS");
		if (p1 && !strcasecmp(p1, "c") && p2 && strcasecmp(p2, "c"))
			_clip_put_env("CLIP_HOSTCS", p2);
		e = _clip_getenv("CLIP_HOSTCS");
		if (e && *e)
		{
			_clip_logg(3, "load charset tables '%s'", e);
			load_charset_tables(e, _clip_cmptbl, _clip_uptbl, _clip_lowtbl, _clip_isalpha_tbl, _clip_pgtbl);
			_clip_hostcs = strdup(e);
		}

		p1 = _clip_getenv("CLIP_HOSTCS");
		p2 = _clip_getenv("CLIP_CLIENTCS");
		if (p1 && p2 && strcmp(p1, p2))
		{
			cons_CharsetEntry *cs1 = 0, *cs2 = 0;
			int len1 = 0, len2 = 0;

			_clip_logg(2, "set stream io translation  %s -> %s", p1, p2);

			if (load_charset_name(p1, &cs1, &len1))
			{
				_clip_logg(0, "cannot load charset file '%s': %s", p1, strerror(errno));
			}

			if (load_charset_name(p2, &cs2, &len2))
			{
				_clip_logg(0, "cannot load charset file '%s': %s", p2, strerror(errno));
			}

			if (cs1 && cs2)
			{
				make_translation(cs1, len1, cs2, len2, _clip_outtbl);
				make_translation(cs2, len2, cs1, len1, _clip_intbl);
			}

			free(cs1);
			free(cs2);
		}

		e = get_env(_clip_envp, "CLIP_LOCALE_ROOT");
		if (e && *e)
			CLIP_LOCALE_ROOT = strdup(e);

		e = _clip_getenv("CLIP_LOCALE");
		if (e && *e)
		{
			_clip_add_locale(e);
		}
	}

	for (npp = init_struct->_libinits; *npp; ++npp)
	{
		for (np = **npp; *np; ++np)
			if ((ret = _clip_main_func(mp, *np, _clip_argc, _clip_argv, _clip_envp)))
				return ret;
	}
	for (np = init_struct->_inits; *np; ++np)
		if ((ret = _clip_main_func(mp, *np, _clip_argc, _clip_argv, _clip_envp)))
			return ret;

	for (fpp = init_struct->_libcpfiles; *fpp; ++fpp)
	{
		for (fp = **fpp; *fp; ++fp)
			_clip_register_file(mp, *fp);
	}
	for (fp = init_struct->_cpfiles; *fp; ++fp)
	{
		ClipFile *file = *fp;

		_clip_register_file(mp, file);
	}

	for (fpp = init_struct->_libcpfiles; *fpp; ++fpp)
	{
		for (fp = **fpp; *fp; ++fp)
			_clip_load_inits(mp, *fp);
	}
	for (fp = init_struct->_cpfiles; *fp; ++fp)
	{
		ClipFile *file = *fp;

		_clip_load_inits(mp, file);
	}

	for (sp = init_struct->_pfunctions; *sp; ++sp)
		if ((ret = _clip_load(mp, *sp, 0, 0)))
			return ret;

	if (need_stop)
	{
		need_stop = 0;
		_clip_in_breakpoint();
	}

	return 0;
}

int
_clip_register_file(ClipMachine * mp, ClipFile * file)
{
	char *modp = file->body;
	char *modbeg = M_OFFS(modp, 2, 0);
	long funcOffs = GETLONG(M_OFFS(modp, 7, 4));
	int funcnum = GETLONG(M_OFFS(modp, 4, 2));
	char *bp = (modbeg + funcOffs);
	int i;

	_clip_hash_buckets(mp, file);

	for (i = 0; i < funcnum; ++i, bp += 2 * sizeof(long))
	{
		long hash = GETLONG(bp);
		char *func = modbeg + GETLONG(bp + sizeof(long));
		ClipBlock block;

		block.file = file;
		block.func = func;
		if (_clip_register_block(mp, block, hash))
			++file->refCount;
	}

	return 0;
}

void
_clip_log_init(char *filename)
{
	static int inited = 0;
	char buf[256];

	if (filename == NULL)
	{
		if (inited)
			return;
		inited = 1;
		sprintf(buf, "%s.log", _clip_progname);
		logg = fopen(buf, "at");
		if (!logg)
		{
			fprintf(stderr, "cannot open log file '%s'", buf);
			logg = stderr;
		}
	}
	else
	{
		inited = 1;
		if (logg != stderr)
			fclose(logg);
		logg = fopen(filename, "at");
		if (!logg)
		{
			fprintf(stderr, "cannot open log file '%s'", buf);
			logg = stderr;
		}
	}
}

int
_clip_loglevel(int newlevel)
{
	int ret = log_level;

	if (newlevel >= 0)
		log_level = newlevel;
	return ret;
}

void
_clip_out_log(char *buf, int len)
{
	_clip_log_init(NULL);
	fwrite(buf, len, 1, logg);
}

void
_clip_flush_log()
{
	fflush(logg);
}

CLIP_DLLEXPORT void
_clip_logg(int level, const char *fmt, ...)
{
	va_list ap;
	time_t tt;
	struct tm *tp;

	if (level > log_level)
		return;

	_clip_log_init(NULL);
	if (!logg)
		goto ret;
	tt = time(0);
	tp = localtime(&tt);

	fprintf(logg, "%02d:%02d:%02d %s:%lu:%d ", tp->tm_hour, tp->tm_min, tp->tm_sec, _clip_progname,
		(unsigned long) getpid(), level);
	va_start(ap, fmt);
	vfprintf(logg, _clip_gettext(fmt), ap);
	va_end(ap);
	fputc('\n', logg);
	fflush(logg);

	  ret:
		;
}

void
_clip_signal(int sig)
{
	static int oldsig = 0;
	static int cnt = 0;

	if(cnt >= 10)
		exit(100+sig);
	if(sig == oldsig)
		cnt++;
	else
		cnt = 0;
	oldsig = sig;
	_clip_logg(0, "CLIP VM debug signal %d #%d",sig,cnt);
	_clip_sig_flag = sig;
}

void
_clip_signal_real(int sig)
{
	const char *msg;
	ClipFrame *fp;
	ClipMachine *mp;

	switch (sig)
	{
	case 0:
		return;
#ifndef OS_MINGW
	case SIGHUP:
		msg = "SIGHUP";
		break;
	case SIGQUIT:
		msg = "SIGQUIT";
		break;
	case SIGKILL:
		msg = "SIGKILL";
		break;
	case SIGPIPE:
		msg = "SIGPIPE";
		break;
	case SIGALRM:
		msg = "SIGALRM";
		break;
#endif
	case SIGINT:
		msg = "SIGINT";
		break;
	case SIGILL:
		msg = "SIGILL";
		break;
	case SIGABRT:
		msg = "SIGABRT";
		break;
	case SIGFPE:
		msg = "SIGFPE";
		break;
	case SIGSEGV:
		msg = "SIGSEGV";
		break;
	case SIGTERM:
		msg = "SIGTERM";
		break;
	default:
		msg = "UNKNOWN";
		break;
	}
	mp = first_mp; /*cur_ClipMachine();*/
	_clip_sig_flag = 0;
	_clip_trap_err(mp, EG_SIGNAL, 0, 0, "SIGNAL", sig, msg);
	_clip_call_errblock(mp, EG_SIGNAL);

	_clip_logg(0, "got signal %s, exiting...", msg);
	fprintf(stderr, "\n%s: got signal %s, exiting...\n", _clip_progname, msg);
	fflush(stderr);

	for (fp = cur_mp->fp; fp; fp = fp->up)
	{
		_clip_logg(0, "trace: file '%s' line %d", fp->filename, fp->line);
		fprintf(stderr, "trace: file '%s' line %d\n", fp->filename, fp->line);
		fflush(stderr);
	}

/*_clip_exit();*/
	exit(100 + sig);
}

ClipMachine *
cur_ClipMachine()
{
	/* thread-depend code */
	return cur_mp;
}

static VarEntry *
new_VarEntry(long hash)
{
	NEWVAR(VarEntry, ret);
	ret->hash = hash;
	return ret;
}

static void
delete_VarEntry(ClipMachine * mp, VarEntry * vp)
{
	if (!vp)
		return;
	if (vp->next)
		delete_VarEntry(mp, vp->next);
	_clip_destroy(mp, &vp->var);
	free(vp);
}

static void
delete_VarTable(ClipMachine * mp, HashTable * hp)
{
	int r;

	for (r = HashTable_first(hp); r; r = HashTable_next(hp))
	{
		VAR(VarEntry, vp, HashTable_current(hp));
		delete_VarEntry(mp, vp);
	}
	delete_HashTable(hp);
}

static void
clear_VarTable(ClipMachine * mp, HashTable * hp)
{
	int r;

	for (r = HashTable_first(hp); r; r = HashTable_next(hp))
	{
		VAR(VarEntry, vp, HashTable_current(hp));
		delete_VarEntry(mp, vp);
	}
	HashTable_clear(hp);
}

static void
delete_spaces(ClipMachine * mp, HashTable * hp)
{
	int r;

	for (r = HashTable_first(hp); r; r = HashTable_next(hp))
	{
		VAR(HashTable, vp, HashTable_current(hp));
		delete_VarTable(mp, vp);
	}
	delete_HashTable(hp);
}

static void
delete_Functions(ClipMachine * mp, HashTable * hp)
{
	int r;

	for (r = HashTable_first(hp); r; r = HashTable_next(hp))
	{
		VAR(FuncEntry, fp, HashTable_current(hp));
		/*if (!fp->f)
		   delete_ClipFile(mp, fp->block.file); */
		free(fp);
	}
	delete_HashTable(hp);
}

void
delete_ClipMachine(ClipMachine * mp)
{
	FILE *out;
	int i;
	ClipFunction **np, ****npp;
	int r;

	if (mp->deleted)
		return ;
	mp->deleted = 1;

	if (_clip_profiler)
	{
		fini_profiler(mp);
	}

	if (mp==first_mp)
		first_mp = mp->next;
	else
	{
		ClipMachine *mpp;
		for(mpp = first_mp; mpp && mpp->next; mpp = mpp->next)
		{
			if(mpp->next == mp)
			{
				mpp->next = mp->next;
				break;
			}
		}
	}

	/*if (machineCount == 1)*/
	{
		_clip_close_all(mp);
		clip_RDDCLOSEALL(mp);
	}

	for (i = mp->nexits - 1; i >= 0; --i)
	{
		_clip_main_code(mp, mp->exits + i, _clip_argc, _clip_argv, _clip_envp);
		destroy_Block(mp, mp->exits + i);
	}

	for (i = mp->ncexits - 1; i >= 0; --i)
		_clip_main_func(mp, mp->cexits[i], _clip_argc, _clip_argv, _clip_envp);

	for (npp = init_struct->_libexits; *npp; ++npp)
	{
		for (np = **npp; *np; ++np)
			_clip_main_func(mp, *np, _clip_argc, _clip_argv, _clip_envp);
	}
	for (np = init_struct->_exits; *np; ++np)
		_clip_main_func(mp, *np, _clip_argc, _clip_argv, _clip_envp);

	clear_VarTable(mp, mp->privates);
	/*clear_VarTable(mp, mp->publics);*/

	for (i = 0; i < mp->dlls.count; ++i)
#ifdef OS_MINGW
		lt_dlclose(mp->dlls.items[i]);
#else
		dlclose(mp->dlls.items[i]);
#endif

	out = (FILE *) mp->out;
	if (out != stdout)
		fclose(out);
	out = (FILE *) mp->extra;
	if (out)
		fclose(out);
	out = (FILE *) mp->alt;
	if (out)
		fclose(out);
	_clip_close_printer(mp);

	if(mp->pbuf)
	{
		destroy_Buf(mp->pbuf);
		free(mp->pbuf);
	}

	delete_VarTable(mp, mp->privates);
	delete_spaces(mp, mp->spaces);
	delete_HashTable(mp->aliases);
	delete_HashTable(mp->fields);

	if (machineCount == 1)
	{
		delete_VarTable(mp, mp->publics);
		all_publics = 0;
		all_aliases = 0;
		all_fields = 0;
		for (r = HashTable_first(mp->store); r; r = HashTable_next(mp->store))
			free(HashTable_current(mp->store));
		delete_HashTable(mp->store);
		all_store = 0;
	}

	if (machineCount == 1)
	{
		for (r = HashTable_first(mp->hashnames); r; r = HashTable_next(mp->hashnames))
			free(HashTable_current(mp->hashnames));
		delete_HashTable(mp->hashnames);
		all_hashnames = 0;
	}

	_clip_delete(mp, mp->trapVar);
	_clip_delete(mp, mp->errorblock);
	_clear_trap(mp);

/*	if (machineCount == 1)
	{*/
		destroy_ClipVect(mp->areas);
		destroy_ClipVect(mp->areaStack);
		free(mp->areas);
		free(mp->areaStack);
/*	}*/

	free(mp->date_format);
	free(mp->path);
	free(mp->defaul);
	free(mp->altfile);
	free(mp->extrafile);
	if ( mp->rootpath != NULL )
		free(mp->rootpath);
	free(mp->delimchars);
	if (machineCount == 1)
	{
		delete_Functions(mp, mp->functions);
		all_functions = 0;
	}

	free(mp->buf);

	for (i = 0; i < mp->history.count; ++i)
		free(mp->history.items[i]);

	destroy_ClipVect(&mp->history);

	free(mp->exits);
	free(mp->cexits);
	/*free(*mp->dbdrivers);*/

	if (machineCount == 1)
		free(mp->kbdbuf);

	destroy_ClipVect(&mp->dlls);

	if (mp->screen_base)
	{
		if (mp->screen)
			delete_Screen(mp->screen);
		destroy_tty(mp->screen_base);
		free(mp->screen_base);
	}

	/*if ( machineCount == 1 )*/
	{
		/*all_windows = 0;*/
		for (i = 0; i <= mp->wnum; i++)
		{
			ClipWindow *wp = mp->windows + i;

			if (wp->save)
				free(wp->save);
		}
		free(mp->windows);
	}

	--machineCount;

	free(mp);
}

CLIP_DLLEXPORT void
_clear_trap(ClipMachine * mp)
{
	int i;

	for (i = 0; i < mp->trapTrace.count; ++i)
		free(mp->trapTrace.items[i]);
	clear_ClipVect(&mp->trapTrace);
}

CLIP_DLLEXPORT void
_clip_log_call(ClipMachine * mp)
{
	ClipFrame *fp = mp->fp;
	if (_clip_profiler)
		_clip_start_profiler(mp);

	if (log_level >= 5)
	{
		_clip_logg(5, "C call: proc '%s' file '%s' line %d", fp->procname ? fp->procname : "unknown", fp->filename,
			   fp->line);
	}
}

CLIP_DLLEXPORT int
_clip_errorblock(ClipMachine * mp, ClipVar * vp, int genCode)
{
	int r;
	ClipVar res;
	memset(&res, 0, sizeof(res));

	r = _clip_errorblock_res(mp, vp, genCode, &res);

	_clip_destroy(mp, &res);

	if (!r)
		r = _clip_log(&res);
	else
		r = 0;


	return 0;
}


CLIP_DLLEXPORT int
_clip_errorblock_res(ClipMachine * mp, ClipVar * vp, int genCode, ClipVar *res)
{
	int r;

	if (mp->noerrblock)
		return 0;

	/* default err handler */
	if (!mp->errorblock || (_clip_type(mp->errorblock) != CCODE_t && _clip_type(mp->errorblock) != PCODE_t))
	{
		char *msg = 0;
		int i;

		descr_str(mp, vp, &msg);
		if (!msg)
			msg = "unknown runtime error";
		printf("\n%s: system errorblock:\n", _clip_progname);
		printf("%s: runtime error: %s\n", _clip_progname, msg);
		_clip_logg(0, "%s: systerm errorblock: runtime error: %s", _clip_progname, msg);
		for (i = 0; i < mp->trapTrace.count; ++i)
		{
			printf("trace: %s\n", (char *) mp->trapTrace.items[i]);
			_clip_logg(0, "trace: %s", (char *) mp->trapTrace.items[i]);
		}
		clip___QUIT(mp);
	}

	mp->errorlevel++;
	if (mp->errorlevel > CLIP_MAX_ERRORBLOCK_DEEP)
	{
		int i;

		printf("%s: errorblock nested too deep (%d):\n", _clip_progname, CLIP_MAX_ERRORBLOCK_DEEP);
		_clip_logg(0, "%s: errorblock nested too deep (%d): ", _clip_progname, CLIP_MAX_ERRORBLOCK_DEEP);
		for (i = 0; i < mp->trapTrace.count; ++i)
		{
			printf("trace: %s\n", (char *) mp->trapTrace.items[i]);
			_clip_logg(0, "trace: %s", (char *) mp->trapTrace.items[i]);
		}

		clip___QUIT(mp);
	}


	if (_clip_type(vp) == MAP_t)
	{
		double d = 0;

		_clip_mgetn(mp, vp, HASH_gencode, &d);
		if (d == 0.0)
		{
			_clip_var_num(genCode, res);
			_clip_madd(mp, vp, HASH_gencode, res);
			_clip_destroy(mp, res);
		}
	}

	r = _clip_eval(mp, mp->errorblock, 1, vp, res);
	mp->errorlevel--;

	return r;
}

static int
do_call(ClipMachine * mp, ClipFunction f, int argc, int isProc, int rest, ClipVarFrame * uplocals)
{
	int ret, _argc = mp->argc;
	ClipFrame *fp = mp->fp;
	ClipVar *bp = mp->bp;
	ClipVarFrame *s_up = mp->fp->localvars;

	mp->argc = argc;
	mp->bp = fp->sp;
	if (uplocals)
		mp->fp->localvars = uplocals;

	if (_clip_profiler)
	{
		_clip_stop_profiler(mp);
	}

	if (log_level >= 6)
	{
		_clip_logg(6, "C call from: proc '%s' file '%s' line %d", fp->procname ? fp->procname : "unknown", fp->filename,
			   fp->line);
	}

	for (;;)
	{
		int dnext = 0;

		if (_clip_debuglevel)
		{
			dnext = _clip_debugnext;
			/*printf("-dnext=%d line %d\n", dnext, fp->line); */
			_clip_debug(mp);
		}

#ifdef USE_TASKS
		Task_yield();
#endif

		ret = f(mp);

		if (_clip_sig_flag)
			_clip_signal_real(_clip_sig_flag);

		if (_clip_debuglevel)
		{
			/*printf("+dnext=%d _clip_debugnext=%d line %d\n", dnext, _clip_debugnext, fp->line); */
			if (!dnext && _clip_debugnext)
			{
				_clip_debugnext = 0;
/*_clip_debug(mp);*/
			}
		}

		if (log_level >= 6)
			_clip_logg(6, "C return=%d to: proc '%s' file '%s' line %d", ret,
				   fp->procname ? fp->procname : "unknown", fp->filename, fp->line);

		if (!ret)
			break	;

		if (!mp->trapVar)
			_clip_generr(mp, ret);

		if (ret < 0)
			break;

		if (!_clip_errorblock(mp, mp->trapVar, ret))
		{
			ret = -ret;
			break;
		}
		mp->argc = _argc;
		mp->fp = fp;
		mp->bp = bp;
		mp->fp->localvars = s_up;
	}

	mp->argc = _argc;
	mp->fp = fp;
	mp->bp = bp;
	mp->fp->localvars = s_up;

	if (isProc)
		++argc;
	for (; argc; --argc)
	{
		--(fp->sp);
		_clip_destroy(mp, fp->sp);
	}

	if (_clip_profiler)
	{
		_clip_start_profiler(mp);
		mp->pbucket->callno--;
	}

	return ret;
}

static void
init_profiler(ClipMachine *mp)
{
	if(mp->profiler)
		return;

	mp->profiler = new_HashTable();
}


#if 0
static void
delete_profile_bucket(void *bpp)
{
	ProfileBucket *bp = (ProfileBucket*) bpp;
	if (!bp)
		return;
	free(bp->procname);
	free(bp->filename);
#if 0
	destroy_Coll(&(bp->callby));
#endif
	free(bp);
}

static int
cmp_profile_bucket(void *p1, void *p2)
{
	long h1 = ((ProfileBucket *)p1)->hash;
	long h2 = ((ProfileBucket *)p2)->hash;
	if (h1<h2)
		return -1;
	else if (h1>h2)
		return 1;
	else
		return 0;
}

#endif

static ProfileBucket *
find_profile_bucket_name(ClipMachine *mp, const char *procname, const char *filename)
{
	long hash;
	ProfileBucket *bp;

	hash = _clip_casehashbytes(0, procname, strlen(procname));
	hash = _clip_casehashbytes(hash, filename, strlen(filename));

	init_profiler(mp);
	bp = (ProfileBucket*) HashTable_fetch(mp->profiler, hash);
	if (!bp)
	{
		bp = NEW(ProfileBucket);
		bp->hash = hash;
		bp->procname = strdup(procname);
		bp->filename = strdup(filename);
#if 0
		init_Coll(&bp->callby, delete_profile_bucket, cmp_profile_bucket);
#endif
		HashTable_insert(mp->profiler, bp, hash);
	}

	return bp;
}

static ProfileBucket *
find_profile_bucket(ClipMachine *mp)
{
	const char *fs = "", *ps = "";

	if (mp->fp && mp->fp->procname)
		ps = mp->fp->procname;
	if (mp->fp && mp->fp->filename)
		fs = mp->fp->filename;

	return find_profile_bucket_name(mp, ps, fs);
}

#ifndef timer_add
#define	timer_add(a, b, result)							  \
  do {										  \
	(result)->tv_sec = (a)->tv_sec + (b)->tv_sec;				  \
	(result)->tv_usec = (a)->tv_usec + (b)->tv_usec;				  \
	if ((result)->tv_usec >= 1000000)						  \
	  {										  \
	++(result)->tv_sec;							  \
	(result)->tv_usec -= 1000000;						  \
	  }										  \
  } while (0)
#endif

#ifndef timer_sub
#define timer_sub(a, b, result) \
   do {                         \
	   (result)->tv_sec = (a)->tv_sec - (b)->tv_sec;     \
	   (result)->tv_usec = (a)->tv_usec - (b)->tv_usec;  \
	   if ((result)->tv_usec < 0) {                      \
		  --(result)->tv_sec;                        \
		  (result)->tv_usec += 1000000;              \
	   }                                                 \
   } while (0)
#endif



static int
start_profiler(ClipMachine *mp, ProfileBucket *bp)
{
	ProfileBucket *pbp;
	struct timeval tv;

	pbp = mp->pbucket;

	if(mp->pbucket && mp->pbucket->started)
		_clip_stop_profiler(mp);

	if (bp->started)
	{
		mp->pbucket = bp;
		_clip_stop_profiler(mp);
	}

	gettimeofday(&tv, 0);
	bp->start = tv;
	mp->pbucket = bp;
	bp->started = 1;
	bp->callno ++;

	return 0;
}

int CLIP_DLLEXPORT
_clip_start_profiler(ClipMachine *mp)
{
	ProfileBucket *bp;

	bp = find_profile_bucket(mp);

	return start_profiler(mp, bp);
}

int CLIP_DLLEXPORT
_clip_start_profiler_name(ClipMachine *mp, const char *procname, const char *filename)
{
	ProfileBucket *bp;

	if (!_clip_profiler)
		return 0;

	bp = find_profile_bucket_name(mp, procname, filename);

	return start_profiler(mp, bp);
}

static int
stop_profiler(ClipMachine *mp, ProfileBucket *bp, struct timeval *tv)
{
	struct timeval dt, rt;

	if (!bp->started)
		return 0;

	timer_sub(tv, &bp->start, &dt);

	timer_add(&bp->self, &dt, &rt);
	bp->self = rt;
	bp->started = 0;

	return 0;
}

int CLIP_DLLEXPORT
_clip_stop_profiler(ClipMachine *mp)
{
	struct timeval tv;
	ProfileBucket *bp;

	gettimeofday(&tv, 0);
	bp = mp->pbucket;
	if (!bp)
		bp = find_profile_bucket(mp);

	return stop_profiler(mp, bp, &tv);
}

int CLIP_DLLEXPORT
_clip_stop_profiler_name(ClipMachine *mp, const char *procname, const char *filename)
{
	struct timeval tv;
	ProfileBucket *bp;

	if (!_clip_profiler)
		return 0;

	gettimeofday(&tv, 0);
	bp = find_profile_bucket_name(mp, procname, filename);

	return stop_profiler(mp, bp, &tv);
}

static int
cmp_profile_out(void *p1, void *p2)
{
	ProfileBucket *bp1 = (ProfileBucket*) p1;
	ProfileBucket *bp2 = (ProfileBucket*) p2;

	if (bp1->self.tv_sec > bp2->self.tv_sec)
		return -1;
	else if (bp1->self.tv_sec < bp2->self.tv_sec)
		return 1;
	else if (bp1->self.tv_usec > bp2->self.tv_usec)
		return -1;
	else if (bp1->self.tv_usec < bp2->self.tv_usec)
		return 1;
	else
		return 0;
#if 0
	{
	int r;
	r = strcasecmp(bp1->procname, bp2->procname);
	if (r)
		return r;
	r = strcasecmp(bp1->filename, bp2->filename);
	return r;
	}
#endif
}

static void
fini_profiler(ClipMachine *mp)
{
	Coll coll;
	int r, i;
	FILE *out;
	char path[256];
	struct timeval total;
	unsigned long ms, us;

	init_profiler(mp);
	/* generate report here */

	init_Coll(&coll, 0, cmp_profile_out);

	snprintf(path, sizeof(path), "%s.pro", _clip_progname);
	out = fopen(path, "w");
	if (!out)
		out = stderr;


	for(r = HashTable_first(mp->profiler); r; r = HashTable_next(mp->profiler))
	{
		ProfileBucket *bp = (ProfileBucket *) HashTable_current(mp->profiler);
		insert_Coll(&coll, bp);
	}

	total.tv_sec = 0;
	total.tv_usec = 0;
	for(i = 0; i < coll.count; i++)
	{
		ProfileBucket *bp = (ProfileBucket *) coll.items[i];
		struct timeval tv;

		if (!bp->procname[0] && !bp->filename[0])
			continue;

		ms = bp->self.tv_sec * 1000 + bp->self.tv_usec/1000;
		us = bp->self.tv_usec%1000;

		tv = total;
		timer_add(&tv, &bp->self, &total);

		fprintf(out, "%18s %-13s %8ld calls %8lu.%03lu ms\n", bp->procname, bp->filename, bp->callno, ms, us);
	}

	ms = total.tv_sec * 1000 + total.tv_usec/1000;
	us = total.tv_usec%1000;
	fprintf(out, "---------------------------------\n");
	fprintf(out, "total registered %8lu.%03lu ms\n", ms, us);

	destroy_Coll(&coll);

	if (out != stderr)
		fclose(out);
}


static int
_clip_refclone(ClipMachine * mp, ClipVar * dest, ClipVar * src)
{
	if (src->t.flags == F_MREF)
	{
		_clip_destroy(mp, dest);
		dup_ref(dest, src);
		return 0;
	}
	else
		return _clip_clone(mp, dest, src);
}

CLIP_DLLEXPORT int
_clip_eval(ClipMachine * mp, ClipVar * blockp, int argc, ClipVar * stackp, ClipVar * retp)
{
#ifdef OS_MINGW
	ClipVar *stack = (ClipVar *) malloc(sizeof(ClipVar) * (argc + 1));
#else
	ClipVar *stack = (ClipVar *) alloca(sizeof(ClipVar) * (argc + 1));
#endif
	ClipFrame frame = { stack, stack + 1 + argc, __file__, __LINE__, 0, 0, 0, 0, 0, 0, "eval",
		argc + 1, 0
	};
	enum ClipVarType type = _clip_type(blockp);
	int i, j, r;

	if (type != PCODE_t && type != CCODE_t)
	{
		_clip_trap_str(mp, __file__, __LINE__, "clip_eval: non-code argument");
#ifdef OS_MINGW
		free(stack);
#endif
		return _clip_call_errblock(mp, 1);
	}

	if (_clip_profiler)
	{
		_clip_stop_profiler(mp);
	}

	blockp = _clip_vptr(blockp);
	memset(stack, 0, sizeof(ClipVar) * (argc + 1));

	for (i = 1, j = 0; j < argc; ++j, ++i)
	{
		_clip_refclone(mp, stack + i, stackp + j);
	}

	frame.up = mp->fp;
	mp->fp = &frame;

	if (_clip_profiler)
	{
		_clip_stop_profiler(mp);
	}

	if (type == CCODE_t)
		r = _clip_func(mp, blockp->c.u.func, argc, 0, blockp->c.uplocals);
	else
		r = _clip_code_func(mp, blockp->c.u.block, argc, 0, blockp->c.uplocals);

	mp->fp = frame.up;
	if (retp)
		*retp = stack[0];
	else
		_clip_destroy(mp, stack + 0);

	if (_clip_profiler)
	{
		_clip_start_profiler(mp);
		mp->pbucket->callno--;
	}


#ifdef OS_MINGW
	free(stack);
#endif
	return r;
}

int
clip_CLIP(ClipMachine * mp)
{
	char *funcname = _clip_parc(mp, 1);
	int i, parcount = _clip_parinfo(mp, 0);
	ClipVar *params, *retVal = RETPTR(mp);

	if (funcname == NULL)
	{
		int r;

		r = _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CLIP");
		return _clip_call_errblock(mp, r);
	}
	params = malloc(parcount * sizeof(ClipVar));
	for (i = 2; i <= parcount; i++)
		params[i - 2] = *_clip_spar(mp, i);

	_clip_clip(mp, funcname, parcount - 1, params, retVal);

	free(params);
	return 0;
}

int
clip_CLIPA(ClipMachine * mp)
{
	char *funcname = _clip_parc(mp, 1);
	int parcount;
	ClipVar *params, *retVal = RETPTR(mp);
	ClipVar *ap = _clip_par(mp, 2);

	if (!funcname || !ap || ap->t.type != ARRAY_t)
	{
		int r;

		r = _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CLIPA");
		return _clip_call_errblock(mp, r);
	}

	parcount  = ap->a.count;
	params = ap->a.items;

	_clip_clip(mp, funcname, parcount, params, retVal);

	return 0;
}

CLIP_DLLEXPORT int
_clip_clip(ClipMachine * mp, const char *funcname, int argc, ClipVar * stackp, ClipVar * retp)
{
	ClipVar *stack;
	ClipFrame frame = { 0, 0, __file__, __LINE__, 0, 0, 0, 0, 0, 0, "clip", 0, 0};
	int i, j, r;
	ClipFunction *fp;
	ClipBlock *bp;
	long hash;

	hash = _clip_casehashbytes(0, funcname, strlen(funcname));
	if (!_clip_get_function(mp, hash, &fp, &bp))
	{
		return 1;
	}

	stack = (ClipVar *) malloc(sizeof(ClipVar) * (argc + 1));
	frame.stack = stack;
	frame.sp = stack + 1 + argc;
	memset(stack, 0, sizeof(ClipVar) * (argc + 1));

	for (i = 1, j = 0; j < argc; ++j, ++i)
		_clip_clone(mp, stack + i, stackp + j);

	frame.up = mp->fp;
	mp->fp = &frame;

	if (fp)
		r = _clip_func(mp, fp, argc, 0, 0);
	else
		r = _clip_code_func(mp, bp, argc, 0, 0);

	mp->fp = frame.up;
	if (retp)
		*retp = stack[0];
	else
		_clip_destroy(mp, stack + 0);

	free(stack);
	return r;
}

CLIP_DLLEXPORT void
_clip_push_func(struct ClipMachine *mp, ClipFunction f, int nlocals, int nolocals)
{
	ClipVar *sp;
	ClipVar *vp;
	ClipFrame *fp = mp->fp;

	vp = NEW(ClipVar);

	vp->t.count = 1;
	vp->t.type = CCODE_t;
	vp->t.flags = F_NONE;
	vp->c.u.func = f;

	if (nlocals)
	{
		ClipVarFrame *localvars = (ClipVarFrame *) calloc(1, sizeof(ClipVarFrame) + nlocals * sizeof(ClipVar));

		localvars->vars = (ClipVar *) (localvars + 1);
		memcpy(localvars->vars, mp->fp->sp - nlocals, nlocals * sizeof(ClipVar));
		localvars->refcount = 1;
		localvars->size = nlocals;
		vp->c.uplocals = localvars;
		mp->fp->sp -= nlocals;
	}
	else if (!nolocals && fp->localvars && fp->localvars->refcount > 0)
	{
		fp->localvars->refcount++;
		vp->c.uplocals = fp->localvars;
	}

	sp = mp->fp->sp++;
	CLIP_CHECK_STACK;

	CLEAR_CLIPVAR(sp);
	sp->t.flags = F_MPTR;
	sp->t.type = CCODE_t;
	sp->p.vp = vp;

}

CLIP_DLLEXPORT int
_clip_func(ClipMachine * mp, ClipFunction f, int argc, int rest, ClipVarFrame * uplocals)
{
	int r;
	ClipFrame *inMacro = mp->inMacro;

	mp->inMacro = 0;
	r = do_call(mp, f, argc, 0, rest, uplocals);
	mp->inMacro = inMacro;
	return r;
}

CLIP_DLLEXPORT int
_clip_func_name(struct ClipMachine *mp, int argc)
{
	ClipFrame *fp = mp->fp;
	ClipVar *vp = _clip_vptr(fp->sp - argc - 2);
	long hash;
	int ret;

	if (vp->t.type == CHARACTER_t)
		hash = _clip_casehashbytes(0, vp->s.str.buf, vp->s.str.len);
	else if (vp->t.type == NUMERIC_t)
	{
		if (vp->t.memo)
			hash = (long) rational_toDouble(vp->r.r);
		else
			hash = (long) vp->n.d;
	}
	else
	{
		_clip_trap_str(mp, __file__, __LINE__, "call by name not from CHARACTER_t or NUMERIC_t value");
		return _clip_call_errblock(mp, 1);
	}
	if ((ret = _clip_func_hash(mp, hash, argc, 0, 0)))
		return ret;
	--fp->sp;
	_clip_destroy(mp, fp->sp - 1);
	fp->sp[-1] = fp->sp[0];

	return 0;
}

static void
init_machine(ClipMachine * mp)
{
	/* thread-depend code */
	cur_mp = mp;
}

CLIP_DLLEXPORT int
_clip_proc(struct ClipMachine *mp, ClipFunction f, int argc, int rest, ClipVarFrame * uplocals)
{
	int r;
	ClipFrame *inMacro = mp->inMacro;

	mp->inMacro = 0;
	r = do_call(mp, f, argc, 1, rest, uplocals);
	mp->inMacro = inMacro;
	return r;
}

CLIP_DLLEXPORT int
_clip_register(ClipMachine * mp, ClipFunction func, const char *name)
{
	return _clip_register_hash(mp, func, _clip_hashstr(name));
}

CLIP_DLLEXPORT int
_clip_register_hash(ClipMachine * mp, ClipFunction func, long hash)
{
	NEWVAR(FuncEntry, fp);
	fp->f = func;
	fp->hash = hash;
#if 0
	if (HashTable_insert(mp->functions, fp, fp->hash))
		return 1;
	else
	{
		free(fp);
		return 0;
	}
#else
	HashTable_store(mp->functions, fp, fp->hash);
	return 1;
#endif
}

int
_clip_register_block(ClipMachine * mp, ClipBlock block, long hash)
{
	NEWVAR(FuncEntry, fp);
	fp->f = 0;
	fp->block = block;
	fp->hash = hash;
	/*HashTable_remove(mp->functions, hash); */
	/*HashTable_insert(mp->functions, fp, fp->hash); */
	HashTable_store(mp->functions, fp, fp->hash);
	/*if (HashTable_insert(mp->functions, fp, fp->hash)) */
	/*if (HashTable_store(mp->functions, fp, fp->hash))
	   return 1;
	   else
	   {
	   free(fp);
	   return 0;
	   }
	 */
	return 1;
}

int
_clip_get_function(ClipMachine * mp, long hash, ClipFunction ** fpp, ClipBlock ** bpp)
{
	ClipFunction *fp;
	FuncEntry *vp;

	vp = (FuncEntry *) HashTable_fetch(mp->functions, hash);
	if (!vp)
	{
		fp = init_struct->_clip_builtin(hash);
		if (fp)
		{
			*fpp = fp;
			*bpp = 0;
			return 1;
		}
		return 0;
	}

	if (vp->f)
	{
		*fpp = vp->f;
		*bpp = 0;
	}
	else
	{
		*fpp = 0;
		*bpp = &vp->block;
	}

	return 1;
}

CLIP_DLLEXPORT int
_clip_call_errblock(ClipMachine * mp, int ret)
{
	if (!ret)
		return 0;

	if (!mp->trapVar)
		_clip_generr(mp, ret);

	if (ret < 0)
		return ret;

	if (!_clip_errorblock(mp, mp->trapVar, ret))
		ret = -ret;
	return ret;
}

CLIP_DLLEXPORT int
_clip_func_hash(struct ClipMachine *mp, long hash, int argc, int rest, ClipVarFrame * uplocals)
{
	ClipFunction *fp;
	ClipBlock *bp;
	int r = 0;
	ClipFrame *inMacro = mp->inMacro;

	mp->inMacro = 0;
	if (!_clip_get_function(mp, hash, &fp, &bp))
	{
		char buf[64];
		VarEntry *vep;

		vep = fetch_var(mp, hash);

		if (vep && (vep->var.t.type == ARRAY_t || vep->var.t.type == MAP_t))
		{
			/* support FoxPro syntax aVar(nElement) */
			ClipVar *vp;
			ClipVar *ap = mp->fp->sp - argc - 1;
			_clip_clone(mp, ap, &vep->var);
			vp = clip_fetch(mp, argc, 1, 0, 0, 0);
			if (vp)
				goto ret;
		}
		if (vep && (vep->var.t.type == PCODE_t || vep->var.t.type == CCODE_t))
		{
			/* if function not found - call codeblock from memvar*/
			int _argc = mp->argc;
			ClipFrame *fp = mp->fp;
			ClipVar *bp = mp->bp;

			ClipVar res;
			memset(&res, 0, sizeof(res));

			mp->argc = argc;
			mp->bp = fp->sp;
			r =_clip_eval(mp, &(vep->var), mp->argc, ARGPTR(mp, 1), &res);
			//r = _clip_eval(mp, &(vep->var), mp->argc,0, &res);
			mp->argc = _argc;
			mp->fp = fp;
			mp->bp = bp;
			argc++;
			for (; argc; --argc)
			{
				--(fp->sp);
				_clip_destroy(mp, fp->sp);
			}
			_clip_push(mp, &res);
			_clip_destroy(mp, &res);
			r = 0;
			goto ret;
		}
#if 1
		{
			/* call error with args */
			int _argc = mp->argc;
			ClipFrame *fp = mp->fp;
			ClipVar *bp = mp->bp;
			ClipVar res;
			memset(&res, 0, sizeof(res));

			mp->argc = argc;
			mp->bp = fp->sp;
			_clip_hash_name(mp, hash, buf, sizeof(buf));
			r = _clip_trap_err(mp, EG_NOFUNC, 0, 0, 0, 0, buf);
			mp->argc = _argc;
			mp->fp = fp;
			mp->bp = bp;
			if (!mp->trapVar)
				_clip_generr(mp, r);
			_clip_errorblock_res(mp, mp->trapVar, r, &res);
			argc++;
			for (; argc; --argc)
			{
				--(fp->sp);
				_clip_destroy(mp, fp->sp);
			}
			_clip_push(mp, &res);
			_clip_destroy(mp, &res);
			r = 0;
			goto ret;
		}
#else
		{
			/* old code for call error without args */
			_clip_hash_name(mp, hash, buf, sizeof(buf));
			r = _clip_trap_err(mp, EG_NOFUNC, 0, 0, 0, 0, buf);
			r = _clip_call_errblock(mp, r);
		}
#endif
	}
	if (fp)
	{
		char *oldbuf = 0, *buf = 0;

		if (log_level >= 4)
		{
			if (mp->fp->procname)
			{
				buf = (char *) calloc(1, 64);
				_clip_hash_name(mp, hash, buf, 64);
				oldbuf = (char *) mp->fp->procname;
				mp->fp->procname = buf;
			}
		}

		r = _clip_func(mp, fp, argc, rest, uplocals);

		if (log_level >= 4)
		{
			if (oldbuf)
			{
				mp->fp->procname = oldbuf;
				free(buf);
			}
		}

	}
	else
		r = _clip_code_func(mp, bp, argc, rest, uplocals);

	  ret:
	mp->inMacro = inMacro;
	return r;
}

CLIP_DLLEXPORT int
_clip_proc_hash(struct ClipMachine *mp, long hash, int argc, int rest, ClipVarFrame * uplocals)
{
	ClipFunction *fp;
	ClipBlock *bp;
	int r = 0;
	ClipFrame *inMacro = mp->inMacro;

	mp->inMacro = 0;
	if (!_clip_get_function(mp, hash, &fp, &bp))
	{
		char buf[64];

		_clip_hash_name(mp, hash, buf, sizeof(buf));
		r = _clip_trap_err(mp, EG_NOFUNC, 0, 0, 0, 0, buf);
		return _clip_call_errblock(mp, r);
	}

	if (fp)
	{
		char *oldbuf = 0, *buf = 0;

		if (log_level >= 4)
		{
			if (mp->fp->procname)
			{
				buf = (char *) calloc(1, 64);
				_clip_hash_name(mp, hash, buf, 64);
				oldbuf = (char *) mp->fp->procname;
				mp->fp->procname = buf;
			}
		}

		r = _clip_proc(mp, fp, argc, rest, uplocals);

		if (log_level >= 4)
		{
			if (oldbuf)
			{
				mp->fp->procname = oldbuf;
				free(buf);
			}

		}
	}
	else
		r = _clip_code_proc(mp, bp, argc, rest, uplocals);

	mp->inMacro = inMacro;
	return r;
}

CLIP_DLLEXPORT void
_clip_return(ClipMachine * mp)
{
	mp->bp[-mp->argc - 1] = *(--(mp->fp->sp));
}

CLIP_DLLEXPORT void
_clip_pop(ClipMachine * mp)
{
	_clip_destroy(mp, --(mp->fp->sp));
}

static void
delete_ClipVarFrame(ClipMachine * mp, ClipVarFrame * localvars)
{
	if (localvars && localvars->refcount > 0 && ((--(localvars->refcount)) < 1))
	{
		int i;

		for (i = 0; i < localvars->size; i++)
			_clip_destroy(mp, localvars->vars + i);
		free(localvars);
	}
}

CLIP_DLLEXPORT void
_clip_destroy_locals(ClipMachine * mp)
{
	if (mp->fp->localvars)
	{
		if (mp->fp->localvars->refcount == 0)
		{
			int i;

			for (i = 0; i < mp->fp->localvars->size; i++)
				_clip_destroy(mp, mp->fp->localvars->vars + i);
		}
	}
}


#if 0
static void
resume_mp(ClipMachine * mp)
{
	ClipFrame *fp = mp->fp;

	for (; fp->sp > fp->stack;)
	{
		--(fp->sp);
		_clip_destroy(mp, fp->sp);
	}
}
#endif
#define MAX_LOOP_DEEP 1024

static int
calc_loopcount(ClipMachine * mp, ClipVar * vp, ClipVarFrame * vfp, int deep)
{
	int r = 0, i;

	vp = _clip_vptr(vp);

	if (deep > MAX_LOOP_DEEP)
		return 0;
	deep++;

	switch (vp->t.type)
	{
	case CCODE_t:
	case PCODE_t:
		if (vp->c.uplocals == vfp)
			r = 1;
		break;
	case MAP_t:
		for (i = 0; i < vp->m.count; i++)
		{
			ClipVar *vpp = &(vp->m.items[i].v);

			r += calc_loopcount(mp, vpp, vfp, deep);
		}
		break;
	case ARRAY_t:
		for (i = 0; i < vp->a.count; i++)
		{
			ClipVar *vpp = vp->a.items + i;

			r += calc_loopcount(mp, vpp, vfp, deep);
		}
		break;
	default:
		break;
	}
	return r;
}


CLIP_DLLEXPORT ClipVar *
_clip_add_tempvar(ClipMachine *mp, ClipVar *vp)
{
	ClipFrame *fp;
	ClipVarVect *vvp;
	ClipVar *np;

	if (!vp)
		return 0;

	fp = mp->fp;
	vvp = fp->tempvars;
	if (!vvp)
	{
		vvp = NEW(ClipVarVect);
		fp->tempvars = vvp;
	}

	vvp->items = (ClipVar *) realloc (vvp->items, (vvp->count+1)*sizeof(ClipVar));
	np = vvp->items + vvp->count;
	vvp->count++;

	_clip_clone(mp, np, vp);

	return np;
}

CLIP_DLLEXPORT void
_clip_resume(ClipMachine * mp, int nlocals, int nreflocals)
{
	int i;
	ClipFrame *fp = mp->fp;
	ClipVarFrame *vfp = fp->localvars;

	for (; fp->sp > fp->stack;)
	{
		--(fp->sp);
		_clip_destroy(mp, fp->sp);
	}

/*      resume_mp(mp); */

	if (vfp)
	{
		for (i = 0; i < nlocals && i < vfp->size; ++i)
			_clip_destroy(mp, vfp->vars + i);

		for (; i < nlocals + nreflocals && i < vfp->size; ++i)
		{
			ClipVar *vp = vfp->vars + i;

/*#if 1
			if ((vp->t.flags & F_MPTR) && calc_loopcount(mp, vp, vfp, 0) == vfp->refcount - 1)
                        {
					_clip_destroy(mp, vp);
			}
#endif
*/
#if 1
			if ((vp->t.flags & F_MPTR) && vp->p.vp->t.count == 1
				&& (calc_loopcount(mp, vp, vfp, 0) == vfp->refcount - 1))
				_clip_destroy(mp, vp);
#else
			if ((vp->t.flags & F_MPTR) && (vp->t.type == MAP_t || vp->t.type == ARRAY_t))
			{
				if (vp->p.vp->t.count > 1)
					vp->p.vp->t.count--;
				else
					_clip_destroy(mp, vp);
			}
#endif
		}

		delete_ClipVarFrame(mp, vfp);
	}

	if (fp->privates)
	{
		long *p = fp->privates;
		int num = *p;

		++p;
		remove_private_vect(mp, num, p);
		free(fp->privates);
	}

	if (fp->tempvars)
	{
		ClipVarVect *vvp = fp->tempvars;

		for(i = 0; i < vvp->count; i++)
			_clip_destroy(mp, vvp->items+i);

		free(vvp->items);
		free(vvp);
		fp->tempvars = 0;
	}

	mp->fp = mp->fp->up;
}

CLIP_DLLEXPORT void
_clip_vresume(ClipMachine * mp, int num, ClipVar * vect)
{
	/*resume_mp(mp); */
	for (; num; --num, ++vect)
		_clip_destroy(mp, vect);
}

CLIP_DLLEXPORT void
_clip_delete(ClipMachine * mp, ClipVar * vp)
{
	if (!vp)
		return;
	_clip_destroy(mp, vp);
	free(vp);
}

CLIP_DLLEXPORT void
_clip_destroy(ClipMachine * mp, ClipVar * vp)
{
	if (!vp)
		return;

	switch (vp->t.flags)
	{
	case F_MPTR:
	case F_MREF:
		if ((--(vp->p.vp->t.count)) <= 0)
		{
			_clip_destroy(mp, vp->p.vp);
			free(vp->p.vp);
		}
		CLEAR_CLIPVAR(vp);
		return;
	case F_MSTAT:
		return;
	case F_NONE:
		break;
	}

	switch (vp->t.type)
	{
	case CHARACTER_t:
		free(vp->s.str.buf);
		break;
	case NUMERIC_t:
		if (vp->t.memo)
		{
			rational_destroy(vp->r.r);
		}
		break;
	case ARRAY_t:
		{
			int i;

			for (i = vp->a.count - 1; i >= 0; --i)
				_clip_destroy(mp, vp->a.items + i);
			free(vp->a.items);
		}
		break;
	case MAP_t:
		{
			int i;

#if 1
			int ind;

			/* try run `destroy` member */
			if (search_map(vp->m.items, vp->m.count, HASH_destroy, &ind))
			{
				ClipVar *ep;
				int type;

				ep = &(vp->m.items[ind].v);
				type = _clip_type(ep);

				if (type == PCODE_t || type == CCODE_t)
				{
					ClipVar vpp;

					memset(&vpp, 0, sizeof(vpp));
					vpp.t = vp->t;
					vpp.t.flags = F_MPTR;
					vpp.p.vp = vp;
					vp->t.count++;
					_clip_eval(mp, _clip_vptr(ep), 1, &vpp, 0);
				}
			}
#endif

			for (i = vp->m.count - 1; i >= 0; --i)
				_clip_destroy(mp, &(vp->m.items[i].v));
			free(vp->m.items);
		}
		break;
	case CCODE_t:

		delete_ClipVarFrame(mp, vp->c.uplocals);
		break;

	case PCODE_t:

		delete_ClipVarFrame(mp, vp->c.uplocals);
		destroy_Block(mp, vp->c.u.block);
		free(vp->c.u.block);

		break;
	default:
		break;
	}
	CLEAR_CLIPVAR(vp);
}

CLIP_DLLEXPORT ClipVar *
_clip_ref_destroy(ClipMachine * mp, ClipVar * vp)
{
	/*if (vp->t.flags != F_MREF)*/
		_clip_destroy(mp, vp);
	return vp;
}

int
type_weight(int type)
{
	int r = 0;

	switch (type)
	{
	case ARRAY_t:
		r = 0;
		break;
	case CCODE_t:
	case PCODE_t:
		r = 1;
		break;
	case CHARACTER_t:
		r = 2;
		break;
	case LOGICAL_t:
		r = 3;
		break;
	case DATE_t:
		r = 4;
		break;
	case DATETIME_t:
		r = 5;
	case NUMERIC_t:
		r = 6;
		break;
	case UNDEF_t:
	default:
		r = 7;
		break;
	}
	return r;
}

CLIP_DLLEXPORT int
_clip_cmp(ClipMachine * mp, ClipVar * lval, ClipVar * rval, int *res, int bytype)
{
	ClipVar *Rval = rval, *Lval = lval;
	int ltype, rtype;
	int l = 0;

	Rval = _clip_vptr(Rval);
	Lval = _clip_vptr(Lval);

	ltype = _clip_type(Lval), rtype = _clip_type(Rval);

	if (bytype && ltype != rtype)
	{
		int wl, wr;

		wl = type_weight(ltype);
		wr = type_weight(rtype);
		if (wl < wr)
			l = -1;
		else if (wl > wr)
			l = 1;
		else
			l = 0;
	}
	else if (ltype == CHARACTER_t && rtype == CHARACTER_t)
	{
		int rrlen = Rval->s.str.len;
		int rlen = rrlen;
		int lllen = Lval->s.str.len;
		int llen = lllen;
		char *s;

		for (s = Rval->s.str.buf + rlen - 1; rlen; --rlen, --s)
			if (*s != ' ' /* && *s != '\n'*/)
				break;

		if (!(mp->flags & EXACT_FLAG))
		{		/* SET EXACT OFF - empty rstr, len must match for equal */
			if (rrlen == 0)
				l = 0;
#if 1
			else if (lllen == 0 && rrlen > 0)
				l = -1;
			else	/* if ( rrlen > lllen ) */
			{
				if (lllen > rrlen)
					lllen = rrlen;
				l = _clip_strnncmp(Lval->s.str.buf, Rval->s.str.buf, lllen, rrlen);
			}
#else
			else if (llen < rrlen)
			{
				l = _clip_strncmp(Lval->s.str.buf, Rval->s.str.buf, llen);
				if (!l)
					l = -1;
			}
			else
				l = _clip_strncmp(Lval->s.str.buf, Rval->s.str.buf, rrlen);
#endif
		}
		else
			/* SET EXACT ON - all but trailing spaces */
		{
			if (llen == 0 && rlen > 0 /* llen > rlen */ )
				l = -1;
			else
			{
				for (s = Rval->s.str.buf + rlen - 1; rlen && *s == ' '; --rlen, --s)
					;
				for (s = Lval->s.str.buf + llen - 1; llen && *s == ' '; --llen, --s)
					;
				if (rlen == 0 && llen > 0)
					l = 1;
				else if (rlen > 0 && llen == 0)
					l = -1;
				else
					l = _clip_strnncmp(Lval->s.str.buf, Rval->s.str.buf, llen, rlen);
			}
		}
	}
	else if (ltype == DATE_t && rtype == DATE_t)
	{
		l = (Lval->d.julian < Rval->d.julian ? -1 : (Lval->d.julian > Rval->d.julian ? 1 : 0));
	}
	else if (ltype == DATETIME_t && rtype == DATETIME_t)
	{
		l = (Lval->dt.julian < Rval->dt.julian ? -1 : (Lval->dt.julian > Rval->dt.julian ? 1 : 0));
		if (l == 0)
			l = (Lval->dt.time < Rval->dt.time ? -1 : (Lval->dt.time > Rval->dt.time ? 1 : 0));
	}
	else if (ltype == NUMERIC_t && rtype == NUMERIC_t)
	{
		if (!Lval->t.memo && !Rval->t.memo)
		{
			double diff;

			diff = fabs(Lval->n.d - Rval->n.d);
			if (diff < (Lval->n.d * MIN_NUMERIC_DIFF))
				l = 0;
			else if (Lval->n.d < Rval->n.d)
				l = -1;
			else if (Lval->n.d > Rval->n.d)
				l = 1;
			else
				l = 0;
			/*
			   l = (Lval->n.d < Rval->n.d ? -1 : (Lval->n.d > Rval->n.d ? 1 : 0));
			 */
		}
		else
		{
			if (Lval->t.memo && Rval->t.memo)
				l = rational_cmp(Lval->r.r, Rval->r.r);
			else
			{
				rational *tmp;

				if (Lval->t.memo)
				{
					tmp = rational_double_init(Rval->n.d);
					l = rational_cmp(Lval->r.r, tmp);
				}
				else
				{
					tmp = rational_double_init(Lval->n.d);
					l = rational_cmp(tmp, Lval->r.r);
				}
				rational_destroy(tmp);
			}
		}
	}
	else if (ltype == LOGICAL_t && rtype == LOGICAL_t)
	{
		if (Lval->l.val && !Rval->l.val)
			l = 1;
		else if (!Lval->l.val && Rval->l.val)
			l = -1;
		else
			l = 0;
	}
	else if (ltype == ARRAY_t && rtype == ARRAY_t)
	{
		l = (Lval != Rval);
	}
	else if (ltype == MAP_t && rtype == MAP_t)
	{
		l = (Lval != Rval);
	}
	else if (ltype == OBJECT_t && rtype == OBJECT_t)
	{
		l = (Lval->o.obj != Rval->o.obj);
	}
	else if (ltype == CCODE_t && rtype == CCODE_t)
	{
		l = (Lval->c.u.func != Rval->c.u.func);
	}
	else if (ltype == PCODE_t && rtype == PCODE_t)
	{
		l = (Lval->c.u.block != Rval->c.u.block);
	}
	else if ((ltype == PCODE_t && rtype == CCODE_t) || (ltype == CCODE_t && rtype == PCODE_t))
	{
		l = 0;
	}
	else if (ltype == UNDEF_t)
	{
		l = (rtype == UNDEF_t ? 0 : -1);
	}
	else if (rtype == UNDEF_t)
	{
		l = (ltype == UNDEF_t ? 0 : 1);
	}
	else
	{
		return _clip_trap_operation(mp, __file__, __LINE__, "==", Lval);
		/*return _clip_call_errblock(mp, 1);*/
	}

	*res = l;
	return 0;
}

const char *
_clip_strstr(const char *src, int slen, const char *dst, int dlen)
{
	const char *end, *de, *s = src, *d = dst;

	/*
	if(!dlen)
		return src;
	*/
	for (end = src + slen, de = dst + dlen - 1; src < end; src++)
		if (*src == *d)
		{
			s = src;
			for (; src < end && d < de && *(++src) == *(++d);)
				;
			if (d == de && *src == *d)
				return s;
			src = s;
			d = dst;
		}
	return 0;
}

static int
do_assign(ClipMachine * mp, ClipVar * lval, ClipVar * rval, int op)
{
	int ret = 0;
	int l;
	ClipVar *Rval = rval, *Lval = lval;
	int ltype, rtype;

	Rval = _clip_vptr(Rval);
	Lval = _clip_vptr(Lval);

	ltype = _clip_type(Lval);
	rtype = _clip_type(Rval);

	if (ltype == MAP_t)
	{
		int ind;
		long hash = 0;

		switch (op)
		{
		case '+':
			hash = HASH_operator_add;
			break;
		case '-':
			hash = HASH_operator_sub;
			break;
		case '*':
			hash = HASH_operator_mul;
			break;
		case '/':
			hash = HASH_operator_div;
			break;
		case '%':
			hash = HASH_operator_mod;
			break;
		case '^':
			hash = HASH_operator_pow;
			break;
		case '|':
			hash = HASH_operator_or;
			break;
		case '&':
			hash = HASH_operator_and;
			break;
		case '$':
			hash = HASH_operator_in;
			break;
		case 'e':
			hash = HASH_operator_eq;
			break;
		case 'E':
			hash = HASH_operator_eeq;
			break;
		case 'N':
			hash = HASH_operator_neq;
			break;
		case '<':
			hash = HASH_operator_lt;
			break;
		case '>':
			hash = HASH_operator_gt;
			break;
		case 'L':
			hash = HASH_operator_le;
			break;
		case 'G':
			hash = HASH_operator_ge;
			break;
		}

		if (hash)
		{
			ClipVar *vp = Lval;

			/* try run `destroy` member */
			if (search_map(vp->m.items, vp->m.count, hash, &ind))
			{
				ClipVar *ep;
				int type;

				ep = &(vp->m.items[ind].v);
				type = _clip_type(ep);

				if (type == PCODE_t || type == CCODE_t)
				{
					int i;
					ClipVar stack[2], res;

					memset(stack, 0, sizeof(stack));
					memset(&res, 0, sizeof(res));

					stack[0].t = vp->t;
					stack[0].t.flags = F_MPTR;
					stack[0].p.vp = vp;
					vp->t.count++;

					_clip_clone(mp, stack + 1, rval);

					ret = _clip_eval(mp, _clip_vptr(ep), 2, stack, &res);

					_clip_clone(mp, lval, &res);

					for (i = 0; i < 2; i++)
						_clip_destroy(mp, stack + i);

					_clip_destroy(mp, &res);
				}
				return ret;
			}
		}
	}

	switch (op)
	{
	case '+':
		if (ltype == CHARACTER_t && rtype == CHARACTER_t)
		{
			int len = Lval->s.str.len + Rval->s.str.len;

			if (Lval->t.flags == F_MSTAT)
			{
				char *s = (char *) malloc(len + 1);

				Lval->t.flags = F_NONE;
				memcpy(s, Lval->s.str.buf, Lval->s.str.len);
				Lval->s.str.buf = s;
			}
			else
				Lval->s.str.buf = (char *) realloc(Lval->s.str.buf, len + 1);
			memcpy(Lval->s.str.buf + Lval->s.str.len, Rval->s.str.buf, Rval->s.str.len + 1);
			Lval->s.str.len = len;
			Lval->t.MACRO = Rval->t.MACRO;
		}
		else if (ltype == NUMERIC_t && rtype == NUMERIC_t)
		{
			_clip_math_operation(mp, op, Lval, Rval);
		}
		else if (ltype == DATE_t && rtype == NUMERIC_t)
		{
			if (Rval->t.memo)
				Lval->d.julian += rational_toDouble(Rval->r.r);
			else
				Lval->d.julian += Rval->n.d;
		}
		else if (ltype == NUMERIC_t && rtype == DATE_t)
		{
			double tmp;

			if (Lval->t.memo)
				tmp = rational_toDouble(Lval->r.r);
			else
				tmp = Lval->n.d;
			Lval->t.type = DATE_t;
			Lval->d.julian = Rval->d.julian;
			Lval->d.julian += tmp;
		}
		else if (ltype == DATETIME_t && rtype == NUMERIC_t)
		{
			long tmp;

			if (Rval->t.memo)
				tmp = (long) rational_toDouble(Rval->r.r);
			else
				tmp = (long) Rval->n.d;
			Lval->dt.julian += tmp / (24 * 60 * 60);
			Lval->dt.time += (tmp % (24 * 60 * 60)) * 1000;
		}
		else if (ltype == NUMERIC_t && rtype == DATETIME_t)
		{
			long tmp;

			if (Lval->t.memo)
				tmp = (long) rational_toDouble(Lval->r.r);
			else
				tmp = (long) Lval->n.d;
			Lval->t.type = DATETIME_t;
			Lval->dt.julian = Rval->dt.julian + tmp / (24 * 60 * 60);
			Lval->dt.time = Rval->dt.time + (tmp % (24 * 60 * 60)) * 1000;
		}
		else
		{
			return _clip_trap_operation(mp, __file__, __LINE__, "+", Lval);
			/*return 1;*/
		}
		break;
	case '-':
		if (ltype == CHARACTER_t && rtype == CHARACTER_t)
		{
			int llen = Lval->s.str.len;
			int len,slen = 0;
			char *s;

			for (s = Lval->s.str.buf + llen - 1; llen; --llen, --s, ++slen)
				if (*s != ' ' && *s != '\t')
					break;
			len = llen + Rval->s.str.len;

			if (Lval->t.flags == F_MSTAT)
			{
				char *s = (char *) malloc(len + 1);

				Lval->t.flags = F_NONE;
				memcpy(s, Lval->s.str.buf, Lval->s.str.len);
				Lval->s.str.buf = s;
			}
			else
				Lval->s.str.buf = (char *) realloc(Lval->s.str.buf, len + slen + 1);
			memcpy(Lval->s.str.buf + llen, Rval->s.str.buf, Rval->s.str.len + 1);
			memset(Lval->s.str.buf + len,' ',slen);
			Lval->s.str.buf[len+slen] = 0;
			Lval->s.str.len = len+slen;
			Lval->t.MACRO = Rval->t.MACRO;
		}
		else if (ltype == NUMERIC_t && rtype == NUMERIC_t)
		{
			_clip_math_operation(mp, op, Lval, Rval);
		}
		else if (ltype == DATE_t && rtype == NUMERIC_t)
		{
			if (Rval->t.memo)
				Lval->d.julian -= rational_toDouble(Rval->r.r);
			else
				Lval->d.julian -= Rval->n.d;
		}
		else if (ltype == DATETIME_t && rtype == DATETIME_t)
		{
			long tmp = (Lval->dt.julian - Rval->dt.julian) * 24 * 60 * 60;

			tmp += (Lval->dt.time - Rval->dt.time) / 1000;

			Lval->t.type = NUMERIC_t;
			Lval->n.d = tmp;
		}
		else if (ltype == DATETIME_t && rtype == NUMERIC_t)
		{
			long tmp;

			if (Rval->t.memo)
				tmp = (long) rational_toDouble(Rval->r.r);
			else
				tmp = (long) Rval->n.d;
			Lval->dt.julian -= tmp / (24 * 60 * 60);
			Lval->dt.time -= (tmp % (24 * 60 * 60)) * 1000;
			if (Lval->dt.time < 0)
			{
				Lval->dt.julian--;
				Lval->dt.time = (24 * 60 * 60 * 1000) + Lval->dt.time;
			}
		}
		else if (ltype == NUMERIC_t && rtype == DATE_t)
		{
			double tmp;

			if (Lval->t.memo)
				tmp = rational_toDouble(Lval->r.r);
			else
				tmp = Lval->n.d;
			Lval->t.type = DATE_t;
			Lval->d.julian = Rval->d.julian;
			Lval->d.julian -= tmp;
		}
		else if (ltype == DATE_t && rtype == DATE_t)
		{
			Lval->n.d = Lval->d.julian - Rval->d.julian;
			Lval->t.type = NUMERIC_t;
			Lval->t.len = 0;
			Lval->t.dec = 0;
			Lval->t.memo = 0;
		}
		else
		{
			return _clip_trap_operation(mp, __file__, __LINE__, "-", Lval);
			/*return 1;*/
		}
		break;
	case '*':
		if (ltype == NUMERIC_t && rtype == NUMERIC_t)
		{
			_clip_math_operation(mp, op, Lval, Rval);
		}
		else
		{
			return _clip_trap_operation(mp, __file__, __LINE__, "*", Lval);
			/*return 1;*/
		}
		break;
	case '/':
		if (ltype == NUMERIC_t && rtype == NUMERIC_t)
		{
			_clip_math_operation(mp, op, Lval, Rval);
		}
		else
		{
			return _clip_trap_operation(mp, __file__, __LINE__, "/", Lval);
			/*return 1;*/
		}
		break;
	case '%':
		if (ltype == NUMERIC_t && rtype == NUMERIC_t)
		{
			if (!Lval->t.memo && !Rval->t.memo)
			{
				Lval->n.d = fmod(Lval->n.d, Rval->n.d);
				Lval->t.len = 0;
				Lval->t.dec = 0;
				Lval->t.memo = 0;
			}
			else
			{
				rational *tmp = 0;

				if (Lval->t.memo && Rval->t.memo)
				{
					tmp = rational_fmod(Lval->r.r, Rval->r.r);
				}
				else
				{
					if (Lval->t.memo)
					{
						rational *tmp1;

						tmp1 = rational_double_init(Rval->n.d);
						tmp = rational_fmod(Lval->r.r, tmp1);
						rational_destroy(tmp1);
					}
					else
					{
						rational *tmp1;

						tmp1 = rational_double_init(Lval->n.d);
						tmp = rational_fmod(tmp1, Lval->r.r);
						rational_destroy(tmp1);
					}
				}
				rational_destroy(Lval->r.r);
				Lval->r.r = tmp;
			}

		}
		else
		{
			return _clip_trap_operation(mp, __file__, __LINE__, "%", Lval);
			/*return 1;*/
		}
		break;
	case '^':
		if (ltype == NUMERIC_t && rtype == NUMERIC_t)
		{
			if (Lval->t.memo)
			{
				long tmp;

				if (Rval->t.memo)
					tmp = (long) rational_toDouble(Rval->r.r);
				else
					tmp = (long) Rval->n.d;
				rational_powa(Lval->r.r, tmp);
			}
			else
			{
				Lval->n.d = pow(Lval->n.d, Rval->n.d);
				if (!finite(Lval->n.d))
					Lval->n.d = 0;
				Lval->t.len = 0;
				Lval->t.dec = 0;
			}
		}
		else
		{
			return _clip_trap_operation(mp, __file__, __LINE__, "**", Lval);
			/*return 1;*/
		}
		break;
	case '$':
		if (ltype == CHARACTER_t && rtype == CHARACTER_t)
		{
			const char *s = _clip_strstr(Rval->s.str.buf, Rval->s.str.len,
						Lval->s.str.buf, Lval->s.str.len);

			_clip_destroy(mp, lval);
			lval->l.val = (s ? 1 : 0);
			lval->t.type = LOGICAL_t;
		}
		else if (rtype == MAP_t)
		{
			int ind, r;
			long no;

			switch (ltype)
			{
			case NUMERIC_t:
				if (Lval->t.memo)
					no = rational_toDouble(Lval->r.r);
				else
					no = Lval->n.d;
				break;
			case CHARACTER_t:
				/*no = _clip_casehashbytes(0, Lval->s.str.buf, Lval->s.str.len); */
				no = _clip_hashbytes(0, Lval->s.str.buf, Lval->s.str.len);
				break;
			default:
				goto inv_in_arg;
			}

			r = search_map(Rval->m.items, Rval->m.count, no, &ind);
			_clip_destroy(mp, lval);
			lval->l.val = (r ? 1 : 0);
			lval->t.type = LOGICAL_t;
		}
		else if (rtype == ARRAY_t)
		{
			int i, c, r, res = 0;

			c = Rval->a.count;

			for (i = 0; i < c; ++i)
			{
				ClipVar *vp = Rval->a.items + i;

				r = _clip_cmp(mp, Lval, vp, &res, 1);
				if (r)
					continue;
				if (res)
					break;
			}
			_clip_destroy(mp, lval);
			lval->l.val = (!res ? 1 : 0);
			lval->t.type = LOGICAL_t;
		}
		else
		{
			  inv_in_arg:
			return _clip_trap_operation(mp, __file__, __LINE__, "$", Lval);
			/*return 1;*/
		}
		break;
	case 'E':
	case 'e':
	case 'N':
#if 1				/* uri added : oper != work as =, not == */
		if ((op == 'E') && (ltype == CHARACTER_t && rtype == CHARACTER_t))
#else
		if ((op == 'E' || op == 'N') && (ltype == CHARACTER_t && rtype == CHARACTER_t))
#endif
#if 1
			/*l = !strcmp(Lval->s.str.buf, Rval->s.str.buf); */
		{
			int ll, lr;

			ll = Lval->s.str.len;
			lr = Rval->s.str.len;

			if (ll != lr)
				l = 0;
			else
				l = !memcmp(Lval->s.str.buf, Rval->s.str.buf, ll);
		}
#else
/*Rust begin */
		{
			int len = Lval->s.str.len < Rval->s.str.len ? Lval->s.str.len : Rval->s.str.len;

			l = !_clip_strncmp(Lval->s.str.buf, Rval->s.str.buf, len);
		}
/*Rust end */
#endif
		else
		{
			if ((ret = _clip_cmp(mp, lval, rval, &l, 0)))
				return ret;
			l = !l;
		}

		_clip_destroy(mp, lval);
		switch (op)
		{
		case 'E':
		case 'e':
			lval->l.val = l;
			break;
		default:
			lval->l.val = !l;
			break;
		}
		lval->t.type = LOGICAL_t;
		break;
	case '|':
		if (ltype == LOGICAL_t && rtype == LOGICAL_t)
		{
			l = (Lval->l.val || Rval->l.val);
		}
		else
		{
			return _clip_trap_operation(mp, __file__, __LINE__, "OR", lval);
			/*return 1;*/
		}
		lval->l.val = l;
		lval->t.type = LOGICAL_t;
		break;
	case '&':
		if (ltype == LOGICAL_t && rtype == LOGICAL_t)
		{
			l = (Lval->l.val && Rval->l.val);
		}
		else
		{
			return _clip_trap_operation(mp, __file__, __LINE__, "AND", lval);
			/*return 1;*/
		}
		lval->l.val = l;
		lval->t.type = LOGICAL_t;
		break;
	case '<':
	case '>':
	case 'L':
	case 'G':
		if (ltype == CHARACTER_t && rtype == CHARACTER_t)
		{
			l = _clip_strnncmp(Lval->s.str.buf, Rval->s.str.buf, Lval->s.str.len, Rval->s.str.len);
#if 1   /* added 20030118 for test '? "" <="0"' */
			ret = _clip_cmp(mp, lval, rval, &l, 0);
#endif
			//printf("\nl=%d,ret=%d\n",l,ret);
			_clip_destroy(mp, lval);
		}
		else if (ltype == DATE_t && rtype == DATE_t)
		{
			if (Lval->d.julian < Rval->d.julian)
				l = -1;
			else if (Lval->d.julian > Rval->d.julian)
				l = 1;
			else
				l = 0;
		}
		else if (ltype == DATETIME_t && rtype == DATETIME_t)
		{
			if (Lval->dt.julian < Rval->dt.julian)
				l = -1;
			else if (Lval->dt.julian > Rval->dt.julian)
				l = 1;
			else
				l = 0;
			if (l == 0)
			{
				if (Lval->dt.time < Rval->dt.time)
					l = -1;
				else if (Lval->dt.time > Rval->dt.time)
					l = 1;
				else
					l = 0;
			}
		}
		else if (ltype == NUMERIC_t && rtype == NUMERIC_t)
		{
			if (!Lval->t.memo && !Rval->t.memo)
			{
				double diff;

				diff = fabs(Lval->n.d - Rval->n.d);
				if (diff < (Lval->n.d * MIN_NUMERIC_DIFF))
					l = 0;
				else if (Lval->n.d < Rval->n.d)
					l = -1;
				else if (Lval->n.d > Rval->n.d)
					l = 1;
				else
					l = 0;
			}
			else
			{
				if (Lval->t.memo && Rval->t.memo)
					l = rational_cmp(Lval->r.r, Rval->r.r);
				else
				{
					rational *tmp = NULL;

					if (Lval->t.memo)
					{
						tmp = rational_double_init(Rval->n.d);
						l = rational_cmp(Lval->r.r, tmp);
					}
					else
					{
						tmp = rational_double_init(Lval->n.d);
						l = rational_cmp(tmp, Rval->r.r);
					}
					rational_destroy(tmp);
				}
			}
			_clip_destroy(mp, lval);
		}
		else if (ltype == LOGICAL_t && rtype == LOGICAL_t)
		{
			if (Lval->l.val && !Rval->l.val)
				l = -1;
			else if (!Lval->l.val && Rval->l.val)
				l = 1;
			else
				l = 0;
		}
		else if (ltype == OBJECT_t && rtype == OBJECT_t)
		{
			l = Lval->o.rtti->cmp(mp, Lval->o.obj, Lval->o.rtti, Rval);
			_clip_destroy(mp, lval);
		}
		else
		{
			return _clip_trap_operation(mp, __file__, __LINE__, "==", lval);
			/*return 1;*/
		}
		switch (op)
		{
		case 'L':
			lval->l.val = (l <= 0 ? 1 : 0);
			break;
		case 'G':
			lval->l.val = (l >= 0 ? 1 : 0);
			break;
		case '>':
			lval->l.val = (l > 0 ? 1 : 0);
			break;
		case '<':
			lval->l.val = (l < 0 ? 1 : 0);
			break;
		default:
			lval->l.val = l;
		}
		lval->t.type = LOGICAL_t;
		lval->t.flags = F_NONE;
		break;
	}

	return ret;
}

CLIP_DLLEXPORT int
_clip_op(ClipMachine * mp, int op)
{
	int ret;
	ClipVar *rval = mp->fp->sp - 1;
	ClipVar *lval = mp->fp->sp - 2;

	if ((ret = do_assign(mp, lval, rval, op)))
		return ret;
		/*return _clip_call_errblock(mp, ret);*/
	_clip_destroy(mp, rval);
	--mp->fp->sp;
	return 0;
}

CLIP_DLLEXPORT int
_clip_not(ClipMachine * mp)
{
	ClipVar *vp = _clip_vptr(mp->fp->sp - 1);

	if (vp->t.type != LOGICAL_t)
	{
		_clip_trap_str(mp, __file__, __LINE__, "non-logical type in NOT operator");
		return _clip_call_errblock(mp, 1);
	}
	vp->l.val = !vp->l.val;
	return 0;
}

CLIP_DLLEXPORT int
_clip_minus(ClipMachine * mp)
{
	ClipVar *vp = _clip_vptr(mp->fp->sp - 1);

	if (vp->t.type != NUMERIC_t)
	{
		_clip_trap_str(mp, __file__, __LINE__, "non-numeric type in MINUS operator");
		return _clip_call_errblock(mp, 1);
	}
	if (vp->t.memo)
		rational_inverse(vp->r.r);
	else
		vp->n.d = -vp->n.d;
	return 0;
}

CLIP_DLLEXPORT int
_clip_opassign(struct ClipMachine *mp, void *Lval, int op)
{
	int ret;
	ClipVar *rval = mp->fp->sp - 1;

	if ((ret = do_assign(mp, (ClipVar *) Lval, rval, op)))
		return ret;
	_clip_destroy(mp, rval);
	--mp->fp->sp;
	return 0;
}

CLIP_DLLEXPORT int
_clip_opiassign(struct ClipMachine *mp, void *Lval, int op)
{
	int ret;
	ClipVar *rval = mp->fp->sp - 1;
	ClipVar *lval = (ClipVar *) Lval;

	if ((ret = do_assign(mp, lval, mp->fp->sp - 1, op)))
		return ret;
	_clip_destroy(mp, rval);
	if ((ret = _clip_mclone(mp, rval, lval)))
		return ret;
	return 0;
}

CLIP_DLLEXPORT int
_clip_assign(struct ClipMachine *mp, void *Lval)
{
	ClipVar *rval = mp->fp->sp - 1;
	ClipVar *lval = (ClipVar *) Lval;
	int ret;

	if (lval)
	{
		if ((lval->t.flags & F_MPTR) && lval->t.field && lval->p.fp)
		{
			return _clip_assign_field(mp, lval->p.fp->fieldhash, lval->p.fp->areahash);
		}
		else
		{
			if (!(lval->t.flags & F_MPTR) && (rval->t.flags == F_MREF) && lval->t.type == UNDEF_t
				 && !(rval->t.type == ARRAY_t || rval->t.type == MAP_t)
				)
			{
					_clip_dup(mp, lval, _clip_vptr(rval));
			}
#if 0
			else if (lval->t.type == ARRAY_t || lval->t.type == MAP_t)
			{
				_clip_destroy(mp, lval);
				ret = _clip_mclone(mp, lval, rval);
			}
#endif
			else if ((ret = _clip_mclone(mp, lval, rval)))
				return ret;
		}
		lval->t.field = 0;
		if (lval->t.type == CHARACTER_t)
			lval->t.memo = 0;
	}

	_clip_destroy(mp, rval);
	mp->fp->sp--;
	return 0;
}

CLIP_DLLEXPORT int
_clip_refassign(ClipMachine * mp, void *Lval, int isTop)
{
	ClipVar *rval = mp->fp->sp - 1;
	ClipVar *lval = (ClipVar *) Lval;

	_clip_destroy(mp, lval);

	if (!(rval->t.flags & F_MPTR))
		return 1;
	*lval = *rval;
	if (isTop)
		mp->fp->sp--;
	else
	{
		rval->p.vp->t.count++;
	}

	return 0;
}

CLIP_DLLEXPORT int
_clip_iassign(struct ClipMachine *mp, void *Lval)
{
	int ret;
	ClipVar *rval = mp->fp->sp - 1;
	ClipVar *lval = (ClipVar *) Lval;

	if ((lval->t.flags & F_MPTR) && lval->t.field && lval->p.fp)
	{
		ret = _clip_iassign_field(mp, lval->p.fp->fieldhash, lval->p.fp->areahash);
	}
	else
	{
		if (!(lval->t.flags & F_MPTR) && (rval->t.flags == F_MREF) && lval->t.type == UNDEF_t
				 && !(rval->t.type == ARRAY_t || rval->t.type == MAP_t)
		)
		{
				ret = _clip_dup(mp, lval, _clip_vptr(rval));
		}
		else
			ret = _clip_mclone(mp, lval, rval);
		lval->t.field = 0;
		if (lval->t.type == CHARACTER_t)
			lval->t.memo = 0;
	}

	return ret;
}

static ClipVar *
find_lval(ClipMachine * mp, char *name, int namelen)
{
	VarEntry *vep;
	ClipVar *lval = 0;
	long hash;
	char *fname = 0;
	int fl = 0, r, ndim = 0;
	long *dim = 0;

	r = _clip_parse_name(name, namelen, 0, 0, &fname, &fl, &dim, &ndim);
	if (r == 2)		/* field */
		return 0;

	hash = _clip_casehashbytes(0, fname, fl);
	vep = fetch_var(mp, hash);

	if (vep)
		lval = &vep->var;

	if (lval && r == 3)
	{
		lval = _clip_aref(mp, lval, ndim, dim);
		free(dim);
	}

	return lval;
}

CLIP_DLLEXPORT int
_clip_macroassign(ClipMachine * mp, int op, int isTop, int fieldprec)
{
	int r;
	ClipVar *rval = mp->fp->sp - 2;
	ClipVar *vp = _clip_vptr(mp->fp->sp - 1);
	ClipVar *lval = 0;

	if (vp->t.type != CHARACTER_t)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "macro assign with non-character argument (%s)", _clip_typename(vp));
		return _clip_call_errblock(mp, 1);
	}

	if (op == '=')
		r = _clip_nameassign(mp, vp->s.str.buf, vp->s.str.len, rval, fieldprec);
	else
	{
		lval = find_lval(mp, vp->s.str.buf, vp->s.str.len);

		if (!lval)
		{
			_clip_trap_printf(mp, __file__, __LINE__, "no variable name: '%.*s'", vp->s.str.len, vp->s.str.buf);
			return _clip_call_errblock(mp, 1);
		}

		if (op == '=')
			r = _clip_mclone(mp, lval, rval);
		else
			r = do_assign(mp, lval, rval, op);
	}

	if (r)
		return r;

	_clip_destroy(mp, --(mp->fp->sp));

	if (isTop)
		_clip_destroy(mp, --(mp->fp->sp));

	return 0;
}

CLIP_DLLEXPORT void
_clip_pop_fieldhash(ClipMachine * mp, long *area, long *field)
{
	ClipVar *vp, *vpp;

	vpp = --(mp->fp->sp);
	*area = -1;
	*field = -1;

	vp = _clip_vptr(vpp);

	switch (vp->t.type)
	{
	case CHARACTER_t:
		{
			int al = 0, fl = 0;
			char *aname = 0, *fname = 0;

			_clip_parse_name(vp->s.str.buf, vp->s.str.len, &aname, &al, &fname, &fl, 0, 0);
			if (aname)
				*area = _clip_casehashbytes(0, aname, al);
			if (fname)
				*field = _clip_casehashbytes(0, fname, fl);
		}
		break;
	case NUMERIC_t:
		*field = _clip_double(vp);
		break;
	case OBJECT_t:
		*field = vp->o.rtti->hash(mp, vp->o.obj, vp->o.rtti);
		break;
	default:
		break;
	}

	_clip_destroy(mp, vpp);
}

CLIP_DLLEXPORT int
_clip_cond(ClipMachine * mp, int *ifp)
{
	int r = _clip_tcond(mp, ifp);

	if (r)
		return r;

	mp->fp->sp--;
	_clip_destroy(mp, mp->fp->sp);
	return 0;
}

CLIP_DLLEXPORT int
_clip_tcond(ClipMachine * mp, int *ifp)
{
	ClipVar *vp = _clip_vptr(mp->fp->sp - 1);

	if (vp->t.type != LOGICAL_t)
	{
		_clip_trap_str(mp, __file__, __LINE__, "non-logical var in condition");
		return _clip_call_errblock(mp, 1);
	}
	if (vp->t.flags & F_MPTR)
		*ifp = vp->p.vp->l.val;
	else
		*ifp = vp->l.val;

	return 0;
}

CLIP_DLLEXPORT void *
_clip_memdup(const void *src, int len)
{
	void *ret = malloc(len + 1);

	memcpy(ret, src, len);
	((char *) ret)[len] = 0;
	return ret;
}

CLIP_DLLEXPORT int
_clip_mclone(struct ClipMachine *mp, ClipVar * dest, ClipVar * src)
{
	if (dest->t.flags == F_MREF && dest->p.vp->t.count > 1)
	{
		ClipVar *dp, *srcp;
		int count, ret;

		dp = dest->p.vp;
		srcp = src;
		count = dp->t.count;
		ret = 0;

		switch (src->t.flags)
		{
		case F_MREF:
			srcp = src->p.vp;
			if (srcp == dp)
				break;
		case F_MPTR:
			if (src->t.field && src->p.fp)
			{
				dest->p.fp = src->p.fp;
				dest->t.field = 1;
			}
		default:
			_clip_destroy(mp, dp);
			ret = _clip_clone(mp, dp, srcp);
			dp->t.count = count;
			dest->t.type = srcp->t.type;
			dest->t.flags = F_MREF;
			dest->t.field = 0;
			break;
		}
		return ret;
	}
	else
	{
		_clip_destroy(mp, dest);
		return _clip_clone(mp, dest, src);
	}
}

CLIP_DLLEXPORT int
_clip_clone(struct ClipMachine *mp, ClipVar * dest, ClipVar * src)
{
	ClipType t;

	CLEAR_CLIPVAR(dest);
	if (!src)
		return 0;

	t = src->t;
	switch (src->t.flags)
	{
	case F_MPTR:
		dup_ref(dest, src);
		return 0;
	case F_MREF:
		switch (src->t.type)
		{
		case MAP_t:
		case ARRAY_t:
		case CCODE_t:
		case PCODE_t:
			dup_ref(dest, src);
			return 0;
		default:
			return _clip_clone(mp, dest, src->p.vp);
		}
	case F_MSTAT:
		t.flags = F_NONE;
	case F_NONE:
		switch (src->t.type)
		{
		case UNDEF_t:
			break;
		case NUMERIC_t:
			if (src->t.memo)
			{
				dest->t.type = NUMERIC_t;
				dest->t.flags = F_NONE;
				dest->t.len = src->t.len;
				dest->t.dec = src->t.dec;
				dest->t.memo = 1;
				dest->r.r = rational_copy(src->r.r);
			}
			else
				*dest = *src;
			break;
		case LOGICAL_t:
		case DATE_t:
		case DATETIME_t:
			*dest = *src;
			break;
		case CCODE_t:
		case PCODE_t:
			*dest = *src;
			if (src->c.uplocals && src->c.uplocals->refcount)
				src->c.uplocals->refcount++;
			return 0;
		case CHARACTER_t:
			{
				int len = src->s.str.len;

				dest->s.str.buf = (char *) _clip_memdup(src->s.str.buf, len);
				dest->s.str.len = len;

			}
			break;
		case OBJECT_t:
			src->o.rtti->clone(mp, dest, src);
			break;
		default:
			break;
		}
	}
	dest->t = t;
	return 0;
}

CLIP_DLLEXPORT int
_clip_dup(ClipMachine * mp, ClipVar * dest, ClipVar * src)
{
	dest->t = src->t;

	switch (src->t.flags)
	{
	case F_MPTR:
	case F_MREF:
#if 0
		{
			enum ClipVarType type = src->t.type;

			if (type == CCODE_t || type == PCODE_t)
			{
				dest->p.vp = src->p.vp;
				++(src->p.vp->t.count);
				return 0;
			}
		}
#endif
		src = src->p.vp;
		dest->t.flags = F_NONE;
		break;
	case F_MSTAT:
		/*
		   *dest = *src;
		   return 0;
		 */
	case F_NONE:
		break;
	}

	switch (src->t.type)
	{
	case NUMERIC_t:
		if (src->t.memo)
		{
			dest->t.type = NUMERIC_t;
			dest->t.flags = F_NONE;
			dest->t.len = src->t.len;
			dest->t.dec = src->t.dec;
			dest->t.memo = 1;
			dest->r.r = rational_copy(src->r.r);
		}
		else
			*dest = *src;
		break;
	case LOGICAL_t:
	case DATE_t:
	case DATETIME_t:
		*dest = *src;
		break;
	case CCODE_t:
	case PCODE_t:
		{
		/**dest = *src;*/
			CLEAR_CLIPVAR(dest);
			dest->t.flags = F_MPTR;
			dest->t.type = src->t.type;
			dest->p.vp = src;

			src->t.count++;
#if 0
			vp->t.type = src->t.type;
			vp->t.flags = F_NONE;
			vp->c = src->c;
			if (vp->t.type == PCODE_t && vp->c.u.block->file)
				vp->c.u.block->file->refCount++;
#if 0
			if (vp->t.type == PCODE_t)
			{
				ClipBlock *bp;

				bp = NEW(ClipBlock);
				*bp = *(src->c.u.block);
				vp->c.u.block = bp;
				/*bp->file->refCount++; */
			}
			else
				vp->c.u.func = src->c.u.func;
#endif
#endif
		}
#if 0
		if (src->c.uplocals && src->c.uplocals->refcount)
			src->c.uplocals->refcount++;
#endif
		break;
	case CHARACTER_t:
		{
			int len = src->s.str.len;

			dest->s.str.buf = (char *) _clip_memdup(src->s.str.buf, len);
			dest->s.str.len = len;
		}
		break;
	case OBJECT_t:
		src->o.rtti->clone(mp, dest, src);
		break;
	case ARRAY_t:
		{
			ClipVar *ap = NEW(ClipVar);
			int count = src->a.count, i;

			dest->t.type = ARRAY_t;
			dest->t.flags = F_MPTR;
			dest->p.vp = ap;
			dest->t.field = 0;
			dest->p.fp = 0;
			ap->t.type = ARRAY_t;
			ap->t.flags = F_NONE;
			ap->t.count = 1;
			ap->a.items = (ClipVar *) malloc(sizeof(ClipVar) * count);
			ap->a.count = count;
			for (i = 0; i < count; i++)
			{
				ClipVar *src_p, *tg_p;

				tg_p = ap->a.items + i;
				src_p = src->a.items + i;
				_clip_dup(mp, tg_p, src_p);
			}
		}
		break;
	case MAP_t:
		{
			ClipVar *ap = NEW(ClipVar);
			int count = src->m.count, i;

			dest->t.type = MAP_t;
			dest->t.flags = F_MPTR;
			dest->p.vp = ap;
			dest->t.field = 0;
			dest->p.fp = 0;
			ap->t.type = MAP_t;
			ap->t.flags = F_NONE;
			ap->t.count = 1;
			ap->m.items = (ClipVarEl *) malloc(sizeof(ClipVarEl) * count);
			ap->m.count = count;
			for (i = 0; i < count; i++)
			{
				ClipVarEl *src_p, *tg_p;

				tg_p = ap->m.items + i;
				src_p = src->m.items + i;
				_clip_dup(mp, &tg_p->v, &src_p->v);
				tg_p->no = src_p->no;
			}
		}
		break;
	default:
		break;
	}
	return 0;
}

CLIP_DLLEXPORT int
_clip_push(ClipMachine * mp, void *vpp)
{
	ClipVar *sp = mp->fp->sp;
	ClipVar *vp = (ClipVar *) vpp;
	int ret;

	if (vp->t.type != UNDEF_t && (vp->t.flags & F_MPTR) && vp->t.field && vp->p.fp)
	{
		ret = _clip_take_field(mp, vp->p.fp->fieldhash, vp->p.fp->areahash, vp);
		if (ret)
			return ret;
	}

	ret = _clip_clone(mp, sp, vp);

	++(mp->fp->sp);

	/*
	if (!(mp->flags1 & NOEXPAND_MACRO_FLAG))
	{
	*/
		if (!ret)
		{
			if (sp->t.type == CHARACTER_t && sp->t.MACRO)
				ret = _clip_expand_var(mp, sp);
		}
	/*}*/

	CLIP_CHECK_STACK;

	return ret;
}

CLIP_DLLEXPORT void
_clip_push_nil(ClipMachine *mp)
{
	ClipFrame *fp = mp->fp;
	fp->sp->t.type = UNDEF_t;
	fp->sp->t.flags = F_NONE;
	fp->sp++;
}

CLIP_DLLEXPORT void
_clip_push_true(ClipMachine * mp)
{
	ClipFrame *fp = mp->fp;
	fp->sp->t.type = LOGICAL_t;
	fp->sp->t.flags = F_NONE;
	fp->sp->l.val = 1;
	fp->sp++;
}

CLIP_DLLEXPORT void
_clip_push_false(ClipMachine * mp)
{
	ClipFrame *fp = mp->fp;
	fp->sp->t.type = LOGICAL_t;
	fp->sp->t.flags = F_NONE;
	fp->sp->l.val = 0;
	fp->sp++;
}

CLIP_DLLEXPORT int
_clip_push_static(ClipMachine * mp, void *vpp)
{
	int r;

	r = _clip_push(mp, vpp);
	if (!r)
	{
		ClipVar *vp;

		vp = _clip_vptr(mp->fp->sp - 1);
		if (vp->t.type == CCODE_t || vp->t.type == PCODE_t)
		{
			if (!vp->c.uplocals && mp->fp->localvars)
			{
				mp->fp->localvars->refcount++;
				vp->c.uplocals = mp->fp->localvars;
			}
		}
	}
	return r;
}

CLIP_DLLEXPORT void
_clip_push_hash(ClipMachine * mp, long hash)
{
	ClipVar *sp = mp->fp->sp;

	CLEAR_CLIPVAR(sp);
	sp->t.memo = 0;
	sp->t.type = NUMERIC_t;
	sp->t.flags = F_NONE;
	sp->t.len = 10;
	sp->t.dec = 0;
	sp->n.d = hash;

	mp->fp->sp++;
	CLIP_CHECK_STACK;
}

CLIP_DLLEXPORT int
_clip_ref(ClipMachine * mp, void *Vp, int noadd)
{
	ClipVar *nv;
	ClipVar *vp = (ClipVar *) Vp;
	ClipVar *sp = mp->fp->sp;
	CLEAR_CLIPVAR(sp);

	if (!vp)
		return EG_NOVAR;

	if (vp->t.flags & F_MPTR)
	{
		if (noadd)
			*sp = *vp;
		else
		{
			dup_ref(sp, vp);
			sp->t.flags = F_MREF;
		}

		++(mp->fp->sp);
		CLIP_CHECK_STACK;
		return 0;
	}

	nv = NEW(ClipVar);

	if (vp->t.flags & F_MSTAT)
	{
		/*vp->t.flags &= ~F_MSTAT; */
		_clip_clone(mp, nv, vp);
	}
	else
		*nv = *vp;

	nv->t.count = noadd ? 1 : 2;
	vp->t.flags = F_MREF /*mptr?F_MPTR:F_MREF */ ;
	vp->p.vp = nv;
	vp->t.field = 0;
	vp->p.fp = 0;

	sp->t.type = nv->t.type;
	sp->t.flags = F_MREF /*mptr?F_MPTR:F_MREF */ ;
	sp->p.vp = nv;
	sp->t.field = 0;
	sp->p.fp = 0;

	++(mp->fp->sp);
	CLIP_CHECK_STACK;
	return 0;
}

CLIP_DLLEXPORT long
_clip_hash(ClipMachine * mp, ClipVar * vp)
{
	vp = _clip_vptr(vp);

	switch (vp->t.type)
	{
	case CHARACTER_t:
		return _clip_hashbytes(0, vp->s.str.buf, vp->s.str.len);
	case NUMERIC_t:
		return _clip_double(vp);
	case DATE_t:
		return vp->d.julian;
	case LOGICAL_t:
		return vp->l.val;
	case OBJECT_t:
		return vp->o.rtti->hash(mp, vp->o.obj, vp->o.rtti);
	default:
		break;
	}
	return 0;
}

static long
calc_casehash(ClipMachine * mp, ClipVar * vp, int trim)
{
	if (!vp)
		return 0;
	vp = _clip_vptr(vp);

	switch (vp->t.type)
	{
	case CHARACTER_t:
		{
			char *s = vp->s.str.buf;
			int l = vp->s.str.len;

			if (trim)
			{
				char *e;

				for (e = s + l - 1; e >= s; e--)
				{
					switch (*e)
					{
					case ' ':
					case '\t':
					case '\r':
					case '\n':
						l--;
						continue;
					}
					break;
				}
			}
			return _clip_casehashbytes(0, s, l);
		}
	case NUMERIC_t:
		return _clip_double(vp);
	case DATE_t:
		return vp->d.julian;
	case LOGICAL_t:
		return vp->l.val;
	case OBJECT_t:
		return vp->o.rtti->hash(mp, vp->o.obj, vp->o.rtti);
	default:
		break;
	}
	return 0;
}

CLIP_DLLEXPORT long
_clip_casehash(ClipMachine * mp, ClipVar * vp)
{
	return calc_casehash(mp, vp, 0);
}

CLIP_DLLEXPORT long
_clip_pop_hash(ClipMachine * mp)
{
	ClipVar *vp = --(mp->fp->sp);
	long r;

	r = calc_casehash(mp, vp, 1);
	_clip_destroy(mp, vp);

	return r;
}

CLIP_DLLEXPORT long
_clip_pop_shash(ClipMachine * mp)
{
	ClipVar *vp = --(mp->fp->sp);
	long r;

	r = _clip_hash(mp, vp);
	_clip_destroy(mp, vp);

	return r;
}

/* ] ClipMachine */
/* [ param */

CLIP_DLLEXPORT void
_clip_param(ClipMachine * mp, int no, int lno)
{
	ClipVar *param = _clip_ref_local(mp, lno);

	_clip_destroy(mp, param);

	if (!param)
		return;
	if (no < mp->argc)
	{
		ClipVar *vp = mp->bp - (mp->argc - no);

		if (vp->t.flags == F_MREF)
		{
			_clip_destroy(mp, param);
			*param = *vp;
			vp->p.vp->t.count++;
		}
		else
			_clip_mclone(mp, param, vp);
		if (param->t.flags & F_MPTR && param->t.field)
		{
			param->t.field = 0;
			param->p.fp = 0;
		}
	}
	else
		_clip_destroy(mp, param);
}

CLIP_DLLEXPORT ClipVar *
_clip_ref_param(ClipMachine * mp, int no, ClipVar * params)
{
	if (no >= mp->argc)
		return params + no;
	else
		return mp->bp - (mp->argc - no);
}

/* ] param */
/* [ memvars */

CLIP_DLLEXPORT void
_clip_memvar_public(ClipMachine * mp, long hash)
{
	VAR(VarEntry, vp, HashTable_fetch(mp->publics, hash));
	if (!vp)
	{
		VarEntry *ep = new_VarEntry(hash);

		ep->var.t.type = LOGICAL_t;
		HashTable_insert(mp->publics, ep, hash);
	}
}

CLIP_DLLEXPORT void
_clip_add_private(ClipMachine * mp, long hash)
{
	add_private(mp, hash);
}

CLIP_DLLEXPORT void
_clip_memvar_private(ClipMachine * mp, long hash)
{
	add_private(mp, hash);
}

CLIP_DLLEXPORT int
_clip_is_public(ClipMachine * mp, long hash)
{
	VAR(VarEntry, vp, HashTable_fetch(mp->publics, hash));

	return vp ? 0 : -1;
}

CLIP_DLLEXPORT int
_clip_is_private(ClipMachine * mp, long hash)
{
	VAR(VarEntry, vp, HashTable_fetch(mp->privates, hash));

	return vp ? 0 : -1;
}

CLIP_DLLEXPORT int
_clip_is_memvar(ClipMachine * mp, long hash)
{
	return (!_clip_is_private(mp, hash) || !_clip_is_public(mp, hash)) ? 0 : 1;
}

CLIP_DLLEXPORT struct _HashTable *
_clip_space(ClipMachine * mp, long space)
{
	VAR(HashTable, hp, HashTable_fetch(mp->spaces, space));
	if (!hp)
	{
		hp = new_HashTable();
		HashTable_insert(mp->spaces, hp, space);
	}
	return hp;
}

CLIP_DLLEXPORT ClipVar *
_clip_memvar_space(ClipMachine * mp, struct _HashTable * hp, long hash, int newvar)
{
	VarEntry *vp = (VarEntry *) HashTable_fetch(hp, hash);

	if (!vp)
	{
		if (!newvar)
			return 0;
		vp = new_VarEntry(hash);
		HashTable_insert(hp, vp, hash);
	}

	return &(vp->var);
}

CLIP_DLLEXPORT void
_clip_memvar_param(ClipMachine * mp, long hash, int no)
{
	ClipVar *cp = 0;
	VarEntry *vp;

	if (no >= 0 && no < mp->argc)
		cp = mp->bp - (mp->argc - no);

	vp = add_private(mp, hash);
	if (cp)
	{
		_clip_destroy(mp, &vp->var);
		vp->var = *cp;
		if ((vp->var.t.flags & F_MPTR) && vp->var.t.field)
		{
			vp->var.t.field = 0;
			vp->var.p.fp = 0;
		}
		CLEAR_CLIPVAR(cp);
	}
}

static void
remove_private_vect(ClipMachine * mp, int num, void *vect)
{
	long *lp = (long *) vect;

	for (; num > 0; --num, ++lp)
	{
		long hash = GETLONG(lp);
		VarEntry *vp = (VarEntry *) HashTable_fetch(mp->privates, hash);

		if (!vp)
			continue;
		if (vp->next)
		{
			HashTable_remove(mp->privates, hash);
			HashTable_store(mp->privates, vp->next, hash);
			vp->next = 0;
		}
		else
		{
			HashTable_remove(mp->privates, hash);
		}
		delete_VarEntry(mp, vp);
	}
}

CLIP_DLLEXPORT void
_clip_remove_privates(ClipMachine * mp, int num, ... /*long hash */ )
{
	va_list ap;

	va_start(ap, num);
	remove_private_vect(mp, num, ap);
	va_end(ap);
}

CLIP_DLLEXPORT void
_clip_vremove_privates(ClipMachine * mp, int num, long *vect)
{
	remove_private_vect(mp, num, vect);
}

static VarEntry *
add_private(ClipMachine * mp, long hash)
{
	long *p;
	VarEntry *vp, *np;
	ClipFrame *fp;

	if (mp->inMacro)
		fp = mp->inMacro;
	else
		fp = mp->fp;

	if (fp)
	{
		p = fp->privates;
		if (p)
		{
			int n;
			long c;

			for (n = *p, p++; n >= 0; n--, p++)
				if (hash == GETLONG(p))
				{
					vp = (VarEntry *) HashTable_fetch(mp->privates, hash);
					if (vp)
						return vp;
				}
			p = fp->privates;
			c = GETLONG(p);
			p = (long *) realloc(p, (c + 2) * sizeof(long));

			SETLONG(p, c + 1);
			SETLONG(p + c + 1, hash);
			fp->privates = p;
		}
		else
		{
			p = fp->privates = (long *) malloc(sizeof(long) * 2);

			SETLONG(p, 1);
			SETLONG(p + 1, hash);
		}
	}

	vp = (VarEntry *) HashTable_fetch(mp->privates, hash);
	np = new_VarEntry(hash);
	if (!vp)
		HashTable_insert(mp->privates, np, hash);
	else
	{
		np->next = vp;
		HashTable_remove(mp->privates, hash);
		HashTable_store(mp->privates, np, hash);
	}
	return np;
}

static VarEntry *
fetch_var(ClipMachine * mp, long hash)
{
	VarEntry *vp = (VarEntry *) HashTable_fetch(mp->privates, hash);

	if (!vp)
		vp = (VarEntry *) HashTable_fetch(mp->publics, hash);
	return vp;
}

static ClipVar *
fetch_obj(ClipMachine * mp, ClipVar * obj, long hash)
{
	if (obj->t.type != MAP_t)
		return 0;
	return _clip_mget(mp, obj, hash);
}

CLIP_DLLEXPORT int
_clip_memvar(ClipMachine * mp, long hash)
{
	VarEntry *vp;

	vp = fetch_var(mp, hash);

	if (!vp)
	{
#if 0
		vp = add_private(mp, hash);
#else
		char buf[64];
		_clip_hash_name(mp, hash, buf, sizeof(buf));
		_clip_trap_printf(mp, __file__, __LINE__, "no memvar variable '%s'", buf);
		return _clip_call_errblock(mp, EG_NOVAR);
#endif
	}
	_clip_push(mp, &vp->var);
	return 0;
}

CLIP_DLLEXPORT int
_clip_fmemvar(ClipMachine * mp, long hash)
{
	VarEntry *vp;

	if (mp->obj)
	{
		ClipVar *vpp;

		vpp = fetch_obj(mp, _clip_vptr(mp->obj), hash);
		if (vpp)
		{
			_clip_push(mp, vpp);
			return 0;
		}
	}

	if (!_clip_try_field(mp, hash))
		return 0;

	vp = fetch_var(mp, hash);

	if (!vp)
	{
		char buf[64];

		/*int r; */

		_clip_hash_name(mp, hash, buf, sizeof(buf));
		_clip_trap_printf(mp, __file__, __LINE__, "no variable '%s'", buf);
		/*r = _clip_trap_err(mp, EG_NOVAR, 0, 0, 0, 0, buf); */
		return _clip_call_errblock(mp, EG_NOVAR);
	}
	/*vp = add_private(mp, hash); */
	_clip_push(mp, &vp->var);
	return 0;
}

CLIP_DLLEXPORT int
_clip_memvarf(ClipMachine * mp, long hash)
{
	VarEntry *vp;

	vp = fetch_var(mp, hash);

	if (!vp)
	{
		char buf[64];

		/*int r; */

		if (!_clip_try_field(mp, hash))
			return 0;

		_clip_hash_name(mp, hash, buf, sizeof(buf));
		_clip_trap_printf(mp, __file__, __LINE__, "no variable '%s'", buf);
		/*r = _clip_trap_err(mp, EG_NOVAR, 0, 0, 0, 0, buf); */
		return _clip_call_errblock(mp, EG_NOVAR);
	}
	_clip_push(mp, &vp->var);
	return 0;
}

CLIP_DLLEXPORT int
_clip_ref_fmemvar(ClipMachine * mp, long hash)
{
	VarEntry *vp;

	if (!_clip_try_field(mp, hash))
		return 0;

	vp = fetch_var(mp, hash);

	if (!vp)
	{
#if 1
		vp = add_private(mp, hash);
#else
		char buf[64];

		/*int r; */

		_clip_hash_name(mp, hash, buf, sizeof(buf));
		_clip_trap_printf(mp, __file__, __LINE__, "no variable '%s'", buf);
		/*r = _clip_trap_err(mp, EG_NOVAR, 0, 0, 0, 0, buf); */
		return _clip_call_errblock(mp, EG_NOVAR);
#endif
	}
	_clip_ref(mp, &vp->var, 0);
	return 0;
}

CLIP_DLLEXPORT ClipVar *
_clip_ref_memvar(ClipMachine * mp, long hash)
{
	VarEntry *vp = fetch_var(mp, hash);

	if (!vp)
	{
#if 1
		vp = add_private(mp, hash);
#else
		char buf[64];
		_clip_hash_name(mp, hash, buf, sizeof(buf));
		_clip_trap_printf(mp, __file__, __LINE__, "no variable '%s'", buf);
		_clip_call_errblock(mp, EG_NOVAR);
		return 0;
#endif
	}
	return &vp->var;
}

CLIP_DLLEXPORT ClipVar *
_clip_ref_memvar_noadd(ClipMachine * mp, long hash)
{
	VarEntry *vp = fetch_var(mp, hash);

	if (!vp)
	{
#if 0
		return 0;
#else
		char buf[64];
		_clip_hash_name(mp, hash, buf, sizeof(buf));
		_clip_trap_printf(mp, __file__, __LINE__, "no memvar variable '%s'", buf);
		_clip_call_errblock(mp, EG_NOVAR);
		return 0;
#endif
	}
	return &vp->var;
}

CLIP_DLLEXPORT int
_clip_public(ClipMachine * mp, long hash)
{
	VarEntry *vp = (VarEntry *) HashTable_fetch(mp->publics, hash);

	if (!vp)
	{
		char buf[64];

		_clip_hash_name(mp, hash, buf, sizeof(buf));
		_clip_trap_printf(mp, __file__, __LINE__, "try access to unknown public var '%s'", buf);
		return _clip_call_errblock(mp, 1);
	}
	_clip_push(mp, &vp->var);
	return 0;
}

CLIP_DLLEXPORT ClipVar *
_clip_ref_public(ClipMachine * mp, long hash)
{
	VarEntry *vp = (VarEntry *) HashTable_fetch(mp->publics, hash);

	if (!vp)
	{
		char buf[64];

		_clip_hash_name(mp, hash, buf, sizeof(buf));
		_clip_trap_printf(mp, __file__, __LINE__, "try access to unknown public var '%s'", buf);
		return 0;
	}
	return &vp->var;
}

CLIP_DLLEXPORT ClipVar *
_clip_ref_public_noadd(ClipMachine * mp, long hash)
{
	VarEntry *vp = (VarEntry *) HashTable_fetch(mp->publics, hash);

	if (!vp)
		return 0;
	else
		return &vp->var;
}

/* ] memvars */
/* [ traps */

/* retrapper - add filename&line info into trapStack */
CLIP_DLLEXPORT void
_clip_trap(ClipMachine * mp, const char *filename, int line)
{
	char *s;
	char buf[256];

	snprintf(buf, 256, "file '%s' line %d", filename, line);
#if 0
	if (!mp->noerrblock)
		_clip_logg(4, "trace: %s", buf);
#endif
	s = strdup(buf);
	add_ClipVect(&mp->trapTrace, s);
}

/* trap head of stack */
CLIP_DLLEXPORT void
_clip_trap_pop(ClipMachine * mp)
{
	ClipVar *vp = --(mp->fp->sp), *Vp = NEW(ClipVar);

	*Vp = *vp;
	mp->trapVar = Vp;
}

CLIP_DLLEXPORT void
_clip_trap_str(ClipMachine * mp, const char *filename, int line, const char *str)
{
	ClipVar *vp;

	vp = _clip_new_error(mp, _clip_gettext(str), 2, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	_clip_trap_var(mp, filename, line, vp);
}

CLIP_DLLEXPORT int
_clip_trap_operation(ClipMachine * mp, const char *filename, int line, const char *oper,
	ClipVar *lval)
{
	ClipVar *vp;
	int r;
	char buf[256];
	snprintf(buf,256,_clip_gettext("invalid arguments for  '%s' operation"),oper);

	vp = _clip_new_error(mp, buf, 2, 0, 0, 0, 0, 0, 0, 0, 0, oper);
	_clip_trap_var(mp, filename, line, vp);

	if (!mp->trapVar)
		_clip_generr(mp, 1);

	_clip_destroy(mp, lval);
	r = _clip_errorblock_res(mp, mp->trapVar, 1, lval);

	if (!r && _clip_type(lval) == UNDEF_t)
		r = 1;

	return r;
}

CLIP_DLLEXPORT void
_clip_trap_printf(ClipMachine * mp, const char *filename, int line, const char *fmt, ...)
{
	va_list ap;
	char buf[256];

	va_start(ap, fmt);
	vsnprintf(buf, sizeof(buf), _clip_gettext(fmt), ap);
	va_end(ap);
	_clip_trap_str(mp, filename, line, buf);
}

CLIP_DLLEXPORT void
_clip_trap_printv(ClipMachine * mp, const char *filename, int line, const char *fmt, void *ap)
{
	char buf[256];

	vsnprintf(buf, sizeof(buf), _clip_gettext(fmt), ap);
	_clip_trap_str(mp, filename, line, buf);
}

CLIP_DLLEXPORT void
_clip_trap_var(ClipMachine * mp, const char *filename, int line, ClipVar * vp)
{
	_clip_delete(mp, mp->trapVar);
	_clear_trap(mp);
	if (vp)
	{
		/*vp = _clip_vptr(vp); */
		mp->trapVar = vp;
	}
	else
	{
		mp->trapVar = NEW(ClipVar);
	}
	_clear_trap(mp);
	_clip_trap(mp, filename, line);
}

CLIP_DLLEXPORT void
_clip_trap_invargv(ClipMachine * mp, const char *filename, int line)
{
	_clip_trap_str(mp, filename, line, "invalid arguments");
}

/* ] traps */
/* [ arrays */

/* create from stack */
CLIP_DLLEXPORT void
_clip_sarray(ClipMachine * mp, int n)
{
	ClipVar arr, *ap, *sp = mp->fp->sp;
	int i;

	ap = NEW(ClipVar);
	CLEAR_CLIPVAR(&arr);
	arr.t.type = ARRAY_t;
	arr.t.flags = F_MPTR/*F_MREF*/;
	arr.p.vp = ap;
	ap->t.type = ARRAY_t;
	ap->t.flags = F_NONE;
	ap->t.count = 1;
	ap->a.items = (ClipVar *) malloc(sizeof(ClipVar) * n);
	ap->a.count = n;
	for (i = 0; i < n; i++)
	{
		ClipVar *vpp = ap->a.items + i;

		*vpp = sp[-n + i];
		vpp->t.field = 0;
	}
	sp[-n] = arr;
	mp->fp->sp -= n - 1;
}

static void
new_array(ClipVar * vp, int n, long *dims)
{
	ClipVar *ap;
	int i, size;

	CLEAR_CLIPVAR(vp);
	if (!n)
	{
		vp->t.type = 0;
		vp->t.flags = F_NONE;
		return;
	}

	--n;
	size = GETLONG(dims);
	++dims;

	ap = NEW(ClipVar);
	vp->t.type = ARRAY_t;
	vp->t.flags = F_MPTR;
	vp->p.vp = ap;
	ap->t.type = ARRAY_t;
	ap->t.flags = F_NONE;
	ap->t.count = 1;
	ap->a.items = (ClipVar *) malloc(sizeof(ClipVar) * size);
	ap->a.count = size;
	for (i = 0; i < size; i++)
		new_array(&ap->a.items[i], n, dims);
}

CLIP_DLLEXPORT void
_clip_dimarray(ClipMachine * mp, int n)
{
	ClipVar *sp = mp->fp->sp;
	int i;
	long *dims;

#ifdef OS_MINGW
	dims = (long *) malloc(sizeof(long) * n);
#else
	dims = (long *) alloca(sizeof(long) * n);
#endif

	for (i = 0; i < n; i++)
		dims[i] = _clip_long(sp - n + i);

	mp->fp->sp -= n - 1;
	new_array(mp->fp->sp - 1, n, dims);
#ifdef OS_MINGW
	free(dims);
#endif
}

/* create with n dimentions */
CLIP_DLLEXPORT void
_clip_newarray(ClipMachine * mp, int n, ...)
{
	ClipVar *sp = mp->fp->sp;
	va_list ap;

	va_start(ap, n);
	new_array(sp, n, (long *) ap);
	va_end(ap);

	++(mp->fp->sp);
	CLIP_CHECK_STACK;
}

CLIP_DLLEXPORT void
_clip_vnewarray(ClipMachine * mp, int n, long *vect)
{
	ClipVar *sp = mp->fp->sp;

	new_array(sp, n, vect);
	++(mp->fp->sp);
	CLIP_CHECK_STACK;
}

CLIP_DLLEXPORT int
_clip_array(ClipMachine * mp, ClipVar * dest, int ndim, long *dims)
{
	new_array(dest, ndim, dims);
	return 0;
}

CLIP_DLLEXPORT int
_clip_adel(ClipMachine * mp, ClipVar * ap, int ndim, long *dims)
{
	int c;
	long ind;

	ap = _clip_vptr(ap);
	if (ap->t.type != ARRAY_t || !ndim)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "adel for non-array object");
		return _clip_call_errblock(mp, 1);
	}

	c = ap->a.count;
	ind = GETLONG(dims);

	if (ind < 0 || ind >= c)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "index for adel is out-of range: ind=%d, count=%d", ind + 1, c);
		return _clip_call_errblock(mp, 1);
	}

	if (ndim > 1)
	{
		ClipVar *app;

		app = ap->a.items + ind;
		return _clip_adel(mp, app, ndim - 1, dims + 1);
	}

	_clip_destroy(mp, ap->a.items + ind);
	memmove(ap->a.items + ind, ap->a.items + ind + 1, (c - ind - 1) * sizeof(ClipVar));
	memset(ap->a.items + c - 1, 0, sizeof(ClipVar));

	return 0;
}

CLIP_DLLEXPORT int
_clip_asize(ClipMachine * mp, ClipVar * ap, int ndim, long *dims)
{
	int c;
	long i, ind;

	ap = _clip_vptr(ap);

	if (ap->t.type != ARRAY_t || !ndim)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "asize for non-array object");
		return _clip_call_errblock(mp, 1);
	}

	c = ap->a.count;
	ind = GETLONG(dims);

	if (ndim > 1)
	{
		ClipVar *app;

		ind = dims[0];
		if (ind < 0 || ind >= c)
		{
			_clip_trap_printf(mp, __file__, __LINE__, "index for asize is out-of range: ind=%d, count=%d", ind + 1,
					  c);
			return _clip_call_errblock(mp, 1);
		}
		app = ap->a.items + ind;
		return _clip_asize(mp, app, ndim - 1, dims + 1);
	}

	for (i = ind; i < c; ++i)
		_clip_destroy(mp, ap->a.items + i);

	ap->a.items = (ClipVar *) realloc(ap->a.items, sizeof(ClipVar) * ind);
	ap->a.count = ind;

	for (i = c; i < ind; ++i)
		memset(ap->a.items + i, 0, sizeof(ClipVar));

	return 0;
}

CLIP_DLLEXPORT int
_clip_ains(ClipMachine * mp, ClipVar * ap, int ndim, long *dims)
{
	int c;
	long ind;

	ap = _clip_vptr(ap);

	if (ap->t.type != ARRAY_t || !ndim)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "ains for non-array object");
		return _clip_call_errblock(mp, 1);
	}

	c = ap->a.count;
	ind = GETLONG(dims);
	if (ind < 0 || ind >= c)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "index for ains is out-of range: ind=%d, count=%d", ind + 1, c);
		return _clip_call_errblock(mp, 1);
	}
	if (ndim > 1)
	{
		ClipVar *app;

		app = ap->a.items + ind;
		return _clip_ains(mp, app, ndim - 1, dims + 1);
	}

	if (c > 0)
	{
		_clip_destroy(mp, &ap->a.items[c - 1]);
		memmove(ap->a.items + ind + 1, ap->a.items + ind, (c - ind - 1) * sizeof(ClipVar));
	}
	memset(ap->a.items + ind, 0, sizeof(ClipVar));

	return 0;
}

CLIP_DLLEXPORT int
_clip_aadd(ClipMachine * mp, ClipVar * ap, ClipVar * vp)
{
	int c;

	ap = _clip_vptr(ap);

	if (ap->t.type != ARRAY_t)
		return 1;

	c = ++ap->a.count;
	ap->a.items = (ClipVar *) realloc(ap->a.items, sizeof(ClipVar) * c);
	memset(ap->a.items + c - 1, 0, sizeof(ClipVar));
	_clip_clone(mp, ap->a.items + c - 1, vp);

	return 0;
}

CLIP_DLLEXPORT ClipVar *
_clip_aref(ClipMachine * mp, ClipVar * ap, int ndim, long *dims)
{
	int c;
	long ind;
	ClipVar *app = 0;

	ap = _clip_vptr(ap);

	if ((ap->t.type != ARRAY_t && ap->t.type != MAP_t) || !ndim)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "aget for non-array object");
		return 0;
	}

	if (ap->t.type == MAP_t)
	{
		app = _clip_mget(mp, ap, dims[0]);
	}
	else
	{
		c = ap->a.count;
		ind = GETLONG(dims);

		if (ind < 0 || ind >= c)
		{
			_clip_trap_printf(mp, __file__, __LINE__, "index for aget is out-of range: ind=%d, count=%d", ind + 1,
					  c);
			return 0;
		}

		app = ap->a.items + ind;
	}

	if (ndim > 1)
	{
		return _clip_aref(mp, app, ndim - 1, dims + 1);
	}

	return app;
}

CLIP_DLLEXPORT int
_clip_aget(ClipMachine * mp, ClipVar * ap, ClipVar * resp, int ndim, long *dims)
{
	ClipVar *app;

	app = _clip_aref(mp, ap, ndim, dims);
	if (app)
		return _clip_clone(mp, resp, app);
	else
		return EG_NOVAR;
}

CLIP_DLLEXPORT int
_clip_aset(ClipMachine * mp, ClipVar * ap, ClipVar * vp, int ndim, long *dims)
{
	int c;
	long ind;
	ClipVar *app;

	ap = _clip_vptr(ap);

	if ((ap->t.type != ARRAY_t && ap->t.type != MAP_t) || !ndim)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "aset for non-array object");
		return _clip_call_errblock(mp, 1);
	}

	if (ap->t.type == MAP_t)
	{
		app = _clip_mget(mp, ap, dims[0]);
	}
	else
	{
		c = ap->a.count;
		ind = GETLONG(dims);

		if (ind < 0 || ind >= c)
		{
			_clip_trap_printf(mp, __file__, __LINE__, "index for aset is out-of range: ind=%d, count=%d", ind + 1,
					  c);
			return _clip_call_errblock(mp, 1);
		}

		app = ap->a.items + ind;
	}

	if (ndim > 1)
	{
		return _clip_aset(mp, app, vp, ndim - 1, dims + 1);
	}

/*_clip_destroy(mp, app);*/
	return _clip_mclone(mp, app, vp);
}

CLIP_DLLEXPORT void
_clip_unref_arr(ClipMachine * mp)
{
	ClipVar *sp = mp->fp->sp - 1, *ap;
	int type = _clip_type(sp);

	if ((type != ARRAY_t && type != MAP_t) || (sp->t.flags != F_MPTR && sp->t.flags != F_MREF))
		return;
	ap = _clip_vptr(sp->p.vp);

	_clip_dup(mp, sp, ap);
}

static void
print_dim(ClipMachine * mp, char *buf, int size, int dim, int Dim, long *Vect)
{
	char *s = buf, *e = buf + size - 20;
	int i;

	for (i = 0, *s = 0; i < Dim - dim && s < e; ++i)
	{
		char bb[64];

		s = s + strlen(s);
		_clip_hash_name(mp, GETLONG(Vect + i), bb, sizeof(bb));
		sprintf(s, "[%s]", bb);
	}
}

int
search_map(ClipVarEl * items, int count, long key, int *index)
{
	int l, h, res, i, c;
	long ln;

	l = 0;
	h = count - 1;
	res = 0;
	while (l <= h)
	{
		i = (l + h) >> 1;
		ln = items[i].no;
		if (ln < key)
			c = -1;
		else if (ln > key)
			c = 1;
		else
			c = 0;

		if (c < 0)
			l = i + 1;
		else
		{
			h = i - 1;
			if (c == 0)
			{
				res = 1;
				l = i;
			}
		}
	}
	if (index)
		*index = l;
	return res;
}

static ClipVarEl *
get_map_el(ClipMapVar * a, long no)
{
	int ind;

	if (search_map(a->items, a->count, no, &ind))
		return a->items + ind;
	else
		return 0;
}

CLIP_DLLEXPORT int
_clip_map(ClipMachine * mp, ClipVar * vp)
{
	ClipVar *ap;

	_clip_destroy(mp, vp);
	ap = NEW(ClipVar);
	vp->t.type = MAP_t;
	vp->t.flags = F_MPTR;
	vp->p.vp = ap;
	ap->t.type = MAP_t;
	ap->t.flags = F_NONE;
	ap->t.count = 1;
	ap->m.items = 0;
	ap->m.count = 0;

	return 0;
}

CLIP_DLLEXPORT int
_clip_mputn(ClipMachine * mp, ClipVar * ap, long no, double n)
{
	ClipVar v;
	int r;

	memset(&v, 0, sizeof(v));
	_clip_var_num(n, &v);
	r = _clip_madd(mp, ap, no, &v);
	_clip_destroy(mp, &v);

	return r;
}

CLIP_DLLEXPORT int
_clip_mputl(ClipMachine * mp, ClipVar * ap, long no, int l)
{
	ClipVar v;
	int r;

	memset(&v, 0, sizeof(v));
	_clip_var_log(l, &v);
	r = _clip_madd(mp, ap, no, &v);
	_clip_destroy(mp, &v);

	return r;
}

CLIP_DLLEXPORT int
_clip_mputc(ClipMachine * mp, ClipVar * ap, long no, char *str, int len)
{
	ClipVar v;
	int r;

	memset(&v, 0, sizeof(v));
	_clip_var_str(str, len, &v);
	r = _clip_madd(mp, ap, no, &v);
	_clip_destroy(mp, &v);

	return r;
}

CLIP_DLLEXPORT int
_clip_madd(ClipMachine * mp, ClipVar * ap, long no, ClipVar * vp)
{
	int ind, c;
	ClipVarEl *vlp;

	ap = _clip_vptr(ap);

	if (ap->t.type != MAP_t)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "madd for non-map object");
		return _clip_call_errblock(mp, 1);
	}

	c = ap->m.count;

	if (search_map(ap->m.items, c, no, &ind))
	{
		vlp = ap->m.items + ind;
		_clip_destroy(mp, &vlp->v);
	}
	else
	{
		ap->m.items = (ClipVarEl *) realloc(ap->m.items, (c + 1) * sizeof(ClipVarEl));
		if (ind < c)
			memmove(ap->m.items + ind + 1, ap->m.items + ind, (c - ind /* -1 */ ) * sizeof(ClipVarEl));
		ap->m.count++;
		vlp = ap->m.items + ind;
		memset(vlp, 0, sizeof(ClipVarEl));
		vlp->no = no;
	}
	_clip_mclone(mp, &vlp->v, vp);

	return 0;
}

CLIP_DLLEXPORT int
_clip_mdel(ClipMachine * mp, ClipVar * ap, long no)
{
	int ind;

	ap = _clip_vptr(ap);

	if (ap->t.type != MAP_t)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "mdel for non-map object");
		return _clip_call_errblock(mp, 1);
	}
	if (search_map(ap->m.items, ap->m.count, no, &ind))
	{
		_clip_destroy(mp, &((ap->m.items + ind)->v));

		ap->m.count--;
		if (ind < ap->m.count)
			memmove(ap->m.items + ind, ap->m.items + ind + 1, (ap->m.count - ind) * sizeof(ClipVarEl));
	}
	return 0;
}

CLIP_DLLEXPORT int
_clip_mind(ClipMachine * mp, ClipVar * ap, long no, int *ind)
{
	ap = _clip_vptr(ap);
	if (ap->t.type != MAP_t)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "mind for non-map object");
		return _clip_call_errblock(mp, 1);
	}

	return !search_map(ap->m.items, ap->m.count, no, ind);
}

static int
test_maponerror(ClipMachine * mp, ClipVar * map, char * member)
{
	int ind, ret = 1;

	/* try run `onerror` member */
	if (search_map(map->m.items, map->m.count, HASH_onerror, &ind))
	{
		ClipVar *ep;

		map->t.memo = 0;
		ep = _clip_vptr(&(map->m.items[ind].v));

		if (ep->t.type == PCODE_t || ep->t.type == CCODE_t)
		{
			int i;
			ClipVar stack[3];
			ClipVar *rval = mp->fp->sp - 1;

			memset(stack, 0, sizeof(stack));

			stack[0].t = map->t;
			stack[0].t.flags = F_MPTR;
			stack[0].p.vp = map;
			map->t.count++;

			_clip_var_str(member, strlen(member), stack + 1);
			_clip_clone(mp, stack + 2, rval);

			_clip_eval(mp, _clip_vptr(ep), 3, stack, rval);

			for (i = 0; i < 3; i++)
				_clip_destroy(mp, stack + i);
			ret = 0;
		}
		map->t.memo = 1;
	}
	return ret;
}

static ClipVar *
fetch_arr(ClipMachine * mp, ClipVar * ap, int dim, long *vect, int Dim, long *Vect, int store, ClipVar ** mapp, long *hashp)
{
	long no;
	ClipVar *vp = NULL;
	ClipVarEl *vlp = 0;
	int isMap, type;
	int pdim;
	long *pvect;
	ClipVar *pap;

	if (!dim)
		return ap;

	type = _clip_type(ap);

	isMap = (type == MAP_t ? 1 : 0);

	if ( type == CHARACTER_t)
	{
		long pos, len=1, slen;
		char *buf;
		ClipVar *sp = mp->fp->sp, var;

		pos = _clip_hash(mp, sp - dim);
		pos --;
		if ( dim > 1 )
			len = _clip_hash(mp, sp - dim + 1);
		if ( len < 1 )
			len = 1;

		vp = _clip_vptr(ap);
		slen = vp->s.str.len;
		buf = vp->s.str.buf;

		CLEAR_CLIPVAR(&var);
		if ( pos<0 || pos >= slen )
		{
			pos = 0;
			len = 0;
		}
		if ( pos + len > slen)
			len = slen - pos;
		_clip_var_str(buf+pos, len, &var);
		vp = _clip_add_tempvar(mp, &var);
		_clip_destroy(mp, &var);
		return vp;
	}

	if (type != ARRAY_t && !isMap)
	{
		char buf[64];

		print_dim(mp, buf, sizeof(buf), dim - 1, Dim, Vect);
		_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "try fetch element from non-array object%s%s",
				  buf[0] ? " " : "", buf);
		_clip_call_errblock(mp, EG_BOUND);
		return NULL;
	}

	pap = ap;
	pvect = vect;
	pdim = dim;

	ap = _clip_vptr(ap);
	no = GETLONG(vect);

	++vect;
	--dim;

	if (isMap)
	{
		int ind;
		int c = ap->m.count;

		if (search_map(ap->m.items, c, no, &ind))
			vlp = ap->m.items + ind;
		else if (store)
		{
			/*addvar: */
			ap->m.items = (ClipVarEl *) realloc(ap->m.items, (c + 1) * sizeof(ClipVarEl));
			if (ind < c)
				memmove(ap->m.items + ind + 1, ap->m.items + ind, (c - ind /*-1*/ ) * sizeof(ClipVarEl));
			ap->m.count++;
			vlp = ap->m.items + ind;
			memset(vlp, 0, sizeof(ClipVarEl));
			vlp->no = no;
		}
		else
		{
			if ((mp->flags1 & MAPERR_FLAG))
			{
				/*goto addvar; */
				vp = mp->fp->sp;
				memset(vp, 0, sizeof(ClipVar));
				vp->p.vp = vp;
				return vp;
			}
			else
			{
				char buf[64];

				_clip_hash_name(mp, no, buf, sizeof(buf));
				if ( test_maponerror(mp,ap,buf) )
				{
					_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "map fetch error: index %s", buf);
					_clip_call_errblock(mp, EG_BOUND);
					return 0;
				}
				else
				{
					vp = fetch_arr(mp, pap, pdim, pvect, Dim, Vect, store, mapp, hashp);
					return vp;
				}
			}
		}

		if (store && !dim && ap->t.memo && mapp && hashp)
		{
			*mapp = ap;
			*hashp = no;
		}
	}
	else if (no < 1 || no > ap->a.count)
	{
		char buf[64];

		print_dim(mp, buf, sizeof(buf), dim, Dim, Vect);
		_clip_trap_printf(mp, mp->fp->filename, mp->fp->line, "out-of-bounds array %s, index=%d, count=%d", buf, no,
				  ap->a.count);
		_clip_call_errblock(mp, EG_BOUND);
		return NULL;
	}
	if (isMap)
	{
		vp = fetch_arr(mp, &vlp->v, dim, vect, Dim, Vect, store, mapp, hashp);
	}
	else
		vp = fetch_arr(mp, ap->a.items + no - 1, dim, vect, Dim, Vect, store, mapp, hashp);

	return vp;
}

static int
clip_count(ClipVar *vp)
{
	int count;

	if (vp && vp->t.flags & F_MPTR)
	{
		count = vp->p.vp->t.count + clip_count(vp->p.vp);
	}
	else
		count = 0;
	return count;
}

static ClipVar *
clip_fetch(ClipMachine * mp, int dim, int push, int store, ClipVar ** mapp, long *hashp)
{
	ClipFrame *fp = mp->fp;
	ClipVar *sp = fp->sp;
	ClipVar *ap = sp - dim - 1;
	ClipVar arr;
	ClipVar *vp = NULL;
	/*ClipVar *app;*/
	int i;
#ifdef OS_MINGW
	long *vect = (long *) malloc(sizeof(long) * dim);
#else
	long *vect = (long *) alloca(sizeof(long) * dim);
#endif

	memset(&arr, 0, sizeof(ClipVar));
	_clip_clone(mp, &arr, ap);

	for (i = 0; i < dim; ++i)
	{
		long h;
		void *p;

		h = _clip_hash(mp, sp - dim + i);
		p = vect + i;

		*(long *) (p) = (h);
		/*SETLONG(vect + i, _clip_hash(mp, sp - dim + i)); */
	}


	vp = fetch_arr(mp, &arr, dim, vect, dim, vect, store, mapp, hashp);

	if (!vp)
		return 0;

	for (i = dim + 1; i; --i)
	{
		sp = --(fp->sp);
		_clip_destroy(mp, sp);
	}

	if (push)
	{
		if (!vp)
		{
			vp = mp->fp->sp++;
			CLIP_CHECK_STACK;
			memset(vp, 0, sizeof(ClipVar));
		}
		else
			_clip_push(mp, vp);
	}

	if (!vp)
	{
		_clip_trap_str(mp, mp->fp->filename, mp->fp->line, "map/array fetch error");
		_clip_call_errblock(mp, EG_BOUND);
	}

#if 0
	app = _clip_vptr(&arr);
	if (app->t.count == 1 && !push)
#else
	if (clip_count(&arr) == 1 && !push)
#endif
	{
		vp = _clip_add_tempvar(mp, vp);
	}

	_clip_destroy(mp, &arr);
#ifdef OS_MINGW
	free(vect);
#endif
	return vp;
}

CLIP_DLLEXPORT int
_clip_ifetch(ClipMachine * mp, int dim)
{
	return clip_fetch(mp, dim, 1, 0, 0, 0) ? 0 : 1;
}

CLIP_DLLEXPORT int
_clip_fetch(ClipMachine * mp, int dim)
{
	return clip_fetch(mp, dim, 0, 0, 0, 0) ? 0 : 1;
}

CLIP_DLLEXPORT ClipVar *
_clip_fetchref(ClipMachine * mp, int dim)
{
	ClipVar *vp;

	vp = clip_fetch(mp, dim, 0, 0, 0, 0);
	/*printf("%p\n",vp); */
	return vp;
}

static void
test_modify(ClipMachine * mp, ClipVar * map, long hash)
{
	int ind;

	/* try run `modify` member */
	if (search_map(map->m.items, map->m.count, HASH_modify, &ind))
	{
		ClipVar *ep;

		map->t.memo = 0;
		ep = _clip_vptr(&(map->m.items[ind].v));

		if (ep->t.type == PCODE_t || ep->t.type == CCODE_t)
		{
			int i;
			ClipVar stack[3];
			ClipVar *rval = mp->fp->sp - 1;

			memset(stack, 0, sizeof(stack));

			stack[0].t = map->t;
			stack[0].t.flags = F_MPTR;
			stack[0].p.vp = map;
			map->t.count++;

			_clip_var_num(hash, stack + 1);
			_clip_clone(mp, stack + 2, rval);

			_clip_eval(mp, _clip_vptr(ep), 3, stack, rval);

			for (i = 0; i < 3; i++)
				_clip_destroy(mp, stack + i);
		}
		map->t.memo = 1;
	}
}

CLIP_DLLEXPORT int
_clip_istore(ClipMachine * mp, int dim, int byref)
{
	ClipVar *map = 0;
	long hash = 0;
	ClipVar *vp = clip_fetch(mp, dim, 0, 1, &map, &hash);

	if (!vp)
		return 1;

	if (map)
		test_modify(mp, map, hash);

	if (byref == 2)
		_clip_destroy(mp, vp);
	else if (byref == 1)
		_clip_refassign(mp, vp, 0);
	else
		_clip_iassign(mp, vp);
	return 0;
}

CLIP_DLLEXPORT int
_clip_store(ClipMachine * mp, int dim, int byref)
{
	ClipVar *map = 0;
	long hash = 0;
	ClipVar *vp = clip_fetch(mp, dim, 0, 1, &map, &hash);

	if (!vp)
		return 1;

	if (map)
		test_modify(mp, map, hash);

	if (byref == 2)
	{
		_clip_destroy(mp, vp);
		CLEAR_CLIPVAR(mp->fp->sp);
		mp->fp->sp++;
		CLIP_CHECK_STACK;
	}
	else if (byref == 1)
		_clip_refassign(mp, vp, 1);
	else
		_clip_assign(mp, vp);
	return 0;
}

CLIP_DLLEXPORT int
_clip_opistore(ClipMachine * mp, int dim, int op)
{
	ClipVar *vp = clip_fetch(mp, dim, 0, 1, 0, 0);

	if (!vp)
		return 1;
	_clip_opiassign(mp, vp, op);
	return 0;
}

CLIP_DLLEXPORT int
_clip_opstore(ClipMachine * mp, int dim, int op)
{
	ClipVar *vp = clip_fetch(mp, dim, 0, 1, 0, 0);

	if (!vp)
		return 1;
	_clip_opassign(mp, vp, op);
	return 0;
}

/* ] arrays */
/* [ var */

CLIP_DLLEXPORT int
_clip_log(ClipVar * vp)
{
	vp = _clip_vptr(vp);

	switch (vp->t.type)
	{
	case NUMERIC_t:
		if (vp->t.memo)
			return rational_empty(vp->r.r);
		else
			return vp->n.d == 0 ? 0 : 1;
	case LOGICAL_t:
		return vp->l.val;
	case CHARACTER_t:
		return vp->s.str.len == 0 ? 0 : 1;
	case ARRAY_t:
		return vp->a.count == 0 ? 0 : 1;
	case MAP_t:
		return vp->m.count == 0 ? 0 : 1;
	default:
		break;
	}
	return 0;
}

CLIP_DLLEXPORT long
_clip_long(ClipVar * vp)
{
	vp = _clip_vptr(vp);

	switch (vp->t.type)
	{
	case NUMERIC_t:
		if (vp->t.memo)
			return (long) rational_toDouble(vp->r.r);
		else
			return (long) vp->n.d;
	case DATE_t:
		return vp->d.julian;
	case LOGICAL_t:
		return vp->l.val;
	case CHARACTER_t:
		return vp->s.str.len;
	case ARRAY_t:
		return vp->a.count;
	case MAP_t:
		return vp->m.count;
	default:
		break;
	}
	return 0;
}

CLIP_DLLEXPORT double
_clip_double(ClipVar * vp)
{
	vp = _clip_vptr(vp);

	switch (vp->t.type)
	{
	case NUMERIC_t:
		if (vp->t.memo)
			return rational_toDouble(vp->r.r);
		else
			return vp->n.d;
	case DATE_t:
		return vp->d.julian;
	case LOGICAL_t:
		return vp->l.val;
	case CHARACTER_t:
		return vp->s.str.len;
	case ARRAY_t:
		return vp->a.count;
	case MAP_t:
		return vp->m.count;
	default:
		break;
	}
	return 0;
}

static int
descr_str(ClipMachine * mp, ClipVar * vp, char **str)
{
	int l;

	if (!vp)
		return 0;
	vp = _clip_vptr(vp);

	switch (vp->t.type)
	{
	case CHARACTER_t:
		return _clip_strFromVar(mp, vp, str, &l);
		break;
	case MAP_t:
		{
			int ind, l;

			if (!_clip_mind(mp, vp, HASH_description, &ind))
			{
				ClipVar *ep, *ap;

				ap = _clip_vptr(vp);

				ep = &(ap->m.items[ind].v);
				return _clip_strFromVar(mp, ep, str, &l);
			}
		}
		break;
	default:
		break;
	}
	return 0;

}

CLIP_DLLEXPORT int
_clip_strFromVar(ClipMachine * mp, ClipVar * vp, char **str, int *lenp)
{
	if (!vp)
		return 0;

	vp = _clip_vptr(vp);

	switch (vp->t.type)
	{
	case CHARACTER_t:
		{
			ClipBuf buf = { 0, 0 };

			int ret = _clip_expand(mp, &buf, &vp->s.str);

			if (!ret)
			{
				*str = buf.buf;
				*lenp = buf.len;
			}
			else
			{
				free(buf.buf);
				*str = 0;
				*lenp = 0;
			}
			return ret;
		}
	default:
		*lenp = 0;
	}
	return 0;
}

CLIP_DLLEXPORT int
_clip_eval_macro(ClipMachine * mp, char *str, int len, ClipVar * dest)
{
	char *s = str, *e;
	int simple = 1;

	if (len == 0)
	{
		dest->t.type = UNDEF_t;
		dest->t.flags = F_NONE;
		return 0;
	}

	if (!(isalpha(*s) || *s == '_'))
		simple = 0;
	else
		for (s = str + 1, e = str + len; s < e; ++s)
			if (!(isalnum(*s) || *s == '_'))
			{
				simple = 0;
				break;
			}

	if (simple)
	{
		VarEntry *vp;
		long hash = _clip_casehashbytes(0, str, len);

		if (!_clip_take_field(mp, hash, -1, dest))
			return 0;

		vp = fetch_var(mp, hash);

		if (!vp)
		{
			if (mp->obj)
			{
				ClipVar *vpp;

				vpp = fetch_obj(mp, _clip_vptr(mp->obj), hash);
				if (vpp)
					return _clip_clone(mp, dest, vpp);
			}
		}

		if (!vp)
		{
			if (mp->noerrblock)
			{
				ClipVar var;

				memset(&var, 0, sizeof(var));
				return _clip_clone(mp, dest, &var);
			}
			else
			{
				_clip_trap_printf(mp, __file__, __LINE__, "no variable name: '%.*s'", len, str);
				return _clip_call_errblock(mp, 1);
				/*vp = add_private(mp, hash); */
			}
		}
		return _clip_clone(mp, dest, &vp->var);
	}
	else
	{
		ClipBlock block;
		int ret = _clip_compile_Block(mp, str, len, &block);
		ClipVar stack[1];
		ClipFrame frame = { stack, stack + 1, __file__, __LINE__, 0, 0, 0, 0, 0, 0, "eval_macro", 1, 0 };
		ClipFrame *inMacro = mp->inMacro;

		if (ret)
			return -1;
		memset(stack, 0, sizeof(stack));

		mp->inMacro = mp->fp;
		frame.up = mp->fp;
		mp->fp = &frame;

		ret = _clip_code_func(mp, &block, 0, 0, 0);

		mp->inMacro = inMacro;
		mp->fp = frame.up;
		*dest = stack[0];
		destroy_Block(mp, &block);
		if (ret)
			return 1;
		else
			return 0;
	}
}

CLIP_DLLEXPORT int
_clip_expand_var(ClipMachine * mp, ClipVar * vp)
{
	ClipBuf dest;
	int ret;
	char *s, *e;

	vp = _clip_vptr(vp);

	if (vp->t.type == CHARACTER_t)
	{
		ret = _clip_expand(mp, &dest, &(vp->s.str));
		if (ret)
			return ret;
	}
	else
	{
		_clip_destroy(mp, vp);
		vp->t.type = CHARACTER_t;
		vp->t.flags = F_MSTAT;
		vp->t.MACRO = 0;
		vp->s.str.buf = "";
		vp->s.str.len = 0;
		return 0;
	}
	_clip_destroy(mp, vp);
	vp->t.type = CHARACTER_t;
	vp->t.flags = 0;
	vp->t.MACRO = 1;
	vp->s.str = dest;
	for (s = dest.buf, e = dest.buf + dest.len; s < e; ++s)
		if (*s == '&')
		{
			ret = 1;
			break;
		}
	if (!ret)
		vp->t.MACRO = 0;
	return 0;
}

static int
find_macro(char *s, char *e, char **beg, char **end, char **next, int *dot)
{
	*dot = 0;
	if (s >= e)
		return 0;
	for (; s < e; ++s)
		if (*s == '&')
		{
			++s;
			if (s >= e)
				return 0;
			*beg = s;
			if (*s == '.')
				*dot = 1;
			if (*s == '\\')
			{
				++s;
				if (s >= e)
					return 0;
				switch (*s)
				{
				case 'x':
				case 'X':
				case '0':
				case '1':
				case '2':
				case '3':
				case '4':
				case '5':
				case '6':
				case '7':
					goto cont;
				}
				++s;
				*end = s;
				*next = s;
				return 1;
			}
			else
			{
				if (*s == '.')
					*dot = 1;

				  cont:

				for (; s <= e; ++s)
					if (s == e || !(isalnum(*s) || *s == '_'))
					{
						*end = s;
						if (*s == '.')
						{
							++s;
							*dot = 1;
						}
						*next = s;
						return 1;
					}
			}
			*end = s;
			++s;
			*next = s;
		}
	return 0;
}

static int
octdig(int ch)
{
	return ch - '0';
}

static int
hexdig(int ch)
{
	switch (ch)
	{
	case '0':
		return 0;
	case '1':
		return 1;
	case '2':
		return 2;
	case '3':
		return 3;
	case '4':
		return 4;
	case '5':
		return 5;
	case '6':
		return 6;
	case '7':
		return 7;
	case '8':
		return 8;
	case '9':
		return 9;
	case 'A':
	case 'a':
		return 10;
	case 'B':
	case 'b':
		return 11;
	case 'C':
	case 'c':
		return 12;
	case 'D':
	case 'd':
		return 13;
	case 'E':
	case 'e':
		return 14;
	case 'F':
	case 'f':
		return 15;
	}
	return 0;
}

CLIP_DLLEXPORT int
_clip_expand(ClipMachine * mp, ClipBuf * dest, ClipBuf * src)
{
	char *s, *e, *beg, *end, *next;
	int dot;
	OutBuf buf;

	init_Buf(&buf);

	s = src->buf;
	e = s + src->len;
	for (; find_macro(s, e, &beg, &end, &next, &dot); s = next)
	{
		long hash;
		VarEntry *vp;
		ClipVar *vpp;
		int ch;

		putBuf_Buf(&buf, s, (beg - 1) - s);
		if (end == beg)
		{
			putByte_Buf(&buf, '&');
			if (dot)
				putByte_Buf(&buf, '.');
			continue;
		}

		if (*beg == '\\')
		{
			++beg;
			if (end == beg)
			{
				putByte_Buf(&buf, '&');
				putByte_Buf(&buf, '\\');
				continue;
			}

			switch ((ch = *beg))
			{
			case 'x':
			case 'X':
				{
					++beg;
					if ((end - beg) != 2)
					{
						  undo:
						putByte_Buf(&buf, '&');
						putByte_Buf(&buf, '\\');
						while (beg < end)
							putByte_Buf(&buf, *beg++);
						continue;
					}
					else
					{
						unsigned char b1, b2;

						b1 = hexdig(beg[0]);
						b2 = hexdig(beg[1]);
						putByte_Buf(&buf, b1 << 4 | b2);
					}
				}
				continue;
			case '0':
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
				{
					unsigned char b1, b2, b3;

					if ((end - beg) != 3)
						goto undo;
					b1 = octdig(beg[0]);
					b2 = octdig(beg[1]);
					b3 = octdig(beg[2]);
					putByte_Buf(&buf, b1 << 6 | b2 << 3 | b3);
				}
				continue;
			default:
				if ((end - beg) != 1)
					goto undo;
				switch (ch)
				{
				case 'n':
					putByte_Buf(&buf, '\n');
					break;
				case 'r':
					putByte_Buf(&buf, '\r');
					break;
				case 't':
					putByte_Buf(&buf, '\t');
					break;
				case 'v':
					putByte_Buf(&buf, '\v');
					break;
				case 'a':
					putByte_Buf(&buf, 7);
					break;
				case 'e':
					putByte_Buf(&buf, 27);
					break;
				default:
					putByte_Buf(&buf, ch);
					break;
				}
				continue;
			}
		}


		hash = _clip_casehashbytes(0, beg, end - beg);
		vp = fetch_var(mp, hash);
#if 0
		if (!vp)
		{
			_clip_trap_str(mp, __file__, __LINE__, "undefined macro-variable in string");
			goto _trap;
		}
#endif
#if 0
		if (!(vp->var.t.type & CHARACTER_t))
		{
			_clip_trap_str(mp, __file__, __LINE__, "non-character result of macro in string");
			goto _trap;
		}
#endif
		if (vp && !(mp->flags1 & NOEXPAND_MACRO_FLAG))
		{
			vpp = _clip_vptr(&vp->var);
			switch (vpp->t.type)
			{
			case CHARACTER_t:
				putBuf_Buf(&buf, vpp->s.str.buf, vpp->s.str.len);
				break;
			case NUMERIC_t:
				{
					if (vpp->t.memo)
					{
						char *bf;

						if (vpp->t.len)
							bf = rational_toString(vpp->r.r, 10, vpp->t.dec, 0);
						else
							bf = rational_toString(vpp->r.r, 10, mp->decimals, 0);
						putBuf_Buf(&buf, bf, strlen(bf));
						free(bf);
					}
					else
					{
						char bf[32];

						if (vpp->t.len)
							snprintf(bf, sizeof(bf), "%*.*f", vpp->t.len, vpp->t.dec, vpp->n.d);
						else
							snprintf(bf, sizeof(bf), "%g", vpp->n.d);
						putBuf_Buf(&buf, bf, strlen(bf));
					}
				}
				break;
			case LOGICAL_t:
				if (vpp->l.val)
					putBuf_Buf(&buf, ".T.", 3);
				else
					putBuf_Buf(&buf, ".F.", 3);
				break;
			case DATE_t:
				{
					int dd, mm, yy, ww;
					char bf[32];

					_clip_cdate(vpp->d.julian, &dd, &mm, &yy, &ww);
					sprintf(bf, "%02d/%02d/%d", dd, mm, yy);
					putBuf_Buf(&buf, bf, strlen(bf));
				}
				break;
			case DATETIME_t:
				{
					int len;
					char *r =
						_clip_ttoc(mp, vpp->dt.julian, vpp->dt.time, &len, mp->date_format, mp->hours,
							   mp->seconds);

					putBuf_Buf(&buf, r, len);
					free(r);
				}
				break;
			default:
				goto badtype;
				break;
			}
		}
		else
		{
			  badtype:
			putByte_Buf(&buf, '&');
			while (beg < end)
				putByte_Buf(&buf, *beg++);
			if (dot)
				putByte_Buf(&buf, '.');
		}
	}
	/* rest of string */
	if (s < e)
		putBuf_Buf(&buf, s, e - s);

	dest->len = buf.ptr - buf.buf;
	putByte_Buf(&buf, 0);
	dest->buf = buf.buf;
	return 0;
}

CLIP_DLLEXPORT int
_clip_macro(ClipMachine * mp)
{
	ClipVar *vp = mp->fp->sp - 1;

	vp = _clip_vptr(vp);

	if (vp->t.type == CHARACTER_t)
	{
		int l = vp->s.str.len;
		char *s = _clip_memdup(vp->s.str.buf, l);
		ClipVar *vpp = mp->fp->sp - 1;
		int r;

		_clip_destroy(mp, vpp);

		r = _clip_eval_macro(mp, s, l, vpp);
		free(s);

		return r;
	}
	else
	{
		_clip_trap_printf(mp, __file__, __LINE__, "macro operation with non-character argument (%s)",
				  _clip_typename(vp));
		return _clip_call_errblock(mp, 1);
	}
}

CLIP_DLLEXPORT void
_clip_var_str(const char *str, int len, ClipVar * dest)
{
	dest->s.str.buf = (char *) _clip_memdup(str, len);
	dest->s.str.len = len;
	dest->t.type = CHARACTER_t;
	dest->t.flags = F_NONE;
	dest->t.memo = 0;
}

CLIP_DLLEXPORT void
_clip_var_num(double num, ClipVar * vp)
{
	vp->t.type = NUMERIC_t;
	vp->t.flags = F_NONE;
	vp->t.len = 0;
	vp->t.dec = 0;
	vp->t.memo = 0;
	vp->n.d = num;
}

CLIP_DLLEXPORT void
_clip_var_log(int val, ClipVar * vp)
{
	vp->t.type = LOGICAL_t;
	vp->t.flags = F_NONE;
	vp->l.val = val;
}

/* ] var */
/* [ pcount */

CLIP_DLLEXPORT void
_clip_pcount(ClipMachine * mp)
{
	ClipVar *vp = mp->fp->sp;

	vp->t.type = NUMERIC_t;
	vp->t.flags = F_NONE;
	vp->t.len = 0;
	vp->t.dec = 0;
	vp->t.memo = 0;
	vp->n.d = mp->argc;
	mp->fp->sp++;
	CLIP_CHECK_STACK;
}

CLIP_DLLEXPORT void
_clip_pshift(ClipMachine * mp)
{
	--mp->argc;
	_clip_pcount(mp);
}

CLIP_DLLEXPORT int
_clip_parn(ClipMachine * mp)
{
	int no;
	ClipVar *sp = mp->fp->sp - 1;

	no = _clip_long(sp);

	_clip_destroy(mp, sp);

	if (no < 1 || no > mp->argc)
		return 0;

	mp->fp->sp--;
	_clip_push(mp, ARGPTR(mp, no));
	return 0;
}

/* ] pcount */
/* [ Object calls */

static int obj_call(struct ClipMachine *mp, int argc, long hash, int call);

#define CALL_CALL 0
#define CALL_GET 1
#define CALL_SET 2

CLIP_DLLEXPORT int
_clip_call(struct ClipMachine *mp, int argc, long hash)
{
	return obj_call(mp, argc, hash, CALL_CALL);
}

static int
obj_call(struct ClipMachine *mp, int argc, long hash, int call)
{
	ClipVar *op = _clip_vptr(mp->fp->sp - argc);
	int ret = 0;
	int _argc = mp->argc;
	ClipFrame *fp = mp->fp;
	ClipVar *bp = mp->bp;
	ClipFrame *inMacro = mp->inMacro;

	mp->inMacro = 0;
	switch (op->t.type)
	{
	case OBJECT_t:
		mp->argc = argc;
		mp->bp = fp->sp;

		switch (call)
		{
		case CALL_CALL:
			ret = op->o.rtti->call(mp, op->o.obj, op->o.rtti, hash);
			break;
		case CALL_GET:
			ret = op->o.rtti->get(mp, op->o.obj, op->o.rtti, hash);
			break;
		case CALL_SET:
			ret = op->o.rtti->set(mp, op->o.obj, op->o.rtti, hash);
			break;
		}

		mp->argc = _argc;
		mp->fp = fp;
		mp->bp = bp;
		for (; argc; --argc)
		{
			--(fp->sp);
			_clip_destroy(mp, fp->sp);
		}

		break;
	case MAP_t:
		{
			ClipVarEl *vlp;
			ClipVar *vpp;
			enum ClipVarType type;

			vlp = get_map_el(&op->m, hash);
			if (!vlp)
			{
				char buf[32];

				_clip_hash_name(mp, hash, buf, sizeof(buf));
				_clip_trap_printf(mp, __file__, __LINE__, "no method %s", buf);
				ret = EG_NOMETHOD;
				break;
			}
			vpp = &vlp->v;
			type = _clip_type(vpp);

			if (type != CCODE_t && type != PCODE_t)
			{
				if (argc == 1)
				{
					ClipVar *rp = mp->fp->sp - argc - 1;

					_clip_clone(mp, rp, vpp);
					--(fp->sp);
					_clip_destroy(mp, fp->sp);
					ret = 0;
				}
				else
				{
					char buf[32];

					_clip_hash_name(mp, hash, buf, sizeof(buf));
					_clip_trap_printf(mp, __file__, __LINE__, "method %s is not code", buf);
					ret = EG_NOMETHOD;
				}
				break;
			}

			vpp = _clip_vptr(vpp);

			if (type == CCODE_t)
				ret = _clip_func(mp, vpp->c.u.func, argc, 0, vpp->c.uplocals);
			else
				ret = _clip_code_func(mp, vpp->c.u.block, argc, 0, vpp->c.uplocals);

		}
		break;
	default:
		ret = _clip_func_hash(mp, hash, argc, 0, 0);
		break;
	}

	mp->inMacro = inMacro;
	if (ret)
		return _clip_call_errblock(mp, ret);

	return ret;
}

CLIP_DLLEXPORT int
_clip_get(struct ClipMachine *mp, long hash)
{
	return obj_call(mp, 0, hash, CALL_GET);
}

CLIP_DLLEXPORT int
_clip_set(struct ClipMachine *mp, long hash)
{
	return obj_call(mp, 1, hash, CALL_SET);
}

/* ] Object calls */
/* [ OutBuf */

void
init_Buf(OutBuf * bp)
{
	bp->buf = bp->ptr = (char *) malloc(64);
	bp->end = bp->buf + 64;
}

void
destroy_Buf(OutBuf * bp)
{
	if (!bp)
		return;
	if (bp->buf)
		free(bp->buf);
}

static void
grow_buf(OutBuf * bp, int min)
{
	int size = bp->end - bp->buf;
	int dsize = size / 2;
	int pos = bp->ptr - bp->buf;

	if (min < 16)
		min = 16;
	if (dsize < min)
		dsize = min;
	size += dsize;
	bp->buf = realloc(bp->buf, size);
	bp->end = bp->buf + size;
	bp->ptr = bp->buf + pos;
}

void
putByte_Buf(OutBuf * bp, unsigned char b)
{
	*bp->ptr = b;
	++(bp->ptr);
	if (bp->ptr >= bp->end)
		grow_buf(bp, 0);
}

void
putBuf_Buf(OutBuf * bp, char *p, int len)
{
	if ((bp->end - bp->ptr) <= len)
		grow_buf(bp, len + 1);
	memcpy(bp->ptr, p, len);
	bp->ptr += len;
}

void
putShort_Buf(OutBuf * bp, short s)
{
	putBuf_Buf(bp, (char *) &s, sizeof(s));
}

void
putLong_Buf(OutBuf * bp, long l)
{
	putBuf_Buf(bp, (char *) &l, sizeof(l));
}

void
putDouble_Buf(OutBuf * bp, double d)
{
	putBuf_Buf(bp, (char *) &d, sizeof(d));
}

void
putStr_Buf(OutBuf * bp, char *str)
{
	putBuf_Buf(bp, str, strlen(str) + 1);
}

/* ] OutBuf */
/* [ utils */
/*
 *    Юлианская -> Календарная
 *    ww - номер дня недели (0 - Вск, 1 - Пнд и т.д.)
 */
CLIP_DLLEXPORT void
_clip_cdate(long ju, int *dd, int *mm, int *yy, int *ww)
{
	long alf, a, b, c, d, e;

	alf = (long) ((ju - 1867216.25) / 36524.25);
	a = ju < 2299161L ? ju : ju + 1L + alf - alf / 4;
	b = a + 1524;
	c = (long) ((b - 122.1) / 365.25);
	d = (long) (365.25 * c);
	e = (long) ((b - d) / 30.6001);
	*dd = b - d - (long) (30.6001 * e);
	if (e < 14)
		*mm = e - 1;
	else
		*mm = e - 13;
	if (*mm > 2)
		*yy = c - 4716;
	else
		*yy = c - 4715;
	*ww = (ju + 1) % 7L;
}

/*
 *    Календарная -> Юлианская
 */
CLIP_DLLEXPORT long
_clip_jdate(int dd, int mm, int yy)
{
	int a, b;

	b = 0;
	if (mm <= 2)
	{
		yy--;
		mm += 12;
	}
	if ((yy * 10000.0 + mm * 100.0 + dd) >= 15821015.0)
	{
		a = yy / 100;
		b = 2 - a + a / 4;
	}
	return ((long) (365.25 * yy - (yy ? 0.0 : 0.75)) + (long) (30.6001 * (mm + 1) + dd + 1720995 + b));
}

CLIP_DLLEXPORT int
_clip_parinfo(ClipMachine * mp, int num)
{
	if (num == 0)
		return mp->argc;
	if (num < 0 || num > mp->argc)
		return 0;

	return _clip_type(mp->bp - (mp->argc - (num - 1)));
}

CLIP_DLLEXPORT int
_clip_parni(ClipMachine * mp, int num)
{
	return (int) _clip_parnd(mp, num);
}

CLIP_DLLEXPORT long
_clip_parnl(ClipMachine * mp, int num)
{
	return (long) _clip_parnd(mp, num);
}

CLIP_DLLEXPORT ClipVar *
_clip_par(ClipMachine * mp, int num)
{
	if (num > 0 && num <= mp->argc)
	{
		ClipVar *vp = (mp->bp - (mp->argc - (num - 1)));

		return _clip_vptr(vp);
	}
	return 0;
}

CLIP_DLLEXPORT ClipVar *
_clip_spar(ClipMachine * mp, int num)
{
	if (num > 0 && num <= mp->argc)
	{
		ClipVar *vp = (mp->bp - (mp->argc - (num - 1)));

		return vp;
	}
	return 0;
}

CLIP_DLLEXPORT int
_clip_par_isref(ClipMachine * mp, int num)
{
	ClipVar *vp = _clip_spar(mp, num);

	if (!vp)
		return 0;
	if (vp->t.flags & F_MPTR)
		return 1;
	return 0;
}

CLIP_DLLEXPORT int
_clip_par_assign(ClipMachine * mp, int num, ClipVar * vp)
{
	ClipVar *lp = _clip_spar(mp, num);

	if (!lp || !vp)
		return -1;
	if (!(lp->t.flags & F_MPTR))
		return 1;
	return _clip_mclone(mp, lp, vp);
}

CLIP_DLLEXPORT int
_clip_par_assign_str(ClipMachine * mp, int num, char *str, int len)
{
	return _clip_par_assign_str_m(mp, num, _clip_memdup(str, len), len);
}

CLIP_DLLEXPORT int
_clip_par_assign_str_m(ClipMachine * mp, int num, char *str, int len)
{
	ClipVar v;
	int r;

	if (!_clip_par_isref(mp, num))
		return -1;
	CLEAR_CLIPVAR(&v);
	v.s.str.buf = str;
	v.s.str.len = len;
	v.t.type = CHARACTER_t;
	v.t.flags = F_NONE;
	v.t.memo = 0;
	r = _clip_par_assign(mp, num, &v);
	_clip_destroy(mp, &v);
	return r;
}

CLIP_DLLEXPORT double
_clip_parnd(ClipMachine * mp, int num)
{
	if (num > 0 && num <= mp->argc)
	{
		ClipVar *vp = _clip_vptr((mp->bp - (mp->argc - (num - 1))));

		if (vp->t.type == NUMERIC_t && !vp->t.memo)
		{
			return vp->n.d;
		}
		if (vp->t.type == NUMERIC_t && vp->t.memo)
			return rational_toDouble(vp->r.r);
	}
	return 0;
}

CLIP_DLLEXPORT int
_clip_parp(ClipMachine * mp, int num, int *len, int *dec)
{
	*len = *dec = 0;

	if (num > 0 && num <= mp->argc)
	{
		ClipVar *vp = (mp->bp - (mp->argc - (num - 1)));

		if (vp->t.flags & F_MPTR)
			vp = vp->p.vp;
		*len = vp->t.len;
		*dec = vp->t.dec;
		return 0;
	}

	return -1;
}

CLIP_DLLEXPORT int
_clip_parl(ClipMachine * mp, int num)
{
	if (num > 0 && num <= mp->argc)
	{
		ClipVar *vp = (mp->bp - (mp->argc - (num - 1)));
		enum ClipVarType type = _clip_type(vp);

		if (type == LOGICAL_t)
		{
			if (vp->t.flags & F_MPTR)
				vp = vp->p.vp;
			return vp->l.val;
		}
	}
	return 0;
}

CLIP_DLLEXPORT char *
_clip_parcl(ClipMachine * mp, int num, int *len)
{
	if (num > 0 && num <= mp->argc)
	{
		ClipVar *vp = (mp->bp - (mp->argc - (num - 1)));
		enum ClipVarType type = _clip_type(vp);

		if (type == CHARACTER_t)
		{
			if (vp->t.flags & F_MPTR)
				vp = vp->p.vp;
			if (len)
				*len = vp->s.str.len;
			return vp->s.str.buf;
		}
	}
	return 0;
}

CLIP_DLLEXPORT char *
_clip_parc(ClipMachine * mp, int num)
{
	return _clip_parcl(mp, num, 0);
}

CLIP_DLLEXPORT void
_clip_retndp(ClipMachine * mp, double n, int len, int dec)
{
	ClipVar *vp = mp->bp - mp->argc - 1;

	if (vp->t.type==CHARACTER_t && vp->s.str.buf != NULL )
		free(vp->s.str.buf);

	vp->t.type = NUMERIC_t;
	vp->t.flags = F_NONE;
	vp->t.memo = 0;
	vp->t.len = len;
	vp->t.dec = dec;
	if (!finite(n))
		n = 0;
	vp->n.d = n;
}

CLIP_DLLEXPORT void
_clip_retni(ClipMachine * mp, int n)
{
	_clip_retndp(mp, n, 0, 0);
}

CLIP_DLLEXPORT void
_clip_retnl(ClipMachine * mp, long n)
{
	_clip_retndp(mp, n, 0, 0);
}

CLIP_DLLEXPORT void
_clip_retnd(ClipMachine * mp, double n)
{
	_clip_retndp(mp, n, 0, 0);
}

CLIP_DLLEXPORT void
_clip_retnr(ClipMachine * mp, rational * r, int len, int dec)
{
	ClipVar *vp = mp->bp - mp->argc - 1;

	if (vp->t.type==CHARACTER_t && vp->s.str.buf != NULL )
		free(vp->s.str.buf);

	vp->t.type = NUMERIC_t;
	vp->t.flags = F_NONE;
	vp->t.len = len;
	vp->t.dec = dec;
	vp->t.memo = 1;
	vp->r.r = r;
}

CLIP_DLLEXPORT void
_clip_retl(ClipMachine * mp, int n)
{
	ClipVar *vp = mp->bp - mp->argc - 1;

	if (vp->t.type==CHARACTER_t && vp->s.str.buf != NULL )
		free(vp->s.str.buf);

	vp->t.type = LOGICAL_t;
	vp->t.flags = F_NONE;
	vp->l.val = n;
}

CLIP_DLLEXPORT void
_clip_retcn(ClipMachine * mp, char *s, int l)
{
	ClipVar *vp = mp->bp - mp->argc - 1;

	if (vp->t.type==CHARACTER_t && vp->s.str.buf != NULL )
		free(vp->s.str.buf);

	vp->t.type = CHARACTER_t;
	vp->t.flags = F_NONE;

	if (!s)
	{
		l = 0;
		s = "";
	}

	vp->s.str.buf = _clip_memdup(s, l);
	vp->s.str.len = l;
}

CLIP_DLLEXPORT void
_clip_retcn_m(ClipMachine * mp, char *s, int l)
{
	ClipVar *vp = RETPTR(mp);

	if (vp->t.type==CHARACTER_t && vp->s.str.buf != NULL )
		free(vp->s.str.buf);
	memset(vp, 0, sizeof(ClipVar));
	vp->t.type = CHARACTER_t;
	vp->t.flags = F_NONE;

	vp->s.str.buf = s;
	vp->s.str.len = l;
}

CLIP_DLLEXPORT void _clip_retc(ClipMachine * mp, char *s)
{
	int l = 0;

	if (s)
		l = strlen(s);
	_clip_retcn(mp, s, l);
}

CLIP_DLLEXPORT int
_clip_storclen(ClipMachine * mp, const char *str, int len, int num, int ind)
{
#if 1
	ClipVar *vp = _clip_spar(mp, num);
	ClipVar lp ;

	if (!vp)
		return 0;

	if (vp->t.type == ARRAY_t)
	{
		if (ind < 0 || ind >= vp->a.count)
			return 0;
		vp = _clip_vptr(vp->a.items + ind);
	}

	if (vp->t.flags == F_MSTAT)
		return 0;

	_clip_var_str(str, len, &lp);
	_clip_mclone(mp, vp, &lp);
	_clip_destroy(mp,&lp);
#else
	ClipVar *vp = _clip_par(mp, num);

	if (!vp)
		return 0;

	if (vp->t.type == ARRAY_t)
	{
		if (ind < 0 || ind >= vp->a.count)
			return 0;
		vp = _clip_vptr(vp->a.items + ind);
	}

	if (vp->t.flags == F_MSTAT)
		return 0;

	_clip_destroy(mp, vp);
	_clip_var_str(str, len, vp);
#endif
	return 1;
}

CLIP_DLLEXPORT int
_clip_storc(ClipMachine * mp, const char *str, int num, int ind)
{
	return _clip_storclen(mp, str, strlen(str), num, ind);
}

CLIP_DLLEXPORT int
_clip_stornd(ClipMachine * mp, double d, int num, int ind)
{
#if 1
	ClipVar *vp = _clip_spar(mp, num);
	ClipVar lp ;

	if (!vp)
		return 0;

	if (vp->t.type == ARRAY_t)
	{
		if (ind < 0 || ind >= vp->a.count)
			return 0;
		vp = _clip_vptr(vp->a.items + ind);
	}

	if (vp->t.flags == F_MSTAT)
		return 0;

	_clip_var_num(d,&lp);
	_clip_mclone(mp, vp, &lp);
	_clip_destroy(mp,&lp);
#else
	ClipVar *vp = _clip_par(mp, num);

	if (!vp)
		return 0;

	if (vp->t.type == ARRAY_t)
	{
		if (ind < 0 || ind >= vp->a.count)
			return 0;
		vp = _clip_vptr(vp->a.items + ind);
	}

	if (vp->t.flags == F_MSTAT)
		return 0;

	_clip_destroy(mp, vp);
	_clip_var_num(d, vp);
#endif
	return 1;
}

CLIP_DLLEXPORT int
_clip_storni(ClipMachine * mp, int d, int num, int ind)
{
	return _clip_stornd(mp, d, num, ind);
}

CLIP_DLLEXPORT int
_clip_stornl(ClipMachine * mp, long d, int num, int ind)
{
	return _clip_stornd(mp, d, num, ind);
}

CLIP_DLLEXPORT int
_clip_storl(ClipMachine * mp, int val, int num, int ind)
{
	ClipVar *vp = _clip_par(mp, num);

	if (!vp)
		return 0;

	if (vp->t.type == ARRAY_t)
	{
		if (ind < 0 || ind >= vp->a.count)
			return 0;
		vp = _clip_vptr(vp->a.items + ind);
	}

	if (vp->t.flags == F_MSTAT)
		return 0;

	_clip_destroy(mp, vp);
	_clip_var_log(val, vp);

	return 1;
}

static int
incr_var(ClipMachine * mp, ClipVar * vp, int isIncr)
{
	vp = _clip_vptr(vp);

	switch (vp->t.type)
	{
	case NUMERIC_t:
		if (vp->t.memo)
		{
			rational *tmp = rational_long_init((long) 1);

			rational_adda(vp->r.r, tmp);
			rational_destroy(tmp);
		}
		else
			vp->n.d += (isIncr ? 1 : -1);
		return 0;
	case DATE_t:
		vp->d.julian += (isIncr ? 1 : -1);
		return 0;
	default:
		_clip_trap_str(mp, __file__, __LINE__, "invalid type in INCR/DECR operation");
		return _clip_call_errblock(mp, 1);
	}
}

CLIP_DLLEXPORT int
_clip_incr(struct ClipMachine *mp, void *lval, int isIncr, int isPost)
{
	int ret;
	ClipVar *vp = (ClipVar *) lval;

	if (isPost)
	{
		if ((ret = _clip_push(mp, vp)))
			return ret;
		if ((ret = incr_var(mp, vp, isIncr)))
			return ret;
	}
	else
	{
		if ((ret = incr_var(mp, vp, isIncr)))
			return ret;
		if ((ret = _clip_push(mp, vp)))
			return ret;
	}
	return 0;
}

CLIP_DLLEXPORT ClipVar *
_clip_unptr(ClipVar * vp)
{
	return _clip_vptr(vp);
}

CLIP_DLLEXPORT int
_clip_find_obj(ClipMachine * mp, long otype, ClipObjRtti ** rtti)
{
	ClipObjRtti **rp;

	for (rp = init_struct->_objrtti; *rp; ++rp)
		if ((*rp)->hashId == otype)
		{
			*rtti = *rp;
			return 0;
		}

	return 1;
}

static int
do_main(ClipMachine * mp, long hash, ClipFunction * func, ClipBlock * block, int argc, char **argv, char **envp)
{
	int i, ret;
#ifdef OS_MINGW
	ClipVar *_stack = (ClipVar *) malloc(sizeof(ClipVar) * (argc + 1));
#else
	ClipVar *_stack = (ClipVar *) alloca(sizeof(ClipVar) * (argc + 1));
#endif
	ClipFrame _frame =
		{ _stack, _stack, "" /*__FILE__*//* ": do_main()" */ , /*__LINE__*/ 0, 0, 0, 0, 0, 0, 0, 0, argc + 1, 0 };

	_frame.up = mp->fp;
	mp->fp = &_frame;
	if (_clip_init(mp, argc, argv, envp))
		goto _trap;
	argc = _clip_argc;
	argv = _clip_argv;

	if (!argc)
		argc = 1;
	mp->argc = argc - 1;
	_frame.sp->t.type = UNDEF_t;
	_frame.sp->t.flags = F_NONE;
	_frame.sp++;
	CLIP_CHECK_STACK;
	for (i = 1; i < argc; ++i, ++_frame.sp)
		_clip_var_str(argv[i], strlen(argv[i]), _frame.sp);

	init_machine(mp);
	if (func)
		ret = do_call(mp, func, argc - 1, 0, 0, 0);
	else if (block)
		ret = _clip_code_func(mp, block, argc - 1, 0, 0);
	else
		ret = _clip_func_hash(mp, hash, argc - 1, 0, 0);

	if (ret)
	{
		_clip_trap(mp, __file__, __LINE__);
		goto _trap;
	}

	ret = _clip_long(_stack);
	goto _return;
	  _trap:
	{
		char *msg = 0;

		descr_str(mp, mp->trapVar, &msg);
		if (!msg)
			msg = "unknown runtime error";
		printf("\n%s: runtime error: %s\n", _clip_progname, msg);
		_clip_logg(1, "%s: runtime error: %s", _clip_progname, msg);
		for (i = 0; i < mp->trapTrace.count; ++i)
		{
			printf("trace: %s\n", (char *) mp->trapTrace.items[i]);
			_clip_logg(1, "trace: %s", (char *) mp->trapTrace.items[i]);
		}
		ret = 1;
	}
	  _return:
	_clip_resume(mp, 0, 0);
	if (ret == 0)
		ret = errorlevel;
#ifdef OS_MINGW
	free(_stack);
#endif
	return ret;
}

CLIP_DLLEXPORT int
_clip_main(ClipMachine * mp, long hash, int argc, char **argv, char **envp)
{
	int ret;
	mp->main_func_level++;
	ret = do_main(mp, hash, NULL, NULL, argc, argv, envp);
	mp->main_func_level--;
	if (mp->main_func_level == 0)
		delete_ClipMachine(mp);
	return ret;
}

CLIP_DLLEXPORT int
_clip_main_func(ClipMachine * mp, ClipFunction func, int argc, char **argv, char **envp)
{
	int ret;
	mp->main_func_level++;
	ret = do_main(mp, 0, func, NULL, argc, argv, envp);
	mp->main_func_level--;
	if (mp->main_func_level == 0)
		delete_ClipMachine(mp);
	return  ret;
}

CLIP_DLLEXPORT int
_clip_main_code(ClipMachine * mp, ClipBlock * block, int argc, char **argv, char **envp)
{
	int ret;
	mp->main_func_level++;
	ret = do_main(mp, 0, NULL, block, argc, argv, envp);
	mp->main_func_level--;
	if (mp->main_func_level == 0)
		delete_ClipMachine(mp);
	return ret;
}

CLIP_DLLEXPORT const char *
_clip_typename(ClipVar * vp)
{
	enum ClipVarType type = _clip_type(vp);

	if (!vp)
		return "NIL";
	switch (type)
	{
	case UNDEF_t:
		return "UNDEF";
	case NUMERIC_t:
		return "NUMERIC";
	case CHARACTER_t:
		return "CHARACTER";
	case LOGICAL_t:
		return "LOGICAL";
	case DATE_t:
		return "DATE";
	case OBJECT_t:
		return "OBJECT";
	case PCODE_t:
		return "PCODE";
	case CCODE_t:
		return "CCODE";
	case ARRAY_t:
		return "ARRAY";
	case MAP_t:
		return "MAP";
	case MEMO_t:
		return "MEMO";
	case DATETIME_t:
		return "DATETIME";
	}
	return "UNKNOWN";
}

/* ] utils */

static int
cmp_hash_bucket(const void *p1, const void *p2)
{
	unsigned long h1 = (unsigned long) GETLONG(p1);
	unsigned long h2 = ((ClipHashBucket *) p2)->hash;

	if (h1 < h2)
		return -1;
	else if (h1 > h2)
		return 1;
	else
		return 0;
}

CLIP_DLLEXPORT void
_clip_hash_name(ClipMachine * mp, long hash, char *buf, int buflen)
{
	ClipFrame *fp;
	char *s = 0;

	if (!buflen)
		return;
	else
		buf[0] = 0;

	switch (hash)
	{
	case HASH_main:
		s = "MAIN";
		break;
	case HASH_filename:
		s = "filename";
		break;
	case HASH_operation:
		s = "operation";
		break;
	case HASH_tries:
		s = "tries";
		break;
	case HASH_canSubstitute:
		s = "canSubstitute";
		break;
	case HASH_canRetry:
		s = "canRetry";
		break;
	case HASH_canDefault:
		s = "canDefault";
		break;
	case HASH_osCode:
		s = "osCode";
		break;
	case HASH_genCode:
		s = "genCode";
		break;
	case HASH_severity:
		s = "severity";
		break;
	case HASH_description:
		s = "description";
		break;
	case HASH_args:
		s = "args";
		break;
	case HASH_cargo:
		s = "cargo";
		break;
	case HASH_subCode:
		s = "subCode";
		break;
	case HASH_subSystem:
		s = "subSystem";
		break;
	case HASH_syserr:
		s = "syserr";
		break;
	}

	if (s)
	{
		strncpy(buf, s, buflen);
		return;
	}

	s = (char *) HashTable_fetch(mp->hashnames, hash);
	if (s)
	{
		strncpy(buf, s, buflen);
		return;
	}

	for (fp = mp->fp; fp; fp = fp->up)
	{
		if (fp->names)
		{
			ClipHashBucket *bp;

			bp = (ClipHashBucket *) bsearch(&hash, fp->names->buckets,
							fp->names->num, sizeof(ClipHashBucket), cmp_hash_bucket);
			if (bp)
			{
				strncpy(buf, fp->names->mem + bp->offs, buflen);
				return;
			}
		}
	}

	snprintf(buf, buflen, "0x%08lx", hash);
}

CLIP_DLLEXPORT long
_clip_pardj(ClipMachine * mp, int num)
{
	if (num > 0 && num <= mp->argc)
	{
		ClipVar *vp = (mp->bp - (mp->argc - (num - 1)));
		enum ClipVarType type = _clip_type(vp);

		if (type == DATE_t)
		{
			if (vp->t.flags & F_MPTR)
				vp = vp->p.vp;
			return vp->d.julian;
		}
	}
	return 0;
}

CLIP_DLLEXPORT long
_clip_pardtj(ClipMachine * mp, int num, long *time)
{
	if (num > 0 && num <= mp->argc)
	{
		ClipVar *vp = (mp->bp - (mp->argc - (num - 1)));
		enum ClipVarType type = _clip_type(vp);

		if (type == DATETIME_t)
		{
			if (vp->t.flags & F_MPTR)
				vp = vp->p.vp;
			*time = vp->dt.time;
			return vp->dt.julian;
		}
	}
	return 0;
}

CLIP_DLLEXPORT long
_clip_pardc(ClipMachine * mp, int num, int *yy, int *mm, int *dd, int *ww)
{
	long julian = _clip_pardj(mp, num);

	_clip_cdate(julian, dd, mm, yy, ww);
	return julian;
}

CLIP_DLLEXPORT void
_clip_retdj(ClipMachine * mp, long julian)
{
	ClipVar *vp = RETPTR(mp);

	if (vp->t.type==CHARACTER_t && vp->s.str.buf != NULL )
		free(vp->s.str.buf);

	vp->t.type = DATE_t;
	vp->t.flags = F_NONE;
	vp->t.len = 8;
	vp->t.dec = 0;
	vp->d.julian = julian;
}

CLIP_DLLEXPORT void
_clip_retdtj(ClipMachine * mp, long julian, long time)
{
	ClipVar *vp = RETPTR(mp);

	if (vp->t.type==CHARACTER_t && vp->s.str.buf != NULL )
		free(vp->s.str.buf);

	vp->t.type = DATETIME_t;
	vp->t.flags = F_NONE;
	vp->t.len = 8;
	vp->t.dec = 0;
	vp->dt.julian = julian;
	vp->dt.time = time;
}

CLIP_DLLEXPORT void
_clip_retdc(ClipMachine * mp, int yy, int mm, int dd)
{
	_clip_retdj(mp, _clip_jdate(dd, mm, yy));
}

CLIP_DLLEXPORT int
_clip_stordj(ClipMachine * mp, long julian, int num, int ind)
{
	ClipVar *vp = _clip_par(mp, num);

	if (!vp)
		return 0;

	if (vp->t.type == ARRAY_t)
	{
		if (ind < 0 || ind >= vp->a.count)
			return 0;
		vp = _clip_vptr(vp->a.items + ind);
		goto assign;
	}
	else if (vp->t.type == DATE_t)
	{
		  assign:
		if (vp->t.flags == F_MSTAT)
			return 0;
		vp->d.julian = julian;
	}
	else
	{
		return 0;
	}

	return 1;
}

CLIP_DLLEXPORT int
_clip_stordc(ClipMachine * mp, int yy, int mm, int dd, int num, int ind)
{
	return _clip_stordj(mp, _clip_jdate(dd, mm, yy), num, ind);
}

#define DD_BUF_LEN 	7

long
_clip_str_to_date(char *str, char *format, int epoch)
{
	int i, j, len;
	int d = 0, m = 0, y = 0;
	int b[3] = { 0, 0, 0 };
	int mms[12] = {31,29,31,30,31,30,31,31,30,31,30,31};
	char ch = 0;

	if (epoch == 0)
		epoch = CLIP_EPOCH_DEFAULT;
	if (format == NULL)
		format = CLIP_DATEFORMAT_DEFAULT;

	len = strlen(format);
	for (i = 0, j = 0; i < len; i++)
	{
		if (ch == format[i])
			continue;
		switch (format[i])
		{
		case 'y':
		case 'Y':
			y = j;
			break;
		case 'm':
		case 'M':
			m = j;
			break;
		case 'd':
		case 'D':
			d = j;
			break;
		case ' ':
			break;
		default:
			j++;
			break;
		}
		if (j > 2)
			break;
		ch = format[i];
	}
	if (j < 2)
		return 0;

	len = strlen(str);

	for (i = 0; i < len && !isdigit(str[i]); i++);

	for (j = 0, b[0] = i; i < len && j < 2; i++)
	{
		ch = str[i];
		if ((ch < '0' || ch > '9') && ch != ' ')
		{
			for (; i < len && !isdigit(str[i]); i++);
			j++;
			b[j] = i;
		}
	}
	if (j < 2)
		return 0;
	m = atoi(str + b[m]);
	d = atoi(str + b[d]);
	y = atoi(str + b[y]);
	if (m == 0 && d == 0 && y == 0)
		return 0;
	if (m > 12 || d > 31)
		return 0;
	/*
	printf("\nctod m=%d,d=%d,mms[m]=%d\n",m,d,mms[m]);
	*/
	if (m > 0 && (d > mms[m-1]))
		return 0;

	i = epoch % 100;
	j = epoch / 100;
	if (y < 100)
	{
		if (y < i)
			y += (j + 1) * 100;
		else
			y += j * 100;
	}
	return _clip_jdate(d, m, y);
}

CLIP_DLLEXPORT void
_clip_datetostr(long date, char *buf)
{
	int dd, mm, yy, ww;
	char *sss = "0123456789";

	buf[8] = 0;
	if (date == 0)
	{
		memset(buf, ' ', 8);
		return;
	}
	_clip_cdate(date, &dd, &mm, &yy, &ww);
	buf[7] = sss[dd % 10];
	buf[6] = sss[dd / 10];
	buf[5] = sss[mm % 10];
	buf[4] = sss[mm / 10];

	buf[3] = sss[yy % 10];
	yy /= 10;
	buf[2] = sss[yy % 10];
	yy /= 10;
	buf[1] = sss[yy % 10];
	yy /= 10;
	buf[0] = sss[yy];
}

CLIP_DLLEXPORT char *
_clip_date_to_str(long date, char *format)
{
	int i, fl;
	int dl = 1, ml = 1, yl = 1;
	int dd, mm, yy, ww;
	char ch, ch2;
	char ds[DD_BUF_LEN + 1], ms[DD_BUF_LEN + 1], ys[DD_BUF_LEN + 1];
	char *ret;

	if (format == NULL)
		format = CLIP_DATEFORMAT_DEFAULT;
	fl = strlen(format);
	ret = malloc(fl + 1);
	memset(ret, 32, fl - 1);
	ret[fl] = 0;
	memset(ds, 32, DD_BUF_LEN);
	ds[DD_BUF_LEN] = 0;
	memset(ms, 32, DD_BUF_LEN);
	ms[DD_BUF_LEN] = 0;
	memset(ys, 32, DD_BUF_LEN);
	ys[DD_BUF_LEN] = 0;

	_clip_cdate(date, &dd, &mm, &yy, &ww);
	if (date != 0)
	{
		snprintf(ds, DD_BUF_LEN + 1, "%07d", dd);
		snprintf(ms, DD_BUF_LEN + 1, "%07d", mm);
		snprintf(ys, DD_BUF_LEN + 1, "%07d", yy);
	}
	for (i = fl; i >= 0; i--)
	{
		ch = format[i];
		switch (ch)
		{
		case 'd':
		case 'D':
			ch2 = ds[DD_BUF_LEN - dl];
			dl++;
			break;
		case 'm':
		case 'M':
			ch2 = ms[DD_BUF_LEN - ml];
			ml++;
			break;
		case 'y':
		case 'Y':
			ch2 = ys[DD_BUF_LEN - yl];
			yl++;
			break;
		default:
			ch2 = ch;
			break;
		}
		ret[i] = ch2;
		/*printf("%c%c%d%d%d.",ch,ch2,dl,ml,yl); */
	}
	return ret;
}

/*
   1) returns number of characters matched, -1 if failed.
   (Can return 0 on patterns like "" or "$")
   2) does not require pattern to match to end of string
   3) case-independent
 */

CLIP_DLLEXPORT int
_clip_glob_match(const char *string, const char *pattern, int caseflag)
{
	char c2;
	int match = 0;		/* # of chars matched */

	while (1)
	{
		/* If at end of pattern, success! */
		if (*pattern == 0)
		{
#if 0
			return match;
#else
			/* uri added: bug with pattern length < string length */
			if (*string == 0)
				return match;
			else
				return (-1);
#endif
		}

		/* If last pattern character is '$', verify that entire
		 * string has been matched.
		 */
		if ((*pattern == '$') && (pattern[1] == 0))
		{
			if (*string == 0)
				return (match);
			else
				return (-1);
		}

		/* Check for a "*" as the next pattern character.  It matches
		 * any substring.  We handle this by calling ourselves
		 * recursively for each postfix of string, until either we
		 * match or we reach the end of the string.
		 */

		if (*pattern == '*')
		{

			int head_len;
			const char *tail;

			pattern += 1;
			if (*pattern == 0)
			{
				return (strlen(string) + match);	/* DEL */
			}

			/* find longest match - switched to this on 12/31/93 */
			head_len = strlen(string);	/* length before tail */
			tail = string + head_len;
			/*printf("pattern='%s' tail='%s'\n", pattern, tail); */
			while (head_len >= 0)
			{
				int rc;

				if (-1 != (rc = _clip_glob_match(tail, pattern, caseflag)))
				{
					/*printf("rc=%d match=%d head_len=%d tail='%s' str='%s' patt='%s'\n", rc, match, head_len, tail,
					   sstr, patt); */
					return rc + match + head_len;	/* DEL */
				}
				tail--;
				head_len--;
			}

			return -1;	/* DEL */
		}

#if 1
		if (*pattern == '?')
		{
			if (!*string)
			{
				for (; *pattern; pattern++)
					if (*pattern != '?' && *pattern != '*')
						return -1;
				return match;
			}
		}
#endif
		/*
		 * after this point, all patterns must match at least one
		 * character, so check this
		 */

		if (*string == 0)
			return -1;

#if 1
		/* Check for a "?" as the next pattern character.  It matches
		 * any single character.
		 */

		if (*pattern == '?')
		{
			goto thisCharOK;
		}
#endif
		/* Check for a "[" as the next pattern character.  It is followed
		 * by a list of characters that are acceptable, or by a range
		 * (two characters separated by "-").
		 */

		if (*pattern == '[')
		{
			pattern += 1;
			while (1)
			{
				if ((*pattern == ']') || (*pattern == 0))
				{
					return -1;	/* was 0; DEL */
				}
				if (*pattern == *string)
				{
					break;
				}
				if (pattern[1] == '-')
				{
					c2 = pattern[2];
					if (c2 == 0)
					{
						return -1;	/* DEL */
					}
					if ((*pattern <= *string) && (c2 >= *string))
					{
						break;
					}
					if ((*pattern >= *string) && (c2 <= *string))
					{
						break;
					}
					pattern += 2;
				}
				pattern += 1;
			}

/* OOPS! Found a bug in vanilla Tcl - have sent back to Ousterhout */
/* but he hasn't integrated it yet. - DEL */

#if 0
			while ((*pattern != ']') && (*pattern != 0))
#else
			while (*pattern != ']')
			{
				if (*pattern == 0)
				{
					pattern--;
					break;
				}
#endif
				pattern += 1;
			}
			goto thisCharOK;
		}

		/* If the next pattern character is backslash, strip it off
		 * so we do exact matching on the character that follows.
		 */

		if (*pattern == '%')
		{
			pattern += 1;
			if (*pattern == 0)
			{
				return -1;
			}
			switch (*pattern)
			{
			case 'r':
				if (*string != '\r')
					return -1;
				break;
			case 'n':
				if (*string != '\n')
					return -1;
				break;
			case 's':
				if (*string != ' ')
					return -1;
				break;
			case 'e':
				if (*string != '\033')
					return -1;
				break;
			default:
				if (*string != *pattern)
					return -1;
				break;
			}
		}
		else if ((caseflag && _clip_toupper(*pattern) != _clip_toupper(*string)) || (!caseflag && *pattern != *string))
		{
			return -1;
		}

		  thisCharOK:
		pattern += 1;
		string += 1;
		match++;
	}
}

typedef struct
{
	void *item;
	void (*destroy) (void *);
}
item_bucket;

CLIP_DLLEXPORT void *
_clip_fetch_item(ClipMachine * mp, long hash)
{
	item_bucket *ip;

	ip = (item_bucket *) HashTable_fetch(mp->store, hash);
	if (ip)
		return ip->item;
	else
		return 0;
}

CLIP_DLLEXPORT void
_clip_store_item(ClipMachine * mp, long hash, void *item)
{
	item_bucket *ip;

	_clip_free_item(mp, hash);
	ip = NEW(item_bucket);
	ip->item = item;
	HashTable_store(mp->store, ip, hash);
}

CLIP_DLLEXPORT void
_clip_store_item_destroy(ClipMachine * mp, long hash, void *item, void (*destroy) (void *))
{
	item_bucket *ip;

	_clip_free_item(mp, hash);
	ip = NEW(item_bucket);
	ip->item = item;
	ip->destroy = destroy;
	HashTable_store(mp->store, ip, hash);
}

CLIP_DLLEXPORT void
_clip_free_item(ClipMachine * mp, long hash)
{
	item_bucket *ip;

	ip = (item_bucket *) HashTable_remove(mp->store, hash);
	if (ip)
	{
		if (ip->destroy)
			ip->destroy(ip->item);
		else
			free(ip->item);
		free(ip);
	}
}

CLIP_DLLEXPORT void
_clip_remove_item(ClipMachine * mp, long hash)
{
	void *rp;

	rp = HashTable_remove(mp->store, hash);
	free(rp);
}

/*
 * CONTAINER
 */

CLIP_DLLEXPORT int
_clip_compare_c_item(const void *p1, const void *p2)
{
	return ((ContainerItem *) p1)->key - ((ContainerItem *) p2)->key;
}

CLIP_DLLEXPORT int
_clip_compare_c_item_type(const void *p1, const void *p2)
{
	return ((ContainerItem *) p1)->type - ((ContainerItem *) p2)->type;
}

CLIP_DLLEXPORT void *
_clip_fetch_c_item(ClipMachine * cm, int key, int type)
{
	ContainerItem citem, *ci = NULL;

	if (cm->container == NULL)
		return NULL;

	citem.key = key;
	ci = bsearch(&citem, cm->container->items, cm->container->len, sizeof(ContainerItem), _clip_compare_c_item);
	return (ci && ci->type == type ? ci->item : NULL);
}

CLIP_DLLEXPORT void *
_clip_fetch_c_item_type(ClipMachine * cm, int type, int *key)
{
	ContainerItem citem, *ci = NULL;

	if (cm->container == NULL)
		return NULL;

	if (key)
		*key = -1;
	citem.type = type;
	ci = bsearch(&citem, cm->container->items, cm->container->len, sizeof(ContainerItem), _clip_compare_c_item_type);
	if (ci && key)
		*key = ci->key;
	return (ci ? ci->item : NULL);
}

CLIP_DLLEXPORT int
_clip_destroy_c_item(ClipMachine * cm, int key, int type)
{
	int len;
	Container *cn = cm->container;
	ContainerItem citem, *ci = NULL;

	if (cn == NULL)
		return 0;
	citem.key = key;
	ci = bsearch(&citem, cn->items, cn->len, sizeof(ContainerItem), _clip_compare_c_item);
	if (ci == NULL || ci->type != type)
		return 0;

	if (ci->destroy)
		ci->destroy(ci->item);

	len = cn->len * sizeof(ContainerItem) - (ci - cn->items + 1) * sizeof(ContainerItem);

	/*printf( "_destroy_: items=%lx, item=%lx, len=%d\n", cn->items, ci, len ); */

	if (len > 0)
		memmove(ci, ci + 1, len);

	cn->len--;

	return 1;
}

CLIP_DLLEXPORT int
_clip_store_c_item(ClipMachine * cm, void *item, int type, void (*destroy) (void *))
{
	Container *cn = NULL;
	ContainerItem citem;
	int i = 0;

	citem.item = item;
	citem.type = type;
	citem.destroy = destroy;

	cn = cm->container;

	/* search for first unused key */
	for (i = 0; i < cn->len; i++)
	{
		if (i != cn->items[i].key)
			break;
	}
	citem.key = i;

	cn->items = (ContainerItem *) realloc(cn->items, (cn->len + 1) * sizeof(ContainerItem));

	cn->items[cn->len++] = citem;

	qsort(cn->items, cn->len, sizeof(ContainerItem), _clip_compare_c_item);

	/*printf( "arr:" );
	   for( i=0; i < cn->len; i++ ) {
	   printf( "<it=%lx, f=%lx>", &(cn->items)[i], (cn->items)[i].item );
	   }
	   printf( "\n" ); */

	return citem.key;
}

/*
 * CONTAINER end
 */

static char *
_clip_normalize_path(char * _path)
{
	/* translate "path1/../path2" -> "path2" */
	int pos[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	int pos2[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	int flag[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
	int i,beg,end,len,cur = 1, cur2 = 0;
	char *tmp;
	char *path;

	path = strdup(_path);

	i = 0;
	if ( path[i]=='/' || path[i]=='\\')
		 { i++; pos[0]=1;}
	for (len=strlen(path); i<len; i++)
	{
		if ( path[i] == '.' )
			flag[cur]++;
		else if ( path[i]=='/' || path[i]=='\\')
		{
			pos[cur]=i+1;
			cur++;
		}
		else
			flag[cur]--;
		if (cur>15)
			break;
	}
	for (cur=0,cur2=-1; cur<16; cur++)
	{
		if ( flag[cur] == 2) /* subpath ==".." */
			cur2--;
		else
			cur2++;
		if ( cur2 < 0)
			cur2 = 0;
		//printf("\ncur=%d,flag=%d,cur2=%d",cur,flag[cur],cur2);
		pos2[cur2] = cur;
	}

	tmp = strdup(path);
	//printf("\npos[0]=%d,pos[1]=%d,pos[2]=%d",pos[0],pos[1],pos[2]);
	//printf("\npo2[0]=%d,po2[1]=%d,po2[2]=%d",pos2[0],pos2[1],pos2[2]);
	memset(path,0,len);
	for (i=0,len=0; i<16; i++)
	{
		beg = pos[ pos2[i] ];
		end = pos[ pos2[i]+1 ];
		if (end == 0)
		{
			end = strlen(tmp);
			i = 200;
		}
		strncpy(path+len,tmp+beg,end-beg);
		len+=(end-beg);
		//printf("\ni=%d,pos2=%d,beg=%d,end=%d,tmp=%s,str=%s\n",i,pos2[i],beg,end,tmp,path);
	}
	return path;
}

CLIP_DLLEXPORT int
_clip_translate_path(ClipMachine * mp, const char *str, char *buf, int buflen)
{
#ifdef _WIN32
	if ((memcmp(str, "\\\\", 2) == 0) || (memcmp(str, "//", 2) == 0))
	{
		/* network resource */
		strncpy(buf, str, buflen);
		return 0;
	}

	if (str != NULL && (*str == '/' || *str == '\\') && memcmp(str, "/cygdrive/", 10))
	{
		/* add default drive */
		char *s = _clip_fetch_item(mp, CLIP_CUR_DRIVE);
		if (mp->rootpath==NULL)
			snprintf(buf, buflen - 1, "%s%s", s, str);
		else
		{
			char * _str = NULL;
			_str = _clip_normalize_path( ( char *) str);
			snprintf(buf, buflen - 1, "%s%s%s",s,mp->rootpath, _str);
			free(_str);
		}
		return 0;
	}
	if (str != NULL && strlen(str) >= 2 && str[1] == ':' && str[2] != '/' && str[2] != '\\')
	{
		/* drive with default path */
		char *def_path;

		def_path = _clip_fetch_item(mp, _hash_cur_dir[toupper(*str) - 65]);
		snprintf(buf, buflen - 1, "%c:%s%s\\%s", *str, mp->rootpath, def_path, str + 2);
		return 0;
	}
	if (mp->rootpath == NULL )
		snprintf(buf,buflen-1,"%s",str);
	else
	{
		char * _str = NULL;
		_str = _clip_normalize_path( ( char *) str);
		snprintf(buf,buflen-1,"%s%s",mp->rootpath,_str);
		free(_str);
	}
	return 0;
#else
	char *s, *e;
	char *root = 0;
	int bl, ch;

	buf[0] = 0;
	if (strchr(str, '|'))
	{
		strncpy(buf, str, buflen);
		buf[buflen - 1] = 0;
		return 0;
	}

	if ((s = strchr(str, ':')) && s == str + 1)
	{
		char dn[3];
		long dh;

		dn[0] = toupper(*str);
		dn[1] = ':';
		dn[2] = 0;
		dh = _clip_hashstr(dn);
		if ((root = _clip_fetch_item(mp, dh)) == NULL)
		{
			return -1;
		}

		str = s + 1;
		while ((ch = *str) && (ch == '\\' || ch == '/'))
			++str;
	}

	bl = 0;
	if (root)
	{
		snprintf(buf, buflen - 1, "%s", root);
		bl = strlen(buf);
		if (bl > 0 && (buf[bl - 1] == '/' || buf[bl - 1] == '\\'))
			--bl;
		buf[bl++] = '/';
	}
	/*
	else if (str[0] == '.' && str[1] == '.')
	{
		strncpy(buf, str, buflen);
		return 1;
	}
	*/
	else if ( *str != '/' /*&& *str != '\\'*/)
	{
		if ( mp->rootpath == NULL )
		{
			getcwd(buf, buflen);
			bl = strlen(buf);
			buf[bl++] = '/';
		}
	}
	if ( mp->rootpath != NULL )
	{
		char * _str = NULL;
		char * tmp = strdup(buf);
		snprintf(buf,buflen, "%s%s",mp->rootpath,tmp);
		free(tmp);
		bl = strlen(buf);
		_str = _clip_normalize_path( ( char *) str);
		snprintf(buf + bl, buflen - bl, "%s", _str);
		free(_str);
	}
	else
	{
		snprintf(buf + bl, buflen - bl, "%s", str);
	}
	bl = strlen(buf);
	for (e = buf + bl, s = buf; s < e; ++s)
	{
		if (*s == '\\')
			*s = '/';
	}
	s = strrchr(buf,'/');
	if (s && s != buf )
	{
		char ocwd[PATH_MAX];
		char fname[PATH_MAX];
		char ch;

		getcwd(ocwd,sizeof(ocwd));

		strncpy(fname,s+1,sizeof(fname));

		ch  = *s;
		* s = 0;
		if (chdir(buf) == 0)
		{
			getcwd(buf,buflen);
			strcat(buf,"/");
			strcat(buf,fname);
			chdir(ocwd);
		}
		else
			*s = ch;
	}
	bl = strlen(buf);
	if (mp->flags & TRANSLATE_FLAG)
	{
#if 1
		int i,j;
		for (i=0,j=0; i<bl; i++)
		{
			if (buf[i] == ' ')
				continue;
			buf[j] = tolower((unsigned char) (buf[i]));
			j ++;
		}
		buf[j] = 0;
#else
		char *tmp;
		for (e = buf + bl, s = buf; s < e; ++s)
			*s = tolower(*(unsigned char *) s);
		for (tmp=buf+strlen(buf)-1; *tmp == ' ' && tmp>=buf; tmp--);
		tmp++; *tmp=0;
#endif
	}
	return 0;
#endif
}

CLIP_DLLEXPORT void
_clip_mptr(ClipMachine * mp, ClipVar * refs, int num)
{
	while (num--)
	{
		ClipVar *vp = NEW(ClipVar);

		refs->t.type = UNDEF_t;
		refs->t.flags = F_MREF;
		refs->p.vp = vp;
		refs->t.field = 0;
		refs->p.fp = 0;
		vp->t.count = 1;

		refs++;
	}
}

CLIP_DLLEXPORT ClipVar *
_clip_new_error(ClipMachine * mp,
		const char *description, int severity,
		int genCode, int osCode,
		int canDefault, int canRetry, int canSubstitute,
		int tries, const char *subSystem, int subCode, const char *operation)
{
	ClipVar *rp = NEW(ClipVar);
	ClipVar var;
	char *s;
	long dim;
	int i;

	_clip_map(mp, rp);

	memset(&var, 0, sizeof(var));

	/* 'cargo' */

	dim = mp->argc;
	_clip_array(mp, &var, 1, &dim);
	for (i = 0; i < mp->argc; i++)
	{
		dim = i;
		_clip_aset(mp, &var, ARGPTR(mp, i + 1), 1, &dim);
	}
	_clip_madd(mp, rp, HASH_args, &var);
	_clip_destroy(mp, &var);

	_clip_var_str(description, strlen(description), &var);
	_clip_madd(mp, rp, HASH_description, &var);
	_clip_destroy(mp, &var);

	_clip_var_num(severity, &var);
	_clip_madd(mp, rp, HASH_severity, &var);
	_clip_destroy(mp, &var);

	_clip_var_num(genCode, &var);
	_clip_madd(mp, rp, HASH_genCode, &var);
	_clip_destroy(mp, &var);

	/* 'osCode' */
	_clip_var_num(osCode, &var);
	_clip_madd(mp, rp, HASH_osCode, &var);
	_clip_destroy(mp, &var);

	/* 'canDefault' */
	_clip_var_log(canDefault, &var);
	_clip_madd(mp, rp, HASH_canDefault, &var);
	_clip_destroy(mp, &var);

	/* 'canRetry' */
	_clip_var_log(canRetry, &var);
	_clip_madd(mp, rp, HASH_canRetry, &var);
	_clip_destroy(mp, &var);

	/* 'canSubstitute' */
	_clip_var_log(canSubstitute, &var);
	_clip_madd(mp, rp, HASH_canSubstitute, &var);
	_clip_destroy(mp, &var);

	/* 'tries' */
	_clip_var_num(tries, &var);
	_clip_madd(mp, rp, HASH_tries, &var);
	_clip_destroy(mp, &var);

	/* 'filename' */
	if (mp->fp)
		s = (char *) mp->fp->filename;
	else
		s = "";
	_clip_var_str(s, strlen(s), &var);
	_clip_madd(mp, rp, HASH_filename, &var);
	_clip_destroy(mp, &var);

	/* 'operation' */
	s = (char *) operation;
	if (!s)
		s = (char *) mp->fp->procname;
	if (!s)
		s = "";
	_clip_var_str(s, strlen(s), &var);
	_clip_madd(mp, rp, HASH_operation, &var);
	_clip_destroy(mp, &var);

	/* 'subSystem' */
	s = (char *) subSystem;
	if (!s)
		s = "";
	_clip_var_str(s, strlen(s), &var);
	_clip_madd(mp, rp, HASH_subSystem, &var);
	_clip_destroy(mp, &var);

	/* 'subCode' */
	_clip_var_num(subCode, &var);
	_clip_madd(mp, rp, HASH_subCode, &var);
	_clip_destroy(mp, &var);

	/* 'syserr' */
	_clip_var_str(mp->syserr, strlen(mp->syserr), &var);
	mp->syserr[0] = 0;
	_clip_madd(mp, rp, HASH_syserr, &var);
	_clip_destroy(mp, &var);

	return rp;
}

CLIP_DLLEXPORT const char *
_clip_errname(int code)
{
	char *msg;

	switch (code)
	{
	default:
		msg = _clip_gettext("unknown error");
		break;
	case EG_ARG:
		msg = _clip_gettext("invalid argument");
		break;
	case EG_BOUND:
		msg = _clip_gettext("bound error");
		break;
	case EG_STROVERFLOW:
		msg = _clip_gettext("string too long");
		break;
	case EG_NUMOVERFLOW:
		msg = _clip_gettext("number too big");
		break;
	case EG_ZERODIV:
		msg = _clip_gettext("divide by zero");
		break;
	case EG_NUMERR:
		msg = _clip_gettext("number error");
		break;
	case EG_SYNTAX:
		msg = _clip_gettext("syntax error");
		break;
	case EG_COMPLEXITY:
		msg = _clip_gettext("syntax too complex");
		break;

	case EG_MEM:
		msg = _clip_gettext("memory error");
		break;
	case EG_NOFUNC:
		msg = _clip_gettext("no function");
		break;
	case EG_NOMETHOD:
		msg = _clip_gettext("no method");
		break;
	case EG_NOVAR:
		msg = _clip_gettext("no variable");
		break;
	case EG_NOALIAS:
		msg = _clip_gettext("no alias");
		break;
	case EG_NOVARMETHOD:
		msg = _clip_gettext("no varmethod");
		break;

	case EG_CREATE:
		msg = _clip_gettext("create error");
		break;
	case EG_OPEN:
		msg = _clip_gettext("open error");
		break;
	case EG_CLOSE:
		msg = _clip_gettext("close error");
		break;
	case EG_READ:
		msg = _clip_gettext("read error");
		break;
	case EG_WRITE:
		msg = _clip_gettext("write error");
		break;
	case EG_PRINT:
		msg = _clip_gettext("print error");
		break;

	case EG_UNSUPPORTED:
		msg = _clip_gettext("unsupported");
		break;
	case EG_LIMIT:
		msg = _clip_gettext("limit exhaust");
		break;
	case EG_CORRUPTION:
		msg = _clip_gettext("corruption detected");
		break;
	case EG_DATATYPE:
		msg = _clip_gettext("wrong datatype");
		break;
	case EG_DATAWIDTH:
		msg = _clip_gettext("wrong datawidth");
		break;
	case EG_NOTABLE:
		msg = _clip_gettext("no table");
		break;
	case EG_NOORDER:
		msg = _clip_gettext("no order");
		break;
	case EG_SHARED:
		msg = _clip_gettext("share violation");
		break;
	case EG_UNLOCKED:
		msg = _clip_gettext("unlocked");
		break;
	case EG_READONLY:
		msg = _clip_gettext("readonly");
		break;
	case EG_APPENDLOCK:
		msg = _clip_gettext("appendlock");
		break;
	case EG_BADALIAS:
		msg = _clip_gettext("bad alias");
		break;
	case EG_LOCK:
		msg = _clip_gettext("locking error");
		break;
	case EG_SIGNAL:
		msg = _clip_gettext("system signal");
		break;
	}

	return msg;
}

CLIP_DLLEXPORT void
_clip_generr(ClipMachine * mp, int code)
{
	if (mp->trapVar)
		return;

	if (code < 0)
		code = -code;

	mp->trapVar = _clip_new_error(mp, _clip_errname(code), 2, code, 0, 0, 0, 0, 0, 0, 0, 0);
}

CLIP_DLLEXPORT int
_clip_trap_err(ClipMachine * mp, int genCode, int canDefault, int canRetry,
		   const char *subSystem, int subCode, const char *operation)
{
	ClipVar *vp;

	vp = _clip_new_error(mp, _clip_errname(genCode), 2, genCode, 0, canDefault,
				 canRetry, 0, 1, subSystem, subCode, operation);

	_clip_trap_var(mp, mp->fp ? mp->fp->filename : "", mp->fp ? mp->fp->line : 0, vp);

	return genCode;
}

CLIP_DLLEXPORT ClipVar *
_clip_mget(ClipMachine * mp, ClipVar * vp, long no)
{
	int ind;

	if (!_clip_mind(mp, vp, no, &ind))
	{
		ClipVar *ep, *ap;

		ap = _clip_vptr(vp);
		ep = &(ap->m.items[ind].v);
		return ep;
	}

	return 0;
}

CLIP_DLLEXPORT int
_clip_mtype(ClipMachine * mp, ClipVar * vp, long no)
{
	int ind;

	if (!_clip_mind(mp, vp, no, &ind))
	{
		ClipVar *ap;

		ap = _clip_vptr(vp);
		return ap->m.items[ind].v.t.type;
	}

	return UNDEF_t;
}

CLIP_DLLEXPORT int
_clip_mgetn(ClipMachine * mp, ClipVar * vp, long no, double *n)
{
	int ind;

	if (!_clip_mind(mp, vp, no, &ind))
	{
		ClipVar *ep, *ap;

		ap = _clip_vptr(vp);

		ep = &(ap->m.items[ind].v);
		*n = _clip_double(ep);
		return 0;
	}
	return -1;
}

CLIP_DLLEXPORT int
_clip_mgetl(ClipMachine * mp, ClipVar * vp, long no, int *n)
{
	int ind;

	if (!_clip_mind(mp, vp, no, &ind))
	{
		ClipVar *ep, *ap;

		ap = _clip_vptr(vp);

		ep = &(ap->m.items[ind].v);
		*n = _clip_log(ep);
		return 0;
	}
	return -1;
}

CLIP_DLLEXPORT int
_clip_mgetc(ClipMachine * mp, ClipVar * vp, long no, char **strp, int *lenp)
{
	int ind;

	if (!_clip_mind(mp, vp, no, &ind))
	{
		ClipVar *ep, *ap;
		int r;

		ap = _clip_vptr(vp);

		ep = &(ap->m.items[ind].v);
		r = _clip_strFromVar(mp, ep, strp, lenp);
		return r;
	}
	return -1;
}

CLIP_DLLEXPORT void
_clip_upstr(char *s, int len)
{
	unsigned char *us = (unsigned char *) s;

	for (; len; us++, len--)
	{
		int c = *us;

		*us = _clip_uptbl[c];
	}
}

CLIP_DLLEXPORT int
_clip_toupper(int c)
{
	return _clip_uptbl[c];
}

CLIP_DLLEXPORT int
_clip_tolower(int c)
{
	return _clip_lowtbl[c];
}

CLIP_DLLEXPORT int
_clip_calc_hash(ClipMachine * mp)
{
	ClipVar *vp = mp->fp->sp - 1, *vvp;
	long hash = -1;

	vvp = _clip_vptr(vp);

	if (vvp->t.type == NUMERIC_t)
	{
		if (vvp->t.memo)
			hash = (long) rational_toDouble(vvp->r.r);
		else
			hash = (long) vvp->n.d;
	}
	else if (vvp->t.type == CHARACTER_t)
		hash = _clip_casehashbytes(0, vvp->s.str.buf, vvp->s.str.len);

	_clip_destroy(mp, vp);
	vp->t.flags = F_NONE;
	vp->t.type = NUMERIC_t;
	vp->t.len = 10;
	vp->t.dec = 0;
	vp->t.memo = 0;
	vp->n.d = hash;

	return 0;
}

CLIP_DLLEXPORT int
_clip_calc_hash2(ClipMachine * mp, int rev)
{
	ClipVar *vp = mp->fp->sp - 1, *vvp;
	long hash = -1, hash2 = -1;

	vvp = _clip_vptr(vp);

	if (vvp->t.type == NUMERIC_t)
	{
		if (vvp->t.memo)
			hash = (long) rational_toDouble(vvp->r.r);
		else
			hash = (long) vvp->n.d;
	}
	else if (vvp->t.type == CHARACTER_t)
	{
		char *s = vvp->s.str.buf;
		int l = vvp->s.str.len;
		char *e;

		e = strstr(s, "->");
		if (e)
		{
			hash = _clip_casehashword(e + 2, strlen(e + 2));
			hash2 = _clip_casehashword(s, e - s);
		}
		else
			hash = _clip_casehashword(s, l);
	}

	_clip_destroy(mp, vp);
	vp->t.flags = F_NONE;
	vp->t.type = NUMERIC_t;
	vp->t.len = 10;
	vp->t.dec = 0;
	vp->t.memo = 0;
	vp->n.d = (rev ? hash2 : hash);

	vp = mp->fp->sp;
	++(mp->fp->sp);
	vp->t.flags = F_NONE;
	vp->t.type = NUMERIC_t;
	vp->t.len = 10;
	vp->t.dec = 0;
	vp->t.memo = 0;
	vp->n.d = (rev ? hash : hash2);

	CLIP_CHECK_STACK;
	return 0;
}

CLIP_DLLEXPORT void
_clip_math_operation(ClipMachine * mp, int op, ClipVar * Lval, ClipVar * Rval)
{
	rational *tmp1 = NULL, *tmp2 = NULL;
	double d1, d2;
	int ldec = Lval->t.dec;
	int rdec = Rval->t.dec;
	int llen = Lval->t.len;
	int rlen = Rval->t.len;

	if (mp->flags & RATIONAL_FLAG)
	{
		if (!Lval->t.memo)
			tmp1 = rational_double_init(Lval->n.d);
		else
			tmp1 = Lval->r.r;
		if (!Rval->t.memo)
			tmp2 = rational_double_init(Rval->n.d);
		else
			tmp2 = Rval->r.r;
		switch (op)
		{
		case '-':
			rational_suba(tmp1, tmp2);
			break;
		case '+':
			rational_adda(tmp1, tmp2);
			break;
		case '/':
			rational_diva(tmp1, tmp2);
			break;
		case '*':
			rational_mula(tmp1, tmp2);
			break;

		}
		if (!Lval->t.memo)
		{
			Lval->t.memo = 1;
			Lval->r.r = tmp1;
		}
		if (!Rval->t.memo)
			rational_destroy(tmp2);
	}
	else
	{
		if (Lval->t.memo)
			d1 = rational_toDouble(Lval->r.r);
		else
			d1 = Lval->n.d;
		if (Rval->t.memo)
			d2 = rational_toDouble(Rval->r.r);
		else
			d2 = Rval->n.d;
		switch (op)
		{
		case '-':
			d1 -= d2;
			break;
		case '+':
			d1 += d2;
			break;
		case '/':
			if (d2 == 0.0)
				d1 = 0.0;
			else
				d1 /= d2;
			break;
		case '*':
			d1 *= d2;
			break;
		}
		if (Lval->t.memo)
			rational_destroy(Lval->r.r);
		Lval->t.memo = 0;
		Lval->n.d = d1;
	}
	switch (op)
	{
	case '-':
		llen = (llen < rlen ? rlen : llen);
		ldec = (ldec < rdec ? rdec : ldec);
		break;
	case '+':
		llen = (llen < rlen ? rlen : llen);
		ldec = (ldec < rdec ? rdec : ldec);
		break;
	case '/':
		if ( ldec == 0 )
		{
			ldec += mp->decimals;
			llen += mp->decimals+1;
		}
		break;
	case '*':
		llen += Rval->t.len;
		ldec += Rval->t.dec;
		break;
	}
	if (ldec > 5)
		ldec = 5;
	if (mp->flags & FIXED_FLAG)
		ldec = mp->decimals;
	if (ldec > 0 && llen <= 10+ldec )
		llen = 11+ldec;
	if (llen > 20)
		llen = 20;
	Lval->t.len = llen;
	Lval->t.dec = ldec;
	return;
}

CLIP_DLLEXPORT int
_clip_forstep(ClipMachine * mp, int *_if)
{
	double d_step, d_to, d_val;
	ClipVar *step = _clip_vptr(mp->fp->sp - 1);
	ClipVar *to = _clip_vptr(mp->fp->sp - 2);
	ClipVar *val = _clip_vptr(mp->fp->sp - 3);

	if (step->t.type != NUMERIC_t
		|| (to->t.type != NUMERIC_t && to->t.type != DATE_t) || (val->t.type != NUMERIC_t && val->t.type != DATE_t))
		return EG_ARG;

	d_step = _clip_double(step);
	d_to = _clip_double(to);
	d_val = _clip_double(val);

	*_if = 1;

	if (d_step > 0)
	{
		if (d_val > d_to)
			*_if = 0;
	}
	else if (d_step < 0)
	{
		if (d_val < d_to)
			*_if = 0;
	}

	_clip_pop(mp);
	_clip_pop(mp);
	_clip_pop(mp);

	return 0;
}

CLIP_DLLEXPORT int
_clip_map_first(ClipMachine * mp, int keys, int *_if)
{
	ClipVar *rp = mp->fp->sp - 1;
	ClipVar *arr = _clip_vptr(rp);
	ClipVar *vp = 0;
	long no = 0;

	*_if = 0;

	if (arr->t.type == MAP_t)
	{
		arr->m.current = 0;
		if (arr->m.count > 0)
		{
			no = arr->m.items[0].no;
			vp = &(arr->m.items[0].v);
			*_if = 1;
		}
	}
	else if (arr->t.type == ARRAY_t)
	{
		arr->a.current = 0;
		if (arr->a.count > 0)
		{
			no = 1;
			vp = arr->a.items;
			*_if = 1;
		}
	}
	else
		return EG_ARG;

	if (*_if)
	{
		_clip_destroy(mp, rp);
		if (keys)
			_clip_var_num(no, rp);
		else
			_clip_clone(mp, rp, vp);
	}
	else
		_clip_pop(mp);

	return 0;
}

CLIP_DLLEXPORT int
_clip_map_next(ClipMachine * mp, int keys, int *_if)
{
	ClipVar *rp = mp->fp->sp - 1;
	ClipVar *arr = _clip_vptr(rp);
	ClipVar *vp = 0;
	long no = 0;

	*_if = 0;

	if (arr->t.type == MAP_t)
	{
		arr->m.current += 1;
		if (arr->m.current < arr->m.count)
		{
			no = arr->m.items[arr->m.current].no;
			vp = &(arr->m.items[arr->m.current].v);
			*_if = 1;
		}
	}
	else if (arr->t.type == ARRAY_t)
	{
		arr->a.current += 1;
		if (arr->a.current < arr->a.count)
		{
			no = arr->a.current + 1;
			vp = arr->a.items + arr->a.current;
			*_if = 1;
		}
	}
	else
		return EG_ARG;

	if (*_if)
	{
		_clip_destroy(mp, rp);
		if (keys)
			_clip_var_num(no, rp);
		else
			_clip_clone(mp, rp, vp);
	}
	else
		_clip_pop(mp);

	return 0;
}

CLIP_DLLEXPORT void
_clip_swap(ClipMachine * mp, int offset)
{
	ClipVar v;

	v = mp->fp->sp[-1];
	memmove(mp->fp->sp - offset, mp->fp->sp - offset - 1, offset * sizeof(ClipVar));
	mp->fp->sp[-offset - 1] = v;
}

CLIP_DLLEXPORT void
_clip_push_locale(ClipMachine * mp)
{
	ClipVar *vp = _clip_vptr(mp->fp->sp - 1);
	char *s = 0;

	if (vp->t.type == CHARACTER_t)
	{
		char *e, *p, *m;
		int i;

		p = vp->s.str.buf;
		for (i = 0, e = p; *e && *e != 1; e++, i++)
			;
		e++;
		m = (char *) malloc(i + 1);
		memcpy(m, p, i);
		m[i] = 0;

		_clip_locale_msg(m, e, &s);
#if 0
		for (e = s; *e; e++)
			*e = _clip_intbl[*(unsigned char *) e];
#endif
		free(m);
	}
	else
		s = strdup("");

	vp = mp->fp->sp - 1;
	_clip_destroy(mp, vp);
	_clip_var_str(s, strlen(s), vp);
	free(s);
}

static ClipVar *
local_ref(ClipMachine * mp, int no)
{
	ClipVar *vp;
	ClipVarFrame *lp = mp->fp->localvars;

	if (lp && no < lp->size)
		vp = lp->vars + no;
	else
	{
		int nlocals = no + 1;
		ClipVarFrame *localvars = (ClipVarFrame *) realloc(lp, sizeof(ClipVarFrame) + nlocals * sizeof(ClipVar));

		localvars->vars = (ClipVar *) (localvars + 1);
		if (lp)
		{
			memset(localvars->vars + no, 0, (nlocals - localvars->size) * sizeof(ClipVar));
		}
		else
		{
			memset(localvars->vars, 0, nlocals * sizeof(ClipVar));
			localvars->refcount = 1;
		}
		localvars->size = nlocals;
		mp->fp->localvars = localvars;

		vp = localvars->vars + no;
	}

	if (vp->t.flags & F_MPTR && vp->p.vp->t.flags & F_MPTR)
	{
#if 1
		if (vp->p.vp->t.flags == F_MPTR &&
			(vp->p.vp->t.type == ARRAY_t || vp->p.vp->t.type == MAP_t) )
		{
		}
		else
#endif
			vp = vp->p.vp;
	}

	return vp;
}

CLIP_DLLEXPORT int
_clip_push_local(ClipMachine * mp, int no)
{
	return _clip_push(mp, local_ref(mp, no));
}

CLIP_DLLEXPORT ClipVar *
_clip_ref_local(ClipMachine * mp, int no)
{
	return local_ref(mp, no);
}

CLIP_DLLEXPORT ClipVar *
_clip_pop_ref(ClipMachine * mp)
{
	return mp->fp->sp->p.vp;
}

CLIP_DLLEXPORT int
_clip_unref(ClipMachine * mp, ClipVar * lval)
{
	_clip_destroy(mp, lval);
	return 0;
}

CLIP_DLLEXPORT int
_clip_refmacro(ClipMachine * mp)
{
	VarEntry *vep;
	long fhash = 0, ahash;
	char *fname = 0, *aname = 0;
	int fl = 0, al = 0, r;
	ClipVar *lval = 0;
	ClipVar *sp = mp->fp->sp - 1;
	ClipVar *vp = _clip_vptr(sp);
	long *dim = 0;
	int ndim = 0;

	if (vp->t.type != CHARACTER_t)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "macro reference with non-character argument (%s)",
				  _clip_typename(vp));
		return 0;
	}

	r = _clip_parse_name(vp->s.str.buf, vp->s.str.len, &aname, &al, &fname, &fl, &dim, &ndim);

	if (aname)
		ahash = _clip_casehashbytes(0, aname, al);
	else
		ahash = -1;

	if (fname)
		fhash = _clip_casehashbytes(0, fname, fl);

	_clip_destroy(mp, sp);
	mp->fp->sp--;

	if (r == 2)		/* field */
	{
		return _clip_field(mp, fhash, ahash);
	}
	else if (r == 1)	/* memvar */
	{
	}
	else
		/* field/memvar */
	{
		if (!_clip_try_field(mp, fhash))
			return 0;
	}

	vep = fetch_var(mp, fhash);

	if (vep)
		lval = &vep->var;

	if (!lval)
	{
		_clip_trap_printf(mp, __file__, __LINE__, "no variable name: '%.*s'", vp->s.str.len, vp->s.str.buf);
		return _clip_call_errblock(mp, 1);
	}
	else if (r == 3)
	{
		lval = _clip_aref(mp, lval, ndim, dim);
		free(dim);
	}

	_clip_ref(mp, lval, 0);

	return 0;
}

static void
dup_ref(ClipVar * dest, ClipVar * src)
{
	if (dest == src || src->p.vp == dest)
		return;
	CLEAR_CLIPVAR(dest);
	dest->t.type = src->t.type;
	dest->t.flags = src->t.flags;
	dest->p.vp = src->p.vp;
	dest->t.field = src->t.field;
	dest->p.fp = src->p.fp;
	++(src->p.vp->t.count);
}

CLIP_DLLEXPORT ClipFieldDef *
_clip_get_fielddef(ClipMachine * mp, long areahash, long namehash)
{
	long hash;
	ClipFieldDef *fp;

	hash = _clip_hashbytes(0, (char *) &areahash, sizeof(areahash));
	hash = _clip_hashbytes(hash, (char *) &namehash, sizeof(namehash));

	fp = (ClipFieldDef *) HashTable_fetch(mp->fields, hash);
	if (!fp)
	{
		fp = (ClipFieldDef *) calloc(1, sizeof(ClipFieldDef));
		fp->areahash = areahash;
		fp->fieldhash = namehash;
		HashTable_insert(mp->fields, fp, hash);
	}

	return fp;
}

static void
choose_quot(char *str, int l, char *lquot, char *rquot)
{
	char *s;
	int ch, n = 0;

	do
	{
		int lq = *lquot;
		int rq = *rquot;

		for (s = str; (ch = *s); ++s)
			if (ch == lq || ch == rq)
				break;
		if (!ch)
			return;
		switch (*lquot)
		{
		case '"':
			*lquot = '\'';
			*rquot = '\'';
			break;
		case '\'':
		case '[':
			*lquot = '"';
			*rquot = '"';
			break;
		}
	}
	while (n++ < 3);
}

CLIP_DLLEXPORT int
_clip_catstr(ClipMachine * mp, int num)
{
	int i;
	char *s = 0, buf[128], *s1;
	int l = 0, l1, len, dec;
	ClipVar *rp;

	for (i = 0; i < num; i++)
	{
		ClipVar *vp = _clip_vptr(mp->fp->sp - num + i);

		switch (vp->t.type)
		{
		default:
			snprintf(buf, sizeof(buf), "NIL");
			s1 = buf;
			l1 = 3;
			break;
		case CHARACTER_t:
			l1 = vp->s.str.len;
			s1 = vp->s.str.buf;
			break;
		case NUMERIC_t:
			len = vp->t.len;
			dec = vp->t.dec;
			if (!len)
			{
				len = 10;
				dec = 2;
			}
			if (!vp->t.memo)
			{
				int c;

				snprintf(buf, sizeof(buf), "%*.*f", len, dec, vp->n.d);
				for (s1 = buf + strlen(buf); s1 > buf; --s1)
					if ((*s1) == ',')
						(*s1) = '.';
				for (s1 = buf; (c = *s1) && c == ' '; s1++)
					;
				l1 = strlen(s1);
			}
			else
			{
				if (len)
					s1 = rational_toString(vp->r.r, 10, dec, 0);
				else
				{
					s1 = rational_toString(vp->r.r, len, dec, 0);
					snprintf(buf, sizeof(buf), "%s", s1);
					free(s1);
				}
				l1 = strlen(buf);
			}
			break;
		}

		{
			s = (char *) realloc(s, l + l1 + 1);
			memcpy(s + l, s1, l1);
			s[l + l1] = 0;
			l += l1;
		}

		_clip_destroy(mp, mp->fp->sp - num + i);
	}

	mp->fp->sp -= num;
	rp = mp->fp->sp;

	rp->s.str.buf = s;
	rp->s.str.len = l;
	rp->t.type = CHARACTER_t;
	rp->t.flags = F_NONE;
	rp->t.memo = 0;

	mp->fp->sp++;
	CLIP_CHECK_STACK;

	return 0;
}

CLIP_DLLEXPORT int
_clip_quot(ClipMachine * mp)
{
	ClipVar *vp = mp->fp->sp - 1;
	ClipVar *rp = _clip_vptr(vp);
	char *s;
	int l;

	if (rp->t.type == CHARACTER_t)
	{
		l = rp->s.str.len;
		s = (char *) calloc(1, l + 3);
		memcpy(s + 1, rp->s.str.buf, l);
		s[0] = '"';
		s[l + 1] = '"';
		choose_quot(s, l + 2, s, s + l + 1);
		s[l + 2] = 0;
		l += 2;
	}
	else if (rp->t.type == DATE_t)
	{
		int dd, mm, yy, ww;

		_clip_cdate(rp->d.julian, &dd, &mm, &yy, &ww);
		s = malloc(17);
		snprintf(s, 17, "STOD(\"%04d%02d%02d\")", yy, mm, dd);
		l = 16;
	}
	else if (rp->t.type == DATETIME_t)
	{
		s = _clip_ttoc(mp, rp->dt.julian, rp->dt.time, &l, mp->date_format, mp->hours, mp->seconds);
	}
	else if (rp->t.type == LOGICAL_t)
	{
		s = malloc(4);
		snprintf(s, 4, "%s", rp->l.val ? ".T." : ".F.");
		l = 3;
	}
	else
		return 0;

	_clip_destroy(mp, vp);

	vp->s.str.buf = s;
	vp->s.str.len = l;
	vp->t.type = CHARACTER_t;
	vp->t.flags = F_NONE;
	vp->t.memo = 0;

	return 0;
}

CLIP_DLLEXPORT int
_clip_strcmp(const char *str1, const char *str2)
{
	int l1 = strlen(str1);
	int l2 = strlen(str2);

	return _clip_strnncmp(str1, str2, l1, l2);
}

CLIP_DLLEXPORT int
_clip_strncmp(const char *str1, const char *str2, int len)
{
	int l1 = strlen(str1);
	int l2 = strlen(str2);

	if (l1 > len)
		l1 = len;
	if (l2 > len)
		l2 = len;
	return _clip_strnncmp(str1, str2, l1, l2);
}

CLIP_DLLEXPORT int
_clip_strnncmp(const char *str1, const char *str2, int len1, int len2)
{
	unsigned char ch1 = 0, ch2 = 0;
	const unsigned char *us1, *us2;

 	for (us1 = (const unsigned char *)str1, us2 = (const unsigned char *)str2; len1 && len2; us1++, us2++, len1--, len2--)
	{
		ch1 = *(unsigned char *)us1;
		ch2 = *(unsigned char *)us2;
		if (ch1 < 32 && ch2 > 31)
			ch1 = 0;

		if (ch1 > 31 && ch2 < 32)
			ch2 = 0;

		ch1 = _clip_cmptbl[ch1];
		ch2 = _clip_cmptbl[ch2];

		if (ch1 < ch2)
			return -(ch2 - ch1);
		else if (ch1 > ch2)
			return ch1 - ch2;
	}

	if (len1)
		return ch1;
	else if (len2)
		return -ch2;
	return 0;
}

CLIP_DLLEXPORT int
_clip_strcasecmp(const char *str1, const char *str2)
{
	int l1 = strlen(str1);
	int l2 = strlen(str2);

	return _clip_strnncasecmp(str1, str2, l1, l2);
}

CLIP_DLLEXPORT int
_clip_strncasecmp(const char *str1, const char *str2, int len)
{
	int l1 = strlen(str1);
	int l2 = strlen(str2);

	if (l1 > len)
		l1 = len;
	if (l2 > len)
		l2 = len;
	return _clip_strnncasecmp(str1, str2, l1, l2);
}

CLIP_DLLEXPORT int
_clip_strnncasecmp(const char *str1, const char *str2, int len1, int len2)
{
	unsigned char ch1 = 0, ch2 = 0;
	const unsigned char *us1, *us2;

	for (us1 = (const unsigned char *)str1, us2 = (const unsigned char *)str2; len1 && len2; us1++, us2++, len1--, len2--)
	{
		ch1 = _clip_uptbl[*us1];
		ch2 = _clip_uptbl[*us2];
		if (ch1 < 32 && ch2 > 31)
			ch1 = 0;

		if (ch1 > 31 && ch2 < 32)
			ch2 = 0;

		ch1 = _clip_cmptbl[ch1];
		ch2 = _clip_cmptbl[ch2];

		if (ch1 < ch2)
			return -(ch2 - ch1);
		else if (ch1 > ch2)
			return ch1 - ch2;
	}

	if (len1)
		return ch1;
	else if (len2)
		return -ch2;
	return 0;
}

void
_clip_unix_path(char *p, int doslike)
{
#if 1
	int i,j,len=strlen(p);
	char * buf = p;
	for (i=0,j=0; i<len; i++)
	{
		if (doslike && buf[i] == ' ')
			continue;
		if (buf[i] == '\\')
			buf[j] = '/';
		if (doslike)
			buf[j] = tolower((unsigned char) (buf[i]));
		j ++;
	}
	buf[j] = 0;
#else
	while (*p)
	{
		if (*p == '\\')
			*p = '/';
		else if (tolow)
			*p = tolower(*p);
		p++;
	}
#endif
}

int
_clip_absolute_path(ClipMachine * cm, const char *path, char *p, int len)
{
	char op[PATH_MAX];
	char *e = p;

#ifndef _WIN32
	const char *s = path;

	p[0] = 0;
	if (path[1] == ':')
	{
		char dn[3];
		char *root;

		dn[0] = toupper(*s);
		dn[1] = ':';
		dn[2] = 0;
		root = _clip_fetch_item(cm, _clip_hashstr(dn));
		if (!root)
			return 0;
		strncpy(p, root, len - 1);
		e = p + strlen(p);
		if (*(e - 1) != '/')
		{
			*e = '/';
			e++;
			*e = 0;
		}
		s += 2;
		if (path[2] == '\\' || path[2] == '/')
			s++;
	}
	strncpy(e, s, p + len - e - 2);
#else
	if ((memcmp(path, "\\\\", 2) == 0) || (memcmp(path, "//", 2) == 0))
	{
		/* network resource */
		strncpy(p, path, len);
	}
	else
	{
		if (path != NULL && (*path == '/' || *path == '\\') && memcmp(path, "/cygdrive/", 10))
		{

			/* add default drive */
			char *s = _clip_fetch_item(cm, CLIP_CUR_DRIVE);

			snprintf(p, len - 1, "%s%s", s, path);
		}
		else
			strncpy(p, path, len);
	}
#endif
	_clip_unix_path(p, cm->flags & TRANSLATE_FLAG);

	errno = 0;
	getcwd(op, sizeof(op));
	if (errno)
		return 1;
	chdir(p);
/*	if (errno)
		return 1;*/
	errno = 0;
	getcwd(p, len);
	if (errno)
		return 1;
	chdir(op);
	if (errno)
		return 1;

	e = p + strlen(p) - 1;
	if (*e != '/' && e - p < len - 2)
	{
		*(e + 1) = '/';
		*(e + 2) = 0;
	}

	return 0;
}

CLIP_DLLEXPORT int
_clip_path(ClipMachine * cm, const char *fn, char *p, int len, int create)
{
	char path[PATH_MAX];
	const char *s, *s1 = NULL, *s2 = NULL;

	if (strchr(fn, '|'))
	{
		strncpy(p, fn, len);
		p[len - 1] = 0;
		return 0;
	}

	if ((memcmp(fn, "\\\\", 2) == 0) || (memcmp(fn, "//", 2) == 0))
	{
		strncpy(p, fn, len);
	}
	else if ((s = strrchr(fn, '/')) || (s1 = strrchr(fn, '\\')) || (s2 = strrchr(fn, ':')))
	{
		char path[PATH_MAX];
		int f = 0;

		if (!s1)
			s1 = strrchr(fn, '\\');
		if (!s2)
			s2 = strrchr(fn, ':');
		s = (s > s1) ? s : s1;
		if (s2 > s)
			f = 1;
		s = (s > s2) ? s : s2;
		memcpy(path, fn, s - fn + f);
		path[s - fn + f] = 0;
		if (_clip_absolute_path(cm, path, p, len))
			return 1;
		strncat(p, s + 1, len - strlen(p) - 1);
		_clip_unix_path(p, cm->flags & TRANSLATE_FLAG);
	}
	else
	{
		if (_clip_absolute_path(cm, cm->defaul, p, len))
			return 1;
		strncat(p, fn, len - strlen(p) - 1);
		_clip_unix_path(p, cm->flags & TRANSLATE_FLAG);
		if (!create && access(p, F_OK))
		{
			char *c, *c1 = path;

			strncpy(path, cm->path, sizeof(path) - 1);
			while (c1 != (char *) 1 && access(p, F_OK))
			{
				c = strchr(c1, ';');
				if (c)
				{
					*c = 0;
				}
				else
				{
					c = strchr(c1, ',');
					if (c)
						*c = 0;
				}
				if (_clip_absolute_path(cm, c1, p, len))
					return 1;
				strncat(p, fn, len - strlen(p) - 1);
				_clip_unix_path(p, cm->flags & TRANSLATE_FLAG);
				c1 = c + 1;
			}
		}
	}
	return 0;
}

typedef struct
{
	char *src;
	char *dst;
	unsigned char tbl[256];
	unsigned char *pg;	/*[128] */
}
TranslateTable;

static int
cmp_TranslateTable(void *p1, void *p2)
{
	TranslateTable *tp1 = (TranslateTable *) p1;
	TranslateTable *tp2 = (TranslateTable *) p2;
	int r;

	r = strcasecmp(tp1->src, tp2->src);
	if (r)
		return r;

	return strcasecmp(tp1->dst, tp2->dst);
}

static void
delete_TranslateTable(void *p)
{
	TranslateTable *tp = (TranslateTable *) p;

	if (!tp)
		return;

	free(tp->src);
	free(tp->dst);
	if (tp->pg)
		free(tp->pg);

	free(tp);
}

static Coll *tr_charsets = 0;

static unsigned char
pg2pgch(unsigned char ch)
{
	switch (ch)
	{
	case PG_HLINE:
		return PGCH_HLINE;
	case PG_LLCORNER:
		return PGCH_LLCORNER;
	case PG_LRCORNER:
		return PGCH_LRCORNER;
	case PG_TTEE:
		return PGCH_TTEE;
	case PG_RTEE:
		return PGCH_RTEE;
	case PG_LTEE:
		return PGCH_LTEE;
	case PG_BTEE:
		return PGCH_BTEE;
	case PG_ULCORNER:
		return PGCH_ULCORNER;
	case PG_URCORNER:
		return PGCH_URCORNER;
	case PG_VLINE:
		return PGCH_VLINE;

	case PG_HLINE2:
		return PGCH_HLINE2;
	case PG_LLCORNER2:
		return PGCH_LLCORNER2;
	case PG_LRCORNER2:
		return PGCH_LRCORNER2;
	case PG_TTEE2:
		return PGCH_TTEE2;
	case PG_RTEE2:
		return PGCH_RTEE2;
	case PG_LTEE2:
		return PGCH_LTEE2;
	case PG_BTEE2:
		return PGCH_BTEE2;
	case PG_ULCORNER2:
		return PGCH_ULCORNER2;
	case PG_URCORNER2:
		return PGCH_URCORNER2;
	case PG_VLINE2:
		return PGCH_VLINE2;

	case PG_PLUS:
		return PGCH_PLUS;
	case PG_PLUS2:
		return PGCH_PLUS2;
	case PG_BLOCK:
		return PGCH_BLOCK;

	case PG_LARROW:
		return PGCH_LARROW;
	case PG_RARROW:
		return PGCH_RARROW;

	}
	return 0;
}

CLIP_DLLEXPORT int
_clip_translate_charset(char *p1, char *p2, unsigned char *str, unsigned char *ostr, int len)
{
	cons_CharsetEntry *cs1 = 0, *cs2 = 0;
	int len1 = 0, len2 = 0;
	int ind;
	TranslateTable stbl, *tp = 0;

	if (!p1 || !p2 || !str || !ostr)
		return EG_ARG;

	if (!strcasecmp(p1, p2))
	{
		memcpy(ostr, str, len);
		return 0;
	}

	stbl.src = p1;
	stbl.dst = p2;

	if (tr_charsets && search_Coll(tr_charsets, &stbl, &ind))
	{
		tp = (TranslateTable *) tr_charsets->items[ind];
		goto translate;
	}

	if (load_charset_name(p1, &cs1, &len1))
	{
		_clip_logg(2, "translate_charset: cannot load charset file '%s': %s", p1, strerror(errno));
	}

	if (load_charset_name(p2, &cs2, &len2))
	{
		_clip_logg(2, "translate_charset: cannot load charset file '%s': %s", p2, strerror(errno));
	}

	if (cs1 && cs2)
	{
		int src_pg, dst_pg;

		tp = (TranslateTable *) calloc(1, sizeof(TranslateTable));
		tp->src = strdup(p1);
		tp->dst = strdup(p2);
		make_translation(cs1, len1, cs2, len2, tp->tbl);

		src_pg = !charset_have_pg(cs1, len1);
		dst_pg = !charset_have_pg(cs2, len2);
		if (src_pg && !dst_pg)
		{
			unsigned char *pg;

			pg = (unsigned char *) malloc(256);
			load_charset_tables(p1, 0, 0, 0, 0, pg);

			memmove(pg, pg + 128, 128);
			tp->pg = (unsigned char *) realloc(pg, 128);
		}

		if (!tr_charsets)
			tr_charsets = new_Coll(delete_TranslateTable, cmp_TranslateTable);
		insert_Coll(tr_charsets, tp);
	}

	free(cs1);
	free(cs2);

	  translate:
	if (tp)
	{
		int i;
		int s, s1;

		for (i = 0; i < len; i++)
		{
			s = str[i];
			if ((s & 0x80) && tp->pg && (s1 = tp->pg[s & 0x7f]))
				ostr[i] = pg2pgch(s1);
			else
				ostr[i] = tp->tbl[s];
		}
	}
	else
	{
		memcpy(ostr, str, len);
	}

	return 0;
}

/*
*	ALTD(0) - disable debugging
*	ALTD(1) - enable debugging
*	ALTD(2) - enable debugging and wait connection
*/

int
clip_ALTD(ClipMachine * mp)
{
	if (!_clip_debuglevel)
	{
		_clip_debuglevel = 1;
#ifndef OS_MINGW
		signal(SIGUSR1, _clip_sigdebug);
#endif
	}

	_clip_in_breakpoint();
	return 0;
}

void
_clip_check_stack(ClipMachine * mp)
{
	ClipFrame *fp = mp->fp;

	if (fp && fp->sp > (fp->stack + fp->stklen))
	{
		_clip_call_errblock(mp, EG_MEM);
		_clip_logg(0, "stack check failed at line %d file %d", fp->line, fp->filename ? fp->filename : "unknown");
		exit(1);
	}
}

CLIP_DLLEXPORT char *
_clip_host_charset()
{
	return _clip_hostcs;
}

int
clip_ERRORLEVEL(ClipMachine * mp)
{
	int level = errorlevel;

	if (mp->argc > 0)
		errorlevel = _clip_parni(mp, 1);

	_clip_retni(mp, level);
	return 0;
}


int
clip___QUIT(ClipMachine * mp)
{
#ifdef USE_TASKS
/*	Task_killAll();*/
#endif
	exit(errorlevel);
}

