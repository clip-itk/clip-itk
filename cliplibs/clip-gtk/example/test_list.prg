function Main()
gtk_init()

win := gtk_windowNew(, " test list with widgets ")
gtk_WidgetSetSize(win, 100, 700)


b1 := gtk_buttonNew(, "button1")
e1 := gtk_entryNew(, 1024)
gtk_entrySetText(e1, "entry 1")
e11 := gtk_entryNew(, 1024)
gtk_entrySetText(e11, "entry 11")

b2 := gtk_buttonNew(, "button2")
e2 := gtk_entryNew(, 1024)
gtk_entrySetText(e2, "entry 2")
e21 := gtk_entryNew(, 1024)
gtk_entrySetText(e21, "entry 21")

b3 := gtk_buttonNew(, "button3")
e3 := gtk_entryNew(, 1024)
gtk_entrySetText(e3, "entry 3")
e31 := gtk_entryNew(, 1024)
gtk_entrySetText(e31, "entry 31")


list := gtk_ListNew()

gtk_ListAppendItems(list, b1)
gtk_ListAppendItems(list, e1)
gtk_ListAppendItems(list, e11)
gtk_ListAppendItems(list, b2)
gtk_ListAppendItems(list, e2)
gtk_ListAppendItems(list, e21)
gtk_ListAppendItems(list, b3)
gtk_ListAppendItems(list, e3)
gtk_ListAppendItems(list, e31)

gtk_ContainerAdd(win, list)

gtk_widgetShowAll(win)
gtk_SignalConnect(win, "delete-event", {|| gtk_quit()})

gtk_main()
return .t.
