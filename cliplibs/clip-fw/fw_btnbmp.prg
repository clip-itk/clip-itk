/*   FiveWin likely classes					*/
/*   TBtnBmp							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <fwin/fivewin.ch>
#define LTGRAY_BRUSH        1
#define RT_BITMAP           2

#define OPAQUE              0
#define TRANSPARENT         1

#define COLOR_BTNFACE      15
#define COLOR_BTNSHADOW    16
#define COLOR_BTNHIGHLIGHT 20

#define NO_FOCUSWIDTH      25

static Selector := GetSelector()

function TBtnBmp()
local obj:=Inherit(TControl())//map()

	obj:classname	:= "FWIN_TBTNBMP"
	obj:oWnd	:= NIL
	obj:bAction	:= NIL
	obj:cAction   	:= NIL // A string description of the action
	obj:lPressed	:= .f.
	obj:lCaptured	:= .f.
	obj:lAdjust	:= .f.
	obj:lGroup	:= .f.
	obj:lWorking	:= .f.
	obj:lBtnUp	:= .f.
	obj:lBtnDown	:= .f.
	obj:hBmpPal1	:= NIL
	obj:hBmpPal2	:= NIL
	obj:hBmpPal3	:= NIL
	obj:cResName1	:= NIL
	obj:cResName2	:= NIL
	obj:cResName3	:= NIL
	obj:cBmpFile1	:= NIL
	obj:cBmpFile2	:= NIL
	obj:cBmpFile3	:= NIL
	obj:lProcessing := .f.
	obj:lBorder 	:= .t.
	obj:oPopup	:= NIL

	_recover_FWIN_TBTNBMP(obj)
return obj
***********
function _recover_FWIN_TBTNBMP(obj)
	obj:new		:= @fw_new()
	obj:newBar	:= @fw_newBar()
	obj:create	:= @fw_create()
	obj:loadBitmaps	:= @fw_loadBitmaps()
return obj
***********
static function fw_new(self, nTop, nLeft, nWidth, nHeight,;
		       cResName1, cResName2, cBmpFile1, cBmpFile2,;
		       bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
		       cPrompt, oFont, cResName3, cBmpFile3, lBorder )

	DEFAULT cMsg := " ", nWidth := 20, nHeight := 20, lAdjust := .f.,;
	   lUpdate := .f., oWnd := GetWndDefault(), lBorder := .t.

	self:nStyle    = numOR( WS_CHILD, WS_VISIBLE,; // WS_CLIPSIBLINGS
		      If( lBorder, WS_BORDER, 0 ),;
		      If( oWnd:ClassName != "FWIN_TBAR", WS_TABSTOP, 0 ) )
	self:nId       = self:GetNewId()
	self:oWnd      = oWnd
	self:bAction   = bAction
	self:cMsg      = cMsg
	self:nTop      = nTop
	self:nLeft     = nLeft
	self:nBottom   = nTop + nHeight - 1
	self:nRight    = nLeft + nWidth - 1
	self:lPressed  = .f.
	self:lWorking  = .f.
	self:lAdjust   = lAdjust
	self:lDrag     = .f.
	self:lCaptured = .f.
	self:bWhen     = bWhen
	self:nClrPane  = GetSysColor( COLOR_BTNFACE )
	self:lUpdate   = lUpdate
	self:l97Look   = !lBorder
	self:lBorder   = lBorder
	self:lBtnDown  = .f.

	/*
	self:hBmpPal1  = NIL
	self:hBmpPal2  = NIL
	self:hBmpPal3  = NIL
	*/
	self:cCaption  = cPrompt
	self:oFont     = oFont
	self:nDlgCode  = If(self:oWnd:className == "TBAR", nil, DLGC_WANTALLKEYS )

	//self:Register( numOR( CS_VREDRAW, CS_HREDRAW ) )

	if ! Empty( oWnd:hWnd )
		self:Create()
		self:SetColor( self:nClrText, self:nClrPane )
		oWnd:AddControl( Self )
	else
		oWnd:DefControl( Self )
	endif

	self:LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
		  cResName3, cBmpFile3 )
return self
***********
static function fw_newBar(self, cResName1, cResName2, cBmpFile1, cBmpFile2, cMsg, bAction,;
				lGroup, oBar, lAdjust, bWhen, cToolTip, lPressed,;
				bDrop, cAction, nPos, cPrompt, oFont, cResName3, cBmpFile3,;
				lBorder, oPopup )



	DEFAULT cMsg := "", lAdjust := .f., lPressed := .f., lBorder := .t. //ojo

	self:nStyle    = numOr( If( lBorder, WS_BORDER, 0 ), WS_CHILD, WS_VISIBLE )
	self:l97Look   = !lBorder
	self:nId       = self:GetNewId()
	self:oWnd      = oBar
	self:bAction   = bAction
	self:cMsg      = cMsg
       //	self:nTop      = oBar:GetBtnTop( lGroup, nPos )
	//self:nLeft     = oBar:GetBtnLeft( lGroup, nPos )
	//self:nBottom   = self:nTop + oBar:nBtnHeight + 1 - If( oBar:l3D, 7, 0 )
	//self:nRight    = self:nLeft + oBar:nBtnWidth - If( oBar:l3D, 2, 0 ) + ;
	//		 If( oPopup != nil, 13, 0 )
	self:lPressed  = lPressed
	self:lCaptured = .f.
	self:lWorking  = .f.
	self:lDrag     = .f.
	self:lBtnDown  = lPressed
	self:lAdjust   = lAdjust
	self:lGroup    = lGroup
	self:bWhen     = bWhen
	self:nClrPane  = GetSysColor( COLOR_BTNFACE )
	self:oCursor   = oBar:oCursor
	self:cToolTip  = cToolTip
	self:bDropOver = bDrop
	self:cResName1 = cResName1
	self:cResName2 = cResName2
	self:cBmpFile1 = cBmpFile1
	self:cBmpFile2 = cBmpFile2
	self:cAction   = cAction
	self:cCaption  = cPrompt
	self:oFont     = oFont
	self:lBorder   = lBorder
	/*
	self:hBmpPal1  = NIL
	self:hBmpPal2  = NIL
	self:hBmpPal3  = NIL
	*/
	self:oPopup    = oPopup
	self:nDlgCode  = If( self:oWnd:ClassName  == "FWIN_TBAR", nil, DLGC_WANTALLKEYS )


	//self:Register( numOr( CS_VREDRAW, CS_HREDRAW ) )

	self:Create()
	oBar:Add( Self, nPos )
	self:SetColor( self:nClrText, self:nClrPane )

	self:LoadBitmaps( cResName1, cResName2, cBmpFile1, cBmpFile2,;
		  cResName3, cBmpFile3 )

	if bWhen != nil .and. ! self:lWhen()
		self:Disable()
	endif


return self
**************
static function fw_create(self)
	eval(Selector:CreateButton,self)
return
**************
static function fw_loadBitmaps(self, cResName1, cResName2, cBmpFile1, cBmpFile2,;
				     cResName3, cBmpFile3 )
	/*
	if ! Empty( cResName1 )
		self:hBmpPal1 := PalBmpLoad( cResName1 )
	endif

	if ! Empty( cResName2 )
		self:hBmpPal2 := PalBmpLoad( cResName2 )
	endif

	if ! Empty( cResName3 )
		self:hBmpPal3 := PalBmpLoad( cResName3 )
	endif
	*/

	if cBmpFile1 != NIL
		if File( cBmpFile1 )
			self:cBmpFile1 := cBmpFile1
			self:hBmpPal1  := eval(Selector:PalBmpRead, self:oWnd:oWnd, cBmpFile1 )
	       //		self:ReleaseDC()
		endif
	endif

	if cBmpFile2 != NIL
		if File( cBmpFile2 )
			self:hBmpPal2  := eval(Selector:PalBmpRead, self:oWnd:oWnd, cBmpFile2 )
		 //	self:ReleaseDC()
		endif
	endif

	if cBmpFile3 != NIL
		if File( cBmpFile3 )
			self:hBmpPal3  := eval(Selector:PalBmpRead, self:oWnd:oWnd, cBmpFile3 )
		   //	self:ReleaseDC()
		endif
	endif

	if self:hBmpPal1 != NIL
		eval(Selector:PalBmpNew, self, self:hBmpPal1 )
	endif

	if self:hBmpPal2 != NIL
		eval(Selector:PalBmpNew, self, self:hBmpPal2 )
	endif

	if self:hBmpPal3 != NIL
		eval(Selector:PalBmpNew, self, self:hBmpPal3 )
	endif

return
