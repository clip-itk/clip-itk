/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003 by E/AS Software Foundation 		           */
/*   Author: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 30 Mar 2004						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Combobox class */
function UIComboBox( values, defaultItem )
	local obj 	:= driver:createComboBox( values )
	obj:className 	:= "UIComboBox"
	obj:list	:= values
	_recover_UICOMBOBOX(obj)
	if .not. empty( defaultItem )
		driver:setValue( obj, defaultItem )
	endif
return obj

function _recover_UICOMBOBOX( obj )
	obj:setList	:= @ui_setList()
	obj:setValue	:= @ui_setValue()
	obj:getValue	:= @ui_getValue()
return obj

/* Set list of strings */
static function ui_setList(self, values)
	self:list	:= values
	driver:setComboBoxList( self, values )
return NIL

/* Set value */
static function ui_setValue(self, value)
	driver:setValue( self, value )
return NIL

/* Get value */
static function ui_getValue(self)
return driver:getValue( self )
