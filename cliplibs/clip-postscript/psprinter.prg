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
#include <fileio.ch>
#include "clip-postscript.ch"
#define USER_AGENT	"clip-postscript"
#define VERSION		"0.1.0"

/** PSPrinter - Class for generate PostScript file from XPL form */
function PSPrinter( settings )
	local obj := map()
	
	obj:className := "PSPrinter"
	obj:property  := map() 
	obj:content   := ""
	obj:styles	  := map()
	obj:root      := NIL
	obj:title     := ""
	obj:author    := USER_AGENT + "-" + VERSION
	
	obj:styles    := array(0)
	obj:styleNum  := 1
	obj:pages     := array(0)
	obj:currentPage := NIL
	obj:fonts     := array(0)
	obj:y         := 0
	obj:ay        := 0
	obj:hy        := 0
	obj:fy        := 0
	obj:header    := NIL
	obj:footer    := NIL
	
	// Page settings
	if valtype(settings) == "O" .and. settings:className == "PSPageSettings"
		obj:page := settings
	else
		obj:page := PSPageSettings()
	endif
	
	_recover_PSPRINTER(obj)
return obj


function _recover_PSPRINTER( obj )
	obj:print    := @ps_print()
	obj:save     := @ps_save()
	obj:render   := @ps_render()
	obj:set      := @ps_set()
	obj:setStyle := @ps_setStyle()
	obj:getStyle := @ps_getStyle()
	obj:printHeader := @ps_printHeader()
	obj:printFooter := @ps_printFooter()
	obj:val2pt		:= @ps_val2pt()
	obj:pt2val		:= @ps_pt2val()
	// Pages management
	obj:add			:= @ps_add()
	obj:getPage		:= @ps_getPage()
	obj:getPageCount := @ps_getPageCount()
return obj


/* View generated PostScript file */
static function ps_print( self, form, viewer, file )
	local content:='', tmpdir, f, cdir, old, nPos, d, realPSFile, oErr
	local out:="", err:=""
	
	oErr := errorBlock({|e| break(e) })
	begin sequence
		if valtype(form) != 'O'
			return .F.
		endif
		
		// Define missing file name
		if empty(file)
			tmpdir := getenv("TEMP")
			if empty(tmpdir); tmpdir := getenv("TMP"); endif
			if empty(tmpdir); tmpdir := '.'; endif
			if right(tmpdir,1) != PATH_DELIM; tmpdir += PATH_DELIM; endif 
			file := tmpdir + 'output'+alltrim(str(random(10000),4,0))+'.ps'
		endif
		
		if empty(viewer)
			if os() == "CYGWIN"
				viewer := WINDOWS_PRINT_PREVIEW
			else
				viewer := UNIX_PRINT_PREVIEW
			endif
		endif
		
		// Save to file
		content := self:save( form, file )
		
		// View in external viewer
		// TODO: non blocking fork
		?? "View " + file + " in " + viewer + chr(10)
		if os() == "CYGWIN"
			old := set(_SET_TRANSLATE_PATH, .F.)
			cdir := curdir()
			cdir := iif(left(cdir,7) == "Cygwin/",substr(cdir,7),cdir)
			if (nPos := rat("/", file)) != 0
				d := substr(file, 1, nPos-1)
			else
				d := ""
			endif
			realPSFile := iif(len(d)==0, file, substr(file,len(d)+2))
			dirchange( iif(left(d,1)=="/",cygwinroot()+d,d) )
			syscmd( viewer + " " + realPSFile, "", @out, @err )
			dirchange( cygwinroot()+cdir )
			set(_SET_TRANSLATE_PATH, old)
		else
			syscmd( viewer + " " + file, "", @out, @err )
		endif
	
	recover using oErr
		?? "PSPrinter:print() error:", errorMessage(oErr), chr(10)
		return .F.
	end sequence
	
return .T.


/* Save generated PostScript file */
static function ps_save( self, form, file )
	local content:=NIL, f, old, oErr
	
	oErr := errorBlock({|e| break(e) })
	begin sequence
		if valtype(form) != 'O'
			return NIL
		endif
		
		// Generate PostScript if nessesary
		content := self:render( form )
		
		if empty(content)
			content := ''
		endif
		
		if .not. empty(file)
			// Save to file
			old := set(_SET_TRANSLATE_PATH, .F.)
			f := fcreate( iif(left(file,1)=="/",cygwinroot()+file, file), FC_NORMAL )
			if f < 0
					?? "PSPrinter: Could not save file "+file+":", ferror(), ferrorstr(), chr(10)
					return NIL
			endif
			fwrite( f, content )
			fclose( f )
			set(_SET_TRANSLATE_PATH, old)
		endif
	
	recover using oErr
		?? "PSPrinter:save() error:", errorMessage(oErr), chr(10)
		return NIL
	end sequence
		
return content


/* Generate PostScript from form */
static function ps_render( self, form, force )
	local t, a, i, oErr, content:="", b
	
	oErr := errorBlock({|e| break(e) })
	begin sequence
		//?? "render&\n"
		// Return early generated content
		if .not. empty(self:content) .and. (valtype(force) !='L' .or. .not. force)
			return self:content
		endif		
		
		//?? "check form&\n"
		// Check form
		if valtype(form) != 'O' .or. valtype(form:root) != 'O'
			return ''
		endif
		t := form:root
		
		//?? "parse header&\n"
		// Set title, page settings and styles
		a := t:XPath("/head/name")
		if valtype(a) == 'A' .and. len(a) > 0
			self:title := a[1]:getText()
		endif
		a := t:XPath("/head/page/*")
		if valtype(a) == 'A' .and. len(a) > 0
			for i in a
				self:set( lower(i:getName()), i:getText() )
			next
		endif	
		a := t:XPath("/head/style")
		if valtype(a) == 'A' .and. len(a) > 0
			for i in a
				self:setStyle( PSStyle(i, self) )
			next
		endif	
		//?? "process blocks&\n"
		
		// Generate blocks
		// Add first page
		self:y := 0
		self:add()
		a := t:XPath("/content/*")
		if valtype(a) == 'A' .and. len(a) > 0
			for i in a
				b := PSBlock( self, i, NIL )
				b:print()
			next
		endif
		
		//?? "print pages&\n"
		// Print pages
		self:content := self:printHeader()
		for i in self:pages
			self:content += i:print( self )
		next
		self:content += self:printFooter()
		//?? "end render&\n"
		
	recover using oErr
		?? "PSPrinter:render() error:", errorMessage(oErr), chr(10)
		return .F.
	end sequence

return self:content


/* Set page setting */
static function ps_set( self, name, value )
return self:page:set( name, value )


/* Set style */
static function ps_setStyle(self, style)
	local name:=""
	if valtype(style) == "O" .and. ascan(self:styles, {|e| style:getName()==e[1]}) == 0
		name := style:getName()
		if empty(name)
			name := "internal_style_" + ltrim(str(self:styleNum))
			style:name := name
			self:styleNum++
		endif
		aadd(self:styles, { name, style })
	endif
return name


/* Get style */
static function ps_getStyle(self, name)
	local i
	i := ascan(self:styles, {|e| name==e[1]})
	if i > 0
		return self:styles[i][2] 
	endif
return NIL


/* Print document header */
static function ps_printHeader( self )
	local s:="", tpw, tph, a, enc, fonts:=array(0), real_font, cyr_font, i, f, fExt, is
	
	// Write PS content
	// Write document header
	s += "%!PS-Adobe-2.0&\n"
	s += "%%Title: " + self:title + "&\n"
	s += "%%Creator: " + self:author + "&\n"
	s += "%%CreationDate: " + dtoc( date(),"DD/MM/YY") + " " + time() + "&\n"
   	s += "%%EndComments&\n"

	// Prolog: page size and encoding
	s += "%%BeginProlog&\n"
	tpw := ltrim(str(self:page:width))
	tph := ltrim(str(self:page:height))
	s += "<</PageSize [" + tpw + " " + tph + "] /ImagingBBox null>> setpagedevice&\n"

	s += "% Text format functions&\n"
	s += "/newline { tm bg sub /tm exch def lm tm moveto } def&\n"
	s += "/s /show load def&\n"
	s += "/L { newline } def&\n"
	s += "/n { s L } def&\n"
	s += "/centre { dup stringwidth pop 2 div rm lm sub 2 div&\n"
	s += "	exch sub lm add tm moveto } def&\n"
	s += "/right 	{ dup stringwidth pop rm exch sub tm moveto } def&\n"
	s += "/c { centre n } def&\n"
	s += "/l { n } def&\n"
	s += "/r { right n } def&\n"
	s += "/ssp { ( ) search pop } def&\n"
	s += "/spacecount { 0 exch ( ) { search { pop 3 -1 roll 1 add 3 1 roll } { pop exit } ifelse } loop } def&\n"
	s += "/dsp { dup stringwidth pop } def&\n"
	s += "/cpp { currentpoint pop } def&\n"
	s += "/S { dup spacecount { ssp dsp cpp add rm gt { L s s }{ s s } ifelse } repeat pop } def&\n"
	s += "/P { S L } def&\n"

	for i in self:styles
		is := i[2]
		f := is:getFontName()
		if at("Cyr", f) > 1 .and. ascan(fonts, {|e| e == f}) == 0
			aadd(fonts, f)
		endif
	next
	
	if len(fonts) > 0
		s += "&\n% Change encoding for used cyrillic fonts&\n"
		s += "/encoding_array 256 array def&\n"
		s += "0 1 127 { dup encoding_array exch dup StandardEncoding exch get put } for&\n"
		s += "128 1 255 { encoding_array exch /.notdef put } for&\n"
		s += "encoding_array&\n"
		s += "  dup 163 /afii10071 put %¸&\n"
		s += "  dup 179 /afii10023 put %¨&\n"
		s += "  dup 185 /afii61352 put %¹&\n"
		s += "  dup 192 /afii10096 put %þ&\n"
		s += "  dup 193 /afii10065 put %à&\n"
		s += "  dup 194 /afii10066 put %á&\n"
		s += "  dup 195 /afii10088 put %ö&\n"
		s += "  dup 196 /afii10069 put %ä&\n"
		s += "  dup 197 /afii10070 put %å&\n"
		s += "  dup 198 /afii10086 put %ô&\n"
		s += "  dup 199 /afii10068 put %ã&\n"
		s += "  dup 200 /afii10087 put %õ&\n"
		s += "  dup 201 /afii10074 put %è&\n"
		s += "  dup 202 /afii10075 put %é&\n"
		s += "  dup 203 /afii10076 put %ê&\n"
		s += "  dup 204 /afii10077 put %ë&\n"
		s += "  dup 205 /afii10078 put %ì&\n"
		s += "  dup 206 /afii10079 put %í&\n"
		s += "  dup 207 /afii10080 put %î&\n"
		s += "  dup 208 /afii10081 put %ï&\n"
		s += "  dup 209 /afii10097 put %ÿ&\n"
		s += "  dup 210 /afii10082 put %ð&\n"
		s += "  dup 211 /afii10083 put %ñ&\n"
		s += "  dup 212 /afii10084 put %ò&\n"
		s += "  dup 213 /afii10085 put %ó&\n"
		s += "  dup 214 /afii10072 put %æ&\n"
		s += "  dup 215 /afii10067 put %â&\n"
		s += "  dup 216 /afii10094 put %ü&\n"
		s += "  dup 217 /afii10093 put %û&\n"
		s += "  dup 218 /afii10073 put %ç&\n"
		s += "  dup 219 /afii10090 put %ø&\n"
		s += "  dup 220 /afii10095 put %ý&\n"
		s += "  dup 221 /afii10091 put %ù&\n"
		s += "  dup 222 /afii10089 put %÷&\n"
		s += "  dup 223 /afii10092 put %ú&\n"
		s += "  dup 224 /afii10048 put %Þ&\n"
		s += "  dup 225 /afii10017 put %À&\n"
		s += "  dup 226 /afii10018 put %Á&\n"
		s += "  dup 227 /afii10040 put %Ö&\n"
		s += "  dup 228 /afii10021 put %Ä&\n"
		s += "  dup 229 /afii10022 put %Å&\n"
		s += "  dup 230 /afii10038 put %Ô&\n"
		s += "  dup 231 /afii10020 put %Ã&\n"
		s += "  dup 232 /afii10039 put %Õ&\n"
		s += "  dup 233 /afii10026 put %È&\n"
		s += "  dup 234 /afii10027 put %É&\n"
		s += "  dup 235 /afii10028 put %Ê&\n"
		s += "  dup 236 /afii10029 put %Ë&\n"
		s += "  dup 237 /afii10030 put %Ì&\n"
		s += "  dup 238 /afii10031 put %Í&\n"
		s += "  dup 239 /afii10032 put %Î&\n"
		s += "  dup 240 /afii10033 put %Ï&\n"
		s += "  dup 241 /afii10049 put %ß&\n"
		s += "  dup 242 /afii10034 put %Ð&\n"
		s += "  dup 243 /afii10035 put %Ñ&\n"
		s += "  dup 244 /afii10036 put %Ò&\n"
		s += "  dup 245 /afii10037 put %Ó&\n"
		s += "  dup 246 /afii10024 put %Æ&\n"
		s += "  dup 247 /afii10019 put %Â&\n"
		s += "  dup 248 /afii10046 put %Ü&\n"
		s += "  dup 249 /afii10045 put %Û&\n"
		s += "  dup 250 /afii10025 put %Ç&\n"
		s += "  dup 251 /afii10042 put %Ø&\n"
		s += "  dup 252 /afii10047 put %Ý&\n"
		s += "  dup 253 /afii10043 put %Ù&\n"
		s += "  dup 254 /afii10041 put %×&\n"
		s += "  dup 255 /afii10044 put %Ú&\n"
		s += "pop&\n"
    endif
	
	// Transform fonts 
	// For each cyrillic font
	for i in fonts
		f := at("Cyr", i)
		real_font := left(i,f-1) + substr(i, f+3)
		cyr_font  := i
		s += "%%BeginResource: font "+cyr_font + "&\n"
		s += "/FullName ("+real_font+" Koi8) def&\n"
		s += "/FamilyName ("+real_font+" Koi8) def&\n"
		s += "/Weight (Regular) def&\n"
		s += "/ItalicAngle 0 def&\n"
		s += "/FontName /"+cyr_font+" def&\n"
		s += "/"+real_font+" findfont dup length dict dup&\n"
		s += "3 -1 roll&\n"
		s += "{ 1 index /FID ne 2 index /UniqueID ne 3 index /Encoding ne and and&\n"
		s += "	{ 2 index 3 1 roll put }&\n"
		s += "	{ pop pop } ifelse&\n"
		s += "} forall&\n"
		s += "dup /FontName /"+cyr_font+" put&\n"
		s += "dup /Encoding encoding_array put&\n"
		s += "/"+cyr_font+" exch definefont pop&\n"
		s += "%%EndResource&\n"
	next

    s += "%%EndProlog&\n&\n"

return s


/* Print document footer */
static function ps_printFooter( self )
	local s:="", inum
	// --------- PAGE -------------
	inum := ltrim(str( self:getPageCount() ))
    // Write document footer
    s += "%%Trailer&\n%%Pages:"+inum+"&\n%%EOF&\n"
return s


/* Convert current units to pt */
static function ps_val2pt( self, val )
	local nmul
	val := IIF(val==NIL,0,val)
	switch self:page:units
       	case PRINT_CM
          	nmul := val*10*PT_IN_MM
       	case PRINT_MM
          	nmul := val*PT_IN_MM
       	case PRINT_INCH
          	nmul := val*72
		otherwise
           	nmul := val
	endswitch
return nmul


/* Convert pt to current units */
static function ps_pt2val( self, val )
	local nmul
	val := IIF(val==NIL,0,val)
	switch self:units
       	case PRINT_CM
          	nmul := val/10/PT_IN_MM
       	case PRINT_MM
          	nmul := val/PT_IN_MM
       	case PRINT_INCH
          	nmul := val/72
		otherwise
           	nmul := val
	endswitch
return nmul


// Pages management
/* Add new page */
static function ps_add( self )
	local n, page
	n := self:getPageCount() + 1
	page := PSPage( n, self:page:layout, @self )
	aadd( self:pages, page )
	self:currentPage := page
return page


/* Get current page or page by number */
static function ps_getPage( self, num )
	if valtype(num) == 'N' .and. num > 0 .and. num <= self:getPageCount()
		return self:pages[num]
	else
		return self:currentPage
	endif
return NIL


/* Get page count */
static function ps_getPageCount( self )
return len(self:pages)
