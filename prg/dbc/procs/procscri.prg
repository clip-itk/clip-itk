/*
 * Common procedures
 * Scripts
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => D:\MYAPPS\SOURCE\PROCS\PROCSCRI.PRG
*+
*+    Functions: Function RdScript()
*+               Static Function Fou_If()
*+               Static Function Fou_Do()
*+               Function DoScript()
*+
*+    Reformatted by Click! 2.00 on Apr-12-2001 at  9:01 pm
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

#include "fileio.ch"
STATIC aModules := {}
STATIC nLastError, numlin

FUNCTION RunScript( fname )
Local i, aScript

   IF ( i := Ascan( aModules, {|a|a[1]==fname} ) ) == 0
      aScript := RdScript( fname )
      IF aScript == Nil .OR. Empty( aScript )
         RETURN 1
      ELSE
         Aadd( aModules, { fname, aScript } )
         i := Len( aModules )
      ENDIF
   ENDIF
   DoScript( aModules[ i,2 ] )

RETURN 0

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function RdScript()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION RdScript( scrSource, strbuf, poz )

LOCAL scom
LOCAL han, stroka, poz1, bOldError
PRIVATE rezArray := {}, tmpArray := {}

   numlin := 1
   nLastError := 0
   IF scrSource == Nil
      han := Nil
      poz := 0
   ELSEIF VALTYPE( scrSource ) == "C"
      strbuf := SPACE( 512 )
      poz    := 513
      han    := FOPEN( scrSource, FO_READ + FO_SHARED )
   ELSE
      han := scrSource
   ENDIF
   IF han == Nil .OR. han <> - 1
      IF VALTYPE( scrSource ) == "C"
         WndOut( "Compiling ..." )
         WndOut( "" )
      ENDIF
      DO WHILE .T.
         stroka := RDSTR( han, @strbuf, @poz, 512 )
         IF LEN( stroka ) = 0
            EXIT
         ENDIF
         IF VALTYPE( scrSource ) == "C"
            WndOut( STR( numlin, 4 ), .T. )
         ENDIF
         numlin ++
         stroka := RTRIM( LTRIM( stroka ) )
         IF RIGHT( stroka, 1 ) = CHR( 26 )
            stroka := LEFT( stroka, LEN( stroka ) - 1 )
         ENDIF
         IF .NOT. EMPTY( stroka ) .AND. LEFT( stroka, 2 ) <> "//"

#ifdef __HARBOUR__
            IF Left( stroka,1 ) == "#" 
               IF UPPER( Left( stroka,7 ) ) != "#ENDSCR"
                  __ppAddRule( stroka )
                  LOOP
               ENDIF
            ELSE
               stroka := __Preprocess( stroka )
            ENDIF
#endif

            poz1 := AT( " ", stroka )
            scom := UPPER( SUBSTR( stroka, 1, IIF( poz1 <> 0, poz1 - 1, 999 ) ) )
            DO CASE
            CASE scom = "PRIVATE"
               IF LEN( rezArray ) == 0 .OR. VALTYPE( ATAIL( rezArray ) ) == "C"
                  AADD( rezArray, ALLTRIM( SUBSTR( stroka, 9 ) ) )
                  AADD( tmpArray, "" )
               ELSE
                  nLastError := 1
                  RETURN Nil
               ENDIF
            CASE ( scom = "DO" .AND. UPPER( SUBSTR( stroka, 4, 5 ) ) = "WHILE" ) ;
                   .OR. scom == "WHILE"
               AADD( tmpArray, stroka )
               AADD( rezArray, .F. )
            CASE scom = "ENDDO"
               IF .NOT. Fou_Do()
                  nLastError := 2
                  RETURN Nil
               ENDIF
            CASE scom = "EXIT"
               AADD( tmpArray, "EXIT" )
               AADD( rezArray, .F. )
            CASE scom = "LOOP"
               AADD( tmpArray, "LOOP" )
               AADD( rezArray, .F. )
            CASE scom = "IF"
               AADD( tmpArray, stroka )
               AADD( rezArray, .F. )
            CASE scom = "ELSEIF"
               IF .NOT. Fou_If( .T. )
                  nLastError := 3
                  RETURN Nil
               ENDIF
               AADD( tmpArray, SUBSTR( stroka, 5 ) )
               AADD( rezArray, .F. )
            CASE scom = "ELSE"
               IF .NOT. Fou_If( .T. )
                  nLastError := 1
                  RETURN Nil
               ENDIF
               AADD( tmpArray, "IF .T." )
               AADD( rezArray, .F. )
            CASE scom = "ENDIF"
               IF .NOT. Fou_If( .F. )
                  nLastError := 1
                  RETURN Nil
               ENDIF
            CASE scom = "#ENDSCRIPT"
               RETURN rezArray
            OTHERWISE
               bOldError := ERRORBLOCK( { | e | MacroError(e,stroka) } )
               BEGIN SEQUENCE
                  AADD( rezArray, &( "{||" + ALLTRIM( stroka ) + "}" ) )
               RECOVER
                  IF scrSource != Nil .AND. VALTYPE( scrSource ) == "C"
                     WndOut()
                     FCLOSE( han )
                  ENDIF
                  RETURN Nil
               END SEQUENCE
               ERRORBLOCK( bOldError )
               AADD( tmpArray, "" )
            ENDCASE
         ENDIF
      ENDDO
      IF scrSource != Nil .AND. VALTYPE( scrSource ) == "C"
         WndOut()
         FCLOSE( han )
      ENDIF
   ELSE
#ifdef ENGLISH
      MsgSay( "Can't open " + scrSource )
#else
      MsgSay( "¥ ã¤ «®áì ®âªàëâì " + scrSource )
#endif
      nLastError := -1
      RETURN Nil
   ENDIF
RETURN rezArray

#ifdef __CLIP__
STATIC FUNCTION MacroError( e, stroka )

   ALERT( "Error in" + ';' + AllTrim(stroka) )
   BREAK
RETURN .T.
#else
STATIC FUNCTION MacroError( e, stroka )

   ALERT( "Error" + ';' + ErrorMessage( e ) + ;
          ';' + "in" + ';' + AllTrim(stroka) )
   BREAK
RETURN .T.
#endif

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Static Function Fou_If()
*+
*+    Called from ( procscri.prg )   3 - function rdscript()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
STATIC FUNCTION Fou_If( prju )

LOCAL i, j, bOldError
   IF prju
      AADD( tmpArray, "JUMP" )
      AADD( rezArray, .F. )
   ENDIF
   j := LEN( rezArray )
   FOR i := j TO 1 STEP - 1
      IF .NOT. EMPTY( tmpArray[ i ] ) .AND. UPPER( LEFT( tmpArray[ i ], 2 ) ) = "IF"
         bOldError := ERRORBLOCK( { | e | MacroError(e,tmpArray[ i ]) } )
         BEGIN SEQUENCE
            rezArray[ i ] = &( "{||IIF(" + ALLTRIM( SUBSTR( tmpArray[ i ], 4 ) ) + ;
                 ",.T.,iscr:=" + LTRIM( STR( j, 5 ) ) + ")}" )
         RECOVER
            RETURN .F.
         END SEQUENCE
         ERRORBLOCK( bOldError )
         tmpArray[ i ] = ""
         i --
         IF i > 0 .AND. .NOT. EMPTY( tmpArray[ i ] ) .AND. tmpArray[ i ] = "JUMP"
            rezArray[ i ] = &( "{||iscr:=" + LTRIM( STR( IIF( prju, j - 1, j ), 5 ) ) + "}" )
            tmpArray[ i ] = ""
         ENDIF
         RETURN .T.
      ENDIF
   NEXT
RETURN .F.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Static Function Fou_Do()
*+
*+    Called from ( procscri.prg )   1 - function rdscript()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
STATIC FUNCTION Fou_Do

LOCAL i, j, iloop := 0, iPos, bOldError
   j := LEN( rezArray )
   FOR i := j TO 1 STEP - 1
      IF .NOT. EMPTY( tmpArray[ i ] ) .AND. LEFT( tmpArray[ i ], 4 ) = "EXIT"
         rezArray[ i ] = &( "{||iscr:=" + LTRIM( STR( j + 1, 5 ) ) + "}" )
         tmpArray[ i ] = ""
      ENDIF
      IF .NOT. EMPTY( tmpArray[ i ] ) .AND. LEFT( tmpArray[ i ], 4 ) = "LOOP"
         iloop := i
      ENDIF
      IF .NOT. EMPTY( tmpArray[ i ] ) .AND. ;
            ( UPPER( LEFT( tmpArray[ i ], 8 ) ) = "DO WHILE" .OR. ;
              UPPER( LEFT( tmpArray[ i ], 5 ) ) = "WHILE" )
         bOldError := ERRORBLOCK( { | e | MacroError(e,tmpArray[ i ] ) } )
         BEGIN SEQUENCE
            rezArray[ i ] = &( "{||IIF(" + ALLTRIM( SUBSTR( tmpArray[ i ], ;
                 IIF( UPPER( LEFT( tmpArray[ i ],1 ) ) == "D",10,7 ) ) ) + ;
                 ",.T.,iscr:=" + LTRIM( STR( j + 1, 5 ) ) + ")}" )
         RECOVER
            RETURN .F.
         END SEQUENCE
         ERRORBLOCK( bOldError )
         tmpArray[ i ] = ""
         AADD( rezArray, &( "{||iscr:=" + LTRIM( STR( i - 1, 5 ) ) + "}" ) )
         AADD( tmpArray, "" )
         IF iloop > 0
            rezArray[ iloop ] = &( "{||iscr:=" + LTRIM( STR( i - 1, 5 ) ) + "}" )
            tmpArray[ iloop ] = ""
         ENDIF
         RETURN .T.
      ENDIF
   NEXT
RETURN .F.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function DoScript()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION DoScript( aScript )

LOCAL arlen, stroka, varName, varValue
PRIVATE iscr := 1
   IF aScript == Nil .OR. ( arlen := Len( aScript ) ) == 0
      Return Nil
   ENDIF
   DO WHILE VALTYPE( aScript[ iscr ] ) = "C"
      stroka := aScript[ iscr ++ ]
      DO WHILE !EMPTY( varName := getNextVar( @stroka, @varValue ) )
         PRIVATE &varName
         IF varvalue != Nil
            &varName := &varValue
         ENDIF
      ENDDO
   ENDDO
   DO WHILE iscr > 0 .AND. iscr <= arlen
      EVAL( aScript[ iscr ] )
      iscr ++
   ENDDO
   WndOut()
RETURN Nil

FUNCTION EndScript
   iscr := 0
RETURN Nil

FUNCTION CompileErr( nLine )
   nLine := numlin
RETURN nLastError