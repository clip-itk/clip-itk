/*   FiveWin likely functions					*/
/*   GTK system functions					*/
/*   Copyright (C) 2001  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   License : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <fwin/FiveWin.ch>
#include <fwin/Constant.ch>
#include <fwin/tcbrowse.ch>
#include <fwin/sysMetrics.ch>
//#include <fwin/WinApi.ch> |\ includig from fivewin.ch
//#include <fwin/font.ch>   |/

#include <clip-gtk.ch>
#include <fwin/msgxpm.ch>
#include <fwin/itk.ch>

#define COLOR_BTNFACE	15
#define COLOR_BTNSHADOW	16
#define COLOR_BTNHIGHLIGHT	20

#define  DRW_SHADOW_NONE	0
#define  DRW_SHADOW_IN		1
#define  DRW_SHADOW_OUT		2
#define  DRW_SHADOW_ETCHED_IN	3
#define  DRW_SHADOW_ETCHED_OUT	4

#define SB_HORZ         0
#define SB_VERT         1
#define SB_CTL          2

/* Menu defines */
#define MF_ENABLED	0	// Normal
#define MF_GRAYED	1	// Disabled and gray
#define MF_DISABLED	2	// Disabled and not gray
#define MF_BITMAP	4	// Single Bitmap
#define MF_CHECKED	8	// It marks of elect
#define MF_POPUP	16	// The item has menu associate popup
#define MF_BREAK	64	// Menu with several columns
#define MF_OWNERDRAW	256	// The item has own drawing
#define MF_SEPARATOR	2048	// Separador
#define MF_HELP 	16384	// Item to right of horizontal bar

/* System defines */
#define CW_USEDEFAULT  32768

/* DC static values */
static DCPoints := map()
static DCPixmap := map()
/* MDI static values */
static __MDIInstance

/* Menu static values */
static aMenuStack := {}
static aMenuAccel := {}
static oLastItem  := {}

/* System static values */
static __FW_INIT := .f.
static hWndApp

init procedure RegisterDriverGTK()
	fw_driver_register("GTK")
return


function GetSelectorGTK()
local selector := map()

selector:GetFwDriver 	:= @GetFwDriver()
selector:isZoomed 	:= @isZoomed()
selector:GetInstance 	:= @GetInstance()
selector:RefreshObj 	:= @RefreshObj()
selector:SetWindowPos 	:= @SetWindowPos()
selector:CreateWindow 	:= @CreateWindow()
selector:CloseAppl 	:= @CloseAppl()
selector:ValueChanged 	:= @ValueChanged()
selector:CoorsUpdate 	:= @CoorsUpdate()
selector:PostChild 	:= @PostChild()
selector:WndCreateError := @WndCreateError()
selector:GetActiveWindow:= @GetActiveWindow()
selector:aSend 		:= @aSend()
selector:WndCenter 	:= @WndCenter()
selector:GetCoors 	:= @GetCoors()
selector:GetClientRect 	:= @GetClientRect()
selector:ShowChildrenControls := @ShowChildrenControls()
selector:ShowWindow 	:= @ShowWindow()
selector:UpdateWindow 	:= @UpdateWindow()
selector:WSay 		:= @WSay()
selector:DragQueryPoint := @DragQueryPoint()
selector:BeginPaint 	:= @BeginPaint()
selector:EndPaint 	:= @EndPaint()
selector:GetTextWidth 	:= @GetTextWidth()
selector:GetWndRect 	:= @GetWndRect()
selector:NexDlgTab 	:= @NexDlgTab()
selector:SetFocus 	:= @SetFocus()
selector:BringWindowToTop:= @BringWindowToTop()
selector:CloseWindow 	:= @CloseWindow()
selector:SetKey 	:= @SetKey()
selector:GetKeyState 	:= @GetKeyState()
selector:IsChild 	:= @IsChild()
selector:SysRefresh 	:= @SysRefresh()
selector:SetCursor 	:= @SetCursor()
selector:CursorArrow 	:= @CursorArrow()
selector:MoveWindow 	:= @MoveWindow()
selector:GetFocus 	:= @GetFocus()
selector:DrawIcon 	:= @DrawIcon()
selector:WndPrint 	:= @WndPrint()
selector:IsIconic 	:= @IsIconic()
selector:InvalidateRect := @InvalidateRect()
selector:RegisterClass 	:= @RegisterClass()
selector:PostMessage 	:= @PostMessage()
selector:DeleteObject 	:= @DeleteObject()
selector:SelectObject 	:= @SelectObject()
selector:FwSetColor 	:= @FwSetColor()
selector:CreateStatusBar:= @CreateStatusBar()
selector:PaintStatusBar := @PaintStatusBar()
selector:MsgPaint 	:= @MsgPaint()
selector:AddMsgItem 	:= @AddMsgItem()
selector:PaintMsgItem 	:= @PaintMsgItem()
selector:WndDrawBox	:= @WndDrawBox()
selector:WindowRaised 	:= @WindowRaised()
selector:WindowBoxIn 	:= @WindowBoxIn()
selector:MsgPaint3L 	:= @MsgPaint3L()
selector:CreateButtonBar:= @CreateButtonBar()
selector:CreateButton 	:= @CreateButton()
selector:GColorNew 	:= @GColorNew()
selector:nGetForeRGB 	:= @nGetForeRGB()
selector:nGetBackRGB 	:= @nGetBackRGB()
selector:CreateFont 	:= @CreateFont()
selector:FwSetFont 	:= @FwSetFont()
selector:ChooseFont 	:= @ChooseFont()
selector:GetFontWidth 	:= @GetFontWidth()
selector:GetFontHeight 	:= @GetFontHeight()
selector:SetChosedFont 	:= @SetChosedFont()
selector:GetDefaultFont := @GetDefaultFont()
selector:SetDefaultFont := @SetDefaultFont()
selector:SizeFont 	:= @SizeFont()
selector:GetFontInfo 	:= @GetFontInfo()
selector:PalBmpLoad 	:= @PalBmpLoad()
selector:PalBmpRead 	:= @PalBmpRead()
selector:PalBmpNew 	:= @PalBmpNew()
selector:CreateDlgBox 	:= @CreateDlgBox()
selector:EndDialog 	:= @EndDialog()
selector:DialogBoxIndirect := @DialogBoxIndirect()
selector:NextDlgTab 	:= @NextDlgTab()
selector:mGetCreate 	:= @mGetCreate()
selector:SetText 	:= @SetText()
selector:SetGetText 	:= @SetGetText()
selector:GetText 	:= @GetText()
selector:CreateLabel 	:= @CreateLabel()
selector:SetWindowText 	:= @SetWindowText()
selector:CreateProgressBar := @CreateProgressBar()
selector:ProgressPaint 	:= @ProgressPaint()
selector:ProgressBarSetTotal := @ProgressBarSetTotal()
selector:CreateCombo 	:= @CreateCombo()
selector:CreateListbox 	:= @CreateListbox()
selector:configure_event:= @configure_event()
selector:expose_event	:= @expose_event()
selector:GetDc 		:= @GetDc()
selector:ReleaseDc 	:= @ReleaseDc()
selector:CreatePen 	:= @CreatePen()
selector:MoveTo 	:= @MoveTo()
selector:LineTo 	:= @LineTo()
selector:CreateSolidBrush := @CreateSolidBrush()
selector:FWBrushes 	:= @FWBrushes()
selector:DrawMsgItem 	:= @DrawMsgItem()
selector:ExtTextOut 	:= @ExtTextOut()
selector:DrawText 	:= @DrawText()
selector:WndBoxIn 	:= @WndBoxIn()
selector:SetTimer 	:= @SetTimer()
selector:KillTimer 	:= @KillTimer()
selector:ReadBitmap 	:= @ReadBitmap()
selector:CreateScrollBar:= @CreateScrollBar()
selector:SetScrollRange := @SetScrollRange()
selector:SetScrollPos 	:= @SetScrollPos()
selector:GetMDIInstance := @GetMDIInstance()
selector:cMdiStruct 	:= @cMdiStruct()
selector:CreateTabs 	:= @CreateTabs()
/* Messages functions */
selector:__MsgBox	:= @__MsgBox()
selector:__MsgAbout	:= @__MsgAbout()
selector:__InitMessageStyle:= @__InitMessageStyle()
selector:__MsgBeep	:= @__MsgBeep()
selector:__ChooseColor	:= @__ChooseColor()
selector:Calendar 	:= @Calendar()
/* Menu function */
selector:IsMenu		:= @IsMenu()
selector:CreateMenu	:= @CreateMenu()
selector:CreatePopupMenu:= @CreatePopupMenu()
selector:GetSystemMenu	:= @GetSystemMenu()
selector:TrackPopup	:= @TrackPopup()
selector:AppendMenu	:= @AppendMenu()
selector:MenuBegin	:= @MenuBegin()
selector:MenuAddItem	:= @MenuAddItem()
selector:MenuEnd	:= @MenuEnd()
selector:SetMenu	:= @SetMenu()
selector:GetSubMenu	:= @GetSubMenu()
selector:DrawMenuBar	:= @DrawMenuBar()
selector:MenuMeasureItem:= @MenuMeasureItem()
/* System functions */
selector:InitFWDriver	:= @InitFWDriver()
selector:lWRunning	:= @lWRunning()
selector:WinRun		:= @WinRun()
selector:WinClose	:= @WinClose()
selector:WinExec	:= @WinExec()
selector:WinHelp	:= @WinHelp()
selector:SetWndApp	:= @SetWndApp()
selector:GetWndApp	:= @GetWndApp()
selector:SendMessage	:= @SendMessage()
selector:GetParent	:= @GetParent()
selector:ClientToScreen	:= @ClientToScreen()
selector:GetSysMetrics	:= @GetSysMetrics()
selector:FileDialog	:= @FileDialog()
selector:KeyboardEvent	:= @KeyboardEvent()
/* WBrowse functions */
Selector:CreateWBrowse	:= @CreateWBrowse()
Selector:ConfigureBrowse:= @ConfigureBrowse()
Selector:CellConfigure	:= @CellConfigure()
Selector:CellGet	:= @CellGet()
Selector:Browser_size_allocate	:= @Browser_size_allocate()

return selector


************************
static function GetFwDriver()
return "GTK"
******************************
static function isZoomed(hWnd)
// HZ it now1111
return .f.
******************
static function GetInstance()
return 0
************
static function RefreshObj(oObj)
	gtk_WidgetShow(oObj)
return
************
static function SetWindowPos(hWnd, xxx, nTop, nLeft, nWidth, nHeight, yyy)
/* It's WINAPI function                                                    */
/* xxx & yyy it's WINAPI pribabah witch Z-order  - stack overlapped window */
	gtk_WidgetSetPosition(hWnd, nLeft, nTop)
	gtk_WidgetSetSize(hWnd, nWidth, nHeight)
	gtk_WidgetRealize(hWnd)
return
************
* Create window with GTK
static function CreateWindow(oWnd, cClsName, cTitle, nStyle, nLeft, nTop, ;
			nWidth, nHeight, hWndOwner, hMenu, cExtraData)
local vBox, hBox, x, y, style, sw, wBorder, lVScroll, lHScroll, decor, nS
local val, low, up
	/*
	if oWnd:className == "FWIN_TMDICHILD"
		gtk_WindowNew(oWnd, iif(cTitle!=NIL, cTitle, oWnd:cCaption), 1)//GTK_WINDOW_POPUP)
	else
		gtk_WindowNew(oWnd, iif(cTitle!=NIL, cTitle, oWnd:cCaption))
	endif
	*/
	gtk_WindowNew(oWnd, iif(cTitle!=NIL, cTitle, oWnd:cCaption))

	//gtk_WindowSetDefaultSize(oWnd, oWnd:nWidth, oWnd:nHeight)
	//gtk_WindowSetPolicy(oWnd, .t., .t.)

	vBox := gtk_VBoxNew()
	hBox := gtk_HBoxNew()
	if oWnd:oTop == NIL
		oWnd:oTop := gtk_VBoxNew()
	endif
	if oWnd:oBottom == NIL
		oWnd:oBottom := gtk_VBoxNew()
	endif
	if oWnd:oLeft == NIL
		oWnd:oLeft := gtk_VBoxNew()
	endif
	if oWnd:oRight == NIL
		oWnd:oRight := gtk_VBoxNew()
	endif
	if oWnd:oClient == NIL
		oWnd:oClient := gtk_LayoutNew()
		oWnd:oClient:nWidth := oWnd:nRight-oWnd:nLeft+20
		oWnd:oClient:nHeight := oWnd:nBottom-oWnd:nLeft+20
		gtk_WidgetSetSize(oWnd:oClient, oWnd:oClient:nWidth, oWnd:oClient:nHeight)
	endif

	gtk_BoxPackStart(hBox, oWnd:oLeft)
	gtk_BoxPackEnd(hBox, oWnd:oRight)

	lVScroll := oWnd:nStyle == numOr(oWnd:nStyle, WS_VSCROLL)
	lHScroll := oWnd:nStyle == numOr(oWnd:nStyle, WS_HSCROLL)
	if lVScroll .or. lHScroll
		sw := gtk_ScrolledWindowNew()
		gtk_BoxPackStart(hBox, sw, .t., .t.)
		gtk_ScrolledWindowAddWithViewport (sw, oWnd:oClient)

		if !lVScroll /* hide vscrollbar */
			gtk_ScrolledWindowSetPolicy(sw, GTK_POLICY_AUTOMATIC, GTK_POLICY_NEVER)
		else
			oWnd:oVScroll := gtk_ScrolledWindowGetVAdjustment(sw)
			gtk_AdjustmentGetValue(oWnd:oVScroll, @val, @low, @up)
			oWnd:oVScroll:Value := val
			oWnd:oVScroll:hOwner := oWnd:handle
			gtk_SignalConnect(oWnd:oVScroll, "value-changed", {|w| ValueChanged(w)})
		endif

		if !lHScroll /* hide hscrollbar */
			gtk_ScrolledWindowSetPolicy(sw, GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC)
		else
			oWnd:oHScroll := gtk_ScrolledWindowGetHAdjustment(sw)
			gtk_AdjustmentGetValue(oWnd:oHScroll, @val, @low, @up)
			oWnd:oHScroll:Value := val
			oWnd:oHScroll:hOwner := oWnd:handle
			gtk_SignalConnect(oWnd:oHScroll, "value-changed", {|w| ValueChanged(w)})
		endif
	else
		gtk_BoxPackStart(hBox, oWnd:oClient, .t., .t.)
	endif

	gtk_BoxPackStart(vBox, oWnd:oTop)
	gtk_BoxPackEnd(vBox, oWnd:oBottom)
	gtk_BoxPackStart(vBox, hBox, .t., .t.)

	gtk_ContainerAdd(oWnd, vBox)


	gtk_SignalConnect(oWnd, 'delete-event', {|w| iif(w:end(), gtk_WidgetHideOnDelete(w), nil)})
	gtk_SignalConnect(oWnd, GTK_HIDE_SIGNAL, {|w| CloseAppl(w)})


	if nLeft!=NIL .and. nLeft != CW_USEDEFAULT
	    gtk_WidgetSetPosition(oWnd, nLeft)
	elseif "NLEFT"$oWnd .and. oWnd:nLeft != CW_USEDEFAULT
	    gtk_WidgetSetPosition(oWnd, oWnd:nLeft)
	endif
	if nTop!=NIL .and. nTop != CW_USEDEFAULT
	    gtk_WidgetSetPosition(oWnd, , nTop)
	elseif "NTOP"$oWnd .and. oWnd:nTop != CW_USEDEFAULT
	    gtk_WidgetSetPosition(oWnd, ,oWnd:nTop)
	endif

	if nWidth!=NIL .and. nWidth != CW_USEDEFAULT
	    gtk_WidgetSetSize(oWnd, nWidth)
	elseif "NWIDTH"$oWnd .and. oWnd:nWidth != CW_USEDEFAULT
	    gtk_WidgetSetSize(oWnd, oWnd:nWidth)
	endif
	if nHeight!=NIL .and. nHeight != CW_USEDEFAULT
	    gtk_WidgetSetSize(oWnd, , nHeight)
	elseif "NHEIGHT"$oWnd .and. oWnd:nHeight != CW_USEDEFAULT
	    gtk_WidgetSetSize(oWnd, , oWnd:nHeight)
	endif

	gtk_WidgetRealize(oWnd)
	oWnd:hWnd := oWnd:Handle

	if cClsName == "FWIN_TMDIFRAME"
		__MDIInstance := oWnd:hWnd
		//gdk_windowLower(oWnd)
	endif


	if cClsName == "FWIN_TMDICHILD"
		outlog('create tmdichild ok. handle=', oWnd:handle)
		gtk_WindowSetTransientFor(oWnd, hWndOwner)
	endif

	gtk_SignalConnect(oWnd, 'size-allocate', {|w, e| CoorsUpdate(w)})

	gtk_WidgetAddEvents(oWnd:oClient, GDK_BUTTON_PRESS_MASK+GDK_BUTTON_RELEASE_MASK+GDK_POINTER_MOTION_MASK)
	x:=0; y:=0
	gtk_SignalConnect(oWnd:oClient, "button-press-event", {|| gdk_WindowGetPointer(oWnd:oClient, @x, @y), oWnd:LbuttonDown(y, x)})

	/* set font default */
	style := gtk_WidgetGetStyle(oWnd)
	gdk_FontUnref(style:font)
	style:font := gdk_FontLoad(, FONT_DEFAULT)
	gdk_FontRef(style:font)
	gtk_WidgetSetDefaultStyle(style)

	/* set decorations */
	decor := 0
	nS := oWnd:nStyle
	/* border */
	if numOr(nS, WS_THICKFRAME) == nS
		decor := numOr(decor, GDK_DECOR_BORDER)
	endif
	/* title */
	if numOr(nS, WS_CAPTION) == nS
		decor := numOr(decor, GDK_DECOR_TITLE)
	endif
	/* sys menu */
	if numOr(nS, WS_SYSMENU) == nS
		decor := numOr(decor, GDK_DECOR_MENU)
	endif
	/* minimize */
	if numOr(nS, WS_MINIMIZEBOX) == nS
		decor := numOr(decor, GDK_DECOR_MINIMIZE)
	endif
	/* maximize */
	if numOr(nS, WS_MAXIMIZEBOX) == nS
		decor := numOr(decor, GDK_DECOR_MAXIMIZE)
	endif
	gtk_WindowSetDecorations(oWnd, decor)


return oWnd:Handle
*************
static function CloseAppl(oWnd)
	gtk_Quit()
return
*************
static function ValueChanged(oAdj)
local value , l, u
	gtk_AdjustmentGetValue(oAdj, @value, @l, @u)

	if value>oAdj:Value .and. "BGODOWN"$oAdj .and. oAdj:bGoDown!= NIL
		eval(oAdj:bGoDown)
	elseif value<oAdj:Value .and. "BGOUP"$oAdj .and. oAdj:bGoUp!= NIL
		eval(oAdj:bGoUp)
	endif
	oAdj:Value := value
return
*************
static function CoorsUpdate(oWnd)
local aItem, i, oLabel
	oWnd:CoorsUpdate()
	if !("OMSGBAR"$oWnd) .or. oWnd:oMsgBar == NIL .or. !gtk_IsWidget(oWnd:oMsgBar)
		return
	endif
	gtk_WidgetSetSize(oWnd:oMsgBar, oWnd:nWidth)
	oWnd:oMsgBar:CoorsUpdate()
	oLabel := gtk_StatusBarGetLabel(oWnd:oMsgBar)
	gtk_WidgetSetSize(oLabel, oWnd:oMsgBar:nWidth-oWnd:oMsgBar:nSizeItem+1)

return
*************
static function PostChild(oWnd, cEvent)
	if "OMSGBAR"$oWnd .and. oWnd:oMsgBar!=NIL
		gtk_SignalEmit(oWnd:oMsgBar, cEvent)
	endif
return
*************
static function WndCreateError(oWnd)
	alert([Window create error]+ " "+oWnd:cTitle)
	outlog(__FILE__, __LINE__, [Window create error]+ " "+oWnd:cTitle)
	quit
return
*************
static function GetActiveWindow(oItem)
local oWnd, hWnd:=-1, aWins, i

	aWins := GetAllWin()

	for i in aWins
		if GTK_WIDGET_VISIBLE(i) .and. GTK_WIDGET_MAPPED(i)
			hWnd := i
			exit
		endif
	next
	/*
	if hWnd == -1
		oWnd := gtk_WidgetGetTopLevel(oItem)

		if oWnd!=NIL
			hWnd := oWnd:handle
		endif
	endif
	*/
return hWnd
*************
//function aSend(aControls, cMsg, hWnd)
static function aSend(aControls, cMsg, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
local i
	do switch upper(cMsg)
	case "INITIATE"
		AEval( aControls, { | oCtrl | oCtrl:Initiate() } )
	case "PAINT"
		aEval( aControls, { | oItem | oItem:Paint() } )
	endswitch

return
*************
static function WndCenter(hWnd, hParent)
local position
	position := iif( hParent=NIL, GTK_WIN_POS_CENTER, GTK_WIN_POS_CENTER_ON_PARENT)
	gtk_windowSetPosition(hWnd, position)
return
************
static function GetCoors(hWnd)
local aRect, nTop, nLeft, nWidth, nHeight
	aRect := map()
	gtk_WidgetGetSize(hWnd, @nWidth, @nHeight)
	gtk_WidgetGetPosition(hWnd, @nLeft, @nTop)
	aRect:Left   := nLeft
	aRect:Top    := nTop
	aRect:Right  := nLeft + nWidth - 1
	aRect:Bottom := nTop + nHeight - 1
return aRect
*************
static function GetClientRect(hWnd)
local x, y, w, h, aRect[4]
	x := 0; y := 0; w := 0; h := 0
	gtk_WidgetGetPosition(hWnd, @x, @y)
	gtk_WidgetGetSize(hWnd, @w, @h)
	aRect[1] := y
	aRect[2] := x
	aRect[3] := y + h - 1
	aRect[4] := x + w - 1
return aRect
*************
static function ShowChildrenControls(oWgt, oWnd)
local i, j, item, aItem

	aItem := gtk_ContainerChildren(oWgt)
	for i=1 to len(aItem)
		if gtk_WidgetGetTypeName(aItem[i]) == "GTK_WIDGET_FIXED"
			aItem := gtk_ContainerChildren(aItem[i])
			exit
		endif
	next
	for i=1 to len(aItem)
		if !('ACONTROLS'$aItem[i]) .or. len(aItem[i]:aControls)==0
			loop
		endif
		for j=1 to len(aItem[i]:aControls)
			item := aItem[i]:aControls[j]
			gtk_WidgetAddAccelerator(item:Handle, GTK_CLICKED_SIGNAL, oWnd, ;
				item:AccelKey, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)
			if aItem[i]:classname == "FWIN_TBAR" .or. aItem[i]:classname == "FWIN_TBTNBAR"

				gtk_ToolBarAppendWidget(aItem[i], item, item:cToolTip)
			else
				gtk_BoxPackStart(aItem[i], item)
			endif
		next
	next
return
*************
static function ShowWindow(oWnd, nShowMode, ret)
local i, item, aItem, val, hFocus, toolt, oRect, style
	do switch nShowMode
	case 1,3 	//NORMAL .or. MAXIMIZED
		for i=1 to len(oWnd:aControls)
			item := oWnd:aControls[i]
			do switch item:className
			case 'FWIN_TTABS'
				gtk_WidgetAddAccelerator(item:Handle, GTK_SWITCH_PAGE_SIGNAL, oWnd, ;
					item:AccelKey, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)
			case 'FWIN_TBUTTON', 'FWIN_TBTNBMP'
				if pcount()>2
					item:nResult := i
					gtk_SignalConnect(item, "clicked", ;
						{|w| ret:=w:nResult})
				endif
				gtk_WidgetAddAccelerator(item:Handle, GTK_CLICKED_SIGNAL, oWnd, ;
					item:AccelKey, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)
				if item:cToolTip!=NIL
					toolt := gtk_ToolTipsNew()
					gtk_ToolTipsSetTip(toolt, item, item:cToolTip, "")
				endif
			//case 'FWIN_TSAY'
			//	gtk_ContainerAdd(oWnd:Client, item)
			case 'FWIN_TCOMBOBOX'
				if "POPUP"$item .and. item:nStyle == CBS_SIMPLE
					gtk_LayoutPut(oWnd:oClient, item:Popup, item:nLeft, item:nTop)
					if oWnd:oClient:nWidth < item:nRight
						oWnd:oClient:nWidth += item:nRight
						gtk_WidgetSetSize(oWnd:oClient, oWnd:oClient:nWidth)
					endif
					if oWnd:oClient:nHeight < item:nBottom
						oWnd:oClient:nHeight += item:nBottom
						gtk_WidgetSetSize(oWnd:oClient, , oWnd:oClient:nHeight)
					endif
				endif
			endswitch
			gtk_LayoutPut(oWnd:oClient, item, item:nLeft, item:nTop)
			if oWnd:oClient:nWidth < item:nRight
				oWnd:oClient:nWidth += item:nRight
				gtk_WidgetSetSize(oWnd:oClient, oWnd:oClient:nWidth)
			endif
			if oWnd:oClient:nHeight < item:nBottom-item:nTop+1
				oWnd:oClient:nHeight += item:nBottom-item:nTop+1
				gtk_WidgetSetSize(oWnd:oClient, , oWnd:oClient:nHeight)
			endif
			if hFocus==NIL
				hFocus := item:handle
				hFocus := iif(gtk_WidgetSetFocus(hFocus), hFocus, NIL)
			endif
		next
		if oWnd:oTop != NIL
			ShowChildrenControls(oWnd:oTop, oWnd)
		endif
		if oWnd:oBottom != NIL
			ShowChildrenControls(oWnd:oBottom, oWnd)
		endif
		if oWnd:oLeft != NIL
			ShowChildrenControls(oWnd:oLeft, oWnd)
		endif
		if oWnd:oRight != NIL
			ShowChildrenControls(oWnd:oRight, oWnd)
		endif
		if nShowMode == 3
			oRect := map()
			oRect:nLeft := 0
			oRect:nTop := 0
			oRect:nRight := gdk_ScreenWidth()
			oRect:nBottom := gdk_ScreenHeight()

			gtk_WidgetSetPosition(oWnd, oRect:nLeft, oRect:nTop)
			gtk_WidgetSetSize(oWnd, oRect:nRight, oRect:nBottom)

			oWnd:SetCoors(oRect)
		endif
		gtk_WidgetShowAll(oWnd:handle)
		if oWnd:classname == "FWIN_TMDIFRAME"
			/*show mdi frame , but does not modify its stacking order.*/
			gdk_WindowLower(oWnd)
		endif
	case 2 	//ICONIZED
	otherwise
		//outlog(__FILE__, __LINE__, oWnd:className, 'handle',iif("HANDLE"$oWnd, oWnd:handle, "no"))
		gtk_WidgetShowAll(oWnd:handle)
	endswitch
	if !empty(oWnd:bPainted)
		eval(oWnd:bPainted)
	endif
	gtk_WidgetSetFocus(oWnd)
	//outlog(__FILE__, __LINE__, "check visible",GTK_WIDGET_VISIBLE(oWnd), 'focus', GTK_WIDGET_HAS_FOCUS(oWnd), 'mapped', GTK_WIDGET_MAPPED(oWnd))
return
*************
static function UpdateWindow(oWnd)
// Ëë¨ðêË ¬Åðëµ Êê¦µµ ¬ëÊ. þËë áë‘êëÊË´ ðë§ë÷ ÁëÊµáå
return
************
static function WSay( oWnd, nRow, nCol, cText, nClrFore, nClrBack,;
		hFont, lPixel, lTransparent, nAlign )
local lb
	lb := gtk_LabelNew(, cText)
	nRow := nRow*iif(lPixel, 1, WIN_CHARPIX_H)
	nCol := nCol*iif(lPixel,1, WIN_CHARPIX_W)

	gtk_LayoutPut(oWnd, lb, nCol, nRow)
	gtk_WidgetShowAll(oWnd)
return
*************
static function DragQueryPoint(hDrop, aPoint)
local lDrop:= .f.
	if hDrop == NIL .or. hDrop:hWnd == 0
		return lDrop
	endif
return lDrop
**************
static function BeginPaint(hWnd, cPS)
local hDC
	hDC := GetDC(hWnd)
return hDC
**************
static function EndPaint(oWnd, cPS)

	if !empty(oWnd:hDC)
		expose_event(gtk_getObjByHandle(oWnd:hDC), ,oWnd:hWnd)
	endif

	releaseDC(oWnd:hWnd, oWnd:hDC)
return
***************
//function GetTextWidth(hDC, cText, oFont)
static function GetTextWidth(cText, hFont)
local style

	if hFont==NIL .or. empty(hFont)
		style := gtk_WidgetGetDefaultStyle()
		hFont := style:font:handle
	endif
return gdk_TextWidth(hFont, cText, len(cText))
**************
static function GetWndRect(hWnd)// --> window coors
local aRect, nTop, nLeft, nWidth, nHeight
	aRect := map()
	gtk_WidgetGetSize(hWnd, @nWidth, @nHeight)
	gtk_WidgetGetPosition(hWnd, @nLeft, @nTop)
	aRect:Left   := nLeft
	aRect:Top    := nTop
	aRect:Right  := nLeft + nWidth - 1
	aRect:Bottom := nTop + nHeight - 1
return aRect
****************
static function NexDlgTab(hWnd, hCtrl, lNext)
local i, nStep, nEnd, nLen, ret:= -1, item
	if hWnd==NIL .or. hWnd==0
		return ret
	endif
	item := gtk_GetObjByHandle(hWnd)
	nLen := len(item:aControls)
	if hCtrl==NIL .or. !between(hCtrl, 1, nLen)
		return ret
	endif
	lNext := iif(lNext==NIL, .f., lNext)
	i := hCtrl
	if !lNext
		nStep := 1
		nEnd := nLen
	else
		nStep := -1
		nEnd := 1
	endif
	do while .t.
		if item:aControls[i]:hWnd != 0
			ret := item:aControls[i]:hWnd
			item:hCtlFocus := ret
			exit
		endif
		i += nStep
		if i>nLen
			i := 1
		endif
		if i<1
			i := nLen
		endif
	enddo

return ret
******************
* set focus new window and send KILL_FOCUS to prev window, return handle of prew window
static function SetFocus(hCtrl)
local ret
	if hCtrl<0
		return
	endif
	ret := gtk_WidgetSetFocus(hCtrl)
return ret
****************
static function BringWindowToTop(hWnd)
local lTop:=.f.
	// go top ­ HSCROLL or VSCROLL??????
return lTop
************
static function CloseWindow(hWnd)
local ret
	ret := SendMessage(hWnd, WS_MINIMIZE)
return ret
*************
static function SetKey(nKey)
//  ê éµ‘®îë ¬Åðëµ Å ¬ë ¬êáµ, Ëáëµê¬ê á‘´ Ëµ­ÁëËÊÅÁµËÊÅ
return NIL
**************
static function GetKeyState(nKey)
local lPressed := .f.
	switch nKey
	case 0//VK_CONTROL
		// ª íÊµ §êéµÊêëÊ Êµ‘®¦µ Ë §êËîÅ§ë¬¬µ¨ ¦‘ê­ÅêÊ×§µ¨ :( ???????
		lPressed := iif(kbdstat()==0x4, .t., .f.)
	endswitch
return lPressed
****************
static function IsChild(hWndParent, hWndChild)
local lSuccess := .f., i, oParent
	if hWndParent==NIL .or. hWndParent==0
		return lSuccess
	endif
	oParent := gtk_GetObjByHandle(hWndParent)
	for i=1 to len(oParent:aControls)
		lSuccess := (oParent:aControls[i]:hWnd == hWndChild)
		if lSuccess
			exit
		endif
	next
return lSuccess
************
static function SysRefresh()
local lQuit

	do while gtk_EventsPending()
		gtk_MainIteration()
	enddo
return lQuit
*******************
* set user cursor type
static function SetCursor(hNewCursor)
local hOldCursor
return hOldCursor
******************
* set traditions arrow cursor
static function CursorArrow()
return
******************
static function MoveWindow( hWnd, nTop, nLeft, nWidth, nHeight, lRepaint )
local ret:=.f., item
	if hWnd==NIL .or. hWnd==0
		return ret
	endif
	if nTop==NIL .or. nLeft==NIL .or. nWidth==NIL .or. nHeight==NIL
		return ret
	endif
	DEFAULT lRepaint TO .t.

	gtk_WidgetSetPosition(hWnd, nLeft, nTop)
	gtk_WidgetSetSize(hWnd, nWidth, nHeight)
	/*
	item := aWindows[hWnd]
	item:moveWindow(nTop, nLeft, nWidth, nHeight)
	if lRepaint
		item:update()
	endif
	*/
return .t.
****************
static function GetFocus()
local nCurHandle
return nCurHandle
*****************
static function DrawIcon(hDC, nRow, nCol, hIcon)
local lSuccess:=.f.
return lSuccess
*********************
static function WndPrint( hWnd, hDC, nRow, nCol, nScale )
* …ê¦ê´-Êµ ¡ëðêÊê‘¦ê ­Å¬áµ­ê´
* ËÁ. source/WINAPI/WNDPRINT.C Ð×¬¦öÅä WNDPRINT
*
return
*******************
static function IsIconic(hWnd)
local lIconic:=.f.
return lIconic
********************
static function InvalidateRect(hWnd, param1, param2)
local aRect:=map(), lRepaint, x, y, w, h
	if param1 != NIL .and. valtype(param1) == "A"
		if param2 != NIL .and. valtype(param2) == "L"
			lRepaint := param2
		else
			lRepaint := .t.
		endif
		x := param1[1]
		y := param1[2]
		w := param1[3]-x+1
		h := param1[4]-y+1
	else
		if param1 != NIL .and. valtype(param1) == "L"
			lRepaint := param1
		else
			lRepaint := .t.
		endif
		gtk_WidgetGetPosition(hWnd, x, y)
		gtk_WidgetGetSize(hWnd, w, h)
	endif
	if lRepaint
		/* "Virtual screen" for Device context */

		if hWnd $ DCPixmap
			/*
			gtk_WidgetDestroy(DCPixmap[hWnd])
			adel(DCPixmap, hWnd)
			*/
			gtk_SignalEmit(DCPixmap[hWnd], 'configure-event')
		endif

		//gtk_SignalEmit(hWnd, "configure-event")
		gtk_WidgetDraw(hWnd)
	endif
return
***********
static function RegisterClass(cClassName, nStyle, nClsExtra, nWndExtra, hCursor, hBrush,;
			cMenuName, nWndProc)
local lSuccess:=.t.

return lSuccess
*****************
static function PostMessage(hWnd, cMsg, nWParam, nLParam)
	if gtk_isWidget(hWnd)
		gtk_SignalEmit(hWnd, cMsg)
	endif
return
**************
static function DeleteObject(hObj)

//	if gtk_IsWidget(hObj)  - for cygwin it has SigSegv for OBJECT
	if "WIDGET" $ gtk_WidgetGetTypeName(hObj)
		gtk_WidgetDestroy(hObj)
	else
		gtk_ObjectDestroy(hObj)
	endif
return
**************
* set brush to draw
static function SelectObject(hDC, hPen)
local hOldObj, oDC, style
	oDC := gtk_GetObjByHandle(hDC)

	if "HPEN"$oDC
		hOldObj := oDC:hPen
	else
		style := gtk_WidgetGetStyle(hDC)
		hOldObj := style:fg_gc[1]
	endif
	oDC:hPen := hPen

return hOldObj
*************
static function FwSetColor(oWnd, nClrFore, nClrBack, oBrush)
local oStyle:=map(), clr
	if ValType( nClrFore ) == "C"
		nClrBack = nClrFore                   // It is a dBase Color string
		nClrFore = nGetForeRGB( nClrFore )
		nClrBack = nGetBackRGB( nClrBack )
	endif
	oWnd:nClrText = nClrFore
	oWnd:nClrPane = nClrBack

	oStyle := gtk_WidgetGetStyle(oWnd)

	if !("COLORMAP"$oStyle)
		oStyle:colormap := gtk_WidgetGetColormap(oWnd)
	endif
	if nClrFore != NIL
		clr := gdk_ColorRGB(nClrFore)
		gdk_ColorMapAllocColor(oStyle:colormap, clr)
		oStyle:FG_color := {clr, clr, clr, clr, clr}
		//oStyle:BASE_color := {clr, clr, clr, clr, clr}
	endif

	if nClrBack != NIL
		clr := gdk_ColorRGB(nClrBack)
		gdk_ColorMapAllocColor(oStyle:colormap, clr)
		oStyle:BG_color := {clr, clr, clr, clr, clr}
	endif

	if ("HANDLE"$oWnd)
		do switch oWnd:className
		case "FWIN_TBUTTON", "FWIN_BTNBMP"
			gtk_ButtonSetStyle(oWnd, oStyle)
		otherwise
			gtk_WidgetSetStyle(oWnd, oStyle)
		endswitch
	endif
	if ("FIXED"$oWnd)
		gtk_WidgetSetStyle(oWnd:fixed, oStyle)
	endif
	/****** it in future
	if oWnd:oBrush != nil
		oWnd:oBrush:End()
	endif
	if oBrush != nil
		oWnd:oBrush = oBrush
	else
		oWnd:oBrush = TBrush():New(,nClrBack,)
	endif
	*/
return
************
static function CreateStatusBar(oMsgBar)
local oLabel, fixed
	oMsgBar := gtk_StatusBarNew(oMsgBar)
	oMsgBar:hWnd := oMsgBar:Handle
	fixed := gtk_FixedNew()

	gtk_BoxSetSpacing(oMsgBar, 2)
	gtk_WidgetSetSize(oMsgBar, oMsgBar:nWidth, oMsgBar:nHeight)

	gtk_StatusBarSetText(oMsgBar, oMsgBar:cMsg)


	gtk_FixedPut(fixed, oMsgBar:hWnd, 0, 0)
	gtk_BoxPackStart(oMsgBar:oWnd:oBottom, fixed, .t., .t.)
	//gtk_SignalConnect(oMsgBar, "expose-event",{|w, e| w:paint()})
	if oMsgBar:lCentered
		oLabel := gtk_StatusBarGetLabel(oMsgBar)
		gtk_MiscSetAlignment(oLabel, 0.5, 0.5)
		gtk_WidgetSetSize(oLabel, oMsgBar:nWidth-oMsgBar:nSizeItem)
	endif
	oMsgBar:fixed := fixed

	//gtk_SignalConnect(oMsgBar:oWnd:oBottom, 'size-allocate', {|w, e| qout('call coorsUpdate for Msgbar'),oMsgBar:CoorsUpdate()})
return
***************
static function PaintStatusBar(hWnd, cMsg, cMsgDef, lErase, lCentered, nWidth, nClrText, nClrPane, hFont, lInset)
local style, oLabel, oMsgBar
	DEFAULT lErase    TO .f.
	DEFAULT lInset    TO .f.
	DEFAULT lCentered TO .f.
	DEFAULT nClrText  TO 0
	DEFAULT nClrPane  TO GetSysColor( COLOR_BTNFACE )

	gtk_StatusBarSetText(hWnd, iif(cMsg==NIL .or. empty(cMsg), cMsgDef, cMsg))
	oLabel := gtk_StatusBarGetLabel(hWnd)
	style := gtk_WidgetGetStyle(hWnd)
	oMsgBar := gtk_GetObjByHandle(hWnd)
	gtk_WidgetSetSize(oLabel, oMsgBar:nWidth-oMsgBar:nSizeItem)
	gtk_WidgetSetStyle(oLabel, style)
return
*****************
static function MsgPaint(hMsgBar, cMsg, cMsgDef, lErase, lCentered, nWidth, nClrText, nClrPane, oFont, lInset)
local oLabel, style, oMsgBar

	DEFAULT lErase    TO .f.
	DEFAULT lInset    TO .f.
	DEFAULT lCentered TO .f.
	DEFAULT nClrText  TO 0
	DEFAULT nClrPane  TO GetSysColor( COLOR_BTNFACE )

	oLabel := gtk_StatusBarGetLabel(hMsgBar)
	style := gtk_WidgetGetStyle(hMsgBar)
	gtk_WidgetSetStyle(oLabel, style)

	oMsgBar := gtk_GetObjByHandle(hMsgBar)
	gtk_WidgetSetSize(oLabel, oMsgBar:nWidth-oMsgBar:nSizeItem)


	gtk_LabelSetText(oLabel, iif(cMsg==NIL .or. empty(cMsg), cMsgDef, cMsg))

return
****************************
static function AddMsgItem(hMsgBar, oItem)
local button, toolt, frame, style

	style := gtk_WidgetGetStyle(hMsgBar)
	frame := gtk_FrameNew()
	gtk_frameSetShadowType(frame, GTK_SHADOW_IN)
	button := gtk_ButtonNew(oItem, oItem:cMsg)
	gtk_ButtonSetStyle(button, style)
	oItem:hWnd := button:handle
	gtk_ButtonSetRelief(button, GTK_RELIEF_NONE)
	if oItem:cToolTip != NIL .and. !empty(oItem:cToolTip)
		toolt := gtk_toolTipsNew()
		gtk_ToolTipsSetTip(toolt, button, oItem:cToolTip, "")
	endif
	if "BACTION"$oItem .and. oItem:bAction != NIL
		gtk_SignalConnect(oItem, "clicked", {|w, e| w:bAction()})
	endif
	gtk_ContainerAdd(frame, button)
	gtk_BoxPackStart(hMsgBar, frame)

return
****************************
static function PaintMsgItem(hItem, cMsg, hMsgBar)
	if gtk_IsWidget(hItem)
		gtk_ButtonSetLabel(hItem, cMsg)
		gtk_WidgetShowAll(hItem)
	endif
return
****************************
static function  WndDrawBox( hDC, rct, hPUpLeft, hPBotRit )
local hOldPen, pt

	hOldPen := SelectObject( hDC, hPUpLeft )

	MoveTo( hDC, rct[2], rct[3] )

	LineTo( hDC, rct[2], rct[1] )
	LineTo( hDC, rct[4], rct[1] )
	SelectObject( hDC, hPBotRit )

	MoveTo( hDC, rct[2], rct[3] )

	LineTo( hDC, rct[4], rct[3] )
	LineTo( hDC, rct[4], rct[1] - 1 )
	SelectObject( hDC, hOldPen )
return
*********************
static function WindowRaised(hDC, aRect)
local hGrey, hWhite, style
/*
	hGray  := CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) )
	hWhite := CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) )

	WndDrawBox( hDC, aRect, hWhite, hGray )

	DeleteObject( hGray )
	DeleteObject( hWhite )
*/
	style := gtk_WidgetGetStyle(hDC)
	gtk_DrawBox(hDC, style, DRW_SHADOW_NONE, aRect[2], aRect[1], aRect[4]-aRect[2]+1, aRect[3]-aRect[1]+1)
return
*********************
static function WindowBoxIn( hDC, pRect )
local hGrey, hWhite, style
/*
	hGray  := CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) )
	hWhite := CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) )

	WndDrawBox( hDC, pRect, hGray, hWhite )

	DeleteObject( hGray )
	DeleteObject( hWhite )
*/
	style := gtk_WidgetGETStyle(hDC)
	gtk_DrawBox(hDC, style, DRW_SHADOW_IN, pRect[2], pRect[1], pRect[4]-pRect[2]+1, pRect[3]-pRect[1]+1)

return
*********************
static function MsgPaint3L(hMsgBar)
* HZ - what it is?
return
************
static function CreateButtonBar(self, cMode)
local width, height, fixed
	cMode := iif(cMode==NIL, "TOP", upper(cMode))
	fixed := gtk_FixedNew()

	if "OWND" $ self .and. "OBAR" $ self:oWnd
		self:oWnd:oBar := self
		do switch cMode
		case "BOTTOM"
			self := gtk_ToolBarNew(self, GTK_ORIENTATION_HORIZONTAL)
			self:hWnd := self:Handle
			gtk_BoxPackStart(self:oWnd:oBottom, fixed)
			gtk_FixedPut(fixed, self:hWnd, 0, 0)
		case "LEFT"
			self := gtk_ToolBarNew(self, GTK_ORIENTATION_VERTICAL)
			self:hWnd := self:Handle
			gtk_BoxPackStart(self:oWnd:oLeft, fixed)
			gtk_FixedPut(fixed, self:hWnd, 0, 0)
			//gtk_BoxPackStart(self:oWnd:oLeft, gtk_VSeparatorNew())
		case "RIGHT"
			self := gtk_ToolBarNew(self, GTK_ORIENTATION_VERTICAL)
			self:hWnd := self:Handle
			gtk_BoxPackStart(self:oWnd:oRight, fixed)
			gtk_BoxPackStart(self:oWnd:oRight, gtk_VSeparatorNew())
			gtk_FixedPut(fixed, self:hWnd, 0, 0)
		otherwise
			self := gtk_ToolBarNew(self)
			self:hWnd := self:Handle
			gtk_BoxPackStart(self:oWnd:oTop, fixed)
			gtk_FixedPut(fixed, self:hWnd, 0, 0)
			gtk_BoxPackStart(self:oWnd:oTop, gtk_HSeparatorNew())
	endswitch
	endif
	self:fixed := fixed
	FwSetColor(self, self:nClrText, self:nClrPane)
	FwSetFont(self, self:oFont)
return
************
static function CreateButton(self)
local box
	if self:classname == "FWIN_TBUTTON"
		self := gtk_ButtonNew(self, self:cCaption, "&")
		self:hWnd := self:Handle
	else  //FWIN_TBTNBMP
		self := gtk_ButtonNew(self)
		self:hWnd := self:Handle
		self:oBox := gtk_VBoxNew()
		gtk_containerAdd(self, self:oBox)
		if self:cCaption != NIL
			gtk_BoxPackEnd(self:oBox, gtk_LabelNew(, self:cCaption))
		endif
	endif

	FwSetColor(self, self:nClrText, self:nClrPane)
	FwSetFont(self, self:oFont)

	gtk_SignalConnect(self, "enter", {|w, e|  w:GotFocus(getActiveWindow())})
	gtk_SignalConnect(self, "leave", {|w, e|  w:LostFocus()})
	gtk_SignalConnect(self, "focus-in-event", {|w, e|  w:GotFocus(getActiveWindow())})
	gtk_SignalConnect(self, "focus-out-event", {|w, e|  w:LostFocus()})

	if "BACTION" $ self
		gtk_SignalConnect(self, "clicked", {|w, e| w:bAction()})
	endif


	if "OWND" $ self .and. self:oWnd != NIL
		if self:oWnd:classname == "FWIN_TBAR"
			gtk_WidgetSetSize(self, self:oWnd:nBtnWidth, self:oWnd:nBtnHeight)
		endif
	endif
return
/*****************************************************************************
Font Funciton
*****************************************************************************/
static function GColorNew(Red, Green, Blue, Opacity)
local color
	Red := iif(Red==NIL, 0, Red)
	Green := iif(Green==NIL, 0, Green)
	Blue := iif(Blue==NIL, 0, Blue)
	Opacity := iif(Opacity==NIL, 65535, Opacity)

	color := map()
	color:Red := Red
	color:Green := Green
	color:Blue := Blue
	color:Opacity := Opacity

return color
********************
static function nGetForeRGB(clr)
return
static function nGetBackRGB(clr)
return
*************************
static function CreateFont(cFont)
local oFont, ret :=NIL
	oFont := gdk_FontLoad(, cFont)
	if oFont!=NIL
		ret:= oFont:Handle
	endif
return ret
*************
static function FwSetFont(oWnd, oFont, nWidth, nHeight)
local aFont, val, wid, style:=map()

	nWidth := iif(nWidth==NIL, SAY_CHARPIX_W, nWidth)
	nHeight := iif(nHeight==NIL, SAY_CHARPIX_H, nHeight)

	if oWnd:oFont != nil .and. "HFONT"$oWnd:oFont .and. oWnd:oFont:hFont != oFont:hFont
		oWnd:oFont:End()
	endif

	style := gtk_WidgetGetStyle(oWnd)

	gdk_FontUnref(style:font)

	if oFont != nil .and. !empty(oFont)
		if oFont:cFontDescription==NIL
			oFont:cFontDescription := FONT_DEFAULT
		endif
		aFont := split(oFont:cFontDescription, "-")
		aDel(aFont, 1)
		aSize(aFont, 14)
		if aFont[7] == "*"
			aFont[7] = nWidth
		endif
		oFont:cFontDescription := ""
		for val in aFont
			oFont:cFontDescription += "-"+alltrim(toString(val))
		next
		oWnd:oFont = oFont
		if oFont:nCount == nil
			oFont:nCount = 0
		endif
		oFont:nCount++
		style:Font := gdk_FontLoad(, oFont:cFontDescription)
	else
		style:Font := gdk_FontLoad(, FONT_DEFAULT)
	endif
	gdk_FontRef(style:font)
	gtk_WidgetSetStyle(oWnd, style)
	do switch oWnd:className
	case "FWIN_TMSGBAR"
		wid := gtk_StatusBarGetLabel(oWnd)
		gtk_WidgetSetStyle(wid, style)
	case "FWIN_TBUTTON", "FWIN_BTNBMP"
		gtk_ButtonSetStyle(oWnd, style)
	otherwise
		gtk_WidgetSetStyle(oWnd, style)
	endswitch
return
***************
static function ChooseFont(self, nRGBColor)
local fsd, cFont

	FWInitDriver()

	fsd:=gtk_FontSelectionDialogNew(,[Font Selection Dialog window])
	gtk_WidgetSetName(fsd, [Font selection dialog])
	gtk_WindowSetModal(fsd)
	gtk_WidgetSetPosition(fsd,200,300)
	gtk_WidgetShowAll(fsd:ApplyButton)
	//gtk_FontSelectionDialogSetFontName(fsd,l:Style:Font)
	gtk_SignalConnect(fsd,"delete-event",{|wid,ev|gtk_Quit()})
	gtk_SignalConnect(fsd:OkButton,"clicked",{|wid,ev|SetChosedFont(@cFont, fsd),gtk_WidgetHide(fsd)})
	gtk_SignalConnect(fsd:ApplyButton,"clicked",{||SetChosedFont(@cFont, fsd)})
	gtk_SignalConnect(fsd:CancelButton,"clicked",{|wid,ev|gtk_WidgetHide(fsd)})
	gtk_WidgetShow(fsd)
	gtk_Main()
return cFont
******************
static function GetFontWidth(hFont)
return gdk_CharWidth(hFont, "W")
******************
static function GetFontHeight(hFont)
return gdk_CharHeight(hFont, "W")
******************
static function SetChosedFont(cFont, fsd)
	cFont := gtk_FontSelectionDialogGetFontName(fsd)
return
********************
static function GetDefaultFont()
local oFont
	oFont := gtk_WidgetGetDefaultStyle()
return oFont
********************
static function SetDefaultFont(oFont)
	oFont := gtk_WidgetSetDefaultStyle(oFont)
return oFont
********************
static function SizeFont(hFont)
return gdk_StringHeight(hFont, "A")
***************
static function GetFontInfo(hFont)// --> struct font
//1 - nHeight
//2 - nWidth
//3 - lBold
local aFontInfo
return aFontInfo
/*****************************************************************************
Pixmap  function
*****************************************************************************/
static function PalBmpLoad(cResName)
local hBmpPal
return hBmpPal
****************
static function PalBmpRead(oWnd, cBmpFile)
local hBmpPal, s:="", i
	i := atr(".", cBmpFile)
	if i>0
		s := upper(substr(cBmpFile, i+1))
	endif
	if s == "XPM"
		hBmpPal := gtk_PixmapNew(, cBmpFile, oWnd)
	elseif s == "BMP"
		hBmpPal := gtk_PixmapFromBmpNew(, cBmpFile, oWnd)
	endif
return hBmpPal:handle
*************
static function PalBmpNew(oBtn, hBmpPal)
	gtk_BoxPackStart(oBtn:oBox, hBmpPal)
return
/*****************************************************************************
Dialog box function
*****************************************************************************/
static function CreateDlgBox(oDlg)

	oDlg := gtk_DialogNew(oDlg, oDlg:cCaption)
	oDlg:hWnd := oDlg:handle
	gtk_WidgetSetPosition(oDlg, oDlg:nLeft, oDlg:nTop)
	gtk_WidgetSetSize(oDlg, oDlg:nWidth, oDlg:nHeight)

	/* create client area in dialog */
	oDlg:oClient := gtk_LayoutNew()
	gtk_WidgetSetSize(oDlg:oClient, oDlg:nWidth, oDlg:nHeight)
	oDlg:oClient:nWidth := oDlg:nWidth
	oDlg:oClient:nHeight := oDlg:nHeight

	gtk_ContainerAdd(oDlg:VBox, oDlg:oClient)

	/* set modal */
	gtk_WindowSetModal(oDlg, oDlg:lModal)

return oDlg
************
static function EndDialog(oDlg, nResult)
local parentWindow
	parentWindow := oDlg:oWnd
	oDlg:nResult := nResult
	gtk_SignalEmit(oDlg, 'hide')
return
**************
static function DialogBoxIndirect(hInstance, cResName, hActiveWnd, oDlg)
local i, nResult, hFocus

	oDlg:Initiate(, oDlg:handle)
	nResult := -1000
	if hActiveWnd!= NIL .and. hActiveWnd != oDlg:handle
		gtk_WindowSetTransientFor(oDlg, hActiveWnd)
	endif

	gtk_SignalConnect(oDlg, GTK_DELETE, {|oWnd| iif(oWnd:end(),gtk_WidgetHideOnDelete(oDlg), )})
	gtk_SignalConnect(oDlg, GTK_HIDE_SIGNAL, {|| gtk_WidgetDestroy(oDlg), gtk_Quit()})

	ShowWindow(oDlg, 1, @nResult)

	gtk_SignalConnect(oDlg, 'focus-in-event', ;
		{|w, e| oDlg:GotFocus(), oDlg:HandleEvent(WM_PAINT)})


	/*
	gtk_SignalConnect(oDlg, GTK_MAP, {|w, e| oDlg:GotFocus(), oDlg:HandleEvent(WM_PAINT)})
	*/

	gtk_WidgetShowAll(oDlg)

	/* hide action area and insert Layout into Vbox */
	gtk_WidgetHide( oDlg:ActionArea )


	gtk_Main()

return nResult
**************
static function NextDlgTab(oWnd, hControl, lPrev)
local hCtrl, _step:=1, hC:=1, nLen, oControl1, oControl2
	lPrev := iif(lPrev==NIL, .f., lPrev)
	nLen := len(oWnd:aControls)
	if lPrev
		_step := -1
	endif
	aEval(oWnd:aControls, {|x,y| iif(x:handle==hControl, hC:=y, nil)})
	hC += _step
	if hC<1
		hC := nLen
	endif
	if hC>nLen
		hC := 1
	endif
	if hC <= nLen
		oControl1 := gtk_getObjByHandle(hControl)
		if oControl1:LostFocus()
			hCtrl := oWnd:aControls[hC]:handle
			oControl2 := gtk_getObjByHandle(hCtrl)
			oControl2:setFocus()
		else
			hCtrl := hControl
		endif
	endif
return hCtrl
/*****************************************************************************
Get function
*****************************************************************************/
static function mGetCreate(oEntry, cCaption, nStyle, nLeft, nTop, nWidth, ;
			   nHeight, hWnd, nId, hHeap )
local hFunc := oEntry:KeyChar
	oEntry := gtk_EntryNew(oEntry, 100)
	gtk_EntrySetText(oEntry, cCaption)
	gtk_WidgetSetPosition(oEntry, nLeft, nTop)
	gtk_WidgetSetSize(oEntry, nWidth+6, nHeight+6)
	gtk_EntrySetPosition(oEntry, oEntry:nPos-1)  // entry position started with 0
	gtk_SignalConnect(oEntry, GTK_EVENT, {|wgt, ev| wgt:KeyChar(ev) })

	//if "CMSG"$oEntry .and. oEntry:cMsg != NIL
		/* mouse cursor enters on button region */
		//gtk_SignalConnect(oEntry, "enter", {|w, e| w:GotFocus(GetActiveWindow())})
		//gtk_SignalConnect(oEntry, "focus-in-event", {|w, e| w:GotFocus(GetActiveWindow())})
		/* mouse cursor leave button region */
		//gtk_SignalConnect(oEntry, "leave", {|w, e| w:LostFocus()})
		//gtk_SignalConnectAfter(oEntry, "focus-out-event", {|w, e| (local(x), x:=w:hWnd, iif(gtk_widgetHasFocus(w) .and. w:LostFocus(), .t., gtk_WidgetSetFocus(x)), .t.)})
	//endif
return oEntry:handle
*************
static function SetText(oEntry, uVal)
	if gtk_WidgetGetTypeName(oEntry) == "GTK_TYPE_ENTRY"
		gtk_EntrySetText(oEntry, ToString(uVal))
		gtk_EntrySetPosition(oEntry, 0)
	endif
return
*************
static function SetGetText(hEntry, uVal, nPos)
	gtk_EntrySetText(hEntry, ToString(uVal))
	if nPos != nil
		gtk_EntrySetPosition(hEntry, nPos-1)
	endif
return uVal
******************
static function GetText(oWnd)
local str := ""
	if oWnd:ClassName == "FW_TGET"
        	str := gtk_EntryGetText(oWnd)
        endif
return str
/*****************************************************************************
Label function
*****************************************************************************/
static function CreateLabel(oWnd)
	oWnd := gtk_LabelNew(oWnd, oWnd:cCaption, "&")
	oWnd:hWnd := oWnd:handle
	gtk_WidgetSetPosition(oWnd, oWnd:nLeft, oWnd:nTop)
	gtk_WidgetSetSize(oWnd, oWnd:nWidth, oWnd:nHeight)
return
**************
static function SetWindowText(hWnd, cText)
local cType
	cType := gtk_WidgetGetTypeName(hWnd)
	do switch cType
	case "GTK_WIDGET_LABEL"
		gtk_LabelSetText(hWnd, cText, "&")
	case "GTK_WIDGET_DIALOG", "GTK_WIDGET_WINDOW"
		gtk_WindowSetTitle(hWnd, cText)
	endswitch
return
/*****************************************************************************
Progress Bar function
*****************************************************************************/
static function CreateProgressBar(oMeter)
local oStyle:=map(), clr, st
	oMeter := gtk_ProgressBarNew(oMeter)
	oMeter:hWnd := oMeter:handle

	gtk_WidgetSetSize(oMeter, oMeter:nWidth)
	//gtk_ProgressSetActivityMode(oMeter, .f.)
	//gtk_ProgressSetShowText(oMeter, .t.)
	//gtk_ProgressSetTextAlignment(oMeter, 0.5, 0.5)
	gtk_ProgressBarSetOrientation(oMeter, GTK_PROGRESS_LEFT_TO_RIGHT)
	gtk_ProgressBarSetBarStyle(oMeter, GTK_PROGRESS_CONTINUOUS)

	//gtk_ProgressBarSetActivityStep(oMeter, 5)
	//gtk_ProgressBarSetActivityBlocks(oMeter, oMeter:nTotal)
	//gtk_ProgressSetFormatString(oMeter, oMeter:cText)
	//gtk_ProgressConfigure(oMeter, 1, 1, oMeter:nTotal)
	//oStyle := gtk_WidgetGetStyle(oMeter)
	if oMeter:nClrBar != NIL
		clr := gdk_ColorRGB(oMeter:nClrBar)
		oStyle:BG_color := {, , clr}

	endif
	if oMeter:nClrBText != NIL
		clr := gdk_ColorRGB(oMeter:nClrBText)
		oStyle:FG_color := clr

	endif
	gtk_WidgetSetStyle(oMeter, oStyle)

return
************
static function ProgressPaint(oMeter, nActual)
	gtk_ProgressSetPercentage(oMeter, nActual)
	gtk_WidgetDraw(oMeter)
	//gtk_WidgetShow(oMeter)
return
************
static function ProgressBarSetTotal(oMeter, nTotal)
	oMeter:nTotal := nTotal
	gtk_ProgressConfigure(oMeter, 0, 0, oMeter:nTotal)
return
/*****************************************************************************
Combo function
*****************************************************************************/
static function CreateCombo(oCombo)
local Style, clrFore, clrBack
	do switch oCombo:nStyle
	case CBS_SIMPLE
		oCombo := gtk_ComboSimpleNew(oCombo)
		oCombo:Popup:nLeft := oCombo:nLeft
		oCombo:Popup:nTop := oCombo:nBottom+5
		oCombo:Popup:nWidth := oCombo:nWidth
		oCombo:Popup:nHeight := 3*oCombo:nHeight
		gtk_WidgetSetPosition(oCombo:Popup, oCombo:Popup:nLeft, oCombo:Popup:nTop)
		gtk_WidgetSetSize(oCombo:Popup, oCombo:Popup:nWidth, oCombo:Popup:nHeight)
	case CBS_DROPDOWN	//             	2  // 0x0002
		oCombo := gtk_ComboNew(oCombo)
	case CBS_DROPDOWNLIST	//         	3  // 0x0003
		oCombo := gtk_ComboNew(oCombo)
		gtk_EntrySetEditable(oCombo:Entry, .f.)
	/*
	case CBS_OWNERDRAWFIXED	//      	16  // 0x0010
	case CBS_AUTOHSCROLL	//         	64  // 0x0040
	case CBS_OEMCONVERT	//         	128  // 0x0080
	case CBS_SORT		//              256  // 0x0100
	case CBS_DISABLENOSCROLL//   	2048  // 0x0800
	*/
	otherwise
		oCombo := gtk_ComboNew(oCombo)
	endswitch

	oCombo:hWnd := oCombo:handle
	gtk_ComboSetValueInList(oCombo, .f.)
	gtk_WidgetSetPosition(oCombo, oCombo:nLeft, oCombo:nTop)
	gtk_WidgetSetSize(oCombo, oCombo:nWidth, oCombo:nHeight)

	Style := map()
	Style:colormap := gtk_WidgetGetColormap(oCombo)
	clrFore := gdk_ColorRGB(oCombo:nClrFore)
	clrBack := gdk_ColorRGB(oCombo:nClrBack)
	gdk_ColormapAllocColor(Style:colormap, clrFore)
	gdk_ColormapAllocColor(Style:colormap, clrBack)
	Style:FG_color := {clrFore, clrFore, clrFore, clrFore, clrFore}
	Style:BASE_color := {clrBack, clrBack, clrBack, clrBack, clrBack}

	gtk_WidgetSetStyle(oCombo:Entry, Style)
	gtk_WidgetSetStyle(oCombo:List, Style)

	if "CMSG"$oCombo .and. oCombo:cMsg != NIL
		/* mouse cursor enters on button region */
		gtk_SignalConnect(oCombo, "enter", {|w, e| w:GotFocus(GetActiveWindow())})
		gtk_SignalConnect(oCombo, "focus-in-event", {|w, e| w:GotFocus(GetActiveWindow())})
		/* mouse cursor leave button region */
		gtk_SignalConnect(oCombo, "leave", {|w, e| w:LostFocus()})
		gtk_SignalConnect(oCombo, "focus-out-event", {|w, e| w:LostFocus()})
	endif

return
/*****************************************************************************
ListBox function
*****************************************************************************/
static function CreateListbox(oLBox)
local Style, FGcolor, BASEcolor

	oLBox := gtk_CListNew(oLBox, 1, "")
	gtk_ClistColumnTitlesHide(oLBox)
	if oLBox:nStyle == numOr(oLBox:nStyle, LBS_MULTIPLESEL)
		gtk_CListSetSelectionMode(oLBox, GTK_SELECTION_MULTIPLE)
	endif
	if oLBox:nStyle == numOr(oLBox:nStyle, LBS_SORT)
		gtk_CListSetAutoSort(oLBox, .t.)
	endif
	Style := map()
	Style:colormap := gtk_WidgetGetColormap(oLBox)
	FGcolor := gdk_ColorRGB(oLBox:nClrFore)
	BASEcolor := gdk_ColorRGB(oLBox:nClrBack)
	gdk_COlormapAllocColor(Style:colormap, FGcolor)
	gdk_COlormapAllocColor(Style:colormap, BASEcolor)
	Style:FG_color := {FGcolor, FGcolor, FGcolor, FGcolor, FGcolor}
	Style:BASE_color := {BASEcolor, BASEcolor, BASEcolor, BASEcolor, BASEcolor}

	gtk_WidgetSetStyle(oLBox, Style)
	gtk_WidgetSetPosition(oLBox, oLBox:nLeft, oLBox:nTop)
	gtk_WidgetSetSize(oLBox, oLBox:nWidth, oLBox:nHeight)
	gtk_SignalConnect(oLBox, "select-row", {|w, e| w:Change()})
	if "CMSG"$oLBox .and. oLBox:cMsg != NIL
		/* mouse cursor enters on ListBox region */
		gtk_SignalConnect(oLBox, "enter", {|w, e| w:GotFocus(GetActiveWindow())})
		gtk_SignalConnect(oLBox, "focus-in-event", {|w, e| w:GotFocus(GetActiveWindow())})
		/* mouse cursor leave ListBox region */
		gtk_SignalConnect(oLBox, "leave", {|w, e| w:LostFocus()})
		gtk_SignalConnect(oLBox, "focus-out-event", {|w, e| w:LostFocus()})
	endif

return oLBox
/*****************************************************************************
Drawing function
*****************************************************************************/
static function configure_event(oDC, ev, hWnd)
local nWidth, nHeight, style, oWnd, nWDC, nHDC


	style := gtk_WidgetGetStyle(oDC)

	if "PIXMAP"$oDC .and. !empty(oDC:pixmap)
		gtk_WidgetDestroy(oDC:pixmap)
	endif

	gtk_WidgetGetSize(hWnd, @nWidth, @nHeight)
	gtk_WidgetGetSize(oDC, @nWDC, @nHDC)

	if nWidth != nWDC .or. nHeight != nHDC
		gtk_DrawingAreaSize(oDC, nWidth, nHeight)
	endif

	oDC:pixmap := gtk_PixmapNew(, hWnd, nWidth, nHeight)
	oDC:hWnd := oDC:handle
	oDC:pWnd := hWnd	  // parent handle

	gdk_DrawRectangle (oDC:pixmap, ;
	    style:bg_gc[1], ;
	    .t., ;
	    0, 0, ;
	    nWidth,;
	    nHeight)

	oWnd := gtk_GetObjByHandle(hWnd)
	oWnd:Paint()
return
*************
static function expose_event(oDC, oEvent, hWnd)
local pixmap, oWnd, rect, style

	style := gtk_WidgetGetStyle(oDC)

	oWnd := gtk_GetObjByHandle(hWnd)
	rect := GetCoors(hWnd)
	gdk_DrawPixmap(oDC, ;
		style:fg_gc[GTK_WIDGET_STATE(oDC)+1], ;
		oDC:pixmap, ;
		oEvent:area:x, oEvent:area:y, ;
		oEvent:area:x, oEvent:area:y, ;
		oEvent:area:width, oEvent:area:height)

return
*************
static function GetDc(hWnd)
local DC, hDC, nW, nH, oWnd, style

	if !(hWnd $ DCPixmap)

		DCPixmap[hWnd] := gtk_DrawingAreaNew(, hWnd)
		hDC := DCPixmap[hWnd]:handle
		gtk_WidgetGetSize(hWnd, @nW, @nH)
		gtk_DrawingAreaSize(hDC, nW, nH)
		gtk_SignalConnect(hDC, "configure-event", {|w, e|configure_event(w, e, hWnd)})
		gtk_SignalConnect(hDC, "expose-event", {|w, e|expose_event(w, e, hWnd)})

		oWnd := gtk_GetObjByHandle(hWnd)
		if "OCLIENT"$oWnd .and. oWnd:oClient != NIL
			gtk_LayoutPut(oWnd:oClient, hDC, 0, 0)

			if oWnd:oClient:nWidth < nW
				oWnd:oClient:nWidth += nW
				gtk_WidgetSetSize(oWnd:oClient, oWnd:oClient:nWidth)
			endif
			if oWnd:oClient:nHeight < nH
				oWnd:oClient:nHeight += nH
				gtk_WidgetSetSize(oWnd:oClient, , oWnd:oClient:nHeight)
			endif
		else
			if gtk_WidgetGetType(oWnd)== GTK_WIDGET_LAYOUT
				gtk_LayoutPut(oWnd, hDC, 0, 0)
			else
				gtk_ContainerAdd(oWnd, hDC)
			endif
		endif

	endif
	DC := DCPixmap[hWnd]

	style := gtk_WidgetGetStyle(DC)
	DC:hPen := style:fg_gc[1]

return DC:handle
*******************
static function ReleaseDc(hWnd, hDC)
local ret := .t.

	gtk_WidgetDraw(hWnd)

	if hDC!=NIL
		gtk_WidgetShowAll(hDC)
	endif
	gtk_WidgetShowAll(hWnd)
return ret

*******************
* lineStyle GDK_LINE_SOLID | GDK_LINE_ON_OFF_DASH | GDK_LINE_DOUBLE_DASH
* capStyle  GDK_CAP_NOT_LAST | GDK_CAP_BUTT | GDK_CAP_ROUND | GDK_CAP_PROJECTING
* joinStyle GDK_JOIN_MITER | GDK_JOIN_ROUND | GDK_JOIN_BEVEL

static function CreatePen(nStyle, nWidth, nRGBColor)
local oWnd, gc, bgColor, style, lineStyle, capStyle, joinStyle
	oWnd := GetWndDefault()
	gc := gdk_GCNew(, oWnd)
	style := gtk_WidgetGetStyle(oWnd)
	style:colormap := gtk_WidgetGetColormap(oWnd)

	bgColor := gdk_ColorRGB(nRGBColor)
	gdk_ColormapAllocColor(style:colormap, bgColor)
	gdk_GCSetForeground(gc, bgColor)
	gdk_GCSetBackground(gc, bgColor)

	do case
	case numOr(nStyle, PS_SOLID       ) == nStyle
		lineStyle := GDK_LINE_SOLID
	case numOr(nStyle, PS_DASH        ) == nStyle
		lineStyle := GDK_LINE_ON_OFF_DASH
	case numOr(nStyle, PS_DOT         ) == nStyle
	case numOr(nStyle, PS_DASHDOT     ) == nStyle
	case numOr(nStyle, PS_DASHDOTDOT  ) == nStyle
	case numOr(nStyle, PS_NULL        ) == nStyle
	case numOr(nStyle, PS_INSIDEFRAME ) == nStyle
	endcase
	capStyle  := GDK_CAP_NOT_LAST
	joinStyle := GDK_JOIN_MITER
	gdk_GCSetLineAttributes(gc, nWidth, lineStyle, capStyle, joinStyle)
return gc:handle
********************
static function MoveTo(hDC, nRow, nCol)
	DCPoints[hDC] := { nCol, nRow }
return
****************
static function LineTo(hDC, nRow, nCol)
local lSuccess:=.t., oDC, GCPen
	oDC := gtk_getObjByHandle(hDC)
	GCPen := oDC:hPen
	gdk_DrawLine(oDC:pixmap, GCPen, DCPoints[hDC][2], DCPoints[hDC][1], nRow, nCol)

return lSuccess
/*****************************************************************************
Brush function
*****************************************************************************/
static function CreateSolidBrush(nRGBColor)
local oBrush, gc, bgColor, nWidth, nHeight, hWnd, hDC
	nWidth := 1; nHeight := 1
	hWnd := GetActiveWindow()
	gc := gdk_GCNew(, hWnd)
	hDc := gtk_PixmapNew(, hWnd, nWidth, nHeight)
	bgColor := gdk_ColorRGB(nRGBColor)
	gdk_ColorAlloc(hWnd, bgColor)
	gdk_GCSetForeground(gc, bgColor)
	gdk_DrawRectangle(hDc, gc, .t., 0, 0, nWidth, nHeight)
return oBrush:handle
***********************
static function FWBrushes(nStyle)
local oBrush

	do switch nStyle
	case 1	//"BORLAND"
	case 2  //"BRICKS"
	case 3  //"TILED"
	case 4  //"TABS"
	otherwise
	endswitch
return oBrush:handle
*********************
static function DrawMsgItem(hDC, cMsg, aCoor, nClrText, nClrPane, hFont)
local style
	style := gtk_WidgetGetStyle(hDC)
	hFont := style:font

	gdk_DrawText(hDC, style:fg_gc[1], hFont, aCoor[2], aCoor[1], cMsg, len(cMsg))
return
*********************
*The ExtTextOut function draws a character string by using the
*currently selected font.
static function ExtTextOut(hDC, x, y, aRect, cText)
local style, oDC, gc
	style := gtk_WidgetGetStyle(hDC)
	outlog(__FILE__, __LINE__, 'exttextout', cText, x, y, style:fg_gc[1])
	oDC := gtk_GetObjbyhandle(hDC)
	gc := gdk_GCNew(, oDC:pWnd)
	//gdk_DrawText(hDC, style:fg_gc[1], style:font, x, y, cText, len(cText))
	//gdk_DrawText(hDC, gc, style:font, x, y, cText, len(cText))
	MOveto(hDC, x, y)
	LIneTo(hDC, x+200, y)
return
*********************
static function DrawText(hDC, cMsg, wLen, aCoor, nAlign)
local style, x, y, nWidth, nHeight, lenMsg, hgMsg
	style := gtk_WidgetGetStyle(hDC)

	nWidth := aCoor[4]-aCoor[2]
	nHeight := aCoor[3]-aCoor[1]

	cMsg := substr(alltrim(cMsg), 1, wLen)
	lenMsg := gdk_StringWidth(style:font, cMsg)
	hgMsg := gdk_StringHeight(style:font, cMsg)

	x := aCoor[2]
	y := aCoor[1]+hgMsg
	do case
	case nAlign == DT_CENTER
		x += (nWidth - lenMsg)/2
	case nAlign == DT_RIGHT
		x += nWidth - lenMsg
	endcase
	gdk_DrawText(hDC, style:fg_gc[1], style:font, x, y, cMsg, wLen)
return
static function WndBoxIn(hDC, nTop, nLeft, nBottom, nRight)
return
/*****************************************************************************
Timer function
*****************************************************************************/
static function SetTimer(hWnd, nInterval)
local oWnd
	oWnd := gtk_GetObjByHandle(hWnd)
return gtk_TimeOutAdd(nInterval, {||oWnd:setText(oWnd:bMsg())} )
***********************
static function KillTimer(hWnd, nId)
	gtk_TimeOutRemove(nId)
return

/*****************************************************************************
Bitmap functions
*****************************************************************************/
static function ReadBitmap(hDC, cFileName)
local hBitmap, oBitmap
	if file(cFileName)
		oBitmap := gtk_PixmapFromBMPNew(, cFileName, GetactiveWindow())
		hBitmap := oBitmap:handle
	endif
return hBitmap
/*****************************************************************************
ScrollBar functions
*****************************************************************************/
static function CreateScrollBar(oScrl)
local oAdj, size
	size := iif(oScrl:lVertical, oScrl:nWidth, oScrl:nHeight)
	oAdj := gtk_AdjustmentNew(, 0, 0, size, 1, 0.1, 0.1)

	if oScrl:lVertical
		oScrl := gtk_VScrollBarNew(oScrl,oAdj)
	else
		oScrl := gtk_HScrollBarNew(oScrl,oAdj)
	endif
	gtk_WidgetSetSize(oScrl, oScrl:nWidth, oScrl:nHeight)

	oScrl:hWnd := oScrl:handle
	oScrl:oAdj := oAdj
	gtk_RangeSetUpdatePolicy(oScrl,GTK_UPDATE_DELAYED)

	gtk_SignalConnect(gtk_RangeGetAdjustment(oScrl), "value-changed", {|w, e, r| local (v:=-1, l:=-1, u:=-1), gtk_AdjustmentGetValue(w, @v, @l, @u),  }, oScrl)
return
/*
nBar -Specifies the scroll bar to be set. This parameter can be one of the following values:

SB_CTL	Sets the range of a scroll bar control. The hWnd parameter
	must be the handle of the scroll bar control.
SB_HORZ	Sets the range of a window,s standard horizontal scroll bar.
SB_VERT	Sets the range of a window,s standard vertical scroll bar.
*/
static function SetScrollRange(hWnd, nBar, nMinPos, nMaxPos, lRedraw)
local oWnd, size

	oWnd := gtk_GetObjByHandle(hWnd)

	if oWnd:lVertical .and. nBar == SB_HORZ
		oWnd := gtk_HScrollbarNew(oWnd, oWnd:oAdj)
		oWnd:lVertical := .f.
	endif
	if !(oWnd:lVertical) .and. nBar == SB_VERT
		oWnd := gtk_VScrollbarNew(oWnd, oWnd:oAdj)
		oWnd:lVertical := .t.
	endif

	if nMaxPos - nMinPos == 0
		size := iif(oWnd:lVertical, oWnd:nWidth, oWnd:nHeight)
		gtk_AdjustmentClampPage(oWnd:oAdj, 0, size)
	else
		gtk_AdjustmentClampPage(oWnd:oAdj, nMinPos, nMaxPos)
	endif
return
static function SetScrollPos(hWnd, nBar, nPos, lRedraw)
local oWnd
	oWnd := gtk_GetObjByHandle(hWnd)
	gtk_AdjustmentSetValue(gtk_RangeGetAdjustment(hWnd), nPos)
return
/*****************************************************************************
MDI functions
*****************************************************************************/
static function GetMDIInstance()
return __MDIInstance
*********************
static function cMdiStruct(cClassName, cTitle, nTop, nLeft, nBottom, nRight, nStyle )
local obj

	//DEFAULT cTitle := cClassName

	obj := map()
	obj:ClassName := cClassName
	obj:cTitle := cTitle
	obj:hOwner  	= __MDIInstance
	obj:style   	= nStyle
	if nRight !=  CW_USEDEFAULT
		obj:x       	= nLeft
		obj:y       	= nTop
		obj:cx      	= nRight - nLeft + 1
		obj:cy      	= nBottom - nTop + 1

	else
		obj:x       	= nLeft
		obj:y       	= nTop
		obj:cx      	= nRight
		obj:cy      	= nBottom
	endif
return obj
/*****************************************************************************
TABS functions
*****************************************************************************/
static function CreateTabs(oWnd)
local nAlign, i, page
	oWnd := gtk_NotebookNew(oWnd)
	oWnd:hWnd := oWnd:handle
	do switch upper(oWnd:cAlign)
	case "TOP"
		nAlign := GTK_POS_TOP
	case "LEFT"
		nAlign := GTK_POS_LEFT
	case "RIGHT"
		nAlign := GTK_POS_RIGHT
	otherwise
		nAlign := GTK_POS_BOTTOM
	endswitch
	gtk_NotebookSetTabPos(oWnd, nAlign)
	oWnd:aPages := {}
	for i=1 to len(oWnd:aPrompts)
		page := gtk_LayoutNew()
		page:hWnd := page:handle
		page:oFont := oWnd:oFont
		page:ClassName := "FWIN_PAGETABS"
		aadd(oWnd:aPages, page)
		gtk_WidgetSetSize(oWnd:aPages[i], oWnd:nRight-oWnd:nLeft+1, oWnd:nBottom-oWnd:nTop+1)

		gtk_NotebookAppendPage(oWnd, oWnd:aPages[i], oWnd:aPrompts[i], "&")
	next
return
/*****************************************************************************
Messages functions
*****************************************************************************/
static function __MsgBox(cMsg, cTitle, FontMessage, lbStyle, cXPM, aButton, aReturn)
local nWidth, nHeight
local Button, Label, activeWnd
local Dialog, inFocus, i, ret:=.f.
local BtnWidth:=40, BtnHeight:=25, hbox, vbox

	FWInitDriver()

	Dialog := gtk_DialogNew(, cTitle)

	gtk_WindowSetDefaultSize(Dialog, gdk_StringWidth(FontMessage, cTitle)+50)


	gtk_SignalConnect(Dialog, GTK_DELETE, {|| gtk_WidgetHideOnDelete(Dialog)})
	gtk_SignalConnect(Dialog, GTK_HIDE_SIGNAL, {|| gtk_WidgetDestroy(Dialog), gtk_Quit()})

	gtk_WindowSetModal(Dialog, .t.)

	gtk_ContainerSetBorderWidth(Dialog:VBox, 5)
	hbox := gtk_HBoxNew()
	gtk_ContainerSetBorderWidth(hBox, 10)
	vbox := gtk_VBoxNew()

	if aReturn != NIL .and. !empty(aReturn)
		ret := iif(valtype(aReturn[1])=="N", 0, .f.)
	endif

	if cXPM != NIL
		gtk_BoxPackStart(hbox, gtk_PixmapCreateFromXPMd(, cXPM))
	endif

	label := gtk_LabelNew(, alltrim(toString(cMsg)) )
	gtk_WidgetSetStyle(Label, lbStyle)
	gtk_LabelSetLineWrap(Label, .t.)
	gtk_BoxPackStart(vbox, Label)
	gtk_BoxPackStart(hbox, vbox)
	gtk_ContainerAdd(Dialog:VBox, hbox)

	gtk_BoxSetHomogeneous(Dialog:ActionArea, .t.)

	if aButton == NIL
		Button := gtk_ButtonNew(, [&Ok], "&")
		gtk_WidgetSetSize(Button, BtnWidth, BtnHeight)
		gtk_ButtonSetStyle(Button, lbStyle)
		gtk_SignalConnect(Button,"clicked",{|w,e| ret:=.t., gtk_WidgetHide(Dialog)})
		gtk_WidgetAddAccelerator(Button, GTK_CLICKED_SIGNAL, Dialog, ;
			Button:AccelKey)
		gtk_WidgetAddAccelerator(Button, GTK_CLICKED_SIGNAL, Dialog, ;
			Button:AccelKey, GDK_CONTROL_MASK)

		gtk_ContainerAdd(Dialog:ActionArea, Button)
		inFocus := Button:handle
	else
		Button := {}
		asize(aReturn, len(aButton))
		for i=1 to len(aButton)
			aadd(Button, gtk_ButtonNew(, aButton[i], "&"))
			Button[i]:nResult := iif(aReturn[i]==NIL, i, aReturn[i])
			gtk_WidgetSetSize(Button[i], BtnWidth, BtnHeight)
			gtk_ButtonSetStyle(Button[i], lbStyle)
			gtk_SignalConnect(Button[i],"clicked",{|w,e| ret:=w:nResult, gtk_WidgetHide(Dialog)})
			gtk_WidgetAddAccelerator(Button[i], GTK_CLICKED_SIGNAL, Dialog, ;
				Button[i]:AccelKey)
			gtk_WidgetAddAccelerator(Button[i], GTK_CLICKED_SIGNAL, Dialog, ;
				Button[i]:AccelKey, GDK_CONTROL_MASK)

			gtk_ContainerAdd(Dialog:ActionArea, Button[i])
			if i==1
				inFocus := Button[i]:handle
			endif
		next
	endif


	activeWnd := GetActiveWindow(Dialog)

	if activeWnd > -1
		gtk_WindowSetTransientFor(Dialog, activeWnd)
	endif

	gtk_WindowSetPosition(Dialog, GTK_WIN_POS_CENTER_ON_PARENT)

	gtk_WidgetSetFocus(inFocus)
	gtk_WidgetRealize(Dialog)
	gtk_WindowSetFunctions(Dialog, GDK_FUNC_CLOSE)
	gtk_WindowSetDecorations(Dialog, NUMOR(GDK_DECOR_TITLE, GDK_DECOR_BORDER))
	gtk_WidgetShowAll(Dialog)

	gtk_Main()

return ret
********************
static function __MsgAbout(FontMessage, lbStyle)
local nWidth, nHeight
local Button, gc
local Dialog, cXPM, hBox, st
local BtnWidth:=40, BtnHeight:=25
local version, errb

	FWInitDriver()

	Dialog := gtk_DialogNew(, "About")

	gtk_SignalConnect(Dialog, GTK_DELETE, {|| gtk_WidgetHideOnDelete(Dialog)})
	gtk_SignalConnect(Dialog, GTK_HIDE_SIGNAL, {|| gtk_WidgetDestroy(Dialog), gtk_Quit()})

	gtk_WindowSetModal(Dialog, .t.)
	nWidth := 300
	nHeight := 300
	gtk_WidgetSetSize(Dialog, nWidth, nHeight)


	st := gtk_WidgetGetStyle(Dialog)

	gtk_WidgetSetStyle(Dialog, lbStyle)


	gtk_ContainerSetBorderWidth(Dialog:VBox, 5)

	hBox := gtk_HBoxNew()
	gtk_ContainerSetBorderWidth(hBox, 25)

	cXPM := itkXPM

	if cXPM != NIL
		gtk_BoxPackStart(hBox, gtk_PixmapCreateFromXPMd(, cXPM))
	endif
	gtk_BoxPackStart(hBox, gtk_LabelNew(, FWCOPYRIGHT))
	gtk_ContainerAdd(Dialog:VBox, hBox)
	gtk_ContainerAdd(Dialog:Vbox, gtk_LabelNew(, FWVERSION))
	gtk_ContainerAdd(Dialog:Vbox, gtk_LabelNew(, "OS-version: "+OS()))
	version := space(0)
	errb := space(0)
	syscmd("gtk-config --version", "", @version, errb)
	gtk_ContainerAdd(Dialog:Vbox, gtk_LabelNew(, "GTK-version: "+version))

	Button := gtk_ButtonNew(, [&Ok], "&")
	//gtk_ButtonSetStyle(Button, lbStyle)
	gtk_SignalConnect(Button,"clicked",{|w,e| gtk_WidgetHide(Dialog)})
	gtk_WidgetAddAccelerator(Button, GTK_CLICKED_SIGNAL, Dialog, ;
		Button:AccelKey)
	gtk_WidgetAddAccelerator(Button, GTK_CLICKED_SIGNAL, Dialog, ;
		Button:AccelKey, GDK_CONTROL_MASK)

	gtk_ContainerAdd(Dialog:ActionArea, Button)
	gtk_WidgetSetSize(Button, BtnWidth, BtnHeight)

	gtk_WindowSetTransientFor(Dialog, GetWndDefault())

	gtk_WindowSetPosition(Dialog, GTK_WIN_POS_CENTER_ON_PARENT)

	gtk_WidgetRealize(Dialog)
	gtk_WindowSetFunctions(Dialog, GDK_FUNC_CLOSE)
	gtk_WindowSetDecorations(Dialog, NUMOR(GDK_DECOR_TITLE, GDK_DECOR_BORDER))
	gtk_WidgetShowAll(Dialog)

	gtk_Main()

return
*********************
static function __InitMessageStyle(lbStyle, FontMessage)
	lbStyle := gtk_WidgetGetDefaultStyle()
	lbStyle:cFontDescription = FONT_DEFAULT

	lbStyle:Font := gdk_FontLoad(, lbStyle:cFontDescription)
	FontMessage := lbStyle:Font
return
************************
static function __MsgBeep()
	gdk_Beep()
return
************************
static function __ChooseColor()
local csDialog, ret, retarr, oWndDef, style, curColor

	FWInitDriver()

	oWndDef := GetWndDefault()
	style := gtk_WidgetGetStyle(oWndDef)

	csDialog:=gtk_ColorSelectionDialogNew(,"Color Selection Dialog window")
	gtk_WindowSetModal(csDialog, .F.)
	gtk_WidgetSetPosition(csDialog,200,300)
	gtk_WidgetHide(csDialog:HelpButton)
	curColor := style:FG_color[1]

	gtk_ColorSelectionSetColor(csDialog:ColorSel, curColor)//style:FG_color[1])
	gtk_SignalConnect(csDialog,"delete-event",{|wid,ev|gtk_WidgetHide(csDialog)})
	gtk_SignalConnect(csDialog:OkButton,"clicked",{|wid,ev|retarr := gtk_ColorSelectionGetColor(csDialog:ColorSel),gtk_WidgetHide(csDialog)})
	gtk_SignalConnect(csDialog:CancelButton,"clicked",{|wid,ev|gtk_WidgetHide(csDialog)})
	gtk_WindowSetTransientFor(csDialog, oWndDef)

	gtk_SignalConnect(csDialog, GTK_DELETE, {|| gtk_WidgetHideOnDelete(csDialog)})
	gtk_SignalConnect(csDialog, GTK_HIDE_SIGNAL, {|| gtk_WidgetDestroy(csDialog), gtk_Quit()})


	gtk_WidgetRealize(csDialog)
	gtk_WindowSetFunctions(csDialog, GDK_FUNC_CLOSE)
	gtk_WindowSetDecorations(csDialog, NUMOR(GDK_DECOR_TITLE, GDK_DECOR_BORDER))
	gtk_WidgetShowAll(csDialog)

	gtk_Main()

	if valtype(retarr) != "U"
		ret := gdk_ColorRGBtoN(retarr)
		style:FG_color[1] := retarr
		gtk_WidgetSetStyle(oWndDef, style)
	else
		ret := -1
	endif
return ret
*****************************
static function Calendar(date)
local wnd, oCalendar, nWidth, nHeight, nTop, nLeft, ret

	date := iif(date==NIL .or. valtype(date)!= "D", date(), date)
	ret := date

	FWInitDriver()

	oCalendar := gtk_CalendarNew()
	gtk_CalendarDisplayOptions(oCalendar, GTK_CALENDAR_SHOW_HEADING+;
					GTK_CALENDAR_SHOW_DAY_NAMES+;
					GTK_CALENDAR_WEEK_START_MONDAY)

	//qout(date, day(date), month(date), year(date))
	gtk_CalendarSelectDay(oCalendar, day(date))
	gtk_CalendarSelectMonth(oCalendar, month(date), year(date))

	wnd := gtk_WindowNew(, [Calendar])
	gtk_SignalConnect(wnd, GTK_DELETE, {|| gtk_WidgetHideOnDelete(wnd)})
	gtk_SignalConnect(wnd, GTK_HIDE_SIGNAL, {|| gtk_WidgetDestroy(wnd), gtk_Quit()})
	gtk_SignalConnect(oCalendar, "day-selected-double-click", {|| ret:= gtk_CalendarGetDate(oCalendar), gtk_WidgetDestroy(wnd), gtk_Quit()})

	nWidth := 300
	nHeight := 300
	nTop := gdk_ScreenHeight()/2 - nHeight/2
	nLeft := gdk_ScreenWidth()/2 - nWidth/2
	gtk_WidgetSetPosition(wnd, nLeft, nTop)

	gtk_ContainerAdd(wnd, oCalendar)

	gtk_WidgetShowAll(wnd)
	gtk_Main()
return ret

/*****************************************************************************
 Menu functions
*****************************************************************************/
static function IsMenu(hItem)
outlog(__FILE__, __LINE__, gtk_WidgetGetTypeName(hItem))

return .f.
*************
static function CreateMenu(oMenu)
	if len(aMenuStack)==0
		oMenu := gtk_MenuBarNew(oMenu)
	else
		oMenu := gtk_MenuNew(oMenu)
		gtk_MenuItemSetSubmenu(oLastItem, oMenu)
	endif

	aadd(aMenuStack,oMenu )

return oMenu:handle
********************
static function MenuMeasureItem(oItem, nLen)
	oItem:nWidth := nLen
	oItem:update()
return
**************
static function CreatePopupMenu(self)
return
***************
static function GetSystemMenu(oWnd, lValue)
return
**************
static function TrackPopUp(hMenu, nFlags, nLeft, nTop, nReserved, hWnd)
local i

return
*************
static function AppendMenu(hMenu, oItem, nFlags, nId, cPrompt)
local oMenu, lb, box

	oMenu := gtk_GetObjByHandle(hMenu)

//qout('append menuitem', cPrompt)
	if numOr(nFlags, MF_BITMAP) == nFlags
		oItem := gtk_MenuItemNew (oItem)
		box := gtk_VBoxNew()
		gtk_ContainerAdd(oItem, box)
		//gtk_BoxPackStart(box, gtk_PixmapFromBmpNew(, cBmpFile, GetActiveWindow(oItem)))
		gtk_BoxPackStart(box, cPrompt)
		/*
		if cPrompt != NIL
			lb := gtk_LabelNew(, cPrompt, "&")
			gtk_BoxPackEnd(box, lb)
			aadd(aMenuAccel, lb)
		endif
		*/
	else
		if cPrompt == NIL .or. empty(cPrompt)
			oItem := gtk_MenuItemNew (oItem)//, popUp() )
		else
			oItem := gtk_MenuItemNew (oItem, cPrompt, "&")//, popUp() )
		endif
		aadd(aMenuAccel, oItem)
	endif

	oItem:hMenu := oItem:handle

	if oItem:lChecked != NIL
		//oItem:checked := lChecked
	endif
	if oItem:lActive != NIL
		gtk_WidgetSetSensitive(oItem, oItem:lActive)
	endif
	if oItem:cMsg != NIL
		//oItem:message := cMsg
	endif
	if oItem:bAction != NIL
		gtk_SignalConnect(oItem, GTK_ACTIVATE_SIGNAL, {|w, e| w:bAction()})
	endif
	/*if nEvent != NIL
		oItem:id := nEvent
	endif*/


return
*************
static function MenuBegin(lPopup, lSystem, oWnd)
local oMenu
	oMenu := TMenu():New(lPopup, oWnd)
return oMenu
***********
static function MenuAddItem(cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile, ;
			cResName, oMenu, bBlock, nVKState, nVirtKey, lHelp, nHelpId, bWhen, lBreak )
local oItem

	DEFAULT cMsg := "", lChecked := .f., lActive := .t.

	oItem := TMenuItem():New( cPrompt, cMsg, lChecked, lActive, bAction, ;
				cBmpFile, cResName, nVKState, nVirtKey, ;
				lHelp, nHelpId, bWhen, lBreak )


	if valtype(oMenu)=="O" .and. oMenu:className == "FWIN_TMENU"
		oMenu:Add(oItem)
	else
		aMenuStack[len(aMenuStack)]:Add(oItem)
	endif

	if nVirtKey != NIL
		//oItem:shortCut := nVirtKey
	endif

	if bBlock != NIL
		//oItem:data := bBlock
	endif

	oLastItem := oItem
	if len(aMenuStack)==1
		gtk_MenuBarAppend(aMenuStack[1], oItem)
	else
		gtk_MenuAppend(aMenuStack[len(aMenuStack)], oItem)
	endif
return oItem
***************
static function MenuEnd()
local ret := atail(aMenuStack)
	asize(aMenuStack, len(aMenuStack)-1 )
return ret
*****************
static function SetMenu(oWnd, oMenu)
local i, item
	for i=1 to len(aMenuAccel)
		item := aMenuAccel[i]
		gtk_WidgetAddAccelerator(item:Handle, GTK_ACTIVATE_ITEM_SIGNAL, oWnd, ;
			item:AccelKey, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)
	next
	gtk_BoxPackStart(oWnd:oTop, oMenu:hMenu, .t., .t.)
	aMenuAccel := {}
return
*******************
static function GetSubMenu(hMenu, hPopup)
local oMenu
	oMenu := gtk_GetObjByHandle(hMenu)
return oMenu:GetSubMenu(hPopup)
********************
static function DrawMenuBar(hWnd)
local oWnd
	oWnd := gtk_GetObjByHandle(hWnd)
	gtk_WidgetShow(oWnd:oMenu)
	gtk_WidgetShowAll(oWnd:oTop)
return
/*****************************************************************************
 System functions
*****************************************************************************/
* Init GTKsystem
static function InitFWDriver()
	if !__FW_INIT
		__FW_INIT := gtk_Init()
		qout('GTK system inizialized &\n')
		InitMessageStyle()
	endif
return __FW_INIT
**************
static function lWRunning()
return gtk_EventsPending()
*************
static function WinRun(hWnd)
	gtk_Main()
return
*************
static function WinClose()
	gtk_Quit()
return
*************
static function WinExec(cAppl)
local txt
	txt := cAppl+CRLF+"This program cannot be run in LINUX mode!"
	MsgInfo(txt, [Sorry!!!])
return
*************
static function WinHelp(cFile)
local txt
	txt := cFile+CRLF+"This program cannot be run in LINUX mode!"
	MsgInfo(txt, [Sorry!!!])
return
*************
static function SetWndApp(hWnd)
	hWndApp := hWnd
	gtk_Main()
return
*************
static function GetWndApp()
return hWndApp
*************
static function SendMessage(oWnd, nMsg, nWParam, nLParam)
local ret, nS:=0, nE:=0, nRow
	do switch nMsg
	/****** GET MESSAGES ******/
	case WM_USER //EM_GETSEL
		ret := gtk_EditableGetSelection(oWnd, @nS, @nE)
		nWParam := nS
		nLParam := nE


	/****** COMBOBOX MESSAGES ******/
	case HASH_CB_ADDSTRING
		//outlog('nLParam', nLParam)
		//gtk_ListAppendItems(oWnd:List, gtk_ListItemNew(, nLParam))
		gtk_ListAppendItems(oWnd:List, nLParam)
		gtk_ComboSetPopdownStrings(oWnd, oWnd:aItems)// ??????
	case HASH_CB_DELETESTRING
		// delete by index
		gtk_ListClearItems(oWnd:List, nWParam, nWParam)
	case HASH_CB_GETCURSEL
		ret := gtk_EntryGetText(oWnd:Entry)
	case HASH_CB_INSERTSTRING
		gtk_ListInsertItems(oWnd:List, nLParam, nWParam)
	case HASH_CB_RESETCONTENT
		gtk_ListClearItems(oWnd:List, 1, len(oWnd:Popup)+1)
	case HASH_CB_FINDSTRING
		// find item in dropDown list
	case HASH_CB_SETCURSEL
		//qout('setting', nWParam)
		gtk_EntrySetText(oWnd:Entry, toString(nWParam))
	case HASH_CB_SHOWDROPDOWN
		// show dropDown list

	/****** LISTBOX MESSAGES ******/
	case HASH_LB_ADDSTRING
		gtk_CListAppend(oWnd, {toString(nLParam)})
		gtk_WidgetShowAll(oWnd)
	case HASH_LB_INSERTSTRING
		gtk_CListInsert(oWnd, {toString(nLParam)}, nWParam)
	case HASH_LB_DELETESTRING
		gtk_CListRemove(oWnd, nWParam)
	case HASH_LB_RESETCONTENT
		gtk_CListClear(oWnd)
	case HASH_LB_SETSEL
		/* multiple select */
		//gtk_List
	case HASH_LB_SETCURSEL
		gtk_CListSetFocusRow(oWnd, nWParam)
	case HASH_LB_GETSEL
		/* multiple return */
		//gtk_List
	case HASH_LB_GETCURSEL
		/* ret current selected row */
		ret := gtk_CListGetFocusRow(oWnd)
	case HASH_LB_GETCOUNT
		//
	case HASH_LB_GETSELCOUNT
	case HASH_LB_GETSELITEMS
	case HASH_CLOSE_APL
		gtk_Quit()

	/****** MDI MESSAGES ******/
	case HASH_WM_MDICREATE	 // create MDI child
		ret := gtk_WindowNew(, nLParam:cTitle)
		if nLParam:cx != CW_USEDEFAULT
			gtk_WidgetSetSize(ret, nLParam)
		endif
	endswitch
return ret
***********************************************************************
*The function retrieves the handle of the specified child window,s parent
*window.
*
static function GetParent(hWnd)
local hParentWnd
	hParentWnd := gtk_WidgetGetParentWindow(hWnd)
	if hParentWnd == NIL
		hParentWnd := -1
	endif
return hParentWnd
**********************************************************************
*The  function converts the client coordinates of a specified point to
*screen coordinates.
*
static function ClientToScreen(hWnd, aPos) // aPos = {nRow, nCol}
local nPos, nRow, nCol
	nRow := 0; nCol := 0
	gtk_WidgetGetPosition(hWnd, @nCol, @nRow)
	nPos := {}
	aadd(nPos, nRow + aPos[1] * GRP_CHARPIX_H)
	aadd(nPos, nCol + aPos[2] * GRP_CHARPIX_W)
return nPos
**********************************************************************
*Retrieves the system metrics
*
static function GetSysMetrics(nIndex)
local nValue
	do switch nIndex
	case SM_CXBORDER
	case SM_CXCURSOR
	case SM_CXDLGFRAME
	case SM_CXDOUBLECLK
	case SM_CXFRAME
	case SM_CXFULLSCREEN
	case SM_CXHSCROLL
	case SM_CXHTHUMB
	case SM_CXICON
	case SM_CXICONSPACING
	case SM_CXMIN
	case SM_CXMINTRACK
	case SM_CXSCREEN
		nValue := gdk_ScreenWidth()
	case SM_CXSIZE
	case SM_CXVSCROLL
	case SM_CYBORDER
	case SM_CYCAPTION
	case SM_CYCURSOR
	case SM_CYDLGFRAME
	case SM_CYDOUBLECLK
	case SM_CYFRAME
	case SM_CYFULLSCREEN
	case SM_CYHSCROLL
	case SM_CYICON
	case SM_CYICONSPACING
	case SM_CYKANJIWINDOW
	case SM_CYMENU
	case SM_CYMIN
	case SM_CYMINTRACK
	case SM_CYSCREEN
	case SM_CYSIZE
	case SM_CYVSCROLL
	case SM_CYVTHUMB
	case SM_DBCSENABLED
	case SM_DEBUG
	case SM_MENUDROPALIGNMENT
	case SM_MOUSEPRESENT
	case SM_PENWINDOWS
	case SM_SWAPBUTTON
	endswitch
return nValue
*******************************************************************************
* FileDialog functions
static function FileDialog(cMask, cTitle)
local cFileName:="", fileSel, wnd, activeWnd
	FWInitDriver()

	cTitle := iif(empty(cTitle), [File selection], cTitle)
	cMask := iif(empty(cMask), "*", cMask)

	activeWnd := GetActiveWindow()
	fileSel := gtk_FileSelectionNew(,cTitle)
	gtk_FileSelectionComplete(fileSel, cMask)
	gtk_FileSelectionSetFileName(filesel, cMask)

	if activeWnd > -1
		gtk_WindowSetTransientFor(fileSel, activeWnd)
	endif

	gtk_FileSelectionHideFileOpButtons(fileSel)

	gtk_SignalConnect(fileSel, GTK_DELETE, {|w| gtk_WidgetHideOnDelete(w)})
	gtk_SignalConnect(fileSel, GTK_HIDE_SIGNAL, {|w| gtk_WidgetDestroy(w), gtk_Quit()})
	gtk_SignalConnect(fileSel:cancelButton, "clicked", {|w| gtk_WidgetHideOnDelete(fileSel), gtk_Quit()})
	gtk_SignalConnect(fileSel:okButton, "clicked", {|w| cFileName := gtk_FileSelectionGetFileName(fileSel),gtk_WidgetHideOnDelete(fileSel), gtk_Quit()})

	gtk_WidgetShowAll(fileSel)
	gtk_main()

return cFileName
******************************************************************************
*
static function KeyboardEvent(event)
return event == GTK_KEY_PRESS
*******************************************************************************
* WBrowse functions                                                           *
*******************************************************************************
static function CreateWBrowse(oBrow)
	oBrow := gtk_HBoxNew(oBrow)
	oBrow:hWnd := oBrow:handle
	oBrow:vBox := gtk_VBoxNew()
	oBrow:headBox := gtk_hBoxNew()
	oBrow:itemBox := gtk_hBoxNew()
	oBrow:footHeadBox := gtk_hBoxNew()
	oBrow:paned := gtk_hPanedNew()
	//gtk_WidgetSetSize(oBrow:paned, oBrow:nWidth, oBrow:nHeight)

	oBrow:lVScroll := oBrow:nStyle == numOr(oBrow:nStyle, WS_VSCROLL)
	oBrow:lHScroll := oBrow:nStyle == numOr(oBrow:nStyle, WS_HSCROLL)

	gtk_BoxPackStart(oBrow:vbox, oBrow:headBox)
	gtk_BoxPackStart(oBrow:vbox, oBrow:itemBox, .t., .t.)

	gtk_BoxPackEnd(oBrow:vbox, oBrow:footHeadBox)
	gtk_PanedPack2(oBrow:paned, oBrow:vbox, .f., .t.)
	gtk_BoxPackStart(oBrow, oBrow:paned, .t., .t.)

	/* add browser to client area of parent window  	*/
	/*browser add to clien area - from function SHowWindow	*/
	/*browser it is control for window/dialog		*/
//	gtk_LayoutPut(oBrow:oWnd:oClient, oBrow, oBrow:nLeft, oBrow:nTop)

return
**************************************************************************
* Configure browse headers & footHeaders if need
static function configureBrowse(oBrow)
local j, k, r, clr
local vb, hFrame, hfbox, bpgup, bgotop
local shFrame, shfbox, bpgdn, bgobottom
local sw_width, sw_height, heightHeadBox, heightItemBox, heightFootHeadBox, heightScroll

	oBrow:nCols := len(oBrow:aHeaders)
	oBrow:nRows := 1
	oBrow:nStartRec := 1

	oBrow:entry := array(oBrow:nRows, oBrow:nCols)
	oBrow:frameHb := array(oBrow:nCols) 	// header frame
	oBrow:header := array(oBrow:nCols)  	// some header button
	oBrow:nHeadLine := 0 			// line in header

	oBrow:frame := array(oBrow:nCols)  	//
	oBrow:box := array(oBrow:nCols)  	//

	if oBrow:lVScroll
		//oBrow:vAdj := gtk_AdjustmentNew(, 1.0, 1.0, oBrow:bLogicLen()+1.0, 1.0, oBrow:nRows*1.0, 1.0)
		oBrow:vAdj := gtk_AdjustmentNew(, 1.0, 1.0, ordKeyCount()+1.0, 1.0, oBrow:nRows*1.0, 1.0)
		gtk_SignalConnect(oBrow:vAdj, "value-changed", {|w, e| local (v:=-1, l:=-1, u:=-1), gtk_AdjustmentGetValue(w, @v, @l, @u),  changeRows(v), qout(v, l, u)},)
		oBrow:vScroll := gtk_VScrollBarNew(, oBrow:vAdj)

		vb := gtk_VBoxNew()

		hFrame := gtk_FrameNew()
		hfbox := gtk_VBoxNew()
		bpgup := gtk_ButtonNew()
		gtk_SignalConnect(bpgup, GTK_CLICKED_SIGNAL, {|btn| oBrow:PageUp()})
		gtk_ContainerAdd(bpgup, gtk_PixmapCreateFromXPMd(, pgupXPM))
		bgotop := gtk_ButtonNew()
		gtk_SignalConnect(bgotop, GTK_CLICKED_SIGNAL, {|btn| oBrow:GoTop()})
		gtk_ContainerAdd(bgotop, gtk_PixmapCreateFromXPMd(, gotopXPM))
		gtk_ContainerAdd(hFrame, hfbox)
		gtk_BoxPackStart(hfbox, bgotop)
		gtk_BoxPackStart(hfbox, bpgup)
		gtk_FrameSetShadowType(hFrame, GTK_SHADOW_NONE)

		shFrame := gtk_FrameNew()
		shfbox := gtk_VBoxNew()
		bpgdn := gtk_ButtonNew()
		gtk_SignalConnect(bpgdn, GTK_CLICKED_SIGNAL, {|btn| oBrow:PageDown()})
		gtk_ContainerAdd(bpgdn, gtk_PixmapCreateFromXPMd(, pgdnXPM))
		bgobottom := gtk_ButtonNew()
		gtk_SignalConnect(bgobottom, GTK_CLICKED_SIGNAL, {|btn| oBrow:GoBottom()})
		gtk_ContainerAdd(bgobottom, gtk_PixmapCreateFromXPMd(, gobottomXPM))
		gtk_ContainerAdd(shFrame, shfbox)
		gtk_BoxPackStart(shfbox, bpgdn)
		gtk_BoxPackStart(shfbox, bgobottom)
		gtk_FrameSetShadowType(shFrame, GTK_SHADOW_NONE)

		gtk_BoxPackStart(vb, hFrame)
		gtk_boxPackStart(vb, oBrow:vScroll, .t., .t.)
		gtk_boxPackEnd(vb, shFrame)

		gtk_boxPackEnd(oBrow, vb)
	endif
	if oBrow:lHScroll
		oBrow:hAdj := gtk_AdjustmentNew(, 1.0, 1.0, oBrow:nCols+1.0, 1.0, 1.0, 1.0)
		gtk_SignalConnect(oBrow:hAdj, "value-changed", {|w, e| local (v:=-1, l:=-1, u:=-1), gtk_AdjustmentGetValue(w, @v, @l, @u),  changeCols(v), qout(v, l, u)},)
		oBrow:hScroll := gtk_HScrollBarNew(, oBrow:hAdj)
		gtk_BoxPackEnd(oBrow:vbox, oBrow:hScroll)
	endif
/*
	/* init header style */
	oBrow:headStyle := gtk_WidgetGetStyle(oBrow)
	if !("COLORMAP"$oBrow:headStyle)
		oBrow:headStyle:colormap := gtk_WidgetGetColormap(oBrow)
	endif
	if oBrow:nClrForeHead != NIL
		clr := gdk_ColorRGB(oBrow:nClrForeHead)
		gdk_ColorMapAllocColor(oBrow:headStyle:colormap, clr)
		oBrow:headStyle:FG_color := {clr, clr, clr, clr, clr}
	endif

	if oBrow:nClrBackHead != NIL
		clr := gdk_ColorRGB(oBrow:nClrBackHead)
		gdk_ColorMapAllocColor(oBrow:headStyle:colormap, clr)
		oBrow:headStyle:BG_color := {clr, clr, clr, clr, clr}
	endif
*/
	for j:=1 to oBrow:nCols
		k := cscount(";", oBrow:aHeaders[j])+1
		if k > oBrow:nHeadLine
			oBrow:nHeadLine := k
		endif
	next

	for j:= 1 to oBrow:nCols
		/* init header boxes */
		oBrow:frameHb[j] := gtk_frameNew()
		gtk_frameSetShadowType(oBrow:frameHb[j], GTK_SHADOW_NONE)
		oBrow:header[j] := gtk_ButtonNew()
		oBrow:header[j]:id := j
		gtk_SignalConnect(oBrow:header[j], GTK_CLICKED_SIGNAL, {|cln| freez(cln)})
		vb := gtk_vBoxNew()

		gtk_ButtonSetRelief(oBrow:header[j], GTK_RELIEF_NONE)
		gtk_ContainerAdd(oBrow:header[j], vb)

		oBrow:header[j]:label := array(oBrow:nHeadLine)
		r := split(oBrow:aHeaders[j], ";")
		for k=1 to oBrow:nHeadLine
			oBrow:header[j]:label[k] := gtk_LabelNew(, r[k])
			gtk_BoxPackStart(vb, oBrow:header[j]:label[k])
		next

		gtk_WidgetSetSize(oBrow:header[j], oBrow:aColSizes[j])
    //		gtk_WidgetSetStyle(oBrow:header[j], oBrow:headstyle)

		gtk_ContainerAdd(oBrow:frameHb[j], oBrow:header[j])
		gtk_BoxPackStart(oBrow:headBox, oBrow:frameHb[j])
/**************
		/* init footHeader boxes */
		frameFb[j] := gtk_frameNew()
		gtk_frameSetShadowType(frameFb[j], GTK_SHADOW_IN)
		footHeader[j] := gtk_vBoxNew()
		footHeader[j]:label := array(1)
		footHeaderName[j] := "footHead"+str(j,2)+";"
		r := split(footHeaderName[j], ";")
		for k=1 to 1
			footHeader[j]:label[k] := gtk_LabelNew(, r[k])
			gtk_BoxPackStart(footHeader[j], footHeader[j]:label[k])
		next
		gtk_widgetsetSize(footHeader[j], headerWidth[j])
		gtk_WidgetSetStyle(footHeader[j], footHeadstyle)
		gtk_ContainerAdd(frameFb[j], footHeader[j])
		gtk_BoxPackStart(footHeadBox, frameFb[j])

***********/
		oBrow:frame[j] := gtk_frameNew()
		oBrow:box[j] := gtk_vBoxNew()
		gtk_frameSetShadowType(oBrow:frame[j], GTK_SHADOW_IN)
		gtk_ContainerAdd(oBrow:frame[j], oBrow:box[j])
		gtk_boxPackStart(oBrow:itemBox, oBrow:frame[j])
	next

	CellConfigure(oBrow)

	gtk_WidgetGetSize(oBrow:paned, @sw_width, @sw_height)
	oBrow:sw_width := sw_width; oBrow:sw_height := sw_height
	gtk_WidgetGetSize(oBrow:headBox,,@heightHeadBox)
	oBrow:heightHeadBox := heightHeadBox
	gtk_WidgetGetSize(oBrow:itemBox, ,@heightItemBox)
	oBrow:heightItemBox := heightItemBox
	/*
	gtk_WidgetGetSize(oBrow:footHeadBox,,@heightfootHeadBox)
	oBrow:heightFootHeadBox := heightFootHeadBox
	*/

	//oBrow:heightScroll := oBrow:sw_height - oBrow:heightHeadBox - oBrow:heightItemBox - oBrow:heightfootHeadBox + 1
	oBrow:heightScroll := oBrow:sw_height - oBrow:heightHeadBox - oBrow:heightItemBox + 1


	Browser_size_allocate(oBrow)


	gtk_SignalConnect(oBrow:paned, 'size-allocate', {|w| Browser_size_allocate(oBrow)})
//qout('rows', oBrow:nRows, 'cols', oBrow:nCols)
return
**************************************************************************
* Configure browser cells
static function CellConfigure(oBrow, startR, startC, frRedraw)
local i, j
startR := iif(startR == NIL, 1, startR)
startC := iif(startC==NIL, 1, startC)
frRedraw := iif(frRedraw==NIL, .t., frRedraw)
for i=startR to oBrow:nRows
	for j:= startC to oBrow:nCols
		oBrow:entry[i][j] := gtk_ButtonNew(, "")
		oBrow:entry[i][j]:i := i
		oBrow:entry[i][j]:j := j
		gtk_SignalConnect(oBrow:entry[i][j], GTK_CLICKED_SIGNAL, {|w, br| br:nRowPos := w:i, br:nColPos := w:j, qout(gtk_buttonGetText(w))}, oBrow)
		gtk_buttonsetrelief(oBrow:entry[i][j], GTK_RELIEF_NONE)
		gtk_boxpackStart(oBrow:box[j], oBrow:entry[i][j])
		gtk_WidgetSetSize(oBrow:box[j], oBrow:aColSizes[j])
		//gtk_WidgetShow(oBrow:entry[i][j])
	next
next
/*
if fr_cols > 0 .and. frRedraw
	InitFrozenPart(startR, 1)
endif
*/
return
**************************************************************************
static function CellGet()
return
**************************************************************************
static function Browser_size_allocate(oBrow)
local oldrows := oBrow:nRows, w, h, w1, h1, i, j, r, sw_width, sw_height
	/* width and height paned */
	gtk_WidgetGetSize(oBrow:Paned, @sw_width, @sw_height)
	oBrow:sw_width := sw_width
	oBrow:sw_height := sw_height

	//h := sw_height - oBrow:heightHeadBox - oBrow:heightfootHeadBox - oBrow:heightScroll + 1
	h := sw_height - oBrow:heightHeadBox  - oBrow:heightScroll + 1
	qout('itemBox height', h, sw_height, valtype(oBrow))
	w1:=0; h1:=0
	gtk_WidgetGetSize(oBrow:entry[1][1], @w1, @h1)
	r := int(h/h1)
	if r > oldrows
		oBrow:nRows := r
		asize(oBrow:entry, oBrow:nRows)
		for i=oldrows+1 to oBrow:nRows
			oBrow:entry[i] := array(oBrow:nCols)
		next
		/*
		if fr_cols>0
			asize(fr_entry, rows)
			for i=oldrows+1 to rows
				fr_entry[i] := array(fr_cols)
			next
		endif
		*/
		CellConfigure(oBrow, oldrows+1)
		CellGet(oBrow, oBrow:nStartRec, oldrows+1)
		//gtk_WidgetShow(oBrow:paned)
	elseif r < oldrows
		oBrow:nRows := r
		for i=oldrows to oBrow:nRows+1 step -1
			for j=1 to oBrow:nCols
				gtk_WidgetDestroy(oBrow:entry[i][j])
			next
		next
		asize(oBrow:entry, oBrow:nRows)
		/*
		if fr_cols>0
			for i=oldrows to rows+1 step -1
				for j=1 to fr_cols
					gtk_WidgetDestroy(fr_entry[i][j])
				next
			next
			asize(fr_entry, rows)
		endif
		*/
		if oBrow:nRowPos > oBrow:nRows
			oBrow:nRowPos := oBrow:nRows
			gtk_WidgetSetFocus(oBrow:entry[oBrow:nRowPos][oBrow:nColPos])
		endif
	endif
qout('size-allocate rows=', oBrow:nRows, len(oBrow:entry))
return
