/*   FiveWin likely classes					*/
/*   TBUTTON							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <fwin/FiveWin.ch>
#include <fwin/Constant.ch>

#define DLGC_DEFPUSHBUTTON    16     //0x0010
#define DLGC_UNDEFPUSHBUTTON  32     //0x0020
#define GWL_STYLE           (-16)
#define DLGC_BUTTON        8192 //0x2000

#define BM_SETSTYLE       244
#define COLOR_BTNFACE		15	// Face shading on push buttons
#define COLOR_BTNTEXT		18	// Text on push buttons

static Selector := GetSelector()

function TButton()
local obj:=Inherit(TControl())

	obj:classname	:= "FWIN_TBUTTON"
	obj:bAction	:= NIL
	obj:lDefault	:= .f.
	obj:lProcessing	:= .f.
	_recover_FWIN_TBUTTON(obj)
return obj
function _recover_FWIN_TBUTTON(obj)

	obj:new		:= @fw_New()
	obj:reDefine	:= @fw_ReDefine()
	obj:click	:= @fw_Click()
	obj:cGenPrg	:= @fw_cGenPRG()
	obj:gotFocus	:= @fw_GotFocus()
	obj:lostFocus	:= @fw_LostFocus()
	obj:mouseMove	:= @fw_MouseMove()
	obj:cToChar	:= @fw_cToChar()
	obj:colors	:= @fw_Colors()
	obj:keyDown	:= @fw_KeyDown()
	obj:initiate	:= @fw_Initiate()
return obj
***********
static function fw_New( self, nRow, nCol, cCaption, oWnd, bAction, nWidth, nHeight, ;
	    nHelpId, oFont, lDefault, lPixel, lDesign, cMsg,;
	    lUpdate, bWhen, bValid, lCancel )

local nFntWidth, nFntHeight

	DEFAULT nRow     := 0, nCol := 0,;
	   cCaption := "&Button",;
	   oWnd     := GetWndDefault(),;
	   oFont    := oWnd:oFont,;
	   nHelpId  := 100,;
	   lDefault := .f., lPixel := .f., lDesign := .f., lUpdate := .f.,;
	   lCancel  := .f.

	nFntWidth  = If( oFont != nil .and. "NWIDTH"$oFont .and. oFont:nWidth != nil, oFont:nWidth,    7 )
	nFntHeight = If( oFont != nil .and. "NHEIGHT"$oFont .and. oFont:nHeight != nil, oFont:nHeight, 10 )

	DEFAULT nWidth   := ( Len( cCaption ) + 2 ) * nFntWidth,;
	   nHeight  := nFntHeight + Int( nFntHeight / 4 )

	self:cCaption  = cCaption
	self:nTop      = nRow * If( ! lPixel, WIN_CHARPIX_H/*nFntHeight + Int( nFntHeight / 4 )*/, 1 )
	self:nLeft     = nCol * If( ! lPixel, WIN_CHARPIX_W/*nFntWidth*/, 1 )
	self:nBottom   = self:nTop  + nHeight
	self:nRight    = self:nLeft + nWidth
	self:nHelpId   = nHelpId
	self:bAction   = bAction
	self:oWnd      = oWnd
	self:oFont     = oFont
	self:nStyle    = numOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP,;
		     If( lDefault, BS_DEFPUSHBUTTON, 0 ),;
		     If( lDesign, WS_CLIPSIBLINGS, 0 ) )
	self:nId       = self:GetNewId()
	self:lDrag     = lDesign
	self:lCaptured = .f.
	self:cMsg      = cMsg
	self:lUpdate   = lUpdate
	self:bWhen     = bWhen
	self:bValid    = bValid
	self:lDefault  = lDefault
	self:lCancel   = lCancel
	self:lProcessing = .f.
	self:nClrText  = GetSysColor(COLOR_BTNTEXT)
	self:nClrPane  = GetSysColor(COLOR_BTNFACE)

	if oWnd:hWnd != NIL
		eval(Selector:CreateButton, self )
		oWnd:AddControl( Self )
	else
		oWnd:DefControl( Self )
	endif

	if lDesign
		self:CheckDots()
	endif

return Self
***********
static function fw_ReDefine( self, nId, bAction, oWnd, nHelpId, cMsg,;
		 lUpdate, bWhen, bValid, cPrompt, lCancel )

   DEFAULT oWnd := GetWndDefault(), lCancel := .f.

   self:nId       = nId
   self:bAction   = bAction
   self:hWnd      = -1
   self:nHelpId   = nHelpId
   self:oWnd      = oWnd
   self:lCaptured = .f.
   self:lDrag     = .f.
   self:cMsg      = cMsg
   self:lUpdate   = lUpdate
   self:bWhen     = bWhen
   self:bValid    = bValid
   self:cCaption  = cPrompt
   self:lCancel   = lCancel

   oWnd:DefControl( Self )

return Self
***********
static function fw_Click(self)

   if ! self:lProcessing
      self:lProcessing = .t.

      // Visual FiveWin 2.0
      if self:OnClick != nil
	 OSend( self:oWnd, self:OnClick, Self )
      endif

      if self:bAction != nil
	 Eval( self:bAction )
      endif
      self:Super:Click()
      self:SendMsg( BM_SETSTYLE, BS_DEFPUSHBUTTON, 1 )
      self:lProcessing = .f.
   endif

return
***********
static function fw_cGenPRG(self)

   local cPrg := ""

   self:CoorsUpdate()

   cPrg += CRLF + ;
	   "   @ " + Str( self:nTop, 3 ) + ", " + Str( self:nLeft, 3 ) + ;
	   ' BUTTON "' + self:cCaption + '" SIZE ' + ;
	   Str( self:nRight - self:nLeft + 1, 3 ) + ", " + ;
	   Str( self:nBottom - self:nTop + 1, 3 ) + ;
	   " PIXEL OF oWnd ;" + CRLF + ;
	   '      ACTION MsgInfo( "Not defined yet!" )' + CRLF

return cPrg
***********
static function fw_GotFocus( self, hCtlLost )

   if ! self:lDrag
      if Upper( self:oWnd:ClassName() ) != "TDIALOG" .or. ;  // ( GetParent( hCtlLost ) != self:oWnd:hWnd ) .or. ;
	 ( self:oWnd:oWnd != nil .and. ;
	 ( Upper( self:oWnd:oWnd:ClassName() ) == "TFOLDER" .or. ;
	   Upper( self:oWnd:oWnd:ClassName() ) == "TPAGES" ) ) .or. ;
	 self:oWnd:nLastKey == VK_RETURN .or. ;
	 ( self:oWnd:oCtlFocus != nil .and. ;
	 Upper( self:oWnd:oCtlFocus:ClassName() ) == "TMULTIGET" )
	 self:SendMsg( BM_SETSTYLE, BS_DEFPUSHBUTTON, 1 )
      endif
   endif

return self:Super:GotFocus( hCtlLost )
***********
static function fw_LostFocus(self)

   if ! self:lDrag
      if self:oWnd:ClassName() != "TDIALOG" .or. ;
	 ( self:oWnd:oWnd != nil .and. ;
	 ( self:oWnd:oWnd:ClassName() == "TFOLDER" .or. ;
	   self:oWnd:oWnd:ClassName() == "TPAGES" ) )
	 self:SendMsg( BM_SETSTYLE, BS_PUSHBUTTON, 1 )
      endif
   endif

return self:Super:LostFocus()
***********
static function fw_KeyDown( self, nKey, nFlags )

   do case
      case nKey == VK_UP .or. nKey == VK_LEFT
	   self:oWnd:GoPrevCtrl( self:hWnd )
	   return 0

      case nKey == VK_DOWN .or. nKey == VK_RIGHT
	   self:oWnd:GoNextCtrl( self:hWnd )
	   return 0

      case nKey == VK_RETURN
	   PostMessage( self:hWnd, FM_CLICK )    // fire the button's action
	   return 0
   endcase

return self:Super:KeyDown( nKey, nFlags )
***********
static function fw_Initiate( self, hDlg )

   self:Super:Initiate( hDlg )

   self:lDefault    = lAnd( GetWindowLong( self:hWnd, GWL_STYLE ),;
			 BS_DEFPUSHBUTTON )
   self:lProcessing = .f.

   if ! Empty( self:cCaption )
      eval(Selector:SetWindowText, self:hWnd, self:cCaption )
   endif

return
***********
static function fw_MouseMove( self,  nRow, nCol, nKeyFlags )
	// Standard Behavior
	self:Super:MouseMove( nRow, nCol, nKeyFlags )
return
***************
static function fw_cToChar(self)
return self:Super:cToChar( "BUTTON" )
***********
static function fw_Colors( hDC )
return  0

