/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2003-2006 by E/AS Software Foundation                   */
/*   Authors: Igor Satsyuk <satsyuk@tut.by>                                */
/*            Andrey Cherepanov <skull@eas.lrn.ru>                         */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

static driver := getDriver()

/* 
	TODO: nice expand/collapse icons, ignore expand/collapse as node 
	activation on single LMB click
*/

/* Tree class */
function UITree(columns, nTreeColumn)
	local obj 		:= driver:createTree(columns, nTreeColumn)
	obj:className 	:= "UITree"
	obj:columns 	:= columns
	obj:onSelect 	:= NIL
	obj:lastId		:= 0
	_recover_UITREE(obj)
return obj

function _recover_UITREE( obj )
	obj:addNode 	 	:= @ui_addNode()
	obj:setRow		 	:= @ui_setRow()
	obj:getRow			:= @ui_getRow()
	obj:removeRow		:= @ui_removeRow()
	obj:setAction 	 	:= @ui_setAction()
	obj:clear 	     	:= @ui_clear()
	obj:getSelection 	:= @ui_getSelection()
	obj:getValue     	:= @ui_getValue()
	obj:setValue     	:= @ui_setValue()
	obj:savePosition    := @ui_savePosition()
	obj:restorePosition := @ui_restorePosition()
return obj

/* Add node and fill it by data */
static function ui_addNode(self, data, id, parent, sibling, expanded)
	local node
        
	// Fix missing id
    if id == NIL
		self:lastId++
		id := alltrim(str(self:lastId))
	endif
   	if valtype(id) == 'N'
   		id := ltrim(str(id))
	endif
	
	expanded := iif(valtype(expanded)=="U", .T., expanded)
	node := driver:addTreeNode(self, parent, sibling, data, expanded, id)
return node

/* Set data for tree row */
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
return driver:setTreeRow(self, row, data, id)

/* Get data from tree row as object */
static function ui_getRow(self, row)
return driver:getTreeRow(self, row)

/* Get data from tree row */
static function ui_removeRow(self, row)
return driver:removeTreeRow(self, row)

/* Set action to UITree */
static function ui_setAction(self, signal, action)
  	// Set action to single-click LMB or key ENTER pressed
	if signal=='selected' .and. valtype(action)=='B'
		self:onSelect := action
		driver:setTreeSelectAction( self, {|w,e| treeNodeSelect(self, e)} )
	endif
return NIL

/* Slot for tree selection */
function treeNodeSelect(tree, event)
  	if driver:conditionTreeSelection(tree, event)
     		eval(tree:onSelect, tree, tree:getSelection(event))
	endif
return

/* Clear all nodes */
static function ui_clear(self)
	driver:clearTree( self )
	self:lastId := 0
return NIL

/* Get current selection */
static function ui_getSelection(self)
return driver:getTreeSelection( self )

/* Get current selection ID */
static function ui_getValue(self)
return driver:getTreeSelection( self, .T. )

/* Set selection by ID */
static function ui_setValue(self, id)
	if valtype(id) == 'A' .and. len(id) > 0
		id := id[1]		
	endif
return driver:setTreeSelection( self, id )

/* Save current position to variable */
static function ui_savePosition(self)
return driver:getTreePosition( self )

/* Restore position from variable */
static function ui_restorePosition(self, pos)
	local ret
	if valtype(pos) == 'A' .and. len(pos) == 2 .and. .not. empty(pos[2])
		ret := driver:setTreePosition( self, pos )
	endif
return ret
