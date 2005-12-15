/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation 	           */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include <clip-ui.ch>

/* Test of clip-ui library usage */

static ws
static wnd := NIL, ww1, ww2
static childToolbar
static timer, tbState, iteration

/* Declaration */
local menu, i, sp, b
local journal_menu, action_menu, doc_menu
local ref_menu, cfg_menu, window_menu, help_menu
local main_tbar, statusbar
local accel_group
local win := NIL, params:=array(0)

driver := "gtk"
for i:=1 to pcount()
	if left(param(i),9) == "--driver="
		driver := substr(param(i),10)
	elseif param(i) == "-driver" .and. i+1<=pcount()
		driver := param(i+1)
	else
		aadd(params, param(i))
	endif
next

/* Use driver for GTK+ 2.x */
?? "Used driver: "+driver,chr(10)
useDriver( driver )

/* create workspace */
ws  := UIWorkSpace( params )

/*--------------------------------------------------------------------*/
/* create main window */
win := UIMainWindow("E/AS " + getClipUIVersion(), NIL, "mainWindow" )

// create menu of main window
menu := UIMenu()
journal_menu := UIPopupMenu()
action_menu := UIPopupMenu()
doc_menu := UIPopupMenu()
ref_menu := UIPopupMenu()
cfg_menu := UIPopupMenu()
window_menu := UIPopupMenu()
help_menu := UIPopupMenu()

menu:add(,"&Journal", journal_menu)
i := journal_menu:add( UIImage("icons/journal_bank_pp.xpm"),"&Payment orders", {|| qout("Payment orders") } )
journal_menu:disable(i)
i := journal_menu:add( UIImage("icons/doc_bank_pp.xpm"),"&Create payment order", {|| qout("Create payment order") } )
journal_menu:add(,"Submenu",help_menu)
help_menu:add(UIImage("icons/journal_bank_pp.xpm"),"Item",{|| qout("Item") })
help_menu:add(,"Item2",{|| qout("Item2") })
journal_menu:setKey(i,"F5")
journal_menu:addSeparator()
journal_menu:add(,"&Exit", @quit())

menu:add(,"&Settings", cfg_menu)
cff := @cfg_menu
win:widget["showTB"] := cfg_menu:addChecked(.T., "Show &toolbar", {|w,e| showToolBar(win, "showTB", cfg_menu) } )
win:widget["showSB"] := cfg_menu:addChecked(.T., "Show &statusbar", {|w,e| showStatusBar(win, "showSB", cfg_menu) } )
cfg_menu:addSeparator()
cfg_menu:add(,"&Configure...", NIL)
//journal_menu:clear()

// ToolBars
main_tbar := UIToolBar()
main_tbar:addButton( UIImage("icons/journal_bank_pp.xpm"), "List of payment orders", {|| qout("List of payment orders") } )
main_tbar:addButton( UIImage("icons/doc_bank_pp.xpm"), "Create payment order", {|| qout("Create payment order") })
main_tbar:addSeparator()
main_tbar:addButton( UIImage("icons/reference_partner.xpm"), "Partners", NIL )

//main_tbar:remove(1)
statusbar   := UIStatusBar()
statusbar:setText("Ready.")

win:setPanels( menu, main_tbar, statusbar )
win:setMDI()

ww1 := UIDocument("Core widgets", win)

/* Test widgets */
sp := UISplitter(SPLITTER_VERTICAL)
ww1:add(sp, .T., .T.)
sp:setPosition( 200 )

BankRefReq( sp )

b  := UIVBox(,3,3)
sp:addEnd(b) 

BankDocReq( ww1, b )

ww2 := UIChildWindow("", win)

OtherWidget(ww2)

ww1:show()

ww2:setCaption("Other widgets")
ww2:show()

ww1:show()

// Assign icon to window.
win:setIcon( UIImage("icons/eas-logo.xpm") )
// Put window to screen center
win:setPlacement( .T. )
// Set size to 600x450
win:setGeometry( { 600, 550, 35, 15 } )
//-----------------------------------------------------------------------------

/* show window */
win:show()

/* run infinitive application loop */
ws:run()
ws:quit()


/**================== FUNCTIONS ==================**/
static function quit()
	ws:quit()
return 0

/* Show/hide tool bar */
static function showToolBar(window, id, menu)
	if window:toolbar != NIL
		if menu:isChecked(window:widget[id])
			window:toolbar:show()
		else
			window:toolbar:hide()
		endif
	endif
return 0

/* Show/hide status bar */
static function showStatusBar(window, id, menu)
	if window:statusbar != NIL
		if menu:isChecked(window:widget[id])
			window:statusbar:show()
		else
			window:statusbar:hide()
		endif
	endif
return 0

/* Tree and table widgets */
static function BankRefReq( sp )
	local splitter, tree, table, vb

	splitter := UISplitter(SPLITTER_HORIZONTAL)
	sp:add(splitter, .T., .T.)
	
	tree := UITree(, {"N1","N2"})
	
	tree:setAction("selected",{|w,e| listEventTree(tree, e) })
	splitter:add( tree )
	
	table := UITable({"#","Date","Payee","Sum"})
	table:setAltRowColor("#cbe8ff")
	
	// Fill tree and table
	updateTable(tree, table)
	node66 := tree:addNode({"Parent_Last"})
	node67 := tree:addNode({"Last Leaf"},, node66)
	table:addRow({"8","25.10.03",'Last: JSC "Phoenix"',"99.00"})
		
	vb := UIVbox()
	table:setAction("selected",{|w,e| listEvent(table, e) })
	vb:add(table, .T., .T.)
	vb:addEnd(UIButton("&Update views", {|| updateTable(tree, table) }))
	splitter:addEnd( vb )
	
return NIL

static function listEventTree(tree, c)
	?? "Select in tree:",c,"(id =",tree:getSelectionId(),")",chr(10)
return

function listEvent(table, c)
	?? "Select in table:",c,"(id =",table:getSelectionId(),")",chr(10)
return

function updateTable(tree, table)
	local pos
	
	// Tree data
	pos := tree:savePosition()
	?? "Tree pos:", pos, chr(10)
	tree:clear()
	node1  := tree:addNode({"Node1", "node1111"})
	node11 := tree:addNode({"Node2"})
	node2  := tree:addNode({"Leaf1"},, node1)
	node3  := tree:addNode({"Leaf2"},, node1)
	node5  := tree:addNode({"Leaf5", "Leaf5"},, node1)
	node4  := tree:addNode({"Leaf3"},, node1, node3)
	node44 := tree:addNode({"Leaf3333"},, node11)
	node55 := tree:addNode({"Leaf333"},, node44)
	tree:restorePosition( pos )
	
	// Table data
	pos := table:savePosition()
	?? "Table pos:", pos, chr(10)
	table:clear()
	table:addRow({"1","20.10.03",'JSC "Lighthouse"',"20000.00"},"DB0101000588")
	table:addRow({"2","20.10.03",'JSC "Phoenix"',"5689.20"})
	table:addRow({"3","21.10.03",'JSC "Phoenix"',"1500.00"})
	table:addRow({"4","25.10.03",'JSC "Phoenix"',"99.00"})
	table:addRow({"5","20.10.03",'JSC "Lighthouse"',"20000.00"},"DB0101000589")
	table:addRow({"6","20.10.03",'JSC "Phoenix"',"5689.20"})
	table:addRow({"7","21.10.03",'JSC "Phoenix"',"1500.00"})
	table:restorePosition( pos )
return

/* Form widgets */
static function BankDocReq(w,grid)
	local drv, lab, data, top, bottomLine, t, f1, f2, t1, t2, b1, b2, b3, e1, e2, cb1, cb2, sum, hbsum, rs, rg
	drv := getDriver()

	data := map()
	data:num  := "11"
	data:date :="20.10"
	data:client := 'JSC "Brown and son"'
	data:sum  := "20000.00"
	data:reason := "For delivered goods.&\n"
	for i:=1 to 10
		data:reason += alltrim(str(i))+" line.&\n"
	next
	
	plat := map()
	plat:name 	:= 'JSC "Brown and son"'
	plat:bank	:= 'JSC "MENATEP"'
	plat:bankCity	:= "Krasnoyarsk"
	plat:BIK	:= "54521724647"
	plat:korAccount := "86768348914"
	plat:account	:= "7683187443445276"
	plat:INN	:= "1234567890"

	pol := map()
	pol:name	:= 'JSC "Lighthouse"'
	pol:bank	:= 'JSC "MENATEP"'
	pol:bankCity	:= "Moscow"
	pol:BIK		:= "54521724647"
	pol:korAccount 	:= "86768348914"
	pol:account	:= "7683187443445276"
	pol:INN		:= "1212145436"

	w:setName("usetax",grid:add(UICheckBox(.F.,"Use &tax")))
	
	rg := UIRadioGroup()
	w:setName("button1", grid:add(rg:addButton("button1")))
	w:setName("button2", grid:add(rg:addButton("button2")))
        
        // Slider
        sd := UISlider(10, 5, 60, 5)
        w:setName("slider", grid:add(sd))

	// Title
	top := UIHBox(,0,3)
	lab := UILabel("Payment order N ")
	drv:setStyle(lab,"font.style","bold")
	drv:setStyle(lab,"font.size","14")
	
	drv:setStyle(lab,"color.bg","red")
	drv:setStyle(lab,"color.light","white")
	drv:setStyle(lab,"color.dark","white")
	drv:setStyle(lab,"color.mid","white")
	drv:setStyle(lab,"color.text","white")
	drv:setStyle(lab,"color.base","white")
	drv:setStyle(lab,"color.white","white")
	
	drv:setStyle(lab,"color.fg","#FF1790")

//	drv:setStyle(lab,"color.text","blue")
//	drv:setStyle(lab,"color.bg","#ff0000")
//	drv:setStyle(lab,"color.base","#0000ff")
	top:add(lab)
 	e1 := UIEdit()
	e1:setValue(data:num)
	e1:setGeometry(50)
	e1:readOnly()
        w:setName("number", e1)
	drv:setStyle(top, "background", "icons/tick.xpm")
	top:add(e1)

	top:add(UILabel(" from "))

	e2 := UIEditDate()
	e2:setValue(data:date)
	e2:appendText(".2005")
	w:setFocus(e2)
	e2:setGeometry(75)
	w:setName("date", e2)
	top:add(e2)
	grid:add(top)

        // Payer
	f1 := UIFrame()
	grid:add(f1)
	drv:setStyle(f1,"color.bg","darkblue")
	f1:setLabel("Payer")
	f1:setType(FRAME_RAISED)
        t1 := UIVBox(,,3)
	f1:add( t1 )
	cb1 := UIComboBox({'JSC "Brown and son"'},1)
	w:setName("payer", cb1)
	t1:add(cb1)

        // Payee
	f2 := UIFrame("Payee",FRAME_SUNKEN)
	grid:add(f2)
        t2 := UIVBox(,,3)
	f2:add( t2 )
	cb2 := UIComboBox()
	cb2:setList({'JSC "Lighthouse"','JSC "Ronal"','JSC "Porechnoye"'})
	cb2:setValue(2)
	cb2:setValueInList(.T.)
        w:setName("payee", cb2)
	t2:add(cb2)

	// Sum
	hbsum := UIHBox(,3)
        hbsum:add(UILabel("&Sum: "))
	sum := UIEdit(data:sum)
	drv:setStyle(sum,"color.base","#C2D2FF")
	drv:setStyle(sum,"color.bg","red")
	w:setName("sum", sum)
	hbsum:add(sum)
	hbsum:add(w:setName("tax", UILabel("")))
	grid:add(hbsum)
	
	// Fill tax calculation
	sum:setAction("changed", {|| fieldChanged(w) })
	fieldChanged(w)
	
	grid:add(UILabel("Description:"))
        rs := UIEditText(data:reason)
	rs:appendText("&\nEND.")
	rs:setGeometry({,30})
	w:setName("reason", rs)
	grid:add(rs, .T., .T.)

	// Bottom panel
	bottomLine := w:actions
	b1 := UIButton( "Save", {|o,e| pp_save(w) } )
	b2 := UIButton( "Print", {|| w:dialogBox("Print","Print function isn't implemented yet.","'Ok','Cancel'",NIL,NIL,IMG_OK) } )
	b3 := UIButton( "Close", {|o,e| w_close(w) } )

	bottomLine:add(b1)
	bottomLine:add(b2)
	bottomLine:add(b3)

return NIL

/* Close specified window */
static function w_close(window)
	window:close()
return 0

/* Show all stored values from document */
static function pp_save(wnd)
	local val
	val := wnd:getValues()
	?? "Form values:"+CHR(10)
 	for i in val
		?? CHR(9)+i[1]+" =",i[2],CHR(10)
	next
return 0

static function fieldChanged(win)
	local s, tax, label, i
	if valtype(win) != 'O'
		return
	endif
	s := win:val("sum")
	tax := round(val(s)*0.2,2)
	label := iif("tax" $ win:value,win:value["tax"],NIL)
	tax := alltrim(str(tax))
	if valtype(label) == 'O'
		label:setText("Tax: "+tax)
	endif
return 

static function OtherWidget(w)
	local hp, pb, bt, percent := 0, lt, g, co, fn, tg, t, tl, tb
	
	hp := UIHBox(,3)
	hp:setPadding(5)
	hp:add(UILabel("Predefined icons:"))
	hp:add(UIImage(1))
	hp:add(UIImage(2))
	hp:add(UIImage(3))
	hp:add(UIImage(4))
	hp:add(UIImage(5))

        // Layout
        lt := UILayout()
	hp:add(lt)
        
	// Progress Bar
	pb := UIProgressBar("Progress Bar")
	lt:add(pb)
        
	bt := UIButton( "Change ProgressBar", {|o,e| percent += 0.05, percent := iif(percent > 1, 0, percent),; 
                                               pb:setPercent(percent, "Progress: "+alltrim(str(percent*100,0))+" %") } )
	lt:add(bt, "10,30")

	w:add( hp )
	
	g := UIHBox(,5)
	
	// Get FileName
	g:add(UILabel("File name: "))
	fn := UIEditFileName('')
        g:add(fn)
	
	// Get Color
	g:add(UILabel("Color: "))
	co := UIEditColor('#91FF40')
	co:setGeometry(60)
        g:add(co)
	w:add( g )

	// Timer
	tg := UIHBox(,5)
	tg:add(UILabel("Timer:"))
	tl := UILabel("<time>")
	tbState := 0
	timer   := NIL
	tb := UIButton("Start timer", {|| startTimer(tb, tl) })
	tg:add(tl)
	tg:add(tb)
	w:add( tg )	

return

/* Start timer */
static function startTimer(tb, tl)
	if tbState == 0
		// start
		tbState := 1
		tb:setText("Stop timer")
		if empty(timer)
			timer := UITimer(1, {|| timerEvent(tl) })
		else
			timer:start()
		endif
		iteration := 0
	else
		// stop
		tbState := 0
		tb:setText("Start timer")
		if .not. empty(timer)
			timer:stop()
		endif
	endif
return

/* Timer event */
static function timerEvent(l)
	local t, w
	iteration++
	if iteration == 15
		w := getMainWindow()
		if .not. empty(w)
			w:dialogBox("Timer","Timer works 15 seconds.","'Ok'",NIL,NIL,IMG_OK)
		else
			?? "getMainWindow failed.&\n"
		endif
	endif
	t := time()
	?? "Event:", t, chr(10)
	l:setText(t)
return
