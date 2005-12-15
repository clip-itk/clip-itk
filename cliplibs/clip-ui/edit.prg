/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation	           */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* TODO: control wordwrap for UIEditText */

/* EditText class */
function UIEdit(value)
	local obj	:= driver:createEdit()
	obj:className	:= "UIEdit"
	_recover_UIEDIT(obj)
	obj:setValue( value )
	obj:setPassword := @ui_editSetPassword()
return obj

/* EditText class */
function UIEditText(value)
	local obj	:= driver:createEditText(value)
	obj:className	:= "UIEditText"
	if .not. empty(value)
		ui_setValue(obj, value)
	endif
	_recover_UIEDIT(obj)
return obj

function _recover_UIEDIT( obj )
	obj:getGeometry := @ui_getGeometry()
	obj:setGeometry := @ui_setGeometry()
	obj:setValue	:= @ui_setValue()
	obj:getValue	:= @ui_getValue()
	obj:readOnly	:= @ui_setReadOnly()
	obj:setAction 	:= @ui_setEditAction()
	obj:appendText	:= @ui_appendText()
return obj

/* Get widget geometry: position and size */
static function ui_getGeometry( self )
	local geom
	geom := driver:getGeometry( self )
return( geom )

/* Set widget geometry: position and size */
static function ui_setGeometry( self, geom )
	driver:setGeometry( self, geom )
return NIL

/* Set value */
static function ui_setValue(self, value)
	driver:setValue( self, val2str(value) )
return NIL

/* Get value */
static function ui_getValue(self)
return driver:getValue( self )

/* Set state to read-only */
static function ui_setReadOnly(self, flag)
	if empty(flag)
		flag := .T.
	endif
	driver:editSetReadOnly(self,flag)
return

/* Set state to password mode (if TRUE) */
static function ui_editSetPassword(self, flag)
        flag := iif(valtype(flag)=="U",.T.,flag)
	driver:editSetPassword(self,flag)
return

/* Set action for edit entry */
static function ui_setEditAction(self, signal, action)
	if signal=='changed' .and. valtype(action)=='B'
		driver:setAction( self, "changed", action)
	endif
return .T.

/* Append text to the end of current text */
static function ui_appendText(self, text)
	driver:setValue( self, val2str(text), .T.)
return .T.

/* EditDate class */
function UIEditDate(value, caption)
        local button, obj

        obj := UIEdit(value)
        caption := iif(empty(caption),"Select Date",caption)
        button := UIButton("...", {|| driver:showCalendar(caption, obj:getValue(), obj) })
        obj:stick := map()
        obj:stick:right := button

return obj

/* EditFileName class */
function UIEditFileName(value, caption)
        local button, obj

        obj := UIEdit(value)
        caption := iif(empty(caption),"Select File",caption)
        button := UIButton("...", {|| driver:selectFileName(caption, obj:getValue(), obj) })
        obj:stick := map()
        obj:stick:right := button

return obj

/* EditColor class */
function UIEditColor(value, caption)
        local button, obj

        obj := UIEdit(value)
        caption := iif(empty(caption),"Select Color",caption)
        button := UIButton("...", {|| driver:selectColor(caption, obj:getValue(), obj) })
        obj:stick := map()
        obj:stick:right := button

return obj

/* EditNumber class */
/*????*/

/* EditReference class */
/*????*/
