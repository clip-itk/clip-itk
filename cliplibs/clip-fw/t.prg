#INCLUDE <fwin/FiveWin.ch>

STATIC oWnd, oFont

//-------------------------------------------------------------//

FUNCTION Main()
   LOCAL oBar


   DEFINE WINDOW oWnd                                           ;
      TITLE "Hello world!"                                      ;
      MENU BuildMenu()

	oFont := TFont():new("times")

   DEFINE BUTTONBAR oBar OF oWnd

   //DEFINE BUTTON OF oBar //FILENAME "..\bitmaps\info.bmp"         ;
   //   ACTION MsgBeep()                                          ;
   //   MESSAGE "Any action from here"
   DEFINE BUTTON OF oBar          ;
      MESSAGE "Any action from here"				;
      PROMPT  "Hi-Hi" 						;
      ACTION oWnd:End()
   DEFINE BUTTON OF oBar          ;
      MESSAGE "Some button for beep!!"				;
      PROMPT  "Beep!"						;
      ACTION MsgBeep()

/*
*/
   SET MESSAGE OF oWnd TO "FiveOS2 - CA-Clip for UNIX system"

   ACTIVATE WINDOW oWnd                                         ;
      VALID MsgYesNo( "Confirm exit" )
RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION BuildMenu()

   LOCAL oMenu

   MENU oMenu
      MENUITEM "&Information"
      MENU
	 MENUITEM "&About..."
	 MENU
		MENUITEM "Uuups"
		MENUITEM "Ooops"
	 ENDMENU
	 SEPARATOR
	 MENUITEM "E&xit..."                                    ;
	    ACTION oWnd:End()
      ENDMENU
      MENUITEM "ha-ha"
      MENU
	MENUITEM "dsgfj"
	MENUITEM "Choose Font"					;
		ACTION oFont:Choose()
      ENDMENU
   ENDMENU

RETURN( oMenu )
//-------------------------------------------------------------//

? 'end'
?
