/*   FiveWin likely classes					*/
/*   TMsgItem							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <fwin/FiveWin.ch>

static Selector := GetSelector()

function TMsgItem()
local obj:=map()

	obj:className	:= "FWIN_TMSGITEM"
	obj:oMsgBar	:= NIL
	obj:cMsg	:= NIL
	obj:nWidth	:= NIL
	obj:nClrText	:= NIL
	obj:nClrPane	:= NIL
	obj:nClrDisabled:= NIL
	obj:bMsg	:= NIL
	obj:bAction	:= NIL
	obj:oFont	:= NIL
	obj:lActive	:= .f.
	obj:lTimer	:= .f.
	obj:lWasActive	:= NIL
	obj:hBmpPal1	:= NIL
	obj:hBmpPal2	:= NIL
	obj:cToolTip	:= NIL

	_recover_FWIN_TMSGITEM(obj)

return obj
*******************
function _recover_FWIN_TMSGITEM(obj)

	obj:new		:= @fw_New()
	obj:refresh	:= @fw_Refresh()
	obj:SetFont	:= {|self, oFont| self:oFont:End(), self:oFont := oFont}
	obj:Paint	:= @fw_Paint()
	obj:SetText	:= {|self, cMsg| self:cMsg := ToString( cMsg ), self:Paint()}
	obj:Click	:= {|self| If( self:bAction != nil, Eval( self:bAction ),)}
	obj:IsOver	:= @fw_IsOver()
	obj:nLeft	:= @fw_nLeft()

return obj
*******************
static function fw_New( self, oMsgBar, cMsg, nWidth, oFont, nClrText, nClrBack, ;
	    lAdd, bAction, cBmp1, cBmp2, cToolTip )

	DEFAULT nClrText := oMsgBar:nClrText,;
	   nClrBack := oMsgBar:nClrPane,;
	   lAdd := .f., cMsg := "", cToolTip := ""

	self:oMsgBar = oMsgBar
	self:cMsg    = cMsg
	self:oFont   = If( oFont != nil, oFont, self:oMsgBar:oFont )
	self:bAction = bAction
	self:lActive = .t.
	self:lWasActive = .t.
	self:lTimer  = .f.
	self:cToolTip = cToolTip

	if Valtype( nClrText ) == "C"
		self:nClrText := eval(Selector:nGetForeRGB, nClrText )
		self:nClrPane := eval(Selector:nGetBackRGB, nClrText )
	else
		self:nClrText := nClrText
		self:nClrPane := nClrBack
	endif

	if cBmp1 != nil
		if File( cBmp1 )
			self:hBmpPal1 = eval(Selector:ReadBitmap, 0, cBmp1 )
		else
			self:hBmpPal1 = eval(Selector:LoadBitmap, eval(Selector:GetResources), cBmp1 )
		endif

		nWidth := iif(nWidth==NIL, nBmpWidth( self:hBmpPal1 ) + 7, nWidth)
	endif

	if cBmp2 != nil
		if File( cBmp2 )
			self:hBmpPal2 = eval(Selector:ReadBitmap, 0, cBmp2 )
		else
			self:hBmpPal2 = eval(Selector:LoadBitmap, eval(Selector:GetResources,), cBmp2 )
		endif
		nWidth := iif(nWidth==NIL, nBmpWidth( self:hBmpPal2 ) + 7, nWidth)
	endif


	DEFAULT nWidth := 40

	self:nWidth = nWidth + 4

	if ! Empty( self:cToolTip )
		self:oMsgBar:cToolTip := ""
	endif

	if lAdd
		oMsgBar:AddItem( Self )
	endif

return Self
**********************
static function fw_nLeft(self)

local n := Len( self:oMsgBar:aItem ), nPos := self:oMsgBar:nRight - ;
	      If( eval(Selector:IsZoomed, self:oMsgBar:oWnd:hWnd ), 3, 13 )

	while n > 0 .and. ! self:oMsgBar:aItem[ n ] == Self
		nPos -= ( self:oMsgBar:aItem[ n ]:nWidth + 4 )
		n--
	end
	nPos -= ( self:nWidth - 2 )

return nPos
**********************
static function fw_IsOver( self, nRow, nCol )

   local nLeft := self:nLeft()

return nCol >= nLeft - 1 .and. nCol <= nLeft + ( self:nWidth - 7 )
**********************
static function fw_Paint(self)

	eval(Selector:PaintMsgItem,self:handle,  self:cMsg, self:oMsgBar:handle)

return
**********************
static function fw_Refresh(self)

   local cMsg

   if self:bMsg != nil
      cMsg = ToString( Eval( self:bMsg, self ) )
      if cMsg != self:cMsg .or. self:lActive != self:lWasActive
	 self:cMsg = cMsg
	 self:Paint()
	 self:lWasActive = self:lActive
      endif
   endif

return
