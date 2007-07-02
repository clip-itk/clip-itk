/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2006 by E/AS Software Foundation                        */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

/** UISource - class for field source */

/*  UISource uses external function for external sources:
	getAttributeValue(<source>,[<id>])
		<source> should has format: 'db:class:attribute'
		<id> is object id

	If <id> is NIL, getAttributeValue() should returns array with possible 
	values as pair {'value', 'id'}. If <id> is defined, getAttributeValue()
	should returns object field values specified by <source>.
*/

static driver := getDriver()

/* Field source class */
function UISource(source)
	local obj   := map()
	
	if valtype(source) == 'O' ;
			.and. 'CLASSNAME' $ source ;
			.and. source:className == 'UISource'
		return source
	endif
	
	obj:source 	:= source
	obj:list    := array(0)
	obj:size	:= 0
	obj:extern  := .F.
	
	if valtype(source) == 'C'	// External source 
		obj:extern := .T.
	elseif valtype(source) == 'A' // Internal source
		ui_fillList(obj, source)
	else
		obj:source := NIL
	endif
	_recover_UISOURCE(obj)

return obj

/* Methods */
static function _recover_UISOURCE( obj )
	obj:getList	   := @ui_getList()
	obj:getValue   := @ui_getValue()
	obj:getValueByText := @ui_getValueByText()
	obj:setValue   := @ui_setValue()
	obj:getText	   := @ui_getText()
return obj

/* Internal function for normalize passed list */
static function ui_fillList(obj, source)
	local i, e, id
	obj:list := array(0)
	if valtype(source) == 'A'
		obj:size := len(source)
		for i:=1 to obj:size
			e := source[i]
			if valtype(e) == 'A'
				if len(e) > 1
					aadd(obj:list, { val2str(e[1]), val2str(e[2]) })
				elseif len(e) == 1
					aadd(obj:list, { val2str(e[1]), ltrim(str(i)) })
				else
					aadd(obj:list, { '', ltrim(str(i)) })
				endif
			else
				aadd(obj:list, { val2str(e), ltrim(str(i)) })
			endif
		next
	endif
	obj:size := len(obj:list)
return NIL

/* Get source list */
static function ui_getList(self)
	if self:extern
			self:list := array(0)
			if isFunction("GETATTRIBUTEVALUE")
				ui_fillList(self, getAttributeValue( self:source, NIL ))
			endif
	endif
return self:list

/* Get index by id */
static function ui_setValue(self, id)
	id := val2str(id)
return ascan(self:list, {|e| e[2] == id })

/* Get id by index */
static function ui_getValue(self, id)
	if valtype(id) == 'N'
		if id > 0 .and. id <= self:size
			return self:list[id][2]
		endif
	else
		return id
	endif
return NIL

/* Get value by text */
static function ui_getValueByText(self, text)
	local v:=NIL,i
	text := val2str(text)
	i := ascan(self:list, {|e| e[1] == text })
	if i > 0
		v := self:list[i][2]
	endif
return v 

/* Get text by id */
static function ui_getText(self, id)
	local v:=NIL, i
	if self:extern .and. isFunction("GETATTRIBUTEVALUE")
		//?? "GETTEXT:", self:source, id, getAttributeValue( self:source, id ), chr(10)
		return getAttributeValue( self:source, id )
	endif
	id := val2str(id)
	i := ascan(self:list, {|e| e[2] == id })
	if i > 0
		v := self:list[i][1]
	endif
return v 
