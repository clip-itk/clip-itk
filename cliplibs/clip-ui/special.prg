/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2004 by E/AS Software Foundation 		           */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Choice class (edit box with button for choosing values) */
function UIChoice( action, value, text )
	local o		:= UIHBox(,0)
	local obj 	:= UIButton( "...", action, value )
	obj:layout	:= o
	obj:edit	:= UIEdit( text )
	obj:edit:setReadOnly(.T.)
	obj:className 	:= "UIChoice"
	_recover_UICHOICE(obj)
return obj

function _recover_UICHOICE( obj )
	obj:setText	:= @ui_setText()
	obj:getText	:= @ui_getText()
return obj

/* Set text */
static function ui_setText(self, text)
	self:edit:setValue( value )
return NIL

/* Get text */
static function ui_getText(self)
return self:edit:getValue()
