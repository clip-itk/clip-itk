/*
 * DBC - Database Control Utility
 * Main file
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
*+
*+    Source Module => D:\MYAPPS\SOURCE\MYDBU\DBC.PRG
*+
*+    Functions: Function Main()
*+               Function Fiopen()
*+               Static Function OpenError()
*+               Function FiClose()
*+               Function NEXTAREA()
*+               Function PREVAREA()
*+               Function Wrkdoc()
*+               Function DbflUsr()
*+               Function Fmenu()
*+               Function Fpgm1()
*+               Function Fpgm2()
*+               Function Fpgm3()
*+               Function Fpgm4()
*+               Function Fpgm5()
*+               Function Fpgm6()
*+               Function Fpgm7()
*+               Function Fpgm8()
*+               Function Fpgm9()
*+               Function FileLock()
*+               Function FileMan()
*+               Static Function DriveChoose()
*+               Function Userfi()
*+               Function DateMan()
*+               Function NewIndex()
*+               Function EditRec()
*+               Static Function Calc_exp()
*+               Function MsgGet()
*+               Function MsgYesNo()
*+               Function MsgInf()
*+               Procedure SHADOW()
*+               Function Deshf()
*+               Function FilePath()
*+               Function CutPath()
*+               Function Selarea()
*+               Function CmpMsk()
*+               Function OutCtrls()
*+               Function Stufmy()
*+
*+       Tables: DBUSEAREA(,, fname, alsname,, prrdonly )
*+               DBUSEAREA(,, fname, CutExten( IIF( alsname = Nil, fname, alsname ) ),, prrdonly )
*+               USE
*+               USE &fname EXCLUSIVE
*+               USE &fname SHARED
*+
*+    Reformatted by Click! 2.00 on Jul-2-2001 at  8:14 pm
*+
*+▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

#ifdef RDD_AX
#ifdef __HARBOUR__
#include "ads.ch"
#define __HARBOUR_AX__
#else
#include "axntxcdx.ch"
#endif
#endif
#include "deflist.ch"
#include "inkey.ch"
#include "error.ch"

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Main()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Main( fname1 )

PUBLIC slkeys := { - 1, - 2, - 3, - 4, - 5, - 6, - 7, - 8, - 9, 9, 22, 402, 385, 307, 308, 280, 281, 287, 289, 290, 7, 274, 418, 419, 294, 305 }
PUBLIC MSANIM[ 7 ]
   // Private Regkey:="!x~22_;/V~`@*"
PUBLIC msfile[ 15 ], msmode[ 15, 3 ], msmsli[ 15 ], msexp[ 15 ], lenmsf := 0, improc := 0, mypath := ""
PUBLIC mode43   := .F., modesplit := .F., dformat := "dd/mm/yy", memownd := .F., prrdonly := .F.
PUBLIC lWinChar := .F.
#ifdef RDD_AX
#ifdef __HARBOUR__
PUBLIC nServerType := ADS_LOCAL_SERVER
PUBLIC msdriv := { "ADS_CDX", "ADS_NTX","ADS_ADT" }, numdriv := 1
#else
PUBLIC msdriv := { "DBFCDXAX", "DBFNTXAX" }, numdriv := 1
#endif
#else
PUBLIC msdriv := { "DBFCDX", "DBFNTX" }, numdriv := 1
#endif
PUBLIC ORAMKA   := "┌─┐│┘─└│ ", DRAMKA := "╔═╗║╝═╚║ ", klrecf := 200
PUBLIC txtinf   := ""
PRIVATE que_simpl := .T.
PUBLIC aMMenu[ 4 ]
   aMMenu[ 1 ] := aMMenu[ 3 ] := "+GR/B,N/BG,,,N/B"
   aMMenu[ 4 ] := { { " F2 ",, 0, 3 }, { " F3 ",, 0, 12 }, { " F4 ",, 0, 21 }, { " F5 ",, 0, 29 }, ;
		    { " F6 ",, 0, 37 }, { " F7 ",, 0, 47 }, { " F8 ",, 0, 56 }, { " F9 ",, 0, 65 }, { " F10",, 0, 73 } }
#ifdef ENGLISH
   aMMenu[ 2 ] = { { " File ",, 1, 2 }, { " Index  ",, 1, 10 }, { " Fields ",, 1, 19 }, ;
		   { " Move ",, 1, 28 }, { " Commands ",, 1, 35 }, { " View ",, 1, 46 }, { " Query  ",, 1, 55 }, ;
		   { " Others ",, 1, 63 }, { " Exit ",, 1, 73 } }
PRIVATE stra1 := "Xbase files control"
PRIVATE stra3 := "(C)1998,2001 Alexander Kresin"
PRIVATE stra4 := "Belgorod, Russia"
#else
   aMMenu[ 2 ] = { { " Файл ",, 1, 2 }, { " Индекс ",, 1, 10 }, { " Поля ",, 1, 20 }, ;
		   { " Движение ",, 1, 26 }, { " Команды",, 1, 36 }, { " View ",, 1, 46 }, { " Запрос ",, 1, 55 }, ;
		   { " Другое ",, 1, 63 }, { " Выход",, 1, 72 } }
PRIVATE stra1 := "Управление xbase файлами"
PRIVATE stra3 := "(C)1998,2001 Александр Кресин"
PRIVATE stra4 := "alex@belacy.belgorod.su"
   // PRIVATE stra5:="",stra6:=""
#endif
#ifdef ENGLISH
#ifdef __HARBOUR__
#ifdef RDD_AX
PRIVATE stra2 := "Version 3.1b ( Harbour+ADS )"
#else
PRIVATE stra2 := "Version 3.1b ( Harbour )"
#endif
#else
#ifdef RDD_AX
PRIVATE stra2 := "Version 3.1b ( ADS )"
#else
PRIVATE stra2 := "Version 3.1b"
#endif
#endif
#else
#ifdef __HARBOUR__
#ifdef RDD_AX
PRIVATE stra2 := "Версия 3.1b ( Harbour+ADS )"
#else
PRIVATE stra2 := "Версия 3.1b ( Harbour )"
#endif
#else
#ifdef RDD_AX
PRIVATE stra2 := "Версия 3.1b ( ADS )"
#else
PRIVATE stra2 := "Версия 3.1b"
#endif
#endif
#endif
   SET EXCLUSIVE ON
   SET EPOCH TO 1960
#ifdef __CLIP__
   set autopen off
   set translate path off
#endif

   // #ifdef ENGLISH
   // PRIVATE Regname:=Regkey
   IF FILE( "dbc.ini" )
      RDINI( "dbc.ini" )
#ifndef __NOEXTRA__
   ELSE
      RDINI( FilePath( exe_path() ) + "dbc.ini" )
#endif
   ENDIF
   // #endif
#ifdef RDD_AX
#ifdef __HARBOUR__
   // REQUEST _ADS
   // rddRegister( "ADS", 1 )
   // RDDSETDEFAULT( "ADS" )
   IF nServerType == ADS_REMOTE_SERVER
      mypath := "\" + CURDIR() + IIF( EMPTY( CURDIR() ), "", "\" )
      IF !AdsConnect( mypath )
	  nServerType := ADS_LOCAL_SERVER
	  Alert( "Can't establish connection" )
	  mypath := ""
      ENDIF
   ENDIF
   AdsSetServerType( nServerType )
   AdsRightsCheck( .F. )
   // SET CHARTYPE TO OEM
#else
   SET AXS LOCKING ON
#endif
#endif
#ifdef RDD_AX
#ifdef __HARBOUR__
   AdsSetFileType( Iif( numdriv==1,2,Iif( numdriv==2,1,3 ) ) )
#else
   RDDSETDEFAULT( msdriv[ numdriv ] )
#endif
#else
   REQUEST DBFNTX
   REQUEST DBFCDX
   RDDSETDEFAULT( msdriv[ numdriv ] )
#endif
   SET DATE FORMAT dformat
   SET WRAP ON
   SET SCORE OFF
   // #ifdef ENGLISH
   //  Regkey=PPAROL(Regname,Regkey)
   // #else
   // Regkey="11"
   // #endif
   SET COLOR TO N/B
   @  0,  0 CLEAR TO 24, 79
   SET COLOR TO N/W,W+/RB
   /*
#ifdef ENGLISH
 IF Regkey="!!"
  FREGI()
 ENDIF
 stra5:=IIF(Regkey="!!","UNREGISTERED VERSION","    REGISTERED TO")
 stra6:=IIF(Regkey="!!","",Regname)
#endif
*/
   @  2,  0 CLEAR TO 2, 79
   OutCtrls( aMMenu )
   Wrkdoc( fname1 )
RETURN

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fiopen()
*+
*+    Called from ( dbc.prg      )   2 - function wrkdoc()
*+                                   2 - function fpgm1()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fiopen( fname, alsname, prend )

LOCAL i, oldimp := improc, res := .T.
#ifdef ENGLISH
LOCAL strerr := "Can't open file " + Iif( fname != Nil, fname, Alias() )
#else
LOCAL strerr := "Не удалось открыть файл " + Iif( fname != Nil, fname, Alias() )
#endif
LOCAL bOldError, oError
   IF fname != Nil
      prend := IIF( prend = Nil, .F., prend )
      IF prend
	 improc := lenmsf + 1
      ELSE
	 FOR i := 1 TO 15
	    IF msfile[ i ] = Nil
	       improc := i
	       EXIT
	    ENDIF
	 NEXT
      ENDIF
      IF improc > 15
	 improc := oldimp
#ifdef ENGLISH
	 MsgSay( "Too many opened files!" )
#else
	 MsgSay( "Слишком много открытых файлов!" )
#endif
	 RETURN .F.
      ENDIF
      SELECT( improc )
      alsname := IIF( alsname = Nil, CutExten( CutPath( fname ) ), Trim( CutExten( CutPath( alsname ) ) ) )
      IF ( i := AT( '~', alsname ) ) <> 0
	 alsname := Stufmy( alsname, i, 1, '_' )
      ENDIF
      bOldError := ERRORBLOCK( { | e | OpenError( e ) } )
      DO WHILE .T.
	 BEGIN SEQUENCE
	    DBUSEAREA(,, fname, alsname,, prrdonly )
	 RECOVER USING oError
	    IF oError:genCode == EG_BADALIAS .OR. oError:genCode == EG_DUPALIAS
	       IF EMPTY( alsname := MsgGet( "Bad alias name, input other:", "XXXXXXXX", alsname ) )
		  res := .F.
	       ELSE
		  LOOP
	       ENDIF
	    ELSE
	       EVAL( bOldError, oError )
	    ENDIF
	 END SEQUENCE
	 EXIT
      ENDDO
      ERRORBLOCK( bOldError )
      IF !res
	 improc := oldimp
	 RETURN .F.
      ENDIF
      IF NETERR()
	 IF SET( _SET_EXCLUSIVE )
	    SET( _SET_EXCLUSIVE, .F. )
	    DBUSEAREA(,, fname, CutExten( IIF( alsname = Nil, fname, alsname ) ),, prrdonly )
	    IF NETERR()
	       MsgSay( strerr )
	       improc := oldimp
	       RETURN .F.
	    ENDIF
	 ELSE
	    MsgSay( strerr )
	    improc := oldimp
	    RETURN .F.
	 ENDIF
      ENDIF
   ENDIF
   IF improc > lenmsf
      lenmsf := improc
   ENDIF
   msfile[ improc ] := Iif( fname != Nil, UPPER( fname ), Alias() )
   msmode[ improc, 1 ] = SET( _SET_EXCLUSIVE )
   msmode[ improc, 2 ] = prrdonly
   msmode[ improc, 3 ] = numdriv
   msmsli[ improc ] := InitList()
RETURN .T.

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Static Function OpenError()
*+
*+    Called from ( dbc.prg      )   1 - function fiopen()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
STATIC FUNCTION OpenError( e )

   BREAK e
RETURN

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function FiClose()
*+
*+    Called from ( dbc.prg      )   1 - function fpgm1()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION FiClose

LOCAL i
   IF improc > 0
      SELECT( improc )
      USE
      msfile[ improc ] = Nil
      IF improc = lenmsf
	 FOR i := lenmsf - 1 TO 1 STEP - 1
	    IF msfile[ i ] <> Nil
	       EXIT
	    ENDIF
	 NEXT
	 lenmsf := i
      ENDIF
      FOR i := 1 TO lenmsf
	 IF msfile[ i ] <> Nil
	    EXIT
	 ENDIF
      NEXT
      improc := IIF( i <= lenmsf, i, 0 )
      prkorf := .T.
   ENDIF
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function NEXTAREA()
*+
*+    Called from ( dbc.prg      )   1 - function wrkdoc()
*+                                   1 - function fpgm1()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION NEXTAREA

LOCAL i
   FOR i := improc + 1 TO lenmsf
      IF msfile[ i ] <> Nil
	 improc := i
	 prkorf := .T.
	 EXIT
      ENDIF
   NEXT
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function PREVAREA()
*+
*+    Called from ( dbc.prg      )   1 - function wrkdoc()
*+                                   1 - function fpgm1()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION PREVAREA

LOCAL i
   FOR i := improc - 1 TO 1 STEP - 1
      IF msfile[ i ] <> Nil
	 improc := i
	 prkorf := .T.
	 EXIT
      ENDIF
   NEXT
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Wrkdoc()
*+
*+    Called from ( dbc.prg      )   1 - function main()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Wrkdoc( fname )

LOCAL rez      := .T., vybkey, bl0, y1, nstr1 := 1, nstr2 := 1, i, klcolumn, prlimsf
MEMVAR x1, x2, y2, _y2
PRIVATE prkorf := .T., prkorst, dbfi_f := 1, dbnumf := 1, prfi, prmemo, _y2
PRIVATE impr1, impr2, wndfirst, cdata := "", prmsf := .F.
PRIVATE mslist
   prkorst := !EMPTY( fname )
   IF .NOT. EMPTY( fname )
      IF UPPER( FilExten( fname ) ) = "VEW"
	 RdView( fname )
      ELSE
	 Fiopen( fname )
      ENDIF
   ENDIF
#ifdef ENGLISH
   bl0 := { | mslist | DEVPOS( _y2, LI_X1 + 2 ), DEVOUT( IIF( LI_PRFLT, STR( LI_TEKZP, 6 ), STR( RECNO(), 6 ) ) + ;
	    "/" + STR( LI_KOLZ, 6 ) + IIF( LI_PRFLT, " Filter: " + DBFILTER(), "" ) ), DbflUsr( mslist ) }
#else
   bl0 := { | mslist | DEVPOS( _y2, LI_X1 + 2 ), DEVOUT( IIF( LI_PRFLT, STR( LI_TEKZP, 6 ), STR( RECNO(), 6 ) ) + ;
	    "/" + STR( LI_KOLZ, 6 ) + IIF( LI_PRFLT, " Фильтр: " + DBFILTER(), "" ) ), DbflUsr( mslist ) }
#endif
   DO WHILE rez
      prfi := .T.
      IF improc > 0
	 IF prkorf
	    mslist   := msmsli[ improc ]
	    LI_B1    := bl0
	    IF modesplit
	       LI_NSTR := IIF( wndfirst, nstr1, nstr2 )
	    ENDIF
	    SELECT( improc )
	    IF prkorst .OR. LI_NAMES == Nil
	       LI_NAMES = ARRAY( FCOUNT() )
	       AFIELDS( LI_NAMES )
	       prkorst := .F.
	    ENDIF
	    prkorf   := .F.
	    LI_MSED  := IIF( msmode[ improc, 2 ], 1, 3 )
	    LI_LADD  := !msmode[ improc, 2 ]
	    IF prkorst
	       LI_MSF := Nil
	    ENDIF
	 ENDIF
	 // Определяем наличие мемо поля
	 prmemo := 0
	 IF memownd
	    klcolumn := FCOUNT()
	    IF VALTYPE( LI_MSF ) == "A"
	       prlimsf  := .T.
	       klcolumn := LEN( LI_MSF )
	    ELSE
	       prlimsf := .F.
	    ENDIF
	    FOR i := 1 TO klcolumn
	       IF prlimsf .AND. klcolumn >= i
		  IF VALTYPE( LI_MSF[ i ] ) == "C"
		     prmemo := FIELDPOS( LI_MSF[ i ] )
		     EXIT
		  ELSEIF VALTYPE( LI_MSF[ i ] ) = "N" .AND. LI_MSF[ i ] <> 1 .AND. VALTYPE( &( FIELD( i ) ) ) = "M"
		     prmemo := i
		     EXIT
		  ENDIF
	       ELSEIF FieldType( i ) == "M"
		  prmemo := i
		  EXIT
	       ENDIF
	    NEXT
	 ENDIF
	 IF lWinChar
	    LI_BDESHIN  := { | stroka | WinToDos( stroka ) }
	    LI_BDESHOUT := { | stroka | DosToWin( stroka ) }
	 ELSE
	    LI_BDESHIN  := Nil
	    LI_BDESHOUT := Nil
	 ENDIF
	 //
	 y1  := IIF( modesplit .AND. .NOT. wndfirst, IIF( mode43, 22, 14 ), 3 )
	 _y2 := IIF( modesplit .AND. wndfirst, IIF( mode43, 21, 13 ), IIF( mode43, 42, 24 ) )
	 IF prmemo > 0
	    _y2 -= 4
	    @ _y2,  0, _y2 + 4, 79 BOX ORAMKA
	 ENDIF
	 MsgInf()
	 IF .NOT. EMPTY( cdata )
	    KEYBOARD cdata
	    cdata := ""
	 ENDIF
	 LI_LSOHR := .F.
	 vybkey   := dbflist( mslist, 0, y1, 79, _y2, IIF( msmode[ improc, 1 ], "(Exclusive)  ", "(Shared)  " ) + msfile[ improc ] + "  Order: " + IIF( INDEXORD() = 0, "None", ORDSETFOCUS() ) + IIF( msmode[ improc, 2 ], ", (ReadOnly)", "" ), slkeys, aMMenu )
      ELSE
	 y1  := IIF( modesplit .AND. .NOT. wndfirst, IIF( mode43, 22, 14 ), 3 )
	 _y2 := IIF( modesplit .AND. wndfirst, IIF( mode43, 21, 13 ), IIF( mode43, 42, 24 ) )
	 SET COLOR TO W+/B
	 @ y1,  0, _y2, 79 BOX ORAMKA
#ifdef VER_MOUSE
	 vybkey := IN_KM()
#else
	 vybkey := INKEY( 0 )
#endif
	 IF vybkey = 27 .OR. vybkey = 502
	    vybkey := 0
#ifdef VER_MOUSE
	 ELSEIF vybkey = 501
	    SETCOLOR( aMMenu[ 1 ] )
	    vybkey := F_CTRL( aMMenu[ 2 ],,,,,, 1, M_YTEXT(), M_XTEXT() )
	    IF vybkey = 0
	       vybkey := F_CTRL( aMMenu[ 4 ],,,,,, 1, M_YTEXT(), M_XTEXT() )
	    ENDIF
	    vybkey += 500
#endif
	 ENDIF
      ENDIF
      DO CASE
      CASE vybkey = 0
	 vybkey := 9
	 Fmenu( vybkey )
	 OutCtrls( aMMenu )
      CASE ( vybkey < 0 .AND. vybkey > - 10 ) .OR. vybkey > 500
	 vybkey := IIF( vybkey > 500, vybkey - 500, ABS( vybkey ) )
	 Fmenu( vybkey )
	 OutCtrls( aMMenu )
      CASE vybkey = 7
	 IF .NOT. SET( _SET_EXCLUSIVE )
	    RLOCK()
	 ENDIF
	 IF DELETED()
	    RECALL
	 ELSE
	    DELETE
	 ENDIF
	 IF .NOT. SET( _SET_EXCLUSIVE )
	    UNLOCK
	 ENDIF
      CASE vybkey = 281                 // Alt-P
	 Pech()
      CASE vybkey = 385                 // Alt-0
	 Selarea()
      CASE vybkey = 307
	 PREVAREA()
      CASE vybkey = 308
	 NEXTAREA()
      CASE vybkey = 280
	 fname := FileMan( "*.dbf",, .T. )
	 IF .NOT. EMPTY( fname )
	    IF Fiopen( mypath + IIF( VALTYPE( fname ) == "C", fname, fname[ 1 ] ), ;
		       IIF( VALTYPE( fname ) == "C", Nil, fname[ 2 ] ) )
	       prkorf  := .T.
	       prkorst := .T.
	    ENDIF
	 ENDIF
      CASE vybkey = 274
	 EditRec()
      CASE vybkey = 418
	 InsFiel( dbfi_f + dbnumf - 1 )
      CASE vybkey = 419
	 DelFiel( dbfi_f + dbnumf - 1 )
      CASE vybkey = 294
	 F_LOCATE()
      CASE vybkey = 305
	 F_CONTIN()
      CASE vybkey = 287
	 F_SEEK()
      CASE vybkey = 289
	 F_FILTER()
      CASE vybkey = 290
	 F_GO()
      CASE vybkey = 9 .AND. modesplit
	 IF wndfirst
	    impr1 := improc
	    nstr1 := LI_NSTR
	 ELSE
	    impr2 := improc
	    nstr2 := LI_NSTR
	 ENDIF
	 wndfirst := .NOT. wndfirst
	 improc   := IIF( wndfirst, impr1, impr2 )
	 prkorf   := .T.
#ifndef __NOEXTRA__
      CASE vybkey = 402
	 IF IS_CLIPBRD()
	    SEND_CLIPB( DosToWin( RTRIM( LTRIM( FLDSTR( dbfi_f + dbnumf - 1 ) ) ) ) )
	 ENDIF
      CASE vybkey = 22 .AND. FT_SHIFT()
	 IF IS_CLIPBRD()
	    GET_CLIPB( @cdata )
	    WinToDos( @cdata )
	 ENDIF
#endif
      ENDCASE
   ENDDO
RETURN

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function DbflUsr()
*+
*+    Called from ( dbc.prg      )   2 - function wrkdoc()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION DbflUsr( mslist )

LOCAL v1
   IF prfi
      v1        := LI_NLEFT
      LI_NLEFT  := dbfi_f
      LI_COLPOS := dbnumf
      IF LI_NLEFT == 1
	 LI_NLEFT := LI_FREEZE + 1
      ENDIF
      IF v1 <> LI_NLEFT
	 LI_NCOLUMNS := FLDCOUNT( mslist, LI_X1 + 2, LI_X2 - 2, LI_NLEFT )
	 VIVNAMES( mslist )
	 WNDVIVOD( mslist )
      ENDIF
      prfi := .F.
   ELSE
      dbfi_f := LI_NLEFT
      dbnumf := LI_COLPOS
   ENDIF
   IF prmemo > 0
      KEYBOARD CHR( 27 )
      MEMOEDIT( FIELDGET( prmemo ), _y2 + 1, 1, _y2 + 2, 78, .F. )
   ENDIF
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fmenu()
*+
*+    Called from ( dbc.prg      )   2 - function wrkdoc()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fmenu( nkey )

LOCAL bufscr, i, ym, xm
PRIVATE mchoic, ScrClr := .F.
   KEYBOARD CHR( 13 )
   mchoic := nkey
   DO WHILE .T.
      SET COLOR TO +GR/B,N/BG,,,N/B
      mchoic := MainMenu(,,,, aMMenu[ 2 ],,, mchoic )
      bufscr := SAVESCREEN( 0, 0, 24, 79 )
      DO CASE
      CASE mchoic = 0
	 mchoic := 9
      CASE mchoic = 1
	 i := Fpgm1()
      CASE mchoic = 2
	 i := Fpgm2()
      CASE mchoic = 3
	 i := Fpgm3()
      CASE mchoic = 4
	 i := Fpgm4()
      CASE mchoic = 5
	 i := Fpgm5()
      CASE mchoic = 6
	 i := Fpgm6()
      CASE mchoic = 7
	 i := Fpgm7()
      CASE mchoic = 8
	 i := Fpgm8()
      CASE mchoic = 9
	 i := Fpgm9()
      ENDCASE
      RESTSCREEN( 0, 0, 24, 79, bufscr )
      IF ScrClr
	 @  3,  0, IIF( mode43, 42, 24 ), 79 BOX ORAMKA
	 ScrClr := .F.
      ENDIF
#ifdef VER_MOUSE
      IF i = 501
	 ym     := M_YTEXT()
	 xm     := M_XTEXT()
	 mchoic := F_CTRL( aMMenu[ 2 ],,,,,, 1, ym, xm )
	 IF mchoic = 0
	    mchoic := F_CTRL( aMMenu[ 4 ],,,,,, 1, ym, xm )
	 ENDIF
	 IF mchoic > 0
	    KEYBOARD CHR( 13 )
	 ELSE
	    EXIT
	 ENDIF
      ELSEIF NEXTKEY() = 0
	 EXIT
      ENDIF
#else
      IF NEXTKEY() = 0
	 EXIT
      ENDIF
#endif
   ENDDO
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fpgm1()
*+
*+    Called from ( dbc.prg      )   1 - function fmenu()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fpgm1

LOCAL choic := 1, bufscr, fname, i
#ifdef ENGLISH
#ifdef RDD_AX
#ifdef __HARBOUR__
LOCAL submenu := { " 1 NEW", " 2 OPEN       Alt-O", " 3 CLOSE", " 4 PRINT      Alt-P", "─", ;
		      " 5SELECT AREA Alt-0", " 6 NEXT AREA  Alt->", " 7 PREV.AREA  Alt-<", "─", ;
		      " 8 EXCLUSIVE    ON ", " 9 READONLY     OFF", " 0 AXS LOCK     ON ", " DRIVER: ADS_CDX", " SERVER:    LOCAL" }
#else
LOCAL submenu := { " 1 NEW", " 2 OPEN       Alt-O", " 3 CLOSE", " 4 PRINT      Alt-P", "─", ;
		      " 5SELECT AREA Alt-0", " 6 NEXT AREA  Alt->", " 7 PREV.AREA  Alt-<", "─", ;
		      " 8 EXCLUSIVE    ON ", " 9 READONLY     OFF", " 0 AXS LOCK     ON ", " DRIVER: DBFCDXAX" }
#endif
#else
LOCAL submenu := { " 1 NEW", " 2 OPEN       Alt-O", " 3 CLOSE", " 4 PRINT      Alt-P", "─", ;
		      " 5SELECT AREA Alt-0", " 6 NEXT AREA  Alt->", " 7 PREV.AREA  Alt-<", "─", ;
		      " 8 EXCLUSIVE    ON ", " 9 READONLY     OFF", "   DRIVER: DBFCDX" }
#endif
#else
#ifdef RDD_AX
#ifdef __HARBOUR__
LOCAL submenu := { " 1 НОВЫЙ", " 2 ОТКРЫТЬ    Alt-O", " 3 ЗАКРЫТЬ", " 4 ПЕЧАТЬ     Alt-P", "─", ;
		      " 5 ВЫБОР ОКНА Alt-0", " 6 СЛЕД.ОКНО  Alt->", " 7 ПРЕД.ОКНО  Alt-<", "─", ;
		      " 8 EXCLUSIVE    ON ", " 9 READONLY     OFF", " 0 AXS LOCK     ON ", " DRIVER: ADS_CDX", " СЕРВЕР:ЛОКАЛЬНЫЙ" }
#else
LOCAL submenu := { " 1 НОВЫЙ", " 2 ОТКРЫТЬ    Alt-O", " 3 ЗАКРЫТЬ", " 4 ПЕЧАТЬ     Alt-P", "─", ;
		      " 5 ВЫБОР ОКНА Alt-0", " 6 СЛЕД.ОКНО  Alt->", " 7 ПРЕД.ОКНО  Alt-<", "─", ;
		      " 8 EXCLUSIVE    ON ", " 9 READONLY     OFF", " 0 AXS LOCK     ON ", " DRIVER: ADS_CDX" }
#endif
#else
LOCAL submenu := { " 1 НОВЫЙ", " 2 ОТКРЫТЬ    Alt-O", " 3 ЗАКРЫТЬ", " 4 ПЕЧАТЬ", "─", ;
		      " 5 ВЫБОР ОКНА Alt-0", " 6 СЛЕД.ОКНО  Alt->", " 7 ПРЕД.ОКНО  Alt-<", "─", ;
		      " 8 EXCLUSIVE    ON ", " 9 READONLY     OFF", "   DRIVER: DBFCDX" }
#endif
#endif
LOCAL aDostup := { .T., .T., lenmsf > 0, lenmsf > 0, .T., lenmsf > 0, lenmsf > 0, lenmsf > 0, ;
		      .T., .T., .T., .T., .T., .T. }

   DO WHILE .T.
      submenu[ 10 ] = Stufmy( submenu[ 10 ], 17, 3, IIF( SET( _SET_EXCLUSIVE ), "ON ", "OFF" ) )
      submenu[ 11 ] = Stufmy( submenu[ 11 ], 17, 3, IIF( prrdonly, "ON ", "OFF" ) )
#ifdef RDD_AX
#ifdef __HARBOUR__
#ifdef ENGLISH
      submenu[ 14 ] = Stufmy( submenu[ 14 ], 12, 6, IIF( nServerType == 1, " LOCAL", "REMOTE" ) )
#else
      submenu[ 14 ] = Stufmy( submenu[ 14 ], 9, 9, IIF( nServerType == 1, "ЛОКАЛЬНЫЙ", "УДАЛЕННЫЙ" ) )
#endif
#else
      submenu[ 12 ] = Stufmy( submenu[ 12 ], 17, 3, IIF( AX_AXSLocking(), "ON ", "OFF" ) )
#endif
      submenu[ 13 ] = Stufmy( submenu[ 13 ], 10, LEN( msdriv[ numdriv ] ), msdriv[ numdriv ] )
#else
      submenu[ 12 ] = Stufmy( submenu[ 12 ], 12, LEN( msdriv[ numdriv ] ), msdriv[ numdriv ] )
#endif
      SET COLOR TO +GR/B,N/BG,,,N/B
      @  2,  1, 17, 22 BOX ORAMKA
      choic := MainMenu( 3, 2, 16, 21, submenu, aDostup,, 1, 1 )
      IF choic = 0 .OR. choic = 501
	 RETURN choic
      ENDIF
      bufscr := SAVESCREEN( 0, 0, 24, 79 )
      DO CASE
      CASE choic = 1
	 StruMan( .T. )
      CASE choic = 2
#ifdef __HARBOUR_AX__
	 IF nServerType == 2 .AND. Left( mypath,2 ) == "//"
	    fname := MsgGet( "Input file name:" )
	 ELSE
	    fname := FileMan( Iif( numdriv==3,"*.adt","*.dbf" ),, .T. )
	 ENDIF
#else
	 fname := FileMan( "*.dbf",, .T. )
#endif
	 IF .NOT. EMPTY( fname )
	    IF VALTYPE( fname ) == "C"
	       Fiopen( mypath + fname )
	    ELSE
	       Fiopen( mypath + fname[ 1 ], fname[ 2 ] )
	    ENDIF
	    prkorf  := .T.
	    prkorst := .T.
	    KEYBOARD CHR( 27 )
	    EXIT
	 ENDIF
      CASE choic = 3
	 FiClose()
	 KEYBOARD CHR( 27 )
      CASE choic = 4
	 PECH()
      CASE choic = 6
	 Selarea()
	 KEYBOARD CHR( 27 )
	 EXIT
      CASE choic = 7
	 NEXTAREA()
	 KEYBOARD CHR( 27 )
	 EXIT
      CASE choic = 8
	 PREVAREA()
	 KEYBOARD CHR( 27 )
	 EXIT
      CASE choic = 10
	 SET( _SET_EXCLUSIVE, .NOT. SET( _SET_EXCLUSIVE ) )
      CASE choic = 11
	 prrdonly := .NOT. prrdonly
#ifdef RDD_AX
      CASE choic = 12
#ifdef __HARBOUR__
#else
	 AX_AXSLocking( IIF( AX_AXSLocking(), .F., .T. ) )
#endif
      CASE choic = 13
#ifdef __HARBOUR__
	 numdriv ++
	 IF numdriv == 4
	    numdriv := 1
	 ENDIF
	 AdsSetFileType( Iif( numdriv==1,2,Iif( numdriv==2,1,3 ) ) )
#else
	 numdriv := IIF( numdriv = 1, 2, 1 )
	 RDDSETDEFAULT( msdriv[ numdriv ] )
#endif
#else
      CASE choic = 12
	 numdriv := IIF( numdriv = 1, 2, 1 )
	 RDDSETDEFAULT( msdriv[ numdriv ] )
#endif

#ifdef __HARBOUR_AX__
      CASE choic == 14
	 nServerType := IIF( nServerType == 1, 2, 1 )
	 AdsSetServerType( nServerType )
	 IF nServerType == ADS_REMOTE_SERVER
	    fname := MsgGet( "Input server path:" )
	    IF Lastkey() != 27 .AND. !Empty( fname )
	       IF Right( fname ) != "/" .AND. Right( fname ) != "\"
#ifdef __UNIX__
		  fname += "/"
#else
		  fname += "\"
#endif
	       ENDIF
	    ENDIF
	    IF Lastkey() == 27 .OR. Empty( fname ) .OR. !AdsConnect( fname )
		nServerType := 1
		AdsSetServerType( nServerType )
		Alert( "Can't establish connection" )
	    ELSE
		mypath := fname
	    ENDIF
	 ENDIF
#endif

      ENDCASE
      RESTSCREEN( 0, 0, 24, 79, bufscr )
   ENDDO
RETURN 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fpgm2()
*+
*+    Called from ( dbc.prg      )   1 - function fmenu()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fpgm2

LOCAL choic := 1, bufscr, msind[ 1 ], i, indname
#ifdef ENGLISH
LOCAL submenu := { " 1 SELECT CURRENT INDEX", " 2 CREATE NEW INDEX", ;
		      " 3 OPEN INDEX", " 4 CLOSE INDEXES" }
#else
LOCAL submenu := { " 1 ВЫБОР ТЕКУЩЕГО ИHДЕКСА ", " 2 СОЗДАТЬ НОВЫЙ ИНДЕКС", ;
		      " 3 ОТКРЫТЬ ИНДЕКСНЫЙ ФАЙЛ", " 4 ЗАКРЫТЬ ИНДЕКСЫ" }
#endif
LOCAL aDostup := { lenmsf > 0, lenmsf > 0, lenmsf > 0, lenmsf > 0 }
   DO WHILE .T.
      SET COLOR TO +GR/B,N/BG,,,N/B
      @  2,  8, 7, 35 BOX ORAMKA
      choic := MainMenu( 3, 9, 6, 34, submenu, aDostup,, 1, 1 )
      IF choic = 0 .OR. lenmsf = 0 .OR. choic = 501
	 RETURN choic
      ENDIF
      bufscr := SAVESCREEN( 0, 0, 24, 79 )
      DO CASE
      CASE choic = 1
	 msind[ 1 ] = "0 None"
	 i := 1
	 DO WHILE .NOT. EMPTY( indname := ORDNAME( i ) )
	    AADD( msind, STR( i, 1 ) + " " + PADR( indname, 10 ) + PADR( ORDKEY( i ), 50 ) + " " + ORDBAGNAME( i ) )
	    i ++
	 ENDDO
	 @  5,  1, 11, 78 BOX ORAMKA
	 i := MainMenu( 6, 2, 10, 77, msind,,, INDEXORD() + 1,, i )
	 IF i > 0
	    SET ORDER TO i-1
	    KEYBOARD CHR( 27 )
	    EXIT
	 ENDIF
      CASE choic = 2
	 NewIndex()
      CASE choic = 3
	 indname := FileMan( IIF( numdriv = 1, "*.?dx", "*.ntx" ) )
	 IF .NOT. EMPTY( indname )
	    ORDLISTADD( mypath + indname )
	 ENDIF
      CASE choic = 4
	 ORDLISTCLEAR()
      ENDCASE
      RESTSCREEN( 0, 0, 24, 79, bufscr )
   ENDDO
RETURN 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fpgm3()
*+
*+    Called from ( dbc.prg      )   1 - function fmenu()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fpgm3

LOCAL choic := 1, bufscr
#ifdef __NOEXTRA__
#ifdef ENGLISH
LOCAL submenu := { " 1 VIEW STRUCTURE", " 2 EDIT STRUCTURE", "─", " 3 EDIT RECORD        Alt-E", ;
		      "─", " 4 SELECT COLUMNS OF BROWSE", " 5 INSERT COLUMN    Alt-Ins", " 6 DELETE COLUMN    Alt-Del", ;
		      " 7 EDIT COLUMN" }
#else
LOCAL submenu := { " 1 ПРОСМОТР СТРУКТУРЫ", " 2 РЕДАКТИРОВАНИЕ СТРУКТУРЫ ", ;
		      "─", " 3 РЕДАКТ-Е ЗАПИСИ    Alt-E", "─", " 4 ВЫБОР СТОЛБЦОВ BROWSE   ", ;
		      " 5 ВСТАВКА СТОЛБЦА  Alt-Ins", " 6 УДАЛЕНИЕ СТОЛБЦА Alt-Del", " 7 РЕДАКТИРОВАНИЕ СТОЛБЦА" }
#endif
LOCAL aDostup := { lenmsf > 0, lenmsf > 0, .T., lenmsf > 0, .T., lenmsf > 0, lenmsf > 0, lenmsf > 0, lenmsf > 0, .T. }
#else
#ifdef ENGLISH
LOCAL submenu := { " 1 VIEW STRUCTURE", " 2 EDIT STRUCTURE", "─", " 3 EDIT RECORD        Alt-E", ;
		      "─", " 4 SELECT COLUMNS OF BROWSE", " 5 INSERT COLUMN    Alt-Ins", " 6 DELETE COLUMN    Alt-Del", ;
		      " 7 EDIT COLUMN", "─", " 8 COPY FIELD      Ctrl-Ins", " 9 INSERT FIELD   Shift-Ins" }
#else
LOCAL submenu := { " 1 ПРОСМОТР СТРУКТУРЫ", " 2 РЕДАКТИРОВАНИЕ СТРУКТУРЫ ", ;
		      "─", " 3 РЕДАКТ-Е ЗАПИСИ    Alt-E", "─", " 4 ВЫБОР СТОЛБЦОВ BROWSE   ", ;
		      " 5 ВСТАВКА СТОЛБЦА  Alt-Ins", " 6 УДАЛЕНИЕ СТОЛБЦА Alt-Del", " 7 РЕДАКТИРОВАНИЕ СТОЛБЦА", ;
		      "─", " 8 КОПИРОВАТЬ ПОЛЕ Ctrl-Ins", " 9 ВСТАВИТЬ ПОЛЕ  Shift-Ins" }
#endif
LOCAL aDostup := { lenmsf > 0, lenmsf > 0, .T., lenmsf > 0, .T., lenmsf > 0, lenmsf > 0, lenmsf > 0, lenmsf > 0, .T., lenmsf > 0, lenmsf > 0 }
#endif
PRIVATE prmsf := .F.
   DO WHILE .T.
      SET COLOR TO +GR/B,N/BG,,,N/B
      @  2, 17, 18, 46 BOX ORAMKA
      IF lenmsf > 0
#ifdef ENGLISH
	 @  3, 19 SAY "Amount of fields: " + STR( FCOUNT(), 3 )
	 @  4, 19 SAY "Record lenth:" + STR( RECSIZE(), 6 ) + " bytes"
#else
	 @  3, 19 SAY "Всего полей: " + STR( FCOUNT(), 3 )
	 @  4, 19 SAY "Длина записи" + STR( RECSIZE(), 6 ) + " байт"
#endif
      ENDIF
      choic := MainMenu( 6, 18, 17, 45, submenu, aDostup,, 1, 1 )
      IF choic = 0 .OR. lenmsf = 0 .OR. choic = 501
	 RETURN choic
      ENDIF
      bufscr := SAVESCREEN( 0, 0, 24, 79 )
      DO CASE
      CASE choic = 1
	 StruView()
      CASE choic = 2
	 StruMan( .F. )
      CASE choic = 4
	 EditRec()
      CASE choic = 6
	 SelFiel()
      CASE choic = 7
	 InsFiel( dbfi_f + dbnumf - 1 )
      CASE choic = 8
	 DelFiel( dbfi_f + dbnumf - 1 )
      CASE choic = 9
	 ChngFiel( dbfi_f + dbnumf - 1 )
#ifndef __NOEXTRA__
      CASE choic = 11
	 IF IS_CLIPBRD()
	    SEND_CLIPB( DosToWin( RTRIM( LTRIM( FLDSTR( dbfi_f + dbnumf - 1 ) ) ) ) )
	 ENDIF
      CASE choic = 12
	 IF IS_CLIPBRD()
	    GET_CLIPB( @cdata )
	    WinToDos( @cdata )
	 ENDIF
#endif
      ENDCASE
      RESTSCREEN( 0, 0, 24, 79, bufscr )
      KEYBOARD CHR( 27 )
      EXIT
   ENDDO
RETURN 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fpgm4()
*+
*+    Called from ( dbc.prg      )   1 - function fmenu()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fpgm4

LOCAL choic   := 1, bufscr, nrec
LOCAL submenu := { " 1 LOCATE     Alt-L", " 2 CONTINUE   Alt-N", " 3 SEEK       Alt-S", ;
		      " 4 SET FILTER Alt-F", " 5 GO TO      Alt-G" }
LOCAL aDostup  := { lenmsf > 0, lenmsf > 0, lenmsf > 0, lenmsf > 0, lenmsf > 0 }
PRIVATE strfnd
   DO WHILE .T.
      SET COLOR TO +GR/B,N/BG,,,N/B
      @  2, 25, 8, 46 BOX ORAMKA
      choic := MainMenu( 3, 26, 7, 44, submenu, aDostup,, 1, 1 )
      IF choic = 0 .OR. lenmsf = 0 .OR. choic = 501
	 RETURN choic
      ENDIF
      DO CASE
      CASE choic = 1
	 F_LOCATE()
      CASE choic = 2
	 F_CONTIN()
      CASE choic = 3
	 F_SEEK()
      CASE choic = 4
	 F_FILTER()
      CASE choic = 5
	 F_GO()
      ENDCASE
      KEYBOARD CHR( 27 )
      EXIT
   ENDDO
RETURN 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fpgm5()
*+
*+    Called from ( dbc.prg      )   1 - function fmenu()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fpgm5

LOCAL choic   := 1
LOCAL submenu := { " 1 REPLACE", " 2 DELETE", " 3 RECALL", " 4 COUNT", " 5 SUM", ;
		      " 6 APPEND FROM", " 7 COPY TO", " 8 REINDEX", " 9 PACK", " 0 ZAP", "─", " DO SCRIPT", "─", " MEMO      ", " SET RELATION" }
LOCAL aDostup := { lenmsf > 0 .AND. .NOT. prrdonly, lenmsf > 0 .AND. .NOT. prrdonly, lenmsf > 0 .AND. .NOT. prrdonly, ;
		      lenmsf > 0, lenmsf > 0, lenmsf > 0 .AND. .NOT. prrdonly, lenmsf > 0, lenmsf > 0 .AND. .NOT. prrdonly, ;
		      lenmsf > 0 .AND. .NOT. prrdonly, lenmsf > 0 .AND. .NOT. prrdonly, lenmsf > 0, lenmsf > 0, lenmsf > 0, lenmsf > 0, lenmsf > 0 }
LOCAL arScr := {}, obl, fname
   DO WHILE .T.
      SET COLOR TO +GR/B,N/BG,,,N/B
      @  2, 36, 18, 52 BOX ORAMKA
      choic := MainMenu( 3, 37, 17, 51, submenu, aDostup,, 1, 1 )
      IF choic = 0 .OR. lenmsf = 0 .OR. choic = 501
	 RETURN choic
      ENDIF
      DO CASE
      CASE choic = 1
	 C_REPL()
      CASE choic = 2 .OR. choic = 3
	 C_DELE( IIF( choic = 2, .T., .F. ) )
      CASE choic = 4
	 C_COUN()
      CASE choic = 5
	 C_SUM()
      CASE choic = 6
	 C_APPE()
      CASE choic = 7
	 C_COPY()
      CASE choic = 8
	 C_REIN()
      CASE choic = 9
	 C_PACK()
      CASE choic = 10
	 C_ZAP()
      CASE choic = 12
	 fname := FileMan( "*.scr" )
	 IF .NOT. EMPTY( fname )
	    IF ( arScr := RdScript( fname ) ) <> Nil
	       obl := SELECT()
	       FGOTOP( mslist )
	       DO ANIMA WITH 0, IIF( LI_PRFLT, LI_KOLZ, RECCOUNT() ), 'Script ' + fname + ' executing ...', 8, 6, 72
	       DO WHILE .NOT. FEOF( mslist )
		  DoScript( arScr )
		  DO ANIMA WITH 1
		  SELECT( obl )
		  FSKIP( mslist, 1 )
	       ENDDO
	       DO ANIMA WITH 2, 0, 'Script execution completed'
	    ELSE
	       MsgSay( "Error in script file" )
	    ENDIF
	 ENDIF
      CASE choic = 14
	 MemoFuncs()
      CASE choic = 15
	 C_SETR()
      ENDCASE
   ENDDO
RETURN 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fpgm6()
*+
*+    Called from ( dbc.prg      )   1 - function fmenu()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fpgm6

LOCAL choic := 1, bufscr, fname, rez
#ifdef ENGLISH
LOCAL submenu := { " 1 LOAD", " 2 SAVE" }
#else
LOCAL submenu := { " 1 ОТКРЫТЬ", " 2 СОХРАНИТЬ" }
#endif
   DO WHILE .T.
      SET COLOR TO +GR/B,N/BG,,,N/B
      @  2, 44, 5, 58 BOX ORAMKA
      choic := MainMenu( 3, 45, 4, 57, submenu,,, 1, 1 )
      IF choic = 0 .OR. choic = 501
	 RETURN choic
      ENDIF
      bufscr := SAVESCREEN( 0, 0, 24, 79 )
      DO CASE
      CASE choic = 1
	 fname := FileMan( "*.vew" )
	 IF .NOT. EMPTY( fname )
	    RdView( mypath + fname )
	 ENDIF
      CASE choic = 2
	 /*
     rez=.T.
     DO WHILE rez
      rez=.F.
#ifdef ENGLISH
      fname=MsgGet("View file name ?")
#else
      fname=MsgGet("С каким именем сохранить ?")
#endif
      IF LASTKEY()<>27.AND..NOT.EMPTY(fname)
       IF AT('.',fname)=0
	fname+=".VEW"
       ENDIF
       IF FILE(fname)
#ifdef ENGLISH
	IF .NOT.MsgYesNo(fname+" already exists! Overwrite?")
#else
	IF .NOT.MsgYesNo(fname+" уже существует! Перезаписать?")
#endif
	 rez=.T.
	ENDIF
       ENDIF
      ENDIF
     ENDDO
*/
	 fname := FileMan( "*.vew", .T. )
	 IF LASTKEY() <> 27 .AND. .NOT. EMPTY( fname )
	    WrView( fname )
	 ENDIF
      ENDCASE
      RESTSCREEN( 0, 0, 24, 79, bufscr )
      KEYBOARD CHR( 27 )
      EXIT
   ENDDO
RETURN 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fpgm7()
*+
*+    Called from ( dbc.prg      )   1 - function fmenu()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fpgm7

LOCAL choic := 1, bufscr, fname, rez
#ifdef __HARBOUR_AX__
#ifdef ENGLISH
LOCAL submenu := { " 1 NEW QUERY", " 2 OPEN QUERY", " 3 EDIT QUERY", " 4 SAVE" }
#else
LOCAL submenu := { " 1 НОВЫЙ ЗАПРОС", " 2 ОТКРЫТЬ ЗАПРОС", " 3 РЕДАКТИРОВАТЬ", ;
		      " 4 СОХРАНИТЬ" }
#endif
#else
#ifdef ENGLISH
LOCAL submenu := { " 1 NEW QUERY", " 2 OPEN QUERY", " 3 EDIT QUERY", " 4 SAVE", ;
		      " 5 SIMPLE MODE  ON" }
#else
LOCAL submenu := { " 1 НОВЫЙ ЗАПРОС", " 2 ОТКРЫТЬ ЗАПРОС", " 3 РЕДАКТИРОВАТЬ", ;
		      " 4 СОХРАНИТЬ", " 5 РЕЖИМ УПР.   ON" }
#endif
#endif
   DO WHILE .T.
#ifndef __HARBOUR_AX__
      submenu[ 5 ] = Stufmy( submenu[ 5 ], 16, 3, IIF( que_simpl, "ON ", "OFF" ) )
#endif
      SET COLOR TO +GR/B,N/BG,,,+GR/B
      @  2, 52, 8, 73 BOX ORAMKA
      choic := MainMenu( 3, 53, 7, 72, submenu,,, 1, 1 )
      IF choic = 0 .OR. choic = 501
	 RETURN choic
      ENDIF
      bufscr := SAVESCREEN( 0, 0, 24, 79 )
      DO CASE
      CASE choic = 1
	 CreatQuery()
      CASE choic = 2
	 fname := FileMan( "*.que" )
	 IF .NOT. EMPTY( fname )
	    OpenQuery( mypath + fname )
	    EditQuery()
	 ENDIF
      CASE choic = 3
	 IF textquery[ 1 ] = Nil
	    CreatQuery()
	 ELSE
	    EditQuery()
	 ENDIF
      CASE choic = 4 .AND. textquery[ 1 ] <> Nil
	 WriteQuery()
#ifndef __HARBOUR_AX__
      CASE choic = 5
	 que_simpl := .NOT. que_simpl
#endif
      ENDCASE
      RESTSCREEN( 0, 0, 24, 79, bufscr )
   ENDDO
RETURN 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fpgm8()
*+
*+    Called from ( dbc.prg      )   1 - function fmenu()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fpgm8

LOCAL choic := 1, bufscr, expr, rez, i
LOCAL arScr := {}, fname
#ifdef ENGLISH
LOCAL submenu := { " SWITCH VIDEOMODE", " SPLIT SCREEN", " CALCULATE EXPRESSIONS", ;
		      " DATE FORMAT", " CHARSET: OEM ", " MEMO WINDOW        ON", " RUN SCRIPT" }
#else
LOCAL submenu := { " ПЕРЕКЛЮЧЕНИЕ ВИДЕОРЕЖИМА", " РАСЩЕПИТЬ(СЛИТЬ) ЭКРАН", ;
		      " ВЫЧИСЛЕНИЕ  ВЫРАЖЕНИЙ", " ФОРМАТ ДАТЫ", " CHARSET: DOS ", " ОКНО ДЛЯ МЕМО      ON", " ВЫПОЛНИТЬ СКРИПТ" }
#endif
   DO WHILE .T.
#ifdef ENGLISH
      submenu[ 5 ] = Stufmy( submenu[ 5 ], 11, 4, IIF( lWinChar, "ANSI", "OEM " ) )
#else
      submenu[ 5 ] = Stufmy( submenu[ 5 ], 11, 4, IIF( lWinChar, "WIN", "DOS" ) )
#endif
      submenu[ 6 ] = Stufmy( submenu[ 6 ], 20, 3, IIF( memownd, "ON ", "OFF" ) )
      SET COLOR TO +GR/B,N/BG,,,+GR/B
      @  2, 51, 10, 79 BOX ORAMKA
      choic := MainMenu( 3, 52, 9, 78, submenu,,, 1, 1 )
      IF choic = 0 .OR. choic = 501
	 RETURN choic
      ENDIF
      DO CASE
      CASE choic = 1
#ifndef __CLIP__
	 mode43 := .NOT. mode43
	 SETMODE( IIF( mode43, 43, 25 ), 80 )
	 ScrClr := .T.
#endif
	 KEYBOARD CHR( 27 )
	 EXIT
      CASE choic = 2
	 modesplit := .NOT. modesplit
	 IF modesplit
	    impr1 := improc
	    impr2 := 0
	    FOR i := improc + 1 TO lenmsf
	       IF msfile[ i ] <> Nil
		  impr2 := i
		  EXIT
	       ENDIF
	    NEXT
	    IF impr2 = 0
	       FOR i := improc - 1 TO 1 STEP - 1
		  IF msfile[ i ] <> Nil
		     impr2 := i
		     EXIT
		  ENDIF
	       NEXT
	    ENDIF
	    wndfirst := .T.
	 ENDIF
	 ScrClr := .T.
	 KEYBOARD CHR( 27 )
	 EXIT
      CASE choic = 3
	 Calc_exp()
      CASE choic = 4
	 Dateman( 6, 60, 14, 72 )
      CASE choic = 5
	 lWinChar := !lWinChar
      CASE choic = 6
	 memownd := .NOT. memownd
      CASE choic = 7
	 fname := FileMan( "*.scr" )
	 IF .NOT. EMPTY( fname )
	    IF ( arScr := RdScript( fname ) ) <> Nil
	       DoScript( arScr )
	       MsgSay( "Script executed", "N/W" )
	    ELSE
	       MsgSay( "Error in script file" )
	    ENDIF
	 ENDIF
	 KEYBOARD CHR( 27 )
	 EXIT
      ENDCASE
   ENDDO
RETURN 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Fpgm9()
*+
*+    Called from ( dbc.prg      )   1 - function fmenu()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Fpgm9

LOCAL choic := 1, bufscr
#ifdef ENGLISH
LOCAL submenu := { " EXIT  " }
#else
LOCAL submenu := { " ВЫХОД " }
#endif
   DO WHILE .T.
      SET COLOR TO +GR/B,N/BG,,,+GR/B
      @  2, 45, 11, 79 BOX ORAMKA
      @  3, 46 SAY Padc( stra1,33 )
      @  4, 46 SAY Padc( stra2,33 )
      @  6, 46 SAY Padc( stra3,33 )
      @  7, 46 SAY Padc( stra4,33 )
      // @ 7,54 SAY stra5
      // @ 8,54 SAY PADC(stra6,20)
      @  9, 46 TO 9, 78
      choic := MainMenu( 10, 58, 10, 64, submenu,,, 1, 1 )
      IF choic = 0 .OR. choic = 501
	 RETURN choic
      ENDIF
      DO CASE
      CASE choic = 1
	 CLOSE ALL
	 SET COLOR TO W/N
	 @  0,  0 CLEAR TO 24, 79
	 QUIT
      ENDCASE
   ENDDO
RETURN 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function FileLock()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION FileLock()

LOCAL fname := msfile[ improc ]
   IF .NOT. msmode[ improc, 1 ]
      USE &fname EXCLUSIVE
      IF NETERR()
#ifdef ENGLISH
	 MsgSay( "File locked !" )
#else
	 MsgSay( "Файл занят !" )
#endif
	 USE &fname SHARED
	 RETURN .F.
      ELSE
	 msmode[ improc, 1 ] = .T.
      ENDIF
   ENDIF
RETURN .T.

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function FileMan()
*+
*+    Called from ( dbc.prg      )   1 - function wrkdoc()
*+                                   1 - function fpgm1()
*+                                   1 - function fpgm2()
*+                                   1 - function fpgm5()
*+                                   2 - function fpgm6()
*+                                   1 - function fpgm7()
*+                                   1 - function fpgm8()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION FileMan( fspec, prnew, lAlias )

LOCAL fname, aFiles, aNames[ 2000 ], aSpec[ 2000 ]
LOCAL i, arlen, bufscr, oldc, lkey
LOCAL aDisk := {}, chgpath := .T., curdr, drLetter, cDrive
#ifdef ENGLISH
LOCAL cMsg1 := " already exists! Overwrite?"
#else
LOCAL cMsg1 := " уже существует! Перезаписать?"
#endif
LOCAL filename  := SPACE( 30 ), prfirst := .T., choic := 1
PRIVATE aCtrl   := { { "", { || __keyboard( CHR( K_TAB ) ) }, 8, 24, 12, 45 }, { "", { || __keyboard( CHR( K_UP ) ) }, 7, 54, 7, 56 }, { "",, 16, 22, 16, 56 } }
PRIVATE Ctrlist := { "W+/RB,W+/B", aCtrl }
PRIVATE GetList := {}

   fspec  := UPPER( fspec )
   prnew  := IIF( prnew = Nil, .F., prnew )
   lAlias := IIF( lAlias == Nil, .F., lALias )
   bufscr := SAVESCREEN( 4, 20, 18, 60 )
   oldc   := SETCOLOR()
   DO WHILE .T.
      IF prfirst
#ifndef __NOEXTRA__
	 IF SUBSTR( mypath, 2, 1 ) = ":"
	    curdr := ASC( mypath ) - 64
	 ELSE
	    curdr := CurrDrive()
	 ENDIF
	 cDrive := drLetter := CHR( curdr + 64 )
#endif
	 SETCOLOR( "W+/RB" )
	 @  4, 20, 18, 60 BOX DRAMKA
	 @  5, 22 SAY "Choose file:"
	 IF lAlias
	    @ 15, 22 SAY "Alias:"
	 ENDIF
#ifndef __NOEXTRA__
	 @  5, 52 SAY "Drive:"
	 mypath := IIF( EMPTY( mypath ), drLetter + ":\" + CURDIR() + IIF( EMPTY( CURDIR() ), "", "\" ), mypath )
#else
#ifdef __UNIX__
	 mypath := IIF( EMPTY( mypath ), "/" + CURDIR() + IIF( EMPTY( CURDIR() ), "", "/" ), mypath )
#else
	 mypath := IIF( EMPTY( mypath ), "\" + CURDIR() + IIF( EMPTY( CURDIR() ), "", "\" ), mypath )
#endif
#endif
	 IF prnew
	    @ 16, 22 SAY filename COLOR "N/W"
	 ENDIF
	 @ 17, 22 SAY mypath
#ifndef __NOEXTRA__
	 @  6, 53, 8, 57 BOX ORAMKA
	 @  7, 55 SAY drLetter
#endif
	 @  6, 22, 14, 47 BOX ORAMKA
	 SETCOLOR( "N/W,W+/N" )
	 @  7, 23 CLEAR TO 13, 46
	 IF chgpath
	    arlen  := ADIR( mypath + FILE_MASK, aNames,,,, aSpec )
	    aFiles := {}
	    FOR i := 1 TO arlen
	       IF "D" $ aSpec[ i ]
		  IF "." <> aNames[ i ]
		     AADD( aFiles, " " + aNames[ i ] )
		  ENDIF
	       ELSEIF CmpMsk( UPPER( aNames[ i ] ), fspec )
		  AADD( aFiles, aNames[ i ] )
	       ENDIF
	    NEXT
	    ASORT( aFiles )
	    chgpath := .F.
	    choic   := 1
	 ENDIF

	 i := MainMenu( 7, 23, 13, 46, aFiles,, { | p1, p2 | userfi( p1, p2 ) }, @choic )
	 // outlog(__FILE__,__LINE__,i)
	 IF i = 0
	    EXIT
	 ENDIF
      ELSE
	 i       := 1001
	 prfirst := .T.
      ENDIF
      IF i == 1001
#ifndef __NOEXTRA__
	 READEXIT( .T. )
	 @  7, 55 GET drLetter VALID !EMPTY( drLetter := DriveChoose( aDisk, drLetter ) )
	 READ
	 READEXIT( .F. )
	 IF cDrive <> drLetter .AND. LASTKEY() <> 27
	    cDrive  := drLetter
	    mypath  := drLetter + ":\"
	    chgpath := .T.
	 ENDIF
	 IF LASTKEY() == K_TAB
	    i := 1001
	 ENDIF
#endif
      ELSEIF i < 500
	 IF LEFT( aFiles[ i ], 1 ) <> " "
	    IF prnew
	       // LOOP
	    ELSE
	       IF !ISDIGIT( aFiles[ choic ] )
		  EXIT
	       ENDIF
	    ENDIF
	 ELSE
	    IF LEFT( aFiles[ i ], 2 ) == " ."
#ifdef __UNIX__
	       j := RAT( "/", LEFT( mypath, LEN( mypath ) - 1 ) )
#else
	       j := RAT( "\", LEFT( mypath, LEN( mypath ) - 1 ) )
#endif
	       IF j > 0
		  mypath := LEFT( mypath, j )
	       ENDIF
	    ELSE
#ifdef __UNIX__
	       mypath += SUBSTR( aFiles[ i ], 2 ) + "/"
#else
	       mypath += SUBSTR( aFiles[ i ], 2 ) + "\"
#endif
	    ENDIF
	    chgpath := .T.
	    LOOP
	 ENDIF
      ENDIF
      IF ( prnew .OR. lAlias ) .AND. .NOT. ( chgpath .AND. i = 1001 )
	 IF lAlias .OR. Lastkey() == 13
	    filename := PADR( CutExten( aFiles[ choic ] ), 30 )
	 ENDIF
	 READEXIT( .T. )
	 @ 16, 22 GET filename COLOR "N/W,N/W"
	 READ
	 READEXIT( .F. )
	 lkey := LASTKEY()
	 DO CASE
	 CASE lkey = K_SH_TAB .OR. lkey = K_UP
	    prfirst := .F.
	 CASE lkey == K_ENTER .AND. .NOT. EMPTY( filename )
	    IF prnew
	       IF AT( ".", filename ) = 0
		  filename := RTRIM( filename ) + "." + FilExten( fspec )
	       ELSE
		  filename := RTRIM( filename )
	       ENDIF
	       IF .NOT. FILE( mypath + filename ) .OR. MsgYesNo( filename + cMsg1 )
		  EXIT
	       ELSE
		  filename := PADR( filename, 30 )
	       ENDIF
	    ELSE
	       EXIT
	    ENDIF
	 CASE lkey = 27 .OR. ( lkey = K_ENTER .AND. EMPTY( filename ) )
	    i := 0
	    EXIT
	 ENDCASE
      ENDIF
   ENDDO
   SETCOLOR( oldc )
   RESTSCREEN( 4, 20, 18, 60, bufscr )
   RETURN IIF( i == 0, "", IIF( prnew, mypath + filename, IIF( lAlias .AND. !EMPTY( filename ), { aFiles[ choic ], filename }, aFiles[ choic ] ) ) )

#ifndef __NOEXTRA__

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Static Function DriveChoose()
*+
*+    Called from ( dbc.prg      )   1 - function fileman()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
STATIC FUNCTION DriveChoose( aDisk, drLetter )

LOCAL j, j1, bufs1, choic := 1
   IF EMPTY( aDisk )
      j  := 1
      j1 := 0
      DO WHILE .T.
	 IF DiskAbout( j ) < 18
	    AADD( aDisk, " " + CHR( j + 64 ) + " " )
	    j1 := 0
	 ELSEIF j1 > 2
	    EXIT
	 ELSE
	    j1 ++
	 ENDIF
	 j ++
      ENDDO
   ENDIF
   drLetter := UPPER( drLetter )
   IF ASCAN( aDisk, ' ' + drLetter + ' ' ) == 0
      bufs1 := SAVESCREEN( 8, 53, 15, 57 )
      @  8, 53, 15, 57 BOX ORAMKA
      MainMenu( 9, 54, 14, 56, aDisk,,, @choic )
      RESTSCREEN( 8, 53, 15, 57, bufs1 )
   ELSE
      RETURN ALLTRIM( drLetter )
   ENDIF
   RETURN ALLTRIM( aDisk[ choic ] )
#endif

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Userfi()
*+
*+    Called from ( dbc.prg      )   1 - function fileman()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Userfi( nind, key )

LOCAL rez := 2, i
#ifdef VER_MOUSE
   IF key = 501
      i := F_CTRL( aCtrl,,,,,, 1, M_YTEXT(), M_XTEXT() )
   ENDIF
#endif
   DO CASE
   CASE key = K_TAB .OR. ( key = 501 .AND. i = 2 )
      rez := 1001
   CASE key = K_SH_TAB .OR. ( key = 501 .AND. i = 3 )
      rez := 1002
   ENDCASE
RETURN rez

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function DateMan()
*+
*+    Called from ( dbc.prg      )   1 - function fpgm8()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION DateMan( y1, x1, y2, x2 )

LOCAL i, bufscr
LOCAL aDate := { "dd/mm/yy", "mm/dd/yy", "yy/mm/dd", "dd.mm.yy", "dd-mm-yy", "dd/mm/yyyy", "mm/dd/yyyy" }
   bufscr := SAVESCREEN( y1, x1, y2, x2 )
   @ y1, x1, y2, x2 BOX ORAMKA
   i := MainMenu( y1 + 1, x1 + 1, y2 - 1, x2 - 1, aDate,,,,,, .T. )
   RESTSCREEN( y1, x1, y2, x2, bufscr )
   IF i > 0 .AND. i < 500
      dformat := aDate[ i ]
      SET DATE FORMAT dformat
   ENDIF
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function NewIndex()
*+
*+    Called from ( dbc.prg      )   1 - function fpgm2()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION NewIndex

LOCAL bufsc, oldc, indname, i, prmulti := "Y", tagname := "       "
LOCAL expkey := SPACE( 100 ), expfor := SPACE( 100 )
   indname := PADR( CutExten( CutPath( msfile[ improc ] ) ) + INDEXEXT(), 46 )
   bufsc   := SAVESCREEN( 6, 20, 13, 70 )
   oldc    := SETCOLOR()
   SET COLOR TO +W/GR,N+/W,,,+W/GR
   @  6, 20, 14, 70 BOX ORAMKA
#ifdef ENGLISH
   @  7, 25 SAY "Creating tag for     " + CutPath( msfile[ improc ] ) COLOR "+GR/GR"
   @  8, 22 SAY "Name" GET indname    PICTURE REPLICATE( 'X', 36 )
   IF msmode[ improc , 3 ] = 1
      @  9, 22 SAY "MultiBag (Y/N)" GET prmulti PICTURE "X"        VALID prmulti $ "YyNn"
      @  9, 40 SAY "Тag"            GET tagname PICTURE "XXXXXXXX" WHEN prmulti $ "Yy"
   ENDIF
   @ 10, 22 SAY "Expression:"
   @ 12, 22 SAY "Condition:"
#else
   @  7, 25 SAY "Создание индекса для " + CutPath( msfile[ improc ] ) COLOR "+GR/GR"
   @  8, 22 SAY "Имя"                                      GET indname    PICTURE REPLICATE( 'X', 36 )
   IF msmode[ improc , 3 ] = 1
      @  9, 22 SAY "MultiBag (Y/N)" GET prmulti PICTURE "X"        VALID prmulti $ "YyNn"
      @  9, 40 SAY "Тag"            GET tagname PICTURE "XXXXXXXX" WHEN prmulti $ "Yy"
   ENDIF
   @ 10, 22 SAY "Индексное выражение:"
   @ 12, 22 SAY "Условие:"
#endif
   @ 11, 22 GET expkey PICTURE "@S36"
   @ 13, 22 GET expfor PICTURE "@S36"
   READ
   IF LASTKEY() <> 27
#ifdef ENGLISH
      MsgInf( "Indexing ..." )
#else
      MsgInf( "Индексирую ..." )
#endif
      indname := mypath + indname
      IF numdriv = 1 .AND. prmulti $ "Yy"
	 IF EMPTY( expfor )
	    // INDEX ON &(RTRIM(expkey)) TAG &(RTRIM(tagname)) TO &(RTRIM(indname))
	    ORDCREATE( RTRIM( indname ), RTRIM( tagname ), RTRIM( expkey ), &( "{||" + RTRIM( expkey ) + "}" ) )
	 ELSE
	    // INDEX ON &(RTRIM(expkey)) TAG &(RTRIM(tagname)) TO &(RTRIM(indname)) FOR &(RTRIM(expfor))
	    ordCondSet( RTRIM( expfor ), &( "{||" + RTRIM( expfor ) + "}" ),,,,, RECNO(),,,, )
	    ORDCREATE( RTRIM( indname ), RTRIM( tagname ), RTRIM( expkey ), &( "{||" + RTRIM( expkey ) + "}" ) )
	 ENDIF
      ELSE
	 IF EMPTY( expfor )
	    // INDEX ON &(RTRIM(expkey)) TO &(RTRIM(indname))
	    dbCreateIndex( RTRIM( indname ), RTRIM( expkey ), &( "{||" + RTRIM( expkey ) + "}" ) )
	 ELSE
	    // INDEX ON &(RTRIM(expkey)) TO &(RTRIM(indname)) FOR &(RTRIM(expfor))
	    ordCondSet( RTRIM( expfor ), &( "{||" + RTRIM( expfor ) + "}" ),,,,, RECNO(),,,, )
	    ORDCREATE( RTRIM( indname ),, RTRIM( expkey ), &( "{||" + RTRIM( expkey ) + "}" ) )
	 ENDIF
      ENDIF
#ifdef ENGLISH
      MsgInf( "File indexed !" )
#else
      MsgInf( "Индексация закончена !" )
#endif
   ENDIF
   RESTSCREEN( 6, 20, 13, 70, bufsc )
   SETCOLOR( oldc )
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function EditRec()
*+
*+    Called from ( dbc.prg      )   1 - function wrkdoc()
*+                                   1 - function fpgm3()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION EditRec

LOCAL bufc, oldc, i, kolf := FCOUNT(), firstf, lastf, lkey, prupdt, fType
#ifdef ENGLISH
LOCAL cMsg1 := "Data was changed. Save?"
#else
LOCAL cMsg1 := "Данные изменены! Сохранить?"
#endif
PRIVATE GetList := {}
PRIVATE maspic[ kolf ], varname
   bufsc := SAVESCREEN( 4, 3, 22, 76 )
   oldc  := SETCOLOR()
   FOR i := 1 TO kolf
      varname := "get" + NUM_STR( i, 2 )
PRIVATE &varname
   NEXT
   DO FLMSFLD WITH maspic, .T., 60
   firstf := 1
   lastf  := MIN( kolf, 16 )
   prupdt := .F.
   DO WHILE .T.
      SET COLOR TO +GR/RB
      @  4,  3, 22, 76 BOX ORAMKA
      IF prrdonly
	 @  4,  6 SAY "(ReadOnly)"
      ENDIF
      IF lastf < kolf
	 @ 22,  6 SAY " Page Down  "
      ENDIF
      IF firstf > 1
	 @ 22, 21 SAY " Page Up  "
      ENDIF
      FOR i := firstf TO lastf
	 @  6 + i - firstf, 5 SAY FIELDNAME( i )
      NEXT
      SET COLOR TO +W/RB,N+/W,,,+W/RB
      FOR i := firstf TO lastf
	 varname := "get" + NUM_STR( i, 2 )
	 fType   := FieldType( i )
	 IF lWinChar .AND. ( fType == "C" .OR. fType == "M" )
	    &varname := WinToDos( &varname )
	 ENDIF
	 @  6 + i - firstf, 15 GET &varname PICTURE IIF( fType == "M", "@S50", maspic[ i ] )
      NEXT
      READ
      IF UPDATED()
	 prupdt := .T.
      ENDIF
      lkey := LASTKEY()
      DO CASE
      CASE lkey = 27
	 IF ( prupdt .OR. UPDATED() ) .AND. .NOT. msmode[ improc, 2 ]
	    IF MsgYesNo( cMsg1 )
	       IF .NOT. SET( _SET_EXCLUSIVE )
		  RLOCK()
	       ENDIF
	       FOR i := 1 TO kolf
		  varname := "get" + NUM_STR( i, 2 )
		  fType   := FieldType( i )
		  IF lWinChar .AND. ( fType == "C" .OR. fType == "M" )
		     &varname := DosToWin( &varname )
		  ENDIF
FIELDPUT( i, &varname )
	       NEXT
	       IF .NOT. SET( _SET_EXCLUSIVE )
		  UNLOCK
	       ENDIF
	    ENDIF
	 ENDIF
	 EXIT
      CASE lkey = 3 .AND. lastf < kolf
	 firstf := lastf + 1
	 lastf  := MIN( kolf, lastf + 16 )
      CASE lkey = 18 .AND. firstf > 1
	 firstf -= 16
	 lastf  := firstf + 15
      ENDCASE
   ENDDO
   SETCOLOR( oldc )
   RESTSCREEN( 4, 3, 22, 76, bufsc )
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Static Function Calc_exp()
*+
*+    Called from ( dbc.prg      )   1 - function fpgm8()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
STATIC FUNCTION Calc_exp

LOCAL GetList := {}
LOCAL oldc, bufscr, txget := SPACE( 200 ), rez
   bufscr := SAVESCREEN( 08, 12, 13, 66 )
   oldc   := SETCOLOR()
   SET COLOR TO +W/RB,B/W,,,+W/RB
   @ 08, 12, 13, 66 BOX ORAMKA
   DO WHILE .T.
#ifdef ENGLISH
      @ 09, 14 SAY "Input expression:"
#else
      @ 09, 14 SAY "Введите выражение:"
#endif
      @ 10, 14 GET txget PICTURE "@S50"
      READ
      IF LASTKEY() = 27
	 EXIT
      ENDIF
      IF TYPE( TRIM( txget ) ) $ "UEUI"
#ifdef ENGLISH
	 MsgSay( "Wrong expression" )
#else
	 MsgSay( "Неверное выражение" )
#endif
      ELSE
	 rez := &( TRIM( txget ) )
#ifdef ENGLISH
	 @ 11, 14 SAY "Result:"
#else
	 @ 11, 14 SAY "Результат:"
#endif
	 @ 12, 14 CLEAR TO 12, 65
	 @ 12, 14 SAY TRANSFORM( rez, "@B" )
      ENDIF
   ENDDO
   SETCOLOR( oldc )
   RESTSCREEN( 08, 12, 13, 66, bufscr )
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function MsgGet()
*+
*+    Called from ( dbc.prg      )   1 - function fiopen()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION MsgGet( tsoob, tpict, txget )

LOCAL GetList := {}
LOCAL oldc, bufscr
   txget  := IIF( txget = Nil, SPACE( 200 ), IIF( VALTYPE( txget ) = "C", PADR( txget, 200 ), txget ) )
   bufscr := SAVESCREEN( 08, 12, 11, 66 )
   oldc   := SETCOLOR()
   SET COLOR TO +W/RB,B/W,,,+W/RB
   @ 08, 12, 11, 66 BOX ORAMKA
   @ 09, 14 SAY tsoob
   @ 10, 14 GET txget PICTURE IIF( tpict <> Nil, tpict, "@S50" )
   READ
   SETCOLOR( oldc )
   RESTSCREEN( 08, 12, 11, 66, bufscr )
   IF LASTKEY() = 27
      RETURN ""
   ENDIF
RETURN TRIM( txget )

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function MsgYesNo()
*+
*+    Called from ( dbc.prg      )   1 - function fileman()
*+                                   1 - function editrec()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION MsgYesNo( tsoob )

LOCAL GetList := {}
LOCAL oldc, bufscr, txget := " "
   bufscr := SAVESCREEN( 07, 15, 13, 65 )
   oldc   := SETCOLOR()
   SET COLOR TO +W/R,B/W,,,+W/RB
   @ 07, 15, 13, 65 BOX DRAMKA
   @ 09, 16 SAY PADC( tsoob, 49 )
   @ 11, 23 SAY "(Yes/No)"        GET txget PICTURE "X" VALID txget $ "YyNn"
   READ
   SETCOLOR( oldc )
   RESTSCREEN( 07, 15, 13, 65, bufscr )
   IF LASTKEY() = 27
      RETURN .F.
   ENDIF
RETURN txget $ "Yy"

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function MsgInf()
*+
*+    Called from ( dbc.prg      )   1 - function wrkdoc()
*+                                   4 - function newindex()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION MsgInf( tsoob )

LOCAL oldc
   oldc := SETCOLOR()
   SET COLOR TO "N/W"
   @  2,  0 CLEAR TO 2, 22
   IF tsoob <> Nil
      txtinf := tsoob
   ENDIF
   @  2,  0 SAY txtinf
   IF tsoob = Nil
      txtinf := ""
   ENDIF
   SETCOLOR( oldc )
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Procedure SHADOW()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
PROCEDURE SHADOW( y1, x1, y2, x2 )

   SET COLOR TO N+/N
   @ y2 + 1, x1 + 1, y2 + 1, x2 + 1 BOX REPLICATE( CHR( 220 ), 9 )
   @ y1 + 1, x2 + 1 CLEAR TO y2, x2 + 1
   @ y1, x2 + 1 SAY CHR( 223 )
RETURN

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Deshf()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Deshf

RETURN

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function FilePath()
*+
*+    Called from ( dbc.prg      )   1 - function main()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION FilePath( fname )
LOCAL i := RAT( '\', fname )
   IF i == 0
      i := RAT( '/', fname )
   ENDIF
RETURN IIF( i == 0, "", LEFT( fname, i ) )

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function CutPath()
*+
*+    Called from ( dbc.prg      )   1 - function fiopen()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION CutPath( fname )
LOCAL i := RAT( '\', fname )
   IF i == 0
      i := RAT( '/', fname )
   ENDIF
RETURN IIF( i = 0, fname, SUBSTR( fname, i + 1 ) )

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Selarea()
*+
*+    Called from ( dbc.prg      )   1 - function wrkdoc()
*+                                   1 - function fpgm1()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Selarea

LOCAL i := 0, oldc
   oldc := SETCOLOR()
   SET COLOR TO +GR/B,B/W
   Vldareas( @i )
   IF i > 0
      improc := i
      prkorf := .T.
   ENDIF
   SETCOLOR( oldc )
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function CmpMsk()
*+
*+    Called from ( dbc.prg      )   1 - function fileman()
*+                                   1 - function cmpmsk()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION CmpMsk( strcmp, mask )

#ifdef __CLIP__
	return glob(strcmp,mask,.t.) // .f. - case sensitivity
#else
LOCAL lenm := LEN( mask ), i, poz1 := 1, poz2, symb
   FOR i := 1 TO lenm
      symb := SUBSTR( mask, i, 1 )
      IF symb = "*"
	 IF i = lenm
	    RETURN .T.
	 ELSE
	    symb := SUBSTR( mask, i + 1, 1 )
	    DO WHILE .T.
	       poz2 := AT( symb, SUBSTR( strcmp, poz1 ) )
	       IF poz2 = 0
		  RETURN .F.
	       ENDIF
	       poz1 += poz2 - 1
	       IF CmpMsk( SUBSTR( strcmp, poz1 ), SUBSTR( mask, i + 1 ) )
		  RETURN .T.
	       ENDIF
	       poz1 ++
	    ENDDO
	 ENDIF
      ELSEIF symb = "?"
	 poz1 ++
      ELSE
	 IF symb <> SUBSTR( strcmp, poz1, 1 )
	    RETURN .F.
	 ENDIF
	 poz1 ++
      ENDIF
   NEXT
RETURN .T.
#endif

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function OutCtrls()
*+
*+    Called from ( dbc.prg      )   1 - function main()
*+                                   2 - function wrkdoc()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION OutCtrls( mctrl )

LOCAL i, j, oldc
   oldc := SETCOLOR()
   FOR i := 1 TO LEN( mctrl )
      IF VALTYPE( mctrl[ i ] ) = "C"
	 SETCOLOR( mctrl[ i ] )
      ELSE
	 FOR j := 1 TO LEN( mctrl[ i ] )
	    @ mctrl[ i, j, 3 ], mctrl[ i, j, 4 ] SAY mctrl[ i, j, 1 ]
	 NEXT
      ENDIF
   NEXT
   SETCOLOR( oldc )
RETURN .T.

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Stufmy()
*+
*+    Called from ( dbc.prg      )   1 - function fiopen()
*+                                   7 - function fpgm1()
*+                                   1 - function fpgm7()
*+                                   3 - function fpgm8()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Stufmy( stsou, pozs, ellen, elzn )

RETURN SUBSTR( stsou, 1, pozs - 1 ) + elzn + SUBSTR( stsou, pozs + ellen )

#ifdef __HARBOUR__
Exit PROCEDURE ExitDBC
/*
   __PP_Free()
*/
#ifdef RDD_AX
   AdsApplicationExit()
#endif
Return
#endif

*+ EOF: DBC.PRG
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                        ����  g�@��?A:;=    �             �b                                                         ���
                        ��  �  _�@���?���?    �             $c #c                                                     <                         ��    _�@���?���?    �             &c %c                                                     �                         ��  '   `�@���?���?    �              /home/rust/tmp/netpbm-10.18/pm_config.h                                              ��  $   `�@���?���?    �              /home/rust/tmp/netpbm-10.18/lib/pm.h                        7                         ��  %   `�@���?���?    �              /home/rust/tmp/netpbm-10.18/lib/pbm.h                       L                         ��  -   `�@���?���?    �              /home/rust/tmp/netpbm-10.18/lib/util/shhopt.h               b                         ��  .   `�@���?���?    �              /home/rust/tmp/netpbm-10.18/lib/util/nstring.h              w                         ��  0   `�@���?���?    �              /home/rust/tmp/netpbm-10.18/lib/util/mallocvar.h            �                         ��  �  `�@���?���?    �             Kc Lc                                                                               �  �!  `�@���?���?    �             Oc Pc Qc                                                 �                         ��  �  `�@���?���?    �             Rc                                                         �                         �  `  `�@���?���?    �             Sc Tc                                                     �                         ��  �	  `�@���?���?    �             Uc                                                         �                         �  ?  a�@���?���?    �             Vc Wc                                                     I                         ��  �  a�@���?���?    �             Xc                                                         Z                         �  !  a�@���?���?    �             ac bc cc                                                 �                         ��  �  a�@���?���?    �             ec dc                                                     �                         �  .  a�@���?���?    �             fc gc hc                                                 
                         ��  (	  a�@���?���?    �             �c                                                                                  �    a�@���?���?    �             �c �c                                                     `                         ��  l  a�@���?���?    �             �c                                                         �                         �  �  a�@���?���?    �             �c �c                                                     �                         ��  �  a�@���?���?    �             �c                                                         �                         �      a�@���?���?    �             �c �c �c                                                 8                         ��  t  a�@���?���?    �             �c �c                                                     I                         �  �%  a�@���?���?    �             �c �c �c                                                 �                         ��  �  a�@���?���?    �             �c                                                         �                         �  �  a�@���?���?    �             �c �c                                                                              ��  p  a�@���?���?    �             �c                                                         E                         �  �   a�@���?���?    �             �c �c �c                                                 �                         
