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
      TITLE "ToolTips in FiveWin! Hooray! Hooray! Hooray!!!"

   DEFINE BUTTONBAR oBar 3D SIZE 33, 33 OF oWnd

   DEFINE BUTTON OF oBar  FILE ".\bitmaps\Exit.bmp"            ;
      TOOLTIP "Exit Exit"                                            ;
      ACTION oWnd:End()

   DEFINE BUTTON OF oBar  FILE ".\bitmaps\Plus.bmp"            ;
      TOOLTIP "Adding tooltips is... Adding tooltip...."                           ;
      ACTION MsgInfo("... as easy as this! .... really easy!")

   @ 10, 8 BUTTON oBtn PROMPT "Where is my tooltip? Where is my tooltip?" SIZE 180, 28 OF oWnd ;
      ACTION MsgInfo( "Oh! Thanks! Oh! Thanks!" )

   // Manipulate directly the cToolTip DATA of other controls than ButtonBitmaps
   oBtn:cToolTip = "Here it is! here it is!"


   SET MESSAGE OF oWnd                                          ;
      TO "FiveWin: Clip for Unix  && "+                    ;
	 "Somewhere in Russian!!!"         ;
      CENTER							;
      DATE ;
      CLOCK ;
      KEYBOARD

   ACTIVATE WINDOW oWnd                                         ;

RETURN( NIL )

//-------------------------------------------------------------//
