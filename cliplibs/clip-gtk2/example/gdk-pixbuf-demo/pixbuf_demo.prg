
#include <clip-gtk2.ch>

#define TRUE  .t.
#define FALSE .f.
#define M_PI pi()
#define CYCLE_LEN 60
#define FRAME_DELAY 0.010

static frame
static background
static image_names := { ;
        "apple-red.png",;
        "gnome-applets.png",;
        "gnome-calendar.png",;
        "gnome-foot.png",;
        "gnome-gmush.png",;
        "gnome-gimp.png",;
        "gnome-gsame.png",;
        "gnu-keys.png" 	}

#define N_IMAGES len(image_names)
static images := array(N_IMAGES)
static back_width, back_height	// background sizes.
static da			// drawing area.
static frame_num := 0


function main ( cimagefile )

	local window

	if( cimagefile == nil ); cimagefile := "background.jpg"; endif

	if( ! file( cimagefile ) )
		? "Use : test <imagefile>"
		?
		quit
	endif
        gtk_init()
        gdk_rgbinit()

	if( ! load_pixbufs( cimagefile ) )
                ? "main(): Could not load all the pixbufs!"
		return( 1 )
	endif

        frame := gdk_pixbufNew( , FALSE, 8, back_width, back_height)


        window = gtk_windowNew(,"Pixbuf demo")
        gtk_widgetSetSizeRequest (window, back_width, back_height)
        //gtk_windowSetPolicy(window, .f., .f., .f.)


        da := gtk_drawingAreaNew()

        gtk_signalConnect( da, "expose-event", ;
                            { | wid, ev | expose_cb(wid,ev)} )

        gtk_containerAdd(window, da)

	gtk_widgetShow( da )

	start( @task_time() )


        gtk_widgetShowAll(window)
        gtk_signalConnect( window, "delete-event", ;
		{ |wid,e| gtk_widgetDestroy(wid),gtk_quit() } )

        gtk_main()


return 0	// main()


static function load_pixbufs( background_name )

        local i


        background := gdk_pixbufNewFromFile (background_name)

        if( background == nil )
return FALSE; endif

        back_width := gdk_pixbufGetWidth( background)
        back_height := gdk_pixbufGetHeight (background)

        for i := 1 to N_IMAGES
                images[i] := gdk_pixbufNewFromFile(image_names[i])
                if( images[i] == nil )
return FALSE; endif
        next

return( TRUE )	// load_pixbufs()



static function expose_cb( widget, event, data )

        local pixels, rowstride, style

        rowstride := gdk_pixbufGetRowstride (frame)

	style := gtk_widgetGetStyle( widget )

   	pixels = gdk_pixbufGetPixels(frame)

        gdk_drawRgbImageDithalign(widget, ;
        	style:black_gc, ;
                event:area:x, event:area:y, ;
                event:area:width, event:area:height, ;
                GDK_RGB_DITHER_NORMAL, ;
                pixels, rowstride, ;
                event:area:x, event:area:y)
return( TRUE )	// expose_cb()



/* Task to regenerate the frame */
static function task_time()

	local f, i, xmid, ymid, radius
	local ang, xpos, ypos, iw, ih, r, k
	local r1 := map(), r2 := map(), dest := map()

   do while .t.


	gdk_pixbufCopyArea( background, 0, 0, back_width, back_height, ;
			      frame, 0, 0)

	f := (frame_num % CYCLE_LEN) / CYCLE_LEN

	xmid := back_width / 2.0
	ymid := back_height / 2.0

	radius := MIN(xmid, ymid) / 2.0

	for i := 1 to N_IMAGES

		ang := 2.0 * M_PI * i / N_IMAGES - f * 2.0 * M_PI

		iw := gdk_pixbufGetWidth(images[i])
		ih := gdk_pixbufGetHeight(images[i])

		r := radius + (radius / 3.0) * sin (f * 2.0 * M_PI)

		xpos := int (xmid + r * cos (ang) - iw / 2.0 + 0.5)
		ypos := int (ymid + r * sin (ang) - ih / 2.0 + 0.5)

		k := iif( isbit( i, 0 ), sin (f * 2.0 * M_PI), cos (f * 2.0 * M_PI))
		k := 2.0 * k * k
		k := MAX (0.25, k)

		r1:x := xpos
		r1:y := ypos
		r1:width := iw * k
		r1:height := ih * k

		r2:x := 0
		r2:y := 0
		r2:width := back_width
		r2:height := back_height


		if (gdk_rectangleIntersect (r1, r2, dest))

		gdk_pixbufComposite (images[i], ;
		      frame, ;
		      dest:x, dest:y, ;
		      dest:width, dest:height, ;
		      xpos, ypos, ;
		      k, k, ;
		      GDK_INTERP_BILINEAR, ;
		      iif( isbit(i,0), ;
		      MAX( 127, abs( 255 * sin (f * 2.0 * M_PI))), ;
		      MAX( 127, abs( 255 * cos (f * 2.0 * M_PI)))) ;
		); endif


	next
	//gtk_widgetQueueDrawArea(da, 0, 0, back_width, back_height)
	gtk_widgetDraw(da);
	//gtk_widgetShow(da);

	frame_num++
	sleep( FRAME_DELAY )
   end
return TRUE




