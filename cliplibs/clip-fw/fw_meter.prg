/*   FiveWin likely classes					*/
/*   TMeter							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#INCLUDE <fwin/FiveWin.ch>
#include <fwin/Constant.ch>

#define LTGRAY_BRUSH 1

static Selector := GetSelector()

function TMeter()
local obj:=TControl()

	obj:classname	:= "FWIN_TMETER"
	obj:lRegistered	:= .f.

	obj:nTotal	:= 0
	obj:nRefresh 	:= 0 //add nRefresh 27 Jul 96, used for sysrefresh jrh
	obj:nClrBar	:= NIL
	obj:nClrBText	:= NIL
	obj:cText	:= NIL
	obj:lPercentage	:= .f.

	_recover_FWIN_TMETER(obj)
return obj
***************
function _recover_FWIN_TMETER(obj)

	obj:new		:= @fw_New()
	obj:redefine	:= @fw_ReDefine()
	obj:default	:= @fw_Default()
	obj:display	:= @fw_Display()
	obj:initiate	:= @fw_Initiate()
	obj:paint	:= @fw_Paint()
	obj:set		:= @fw_Set()
	obj:setTotal	:= @fw_SetTotal()

return obj
****************
static function fw_New( self, nRow, nCol, bSetGet, nTotal, oWnd, nWidth, nHeight,;
	    lUpdate, lPixel, oFont, cText, lNoPercentage, nClrPane, nClrText, ;
	    nClrBar, nClrBText, lDesign )


	DEFAULT nRow     := 0, nCol := 0, lNoPercentage := .f., oWnd := GetWndDefault(), ;
		bSetGet  := { || 1 }, lPixel   := .f., ;
		nClrBar  := CLR_HBLUE, nClrBText := CLR_WHITE, ;
		nClrText := oWnd:nClrText, nClrPane := oWnd:nClrPane, ;
		cText    := Chr( 0 ), ;
		nTotal   := 10, nWidth := 300, nHeight := 20,;
		lUpdate  := .f., lDesign := .f.

	self:nTop      = If( lPixel, nRow, nRow * MTR_CHARPIX_H )  //14
	self:nLeft     = If( lPixel, nCol, nCol *  MTR_CHARPIX_W ) //8
	self:nWidth    = nWidth
	self:nHeight   = nHeight
	self:nBottom   = self:nTop  + nHeight
	self:nRight    = self:nLeft + nWidth
	self:oWnd      = oWnd
	self:nStyle    = numOr( WS_CHILD, WS_VISIBLE,;
		 If( lDesign, numOr( WS_CLIPSIBLINGS, WS_TABSTOP ), 0 ) )
	self:nId       = self:GetNewId()
	self:bSetGet   = bSetGet
	self:nTotal    = nTotal
	self:lDrag     = lDesign
	self:lCaptured = .f.
	self:lUpdate   = .f.

	self:nClrText  = nClrText
	self:nClrPane  = nClrPane
	self:nClrBar   = nClrBar
	self:nClrBText = nClrBText
	self:cText     = cText
	self:lPercentage = ! lNoPercentage

	self:oFont     = oFont


	//self:Register( numOr( CS_VREDRAW, CS_HREDRAW ) )

	self:nRefresh  := 0  // initailize for sysrefresh 27 Jul 96 jrh

	if ! Empty( oWnd:hWnd )
		eval(Selector:CreateProgressBar,self)
		self:Default()
		oWnd:AddControl( Self )
	else
		oWnd:DefControl( Self )
	endif

	/*
	if lDesign
		self:CheckDots()
	endif
	*/

return Self
****************
static function fw_ReDefine( self, nId, bSetGet, nTotal, oWnd, lUpdate, ;
		 oFont, cText, lNoPercentage, nClrPane, nClrText, ;
		 nClrBar, nClrBText )

	DEFAULT lNoPercentage := .f., nTotal   := 10, lUpdate := .f.,;
		nClrBar  := CLR_HBLUE, nClrBText := CLR_WHITE,;
		nClrText := oWnd:nClrText, nClrPane := oWnd:nClrPane, ;
		cText    := Chr( 0 )

	self:nId       = nId
	self:bSetGet   = bSetGet
	self:nTotal    = nTotal
	self:oWnd      = oWnd
	self:lDrag     = .f.
	self:lCaptured = .f.
	self:lUpdate   = lUpdate

	self:nClrText  = nClrText
	self:nClrPane  = nClrPane
	self:nClrBar   = nClrBar
	self:nClrBText = nClrBText
	self:cText     = cText
	self:lPercentage = ! lNoPercentage
	self:oFont     = oFont

	self:nRefresh  := 0  // initailize for sysrefresh 27 Jul 96 jrh

	//self:Register( numOr( CS_VREDRAW, CS_HREDRAW ) )

	if oWnd != nil
		oWnd:DefControl( Self )
	endif

return Self
****************
static function fw_Display( self )

	//self:BeginPaint()
	self:Paint()
	//self:EndPaint()

return 0
*****************
static function fw_Paint(self)

local nActual := Eval( self:bSetGet )

   eval(Selector:ProgressPaint, self, nActual / If( self:nTotal != 0, self:nTotal, 1 ) )
return nil
*******************
static function fw_Set( self, nActual )

	DEFAULT nActual := Eval( self:bSetGet )

	if nActual > self:nTotal
		nActual = self:nTotal
	endif

	if nActual < 0
		nActual = 0
	endif

	Eval( self:bSetGet, nActual )
// add 27 Jul 96 to do the sysrefresh only when the meter moves jrh
	if self:nTotal != 0 .and. ( self:nRefresh + ( nActual / self:nTotal ) * 100 ) ;
			>= self:nRefresh + 1
		self:nRefresh += ( ( nActual / self:nTotal ) * 100 )
		self:Refresh( .f. )
		self:Paint()
		SysRefresh()
	endif
return nil
**************
static function fw_Default(self)

	if ValType( Eval( self:bSetGet ) ) == "U"
		Eval( self:bSetGet, 0 )
	endif

	if self:oFont != nil
		self:SetFont( self:oFont )
	else
		self:SetFont( self:oWnd:oFont )
	endif

return nil
*****************
static function fw_Initiate( self, hDlg )
	self:Super:Initiate( hDlg )
	self:Default()
return
****************
static function fw_SetTotal( self, nTotal )
	eval(Selector:ProgressBarSetTotal,self, nTotal)
	self:Refresh()
return
