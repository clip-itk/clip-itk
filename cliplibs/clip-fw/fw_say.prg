/*   FiveWin likely classes					*/
/*   TSAY							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#INCLUDE <fwin/FiveWin.ch>
#include <fwin/Constant.ch>

#define LTGRAY_BRUSH       1
#define TRANSPARENT        1

#define SS_CENTER          1
#define SS_RIGHT           2
#define SS_GRAYRECT        5 // BOXRECT

#define DLGC_BUTTON     8192   // 0x2000

#define COLOR_WINDOW       5
#define COLOR_WINDOWTEXT   8

#define WM_NCHITTEST     132  // 0x84

static Selector := GetSelector()

function TSay()
local obj := TControl()

	obj:classname	:= "FWIN_TSAY"
	obj:l3D		:= .f.
	obj:cPicture	:= NIL
	obj:bGet	:= NIL
	obj:lWantClick	:= NIL
	_recover_FWIN_TSAY(obj)
return obj
***********
function _recover_FWIN_TSAY(obj)
	obj:new		:= @fw_New()
	obj:reDefine	:= @fw_ReDefine()
	obj:cToChar	:= @fw_cToChar()
	obj:default	:= @fw_Default()
	obj:cGenPrg	:= @fw_cGenPrg()
	obj:handleEvent	:= @fw_HandleEvent()
	obj:initiate	:= @fw_Initiate()
	obj:refresh	:= @fw_Refresh()
	obj:setText	:= @fw_SetText()
	obj:varPut	:= @fw_VarPut()
return obj
***************
static function fw_New( self, nRow, nCol, bText, oWnd, cPicture, oFont,;
	    lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
	    nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised )

	DEFAULT nRow     := 0, nCol := 0,;
	   lBorder  := .f., lCentered := .f., lRight := .f., lPixels := .f.,;
	   oWnd     := GetWndDefault(),;
	   nClrText := oWnd:nClrText, nClrBack := oWnd:nClrBack,;
	   nHeight  := If( oFont != nil, Abs( oFont:nHeight ), SAY_CHARPIX_H ),;
	   lDesign  := .f., bText := { || "" },;
	   lUpdate  := .f., lShaded := .f., lBox := .f., lRaised := .f.

	self:l3D       = lShaded .or. lBox .or. lRaised
	self:bGet      = bText
	self:bSetGet   = bText
	self:cPicture  = cPicture
	self:cCaption  = If( Empty( cPicture ), ToString( Eval( bText ) ),;
		     Transform( Eval( bText ), cPicture ) )

	DEFAULT nWidth := ( If( oFont != nil, Abs( oFont:nWidth ), SAY_CHARPIX_W ) * Len( self:cCaption ) ) - 4	 // 8

	if ! lPixels
		self:nTop  = nRow * If( oFont != nil, Abs( oFont:nHeight ), SAY_CHARPIX_H ) + 2	  // 13
		self:nLeft = nCol * If( oFont != nil, Abs( oFont:nWidth ), SAY_CHARPIX_W )			 // 8
	else
		self:nTop  = nRow
		self:nLeft = nCol
	endif

	self:nBottom   = self:nTop + nHeight - 1
	self:nRight    = self:nLeft + nWidth - 1
	self:nHeight   = nHeight
	self:nWidth    = nWidth

	self:oWnd      = oWnd
	self:oFont     = oFont
	self:nId       = self:GetNewId()
	self:nStyle    = numOR( WS_CHILD, WS_VISIBLE,;
		 If( lDesign, numOR( WS_CLIPSIBLINGS, WS_TABSTOP ), 0 ),;
		 If( lCentered, SS_CENTER, If( lRight, SS_RIGHT, SS_LEFT ) ),;
		 If( lBorder, WS_BORDER, 0 ),;
		 If( lShaded, SS_BLACKRECT, 0 ),;
		 If( lBox,    SS_GRAYRECT,  0 ),;
		 If( lRaised, SS_WHITERECT, 0 ) )
	self:lDrag     = lDesign
	self:lCaptured = .f.
	self:lUpdate   = lUpdate
	self:lWantClick = .f.


	if ! Empty( oWnd:hWnd )
		eval(Selector:CreateLabel,self)
		oWnd:AddControl( Self )
	else
		oWnd:DefControl( Self )
	endif

	self:SetColor( nClrText, nClrBack )

	if self:lDrag
		self:CheckDots()
	endif

return Self
**************
static function fw_ReDefine( self, nId, bText, oWnd, cPicture,;
		 nClrText, nClrBack, lUpdate, oFont )

	DEFAULT nClrText  := oWnd:nClrText, nClrBack := oWnd:nClrPane,;
	   oWnd     := GetWndDefault(),;
	   lUpdate   := .f.

	self:l3D       = .f.
	self:nId       = nId
	self:bGet      = bText
	self:bSetGet   = bText
	self:cPicture  = cPicture
	self:oFont     = oFont

	if bText != nil
		self:cCaption = If( Empty( cPicture ), ToString( Eval( bText ) ),;
		       Transform( Eval( bText ), cPicture ) )
	endif

	self:oWnd      = oWnd
	self:hWnd      = 0
	self:lDrag     = .f.
	self:lCaptured = .f.
	self:lUpdate   = lUpdate
	self:lWantClick = .f.

	self:SetColor( nClrText, nClrBack )
	oWnd:DefControl( Self )

return Self
**************
static function fw_Initiate( self, hDlg )

	self:Super:Initiate( hDlg )

	if self:cCaption != nil // don't use Empty() here or blank texts will not show
		eval(Selector:SetWindowText, self:hWnd, self:cCaption )
	else
		self:cCaption = eval(Selector:GetWindowText, self:hWnd )
	endif

return
***********
static function fw_HandleEvent( self, nMsg, nWParam, nLParam )

	if nMsg == WM_LBUTTONDOWN
		return self:LButtonDown( nHiWord( nLParam ), nLoWord( nLParam ),;
			    nWParam )
	endif

	if ( ( self:lDrag .or. self:lWantClick ) .and. nMsg == WM_NCHITTEST ) // To have a standard behavior on Clicks
		return DefWindowProc( self:hWnd, nMsg, nWParam, nLParam )
	endif

return self:Super:HandleEvent( nMsg, nWParam, nLParam )
**************
static function fw_Default(self)

	if self:oFont != nil
		self:SetFont( self:oFont )
	else
		self:SetFont( self:oWnd:oFont )
	endif

return
**************
static function fw_cGenPrg(self)

local cCode := CRLF + "   @ " + Str( self:nTop, 3 ) + ", " + ;
		  Str( self:nLeft, 3 ) + ' SAY "' + self:cCaption + ;
		  '" SIZE ' + Str( self:nRight - self:nTop, 3 ) + ", " + ;
		  Str( self:nBottom - self:nTop, 3 ) + " PIXEL OF oWnd" + CRLF
return cCode
**************
static function fw_VarPut( self, cValue )

	if ! Empty( self:cPicture )
		cValue = Transform( cValue, self:cPicture )
	else
		cValue = ToString( cValue )
	endif

	self:bGet = { || cValue }

return
************
static function fw_cToChar(self)
return self:Super:cToChar( "STATIC" )
************
static function fw_Refresh(self)

	If self:bGet != nil
		self:SetText( Eval( self:bGet ) )
	endif
return
************
static function fw_SetText( self, cText )
	self:cCaption := If( self:cPicture != nil,;
		Transform( cText, self:cPicture ),;
		ToString( cText ) )
	eval(Selector:SetWindowText, self:hWnd, self:cCaption )
return
