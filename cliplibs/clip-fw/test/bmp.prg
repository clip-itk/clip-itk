// Display bitmap
/*
File Name  : BMP.PRG

Description: Display bitmap

*/

#INCLUDE <fwin/FiveWin.ch>

//-------------------------------------------------------------//

FUNCTION Main()
   LOCAL oWnd, oBar

   DEFINE WINDOW oWnd                                           ;
      TITLE "Test"

   DEFINE BUTTONBAR oBar  OF oWnd

   DEFINE BUTTON OF oBar                                        ;
      FILE "bitmaps/Info.bmp"                                ;
      TOOLTIP "Test"						;
      ACTION (oWnd:say(3, 3, cGetFile("*.*", "")))

   DEFINE BUTTON OF oBar                                        ;
      FILE "bitmaps\Exit.bmp"                                ;
      TOOLTIP "Exit"						;
      ACTION oWnd:end()

   ACTIVATE WINDOW oWNd VALID MsgYesNo('Realy quit?!?!?')

RETURN( NIL )
//-------------------------------------------------------------//
