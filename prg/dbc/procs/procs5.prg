/*
 * Common procedures
 * Db browse ( use with dbflist, procs1.prg )
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
*+
*+    Source Module => D:\MYAPPS\SOURCE\PROCS\PROCS5.PRG
*+
*+    Functions: Function InitList()
*+               Function FGOTOP()
*+               Function FGOBOT()
*+               Procedure FSKIP()
*+               Function FBOF()
*+               Function FEOF()
*+               Procedure FLMSFLD()
*+               Function Defpict()
*+               Function EMPVAR()
*+               Function FLDS()
*+
*+    Reformatted by Click! 2.00 on Apr-17-2001 at  1:48 pm
*+
*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊

#ifdef RDD_AX
#include "dbfcdxax.ch"
#endif
// #include "fileio.ch"
#include "deflist.ch"

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function InitList()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
FUNCTION InitList

LOCAL mslist := ARRAY( LI_LEN )
   LI_NSTR    := LI_MSED := 1
   LI_CLR     := "W+/B"
   LI_CLRV    := "R/W"
   LI_BSKIP   := { | a, x | FSKIP( a, x ) }
   LI_BGTOP   := { | a | FGOTOP( a ) }
   LI_BGBOT   := { | a | FGOBOT( a ) }
   LI_BEOF    := { | a | FEOF( a ) }
   LI_BBOF    := { | a | FBOF( a ) }
   LI_B1      := { | a | DEVPOS( LI_Y2, LI_X1 + 2 ), DEVOUT( IIF( LI_PRFLT, "敤忄" + STR( LI_TEKZP, 5 ), STR( RECNO(), 6 ) ) + "/" + STR( LI_KOLZ, 6 ) ) }
   LI_FREEZE  := 0
   LI_RCOU    := { || RECCOUNT() }
   LI_MSREC   := Nil
   LI_RECNO   := { || RECNO() }
   LI_BGOTO   := { | a, n | DBGOTO( n ) }
   LI_PRFLT   := LI_LVIEW := LI_LADD := LI_UPDATED := .F.
   LI_LSOHR   := .T.
   LI_BDESHIN := LI_BDESHOUT := LI_MSF := LI_MSTYP := Nil
   LI_TEKZP   := 1
   LI_SEPARATOR := " "
RETURN mslist

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function FGOTOP()
*+
*+    Called from ( procs5.prg   )   1 - function initlist()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
FUNCTION FGOTOP( mslist )

   IF LI_PRFLT
      IF LI_KOLZ > 0
         LI_TEKZP := 1
         GO LI_MSREC[ 1 ]
      ENDIF
   ELSE
      GO TOP
   ENDIF
RETURN Nil

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function FGOBOT()
*+
*+    Called from ( procs5.prg   )   1 - function initlist()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
FUNCTION FGOBOT( mslist )

   IF LI_PRFLT
      LI_TEKZP := LI_KOLZ
      GO IIF( LI_KOLZ < klrecf, LI_MSREC[ LI_KOLZ ], LI_MSREC[ klrecf ] )
   ELSE
      GO BOTTOM
   ENDIF
RETURN Nil

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Procedure FSKIP()
*+
*+    Called from ( procs5.prg   )   1 - function initlist()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
PROCEDURE FSKIP( mslist, kolskip )

LOCAL tekzp1
   IF LI_PRFLT
      IF LI_KOLZ = 0
         RETURN
      ENDIF
      tekzp1   := LI_TEKZP
      LI_TEKZP := LI_TEKZP + kolskip + IIF( tekzp1 = 0, 1, 0 )
      IF LI_TEKZP < 1
         LI_TEKZP := 0
         GO LI_MSREC[ 1 ]
      ELSEIF LI_TEKZP > LI_KOLZ
         LI_TEKZP := LI_KOLZ + 1
         GO IIF( LI_KOLZ < klrecf, LI_MSREC[ LI_KOLZ ], LI_MSREC[ klrecf ] )
      ELSE
         IF LI_TEKZP > klrecf - 1
            SKIP IIF( tekzp1 = LI_KOLZ + 1, kolskip + 1, kolskip )
         ELSE
            GO LI_MSREC[ LI_TEKZP ]
         ENDIF
      ENDIF
   ELSE
      SKIP kolskip
   ENDIF
RETURN

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function FBOF()
*+
*+    Called from ( procs5.prg   )   1 - function initlist()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
FUNCTION FBOF( mslist )

   IF LI_PRFLT
      RETURN IIF( LI_TEKZP = 0, .T., .F. )
   ENDIF
RETURN BOF()

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function FEOF()
*+
*+    Called from ( procs5.prg   )   1 - function initlist()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
FUNCTION FEOF( mslist )

   IF LI_PRFLT
      RETURN IIF( LI_TEKZP > LI_KOLZ, .T., .F. )
   ENDIF
RETURN EOF()

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Procedure FLMSFLD()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
PROCEDURE FLMSFLD( mspic, lValue, maxlen )

LOCAL i, varname, mslen := FCOUNT()
   FOR i := 1 TO mslen
      varname  := "GET" + PADL( i, 2,"0" )
      &varname := IIF( lValue, FIELDGET( i ), Empvar( i ) )
      IF mspic <> Nil
         mspic[ i ] := Defpict( i, maxlen )
      ENDIF
   NEXT
RETURN

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function Defpict()
*+
*+    Called from ( procs5.prg   )   1 - procedure flmsfld()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
FUNCTION Defpict( i, maxlen )

LOCAL spict, fldd, fldtype := FIELDTYPE( i ), fldlen := FIELDSIZE( i )
   DO CASE
   CASE fldtype == "C"
      spict := IIF( maxlen = Nil, REPLICATE( "X", fldlen ), "@S" + PADL( maxlen, 2,"0" ) )
   CASE fldtype == "N"
      fldd  := FIELDDECI( i )
      spict := IIF( fldd = 0, REPLICATE( "9", fldlen ), REPLICATE( "9", fldlen - 1 - fldd ) + "." + REPLICATE( "9", fldd ) )
   CASE fldtype == "D"
      spict := "@D"
   ENDCASE
RETURN spict

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function EMPVAR()
*+
*+    Called from ( procs5.prg   )   1 - procedure flmsfld()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
FUNCTION EMPVAR( numf )

LOCAL rez, fldtype := FIELDTYPE( numf )
   DO CASE
   CASE fldtype = "C"
      rez := SPACE( FIELDSIZE( numf ) )
   CASE fldtype = "N"
      rez := 0
   CASE fldtype = "D"
      rez := CTOD( SPACE( 8 ) )
   CASE fldtype = "L"
      rez := .F.
   ENDCASE
RETURN rez

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function FLDS()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
FUNCTION FLDS( numf, znch, pr )

LOCAL fldtype, rez
   fldtype := FIELDTYPE( numf )
   DO CASE
   CASE fldtype = "C"
      rez := '"' + RTRIM( znch ) + '"'
   CASE fldtype = "N"
      rez := LTRIM( STR( znch, FIELDSIZE( numf ), FIELDDECI( numf ) ) )
   CASE fldtype = "D"
      IF pr
         rez := 'CTOD("' + DTOC( znch ) + '")'
      ELSE
         rez := DTOC( znch )
      ENDIF
   CASE fldtype = "L"
      rez := IIF( znch, '".T."', '".F."' )
   ENDCASE
RETURN rez

*+ EOF: PROCS5.PRG
