
#include <clip-gtk2.ch>


function main ( cimg )

	local window, pixbuf
	local pxb_width, pxb_height
	local da, btn, vbox

	if( ! file( cimg ) )
		? "Use : test <imagefile>"
		?
quit
	endif

        gtk_init()
        gdk_rgbinit()


	pixbuf := gdk_pixbufNewFromFile( cimg )
	if( pixbuf == nil )
		? "Error cargando fichero, " + cimg
		?
quit
	endif

        pxb_width := gdk_PixbufGetWidth( pixbuf )
	pxb_height := gdk_PixbufGetHeight( pixbuf )



        window = gtk_windowNew(,"Test pixbuf")
        gtk_widgetSetSizeRequest (window, pxb_width, pxb_height)
        //gtk_windowSetPolicy(window, .f., .f., .t.)

        gtk_signalConnect( window, "delete-event", { |wid,e| gtk_widgetDestroy(wid),gtk_quit() } )


        da = gtk_drawingAreaNew()
        gtk_signalConnect( da, "expose-event",;
                            { | wid, ev | event_expose_darea(wid,ev,pixbuf)} )

	btn := gtk_buttonNew(, "Quit", "_Q" )
	gtk_signalConnect( btn, GTK_CLICKED_SIGNAL, { || gtk_widgetDestroy(window), gtk_quit()} )

	vbox := gtk_vboxNew()
	gtk_containerAdd(window, vbox )
        gtk_boxPackStart(vbox, da, .t., .t. )
	gtk_boxPackEnd( vbox, btn )


        gtk_widgetShowAll(window)
        gtk_main()

return 0


static procedure event_expose_darea( widget, event, pixb )
local dest, style, width, height

  gdk_WindowSetBackPixmap (widget, NIL, .F.)

  dest = gdk_PixbufNew (, .F., 8, event:area:width, event:area:height)
  style := gtk_widgetGetStyle( widget )

  gtk_WidgetGetSize(widget, @width, @height)
  gdk_PixbufCompositeColor (pixb, dest, ;
                            0, 0, event:area:width, event:area:height, ;
                            -event:area:x, -event:area:y, ;
                            width / gdk_PixbufGetWidth (pixb), ;
                            height / gdk_PixbufGetHeight (pixb), ;
                            GDK_INTERP_BILINEAR, 255, ;
                            event:area:x, event:area:y, 16, 0xaaaaaa, 0x555555)

  gdk_PixbufRenderToDrawable (dest, widget, style:fg_gc[CLIP_GTK_STATE_NORMAL], ;
                              0, 0, event:area:x, event:area:y, ;
                              event:area:width, event:area:height, ;
                              GDK_RGB_DITHER_NORMAL, event:area:x, event:area:y)

  gdk_PixbufUnref (dest)

return


