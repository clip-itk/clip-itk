#include <clip-gtk2.ch>
function main()
local mask, tb

gtk_init()
win := gtk_windowNew(, "Test background pixmap")
qout()
gtk_WindowSetPosition(win, GTK_WIN_POS_CENTER)
gtk_WindowSetDefaultSize(win, 300, 200)
gtk_signalConnect(win, "delete-event", {|w| gtk_WidgetDestroy(win), gtk_quit()})

gtk_WidgetRealize(win)

/*
st:=map()
//st:bg_pixmap_name:="./gdk-pixbuf-demo/laser1.jpg"
st:bg_pixmap_name:="x.xpm"

layout := gtk_LayoutNew()
gtk_WidgetSetSizeRequest(layout, 300,200)

gtk_WidgetModifyBG(layout, gtk_ColorNew(11111, 111111, 11111), GTK_STATE_NORMAL)
gtk_WidgetModifyStyle(layout,st, GTK_STATE_NORMAL)

*/
/******* OR **********/

st:=map()
st:bg_pixmap_name:={"./gdk-pixbuf-demo/laser1.jpg", "x.xpm"}

/*
layout := gtk_LayoutNew()
gtk_WidgetSetSizeRequest(layout, 300,200)

gtk_WidgetModifyBG(layout, gtk_ColorNew(11111, 111111, 11111), GTK_STATE_NORMAL)
gtk_WidgetModifyStyle(layout,st, GTK_STATE_NORMAL)
*/

vbox := gtk_VBoxNew()
button := gtk_ButtonNew(,"This is button. Press me!")

gtk_WidgetModifyBG(button, gtk_ColorNew(11111, 111111, 11111), GTK_STATE_NORMAL)
gtk_WidgetModifyBG(button, gtk_ColorNew(11111, 111111, 11111), GTK_STATE_ACTIVE)
gtk_WidgetModifyStyle(button,st)
gtk_BoxPackStart(vbox, button)


st2 := map()
st2:bg_pixmap_name := "gnome-foot.xpm"
entry := gtk_EntryNew()
gtk_WidgetModifyStyle(entry,st2)
gtk_BoxPackStart(vbox, entry)

buffer = gtk_TextBufferNew()
view := gtk_TextViewNewWithBuffer( , buffer )
gtk_TextViewSetWrapMode (view, GTK_WRAP_WORD)
gtk_WidgetSetSizeRequest(view, 300, 50)
str := "И текст по-русски"
gtk_TextBufferSetText(buffer,str, len(str) )
st3 := map()
st3:base_color:=gtk_ColorNew(11111, 111111, 11111)
st3:text_color:=gtk_ColorNew(55555, 0, 0)
gtk_WidgetModifyStyle(view,st3)
gtk_BoxPackEnd(vbox, view)

gtk_containerAdd(win, vbox)
//gtk_containerAdd(win, layout)

gtk_WidgetShowAll(win)

gtk_main()
return
