#INCLUDE <fwin/FiveWin.ch>

STATIC oWnd, oFont, oName

//-------------------------------------------------------------//

FUNCTION Main()
   LOCAL oBar, cName

   DEFINE WINDOW oWnd						;
      TITLE "Hello world!"					//;
//      MENU BuildMenu()


      @ 2, 3 BUTTON "Browse" OF oWnd ;
      ACTION (cName:=cGetFile("*.prg"),oName:refresh())   ;
      MESSAGE "Call file dialog"

      cName := "no file name"
      @ 5, 3 GET oName VAR cName OF oWnd SIZE 100, 20 ;
      MESSAGE "It is file from <Browse>"

/*


   DEFINE BUTTONBAR oBar OF oWnd

      DEFINE BUTTON OF oBar FILENAME "bitmaps\info.bmp"	;
      ACTION MsgBeep()						;
      MESSAGE "Any action from here"

      DEFINE BUTTON OF oBar FILENAME "bitmaps\exit.bmp"	;
      MESSAGE "Exit from here"				;
      ACTION oWnd:End()
*/

   SET MESSAGE OF oWnd TO "Clip for UNIX system" //;
   //DATE// ;
   //CLOCK


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

