#include <clip-gtk.ch>
gtk_init()
win := gtk_windowNew(, "Test accelerators")
gtk_WindowSetPosition(win, GTK_WIN_POS_CENTER)
gtk_WidgetSetSize(win, 200, 200)
gtk_signalConnect(win, "delete-event", {|| gtk_quit()})

//gtk_SignalConnect(win, GTK_EVENT, {|wgt, ev| iif(ev:event!=GTK_KEY_PRESS, .f., (qout(ev:keyval, chr(ev:keyval))))})
btn := gtk_ButtonNew(, "ф&ыва", "&")
//btn:AccelKey=115
gtk_SignalConnect(btn, "clicked", {|| qout("clicked asdf")})
gtk_WidgetAddAccelerator(btn, GTK_CLICKED_SIGNAL, win, ;
btn:AccelKey, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)

qout(btn:AccelKey, chr(btn:AccelKey))

vbox := gtk_VboxNew()

gtk_BoxPackStart(vbox, btn)
gtk_containerAdd(win, vbox)
gtk_WidgetShowAll(win)
gtk_main()
