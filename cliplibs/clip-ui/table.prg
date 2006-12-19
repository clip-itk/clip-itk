/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2003-2006 by E/AS Software Foundation                   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

static driver := getDriver()

/* Table column class */
function UITableColumn(name, caption, type)
	local obj	:= map()
	obj:className := 'UITableColumn'
	obj:name 	:= name
	obj:caption := caption
	obj:type 	:= type
	obj:editable := NIL
	obj:format  := ''
	obj:source	:= ''
	obj:lookup	:= .F.
	switch type
		case TABLE_COLUMN_NUMBER
			obj:default	:= 0
			obj:format := "%'.2f"
		case TABLE_COLUMN_COUNTER
			obj:default	:= 0
			obj:format := "%.0f"
		case TABLE_COLUMN_CHECK
			obj:default	:= .F.
		otherwise
			obj:default	:= ''
	endswitch			
return obj

/* Table class */
function UITable(columns)
	local obj		:= driver:createTable(columns)
	obj:className	:= "UITable"
	obj:columns 	:= columns
	obj:onSelect	:= NIL
	obj:lastId		:= 0
	_recover_UITABLE(obj)
return obj

function _recover_UITABLE( obj )
	obj:addRow			:= @ui_addRow()
	obj:setRow			:= @ui_setRow()
	obj:getRow			:= @ui_getRow()
	obj:removeRow		:= @ui_removeRow()
	obj:clear			:= @ui_clear()
	obj:setAction		:= @ui_setAction()
	obj:getSelection 	:= @ui_getSelection()
	obj:getValue	 	:= @ui_getValue()
	obj:setValue	 	:= @ui_setValue()
	obj:savePosition    := @ui_savePosition()
	obj:restorePosition := @ui_restorePosition()
return obj

/* Add row and fill it by data */
static function ui_addRow(self, data, id)
	local i, node
        
    // Fix missing id
    if id == NIL
       	self:lastId++
		id := self:lastId
	endif
   	if valtype(id) == 'N'
   		id := ltrim(str(id))
	endif
	node := driver:addTableRow(self, data, id)
return node

/* Set data for table row */
static function ui_setRow(self, row, data, id)
	local i, node
        
    // Fix missing id
    if id == NIL
       	self:lastId++
		id := self:lastId
	endif
   	if valtype(id) == 'N'
   		id := ltrim(str(id))
	endif
return driver:setTableRow(self, row, data, id)

/* Get data from table row as object */
static function ui_getRow(self, row)
return driver:getTableRow(self, row)

/* Get data from table row */
static function ui_removeRow(self, row)
return driver:removeTableRow(self, row)

/* Clear all rows */
static function ui_clear(self)
	driver:clearTable( self )
	self:lastId := 0
return NIL

/* Set action to UITable */
static function ui_setAction(self, signal, action)
	// Set action to double-click or key ENTER pressed
	if signal=='selected' .and. valtype(action)=='B'
		self:onSelect := action
		driver:setTableSelectAction( self, {|w,e| tableRowSelect(self, e)} )
	endif
return NIL

/* Slot for table selection */
function tableRowSelect(table, event)
	if driver:conditionTableSelection(table, event)
		eval(table:onSelect, table, table:getSelection() )
	endif
return

/* Get current selection */
static function ui_getSelection(self)
return driver:getTableSelection( self )

/* Get ID of selected string */
static function ui_getValue(self)
return driver:getTableSelection( self, .T. )

/* Set selection by ID */
static function ui_setValue(self, id)
return driver:setTableSelection( self, id )

/* Save current position to variable */
static function ui_savePosition(self)
return driver:getTablePosition( self )

/* Restore position from variable */
static function ui_restorePosition(self, pos)
	local ret
	
	if valtype(pos) == 'A' .and. len(pos) == 2 .and. .not. empty(pos[2])
		ret := driver:setTablePosition( self, pos )
	endif
return ret
