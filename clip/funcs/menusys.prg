/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "button.ch"
#include "getexit.ch"
#include "inkey.ch"
#include "llibg.ch"
#include "setcurs.ch"

STATIC oStatus

*****************************************
FUNCTION MenuModal( oTopMenu, nSelection, nMsgRow, nMsgLeft, nMsgRight, ;
		    cMsgColor, GetList )
   LOCAL k,nKey, nNewItem, lSaveCursor:=setCursor(), lLeftDown, oNewMenu, nNewLevel, ;
	 nEvent, oMenuItem, nMenuItem, nReturn, nCol, nRow, oMsg, ;
	 nTemp, bKeyBlock, lSubMenu, aMode, aSavMenuSys

   if oStatus==NIL
      menuSysInit()
   endif

   aSavMenuSys := map()
   for k in oStatus KEYS
	aSavMenuSys[k] := oStatus[k]
   next


   oMsg := map()
   oMsg:flag := NIL
   oMsg:row  := nMsgRow
   oMsg:left := nMsgLeft
   oMsg:right:= nMsgRight
   oMsg:color:= iif(cMsgColor==NIL, setcolor(), cMsgColor)
   oMsg:back1:= NIL
   oMsg:back2:= NIL
   oMsg:fore := NIL
   oMsg:fontcol:= NIL
   oMsg:fontrow:= NIL

   nReturn     := 0


   IF ( oMsg:flag := ( ValType( oMsg:row ) + ;
			     ValType( oMsg:left ) + ;
			     ValType( oMsg:right ) == "NNN" ) )

      IF !( ValType( oMsg:color ) == "C" )
	 oMsg:color := GetClrPair( SetColor(), 1 )
      ENDIF

      @ oMsg:row, oMsg:left CLEAR TO ;
	oMsg:row, oMsg:right

      oStatus:scrVmsg := SaveScreen( oMsg:row, ;
	   oMsg:left, oMsg:row, oMsg:right )

   ENDIF

   oTopMenu:Select( nSelection )

   IF ( oTopMenu:ClassName != "TOPBARMENU" .AND. !oTopMenu:IsOpen )
      oTopMenu:Open()
   ELSE
      oTopMenu:Display()
   ENDIF

   IF nSelection <= 0
      WHILE ( nSelection <= 0 )

	 nEvent := SET( _SET_EVENTMASK, INKEY_KEYBOARD + INKEY_LDOWN )
	 nKey   :=  Inkey( 0.01 )
	 SET( _SET_EVENTMASK, nEvent )

	 IF ( nKey == K_LBUTTONDOWN .OR. nKey == K_LDBLCLK )
	    nSelection := oTopMenu:HitTest( MRow(), MCol() )

	 ELSEIF ( ( nSelection := oTopMenu:GetAccel( nKey ) ) != 0 )

	 ELSEIF ( IsShortCut( oTopMenu, nKey, @nReturn ) )
	    for k in aSavMenuSys KEYS
		oStatus[k] := aSavMenuSys[k]
	    next
	    RETURN ( nReturn )

	 ELSE
	    nSelection := 1

	 ENDIF

      ENDDO

      oTopMenu:Select( nSelection )
      oTopMenu:Display()

   ENDIF

   IF ( !oTopMenu:GetItem( nSelection ):Enabled .or. ;
	oTopMenu:GetItem( nSelection ):Disabled )
	    for k in aSavMenuSys KEYS
		oStatus[k] := aSavMenuSys[k]
	    next
      RETURN ( 0 )
   ENDIF

   oStatus:oMenu          := oTopMenu
   oStatus:menuList      := Array( 16 )
   oStatus:menuLevel     := 1
   oStatus:menuList[ 1 ] := oStatus:oMenu

   lLeftDown := mLeftDown()

   ShowMsg( oMsg, .T. )

   WHILE (.T.)
      nKey := INKEY( 0 )
      IF !( ( bKeyBlock := SETKEY( nKey ) ) == NIL )
	 EVAL( bKeyBlock, PROCNAME(1), PROCLINE(1), "" )
	 LOOP
      ENDIF

      IF ( nKey == K_MOUSEMOVE )

	 IF ( lLeftDown )
	    IF ( !MHitTest( @oNewMenu, @nNewLevel, @nNewItem, oTopMenu ) )

	    ELSEIF ( nNewLevel != oStatus:menuLevel )

	       IF ( nNewItem == oNewMenu:Current )
	       ELSEIF ( oNewMenu:GetItem( nNewItem ):Enabled .and. ;
			!oNewMenu:GetItem( nNewItem ):Disabled)
		  oStatus:oMenu := oNewMenu
		  PopChild( nNewLevel, oTopMenu )
		  oStatus:oMenu:Select( nNewItem )
		  oStatus:oMenu:Display()
		  PushMenu( .T., oTopMenu )
		  ShowMsg( oMsg, .T. )
	       ENDIF

	    ELSEIF ( nNewItem != oNewMenu:Current() )

	       PopChild( oStatus:menuLevel, oTopMenu  )

	       IF ( oStatus:oMenu:GetItem( nNewItem ):Enabled .and. ;
		    !oStatus:oMenu:GetItem( nNewItem ):Disabled )
		  oStatus:oMenu:Select( nNewItem )
		  oStatus:oMenu:Display()
		  PushMenu( .T., oTopMenu )
		  ShowMsg( oMsg, .T. )
	       ENDIF

	    ENDIF

	 ENDIF

      ELSEIF ( nKey == K_DOWN )

	 IF oStatus:oMenu:ClassName == "TOPBARMENU"
	    IF ( PushMenu( .T., oTopMenu ) )
	       ShowMsg( oMsg, .T. )
	    ENDIF
	 ELSE
	    nTemp := oStatus:oMenu:GetNext()
	    IF ( nTemp == 0 )
	       nTemp := oStatus:oMenu:GetFirst()
	    ENDIF
	    oStatus:oMenu:Select( nTemp )
	    oStatus:oMenu:Display()
	    ShowMsg( oMsg, .T. )

	 ENDIF

      ELSEIF ( nKey == K_UP )

	 IF oStatus:oMenu:ClassName != "TOPBARMENU"
	    nTemp := oStatus:oMenu:GetPrev()
	    IF ( nTemp == 0 )
	       nTemp := oStatus:oMenu:GetLast()
	    ENDIF
	    oStatus:oMenu:Select( nTemp )
	    oStatus:oMenu:Display()
	    ShowMsg( oMsg, .T. )

	 ENDIF

      ELSEIF ( nKey == K_LEFT )
	 IF ( lSubMenu := oStatus:menuLevel > 1 )
	    PopMenu( oTopMenu )
	 ENDIF
	 IF oStatus:oMenu:ClassName == "TOPBARMENU"
	    nTemp := oStatus:oMenu:GetPrev()
	    IF ( nTemp == 0 )
	      nTemp := oStatus:oMenu:GetLast()
	    ENDIF
	    oStatus:oMenu:Select( nTemp )
	    oStatus:oMenu:Display()
	    IF lSubMenu
	       PushMenu( .T., oTopMenu )
	    ENDIF
	 ENDIF
	 ShowMsg( oMsg, .T. )

      ELSEIF ( nKey == K_RIGHT )
	 IF ( lSubMenu := oStatus:menuLevel > 1 )
	    IF !( PopMenu( oTopMenu ) )
	       PopAll()
	    ENDIF
	    PopMenu( oTopMenu )
	 ENDIF

	 IF oStatus:oMenu:ClassName == "TOPBARMENU"
	    nTemp := oStatus:oMenu:GetNext()
	    IF ( nTemp == 0 )
	       nTemp := oStatus:oMenu:GetFirst()
	    ENDIF
	    oStatus:oMenu:Select( nTemp )
	    oStatus:oMenu:Display()
	    IF lSubMenu
	       PushMenu( .T., oTopMenu )
	    ENDIF
	 ENDIF
	 ShowMsg( oMsg, .T. )

      ELSEIF ( nKey == K_ENTER )
	 IF ( PushMenu( .T., oTopMenu ) )
	    ShowMsg( oMsg, .T. )
	 ELSE
	    ShowMsg( oMsg, .F. )
	    nReturn := Execute( oTopMenu )
	    IF ( nReturn != 0 )
	       EXIT
	    ENDIF

	 ENDIF

      ELSEIF ( nKey == K_ESC )
	 IF PopMenu( oTopMenu )
	    oStatus:oMenu:Display()
	    ShowMsg( oMsg, .T. )
	 ELSE

	    IF oStatus:oMenu:ClassName == "POPUPMENU"
	       oStatus:oMenu:Close()
	    ENDIF
	    nReturn := -1
	    EXIT

	 ENDIF

      ELSEIF ( nKey == K_LBUTTONDOWN )
	 IF ( !MHitTest( @oNewMenu, @nNewLevel, @nNewItem, oTopMenu ) )
	    IF ( !( GetList == NIL ) .AND. ;
	       HitTest( GetList, MROW(), MCOL(), oMsg ) != 0 )
	       GETACTIVE():ExitState := GE_MOUSEHIT
	       //ReadStats( SNLASTEXIT, GE_MOUSEHIT )
	       IF oStatus:oMenu:ClassName == "POPUPMENU"
		  PopMenu( oTopMenu )
	       ENDIF
	       nReturn := -1
	       EXIT
	    ENDIF

	    IF oStatus:oMenu:ClassName == "POPUPMENU"
	       PopMenu( oTopMenu )
	    ENDIF

	 ELSEIF ( nNewLevel == oStatus:menuLevel )
	    oStatus:oMenu:Select( nNewItem )
	    oStatus:oMenu:Display()
	    PushMenu(.T., oTopMenu )
	    ShowMsg( oMsg, .T. )

	 ELSE
	    oStatus:menuLevel := nNewLevel
	    oStatus:oMenu      := ;
	    oStatus:menuList[ oStatus:menuLevel ]

	    nMenuItem := oStatus:oMenu:Current
	    oMenuItem := oStatus:oMenu:GetItem( nMenuItem )
	    IF ( ( oMenuItem := ;
	       oStatus:oMenu:GetItem( ;
	       oStatus:oMenu:Current ) ):IsPopUp() )
	       oMenuItem:Data:Close()
	    ENDIF

	    IF !( nMenuItem == nNewItem )
	       nMenuItem    := nNewItem
	       oStatus:oMenu:Select( nNewItem )
	       oStatus:oMenu:Display()
	       PushMenu( .T., oTopMenu )
	    ENDIF

	    ShowMsg( oMsg, .T. )
	 ENDIF

	 lLeftDown := .T.

      ELSEIF ( nKey == K_LBUTTONUP )
	 lLeftDown := .F.
	 IF ( !MHitTest( @oNewMenu, @nNewLevel, @nNewItem, oTopMenu ) )
	 ELSEIF ( nNewLevel == oStatus:menuLevel )
	    IF ( nNewItem == oStatus:oMenu:Current )
	       ShowMsg( oMsg, .F.)
	       nReturn := Execute( oTopMenu )
	       IF ( nReturn != 0 )
		  EXIT
	       ENDIF
	    ENDIF

	 ENDIF

      ELSEIF ( ( nNewItem := oStatus:oMenu:GetAccel( nKey ) ) != 0 )
	 IF oStatus:oMenu:GetItem( nNewItem ):Enabled .and. ;
	    !oStatus:oMenu:GetItem( nNewItem ):Disabled

	    oStatus:oMenu:Select( nNewItem )
	    oStatus:oMenu:Display()

	    IF ( !PushMenu( .T., oTopMenu ) )
	       ShowMsg( oMsg, .F. )
	       nReturn := Execute( oTopMenu )
	       IF ( nReturn != 0 )
		  EXIT
	       ENDIF
	    ENDIF
	    ShowMsg( oMsg, .T. )

	 ENDIF

      ELSEIF ( IsShortCut( oTopMenu, nKey, @nReturn ) )

	 IF ( nReturn != 0 )
	    EXIT
	 ENDIF

      ELSEIF ( !( GetList == NIL ) .AND. ;
	 ( ( nNewItem := Accelerator( GetList, nKey, oMsg ) ) != 0 ) )
	 GETACTIVE():ExitState := GE_SHORTCUT
	 //ReadStats( SNNEXTGET, nNewItem )
	 IF oStatus:oMenu:ClassName == "POPUPMENU"
	    PopMenu( oTopMenu )
	 ENDIF
	 nReturn := -1
	 EXIT

      ELSEIF ( ( nNewItem := oTopMenu:GetAccel( nKey ) ) != 0 )
	 IF oTopMenu:GetItem( nNewItem ):Enabled .and. ;
	    !oTopMenu:GetItem( nNewItem ):Disabled

	    PopAll( oTopMenu )
	    oStatus:oMenu:Select( nNewItem )
	    oStatus:oMenu:Display()
	    IF ( oTopMenu:GetItem( nNewItem ):IsPopUp() )
	       PushMenu( .T., oTopMenu )
	    ELSE
	       ShowMsg( oMsg, .F. )
	       nReturn := Execute( oTopMenu )
	       IF ( nReturn != 0 )
		  EXIT
	       ENDIF
	    ENDIF
	    ShowMsg( oMsg, .T. )
	 ENDIF

      ENDIF

   ENDDO

   IF ( oMsg:flag )
      RestScreen( oMsg:row, oMsg:left, oMsg:row, ;
		  oMsg:right, oStatus:scrVmsg )
   ENDIF

   PopAll( oTopMenu )
   SetPos( nRow, nCol )
   SetCursor( lSaveCursor )

   for k in aSavMenuSys KEYS
	   oStatus[k] := aSavMenuSys[k]
   next

RETURN ( nReturn )

*********************************************
STATIC FUNCTION PushMenu( lSelect, oTopMenu )
   LOCAL oNewMenu

   oNewMenu := oStatus:oMenu:GetItem( oStatus:oMenu:Current )

   IF ( !( ValType( oNewMenu ) == "O" ) )
   ELSEIF ( oNewMenu:IsPopUp() )

      IF ( !( ValType( lSelect ) == "L" ) )
	 lSelect := .F.
      ENDIF

      oStatus:oMenu := oNewMenu:Data
      oStatus:menuList[ ++oStatus:menuLevel ] := ;
				 oStatus:oMenu

      IF ( lSelect )
	 oStatus:oMenu:Select( oStatus:oMenu:GetFirst() )
      ELSE
	 oStatus:oMenu:Select( 0 )
      ENDIF

      IF !( oStatus:oMenu:IsOpen )
	 oStatus:oMenu:Open()
      ENDIF

      RETURN ( .T. )

   ENDIF

RETURN ( .F. )

***********************************************
STATIC FUNCTION PopMenu( oTopMenu )
   IF ( oStatus:menuLevel > 1 )
      oStatus:oMenu:Select(0)
      oStatus:oMenu:Close(.T.)
      oStatus:oMenu := ;
	 oStatus:menuList[ --oStatus:menuLevel ]
      RETURN ( .T. )
   ENDIF
RETURN ( .F. )


***********************************************
STATIC FUNCTION PopChild( nNewLevel, oTopMenu )
   LOCAL oOldMenuItem, nCurrent

   IF ( ( nCurrent := oStatus:oMenu:Current ) != 0 )
      oOldMenuItem := oStatus:oMenu:GetItem( nCurrent )
      IF ( oOldMenuItem:IsPopUp() )
	 oOldMenuItem:Data:Close()
	 oStatus:menuLevel := nNewLevel
	 RETURN ( .T. )
      ENDIF
   ENDIF
RETURN ( .F. )


***********************************************
STATIC FUNCTION PopAll( oTopMenu )
   IF oStatus:menuList[2] != NIL
      oStatus:menuList[2]:Close()
   ENDIF
   oStatus:menuLevel := 1
   oStatus:oMenu      := oStatus:menuList[ 1 ]
RETURN ( .T. )


***********************************************
STATIC FUNCTION Execute( oTopMenu )
   LOCAL oNewMenu, nCurrent := 0, i, lPas := .T.
   LOCAL nOldRow, nOldCol, nOldCursor

   oNewMenu := oStatus:oMenu:GetItem( oStatus:oMenu:Current )

   IF ( !( ValType( oNewMenu ) == "O" ) )
   ELSEIF ( !oNewMenu:IsPopUp() )
      IF ( oStatus:oMenu:ClassName == "TOPBARMENU" )
	 nOldRow    := oStatus:oldRow
	 nOldCol    := oStatus:oldCol
	 nOldCursor := oStatus:oldCursor
	 SETPOS( oStatus:oldRow, oStatus:oldCol )
	 SETCURSOR( oStatus:oldCursor )
	 nCurrent := oStatus:oMenu:Current
	 EVAL( oNewMenu:Data, oNewMenu )
	 oStatus:oMenu:Select( nCurrent )
	 SETCURSOR( SC_NONE )
	 lPas := .F.
      ELSEIF ( oStatus:oMenu:ClassName == "POPUPMENU" )
	 do while popMenu(oNewMenu)
	 enddo
	 nOldRow    := oStatus:oldRow
	 nOldCol    := oStatus:oldCol
	 nOldCursor := oStatus:oldCursor
	 SETPOS( oStatus:oldRow, oStatus:oldCol )
	 SETCURSOR( oStatus:oldCursor )
	 nCurrent := oStatus:oMenu:Current
	 EVAL( oNewMenu:Data, oNewMenu )
	 oStatus:oMenu:Select( nCurrent )
	 SETCURSOR( SC_NONE )
	 lPas := .F.
      ENDIF

      IF PopMenu( oTopMenu )
	 nCurrent := oStatus:oMenu:Current
      ENDIF

      oStatus:oMenu:Select( nCurrent )
      IF ( oStatus:oMenu:ClassName == "POPUPMENU" .AND. ;
	 oStatus:menuLevel == 1 .AND. !oStatus:oMenu:IsOpen )
	 oStatus:oMenu:Open()
      ENDIF

      IF lPas
	 do while popMenu(oNewMenu)
	 enddo
	 nOldRow    := oStatus:oldRow
	 nOldCol    := oStatus:oldCol
	 nOldCursor := oStatus:oldCursor
	 SETPOS( oStatus:oldRow, oStatus:oldCol )
	 SETCURSOR( oStatus:oldCursor )
	 nCurrent := oStatus:oMenu:Current
	 EVAL( oNewMenu:Data, oNewMenu )
	 oStatus:oMenu:Select( nCurrent )
	 SETCURSOR( SC_NONE )

      ENDIF
      RETURN ( oNewMenu:Id )
   ENDIF
RETURN ( 0 )


***********************************************
STATIC FUNCTION MHitTest( oNewMenu, nNewLevel, nNewItem, oTopMenu )

   FOR nNewLevel := oStatus:menuLevel TO 1 STEP -1
      oNewMenu   := oStatus:menuList[ nNewLevel ]
      nNewItem   := oNewMenu:HitTest( mRow(), mCol() )
      IF ( nNewItem < 0 )
	 RETURN ( .F. )

      ELSEIF ( nNewItem > 0 ) .AND. ;
		oNewMenu:GetItem( nNewItem ):Enabled .and. ;
		!oNewMenu:GetItem( nNewItem ):Disabled
	 RETURN ( .T. )
      ENDIF
   NEXT
RETURN ( .F. )

****************************************
FUNCTION ShowMsg( oMsg, lMode )
   LOCAL nCurrent, lColorFlag, cMsg := NIL
   LOCAL cSaveColor := SetColor()
   LOCAL mlOldState := MSetCursor( .F. )

   IF ( ValType( oStatus:oldMsgFlag ) == "L" .AND.  oStatus:oldMsgFlag )
      RestScreen( oMsg:row, oMsg:left, oMsg:row, oMsg:right, oStatus:scrVmsg )
   ENDIF
   IF lmode
      IF !( lColorFlag    := ( ValType( oMsg:color ) == "C" ) )
	 oMsg:color := GetClrPair( SetColor(), 1 )
      ENDIF

      IF ( ( oMsg:flag ) .AND. ( nCurrent := oStatus:oMenu:Current ) != 0 )
	 IF !EMPTY( cMsg := oStatus:oMenu:GetItem( nCurrent ):Message )
	    @ oMsg:row, oMsg:left ;
	    SAY PadC( cMsg, oMsg:right - oMsg:left + 1 ) ;
	    COLOR oMsg:color
	 ENDIF
      ENDIF
      oStatus:oldMessage := cMsg
      oStatus:oldMsgFlag := oMsg:flag
   ENDIF
   MSetCursor( mlOldState )
RETURN ( .T. )


***********************************************
FUNCTION IsShortCut( oMenu, nKey, nID )
   LOCAL nItem, nTotal, nShortCut, oItem, i

   IF !( oMenu:ClassName == "TOPBARMENU" )
      RETURN ( IsQuick( oMenu, nKey, @nID ) )

   ELSEIF ( ( nShortCut := oMenu:GetShortCt( nKey ) ) > 0 ) .AND. ;
	    ( ( oItem := oMenu:GetItem( nShortcut ) ):Enabled .and. ;
		!oItem:Disabled ) .AND. ;
	    ( !( oItem:IsPopUp() ) )
      oMenu:Select( nShortCut )
      EVAL( oItem:Data, oItem )
      nID := oItem:ID
      RETURN ( .T. )

   ELSEIF ( nShortCut == 0 )
      nTotal := oMenu:ItemCount()
      nItem  := oMenu:Current
      nItem  := IIF( nItem == 0, nItem := 1, nItem )

      FOR i := 1 TO nTotal
	 IF ( !( oItem := oMenu:GetItem( nItem ) ):Enabled .or. oItem:Disabled)
	 ELSEIF ( !oItem:IsPopUp() )
	 ELSEIF ( IsQuick( oItem:Data, nKey, @nID ) )
	    RETURN ( .T. )
	 ENDIF
	 nItem := IIF( ++nItem > nTotal, nItem := 1, nItem )
      NEXT

   ENDIF
RETURN ( .F. )


***********************************************
FUNCTION IsQuick( oMenu, nKey, nID )
   LOCAL nItem, nTotal, nShortCut, oItem, i

   IF ( ( nShortCut := oMenu:GetShortCt( nKey ) ) == 0 )
      nTotal := oMenu:ItemCount()

      FOR nItem := 1 TO nTotal
	 IF ( !( oItem := oMenu:GetItem( nItem ) ):Enabled .or. oItem:Disabled )
	 ELSEIF ( !( oItem:IsPopUp() ) )
	 ELSEIF ( IsQuick( oItem:Data, nKey, @nID ) )
	    RETURN ( .T. )
	 ENDIF
      NEXT

   ELSEIF ( !( oItem := oMenu:GetItem( nShortCut ) ):IsPopUp() )
      IF oItem:Enabled .and. !oItem:Disabled
	 oMenu:Select( nShortCut )
	 EVAL( oItem:Data, oItem )
	 nID := oItem:ID
	 RETURN ( .T. )
      ENDIF

   ENDIF

RETURN ( .F. )

****************************************
procedure menusysInit()
   if oStatus==NIL
	oStatus:=map()
	oStatus:menuList     := NIL
	oStatus:menuLevel    := NIL
	oStatus:oMenu        := NIL
	oStatus:oldMessage   := NIL
	oStatus:scrVmsg      := NIL
	oStatus:oldMsgFlag   := NIL
	oStatus:oldRow       := row()
	oStatus:oldCol       := col()
	oStatus:oldCursor    := SC_NORMAL
   endif
return
