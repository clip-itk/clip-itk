/*
 * DBC - Database Control Utility
 * Menu functions
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => D:\MYAPPS\SOURCE\MYDBU\PRCMENU.PRG
*+
*+    Functions: Function MainMenu()
*+               Function OutMenu()
*+               Function F_CTRL()
*+               Function IN_KM()
*+               Function M_XTEXT()
*+               Function M_YTEXT()
*+
*+    Reformatted by Click! 2.00 on Jun-20-2001 at 12:51 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

#include "color.ch"
#include "inkey.ch"
MEMVAR mwidth, horiz
/*
 …á«¨ ­ ¦ â  ª« ¢¨è , ¢®§¢à é ¥â 0 ¨«¨ ­®¬¥à ¢ë¡à ­­®£® í«¥¬¥­â .
 …á«¨ ­ ¦ â  ª­®¯ª  ¬ëè¨: (¯à ¢ ï) - 0,
 («¥¢ ï) - ¥á«¨ ­ ¦ â  ­  í«¥¬¥­â¥, â® ­®¬¥à ¢ë¡à ­­®£® í«¥¬¥­â ,
           ¥á«¨ ¬¨¬® ¨ ­¥â ¯®«ì§.äã­ªæ¨¨ - 501,
           ¥á«¨ ¥áâì ¯®«ì§.äã­ªæ¨ï - 0,­®¬¥à ¢ë¡à ­­®£® í«¥¬¥­â , ¨«¨
           >1000 (®¯à¥¤-áï ¯®«ì§.äã­ªæ¨¥©)
*/

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MainMenu()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION MainMenu( y1, x1, y2, x2, aMenu, aDostup, bUserF, choic, level, menu_len, prenter )

LOCAL laSimple
LOCAL ykoor, xkoor
LOCAL i, j, xm, ym, res, oldcurs, box_len, fitem := 1, delta, key, nind
PRIVATE mwidth, horiz
   choic    := IIF( choic = Nil .OR. choic > LEN( aMenu ), 1, choic )
   level    := IIF( level = Nil, 0, level )
   menu_len := IIF( menu_len = Nil, LEN( aMenu ), menu_len )
   box_len  := IIF( y1 <> Nil, MIN( y2 - y1 + 1, menu_len ), menu_len )
   laSimple := ( VALTYPE( aMenu[ 1 ] ) <> "A" )
   IF laSimple .OR. LEN( aMenu[ 1 ] ) < 3
      horiz := .F.
   ELSE
      horiz := ( aMenu[ 1, 3 ] == aMenu[ 2, 3 ] )
   ENDIF
   IF .NOT. horiz
      IF x1 <> Nil
         mwidth := x2 - x1 + 1
      ELSE
         mwidth := 0
         FOR i := 1 TO menu_len
            mwidth := MAX( mwidth, LEN( aMenu[ i, 1 ] ) )
         NEXT
      ENDIF
   ENDIF
   oldcurs := SETCURSOR( 0 )
   DO WHILE choic <= menu_len .AND. ( ( aDostup <> Nil .AND. .NOT. aDostup[ choic ] ) .OR. ASC( IIF( laSimple, aMenu[ choic ], aMenu[ choic, 1 ] ) ) = 196 )
      choic ++
   ENDDO
   IF box_len <> menu_len
      fitem := choic
   ENDIF
   OutMenu( aMenu, aDostup, y1, x1, y2, x2, fitem, menu_len )
   DO WHILE .T.
      IF laSimple .OR. LEN( aMenu[ 1 ] ) < 3
         ykoor := y1 + choic - fitem
         xkoor := x1
      ELSE
         ykoor := aMenu[ choic - fitem + 1, 3 ]
         xkoor := aMenu[ choic - fitem + 1, 4 ]
      ENDIF
      IF choic <= menu_len .AND. choic > 0
         COLORSELECT( CLR_ENHANCED )
         IF horiz
            @ ykoor, xkoor SAY IIF( laSimple, aMenu[ choic ], aMenu[ choic, 1 ] )         
         ELSE
            @ ykoor, xkoor SAY PADR( IIF( laSimple, aMenu[ choic ], aMenu[ choic, 1 ] ), mwidth )         
         ENDIF
         COLORSELECT( CLR_STANDARD )
      ENDIF
#ifdef VER_MOUSE
      key := IN_KM( .F. )
#else
      key := INKEY( 0 )
#endif
      IF choic <= menu_len .AND. choic > 0
         IF horiz
            @ ykoor, xkoor SAY IIF( laSimple, aMenu[ choic ], aMenu[ choic, 1 ] )         
         ELSE
            @ ykoor, xkoor SAY PADR( IIF( laSimple, aMenu[ choic ], aMenu[ choic, 1 ] ), mwidth )         
         ENDIF
      ENDIF
      IF key < 500
         DO CASE
         CASE ( .NOT. horiz .AND. key = K_UP ) .OR. ( horiz .AND. key = K_LEFT ) .OR. key = K_END
            IF key = K_END
               choic := menu_len + 1
            ENDIF
            IF choic <> fitem .OR. fitem > 1
               delta := 1
               choic --
               DO WHILE choic > 0 .AND. ( ( aDostup <> Nil .AND. .NOT. aDostup[ choic ] ) .OR. ASC( IIF( laSimple, aMenu[ choic ], aMenu[ choic, 1 ] ) ) = 196 )
                  choic --
                  delta ++
               ENDDO
               IF choic = 0
                  choic += delta
                  delta := 0
               ENDIF
               IF key = K_END .AND. fitem <> choic - box_len + 1
                  fitem := choic - box_len + 1
                  OutMenu( aMenu, aDostup, y1, x1, y2, x2, fitem, menu_len )
               ELSEIF fitem > 1 .AND. choic - delta < fitem
                  fitem := choic
                  OutMenu( aMenu, aDostup, y1, x1, y2, x2, fitem, menu_len )
               ENDIF
            ENDIF
         CASE ( .NOT. horiz .AND. key = K_DOWN ) .OR. ( horiz .AND. key = K_RIGHT ) .OR. key = K_HOME
            IF key = K_HOME
               choic := 0
            ENDIF
            IF choic <> fitem + box_len - 1 .OR. ( box_len <> menu_len .AND. choic < menu_len )
               delta := 1
               choic ++
               DO WHILE choic <= menu_len .AND. ( ( aDostup <> Nil .AND. .NOT. aDostup[ choic ] ) .OR. ASC( IIF( laSimple, aMenu[ choic ], aMenu[ choic, 1 ] ) ) = 196 )
                  choic ++
                  delta ++
               ENDDO
               IF choic > menu_len
                  choic -= delta
                  delta := 0
               ENDIF
               IF key = K_HOME .AND. fitem <> choic
                  fitem := choic
                  OutMenu( aMenu, aDostup, y1, x1, y2, x2, fitem, menu_len )
               ELSEIF box_len <> menu_len .AND. choic - fitem + 1 > box_len
                  fitem := choic - box_len + 1
                  OutMenu( aMenu, aDostup, y1, x1, y2, x2, fitem, menu_len )
               ENDIF
            ENDIF
         CASE key = K_PGDN .AND. .NOT. horiz .AND. menu_len > fitem + box_len - 1
            fitem += box_len - 1
            IF fitem > menu_len - box_len + 1
               fitem := menu_len - box_len + 1
            ENDIF
            choic := fitem
            OutMenu( aMenu, aDostup, y1, x1, y2, x2, fitem, menu_len )
         CASE key = K_PGUP .AND. .NOT. horiz .AND. choic > 1
            IF choic > fitem
               choic := fitem
            ELSE
               fitem := IIF( fitem >= box_len, fitem - box_len + 1, 1 )
               choic := fitem
               OutMenu( aMenu, aDostup, y1, x1, y2, x2, fitem, menu_len )
            ENDIF
         CASE key = K_ESC
            res := 0
            EXIT
         CASE .NOT. horiz .AND. level > 0 .AND. key = K_LEFT
            res := 0
            KEYBOARD CHR( K_LEFT ) + CHR( K_ENTER )
            EXIT
         CASE .NOT. horiz .AND. level > 0 .AND. key = K_RIGHT
            res := 0
            KEYBOARD CHR( K_RIGHT ) + CHR( K_ENTER )
            EXIT
         CASE key = K_ENTER .OR. ( key >= 49 .AND. key <= 57 )
            IF key >= 49
               res := key - 48
            ELSE
               res := choic
            ENDIF
            COLORSELECT( CLR_ENHANCED )
            IF horiz
               @ ykoor, xkoor SAY IIF( laSimple, aMenu[ choic ], aMenu[ choic, 1 ] )         
            ELSE
               @ ykoor, xkoor SAY PADR( IIF( laSimple, aMenu[ choic ], aMenu[ choic, 1 ] ), mwidth )         
            ENDIF
            EXIT
         OTHERWISE
            IF Ascan( { K_DOWN,K_UP,K_RIGHT,K_LEFT,K_HOME,K_END,K_PGDN,K_PGUP }, key ) == 0
               IF bUserf <> Nil
                  nind := choic
                  res  := EVAL( bUserf, nind, key )
                  IF res < 2
                     res := IIF( res == 0, 0, res )
                     EXIT
                  ELSEIF res == 2
                     res := choic
                     EXIT
                  ELSE
                     EXIT
                  ENDIF
               ENDIF
            ENDIF
         ENDCASE
#ifdef VER_MOUSE
      ELSE
         IF key = 502
            DO WHILE M_STAT() <> 0
            ENDDO
            res := 0
            EXIT
         ELSEIF key = 501
            ym := M_YTEXT()
            xm := M_XTEXT()
            i  := F_CTRL( aMenu, aDostup, y1, x1, y2, x2, fitem, ym, xm )
            IF i <> 0 .AND. ( aDostup = Nil .OR. aDostup[ i ] )
               IF i = choic
                  res := choic
                  EXIT
               ELSE
                  res := choic := i
                  IF prenter = Nil .OR. .NOT. prenter
                     EXIT
                  ENDIF
               ENDIF
            ELSEIF i = 0 .AND. .NOT. horiz .AND. box_len < menu_len .AND. xm >= x1 .AND. xm <= x2 .AND. ( ym = y2 + 1 .OR. ym = y1 - 1 )
               IF ym = y2 + 1
                  DO WHILE M_STAT() <> 0 .AND. M_YTEXT() = ym .AND. fitem < menu_len - box_len + 1
                     fitem ++
                     OutMenu( aMenu, aDostup, y1, x1, y2, x2, fitem, menu_len )
                     M_SHOW()
                     j := SECONDS()
                     DO WHILE SECONDS() - j < 0.1
                     ENDDO
                     M_HIDE()
                  ENDDO
                  choic := fitem
               ELSEIF ym = y1 - 1
                  DO WHILE M_STAT() <> 0 .AND. M_YTEXT() = ym .AND. fitem > 1
                     fitem --
                     OutMenu( aMenu, aDostup, y1, x1, y2, x2, fitem, menu_len )
                     M_SHOW()
                     j := SECONDS()
                     DO WHILE SECONDS() - j < 0.1
                     ENDDO
                     M_HIDE()
                  ENDDO
                  choic := fitem
               ENDIF
            ELSE
               M_SHOW()
               DO WHILE M_STAT() <> 0
               ENDDO
               M_HIDE()
               IF bUserf = Nil
                  res := 501
                  EXIT
               ELSE
                  nind := choic
                  res  := EVAL( bUserf, nind, key )
                  IF res < 2
                     res := IIF( res = 0, 0, res )
                     EXIT
                  ELSEIF res = 2
                  ELSE
                     EXIT
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
#endif
      ENDIF
   ENDDO
   SETCURSOR( oldcurs )
   COLORSELECT( CLR_STANDARD )
RETURN res

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function OutMenu()
*+
*+    Called from ( prcmenu.prg  )   9 - function mainmenu()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION OutMenu( aMenu, aDostup, y1, x1, y2, x2, choic, menu_len )

LOCAL i, ykoor, xkoor, laSimple, stmp
   laSimple := ( VALTYPE( aMenu[ 1 ] ) <> "A" )
   choic    := IIF( choic = Nil, 1, choic )
   menu_len := IIF( menu_len = Nil, LEN( aMenu ), menu_len )
   FOR i := choic TO menu_len
      IF laSimple .OR. LEN( aMenu[ 1 ] ) < 3
         ykoor := y1 + i - choic
         xkoor := x1
      ELSE
         ykoor := aMenu[ i + choic - 1, 3 ]
         xkoor := aMenu[ i + choic - 1, 4 ]
      ENDIF
      IF y2 <> Nil .AND. ykoor > y2
         EXIT
      ENDIF
      IF aDostup <> Nil
         IF .NOT. aDostup[ i ]
            COLORSELECT( CLR_UNSELECTED )
         ELSE
            COLORSELECT( CLR_STANDARD )
         ENDIF
      ENDIF
      stmp := IIF( laSimple, aMenu[ i ], aMenu[ i, 1 ] )
      IF stmp = 'Ä'
         stmp := REPLICATE( 'Ä', mwidth )
      ENDIF
      IF horiz
         @ ykoor, xkoor SAY stmp         
      ELSE
         @ ykoor, xkoor SAY PADR( stmp, mwidth )         
      ENDIF
   NEXT
   RETURN Nil

#ifdef VER_MOUSE

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function F_CTRL()
*+
*+    Called from ( prcmenu.prg  )   1 - function mainmenu()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION F_CTRL( mctrl, aDostup, y1, x1, y2, x2, fitem, ym, xm )

LOCAL i, mlen, xkoor, ykoor, bufc, laSimple, ilen
   laSimple := ( VALTYPE( mctrl[ 1 ] ) <> "A" )
   mlen     := LEN( mctrl )
   mlen     := IIF( y1 <> Nil, MIN( y2 - y1 + 1, mlen ), mlen )
   FOR i := 1 TO mlen
      IF laSimple .OR. LEN( mctrl[ 1 ] ) < 3
         ykoor := y1 + i - 1
         xkoor := x1
         ilen  := x2 - x1 + 1
      ELSE
         ykoor := mctrl[ i + fitem - 1, 3 ]
         xkoor := mctrl[ i + fitem - 1, 4 ]
         IF LEN( mctrl[ i ] ) = 6
            ilen := 0
         ELSE
            ilen := LEN( mctrl[ i + fitem - 1, 1 ] )
         ENDIF
      ENDIF
      IF ( ( ilen = 0 .AND. ym <= mctrl[ i + fitem - 1, 5 ] .AND. ym >= ykoor .AND. xm >= xkoor .AND. xm < mctrl[ i + fitem - 1, 6 ] ) .OR. ;
             ( ilen <> 0 .AND. ym = ykoor .AND. xm >= xkoor .AND. xm < xkoor + ilen ) ) ;
             .AND. ( aDostup = Nil .OR. aDostup[ i + fitem - 1 ] )
         IF ilen > 0
            COLORSELECT( CLR_ENHANCED )
            @ ykoor, xkoor SAY PADR( IIF( laSimple, mctrl[ i + fitem - 1 ], mctrl[ i + fitem - 1, 1 ] ), ilen )         
            COLORSELECT( CLR_STANDARD )
         ENDIF
         M_SHOW()
         DO WHILE M_STAT() <> 0
         ENDDO
         M_HIDE()
         EXIT
      ENDIF
   NEXT
RETURN IIF( i > mlen, 0, i + fitem - 1 )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function IN_KM()
*+
*+    Called from ( prcmenu.prg  )   1 - function mainmenu()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION IN_KM( w_0 )

LOCAL rez, mstat
   IF TYPE( "is_mpresent" ) <> "L"
PUBLIC is_mpresent := ( M_INIT() <> 0 )
   ENDIF
   IF is_mpresent
      M_SHOW()
   ENDIF
   DO WHILE .T.
      IF ( rez := INKEY() ) <> 0
         EXIT
      ENDIF
      IF is_mpresent .AND. ( mstat := M_STAT() ) <> 0
         IF w_0 = Nil .OR. w_0
            DO WHILE M_STAT() <> 0
            ENDDO
         ENDIF
         rez := mstat + 500
         EXIT
      ENDIF
   ENDDO
   IF is_mpresent
      M_HIDE()
   ENDIF
RETURN rez

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function M_XTEXT()
*+
*+    Called from ( prcmenu.prg  )   1 - function mainmenu()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION M_XTEXT

RETURN M_XPOS() / 8

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function M_YTEXT()
*+
*+    Called from ( prcmenu.prg  )   3 - function mainmenu()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION M_YTEXT

RETURN M_YPOS() / 8
#endif

*+ EOF: PRCMENU.PRG
