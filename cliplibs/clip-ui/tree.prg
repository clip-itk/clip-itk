/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2003 by E/AS Software Foundation                        */
/*   Author: Igor Satsyuk <satsyuk@tut.by>                                 */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

static driver := getDriver()

/* 
TODO: id by data, not index, nice expand/collapse icons, possible remove lines, ignore expand/collapse as node activation on single LMB click, fill tree from object 
*/

/* Tree class */
function UITree(nTreeColumn, acNameColumns)
	local obj := driver:createTree(nTreeColumn, acNameColumns)
	obj:className 	:= "UITree"
	obj:nodes 	:= map()
	obj:onSelect 	:= NIL
	obj:lastId	:= 0
	_recover_UITREE(obj)
return obj

function _recover_UITREE( obj )
	obj:addNode 	:= @ui_addNode()
	obj:setAction 	:= @ui_setAction()
	obj:clear 	:= @ui_clear()
	obj:getSelection := @ui_getSelection()
	obj:getSelectionId := @ui_getSelectionId()
	obj:savePosition    := @ui_savePosition()
	obj:restorePosition := @ui_restorePosition()
return obj

/* Add node and fill it by data */
static function ui_addNode(self, columns, id, parent, sibling, expanded)
	local i, node
        
        // Fix missing id
        if id == NIL
        	self:lastId++
        	id := alltrim(str(self:lastId))
	endif
	
	// Convert values to strings
	for i=1 to len(columns)
	      	columns[i] := val2str(columns[i])
	next
	expanded := iif(valtype(expanded)=="U",.T.,expanded)
	node := driver:addTreeNode(self, parent, sibling, columns, expanded)
	node:className := "UITreeItem"
	node:tree := @self
	node:node_id := id
	self:nodes[node:id] = node
return node

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
	self:nodes := map()
	self:lastId := 0
return NIL

/* Get current selection */
static function ui_getSelection(self)
return driver:getTreeSelection( self )

/* Get current selection ID */
static function ui_getSelectionId(self)
	local sel, id
	sel := driver:getTreeSelection( self )
	if .not. empty(sel) .and. sel $ self:nodes
		id := self:nodes[sel]:node_id
	else 
		return NIL
	endif
return id

/* Save current position to variable */
static function ui_savePosition(self)
	local pos
	pos := driver:getTreePosition( self )
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
		ret := driver:setTreePosition( self, pos )
	endif
return ret
