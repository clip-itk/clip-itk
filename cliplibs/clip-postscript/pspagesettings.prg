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

/* Class for page settings */

static page_formats := { ;
	{ PAGE_A4, 595.276,  841.89 } ;
}


function PSPageSettings()
	local obj := map()
	
	obj:className := "PSPageSettings"
	obj:format  := PAGE_A4
	obj:layout  := PAGE_PORTRAIT
	obj:units   := PRINT_MM
	obj:margins := { 20, 20, 20, 20 }
	obj:header_margin := 10
	obj:footer_margin := 15
	obj:spacing := 0
	
	// Page size in PT
	obj:width   := 595.276
	obj:height  := 841.89
	
	_recover_PSPAGESETTINGS(obj)
return obj


function _recover_PSPAGESETTINGS( obj )
	obj:set := @ps_set()
return obj


/* Set page setting */
static function ps_set( self, name, value )
	local v, i, tv, a
	
	//?? "set:", name, value, chr(10)
	switch lower(name)
		case 'format'
			switch upper(value)
				case "A4"
					v := PAGE_A4
				otherwise
					v := PAGE_A4
			endswitch
			if self:format != v
				i := ascan( page_formats, {|e| e[1] == v } )
				if i > 0
					if self:layout == PAGE_LANDSCAPE
						self:width  := page_formats[i][3]
						self:height := page_formats[i][2]
					else
						self:width  := page_formats[i][2]
						self:height := page_formats[i][3]
					endif
				endif
			endif
			self:format := v
				
		case "orientation"
			v := iif( lower(value) == "landscape", PAGE_LANDSCAPE, PAGE_PORTRAIT)
			if self:layout != v
				tv          := self:width
				self:width  := self:height
				self:height := tv
			endif
			self:layout := v
		
		case "units"
			switch lower(value)
				case "pt"
					self:units := PRINT_PT
				case "cm"
					self:units := PRINT_CM
				case "mm"
					self:units := PRINT_MM
				case "inch"
					self:units := PRINT_INCH
				otherwise
			endswitch

		case "margins"
			if at(",", value) > 0
				a := split(value, ",")
				if len(a) != 4
					return .F.
				else
					for i:=1 to 4
						a[i] := val(a[i])
					next
				endif
				self:margins := a
			else
				value := val(value)
				self:margins := { value, value, value, value }
			endif
		
		case "spacing"
			self:spacing := val(value)
		
		case "header-margin"
			self:header_margin := val(value)
		
		case "footer-margin"
			self:footer_margin := val(value)
		
		otherwise
			// Ignored
	endswitch
return .T.
