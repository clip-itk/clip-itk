/*
    Copyright (C) 2004  ITK
    Author  : Elena Kornilova <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html

    Test zoom images with using gdk-pixbuf
*/

#define _OFFSET_	0.25
#include <clip-gtk.ch>

static da, back, background, pixbuf, pixbuf1, offset:=1, lInc:=.f.
static _width, _height, window

function main ( )

	local vbox, hbox, inc, dec


	gtk_init()
	gdk_rgbinit()


	pixbuf := gdk_pixbufNewFromFile( "gnome-gmush.jpg" )
	_width  := gdk_PixbufGetWidth(pixbuf)
	_height := gdk_PixbufGetHeight(pixbuf)
	pixbuf1 := gdk_pixbufNew(, .f., 8, _width, _height)
	gdk_pixbufCopyArea( pixbuf, 0, 0, _width, _height, ;
			      pixbuf1, 0, 0)

	window = gtk_windowNew(,"Test image zooming")
	gtk_widgetSetSize (window, 200, 200)
	gtk_windowSetPolicy(window, .f., .f., .t.)

	gtk_signalConnect( window, "delete-event", { |wid,e| gtk_widgetDestroy(wid),gtk_quit() } )

	vbox := gtk_vboxNew()
	hbox := gtk_hboxNew()

	btn := gtk_buttonNew(, "&Quit", "&" )
	gtk_WidgetAddAccelerator(btn, GTK_CLICKED_SIGNAL, window, ;
	btn:AccelKey, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)
	gtk_signalConnect( btn, GTK_CLICKED_SIGNAL, { || gtk_widgetDestroy(window), gtk_quit()} )

	da := gtk_drawingAreaNew()
	gtk_DrawingAreaSize (da, _width, _height)
	gtk_signalConnect( da, "configure-event", ;
			    { | wid, ev | configure_cb(wid,ev)} )
	gtk_signalConnect( da, "expose-event", ;
			    { | wid, ev | expose_cb(wid,ev)} )


	inc := gtk_buttonNew(, "&Inc", "&" )
	gtk_WidgetAddAccelerator(inc, GTK_CLICKED_SIGNAL, window, ;
	inc:AccelKey, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)
	gtk_SignalConnect(inc, "clicked", {||myincrement()})
	dec := gtk_buttonNew(, "&Dec", "&" )
	gtk_WidgetAddAccelerator(dec, GTK_CLICKED_SIGNAL, window, ;
	dec:AccelKey, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)
	gtk_SignalConnect(dec, "clicked", {||mydecrement()})
	gtk_boxPackStart(hbox, btn, .t., .t.)
	gtk_boxPackStart(hbox, inc, .t., .t.)
	gtk_boxPackStart(hbox, dec, .t., .t.)

	gtk_boxPackStart(vbox, da, .t., .t.)
	gtk_boxPackEnd(vbox, hbox)
	gtk_containerAdd(window, vbox )

	gtk_widgetShowAll(window)
	gtk_main()

return 0
static function expose_cb( widget, event, data )

	local pixels, rowstride, style

	rowstride := gdk_pixbufGetRowstride (pixbuf1)

	style := gtk_widgetGetStyle( widget )
	pixels = gdk_pixbufGetPixels(pixbuf1)


	gdk_drawRgbImageDithalign(widget, ;
		style:black_gc, ;
		0, 0, ;
		gdk_PixbufGetWidth(pixbuf1), gdk_PixbufGetHeight(pixbuf1), ;
		GDK_RGB_DITHER_NORMAL, ;
		pixels, rowstride, ;
		0, 0)

return( .t. )	// expose_cb()

static function configure_cb( widget, event, data )

	if lInc
		offset := iif(offset<=0, _OFFSET_, offset)
		pixbuf1 := gdk_pixbufScaleSimple( pixbuf,  _width*offset, ;
			_height*offset,GDK_INTERP_BILINEAR )
		lInc := .f.
	endif
	? "picture size", offset, gdk_PixbufGetWidth(pixbuf1), gdk_PixbufGetHeight(pixbuf1)
	?

return( .t. )	// configure_cb()

static function myincrement()
	offset += _OFFSET_
	lInc := .t.
	gtk_SignalEmit(da, "configure-event")
	gtk_SignalEmit(da, "expose-event")

return .t.

static function mydecrement()
	offset -= _OFFSET_
	lInc := .t.
	gtk_SignalEmit(da, "configure-event")
	gtk_SignalEmit(da, "expose-event")
	gtk_SignalEmit(da, "draw")
return .t.

