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
	_recover_UICHOICE(obj)
return obj

function _recover_UICHOICE( obj )
	obj:setAction	:= @ui_setAction()
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

/* Set value */
static function ui_setValue(self, value)
	local v
	if valtype(value) == 'A' .and. len(value) == 2
		driver:setValue( self, val2str(value[1]) )
		self:button:setValue(value[2])
	endif
return NIL

/* Get value */
static function ui_getValue(self)
	local v:=array(2)
	v[1] := driver:getValue( self )
	v[2] := self:button:getValue()
return v
