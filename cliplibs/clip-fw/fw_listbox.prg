#include <fwin/FiveWin.ch>
#include <fwin/Constant.ch>

#define LISTBOX_BASE    WM_USER

#define LB_ADDSTRING         ( LISTBOX_BASE +  1 )
#define LB_INSERTSTRING      ( LISTBOX_BASE +  2 )
#define LB_DELETESTRING      ( LISTBOX_BASE +  3 )
#define LB_RESETCONTENT      ( LISTBOX_BASE +  5 )
#define LB_SETSEL            ( LISTBOX_BASE +  6 )
#define LB_SETCURSEL         ( LISTBOX_BASE +  7 )
#define LB_GETSEL            ( LISTBOX_BASE +  8 )
#define LB_GETCURSEL         ( LISTBOX_BASE +  9 )
#define LB_GETCOUNT          ( LISTBOX_BASE + 12 )
#define LB_DIR               ( LISTBOX_BASE + 14 )
#define LB_GETSELCOUNT       ( LISTBOX_BASE + 17 )
#define LB_GETSELITEMS       ( LISTBOX_BASE + 18 )
#define LB_ERR                           -1
#define GWL_STYLE           (-16)

#define COLOR_WINDOW       5
#define COLOR_WINDOWTEXT   8

#define WM_DRAWITEM           43    // 0x2B
#define WM_MEASUREITEM        44    // 0x2C

static Selector := GetSelector()

function TListBox()
local obj:=Inherit(TControl())

	obj:ClassName	:= "FWIN_TLISTBOX"
	obj:aItems	:= {}
	obj:aBitmaps	:= {}
	obj:lOwnerDraw	:= .f.
	obj:nBmpHeight	:= NIL
	obj:nBmpWidth	:= NIL
	obj:cFileSpec	:= NIL
	obj:bDrawItem	:= NIL
/*
   CLASSDATA aProperties ;
      INIT { "aItems", "cTitle", "cVarName", "l3D", "nClrText",;
	     "nClrPane", "nAlign", "nTop", "nLeft",;
	     "nWidth", "nHeight", "Cargo" }
*/
	_recover_FWIN_TLISTBOX(obj)

return obj
***********
function _recover_FWIN_TLISTBOX(obj)

	obj:New		:= @fw_New()
	obj:ReDefine	:= @fw_ReDefine()

	//obj:cToChar	:= from TControl
	obj:cGenPrg	:= @fw_cGenPrg()
	obj:GetSel	:= {|self| self:SendMsg( HASH_LB_GETSEL ) + 1}
	obj:GetSelText	:= {|self| self:aItems[ self:GetPos() ] }
	obj:Initiate	:= @fw_Initiate()
	obj:LButtonUp	:= @fw_LButtonUp()
	obj:MouseMove	:= @fw_MouseMove()
	obj:GoTop	:= {|self| self:Select( 1 )}
	obj:GoBottom	:= {|self| self:Select( Len( self:aItems ) )}
	obj:Select	:= {|self, nItem| self:SendMsg( HASH_LB_SETCURSEL, nItem, 1 ),;
				 self:Change()}
	obj:Set		:= @fw_Set()
	obj:SetItems	:= {|self, aItems| self:Reset(), self:aItems := aItems,;
				    self:Default(),;
				    self:SendMsg( HASH_LB_SETCURSEL, 1 ),;
				    self:Change()}
	obj:SetSel	:= {|self, nItem, lOnOff| ; // Only for multiselection listboxes
				lOnOff := If( lOnOff == nil, .t., lOnOff ),;
				self:SendMsg( HASH_LB_SETSEL, If( lOnOff, 1, 0 ), nItem)}
	obj:Add		:= @fw_Add()
	obj:Modify	:= @fw_Modify()
	obj:Insert	:= @fw_Insert()
	obj:Del		:= @fw_Del()
	obj:GetItem	:= {|self, nItem| eval(Selector:LbxGetItem, self:hWnd, nItem )}
	obj:Len		:= {|self| eval(Selector:SendMessage, self:hWnd, HASH_LB_GETCOUNT )}
	obj:LostFocus	:= @fw_LostFocus()
	obj:Reset	:= {|self| Eval( self:bSetGet,;
				If( ValType( Eval( self:bSetGet ) ) == "N", 0, "" ) ),;
				self:aItems := {}, self:SendMsg( HASH_LB_RESETCONTENT )}
	obj:Change	:= @fw_Change()
	obj:FillMeasure	:= {|self, nPInfo| eval(Selector:LbxMeasure, nPInfo, self:nBmpHeight )}
	obj:GetSelCount	:= {|self| If( self:IsMultipleSel(), self:SendMsg( HASH_LB_GETSELCOUNT ), 0 )}
	obj:GetSelItems	:= {|self|  ;     // returns an array of numbers
				If( self:IsMultipleSel(), eval(Selector:LbxGetSelItems, self:hWnd ), 0 )}
	obj:SetSelItems	:= @fw_SetSelItems() // aItems is an array of numbers
	obj:DrawItem	:= @fw_DrawItem()
	obj:GetPos	:= ;             // it has to be a BLOCK
			{ | Self, nPos | nPos := self:SendMsg( HASH_LB_GETCURSEL );
				/*If( nPos == -1, 0, nPos + 1 )*/ }

	obj:IsMultipleSel:= {|self| lAnd( eval(Selector:GetWindowLong, self:hWnd, GWL_STYLE ),;
				       LBS_MULTIPLESEL )}
	obj:Default	:= @fw_Default()
	obj:VScroll	:= @fw_VScroll()
	obj:SetBitmaps	:= @fw_SetBitmaps()
	obj:Destroy	:= @fw_Destroy()
	obj:aSelections	:= @fw_aSelections()
	obj:SwapUp	:= @fw_SwapUp()
	obj:SwapDown	:= @fw_SwapDown()

return obj
********************

static function fw_New( self, nRow, nCol, bSetGet, aItems, nWidth, nHeight, bChange, ;
			oWnd, bValid, nClrFore, nClrBack, lPixel, lDesign,;
			bLDblClicked, oFont, cMsg, lUpdate, bWhen, acBitmaps,;
			bDrawItem, lMulti, lSort )


	DEFAULT nRow     := 0, nCol := 0,;
	   bSetGet  := { || nil },;
	   aItems   := {}, nWidth := 40, nHeight := 40,;
	   nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;
	   nClrBack := GetSysColor( COLOR_WINDOW ),;
	   lPixel   := .f., lDesign := .f., lUpdate := .f.,;
	   oWnd     := GetWndDefault(), lMulti := .f., lSort := .f.

	self:cCaption   = ""
	self:nTop       = nRow * If( lPixel, 1, LST_CHARPIX_H )		//14
	self:nLeft      = nCol * If( lPixel, 1, LST_CHARPIX_W )	  // 8
	self:nBottom    = self:nTop  + nHeight - 1
	self:nRight     = self:nLeft + nWidth - 1
	self:nWidth	= nWidth
	self:nHeight	= nHeight
	self:aItems     = aItems
	self:bSetGet    = bSetGet
	self:bChange    = bChange
	self:bLDblClick = bLDblClicked
	self:oWnd       = oWnd
	self:oFont      = oFont

	if acBitmaps != nil
		self:SetBitmaps( acBitmaps )
	else
		self:lOwnerDraw = .f.
	endif

	self:nStyle     = numOr( LBS_NOTIFY, WS_TABSTOP, LBS_DISABLENOSCROLL,;
		       LBS_USETABSTOPS, WS_CHILD, WS_VISIBLE, WS_BORDER,;
		       WS_VSCROLL, If( lDesign, WS_CLIPSIBLINGS, 0 ),;
		       If( self:lOwnerDraw, LBS_OWNERDRAWFIXED, 0 ),;
		       If( lMulti, LBS_MULTIPLESEL, 0 ),;
		       If( lSort, LBS_SORT, 0 ) )
	self:nId        = self:GetNewId()
	self:bValid     = bValid
	self:lDrag      = lDesign
	self:lCaptured  = .f.
	self:cMsg       = cMsg
	self:lUpdate    = lUpdate
	self:bWhen      = bWhen
	self:bDrawItem  = bDrawItem
	self:nClrFore	= nClrFore
	self:nClrBack	= nClrBack
	self:lSort	= lSort


	if ! Empty( oWnd:hWnd )
		eval(Selector:CreateListbox,self)
		self:Default()
		oWnd:AddControl( Self )
	else
		oWnd:DefControl( Self )
	endif

	self:SetColor( nClrFore, nClrBack )

	if lDesign
		self:CheckDots()
	endif

return Self

//----------------------------------------------------------------------------//

static function fw_ReDefine( self, nId, bSetGet, aItems, bChange, oWnd, nHelpId,;
		 acBitmaps, bValid, cFileSpec, nClrFore,;
		 nClrBack, bLDblClicked, cMsg, lUpdate, bWhen,;
		 bDrawItem )

   if nClrFore == nil
      nClrBack := GetSysColor( COLOR_WINDOW )
   endif

   DEFAULT aItems   := {},;
	   nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;
	   lUpdate  := .f.

   self:nId        = nId
   self:hWnd       = 0
   self:aItems     = aItems
   self:bSetGet    = bSetGet
   self:bChange    = bChange
   self:bLDblClick = bLDblClicked
   self:oWnd       = oWnd
   self:nHelpId    = nHelpId
   self:bValid     = bValid
   self:cFileSpec  = cFileSpec
   self:lDrag      = .f.
   self:lCaptured  = .f.
   self:cMsg       = cMsg
   self:lUpdate    = lUpdate
   self:bWhen      = bWhen
   self:bDrawItem  = bDrawItem

   if acBitmaps != nil
      self:SetBitmaps( acBitmaps )
   else
      self:lOwnerDraw = .f.
   endif

   self:SetColor( nClrFore, nClrBack )

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

static function fw_Set( self, cNewItem )

   local nAt := AScan( self:aItems,;
		       { | cItem | Upper( AllTrim( cItem ) ) == ;
				   Upper( AllTrim( cNewItem ) ) } )

   if nAt != 0
      self:Select( nAt )
   endif

return

//----------------------------------------------------------------------------//

static function fw_LButtonUp( self, nRow, nCol, nFlags )

   if self:lDrag
      self:Super:LButtonUp( nRow, nCol, nFlags )
      eval(Selector:SysRefresh)
      self:Refresh()
      return 0
   endif

return self:Super:LButtonUp( nRow, nCol, nFlags )

//----------------------------------------------------------------------------//

static function fw_LostFocus(self)

   local nAt := self:SendMsg( HASH_LB_GETCURSEL )

   self:Super:LostFocus()

   if nAt != 0
      if ValType( Eval( self:bSetGet ) ) == "N"
	 Eval( self:bSetGet, nAt  )
      else
	 if Len( self:aItems ) > 0
	    Eval( self:bSetGet, self:aItems[ nAt ] )
	 else
	    Eval( self:bSetGet, "" )
	 endif
      endif
   endif

return

//----------------------------------------------------------------------------//

static function fw_Add( self, cItem, nAt )

	DEFAULT nAt := Len( self:aItems )

	if nAt == Len( self:aItems )
		AAdd( self:aItems, cItem )
		self:SendMsg( HASH_LB_ADDSTRING, 0, cItem )
	else
		ASize( self:aItems, Len( self:aItems ) + 1 )
		AIns( self:aItems, nAt + 1 )
		self:aItems[ nAt + 1 ] = cItem
		self:SendMsg( HASH_LB_INSERTSTRING, nAt, cItem )
	endif

	self:SendMsg( HASH_LB_SETCURSEL, nAt )

return

//----------------------------------------------------------------------------//

static function fw_Modify( self, cItem, nAt )

   if nAt == nil
      nAt := self:SendMsg( HASH_LB_GETCURSEL )
   endif

   if nAt > 0
      self:aItems[ nAt ] = cItem
      self:SendMsg( HASH_LB_DELETESTRING, nAt )
      self:SendMsg( HASH_LB_INSERTSTRING, nAt, cItem )
      self:SendMsg( HASH_LB_SETCURSEL, nAt )
   endif

return

//----------------------------------------------------------------------------//

static function fw_Insert( self, cItem, nAt )

   if nAt == nil
      nAt := self:SendMsg( HASH_LB_GETCURSEL )
   endif

   if nAt > 0
      ASize( self:aItems, Len( self:aItems ) + 1 )
      AIns( self:aItems, nAt )
      self:aItems[ nAt ] = cItem
      self:SendMsg( HASH_LB_INSERTSTRING, nAt, cItem )
   endif

return

//----------------------------------------------------------------------------//

static function fw_Del( self, nAt )

   if nAt == nil
      nAt := self:SendMsg( HASH_LB_GETCURSEL )
   endif

   if nAt > 0
      ADel( self:aItems, nAt )
      ASize( self:aItems, Len( self:aItems ) - 1 )
      self:SendMsg( HASH_LB_DELETESTRING, nAt )
      self:SendMsg( HASH_LB_SETCURSEL, Min( nAt, Len( self:aItems ) )  )
   endif

return

//----------------------------------------------------------------------------//

static function fw_Change(self)

	if Len( self:aItems ) > 0                // Needed during drag and drop JRH
		if ValType( Eval( self:bSetGet ) ) == "N"
			Eval( self:bSetGet, self:SendMsg( HASH_LB_GETCURSEL ) )
		else
			Eval( self:bSetGet, self:aItems[ self:SendMsg( HASH_LB_GETCURSEL )] )
		endif

		if self:bChange != nil
			Eval( self:bChange, Self )
		endif
	endif

return

//----------------------------------------------------------------------------//

static function fw_Default(self)

local nAt
local cStart := Eval( self:bSetGet )
local aFiles

	DEFAULT cStart := ""

	if self:lSort
		ASort( self:aItems )
	endif

	if ! Empty( self:cFileSpec )
		aFiles = Directory( self:cFileSpec )
		for nAt = 1 to Len( aFiles )
			AAdd( self:aItems, Lower( aFiles[ nAt ][ 1 ] ) )
		next
		ASort( self:aItems )
	endif

	AEval( self:aItems,;
		{ | cItem, nAt | If( cItem == nil, self:aItems[ nAt ] := "", ),;
			       self:SendMsg( HASH_LB_ADDSTRING, 0,;
			       If( cItem == nil, "", cItem ) ) } )

	if ValType( cStart ) != "N"
		nAt = AScan( self:aItems, { | cItem | Upper( AllTrim( cItem ) ) == ;
					 Upper( AllTrim( cStart ) ) } )
	else
		nAt = cStart
	endif

	if nAt != 0
		self:SendMsg( HASH_LB_SETCURSEL, nAt )
	else
		self:SendMsg( HASH_LB_SETCURSEL, 1 )
	endif

	if self:oFont != nil
		self:SetFont( self:oFont )
	else
		self:SetFont( self:oWnd:oFont )
	endif

return

//----------------------------------------------------------------------------//

static function fw_MouseMove( self, nRow, nCol, nKeyFlags )

   local nResult := self:Super:MouseMove( nRow, nCol, nKeyFlags )

return If( self:lDrag, nResult, nil )    // We want standard behavior !!!

//----------------------------------------------------------------------------//

static function fw_cGenPrg(self)

   local cCode := ""
   local n

   cCode += CRLF + "   @ " + Str( self:nTop, 3 ) + ", " + Str( self:nLeft, 3 ) + ;
	    " LISTBOX oLbx ITEMS { "

   for n = 1 to Len( self:aItems )
      if n > 1
	 cCode += ", "
      endif
      cCode += '"' + self:aItems[ n ] + '"'
   next

   cCode += " } ;" + CRLF + ;
	    "      SIZE " + Str( self:nRight - self:nLeft + 1, 3 ) + ", " + ;
	    Str( self:nBottom - self:nTop + 1, 3 ) + " PIXEL OF oWnd" + CRLF

return cCode

//----------------------------------------------------------------------------//

static function fw_SetBitmaps( self, acBitmaps )

   local n

   self:lOwnerDraw = .t.

   if ! Empty( self:aBitmaps )
      for n = 1 to Len( self:aBitmaps )
	 eval(Selector:DeleteObject, self:aBitmaps[ n ] )
      next
      self:aBitmaps = {}
   endif

   if ! Empty( acBitmaps )
      self:aBitmaps = Array( Len( acBitmaps ) )
      for n = 1 to Len( acBitmaps )
	 if ValType( acBitmaps[ n ] ) == "C"
	    if File( acBitmaps[ n ] )
	       self:aBitmaps[ n ] = eval(Selector:ReadBitmap, 0, acBitmaps[ n ] )
	    else
	       self:aBitmaps[ n ] = eval(Selector:LoadBitmap, eval(Selector:GetResources), acBitmaps[ n ] )
	    endif
	 else
	    self:aBitmaps[ n ] = acBitmaps[ n ]
	 endif
      next
      //self:nBmpHeight = nBmpHeight( self:aBitmaps[ 1 ] )
      //self:nBmpWidth  = nBmpWidth( self:aBitmaps[ 1 ] )
   endif

return

//----------------------------------------------------------------------------//

static function fw_Destroy(self)

   local n

   if self:aBitmaps != nil
      for n = 1 to Len( self:aBitmaps )
	 eval(Selector:DeleteObject, self:aBitmaps[ n ] )
      next
   endif

return self:Super:Destroy()

//----------------------------------------------------------------------------//

static function fw_DrawItem( self, nIdCtl, nPStruct )

return eval(Selector:LbxDrawItem, nPStruct, self:aBitmaps, self:aItems, self:nBmpWidth, self:bDrawItem )

//----------------------------------------------------------------------------//

static function fw_aSelections(self)

  local nAt, nLen, aNums, aItems := {}

  if self:IsMultipleSel()

    aNums = self:GetSelItems()
    nLen  = Len( aNums )

    if nLen > 0
      ASize( aItems, nLen )
      for nAt := 1 TO nLen
	aItems[ nAt ] := self:GetItem( aNums[ nAt ] )
      next
    endif

  else
    nAt = self:SendMsg( HASH_LB_GETCURSEL, 0, 0 )
    if nAt > 0
      aItems = { self:GetItem( nAt ) }
    endif
  endif

return aItems

//----------------------------------------------------------------------------//

static function fw_SetSelItems( self, aItems )

   local n

   if self:IsMultipleSel()
      for n = 1 to Len( aItems )
	 self:SetSel( aItems[n] )                   // Note element of aItems not n JRH
      next
   endif

return

//----------------------------------------------------------------------------//

static function fw_SwapUp(self)

   local nAt, cItem

   if nAt == nil
      nAt := self:SendMsg( HASH_LB_GETCURSEL )
   endif

   if nAt > 1
      cItem := self:aItems[ nAt ]
      self:SendMsg( HASH_LB_DELETESTRING, nAt )
      self:SendMsg( HASH_LB_INSERTSTRING, nAt - 1, cItem )
      self:SendMsg( HASH_LB_SETCURSEL, nAt - 1 )
      self:aItems[ nAt ] = self:aItems[ nAt - 1 ]
      self:aItems[ nAt - 1 ] = cItem
      self:Change()
   endif

return

//----------------------------------------------------------------------------//

static function fw_SwapDown(self)

   local nAt, cItem

   if nAt == nil
      nAt := self:SendMsg( HASH_LB_GETCURSEL )
   endif

   if nAt > 0 .and. nAt < Len( self:aItems )
      cItem := self:aItems[ nAt ]
      self:SendMsg( HASH_LB_DELETESTRING, nAt )
      self:SendMsg( HASH_LB_INSERTSTRING, nAt+1, cItem )
      self:SendMsg( HASH_LB_SETCURSEL, nAt+1 )
      self:aItems[ nAt ]     = self:aItems[ nAt + 1 ]
      self:aItems[ nAt + 1 ] = cItem
      self:Change()
   endif

return

//----------------------------------------------------------------------------//
static function fw_Initiate(self, hDlg)
	self:Super:Initiate( hDlg )
	self:Default()
return
**********************
static function fw_VScroll(self)
	// Virtual function
return
