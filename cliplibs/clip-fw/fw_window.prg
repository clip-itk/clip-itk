/*   FiveWin likely classes					*/
/*   TWindow							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <clip-gtk.ch>
#include <fwin/FiveWin.ch>
#include <fwin/constant.ch>
#include <fwin/sysMetrics.ch>

#define MAXCOLOR	65535
#define SW_NORMAL              1
#define SW_MAXIMIZE            3
#define SW_MINIMIZE            6
#define SW_RESTORE             9

#define WM_SYSCOMMAND        274    // 0x112
#define WM_LBUTTONDBLCLK     515    // 0x203
#define WM_DRAWITEM           43    // 0x2B
#define WM_MEASUREITEM        44    // 0x2C
#define WM_SETFONT            48    // 0x30
#define WM_QUERYDRAGICON      55    // 0x37
#define WM_ERASEBKGND         20    // 0x14
#define WM_CHILDACTIVATE      34    // 0x22
#define WM_ICONERASEBKGND     39    // 0x27
#define WM_GETFONT            49    // 0x0031
#define WM_NCPAINT           133    // 0x085
#define WM_NCMOUSEMOVE       160    // 0xA0
#define WM_MBUTTONDOWN       519
#define WM_MBUTTONUP         520
#define WM_CTLCOLOR           25    // 0x19
#define WM_CTLCOLOREDIT      307    // 0x133
#define WM_CTLCOLORLISTBOX   308    // 0x134
#define WM_CTLCOLORSTATIC    312    // 0x138
#define WM_GETMINMAXINFO      36    // 0x024

#define WS_EX_DLGMODALFRAME    1
#define WS_EX_TOOLWINDOW     128
#define WS_EX_CLIENTEDGE     512
#define WS_EX_CONTEXTHELP   1024

#define CBN_SELCHANGE          1
#define CBN_CLOSEUP            8

#define IDC_ARROW          32512

#define SIZE_MINIMIZED         1

#define SC_RESTORE         61728
#define SC_CLOSE           61536   // 0xF060
#define SC_CLOSE_OPEN      61539   // 0xF063  Close and Popup already opened
#define SC_MINIMIZE        61472
#define SC_NEXT            61504
#define SC_MAXIMIZE        61488   // 0xF030

#define SW_HIDE                0
#define SW_SHOWNA              8

#define DLGC_BUTTON         8192   // 0x2000

#define CS_DBLCLKS             8
#define CW_USEDEFAULT      32768

#define HORZRES             8
#define VERTRES            10

#define GWL_STYLE         -16
#define GW_CHILD            5
#define GWL_EXSTYLE       -20

#define COLOR_WINDOW        5
#define WM_SETICON        128  // 0x80
#define WM_MENUSELECT     287  // 0x11F

#define FN_ZIP          15001

//extern set
static Selector := GetSelector()

static Handle_window := 0
static Identifier_window := 0
static nCurHandle := 0
static aWindows := {}
static nCur := 0

// ToolTips statics support
static oToolTip, oTmr, hPrvWnd, lToolTip := .f., hWndParent := -1,;
       hToolTip := -1

static defIcon := NIL  // Icon by default
static oWndDefault := 0
//----------------------------------------------------------------------------//

function nWindows()  ; return Len( aWindows )
function GetAllWin() ; return aWindows
//function GetActiveWindow() ; return aWindows[nCur]:hWnd

function SetWndDefault( oWnd ) ; oWndDefault := oWnd ; return nil
function GetWndDefault() ; return oWndDefault

//----------------------------------------------------------------------------//

*************
function TWindow()
local obj:=map()

	obj:className	:= "FWIN_TWINDOW"
	obj:hWnd	:= -1
	obj:nOldProc	:= 0
	obj:bInit	:= NIL
	obj:bMoved	:= NIL
	obj:bLClicked	:= NIL
	obj:bKeyDown	:= NIL
	obj:bPainted	:= NIL
	obj:bRClicked	:= NIL
	obj:bResized	:= NIL
	obj:bLDblClick	:= NIL
	obj:bLButtonUp	:= NIL
	obj:bWhen	:= NIL
	obj:bValid	:= NIL
	obj:bKeyChar	:= NIL
	obj:bMMoved	:= NIL
	obj:bGotFocus	:= NIL
	obj:bLostFocus	:= NIL
	obj:cCaption	:= ""
	obj:cPS		:= ""
	obj:nPaintCount	:= 0
	obj:cMsg	:= ""
	obj:cVarName	:= ""
	obj:cToolTip	:= ""
	obj:Cargo	:= NIL
	obj:hDC		:= NIL
	obj:nId		:= 0
	obj:lActive	:= .f.
	obj:lVisible	:= .t.
	obj:lFocused	:= .f.
	obj:nStyle	:= 0
	obj:nChrHeight	:= 0
	obj:nChrWidth	:= 0
	obj:nLastKey	:= 0
	obj:nTop	:= 0
	obj:nLeft	:= 0
	obj:nRight	:= 0
	obj:nBottom	:= 0
	obj:nClrPane	:= 0
	obj:nClrText	:= 0
	obj:nResult	:= 0
	obj:lValidating	:= .f.
	obj:nHelpId	:= -1
	obj:hCtlFocus	:= -1
	obj:aControls	:= {}
	obj:oBar	:= NIL
	obj:oBrush	:= NIL
	obj:oCursor	:= NIL
	obj:oFont	:= NIL
	obj:oIcon	:= NIL
	obj:oMenu	:= NIL
	obj:oSysMenu	:= NIL
	obj:oPopup	:= NIL
	obj:oMsgBar	:= NIL
	obj:oWnd	:= NIL
	obj:oVScroll	:= NIL
	obj:oHScroll	:= NIL
	obj:oClient	:= NIL
	obj:oTop	:= NIL
	obj:oBottom	:= NIL
	obj:oLeft	:= NIL
	obj:oRight	:= NIL

	obj:handle	:= NIL
	obj:type	:= NIL

	/* methods */
	_recover_FWIN_TWINDOW(obj)
return obj

function _recover_FWIN_TWINDOW(obj)
	obj:New		:= @fw_new()
	obj:Activate	:= @fw_activate()
	obj:AddControl	:= @fw_addControl()
	obj:BeginPaint	:= @fw_beginPaint()
	obj:Box		:= @fw_box()
	obj:Capture	:= @fw_capture()
	obj:Center	:= @fw_center()
	obj:Command	:= @fw_command()
	obj:Circle	:= @fw_circle()
	obj:Close	:= @fw_Close()
	obj:CoorsUpdate	:= @fw_coorsUpdate()
	obj:Copy	:= @fw_copy()
	obj:Create	:= @fw_create()
	obj:CtlColor	:= @fw_ctlColor()
	obj:cTitle	:= @fw_cTitle()
	obj:DdeInitiate	:= @fw_ddeInitiate()
	obj:DdeAck	:= @fw_ddeAck()
	obj:DdeExecute	:= @fw_ddeExecute()
	obj:DdeTerminate:= @fw_ddeTerminate()
	obj:Destroy	:= @fw_destroy()
	obj:Disable	:= @fw_disable()
	obj:DrawItem	:= @fw_drawItem()
	obj:DropFiles	:= @fw_dropFiles()
	obj:Enable	:= @fw_Enable()
	obj:End		:= @fw_end()
	obj:EndPaint	:= @fw_endPaint()
	obj:EraseBkGnd	:= @fw_eraseBkGnd()
	obj:FloodFill	:= @fw_floodFill()
	obj:FindNext	:= @fw_findNext()
	obj:cGenPrg	:= @fw_cGenPrg()
	obj:nGetChrHeight	:= @fw_nGetChrHeight()
	obj:GetCliRect	:= @fw_getCliRect()
	obj:GetFont	:= @fw_getFont()
	obj:GetRect	:= @fw_getRect()
	obj:GetDC	:= @fw_getDC()
	obj:GetDlgCode	:= @fw_getDlgCode()
	obj:GetWidth	:= @fw_getWidth()
	obj:GoNextCtrl	:= @fw_goNextCtrl()
	obj:GoPrevCtrl	:= @fw_goPrevCtrl()
	obj:GotFocus	:= @fw_gotFocus()
	obj:GoTop	:= @fw_goTop()
	obj:HandleEvent	:= @fw_handleEvent()
	obj:HardCopy	:= @fw_hardCopy()
	obj:Hide	:= @fw_hide()
	obj:HScroll	:= @fw_hScroll()
	obj:Iconize	:= @fw_iconize()
	obj:CheckToolTip:= @fw_CheckToolTip()
	obj:KeyDown	:= @fw_keyDown()
	obj:KeyChar	:= @fw_keyChar()
	obj:KillFocus	:= @fw_killFocus()
	obj:LButtonDown	:= @fw_lButtonDown()
	obj:LDblClick	:= @fw_lDblClick()
	obj:Line	:= @fw_line()
	obj:Link	:= @fw_link()
	obj:LostFocus	:= @fw_lostFocus()
	obj:lWhen	:= @fw_lWhen()
	obj:Maximize	:= @fw_maximize()
	obj:MenuSelect	:= @fw_menuSelect()
	obj:MeasureItem	:= @fw_measureItem()
	obj:Minimize	:= @fw_minimaze()
	obj:MouseMove	:= @fw_mouseMove()
	obj:Move	:= @fw_move()
	obj:NcActivate	:= @fw_ncActivate()
	obj:Normal	:= @fw_normal()
	obj:Paint	:= @fw_paint()
	obj:PaletteChanged	:= @fw_paletteChanged()
	obj:PostMsg	:= @fw_postMsg()
	obj:Print	:= @fw_print()
	obj:QueryDragIcon	:= @fw_queryDragIcon()
	obj:QueryEndSession	:= @fw_queryEndSession()
	obj:QueryNewPalette	:= @fw_queryNewPalette()
	obj:RButtonDown	:= @fw_rButtonDown()
	obj:ReleaseDC	:= @fw_releaseDC()
	obj:Refresh	:= @fw_refresh()
	obj:Register	:= @fw_register()
	obj:ReSize	:= @fw_reSize()
	obj:Say		:= @fw_say()
	obj:SayRect	:= @fw_sayRect()
	obj:SendMsg	:= @fw_sendMsg()
	obj:SelColor	:= @fw_selColor()
	obj:SetBrush	:= @fw_setBrush()
	obj:SetCoors	:= @fw_setCoors()
	obj:SetColor	:= @fw_setColor()
	obj:SetFocus	:= @fw_setFocus()
	obj:SelFont	:= @fw_selFont()
	obj:SetFont	:= @fw_setFont()
	obj:SetMenu	:= {| self, oMenu | SetMenu( self, oMenu ),;
				   self:oMenu := oMenu, oMenu:oWnd := Self }
	obj:SetMsg	:= @fw_setMsg()
	obj:SetPixel	:= @fw_setPixel()
	obj:SetText	:= @fw_setText()
	obj:Show	:= {|self| eval(Selector:ShowWindow, self:hWnd, SW_SHOWNA)}
	obj:ShowToolTip	:= @fw_showToolTip()
	obj:DestroyToolTip:= @fw_destroyToolTip()
	obj:SysCommand	:= @fw_sysCommand()
	obj:Timer	:= @fw_timer()
	obj:UnLink	:= @fw_unLink()
	obj:Update	:= @fw_update()
	obj:lValid	:= @fw_lValid()
	obj:VScroll	:= @fw_vScroll()
	obj:nVertRes	:= @fw_nVertRes()
	obj:nHorzRes	:= @fw_nHorzRes()
	obj:AEvalWhen	:= @fw_aEvalWhen()
	obj:VbxFireEvent	:= @fw_vbxFireEvent()
return obj
***************
static function fw_new(self, nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu,;
			oBrush, oIcon, oWnd, lVScroll, lHScroll, nClrFore, nClrBack,;
			oCursor, cBorder, lSysMenu, lCaption, lMin, lMax, lPixel)
local cH, cW

	FWInitDriver()

	DEFAULT nTop := 2, nLeft := 2, nBottom := 20, nRight := 70,;
		lVScroll := .f., lHScroll := .f.,;
		nClrFore := CLR_BLACK, nClrBack := GetSysColor( COLOR_WINDOW ),;
		nStyle   := 0,;
		cBorder  := "SINGLE", lSysMenu := .t., lCaption := .t.,;
		lMin     := .t., lMax := .t., lPixel := .f.

	if nStyle == 0
		nStyle = numOr( WS_CLIPCHILDREN,;
		    If( cBorder == "NONE",   WS_POPUP, 0 ),;
		    If( cBorder == "SINGLE", WS_THICKFRAME, 0 ),;
		    If( lCaption, WS_CAPTION, 0 ),;
		    If( lSysMenu .and. lCaption, WS_SYSMENU, 0 ),;
		    If( lMin .and. lCaption, WS_MINIMIZEBOX, 0 ),;
		    If( lMax .and. lCaption, WS_MAXIMIZEBOX, 0 ),;
		    If( lVScroll, WS_VSCROLL, 0 ),;
		    If( lHScroll, WS_HSCROLL, 0 ) )
	endif

	self:nTop	:= nTop*iif(lPixel, 1, WIN_CHARPIX_H)
	self:nLeft 	:= nLeft*iif(lPixel,1, WIN_CHARPIX_W)
	self:nBottom 	:= nBottom*iif(lPixel, 1, WIN_CHARPIX_H)
	self:nRight 	:= nRight*iif(lPixel, 1, WIN_CHARPIX_W)
	self:nWidth 	:= self:nRight-self:nLeft+1
	self:nHeight 	:= self:nBottom-self:nTop+1
	self:cCaption 	:= cTitle
	self:nStyle 	:= nStyle
	self:oMenu 	:= oMenu
	self:oBrush 	:= oBrush
	self:oIcon 	:= oIcon
	self:oWnd	:= oWnd
	self:lVisible	:= .t.
	self:aControls	:= {}
	self:nLastKey	:= 0
	self:nClrFore   := nClrFore
	self:nClrBack   := nClrBack


	self:Create()

	self:SetColor(nClrFore, nClrBack, oBrush)

	if valtype( oIcon ) == "C"  // oIcon - file name
		if file( oIcon )
			oIcon := TIcon():New(,,, oIcon)  // FILE
		else
			oIcon := TIcon():New(,, oIcon)   // RESOURSE

		endif
		self:oIcon := oIcon
		self:Refresh()
	endif

	if oMenu != NIL
		eval(Selector:SetMenu, self, oMenu )
	endif


	SetWndDefault( Self )                   // Set Default DEFINEd Window
return self
***************
static function fw_activate(self, cShow, blClicked, bRClicked, bMoved, bResized, bPainted, ;
			bKeyDown, bInit, bUp, bDown, bPgUp, bPgDown, ;
			bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles)
local oVScroll, oHScroll

	DEFAULT cShow := "NORMAL"



	self:lValidating = .f.

	if bValid != NIL
		self:bValid = bValid
	endif

	if bDropFiles != NIL
		self:bDropFiles = bDropFiles
		//DragAcceptFiles( self:hWnd, .t. ) //???????????
	endif

	if bPainted != NIL
		if self:className == "FWIN_TMDIFRAME"
			self:oWndClient:bPainted = bPainted
		else
			self:bPainted  = bPainted
		endif
	endif

	if bRClicked != NIL
		if self:classname == "FWIN_TMDIFRAME"
			self:oWndClient:bRClicked = bRClicked
		else
			self:bRClicked = bRClicked
		endif
	endif

	if self:oFont != NIL
		self:SetFont( self:oFont )
	endif

	// For WS_VSCROLL and WS_HSCROLL styles

	if self:classname == "FWIN_TMDIFRAME"
	else
		oVScroll = self:oVScroll
		oHScroll = self:oHScroll
	endif

	if oVScroll != NIL       // When using VSCROLL clause
		if bUp != NIL
			oVScroll:bGoUp := bUp
		endif
		if bDown != NIL
			oVScroll:bGoDown := bDown
		endif
		if bPgUp != NIL
			oVScroll:bPageUp := bPgUp
		endif
		if bPgDown != NIL
			oVScroll:bPageDown := bPgDown
		endif
	endif

	if oHScroll != NIL       // When using HSCROLL clause
		if bLeft != NIL
			oHScroll:bGoUp := bLeft
		endif
		if bRight != NIL
			oHScroll:bGoDown := bRight
		endif
		if bPgLeft != NIL
			oHScroll:bPageUp := bPgLeft
		endif
		if bPgRight != NIL
			oHScroll:bPageDown = bPgRight
		endif
	endif

	self:AEvalWhen()


	eval(Selector:ShowWindow, self, AScan( { "NORMAL", "ICONIZED", "MAXIMIZED" }, cShow ) )
	eval(Selector:UpdateWindow, self )

	self:lVisible = .t.

	/*
	if "OMSGBAR"$self .and. self:oMsgBar != NIL
		eval(self:oMsgBar:paint, self:oMsgBar)
	endif
	*/

	eval(Selector:SetWndApp, self:hWnd )


	if self:bInit != NIL
		Eval( self:bInit, self )
	endif


	//self:Resize()

//	if self:oWnd == nil
//		if ! lWRunning()
//			WinRun( Self:hWnd )
//		endif
  //	endif

	if self != NIL  // FiveWin++ difference
		self:lVisible = .f.
	endif

return
***************
static function fw_addControl(self, oControl)
	if self:aControls == NIL
		self:aControls := {}
	endif
	aadd( self:aControls, oControl )
	self:lValidating := .f.
return
***************
static function fw_beginPaint(self)
local cPS

	if self:nPaintCount == nil
		self:nPaintCount = 1
	else
		self:nPaintCount++
	endif

	self:hDC = eval(Selector:BeginPaint, self:hWnd, @cPS )
	self:cPS = cPS
return
***************
static function fw_box(self, nTop, nLeft, nBotton, nRight)
   self:GetDC()
   //WndBox( self:hDC, nTop, nLeft, nBottom, nRight )
   self:ReleaseDC()
return
***************
static function fw_capture()
return
***************
static function fw_center(self, oWnd)

	eval(Selector:WndCenter, self:hWnd, oWnd )
return
***************
static function fw_command(self, nWParam, nLParam)
local nNotifyCode, nID, hWndCtl

	nNotifyCode = HiWord( nWParam )
	nID         = LoWord( nWParam )
	hWndCtl     = nLParam

	do case
	case self:oPopup != nil
		self:oPopup:Command( nID )

	case hWndCtl < 0 .and. self:oMenu != nil
		self:oMenu:Command( nID )

	case hWndCtl > -1
		do case
		case nNotifyCode == BN_CLICKED
			eval(Selector:SendMessage, hWndCtl, HASH_FM_CLICK, 0, 0 )

		case nNotifyCode == CBN_CLOSEUP
			eval(Selector:SendMessage, hWndCtl, HASH_FM_CLOSEUP, 0, 0 )

		case nNotifyCode == CBN_SELCHANGE
			eval(Selector:SendMessage, hWndCtl, HASH_FM_CHANGE, 0, 0 )

		case nWParam == FN_UNZIP // FiveWin notification codes
			self:UnZip( nPtrWord( nLParam ) )

		case nWParam == FN_ZIP
			self:Zip( nLParam )
		endcase
	endcase
return
***************
static function fw_circle(self, nRow, nCol, nWidth)
return
***************
static function fw_coorsUpdate(self)
local aRect := eval(Selector:GetCoors,self:hWnd)

	self:nTop    := aRect:top
	self:nLeft   := aRect:left
	self:nBottom := aRect:bottom
	self:nRight  := aRect:right

	self:nWidth  := self:nRight - self:nLeft + 1
	self:nHeight := self:nBottom - self:nTop + 1
return
***************
static function fw_copy(self, lAll)
// lAll пока почему-то не используется.
// См сырцы clasess/window.prg, а делается так:
	if self:bCopy != NIL
		eval(self:bCopy, self)
	endif
return
***************
static function fw_create(self, cClsName)

	DEFAULT cClsName := self:classname, self:cCaption := "",;
		self:nStyle := WS_OVERLAPPEDWINDOW,;
		self:nTop := 0, self:nLeft := 0, self:nBottom := 10, self:nRight := 10,;
		self:nId := 0

	if self:oWnd != nil
		self:nStyle = numOr( self:nStyle, WS_CHILD )
	endif

	if self:nRight!=CW_USEDEFAULT .and. self:nLeft!=CW_USEDEFAULT
		self:nWidth := self:nRight-self:nLeft+1
	else
		self:nWidth := 400
	endif

	if self:nBottom!=CW_USEDEFAULT .and. self:nTop!=CW_USEDEFAULT
		self:nHeight := self:nBottom-self:nTop+1
	else
		self:nHeight := 200
	endif

	eval(Selector:CreateWindow, self, cClsName)

	Identifier_window ++
	self:nId := Identifier_window
	nCurHandle := Handle_window

	if self:hWnd < 0
		eval(Selector:WndCreateError, Self )
	else
		self:Link()
		if self:oFont != nil
			self:SetFont( self:oFont )
		endif
	endif
return
***************
static function fw_ctlColor(self, nWndChild, hDCChild)
	eval(Selector:SendMessage,nWndChild, FM_COLOR, hDCChild)
return
***************
static function fw_cTitle(self, cNewTitle)
	if cNewTitle != NIL .and. self:hWnd > -1
		self:cTitle := cNewTitle
		self:update()
	endif
return
***************
static function fw_ddeInitiate(self, hWndClient, nAppName, nTopicName)
	if self:bDdeInit != NIL
		Eval( self:bDdeInit, hWndClient, eval(Selector:GlobalGetAtomName, nAppName ), eval(Selector:GlobalGetAtomName, nTopicName ) )
		eval(Selector:SendMessage, hWndClient, WM_DDE_ACK, self:hWnd, nMakeLong( nTopicName, nAppName ) )
	endif
return
***************
static function fw_ddeAck(self, hWndSender, nLParam)
	eval(Selector:DdeAck, hWndSender, nLParam ) // DDE class
return
***************
static function fw_ddeExecute(hWndSender, nCommand)
return
***************
static function fw_ddeTerminate(hWndSender)
return
***************
static function fw_destroy()
	//X:Quit()
return
***************
static function fw_disable(self)
	self:lActive := .f.
	if self:hWnd > -1
		eval(Selector:EnableWindow,self:hWnd, .f.)
	endif
return
***************
static function fw_drawItem(self, nIdCtl, pItemStruct)
local oItem

	if nIdCtl == 0
		if self:oPopup != NIL .or. self:oMenu != NIL
			if self:oPopup != NIL .and. self:oPopup:GetPopup( eval(Selector:GetDrawMenu, pItemStruct ) ) != NIL
				oItem = self:oPopup:GetMenuItem( eval(Selector:GetDrawItem, pItemStruct ) )
				if oItem == NIL
					self:oPopup = NIL
				endif
			endif
			if oItem == NIL .and. self:oMenu != NIL
				oItem = self:oMenu:GetMenuItem( eval(Selector:GetDrawItem, pItemStruct ) )
			endif
			if oItem != NIL
				return eval(Selector:MenuDrawItem, pItemStruct, oItem:cPrompt,;
				ValType( oItem:bAction ) == "O", oItem:hBitmap )
			endif
		endif
	else
		return eval(Selector:SendMessage, eval(Selector:GetDlgItem, self:hWnd, nIdCtl ), FM_DRAW, nIdCtl, pItemStruct )
	endif
return
***************
static function fw_dropFiles(self, hDrop)
local aFiles
local aCoors := { 0, 0 }

	self:hDrop := hDrop

	if !Empty( self:bDropFiles )
		eval(Selector:DragQueryPoint, hDrop, aCoors )
		Eval( self:bDropFiles, aCoors[ 2 ], aCoors[ 1 ], eval(Selector:DragQueryFiles, hDrop ) )
	endif
return
***************
static function fw_Enable(self)
	self:lActive := .t.
	if self:hWnd > -1
		eval(Selector:EnableWindow,self:hWnd, .t.)
	endif
return
***************
static function fw_end(self)
local lEnd, i
	lEnd := self:lValid()

	if lEnd
		eval(Selector:PostMessage,self:hWnd, 'hide' )
		for i=1 to len(aWindows)
			if aWindows[i] == self:hWnd
				adel(aWindows, i)
				asize(aWindows, len(aWindows)-1)
				exit
			endif
		next
		//PostMessage(self, 'gtk-hide-signal' )
	endif
return lEnd
***************
static function fw_endPaint(self)
	self:nPaintCount--
	eval(Selector:EndPaint, self, self:cPS )
	self:cPS := nil
	self:hDC := nil
return
***************
static function fw_eraseBkGnd(self, hDC)
	// if iconized
	if eval(Selector:IsIconic, self:hWnd )
		if self:oWnd != NIL
			eval(Selector:FillRect, hDC, eval(Selector:GetClientRect, self:hWnd ), self:oWnd:oBrush:hBrush )
			return 1
		endif
		return 0
	endif

	if self:oBrush != NIL .and. ! Empty( self:oBrush:hBrush )
		eval(Selector:FillRect, hDC, eval(Selector:GetClientRect, self:hWnd ), self:oBrush:hBrush )
		return 1
	endif
return
***************
static function fw_floodFill(self, nRow, nCol, nRGBColor)
return
***************
static function fw_findNext(self, hCtrl, lPrevious)
	if self:bFindNext != NIL
		Eval( self:bFindNext, Self )
	endif
return
***************
static function fw_cGenPrg(self, cFileName)
local cPrg := ""

self:CoorsUpdate()

	cPrg += '#include "FiveWin.ch"' + CRLF + CRLF
	cPrg += "static oWnd" + CRLF + CRLF
	cPrg += "//" + Replicate( "-", 76 ) + "//" + CRLF + CRLF
	cPrg += "function Main()" + CRLF + CRLF

	if self:oBar != nil
		cPrg += "   local oBar" + CRLF
	endif

	if self:oBrush != nil
		cPrg += "   local oBrush" + CRLF
	endif

	if self:oBrush != nil
		cPrg += self:oBrush:cGenPRG()
	endif

	cPrg += CRLF + ;
		'   DEFINE WINDOW oWnd TITLE "' + self:cTitle + '" ;' + CRLF + ;
		"      FROM " + ;
		Str( self:nTop / WIN_CHARPIX_H , 3 ) + ", " + Str( self:nLeft / WIN_CHARPIX_W, 3 ) + " := " + ;				  // 16, 8
		Str( self:nBottom / WIN_CHARPIX_H, 3 ) + ", " + Str( self:nRight / WIN_CHARPIX_W, 3 )							  // 16,8

	if self:oMenu != nil
		cPrg += " ;" + CRLF + "      MENU BuildMenu()"
	endif

	if self:oBrush != nil
		cPrg += " ;" + CRLF + "      BRUSH oBrush" + CRLF
	endif

	if self:oBar != nil
		cPrg += self:oBar:cGenPRG()
	endif

	if self:oMsgBar != nil
		cPrg += CRLF + CRLF + '   SET MESSAGE OF oWnd := "' + ;
		self:oMsgBar:cMsgDef + '"'
	endif

	if ! Empty( self:aControls )
		AEval( self:aControls, { | oCtrl | cPrg += oCtrl:cGenPRG() } )
	endif

	cPrg += CRLF + "   ACTIVATE WINDOW oWnd" + CRLF + CRLF
	cPrg += "return nil" + CRLF + CRLF
	cPrg += "//" + Replicate( "-", 76 ) + "//" + CRLF

	if ! Empty( cFileName )
		MemoWrit( cFileName, cPrg )
	endif

return cPrg
***************
static function fw_nGetChrHeight(self)
	// ?????????? тут нужна функция, определяющая высоту символа в окне
	self:nChrHeight := nWndChrHeight( self:hWnd, If( self:oFont != nil, self:oFont:hFont,) )
return
***************
static function fw_getCliRect(self)
local aRect := eval(Selector:GetClientRect, self:hWnd )

return TRect():New( aRect[ 1 ], aRect[ 2 ], aRect[ 3 ], aRect[ 4 ] )
***************
static function fw_getFont(self, nWidth, nHeight)
local hFont, aFont, val

	DEFAULT nWidth := SAY_CHARPIX_W, nHeight := SAY_CHARPIX_H

	hFont := iif("OWND"$self .and. self:oWnd!=nil, iif("OFONT"$self:oWnd .and. self:oWnd:oFont!=nil, self:oWnd:oFont:hFont, 0), 0)
	if self:oFont == nil .and. hFont != 0 .and. self:oWnd:oFont!=NIL
		self:oFont = self:oWnd:oFont
		self:nChrHeight   = self:oWnd:oFont:nHeight
		self:nChrWidth    = self:oWnd:oFont:nWidth
	else
		self:oFont := TFont():New()
	endif
	if "CFONTDESCRIPTION"$self:oFont .and. !empty(self:oFont:cFontDescription)
		aFont := split(self:oFont:cFontDescription, "-")
	else
		aFont := split(FONT_DEFAULT, "-")
	endif
	aDel(aFont, 1)
	aSize(aFont, 14)
	if aFont[7] == "*"
		aFont[7] = nWidth
	endif
	self:oFont:cFontDescription := ""
	for val in aFont
		self:oFont:cFontDescription += "-"+alltrim(toString(val))
	next

return self:oFont
***************
static function fw_getRect(self)
local aRect := eval(Selector:GetWndRect, self:hWnd )

return TRect():New( aRect[ 1 ], aRect[ 2 ], aRect[ 3 ], aRect[ 4 ] )
***************
static function fw_getDC(self)  // It's simple DispBegin() and it need ReleaseDC()
	if self:hDC == nil
		self:hDC := eval(Selector:GetDC, self:hWnd )
	endif
	if self:nPaintCount == nil
		self:nPaintCount := 1
	else
		self:nPaintCount++
	endif
return self:hDC
***************
static function fw_releaseDC(self)  // It's simple DispEnd()
	If --self:nPaintCount == 0
		If eval(Selector:ReleaseDC, self:hWnd, self:hDC )
			self:hDC := NIL
		endif
	endif
return
***************
static function fw_getDlgCode()
return
***************
static function fw_getWidth(self, cText, oFont, nSize)
	oFont := If( oFont == NIL, self:oFont, oFont )
	//nSize := GetTextWidth( self:GetDC(), cText, If( oFont != nil, oFont:hFont,) )
	//outlog(__FILE__, __LINE__, oFont )
	nSize := eval(Selector:GetTextWidth, cText, If( oFont != nil .and. !empty(oFont), oFont:handle, NIL) )
	//self:ReleaseDC()
return nSize
***************
static function fw_goNextCtrl(self, hCtrl)
local hCtlNext := eval(Selector:NextDlgTab, self, hCtrl )

	self:hCtlFocus = hCtlNext

	if ! Empty( self:aControls ) .and. hCtrl == ATail( self:aControls ):hWnd
		if ! Empty( self:oWnd ) .and. ;
			( Upper( self:oWnd:classname ) == "TFOLDER" .or. ;
			Upper( self:oWnd:classname ) == "TPAGES" )
			hCtlNext = eval(Selector:NextDlgTab, self:oWnd:oWnd:hWnd, self:oWnd:hWnd )
			self:hCtlFocus = hCtrl
		endif
	endif

	if hCtlNext != hCtrl
		eval(Selector:SetFocus, hCtlNext )
	endif
return
***************
static function fw_goPrevCtrl(self, hCtrl)
local hCtlPrev := eval(Selector:NextDlgTab, self, hCtrl, .t. )

	self:hCtlFocus = hCtlPrev

	if ! Empty( self:aControls ) .and. hCtrl == self:aControls[ 1 ]:hWnd
		if ! Empty( self:oWnd ) .and. ;
			( Upper( self:oWnd:classname ) == "TFOLDER" .or. ;
			Upper( self:oWnd:classname ) == "TPAGES" )
			hCtlPrev = eval(Selector:NextDlgTab, self:oWnd:oWnd:hWnd, self:oWnd:hWnd, .t. )
			self:hCtlFocus = hCtrl
		endif
	endif

	if hCtlPrev != hCtrl
		eval(Selector:SetFocus, hCtlPrev )
	endif
return
***************
static function fw_gotFocus(self)
	self:lFocused = .t.

	if self:bGotFocus != nil
		Eval( self:bGotFocus )
	endif

	if ! Empty( self:hCtlFocus )
		eval(Selector:SetFocus, self:hCtlFocus )
	else
		if self:aControls != nil .and. Len( self:aControls ) > 0
			if self:aControls[ 1 ] != nil
				self:hCtlFocus = self:aControls[ 1 ]:hWnd
				eval(Selector:SetFocus, self:hCtlFocus )
			endif
		endif
	endif
return 0
***************
static function fw_goTop(self)

return eval(Selector:BringWindowToTop,self:hWnd)
***************
static function fw_handleEvent(self, oEvent, nWParam, nLParam)
local nMsg
	nMsg := oEvent:event
	qout('event=', nMsg)
   do case
/*The WM_CHAR message is posted to the window with the keyboard    */
/*focus when a WM_KEYDOWN message is translated by the             */
/*TranslateMessage function. WM_CHAR contains the character code of*/
/*the key that was pressed.                                        */
      case nMsg == WM_CHAR
	   return self:KeyChar( nWParam, nLParam )

/*The WM_CLOSE message is sent as a signal that a window or an    */
/*application should terminate.                                   */
      case nMsg == WM_CLOSE  // 'delete-event'
	   return self:Close( )

/*The WM_COMMAND message is sent when the user selects a           */
/*command item from a menu, when a control sends a notification    */
/*message to its parent window, or when an accelerator keystroke is*/
/*translated.                                                      */
      case nMsg == WM_COMMAND
	   return self:Command( nWParam, nLParam )

/*The WM_GETMINMAXINFO message is sent to a window when the size  */
/*or position of the window is about to change. An application can*/
/*use this message to override the window,s default maximized size*/
/*and position, or its default minimum or maximum tracking size.  */
      case nMsg == WM_GETMINMAXINFO
	   return self:GetMinMaxInfo( nLParam )

/*An application sends the WM_PAINT message when Windows or          */
/*another application makes a request to paint a portion of an       */
/*application,s window. The message is sent when the UpdateWindow    */
/*or RedrawWindow function is called, or by the DispatchMessage      */
/*function when the application obtains a WM_PAINT message by using  */
/*the GetMessage or PeekMessage function.			     */
      case nMsg == WM_PAINT
	   self:BeginPaint()
	   self:Paint()
	   self:EndPaint()

/*The WM_DESTROY message is sent when a window is being               */
/*destroyed. It is sent to the window procedure of the window being   */
/*destroyed after the window is removed from the screen.              */
/*This message is sent first to the window being destroyed and then   */
/*to the child windows (if any) as they are destroyed. During the     */
/*processing of the message, it can be assumed that all child         */
/*windows still exist.						      */
      case nMsg == WM_DESTROY
	   return self:Destroy()

/*The WM_DRAWITEM message is sent to the owner window of an           */
/*owner-drawn button, combo box, list box, or menu when a visual      */
/*aspect of the button, combo box, list box, or menu has changed.     */
      case nMsg == WM_DRAWITEM
	   return self:DrawItem( nWParam, nLParam )

/*An application sends the WM_ERASEBKGND message when the window      */
/*background must be erased (for example, when a window is resized)   */
/*. The message is sent to prepare an invalidated portion of a        */
/*window for painting.						      */
      case nMsg == WM_ERASEBKGND
	   return self:EraseBkGnd( nWParam )

/*The WM_GETDLGCODE message is sent to the dialog box procedure        */
/*associated with a control. Normally, Windows handles all arrow-      */
/*key and TAB-key input to the control. By responding to the           */
/*WM_GETDLGCODE message, an application can take control of a          */
/*particular type of input and process the input itself.	       */
      case nMsg == WM_GETDLGCODE
	   return self:GetDlgCode()

/*The WM_HSCROLL message is sent to a window when a scroll event       */
/*occurs in the window,s standard horizontal scroll bar. This          */
/*message is also sent to the owner of a horizontal scroll bar         */
/*control when a scroll event occurs in the control.		       */
      case nMsg == WM_HSCROLL
	   return self:HScroll( nWParam, nLParam )

/*The WM_KEYDOWN message is posted to the window with the              */
/*keyboard focus when a nonsystem key is pressed. A nonsystem key      */
/*is a key that is pressed when the ALT key is not pressed.            */
      case nMsg == WM_KEYDOWN
	   return self:KeyDown( nWParam, nLParam )

/*The WM_KILLFOCUS message is sent to a window immediately before      */
/*it loses the keyboard focus.					       */
      case nMsg == WM_KILLFOCUS
	   return self:LostFocus( nWParam ) // LostFocus(), not KillFocus()!!!

/*The WM_LBUTTONDOWN message is posted when the user presses the        */
/*left mouse button while the cursor is in the client area of a         */
/*window. If the mouse is not captured, the message is posted to        */
/*the window beneath the cursor. Otherwise, the message is posted       */
/*to the window that has captured the mouse.				*/
      case nMsg == WM_LBUTTONDOWN
	   return self:LButtonDown( nHiWord( nLParam ), nLoWord( nLParam ),;
				 nWParam )
/*The WM_LBUTTONUP message is posted when the user releases the         */
/*left mouse button while the cursor is in the client area of a         */
/*window. If the mouse is not captured, the message is posted to        */
/*the window beneath the cursor. Otherwise, the message is posted       */
/*to the window that has captured the mouse.                            */
      case nMsg == WM_LBUTTONUP
	   return self:LButtonUp( nHiWord( nLParam ), nLoWord( nLParam ),;
			       nWParam )

/*The WM_LBUTTONDBLCLK message is posted when the user double-           */
/*clicks the left mouse button while the cursor is in the client         */
/*area of a window. If the mouse is not captured, the message is         */
/*posted to the window beneath the cursor. Otherwise, the message        */
/*is posted to the window that has captured the mouse.			 */
      case nMsg == WM_LBUTTONDBLCLK
	   return self:LDblClick( nHiWord( nLParam ), nLoWord( nLParam ),;
			       nWParam )

/*The WM_MBUTTONDOWN message is posted when the user presses the          */
/*middle mouse button while the cursor is in the client area of a         */
/*window. If the mouse is not captured, the message is posted to          */
/*the window beneath the cursor. Otherwise, the message is posted         */
/*to the window that has captured the mouse.				  */
      case nMsg == WM_MBUTTONDOWN
	   return self:MButtonDown( nHiWord( nLParam ), nLoWord( nLParam ),;
				 nWParam )
/*The WM_MBUTTONUP message is posted when the user releases the           */
/*middle mouse button while the cursor is in the client area of a         */
/*window. If the mouse is not captured, the message is posted to          */
/*the window beneath the cursor. Otherwise, the message is posted         */
/*to the window that has captured the mouse.				  */
      case nMsg == WM_MBUTTONUP
	   return self:MButtonUp( nHiWord( nLParam ), nLoWord( nLParam ),;
			       nWParam )

/*The WM_MEASUREITEM message is sent to the owner window of an            */
/*owner-drawn button, combo box, list box, list view control, or          */
/*menu item when the control or menu is created.			  */
      case nMsg == WM_MEASUREITEM
	   return self:MeasureItem( nWParam, nLParam )

/*The WM_MENUSELECT message is sent to a menu,s owner window when         */
/*the user selects a menu item.						  */
      case nMsg == WM_MENUSELECT
	   return self:MenuSelect( nLoWord( nWParam ), nHiWord( nWParam ), nLParam )

/*The WM_MOUSEMOVE message is posted to a window when the cursor          */
/*moves. If the mouse is not captured, the message is posted to the       */
/*window that contains the cursor. Otherwise, the message is posted       */
/*to the window that has captured the mouse.				  */
      case nMsg == GTK_LEAVE_SIGNAL//WM_MOUSEMOVE //'leave'
	   return self:MouseMove( nHiWord( nLParam ), nLoWord( nLParam ),;
			       nWParam )
/*The WM_NCMOUSEMOVE message is posted to a window when the               */
/*cursor is moved within the nonclient area of the window. This           */
/*message is posted to the window that contains the cursor. If a          */
/*window has captured the mouse, this message is not posted.		  */
      case nMsg == WM_NCMOUSEMOVE
	   return self:NcMouseMove( nWParam, nHiWord( nLParam ), nLoWord( nLParam ) );

/*The WM_RBUTTONDOWN message is posted when the user presses the          */
/*right mouse button while the cursor is in the client area of a          */
/*window. If the mouse is not captured, the message is posted to          */
/*the window beneath the cursor. Otherwise, the message is posted         */
/*to the window that has captured the mouse.				  */
      case nMsg == WM_RBUTTONDOWN
	   return self:RButtonDown( nHiWord( nLParam ), nLoWord( nLParam ),;
				 nWParam )

/*The WM_RBUTTONUP message is posted when the user releases the           */
/*right mouse button while the cursor is in the client area of a          */
/*window. If the mouse is not captured, the message is posted to          */
/*the window beneath the cursor. Otherwise, the message is posted         */
/*to the window that has captured the mouse.				  */
      case nMsg == WM_RBUTTONUP
	   return self:RButtonUp( nHiWord( nLParam ), nLoWord( nLParam ),;
			       nWParam )

/*The WM_SETFOCUS message is sent to a window after it has gained	  */
/*the keyboard focus.							  */
      case nMsg == WM_SETFOCUS
	   return self:GotFocus( nWParam )

/*The WM_VSCROLL message is sent to a window when a scroll event          */
/*occurs in the window,s standard vertical scroll bar. This message       */
/*is also sent to the owner of a vertical scroll bar control when a       */
/*scroll event occurs in the control.					  */
      case nMsg == WM_VSCROLL
	   return self:VScroll( nWParam, nLParam )

/*The WM_SIZE message is sent to a window after its size has changed.     */
      case nMsg == WM_SIZE
	   return self:ReSize( nWParam, nLoWord( nLParam ), nHiWord( nLParam ) )

/*A window receives this message when the user chooses a command          */
/*from the window menu (also known as the System menu or Control          */
/*menu) or when the user chooses the Maximize button or Minimize          */
/*button.								  */
      case nMsg == WM_SYSCOMMAND
	   return self:SysCommand( nWParam, nLParam )

/*The WM_TIMER message is posted to the installing thread,s               */
/*message queue or sent to the appropriate TimerProc callback             */
/*function after each interval specified in the SetTimer function         */
/*used to install a timer.						  */
      case nMsg == WM_TIMER
	   return self:Timer( nWParam, nLParam )

/*The WM_CTLCOLORSTATIC message is sent to the parent window of a         */
/*static control when the control is about to be drawn. By                */
/*responding to this message, the parent window can use the given         */
/*device context handle to set the text and background colors of          */
/*the static control.							  */
      case nMsg == WM_CTLCOLORSTATIC .or. ;
	   nMsg == WM_CTLCOLOREDIT   .or. ;
	   nMsg == WM_CTLCOLORLISTBOX
	   return self:CtlColor( nLParam, nWParam )

/*??????*/
/*
      case nMsg == WM_ASYNCSELECT
	   return self:AsyncSelect( nWParam, nLParam )
*/

/*??????*/
      case nMsg == FM_DRAW
	   return self:DrawItem( nWParam, nLParam )

/*??????*/
      case nMsg == FM_DROPOVER
	   return self:DropOver( nLoWord( nWParam ), nHiWord( nWParam ), nLParam )
   endcase
return
***************
static function fw_hardCopy(self, nScale, lUser)
local oPrn

	DEFAULT lUser := .t.

	if lUser
		PRINT oPrn NAME self:cTitle FROM USER
	else
		PRINT oPrn NAME self:cTitle
	endif

	PAGE
		self:Refresh()
		eval(Selector:SysRefresh,)                      // Let Windows process
		self:Print( oPrn, 0, 0, nScale )
	ENDPAGE
	ENDPRINT
return
***************
static function fw_hide(self)
return eval(Selector:ShowWindow, self, SW_HIDE )
***************
static function fw_hScroll(self, nWParam, nLParam)
local nScrHandle  := nLParam
local nScrollCode := nLoWord( nWParam )
local nPos        := nHiWord( nWParam )

   if nScrHandle == 0                   // Window ScrollBar
      do case
	 case nScrollCode == SB_LINEUP
	      self:oHScroll:GoUp()

	 case nScrollCode == SB_LINEDOWN
	      self:oHScroll:GoDown()

	 case nScrollCode == SB_PAGEUP
	      self:oHScroll:PageUp()

	 case nScrollCode == SB_PAGEDOWN
	      self:oHScroll:PageDown()

	 case nScrollCode == SB_THUMBPOSITION
	      self:oHScroll:ThumbPos( nPos )

	 case nScrollCode == SB_THUMBTRACK
	      self:oHScroll:ThumbTrack( nPos )

	 case nScrollCode == SB_ENDSCROLL
	      return 0
      endcase
   else                                 // Control ScrollBar
      do case
	 case nScrollCode == SB_LINEUP
	      eval(Selector:SendMessage, nScrHandle, FM_SCROLLUP )

	 case nScrollCode == SB_LINEDOWN
	      eval(Selector:SendMessage, nScrHandle, FM_SCROLLDOWN )

	 case nScrollCode == SB_PAGEUP
	      eval(Selector:SendMessage, nScrHandle, FM_SCROLLPGUP )

	 case nScrollCode == SB_PAGEDOWN
	      eval(Selector:SendMessage, nScrHandle, FM_SCROLLPGDN )

	 case nScrollCode == SB_THUMBPOSITION
	      eval(Selector:SendMessage, nScrHandle, FM_THUMBPOS, nPos )

	 case nScrollCode == SB_THUMBTRACK
	      eval(Selector:SendMessage, nScrHandle, FM_THUMBTRACK, nPos )
      endcase
   endif
return 0
***************
static function fw_iconize(self)
return eval(Selector:CloseWindow,self:hWnd) // for FiveWin - it's MINIMIZED WINDOW!!! FINISH!!!!
***************
static function fw_keyDown(self, nKey, nFlags)
// тут похоже вызывается функция _SetKey(nKey, bAction) и тк bAction -NIL,
// то и возвращает эта функция NIL, иначе возвращается кодовый блок, повешанный
// на эту кнопку. В нашем случае это не надо, поэтому моя функция возвращает
// только NIL  и больше ничего. Во всех FiveWin классах используется только
// SetKey() с одним параметром
local bKeyAction := eval(Selector:SetKey, nKey )

	if nKey == VK_TAB .and. self:oWnd != nil
		self:oWnd:GoNextCtrl( self:hWnd )
		return 0
	endif

	if nKey == VK_F4 .and. eval(Selector:GetKeyState, VK_CONTROL ) .and. ;
		self:oWnd != nil .and. self:oWnd:ChildLevel( TMdiChild() ) > 0
		self:oWnd:KeyDown( nKey, nFlags )
		return 0
	endif

	if nKey == VK_F6 .and. eval(Selector:GetKeyState, VK_CONTROL ) .and. ;
		self:oWnd != nil .and. self:oWnd:ChildLevel( TMdiChild() ) > 0
		self:oWnd:KeyDown( nKey, nFlags )
		return 0
	endif

	if bKeyAction != nil     // Clipper SET KEYs !!!
		Eval( bKeyAction, ProcName( 4 ), ProcLine( 4 ) )
		return 0
	endif

	if nKey == VK_F1
		self:HelpTopic()
		return 0
	endif

	if self:bKeyDown != nil
		return Eval( self:bKeyDown, nKey, nFlags )
	endif

	if self:oWnd != nil .and. eval(Selector:IsChild, self:oWnd:hWnd, self:hWnd )
		self:oWnd:KeyDown( nKey, nFlags )
	endif
return
***************
static function fw_keyChar(self, nKey, nFlags)
local bKeyAction := eval(Selector:SetKey, nKey )

	if bKeyAction != nil     // Clipper SET KEYs !!!
		return Eval( bKeyAction, ProcName( 4 ), ProcLine( 4 ) )
	endif

	if self:bKeyChar != nil
		return Eval( self:bKeyChar, nKey, nFlags )
	endif

	if nKey == VK_ESCAPE .and. self:oWnd != nil
		self:oWnd:KeyChar( nKey, nFlags )
	endif
return
***************
static function fw_killFocus(self, hWndFocus)
return self:lostFocus(hWndFocus)
***************
static function fw_lButtonDown(self, nRow, nCol, nKeyFlags)
	if self:bLClicked != NIL
		self:bLClicked(nRow, nCol, nKeyFlags) // runing block code
	endif
return
***************
static function fw_lDblClick(self, nRow, nCol, nKeyFlags)
	if self:bDblClock != NIL
		self:bDblClick(nRow, nCol, nKeyFlags) // runing block code
	endif
return
***************
static function fw_line(self, nTop, nLeft, nBottom, nRight)
	self:GetDC()
	eval(Selector:MoveTo, self:hDC, nLeft, nTop )
	eval(Selector:LineTo, self:hDC, nRight, nBottom )
	self:ReleaseDC()
return
***************
static function fw_link(self, lSubClass)
local nAt := AScan( aWindows, 0 )

	DEFAULT lSubClass := .t.

	if self:hWnd > -1
		if nAt != 0
			aWindows[ nAt ] = Self
		else
			AAdd( aWindows, Self:hWnd )
			nAt = Len( aWindows )
		endif
		nCur := nAt
		if lSubClass
			// ???????????
			//self:nOldProc = XChangeProc( self:hWnd, nAt )
		endif
	endif
return
***************
static function fw_lostFocus(self, hWndGetFocus)
	self:lFocused = .f.

/*
	if oToolTip != nil
		oToolTip:End()
		oToolTip = nil
	endif
*/

	if ! Empty( self:bLostFocus )
		return Eval( self:bLostFocus, hWndGetFocus )
	endif
return
***************
static function fw_lWhen(self)
local ret:=.t.
	if self:bWhen != NIL
		ret := self:bWhen() // runing block code
	endif
return ret
***************
static function fw_maximize(self)
return eval(Selector:ShowWindow, self, SW_MAXIMIZE )
***************
static function fw_menuSelect(self, nIdItem, nFlags, nHMenu)
	if oToolTip != nil
		oToolTip:End()
		eval(Selector:SysRefresh,)
		oToolTip = nil
	endif

	if nFlags == -1 .and. nHMenu == 0   // The pulldown is beeing closed !
		self:oMItemSelect = nil
	else
		if self:oMenu != nil .or. self:oPopup != nil
			if self:oPopup != nil
				self:oMItemSelect = self:oPopup:GetMenuItem( nIdItem )
			else
				self:oMItemSelect = self:oMenu:GetMenuItem( nIdItem )
			endif
			self:SetMsg( If( self:oMItemSelect != nil, self:oMItemSelect:cMsg,) )
		endif
	endif

	if self:bMenuSelect != nil
		self:bMenuSelect(self:oMItemSelect, nFlags, nHMenu )
	endif
return
***************
static function fw_measureItem(self, nIdCtl, pMitStruct)
local nAt, oItem

	// Warning: On this message the Controls still are not initialized
	// because WM_MEASUREITEM is sent before of WM_INITDIALOG

	if nIdCtl == 0 // Menu
		if self:oPopup != nil
			oItem = self:oPopup:GetMenuItem( GetMeaItem( pMitStruct ) )
		endif
		if oItem == nil
			self:oPopup = nil
			oItem = self:oMenu:GetMenuItem( GetMeaItem( pMitStruct ) )
		endif
		if oItem != nil
			eval(Selector:MenuMeasureItem, pMitStruct,;
			eval(Selector:GetTextWidth, 0, StrTran( oItem:cPrompt, "&", "" ) ) + ;
			If( ValType( oItem:bAction ) == "B", 20, 0 ) )
		endif
		return .f.  // default behavior
	endif

	if ( nAt := AScan( self:aControls, { | oCtrl | oCtrl:nId == nIdCtl } ) ) != 0
		return self:aControls[ nAt ]:FillMeasure( pMitStruct )
	endif
return
***************
static function fw_minimaze(self)
return eval(Selector:ShowWindow, self, SW_MINIMIZE )
***************
static function fw_mouseMove(self, nRow, nCol, nKeyFlags)
	/*
	if self:oCursor != nil
		SetCursor( self:oCursor:hCursor )
	else
		CursorArrow()
	endif
	*/

	self:SetMsg( self:cMsg )

	self:CheckToolTip()

	if self:bMMoved != nil
		return self:bMMoved( nRow, nCol, nKeyFlags )
	endif
return .t.
***************
static function fw_move(self, nTop, nLeft, nWidth, nHeight, lRepaint)
	eval(Selector:MoveWindow, self:hWnd, nTop, nLeft, nWidth, nHeight, lRepaint )

	self:CoorsUpdate()
return
***************
static function fw_ncActivate(self, lOnOff)
	if !lOnOff .and. self:bLostFocus != NIL .and.  GetFocus() != self:hWnd
		self:bLostFocus( GetFocus() )
	endif
return
***************
static function fw_normal(self)
	eval(Selector:ShowWindow,self, SW_NORMAL)
return
***************
static function fw_paint(self)
	if eval(Selector:IsIconic, self:hWnd )
		if self:classname == "TMDICHILD" // ChildLevel( TMdiChild() ) > 0
			self:SendMsg( WM_ERASEBKGND, self:hDC, 0 )
		else
			self:SendMsg( WM_ICONERASEBKGND, self:hDC, 0 )
		endif
		eval(Selector:DrawIcon, self:hDC, 0, 0, If( self:oIcon != nil, self:oIcon:hIcon, defIcon:hIcon ) )
	else
		//qout('paint', self:hDC, self:cPS)
		/* call it by "configure-event"*/
		if ValType( self:bPainted ) == "B"
			return self:bPainted( self:hDC, self:cPS, Self )
		endif

	endif
return
***************
static function fw_paletteChanged(hWndPalChg)
return eval(Selector:PalChgEvent, hWndPalChg )
***************
static function fw_postMsg(self, cMsg, nWParam, nLParam)
return eval(Selector:PostMessage, self:hWnd, cMsg, nWParam, nLParam )
***************
static function fw_print(self, oTarget, nRow, nCol, nScale)
local lNew := .f.

	DEFAULT nRow := 0, nCol := 0, nScale := 4

	if self:bPrint != NIL
		self:bPrint(self)
		return NIL
	endif

	if oTarget == NIL
		lNew = .t.
		PAGE
		eval(Selector:SysRefresh,)
	endif

	eval(Selector:WndPrint, self:hWnd, oTarget:hDC, nRow, nCol, nScale )

	if lNew
		ENDPAGE
		ENDPRINT
	endif
return
***************
static function fw_queryDragIcon(self)
	if self:oIcon != NIL
		return self:oIcon:hIcon
	else
		return eval(Selector:ExtractIcon, "user.exe" )
	endif
return
***************
static function fw_queryEndSession(self)
return  iif(self:end(), 1, 0)
***************
static function fw_queryNewPalette(self)
return If( eval(Selector:IsIconic, self:hWnd ), 0, eval(Selector:QryNewPalEvent,) )
***************
static function fw_rButtonDown(self, nRow, nCol, nKeyFlags)
	if self:bRClicked != nil
		self:bRClicked( nRow, nCol, nKeyFlags, Self )
	endif
return
***************
static function fw_refresh(self, lErase)
	eval(Selector:InvalidateRect, self:hWnd, iif( lErase != NIL, lErase, .t. ) )
return
***************
static function fw_register(self, nClsStyle)
local hUser

	DEFAULT self:lRegistered := .f. // XBPP workaround

	if self:lRegistered
		return nil
	endif

	hUser = getenv("USER")

	DEFAULT nClsStyle  := numOr( CS_VREDRAW, CS_HREDRAW ),;
	   self:nClrPane := GetSysColor( COLOR_WINDOW ),;
	   self:oBrush   := TBrush():New( ,self:nClrPane )

	nClsStyle = numOr( nClsStyle, CS_GLOBALCLASS, CS_DBLCLKS )

	if GetClassInfo( hUser, self:classname ) == nil
		self:lRegistered = RegisterClass( self:classname, nClsStyle,,, hUser, 0,;
				     self:oBrush:hBrush )
	else
		self:lRegistered = .t.
	endif
return
***************
static function fw_reSize(self, nSizeType, nWidth, nHeight)
	self:CoorsUpdate()

	// New Alignment techniques
	if self:oTop != NIL
		self:oTop:AdjTop()
	endif
	if self:oBottom != NIL
		self:oBottom:AdjBottom()
	endif

	if self:oMsgBar != NIL
		self:oMsgBar:Adjust()
	endif
	if self:oBar != NIL
		self:oBar:Adjust()
	endif

	if self:oLeft != NIL
		self:oLeft:AdjLeft()
	endif
	if self:oRight != NIL
		self:oRight:AdjRight()
	endif

	if self:oClient != NIL
		self:oClient:AdjClient()
	endif

	if self:bResized != NIL
		self:bResized( nSizeType, nWidth, nHeight )
	endif
return
***************
static function fw_say(self, nRow, nCol, cText, nClrFore, nClrBack, oFont, lPixel,;
			lTransparent, nAlign)

	DEFAULT nClrFore := self:nClrText,;
		nClrBack := self:nClrPane,;
		oFont    := self:oFont,;
		lPixel   := .f.,;
		lTransparent := .f.

	if ValType( nClrFore ) == "C"      //  xBase Color string
		nClrBack = nClrFore
		nClrFore = nGetForeRGB( nClrFore )
		nClrBack = nGetBackRGB( nClrBack )
	endif

	//self:GetDC()

	//DEFAULT nAlign := GetTextAlign( self:hDC )

	/*
	WSay( self:hWnd, self:hDC, nRow, nCol, cValToChar( cText ), nClrFore, nClrBack,;
		If( oFont != nil, oFont:hFont, 0 ), lPixel, lTransparent, nAlign )
	*/
	eval(Selector:WSay, self:oClient, nRow, nCol, ToString( cText ), nClrFore, nClrBack,;
		If( oFont != nil, oFont:hFont, 0 ), lPixel, lTransparent, nAlign )
	//self:ReleaseDC()
return
***************
static function fw_sayRect(self, nRow, nCol, cText, nClrFore, nClrBack, nWidth)
return
***************
static function fw_sendMsg(self, nMsg, nWParam, nLParam)
return  eval(Selector:SendMessage,self, nMsg, @nWParam, @nLParam)
***************
static function fw_selColor(IFore)
return
***************
static function fw_setBrush(oBrush)
return
***************
static function fw_setCoors(self, oRect)
	eval(Selector:SetWindowPos, self:hWnd, 0, oRect:nTop, oRect:nLeft,;
		 oRect:nRight - oRect:nLeft + 1,;
		 oRect:nBottom - oRect:nTop + 1, 4 )    // Important:
							// Use 4 for
	self:nTop    = oRect:nTop                               // for keeping
	self:nLeft   = oRect:nLeft                              // ZOrder !!!!
	self:nBottom = oRect:nBottom
	self:nRight  = oRect:nRight
	self:nWidth  = self:nRight-self:nLeft+1
	self:nHeight = self:nBottom-self:nTop+1
return
***************
static function fw_setColor(self, nClrFore, nClrBack, oBrush)
	eval(Selector:FwSetColor,self, nClrFore, nClrBack, oBrush)
return
***************
static function fw_setFocus()
return
***************
static function fw_selFont()
return
***************
static function fw_setFont(self, oFont, nWidth, nHeight)
	eval(Selector:FwSetFont,self, oFont, nWidth, nHeight)
return
***************
static function fw_setMsg(cText, lDefault)

	DEFAULT lDefault := .f.

	if ::oMsgBar != nil   // Thanks to HMP
		if lDefault
			::oMsgBar:cMsgDef := cText
		else
			::oMsgBar:SetMsg( cText )
		endif
	else
		if ::oWnd != nil
			::oWnd:SetMsg( cText )
		endif
	endif
return
***************
static function fw_setPixel(nX, nY, nColor)
return
***************
static function fw_setText(self, cText)
	self:cCaption := cText
	eval(Selector:SetWindowText,self:hWnd, cText)
return
***************
static function fw_sysCommand(nWParam, nLParam)
return
***************
static function fw_timer(nTimerId)
return
***************
static function fw_unLink()
return
***************
static function fw_update()
return
***************
static function fw_lValid(self)
	if self:bValid!=NIL
		return eval(self:bValid)
	endif
return .t.
***************
static function fw_vScroll(nWParam, nLParam)
return
***************
static function fw_nVertRes()
return
***************
static function fw_nHorzRes()
return
***************
static function fw_aEvalWhen(self)
local n
local aControls := self:aControls
   if aControls != nil// .and. ! Empty( aControls )
      for n = 1 to Len( aControls )
	  if aControls[ n ] != nil .and. aControls[ n ]:bWhen != nil
	     if Eval( aControls[ n ]:bWhen )
		self:aControls[ n ]:Enable()   // keep this as self:
	     else
		self:aControls[ n ]:Disable()  // keep this as self:
	     endif
	 endif
      next
   endif

return
***************
static function fw_vbxFireEvent(pEventInfo)
return
***************
static function fw_CheckToolTip(self)
/*
local hWndAct


	if self:cToolTip == nil .and. self:hWnd != hWndParent
		if self:hWnd != hToolTip
			lToolTip = .f.
		endif
	endif

	if self:cToolTip == nil
		if hPrvWnd != self:hWnd
			hPrvWnd  = self:hWnd
		endif
		if oToolTip != nil
			oToolTip:End()
			oToolTip = NIL
		endif
		if oTmr != NIL
			oTmr:End()
			oTmr = NIL
		endif
	else
		if hPrvWnd != self:hWnd
			hWndParent = eval(Selector:GetParent, self:hWnd )
			hPrvWnd    = self:hWnd
			if oToolTip != nil
				oToolTip:End()
				oToolTip = NIL
			endif
			if oTmr != NIL
				oTmr:End()
				oTmr = NIL
			endif
			if lToolTip
				self:ShowToolTip()
			else
				hWndAct = eval(Selector:GetActiveWindow,)

				DEFINE TIMER oTmr INTERVAL self:nToolTip ;
				ACTION ( If( eval(Selector:GetActiveWindow,) == hWndAct,;
				self:ShowToolTip(),), oTmr:End(), oTmr := nil )
				oTmr:hWndOwner = eval(Selector:GetActiveWindow,) // WndApp()

				ACTIVATE TIMER oTmr

			endif
		endif
	endif
*/
return nil
***************
static function fw_ShowToolTip( self, nRow, nCol, cToolTip )
/*
local oFont, aPos, hOldFont, nTxtWidth := 0
local aToolTip, nLenToolTip

	DEFAULT nCol := 7, nRow := self:nHeight() + 7, ;
		cToolTip := self:cToolTip

	if oToolTip == nil

		DEFINE FONT oFont NAME "times" SIZE 0, -8

		DEFINE WINDOW oToolTip FROM 0, 0 TO 1, 5 ;
			STYLE nOr( WS_POPUP, WS_BORDER ) ;
			COLOR 0, RGB( 255, 255, 225 )

		aPos = { nRow, nCol }

		aPos = ClientToScreen( self:hWnd, aPos )

		aToolTip = Array( nLenToolTip := MLCount( cToolTip, 254 ) )
		AEval( aToolTip, {|c, n| aToolTip[ n ] := Trim( MemoLine( cToolTip, 252, n ) ), ;
		nTxtWidth := Max( nTxtWidth, GetTextWidth( 0, aToolTip[ n ], oFont:hFont ) + 7 ) } )

		if aPos[ 2 ] + nTxtWidth + 3 > GetSysMetrics( SM_CXSCREEN )
			aPos[ 2 ] = GetSysMetrics( SM_CXSCREEN ) - nTxtWidth - 3
		endif

		oToolTip:Move( aPos[ 1 ], aPos[ 2 ], nTxtWidth, 14 * nLenToolTip + 3 )
		oToolTip:Show()
		hToolTip = oToolTip:hWnd

		SetBkMode( oToolTip:GetDC(), 1 )
		SetTextColor( oToolTip:hDC, 0 )
		hOldFont = SelectObject( oToolTip:hDC, oFont:hFont )
		AEval( aToolTip, {| c, n | TextOut( oToolTip:hDC, n * 14 - 13, 2, aToolTip[ n ] ) } )
		SelectObject( oToolTip:hDC, hOldFont )
		oToolTip:ReleaseDC()
		oFont:End()

	endif

	lToolTip = .t.
*/
return nil
**************************
static function fw_DestroyToolTip()
/*
	if oToolTip != nil
		oToolTip:End()
		oToolTip = nil
	endif

	hPrvWnd = 0
	hWndParent = 0
*/
return nil

**************************
static function fw_Close(self)
local parentWindow
	parentWindow := self:oWnd
	if parentWindow!=NIL
		eval(Selector:SetFocus,parentWindow)
	endif
	eval(Selector:SendMessage,self:hWnd, HASH_CLOSE_APL)
return .t.
**************************
static function fw_NcMouseMove( self, nHitTestCode, nRow, nCol )

	hWndParent = -1
	hPrvWnd  = -1
	lToolTip = .f.
	if oToolTip != NIL
		oToolTip:End()
		oToolTip = NIL
	endif
	if oTmr != NIL
		oTmr:End()
		oTmr = NIL
	endif

return

