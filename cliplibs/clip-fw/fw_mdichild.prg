/*   FiveWin likely clasJses					*/
/*   TMdiChild							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <clip-gtk.ch>
#include <fwin/FiveWin.ch>
#include <fwin/Constant.ch>

#define WM_MDICREATE        544   // 0x0220
#define WM_MDIDESTROY       545   // 0x0221
#define WM_MDIACTIVATE      546   // 0x0222
#define WM_MDIRESTORE       547   // 0x0223
#define WM_MDINEXT          548   // 0x0224
#define WM_MDIMAXIMIZE      549   // 0x0225
#define WM_MDITILE          550   // 0x0226
#define WM_MDICASCADE       551   // 0x0227
#define WM_MDIICONARRANGE   552   // 0x0228
#define WM_MDIGETACTIVE     553   // 0x0229
#define WM_MDISETMENU       560   // 0x0230

#define WM_CHILDACTIVATE     34   // 0x22
#define WM_GETFONT           49   // 0x0031

#define WM_NCACTIVATE       134   // 0x0086

#define SC_RESTORE        61728
#define SC_CLOSE          61536   // 0xF060
#define SC_MINIMIZE       61472
#define SC_NEXT           61504
#define SC_MAXIMIZE       61488   // 0xF030

#define IDC_ARROW         32512
#define WM_SYSCOMMAND       274   // 0x0112

#define CW_USEDEFAULT     32768

#define BAR_TOP         1
#define BAR_LEFT        2
#define BAR_RIGHT       3
#define BAR_DOWN        4
#define BAR_FLOAT       5

#define CS_DBLCLKS      8

static Selector := GetSelector()

function TMdiChild()
local obj := Inherit(TWindow())

	obj:className	:= "FWIN_TMDICHILD"
	obj:lRegistered	:= .t.

	obj:oWndClient	:= NIL
	obj:oControl	:= NIL
	obj:lKeepMenu	:= .f.
	obj:nMenuInfo	:= NIL

	_recover_FWIN_TMDICHILD(obj)
return obj
***************************
function _recover_FWIN_TMDICHILD(obj)

	obj:New		:= @fw_New()
	obj:Maximize	:= {| self | self:oWndClient:ChildMaximize( Self )}
	obj:MdiActivate	:= @fw_MdiActivate()
	obj:Restore	:= {| self | self:oWndClient:ChildRestore( Self )}
	//obj:Activate	:= @fw_activate()
	obj:End		:= @fw_End()
	obj:Center	:= {| self | eval(Selector:WndCenter, self:hWnd, self:oWndClient:hWnd )}
	obj:Copy	:= {| self | If( self:oControl != nil, self:oControl:Copy(), )}
	obj:Cut		:= {| self | If( self:oControl != nil, self:oControl:Cut(), )}
	obj:Delete	:= {| self | If( self:oControl != nil, self:oControl:Delete(), )}
	obj:Paste	:= {| self, cText | ;
	       If( self:oControl != nil, self:oControl:Paste( cText ), )}
	obj:Find	:= {| self, cText | ;
	       If( self:oControl != nil, self:oControl:Find( cText ), )}
	obj:FindNext	:= {| self | ;
	       If( self:oControl != nil, self:oControl:FindNext(), )}
	obj:Print	:= @fw_Print()
	obj:GotFocus	:= {| self| self:super:GotFocus(),;
			    self:oWnd:oWndActive := Self}
	obj:HandleEvent	:= @fw_HandleEvent()
	obj:Next	:= {| self | self:oWndClient:ChildNext( Self )}
	obj:Prev	:= {| self | self:oWndClient:ChildNext( Self, .t. )}
	obj:KeyDown	:= @fw_KeyDown()
	obj:KeyChar	:= @fw_KeyChar()
	obj:Properties	:= {| self | ;
	       If( self:oControl != nil, self:oControl:Properties(), )}
	obj:Replace	:= {| self | ;
	       If( self:oControl != nil, self:oControl:Replace(), )}
	obj:SelectAll	:= {| self | ;
	       If( self:oControl != nil, self:oControl:SelectAll(), )}
	obj:SetControl	:= {| self, oCtrl | ;
	  self:oClient := self:oControl := oCtrl, self:ReSize()}
	obj:SetMenu	:= {| self, oMenu, nMenuInfo | self:oMenu := oMenu,;
	     self:oWnd:SetMenu( oMenu, self:nMenuInfo := nMenuInfo )}
	obj:SetFocus	:= {| self | self:oWnd:oWndClient:ChildActivate( Self )}
	obj:ReDo	:= {| self | ;
	       If( self:oControl != nil, self:oControl:ReDo(), )}
	obj:UnDo	:= {| self | ;
	       If( self:oControl != nil, self:oControl:UnDo(), )}

return obj

//----------------------------------------------------------------------------//

static function fw_New( self, nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu, oWnd,;
	    oIcon, lVScroll, nClrFore, nClrBack, oCursor, oBrush,;
	    lPixel, lHScroll, nHelpId, cBorder, lSysMenu, lCaption,;
	    lMin, lMax, nMenuInfo )

   DEFAULT cTitle   := "MDI Child", lVScroll := .f., lHScroll := .f.,;
	   oWnd     := eval(Selector:GetWndFrame),;
	   nClrFore := oWnd:oWndClient:nClrText,;
	   nClrBack := oWnd:oWndClient:nClrPane,;
	   nStyle   := 0,;
	   cBorder  := "SINGLE", lSysMenu := .t., lCaption := .t.,;
	   lMin     := .t., lMax := .t., lPixel := .f.

   if nStyle == 0
      nStyle = numOr( WS_CLIPCHILDREN, WS_VISIBLE, ;
		    If( cBorder == "NONE",   0, 0 ),;
		    If( cBorder == "SINGLE", WS_THICKFRAME, 0 ),;
		    If( lCaption, WS_CAPTION, 0 ),;
		    If( lSysMenu .and. lCaption, WS_SYSMENU, 0 ),;
		    If( lMin .and. lCaption, WS_MINIMIZEBOX, 0 ),;
		    If( lMax .and. lCaption, WS_MAXIMIZEBOX, 0 ),;
		    If( lVScroll, WS_VSCROLL, 0 ),;
		    If( lHScroll, WS_HSCROLL, 0 ) )
   endif

   self:nTop       = If( nTop    != nil, nTop * If( ! lPixel, MDIC_CHARPIX_H, 1 ), CW_USEDEFAULT )				  // 16
   self:nLeft      = If( nLeft   != nil, nLeft * If( ! lPixel,  MDIC_CHARPIX_W, 1 ), CW_USEDEFAULT )       // 8
   self:nBottom    = If( nBottom != nil, nBottom * If( ! lPixel, MDIC_CHARPIX_H, 1 ), CW_USEDEFAULT )		  // 16
   self:nRight     = If( nRight  != nil, nRight  * If( ! lPixel,  MDIC_CHARPIX_W, 1 ), CW_USEDEFAULT )		// 8
   self:oWndClient = oWnd:oWndClient
   self:oWnd       = oWnd
   self:nStyle     = nStyle
   self:oIcon      = oIcon
   self:lVisible   = .t.
   self:aControls  = {}
   self:nHelpId    = nHelpId
   self:cCaption   = cTitle
   self:lKeepMenu  = .f.
   self:nMenuInfo  = nMenuInfo

   if ValType( oIcon ) == "C"
      if File( oIcon )
	 DEFINE ICON oIcon FILENAME oIcon
      else
	 DEFINE ICON oIcon RESOURCE oIcon
      endif
      self:oIcon = oIcon
   endif

   self:oCursor    = oCursor


   /*
   #ifdef __XPP__
      DEFAULT self:lRegistered := .f.
   #endif

   if ! self:lRegistered
      self:lRegistered = RegisterClass( "TMDICHILD",;
				     numOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ),;
				     0, 0, 0, 0, 0, "", GetMDIChlProc() )
   endif
   */

   /*
   self:hWnd = self:oWndClient:SendMsg( HASH_WM_MDICREATE, 0,;
	cMdiStruct( "TMDICHILD", cTitle,;
		    self:nTop, self:nLeft, self:nBottom, self:nRight,;
		    self:nStyle ) )
   */
   self:hWnd    = eval(Selector:CreateWindow, self,"FWIN_TMDICHILD", "MDIChild", self:nStyle,;
		    self:nLeft, self:nTop, ;
		    iif(self:nRight==CW_USEDEFAULT, CW_USEDEFAULT, self:nRight-self:nLeft+1), ;
		    iif(self:nBottom==CW_USEDEFAULT, CW_USEDEFAULT, self:nBottom-self:nTop+1), ;
		    self:oWndClient)

outlog(__FILE__, __LINE__, '1created child', self:hWnd, self:handle, gtk_WidgetGEtTYpeName(self))

   self:SetColor( nClrFore, nClrBack, oBrush )

   self:Link()

   if oMenu != nil
      self:SetMenu( oMenu, nMenuInfo )
   endif
outlog(__FILE__, __LINE__, '2created child', self:hWnd, self:handle, gtk_WidgetGEtTYpeName(self))

   if lVScroll
      DEFINE SCROLLBAR self:oVScroll VERTICAL OF Self
   endif
   if lHScroll
      DEFINE SCROLLBAR self:oHScroll HORIZONTAL OF Self
   endif

   #ifndef __XPP__
   if self:oFont == nil
      self:oFont = TFont()
      self:oFont:hFont = self:SendMsg( WM_GETFONT )
   endif
   #endif
outlog(__FILE__, __LINE__, '3created child', self:hWnd, self:handle, gtk_WidgetGEtTYpeName(self))

   self:oWndClient:Add( Self )

outlog(__FILE__, __LINE__, '4created child', self:hWnd, self:handle, gtk_WidgetGEtTYpeName(self))
   SetWndDefault( Self )              // Set Default DEFINEd Window
   self:oWnd:oWndActive = Self
outlog(__FILE__, __LINE__, '5created child', self:hWnd, self:handle, gtk_WidgetGEtTYpeName(self))

outlog(__FILE__, __LINE__, '6created child',  gdk_WindowGEtTYpe(self))


return Self

//----------------------------------------------------------------------------//

static function fw_Activate(self, cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
				bKeyDown, bInit,;
				bUp, bDown, bPgUp, bPgDn,;
				bLeft, bRight, bPgLeft, bPgRight, bValid )
	self:oWndClient:ChildActivate( Self )
	self:super:Activate( cShow, bLClicked, bRClicked, bMoved,;
		    bResized, bPainted, bKeyDown, bInit,;
		    bUp, bDown, bPgUp, bPgDn,;
		    bLeft, bRight, bPgLeft, bPgRight, bValid )
	self:lVisible := .t.
	If( self:oControl != nil, self:oControl:SetFocus(), )
return
******************************
static function fw_End(self)

   local lEnd := .t.

   if self:bValid != nil
      if Eval( self:bValid )
	 if self:oMenu != nil .and. ! self:lKeepMenu
	    self:oMenu:End()
	 endif
	 self:oWndClient:ChildClose( Self )
      else
	 lEnd = .f.
      endif
   else
      if self:oMenu != nil .and. ! self:lKeepMenu
	 self:oMenu:End()
      endif
      self:oWndClient:ChildClose( Self )
   endif

return lEnd

//----------------------------------------------------------------------------//

static function fw_KeyDown( self, nKey, nFlags )

   // There is no a standard behavior for WM_KEYDOWN messages so we have
   // to process them !

   if nKey == VK_F4 .and. eval(Selector:GetKeyState, VK_CONTROL )
      self:SendMsg( WM_SYSCOMMAND, SC_CLOSE )
      return 0
   endif

   if nKey == VK_F6 .and. eval(Selector:GetKeyState, VK_CONTROL )
      self:SendMsg( WM_SYSCOMMAND, SC_NEXT )
      return 0
   endif

return self:super:KeyDown( nKey, nFlags )

//----------------------------------------------------------------------------//

static function fw_KeyChar( self, nKey, nFlags )

   if nKey == VK_ESCAPE
      self:End()
      return 0
   endif

return self:super:KeyChar( nKey, nFlags )

//----------------------------------------------------------------------------//

static function fw_HandleEvent( self, nMsg, nWParam, nLParam )

   #ifndef __XPP__
      if nMsg == WM_MDIACTIVATE
	 return self:MdiActivate( nWParam == 1, nLoWord( nLParam ),;
			       nHiWord( nLParam ) )
      endif
   #else
      if nMsg == WM_MDIACTIVATE
	 return self:MdiActivate( self:hWnd == nLParam, nLParam, nWParam )
      endif
   #endif

return self:super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

static function fw_MdiActivate( self, lOn, hWndAct, hWndDeAct )

   if lOn
      if self:oMenu != nil
	 self:oWnd:SetMenu( self:oMenu, self:nMenuInfo )
      endif
   else
      if self:oMenu != nil
	 self:oWnd:SetMenu( self:oWnd:oMenuStart )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_Print( self, oTarget, nRow, nCol, nScale )

   if self:bPrint != nil
      Eval( self:bPrint, Self )
      return nil
   endif

   if self:oControl != nil
      self:oControl:Print( oTarget, nRow, nCol, nScale )
   else
      self:super:Print( oTarget, nRow, nCol, nScale )
   endif

return nil

//----------------------------------------------------------------------------//

