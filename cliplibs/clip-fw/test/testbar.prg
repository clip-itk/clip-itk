// Create an application with ButtonBar and Menu.               Æ
/*
File Name  : TESTBAR.PRG

Description: This sample shows how to create a Management Menu
	     with ButtonBar and Menu.

*/

#INCLUDE "fwin/FiveWin.ch"

STATIC oWnd
STATIC date

//-------------------------------------------------------------//

FUNCTION Main()
   LOCAL oBar

   date := date()

   DEFINE WINDOW oWnd FROM 1, 5 TO 20, 65                       ;
      TITLE "FiveWin ButtonBar & Menu Management"               ;
      MENU  BuildMenu()


   DEFINE BUTTONBAR oBar BUTTONSIZE 33, 33 3D TOP OF oWnd

   DEFINE BUTTON OF oBar FILE ".\bitmaps\Exit.bmp"             ;
      ACTION IIF( MsgYesNo( "Do you want to end ?",             ;
	 "Please Select" ), oWnd:End(), )                       ;
      MESSAGE "End this session"

   DEFINE BUTTON OF oBar FILE ".\bitmaps\Cara.bmp"             ;
      ACTION MsgInfo( "New Project", "Information" )            ;
      MESSAGE "Create a new project"

   DEFINE BUTTON OF oBar FILE ".\bitmaps\OpenPrj.bmp"          ;
      ACTION MsgStop( "Open Project", "Stop" )                  ;
      MESSAGE "Open a previous project"

   DEFINE BUTTON OF oBar FILE ".\bitmaps\SavePrj.bmp"          ;
      ACTION MsgAlert( "Save this project", "Hey!" )            ;
      MESSAGE "Save this project"

   DEFINE BUTTON OF oBar FILE ".\bitmaps\CUT.bmp"              ;
      GROUP                                                     ;
      ACTION MsgInfo( "You can easily call your functions"+     ;
	 " from the ButtonBar", "Well, this is FiveWin" )       ;
      MESSAGE "Cut to ClipBoard"

   DEFINE BUTTON OF oBar FILE ".\bitmaps\COPY.bmp"             ;
      ACTION MsgStop( "FiveWin automatically will execute"+     ;
	 " your actions","Go for productivity!" )               ;
      MESSAGE "Copy to ClipBoard" ;

      DEFINE BUTTON OF oBar FILE ".\bitmaps\PASTE.bmp"         ;
      ACTION MsgAlert( "It's time for OOPS & xBase Power!" +    ;
	 CRLF+"It provides over 50 new Clipper real Classes"+   ;
	 CRLF+"using xBase Commands to encapsulate complexity!",;
      "FiveWin is really Clipper 5 & xBase" )                   ;
      MESSAGE "Paste from ClipBoard"

   DEFINE BUTTON OF oBar FILE ".\bitmaps\CALENDAR.bmp"         ;
      GROUP                                                     ;
      ACTION (date:=Calendar(date),oWnd:say(2, 3, dtoc(date)))  ;
      MESSAGE "Calling Windows Calendar"

   DEFINE BUTTON OF oBar FILE ".\bitmaps\CLIPBOAR.bmp"         ;
      ACTION WinExec( "Clipbrd" )                               ;
      MESSAGE "Looking at ClipBoard"

   DEFINE BUTTON OF oBar FILE ".\bitmaps\HELP.bmp"             ;
      ACTION WinHelp( "..\doc\FiveWin.hlp" )                    ;
      MESSAGE "Windows Help"

   SET MESSAGE OF oWnd TO                                       ;
      FWVERSION + "-" + FWCOPYRIGHT                             ;
      CENTERED

      //DATE

   ACTIVATE WINDOW oWnd VALID MsgYesNo("Are you shure?")

RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION BuildMenu()
   LOCAL oMenu

   MENU oMenu
      MENUITEM "&Information"
      MENU
	 MENUITEM "About..."                                    ;
	    MESSAGE "About FiveWin"                             ;
	    ACTION MsgAbout( FWVERSION, FWCOPYRIGHT )
	 SEPARATOR
	 MENUITEM FILE ".\bitmaps\End.bmp"                     ;
	    MESSAGE "End this session"                          ;
	    ACTION IF( MsgYesNo( "Do you want to end ?",        ;
	    "Please select" ), oWnd:End(), )

      ENDMENU
      MENUITEM "&Files"

	 MENU
	    MENUITEM "&Clients"
	       MENU
		  MENUITEM "&New..."                            ;
		     MESSAGE "Add a new Client"                 ;
		     ACTION MsgInfo( "New Client",              ;
			"Call here your functions..." )
		  MENUITEM "&Modify..."                         ;
		     MESSAGE "Modify the information"
		  MENUITEM "what ever..."                       ;
		     MESSAGE "FiveWin is so easy!"
	       ENDMENU
	    MENUITEM "&Stocks"
	 ENDMENU

      MENUITEM "&Utilities"
      MENU
	 MENUITEM FILE ".\bitmaps\Calc.bmp"                    ;
	    MESSAGE "Calling calculator"                        ;
	    ACTION WinExec( "Calc" )
	 MENUITEM FILE ".\bitmaps\FiveWin.bmp"                 ;
	    ACTION MsgInfo( FWVERSION                         , ;
	    "The xBase & Windows revolution!" )
      ENDMENU
   ENDMENU

RETURN( oMenu )
//-------------------------------------------------------------//
