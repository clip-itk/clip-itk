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
	obj:getSelectionId 	:= @ui_getSelectionId()
/*	obj:getSelectionField := @ui_getSelectionField() */
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
return NIL

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
	self:nodes := map()
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
	local sel
	sel := driver:getTableSelection( self )
return sel

/* Get ID of selected string */
static function ui_getSelectionId(self)
	local sel, id:=NIL
return driver:getTableSelection( self, .T. )

/* Get field value on selected string  */
/*static function ui_getSelectionField(self, column)
	local sel, val:=NIL, node
	column = iif(empty(column),1,int(val(column)))
	sel := driver:getTableSelection( self )
	//?? "Selection:", sel, sel $ self:nodes, chr(10)
	if .not. empty(sel) .and. sel $ self:nodes
		node := self:nodes[sel]
		?? valtype(node:data), len(node:data), column, chr(10)
		if valtype(node:data) == "A" .and. len(node:data) >= column .and. column > 0
			val := node:data[column]
			//?? "Value:", val, chr(10)
		endif
	else 
		return NIL
	endif
return val
*/
/* Save current position to variable */
static function ui_savePosition(self)
	local pos
	pos := driver:getTablePosition( self )
return pos

/* Restore position from variable */
static function ui_restorePosition(self, pos)
	local ret, k, i, realPos:=NIL
	
	if valtype(pos) == 'A' .and. len(pos) == 2 .and. .not. empty(pos[2])
/*		k := mapkeys(self:nodes)
		for i:=1 to len(k)
			if self:nodes[k[i]]:node_id == pos[2]
				realPos := self:nodes[k[i]]:id
				exit
			endif
		next
		pos[1] := realPos
*/
		ret := driver:setTablePosition( self, pos )
	endif
return ret
