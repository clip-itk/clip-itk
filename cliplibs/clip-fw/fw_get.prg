/*   FiveWin likely classes					*/
/*   TGET							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/


#include <clip-gtk.ch>

#include <fwin/FiveWin.ch>
#include <fwin/Constant.ch>
#include <Set.ch>

#define ES_PASSWORD         32   // 0x020
#define GWL_STYLE          -16

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8
#define COLOR_BTNFACE       15

#define ES_CENTER            1

#define DM_GETDEFID  WM_USER

#define MB_ICONEXCLAMATION  48   // 0x0030

#define CW_USEDEFAULT    32768

#define EM_GETSEL    (WM_USER+0)
#define EM_SETSEL    (WM_USER+1)
#define EM_UNDO     (WM_USER+23)

static Selector := GetSelector()

function TGet()
local obj:=TControl()

	obj:classname	:= "FWIN_TGET"
	obj:oGet	:= NIL
	obj:bMin	:= NIL
	obj:bMax	:= NIL
	obj:nClrFocusText:= NIL
	obj:ClrFocusPane:= NIL
	obj:nClrDef	:= NIL
	obj:nPos	:= NIL
	obj:lReadOnly	:= .f.
	obj:lPassword	:= .f.
	obj:cError	:= NIL
	obj:hHeap 	:= 0  // Own heap for @ ..., ... GET
	_recover_FWIN_TGET(obj)
return obj
function _recover_FWIN_TGET(obj)

	obj:new		:= @fw_New()
	obj:reDefine	:= @fw_ReDefine()
	obj:assign	:= @fw_Assign() //INLINE self:oGet:Assign()
	obj:cToChar	:= @fw_cToChar() //INLINE Super:cToChar( "EDIT" )
	obj:copy	:= @fw_Copy()
	obj:create	:= @fw_Create()
	obj:cut		:= @fw_Cut()
	obj:default	:= @fw_Default()
	//obj:destroy	:= @fw_Destroy()
	obj:cGenPrg	:= @fw_cGenPrg()
	obj:getDlgCode	:= @fw_GetDlgCode()
	obj:gotFocus	:= @fw_GotFocus()
	obj:initiate	:= @fw_Initiate()
	obj:keyDown	:= @fw_KeyDown()
	obj:keyChar	:= @fw_KeyChar()
	obj:keyUp	:= @fw_KeyUp()
	obj:lButtonDown	:= @fw_LButtonDown()
	obj:lButtonUp	:= @fw_LButtonUp()
	obj:lostFocus	:= @fw_LostFocus()
	obj:mouseMove	:= @fw_MouseMove()
	obj:cText	:= @fw_cText()// cText ) SETGET
	obj:paste	:= @fw_Paste()
	obj:refresh	:= @fw_Refresh() //INLINE self:oGet:SetFocus(),;
			   //self:oGet:UpdateBuffer(),;
			   //self:DispText(),;
			   //self:SetPos( 0 )
	obj:dispText	:= @fw_DispText()
	obj:getSel	:= @fw_GetSel()
	obj:getSelPos	:= @fw_GetSelPos()// parameters by reference!!!!
	obj:getDelSel	:= @fw_GetDelSel()
	obj:editUpdate	:= @fw_EditUpdate()
	obj:hideSel	:= @fw_HideSel()// INLINE self:SetSel( -1, 0 )
	obj:lValid	:= @fw_lValid()
	obj:rButtonDown	:= @fw_RButtonDown()
	obj:Resize	:= @fw_Resize()
	obj:selectAll	:= @fw_SelectAll() //INLINE self:SetSel( 0, -1 )
	obj:selFile	:= @fw_SelFile()
	obj:setPos	:= @fw_SetPos()
	obj:setSel	:= @fw_SetSel()//( nStart, nEnd ) INLINE ;
		  //nStart := If( nStart == nil, 1, nStart ),;
		  //nEnd   := If( nEnd == nil, nStart, nEnd ),;
		  //SendMessage( self:hWnd, EM_SETSEL, 0,;
		  //nMakeLong( nStart - If( nStart > 0, 1, 0 ),;
		  //nEnd - If( nEnd > 0, 1, 0 ) ) ),;
		  //self:nPos := nStart
	obj:move	:= @fw_Move()
	obj:unDo	:= @fw_UnDo()// INLINE self:cText := self:oGet:Original
	obj:spinner	:= @fw_Spinner()
	obj:inc		:= @fw_Inc() //  OPERATOR "++"
	obj:dec		:= @fw_Dec() //  OPERATOR "--"
	obj:value	:= @fw_Value() //INLINE self:VarGet()
return obj
************
static function fw_New( self, nRow, nCol, bSGet, oWnd, nWidth, nHeight, cPict, bValid,;
	    nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
	    lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
	    lPassword, lNoBorder, nHelpId, lSpinner,;
	    bUp, bDown, bMin, bMax )

local cText := Space( 50 )

	DEFAULT nClrFore  := GetSysColor( COLOR_WINDOWTEXT ),;
		nClrBack  := GetSysColor( COLOR_WINDOW ),;
		oWnd      := GetWndDefault(),;
		nHeight   := If( oFont != nil, oFont:nHeight, 12 ),;
		lDesign   := .f., lPixel := .f., lUpdate := .f.,;
		lCenter   := .f., lRight := .f.,;
		lReadOnly := .f., lPassword := .f.,;
		lSpinner  := .f.,;
		nRow      := 0, nCol := 0, lNoBorder := .f.,;
		bSGet   := bSETGET( cText )

	self:cCaption = If( cPict == nil, ToString( Eval( bSGet ) ), ;
			Transform( Eval( bSGet ), cPict ) )

	if lSpinner
		nHeight := Min( 15, nHeight )
	endif

	self:oGet      = GetNew( ,, bSGet,, cPict )
	self:cPicture  = cPict
	self:oGet:_display := @fw_DispText()
	self:nTop     = nRow * If( lPixel, 1, GET_CHARPIX_H )	 //13
	self:nLeft    = nCol * If( lPixel, 1, GET_CHARPIX_W )	 // 8
	self:nBottom  = self:nTop + nHeight - 1
	self:nRight   = self:nLeft + If( nWidth == nil, Len( self:cCaption ) * GET_CHARPIX_W, ;
				       nWidth - 1 ) + If( lSpinner, 20, 0 )
	self:nWidth   = self:nRight - self:nLeft + 1
	self:nHeight  = self:nBottom - self:nTop + 1
	self:oWnd      = oWnd
	self:nStyle    = numOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP,;
		      ES_AUTOHSCROLL, WS_BORDER,;
		      If( lDesign, WS_CLIPSIBLINGS, 0 ),;
		      If( lSpinner, WS_VSCROLL, 0 ),;
		      If( lCenter .or. lRight, ES_MULTILINE, 0 ),;
		      If( lCenter, ES_CENTER, If( lRight, ES_RIGHT, ES_LEFT ) ) )
	self:nStyle    = If( lNoBorder, nAnd( self:nStyle, nNot( WS_BORDER ) ), self:nStyle )
	self:nId       = self:GetNewId()
	self:bSetGet   = bSGet
	self:bValid    = bValid
	self:lDrag     = lDesign
	self:lCaptured = .f.
	self:lPassword = lPassword
	if lPassword
		self:oGet:__flags += "Q"
	endif
	self:oFont     = oFont
	self:oCursor   = oCursor
	self:cMsg      = cMsg
	self:lUpdate   = lUpdate
	self:bWhen     = bWhen
	self:bChange   = bChanged
	self:nPos      = 1  // 0   14/Aug/98
	self:lReadOnly = lReadOnly
	self:lFocused  = .f.
	self:nHelpId   = nHelpId

	self:nClrDef := nClrBack

	self:oGet:SetFocus()
	//self:cCaption = self:oGet:Buffer
	self:oGet:KillFocus()

	self:Default()

	if ! Empty( oWnd:hWnd )
		self:Create( "EDIT" )
		oWnd:AddControl( Self )
	else
		oWnd:DefControl( Self )
	endif

	self:oGet:hWnd := self:hWnd

	self:SetColor( nClrFore, nClrBack )
	self:GetFont(GET_CHARPIX_W, GET_CHARPIX_H)

	if lDesign
		self:CheckDots()
	endif

	if lSpinner
		self:Spinner( bUp, bDown, bMin, bMax )
	endif

return Self
**************
static function fw_ReDefine( self, nId, bSetGet, oWnd, nHelpId, cPict, bValid, nClrFore,;
		 nClrBack, oFont, oCursor, cMsg, lUpdate, bWhen, bChanged,;
		 lReadOnly, lSpinner, bUp, bDown, bMin, bMax )

	DEFAULT oWnd     := GetWndDefault(),;
	   nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;
	   nClrBack := GetSysColor( COLOR_WINDOW ),;
	   lUpdate  := .f., lReadOnly := .f., lSpinner := .f.


	if Eval( bSetGet ) == nil
		Eval( bSetGet, Space( 30 ) )
	endif

	self:nId       = nId
	self:oWnd      = oWnd
	self:nHelpId   = nHelpId
	self:bSetGet   = bSetGet
	self:oGet      = GetNew( 20, 20, bSetGet,, cPict )
	//self:oGet:_display := @fw_DispText()
	self:bValid    = bValid
	self:lDrag     = .f.
	self:lCaptured = .f.
	self:lPassword = .f.
	self:oFont     = oFont
	self:oCursor   = oCursor
	self:cMsg      = cMsg
	self:lUpdate   = lUpdate
	self:bWhen     = bWhen
	self:bChange   = bChanged
	self:nPos      =  1  // 0   14/Aug/98
	self:lReadOnly = lReadOnly
	self:lFocused  = .f.

	self:nClrDef := nClrBack

	if lSpinner
		self:Spinner(bUp, bDown, bMin, bMax)
	endif

	oWnd:DefControl( Self )
	self:SetColor( nClrFore, nClrBack )

return Self
****************
static function fw_Create( self, cClsName )

local hHeap

	DEFAULT cClsName := self:ClassName, self:cCaption := "",;
	   self:nStyle := WS_OVERLAPPEDWINDOW,;
	   self:nId    := 0

	   //self:nTop   := 0, self:nLeft := 0, self:nBottom := 10, self:nRight := 10,;

	if self:oWnd != nil
		self:nStyle = numOR( self:nStyle, WS_CHILD )
	endif

	if self:nBottom != CW_USEDEFAULT
		self:hWnd = eval(Selector:MGetCreate, self, self:cCaption, self:nStyle, ;
			   self:nLeft, self:nTop, self:nWidth, ;
			   self:nHeight, ;
			   If( self:oWnd != nil, self:oWnd:oClient, nil ), ;
			   self:nId, @hHeap )

	else
		self:hWnd = eval(Selector:MGetCreate, self, self:cCaption, self:nStyle, ;
			   self:nLeft, self:nTop, self:nRight, self:nBottom, ;
			   If( self:oWnd != nil, self:oWnd:oClient, nil ), ;
			   self:nId, @hHeap )
	endif

	if self:hWnd == -1
		eval(Selector:WndCreateError, Self )
	else
		self:Link()
		if self:oFont != nil
			self:SetFont( self:oFont, GET_CHARPIX_W, GET_CHARPIX_H )
		endif
		self:hHeap = hHeap
	endif

return
****************
static function fw_GetDlgCode( self, nLastKey )

   // Needed to do non-modal editing on a browse
      if Len( self:oWnd:aControls ) == 1 .and. self:oWnd:ChildLevel( TWBrowse() ) != 0
	 return DLGC_WANTALLKEYS
      endif

return self:Super:GetDlgCode( nLastKey )
*****************
static function fw_Initiate( self, hDlg )

	self:Super:Initiate( hDlg )
	self:oGet:SetFocus()

	if lAnd( GetWindowLong( self:hWnd, GWL_STYLE ), ES_PASSWORD )
		self:lPassword = .t.
	endif

	if self:lPassword
		self:oGet:__flags += "Q"
	endif
	if self:lReadOnly
		self:Disable()
	endif

	self:DispText()
	self:oGet:KillFocus()

return
******************
//---------------------------------------------------------------------------//
// Actualiza texto y y posici¢n del cursor del EDIT en funci¢n del oGet.
// Updates the text and the EDIT cursor position depending the oGet

static function fw_EditUpdate(self)
/*
	if self:oGet:HasFocus
		self:DispText()
	endif

	self:SetPos( self:oGet:Pos )
*/
return
************
static function fw_cText( self, uVal )
	if PCount() == 1
		eval(Selector:SetText,self, uVal)
		self:Refresh()
	endif

return eval(Selector:GetWindowText, self:hWnd )
******************
static function fw_GetSel(self)
local nStart
local nEnd
	eval(Selector:SendMessage, self, EM_GETSEL, @nStart, @nEnd)

return If( nStart != nEnd, SubStr( self:cText, nStart + 1, nEnd - nStart ), "" )
******************
static function fw_GetSelPos( self, nStart, nEnd )
local nS, nE
	eval(Selector:SendMessage, self, EM_GETSEL , @nS, @nE)
	nStart := nS
	nEnd := nE
return
**************
static function fw_GetDelSel( self, nStart, nEnd )
	self:oGet:buffer = Left( self:oGet:buffer, Min( nEnd, nStart ) ) ;
		   + Right( self:oGet:buffer, ;
			    Len( self:oGet:buffer ) - Max( nEnd, nStart ) ) ;
		   + Space( Abs( nStart - nEnd ) )

	self:oGet:Assign()
	self:oGet:Reset()
	self:oGet:pos := Min( nStart, nEnd ) + 1
return
*****************
static function fw_MouseMove( self, nRow, nCol, nKeyFlags )
	if self:lDrag
		return self:Super:MouseMove( nRow, nCol, nKeyFlags )
	else
		self:oWnd:SetMsg( self:cMsg )        // Many thanks to HMP
		if self:oCursor != nil
			eval(Selector:SetCursor, self:oCursor:hCursor )
		else
			eval(Selector:CursorIBeam)
		endif
		self:CheckToolTip()
	endif

return      // We want standard Get behavior !!!
*************
static function fw_Copy(self)
local oClp

	DEFINE CLIPBOARD oClp OF Self ;
		FORMAT TEXT

	if oClp:Open()
		oClp:Clear()
		oClp:SetText( self:GetSel() )
		oClp:End()
	else
		MsgAlert( "The clipboard is not available now!" )
	endif

return
*************
static function fw_Default(self)

	if self:oFont != nil
		self:SetFont( self:oFont, GET_CHARPIX_W, GET_CHARPIX_H )
	else
		self:GetFont( GET_CHARPIX_W, GET_CHARPIX_H )
	endif
return
*****************
static function fw_Destroy(self)

   if self:hHeap != 0
      // LocalShrink( self:hHeap, 0 )
      self:hHeap = 0
   endif

return self:Super:Destroy()
*************
static function fw_cGenPrg(self)

   local cCode := ""

   cCode += CRLF + "   @ " + Str( self:nTop, 3 ) + ", " + Str( self:nLeft, 3 ) + ;
	    " GET oGet SIZE " + Str( self:nRight - self:nLeft + 1, 3 ) + ;
	    ", " + Str( self:nBottom - self:nTop + 1, 3 ) + ;
	    " PIXEL OF oWnd " + CRLF

return cCode
******************
static function fw_KeyDown( self, nKey, nFlags )

   local nHi, nLo, nPos

   self:nLastKey = nKey

   do case
      case nKey == VK_UP
	   self:oWnd:GoPrevCtrl( self:hWnd )
	   return 1   // avoid default behavior

      case nKey == VK_DOWN
	   self:oWnd:GoNextCtrl( self:hWnd )
	   return 1

      case nKey == VK_LEFT
	   if eval(Selector:GetKeyState, VK_CONTROL )
	      self:oGet:WordLeft()
	   else
	      self:oGet:Left()
	   endif
	   while .t.
	      eval(Selector:CallWindowProc, self:nOldProc, self:hWnd, WM_KEYDOWN, nKey, nFlags )
	      self:GetSelPos( @nLo, @nHi )
	      if nLo <= self:oGet:Pos - 1
		 EXIT
	      endif
	   end
	   self:oGet:Pos = nLo + 1
	   self:nPos = nLo + 1
	   return 0

      case nKey == VK_RIGHT
	   nPos = self:oGet:Pos
	   if eval(Selector:GetKeyState, VK_CONTROL )
	      self:oGet:wordRight()
	   else
	      self:oGet:right()
	   endif
	   if nPos <> self:oGet:Pos
	      while .t.
		 eval(Selector:CallWindowProc, self:nOldProc, self:hWnd, WM_KEYDOWN, nKey, nFlags )
		 self:GetSelPos( @nLo, @nHi )
		 if nHi + 1 = self:oGet:Pos .or. self:lPassword  // >= changed 12/12
		    EXIT
		 endif
	      end
	      self:oGet:Pos = nHi + 1
	      self:nPos     = nHi + 1
	   endif
	   return 0
					  // Many thanks to HMP
      case nKey == VK_INSERT .and. ! GetKeyState( VK_SHIFT ) ;
	   .and. ! GetKeyState( VK_CONTROL )   // to copy to the clipboard

	   Set( _SET_INSERT, ! Set( _SET_INSERT ) )
	   eval(Selector:DestroyCaret)
	   if Set( _SET_INSERT )
	      eval(Selector:CreateCaret, self:hWnd, 0, 6, self:nGetChrHeight() )
	   else
	      eval(Selector:CreateCaret, self:hWnd, 0, 2, self:nGetChrHeight() )
	   endif
	   eval(Selector:ShowCaret, self:hWnd )
	   return 0

      // EMW - Add a case to make sure Cut/Paste accelerators
      // recognize self:lReadOnly and self:bChange
      case ( nKey == VK_INSERT .and. GetKeyState( VK_SHIFT ) ) .or. ;
	   ( nKey == ASC("V") .and. GetKeyState( VK_CONTROL ) ) .or. ;
	   ( nKey == ASC('X') .and. GetKeyState( VK_CONTROL ) )
	  if self:lReadOnly
	     return 0
	  endif

	  eval(Selector:CallWindowProc, self:nOldProc, self:hWnd, WM_KEYDOWN, nKey, nFlags )

	  if self:bChange != nil
	     Eval( self:bChange, nKey, nFlags, Self )
	  endif
	  return 0

      case nKey == VK_HOME .or. nKey == VK_END

	   if eval(Selector:GetKeyState, VK_SHIFT )
	      eval(Selector:CallWindowProc, self:nOldProc, self:hWnd, WM_KEYDOWN, nKey, nFlags )

	      self:GetSelPos( @nLo, @nHi )
	      self:oGet:Pos = nLo + 1
	      self:nPos = nLo + 1
	   else
	       if nKey == VK_HOME
		  self:oGet:Home()
		  self:SetPos( self:oGet:Pos )
	       endif

	       if nKey == VK_END
		  self:oGet:End()
		  self:SetPos( self:oGet:Pos )
	       endif
	   endif
	   return 0

      case nKey == VK_DELETE .or. nKey == VK_BACK

	   if self:lReadOnly
	      return 0
	   endif

	   if self:lDrag
	      return self:Super:KeyDown( nKey, nFlags )
	   endif

	   self:GetSelPos( @nLo, @nHi )
	     // Deletes selection
	   if nHi != nLo
	      self:GetDelSel( nLo, nHi )
	      if eval(Selector:GetKeyState, VK_SHIFT )
		 eval(Selector:CallWindowProc, self:nOldProc, self:hWnd, WM_KEYDOWN, nKey, nFlags )
	      endif
	   else
	      if nKey == VK_DELETE
		 self:oGet:Delete()
	      else
		 self:oGet:BackSpace()
	      endif
	   endif
	   self:EditUpdate()
	   if self:bChange != nil
	      Eval( self:bChange, nKey, nFlags, Self )
	   endif
	   return 0
   endcase

return self:Super:KeyDown( nKey, nFlags )
*****************
static function fw_KeyChar( self, Event )
local nHi, nLo
local lAccept
local nDefButton
local nKey
local nState, nFlags

	if Event:event != GTK_KEY_PRESS
		return .f.
	endif

	nKey := Event:keyval
	nState := Event:state

	if nState == 1
		nState := VK_SHIFT
	elseif nState == 4
		nState := VK_CONTROL
	endif

	if self:lReadOnly
		if nKey == VK_ESCAPE
			self:oWnd:End()
		endif
		return .t.
	endif


	do case
	case nKey == VK_ESCAPE
		return .f.

	case nKey == VK_TAB .and. nState == VK_SHIFT
		if self:bChange != nil
			lAccept = Eval( self:bChange, nKey, nFlags, Self )
			if ValType( lAccept ) == "L" .and. lAccept
				self:oWnd:GoPrevCtrl( self:hWnd )
			endif
		else
			self:oWnd:GoPrevCtrl( self:hWnd )
		endif
		return .t.

	case nKey == VK_TAB .or. nKey == VK_RETURN
		if self:bChange != nil
			lAccept = Eval( self:bChange, nKey, nFlags, Self )
			if ValType( lAccept ) == "L" .and. lAccept
				self:oWnd:GoNextCtrl( self:hWnd )
			endif
		else
			self:oWnd:GoNextCtrl( self:hWnd )
		endif
		return .t.

	case nKey >= 32 .and. nKey < 256

		nLo := nHi := 0
		self:GetSelPos( @nLo, @nHi )

		// Delete selection
		if nHi != nLo
			self:GetDelSel( nLo, nHi )
			self:EditUpdate()
		endif

		if self:oGet:Type == "N" .and. ;
			( Chr( nKey ) == "." .or. Chr( nKey ) == "," )
			self:oGet:ToDecPos()
		else
			if self:bChange != nil
				lAccept = Eval( self:bChange, nKey, nFlags, Self )
				if ValType( lAccept ) == "L" .and. ! lAccept
					return .t.
				endif
			endif
			if Set( _SET_INSERT )             // many thanks to HMP
				self:oGet:Insert( Chr( nKey ) )
			else
				self:oGet:Overstrike( Chr(nKey) )
			end
		endif
		if self:oGet:Rejected()
			MessageBeep( -1 )
		else
			self:EditUpdate()
		endif
		if self:oGet:TypeOut
			if ! Set( _SET_CONFIRM )
				self:oWnd:nLastKey = VK_RETURN  // VK_DOWN 17/10/95
				self:oWnd:GoNextCtrl( self:hWnd )
			else
				MsgBeep()
			endif
		endif
		return .t.
	otherwise
		if self:oGet:setKey(nKey) != NIL
			eval(self:oGet:setKey(nKey), self:oGet, nKey)
			return .t.
		endif
	endcase


return .f.
********************

static function fw_lValid(self)
local lRet := .t.

	if self:oGet:BadDate
		Tone( 100, 3 )
		return .f.
	else
		if ValType( self:bValid ) == "B"
			lRet := Eval( self:bValid, Self  )
		endif
	endif

return lRet
**************
static function fw_LostFocus( self, hCtlFocus )

	self:Super:LostFocus( hCtlFocus )

	self:oGet:SetFocus()

	if ! self:oGet:BadDate .and. ! self:lReadOnly .and. ;
		( self:oGet:changed .or. self:oGet:unTransform() <> self:oGet:original )
		self:oGet:Assign()     // for adjust numbers
		self:oGet:UpdateBuffer()
	endif

	self:DispText()

	if ! self:oGet:BadDate
		self:oGet:KillFocus()
	else
		self:oGet:Pos = 1
		self:nPos = 1
		self:oGet:TypeOut = .f.
	endif

return
***************
static function fw_Paste( self, cText )

local oClp
local cTemp

   DEFINE CLIPBOARD oClp OF Self FORMAT TEXT

   if cText == nil
      if oClp:Open()
	 cText = oClp:GetText()
	 oClp:Close()
      else
	 MsgAlert( "The clipboard is not available!" )
      endif
   endif

   if ! Empty( cText )
      cTemp = self:GetText()
      do case
	 case ValType( cTemp ) == "C"
	      self:oGet:Buffer = SubStr( cTemp, 1, self:nPos - 1 ) + Trim( cText ) + ;
			SubStr( cTemp, self:nPos )

	 case ValType( cTemp ) == "N"
	      cTemp = ToString( cTemp )
	      self:oGet:Buffer = Val( SubStr( cTemp, 1, self:nPos - 1 ) + Trim( cText ) + ;
			     SubStr( cTemp, self:nPos ) )

	 case ValType( cTemp ) == "D"
	      cTemp = ToString( cTemp )
	      self:oGet:Buffer = CToD( SubStr( cTemp, 1, self:nPos - 1 ) + Trim( cText ) + ;
			      SubStr( cTemp, self:nPos ) )
      endcase

      self:DispText() // from buffer to screen

      // EMW - the text has been changed!
      if self:bChange != nil
	 Eval( self:bChange,,, Self )
      endif

   endif

return
********************************************
* redefined _display- function in Get-object
*
static function fw_DispText(oObj)
local oGet

	if "OGET"$oObj
		oGet := oObj:oGet
	else
		oGet := oObj
	endif
	if !("HWND" $ oGet)
		return
	endif
	if "Q" $ oGet:__flags .and. oGet:Type == "C"
		eval(Selector:SetGetText, oGet:hWnd, Replicate( "*", Len( Trim( oGet:buffer ) ) ), oGet:Pos )
	else
		eval(Selector:SetGetText, oGet:hWnd, oGet:buffer, oGet:Pos )
	endif

return
*****************
static function fw_Move( self, nTop, nLeft, nBottom, nRight, lRepaint )

   self:Super:Move( nTop, nLeft, nBottom, nRight, lRepaint )
   eval(Selector:MoveGet, self:hWnd, self:nRight - self:nLeft, self:nBottom - self:nTop )

return
****************
static function fw_GotFocus(self)

   if ! self:lDrag
      self:oGet:KillFocus()   // to properly initialize internal status
      self:oGet:SetFocus()
      self:DispText()
      self:oGet:Pos = self:nPos
      self:SetPos( self:nPos )
      eval(Selector:CallWindowProc, self:nOldProc, self:hWnd, WM_SETFOCUS )

      if Set( _SET_INSERT )
	 eval(Selector:DestroyCaret)
	 eval(Selector:CreateCaret, self:hWnd, 0, 6, self:nGetChrHeight() )
	 eval(Selector:ShowCaret, self:hWnd )
      endif
   else
      eval(Selector:HideCaret, self:hWnd )
   endif

   self:Super:GotFocus()

return 0
****************
static function fw_LButtonDown( self, nRow, nCol, nFlags )

   if self:lDrag
      return self:Super:LButtonDown( nRow, nCol, nFlags )
   else
      eval(Selector:CallWindowProc, self:nOldProc, self:hWnd, WM_LBUTTONDOWN, nFlags,;
		      nMakeLong( nCol, nRow ) )
      self:nPos = GetCaretPos()[ 1 ]
      return 1
   endif

return
*****************
static function fw_LButtonUp( self, nRow, nCol, nFlags )

   local nLo, nHi, cText

   if self:lDrag
      self:Super:LButtonUp( nRow, nCol, nFlags )
      eval(Selector:SysRefresh)
      self:Refresh()
      return 0
   else
      cText = self:GetText()
      If AllTrim( cText ) == "(   )"
	 self:nPos = 2
	 self:SetPos( self:nPos )
      elseif Empty( cText ) .or. cText == "  /  /" .or. ;
	 AllTrim( cText ) == "0" .or. ;
	 AllTrim( cText ) == "   -  -"
	 self:nPos = 1
	 self:SetPos( self:nPos )
      else
	 self:GetSelPos( @nLo, @nHi )
	 self:oGet:pos = If( self:nPos <= GetCaretPos()[ 1 ], nHi, nLo ) + 1
	 self:nPos = self:oGet:pos
      endif
   endif

return
*********************
static function fw_KeyUp( self, nVKey, nFlags )

   local nLo

   if ( nVKey == VK_INSERT .and. eval(Selector:GetKeyState, VK_SHIFT ) ) .or. ;
      ( nVKey == 86 .and. eval(Selector:GetKeyState, VK_CONTROL ) )
      nLo = Len( self:oGet:buffer )
      self:oGet:buffer = Pad( eval(Selector:GetWindowText, self:hWnd ), nLo )
      self:oGet:pos    = Min( nHiWord( self:SendMsg( EM_GETSEL ) ) + 1, nLo )
      self:EditUpdate()  // Many thanks to HMP
   elseif nVKey == VK_UP .or. nVKey == VK_DOWN
	 return 1  // We have not processed the key and we don't let
		   // the edit to do it
   endif

return
**********************
static function fw_RButtonDown( self, nRow, nCol, nFlags )

   local oMenu, oClp
   local nLo, nHi

   self:GetSelPos( @nLo, @nHi )

   if GetFocus() != self:hWnd
      self:SetFocus()
      eval(Selector:SysRefresh)                  // In case there is a VALID somewhere
      if eval(Selector:GetFocus) != self:hWnd
	 return
      endif
   endif

   DEFINE CLIPBOARD oClp OF Self FORMAT TEXT

   if self:bRClicked != nil
      return Eval( self:bRClicked, nRow, nCol, nFlags )
   endif

   MENU oMenu POPUP
      // EMW - Undo() should only be available if the text changed.
      //if self:lReadOnly
      // Use this ...
      if self:lReadOnly .or. self:GetText() == ToString( self:oGet:Original )
	 MENUITEM "&Undo" ACTION self:UnDo() disabled
      else
	 MENUITEM "&Undo" ACTION self:UnDo()
      endif

      SEPARATOR

      if self:lReadOnly .or. nLo == nHi
	 MENUITEM "Cu&t"  ACTION self:Cut() disabled
      else
	 MENUITEM "Cu&t"  ACTION self:Cut()
      endif

      if nLo != nHi
	 MENUITEM "&Copy" ACTION self:Copy()
      else
	 MENUITEM "&Copy" ACTION self:Copy() disabled
      endif

      if ! Empty( oClp:GetText() ) .and. !self:lReadOnly
	 MENUITEM "&Paste" ACTION self:Paste()
      else
	 MENUITEM "&Paste" ACTION self:Paste() DISABLED
      endif

      if self:lReadOnly .or. nLo == nHi
	 MENUITEM "&Delete" action nil disabled
      else
	 MENUITEM "&Delete" ACTION If( nHi != nLo,;
		( self:GetDelSel( nLo, nHi ), self:EditUpdate() ),)
      endif

      SEPARATOR
      MENUITEM "Select &All" ACTION self:SelectAll()
   ENDMENU

   ACTIVATE POPUP oMenu AT nRow - 60, nCol OF Self

return 0             // Message already processed
*******************
static function fw_Resize( self, nType, nWidth, nHeight )

   if self:lDrag       // a line remains on the surface
      self:Refresh()
   endif

return self:Super:ReSize( nType, nWidth, nHeight )
********************
static function fw_SelFile( self, cMask, cTitle )

   local cFileName := Eval( self:bSetGet )

   DEFAULT cFileName := "*.*",;
	   cMask := cFileName, cTitle := "Please select a file"

   cFileName = cGetFile( cMask, cTitle )

   if ! Empty( cFileName )
      self:VarPut( cFileName )
      self:Refresh()
   endif

return cFileName
******************
static function fw_SetPos( self, nStart, nEnd )

   DEFAULT nEnd := nStart

      /*
      self:SendMsg( EM_SETSEL, 0,;
		 int( nStart - If( nStart > 0, 1, 0 ),;
		 nEnd - If( nEnd > 0, 1, 0 ) ) )
      */
   self:nPos := nStart+1
   if self:lFocused
      self:oGet:Pos = nStart+1
   endif

return
*********************
static function fw_Cut(self)

   local nLo, nHi, cTemp

   if self:lReadOnly
      MsgAlert( "The get is read only!", "Can't cut" )
      return
   endif

   self:Copy()
   self:GetSelPos( @nLo, @nHi )

   if nHi != nLo
      self:GetDelSel( nLo, nHi )
   endif

   self:EditUpdate()
   cTemp = self:VarGet()

   do case
      case ValType( cTemp ) == "C"
	   Eval( self:bSetGet, self:GetText() )

      case ValType( cTemp ) == "N"
	   Eval( self:bSetGet, Val( self:GetText() ) )

      case ValType( cTemp ) == "D"
	   Eval( self:bSetGet, CToD( self:GetText() ) )
   endcase

   self:EditUpdate()

   // EMW - the text has been changed!
   if self:bChange != nil
      Eval( self:bChange,,, Self )
   endif

return
*****************
static function fw_Inc(self)

   LOCAL xValue

   if ! self:oGet:BadDate .and. ! self:lReadOnly
      self:oGet:Assign()
      self:oGet:UpdateBuffer()
   endif

   xValue := self:Value

   if Valtype( xValue ) $ "ND"

      if self:bMax != NIL .and. ( xValue + 1 ) > Eval( self:bMax )
	 MessageBeep()
      else
	 self:cText( xValue + 1 )
      endif

      if self:Value != xValue .and. self:bChange != nil
	 Eval( self:bChange,,, Self )
      endif

   endif

RETURN Self
********************
static function fw_Dec(self)

   LOCAL xValue

   if ! self:oGet:BadDate .and. ! self:lReadOnly
      self:oGet:Assign()
      self:oGet:UpdateBuffer()
   endif

   xValue := self:Value

   if Valtype( xValue ) $ "ND"

      if self:bMin != NIL .and. ( xValue - 1 ) < Eval( self:bMin )
	 MessageBeep()
      else
	 self:cText( xValue - 1 )
      endif

      if self:Value != xValue .and. self:bChange != nil
	 Eval( self:bChange,,, Self )
      endif

   endif

RETURN Self
****************
static function fw_Spinner( self, bUp, bDown, bMin, bMax )

   self:bMin := bMin
   self:bMax := bMax

   DEFINE SCROLLBAR self:oVScroll VERTICAL OF Self

   DEFAULT bUp   := {|| Self++ } ,;
	   bDown := {|| Self-- }

   self:oVScroll:bGoUp   := {|| If( GetFocus() != self:hWnd, self:SetFocus(), ),;
			     Eval( bUp ) }
   self:oVScroll:bGoDown := {|| If( GetFocus() != self:hWnd, self:SetFocus(), ),;
			     Eval( bDown ) }

return
*****************
static function fw_Assign(self)
return self:oGet:Assign()
**************
static function fw_cToChar(self)
return self:Super:cToChar( "EDIT" )
**************
static function fw_Refresh(self)
	self:oGet:SetFocus()
	self:oGet:UpdateBuffer()
	self:DispText()
	self:SetPos( 0 )
	//RefreshObj(self)
return
*************
static function fw_HideSel(self)
return self:SetSel( -1, 0 )
**************
static function fw_SelectAll(self)
return self:SetSel( 0, -1 )
**************
static function fw_SetSel( self, nStart, nEnd )
	nStart := If( nStart == nil, 1, nStart )
	nEnd   := If( nEnd == nil, nStart, nEnd )
	eval(Selector:SendMessage, self:hWnd, EM_SETSEL, 0,;
		nMakeLong( nStart - If( nStart > 0, 1, 0 ),;
		nEnd - If( nEnd > 0, 1, 0 ) ) )
	self:nPos := nStart
return
******************
static function fw_UnDo(self)
	self:cText := self:oGet:Original
return
**************
static function fw_Value(self)
return self:VarGet()
