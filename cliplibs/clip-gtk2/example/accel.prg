#include <clip-gtk2.ch>
gtk_init()
win := gtk_windowNew(, "Test accelerators")
qout()
gtk_WindowSetPosition(win, GTK_WIN_POS_CENTER)
gtk_WindowSetDefaultSize(win, 300, 200)
gtk_signalConnect(win, "delete-event", {|w| gtk_WidgetDestroy(w), gtk_quit()})


/* create button */
btn := gtk_ButtonNew(, "a&sdf", "&")
gtk_ButtonModifyFont(btn, "proof Medium 28")
gtk_ButtonModifyFG(btn, gtk_ColorNew(50000, 0, 65535))
/* add accelerator for button */
gtk_WidgetAddAccelerator(btn, GTK_CLICKED_SIGNAL, win, ;
                         btn:AccelKey, GDK_MOD1_MASK, GTK_ACCEL_VISIBLE)


/* create button with mnemonic */
btn1 := gtk_ButtonNewWithMnemonic(, "ф&ыва", "&")
gtk_ButtonModifyFont(btn1, "proof Medium 28")
gtk_ButtonModifyFG(btn1, gtk_ColorNew(0, 50000, 50000))

/* add clicked signals to button */
gtk_SignalConnect(btn, "clicked", {|w| gtk_WidgetSetFocus(w), qout("clicked " +gtk_ButtonGetLabel(w)), .f.})
gtk_SignalConnect(btn1, "clicked", {|w| gtk_WidgetSetFocus(w),qout("clicked " +gtk_ButtonGetLabel(w)), .f.})


lab := gtk_LabelNew(, "Press ALT+S to accelerate asdf")
gtk_WidgetModifyFG(lab, gtk_ColorNew(50000, 0, 65535))
gtk_WidgetModifyFont(lab, "proof Medium 28")
lab1 := gtk_LabelNew(, "Press ALT+Ы to accelerate фыва")
gtk_WidgetModifyFG(lab1, gtk_ColorNew(0, 50000, 50000))
gtk_WidgetModifyFont(lab1, "proof Medium 28")


vbox := gtk_VboxNew()

gtk_BoxPackStart(vbox, btn)
gtk_BoxPackStart(vbox, btn1)

gtk_BoxPackEnd(vbox, lab1)
gtk_BoxPackEnd(vbox, lab)
gtk_containerAdd(win, vbox)
gtk_WidgetShowAll(win)

gtk_main()
