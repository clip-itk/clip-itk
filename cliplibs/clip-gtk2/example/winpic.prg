#include <clip-gtk2.ch>



function  main()
local win, pixmap, pict, layout, btn, mask := map()

	gtk_init()

	win = gtk_windownew(, " Test GTK base pictures ")
	gtk_widgetsetsizeRequest(win, 500, 500)


	layout = gtk_layoutnew()
	gtk_widgetsetsizeRequest(layout, 500, 500)

	gtk_containeradd(win, layout)

	gtk_widgetshow(layout)
	gtk_widgetshow(win)

	pixmap = gtk_pixmapfromxpmnew(, "x.xpm", win, @mask)
        pict = gtk_ImageNewFromFile(, "x.xpm")

        btn = gtk_buttonnew()
        box := gtk_VBoxNew()
        gtk_BoxPackEnd(box, pixmap)
        gtk_ContainerAdd(btn, box)
        gtk_layoutput(layout, btn, 40, 40)

	//btn = gtk_buttonnew(,"Press me!")
	gtk_layoutput(layout, pict, 0, 0)

	gtk_widgetshowall(win)
	gtk_signalconnect(win, "delete-event", {|| gtk_quit()})

	gtk_main()
return 0


