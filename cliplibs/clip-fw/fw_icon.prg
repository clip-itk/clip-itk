/*   FiveWin likely classes					*/
/*   TIcon							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <fwin/FiveWin.ch>
#include <fwin/Constant.ch>

#define IDI_HAND   32513

static Selector := GetSelector()

function TIcon()
local obj := Inherit(TControl())

	obj:ClassName	:= "FWIN_TICON"
	obj:lRegistered	:= .t.

	obj:cIcoFile	:= ""
	obj:cResName	:= ""
	obj:hIcon	:= NIL

	_recover_FWIN_TICON(obj)
return obj
**********
function _recover_FWIN_TICON(obj)

	obj:New		:= @fw_New()
	obj:ReDefine	:= @fw_ReDefine()
	obj:Display	:= {| Self | self:BeginPaint(), self:Paint(), self:EndPaint(), 0}
	obj:Paint	:= {| Self |  DrawIcon( self:hDC, 0, 0, self:hIcon )
	//obj:Destroy	:= @fw_Destroy()
	obj:SetName	:= @fw_SetName()
	obj:SetFile	:= @fw_SetFile()
	obj:Initiate	:= @fw_Initiate()
	obj:End		:= @fw_End()

return obj

//----------------------------------------------------------------------------//

static function fw_New( self, nRow, nCol, cResName, cIcoFile, lBorder, bClick, oWnd,;
	    lUpdate, bWhen, nClrFore, nClrBack )

   DEFAULT nRow := 0, nCol := 0, cResName := "",;
	   cIcoFile := "", lBorder := .f., lUpdate := .f.

   self:nTop      = nRow * ICO_CHARPIX_H // 14
   self:nLeft     = nCol * ICO_CHARPIX_W // 8
   self:nBottom   = self:nTop  + 32
   self:nRight    = self:nLeft + 32
   self:oWnd      = oWnd
   self:nStyle    = numOr( WS_CHILD, WS_VISIBLE, If( lBorder, WS_BORDER, 0 ) )
   self:nId       = self:GetNewId()
   self:cIcoFile  = cIcoFile
   self:cResName  = cResName
   self:bLClicked = bClick
   self:lDrag     = .f.
   self:lCaptured = .f.
   self:lUpdate   = lUpdate
   self:bWhen     = bWhen

   //self:Register( numOr( CS_VREDRAW, CS_HREDRAW ) )

   if oWnd != nil
      self:nClrText  = oWnd:nClrText
      self:nClrPane  = oWnd:nClrPane
      if ! Empty( oWnd:hWnd )
	 self:Create()
      else
	 oWnd:DefControl( Self )
      endif
   else
      oWnd   = GetWndDefault()
      self:hWnd = 0
      if oWnd != nil
	 self:nClrText = oWnd:nClrText
	 self:nClrPane = oWnd:nClrPane
      endif
   endif

   self:SetColor( nClrFore, nClrBack )

   if ! Empty( cIcoFile )
      self:hIcon = eval(Selector:ExtractIcon, cIcoFile )
   endif

   if ! Empty( cResName )
      self:hIcon = eval(Selector:LoadIcon, GetResources(), cResName )
   endif

return Self

//----------------------------------------------------------------------------//

static function fw_ReDefine( self, nId, cResName, cIcoFile, bClick, lUpdate, oDlg,;
		    bWhen )

   DEFAULT lUpdate := .f.

   self:nId       = nId
   self:cResName  = cResName
   self:cIcoFile  = cIcoFile
   self:bLClicked = bClick
   self:lUpdate   = lUpdate
   self:oWnd      = oDlg
   self:bWhen     = bWhen

   self:Register( numOr( CS_VREDRAW, CS_HREDRAW ) )

   oDlg:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

static function fw_SetName( self, cNewName )

   if ! Empty( cNewName )
      self:cResName = cNewName
      if self:hIcon != 0
	 eval(Selector:DestroyIcon, self:hIcon )
      endif
      self:hIcon = eval(Selector:LoadIcon, eval(Selector:GetResources), cNewName )
      self:Refresh( .t. )
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_SetFile( self, cIcoFile )

   if ! Empty( cIcoFile ) .and. File( cIcoFile )
      self:cIcoFile = cIcoFile
      if self:hIcon != 0
	 eval(Selector:DestroyIcon, self:hIcon )
      endif
      self:hIcon = eval(Selector:ExtractIcon, cIcoFile )
      self:Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_Initiate( self, hDlg )

   self:Super:Initiate( hDlg )

   if ! Empty( self:cIcoFile )
      self:hIcon = eval(Selector:ExtractIcon, self:cIcoFile )
   endif

   if ! Empty( self:cResName )
      self:hIcon = eval(Selector:LoadIcon, eval(Selector:GetResources), self:cResName )
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_End(self)

   if self:hWnd == 0
      self:Destroy()
   else
      return self:Super:End()
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_Destroy()

   if self:hIcon != 0
      eval(Selector:DestroyIcon, self:hIcon )
      self:hIcon = 0
   endif

return self:Super:Destroy()

//----------------------------------------------------------------------------//
