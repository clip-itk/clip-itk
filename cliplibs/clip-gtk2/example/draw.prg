// Drawing primitives
/*
File Name  : DRAW.PRG

Description: Drawing different grphical primitives - lines, points, segments,
arc...

*/
#include <clip-gtk2.ch>

#define TRUE	.T.
#define FALSE 	.F.
STATIC DC, oWnd, nCount := 0, nColor := 0
STATIC lineStyle := 0, capStyle := GDK_CAP_NOT_LAST
STATIC joinStyle := GDK_JOIN_MITER, fillStyle := GDK_SOLID, widthLine


//-------------------------------------------------------------//

FUNCTION Main()
local vbox

   gtk_init()
   oWnd := gtk_WindowNew(, " Draving Primitives ")
   gtk_WindowSetPosition(oWnd, GTK_WIN_POS_CENTER)
   gtk_WindowSetDefaultSize(oWnd, 800, 500)
   gtk_signalConnect(oWnd, "delete-event", {|w| gtk_quit()})

   vbox := gtk_VBoxNew()
   gtk_BoxPackStart( vbox, BuildMenu())

   DC := gtk_DrawingAreaNew()
   DC:PIXMAP = NIL

   gtk_SignalConnect(DC, "configure-event", {|wid, ev| configure(wid, ev)})
   gtk_SignalConnect(DC, "expose-event", {|wid, ev| expose(wid, ev)})

   gtk_BoxPackStart( vbox, DC)

   gtk_ContainerAdd(oWnd, vbox)

   gtk_WidgetShowAll(oWnd)
   gtk_main()

RETURN( 0 )

//-------------------------------------------------------------//

FUNCTION BuildMenu()
   LOCAL oMenu, oPopup, o, o1

	oMenu := gtk_MenuBarNew()
	oPopup := gtk_MenuNew()

	o := gtk_MenuItemNew( , "Tasks" )

	o1 := gtk_MenuItemNew( , "_Lines", "_" )
	gtk_SignalConnect(o1, "activate", {|| Lines()})
	gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_MenuItemNew( , "_Segments", "_" )
	gtk_SignalConnect(o1, "activate", {|| Segments()})
	gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_MenuItemNew( , "_Rectangle", "_" )
	gtk_SignalConnect(o1, "activate", {|| Rectangle(.f.)})
	gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_MenuItemNew( , "Filled R_ectangle", "_" )
	gtk_SignalConnect(o1, "activate", {|| Rectangle(.t.)})
	gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_MenuItemNew( , "_Arc", "_" )
	gtk_SignalConnect(o1, "activate", {|| Arc(.f.)})
	gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_MenuItemNew( , "Filled Arc" )
	gtk_SignalConnect(o1, "activate", {|| arc(.t.)})
	//gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
        // o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_MenuItemNew( , "Pango Text" )
	gtk_SignalConnect(o1, "activate", {|| PangoText()})
	//gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
        // o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_MenuItemNew( , "_Image", "_" )
	gtk_SignalConnect(o1, "activate", {|| Image()})
	gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
         o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_SeparatorMenuItemNew( )
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_MenuItemNew( , "_Clear", "_" )
	gtk_SignalConnect(o1, "activate", {|| Clear()})
	gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_MenuItemNew( , "C_olor", "_" )
	gtk_SignalConnect(o1, "activate", {|| NewColor()})
	gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	o1 := gtk_MenuItemNew( , "E_xit", "_" )
	gtk_SignalConnect(o1, "activate", {|| gtk_Quit()})
	gtk_WidgetAddAccelerator(o1, GTK_ACTIVATE_SIGNAL, oWnd, ;
                         o1:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)
	gtk_MenuAppend( oPopup, o1 )

	gtk_MenuItemSetSubmenu(o, oPopup)
	gtk_MenuBarAppend( oMenu, o )


RETURN( oMenu )

//-------------------------------------------------------------//

STATIC PROCEDURE Clear()
   nCount := 0
   Refresh()
RETURN

//-------------------------------------------------------------//
STATIC PROCEDURE NewColor()
   LOCAL nOldColor := nColor

   IF ( nColor := ChooseColor() ) == -1
      nColor := nOldColor
   ENDIF
RETURN

//-------------------------------------------------------------//

STATIC FUNCTION Lines(  )
   LOCAL n, hPen

   hPen := CreatePen( widthLine, nColor )
   DC:hPen := hPen

   gdk_DrawLines(DC:PIXMAP, hPen, ;
   	{{10, 20},{100, 200},{100, 200}, {200, 300}, {200, 300}, {10, 20}} )
   gtk_ObjectDestroy( hPen )

   gtk_WidgetDraw(DC)
   gtk_WidgetShowAll(Dc)

RETURN

//-------------------------------------------------------------//

STATIC PROCEDURE Segments(  )
   LOCAL n, hPen

   hPen := CreatePen( widthLine, nColor )
   DC:hPen := hPen

   gdk_DrawSegments(DC:PIXMAP, hPen, ;
   	{{200, 220, 300, 400}, {300, 400, 500, 200}, {500, 200, 100, 100}})
   gtk_ObjectDestroy( hPen )

   gtk_WidgetDraw(DC)
   gtk_WidgetShowAll(Dc)

RETURN

STATIC PROCEDURE Rectangle( lFilled )
   LOCAL n, hPen

   hPen := CreatePen( widthLine, nColor )
   DC:hPen := hPen

   gdk_DrawRectangle(DC:PIXMAP, hPen, lFilled,;
   	500, 300, 700, 400)
   gtk_ObjectDestroy( hPen )

   gtk_WidgetDraw(DC)
   gtk_WidgetShowAll(Dc)

RETURN

STATIC PROCEDURE Arc( lFilled )
   LOCAL n, hPen

   hPen := CreatePen( widthLine, nColor )
   DC:hPen := hPen

   gdk_DrawArc(DC:PIXMAP, hPen, lFilled,;
   	500, 100, 200, 150, 0, 360*64)
   gtk_ObjectDestroy( hPen )

   gtk_WidgetDraw(DC)
   gtk_WidgetShowAll(Dc)

RETURN


STATIC FUNCTION PangoText( )
   LOCAL n, hPen, label, pango, fg := map(), bg := map()

   hPen := CreatePen( widthLine, nColor )
   DC:hPen := hPen

   label := gtk_LabelNew()
   pango := gtk_WidgetCreatePangoLayout(label, "Pango Text Pango Text")
   PangoLayoutSetFontDescription(pango, "Arial Italic 16")
   /* without color */
   gdk_DrawLayoutLine(DC:PIXMAP, hPen, ;
   	50, 70, PangoLayoutGetLine(pango,1))
   /* with colors backgrpud and foregroud */

   label := gtk_LabelNew()
   pango := gtk_WidgetCreatePangoLayout(label, "Color pango: red foregroud & green background")
   PangoLayoutSetFontDescription(pango, "Times Bold 24")
   fg:RED := 63333
   fg:GREEN := 3000
   fg:BLUE := 5666
   bg:RED := 0
   bg:GREEN := 65535
   bg:BLUE := 0
   gdk_DrawLayoutLineWithColors(DC:PIXMAP, hPen, ;
   	100, 170, PangoLayoutGetLine(pango,1), fg, bg)
   gtk_ObjectDestroy( hPen )

   gtk_WidgetDraw(DC)
   gtk_WidgetShowAll(Dc)

RETURN

STATIC FUNCTION Image( )
   LOCAL n, hPen, img, gdkImage, mask, width, height

   hPen := CreatePen( widthLine, nColor )
   DC:hPen := hPen


   image := gtk_ImageNewFromFile(, "./gdk-pixbuf-demo/background.jpg")
   gtk_WidgetGetSize(image, @width, @height)

   gdk_DrawDrawable(DC:PIXMAP, hPen, ;
   	image, 0, 0, 0, 0, width, height)
   gtk_ObjectDestroy( hPen )

   gtk_WidgetDraw(DC)
   gtk_WidgetShowAll(Dc)

RETURN


//-------------------------------------------------------------//

STATIC PROCEDURE Refresh()

	if !empty(DC)
		gtk_SignalEmit(DC, 'configure-event')
        endif
   gtk_WidgetDraw(DC)
   gtk_WidgetShowAll(Dc)
RETURN
//-------------------------------------------------------------//
STATIC FUNCTION expose(oDC, oEvent)
local pixmap, rect, style

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

	nWidth := 800
        nHeight := 500
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

