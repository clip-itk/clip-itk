// Massive DialogBox use test                                   ä
/*
File Name  : DLGTEST.PRG

Description: Massive Dialog Box use test

*/

#INCLUDE <fwin/FiveWin.ch>

STATIC oWnd
STATIC lEnd := .F.
STATIC cName
//-------------------------------------------------------------//

FUNCTION Main()

   DEFINE WINDOW oWnd                                          ;
      TITLE "Massive Dialog Box use test"

   @ 2,  2 BUTTON "&Start"                                     ;
      SIZE 80, 20                                              ;
      ACTION ( lEnd := .F., StartTest() )

   @ 2, 20 BUTTON "&End"                                       ;
      SIZE 80, 20                                              ;
      ACTION lEnd:=.T.

      @ 4, 2 GET cName OF oWnd	;
		PICTURE "(999),999"

   ACTIVATE WINDOW oWnd

RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION StartTest()
   LOCAL oDlg
   LOCAL nPos  := 1
   cName := space( 30 )


      DEFINE DIALOG oDlg                                        ;
	 FROM 10, 10 TO 23, 70                                  ;
	 TITLE "A Dialog Box"

      @ 2, 2 SAY "&One" OF oDlg
/*
      @ 4, 2 GET cName OF oDlg	;
		PICTURE "(999),999"
*/
      @ 6, 2 BUTTON "&One" OF oDlg ACTION MsgBeep()

      @ 8, 2 BUTTON "&Dlg" OF oDlg	;
	MESSAGE "Some dialog box"	;
	ACTION StartDialog()
/*
      oWnd:Say( 4, 2, str( ++nPos ) )
*/
      ACTIVATE DIALOG oDlg                                      //;

      SysRefresh()

RETURN( NIL )
****************
FUNCTION StartDialog()
   LOCAL oDlg
   LOCAL nPos  := 1
   LOCAL cN := padr( 'Name', 30 )
   LOCAL cFamily := padr( 'Family', 60)
   LOCAL cCity	:= padr( 'City', 60)
   LOCAL cPhone := padr( 'xx-xx-xx', 10)

      DEFINE DIALOG oDlg                                        ;
	 FROM 15, 20 TO 25, 70                                  ;
	 TITLE "Personal cards"

      @ 2, 2 SAY "&One" OF oDlg
      @ 4, 2 GET cN OF oDlg
      @ 6, 2 GET cFamily OF oDlg
      @ 8, 2 GET cCity OF oDlg
      @ 10, 2 GET cPhone OF oDlg
      @ 10, 22 BUTTON "&Done" OF oDlg	;
	MESSAGE "Done"	;
	ACTION {||beep(), oDlg:End()}

      ACTIVATE DIALOG oDlg                                      ;
	VALID MsgYesNo("Done?")

RETURN( NIL )
//-------------------------------------------------------------//

