/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation                   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* Combobox class */

/* NOTE: for Windows-like drop-down list add 
	GtkComboBox::appears-as-list = 1
	GtkButton::inner-border = { 0, 0, 0, 0 }
	in used theme
*/

function UIComboBox( source, defaultItem )
	local obj 		:= driver:createComboBox()
	obj:className 	:= "UIComboBox"
	obj:source		:= NIL
	obj:value		:= defaultItem
	_recover_UICOMBOBOX(obj)
	
	obj:setSource( source )
	if .not. empty( defaultItem )
		obj:setValue( defaultItem )
	endif
return obj

function _recover_UICOMBOBOX( obj )
	obj:setSource	   := @ui_setSource()
	obj:setValue	   := @ui_setValue()
	obj:getValue	   := @ui_getValue()
return obj

/* Set list of strings */
static function ui_setSource(self, source)
	self:source := UISource(source)
	driver:setComboBoxList( self, self:source:getList() )
		
	if .not. empty( self:value )
		self:setValue( self:value )
	endif

return NIL

/* Set value */
static function ui_setValue(self, value)
	self:value := value
	driver:setValue( self, self:source:setValue(value) )
return NIL

/* Get value */
static function ui_getValue(self)
return self:source:getValue( driver:getValue( self ) )

