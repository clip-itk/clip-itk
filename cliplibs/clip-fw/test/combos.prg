// Using different styles of ComboBox controls in a dialog

#INCLUDE <fwin/FiveWin.ch>

#DEFINE ID_SIMPLE       110
#DEFINE ID_DROPDOWN     120
#DEFINE ID_DROPDOWNLIST 130
#DEFINE ID_SELECTION    140

//-------------------------------------------------------------//

FUNCTION Main()
   LOCAL oDlg, oSay
   LOCAL oCbx1, oCbx2, oCbx3
   LOCAL cItem1, cItem2, cItem3, cItem4

/*
   SET RESOURCES TO "Combos.dll"
*/

   DEFINE DIALOG oDlg TITLE "Test all Combo-style"              ;
	FROM 20, 20 to 200, 400					;
	PIXEL
//      RESOURCE "Combos"

   //REDEFINE COMBOBOX oCbx1                                      ;
   cItem2 := 'dhfj'

   @ 1, 2 COMBOBOX oCbx1                                      ;
      VAR cItem1                                                ;
      ITEMS { "One", "Two", "Three", 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten' }                           ;
      SIZE 100, 20						;
      OF oDlg                                      ;
      ON CHANGE ( cItem4 := cItem1, oSay:Refresh() )            ;
      VALID ( MsgBeep(), cItem4 := cItem1 ,                     ;
	      oSay:Refresh(), .T. )				;
      STYLE CBS_SIMPLE

   cItem2 := 'Three'

   @ 1, 15 COMBOBOX oCbx2                                      ;
      VAR cItem2                                                ;
      ITEMS { "One", "Two", "Three", 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten' }                           ;
      SIZE 100, 20						;
      OF oDlg                                    ;
      ON CHANGE ( cItem4 := cItem2, oSay:Refresh() )            ;
      VALID ( MsgBeep() , cItem4 := cItem2                    , ;
	      oSay:Refresh(), .T. )				;
      STYLE CBS_DROPDOWN

   @ 1, 31 COMBOBOX oCbx3                                      ;
      VAR cItem3                                                ;
      ITEMS { "One", "Two", "Three" }                           ;
      SIZE 100, 20						;
      OF oDlg                                ;
      ON CHANGE ( cItem4 := cItem3, oSay:Refresh() )            ;
      VALID ( MsgBeep() , cItem4 := cItem3                    , ;
	      oSay:Refresh(), .T. )				;
      STYLE CBS_DROPDOWNLIST

/*
*/
   //REDEFINE SAY oSay PROMPT cItem4 ID ID_SELECTION OF oDlg

//   @ 1, 6 SAY oSay  PROMPT cItem4 OF oDlg

   ACTIVATE DIALOG oDlg                                         ;
      CENTERED

//   SET RESOURCES TO

RETURN( NIL )
//-------------------------------------------------------------//
