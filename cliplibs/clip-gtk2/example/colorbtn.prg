#include <clip-gtk2.ch>
function main()
gtk_init()
win := gtk_windowNew(, "Color Buttons")
qout()
gtk_WindowSetPosition(win, GTK_WIN_POS_CENTER)
gtk_signalConnect(win, "delete-event", {|| gtk_quit()})

vbox := gtk_VBoxNew()

/* create button */
btn1 := gtk_ButtonNew(, "button1")
gtk_ButtonModifyFG(btn1, gtk_ColorNew(555555, 0, 0))
gtk_ButtonModifyBG(btn1, gtk_ColorNew(11111, 111111, 11111), GTK_STATE_ACTIVE)
gtk_ButtonModifyBG(btn1, gtk_ColorNew(22222, 55, 55555), GTK_STATE_NORMAL)
gtk_ButtonModifyBG(btn1, gtk_ColorNew(0, 55555, 55555), GTK_STATE_PRELIGHT)


btn2 := gtk_ButtonNew(, "button2")
gtk_ButtonModifyFG(btn2, gtk_ColorNew(0, 0, 33333))
//gtk_ButtonModifyFont(btn2, "Arial Italic 16")
gtk_ButtonModifyFont(btn2, "Sans Bold 16")

gtk_BoxPackStart(vbox, btn1)
gtk_BoxPackStart(vbox, btn2)

gtk_containerAdd(win, vbox)
gtk_WidgetShowAll(win)

gtk_main()
return
