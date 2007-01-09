/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-XML library                                    */
/*                                                                         */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation                   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

#define TAGSPACER	'    '

/* Base class for XML tag */
function XMLTag( name )
	local obj 	:= map()
	obj:className := "XMLTag"
	obj:name	:= name
	obj:text	:= ""
	obj:offset 	:= 0
	obj:attributes := array(0)
	obj:parent	:= NIL
	obj:childs	:= array(0)
	obj:o		:= NIL
	_recover_XMLTAG(obj)
return obj

function _recover_XMLTAG( obj )
	obj:getName			:= @xml_TagGetName()
	obj:addChild 		:= @xml_TagAddChild()
	obj:removeChild 	:= @xml_TagRemoveChild()
	obj:countChilds 	:= @xml_TagCountChilds()
	obj:getChild 		:= @xml_TagGetChild()
	obj:getChilds 		:= @xml_TagGetChilds()
	obj:setAttribute 	:= @xml_TagSetAttribute()
	obj:attribute 		:= @xml_TagGetAttribute()
	obj:getAttributes 	:= @xml_TagGetAttributes()
	obj:removeAttribute := @xml_TagRemoveAttribute()
	obj:setText	 		:= @xml_TagSetText()
	obj:getText	 		:= @xml_TagGetText()
	obj:getParent		:= @xml_TagGetParent()
	obj:dump			:= @xml_TagDump()
	obj:XPath			:= @xml_TagXPath()
return obj

/* Get tag name */
static function xml_TagGetName( self )
return self:name

/* Add child tag */
static function xml_TagAddChild( self, tag, position )
	if valtype(tag) != "O" .or. tag:className != "XMLTag"
		return .F.
	endif
	if empty(position) .or. self:countChilds() < position
		aadd( self:childs, tag )
	else
		self:childs[ position ] := tag
	endif
	tag:parent := self
return .T.

/* Remove child tag by its number */
static function xml_TagRemoveChild( self, position )
	if empty(position) .or. self:countChilds() > position
		self:childs := array(0)
		return .T.
	endif
	adel( self:childs, position )
	asize( self:childs, self:countChilds()-1 )
return .T.

/* Number of child tags */
static function xml_TagCountChilds( self )
return len(self:childs)

/* Get child tag by its number */
static function xml_TagGetChild( self, position )
	if empty(position) .or. self:countChilds() > position
		return NIL
	endif
return self:childs[ position ]

/* Get all childs */
static function xml_TagGetChilds( self )
return self:childs

/* Set tag attribute */
static function xml_TagSetAttribute( self, attrName, attrValue )
	local p, sValue
	
	// Transform attrValue to string
	switch valtype(attrValue)
		case 'C'
			sValue := attrValue
		case 'N'
			sValue := ltrim( str( attrValue ) )
		case 'L'
			sValue := iif( attrValue, "true", "false" )
		case 'D'
			sValue := dtoc( attrValue )
		otherwise
			sValue := attrValue
	endswitch
	
	// Lookup attribute name
	p := ascan( self:attributes, {|e| e[1]==attrName } )
	if p == 0
		aadd( self:attributes,{ attrName, sValue } )
	else
		self:attributes[ p ] := { attrName, sValue }
	endif
	//?? "set attribute", attrName, valtype(sValue), chr(10)
return .T.

/* Get attribute value */
static function xml_TagGetAttribute( self, attrName, defVal )
	local p
	p := ascan( self:attributes, {|e| e[1]==attrName } )
	if p == 0
		return defVal
	endif
return self:attributes[p][2]

/* Get all attributes */
static function xml_TagGetAttributes( self )
return self:attributes

/* Remove tag attribute */
static function xml_TagRemoveAttribute( self, attrName )
	local p
	p := ascan( self:attributes, {|e| e[1]==attrName } )
	if p == 0
		return .F.
	endif
	adel( self:attributes, p )
	asize( self:attributes, len(self:attributes)-1 )
return .T.

/* Set tag text */
static function xml_TagSetText( self, text )
	self:text := text
return 

/* Get tag text */
static function xml_TagGetText( self )
return self:text

/* Get parent of tag */
static function xml_TagGetParent( self )
return self:parent

/* Dump tag and its childs */
static function xml_TagDump( self, encoding, level )
	local indent:='', s:='', a, lastOffset:=1, hasInlineTags:=.F., ct, a2
	
	//?? self:name,chr(10)
	// Set indentation
	if empty(level)
		level := 0 
	endif
	if level > 0
		indent := replicate(TAGSPACER, level)
	endif
	
	//?? "attrs&\n"
	// Print tag and attributes
	s := indent + "<" + self:name + " "
	//?? self:attributes,chr(10)
	for a in self:attributes
		s += a[1] + '="' + xmlText( a[2] ) + '" '
	next
	
	//?? "childs&\n"
	if len(self:childs) == 0
		if .not. empty(self:text)
			s := rtrim(s) + ">" + xmlText( self:text ) + "</" + self:name + ">&\n"
		else
			s += "/>&\n"
		endif
	else
		s := rtrim(s) + ">"
		// Look for inline tags (mixed tags and text)
		for a in self:childs
			if a:offset > 0
				hasInlineTags := .T.
				exit
			endif
		next
		if hasInlineTags
			for a in self:childs
				ct := ltrim( a:dump( encoding, level+1 ) )
				ct := left( ct, len(ct)-1 )
				if a:offset > 0
					s += xmlText( substr( self:text, lastOffset, a:offset-lastOffset+1 ) )
					lastOffset := a:offset
				endif
				s += ct
			next
			s += xmlText( substr(self:text, lastOffset+1 ) ) + "</" + self:name + ">&\n"
		
		else
			s += "&\n"
			for a in self:childs
				s += a:dump( encoding, level+1 )
			next
			s += indent + xmlText( self:text ) + "</" + self:name + ">&\n"
		endif
	endif
return s

static function xmlText( text )
	text := iif( valtype(text)=='C', text, '' )
	text := strtran( text, '&', '&amp;' )
	text := strtran( text, '>', '&gt;' )
	text := strtran( text, '<', '&lt;' )
	text := strtran( text, '"', '&quot;' )
	text := strtran( text, "'", '&apos;' )
return text

/* Get tag(s) by XPath */
static function xml_TagXPath( self, path )
return xml_XPath( self, path )