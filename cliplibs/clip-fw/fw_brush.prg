/*   FiveWin likely classes					*/
/*   TBrush							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <fwin/FiveWin.ch>

#define BRUSH_NULL    5

static Selector := GetSelector()

function TBrush()
local obj:=map()

	obj:className	:= "FWIN_TBRUSH"
	obj:hBrush	:= NIL
	obj:hBitmap	:= NIL
	obj:nCount	:= NIL
	obj:cStyle	:= NIL
	obj:nRGBColor	:= NIL
	obj:cBmpFile	:= NIL
	obj:cBmpRes	:= NIL

	_recover_FWIN_TBRUSH(obj)

return obj
********************
function _recover_FWIN_TBRUSH(obj)

	obj:New		:= @fw_New()
	obj:cGenPRG	:= @fw_cGenPRG()
	obj:End		:= @fw_End()
	obj:Release	:= {|self| self:End()}

return obj
********************
static function fw_New( self, cStyle, nRGBColor, cBmpFile, cBmpRes )

local nAt
local aNewTypes := { "BORLAND", "BRICKS", "TILED", "TABS" }
local aStdTypes := { "HORIZONTAL", "VERTICAL", "FDIAGONAL", "BDIAGONAL",;
			"CROSS", "DIAGCROSS" }

	self:aBrushes = {}

	self:hBrush  = 0
	self:hBitmap = 0

	// Ron Pinkas added
	self:cStyle    := cStyle
	self:nRGBColor := nRGBColor
	self:cBmpFile  := cBmpFile
	self:cBmpRes   := cBmpRes


	do case
	case cStyle == nil .and. nRGBColor != nil
		self:hBrush = eval(Selector:CreateSolidBrush, nRGBColor )
	case cStyle != nil
		do case
		case cStyle == "NULL"
			self:hBrush = eval(Selector:GetStockObject, BRUSH_NULL )

		case ( nAt := AScan( aNewTypes, cStyle ) ) != 0
			self:hBitmap = eval(Selector:FWBrushes, nAt )

			self:hBrush = If( self:hBitmap > 0,;
				  eval(Selector:CreatePatternBrush, self:hBitmap ), )

		case ( nAt := AScan( aStdTypes, cStyle ) ) != 0
			self:hBrush = eval(Selector:CreateHatchBrush, nAt - 1, nRGBColor )

		otherwise
			if File( cBmpFile )
				self:hBitMap = ReadBitmap( 0, cBmpFile )
				self:hBrush = If( self:hBitmap > 0,;
					eval(Selector:CreatePatternBrush, self:hBitmap ), )
			endif
		endcase

	case cBmpFile != nil
		if File( cBmpFile )
			self:hBitMap = eval(Selector:ReadBitmap, 0, cBmpFile )
			self:hBrush = If( self:hBitmap > 0, eval(Selector:CreatePatternBrush, self:hBitmap ), )
		endif

	case cBmpRes != nil
		self:hBitmap = eval(Selector:LoadBitmap, eval(Selector:GetResources), cBmpRes )
		self:hBrush  = If( self:hBitmap > 0, eval(Selector:CreatePatternBrush, self:hBitmap ),)
	endcase

	self:nCount := 1

	AAdd( self:aBrushes, Self )

return Self
*************************
static function fw_cGenPRG(self)

local cPrg := ""

	cPrg += CRLF + ;
	   "   DEFINE BRUSH oBrush " + ;
		If( self:hBitmap != 0, 'BITMAP "brush.bmp"', "" ) + CRLF

return cPrg
*************************
static function fw_End(self)

// Ron Pinkas added 8/23/97
local nAt

	// Now different objects may use the same brush!!!
	if self:nCount == NIL
		self:nCount := 1
	endif

	if --self:nCount < 1
		nAt := AScan( self:aBrushes, { | oBrush | oBrush:hBrush = self:hBrush } )
		if nAt > 0
			ADel( self:aBrushes, nAt )
			ASize( self:aBrushes, Len( self:aBrushes ) - 1 )
		endif
	else
		return
	endif
	// End

	if self:hBrush != nil .and. self:hBrush != 0
		eval(Selector:DeleteObject, self:hBrush )
	endif

	if self:hBitmap != nil .and. self:hBitMap != 0
		eval(Selector:DeleteObject, self:hBitmap )
	endif

	self:hBrush  = 0
	self:hBitmap = 0

return

