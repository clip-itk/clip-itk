#include <clip-gtk.ch>

function Main()
gtk_Init()

window := gtk_WindowNew(," Test IMAGE and EVENTBOX ")

gtk_WindowSetDefaultSize(window, 470, 90)

vbox := gtk_VBoxNew()
ebox := gtk_EventBoxNew()
gtk_WidgetSetEvents (ebox, GDK_BUTTON_PRESS_MASK)
gtk_SignalConnect(ebox, "button-press-event", {|wid, ev| qout("ok"),action(wid, ev)})
image:=gdk_PixmapFromXPMNew(,"clip.xpm",window)

gtk_ContainerAdd(ebox, image)

tbar := gtk_ToolBarNew()
gtk_ToolBarSetStyle(tbar, GTK_TOOLBAR_BOTH)
gtk_ToolBarAppendElement(tbar, GTK_TOOLBAR_CHILD_WIDGET, gtk_LabelNew(,"Clicked into picture "))

gtk_BoxPackStart(vbox, ebox)
gtk_BoxPackEnd(vbox, tbar)

gtk_ContainerAdd(window, vbox)

gtk_SignalConnect( window, "delete-event", {|wid,e|gtk_Quit()} )
gtk_WidgetShowAll( window )

gtk_Main()
return

static function action(wid, ev)
    ? "Event box clicked at coordinates "+ str(ev:X)+ " " + str(ev:Y)
return .f.
