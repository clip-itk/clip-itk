#INCLUDE <fwin/FiveWin.ch>

STATIC oWnd, oFont

//-------------------------------------------------------------//

FUNCTION Main()
   LOCAL oBar

   DEFINE WINDOW oWnd						;
      TITLE "Hello world!"					;
      MENU BuildMenu()


   DEFINE BUTTONBAR oBar OF oWnd

      DEFINE BUTTON OF oBar FILENAME "bitmaps\info.bmp"	;
      ACTION MsgBeep()						;
      MESSAGE "Any action from here"

      DEFINE BUTTON OF oBar FILENAME "bitmaps\exit.bmp"	;
      MESSAGE "Exit from here"				;
      ACTION oWnd:End()

   SET MESSAGE OF oWnd TO "Clip for UNIX system";
   DATE ;
   CLOCK

   ACTIVATE WINDOW oWnd					;
      VALID MsgYesNo( "Confirm exit" )

RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION BuildMenu()

   LOCAL oMenu

   MENU oMenu
      MENUITEM "E&xit..." ACTION oWnd:End()
      MENUITEM "&Information"
      MENU
	 MENUITEM "&About..." ACTION MsgAbout()
	 SEPARATOR
	 MENUITEM "E&xit..." ACTION oWnd:End()
      ENDMENU
      MENUITEM "ha-ha"
      MENU
	MENUITEM "dsgfj" ACTION msgbeep()
	MENUITEM "Choose Font" ACTION oFont:Choose()
      ENDMENU
   ENDMENU

RETURN( oMenu )
//-------------------------------------------------------------//

? 'end'
?

