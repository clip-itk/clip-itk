// Drawing lines and some management colors                     ß
/*
File Name  : LINES.PRG

Description: Drawing lines and some management colors

*/
#include <clip-gtk2.ch>
/* Pen Styles */
#define PS_SOLID                          0
#define PS_DASH                           1
#define PS_DOT                            2
#define PS_DASHDOT                        3
#define PS_DASHDOTDOT                     4
#define PS_NULL                           5
#define PS_INSIDEFRAME                    6

#define TRUE	.T.
#define FALSE 	.F.

STATIC aPoints, nCount, nColor := 0, oWnd
STATIC DCPoints := map(), lineStyle := PS_SOLID, capStyle := GDK_CAP_NOT_LAST
STATIC joinStyle := GDK_JOIN_MITER, fillStyle := GDK_SOLID, widthLine

//-------------------------------------------------------------//

FUNCTION Main()

   aPoints := array( 1000 )
   nCount  := 0

   gtk_init()
   oWnd := gtk_WindowNew(, "FiveWin - Click the mouse over the window")
   gtk_WindowSetPosition(oWnd, GTK_WIN_POS_CENTER)
   gtk_WindowSetDefaultSize(oWnd, 500, 300)
   gtk_signalConnect(oWnd, "delete-event", {|w| gtk_quit()})
   oWnd:VBOX := gtk_VboxNew()
   oWnd:HBOX := gtk_HboxNew()
   gtk_ContainerAdd(oWnd, oWnd:VBOX)
   gtk_BoxPackStart( oWnd:VBOX, oWnd:HBOX )

   gtk_BoxPackStart( oWnd:HBOX, BuildMenu())

   oWnd:WIDTHLINE := gtk_ComboBoxNewText()
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width Line 0" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 1" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 2" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 3" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 4" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 5" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 6" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 7" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 8" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 9" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 10" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 11" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 12" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 13" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 14" )
   gtk_ComboBoxAppendText( oWnd:WIDTHLINE, "Width line 15" )
   gtk_ComboBoxSetActive( oWnd:WIDTHLINE, 1 )
   gtk_SignalConnect( oWnd:WIDTHLINE, "changed", {|w| widthLine := gtk_ComboBoxGetActive(w)-1} )
   gtk_BoxPackStart( oWnd:HBOX, oWnd:WIDTHLINE )

   oWnd:LINESTYLE := gtk_ComboBoxNewText()
   gtk_ComboBoxAppendText( oWnd:LINESTYLE, "Line Solid" )
   gtk_ComboBoxAppendText( oWnd:LINESTYLE, "Line on of Dash" )
   gtk_ComboBoxAppendText( oWnd:LINESTYLE, "Line Doble Dash" )
   gtk_ComboBoxSetActive( oWnd:LINESTYLE, 1 )
   gtk_SignalConnect( oWnd:LINESTYLE, "changed", {|w| lineStyle := gtk_ComboBoxGetActive(w)-1} )
   gtk_BoxPackStart( oWnd:HBOX, oWnd:LINESTYLE )

   oWnd:CAPSTYLE := gtk_ComboBoxNewText()
   gtk_ComboBoxAppendText( oWnd:CAPSTYLE, "Cap Not Last" )
   gtk_ComboBoxAppendText( oWnd:CAPSTYLE, "Cap Butt" )
   gtk_ComboBoxAppendText( oWnd:CAPSTYLE, "Cap Round" )
   gtk_ComboBoxAppendText( oWnd:CAPSTYLE, "Cap Projecting" )
   gtk_ComboBoxSetActive( oWnd:CAPSTYLE, 1 )
   gtk_SignalConnect( oWnd:CAPSTYLE, "changed", {|w| capStyle := gtk_ComboBoxGetActive(w)-1} )
   gtk_BoxPackStart( oWnd:HBOX, oWnd:CAPSTYLE )

   oWnd:JOINSTYLE := gtk_ComboBoxNewText()
   gtk_ComboBoxAppendText( oWnd:JOINSTYLE, "Join Mitter" )
   gtk_ComboBoxAppendText( oWnd:JOINSTYLE, "Join Round" )
   gtk_ComboBoxAppendText( oWnd:JOINSTYLE, "Join Bevel" )
   gtk_ComboBoxSetActive( oWnd:JOINSTYLE, 1 )
   gtk_SignalConnect( oWnd:JOINSTYLE, "changed", {|w| joinStyle := gtk_ComboBoxGetActive(w)-1} )
   gtk_BoxPackStart( oWnd:HBOX, oWnd:JOINSTYLE )

   oWnd:FILLSTYLE := gtk_ComboBoxNewText()
   gtk_ComboBoxAppendText( oWnd:FILLSTYLE, "Fill Solid" )
   gtk_ComboBoxAppendText( oWnd:FILLSTYLE, "Fill Tiled" )
   gtk_ComboBoxAppendText( oWnd:FILLSTYLE, "Fill Stippled" )
   gtk_ComboBoxAppendText( oWnd:FILLSTYLE, "Fill Opaque Stippled" )
   gtk_ComboBoxSetActive( oWnd:FILLSTYLE, 1 )
   gtk_SignalConnect( oWnd:FILLSTYLE, "changed", {|w| fillStyle := gtk_ComboBoxGetActive(w)-1} )
   gtk_BoxPackStart( oWnd:HBOX, oWnd:FILLSTYLE )


   oWnd:SWND := gtk_ScrolledWindowNew()
   gtk_ScrolledWindowSetPlacement(oWnd:SWND, GTK_CORNER_TOP_LEFT)
   gtk_BoxPackStart( oWnd:VBOX, oWnd:SWND, .t., .t. )

   oWnd:CLIENT := gtk_LayoutNew()
   gtk_WidgetSetSizeRequest(oWnd:CLIENT, 1000, 1000)
   //gtk_SignalConnect(oWnd, 'size-request', {|w, e| CoorsUpdate()})

   gtk_WidgetAddEvents(oWnd:CLIENT, GDK_BUTTON_PRESS_MASK+GDK_BUTTON_RELEASE_MASK+GDK_POINTER_MOTION_MASK)
   gtk_SignalConnect(oWnd:CLIENT, "button-press-event", {|| bpress()})
   gtk_ScrolledWindowAddWithViewport( oWnd:SWND, oWnd:CLIENT )

   oWnd:DC := gtk_DrawingAreaNew()
   oWnd:DC:PIXMAP := NIL
   gtk_SignalConnect(oWnd:DC, "configure-event", {|wid, ev| configure(wid, ev)})
   gtk_SignalConnect(oWnd:DC, "expose-event", {|wid, ev| expose(wid, ev)})
   gtk_LayoutPut(oWnd:CLIENT, oWnd:DC)


   gtk_WidgetShowAll(oWnd)
   gtk_main()

RETURN( 0 )

//-------------------------------------------------------------//

STATIC FUNCTION CoorsUpdate()
LOCAL x, y, x1, y1
	gtk_WidgetGetSize(oWnd, @x, @y)
	gtk_WidgetGetSize(oWnd:CLIENT, @x1, @y1)
	if x <> x1 .or. y <> y1
		gtk_WidgetSetSizeRequest(oWnd:CLIENT, x, y)
        endif
RETURN

//-------------------------------------------------------------//

FUNCTION BuildMenu()
   LOCAL oMenu, oPopup, o, o1, o2, o3, o4

	oMenu := gtk_MenuBarNew()
	oPopup := gtk_MenuNew()

	o := gtk_MenuItemNew( , "Tasks" )

	o1 := gtk_MenuItemNew( , "Clea_r", "_" )
	gtk_SignalConnect(o1, "activate", {|| Clear()})
	gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	o2 := gtk_MenuItemNew( , "_Undo", "_" )
	gtk_SignalConnect(o2, "activate", {|| Undo()})
	gtk_WidgetAddAccelerator(o2, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o2:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	o3 := gtk_MenuItemNew( , "_Color", "_" )
	gtk_SignalConnect(o3, "activate", {|| NewColor()})
	gtk_WidgetAddAccelerator(o3, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o3:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	o4 := gtk_MenuItemNew( , "E_xit", "_" )
	gtk_SignalConnect(o4, "activate", {|| gtk_Quit()})
	gtk_WidgetAddAccelerator(o4, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o4:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)

	gtk_MenuAppend( oPopup, o1 )
	gtk_MenuAppend( oPopup, o2 )
	gtk_MenuAppend( oPopup, o3 )
	gtk_MenuAppend( oPopup, o4 )


	gtk_MenuItemSetSubmenu(o, oPopup)
	gtk_MenuBarAppend( oMenu, o )


RETURN( oMenu )

//-------------------------------------------------------------//

STATIC FUNCTION bpress()
LOCAL x, y
	gdk_WindowGetPointer(oWnd:CLIENT, @x, @y)
        Click(y, x)
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE Clear()
   nCount := 0
   Refresh()
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE Undo()
   IF nCount > 0
      nCount--
      Refresh()
   ENDIF
   MiPaint()
RETURN

//-------------------------------------------------------------//
STATIC PROCEDURE NewColor()
   LOCAL nOldColor := nColor

   IF ( nColor := ChooseColor() ) == -1
      nColor := nOldColor
   ENDIF
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE Click( x, y )
   aPoints[ ++nCount ] := { y, x }
   DrawLine( x, y )
   //Refresh()
   gtk_WidgetDraw(oWnd)
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE DrawLine( x, y )
   LOCAL n, hPen, hOldPen

   hPen := CreatePen( widthLine, nColor )
   oWnd:DC:hPen := hPen
   //hOldPen := SelectObject( oWnd:DC, hPen )

   FOR n := 1 to nCount - 1
      MoveTo( oWnd:DC:Handle, aPoints[ n, 1 ], aPoints[ n, 2 ] )
      LineTo( oWnd:DC:Handle, y, x )
   NEXT

   //SelectObject( oWnd:Dc, hOldPen )
   gtk_ObjectDestroy( hPen )

   /*
   gtk_WidgetDraw(oWnd)
   if !empty(oWnd:DC)
   	gtk_WidgetShowAll(oWnd:DC)
   endif
   gtk_WidgetShowAll(oWnd)
   */
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE MiPaint()
   LOCAL n

   FOR n := 1 to nCount
      DrawLine( aPoints[n, 2], aPoints[n, 1] )
   NEXT
RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE Refresh()

	if !empty(oWnd:DC)
		gtk_SignalEmit(oWnd:DC, 'configure-event')
        endif
        gtk_WidgetDraw(oWnd)
RETURN
//-------------------------------------------------------------//
STATIC FUNCTION expose(oDC, oEvent)
local pixmap, oWnd, rect, style

	style := gtk_WidgetGetStyle(oDC)

	gdk_DrawPixmap(oDC, ;
		style:fg_gc[GTK_WIDGET_STATE(oDC)+1], ;
		oDC:pixmap, ;
		oEvent:area:x, oEvent:area:y, ;
		oEvent:area:x, oEvent:area:y, ;
		oEvent:area:width, oEvent:area:height)

return( TRUE )	// expose()
//-------------------------------------------------------------//

STATIC FUNCTION configure(oDC, ev)
local nWidth, nHeight, style, nWDC, nHDC

	style := gtk_WidgetGetStyle(oDC)

	/*
	if "PIXMAP"$oDC .and. !empty(oDC:PIXMAP)
		gtk_WidgetDestroy(oDC:PIXMAP)
	endif

	gtk_WidgetGetSize(oWnd, @nWidth, @nHeight)
	gtk_WidgetGetSize(oDC, @nWDC, @nHDC)

	nWidth := 1000
        nHeight := 1000
	if nWidth != nWDC .or. nHeight != nHDC
		gtk_DrawingAreaSize(oDC, nWidth, nHeight)
	endif

	oDC:PIXMAP := gdk_PixmapNew ( , oWnd, nWidth, nHeight)
        */
	nWidth := 1000
        nHeight := 1000
	if "PIXMAP"$oDC .and. empty(oDC:PIXMAP)
		gtk_DrawingAreaSize(oDC, nWidth, nHeight)

		oDC:PIXMAP := gdk_PixmapNew ( , oWnd, nWidth, nHeight)
        endif

	gdk_DrawRectangle (oDC:PIXMAP, ;
	    style:bg_gc[1], ;
	    .t., ;
	    0, 0, ;
	    nWidth,;
	    nHeight)
        MiPaint()
return


//-------------------------------------------------------------//

STATIC FUNCTION CreatePen( nWidth, nRGBColor)
local gc, bgColor, style
	gc := gdk_GCNew(, oWnd)

	bgColor := gdk_ColorRGB(nRGBColor)
	gdk_GCSetRGBFgColor(gc, bgColor)
	gdk_GCSetRGBBgColor(gc, bgColor)

	gdk_GCSetFill(gc, fillStyle)

	gdk_GCSetTile(gc, gdk_PixmapFromXPMNew(, "gnome-foot.xpm", oWnd))

	gdk_GCSetLineAttributes(gc, nWidth, lineStyle, capStyle, joinStyle)
RETURN gc

//-------------------------------------------------------------//

STATIC FUNCTION SelectObject(oDC, hPen)
local hOldObj, style

	if "HPEN"$oDC
		hOldObj := oDC:hPen
	else
		style := gtk_WidgetGetStyle(oDC)
		hOldObj := style:fg_gc[1]
	endif
	oDC:hPen := hPen

RETURN hOldObj

//-------------------------------------------------------------//

STATIC FUNCTION MoveTo(hDC, nRow, nCol)
	DCPoints[hDC] := { nCol, nRow }
RETURN

//-------------------------------------------------------------//

STATIC FUNCTION LineTo(hDC, nRow, nCol)
local lSuccess:=.t., GCPen

	//oDC := gtk_getObjByHandle(hDC)
	GCPen := oWnd:DC:hPen
	gdk_DrawLine(oWnd:DC:PIXMAP, GCPen, DCPoints[hDC][2], DCPoints[hDC][1], nRow, nCol)

RETURN lSuccess

//-------------------------------------------------------------//

STATIC FUNCTION ChooseColor()
local csDialog, ret, retarr

	csDialog:=gtk_ColorSelectionDialogNew(,"Color Selection Dialog window")
	gtk_WindowSetModal(csDialog, .F.)
	gtk_WidgetHide(csDialog:HelpButton)


	gtk_ColorSelectionSetColor(csDialog:ColorSel, gdk_ColorRGB(nColor))
	gtk_SignalConnect(csDialog,"delete-event",{|wid,ev|gtk_WidgetHide(csDialog)})
	gtk_SignalConnect(csDialog:OkButton,"clicked",{|wid,ev| retarr := gtk_ColorSelectionGetColor(csDialog:ColorSel),gtk_WidgetHide(csDialog)})
	gtk_SignalConnect(csDialog:CancelButton,"clicked",{|wid,ev|gtk_WidgetHide(csDialog)})
	gtk_WindowSetTransientFor(csDialog, oWnd)

	gtk_SignalConnect(csDialog, GTK_DELETE, {|| gtk_WidgetHideOnDelete(csDialog)})
	gtk_SignalConnect(csDialog, GTK_HIDE_SIGNAL, {|| gtk_WidgetDestroy(csDialog), gtk_Quit()})


	gtk_WidgetRealize(csDialog)
	gtk_WindowSetFunctions(csDialog, GDK_FUNC_CLOSE)
	gtk_WindowSetDecorations(csDialog, NUMOR(GDK_DECOR_TITLE, GDK_DECOR_BORDER))
	gtk_WidgetShowAll(csDialog)

	gtk_Main()

	if valtype(retarr) != "U"
		nColor := gdk_ColorRGBtoN(retarr)
	else
		nColor := -1
	endif
return nColor

