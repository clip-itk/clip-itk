// Drawing lines and some management colors                     ß
/*
File Name  : LINES.PRG

Description: Drawing lines and some management colors

*/
#INCLUDE "fwin/FiveWin.ch"

STATIC aPoints, nCount, nColor := 0, oWnd

//-------------------------------------------------------------//

FUNCTION Main()

   aPoints := array( 1000 )
   nCount  := 0

   DEFINE WINDOW oWnd FROM 1, 1 TO 30, 50                       ;
      TITLE "FiveWin - Click the mouse over the window"         ;
      MENU BuildMenu()

   oWnd:bLClicked := { | h, y, x, flags | Click( y, x ) }
   oWnd:bPainted  := { || MiPaint() }

   ACTIVATE WINDOW oWnd

RETURN( 0 )

//-------------------------------------------------------------//

FUNCTION BuildMenu()
   LOCAL oMenu

   MENU oMenu
      MENUITEM "&Tasks"
      MENU
	 MENUITEM "&Clear"                                      ;
	    ACTION Clear()
	 MENUITEM "&Undo"                                       ;
	    ACTION Undo()
	 SEPARATOR
	 MENUITEM "&Color"                                      ;
	    ACTION NewColor()
	 SEPARATOR
	 MENUITEM "E&xit"                                          ;
	    ACTION oWnd:End()
      ENDMENU

   ENDMENU

RETURN( oMenu )

//-------------------------------------------------------------//

STATIC PROCEDURE Clear()
   nCount := 0
   oWnd:Refresh()
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE Undo()
   IF nCount > 0
      nCount--
      oWnd:Refresh()
   ENDIF
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE NewColor()
   LOCAL nOldColor := nColor

   IF ( nColor := ChooseColor() ) == -1
      nColor := nOldColor
   ENDIF
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE Click( x, y )
   aPoints[ ++nCount ] := { y, x }
   DrawLine( x, y )
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE DrawLine( x, y )
   LOCAL n, hPen, hOldPen

   oWnd:GetDc()

   hPen := CreatePen( 0, 1, nColor )
   hOldPen := SelectObject( oWnd:hDc, hPen )

   FOR n := 1 to nCount - 1
      MoveTo( oWnd:hDC, aPoints[ n, 1 ], aPoints[ n, 2 ] )
      LineTo( oWnd:hDC, y, x )
   NEXT

   SelectObject( oWnd:hDc, hOldPen )
   DeleteObject( hPen )

   oWnd:ReleaseDc()
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE MiPaint()
   LOCAL n

   FOR n := 1 to nCount
      DrawLine( aPoints[n, 2], aPoints[n, 1] )
   NEXT
RETURN
//-------------------------------------------------------------//
