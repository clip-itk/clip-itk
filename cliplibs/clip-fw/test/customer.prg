// Basic MDI application with reporting examples
/*
File Name  : Customer.PRG

Description: Basic MDI application with reporting examples

*/

#INCLUDE "fwin/FiveWin.ch"

#DEFINE ID_FIRST       110
#DEFINE ID_LAST        120
#DEFINE ID_STREET      130
#DEFINE ID_CITY        140
#DEFINE ID_STATE       150
#DEFINE ID_ZIP         160
#DEFINE ID_HIREDATE    170
#DEFINE ID_MARRIED     180
#DEFINE ID_AGE         190
#DEFINE ID_SALARY      200
#DEFINE ID_NOTES       210
#DEFINE ID_NEXT        220
#DEFINE ID_NAME        230
#DEFINE ID_SALES       240
#DEFINE ID_ADDRESS     250
#DEFINE ID_PREV        260
#DEFINE ID_NEW         270
#DEFINE ID_EDIT        280
#DEFINE ID_DEL         290
#DEFINE ID_PRINT       300

STATIC oWnd, oClients, oClient, oName
STATIC cName

//-------------------------------------------------------------//

FUNCTION Main()

   IF !file(".\data\Customer.dbf") .OR.                        ;
      !file(".\data\Sales.dbf")
      MsgStop("Missing Tables!")
      QUIT
   ENDIF
/*
   IF GetPvProfString("FiveWin","ThreeD","1",cIniFile ) == "1"
      SET 3DLOOK ON
   ENDIF

   SET RESOURCES TO "Customer.dll"
*/
   use .\data\CUSTOMER alias CLIENTS NEW

   use .\data\SALES NEW

   dbselectarea("Clients")

   DEFINE WINDOW oWnd                                           ;
      TITLE "Reporting tools"                                   ;
      MDI                                                       ;
      MENU BuildMenu()

   SET MESSAGE OF oWnd                                          ;
      TO "Testing the FiveWin Report Class"                     ;
      CENTERED

   ACTIVATE WINDOW oWnd                                         ;
      VALID MsgYesNo( "Do you want to end?" )

//   SET RESOURCES TO

RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION BuildMenu()
   LOCAL oMenu

   MENU oMenu
      MENUITEM "&File"                                      //CLW
      MENU
	 MENUITEM "&Clients..."                                 ;
	    ACTION  BrwClients()                                ;
	    MESSAGE "Clients management"

	 MENUITEM "&Report..."                                  ;
	    ACTION GenReport()
	 SEPARATOR
	 MENUITEM "E&xit"                                       ;
	    ACTION oWnd:End()                                   ;
	    MESSAGE "End this test"

      ENDMENU

      oMenu:AddMdi()  // Add standard MDI menu options

   ENDMENU

RETURN( oMenu )

//-------------------------------------------------------------//

FUNCTION BrwClients()
   LOCAL oBrw, oIco, oBar

   IF oClients != NIL
      RETURN( NIL )
   ENDIF

   DEFINE ICON oIco FILENAME "..\icons\Customer.ico"

   DEFINE WINDOW oClients                                       ;
      TITLE "Clients management"                                ;
      MDICHILD                                                  ;
      ICON oIco

   DEFINE BUTTONBAR oBar OF oClients

   DEFINE BUTTON OF oBar                                        ;
      TOOLTIP "Clients"                                         ;
      ACTION ShowClient()

   @ 2, 0 LISTBOX oBrw FIELDS OF oClients                       ;
      SIZE 500, 500                                             ;
      ON CHANGE ChangeClient()

   oClients:SetControl( oBrw )

   ACTIVATE WINDOW oClients                                     ;
      VALID( oClients := NIL, .T. )
   // We destroy the object

RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION GenReport()
   LOCAL oWnd, oIco

   DEFINE ICON oIco FILENAME "..\icons\print.ico"

   DEFINE WINDOW oWnd                                           ;
      TITLE "Clients report"                                    ;
      MDICHILD                                                  ;
      VSCROLL HSCROLL                                           ;
      ICON oIco

   ACTIVATE WINDOW oWnd

RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION ShowClient()
   LOCAL oIco

   IF oClient != NIL
      RETURN( NIL )
   ENDIF

   DEFINE ICON oIco FILENAME "..\icons\Person.ico"

   DEFINE DIALOG oClient RESOURCE "Client" ;
      ICON oIco

   REDEFINE SAY ID 3 OF oClient        // To get the proper color
   REDEFINE SAY ID 4 OF oClient
   REDEFINE SAY ID 5 OF oClient

   REDEFINE GET oName VAR cName ID ID_NAME OF oClient

   REDEFINE BUTTON ID ID_NEXT OF oClient                        ;
      ACTION GoNext()

   dbselectarea("Sales")
   // We select Sales to properly initialize the Browse

   REDEFINE LISTBOX FIELDS ID ID_SALES OF oClient

   ACTIVATE DIALOG oClient                                      ;
      CENTERED                                                  ;
      NOWAIT                                                    ;
      VALID ( oClient := NIL, .T. )
   // Destroy the object

   SELECT Clients

RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION ChangeClient()

   IF oClient != NIL
      cName = alltrim( Clients->Last ) + ", " + Clients->First
      oName:Refresh()
   ENDIF

RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION GoNext()

   IF oClients != NIL

      oClients:oControl:GoDown()

   ELSE

      dbskip(1)

      IF eof()
	 dbgobottom()
      ENDIF

   ENDIF

   ChangeClient()

RETURN( NIL )
//-------------------------------------------------------------//
