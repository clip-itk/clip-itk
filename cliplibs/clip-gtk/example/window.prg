#include <clip-gtk.ch>

static cls

function Main()
	local w,vb,hb,sw,f,CLFrame
	local clst,clst1,sizes:={}, cols:={},clf:={}
	local wX,wY
	gtk_Init()

	w:= gtk_WindowNew(,"CLIP-GTK test")
	gtk_WidgetSetPosition(w,50,50)
	gtk_WidgetSetSize(w,750,550)
	gtk_WidgetRealize(w)
//	gtk_WindowGetSize(w,wX,wY)
//qout(wX,wY)
	gtk_WindowSetPolicy(w,.f.,.t.,.t.)
	gtk_ContainerSetBorderWidth(w,0)
	gtk_ContainerSetResizeMode(w, GTK_RESIZE_QUEUE)
//		Обработка "delete-event" окна w
	gtk_SignalConnect(w,"delete-event",{|wid,e|gtk_WidgetDestroy(w),gtk_Quit()})
	vb:= gtk_VBoxNew()
	vb:name = "VBox 1"
	gtk_ContainerAdd (w, vb)

	hb:= gtk_HBoxNew()
	gtk_WidgetSetSize(hb,600,25)
	gtk_BoxPackStart(vb,hb)

	sw:= gtk_ScrolledWindowNew()
	gtk_ScrolledWindowSetPlacement(sw,GTK_CORNER_TOP_LEFT)
	gtk_BoxPackStart(vb,sw,.t.,.t.)

	f:= gtk_LayoutNew()
	gtk_WidgetSetSize(f,400,300)
	gtk_ContainerSetBorderWidth(f,20)
	gtk_ScrolledWindowAddWithViewport (sw, f)


	EFrame:=gtk_FrameNew(,"Entries and Combo box")
	gtk_WidgetSetSize(EFrame,215,185)
// dlja chego eto? na frame veshat signal???	gtk_SignalConnect(EFrame,"focus-in-event",{|wid,e|/*gtk_WindowSetFocus(w,en2),*/gtk_EntrySetText(wid,'got focus')})
	gtk_LayoutPut(f, EFrame, 215,10)
	EFx:=gtk_FixedNew()
	gtk_ContainerAdd(EFrame,EFx)

	en2:=gtk_EntryNew()
	gtk_EntrySetText(en2,"Text text text")
	gtk_WidgetSetSize(en2,200,30)
	gtk_WidgetSetPosition(en2,5,5)
	gtk_EntrySetMaxLength(en2, 20)
	gtk_EntrySetPosition(en2, 12)
	gtk_EntrySetVisibility(en2, .t.)
	gtk_EntrySetEditable(en2, .t.)
	gtk_SignalConnect(en2,"focus-in-event",{|wid,e|/*gtk_WindowSetFocus(w,en2),*/gtk_EntrySetText(wid,'got focus')})
	gtk_SignalConnect(en2,"focus-out-event",{|wid|/*gtk_WindowSetFocus(w,en3),*/gtk_EntrySetText(wid, "lost focus")})
	gtk_FixedPut (EFx, en2)

	en3:=gtk_EntryNew()
	gtk_EntrySetText(en3,"Text text text")
	gtk_WidgetSetSize(en3,200,30)
	gtk_WidgetSetPosition(en3,5,55)
	gtk_EntrySetMaxLength(en3, 20)
	gtk_EntrySetPosition(en3,12)
	gtk_EntrySetVisibility(en3, .t.)
	gtk_EntrySetEditable(en3, .t.)
	gtk_SignalConnect(en3,"focus-in-event",{|wid,e|/*gtk_WindowSetFocus(w,en2),*/gtk_EntrySetText(wid,'1233')})
	gtk_SignalConnect(en3,"focus-out-event",{|wid,e|/*gtk_WindowSetFocus(w,en2)*/gtk_EntrySetText(wid,'0000')})
	gtk_FixedPut (EFx, en3)


/*
	focbtn:=gtk_ButtonNew(,"Set focus")
	gtk_WidgetSetName(focbtn, "Button7")
	gtk_WidgetSetPosition(focbtn, 5,55)
	gtk_SignalConnect(focbtn,"clicked",{|wid,e|gtk_WindowSetFocus(w,en2)})
	//gtk_SignalConnect(focbtn,"clicked",{|wid,e|gtk_WindowRaise(dialog)})
	gtk_FixedPut (EFx, focbtn)
*/


	// Show main window
	/***************************************************/
	gtk_WidgetShowAll( w )
	gtk_WindowSetIconName(w, "G U I   t e s t");
	/***************************************************/
	gtk_Main()
use
return
