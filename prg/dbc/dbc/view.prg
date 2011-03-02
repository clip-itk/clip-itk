/*
 * DBC - Database Control Utility
 * Views
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
*+
*+    Source Module => D:\MYAPPS\SOURCE\MYDBU\VIEW.PRG
*+
*+    Functions: Function RdView()
*+               Function NEXTWORD()
*+               Function Wordend()
*+               Function EL_NEXT()
*+               Function WrView()
*+
*+    Reformatted by Click! 2.00 on Jun-20-2001 at 12:50 pm
*+
*+▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

#ifdef RDD_AX
#ifdef __HARBOUR__
#include "ads.ch"
#else
#include "axntxcdx.ch"
#endif
#endif
#include "deflist.ch"
#include "fileio.ch"

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function RdView()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION RdView( fname )

LOCAL sword, sw2, i, j, poztmp
LOCAL f_impr := lenmsf + 1, kolfiles := 0, msrel := {}, msflt := {}
PRIVATE han, strbuf, stroka, poz1, poz
   han := FOPEN( fname, FO_READ + FO_SHARED )
   IF han <> - 1
      DO WHILE .T.
         stroka := RDSTR( han )
         IF LEN( stroka ) = 0
            EXIT
         ENDIF
         IF SUBSTR( stroka, 1, 1 ) <> ";"
            poz1 := AT( " ", stroka )
            scom := UPPER( SUBSTR( stroka, 1, IIF( poz1 <> 0, poz1 - 1, 999 ) ) )
            DO CASE
            CASE scom = "DRIVER"
               sword := NEXTWORD()
               IF EMPTY( sword )
#ifdef ENGLISH
                  MsgSay( "Driver name is absent" )
#else
                  MsgSay( "Нет имени RDD" )
#endif
                  RETURN
               ELSE
                  numdriv := ASCAN( msdriv, sword )
                  IF numdriv = 0
#ifdef ENGLISH
                     MsgSay( "Driver name is wrong" )
#else
                     MsgSay( "Неверное имя RDD" )
#endif
                     RETURN
                  ELSE
                     RDDSETDEFAULT( msdriv[ numdriv ] )
                  ENDIF
               ENDIF
            CASE scom = "FILE"
               sword := NEXTWORD()
               IF EMPTY( sword )
#ifdef ENGLISH
                  MsgSay( "File name is absent" )
#else
                  MsgSay( "Нет имени файла" )
#endif
                  RETURN
               ELSE
                  FIOPEN( IIF( AT( '\', sword ) = 0, mypath + sword, sword ),, .T. )
                  kolfiles ++
                  IF numdriv > 1
                     numdriv := 1
                     RDDSETDEFAULT( msdriv[ 1 ] )
                  ENDIF
               ENDIF
            CASE scom = "ORDER"
               sword := NEXTWORD()
               IF .NOT. EMPTY( sword )
                  ORDSETFOCUS( sword )
               ENDIF
            CASE scom = "INDEX"
               sword := NEXTWORD()
               IF .NOT. EMPTY( sword )
                  SET INDEX TO &sword
               ENDIF
            CASE scom = "FILTER"
               sword := NEXTWORD()
               IF .NOT. EMPTY( sword )
                  AADD( msflt, { improc, sword } )
               ENDIF
            CASE scom = "RELATION"
               sword := NEXTWORD()
               sw2   := NEXTWORD()
               AADD( msrel, { improc, sword, sw2 } )
            CASE scom = "NAMES"
               poz1 ++
               poztmp := poz1
               i      := 0
               DO WHILE VALTYPE( EL_NEXT() ) == "C"
                  i ++
               ENDDO
               msmsf[ improc, 2 ] = ARRAY( MAX( i, FCOUNT() ) )
               poz1 := poztmp
               i    := 0
               DO WHILE VALTYPE( sword := EL_NEXT() ) == "C"
                  i ++
                  msmsf[ improc, 2 , i ] = sword
               ENDDO
            CASE scom = "FIELDS"
               poz1 ++
               poztmp := poz1
               i      := 0
               DO WHILE VALTYPE( EL_NEXT() ) == "C"
                  i ++
               ENDDO
               msmsf[ improc, 3 ] = ARRAY( MAX( i, FCOUNT() ) )
               poz1 := poztmp
               i    := 0
               DO WHILE VALTYPE( sword := EL_NEXT() ) == "C"
                  i ++
                  msmsf[ improc, 3 , i ] = sword
               ENDDO
            ENDCASE
            //
         ENDIF
      ENDDO
      FCLOSE( han )
      FOR j := f_impr TO f_impr + kolfiles - 1
         improc := j
         SELECT( improc )
         IF msmsf[ j, 3 ] <> Nil
            msmsf[ j, 1 ] = ARRAY( LEN( msmsf[ j, 3 ] ) )
            FOR i := 1 TO LEN( msmsf[ j, 3 ] )
               IF msmsf[ j, 3 , i ] <> Nil
                  sword := msmsf[ j, 3, i ]
                  IF VALTYPE( &sword ) <> "C"
                     sword := "TRANSFORM(" + sword + ",'@(')"
                  ENDIF
                  msmsf[ j, 1 , i ] = &( "{||" + sword + "}" )
               ELSE
                  EXIT
               ENDIF
            NEXT
         ENDIF
      NEXT
      FOR i := 1 TO LEN( msrel )
         SELECT( msrel[ i , 1 ] )
         sword := msrel[ i, 2 ]
         sw2   := msrel[ i, 3 ]
         SET RELATION TO &sword INTO &sw2 ADDITIVE
      NEXT
      FOR i := 1 TO LEN( msflt )
         improc := msflt[ i, 1 ]
         SELECT( improc )
         sword := msflt[ i, 2 ]
         F_FILTER( sword )
      NEXT
      improc  := f_impr
      prkorf  := .T.
      prkorst := .F.
   ELSE
#ifdef ENGLISH
      MsgSay( "Can't open " + fname )
#else
      MsgSay( "Не удалось открыть " + fname )
#endif
      RETURN
   ENDIF
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function NEXTWORD()
*+
*+    Called from ( view.prg     )   7 - function rdview()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION NEXTWORD

LOCAL swo, poz2
   IF poz1 > LEN( stroka )
      RETURN ""
   ENDIF
   DO WHILE poz1 < LEN( stroka ) .AND. SUBSTR( stroka, poz1, 1 ) <= " "
      poz1 ++
   ENDDO
   swo  := SUBSTR( stroka, poz1 )
   poz2 := Wordend( swo )
   IF poz2 = 0
      poz1 := LEN( stroka ) + 1
   ELSE
      swo  := SUBSTR( swo, 1, poz2 - 1 )
      poz1 += poz2
   ENDIF
RETURN UPPER( swo )

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function Wordend()
*+
*+    Called from ( view.prg     )   1 - function nextword()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION Wordend( stro )

LOCAL i := 1, ln := LEN( stro )
   DO WHILE i < ln
      IF SUBSTR( stro, i, 1 ) <= " "
         RETURN i
      ENDIF
      i ++
   ENDDO
RETURN 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function EL_NEXT()
*+
*+    Called from ( view.prg     )   4 - function rdview()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION EL_NEXT

LOCAL poz2, stmp
   IF poz1 <= LEN( stroka )
      stmp := SUBSTR( stroka, poz1 )
      poz2 := FIND_Z( stmp )
      IF poz2 <> 0
         stmp := SUBSTR( stmp, 1, poz2 - 1 )
         poz1 += poz2
      ELSE
         poz1 := LEN( stroka ) + 1
      ENDIF
   ELSE
      RETURN .F.
   ENDIF
RETURN stmp

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function WrView()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION WrView( fname )

LOCAL i, han, j, strlen, obl
   obl := SELECT()
   han := FCREATE( fname, FC_NORMAL )
   IF han <> - 1
      FOR i := 1 TO lenmsf
         IF msmode[ i, 3 ] > 1
            FWRITE( han, "Driver " + msdriv[ msmode[ i, 3 ] ] + CHR( 13 ) + CHR( 10 ) )
         ENDIF
         FWRITE( han, "File " + msfile[ i ] + CHR( 13 ) + CHR( 10 ) )
         SELECT( i )
         IF .NOT. EMPTY( ORDSETFOCUS() )
            IF msmode[ i, 3 ] = 2
               FWRITE( han, "Index " + ORDBAGNAME() + CHR( 13 ) + CHR( 10 ) )
            ELSE
               FWRITE( han, "Order " + ORDSETFOCUS() + CHR( 13 ) + CHR( 10 ) )
            ENDIF
         ENDIF
         IF .NOT. EMPTY( DBFILTER() )
            FWRITE( han, "Filter " + ALLTRIM( DBFILTER() ) + CHR( 13 ) + CHR( 10 ) )
         ENDIF
         FOR j := 1 TO 3
            IF .NOT. EMPTY( DBRELATION( j ) )
               FWRITE( han, "RELATION " + DBRELATION( j ) + " " + ALIAS( DBRSELECT( j ) ) + CHR( 13 ) + CHR( 10 ) )
            ELSE
               EXIT
            ENDIF
         NEXT
         IF msmsf[ i, 3 ] <> Nil
            FWRITE( han, "NAMES" )
            strlen := 5
            FOR j := 1 TO LEN( msmsf[ i, 3 ] )
               IF msmsf[ i, 3 , j ] <> Nil
                  IF strlen > 90
                     FWRITE( han, "&" + CHR( 13 ) + CHR( 10 ) )
                  ENDIF
                  FWRITE( han, IIF( j = 1, ' ', ',' ) + msmsf[ i, 2 , j ] )
                  strlen += LEN( msmsf[ i, 2, j ] ) + 1
               ELSE
                  EXIT
               ENDIF
            NEXT
            FWRITE( han, CHR( 13 ) + CHR( 10 ) )
            FWRITE( han, "FIELDS" )
            strlen := 6
            FOR j := 1 TO LEN( msmsf[ i, 3 ] )
               IF msmsf[ i, 3 , j ] <> Nil
                  IF strlen > 90
                     FWRITE( han, "&" + CHR( 13 ) + CHR( 10 ) )
                  ENDIF
                  FWRITE( han, IIF( j = 1, ' ', ',' ) + msmsf[ i, 3 , j ] )
                  strlen += LEN( msmsf[ i, 3, j ] ) + 1
               ELSE
                  EXIT
               ENDIF
            NEXT
            FWRITE( han, CHR( 13 ) + CHR( 10 ) )
         ENDIF
      NEXT
      FCLOSE( han )
   ELSE
#ifdef ENGLISH
      MsgSay( "Can't create " + fname )
#else
      MsgSay( "Не удалось создать " + fname )
#endif
   ENDIF
   SELECT( obl )
RETURN Nil

*+ EOF: VIEW.PRG
