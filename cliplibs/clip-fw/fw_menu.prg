/*   FiveWin likely classes					*/
/*   TMenu							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <clip-gtk.ch>
#INCLUDE <fwin/FiveWin.ch>

#define MF_ENABLED       0
#define MF_GRAYED        1
#define MF_DISABLED      2
#define MF_BITMAP        4
#define MF_CHECKED       8
#define MF_POPUP        16  // 0x0010
#define MF_BREAK        64
#define MF_BYPOSITION 1024  // 0x0400
#define MF_SEPARATOR  2048  // 0x0800
#define MF_HELP      16384  // 0x4000
#define MF_HILITE      128  // 0x0080
#define MF_UNHILITE      0
#define MF_OWNERDRAW   256  // 0x0100

static aPopups := {}
static Selector := GetSelector()

function TMenu()
local obj:=map()

	obj:classname	:= "FWIN_TMENU"
	obj:hMenu	:= -1
	obj:aItems	:= {}
	obj:aAccel	:= {}
	obj:oWnd	:= NIL
	obj:lSysMenu	:= .f.
	obj:lPopup	:= .f.
	obj:nHelpId	:= NIL
	obj:cVarName	:= NIL

	_recover_FWIN_TMENU(obj)
return obj
**********
static function _recover_FWIN_TMENU(obj)
	obj:New		:= @fw_New()
	obj:NewSys	:= @fw_NewSys()
	obj:Redefine	:= @fw_Redefine()
	obj:Activate	:= @fw_Activate()
	obj:Add		:= @fw_Add()
	obj:AddEdit	:= @fw_AddEdit()
	obj:AddAccel	:= @fw_AddAccel()
	obj:AddHelp	:= @fw_AddHelp()
	obj:AddMdi	:= @fw_AddMdi()
	obj:Command	:= @fw_Command()
	obj:DelItems	:= @fw_DelItems()
	//obj:Destroy	:= @fw_Destroy()
	obj:Disable	:= @fw_Disable()
	obj:End		:= @fw_End()
	obj:GetMenuItem	:= @fw_GetMenuItem()
	obj:GetPopup	:= @fw_GetPopup()
	obj:GetSubMenu	:= {|self, hPopup| eval(Selector:SearchSubMenu,self, hPopup)}
	obj:HelpTopic	:= @fw_HelpTopic()
	obj:Hilite	:= @fw_Hilite()
	obj:Initiate	:= @fw_Initiate()
	obj:Insert	:= @fw_Insert()
	obj:LastItem	:= @fw_LastItem()
	obj:Load	:= @fw_Load()
	obj:Refresh	:= @fw_Refresh()
	obj:Release	:= @fw_Release()
	obj:Reset	:= @fw_Reset()
	obj:Save	:= @fw_Save()
	obj:UnHilite	:= @fw_UnHilite()
	obj:Disable	:= @fw_Disable()
	obj:Enable	:= @fw_Enable()
return
**********
static function fw_New(self, lPopup, oWnd)
	DEFAULT lPopup := .f. // , oWnd := GetWndDefault()

	self:hMenu    = iif(lPopup, eval(Selector:CreatePopupMenu,self), eval(Selector:CreateMenu,self))
	self:aItems   = {}
	self:lSysMenu = .f.
	self:lPopup   = lPopup

	if lPopup
		AAdd( aPopups, Self )
	endif

	if oWnd != nil
		oWnd:SetMenu( Self )
	endif
return self
**********
static function fw_NewSys(self, oWnd)
local n

	if oWnd != nil
		self:oWnd  = oWnd
		self:hMenu = eval(Selector:GetSystemMenu, oWnd:hWnd, .f. )
	endif
	self:aItems   = {}
	self:lSysMenu = .t.
return self
**********
static function fw_Redefine(self, cResName, lPopup)
/*
local hMenu := eval(Selector:LoadMenu, eval(Selector:GetResources), cResName )
local n

	self:hMenu    = hMenu
	self:aItems   = {}
	self:lSysMenu = .f.
	self:lPopup   = lPopup

	if lPopup
		// Windows does not provides a way of storing only Popups in resources
		// so we are going to create one on the fly copying it from the
		// one placed at resources
		self:hMenu = eval(Selector:CreatePopupMenu)
		eval(Selector:MenuClone, self:hMenu, hMenu )
		eval(Selector:DestroyMenu, hMenu )
	endif

	eval(Selector:ResBuild, Self )
*/
return self
 **********
static function fw_Activate(self, nRow, nCol, oWnd, lEnd)
local aPoint := { nRow, nCol }

	DEFAULT lEnd := .t.

	if oWnd != nil
		aPoint = eval(Selector:ClientToScreen, oWnd:hWnd, aPoint )

		if lEnd
			if oWnd:oPopup != nil
				oWnd:oPopup:End()
			endif
		endif
		oWnd:oPopup = Self
		eval(Selector:TrackPopup, self:hMenu, 2, aPoint[ 1 ], aPoint[ 2 ],;
			0, oWnd:hWnd )
		eval(Selector:SysRefresh)
		if lEnd
			self:End()
			oWnd:oPopup = nil
		endif
	endif
return
**********
static function fw_Add(self, oMenuItem)
	AAdd( self:aItems, oMenuItem )

	oMenuItem:oMenu = Self

	if ValType( oMenuItem:bAction ) == "O" .and. oMenuItem:bAction:className == "FWIN_TMENU"
		if oMenuItem:cPrompt != nil
			eval(Selector:AppendMenu, self:hMenu, oMenuItem, numOr( MF_POPUP, MF_ENABLED,;
				If( oMenuItem:hBitmap != 0, MF_OWNERDRAW, 0 ),;
				If( oMenuItem:lHelp, MF_HELP, 0 ),;
				If( oMenuItem:lChecked, MF_CHECKED, 0 ),;
				If( ! oMenuItem:lActive, MF_GRAYED, 0 ),;
				If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
				oMenuItem:bAction:hMenu,;
				oMenuItem:cPrompt )
		else
			eval(Selector:AppendMenu, self:hMenu, oMenuItem, numOr( MF_POPUP, MF_BITMAP,;
			  If( oMenuItem:lChecked, MF_CHECKED, 0 ),;
			  If( ! oMenuItem:lActive, MF_GRAYED, 0 ),;
			  If( oMenuItem:lHelp, MF_HELP, 0 ),;
			  If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
		     oMenuItem:bAction:hMenu, oMenuItem:hBitmap )
		endif
		AAdd( aPopups, oMenuItem:bAction )
	else
		if oMenuItem:cPrompt != nil
			eval(Selector:AppendMenu, self:hMenu, oMenuItem, ;
				numOr( If( oMenuItem:lActive,;
				numOr( MF_ENABLED, If( oMenuItem:hBitmap != 0, MF_OWNERDRAW, 0 ) ),;
				numOr( MF_DISABLED, MF_GRAYED ) ),;
				If( oMenuItem:lChecked, MF_CHECKED, 0 ),;
				If( oMenuItem:lHelp, MF_HELP, 0 ),;
				If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
				oMenuItem:nId, oMenuItem:cPrompt )
		else
			if oMenuItem:hBitmap != 0
				eval(Selector:AppendMenu, self:hMenu, oMenuItem, numOr( MF_BITMAP,;
					If( oMenuItem:lBreak, MF_BREAK, 0 ) ),;
					oMenuItem:nId, oMenuItem:hBitmap )
			else
				eval(Selector:AppendMenu, self:hMenu, oMenuItem, MF_SEPARATOR, oMenuItem:nId, "" )
			endif
		endif
	endif
return
***************
static function fw_addAccel(self, oAccel)
	if self:aAccel == NIL
		self:aAccel := {}
	endif
	aadd( self:aAccel, oAccel )
return
**********
static function fw_AddEdit()
return
**********
static function fw_AddHelp()
return
**********
static function fw_AddMdi(self)
   MENUITEM "&Window"
   MENU
      MENUITEM "&Tile Vertical"   ;
	 ACTION oMenuItem:oWnd:Tile() ;
	 MESSAGE "Vertical arranges the windows as nonoverlapping tiles" ;
	 WHEN Len( oMenuItem:oWnd:oWndClient:aWnd ) > 0

      MENUITEM "&Tile Horizontal" ACTION oMenuItem:oWnd:Tile( .t. ) ;
	 MESSAGE "Horizontal arranges the windows as nonoverlapping tiles" ;
	 WHEN Len( oMenuItem:oWnd:oWndClient:aWnd ) > 0

      MENUITEM "&Cascade"         ACTION oMenuItem:oWnd:Cascade() ;
	 MESSAGE "Arranges the windows so they overlap" ;
	 WHEN Len( oMenuItem:oWnd:oWndClient:aWnd ) > 0

      MENUITEM "&Next Window" + Chr( 9 ) + "Ctrl+F6" ;
	 ACTION oMenuItem:oWnd:NextWindow() MESSAGE "Selects the next window" ;
	 WHEN Len( oMenuItem:oWnd:oWndClient:aWnd ) > 1

      SEPARATOR

      MENUITEM "&Arrange Icons"   ACTION oMenuItem:oWnd:ArrangeIcons() ;
	 MESSAGE "Arrange icons at the bottom of the window" ;
	 WHEN Len( oMenuItem:oWnd:oWndClient:aWnd ) > 0

      MENUITEM "&Iconize All"     ACTION oMenuItem:oWnd:IconizeAll() ;
	 MESSAGE "Iconize all open windows" ;
	 WHEN Len( oMenuItem:oWnd:oWndClient:aWnd ) > 0

      MENUITEM "C&lose All"       ACTION oMenuItem:oWnd:CloseAll() ;
	 MESSAGE "Close all open windows" ;
	 WHEN Len( oMenuItem:oWnd:oWndClient:aWnd ) > 0
   ENDMENU
return
**********
static function fw_Command()
return
**********
static function fw_DelItems()
return
**********
static function fw_Destroy()
return
**********
static function fw_End()
return
**********
static function fw_GetMenuItem()
return
**********
static function fw_GetPopup()
return
**********
static function fw_HelpTopic()
return
**********
static function fw_Hilite()
return
**********
static function fw_Initiate()
return
**********
static function fw_Insert()
return
**********
static function fw_LastItem()
return
**********
static function fw_Load()
return
**********
static function fw_Refresh()
return
**********
static function fw_Release()
return
**********
static function fw_Reset()
return
**********
static function fw_Save()
return
**********
static function fw_UnHilite()
return
**********
static function fw_Disable()
return
**********
static function fw_Enable()
return
**********
static function SearchSubMenu( oMenu, hMenu )
local n, oSubMenu

   for n = 1 to Len( oMenu:aItems )
      if ValType( oSubMenu := oMenu:aItems[ n ]:bAction ) == "O"
	 if oSubMenu:hMenu == hMenu
	    return oSubMenu
	 endif
	 if ( oSubMenu := eval(Selector:SearchSubMenu, oSubMenu, hMenu ) ) != nil
	    return oSubMenu
	 endif
      endif
   next

return

