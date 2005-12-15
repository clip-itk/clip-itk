/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation 	           */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

static driver := getDriver()

/* vertical container class */
function UIVBox(o, spacing, padding)
	local obj	:= driver:createVBox(o, spacing, padding)
	obj:spacing	:= iif(empty(spacing),0,spacing)
	obj:padding	:= iif(empty(padding),0,padding)
	obj:className	:= "UIVBox"
	obj:elem	:= array(0)
	_recover_UIBOX(obj)
return obj

/* horizontal container class */
function UIHBox(o, spacing, padding)
	local obj	:= driver:createHBox(o, spacing, padding)
	obj:spacing	:= iif(empty(spacing),0,spacing)
	obj:padding	:= iif(empty(padding),0,padding)
	obj:className	:= "UIHBox"
	obj:elem	:= array(0)
	_recover_UIBOX(obj)
return obj

function _recover_UIBOX( obj )
	obj:add   	:= @ui_add()
	obj:addEnd	:= @ui_addEnd()
	obj:setSpacing	:= @ui_setSpacing()
	obj:setPadding  := @ui_setPadding()
	obj:setAlignment := @ui_setAlignment()
	obj:setEqualSize := @ui_setEqualSize()
return obj

/* Table grid class */
function UIGrid(o, grow, gcol, spacing, padding)
	local obj	:= driver:createGrid(o, grow, gcol, spacing, padding)
	obj:spacing	:= iif(empty(spacing),0,spacing)
	obj:padding	:= iif(empty(padding),2,padding)
	obj:className	:= "UIGrid"
	_recover_UIGRID(obj)
return obj

function _recover_UIGRID( obj )
	obj:add   	:= @ui_addGrid()
	obj:setSpacing	:= @ui_setSpacing()
	obj:setPadding  := @ui_setPadding()
	obj:setAlignment := @ui_setAlignment()
	obj:setEqualSize := @ui_setEqualSize()
return obj

/* Vertical or horisontal splitter */
function UISplitter(type)
	local obj	:= driver:createSplitter(type)
	obj:className	:= "UISplitter"
	obj:first 	:= NIL
	obj:second 	:= NIL
	_recover_UISPLITTER(obj)
return obj

function _recover_UISPLITTER( obj )
	obj:add   	:= @ui_addSplitPane()
	obj:addEnd   	:= @ui_addSplitPaneEnd()
	obj:setPosition := @ui_setSplitterPosition()
return obj

/* Add object to begin of grid */
static function ui_add(self, o, expand, fill, padding)
        if empty(expand)
		expand := .F.
	endif
	driver:addBox(self, o, expand, fill, padding)
	aadd(self:elem, o)
return o

/* Add object to end of grid */
static function ui_addEnd(self, o, expand, fill, padding)
	driver:addBoxEnd(self, o, expand, fill, padding)
 	aadd(self:elem, o)
return o

/* Set box spacing */
static function ui_setSpacing(self, space)
	driver:setBoxSpacing(self, space)
return NIL

/* Set box border */
static function ui_setPadding(self, space)
	driver:setPadding(self, space)
return NIL

/* Get grid spacing */
static function ui_getSpacing(self)
	driver:getGridSpacing(self)
return NIL

/* Add object to specified position in table grid */
static function ui_addGrid(self, o, pos, h_expand, v_expand)
	driver:addGrid(self, o, pos, h_expand, v_expand)
return NIL

/* Set box alignment */
static function ui_setAlignment(self, align, valign)
	driver:setBoxAlignment(self, align, valign)
return NIL

/* Set box elements equal size */
static function ui_setEqualSize(self, isEqual)
	driver:setBoxElemEqualSize(self, isEqual)
return NIL
	
/* Add widget to left/top pane */
static function ui_addSplitPane(self, obj)
	driver:addSplitPane(self, obj)
	self:first := obj
return NIL

/* Add widget to right/bottom pane */
static function ui_addSplitPaneEnd(self, obj)
	driver:addSplitPaneEnd(self, obj)
	self:second := obj
return NIL

/* Set splitter position */
static function ui_setSplitterPosition(self, pos)
	driver:setSplitterPosition(self, pos)
return NIL
