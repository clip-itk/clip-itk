/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library									   */
/*																		   */
/*   Copyright (C) 2005-2006 by E/AS Software Foundation				   */
/*   Authors: 															   */
/*  	     Andrey Cherepanov <skull@eas.lrn.ru>						   */
/*           Igor Satsyuk <satsyuk@tut.by>                                 */
/* 									  									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include <clip-gtk2.ch>
//#include <gtk2-stock.ch>
#include "../clip-ui.ch"

static drv := NIL

/* GTK+ 2.x driver. */

/* TODO:
	- gtk_ImageMenuItemNewWithMnemonic() for menu items with icons
*/

function initGTK2Driver()
	drv := map()
	drv:className  := "UIDriver"
	drv:driverName := "GTK+ 2.x driver"
	drv:driver     := "gtk2"

	/* WorkSpace */
	drv:getName		:= @ui_getName()
	drv:createInstance 	:= @ui_createInstance()
	drv:run 		:= @ui_run()
	drv:quit		:= @ui_quit()

	/* Window */
	drv:createWindow 	:= @ui_createWindow()
	drv:createChildWindow 	:= @ui_createChildWindow()
	drv:createChildSpace 	:= @ui_createChildSpace()
	drv:closeWindow		:= @ui_closeWindow()
	drv:closeMainWindow	:= @ui_closeMainWindow()
	drv:showWindow		:= @ui_showWindow()
	drv:setCaption		:= @ui_setCaption()
	drv:setChildCaption	:= @ui_setChildCaption()
	drv:setPanels		:= @ui_setPanels()
	drv:setGeometry		:= @ui_setGeometry()
	drv:getGeometry		:= @ui_getGeometry()
	drv:setWindowPlacement	:= @ui_setWindowPlacement()
	drv:setWindowIcon	:= @ui_setWindowIcon()
	drv:getCurrentChild	:= @ui_getCurrentChild()
	drv:setFocus		:= @ui_setFocus()
	drv:setDefault		:= @ui_setDefault()
	drv:setKeyEvent		:= @ui_setKeyEvent()
	drv:setModal		:= @ui_setModal()

	/* Menu */
	drv:createMenuBar	:= @ui_createMenuBar()
	drv:createPopupMenu	:= @ui_createPopupMenu()
	drv:addMenuItem		:= @ui_addMenuItem()
	drv:addMenuCheckedItem	:= @ui_addMenuCheckedItem()
	drv:addSeparator	:= @ui_addSeparator()
	drv:removeMenuItem	:= @ui_removeMenuItem()
	drv:isCheckedMenuItem	:= @ui_isCheckedMenuItem()
	drv:setAccelKey		:= @ui_setAccelKey()

	/* Toolbar */
	drv:createToolBar	:= @ui_createToolBar()
	drv:addToolBarButton	:= @ui_addToolBarButton()
	drv:addToolBarSpace	:= @ui_addToolBarSpace()
	drv:removeToolBarItem	:= @ui_removeToolBarItem()
	drv:createImage		:= @ui_createImage()
	drv:createStatusBar	:= @ui_createStatusBar()
	drv:setStatusText	:= @ui_setStatusText()

	/* Widget */
	drv:enableWidget	:= @ui_enableWidget()
	drv:isEnabled		:= @ui_isEnabled()
	drv:showWidget		:= @ui_showWidget()
	drv:setPixmap		:= @ui_setPixmap()
	drv:createScrolledRegion := @ui_createScrolledRegion()

	/* Grid */
	drv:createVBox		:= @ui_createVBox()
	drv:createHBox		:= @ui_createHBox()
	drv:addBox			:= @ui_addBox()
	drv:addBoxEnd		:= @ui_addBoxEnd()
	drv:setBoxSpacing	:= @ui_setBoxSpacing()
	drv:getBoxSpacing	:= @ui_getBoxSpacing()
	drv:createGrid		:= @ui_createGrid()
	drv:addGrid			:= @ui_addGrid()
	drv:setBoxAlignment	:= @ui_setBoxAlignment()
	drv:setBoxElemEqualSize	:= @ui_setBoxElemEqualSize()
	drv:createSplitter	:= @ui_createSplitter()
	drv:addSplitPane	:= @ui_addSplitPane()
	drv:addSplitPaneEnd	:= @ui_addSplitPaneEnd()
	drv:setSplitterPosition	:= @ui_setSplitterPosition()

	/* Button */
	drv:createButton	:= @ui_createButton()
	drv:setPadding		:= @ui_setPadding()
	drv:setButtonText	:= @ui_setButtonText()

	/* Table*/
	drv:createTable		:= @ui_createTable()
	drv:addTableRow		:= @ui_addTableRow()
	drv:setTableRow		:= @ui_setTableRow()
	drv:getTableRow		:= @ui_getTableRow()
	drv:removeTableRow	:= @ui_removeTableRow()
	drv:clearTable		:= @ui_clearTable()
	drv:setTableSelectAction    := @ui_setTableSelectAction()
	drv:getTableSelection	    := @ui_getTableSelection()
	drv:setTableSelection	    := @ui_setTableSelection()
	drv:conditionTableSelection := @ui_conditionTableSelection()
	drv:getTablePosition	    := @ui_getTablePosition()
	drv:setTablePosition	    := @ui_setTablePosition()

	/* Edit */
	drv:createEdit		:= @ui_createEdit()
	drv:createEditText	:= @ui_createEditText()
	drv:editSetReadOnly	:= @ui_editSetReadOnly()
	drv:editSetPassword	:= @ui_editSetPassword()

	/* Label */
	drv:createLabel		:= @ui_createLabel()
	drv:setLabelText	:= @ui_setLabelText()

	/* Frame */
	drv:createFrame		:= @ui_createFrame()
	drv:setFrameGrid	:= @ui_setFrameGrid()
	drv:setFrameLabel	:= @ui_setFrameLabel()
	drv:setFrameType	:= @ui_setFrameType()

	/* ComboBox*/
	drv:createComboBox	:= @ui_createComboBox()
	drv:setComboBoxList	:= @ui_setComboBoxList()

	/* RadioGroup and RadioButton */
	drv:createRadioGroup  := @ui_createRadioGroup()
	drv:createRadioButton := @ui_createRadioButton()

	/* CheckBox */
	drv:createCheckBox	:= @ui_createCheckBox()

	/* Values */
	drv:setValue		:= @ui_setValue()
	drv:getValue		:= @ui_getValue()
	drv:setStyle		:= @ui_setStyle()

	/* Other */
	drv:setAction		:= @ui_setAction()
	drv:getChildren		:= @ui_getChildren()
	drv:setKey		:= @ui_setKey()
	drv:unSetKey		:= @ui_unSetKey()
	drv:getKeyCode		:= @ui_getKeyCode()

	/* Tree */
	drv:createTree    	:= @ui_createTree()
	drv:addTreeNode   	:= @ui_addTreeNode()
	drv:setTreeRow		:= @ui_setTreeRow()
	drv:getTreeRow		:= @ui_getTreeRow()
	drv:removeTreeRow	:= @ui_removeTreeRow()
	drv:clearTree     	:= @ui_clearTree()
	drv:setTreeSelectAction := @ui_setTreeSelectAction()
	drv:getTreeSelection 	:= @ui_getTreeSelection()
	drv:setTreeSelection 	:= @ui_setTreeSelection()
	drv:conditionTreeSelection := @ui_conditionTreeSelection()
	drv:getTreePosition	:= @ui_getTreePosition()
	drv:setTreePosition	:= @ui_setTreePosition()

	/* Timer */
	drv:startTimer		:= @ui_startTimer()
	drv:stopTimer		:= @ui_stopTimer()

	/* Color */
	drv:colorParse		:= @ui_colorParse()

	/* Progress Bar */
	drv:createProgressBar 	:= @ui_createProgressBar()
	drv:setProgressBarPercent := @ui_setProgressBarPercent()

	/* Layout */
	drv:createLayout        := @ui_createLayout()
	drv:addLayout           := @ui_addLayout()
	drv:moveLayout          := @ui_moveLayout()

	/* Slider */
	drv:createSlider        := @ui_createSlider()
	drv:setSliderRange      := @ui_setSliderRange()
	drv:setSliderStep       := @ui_setSliderStep()

	/* Calendar */
	drv:showCalendar        := @ui_showCalendar()

	/* FileName Dialog */
	drv:selectFileName      := @ui_selectFileName()

	/* Color Dialog */
	drv:selectColor 		:= @ui_selectColor()

	/* EditTable*/
	drv:createEditTable		:= @ui_createEditTable()
	drv:addEditTableRow		:= @ui_addEditTableRow()
	drv:setEditTableRow		:= @ui_setEditTableRow()
	drv:getEditTableRow		:= @ui_getEditTableRow()
	drv:removeEditTableRow	:= @ui_removeEditTableRow()
	drv:clearEditTable		:= @ui_clearEditTable()
	drv:setEditTableField		:= @ui_setEditTableField()
	drv:getEditTableField		:= @ui_getEditTableField()
	drv:setEditTableCursor 		:= @ui_setEditTableCursor()
	drv:getEditTableRowCount 	:= @ui_getEditTableRowCount()
	drv:getEditTableColumnCount := @ui_getEditTableColumnCount()
	drv:getEditTableSelectedRow := @ui_getEditTableSelectedRow()
	drv:getEditTableSelectedColumn := @ui_getEditTableSelectedColumn()

	/* TabArea and Tab */
	drv:createTabArea		:= @ui_createTabArea()
	drv:createTab			:= @ui_createTab()
	drv:addTab				:= @ui_addTab()
	drv:activateTab			:= @ui_activateTab()
	drv:setTabCaption		:= @ui_setTabCaption()

return drv

function getGTK2Driver( params )
	if drv == NIL
		initGTK2Driver()
	endif
return drv

static function ui_getName( self )
return self:driver

/** Application **/

static function ui_createInstance( self, params )
	loadlib("libclip-gtk2")
//	clipa("gtk_init", iif(valtype(params)!='A',array(0), params))
	gtk_init()
return map()

static function ui_run( self, ws )
	gtk_main()
return 0

static function ui_quit( self, ws )
	gtk_Quit()
	CANCEL
return 0

/** Window **/

static function ui_createWindow( self, title, parent, resizeable )
	local wnd, id := NIL, vbox
	wnd := gtk_WindowNew( id, title )
	vbox := UIVBox()
	gtk_ContainerAdd( wnd, vbox )
	wnd:userSpace := vbox
	if valtype(resizeable) == "L" .and. .not. resizeable
		gtk_WindowSetResizeable(wnd, .F.)
	else
		gtk_WindowSetResizeable(wnd, .T.)
	endif
	if empty(parent)
		gtk_SignalConnectAfter( wnd, "delete-event", @ui_quit() )
	endif
return wnd

static function ui_createChildSpace(self, box )
	local o
	o := gtk_NotebookNew()
	gtk_NoteBookSetShowBorder( o, .T. )
	gtk_NoteBookSetScrollable( o, .T. )
	gtk_NotebookPopupEnable( o )
	gtk_BoxPackStart( box, o, .T., .T. )
return o

static function ui_createChildWindow( self, title, parent )
	local o, n
	o := UIVBox()
	gtk_NoteBookAppendPage( parent:childSpace, o, title )
	o:userSpace := o
return o

static function ui_closeWindow( self, window )
	local n
	n := ascan(window:parent:childs, {|e| e:idWindow == window:idWindow })
	gtk_NotebookRemoveTPage(window:parent:childSpace, n)
return n

static function ui_closeMainWindow( self, window )
	gtk_WidgetHideAll( window )
	if window:closeFlag == .T.
		gtk_SignalEmit(window, "delete-event")
	endif
	gtk_WidgetDestroy(window)
return NIL

static function ui_showWindow( self, window )
	local n, menu, e, o, first
	gtk_WidgetShowAll( window )
	if window:className == "UIVBox" .or. window:className == "UIChildWindow" .or. window:className == "UIDocument"
		// Activate window
		n := gtk_NoteBookPageNum(window:parent:childSpace, window)
		gtk_NoteBookSetPage(window:parent:childSpace, n)
	endif

	// Activate menu accels
	if "MENU" $ window .and. ! empty(window:menu)
		menu := window:menu
		for e in menu:elem
			if "ACCELKEY" $ e .and. ! empty(e:AccelKey)
				ui_setMenuAccel( window, e )
			endif
		next
		if len(menu:elem) > 0
			first := menu:elem[1]
			window:setKeyEvent( "F10", {|| gtk_SignalEmit(first, "activate-item") } )
		endif
	endif

return 0

static function ui_setMenuAccel( window, e )
	window:setKeyEvent( e:AccelKey, {|| gtk_SignalEmit(e, "activate-item") })
return 0

static function ui_setCaption( self, window, caption )
	gtk_windowSetTitle( window, caption )
return 0

static function ui_setChildCaption( self, window, caption )
	local n, w
	n := ascan(window:parent:childs, {|e| e:idWindow == window:idWindow })
	if n > 0
		w := gtk_NotebookGetNthPage(window:parent:childSpace, n)
		gtk_NotebookSetTabLabel(window:parent:childSpace, w, caption)
	endif
return 0

static function ui_setPanels( self, window, menu, toolBar, statusBar )
	local frame
	if .not. empty(menu)
		gtk_BoxPackStart( window:userSpace, menu, .F., .F., 0 )

		menu:win := window
		// Activate accel keys: Alt+AccelKey
		self:setAccelKey(window, menu)
	endif
	if .not. empty(toolBar)
		frame := gtk_FrameNew()
// TODO: need remove border from toolbar
//		gtk_ContainerSetBorderWidth( frame, 0 )
//		gtk_ContainerSetBorderWidth( toolBar, 0 )
		if window:className == "UIChildWindow" .or. window:className == "UIDocument"
			gtk_FrameSetShadowType(frame, GTK_SHADOW_OUT)
		else
			gtk_FrameSetShadowType(frame, GTK_SHADOW_NONE)
		endif
		gtk_ContainerAdd(frame, toolBar)
		gtk_BoxPackStart( window:userSpace, frame )
		toolBar:widget := frame
	endif
	if .not. empty(statusBar)
		gtk_BoxPackEnd( window:userSpace, statusBar )
	endif
return

static function ui_setAccelKey(self, win, menu)
	local nPos, oKey := map()
		for nPos := 1 to len(menu:elem)
			if "POPUPMENU" $ menu:elem[nPos]
				self:setAccelKey(win, menu:elem[nPos]:PopupMenu)
			endif

			if "ACCELKEY" $ menu:elem[nPos]
				oKey:alt   := .t.
				oKey:shift := .f.
				oKey:ctrl  := .f.
				oKey:code  := menu:elem[nPos]:AccelKey
				self:setKey(menu:elem[nPos], win, oKey)
			endif
		next
return .t.

/* Set window geometry: position and size */
static function ui_setGeometry( self, window, geom )
	if .not. valtype(geom) $ 'AN' .or. valtype(window) != "O"
		return .f.
	endif
	if "LAYOUT" $ window // Set geomtry for layout object
		window := window:layout
	endif
	if valtype(geom) == 'N'
		if ascan({"UIWindow","UIDocument","UIMainWindow"}, window:className) != 0
			// Separate windows
			gtk_WindowSetDefaultSize( window, geom )
		else
			// Other widgets
			gtk_WidgetSetSizeRequest( window, geom  )
		endif
	else
		if len(geom) >= 2
			gtk_WidgetSetSizeRequest( window, geom[1], geom[2] )
		endif
		if len(geom) == 4
			// NOTE: deprecated in GTK+ 2.x
			// gtk_WidgetSetUPosition( window, geom[3], geom[4] )
		endif
	endif
return .t.

/* Get window geometry: position and size */
static function ui_getGeometry( self, window )
	local geom, w:=0, h:=0, x:=0, y:=0 // width, height, x, y
	gtk_WidgetRealize( window )
	gtk_WidgetGetSizeRequest( window, @w, @h )
	// NOTE: deprecated in GTK+ 2.x
	// gtk_WidgetGetPosition( window, @x, @y )
	geom := { w, h, x, y }
return geom

/* Set window placement */
static function ui_setWindowPlacement( self, window, centered )
	if centered
		gtk_WindowSetPosition( window, GTK_WIN_POS_CENTER)
	else
		gtk_WindowSetPosition( window, GTK_WIN_POS_NONE)
	endif
return 0

static function ui_setWindowIcon( self, window, pic )
	gtk_WidgetRealize( window )
	gtk_WindowSetIconPixmap( window, pic )
return 0

static function ui_getCurrentChild(self, window)
	local n
	n := gtk_NotebookGetCurrentPage(window:childSpace)
return n

static function ui_setFocus(self, window, widget)
	gtk_WindowSetFocus(window, widget)
return NIL

static function ui_setDefault(self, window, widget)
	gtk_WindowSetDefault(window, widget)
	window:setFocus( widget )
return NIL

static function ui_setModal(self, window, modal)
	if window:className == 'UIWindow'
		gtk_WindowSetModal(window, modal)
	endif
return NIL

/** Menu **/

static function ui_createMenuBar( self )
	local o
	o := gtk_MenuBarNew()
return o

static function ui_createPopupMenu( self )
	local o
	o := gtk_MenuNew()
return  o

static function ui_addMenuItem( self, menu, pic, name, action, isEnabled )
	local o, picBox, lb, s, k, i, ii, accel:=""

	if menu:className == 'UIMenu'
		pic := NIL
	endif

	name := strtran( name, "_", "__" )
	if empty(pic)
		o := gtk_MenuItemNew( , name, "&" )
	else
		// TODO: o := gtk_ImageMenuItemNewWithMnemonic( , strtran( name, "&", "_" ) )
		// TODO: gtk_ImageMenuItemSetImage( o, pic )
		o := gtk_MenuItemNew()
		picBox := gtk_HBoxNew()
		gtk_BoxSetSpacing( picBox, 4)
		gtk_ContainerAdd( o, picBox )
		if .not. empty(pic)
			gtk_BoxPackStart( picBox, pic)
			o:pic := picBox
		endif
		lb := gtk_LabelNew(, name, "&")
		gtk_BoxPackStart(picBox, lb)
	endif

	// Extract accel key
	k := split(name, "&")
	if len(k) > 1
		for i=2 to len(k)
			ii := k[i]
			if ii[1,1] != "&" .and. accel == ""
				accel := ii[1,1]
			endif
		next
	endif
	if valtype(accel) == "C"
		// Correction for cyrillic key
		o:AccelKey := "Alt+"+ui_conversionLetter( accel )
	endif

	/* Check popup or finction in 'action' */
	if valtype(action) == 'B'
		/* Regular item */
		gtk_SignalConnectAfter( o, "activate", action )
	else
		if .not. empty(action) .and. action:className == 'UIPopupMenu'
			/* Popup menu */
			gtk_MenuItemSetSubmenu(o, action)
		endif
	endif

	if menu:className == 'UIMenu'
		// Top-level menu bar
		gtk_MenuBarAppend( menu, o )
	else
		// Sub-menu
		gtk_MenuAppend( menu, o )
	endif

	if isEnabled == .F.
		self:enableWidget( o, .F. )
	endif
return o

static function ui_addMenuCheckedItem( self, menu, isChecked, name, action, isEnabled )
	// TODO: add accel support
	local o
	name := strtran( name, "_", "__" )
	o := gtk_CheckMenuItemNew( , name, "&" )
	if valtype(isChecked) == 'L' .and. isChecked == .T.
		gtk_CheckMenuItemSetActive( o, .T. )
	else
		gtk_CheckMenuItemSetActive( o, .F. )
	endif
	if menu:className == 'UIMenu'
		gtk_MenuBarAppend( menu, o )
	else
		gtk_MenuAppend( menu, o )
	endif
	if .not. empty(action)
		gtk_SignalConnectAfter( o, "toggled", action )
	endif
	if isEnabled == .F. .or. empty(action)
		self:enableWidget( o, .F. )
	endif
return o

static function ui_addSeparator( self, menu )
	local o, st
//	o := gtk_SeparatorMenuItemNew()
	o := gtk_MenuItemNew()
	self:enableWidget( o, .F. )
	if menu:className == 'UIMenu'
		gtk_MenuBarAppend( menu, o )
	else
		gtk_MenuAppend( menu, o )
	endif
return o

static function ui_isCheckedMenuItem( self, item )
return gtk_CheckMenuItemGetActive(item)

static function ui_removeMenuItem( self, id, item )
	if valtype(id) != "O" .or. valtype(item) != "O"
		return
	endif
	gtk_ContainerRemove( id, item )
return 0

/** ToolBar **/

static function ui_createToolBar(self)
	local o, frame
	o := gtk_ToolBarNew()
return o

static function ui_addToolBarButton(self, toolBar, pic, tooltip, action, isEnabled )
	local o, w

	if empty(action)
		action := NIL //@ui_emptyFunction
		isEnabled := .F.
	endif

	if empty(pic)
		pic := UIImage(IMG_EMPTY)
	endif
	o := gtk_ToolBarAppendItem( toolBar, NIL, tooltip, NIL, pic, action )
	if isEnabled == .F.
		self:enableWidget( o, .F. )
	endif
return o

static function ui_enableToolBarItem(self, item, is_enabled)
	self:enableWidget( item, is_enabled )
return 0

static function ui_addToolBarSpace(self, toolBar)
	local o
	o := gtk_ToolBarAppendSpace( toolBar )
return o

static function ui_removeToolBarItem( self, id, item )
	if valtype(id) != "O" .or. valtype(item) != "O"
		return
	endif
	gtk_ContainerRemove( id, item )
return 0

/** StatusBar **/

static function ui_createStatusBar(self)
	local o
	o := gtk_StatusBarNew()
return o

static function ui_setStatusText( self, statusBar, text)
	gtk_StatusBarSetText(statusBar, text)
return 0

/** Image **/

static function ui_createImage(self, file, isString)
	local o
	if .not. empty(isString) .and. isString
		o := gdk_PixmapCreateFromXPMD(,file)
	elseif empty(file) .or. FILEATTR(file) == 0
		o := gdk_PixmapCreateFromXPMD(,getSysImage( IMG_EMPTY ))
	else
		o := gdk_PixmapFromXPMNew(, file )
	endif
return o

/** Widget **/

	static function ui_enableWidget( self, obj, flag )
	if .not. empty(obj)
		gtk_WidgetSetSensitive( obj, flag )
	endif
return 0

static function ui_isEnabled( self, obj )
	if NUMAND(gtk_WidgetFlags( obj ), GTK_SENSITIVE) != 0
		return .T.
	endif
return .F.

static function ui_showWidget( self, obj, flag )
	local widget
	if empty(obj)
		return flag
	endif
	if obj:className == "UIToolBar"
		widget := obj:widget
	else
		widget := obj
	endif
	if flag
		gtk_WidgetShow( widget )
	else
		gtk_WidgetHide( widget )
	endif
return flag

function ui_emptyFunction()
return .F.

static function ui_setPixmap(self, obj, icon)
	local o
	if valtype(obj) != "O"
		return .F.
	endif
	switch obj:className
		case "UIToolButton"
			gtk_ContainerRemove(obj:toolBar,obj)
			//?? obj:pos, obj:action, obj:tooltip,obj:isEnabled,chr(10)
			obj:action := iif(empty(obj:action),{|| .F. },obj:action)
			o := gtk_ToolBarInsertItem( obj:toolBar, NIL, obj:tooltip, NIL, icon, obj:action, obj:pos )
			obj:type := o:type
			obj:handle := o:handle
			if obj:action == NIL .or. .not. obj:isEnabled
				self:enableWidget( o, .F. )
			endif
		case "UIMenuItem"
			//gtk_image_menu_item_new_with_label
			o := gtk_ContainerChildren(obj:pic)
			gtk_ContainerRemove(obj:pic,o[1])
			gtk_ContainerRemove(obj:pic,o[2])
			gtk_BoxPackStart(obj:pic, icon)
			obj:label := strtran( obj:label, "_", "__" )
			gtk_BoxPackStart(obj:pic, gtk_LabelNew(,obj:label,"&"))
		otherwise
			?? "Warning: Unknown class ("+obj:className+") for set pixmap&\n"
	endswitch
return .T.

static function ui_createScrolledRegion(self, parent)
	local scr, o
	scr := gtk_ScrolledWindowNew()
	scr:className := "UIScrolledRegion"
	gtk_ScrolledWindowSetPlacement(scr, GTK_CORNER_TOP_LEFT)
	gtk_ScrolledWindowSetPolicy(scr, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
	gtk_BoxPackStart( parent, scr, .T., .T., 0)
	o := UIVBox(,2,5)
	gtk_ScrolledWindowAddWithViewport( scr, o )
return o

/** Grid **/

static function ui_createVBox(self, window, spacing, padding)
	local o, obj
	if valtype( window )=="O" .and. "USERSPACE" $ window
		if empty( window:userSpace )
			o := gtk_VBoxNew(,.F., spacing)
			obj := gtk_alignmentNew( , 0, 0, 1, 1 )
			o:layout := obj
			gtk_ContainerSetBorderWidth( o, padding )
			gtk_ContainerAdd( window, obj )
		else
			o := window:userSpace
		endif
	else
		o := gtk_VBoxNew(,.F., spacing)
		gtk_ContainerSetBorderWidth( o, padding )
		obj := gtk_alignmentNew( , 0, 0, 1, 1 )
		o:layout := obj
		if .not. empty(window)
			if window:className=="UIHBox" .or. window:className=="UIVBox"
				gtk_PackBoxStart( window, obj )
			else
				gtk_ContainerAdd( window, obj )
			endif
		endif
	endif
return o

static function ui_createHBox(self, window, spacing, padding)
	local o, obj
	o := gtk_HBoxNew(,.F., spacing)
	obj := gtk_alignmentNew( , 0, 0, 1, 1 )
	o:layout := obj
	gtk_ContainerSetBorderWidth( o, padding )
	if .not. empty(window)
		if window:className=="UIHBox" .or. window:className=="UIVBox"
			gtk_PackBoxStart( window, obj )
		else
			gtk_ContainerAdd( window, obj )
		endif
	endif
return o

static function ui_addBox(self, box, obj, expand, fill, padding)
	local vBox, hBox
	if "LAYOUT" $ obj
		if "SCROLL" $ obj:layout
			gtk_ScrolledWindowAddWithViewport( obj:layout, obj )
		else
			gtk_ContainerAdd( obj:layout, obj )
		endif
		if "CLASSNAME" $ obj .and. obj:classname == "UIChoice"
			gtk_ContainerAdd( obj:layout, obj:edit )
		endif
		obj := obj:layout
	endif
	if "STICK" $ obj .and. valtype(obj:stick) == "O"
		vBox := gtk_VBoxNew(,.F.)
		hBox := gtk_HBoxNew(,.F.)
		gtk_BoxPackStart( box, vBox, expand, fill, padding)
		if "TOP" $ obj:stick .and. .not. empty(obj:stick:top)
			gtk_BoxPackStart( vBox, obj:stick:top, .F., .F., padding)
		endif
		gtk_BoxPackStart( vBox, hBox, expand, fill, padding)
		if "BOTTOM" $ obj:stick .and. .not. empty(obj:stick:bottom)
			gtk_BoxPackEnd( vBox, obj:stick:bottom, .F., .F., padding)
		endif
		if "LEFT" $ obj:stick .and. .not. empty(obj:stick:left)
			gtk_BoxPackStart( hBox, obj:stick:left, .F., .F., padding)
		endif
		gtk_BoxPackStart( hBox, obj, .T., .T., padding)
		if "RIGHT" $ obj:stick .and. .not. empty(obj:stick:right)
			gtk_BoxPackEnd( hBox, obj:stick:right, .F., .F., padding)
		endif
	else
		gtk_BoxPackStart( box, obj, expand, fill, padding)
	endif
return 0

static function ui_addBoxEnd(self, box, obj, expand, fill, padding)
	local vBox, hBox
	if "LAYOUT" $ obj
		if "SCROLL" $ obj:layout
			gtk_ScrolledWindowAddWithViewport( obj:layout, obj )
		else
			gtk_ContainerAdd( obj:layout, obj )
		endif
		if "CLASSNAME" $ obj .and. obj:classname == "UIChoice"
			gtk_ContainerAdd( obj:layout, obj:edit )
		endif
		obj := obj:layout
	endif
	if "STICK" $ obj .and. valtype(obj:stick) == "O"
		vBox := gtk_VBoxNew(,.F.)
		hBox := gtk_HBoxNew(,.F.)
		gtk_BoxPackEnd( box, vBox, expand, fill, padding)
		if "TOP" $ obj:stick .and. .not. empty(obj:stick:top)
			gtk_BoxPackStart( vBox, obj:stick:top, .F., .F., padding)
		endif
		gtk_BoxPackStart( vBox, hBox, expand, fill, padding)
		if "BOTTOM" $ obj:stick .and. .not. empty(obj:stick:bottom)
			gtk_BoxPackEnd( vBox, obj:stick:bottom, .F., .F., padding)
		endif
		if "LEFT" $ obj:stick .and. .not. empty(obj:stick:left)
			gtk_BoxPackStart( hBox, obj:stick:left, .F., .F., padding)
		endif
		gtk_BoxPackStart( hBox, obj, .T., .T., padding)
		if "RIGHT" $ obj:stick .and. .not. empty(obj:stick:right)
			gtk_BoxPackEnd( hBox, obj:stick:right, .F., .F., padding)
		endif
	else
		gtk_BoxPackEnd( box, obj, expand, fill, padding)
	endif
return 0

static function ui_setBoxSpacing(self, box, spacing)
	box:spacing := spacing
	if box:className == "UIGrid"
		gtk_TableSetRowSpacings(box, spacing)
		gtk_TableSetColSpacings(box, spacing)
	else
		gtk_BoxSetSpacing(box, spacing)
	endif
return 0

static function ui_getBoxSpacing(self, box)
return box:spacing

static function ui_createGrid(self, parent, row, col, spacing, padding)
	local o, obj
	o := gtk_TableNew(, row, col, .F.)
	if .not. empty(parent)
		gtk_ContainerAdd( parent, o )
	endif
	obj := gtk_AlignmentNew( , 0, 0, 1, 1 )
	o:layout := obj
return o

static function ui_addGrid(self, box, obj, pos, h_expand, v_expand)
	local vBox, hBox, padding:=box:padding
	local a, cl, rw, l, r, t, b, hflags := GTK_FILL, vflags := GTK_FILL
	if valtype(pos) == "U"
		?? "ERROR: bad grid position&\n"
		return .F.
	endif
	a := split(pos, ",")
	if len(a) != 2
		?? "ERROR: no delimiter ',' in grid position&\n"
		return .F.
	endif
	
	// Check expand flags (+ in axes end)
	if right(a[1],1) == '+'
		a[1] := left(a[1], len(a[1])-1)
		v_expand := .T.
	endif
	if right(a[2],1) == '+'
		a[2] := left(a[2], len(a[2])-1)
		h_expand := .T.
	endif
	if valtype(h_expand) == "L" .and. h_expand
		hflags += GTK_EXPAND
	endif
	if valtype(v_expand) == "L" .and. v_expand
		vflags += GTK_EXPAND
	endif
	
	cl := split(a[1],"\-")
	rw := split(a[2],"\-")
	t := val(cl[1])
	b := iif(len(cl)==2,val(cl[2]),t)
	l := val(rw[1])
	r := iif(len(rw)==2,val(rw[2]),l)
	if "LAYOUT" $ obj
		if "SCROLL" $ obj:layout
			gtk_ScrolledWindowAddWithViewport( obj:layout, obj )
		else
			gtk_ContainerAdd( obj:layout, obj )
		endif
		if "CLASSNAME" $ obj .and. obj:classname == "UIChoice"
			gtk_ContainerAdd( obj:layout, obj:edit )
		endif
		obj := obj:layout
	endif
	if "STICK" $ obj .and. valtype(obj:stick) == "O"
		vBox := gtk_VBoxNew(,.F.)
		hBox := gtk_HBoxNew(,.F.)
		gtk_TableAttach( box, vBox, l, r+1, t, b+1, hflags, vflags, box:padding*2, box:padding )
		if "TOP" $ obj:stick .and. .not. empty(obj:stick:top)
			gtk_BoxPackStart( vBox, obj:stick:top, .F., .F., padding)
		endif
		gtk_BoxPackStart( vBox, hBox, v_expand, .T., padding)
		if "BOTTOM" $ obj:stick .and. .not. empty(obj:stick:bottom)
			gtk_BoxPackEnd( vBox, obj:stick:bottom, .F., .F., padding)
		endif
		if "LEFT" $ obj:stick .and. .not. empty(obj:stick:left)
			gtk_BoxPackStart( hBox, obj:stick:left, .F., .F., padding)
		endif
		gtk_BoxPackStart( hBox, obj, .T., .T., padding)
		if "RIGHT" $ obj:stick .and. .not. empty(obj:stick:right)
			gtk_BoxPackEnd( hBox, obj:stick:right, .F., .F., padding)
		endif
	else
		gtk_TableAttach( box, obj, l, r+1, t, b+1, hflags, vflags, box:padding*2, box:padding )
	endif
return NIL

static function ui_setBoxAlignment(self, box, align, valign)
	local al
	/* Elements alignment in the box:
	x:	ALIGN_LEFT	0
		ALIGN_CENTER	1
		ALIGN_RIGHT	2
		ALIGN_JUSTIFY	3
	y:	ALIGN_TOP	0
		ALIGN_MIDDLE	1
		ALIGN_BOTTOM	2
	*/
	align  :=iif(valtype(align) != 'N', 0, align)
	valign :=iif(valtype(valign) != 'N', 0, valign)

	gtk_alignmentSet( box:layout, align/2, valign/2, 0, 0 )

return NIL

static function ui_setBoxElemEqualSize(self, box, isEqual)
	gtk_boxSetHomogeneous( box, isEqual )
return NIL

/* Create splitter with two adjustable panes */
static function ui_createSplitter(self, type)
	local o
	if type == SPLITTER_HORIZONTAL
		o := gtk_VPanedNew()
	else
		o := gtk_HPanedNew()
	endif
	gtk_PanedSetPosition(o, 100)
return o

/* Add widget to left/top pane */
static function ui_addSplitPane(self, pane, obj)
	local vBox, hBox
	if "LAYOUT" $ obj
		if "SCROLL" $ obj:layout
			gtk_ScrolledWindowAddWithViewport( obj:layout, obj )
		else
			gtk_ContainerAdd( obj:layout, obj )
		endif
		if "CLASSNAME" $ obj .and. obj:classname == "UIChoice"
			gtk_ContainerAdd( obj:layout, obj:edit )
		endif
		obj := obj:layout
	endif
	if "STICK" $ obj .and. valtype(obj:stick) == "O"
		vBox := gtk_VBoxNew(,.F.)
		hBox := gtk_HBoxNew(,.F.)
		gtk_PanedAdd1(pane, vBox)
		if "TOP" $ obj:stick .and. .not. empty(obj:stick:top)
			gtk_BoxPackStart( vBox, obj:stick:top, .F., .F.)
		endif
		gtk_BoxPackStart( vBox, hBox, .T., .T.)
		if "BOTTOM" $ obj:stick .and. .not. empty(obj:stick:bottom)
			gtk_BoxPackEnd( vBox, obj:stick:bottom, .F., .F.)
		endif
		if "LEFT" $ obj:stick .and. .not. empty(obj:stick:left)
			gtk_BoxPackStart( hBox, obj:stick:left, .F., .F.)
		endif
		gtk_BoxPackStart( hBox, obj, .T., .T.)
		if "RIGHT" $ obj:stick .and. .not. empty(obj:stick:right)
			gtk_BoxPackEnd( hBox, obj:stick:right, .F., .F.)
		endif
	else
		gtk_PanedAdd1(pane, obj)
	endif
return NIL

/* Add widget to right/bottom pane */
static function ui_addSplitPaneEnd(self, pane, obj)
	local vBox, hBox
	if "LAYOUT" $ obj
		if "SCROLL" $ obj:layout
			gtk_ScrolledWindowAddWithViewport( obj:layout, obj )
		else
			gtk_ContainerAdd( obj:layout, obj )
		endif
		if "CLASSNAME" $ obj .and. obj:classname == "UIChoice"
			gtk_ContainerAdd( obj:layout, obj:edit )
		endif
		obj := obj:layout
	endif
	if "STICK" $ obj .and. valtype(obj:stick) == "O"
		vBox := gtk_VBoxNew(,.F.)
		hBox := gtk_HBoxNew(,.F.)
		gtk_PanedAdd2(pane, vBox)
		if "TOP" $ obj:stick .and. .not. empty(obj:stick:top)
			gtk_BoxPackStart( vBox, obj:stick:top, .F., .F.)
		endif
		gtk_BoxPackStart( vBox, hBox, .T., .T.)
		if "BOTTOM" $ obj:stick .and. .not. empty(obj:stick:bottom)
			gtk_BoxPackEnd( vBox, obj:stick:bottom, .F., .F.)
		endif
		if "LEFT" $ obj:stick .and. .not. empty(obj:stick:left)
			gtk_BoxPackStart( hBox, obj:stick:left, .F., .F.)
		endif
		gtk_BoxPackStart( hBox, obj, .T., .T.)
		if "RIGHT" $ obj:stick .and. .not. empty(obj:stick:right)
			gtk_BoxPackEnd( hBox, obj:stick:right, .F., .F.)
		endif
	else
		gtk_PanedAdd2(pane, obj)
	endif
return NIL

/* Add widget to left/top pane */
static function ui_setSplitterPosition(self, pane, pos)
	gtk_PanedSetPosition(pane, pos)
return NIL


/** Button **/

static function ui_createButton(self, label, action)
	local o
	if valtype(label) != "C"
		label:=""
	endif
	label := strtran( label, "_", "__" )
	o := gtk_ButtonNew(, " "+label+" ", "&")
	if .not. empty(action)
		gtk_SignalConnectAfter(o, GTK_CLICKED_SIGNAL, action)
	else
		ui_enableWidget( self, o, .F.)
	endif
return o

static function ui_setPadding(self, object, padding)
	gtk_ContainerSetBorderWidth( object, padding )
return 0

static function ui_setButtonText(self, object, text)
	gtk_ButtonSetLabel( object, " "+text+" " )
return 0

/** Table **/

static function ui_createTable(self, columns)
	local o, i, cc, store, model, renderer, c, frame, column, ic
	local t, types:={}, x, searchColumn:=0, addColumns:=0

	frame := gtk_ScrolledWindowNew()
	gtk_ScrolledWindowSetPolicy( frame, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
	gtk_ScrolledWindowSetShadowType( frame, GTK_SHADOW_IN )

	cc := len(columns)
	for column in columns
		if valtype(column) == 'O' .and. 'TYPE' $ column
			if 'LOOKUP' $ column .and. column:lookup .and. searchColumn == 0
				searchColumn := len(types) + 1
			endif
			switch column:type
				case TABLE_COLUMN_TEXT
					t := TREE_TYPE_STRING
				case TABLE_COLUMN_CHOICE
					t := TREE_TYPE_STRING
					addColumns++
				case TABLE_COLUMN_COMBO
					t := TREE_TYPE_STRING
				case TABLE_COLUMN_NUMBER
					t := TREE_TYPE_NUMERIC_FLOAT
				case TABLE_COLUMN_DATE
					t := TREE_TYPE_DATE
				case TABLE_COLUMN_CHECK
					t := TREE_TYPE_LOGICAL
				case TABLE_COLUMN_COUNTER
					t := TREE_TYPE_NUMERIC
				otherwise
					t := TREE_TYPE_STRING
			endswitch
		else
			t := TREE_TYPE_STRING
		endif
		aadd( types, t )
	next
	aadd( types, TREE_TYPE_LOGICAL )
	aadd( types, TREE_TYPE_NUMERIC_FLOAT )
	aadd( types, TREE_TYPE_STRING )
	
	// Create columns for choice cell text 
	if addColumns > 0
		for i:=1 to addColumns
			aadd( types, TREE_TYPE_STRING )
		next
	endif
	
	store := gtk_ListStoreNew(, len(types), types)
	if empty(store)
		return NIL
	endif
	model := gtk_TreeModel(store)
	o := gtk_TreeViewNewWithModel(,model)

	gtk_TreeViewSetHeadersVisible(o, .T.)
	gtk_TreeViewSetRulesHint (o, .T.)
	gtk_TreeSelectionSetMode(gtk_TreeViewGetSelection(o), GTK_SELECTION_SINGLE)

	o:store := store
	o:model := model
	
	addColumns := cc + 3
	// Append columns
	for i:=1 to cc
		column := columns[i]
		if column:type == TABLE_COLUMN_CHECK
			renderer = gtk_CellRendererToggleNew ()
			c := gtk_TreeViewInsertColumnWithAttributes(o, -1, column:caption, renderer, ;
					"active", i)
			ic := gtk_TreeViewGetColumn(o, c)
		else
			renderer = gtk_CellRendererTextNew ()
			if column:type == TABLE_COLUMN_CHOICE
				addColumns++
				columns[i]:__text := addColumns
				c := gtk_TreeViewInsertColumnWithAttributes(o, -1, column:caption, renderer, ;
						"text", addColumns)
			else
				c := gtk_TreeViewInsertColumnWithAttributes(o, -1, column:caption, renderer, ;
						"text", i)
			endif
			ic := gtk_TreeViewGetColumn(o, c)
			if .not. empty(column:format) .and. column:type == TABLE_COLUMN_NUMBER
				gtk_TreeViewColumnSetFormat(ic, renderer, c, column:format)
			endif
			if column:type == TABLE_COLUMN_NUMBER .or. column:type == TABLE_COLUMN_COUNTER
					gtk_TreeViewColumnSetAttributes(ic, renderer, "text", i, "xalign", cc+2)
			endif
		endif
		gtk_TreeViewColumnSetResizable(ic, .T.)
		//gtk_TreeViewColumnSetExpand(ic, .T.)
		columns[i]:__obj := ic
	next
	//	gtk_TreeViewSetExpanderColumn(o, NIL)
	//	gtk_TreeViewSetHoverSelection(o, .T.) // Cool effect!
	if searchColumn != 0
		gtk_TreeViewSetSearchColumn(o, searchColumn)
	endif
	o:columns := columns
	o:columnId := cc+3
	o:layout := frame
return o

static function ui_addTableRow(self, table, data, id)
	local row, i, item:=map()
	row := gtk_ListStoreAppend(table:store)
	//?? 'add table row:', data, chr(10)
	for i:=1 to len( data )
		ui_setTableValue(table, row, i, data[i])
	next
	i := len(table:columns)
	gtk_ListStoreSetValue(table:store, row, i+1, .T.)
	gtk_ListStoreSetValue(table:store, row, i+2, 1.0)
	gtk_ListStoreSetValue(table:store, row, table:columnId, id)
return row

/* Set data for table row */
static function ui_setTableRow(self, table, row, data, id)
	local i, c
	if valtype(row) == 'N'
		row := ltrim(str(row-1))
	endif
	if valtype(data) == 'A'
		for i:=1 to len( data )
			ui_setTableValue(table, row, i, data[i])
		next
	elseif valtype(data) == 'O'
		for i:=1 to len( table:columns )
			c := upper(table:columns[i]:name)
			ui_setTableValue(table, row, i, data[c])
		next
	endif
	gtk_ListStoreSetValue(table:store, row, table:columnId, id)
return NIL

/* Get data from table row as object */
static function ui_getTableRow(self, table, row)
	local o:=map(), i, cc, c, v:=''
	
	// Normalize row
	if valtype(row) == 'N'
		row := ltrim(str(row-1))
	elseif valtype(row) == 'U'
		row := ui_getEditTableSelection(self, table)
	endif
	
	if valtype(row) == 'U' // If there is no selected row in table
		return NIL
	endif
	
	// Get row as object
	cc := len( table:columns )
	for i:=1 to cc
		c := table:columns[i]:name
		o[upper(c)] := ui_getTableValue(table, row, i, v)
	next
return o

/* Remove table row */
static function ui_removeTableRow(self, table, row)
	local num, total
	if valtype(row) == 'N'
		num := row
		row := ltrim(str(row-1))
	else
		num := 0 + row
	endif
	total := self:getEditTableRowCount(table)
	if num <= total
		gtk_ListStoreRemove(table:store, row)
	endif
return NIL

static function ui_clearTable(self, table)
	gtk_ListStoreClear( table:store )
return NIL

static function ui_getTableSelection(self, table, needId)
	local s, iter, path, pathstr, v:=''
	s := gtk_TreeViewGetSelection( table )
	gtk_TreeSelectionGetSelected(s, NIL, @iter)
	if iter == NIL
		return NIL
	endif
	path := gtk_TreeModelGetPath(gtk_TreeViewGetModel( table ), iter)
	pathstr := gtk_TreePathToString(path)
	if valtype(needId) == 'L' .and. needId
		gtk_TreeModelGetFromPathString( gtk_TreeViewGetModel( table ), pathstr, table:columnId, @v, -1 )
		return v
	endif
return pathstr

static function ui_setTableSelection( self, table, id )
	local t, i, r:=NIL, v
	
	if valtype(id) != 'C'
		return
	endif
	
	t := 0 + gtk_TreeModelIterNChildren( gtk_TreeViewGetModel( table ), NIL )
	for i:=1 to t
		v := ''
		gtk_TreeModelGetFromPathString( gtk_TreeViewGetModel( table ), ltrim(str(i-1)), table:columnId, @v, -1 )
		if v == id
			r := ltrim(str(i-1))
			exit
		endif
	next
	if .not. empty(r)
		gtk_TreeViewSetCursor(table, gtk_TreePathNewFromString(r), NIL, .F.)
	endif
return


static function ui_setTableSelectAction( self, table, action )
	self:setAction( table, "row-activated", action )
return

static function ui_conditionTableSelection(self, table, event)
return .T.

static function ui_getTablePosition(self, table)
	local pos
	pos := array(2)
	pos[1] := table:getSelection()
	pos[2] := table:getValue()
return pos

static function ui_setTablePosition(self, table, pos)
	local r
	if .not. empty(pos[1])
		r := gtk_TreePathNewFromString(pos[1])
		gtk_TreeViewSetCursor(table, r, NIL, .F.)
	endif
return NIL

/** Edit **/

static function ui_createEdit(self, defValue)
	local o
	o := gtk_EntryNew()
	if .not. empty(defValue)
		gtk_EntrySetText(o, defValue)
	endif
	gtk_EntrySetEditable(o, .T.)
return o

static function ui_createEditText(self, defValue)
	local o, frame, buf
	frame := gtk_ScrolledWindowNew()
	gtk_ScrolledWindowSetPolicy( frame, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
	gtk_ScrolledWindowSetShadowType( frame, GTK_SHADOW_IN )

	buf := gtk_TextBufferNew()
	o := gtk_TextViewNewWithBuffer(, buf )
	o:layout := frame

	gtk_TextViewSetEditable(o, .T.)
	gtk_TextViewSetLeftMargin(o, 2)
	gtk_TextViewSetRightMargin(o, 2)
return o

static function ui_editSetReadOnly(self, o, flag)
	local sd, st
	if o:className == "UIEdit"
		gtk_EntrySetEditable(o, .not. flag)
	else
		gtk_TextViewSetEditable(o, .not. flag)
	endif
	o:style := map()
	sd := gtk_WidgetGetDefaultStyle(o)
	o:style:BASE_color := sd:BG_color
	gtk_WidgetSetStyle(o, o:style)
return NIL

static function ui_editSetPassword(self, o, flag)
	gtk_EntrySetVisibility(o, .not. flag)
return NIL

/** Label **/
static function ui_createLabel(self, defValue)
	local o
	if valtype(defValue) != "U"
		defValue := strtran( defValue, "_", "__" )
	endif
	o := gtk_LabelNew(, defValue, "&")
	gtk_LabelSetJustify( o, GTK_JUSTIFY_LEFT)
	gtk_MiscSetAlignment( o, 0, 0.5)
return o

static function ui_setLabelText(self, label, text)
	gtk_LabelSetText(label, text)
return NIL

/** Frame **/
static function ui_createFrame(self, caption, type)
	local o, eBox
	eBox := gtk_FrameNew(, caption)
	o := gtk_EventBoxNew()
	o:layout := eBox
	self:setFrameType(o, type)
return o

static function ui_setFrameGrid(self, frame, grid)
	gtk_ContainerAdd( frame, grid )
return NIL

static function ui_setFrameLabel(self, frame, label)
	gtk_FrameSetLabel( frame:layout, label )
return NIL

static function ui_setFrameType(self, frame, type)
	if valtype(type) == 'N'
		gtk_FrameSetShadowType( frame:layout, type )
	endif
return NIL

/** ComboBox **/
static function ui_createComboBox(self, values)
	local o

	//o := gtk_ComboBoxEntryNewText() // Editable combobox
	o := gtk_ComboBoxNewText()
	gtk_ComboBoxSetFocusOnClick(o, .T.)
	// self:setComboBoxList(o, values)
return o

static function ui_setComboBoxList(self, o, values)
	local i, row
	for i in values
		gtk_ComboBoxAppendText(o,i[1])
	next
return o

/** RadioGroup **/
// Create radio group
static function ui_createRadioGroup(self)
	local o:= gtk_RadioGroupNew()
return o

/** RadioButton **/
// Create radio button
static function ui_createRadioButton(self, rg, text)
	local o:= gtk_RadioButtonNew(, rg, text)
return o

/** CheckBox **/
static function ui_createCheckBox(self, value, label)
	local o
	label := strtran( label, "_", "__" )
	o := gtk_CheckButtonNew(, label, "&" )
	if valtype(value) == 'L'
		gtk_ToggleButtonSetActive( o, value)
	endif
return o

/** Values **/
static function ui_setValue(self, o, value, append)
	local a, iter

	append := iif( valtype(append) == 'L' .and. append, .T., .F. )
	switch o:className
		case "UILabel"
			o:setValue( value )

		case "UIChoice"
			gtk_EntrySetText( o, value )
		
		case "UIEdit"
			if append
				gtk_EntryAppendText( o, value )
			else
				gtk_EntrySetText( o, value )
			endif

		case "UIEditText"
			if append
				gtk_TextBufferGetEndIter( gtk_TextViewGetBuffer(o), @iter )
				gtk_TextBufferInsert( gtk_TextViewGetBuffer(o), iter, value)
			else
				gtk_TextBufferSetText( gtk_TextViewGetBuffer(o), value )
			endif

		case "UIComboBox"
			gtk_ComboBoxSetActive( o, value )

		case "UICheckBox"
			gtk_ToggleButtonSetActive( o, value)

		case "UIRadioButton"
			gtk_ToggleButtonSetActive( o, value)

		case "UISlider"
			a := gtk_ScaleGetAdjustment(o)
			gtk_AdjustmentSetValue(a, val(value))
			
		case "UIEditTable"
			o:clear()
			for iter in value
				o:addRow( iter )
			next

		otherwise
			?? "ERROR: couldn't set value to non-valued widget: "+o:className+CHR(10)
			return NIL
	endswitch
return NIL

static function ui_setStyle(self, o, style, value, element)
	local a, n, align, ost, st, font

	// ?? "STYLE ",style,":",value,chr(10)
//	ost := gtk_WidgetGetStyle( o )
	st := map()

	// Alignment
	if style == "align"
		align := map()
		align["LEFT"]    := GTK_JUSTIFY_LEFT
		align["RIGHT"]   := GTK_JUSTIFY_RIGHT
		align["CENTER"]  := GTK_JUSTIFY_CENTER
		align["JUSTIFY"] := GTK_JUSTIFY_FILL
		if o:className == "UITable" .and. .not. empty(element)
			a := split(element,"\.")
			if len(a) > 1 .and. a[1] == "column"
				n := val(a[2])
//TODO: deprecated in GTK+ 2.x
//				gtk_CListSetColumnJustification(o, n, mapget(align,upper(value),GTK_JUSTIFY_LEFT))
				return .T.
			endif
		endif
	endif

	// Font
	if left(style,5) == "font."
		style := substr(style,6)
		if .not. "FONT" $ o
			o:font := UIFont()
		endif
		o:font:setProperty(style,value)
		gtk_WidgetModifyFont(o, o:font:font)
		return .T.
	endif

	// Color
	if left(style,6) == "color."
		/* TODO: Set states of widget while color change
		GTK_STATE_NORMAL,
		GTK_STATE_ACTIVE,
		GTK_STATE_PRELIGHT,
		GTK_STATE_SELECTED,
		GTK_STATE_INSENSITIVE
		*/
		style := substr(style,7)
		switch upper(style)
			case 'FG'
				gtk_WidgetModifyFG(o, UIColor(value), GTK_STATE_NORMAL )
			case 'BG'
				gtk_WidgetModifyBG(o, UIColor(value), GTK_STATE_NORMAL )
			case 'TEXT'
				gtk_WidgetModifyText(o, UIColor(value), GTK_STATE_NORMAL )
			case 'BASE'
				gtk_WidgetModifyBase(o, UIColor(value), GTK_STATE_NORMAL )
		endswitch
		return .T.
	endif

	// Background picture
	if style == "background"
		st:bg_pixmap_name := value
		gtk_WidgetModifyStyle(o, st, GTK_STATE_NORMAL)
		return .T.
	endif


	?? "Style unsupported: '"+style+"'='"+iif(valtype(value)=="C",value,"")+"'&\n"
return .F.

static function ui_getValue(self, o)
	local val:=NIL, a, i, rows, cols, start, end
	switch o:className
		case "UILabel"
			val := o:getValue()

		case "UIChoice"
			val := gtk_EntryGetText( o )
		
		case "UIEdit"
			val := gtk_EntryGetText( o )

		case "UIEditText"
			gtk_TextBufferGetBounds (gtk_TextViewGetBuffer(o), @start, @end)
			val := gtk_TextIterGetText (start, end)

		case "UIComboBox"
			val := gtk_ComboBoxGetActive( o )

		case "UICheckBox"
			val := gtk_ToggleButtonGetActive( o )

		case "UIRadioButton"
			val := gtk_ToggleButtonGetActive( o )

		case "UISlider"
			a := gtk_ScaleGetAdjustment(o)
			gtk_AdjustmentGetValue(a, @val)

		case "UIEditTable"
			rows := o:getRowCount()
			val := array(rows)
			for i:=1 to rows
				val[i] := o:getField(NIL,i)
			next
		
		otherwise
			?? "ERROR: couldn't get value from non-valued widget: "+o:className+CHR(10)
			val := NIL
	endswitch
return val

static function ui_setAction(self, o, signal, action)
	gtk_signalConnectAfter(o, signal, action)
return NIL

static function ui_getChildren(self, o)
return gtk_containerChildren( o )

/* Set accelerator key for widget */
static function ui_setKey(self, o, win, xKey)
	local oKey, accel_mods := 0, accel_flags := GTK_ACCEL_VISIBLE

	if valtype(xKey) == "C"
		oKey := self:getKeyCode(xKey)
	elseif valtype(xKey) == "O"
		oKey := xKey
	else
		return .f.
	endif
	if empty(oKey:code)
		return .f.
	endif
	if oKey:alt
		accel_mods := GDK_MOD1_MASK
	elseif oKey:shift
		accel_mods := GDK_SHIFT_MASK
	elseif oKey:ctrl
		accel_mods := GDK_CONTROL_MASK
	endif
//	TODO: push accel to accel poll (see widget.c - bug in accel_group, window required)
//	gtk_WidgetAddAccelerator(o, GTK_ACTIVATE_ITEM_SIGNAL, win, oKey:code, accel_mods, accel_flags)
// 	TODO: need to accel button and linked to label input fields
// 	TODO: need to append key to menu item
return .t.

/* Remove accelerator key for widget */
static function ui_unSetKey(self, o, win, cKey)
	local oKey, accel_mods := 0

	oKey := self:getKeyCode(cKey)
	if empty(oKey:code)
		return .f.
	endif

	if oKey:alt
		accel_mods := GDK_MOD1_MASK
	elseif oKey:shift
		accel_mods := GDK_SHIFT_MASK
	elseif oKey:ctrl
		accel_mods := GDK_CONTROL_MASK
	endif
	gtk_WidgetRemoveAccelerator(o, win, oKey:code, accel_mods)
// 	TODO: need to remove key from menu item
return .t.

/* Convert combination key to key object */
static function ui_getKeyCode(self, cKey, action)
	local oKey := map(), nIndex, cToken, cMainKey := '', cModKey := ''

	oKey:alt	:= .f.
	oKey:ctrl	:= .f.
	oKey:shift	:= .f.
	oKey:code	:= nil
	oKey:action	:= action

	if valtype(cKey) == "N"
		oKey:code := cKey
		oKey:keyval := cKey
//		cModKey	+= iif(oKey:alt,  "ALT_", "")
//		cModKey	+= iif(oKey:ctrl, "CTRL_","")
//		cModKey	+= iif(oKey:shift,"SH_",  "")
		oKey:keyval := oKey:code + 192
	else
		for nIndex := 1 to numtoken(cKey,, 1)
			cToken := token(cKey,, nIndex, 1)
			do switch upper(cToken)
				case "ALT"
					oKey:alt	:= .t.
					cModKey	:= "ALT_"
				case "CTRL"
					oKey:ctrl	:= .t.
					cModKey	:= "CTRL_"
				case "SHIFT"
					oKey:shift	:= .t.
					cModKey	:= "SH_"
				otherwise
					cMainKey := UPPER(cToken)
					oKey:code := gdk_keyValFromName(cToken)
			end switch
		next
		oKey:keyval := keycodeByName("K_"+cModKey+cMainKey)
	endif
return oKey

static function ui_conversionLetter( letter )
	local i, l
	local al_ru := "?????????????????????????????????"
	local al_tr := "F,DULT`;PBQRKVYJGHCNEA[WXIO]SM'.Z"

	l := upper(letter)
	i := at( l, al_ru )
return iif(i>0, al_tr[i], l)

static function ui_conversionKey(nCode)
	local nNewCode := nCode

	switch nCode
		case 1040, 1072 // '?', '?'
			nNewCode := GDK_Cyrillic_a
		case 1041, 1073 // '?', '?'
			nNewCode := GDK_Cyrillic_be
		case 1042, 1074 // '?', '?'
			nNewCode := GDK_Cyrillic_ve
		case 1043, 1075 // '?', '?'
			nNewCode := GDK_Cyrillic_ghe
		case 1044, 1076 // '?', '?'
			nNewCode := GDK_Cyrillic_de
		case 1045, 1077 // '?', '?'
			nNewCode := GDK_Cyrillic_je
		case 1025, 1105 // '?', '?'
			nNewCode := GDK_Cyrillic_io
		case 1046, 1078 // '?', '?'
			nNewCode := GDK_Cyrillic_zhe
		case 1047, 1079 // '?', '?'
			nNewCode := GDK_Cyrillic_ze
		case 1048, 1080 // '?', '?'
			nNewCode := GDK_Cyrillic_i
		case 1049, 1081 // '?', '?'
			nNewCode := GDK_Cyrillic_shorti
		case 1050, 1082 // '?', '?'
			nNewCode := GDK_Cyrillic_ka
		case 1051, 1083 // '?', '?'
			nNewCode := GDK_Cyrillic_el
		case 1052, 1084 // '?', '?'
			nNewCode := GDK_Cyrillic_em
		case 1053, 1085 // '?', '?'
			nNewCode := GDK_Cyrillic_en
		case 1054, 1086 // '?', '?'
			nNewCode := GDK_Cyrillic_o
		case 1055, 1087 // '?', '?'
			nNewCode := GDK_Cyrillic_pe
		case 1056, 1088 // '?', '?'
			nNewCode := GDK_Cyrillic_er
		case 1057, 1089 // '?', '?'
			nNewCode := GDK_Cyrillic_es
		case 1058, 1090 // '?', '?'
			nNewCode := GDK_Cyrillic_te
		case 1059, 1091 // '?', '?'
			nNewCode := GDK_Cyrillic_u
		case 1060, 1092 // '?', '?'
			nNewCode := GDK_Cyrillic_ef
		case 1061, 1093 // '?', '?'
			nNewCode := GDK_Cyrillic_ha
		case 1062, 1094 // '?', '?'
			nNewCode := GDK_Cyrillic_tse
		case 1063, 1095 // '?', '?'
			nNewCode := GDK_Cyrillic_che
		case 1064, 1096 // '?', '?'
			nNewCode := GDK_Cyrillic_sha
		case 1065, 1097 // '?', '?'
			nNewCode := GDK_Cyrillic_shcha
		case 1066, 1098 // '?', '?'
			nNewCode := GDK_Cyrillic_hardsign
		case 1067, 1099 // '?', '?'
			nNewCode := GDK_Cyrillic_yeru
		case 1068, 1100 // '?', '?'
			nNewCode := GDK_Cyrillic_softsign
		case 1069, 1101 // '?', '?'
			nNewCode := GDK_Cyrillic_e
		case 1070, 1102 // '?', '?'
			nNewCode := GDK_Cyrillic_yu
		case 1071, 1103 // '?', '?'
			nNewCode := GDK_Cyrillic_ya
	end switch
return nNewCode

static function ui_setKeyEvent(self, wid)
	self:setAction( wid, "key-press-event", {|wid,e| ui_runKeyEvent(wid, e)} )
return .t.

static function ui_runKeyEvent(wid, event)
	local i
	if "KEYEVENTS" $ wid
		if (i := ascan(wid:keyEvents, {|ev| ev:keyval == event:keyval})) <> 0
			eval(wid:keyEvents[i]:action, wid, event:keyval)
			return .t.
		endif
	endif
return NIL

/** Tree **/

static function ui_createTree(self, columns, nTreeColumn)
	local o, i, cc, store, model, renderer, c, frame, column, ic
	local t, types:={}, x, searchColumn:=0, addColumns:=0
	
	nTreeColumn := iif(empty(nTreeColumn),1,nTreeColumn)

	frame := gtk_ScrolledWindowNew()
	gtk_ScrolledWindowSetPolicy( frame, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
	gtk_ScrolledWindowSetShadowType( frame, GTK_SHADOW_IN )

	cc := len(columns)
	for column in columns
		if valtype(column) == 'O' .and. 'TYPE' $ column
			if 'LOOKUP' $ column .and. column:lookup .and. searchColumn == 0
				searchColumn := len(types) + 1
			endif
			switch column:type
				case TABLE_COLUMN_TEXT
					t := TREE_TYPE_STRING
				case TABLE_COLUMN_CHOICE
					t := TREE_TYPE_STRING
					addColumns++
				case TABLE_COLUMN_COMBO
					t := TREE_TYPE_STRING
				case TABLE_COLUMN_NUMBER
					t := TREE_TYPE_NUMERIC_FLOAT
				case TABLE_COLUMN_DATE
					t := TREE_TYPE_DATE
				case TABLE_COLUMN_CHECK
					t := TREE_TYPE_LOGICAL
				case TABLE_COLUMN_COUNTER
					t := TREE_TYPE_NUMERIC
				otherwise
					t := TREE_TYPE_STRING
			endswitch
		else
			t := TREE_TYPE_STRING
		endif
		aadd( types, t )
	next
	aadd( types, TREE_TYPE_LOGICAL )
	aadd( types, TREE_TYPE_NUMERIC_FLOAT )
	aadd( types, TREE_TYPE_STRING )
	
	// Create columns for choice cell text 
	if addColumns > 0
		for i:=1 to addColumns
			aadd( types, TREE_TYPE_STRING )
		next
	endif
	
	store := gtk_TreeStoreNew(, len(types), types)
	if empty(store)
		return NIL
	endif
	model := gtk_TreeModel(store)
	o := gtk_TreeViewNewWithModel(,model)

	gtk_TreeViewSetHeadersVisible(o, .T.)
	gtk_TreeViewSetRulesHint (o, .T.)
	gtk_TreeSelectionSetMode(gtk_TreeViewGetSelection(o), GTK_SELECTION_SINGLE)

	o:store := store
	o:model := model
	
	addColumns := cc + 3
	// Append columns
	for i:=1 to cc
		column := columns[i]
		if column:type == TABLE_COLUMN_CHECK
			renderer = gtk_CellRendererToggleNew ()
			c := gtk_TreeViewInsertColumnWithAttributes(o, -1, column:caption, renderer, ;
					"active", i)
			ic := gtk_TreeViewGetColumn(o, c)
		else
			renderer = gtk_CellRendererTextNew ()
			if column:type == TABLE_COLUMN_CHOICE
				addColumns++
				columns[i]:__text := addColumns
				c := gtk_TreeViewInsertColumnWithAttributes(o, -1, column:caption, renderer, ;
						"text", addColumns)
			else
				c := gtk_TreeViewInsertColumnWithAttributes(o, -1, column:caption, renderer, ;
						"text", i)
			endif
			ic := gtk_TreeViewGetColumn(o, c)
			if .not. empty(column:format) .and. column:type == TABLE_COLUMN_NUMBER
				gtk_TreeViewColumnSetFormat(ic, renderer, c, column:format)
			endif
			if column:type == TABLE_COLUMN_NUMBER .or. column:type == TABLE_COLUMN_COUNTER
					gtk_TreeViewColumnSetAttributes(ic, renderer, "text", i, "xalign", cc+2)
			endif
		endif
		gtk_TreeViewColumnSetResizable(ic, .T.)
		//gtk_TreeViewColumnSetExpand(ic, .T.)
		columns[i]:__obj := ic
	next
	//	gtk_TreeViewSetExpanderColumn(o, NIL)
	//	gtk_TreeViewSetHoverSelection(o, .T.) // Cool effect!
	if searchColumn != 0
		gtk_TreeViewSetSearchColumn(o, searchColumn)
	endif
	o:columns := columns
	o:columnId := cc+3
	o:layout := frame
return o

/* Wrappers for combobox and choice tree cell values */
static function ui_setTreeValue(tree, row, column, value)
	local c
	c := tree:columns[column]
	
	if c:type == TABLE_COLUMN_COMBO .and. valtype(c:source) == 'O'
		value := c:source:getText(value)
	endif
	
	//?? 'set value:', row, column, value, chr(10)
	gtk_TreeStoreSetValue(tree:store, row, column, value)

	if c:type == TABLE_COLUMN_CHOICE .and. valtype(c:source) == 'O' .and. "__TEXT" $ c
		gtk_TreeStoreSetValue(tree:store, row, c:__text, c:source:getText(value))
	endif
	
return value

static function ui_getTreeValue(tree, row, column, value)
	local c, v
	c := tree:columns[column]
	v := c:default	
	
	gtk_TreeModelGetFromPathString( gtk_TreeViewGetModel( tree ), row, column, @value, -1 )
	
	if c:type == TABLE_COLUMN_COMBO .and. valtype(c:source) == 'O'
		value := c:source:getValueByText(value)
	endif
	
return value

static function ui_addTreeNode(self, tree, parent, sibling, data, expanded, id)
	local row, i, c, major, minor, path
	/* TODO: addTreeNode(): sibling */
	row := gtk_TreeStoreAppend( tree:store, parent )
	
	if valtype(data) == 'A'
		for i:=1 to len( data )
			ui_setTreeValue(tree, row, i, data[i])
		next
	elseif valtype(data) == 'O'
		for i:=1 to len( tree:columns )
			c := upper(tree:columns[i]:name)
			ui_setTreeValue(tree, row, i, data[c])
		next
	endif
	gtk_TreeStoreSetValue(tree:store, row, tree:columnId, id)
	path := gtk_TreePathNewFromString( row )

	gtk_Version(@major, @minor)
	if (expanded == NIL .or. expanded) .and. major>=2 .and. minor>=2
		gtk_TreeViewExpandToPath( tree, path )
	endif
return row

/* Set data for tree row */
static function ui_setTreeRow(self, tree, row, data, id)
	local i, c
	if valtype(data) == 'A'
		for i:=1 to len( data )
			ui_setTreeValue(tree, row, i, data[i])
		next
	elseif valtype(data) == 'O'
		for i:=1 to len( tree:columns )
			c := upper(tree:columns[i]:name)
			ui_setTreeValue(tree, row, i, data[c])
		next
	endif
	gtk_TreeStoreSetValue(tree:store, row, tree:columnId, id)
return NIL

/* Get data from tree row as object */
static function ui_getTreeRow(self, tree, row)
	local o:=map(), i, cc, c, v:=''
	
	// Normalize row
	if valtype(row) == 'U'
		row := ui_getTreeSelection(self, tree)
	endif
	
	if valtype(row) == 'U' // If there is no selected row in tree
		return NIL
	endif
	
	// Get row as object
	cc := len( tree:columns )
	for i:=1 to cc
		c := tree:columns[i]:name
		o[upper(c)] := ui_getTreeValue(tree, row, i, v)
	next
return o

/* Remove tree row */
static function ui_removeTreeRow(self, tree, row)
	gtk_TreeStoreRemove(tree:store, row)
return NIL

static function ui_setTreeSelectAction( self, tree, action )
	self:setAction( tree, "row-activated", action )
return

static function ui_getTreeSelection(self, tree, needId)
	local s, iter, path, pathstr, v:=''
	s := gtk_TreeViewGetSelection( tree )
	gtk_TreeSelectionGetSelected(s, NIL, @iter)
	if iter == NIL
		return NIL
	endif
	path := gtk_TreeModelGetPath(gtk_TreeViewGetModel( tree ), iter)
	pathstr := gtk_TreePathToString(path)
	if valtype(needId) == 'L' .and. needId
		gtk_TreeModelGetFromPathString( gtk_TreeViewGetModel( tree ), pathstr, tree:columnId, @v, -1 )
		return v
	endif
return pathstr

function ui_treeForeach( model, path, iter, column, id, result )
	local v:='', p
	path := gtk_TreePathToString(path)
	//?? "node:", path, iter, chr(10)
	gtk_TreeModelGetFromPathString( model, path, column, @v, -1 )
	if v == id
		p := gtk_TreeModelGetPath(model, iter)
		//?? "FOUND:", p, "&\n"
		result := p
		return .T.
	endif
return .F.

static function ui_setTreeSelection( self, tree, id )
	local result:='', c
	
	//?? "driver:setTreeSelection(", id, ")&\n"
	if valtype(id) != 'C'
		return
	endif
	
	// Lookup id in model for tree path
	c := tree:columnId 
	gtk_TreeModelForeach( gtk_TreeViewGetModel( tree ), {|w,p,i| ui_treeForeach( w, p, i, c, id, @result ) } )
	
	//?? 'set cursor', result, chr(10)	
	if .not. empty(result)
		gtk_TreeViewSetCursor(tree, result, NIL, .F.)
	endif
return

static function ui_clearTree(self, tree)
	gtk_TreeStoreClear( tree:store )
return NIL

static function ui_conditionTreeSelection(self, tree, event)
return .T.

static function ui_getTreePosition(self, tree)
	local pos
	pos := array(2)
	pos[1] := tree:getSelection()
	pos[2] := tree:getValue()
return pos

static function ui_setTreePosition(self, tree, pos)
	local r
	if .not. empty(pos[1])
		r := gtk_TreePathNewFromString(pos[1])
		gtk_TreeViewSetCursor(tree, r, NIL, .F.)
	endif
return NIL

/** Timer **/
static function ui_startTimer(self, timeout, func, data)
	local id
	id := gtk_timeoutAdd( timeout, func, data )
return id

static function ui_stopTimer(self, id)
	gtk_timeoutRemove( id )
return NIL

static function ui_colorParse(self, color)
return gdk_ColorParse(color)


/** ProgressBar **/
static function ui_createProgressBar(self, text)
	local pb := gtk_ProgressBarNew()
	if text != nil
		gtk_ProgressBarSetText(pb, text)
	endif
return pb

static function ui_setProgressBarPercent(self, pb, percent, text)
	gtk_ProgressBarSetFraction(pb, percent)
	if text != nil
		gtk_ProgressBarSetText(pb, text)
	endif
return .T.

/** Layout **/
static function ui_createLayout(self)
	local fb := gtk_FixedNew()
return fb

static function ui_addLayout(self, fb, wd, x, y)
	gtk_FixedPut(fb, wd, x, y)
return .T.

static function ui_moveLayout(self, fb, wd, x, y)
	gtk_FixedMove(fb, wd, x, y)
return .T.

/** Slider **/
static function ui_createSlider(self, lower, upper, step)
	local adj := gtk_Adjustmentnew(,, lower, upper, step, step, 10), obj

	obj := gtk_HScaleNew(, adj)
	gtk_ScaleSetDigits(obj, 0)
	gtk_ScaleSetDrawValue(obj, 0)

return obj

static function ui_setSliderRange(self, obj, lower, upper)
	local value, adj
	value := self:getValue(obj)
	adj := gtk_Adjustmentnew(, value, lower, upper, obj:step, obj:step, 10)
	gtk_ScaleSetAdjustment(obj, adj)
return .t.

static function ui_setSliderStep(self, obj, step)
	local value, adj
	value := self:getValue(obj)
	adj := gtk_Adjustmentnew(, value, obj:lower, obj:upper, step, step, 10)
	gtk_ScaleSetAdjustment(obj, adj)
return .t.

/** Calendar **/
static function ui_showCalendar(self, caption, date, obj)
	local cal := gtk_CalendarNew(), dsel, win
	default date to dtoc(date())

	gtk_CalendarDisplayOptions(cal, GTK_CALENDAR_SHOW_HEADING+;
					GTK_CALENDAR_SHOW_DAY_NAMES+;
					GTK_CALENDAR_WEEK_START_MONDAY)
	dsel := ctod(date)
	gtk_CalendarSelectMonth(cal,month(dsel),year(dsel))
	gtk_CalendarSelectDay(cal, day(dsel))
	gtk_CalendarMarkDay(cal, day(dsel))

	win := gtk_WindowNew( , caption )
	gtk_ContainerAdd( win, cal )
	gtk_WindowSetFocus(win, cal)
	gtk_WindowSetPosition( win, GTK_WIN_POS_CENTER)
	gtk_WindowSetModal( win, .T. )

	self:setAction(cal, "day-selected-double-click", {|wd| date := gtk_CalendarGetDate(wd), obj:setValue(date), gtk_WidgetDestroy(win) })
	self:setAction(cal, "key-press-event", {|wd, e| iif(e:keyval==13, gtk_SignalEmit(cal, "day-selected-double-click"), .T.) })

	gtk_WidgetShowAll( win )

return date

/** FileName Dialog **/
static function ui_selectFileName(self, caption, file, obj)
	local fd := gtk_FileSelectionNew(, caption)

	if !empty(file)
		gtk_FileSelectionSetFileName(fd, file)
	endif

	gtk_SignalConnect(fd:okbutton, "clicked",;
	    {|wid,e| file := gtk_FileSelectionGetFileName(fd), obj:setValue(file), gtk_WidgetDestroy(fd)})
	gtk_SignalConnect(fd:cancelbutton, "clicked", {|wid,e| gtk_WidgetDestroy(fd)})

	gtk_WindowSetModal( fd, .T. )

	gtk_WindowSetPosition( fd, GTK_WIN_POS_CENTER)
	gtk_WidgetShow(fd)

return fd

/** Color Dialog **/
static function ui_selectColor(self, caption, color, obj)
	local cd

	if !("SETVALUE" $ obj .and. valtype(obj:setValue) == "B")
		return nil
	endif

	cd := gtk_ColorSelectionDialogNew(, caption)
	if !empty(color)
		gtk_ColorSelectionSetColor(cd:colorsel, UIColor(color))
	endif

	gtk_WindowSetModal( cd, .T. )

	gtk_SignalConnect(cd:okbutton, "clicked",;
	    {|wid,e| color := gtk_ColorSelectionGetColor(cd:colorsel),;
		obj:setValue(conv_color_to_str(color:red, color:green, color:blue)), gtk_WidgetDestroy(cd)})
	gtk_SignalConnect(cd:cancelbutton, "clicked", {|wid,e| gtk_WidgetDestroy(cd)})

	gtk_WindowSetPosition( cd, GTK_WIN_POS_CENTER)
	gtk_WidgetShow(cd)

return cd

static function conv_color_to_str(red, green, blue)
	local color := '#'
	if red > 0
		color += ntoc((red + 1) / 256 - 1, 16, 2, '0')
	else
		color += '00'
	endif
	if green > 0
		color += ntoc((green + 1) / 256 - 1, 16, 2, '0')
	else
		color += '00'
	endif
	if blue > 0
		color += ntoc((blue + 1) / 256 - 1, 16, 2, '0')
	else
		color += '00'
	endif
return color

/** EditTable **/

static function ui_createEditTable(self, columns)
	local o, i, j, cc, store, model, renderer, c, frame, column, ic
	local t, types:={}, x, searchColumn:=0
	local listArray, listStore, listModel, iter, addColumns:=0

	frame := gtk_ScrolledWindowNew()
	gtk_ScrolledWindowSetPolicy( frame, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
	gtk_ScrolledWindowSetShadowType( frame, GTK_SHADOW_IN )

	cc := len(columns)
	for column in columns
		if 'LOOKUP' $ column .and. column:lookup .and. searchColumn == 0
			searchColumn := len(types) + 1
		endif
		switch column:type
			case TABLE_COLUMN_TEXT
				t := TREE_TYPE_STRING
			case TABLE_COLUMN_CHOICE
				t := TREE_TYPE_STRING
				addColumns++
			case TABLE_COLUMN_COMBO
					t := TREE_TYPE_STRING
			case TABLE_COLUMN_NUMBER
				t := TREE_TYPE_NUMERIC_FLOAT
			case TABLE_COLUMN_DATE
				t := TREE_TYPE_DATE
			case TABLE_COLUMN_CHECK
				t := TREE_TYPE_LOGICAL
			case TABLE_COLUMN_COUNTER
				t := TREE_TYPE_NUMERIC
			otherwise
				t := TREE_TYPE_STRING
		endswitch
		aadd( types, t )
		if valtype(column:editable) != 'L'
			column:editable := .T.
		endif
	next
	aadd( types, TREE_TYPE_LOGICAL )
	aadd( types, TREE_TYPE_NUMERIC_FLOAT )
	
	// Create columns for choice cell text 
	if addColumns > 0
		for i:=1 to addColumns
			aadd( types, TREE_TYPE_STRING )
		next
	endif
	
	store := gtk_ListStoreNew(, len(types), types)
	if empty(store)
		return NIL
	endif
	model := gtk_TreeModel(store)
	o := gtk_TreeViewNewWithModel(, model)

	gtk_TreeViewSetHeadersVisible(o, .T.)
	gtk_TreeViewSetRulesHint (o, .T.)

	gtk_TreeSelectionSetMode(gtk_TreeViewGetSelection(o), GTK_SELECTION_SINGLE)
	o:store := store
	o:model := model
	
	addColumns := cc + 2
	// Append columns
	for i:=1 to cc
		
		column := columns[i]
		
		if column:type == TABLE_COLUMN_CHECK
			
			renderer = gtk_CellRendererToggleNew()
			c := gtk_TreeViewInsertColumnWithAttributes(o, -1, column:caption, renderer, ;
					"active", i)
			ic := gtk_TreeViewGetColumn(o, c)
			if column:editable
				gtk_TreeViewColumnSetAttributes(ic, renderer, "activatable", cc+1, "active", i)
				gtk_SignalConnect(renderer, "toggled", {|w, e| ui_EditTableToggled(self, w, e, o)})
			endif
		
		elseif column:type == TABLE_COLUMN_CHOICE
			addColumns++
			renderer = gtk_CellRendererTextNew()
			c := gtk_TreeViewInsertColumnWithAttributes(o, -1, column:caption, renderer, ;
					"text", addColumns)
			ic := gtk_TreeViewGetColumn(o, c)
			if column:editable
				gtk_TreeViewColumnSetAttributes(ic, renderer, "text", addColumns, "editable", cc+1)
				//gtk_SignalConnect(renderer, "edited",           {|w, e| ui_EditTableEdited(self, w, e, o)})
				gtk_SignalConnect(renderer, "editing-started",  {|w, e| ui_EditTableStartEdit(self, w, e, o, renderer)})
				//gtk_SignalConnect(renderer, "editing-canceled", {|w, e| ui_EditTableEndEdit(self, w, e, o, renderer)})
			endif
			columns[i]:__text := addColumns
                                             		
		elseif column:type == TABLE_COLUMN_COMBO
			
			// Fill combobox
			if valtype(column:source) != 'O'
				listArray := array(0)
			else
				listArray := column:source:getList()
			endif
			listStore := gtk_ListStoreNew(, 2, TREE_TYPE_STRING, TREE_TYPE_STRING)
			//?? 'source:', listArray, column:source, chr(10)
			for j:=1 to len(listArray)
				iter := gtk_ListStoreAppend(listStore)
				gtk_ListStoreSet(listStore, iter, 1, listArray[j][1])
				gtk_ListStoreSet(listStore, iter, 2, listArray[j][2])
			next
			listModel := gtk_TreeModel(listStore)
			columns[i]:__model := listModel
						
			// Create renderer
			renderer = gtk_CellRendererComboNew(, listModel, 1, .F., column:editable)
			c := gtk_TreeViewInsertColumnWithAttributes(o, -1, column:caption, renderer, ;
					"text", i)
			ic := gtk_TreeViewGetColumn(o, c)
			if column:editable
				gtk_SignalConnect(renderer, "edited", {|w, e| ui_EditTableEdited(self, w, e, o)})
			endif
			
		else
			
			renderer = gtk_CellRendererTextNew()
			c := gtk_TreeViewInsertColumnWithAttributes(o, -1, column:caption, renderer, ;
					"text", i)
			ic := gtk_TreeViewGetColumn(o, c)
			if .not. empty(column:format) .and. column:type == TABLE_COLUMN_NUMBER
				gtk_TreeViewColumnSetFormat(ic, renderer, c, column:format)
			endif
			if column:editable .and. column:type != TABLE_COLUMN_COUNTER
				gtk_TreeViewColumnSetAttributes(ic, renderer, "text", i, "editable", cc+1)
				gtk_SignalConnect(renderer, "edited", {|w, e| ui_EditTableEdited(self, w, e, o)})
			endif
			if column:type == TABLE_COLUMN_NUMBER .or. column:type == TABLE_COLUMN_COUNTER
				if column:editable .and. column:type != TABLE_COLUMN_COUNTER
					gtk_TreeViewColumnSetAttributes(ic, renderer, "text", i, "xalign", cc+2, "editable", cc+1)
				else
					gtk_TreeViewColumnSetAttributes(ic, renderer, "text", i, "xalign", cc+2)
				endif
			endif
			
		endif
		gtk_TreeViewColumnSetResizable(ic, .T.)
		//gtk_TreeViewColumnSetExpand(ic, .T.)
		columns[i]:__obj := ic
	next
	//gtk_TreeViewSetExpanderColumn(o, gtk_TreeViewGetColumn(o, 2))
	//gtk_TreeViewSetHoverSelection(o, .T.) // Cool effect!
	if searchColumn != 0
		//?? 'Search column:', searchColumn, chr(10)
		gtk_TreeViewSetSearchColumn(o, searchColumn)
	endif
	o:columns := columns
	o:layout := frame
	
	// Set action for delete and append
	gtk_SignalConnect(o, "key-press-event", {|w, e| ui_EditTableKeyboardHandler(self, w, e, o)})
	
return o

/* Key press slot for editable table*/
static function ui_EditTableKeyboardHandler(self, w, e, o)
	local r, tRow, key, win
	r := self:getEditTableSelectedRow(o)
	tRow := self:getEditTableRowCount(o)
	key := e:keyVal
	//?? 'Key pressed:', e, 'row:', r, 'rows:', tRow, chr(10)
	switch key
		case 7 // Delete
			if r != NIL
				win := getMainWindow()
				win:dialogBox( [Delete confirmation], ;
					[Are you sure to delete this record?], ;
					"'"+[&amp;Delete]+"','"+[&amp;Cancel]+"'", ;
					"'DELETE','CANCEL'", ;
					{|gId| iif(gId=='DELETE', o:removeRow( r ), NIL), self:setEditTableCursor(o, r) }, ;
					IMG_QUESTION )
			endif
		case 24 // Down arrow
			if r == tRow .or. tRow == 0
				o:addRow()
			endif
		case 22 // Insert
			r := self:addEditTableRow(o)
			self:setEditTableCursor(o, 1+val(r), self:getEditTableSelectedColumn(o))	
	endswitch
return .F. 

/* Slots for edit choice cell */
static function ui_EditTableStartEdit(self, wid, ev, o, renderer)
	local row, column, oldValue, c, ret
	
	//row := self:getEditTableSelectedRow(o)
	row := 1+val(ev:PATHSTRING)
	column := self:getEditTableSelectedColumn(o)
	c := o:columns[column]
	
	//?? "EditTableStartEdited():", row, column, ev, chr(10)
	oldValue := self:getEditTableField(o, column, row)
	//?? 'start edit:', ev, chr(10)
	
	if 'ONSELECT' $ c
		ret := eval( c:onSelect, o, column, row, oldValue )
		if valtype(ret) == 'L' .and. ret
			ui_setTableValue(o, ltrim(str(row-1)), column, oldValue)
			return .T.
		endif
	endif
	//gtk_CellRendererEditingCanceled(renderer)
	gtk_CellRendererStopEditing(renderer, .T.)
	//?? "end start&\n"
return .T.

static function ui_EditTableEndEdit(self, wid, ev, o, renderer)
	//?? 'stop edit:', ev, chr(10)
return .T.

/* Edit text cell slot */
static function ui_EditTableEdited(self, wid, ev, o)
	local row, column, oldValue, c
	
	//row := self:getEditTableSelectedRow(o)
	row := 1+val(ev:PATHSTRING)
	column := self:getEditTableSelectedColumn(o)
	c := o:columns[column]
	
	//?? "EditTableEdited():", row, column, ev, chr(10)
	oldValue := self:getEditTableField(o, column, row)
	
	if c:type == TABLE_COLUMN_COMBO
		gtk_ListStoreSetValue(GTK_TREEMODEL(o:model), ltrim(str(row-1)), column, ev:NEWTEXT)
	else
		ui_setTableValue(o, ltrim(str(row-1)), column, ev:NEWTEXT)
	endif
	
	if 'ONCHANGED' $ o
		if eval( o:onChanged, o, column, row, oldValue )
			ui_setTableValue(o, ltrim(str(row-1)), column, oldValue)
			return .T.
		endif
	endif

return .F.

/* Toggle checked cell slot */
static function ui_EditTableToggled(self, wid, ev, o)
	local row, column, value, oldValue:=.F.
	
	row := 1+val(ev:PATHSTRING)
	column := self:getEditTableSelectedColumn(o)
  	gtk_TreeModelGetFromPathString(GTK_TREEMODEL(o:model), ltrim(str(row-1)), column, @oldValue, -1)
	value = !oldValue
	//?? "EditTableToggled():", row, column, oldValue, chr(10)
	
	gtk_ListStoreSetValue(GTK_TREEMODEL(o:model), ltrim(str(row-1)), column, value)
	if 'ONCHANGED' $ o
		if eval( o:onChanged, o, column, row, oldValue )
			gtk_ListStoreSetValue(GTK_TREEMODEL(o:model), ltrim(str(row-1)), column, oldValue)
			return .T.
		endif
	endif

return .F.

/* Add editable table row */
static function ui_addEditTableRow(self, table, data)
	local row, i 
	row := gtk_ListStoreAppend(table:store)
	self:setEditTableRow(table, row, data)
	for i:=1 to len(table:columns)
		if table:columns[i]:type == TABLE_COLUMN_COUNTER
			gtk_ListStoreSetValue(GTK_TREEMODEL(table:model), row, i, 1+val(row))
		endif
	next
	i := len(table:columns)
	gtk_ListStoreSetValue(table:store, row, i+1, .T.)
	gtk_ListStoreSetValue(table:store, row, i+2, 1.0)
return row

/* Wrappers for combobox and choice cell values */
static function ui_setTableValue(table, row, column, value)
	local c
	c := table:columns[column]
	
	if c:type == TABLE_COLUMN_COMBO .and. valtype(c:source) == 'O'
		value := c:source:getText(value)
	endif
	
	//?? 'set value:', row, column, value, chr(10)
	gtk_ListStoreSetValue(table:store, row, column, value)

	if c:type == TABLE_COLUMN_CHOICE .and. valtype(c:source) == 'O' .and. "__TEXT" $ c
		gtk_ListStoreSetValue(table:store, row, c:__text, c:source:getText(value))
	endif
	
return value

static function ui_getTableValue(table, row, column, value)
	local c, v
	c := table:columns[column]
	v := c:default	
	
	gtk_TreeModelGetFromPathString( gtk_TreeViewGetModel( table ), row, column, @value, -1 )
	
	if c:type == TABLE_COLUMN_COMBO .and. valtype(c:source) == 'O'
		value := c:source:getValueByText(value)
	endif
	
return value

/* Set data for editable table row */
static function ui_setEditTableRow(self, table, row, data)
	local i, c
	if valtype(row) == 'N'
		row := ltrim(str(row-1))
	endif
	if valtype(data) == 'A'
		for i:=1 to len( data )
			if table:columns[i]:type != TABLE_COLUMN_COUNTER
				ui_setTableValue(table, row, i, data[i])
			endif
		next
	elseif valtype(data) == 'O'
		for i:=1 to len( table:columns )
			c := upper(table:columns[i]:name)
			if table:columns[i]:type != TABLE_COLUMN_COUNTER
				ui_setTableValue(table, row, i, data[c])
			endif
		next
	else
		for i:=1 to len( table:columns )
			c := table:columns[i]:default
			if table:columns[i]:type != TABLE_COLUMN_COUNTER
				ui_setTableValue(table, row, i, c)
			endif
		next
	endif
return NIL

/* Get data from editable table row as object */
static function ui_getEditTableRow(self, table, row)
	local o:=map(), i, cc, c, v:=''
	
	// Normalize row
	if valtype(row) == 'N'
		if self:getEditTableRowCount(table) < row
			row := NIL
		else
			row := ltrim(str(row-1))
		endif
	elseif valtype(row) == 'U'
		row := ui_getEditTableSelection(self, table)
	endif
	
	if empty(row)
		return NIL
	endif
	
	// Get row as object
	cc := len( table:columns )
	for i:=1 to cc
		c := table:columns[i]:name
		v := ui_getTableValue(table, row, i, v)
		o[upper(c)] := v
	next
return o

/* Remove editable table row */
static function ui_removeEditTableRow(self, table, row)
	local num, total, i, r
	if valtype(row) == 'N'
		num := row
		row := ltrim(str(row-1))
	else
		num := 0 + val(row)
	endif
	total := self:getEditTableRowCount(table)
	//?? 'remove', num, 'from', total, chr(10)
	if num <= total
		gtk_ListStoreRemove(table:store, row)
		// Refresh count
		for r:=num to total-1
			for i:=1 to len(table:columns)
				if table:columns[i]:type == TABLE_COLUMN_COUNTER
					gtk_ListStoreSetValue(GTK_TREEMODEL(table:model), ltrim(str(r-1)), i, r)
				endif
			next
		next
	endif
return NIL

/* Clear all editable table */
static function ui_clearEditTable(self, table)
	gtk_ListStoreClear( table:store )
return NIL

static function ui_getEditTableSelection(self, table)
	local s, iter, path, pathstr

	s := gtk_TreeViewGetSelection( table )
	gtk_TreeSelectionGetSelected(s, NIL, @iter)
	if iter == NIL
		return NIL
	endif
	path := gtk_TreeModelGetPath(gtk_TreeViewGetModel( table ), iter)
	pathstr := gtk_TreePathToString(path)
return pathstr

static function ui_setEditTableField(self, table, column, row, value)
	local c, i
	
	if valtype(row) == 'U'
		row := ui_getEditTableSelection(self, table)
	endif
	if valtype(column) == 'C'
		c := lower(column) 
		i := ascan(table:columns, {|e| lower(e:name) == c })
		if i > 0
			column := i
		else
			column := NIL
		endif
	endif
	if valtype(row) == 'U' .or. valtype(column) != 'N'
		return NIL
	else
		if valtype(row) == 'N'
			if self:getEditTableRowCount(table) < row
				return NIL
			endif
			row := ltrim(str(row-1))
		endif
	endif
	if table:columns[column]:type != TABLE_COLUMN_COUNTER
		ui_setTableValue(table, row, column, value)
	endif
return NIL

static function ui_getEditTableField(self, table, column, row)
	local o:=array(0), i, c, cc, r:='', v:=''
	
	// Normalize row
	if valtype(row) == 'N'
		if self:getEditTableRowCount(table) < row
			row := NIL 
		else
			row := ltrim(str(row-1))
		endif
	elseif valtype(row) == 'U'
		row := ui_getEditTableSelection(self, table)
	endif
	if empty(row)
		return NIL
	endif
	
	// Normalize column
	if valtype(column) == 'C'
		c := lower(column) 
		i := ascan(table:columns, {|e| lower(e:name) == c })
		if i > 0
			column := i
		else
			column := NIL
		endif
	endif
	if valtype(column) == 'N'
		// Get single value
		return ui_getTableValue(table, row, column, v)
	else
		// Get row as array
		cc := len( table:columns )
		for i:=1 to cc
			c := table:columns[i]:name
			aadd(o, ui_getTableValue(table, row, i, v))
		next
		return o
	endif
return NIL

static function ui_setEditTableCursor(self, table, row, column, beginEdit)
	local r
	
	if valtype(beginEdit) == 'U'
		beginEdit := .F.
	endif
	if valtype(column) == 'U'
		column := self:getEditTableSelectedColumn(table)
	endif
	r := self:getEditTableRowCount(table)
	if row > r
		row := r
	endif
	if row <= 0
		row := 1
	endif
	
	// Map indexes to objects
	row := gtk_TreePathNewFromString( ltrim(str(row-1)) )
	column := gtk_TreeViewGetColumn(table, column)
	
	gtk_TreeViewSetCursor(table, row, column, beginEdit)

return NIL

static function ui_getEditTableRowCount(self, table)
return 0+gtk_TreeModelIterNChildren( gtk_TreeViewGetModel( table ), NIL )

static function ui_getEditTableColumnCount(self, table)
return len(table:columns)

static function ui_getEditTableSelectedRow(self, table)
	local row
	row := ui_getEditTableSelection(self, table)
	if row == NIL
		return NIL
	endif
	//?? 'selected row:', row, chr(10)
return 1 + val( row )

static function ui_getEditTableSelectedColumn(self, table)
	local c
	c := gtk_TreeViewGetSelectedColumn(table)
	//?? 'selected column:', c, chr(10)
return c


/* TabArea and Tab */
static function ui_createTabArea(self)
	local o
	o := gtk_NotebookNew()
	gtk_NoteBookSetShowBorder( o, .T. )
	gtk_NoteBookSetScrollable( o, .T. )
	gtk_NotebookPopupEnable( o )
return o

static function ui_createTab(self, caption, name)
	local o
	o := UIVBox()
	o:caption := caption
return o

static function ui_addTab(self, area, tab, pos)
	tab:parent := area
	gtk_NoteBookAppendPage( area, tab, tab:caption )
return NIL

static function ui_activateTab(self, tab)
	local n
	n := gtk_NoteBookPageNum(tab:parent, tab)
	gtk_NoteBookSetPage(tab:parent, n)
return NIL

static function ui_setTabCaption(self, tab, caption)
	//w := gtk_NotebookGetNthPage(window:parent:childSpace, n)
	gtk_NotebookSetTabLabel(tab:parent, tab, caption)
return NIL
