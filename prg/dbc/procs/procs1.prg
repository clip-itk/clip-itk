/*
 * Common procedures
 * Browse
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
*+
*+    Source Module => D:\MYAPPS\SOURCE\PROCS\PROCS1.PRG
*+
*+    Functions: Function DBFLIST()
*+               Function FLDCOUNT()
*+               Function VIVNAMES()
*+               Function WNDVIVOD()
*+               Static Procedure VIVSTR()
*+               Function FLDSTR()
*+               Procedure EXT_PRG()
*+               Function GetBuf()
*+
*+    Reformatted by Click! 2.00 on Apr-12-2001 at  8:13 pm
*+
*+▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

#include "fileio.ch"
#ifdef RDD_AX
#include "dbfcdxax.ch"
#endif
#include "inkey.ch"
#include "deflist.ch"

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function DBFLIST()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
#ifdef VER_MOUSE
FUNCTION DBFLIST( mslist, x1, y1, x2, y2, title, maskey, ctrl_ar )
#else
FUNCTION DBFLIST( mslist, x1, y1, x2, y2, title, maskey )
#endif

LOCAL rezproc, xkey, rez, fipos, wndbuf, predit, oldcolors
LOCAL ym, xm, i
LOCAL fbar1, fbar2, vartmp, cPicture, lEdArr, razmer
LOCAL GetList := {}

MEMVAR str_bar, varbuf
PRIVATE varbuf

   IF mslist == Nil
      mslist := InitList()
   ENDIF
   IF TYPE( "str_bar" ) <> "C"
      PRIVATE str_bar := "▒■"
   ENDIF
   LI_Y1 := y1
   LI_X1 := x1
   LI_Y2 := y2
   LI_X2 := x2
   IF LI_MSF == Nil
      LI_COLCOUNT := FCOUNT()
   ELSE
      LI_COLCOUNT := LEN( LI_MSF )
      IF LI_MSTYP == Nil
         LI_MSTYP := Array( LI_COLCOUNT )
         IF LI_MSLEN == Nil
            LI_MSLEN := Array( LI_COLCOUNT )
         ENDIF
         LI_MSDEC := Array( LI_COLCOUNT )
         FOR i := 1 TO LI_COLCOUNT
            IF Valtype( LI_MSF[ i ] ) == "B"
               vartmp := EVAL( LI_MSF[ i ],mslist,i )
               LI_MSTYP[ i ] := Valtype( vartmp )
               IF LI_MSTYP[ i ] == "C"
                  LI_MSLEN[ i ] := Len( vartmp )
               ELSEIF LI_MSTYP[ i ] == "N"
                  vartmp := STR( vartmp )
                  LI_MSLEN[ i ] := Len( vartmp )
                  LI_MSDEC[ i ] := IIF( '.' $ vartmp,LI_MSLEN[ i ] - AT( '.',vartmp ),0 )
               ELSEIF LI_MSTYP[ i ] == "D"
                  LI_MSLEN[ i ] := 8
               ELSEIF LI_MSTYP[ i ] == "L"
                  LI_MSLEN[ i ] := 1
               ENDIF
            ELSE
               LI_MSTYP[ i ] := FieldType( FieldPos( LI_MSF[ i ] ) )
            ENDIF
         NEXT
      ENDIF
   ENDIF
   IF VALTYPE( LI_MSED ) = "N"
      predit := LI_MSED
   ELSEIF VALTYPE( LI_MSED ) = "A"
      predit :=2
   ENDIF
   // SET CURSOR ( predit > 1 )
   SET CURSOR OFF
   SET EXACT OFF
   IF LI_LSOHR
      wndbuf := SAVESCREEN( LI_Y1, LI_X1, LI_Y2, LI_X2 )
   ENDIF
   oldcolors := SETCOLOR()
   SETCOLOR( LI_CLR )
   @ LI_Y1, LI_X1, LI_Y2, LI_X2 BOX "┌─┐│┘─└│ "
   IF title <> Nil
      @ LI_Y1, ( LI_X2 - LI_X1 - 1 - LEN( title ) ) / 2 + LI_X1 SAY " " + title + " "
   ENDIF
   IF title <> Nil .AND. LI_NAMES <> Nil
      LI_Y1 ++
   ENDIF
   razmer := LI_Y2 - LI_Y1 - 1
   IF .NOT. LI_PRFLT
      LI_KOLZ := EVAL( LI_RCOU,mslist )
   ENDIF
   LI_COLPOS := 1
   LI_NLEFT := LI_FREEZE + 1
   STORE .T. TO rez
   LI_NCOLUMNS := FLDCOUNT( mslist, LI_X1 + 2, LI_X2 - 2, LI_NLEFT )
   VIVNAMES( mslist )
   IF EVAL( LI_BEOF,mslist )
      EVAL( LI_BGTOP,mslist )
      LI_NSTR := 1
   ELSE
      EVAL( LI_BSKIP, mslist,- ( LI_NSTR - 1 ) )
      IF EVAL( LI_BBOF,mslist )
         EVAL( LI_BGTOP,mslist )
         LI_NSTR := 1
      ENDIF
   ENDIF
   WNDVIVOD( mslist )
   EVAL( LI_BSKIP, mslist,( LI_NSTR - 1 ) )
   IF LI_KOLZ = 0 .AND. LI_LADD
      LI_NSTR := 0
      KEYBOARD CHR( K_DOWN )
   ENDIF
   DO WHILE rez
      SETCOLOR( LI_CLR )
      EVAL( LI_B1,mslist )
      SETCOLOR( LI_CLRV )               // Выделить строку
      VIVSTR( mslist,LI_NSTR + LI_Y1, IIF( predit > 1, LI_COLPOS, 0 ) )
      SETCOLOR( LI_CLR )                // Убрать выделение
      //
#ifdef RDD_AX
      @ LI_Y1 + 2, LI_X2, LI_Y2 - 2, LI_X2 BOX LEFT( str_bar, 1 )
      @ LI_Y1 + 1, LI_X2 SAY SUBSTR( str_bar, 2, 1 )
      @ LI_Y2 - 1, LI_X2 SAY SUBSTR( str_bar, 2, 1 )
      @ LI_Y1 + 2 + INT( IIF( LI_PRFLT, LI_TEKZP, Ax_Keyno() ) * ( LI_Y2 - LI_Y1 - 4 ) / IIF( LI_PRFLT, LI_KOLZ, Ax_KeyCount() ) ), LI_X2 SAY RIGHT( str_bar, 1 )
#else
/*
      IF .NOT. ( TYPE( "Sx_Keyno()" ) == "U" )
         @ LI_Y1 + 2, LI_X2, LI_Y2 - 2, LI_X2 BOX LEFT( str_bar, 1 )
         @ LI_Y1 + 1, LI_X2 SAY SUBSTR( str_bar, 2, 1 )
         @ LI_Y2 - 1, LI_X2 SAY SUBSTR( str_bar, 2, 1 )
         fbar1 := "Sx_Keyno()"
         fbar2 := "Sx_KeyCount()"
         @ LI_Y1 + 2 + INT( IIF( LI_PRFLT, LI_TEKZP, &fbar1 ) * ( LI_Y2 - LI_Y1 - 4 ) / IIF( LI_PRFLT, LI_KOLZ, &fbar2 ) ), LI_X2 SAY RIGHT( str_bar, 1 )
      ENDIF
*/      
#endif
      //
      IF LI_LVIEW
         xkey := 27
      ELSE
#ifdef VER_MOUSE
         xkey := IN_KM( .F. )
         IF xkey = 502
            DO WHILE M_STAT() <> 0
            ENDDO
            xkey := 27
         ELSEIF xkey = 501
            ym := M_YTEXT()
            xm := M_XTEXT()
            IF ( ym <= LI_Y1 .OR. ym >= LI_Y2 .OR. xm <= LI_X1 .OR. xm >= LI_X2 )
               IF xm <= LI_X2 .AND. xm >= LI_X1 .AND. ( ym = LI_Y1 .OR. ym = LI_Y2 )
                  M_SHOW()
                  i := SECONDS()
                  DO WHILE SECONDS() - i < 0.05
                  ENDDO
                  KEYBOARD CHR( IIF( ym = LI_Y1, 5, 24 ) )
                  M_HIDE()
                  LOOP
               ELSEIF ctrl_ar <> Nil
                  FOR i := 1 TO LEN( ctrl_ar )
                     IF VALTYPE( ctrl_ar[ i ] ) = "C"
                        SETCOLOR( ctrl_ar[ i ] )
                     ELSE
                        rezproc := F_CTRL( ctrl_ar[ i ],,,,,, 1, ym, xm )
                        IF rezproc > 0
                           EXIT
                        ENDIF
                     ENDIF
                  NEXT
                  SETCOLOR( LI_CLR )
                  IF rezproc > 0
                     rezproc += 500
                     EXIT
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
#else
         xkey := INKEY( 0 )
#endif
      ENDIF
      VIVSTR( mslist,LI_NSTR + LI_Y1, 0 )         // строки
      IF xkey < 500
         DO CASE
         CASE xkey = 24                 // Курсор вниз
            IF ( LI_KOLZ > 0 .OR. LI_LADD ) .AND. ( LI_KOLZ = 0 .OR. .NOT. EVAL( LI_BEOF,mslist ) )
               EVAL( LI_BSKIP, mslist,1 )
               IF EVAL( LI_BEOF,mslist ) .AND. ( !LI_LADD .OR. LI_PRFLT )
                  EVAL( LI_BSKIP, mslist,- 1 )
               ELSE
                  IF EVAL( LI_BEOF,mslist )
                     vartmp   := LI_NLEFT
                     LI_NLEFT := LI_COLPOS := LI_FREEZE + 1
                     LI_NCOLUMNS   := FLDCOUNT( mslist,LI_X1 + 2, LI_X2 - 2, LI_NLEFT )
                     IF vartmp > LI_FREEZE + 1
                        EVAL( LI_BSKIP, mslist,- 1 )
                        EVAL( LI_BSKIP, mslist,- ( LI_NSTR - 1 ) )
                        WNDVIVOD( mslist )
                        EVAL( LI_BSKIP, mslist,LI_NSTR - 1 )
                        EVAL( LI_BSKIP,mslist )
                     ENDIF
                  ENDIF
                  LI_NSTR ++
                  IF LI_NSTR > razmer
                     LI_NSTR := razmer
                     SCROLL( LI_Y1 + 1, LI_X1 + 1, LI_Y2 - 1, LI_X2 - 1, 1 )
                     VIVSTR( mslist,LI_Y2 - 1, 0 )
                     DrawVSep( mslist )
                  ENDIF
                  IF EVAL( LI_BEOF,mslist )
                     KEYBOARD CHR( 13 )
                  ENDIF
               ENDIF
            ENDIF
         CASE xkey = 5 .AND. LI_KOLZ > 0                    // Курсор вверх
            EVAL( LI_BSKIP, mslist,- 1 )
            IF EVAL( LI_BBOF,mslist )
               EVAL( LI_BGTOP,mslist )
            ELSE
               LI_NSTR --
               IF LI_NSTR = 0
                  LI_NSTR := 1
                  SCROLL( LI_Y1 + 1, LI_X1 + 1, LI_Y2 - 1, LI_X2 - 1, - 1 )
                  VIVSTR( mslist,LI_Y1 + 1, 0 )
                  DrawVSep( mslist )
               ENDIF
            ENDIF
         CASE xkey = 4 .AND. LI_KOLZ <> 0                   // Курсор вправо
            IF predit > 1
               IF LI_COLPOS < LI_NCOLUMNS
                  LI_COLPOS ++
                  LOOP
               ENDIF
            ENDIF
            IF LI_NCOLUMNS + LI_NLEFT - LI_FREEZE - 1 < LI_COLCOUNT
               i := LI_NLEFT + LI_NCOLUMNS
               DO WHILE LI_NCOLUMNS + LI_NLEFT - LI_FREEZE - 1 < LI_COLCOUNT .AND. LI_NLEFT + LI_NCOLUMNS = i
                  LI_NLEFT ++
                  // DO MSFNEXT WITH mslist,LI_NLEFT
                  LI_NCOLUMNS := FLDCOUNT( mslist,LI_X1 + 2, LI_X2 - 2, LI_NLEFT )
               ENDDO
               LI_COLPOS := i - LI_NLEFT + 1
               EVAL( LI_BSKIP, mslist,- ( LI_NSTR - 1 ) )
               WNDVIVOD( mslist )
               EVAL( LI_BSKIP, mslist,LI_NSTR - 1 )
               VIVNAMES( mslist )
            ENDIF
         CASE xkey = 19                 // Курсор влево
            IF predit > 1
               LI_COLPOS --
            ENDIF
            IF LI_NLEFT > LI_FREEZE + 1 .AND. ( predit <= 1 .OR. LI_COLPOS < LI_FREEZE + 1 )
               LI_NLEFT --
               LI_NCOLUMNS := FLDCOUNT( mslist,LI_X1 + 2, LI_X2 - 2, LI_NLEFT )
               IF predit <= 1 .OR. LI_COLPOS < LI_FREEZE + 1
                  LI_COLPOS := LI_FREEZE + 1   // 1
               ENDIF
               EVAL( LI_BSKIP, mslist,- ( LI_NSTR - 1 ) )
               WNDVIVOD( mslist )
               EVAL( LI_BSKIP, mslist,LI_NSTR - 1 )
               VIVNAMES( mslist )
            ENDIF
            IF LI_COLPOS < 1
               LI_COLPOS := 1
            ENDIF
         CASE xkey = 3                  // PgDn
            EVAL( LI_BSKIP, mslist,razmer - LI_NSTR + 1 )
            LI_NSTR := 1
            IF EVAL( LI_BEOF,mslist )
               EVAL( LI_BSKIP, mslist,- 1 )
            ENDIF
            WNDVIVOD( mslist )
         CASE xkey = 18                 // PgUp
            IF LI_NSTR > 1
               EVAL( LI_BSKIP, mslist,- ( LI_NSTR - 1 ) )
               LI_NSTR := 1
            ELSE
               EVAL( LI_BSKIP, mslist,- razmer )
               IF EVAL( LI_BBOF,mslist )
                  EVAL( LI_BGTOP,mslist )
               ENDIF
               WNDVIVOD( mslist )
            ENDIF
         CASE xkey = 6 .AND. LI_KOLZ > 0                    // End
            EVAL( LI_BGBOT,mslist )
            EVAL( LI_BSKIP, mslist,- ( razmer - 1 ) )
            IF EVAL( LI_BBOF,mslist )
               EVAL( LI_BGTOP,mslist )
            ENDIF
            LI_NSTR := WNDVIVOD( mslist )
            EVAL( LI_BSKIP, mslist,LI_NSTR - 1 )
         CASE xkey = 1 .AND. LI_KOLZ > 0                    // Home
            LI_NSTR := 1
            EVAL( LI_BGTOP,mslist )
            WNDVIVOD( mslist )
         CASE xkey = K_ENTER .AND. predit < 2
            rez     := .F.
            rezproc := xkey
         CASE ( xkey = K_ENTER .OR. ( xkey > 47 .AND. xkey < 58 ) .OR. ( xkey > 64 .AND. xkey < 91 ) ;
                   .OR. ( xkey > 96 .AND. xkey < 123 ) .OR. ( xkey > 127 .AND. xkey < 176 ) .OR. ( xkey > 223 .AND. xkey < 240 ) ) .AND. predit > 1
            //   Редактирование
            fipos := LI_COLPOS + LI_NLEFT - 1 - LI_FREEZE
            IF LI_WHEN = Nil .OR. LEN( LI_WHEN ) < fipos .OR. LI_WHEN[ fipos ] = Nil .OR. EVAL( LI_WHEN[ fipos ] )
               lEdErr := .F.
               IF VALTYPE( LI_MSED ) != "N"
                  vartmp := IIF( LEN( LI_MSED ) < fipos, 1, LI_MSED[ fipos ] )
                  IF VALTYPE( vartmp ) = "N"
                     IF vartmp == 2
                        IF LI_MSF != Nil
                           IF Valtype( LI_MSF[ fipos ] ) == "B"
                              LOOP
                           ELSE
                              varbuf := FieldGet( FieldName( LI_MSF[ fipos ] ) )
                              cPicture := Defpict( FieldName( LI_MSF[ fipos ] ), LI_X2 - LI_X1 - 3 )
                           ENDIF
                        ELSE
                           varbuf := FieldGet( fipos )
                           cPicture := Defpict( fipos, LI_X2 - LI_X1 - 3 )
                        ENDIF
                     ELSE
                        LOOP
                     ENDIF
                  ELSEIF LI_MSF != Nil .AND. Valtype( LI_MSF[ fipos ] ) == "B"
                     varbuf := Eval( LI_MSF[ fipos ],mslist )
                     cPicture := LI_MSED[ fipos ]
                     lEdErr := .T.
                  ELSE
                     LOOP
                  ENDIF
               ELSE
                  varbuf := FieldGet( fipos )
               ENDIF
               SET CURSOR ON
               SETCOLOR( LI_CLRV + "," + LI_CLRV )
               IF xkey <> 13
                  KEYBOARD CHR( xkey ) + GetBuf()
               ENDIF
               vartmp := READEXIT( .T. )
               @ LI_NSTR + LI_Y1, LI_XPOS GET varbuf PICTURE cPicture
               IF LI_VALID <> Nil .AND. LEN( LI_VALID ) >= fipos .AND. LI_VALID[ fipos ] <> Nil
                  Getlist[ 1 ] :postBlock := LI_VALID[ fipos ]
               ENDIF
               READ
               IF LASTKEY() <> 27 .AND. UPDATED()
                  LI_UPDATED := .T.
                  IF EVAL( LI_BEOF,mslist )
                     APPEND BLANK
                     LI_KOLZ := EVAL( LI_RCOU,mslist )
                  ELSE
                     IF !lEdErr .AND. !SET( _SET_EXCLUSIVE )
                        RLOCK()
                        IF NETERR()
                           LOOP
                        ENDIF
                     ENDIF
                  ENDIF
                  IF LI_BDESHOUT != Nil .AND. VALTYPE( varbuf ) == "C"
                     varbuf := EVAL( LI_BDESHOUT, mslist,varbuf )
                  ENDIF
                  IF lEdErr
                     Eval( LI_MSF[ fipos ],mslist,fipos,varbuf )
                  ELSE
                     FIELDPUT( fipos, varbuf )
                  ENDIF
                  IF !lEdErr .AND. !SET( _SET_EXCLUSIVE )
                     UNLOCK
                  ENDIF
               ENDIF
               IF ( LASTKEY() = 27 .OR. .NOT. UPDATED() ) .AND. EVAL( LI_BEOF,mslist )
                  SETCOLOR( LI_CLR )
                  @ LI_NSTR + LI_Y1, LI_X1 + 1 CLEAR TO LI_NSTR + LI_Y1, LI_X2 - 1
                  LI_NSTR --
                  EVAL( LI_BSKIP, mslist,- 1 )
               ELSE
                  IF ( vartmp := LASTKEY() ) <> 13 .AND. vartmp <> 27 .AND. vartmp < 32
                     KEYBOARD CHR( vartmp )
                  ENDIF
               ENDIF
               READEXIT( vartmp )
               SET CURSOR OFF
            ENDIF
         CASE xkey = 27                 // Esc
            rez     := .F.
            rezproc := 0
/*
         CASE xkey = - 1 .AND. ( maskey = Nil .OR. ASCAN( maskey, xkey ) = 0 )  // F2
            IF predit = 1
               predit := predxx
            ELSEIF predit > 1
               predit := 1
            ENDIF
*/
         CASE xkey = 28
            DO CALCUL
#ifndef __NO_EXTRA__
         CASE xkey = - 10
            DO EXT_PRG
#ifdef RDD_AX
         // CASE xkey = - 39
         //   DO CheckDown
#endif
#endif
         OTHERWISE
            IF maskey <> Nil
               IF ASCAN( maskey, xkey ) <> 0
                  rez     := .F.
                  rezproc := xkey
               ENDIF
            ENDIF
         ENDCASE
#ifdef VER_MOUSE
      ELSE
         IF ym > LI_Y1 .AND. ym < LI_Y2 .AND. xm > LI_X1 .AND. xm < LI_X2
            IF predit < 2
               IF LI_NSTR = ym - LI_Y1
                  rez     := .F.
                  rezproc := 13
               ELSE
                  EVAL( LI_BSKIP, mslist,ym - LI_Y1 - LI_NSTR )
                  LI_NSTR := ym - LI_Y1
               ENDIF
            ELSE
               i := FLDCOUNT( mslist,LI_X1 + 2, xm, LI_NLEFT ) + 1
               IF i <= FLDCOUNT( mslist,LI_X1 + 2, LI_X2 - 2, LI_NLEFT )
                  IF i = 2 .AND. xm < LI_X1 + 2 + LEN( FLDSTR( mslist,LI_NLEFT + LI_COLPOS - 1 ) )
                     i := 1
                  ENDIF
                  IF LI_COLPOS <> i .OR. LI_NSTR <> ym - LI_Y1
                     LI_COLPOS := i
                     EVAL( LI_BSKIP, mslist,ym - LI_Y1 - LI_NSTR )
                     LI_NSTR := ym - LI_Y1
                  ELSE
                     KEYBOARD CHR( 13 )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         M_SHOW()
         DO WHILE M_STAT() <> 0
         ENDDO
         M_HIDE()
#endif
      ENDIF
   ENDDO

   IF LI_LSOHR
      RESTSCREEN( IIF( title <> Nil .AND. LI_NAMES <> Nil, LI_Y1 - 1, LI_Y1 ), LI_X1, LI_Y2, LI_X2, wndbuf )
   ELSE
      SETCOLOR( LI_CLRV )
      VIVSTR( mslist,LI_NSTR + LI_Y1, IIF( predit > 1, LI_COLPOS, 0 ) )
   ENDIF
   SETCOLOR( oldcolors )
   SET CURSOR ON
RETURN rezproc

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function FLDCOUNT()
*+
*+    Called from ( procs1.prg   )   6 - function dbflist()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION FLDCOUNT( mslist, xstrt, xend, fld1 )

LOCAL klf := 0, i := IIF( LI_FREEZE > 0, 1, fld1 )
   DO WHILE .T.
      xstrt += MAX( LEN( FLDSTR( mslist,i ) ), IIF( LI_NAMES <> Nil .AND. LEN( LI_NAMES ) >= i, LEN( LI_NAMES[ i ] ), 0 ) ) - 1
      IF xstrt > xend
         EXIT
      ENDIF
      klf ++
      i   := IIF( i = LI_FREEZE, fld1, i + 1 )
      xstrt += 2
      IF i > LI_COLCOUNT
         EXIT
      ENDIF
   ENDDO
RETURN IIF( klf = 0, 1, klf )

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function VIVNAMES()
*+
*+    Called from ( procs1.prg   )   3 - function dbflist()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION VIVNAMES( mslist )

LOCAL i   := 1, x, oldc, fif
   IF LI_NAMES <> Nil
      x := LI_X1 + 2
      IF LI_NMCLR <> Nil
         oldc := SETCOLOR( LI_NMCLR )
      ENDIF
      @ LI_Y1, x - 1 CLEAR TO LI_Y1, LI_X2 - 1
      fif := IIF( LI_FREEZE > 0, 1, LI_NLEFT )
      DO WHILE i <= LI_NCOLUMNS .AND. fif <= LEN( LI_NAMES )
         IF LI_NAMES[ fif ] <> Nil
            @ LI_Y1, x SAY LI_NAMES[ fif ]
         ENDIF
         x   += MAX( LEN( FLDSTR( mslist,fif ) ), LEN( LI_NAMES[ fif ] ) ) + 1
         fif := IIF( fif = LI_FREEZE, LI_NLEFT, fif + 1 )
         i ++
      ENDDO
      IF LI_NMCLR <> Nil
         SETCOLOR( oldc )
      ENDIF
   ENDIF
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function WNDVIVOD()
*+
*+    Called from ( procs1.prg   )   8 - function dbflist()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION WNDVIVOD( mslist )

LOCAL firstrec, nstr := 1, tekzp1, x := LI_X1 + 2, i, fif
   IF LI_PRFLT
      tekzp1 := LI_TEKZP
   ENDIF
   firstrec := EVAL( LI_RECNO,mslist )
   SETCOLOR( LI_CLR )
   @ LI_Y1 + 1, LI_X1 + 1 CLEAR TO LI_Y2 - 1, LI_X2 - 1
#ifdef __HARBOUR__
   DispBegin()
#endif
   DrawVSep( mslist )
   DO WHILE .T.
      VIVSTR( mslist,nstr + LI_Y1, 0 )
      nstr ++
      EVAL( LI_BSKIP, mslist,1 )
      IF nstr > LI_Y2 - LI_Y1 - 1 .OR. EVAL( LI_BEOF,mslist )
         EXIT
      ENDIF
   ENDDO
#ifdef __HARBOUR__
   DispEnd()
   Keyboard ""
#endif
   IF LI_PRFLT
      LI_TEKZP := tekzp1
   ENDIF
   EVAL( LI_BGOTO, mslist,firstrec )
RETURN nstr - 1

Static Function DrawVSep( mslist )
LOCAL x := LI_X1 + 2, i, fif
   fif := IIF( LI_FREEZE > 0, 1, LI_NLEFT )
   FOR i := 1 TO LI_NCOLUMNS
      sviv := FLDSTR( mslist,fif )
      x   += MAX( LEN( sviv ), IIF( LI_NAMES <> Nil .AND. LEN( LI_NAMES ) >= fif, LEN( LI_NAMES[ fif ] ), 0 ) )
      fif := IIF( fif == LI_FREEZE, LI_NLEFT, fif + 1 )
      IF fif <= LI_COLCOUNT
         @ LI_Y1+1, x, LI_Y2 - 1, x BOX Replicate( LI_SEPARATOR,9 )
      ENDIF
      x ++
   NEXT
Return Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Static Procedure VIVSTR()
*+
*+    Called from ( procs1.prg   )   5 - function dbflist()
*+                                   1 - function wndvivod()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
STATIC PROCEDURE VIVSTR( mslist,nstroka, vybfld )
LOCAL x, dx, i, shablon, sviv, fif, slen

   LI_XPOS := x := LI_X1 + 2
   IF LI_KOLZ > 0
      fif     := IIF( LI_FREEZE > 0, 1, LI_NLEFT )
      IF LI_NLEFT <> LI_FREEZE + 1 .AND. vybfld = 0
         @ nstroka, LI_X1 + 1 SAY "<"
      ENDIF
      IF DELETED()
         @ nstroka, LI_X1 + 1 SAY "*"
      ENDIF
      FOR i := 1 TO LI_NCOLUMNS
         IF i = LI_COLPOS
            LI_XPOS := x
         ENDIF
         sviv := FLDSTR( mslist,fif )
         sviv := IIF( LEN( sviv ) < LI_X2 - 1 - x, sviv, SUBSTR( sviv, 1, LI_X2 - 1 - x ) )
         IF vybfld = 0 .OR. vybfld = i
            @ nstroka, x SAY sviv
         ENDIF
         slen := LEN( sviv )
         dx := IIF( LI_NAMES <> Nil .AND. LEN( LI_NAMES ) >= fif, LEN( LI_NAMES[ fif ] ), 0 )
         IF i < LI_NCOLUMNS .AND. ( vybfld = 0 .OR. vybfld = i )
            IF dx > slen
               @ nstroka, x+slen SAY SPACE( dx - slen )
            ENDIF
         ENDIF
         x   += MAX( slen, dx ) + 1
         fif := IIF( fif == LI_FREEZE, LI_NLEFT, fif + 1 )
      NEXT
      IF fif <= LI_COLCOUNT .AND. vybfld = 0
         IF LI_X2 - 1 - x > 0
            sviv := FLDSTR( mslist,fif )
            @ nstroka, x SAY SUBSTR( sviv, 1, LI_X2 - 1 - x )
         ENDIF
         @ nstroka, LI_X2 - 1 SAY ">"
      ENDIF
   ENDIF
RETURN

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function FLDSTR()
*+
*+    Called from ( procs1.prg   )   1 - function dbflist()
*+                                   1 - function fldcount()
*+                                   1 - function vivnames()
*+                                   3 - static procedure vivstr()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION FLDSTR( mslist,numf )

LOCAL fldtype, rez, vartmp, nItem := numf
   IF LI_MSF != Nil
      IF numf <= LEN( LI_MSF )
         vartmp := LI_MSF[ numf ]
         IF ( fldtype := VALTYPE( vartmp ) ) = "B"
            vartmp := EVAL( vartmp,mslist,numf )
            IF LI_MSTYP[ numf ] == "C"
               RETURN PADR( vartmp,LI_MSLEN[ numf ] )
            ELSEIF LI_MSTYP[ numf ] == "N"
               RETURN PADL( STR( vartmp, LI_MSLEN[ numf ], LI_MSDEC[ numf ] ),LI_MSLEN[ numf ] )
            ELSEIF LI_MSTYP[ numf ] == "D"
               RETURN PADR( DTOC( vartmp ),LI_MSLEN[ numf ] )
            ELSEIF LI_MSTYP[ numf ] == "L"
               RETURN PADR( IIF( vartmp, "T", "F" ),LI_MSLEN[ numf ] )
            ENDIF
         ELSEIF fldtype = "C"
            numf := FIELDPOS( vartmp )
         ENDIF
      ENDIF
   ENDIF
   fldtype := FIELDTYPE( numf )
   DO CASE
   CASE fldtype = "C"
      rez := FIELDGET( numf )
   CASE fldtype = "N"
      rez := STR( FIELDGET( numf ), Iif( LI_MSLEN != Nil .AND. nItem <= LEN( LI_MSLEN ) .AND. LI_MSLEN[nItem] != Nil, LI_MSLEN[nItem], FIELDSIZE( numf ) ), FIELDDECI( numf ) )
   CASE fldtype = "D"
      rez := DTOC( FIELDGET( numf ) )
   CASE fldtype = "L"
      rez := IIF( FIELDGET( numf ), "T", "F" )
   CASE fldtype = "M"
      rez := "  <Memo>  "
   ENDCASE
   IF LI_BDESHIN <> Nil
      rez := EVAL( LI_BDESHIN, mslist,rez )
   ENDIF
RETURN rez

#ifndef __NO_EXTRA__

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Procedure EXT_PRG()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
PROCEDURE EXT_PRG

LOCAL bufs, i, oldc
   IF TYPE( "ms_ext_n" ) <> "U"
      bufs := SAVESCREEN( 0, 0, 24, 79 )
      oldc := SETCOLOR()
      SET COLOR TO GR+/N,N/W
      @ 07, 30, 8 + LEN( ms_ext_n ), 50 BOX "┌─┐│┘─└│ "
      i := ACHOICE( 08, 31, 7 + LEN( ms_ext_n ), 49, ms_ext_n )
      IF i <> 0
         SWPRUNCMD( ms_ext_p[ i ], 0, "", "" )
      ENDIF
      SETCOLOR( oldc )
      RESTSCREEN( 0, 0, 24, 79, bufs )
   ENDIF
   RETURN
#endif

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function GetBuf()
*+
*+    Called from ( procs1.prg   )   1 - function dbflist()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION GetBuf

LOCAL srez := ""
   DO WHILE NEXTKEY() <> 0
      srez += CHR( INKEY( 0 ) )
   ENDDO
   RETURN srez

*+ EOF: PROCS1.PRG
