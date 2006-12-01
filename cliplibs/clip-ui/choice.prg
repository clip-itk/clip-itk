/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2004-2006 by E/AS Software Foundation                   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Choice class (edit box with button for choosing values) */
function UIChoice( action, value, text )
	local obj := UIEdit( text )
	obj:readOnly(.T.)
	obj:button 		:= UIButton( "...", action, value )
	obj:stick 		:= map()
	obj:stick:right := obj:button
	obj:source 		:= NIL
	_recover_UICHOICE(obj)
return obj

function _recover_UICHOICE( obj )
	obj:setAction	:= @ui_setAction()
	obj:setSource	:= @ui_setSource()
	obj:setText		:= @ui_setText()
	obj:getText		:= @ui_getText()
	obj:setValue	:= @ui_setValue()
	obj:getValue	:= @ui_getValue()
return obj

/* Set action to UIChoice */
static function ui_setAction(self, signal, action)
	// Set action to choice button clicked
	if signal=='clicked' .and. valtype(action)=='B'
		self:button:setAction(signal, action)
	endif
return NIL

/* Set source for automatic text retrieve on change value */
static function ui_setSource(self, source)
	self:source := source
return NIL

/* Set text */
static function ui_setText(self, value)
	driver:setValue( self, val2str(value) )
return NIL

/* Get text */
static function ui_getText(self)
return driver:getValue( self )

/* Set value */
static function ui_setValue(self, value)
	self:button:setValue(value)
	
	if valtype(self:source) != 'U' .and. isFunction("GETATTRIBUTEVALUE")
		// getAttributeValue(<id>, <attribute>)
		// <id> is object id
		// <attribute> should has format: 'db:class:attribute'
		self:setText( getAttributeValue( value, self:source ) )
	endif
return NIL

/* Get value */
static function ui_getValue(self)
return self:button:getValue()
