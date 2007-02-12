/*-------------------------------------------------------------------------*/
/*   This is a part of library clip-postscript							   */
/*													                 	   */
/*   Copyright (C) 2007 by E/AS Software Foundation 					   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>						   */
/*  								 									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-postscript.ch"

#define PSTDEBUG	.F.

static valued_tags   := { "call", "value", "data", "condition" }
static currentObject := NIL

/** PSTemplate - Class for XPL templates */
function PSTemplate( o )
	local obj:=NIL
	
	if valtype(o) == 'O' .and. o:className == 'PSForm'
		obj := o
	else
		obj := PSForm()
		obj:className := "PSTemplate"
	endif
	obj:values  := array(0)
	obj:namedSections := map()
	
	_recover_PSTEMPLATE(obj)
return obj


function _recover_PSTEMPLATE( obj )
	obj:fill 		:= @ps_fill()
	obj:setNumber	:= @ps_setNumber()
	obj:setValue	:= @ps_setValue()
	obj:getValue	:= @ps_getValue()
return obj


/* Fill PSForm by data */
static function ps_fill( self )
	local tags:=array(0), t, root, i, j, res, hasParent, oErr
	
	oErr := errorBlock({|e| break(e) })
	begin sequence
		if PSTDEBUG
			?? "PSTemplate:fill()...&\n"
		endif
		currentObject := self
		self:values := array(0)
		if valtype(self:oXml) != 'O' .or. valtype(self:oXml:getRoot()) != 'O'
			return .F.
		endif
		root := self:oXml:getRoot()
		
		for i:=1 to len(valued_tags)
			res := root:XPath("//"+valued_tags[i])
			if valtype(res) == "A"
				for t in res
					hasParent := .F.
					for j in valued_tags
						if ps_hasParent( t, j )
							hasParent := .T.
						endif
					next
					//?? t:getName(), hasParent, chr(10)
					if .not. hasParent
						aadd( tags, t )
					endif
				next 
			endif
		next
		
		asort(tags,,,{|a,b| a:pos < b:pos })
		if PSTDEBUG
			?? "PSTemplate:fill() - number of top-level valued tags:", ltrim(str(len(tags))), "&\n"
		endif
		
		// Process valued tags
		for t in tags
			ps_templateExecute( self, t )
		next
		if PSTDEBUG
			?? "PSTemplate:fill() complete&\n"
		endif
	
	recover using oErr
		?? "PSTemplate:fill() error:", errorMessage(oErr), chr(10)
		return .F.
	end sequence

return .T.


/* Process single valued tag */
static function ps_templateExecute( self, t )
	local c, v:=NIL, vv, node, name, func, oErr
	local block, lpos, childs, content, ocontent, item, schilds, i, j
	local newData, pNode, pPos
	
	if valtype(t) != 'O'
		return .F.
	endif
	
	oErr := errorBlock({|e| break(e) })
	begin sequence
	
	if PSTDEBUG
		?? "process tag <"+t:getName()+">...", chr(10)
	endif
	switch lower(t:getName())
	
		case "value"
			// Single value
			name := t:attribute("name","")
			if empty(name)
				if PSTDEBUG
					?? "Warning: missing value name&\n"
				endif
				return NIL
			endif
			c := t:getChilds()
			if len(c) > 0
				for node in c
					vv := ps_templateExecute( self, node )
					self:setValue( name, vv )
				next
			else
				// Process simple <value>
				vv := t:getText() 
				func := lower(t:attribute("function",""))
				if .not. empty(func)
					switch func
						case "sum"
							self:setNumber( name )
							self:setValue( name, self:getValue( name ) + val(vv) )
						case "sub"
							self:setNumber( name )
							self:setValue( name, self:getValue( name ) - val(vv) )
						case "inc"
							self:setNumber( name )
							self:setValue( name, self:getValue( name ) + 1 )
						case "dec"
							self:setNumber( name )
							self:setValue( name, self:getValue( name ) - 1 )
						otherwise
							if PSTDEBUG
								?? "Warning: unknown function "+func+"&\n"
							endif
					endswitch
				else
					self:setValue( name, vv )
				endif
			endif
			v := self:getValue( name )
			if .not. ps_hasParent( t, "data" )
				t:remove()
			endif
			
		case "call"
			// Statement call
			childs := t:getChilds()
			ocontent := t:getText()
			if len(childs) > 0
				lpos := 0
				content := ""
				for item in childs
					v := ps_val2str( ps_templateExecute( self, item ) )
					content += substr(ocontent, lpos, item:offset-lpos) + v				
				next
				content += substr(ocontent, lpos, len(ocontent)-lpos) 
			else
				content := ocontent
			endif
			
			if PSTDEBUG
				?? "Execute expression:", content, chr(10)
			endif
			vv := "{|| " + content + " }"
			
			begin sequence
				v := eval( &vv )
			recover using oErr
				?? "Error on execute expression '"+content+"':", errorMessage(oErr), chr(10)
				return NIL
			end sequence
			
			if PSTDEBUG
				?? "Execute result:", v, chr(10)
			endif
			
			if .not. ps_hasParent( t, "data" )
				t:remove()
			endif
			
		case "data"
			// Iterated section
			newData := array(0)
			content := self:getValue(t:attribute("repeat",""))
			if valtype(content) == 'A' .and. len(content) > 0
				
				// Iterate each element
				for i:=1 to len(content)
					if PSTDEBUG
						?? "ITERATE", t:attribute("repeat",""), ltrim(str(i)), chr(10)
					endif
					self:setValue(t:attribute("repeat",""),i,i)
					childs := t:getChilds()
					for item in childs
						if ascan(valued_tags, {|e| e == item:getName() }) > 0
							// Execute statement
							ps_templateExecute( self, item )
						else
							// Pass orginary elements
							aadd(newData, ps_repeat(self, @item))
						endif
					next 
				next
				self:setValue(t:attribute("repeat",""), 0)
				
				// Replace data by newData
				pNode := t:getParent()
				pPos  := t:pos
				j := ascan(pNode:getChilds(), {|e| e:pos == pPos })
				if j > 0
					for i:=1 to len(newData)
						pNode:addChild( newData[i], j+i-1 )
					next
				endif
				if .not. ps_hasParent( t, "data" )
					t:remove()
				endif
				// Only for debug!
				//?? pNode:dump()
			endif
			
			
		case "condition"
			// Condition
			childs := t:getChilds()
			if len(childs) == 0
				?? "PSTemplate: missing value for <condition>&\n"
				v := NIL			
			else
				content := .T.
				vv := "NIL"				
				for item in childs
					if content 	// Value
						content := .F.
						vv := ps_val2str(ps_templateExecute( self, item ))
					else 		// Option
						if lower(item:getName()) == 'option'
							if vv == item:attribute("value","")
								schilds := item:getChilds()
								for i in schilds
									v := ps_templateExecute( self, i )
								next
							endif
						endif
					endif
				next
			endif
			if .not. ps_hasParent( t, "data" )
				t:remove()
			endif
			
		otherwise
			// Unknown tag. Ignored
			if PSTDEBUG
				?? "Warning: unsupported valued tag <"+t:getName()+">&\n"
			endif
			
	endswitch
	
	recover using oErr
		?? "Error process tag <"+t:getName()+">:", errorMessage(oErr), chr(10)
		return NIL
	end sequence

return v


/* Check if tag <t> has parent tag with name <tag> */
static function ps_hasParent( t, tag )
	local fnd:=.F., ct, n
	local s:=""
	
	if empty(tag) .or. valtype(t) != 'O' .or. .not. "GETNAME" $ t
		return .F.
	endif
	
	ct := t:getParent()
	do while .not. fnd .and. valtype(ct) == 'O'
		s := ct:getName() + "/"
		if lower(ct:getName()) == lower(tag)
			fnd := .T.
		endif
		ct := ct:getParent()
	enddo
	//?? "lookup", tag, "in", s, "=", fnd, chr(10)
	
return fnd


/* Transform value to number */
static function ps_setNumber( self, name )
	local i
	i := ascan(self:values, {|e| lower(e[1]) == lower(name) })
	if i > 0
		if valtype(self:values[i][2]) == 'C'
			self:values[i][2] := val(self:values[i][2])
		elseif valtype(self:values[i][2]) != 'N'
			self:values[i][2] := 0
		endif		
	endif
return NIL


/* Set form value */
static function ps_setValue( self, name, value, cItem )
	local i, ov:=NIL
	
	if empty(value)
		return NIL
	endif
	
	if PSTDEBUG
		?? "Set value:", name, "=", ps_val2str(value), ;
			iif(valtype(cItem) == 'N', "("+ltrim(str(cItem))+")",""),"&\n"
	endif

	i := ascan(self:values, {|e| lower(e[1]) == lower(name) })
	if i > 0
		if valtype(cItem) == 'N'
			self:values[i][3] := cItem
		else
			ov := self:values[i][2]
			self:values[i][2] := value
		endif
	else
		aadd(self:values, { name, value, cItem } )
	endif
return ov


/* Get form value */
static function ps_getValue( self, name )
	local i, origName, a, v:=NIL, sub
	
	origName := name
	a := split(name, ":")
	if len(a) > 1
		name := a[1]
		sub  := a[2]
	endif
	i := ascan(self:values, {|e| lower(e[1]) == lower(name) })
	if i > 0
		v := self:values[i][2]
		if len(a) > 1
			if valtype(v) == 'A'
				// Get context record
				if valtype(self:values[i][3]) == 'N' .and. self:values[i][3] > 0
					v := v[ self:values[i][3] ]
				endif
				// Extract index
				if left(sub,1) == '[' .and. right(sub,1) == ']'
					sub := val(substr(sub, 2, len(sub)-2))
					if sub > 0 .and. sub <= len(v)
						if PSTDEBUG
							?? "Get value:", origName, "=", ps_val2str(v[sub]), "&\n"
						endif
						return v[sub]
					endif 
				endif
			elseif valtype(v) == 'O'
				if upper(sub) $ v
					if PSTDEBUG
						?? "Get value:", origName, "=", ps_val2str(v[upper(sub)]), "&\n"
					endif
					return v[upper(sub)]
				endif
			endif
		endif
	else
		if PSTDEBUG
			?? "Warning: undefined value with name "+name+"&\n"
		endif
	endif
	
	if PSTDEBUG
		?? "Get value:", origName, "=", ps_val2str(v), "&\n"
	endif

return v


/* Fill item and return copy */
static function ps_repeat(self, tag)
	local t, childs, i, item, v, a, tN, tM, tA:=array(0)
	
	if valtype(tag) != 'O'
		return NIL
	endif
	
	if PSTDEBUG
		?? "repeat tag <"+tag:getName()+">&\n"
	endif
	
	// Copy object
	t := map()
	childs := mapkeys(tag)
	for i in childs
		tM := tag[i]
		if valtype(tM) == 'A' .and. hashStr("ATTRIBUTES") == i
			tA := aclone( tM )
			t[i] := tA
		else
			t[i] := tM
		endif
	next
	
	// Copy arrays
	childs := tag:getChilds()
	t:childs := array(0)
	
	// Store named tag
	tN := upper(t:attribute("name",""))
	if .not. empty(tN)
		//?? "NAMED:", tN, chr(10)
		self:namedSections[tN] := @t
	endif
	
	// Process childs
	for i:=1 to len(childs)
		item := childs[i]
		if ascan(valued_tags, {|e| e == item:getName() }) > 0
			// Execute statement
			v := ps_val2str(ps_templateExecute( self, item ))
			t:setText( v )
		else
			// Pass orginary elements
			t:addChild( ps_repeat(self, @item) )
		endif
		
	next
	
return t


/* Set style to named section */
// TODO: support all named elements
function setStyle( name, style )
	
	if empty(name) .or. empty(style) .or. valtype(currentObject) != 'O'
		return NIL
	endif
	//?? "SETSTYLE():", name, upper(name) $ currentObject:namedSections, mapkeys(currentObject:namedSections), chr(10)
	if upper(name) $ currentObject:namedSections
		currentObject:namedSections[upper(name)]:setAttribute("style", style)
	endif
	
return NIL


/* Transform any value to string */
static function ps_val2str( v, fmt )
	local t, s:="", l, i
	
	t := valtype(v)
	if valtype(fmt) != 'L'
		fmt := .F.
	endif
	
	switch t
		case 'C', 'D'
			s := iif(fmt, '"'+v+"'", v)
		case 'N'
			s := ltrim(str(v))
		case 'L'
			s := iif(v, '.T.', '.F.')
		case 'A'
			s := "{"
			for i in v
				s += " " + ps_val2str(i, .T.) + ","
			next
			s := left(s, len(s)-1) + " }"
		case 'O'
			l := mapkeys(v)
			s := "{"
			for i in l
				s += " " + i + ":" + ps_val2str(v[i], .T.) + ","
			next
			s := left(s, len(s)-1) + " }"
		case 'U'
			s := iif(fmt, 'NIL', '')
		otherwise
			s := ''
	endswitch
	
return s
	