/*   FiveWin likely classes					*/
/*   TMsgBar							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <clip-gtk.ch>
#include <fwin/fivewin.ch>

#define BAR_HEIGHT           28
#define GRAY_BRUSH            2

#define BAR_TOP               1
#define BAR_LEFT              2
#define BAR_RIGHT             3
#define BAR_DOWN              4
#define BAR_FLOAT             5

#define SM_CYBORDER           6
#define SM_CYCAPTION          4

#define COLOR_BTNFACE        15
#define COLOR_BTNSHADOW      16
#define COLOR_BTNHIGHLIGHT   20

#define GROUP_SEP            8

static Selector := GetSelector()

function TBar()
local obj:=TControl()

	obj:className	:= "FWIN_TBAR"
	obj:nGroups	:= NIL
	obj:nMode	:= NIL
	obj:cMode	:= NIL
	obj:nBtnWidth	:= NIL
	obj:nBtnHeight	:= NIL
	obj:l3D		:= .f.
	obj:oWnd	:= NIL
	obj:nClrText	:= 0
	obj:nClrPane	:= 0


	_recover_FWIN_TBAR(obj)
return obj
***********
function _recover_FWIN_TBAR(obj)
	obj:new		:= @fw_new()
	obj:create	:= @fw_create()
	obj:setColor	:= @fw_setColor()
	obj:add		:= @fw_add()
return obj
***********
static function fw_new(self, oWnd, nBtnWidth, nBtnHeight, l3D, cMode, oCursor)
local oRect
	DEFAULT nBtnWidth := BAR_HEIGHT, nBtnHeight := BAR_HEIGHT,;
	   l3D := .f., cMode := "TOP"


	oRect := oWnd:GetCliRect()
	self:nStyle      = numOR( WS_BORDER, WS_CHILD, WS_VISIBLE )
	self:aControls   = {}
	self:nGroups     = 0
	self:oWnd        = oWnd

	self:nTop        = If( cMode == "BOTTOM", oRect:nBottom - nBtnHeight, -1 )
	self:nLeft       = If( cMode == "RIGHT", oRect:nRight - nBtnWidth - ;
			   If( l3D, 3, 0 ), -1 )
	self:nBottom     = If( cMode == "TOP", nBtnHeight, oRect:nBottom + 1 )
	self:nRight      = If( cMode == "TOP" .or. cMode == "BOTTOM",;
			       oRect:nRight,;
			   If( cMode == "LEFT", nBtnWidth + If( l3D, 3, 0 ), oRect:nRight + 1 ) )

	self:nBtnWidth   = nBtnWidth
	self:nBtnHeight  = nBtnHeight
	self:nId         = self:GetNewId()
	self:lDrag       = .f.
	self:lCaptured   = .f.
	self:nClrPane    = If( l3D, GetSysColor( COLOR_BTNFACE ), CLR_GRAY )
	self:lVisible    = .t.
	self:l3D         = l3D
	self:cMode	 = cMode
	self:nMode       = AScan( { "TOP", "LEFT", "RIGHT", "BOTTOM", "FLOAT" }, cMode )
	self:oCursor     = oCursor
	self:lValidating = .f.


	self:Create()

	self:SetColor( self:nClrText, self:nClrPane )
return self
**********
static function fw_create(self)
	eval(Selector:CreateButtonBar,self, self:cMode)
return
***************
static function fw_setColor(self, nClrFore, nClrBack)
	eval(Selector:FwSetColor,self, nClrFore, nClrBack)
return
***************
static function fw_add(self, oBtnBmp, nPos)
	if nPos == nil
		AAdd( self:aControls, oBtnBmp )
	else
		AAdd( self:aControls, nil )
		AIns( self:aControls, nPos )
		self:aControls[ nPos ] = oBtnBmp
	endif
return
