#include <clip-gtk2.ch>
#include <gtk2-stock.ch>

//#define DEBUG

#ifdef DEBUG
	#define D_MSG(t)        qout(t)
#else
	#define D_MSG(t)
#endif

static Process
static l, fsdialog, csdialog
static rb1, rb2, rb3
static pbut, pb

function Main()
	local w, vb, hb, sw, f, tt
	local menubar, menu1i, menu1, item1, save_item, item2, en3, item3, item4, item5
	local rmg, radioitem1, radioitem2, radioitem3, checkitem1, tearoffitem1
	local menu2i, menu2, hitem, menubar2
	local BFrame, BFx, rg, en, trbtn
	local EFrame, EFx, en2, cb
	local TFrame, TFx, vscr, text, txt, edbtn, wwbtn
	local DFrame, DFx, dialog, dbtn, dbtn2, dbtn3, dhb, btn6, btn10, btn11
	local MFrame, MFx, check1, opt_menu, optmenu, focbtn, cal
	local CLFrame, CLFx, clscr, clist
	local CTFrame, CTFx, ctree, node1, node2, node3, node4, ctscr
	local PBFrame, PBFx, qbtn
	local PxmFrame, PxmFx, pix, bmppix
        local bfont, bcolor

	Process:=map()

	gtk_Init()

	Process:=map()
	Process:Runned = .f.
	Process:Stopped = .f.
	Process:Run = @ProcessRun()
	Process:Stop = @ProcessStop()

	// Create main window
	/***************************************************/
	D_MSG("Create window")
	w:= gtk_WindowNew(,"CLIP-GTK test")
	gtk_WindowSetPosition(w,GTK_WIN_POS_CENTER_ON_PARENT)
	gtk_WindowSetDefaultSize(w,750,550)
	gtk_ContainerSetBorderWidth(w,0)
	gtk_ContainerSetResizeMode(w, GTK_RESIZE_QUEUE)
	gtk_SignalConnect(w,"delete-event",{|wid,e|qout("delete-event"), .f.})
	gtk_SignalConnect(w,"delete-event",{|wid,e|qout("try destroy window"),gtk_WidgetDestroy(w),gtk_Quit()})

	D_MSG("Create vertical box container")
	vb:= gtk_VBoxNew()
	vb:name = "VBox 1"
	gtk_ContainerAdd (w, vb)
	D_MSG("Create horizontal box container")
	hb:= gtk_HBoxNew()
	gtk_WidgetSetSizeRequest(hb,600,25)
	gtk_BoxPackStart(vb,hb)

	D_MSG("Create scrolled window container")
	sw:= gtk_ScrolledWindowNew()
	gtk_ScrolledWindowSetPlacement(sw,GTK_CORNER_TOP_LEFT)
	gtk_BoxPackStart(vb,sw,.t.,.t.)

	D_MSG("Create layout container")
	f:= gtk_LayoutNew()
	gtk_WidgetSetSizeRequest(f,700,1000)
	gtk_ContainerSetBorderWidth(f,20)
	gtk_ScrolledWindowAddWithViewport (sw, f)
	gtk_WidgetModifyBg(f, ColorNew(10000,40000,50008))

	D_MSG("Create tooltips group")
	tt:=gtk_TooltipsNew()

	// Menu
	/***************************************************/
	D_MSG("Prepare menu bar")
	menubar:=gtk_MenuBarNew()
	//gtk_MenuBarSetShadowType(menubar, GTK_SHADOW_IN)
	gtk_BoxPackStart (hb, menubar)

	D_MSG("Create submenu item")
	menu1i:=gtk_MenuItemNew(,"menu1")
	//gtk_WidgetAddAccelerator (menu1i, GTK_ACTIVATE_ITEM_SIGNAL, w, GDK_m, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)

	D_MSG("Create submenu")
	menu1:=gtk_MenuNew()

	D_MSG("Create menu item 1")
	item1:=gtk_MenuItemNew(,"Item  1")
	gtk_MenuItemRightJustify(item1)

	D_MSG("Create menu item 'save'")
	save_item:=gtk_MenuItemNew(,"save")
	gtk_SignalConnect(save_item, "activate", {||qout("Save something...")})

	//gtk_WidgetAddAccelerator (save_item, GTK_ACTIVATE_SIGNAL, w, GDK_s, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)

	D_MSG("Create menu item 2")
	item2:=gtk_MenuItemNew(,"Item        2")
	gtk_MenuItemRightJustify(item1)

	D_MSG("Create entry for menu item")
	en3:=gtk_EntryNew()
	gtk_EntrySetText(en3, "s")
        gtk_EntrySetEditable(en3, .t.)

	D_MSG("Create menu item 3")
	item3:=gtk_MenuItemNew()
	gtk_ContainerAdd(item3, en3)

	D_MSG("Create menu item 4")
	item4:=gtk_MenuItemNew(,"Item    4")
	item4:Style = map()
	item4:Style:FG_color = ColorNew(40000,10000)
	gtk_MenuItemSetStyle(item4,item4:Style)

	D_MSG("Create menu item 5")
	item5:=gtk_MenuItemNew(,"Item 5")
	item5:Style = map()
	item5:Style:FG_color = ColorNew(0,40000,10000)
	gtk_MenuItemSetStyle(item5,item5:Style)

	D_MSG("Create radio menu group")
	rmg:=gtk_RadioMenuGroupNew()

	D_MSG("Create radio menu item 1")
	radioitem1:=gtk_RadioMenuItemNew(,rmg,"RadioItem1")

	D_MSG("Create radio menu item 2")
	radioitem2:=gtk_RadioMenuItemNew(,rmg,"RadioItem2")
	gtk_CheckMenuItemSetActive(radioitem2)

	D_MSG("Create radio menu item 3")
	radioitem3:=gtk_RadioMenuItemNew(,,"RadioItem3")
	radioitem3:Style = map()
	radioitem3:Style:Font = "urw chancery l, Medium Italic 26"
	radioitem3:Style:FG_color = ColorNew(0,40000,10000)
	gtk_RadioMenuItemSetStyle(radioitem3,radioitem3:Style)
	gtk_RadioMenuItemSetGroup(radioitem3,rmg)


	D_MSG("Create check menu item 1")
	checkitem1:=gtk_CheckMenuItemNew(,"Check Item 1")
	gtk_CheckMenuItemSetActive(checkitem1)

	D_MSG("Create tearoff menu item")
	tearoffitem1:=gtk_TearoffMenuItemNew()

	D_MSG("Create submenu 2 item")
	menu2i = gtk_MenuItemNew(,"menu2")
	menu2i:Style = map()
	menu2i:Style:Font = "times Bold 14"
	gtk_MenuItemSetStyle(menu2i,menu2i:Style)

	D_MSG("Create submenu 2")
	menu2:=gtk_MenuNew()
	gtk_MenuAppend(menu2, item4)
	gtk_MenuAppend(menu2, item5)

	D_MSG("Create menubar")
	gtk_MenuAppend(menu1, save_item)
	gtk_MenuAppend(menu1, item1)
	gtk_MenuAppend(menu1, item3)
	gtk_MenuAppend(menu1, radioitem1)
	gtk_MenuAppend(menu1, radioitem2)
	gtk_MenuAppend(menu1, radioitem3)
	gtk_MenuAppend(menu1, checkitem1)
	gtk_MenuAppend(menu1, menu2i)
	gtk_MenuPrepend(menu1, tearoffitem1)
	gtk_MenuItemSetSubmenu(menu2i,menu2)
	gtk_MenuBarAppend(menubar,menu1i)
	gtk_MenuItemSetSubmenu(menu1i,menu1)
	gtk_MenuBarAppend(menubar,item2)

	D_MSG("Create help menu item")
	hitem:=gtk_MenuItemNew(,"Help")

	D_MSG("Create menu bar 2")
	menubar2:=gtk_MenuBarNew()
	gtk_MenuBarAppend(menubar2,hitem)
	gtk_BoxPackEnd (hb, menubar2)


	// Radio buttons
	/***************************************************/
	BFrame:=gtk_FrameNew(,"Radio buttons")
	gtk_WidgetSetSizeRequest(BFrame,200,140)
	gtk_LayoutPut(f, BFrame, 10,10)
	BFx:=gtk_FixedNew()
	gtk_ContainerAdd(BFrame,BFx)

	// Radio buttons
	D_MSG("Create radio group")
	rg:= gtk_RadioGroupNew()

	D_MSG("Create radio button 1") // Radio button with entry
	rb1:= gtk_RadioButtonNew(,rg)
	gtk_FixedPut(BFx,rb1, 10, 10)
	D_MSG("Create entry")
	en:=gtk_EntryNew()
	gtk_EntrySetText(en, "a")
	gtk_ContainerAdd (rb1, en)
	gtk_TooltipsSetTip(tt,rb1,"Radio button with entry")

	D_MSG("Create radio button 2")
	rb2:= gtk_RadioButtonNew(,rg,"Radio button 2")
	gtk_ToggleButtonSetActive(rb2)
	rb2:Style = map()
	rb2:Style:Font = "bookman Italic 12"
	gtk_ToggleButtonSetStyle(rb2,rb2:Style)
	gtk_FixedPut(BFx,rb2, 10, 40)
	gtk_TooltipsSetTip(tt,rb2,"Radio button")

	D_MSG("Create radio button 3")
	rb3:= gtk_RadioButtonNew(,,"Radio button 3")
	gtk_RadioButtonSetGroup(rb3,rg)
	gtk_FixedPut(BFx,rb3, 10, 70)
	gtk_TooltipsSetTip(tt,rb3,"Radio button")

	D_MSG("Create button for toggle radio buttons")
	trbtn:=gtk_ButtonNew(,"Toggle radio buttons")
	//gtk_WindowSetPosition(trbtn, 35,100)
	gtk_SignalConnect(trbtn,GTK_CLICKED_SIGNAL,{|w,e|tr_button_clicked(w,e)})
	gtk_FixedPut(BFx, trbtn, 35, 100)
	gtk_TooltipsSetTip(tt,trbtn,"Press to cyclic toggle radio buttons")

	// Entry and combo
	/***************************************************/
	EFrame:=gtk_FrameNew(,"Entries and Combo box")
	gtk_WidgetSetSizeRequest(EFrame,215,85)
	gtk_LayoutPut(f, EFrame, 215,10)
	EFx:=gtk_FixedNew()
	gtk_ContainerAdd(EFrame,EFx)

	D_MSG("Create entry 2")
	en2:=gtk_EntryNew()
	gtk_EntrySetText(en2,"Text text text")
	gtk_WidgetSetSizeRequest(en2,200,30)
	gtk_EntrySetMaxLength(en2, 20)
	gtk_EntrySetPosition(en2, 12)
	gtk_EntrySetVisibility(en2, .t.)
	gtk_EntrySetEditable(en2, .t.)
	en2:Style:=map()
	en2:Style:FG_color=ColorNew(65535,65535)
	en2:Style:BASE_color=ColorNew(,,65535)
	gtk_WidgetSetStyle(en2,en2:Style)
	gtk_FixedPut (EFx, en2, 5, 5)
	gtk_TooltipsSetTip(tt,en2,"Text input entry")

	D_MSG("Create combo box")
	cb:= gtk_ComboNew()
	gtk_WidgetSetSizeRequest(cb,200)
	gtk_ComboSetValueInList(cb,.f.)
	//cb:lEnableEmptyValue = .f.
	gtk_ComboSetUseArrows(cb,.t.)
	gtk_ComboSetUseArrowsAlways(cb,.t.)
	//gtk_ComboSetCaseSensitive(cb,.t.)
	//gtk_ComboDisableActivate(cb)
	gtk_ComboSetPopdownStrings(cb, {'a','b','c','d'})
	gtk_EntrySetText(cb:Entry,"1234567890")
	gtk_FixedPut (EFx, cb, 5, 40)
	gtk_TooltipsSetTip(tt,cb:Entry,"Combo box")

/* comment -because GTK_ENABLE_BROKEN
	// Text widget
	/***************************************************/
	D_MSG("Create frame for the text")
	TFrame:=gtk_FrameNew(,"Text")
	gtk_FrameSetLabelAlign(TFrame,0.5)
	gtk_WidgetSetSizeRequest(TFrame,440,290)
	gtk_LayoutPut(f, TFrame, 10,145)
	TFx:=gtk_FixedNew()
	gtk_ContainerAdd(TFrame,TFx)

	D_MSG("Create vertical scrollbar")
	vscr:=gtk_VScrollbarNew()
	gtk_WidgetSetUPosition(vscr,415,5)
	gtk_WidgetSetSizeRequest(vscr,,245)
	gtk_RangeSetUpdatePolicy(vscr,GTK_UPDATE_DELAYED)
	gtk_FixedPut (TFx, vscr)
	D_MSG("Create text widget")
	//text:=gtk_TextNew(,,gtk_RangeGetAdjustment(vscr))
	text:=gtk_TextNew()
	txt = replicate("This is a TEXT widget. It can display and edit text."+ ;
		"It may have a Editable and WordWrap property."+chr(10),30)
	gtk_TextInsert(text,txt)
	gtk_WidgetSetUPosition(text,5,5)
	gtk_WidgetSetRequestSize(text,400,245)
	gtk_TextSetEditable(text,.T.)
	gtk_TextSetWordWrap(text,.T.)
	gtk_TextSetAdjustments(text,,gtk_RangeGetAdjustment(vscr))
	//text:VAdjustment = vscr
	gtk_FixedPut (TFx, text)
	gtk_TooltipsSetTip(tt,text,"Text widget. It can display and edit text")

	edbtn:=gtk_CheckButtonNew(,"Editable")
	gtk_ToggleButtonSetActive(edbtn,gtk_TextGetEditable(text))
	gtk_SignalConnect(edbtn, "clicked", {||gtk_TextSetEditable(text, !gtk_TextGetEditable(text))})
	gtk_FixedPut (TFx, edbtn, 5, 250)
	gtk_TooltipsSetTip(tt,edbtn,'Change "Editable" property of Text widget')

	wwbtn:=gtk_CheckButtonNew(,"Word wrap")
	gtk_ToggleButtonSetActive(wwbtn,gtk_TextGetWordWrap(text))
	gtk_SignalConnect(wwbtn, "clicked", {||gtk_TextSetWordWrap(text, !gtk_TextGetWordWrap(text))})
	gtk_FixedPut (TFx, wwbtn, 100, 250)
	gtk_TooltipsSetTip(tt,wwbtn,'Change "WordWrap" property of Text widget')

comment -because GTK_ENABLE_BROKEN */



	//Dialog and font and color selecting dialogs
	/***************************************************/
	D_MSG("Create frame for dialogs")
	DFrame:=gtk_FrameNew(,"Dialogs")
	gtk_WidgetSetSizeRequest(DFrame,255,115)
	gtk_LayoutPut(f, DFrame, 440,10)
	DFx:=gtk_FixedNew()
	gtk_ContainerAdd(DFrame,DFx)

	/*** Popup dialog ***/
	D_MSG("Create dialog window")
	dialog:=map()
	dialog:=gtk_DialogNew(,"Dialog window")
	gtk_WindowSetModal(dialog, .F.)
	gtk_WindowSetPosition(dialog,GTK_WIN_POS_CENTER_ON_PARENT,)
	gtk_WidgetSetSizeRequest(dialog,400,100)
	gtk_ContainerAdd(dialog:VBox,gtk_LabelNew(,"This is a dialog window"))
	gtk_WindowSetTransientFor(dialog,w)
	gtk_SignalConnect(dialog,"delete-event",{|w,e|gtk_WidgetHide(dialog)})

	D_MSG("Create close button for a dialog")
	dbtn:=map()
	dbtn:=gtk_ButtonNew(,"Close")
	gtk_SignalConnect(dbtn,"clicked",{|w,e|gtk_WidgetHide(dialog)})
	gtk_TooltipsSetTip(tt,dbtn,'Click this button for close dialog')
	dbtn2:=gtk_ButtonNew(,"List Toplevels Windows")
	gtk_SignalConnect(dbtn2,"clicked",{|w, e| getToplevels(w)})
	gtk_TooltipsSetTip(tt,dbtn2,'Click this button for get list toplevels windows')
	dbtn3:=gtk_ButtonNew(,"Call Error Message")
	gtk_SignalConnect(dbtn3,"clicked",{|w, e| gtk_ErrorMsgBox("Test!",,"Test error message box", dialog)})
	gtk_TooltipsSetTip(tt,dbtn3,'Click this button for test error message dialog')
	dhb := gtk_HboxNew()
        gtk_BoxPackStart(dhb, dbtn2, .t., .t.)
        gtk_BoxPackStart(dhb, dbtn3, .t., .t.)
        gtk_BoxPackEnd(dhb, dbtn, .t., .t.)
	gtk_ContainerAdd(dialog:ActionArea,dhb)

	D_MSG("Create button 6")
	btn6:=map()
	btn6:=gtk_ButtonNew(,"Pop a dialog")
	gtk_SignalConnect(btn6,"clicked",{|w,e|gtk_WidgetShowAll(dialog)})
	gtk_FixedPut (DFx, btn6, 85, 35)
	gtk_TooltipsSetTip(tt,btn6,'Click this button for popup dialog')

	/*** This label demonstrates a selected font and color ***/
	D_MSG("Create label")
	l:=gtk_LabelNew(,"Selected font")
	gtk_WidgetSetSizeRequest(l, 240)
	gtk_MiscSetAlignment(l, 0.5)
	l:Style=map()
	l:Style:Font = "proof Medium 16"
	l:Style:FG_color = ColorNew(,65535,32768)
	gtk_WidgetModifyStyle(l, l:Style)
	gtk_FixedPut (DFx, l, 5,60)


	/*** Font selection dialog ***/
	D_MSG("Create font select dialog window")
	fsdialog:=gtk_FontSelectionDialogNew(,"Font Selection Dialog window")
	gtk_WindowSetModal(fsdialog)
	gtk_WindowSetPosition(fsdialog,GTK_WIN_POS_CENTER_ON_PARENT,)
	gtk_WidgetShowAll(fsdialog:ApplyButton)
	gtk_FontSelectionDialogSetFontName(fsdialog,l:Style:Font)
	gtk_SignalConnect(fsdialog,"delete-event",{|wid,ev|gtk_WidgetHide(fsdialog)})
	gtk_SignalConnect(fsdialog:OkButton,"clicked",{|wid,ev|SetFont(),gtk_WidgetHide(fsdialog)})
	gtk_SignalConnect(fsdialog:ApplyButton,"clicked",{||SetFont()})
	//gtk_SignalConnect(fsdialog:ApplyButton,"clicked",@SetFont())
	gtk_SignalConnect(fsdialog:CancelButton,"clicked",{|wid,ev|gtk_WidgetHide(fsdialog)})
	gtk_WindowSetTransientFor(fsdialog,w)

	D_MSG("Create button 10")
	btn10:=gtk_ButtonNewWithMnemonic(,"Select _font")
	gtk_SignalConnect(btn10, "clicked", {|wid,ev|gtk_WidgetShow(fsdialog)})
        gtk_SignalConnect(btn10, "mnemonic-activate", {|w, e| qout("mnemonic activated!!!"), gtk_SignalEmit(w, "clicked"),.f.})

	gtk_FixedPut (DFx, btn10,30,5)
	gtk_TooltipsSetTip(tt,btn10,'Click this button for select font')


	/*** Color selection dialog ***/
	D_MSG("Create color select dialog window")
	csdialog:=gtk_ColorSelectionDialogNew(,"Color Selection Dialog window")
	gtk_WindowSetModal(csdialog, .F.)
	gtk_WindowSetPosition(csdialog,GTK_WIN_POS_CENTER_ON_PARENT,)
	gtk_WidgetHide(csdialog:HelpButton)
	gtk_ColorSelectionSetHasOpacityControl(csdialog:ColorSel, .T.)
	gtk_ColorSelectionSetColor(csdialog:ColorSel, l:Style:FG_color)
	gtk_SignalConnect(csdialog,"delete-event",{|wid,ev|gtk_WidgetHide(csdialog)})
	gtk_SignalConnect(csdialog:ColorSel,"color-changed",{||mySetColor()})
	gtk_SignalConnect(csdialog:OkButton,"clicked",{|wid,ev|mySetColor(),gtk_WidgetHide(csdialog)})
	gtk_SignalConnect(csdialog:CancelButton,"clicked",{|wid,ev|gtk_WidgetHide(csdialog)})
	gtk_WindowSetTransientFor(csdialog, w)

	D_MSG("Create button 11")
	btn11:=gtk_ButtonNewWithMnemonic(,"Select &color", "&")
	gtk_SignalConnect(btn11, "clicked", {|wid,ev|gtk_WidgetShow(csdialog)})
	gtk_FixedPut (DFx, btn11, 150,5)
	gtk_TooltipsSetTip(tt,btn11,'Click this button for select color')


	// Stock buttons
	/***************************************************/
	bcolor:=gtk_ButtonNewFromStock(,GTK_STOCK_SELECT_COLOR)
	bfont:=gtk_ButtonNewFromStock(,GTK_STOCK_SELECT_FONT)
	gtk_SignalConnect(bfont, "clicked", {|wid,ev|gtk_WidgetShow(fsdialog)})
	gtk_SignalConnect(bcolor, "clicked", {|wid,ev|gtk_WidgetShow(csdialog)})
        gtk_BoxPackEnd(hb, bcolor)
        gtk_BoxPackEnd(hb, bfont)


	// Miscellaneous widgets
	/***************************************************/
	D_MSG("Create frame for miscellaneous widgets")
	MFrame:=gtk_FrameNew(,"Miscellaneous widgets")
	gtk_WidgetSetSizeRequest(MFrame,240,285)
	gtk_LayoutPut(f, MFrame, 455,200)
	MFx:=gtk_FixedNew()
	gtk_ContainerAdd(MFrame,MFx)

	D_MSG("Create check button 1")
	check1:=gtk_CheckButtonNew(,"Check Button 1")
	gtk_ToggleButtonSetActive(check1, .T.)
	gtk_FixedPut (MFx, check1, 5, 5)
	gtk_TooltipsSetTip(tt,check1,'Check button')

	D_MSG("Create menu for option menu")
	opt_menu:=gtk_MenuNew()
	gtk_MenuAppend(opt_menu,gtk_MenuItemNew(,"option 1"))
	gtk_MenuAppend(opt_menu,gtk_MenuItemNew(,"option 2"))
	gtk_MenuAppend(opt_menu,gtk_MenuItemNew(,"option 3"))

	D_MSG("Create option menu widget")
	optmenu:=gtk_OptionMenuNew()
	gtk_WidgetSetSizeRequest(optmenu,200)
	gtk_OptionMenuSetMenu(optmenu,opt_menu)
	gtk_FixedPut (MFx, optmenu, 5,30)
	gtk_TooltipsSetTip(tt,optmenu,'Option menu widget')

	D_MSG("Create button for focus")
	focbtn:=gtk_ButtonNew(,"Set focus")
	gtk_WidgetSetName(focbtn, "Button7")
	gtk_SignalConnect(focbtn,"clicked",{|wid,e|gtk_WindowSetFocus(w,en2)})
	//gtk_SignalConnect(focbtn,"clicked",{|wid,e|gtk_WindowRaise(dialog)})
	gtk_FixedPut (MFx, focbtn, 5,55)
	gtk_TooltipsSetTip(tt,focbtn,'Set focus to entry')

	D_MSG("Calendar")
	cal:=gtk_CalendarNew()
	gtk_CalendarDisplayOptions(cal, GTK_CALENDAR_SHOW_HEADING+;
					GTK_CALENDAR_SHOW_DAY_NAMES+;
					GTK_CALENDAR_WEEK_START_MONDAY)
	gtk_WidgetShowAll(cal)
	gtk_CalendarSelectMonth(cal,6,2002)
	? gtk_CalendarGetDate(cal)
	?
	gtk_FixedPut(MFx,cal,5,80)

	// CList
	/***************************************************/
	D_MSG("Create frame for CList")
	CLFrame:=gtk_FrameNew(,"CList")
	gtk_WidgetSetSizeRequest(CLFrame,310,230)
	gtk_LayoutPut(f, CLFrame, 5,490)
	CLFx:=gtk_FixedNew()
	gtk_ContainerAdd(CLFrame,CLFx)

	D_MSG("Scrolled window for clist")
	clscr:=gtk_ScrolledWindowNew()
	gtk_WidgetSetSizeRequest(clscr, 300,200)
	gtk_FixedPut(CLFx,clscr, 5,5)

	D_MSG("Create clist widget")
	clist:= gtk_CListNew(,3,{"Column1","Column2","Column3"})
	gtk_ContainerAdd (clscr, clist)
	gtk_CListColumnTitlesShow(clist)
	gtk_CListSetReorderable(clist, .t.)
	gtk_CListSetUseDragIcons(clist, .t.)
	gtk_CListSetSelectionMode(clist, GTK_SELECTION_EXTENDED)

	gtk_CListSetColumnTitle(clist,1,"Column1")
	gtk_CListSetColumnTitle(clist,2,"Column2")
	gtk_CListSetColumnTitle(clist,3,"Column3")

	gtk_CListSetColumnAutoResize(clist,2,.t.)
	gtk_ClistAppend(clist,{"1","2","3"})
	gtk_ClistAppend(clist,{"2","2","3"})
	gtk_ClistAppend(clist,{"3","2","3"})
	gtk_ClistAppend(clist,{"4","2","3"})
	gtk_ClistAppend(clist,{"5","2","3"})
	gtk_ClistAppend(clist,{"6","2","3"})
	gtk_ClistAppend(clist,{"7","2","3"})
	gtk_ClistAppend(clist,{"8","2","3"})
	gtk_ClistAppend(clist,{"9","2","3"})
	gtk_ClistAppend(clist,{"10","2","3"})
	gtk_ClistAppend(clist,{"11","2","3"})
	gtk_ClistAppend(clist,{"12","2","3"})
	gtk_ClistAppend(clist,{"13","2","3"})
	gtk_ClistAppend(clist,{"14","2","3"})
	gtk_ClistAppend(clist,{"15","2","3"})
	gtk_ClistAppend(clist,{"16","2","3"})
	gtk_ClistPrepend(clist,{"17","2","3"})
	gtk_ClistInsert(clist,8,{"20","2","3"})

	gtk_CListSetForeground(clist, 3, ColorNew(65535))
	gtk_CListSetBackground(clist, 3, ColorNew(,65535))

	// CTree
	/***************************************************/
	D_MSG("Create frame for CTree")
	CTFrame:=gtk_FrameNew(,"CTree")
	gtk_WidgetSetSizeRequest(CTFrame,375,230)
	gtk_LayoutPut(f, CTFrame, 320,490)
	CTFx:=gtk_FixedNew()
	gtk_ContainerAdd(CTFrame,CTFx)

	D_MSG("Create CTree widget")
	ctree:=gtk_CTreeNew(,1,1,{"Column1"})
	//gtk_CListColumnTitlesShow(ctree)
	gtk_CListSetColumnWidth(ctree,1,100)
	gtk_CListSetSelectionMode(ctree,GTK_SELECTION_EXTENDED)

	D_MSG("Insert CTree nodes")
	node1:=gtk_CTreeInsertNode(ctree,,,{"Node1"},,,,.f.,.t.)
	node2:=gtk_CTreeInsertNode(ctree,node1,,{"Leaf1"},,,,.t.)
	node3:=gtk_CTreeInsertNode(ctree,node1,,{"Leaf2"},,,,.t.)
	node4:=gtk_CTreeInsertNode(ctree,node1,node3,{"Leaf3"},,,,.t.)

	D_MSG("Scrolled window for ctree")
	ctscr:=gtk_ScrolledWindowNew()
	gtk_WidgetSetSizeRequest(ctscr, 365,200)
	gtk_ContainerAdd (ctscr, ctree)
	gtk_FixedPut(CTFx,ctscr, 5,5)

	// Progress bar
	/***************************************************/
	D_MSG("Create frame for progress bar")
	PBFrame:=gtk_FrameNew(,"Progress bar")
	gtk_WidgetSetSizeRequest(PBFrame,310,100)
	gtk_LayoutPut(f, PBFrame, 5,670)
	PBFx:=gtk_FixedNew()
	gtk_ContainerAdd(PBFrame,PBFx)

	D_MSG("Create progress bar")
	pb:=gtk_ProgressBarNew()
	gtk_WidgetSetSizeRequest(pb,295,40)
	gtk_ProgressBarSetOrientation(pb,GTK_PROGRESS_LEFT_TO_RIGHT)
	gtk_ProgressBarSetText(pb,"Formatting disk C: %p%% complete")
	gtk_FixedPut(PBFx, pb, 5,5)
	Process:pbar := pb


	D_MSG("Process button")
	pbut:=gtk_ButtonNew(,"Run process")
	gtk_SignalConnect(pbut,"clicked",{|w,e|pbut_handler(w,e)})
	gtk_FixedPut(PBFx, pbut, 5,50)
	gtk_TooltipsSetTip(tt,pbut,'Click for start/stop background process')

	// Quit button
	/***************************************************/
	D_MSG("Create quit button")
	qbtn:=gtk_ButtonNewFromStock(,GTK_STOCK_QUIT)
	gtk_WidgetSetSizeRequest(qbtn,215,27)
	gtk_ButtonSetRelief(qbtn,GTK_RELIEF_NORMAL)
	qbtn:Style:=map()

	qbtn:Style:Font = "urw chancery l, Medium Italic 20"

	gtk_ButtonSetStyle(qbtn,qbtn:Style)
	gtk_LayoutPut (f, qbtn, 215,110)
	gtk_WindowSetDefault(w, qbtn)
	gtk_SignalConnect(qbtn,GTK_CLICKED_SIGNAL,{||gtk_Quit()})
	gtk_WidgetAddAccelerator( qbtn, "clicked", w, GDK_q, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE )
	gtk_TooltipsSetTip(tt,qbtn,'Quit from application')

	listbtn := gtk_ButtonNewWithMnemonic(, "List Toplevels")
        gtk_SignalConnect(listbtn, "clicked", {|w,e | getToplevels(w)})
        gtk_LayoutPut(f, listbtn, 215, 150)
	// Show main window
	/***************************************************/
	D_MSG("Show main window")
	gtk_WidgetShowAll( w )
	gtk_WindowSetIconName(w, "G U I   t e s t");

	// Pictures
	/***************************************************/
	D_MSG("Create frame for the pictures")
	PxmFrame:=gtk_FrameNew(,"Pictures")
	gtk_FrameSetLabelAlign(PxmFrame,0.5)
	gtk_WidgetSetSizeRequest(PxmFrame,140,70)
	gtk_LayoutPut(f, PxmFrame, 455,125)
	PxmFx:=gtk_FixedNew()
	gtk_ContainerAdd(PxmFrame,PxmFx)

	D_MSG("Pixmap")
	pix:=gdk_PixmapFromXPMNew(,"clip.xpm",w)
	gtk_FixedPut(PxmFx, pix, 5, 5)

	D_MSG("Pixmap from BMP")
	bmppix:=gdk_PixmapFromBMPNew(,"basket.bmp",w)
	gtk_FixedPut(PxmFx, bmppix, 80, 5)

	gtk_WidgetShowAll(PxmFrame)
	//
	/***************************************************/
	D_MSG("Run events")

	gtk_Main()
return

function SetFont
	l:style:Font = gtk_FontSelectionDialogGetFontName(fsdialog)
	gtk_WidgetModifyFont(l, l:style:Font)
return

function mySetColor
       	l:style:FG_color = {0, 0, 0, 0, 0}
       	l:style:FG_color[1] = gtk_ColorSelectionGetColor(csdialog:ColorSel)
	gtk_WidgetModifyStyle(l, l:style)
return

function tr_button_clicked(self, event)
    if gtk_ToggleButtonGetActive(rb1)
      gtk_ToggleButtonSetActive(rb2)
    else
      if gtk_ToggleButtonGetActive(rb2)
	gtk_ToggleButtonSetActive(rb3)
      else
	if gtk_ToggleButtonGetActive(rb3)
	  gtk_ToggleButtonSetActive(rb1)
	endif
      endif
    endif
return .t.


function pbut_handler()
  if .not. Process:Runned
    Process:Run()
  else
    Process:Stop()
    "Run process"
  endif
return .t.

function ProcessRun()
  local i := 0

  Process:Runned = .t.
  Process:Stopped := .f.
  gtk_ButtonSetLabel(pbut,"Stop process")
  while i<=100 .and. !Process:Stopped

    	sleep(0.1)
    	while gtk_EventsPending()
      		gtk_MainIteration()
    	enddo
    	gtk_ProgressBarSetFraction(Process:pbar,i/100)
    	i ++
  enddo
  ProcessStop()
return


function ProcessStop()
  Process:Runned = .f.
  Process:Stopped = .t.
  gtk_ButtonSetLabel(pbut,"Run process")
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

function getToplevels(w)
local dialog, dvb, dbtn, dsv, list, i, str, toplevel

        list := gtk_WindowListToplevels()
        toplevel = gtk_WidgetGetToplevel(w)

	dvb := gtk_VboxNew()
        for i = 1 to len(list)
        	str := str(list[i]:handle,3,0)+" : "+gtk_WindowGetTitle(list[i])+;
                	" : " + gtk_WidgetGetTypeName(list[i])
        	label := gtk_LabelNew(, str)
                gtk_MiscSetAlignment(label, 0, 0)
        	gtk_BoxPackStart(dvb, label)
                if toplevel != NIL .and. toplevel:handle == list[i]:handle
                	gtk_WidgetModifyFG(label, ColorNew(65535, 0, 0))
                endif
        next

	dialog:=gtk_DialogNew(,"List Toplevels Windows")
	gtk_WindowSetPosition(dialog,GTK_WIN_POS_CENTER_ON_PARENT,)
	gtk_WidgetSetSizeRequest(dialog,400,500)
	dsv := gtk_ScrolledWindowNew()
	gtk_ScrolledWindowAddWithViewport (dsv, dvb)
	gtk_ContainerAdd(dialog:VBox,dsv)
	gtk_SignalConnect(dialog,"delete-event",{|w,e|gtk_WidgetHide(dialog)})

	dbtn:=gtk_ButtonNew(,"Close")
	gtk_SignalConnect(dbtn,"clicked",{|w,e|gtk_WidgetHide(dialog)})
	gtk_ContainerAdd(dialog:ActionArea,dbtn)
        gtk_WidgetShowAll(dialog)
return .t.








