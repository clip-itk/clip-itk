/*   FiveWin likely functions					*/
/*   CTI system functions					*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   License : (GPL) http://www.itk.ru/clipper/licence.html	*/

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

return selector

static function isZoomed()
return
*******************************
static function GetInstance()
return
*******************************
static function RefreshObj()
return
*******************************
static function SetWindowPos()
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
			oMenu := cti_Get_Obj_by_id(oWnd:oMenu:hMenu)
			if oMenu:__is_focused
				ctiApp:set_focus(focus)
			else
				focus := ctiApp:__FocusedObj
				ctiApp:set_focus(oMenu)
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

*/
	ctiApp:put(oCTI)

	cti_event_connect(HASH_CTI_KEYBOARD_EVENT, @__keybHandler())
	//outlog(__FILE__, __LINE__, 'connect signal', HASH_DELETE_EVENT, 'to id', oCTI:id)
	oCTI:Signal_Connect(HASH_CTI_DELETE_SIGNAL, {|w, e, obj| iif(obj:end(), CloseAppl(w), nil)}, oWnd)
	//oCTI:Signal_Connect(HASH_CTI_HIDE_SIGNAL, oWnd, {|w, e, obj| iif(obj:end(), CloseAppl(w), nil)})

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

return oWnd:Handle
*******************************
static function CloseAppl(oWnd)
	cti_Quit()
return
*******************************
static function ValueChanged()
return
*******************************
static function CoorsUpdate()
return
*******************************
static function PostChild()
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
return
*******************************
static function WndCenter()
return
*******************************
static function GetCoors(hWnd)
local aRect, nTop, nLeft, nWidth, nHeight, ctiWnd
	ctiWnd := cti_get_object_by_id(hWnd)
	aRect := map()
	aRect:Left   := ctiWnd:Left
	aRect:Top    := ctiWnd:Top
	aRect:Right  := ctiWnd:Left + ctiWnd:Width - 1
	aRect:Bottom := ctiWnd:Top + ctiWnd:Height - 1
return aRect
*******************************
static function GetClientRect()
return
*******************************
static function ShowChildrenControls()
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

			oCti:put(itemCti, itemCti:Top, itemCti:Left)
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
		//outlog(__FILE__, __LINE__, oWnd:className, 'handle',iif("HANDLE"$oWnd, oWnd:handle, "no"))
		oCti:Show()
	endswitch
	if !empty(oWnd:bPainted)
		eval(oWnd:bPainted)
	endif
	ctiApp:Set_Focus(oCti)
	//outlog(__FILE__, __LINE__, "check visible",GTK_WIDGET_VISIBLE(oWnd), 'focus', GTK_WIDGET_HAS_FOCUS(oWnd), 'mapped', GTK_WIDGET_MAPPED(oWnd))
return
*******************************
static function UpdateWindow()
return
*******************************
static function WSay()
return
*******************************
static function DragQueryPoint()
return
*******************************
static function BeginPaint()
return
*******************************
static function EndPaint()
return
*******************************
static function GetTextWidth()
return
*******************************
static function GetWndRect()
return
*******************************
static function NexDlgTab()
return
*******************************
static function SetFocus()
return
*******************************
static function BringWindowToTop()
return
*******************************
static function CloseWindow(hWnd)
local ctiWin := cti_get_object_by_id(hWnd)
	ctiWin:destroy()
	adel(__aObj, hWnd)
return
*******************************
static function SetKey()
return
*******************************
static function GetKeyState()
return
*******************************
static function IsChild()
return
*******************************
static function SysRefresh()
return
*******************************
static function SetCursor()
return
*******************************
static function CursorArrow()
return
*******************************
static function MoveWindow()
return
*******************************
static function GetFocus()
return
*******************************
static function DrawIcon()
return
*******************************
static function WndPrint()
return
*******************************
static function IsIconic()
return
*******************************
static function InvalidateRect()
return
*******************************
static function RegisterClass()
return
*******************************
static function PostMessage()
return
*******************************
static function DeleteObject()
return
*******************************
static function SelectObject()
return
*******************************
static function FwSetColor()
return
*******************************
static function CreateStatusBar()
return
*******************************
static function PaintStatusBar()
return
*******************************
static function MsgPaint()
return
*******************************
static function AddMsgItem()
return
*******************************
static function PaintMsgItem()
return
*******************************
static function WndDrawBox()
return
*******************************
static function WindowRaised()
return
*******************************
static function WindowBoxIn()
return
*******************************
static function MsgPaint3L()
return
*******************************
static function CreateButtonBar()
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
	button:set_size(1, len(self:cCaption)+2)
	button:top := int(self:nTop/WIN_CHARPIX_H)
	button:left := int(self:nLeft/WIN_CHARPIX_W)
	button:show()
	self:hWnd := button:id

	FwSetColor(self, self:nClrText, self:nClrPane)
	FwSetFont(self, self:oFont)

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
return
*******************************
static function GColorNew()
return
*******************************
static function nGetForeRGB()
return
*******************************
static function nGetBackRGB()
return
*******************************
static function CreateFont()
return
*******************************
static function FwSetFont()
return
*******************************
static function ChooseFont()
return
*******************************
static function GetFontWidth()
return
*******************************
static function GetFontHeight()
return
*******************************
static function SetChosedFont()
return
*******************************
static function GetDefaultFont()
return
*******************************
static function SetDefaultFont()
return
*******************************
static function SizeFont()
return
*******************************
static function GetFontInfo()
return
*******************************
static function PalBmpLoad()
return
*******************************
static function PalBmpRead()
return
*******************************
static function PalBmpNew()
return
*******************************
static function CreateDlgBox(oDlg)
local Dialog, activeW
	Dialog := cti_Window_New(oDlg:cCaption)
	Dialog:top := int(oDlg:nTop/DLG_CHARPIX_H)
	Dialog:left := int(oDlg:nLeft/DLG_CHARPIX_W)
	Dialog:width := int(oDlg:nWidth/DLG_CHARPIX_W)
	Dialog:height := int(oDlg:nHeight/DLG_CHARPIX_H)
	oDlg:hWnd := Dialog:id
	Dialog:set_position(Dialog:top, Dialog:left)
	Dialog:set_size(Dialog:height, Dialog:width)

	if "OWND"$oDlg .and. oDlg:oWnd != NIL
		activeW := cti_get_object_by_id(oDlg:oWnd:hWnd)
		//activeW:put(Dialog) // while not realized
		ctiApp:put(Dialog)
	else
		ctiApp:put(Dialog)
	endif
	__aObj[oDlg:hWnd] := oDlg

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
	ctiWin := cti_get_object_by_id(oDlg:hWnd)
	if hActiveWnd!= NIL .and. hActiveWnd != oDlg:hWnd
		//gtk_WindowSetTransientFor(oDlg, hActiveWnd)
	endif

	ctiWin:Signal_Connect(HASH_CTI_DELETE_SIGNAL, {|w, e, oD| iif(oD:end(), (w:destroy(), cti_quit()), )}, oDlg)

	ShowWindow(oDlg, 1, @nResult)

	/*
	gtk_SignalConnect(oDlg, 'focus-in-event', ;
		{|w, e| oDlg:GotFocus(), oDlg:HandleEvent(WM_PAINT)})
		*/

	ctiWin:show()

	x:=ctiWin
	aa := cti_entry_new("C", "@S20")
	aa:set_size(1, 20)
	aa:set_value("abrakadabra")
	aa:show()
	bb := cti_label_new("Ctttwtwt")
	bb:set_size(1, 20)
	bb:show()
	outlog(__FILE__, __LINE__, iif(x!=nil, x:classname, 'it is not window!!!!'))
	x:put(aa, 5, 20)
	x:put(bb, 6, 20)

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
	aEval(oWnd:aControls, {|x,y| iif(x:handle==hControl, hC:=y, nil)})
	hC += _step
	if hC<1
		hC := nLen
	endif
	if hC>nLen
		hC := 1
	endif
	if hC <= nLen
		hCtrl := oWnd:aControls[hC]:handle
	endif
return hCtrl
/*****************************************************************************
Get function
*****************************************************************************/
static function mGetCreate(oEntry, cCaption, nStyle, nLeft, nTop, nWidth, ;
			   nHeight, hWnd, nId, hHeap )
local hFunc := oEntry:KeyChar, ctiEntry
	ctiEntry := cti_Entry_New("C", oEntry:cPicture)

	x:=cti_get_object_by_id(oEntry:oWnd:hWnd)
	aa := cti_entry_new("C")
	aa:set_size(1, 20)
	aa:set_value("abrakadabra")
	aa:show()
	outlog(__FILE__, __LINE__, hWnd, iif(x!=nil, x:classname, 'it is not window!!!!'))
	x:put(aa, 5, 20)

//	ctiEntry:Set_Value(cCaption)
	ctiEntry:Set_Position(int(nTop/GET_CHARPIX_H), int(nLeft/GET_CHARPIX_W))
/*
	if nWidth != NIL
		ctiEntry:Set_Size(1, int(nWidth/GET_CHARPIX_W))
	else
		ctiEntry:Set_Size(1, 10)
	endif
*/
	ctiEntry:__cursorPos := oEntry:nPos-1
	ctiEntry:__Set_Cursor( )  // entry position started with 0
	//gtk_SignalConnect(oEntry, GTK_EVENT, {|wgt, ev| wgt:KeyChar(ev) })
	/*
	if "CMSG"$oEntry .and. oEntry:cMsg != NIL
		/* mouse cursor enters on button region */
		gtk_SignalConnect(oEntry, "enter", {|w, e| w:GotFocus(GetActiveWindow())})
		gtk_SignalConnect(oEntry, "focus-in-event", {|w, e| w:GotFocus(GetActiveWindow())})
		/* mouse cursor leave button region */
		gtk_SignalConnect(oEntry, "leave", {|w, e| w:LostFocus()})
		gtk_SignalConnect(oEntry, "focus-out-event", {|w, e| w:LostFocus()})
	endif
	*/
	ctiEntry:show()
return ctiEntry:id
*******************************
static function SetText(oEntry, uVal)
local ctiEntry := cti_get_object_by_id(oEntry:hWnd)
	if ctiEntry != NIL .and. ctiEntry:className == "CTI_ENTRY"
		ctiEntry:Set_value(ToString(uVal))
		ctiEntry:__cursorPos := 1
		ctiEntry:__Set_Cursor()
	endif
return
*******************************
static function SetGetText(hEntry, uVal, nPos)
local ctiEntry := cti_get_object_by_id(hEntry)
	ctiEntry:Set_value(ToString(uVal))
	if nPos != nil
		ctiEntry:__cursorPos := nPos-1
		ctiEntry:__Set_Cursor()
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
return
*******************************
static function ProgressPaint()
return
*******************************
static function ProgressBarSetTotal()
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
return
*******************************
static function configure_event()
return
*******************************
static function expose_event()
return
*******************************
static function GetDc()
return
*******************************
static function ReleaseDc()
return
*******************************
static function CreatePen()
return
*******************************
static function MoveTo()
return
*******************************
static function LineTo()
return
*******************************
static function CreateSolidBrush()
return
*******************************
static function FWBrushes()
return
*******************************
static function DrawMsgItem()
return
*******************************
static function ExtTextOut()
return
*******************************
static function DrawText()
return
*******************************
static function WndBoxIn()
return
*******************************
static function SetTimer()
return
*******************************
static function KillTimer()
return
*******************************
static function ReadBitmap()
return
*******************************
static function CreateScrollBar()
return
*******************************
static function SetScrollRange()
return
*******************************
static function SetScrollPos()
return
*******************************
static function GetMDIInstance()
return
*******************************
static function cMdiStruct()
return
*******************************
static function CreateTabs()
return
*******************************************************************************
* Messages functions                                                          *
*******************************************************************************
static function __MsgBox(cMsg, cTitle, FontMessage, lbStyle, cXPM, aButtons, aReturn)
#define DEF_BUTT	[&OK]
local nWidth, nHeight
local Button, Label, activeWnd
local Dialog, inFocus, i, ret:=.f.
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

	Dialog := cti_Window_New(cTitle, 1, 1, 3+lenMas, j+1)
	Dialog:center()
	id := Dialog:id
	__aObj[id] := Dialog

	//gtk_SignalConnect(Dialog, GTK_DELETE, {|| gtk_WidgetHideOnDelete(Dialog)})
	//Dialog:Signal_Connect(HASH_CTI_HIDE_SIGNAL, {|w, e| w:Destroy()})

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
		Dialog:put(label, ++CurLine, 1)
	next
	curLine ++
	if aButtons == NIL
		Button := cti_pushButton_New(DEF_BUTT, "&")

		Button:Signal_Connect(HASH_CTI_CLICKED_SIGNAL, {|w,e,dial| ret:=.t., dial:Destroy(), cti_quit()}, Dialog)
		/*
		gtk_WidgetAddAccelerator(Button, GTK_CLICKED_SIGNAL, Dialog, ;
			Button:AccelKey)
		gtk_WidgetAddAccelerator(Button, GTK_CLICKED_SIGNAL, Dialog, ;
			Button:AccelKey, GDK_CONTROL_MASK)
		*/
		Button:show()
		Dialog:put(Button, curLine, Dialog:width-len(DEF_BUTT)/2)
		inFocus := Button:id
	else
		Button := {}
		asize(aReturn, len(aButtons))
		m=int((j-n)/(lenmes+1))
		x:=m+1
		for i=1 to len(aButtons)
			aadd(Button, cti_pushButton_New(aButtons[i], "&"))
			Button[i]:nResult := iif(aReturn[i]==NIL, i, aReturn[i])
			Button[i]:Signal_Connect(HASH_CTI_CLICKED_SIGNAL,{|w,e, dial| ret:=w:nResult, dial:Destroy(), cti_quit()},Dialog)
			/*
			gtk_WidgetAddAccelerator(Button[i], GTK_CLICKED_SIGNAL, Dialog, ;
				Button[i]:AccelKey)
			gtk_WidgetAddAccelerator(Button[i], GTK_CLICKED_SIGNAL, Dialog, ;
				Button[i]:AccelKey, GDK_CONTROL_MASK)
			*/
			Button[i]:show()
			Dialog:put(Button[i], curLine, x)
			x+=len(aButtons[i])+m+2
			if i==1
				inFocus := Button[i]:id
			endif
		next
	endif

	Dialog:show()
	ctiApp:put(Dialog)
	//ActiveWnd:put(Dialog)
	//Dialog:Set_Focus(inFocus)
	ctiApp:set_focus(Dialog)
	cti_main()
	adel(__aObj, id)
	//outlog(__FILE__, __LINE__, "cti_quit()")
return ret
*******************************
static function __MsgAbout()
return
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
return
*******************************
static function Calendar()
return
*******************************************************************************
* Menu function                                                               *
*******************************************************************************
static function IsMenu()
return
*******************************
static function CreateMenu()
return
*******************************
static function CreatePopupMenu()
return
*******************************
static function GetSystemMenu()
return
*******************************
static function TrackPopup()
return
*******************************
static function AppendMenu()
return
*******************************
static function MenuBegin()
return
*******************************
static function MenuAddItem()
return
*******************************
static function MenuEnd()
return
*******************************
static function SetMenu()
return
*******************************
static function GetSubMenu()
return
*******************************
static function DrawMenuBar()
return
*******************************
static function MenuMeasureItem()
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
static function SendMessage()
	outlog(__FILE__, __LINE__, "send message not realized!!!")
return
*******************************
static function GetParent(hWnd)
local hParentWnd
	hParentWnd := cti_Widget_Get_Parent_Window(hWnd)
	if hParentWnd == NIL
		hParentWnd := -1
	endif
return hParentWnd
*******************************
static function ClientToScreen(hWnd, aPos) // aPos = {nRow, nCol}
local nPos, nRow, nCol
	nRow := 0; nCol := 0
	cti_Widget_Get_Position(hWnd, @nCol, @nRow)
	nPos := {}
	aadd(nPos, nRow + aPos[1] * GRP_CHARPIX_H)
	aadd(nPos, nCol + aPos[2] * GRP_CHARPIX_W)
return nPos
*******************************
static function GetSysMetrics()
	outlog(__FILE__, __LINE__, "Get Sys metricse not realized!!!")
return
*******************************

