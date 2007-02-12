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

/* TODO: Class for content block */

function PSBlock( printer, t, parent )
	local obj := map(), n, nA, b, st, ct, xm, ym, v
	local ml:=0, mr:=0, mt:=0, mb:=0, border, dh:=0
	local ax, ay, aw, ah, p, oErr
	
	if valtype(printer) != "O" .or. valtype(t) != "O"
		return NIL
	endif
	//?? "block:", t:getName(), chr(10)
	obj:className := "PSBlock"
	obj:name      := t:getName()
	obj:parent    := parent
	obj:printer   := printer
	obj:type      := O_TEXT
	obj:text      := t:getText()
	obj:style     := NIL
	obj:header    := NIL
	obj:footer    := NIL
	obj:p_header  := NIL
	obj:p_footer  := NIL
	obj:x         := 0
	obj:y         := 0
	obj:tx        := 0
	obj:ty        := 0
	obj:tx1       := 0
	obj:ty1       := 0
	obj:ts        := 0
	obj:w         := 0
	obj:h         := 0
	obj:attrs     := t:getAttributes()
	obj:childs    := array(0)
	
	_recover_PSBLOCK(obj)
	
	oErr := errorBlock({|e| break(e) })
	begin sequence
	
	// Detect type
	switch lower(t:getName())
		case "text"
			obj:type := O_TEXT
		case "table"
			obj:type := O_TABLE
		case "row"
			obj:type := O_ROW
		case "cell"
			obj:type := O_CELL
		case "header"
			obj:type := O_HEADER
		case "footer"
			obj:type := O_FOOTER
		case "pageheader"
			obj:type := O_PAGE_HEADER
		case "pagefooter"
			obj:type := O_PAGE_FOOTER
		case "section"
			obj:type := O_SECTION
		otherwise
			obj:type := O_VARIABLE
	endswitch

	// Get style
	st := t:attribute("style","")
	if .not. empty(st)
		obj:style := printer:getStyle( st )
		//?? "Got style:", valtype( obj:style), chr(10)
	endif
	
	// Inherits parent element style
	if valtype(obj:style) != "O" .and. empty(st)
		// Try to get parent object style
		ct := parent
		do while valtype(ct) == "O"
			if valtype(ct:style) == "O"
				obj:style := ct:style
				exit
			endif
			ct := ct:parent 
		enddo
	endif
	
	// Create style from string
	if valtype(obj:style) != "O"
		// Unknown style name, try to apply defined properies
		obj:style := PSStyle( st, printer )
		printer:setStyle( obj:style )
	endif
	
	//?? "Style:", st, obj:style:getName(), chr(10)
	
	// Compute sizes
	obj:x := obj:style:get("x")
	obj:y := obj:style:get("y")
	obj:w := obj:style:get("width")
	obj:h := obj:style:get("height")
	dh := obj:style:get("font-size")
	ml := obj:style:get("padding-left")
	mr := obj:style:get("padding-right")
	mt := obj:style:get("padding-top")
	mb := obj:style:get("padding-bottom")
	obj:ts := obj:style:get("font-size")
	
	// Fix margins for cells
	if obj:type == O_CELL
		ml := iif( ml == 0, 2 * PT_IN_MM, ml )
		mr := iif( mr == 0, 2 * PT_IN_MM, mr )
		mt := iif( mt == 0, 2 * PT_IN_MM, mt )
		mb := iif( mb == 0, 2 * PT_IN_MM, mb )
	endif
	
	dh := iif( dh==0, 7.5, dh ) // For default font
	if obj:type == O_TEXT .or. obj:type == O_CELL
		obj:h := iif( obj:h==0, dh + mt + mb, obj:h )
	endif
	obj:tx := ml
	obj:ty := mt
	obj:tx1 := mr
	obj:ty1 := mb
			
	// Pass sizes to parent
	p := iif( valtype(obj:parent)=="O", obj:parent, printer:currentPage )
	
	if obj:type == O_TABLE
		obj:h := 0
	endif
	
	if valtype(p) == "O"
		obj:y := iif( obj:y==0, p:y, obj:x )
		switch p:type
			case O_ROW
				obj:y := p:y
				p:h := iif( p:h < obj:h, obj:h, p:h )
				obj:x := p:w
				p:w := p:w + obj:w
			case O_TABLE
				if obj:type == O_ROW
					obj:y := p:h
					//?? "row:", obj:y, chr(10)
					p:h += obj:h
				endif
			case O_PAGE_HEADER, O_PAGE_FOOTER
				p:h += obj:h
			case O_TEXT, O_SECTION
				// Nothing do
			otherwise
				if obj:type != O_SECTION
					//?? "obj:", obj:type, obj:h, chr(10)
					p:h += obj:h + printer:val2pt(printer:page:spacing)
				endif
		endswitch
	endif
	
	// Process childs
	nA := t:getChilds()
	for n in nA
		b := PSBlock( printer, n, obj )
		if valtype(b) == "O"
			switch b:type
				case O_HEADER
					obj:header := b
					aadd( obj:childs, b )
				case O_FOOTER
					obj:footer := b
					aadd( obj:childs, b )
				case O_PAGE_HEADER
					obj:p_header := b
				case O_PAGE_FOOTER
					obj:p_footer := b
				otherwise
					aadd( obj:childs, b )
			endswitch
		endif 
	next
	if obj:w == 0
		obj:w := printer:page:width - obj:x - ;
			printer:val2pt(printer:page:margins[2]) - ;
			printer:val2pt(printer:page:margins[4])
	endif
		
		
	// Set document-wide page footer and page header
	if valtype(obj:parent) == "O" .and. obj:parent:type != O_TABLE
		if obj:type == O_PAGE_HEADER
			printer:header := obj
		elseif obj:type == O_PAGE_FOOTER
			printer:footer := obj
		endif
	endif
	
	recover using oErr
		?? "PSBlock() error:", errorMessage(oErr), chr(10)
		obj := NIL
		cancel
	end sequence
		
return obj


function _recover_PSBLOCK( obj )
	obj:width		:= @ps_width()
	obj:height		:= @ps_height()
	obj:print   	:= @ps_print()
	obj:setColor   	:= @ps_setColor()
	obj:setFont		:= @ps_setFont()
	obj:printAt		:= @ps_printAt()
	obj:moveTo		:= @ps_moveTo()
	obj:printText	:= @ps_printText()
	obj:printBorder	:= @ps_printBorder()
return obj


/* Get block width */
static function ps_width( self )
return self:w


/* Get block height */
static function ps_height( self )
return self:h


/* Put postscript code */
static function ps_print( self )
	local psize, p, s:="", childs, i
	local font, color, bt, bb, bl, br, align, oErr
	local arr:=array(2), continues:=.F., text, ph
	local hasH:=.F., hasF:=.F., ct
	
	oErr := errorBlock({|e| break(e) })
	begin sequence
		//?? "print block&\n"
		psize := self:printer:page
		p := self:printer:currentPage
		if valtype( self:style ) != "O"
			self:style := PSStyle( "__def", self:printer )
		endif
		if empty(p)
			?? "ERROR: No page&\n"
			return NIL
		endif
		
		// Simple text and variables
		if valtype(self:parent) == "O" .and. ;
				( self:parent:type == O_TEXT .or. self:parent:type == O_CELL ) .and. ;
				self:type == O_TEXT
			text := self:text
			text := STRTRAN(text, '(', '\(')
			text := STRTRAN(text, ')', '\)')
			//?? "add text: *"+text+"*&\n"
			p:add( PSCode( text ) )
			return NIL
		endif
		if self:type == O_VARIABLE
			//?? "add variable:", self:name, "&\n"
			p:add( PSVariable( self:name, self:attrs ) )
			return NIL
		endif
		
		//?? "headers, footers...&\n"
		// Print header
		if .not. empty(self:header)
			self:header:print()
		endif
		
		// Check if block is in page header or page footer
		ct := self:parent
		do while valtype(ct) == "O"
			if ct:type == O_PAGE_HEADER
				hasH := .T.
			elseif ct:type == O_PAGE_FOOTER
				hasF := .T.
			endif
			ct := ct:parent
		enddo
		
		// Set y-coordinate for header and footer
		if self:type == O_PAGE_HEADER
			
			self:y := self:printer:val2pt(psize:header_margin)
			self:printer:hy := self:y
		
		elseif self:type == O_PAGE_FOOTER
			
			self:y := psize:height - self:printer:val2pt(psize:footer_margin)
			self:printer:fy := self:y
		
		elseif hasH
			
			if self:type == O_TEXT .or. self:type == O_ROW
				self:y := self:printer:hy
				self:printer:hy += self:h + ;
					iif(self:type == O_TEXT, self:printer:val2pt(psize:spacing), 0)
			endif
		
		elseif hasF
			
			if self:type == O_TEXT .or. self:type == O_ROW
				self:y := self:printer:fy
				self:printer:fy += self:h + ;
					iif(self:type == O_TEXT, self:printer:val2pt(psize:spacing), 0)
			endif
		
		else
			if self:type == O_ROW
				//?? "Y (row):", self:y, chr(10)
			endif
			
			// Fix y-coordinate for continues pages
			if .not. ( hasH .or. hasF )
				self:y := self:y - self:printer:ay
			endif
						
			ph := psize:height - self:printer:val2pt(psize:margins[1]) - ;
				self:printer:val2pt(psize:margins[3])
			ph -= iif(valtype(self:parent) == "O" .and. ;
				valtype(self:parent:p_footer) == "O", self:parent:p_footer:h, 0)
			
			if self:type == O_CELL .and. valtype(self:parent) == "O"
				self:y := self:parent:y
			elseif self:y == 0
				//?? "Y:", self:name, self:printer:y, chr(10)
				self:y := self:printer:y
			elseif self:type == O_ROW .and. valtype(self:parent) == "O"
				//?? "Y (row2):", self:y, self:parent:y, chr(10)
				self:y := self:y + self:parent:y
			endif
		
			//?? "pos:", self:y + self:h, ph, chr(10)
			if self:y + self:h > ph .and. self:type != O_TABLE .and. self:type != O_SECTION
				
				// Wrap to new page
				//?? "NEW PAGE&\n"
				self:printer:ay += self:printer:y
				if valtype(self:parent) == "O" .and. valtype(self:parent:p_footer) == "O"
					self:parent:p_footer:print()
				endif
				self:printer:add()
				p := self:printer:currentPage
				
				// Print common page header and footer
				if valtype(self:printer:header) == "O"
					self:printer:header:print()
				elseif valtype(self:printer:footer) == "O"
					self:printer:footer:print()
				endif
				
				// Print section header
				self:printer:y := 0
				if valtype(self:parent) == "O" .and. valtype(self:parent:p_header) == "O"
					self:parent:p_header:print()
					self:printer:ay -= self:parent:p_header:h
					self:printer:y  += self:parent:p_header:h
					//?? "section header:", self:parent:p_header:h, self:printer:y, self:printer:ay, chr(10)
				endif
				//?? "Y after header:", self:printer:y, chr(10)
				self:y := self:printer:y
			
			elseif self:type == O_TEXT .or. self:type == O_ROW
				// Shift bottom
				self:printer:y := self:y + self:h + ;
					iif(self:type == O_TEXT, self:printer:val2pt(psize:spacing), 0)
			endif
		
		endif
				
		// Print page header
		if .not. empty(self:p_header) .and. self:type != O_TABLE
			self:p_header:print()
		endif
				
		// Print page footer
		if .not. empty(self:p_footer) .and. self:type != O_TABLE
			self:p_footer:print()
		endif
				
		// Set font && color
		font := self:style:getFontName( .T. )
		//?? "font", font != p:font, font, p:font, "&\n"
		if empty(p:font) .or. font != p:font
			s += self:setFont( self:style:getFontName(), self:style:get("font-size") )
			p:font := font
		endif
		//?? "color&\n"
		color := self:style:get("color")
		if empty(p:color) .or. color != p:color
			s += self:setColor( color )
			p:color := color
		endif
		
		switch self:style:get("text-align")
			case "left"
				align := C_ALIGN_LEFT
			case "right"
				align := C_ALIGN_RIGHT
			case "center"
				align := C_ALIGN_CENTER
			case "justify"
				align := C_ALIGN_JUSTIFY
			otherwise
				align := C_ALIGN_LEFT
		endswitch
		
		//?? "print text&\n"
		continues := (self:type==O_TEXT .or. self:type==O_CELL) .and. len(self:childs)>0
		//?? "block:", self:name, ltrim(str(self:printer:y)), ltrim(str(self:x)), ltrim(str(self:y)), ltrim(str(self:w)), ltrim(str(self:h)), chr(10)
		//?? "block:", self:name, ltrim(str(self:y)), chr(10)

		// Put boders
		s += self:printBorder() // border
		arr := self:printAt( self:x + self:tx, self:y + self:ty, self:text, align, ;
				self:x + self:w - self:tx1, self:y + self:h - self:ty1, self:h, continues ) // text
		
		if continues
			s += arr[1] 
		else
			s += arr
		endif
		
		if continues
			//?? "CONTUNUES:", s, arr[2], chr(10)
		endif
		
		// TODO: split to several pages
		s := "%% <" + self:name + iif(continues,"-continues","") + ">&\n" + s
		p:add( PSCode( s ) )
		
		// Print childs
		childs := self:childs
		for i in childs
			i:print()
		next
		if continues
			p:add( PSCode( arr[2] ) )
		endif		
		
		// Print footer
		if .not. empty(self:footer)
			self:footer:print()
		endif
		
	recover using oErr
		?? "PSBlock:print() error:", errorMessage(oErr), chr(10)
		cancel
	end sequence

return NIL

/*===========================================================================*/
// Drawing functions
/*===========================================================================*/

/* Set drawing color in format '#RRGGBB' */
static function ps_setColor( self, color )
	local r, g, b
	r := alltrim(str(cton(substr(color,2,2),16)/255))
	g := alltrim(str(cton(substr(color,4,2),16)/255))
	b := alltrim(str(cton(substr(color,6,2),16)/255))
return r + " " + g + " " + b + " setrgbcolor&\n"


/* Set font for printed text */
static function ps_setFont( self, fontName, size )
	local s
	s := "/" + fontName + " findfont&\n"
	s += alltrim(str(size)) + " scalefont setfont&\n"
return s


/* Print text at defined position */
static function ps_printAt( self, x, y, text, align, x2, y2, lh, continues )
	local xr, yr, x2r, y2r, lhr, s, arr:=array(2), rA, ct, footer:=.F.
    local p := self:printer
    local ps := p:page
    local cH

	cH := self:style:get("font-size") * 0.125
	xr := ltrim(str( x + p:val2pt(ps:margins[4]) ))
	yr := ltrim(str( ps:height - y - self:ts - p:val2pt(ps:margins[1]) + cH ))
	x2r := ltrim(str( iif(x2==NIL, ps:width - p:val2pt(ps:margins[2]), ;
		p:val2pt(ps:margins[4]) + x2) ))
	y2r := ltrim(str( iif(y2==NIL, ps:height - p:val2pt(ps:margins[1]), ;
		ps:height - p:val2pt(ps:margins[1]) - y2 + cH ) ))
	lhr := ltrim(str( lh ))
	
	ct := self:parent
	do while valtype(ct) == "O"
		 if ct:type == O_PAGE_FOOTER
		 	footer := .T.
		 	exit
		 endif
		 ct := ct:parent
	enddo
	
	if footer
		yr := ltrim(str( ps:height - y - self:ts + cH ))
		y2r := ltrim(str( iif(y2==NIL, p:val2pt(ps:footer_margin), ps:height - y2 + cH) ))
		//?? "FOOTER POS (text):", self:y, yr, y2r, lhr, chr(10)
	endif
	
	s := self:moveTo( x, y + self:ts - cH )
	//?? "y (text):", y, self:ts, cH, chr(10)
	s += "/lm " + xr + " def /tm " + yr + " def /rm " + x2r + " def /bm " + y2r + " def /bg " + lhr + " def&\n"
	rA := self:printText( text, align, continues )
	if valtype(continues) == "L" .and. continues
		arr[1] := s + rA[1]
		arr[2] := rA[2]
	else
		arr := s + rA
	endif
return arr


/* Set drawing position */
static function ps_moveTo( self, x, y )
    local r_x, r_y, ct, footer:=.F.
    local p := self:printer
    local ps := p:page

	r_x := x + p:val2pt(ps:margins[4])
	r_y := ps:height - y - p:val2pt(ps:margins[1])
	
	ct := self:parent
	do while valtype(ct) == "O"
		 if ct:type == O_PAGE_FOOTER
		 	footer := .T.
		 	exit
		 endif
		 ct := ct:parent
	enddo
	
	if footer
		r_y := ps:height - y
		//?? "FOOTER POS (pos):", y, r_y, chr(10)
	endif
	
return alltrim(str(round(r_x))) + " " + alltrim(str(round(r_y))) + " moveto&\n"


/* Print text to current position */
static function ps_printText( self, text, align, continues )
	local a:="P", arr:=array(2)

	// escape any Postscript delimiters in string
	text := STRTRAN(text, '(', '\(')
	text := STRTRAN(text, ')', '\)')
	/* align - text alignment
		C_ALIGN_LEFT 	left
		C_ALIGN_CENTER 	center
		C_ALIGN_RIGHT 	right
		C_ALIGN_JUSTIFY 	TODO: really justify
	*/
	switch align
		case C_ALIGN_LEFT
			a := "l"
			text += " "
		case C_ALIGN_CENTER
			a := "c"
 		case C_ALIGN_RIGHT
			a := "r"
		case C_ALIGN_JUSTIFY // TODO: really justify
			a := "P"
	endswitch
	if valtype(continues) == "L" .and. continues
		arr[1] := "(" + text
		arr[2] := ") " + a + chr(10)
	else
		arr := "(" + text + ") " + a + chr(10)
	endif
return arr


/* Print box with boder */
static function ps_printBorder( self )
    local x, y, x1, y1, w, h, xf, yf, ct, footer:=.F.
    local bt, bb, bl, br, bc, s:=""
    local p := self:printer
    local ps := p:page

	// Get borders
	bl := self:style:get("border-left")
	br := self:style:get("border-right")
	bt := self:style:get("border-top")
	bb := self:style:get("border-bottom")
	bc := self:style:get("background-color")
	
	// Calculate coordinates
	x := alltrim(str( self:x + p:val2pt(ps:margins[4])))// + bl/2 ))
	y := alltrim(str( ps:height - self:y - p:val2pt(ps:margins[1])))// - bt/2 ))
	x1 := alltrim(str( self:x + p:val2pt(ps:margins[4]) + self:w))// - br/2 ))
	y1 := alltrim(str( ps:height - self:y - p:val2pt(ps:margins[1]) - self:h))// + bb/2 ))
	w := alltrim(str( self:w ))
	h := alltrim(str( self:h ))
	
	ct := self:parent
	do while valtype(ct) == "O"
		 if ct:type == O_PAGE_FOOTER
		 	footer := .T.
		 	exit
		 endif
		 ct := ct:parent
	enddo
	
	if footer
		y := alltrim(str( ps:height - self:y ))
		y1 := alltrim(str( ps:height - self:y - self:h ))
		//?? "FOOTER POS:", self:y, y, y1, h, chr(10)
	endif
	
	// Fill path
	if .not. empty(bc)
		xf := alltrim(str( self:x + p:val2pt(ps:margins[4]) ))
		yf := alltrim(str( ps:height - self:y - p:val2pt(ps:margins[1]) ))
		s += "gsave&\n"
		s += xf + " " + yf + " moveto " + w + " 0 rlineto&\n"
		s += "0 -" + h + " rlineto -" + w + " 0 rlineto&\n"
		s += self:setColor( bc )
		s += " 0 setlinewidth&\n"
		s += "closepath&\n"
		s += "fill grestore&\n"
	endif
	
	// Draw borders
	//?? "borders:", self:style:getName(), bt, bb, bl, br, chr(10)
	//s += "gsave&\n"
	if bt > 0
		s += x + " " + y + " moveto&\n"
		s += alltrim(str( bt )) + " setlinewidth&\n"
		s += x1 + " " + y + " lineto closepath stroke&\n"
	endif
	if br > 0
		s += x1 + " " + y + " moveto&\n"
		s += alltrim(str( br )) + " setlinewidth&\n"
		s += x1 + " " + y1 + " lineto closepath  stroke&\n"
	endif
	if bb > 0
		s += x1 + " " + y1 + " moveto&\n"
		s += alltrim(str( bb )) + " setlinewidth&\n"
		s += x + " " + y1 + " lineto closepath stroke&\n"
	endif
	if bl > 0
		s += x + " " + y1 + " moveto&\n"
		s += alltrim(str( bl )) + " setlinewidth&\n"
		s += x + " " + y + " lineto closepath stroke&\n"
	endif
	//s += "grestore&\n"
	// End border

return s

