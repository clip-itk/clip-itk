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

static driver := getDriver()

/* TODO: column and row manipulation, get/set values */

/* Table class */
function UITable(columns)
	local obj		:= driver:createTable(columns)
	obj:className	:= "UITable"
	obj:columns 	:= columns
	obj:nodes		:= map()
	obj:onSelect	:= NIL
// No alternate rows color by default
//	obj:altRowColor	:= NIL
// Set alternate rows color by default
	obj:altRowColor	:= UIColor(ALT_TABLE_ROW_COLOR)
	obj:lastId		:= 0
	_recover_UITABLE(obj)
return obj

function _recover_UITABLE( obj )
	obj:addRow			:= @ui_addRow()
	obj:setAction		:= @ui_setAction()
	obj:clear			:= @ui_clear()
	obj:getSelection 	:= @ui_getSelection()
	obj:getSelectionId 	:= @ui_getSelectionId()
	obj:getSelectionField := @ui_getSelectionField()
	obj:setAltRowColor 	:= @ui_setAltRowColor()
	obj:savePosition    := @ui_savePosition()
	obj:restorePosition := @ui_restorePosition()
return obj

/* Add row and fill it by data */
static function ui_addRow(self, data, id)
	local i, node
        
    // Fix missing id
    if id == NIL
       	self:lastId++
       	id := alltrim(str(self:lastId))
	endif
        
    // Convert values to strings
	for i=1 to len(data)
		data[i] := val2str(data[i])
	next
	node := driver:addTableRow(self, data)
	node:className := "UITableItem"
	node:table := @self
	node:node_id := id
	node:data := data
	self:nodes[node:id] = node
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

/* Clear all rows */
static function ui_clear(self)
	driver:clearTable( self )
	self:nodes := map()
	self:lastId := 0
return NIL

/* Get current selection */
static function ui_getSelection(self)
	local sel
	sel := driver:getTableSelection( self )
return sel

/* Get ID of selected string */
static function ui_getSelectionId(self)
	local sel, id:=NIL
	sel := driver:getTableSelection( self )
	//?? "Selection:", sel, sel $ self:nodes, chr(10)
	if .not. empty(sel) .and. sel $ self:nodes
		id := self:nodes[sel]:node_id
	else 
		return NIL
	endif
return id

/* Get field value on selected string  */
static function ui_getSelectionField(self, column)
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

/* Set alternate row color */
static function ui_setAltRowColor(self, color)
	self:altRowColor := UIColor(color)
	// TODO: redraw rows on alternate color changes
return NIL

/* Save current position to variable */
static function ui_savePosition(self)
	local pos
	pos := driver:getTablePosition( self )
return pos

/* Restore position from variable */
static function ui_restorePosition(self, pos)
	local ret, k, i, realPos:=NIL
	
	if valtype(pos) == 'A' .and. len(pos) == 2 .and. .not. empty(pos[2])
		k := mapkeys(self:nodes)
		for i:=1 to len(k)
			if self:nodes[k[i]]:node_id == pos[2]
				realPos := self:nodes[k[i]]:id
				exit
			endif
		next
		pos[1] := realPos
		ret := driver:setTablePosition( self, pos )
	endif
return ret
