#include <clip-gtk2.ch>
function main()
gtk_init()
win := gtk_windowNew(, " Test pango ")
qout()
gtk_WindowSetPosition(win, GTK_WIN_POS_CENTER)
gtk_signalConnect(win, "delete-event", {|| gtk_quit()})

vbox := gtk_VBoxNew()

/* create button */
btn1 := gtk_ButtonNew(, "button1")
lay := gtk_LayoutNew()
gtk_WidgetSetSizeRequest(lay, 100, 50)
label := gtk_LabelNew()
plab := gtk_WidgetCreatePangoLayout(label, "It is Pango text")
PangoLayoutSetFontDescription(plab, "Arial Italic 16")
gtk_LabelSetText(label, "aaaaa")
gtk_LayoutPut(lay, label, 0, 0)

gtk_BoxPackStart(vbox, btn1)
gtk_BoxPackStart(vbox, lay)

gtk_containerAdd(win, vbox)
gtk_WidgetShowAll(win)

gtk_main()
return

