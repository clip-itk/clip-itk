// This sample shows how to easily implement 'tool-tips'
// in FiveWin!
/*
File Name  : TOOLTIP.PRG

Description: This sample shows how to easily implement
	     'tool-tips' in FiveWin!

*/

#INCLUDE "fwin/FiveWin.ch"

STATIC oWnd

//-------------------------------------------------------------//

FUNCTION Main()
   LOCAL oBar, oBtn

   DEFINE WINDOW oWnd                                           ;
      TITLE "ToolTips in FiveWin! Ура! Ура! Ура!!!"

   DEFINE BUTTONBAR oBar 3D SIZE 33, 33 OF oWnd

   DEFINE BUTTON OF oBar  FILE ".\bitmaps\Exit.bmp"            ;
      TOOLTIP "Exit Выход"                                            ;
      ACTION oWnd:End()

   DEFINE BUTTON OF oBar  FILE ".\bitmaps\Plus.bmp"            ;
      TOOLTIP "Adding tooltips is... добавим tooltip...."                           ;
      ACTION MsgInfo("... as easy as this! .... действительно легко!")

   @ 10, 8 BUTTON oBtn PROMPT "Where is my tooltip? Где мой tooltip?" SIZE 180, 28 OF oWnd ;
      ACTION MsgInfo( "Oh! Thanks! О! Спасибо!" )

   // Manipulate directly the cToolTip DATA of other controls than ButtonBitmaps
   oBtn:cToolTip = "Here it is! А вот он!"


   SET MESSAGE OF oWnd                                          ;
      TO "FiveWin: Clip for Unix  && "+                    ;
	 "что-то по-русски!!!"         ;
      CENTER							;
      DATE ;
      CLOCK ;
      KEYBOARD

   ACTIVATE WINDOW oWnd                                         ;

RETURN( NIL )

//-------------------------------------------------------------//
