#INCLUDE <fwin/FiveWin.ch>

#define LTGRAY_BRUSH       1
#define GRAY_BRUSH         2

#define WM_ERASEBKGND     20
#define WM_LBUTTONDBLCLK 515  // 0x203
#define WM_CTLCOLOR       25  // 0x19       // Don't remove Color Control
#define WM_MENUSELECT    287

#define GW_HWNDNEXT        2
#define GW_CHILD           5
#define GWW_INSTANCE      -6

#define SC_CLOSE       61536   // 0xF060
#define SC_NEXT        61504
#define SC_KEYMENU     61696   // 0xF100

#define WM_SYSCOMMAND    274   // 0x0112

#define DM_GETDEFID  WM_USER
#define DC_HASDEFID    21323   // 0x534B

// Controls mouse-resizing types in design mode
#define RES_NW             1
#define RES_N              2
#define RES_NE             3
#define RES_E              4
#define RES_SE             5
#define RES_S              6
#define RES_SW             7
#define RES_W              8

#define DLGC_DEFPUSHBUTTON    16     //0x0010
#define GWL_STYLE           (-16)

#define COLOR_WINDOW        5

static nMRow, nMCol
static nXGrid := 8, nYGrid := 8
static lDragging := .f.

static Selector := GetSelector()

function TControl()// FROM TWindow
local obj:=Inherit(TWindow())//map()

	obj:className	:= "FWIN_CONTROL"
	obj:bSetGet	:= NIL
	obj:bChange	:= NIL
	obj:bDragBegin	:= NIL
	obj:lCaptured	:= .f.
	obj:lDrag	:= .f.
	obj:lMouseDown	:= .f.
	obj:lUpdate 	:= .f.
	obj:l3DLook 	:= .f. // HIDDEN
	obj:nLastRow	:= NIL
	obj:nLastCol 	:= NIL
	obj:nMResize 	:= NIL //AS NUMBER // Controls resize with mouse in design mode
			       // automatic initialized to zero

	obj:nDlgCode	:= NIL // Default GetDlgCode() returned value
			       // by default nil. (Default behavior).

	obj:oJump	:= NIL // After VALID set focus to this control
			       // if defined
	obj:l97Look 	:= .f.
	obj:nInitID	:= 100
	obj:nPoint	:= NIL
	obj:aDots	:= NIL

	_recover_FWIN_CONTROL(obj)
return obj
function _recover_FWIN_CONTROL(obj)

	obj:nTop	:= @fw_nTop()
	obj:nLeft	:= @fw_nLeft()
	obj:_cVarName	:= @fw_cVarName()
	obj:adjBottom	:= @fw_AdjBottom()
	obj:adjClient	:= @fw_AdjClient()
	obj:adjLeft	:= @fw_AdjLeft()
	obj:adjRight	:= @fw_AdjRight()
	obj:adjTop	:= @fw_AdjTop()
	obj:change	:= @fw_Change() //VIRTUAL
	obj:changeFocus	:= @fw_ChangeFocus()
	obj:click	:= @fw_Click()
	obj:coorsUpdate	:= @fw_CoorsUpdate() //VIRTUAL
	obj:cToChar	:= @fw_cToChar()
	obj:init	:= @fw_Init() //VIRTUAL   // XBPP avoid calling TWindow New !!!
	obj:initiate	:= @fw_Initiate()
	obj:default	:= @fw_Default()
	obj:eraseBkGnd	:= @fw_EraseBkGnd()
	obj:FWLostFocus	:= @fw_FWLostFocus()
	obj:hideDots	:= @fw_HideDots()
	obj:fetDlgCode	:= @fw_GetDlgCode()
	obj:getNewId	:= @fw_GetNewId()
	obj:gotFocus	:= @fw_GotFocus()
	obj:inspect	:= @fw_Inspect()
	obj:_l3D	:= @fw__l3D()
	obj:l3D		:= @fw_l3D()
	obj:lostFocus	:= @fw_LostFocus()
	obj:move	:= @fw_Move()
	obj:mResize	:= @fw_MResize()// nType, nRow, nCol )  // Controls resize in design mode
	obj:end		:= @fw_End()
	obj:nAlign	:= @fw_nAlign()
	obj:_nWidth	:= @fw_nWidth()
	obj:_nHeight	:= @fw_nHeight()
	obj:handleEvent	:= @fw_HandleEvent()
	obj:keyChar	:= @fw_KeyChar()
	obj:keyDown	:= @fw_KeyDown()
	obj:keyUp	:= @fw_KeyUp()// VIRTUAL
	obj:setFocus	:= @fw_SetFocus()// METHOD _SetFocus()
	obj:checkDots	:= @fw_CheckDots()
	obj:colors	:= @fw_Colors()
	obj:dragBegin	:= @fw_DragBegin()
	obj:fillMeasure	:= @fw_FillMeasure()//        VIRTUAL
	obj:killFocus	:= @fw_KillFocus()
	obj:set3DLoook	:= @fw_Set3DLook()
	obj:varPut	:= @fw_VarPut()
	obj:varGet	:= @fw_VarGet()
	obj:lButtonDown	:= @fw_LButtonDown()
	obj:lButtonUp	:= @fw_LButtonUp()
	obj:mouseMove	:= @fw_MouseMove()
	obj:forWhen	:= @fw_ForWhen()
	obj:display	:= @fw_Display() //VIRTUAL
	obj:paint	:= @fw_Paint() //VIRTUAL
	obj:reDefine	:= @fw_Redefine()
	obj:sysCommand	:= @fw_SysCommand()
	obj:showDots	:= @fw_ShowDots()
return obj
**********
static function fw_AdjClient(self)
local hTop, hBottom, hLeft, hRight

	if self:oWnd:oTop != nil
		hTop = self:oWnd:oTop:hWnd
	endif

	if self:oWnd:oBar != nil
		hTop = self:oWnd:oBar:hWnd
	endif

	if self:oWnd:oBottom != nil
		hBottom = self:oWnd:oBottom:hWnd
	endif

	if self:oWnd:oMsgBar != nil
		hBottom = self:oWnd:oMsgBar:hWnd
	endif

	if self:oWnd:oLeft != nil
		hLeft = self:oWnd:oLeft:hWnd
	endif

	if self:oWnd:oRight != nil
		hRight = self:oWnd:oRight:hWnd
	endif

	eval(Selector:WndAdjClient, self:hWnd, hTop, hBottom, hLeft, hRight )

	if self:lDrag .and. eval(Selector:GetFocus) == self:hWnd
		self:ShowDots()
	endif

return
************
static function fw_AdjLeft(self)
local hTop, hBottom

	if self:oWnd:oTop != nil
		hTop = self:oWnd:oTop:hWnd
	endif

	if self:oWnd:oBar != nil
		hTop = self:oWnd:oBar:hWnd
	endif

	if self:oWnd:oBottom != nil
		hBottom = self:oWnd:oBottom:hWnd
	endif

	if self:oWnd:oMsgBar != nil
		hBottom = self:oWnd:oMsgBar:hWnd
	endif

	eval(Selector:WndAdjLeft, self:hWnd, hTop, hBottom )

	if self:lDrag .and. eval(Selector:GetFocus) == self:hWnd
		self:ShowDots()
	endif

return
**********
static function fw_AdjRight(self)
local hTop, hBottom

	if self:oWnd:oTop != nil
		hTop = self:oWnd:oTop:hWnd
	endif

	if self:oWnd:oBar != nil
		hTop = self:oWnd:oBar:hWnd
	endif

	if self:oWnd:oBottom != nil
		hBottom = self:oWnd:oBottom:hWnd
	endif

	if self:oWnd:oMsgBar != nil
		hBottom = self:oWnd:oMsgBar:hWnd
	endif

	eval(Selector:WndAdjRight, self:hWnd, hTop, hBottom )

	if self:lDrag .and. eval(Selector:GetFocus) == self:hWnd
		self:ShowDots()
	endif

return
***********
static function fw_cToChar(self,  cCtrlClass )
local n := eval(Selector:GetDlgBaseUnits)

	DEFAULT cCtrlClass := self:ClassName,;
		self:cCaption := "",;
		self:nId      := self:GetNewId(),;
		self:nStyle   := numOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP )

return cCtrl2Chr( Int( 2 * 8 * self:nTop    / nHiWord( n ) ),;
		  Int( 2 * 4 * self:nLeft   / nLoWord( n ) ),;
		  Int( 2 * 8 * self:nBottom / nHiWord( n ) ),;
		  Int( 2 * 4 * self:nRight  / nLoWord( n ) ),;
		  self:nId, self:nStyle, cCtrlClass, self:cCaption )
***********
static function fw_Initiate(self,  hDlg )

	DEFAULT self:lActive := .t., self:lDrag := .f., self:lCaptured := .f.,;
		self:lFocused := .f.

	if( ( self:hWnd := eval(Selector:GetDlgItem, hDlg, self:nId ) ) != 0 )

	If( self:lActive, self:Enable(), self:Disable() )
		self:Link()

		if self:oFont != nil
			self:SetFont( self:oFont )
		else
			self:GetFont()
		endif
	else
	#define NOVALID_CONTROLID   1
		Eval( ErrorBlock(), _FWGenError( NOVALID_CONTROLID, "No: " + ;
				      Str( self:nId, 6 ) ) )
	endif

return
************
static function fw_SetFocus(self)
local hCtrlNext

	if self:lWhen()
		eval(Selector:SetFocus, self:hWnd )
	else
		hCtrlNext = eval(Selector:GetWindow, self:hWnd, GW_HWNDNEXT )
		if eval(Selector:GetParent, hCtrlNext ) != self:oWnd:hWnd
			hCtrlNext = eval(Selector:GetWindow, self:oWnd:hWnd, GW_CHILD )
		endif
		eval(Selector:SetFocus, hCtrlNext )
	endif
return
**********
static function fw_Colors(self,  hDC )

	DEFAULT self:nClrText := eval(Selector:GetTextColor, hDC ),;
		self:nClrPane := eval(Selector:GetBkColor, hDC ),;
		self:oBrush   := TBrush():New(, self:nClrPane )

	eval(Selector:SetTextColor, hDC, self:nClrText )
	eval(Selector:SetBkColor, hDC, self:nClrPane )
return self:oBrush:hBrush
************
static function fw_Default(self)

	self:lDrag     = .f.
	self:lCaptured = .f.
return
************
static function fw_LButtonDown( self, nRow, nCol, nKeyFlags )

	self:oWnd:nLastKey = 1002  // fixes CANCEL clause. Thanks to Ron Pinkas!

	self:lMouseDown = .t.
	self:nLastRow   = nRow
	self:nLastCol   = nCol

	if self:lDrag
		self:HideDots()
		eval(Selector:CursorCatch)
		if ! self:lCaptured
			self:nPoint = nMakeLong(  nRow -= ( nRow % nYGrid ),;
			      nCol -= ( nCol % nXGrid ) )
			nMRow  = nRow
			nMCol  = nCol

			eval(Selector:CtrlDrawFocus, self:hWnd )
			self:Capture()
			self:lCaptured = .t.
		endif
		return 0
	else
		return self:Super:LButtonDown( nRow, nCol, nKeyFlags )
	endif
return
************
static function fw_LButtonUp( self, nRow, nCol, nKeyFlags )
local aPoint := { nRow, nCol }

	self:lMouseDown = .f.

	if lDragging
		lDragging = .f.
		eval(Selector:ReleaseCapture)
		aPoint = eval(Selector:ClientToScreen, self:hWnd, aPoint )
		eval(Selector:SendMessage, eval(Selector:WindowFromPoint, aPoint[ 2 ], aPoint[ 1 ] ),;
		   FM_DROPOVER, nKeyFlags, nMakeLong( nRow, nCol ) )
		return nil
	endif

	if self:lDrag
		if self:lCaptured
			eval(Selector:ReleaseCapture)
			self:lCaptured = .f.
			eval(Selector:CtrlDrawFocus, self:hWnd, ;
				( nRow := nLoWord( self:nPoint ) ) - nMRow,;
				( nCol := nHiWord( self:nPoint ) ) - nMCol, ;
				nRow, nCol, self:nMResize )
			aPoint[ 1 ] = nRow
			aPoint[ 2 ] = nCol
			if Empty( self:nMResize )
				self:Move( self:nTop + nRow - nMRow, self:nLeft + nCol - nMCol,,, .t. )
			else
				// The click is relative to the control
				// and we need it relative to the control container
				aPoint = eval(Selector:ClientToScreen, self:hWnd, aPoint )
				aPoint = eval(Selector:ScreenToClient, self:oWnd:hWnd, aPoint )
				nRow := aPoint[ 1 ] - aPoint[ 1 ] % nYGrid
				nCol := aPoint[ 2 ] - aPoint[ 2 ] % nXGrid
				do case
				case self:nMResize == RES_NW
					self:Move( nRow, nCol,;
					self:nWidth + ( self:nLeft - nCol ),;
					self:nHeight + ( self:nTop - nRow ), .t. )
				case self:nMResize == RES_N
					self:Move( nRow, self:nLeft, self:nWidth, self:nHeight + ( self:nTop - nRow ), .t. )
				case self:nMResize == RES_NE
					self:Move( nRow, self:nLeft, nCol - self:nLeft,;
					self:nHeight + ( self:nTop - nRow ), .t. )
				case self:nMResize == RES_E
					self:SetSize( nCol - self:nLeft, self:nHeight, .t. )
				case self:nMResize == RES_W
					self:Move( self:nTop, nCol,;
					self:nWidth + ( self:nLeft - nCol ),;
					self:nHeight, .t. )
				case self:nMResize == RES_SE
					self:SetSize( nCol - self:nLeft, nRow - self:nTop, .t. )
				case self:nMResize == RES_S
					self:SetSize( self:nWidth, nRow - self:nTop, .t. )
				case self:nMResize == RES_SW
					self:Move( self:nTop, nCol,;
					self:nWidth + ( self:nLeft - nCol ), nRow - self:nTop, .t. )
				endcase
				self:nPoint = nil
			endif
			if self:nAlign() != 0
				self:oWnd:ReSize()
			endif
			if self:aDots != nil
				self:ShowDots()
			endif
			self:nMResize = 0
		endif
		if eval(Selector:GetFocus) != self:hWnd
			eval(Selector:SetFocus, self:hWnd )
		endif
		return 0
	endif
return self:Super:LButtonUp( nRow, nCol, nKeyFlags )
*************
static function fw_MouseMove( self, nRow, nCol, nKeyFlags )
local nOldRow, nOldCol

   qout('mouse move for fw_control')

   DEFAULT self:lMouseDown := .f.

   if self:lDrag
      if self:lCaptured

	 if Empty( self:nMResize )
	    eval(Selector:CursorCatch)
	 endif

	 nOldRow := nLoWord( self:nPoint )
	 nOldCol := nHiWord( self:nPoint )

	 if Abs( nOldRow - nRow ) >= nXGrid .or. ;
	    Abs( nOldCol - nCol ) >= nYGrid

	    eval(Selector:CtrlDrawFocus, self:hWnd, ;
			   nOldRow - nMRow,;
			   nOldCol - nMCol,;
			   nOldRow,;
			   nOldCol,;
			   self:nMResize )
	    self:nPoint = nMakeLong(  nRow -= nRow % nYGrid,;
				 nCol -= nCol % nXGrid )
	    eval(Selector:CtrlDrawFocus, self:hWnd, ;
			   nRow - nMRow,;
			   nCol - nMCol,;
			   nRow,;
			   nCol, ;
			   self:nMResize )
	 endif

      else
	 if self:oCursor != nil
	    eval(Selector:SetCursor, self:oCursor:hCursor )
	 endif
      endif

      return 0
   else
      if self:lMouseDown .and. ;
	 ( Abs( nRow - self:nLastRow ) > 5 .or. Abs( nCol - self:nLastCol ) > 5 ) ;
	 .and. ! Empty( self:oDragCursor )
	 eval(Selector:SetCursor, self:oDragCursor:hCursor )
	 if ! lDragging
	    self:DragBegin( nRow, nCol, nKeyFlags )
	 endif
      else
	 return self:Super:MouseMove( nRow, nCol, nKeyFlags )
      endif
   endif

return 0
*************
static function fw_Move( self, nTop, nLeft, nWidth, nHeight, lRepaint )

   self:Super:Move( nTop, nLeft, nWidth, nHeight, lRepaint )

   DEFAULT self:lDrag := .f., self:lFocused := .f.

   if self:lDrag .and. self:aDots != nil .and. self:lFocused
      self:ShowDots()
   endif

return nil
***********
static function fw_End(self)

   local nAt := If( self:oWnd != nil .and. ! Empty( self:oWnd:aControls ),;
		AScan( self:oWnd:aControls, { | oCtrl | oCtrl:hWnd == Self:hWnd } ),;
		0 )

   if nAt != 0
      ADel( self:oWnd:aControls, nAt )
      ASize( self:oWnd:aControls, Len( self:oWnd:aControls ) - 1 )
   endif

   if self:oWnd != nil .and. self:oWnd:oCtlFocus == Self
      self:oWnd:oCtlFocus = nil
   endif

return self:Super:End()
************
static function fw_KeyChar( self, nKey, nFlags )

   local nDefValue, nDefButton, hDef

   do case
      case nKey == VK_TAB .and. eval(Selector:GetKeyState, VK_SHIFT )
	   self:oWnd:GoPrevCtrl( self:hWnd )
	   return 0    // We don't want API default behavior

      case nKey == VK_TAB
	   self:oWnd:GoNextCtrl( self:hWnd )
	   return 0    // We don't want API default behavior

      case nKey == VK_ESCAPE
	   self:oWnd:KeyChar( nKey, nFlags )
	   return 0

      case nKey == VK_RETURN
	   if ( nDefButton := nLoWord( eval(Selector:SendMessage, self:oWnd:hWnd,;
	       DM_GETDEFID ) ) ) != 0 .and. ;
	      ( hDef := eval(Selector:GetDlgItem, self:oWnd:hWnd, nDefButton ) ) != 0 ;
	      .and. nDefButton != self:nId .and. ;
	      lAnd( eval(Selector:GetWindowLong, hDef, GWL_STYLE ), BS_DEFPUSHBUTTON )
	      eval(Selector:SendMessage, hDef, WM_KEYDOWN, VK_RETURN )
	      return 0
	   end

   endcase

return self:Super:KeyChar( nKey, nFlags )
**************
static function fw_nTop( self, nNewTop )

   if PCount() > 0
      if ! Empty( self:hWnd )
	 eval(Selector:WndTop, self:hWnd, nNewTop )
      endif
      self:Super:nTop = nNewTop
   else
      if ! Empty( self:hWnd )
	 return eval(Selector:WndTop, self:hWnd )
      else
	 return self:Super:nTop
      endif
   endif

return nil
************
static function fw_nLeft( self, nNewLeft )

   if PCount() > 0
      if ! Empty( self:hWnd )
	 eval(Selector:WndLeft, self:hWnd, nNewLeft )
      endif
      self:Super:nLeft = nNewLeft
   else
      if ! Empty( self:hWnd )
	 return eval(Selector:WndLeft, self:hWnd )
      else
	 return self:Super:nLeft
      endif
   endif

return nil
************
static function fw_ForWhen(self)

   self:oWnd:AEvalWhen()
   self:lCaptured = .f.

   // keyboard navigation
   if self:oJump != nil
      eval(Selector:SetFocus, self:oJump:hWnd )
      self:oJump = nil
   elseif self:oWnd:nLastKey == VK_UP .or. ( self:oWnd:nLastKey == VK_TAB .and. ;
       eval(Selector:GetKeyState, VK_SHIFT ) )
      self:oWnd:GoPrevCtrl( self:hWnd )
   elseif self:oWnd:nLastKey == VK_DOWN .or. self:oWnd:nLastKey == VK_RETURN .or. ;
      self:oWnd:nLastKey == VK_TAB
      self:oWnd:GoNextCtrl( self:hWnd )
   else
      if Empty( GetFocus() )
	 eval(Selector:SetFocus, self:hWnd )
      endif
   endif

   self:oWnd:nLastKey = 0

return nil
**************
static function fw_KeyDown( self, nKey, nFlags )

   if self:lDrag
      do case
	 case nKey == VK_DELETE
	      if MsgYesNo( "Delete this control ?" )
		 self:End()
		 if Len( self:oWnd:aControls ) == 0
		    ASend( self:aDots, "Hide" )
		 endif
	      endif
      endcase
   else
      return self:Super:KeyDown( nKey, nFlags )
   endif

return nil
****************
static function fw_KillFocus( self, hCtlFocus )

   local nAt

   // CANCEL clause. To avoid checking VALID
   // We can not compare tasks here. They return different values!
   // So we use again GetParent()
   if ! Empty( hCtlFocus ) .and. self:bValid != nil .and. ;
      ( eval(Selector:GetParent, hCtlFocus ) == eval(Selector:GetParent, self:hWnd ) ) .and. ;
      ( nAt := eval(Selector:GetProp, hCtlFocus, "WP" ) ) > 0 .and. ;
      nAt <= Len( GetAllWin() ) .and. GetAllWin()[ nAt ]:lCancel .and. ;
      self:oWnd:nLastKey != VK_RETURN .and. self:oWnd:nLastKey != VK_TAB
      self:lValidating = .t.
      self:ForWhen()
      self:lValidating = .f.
      self:LostFocus()
      return nil
   endif

   // #ifndef __XPP__   // GetParent() is giving problems with 32 bits!
   if ( ! Empty( hCtlFocus ) .and. ;
      eval(Selector:GetParent, hCtlFocus ) == eval(Selector:GetParent, self:hWnd ) .or. ;
      ( self:oWnd:oBar != nil .and. ;
      self:oWnd:oBar:hWnd == eval(Selector:GetParent, hCtlFocus ) ) ) .and. ;
      ! self:oWnd:lValidating
	 eval(Selector:PostMessage, self:hWnd, FM_LOSTFOCUS )
   endif
   // #endif

return self:LostFocus( hCtlFocus )
*****************
static function fw_EraseBkGnd( self, hDC )

  if self:oBrush != nil
     eval(Selector:FillRect, hDC, eval(Selector:GetClientRect, self:hWnd ), self:oBrush:hBrush )
     return 1
  endif

return nil
************
static function fw_FWLostFocus(self)

   if ! self:oWnd:lValidating
	self:oWnd:lValidating = .t.
	if ! self:lValid()
	   eval(Selector:SetFocus, self:hWnd )
	else
	   self:ForWhen()
	endif
	self:oWnd:lValidating = .f.
   endif

return nil
**************
static function fw_GetDlgCode( self, nLastKey )

   if .not. self:oWnd:lValidating
      if nLastKey == VK_RETURN .or. nLastKey == VK_TAB
	 self:oWnd:nLastKey = nLastKey

      // don't do a else here with :nLastKey = 0
      // or WHEN does not work properly, as we pass here twice before
      // evaluating the WHEN
      endif
   endif

   if self:oWnd:oWnd == nil   // There is no folders !!!
      return self:nDlgCode    // standard GetDlgCode behavior (nil)
   else
      if ( self:oWnd:oWnd:ClassName() != "TFOLDER" .and. ;
	   self:oWnd:oWnd:ClassName() != "TPAGES" )
	 return self:nDlgCode // standard GetDlgCode behavior (nil)
      endif
   endif

return DLGC_WANTALLKEYS // It is the only way to have 100% control using Folders
******************
static function fw_GotFocus( self, hCtlLost )

   self:lFocused       = .t.
   self:oWnd:nResult   = Self  // old code pending to be oCtlFocus
   self:oWnd:oCtlFocus = Self
   self:oWnd:hCtlFocus = self:hWnd
   self:SetMsg( self:cMsg )

   if self:lDrag
      self:ShowDots()
   endif

   if self:bGotFocus != nil
      return Eval( self:bGotFocus, Self, hCtlLost )
   endif

return nil
***********
static function fw_SysCommand( self, nType, nLoWord, nHiWord )

   local oFolder, nItem
   local hCtrl

   do case
      case nType == SC_KEYMENU      // Alt+... control accelerator pressed
	   if ! Empty( oFolder := self:oWnd:oWnd ) .and. ;
	      ( Upper( oFolder:ClassName() ) == "TFOLDER" )
	      if ( nItem := oFolder:GetHotPos( nLoWord ) ) > 0
		 oFolder:SetOption( nItem )
		 return 0
	      else
		 if ( hCtrl := self:oWnd:GetHotPos( nLoWord, self:hWnd ) ) != 0
		    SetFocus( hCtrl )
		 endif
	      endif
	   endif
   endcase

return nil
***********
static function fw___HelpTopic(self)

   if Empty( self:nHelpId )
      if self:oWnd != nil
	 self:oWnd:HelpTopic()
      else
	 HelpIndex()
      endif
   else
      HelpPopup( self:nHelpId )
   endif

return nil
***********
static function fw_Inspect( self, cDataName )

   do case
      case cDataName == "nAlign"
	   return { "None", "Top", "Left", "Bottom", "Right", "Client" }

      otherwise
	   return self:Super:Inspect( cDataName )
   endcase

return nil
**********
static function fw_DragBegin( self, nRow, nCol, nKeyFlags )

   if ! lDragging
      lDragging = .t.
      eval(Selector:SetCapture, self:hWnd )
   endif

   if self:bDragBegin != nil
      Eval( self:bDragBegin, nRow, nCol, nKeyFlags, Self )
   endif

return nil
************
static function fw_CheckDots(self)

   local oDot1, oDot2, oDot3, oDot4, oDot5, oDot6, oDot7, oDot8
   local oSizeNWSE, oSizeNESW, oSizeNS, oSizeWE
   local oWndParent := self:oWnd

   if self:lDrag
      // Ajustamos el control al grid
      self:Move( int( self:nTop  / nYGrid ) * nYGrid,;
	      int( self:nLeft / nXGrid ) * nXGrid,;
	      int( ( self:nRight - self:nLeft + 1 ) / nXGrid ) * nXGrid,;
	      int( ( self:nBottom - self:nTop + 1 ) / nYGrid ) * nYGrid, .t. )
   endif


   if self:aDots != nil .and. self:aDots[ 1 ]:hWnd != 0
      return nil
   endif
/*
   DEFINE CURSOR oSizeNWSE SIZENWSE
   DEFINE CURSOR oSizeNESW SIZENESW
   DEFINE CURSOR oSizeNS   SIZENS
   DEFINE CURSOR oSizeWE   SIZEWE
  */
   DEFINE WINDOW oDot1 OF oWndParent;
      STYLE numOr( WS_CHILD, WS_CLIPSIBLINGS );
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNWSE

   DEFINE WINDOW oDot2 OF oWndParent;
      STYLE numOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNS

   DEFINE WINDOW oDot3 OF oWndParent;
      STYLE numOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNESW

   DEFINE WINDOW oDot4 OF oWndParent;
      STYLE numOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeWE

   DEFINE WINDOW oDot5 OF oWndParent ;
      STYLE numOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNWSE

   DEFINE WINDOW oDot6 OF oWndParent ;
      STYLE numOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNS

   DEFINE WINDOW oDot7 OF oWndParent ;
      STYLE numOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNESW

   DEFINE WINDOW oDot8 OF oWndParent ;
      STYLE numOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeWE

   self:aDots = { oDot1, oDot2, oDot3, oDot4, oDot5, oDot6, oDot7, oDot8 }

   ASend( self:aDots, "Hide()" )

   oDot1:bLClicked = { | nRow, nCol | self:HideDots(), oWndParent:oCtlFocus:MResize( RES_NW, nRow, nCol, oDot1 ) }
   oDot2:bLClicked = { | nRow, nCol | self:HideDots(), oWndParent:oCtlFocus:MResize( RES_N, nRow, nCol, oDot2 )  }
   oDot3:bLClicked = { | nRow, nCol | self:HideDots(), oWndParent:oCtlFocus:MResize( RES_NE, nRow, nCol, oDot3 ) }
   oDot4:bLClicked = { | nRow, nCol | self:HideDots(), oWndParent:oCtlFocus:MResize( RES_E, nRow, nCol, oDot4 )  }
   oDot5:bLClicked = { | nRow, nCol | self:HideDots(), oWndParent:oCtlFocus:MResize( RES_SE, nRow, nCol, oDot5 ) }
   oDot6:bLClicked = { | nRow, nCol | self:HideDots(), oWndParent:oCtlFocus:MResize( RES_S, nRow, nCol, oDot6 )  }
   oDot7:bLClicked = { | nRow, nCol | self:HideDots(), oWndParent:oCtlFocus:MResize( RES_SW, nRow, nCol, oDot7 ) }
   oDot8:bLClicked = { | nRow, nCol | self:HideDots(), oWndParent:oCtlFocus:MResize( RES_W, nRow, nCol, oDot8 )  }

return nil
*************
static function fw_ShowDots(self)

   local n

   if self:aDots != nil
      if GetParent( self:aDots[ 1 ]:hWnd  ) != self:oWnd:hWnd
	 ASend( self:aDots, "Hide()" )
	 self:aDots[ 1 ]:bLClicked = { | nRow, nCol | self:oWnd:oCtlFocus:MResize( RES_NW, nRow, nCol, self:aDots[ 1 ] ) }
	 self:aDots[ 2 ]:bLClicked = { | nRow, nCol | self:oWnd:oCtlFocus:MResize( RES_N, nRow, nCol, self:aDots[ 2 ] )  }
	 self:aDots[ 3 ]:bLClicked = { | nRow, nCol | self:oWnd:oCtlFocus:MResize( RES_NE, nRow, nCol, self:aDots[ 3 ] ) }
	 self:aDots[ 4 ]:bLClicked = { | nRow, nCol | self:oWnd:oCtlFocus:MResize( RES_E, nRow, nCol, self:aDots[ 4 ] )  }
	 self:aDots[ 5 ]:bLClicked = { | nRow, nCol | self:oWnd:oCtlFocus:MResize( RES_SE, nRow, nCol, self:aDots[ 5 ] ) }
	 self:aDots[ 6 ]:bLClicked = { | nRow, nCol | self:oWnd:oCtlFocus:MResize( RES_S, nRow, nCol, self:aDots[ 6 ] )  }
	 self:aDots[ 7 ]:bLClicked = { | nRow, nCol | self:oWnd:oCtlFocus:MResize( RES_SW, nRow, nCol, self:aDots[ 7 ] ) }
	 self:aDots[ 8 ]:bLClicked = { | nRow, nCol | self:oWnd:oCtlFocus:MResize( RES_W, nRow, nCol, self:aDots[ 8 ] )  }
	 AEval( self:aDots, { | o | o:oWnd := self:oWnd,;
			 SetParent( o:hWnd, self:oWnd:hWnd ) } )
      endif
      DotsAdjust( self:hWnd, self:aDots[ 1 ]:hWnd, self:aDots[ 2 ]:hWnd,;
			  self:aDots[ 3 ]:hWnd, self:aDots[ 4 ]:hWnd,;
			  self:aDots[ 5 ]:hWnd, self:aDots[ 6 ]:hWnd,;
			  self:aDots[ 7 ]:hWnd, self:aDots[ 8 ]:hWnd )
       ASend( self:aDots, "Show()" )
   endif

return nil
***********
static function fw_MResize( self, nType, nRow, nCol, oDot )

   local aPoint := { nRow + oDot:nHeight(), nCol + oDot:nWidth() }

   if oDot:oCursor != nil
      SetCursor( oDot:oCursor:hCursor )
   endif

   // The click is relative to the Dot Client
   // and we need it relative to the Control Client

   aPoint = ClientToScreen( oDot:hWnd, aPoint )
   aPoint = ScreenToClient( self:hWnd, aPoint )
   nRow = aPoint[ 1 ]
   nCol = aPoint[ 2 ]

   self:nPoint = nMakeLong( nRow -= nRow % nYGrid,;
		       nCol -= nCol % nXGrid )

   self:nLastRow := nMRow := nRow
   self:nLastCol := nMCol := nCol
   self:nMResize = nType

   CtrlDrawFocus( self:hWnd )
   self:lCaptured = .t.
   self:Capture()

return nil
**********
static function fw_nAlign( self, nNewAlign )

   if self:oWnd == nil
      return 0
   endif

   if PCount() > 0  // SET action
      do case
	 case self:oWnd:oTop == Self .and. nNewAlign != 2
	      self:oWnd:oTop = nil

	 case self:oWnd:oLeft == Self .and. nNewAlign != 3
	      self:oWnd:oLeft = nil

	 case self:oWnd:oBottom == Self .and. nNewAlign != 4
	      self:oWnd:oBottom = nil

	 case self:oWnd:oRight == Self .and. nNewAlign != 5
	      self:oWnd:oRight = nil

	 case self:oWnd:oClient == Self .and. nNewAlign != 6
	      self:oWnd:oClient = nil
      endcase

      do case
	 case nNewAlign == 2
	      self:oWnd:oTop = Self

	 case nNewAlign == 3
	      self:oWnd:oLeft = Self

	 case nNewAlign == 4
	      self:oWnd:oBottom = Self

	 case nNewAlign == 5
	      self:oWnd:oRight = Self

	 case nNewAlign == 6
	      self:oWnd:oClient = Self
      endcase
      self:oWnd:ReSize()
   else       // GET action
      do case
	 case self:oWnd:oTop == Self
	      return 2

	 case self:oWnd:oLeft == Self
	      return 3

	 case self:oWnd:oBottom == Self
	      return 4

	 case self:oWnd:oRight == Self
	      return 5

	 case self:oWnd:oClient == Self
	      return 6

	 otherwise
	      return 1
      endcase
   endif

return nil
**************
function SetGridSize( nWidth, nHeight )

   nXGrid = nWidth
   nYGrid = nHeight

return nil
***************
function GetGridSize()

return { nXGrid, nYGrid }
**************
static function fw_Redefine( self, nId, oWnd )

   self:nId  = nId
   self:oWnd = oWnd

   self:Register()

   if oWnd != nil
      oWnd:DefControl( Self )
   endif

return nil
**************
static function fw_VarPut( self, uVal )
	If ValType( self:bSetGet ) == "B"
		Eval( self:bSetGet, uVal )
	endif
return
*************
static function fw_VarGet(self)
	If ValType( self:bSetGet ) == "B"
		Eval( self:bSetGet )
	endif
return
************
static function fw_cVarName( self, cNewVarName )
	If ! self:lDrag .and. ! self:oWnd:lDesign
		eval(Selector:OSend, self:oWnd, "_" + cNewVarName, Self )
	endif
	self:Super:cVarName := cNewVarName
return
************
static function fw_AdjBottom(self)
	eval(Selector:WndAdjBottom, self:hWnd )
	If self:lDrag .and. GetFocus() == self:hWnd
		self:ShowDots()
	endif
return
************
static function fw_AdjTop(self)
	eval(Selector:WndAdjTop, self:hWnd )
	If self:lDrag .and. GetFocus() == self:hWnd
		self:ShowDots()
	endif
return
*************
static function fw_ChangeFocus(self)
return eval(Selector:PostMessage, self:hWnd, HASH_FM_CHANGEFOCUS )
*************
static function fw_Click(self)
return self:oWnd:AEvalWhen()
*************
static function fw_HideDots(self)
	If ! Empty( self:aDots )
		ASend( self:aDots, "Hide()" )
		SysRefresh()
	endif
return
************
static function fw_GetNewId(self)
	If self:nInitId == nil
		self:nInitId := 100
	endif
	++self:nInitId
return self:nInitId
************
static function fw__l3D( self, lOnOff )
	If self:l3DLook := lOnOff
		self:Set3DLook()
	endif
return
**************
static function fw_l3D(self)
return self:l3DLook
************
static function fw_LostFocus( self, hWndGetFocus )
	self:SetMsg()
	self:Super:LostFocus( hWndGetFocus )
return
***********
static function fw_nWidth( self, nNewWidth )
	If ! Empty( self:hWnd )
		eval(Selector:WndWidth, self:hWnd, nNewWidth )
	endif
return
***********
static function fw_nHeight( self, nNewHeight )
	If ! Empty( self:hWnd )
		eval(Selector:WndHeight, self:hWnd, nNewHeight )
	endif
	If self:lDrag
		self:ShowDots()
	endif
return
**********
static function fw_Set3DLook(self)
return Ctl3DLook( self:hWnd )
**********
static function fw_Change() //VIRTUAL
return
**********
static function fw_CoorsUpdate() //VIRTUAL
return
**********
static function fw_Init() //VIRTUAL   // XBPP avoid calling TWindow New !!!
return
**********
static function fw_KeyUp()// VIRTUAL
return
**********
static function fw_FillMeasure()//        VIRTUAL
return
**********
static function fw_Display() //VIRTUAL
return
**********
static function fw_Paint() //VIRTUAL
return
**********
static function fw_HandleEvent( self, oEvent, nWParam, nLParam )
local nMsg
	nMsg := oEvent:event
	do case
	case nMsg == FM_CLICK
		return self:Click()

	case nMsg == WM_CTLCOLOR
		return self:CtlColor( nLoWord( nLParam ), nWParam )

	case nMsg == WM_KILLFOCUS
		return self:KillFocus( nWParam )

	case nMsg == WM_PAINT
		return self:Display()

	case nMsg == FM_CHANGE
		return self:Change()

	case nMsg == FM_COLOR
		return self:Colors( nWParam )

	case nMsg == FM_LOSTFOCUS
		return self:FWLostFocus( nWParam )

	case nMsg == WM_SYSCOMMAND
		return self:SysCommand( nWParam, nLoWord( nLParam ), nHiWord( nLParam ) )
	endcase

return self:Super:HandleEvent( oEvent, nWParam, nLParam )

