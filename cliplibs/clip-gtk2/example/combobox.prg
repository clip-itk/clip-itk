#include <clip-gtk2.ch>
function main()
local major, minor
gtk_init()
gtk_Version(@major, @minor)
if  (major < 2) .or. (minor < 4)
	gtk_ErrorMsgBox("For run this test you must install gtk2.0 version 2.4 or above",,"Gtk Version")
	return
endif
win := gtk_windowNew(, " Test Combo box ")
gtk_WindowSetPosition(win, GTK_WIN_POS_CENTER)
gtk_signalConnect(win, "delete-event", {|| gtk_quit()})

vbox := gtk_VBoxNew()

/* create button */

layout := gtk_LayoutNew()
gtk_WidgetSetSizeRequest(layout, 300, 180)
frame1 := gtk_FrameNew(, "Text combo")
gtk_WidgetSetSizeRequest(frame1, 120, 52)
gtk_LayoutPut(layout, frame1, 2, 2)

combo := gtk_ComboBoxNewText()
gtk_LayoutPut(layout, combo, 8, 17)


a:={}
aadd(a, "Monday"    )
aadd(a, "Tuesday"   )
aadd(a, "Wednesday" )
aadd(a, "Thursday"  )
aadd(a, "Friday"    )
aadd(a, "Saturday"  )
aadd(a, "Weekend!!!")

gtk_ComboBoxAppendText(combo, a[1])
gtk_ComboBoxAppendText(combo, a[2])
gtk_ComboBoxAppendText(combo, a[3])
gtk_ComboBoxAppendText(combo, a[4])
gtk_ComboBoxAppendText(combo, a[5])
gtk_ComboBoxAppendText(combo, a[6])
gtk_ComboBoxAppendText(combo, a[7])
d := dow(date())-1

if d == 0
	d := 7
endif
gtk_ComboBoxSetActive(combo, d)
gtk_SignalConnect(combo, "changed", {|w, e| qout("New active item "+a[gtk_ComboBoxGetActive(w)])})

list = gtk_ListStoreNew(, 1, TREE_TYPE_STRING)
combo2 := gtk_ComboBoxNewWithModel(, gtk_TreeModel(list))
cell := gtk_CellRendererTextNew()
gtk_CellLayoutPackstart(combo2, cell, .t.)
gtk_CellLayoutSetAttributes(combo2, cell, "text", 1, NIL)
  /* or like this, if one attribute */
//gtk_CellLayoutAddAttribute(combo2, cell, "text", 1)
gtk_ComboBoxSetWrapWidth(combo2, 3)
for i=1 to 10

        gtk_ListStoreAppend(list, 1, "str string"+alltrim(str(i)), -1)

next

gtk_ComboBoxSetActive(combo2, 1)

frame2 := gtk_FrameNew(, "Combo from model")
gtk_WidgetSetSizeRequest(frame2, 120, 52)
gtk_LayoutPut(layout, frame2, 130, 2)
gtk_LayoutPut(layout, combo2, 135, 17)


frame3 := gtk_FrameNew(, "Combo box text entry")
gtk_WidgetSetsizeRequest(frame3, 250, 52)
gtk_LayoutPut(layout, frame3, 2, 70)

entry := gtk_ComboBoxEntryNewText()
gtk_WidgetSetSizeRequest(entry, 240)
gtk_ComboBoxAppendText(entry, "Shave my legs shave my legs")
gtk_ComboBoxAppendText(entry, "Even though it's kind of hairy")
gtk_ComboBoxAppendText(entry, "Like my uncle Gary")
gtk_ComboBoxAppendText(entry, "Please don't let me beg...")
gtk_ComboBoxSetActive(entry, 1)

gtk_LayoutPut(layout, entry, 8, 85)

gtk_BoxPackStart(vbox, layout)

gtk_containerAdd(win, vbox)
gtk_WidgetShowAll(win)

gtk_main()
return

