/*   FiveWin likely classes					*/
/*   TFont							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#INCLUDE <fwin/FiveWin.ch>

#define FW_NORMAL          400
#define FW_BOLD            700

#define OEM_FIXED_FONT      10
#define ANSI_FIXED_FONT     11
#define ANSI_VAR_FONT       12
#define SYSTEM_FONT         13
#define DEVICE_DEFAULT_FONT 14
#define SYSTEM_FIXED_FONT   16

#define MM_ANISOTROPIC       8

#define LOGPIXELSY          90

static Selector := GetSelector()

function TFont()
local obj:=map()

	obj:className	:= "FWIN_TFONT"
	obj:cFaceName	:= NIL
	obj:cFontDescription := NIL
	obj:hFont	:= NIL
	obj:hFontOld	:= NIL
	obj:lBold	:= .f.
	obj:lItalic	:= .f.
	obj:lUnderline	:= .f.
	obj:lStrikeOut	:= .f.
	obj:nHeight	:= 0
	obj:nWidth	:= 0
	obj:nEscapement	:= 0
	obj:nOrientation:= 0
	obj:nWeight	:= 0
	obj:nCharSet	:= NIL
	obj:nOutPrecision:= NIL
	obj:nClipPrecision:= NIL
	obj:nQuality	:= NIL
	obj:nPitchFamily:= NIL
	obj:nCount	:= 0
	obj:lDestroy	:= .f.

	_recover_FWIN_TFONT(obj)
return obj
function _recover_FWIN_TFONT(obj)
	obj:new		:= @fw_new()
	obj:choose	:= @fw_choose()
	obj:end		:= @fw_end()
	obj:release	:= @fw_end()  // it's FW-fichka
	obj:activate	:= @fw_activate()
	obj:deActivate	:= @fw_deActivate()
	obj:nSize	:= @fw_nSize()
return obj
*************
static function fw_new(self, cFaceName, nWidth, nHeight, lFromUser, lBold,;
			nEscapement, nOrientation, nWeight, lItalic, lUnderline,;
			lStrikeOut, nCharSet, nOutPrecision, nClipPrecision,;
			nQuality, oDevice )
local cFont:="", aFont

	FWInitDriver()

	DEFAULT cFaceName := FONT_DEFAULT, nWidth := 0, nHeight := 0, lBold := .f.,;
	nOrientation := 0, nWeight := 0, lItalic := .f., lUnderline := .f.,;
	nQuality := 0

	/* !!!!!!!! WHILE IT SO !!!!!!!!! */
	cFaceName := FONT_DEFAULT
	/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */

	aFont := split(cFaceName, "-")
	aDel(aFont, 1)
	aSize(aFont, 14)

	/*Foundry - the company or organization where the font originated.*/
	cFont += "-"+iif(aFont[1]==NIL, "*", aFont[1])

	/*Family - the font family (a group of related font designs).                              */
	cFont += "-"+iif(aFont[2]==NIL, "*", aFont[2])

	/*Weight - A name for the font's typographic weight For example, 'bold' or 'medium').  */
	cFont += "-"+iif(aFont[3]==NIL, iif(lBold, "bold", "medium"), aFont[3])

	/*Slant - The slant of the font. Common values are 'R' for Roman, 'I' for italoc,
	  and 'O' for oblique.                         */
	cFont += "-"+iif(aFont[4]==NIL, iif(lItalic, "i", "r"), aFont[4])

	/*Set Width - A name for the width of the font. For example, 'normal' or 'condensed'.          */
	cFont += "-"+iif(aFont[5]==NIL, "normal", aFont[5])

	/*Add Style - Additional information to distinguish
	  a font from other fonts of the same family.      */
	cFont += "-"+iif(aFont[6]==NIL, "*", aFont[6])

	/*Pixel Size - The body size of the font in pixels.*/
	cFont += "-"+iif(aFont[7]==NIL, "*", aFont[7])

	/*Point Size - The body size of the font in 10ths
	  of a point. (A point is 1/72.27 inch)          */
	cFont += "-"+iif(aFont[8]==NIL, iif(nWidth==0, "*", str(nWidth/72.27, 1)), aFont[8])

	/*Resolution X - The horizontal resolution that
	  the font was designed for.                   	*/
	cFont += "-"+iif(aFont[9]==NIL, "*", aFont[9])

	/*Resolution Y - The vertical resolution that
	  the font was designed for .                */
	cFont += "-"+iif(aFont[10]==NIL, "*", aFont[10])

	/*Spacing - The type of spacing for the font -
	  can be 'p' for proportional, 'm' for monospaced or 'c' for charcell.*/
	cFont += "-"+iif(aFont[11]==NIL, "*", aFont[11])

	/*Average Width - The average width of a glyph
	  in the font. For monospaced and charcell fonts,
	  all glyphs in the font have this width          */
	cFont += "-"+iif(aFont[12]==NIL, "*", aFont[12])

	/*Charset Registry - The registration authority
	  that owns the encoding for the font. Together
	  with the Charset Encoding field, this defines
	  the character set for the font.               */
	cFont += "-"+iif(aFont[13]==NIL, "*", aFont[13])

	/*Charset Encoding - An identifier for the
	  particular character set encoding.       */
	cFont += "-"+iif(aFont[14]==NIL, "*", aFont[14])

	//self:cFontDescription := cFont

	self:hFont := eval(Selector:CreateFont,cFont)
	if self:nWidth == NIL .or. self:nWidth == 0
		self:nWidth := eval(Selector:GetFontWidth,self:hFont)
	endif
	if self:nHeight == NIL .or. self:nHeight == 0
		self:nHeight := eval(Selector:GetFontHeight,self:hFont)
	endif
	if self:hFont != NIL
		self:lDestroy := .t.
	endif
return self
***************
static function fw_choose(self, nRGBColor)
local cFont, fsd
	cFont := eval(Selector:ChooseFont,self, nRGBColor)
	self:nCount = 0
	if ! Empty( self:hFont ) .and. self:lDestroy
		eval(Selector:DeleteObject, self:hFont )
	endif
	self:hFont = eval(Selector:CreateFont,cFont)
	if self:hFont != NIL
		self:lDestroy := .t.
	endif
return
*****************
static function fw_end(self)
	if self:nCount == nil
		self:nCount = 1
	endif

	if --self:nCount < 1
		if ! Empty( self:handle ) .and. self:lDestroy
			eval(Selector:DeleteObject, self:handle )
			/*
			self:hFont  = -1   // because handle may be 0
			self:handle  = -1   // because handle may be 0
			self:nCount = 0
			self:cFontDescription := NIL
			*/
		endif
	endif
return
******************
static function fw_activate(self)
	self:hFontOld := eval(Selector:GetDefaultFont)
return
******************
static function fw_deActivate(self)
	self:hFont := eval(Selector:SetDefaultFont,self:hFontOld)
return
******************
static function fw_nSize(self)
return eval(Selector:SizeFont,self:hFont)

