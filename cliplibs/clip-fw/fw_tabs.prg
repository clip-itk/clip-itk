/*   FiveWin likely classes					*/
/*   Ttabs							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <fwin/FiveWin.ch>
#include <fwin/constant.ch>

#define COLOR_INACTIVECAPTION 3
#define COLOR_WINDOW          5
#define COLOR_WINDOWTEXT      8
#define COLOR_BTNFACE        15
#define COLOR_BTNSHADOW      16
#define COLOR_INACTIVECAPTIONTEXT  19
#define COLOR_BTNHIGHLIGHT   20

#define FD_BORDER             8
#define FD_HEIGHT            22

#define DT_CENTER             1
#define DT_VCENTER            4

#define WINDING               2
#define SC_KEYMENU        61696   // 0xF100

static Selector := GetSelector()

function TTabs
local obj := Inherit(TControl())

	obj:ClassName	:= "FWIN_TTABS"
	obj:lRegistered	:= .f.
	obj:aProperties	:= { "aPrompts", "nAlign", "nClrText", "nClrPane",;
				"nOption", "nTop", "nLeft", "nWidth",;
				"nHeight", "Cargo" }

	obj:aPrompts	:= {}
	obj:aSizes	:= {}
	obj:aPages	:= {}
	obj:nOption	:= 0
	obj:bAction	:= NIL
	obj:cAlign	:= "NULL"

	_recover_FWIN_TTABS(obj)

return obj
********************
function _recover_FWIN_TTABS(obj)

	obj:New		:= @fw_New()
	obj:ReDefine	:= @fw_ReDefine()
	obj:Display	:= @fw_Display()
	obj:Paint	:= @fw_Paint()
	obj:Initiate	:= @fw_Initiate()
	obj:LButtonDown	:= @fw_LButtonDown()
	obj:Default	:= @fw_Default()
	obj:AddItem	:= @fw_AddItem()
	obj:DelItem	:= @fw_DelItem()
	obj:SetOption	:= @fw_SetOption()
	obj:SetTabs	:= @fw_SetTabs()
	obj:GetHotPos	:= @fw_GetHotPos()
	obj:SysCommand	:= @fw_SysCommand()
	obj:Inspect	:= @fw_Inspect()
	obj:EditPrompts	:= @fw_EditPrompts()

	obj:PutItem	:= @fw_PutItem()
return obj

//----------------------------------------------------------------------------//

static function fw_New( self, nTop, nLeft, nBottom, nRight, aPrompts, bAction, ;
	     oWnd, nOption, nClrFore, nClrBack, lPixel, lDesign, cMsg, cAlign )

   DEFAULT nTop     := 0, nLeft := 0,;
	   nBottom  := 20, nRight := 10,;
	   aPrompts := { "&One", "&Two", "T&hree" },;
	   oWnd     := GetWndDefault(),;
	   nOption  := 1,;
	   nClrFore := oWnd:nClrText,;
	   nClrBack := GetSysColor( COLOR_BTNFACE ),;
	   lPixel   := .f.,;
	   lDesign  := .f.,;
	   cAlign := "BOTTOM"

   self:nStyle    = numOr( WS_CHILD, WS_VISIBLE,;
		      If( lDesign, WS_CLIPSIBLINGS, 0 ), WS_TABSTOP )
   self:nId       = self:GetNewId()
   self:oWnd      = oWnd
   self:aPrompts  = aPrompts
   self:bAction   = bAction
   self:nOption   = nOption
   self:cMsg      = cMsg
   self:nTop      = If( lPixel, nTop, nTop * WIN_CHARPIX_H )
   self:nLeft     = If( lPixel, nLeft, nLeft * WIN_CHARPIX_W )
   self:nBottom   = nBottom*iif(lPixel, 1, SAY_CHARPIX_H) - 21
   self:nRight 	  = nRight*iif(lPixel, 1, SAY_CHARPIX_W)
   self:lDrag     = lDesign
   self:lCaptured = .f.
   self:oFont     = TFont():New( FONT_DEFAULT, 0, -9 )
   self:nClrText  = nClrFore
   self:nClrPane  = nClrBack
   self:cAlign    = cAlign  // A.K. new my attribute - tabs align

   //DEFINE BRUSH self:oBrush STYLE TABS

      //DEFAULT self:lRegistered := .f.

   //self:Register()

   if ! Empty( oWnd:hWnd )
      eval(Selector:CreateTabs, Self )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   self:Default()

   if lDesign
      self:CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

static function fw_ReDefine( self, nId, aPrompts, bAction, oWnd, nOption, nClrFore,;
		 nClrBack )

   local n, oDlg

   DEFAULT nOption  := 1,;
	   nClrFore := oWnd:nClrText,;
	   nClrBack := GetSysColor( COLOR_BTNFACE )

   self:nId      = nId
   self:oWnd     = oWnd
   self:aPrompts = aPrompts
   self:bAction  = bAction
   self:nOption  = nOption
   self:oFont    = TFont():New( FONT_DEFAULT, 0, -9 )
   self:nClrText = nClrFore
   self:nClrPane = nClrBack

   self:Register()

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

static function fw_Display( self )

   self:BeginPaint()
   self:Paint()
   self:EndPaint()

return 0

//----------------------------------------------------------------------------//

static function fw_Paint( self )
/*
   local hDarkPen  := eval(Selector:CreatePen, PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) )
   local hGrayPen  := eval(Selector:CreatePen, PS_SOLID, 1, GetSysColor( COLOR_BTNFACE ) )
   local hLightPen := eval(Selector:CreatePen, PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) )
   local n, nCol := 5
   local hOldFont, hOldBrush, hOldPen
   local hDC := self:GetDC()
   local hGrayBrush := eval(Selector:CreateSolidBrush, self:nClrPane )
   local hDarkBrush := eval(Selector:CreateSolidBrush, GetSysColor( COLOR_INACTIVECAPTION ) )

   hOldFont  = eval(Selector:SelectObject, hDC, self:oFont:hFont )
   hOldPen   = eval(Selector:SelectObject, hDC, hDarkPen )
   hOldBrush = eval(Selector:SelectObject, hDC, hDarkBrush )

   eval(Selector:MoveTo, hDC, 0, 0 )
   eval(Selector:LineTo, hDC, self:nWidth(), 0 )

   eval(Selector:SetBlackPen, hDC )
   eval(Selector:MoveTo, hDC, 0, 1 )
   eval(Selector:LineTo, hDC, self:nWidth(), 1 )

   eval(Selector:SetTextColor, hDC, CLR_WHITE )

   if Len( self:aSizes ) < Len( self:aPrompts )
      self:Default()
   endif

   for n = 1 to Len( self:aPrompts )
      SelectObject( hDC, If( n == self:nOption, hGrayBrush, hDarkBrush ) )
      SetBlackPen( hDC )
      if n == 1 .or. n == self:nOption
	 PolyPolygon( hDC, { { nCol, 1 },;
			       { nCol + 5, 15 },;
			       { nCol + 9 + self:aSizes[ n ], 15 },;
			       { nCol + 14 + self:aSizes[ n ], 1 },;
			       { nCol, 1 } } )
      else
	 PolyPolygon( hDC, { { nCol + 2, 7 },;
			       { nCol + 5, 15 },;
			       { nCol + 9 + self:aSizes[ n ], 15 },;
			       { nCol + 14 + self:aSizes[ n ], 1 },;
			       { nCol + 4, 1 },;
			       { nCol + 2, 7 } } )
      endif

      if n == self:nOption
	 SelectObject( hDC, hGrayPen )
	 MoveTo( hDC, nCol, 0 )
	 LineTo( hDC, nCol + 14 + self:aSizes[ n ], 0 )
	 MoveTo( hDC, nCol + 1, 1 )
	 LineTo( hDC, nCol + 14 + self:aSizes[ n ], 1 )

	 SelectObject( hDC, hLightPen )
	 MoveTo( hDC, nCol + 1,  2 )
	 LineTo( hDC, nCol + 6, 14 )

	 SelectObject( hDC, hDarkPen )
	 LineTo( hDC, nCol + self:aSizes[ n ] +  8, 14 )
	 LineTo( hDC, nCol + self:aSizes[ n ] + 13,  0 )

	 SetTextColor( hDC, self:nClrText )
	 eval(Selector:SetBkColor, hDC, self:nClrPane )
	 eval(Selector:DrawText, hDC, self:aPrompts[ n ],;
		   { 1, nCol + 4, 15, nCol + 5 + self:aSizes[ n ] + 5 },;
		   numOr( DT_CENTER, DT_VCENTER ) )
      else
	 SetTextColor( hDC, GetSysColor( COLOR_INACTIVECAPTIONTEXT ) )
	 eval(Selector:SetBkColor, hDC, GetSysColor( COLOR_INACTIVECAPTION ) )
	 eval(Selector:DrawText, hDC, self:aPrompts[ n ],;
		   { 2, nCol + 3, 19, nCol + 5 + self:aSizes[ n ] + 6 },;
		   numOr( DT_CENTER, DT_VCENTER ) )
      endif
      nCol += self:aSizes[ n ] + 4 + 6
   next

   SelectObject( hDC, hOldPen )
   SelectObject( hDC, hOldFont )
   SelectObject( hDC, hOldBrush )

   DeleteObject( hDarkPen )
   DeleteObject( hGrayPen )
   DeleteObject( hLightPen )
   DeleteObject( hDarkBrush )
   DeleteObject( hGrayBrush )

   self:ReleaseDC()
*/
return nil

//----------------------------------------------------------------------------//

static function fw_Initiate( self, hDlg )

   self:Super:Initiate( hDlg )

   if self:oBrush == nil
      DEFINE BRUSH self:oBrush STYLE TABS
   endif

   self:Default()

return nil

//----------------------------------------------------------------------------//

static function fw_LButtonDown( self, nRow, nCol, nFlags )

   local n := 1, nPos := 5

   if self:lDrag
      return self:Super:LButtonDown( nRow, nCol, nFlags )
   else
      if nRow <= FD_HEIGHT
	 while nCol > nPos + self:aSizes[ n ] + 10 .and. n < Len( self:aPrompts )
	    nPos += self:aSizes[ n ] + 10
	    n++
	 end
	 self:SetOption( n )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_Default( self )

   local n

   self:aSizes = Array( Len( self:aPrompts ) )

   /*
   for n = 1 to Len( self:aPrompts )
      self:aSizes[ n ] = GetTextWidth( 0, StrTran( self:aPrompts[ n ], "&", "" ),;
				    self:oFont:hFont )
   next
   */

return nil

//----------------------------------------------------------------------------//

static function fw_AddItem( self, cItem )

   AAdd( self:aPrompts, cItem )
   self:Default()
   self:Refresh()

return nil

//----------------------------------------------------------------------------//

static function fw_DelItem( self )

   if Len( self:aPrompts ) > 1
      self:aPrompts = ADel( self:aPrompts, self:nOption )
      self:aPrompts = ASize( self:aPrompts, Len( self:aPrompts ) - 1 )
   else
      self:aPrompts = { "No Defined" }
   endif
   self:Default()
   self:Refresh()

return nil

//----------------------------------------------------------------------------//

static function fw_SetOption( self, nOption )

   if nOption != self:nOption
      self:nOption = nOption
      self:Paint()
      if ! Empty( self:bAction )
	 Eval( self:bAction, nOption )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_GetHotPos( self, nChar )

   local n := 1
   local nAt

   while n <= Len( self:aPrompts )
     if ( nAt := At( "&", self:aPrompts[ n ] ) ) != 0 .and. ;
	Lower( SubStr( self:aPrompts[ n ], nAt + 1, 1 ) ) == Chr( nChar )
	return n
     endif
     n++
   end

return 0

//----------------------------------------------------------------------------//

static function fw_SysCommand( self, nType, nLoWord, nHiWord )

   local nItem

   do case
      case nType == SC_KEYMENU      // Alt+... control accelerator pressed
	   if ( nItem := self:GetHotPos( nLoWord ) ) > 0
	      self:SetOption( nItem )
	      return 0
	   endif
   endcase

return nil

//----------------------------------------------------------------------------//

static function fw_SetTabs( self, aTabs, nOption )

   DEFAULT aTabs := { "&One", "&Two", "T&hree" }, nOption := 1

   self:aPrompts = aTabs
   self:nOption  = nOption
   self:Default()
   self:Refresh()

return nil

//----------------------------------------------------------------------------//

static function fw_Inspect( self, cData )

   if cData == "aPrompts"
      return { || self:EditPrompts() }
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_EditPrompts( self )

   local oDlg, n
   local cPrompts := ""
   local oFont
   local lOk := .f.
   local aPrompts := {}

   for n = 1 to Len( self:aPrompts )
      cPrompts += self:aPrompts[ n ] + CRLF
   next

   DEFINE FONT oFont NAME FONT_DEFAULT SIZE 0, -8

   //DEFINE DIALOG oDlg SIZE 300, 178 TITLE "Edit prompts" FONT oFont
   DEFINE DIALOG oDlg TITLE "Edit prompts" FONT oFont

   @ 0.2, 0.3 GET cPrompts MEMO SIZE 145, 70

   @ 7.5, 10.1 BUTTON "&Ok"     SIZE 30, 11 ACTION ( lOk := .t., oDlg:End() )
   @ 7.5, 22.1 BUTTON "&Cancel" SIZE 30, 11 ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

   if lOk
      for n = 1 to MLCount( cPrompts )
	 AAdd( aPrompts, AllTrim( MemoLine( cPrompts,, n ) ) )
      next
      self:SetTabs( aPrompts, 1 )
   endif

return nil

*********
static function fw_PutItem(self, nPage, oWnd)
//----------------------------------------------------------------------------//
