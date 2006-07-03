/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library									   */
/*						          								       	   */
/*   Copyright (C) 2004-2005 by E/AS Software Foundation 		       	   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>						   */
/*   																	   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

static driver := getDriver()

/* UIFont class */
function UIFont( family, style, size, encoding )
	local obj := map()
	obj:className := "UIFont"
	
	obj:font 	 := ""
	obj:family 	 := family
	obj:style 	 := style
	obj:size 	 := size
	obj:encoding := encoding
	
	_recover_UIFONT(obj)
	
	if driver:driver == "gtk"
		if left(family,1) == '-'
			obj:font := obj:parseFont( family )
		else
			obj:font := obj:parseFont()	
		endif
	else
		if style == NIL .and. size == NIL 
			obj:font := obj:parseFont2( family )
		else
			obj:font := obj:parseFont2()	
		endif
	endif
return obj

function _recover_UIFONT( obj )
	obj:setProperty	:= @ui_setProperty()
	obj:parseFont	:= @ui_parseFont()
	obj:parseFont2	:= @ui_parseFont2()
return obj

/* Set property for font */
static function ui_setProperty(self, property, value)
	switch upper(property)
		case 'FAMILY'
			self:family := value
		case 'STYLE'
			self:style := value
		case 'SIZE'
			//?? "Size before:", valtype(self:size), self:size,chr(10)
			if empty(self:size)
				self:size := 10
			endif
			if valtype( value ) == 'C'
				if left( value, 1 ) == '+'
					value := self:size + val(substr(value,2))*2
				elseif left( value, 1 ) == '-'
					value := self:size - val(substr(value,2))*2
				else
					value := val( value )
				endif
			endif
			self:size := value
		case 'ENCODING'
			self:encoding := value
	endswitch
	if driver:driver == "gtk"
		self:font := self:parseFont()
	else
		self:font := self:parseFont2()
	endif
	//?? "NEW FONT:", self:font,chr(10)
return 

/* Parse font (XWindow font name) */
static function ui_parseFont(self, string)
	local a, ff, fn, fs, fe, lang
	
	if .not. empty(string)
		// Font string like -monotype-arial-medium-r-normal--12-0-0-0-p-0-koi8-r
		a = split(string,'-')
		self:family := a[3]
		if a[4] == 'bold'
			self:style := 'bold'
			if a[5] == 'i'
				self:style := 'bolditalic'
			endif
		elseif a[5] == 'i'
			self:style := 'italic'
		else
			self:style := 'normal'
		endif
		self:size := val(a[9])/10
		self:encoding := a[14]+'-'+a[15]		
		return string
	else
		// Composite font
		ff := iif( empty(self:family), 'helvetica', self:family )
		fn := iif( empty(self:style), 'normal', lower(self:style) )
		
		fs := iif( empty(self:size), '', alltrim(str(self:size)) )
		lang := split(getenv("LANG"),'\.')
		if len(lang) > 1
			fe := lower(lang[2])
		else
			fe := 'iso8859-1'
		endif
		string := '-*-'+ff+'-'+iif(left(fn,4)=='bold','bold','medium')
		string += '-'+iif(right(fn,6)=='italic','i','r')+'-'+'normal'+'-'
		string += '-'+fs+'-*-*-*-*-*-'+fe
		return string
	endif
return

/* Parse font (GTK2 font name) */
static function ui_parseFont2(self, string)
	local a, l, i, ff, fn, fs, fe
	
	if .not. empty(string)
		// Font string like "Sans Medium 10"
		a = split(string,' ')
		l := len(a)
		if l == 2	// Only family and size
			self:style := "Medium"
		else
			self:style := a[l-1]
			adel(a, l-1)
			l := l-1
		endif
		self:size := val(a[l])
		l := l-1
		self:family := ""
		for i:=1 to l
			self:family += " "+a[i] 
		next
		self:family := alltrim(self:family)
		return string
	else
		// Composite font
		ff := iif( empty(self:family), 'Sans', self:family )
		fn := iif( empty(self:style) .or. upper(self:style)=="NORMAL", 'Medium', lower(self:style) )
		fs := iif( empty(self:size), '10', alltrim(str(self:size)) )
		string := ff+" "+fn+" "+fs
		return string
	endif
return
