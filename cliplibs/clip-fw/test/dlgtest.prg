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
      ACTION ( lEnd:=.T., oWnd:end() )

   ACTIVATE WINDOW oWnd

	qout('Cname is ', cName)
        qout()
RETURN( NIL )

//-------------------------------------------------------------//

FUNCTION StartTest()
   LOCAL oDlg
   LOCAL nPos  := 1
   LOCAL nV
   cName := space( 30 )
   nV := 0


      DEFINE DIALOG oDlg                                        ;
	 FROM 10, 10 TO 23, 70                                  ;
	 TITLE "A Dialog Box"

      @ 2, 2 SAY "&One" OF oDlg

      @ 4, 2 GET cName OF oDlg	;
		PICTURE "@R (999),999" ;
		VALID !empty(cName)

      @ 6, 2 BUTTON "&One" OF oDlg ACTION MsgBeep()

      @ 8, 2 BUTTON "&Dlg" OF oDlg	;
	MESSAGE "Some dialog box"	;
	ACTION StartDialog()

      @ 12, 2 GET nV OF oDlg	;
		WHEN (val(cName)>100)

      ACTIVATE DIALOG oDlg

      SysRefresh()

      qout('cName=', cName)
      qout()
      qout('nV=', nV)
      qout()

RETURN( NIL )
***************************
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

