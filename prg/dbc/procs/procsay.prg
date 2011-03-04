/*
 * Common procedures
 *
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
STATIC y__size := 0, x__size := 0

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function WndOut()
*+
*+    Called from ( procscri.prg )   4 - function rdscript()
*+                                   1 - function doscript()
*+                                   1 - function wndget()
*+                                   1 - function wndopen()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION WndOut( sout, noscroll, prnew )
LOCAL y1, x1, y2, x2, oldc, ly__size := (y__size != 0)
STATIC w__buf
   IF sout == Nil .AND. !ly__size
      Return Nil
   ENDIF
   IF y__size == 0
      y__size := 5
      x__size := 30
      prnew   := .T.
   ELSEIF prnew == Nil
      prnew := .F.
   ENDIF
   y1 := 13 - INT( y__size / 2 )
   x1 := 41 - INT( x__size / 2 )
   y2 := y1 + y__size
   x2 := x1 + x__size
   IF sout == Nil 
      RESTSCREEN( y1, x1, y2, x2, w__buf )
      y__size := 0
   ELSE
      oldc := SETCOLOR( "N/W" )
      IF prnew
         w__buf := SAVESCREEN( y1, x1, y2, x2 )
         @ y1, x1, y2, x2 BOX "┌─┐│┘─└│ "
      ELSEIF noscroll = Nil
         SCROLL( y1 + 1, x1 + 1, y2 - 1, x2 - 1, 1 )
      ENDIF
      @ y2 - 1, x1 + 2 SAY sout         
      SETCOLOR( oldc )
   ENDIF
RETURN Nil

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function WndGet()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION WndGet( sout, varget, spict )

LOCAL y1, x1, y2, x2, oldc
LOCAL GetList := {}
   WndOut( sout )
   y1   := 13 - INT( y__size / 2 )
   x1   := 41 - INT( x__size / 2 )
   y2   := y1 + y__size
   x2   := x1 + x__size
   oldc := SETCOLOR( "N/W" )
   IF LEN( sout ) + IIF( spict = "@D", 8, LEN( spict ) ) > x__size - 3
      SCROLL( y1 + 1, x1 + 1, y2 - 1, x2 - 1, 1 )
   ELSE
      x1 += LEN( sout ) + 1
   ENDIF
   @ y2 - 1, x1 + 2 GET varget PICTURE spict        
   READ
   SETCOLOR( oldc )
RETURN IIF( LASTKEY() = 27, Nil, varget )

*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
*+    Function WndOpen()
*+
*+▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
*+
FUNCTION WndOpen( ysize, xsize )

   y__size := ysize
   x__size := xsize
   WndOut( "",, .T. )
RETURN Nil
