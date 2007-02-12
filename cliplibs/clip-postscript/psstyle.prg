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

/* Class for style */

function PSStyle( s, printer )
	local obj := map(), l, i, pair, iName, iObj, iMap, j
	
	obj:className := "PSStyle"
	obj:name := ""
	obj:printer := printer
	
	obj:prop := map()
	obj:prop["FONT-FAMILY"] 	:= "Helvetica"
	obj:prop["FONT-SIZE"] 		:= 10
	obj:prop["FONT-WEIGHT"]		:= "normal"
	obj:prop["FONT-STYLE"]	    := "normal"
	obj:prop["X"] 				:= 0
	obj:prop["Y"] 				:= 0
	obj:prop["WIDTH"]			:= 0
	obj:prop["HEIGHT"]			:= 0
	obj:prop["COLOR"]			:= "#000000"
	obj:prop["BACKGROUND-COLOR"] := ""
	obj:prop["TEXT-ALIGN"]		:= "left"
	obj:prop["BORDER"]			:= 0
	obj:prop["BORDER-TOP"]		:= 0
	obj:prop["BORDER-LEFT"]		:= 0
	obj:prop["BORDER-BOTTOM"]	:= 0
	obj:prop["BORDER-RIGHT"]	:= 0
	obj:prop["PADDING"]			:= 0
	obj:prop["PADDING-TOP"]		:= 0
	obj:prop["PADDING-LEFT"]	:= 0
	obj:prop["PADDING-BOTTOM"]	:= 0
	obj:prop["PADDING-RIGHT"]	:= 0
	
	_recover_PSSTYLE(obj)
	
	
	// Fill style from tags or string
	if valtype(s) == "O"
		
		// From tag
		obj:name := s:attribute("name", "")
		
		// Copy properties from another style
		iName := s:attribute("inherits", "")
		iObj := printer:getStyle(iName)
		if .not. empty(iName) .and. valtype(iObj) == "O"
			iMap := mapkeys(iObj:prop)
			for j in iMap
				obj:prop[j] := iObj:prop[j]
			next
		endif
		
		// Fill property from child tags
		l := s:getChilds()
		for i in l
			obj:set(i:getName(), i:getText())
		next
	
	elseif valtype(s) == "C"
		//?? "Style from string - ", s, chr(10)
		// From string
		l := split(s, ";")
		for i in l
			pair := split(alltrim(i), "\:")
			//?? "Style from string:", pair, len(pair), chr(10) 
			if len(pair) == 2
				obj:set(alltrim(pair[1]), alltrim(pair[2]))			
			endif
		next
	
	endif
	
return obj


function _recover_PSSTYLE( obj )
	obj:getName 	:= @ps_getName()
	obj:set 		:= @ps_set()
	obj:get 		:= @ps_get()
	obj:getFontName := @ps_getFontName()
return obj


/* Get style name */
static function ps_getName( self )
return self:name


/* Set style propery */
static function ps_set( self, name, value )
	
	switch upper(name)
		
		case "X", "Y", "WIDTH", "HEIGHT", ;
			 "PADDING-TOP", "PADDING-LEFT", "PADDING-BOTTOM", "PADDING-RIGHT"
			if valtype(value) == "C"
			 	value := val(value)
			endif
			if valtype(value) == "N"
				value := self:printer:val2pt(value)
				self:prop[upper(name)] := value
			endif
		
		case "BORDER-TOP", "BORDER-LEFT", "BORDER-BOTTOM", "BORDER-RIGHT", ;
			 "FONT-SIZE"
			if valtype(value) == "C"
			 	value := val(value)
			endif
			if valtype(value) == "N"
				self:prop[upper(name)] := value
			endif
		
		case "BORDER", "PADDING"
			if valtype(value) == "C"
			 	value := val(value)
			endif
			if valtype(value) == "N"
				if upper(name) == "PADDING"
					value := self:printer:val2pt(value)
				endif
				self:prop[upper(name)] := value
				self:prop[upper(name)+"-TOP"] := value
				self:prop[upper(name)+"-LEFT"] := value
				self:prop[upper(name)+"-BOTTOM"] := value
				self:prop[upper(name)+"-RIGHT"] := value
			endif
		
		case "TEXT-ALIGN", "FONT-WEIGHT", "FONT-STYLE"
			if valtype(value) == "C" .and. len(value) > 0
				self:prop[upper(name)] := lower(value)
			endif
		
		case "FONT-FAMILY"
			if valtype(value) == "C" .and. len(value) > 0
				self:prop[upper(name)] := value
			endif
		
		case "COLOR", "BACKGROUND-COLOR"
			if valtype(value) == "C" .and. left(value,1) == "#" .and. len(value) == 7
				self:prop[upper(name)] := value
			endif
		
		otherwise
			// Unknown propery
			
	endswitch
	
return


/* Get style propery */
static function ps_get( self, name )
	local v
	
	if upper(name) $ self:prop
		return self:prop[upper(name)]
	else
		?? "Unknown style propery '" + name + "'&\n"
	endif

return NIL


/* Get font name */
static function ps_getFontName( self, full )
	local f, ext:=""
	
	f := self:prop["FONT-FAMILY"]
	ext += iif(at("bold", self:prop["FONT-WEIGHT"])>0, "Bold", "")
	ext += iif(at("italic", self:prop["FONT-STYLE"])>0, "Italic", "")
	f := self:prop["FONT-FAMILY"] + iif( empty(ext), "", "-" + ext )
	
	if valtype(full) == "L" .and. full
		f += " " + ltrim(str( self:prop["FONT-SIZE"] ))
	endif

return f
