/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003,2004 by E/AS Software Foundation	           */
/*   Author: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 22 Jul 2004						   */
/*   									   */
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
	local obj	:= driver:createTable(columns)
	obj:className	:= "UITable"
	obj:rows	:= array(0)
	obj:rowsId	:= array(0)
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
        local i
        // Convert values to strings
	for i=1 to len(data)
		data[i] := val2str(data[i])
        next
	driver:addTableRow(self, data)
	aadd(self:rows, data)
	aadd(self:rowsId, id)
return NIL

/* Set action to UITable */
static function ui_setAction(self, action)
	// Set action to double-click or key ENTER pressed
	self:onSelect := action
	driver:setTableSelectAction( self, {|w,e| tableRowSelect(self, e)} )
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
	self:rows   := array(0)
	self:rowsId := array(0)
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
return iif(sel==0,NIL,self:rowsId[sel])

/* Set alternate row color */
static function ui_setAltRowColor(self, color)
	self:altRowColor := UIColor(color)
	// TODO: redraw rows on alternate color changes
return NIL

