/*
 * DBC - Database Control Utility
 * Structure handling
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤
*+
*+    Source Module => D:\MYAPPS\SOURCE\MYDBU\MODISTRU.PRG
*+
*+    Functions: Function StruView()
*+               Function StruMan()
*+               Function VldStru()
*+               Function SelFiel()
*+               Function Userf1()
*+               Function Userf2()
*+               Function Addfiel()
*+               Function Insfiel()
*+               Function Delfiel()
*+               Function Chngfiel()
*+
*+       Tables: USE DBCSTRU EXCLUSIVE
*+               USE
*+               USE &fi1
*+
*+    Reformatted by Click! 2.00 on Jun-20-2001 at 12:49 pm
*+
*+≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤

#ifdef RDD_AX
#ifdef __HARBOUR__
#include "ads.ch"
#else
#include "axntxcdx.ch"
#endif
#endif
#include "deflist.ch"

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function StruView()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION StruView

LOCAL m2, m3, m4, i, kolf
PRIVATE m1
   kolf := FCOUNT()
   m1   := ARRAY( kolf )
   m2   := ARRAY( kolf )
   m3   := ARRAY( kolf )
   m4   := ARRAY( kolf )
   AFIELDS( m1, m2, m3, m4 )
   FOR i := 1 TO kolf
      m1[ i ] = PADR( m1[ i ], 10 ) + m2[ i ] + "   " + STR( m3[ i ], 3 ) + "   " + STR( m4[ i ], 1 )
   NEXT
   SET COLOR TO GR+/N,N+/W
   @  5, 22, 20, 46 BOX ORAMKA
   @ 20, 25 SAY " Alt-P - Print "         
   DO WHILE i <> 0
      i := MainMenu( 6, 24, 19, 44, m1,, { || PrnStru1() } )
   ENDDO
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function StruMan()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION StruMan( prnew )

LOCAL oldimp := improc, vybkey, rez := .T.
LOCAL nrec, fi1, fi2, fi3, fi4, i := FCOUNT(), j, alsname
#ifdef ENGLISH
LOCAL ctrl_ar := { "B/W,W/B", ;
                      { { "ESC - Exit",, 20, 22 }, { "ALT-M - Save",, 20, 37 } } }
#else
LOCAL ctrl_ar := { "B/W,W/B", ;
                      { { "ESC - ÇÎÂÆ§",, 20, 22 }, { "ALT-M - ëÆÂ‡†≠®‚Ï",, 20, 37 } } }
#endif
PRIVATE chng_name := .F., chng_kol := .F., chng_par := .F.
   IF .NOT. prnew
      IF .NOT. msmode[ improc, 1 ]
         IF .NOT. FileLock()
            KEYBOARD CHR( 27 )
            RETURN
         ENDIF
      ENDIF
      alsname := ALIAS()
   ENDIF
   SET DELETED ON
   PRIVATE A1[ i ], A2[ i ], A3[ i ], A4[ i ], kolf, B1, B2, B3, B4, C1, C2
   PRIVATE mslist := Initlist()
   IF prnew
      SELECT 20
      CREATE dbcstru
   ELSE
      AFIELDS( A1, A2, A3, A4 )
      COPY STRUCTURE EXTENDED TO dbcstru
   ENDIF
   SELECT 20
   USE DBCSTRU EXCLUSIVE
   LI_CLR  := "GR+/N"
   LI_CLRV := "N+/W"
#ifdef ENGLISH
   LI_NAMES := { "Name", "Type", "Lenth", "Dec" }
#else
   LI_NAMES := { "à¨Ô", "í®Ø", "Ñ´®≠†", "Ñ•·." }
#endif
   LI_MSED       := 3
   LI_LADD       := .T.
   LI_VALID      := ARRAY( 4 )
   LI_VALID[ 1 ] := { || varbuf := UPPER( varbuf ), VldStru( 1 ) }
   LI_VALID[ 2 ] := { || varbuf := UPPER( varbuf ), VldStru( 2 ) }
   LI_VALID[ 3 ] := { || VldStru( 3 ) }
   LI_VALID[ 4 ] := { || VldStru( 4 ) }
   LI_WHEN       := ARRAY( 4 )
   LI_WHEN[ 3 ]  := { || Field_Type $ "CNV" }
   LI_WHEN[ 4 ]  := { || Field_Type = "N" }
   SET COLOR TO B/W
   @  3, 17, 21, 58 BOX ORAMKA
#ifdef ENGLISH
   @  4, 26 SAY IIF( prnew, "New file creating", "Structure " + msfile[ improc ] )         
#else
   @  4, 26 SAY IIF( prnew, "ëÆß§†≠®• ≠Æ¢Æ£Æ ‰†©´†", "ë‚‡„™‚„‡† " + msfile[ improc ] )         
#endif
   OutCtrls( ctrl_ar )
   DO WHILE rez
      LI_LSOHR := .F.
      vybkey   := dbflist( mslist, 23, 5, 52, 19, "", { 7, 22, 306 }, ctrl_ar )
      DO CASE
      CASE vybkey = 0 .OR. vybkey = 501
         rez := .F.
      CASE vybkey = 7
         DELETE
         chng_kol := .T.
         SKIP
      CASE vybkey = 22
         nrec := RECNO()
         APPEND BLANK
         LI_KOLZ ++
         DO WHILE RECNO() > nrec
            SKIP - 1
            fi1 := FIELD_NAME
            fi2 := FIELD_TYPE
            fi3 := FIELD_LEN
            fi4 := FIELD_DEC
            SKIP
            REPLACE FIELD_NAME WITH fi1, FIELD_TYPE WITH fi2, FIELD_LEN WITH fi3, FIELD_DEC WITH fi4
            SKIP - 1
         ENDDO
         REPLACE FIELD_NAME WITH "", FIELD_TYPE WITH "", FIELD_LEN WITH 0, FIELD_DEC WITH 0
         chng_kol := .T.
      CASE vybkey = 306 .OR. vybkey = 502
         PACK
         USE
         IF prnew
            fi1 := FileMan( "*.dbf", .T. )
            IF .NOT. EMPTY( fi1 )
               CREATE &fi1 FROM DBCSTRU
               USE
               FiOpen( fi1 )
            ENDIF
         ELSE
            fi1 := mypath + "a0_new"
            CREATE &fi1 FROM DBCSTRU
            IF chng_name .AND. .NOT. chng_kol .AND. .NOT. chng_par
               SELECT( improc )
               COPY TO dbcuuuuu.txt SDF
               SELECT 20
               APPEND FROM dbcuuuuu.txt SDF
               //      ERASE dbcuuuuu.txt
            ELSE
               kolf := FCOUNT()
               B1   := ARRAY( kolf )
               B2   := ARRAY( kolf )
               B3   := ARRAY( kolf )
               B4   := ARRAY( kolf )
               C1   := ARRAY( kolf )
               C2   := ARRAY( kolf )
               AFIELDS( B1, B2, B3, B4 )
               FOR i := 1 TO kolf
                  j := ASCAN( A1, B1[ i ] )
                  IF j > 0
                     C2[ i ] = j
                     IF B2[ i ] = A2[ j ] .AND. B3[ i ] = A3[ j ] .AND. B4[ i ] = A4[ j ]
                        IF C1[ i ] = Nil
                           C1[ i ] := &( "{|param|param}" )
                        ENDIF
                     ELSE
                        IF C1[ i ] = Nil
                           DO CASE
                           CASE A2[ j ] = "C" .AND. B2[ i ] = "N"
                              C1[ i ] := &( "{|param|VAL(param)}" )
                           CASE A2[ j ] = "N" .AND. B2[ i ] = "C"
                              C1[ i ] := &( "{|param|LTRIM(STR(param," + LTRIM( STR( A3[ j ], 2 ) ) + "," + LTRIM( STR( A4[ j ], 2 ) ) + "))}" )
                           CASE A2[ j ] = "C" .AND. B2[ i ] = "C"
                              C1[ i ] := &( "{|param|SUBSTR(param,1," + NUM_STR( A3[ j ], 4 ) + ")}" )
                           CASE A2[ j ] = "N" .AND. B2[ i ] = "N"
                              C1[ i ] := &( "{|param|param}" )
                           OTHERWISE
                              //           C1[i] := &("{|param|param}")
                           ENDCASE
                        ENDIF
                     ENDIF
                  ENDIF
               NEXT
               SELECT( improc )
               DO ANIMA WITH 0, RECCOUNT(), 'Structure modification ...', 8, 6, 72
               GO TOP
               DO WHILE .NOT. EOF()
                  SELECT 20
                  APPEND BLANK
                  FOR i := 1 TO kolf
                     IF C1[ i ] <> Nil
                        FIELDPUT( i, EVAL( C1[ i ], (alsname)->( FIELDGET( C2[ i ] ) ) ) )
                     ENDIF
                  NEXT
                  SELECT( improc )
                  DO ANIMA WITH 1
                  SKIP
               ENDDO
               DO ANIMA WITH 2, 0, 'Modification completed.'
            ENDIF
            SELECT( improc )
            USE
            SELECT 20
            USE
            fi1 := Cutexten( msfile[ improc ] )
            ERASE &(fi1+".bak")
            FRENAME( fi1 + ".dbf", fi1 + ".bak" )
            FRENAME( mypath + "a0_new.DBF", fi1 + ".dbf" )
            IF FILE( mypath + "a0_new.fpt" )
               FRENAME( mypath + "a0_new.fpt", fi1 + ".fpt" )
            ENDIF
            SELECT( improc )
            USE &fi1
         ENDIF
         prkorf  := .T.
         prkorst := .T.
         rez     := .F.
      ENDCASE
   ENDDO
   SELECT 20
   USE
   FERASE( "DBCSTRU.DBF" )
   SET DELETED OFF
   SELECT( improc )
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function VldStru()
*+
*+    Called from ( modistru.prg )   4 - function struman()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION VldStru( numf )

LOCAL nrec
   IF varbuf <> FIELDGET( numf )
      IF numf > 1
         IF EVAL( LI_BEOF, mslist )
            RETURN .F.
         ELSE
            chng_par := .T.
         ENDIF
      ENDIF
      DO CASE
      CASE numf = 1
         nrec := RECNO()
         LOCATE FOR FIELD_NAME = varbuf
         IF FOUND()
#ifdef ENGLISH
            MsgInf( "Fieldname already exists" )
#else
            MsgInf( "í†™Æ• ®¨Ô „¶• •·‚Ï" )
#endif
            GO nrec
            RETURN .F.
         ENDIF
         GO nrec
         chng_name := .T.
         IF EVAL( LI_BEOF, mslist )
         ENDIF
      CASE numf = 2
         IF .NOT. ( varbuf $ "CNDLM" )
#ifdef ENGLISH
            MsgInf( "Wrong data type" )
#else
            MsgInf( "ç•¢•‡≠Î© ‚®Ø §†≠≠ÎÂ" )
#endif
            RETURN .F.
         ENDIF
         IF varbuf = "D" .OR. varbuf = "M"
            REPLACE FIELD_LEN WITH 8, FIELD_DEC WITH 0
         ELSEIF varbuf = "L"
            REPLACE FIELD_LEN WITH 1, FIELD_DEC WITH 0
         ENDIF
      CASE numf = 3
         DO CASE
         CASE FIELD_TYPE = "N" .AND. varbuf > 18
#ifdef ENGLISH
            MsgInf( "Wrong lenth" )
#else
            MsgInf( "ç•¢•‡≠†Ô §´®≠†" )
#endif
            RETURN .F.
         CASE FIELD_TYPE = "C" .AND. varbuf > 1024
#ifdef ENGLISH
            MsgInf( "Wrong lenth" )
#else
            MsgInf( "ç•¢•‡≠†Ô §´®≠†" )
#endif
            RETURN .F.
         ENDCASE
      CASE numf = 4
         IF varbuf > 15 .OR. varbuf > FIELD_LEN - 2
#ifdef ENGLISH
            MsgInf( "Wrong lenth" )
#else
            MsgInf( "ç•¢•‡≠†Ô §´®≠†" )
#endif
            RETURN .F.
         ENDIF
      ENDCASE
   ENDIF
   MsgInf( "" )
RETURN .T.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function SelFiel()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION SelFiel

LOCAL oldc, bufscr, arez, i
PRIVATE ar2len := FCOUNT(), aNames[ FCOUNT() ]
#ifdef ENGLISH
PRIVATE ctrl_ar1 := { "+W/RB,+W/B", ;
                         { { "",, 7, 37, 15, 55 }, ;
                         { "Ins - Select field",, 17, 12 }, { "F5 - Select all fields",, 17, 32 } } }
PRIVATE ctrl_ar2 := { "+W/RB,+W/B", ;
                         { { "",, 7, 13, 15, 21 }, ;
                         { "Ins - Insert",, 17, 12 }, { "Del - Delete",, 17, 32 }, { "F6 - ì°‡†‚Ï ¢·• ØÆ´Ô",, 17, 46 } } }
#else
PRIVATE ctrl_ar1 := { "+W/RB,+W/B", ;
                         { { "",, 7, 37, 15, 55 }, ;
                         { "Ins - ÇÎ°‡†‚Ï ØÆ´•",, 17, 12 }, { "F5 - Select all fields",, 17, 32 } } }
PRIVATE ctrl_ar2 := { "+W/RB,+W/B", ;
                         { { "",, 7, 13, 15, 21 }, ;
                         { "Ins - Ç·‚†¢®‚Ï",, 17, 12 }, { "Del - ì§†´®‚Ï",, 17, 32 }, { "F6 - ì°‡†‚Ï ¢·• ØÆ´Ô",, 17, 46 } } }
#endif
   bufscr := SAVESCREEN( 05, 10, 18, 68 )
   oldc   := SETCOLOR()
   SET COLOR TO +W/RB
   @ 05, 10, 18, 68 BOX ORAMKA
   AFIELDS( aNames )
   IF LI_MSF == Nil
      LI_MSF := ARRAY( ar2len )
      AFIELDS( LI_MSF )
      msexp[ improc ] = ARRAY( ar2len )
      AFIELDS( msexp[ improc ] )
   ENDIF
   SET COLOR TO +W/N,N/W,,,+W/N
   @  6, 12, 16, 22 BOX ORAMKA
   @  6, 36, 16, 56 BOX ORAMKA
#ifdef ENGLISH
   @  6, 13 SAY "All fields"              
   @  6, 38 SAY "Selected fields"         
#else
   @  6, 13 SAY "Ç·• ØÆ´Ô"               
   @  6, 38 SAY "ÇÎ°‡†≠≠Î• ØÆ´Ô"         
#endif
   arez := 1
   KEYBOARD CHR( 9 )
   DO WHILE .T.
      SET COLOR TO +W/RB
      @ 17, 12 CLEAR TO 17, 66
      Outctrls( ctrl_ar1 )
      SET COLOR TO +W/N,N/W,,,+W/N
      IF ( arez := MainMenu( 7, 13, 15, 21, aNames,, { | p1, p2 | userf1( p1, p2 ) },,,, .T. ) ) = 0
         EXIT
      ENDIF
      IF msexp[ improc , 1 ] <> Nil
         SET COLOR TO +W/RB
         @ 17, 12 CLEAR TO 17, 66
         Outctrls( ctrl_ar2 )
         SET COLOR TO +W/N,N/W,,,+W/N
         IF ( arez := MainMenu( 7, 37, 15, 55, msexp[ improc ],, { | p1, p2 | userf2( p1, p2 ) },,,, .T. ) ) = 0
            EXIT
         ENDIF
      ENDIF
   ENDDO
   IF msexp[ improc, 1 ] = Nil
      AFIELDS( msexp[ improc ] )
   ENDIF
   SETCOLOR( oldc )
   RESTSCREEN( 05, 10, 18, 68, bufscr )
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function Userf1()
*+
*+    Called from ( modistru.prg )   1 - function selfiel()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION Userf1( nind, key )

LOCAL rez := 2, i, oldc
#ifdef VER_MOUSE
   IF key = 501
      oldc := SETCOLOR( ctrl_ar1[ 1 ] )
      i    := F_CTRL( ctrl_ar1[ 2 ],,,,,, 1, M_YTEXT(), M_XTEXT() )
      SETCOLOR( oldc )
   ENDIF
#endif
   DO CASE
   CASE key = 9 .OR. ( key = 501 .AND. i = 1 )
      rez := 1
   CASE key = 22 .OR. ( key = 501 .AND. i = 2 )
      Addfiel( aNames[ nind ] )
      rez := 1
      ar2len ++
      KEYBOARD CHR( 9 )
   CASE key = - 4 .OR. ( key = 501 .AND. i = 3 )
      rez := 1
      AFIELDS( LI_MSF )
      AFIELDS( msexp[ improc ] )
      AFIELDS( LI_NAMES )
      ar2len := FCOUNT()
   ENDCASE
RETURN rez

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function Userf2()
*+
*+    Called from ( modistru.prg )   1 - function selfiel()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION Userf2( nind, key )

LOCAL rez := 2, i, oldc
#ifdef VER_MOUSE
   IF key = 501
      oldc := SETCOLOR( ctrl_ar1[ 1 ] )
      i    := F_CTRL( ctrl_ar2[ 2 ],,,,,, 1, M_YTEXT(), M_XTEXT() )
      SETCOLOR( oldc )
   ENDIF
#endif
   DO CASE
   CASE key = 9 .OR. ( key = 501 .AND. i = 1 )              // Tab
      rez := 1
   CASE key = 7 .OR. ( key = 501 .AND. i = 3 )              // Del
      Delfiel( nind )
      @  6, 36, 16, 56 BOX ORAMKA
      rez := 1
      ar2len --
      KEYBOARD CHR( 9 )
   CASE key = 22 .OR. ( key = 501 .AND. i = 2 )             // Ins
      IF Insfiel( nind )
         ar2len ++
      ENDIF
      rez := 1
      KEYBOARD CHR( 9 )
   CASE key = - 5 .OR. ( key = 501 .AND. i = 4 )
      AFIELDS( LI_MSF )
      AFIELDS( LI_NAMES )
      AFILL( msexp[ improc ], Nil )
      @  6, 36, 16, 56 BOX ORAMKA
      ar2len := 0
      rez    := 1
   ENDCASE
RETURN rez

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function Addfiel()
*+
*+    Called from ( modistru.prg )   1 - function userf1()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION Addfiel( finame )

   IF ASCAN( msexp[ improc ], finame ) = 0
      AADD( msexp[ improc ], finame )
      AADD( LI_NAMES, finame )

      IF LI_MSTYP != Nil
         AADD( LI_MSTYP, VALTYPE( &finame ) )
      ENDIF
      IF LI_MSLEN != Nil
         AADD( LI_MSLEN, Nil )
      ENDIF
      IF LI_MSDEC != Nil
         AADD( LI_MSDEC, Nil )
      ENDIF

      IF .NOT. ( VALTYPE( &finame ) $ "CM" )
         finame := "TRANSFORM(" + finame + ",'@(')"
      ENDIF
      IF VALTYPE( &finame ) = "M"
         AADD( LI_MSF, finame )
      ELSE
         AADD( LI_MSF, &( "{||" + finame + "}" ) )
      ENDIF
      ModiType( mslist, Len( LI_MSF ) )
   ENDIF
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function Insfiel()
*+
*+    Called from ( modistru.prg )   1 - function userf2()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION Insfiel( numfiel )

LOCAL expfiel := SPACE( 100 ), i, finame
LOCAL GetList := {}
LOCAL oldc, bufscr, txname := SPACE( 20 )
   bufscr := SAVESCREEN( 08, 12, 12, 66 )
   oldc   := SETCOLOR()
   SET COLOR TO +W/RB,B/W,,,+W/RB
   @ 08, 12, 12, 66 BOX ORAMKA
#ifdef ENGLISH
   @ 09, 14 SAY "Input expression for column"         
#else
   @ 09, 14 SAY "Ç¢•§®‚• ¢Î‡†¶•≠®• §´Ô ·‚Æ´°Ê†"         
#endif
   @ 10, 14 GET expfiel PICTURE "@S50"        
#ifdef ENGLISH
   @ 11, 14 SAY "Name:" GET txname        
#else
   @ 11, 14 SAY "à¨Ô:" GET txname        
#endif
   READ
   SETCOLOR( oldc )
   RESTSCREEN( 08, 12, 12, 66, bufscr )
   IF LASTKEY() <> 27 .AND. .NOT. EMPTY( expfiel )
      IF LI_MSF = Nil
         LI_MSF = ARRAY( FCOUNT() + 1 )
         AFIELDS( LI_MSF )
         msexp[ improc ] = ARRAY( FCOUNT() + 1 )
         AFIELDS( msexp[ improc ] )
      ELSE
         AADD( LI_MSF, Nil )
         AADD( LI_NAMES, Nil )
         AADD( msexp[ improc ], Nil )
      ENDIF
      AINS( LI_MSF, numfiel )
      AINS( LI_NAMES, numfiel )
      AINS( msexp[ improc ], numfiel )
      msexp[ improc, numfiel ] = expfiel
      LI_NAMES[ numfiel ] = txname
      IF .NOT. ( VALTYPE( &expfiel ) $ "CM" )
         expfiel := "TRANSFORM(" + expfiel + ",'@(')"
      ENDIF
      IF VALTYPE( &expfiel ) = "M"
         LI_MSF[ numfiel ] = expfiel
      ELSE
         LI_MSF[ numfiel ] = &( "{||" + expfiel + "}" )
      ENDIF
      IF LI_MSTYP != Nil
         AADD( LI_MSTYP, Nil )
         AINS( LI_MSTYP, numfiel )
      ENDIF
      IF LI_MSLEN != Nil
         AADD( LI_MSLEN, Nil )
      ENDIF
      IF LI_MSDEC != Nil
         AADD( LI_MSDEC, Nil )
      ENDIF
      ModiType( mslist, numfiel )
      FOR i := numfiel + 1 TO LEN( LI_MSF )
         IF VALTYPE( LI_MSF[ i ] ) = "N"
            finame := FIELD( i - 1 )
            IF VALTYPE( &finame ) = "M"
               LI_MSF[ i ] = finame
            ELSE
               LI_MSF[ i ] = &( "{||TRANSFORM(FIELDGET(" + NUM_STR( i - 1, 3 ) + "),'@(')}" )
            ENDIF
         ENDIF
      NEXT
   ELSE
      RETURN .F.
   ENDIF
RETURN .T.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function Delfiel()
*+
*+    Called from ( modistru.prg )   1 - function userf2()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION Delfiel( numfiel )

LOCAL finame
   IF LI_MSF = Nil
      LI_MSF = ARRAY( FCOUNT() )
      AFIELDS( LI_MSF )
      msexp[ improc ] = ARRAY( FCOUNT() )
      AFIELDS( msexp[ improc ] )
   ENDIF
   ADEL( LI_NAMES, numfiel )
   ASIZE( LI_NAMES, LEN( LI_NAMES ) - 1 )
   ADEL( LI_MSF, numfiel )
   ASIZE( LI_MSF, LEN( LI_MSF ) - 1 )
   ADEL( msexp[ improc ], numfiel )
   ASIZE( msexp[ improc ], LEN( msexp[ improc ] ) - 1 )
   IF LI_MSTYP != Nil
      ADEL( LI_MSTYP, numfiel )
      ASIZE( LI_MSTYP, LEN( LI_MSTYP ) - 1 )
   ENDIF
   IF LI_MSLEN != Nil
      ADEL( LI_MSLEN, numfiel )
      ASIZE( LI_MSLEN, LEN( LI_MSLEN ) - 1 )
   ENDIF
   IF LI_MSDEC != Nil
      ADEL( LI_MSDEC, numfiel )
      ASIZE( LI_MSDEC, LEN( LI_MSDEC ) - 1 )
   ENDIF
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function Chngfiel()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION Chngfiel( numfiel )

LOCAL GetList := {}
LOCAL oldc, bufscr, txname, expfiel, oldexp
LOCAL oldWidth, nWidth := Iif( LI_MSLEN != Nil .AND. numfiel <= Len( LI_MSLEN ) .AND. LI_MSLEN[numfiel] != Nil, LI_MSLEN[numfiel], FieldSize( numfiel ) )
   oldWidth := nWIdth
   txname  := PADR( LI_NAMES[ numfiel ], 20 )
   oldexp := expfiel := PADR( IIF( msexp[ improc ] = Nil, FIELD( numfiel ), msexp[ improc, numfiel ] ), 100 )
   bufscr  := SAVESCREEN( 08, 12, 12, 66 )
   oldc    := SETCOLOR()
   SET COLOR TO +W/RB,B/W,,,+W/RB
   @ 08, 12, 13, 66 BOX ORAMKA
#ifdef ENGLISH
   @ 09, 14 SAY "Name:" GET txname        
   @ 10, 14 SAY "Expression for column"                   
#else
   @ 09, 14 SAY "à¨Ô:"  GET txname        
   @ 10, 14 SAY "ÇÎ‡†¶•≠®• §´Ô ·‚Æ´°Ê†"                   
#endif
   @ 11, 14 GET expfiel PICTURE "@S50"
#ifdef ENGLISH
   @ 12, 14 SAY "Width:"  GET nWidth
#else
   @ 12, 14 SAY "Ñ´®≠†:"  GET nWidth
#endif
   READ
   SETCOLOR( oldc )
   RESTSCREEN( 08, 12, 11, 66, bufscr )
   IF LASTKEY() <> 27
      LI_NAMES[ numfiel ] = txname
      IF expfiel != oldexp
         IF LI_MSF == Nil
            LI_MSF := ARRAY( FCOUNT() )
            AFIELDS( LI_MSF )
         ENDIF
         IF msexp[ improc ] == Nil
            msexp[ improc ] := ARRAY( FCOUNT() )
            AFIELDS( msexp[ improc ] )
         ENDIF

         IF Empty( expfiel )
            msexp[ improc, numfiel ] := Nil
            LI_MSF[ numfiel ] := Nil
         ELSE
            msexp[ improc, numfiel ] := expfiel
            IF VALTYPE( &expfiel ) <> "C"
               expfiel := "TRANSFORM(" + expfiel + ",'@(')"
            ENDIF
            LI_MSF[ numfiel ] = &( "{||" + expfiel + "}" )
         ENDIF
      ENDIF
      IF nWidth != oldWidth
         IF LI_MSLEN == Nil
            LI_MSLEN := Array( Fcount() )
         ENDIF
         LI_MSLEN[ numfiel ] := nWidth
      ENDIF
   ENDIF
RETURN Nil

STATIC FUNCTION MODITYPE( mslist, i )
Local vartmp := EVAL( LI_MSF[ i ],mslist,i )
   IF LI_MSTYP != Nil .AND. LI_MSLEN != Nil .AND. LI_MSDEC != Nil
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
   ENDIF
RETURN Nil

*+ EOF: MODISTRU.PRG
