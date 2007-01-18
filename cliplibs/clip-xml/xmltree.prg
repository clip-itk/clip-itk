/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-XML library                                    */
/*                                                                         */
/*   Copyright (C) 2003-2006 by E/AS Software Foundation                   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include <clip-expat.ch>
#define FILEBLOCK	1024

/* XMLTree class */
function XMLTree( encoding )
	local obj	:= map()
	obj:className	:= "XMLTree"
	obj:encoding	:= iif( empty(encoding), "utf-8", encoding )
	obj:error	:= ""
	obj:root	:= NIL
	_recover_XMLTREE(obj)
return obj

function _recover_XMLTREE( obj )
	obj:parseFile 	:= @xml_ParseFile()
	obj:parseString := @xml_ParseString()
	obj:getRoot		:= @xml_GetRoot()
	obj:setRoot		:= @xml_SetRoot()
	obj:getError	:= @xml_GetError()
	obj:XPath		:= @xml_GetXPath()
	obj:dump		:= @xml_Dump()
return obj

/* Parse XML from file */
static function xml_ParseFile( self, filename )
	local parser, file, buf:=space(1024), var, nRead

	// Create parser
	parser := xml_ParserCreate()
	
	// Set handler functions
	var:=map()
	var:ct := NIL
	var:pt := NIL
	var:root := NIL
	var:parser := parser
	xml_SetUserData(parser, @var)
	xml_SetCharacterDataHandler( parser, @xml_handleText() )
	xml_SetElementHandler( parser, @xml_handleElementStart(), @xml_handleElementEnd() )
	
	file = fopen(filename)
	do while !fileeof(file)
		nRead := fread(file, @buf, 1024)
		// Parse buffer
		xml_Parse(parser, @buf, nRead, fileeof(file))
		// Handle buffer
		if xml_GetErrorCode(parser) <> 0
			self:error := xml_ErrorString(parser) + ;
			" at line "+alltrim( str(xml_GetCurrentLineNumber(parser)) ) + ;
			", column "+alltrim( str(xml_GetCurrentColumnNumber(parser)) )
			return .F.
		endif
	enddo
	
	// Close file and free Expat parser
	self:root := var:root
	fclose(file)
	xml_ParserFree(parser)

return .T.

/* Parse XML from string */
static function xml_ParseString( self, string )
	local parser, var

	// Create parser
	parser := xml_ParserCreate()
	
	// Set handler functions
	var:=map()
	var:ct := NIL
	var:pt := NIL
	var:root := NIL
	var:parser := parser
	xml_SetUserData(parser, @var)
	xml_SetCharacterDataHandler( parser, @xml_handleText() )
	xml_SetElementHandler( parser, @xml_handleElementStart(), @xml_handleElementEnd() )
	
	// Parse string
	xml_Parse(parser, string, len(string), .T.)
		
	// Handle buffer
	if xml_GetErrorCode(parser) <> 0
		self:error := xml_ErrorString(parser) + ;
		" at line "+alltrim( str(xml_GetCurrentLineNumber(parser)) ) + ;
		", column "+alltrim( str(xml_GetCurrentColumnNumber(parser)) )
		return .F.
	endif

	// Free Expat parser
	self:root := var:root
	xml_ParserFree(parser)
	
return .T.

/* Get root tag */
static function xml_GetRoot( self )
return self:root

/* Set XMLTag as root tag */
static function xml_SetRoot( self, tag )
	if valtype(tag) != "O" .or. tag:className != "XMLTag"
		return NIL
	endif
	self:root := tag
return tag

/* Get parse error */
static function xml_GetError( self )
return self:error

/* Get tag(s) by XPath */
static function xml_getXPath( self, path, tag )
	local t:=NIL
	if valtype(tag) == "O" .and. tag:className == "XMLTag"
		t := tag
	else
		t := self:root
	endif
return xml_XPath( t, path )

/* Dump tree as XML string */
static function xml_Dump( self, tag )
	local t, s, header:="", localEncoding
	
	//?? valtype(self:root),chr(10)
	if valtype(tag) == "O" .and. tag:className == "XMLTag"
		t := tag
	elseif .not. empty(self:root)
		t := self:root
		header := '<?xml version="1.0" encoding="'+self:encoding+'" ?>'+chr(10)+chr(10)
	else
		return ""
	endif
	
	s := self:root:dump()
	
	// encode all file: s and self:encoding
	localEncoding := host_charset()
	//?? "BEFORE ",self:encoding, localEncoding,":", s, chr(10)
	if self:encoding != localEncoding
		s := translate_charset( localEncoding, self:encoding, s)
	endif
	//?? "AFTER", s, chr(10)
	s := header + s
return s

/**===========================================================================
   Handler function for Expat
*/

/* Handler function for start tag */
function xml_handleElementStart( vUser, name, aAttr )
	// Create new XMLTag object
	//?? "<"+name+">&\n"
	vUser:ct := XMLTag( name )
	vUser:ct:pos := xml_GetCurrentByteIndex( vUser:parser )
	vUser:ct:parent := vUser:pt
	
	aeval( aAttr, {|e| e[2]:=translate_charset( "utf-8", host_charset(), e[2]) } )
	vUser:ct:attributes := aAttr
		
	// Append child to parent tag	
	if valtype(vUser:pt) == "O" .and. "CHILDS" $ vUser:pt
		aadd(vUser:pt:childs, vUser:ct)
		vUser:ct:offset := len(vUser:pt:text)
	else
		vUser:root := vUser:ct
	endif
	vUser:pt := vUser:ct
return

/* Handler function for close tag */
function xml_handleElementEnd( vUser, name )
	//vUser:ct:text := substr(vUser:ct:text, 1, len(vUser:ct:text)-1)
	vUser:pt := vUser:pt:parent
	vUser:ct := vUser:pt
return

/* Handler function for text processing */
function xml_handleText( vUser, sStr, nLen )
	local s, l
	
	s := translate_charset( "utf-8", host_charset(), sStr )
/*	
	if .not. empty(sStr)
		?? "TEXT:", host_charset(), sStr, translate_charset( "utf-8", "koi8-r", alltrim(sStr) ), chr(10)
	endif
*/
/*
	if .not. empty(s)
		?? len(s), "'"+strtran(s,chr(10),'\n')+"'", chr(10)
	endif
*/
//	if .not. empty(s) .and. .not. empty(vUser:ct)
	if .not. empty(vUser:ct)
		/*if len(s) == 1 .and. s $ '"<>'+chr(38)+chr(39)
			l := len(vUser:ct:text)
			vUser:ct:text := left(vUser:ct:text, len(vUser:ct:text)-1) + s
			//?? "'"+vUser:ct:text+"'", l, chr(10)
		else */
			vUser:ct:text += s // + chr(10)
		//endif
	endif
return
