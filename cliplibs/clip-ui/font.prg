/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2004 by E/AS Software Foundation 	           	   */
/*   Author: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 05 Dec 2004						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

/* UIFont class */
function UIFont( family, style, size, encoding )
	local obj := map()
	obj:className := "UIFont"
	
	obj:font := ""
	obj:family := family
	obj:style := style
	obj:size := size
	obj:encoding := encoding
	
	_recover_UIFONT(obj)
	
	if left(family,1) == '-'
		obj:font := obj:parseFont( family )
	else
		obj:font := obj:parseFont()	
	endif
return obj

function _recover_UIFONT( obj )
	obj:setProperty	:= @ui_setProperty()
	obj:parseFont	:= @ui_parseFont()
return obj

/* Set property for font */
static function ui_setProperty(self, property, value)
	switch upper(property)
		case 'FAMILY'
			self:family := value
		case 'STYLE'
			self:style := value
		case 'SIZE'
			self:size := value
		case 'ENCODING'
			self:encoding := value
	endswitch
	self:font := self:parseFont()
return 

/* Parse font */
static function ui_parseFont(self, string)
	local a, ff, fn, fs, fe
	
	if .not. empty(string)
		// Font string like -monotype-arial-medium-r-normal--0-0-0-0-p-0-koi8-r
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
		ff := iif( empty(self:family), '*', self:family )
		fn := iif( empty(self:style), 'normal', lower(self:style) )
		
		fs := iif( empty(self:size), '', alltrim(str(val(self:size)*10)) )
		lang := split(getenv("LANG"),'\.')
		if len(lang) > 1
			fe := lower(lang[2])
		else
			fe := 'iso8859-1'
		endif
		string := '-*-'+ff+'-'+iif(left(fn,4)=='bold','bold','medium')
		string += '-'+iif(right(fn,6)=='italic','i','r')+'-'+'normal'+'-'
		string += '-*-'+fs+'-*-*-*-*-'+fe
		return string
	endif
return
