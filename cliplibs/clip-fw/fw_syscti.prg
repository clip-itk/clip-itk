/*   FiveWin likely functions					*/
/*   CTI system functions					*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   License : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <ctievents.ch>
#include <inkey.ch>
#include <fwin/FiveWin.ch>
#include <fwin/Constant.ch>
#include <fwin/tcbrowse.ch>
#include <fwin/sysMetrics.ch>
//#include <fwin/WinApi.ch> |\ includig from fivewin.ch
//#include <fwin/font.ch>   |/

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

static ctiApp
static __aObj := map()


init procedure RegisterDriverCTI()
	fw_driver_register("CTI")
return

function GetSelectorCTI()
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
selector:Calendar	:= @Calendar()
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

return selector

************************
static function GetFwDriver()
return "CTI"
************************
static function isZoomed()
return .f.
*******************************
static function GetInstance()
return 0
*******************************
static function RefreshObj()
	outlog("Call empty function;"+procname())
return
*******************************
static function SetWindowPos()
	outlog("Call empty function;"+procname())
return
*******************************
static function __keybHandler(oCti, event)
static focus, lMenuFocused
local oWnd, oMenu
	switch (event:keycode)
		case K_ESC
			oWnd := __aObj[oCti:id]
			if !"OMENU"$oWnd .or. oWnd:oMenu == nil
				return
			endif
			oMenu := cti_get_object_by_id(oWnd:oMenu:hMenu)
			outlog(__FILE__, __LINE__, oMenu:classname, oMenu:__is_focused)
			if oMenu:__is_focused
				//ctiApp:set_focus(focus)
				//oCti:set_focus(focus)
				focus:set_focus()
			else
				focus := oCti:__FocusedObj
				//oCti:set_focus(oMenu)
				oMenu:set_focus()
				//focus := CtiApp:__FocusedObj
				//CtiApp:set_focus(oMenu)
			endif
		case K_ALT_X
			oWnd := __aObj[oCti:id]
			//outlog(__FILE__, __LINE__, 'emit signal', HASH_DELETE_EVENT,  'to',oCti:classname, oCti:id)
			oCti:Signal_Emit(cti_signal_new(HASH_CTI_DELETE_SIGNAL))
			//cti_quit()
	endswitch
return
*******************************
static function CreateWindow(oWnd, cClsName, cTitle, nStyle, nLeft, nTop, ;
			nWidth, nHeight, hWndOwner, hMenu, cExtraData)
local vBox, hBox, x, y, style, sw, wBorder, lVScroll, lHScroll, decor, nS
local val, low, up, oCti

	nTop := int(oWnd:nTop/WIN_CHARPIX_H)
	nLeft := int(oWnd:nLeft/WIN_CHARPIX_W)
	nWidth := int(oWnd:nWidth/WIN_CHARPIX_W)
	nHeight := int(oWnd:nHeight/WIN_CHARPIX_H)

	oCTI := cti_Window_New(iif(cTitle!=NIL, cTitle, oWnd:cCaption), nTop, nLeft, nHeight, nWidth)

/*
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
	*/
	if oWnd:oClient == NIL
		oWnd:oClient := cti_Layout_New()
		oWnd:oClient:hWnd := oWnd:oClient:id
		oWnd:oClient:show()
		oCTI:add(oWnd:oClient)
	endif

	 /*
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

*/
	ctiApp:add(oCTI)

	cti_event_connect(HASH_CTI_KEYBOARD_EVENT, @__keybHandler())
	//outlog(__FILE__, __LINE__, 'connect signal', HASH_DELETE_EVENT, 'to id', oCTI:id)
//	oCTI:Signal_Connect(HASH_CTI_DELETE_SIGNAL, {|w, e, obj| iif(obj:end(), CloseAppl(w), nil)}, oWnd)
	//oCTI:Signal_Connect(HASH_CTI_HIDE_SIGNAL, oWnd, {|w, e, obj| iif(obj:end(), CloseAppl(w), nil)})
	oCTI:signal_connect(HASH_CTI_DELETE_SIGNAL, {|w, e, obj| iif(obj:end(), w:hide(), .t.)}, oWnd)
	oCTI:signal_connect(HASH_CTI_HIDE_SIGNAL, {|w| CloseAppl(w)})

	if nLeft!=NIL .and. nLeft != CW_USEDEFAULT
	    oCTI:Set_Position(, nLeft)
	elseif "NLEFT"$oWnd .and. oWnd:nLeft != CW_USEDEFAULT
	    oCTI:Set_Position(, oWnd:nLeft)
	endif
	if nTop!=NIL .and. nTop != CW_USEDEFAULT
	    oCTI:Set_Position(nTop)
	elseif "NTOP"$oWnd .and. oWnd:nTop != CW_USEDEFAULT
	    oCTI:Set_Position(oWnd:nTop)
	endif

	if nWidth!=NIL .and. nWidth != CW_USEDEFAULT
	    oCTI:Set_Size(, nWidth)
	elseif "NWIDTH"$oWnd .and. oWnd:nWidth != CW_USEDEFAULT
	    oCTI:Set_Size(, oWnd:nWidth)
	endif
	if nHeight!=NIL .and. nHeight != CW_USEDEFAULT
	    oCTI:Set_Size(nHeight)
	elseif "NHEIGHT"$oWnd .and. oWnd:nHeight != CW_USEDEFAULT
	    oCTI:Set_Size(oWnd:nHeight)
	endif

	oWnd:hWnd := oCTI:id
	oWnd:Handle := oCTI:id

	oCTI:Signal_Connect(HASH_CTI_SET_SIZE_SIGNAL, {|w, e, obj|  CoorsUpdate(obj)}, oWnd)
	oCTI:Signal_Connect(HASH_CTI_SET_POSITION_SIGNAL, {|w, e, obj|  CoorsUpdate(obj)}, oWnd)

	/*
	gtk_WidgetAddEvents(oWnd:oClient, GDK_BUTTON_PRESS_MASK+GDK_BUTTON_RELEASE_MASK+GDK_POINTER_MOTION_MASK)
	x:=0; y:=0
	gtk_SignalConnect(oWnd:oClient, "button-press-event", {|| gdk_WindowGetPointer(oWnd:oClient, @x, @y), oWnd:LbuttonDown(y, x)})
	*/

	/* set font default */
	/*
	style := gtk_WidgetGetStyle(oWnd)
	gdk_FontUnref(style:font)
	style:font := gdk_FontLoad(, FONT_DEFAULT)
	gdk_FontRef(style:font)
	gtk_WidgetSetDefaultStyle(style)
	*/

	/* set decorations */
	/*
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
	*/

	__aObj[oCTI:id] := oWnd

return oWnd:hWnd
*******************************
static function CloseAppl(oWnd)
	cti_Quit()
return
*******************************
static function ValueChanged()
	outlog("Call empty function;"+procname())
return
*******************************
static function CoorsUpdate()
	outlog("Call empty function;"+procname())
return
*******************************
static function PostChild()
	outlog("Call empty function;"+procname())
return
*******************************
static function WndCreateError(oWnd)
	alert([Window create error]+ " "+oWnd:cTitle)
	outlog(__FILE__, __LINE__, [Window create error]+ " "+oWnd:cTitle)
	quit
return
*******************************
static function GetActiveWindow(oItem)

return ctiApp:Get_Active_Window_id()
*******************************
static function aSend()
	outlog("Call empty function;"+procname())
return
*******************************
static function WndCenter()
	outlog("Call empty function;"+procname())
return
*******************************
static function GetCoors(hWnd)
local aRect, nTop, nLeft, nWidth, nHeight, ctiWnd, oWnd
	oWnd := __aObj[hWnd]
	ctiWnd := cti_get_object_by_id(hWnd)
	aRect := map()
	aRect:Left   := ctiWnd:Left
	aRect:Top    := ctiWnd:Top
	aRect:Right  := ctiWnd:Left + ctiWnd:Width - 1
	aRect:Bottom := ctiWnd:Top  + ctiWnd:Height - 1
	outlog(__FILE__, __LINE__, ctiWnd:classname, oWnd:classname, aRect:top, arect:left, arect:bottom, arect:right)
return aRect
*******************************
static function GetClientRect(hWnd)
local aRect[4], oWnd
	oWnd := __aObj[hWnd]
	aRect[1] := oWnd:nTop
	aRect[2] := oWnd:nLeft
	aRect[3] := oWnd:nTop + oWnd:nHeight - 1
	aRect[4] := oWnd:nLeft + oWnd:nWidth - 1
	outlog(__FILE__, __LINE__, oWnd:classname, aRect[1], arect[2], arect[3], arect[4])
return aRect
*******************************
static function ShowChildrenControls()
	outlog("Call empty function;"+procname())
return
*******************************
static function ShowWindow(oWnd, nShowMode, ret)
local i, item, aItem, val, hFocus, toolt, oRect, style, oCti, itemCti
	oCti := cti_Get_Object_by_id(oWnd:hWnd)
	do switch nShowMode
	case 1,3 	//NORMAL .or. MAXIMIZED
		for i=1 to len(oWnd:aControls)
			item := oWnd:aControls[i]
			itemCti := cti_get_object_by_id(item:hWnd)
			itemCti:show()
			do switch item:className
			case 'FWIN_TTABS'
			/*
				gtk_WidgetAddAccelerator(item:Handle, GTK_SWITCH_PAGE_SIGNAL, oWnd, ;
					item:AccelKey, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)
			*/
			case 'FWIN_TBUTTON', 'FWIN_TBTNBMP'
			/*
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
			*/
			case 'FWIN_TCOMBOBOX'
			/*
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
			*/
			endswitch

			outlog(__FILE__, __LINE__, 'add to', oWnd:oClient:classname, 'item', itemcti:classname, itemCti:Top, itemCti:Left)
			oWnd:oClient:add(itemCti, itemCti:Top, itemCti:Left)
			outlog(__FILE__, __LINE__, 'add  ok')

			/*
			if oWnd:oClient:nWidth < item:nRight
				oWnd:oClient:nWidth += item:nRight
				gtk_WidgetSetSize(oWnd:oClient, oWnd:oClient:nWidth)
			endif
			if oWnd:oClient:nHeight < item:nBottom-item:nTop+1
				oWnd:oClient:nHeight += item:nBottom-item:nTop+1
				gtk_WidgetSetSize(oWnd:oClient, , oWnd:oClient:nHeight)
			endif
			*/
			if hFocus==NIL
				hFocus := itemCti
				//hFocus := iif(oCti:Set_Focus(hFocus), hFocus, NIL)
			endif
		next
		outlog(__FILE__, __LINE__, len(oWnd:aControls), oWnd:classname, oCti:classname)
		/*
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
		*/
		if nShowMode == 3 //maximize
			oRect := map()
			oRect:nLeft := 0
			oRect:nTop := 0
			oRect:nRight := ctiApp:Width
			oRect:nBottom := ctiApp:Height

			oCti:Set_Position(oRect:nTop, oRect:nLeft)
			oCti:Set_Size(oRect:nBottom, oRect:nRight)

			oWnd:SetCoors(oRect)
		endif
		oCti:Show()
	case 2 	//ICONIZED
	otherwise
		oCti:Show()
	endswitch
	if !empty(oWnd:bPainted)
		eval(oWnd:bPainted)
	endif
	//ctiApp:Set_Focus(oCti)
	oCti:Show()
	oCti:Set_Focus()
return
*******************************
static function UpdateWindow()
	outlog("Call empty function;"+procname())
return
*******************************
static function WSay()
	outlog("Call empty function;"+procname())
return
*******************************
static function DragQueryPoint()
	outlog("Call empty function;"+procname())
return
*******************************
static function BeginPaint()
	outlog("Call empty function;"+procname())
return
*******************************
static function EndPaint()
	outlog("Call empty function;"+procname())
return
*******************************
static function GetTextWidth(cText, hFont)
return len(cText)
*******************************
static function GetWndRect()
	outlog("Call empty function;"+procname())
return
*******************************
static function SetFocus(hCtrl)
local ret, ctiObj, parent
	if hCtrl<0
		return
	endif
	ctiObj := cti_get_object_by_id(hCtrl)
	parent := ctiObj:parent
	//ret := parent:Set_Focus(ctiObj)
	ret := ctiObj:Set_Focus()
return ret
*******************************
static function BringWindowToTop()
	outlog("Call empty function;"+procname())
return
*******************************
static function CloseWindow(hWnd)
local ctiWin := cti_get_object_by_id(hWnd)
	ctiWin:destroy()
	adel(__aObj, hWnd)
return
*******************************
static function SetKey()
	outlog("Call empty function;"+procname())
return
*******************************
static function GetKeyState()
	outlog("Call empty function;"+procname())
return
*******************************
static function IsChild()
	outlog("Call empty function;"+procname())
return
*******************************
static function SysRefresh()
	outlog("Call empty function;"+procname())
return
*******************************
static function SetCursor()
	outlog("Call empty function;"+procname())
return
*******************************
static function CursorArrow()
	outlog("Call empty function;"+procname())
return
*******************************
static function MoveWindow( hWnd, nTop, nLeft, nWidth, nHeight, lRepaint )
local ret:=.f., item, ctiWin, oWnd

	if hWnd==NIL .or. hWnd==0
		return ret
	endif
	if nTop==NIL .or. nLeft==NIL .or. nWidth==NIL .or. nHeight==NIL
		return ret
	endif

	oWnd := __aObj[hWnd]
	if oWnd:className == "FWIN_TDIALOG"
		nTop := int(nTop/DLG_CHARPIX_H)
		nLeft := int(nLeft/DLG_CHARPIX_W)
		nWidth := int(nWidth/DLG_CHARPIX_W)
		nHeight := int(nHeight/DLG_CHARPIX_H)
	else
		nTop := int(nTop/WIN_CHARPIX_H)
		nLeft := int(nLeft/WIN_CHARPIX_W)
		nWidth := int(nWidth/WIN_CHARPIX_W)
		nHeight := int(nHeight/WIN_CHARPIX_H)
	endif


	DEFAULT lRepaint TO .t.

	ctiWin := cti_get_object_by_id(hWnd)
	ctiWin:set_position(nTop, nLeft)
	ctiWin:set_size(nHeight, nWidth)
	/*
	item := aWindows[hWnd]
	item:moveWindow(nTop, nLeft, nWidth, nHeight)
	if lRepaint
		item:update()
	endif
	*/
return .t.
*******************************
static function GetFocus()
	outlog("Call empty function;"+procname())
return
*******************************
static function DrawIcon()
	outlog("Call empty function;"+procname())
return
*******************************
static function WndPrint()
	outlog("Call empty function;"+procname())
return
*******************************
static function IsIconic()
	outlog("Call empty function;"+procname())
return
*******************************
static function InvalidateRect()
	outlog("Call empty function;"+procname())
return
*******************************
static function RegisterClass()
	outlog("Call empty function;"+procname())
return
*******************************
static function PostMessage(hWnd, cMsg, nWParam, nLParam)
local oCti, sig
	oCti := cti_get_object_by_id(hWnd)
	if !empty(oCti)
		cMsg := upper(cMsg)
		do case
		case cMsg == "HIDE"
		oCti:signal_emit(HASH_CTI_HIDE_SIGNAL)
		endcase
	endif
return
*******************************
static function DeleteObject()
	outlog("Call empty function;"+procname())
return
*******************************
static function SelectObject()
	outlog("Call empty function;"+procname())
return
*******************************
static function FwSetColor()
	outlog("Call empty function;"+procname())
return
*******************************
static function CreateStatusBar(oMsgBar)
local mess, ctiStBar, ctiParentWin

	ctiParentWin := cti_get_object_by_id(oMsgBar:oWnd:hWnd)

	ctiStBar := cti_StatusBar_New()
	ctiStBar:set_size(1, ctiParentWin:width-2)

	ctiStBar:set_position(ctiParentWin:height-2, 0)
	oMsgBar:hWnd := ctiStBar:id

	mess := oMsgBar:cMsg
	if oMsgBar:lCentered
		mess := padc(mess, ctiStBar:width)
	endif

	ctiStBar:Set_message(mess)
	ctiStBar:show()

	ctiParentWin:put(ctiStBar, ctiStBar:top, ctiStBar:left+1)
	__aObj[oMsgBar:hWnd] := oMsgBar
return
*******************************
static function PaintStatusBar(hWnd, cMsg, cMsgDef, lErase, lCentered, nWidth, nClrText, nClrPane, hFont, lInset)
local style, ctiStBar, oMsgBar
	DEFAULT lErase    TO .f.
	DEFAULT lInset    TO .f.
	DEFAULT lCentered TO .f.
	DEFAULT nClrText  TO 0
	DEFAULT nClrPane  TO GetSysColor( COLOR_BTNFACE )
outlog(__FILE__, __LINE__, procname())
	ctiStBar := cti_get_object_by_id(hWnd)
	oMsgBar := __aObj[hWnd]

	ctiStBar:set_message(iif(cMsg==NIL .or. empty(cMsg), cMsgDef, cMsg))
	/*
	style := gtk_WidgetGetStyle(hWnd)
	oMsgBar := gtk_GetObjByHandle(hWnd)
	gtk_WidgetSetStyle(oLabel, style)
	*/
outlog(__FILE__, __LINE__, int((oMsgBar:nWidth-oMsgBar:nSizeItem)/WIN_CHARPIX_W)-2)
	ctiStBar:set_size(1, int((oMsgBar:nWidth-oMsgBar:nSizeItem)/WIN_CHARPIX_W)-2)
return
*******************************
static function MsgPaint(hMsgBar, cMsg, cMsgDef, lErase, lCentered, nWidth, nClrText, nClrPane, oFont, lInset)
local style, ctiStBar, oMsgBar

	DEFAULT lErase    TO .f.
	DEFAULT lInset    TO .f.
	DEFAULT lCentered TO .f.
	DEFAULT nClrText  TO 0
	DEFAULT nClrPane  TO GetSysColor( COLOR_BTNFACE )

	ctiStBar := cti_get_object_by_id(hMsgBar)
	oMsgBar := __aObj[hMsgBar]

	ctiStBar:set_message(iif(cMsg==NIL .or. empty(cMsg), cMsgDef, cMsg))
	/*
	style := gtk_WidgetGetStyle(hWnd)
	oMsgBar := gtk_GetObjByHandle(hWnd)
	gtk_WidgetSetStyle(oLabel, style)
	*/

	ctiStBar:set_size(1, int((oMsgBar:nWidth-oMsgBar:nSizeItem)/WIN_CHARPIX_W)-2)

return
*******************************
static function AddMsgItem(hMsgBar, oItem)
local button, toolt, frame, style, ctiMsgBar, ctiWin, fwMsgBar

	ctiMsgBar := cti_get_object_by_id(hMsgBar)
	fwMsgBar := __aObj[hMsgBar]
	ctiWin := cti_get_object_by_id(fwMsgBar:oWnd:hWnd)
	style := ctiMsgBar:palette
	button := cti_pushButton_New(oItem:cMsg)
	button:palette := style
	button:show()
	oItem:hWnd := button:id

	/*
	if oItem:cToolTip != NIL .and. !empty(oItem:cToolTip)
		toolt := gtk_toolTipsNew()
		gtk_ToolTipsSetTip(toolt, button, oItem:cToolTip, "")
	endif
	*/
	if "BACTION"$oItem .and. oItem:bAction != NIL
		button:Signal_Connect(HASH_CTI_CLICKED_SIGNAL, {|w, e, fwobj| fwobj:bAction()}, oItem)
	endif
	/* because container not avilable in cti */
	ctiWin:put(button, 7, 5)
	/*
	gtk_ContainerAdd(frame, button)
	gtk_BoxPackStart(hMsgBar, frame)
	*/

return
*******************************
static function PaintMsgItem()
	outlog("Call empty function;"+procname())
return
*******************************
static function WndDrawBox()
	outlog("Call empty function;"+procname())
return
*******************************
static function WindowRaised()
	outlog("Call empty function;"+procname())
return
*******************************
static function WindowBoxIn()
	outlog("Call empty function;"+procname())
return
*******************************
static function MsgPaint3L()
	outlog("Call empty function;"+procname())
return
*******************************
static function CreateButtonBar()
	outlog("Call empty function;"+procname())
return
*******************************
static function CreateButton(self)
static Bnumber := 0
local button
	if !("CCAPTION"$self) .or. empty(self:cCaption)
		Bnumber ++
		self:cCaption := "Btn "+alltrim(toString(Bnumber))
	endif
	button := cti_pushbutton_new(self:cCaption, "&")
	/*****SET_SIZE****/
	//button:set_size(1, len(self:cCaption)+2)
	if self:className == "FWIN_TBUTTON"
		button:top := int(self:nTop/WIN_CHARPIX_H)
		button:left := int(self:nLeft/WIN_CHARPIX_W)
	else  // FWIN_TBTNBMP
	endif
	button:show()
	self:hWnd := button:id

	FwSetColor(self, self:nClrText, self:nClrPane)
	FwSetFont(self, self:oFont)

	button:signal_connect(HASH_CTI_SET_FOCUS_SIGNAL, {|w, e, fwobj|  fwobj:GotFocus(getActiveWindow())}, self)
	button:signal_connect(HASH_CTI_LOST_FOCUS_SIGNAL, {|w, e, fwobj|  fwobj:LostFocus()}, self)
	/*
	gtk_SignalConnect(self, "enter", {|w, e|  w:GotFocus(getActiveWindow())})
	gtk_SignalConnect(self, "leave", {|w, e|  w:LostFocus()})
	gtk_SignalConnect(self, "focus-in-event", {|w, e|  w:GotFocus(getActiveWindow())})
	gtk_SignalConnect(self, "focus-out-event", {|w, e|  w:LostFocus()})
	*/

	if "BACTION" $ self
		button:Signal_Connect(HASH_CTI_CLICKED_SIGNAL, {|btn, e, w| w:bAction()}, self)
	endif

/*
	if "OWND" $ self .and. self:oWnd != NIL
		if self:oWnd:classname == "FWIN_TBAR"
			gtk_WidgetSetSize(self, self:oWnd:nBtnWidth, self:oWnd:nBtnHeight)
		endif
	endif
*/
	__aObj[button:id] := self
return
*******************************
static function GColorNew()
	outlog("Call empty function;"+procname())
return
*******************************
static function nGetForeRGB()
	outlog("Call empty function;"+procname())
return
*******************************
static function nGetBackRGB()
	outlog("Call empty function;"+procname())
return
*******************************
static function CreateFont()
	outlog("Call empty function;"+procname())
return
*******************************
static function FwSetFont()
	outlog("Call empty function;"+procname())
return
*******************************
static function ChooseFont()
	outlog("Call empty function;"+procname())
return
*******************************
static function GetFontWidth()

return 1
*******************************
static function GetFontHeight()

return 1
*******************************
static function SetChosedFont()
	outlog("Call empty function;"+procname())
return
*******************************
static function GetDefaultFont()
	outlog("Call empty function;"+procname())
return
*******************************
static function SetDefaultFont()
	outlog("Call empty function;"+procname())
return
*******************************
static function SizeFont()
	outlog("Call empty function;"+procname())
return
*******************************
static function GetFontInfo()
	outlog("Call empty function;"+procname())
return
*******************************
static function PalBmpLoad()
	outlog("Call empty function;"+procname())
return
*******************************
static function PalBmpRead()
	outlog("Call empty function;"+procname())
return
*******************************
static function PalBmpNew()
	outlog("Call empty function;"+procname())
return
*******************************
static function CreateDlgBox(oDlg)
local Dialog, activeW, top, left, height, width, layout

	top := int(oDlg:nTop/DLG_CHARPIX_H)
	left := int(oDlg:nLeft/DLG_CHARPIX_W)
	width := int(oDlg:nWidth/DLG_CHARPIX_W)
	height := int(oDlg:nHeight/DLG_CHARPIX_H)

	Dialog := cti_Window_New(oDlg:cCaption, top, left, height, width)

	oDlg:oClient := cti_Layout_New()
	oDlg:oClient:hWnd := oDlg:oClient:id
	outlog(__FILE__, __LINE__, 'layout created, try add it to dialog')
	Dialog:add(oDlg:oClient)
	outlog(__FILE__, __LINE__, 'add it' )

	if "OWND"$oDlg .and. oDlg:oWnd != NIL
	  //	activeW := cti_get_object_by_id(oDlg:oWnd:hWnd)
		//activeW:put(Dialog) // while not realized
		//activeW:add(Dialog) // while not realized
		ctiApp:add(Dialog)
	else
		ctiApp:add(Dialog)
	endif
	oDlg:hWnd := Dialog:id
	__aObj[Dialog:id] := oDlg

	/* set modal */
	//gtk_WindowSetModal(oDlg, oDlg:lModal)

return oDlg
*******************************
static function EndDialog(oDlg, nResult)
local ctiWindow
	ctiWindow := cti_get_object_by_id(oDlg:hWnd)
	oDlg:nResult := nResult
	//ctiWindow:Signal_Emit(cti_signal_new(HASH_CTI_DELETE_SIGNAL))
	CloseWindow(oDlg:hWnd)
return
*******************************
static function DialogBoxIndirect(hInstance, cResName, hActiveWnd, oDlg)
local i, nResult, hFocus, ctiWin

	oDlg:Initiate(, oDlg:hWnd)
	nResult := -1000
	if hActiveWnd!= NIL .and. hActiveWnd != oDlg:hWnd
		//gtk_WindowSetTransientFor(oDlg, hActiveWnd)
	endif

	ctiWin:Signal_Connect(HASH_CTI_DELETE_SIGNAL, {|w, e, oD| iif(oD:end(), (w:destroy(), cti_quit()), )}, oDlg)

	outlog(__FILE__, __LINE__, 'try show dialog')
	ShowWindow(oDlg, 1, @nResult)
	outlog(__FILE__, __LINE__, 'show ok')

	/*
	gtk_SignalConnect(oDlg, 'focus-in-event', ;
		{|w, e| oDlg:GotFocus(), oDlg:HandleEvent(WM_PAINT)})
		*/

	//ctiWin:show_all()

	outlog(__FILE__, __LINE__, 'try cti_main')
	cti_Main()
	adel(__aObj, oDlg:hWnd)
return nResult
*******************************
static function NextDlgTab(oWnd, hControl, lPrev)
local hCtrl, _step:=1, hC:=1, nLen
	lPrev := iif(lPrev==NIL, .f., lPrev)
	nLen := len(oWnd:aControls)
	if lPrev
		_step := -1
	endif
	aEval(oWnd:aControls, {|x,y| iif(x:hWnd==hControl, hC:=y, nil)})
	hC += _step
	if hC<1
		hC := nLen
	endif
	if hC>nLen
		hC := 1
	endif
	if hC <= nLen
		hCtrl := oWnd:aControls[hC]:hWnd
	endif
return hCtrl
/*****************************************************************************
Get function
*****************************************************************************/
static function mGetCreate(oEntry, cCaption, nStyle, nLeft, nTop, nWidth, ;
			   nHeight, hWnd, nId, hHeap )
local ctiEntry

	ctiEntry := cti_Entry_New("C")//, oEntry:cPicture)

	ctiEntry:Set_Value(cCaption)
	ctiEntry:Set_Position(int(nTop/GET_CHARPIX_H), int(nLeft/GET_CHARPIX_W))

	if nWidth != NIL
		ctiEntry:Set_Size(1, int(nWidth/GET_CHARPIX_W))
	else
		ctiEntry:Set_Size(1, 10)
	endif

	ctiEntry:signal_connect(HASH_CTI_EVENT, {|en, ev, wgt| wgt:KeyChar(ev) }, oEntry)
	if "CMSG"$oEntry .and. oEntry:cMsg != NIL
		ctiEntry:signal_connect(HASH_CTI_SET_FOCUS_SIGNAL, {|w, e, fwobj|  fwobj:GotFocus(getActiveWindow())}, oEntry)
		ctiEntry:signal_connect(HASH_CTI_LOST_FOCUS_SIGNAL, {|w, e, fwobj|  fwobj:LostFocus()}, oEntry)
	endif
	/*
		/* mouse cursor enters on button region */
		gtk_SignalConnect(oEntry, "enter", {|w, e| w:GotFocus(GetActiveWindow())})
		gtk_SignalConnect(oEntry, "focus-in-event", {|w, e| w:GotFocus(GetActiveWindow())})
		/* mouse cursor leave button region */
		gtk_SignalConnect(oEntry, "leave", {|w, e| w:LostFocus()})
		gtk_SignalConnect(oEntry, "focus-out-event", {|w, e| w:LostFocus()})
	*/
	ctiEntry:show()
	__aObj[ctiEntry:id] := oEntry
return ctiEntry:id
*******************************
static function SetText(oEntry, uVal)
local ctiEntry := cti_get_object_by_id(oEntry:hWnd)
	if ctiEntry != NIL .and. ctiEntry:className == "CTI_ENTRY"
		ctiEntry:Set_value(ToString(uVal))
		ctiEntry:set_pos(1)
	endif
return
*******************************
static function SetGetText(hEntry, uVal, nPos)
local ctiEntry := cti_get_object_by_id(hEntry)
	ctiEntry:set_value(ToString(uVal))
	if nPos != nil
		ctiEntry:set_pos(nPos)
	endif
return
/*****************************************************************************
Label function
*****************************************************************************/
static function CreateLabel(oWnd)
local label
	label := cti_Label_New(oWnd:cCaption, "&")
	oWnd:hWnd := label:id
	label:Set_Position(int(oWnd:nTop/SAY_CHARPIX_H), int(oWnd:nLeft/SAY_CHARPIX_W))
	label:Set_Size( 1, int(oWnd:nWidth/SAY_CHARPIX_W))
	label:show()
	__aObj[label:id] := oWnd
return
*******************************
static function SetWindowText(hWnd, cText)
local cType, ctiWin := cti_get_object_by_id(hWnd)
	cType := ctiWin:className
	do switch cType
	case "CTI_LABEL"
		ctiWin:Set_Text(cText, "&")
	case "CTI_DIALOG", "CTI_WINDOW"
		//gtk_WindowSetTitle(hWnd, cText)???
	endswitch
return
*******************************
static function CreateProgressBar()
	outlog("Call empty function;"+procname())
return
*******************************
static function ProgressPaint()
	outlog("Call empty function;"+procname())
return
*******************************
static function ProgressBarSetTotal()
	outlog("Call empty function;"+procname())
return
*******************************
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
*******************************
static function CreateListbox()
	outlog("Call empty function;"+procname())
return
*******************************
static function configure_event()
	outlog("Call empty function;"+procname())
return
*******************************
static function expose_event()
	outlog("Call empty function;"+procname())
return
*******************************
static function GetDc()
	outlog("Call empty function;"+procname())
return
*******************************
static function ReleaseDc()
	outlog("Call empty function;"+procname())
return
*******************************
static function CreatePen()
	outlog("Call empty function;"+procname())
return
*******************************
static function MoveTo()
	outlog("Call empty function;"+procname())
return
*******************************
static function LineTo()
	outlog("Call empty function;"+procname())
return
*******************************
static function CreateSolidBrush()
	outlog("Call empty function;"+procname())
return
*******************************
static function FWBrushes()
	outlog("Call empty function;"+procname())
return
*******************************
static function DrawMsgItem()
	outlog("Call empty function;"+procname())
return
*******************************
static function ExtTextOut()
	outlog("Call empty function;"+procname())
return
*******************************
static function DrawText()
	outlog("Call empty function;"+procname())
return
*******************************
static function WndBoxIn()
	outlog("Call empty function;"+procname())
return
*******************************
static function SetTimer()
	outlog("Call empty function;"+procname())
return
*******************************
static function KillTimer()
	outlog("Call empty function;"+procname())
return
*******************************
static function ReadBitmap()
	outlog("Call empty function;"+procname())
return
*******************************
static function CreateScrollBar()
	outlog("Call empty function;"+procname())
return
*******************************
static function SetScrollRange()
	outlog("Call empty function;"+procname())
return
*******************************
static function SetScrollPos()
	outlog("Call empty function;"+procname())
return
*******************************
static function GetMDIInstance()
	outlog("Call empty function;"+procname())
return
*******************************
static function cMdiStruct()
	outlog("Call empty function;"+procname())
return
*******************************
static function CreateTabs()
	outlog("Call empty function;"+procname())
return
*******************************************************************************
* Messages functions                                                          *
*******************************************************************************
static function __MsgBox(cMsg, cTitle, FontMessage, lbStyle, cXPM, aButtons, aReturn)
#define DEF_BUTT	[&OK]
local nWidth, nHeight
local Button, Label, activeWnd
local Dialog, inFocus, i, ret:=.f., DialLay
local BtnWidth:=40, BtnHeight:=25, hbox, vbox
local aMes, str, j, k, lenMes, lenMas, x, n, m, curLine, id


	FWInitDriver()

	activeWnd := GetActiveWindow()
	activeWnd := cti_get_object_by_id(activeWnd)

	aMes := {}
	str := alltrim(toString(cMsg))
	do while !empty(str)
		k := at(";", str)
		j=k
		if k==0
			j:=len(str)+1
		endif
		j=min(j, activeWnd:width-2)
		aadd(aMes, substr(str,1,j-1) )
		str:=substr(str,j+iif(k!=0,1,0))
	enddo
	lenmes=len(aButtons)
	k=2;n=0
	for i=1 to lenmes
		k+=len(aButtons[i])+4
		n+=len(aButtons[i])+2
	next
	lenMas=len(aMes)
	j=k
	for i=1 to lenMas
		j=max(j,len(aMes[i])+2)
	next
	//setcolor(color)

	/****SET_SIZE****/
	//Dialog := cti_Window_New(cTitle, 1, 1, 3+lenMas, j+1)
	Dialog := cti_Window_New(cTitle)
	Dialog:set_size(3+lenMas, j+1)
	Dialog:center()
	DialLay := cti_layout_new(3+lenMas, j+1)
	DialLay:show()
	Dialog:add(DialLay)
	id := Dialog:id
	__aObj[id] := Dialog

	Dialog:signal_connect(HASH_CTI_DELETE_SIGNAL, {|w, e| w:hide()})
	Dialog:signal_connect(HASH_CTI_HIDE_SIGNAL, {|w, e| w:Destroy(), cti_quit()})

	//gtk_WindowSetModal(Dialog, .t.)

	if aReturn != NIL .and. !empty(aReturn)
		ret := iif(valtype(aReturn[1])=="N", 0, .f.)
	endif
	curLine := 0
	for i = 1 to len(aMes)
		str := padc(aMes[i], j-1)
		label := cti_Label_New( str )
		label:set_size(1,len( str ))
		label:show()
		DialLay:put(label, ++CurLine, 1)
	next
	curLine ++
	if aButtons == NIL
		Button := cti_pushButton_New(DEF_BUTT, "&")

		Button:Signal_Connect(HASH_CTI_CLICKED_SIGNAL, {|w,e,dial| ret:=.t., dial:hide()}, Dialog)
		/*
		gtk_WidgetAddAccelerator(Button, GTK_CLICKED_SIGNAL, Dialog, ;
			Button:AccelKey)
		gtk_WidgetAddAccelerator(Button, GTK_CLICKED_SIGNAL, Dialog, ;
			Button:AccelKey, GDK_CONTROL_MASK)
		*/
		Button:show()
		DialLay:put(Button, curLine, Dialog:width-len(DEF_BUTT)/2)
		inFocus := Button:id
	else
		Button := {}
		asize(aReturn, len(aButtons))
		m=int((j-n)/(lenmes+1))
		x:=m+1
		for i=1 to len(aButtons)
			aadd(Button, cti_pushButton_New(aButtons[i], "&"))
			Button[i]:nResult := iif(aReturn[i]==NIL, i, aReturn[i])
			Button[i]:Signal_Connect(HASH_CTI_CLICKED_SIGNAL,{|w,e, dial| ret:=w:nResult, dial:hide()},Dialog)
			/*
			gtk_WidgetAddAccelerator(Button[i], GTK_CLICKED_SIGNAL, Dialog, ;
				Button[i]:AccelKey)
			gtk_WidgetAddAccelerator(Button[i], GTK_CLICKED_SIGNAL, Dialog, ;
				Button[i]:AccelKey, GDK_CONTROL_MASK)
			*/
			Button[i]:show()
			DialLay:put(Button[i], curLine, x)
			x+=len(aButtons[i])+m+2
			if i==1
				inFocus := Button[i]:id
			endif
		next
	endif

	Dialog:show()
	ctiApp:add(Dialog)
	//ActiveWnd:put(Dialog)
	//Dialog:Set_Focus(inFocus)
	//ctiApp:set_focus(Dialog)
	Dialog:set_focus_child()
	cti_main()
	adel(__aObj, id)
	//outlog(__FILE__, __LINE__, "cti_quit()")
return ret
*******************************
static function __MsgAbout(FontMessage, lbStyle)
local cMsg

	cMsg := FWCOPYRIGHT + ";" + ;
		FWVERSION   + ";" + ;
		"OS-version: "+OS() + ";" + ;
		"CTI-version: "//+version))

return __MsgBox(cMsg, [About], FontMessage, lbStyle,,{[&OK]}, {.t.})

*******************************
static function __InitMessageStyle(lbStyle, FontMessage)
	//lbStyle := cti_WidgetGetDefaultStyle()

	FontMessage := nil
return
*******************************
static function __MsgBeep()
	tone()
return
*******************************
static function __ChooseColor()
	outlog("Call empty function;"+procname())
return
*******************************
static function Calendar(date)
local wnd, ctiCalendar, nWidth, nHeight, nTop, nLeft, ret

	date := iif(date==NIL .or. valtype(date)!= "D", date(), date)
	ret := date

	FWInitDriver()

	ctiCalendar := cti_calendar_new(date)
	ctiCalendar:show()

	ctiCalendar:signal_connect(HASH_CTI_DELETE_SIGNAL, {|wnd| wnd:Hide()})
	ctiCalendar:signal_connect(HASH_CTI_HIDE_SIGNAL, {|wnd| wnd:Destroy(), cti_Quit()})
	ctiCalendar:signal_connect(HASH_DAY_SELECTED_SIGNAL, {|wnd| ret:= wnd:get_date(), wnd:Destroy(), cti_Quit()})

	ctiCalendar:center()

	ctiApp:put(ctiCalendar)

	cti_Main()
return ret
*******************************************************************************
* Menu function                                                               *
*******************************************************************************
static function IsMenu(hItem)

return .f.
*************
static function CreateMenu(oMenu)
local ctiMenu
	if len(aMenuStack)==0
		ctiMenu := cti_MenuBar_New()
		oMenu:hWnd := ctiMenu:id
		oMenu:handle := ctiMenu:id
	else
		ctiMenu := cti_Menu_New()
		oMenu:hWnd := ctiMenu:id
		oMenu:handle := ctiMenu:id
		oLastItem:set_submenu( ctiMenu)
	endif

	ctiMenu:show()
	aadd(aMenuStack, oMenu )

return oMenu:handle
*******************************
static function CreatePopupMenu()
	outlog("Call empty function;"+procname())
return
*******************************
static function GetSystemMenu()
	outlog("Call empty function;"+procname())
return
*******************************
static function TrackPopup()
	outlog("Call empty function;"+procname())
return
*******************************
static function AppendMenu(hMenu, oItem, nFlags, nId, cPrompt)
local oMenu, lb, box, ctiItem

	oMenu := cti_get_object_by_id(hMenu)

	if numOr(nFlags, MF_BITMAP) == nFlags
		ctiItem := cti_menuItem_new ("")
		oItem:hWnd := ctiItem:id
	else
		if cPrompt == NIL .or. empty(cPrompt)
			ctiItem := cti_MenuItem_New ("")//, popUp() )
		else
			ctiItem := cti_MenuItem_New (cPrompt, "&")//, popUp() )
		endif
		ctiItem:show()
		aadd(aMenuAccel, ctiItem)
	endif

	oItem:hWnd := ctiItem:id
	oItem:hMenu := ctiItem:id

	if oItem:lChecked != NIL
		//oItem:checked := lChecked
	endif
	if oItem:lActive != NIL
		ctiItem:set_enabled(oItem:lActive)
	endif
	if oItem:cMsg != NIL
		//oItem:message := cMsg
	endif
	if oItem:bAction != NIL
		ctiItem:signal_connect(HASH_CTI_ACTIVATE_SIGNAL, {|w, e, fw| fw:bAction()}, oItem)
	endif
	/*if nEvent != NIL
		oItem:id := nEvent
	endif*/

return
*******************************
static function MenuBegin(lPopup, lSystem, oWnd)
local oMenu
	oMenu := TMenu():New(lPopup, oWnd)
return oMenu
*******************************
static function MenuAddItem(cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile, ;
			cResName, oMenu, bBlock, nVKState, nVirtKey, lHelp, nHelpId, bWhen, lBreak )
local oItem, ctiItem

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

	ctiItem := cti_get_object_by_id(oItem:hWnd)
	oLastItem := ctiItem
	if len(aMenuStack)==1
		outlog(__FILE__, __LINE__, aMenuStack[1]:classname)
		ctiMenu := cti_get_object_by_id(aMenuStack[1]:hWnd)
		ctiMenu:add_item(ctiItem)
	else
		ctiMenu := cti_get_object_by_id(aMenuStack[len(aMenuStack)]:hWnd)
		ctiMenu:add_item(ctiItem)
	endif
return oItem
*******************************
static function MenuEnd()
local ret := atail(aMenuStack)
	asize(aMenuStack, len(aMenuStack)-1 )
return ret
*******************************
static function SetMenu(oWnd, oMenu)
local i, item, ctiParentWnd, ctiMenu
	for i=1 to len(aMenuAccel)
		item := aMenuAccel[i]
		/*
		gtk_WidgetAddAccelerator(item:Handle, GTK_ACTIVATE_ITEM_SIGNAL, oWnd, ;
			item:AccelKey, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE)
			*/
	next
	ctiParentWnd := cti_get_object_by_id(oWnd:hWnd)
	ctiMenu := cti_get_object_by_id(oMenu:hMenu)
	ctiMenu:set_size(1, ctiParentWnd:width-2)
	ctiParentWnd:put(ctiMenu, 0, 1)
	//ctiApp:put(ctiMenu)
	aMenuAccel := {}
return
*******************************
static function GetSubMenu()
	outlog("Call empty function;"+procname())
return
*******************************
static function DrawMenuBar()
	outlog("Call empty function;"+procname())
return
*******************************
static function MenuMeasureItem()
	outlog("Call empty function;"+procname())
return
*******************************************************************************
* System functions                                                            *
*******************************************************************************
static function InitFWDriver()
	if !__FW_INIT
		ctiApp := cti_Init()
		if ctiApp!=nil
			__FW_INIT := .t.
			ctiApp:show()
			qout('CTI system inizialized &\n')
			InitMessageStyle()
		endif
	endif
return __FW_INIT
*******************************
static function lWRunning()
return cti_events_pending()
*******************************
static function WinRun()
	cti_main()
return
*******************************
static function WinClose()
	cti_quit()
return
*******************************
static function WinExec(cAppl)
local txt
	txt := cAppl+CRLF+"This program cannot be run in TEXT mode!"
	MsgInfo(txt, [Sorry!!!])
return
*******************************
static function WinHelp(cFile)
local txt
	txt := cFile+CRLF+"This program cannot be run in TEXT mode!"
	MsgInfo(txt, [Sorry!!!])
return
*******************************
static function SetWndApp(hWnd)
	hWndApp := hWnd
	cti_Main()
return
*******************************
static function GetWndApp()
return hWndApp
*******************************
static function SendMessage(oWnd, nMsg, nWParam, nLParam)
local ret, nS:=0, nE:=0, nRow
	do switch nMsg
	/****** GET MESSAGES ******/
	case WM_USER //EM_GETSEL
		//ret := oWnd:get_selection(@nS, @nE)
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
*******************************
static function GetParent(hWnd)
local hParentWnd, ctiWin
	ctiWin := cti_get_object_by_id(hWnd)
	hParentWnd := ctiWin:parent:id
	//hParentWnd := cti_Widget_Get_Parent_Window(hWnd)
	if hParentWnd == NIL
		hParentWnd := -1
	endif
return hParentWnd
*******************************
static function ClientToScreen(hWnd, aPos) // aPos = {nRow, nCol}
local nPos, nRow, nCol, ctiWin
	ctiWin := cti_get_object_by_id(hWnd)
	nRow := ctiWin:top; nCol := ctiWin:left
	nPos := {}
	aadd(nPos, nRow + aPos[1] * GRP_CHARPIX_H)
	aadd(nPos, nCol + aPos[2] * GRP_CHARPIX_W)
return nPos
*******************************
static function GetSysMetrics()
	outlog(__FILE__, __LINE__, "Get Sys metricse not realized!!!")
return
*******************************************************************************
* FileDialog functions
static function FileDialog(cMask, cTitle)
local cFileName:="", fileSel, activeWnd
	FWInitDriver()

	cTitle := iif(empty(cTitle), [File selection], cTitle)
	cMask := iif(empty(cMask), "*", cMask)

	activeWnd := GetActiveWindow()
	fileSel := cti_FileDialog_new(, cMask, cTitle)

	if activeWnd > -1
		//gtk_WindowSetTransientFor(fileSel, activeWnd)
	endif

	//fileSel:signal_connect(HASH_CTI_DELETE_SIGNAL, {|w,e| w:signal_emit(HASH_CTI_HIDE_SIGNAL)})
	fileSel:signal_connect(HASH_CTI_HIDE_SIGNAL, {|w| w:Destroy(), cti_Quit()})
	fileSel:cancelButton:signal_connect(HASH_CTI_CLICKED_SIGNAL, {|w, e, fd| fd:hide()}, fileSel)
	fileSel:okButton:signal_connect(HASH_CTI_CLICKED_SIGNAL, {|w, e, fd| cFileName := fd:retFile, fd:hide()}, fileSel)

	fileSel:Show()
	ctiApp:put(fileSel)
	cti_main()

return cFileName
******************************************************************************
*
static function KeyboardEvent(event)
return event == CTI_KEYBOARD_EVENT

