#include <clip-gtk.ch>

local nW, nH, style, w, da
local blue,yellow,red,magenta, sx, sy
local green:=nil, pixel:=nil

//static pixmap
local pixmap

set(_SET_MAPERR,.T.)
gtk_init()

w := gtk_windowNew(, 'Testing window')
gtk_WIdgetSetPosition(w, 100, 100)
gtk_WidgetSetSize(w, 300, 300)
gtk_WidgetRealize(w)

gtk_WidgetShowAll(w)

//style := map()
//style:fg_gc := {gdk_GCNew(,w)}
//gtk_WidgetSetStyle(w, style)
for i=1 to 10000
	qout(i)
	style := gtk_WidgetGetStyle(w, i)
	//gtk_WidgetSetStyle(w, style)
//	gtk_ObjectDestroy(style)
next

qout()
gtk_main()
return




style := gtk_WidgetGetStyle(w)
style:bg_gc := {gdk_GCNew(, w)}
style:fg_gc := {gdk_GCNew(, w)}
gcv := gdk_GCGetValues(style:fg_gc[1])
qout('gcv=', gcv, "&\n")
qout("1. LineWidth=",gcv:LineWidth)
style:fg_gc[1]:_NAME_:="window style:FG_GC[1]"
style:colormap := gdk_ColormapGetSystem()
//gtk_WidgetSetStyle(w,style)


blue    := gdk_ColorParse('blue')
yellow  := gdk_ColorParse('yellow')
red     := gdk_ColorParse('red')
magenta := gdk_ColorParse('magenta')
green	:= gdk_ColorParse('green')
gdk_ColormapAllocColor(style:colormap, blue)
gdk_ColormapAllocColor(style:colormap, yellow)
gdk_ColormapAllocColor(style:colormap, red)
gdk_ColormapAllocColor(style:colormap, magenta)
gdk_ColormapAllocColor(style:colormap, green)
qout('blue:',blue)
style:fg_color[1]:=green
style:bg_color[1]:=red
qout('style:fg_color[1]=',style:fg_color[1])

gdk_GCSetBackground(style:bg_gc[1], blue  )
gdk_GCSetForeground(style:bg_gc[1], yellow)

gdk_GCSetBackground(style:fg_gc[1], red    )
gdk_GCSetForeground(style:fg_gc[1], magenta)

gdk_GCSetLineAttributes(style:fg_gc[1], 5)

gtk_WidgetSetStyle(w, style)
gcv := gdk_GCGetValues(style:fg_gc[1])
qout("11. LineWidth=",gcv:LineWidth)
qout('gcv=', gcv, "&\n")

//	qout('1',gtk_WidgetGetStyle(w):fg_gc[1]:_NAME_)

style := gtk_WidgetGetStyle(w)
gcv:=gdk_GCGetValues(style:fg_gc[1])
qout("2. LineWidth=",gcv:LineWidth)
qout('gcv=', gcv, "&\n")
qout('style:fg_color[1]=',style:fg_color[1])
	qout('2',gtk_WidgetGetStyle(w):fg_gc[1]:_NAME_)

gtk_WidgetShowAll(w)
nW := 0; nH := 0
gtk_WidgetGetSize(w, @nW, @nH)
da := gtk_DrawingAreaNew(, w)
gtk_WidgetSetName(w, "main window")
gtk_WidgetSetName(da, "drawing area")
da:hWnd := da:handle
da:pWnd := w:handle

gdk_ColormapAllocColor(style:colormap, blue)
gdk_ColormapAllocColor(style:colormap, yellow)
gdk_ColormapAllocColor(style:colormap, red)
gdk_ColormapAllocColor(style:colormap, magenta)

gtk_WidgetSetStyle(da, style)
style := gtk_WidgetGetStyle(da)
	qout('3',gtk_WidgetGetStyle(da):fg_gc[1]:_NAME_)

//pixmap:=map()
qout('set size for da nW=', nw, nh)
gtk_DrawingAreaSize(da, nW, nH)

qout("fg_color[1]",style:fg_color[1])
qout('***&\n')
//gtk_SignalConnect(da, 'configure-event', {|widg, ev| configure_event(widg, ev)})
//gtk_SignalConnect(da, 'expose-event', {|widg, ev| expose_event(widg, ev)})
gtk_SignalConnect(da, 'configure-event', @configure_event())
gtk_SignalConnect(da, 'expose-event', @expose_event())
gtk_WidgetSetEvents (da, numOr(GDK_EXPOSURE_MASK, ;
			       GDK_LEAVE_NOTIFY_MASK, ;
			       GDK_BUTTON_PRESS_MASK, ;
			       GDK_POINTER_MOTION_MASK, ;
			       GDK_POINTER_MOTION_HINT_MASK))


gtk_SignalConnect(w, 'delete-event', {|| gtk_quit()})
qout("fg_color[1]",style:fg_color[1])
qout('***')



la := gtk_LayoutNew()
gtk_LayoutPut(la, da, 0, 0)

gtk_WidgetAddEvents(la, GDK_BUTTON_PRESS_MASK+GDK_BUTTON_RELEASE_MASK+GDK_POINTER_MOTION_MASK)
x:=0; y:=0
gtk_SignalConnect(la, "button-press-event", {|| gdk_WindowGetPointer(la, @x, @y)})

gtk_ContainerAdd(w, la)
//gtk_ContainerAdd(w, da)

gtk_WidgetShowAll(w)

	qout('4',style:fg_gc[1]:_NAME_)
gtk_main()

return

function configure_event(oDC, oEvent)
local nWidth, nHeight, style
	qout("Configure Event")
	nWidth := 0; nHeight := 0
	gtk_WidgetGetSize(oDC:hWnd, @nWidth, @nHeight)

	style := gtk_WidgetGetStyle(oDC)
	//if "_NAME_"$style:fg_gc[1]
	qout(Style:fg_gc[1]:_NAME_)
	gcv:=gdk_GCGetValues(style:fg_gc[1])
	qout("3. LineWidth=",gcv:LineWidth)
	qout(style:fg_color[1])


	if "PIXMAP"$oDC .and. oDC:pixmap != NIL
		gtk_WidgetDestroy(oDC:pixmap)
	endif
	oDC:pixmap := gtk_PixmapNew(,oDC:pWnd, nWidth, nHeight)

	/*
	if pixmap!=NIL
		gtk_WidgetDestroy(pixmap)
	endif
	pixmap := gtk_PixmapNew(,oDC:pWnd, nWidth, nHeight)
	*/
	gdk_DrawRectangle (oDC:pixmap, ;
			    style:bg_gc[1], ;
			    .t., ;
			    0, 0, ;
			    nWidth,;
			    nHeight)
	gdk_DrawLine(oDC:pixmap, style:fg_gc[1], 20, 20, 120, 120)
	gc := gdk_GCNew(, oDC:pWnd)
	gdk_GCSetLineAttributes(gc, 5)
	//gdk_DrawLine(/*oDC:*/pixmap, gc, 20, 20, 120, 120)

return
function expose_event(oDC, oEvent)
local style
	qout("Expose event")
	style := gtk_WidgetGetStyle(oDC)

	gdk_DrawPixmap(oDC, ;
		style:fg_gc[GTK_WIDGET_STATE(oDC)+1], ;
		oDC:pixmap, ;
		oEvent:area:x, oEvent:area:y, ;
		oEvent:area:x, oEvent:area:y, ;
		oEvent:area:width, oEvent:area:height)

return

