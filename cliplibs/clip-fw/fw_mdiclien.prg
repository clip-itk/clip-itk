/*   FiveWin likely clasJses					*/
/*   TMdiClient							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <clip-gtk.ch>
#include <fwin/FiveWin.ch>

#define MDIS_ALLCHILDSTYLES   1

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
#define WM_SYSCOMMAND       274   // 0x0112

#define WM_GETFONT           49  // 0x0031

#define SC_CLOSE          61536   // 0xF060
#define SC_NEXT           61504
#define SC_RESTORE        61728

static Selector := GetSelector()

function TMdiClient()
local obj := Inherit(TWindow())

	obj:ClassName	:= "FWIN_TMDICLIENT"
	obj:lRegistered	:= .f.
	obj:aWnd	:= {}

	_recover_FWIN_TMDICLIENT(obj)
return obj
**********
function _recover_FWIN_TMDICLIENT(obj)

	obj:New		:= @fw_New()
	obj:Tile	:= {| self, lHor | lHor := If( lHor == nil, .f., lHor ),;
				 self:SendMsg( WM_MDITILE, If( lHor, 1, 0 ) )}
	obj:Cascade	:= {| self | self:SendMsg( WM_MDICASCADE )}
	obj:ArrangeIcons:= {| self | self:SendMsg( WM_MDIICONARRANGE )}
	obj:NextWindow	:= {| self | self:SendMsg( WM_MDINEXT,, 1 )}
	obj:PrevWindow	:= {| self | self:SendMsg( WM_MDINEXT )}
	obj:GetActive	:= @fw_GetActive()
	obj:Add		:= {| self, oWnd | AAdd( self:aWnd, oWnd )}
	obj:ChildNew	:= @fw_ChildNew()
	obj:ChildActivate:= {|self, oWnd | self:SendMsg( WM_MDIACTIVATE, oWnd:hWnd )}
	obj:ChildMaximize:= {|self, oWnd | self:SendMsg( WM_MDIMAXIMIZE, oWnd:hWnd )}
	obj:ChildRestore:= {| self, oWnd | self:SendMsg( WM_MDIRESTORE, oWnd:hWnd )}
	obj:ChildClose	:= @fw_ChildClose()
	obj:ChildNext	:= {| self, oWnd, lPrev | ;
			   lPrev := If( lPrev == nil, .f., lPrev ),;
			   self:SendMsg( WM_MDINEXT, oWnd:hWnd, If( lPrev, 1, 0 ) )}

	obj:ReSize	:= {|| }// VIRTUAL
	obj:lCloseAll	:= @fw_lCloseAll()
	obj:IconizeAll	:= {| self | Selector:ASend( self:aWnd, "Iconize" )}
	obj:Select	:= @fw_Select()
	obj:SetMenu	:= {| self, oMenu, nMenuInfo | ;
				If( oMenu != nil,;
				( nMenuInfo := If( nMenuInfo == nil, Len( oMenu:aItems ), nMenuInfo),;
				self:SendMsg( WM_MDISETMENU, 0,;
				nMakeLong( oMenu:hMenu, GetSubMenu( oMenu:hMenu, nMenuInfo - 1 ) ) ),;
				eval(Selector:DrawMenuBar, self:oWnd:hWnd ) ), )}
	obj:KeyDown	:= @fw_KeyDown()
	obj:MouseMove	:= {| self, nRow, nCol, nFlags | self:oWnd:SetMsg(),;
			self:super:MouseMove( nRow, nCol, nFlags )}
	obj:GotFocus	:= {| self | self:lFocused := .t.,;
		     If( self:bGotFocus != nil, Eval( self:bGotFocus ), ), nil}

return obj

//----------------------------------------------------------------------------//

static function fw_New( self, oWnd, nSubMenu, nIdChildFirst, oBrush, lVscroll, lHScroll )

   local cClientCreateStruct

   //outlog(__FILE__, __LINE__, oWnd:oMenu:hMenu, nSubmenu, nIdChildFirst)
   cClientCreateStruct := ;
   L2Bin( GetSubMenu( oWnd:oMenu:hMenu, nSubMenu - 1 ) ) + ;
   L2Bin( nIdChildFirst )
   //outlog(__FILE__, __LINE__, "cClientCreateStruct=", cClientCreateStruct)

   DEFAULT lVScroll := .f., lHScroll := .f.

   self:nStyle = numOr( WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS, WS_CLIPCHILDREN,;
		   MDIS_ALLCHILDSTYLES,;
		   If( lVScroll, WS_VSCROLL, 0 ),;
		   If( lHScroll, WS_HSCROLL, 0 ) )

   self:aWnd    = {}
   self:oWnd    = oWnd
   self:oBrush  = oBrush
   self:nTop    = 0
   self:nLeft   = 0
   self:nBottom = 0
   self:nRight  = 0
   //outlog(__FILE__, __LINE__, 'cCaption', self:cCaption)
   self:hWnd    = eval(Selector:CreateWindow, self,"FWIN_TMDICLIENT", "", self:nStyle,;
			     0, 0, 0, 0, oWnd:hWnd, 1, cClientCreateStruct )
   self:Link()
   self:lVisible    = .t.
   self:lValidating = .f.

//   if lVScroll .or. lHScroll
//      SysRefresh()  // We give Windows some time to stabilize so
//   endif            // Some ScrollBar notifications get done!

   if lVScroll
      DEFINE SCROLLBAR self:oVScroll VERTICAL RANGE 1, 10 PAGESTEP 1 OF Self
   endif

   if lHScroll
      DEFINE SCROLLBAR self:oHScroll HORIZONTAL RANGE 1, 10 PAGESTEP 1 OF Self
   endif

   self:GetFont()

   /*
   if self:oFont == nil
      self:oFont = TFont()
      self:oFont:hFont = self:SendMsg( WM_GETFONT )
   endif
   */

return self

//----------------------------------------------------------------------------//

static function fw_ChildNew( self, nTop, nLeft, nBottom, nRight, cTitle, nStyle )

   local oWndChild := TMdiChild():New( nTop, nLeft, nBottom, nRight, cTitle,;
				       nStyle,, self:oWnd )
   oWndChild:Show()
   oWndChild:SetFocus()

return oWndChild

//----------------------------------------------------------------------------//

static function fw_GetActive(self)

   local hWndAt := nLoWord( self:SendMsg( WM_MDIGETACTIVE ) )
   local oWnd, nAt

   if hWndAt != 0
      if ( nAt := AScan( self:aWnd, { | oWnd | oWnd:hWnd == hWndAt } ) ) != 0
	 oWnd = self:aWnd[ nAt ]
      endif
   endif

return oWnd

//----------------------------------------------------------------------------//

static function fw_ChildClose( self, oWnd )

   local nAt := AScan( self:aWnd, { | oChild | oChild:hWnd == oWnd:hWnd } )

   if nAt != 0
      self:SendMsg( WM_MDIDESTROY, oWnd:hWnd )
      ADel( self:aWnd, nAt )
      ASize( self:aWnd, Len( self:aWnd ) - 1 )
      SetWndDefault( nil )
      if self:oWnd:oWndActive == oWnd
	 self:oWnd:oWndActive = nil
      endif
   endif

return

//----------------------------------------------------------------------------//

static function fw_lCloseAll(self)

   while Len( self:aWnd ) > 0 .and. ATail( self:aWnd ):End()
   end

return Len( self:aWnd ) == 0

//----------------------------------------------------------------------------//

static function fw_Select( self, nWindow )

   DEFAULT nWindow := 0

   if ! Empty( self:aWnd ) .and. nWindow >= 1 .and. nWindow <= Len( self:aWnd )
      self:SendMsg( WM_MDIACTIVATE, self:aWnd[ nWindow ]:hWnd )
   else
      self:SendMsg( WM_MDIACTIVATE, 0 )
   endif

return

//----------------------------------------------------------------------------//

static function fw_KeyDown( self, nKey, nFlags )

   // When the MdiChilds are iconized, they don't receive WM_KEYDOWN messages.
   // MdiClient receives those messages and there is no a standard behavior
   // so we have to process them !

   if nKey == VK_F4 .and. eval(Selector:GetKeyState, VK_CONTROL )
      eval(Selector:SendMessage, self:SendMsg( WM_MDIGETACTIVE ), WM_SYSCOMMAND, SC_CLOSE )
      return 0
   endif

   if nKey == VK_F6 .and. eval(Selector:GetKeyState, VK_CONTROL )
      eval(Selector:SendMessage, self:SendMsg( WM_MDIGETACTIVE ), WM_SYSCOMMAND, SC_NEXT )
      return 0
   endif

   if nKey == VK_RETURN
      eval(Selector:SendMessage, self:SendMsg( WM_MDIGETACTIVE ), WM_SYSCOMMAND, SC_RESTORE )
      return 0
   endif

return self:super:KeyDown( nKey, nFlags )

//----------------------------------------------------------------------------//
