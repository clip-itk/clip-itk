/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "button.ch"
#include "getexit.ch"
#include "inkey.ch"
#include "llibg.ch"
#include "set.ch"
#include "setCurs.ch"
#include "tbrowse.ch"

#define K_UNDO          K_CTRL_U
#define CTRL_END_SPECIAL

#ifndef SETCURSOR_IN_GETSYS
	#xdefine setcursor __setcursorempty
#endif

#define _GET_INSERT_ON   7     // "Ins"
#define _GET_INSERT_OFF  8     // "   "
#define _GET_INVD_DATE   9     // "Invalid Date"
#define _GET_RANGE_FROM  10    // "Range: "
#define _GET_RANGE_TO    11    // " - "

STATIC oStatus
static aGetList
static keyExit:=15

****************************************
FUNCTION ReadModal( _GetList, nPos, oMenu, nMsgRow, nMsgLeft, ;
					  nMsgRight, cMsgColor )
   LOCAL oGet, aMode, oMsg
   LOCAL aSavGetSysVars
   LOCAL cMsg := NIL
   LOCAL nSaveCursor

   if oStatus==NIL
      __getSysInit()
   endif
   private getlist := {}

   IF ( VALTYPE( oStatus:format ) == "B" )
      EVAL( oStatus:format )
   ENDIF

   IF ( EMPTY( _GetList ) )
      SETPOS( MAXROW() - 1, 0 )
      RETURN (.F.)
   ENDIF

   nSaveCursor := SETCURSOR( SC_NONE )
   aSavGetSysVars := ClearGetSysVars()
   oStatus:svccursor := SETCURSOR( SC_NONE )

   oStatus:procname := PROCNAME( 1 )
   oStatus:procline := PROCLINE( 1 )

   oMsg := map()
   oMsg:flag := NIL
   oMsg:row  := nMsgRow
   oMsg:left := nMsgLeft
   oMsg:right:= nMsgRight
   oMsg:color:= cMsgColor
   oMsg:back1:= NIL
   oMsg:back2:= NIL
   oMsg:fore := NIL
   oMsg:fontcol:= NIL
   oMsg:fontrow:= NIL

   IF ( VALTYPE( nPos ) == "N" )
      oStatus:pos := Settle( _GetList, nPos, .T. )
   ELSE
      oStatus:pos := Settle( _GetList, 0, .T. )
   ENDIF

   IF ( oMsg:flag :=  ( VALTYPE( oMsg:row   ) + ;
			      VALTYPE( oMsg:left ) + ;
			      VALTYPE( oMsg:right ) == "NNN" ) )

      IF !( VALTYPE( oMsg:color ) == "C" )
	 oMsg:color := GetClrPair( SetColor(), 1 )
      ENDIF

      @ oMsg:row, oMsg:left CLEAR TO ;
	oMsg:row, oMsg:right

      oStatus:scrvmsg := SaveScreen( oMsg:row, ;
	   oMsg:left, oMsg:row, oMsg:right )

   ENDIF

   oStatus:nextget := 0
   oStatus:hitcode := 0
   oStatus:menuid  := 0

   WHILE !( oStatus:pos == 0 )

      oGet := _GetList[ oStatus:pos ]
      aGetList := _GetList
	 PostActiveGet( oGet )

      IF ( VALTYPE( oGet:reader ) == "B" )
	 EVAL( oGet:reader, oGet, _GetList, oMenu, oMsg )
      ELSE
	 GetReader( oGet, _GetList, oMenu, oMsg ) // Use standard reader
      ENDIF
      oStatus:pos := Settle( _GetList, oStatus:pos, .F. )

   ENDDO

   RestoreGetSysVars( aSavGetSysVars )
   SETPOS( MAXROW() - 1, 0 )
   SETCURSOR( oStatus:svccursor )
RETURN ( oStatus:updated )


***********************************************
PROCEDURE GetReader( oGet, GetList, oMenu, oMsg )
   LOCAL nKey, nRow, nCol, nCursor

   IF ( oStatus:lastexit == GE_SHORTCUT .OR. ;
	oStatus:lastexit == GE_MOUSEHIT .OR. ;
	GetPreValidate( oGet, oMsg ) )

      ShowGetMsg( oGet, oMsg )

      oStatus:hitcode  := 0
      oGet:setFocus()

      WHILE ( oGet:exitState == GE_NOEXIT .AND. !oStatus:killread )

#ifdef __________
	 IF ( oGet:typeOut )
	    oGet:exitState := GE_ENTER
	 endif
#else
	 IF ( oGet:typeOut )
	    //  oGet:exitState := GE_ENTER

	    IF oStatus:Pos = NIL
	      oGet:exitState := GE_ENTER
	    ELSE
	      IF oStatus:LastExit = GE_UP
		IF oStatus:Pos-1 == 0
		  oGet:exitState := GE_ENTER
		ELSE
		  oGet:exitState := GE_UP
		ENDIF
	      ELSE
		oGet:exitState := GE_ENTER
	      ENDIF

	    ENDIF

	 ENDIF
#endif
	 WHILE ( oGet:exitState == GE_NOEXIT .AND. !oStatus:killread )
	    SETCURSOR( IIF( oStatus:svccursor == SC_NONE, ;
		 SC_NORMAL, oStatus:svccursor ) )
	    nKey := INKEY( 0 )
	    SETCURSOR( SC_NONE )
	    GetApplyKey( oGet, nKey, GetList, oMenu, oMsg )
	    nRow := ROW()
	    nCol := COL()
	    ShowGetMsg( oGet, oMsg )
	    DevPos( nRow, nCol )
	 ENDDO

	 IF oStatus:lastexit == GE_SHORTCUT
	 ELSEIF oStatus:lastexit == GE_MOUSEHIT
	 ELSEIF ( !GetPostValidate( oGet, oMsg ) )
	    oGet:exitState := GE_NOEXIT
	 ENDIF

      ENDDO
      oStatus:lastexit := 0

      nRow    := ROW()
      nCol    := COL()
      nCursor := SETCURSOR()
      oGet:killFocus()
      SETCURSOR( nCursor )
      SETPOS( nRow, nCol )

      EraseGetMsg( oGet, oMsg )
   ENDIF
RETURN


***********************************************
PROCEDURE GUIReader( oGet, GetList, oMenu, oMsg )
   LOCAL oGUI, nKey := 0, nRow, nCol

   IF ( VALTYPE( oGet:Control ) == "O" ) .AND. ;
	oStatus:lastexit == GE_SHORTCUT .OR. ;
	oStatus:lastexit == GE_MOUSEHIT .OR. ;
	GetPreValidate( oGet, oMsg )

      ShowGetMsg( oGet, oMsg )
      oStatus:lastexit := 0

      oGUI := oGet:Control
      oGUI:Select( oGet:VarGet() )
      oGUI:setFocus()

      IF oGet:exitState == GE_NOEXIT

	 IF ( oStatus:hitcode > 0 )
	    oGUI:Select( oStatus:hitcode )

	 ELSEIF ( oStatus:hitcode == HTCAPTION )
	    oGUI:Select()

	 ELSEIF ( oStatus:hitcode == HTCLIENT )
	    oGUI:Select( K_LBUTTONDOWN )

	 ELSEIF ( oStatus:hitcode == HTDROPBUTTON )
	    oGUI:Open()

	 ELSEIF ( ( oStatus:hitcode >= HTSCROLLFIRST ) .AND. ;
		  ( oStatus:hitcode <= HTSCROLLLAST ) )
	    oGUI:Scroll( oStatus:hitcode )
	 ENDIF

      ENDIF

      oStatus:hitcode := 0

      WHILE ( oGet:exitState == GE_NOEXIT .AND. !oStatus:killread )

	 IF ( oGUI:typeOut )
	    oGet:exitState := GE_ENTER
	 ENDIF

	 WHILE ( oGet:exitState == GE_NOEXIT .AND. !oStatus:killread )
	    GUIApplyKey( oGet, oGUI, GetList, INKEY(0), oMenu, oMsg )
	    ShowGetMsg( oGet, oMsg )
	    DevPos( nRow, nCol )
	 ENDDO

	 IF     oStatus:lastexit  == GE_SHORTCUT
	 ELSEIF oStatus:lastexit  == GE_MOUSEHIT
	 ELSEIF ( !GetPostValidate( oGet, oMsg ) )
	    oGet:exitState := GE_NOEXIT
	 ENDIF

      ENDDO

      IF ( ( oGUI:ClassName() $ "LISTBOX_RADIOGROUP" ) .AND. ;
	 VALTYPE( oGet:VarGet() ) == "N" )
	 oGet:VarPut( oGUI:Value )
      ELSE
	 oGet:VarPut( oGUI:Buffer )
      ENDIF
      oGUI:killFocus()

      EraseGetMsg( oGet, oMsg )

      IF !( oGUI:ClassName() == "LISTBOX" )
      ELSEIF ( !oGUI:DropDown )
      ELSEIF ( oGUI:IsOpen )
	 oGUI:Close()
      ENDIF
   ENDIF
RETURN


***********************************************
PROCEDURE TBReader( oGet, GetList, oMenu, oMsg )
   LOCAL oTB, nKey, lAutoLite, nCell, nSaveCursor, nProcessed
   LOCAL nRow, nCol

   IF ( VALTYPE( oGet:Control ) == "O" ) .AND. ;
	oStatus:lastexit == GE_SHORTCUT .OR. ;
	oStatus:lastexit == GE_MOUSEHIT .OR. ;
	GetPreValidate( oGet, oMsg )

      ShowGetMsg( oGet, oMsg )
      oStatus:lastexit := 0

      nSaveCursor := SetCursor( SC_NONE )

      oTB := oGet:Control

      lAutoLite := oTB:Autolite
      oTB:Autolite := .T.
      oTB:Hilite()

      IF oGet:exitState == GE_NOEXIT
	 IF ( oStatus:hitcode == HTCELL )
	    oTB:RowPos := oTb:mRowPos
	    oTB:ColPos := oTb:mColPos
	    oTB:Invalidate()
	 ENDIF
      ENDIF

      oStatus:hitcode := 0

      WHILE ( oGet:exitState == GE_NOEXIT .AND. !oStatus:killread )

	 WHILE ( oGet:exitState == GE_NOEXIT .AND. !oStatus:killread )
	    nKey := 0

	    WHILE ( !( oTB:Stabilize() ) .AND. ( nKey == 0 ) )
	       nKey := INKEY()
	    ENDDO

	    IF ( nKey == 0 )
	       nKey := INKEY(0)
	    ENDIF

	    nProcessed := oTB:ApplyKey( nKey )
	    IF ( nProcessed == TBR_EXIT )
	       oGet:exitState := GE_ESCAPE
	       EXIT

	    ELSEIF ( nProcessed == TBR_EXCEPTION )
	       TBApplyKey( oGet, oTB, GetList, nKey, oMenu, oMsg )
	       ShowGetMsg( oGet, oMsg )
	    ENDIF

	 ENDDO

	 IF     oStatus:lastexit  == GE_SHORTCUT
	 ELSEIF oStatus:lastexit  == GE_MOUSEHIT
	 ELSEIF ( !GetPostValidate( oGet, oMsg ) )
	    oGet:exitState := GE_NOEXIT
	 ENDIF

      ENDDO

      oTB:Autolite := lAutoLite
      oTB:DeHilite()
      EraseGetMsg( oGet, oMsg )
      SetCursor( nSaveCursor )
   ENDIF
RETURN


/*************/
FUNCTION HitTest( GetList, MouseRow, MouseCol, oMsg )
   LOCAL nCount, nTotal, lGUI

   oStatus:nextget := 0
   nTotal  := LEN( GetList )

   FOR nCount := 1 TO nTotal
      IF ( ( oStatus:hitcode := ;
	 GetList[ nCount ]:HitTest( MouseRow, MouseCol ) ) != HTNOWHERE )
	 oStatus:nextget := nCount
	 EXIT
      ENDIF
   NEXT

   IF !( oStatus:nextget == 0 )
      lGUI := ( VALTYPE( Getlist[ oStatus:pos ]:Control ) == "O" )
      IF lGUI .AND. !( GUIPostValidate( GetList[ oStatus:pos ], ;
		GetList[ oStatus:pos ]:Control, oMsg  ) )
	 oStatus:nextget := 0
	 RETURN 0
      ELSEIF !lGUI .AND. !( GetPostValidate( GetList[ oStatus:pos ], ;
	 oMsg ) )
	 oStatus:nextget := 0
	 RETURN 0
      ENDIF

      lGUI := ( VALTYPE( Getlist[ oStatus:nextget ]:Control ) == "O" )
      IF lGUI .AND. !( GUIPreValidate( GetList[ oStatus:nextget ], ;
		GetList[ oStatus:nextget ]:Control, oMsg  ) )
	 oStatus:nextget := 0
	 RETURN oStatus:nextget
      ELSEIF !lGUI .AND. !( GetPreValidate( GetList[ oStatus:nextget ], ;
	 oMsg ) )
	 oStatus:nextget := 0
	 RETURN oStatus:nextget
      ENDIF
      RETURN oStatus:nextget
   ENDIF

RETURN 0

***********************************************
FUNCTION Accelerator( GetList, nKey, oMsg )
   LOCAL nGet, oGet, nHotPos, cKey, cCaption, nStart, nEnd
   LOCAL nIteration, lGUI

      IF ( ( nKey >= K_ALT_Q ) .AND. ( nKey <= K_ALT_P ) )
	 cKey := SUBSTR( "qwertyuiop", nKey - K_ALT_Q + 1, 1 )

      ELSEIF ( ( nKey >= K_ALT_A ) .AND. ( nKey <= K_ALT_L ) )
	 cKey := SUBSTR( "asdfghjkl", nKey - K_ALT_A + 1, 1 )

      ELSEIF ( ( nKey >= K_ALT_Z ) .AND. ( nKey <= K_ALT_M ) )
	 cKey := SUBSTR( "zxcvbnm", nKey - K_ALT_Z + 1, 1 )

      ELSEIF ( ( nKey >= K_ALT_1 ) .AND. ( nKey <= K_ALT_0 ) )
	 cKey := SUBSTR( "1234567890", nKey - K_ALT_1 + 1, 1 )

      ELSE
	 RETURN ( 0 )

      ENDIF

      nStart := oStatus:pos + 1
      nEnd   := LEN( GetList )

      FOR nIteration := 1 TO 2
	 FOR nGet := nStart TO nEnd
	    oGet  := GetList[ nGet ]

	    IF ( VALTYPE( oGet:Control ) == "O" .AND. ;
			  oGet:Control:ClassName() != "TBROWSE" )
	       cCaption := oGet:Control:Caption
	    ELSEIF "CAPTION" $ oGet
	       cCaption := oGet:Caption
	    else
		cCaption := ""
	    ENDIF

	    IF ( ( nHotPos := AT( "&", cCaption ) ) == 0 )
	    ELSEIF ( nHotPos == LEN( cCaption ) )
	    ELSEIF ( LOWER( SUBSTR( cCaption, nHotPos + 1, 1 ) ) == cKey )

		lGUI := ( VALTYPE( Getlist[ oStatus:pos ]:Control ) == "O" )
		IF lGUI .AND. !( GUIPostValidate( GetList[ oStatus:pos ], ;
		    GetList[ oStatus:pos ]:Control, oMsg  ) )
		    RETURN 0
		ELSEIF !lGUI .AND. !( GetPostValidate( GetList[ oStatus:pos ], ;
		       oMsg ) )
		       RETURN 0
		ENDIF

		lGUI := ( VALTYPE( oGet:Control ) == "O" )
		IF lGUI .AND. !( GUIPreValidate( oGet, oGet:Control, oMsg  ) )
		    RETURN nGet
		ELSEIF !lGUI .AND. !( GetPreValidate( oGet, oMsg ) )
		    RETURN nGet
		ENDIF

		RETURN ( nGet )
	    ENDIF
	 NEXT

	 nStart := 1
	 nEnd   := oStatus:pos - 1

      NEXT
RETURN ( 0 )


***********************************************
PROCEDURE GetApplyKey( oGet, nKey, GetList, oMenu, oMsg )

   LOCAL cKey
   LOCAL bKeyBlock
   LOCAL MouseRow, MouseColumn
   LOCAL nButton
   LOCAL nHotItem
   LOCAL lSetKey

   IF "SETKEY" $ oget .and. !( ( bKeyBlock := oget:SETKEY( nKey ) ) == NIL )
      IF valtype( nKey:=eval( bKeyBlock, oGet, nKey ) ) != "N" .or. nkey == 0
	 RETURN
      ENDIF
   ENDIF

   IF !( ( bKeyBlock := SETKEY( nKey ) ) == NIL )
      IF ( lSetKey := GetDoSetKey( bKeyBlock, oGet ) )
	 RETURN
      ENDIF
   ENDIF

   IF ( !( GetList == NIL ) .AND. ;
	( ( nHotItem := Accelerator( GetList, nKey, oMsg ) ) != 0 ) )
      oGet:ExitState := GE_SHORTCUT
      oStatus:nextget  := nHotItem
      oStatus:lastexit := GE_SHORTCUT

   ELSEIF ( !( VALTYPE( oMenu ) == "O" ) )
   ELSEIF ( ( nHotItem := oMenu:GetAccel( nKey ) ) != 0 )
      oStatus:menuid := MenuModal( oMenu, nHotItem, ;
      oMsg:row, oMsg:left, oMsg:right, oMsg:color )
      nKey := 0

   ELSEIF ( IsShortCut( oMenu, nKey )  )
      nKey := 0

   ENDIF

   DO CASE
   CASE( nKey == K_UP )
      keyExit:=5
      if oGet:classname=="TEXTGET"
	 oget:up()
      else
	 oGet:exitState := GE_UP
      endif

   CASE( nKey == K_SH_TAB )
      keyExit:=5
      oGet:exitState := GE_UP

   CASE( nKey == K_DOWN )
      keyExit:=2
      if oGet:classname=="TEXTGET"
	 oget:down()
      else
	 oGet:exitState := GE_DOWN
      endif

   CASE( nKey == K_TAB )
      keyExit:=2
      oGet:exitState := GE_DOWN

   CASE( nKey == K_ENTER )
      keyExit:=15
      if oGet:classname=="TEXTGET"
	 oget:insertLine()
      else
	 oGet:exitState := GE_ENTER
      endif

   CASE( nKey == K_ESC )
      keyExit:=12
      IF ( SET( _SET_ESCAPE ) )
	 oGet:Undo()
	 oGet:exitState := GE_ESCAPE
      ENDIF

   CASE( nKey == K_PGUP )
      keyExit:=6
      if oGet:classname=="TEXTGET"
	 oget:pgup()
      else
	 oGet:exitState := GE_WRITE
      endif

   CASE( nKey == K_PGDN )
      keyExit:=7
      if oGet:classname=="TEXTGET"
	 oget:pgdn()
      else
	 oGet:exitState := GE_WRITE
      endif

   CASE( nKey == K_CTRL_HOME )
      keyExit:=15
      oGet:exitState := GE_TOP

#ifdef CTRL_END_SPECIAL
   CASE( nKey == K_CTRL_END )
      keyExit:=14
      oGet:exitState := GE_BOTTOM
#else
   CASE( nKey == K_CTRL_W )
      keyExit:=14
      oGet:exitState := GE_WRITE
#endif
   CASE( ( nKey == K_LBUTTONDOWN ) .OR. ( nKey == K_LDBLCLK ) )
      MouseRow    := mROW()
      MouseColumn := mCOL()

      IF ( !( VALTYPE( oMenu ) == "O" ) )
	 nButton := 0

      ELSEIF ( !( oMenu:ClassName() == "TOPBARMENU" ) )
	 nButton := 0

      ELSEIF ( ( nButton := oMenu:HitTest( MouseRow, MouseColumn ) ) != 0 )
	 oStatus:menuid := MenuModal( oMenu, nHotItem, ;  // Changed.
	 oMsg:row, oMsg:left, oMsg:right, oMsg:color )
	 nButton := 1

      ENDIF

      IF ( nButton != 0 )

      ELSEIF ( ( nButton := ;
	 oGet:HitTest( MouseRow, MouseColumn ) ) == HTCLIENT )

	 if oGet:className == "TEXTGET"
		DO WHILE ( oGet:Edit:nLeft+oGet:Edit:ColWin-1 > MouseColumn )
			oGet:Edit:Left()
		ENDDO
		DO WHILE ( oGet:Edit:nLeft+oGet:Edit:ColWin-1 < MouseColumn )
			oGet:Edit:right()
		ENDDO
		DO WHILE ( oGet:Edit:nTop+oGet:Edit:rowWin-1 > MouseRow )
			oGet:Edit:up()
		ENDDO
		DO WHILE ( oGet:Edit:nTop+oGet:Edit:rowWin-1 < MouseRow )
			oGet:Edit:down()
		ENDDO
	 else
		DO WHILE ( oGet:Col + oGet:Pos - 1 > MouseColumn )
			oGet:Left()
			IF oGet:typeOut
				oGet:Home()
				EXIT
			ENDIF
		ENDDO

		DO WHILE ( oGet:Col + oGet:Pos - 1 < MouseColumn )
			oGet:Right()
			IF oGet:typeOut
				oGet:End()
				EXIT
			ENDIF
		ENDDO
	 endif

      ELSEIF !( nButton == HTNOWHERE )
      ELSEIF ( !( GetList == NIL ) .AND. ;
	 HitTest( GetList, MouseRow, MouseColumn, oMsg ) != 0 )
	 oGet:exitstate := GE_MOUSEHIT
	 oStatus:lastexit := GE_MOUSEHIT
      ELSE
	 oGet:exitstate := GE_NOEXIT
      ENDIF

   CASE( nKey == K_UNDO )
      oGet:Undo()

   CASE( nKey == K_HOME )
      oGet:Home()

   CASE( nKey == K_END )
      oGet:End()

   CASE( nKey == K_RIGHT )
      oGet:Right()

   CASE( nKey == K_LEFT )
      oGet:Left()

   CASE( nKey == K_CTRL_RIGHT )
      oGet:wordRight()

   CASE( nKey == K_CTRL_LEFT )
      oGet:wordLeft()

   CASE( nKey == K_BS )
      oGet:BackSpace()

   CASE( nKey == K_DEL )
      oGet:Delete()

   CASE( nKey == K_CTRL_T )
      oGet:delWordRight()

   CASE( nKey == K_CTRL_Y )
      oGet:delEnd()

   CASE( nKey == K_CTRL_BS )
      oGet:delWordLeft()

   CASE( nKey == K_INS )
      SET( _SET_INSERT, !SET( _SET_INSERT ) )
      ShowScoreboard()

   OTHERWISE

      IF ( nKey >= 32 .AND. nKey <= 255 )

	 cKey := CHR( nKey )

	 IF ( oGet:type == "N" .AND. ( cKey == "." .OR. cKey == "," ) )
	    oGet:toDecPos()
	 ELSE

	    IF ( SET( _SET_INSERT ) )
	       oGet:Insert( cKey )
	    ELSE
	       oGet:OverStrike( cKey )
	    ENDIF

	    IF ( oGet:typeOut )
	       IF ( SET( _SET_BELL ) )
		  ?? CHR(7)
	       ENDIF

	       IF ( !SET( _SET_CONFIRM ) )
		  keyExit:=15
		  oGet:exitState := GE_ENTER
	       ENDIF
	    ENDIF

	 ENDIF

      ENDIF

   ENDCASE

RETURN


***********************************************
PROCEDURE GUIApplyKey( oGet, oGUI, GetList, nKey, oMenu, oMsg )

   LOCAL cKey
   LOCAL bKeyBlock
   LOCAL MouseRow, MouseColumn
   LOCAL nButton
   LOCAL TheClass
   LOCAL nHotItem
   LOCAL lClose
   LOCAL lSetKey

   IF "SETKEY" $ oget .and.  !( ( bKeyBlock := oget:SETKEY( nKey ) ) == NIL )
      IF valtype( nKey:=eval( bKeyBlock, oGet, nKey ) ) != "N" .or. nkey == 0
	 RETURN
      ENDIF
   ENDIF
   IF ( !( bKeyBlock := SETKEY( nKey ) ) == NIL )
      IF ( lSetKey := GetDoSetKey( bKeyBlock, oGet ) )
	 RETURN
      ENDIF
   ENDIF

   IF ( ( nHotItem := Accelerator( GetList, nKey, oMsg ) ) != 0 )
      oGet:ExitState := GE_SHORTCUT
      oStatus:nextget := nHotItem

   ELSEIF ( !( VALTYPE( oMenu ) == "O" ) )
   ELSEIF ( ( nHotItem := oMenu:GetAccel( nKey ) ) != 0 )
      oStatus:menuid := MenuModal( oMenu, nHotItem, ;
      oMsg:row, oMsg:left, oMsg:right, oMsg:color )
      nKey := 0

   ELSEIF ( IsShortCut( oMenu, nKey )  )
      nKey := 0

   ENDIF

#ifdef __CLIP__
   if nkey==K_LEFT
      oGet:exitState := GE_UP
      nkey:=0
   endif
   if nkey==K_RIGHT
      oGet:exitState := GE_DOWN
      nkey:=0
   endif
#endif

   IF ( nKey == 0 )
   ELSEIF ( ( TheClass := oGUI:ClassName() ) == "RADIOGROUP" )
      IF ( nKey == K_UP )
	 keyExit:=5
	 oGUI:PrevItem()
	 nKey := 0

      ELSEIF ( nKey == K_DOWN )
	 keyExit:=2
	 oGUI:NextItem()
	 nKey := 0

      ELSEIF ( ( nHotItem := oGUI:GetAccel( nKey ) ) != 0 )
	 oGUI:Select( nHotItem )

      ENDIF

      IF VALTYPE( oGet:VarGet() ) == "N"
	 oGet:VarPut( oGui:Value )
      ENDIF

   ELSEIF ( TheClass == "CHECKBOX" )
      IF ( nKey == K_SPACE )
	 oGUI:Select()
      ENDIF

   ELSEIF ( TheClass == "PUSHBUTTON" )
      IF ( nKey == K_SPACE )
	 oGUI:Select( K_SPACE )

      ELSEIF ( nKey == K_ENTER )
	 keyExit:=15
	 oGUI:Select()
	 nKey := 0
      ENDIF

   ELSEIF ( TheClass == "LISTBOX" )
      IF ( nKey == K_UP )
	 keyExit:=5
	 if oGui:isOpen .or. oGui:useArrow
		oGUI:PrevItem()
	 else
		oGet:exitState := GE_UP
	 endif
	 nKey := 0

      ELSEIF ( nKey == K_DOWN )
	 keyExit:=2
	 if oGui:isOpen .or. oGui:useArrow
		oGUI:NextItem()
	 else
		oGet:exitState := GE_DOWN
	 endif
	 nKey := 0

      ELSEIF ( nKey == K_SPACE )
	 IF ( !oGUI:DropDown )
	 ELSEIF ( !oGUI:IsOpen )
	    oGUI:Open()
	    nKey := 0
	 ENDIF

      ELSEIF ( nKey == K_ENTER .and. oGui:isOpen )
		oGui:select()
		oGui:close()
		nkey:=0

      ELSEIF ( nKey == K_ESC .and. oGui:isOpen )
		oGui:close()
		nkey:=0

      ELSEIF ( nKey == K_PGUP .and. oGui:isOpen )
		oGui:prevPage()
		nkey:=0

      ELSEIF ( nKey == K_PGDN .and. oGui:isOpen )
		oGui:nextPage()
		nkey:=0

      ELSEIF ( ( nButton := oGUI:FindText( CHR( nKey ), oGUI:Value + 1, ;
					   .F., .F. ) ) != 0 )
	 oGUI:Select( nButton )

      ENDIF
      IF VALTYPE( oGet:VarGet() ) == "N"
	 oGet:VarPut( oGui:Value )
      ENDIF

   ENDIF

   DO CASE
   CASE( nKey == K_UP )
	 keyExit:=5
      if oGet:classname=="TEXTGET"
	 oget:up()
      else
	 oGet:exitState := GE_UP
      endif

   CASE( nKey == K_SH_TAB )
	 keyExit:=5
      oGet:exitState := GE_UP

   CASE( nKey == K_DOWN )
	 keyExit:=2
      if oGet:classname=="TEXTGET"
	 oget:down()
      else
	 oGet:exitState := GE_DOWN
      endif

   CASE( nKey == K_TAB )
	 keyExit:=2
      oGet:exitState := GE_DOWN

   CASE( nKey == K_ENTER )
	 keyExit:=15
      if oGet:classname=="TEXTGET"
	 oget:insertLine()
      else
	 oGet:exitState := GE_ENTER
      endif
      //oGet:exitState := GE_ENTER

   CASE( nKey == K_ESC )
	 keyExit:=12
      IF ( SET( _SET_ESCAPE ) )
	 oGet:exitState := GE_ESCAPE
      ENDIF

   CASE( nKey == K_PGUP )
	 keyExit:=6
      if oGet:classname=="TEXTGET"
	 oget:pgup()
      else
	 oGet:exitState := GE_WRITE
      endif

   CASE( nKey == K_PGDN )
	 keyExit:=7
      if oGet:classname=="TEXTGET"
	 oget:pgdn()
      else
	 oGet:exitState := GE_WRITE
      endif

   CASE( nKey == K_CTRL_HOME )
	 keyExit:=15
      oGet:exitState := GE_TOP

#ifdef CTRL_END_SPECIAL
   CASE( nKey == K_CTRL_END )
	 keyExit:=14
      oGet:exitState := GE_BOTTOM
#else
   CASE( nKey == K_CTRL_W )
	 keyExit:=14
      oGet:exitState := GE_WRITE

#endif
   CASE( ( nKey == K_LBUTTONDOWN ) .OR. ( nKey == K_LDBLCLK ) )
      MouseRow    := mROW()
      MouseColumn := mCOL()

      IF ( !( VALTYPE( oMenu ) == "O" ) )
	 nButton := 0

      ELSEIF ( !( oMenu:ClassName() == "TOPBARMENU" ) )
	 nButton := 0

      ELSEIF ( ( nButton := oMenu:HitTest( MouseRow, MouseColumn ) ) != 0 )
	 oStatus:menuid := MenuModal( oMenu, nHotItem, ;  // Changed.
	 oMsg:row, oMsg:left, oMsg:right, oMsg:color )
	 nButton := 1

      ENDIF

      lClose := .T.

      IF ( nButton != 0 )
      ELSEIF ( ( nButton := ;
	 oGUI:HitTest( MouseRow, MouseColumn ) ) == HTNOWHERE )
	 IF ( HitTest( GetList, MouseRow, MouseColumn, oMsg ) != 0 )
	    oGet:exitstate := GE_MOUSEHIT
	    oStatus:lastexit := GE_MOUSEHIT
	 ELSE
	    oGet:exitstate := GE_NOEXIT
	 ENDIF

      ELSEIF ( nButton >= HTCLIENT )
	 oGUI:Select( nButton )

      ELSEIF ( nButton == HTDROPBUTTON )
	 IF ( !oGUI:IsOpen )
	    oGUI:Open()
	    lClose := .F.

	 ENDIF

      ELSEIF ( ( nButton >= HTSCROLLFIRST ) .AND. ;
	       ( nButton <= HTSCROLLLAST ) )
	 oGUI:Scroll( nButton )
	 lClose := .F.

      ENDIF

      IF ( !lClose )
      ELSEIF !( TheClass == "LISTBOX" )
      ELSEIF ( !oGUI:DropDown )
      ELSEIF ( oGUI:IsOpen )
	 oGUI:Close()
	 oGUI:Display()
      ENDIF

   ENDCASE

RETURN


***********************************************
PROCEDURE TBApplyKey( oGet, oTB, GetList, nKey, oMenu, oMsg )

   LOCAL cKey
   LOCAL bKeyBlock
   LOCAL MouseRow, MouseColumn
   LOCAL nButton
   LOCAL nHotItem
   LOCAL lSetKey

   IF "SETKEY" $ oget .and.  !( ( bKeyBlock := oget:SETKEY( nKey ) ) == NIL )
      IF ( ( nKey:=eval( bKeyBlock, oGet, nKey ) ) == 0 )
	 RETURN
      ENDIF
   ENDIF
   IF !( ( bKeyBlock := SETKEY( nKey ) ) == NIL )
      IF ( lSetKey := GetDoSetKey( bKeyBlock, oGet ) )
	 RETURN
      ENDIF
   ENDIF

   IF ( ( nHotItem := Accelerator( GetList, nKey, oMsg ) ) != 0 )
      oGet:ExitState := GE_SHORTCUT
      oStatus:nextget := nHotItem

   ELSEIF ( !( VALTYPE( oMenu ) == "O" ) )
   ELSEIF ( ( nHotItem := oMenu:GetAccel( nKey ) ) != 0 )
      oStatus:menuid := MenuModal( oMenu, nHotItem, ;
      oMsg:row, oMsg:left, oMsg:right, oMsg:color )
      nKey := 0

   ELSEIF ( IsShortCut( oMenu, nKey )  )
      nKey := 0

   ENDIF

   DO CASE
   CASE( nKey == K_TAB )
	 keyExit:=2
      oGet:exitState := GE_DOWN

   CASE( nKey == K_SH_TAB )
	 keyExit:=5
      oGet:exitState := GE_UP

   CASE( nKey == K_ENTER )
	 keyExit:=15
      if oGet:classname=="TEXTGET"
	 oget:insertLine()
      else
	 oGet:exitState := GE_ENTER
      endif
      //oGet:exitState := GE_ENTER

   CASE( nKey == K_ESC )
	 keyExit:=12
      IF ( SET( _SET_ESCAPE ) )
	 oGet:exitState := GE_ESCAPE
      ENDIF

#ifdef CTRL_END_SPECIAL
   CASE( nKey == K_CTRL_END )
	 keyExit:=14
      oGet:exitState := GE_BOTTOM
#else
   CASE( nKey == K_CTRL_W )
	 keyExit:=14
      oGet:exitState := GE_WRITE
#endif
   CASE( ( nKey == K_LBUTTONDOWN ) .OR. ( nKey == K_LDBLCLK ) )
      MouseRow    := mROW()
      MouseColumn := mCOL()

      IF ( !( VALTYPE( oMenu ) == "O" ) )
	 nButton := 0

      ELSEIF ( !( oMenu:ClassName() == "TOPBARMENU" ) )
	 nButton := 0

      ELSEIF ( ( nButton := oMenu:HitTest( MouseRow, MouseColumn ) ) != 0 )
	 oStatus:menuid := MenuModal( oMenu, nHotItem, ;  // Changed.
	 oMsg:row, oMsg:left, oMsg:right, oMsg:color )
	 nButton := 1

      ENDIF

      IF ( nButton != 0 )
      ELSEIF ( ( nButton := ;
	 oTB:HitTest( MouseRow, MouseColumn ) ) == HTNOWHERE )
	 IF ( HitTest( GetList, MouseRow, MouseColumn, oMsg ) != 0 )
	    oGet:exitstate := GE_MOUSEHIT
	    oStatus:lastexit := GE_MOUSEHIT
	 ELSE
	    oGet:exitstate := GE_NOEXIT
	 ENDIF
      ENDIF
   ENDCASE

   RETURN


***********************************************
FUNCTION GetPreValidate( oGet, oMsg )

   LOCAL lSavUpdated
   LOCAL lWhen := .T.

   IF !( oGet:preBlock == NIL )
      lSavUpdated := oStatus:updated
      lWhen := EVAL( oGet:preBlock, oGet, oMsg )
      IF !( VALTYPE( oGet:Control ) == "O" ) .AND. !lWhen
	 oGet:Display()
      ENDIF
      ShowScoreBoard()
      oStatus:updated := lSavUpdated
   ENDIF
   IF ( oStatus:killread )
      lWhen := .F.
      oGet:exitState := GE_ESCAPE
   ELSEIF ( !lWhen )
      oGet:exitState := GE_WHEN
   ELSE
      oGet:exitState := GE_NOEXIT
   ENDIF
RETURN ( lWhen )


***********************************************
FUNCTION GetPostValidate( oGet, oMsg )

   LOCAL lSavUpdated
   LOCAL lValid := .T.
   LOCAL nCursor

   IF ( oGet:exitState == GE_ESCAPE )
      RETURN ( .T. )
   ENDIF

   IF ( oGet:badDate() )
      oGet:Home()
      DateMsg()
      ShowScoreboard()
      RETURN ( .F. )
   ENDIF

   IF ( oGet:changed )
      oGet:assign()
      oStatus:updated := .T.
   ENDIF
   nCursor := SETCURSOR()
   oGet:reset()
   SETCURSOR( nCursor )

   IF !( oGet:postBlock == NIL )
      lSavUpdated := oStatus:updated
      IF VALTYPE( oGet:Buffer ) == "C"
	 SETPOS( oGet:row, oGet:Col + LEN( oGet:Buffer ) )
      ENDIF
      lValid := EVAL( oGet:postBlock, oGet, oMsg )
      SETPOS( oGet:row, oGet:Col )
      ShowScoreBoard()
      oGet:updateBuffer()
      oStatus:updated := IIF( oGet:changed, .T., lSavUpdated )
      IF ( oStatus:killread )
	 oGet:exitState := GE_ESCAPE
	 lValid := .T.
      ENDIF
   ENDIF
RETURN ( lValid )


***********************************************
FUNCTION GUIPreValidate( oGet, oGUI, oMsg )

   LOCAL lSavUpdated
   LOCAL lWhen := .T.

   IF !( oGet:preBlock == NIL )
      lSavUpdated := oStatus:updated
      lWhen := EVAL( oGet:preBlock, oGet, oMsg )
      IF ( !( oGUI:ClassName() == "TBROWSE" ) )
	 oGUI:Display()
      ENDIF
      ShowScoreBoard()
      oStatus:updated := lSavUpdated
   ENDIF

   IF ( oStatus:killread )
      lWhen := .F.
      oGet:exitState := GE_ESCAPE
   ELSEIF ( !lWhen )
      oGet:exitState := GE_WHEN
   ELSE
      oGet:exitState := GE_NOEXIT
   ENDIF
RETURN ( lWhen )


***********************************************
FUNCTION GUIPostValidate( oGet, oGUI, oMsg )

   LOCAL lSavUpdated
   LOCAL lValid := .T.
   LOCAL uOldData, uNewData

   IF ( oGet:exitState == GE_ESCAPE )
      RETURN ( .T. )
   ENDIF

   IF ( !( oGUI:ClassName() == "TBROWSE" ) )
      uOldData := oGet:VarGet()
      IF ( oGUI:ClassName() $ "LISTBOX_RADIOGROUP" .AND. ;
	 VALTYPE( oGet:VarGet() ) == "N" )
	 uNewData := oGUI:Value
      ELSE
	 uNewData := oGUI:Buffer
      ENDIF
   ENDIF

   IF ( !( uOldData == uNewData ) )
      oGet:VarPut( uNewData )
      oStatus:updated := .T.
   ENDIF

   IF !( oGet:postBlock == NIL )
      lSavUpdated := oStatus:updated
      lValid := EVAL( oGet:postBlock, oGet, oMsg )
      SETPOS( oGet:row, oGet:Col )
      ShowScoreBoard()
      IF ( !( oGUI:ClassName() == "TBROWSE" ) )
	 oGUI:Select( oGet:VarGet() )
      ENDIF
      oStatus:updated := IIF( oGet:changed, .T., lSavUpdated )
      IF ( oStatus:killread )
	 oGet:exitState := GE_ESCAPE
	 lValid := .T.
      ENDIF
   ENDIF
RETURN ( lValid )


***********************************************
FUNCTION GetDoSetKey( keyBlock, oGet )

   LOCAL lSavUpdated, lSetKey
   IF ( oGet:changed )
      oGet:assign()
      oStatus:updated := .T.
   ENDIF

   lSavUpdated := oStatus:updated

   lSetKey := EVAL( keyBlock, oStatus:procname, ;
			      oStatus:procline, ReadVar() )

   IF ( !( VALTYPE( lSetKey ) == "L" ) )
      lSetKey := .T.
   ENDIF

   ShowScoreboard()
   oGet:updateBuffer()
   oStatus:updated := lSavUpdated
   IF ( oStatus:killread )
      oGet:exitState := GE_ESCAPE
   ENDIF
RETURN lSetKey


***********************************************
STATIC FUNCTION Settle( GetList, nPos, lInit )

   LOCAL nExitState

   IF ( nPos == 0 )
      nExitState := GE_DOWN
   ELSEIF ( nPos > 0 .AND. lInit)
      nExitState := GE_NOEXIT
   ELSE
      nExitState := GetList[ nPos ]:exitState
   ENDIF

   IF ( nExitState == GE_ESCAPE .OR. nExitState == GE_WRITE )
      RETURN ( 0 )
   ENDIF

   IF !( nExitState == GE_WHEN )
      oStatus:lastpos := nPos
      oStatus:bumptop := .F.
      oStatus:bumpbot := .F.
   ELSE
      IF oStatus:lastexit != 0
	 nExitState := oStatus:lastexit
      ELSEIF oStatus:nextget < oStatus:lastpos
	 nExitState := GE_UP
      ELSE
	 nExitState := GE_DOWN
      ENDIF

   ENDIF

   DO CASE
   CASE( nExitState == GE_UP )
      nPos--
   CASE( nExitState == GE_DOWN )
      nPos++
   CASE( nExitState == GE_TOP )
      nPos       := 1
      oStatus:bumptop  := .T.
      nExitState := GE_DOWN
   CASE( nExitState == GE_BOTTOM )
      nPos       := LEN( GetList )
      oStatus:bumpbot  := .T.
      nExitState := GE_UP
   CASE( nExitState == GE_ENTER )
      nPos++
   CASE( nExitState == GE_SHORTCUT )
      RETURN ( oStatus:nextget )
   CASE( nExitState == GE_MOUSEHIT )
      RETURN ( oStatus:nextget )
   ENDCASE

   IF ( nPos == 0 )
      IF ( !( ReadExit() ) .AND. !oStatus:bumpbot )
	 oStatus:bumptop  := .T.
	 nPos       := oStatus:lastpos
	 nExitState := GE_DOWN
      ENDIF

   ELSEIF ( nPos == len( GetList ) + 1 )
      IF ( !( ReadExit() ) .AND. !( nExitState == GE_ENTER ) .AND. ;
	   !oStatus:bumptop )
	 oStatus:bumpbot  := .T.
	 nPos       := oStatus:lastpos
	 nExitState := GE_UP
      ELSE
	 nPos := 0
      ENDIF

   ENDIF

   oStatus:lastexit := nExitState
   IF !( nPos == 0 )
      GetList[ nPos ]:exitState := nExitState
   ENDIF
RETURN ( nPos )

***********************************************
STATIC PROCEDURE PostActiveGet( oGet )
   GetActive( oGet )
   ReadVar( GetReadVar( oGet ) )
   ShowScoreBoard()
RETURN


***********************************************
STATIC FUNCTION ClearGetSysVars()
   LOCAL k, aSavSysVars  := map()

   for k in oStatus KEYS
	 aSavSysVars[k] := oStatus[k]
   next
   aSavSysVars:updated   := .F.
   aSavSysVars:readvar   := READVAR( "" )
   aSavSysVars:activeget := GETACTIVE( NIL )

   oStatus:updated       := .F.
   oStatus:format        := NIL
   oStatus:killread      := .F.
   oStatus:bumptop       := .F.
   oStatus:bumpbot       := .F.
   oStatus:lastexit      := 0
   oStatus:lastpos       := 0
   oStatus:procname  := ""
   oStatus:procline  := 0
   oStatus:nextget       := 0
   oStatus:hitcode       := 0
   oStatus:pos           := 0
   oStatus:scrvmsg      := NIL

   RETURN ( aSavSysVars )


***********************************************
STATIC PROCEDURE RestoreGetSysVars( aSavSysVars )
   LOCAL k,lUpdated         := oStatus:updated
   for k in aSavSysVars KEYS
	oStatus[k] := aSavSysVars[k]
   next
   oStatus:updated := lUpdated
   READVAR( aSavSysVars:readvar )
   GETACTIVE( aSavSysVars:activeget )
RETURN


***********************************************
STATIC FUNCTION GetReadVar( oGet )

   LOCAL cName := UPPER( oGet:name )
   LOCAL i

   IF !( oGet:subscript == NIL )
      FOR i := 1 TO LEN( oGet:subscript )
	 cName += "[" + LTRIM( STR( oGet:subscript[i] ) ) + "]"
      NEXT
   ENDIF
RETURN ( cName )


***********************************************
PROCEDURE __SetFormat( b )
   oStatus:format := IIF( VALTYPE( b ) == "B", b, NIL )
RETURN


***********************************************
PROCEDURE __KillRead()
   oStatus:killread := .T.
RETURN


***********************************************
FUNCTION GetActive( g )
	LOCAL oldActive := oStatus:activeget
	IF ( PCOUNT() > 0 )
		oStatus:activeget := g
	ENDIF
RETURN ( oldActive )
***********************************************
FUNCTION GetFldVar(nField)
	LOCAL name := -1
	local oGet := oStatus:activeget
	if valType(nField) == "N"
		if nField > 0  .and. nField <= len(aGetList)
			oGet := agetList[nField]
		else
			return ( name )
		endif
	endif
	if valtype(oGet) == "O"
		name := oGet:name
	endif
RETURN ( name )
***********************************************
FUNCTION GetActivePos( pos )
   LOCAL oldActive := oStatus:pos
   IF ( PCOUNT() > 0 )
      oStatus:pos := pos
   ENDIF
RETURN ( oldActive )

***********************************************
FUNCTION Updated()
RETURN oStatus:updated

***********************************************
FUNCTION ReadExit( lNew )
RETURN ( SET( _SET_EXIT, lNew ) )

***********************************************
FUNCTION ReadInsert( lNew )
RETURN ( SET( _SET_INSERT, lNew ) )

// Display coordinates for SCOREBOARD
#define SCORE_ROW      0
#define SCORE_COL      60

***********************************************
STATIC PROCEDURE ShowScoreboard()

   LOCAL nRow
   LOCAL nCol

   IF ( SET( _SET_SCOREBOARD ) )
      nRow := ROW()
      nCol := COL()
      SETPOS( SCORE_ROW, SCORE_COL )
      DISPOUT( IIF( SET( _SET_INSERT ), NationMsg( _GET_INSERT_ON ), ;
					NationMsg( _GET_INSERT_OFF ) ) )
      SETPOS( nRow, nCol )
   ENDIF
RETURN

***********************************************
STATIC PROCEDURE DateMsg()

   LOCAL nRow
   LOCAL nCol

   IF ( SET( _SET_SCOREBOARD ) )

      nRow := ROW()
      nCol := COL()

      SETPOS( SCORE_ROW, SCORE_COL )
      DISPOUT( NationMsg( _GET_INVD_DATE ) )
      SETPOS( nRow, nCol )

      WHILE ( NEXTKEY() == 0 )
      ENDDO

      SETPOS( SCORE_ROW, SCORE_COL )
      DISPOUT( SPACE( LEN( NationMsg( _GET_INVD_DATE ) ) ) )
      SETPOS( nRow, nCol )
   ENDIF
RETURN


***********************************************
FUNCTION RangeCheck( oGet, junk, lo, hi )

   LOCAL cMsg, nRow, nCol
   LOCAL xValue

   IF ( !oGet:changed )
      RETURN ( .T. )
   ENDIF

   xValue := oGet:VarGet()

   IF ( xValue >= lo .AND. xValue <= hi )
      RETURN ( .T. )
   ENDIF

   IF ( SET( _SET_SCOREBOARD ) )

      cMsg := NationMsg(_GET_RANGE_FROM) + LTRIM( TRANSFORM( lo, "" ) ) + ;
	      NationMsg(_GET_RANGE_TO) + LTRIM( TRANSFORM( hi, "" ) )

      IF ( LEN( cMsg ) > MAXCOL() )
	 cMsg := SUBSTR( cMsg, 1, MAXCOL() )
      ENDIF

      nRow := ROW()
      nCol := COL()

      SETPOS( SCORE_ROW, MIN( 60, MAXCOL() - LEN( cMsg ) ) )
      DISPOUT( cMsg )
      SETPOS( nRow, nCol )

      WHILE ( NEXTKEY() == 0 )
      ENDDO

      SETPOS( SCORE_ROW, MIN( 60, MAXCOL() - LEN( cMsg ) ) )
      DISPOUT( SPACE( LEN( cMsg ) ) )
      SETPOS( nRow, nCol )

   ENDIF

RETURN ( .F. )


***********************************************
FUNCTION ReadKill( lKill )
   LOCAL lSavKill
   lSavKill := oStatus:killread
   IF ( PCOUNT() > 0 )
      oStatus:killread := lKill
   ENDIF
RETURN ( lSavKill )


***********************************************
FUNCTION ReadUpdated( lUpdated )
   LOCAL lSavUpdated := oStatus:updated
   IF ( PCOUNT() > 0 )
      oStatus:updated := lUpdated
   ENDIF
RETURN ( lSavUpdated )


***********************************************
FUNCTION ReadFormat( b )
   LOCAL bSavFormat := oStatus:format
   IF ( PCOUNT() > 0 )
      oStatus:format := b
   ENDIF
RETURN ( bSavFormat )

***********************************************
FUNCTION ReadStats( nStatic, xValue )
   LOCAL xSavStats, sStatic
   switch ( nStatic )
	case   1
		sStatic := "updated"
	case   2
		sStatic := "format"
	case   3
		sStatic := "killread"
	case   4
		sStatic := "bumptop"
	case   5
		sStatic := "bumpbot"
	case   6
		sStatic := "lastexit"
	case   7
		sStatic := "lastpos"
	case   8
		sStatic := "activeget"
	case   9
		sStatic := "readvar"
	case  10
		sStatic := "procname"
	case  11
		sStatic := "procline"
	case  12
		sStatic := "nextget"
	case  13
		sStatic := "hitcode"
	case  14
		sStatic := "pos"
	case  15
		sStatic := "scrvmsg"
	case  16
		sStatic := "menuid"
	case  17
		sStatic := "svccursor"
   end
   nStatic:=hashname(upper(sStatic))
   xSavStats := oStatus[nStatic]
   IF ( PCOUNT() > 1 )
      oStatus[nStatic] := xValue
   ENDIF
RETURN ( xSavStats )


***********************************************
FUNCTION ShowGetMsg( oGet, oMsg )
   LOCAL cMsg
   LOCAL lmOldState := MSetCursor( .F. )

   IF ( !( EMPTY( oMsg ) ) .AND. oMsg:flag )

      cMsg := IIF( VALTYPE( oGet:Control ) == "O", ;
			    oGet:Control:Message, oGet:Message )

      IF !EMPTY( cMsg )
	 dispOutAt( oMsg:row, oMsg:left, ;
	    PadC( cMsg, oMsg:right - oMsg:left + 1 ), ;
		  oMsg:color )

      ENDIF

   ENDIF
   MSetCursor( lmOldState )

   RETURN ( NIL )

***********************************************
FUNCTION EraseGetMsg( oGet, oMsg )
   LOCAL cMsg, nRow := ROW(), nCol := COL()
   LOCAL lmOldState := MSetCursor( .F. )

   IF ( !( EMPTY( oMsg ) ) .AND. oMsg:flag )

      cMsg := IIF( VALTYPE( oGet:Control ) == "O", ;
			    oGet:Control:Message, oGet:Message )

      RestScreen( oMsg:row, oMsg:left, oMsg:row, ;
		  oMsg:right, oStatus:scrvmsg )

   ENDIF
   MSetCursor( lmOldState )
   SETPOS( nRow, nCol )

   RETURN ( NIL )

***********************************************
FUNC UpDateGets( list )
	local get, ppp
	iif( pcount()==0, list:=memvar->getlist, NIL)
	aeval(list,{|X|x:display()})
RETURN NIL

***********************************************
function readkey()
return keyExit
***********************************************
function __setcursorempty()
return
***********************************************
init procedure getSysInit()
   if oStatus==NIL
	__getSysInit()
   endif
return
***********************************************
static function __getSysInit()
   if oStatus==NIL
	oStatus=map()
	oStatus:updated     := .f.
	oStatus:format      := NIL
	oStatus:killread    := NIL
	oStatus:bumptop     := NIL
	oStatus:bumpbot     := NIL
	oStatus:lastexit    := NIL
	oStatus:lastpos     := NIL
	oStatus:activeget   := NIL
	oStatus:readvar     := NIL
	oStatus:procname    := NIL
	oStatus:procline    := NIL
	oStatus:nextget     := NIL
	oStatus:hitcode     := NIL
	oStatus:pos         := NIL
	oStatus:scrvmsg     := NIL
	oStatus:menuid      := NIL
	oStatus:svccursor   := NIL
   endif
return
************************************
function _procreq_(fName)
	static cFormat
	local ret := cFormat
	if fname !=NIL
		cFormat := fName
	endif
return ret

************************************
function saveGets
return ostatus

************************************
function restGets(obj)
return RestoreGetSysVars(obj)

************************************
function CurrentGet()
return ostatus:pos


