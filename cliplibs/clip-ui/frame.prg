/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation 	           */
/*   Author: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 13 Jan 2005						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* TODO: frame border, changing frame caption */

/* Frame class */
function UIFrame(caption, type)
	local obj 	:= driver:createFrame(caption, type)
	obj:className 	:= "UIFrame"
	_recover_UIFRAME(obj)
return obj

function _recover_UIFRAME( obj )
	obj:add		:= @ui_add()
	obj:setLabel	:= @ui_setLabel()
	obj:setType	:= @ui_setType()
return obj

/* Set grid for frame */
static function ui_add(self, grid)
	driver:setFrameGrid(self, grid)
return NIL

/* Set label for frame */
static function ui_setLabel(self, label)
	driver:setFrameLabel(self, label)
return NIL

/* Set frame type */
static function ui_setType(self, type)
	driver:setFrameType(self, type)
return NIL
