/*
 * Common procedures
 * Array browse ( use with dbflist, procs1.prg )
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊
*+
*+    Source Module => D:\MYAPPS\SOURCE\PROCS\PROCARED.PRG
*+
*+    Functions: Function InitArEdit()
*+               Procedure ARSKIP()
*+
*+    Reformatted by Click! 2.00 on Apr-17-2001 at  2:11 pm
*+
*+膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊膊

#ifdef RDD_AX
#include "dbfcdxax.ch"
#endif
#include "fileio.ch"
#include "deflist.ch"


#ifdef VER_MOUSE
FUNCTION ARLIST( mslist, y1, x1, y2, x2, arr, title, maskey, ctrl_ar )
#else
FUNCTION ARLIST( mslist, y1, x1, y2, x2, arr, title, maskey )
#endif
Local i
   IF mslist == Nil
      mslist := InitArEdit()
   ENDIF
   IF LI_MSREC == Nil
      LI_MSREC := arr
   ENDIF
   IF LI_MSF == Nil
      IF Valtype( LI_MSREC[ 1 ] ) == "A"
         LI_MSF := Array( Len( LI_MSREC[ 1 ] ) )
         FOR i := 1 TO Len( LI_MSF )
            LI_MSF[ i ] := {|mslist,n| LI_MSREC[ LI_TEKZP,n ] }
         NEXT
      ELSE
         LI_MSF := { {|mslist| LI_MSREC[ LI_TEKZP ] } }
      ENDIF
   ENDIF
#ifdef VER_MOUSE
RETURN DBFLIST( mslist, x1, y1, x2, y2, title, maskey, ctrl_ar )
#else
RETURN DBFLIST( mslist, x1, y1, x2, y2, title, maskey )
#endif

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Function InitArEdit()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
FUNCTION InitArEdit

LOCAL mslist := ARRAY( LI_LEN )
   LI_NSTR    := LI_MSED := LI_TEKZP := 1
   LI_CLR     := "W+/B"
   LI_CLRV    := "R/W"
   LI_BSKIP   := { | a, x | ARSKIP( a, x ) }
   LI_BGTOP   := { | a | LI_TEKZP := 1 }
   LI_BGBOT   := { | a | LI_TEKZP := LI_KOLZ }
   LI_BEOF    := { | a | LI_TEKZP > LI_KOLZ }
   LI_BBOF    := { | a | LI_TEKZP == 0 }
   LI_B1      := { | a | DEVPOS( LI_Y2, LI_X1 + 2 ), DEVOUT( STR( LI_TEKZP, 4 ) + "/" + STR( LI_KOLZ, 4 ) ) }
   LI_FREEZE  := 0
   LI_RCOU    := { | a | Len( LI_MSREC ) }
   LI_RECNO   := { | a | LI_TEKZP }
   LI_BGOTO   := { | a, n | LI_TEKZP := n }
   LI_PRFLT   := LI_LVIEW := LI_LADD := LI_UPDATED := .F.
   LI_LSOHR   := .T.
   LI_BDESHIN := LI_BDESHOUT := LI_MSF := LI_MSTYP := LI_MSREC := Nil
   LI_SEPARATOR := " "
RETURN mslist

*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
*+    Procedure ARSKIP()
*+
*+    Called from ( procared.prg )   1 - function initaredit()
*+
*+北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
*+
PROCEDURE ARSKIP( mslist, kolskip )

LOCAL tekzp1
   IF LI_KOLZ != 0
      tekzp1   := LI_TEKZP
      LI_TEKZP += kolskip + IIF( tekzp1 = 0, 1, 0 )
      IF LI_TEKZP < 1
         LI_TEKZP := 0
      ELSEIF LI_TEKZP > LI_KOLZ
         LI_TEKZP := LI_KOLZ + 1
      ENDIF
   ENDIF
RETURN

*+ EOF: PROCARED.PRG
