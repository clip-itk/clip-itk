#include <clip-gtk.ch>

static pixmap

static function expose_event(widget, event, data)
local style

	style := gtk_WidgetGetStyle(widget)

	gdk_DrawPixmap(widget, ;
		style:fg_gc[GTK_WIDGET_STATE(widget)+1], ;
		pixmap, ;
		0, 0, ;
		0, 0, ;
		800, 600)

return


function  main()
local win, drawingarea, layout, btn, box

	gtk_init()

	win = gtk_windownew(, " Test GTK base pictures ")
	gtk_widgetsetsize(win, 500, 500)


	layout = gtk_layoutnew()
	gtk_widgetsetsize(layout, 500, 500)

	drawingarea = gtk_drawingareanew()
	gtk_drawingareasize(drawingarea, 800, 600)

	gtk_containeradd(win, layout)

	gtk_widgetshow(layout)
	gtk_widgetshow(drawingarea)
	gtk_widgetshow(win)

	gtk_layoutput(layout, drawingarea, 0, 0)

	//pixmap = gtk_pixmapcreatefromxpmd(, x)
	pixmap = gtk_pixmapfromxpmnew(, "x.xpm", drawingarea)

//	btn = gtk_buttonnew(,"Press me!")
	btn = gtk_buttonnew()
	box := gtk_VBoxNew()
	gtk_BoxPackEnd(box, pixmap)
	gtk_ContainerAdd(btn, box)
	gtk_layoutput(layout, btn, 40, 40)

	gtk_signalconnect(drawingarea, "expose-event", {|w, e| expose_event(w, e)})

	gtk_widgetshowall(win)
	gtk_signalconnect(win, "delete-event", {|| gtk_quit()})

	gtk_main()
return 0


