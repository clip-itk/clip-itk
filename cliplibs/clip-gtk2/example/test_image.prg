#include <clip-gtk2.ch>

function Main()
gtk_Init()

window := gtk_WindowNew(," Test IMAGE and EVENTBOX ")

gtk_WindowSetDefaultSize(window, 470, 90)

vbox := gtk_VBoxNew()
ebox := gtk_EventBoxNew()
gtk_WidgetSetEvents(ebox, numor(GDK_POINTER_MOTION_MASK, GDK_POINTER_MOTION_HINT_MASK, GDK_BUTTON_PRESS_MASK))
gtk_SignalConnect(ebox, "button-press-event", {|wid, ev| action_press(wid, ev)})
gtk_SignalConnect(ebox, "motion-notify-event", {|wid, ev| action_motion(wid, ev)})


image := gtk_ImageNewFromFile(,"banner.gif")

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

static function action_press(wid, ev)
    ? "Event box clicked at coordinates "+ str(ev:X)+ " " + str(ev:Y)
    ?

return .f.
static function action_motion(wid, ev)
local x, y
    gdk_WindowGetPointer(wid, @x, @y)
    ?  "x= ", x, "y= ", y
    ?

return .f.

