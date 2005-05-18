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

static driver := getDriver()

/* Toolbar class */
function UIToolbar( )
	local obj 	:= driver:createToolBar()
	obj:frame	:= NIL
	obj:elem 	:= array(0)
	obj:className := "UIToolBar"
	_recover_UITOOLBAR(obj)
return obj

function _recover_UITOOLBAR( obj )
	obj:addButton	:= @ui_addButton()
	obj:addSeparator := @ui_addSeparator()
	obj:show	:= @ui_show()
	obj:hide	:= @ui_hide()
	obj:enable 	:= @ui_enable()
	obj:disable 	:= @ui_disable()
	obj:remove 	:= @ui_remove()
	obj:clear 	:= @ui_clear()
	obj:getElement	:= @ui_getElement()
	obj:isEnabled	:= @ui_isEnabled()
return obj

/* Statusbar class */
function UIStatusBar( )
	local obj 	:= driver:createStatusBar()
	obj:className 	:= "UIStatusBar"
	_recover_UISTATUSBAR(obj)
return obj

function _recover_UISTATUSBAR( obj )
	obj:setText	:= @ui_setStatusText()
	obj:show	:= @ui_show()
	obj:hide	:= @ui_hide()
return obj

/* Add button to toolbar */
static function ui_addButton(self, pic, tooltip, action, isEnabled)
	local pos, elem

	if isEnabled == NIL
		isEnabled := .T.
	endif
	if action == NIL
		isEnabled := .F.
	endif
	if pic == NIL
		pic := UIImage()
	endif

	elem := driver:addToolBarButton( self, pic, tooltip, action, isEnabled)
	elem:className	:= "UIToolButton"
	elem:setIcon 	:= @ui_setToolbarItemIcon()
	elem:setAction 	:= @ui_setToolbarItemAction()
	elem:pic 	:= pic
	elem:tooltip 	:= tooltip
	elem:action	:= action
	elem:isEnabled 	:= isEnabled
	elem:pos	:= len( self:elem )+1
	elem:toolBar	:= self
	aadd( self:elem, elem )
	pos := len( self:elem )
return pos

/* Add separator to toolbar */
static function ui_addSeparator(self)
	local elem
	elem := driver:addToolBarSpace( self )
	aadd( self:elem, elem )
	pos := len( self:elem )
return pos

/* Show toolbar or statusbar */
static function ui_show(self, f)
	if f==NIL
		f := .T.
	endif
	driver:showWidget( self, f )
return 0

/* Hide toolbar or statusbar */
static function ui_hide(self)
	driver:showWidget( self, .F. )
return 0

/* Enable toolbar item */
static function ui_enable(self, pos)
	driver:enableWidget( ui_getElement(self, pos), .T.)
return NIL

/* Disable toolbar item */
static function ui_disable(self, pos)
	driver:enableWidget( ui_getElement(self, pos), .F.)
return NIL

/* Remove item from toolbar */
static function ui_remove(self, pos)
	driver:removeToolBarItem( self, self:getElement(pos) )
	adel( self:elem, pos )
	asize( self:elem, len(self:elem)-1 )
return NIL

/* Remove all items from toolbar */
static function ui_clear(self)
	local i, s:=len(self:elem)
	for i=1 to s
		self:remove( 1 )
	next
	?? self:elem, chr(10)
return NIL

/* Set text to statusbar */
static function ui_setStatusText(self, text)
	driver:setStatusText( self, text )
return 0

/* Return object by its number on the toolbar */
static function ui_getElement(self, pos)
	local obj := NIL
       	if len(self:elem) < pos
		pos := len(self:elem)
	endif
	if pos < 1
		pos := 1
	endif
	obj := self:elem[pos]
return obj

/* Return enable state of toolbar item */
static function ui_isEnabled(self, pos)
return driver:isEnabled( ui_getElement(self, pos) )

/* Set icon for toolbar item */
static function ui_setToolbarItemIcon(self, icon)
	driver:setPixmap(self, icon)
return .T.

/* Set action for toolbar item */
static function ui_setToolbarItemAction(self, signal, action)
	if signal=='clicked' .and. valtype(action)=='B'
		driver:setAction( self, "clicked", action)
		self:action := action
		driver:enableWidget( self, .T. )
	endif
return .T.
