/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003 by E/AS Software Foundation 		           */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()


/* Button class */
function UIButton( label, action, val )
	local obj	:= driver:createButton(label, action)
	obj:className	:= "UIButton"
	obj:val		:= val
	_recover_UIBUTTON(obj)
return obj

function _recover_UIBUTTON( obj )
	obj:setAction	:= @ui_setAction()
	obj:setPadding	:= @ui_setPadding()
	obj:setValue	:= @ui_setValue()
	obj:getValue	:= @ui_getValue()
return obj

/* Button bar class */
function UIButtonBar()
	local obj	:= UIHBox(, 5, 3 )
	obj:className	:= "UIButtonBar"
	obj:setEqualSize( .T. )
	obj:setAlignment( 0 )
return obj

/* Connect action to button */
static function ui_setAction(self, signal, action)
	if signal=='clicked' .and. valtype(action)=='B'
		driver:setAction( self, "clicked", action)
		driver:enableWidget( self, .T. )
	endif
return NIL

/* Set button padding */
static function ui_setPadding(self, padding)
	driver:setPadding( self, padding )
return NIL

/* Set value */
static function ui_setValue(self, value)
	self:val := value
return NIL

/* Get value */
static function ui_getValue(self)
return self:val

