// ListBox USE sample                                           Æ
/*
File Name  : TESTLBX.PRG

Description: ListBox USE sample

*/

#INCLUDE "fwin/FiveWin.ch"

//-------------------------------------------------------------//

FUNCTION Main()
   LOCAL oWnd, oLbx, oSay
   LOCAL cItem := "Two"

   DEFINE WINDOW oWnd                                           ;
      FROM 1, 1 TO 20, 60                                       ;
      TITLE "Testing a ListBox"                                 ;
      COLOR CLR_BLUE


   @ 2, 2 LISTBOX oLbx VAR cItem                                ;
      ITEMS { "One", "Two", "Three", "Four", "Five"            };
      OF oWnd SIZE 200, 150                                     ;
      COLOR CLR_BLUE                                            ;
      ON CHANGE oSay:Refresh()                                  ;
      MESSAGE "Please select an Item"                           ;
      SORT


   @ 2, 40 SAY oSay VAR cItem SIZE 80, 20 OF oWnd

   @ 8, 42 BUTTON "&Add" SIZE 80, 20 OF oWnd                    ;
      ACTION oLbx:Add( time() )                                 ;
      MESSAGE "Add a new item to the listbox"


   @ 11, 42 BUTTON "E&xit" SIZE 80, 20 OF oWnd                  ;
      ACTION oWnd:End()                                         ;
      MESSAGE "Press me to end this test"

   SET MESSAGE OF oWnd TO "Testing a ListBox"

   ACTIVATE WINDOW oWnd

RETURN( NIL )
//-------------------------------------------------------------//
