/*   FiveWin likely classes					*/
/*   TMsgBar							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <clip-gtk.ch>
#include <fwin/FiveWin.ch>

#define COLOR_BTNFACE    15
#define COLOR_BTNSHADOW  16
#define MSG_HEIGHT       24

#define TIMER_INTERVAL  400

static Selector := GetSelector()

function TMsgBar()
local obj:=Inherit(TWindow())

	obj:className	:= "FWIN_TMSGBAR"
	obj:cMsgDef	:= "Clip for UNIX system"
	obj:lCentered	:= .f.
	obj:lInset	:= .f.
	obj:oTimer	:= NIL
	obj:aItem	:= {}
	obj:nItem	:= 0
	obj:oKeyNum	:= NIL
	obj:oKeyCaps	:= NIL
	obj:oKeyIns	:= NIL
	obj:oClock	:= NIL
	obj:oDate	:= NIL
	obj:nSizeItem	:= 0
	obj:lCheckRes	:= .f.

	_recover_FWIN_TMSGBAR(obj)
return obj
***********
function _recover_FWIN_TMSGBAR(obj)
	obj:new		:= @fw_new()
	obj:default	:= @fw_default()
	obj:create	:= @fw_create()
	obj:addItem	:= @fw_addItem()
	obj:delItem	:= @fw_DelItem()
	obj:InsItem	:= @fw_InsItem()
	obj:Adjust	:= @fw_Adjust()
	obj:CheckTimer	:= @fw_CheckTimer()
	obj:ClockOn	:= @fw_ClockOn()
	obj:ClockOff	:= {|self| self:DelItem( self:oClock ), self:oClock := nil, self:Refresh()}
	obj:DateOn	:= @fw_DateOn()
	obj:DateOff	:= {|self| self:DelItem( self:oDate ), self:oDate := nil, self:Refresh()}
	obj:Destroy	:= @fw_Destroy()
	obj:GetItem	:= {|self| Len( self:aItem )}
	obj:Height	:= {|| MSG_HEIGHT}
	obj:KeybOn	:= @fw_KeybOn()
	obj:KeybOff	:= {|self| self:DelItem( self:oKeyNum ), self:DelItem( self:oKeyCaps ),;
			    self:DelItem( self:oKeyIns ),;
			    self:oKeyNum := nil, self:oKeyCaps := nil, self:oKeyIns := nil,;
			    self:Refresh()}
	obj:LDblClick	:= {|self, nRow, nCol, nKeyFlags | ;
			    If( ! self:lCheckRes, self:Cargo := self:oWnd:GetText(),),;
			    self:lCheckRes := ! self:lCheckRes}
	obj:MouseMove	:= @fw_MouseMove()
	obj:Paint	:= @fw_Paint()
	obj:SetMsg	:= @fw_SetMsg()
	obj:ShowMsgBar	:= {|| } // virtual
	obj:LButtonDown	:= @fw_LButtonDown()
	obj:ShowToolTip	:= @fw_ShowToolTip()
	obj:TimerEval	:= @fw_TimerEval()
return obj
***********
static function fw_new(self, oWnd, cPrompt, lCentered, lClock, lDate, lKbd,;
			nClrFore, nClrBack, oFont, lInset )
local oRect := oWnd:GetCliRect()

	DEFAULT cPrompt := "", lCentered := .f., lClock := .f., lDate := .f.,;
	   lKbd := .f., nClrFore := CLR_BLACK, nClrBack := GetSysColor( COLOR_BTNFACE ),;
	   lInset := .t.

	self:nClrPane    = nClrBack
	self:nClrText    = nClrFore
	self:oWnd        = oWnd
	self:cMsg        = iif(cPrompt==NIL, self:cMsgDef, cPrompt)
	self:nStyle      = numOR( WS_VISIBLE, WS_CHILD, WS_OVERLAPPED, WS_BORDER )
	self:nLeft       = -1
	self:nTop        = oRect:nBottom - MSG_HEIGHT
	self:nBottom     = oRect:nBottom
	self:nRight      = oRect:nRight  + 1
	self:nWidth	 = self:nRight - self:nLeft + 1
	self:nHeight	 = self:nBottom - self:nTop + 1
	self:lCentered   = lCentered
	self:lInset      = lInset
	self:lValidating = .f.
	self:aItem       = {}
	self:oFont       = oFont
	self:cMsgDef 	 = self:cMsg

	//self:Register()

	self:Create()
	self:Default()

	If lKbd
		self:KeybOn()
	Endif

	If lDate
		self:DateOn()
	Endif

	If lClock
		self:ClockOn()
	Endif
return self
**********

static function fw_create(self)
	eval(Selector:CreateStatusBar,self)
return

**********
static function fw_default(self)

	self:SetColor( self:nClrText, self:nClrPane )

	self:SetFont( self:oFont )

return
**********
static function fw_addItem(self, oItem)
	aadd(self:aItem, oItem)
	self:refresh()
	eval(Selector:AddMsgItem,self:hWnd, oItem)
	self:nSizeItem += oItem:nWidth + 4
return
**********
static function fw_ClockOn(self)
	if self:oClock == nil
		self:oClock := TMsgItem():New( Self, Time(), self:GetWidth( Time() ) + 12,,,, .t.,;
				 { || eval(Selector:WinExec, "Control date/time" ) })
		self:oClock:lTimer = .t.
		self:oClock:bMsg   = { |item| item:cToolTip:= toString(Time()), Time() }
		self:oClock:ID := eval(Selector:SetTimer,self:oClock:hWnd, TIMER_INTERVAL)
	endif
return
*******************
static function fw_Adjust(self)

local rctParent

   rctParent := self:oWnd:GetCliRect()
   self:SetCoors( TRect():New( rctParent:nBottom - MSG_HEIGHT, rctParent:nLeft - 1,;
			    rctParent:nBottom, rctParent:nRight ) )
return nil
********************
static function fw_DateOn(self)

   if self:oDate == nil
      self:oDate := TMsgItem():New( Self, DToC( Date() ),;
				self:GetWidth( DToC( Date() ) ) + 12,,,, .t.,;
				{ || eval(Selector:Calendar) },,, dmy(Date()) )
      self:oDate:bMsg   = { |item| item:cToolTip:=dmy(Date()), Date() }
   endif

return nil
**************************
static function fw_InsItem(self,  oItem, nAt )

   if nAt == nil
      return nil
   endif

   if nAt > 0
      ASize( self:aItem, Len( self:aItem ) + 1 )
      AIns( self:aItem, nAt )
      self:aItem[ nAt ] = oItem
      self:Refresh()
   endif

return nil
**************************
static function fw_DelItem( self, oItem )

   local nAt := AScan( self:aItem, { | o | o == oItem } )

   if nAt != 0
      ADel( self:aItem, nAt )
      ASize( self:aItem, Len( self:aItem ) - 1 )
      self:Refresh()
   endif

return nil
***************************
static function fw_Destroy(self)

   AEval( self:aItem, { | o | if( o:hBmpPal1 != nil, eval(Selector:DeleteObject, o:hBmpPal1 ), ),;
			   if( o:hBmpPal2 != nil, eval(Selector:DeleteObject, o:hBmpPal2 ), ) } )

   if self:oTimer != nil
      self:oTimer:End()
   endif

return self:Super:Destroy()
**************************
static function fw_KeybOn(self)

/*  Sorry! but I'm know it make now!
   if self:oKeyNum == nil
      // keep the ':=' below for XBase++ compatibility
      self:oKeyNum := TMsgItem():New( Self, "Num", self:GetWidth( "Num" ) + 12,,,, .t.,;
				  { || eval(Selector:KeyToggle, VK_NUMLOCK ), self:oKeyNum:Refresh() } )
      self:oKeyNum:lTimer = .t.
      self:oKeyNum:nClrDisabled = GetSysColor( COLOR_BTNSHADOW )
      self:oKeyNum:lActive = eval(Selector:GetKeyToggle, VK_NUMLOCK )
      self:oKeyNum:bMsg  = { || self:oKeyNum:lActive := eval(Selector:GetKeyToggle, VK_NUMLOCK ), "Num" }
   endif

   if self:oKeyCaps == nil
      // keep the ':=' below for XBase++ compatibility
      self:oKeyCaps := TMsgItem():New( Self, "Caps", self:GetWidth( "Caps" ) + 12,,,, .t.,;
				  { || eval(Selector:KeyToggle, VK_CAPITAL ), self:oKeyCaps:Refresh() } )
      self:oKeyCaps:lTimer = .t.
      self:oKeyCaps:nClrDisabled = GetSysColor( COLOR_BTNSHADOW )
      self:oKeyCaps:lActive = eval(Selector:GetKeyToggle, VK_CAPITAL )
      self:oKeyCaps:bMsg = { || self:oKeyCaps:lActive := eval(Selector:GetKeyToggle, VK_CAPITAL ), "Caps" }
   endif

   if self:oKeyIns == nil
      // keep the ':=' below for XBase++ compatibility
      self:oKeyIns := TMsgItem():New( Self, "Ins", self:GetWidth( "Ins" ) + 12,,,, .t.,;
				  { || eval(Selector:KeyToggle, VK_INSERT ), self:oKeyIns:Refresh() } )
      self:oKeyIns:lTimer = .t.
      self:oKeyIns:nClrDisabled = GetSysColor( COLOR_BTNSHADOW )
      self:oKeyIns:lActive = eval(Selector:GetKeyToggle, VK_INSERT )
      self:oKeyIns:bMsg = { || self:oKeyIns:lActive := eval(Selector:GetKeyToggle, VK_INSERT ), "Ins" }
   endif

   self:CheckTimer()
*/
return nil
**************************
static function fw_SetMsg( self, cText )

   DEFAULT self:cMsg := ""

   if cText == NIL .or. empty(cText)
      if ! Empty( self:cMsg )
	 eval(Selector:MsgPaint, self:hWnd, self:cMsg := "", self:cMsgDef, .f.,;
		   self:lCentered, If( Len( self:aitem ) > 0, self:aItem[ 1 ]:nLeft(), 0 ),;
		   self:nClrText, self:nClrPane, self:oFont)//:handle)//Font )
      endif
   else
      if self:cMsg != cText
	 eval(Selector:MsgPaint, self:hWnd, self:cMsg := cText, self:cMsgDef, .f.,;
		   self:lCentered, If( Len( self:aitem ) > 0, self:aItem[ 1 ]:nLeft(), 0 ),;
		   self:nClrText, self:nClrPane, self:oFont)//:handle)//Font )
      endif
   endif

return nil
*****************************
static function fw_CheckTimer(self)
   if self:oTimer == nil

      DEFINE TIMER self:oTimer OF Self INTERVAL TIMER_INTERVAL;
	 ACTION self:TimerEval()

      ACTIVATE TIMER self:oTimer

   endif

return nil
****************************
static function fw_MouseMove( self, nRow, nCol, nFlags )

   local n

   for n = 1 to Len( self:aItem )
      if self:aItem[ n ]:IsOver( nRow, nCol )
	 //CursorHand()
	 if self:nItem != n
	    self:nItem := n
	    self:DestroyToolTip()
	 endif
	 self:CheckToolTip()
	 return nil
      endif
   next
   self:DestroyToolTip()
   self:nItem := 0

return self:Super:MouseMove( nRow, nCol, nFlags )
**************************
static function fw_LButtonDown( self, nRow, nCol, nFlags )

   local n

   for n = 1 to Len( self:aItem )
      if self:aItem[ n ]:IsOver( nRow, nCol )
	 self:aItem[ n ]:Click()
	 return nil
      endif
   next

return nil
*************************
static function fw_TimerEval(self)

   local n

   for n = 1 to Len( self:aItem )
      if self:aItem[ n ]:lTimer
	 self:aItem[ n ]:Refresh()
      endif
   next

   if self:lCheckRes
      self:oWnd:SetText( "MemUsed: " + AllTrim( Transform( /*MemUsed()*/, "999,999,999,999" ) ) + ;
		      " MemMax: " + Alltrim( Transform( /*MemMax()*/, "999,999,999,999" ) ) + ;
		      " Resources: " + AllTrim( Str( /*GetFreeSystemResources( 1 )*/ ) ) + "%" )
   else
      if self:Cargo != NIL
	 self:oWnd:SetText( self:Cargo )
	 self:Cargo = nil
      endif
   endif

return nil
*************************
static function fw_Paint(self)

	eval(Selector:PaintStatusBar,self:hWnd, self:cMsg, self:cMsgDef, .t., ;
	     self:lCentered, If( Len( self:aItem ) > 0, self:aItem[ 1 ]:nLeft(), 0 ),;
	     self:nClrText, self:nClrPane, self:oFont:hFont,;
	     self:lInset )
	Selector:ASend( self:aItem, "Paint" ) // ShowItem( Self, self:aItem, self:nRight )

return nil
*******************************
static function fw_ShowToolTip(self)

   local oItem
/*
   qout('show tool tip for msgbar')
   if self:nItem != 0
      oItem := self:aItem[ self:nItem ]
      if !Empty( oItem:cToolTip )
	 self:cToolTip := oItem:cToolTip
	 self:Super:ShowToolTip( -MLCount( self:cToolTip, 254 ) * 14 - 2, oItem:nLeft() )
      endif
   endif
*/
return nil

//------------------------------------------------------------------------//

