#include <clip-gtk2.ch>

//#define DEBUG

#ifdef DEBUG
	#define D_MSG(t)        qout(t)
#else
	#define D_MSG(t)
#endif

static l, fsdialog, csdialoge

function Main()
	local w, vb, hb, sw, f, tt
	local BFrame, BFx, rg, en, trbtn
	local EFrame, EFx, en2, cb
	local TFrame, TFx, vscr, text, txt, edbtn, wwbtn
	local DFrame, DFx, dialog, dbtn, btn6, btn10, btn11
	local MFrame, MFx, check1, opt_menu, optmenu, focbtn, cal
	local CLFrame, CLFx, clscr, clist
	local CTFrame, CTFx, ctree, node1, node2, node3, node4, ctscr
	local PBFrame, PBFx, qbtn
	local PxmFrame, PxmFx, pix, bmppix

	gtk_Init()

	// Create main window
	/***************************************************/
	D_MSG("Create window")
	w:= gtk_WindowNew(,"FONT test")
	gtk_WindowSetPosition(w,GTK_WIN_POS_CENTER_ON_PARENT)
	gtk_WindowSetDefaultSize(w,300,200)
	gtk_ContainerSetBorderWidth(w,0)
	gtk_ContainerSetResizeMode(w, GTK_RESIZE_QUEUE)
	gtk_SignalConnect(w,"delete-event",{|wid,e|qout("delete-event"), .f.})
	gtk_SignalConnect(w,"delete-event",{|wid,e|qout("try destroy window"),gtk_WidgetDestroy(w),gtk_Quit()})

	D_MSG("Create vertical box container")
	vb:= gtk_VBoxNew()
	vb:name = "VBox 1"
	gtk_ContainerAdd (w, vb)

	D_MSG("Create scrolled window container")
	sw:= gtk_ScrolledWindowNew()
	gtk_ScrolledWindowSetPlacement(sw,GTK_CORNER_TOP_LEFT)
	gtk_BoxPackStart(vb,sw,.t.,.t.)

	D_MSG("Create layout container")
	f:= gtk_LayoutNew()
	gtk_WidgetSetSizeRequest(f,700,1000)
	gtk_ContainerSetBorderWidth(f,20)
	gtk_ScrolledWindowAddWithViewport (sw, f)
	gtk_WidgetModifyBg(f, ColorNew(10000,30000,50008))

	//Dialog and font and color selecting dialogs
	/***************************************************/
	D_MSG("Create frame for dialogs")
	DFrame:=gtk_FrameNew(,"Dialogs")
	gtk_WidgetSetSizeRequest(DFrame,255,115)
	gtk_LayoutPut(f, DFrame, 10,10)
	DFx:=gtk_FixedNew()

	gtk_ContainerAdd(DFrame,DFx)

	D_MSG("Create QUIT button ")
	btn:=gtk_ButtonNew(,"Bye")
	gtk_SignalConnect(btn, "clicked", {|wid,ev|gtk_Quit()})
	gtk_FixedPut (DFx, btn, 100,10)


	/*** This label demonstrates a selected font and color ***/
	D_MSG("Create label")
	l:=gtk_LabelNew(,"Selected font")
	gtk_WidgetSetSizeRequest(l, 240)
	gtk_MiscSetAlignment(l, 0.5)
	l:Style=map()//gtk_WidgetGetModifierStyle(l)
	l:Style:FG_color = ColorNew(,65535,32768)
        l:Style:Font = "serenetypewriter Bold 20"
	gtk_WidgetModifyStyle(l, l:Style)
	gtk_FixedPut (DFx, l, 5,60)


	/*** Font selection dialog ***/
	D_MSG("Create font select dialog window")
	fsdialog:=gtk_FontSelectionDialogNew(,"Font Selection Dialog window")
	gtk_WindowSetModal(fsdialog)
	gtk_WindowSetPosition(fsdialog,GTK_WIN_POS_CENTER_ON_PARENT)
	gtk_WidgetShowAll(fsdialog:ApplyButton)
	gtk_FontSelectionDialogSetFontName(fsdialog,gtk_FontSelectionDialogGetFontName(fsdialog))
	gtk_SignalConnect(fsdialog,"delete-event",{|wid,ev|gtk_WidgetHide(fsdialog)})
	gtk_SignalConnect(fsdialog:OkButton,"clicked",{|wid,ev|SetFont(),gtk_WidgetHide(fsdialog)})
	gtk_SignalConnect(fsdialog:ApplyButton,"clicked",{||SetFont()})
	gtk_SignalConnect(fsdialog:CancelButton,"clicked",{|wid,ev|gtk_WidgetHide(fsdialog)})
	gtk_windowSetDefault(fsdialog, fsdialog:OkButton)
	gtk_WindowSetTransientFor(fsdialog,w)

	D_MSG("Create button 10")
	btn10:=gtk_ButtonNew(,"Select font")
	gtk_SignalConnect(btn10, "clicked", {|wid,ev|gtk_WidgetShow(fsdialog)})
	gtk_FixedPut (DFx, btn10,10,10)



	/*** Color selection dialog ***/
	D_MSG("Create color select dialog window")
	csdialog:=gtk_ColorSelectionDialogNew(,"Color Selection Dialog window")
	gtk_WindowSetModal(csdialog, .F.)
	gtk_WindowSetPosition(csdialog,GTK_WIN_POS_CENTER_ON_PARENT)
	gtk_WidgetHide(csdialog:HelpButton)
	gtk_ColorSelectionSetHasOpacityControl(csdialog:ColorSel, .T.)
	gtk_ColorSelectionSetColor(csdialog:ColorSel, l:style:fg_color)
	gtk_SignalConnect(csdialog,"delete-event",{|wid,ev|gtk_WidgetHide(csdialog)})
	gtk_SignalConnect(csdialog:ColorSel,"color-changed",{||mySetColor()})
	gtk_SignalConnect(csdialog:OkButton,"clicked",{|wid,ev|mySetColor(),gtk_WidgetHide(csdialog)})
	gtk_SignalConnect(csdialog:CancelButton,"clicked",{|wid,ev|gtk_WidgetHide(csdialog)})
	gtk_WindowSetTransientFor(csdialog, w)

	D_MSG("Create button 11")
	btn11:=gtk_ButtonNew(,"Select color")
	gtk_SignalConnect(btn11, "clicked", {|wid,ev|gtk_WidgetShow(csdialog)})
	gtk_FixedPut (DFx, btn11, 150,10)
	//gtk_TooltipsSetTip(tt,btn11,'Click this button for select color')


        gtk_WindowSetDefault(w, btn)
  	gtk_widgetShowAll(w)
	gtk_Main()
return

static function SetFont()
	? gtk_FontSelectionDialogGetFontName(fsdialog)
        ?
	gtk_WidgetModifyFont(l, gtk_FontSelectionDialogGetFontName(fsdialog))
return

static function mySetColor()
	gtk_WidgetModifyFG(l, gtk_ColorSelectionGetColor(csdialog:ColorSel))
return


////////////////////////////////////////////////////
//////// Color class definition ////////////////////
////////////////////////////////////////////////////

function ColorNew(r, g, b, op)
  local obj := map()

  r  = iif(r ==nil,0,r)
  g  = iif(g ==nil,0,g)
  b  = iif(b ==nil,0,b)
  op = iif(op==nil,65535,op)

  obj:Red = r
  obj:Green = g
  obj:Blue = b
  obj:Opacity = op
return obj

////////////////////////////////////////////////////











