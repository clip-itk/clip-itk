#include <clip-gtk2.ch>
static lay, btn1, btn2, btn3, btn4
function main()

gtk_init()
win := gtk_windowNew(, "Test container")

gtk_WindowSetPosition(win, GTK_WIN_POS_CENTER)
gtk_WindowSetDefaultSize(win, 300, 200)
gtk_signalConnect(win, "delete-event", {|| gtk_quit()})


/* create button */
btn1 := gtk_ButtonNewWithMnemonic(, "_1 Set focus chain ")
gtk_SignalConnect(btn1, "clicked", {|| setChain(1)})
? btn1:handle
btn2 := gtk_ButtonNewWithMnemonic(, "_2 Unset focus chain ")
gtk_SignalConnect(btn2, "clicked", {|| setChain(0)})
? btn2:handle
btn3 := gtk_ButtonNewWithMnemonic(, "_3 Set back focus chain ")
gtk_SignalConnect(btn3, "clicked", {|| setChain(2)})
? btn3:handle
btn4 := gtk_ButtonNewWithMnemonic(, "_4 Set focus chain by cicle ")
gtk_SignalConnect(btn4, "clicked", {|| setChain(3)})
? btn4:handle

lay := gtk_LayoutNew()

gtk_LayoutPut(lay, btn1, 12, 10)
gtk_LayoutPut(lay, btn2, 42, 60)
gtk_LayoutPut(lay, btn3, 72, 110)
gtk_LayoutPut(lay, btn4, 102, 160)


/*
? arr

xx := {}
? gtk_ContainerGetFocusCHain(lay, @xx)
? xx
? "set"
gtk_ContainerSetFocusChain(lay, arr)
? "ok"
xx := {}
? gtk_ContainerGetFocusCHain(lay, xx)
?  xx
*/

gtk_containerAdd(win, lay)

gtk_WidgetShowAll(win)
gtk_main()
return .t.

******************************
static function setChain(mode)
local x, arr
	do case
	case mode == 0
        	gtk_ContainerUnsetFocusChain(lay)
                ? "Unset focus chain"
		xx := {}
		? gtk_ContainerGetFocusCHain(lay, @xx)
		? xx
                ?
	case mode == 1
                ? "Set focus chain 4 --> 2 --> 3 --> 1"
		arr := {}
		aadd(arr, btn4)
		aadd(arr, btn2)
		aadd(arr, btn3)
		aadd(arr, btn1)
        	gtk_ContainerSetFocusChain(lay, arr)
		xx := {}
		? gtk_ContainerGetFocusCHain(lay, @xx)
		? xx
                ?

	case mode == 2
        	gtk_ContainerUnsetFocusChain(lay)
                ? "Set focus chain 4 --> 3 --> 2 --> 1"
		arr := {}
		aadd(arr, btn4)
		aadd(arr, btn3)
		aadd(arr, btn2)
		aadd(arr, btn1)
        	gtk_ContainerSetFocusChain(lay, arr)
		xx := {}
		? gtk_ContainerGetFocusCHain(lay, @xx)
		? xx
                ?
	case mode == 3
        	gtk_ContainerUnsetFocusChain(lay)
                ? "Set by cicle focus chain 4 -->  3 --> 2 --> 3 --> 4  --> 1"
		arr := {}
		aadd(arr, btn4)
		aadd(arr, btn3)
		aadd(arr, btn2)
		aadd(arr, btn3)
		aadd(arr, btn4)
		aadd(arr, btn1)
        	gtk_ContainerSetFocusChain(lay, arr)
		xx := {}
		? gtk_ContainerGetFocusCHain(lay, @xx)
		? xx
                ?
        endcase
return .t.
