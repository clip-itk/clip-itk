// Massive DialogBox use test                                   ä
/*
Tested GET object and base
*/

#INCLUDE <fwin/FiveWin.ch>

STATIC oWnd
STATIC lEnd := .F.
STATIC cName
STATIC oName
STATIC oSay
//-------------------------------------------------------------//

FUNCTION Main()

   USE ./data/customer.dbf

   DEFINE WINDOW oWnd                                          ;
      TITLE "Test GET, SAY objects"

   cName := first

   @ 2, 2 BUTTON "&Prev"                                     ;
      SIZE 80, 20                                              ;
      ACTION ( dbskip(-1), cName := first, oName:Refresh(), oSay:Refresh() )

   @ 8, 2 GET oName VAR cName SIZE 80, 20
   @ 8, 20 SAY oSay VAR cName SIZE 100, 20

   @ 15, 2 BUTTON "&Next"                                       ;
      SIZE 80, 20                                              ;
      ACTION ( dbskip(), cName := first, oName:Refresh(), oSay:Refresh() )


   ACTIVATE WINDOW oWnd ;
   VALID (iif(MsgYesNo("Close Test?"), (dbclosearea(), .t.), .f.))

RETURN( NIL )

