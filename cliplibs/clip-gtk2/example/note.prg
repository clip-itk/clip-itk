#include <clip-gtk2.ch>
function Main()
gtk_init()
win := gtk_windowNew(, "Test notebook")
gtk_WindowSetPosition(win, GTK_WIN_POS_CENTER)
gtk_WidgetSetSizeRequest(win, 300, 300)
gtk_signalConnect(win, "delete-event", {|| gtk_quit()})


l1 := gtk_layoutNew()
gtk_WidgetSetSizeRequest(l1, 400, 500)
lab1 := gtk_LabelNew(, "Строка по-русски")
gtk_MiscSetAlignment(lab1, 0.5, 0.5)
gtk_MiscSetPadding(lab1, 10, 10)
gtk_LayoutPut(l1, lab1, 5, 5)
btn1 := gtk_ButtonNew(, "Сменить страницу ")
gtk_SignalConnect(btn1, "clicked", {|| gtk_NotebookSetPage(note, 2)})
gtk_LayoutPut(l1, btn1, 5, 50)


l2 := gtk_layoutNew()
gtk_WidgetSetSizeRequest(l2, 400, 500)
btn2 := gtk_ButtonNew(, "return to &first page", "&")
gtk_WidgetAddAccelerator(btn2, "clicked", win, btn2:AccelKey, ;
			 GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)
gtk_WidgetAddAccelerator(btn2, "clicked", win, GDK_F10, 0, 0)
gtk_SignalConnect(btn2, "clicked", {|| gtk_NotebookSetPage(note, 1)})
gtk_LayoutPut(l2, btn2, 5, 5)

note  := gtk_NoteBookNew()
gtk_NoteBookAppendPage(note, l1, "первая")
gtk_NoteBookAppendPage(note, l2, "вторая")

lab3 := gtk_LabelNew(, "Метка")
gtk_MiscSetAlignment(lab3, 0.5, 0.5)
gtk_MiscSetPadding(lab3, 10, 10)
gtk_NotebookAppendPage(note, lab3, "третья")

vbox := gtk_VboxNew()

gtk_BoxPackStart(vbox, note)
gtk_containerAdd(win, vbox)
gtk_WidgetShowAll(win)
gtk_main()
return .t.
