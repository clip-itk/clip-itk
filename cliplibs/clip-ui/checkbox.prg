/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation 		   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Checkbox class */
function UICheckBox( value, label )
	local obj	:= driver:createCheckBox(value, label)
	obj:className	:= "UICheckBox"
	_recover_UICHECKBOX(obj)
return obj

function _recover_UICHECKBOX( obj )
	obj:setValue	:= @ui_setValue()
	obj:getValue	:= @ui_getValue()
return obj

/* Set value */
static function ui_setValue(self, value)
	driver:setValue( self, value )
return NIL

/* Get value */
static function ui_getValue(self)
return driver:getValue( self )
