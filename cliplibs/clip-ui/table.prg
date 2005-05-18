/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003,2004 by E/AS Software Foundation	           */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

static driver := getDriver()

/* TODO: column and row manipulation, get/set values, id by data, not index */

/* Table class */
function UITable(columns)
	local obj	:= driver:createTable(columns)
	obj:className	:= "UITable"
	obj:nodes	:= map()
	obj:onSelect	:= NIL
// No alternate rows color by default
//	obj:altRowColor	:= NIL
// Set alternate rows color by default
	obj:altRowColor	:= UIColor(ALT_TABLE_ROW_COLOR)
	_recover_UITABLE(obj)
return obj

function _recover_UITABLE( obj )
	obj:addRow	:= @ui_addRow()
	obj:setAction	:= @ui_setAction()
	obj:clear	:= @ui_clear()
	obj:getSelection := @ui_getSelection()
	obj:getSelectionId := @ui_getSelectionId()
	obj:setAltRowColor := @ui_setAltRowColor()
return obj

/* Add row and fill it by data */
static function ui_addRow(self, data, id)
        local i, node
        // Convert values to strings
	for i=1 to len(data)
		data[i] := val2str(data[i])
        next
	node := driver:addTableRow(self, data)
	node:className := "UITableItem"
	node:table := @self
	node:node_id := id
	// TODO: set action to item object
	
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
return NIL

/* Get current selection */
static function ui_getSelection(self)
	local sel
	sel := driver:getTableSelection( self )
return sel

/* Get current selection ID */
static function ui_getSelectionId(self)
	local sel
	sel := driver:getTableSelection( self )
return self:nodes[sel]:node_id

/* Set alternate row color */
static function ui_setAltRowColor(self, color)
	self:altRowColor := UIColor(color)
	// TODO: redraw rows on alternate color changes
return NIL

