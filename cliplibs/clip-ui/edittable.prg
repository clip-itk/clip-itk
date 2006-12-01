/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2003,2004 by E/AS Software Foundation                   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

/** UIEditTable - class for table, editable by user */

/* Tests:
	- create table with columns: 
		- autoincremented #
		- choice
		- combobox
		- text
		- number
		- checkbox
		- date
	- add default row (program and manual by Ins or Arrow Down on last row)
	+ set row data
	- remove row (program and manual with confirmation)
	+ get/set field
	? get/set property
	- get/set data of whole table
	- slots (changed)
	+ number of rows
	? selected row/column
   BUGS:
	- last i in codeblock - value doesn't store (need current selection)
	- number is shown as integer
	
*/

static driver := getDriver()


/* EditTable column class */
function UIEditTableColumn(name, caption, type)
	local obj	:= map()
	obj:name 	:= name
	obj:caption := caption
	obj:type 	:= type
	obj:editable := .T.
return obj


/* EditTable class */
function UIEditTable(columns)
	local obj		:= driver:createEditTable(columns)
	obj:className	:= "UIEditTable"
	_recover_UIEDITTABLE(obj)
return obj

function _recover_UIEDITTABLE( obj )
	// Row manupulation
	obj:addRow			:= @ui_addRow()
	obj:setRow			:= @ui_setRow()
	obj:getRow			:= @ui_getRow()
	obj:removeRow		:= @ui_removeRow()
	obj:clear			:= @ui_clear()
	// Slot
	obj:setAction		:= @ui_setAction()
	// Value
	obj:setField 		:= @ui_setField()
	obj:getField 		:= @ui_getField()
	obj:setValue		:= @ui_setValue()
	obj:getValue		:= @ui_getValue()
	// Property
	obj:setProperty		:= @ui_setProperty()
	obj:getProperty		:= @ui_getProperty()
return obj

/* Add row and fill it by data */
static function ui_addRow(self, data, id)
	local node
	node := driver:addEditTableRow(self, data)
return NIL

/* Set data for table row */
static function ui_setRow(self, row, data)
return driver:setEditTableRow(self, row, data)

/* Get data from table row as object */
static function ui_getRow(self, row)
return driver:getEditTableRow(self, row)

/* Get data from table row */
static function ui_removeRow(self, row)
return driver:removeEditTableRow(self, row)

/* Set action */
static function ui_setAction(self, signal, action)
	if signal=='changed' .and. valtype(action)=='B'
		self:onChanged := action
		driver:setAction( self, 'changed', action )
	endif
return NIL

/* Clear all rows */
static function ui_clear(self)
	driver:clearEditTable( self )
return NIL

/* Get current selection */
static function ui_getSelection(self)
	local sel
	sel := driver:getEditTableSelection( self )
return sel

/* Set field contents */
static function ui_setField(self, row, column, value)
return driver:setEditTableField(self, row, column, value)

/* Get field contents */
static function ui_getField(self, column, row)
return driver:getEditTableField(self, column, row)

/* Fill table */
static function ui_setValue(self, data)
return driver:setValue(self, data)

/* Get table contents */
static function ui_getValue(self)
return driver:getValue(self)

/* Set table property */
static function ui_setProperty(self, name, value)
return driver:setEditTableProperty(self, name, value)

/* Get table property */
static function ui_getProperty(self, name)
return driver:getEditTableProperty(self, name)
