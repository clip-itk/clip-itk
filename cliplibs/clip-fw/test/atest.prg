// Demonstration of array dimensioning under Windows            Æ
/*
File Name  : ATEST.PRG

Description: Demonstration of array dimensioning under Windows

*/

#INCLUDE <fwin/FiveWin.ch>

//-------------------------------------------------------------//

FUNCTION Main()

   DEFINE WINDOW oWnd                                          ;
      TITLE "Massive Dialog Box use test";
      COLOR CLR_YELLOW
/*
   @ 2,  2 BUTTON "&Start"                                     ;
      SIZE 80, 20                                              ;
      ACTION ( MsgMeter( { | oMeter, oText, oDlg, lEnd, oBtn |       ;
      ArrayTest( oMeter, oText, @lEnd ) }                     , ;
      "Element nÚ xxxx"                                       , ;
      "Adding 2000 elements to a Clipper array..." ))

*/
   ACTIVATE WINDOW oWnd VALID MsgYesNo("Uveren??")

RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION ArrayTest( oMeter, oText, lEnd )

   LOCAL aTest := {}
   LOCAL n     := 1
   LOCAL nOld  := 1

   oMeter:SetTotal(2000)
   oText:SetText( OemToAnsi( "Element nÚ: " ) + str( n, 4 ) )

   WHILE n <= oMeter:nTotal .and. ! lEnd
      aadd( aTest, "" )

      oMeter:Set( n++ )

      IF n - nOld == 10
	 oText:SetText( OemToAnsi( "Element nÚ: " ) +           ;
	    str( n - 1, 4 ) )
	 nOld := n
      ENDIF


      /* Let Windows process pending messages */
      SysRefresh()

   ENDDO

   IF lEnd
      MsgAlert( "Sample cancelled" )
   ELSE
      MsgInfo( len( aTest ), "Array Length" )
   ENDIF

RETURN( NIL )
//-------------------------------------------------------------//
