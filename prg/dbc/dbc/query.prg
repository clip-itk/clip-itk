/*
 * DBC - Database Control Utility
 * SQL queries implementation
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤
*+
*+    Source Module => D:\MYAPPS\SOURCE\MYDBU\QUERY.PRG
*+
*+    Functions: Function OpenQuery()
*+               Function EditQuery()
*+               Function WriteQuery()
*+               Function CreatQuery()
*+               Function DoQuery()
*+               Function AnaWhere()
*+               Function AnaHavi()
*+               Function ConvAgr()
*+               Function AnalyzExp()
*+               Function GetZnach()
*+               Function IsAgr()
*+               Function IsExp()
*+               Function FindFiel()
*+               Function IndExp()
*+               Function MainInd()
*+               Function SetInd()
*+               Function COUNT()
*+               Function SUM()
*+               Function AVG()
*+               Function MIN_F()
*+               Function MAX_F()
*+
*+       Tables: USE
*+
*+      Indexes: INDEX ON &ordexp TAG "N1" TO &qfname
*+               INDEX ON &ind_exp TO &indname
*+
*+    Reformatted by Click! 2.00 on Jul-3-2001 at  9:26 am
*+
*+≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤

#ifdef RDD_AX
#ifdef __HARBOUR__
#include "ads.ch"
#else
#include "axntxcdx.ch"
#endif
#endif
#include "fileio.ch"

Static msquery, textquery[ 7 ], fileque, que_upd := .F.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function OpenQuery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION OpenQuery( fname )

LOCAL han, poz2, poz3, i
#ifdef ENGLISH
LOCAL cMsg1 := "Query was changed! Save?"
#else
LOCAL cMsg1 := "á†Ø‡Æ· °Î´ ®ß¨•≠•≠! ëÆÂ‡†≠®‚Ï?"
#endif
PRIVATE stroka, poz1, quebuf := "", sword, flen
   IF que_upd
      IF MsgYesNo( cMsg1 )
         WriteQuery()
      ENDIF
      que_upd := .F.
   ENDIF
   han := FOPEN( fname, FO_READ + FO_SHARED )
   IF han <> - 1
      textquery[ 1 ] = SPACE( 250 )
      textquery[ 2 ] = SPACE( 60 )
      textquery[ 3 ] = SPACE( 200 )
      textquery[ 4 ] = SPACE( 50 )
      textquery[ 5 ] = SPACE( 70 )
      textquery[ 6 ] = SPACE( 40 )
      textquery[ 7 ] = SPACE( 40 )
      fileque := fname
      flen    := FSEEK( han, 0, FS_END )
      FSEEK( han, 0 )
      stroka := SPACE( flen )
      FREAD( han, @stroka, flen )
      FCLOSE( han )
      poz1 := 1
      DO WHILE .NOT. EMPTY( sword := NEXTWORD() )
         quebuf += sword + ' '
      ENDDO
      IF ( poz1 := AT( "SELECT ", quebuf ) ) = 0
         MsgSay( "? SELECT" )
         RETURN Nil
      ENDIF
      IF ( poz2 := AT( "FROM ", quebuf ) ) = 0
         MsgSay( "? FROM" )
         RETURN Nil
      ENDIF
      textquery[ 1 ] = PADR( SUBSTR( quebuf, poz1 + 7, poz2 - poz1 - 8 ), 250 )
      quebuf := SUBSTR( quebuf, poz2 + 5 )
      poz1   := AT( "WHERE ", quebuf )
      poz2   := AT( "GROUP BY ", quebuf )
      poz3   := AT( "ORDER BY ", quebuf )
      IF poz1 = 0 .AND. poz2 = 0 .AND. poz3 = 0
         textquery[ 2 ] = PADR( quebuf, 60 )
         RETURN Nil
      ENDIF
      textquery[ 2 ] = PADR( SUBSTR( quebuf, 1, IIF( poz1 <> 0, poz1, IIF( poz2 <> 0, poz2, poz3 ) ) - 1 ), 60 )
      IF poz1 <> 0
         IF poz2 = 0 .AND. poz3 = 0
            textquery[ 3 ] = PADR( SUBSTR( quebuf, poz1 + 6 ), 200 )
            RETURN Nil
         ENDIF
         textquery[ 3 ] = PADR( SUBSTR( quebuf, poz1 + 6, IIF( poz2 <> 0, poz2, poz3 ) - poz1 - 7 ), 200 )
      ENDIF
      poz1 := poz2
      poz2 := AT( "HAVING ", quebuf )
      IF poz1 <> 0
         IF poz2 = 0 .AND. poz3 = 0
            textquery[ 4 ] = PADR( SUBSTR( quebuf, poz1 + 9 ), 50 )
            RETURN Nil
         ENDIF
         textquery[ 4 ] = PADR( SUBSTR( quebuf, poz1 + 9, IIF( poz2 <> 0, poz2, poz3 ) - poz1 - 10 ), 50 )
      ENDIF
      IF poz2 <> 0
         IF poz3 = 0
            textquery[ 5 ] = PADR( SUBSTR( quebuf, poz2 + 7 ), 70 )
            RETURN Nil
         ENDIF
         textquery[ 5 ] = PADR( SUBSTR( quebuf, poz2 + 7, poz3 - poz2 - 8 ), 70 )
      ENDIF
      IF poz3 <> 0
         textquery[ 6 ] = PADR( SUBSTR( quebuf, poz3 + 9 ), 40 )
      ENDIF
   ELSE
#ifdef ENGLISH
      MsgSay( "Can't open " + fname )
#else
      MsgSay( "ç• „§†´Æ·Ï Æ‚™‡Î‚Ï " + fname )
#endif
      RETURN Nil
   ENDIF
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function EditQuery()
*+
*+    Called from ( query.prg    )   1 - function creatquery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION EditQuery

LOCAL bufc, oldc, i, lkey, prupdt
#ifdef ENGLISH
LOCAL cMsg1 := "Query was changed! Save?"
#else
LOCAL cMsg1 := "á†Ø‡Æ· °Î´ ®ß¨•≠•≠! ëÆÂ‡†≠®‚Ï?"
#endif
#ifdef ENGLISH
PRIVATE Ctrlist := { "+GR/B,+W/RB", { { "F5 - Run query", { || DoQuery() }, 19, 10 } } }
#else
PRIVATE Ctrlist := { "+GR/B,+W/RB", { { "F5 - ÇÎØÆ´≠®‚Ï ß†Ø‡Æ·", { || DoQuery() }, 19, 10 } } }
#endif
PRIVATE GetList := {}
   bufsc := SAVESCREEN( 4, 3, 20, 76 )
   oldc  := SETCOLOR()
   SET COLOR TO +GR/B
   @  4,  3, 20, 76 BOX ORAMKA
   OutCtrls( Ctrlist )
   @  5,  5 SAY "SELECT"           
   @  7,  5 SAY "FROM"             
   @  8,  5 SAY "WHERE"            
   @ 10,  5 SAY "GROUP BY"         
   @ 11,  5 SAY "HAVING"           
   @ 13,  5 SAY "ORDER BY"         
   @ 14,  5 SAY "TO"               
   SET COLOR TO +W/B,N/W,,,+W/B
   SET KEY - 4 TO DoQuery
   @  6,  5 GET textquery[ 1 ] PICTURE "@S70"        
   @  7, 14 GET textquery[ 2 ]                       
   @  9,  5 GET textquery[ 3 ] PICTURE "@S70"        
   @ 10, 14 GET textquery[ 4 ]                       
   @ 12,  5 GET textquery[ 5 ]                       
   @ 13, 14 GET textquery[ 6 ]                       
   @ 14, 14 GET textquery[ 7 ]                       
   READ
   SET KEY - 4 TO
   IF UPDATED()
      que_upd := .T.
      IF LASTKEY() <> 27
         IF MsgYesNo( cMsg1 )
            WriteQuery()
         ENDIF
      ENDIF
   ENDIF
   SETCOLOR( oldc )
   RESTSCREEN( 4, 3, 20, 76, bufsc )
   SET KEY - 4 TO
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function WriteQuery()
*+
*+    Called from ( query.prg    )   1 - function openquery()
*+                                   1 - function editquery()
*+                                   1 - function creatquery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION WriteQuery

LOCAL han, fname
   fname := FileMan( "*.que", .T. )
   IF .NOT. EMPTY( fname )
      han := FCREATE( fname, FC_NORMAL )
      FWRITE( han, "SELECT " + textquery[ 1 ] + CHR( 13 ) + CHR( 10 ) )
      FWRITE( han, "FROM " + textquery[ 2 ] + CHR( 13 ) + CHR( 10 ) )
      IF .NOT. EMPTY( textquery[ 3 ] )
         FWRITE( han, "WHERE " + textquery[ 3 ] + CHR( 13 ) + CHR( 10 ) )
      ENDIF
      IF .NOT. EMPTY( textquery[ 4 ] )
         FWRITE( han, "GROUP BY " + textquery[ 4 ] + CHR( 13 ) + CHR( 10 ) )
      ENDIF
      IF .NOT. EMPTY( textquery[ 5 ] )
         FWRITE( han, "HAVING " + textquery[ 5 ] + CHR( 13 ) + CHR( 10 ) )
      ENDIF
      IF .NOT. EMPTY( textquery[ 6 ] )
         FWRITE( han, "ORDER BY " + textquery[ 6 ] + CHR( 13 ) + CHR( 10 ) )
      ENDIF
      FCLOSE( han )
      que_upd := .F.
   ENDIF
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function CreatQuery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION CreatQuery

#ifdef ENGLISH
LOCAL cMsg1 := "Save previous query?"
#else
LOCAL cMsg1 := "ëÆÂ‡†≠®‚Ï Ø‡•§Î§„È®© ß†Ø‡Æ·?"
#endif
   IF que_upd
      IF MsgYesNo( cMsg1 )
         WriteQuery()
         que_upd := .F.
      ENDIF
   ENDIF
   textquery[ 1 ] = SPACE( 250 )
   textquery[ 2 ] = SPACE( 60 )
   textquery[ 3 ] = SPACE( 200 )
   textquery[ 4 ] = SPACE( 50 )
   textquery[ 5 ] = SPACE( 70 )
   textquery[ 6 ] = SPACE( 40 )
   textquery[ 7 ] = SPACE( 40 )
   fileque := SPACE( 8 )
   EditQuery()
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function DoQuery()
*+
*+    Called from ( query.prg    )   2 - function editquery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION DoQuery()

LOCAL sword, i, j, sw2, vartmp, ordexp := "", pragr := .F., screc
LOCAL groupexp, groupkey, groupbl, prbegin, msgr, nrec, ocher, msals, msqname := {}
LOCAL distbl, qfname
PRIVATE stroka, poz1, f_impr, f_usl := "", max_len, max_dec, msrelat := {}, msaccum
   msquery := ARRAY( 6 )
   // èÆ´Ô ®ß SELECT - ¢ ¨†··®¢ msquery[1]
   stroka       := textquery[ 1 ]
   poz1         := 1
   msquery[ 1 ] := {}
   DO WHILE VALTYPE( sword := EL_NEXT() ) == "C"
      AADD( msquery[ 1 ], UPPER( LTRIM( RTRIM( sword ) ) ) )
   ENDDO
   // î†©´Î ®ß FROM - ¢ ¨†··®¢ msquery[2]
   stroka       := textquery[ 2 ]
   poz1         := 1
   msquery[ 2 ] := {}
   DO WHILE VALTYPE( sword := EL_NEXT() ) == "C"
      sword := UPPER( LTRIM( RTRIM( sword ) ) )
      IF ( i := AT( ' ', sword ) ) <> 0
         sw2   := SUBSTR( sword, i + 1 )
         sword := LEFT( sword, i - 1 )
      ELSE
         sw2 := sword
      ENDIF
      AADD( msquery[ 2 ], { sword, sw2, Nil, Nil } )
   ENDDO
   // é‚™‡Î¢†•¨ ‰†©´Î °†ß §†≠≠ÎÂ
   FOR i := 1 TO LEN( msquery[ 2 ] )
      IF( poz1 := SELECT( msquery[ 2 , i , 2 ] ) ) = 0
      IF .NOT. FIOPEN( mypath + msquery[ 2 , i , 1 ], msquery[ 2 , i , 2 ] )
         RETURN Nil
      ENDIF
   ELSE
      SELECT( poz1 )
   ENDIF
   IF i = 1
      f_impr := SELECT()
   ENDIF
   msquery[ 2, i, 4 ] := SELECT()
   msquery[ 2, i, 3 ] := DBSTRUCT()
   NEXT
   // é°‡†°Æ‚™† WHERE
   IF .NOT. EMPTY( textquery[ 3 ] )
      IF EMPTY( sword := AnaWhere( textquery[ 3 ] ) )
         RETURN Nil
      ELSE
         msquery[ 3 ] := sword
      ENDIF
   ENDIF
   // é°‡†°Æ‚™† GROUP BY
   IF .NOT. EMPTY( textquery[ 4 ] )
      groupexp := MainInd( textquery[ 4 ] )
      groupbl  := &( "{||" + groupexp + "}" )
      msgr     := ARRAY( LEN( msquery[ 1 ] ) )
      AFILL( msgr, .F. )
      IF .NOT. EMPTY( textquery[ 5 ] )  // Having
         IF EMPTY( sword := AnaHavi( RTRIM( textquery[ 5 ] ) ) )
            RETURN Nil
         ELSE
            msquery[ 5 ] := &( "{||" + sword + "}" )
         ENDIF
      ELSE
         msquery[ 5 ] := { || .T. }
      ENDIF
   ENDIF
   IF ( i := IsAgr( msquery[ 1 , 1 ] ) ) <> 0 .AND. groupbl = Nil
      // Ö·´® ß†Ø‡†Ë®¢†•‚·Ô †£‡•£†‚≠†Ô ‰„≠™Ê®Ô
      sword := ALLTRIM( msquery[ 1, 1 ] )
      IF EMPTY( sword := ConvAgr( sword, i ) )
         RETURN Nil
      ENDIF
      msquery[ 1, 1 ] := &( "{|p3|" + sword + "}" )
      pragr           := .T.
   ELSE
      // ëÆß§†≠®• ¢ÎÂÆ§≠Æ£Æ ‰†©´†
      SELECT 20
      CREATE Q0STRU
      FOR i := 1 TO LEN( msquery[ 1 ] )
         APPEND BLANK
         sword := msquery[ 1, i ]
         IF SUBSTR( sword, 1, 8 ) = "DISTINCT"
            IF groupbl <> Nil
#ifdef ENGLISH
               MsgSay( "DISTINCT and GROUP BY in query!" )
#else
               MsgSay( "DISTINCT ® GROUP BY ¢ Æ§≠Æ¨ ß†Ø‡Æ·•!" )
#endif
               RETURN Nil
            ENDIF
            sword    := SUBSTR( sword, 10 )
            groupexp := MainInd( sword )
            distbl   := &( "{||" + groupexp + "}" )
            SELECT 20
         ENDIF
         IF IsExp( sword ) <> 0
            // Ö·´® ¢ ·Ø®·™• ¢Î‡†¶•≠®•
            max_len := max_dec := 0
            REPLACE Field_Name WITH "EXP_" + NUM_STR( i, 2 )
            sw2   := ""
            sword := AnalyzExp( ALLTRIM( sword ), @sw2 )
            IF ( j := IsAgr( sword ) ) <> 0
               msgr[ i ] = .T.
               IF EMPTY( sword := ConvAgr( sword, j ) )
                  RETURN Nil
               ENDIF
               REPLACE Field_Type WITH "N"
               IF j = 1
                  REPLACE Field_Len WITH 10, Field_Dec WITH 0
               ELSE
                  j   := AT( "(", sword )
                  sw2 := SUBSTR( sw2, j + 1, LEN( sw2 ) - j - 1 )
                  sw2 := RTRIM( TRANSFORM( &sw2, "@B" ) )
                  j   := MAX( LEN( sw2 ), max_len ) + 1
                  REPLACE Field_Len WITH IIF( j > 18, 18, j )
                  j := AT( '.', sw2 )
                  j := IIF( j = 0, 0, LEN( sw2 ) - j )
                  REPLACE Field_Dec WITH MAX( max_dec, j )
               ENDIF
            ELSE
               vartmp := &sw2
               sw2    := RTRIM( TRANSFORM( vartmp, "@B" ) )
               REPLACE Field_Type WITH VALTYPE( vartmp ), Field_Len WITH MAX( LEN( sw2 ), max_len )
               IF Field_Type = "C"
                  REPLACE Field_Dec WITH 0
               ELSE
                  j := AT( '.', sw2 )
                  j := IIF( j = 0, 0, LEN( sw2 ) - j )
                  REPLACE Field_Dec WITH MAX( max_dec, j )
               ENDIF
            ENDIF
            sw2             := sword
            msquery[ 1, i ] := IIF( groupbl <> Nil .AND. msgr[ i ], &( "{|p3|" + sw2 + "}" ), ;
                   &( "{||" + sw2 + "}" ) )
         ELSE
            // à≠†Á• (ØÆ´•)
            IF .NOT. FindFiel( @sword, @sw2, @poz1, @j )
               RETURN Nil
            ENDIF
            vartmp := sw2
            IF ASCAN( msqname, vartmp ) <> 0
               vartmp := LEFT( CHR( poz1 + 64 ) + "_" + vartmp, 10 )
               DO WHILE ASCAN( msqname, vartmp ) <> 0
                  vartmp := LEFT( "X" + vartmp, 10 )
               ENDDO
            ENDIF
            REPLACE Field_Name WITH vartmp, Field_Type WITH msquery[ 2 , poz1 , 3 , j , 2 ], ;
                Field_Len WITH msquery[ 2 , poz1 , 3 , j , 3 ], Field_Dec WITH msquery[ 2 , poz1 , 3 , j , 4 ]
            msquery[ 1, i ] := &( "{||" + IIF( EMPTY( sword ), "", sword + '->' ) + sw2 + "}" )
            AADD( msqname, vartmp )
         ENDIF
      NEXT
      USE
      qfname := CutExten( IIF( EMPTY( textquery[ 7 ] ), "QUERY", TRIM( textquery[ 7 ] ) ) )
      IF ( i := ASCAN( msfile, qfname, 1, lenmsf ) ) <> 0
         improc := i
         FiClose()
         SELECT 20
      ENDIF
      CREATE &qfname FROM Q0STRU
      FERASE( "Q0STRU.DBF" )
      // é°‡†°Æ‚™† ORDER BY
      IF .NOT. EMPTY( textquery[ 6 ] )
         AADD( msquery[ 2 ], { qfname, qfname, DBSTRUCT() } )
         stroka := textquery[ 6 ]
         poz1   := 1
         DO WHILE VALTYPE( sword := EL_NEXT() ) == "C"
            ordexp += IIF( EMPTY( ordexp ), "", "+" ) + INDEXP( IIF( ISDIGIT( sword ), FIELDNAME( VAL( sword ) ), UPPER( TRIM( sword ) ) ), .F. )
         ENDDO
      ENDIF
      IF .NOT. EMPTY( ordexp )
#ifdef ENGLISH
         MsgInf( "Indexing " + ALIAS() )
#else
         MsgInf( "à≠§•™·®‡„Ó " + ALIAS() )
#endif
         INDEX ON &ordexp TAG "N1" TO &qfname
      ENDIF
   ENDIF
   // ÇÎØÆ´≠•≠®• ß†Ø‡Æ·†
   SELECT( f_impr )
   IF groupbl <> Nil
      msaccum := ARRAY( LEN( msquery[ 1 ] ) )
   ELSEIF pragr
      msaccum := 0
   ENDIF
#ifdef ENGLISH
   MsgInf( "Wait ..." )
#else
   MsgInf( "Ü§®‚• ..." )
#endif
   IF .NOT. EMPTY( f_usl )
#ifndef __HARBOUR__
#ifdef RDD_AX
#ifdef ENGLISH
      MsgInf( "Wait ..." + IIF( Ax_ExprValid( f_usl ), " Ok", " Hm.." ) )
#else
      MsgInf( "Ü§®‚• ..." + IIF( Ax_ExprValid( f_usl ), " Ok", " Hm.." ) )
#endif
#endif
#endif
      SET FILTER TO &f_usl
   ENDIF
   msquery[ 3 ] := &( "{||" + IIF( msquery[ 3 ] = Nil, ".T.", msquery[ 3 ] ) + "}" )
   GO TOP
   groupkey := "~~~"
   prbegin  := .T.
   max_len  := LEN( msrelat )
   IF que_simpl .OR. LEN( msquery[ 2 ] ) = 1
      FOR i := 1 TO max_len
         msrelat[ i , 5 ] = &( "{||" + msrelat[ i , 5 ] + "}" )
      NEXT
      screc := 0
      DO WHILE .NOT. EOF()
         IF EVAL( msquery[ 3 ] )
            FOR i := 1 TO max_len
               IF .NOT. EVAL( msrelat[ i , 5 ] )
                  EXIT
               ENDIF
            NEXT
            IF i <= max_len
               SKIP
               LOOP
            ENDIF
            IF groupbl <> Nil           // Ö·´® „™†ß†≠ GROUP BY
               IF groupkey <> EVAL( groupbl )               // Ö·´® ≠†Á®≠†•‚·Ô ≠Æ¢†Ô £‡„ØØ†
                  IF groupkey <> "~~~" .AND. EVAL( msquery[ 5 ] )
                     SELECT 20
                     APPEND BLANK
                     FOR i := 1 TO LEN( msaccum )
                        FIELDPUT( i, msaccum[ i ] )
                     NEXT
                     SELECT( f_impr )
                  ENDIF
                  groupkey := EVAL( groupbl )
                  FOR i := 1 TO LEN( msgr )
                     IF msgr[ i ]
                        msaccum[ i ] := EVAL( msquery[ 1, i ], 0 )
                     ELSE
                        msaccum[ i ] := EVAL( msquery[ 1, i ] )
                     ENDIF
                  NEXT
               ELSE                     // Ö·´® Ø‡Æ§Æ´¶†•‚·Ô ‚•™„È†Ô £‡„ØØ†
                  FOR i := 1 TO LEN( msgr )
                     IF msgr[ i ]
                        msaccum[ i ] := EVAL( msquery[ 1, i ], msaccum[ i ] )
                     ENDIF
                  NEXT
               ENDIF
            ELSE    //
               IF distbl <> Nil         // Ö·´® „™†ß†≠ DISTINCT
                  IF groupkey <> EVAL( distbl )
                     groupkey := EVAL( distbl )
                     prbegin  := .T.
                  ELSE
                     prbegin := .F.
                  ENDIF
               ENDIF
               IF prbegin
                  IF pragr
                     msaccum := EVAL( msquery[ 1, 1 ], msaccum )
                  ELSE
                     SELECT 20
                     APPEND BLANK
                     SELECT( f_impr )
                     FOR i := 1 TO LEN( msquery[ 1 ] )
                        sword := EVAL( msquery[ 1, i ] )
                        (qfname)->( FIELDPUT( i, sword ) )
                     NEXT
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         SKIP
         screc ++
         IF screc % 10 = 0
            @  2, 10 SAY LTRIM( STR( screc, 8 ) ) COLOR "N/W"        
         ENDIF
      ENDDO
   ELSE
      //
      max_len := LEN( msrelat )
      FOR i := 1 TO max_len
         msrelat[ i , 5 ] = &( "{||" + msrelat[ i , 5 ] + "}" )
      NEXT
      msals := ARRAY( max_len )
      AFILL( msals, 0 )
      DO WHILE .NOT. EOF()
         ocher := max_len
         DO WHILE .T.
            IF ocher = max_len
               sw2 := msquery[ 2, msrelat[ ocher, 2 ], 2 ]
               IF msals[ ocher ] = 0
                  nrec := &sw2->( RECNO() )
               ENDIF
               DO WHILE EVAL( msrelat[ ocher , 5 ] )
                  IF EVAL( msquery[ 3 ] )                   // Ö·´® ¢ÎØÆ≠Ô•‚·Ô „·´Æ¢®• WHERE
                     IF groupbl <> Nil  // Ö·´® „™†ß†≠ GROUP BY
                        IF groupkey <> EVAL( groupbl )      // Ö·´® ≠†Á®≠†•‚·Ô ≠Æ¢†Ô £‡„ØØ†
                           IF groupkey <> "~~~" .AND. EVAL( msquery[ 5 ] )
                              SELECT 20
                              APPEND BLANK
                              FOR i := 1 TO LEN( msaccum )
                                 FIELDPUT( i, msaccum[ i ] )
                              NEXT
                              SELECT( f_impr )
                           ENDIF
                           groupkey := EVAL( groupbl )
                           FOR i := 1 TO LEN( msgr )
                              IF msgr[ i ]
                                 msaccum[ i ] := EVAL( msquery[ 1, i ], 0 )
                              ELSE
                                 msaccum[ i ] := EVAL( msquery[ 1, i ] )
                              ENDIF
                           NEXT
                        ELSE            // Ö·´® Ø‡Æ§Æ´¶†•‚·Ô ‚•™„È†Ô £‡„ØØ†
                           FOR i := 1 TO LEN( msgr )
                              IF msgr[ i ]
                                 msaccum[ i ] := EVAL( msquery[ 1, i ], msaccum[ i ] )
                              ENDIF
                           NEXT
                        ENDIF
                     ELSE               //
                        IF distbl <> Nil                    // Ö·´® „™†ß†≠ DISTINCT
                           IF groupkey <> EVAL( distbl )
                              groupkey := EVAL( distbl )
                              prbegin  := .T.
                           ELSE
                              prbegin := .F.
                           ENDIF
                        ENDIF
                        IF prbegin
                           IF pragr
                              msaccum := EVAL( msquery[ 1, 1 ], msaccum )
                           ELSE
                              SELECT 20
                              APPEND BLANK
                              SELECT( f_impr )
                              FOR i := 1 TO LEN( msquery[ 1 ] )
                                 sword := EVAL( msquery[ 1, i ] )
                                 (qfname)->( FIELDPUT( i, sword ) )
                              NEXT
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
                  &sw2->( DBSKIP( 1 ) )
               ENDDO
               &sw2->( DBGOTO( msals[ ocher ] ) )
               ocher --
            ELSEIF ocher < 1
               EXIT
            ELSE
               sw2 := msquery[ 2, msrelat[ ocher, 2 ], 2 ]
               IF msals[ ocher ] = 0
                  nrec := &sw2->( RECNO() )
               ENDIF
               &sw2->( DBSKIP( 1 ) )
               IF EVAL( msrelat[ ocher , 5 ] )
                  ocher := 1
               ELSE
                  &sw2->( DBGOTO( msals[ ocher ] ) )
                  ocher --
               ENDIF
            ENDIF
         ENDDO
         SELECT( f_impr )
         SKIP
      ENDDO
   ENDIF
   IF groupbl <> Nil                    // Ö·´® „™†ß†≠ GROUP BY
      IF groupkey <> "~~~" .AND. EVAL( msquery[ 5 ] )
         SELECT 20
         APPEND BLANK
         FOR i := 1 TO LEN( msaccum )
FIELDPUT( i, msaccum[ i ] )
         NEXT
         SELECT( f_impr )
      ENDIF
   ENDIF
#ifdef ENGLISH
   MsgInf( "Done!" )
#else
   MsgInf( "ÉÆ‚Æ¢Æ!" )
#endif
   IF pragr
#ifdef ENGLISH
      MsgSay( "Rezult: " + TRANSFORM( msaccum, "@(" ), "R/W" )
#else
      MsgSay( "ê•ß„´Ï‚†‚: " + TRANSFORM( msaccum, "@(" ), "R/W" )
#endif
   ELSE
      SELECT 20
      IF .NOT. EMPTY( ordexp )
         ORDSETFOCUS( "N1" )
         COPY ALL TO QUERYTMP
         USE
         FERASE( qfname + ".DBF" )
         FRENAME( "QUERYTMP.DBF", qfname + ".DBF" )
      ELSE
         USE
      ENDIF
      FERASE( qfname + ".CDX" )
      FIOPEN( qfname )
      prkorf  := .T.
      prkorst := .T.
      KEYBOARD CHR( 27 ) + CHR( 27 )
   ENDIF
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function AnaWhere()
*+
*+    Called from ( query.prg    )   1 - function doquery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION AnaWhere( strexp )

LOCAL i, j := 0, j1, strrez := "", sword, sdop, sw1, sw2 := "", ileft, swleft2, leftexi := .F.
LOCAL lastand  := "", lastlen := 0, alsinusl := 0, pror := .F.
PRIVATE stroka, poz1 := 1
   stroka := strexp
   strexp := ""
   DO WHILE .NOT. EMPTY( sword := NEXTWORD() )
      IF ( i := ASCAN( { "AND", "OR", "NOT", "IN", "BETWEEN" }, sword ) ) = 0
         strexp += sword
      ELSE
         IF i > 1
            pror := .T.
         ENDIF
         strexp += "|" + sword + "|"
      ENDIF
   ENDDO
   DO WHILE .NOT. EMPTY( strexp )
      IF ( i := IsExp( strexp, "=><()-+*|" ) ) = 0
         sword  := strexp
         strexp := ""
         sdop   := ""
      ELSE
         sword := LEFT( strexp, i - 1 )
         sdop  := SUBSTR( strexp, i, 1 )
         IF ( sdop $ "=<>" .AND. SUBSTR( strexp, i + 1, 1 ) $ "=<>" ) .OR. ( sdop = "(" .AND. SUBSTR( strexp, i + 1, 1 ) = ")" )
            i ++
            sdop += SUBSTR( strexp, i, 1 )
         ENDIF
         strexp := SUBSTR( strexp, i + 1 )
      ENDIF
      IF .NOT. EMPTY( sword )
         IF ASCAN( { "AND", "OR", "NOT" }, sword ) <> 0
            lastand := sword
            sword   := "." + sword + "."
            IF .NOT. pror .AND. alsinusl < 2
               sword  := ""
               f_usl  += IIF( EMPTY( f_usl ), "", ".AND." ) + SUBSTR( strrez, lastlen + 1 )
               strrez := SUBSTR( strrez, 1, lastlen )
            ENDIF
            alsinusl := 0
            lastlen  := LEN( strrez ) + LEN( sword )
         ENDIF
         IF ASC( sword ) > 63
            IF sword = "IN"
            ELSEIF sword = "BETWEEN"
            ELSE
               sw1 := sword
               IF LEFT( sdop, 1 ) <> "("
                  IF .NOT. FindFiel( @sw1, @sw2, @i, @j )
                     RETURN ""
                  ENDIF
                  sword    := IIF( EMPTY( sw1 ), "", sw1 + "->" ) + sw2
                  alsinusl := MAX( alsinusl, i )
                  IF LEN( msquery[ 2 ] ) > 1
                     IF LEFT( sdop, 1 ) == "=" .AND. ( EMPTY( lastand ) .OR. lastand = "AND" )
                        // ç†©§•≠† ´•¢†Ô Á†·‚Ï „·´Æ¢®Ô
                        ileft   := i
                        swleft2 := sw2
                        leftexi := .T.
                        lastlen := LEN( strrez )
                     ELSEIF leftexi .AND. ( EMPTY( sdop ) .OR. sdop = "|" ) .AND. i <> ileft
                        // è‡†¢†Ô Á†·‚Ï
                        IF ileft < i
                           j1      := ileft
                           ileft   := i
                           i       := j1
                           sw1     := swleft2
                           swleft2 := sw2
                           sw2     := sw1
                        ENDIF
                        FOR j1 := 1 TO LEN( msrelat )
                           IF msrelat[ j1 , 1 ] = i .AND. msrelat[ j1 , 2 ] = ileft
                              msrelat[ j1 , 3 ] += "+" + INDEXP( msquery[ 2 , ileft , 2 ] + "." + swleft2, .F. )
                              msrelat[ j1 , 4 ] += "+" + INDEXP( msquery[ 2 , i , 2 ] + "." + sw2, .F. )
                              sw2 := ".AND." + SUBSTR( strrez, lastlen + 1 ) + sword
                              msrelat[ j1 , 5 ] += sw2
                              EXIT
                           ENDIF
                        NEXT
                        IF j1 > LEN( msrelat )
                           AADD( msrelat, { i, ileft, INDEXP( msquery[ 2 , i , 2 ] + "." + sw2, .F. ), ;
                                            INDEXP( msquery[ 2 , ileft , 2 ] + "." + swleft2, .F. ), ;
                                            SUBSTR( strrez, lastlen + 1 ) + sword } )
                        ENDIF
                        IF EMPTY( lastand )
                           sword  := ".T."
                           strrez := ""
                        ELSE
                           sword  := ""
                           strrez := SUBSTR( strrez, 1, lastlen - 5 )
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ELSE
            IF LEN( sword ) = 8 .AND. SUBSTR( sword, 3, 1 ) = "/" .AND. SUBSTR( sword, 6, 1 ) = "/"
               sword := "CTOD('" + sword + "')"
            ENDIF
         ENDIF
         IF leftexi .AND. LEFT( sdop, 1 ) <> "="
            leftexi := .F.
         ENDIF
         IF EMPTY( strexp ) .AND. .NOT. pror .AND. alsinusl < 2
            f_usl  += IIF( EMPTY( f_usl ), "", ".AND." ) + SUBSTR( strrez, lastlen + 1 ) + sword
            strrez := SUBSTR( strrez, 1, IIF( lastand = "AND", lastlen - 5, lastlen ) )
            sword  := ""
         ENDIF
      ENDIF
      strrez += sword + IIF( sdop <> "|", sdop, "" )
   ENDDO
   FOR i := 1 TO LEN( msrelat )
      j := msrelat[ i, 2 ]
      SELECT( msquery[ 2 , j , 4 ] )
      SetInd( msrelat[ i , 4 ], "WHE_" + NUM_STR( j, 2 ) )
      SELECT( msquery[ 2 , msrelat[ i , 1 ] , 4 ] )
      sw1 := msrelat[ i, 3 ]
      sw2 := msquery[ 2, j, 2 ]
      SET RELATION TO &sw1 INTO &sw2 ADDITIVE
   NEXT
RETURN IIF( EMPTY( strrez ), ".T.", strrez )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function AnaHavi()
*+
*+    Called from ( query.prg    )   1 - function doquery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION AnaHavi( strexp )

LOCAL i, strrez := "", sword, sdop
   DO WHILE .NOT. EMPTY( strexp )
      IF ( i := IsExp( strexp, "=>< " ) ) = 0
         sword  := strexp
         strexp := ""
         sdop   := ""
      ELSE
         sword := LEFT( strexp, i - 1 )
         sdop  := SUBSTR( strexp, i, 1 )
         IF sdop $ "=<>" .AND. SUBSTR( strexp, i + 1, 1 ) $ "=<>"
            i ++
            sdop += SUBSTR( strexp, i, 1 )
         ENDIF
         strexp := SUBSTR( strexp, i + 1 )
      ENDIF
      IF .NOT. EMPTY( sword )
         IF ASCAN( { "AND", "OR", "NOT" }, sword ) <> 0
            sword := "." + sword + "."
         ENDIF
         IF ASC( sword ) > 63
            IF ( i := ASCAN( msquery[ 1 ], UPPER( sword ) ) ) = 0
#ifdef ENGLISH
               MsgSay( sword + " - unknown word in Having!" )
#else
               MsgSay( sword + " - ≠•®ß¢•·‚≠Æ• ·´Æ¢Æ ¢ Having!" )
#endif
               RETURN ""
            ELSE
               sword := "msaccum[" + NUM_STR( i, 2 ) + "]"
            ENDIF
         ELSE
            IF LEN( sword ) = 8 .AND. SUBSTR( sword, 3, 1 ) = "/" .AND. SUBSTR( sword, 6, 1 ) = "/"
               sword := "CTOD('" + sword + "')"
            ENDIF
         ENDIF
      ENDIF
      strrez += sword + sdop
   ENDDO
RETURN strrez

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function ConvAgr()
*+
*+    Called from ( query.prg    )   2 - function doquery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION ConvAgr( sword, i )

LOCAL j
   j := AT( "(", sword )
   IF ( poz1 := j + FIND_Z( SUBSTR( sword, j + 1 ), ')' ) ) = j
      MsgSay( "é‚·„‚·‚¢„•‚ ')'" )
      RETURN ""
   ENDIF
   IF SUBSTR( sword, j + 1, 1 ) = "*"
      IF i = 1
         sword := "COUNT(,'*',p3)"
      ELSE
#ifdef ENGLISH
         MsgSay( "* in agregate function!" )
#else
         MsgSay( "* ¢ †£‡•£†‚≠Æ© ‰„≠™Ê®®!" )
#endif
         RETURN ""
      ENDIF
   ELSEIF SUBSTR( sword, j + 1, 8 ) = "DISTINCT"
      sword := SUBSTR( sword, 1, j ) + SUBSTR( sword, j + 9, poz1 - j - 9 ) + ",'D',p3)"
   ELSE
      sword := SUBSTR( sword, 1, poz1 - 1 ) + ",,p3)"
   ENDIF
   IF i = 4 .OR. i = 5
      sword := SUBSTR( sword, 1, j - 1 ) + "_F" + SUBSTR( sword, j )
   ENDIF
RETURN sword

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function AnalyzExp()
*+
*+    Called from ( query.prg    )   1 - function doquery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION AnalyzExp( strexp, str2 )

LOCAL i, j, poz, sword, sw2, strrez := "", strvar := ""
PRIVATE stroka, poz1 := 1
   stroka := strexp
   strexp := ""
   DO WHILE .NOT. EMPTY( sword := NEXTWORD() )
      IF ( i := ASCAN( { "AND", "OR", "NOT", "IN", "BETWEEN" }, sword ) ) = 0
         strexp += sword
      ELSE
         strexp += "|" + sword + "|"
      ENDIF
   ENDDO
   DO WHILE .T.
      IF ( poz := IsExp( strexp, "-+*/()<>=,|" ) ) = 0
         FindFiel( @strexp, @sw2, @i, @j )
         strrez += IIF( EMPTY( strexp ), "", strexp + "->" ) + sw2
         strvar += GetZnach( i, j )
         EXIT
      ELSE
         IF SUBSTR( strexp, poz, 1 ) = "(" .OR. .NOT. ISALPHA( strexp ) .OR. ;
                    ASCAN( { "AND", "OR", "NOT", "IN", "BETWEEN" }, LEFT( strexp, poz - 1 ) ) <> 0
            IF SUBSTR( strexp, poz, 1 ) = "|"
               strrez += SUBSTR( strexp, 1, poz - 1 ) + "."
               strvar += SUBSTR( strexp, 1, poz - 1 ) + "."
            ELSE
               strrez += SUBSTR( strexp, 1, poz )
               strvar += SUBSTR( strexp, 1, poz )
            ENDIF
         ELSE
            sword := SUBSTR( strexp, 1, poz - 1 )
            FindFiel( @sword, @sw2, @i, @j )
            strrez += IIF( EMPTY( sword ), "", sword + "->" ) + sw2 + SUBSTR( strexp, poz, 1 )
            strvar += GetZnach( i, j ) + SUBSTR( strexp, poz, 1 )
         ENDIF
         strexp := SUBSTR( strexp, poz + 1 )
         IF EMPTY( strexp )
            EXIT
         ENDIF
      ENDIF
   ENDDO
   IF str2 <> Nil
      str2 := strvar
   ENDIF
RETURN strrez

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function GetZnach()
*+
*+    Called from ( query.prg    )   2 - function analyzexp()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION GetZnach( i, j )

LOCAL strrez
   IF msquery[ 2 , i , 3 , j , 2 ] = "C"
      strrez := '"' + REPLICATE( 'X', msquery[ 2, i, 3, j, 3 ] ) + '"'
   ELSEIF msquery[ 2 , i , 3 , j , 2 ] = "D"
      strrez := 'DATE()'
   ELSE
      max_len := MAX( max_len, msquery[ 2, i, 3, j, 3 ] )
      max_dec := MAX( max_dec, msquery[ 2, i, 3, j, 4 ] )
      strrez  := IIF( msquery[ 2, i, 3, j, 4 ] = 0, ;
                     REPLICATE( "9", msquery[ 2 , i , 3 , j , 3 ] ), ;
                     REPLICATE( "9", msquery[ 2 , i , 3 , j , 3 ] - msquery[ 2 , i , 3 , j , 4 ] - 1 ) + "." + REPLICATE( "9", msquery[ 2 , i , 3 , j , 4 ] ) )
   ENDIF
RETURN strrez

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function IsAgr()
*+
*+    Called from ( query.prg    )   2 - function doquery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION IsAgr( strexp )

LOCAL i
   i := IsExp( strexp )
   IF SUBSTR( strexp, i, 1 ) = "("
      IF ( i := ASCAN( { "COUNT", "SUM", "AVG", "MIN", "MAX" }, SUBSTR( strexp, 1, i - 1 ) ) ) <> 0
         RETURN i
      ENDIF
   ENDIF
RETURN 0

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function IsExp()
*+
*+    Called from ( query.prg    )   1 - function doquery()
*+                                   1 - function anawhere()
*+                                   1 - function anahavi()
*+                                   1 - function analyzexp()
*+                                   1 - function isagr()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION IsExp( sword, shablon )

LOCAL i
   FOR i := 1 TO LEN( sword )
      IF SUBSTR( sword, i, 1 ) $ IIF( shablon = Nil, "-+*/()<>=", shablon )
         RETURN i
      ENDIF
   NEXT
RETURN 0

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function FindFiel()
*+
*+    Called from ( query.prg    )   1 - function doquery()
*+                                   1 - function anawhere()
*+                                   2 - function analyzexp()
*+                                   1 - function indexp()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION FindFiel( sword, sw2, i, j )

   i   := AT( ".", sword )
   sw2 := IIF( i = 0, sword, SUBSTR( sword, i + 1 ) )
   IF i <> 0
      sword := SUBSTR( sword, 1, i - 1 )
      i     := ASCAN( msquery[ 2 ], { | aVal | aVal[ 1 ] == sword } )
      IF i = 0
#ifdef ENGLISH
         MsgSay( sword + " - Unknown alias" )
#else
         MsgSay( sword + " - ç•®ß¢•·‚≠Î© †´®†·" )
#endif
         RETURN .F.
      ENDIF
   ELSE
      sword := ""
      i     := 1
   ENDIF
   j := ASCAN( msquery[ 2, i, 3 ], { | aVal | aVal[ 1 ] == sw2 } )
   IF j = 0
#ifdef ENGLISH
      MsgSay( sw2 + " - Unknown field" )
#else
      MsgSay( sw2 + " - ç•®ß¢•·‚≠Æ• ØÆ´•" )
#endif
      RETURN .F.
   ENDIF
RETURN .T.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function IndExp()
*+
*+    Called from ( query.prg    )   1 - function doquery()
*+                                   4 - function anawhere()
*+                                   1 - function mainind()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION IndExp( finame, prals, inum )

LOCAL strind := "", sw2, i, j, vtype, vlen, vdec
   prals := IIF( prals = Nil, .T., prals )
   IF .NOT. FindFiel( @finame, @sw2, @i, @j )
      RETURN strind
   ENDIF
   IF .NOT. prals .OR. ( inum <> Nil .AND. inum = i )
      finame := ""
   ENDIF
   IF .NOT. EMPTY( finame )
      finame += "->"
   ENDIF
   vtype := msquery[ 2, i, 3, j, 2 ]
   DO CASE
   CASE vtype = "C"
      strind := finame + sw2
   CASE vtype = "N"
      vlen   := msquery[ 2, i, 3, j, 3 ]
      vdec   := msquery[ 2, i, 3, j, 4 ]
      strind := "STR(" + finame + sw2 + ',' + LTRIM( STR( vlen, 2 ) ) + IIF( vdec = 0, "", "," + STR( vdec, 1 ) ) + ")"
   CASE vtype = "D"
      strind := "DTOS(" + finame + sw2 + ")"
   ENDCASE
RETURN strind

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MainInd()
*+
*+    Called from ( query.prg    )   2 - function doquery()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION MainInd

LOCAL sword, ind_exp := ""
STATIC oblg := 0
   PARAMETERS stroka
PRIVATE poz1 := 1
   DO WHILE VALTYPE( sword := EL_NEXT() ) == "C"
      ind_exp += IIF( EMPTY( ind_exp ), "", "+" ) + INDEXP( UPPER( LTRIM( RTRIM( sword ) ) ),, 1 )
   ENDDO
   IF oblg <> 0
      SELECT( oblg )
      CLOSE INDEXES
      oblg := 0
   ENDIF
   SELECT( f_impr )
   SetInd( ind_exp, "GROUPIND" )
   oblg := SELECT()
RETURN ind_exp

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function SetInd()
*+
*+    Called from ( query.prg    )   1 - function anawhere()
*+                                   1 - function mainind()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION SetInd( ind_exp, indname )

LOCAL i := 1, j := LEN( ind_exp ), rezg, sword
   DO WHILE .T.
      IF EMPTY( sword := UPPER( ALLTRIM( ORDKEY( i ) ) ) )
         rezg := .F.
         EXIT
      ENDIF
      IF ind_exp = SUBSTR( sword, 1, j )
         SET ORDER TO i
         rezg := .T.
         EXIT
      ENDIF
      i ++
   ENDDO
   IF .NOT. rezg
#ifdef ENGLISH
      MsgInf( "Indexing " + ALIAS() )
#else
      MsgInf( "à≠§•™·®‡„Ó " + ALIAS() )
#endif
      INDEX ON &ind_exp TO &indname
      SET INDEX TO &indname
   ENDIF
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function COUNT()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION COUNT( p1, p2, p3 )

RETURN p3 + 1

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function SUM()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION SUM( p1, p2, p3 )

RETURN p1 + p3

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function AVG()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION AVG( p1, p2 )

LOCAL rez
RETURN rez

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MIN_F()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION MIN_F( p1, p2, p3 )

RETURN IIF( p3 == 0, p1, MIN( p1, p3 ) )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MAX_F()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION MAX_F( p1, p2, p3 )

RETURN MAX( p1, p3 )

*+ EOF: QUERY.PRG
