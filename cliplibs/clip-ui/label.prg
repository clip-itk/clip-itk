/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003 by E/AS Software Foundation 		           */
/*   Author: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 15 Feb 2004						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Label class */
function UILabel( text )
	local obj 	:= driver:createLabel( text )
	obj:className 	:= "UILabel"
	obj:value	:= text
	_recover_UILABEL(obj)
return obj

function _recover_UILABEL( obj )
	obj:setText	:= @ui_setText()
	obj:setValue	:= @ui_setText()
	obj:getValue	:= @ui_getText()
return obj

/* Set label text */
static function ui_setText(self, text)
	driver:setLabelText(self, val2str(text) )
	self:value := text
return NIL

/* Get label text */
static function ui_getText(self)
return self:value
