/*
   Copyright (C) 2001  ITK
   Author   : Paul Lasarev <paul@itk.ru>
   License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
   $Log$
   Revision 1.5  2008/01/29 14:26:20  itk
   uri: wboard() fixed

   Revision 1.4  2007/03/09 14:42:12  itk
   uri: many fix for AMD64

   Revision 1.3  2007/01/29 12:58:59  itk
   uri: some fix for rational numbers.

   Revision 1.2  2006/07/17 08:12:17  itk
   uri: small fix about pcol() and qout()

   Revision 1.283  2006/07/11 08:36:28  clip
   uri: devout()+qout()+pcol() some bug fixed

   Revision 1.282  2005/08/08 09:00:30  clip
   alena: fix for gcc 4

   Revision 1.281  2005/03/24 08:18:51  clip
   uri: some fix for val("+40")

   Revision 1.280  2005/02/21 10:56:56  clip
   uri: small fix in *token()

   Revision 1.279  2005/02/09 09:10:08  clip
   uri: small fix

   Revision 1.278  2005/02/03 17:21:28  clip
   uri: kbdstat(), bit #18, for En/Ru detection. Only for scan mode keyboard.

   Revision 1.277  2005/01/05 11:22:01  clip
   uri: small fix

   Revision 1.276  2004/12/16 13:42:21  clip
   uri: small fix

   Revision 1.275  2004/12/16 12:42:20  clip
   uri: small fix for lastkey() with inkey() without timeout

   Revision 1.274  2004/12/15 08:08:24  clip
   uri: small fix

   Revision 1.273  2004/12/15 07:05:36  clip
   uri: add KSET*()

   Revision 1.272  2004/12/14 13:34:35  clip
   uri: small fix for inkey()+lastkey() with empty keyboard buffer.

   Revision 1.271  2004/12/10 10:43:28  clip
   uri: fixed memory leak in _clip_ret*() with twice call.

   Revision 1.270  2004/12/07 09:14:03  clip
   uri: added invertAttr()

   Revision 1.269  2004/11/17 08:57:21  clip
   uri: small about str()

   Revision 1.268  2004/11/16 09:19:29  clip
   uri: small fix in str() for len==-1 and in get object for numeric data and picture "X"

   Revision 1.267  2004/10/28 11:47:32  clip
   uri: fix formatiing in STR(), pad*() for numeric data and constants.

   Revision 1.266  2004/10/27 09:08:50  clip
   uri: small fix for setPxlat()

   Revision 1.265  2004/10/20 17:22:16  clip
   uri: add set(_SET_UTF8TERM) for terminal with UTF-8

   Revision 1.264  2004/10/13 15:03:25  clip
   uri: small fix for PG under cygwin in WBOX()

   Revision 1.263  2004/10/07 07:52:25  clip
   uri: some fixes and few short func names

   Revision 1.262  2004/09/30 12:07:04  clip
   uri: small fix for str(-1234567890,10)

   Revision 1.261  2004/09/03 07:04:00  clip
   uri: small fixes from John Smyth <js@w-e.ru>

   Revision 1.260  2004/08/27 11:34:26  clip
   rust: minor fixes

   Revision 1.259  2004/06/15 13:56:44  clip
   rust: screenchar(),screenattr(),screenstr() (with attrs),screenstring() (w/o attrs)

   Revision 1.258  2004/06/11 12:34:25  clip
   uri: add screenChar(), and some fix in savescreen()

   Revision 1.257  2004/06/11 10:15:14  clip
   rust: SET PRINTER TO MEMBUF

   Revision 1.256  2004/06/01 09:53:02  clip
   uri: small fix

   Revision 1.255  2004/03/30 11:39:54  clip
   rust: fix in FLOATVAL() to understand both '.' and ',' as decimal separators

   Revision 1.254  2004/03/19 14:12:15  clip
   rust: FLOATVAL("9E09") -> Numeric

   Revision 1.253  2004/03/17 08:47:25  clip
   uri: bug in colowin() fixed. Reported by Stas

   Revision 1.252  2004/03/01 11:27:12  clip
   uri: add CLIP_DOS_SCRBUF for save/rest screen

   Revision 1.251  2004/02/06 12:06:57  clip
   alena: add check to "," into clip_strtod

   Revision 1.250  2004/01/28 13:49:00  clip
   rust: common ClipMachine->kbdbuf

   Revision 1.249  2004/01/23 12:55:56  clip
   uri: some fix in STR(10.2,5) from Marco

   Revision 1.248  2004/01/09 14:42:31  clip
   uri: small fix about BINDIR

   Revision 1.247  2003/12/11 16:19:08  clip
   uri: small fix in scroll

   Revision 1.246  2003/11/21 05:26:18  clip
   uri: reguest -> request

   Revision 1.245  2003/11/19 11:48:25  clip
   add FLUSHOUT_FLAG, _SET_FLUSHOUT to set
   paul

   Revision 1.244  2003/11/04 11:18:33  clip
   post signal handler
   paul

   Revision 1.243  2003/10/14 06:10:22  clip
   uri: fix bug in "set alternate to; devout()" from Marco

   Revision 1.242  2003/09/08 12:06:09  clip
   uri: small fix in savescreen()

   Revision 1.241  2003/09/01 14:36:57  clip
   uri: savescreen(,,,,lMainScreen) added

   Revision 1.240  2003/08/22 08:36:59  clip
   uri: add winbuf_out_trans() from Mauricio Abre.

   Revision 1.239  2003/07/16 11:41:22  clip
   uri: str("abc") fixed, call error.

   Revision 1.238  2003/06/04 06:55:44  clip
   uri: timevalid() added

   Revision 1.237  2003/05/14 12:25:30  clip
   uri: small fix in wselect(),wclose()

   Revision 1.236  2003/05/14 09:02:07  clip
   uri: small fix in wselect().

   Revision 1.234  2003/04/09 09:23:10  clip
   rust: small fix in VAL()

   Revision 1.233  2003/04/02 10:53:19  clip
   rust: _clip_close() added

   Revision 1.232  2003/03/28 08:11:38  clip
   uri: small fix for ALT_keys

   Revision 1.231  2003/03/24 12:35:16  clip
   *** empty log message ***

   Revision 1.230  2003/02/07 11:45:48  clip
   mstate fix

   Revision 1.229  2003/02/07 11:43:23  clip
   mstate fix

   Revision 1.228  2003/02/03 08:59:09  clip
   uri: ISKBDEMPTY() added

   Revision 1.227  2003/02/02 12:30:15  clip
   uri: FT_SETATTR() added

   Revision 1.226  2003/02/02 12:19:21  clip
   uri: FT_SHADOW() added

   Revision 1.225  2003/01/24 08:53:20  clip
   uri: beep() -> __beep()

   Revision 1.224  2003/01/15 06:44:52  clip
   uri: small fix in draw_shadow()

   Revision 1.223  2003/01/13 14:49:23  clip
   uri: small fix in wopen() && window_shadow()

   Revision 1.222  2003/01/13 10:40:23  clip
   uri: small fix

   Revision 1.221  2003/01/09 11:41:27  clip
   uri: small fix for c5.3 compatibility

   Revision 1.220  2002/12/20 11:21:46  clip
   fix for ^2, ^6, Ctrl+numpads in scan mode
   closes #88
   paul

   Revision 1.219  2002/12/17 12:08:46  clip
   fix scancodes for keypad '/' '*' '-' '+' + alt/ctrl
   paul

   Revision 1.218  2002/12/16 14:10:47  clip
   uri: waitperiod() remaked.

   Revision 1.217  2002/11/27 12:22:45  clip
   alexey: outlog() - removed printing extra comma at end of line.

   Revision 1.216  2002/11/20 10:22:51  clip
   include beep patch from Przemyslaw Czerpak <druzus@acn.waw.pl>
   paul

   Revision 1.215  2002/11/18 09:26:58  clip
   pgch fix
   paul

   Revision 1.214  2002/11/18 08:52:30  clip
   charset fixes
   asdf

   Revision 1.213  2002/11/14 11:25:03  clip
   uri: fixes for achoice()

   Revision 1.212  2002/10/30 15:42:38  clip
   uri: small fix

   Revision 1.211  2002/10/30 14:58:44  clip
   uri: small tab formatting.

   Revision 1.210  2002/10/30 08:51:03  clip
   rust: _clip_dtostr() again

   Revision 1.209  2002/10/29 14:58:45  clip
   rust: poor poor _clip_dtostr() :)

   Revision 1.208  2002/10/18 08:16:47  clip
   uri: small fix in wselect()

   Revision 1.207  2002/10/08 11:33:08  clip
   uri: maxrow(.t.) small bug fixed.

   Revision 1.206  2002/09/11 12:28:59  clip
   build fixes
   paul

   Revision 1.205  2002/09/09 08:45:42  clip
   uri: small fix in "set extrafile"

   Revision 1.204  2002/08/30 08:34:51  clip
   fix winbuf_attr_at
   paul

   Revision 1.203  2002/08/30 07:25:05  clip
   enable negative points in winbuf_copy
   paul

   Revision 1.202  2002/08/30 06:56:04  clip
   add winbuf_attr_at func
   paul

   Revision 1.201  2002/08/19 05:25:32  clip
   alexey: clip_WINBUF_DESTROY: small bug fixed

   Revision 1.200  2002/08/18 10:02:29  clip
   alexey: clip_WINBUF_COPY - SIGSEGV fixed

   Revision 1.199  2002/07/31 11:28:16  clip
   winbuf fix
   paul

   Revision 1.198  2002/07/31 10:49:53  clip
   initial winbuf
   paul

   Revision 1.197  2002/07/31 09:46:51  clip
   fix for '&' enum marker
   paul

   Revision 1.196  2002/07/30 12:01:30  clip
   preproc: multiword enum match
   paul

   Revision 1.195  2002/07/30 11:05:14  clip
   scancodes
   paul

   Revision 1.194  2002/07/30 10:44:10  clip
   preproc: fix for delim
   paul

   Revision 1.193  2002/07/30 08:06:15  clip
   Alt0-9 in scanmode
   paul

   Revision 1.192  2002/07/16 07:43:47  clip
   uri: set("PRINTER_EOL",chr(13)+chr(10)) added

   Revision 1.191  2002/07/16 07:17:11  clip
   uri: bug in VAL() fixed

   Revision 1.190  2002/07/05 06:22:31  clip
   uri: small fix in _clip_dtostr() :):):)

   Revision 1.189  2002/07/04 10:04:07  clip
   uri: fix in __keyboard(): clear buffer in terminal input

   Revision 1.188  2002/07/01 11:46:42  clip
   uri: fix in str(val,len,NIL)

   Revision 1.187  2002/06/30 08:37:32  clip
   uri: fix in str() & strzero()

   Revision 1.186  2002/06/17 09:47:18  clip
   rust: output numerics in browse()

   Revision 1.185  2002/06/16 15:02:16  clip
   rust: STR() fixed

   Revision 1.184  2002/06/14 11:17:06  clip
   rust: small correction in STR()

   Revision 1.183  2002/06/13 08:28:32  clip
   rust: small fix in STR()

   Revision 1.182  2002/05/28 10:54:58  clip
   uri: trapshift(),trapanykey(),keysend() added

   Revision 1.181  2002/05/27 11:17:58  clip
   scankey() fix
   paul

   Revision 1.180  2002/05/27 10:39:03  clip
   uri: fix in _clip_dtostr() // druzus bug :)

   Revision 1.179  2002/05/26 09:07:45  clip
   uri: small fix

   Revision 1.178  2002/05/25 11:48:45  clip
   rust: avoiding warning

   Revision 1.177  2002/05/24 11:01:28  clip
   rust: _clip_dtostr() - implementation from P.Czerpak <druzus@polbox.com>

   Revision 1.176  2002/05/23 12:18:01  clip
   rust: bug in _clip_dtostr()

   Revision 1.175  2002/05/20 12:01:48  clip
   make _clip_fullsceen  global
   paul

   Revision 1.174  2002/05/18 11:59:06  clip
   fix for f13-f20 func keys, as shift-F
   paul

   Revision 1.173  2002/05/14 08:12:25  clip
   rust: few new parameters to _clip_ttoc are added

   Revision 1.172  2002/04/30 07:49:24  clip
   uri: nextkey([eventMask])

   Revision 1.171  2002/04/30 07:37:54  clip
   uri: fix inkey(NIL,mask)

   Revision 1.170  2002/04/24 13:14:42  clip
   initial
   paul

   Revision 1.169  2002/04/23 14:29:43  clip
   uri: small fix in keyboard()

   Revision 1.168  2002/04/22 15:29:55  clip
   rust: initial support of DATETIME type

   Revision 1.167  2002/04/21 10:54:16  clip
   uri: fixes for new dbstruct() and patch from druzus.

   Revision 1.166  2002/04/15 14:12:52  clip
   \n \r fix in FULLSCREEN mode
   paul

   Revision 1.165  2002/04/11 15:42:22  clip
   uri: set(_SET_DISPBOX) - dispbox over dispout()

   Revision 1.164  2002/04/09 12:14:04  clip
   screen patches by Przemyslaw Czerpak
   paul

   Revision 1.163  2002/04/03 05:46:17  clip
   uri: _clip_strtod(), variant from druzus

   Revision 1.162  2002/03/27 14:32:09  clip
   unnesessary sync_Screen in RESTSCREEN
   paul

   Revision 1.161  2002/03/18 08:46:26  clip
   rust: VAL() with dec==0

   Revision 1.160  2002/03/14 13:55:28  clip
   rust: bug in _clip_dtostr()

   Revision 1.159  2002/02/20 15:57:23  clip
   fucked strtod locale dependence...
   paul

   Revision 1.158  2002/02/19 07:55:36  clip
   timeout bug in inkey
   paul

   Revision 1.157  2002/02/11 08:32:12  clip
   uri: center() && wopen()

   Revision 1.156  2002/02/03 10:32:35  clip
   uri: iscolor() & fullscreen()

   Revision 1.155  2002/01/29 08:30:36  clip
   rust: CLIP_DLLEXPORT _clip_strtod()

   Revision 1.154  2002/01/16 15:29:07  clip
   chinese patch
   preproc bugs
   some pseudographic chars < 32
   paul

   Revision 1.153  2001/12/21 13:21:59  clip
   failed requiest to fullscreen mode now print call trace
   paul

   Revision 1.152  2001/12/16 13:07:34  clip
   uri: small fixes

   Revision 1.151  2001/12/13 12:51:42  clip
   another bug in _clip_strtod() :-)
   rust

   Revision 1.150  2001/12/11 10:45:32  clip
   uri: small fix in wbox()

   Revision 1.149  2001/12/11 07:48:25  clip
   middle mouse button
   paul

   Revision 1.148  2001/12/11 07:35:58  clip
   uri: fix for color

   Revision 1.147  2001/12/10 14:19:12  clip
   uri: fix in VAL()

   Revision 1.146  2001/12/09 14:00:55  clip
   uri: small fix for colorToN()

   Revision 1.145  2001/12/09 13:42:00  clip
   uri: small fix.

   Revision 1.144  2001/12/09 10:29:16  clip
   uri: disbox() && (top==bottom) || (left==right) coordinates

   Revision 1.143  2001/12/08 13:16:39  clip
   _clip_strtod() bug
   rust

   Revision 1.142  2001/11/29 11:25:29  clip
   uri: small fix in shadow for wbox(), paul - remove my test

   Revision 1.141  2001/11/27 11:44:46  clip
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

   Revision 1.140  2001/11/26 12:59:30  clip
   uri: small bugs

   Revision 1.139  2001/11/23 10:53:15  clip
   uri: small fix in VAL(), sqlselect()

   Revision 1.138  2001/11/20 14:10:32  clip
   uri: small fix for output cymbols <32 under cygwin

   Revision 1.137  2001/11/20 13:19:53  clip
   uri: setTxlat(), setPxlat() added

   Revision 1.136  2001/11/15 15:12:09  clip
   uri: small fix in VAL()

   Revision 1.135  2001/11/13 13:20:33  clip
   uri: added ct function showtime(), pronar function setclock()

   Revision 1.134  2001/11/13 11:22:11  clip
   TASKSTOP() stop task switching
   TASKSTART() start task switching
   TASKSTOP()/TASKSTART() pairs may be nested
   paul

   Revision 1.133  2001/11/13 09:39:49  clip
   _clip_str2attr, _clip_attr2str fix for '+' and '*'
   paul

   Revision 1.132  2001/11/13 09:31:36  clip
   START('funcname'[, arg1 ... argN])
   can now put arg1-argN to call of funcname
   paul

   Revision 1.131  2001/11/12 14:13:46  clip
   START(cFuncname) now work :)
   paul

   Revision 1.130  2001/11/08 11:13:25  clip
   SCREENMIX()
   paul

   Revision 1.129  2001/11/08 10:35:59  clip
   another bug in _clip_strtod()
   rust

   Revision 1.128  2001/11/08 10:26:09  clip
   wclose restore screen bug
   paul

   Revision 1.127  2001/11/08 10:14:59  clip
   bug in _clip_strtod()
   rust

   Revision 1.126  2001/11/08 09:30:39  clip
   high-color background fix
   paul

   Revision 1.125  2001/11/08 08:26:56  clip
   pseudographics & colors redraw fix
   paul

   Revision 1.124  2001/11/02 06:44:47  clip
   maxcol(), maxrow(), col(), row(), devpos()
   now can have additional logical parameter lScr, if true, all functions
   work in full screen area, not window.
   paul

   Revision 1.123  2001/10/29 11:56:34  clip
   fix for BLINK(intensitive background)
   paul

   Revision 1.122  2001/10/28 15:06:20  clip
   uri: UNDEF_t parameters in savescreen()

   Revision 1.121  2001/10/28 13:13:50  clip
   WBOX cleanup

   Revision 1.120  2001/10/23 11:19:59  clip
   bug in clip_STR()
   rust

   Revision 1.119  2001/10/17 11:04:00  clip
   bug in clip_STR()
   rust

   Revision 1.118  2001/10/16 12:05:15  clip
   bug in _clip_dtostr()
   rust

   Revision 1.117  2001/10/16 11:13:30  clip
   _clip_dtostr()
   rust

   Revision 1.116  2001/09/26 11:40:02  clip
   uri: setcancel() bug fixed

   Revision 1.115  2001/09/21 09:53:24  clip
   charsets handling
   paul

   Revision 1.114  2001/09/12 10:50:42  clip
   stream output recoding
   paul

   Revision 1.113  2001/08/23 13:52:05  clip
   merge with NEWLOCALS
   paul

   Revision 1.112.2.1  2001/08/21 08:29:54  clip
   reference assign (like b:=@a[1])
   paul

   Revision 1.112  2001/07/26 11:48:37  clip
   after
   set ('PRINTER_CHARSET', 'cp866')
   and
   set printer to asdf
   all output to printer will be recoded from CLIP_HOSTCS to PRINTER_CHARSET
   if PRINTER_CHARSET is not setted, recode from CLIP_HOSTCS to CLIP_CLIENTCS
   paul

   Revision 1.111  2001/07/25 12:01:16  clip
   SETPOS
   paul

   Revision 1.110  2001/07/25 10:32:26  clip
   dispoutat(nRow,nCol,var[,cColor])
   paul

   Revision 1.109  2001/07/25 10:02:08  clip
   SETPOS & SET DEVICE TO PRINTER
   paul

   Revision 1.108  2001/06/13 11:27:38  clip
   BEEP()
   stack deep bug in array init {,,,}
   paul

   Revision 1.107  2001/06/08 13:23:45  clip
   ��� ������� ���clip_region �_SETPOS
   alena:

   Revision 1.106  2001/06/07 13:44:42  clip
   uri: bugs in VAL()

   Revision 1.105  2001/06/07 09:52:26  clip
   uri:bugs

   Revision 1.104  2001/06/06 13:15:26  clip
   wbox
   paul

   Revision 1.103  2001/05/24 10:47:24  clip
   printer
   paul

   Revision 1.102  2001/05/13 12:19:24  clip
   bug in _clip_strtod

   Revision 1.101  2001/05/13 11:54:50  clip
   uri: _clip_strtod() over strtod()

   Revision 1.100  2001/05/12 11:10:58  clip
   uri: mp->lastkey update only with key pressed !

   Revision 1.99  2001/05/11 09:51:23  clip
   SETKEY & pcode
   paul

   Revision 1.98  2001/05/07 13:41:23  clip
   rui: add #include "time.h"

   Revision 1.97  2001/05/07 12:05:06  clip
   uri: str() & val() with '.' over ','

   Revision 1.96  2001/05/07 10:38:39  clip
   uri:val() add params len and dec

   Revision 1.95  2001/05/03 10:38:01  clip
   *** empty log message ***

   Revision 1.94  2001/04/23 13:53:53  clip
   set console off, alltrim() & nonstring params

   Revision 1.93  2001/04/20 12:24:59  clip
   write transform() & devoutpict() as prg-module, delete from c-module

   Revision 1.92  2001/04/19 10:08:05  clip
   alt_g ->290 over 209

   Revision 1.91  2001/04/19 09:56:38  clip
   altQ -> 272 over 271
   uri:

   Revision 1.90  2001/04/16 09:42:12  clip
   print_var delimiter now is ';' instead ':'
   paul

   Revision 1.89  2001/04/16 07:40:14  clip
   print_deep
   paul

   Revision 1.88  2001/04/16 07:29:39  clip
   -> ( expr_list )
   paul

   Revision 1.87  2001/04/12 12:06:20  clip
   set printer
   paul

   Revision 1.86  2001/04/11 08:56:15  clip
   WBOX cleanup
   paul

   Revision 1.85  2001/04/11 07:17:03  clip
   SETPRC function
   paul

   Revision 1.84  2001/04/11 06:57:48  clip
   print-max-deep
   paul

   Revision 1.83  2001/04/10 12:45:43  clip
   print deep limit
   paul

   Revision 1.82  2001/04/10 10:53:19  clip
   scroll
   paul

   Revision 1.81  2001/04/09 11:43:56  clip
   save/restore screen initialization
   paul

   Revision 1.80  2001/04/03 09:17:00  clip
   license errors
   paul

   Revision 1.79  2001/03/30 11:51:02  clip
   add copyright

   Revision 1.78  2001/03/29 06:22:34  clip
   bug in replicate with len <=0

   Revision 1.77  2001/03/28 14:37:01  clip
   bug in transform()

   Revision 1.76  2001/03/28 14:20:52  clip
   restScreen() with none parameters, file() with NIL parameter

   Revision 1.75  2001/03/20 12:42:22  clip
   dispbegin/dispend disable if debugging
   paul

   Revision 1.74  2001/03/12 13:47:18  clip
   VAR2STR, STR2VAR funcs
   paul

   Revision 1.73  2001/02/25 13:10:32  clip
   dispbox

   Revision 1.72  2001/02/25 12:56:00  clip
   bug in dispbox with box_string as ""

   Revision 1.71  2001/02/22 09:53:35  clip
   dbg: expr command
   paul

   Revision 1.70  2001/02/06 13:07:24  clip
   hash in .po, dbg
   paul

   Revision 1.69  2001/02/01 13:05:05  clip
   debug links
   paul

   Revision 1.68  2001/01/18 11:57:40  clip
   CLIPROOT now more correctly used by compiler
   CONSOLE_FLAG now work
   paul

   Revision 1.67  2001/01/17 09:17:58  clip
   small bug in VAL for len and dec

   Revision 1.66  2000/12/05 07:22:06  clip
   alt=
   paul

   Revision 1.65  2000/12/04 11:09:59  clip
   del scancode
   paul

   Revision 1.64  2000/12/04 10:49:23  clip
   keymaps
   paul

   Revision 1.63  2000/12/04 10:09:49  clip
   keymaps
   paul

   Revision 1.62  2000/12/03 12:42:34  clip
   scancodes
   paul

   Revision 1.61  2000/12/03 10:52:56  clip
   scancodes
   paul

   Revision 1.60  2000/12/02 12:46:56  clip
   scancodes
   paul

   Revision 1.59  2000/11/23 12:56:18  clip
   keys, ADEL
   paul

   Revision 1.58  2000/11/21 11:31:12  clip
   io
   paul

   Revision 1.57  2000/11/21 10:01:48  clip
   accept/inkey
   paul

   Revision 1.56  2000/11/04 11:08:29  clip
   bug in set(_SET_CANCEL), ����� � ����
   from uri:

   Revision 1.55  2000/11/04 11:00:11  clip
   sync_mp
   paul

   Revision 1.54  2000/10/30 12:08:42  clip
   savescreen() one parameters its bug
   from uri:

   Revision 1.53  2000/10/30 11:54:42  clip
   restscreen do not inkey()
   from uri:

   Revision 1.52  2000/10/20 11:45:49  clip
   round() and round in str() small bugs
   from uri:

   Revision 1.51  2000/10/20 08:03:23  clip
   Added rational wherever mentioned NUMERIC_t
   maybe in some places this omitted
   (in places where don't use NUMERIC_t)!!!
   from uri:

   Revision 1.50  2000/10/11 11:31:53  clip
   bug in wselect()
   from uri:

   Revision 1.49  2000/10/09 12:31:42  clip
   bug in clip_region
   from uri:

   Revision 1.48  2000/07/07 20:42:19  clip
   \t in fullscreen
   Paul Lasarev <paul@itk.ru>

   Revision 1.47  2000/07/07 19:35:25  clip
   wclose
   Paul Lasarev <paul@itk.ru>

   Revision 1.46  2000/07/05 21:04:02  clip
   wclose
   Paul Lasarev <paul@itk.ru>

   Revision 1.45  2000/07/05 16:40:57  clip
   wclose
   Paul Lasarev <paul@itk.ru>

   Revision 1.44  2000/07/05 16:19:21  clip
   wclose
   Paul Lasarev <paul@itk.ru>

   Revision 1.43  2000/07/05 16:03:46  clip
   wselect
   Paul Lasarev <paul@itk.ru>

   Revision 1.42  2000/07/04 19:27:38  clip
   append parameter to WCLOSE - number of window
   Paul Lasarev <paul@itk.ru>

   Revision 1.41  2000/05/30 19:10:13  clip
   uri: make function setclearb()

   Revision 1.40  2000/05/30 15:22:47  clip
   uri: function colorselect and io color

   Revision 1.39  2000/05/29 16:00:13  clip
   pg gluk

   Revision 1.38  2000/05/26 19:43:17  clip
   uri: small bug in tabexpand

   Revision 1.37  2000/05/25 19:29:36  clip
   restscreen in window
   Paul Lasarev <paul@itk.ru>

   Revision 1.36  2000/05/24 18:33:55  clip
   _clip_push_area
   indents all
   Paul Lasarev <paul@itk.ru>

   Revision 1.35  2000/05/24 17:51:08  clip
   -1.. say in windows
   Paul Lasarev <paul@itk.ru>

   Revision 1.34  2000/05/24 16:56:29  clip
   bugs
   Paul Lasarev <paul@itk.ru>

   Revision 1.33  2000/05/23 23:57:10  clip

   Paul Lasarev <paul@itk.ru>

   Revision 1.32  2000/05/23 23:07:29  clip
   scroll
   Paul Lasarev <paul@itk.ru>

   Revision 1.31  2000/05/23 22:13:49  clip
   wbox
   Paul Lasarev <paul@itk.ru>

   Revision 1.30  2000/05/23 20:37:55  clip
   wbox
   Paul Lasarev <paul@itk.ru>

   Revision 1.29  2000/05/23 18:59:52  clip
   append window functions
   Paul Lasarev <paul@itk.ru>

   Revision 1.28  2000/05/22 14:55:56  clip
   transform with dates
   val with negative strings
   Paul Lasarev <paul@itk.ru>

   Revision 1.27  2000/05/20 19:56:04  clip
   __keyboard can now recieve numeric
   Paul Lasarev <paul@itk.ru>

   Revision 1.26  2000/05/19 19:35:53  clip
   add colors 5/10
   SETCOLOR(,.t.) produce color string in NUM/NUM format
   Paul Lasarev <paul@itk.ru>

   Revision 1.25  2000/05/19 17:49:57  clip
   dispattr
   Paul Lasarev <paul@itk.ru>

   Revision 1.24  2000/05/19 17:14:27  clip
   dispbox
   Paul Lasarev <paul@itk.ru>

   Revision 1.23  2000/05/12 17:08:17  clip
   add error:syserr member
   Paul Lasarev <paul@itk.ru>

   Revision 1.22  2000/05/12 01:22:22  clip
   uri: qqout - first space place

   Revision 1.21  2000/05/10 19:28:04  clip
   scroll (clear)
   Paul Lasarev <paul@itk.ru>

   Revision 1.20  2000/05/10 18:33:44  clip
   AADD now clone arrays
   terminal initialization fail only in fullscreen mode
   Paul Lasarev <paul@itk.ru>

   Revision 1.19  2000/05/03 21:39:15  clip
   add set cursor shape

   Revision 1.18  2000/05/03 19:32:24  clip
   add prefix 'clip_' to all clip functions

   Revision 1.17  2000/05/01 19:40:48  clip
   SunOS port

   Revision 1.16  2000/04/13 17:38:40  paul
   f10-f12 keys

   Revision 1.15  2000/03/25 18:02:21  uri
   outlog - first parameter - as level

   Revision 1.14  2000/03/24 19:49:56  uri
   set(_SET_LOGFILE)

   Revision 1.13  2000/03/24 19:14:12  uri
   ����OUTLOG

   Revision 1.12  2000/03/24 19:02:52  paul
   logg

   Revision 1.11  2000/03/24 18:47:54  uri
   OUTLOG

   Revision 1.10  2000/03/09 21:50:24  paul
   warnigns

   Revision 1.9  1999/12/28 20:34:14  uri
   *** empty log message ***

   Revision 1.8  1999/12/10 21:16:37  uri
   �typename ����MEMO_t

   Revision 1.7  1999/12/10 21:14:01  paul
   gluk in _clip_date_to_str()

   Revision 1.6  1999/12/09 21:19:22  uri
   ���warnings ����misc functions of tools

   Revision 1.5  1999/10/29 20:31:44  uri
   fill in dispbox

   Revision 1.4  1999/10/26 19:11:10  paul
   start cvs logging

 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>
#include <time.h>
#include <sys/time.h>
#include <math.h>
#include <locale.h>
#include <signal.h>

#include "clip.h"
#include "screen/screen.h"
#include "hashcode.h"
#include "error.ch"
#include "ctwin.ch"
#include "config.ch"
#include "rational.h"
#include "coll.h"

#ifdef USE_TASKS
#include "task/task.h"
#endif

ClipModule IO_module = {
	"_io",
	0,
	0,
	0,
	0,
	0,
	0,
	0
};

#define DEV_SCR 0
#define DEV_DEV 1
#define DEV_STD 2
#define DEV_ERR 3
#define DEV_DEVS 4
#define DEV_LOG 5
#define DEV_DBG 6
/*
   write function TRANSFORM as clipper+prg module
 */
/*
   #define CLIP_TRANSFORM_C
 */

static void out_any(ClipMachine * mp, char *buf, int n, int attr, int dev);
static void out_scr(ClipMachine * mp, char *buf, int n, int attr, int wrap);
static void out_dev(ClipMachine * mp, char *buf, int n, int attr, int wrap);
static void out_std(ClipMachine * mp, char *buf, int n, int attr);
static void out_err(ClipMachine * mp, char *buf, int n, int attr);
static void out_dbg(ClipMachine * mp, char *buf, int n);

static void print_var(ClipMachine * mp, ClipVar * vp, int attr, int dev, int level);

#ifdef CLIP_TRANSFORM_C
static void transform(ClipMachine * mp, ClipVar * vp, char *pict);

#endif
static void sync_mp(ClipMachine * mp);
static void clip_region(ClipMachine * mp, int *top, int *left, int *bottom, int *right, int full, int wnum);
static void wind_region(ClipMachine * mp, int *ptop, int *pleft, int *pbottom, int *pright, int full);

extern FILE *logg;
extern int log_level;

static void dialog_init(ClipMachine * mp);

static const int _clip_deck[] = { 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000 };
static const double _clip_deck1[] = { 0.5f, 0.05f, 0.005f, 0.0005f, 0.00005f, 0.000005f, 0.0000005f, 0.00000005f, 0.000000005f };

void
_clip_dtos(double d, char *buf, int buflen, int *dp)
{
	int dl;
	char *s;

	snprintf(buf, buflen, "%.0f", d);
	dl = strlen(buf);
	if (dp)
		*dp = dl;
	snprintf(buf, buflen, "%.*f", buflen - dl - 1, d);

	for (s = buf + strlen(buf); s > buf; --s)
		if ((*s) == ',')
			(*s) = '.';
	for (s = buf + strlen(buf); s > buf; --s)
		if (s[-1] != '0')
			break;
	if (s > buf && s[-1] == '.')
		--s;
	*s = 0;
}

int
_clip_colorSelect(ClipMachine * mp)
{
	int ret;

	switch (mp->colorSelect)
	{
	case 0:
		ret = mp->attr.standard;
		break;
	case 1:
		ret = mp->attr.enhanced;
		break;
	case 2:
		ret = mp->attr.border;
		break;
	case 3:
		ret = mp->attr.background;
		break;
	case 4:
		ret = mp->attr.unselected;
		break;
	case 5:
		ret = mp->attr.u1;
		break;
	case 6:
		ret = mp->attr.u2;
		break;
	case 7:
		ret = mp->attr.u3;
		break;
	case 8:
		ret = mp->attr.u4;
		break;
	case 9:
		ret = mp->attr.u5;
		break;
	default:
		ret = mp->attr.standard;
		break;
	}
	return ret;
}

int
_clip_sprintf(ClipMachine * mp, const char *fmt, ...)
{
	va_list ap;
	int ret;

	va_start(ap, fmt);
	ret = _clip_vsprintf(mp, fmt, ap);

	va_end(ap);

	return ret;
}

int
_clip_vsprintf(ClipMachine * mp, const char *fmt, void *ap)
{
	for (;;)
	{
		int n = vsnprintf(mp->buf, mp->buflen, fmt, ap);

		if (n < mp->buflen)
			return n;
		mp->buflen = mp->buflen * 2;
		mp->buf = (char *) realloc(mp->buf, mp->buflen);
	}
}

static void
out_dev(ClipMachine * mp, char *buf, int n, int attr, int wrap)
{
	if (mp->flags & DEVICE_FLAG)
		goto prn;

	if (mp->fullscreen)
	{
		if (wrap == 0 || (mp->flags & CONSOLE_FLAG))
			out_scr(mp, buf, n, attr, wrap);
	}
	else if ((mp->flags & CONSOLE_FLAG) || mp->out != stdout)
	{
		int i;

		if (mp->obuf)
		{
			int i;

			for (i = 0; i < n; i++)
				putByte_Buf(mp->obuf, _clip_outtbl[(unsigned char) buf[i]]);
			return;
		}

		for (i = 0; i < n; i++)
			fputc(_clip_outtbl[(unsigned char) buf[i]], (FILE *) mp->out);
	}

	if (wrap == 1 && (mp->flags & ALTERNATE_FLAG) )
	{
		FILE *alt = (FILE *) mp->alt;

		if (alt)
		{
			int i;

			for (i = 0; i < n; i++)
				fputc(_clip_outtbl[(unsigned char) buf[i]], alt);
		}
	}

	if (wrap == 1 && (mp->flags & EXTRA_FLAG) )
	{
		FILE *extra = (FILE *) mp->extra;

		if (extra)
		{
			int i;

			for (i = 0; i < n; i++)
				fputc(_clip_outtbl[(unsigned char) buf[i]], extra);
		}
	}

	if ((mp->flags & PRINTER_FLAG) && wrap)
	{
		FILE *printer;
		int i;
		char *s;

		  prn:
		if(mp->pbuf)
		{
			putBuf_Buf(mp->pbuf, buf, n);
		} else {
			printer = (FILE *) mp->printer;
			if (printer)
			{
				for (i = 0, s = buf; i < n; ++i, ++s)
				{
					if (*s == '\n')
					{
						mp->pcol = 0;
						mp->prow++;
					}
					else
					{
						if (*s != '\r')
							++ mp->pcol;
					}
				}
				for (i = 0; i < mp->margin; ++i)
					fputc(' ', printer);
				for (i = 0; i < n; i++)
					fputc(mp->prntbl[( mp->prn_xlat[(unsigned char)(buf[i])])], printer);
			}
		}
	}
}

static void
out_std(ClipMachine * mp, char *buf, int n, int attr)
{
	int i;

	if (mp->obuf)
	{
		int i;

		for (i = 0; i < n; i++)
			putByte_Buf(mp->obuf, _clip_outtbl[(unsigned char) buf[i]]);
		return;
	}

	for (i = 0; i < n; i++)
		fputc(_clip_outtbl[(unsigned char) buf[i]], stdout);
}

static void
out_err(ClipMachine * mp, char *buf, int n, int attr)
{
	int i;


	if (mp->ebuf)
	{
		int i;

		for (i = 0; i < n; i++)
			putByte_Buf(mp->ebuf, _clip_outtbl[(unsigned char) buf[i]]);
		return;
	}


	for (i = 0; i < n; i++)
		fputc(_clip_outtbl[(unsigned char) buf[i]], stderr);
}

static void
out_dbg(ClipMachine * mp, char *buf, int n)
{
	if (_clip_dbg_out)
	{
		int i;

		for (i = 0; i < n; i++)
			fputc(_clip_outtbl[(unsigned char) buf[i]], _clip_dbg_out);
	}
}

static void
out_log(ClipMachine * mp, char *buf, int n, int attr)
{
	_clip_out_log(buf, n);
}

static void
out_any(ClipMachine * mp, char *buf, int n, int attr, int dev)
{

	switch (dev)
	{
	case DEV_DEV:
		out_dev(mp, buf, n, attr, 0);
		break;
	case DEV_DEVS:
		out_dev(mp, buf, n, attr, 1);
		break;
	case DEV_SCR:
		out_scr(mp, buf, n, attr, 0);
		break;
	case DEV_STD:
		out_std(mp, buf, n, attr);
		break;
	case DEV_ERR:
		out_err(mp, buf, n, attr);
		break;
	case DEV_LOG:
		out_log(mp, buf, n, attr);
		break;
	case DEV_DBG:
		out_dbg(mp, buf, n);
		break;
	}
}

int
_clip_printf(ClipMachine * mp, const char *fmt, ...)
{
	int n;
	va_list ap;

	va_start(ap, fmt);
	n = _clip_vsprintf(mp, fmt, ap);
	out_dev(mp, mp->buf, n, _clip_colorSelect(mp), 1);
	va_end(ap);

	return n;
}

void
_clip_print_dbg(ClipMachine * mp, ClipVar * vp)
{
	const char *nm = _clip_type_name(vp);

	if (_clip_dbg_out)
		fprintf(_clip_dbg_out, "%s; ", nm);
	print_var(mp, vp, 0, DEV_DBG, 0);
}

static void
print_var(ClipMachine * mp, ClipVar * vp, int attr, int dev, int level)
{
	if (level >= mp->print_max_deep)
	{
		char b[64];
		int l;

		sprintf(b, "Max print level reached: %d ", level);
		l = strlen(b);
		if (dev != DEV_LOG)
			out_dev(mp, b, l, attr, dev);
		_clip_out_log(b, l);
		return;
	}

	vp = _clip_vptr(vp);

	switch (vp->t.type)
	{
	case UNDEF_t:
		out_any(mp, "NIL", 3, attr, dev);
		break;
	case NUMERIC_t:
		{
			if (vp->t.memo)
			{
				char *buf;

				if (vp->t.dec)
					buf = rational_toString(vp->r.r, 10, vp->t.dec, 0);
				else
					buf = rational_toString(vp->r.r, 10, mp->decimals, 0);
				out_any(mp, buf, strlen(buf), attr, dev);
				free(buf);
			}
			else
			{
				char buf[48];
				char *s;

				if (vp->t.len < sizeof(buf))
					snprintf(buf, sizeof(buf), "%*.*f", vp->t.len, vp->t.dec, vp->n.d);
				else
					_clip_dtos(vp->n.d, buf, sizeof(buf), 0);
				for (s = buf + strlen(buf); s > buf; --s)
					if ((*s) == ',')
						(*s) = '.';
				out_any(mp, buf, strlen(buf), attr, dev);
			}
		}
		break;
	case CHARACTER_t:
		out_any(mp, vp->s.str.buf, vp->s.str.len, attr, dev);
		break;
	case LOGICAL_t:
		if (vp->l.val)
			out_any(mp, ".T.", 3, attr, dev);
		else
			out_any(mp, ".F.", 3, attr, dev);
		break;
	case DATE_t:
		{
			char *s = _clip_date_to_str(vp->d.julian, mp->date_format);

			out_any(mp, s, strlen(s), attr, dev);
			free(s);
		}
		break;
	case DATETIME_t:
		{
			int len;
			char *s = _clip_ttoc(mp, vp->dt.julian, vp->dt.time, &len, mp->date_format, mp->hours, mp->seconds);

			out_any(mp, s, len, attr, dev);
			free(s);
		}
		break;
	case OBJECT_t:
		vp->o.rtti->print(mp, vp->o.obj, vp->o.rtti, &mp->buf, &mp->buflen);
		out_any(mp, mp->buf, mp->buflen, attr, dev);
		break;
	case PCODE_t:
	case CCODE_t:
		out_any(mp, "CODE", 4, attr, dev);
		break;
	case ARRAY_t:
		{
			unsigned i;

			out_any(mp, "{", 1, attr, dev);
			for (i = 0; i < vp->a.count; ++i)
			{
				if (i)
					out_any(mp, ", ", 2, attr, dev);
				print_var(mp, vp->a.items + i, attr, dev, level + 1);
			}
			out_any(mp, "}", 1, attr, dev);
		}
		break;
	case MAP_t:
		{
			unsigned i;

			out_any(mp, "{", 1, attr, dev);
			for (i = 0; i < vp->m.count; ++i)
			{
				char buf[64];
				int l;

				if (i)
					out_any(mp, ", ", 2, attr, dev);
				_clip_hash_name(mp, vp->m.items[i].no, buf, sizeof(buf));
				l = strlen(buf);
				snprintf(buf + l, sizeof(buf) - l, ":");
				l += 1;
				out_any(mp, buf, l, attr, dev);
				print_var(mp, &vp->m.items[i].v, attr, dev, level + 1);
			}
			out_any(mp, "}", 1, attr, dev);
		}
		break;
	default:
		break;
	}
}

int
clip_QQOUT(ClipMachine * mp)
{
	int i;

	for (i = 1; i <= mp->argc; ++i)
	{
		ClipVar *vp = _clip_par(mp, i);

		if (i > 1)
			out_any(mp, " ", 1, _clip_colorSelect(mp), DEV_DEVS);
		if (!vp)
			continue;
		print_var(mp, vp, _clip_colorSelect(mp), DEV_DEVS, 0);
	}
	sync_mp(mp);

	return 0;
}

int
clip_QOUT(ClipMachine * mp)
{
	char *pEol = (char *) _clip_fetch_item(mp, _clip_hashstr("PRINTER_EOL"));

	if (pEol == NULL || *pEol == 0)
		out_any(mp, "\n", 1, _clip_colorSelect(mp), DEV_DEVS);
	else
		out_any(mp, pEol, strlen(pEol), _clip_colorSelect(mp), DEV_DEVS);
	clip_QQOUT(mp);
	sync_mp(mp);
	return 0;
}

int
clip_OUTSTD(ClipMachine * mp)
{
	int i;

	for (i = 1; i <= mp->argc; ++i)
	{
		ClipVar *vp = _clip_par(mp, i);

		if (i > 1)
			out_any(mp, " ", 1, _clip_colorSelect(mp), DEV_STD);
		print_var(mp, vp, _clip_colorSelect(mp), DEV_STD, 0);
	}
	return 0;
}

int
clip_OUTERR(ClipMachine * mp)
{
	int i;

	for (i = 1; i <= mp->argc; ++i)
	{
		ClipVar *vp = _clip_par(mp, i);

		if (i > 1)
			out_any(mp, " ", 1, _clip_colorSelect(mp), DEV_ERR);
		print_var(mp, vp, _clip_colorSelect(mp), DEV_ERR, 0);
	}
	return 0;
}

int
clip_OUTLOG(ClipMachine * mp)
{
	char buf[11];
	int i;
	time_t tt;
	struct tm *tp;
	int level = _clip_parni(mp, 1);

	if (level > log_level)
		return 0;

	tt = time(0);
	tp = localtime(&tt);
	snprintf(buf, 11, "%02d:%02d:%02d: ", tp->tm_hour, tp->tm_min, tp->tm_sec);
	_clip_out_log(buf, 10);
	buf[0] = ',';
	buf[1] = 0;
	for (i = 1; i <= mp->argc; ++i)
	{
		ClipVar *vp = _clip_par(mp, i);

		if (i > 1)
			out_any(mp, " ", 1, _clip_colorSelect(mp), DEV_LOG);
		print_var(mp, vp, _clip_colorSelect(mp), DEV_LOG, 0);
		if (i < mp->argc)
			_clip_out_log(buf, 1);
	}
	buf[0] = '\n';

	_clip_out_log(buf, 1);
	_clip_flush_log();
	return 0;
}

int
clip_SLEEP(ClipMachine * mp)
{
	double d = 60000;
	long ld;

#ifndef USE_TASKS
	struct timeval tv;
#endif

	if (mp->argc > 0)
		d = _clip_parnd(mp, 1);

	ld = d;

#ifdef USE_TASKS
	Task_sleep(d * 1000);
#else

	tv.tv_sec = ld;
	tv.tv_usec = (d - (double) ld) * 1000000.0;

	select(0, 0, 0, 0, &tv);
#endif
	return 0;
}

/*
int
clip_WAITPERIOD(ClipMachine * mp)
{
	int per = _clip_parni(mp, 1);
	struct timeval tv;

	tv.tv_sec = per / 100;
	tv.tv_usec = (per % 100) * 10000;
	select(0, 0, 0, 0, &tv);
	_clip_retl(mp, 1);
	return 0;
}
*/

int
clip_MILLISEC(ClipMachine * mp)
{
	int per = _clip_parni(mp, 1);
	struct timeval tv;

	tv.tv_sec = per / 1000;
	tv.tv_usec = (per % 1000) * 1000;
	select(0, 0, 0, 0, &tv);
	return 0;
}

int
clip_NDATE(ClipMachine * mp)
{
	int dd = _clip_parni(mp, 1);
	int mm = _clip_parni(mp, 2);
	int yy = _clip_parni(mp, 3);

	ClipVar *rp = RETPTR(mp);

	rp->t.type = DATE_t;
	rp->t.flags = F_NONE;
	rp->d.julian = _clip_jdate(dd, mm, yy);

	return 0;
}

char *
_clip_strFunc(ClipMachine * mp,ClipVar *v,int len, int dec, int pad)
{
	char *buf = NULL;
	int lend = 10, decd;
	char *a, *b;

	lend = v->t.len;
	decd = v->t.dec;
	if (lend <= 0)
		lend = 10;
	if ( len != -999 )
	{
		if(len)
			lend = len;
		if ( dec >= 0 )
			decd = dec;
		else
			decd = 0;
	}
	else
	{
		if ( mp->flags & FIXED_FLAG)
		{
			if ( decd == 0 )
				lend += mp->decimals+1;
			else
				lend += (mp->decimals-decd);
			decd = mp->decimals;
		}
	}
	if ( v->t.memo)
	{
		int _lend;
		char * _buf;
		_buf = rational_toString(v->r.r, 10, decd, 0);
		_lend = strlen(_buf);
		if (_lend < lend)
		{
			buf = malloc(lend+1);
			memset(buf,' ',lend);
			memcpy(buf+(lend-_lend),_buf,_lend);
			free(_buf);
		}
		else
		{
			buf = _buf;
			lend = _lend;
		}
	}
	else
	{
		buf = malloc(lend+1);
		_clip_dtostr(buf, lend, decd, v->n.d, 0);
	}
	buf[lend] = 0;
	/* padr() ==2 & padc() ==3 need left orientation */
	/* padl() ==1 & str() == 0 need right orientation*/
	if ( pad < 2 )
		return buf;
	/* formatiing to left */
	for(a=buf,b=buf; *b; b++)
	{
		if ( *b !=' ')
		{
			*a = *b;
			a++;
		}
	}
	*a =0;
	return buf;
}

int
clip_STR(ClipMachine * mp)
{
	ClipVar *v = _clip_par(mp, 1);
	int len = _clip_parni(mp, 2);
	int dec = _clip_parni(mp, 3);
	char *buf;

	_clip_retc(mp, "");
	if ( _clip_parinfo(mp,1) != NUMERIC_t )
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "STR");

	if ( len < 0)
		return 0;

	if ( _clip_parinfo(mp,2) != NUMERIC_t )
		len = -999;
	if ( _clip_parinfo(mp,3) != NUMERIC_t )
		dec = -999;


	buf = _clip_strFunc(mp,v,len,dec,0);
	_clip_retcn_m(mp, buf, strlen(buf) );
	return 0;
}

int
clip_RSTR(ClipMachine * mp)
{
	int lend = 10, decd = 2;
	char buf[32], *s;
	ClipVar *v = _clip_par(mp, 1);
	int len = _clip_parni(mp, 2);
	int dec = _clip_parni(mp, 3);

	_clip_parp(mp, 1, &lend, &decd);

	if (v->t.type == NUMERIC_t && !v->t.memo)
	{
		if (len)
			snprintf(buf, sizeof(buf), "%*.*f", len, dec, v->n.d);
		else
			snprintf(buf, sizeof(buf), "%*.*f", lend, decd, v->n.d);
		_clip_retc(mp, buf);
	}
	if (v->t.type == NUMERIC_t && v->t.memo)
	{
		s = rational_toString2(v->r.r);
		_clip_retcn_m(mp, s, strlen(s));
	}
	return 0;
}

int
clip_STRZERO(ClipMachine * mp)
{
	int lend = 10, decd = 2;
	char *s;
	ClipVar *v = _clip_par(mp, 1);
	int len = _clip_parni(mp, 2);
	int dec = _clip_parni(mp, 3);
	char *buf;

	_clip_parp(mp, 1, &lend, &decd);

	if (v->t.type == NUMERIC_t && !v->t.memo)
	{
		if (!len && !lend)
		{
			char b[32];

			snprintf(b, sizeof(b), "%d", (int) v->n.d);
			_clip_retc(mp, b);
			return 0;
		}
		buf = malloc((len ? len : lend) + 1);

#if 1
		/* uri added */
		_clip_dtostr(buf, len ? len : lend, _clip_parinfo(mp, 3) != UNDEF_t ? dec : decd, v->n.d, 1);
#else
		_clip_dtostr(buf, len ? len : lend, len ? dec : decd, v->n.d, 1);
#endif
		_clip_retcn_m(mp, buf, len ? len : lend);
	}
	if (v->t.type == NUMERIC_t && v->t.memo)
	{
		if (len)
			s = rational_toString(v->r.r, 10, dec, 0);
		else
		{
			if (lend)
				s = rational_toString(v->r.r, 10, decd, 0);
			else
				s = rational_toString(v->r.r, 10, mp->decimals, 0);
		}
		_clip_retcn_m(mp, s, strlen(s));
	}
	return 0;
}

#ifdef CLIP_TRANSFORM_C
static int
is_num(int c)
{
	switch (c)
	{
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':
	case '+':
	case '-':
		return 1;
	default:
		return 0;
	}
}

static int
do_templ(char *str, char *templ, char *buf, int buflen, int ins, int left, int no_zero)
{
	char *t, *te, *s, *se, *d, *e, *p;
	int dot = 0;

	if (!templ)
	{
		int ret, l = strlen(str);

		if (l >= buflen)
			ret = 0;
		else
			ret = 1;

		strncpy(buf, str, buflen);
		return ret;
	}

	for (t = templ, s = str, d = buf, e = buf + buflen - 1; *t && d < e;)
	{
		int f_type, t_len, s_len, i, lead;

		/* find template and source field */
		lead = 0;
		  next:
		switch (*t)
		{
		case 0:
			break;
		case '$':
		case '*':
			lead = *t;
			++t;
			goto next;
		case '9':
		case '#':
		case 'N':
			for (t_len = 1, f_type = *t, te = t + t_len; *te == f_type; ++te, ++t_len)
				;
			while (*s && !is_num(*s))
				++s;
			for (s_len = 0, se = s; is_num(*se); ++se, ++s_len)
				;
			if (s_len <= t_len)
			{
				if (!dot && !left)
					for (i = t_len - s_len; i && d < e; --i, ++d)
						*d = ' ';
				if (lead)
					*d++ = lead;
				if (no_zero && s_len == 1 && *s == '0')
					*d++ = ' ';
				else
					for (i = 0; i < s_len && d < e; ++d, ++s, ++i)
						*d = *s;
				if (dot && !no_zero)
					for (i = t_len - s_len; i && d < e; --i, ++d)
						*d = '0';
				else if (left)
					for (i = t_len - s_len; i && d < e; --i, ++d)
						*d = ' ';
				t = te;
				s = se;
				*d = 0;
				dot = 0;
				continue;
			}
			else
				/* overflow */
			{
				for (i = 0; i < t_len && d < e; ++i, ++d, ++s)
					*d = *s;
				*d = 0;
				s = se;
				t = te;
				continue;
			}
			break;
		case 'A':
			*d = *s;
			break;
		case '.':
			p = strchr(s, '.');
			if (p)
			{
				s = p;
				*d = *s;
			}
			else
			{
				*d = '.';
				if (*s)
					--s;
			}
			dot++;
			break;
		case ',':
			p = strchr(s, ',');
			if (p)
			{
				s = p;
				*d = *s;
			}
			else
			{
				*d = ',';
				if (*s)
					--s;
			}
			break;
		case '!':
			*d = toupper(*s);
			break;
		case 'Y':
			switch (toupper(*s))
			{
			case 'T':
			case 'Y':
				*d = 'Y';
				break;
			case 'F':
			case 'N':
				*d = 'N';
				break;
			default:
				*d = *s;
				break;
			}
			break;
		case 'L':
			switch (toupper(*s))
			{
			case 'T':
			case 'Y':
				*d = 'T';
				break;
			case 'F':
			case 'N':
				*d = 'F';
				break;
			default:
				*d = *s;
				break;
			}
			break;
		default:
			*d = *t;
			if (ins && *s)
				--s;
			break;
		}
		if (*s)
			++s;
		++d;
		++t;
	}

	/* just copy rest */
	for (; *s && d < e; ++s, ++d)
		*d = *s;

	*d = 0;
	if (d == e)
		return 0;
	else
		return 1;
}

static void
transform(ClipMachine * mp, ClipVar * vp, char *pict)
{
	char dbuf[32];
	char *templ = 0;
	int funclen = 0;
	int R_func = 0;
	int B_func = 0;
	int C_func = 0;
	int D_func = 0;
	int E_func = 0;
	int X_func = 0;
	int Z_func = 0;
	int BR_func = 0;
	int VO_func = 0;
	int n = 0;

	if (!vp)
	{
		_clip_printf(mp, "");
		return;
	}
	vp = _clip_unptr(vp);

	if (pict)
	{
		if (pict[0] == '@')
		{
			for (templ = pict + 1; *templ; ++templ, ++funclen)
				if (*templ == ' ')
				{
					++templ;
					break;
				}
			if (!*templ)
				templ = 0;
		}
		else
			templ = pict;
	}

	if (funclen)
	{
		char *s, *e;

		for (s = pict + 1, e = s + funclen; *s && s < e; ++s)
			switch (toupper(*s))
			{
			case 'R':
				R_func = 1;
				break;
			case 'B':
				B_func = 1;
				break;
			case 'C':
				C_func = 1;
				break;
			case 'D':
				D_func = 1;
				break;
			case 'E':
				E_func = 1;
				break;
			case 'X':
				X_func = 1;
				break;
			case 'Z':
				Z_func = 1;
				break;
			case '(':
			case ')':
				BR_func = 1;
				break;
			case '!':
				VO_func = 1;
				break;
			}

	}

	for (;;)
	{
		switch (vp->t.type)
		{
		case CHARACTER_t:
			n = do_templ(vp->s.str.buf, templ, mp->buf, mp->buflen, R_func, B_func, Z_func);
			break;
		case NUMERIC_t:
			{
				double d;

				if (vp->t.memo)
					d = rational_toDouble(vp->r.r);
				else
					d = vp->n.d;

				_clip_dtos(d, dbuf, sizeof(dbuf), 0);
				if (BR_func && d < 0)
				{
					d = -d;
					_clip_dtos(d, dbuf, sizeof(dbuf), 0);
					_clip_printf(mp, "(%s)", dbuf);
					strncpy(dbuf, mp->buf, sizeof(dbuf));
				}
				else if (C_func && d > 0)
				{
					_clip_printf(mp, "%s CR", dbuf);
					strncpy(dbuf, mp->buf, sizeof(dbuf));
				}
				else if (X_func && d < 0)
				{
					d = -d;
					_clip_dtos(d, dbuf, sizeof(dbuf), 0);
					_clip_printf(mp, "%s DB", dbuf);
					strncpy(dbuf, mp->buf, sizeof(dbuf));
				}

				n = do_templ(dbuf, templ, mp->buf, mp->buflen, R_func, B_func, Z_func);
			}
			break;
		case LOGICAL_t:
			if (vp->l.val)
				strcpy(dbuf, "T");
			else
				strcpy(dbuf, "F");
			n = do_templ(dbuf, templ, mp->buf, mp->buflen, R_func, B_func, Z_func);
			break;
		case DATE_t:
			{
				long julian = vp->d.julian;
				char *s;
				int l;

				if (D_func)
					templ = mp->date_format;
				else if (E_func)
					templ = "dd/mm/yy";
				s = _clip_date_to_str(julian, templ);
				l = strlen(s);
				if (l >= mp->buflen)
					n = 0;
				else
				{
					n = 1;
					strncpy(mp->buf, s, mp->buflen);
				}
				free(s);
			}
			break;
		case OBJECT_t:
			_clip_printf(mp, "OBJECT");
			return;
		case ARRAY_t:
			_clip_printf(mp, "ARRAY");
			return;
		case PCODE_t:
		case CCODE_t:
			_clip_printf(mp, "CODE");
			return;
		default:
			break;
		}
		if (n)
			break;
		mp->buflen *= 2;
		mp->buf = (char *) realloc(mp->buf, mp->buflen);
	}
}

int
clip_TRANSFORM(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);
	char *pict = _clip_parc(mp, 2);

	transform(mp, vp, pict);
	_clip_retcn(mp, mp->buf, strlen(mp->buf));

	return 0;
}
#endif

int
_clip_dtostr(char *buf, int len, int dec, double d, int zero)
{
#if 1
	int im = 0, ie;
	char *s;
	double de;
	int neg = 0;
	int cnt = 0;
	int snp = 0;

	buf[len] = 0;

#ifdef CLIP_DEBUG
	printf("\n00dec=%d,len=%d", dec, len);
#endif
	if (dec == 0 ? dec >= len : dec >= len - 1)	/* (1) if not true dec + 1 < len */
		dec = 0;
	/*goto err;
	   else
	 */
	if (dec > 9)
		snp = 1;
	else
	{
		if (d < 0)
		{
			d = -d;
			neg = 1;
		}
		if (dec > 0)
		{
			cnt = dec;
#ifdef ARCH_i386
			(*(long long*)&d)++;
#endif
			im = (int) (modf(d, &de) * _clip_deck[dec] + 0.5f);
			/* chek if fractional part was rounded up */
			/* commented out - 'ie += im' is faster
			   if (im >= _clip_deck[dec])
			   {
			   ++de;
			   im -= _clip_deck[dec];
			   }
			 */
		}
		else
			modf(d + 0.5f, &de);

		if (de >= 1000000000)
			snp = 1;
	}

#ifdef CLIP_DEBUG
	printf("\n01dec=%d,len=%d", dec, len);
#endif
	if (snp)
	{
#if 1 /* Uri added for str(-1234567890,10)*/
		double diff;
		snprintf(buf, len + 1, zero ? "%0*.*f" : "%*.*f", len, dec, neg ? -d : d);
		diff = fabs(fabs(atof(buf)) - d);
		if (diff > (d * MIN_NUMERIC_DIFF))
			goto err;
		/*
		if (fabs(atof(buf)) != d)
			goto err;
		*/
#else
		if (snprintf(buf, len + 1, zero ? "%0*.*f" : "%*.*f", len, dec, neg ? -d : d) < 0)
			goto err;
#endif
		s = strchr(buf, ',');
		if (s)
			*s = '.';
		return 0;
	}

#ifdef CLIP_DEBUG
	printf("\n02dec=%d,len=%d", dec, len);
#endif
	ie = (int) de;
	s = buf + len;

	if (cnt)
	{
		while (cnt--)
		{
			/* (1) is fales, dec + 1 < len always so s > b */
			*(--s) = '0' + im % 10;
			im /= 10;
		}
		*(--s) = '.';
		ie += im;
		/* im > 0 if fractional part was rounded up
		   the case of *.999 with dec == 2 (im == 100 in that case)
		 */
	}

#ifdef CLIP_DEBUG
	printf("\n03dec=%d,len=%d", dec, len);
#endif
	while (1)
	{
		if (--s < buf)
			goto err;
		*s = '0' + ie % 10;
		ie /= 10;
		if (!ie)
			break;
	}

#ifdef CLIP_DEBUG
	printf("\n04dec=%d,len=%d", dec, len);
#endif
	if (zero)
	{
		if (neg ? s <= buf : s < buf)
			goto err;
#ifdef CLIP_DEBUG
		printf("\n05dec=%d,len=%d", dec, len);
#endif
		while (s > buf)
			*(--s) = '0';
		if (neg)
			*s = '-';
	}
	else
	{
#ifdef CLIP_DEBUG
		printf("\n06dec=%d,len=%d", dec, len);
#endif
		if (neg)
		{
			if (--s < buf)
				goto err;
			*s = '-';
		}
		while (s > buf)
			*(--s) = ' ';
#ifdef CLIP_DEBUG
		printf("\n07dec=%d,len=%d", dec, len);
#endif
	}

	return 0;

	  err:
	memset(buf, '*', len);
	if (dec > 0 && dec < len)
		buf[len - dec - 1] = '.';

	return 1;
}
#else
	int im, ie;
	int l;
	char *s;
	double de;
	int neg = 0;
	int cnt;

	buf[len] = 0;
	if (dec < 0 || dec > 9 || dec >= len - 1)
	{
		if (snprintf(buf, len + 1, "%*.*f", len, dec, d) < 0)
			goto err;
		s = strchr(buf, ',');
		if (s)
			*s = '.';
		return 0;
	}

	if (d < 0)
	{
		d = -d;
		neg = 1;
	}
	im = (int) (modf(d, &de) * _clip_deck[dec] + 0.5f);
	if (de >= 1000000000)
	{
		if (snprintf(buf, len + 1, "%*.*f", len, dec, neg ? -d : d) < 0)
			goto err;
		s = strchr(buf, ',');
		if (s)
			*s = '.';
		return 0;
	}
	ie = (int) de;
	s = buf + len;
	if (dec)
	{
		cnt = 0;
		while (cnt++ < dec)
		{
			l = im % 10;
			s--;
			if (s < buf)
				goto err;
			*s = '0' + l;
			im = im / 10;
		}
		*(--s) = '.';
	}
	ie += im;		/* the case of *.999 with dec == 2 (im == 100 in that case) */
	while (1)
	{
		l = ie % 10;
		s--;
		if (s < buf)
			goto err;
		*s = '0' + l;
		ie = ie / 10;
		if (!ie)
			break;
	}
	if (zero)
	{
		while (s > buf)
			*(--s) = '0';
		if (neg)
		{
			if (s < buf)
				goto err;
			*s = '-';
		}
	}
	else
	{
		if (neg)
		{
			s--;
			if (s < buf)
				goto err;
			*s = '-';
		}
		while (s > buf)
			*(--s) = ' ';
	}
	return 0;
	  err:
	memset(buf, '*', len);
	if (dec > 0 && dec < len)
		buf[len - dec - 1] = '.';
	return 1;
}
#endif

CLIP_DLLEXPORT double
_clip_strtod(char *str, int *decpos)
{
#if 1
	int ie = 0;
	int im = 0;
	double d;
	char *s = str, *e, *m;
	int ecnt, mcnt, cnt;
	struct lconv *lc;
	int neg = 0;

	while (*s == ' ')
		s++;
	if (*s == '+')
		s++;
	if (!(((*s >= '0') && (*s <= '9')) || (*s == '.') || (*s == ',') || (*s == '-') || (*s == '+')))
	{
		if (decpos)
			*decpos = strlen(str);
		return 0;
	}

	if (*s == '-')
	{
		neg = 1;
		s++;
	}
	e = s;
	while (*s >= '0' && *s <= '9')
		s++;
	ecnt = s - e;

	m = s;
	if ((*m == '.') || (*m == ','))
	{
		if (decpos)
			*decpos = (s == str) ? 1 : s - str;
		m++;
		while (*m >= '0' && *m <= '9')
			m++;
		mcnt = m - s - 1;
	}
	else
	{
		mcnt = 0;
		if (decpos)
			*decpos = 0;
	}

	if (ecnt > 9 || mcnt > 9)
	{
		if (mcnt > 0)
		{
			lc = localeconv();
			*s = *lc->decimal_point;
			d = strtod(e, NULL);
			*s = '.';
		}
		else
			d = strtod(e, NULL);
	}
	else
	{
		for (m = s + 1, cnt = mcnt; cnt > 0; m++, cnt--)
			im = im * 10 + (*m - '0');

		for (; ecnt > 0; e++, ecnt--)
			ie = ie * 10 + (*e - '0');

		d = (double) ie;
		if (im > 0)
			d += (double) (im) / _clip_deck[mcnt];
	}

	return neg ? -d : d;

#else
	int ie = 0;
	int im = 0;
	double d;
	char *s = str, *e;
	int cnt, dcnt = 0;
	struct lconv *lc;
	int neg = 0;

	while (*s == ' ')
		s++;
	if (!(((*s >= '0') && (*s <= '9')) || (*s == '.') || (*s == '-') || (*s == '+')))
	{
		if (decpos)
			*decpos = strlen(str);
		return 0;
	}
	while ((*s >= '0' && *s <= '9') || *s == '-' || *s == '+')
		s++;

	e = s;
	while ((*e >= '0' && *e <= '9') || *e == '.')
		e++;
	if (*s != 0 && *s == '.')
	{
		if (decpos)
			*decpos = s - str;
	}
	else
	{
		s = NULL;
		if (decpos)
			*decpos = 0;
	}
	if (s)
	{
		if (s - str > 9 || e - s - 1 > 9)
		{
			lc = localeconv();
			*s = *lc->decimal_point;
			if (decpos)
				*decpos = s - str;
			return strtod(str, NULL);
		}
	}
	else if (e - str > 9)
	{
		return strtod(str, NULL);
	}
	if (s)
	{
		for (dcnt = 0; (--e) > s; dcnt++)
		{
			if (*e >= '0' && *e <= '9')
				im += (*e - '0') * _clip_deck[dcnt];
			else
			{
				if (*e == ' ')
					dcnt--;
				else
					break;
			}
		}
	}
	for (cnt = 0; (--e) >= str; cnt++)
	{
		if (*e == '-')
		{
			neg = 1;
			break;
		}
		if (*e >= '0' && *e <= '9')
			ie += (*e - '0') * _clip_deck[cnt];
		else
		{
			if (*e == ' ')
				cnt--;
			else
				break;
		}
	}
	d = (double) ie;
	if (s)
		d += (double) (im) / _clip_deck[dcnt];
	if (neg)
		d = -d;
	return d;
#endif
}

int
clip_VAL(ClipMachine * mp)
{
	int l;
	char *s = _clip_parcl(mp, 1, &l);
	int plen = _clip_parni(mp, 2);
	int pdec = _clip_parni(mp, 3);
	int i;

	if (!s)
	{
		_clip_retnd(mp, 0);
		return 0;
	}
	if (mp->flags & RATIONAL_FLAG)
	{
		for (i = l; i >= 0 && s[i] != '/' && s[i] != '.'; i--);
		if (i < 0)
			i = 0;
		else
			i = l - i - 1;
		_clip_retnr(mp, rational_fromString(s), l, i);
	}
	else
	{
		char *sp;
		int dec = 0, len = 0;
		double d;

		d = _clip_strtod(s, &dec);
		if (dec == 0)
		{
			for (sp = s; *sp && (*sp == ' ' || *sp == '\t'); sp++)
				;
		}
		else
			sp = s + dec;
		for (; *sp && (isdigit(*sp) || *sp == '.' || *sp == ',' || *sp == '-' || *sp == '+' || *sp==' '); ++sp)
			;
		len = sp - s;
		if (dec)
		{
			if ( *s == '.' || *s == ',' )
				dec = len - dec;
			else
				dec = len - dec - 1;
		}
		if (mp->flags & FIXED_FLAG)
			dec = mp->decimals;
		if (dec < 0 || dec == len)
			dec = 0;
		if (plen != 0)
			len = plen;
		if (len < dec+2)
			len = dec+2;
		if (_clip_parinfo(mp, 0) == 3)
			dec = pdec;
		_clip_retndp(mp, d, len, dec);
	}

	return 0;
}

int
clip_FLOATVAL(ClipMachine * mp)
{
	char *s = _clip_parc(mp, 1);
	int len = _clip_parni(mp, 2);
	int dec = _clip_parni(mp, 3);

	if (!s)
	{
		_clip_retnd(mp, 0);
		return 0;
	}
	if(strchr(s,'e') || strchr(s,'E'))
	{
		struct lconv* lc = localeconv();
		char c,*r;

		if(*lc->decimal_point == '.')
			c = ',';
		else
			c = '.';
		r = s;
		while((r = strchr(r,c)))
			*r = *lc->decimal_point;
		_clip_retndp(mp, atof(s), len, dec);
		return 0;
	}
	return clip_VAL(mp);
}

static void
eject(ClipMachine * mp)
{
	FILE *printer = (FILE *) mp->printer;
	int i;

	mp->prow = 0;
	mp->pcol = 0;

	if (!printer)
		return;

	fputc('\f', printer);
	fputc('\r', printer);

	for (i = 0; i < mp->margin; ++i)
		fputc(' ', printer);
}

int
clip___EJECT(ClipMachine * mp)
{
	eject(mp);
	return 0;
}

int
clip_SETPOS(ClipMachine * mp)
{
	int y = _clip_parnl(mp, 1);
	int x = _clip_parnl(mp, 2);
	int scr = _clip_parl(mp, 3);

	if (mp->flags & DEVICE_FLAG)
	{
		int i;
		FILE *printer = (FILE *) mp->printer;

		if (!printer)
			goto norm;

		if (mp->prow > y)
			eject(mp);

		if (mp->prow < y)
		{
			char *pEol = (char *) _clip_fetch_item(mp, _clip_hashstr("PRINTER_EOL"));

			while (mp->prow < y)
			{
				mp->pcol = 0;
				mp->prow++;
				if (pEol == NULL || *pEol == 0)
					fputc('\n', printer);
				else
					fputs(pEol, printer);

			}
			for (i = 0; i < mp->margin; ++i)
				fputc(' ', printer);
		}

		if (mp->pcol > x)
		{
			fputc('\r', printer);
			mp->pcol = 0;
			for (i = 0; i < mp->margin; ++i)
				fputc(' ', printer);
		}

		while (mp->pcol < x)
		{
			fputc(' ', printer);
			mp->pcol++;
		}
	}

	  norm:
	_clip_fullscreen(mp);

	if (scr)
	{
		if (x < 0)
			x = 0;
		if (x >= mp->screen->base->Columns)
			x = mp->screen->base->Columns - 1;
		if (y < 0)
			y = 0;
		if (y >= mp->screen->base->Lines)
			y = mp->screen->base->Lines - 1;
	}
	else
		clip_region(mp, &y, &x, 0, 0, 1, -1);

	mp->screen->y = y;
	mp->screen->x = x;
	sync_mp(mp);

	return 0;
}

int
clip_SETCURSOR(ClipMachine * mp)
{
	int oldcursor;
	int ret = 0;

	_clip_fullscreen(mp);
	oldcursor = mp->screen->cursor;

	switch (oldcursor)
	{
	case 0:
		ret = 1;
		break;
	case 1:
		ret = 0;
		break;
	case 2:
		ret = 3;
		break;
	}

	if (mp->argc > 0)
	{
		int cursor = _clip_parni(mp, 1);
		int scr_cursor;

		switch (cursor)
		{
		case 0:
			scr_cursor = 1;
			break;
		case 1:
		default:
			scr_cursor = 0;
			break;
		case 2:
		case 3:
		case 4:
			scr_cursor = 2;
			break;
		}

		mp->screen->cursor = scr_cursor;

		sync_mp(mp);
	}

	_clip_retni(mp, ret);
	return 0;
}

int
clip_DEVPOS(ClipMachine * mp)
{
	return clip_SETPOS(mp);
}

static int
is_pgch(int ch)
{
	switch (ch)
	{
	case PGCH_HLINE:
	case PGCH_LLCORNER:
	case PGCH_LRCORNER:
	case PGCH_TTEE:
	case PGCH_RTEE:
	case PGCH_LTEE:
	case PGCH_BTEE:
	case PGCH_ULCORNER:
	case PGCH_URCORNER:
	case PGCH_VLINE:

	case PGCH_HLINE2:
	case PGCH_LLCORNER2:
	case PGCH_LRCORNER2:
	case PGCH_TTEE2:
	case PGCH_RTEE2:
	case PGCH_LTEE2:
	case PGCH_BTEE2:
	case PGCH_ULCORNER2:
	case PGCH_URCORNER2:
	case PGCH_VLINE2:

	case PGCH_PLUS:
	case PGCH_PLUS2:
	case PGCH_BLOCK:

	case PGCH_RARROW:
	case PGCH_LARROW:
		return 1;
	}

	return 0;
}

static void
out_scr(ClipMachine * mp, char *buf, int n, int attr, int wrap)
{
	int i;
	unsigned char *s, ch;
	Screen *sp = mp->screen;
	int x = sp->x;
	int y = sp->y;
	int top = -1024, left = -1024, bottom = 1024, right = 1024;

	if (mp->obuf)
	{
		int i;

		for (i = 0; i < n; i++)
			putByte_Buf(mp->obuf, _clip_outtbl[(unsigned char) buf[i]]);
		return;
	}

	clip_region(mp, &top, &left, &bottom, &right, 1, -1);

	if (x > right || y > bottom || x < left || y < top)
		return;

	sp->touched[y] = 1;

	for (i = 0, s = (unsigned char *)buf; i < n; ++i, ++s)
	{
		switch ((ch = *s))
		{
		case '\n':
			if (wrap)
			{
				++y;
				if (y <= bottom)
					sp->touched[y] = 1;
				x = left;
			}
			else
				goto def;

			break;
		case '\r':
			if (wrap)
			{
				x = left;
			}
			else
				goto def;
			break;
		case '\b':
			if (wrap)
			{
				--x;
				if (x < left)
				{
					--y;
					x = right;
					sp->touched[y] = 1;
				}
			}
			else
				goto def;

			break;
		case '\t':
			if (wrap)
			{
				int i = x;

				x = (x / 8 + 1) * 8;
				for (; i < x; ++i)
				{
					if (i > right)
						break;
					sp->chars[y][i] = ' ';
					sp->colors[y][i] = attr;
					sp->attrs[y][i] = 0;
				}
			}
			else
				goto def;

			break;
		default:
			  def:
			ch = mp->term_xlat[ch];

			if (ch < 32 && !is_pgch(ch))
			{
				sp->chars[y][x] = ch + 64;
				sp->colors[y][x] = attr | 0x8;
				sp->attrs[y][x] = 0;
			}
			else
			{
				sp->chars[y][x] = ch;
				sp->colors[y][x] = attr;
				sp->attrs[y][x] = 0;
			}

			++x;
			break;
		}

		if (wrap)
		{
			if (x > right)
			{
				x = left;
				y++;
				if (y <= bottom)
					sp->touched[y] = 1;
			}
			if (y > bottom)
			{
				top = 0;
				clip_region(mp, &top, 0, 0, 0, 0, -1);
				while (y > bottom)
				{
					scrollw_Screen(sp, top, left, bottom, right, 1, attr);
					--y;
				}
			}
			if (y < top)
			{
				top = 0;
				clip_region(mp, &top, 0, 0, 0, 0, -1);
				while (y < top)
				{
					scrollw_Screen(sp, top, left, bottom, right, -1, attr);
					++y;
				}
			}
		}
		else if (x > right)
			break;
	}

	/*sp->touched[y] = 1; */
	sp->y = y;
	sp->x = x;
}

int
_clip_str2attr(char *str, int len)
{
	int bg = 0, fg = 0, *ap = &fg, done = 0;
	char *e;

	if (len == 2 && !strcmp(str, "-1"))
		return -1;

	for (e = str + len; !done && *str && str < e; ++str)
		switch (*str)
		{
		case ',':
			done = 1;
			break;
		case '/':
			ap = &bg;
			break;
		case 'U':
		case 'N':
		case 'X':
		case 'u':
		case 'n':
		case 'x':
		case ' ':
			*ap |= COLOR_BLACK;
			break;
		case 'B':
		case 'b':
			*ap |= COLOR_BLUE;
			break;
		case 'W':
		case 'w':
			*ap |= COLOR_WHITE;
			break;
		case 'G':
		case 'g':
			*ap |= COLOR_GREEN;
			break;
		case 'R':
		case 'r':
			*ap |= COLOR_RED;
			break;
		case '+':
			fg |= COLOR_HI;
			break;
		case 'I':
		case 'i':
			*ap = ~*ap;
			break;
		case '*':
			bg |= COLOR_HI;
			break;
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			*ap = strtol(str, &str, 10);
			--str;
			break;
		}
	return (((bg << 4) & 0xf0) | (fg & 0xf)) /*& 0x7f */ ;
}

int
_clip_attr2str(int attr, char *buf, int buflen, int num_format)
{
	int l = 0;

	if (num_format)
	{
		snprintf(buf, buflen, "%d/%d", attr & 0xf, (attr >> 4) & 0xf);
		l = strlen(buf);
		return l;
	}

	if (attr & COLOR_HI)
	{
		buf[l] = '+';
		++l;
	}

	if (l >= buflen)
		return l;

	if ((attr >> 4) & COLOR_HI)
	{
		buf[l] = '*';
		++l;
	}

	if (l >= buflen)
		return l;

	switch (attr & 0x7)
	{
	case COLOR_BLACK:
		buf[l] = 'N';
		break;
	case COLOR_WHITE:
		buf[l] = 'W';
		break;
	case COLOR_BLUE:
	case COLOR_CYAN:
		buf[l] = 'B';
		break;
	case COLOR_GREEN:
	case COLOR_YELLOW:
		buf[l] = 'G';
		break;
	case COLOR_RED:
	case COLOR_MAGENTA:
		buf[l] = 'R';
		break;
	}

	++l;
	if (l >= buflen)
		return l;

	switch (attr & 0x7)
	{
	case COLOR_CYAN:
		buf[l] = 'G';
		++l;
		break;
	case COLOR_MAGENTA:
		buf[l] = 'B';
		++l;
		break;
	case COLOR_YELLOW:
		buf[l] = 'R';
		++l;
		break;
	}

	if (l >= buflen)
		return l;

	buf[l] = '/';
	++l;

	if (l >= buflen)
		return l;

	switch ((attr >> 4) & 0x7)
	{
	case COLOR_BLACK:
		buf[l] = 'N';
		break;
	case COLOR_WHITE:
		buf[l] = 'W';
		break;
	case COLOR_BLUE:
	case COLOR_CYAN:
		buf[l] = 'B';
		break;
	case COLOR_GREEN:
	case COLOR_YELLOW:
		buf[l] = 'G';
		break;
	case COLOR_RED:
	case COLOR_MAGENTA:
		buf[l] = 'R';
		break;
	}

	++l;
	if (l >= buflen)
		return l;

	switch ((attr >> 4) & 0x7)
	{
	case COLOR_CYAN:
		buf[l] = 'G';
		++l;
		break;
	case COLOR_MAGENTA:
		buf[l] = 'B';
		++l;
		break;
	case COLOR_YELLOW:
		buf[l] = 'R';
		++l;
		break;
	}

	return l;
}

static int
get_color(ClipMachine * mp, char *str)
{
	if (str)
	{
		int l = strcspn(str, ",");

		return _clip_str2attr(str, l);
	}
	else
		return _clip_colorSelect(mp);
}

void
_clip_fullscreen(ClipMachine * mp)
{
	if (mp->fullscreen)
		return;
	mp->fullscreen = 1;
	_clip_init_tty(mp);
	if (!mp->screen)
	{
		char msg[256];
		int l;
		ClipFrame *fp;

		snprintf(msg, sizeof(msg), "request to switch into FULLSCREEN mode failed: %s\n", mp->syserr);
		l = strlen(msg);
		out_log(mp, msg, l, 0);
		out_err(mp, msg, l, 0);
		for (fp = mp->fp; fp; fp = fp->up)
		{
			_clip_logg(0, "trace: file '%s' line %d", fp->filename, fp->line);
			fprintf(stderr, "trace: file '%s' line %d\n", fp->filename, fp->line);
			fflush(stderr);
		}

		exit(2);
	}
	/*clear_Screen(mp->screen); */
}

int
clip_DEVOUT(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);

	_clip_fullscreen(mp);

	if (!vp)
		return 0;

	print_var(mp, vp, get_color(mp, _clip_parc(mp, 2)), DEV_DEV, 0);
	sync_mp(mp);

	return 0;
}

#ifdef CLIP_TRANSFORM_C
int
clip_DEVOUTPICT(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);
	char *pict = _clip_parc(mp, 2);
	int attr;

	_clip_fullscreen(mp);

	if (!vp)
		return 0;

	attr = get_color(mp, _clip_parc(mp, 3));
	if (pict)
	{
		transform(mp, vp, pict);
		out_dev(mp, mp->buf, strlen(mp->buf), attr, 0);
	}
	else
		print_var(mp, vp, attr, DEV_SCR, 0);

	sync_mp(mp);

	return 0;
}
#endif

static void
sync_mp(ClipMachine * mp)
{
	if (!mp->update && !mp->inkey)
	{
		if (mp->fullscreen)
			sync_Screen(mp->screen, mp->flags1 & UTF8TERM_FLAG );
		else if (mp->flags1 & FLUSHOUT_FLAG)
			fflush((FILE *) mp->out);
	}
}

int
clip_DISPOUT(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 1);

	_clip_fullscreen(mp);

	if (!vp)
		return 0;

	print_var(mp, vp, get_color(mp, _clip_parc(mp, 2)), DEV_SCR, 0);
	sync_mp(mp);

	return 0;
}

/* disppos(nRow,nCol) */
int
clip_DISPPOS(ClipMachine * mp)
{
	int y = _clip_parnl(mp, 1);
	int x = _clip_parnl(mp, 2);

	_clip_fullscreen(mp);

	clip_region(mp, &y, &x, 0, 0, 1, -1);

	mp->screen->y = y;
	mp->screen->x = x;
	sync_mp(mp);

	return 0;
}

/* dispoutat(nRow,nCol,var[,cColor]) */
int
clip_DISPOUTAT(ClipMachine * mp)
{
	ClipVar *vp = _clip_par(mp, 3);

	clip_DISPPOS(mp);

	_clip_fullscreen(mp);

	if (!vp)
		return 0;

	print_var(mp, vp, get_color(mp, _clip_parc(mp, 4)), DEV_SCR, 0);
	sync_mp(mp);

	return 0;
}

/*
   dispstr(nStr,nCol,cStr);
 */
int
clip_DISPSTR(ClipMachine * mp)
{
	int top = _clip_parni(mp, 1);
	int left = _clip_parni(mp, 2);
	int len;
	char *str = _clip_parcl(mp, 3, &len);
	int bottom, right, i, k;
	Screen *sp;

	if (!str)
		return 0;
	_clip_fullscreen(mp);
	sp = mp->screen;

	bottom = top;
	right = left + len - 1;

	clip_region(mp, &top, &left, &bottom, &right, 0, -1);
	sp->touched[top] = 1;
	for (k = 0, i = left; i <= right; ++i, ++k)
		sp->chars[top][i] = str[k];

	sync_mp(mp);

	return 0;
}

/* blinkattr([lEnable]) -> prevstate */
int
clip_BLINKATTR(ClipMachine * mp)
{
	int prevState = -1;

	if (_clip_parinfo(mp, 1) == LOGICAL_t)
		prevState = _clip_parl(mp, 1);

	_clip_fullscreen(mp);
	setAttr_Screen(mp->screen, &prevState, 0);

	_clip_retl(mp, prevState);
	return 0;
}

/* boldattr([lEnable]) -> prevstate */
int
clip_BOLDATTR(ClipMachine * mp)
{
	int prevState = -1;

	if (_clip_parinfo(mp, 1) == LOGICAL_t)
		prevState = _clip_parl(mp, 1);

	_clip_fullscreen(mp);
	setAttr_Screen(mp->screen, 0, &prevState);

	_clip_retl(mp, prevState);
	return 0;
}

/*
   dispattr(nTop,nLeft,nBottom,nRight,cColor|nColor)
 */
int
clip_DISPATTR(ClipMachine * mp)
{
	int top = _clip_parni(mp, 1);
	int left = _clip_parni(mp, 2);
	int bottom = _clip_parni(mp, 3);
	int right = _clip_parni(mp, 4);
	int i, j, attr;
	Screen *sp;
	ClipVar *vp;

	_clip_fullscreen(mp);
	sp = mp->screen;

	vp = _clip_par(mp, 5);
	if (vp)
	{
		if (vp->t.type == NUMERIC_t)
			attr = _clip_parni(mp, 5);
		else
			attr = get_color(mp, _clip_parc(mp, 5));
	}
	else
		attr = _clip_colorSelect(mp);

	clip_region(mp, &top, &left, &bottom, &right, 0, -1);
	for (i = top; i <= bottom; ++i)
	{
		sp->touched[i] = 1;
		for (j = left; j <= right; ++j)
		{
			/*int pg = sp->colors[i][j] & PG_ATTR; */

			sp->colors[i][j] = attr /*| pg */ ;
		}
	}

	sync_mp(mp);
	return 0;
}

int
clip_FT_SHADOW(ClipMachine * mp)
{
	return clip_DISPATTR(mp);
}

int
clip_FT_SETATTR(ClipMachine * mp)
{
	return clip_DISPATTR(mp);
}

static void
disp_box(ClipMachine * mp, int Top, int Left, int Bottom, int Right,
	 unsigned char *chars, int cl, int chars_n, char *color, int fill)
{
	Screen *sp;
	int attr = get_color(mp, color);
	int i, j;
	int top, left, bottom, right;
	int ulc, urc, hlt, hlb, llc, lrc, vll, vlr, mch = ' ', pg_char = 0;

	_clip_fullscreen(mp);
	sp = mp->screen;

	if (!chars)
		pg_char = 1;

	if (!chars && chars_n == 2)
	{
		ulc = PGCH_ULCORNER2;
		urc = PGCH_URCORNER2;
		hlt = PGCH_HLINE2;
		hlb = PGCH_HLINE2;
		llc = PGCH_LLCORNER2;
		lrc = PGCH_LRCORNER2;
		vll = PGCH_VLINE2;
		vlr = PGCH_VLINE2;
	}
	else
	{
		ulc = PGCH_ULCORNER;
		urc = PGCH_URCORNER;
		hlt = PGCH_HLINE;
		hlb = PGCH_HLINE;
		llc = PGCH_LLCORNER;
		lrc = PGCH_LRCORNER;
		vll = PGCH_VLINE;
		vlr = PGCH_VLINE;
	}

	top = Top;
	left = Left;
	bottom = Bottom;
	right = Right;

	wind_region(mp, &Top, &Left, &Bottom, &Right, 0);
	clip_region(mp, &top, &left, &bottom, &right, 0, -1);

	if (chars && cl > 0)
	{
		ulc = mch;
		urc = mch;
		hlt = mch;
		hlb = mch;
		llc = mch;
		lrc = mch;
		vll = mch;
		vlr = mch;
		if (cl > 0)
			ulc = chars[0];
		if (cl > 1)
			hlt = chars[1];
		if (cl > 2)
			urc = chars[2];
		if (cl > 3)
			vlr = chars[3];
		if (cl > 4)
			lrc = chars[4];
		if (cl > 5)
			hlb = chars[5];
		if (cl > 6)
			llc = chars[6];
		if (cl > 7)
			vll = chars[7];
		if (cl > 8)
		{
			mch = chars[8];
			fill = 1;
		}
	}

	for (i = top; i <= bottom; ++i)
	{
		sp->touched[i] = 1;
		for (j = left; j <= right; ++j)
		{
			int ch;

			if (top == bottom)
				ch = hlt;
			else if (left == right)
				ch = vll;
			else if (i == Top)
			{
				if (j == Left)
					ch = ulc;
				else if (j == Right)
					ch = urc;
				else
					ch = hlt;
			}
			else if (i == Bottom)
			{
				if (j == Left)
					ch = llc;
				else if (j == Right)
					ch = lrc;
				else
					ch = hlb;
			}
			else if (j == Left)
				ch = vll;
			else if (j == Right)
				ch = vlr;
			else if (fill)
				ch = mch;
			else
				continue;

			sp->chars[i][j] = ch;
			/*if (pg_char)
				sp->attrs[i][j] |= PG_ATTR;*/
			sp->colors[i][j] = attr;
		}
	}

	sync_mp(mp);
}

int
clip_DISPBOXTERM(ClipMachine * mp)
{
	int Top = _clip_parni(mp, 1);
	int Left = _clip_parni(mp, 2);
	int Bottom = _clip_parni(mp, 3);
	int Right = _clip_parni(mp, 4);
	int cl = 0;
	unsigned char *chars = (unsigned char *) _clip_parcl(mp, 5, &cl);
	int chars_n = _clip_parni(mp, 5);
	char *color = _clip_parc(mp, 6);

	if (cl > 0 || !chars)
		disp_box(mp, Top, Left, Bottom, Right, chars, cl, chars_n, color, 0);
	else
		disp_box(mp, Top, Left, Bottom, Right, (unsigned char *)("         "), 9, chars_n, color, 0);

	return 0;
}

#ifdef USE_TASKS
int clip_TASKSTART(ClipMachine * mp);
int clip_TASKSTOP(ClipMachine * mp);
#endif

int
clip_DISPBEGIN(ClipMachine * mp)
{
#ifdef USE_TASKS
	if (!mp->update)
		clip_TASKSTOP(mp);
#endif
	mp->update++;
	return 0;
}

int
clip_DISPEND(ClipMachine * mp)
{
	mp->update--;
	if (_clip_debuglevel)
		sync_Screen(mp->screen, mp->flags1 & UTF8TERM_FLAG );
	if (mp->update <= 0)
	{
		mp->update = 0;
		if (mp->fullscreen)
			sync_Screen(mp->screen, mp->flags1 & UTF8TERM_FLAG );
#ifdef USE_TASKS
		clip_TASKSTART(mp);
#endif
	}
	return 0;
}

int
clip_DISPCOUNT(ClipMachine * mp)
{
	_clip_retni(mp, mp->update);
	return 0;
}

int
clip_ROW(ClipMachine * mp)
{
	int r;
	int scr = _clip_parl(mp, 1);

	if (mp->fullscreen)
	{
		if (scr)
		{
			Screen *sp = mp->screen;

			r = sp->y;
		}
		else
		{
			ClipWindow *wp = mp->windows + mp->wnum;

			r = mp->screen->y - wp->format.top;
		}
	}
	else
		r = 0;
	_clip_retnl(mp, r);
	return 0;
}

int
clip_COL(ClipMachine * mp)
{
	int r;
	int scr = _clip_parl(mp, 1);

	if (mp->fullscreen)
	{
		if (scr)
		{
			Screen *sp = mp->screen;

			r = sp->x;
		}
		else
		{
			ClipWindow *wp = mp->windows + mp->wnum;

			r = mp->screen->x - wp->format.left;
		}
	}
	else
		r = 0;
	_clip_retnl(mp, r);
	return 0;
}

int
clip_PROW(ClipMachine * mp)
{
	_clip_retnl(mp, mp->prow);
	return 0;
}

int
clip_PCOL(ClipMachine * mp)
{
	_clip_retnl(mp, mp->pcol);
	return 0;
}

int
clip_SETPRC(ClipMachine * mp)
{
	if (mp->argc > 0)
		mp->prow = _clip_parni(mp, 1);
	if (mp->argc > 1)
		mp->pcol = _clip_parni(mp, 2);
	return 0;
}

int
clip_MAXROW(ClipMachine * mp)
{
	int r;
	int scr = _clip_parl(mp, 1);

	_clip_fullscreen(mp);
	if (mp->fullscreen)
	{
		if (scr)
		{
			Screen *sp = mp->screen;

			r = sp->base->Lines-1;
		}
		else
		{
			ClipWindow *wp = mp->windows + mp->wnum;

			r = wp->format.bottom - wp->format.top;
		}
	}
	else
		r = 0;
	_clip_retnl(mp, r);
	return 0;
}

int
clip_MAXCOL(ClipMachine * mp)
{
	int r;
	int scr = _clip_parl(mp, 1);

	_clip_fullscreen(mp);
	if (mp->fullscreen)
	{
		if (scr)
		{
			Screen *sp = mp->screen;

			r = sp->base->Columns-1;
		}
		else
		{
			ClipWindow *wp = mp->windows + mp->wnum;

			r = wp->format.right - wp->format.left;
		}
	}
	else
		r = 0;
	_clip_retnl(mp, r);
	return 0;
}

static int altkeys[] = {
	286,
	304,
	302,
	288,
	274,
	289,
	290,
	291,
	279,
	292,
	293,
	294,
	306,

	305,
	280,
	281,
	272,
	275,
	287,
	276,
	278,
	303,
	273,
	301,
	277,
	300,
};

static int altnums[] = {
	385,			/*   Alt-0  */
	376,			/*   Alt-1  */
	377,			/*   Alt-2  */
	378,			/*   Alt-3  */
	379,			/*   Alt-4  */
	380,			/*   Alt-5  */
	381,			/*   Alt-6  */
	382,			/*   Alt-7  */
	383,			/*   Alt-8  */
	384,			/*   Alt-9  */
};

static int
key2clip(unsigned long key, int mask)
{
	int ckey = 0, flags;

	if (key & MOUSE_MASK)
	{
		int type, buttons;

		if (!(mask & (_CLIP_INKEY_MOVE
				  | _CLIP_INKEY_LDOWN
				  | _CLIP_INKEY_LUP | _CLIP_INKEY_RDOWN | _CLIP_INKEY_RUP | _CLIP_INKEY_MDOWN | _CLIP_INKEY_MUP)))
			return 0;

		type = MOUSE_TYPE(key);
		buttons = MOUSE_BUTTONS(key);

		if (type & MOUSE_TYPE_DOUBLE)
		{
			if (type & MOUSE_TYPE_DOWN)
				return 0;
			if ((mask & (_CLIP_INKEY_LUP | _CLIP_INKEY_LDOWN)) && (buttons & MOUSE_BUTTONS_LEFT))
				return 1006 /* K_LDBLCLK */ ;
			else if ((mask & (_CLIP_INKEY_RUP | _CLIP_INKEY_RDOWN)) && (buttons & MOUSE_BUTTONS_RIGHT))
				return 1007 /* K_RDBLCLK */ ;
			else if ((mask & (_CLIP_INKEY_MUP | _CLIP_INKEY_MDOWN)) && (buttons & MOUSE_BUTTONS_MIDDLE))
				return 1010 /* K_MDBLCLK */ ;
			else
				return 0;
		}

		switch (type & (MOUSE_TYPE_MOVE | MOUSE_TYPE_DRAG | MOUSE_TYPE_DOWN | MOUSE_TYPE_UP))
		{
		case MOUSE_TYPE_MOVE:
		case MOUSE_TYPE_DRAG:
		case MOUSE_TYPE_MOVE | MOUSE_TYPE_DRAG:
			if ((mask & _CLIP_INKEY_MOVE))
				return 1001 /* K_MOUSEMOVE */ ;
			else
				return 0;
		case MOUSE_TYPE_DOWN:
			if ((mask & _CLIP_INKEY_LDOWN) && (buttons & MOUSE_BUTTONS_LEFT))
				return 1002 /* K_LBUTTONDOWN */ ;
			else if ((mask & _CLIP_INKEY_RDOWN) && (buttons & MOUSE_BUTTONS_RIGHT))
				return 1004 /* K_RBUTTONDOWN */ ;
			else if ((mask & _CLIP_INKEY_MDOWN) && (buttons & MOUSE_BUTTONS_MIDDLE))
				return 1008 /* K_MBUTTONDOWN */ ;
			else
				return 0;
		case MOUSE_TYPE_UP:
			if ((mask & _CLIP_INKEY_LUP) && (buttons & MOUSE_BUTTONS_LEFT))
				return 1003 /* K_LBUTTONUP */ ;
			else if ((mask & _CLIP_INKEY_RUP) && (buttons & MOUSE_BUTTONS_RIGHT))
				return 1005 /* K_RBUTTONUP */ ;
			else if ((mask & _CLIP_INKEY_MUP) && (buttons & MOUSE_BUTTONS_MIDDLE))
				return 1009 /* K_MBUTTONUP */ ;
			else
				return 0;
		}
		return 0;
	}

	if (!(mask & _CLIP_INKEY_KEYBOARD))
		return 0;

	switch (key)
	{
	case KEY_LEFT:
		ckey = 19;
		break;
	case KEY_RIGHT:
		ckey = 4;
		break;
	case KEY_UP:
		ckey = 5;
		break;
	case KEY_DOWN:
		ckey = 24;
		break;
	case KEY_PGDN:
		ckey = 3;
		break;
	case KEY_PGUP:
		ckey = 18;
		break;
	case KEY_HOME:
		ckey = 1;
		break;
	case KEY_END:
		ckey = 6;
		break;
	case KEY_INS:
		ckey = 22;
		break;
	case KEY_BS:
	case 8:
	case 0x7f:
		ckey = 8;
		break;
	case KEY_DEL:
		ckey = 7;
		break;
	case KEY_ENTER:
		ckey = 13;
		break;
	case KEY_ESC:
		ckey = 27;
		break;

	case KEY_F1:
		ckey = 28;
		break;
	case KEY_F2:
		ckey = -1;
		break;
	case KEY_F3:
		ckey = -2;
		break;
	case KEY_F4:
		ckey = -3;
		break;
	case KEY_F5:
		ckey = -4;
		break;
	case KEY_F6:
		ckey = -5;
		break;
	case KEY_F7:
		ckey = -6;
		break;
	case KEY_F8:
		ckey = -7;
		break;
	case KEY_F9:
		ckey = -8;
		break;
	case KEY_F10:
		ckey = -9;
		break;

	case KEY_F11:
		ckey = -40;
		break;
	case KEY_F12:
		ckey = -41;
		break;

	case KEY_F13:
		ckey = -12;
		break;
	case KEY_F14:
		ckey = -13;
		break;
	case KEY_F15:
		ckey = -14;
		break;
	case KEY_F16:
		ckey = -15;
		break;
	case KEY_F17:
		ckey = -16;
		break;
	case KEY_F18:
		ckey = -17;
		break;
	case KEY_F19:
		ckey = -18;
		break;
	case KEY_F20:
		ckey = -19;
		break;

	case META1_MASK | KEY_F11:
		ckey = -46;
		break;
	case META1_MASK | KEY_F12:
		ckey = -47;
		break;
	case META2_MASK | KEY_F11:
		ckey = -44;
		break;
	case META2_MASK | KEY_F12:
		ckey = -45;
		break;
	case META1_MASK | META2_MASK | KEY_F11:
		ckey = -42;
		break;
	case META1_MASK | META2_MASK | KEY_F12:
		ckey = -43;
		break;

	case META1_MASK | KEY_UP:
		ckey = 408;
		break;
	case META1_MASK | KEY_DOWN:
		ckey = 416;
		break;
	case META1_MASK | KEY_LEFT:
		ckey = 411;
		break;
	case META1_MASK | KEY_RIGHT:
		ckey = 413;
		break;
	case META1_MASK | KEY_HOME:
		ckey = 407;
		break;
	case META1_MASK | KEY_END:
		ckey = 415;
		break;
	case META1_MASK | KEY_PGUP:
		ckey = 409;
		break;
	case META1_MASK | KEY_PGDN:
		ckey = 417;
		break;

	case META2_MASK | KEY_UP:
		ckey = 397;
		break;
	case META2_MASK | KEY_DOWN:
		ckey = 401;
		break;
	case META2_MASK | KEY_LEFT:
		ckey = 26;
		break;
	case META2_MASK | KEY_RIGHT:
		ckey = 2;
		break;
	case META2_MASK | KEY_HOME:
		ckey = 29;
		break;
	case META2_MASK | KEY_END:
		ckey = 23;
		break;
	case META2_MASK | KEY_PGUP:
		ckey = 31;
		break;
	case META2_MASK | KEY_PGDN:
		ckey = 30;
		break;

	case META1_MASK | '=':
		ckey = 387;
		break;

	case META1_MASK | '_':
		ckey = 386;
		break;

	case META1_MASK | '\\':
		ckey = 299;
		break;

	case META1_MASK | '[':
		ckey = 282;
		break;

	case META1_MASK | ']':
		ckey = 283;
		break;

	case META1_MASK | ';':
		ckey = 295;
		break;

	case META1_MASK | '\'':
		ckey = 296;
		break;

	case META1_MASK | ',':
		ckey = 307;
		break;

	case META1_MASK | '.':
		ckey = 308;
		break;

	case META1_MASK | '/':
		/*ckey = 309;*/
		ckey = 420;
		break;

		/* shift-Tab */
	case META1_MASK | META2_MASK | 9:
		ckey = 271;
		break;

	case META1_MASK | KEY_INS:
		ckey = 418;
		break;
	case META1_MASK | KEY_DEL:
		ckey = 419;
		break;
	case META1_MASK | KEY_BS:
	case META1_MASK | 0x7f:
		ckey = 270;
		break;
	case META1_MASK | 9:
		ckey = 421;
		break;

	case META2_MASK | KEY_INS:
		ckey = 402;
		break;
	case META2_MASK | KEY_DEL:
		ckey = 403;
		break;
	case META2_MASK | KEY_BS:
	case META2_MASK | 0x7f:
		ckey = 127;
		break;
	case META2_MASK | 9:
		ckey = 404;
		break;

	case META1_MASK | KEY_ENTER:
		ckey = 422;
		break;
	case META1_MASK | KEY_ESC:
		ckey = 257;
		break;

	case META2_MASK | KEY_ENTER:
		ckey = 10;
		break;

		/*case META1_MASK | '/':
		   ckey = 420;
		   break; */
	case META1_MASK | '*':
		ckey = 311;
		break;
	case META1_MASK | '-':
		ckey = 330;
		break;
	case META1_MASK | '+':
		ckey = 334;
		break;

	case META2_MASK | '/':
		ckey = 405;
		break;
	case META2_MASK | '*':
		ckey = 406;
		break;
	case META2_MASK | '-':
		ckey = 398;
		break;
	case META2_MASK | '+':
		ckey = 400;
		break;

	case META2_MASK | '2':
		ckey = 259;
		break;

	default:
		if (key & (META_MASK | META1_MASK | META2_MASK))
		{
			switch (key & ~(META1_MASK | META2_MASK))
			{
			case KEY_F1:
			case KEY_F2:
			case KEY_F3:
			case KEY_F4:
			case KEY_F5:
			case KEY_F6:
			case KEY_F7:
			case KEY_F8:
			case KEY_F9:
			case KEY_F10:
				switch (key & ~(META1_MASK | META2_MASK))
				{
				case KEY_F1:
					ckey = -10;
					break;
				case KEY_F2:
					ckey = -11;
					break;
				case KEY_F3:
					ckey = -12;
					break;
				case KEY_F4:
					ckey = -13;
					break;
				case KEY_F5:
					ckey = -14;
					break;
				case KEY_F6:
					ckey = -15;
					break;
				case KEY_F7:
					ckey = -16;
					break;
				case KEY_F8:
					ckey = -17;
					break;
				case KEY_F9:
					ckey = -18;
					break;
				case KEY_F10:
					ckey = -19;
					break;
				}
				switch (key & (META1_MASK | META2_MASK))
				{
				case META2_MASK:
					ckey -= 10;
					break;
				case META1_MASK:
					ckey -= 20;
					break;
				}
				break;
			default:
				flags = key & ~(META1_MASK | META2_MASK);
				if (flags < 27)
					ckey = altkeys[flags - 1];
				else if (flags == '`' || flags == '~')
					ckey = 297;
				else if (flags >= '0' && flags <= '9')
					ckey = altnums[flags - '0'];
				else if (flags >= 'A' && flags <= 'Z')
					ckey = altkeys[flags - 'A'];
				else if (flags >= 'a' && flags <= 'z')
					ckey = altkeys[flags - 'a'];
				else if (key == (0x10000 | META2_MASK))
				{
					ckey = 'J' - '@';
					break;
				}
				else
				{
					ckey = key & ~(META_MASK | META1_MASK | META2_MASK);
				}

#if 0
				switch (key & (META1_MASK | META2_MASK))
				{
				case META1_MASK:
					ckey += 256;
					break;
				case META2_MASK:
					ckey += 512;
					break;
				case META1_MASK | META2_MASK:
					ckey += 768;
					break;
				}
#endif

				break;
			}
		}
		else
			ckey = key;
		break;
	}

	return ckey;
}

int
clip___KEYBOARD(ClipMachine * mp)
{
	/* second parameters as "not clear keyboard buffer" */
	ClipVar *vp = _clip_par(mp, 1);

	if (!mp->fullscreen)
		return 0;

	if (!_clip_parl(mp, 2) || _clip_parinfo(mp, 0) == 0)
	{
		int tmp = mp->lastkey;
		while (_clip_key(mp, 0, 0xFF));
		mp->lastkey = tmp ;
		*mp->kbdptr = mp->kbdbuf;
		/*_clip_logg(0,"aaa1 clear kbdbuf,%p,%p",*mp->kbdptr,mp->kbdbuf);*/
	}

	if (vp == NULL)
		return 0;

	if (vp->t.type == CHARACTER_t)
	{
		unsigned char *s = (unsigned char *)vp->s.str.buf;
		int l = vp->s.str.len;
		int i;
		int n = *mp->kbdptr - mp->kbdbuf;

		/*_clip_logg(0,"aaa2 clear kbdbuf,%p,%p,%s",*mp->kbdptr,mp->kbdbuf,s);*/
		if ((l - n) > mp->typeahead)
			l = mp->typeahead - n;

		for (i = 0, s = s + l - 1; i < l; ++i, --s, (*mp->kbdptr)++)
			**mp->kbdptr = *s;
	}
	else if (vp->t.type == NUMERIC_t)
	{
		int key = _clip_parni(mp, 1);
		int n = *mp->kbdptr - mp->kbdbuf;

		/*_clip_logg(0,"aaa3 clear kbdbuf,%p,%p,%d",*mp->kbdptr,mp->kbdbuf,key);*/
		if (n < mp->typeahead)
		{
			**mp->kbdptr = key;
			(*mp->kbdptr)++;
		}

	}
	/*_clip_logg(0,"aaa3 clear kbdbuf,%p,%p",*mp->kbdptr,mp->kbdbuf);*/

	return 0;
}

int
clip_LASTKEY(ClipMachine * mp)
{
	_clip_retndp(mp, mp->lastkey,10,0);
	return 0;
}

int
clip_SETLASTKEY(ClipMachine * mp)
{
	if (_clip_parinfo(mp, 1) == NUMERIC_t)
		mp->lastkey = _clip_parni(mp, 1);
	_clip_retc(mp, "");
	return 0;
}

int
clip_KEYREAD(ClipMachine *mp)
{
	int i, count;
	char *ptr;

	for(count = 0; count < mp->typeahead && mp->kbdbuf[count] != 0; count++);

	ptr = calloc(count*2, sizeof(char));

	for(i = 0; i < count; i++)
		ptr[i * 2] = mp->kbdbuf[i];

	_clip_retcn(mp, ptr, count * 2);

	free(ptr);

	return 0;
}

int
clip_NEXTKEY(ClipMachine * mp)
{
	int eventmask = _clip_parni(mp, 1);

	if (_clip_parinfo(mp, 1) != NUMERIC_t)
		eventmask = mp->eventmask;

	_clip_fullscreen(mp);
	if (*mp->kbdptr != mp->kbdbuf)
		_clip_retndp(mp, (*mp->kbdptr)[-1],10,0);
	else
	{
		long key;
		int ckey, l;

		key = getWait_Key(mp->screen->base, 0);
		if (key)
		{
			ckey = key2clip(key, eventmask);
			if ((l = *mp->kbdptr - mp->kbdbuf) >= mp->typeahead)
			{
				mp->typeahead *= 2;
				mp->kbdbuf = (int *) realloc(mp->kbdbuf, sizeof(int) * mp->typeahead);

				*mp->kbdptr = mp->kbdbuf + l;
			}
			*(*mp->kbdptr)++ = ckey;

			_clip_retndp(mp, ckey,10,0);
		}
		else
			_clip_retndp(mp, 0,10,0);
	}
	return 0;
}

int
clip_ISKBDEMPTY(ClipMachine * mp)
{
	_clip_fullscreen(mp);
	_clip_retl(mp, *mp->kbdptr == mp->kbdbuf);
	return 0;
}

int
clip_CHR(ClipMachine * mp)
{
	unsigned char buf[2];
	int ch = _clip_parni(mp, 1);

	buf[0] = ch;
	buf[1] = 0;
	_clip_retcn(mp, (char *)buf, 1);

	return 0;
}

int
clip_ASC(ClipMachine * mp)
{
	unsigned char *str = (unsigned char *)_clip_parc(mp, 1);
	int ch = 0;

	if (str)
		ch = *str;

	_clip_retni(mp, ch);

	return 0;
}

#define timer_sub(a, b, result) \
   do {                         \
	   (result)->tv_sec = (a)->tv_sec - (b)->tv_sec;     \
	   (result)->tv_usec = (a)->tv_usec - (b)->tv_usec;  \
	   if ((result)->tv_usec < 0) {                      \
		  --(result)->tv_sec;                        \
		  (result)->tv_usec += 1000000;              \
	   }                                                 \
   } while (0)

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

static void
cycle_kbdbuf(int *ptr, int len, int x)
{
	int i = len-1;

	if (len == 0)
		return;

	while (ptr[i] == 0 && i > 0)
		i--;

	//First pos
	if (ptr[i] == 0)
	{
		ptr[i] = x;
		return;
	}

	// Intermedia pos
	if (i != len - 1)
	{
		ptr[i+1] = x;
		return;
	}

	// Must cycle
	memmove(ptr, ptr + 1, (len - 1) * sizeof(int));

	ptr[len - 1] = x;
}

CLIP_DLLEXPORT int
_clip_key(ClipMachine * mp, int timeout_ms, int mask)
{
	unsigned long key;
	int ckey = 0;

	/*_clip_fullscreen(mp); */
	/*_clip_logg(0,"bbb1 clip_key,%p,%p",*mp->kbdptr, mp->kbdbuf);*/
	if (*mp->kbdptr != mp->kbdbuf )
	{
		/*_clip_logg(0,"bbb2 clear lastkey,%p,%p",*mp->kbdptr, mp->kbdbuf);*/
		(*mp->kbdptr)--;
		ckey = mp->lastkey = **mp->kbdptr;
		return ckey;
	}

	signal(SIGINT, _clip_sigint_real);
	if (timeout_ms < 0)
		timeout_ms = 1000 * 6000;

	do
	{
		struct timeval end, tv, dt;

		gettimeofday(&tv, 0);
		dt.tv_sec = timeout_ms / 1000;
		dt.tv_usec = (timeout_ms % 1000) * 1000;

		timer_add(&tv, &dt, &end);

		key = getWait_Key(mp->screen->base, timeout_ms);

		ckey = key2clip(key, mask);

		if (ckey != 0)
		{
			cycle_kbdbuf(mp->kbdbuf, mp->typeahead, ckey);

			if (timeout_ms!=0)
				mp->lastkey = ckey;

			break;
		}

		gettimeofday(&tv, 0);
		timer_sub(&end, &tv, &dt);

		timeout_ms = dt.tv_sec * 1000 + dt.tv_usec / 1000;

	}
	while (timeout_ms > 0);

	signal(SIGINT, _clip_sigint);
	return ckey;
}

int
clip_SCANKEY(ClipMachine * mp)
{
	unsigned long key;
	long ms;

	if (mp->argc < 1)
	{
		ms = 0;
	}
	else
	{
		double t = _clip_parnd(mp, 1);

		if (t > 0)
			ms = t * 1000;
		else if (t == 0)
			ms = 1000 * 6000;
		else
			ms = 0;
	}

	dialog_init(mp);
	sync_mp(mp);

	key = getRawWait_Key(mp->screen->base, ms);
	_clip_retnl(mp, key);

	return 0;
}

int
clip_KBDSTAT(ClipMachine * mp)
{
	int flags;
	int r;

	_clip_fullscreen(mp);

	flags = getState_Key(mp->screen->base);

	r = 0;
	if (flags & (1 << KEY_SHIFTL))
		r |= 0x1;
	if (flags & (1 << KEY_SHIFTR))
		r |= 0x2;
	if (flags & (1 << KEY_SHIFT) && !r)
		r |= 0x3;

	if (flags & ((1 << KEY_CTRL) | (1 << KEY_CTRLL) | (1 << KEY_CTRLR)))
		r |= 0x4;
	if (flags & ((1 << KEY_ALT) | (1 << KEY_ALTGR)))
		r |= 0x8;
	if (flags & (1 << KEY_SLOCK))
		r |= 0x10;
	if (flags & (1 << KEY_NATKBD))
		r |= 0x20000;
	if (flags & (1 << KEY_NUMLOCK))
		r |= 0x20;
	if (flags & (1 << KEY_CAPSLOCK))
		r |= 0x40;
	if (flags & (1 << KEY_INSLOCK))
		r |= 0x80;

	_clip_retni(mp, r);

	return 0;
}

int
clip___KSETSTATE(ClipMachine * mp, int locktype)
{
	int newvalue = _clip_parl(mp,1);

	_clip_fullscreen(mp);

	if (_clip_parinfo(mp,1) != LOGICAL_t)
		newvalue = -1;
	_clip_retl(mp,setState_Key(mp->screen->base,newvalue,locktype));

	return 0;
}

int
clip_KSETNUM(ClipMachine * mp)
{
	return clip___KSETSTATE(mp,1);
}

int
clip_KSETCAPS(ClipMachine * mp)
{
	return clip___KSETSTATE(mp,2);
}

int
clip_KSETSCROLL(ClipMachine * mp)
{
	return clip___KSETSTATE(mp,3);
}

int
clip_KSETINS(ClipMachine * mp)
{
	return clip___KSETSTATE(mp,4);
}

int
clip__INKEY(ClipMachine * mp)
{
	int ckey;
	int mask = mp->eventmask;

	dialog_init(mp);
	sync_mp(mp);

	if (mp->argc > 0 && _clip_parinfo(mp, 1) == NUMERIC_t)
	{
		double t = _clip_parnd(mp, 1);

		if (_clip_parinfo(mp, 2) == NUMERIC_t)
			mask = _clip_parni(mp, 2);

		if (t > 0)
			ckey = _clip_key(mp, t * 1000, mask);
		else if (t == 0)
			ckey = _clip_key(mp, -1, mask);
		else
			ckey = _clip_key(mp, 0, mask);
	}
	else
		ckey = _clip_key(mp, 0, mask);

	_clip_retndp(mp, ckey,10,0);

	return 0;
}

int
clip_SETKEY(ClipMachine * mp)
{
	int key = _clip_parni(mp, 1);
	ClipVar *bp = _clip_spar(mp, 2);
	char buf[16];
	long hash;
	void *p;

	snprintf(buf, sizeof(buf), "setkey_%x", key);
	hash = _clip_hashstr(buf);

	p = _clip_fetch_item(mp, hash);

	if (bp)
	{
		ClipVar *rp;

		if (p)
		{
			rp = (ClipVar *) p;
			_clip_clone(mp, RETPTR(mp), rp);
			_clip_destroy(mp, rp);
			_clip_free_item(mp, hash);
		}
		rp = (ClipVar *) calloc(sizeof(ClipVar), 1);

		_clip_clone(mp, rp, bp);
		_clip_store_item(mp, hash, rp);
	}
	else
	{
		if (p)
		{
			ClipVar *rp = (ClipVar *) p;

			_clip_clone(mp, RETPTR(mp), rp);
		}
	}

	return 0;
}

#if 0

int
clip___WAIT(ClipMachine * mp)
{
	int l;
	int ckey = 0;
	char *prompt = _clip_parcl(mp, 1, &l);

	dialog_init(mp);
	if (!prompt)
	{
		prompt = "Press any key...";
		l = strlen(prompt);
	}

	out_dev(mp, "\n", 1, _clip_colorSelect(mp), 1);

	out_dev(mp, prompt, l, _clip_colorSelect(mp), 1);

	sync_mp(mp);

	ckey = _clip_key(mp, -1, _CLIP_INKEY_KEYBOARD);
	_clip_retni(mp, ckey);

	return 0;
}

#endif

int
clip___ACCEPTSTR(ClipMachine * mp)
{
	int c;

	if ((c = mp->history.count))
		_clip_retc(mp, mp->history.items[c - 1]);
	else
		_clip_retc(mp, "");
	return 0;
}

int
clip___ACCEPT(ClipMachine * mp)
{
	int l, c = mp->history.count;
	int ckey = 0;
	int pos, cpos, size = 16;
	unsigned char *s;
	char *prompt = _clip_parcl(mp, 1, &l);
	int attr = _clip_colorSelect(mp);
	int hpos = c;

	dialog_init(mp);
	if (prompt)
	{
		/*_clip_fullscreen(mp); */
		/*out_dev(mp, "\n", 1, attr, 1); */
		out_dev(mp, prompt, l, attr, 1);
		sync_mp(mp);
	}

	s = (unsigned  char *) malloc(size);

	s[0] = 0;

	for (pos = 0, cpos = 0;;)
	{
		int i;

		sync_mp(mp);

		ckey = _clip_key(mp, -1, _CLIP_INKEY_KEYBOARD);

		if (pos >= size - 1)
		{
			size = size * 3 / 2;
			s = (unsigned char *) realloc(s, size);
		}

		switch (ckey)
		{
		case 13:	/* Enter */
			s[pos] = 0;
			goto ret;
		case 27:	/* Esc */
			s[0] = 0;
			goto ret;
		case 5:	/* Up */
			if (!hpos)
				break;
			hpos--;
			  newstr:
			{
				char *sp = mp->history.items[hpos];
				int l = strlen(sp);

				free(s);
				size = l + 4;
				s = (unsigned char *) malloc(size);
				memcpy(s, sp, l);
				s[l] = 0;

				for (i = 0; i < cpos; ++i)
					out_dev(mp, "\b", 1, attr, 1);

				out_dev(mp, (char *)s, l, attr, 1);

				for (i = l; i < pos; ++i)
					out_dev(mp, " ", 1, attr, 1);

				for (; i > l; --i)
					out_dev(mp, "\b", 1, attr, 1);

				pos = cpos = l;
			}
			break;
		case 24:	/* Down */
			if (hpos >= c - 1)
				break;
			++hpos;
			goto newstr;
		case 21:	/* Ctrl-U */
			for (i = 0; i < cpos; ++i)
				out_dev(mp, "\b", 1, attr, 1);
			for (i = 0; i < pos; ++i)
				out_dev(mp, " ", 1, attr, 1);
			for (i = 0; i < pos; ++i)
				out_dev(mp, "\b", 1, attr, 1);
			cpos = pos = 0;
			break;
		case 1:	/* Home */
			for (i = 0; i < cpos; ++i)
				out_dev(mp, "\b", 1, attr, 1);
			cpos = 0;
			break;
		case 6:	/* End */
			if (cpos < pos)
			{
				out_dev(mp, (char * )(s + cpos), pos - cpos, attr, 1);
				cpos = pos;
			}
			break;
		case 19:	/* Left */
			if (cpos > 0)
			{
				out_dev(mp, "\b", 1, attr, 1);
				--cpos;
			}
			break;
		case 4:	/* Right */
			if (cpos < pos)
			{
				out_dev(mp, (char *)(s + cpos), 1, attr, 1);
				++cpos;
			}
			break;
		case 8:	/* BS */
			if (cpos > 0)
			{
				--pos;
				--cpos;
				if (pos == cpos)
					out_dev(mp, "\b \b", 3, attr, 1);
				else
				{
					int l = pos - cpos;

					memmove(s + cpos, s + cpos + 1, l);
					s[pos] = ' ';
					out_dev(mp, "\b", 1, attr, 1);
					out_dev(mp, (char *)(s + cpos), l + 1, attr, 1);
					for (i = 0; i <= l; ++i)
						out_dev(mp, "\b", 1, attr, 1);
				}
			}
			break;
		case 7:	/* Del */
			if (cpos < pos)
			{
				--pos;
				{
					int l = pos - cpos;

					memmove(s + cpos, s + cpos + 1, l);
					s[pos] = ' ';
					out_dev(mp, (char *)(s + cpos), l + 1, attr, 1);
					for (i = 0; i <= l; ++i)
						out_dev(mp, "\b", 1, attr, 1);
				}
			}
			break;
		default:
			if (ckey >= 32 && ckey < 256)
			{
				unsigned char b;

				b = ckey;
				if (cpos == pos)
				{
					s[cpos++] = b;
					pos = cpos;
					out_dev(mp, (char *)(&b), 1, attr, 1);
				}
				else
				{
					int l = pos - cpos;

					memmove(s + cpos + 1, s + cpos, l);
					s[cpos] = b;
					out_dev(mp, (char *)(&b), 1, attr, 1);
					out_dev(mp, (char *)(s + cpos + 1), l, attr, 1);
					for (i = 0; i < l; ++i)
						out_dev(mp, "\b", 1, attr, 1);
					++cpos;
					++pos;
				}
			}
			break;
		}
	}

	  ret:
	_clip_retc(mp, (char *)s);

	if (c == 0 || strcmp(mp->history.items[c - 1], (char *)s))
		add_ClipVect(&mp->history, s);
	else
		free(s);

	if (c >= CLIP_MAX_HISTORY)
	{
		free(mp->history.items[0]);
		remove_ClipVect(&mp->history, 0);
	}

	out_dev(mp, "\n", 1, attr, 1);
	sync_mp(mp);

	return 0;
}

static void
wind_region(ClipMachine * mp, int *ptop, int *pleft, int *pbottom, int *pright, int full)
{
	ClipWindow *wp = mp->windows + mp->wnum;

	int ftop = (full == 2 ? wp->rect.top : wp->format.top);
	int fleft = (full == 2 ? wp->rect.left : wp->format.left);

	if (ptop)
		*ptop += ftop;
	if (pleft)
		*pleft += fleft;
	if (pbottom)
		*pbottom += ftop;
	if (pright)
		*pright += fleft;
}

static void
clip_region(ClipMachine * mp, int *ptop, int *pleft, int *pbottom, int *pright, int full, int wnum)
{
	ClipWindow *wp;
	int top = -1024, left = -1024, bottom = 1024, right = 1024;
	int Top, Bottom,Left,Right,ftop,fleft,columns,lines;
	if ( wnum == -1 )
		wp = mp->windows + mp->wnum;
	else
		wp = mp->windows + wnum;

	/*int Top = wp->rect.top; */
	Top = (full ? wp->rect.top : wp->format.top);
	Bottom = (full == 2 ? wp->rect.bottom : wp->format.bottom);
	Left = (full == 2 ? wp->rect.left : wp->format.left);
	Right = (full == 2 ? wp->rect.right : wp->format.right);
	ftop = (full == 2 ? wp->rect.top : wp->format.top);
	fleft = (full == 2 ? wp->rect.left : wp->format.left);
	columns = mp->screen->base->Columns - 1;
	lines = mp->screen->base->Lines - 1;

	if (Bottom > lines)
		Bottom = lines;
	if (Right > columns)
		Right = columns;

	if (ptop)
		top = *ptop;
	if (pleft)
		left = *pleft;
	if (pbottom)
		bottom = *pbottom;
	if (pright)
		right = *pright;

	top += ftop;
	bottom += ftop;
	left += fleft;
	right += fleft;

	if (top < Top)
		top = Top;
	else if (top > Bottom)
		top = Bottom;

	if (bottom < Top)
		bottom = Top;
//      else if (bottom == Top)
	//              bottom = Bottom;
	else if (bottom > Bottom)
		bottom = Bottom;

	if (bottom < top)
		bottom = top;

	if (left < Left)
		left = Left;
	else if (left > Right)
		left = Right;

	if (right < Left)
		right = Left;
/*	else if (right == Left)
		right = Right;*/
	else if (right > Right)
		right = Right;

	if (right < left)
		right = left;

	if (ptop)
		*ptop = top;
	if (pleft)
		*pleft = left;
	if (pbottom)
		*pbottom = bottom;
	if (pright)
		*pright = right;

}

static char *
save_region(ClipMachine * mp, char *mem, int top, int left, int bottom, int right, int *len)
{
	int i, j;
	unsigned char *s, *p;
	Screen *sp = mp->screen;

#ifdef CLIP_DOS_SCRBUF
	i=2;
#else
	i=3;
#endif

	*len = (bottom - top + 1) * (right - left + 1) * i;
	s = (unsigned char *) realloc(mem, *len);

	for (i = top, p = s; i <= bottom; ++i)
		for (j = left; j <= right; ++j)
		{
			*p++ = sp->chars[i][j];
			*p++ = sp->colors[i][j];
#ifndef CLIP_DOS_SCRBUF
			*p++ = sp->attrs[i][j];
#endif
		}
	return (char *)s;
}

static void
rest_region(ClipMachine * mp, int top, int left, int bottom, int right, char *s, int l)
{
	int i, j;
	unsigned char *p, *e;
	Screen *sp = mp->screen;
	int lines = sp->base->Lines;
	int columns = sp->base->Columns;

	for (i = top, p = (unsigned char *)s, e = p + l; i <= bottom; ++i)
	{
		if (i < 0 || i >= lines)
			continue;
		sp->touched[i] = 1;
		for (j = left; j <= right; ++j)
		{
			if (j < 0 || j >= columns)
				continue;
			if (p >= e)
				return;
			sp->chars[i][j] = *p++;
			if (p >= e)
				return;
			sp->colors[i][j] = *p++;
#ifndef CLIP_DOS_SCRBUF
			if (p >= e)
				return;
			sp->attrs[i][j] = *p++;
#endif
		}
	}
}

int
clip_SAVESCREEN(ClipMachine * mp)
{
	int l;
	int top = _clip_parni(mp, 1);
	int left = _clip_parni(mp, 2);
	int bottom = _clip_parni(mp, 3);
	int right = _clip_parni(mp, 4);
	int par = _clip_parinfo(mp, 0);
	int mainscreen = (_clip_parl(mp,5) != 0 ? 0: mp->wnum);
	int modescreen = (_clip_parl(mp,5) == 0 ? 0: 2);
	ClipVar *rp;
	char *s;
	ClipWindow *wp;

	wp = mp->windows + mainscreen;

	_clip_fullscreen(mp);

	if (par < 3 || _clip_parinfo(mp, 3) == UNDEF_t)
		bottom = wp->rect.bottom;
	if (par < 4 || _clip_parinfo(mp, 3) == UNDEF_t)
		right = wp->rect.right;

	clip_region(mp, &top, &left, &bottom, &right, modescreen, mainscreen);

	s = save_region(mp, 0, top, left, bottom, right, &l);

	rp = RETPTR(mp);
	rp->t.type = CHARACTER_t;
	rp->t.flags = F_NONE;
	rp->s.str.buf = s;
	rp->s.str.len = l;

	sync_mp(mp);

	return 0;
}

int
clip_RESTSCREEN(ClipMachine * mp)
{
	int l;
	int top = _clip_parni(mp, 1);
	int left = _clip_parni(mp, 2);
	int bottom = _clip_parni(mp, 3);
	int right = _clip_parni(mp, 4);
	ClipVar *vp = _clip_par(mp, 5);
	char *s;

	if (!vp || vp->t.type != CHARACTER_t)
		return 0;

	_clip_fullscreen(mp);

	if (_clip_parinfo(mp, 1) != NUMERIC_t)
		top = 0;
	if (_clip_parinfo(mp, 2) != NUMERIC_t)
		left = 0;
	if (_clip_parinfo(mp, 3) != NUMERIC_t)
	{
		ClipWindow *wp = mp->windows + mp->wnum;

		bottom = wp->format.bottom - wp->format.top;
	}
	if (_clip_parinfo(mp, 4) != NUMERIC_t)
	{
		ClipWindow *wp = mp->windows + mp->wnum;

		right = wp->format.right - wp->format.left;
	}
	s = vp->s.str.buf;
	l = vp->s.str.len;

	clip_region(mp, &top, &left, &bottom, &right, 0, -1);
	rest_region(mp, top, left, bottom, right, s, l);

	sync_mp(mp);
	return 0;
}

int
clip_SCROLL(ClipMachine * mp)
{
	int i, j;
	int top = _clip_parni(mp, 1);
	int left = _clip_parni(mp, 2);
	int bottom = _clip_parni(mp, 3);
	int right = _clip_parni(mp, 4);
	int vert = _clip_parni(mp, 5);
	int hor = _clip_parni(mp, 6);
	int attr = _clip_colorSelect(mp);
	char fill = *((char *) _clip_fetch_item(mp, HASH_setclearb));
	Screen *sp;
	int fs = mp->fullscreen;

	_clip_fullscreen(mp);
	sp = mp->screen;

	if (_clip_parinfo(mp, 1) != NUMERIC_t)
		top = 0;
	if (_clip_parinfo(mp, 2) != NUMERIC_t)
		left = 0;
	if (_clip_parinfo(mp, 3) != NUMERIC_t)
		bottom = sp->base->Lines - 1;
	if (_clip_parinfo(mp, 4) != NUMERIC_t)
		right = sp->base->Columns - 1;

	clip_region(mp, &top, &left, &bottom, &right, 0, -1);

	if (!vert && !hor)
	{
		if (!fs)
			clear_Screen(mp->screen);

		for (i = top; i <= bottom; ++i)
		{
			sp->touched[i] = 1;
			for (j = left; j <= right; ++j)
			{
				sp->chars[i][j] = fill;
				sp->colors[i][j] = attr;
				sp->attrs[i][j] = 0;
			}
		}

		return 0;
	}

	if (vert)
	{
		char *ls = 0, *rs = 0;
		int ll, rl;

		if ((right - left) < (sp->base->Columns - /* / */ 2))
		{
			for (i = top; i <= bottom; ++i)
				sp->touched[i] = 1;

			if (vert > 0)
			{
				for (i = left; i <= right; ++i)
				{
					for (j = top; j <= bottom - vert; ++j)
					{
						sp->chars[j][i] = sp->chars[j + vert][i];
						sp->colors[j][i] = sp->colors[j + vert][i];
						sp->attrs[j][i] = sp->attrs[j + vert][i];
					}
					if ( vert > bottom )
						vert = bottom;
					for (j = bottom - vert + 1; j <= bottom; ++j)
					{
						sp->chars[j][i] = fill;
						sp->colors[j][i] = attr;
						sp->attrs[j][i] = 0;
					}
				}
			}
			else
			{
				for (i = left; i <= right; ++i)
				{
					for (j = bottom; j >= top - vert; --j)
					{
						sp->chars[j][i] = sp->chars[j + vert][i];
						sp->colors[j][i] = sp->colors[j + vert][i];
						sp->attrs[j][i] = sp->attrs[j + vert][i];
					}
					if ( (0-vert) > top )
						vert = 0-top;
					for (j = top - vert - 1; j >= top; --j)
					{
						sp->chars[j][i] = fill;
						sp->colors[j][i] = attr;
						sp->attrs[j][i] = 0;
					}
				}
			}
		}
		else
		{
			if (left > 0)
				ls = save_region(mp, 0, top, 0, bottom, left - 1, &ll);
			if (right < sp->base->Columns - 1)
				rs = save_region(mp, 0, top, right + 1, bottom, sp->base->Columns - 1, &rl);

			scrollw_Screen(sp, top, left, bottom, right, vert, attr);

			if (ls)
				rest_region(mp, top, 0, bottom, left - 1, ls, ll);
			if (rs)
				rest_region(mp, top, right + 1, bottom, sp->base->Columns - 1, rs, rl);
		}
	}

	if (hor > 0)
	{
		for (i = top; i <= bottom; ++i)
		{
			sp->touched[i] = 1;
			for (j = left; j <= right - hor; ++j)
			{
				sp->chars[i][j] = sp->chars[i][j + hor];
				sp->colors[i][j] = sp->colors[i][j + hor];
				sp->attrs[i][j] = sp->attrs[i][j + hor];
			}
			for (j = right - hor + 1; j <= right; ++j)
			{
				sp->chars[i][j] = fill;
				sp->colors[i][j] = attr;
				sp->attrs[i][j] = attr;
			}
		}
	}
	else if (hor < 0)
	{
		for (i = top; i <= bottom; ++i)
		{
			sp->touched[i] = 1;
			for (j = right; j >= left - hor; --j)
			{
				sp->chars[i][j] = sp->chars[i][j + hor];
				sp->colors[i][j] = sp->colors[i][j + hor];
				sp->attrs[i][j] = sp->attrs[i][j + hor];
			}
			for (j = left - hor - 1; j >= left; --j)
			{
				sp->chars[i][j] = fill;
				sp->colors[i][j] = attr;
				sp->attrs[i][j] = 0;
			}
		}
	}

	sync_mp(mp);

	return 0;
}

int
clip_MEMORY(ClipMachine * mp)
{
	_clip_retnl(mp, 0x7fffffffL);
	return 0;
}

int
clip_ALLOFREE(ClipMachine * mp)
{
	_clip_retnl(mp, 0xFFFF);
	return 0;
}

int
clip_STACKFREE(ClipMachine * mp)
{
	_clip_retnl(mp, 0xFFFF);
	return 0;
}

/* ][ window funcs */

typedef struct
{
	ClipAttr attr;
	int cursor;
	ClipRect rect;
	int dr, dc;
	int y, x;
	int l;
}
WindowSave;

static void
save_window(ClipMachine * mp, ClipWindow * wp)
{
	int l;
	char *s;
	WindowSave *ws;
	ClipRect w;
	int lines = mp->screen->base->Lines;
	int columns = mp->screen->base->Columns;

	w = wp->rect;
	if (w.top < 0)
		w.top = 0;
	if (w.bottom < 0)
		return;
	if (w.left < 0)
		w.left = 0;
	if (w.right < 0)
		return;
	if (w.top >= lines)
		return;
	if (w.bottom >= lines)
		w.bottom = lines - 1;
	if (w.left >= columns)
		return;
	if (w.right >= columns)
		w.right = columns - 1;

	s = save_region(mp, wp->save, w.top, w.left, w.bottom, w.right, &l);
	s = (char *) realloc(s, l + sizeof(WindowSave));
	memmove(s + sizeof(WindowSave), s, l);
	ws = (WindowSave *) s;
	ws->attr = mp->attr;
	ws->cursor = mp->cursor;
	ws->rect = w;
	ws->dr = w.top - wp->rect.top;
	ws->dc = w.left - wp->rect.left;
	ws->y = mp->screen->y - wp->rect.top;
	ws->x = mp->screen->x - wp->rect.left;
	ws->l = l;

	wp->save = s;
}

static void
draw_shadow(ClipMachine * mp, ClipWindow * wp)
{
	int lines, columns, nrow, ncol;
	int top, left, bottom, right;
	int i, j, attr;
	Screen *sp;

	if (wp->shadow == -1)
		return;

	sp = mp->screen;
	lines = sp->base->Lines;
	columns = sp->base->Columns;
	attr = wp->shadow;

	nrow = 1;
#if 0
	ncol = (columns - 20) / lines;
	if (ncol < 1)
		ncol = 1;
#else
	ncol = 2;
#endif

	top = wp->rect.top;
	left = wp->rect.left;
	bottom = wp->rect.bottom;
	right = wp->rect.right;

	for (i = top; i <= bottom + nrow; i++)
	{
		if (i < 0 || i >= lines)
			continue;
		sp->touched[i] = 1;
		for (j = left + ncol; j <= right + ncol; j++)
		{
			if (j < 0 || j >= columns)
				continue;
			if ((i >= (top + nrow) && j > right) || (j >= (left + ncol) && i > bottom))
			{
				/*int pg = sp->colors[i][j] & PG_ATTR; */

				sp->colors[i][j] = attr /*| pg */ ;
			}
		}
	}
}

static void
rest_window(ClipMachine * mp, ClipWindow * wp)
{
	int l;
	char *s;
	WindowSave *ws;
	int nr, nc, top, left, y, x;

	if (!(s = wp->save))
		return;

	ws = (WindowSave *) s;
	s += sizeof(WindowSave);
	nr = ws->rect.bottom - ws->rect.top;
	nc = ws->rect.right - ws->rect.left;
	l = ws->l;
	top = wp->rect.top + ws->dr;
	left = wp->rect.left + ws->dc;

	rest_region(mp, top, left, top + nr, left + nc, s, l);

	mp->attr = ws->attr;
	mp->cursor = ws->cursor;
	y = ws->y /*+ wp->rect.top */ ;
	x = ws->x /*+ wp->rect.left */ ;
	clip_region(mp, &y, &x, 0, 0, 2, -1);
	mp->screen->y = y;
	mp->screen->x = x;

	draw_shadow(mp, wp);
}

static void
destroy_window(ClipWindow * wp)
{
	if (wp->save)
		free(wp->save);
}

static int
select_window(ClipMachine * mp, int n)
{
	int no = -1;
	ClipWindow *wp = 0;
	int ono = -1, nno, i;

	for (i = 0; i <= mp->wnum; i++)
	{
		wp = mp->windows + i;
		if (wp->no == n)
		{
			ono = i;
			break;
		}
	}
	if (ono != -1)
	{
		ClipWindow w;

		nno = mp->wnum;

		if ( (mp->windows + nno)->no !=0 )
			save_window(mp, mp->windows + nno);
		if (nno != ono)
		{
			w = mp->windows[ono];
			for (i=ono; i< mp->wnum ; i++)
				mp->windows[i] = mp->windows[i+1];
			mp->windows[mp->wnum] = w;
		}
		if ( n!=0 )
			rest_window(mp, mp->windows + mp->wnum);

		sync_mp(mp);
	}

	return no;
}

static void
calc_center(ClipMachine * mp, ClipWindow * wp, int *top, int *left, int *bottom, int *right)
{
	int sh = mp->screen->base->Lines;
	int sw = mp->screen->base->Columns;
	int h = wp->rect.bottom - wp->rect.top + 1;
	int w = wp->rect.right - wp->rect.left + 1;
	int t, l, b, r;

	t = (sh - h) / 2;
	b = t + h - 1;
	l = (sw - w) / 2;
	r = l + w - 1;

	if (top)
		*top = t;
	if (left)
		*left = l;
	if (bottom)
		*bottom = b;
	if (right)
		*right = r;
}

static void
move_window(ClipMachine * mp, ClipWindow * wp, int top, int left)
{
	int i, dv, dh;

	save_window(mp, mp->windows + mp->wnum);

	dv = top - wp->rect.top;
	dh = left - wp->rect.left;

	wp->rect.top += dv;
	wp->rect.bottom += dv;
	wp->rect.left += dh;
	wp->rect.right += dh;
	wp->format.top += dv;
	wp->format.bottom += dv;
	wp->format.left += dh;
	wp->format.right += dh;

	for (i = 0; i <= mp->wnum; i++)
		rest_window(mp, mp->windows + i);

	sync_mp(mp);
}

static void
adjust_cursor(ClipMachine * mp)
{
	int x, y;
	ClipWindow *wp = mp->windows + mp->wnum;

	x = mp->screen->x;
	y = mp->screen->y;
	if (y < wp->format.top)
		y = wp->format.top;
	if (y > wp->format.bottom)
		y = wp->format.bottom;
	if (x < wp->format.left)
		x = wp->format.left;
	if (x > wp->format.right)
		x = wp->format.right;
	y -= wp->format.top;
	x -= wp->format.left;
	clip_region(mp, &y, &x, 0, 0, 0, -1);

	mp->screen->y = y;
	mp->screen->x = x;
}

/* Closes all windows */
int
clip_WACLOSE(ClipMachine * mp)
{
	int num, i;
	ClipWindow *wp, w;

	_clip_fullscreen(mp);
	num = mp->wnum;

	for (i = 0; i <= num; i++)
	{
		wp = mp->windows + i;
		if (wp->no == 0)
			w = *wp;
		else
			destroy_window(wp);
	}

	mp->windows[0] = w;

	mp->wnum = 0;

	select_window(mp, 0);

	return 0;
}

/*
   Allocates allowable screen area for windows
 */
int
clip_WBOARD(ClipMachine * mp)
{
	int top, left, bottom, right;

	_clip_fullscreen(mp);

	if (_clip_parinfo(mp,0) == 0)
	{
		Screen *sp = mp->screen;
		top = left = 0;
		bottom = sp->base->Lines-1;
		right = sp->base->Columns-1;
	}
	else
	{
		top = _clip_parni(mp, 1);
		left = _clip_parni(mp, 2);
		bottom = _clip_parni(mp, 3);
		right = _clip_parni(mp, 4);
	}

	mp->wboard.top = top;
	mp->wboard.left = left;
	mp->wboard.bottom = bottom;
	mp->wboard.right = right;

	_clip_retni(mp, 0);

	return 0;
}

/*
   Places a frame around the active window
 */
int
clip_WBOXTERM(ClipMachine * mp)
{
	int cl = 0;
	unsigned char *chars = (unsigned char *) _clip_parcl(mp, 1, &cl);
	unsigned char bchars[16];
	int chars_n = _clip_parni(mp, 1);
	ClipRect rect, format;
	ClipWindow *wp = mp->windows + mp->wnum;
	int fill = 1;

	_clip_fullscreen(mp);

	if (mp->argc < 1)
		chars_n = 4;

	mp->colorSelect = 0;

	rect = wp->rect;
	format = wp->format;

	format.top++;
	format.left++;
	format.bottom--;
	format.right--;

	if (format.bottom - format.top < 0 || format.right - format.left < 1)
	{
		_clip_retni(mp, -1);
		return 0;
	}

	if (chars)
	{
		cl = strlen((const char *)chars);
		if (cl >= (int)sizeof(bchars))
			cl = sizeof(bchars) - 1;

		memcpy(bchars, chars, cl);
		if (cl < 9)
			bchars[8] = *((char *) _clip_fetch_item(mp, HASH_setclearb));
		chars = bchars;
	}
	disp_box(mp, 0, 0, wp->format.bottom - wp->format.top, wp->format.right - wp->format.left, chars, cl, chars_n, 0, fill);

	wp->format = format;
	if (fill)
	{
		mp->screen->x = 0;
		mp->screen->y = 0;
	}
	adjust_cursor(mp);

	_clip_retni(mp, mp->wnum);
	return 0;
}

/*
   Returns a window to the visible screen area, or centers it
 */
int
clip_WCENTER(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int lCenter = _clip_parl(mp, 1);
	int top, left;

	_clip_fullscreen(mp);

	_clip_retni(mp, wp->no);

	calc_center(mp, wp, &top, &left, 0, 0);
	if (lCenter)
		move_window(mp, wp, top, left);
	else
		move_window(mp, wp, top, left);

	return 0;
}

/*
   Closes the active window
 */
int
clip_WCLOSE(ClipMachine * mp)
{
	int num,i;
	ClipWindow *wp;

	_clip_fullscreen(mp);

	num = mp->wnum;
	wp = mp->windows + num;

	if (wp->no == 0)
		return 0;

	destroy_window(wp);

	num = --(mp->wnum);
	wp = mp->windows + num;
	if (wp->no == 0 && num>0)
	{
		ClipWindow wp2;
		wp2 = mp->windows[num-1];
		mp->windows[num-1] = mp->windows[num];
		mp->windows[num] = wp2;
	}
	wp = mp->windows + num;

	for (i = 0; i <= mp->wnum; i++)
		if ( (mp->windows + i)->no ==0 )
			rest_window(mp, mp->windows + i);
	for (i = 0; i <= mp->wnum; i++)
		if ( (mp->windows + i)->no !=0 )
			rest_window(mp, mp->windows + i);

	sync_mp(mp);

	return 0;
}

/*
   Returns position of the leftmost column of the active window
 */
int
clip_WCOL(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int lCenter = _clip_parl(mp, 1);
	int r = wp->rect.left;

	_clip_fullscreen(mp);

	if (lCenter)
		calc_center(mp, wp, 0, &r, 0, 0);

	_clip_retni(mp, r);
	return 0;
}

/*
   Returns position of leftmost column of formatted area of window
 */
int
clip_WFCOL(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int lRelative = _clip_parl(mp, 1);
	int r;

	_clip_fullscreen(mp);

	if (lRelative)
		r = wp->format.left - wp->rect.left;
	else
		r = wp->format.left;

	_clip_retni(mp, r);
	return 0;
}

/*
   Returns position of rightmost col of formatted area of a window
 */
int
clip_WFLASTCOL(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int lRelative = _clip_parl(mp, 1);
	int r;

	_clip_fullscreen(mp);

	if (lRelative)
		r = wp->rect.right - wp->format.right;
	else
		r = wp->format.right;

	_clip_retni(mp, r);
	return 0;
}

/*
   Returns position of bottom row of formatted area of a window
 */
int
clip_WFLASTROW(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int lRelative = _clip_parl(mp, 1);
	int r;

	_clip_fullscreen(mp);

	if (lRelative)
		r = wp->rect.bottom - wp->format.bottom;
	else
		r = wp->format.bottom;

	_clip_retni(mp, r);
	return 0;
}

/*
   Determines the usable area within a window
 */
int
clip_WFORMAT(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int dt, dl, db, dr;
	ClipRect format = wp->format;

	_clip_fullscreen(mp);

	_clip_retni(mp, wp->no);
	if (mp->argc < 4)
	{
		wp->format = wp->rect;
		return 0;
	}

	dt = _clip_parni(mp, 1);

	dl = _clip_parni(mp, 2);
	db = _clip_parni(mp, 3);
	dr = _clip_parni(mp, 4);

	format.top += dt;
	format.left += dl;
	format.bottom -= db;
	format.right -= dr;

	if (format.bottom - format.top < 0 || format.right - format.left < 0)
	{
		return 0;
	}

	if (format.top < wp->rect.top)
		format.top = wp->rect.top;
	if (format.left < wp->rect.left)
		format.left = wp->rect.left;
	if (format.bottom > wp->rect.bottom)
		format.bottom = wp->rect.bottom;
	if (format.right > wp->rect.right)
		format.right = wp->rect.right;

	wp->format = format;

	adjust_cursor(mp);

	return 0;
}

/*
   Returns position of top row of the formatted area of a window
 */
int
clip_WFROW(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int lRelative = _clip_parl(mp, 1);
	int r;

	_clip_fullscreen(mp);

	if (lRelative)
		r = wp->format.top - wp->rect.top;
	else
		r = wp->format.top;

	_clip_retni(mp, r);
	return 0;
}

/*
   Returns position of the rightmost column of the active window
 */
int
clip_WLASTCOL(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int lCenter = _clip_parl(mp, 1);
	int r = wp->rect.right;

	_clip_fullscreen(mp);

	if (lCenter)
		calc_center(mp, wp, 0, 0, 0, &r);

	_clip_retni(mp, r);
	return 0;
}

/*
   Returns the position of the bottom row of the active window
 */
int
clip_WLASTROW(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int lCenter = _clip_parl(mp, 1);
	int r = wp->rect.bottom;

	_clip_fullscreen(mp);

	if (lCenter)
		calc_center(mp, wp, 0, 0, &r, 0);

	_clip_retni(mp, r);
	return 0;
}

/*
   Turns the screen border overstep mode on or off
 */
int
clip_WMODE(ClipMachine * mp)
{
	_clip_fullscreen(mp);

	return 0;
}

/*
   Moves a window
 */
int
clip_WMOVE(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int top = _clip_parni(mp, 1);
	int left = _clip_parni(mp, 2);

	_clip_fullscreen(mp);

	_clip_retni(mp, wp->no);

	move_window(mp, wp, top, left);

	return 0;
}

/*
   Determines the highest window handle
 */
int
clip_WNUM(ClipMachine * mp)
{
	_clip_fullscreen(mp);
	_clip_retni(mp, mp->wnum);
	return 0;
}

/*
   Opens a new window
 */
int
clip_WOPEN(ClipMachine * mp)
{
	int top, left, bottom, right;
	int erase;
	int no = -1, i;
	ClipWindow *wp = 0;
	ClipRect wb = mp->wboard;

	_clip_fullscreen(mp);
	if (mp->argc < 4)
		return EG_ARG;

	top = _clip_parni(mp, 1);
	left = _clip_parni(mp, 2);
	bottom = _clip_parni(mp, 3);
	right = _clip_parni(mp, 4);
	erase = _clip_parl(mp, 5);

	{
	top    = top    > wb.top    ? top    : wb.top;
	left   = left   > wb.left   ? left   : wb.left;
	bottom = bottom < wb.bottom ? bottom : wb.bottom;
	right  = right  < wb.right  ? right  : wb.right;
	}

	if (top > bottom || left > right)
		return EG_ARG;

	save_window(mp, mp->windows + mp->wnum);
	mp->wnum++;
	mp->windows = (ClipWindow *) realloc(mp->windows, (mp->wnum + 1) * sizeof(ClipWindow));
	wp = mp->windows + mp->wnum;

	memset(wp, 0, sizeof(ClipWindow));
	for (i = 0, no = 0; i < mp->wnum; i++)
		if (mp->windows[i].no > no)
			no = mp->windows[i].no;
	wp->no = no + 1;
	wp->rect.top = top;
	wp->rect.bottom = bottom;
	wp->rect.left = left;
	wp->rect.right = right;
	wp->format = wp->rect;
	wp->shadow = mp->wshadow;

	//if (mp->wshadow)
	//      erase = 1;

	mp->screen->y = 0;
	mp->screen->x = 0;
	adjust_cursor(mp);

	if (erase)
	{
		int attr = _clip_colorSelect(mp);
		int j;
		char fill = *((char *) _clip_fetch_item(mp, HASH_setclearb));
		Screen *sp = mp->screen;

		bottom -= top;
		top = 0;
		right -= left;
		left = 0;
		clip_region(mp, &top, &left, &bottom, &right, 2, -1);
		for (i = top; i <= bottom; ++i)
		{
			sp->touched[i] = 1;
			for (j = left; j <= right; ++j)
			{
				sp->chars[i][j] = fill;
				sp->colors[i][j] = attr;
				sp->attrs[i][j] = 0;
			}
		}
		draw_shadow(mp, wp);
		sync_mp(mp);
	}

	_clip_retni(mp, wp->no);

	return 0;
}

int
clip_WREOPEN(ClipMachine * mp)
{
	int top, left, bottom, right;
	int erase, i;
	ClipWindow *wp = 0;

	_clip_fullscreen(mp);
	if (mp->argc < 4)
		return EG_ARG;

	top = _clip_parni(mp, 1);
	left = _clip_parni(mp, 2);
	bottom = _clip_parni(mp, 3);
	right = _clip_parni(mp, 4);
	erase = _clip_parl(mp, 5);

	if (top > bottom || left > right)
		return EG_ARG;

	//save_window(mp, mp->windows + mp->wnum);
	wp = mp->windows + mp->wnum;

	wp->rect.top = top;
	wp->rect.bottom = bottom;
	wp->rect.left = left;
	wp->rect.right = right;
	wp->format = wp->rect;

	mp->screen->y = 0;
	mp->screen->x = 0;
	adjust_cursor(mp);

	if (erase)
	{
		int attr = _clip_colorSelect(mp);
		int j;
		char fill = *((char *) _clip_fetch_item(mp, HASH_setclearb));
		Screen *sp = mp->screen;

		bottom -= top;
		top = 0;
		right -= left;
		left = 0;
		clip_region(mp, &top, &left, &bottom, &right, 2, -1);
		for (i = top; i <= bottom; ++i)
		{
			sp->touched[i] = 1;
			for (j = left; j <= right; ++j)
			{
				sp->chars[i][j] = fill;
				sp->colors[i][j] = attr;
				sp->attrs[i][j] = 0;
			}
		}
		draw_shadow(mp, wp);
		sync_mp(mp);
	}

	_clip_retni(mp, wp->no);

	return 0;
}

/*
   Returns the position of the top row of the active window
 */
int
clip_WROW(ClipMachine * mp)
{
	ClipWindow *wp = mp->windows + mp->wnum;
	int lCenter = _clip_parl(mp, 1);
	int r = wp->rect.top;

	_clip_fullscreen(mp);

	if (lCenter)
		calc_center(mp, wp, &r, 0, 0, 0);

	_clip_retni(mp, r);
	return 0;
}

/*
   Activates one of the open windows
 */
int
clip_WSELECT(ClipMachine * mp)
{
	int no;
	int n = _clip_parni(mp, 1);

	_clip_fullscreen(mp);

	no = (mp->windows + mp->wnum)->no;
#if 0
	if (mp->argc > 0 && n != no)
		select_window(mp, n);
	_clip_retni(mp, no);
#else
	if (mp->argc > 0 && n != no)
		select_window(mp, n);
	_clip_retni(mp, (mp->windows + mp->wnum)->no);
#endif
	return 0;
}

/*
   Turns the interactive movement mode on or off
 */
int
clip_WSETMOVE(ClipMachine * mp)
{
	_clip_fullscreen(mp);

	return 0;
}

/*
   Sets the window shadow colors
 */
int
clip_WSETSHADOW(ClipMachine * mp)
{
	char *color = _clip_parc(mp, 1);
	int ncolor = _clip_parni(mp, 1);
	int r = mp->wshadow;

	_clip_fullscreen(mp);

	if (mp->argc > 0)
	{
		if (color)
			mp->wshadow = get_color(mp, color);
		else
			mp->wshadow = ncolor;
	}

	_clip_retni(mp, r);

	return 0;
}

/*
   Determines the step width of interactive window movement
 */
int
clip_WSTEP(ClipMachine * mp)
{
	_clip_fullscreen(mp);

	return 0;
}

/* window funcs ][ */

static void
dialog_init(ClipMachine * mp)
{
	if (!mp->fullscreen)
	{
		static int dialog = 0;

		if (!dialog)
		{
			int r = _clip_init_tty(mp);

			if (!r)
				dialog = 1;
			else
			{
				int l;
				char msg[256];

				snprintf(msg, sizeof(msg), "\nrequest to switch into DIALOG mode failed: %s\n", mp->syserr);
				l = strlen(msg);
				out_log(mp, msg, l, 0);
				out_err(mp, msg, l, 0);
				exit(2);
			}
		}
/*_clip_restore_tty(mp);*/
	}
}

int
clip___BEEP(ClipMachine * mp)
{
	if (mp->fullscreen)
		mp->screen->beeps++;
	else
		fputc('\007', (FILE *) mp->out);

	sync_mp(mp);
	return 0;
}

/*
   screenmix(cCharStr, cAttrStr [, nLine [,nColumn]]) ->Nil
 */
int
clip_SCREENMIX(ClipMachine * mp)
{
	int len, alen;
	unsigned char *str;
	unsigned char *astr;
	int y, x, ey, ex, i, l;
	Screen *sp;
	ClipWindow *wp;

	str = (unsigned char *) _clip_parcl(mp, 1, &len);
	astr = (unsigned char *) _clip_parcl(mp, 2, &alen);

	if (!str || !astr)
		return EG_ARG;

	_clip_fullscreen(mp);

	sp = mp->screen;

	wp = mp->windows + mp->wnum;

	if (mp->argc > 2)
		y = _clip_parnl(mp, 3);
	else
		y = mp->screen->y - wp->format.top;

	if (mp->argc > 3)
		x = _clip_parnl(mp, 4);
	else
		x = mp->screen->x - wp->format.left;

	if (len < alen)
		l = alen;
	else
		l = len;

	ex = x + l;
	ey = y;

	clip_region(mp, &y, &x, &ey, &ex, 1, -1);

	if (y <= ey)
	{
		sp->touched[y] = 1;
		for (i = 0; x <= ex && i <= l; ++i, ++x)
		{
			if (i < len)
				sp->chars[y][x] = str[i];
			if (i < alen)
				sp->colors[y][x] = astr[i];
		}
	}

	sync_mp(mp);

	return 0;
}

/*
	   MPRESENT() --> lIsPresent
*/
int
clip_MPRESENT(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	_clip_retl(mp, sp->mouse_present);

	return 0;
}

/*
	   MHIDE() --> nOldVisibleStatus
	   note: all parameters are ignored
*/
int
clip_MHIDE(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	_clip_retni(mp, sp->mouse_visible);
	sp->mouse_visible = 0;

	return 0;
}

/*
	   MSHOW() --> nOldVisibleStatus
	   note: all parameters are ignored
*/
int
clip_MSHOW(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	_clip_retni(mp, sp->mouse_visible);
	sp->mouse_visible = 1;

	return 0;
}

/*
	   MSETCURSOR( [<lVisible>] ) --> lIsVisible
*/
int
clip_MSETCURSOR(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	_clip_retni(mp, sp->mouse_visible);

	if (mp->argc > 0)
		sp->mouse_visible = _clip_parl(mp, 1);

	return 0;
}

/*
	   MROW() --> nMouseRow
*/
int
clip_MROW(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	_clip_retni(mp, sp->mouse_y);

	return 0;
}

/*
	   MCOL() --> nMouseCol
*/
int
clip_MCOL(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	_clip_retni(mp, sp->mouse_x);

	return 0;
}

/*
	   MLEFTDOWN() --> lIsPressed
*/
int
clip_MLEFTDOWN(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	_clip_retl(mp, (sp->mouse_buttons & MOUSE_BUTTONS_LEFT) ? 1 : 0);

	return 0;
}

/*
	   MRIGHTDOWN() --> lIsPressed
*/
int
clip_MRIGHTDOWN(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	_clip_retl(mp, (sp->mouse_buttons & MOUSE_BUTTONS_RIGHT) ? 1 : 0);

	return 0;
}

/*
	   MMIDDLEDOWN() --> lIsPressed
*/
int
clip_MMIDDLEDOWN(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	_clip_retl(mp, (sp->mouse_buttons & MOUSE_BUTTONS_MIDDLE) ? 1 : 0);

	return 0;
}

/*
	   MSETBOUNDS( [<nTop>], [<nLeft>], [<nBottom>],
				 [<nRight>] ) --> NIL
*/
int
clip_MSETBOUNDS(ClipMachine * mp)
{
	ScreenBase *sp;
	int top, bottom, left, right;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	top = 0;
	bottom = sp->Lines - 1;
	left = 0;
	right = sp->Columns - 1;

	if (_clip_parinfo(mp, 1) == NUMERIC_t)
	{
		top = _clip_parni(mp, 1);
		if (top < 0)
			top = 0;
		if (top >= sp->Lines)
			top = sp->Lines - 1;
	}

	if (_clip_parinfo(mp, 2) == NUMERIC_t)
	{
		left = _clip_parni(mp, 1);
		if (left < 0)
			left = 0;
		if (left >= sp->Columns)
			left = sp->Columns - 1;
	}

	if (_clip_parinfo(mp, 1) == NUMERIC_t)
	{
		bottom = _clip_parni(mp, 1);
		if (bottom < 0)
			bottom = 0;
		if (bottom >= sp->Lines)
			bottom = sp->Lines - 1;
	}

	if (_clip_parinfo(mp, 2) == NUMERIC_t)
	{
		right = _clip_parni(mp, 1);
		if (right < 0)
			right = 0;
		if (right >= sp->Columns)
			right = sp->Columns - 1;
	}

	if (left > right || top > bottom)
		return EG_ARG;

	sp->mouse_top = top;
	sp->mouse_left = left;
	sp->mouse_bottom = bottom;
	sp->mouse_right = right;

	return 0;
}

/*
	   MSAVESTATE() --> cSaveState
*/
int
clip_MSAVESTATE(ClipMachine * mp)
{
	ScreenBase *sp;
	int *save;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	save = (int *) malloc(7 * sizeof(int));

	save[0] = sp->mouse_visible;
	save[1] = sp->mouse_y;
	save[2] = sp->mouse_x;
	save[3] = sp->mouse_top;
	save[4] = sp->mouse_left;
	save[5] = sp->mouse_bottom;
	save[6] = sp->mouse_right;

	_clip_retcn_m(mp, (char *) save, 7 * sizeof(int));

	return 0;
}

/*
	   MRESTSTATE( <cSaveState> ) --> NIL
*/
int
clip_MRESTSTATE(ClipMachine * mp)
{
	ScreenBase *sp;
	int *save;
	char *s;
	int l;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	s = _clip_parcl(mp, 1, &l);
	if (!s || l != (7 * sizeof(int)))
		return EG_ARG;

	save = (int *) s;

	sp->mouse_visible = save[0];
	sp->mouse_y = save[1];
	sp->mouse_x = save[2];
	sp->mouse_top = save[3];
	sp->mouse_left = save[4];
	sp->mouse_bottom = save[5];
	sp->mouse_right = save[6];

	return 0;
}

/*
	   MDBLCLK([<nNewSpeed>]) --> nSpeed
	   note: really not work
*/
int
clip_MDBLCLK(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	_clip_retni(mp, sp->mouse_dclick_speed);

	if (mp->argc > 0)
		sp->mouse_dclick_speed = _clip_parni(mp, 1);

	return 0;
}

/*
	   MSETPOS( <nRow>, <nCol> ) --> NIL
*/
int
clip_MSETPOS(ClipMachine * mp)
{
	ScreenBase *sp;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	sp->mouse_y = _clip_parni(mp, 1);
	sp->mouse_x = _clip_parni(mp, 2);

	return 0;
}

/*
	   MSTATE() --> aState | 0
*/
int
clip_MSTATE(ClipMachine * mp)
{
	ScreenBase *sp;
	long dim;
	ClipVar *rp, var;

	_clip_fullscreen(mp);
	sp = mp->screen->base;

	if (!sp->mouse_present)
	{
		_clip_retni(mp, 0);
		return 0;
	}

	dim = 11;

	rp = RETPTR(mp);
	_clip_array(mp, rp, 1, &dim);

	CLEAR_CLIPVAR(&var);

	/* LLM_STATE_X */
	_clip_var_num(sp->mouse_x, &var);
	dim = 0;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	/* LLM_STATE_Y */
	_clip_var_num(sp->mouse_y, &var);
	dim = 1;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	/* LLM_STATE_ROW */
	_clip_var_num(sp->mouse_y, &var);
	dim = 2;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	/* LLM_STATE_COL */
	_clip_var_num(sp->mouse_x, &var);
	dim = 3;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	/* LLM_STATE_LEFT */
	_clip_var_num( (sp->mouse_buttons & MOUSE_BUTTONS_LEFT) ? 1 : 0, &var);
	dim = 4;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	/* LLM_STATE_RIGHT */
	_clip_var_num( (sp->mouse_buttons & MOUSE_BUTTONS_RIGHT) ? 1 : 0, &var);
	dim = 5;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	/* LLM_STATE_VISIBLE */
	_clip_var_num(sp->mouse_visible, &var);
	dim = 6;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	/* LLM_STATE_DRIVER */
	_clip_var_str(sp->mouse_driver, strlen(sp->mouse_driver), &var);
	dim = 7;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	/* LLM_STATE_SHAPE */
	_clip_var_num(1, &var);
	dim = 8;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	/* LLM_STATE_CLICKS_LEFT */
	_clip_var_num(sp->mouse_clicks_left, &var);
	sp->mouse_clicks_left = 0;
	dim = 9;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	/* LLM_STATE_CLICKS_RIGHT */
	_clip_var_num(sp->mouse_clicks_right, &var);
	sp->mouse_clicks_right = 0;
	dim = 10;
	_clip_aset(mp, rp, &var, 1, &dim);
	_clip_destroy(mp, &var);

	return 0;
}

int
clip_ISCOLOR(ClipMachine * mp)
{
	_clip_fullscreen(mp);
	_clip_retl(mp, iscolor_tty(mp->screen->base));
	return 0;
}

int
clip_CENTER(ClipMachine * mp)
{
	int l1, l2, nl, i;
	unsigned char *ret, *beg, *end, fillchr = ' ';
	unsigned char *str = (unsigned char *)_clip_parcl(mp, 1, &l1);
	int len = _clip_parni(mp, 2);
	unsigned char *s = (unsigned char *)_clip_parcl(mp, 3, &l2);
	int flag = _clip_parl(mp, 4);

	if (str == NULL)
	{
		_clip_retc(mp, "");
		return _clip_trap_err(mp, EG_ARG, 0, 0, __FILE__, __LINE__, "CENTER");
	}
	if (s != NULL)
		fillchr = *s;
	if (_clip_parinfo(mp, 3) == LOGICAL_t)
	{
		flag = _clip_parl(mp, 3);
		s = (unsigned char *)(" ");
	}
	if (len == 0)
	{
		len = 80;
		_clip_fullscreen(mp);
		if (mp->fullscreen)
		{
			ClipWindow *wp = mp->windows + mp->wnum;

			len = wp->format.right - wp->format.left;
		}
	}
	ret = malloc(len + 1);
	for (beg = str; beg < str + l1 && (*beg == ' ' || *beg == '\t'); beg++);
	for (end = str + l1 - 1; end > beg && (*end == ' ' || *end == '\t'); end--);
	end++;
	nl = (len - (end - beg)) / 2;
	for (i = 0; i < nl; i++)
		ret[i] = fillchr;
	for (; beg < end; beg++, i++)
		ret[i] = *beg;
	if (flag)
	{
		for (; i < len; i++)
			ret[i] = fillchr;
	}
	ret[i] = 0;
	_clip_retcn_m(mp, (char *)ret, i);
	return 0;
}

typedef struct
{
	int hi;
	int wi;

	char **chars;
	char **colors;
	char **attrs;
}
WinBuf;

static Coll *winbufs = 0;

static WinBuf *new_WinBuf(int hi, int wi);
static void destroy_WinBuf(void *item);
static WinBuf *find_WinBuf(int no);

/*
   buf = winbuf_create(height,width) - ����������� height x width
	   (����� ��� ����� ���� ���).
*/
int
clip_WINBUF_CREATE(ClipMachine * mp)
{
	int height, width, i;
	WinBuf *wb;

	if (mp->argc < 2)
		return EG_ARG;

	height = _clip_parni(mp, 1);
	width = _clip_parni(mp, 2);

	wb = new_WinBuf(height, width);

	if (!winbufs)
		winbufs = new_Coll(destroy_WinBuf, 0);

	for (i = 0; i < winbufs->count; i++)
	{
		if (!winbufs->items[i])
		{
			winbufs->items[i] = wb;
			break;
		}
	}

	if (i == winbufs->count)
		append_Coll(winbufs, wb);

	_clip_retni(mp, i);

	return 0;
}

int
clip_WINBUF_DESTROY(ClipMachine * mp)
{
	int no;
	WinBuf *wp;

	if (mp->argc < 1)
		return EG_ARG;

	no = _clip_parni(mp, 1);
	wp = find_WinBuf(no);

	if (!wp)
		return EG_ARG;

	destroy_WinBuf(wp);
	winbufs->items[no] = 0;

	return 0;
}

static WinBuf *
new_WinBuf(int hi, int wi)
{
	WinBuf *wb;
	int size, y, x;
	char *mem, *chars, *colors, *attrs;

	size = sizeof(WinBuf) + hi * wi * 3 + sizeof(char *) * hi * 3;
	mem = (char *) calloc(size, 1);
	wb = (WinBuf *) mem;

	wb->hi = hi;
	wb->wi = wi;

	chars = (char *) (mem + sizeof(WinBuf));
	colors = chars + wi * hi;
	attrs = colors + wi * hi;
	wb->chars = (char **) (attrs + wi * hi);
	wb->colors = (char **) (attrs + wi * hi + sizeof(char *) * hi);
	wb->attrs = (char **) (attrs + wi * hi + sizeof(char *) * hi * 2);

	for (y = 0; y < hi; y++)
	{
		wb->chars[y] = chars + wi * y;
		wb->colors[y] = colors + wi * y;
		wb->attrs[y] = attrs + wi * y;

		for (x = 0; x < wi; x++)
		{
			wb->chars[y][x] = ' ';
			wb->colors[y][x] = 7;
			wb->attrs[y][x] = 0;
		}
	}

	return wb;
}

static void
destroy_WinBuf(void *item)
{
	free(item);
}

static WinBuf *
find_WinBuf(int no)
{
	if (!winbufs)
		return 0;

	if (no >= 0 && no < winbufs->count)
	{
		return (WinBuf *) winbufs->items[no];
	}

	return 0;
}

/*
  winbuf_out_at(buf,top,left,str,color) - ������� str ��������  ������top,left ��� color. �������� � ���� ���.
*/
int
clip_WINBUF_OUT_AT(ClipMachine * mp)
{
	int no;
	WinBuf *wp;
	int top, left;
	char *str;
	int slen;
	ClipVar *vp;
	int attr;

	if (mp->argc < 5)
		return EG_ARG;

	no = _clip_parni(mp, 1);
	wp = find_WinBuf(no);

	if (!wp)
		return EG_ARG;

	top = _clip_parni(mp, 2);
	left = _clip_parni(mp, 3);
	str = _clip_parcl(mp, 4, &slen);

	if (!str)
		return EG_ARG;

	vp = _clip_par(mp, 5);
	if (vp)
	{
		if (vp->t.type == NUMERIC_t)
			attr = _clip_parni(mp, 5);
		else
			attr = get_color(mp, _clip_parc(mp, 5));
	}
	else
		attr = _clip_colorSelect(mp);

	if (top >= 0 && top < wp->hi)
	{
		int y = top;
		int x, i;

		for (x = left, i = 0; x < wp->wi && i < slen; i++, x++)
		{
			int ch;

			ch = mp->term_xlat[((unsigned char *) str)[i]];

			if (ch < 32 && !is_pgch(ch))
			{
				wp->chars[y][x] = ch + 64;
				wp->colors[y][x] = attr | 0x8;
				wp->attrs[y][x] = 0;
			}
			else
			{
				wp->chars[y][x] = ch;
				wp->colors[y][x] = attr;
				wp->attrs[y][x] = 0;
			}
		}
	}

	return 0;
}

/*
winbuf_attr_at(buf,top,left,bottom,right,cAttr)
���� �������top,left,bottom,right ����� cAttr ���� buf.
*/

int
clip_WINBUF_ATTR_AT(ClipMachine * mp)
{
	int no;
	WinBuf *wp;
	int top, left, bottom, right;
	ClipVar *vp;
	int attr;
	int y, x;

	if (mp->argc < 5)
		return EG_ARG;

	no = _clip_parni(mp, 1);
	wp = find_WinBuf(no);

	if (!wp)
		return EG_ARG;

	top = _clip_parni(mp, 2);
	left = _clip_parni(mp, 3);
	bottom = _clip_parni(mp, 4);
	right = _clip_parni(mp, 5);

	vp = _clip_par(mp, 6);
	if (vp)
	{
		if (vp->t.type == NUMERIC_t)
			attr = _clip_parni(mp, 6);
		else
			attr = get_color(mp, _clip_parc(mp, 6));
	}
	else
		attr = _clip_colorSelect(mp);

	if (top < 0)
		top = 0;
	if (left < 0)
		left = 0;

	for (y = top; y <= bottom && y < wp->hi; y++)
	{
		for (x = left; x <= right && x < wp->wi; x++)
		{
			wp->colors[y][x] = attr;
		}
	}

	return 0;
}

/*
  winbuf_copy(scr_buf,top1,left1,height1,width1,dest_buf,top2,left2) -
  ����� ������ scr_buf, ������ ������
  top1,left1,height1,width1 �dest_buf � ������top2,left2
*/
int
clip_WINBUF_COPY(ClipMachine * mp)
{
	int no;
	WinBuf *wp, *d_wp;
	int top, left, hi, wi, d_top, d_left;
	int x, y, d_y, d_x;

	if (mp->argc < 6)
		return EG_ARG;

	no = _clip_parni(mp, 1);
	wp = find_WinBuf(no);
	if (!wp)
		return EG_ARG;

	no = _clip_parni(mp, 6);
	d_wp = find_WinBuf(no);
	if (!d_wp)
		return EG_ARG;

	top = _clip_parni(mp, 2);
	left = _clip_parni(mp, 3);

	if (_clip_parinfo(mp, 4) == NUMERIC_t)
		hi = _clip_parni(mp, 4);
	else
		hi = wp->hi;
	if (hi > wp->hi)
		hi = wp->hi;

	if (_clip_parinfo(mp, 5) == NUMERIC_t)
		wi = _clip_parni(mp, 5);
	else
		wi = wp->wi;
	if (wi > wp->wi)
		wi = wp->wi;

	d_top = _clip_parni(mp, 7);
	d_left = _clip_parni(mp, 8);

	for (y = top, d_y = d_top; y < hi && d_y < d_wp->hi; y++, d_y++)
	{
		if (y < 0 || d_y < 0)
				continue;
		for (x = left, d_x = d_left; x < wi && d_x < d_wp->wi; x++, d_x++)
		{
			if (x < 0 || d_x < 0)
				continue;
			d_wp->chars[d_y][d_x] = wp->chars[y][x];
			d_wp->colors[d_y][d_x] = wp->colors[y][x];
			d_wp->attrs[d_y][d_x] = wp->attrs[y][x];
		}
	}

	return 0;
}

/*
  winbuf_display(buf,top,left[,r_top,r_left[,r_height,r_width]]) -
	������ ���buf ������ ������top,left. �� ����	r_top,r_left,r_height,r_width - ������ � buf, ���� ����
	������ ���������. ���� r_top,r_left ����� �top,left
*/

int
clip_WINBUF_DISPLAY(ClipMachine * mp)
{
	int no;
	WinBuf *wp;
	int top, left;
	int r_top, r_left, r_bottom, r_right;
	int d_top, d_left, d_hi, d_wi;
	int x, y, xi, yi;
	Screen *sp;

	if (mp->argc < 3)
		return EG_ARG;

	no = _clip_parni(mp, 1);
	wp = find_WinBuf(no);
	if (!wp)
		return EG_ARG;

	top = _clip_parni(mp, 2);
	left = _clip_parni(mp, 3);

	if (_clip_parinfo(mp, 4) == NUMERIC_t)
		d_top = _clip_parni(mp, 4);
	else
		d_top = 0;
	if (d_top < 0)
		d_top = 0;

	if (_clip_parinfo(mp, 5) == NUMERIC_t)
		d_left = _clip_parni(mp, 5);
	else
		d_left = 0;
	if (d_left < 0)
		d_left = 0;

	if (_clip_parinfo(mp, 6) == NUMERIC_t)
		d_hi = _clip_parni(mp, 6);
	else
		d_hi = wp->hi;
	if (d_hi > wp->hi)
		d_hi = wp->hi;

	if (_clip_parinfo(mp, 7) == NUMERIC_t)
		d_wi = _clip_parni(mp, 7);
	else
		d_wi = wp->wi;
	if (d_wi > wp->wi)
		d_wi = wp->wi;

	_clip_fullscreen(mp);
	sp = mp->screen;

	r_top = top;
	r_left = left;
	r_bottom = r_top + d_hi;
	r_right = r_left + d_wi;

	clip_region(mp, &r_top, &r_left, &r_bottom, &r_right, 0, -1);

	for (y = top, yi = d_top; yi < d_hi; ++y, ++yi)
	{
		if (y < r_top || y > r_bottom)
			continue;
		sp->touched[y] = 1;
		for (x = left, xi = d_left; xi < d_wi; ++x, ++xi)
		{
			if (x < r_left || x > r_right)
				continue;
			sp->chars[y][x] = wp->chars[yi][xi];
			sp->colors[y][x] = wp->colors[yi][xi];
			sp->attrs[y][x] = wp->attrs[yi][xi];
		}
	}

	sync_mp(mp);

	return 0;
}

/*
  winbuf_out_trans(buf,top,left,str,color) - output "transparent" text
  2003/08/21, Mauricio Abre
*/
int
clip_WINBUF_OUT_TRANS(ClipMachine * mp)
{
	int no;
	WinBuf *wp;
	int top, left;
	char *str;
	int slen;
	ClipVar *vp;
	int attr;

	if (mp->argc < 5)
		return EG_ARG;

	no = _clip_parni(mp, 1);
	wp = find_WinBuf(no);

	if (!wp)
		return EG_ARG;

	top = _clip_parni(mp, 2);
	left = _clip_parni(mp, 3);
	str = _clip_parcl(mp, 4, &slen);

	if (!str)
		return EG_ARG;

	vp = _clip_par(mp, 5);
	if (vp)
	{
		if (vp->t.type == NUMERIC_t)
			attr = _clip_parni(mp, 5);
		else
			attr = get_color(mp, _clip_parc(mp, 5));
	}
	else
		attr = _clip_colorSelect(mp);

	if (top >= 0 && top < wp->hi)
	{
		int y = top;
		int x, i;

		for (x = left, i = 0; x < wp->wi && i < slen; i++, x++)
		{
			int ch;

			ch = mp->term_xlat[((unsigned char *) str)[i]];

			if (ch < 32 && !is_pgch(ch))
			{
				wp->chars[y][x] = ch + 64;
				wp->colors[y][x] = attr | 0x8;
				wp->attrs[y][x] = 0;
			}
			else
			{
				wp->chars[y][x] = ch;
				wp->colors[y][x] = (wp->colors[y][x] & 0xf0) | (attr & 0x0f);
				wp->attrs[y][x] = 0;
			}
		}
	}

	return 0;
}

int
clip_GETMEMBUF(ClipMachine *mp)
{
	ClipVar *rp = RETPTR(mp);

	if(mp->pbuf)
		_clip_var_str(mp->pbuf->buf,mp->pbuf->ptr - mp->pbuf->buf,rp);
	return 0;
}

int
clip_SCREENCHAR(ClipMachine *mp)
{
	int top  = _clip_parni(mp,1);
	int left = _clip_parni(mp,2);
	Screen *sp = mp->screen;
	char* r = calloc(1,2);

	if((_clip_parinfo(mp,1) != NUMERIC_t) || (top < 0) || (top >= sp->base->Lines))
		top = sp->y;
	if((_clip_parinfo(mp,2) != NUMERIC_t) || (left < 0) || (left >= sp->base->Columns))
		left = sp->x;

	r[0] = sp->chars[top][left];
	_clip_retcn_m(mp,r,1);
	return 0;
}

int
clip_SCREENATTR(ClipMachine *mp)
{
	int top  = _clip_parni(mp,1);
	int left = _clip_parni(mp,2);
	Screen *sp = mp->screen;
	int r;

	_clip_retni(mp,0);
	if (!mp->fullscreen)
		return 0;

	if((_clip_parinfo(mp,1) != NUMERIC_t) || (top < 0) || (top >= sp->base->Lines))
		top = sp->y;
	if((_clip_parinfo(mp,2) != NUMERIC_t) || (left < 0) || (left >= sp->base->Columns))
		left = sp->x;

	r = (int)sp->colors[top][left];
	_clip_retni(mp,r);
	return 0;
}

int
clip_SCREENSTR(ClipMachine *mp)
{
	int top  = _clip_parni(mp,1);
	int left = _clip_parni(mp,2);
	int l = _clip_parni(mp,3);
	Screen *sp = mp->screen;
	char *r,*p;
	int i,b;

#ifdef CLIP_DOS_SCRBUF
	b=2;
#else
	b=3;
#endif

	if((_clip_parinfo(mp,1) != NUMERIC_t) || (top < 0) || (top >= sp->base->Lines))
		top = sp->y;
	if((_clip_parinfo(mp,2) != NUMERIC_t) || (left < 0) || (left >= sp->base->Columns))
		left = sp->x;
	if((_clip_parinfo(mp,3) != NUMERIC_t) || (l < 1) || (left+l > sp->base->Columns))
		l = sp->base->Columns - left;

	r = calloc(1,l*b+1);

	for (i = 0,p = r; i < l; i++)
	{
		*p++ = sp->chars[top][left+i];
		*p++ = sp->colors[top][left+i];
#ifndef CLIP_DOS_SCRBUF
		*p++ = sp->attrs[top][left+i];
#endif
	}
	_clip_retcn_m(mp,r,l*b);
	return 0;
}

int
clip_SCREENSTRING(ClipMachine *mp)
{
	int top  = _clip_parni(mp,1);
	int left = _clip_parni(mp,2);
	int l = _clip_parni(mp,3);
	Screen *sp = mp->screen;
	char* r;

	if((_clip_parinfo(mp,1) != NUMERIC_t) || (top < 0) || (top >= sp->base->Lines))
		top = sp->y;
	if((_clip_parinfo(mp,2) != NUMERIC_t) || (left < 0) || (left >= sp->base->Columns))
		left = sp->x;
	if((_clip_parinfo(mp,3) != NUMERIC_t) || (l < 1) || (left+l > sp->base->Columns))
		l = sp->base->Columns - left;

	r = calloc(1,l+1);
	memcpy(r,sp->chars[top]+left,l);
	_clip_retcn_m(mp,r,l);
	return 0;
}
