#include <clip-gtk2.ch>
function main()
local oGet
gtk_init()

win := gtk_windowNew(, "Test templates for entry")
qout()
gtk_WindowSetPosition(win, GTK_WIN_POS_CENTER)
gtk_WindowSetDefaultSize(win, 300, 200)
gtk_signalConnect(win, "delete-event", {|| gtk_quit()})


? "charset is", __CHARSET__
?

/* create Entry */
x := "qaaa-bbb-ccc"
oGet := gtk_GetNew(,x,"!AAA-AAA-AAA")//, @after(), @before())



vbox := gtk_VboxNew()

gtk_BoxPackStart(vbox, oGet)

btn := gtk_ButtonNew(, "Get entry value")
gtk_SignalConnect(btn, "clicked", {|w, e| qout(gtk_GetVarGet(oGet))})

btn1 := gtk_ButtonNew(, "Set Value!")
gtk_SignalConnect(btn1, "clicked", {|w, e| qout(gtk_GetVarPut(oGet, "1qqq-qqq-qqq"))})
gtk_BoxPackEnd(vbox, btn)
gtk_BoxPackEnd(vbox, btn1)


gtk_containerAdd(win, vbox)
gtk_WidgetShowAll(win)

gtk_main()

return

static function before(myEntry)
local ret := .T.
	gtk_EntrySetText(myEntry, "AAA-bbb-CCC")
return ret

static function after(myEntry)
local ret := .F.
	? gtk_EntryGetText(myEntry)
        ?
return ret


