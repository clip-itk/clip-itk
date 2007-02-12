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

/* Class for Postscript page content */

function PSPage( num, orientation, printer )
	local obj := map()
	
	obj:className := "PSPage"
	obj:type      := O_PAGE
	obj:num	      := num
	obj:printer   := printer
	obj:x         := 0
	obj:y         := 0
	obj:w         := 0
	obj:h         := 0
	obj:blocks    := array(0)
	obj:font      := ""
	obj:color     := ""
	obj:orientation := iif(valtype(orientation)=="U", PAGE_PORTRAIT, orientation)

	_recover_PSPAGE(obj)
return obj


function _recover_PSPAGE( obj )
	obj:add			:= @ps_add()
	obj:getNumber 	:= @ps_getNumber()
	obj:print		:= @ps_print()
	obj:width		:= @ps_getWidth()
	obj:height		:= @ps_getHeight()
return obj


/* Add block to page */
static function ps_add( self, block )
	if valtype(block) == "O"
		aadd( self:blocks, block )
	endif
return NIL


/* Get page number */
static function ps_getNumber( self )
return self:num


/* Print page */
static function ps_print( self, printer )
	local s:="", i, inum, iinum, tpw, v
	local x, y, x1, y1, ss:="", pp
	
	//?? "print page...&\n"
	if valtype(printer) != "O"
		return ""
	endif
		
	inum  := ltrim(str(self:getNumber()))
	iinum := ltrim(str(printer:getPageCount()))
	tpw   := ltrim(str(printer:page:width))
	s += "%%Page: " + inum + " " + iinum + "&\n"
	s += "gsave&\n"

	// Rotate lanscape orientation
	if self:orientation == PAGE_LANDSCAPE
		s += tpw + " 0 translate&\n"
		s += "90 rotate&\n"
	endif
	
	// Text text box border
	/*pp := printer:page
	x  := ltrim(str(printer:val2pt(pp:margins[4])))
	x1 := ltrim(str(pp:width - printer:val2pt(pp:margins[4])))
	y  := ltrim(str(pp:height - printer:val2pt(pp:margins[3])))
	y1 := ltrim(str(printer:val2pt(pp:margins[3])))
	ss += x+" "+y+" moveto&\n"
	ss += "0.75 setlinewidth&\n"
	ss += x1+" "+y+" lineto closepath stroke&\n"
	ss += x1+" "+y+" moveto&\n"
	ss += "0.75 setlinewidth&\n"
	ss += x1+" "+y1+" lineto closepath  stroke&\n"
	ss += x1+" "+y1+" moveto&\n"
	ss += "0.75 setlinewidth&\n"
	ss += x+" "+y1+" lineto closepath stroke&\n"
	ss += x+" "+y1+" moveto&\n"
	ss += "0.75 setlinewidth&\n"
	ss += x+" "+y+" lineto closepath stroke&\n"
	s += ss
	*/
	
	// Write out page content
	for i in self:blocks
		//?? "."
		if valtype(i) == "O" .and. i:className == "PSCode"
			// Append raw content
			s += i:code
		elseif valtype(i) == "O" .and. i:className == "PSVariable"
			// Evaluate PSVariable
			v := i:get( printer, self )
			//?? "Evaluate variable:", i:name, v, valtype(v), chr(10)
			if valtype(v) == "N"
				v := ltrim(str(v))
			elseif valtype(v) == "D"
				v := dtoc(v)
			elseif valtype(v) != "C"
				v := ""
			endif
			//?? "Put variable:", i:name, v, chr(10)
			s += v
		endif
	next
	
	// write out page footer
	s += "grestore stroke showpage&\n"
	s += "%%PageTrailer&\n&\n"
	//? ""
	//?? "finish print page...&\n"

return s


/* Get available width */
static function ps_getWidth( self )
	local p, s, h
	p := self:printer
	s := p:page
	h := p:width - p:val2pt(s:margins[2]) - p:val2pt(s:margins[4]) - self:x
return h


/* Get available height */
static function ps_getHeight( self )
	local p, s, w
	p := self:printer
	s := p:page
	w := p:height - p:val2pt(s:margins[1]) - p:val2pt(s:margins[3]) - self:y 
return w  
