/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation	           */
/*   Authors: 								   */
/*  	     Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*           Igor Satsyuk <satsyuk@tut.by>                                 */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Menu class */
function UIMenu()
	local obj 	:= driver:createMenuBar()
	obj:elem 	:= array(0)
	obj:win		:= NIL
	obj:className	:= "UIMenu"
	_recover_UIMENU(obj)
return obj

function _recover_UIMENU( obj )
	obj:add		:= @ui_add()
	obj:enable 	:= @ui_enable()
	obj:disable 	:= @ui_disable()
	obj:remove 	:= @ui_remove()
	obj:clear 	:= @ui_clear()
	obj:getElement	:= @ui_getElement()
	obj:isEnabled	:= @ui_isEnabled()
	obj:setKey	:= @ui_setKey()
	obj:unSetKey	:= @ui_unSetKey()
return obj

/* PopupMenu class */
function UIPopupMenu()
	local obj 	:= driver:createPopupMenu()
	obj:elem 	:= array(0)
	obj:win		:= NIL
	obj:className	:= "UIPopupMenu"
	_recover_UIMENU(obj)
	_recover_UIPOPUPMENU(obj)
return obj

function _recover_UIPOPUPMENU( obj )
	obj:addSeparator := @ui_addSeparator()
	obj:addChecked	:= @ui_addChecked()
	obj:isChecked	:= @ui_isChecked()
return obj

/* Add element to menu */
static function ui_add(self, pic, name, action, isEnabled)
	local elem, pos := 0

	if isEnabled == NIL
		isEnabled := .T.
	endif
	if action == NIL
		isEnabled := .F.
	endif
	if pic == NIL
		pic := UIImage()
	endif

	elem := driver:addMenuItem( self, pic, name, action, isEnabled)
	elem:className	:= "UIMenuItem"
	elem:label	:= name
	elem:setIcon 	:= @ui_setMenuItemIcon()
	elem:setAction 	:= @ui_setMenuItemAction()
	aadd( self:elem, elem )
	pos := len( self:elem )
return pos

/* Add checked element to menu */
static function ui_addChecked(self, def_status, name, action, isEnabled)
	local elem, pos := 0

	if isEnabled == NIL
		isEnabled := .T.
	endif
	if action == NIL
		isEnabled := .F.
	endif
	if def_status == NIL
		def_status := .T.
	endif

	elem := driver:addMenuCheckedItem( self, def_status, name, action, isEnabled)
	elem:className	:= "UIMenuCheckedItem"
	elem:label	:= name
	elem:setAction 	:= @ui_setMenuItemCheckedAction()
	elem:isChecked	:= @ui_isChecked()
	aadd( self:elem, elem )
	pos := len( self:elem )
return pos

/* Add separator to menu */
static function ui_addSeparator(self)
        local elem
	elem := driver:addSeparator( self )
	aadd( self:elem, elem )
	pos := len( self:elem )
return pos

/* Enable menu item */
static function ui_enable(self, pos)
	driver:enableWidget( ui_getElement(self, pos), .T.)
return NIL

/* Disable menu item */
static function ui_disable(self, pos)
	driver:enableWidget( ui_getElement(self, pos), .F.)
return NIL

/* Remove item from menu */
static function ui_remove(self, pos)
	driver:removeMenuItem( self, self:getElement(pos) )
	adel( self:elem, pos )
	asize( self:elem, len(self:elem)-1 )
return NIL

/* Remove all items from menu */
static function ui_clear(self)
	local i, s:=len(self:elem)
	for i=1 to s
		self:remove( 1 )
	next
return NIL

/* Return object by its number in the menu */
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

/* Return enable state of menu item */
static function ui_isEnabled(self, pos)
return driver:isEnabled( ui_getElement(self, pos) )

/* Return checked state of checked menu item */
static function ui_isChecked(self, pos)
	local obj
	obj := iif(valtype(pos)=='N',ui_getElement(self, pos),self)
return driver:isCheckedMenuItem( obj )

/* Set icon for menu item */
static function ui_setMenuItemIcon(self, icon)
	driver:setPixmap(self, icon)
return .T.

/* Set action for menu item */
static function ui_setMenuItemAction(self, signal, action)
	if signal=='activate' .and. valtype(action)=='B'
		driver:setAction( self, "activate", action)
		driver:enableWidget( self, .T. )
	endif
return .T.

/* Set action for menu item */
static function ui_setMenuItemCheckedAction(self, signal, action)
	if signal=='toggled' .and. valtype(action)=='B'
		driver:setAction( self, "toggled", action)
		driver:enableWidget( self, .T. )
	endif
return .T.

/* Set key for menu item */
static function ui_setKey(self, nElem, cKey)
	driver:setKey(self:elem[nElem], self, cKey)
return .t.

/* Unset key for menu item */
static function ui_unSetKey(self, nElem, cKey)
	driver:unSetKey(self:elem[nElem], self, cKey)
return .t.
