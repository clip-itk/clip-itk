/*   FiveWin likely classes					*/
/*   TCOMBOBOX							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/



#include <fwin/FiveWin.ch>
#include <fwin/Constant.ch>

#define GWL_STYLE          -16

#define COMBO_BASE  WM_USER

#define CB_ADDSTRING     ( COMBO_BASE + 3 )
#define CB_DELETESTRING  ( COMBO_BASE +  4 )
#define CB_GETCURSEL     ( COMBO_BASE +  7 )
#define CB_INSERTSTRING  ( COMBO_BASE + 10 )
#define CB_RESETCONTENT  ( COMBO_BASE + 11 )
#define CB_FINDSTRING    ( COMBO_BASE + 12 )
#define CB_SETCURSEL     ( COMBO_BASE + 14 )
#define CB_SHOWDROPDOWN  ( COMBO_BASE + 15 )
#define CB_ERR              -1

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8

#define MB_ICONEXCLAMATION  48   // 0x0030

#define GW_CHILD             5
#define GW_HWNDNEXT          2

static Selector := GetSelector()

function TComboBox()
local obj := TControl()

	obj:classname	:= "FWIN_TCOMBOBOX"
	obj:aItems	:= {}
	obj:aBitmaps	:= {}
	obj:lOwnerDraw	:= .f.
	obj:nBmpHeight	:= NIL
	obj:nBmpWidth	:= NIL
	obj:nAt		:= NIL
	obj:bDrawItem	:= NIL
	obj:bCloseUp	:= NIL
	obj:cError	:= NIL
	obj:oGet	:= NIL
	obj:nStyle	:= NIL

	_recover_FWIN_TCOMBOBOX(obj)
return obj
***********
function _recover_FWIN_TCOMBOBOX(obj)

	obj:new		:= @fw_New()
	obj:reDefine	:= @fw_ReDefine()
	obj:add		:= @fw_Add()
	obj:cToChar	:= @fw_cToChar()
	obj:change	:= @fw_Change()
	obj:closeUp	:= @fw_CloseUp()
	obj:default	:= @fw_Default()
	obj:defControl	:= @fw_DefControl()
	obj:del		:= @fw_Del()
	//obj:destroy	:= @fw_Destroy()
	obj:drawItem	:= @fw_DrawItem()
	obj:fillMeasure	:= @fw_FillMeasure()
	obj:findString	:= @fw_FindString()
	obj:find	:= @fw_Find()
	obj:initiate	:= @fw_Initiate()
	obj:insert	:= @fw_Insert()
	obj:lostFocus	:= @fw_LostFocus()
	obj:lValid	:= @fw_lValid()
	obj:modify	:= @fw_Modify()
	obj:mouseMove	:= @fw_MouseMove()
	obj:open	:= @fw_Open()
	obj:refresh	:= @fw_Refresh()
	obj:reset	:= @fw_Reset()
	obj:select	:= @fw_Select()
	obj:set		:= @fw_Set()
	obj:setBitmaps	:= @fw_SetBitmaps()
	obj:setItems	:= @fw_SetItems()
	obj:showToolTop	:= @fw_ShowToolTip()
	obj:varGet	:= @fw_VarGet()

return obj


static function fw_New( self, nRow, nCol, bSetGet, aItems, nWidth, nHeight, oWnd, nHelpId,;
	    bChange, bValid, nClrFore, nClrBack, lPixel, oFont,;
	    cMsg, lUpdate, bWhen, lDesign, acBitmaps, bDrawItem, nStyle,;
	    cPict, bEChange )

	DEFAULT nRow     := 0, nCol := 0, bSetGet := { || nil },;
	   oWnd     := GetWndDefault(),;
	   aItems   := {}, nWidth := 40, nHeight := 60,;
	   nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;
	   nClrBack := GetSysColor( COLOR_WINDOW ),;
	   lPixel   := .f., lUpdate := .f., lDesign := .f.,;
	   nStyle   := CBS_DROPDOWNLIST

	self:cCaption  = ""
	self:nTop      = nRow * If( lPixel, 1, CMB_CHARPIX_H )  // 14
	self:nLeft     = nCol * If( lPixel, 1, CMB_CHARPIX_W )  // 8
	self:nWidth    = nWidth
	self:nHeight   = nHeight
	self:nBottom   = self:nTop  + nHeight - 1
	self:nRight    = self:nLeft + nWidth  - 1
	self:nAt       = 1
	self:aItems    = aItems
	self:bChange   = bChange
	self:bSetGet   = bSetGet
	self:oWnd      = oWnd
	self:oFont     = oFont
	self:nClrFore  = nClrFore
	self:nClrBack  = nClrBack

	if acBitmaps != nil
		self:SetBitmaps( acBitmaps )
	else
		self:lOwnerDraw = .f.
	endif

	self:nStyle    = nStyle //numOR( If( nStyle == CBS_DROPDOWN, 0, LBS_NOTIFY ), WS_TABSTOP,;
		      //nStyle,;
		      //LBS_DISABLENOSCROLL, WS_CHILD, WS_VISIBLE, WS_BORDER,;
		      //WS_VSCROLL, If( lDesign, WS_CLIPSIBLINGS, 0 ),;
		      //If( self:lOwnerDraw, CBS_OWNERDRAWFIXED, 0 ) )

	self:nId       = self:GetNewId()
	self:nHelpId   = nHelpId
	self:bValid    = bValid
	self:lDrag     = lDesign
	self:lCaptured = .f.
	self:cMsg      = cMsg
	self:lUpdate   = lUpdate
	self:bWhen     = bWhen
	self:bDrawItem = bDrawItem

/*
	if nStyle == CBS_DROPDOWN
		self:oGet := TGet():ReDefine( nil,    ;  // ID not used
			      self:bSetGet, ;  // bSETGET(uVar)
			      Self,      ;  // oDlg
			      self:nHelpID, ;  // Help Context ID
			      cPict,     ;  // Picture
			      nil,       ;  // Valid is handled by the CBx
			      self:nClrText,;
			      self:nClrPane,;
			      self:oFont,   ;  // <oFont>
			      nil,       ;  // <oCursor>
			      nil,       ;  // cMsg
			      nil,       ;  // <.update.>
			      nil,       ;  // <{uWhen}>
			      bEChange,  ;  // {|nKey,nFlags,Self| <uEChange>}
			      .F.        )  // <.readonly.> )
	endif
*/
	if oWnd:hWnd != NIL
		eval(Selector:CreateCombo, self )
		self:Default()
		oWnd:AddControl( Self )
	else
		oWnd:DefControl( Self )
	endif
	//self:SetColor( nClrFore, nClrBack )

	if self:oGet != nil
		self:oGet:hWnd = GetWindow( self:hWnd, GW_CHILD )
		self:oGet:Link()
		self:oGet:bLostFocus = ;
			{| hCtlFocus, nAt, cItem| cItem := GetWindowText( self:hWnd ), ;
		nAt := self:SendMsg( HASH_CB_FINDSTRING, 0, Trim( cItem )) + 1,;
		Eval( self:bSetGet, cItem ),;
		self:Select( nAt ),;
		eval(Selector:SetWindowText, self:hWnd, cItem ),;
		If( self:bValid != nil .and. ;
		eval(Selector:GetParent, hCtlFocus ) == eval(Selector:GetParent, self:hWnd ),;
		If( ! Eval( self:bValid ),;
		eval(Selector:PostMessage, self:hWnd, WM_SETFOCUS ),),) }
	endif

	if lDesign
		self:CheckDots()
	endif

return Self
***********
static function fw_ReDefine( self, nId, bSetGet, aItems, oWnd, nHelpId, bValid, ;
		 bChange, nClrFore, nClrBack, cMsg, lUpdate, ;
		 bWhen, acBitmaps, bDrawItem, nStyle, cPict, ;
		 bEChange )

	if nClrFore == nil
		nClrBack := GetSysColor( COLOR_WINDOW )
	endif

	DEFAULT aItems   := {},;
	   nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;
	   lUpdate  := .f., ;
	   nStyle   := CBS_DROPDOWNLIST

	self:nId       = nId
	self:hWnd      = 0
	self:aItems    = aItems
	self:bChange   = bChange
	self:bSetGet   = bSetGet
	self:oWnd      = oWnd
	self:nHelpId   = nHelpId
	self:bValid    = bValid
	self:nAt       = 1
	self:lDrag     = .f.
	self:lCaptured = .f.
	self:cMsg      = cMsg
	self:lUpdate   = lUpdate
	self:bWhen     = bWhen
	self:bDrawItem = bDrawItem
	self:nStyle    = nStyle

	if acBitmaps != nil
		self:SetBitmaps( acBitmaps )
	else
		self:lOwnerDraw = .f.
	endif

	self:SetColor( nClrFore, nClrBack )

	outlog(__FILE__, __LINE__, self:nStyle, nStyle, CBS_DROPDOWN)
	if self:nStyle == CBS_DROPDOWN
		self:oGet := TGet():ReDefine( nil,    ;  // ID not used
			      self:bSetGet, ;  // bSETGET(uVar)
			      Self,      ;  // oDlg
			      self:nHelpID, ;  // Help Context ID
			      cPict,     ;  // Picture
			      nil,       ;  // Valid is handled by the CBx
			      self:nClrText,;
			      self:nClrPane,;
			      self:oFont,   ;  // <oFont>
			      nil,       ;  // <oCursor>
			      nil,       ;  // cMsg
			      nil,       ;  // <.update.>
			      nil,       ;  // <{uWhen}>
			      bEChange,  ;  // {|nKey,nFlags,Self| <uEChange>}
			      .F.        )  // <.readonly.> )
	endif

	oWnd:DefControl( Self )

return Self
***********
static function fw_Add( self, cItem, nAt )

	DEFAULT nAt := 0

	if nAt == 0
		AAdd( self:aItems, cItem )
	else
		ASize( self:aItems, Len( self:aItems ) + 1 )
		AIns( self:aItems, nAt )
		self:aItems[ nAt ] = cItem
	endif

	self:SendMsg( HASH_CB_ADDSTRING, 0, cItem )

return
***********
static function fw_Change(self)

local cItem := GetWindowText( self:hWnd ) // Current Value

	self:nAt = self:SendMsg( HASH_CB_GETCURSEL ) + 1

	if self:nAt != 0 .and. self:nAt <= Len( self:aItems )
		if ValType( Eval( self:bSetGet ) ) == "N"
			Eval( self:bSetGet, self:nAt )
		else
			Eval( self:bSetGet, self:aItems[ self:nAt ] )
		endif
	endif

	if self:oGet != nil                        // Always not nil for dropdown
		self:oGet:VarPut( Eval( self:bSetGet ) )   // udate variable before calling bChange
		self:oGet:Refresh()
	endif

	if self:bChange != nil
		Eval( self:bChange, Self, cItem )
	endif

return
***********
static function fw_DefControl( self, oControl )

	if self:aControls == nil
		self:aControls = {}
	endif

	AAdd( self:AControls, oControl )

return
***********
static function fw_Set( self, cNewItem )
local nAt

	if ValType( cNewItem ) == "N"
		nAt = cNewItem
		if nAt == 0
			nAt = 1
		endif
	else
		nAt = AScan( self:aItems,;
		   { | cItem | Upper( AllTrim( cItem ) ) == ;
			       Upper( AllTrim( cNewItem ) ) } )
	endif

	if ValType( cNewItem ) == "N" .or. nAt != 0
		self:Select( nAt )
	else
		cNewItem := ToString( cNewItem )
		Eval( self:bSetGet, cNewItem )
		qout('set cursel', cNewItem)
		self:SendMsg(self:hWnd , HASH_CB_SETCURSEL, cNewItem )
	endif

return
**********
static function fw_LostFocus( self, hCtlFocus )
local nAt := self:SendMsg( HASH_CB_GETCURSEL )

	self:Super:LostFocus( hCtlFocus )

	if nAt != HASH_CB_ERR
		self:nAt = nAt + 1
		if ValType( Eval( self:bSetGet ) ) == "N"
			Eval( self:bSetGet, nAt + 1 )
		else
			Eval( self:bSetGet, self:aItems[ nAt + 1 ] )
		endif
	else
		Eval( self:bSetGet, GetWindowText( self:hWnd ) )
	endif

return
***********
static function fw_Modify( self, cItem, nAt )

	DEFAULT nAt := 0

	if nAt != 0
		self:aItems[ nAt ] = cItem
		self:SendMsg( HASH_CB_DELETESTRING, nAt )
		self:SendMsg( HASH_CB_INSERTSTRING, nAt, cItem )
	endif

return
************
static function fw_Insert( self, cItem, nAt )

	DEFAULT nAt := 0

	if nAt != 0
		ASize( self:aItems, Len( self:aItems ) + 1 )
		AIns( self:aItems, nAt )
		self:aItems[ nAt ] = cItem
		self:SendMsg( HASH_CB_INSERTSTRING, nAt , cItem )
	endif

return
************
static function fw_Del( self, nAt )

	DEFAULT nAt := 0

	if nAt != 0
		ADel( self:aItems, nAt )
		ASize( self:aItems, Len( self:aItems ) - 1 )
		self:SendMsg( HASH_CB_DELETESTRING, nAt )
	endif

return
*********
static function fw_Default(self)
local cStart := Eval( self:bSetGet )

	if cStart == nil
		Eval( self:bSetGet, If( Len( self:aItems ) > 0, self:aItems[ 1 ], "" ) )
		cStart = If( Len( self:aItems ) > 0, self:aItems[ 1 ], "" )
	endif

	AEval( self:aItems, { | cItem, nAt | self:SendMsg( HASH_CB_ADDSTRING, nAt, cItem ) } )

	if ValType( cStart ) != "N"
		self:nAt = AScan( self:aItems, { | cItem | Upper( AllTrim( cItem ) ) == ;
					   Upper( AllTrim( cStart ) ) } )
	else
		self:nAt = cStart
	endif

	self:nAt = If( self:nAt > 0, self:nAt, 1 )

	if cStart == nil
		self:Select( self:nAt )
	else
		self:Set( cStart )
	endif

	if self:oFont != nil
		self:SetFont( self:oFont )
	else
		self:SetFont( self:oWnd:oFont )
	endif

	if self:oGet != nil
		self:oGet:hWnd = GetWindow( self:hWnd, GW_CHILD )
		self:oGet:Link()
		if self:nStyle = CBS_DROPDOWN
			self:oGet:bLostFocus = ;
			{| hCtlFocus, nAt, cItem| cItem := GetWindowText( self:hWnd ), ;
			nAt := self:SendMsg( HASH_CB_FINDSTRING, 0, Trim( cItem )) + 1,;
			Eval( self:bSetGet, cItem ),;
			self:Select( nAt ),;
			eval(Selector:SetWindowText, self:hWnd, cItem ),;
			If( self:bValid != nil .and. ;
			eval(Selector:GetParent, hCtlFocus ) == eval(Selector:GetParent, self:hWnd ),;
			If( ! Eval( self:bValid ),;
			eval(Selector:PostMessage, self:hWnd, WM_SETFOCUS ),),) }
		else
			self:oGet:bLostFocus = { | hCtlFocus | If( self:bValid != nil .and. ;
			eval(Selector:GetParent, hCtlFocus ) == eval(Selector:GetParent, self:hWnd ),;
			If( ! Eval( self:bValid ),;
			eval(Selector:PostMessage, self:hWnd, WM_SETFOCUS ),),) }
		endif
	endif

return
************
static function fw_MouseMove( self, nRow, nCol, nKeyFlags )
local nResult := self:Super:MouseMove( nRow, nCol, nKeyFlags )

return If( self:lDrag, nResult, nil )    // We want standard behavior !!!
************
static function fw_SetBitmaps( self, acBitmaps )
local n

	self:lOwnerDraw = .t.

	if acBitmaps != nil
		self:aBitmaps = Array( Len( acBitmaps ) )
		for n = 1 to Len( acBitmaps )
			if File( acBitmaps[ n ] )
				self:aBitmaps[ n ] = eval(Selector:ReadBitmap, 0, acBitmaps[ n ] )
			else
				self:aBitmaps[ n ] = eval(Selector:LoadBitmap, GetResources(), acBitmaps[ n ] )
			endif
		next
		self:nBmpHeight = nBmpHeight( self:aBitmaps[ 1 ] )
		self:nBmpWidth  = nBmpWidth( self:aBitmaps[ 1 ] )
	endif

return
************
static function fw_Destroy(self)

   local n

   if self:aBitmaps != nil
      for n = 1 to Len( self:aBitmaps )
	 eval(Selector:DeleteObject, self:aBitmaps[ n ] )
      next
   endif

return self:Super:Destroy()
************
static function fw_DrawItem( self, nIdCtl, nPStruct )

return LbxDrawItem( nPStruct, self:aBitmaps, self:aItems, self:nBmpWidth, self:bDrawItem )
************
static function fw_VarGet(self)
local cRet, nAt := self:SendMsg( HASH_CB_GETCURSEL )

	if nAt != HASH_CB_ERR
		self:nAt = nAt + 1
		cRet :=  self:aItems[ nAt + 1 ]
	else
		cRet := GetWindowText( self:hWnd )
	endif

return cRet
***********
static function fw_lValid(self)
local lRet := .t.

	if ValType( self:bValid ) == "B"
		lRet = Eval( self:bValid, self:oGet  )
	endif

return lRet
***********
static function fw_ShowToolTip(self)
local nOldBottom

	nOldBottom = self:nBottom
	self:nBottom  = self:nTop + GetTextHeight( self:hWnd ) + 8

	self:Super:ShowToolTip()
	self:nBottom  = nOldBottom

return nil
***********
static function fw_cToChar(self)
return  self:Super:cToChar( "COMBOBOX" )
***********
static function fw_CloseUp(self)
	self:Change()
	If ::bCloseUp != nil
		Eval( ::bCloseUp, Self )
	endif
return
***********
static function fw_FillMeasure(self, nPInfo )
return eval(Selector:LbxMeasure, nPInfo, self:nBmpHeight )
***********
static function fw_FindString(self, cItem, nFrom )
	nFrom := If( nFrom == nil, 0, nFrom )
	self:SendMsg( HASH_CB_FINDSTRING, nFrom, cItem ) + 1
return
***********
static function fw_Find(self, cItem, nFrom )
return (self:FindString( cItem, nFrom ) != 0)
***********
static function fw_Initiate(self, hDlg )
	self:Super:Initiate( hDlg )
	self:Default()
	self:Refresh()
return
***********
static function fw_Open(self)
return self:SendMsg( HASH_CB_SHOWDROPDOWN, 1 )
***********
static function fw_Refresh(self)
	self:Set( Eval( self:bSetGet ) )
	self:Super:Refresh()
return
***********
static function fw_Reset(self)
	Eval( self:bSetGet,if( ValType( Eval( self:bSetGet ) ) == "N", 0, "" ) )
	self:nAt := 0
	self:SendMsg( HASH_CB_RESETCONTENT )
	self:Change()
return
***********
static function fw_Select(self, nItem )
	self:nAt := nItem
	self:SendMsg( HASH_CB_SETCURSEL, iif(len(self:aItems)>=nItem, self:aItems[nItem], replicate(" ", 50)), 0 )
return
***********
static function fw_SetItems(self, aItems )
	self:Reset()
	self:aItems := aItems
	self:Default()
	self:Change()
return
