/*   FiveWin likely classes					*/
/*   TDialog							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#INCLUDE <fwin/FiveWin.ch>
#include <fwin/constant.ch>

#define LTGRAY_BRUSH     1
#define GRAY_BRUSH       2

#define WM_CTLCOLOR     25  // 0x19       // Don't remove Color Control
#define WM_ERASEBKGND   20  // 0x0014     // or controls will not shown
					  // colors !!!
#define WM_GETFONT      49  // 0x0031
#define WM_DRAWITEM     43  // 0x002B
#define WM_MEASUREITEM  44  // 0x002C
#define WM_SETFONT      48
#define WM_SETICON     128
#define WM_NCPAINT     133    // 0x085

#define CBN_SELCHANGE      1

#define GWL_STYLE        -16
#define GW_CHILD           5
#define GW_HWNDNEXT        2

#define COLOR_BTNFACE     15

#define SC_HELP        61824
#define FN_ZIP         15001

static Selector := GetSelector()

function TDialog()
local obj:=Inherit(TWindow())

	obj:classname	:= "FWIN_TDIALOG"
	obj:cResName	:= NIL
	obj:cResData	:= NIL
	obj:hResources	:= NIL
	obj:lCentered	:= .f.
	obj:lModal	:= .f.
	obj:lModify	:= .f.
	obj:bStart	:= NIL
	obj:lHelpIcon	:= .f.  // Windows 95 help icon pressed
	_recover_FWIN_TDIALOG(obj)
return obj
**********
function _recover_FWIN_TDIALOG(obj)
	obj:new		:= @fw_New()
	obj:define	:= @fw_Define()
	obj:activate	:= @fw_Activate()
	obj:adjTop	:= @fw_AdjTop()
	obj:changeFocus	:= @fw_ChangeFocus()
	//obj:close	:= @fw_Close()
	obj:command	:= @fw_Command()
	obj:create	:= @fw_Create()
	obj:cToChar	:= @fw_cToChar()
	obj:defControl	:= @fw_DefControl()
	//obj:destroy	:= @fw_Destroy()
	obj:display	:= @fw_Display()
	obj:end		:= @fw_End()
	obj:eraseBkGnd	:= @fw_EraseBkGnd()
	obj:getHotPos	:= @fw_GetHotPos()
	obj:getItem	:= @fw_GetItem()
	obj:gotFocus	:= @fw_GotFocus()
	obj:handleEvent	:= @fw_HandleEvent()
	obj:help	:= @fw_Help()
	obj:initiate	:= @fw_Initiate()
	obj:keyChar	:= @fw_KeyChar()
	obj:lostFocus	:= @fw_LostFocus()
	obj:mouseMove	:= @fw_MouseMove()
	obj:queryEndSession := @fw_QueryEndSession()
	obj:setControl	:= @fw_SetControl()
	obj:setFont	:= @fw_SetFont()
	obj:sysCommand	:= @fw_SysCommand()
	obj:vbxFireEvent:= @fw_VbxFireEvent()
return obj
**********
static function fw_New(self, nTop, nLeft, nBottom, nRight, cCaption, cResName, hResources,;
			     lVbx, nStyle, nClrText, nClrBack, oBrush, oWnd, lPixels,;
			     oIco, oFont, nHelpId, nWidth, nHeight )

	FWInitDriver()

	DEFAULT lVbx := .f., nStyle := numOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU ), ;
		nClrText := CLR_BLACK, nClrBack := GetSysColor( COLOR_BTNFACE ), ;
		lPixels := .f., nTop := 0, nLeft := 0, nBottom := 10, nRight := 40, ;
		nWidth := 0, nHeight := 0

	if nWidth != 0 .or. nHeight != 0
		lPixels = .t.
		nBottom = nHeight
		nRight  = nWidth
	endif

	self:aControls  = {}
	self:cResName   = cResName
	self:cCaption   = cCaption
	self:hResources = hResources
	self:lModify    = .t.
	self:lVbx       = lVbx
	self:lVisible   = .f.
	self:nResult    = 0
	self:nStyle     = nStyle
	self:oWnd       = oWnd
	self:oIcon      = oIco
	self:oFont      = oFont
	self:nLastKey   = 0
	self:nHelpId    = nHelpId
	self:lHelpIcon  = .f.
	self:nClrBack   = nClrBack
	self:nClrText   = nClrText


	if lPixels  // New PIXELS Clausule
		self:nTop       = nTop
		self:nLeft      = nLeft
		self:nBottom    = nBottom
		self:nRight     = nRight
	else
		// Compatibility
		self:nTop    := int( nTop    * DLG_CHARPIX_H )
		self:nLeft   := int( nLeft   * DLG_CHARPIX_W )
		self:nBottom := int( nBottom * DLG_CHARPIX_H  )
		self:nRight  := int( nRight  * DLG_CHARPIX_W  )
	endif
	self:nWidth := self:nRight - self:nLeft + 1
	self:nHeight := self:nBottom - self:nTop + 1
	/* not used
	if lVbx
		if ! VbxInit( eval(Selector:GetInstance), "" )
			MsgAlert( "VBX support not available" )
		endif
	endif
	*/

	//self:Register( numOr( CS_VREDRAW, CS_HREDRAW ) )

	self:create()
	self:SetColor( nClrText, nClrBack, oBrush )
	//self:initiate(, self:handle)

	SetWndDefault( Self )          //  Set Default DEFINEd Window
return self
**********
static function fw_Define(self )
return self
**********
static function fw_Activate(self, bLClicked, bMoved, bPainted, lCentered, ;
		 bValid, lModal, bInit, bRClicked, bWhen )

static nDlgCount := 0

local hActiveWnd, hWnd, bDlgProc

	DEFAULT lCentered := .f., lModal := .t., self:hWnd := -1

	self:nLastKey = 0

	++nDlgCount

	hActiveWnd = If( self:oWnd != nil, self:oWnd:hWnd,;
			If( nDlgCount > 1 , eval(Selector:GetActiveWindow,self), eval(Selector:GetWndApp) ) )
	self:lCentered   = lCentered
	self:lModal      = lModal
	self:bLClicked   = bLClicked
	self:bRClicked   = bRClicked
	self:bWhen       = bWhen
	self:bValid      = bValid
	self:bInit       = bInit
	self:bPainted    = bPainted
	self:bMoved      = bMoved
	self:nResult     = nil
	self:lValidating = .f.
	self:lVisible    = .t.

	if self:bWhen != nil
		if ! Eval( self:bWhen, Self )
			self:nResult  = IDCANCEL
			self:lVisible = .f.
			return nil             // <<---------- Warning: Exiting!
		endif
	endif

	self:AEvalWhen()

	if lModal
		 self:nResult = if( ! Empty( self:cResName ),;
		      eval(Selector:DialogBox, self:hResources, self:cResName,;
				      hActiveWnd, Self ),;
		      eval(Selector:DialogBoxIndirect, eval(Selector:GetInstance),;
					 If( ! Empty( self:cResData ), self:cResData, self:cToChar( hActiveWnd ) ),;
					 hActiveWnd, Self ) )
		if self:nResult == -1
			eval(Selector:CreateDlgError, Self )
		endif

	else
		if ( Len( self:aControls ) > 0 .and. eval(Selector:CanRegDialog) ) .or. ;
			Len( self:aControls ) == 0

			self:hWnd = if( ! Empty( self:cResName ),;
		       eval(Selector:CreateDlg, self:hResources, self:cResName,;
				  hActiveWnd, Self ),;
		       eval(Selector:CreateDlgIndirect, eval(Selector:GetInstance), self:cToChar( hActiveWnd ),;
				  hActiveWnd, Self ) )

			if self:hWnd == -1
				eval(Selector:CreateDlgError, Self )
			endif

			if Len( self:aControls ) > 0 .and. ! eval(Selector:RegDialog, self:hWnd )
				self:SendMsg( WM_CLOSE )
				MsgAlert( "Not possible to create more non-modal Dialogs" )
			endif

			eval(Selector:ShowWindow, self:hWnd )
		else
			MsgAlert( "Not possible to create more non-modal Dialogs" )
		endif
	endif
	nDlgCount--

	if self:lModal
		self:lVisible = .f.
	endif

return
**********
static function fw_create(self)
	eval(Selector:CreateDlgBox,self)
return
**********
static function fw_AdjTop(self)
	eval(Selector:WndAdjTop, self:hWnd )
return
**********
static function fw_ChangeFocus(self)
return eval(Selector:PostMessage, self:hWnd, HASH_FM_CHANGEFOCUS )
**********
/*
static function fw_Close()
return
*/
**********
static function fw_Command()
return
**********
static function fw_cToChar()
return
**********
static function fw_DefControl()
return
**********
static function fw_Destroy() //INLINE Super:Destroy(), If( ! self:lModal, .t., nil )
return
**********
static function fw_Display(self)
	/*
	self:BeginPaint()
	self:Paint()
	self:EndPaint()
	*/
	If self:bStart != nil
		eval( self:bStart, self)
	endif
return .f.
**********
static function fw_End(self, nResult)
	DEFAULT nResult := 2              // Cancel

	if ! self:lModal
		eval(Selector:PostMessage, self, 'delete-event', nResult )
	else
		if ValType( self:bValid ) == "B"
			if ! Eval( self:bValid, Self )
				return .f.
			endif

		endif
		self:nResult = nResult
		eval(Selector:EndDialog, self, nResult )
	endif

return .t.
**********
static function fw_EraseBkGnd()
return
**********
static function fw_GetHotPos()
return
**********
static function fw_GetItem(self, nId )
return eval(Selector:GetDlgItem, self:hWnd, nId )
**********
static function fw_GotFocus(self)
	self:lFocused := .t.
	If self:bGotFocus != nil
		return Eval( self:bGotFocus )
	endif
return
**********
static function fw_HandleEvent(self, Event)
local nMsg, nWParam, nLParam
	nMsg := Event
	do case
	case nMsg == WM_INITDIALOG
		self:Initiate( nWParam, nLParam )
		return .t.

	case nMsg == WM_PAINT
		self:Display()
		return .t.

	otherwise
		return .f.
	endcase
return .f.
**********
static function fw_Help()
return
**********
static function fw_Initiate(self, hWndFocus, hWnd)
local lFocus := .t., lResult

	if hWnd != nil
		self:hWnd = hWnd
	endif

	self:Link()

	if self:lVbx .and. ! Empty( self:cResName )
		if ! eval(Selector:VbxInitDialog, self:hWnd, GetResources(), self:cResName )
			MsgAlert( "Error on VBX's initialization" )
		endif
	endif

	if self:oFont == nil
		self:GetFont()
	endif
	self:SetFont( self:oFont )

	// We can resist to use something more, more faster !!! <g>
	// AEval( self:aControls, { | oCtrl | oCtrl:Initiate( self:hWnd ) } )
	//ASend( self:aControls, "INITIATE", self:hWnd )

	if self:lCentered
		eval(Selector:WndCenter, self:hWnd )
	else
		if Empty( self:cResName )
			self:Move( self:nTop, self:nLeft, self:nWidth, self:nHeight )
		endif
	endif

	if self:cCaption != nil
		eval(Selector:SetWindowText, self:hWnd, self:cCaption )
	endif

	if self:bInit != nil
		lResult = Eval( self:bInit, Self )
		if ValType( lResult ) == "L" .and. ! lResult
			lFocus = .f.
		endif
	endif

	/*
	self:Help95()  // activates the help icon on the caption

	if self:oIcon != nil
		SendMessage( self:hWnd, WM_SETICON, 0, self:oIcon:hIcon )
	endif
	*/
return .t.
**********
static function fw_KeyChar()
return
**********
static function fw_LostFocus(self)
	self:lFocused := .f.
	If self:bLostFocus != nil
		return Eval( self:bLostFocus )
	endif
return
**********
static function fw_MouseMove()
return
**********
static function fw_QueryEndSession(self)
return ! self:End()
**********
static function fw_SetControl(self, oCtrl )
	self:oClient := oCtrl
	self:ReSize()
return
**********
static function fw_SetFont()
return
**********
static function fw_SysCommand()
return
**********
static function fw_VbxFireEvent(self, pEventInfo )
return eval(Selector:VBXEvent, pEventInfo )

