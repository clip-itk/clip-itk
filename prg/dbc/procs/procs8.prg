/*
 * Common procedures
 *
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤
*+
*+    Source Module => D:\MYAPPS\SOURCE\PROCS\PROCS8.PRG
*+
*+    Functions: Function PCHCYCL()
*+               Function ZPLOCK()
*+               Function FILOCK()
*+               Procedure CALCUL()
*+               Static Function Vivchi()
*+               Procedure ANIMA()
*+               Function VIVCTRLS()
*+
*+    Reformatted by Click! 2.00 on Apr-12-2001 at  8:15 pm
*+
*+≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function PCHCYCL()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION PCHCYCL( kolpovt, expres, coor_x )

LOCAL strv
MEMVAR j1
PRIVATE j1
   FOR j1 := 1 TO kolpovt
      strv := &expres
      IF .NOT. EMPTY( strv )
         IF coor_x <> Nil
            @ nLine, coor_x SAY strv         
         ELSE
            ? strv
         ENDIF
         nLine ++
      ENDIF
   NEXT
RETURN .T.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function ZPLOCK()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION ZPLOCK

LOCAL screenb, oldc
   IF .NOT. RLOCK()
      screenb := SAVESCREEN( 11, 20, 11, 60 )
      oldc    := SETCOLOR()
      SETCOLOR( "+W/R" )
      @ 11, 23 SAY "ÜÑàíÖ! áÄèàëú àëèéãúáìÖíëü Ç ëÖíà!"         
      DO WHILE .NOT. RLOCK()
         IF INKEY( 1 ) = - 29
            QUIT
         ENDIF
      ENDDO
      SETCOLOR( oldc )
      RESTSCREEN( 11, 20, 11, 60, screenb )
   ENDIF
RETURN .T.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function FILOCK()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION FILOCK

LOCAL screenb, oldc, prexcl
   FiClose()
   prexcl := SET( _SET_EXCLUSIVE, .T. )
   IF .NOT. FIOPEN()
      screenb := SAVESCREEN( 11, 20, 11, 60 )
      oldc    := SETCOLOR()
      SET COLOR TO +W/R
      @ 11, 23 SAY "ÜÑàíÖ! îÄâã àëèéãúáìÖíëü Ç ëÖíà!"         
      DO WHILE .NOT. FIOPEN()
         IF INKEY( 2 ) = - 29
            QUIT
         ENDIF
      ENDDO
      SETCOLOR( oldc )
      RESTSCREEN( 11, 20, 11, 60, screenb )
   ENDIF
   SET( _SET_EXCLUSIVE, prexcl )
RETURN .T.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Procedure CALCUL()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
PROCEDURE CALCUL

LOCAL bufs, oldc, chi, chi2, nkey, ckey, prtchk, stroper, prnewchi, i
STATIC strchi := "                 0", msmemory := { 0, 0, 0 }, koldec := 2
   bufs := SAVESCREEN( 19, 0, 24, 20 )
   oldc := SETCOLOR()
   SET COLOR TO R/W
   @ 22,  0, 24, 20 BOX "⁄ƒø≥Ÿƒ¿≥ "
   FOR i := 1 TO 3
      IF msmemory[ 4 - i ] <> 0
         @ 18 + i, 1 SAY Vivchi( msmemory[ 4 - i ], koldec ) + ' '         
      ENDIF
   NEXT
   stroper  := " "
   prnewchi := .T.
   DO WHILE .T.
      prtchk := "." $ strchi
      @ 23,  1 SAY strchi + stroper         
      nkey := INKEY( 0 )
      ckey := CHR( nkey )
      DO CASE
      CASE nkey = 27
         EXIT
      CASE ckey $ "0123456789"
         IF prnewchi
            strchi   := SPACE( 17 ) + ckey
            prnewchi := .F.
         ELSE
            strchi := SUBSTR( strchi, 2 ) + ckey
         ENDIF
      CASE ckey = "."
         IF .NOT. prtchk
            IF prnewchi
               strchi   := SPACE( 17 ) + "."
               prnewchi := .F.
            ELSE
               strchi := SUBSTR( strchi, 2 ) + "."
            ENDIF
         ENDIF
      CASE ckey $ "*+-/" .OR. nkey = 13
         chi := VAL( LTRIM( strchi ) )
         IF stroper <> " "
            DO CASE
            CASE stroper = "+"
               chi := chi + chi2
            CASE stroper = "-"
               chi := chi2 - chi
            CASE stroper = "*"
               chi := chi2 * chi
            CASE stroper = "/"
               chi := chi2 / chi
            ENDCASE
            strchi := Vivchi( chi, koldec )
         ENDIF
         prnewchi := .T.
         chi2     := chi
         IF nkey = 13
            stroper := " "
         ELSE
            stroper := ckey
         ENDIF
      CASE nkey = 32
         strchi := SPACE( 17 ) + "0"
      CASE nkey = 8
         strchi := " " + SUBSTR( strchi, 1, 17 )
      CASE nkey <= - 20 .AND. nkey >= - 22
         msmemory[ ABS( nkey ) - 19 ] = VAL( LTRIM( strchi ) )
         FOR i := 1 TO 3
            IF msmemory[ 4 - i ] <> 0
               @ 18 + i, 1 SAY Vivchi( msmemory[ 4 - i ], koldec ) + ' '         
            ENDIF
         NEXT
      CASE ( nkey <= - 1 .AND. nkey >= - 2 ) .OR. nkey = 28
         IF ( i := msmemory[ IIF( nkey = 28, 1, ABS( nkey ) + 1 ) ] ) <> 0
            strchi := Vivchi( i, koldec )
         ENDIF
      CASE nkey = - 8
         @ 23,  1 CLEAR TO 23, 19
         @ 23,  1 SAY "Ñ•·.ß≠†™Æ¢: " + STR( koldec, 1 )         
         DO WHILE .T.
            DEVPOS( 23, 13 )
            i := INKEY( 0 )
            IF i > 47 .AND. i < 58
               koldec := i - 48
               EXIT
            ELSEIF i = 27
               EXIT
            ENDIF
         ENDDO
         @ 23,  1 SAY strchi + stroper         
      CASE nkey = - 9
         KEYBOARD LTRIM( strchi )
         EXIT
      ENDCASE
   ENDDO
   SETCOLOR( oldc )
   RESTSCREEN( 19, 0, 24, 20, bufs )
RETURN

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Static Function Vivchi()
*+
*+    Called from ( procs8.prg   )   4 - procedure calcul()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
STATIC FUNCTION Vivchi( chi, koldec )

LOCAL i, kolzn
   strc  := STR( chi, 18, koldec )
   kolzn := koldec
   FOR i := 1 TO koldec
      IF SUBSTR( strc, 19 - i, 1 ) = "0"
         kolzn := koldec - i
      ELSE
         EXIT
      ENDIF
   NEXT
   IF kolzn > 0
      strc := STR( chi, 18, kolzn )
   ELSE
      strc := STR( chi, 18 )
   ENDIF
RETURN strc

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Procedure ANIMA()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
PROCEDURE ANIMA( priznak, koll, strviv, y1, x1, x2 )

   DO CASE
   CASE priznak = 0 .OR. priznak = 3
      IF priznak = 0
         MSANIM[ 7 ] = strviv
         IF LEN( strviv ) > x2 - x1 - 1
            strviv := SUBSTR( strviv, 1, x2 - x1 - 4 ) + "..."
         ENDIF
         SET CURSOR OFF
         MSANIM[ 1 ] = 0
         MSANIM[ 2 ] = 0
         MSANIM[ 3 ] = INT( koll / ( x2 - x1 - 4 ) )
         MSANIM[ 4 ] = y1
         MSANIM[ 5 ] = x1
         MSANIM[ 6 ] = x2
      ELSE
         strviv := IIF( LEN( MSANIM[ 7 ] ) > MSANIM[ 6 ] - MSANIM[ 5 ] - 1, ;
                        SUBSTR( MSANIM[ 7 ], 1, MSANIM[ 6 ] - MSANIM[ 5 ] - 4 ) + "...", MSANIM[ 7 ] )
         y1 := MSANIM[ 4 ]
         x1 := MSANIM[ 5 ]
         x2 := MSANIM[ 6 ]
      ENDIF
      SET COLOR TO +W/W
      @ y1, x1, y1 + 4, x2 BOX "€ﬂ€€€‹€€ "
      @ y1 + 2, x1 + 2, y1 + 3, x2 - 2 BOX "⁄ƒø≥Ÿƒ¿≥ "
      SET COLOR TO N/W
      @ y1 + 2, x1 + 2                                SAY "⁄"            
      @ y1 + 2, x1 + 3 TO y1 + 2, x2 - 3
      @ y1 + 3, x1 + 2                                SAY "¿"            
      @ y1 + 1, INT( ( 80 - LEN( strviv ) ) / 2 ) + 1 SAY strviv         
      IF priznak = 3
         SET COLOR TO +W/W
         @ MSANIM[  4 ] + 2, MSANIM[ 5 ] + 2 SAY "⁄"         
         @ MSANIM[  4 ] + 3, MSANIM[ 5 ] + 2 SAY "¿"         
         @ MSANIM[  4 ] + 2, MSANIM[ 5 ] + 3 TO MSANIM[ 4 ] + 2, MSANIM[ 5 ] + MSANIM[ 2 ] + 1
         SET COLOR TO N/W
         @ MSANIM[  4 ] + 2, MSANIM[ 5 ] + 2 + MSANIM[ 2 ] SAY "ø"         
         @ MSANIM[  4 ] + 3, MSANIM[ 5 ] + 2 + MSANIM[ 2 ] SAY "Ÿ"         
         @ MSANIM[  4 ] + 3, MSANIM[ 5 ] + 3 TO MSANIM[ 4 ] + 3, MSANIM[ 5 ] + MSANIM[ 2 ] + 1
      ENDIF
   CASE priznak = 1
      MSANIM[ 1 ] = MSANIM[ 1 ] + 1
      IF MSANIM[ 1 ] = MSANIM[ 3 ] .AND. MSANIM[ 2 ] < MSANIM[ 6 ] - MSANIM[ 5 ] - 4
         MSANIM[ 1 ] = 0
         MSANIM[ 2 ] = MSANIM[ 2 ] + 1
         SET COLOR TO +W/W
         @ MSANIM[  4 ] + 2, MSANIM[ 5 ] + 2 SAY "⁄"         
         @ MSANIM[  4 ] + 3, MSANIM[ 5 ] + 2 SAY "¿"         
         @ MSANIM[  4 ] + 2, MSANIM[ 5 ] + 3 TO MSANIM[ 4 ] + 2, MSANIM[ 5 ] + MSANIM[ 2 ] + 1
         SET COLOR TO N/W
         @ MSANIM[  4 ] + 2, MSANIM[ 5 ] + 2 + MSANIM[ 2 ] SAY "ø"         
         @ MSANIM[  4 ] + 3, MSANIM[ 5 ] + 2 + MSANIM[ 2 ] SAY "Ÿ"         
         @ MSANIM[  4 ] + 3, MSANIM[ 5 ] + 3 TO MSANIM[ 4 ] + 3, MSANIM[ 5 ] + MSANIM[ 2 ] + 1
      ENDIF
   CASE priznak = 2
      SET COLOR TO N/W
      @ MSANIM[  4 ] + 1, MSANIM[ 5 ] + 1 CLEAR TO MSANIM[ 4 ] + 1, MSANIM[ 6 ] - 1
      @ MSANIM[  4 ] + 1, INT( ( 80 - LEN( strviv ) ) / 2 ) + 1 SAY strviv         
      INKEY( 2 )
   ENDCASE
   SET CURSOR ON
RETURN

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function VIVCTRLS()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION VIVCTRLS( mctrl )

LOCAL i
   FOR i := 1 TO LEN( mctrl )
      @ VAL( LEFT( mctrl[ i ], 2 ) ), VAL( SUBSTR( mctrl[ i ], 3, 2 ) ) SAY SUBSTR( mctrl[ i ], 5 )         
   NEXT
RETURN .T.

*+ EOF: PROCS8.PRG
