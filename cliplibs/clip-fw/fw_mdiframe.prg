/*   FiveWin likely classes					*/
/*   TMDIFrame							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <clip-gtk.ch>
#include <fwin/FiveWin.ch>
#include <fwin/constant.ch>

#define SC_RESTORE     61728
#define SC_MINIMIZE    61472
#define SC_CLOSE       61536
#define SC_NEXT        61504

#define SIZE_MAXIMIZED     2
#define CW_USEDEFAULT  32768

#define WM_GETFONT        49  // 0x0031

#define BAR_TOP            1
#define BAR_LEFT           2
#define BAR_RIGHT          3
#define BAR_DOWN           4
#define BAR_FLOAT          5

#define COLOR_WINDOW       5

static oWndMain
static Selector := GetSelector()

function TMdiFrame()
local obj := Inherit(TWindow())

	obj:classname	:= "FWIN_TMDIFRAME"

	obj:oWndClient	:= NIL
	obj:oWndActive	:= NIL
	obj:oMenuStart	:= NIL
	obj:nMenuInfo	:= NIL
	obj:bOnOpen	:= NIL

	obj:lRegistered	:= .f.

	_recover_FWIN_TMDIFRAME(obj)
return obj
********************************************************************************
function _recover_FWIN_TMDIFRAME(obj)

	obj:New		:= @fw_New()
	obj:ChildNew	:= {|self, nTop, nLeft, nBottom, nRight, cTitle, nStyle|  ;
				self:oWndClient:ChildNew( nTop, nLeft, nBottom, nRight, cTitle, nStyle ) }
	obj:Cascade	:= {| self | self:oWndClient:Cascade()}
	obj:CloseAll	:= {| self | self:oWndClient:lCloseAll()}
	obj:IconizeAll	:= {| self | self:oWndClient:IconizeAll()}
	obj:Tile	:= {| self, lHor | self:oWndClient:Tile( lHor )}
	obj:ArrangeIcons:= {| self | self:oWndClient:ArrangeIcons()}
	obj:NextWindow	:= {| self | self:oWndClient:NextWindow()}
	obj:PrevWindow	:= {| self | self:oWndClient:PrevWindow()}
	obj:Resize	:= @fw_ReSize()
	obj:Command	:= @fw_Command()
	obj:Copy	:= {| self | If( self:oWndActive != nil, self:oWndActive:Copy(),)}
	obj:Cut		:= {| self | If( self:oWndActive != nil, self:oWndActive:Cut(),)}
	obj:Delete	:= {| self | If( self:oWndActive != nil, self:oWndActive:Delete(),)}
	obj:FindNext	:= {| self | If( self:oWndActive != nil, self:oWndActive:FindNext(),)}
	obj:Open	:= {| self | If( self:bOnOpen != nil, Eval( self:bOnOpen, Self ),)}
	obj:Paste	:= {| self, cText | If( self:oWndActive != nil, self:oWndActive:Paste( cText ),)}
	obj:Print	:= {| self | If( self:oWndActive != nil, self:oWndActive:Print(),)}
	obj:ReDo	:= {| self | If( self:oWndActive != nil, self:oWndActive:ReDo(),)}
	obj:UnDo	:= {| self | If( self:oWndActive != nil, self:oWndActive:UnDo(),)}
	obj:Find	:= {| self, cText | If( self:oWndActive != nil, self:oWndActive:Find( cText ),)}
	obj:End		:= @fw_End()
	obj:Properties	:= {| self | If( self:oWndActive != nil, self:oWndActive:Properties(),)}
	obj:Replace	:= {| self | If( self:oWndActive != nil, self:oWndActive:Replace(),)}
	obj:Select	:= {| self, nWindow | self:oWndClient:Select( nWindow )}
	obj:SelectAll	:= {| self | If( self:oWndActive != nil, self:oWndActive:SelectAll(),)}
	obj:SetMenu	:= @fw_SetMenu()
	obj:GotFocus	:= @fw_GotFocus()

return obj

//----------------------------------------------------------------------------//

static function fw_New( self, nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu, oBrush,;
	    oIcon, nClrFore, nClrBack, lVScroll, lHScroll, nMenuInfo,;
	    cBorder, oWnd, lPixel )

   DEFAULT nStyle    := numOr( WS_OVERLAPPEDWINDOW, WS_CLIPCHILDREN ),;
	   lVScroll  := .f., lHScroll := .f.,;
	   nMenuInfo := If( oMenu != nil, Max( Len( oMenu:aItems ) - 1, 1 ), 2 ),;
	   nClrFore  := CLR_BLACK, nClrBack := GetSysColor( COLOR_WINDOW ),;
	   lPixel    := .f.

   self:nTop        = If( nTop    != nil, nTop    * If( lPixel, 1, MDIF_CHARPIX_H ), CW_USEDEFAULT )      //16
   self:nLeft       = If( nLeft   != nil, nLeft   * If( lPixel, 1, MDIF_CHARPIX_W ), CW_USEDEFAULT )       // 8
   self:nBottom     = If( nBottom != nil, nBottom * If( lPixel, 1, MDIF_CHARPIX_H ), CW_USEDEFAULT )    //16
   self:nRight      = If( nRight  != nil, nRight  * If( lPixel, 1, MDIF_CHARPIX_W ), CW_USEDEFAULT )    //  8
   self:nStyle      = nStyle
   self:cCaption    = cTitle
   self:nId         = 0
   self:oIcon       = oIcon
   self:lValidating = .f.
   self:lVisible    = .t.
   self:oWnd        = oWnd
   self:oMenu       = oMenu
   self:nMenuInfo   = nMenuInfo

      DEFAULT self:lRegistered := .t.

   if ValType( oIcon ) == "C"
      if File( oIcon )
	 DEFINE ICON oIcon FILENAME oIcon
      else
	 DEFINE ICON oIcon RESOURCE oIcon
      endif
      self:oIcon = oIcon
   endif

   if oMenu == nil
      MENU oMenu
	 MENUITEM "&Childs"
	 MENU
	    MENUITEM "New..." ACTION self:ChildNew()
	    SEPARATOR
	    MENUITEM "E&xit"  ACTION self:End()
	 ENDMENU
	 oMenu:AddMdi()
	 oMenu:AddHelp( "FiveWin", "(c) FiveTech" )

      ENDMENU
      self:oMenu = oMenu
   endif

   //self:Register()
   self:Create()                   // After this the window is subclassed and
   //self:nOldProc = GetFrameProc()  // we install the MdiFrame procedure now !!!

   self:SetColor( nClrFore, nClrBack, oBrush )
					// SubMenu, nChild
   self:oWndClient = TMdiClient():New( Self, nMenuInfo, 1,, lVScroll,;
				    lHScroll )
   self:oWndClient:SetColor( nClrFore, nClrBack, oBrush )

   self:SetMenu( oMenu, self:nMenuInfo )

   if self:oFont == nil
      self:oFont = self:GetFont()
   endif

   oWndMain = Self
   SetWndDefault( Self )

return Self

//----------------------------------------------------------------------------//

static function fw_ReSize( self, nSizeType, nWidth, nHeight )

   local hTop, hBottom, hLeft, hRight

   self:super:ReSize( nSizeType, nWidth, nHeight )

   if self:oTop != nil
      hTop = self:oTop:hWnd
   endif

   if self:oBar != nil
      hTop = self:oBar:hWnd
   endif

   if self:oBottom != nil
      hBottom = self:oBottom:hWnd
   endif

   if self:oMsgBar != nil
      hBottom = self:oMsgBar:hWnd
   endif

   if self:oLeft != nil
      hLeft = self:oLeft:hWnd
   endif

   if self:oRight != nil
      hRight = self:oRight:hWnd
   endif
				   // wndClient requires special treatment
   eval(Selector:WndAdjClient, self:oWndClient:hWnd, hTop, hBottom, hLeft, hRight, .t. )

return 0

//----------------------------------------------------------------------------//

static function fw_Command( self, nWParam, nLParam )

   local oWnd := self:oWndClient:GetActive()

   do case
      case nWParam < 100   // MdiChild Menu Selection
	   return

      otherwise
	 self:super:Command( nWParam, nLParam )
   endcase

return

//----------------------------------------------------------------------------//

static function fw_End(self)

   if self:bValid != nil
      if ! Eval( self:bValid )
	 return .f.
      endif
   endif

   if self:oWndClient:lCloseAll()
      //self:PostMsg( WM_CLOSE )
      eval(Selector:PostMessage, self, 'hide' )
   else
      return .f.
   endif

return .t.

//----------------------------------------------------------------------------//

static function fw_SetMenu( self, oMenu, nMenuInfo )

  DEFAULT nMenuInfo := Len( oMenu:aItems )

  self:nMenuInfo = nMenuInfo

  if self:oMenuStart == nil
     self:oMenuStart = oMenu
     self:super:SetMenu( oMenu )
  else
     self:oMenu = oMenu
     oMenu:oWnd = Self
     self:oWndClient:SetMenu( oMenu, nMenuInfo )
  endif

return

//----------------------------------------------------------------------------//

function GetWndFrame() ; return oWndMain      // Default Frame Window

//----------------------------------------------------------------------------//

static function fw_GotFocus(self)

   self:lFocused = .t.

   if self:bGotFocus != nil
      Eval( self:bGotFocus )
   endif

return

//----------------------------------------------------------------------------//
