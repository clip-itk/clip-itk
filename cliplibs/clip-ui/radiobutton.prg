/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2005 by E/AS Software Foundation			   */
/*   Author: Igor Satsyuk <satsyuk@tut.by>        			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* RadioGroup class */
function UIRadioGroup( )
	local obj := driver:createRadioGroup( )

	obj:className := "UIRadioGroup"
	_recover_UIRADIOGROUP(obj)
return obj

function _recover_UIRADIOGROUP( obj )
	obj:addButton := @ui_addButton()
return obj

/* Add RadioButton to RadioGroup */
static function ui_addButton(self, text)
	local obj := UIRadioButton( self, text)
return obj

/* RadioButton class */
function UIRadioButton( radiogroup, text )
	local obj := driver:createRadioButton(radiogroup, text )

	obj:className := "UIRadioButton"
	_recover_UIRADIOBUTTON(obj)
return obj

function _recover_UIRADIOBUTTON( obj )
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
