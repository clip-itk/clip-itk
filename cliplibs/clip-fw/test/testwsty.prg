// Testing Windows Styles!                                      ß
/*
File Name  : TESTWSTY.PRG

Description:

*/

#INCLUDE "fwin/FiveWin.ch"

//-------------------------------------------------------------//

FUNCTION Main()
   LOCAL oWnd

   // First Test
   DEFINE WINDOW oWnd FROM 2, 7 TO 20, 75                       ;
      TITLE "Normal Window Style";
      COLOR CLR_BLUE

   @ 2, 2 BUTTON "&Next Test" SIZE 80, 25 OF oWnd               ;
      ACTION oWnd:End()

   @ 2, 20 SAY "Normal Window Style" COLOR CLR_RED

   ACTIVATE WINDOW oWnd

   // Second Test
   DEFINE WINDOW oWnd FROM 2, 7 TO 20, 75                       ;
      TITLE "Window No Zoom"                                    ;
      NOZOOM

   @ 2, 2 BUTTON "&Next Test" SIZE 80, 25 OF oWnd               ;
      ACTION oWnd:End()

   @ 2, 20 SAY "Window No Zoom"

   ACTIVATE WINDOW oWnd

   // Third Test
   DEFINE WINDOW oWnd FROM 2, 7 TO 20, 75                       ;
      TITLE "Window No Zoom, No Iconize"                        ;
      NOZOOM NOICONIZE

   @ 2, 2 BUTTON "&Next Test" SIZE 80, 25 OF oWnd               ;
      ACTION oWnd:End()

   @ 2, 20 SAY "Window No Zoom, No Iconize"

   ACTIVATE WINDOW oWnd

   // Four Test
   DEFINE WINDOW oWnd FROM 2, 7 TO 20, 75                       ;
      TITLE "Window No Zoom, No Iconize, No Border"             ;
      NOZOOM NOICONIZE                                          ;
      BORDER NONE

   @ 2, 2 BUTTON "&Next Test" SIZE 80, 25 OF oWnd               ;
      ACTION oWnd:End()

   @ 2, 20 SAY "Window No Zoom, No Iconize, No Border"

   ACTIVATE WINDOW oWnd


   // Five Test
   DEFINE WINDOW oWnd FROM 2, 7 TO 20, 75                       ;
      TITLE "Window No SysMenu, No Iconize, No Zoom, No Border" ;
      NOSYSMENU                                                 ;
      NOZOOM NOICONIZE                                          ;
      BORDER NONE

   @ 2, 2 BUTTON "&Next Test" SIZE 80, 25 OF oWnd               ;
      ACTION oWnd:End()

   @ 2, 20 SAY "Window No SysMenu, No Iconize, No Zoom, No Border"

   ACTIVATE WINDOW oWnd

   // Six Test
   DEFINE WINDOW oWnd FROM 2, 7 TO 20, 75                       ;
      TITLE "Window No Caption, No Border"                      ;
      NO CAPTION                                                ;
      BORDER NONE

   @ 2, 2 BUTTON "&Next Test" SIZE 80, 25 OF oWnd               ;
      ACTION oWnd:End()

   @ 2, 20 SAY "Window No Caption, No Border"

   ACTIVATE WINDOW oWnd

   // Seven Test
   DEFINE WINDOW oWnd FROM 2, 7 TO 20, 75                       ;
      TITLE "Normal Window with ScrollBars"                     ;
      VSCROLL HSCROLL

   @ 2, 2 BUTTON "&Next Test" SIZE 80, 25 OF oWnd               ;
      ACTION oWnd:End()

   @ 2, 20 SAY "Normal Window with ScrollBars"

   ACTIVATE WINDOW oWnd                                         ;
      ON UP    oWnd:Say( 4, 2, "Wellcome to FiveWin" )          ;
      ON DOWN  oWnd:Say( 5, 2, "Pure xBase power..." )          ;
      ON LEFT  oWnd:Say( 6, 2, "in your fingertips..." )        ;
      ON RIGHT oWnd:Say( 7, 2, "Enjoy the Windows revolution!" )

RETURN( NIL )
//-------------------------------------------------------------//
