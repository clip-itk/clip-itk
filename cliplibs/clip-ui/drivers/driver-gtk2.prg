/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2005 by E/AS Software Foundation	 	           */
/*   Authors: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 21 Feb 2005						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include <clip-gtk2.ch>
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
	drv:setPanels		:= @ui_setPanels()
	drv:setGeometry		:= @ui_setGeometry()
	drv:getGeometry		:= @ui_getGeometry()
	drv:setWindowPlacement	:= @ui_setWindowPlacement()
	drv:setWindowIcon	:= @ui_setWindowIcon()
	drv:getCurrentChild	:= @ui_getCurrentChild()
	drv:setFocus		:= @ui_setFocus()
	drv:setDefault		:= @ui_setDefault()
	drv:setKeyEvent		:= @ui_setKeyEvent()

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
	drv:addBox		:= @ui_addBox()
	drv:addBoxEnd		:= @ui_addBoxEnd()
	drv:setBoxSpacing	:= @ui_setBoxSpacing()
	drv:getBoxSpacing	:= @ui_getBoxSpacing()
	drv:createGrid		:= @ui_createGrid()
	drv:addGrid		:= @ui_addGrid()
	drv:setBoxAlignment	:= @ui_setBoxAlignment()
	drv:setBoxElemEqualSize	:= @ui_setBoxElemEqualSize()
	drv:createSplitter	:= @ui_createSplitter()
	drv:addSplitPane	:= @ui_addSplitPane()
	drv:addSplitPaneEnd	:= @ui_addSplitPaneEnd()
	drv:setSplitterPosition	:= @ui_setSplitterPosition()
	
	/* Button */
	drv:createButton	:= @ui_createButton()
	drv:setPadding		:= @ui_setPadding()

	/* Table*/
	drv:createTable		:= @ui_createTable()
	drv:addTableRow		:= @ui_addTableRow()
	drv:clearTable		:= @ui_clearTable()
        drv:setTableSelectAction := @ui_setTableSelectAction()
	drv:getTableSelection	:= @ui_getTableSelection()
	drv:conditionTableSelection := @ui_conditionTableSelection()

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
	drv:clearTree     	:= @ui_clearTree()
	drv:setTreeSelectAction := @ui_setTreeSelectAction()
	drv:getTreeSelection 	:= @ui_getTreeSelection()
	drv:conditionTreeSelection := @ui_conditionTreeSelection()
	
	/* Timer */
	drv:startTimer		:= @ui_startTimer()
	drv:stopTimer		:= @ui_stopTimer()
			
return drv

function getGTK2Driver( params )
	if drv == NIL
		initGTK2Driver()
	endif
return drv


/** Application **/

static function ui_createInstance( self )
	loadlib("libclip-gtk2")
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
	if valtype(resizeable) == "L" .and. resizeable
		gtk_WindowSetResizeable(wnd, .T.)
	else
		gtk_WindowSetResizeable(wnd, .F.)
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
	if .not. valtype(geom) $ 'AN'
        	return .f.
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
	local action, s:=map()
	gtk_WindowSetDefault(window, widget)
//	s:BASE_color := UIColor("green")
//	gtk_WidgetSetStyle(widget, s)
	window:setFocus( widget )
	//TODO: setDefault(): no border for default button
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
	if flag == .T.
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
		gtk_ContainerAdd( obj:layout, obj )
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
		gtk_ContainerAdd( obj:layout, obj )
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
	local o
	o := gtk_TableNew(, row, col, .F.)
	if .not. empty(parent)
		gtk_ContainerAdd( parent, o )
	endif
return o

static function ui_addGrid(self, box, obj, pos, h_expand, v_expand)
	local vBox, hBox, padding:=box:padding
        local a, cl, rw, l, r, t, b, hflags := GTK_FILL, vflags := GTK_FILL
	if valtype(h_expand) == "L" .and. h_expand
		hflags += GTK_EXPAND
	endif
	if valtype(v_expand) == "L" .and. v_expand
		vflags += GTK_EXPAND
	endif
	if valtype(pos) == "U"
        	?? "ERROR: bad grid position&\n"
		return .F.
	endif
	a := split(pos, ",")
	if len(a) != 2
        	?? "ERROR: no delimiter ',' in grid position&\n"
		return .F.
	endif
	cl := split(a[1],"\-")
	rw := split(a[2],"\-")
	t := val(cl[1])
        b := iif(len(cl)==2,val(cl[2]),t)
	l := val(rw[1])
        r := iif(len(rw)==2,val(rw[2]),l)
	if "LAYOUT" $ obj
		gtk_ContainerAdd( obj:layout, obj )
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
	y:	ALIGN_TOP	0
		ALIGN_MIDDLE	1
		ALIGN_BOTTOM	2
	*/
	align  :=iif(valtype(align) != 'N', 0, align)
	valign :=iif(valtype(valign) != 'N', 0, valign)
	
	gtk_alignmentSet( box:layout, align/2, valign/2, 0.01, 0.01 ) 
		
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
return o

/* Add widget to left/top pane */
static function ui_addSplitPane(self, pane, obj)
	local vBox, hBox
	if "LAYOUT" $ obj
		gtk_ContainerAdd( obj:layout, obj )
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
		gtk_ContainerAdd( obj:layout, obj )
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

/** Table **/

static function ui_createTable(self, columns)
	local o, i, cc, store, model, renderer, c
	
	cc := len(columns)
	store := gtk_ListStoreNew(, cc)
	if empty(store) 
		return NIL
	endif
	model := gtk_TreeModel(store)
	o := gtk_TreeViewNewWithModel(,model)
	
	gtk_TreeViewSetHeadersVisible(o, .T.)
  	gtk_TreeViewSetRulesHint (o, .T.)
	
	o:store := store
	renderer = gtk_CellRendererTextNew ()
	
	// Append columns
	for i:=1 to cc
		c := gtk_TreeViewInsertColumnWithAttributes(o, -1, columns[i], renderer, "text", i)
		gtk_TreeViewColumnSetResizable(gtk_TreeViewGetColumn(o, c), .T.)
		gtk_TreeViewColumnSetSizing(gtk_TreeViewGetColumn(o, c), CLIP_GTK_TREE_VIEW_COLUMN_AUTOSIZE)
	next

return o

static function ui_addTableRow(self, table, data)
	local row, i
	row := gtk_ListStoreAppend(table:store)
	for i:=1 to len( data )
		gtk_ListStoreSetValue(table:store, row, i, data[i])
	next
return NIL

static function ui_clearTable(self, table)
	gtk_ListStoreClear( table:store )
return NIL

static function ui_getTableSelection(self, table)
	local s, a, iter, path, pathstr
	s := gtk_TreeViewGetSelection( table )
	gtk_TreeSelectionGetSelected(s, NIL, @iter)
	path := gtk_TreeModelGetPath(gtk_TreeViewGetModel( table ), iter)
	pathstr := gtk_TreePathToString(path)
	a := val(pathstr)+1
return a

static function ui_setTableSelectAction( self, table, action )
	self:setAction( table, "row-activated", action )
return

static function ui_conditionTableSelection(self, table, event)
return .T.


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
	frame := UIFrame(, FRAME_SUNKEN)
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
	gtk_MiscSetAlignment( o, 0, 0)
return o

static function ui_setLabelText(self, label, text)
	gtk_LabelSetText(label, text)
return NIL

/** Frame **/
static function ui_createFrame(self, caption, type)
	local o
	o := gtk_FrameNew(, caption)
	self:setFrameType(o, type)
return o

static function ui_setFrameGrid(self, frame, grid)
	gtk_ContainerAdd( frame, grid )
return NIL

static function ui_setFrameLabel(self, frame, label)
	gtk_FrameSetLabel( frame, label )
return NIL

static function ui_setFrameType(self, frame, type)
	if valtype(type) == 'N'
		gtk_FrameSetShadowType( frame, type )
	endif
return NIL

/** ComboBox **/
static function ui_createComboBox(self, values)
	local o
	o := gtk_ComboNew()
	if valtype(values) == 'A'
		gtk_ComboSetPopDownStrings(o, values)
	endif
return o

static function ui_setComboBoxList(self, o, values)
	if valtype(values) == 'A'
		gtk_ComboSetPopDownStrings(o, values)
	endif
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
static function ui_setValue(self, o, value)
	local a
	switch o:className
                case "UILabel"
			o:setValue( value )
		case "UIEdit"
			gtk_EntrySetText( o, value )

		case "UIEditText"
			gtk_TextBufferSetText( gtk_TextViewGetBuffer(o), value )
			
		case "UIComboBox"
			a := gtk_ContainerChildren(o)
			if valtype(value) == "N"
				value := o:list[value]
			endif
			gtk_EntrySetText( a[1], value )

		case "UICheckBox"
			gtk_ToggleButtonSetActive( o, value)

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
		st:font := o:font:font
		gtk_WidgetSetStyle(o, st)
//TODO:??	gtk_WidgetModifyFont(o, o:font:font)
		return .T.
	endif
	
	// Color
	if left(style,6) == "color."
		style := substr(style,7)
		st[upper(style+"_color")] := UIColor( value )
		// ?? upper(style)+"_color", value, UIColor( value ), chr(10)
		gtk_WidgetSetStyle(o, st)
		return .T.
	endif
	
	// Background picture
	if style == "background"
		st:bg_pixmap := UIImage( value )
		gtk_WidgetSetStyle(o, st)
		return .T.
	endif
	
	
	?? "Style unsupported: '"+style+"'='"+iif(valtype(value)=="C",value,"")+"'&\n"
return .F.

static function ui_getValue(self, o)
	local val, a, i, j, rows, cols, start, end
	switch o:className
		case "UILabel"
                        val := o:getValue()

		case "UIEdit"
                        val := gtk_EntryGetText( o )

		case "UIEditText"
                	gtk_TextBufferGetBounds (gtk_TextViewGetBuffer(o), @start, @end)
  			val := gtk_TextIterGetText (start, end)

		case "UIComboBox"
			a := gtk_ContainerChildren(o)
			val := gtk_EntryGetText(a[1])

		case "UICheckBox"
                	val := gtk_ToggleButtonGetActive( o )

		otherwise
                        ?? "ERROR: couldn't get value from non-valued widget: "+o:className+CHR(10)
			val := NIL
	endswitch
return val

static function ui_setAction(self, o, signal, action)
	gtk_signalConnectAfter(o,signal,action)
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
	local al_ru := "áâ÷çäå³öúéêëìíîïðòóôõæèãþûýÿùøüàñ"
	local al_tr := "F,DULT`;PBQRKVYJGHCNEA[WXIO]SM'.Z"
	
	l := upper(letter)
	i := at( l, al_ru )
return iif(i>0, al_tr[i], l)

static function ui_conversionKey(nCode)
	local nNewCode := nCode
	
	switch nCode
		case 1040, 1072 // 'Á', 'á'
			nNewCode := GDK_Cyrillic_a
		case 1041, 1073 // 'Â', 'â'
			nNewCode := GDK_Cyrillic_be
		case 1042, 1074 // '×', '÷'
			nNewCode := GDK_Cyrillic_ve
		case 1043, 1075 // 'Ç', 'ç'
			nNewCode := GDK_Cyrillic_ghe
		case 1044, 1076 // 'Ä', 'ä'
			nNewCode := GDK_Cyrillic_de
		case 1045, 1077 // 'Å', 'å'
			nNewCode := GDK_Cyrillic_je
		case 1025, 1105 // '£', '³'
			nNewCode := GDK_Cyrillic_io
		case 1046, 1078 // 'Ö', 'ö'
			nNewCode := GDK_Cyrillic_zhe
		case 1047, 1079 // 'Ú', 'ú'
			nNewCode := GDK_Cyrillic_ze
		case 1048, 1080 // 'É', 'é'
			nNewCode := GDK_Cyrillic_i
		case 1049, 1081 // 'Ê', 'ê'
			nNewCode := GDK_Cyrillic_shorti
		case 1050, 1082 // 'Ë', 'ë'
			nNewCode := GDK_Cyrillic_ka
		case 1051, 1083 // 'Ì', 'ì'
			nNewCode := GDK_Cyrillic_el
		case 1052, 1084 // 'Í', 'í'
			nNewCode := GDK_Cyrillic_em
		case 1053, 1085 // 'Î', 'î'
			nNewCode := GDK_Cyrillic_en
		case 1054, 1086 // 'Ï', 'ï'
			nNewCode := GDK_Cyrillic_o
		case 1055, 1087 // 'Ð', 'ð'
			nNewCode := GDK_Cyrillic_pe
		case 1056, 1088 // 'Ò', 'ò'
			nNewCode := GDK_Cyrillic_er
		case 1057, 1089 // 'Ó', 'ó'
			nNewCode := GDK_Cyrillic_es
		case 1058, 1090 // 'Ô', 'ô'
			nNewCode := GDK_Cyrillic_te
		case 1059, 1091 // 'Õ', 'õ'
			nNewCode := GDK_Cyrillic_u
		case 1060, 1092 // 'Æ', 'æ'
			nNewCode := GDK_Cyrillic_ef
		case 1061, 1093 // 'È', 'è'
			nNewCode := GDK_Cyrillic_ha
		case 1062, 1094 // 'Ã', 'ã'
			nNewCode := GDK_Cyrillic_tse
		case 1063, 1095 // 'Þ', 'þ'
			nNewCode := GDK_Cyrillic_che
		case 1064, 1096 // 'Û', 'û'
			nNewCode := GDK_Cyrillic_sha
		case 1065, 1097 // 'Ý', 'ý'
			nNewCode := GDK_Cyrillic_shcha
		case 1066, 1098 // 'ß', 'ÿ'
			nNewCode := GDK_Cyrillic_hardsign
		case 1067, 1099 // 'Ù', 'ù'
			nNewCode := GDK_Cyrillic_yeru
		case 1068, 1100 // 'Ø', 'ø'
			nNewCode := GDK_Cyrillic_softsign
		case 1069, 1101 // 'Ü', 'ü'
			nNewCode := GDK_Cyrillic_e
		case 1070, 1102 // 'À', 'à'
			nNewCode := GDK_Cyrillic_yu
		case 1071, 1103 // 'Ñ', 'ñ'
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

static function ui_createTree(self, nTreeColumn, acNameColumns)
	local o,i
	nTreeColumn := iif(empty(nTreeColumn),1,nTreeColumn)
	o := gtk_CTreeNew(, len(acNameColumns), nTreeColumn, acNameColumns)
	o:currentNode := NIL
	//gtk_CListColumnTitlesShow(o)
	
	// Type of selection
	// GTK_SELECTION_SINGLE (the default)
	// GTK_SELECTION_BROWSE
	// GTK_SELECTION_MULTIPLE
	// GTK_SELECTION_EXTENDED
	gtk_CListSetSelectionMode(o, GTK_SELECTION_BROWSE)
	
	if valtype(acNameColumns) == 'A'
		for i=1 to len(acNameColumns)
			gtk_CListSetColumnAutoResize(o, i)
		next
	endif
return o

static function ui_setTreeSelectAction( self, tree, action )
	self:setAction( tree, "tree-select-row", action )
	self:setAction( tree, "key-press-event", action )
return

static function ui_getTreeSelection(self, tree)
	local i, l:=len(tree:nodes), h
	if tree:currentNode != NIL
		h := tree:currentNode:handle
		for i=1 to l
			if tree:nodes[i]:handle == h
				return i
			endif
		next
	endif
return NIL

static function ui_addTreeNode(self, tree, parent, sibling, columns, expanded)
	local node
	node := gtk_CTreeInsertNode(tree, parent, sibling, columns,,,, .F., expanded)
	if len(tree:nodes) == 0
		tree:currentNode := node
	endif
return node

static function ui_clearTree(self, tree)
	gtk_CListClear( tree )
	tree:currentNode := NIL
return NIL

static function ui_conditionTreeSelection(self, tree, event)
	local isRealSelect := .F.
	if "NODE" $ event
		tree:currentNode := event:node
		if event:column > 0
			isRealSelect := .T.
		endif
	endif
return isRealSelect .or. (event:event == GTK_KEY_PRESS .and. event:keyval == 13)

static function ui_startTimer(self, timeout, func, data)
	local id
	id := gtk_timeoutAdd( timeout, func, data )
return id

static function ui_stopTimer(self, id)
	gtk_timeoutRemove( id )
return NIL
