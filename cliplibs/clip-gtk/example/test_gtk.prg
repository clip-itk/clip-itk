#include <clip-gtk.ch>
function Main()
gtk_Init()

window := gtk_WindowNew(,"test")

vbox := gtk_VBoxNew()
gtk_ContainerAdd( window, vbox )

tb := gtk_ToolBarNew()
pic := gdk_PixmapFromXPMNew(, "x.xpm")
pic1 = gdk_PixmapFromXPMNew(, "x.xpm")
gtk_ToolBarAppendItem(tb,NIL, "Button 1", NIL, pic, @action())
gtk_ToolBarAppendItem(tb,NIL, "Button 2", NIL, pic1, @action())

gtk_BoxPackStart( vbox, tb )


clist = gtk_CListNew(, 3, {"one", "two", "three"})

gtk_CListColumnTitlesShow(clist)
gtk_ClistAppend(clist, {"1", "2", "3"})
gtk_ClistAppend(clist, {"11", "22", "33"})
gtk_ClistAppend(clist, {"111", "222", "333"})

gtk_BoxPackStart( vbox, clist )


label := gtk_LabelNew(, "text")
gtk_labelSetJustify(label, GTK_JUSTIFY_FILL)
gtk_miscsetAlignment(label, 0, 0)
gtk_BoxPackStart( vbox, label )




gtk_SignalConnect( window, "delete-event", {|wid,e|gtk_Quit()} )
gtk_WidgetShowAll( window )

gtk_Main()
return

static function action()
    ? "Button clicked!"
return 0
