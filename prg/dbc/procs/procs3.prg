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
*+    Source Module => D:\MYAPPS\SOURCE\PROCS\PROCS3.PRG
*+
*+    Functions: Function ORSEEK()
*+               Function NUM_STR()
*+               Function SUMMAS()
*+               Function SCHDIV()
*+               Function NAMDIV()
*+               Function FNDSCH()
*+               Function ACondAdd()
*+               Function AFind()
*+               Function PLIF()
*+               Function TRANSNUM()
*+               Function PERIOD()
*+               Function OBRSUB()
*+               Function PROPIS()
*+               Function EXECUTE()
*+               Function SDIV()
*+               Function StrinDiv()
*+               Function MsgSay()
*+               Function MsgGet()
*+               Function FCHOICE()
*+               Function ASUM()
*+               Function DC2000()
*+               Function DateY()
*+               Function ADDMONTH()
*+               Function CutExten()
*+               Function FilExten()
*+               Function Stufmy()
*+               Function DosToWin()
*+               Function WinToDos()
*+               Function ReadParam()
*+               Function StrOut()
*+
*+    Reformatted by Click! 2.00 on Jul-3-2001 at  2:59 pm
*+
*+≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤

#ifdef RDD_AX
#include "dbfcdxax.ch"
#endif
#include "fileio.ch"
#include "deflist.ch"

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function ORSEEK()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION ORSEEK( valseek, numord )

LOCAL oldord := ORDSETFOCUS( numord ), rez := DBSEEK( valseek )
   IF oldord <> numord
      ORDSETFOCUS( oldord )
   ENDIF
RETURN rez

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function NUM_STR()
*+
*+    Called from ( procs3.prg   )   1 - function period()
*+                                   2 - function dc2000()
*+                                   2 - function addmonth()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNC NUM_STR( NOM, KOLZN )

   NOM := INT( NOM )
RETURN ( REPLICATE( "0", KOLZN - LEN( LTRIM( STR( NOM ) ) ) ) + LTRIM( STR( NOM ) ) )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function SUMMAS()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION SUMMAS( kolpovt, masnm, nItem )

LOCAL xsum := 0
   IF nItem == Nil
      AEVAL( masnm, { | nVal | xsum := xsum + nVal }, 1, kolpovt )
   ELSE
      AEVAL( masnm, { | aVal | xsum := xsum + aVal[ nItem ] }, 1, kolpovt )
   ENDIF
RETURN xsum

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function SCHDIV()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION SCHDIV( var1, var2 )

LOCAL prsc1, j
   IF .NOT. EMPTY( var1 ) .AND. .NOT. EMPTY( var2 )
      prsc1 := .F.
      IF kolsc > 0
         FOR j := 1 TO kolsc
            IF var1 = MSSCH[ j ]
               STORE MSSUM1[ j ] + var2 TO MSSUM1[ j ]
               prsc1 := .T.
               EXIT
            ENDIF
         NEXT
      ENDIF
      IF .NOT. prsc1
         IF kolsc == LEN( MSSCH )
            AADD( MSSCH, Nil )
            AADD( MSSUM1, Nil )
         ENDIF
         STORE kolsc + 1 TO kolsc
         MSSCH[ kolsc ] = var1
         MSSUM1[ kolsc ] = var2
      ENDIF
   ENDIF
RETURN var1

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function NAMDIV()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION NAMDIV( var1, var2, var3 )

LOCAL prsc1, j
   IF .NOT. EMPTY( var1 )               // .AND.(.NOT.EMPTY(var2).OR..NOT.EMPTY(var3))
      prsc1 := .F.
      IF kolnam > 0
         FOR j := 1 TO kolnam
            IF var1 = MSNAIM[ j ]
               STORE MSSM1[ j ] + var2 TO MSSM1[ j ]
               IF var3 <> Nil
                  STORE MSSM2[ j ] + var3 TO MSSM2[ j ]
               ENDIF
               prsc1 := .T.
               EXIT
            ENDIF
         NEXT
      ENDIF
      IF .NOT. prsc1
         IF kolnam == LEN( MSNAIM )
            AADD( MSNAIM, Nil )
            AADD( MSSM1, Nil )
            AADD( MSSM2, Nil )
         ENDIF
         STORE kolnam + 1 TO kolnam
         MSNAIM[ kolnam ] = var1
         MSSM1[ kolnam ] = var2
         IF var3 <> Nil
            MSSM2[ kolnam ] = var3
         ENDIF
      ENDIF
   ENDIF
RETURN var1

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function FNDSCH()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION FNDSCH( fsch, nsum )

LOCAL i, rsum
   IF nsum = Nil
      nsum := 1
   ENDIF
   rsum := 0
   FOR i := 1 TO kolnam
      IF MSNAIM[ i ] = fsch
         rsum := rsum + IIF( nsum = 1, MSSM1[ i ], MSSM2[ i ] )
      ENDIF
   NEXT
RETURN rsum

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function ACondAdd()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION ACondAdd( arr, kolItems, aItems )

LOCAL i, nIndex
   kolItems := IIF( kolItems == Nil, LEN( arr ), kolItems )
   IF ( nIndex := ASCAN( arr, { | aVal | aVal[ 1 ] == aItems[ 1 ] }, 1, kolItems ) ) > 0
      FOR i := 2 TO LEN( aItems )
         arr[ nIndex, i ] += aItems[ i ]
      NEXT
   ELSE
      IF ++ kolItems > LEN( arr )
         AADD( arr, aItems )
      ELSE
         arr[ kolItems ] := aItems
      ENDIF
   ENDIF
RETURN .T.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function AFind()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION AFind( fsch, nItem, arr, kolItems )

LOCAL i, rsum := 0, aFnd, kola
STATIC aTmp, nTmp

   IF fsch == Nil
      aTmp := arr
      nTmp := kolItems
   ELSE
      nItem := IIF( nItem == Nil, 2, nItem )
      aFnd  := IIF( arr == Nil, aTmp, arr )
      kola  := IIF( kolItems == 0, nTmp, kolItems )
      FOR i := 1 TO kola
         IF aFnd[ i, 1 ] = fsch
            rsum += aFnd[ i, nItem ]
         ENDIF
      NEXT
   ENDIF

RETURN rsum

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function PLIF()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION PLIF( n )

RETURN IIF( n > 0, n, 0 )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function TRANSNUM()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION TRANSNUM( vnum )

RETURN IIF( rou_dec = 0, TRANSFORM( vnum, "999 999 999 999" ), TRANSFORM( vnum, "999 999 999.99" ) )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function PERIOD()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION PERIOD( date1, date2 )

LOCAL rez
   IF PCOUNT() = 1
      date2 := tdate
   ENDIF
   date2 := CTOD( "01/" + PADL( IIF( kvartal, ( INT( ( MONTH( date2 ) - 1 ) / 3 ) ) * 3 + 1, MONTH( date2 ) ), 2, "0" ) + SUBSTR( DTOC( date2 ), 6, 3 ) )
   IF kvartal
      rez := IIF( date1 < date2, - 1, IIF( date1 >= date2 .AND. date1 < ADDMONTH( date2, 3 ), 0, 1 ) )
   ELSE
      rez := IIF( date1 < date2, - 1, IIF( date1 >= date2 .AND. date1 < ADDMONTH( date2, 1 ), 0, 1 ) )
   ENDIF
RETURN rez

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function OBRSUB()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION OBRSUB( sseek, blockf, block0 )

LOCAL bind, nrec
MEMVAR kolz
PRIVATE kolz
   kolz := 0
   SEEK sseek
   IF .NOT. EOF()
      bind := &( "{||" + INDEXKEY() + "}" )
      IF blockf = Nil
         blockf := { || .T. }
      ELSE
         blockf := &( "{||" + blockf + "}" )
      ENDIF
      DO WHILE EVAL( bind ) = sseek .AND. .NOT. EOF()
         IF EVAL( blockf )
            kolz ++
            IF kolz = 1
               nrec := RECNO()
            ENDIF
            IF block0 <> Nil
               EVAL( block0 )
            ELSE
               EXIT
            ENDIF
         ENDIF
         SKIP
      ENDDO
      IF kolz > 0
         GO nrec
      ENDIF
   ENDIF
RETURN kolz

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function PROPIS()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION PROPIS( chislo, valut )

LOCAL str1, str2, str3, strrez, i, j, len, kolgr, kod, prbe, strupp, strlow, skop
LOCAL msnm1[ 4 ], msnm2[ 4 ], msnm3[ 4 ]
LOCAL mssot  := { "·‚Æ", "§¢•·‚®", "‚‡®·‚†", "Á•‚Î‡•·‚†", "ØÔ‚Ï·Æ‚", "Ë•·‚Ï·Æ‚", "·•¨Ï·Æ‚", "¢Æ·•¨Ï·Æ‚", "§•¢Ô‚Ï·Æ‚" }
LOCAL msdes  := { "§¢†§Ê†‚Ï", "‚‡®§Ê†‚Ï", "·Æ‡Æ™", "ØÔ‚Ï§•·Ô‚", "Ë•·‚Ï§•·Ô‚", "·•¨Ï§•·Ô‚", "¢Æ·•¨Ï§•·Ô‚", "§•¢Ô≠Æ·‚Æ" }
LOCAL ms1des := { "§•·Ô‚Ï", "Æ§®≠≠†§Ê†‚Ï", "§¢•≠†§Ê†‚Ï", "‚‡®≠†§Ê†‚Ï", "Á•‚Î‡≠†§Ê†‚Ï", "ØÔ‚≠†§Ê†‚Ï", "Ë•·‚≠†§Ê†‚Ï", "·•¨≠†§Ê†‚Ï", "¢Æ·•¨≠†§Ê†‚Ï", "§•¢Ô‚≠†§Ê†‚Ï" }
LOCAL msed   := { "Æ§®≠", "§¢†", "‚‡®", "Á•‚Î‡•", "ØÔ‚Ï", "Ë•·‚Ï", "·•¨Ï", "¢Æ·•¨Ï", "§•¢Ô‚Ï" }
LOCAL msed1  := { "Æ§≠†", "§¢•" }
LOCAL msrod  := { .T., .T., .F., .T. }
   valut := IIF( valut = Nil, .F., valut )
   msnm1[ 1 ] = "¨®´´®†‡§"
   msnm1[ 2 ] = "¨®´´®Æ≠"
   msnm1[ 3 ] = "‚Î·ÔÁ†"
   msnm1[ 4 ] = IIF( valut, "§Æ´´†‡ ëòÄ", "‡„°´Ï" )
   msnm2[ 1 ] = "¨®´´®†‡§†"
   msnm2[ 2 ] = "¨®´´®Æ≠†"
   msnm2[ 3 ] = "‚Î·ÔÁ®"
   msnm2[ 4 ] = IIF( valut, "§Æ´´†‡† ëòÄ", "‡„°´Ô" )
   msnm3[ 1 ] = "¨®´´®†‡§Æ¢"
   msnm3[ 2 ] = "¨®´´®Æ≠Æ¢"
   msnm3[ 3 ] = "‚Î·ÔÁ"
   msnm3[ 4 ] = IIF( valut, "§Æ´´†‡Æ¢ ëòÄ", "‡„°´•©" )
   strupp := "ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôúõöùûü"
   strlow := "†°¢£§•¶ß®©™´¨≠ÆØ‡·‚„‰ÂÊÁËÈÏÎÍÌÓÔ"
   str2   := SPACE( 10 )
   str3   := SPACE( 10 )
   strrez := SPACE( 120 )
   len    := AT( ".", chislo ) - 1
   kolgr  := INT( ( len + 2 ) / 3 )
   i      := kolgr * 3 - len
   str1   := REPLICATE( "0", i ) + chislo
   FOR j := 0 TO kolgr - 1
      prbe := .F.
      kod  := VAL( SUBSTR( str1, j * 3 + 1, 1 ) )
      IF kod <> 0
         strrez := TRIM( strrez ) + " " + mssot[ kod ]
         prbe   := .T.
      ENDIF
      kod := VAL( SUBSTR( str1, j * 3 + 2, 1 ) )
      IF kod = 1
         kod    := VAL( SUBSTR( str1, j * 3 + 3, 1 ) )
         strrez := TRIM( strrez ) + " " + ms1des[ kod + 1 ]
         str3   := msnm3[ 5 - kolgr + j ]
         prbe   := .T.
      ELSE
         IF kod <> 0
            strrez := TRIM( strrez ) + " " + msdes[ kod - 1 ]
            prbe   := .T.
         ENDIF
         kod := VAL( SUBSTR( str1, j * 3 + 3, 1 ) )
         IF kod = 1
            str3 := msnm1[ 5 - kolgr + j ]
         ELSEIF kod > 1 .AND. kod < 5
            str3 := msnm2[ 5 - kolgr + j ]
         ELSE
            IF kod = 0 .AND. prbe = .F. .AND. j <> kolgr - 1
               str3 := " "
            ELSE
               str3 := msnm3[ 5 - kolgr + j ]
            ENDIF
         ENDIF
         IF kod <> 0
            IF msrod[ 5 - kolgr + j ] .OR. kod > 2
               str2 := msed[ kod ]
            ELSE
               str2 := msed1[ kod ]
            ENDIF
            strrez := TRIM( strrez ) + " " + str2
         ENDIF
      ENDIF
      strrez := TRIM( strrez ) + " " + str3
   NEXT
   kod := VAL( SUBSTR( chislo, len + 2, 2 ) )
   IF kod <> 0
      skop := VAL( SUBSTR( chislo, len + 3, 1 ) )
      IF valut
         strrez := TRIM( strrez ) + " " + SUBSTR( chislo, len + 2, 2 ) + IIF( ( kod > 9 .AND. kod < 21 ) .OR. skop = 0 .OR. skop > 4, " Ê•≠‚Æ¢", IIF( skop = 1, " Ê•≠‚", " Ê•≠‚†" ) )
      ELSE
         strrez := TRIM( strrez ) + " " + SUBSTR( chislo, len + 2, 2 ) + IIF( ( kod > 9 .AND. kod < 21 ) .OR. skop = 0 .OR. skop > 4, " ™ÆØ••™", IIF( skop = 1, " ™ÆØ•©™†", " ™ÆØ•©™®" ) )
      ENDIF
   ELSE
      strrez := TRIM( strrez ) + "="
   ENDIF
   i := AT( SUBSTR( strrez, 2, 1 ), strlow )
   IF i > 0
      strrez := STUFF( strrez, 2, 1, SUBSTR( strupp, i, 1 ) )
   ENDIF
RETURN strrez

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function EXECUTE()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION EXECUTE( expres )

LOCAL vartmp, poz
MEMVAR pend
PRIVATE pend := .T.
   DO WHILE pend
      poz := FIND_Z( expres )
      IF poz <> 0
         vartmp := &( SUBSTR( expres, 1, poz - 1 ) )
         expres := SUBSTR( expres, poz + 1 )
      ELSE
         IF .NOT. EMPTY( expres )
            vartmp := &expres
            EXIT
         ENDIF
      ENDIF
   ENDDO
RETURN vartmp

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function SDIV()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION SDIV( str, rlen )

LOCAL i, strtmp, vname, poz1
   STORE SPACE( rlen ) TO part2, part3, part4, part5
   str := TRIM( str )
   FOR i := 1 TO 5
      vname := "part" + STR( i, 1 )
      IF LEN( str ) <= rlen
         &vname := str
         EXIT
      ENDIF
      strtmp := SUBSTR( str, 1, rlen )
      poz1   := MAX( RAT( " ", strtmp ), RAT( ",", strtmp ) )
      poz1   := MAX( poz1, RAT( ".", strtmp ) )
      IF poz1 = 0
         poz1 := rlen
      ENDIF
      &vname := SUBSTR( str, 1, poz1 )
      str    := SUBSTR( str, poz1 + 1 )
   NEXT
RETURN part1

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function StrinDiv()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION StrinDiv( stroka, partLen, partNum )

LOCAL i := 1, strtmp, pos := 1, pos1
   DO WHILE i <= partNum
      strtmp := SUBSTR( stroka, pos, partLen )
      IF LEN( strtmp ) < partLen
         pos1 := 0
      ELSE
         pos1 := MAX( MAX( RAT( " ", strtmp ), RAT( ",", strtmp ) ), RAT( ".", strtmp ) )
      ENDIF
      pos += IIF( pos = 0, partLen, pos1 )
      i ++
   ENDDO
RETURN IIF( pos1 = 0, strtmp, LEFT( strtmp, pos1 ) )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MsgSay()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION MsgSay( tsoob, clr )

LOCAL oldc, bufscr, ln := LEN( tsoob ), x1
   x1     := 40 - INT( ln / 2 ) - 3
   bufscr := SAVESCREEN( 10, x1, 12, x1 + ln + 4 )
   oldc   := SETCOLOR()
   SETCOLOR( IIF( clr = Nil, "+W/R", clr ) )
   @ 10, x1, 12, x1 + ln + 4 BOX "⁄ƒø≥Ÿƒ¿≥ "
   @ 11, x1 + 2 SAY tsoob         
   WAIT ""
   SETCOLOR( oldc )
   RESTSCREEN( 10, x1, 12, x1 + ln + 4, bufscr )
RETURN .T.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MsgGet()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION MsgGet( tsoob, tpict, txget )

LOCAL GetList := {}
LOCAL oldc, bufscr, x1, lennm := MAX( 52, LEN( tsoob ) )
   txget  := IIF( txget = Nil, SPACE( 200 ), IIF( VALTYPE( txget ) = "C", PADR( txget, 200 ), txget ) )
   x1     := INT( ( 76 - lennm ) / 2 ) - 2
   bufscr := SAVESCREEN( 08, x1, 11, x1 + lennm + 4 )
   oldc   := SETCOLOR()
   SET COLOR TO +W/RB,B/W,,,+W/RB
   @ 08, x1, 11, x1 + lennm + 4 BOX "⁄ƒø≥Ÿƒ¿≥ "
   @ 09, x1 + 2 SAY tsoob                                                   
   @ 10, x1 + 2 GET txget PICTURE IIF( tpict <> Nil, tpict, "@S50" )        
   READ
   SETCOLOR( oldc )
   RESTSCREEN( 08, x1, 11, x1 + lennm + 4, bufscr )
   IF LASTKEY() = 27
      RETURN ""
   ENDIF
RETURN IIF( VALTYPE( txget ) = "C", TRIM( txget ), txget )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function FCHOICE()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION FCHOICE( forms, y1, x1, color1, colorv, title )

LOCAL i, x2, y2, lennm := 0, kolforms := LEN( forms )
LOCAL xmin   := IIF( x1 == Nil, 70, 78 - x1 ), ymin := IIF( y1 == Nil, 16, 24 - y1 )
LOCAL mslist := InitArEdit()

   LI_CLR  := IIF( color1 == Nil, "W+/GR", color1 )
   LI_CLRV := IIF( colorv == Nil, "R/W", colorv )

   FOR i := 1 TO kolforms
      lennm := MAX( lennm, LEN( forms[ i ] ) )
   NEXT
   lennm := MIN( lennm, xmin )
   IF x1 == Nil
      x1 := INT( ( 76 - lennm ) / 2 )
   ENDIF
   x2       := x1 + lennm + 4
   kolforms := MIN( kolforms, ymin )
   IF y1 == Nil
      y1 := INT( ( 20 - kolforms ) / 2 )
   ENDIF
   y2       := y1 + kolforms + 1
   LI_MSF   := { { | mslist | LI_MSREC[ LI_TEKZP ] } }
   LI_MSTYP := { "C" }
   LI_MSLEN := { lennm }

RETURN IIF( Arlist( mslist, y1, x1, y2, x2, forms, title ) == 0, 0, LI_TEKZP )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function ASUM()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION ASUM( ms1, n1, n2 )

LOCAL rezsum := 0, i
   n1 := IIF( n1 = Nil, 1, n1 )
   n2 := IIF( n2 = Nil, LEN( ms1 ), n2 )
   FOR i := n1 TO n2
      rezsum += ms1[ i ]
   NEXT
RETURN rezsum

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function DC2000()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION DC2000( d1, delimi )

   delimi := IIF( delimi = Nil, '/', delimi )
RETURN PADL( DAY( d1 ), 2 ) + delimi + PADL( MONTH( d1 ), 2, "0" ) + delimi + STR( YEAR( d1 ), 4 )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function DateY()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION DateY

   RETURN IIF( YEAR( DATE() ) < 2000, Addmonth( DATE(), IIF( TYPE( "add_mnth" ) = "N", add_mnth, 0 ) ), DATE() )

#ifdef __HARBOUR__

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function ADDMONTH()
*+
*+    Called from ( procs3.prg   )   2 - function period()
*+                                   1 - function datey()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION ADDMONTH( dt, n )

LOCAL mn, ye
   mn := MONTH( dt ) + n % 12
   ye := YEAR( dt ) + INT( n / 12 )
   IF mn > 12
      ye ++
      mn -= 12
   ELSEIF mn < 0
      ye --
      mn += 12
   ENDIF
   RETURN CTOD( PADL( DAY( dt ), 2, "0" ) + "/" + PADL( mn, 2, "0" ) + "/" + SUBSTR( STR( ye, 4 ), 3, 2 ) )
#endif

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function Stufmy()
*+
*+    Called from ( procs3.prg   )   4 - function dostowin()
*+                                   4 - function wintodos()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION Stufmy( stsou, pozs, ellen, elzn )

RETURN SUBSTR( stsou, 1, pozs - 1 ) + elzn + SUBSTR( stsou, pozs + ellen )

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function DosToWin()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION DosToWin( stroka )

LOCAL i, slen := LEN( stroka ), ia
   FOR i := 1 TO slen
      ia := ASC( SUBSTR( stroka, i, 1 ) )
      IF ia >= 128 .AND. ia <= 159
         stroka := StufMy( stroka, i, 1, CHR( ia + 64 ) )
      ELSEIF ia >= 160 .AND. ia <= 175
         stroka := STUFmY( stroka, i, 1, CHR( ia + 64 ) )
      ELSEIF ia >= 224 .AND. ia <= 239
         stroka := StufMy( stroka, i, 1, CHR( ia + 16 ) )
      ELSEIF ia == 241
         stroka := StufMy( stroka, i, 1, CHR( 184 ) )
      ENDIF
   NEXT
RETURN stroka

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function WinToDos()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION WinToDos( stroka )

LOCAL i, slen := LEN( stroka ), ia
   FOR i := 1 TO slen
      ia := ASC( SUBSTR( stroka, i, 1 ) )
      IF ia >= 192 .AND. ia <= 223
         stroka := StufMy( stroka, i, 1, CHR( ia - 64 ) )
      ELSEIF ia >= 224 .AND. ia <= 239
         stroka := StufMy( stroka, i, 1, CHR( ia - 64 ) )
      ELSEIF ia >= 240 .AND. ia <= 255
         stroka := StufMy( stroka, i, 1, CHR( ia - 16 ) )
      ELSEIF ia == 184
         stroka := StufMy( stroka, i, 1, CHR( 241 ) )
      ENDIF
   NEXT
RETURN stroka

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function ReadParam()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION ReadParam()

LOCAL i, vartmp
   PARAMETERS _par1, _par2, _par3
   FOR i := 1 TO 3
      vartmp := "_par" + STR( i, 1 )
      IF &vartmp != Nil
         IF LEFT( &vartmp, 1 ) == '-'
            vartmp := SUBSTR( &vartmp, 2 )
            IF vartmp $ "tT"
               isTick := .F.
            ENDIF
         ELSE
            mypath := &vartmp
         ENDIF
      ENDIF
   NEXT
RETURN

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function StrOut()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION StrOut( y, x, stroka )

   @ y, x SAY stroka         
RETURN .T.

*+ EOF: PROCS3.PRG
