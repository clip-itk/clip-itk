// Sample how to use ScrollBars                                 Æ
/*
File Name  : TESTSCRL.PRG

Description: Sample how to use ScrollBars

*/

#INCLUDE "fwin/FiveWin.ch"

STATIC oWnd

//-------------------------------------------------------------//

FUNCTION Main()

   DEFINE WINDOW oWnd                                           ;
      FROM 1, 1 TO 20, 70                                       ;
      TITLE "Testing ScrollBars"                                ;
      MENU BuildMenu()

      @ 2, 5 SCROLLBAR OF oWnd                                  ;
	 UP   nMsgBox( "Hey!, Go Up" )                       ;
	 DOWN nMsgBox( "Going down man" )

      @ 2, 15 SCROLLBAR OF oWnd                                 ;
	 UP   oWnd:Say( 2, 30, Time() )                      ;
	 DOWN oWnd:Say( 4, 30, "Hello!" )

   SET MESSAGE OF oWnd TO                                       ;
      OemToAnsi( FWCOPYRIGHT , FWVERSION )

   ACTIVATE WINDOW oWnd

RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION BuildMenu()
   LOCAL oMenu

   MENU oMenu
      MENUITEM "Add &ScrollBar"                                 ;
	 ACTION AddSbr()
   ENDMENU

RETURN( oMenu )

//-------------------------------------------------------------//

FUNCTION AddSbr()
   STATIC lAdded

   IF lAdded == NIL
      lAdded := .T.

      @ 2, 5 SCROLLBAR OF oWnd                                  ;
	 UP   nMsgBox( "Hey!, Go Up" )                       ;
	 DOWN nMsgBox( "Going down man" )

      @ 2, 15 SCROLLBAR OF oWnd                                 ;
	 UP   oWnd:Say( 2, 30, Time() )                      ;
	 DOWN oWnd:Say( 4, 30, "Hello!" )

   ENDIF

RETURN( NIL )
//-------------------------------------------------------------//
