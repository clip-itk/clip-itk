/*   FiveWin likely classes					*/
/*   TWBrowse							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include "fwin/FiveWin.ch"
#include "InKey.ch"
#include "Set.ch"
#include "fwin/Constant.ch"
#include "fwin/Report.ch"

#define GW_HWNDFIRST          0
#define GW_HWNDLAST           1
#define GW_HWNDNEXT           2
#define GWL_STYLE           -16

#define HWND_BROADCAST    65535  // 0xFFFF

#define CS_DBLCLKS            8
#define COLOR_ACTIVECAPTION   2
#define COLOR_WINDOW          5
#define COLOR_CAPTIONTEXT     9
#define COLOR_HIGHLIGHT      13
#define COLOR_BTNFACE        15
#define COLOR_BTNTEXT        18

#define WM_SETFONT           48  // 0x30

// Lines Styles
#define LINES_NONE            0
#define LINES_BLACK           1
#define LINES_GRAY            2
#define LINES_3D              3
#define LINES_DOTED           4


static Selector := GetSelector()
extern DBSKIP

//----------------------------------------------------------------------------//

function TWBrowse()
local obj:=inHerit(TControl())

	obj:className	:= "FWIN_TWBROWSE"
	obj:cAlias	:= NIL
	obj:cField	:= ""
	obj:uValue1	:= NIL
	obj:uValue2	:= NIL
	obj:bLine	:= NIL
	obj:bSkip	:= NIL
	obj:bGoTop	:= NIL
	obj:bGoBottom	:= NIL
	obj:bLogicLen	:= NIL
	obj:bChange	:= NIL
	obj:bAdd	:= NIL
	obj:nRowPos	:= NIL
	obj:nColPos	:= NIL
	obj:nLen	:= NIL
	obj:nAt		:= NIL
	obj:nColAct	:= NIL
	obj:MaxFilter	:= NIL // Mximum number of records to tcount
			       // on indexed filters
	obj:lHitTop	:= .f.
	obj:lHitBottom	:= .f.
	obj:lCaptured	:= .f.
	obj:lMChange	:= .f.
	obj:lAutoEdit	:= .f.
	obj:lAutoSkip	:= .f.
	obj:lCellStyle	:= .f.
	obj:aHeaders	:= NIL
	obj:aColSizes	:= NIL
	obj:nClrBackHead:= NIL
	obj:nClrForeHead:= NIL
	obj:nClrBackFocus:= NIL
	obj:nClrForeFocus:= NIL
	obj:aJustify	:= NIL
	obj:aActions	:= NIL
	obj:oGet	:= NIL
	obj:nLineStyle	:= NIL
	obj:lIconView	:= .f.
	obj:aIcons	:= NIL
	obj:bIconDraw	:= NIL
	obj:bIconText	:= NIL
	obj:nIconPos	:= NIL

	obj:lRegistered := .f.

	__recover_FWIN_TWBROWSE(obj)

return obj
******************************************************************************
function __recover_FWIN_TWBROWSE(obj)

	obj:New		:= @fw_New()
	obj:Redefine	:= @fw_ReDefine()
	obj:nAtCol	:= @fw_nAtCol()
	obj:nAtIcon	:= @fw_nAtIcon()
	obj:lCloseArea	:= {| Self | ;
			If( ! Empty( Self:cAlias ), ( Self:cAlias )->( DbCloseArea() ),),;
			If( ! Empty( Self:cAlias ), Self:cAlias := "",), .t. }
	obj:lDblClick	:= @fw_LDblClick()
	obj:Default	:= @fw_Default()
	obj:BugUp	:= {| Self | Self:UpStable()}
	obj:Display	:= @fw_Display()
	obj:DrawIcon	:= @fw_DrawIcons()
	obj:DrawLine	:= {| Self, nRow | ;
			wBrwLine( Self:hWnd, Self:hDC, If( nRow == nil, Self:nRowPos, nRow ), ;
			Eval( Self:bLine ), Self:GetColSizes(), Self:nColPos,;
			Self:nClrText, Self:nClrPane,;
			If( Self:oFont != nil, Self:oFont:hFont, 0 ),;
			ValType( Self:aColSizes ) == "B", Self:aJustify, nil, Self:nLineStyle )}
	obj:DrawSelect	:= @fw_DrawSelect()
	obj:lEditCol	:= @fw_lEditCol()
	obj:Edit	:= @fw_Edit()
	obj:EditCol	:= @fw_EditCol()
	obj:GetColSizes	:= {| Self | ;
			If( ValType( Self:aColSizes ) == "A", Self:aColSizes, Eval( Self:aColSizes ) )}
	obj:GetDlgCode	:= @fw_GetDlgCode()
	obj:GoUp	:= @fw_GoUp()
	obj:GoDown	:= @fw_GoDown()
	obj:GoLeft	:= @fw_GoLeft()
	obj:GoRight	:= @fw_GoRight()
	obj:GoTop	:= @fw_GoTop()
	obj:GoBottom	:= @fw_GoBottom()
	obj:GotFocus	:= {| Self | Self:super:GotFocus(),;
			If( Self:nLen > 0 .and. ! Empty( Self:cAlias ) .and. ;
			! Self:lIconView, Self:DrawSelect(),)}
	obj:HScroll	:= @fw_HScroll()
	obj:DrawIcon 	:= @fw_DrawIcon()
	obj:Initiate	:= {| Self, hDlg | Self:super:Initiate( hDlg ), Self:Default()}
	obj:IsColVisible:= @fw_IsColVisible()
	obj:KeyDown	:= @fw_KeyDown()
	obj:KeyChar	:= @fw_KeyChar()
	obj:LButtonDown	:= @fw_LButtonDown()
	obj:LButtonUp	:= @fw_LButtonUp( )
	obj:LostFocus	:= {| Self, hCtlFocus | Self:super:LostFocus( hCtlFocus ),;
			If( Self:nLen > 0 .and. ! Empty( Self:cAlias ) .and. ;
			! Self:lIconView, Self:DrawSelect(),)}
	obj:MouseMove	:= @fw_MouseMove()
	obj:PageUp	:= @fw_PageUp()
	obj:PageDown	:= @fw_PageDown()
	obj:Paint	:= @fw_Paint()
	obj:RecAdd	:= {| Self | If( Self:bAdd != nil, Eval( Self:bAdd ),)}
	obj:RecCount 	:= @fw_RecCount()
	obj:Report	:= @fw_Report()
	obj:ReSize	:= @fw_ReSize()
	obj:nRowCount	:= {| Self | Self:nRows}//;
			//nWRows( Self:hWnd, 0, If( Self:oFont != nil, Self:oFont:hFont, 0 ) ) - 1}
	obj:SetArray	:= @fw_SetArray()
	obj:SetCols	:= @fw_SetCols()
	obj:SetFilter	:= @fw_SetFilter()
	obj:SetTree	:= @fw_SetTree()
	obj:ShowSizes	:= @fw_ShowSizes()
	obj:Skip	:= @fw_Skip()
	obj:UpStable	:= @fw_UpStable()
	obj:VertLine	:= @fw_VertLine()
	obj:VScroll	:= @fw_VScroll()

return obj

//----------------------------------------------------------------------------//

static function fw_New( Self, nRow, nCol, nWidth, nHeight, bLine, aHeaders, aColSizes, oWnd,;
	    cField, uVal1, uVal2, bChange, bLDblClick, bRClick,;
	    oFont, oCursor, nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
	    lPixel, bWhen, lDesign, bValid, bLClick, aActions )


	DEFAULT nRow := 0, nCol := 0, nHeight := 100, nWidth := 100,;
	   oWnd := GetWndDefault(), nClrFore := CLR_BLACK,;
	   nClrBack := GetSysColor( COLOR_WINDOW ),;
	   lUpdate  := .f., cAlias := Alias(), lPixel := .f.,;
	   lDesign  := .f.


	Self:cCaption   = ""
	Self:nTop       = nRow * If( lPixel, 1, BRSE_CHARPIX_H ) // 14
	Self:nLeft      = nCol * If( lPixel, 1, BRSE_CHARPIX_W )  //8
	Self:nBottom    = Self:nTop + nHeight - 1
	Self:nRight     = Self:nLeft + nWidth - 1
	Self:nHeight    = nHeight
	Self:nWidth     = nWidth
	Self:oWnd       = oWnd
	Self:lHitTop    = .f.
	Self:lHitBottom = .f.
	Self:lFocused   = .f.
	Self:lCaptured  = .f.
	Self:lMChange   = .t.
	Self:nRowPos    = 1
	Self:nColPos    = 1
	Self:nColAct    = 1
	Self:nStyle     = numOr( WS_CHILD, WS_VSCROLL, WS_HSCROLL,;
			       WS_BORDER, WS_VISIBLE, WS_TABSTOP,;
			       If( lDesign, WS_CLIPSIBLINGS, 0 ) )
	Self:nId        = Self:GetNewId()
	Self:cAlias     = cAlias
	Self:bLine      = bLine
	Self:lAutoEdit  = .f.
	Self:lAutoSkip  = .f.
	Self:lIconView  = .f.
	Self:lCellStyle = .f.
	Self:nIconPos   = 0

	Self:SetFilter( cField, uVal1, uVal2 )

	Self:bAdd       = { || ( Self:cAlias )->( DbAppend() ), Self:UpStable() }

	Self:aHeaders   = aHeaders
	Self:aColSizes  = aColSizes
	Self:nLen       = 0
	Self:lDrag      = lDesign
	Self:lCaptured  = .f.
	Self:lMChange   = .t.
	Self:bChange    = bChange
	Self:bLClicked  = bLClick
	Self:bLDblClick = bLDblClick
	Self:bRClicked  = bRClick

	Self:oCursor    = oCursor
	Self:oFont      = oFont

	//Self:nLineStyle    := LINES_3D
	Self:nLineStyle    := LINES_GRAY
	Self:nClrBackHead  := GetSysColor( COLOR_BTNFACE )
	Self:nClrForeHead  := GetSysColor( COLOR_BTNTEXT )
	Self:nClrBackFocus := GetSysColor( COLOR_HIGHLIGHT )
	Self:nClrForeFocus := CLR_WHITE

	Self:cMsg          = cMsg
	Self:lUpdate       = lUpdate
	Self:bWhen         = bWhen
	Self:bValid        = bValid
	Self:aActions      = aActions


	Self:Register := .t.

	if ! Empty( oWnd:hWnd )
		eval(Selector:CreateWBrowse, Self )
		Self:Default()
		Self:lVisible = .t.
		oWnd:AddControl( Self )
	else
		oWnd:DefControl( Self )
		Self:lVisible = .f.
	endif

	eval(Selector:ConfigureBrowse, Self )

	Self:SetColor( nClrFore, nClrBack )

	if lDesign
		Self:CheckDots()
	endif

return Self

//----------------------------------------------------------------------------//

static function fw_ReDefine( Self, nId, bLine, oDlg, aHeaders, aColSizes, cField, uVal1, uVal2,;
		 bChange, bLDblClick, bRClick, oFont, oCursor,;
		 nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
		 bWhen, bValid, bLClick, aActions )

   DEFAULT oDlg := GetWndDefault(), nClrFore := CLR_BLACK,;
	   nClrBack := GetSysColor( COLOR_WINDOW ), lUpdate := .f., cAlias := Alias()

   Self:lHitTop    = .f.
   Self:lHitBottom = .f.
   Self:lFocused   = .f.
   Self:nId        = nId
   Self:nRowPos    = 1
   Self:nColPos    = 1
   Self:nColAct    = 1
   Self:cAlias     = cAlias
   Self:oWnd       = oDlg
   Self:aHeaders   = aHeaders
   Self:aColSizes  = aColSizes
   Self:nClrPane   = CLR_LIGHTGRAY
   Self:nClrText   = CLR_WHITE
   Self:nLen       = 0
   Self:lDrag      = .f.
   Self:lCaptured  = .f.
   Self:lVisible   = .f.
   Self:lCaptured  = .f.
   Self:lMChange   = .t.

   Self:bLine      = bLine
   Self:bChange    = bChange
   Self:bLClicked  = bLClick
   Self:bLDblClick = bLDblClick
   Self:bRClicked  = bRClick

   Self:oCursor    = oCursor
   Self:oFont      = oFont

   Self:nLineStyle    := LINES_GRAY
   //Self:nLineStyle    := LINES_3D
   Self:nClrBackHead  := GetSysColor( COLOR_BTNFACE )
   Self:nClrForeHead  := CLR_BLACK
   Self:nClrBackFocus := GetSysColor( COLOR_HIGHLIGHT )
   Self:nClrForeFocus := CLR_WHITE

   Self:cMsg          = cMsg
   Self:lUpdate       = lUpdate
   Self:bWhen         = bWhen
   Self:bValid        = bValid
   Self:aActions      = aActions
   Self:lAutoEdit     = .f.
   Self:lIconView     = .f.
   Self:lCellStyle    = .f.
   Self:nIconPos      = 0

   Self:SetColor( nClrFore, nClrBack )

   Self:SetFilter( cField, uVal1, uVal2 )
   Self:bAdd       = { || ( Self:cAlias )->( DbAppend() ), Self:UpStable() }

   Self:Register( numOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

   oDlg:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

static function fw_DrawSelect(Self)

   if Self:lCellStyle
      WBrwLine( Self:hWnd, Self:hDC, Self:nRowPos, Eval( Self:bLine ),;
		Self:GetColSizes(), Self:nColPos, Self:nClrForeFocus,;
		If( Self:lFocused, Self:nClrBackFocus, CLR_GRAY ),;
		If( Self:oFont != nil, Self:oFont:hFont, 0 ),;
		ValType( Self:aColSizes ) == "B", Self:aJustify,, Self:nLineStyle,;
		Self:nColAct, Self:lFocused )
   else
      WBrwLine( Self:hWnd, Self:hDC, Self:nRowPos, Eval( Self:bLine ),;
		Self:GetColSizes(), Self:nColPos, Self:nClrForeFocus,;
		If( Self:lFocused, Self:nClrBackFocus, CLR_GRAY ),;
		If( Self:oFont != nil, Self:oFont:hFont, 0 ),;
		ValType( Self:aColSizes ) == "B", Self:aJustify,, Self:nLineStyle, nil,;
		Self:lFocused )
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_DrawIcons(Self)

   local nWidth := Self:nWidth(), nHeight := Self:nHeight()
   local nRow := 10, nCol := 10
   local n := 1, nIcons := Int( nWidth / 50 ) * Int( nHeight / 50 )
   local hIcon := ExtractIcon( "user.exe", 0 )
   local oFont, cText

   DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0, -8 UNDERLINE

   eval(Selector:SelectObject, Self:hDC, oFont:hFont )
   eval(Selector:SetBkColor, Self:hDC, CLR_BLUE )
   eval(Selector:SetTextColor, Self:hDC, CLR_WHITE )

   while n <= nIcons .and. ! ( Self:cAlias )->( EoF() )
      if Self:bIconDraw != nil .and. Self:aIcons != nil
	 hIcon = Self:aIcons[ Eval( Self:bIconDraw, Self ) ]
      endif
      DrawIcon( Self:hDC, nRow, nCol, hIcon )
      if Self:bIconText != nil
	 cText = cValToChar( Eval( Self:bIconText, Self ) )
      else
	 cText = Str( ( Self:cAlias )->( RecNo() ) )
      endif
      eval(Selector:DrawText, Self:hDC, cText, { nRow + 35, nCol - 5, nRow + 48, nCol + 40 },;
		1 )
      nCol += 50
      if nCol >= nWidth - 32
	 nRow += 50
	 nCol  = 10
      endif
      ( Self:cAlias )->( DbSkip() )
      n++
   end
   ( Self:cAlias )->( DbSkip( 1 - n ) )

   oFont:End()

return nil

//----------------------------------------------------------------------------//

static function fw_Edit( Self, nCol, lModal )

   local uTemp, cType, lAutoSave, lContinue

   DEFAULT nCol := 1, lModal := .t.

   DO
      uTemp = Eval( Self:bLine )[ nCol ]
      if ! Empty( Self:cAlias ) .and. Upper( Self:cAlias ) != "ARRAY"
	 lAutoSave = ( cValToChar( ( Self:cAlias )->( FieldGet( nCol ) ) ) == uTemp )
	 if ( Self:cAlias )->( RLock() )
	    if lContinue := Self:lEditCol( nCol, @uTemp )
	       if lAutoSave
		  cType = ValType( ( Self:cAlias )->( FieldGet( nCol ) ) )
		  do case
		     case cType == "D"
			( Self:cAlias )->( FieldPut( nCol, CToD( uTemp ) ) )

		     case cType == "L"
			( Self:cAlias )->( FieldPut( nCol, Upper( uTemp ) == ".T." ) )

		     case cType == "N"
			( Self:cAlias )->( FieldPut( nCol, Val( uTemp ) ) )

		     otherwise
			( Self:cAlias )->( FieldPut( nCol, uTemp ) )
		  endcase
	       endif
	       Self:DrawSelect()
	    endif
	    ( Self:cAlias )->( DbUnLock() )
	 else
	    MsgStop( "Record locked!", "Please, try again" )
	 endif
      else
	 Self:lEditCol( nCol, @uTemp )
      endif
      if lContinue .and. Self:lAutoSkip
	 if nCol < Len( Eval( Self:bLine ) )
	    Self:GoRight()
	    nCol++
	 else
	    Self:nColPos = 1
	    nCol = 1
	    Self:GoDown()
	 endif
      endif
   UNTIL ! ( Self:lAutoSkip .and. lContinue )

return nil

//----------------------------------------------------------------------------//

static function fw_EditCol( Self, nCol, uVar, cPicture, bValid, nClrFore, nClrBack, aItems,;
		bAction )

   local oFont
   local uTemp
   local aDim, aPos
   local cType
   local nWidth, nHeight

   DEFAULT nCol := Self:nColAct

   uTemp   := uVar
   aDim    := aBrwPosRect( Self:hWnd, Self:nRowPos, Self:aColSizes, Self:nColPos, nCol,;
			  If( Self:oFont != nil, Self:oFont:hFont, 0 ) )
   aPos    := { aDim[ 1 ], aDim[ 2 ] }
   cType   := ValType( uVar )

   nWidth  := aDim[ 4 ] - aDim[ 2 ]
   nWidth  := Self:aColSizes[nCol]
   nHeight := aDim[ 3 ] - aDim[ 1 ]

   ScreenToClient( Self:hWnd, aPos )

   IF Self:lCellStyle .and. nCol != Self:nColAct
	Self:nColAct := nCol
	 if Self:oHScroll != nil
	    Self:oHScroll:SetPos(nCol)
	 endif
	Self:Refresh(.F.)
   ENDIF

   DEFAULT nClrFore := Self:nClrText ,;
	   nClrBack := Self:nClrPane ,;
	   bValid   := {|| nil }

   if Self:oGet != nil .AND. ! Empty( Self:oGet:hWnd )
      Self:oGet:End()
   endif

   if Self:oFont != nil
      oFont = TFont():New( Self:oFont:cFaceName, Self:oFont:nWidth,;
			   Self:oFont:nHeight, .f., Self:oFont:lBold )
   endif

   do case
      case cType == "L"
	   DEFAULT aItems := { ".T.", ".F." }

	   uVar = If( uTemp, aItems[ 1 ], aItems[ 2 ] )
	   @  aPos[ 1 ] + 1, aPos[ 2 ] + 1 COMBOBOX Self:oGet VAR uVar ITEMS aItems ;
	      SIZE  Min(100,Max(nWidth,50)), 100 OF Self ;
	      FONT oFont COLOR nClrFore, nClrBack ;
	      ON CHANGE Self:End() ;
	      PIXEL

      case aItems != nil
	   @  aPos[ 1 ] + 1, aPos[ 2 ] + 1 COMBOBOX Self:oGet VAR uVar ITEMS aItems ;
	      SIZE nWidth, Max( 200, Len( aItems ) * 25 ) OF Self ;
	      FONT oFont COLOR nClrFore, nClrBack ;
	      ON CHANGE Self:End() ;
	      PIXEL

      otherwise
	  @ aPos[ 1 ] + 1, aPos[ 2 ] + 1 GET Self:oGet VAR uVar ;
	       SIZE nWidth, nHeight ;
	       OF Self ;
	       FONT oFont COLOR nClrFore, nClrBack ;
	       PIXEL

	  Self:oGet:oGet:Picture = cPicture
   endcase

   Self:nLastKey := 0
   Self:oGet:Set3dLook()
   Self:oGet:SetFocus()

   if Self:oGet:ClassName != "FWIN_TGET"
      Self:oGet:Refresh()
   endif

   Self:oGet:bLostFocus := {|| If( Self:oGet:ClassName == "FWIN_TGET",;
      ( Self:oGet:Assign(), Self:oGet:VarPut( Self:oGet:oGet:VarGet())),;
      Self:oGet:VarPut( If( cType == "L", ( uVar == aItems[ 1 ] ), Self:oGet:VarGet() ) ) ),;
      If( Self:nLastKey != VK_ESCAPE,;
      Eval( bValid, uVar, Self:nLastKey ),;
      Eval( bValid, nil, Self:nLastKey ) ),;
      Self:oGet:End() }

   Self:oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. ;
				     nKey == VK_ESCAPE,;
			( Self:nLastKey := nKey, Self:oGet:End()), ) }
return .f.

//----------------------------------------------------------------------------//

static function fw_ReSize( Self, nSizeType, nWidth, nHeight )

   Self:nRowPos = Min( Self:nRowPos, Max( Self:nRowCount(), 1 ) )

return Self:super:ReSize( nSizeType, nWidth, nHeight )

//----------------------------------------------------------------------------//

static function fw_SetArray( Self, aArray )

   Self:nAt       = 1
   Self:cAlias    = "ARRAY"
   // Self:bLine     = { || { aArray[ Self:nAt ] } }
   Self:bLogicLen = { || Self:nLen := Len( aArray ) }
   Self:bGoTop    = { || Self:nAt := 1 }
   Self:bGoBottom = { || Self:nAt := Eval( Self:bLogicLen ) }
   Self:bSkip     = { | nSkip, nOld | nOld := Self:nAt, Self:nAt += nSkip,;
		  Self:nAt := Min( Max( Self:nAt, 1 ), Eval( Self:bLogicLen ) ),;
		  Self:nAt - nOld }
return nil

//----------------------------------------------------------------------------//

static function fw_SetTree( Self, oTree )

   local oItem := oTree:oFirst

   Self:lMChange   = .f.
   Self:bLine      = { || oItem:GetLabel() }
   Self:aColSizes  = { || oItem:ColSizes() }
   Self:bGoTop     = { || oItem := oTree:oFirst }
   Self:bGoBottom  = { || oItem := oTree:GetLast() }
   Self:bSkip      = { | n | oItem := oItem:Skip( @n ), Self:Cargo := oItem, n }
   Self:bLogicLen  = { || Self:nLen := oTree:nCount() }
   Self:bLDblClick = { || If( oItem:oTree != nil,;
			 ( oItem:Toggle(), Self:Refresh() ),) }
   Self:Cargo      = oItem
   Self:bKeyChar   = { | nKey | If( nKey == 13 .and. oItem:oTree != nil,;
			 ( oItem:Toggle(), Self:Refresh() ),) }

   if Self:oHScroll != nil
      Self:oHScroll:SetRange( 0, 0 )
      Self:oHScroll = nil
   endif

   oTree:Draw()

return nil

//----------------------------------------------------------------------------//

static function fw_Paint(Self)

   local n := 1, nSkipped := 1, nLines

   if Self:lIconView
      Self:DrawIcons()
      return 0
   endif

   if Self:nRowPos == 1 .and. ! Empty( Self:cAlias ) .and. ;
      Upper( Self:cAlias ) != "ARRAY"
      if ! ( Self:cAlias )->( EoF() )
	 ( Self:cAlias )->( DbSkip( -1 ) )
	 if ! ( Self:cAlias )->( BoF() )
	    ( Self:cAlias )->( DbSkip() )
	 endif
      endif
   endif

   WBrwLine( Self:hWnd, Self:hDC, 0, Self:aHeaders, Self:GetColSizes(),;
	       Self:nColPos, Self:nClrForeHead, Self:nClrBackHead,;
	       If( Self:oFont != nil, Self:oFont:hFont, 0 ),.f.,;
		  Self:aJustify, nil, Self:nLineStyle)

   if ( Self:nLen := Eval( Self:bLogicLen ) ) > 0

      Self:Skip( 1 - Self:nRowPos )

      #ifdef __XPP__
	 nLines = Self:nRowCount()
	 while n <= nLines .and. nSkipped == 1
	    Self:DrawLine( n )
	    nSkipped = Self:Skip( 1 )
	    if nSkipped == 1
	       n++
	    endif
	 end
	 Self:Skip( Self:nRowPos - n )
      #else
	  // WBrwPane() returns the n¡ of visible rows
	  // WBrwPane recieves at aColSizes the Array or a Block
	  // to get dinamically the Sizes !!!
	 Self:Skip( Self:nRowPos - wBrwPane( Self:hWnd, Self:hDC, Self, Self:bLine,;
	      Self:aColSizes, Self:nColPos, Self:nClrText, Self:nClrPane,;
	      If( Self:oFont != nil, Self:oFont:hFont, 0 ), Self:aJustify, Self:nLineStyle ) )
      #endif

      if Self:nLen < Self:nRowPos
	 Self:nRowPos = Self:nLen
      endif

      Self:DrawSelect()
   endif

   if ! Empty( Self:cAlias ) .and. Upper( Self:cAlias ) != "ARRAY"
      Self:lHitTop    = ( Self:cAlias )->( BoF() )
      Self:lHitBottom = ( Self:cAlias )->( EoF() )
   endif

return 0

//----------------------------------------------------------------------------//

static function fw_lEditCol( Self, nCol, uVar, cPicture, bValid, nClrFore, nClrBack,;
		 aItems, bAction )

   local oDlg, oGet, oFont, oBtn, oBtnAction
   local nWidth := Self:aColSizes[ nCol ]
   local uTemp
   local aDim
   local lOk
   local cType

   DEFAULT nClrFore := Self:nClrText ,;
	   nClrBack := Self:nClrPane ,;
	   nCol := Self:nColAct

   uTemp  := uVar
   aDim   := aBrwPosRect( Self:hWnd, Self:nRowPos, Self:aColSizes, Self:nColPos, nCol,;
			  If( Self:oFont != nil, Self:oFont:hFont, 0 ) )
   aDim[ 1 ] = aDim[ 1 ] + 1
   lOk    := .f.
   cType  := ValType( uVar )

   IF Self:lCellStyle .and. nCol != Self:nColAct
	Self:nColAct := nCol
	 if Self:oHScroll != nil
	    Self:oHScroll:SetPos(nCol)
	 endif
	Self:Refresh(.F.)
   ENDIF

   DEFINE DIALOG oDlg FROM aDim[ 1 ], aDim[ 2 ] TO aDim[ 3 ], aDim[ 4 ] ;
      STYLE numOr( WS_VISIBLE, WS_POPUP ) PIXEL

   if Self:oFont != nil
      oFont = TFont():New( Self:oFont:cFaceName, Self:oFont:nWidth,;
			   Self:oFont:nHeight, .f., Self:oFont:lBold )
   endif

   // if we use uTemp instead of uVar, then VALID does not work!
   // because VALID is issued on uVar. !!!

   do case
      case cType == "L"
	   DEFAULT aItems := { ".T.", ".F." }

	   uVar = If( uTemp, aItems[ 1 ], aItems[ 2 ] )
	   @  0, 0 COMBOBOX oGet VAR uVar ITEMS aItems ;
	      SIZE ( aDim[ 4 ] - aDim[ 2 ] ) * 0.50, 50 OF oDlg ;
	      ON CHANGE ( oDlg:End(), lOk := .t. ) ;
	      FONT oFont COLOR nClrFore, nClrBack

      case aItems != nil
	   @  0, 0 COMBOBOX oGet VAR uVar ITEMS aItems ;
	      SIZE ( aDim[ 4 ] - aDim[ 2 ] ) * 0.50, 50 OF oDlg ;
	      ON CHANGE ( oDlg:End(), lOk := .t. ) ;
	      FONT oFont COLOR nClrFore, nClrBack

      otherwise
	 @  0, 0 GET oGet VAR uVar ; // we have to use here uVar to use VALID !!!
	 SIZE aDim[ 4 ] - aDim[ 2 ] - If( bAction != nil, 12, 0 ),;
	 aDim[ 3 ] - aDim[ 1 ]  OF oDlg ;
	 FONT oFont COLOR nClrFore, nClrBack

	 oGet:oGet:Picture = cPicture

	 if bAction != nil
	    @ 0, 0 BUTTON oBtnAction PROMPT "" OF oDlg SIZE 12, 12
	    oBtnAction:bAction = { || oGet:VarPut( Eval( bAction, uVar ) ),;
				      oDlg:End() }
	 endif
   endcase

   oGet:bValid = bValid

   @ 10, 0 BUTTON oBtn PROMPT "" ACTION ( oDlg:End(), lOk := .t. ) OF oDlg

   oBtn:nStyle = numOr( WS_CHILD, WS_VISIBLE, BS_DEFPUSHBUTTON )

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgAdjust( oDlg, oGet, oBtnAction, aDim, cType )

   if ! lOk
      uVar = uTemp
   else
      if cType == "L"
	 uVar = ( uVar == aItems[ 1 ] )
      endif
   endif

return lOk

//----------------------------------------------------------------------------//

static function DlgAdjust( oDlg, oGet, oBtnAction, aDim, cType )

   oDlg:Move( aDim[ 1 ] + 1, aDim[ 2 ] + 1,;
	      aDim[ 4 ] - aDim[ 2 ], aDim[ 3 ] - aDim[ 1 ] )

   do case
      case cType == "L"
	   oGet:Move( -3, -1, aDim[ 4 ] - aDim[ 2 ] + 3, 50 )

      case oBtnAction != nil
	   oGet:Move( -3, -1, aDim[ 4 ] - aDim[ 2 ] - 14,;
		      aDim[ 3 ] - aDim[ 1 ] + 6 )
	   oBtnAction:Move( 0, aDim[ 4 ] - aDim[ 2 ] - 15, 15,;
	   aDim[ 3 ] - aDim[ 1 ] )

    otherwise
	   oGet:Move( -2, 0 )
   endcase

return nil

//----------------------------------------------------------------------------//

static function fw_GoUp(Self)

   local nSkipped
   local nLines := Self:nRowCount()

   if ( Self:nLen := Eval( Self:bLogicLen ) ) < 1
      return nil
   endif

   if ! Self:lHitTop
      Self:DrawLine()
      if Self:Skip( -1 ) == -1
	 Self:lHitBottom = .f.
	 if Self:nRowPos > 1
	    Self:nRowPos--
	 else
	    WBrwScroll( Self:hWnd, -1, If( Self:oFont != nil, Self:oFont:hFont, 0 ) )
	 endif
      else
	 Self:lHitTop = .t.
      endif
      Self:DrawSelect()
      if Self:oVScroll != nil
	 Self:oVScroll:GoUp()
      endif
      if Self:bChange != nil
	 Eval( Self:bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_GoDown(Self)

   local nSkipped
   local nLines := Self:nRowCount()

   if ( Self:nLen := Eval( Self:bLogicLen ) ) < 1
      return nil
   endif

   if ! Self:lHitBottom
      Self:DrawLine()
      if Self:Skip( 1 ) == 1
	 Self:lHitTop = .f.
	 if Self:nRowPos < nLines
	    Self:nRowPos++
	 else
	    WBrwScroll( Self:hWnd, 1, If( Self:oFont != nil, Self:oFont:hFont, 0 ) )
	 endif
      else
	 Self:lHitBottom = .t.
      endif
      Self:DrawSelect()
      if Self:oVScroll != nil
	 Self:oVScroll:GoDown()
      endif
      if Self:bChange != nil
	 Eval( Self:bChange, Self )
      endif
   endif

return nil

//---------------------------------------------------------------------------//

static function fw_GoLeft(Self)

   if Self:nColAct > 1
      if Self:lCellStyle .and. Self:IsColVisible( Self:nColAct-1 )
	 Self:nColAct--
	 Self:DrawSelect()
      else
	 Self:nColPos--
	 Self:nColAct--
	 Self:Refresh()
      endif
      if Self:oHScroll != nil
	 Self:oHScroll:GoUp()
      endif
   endif

return nil

//---------------------------------------------------------------------------//

static function fw_GoRight(Self)

   local lColVisible

   if Self:nColAct < Len( Self:GetColSizes() )
      lColVisible = Self:IsColVisible( Self:nColAct + 1 )
      Self:nColAct++
      do while ! Self:IsColVisible( Self:nColAct ) .and. Self:nColPos < Self:nColAct
	 Self:nColPos++
      enddo
      if ! Self:lCellStyle
	 Self:nColPos := Self:nColAct
	 Self:Refresh()
      else
	 if lColVisible
	    Self:DrawSelect()
	 else
	    Self:Refresh()
	 endif
      endif
      if Self:oHScroll != nil
	 Self:oHScroll:GoDown()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_GoTop(Self)

   if ( Self:nLen := Eval( Self:bLogicLen ) ) < 1
      return nil
   endif

   if ! Self:lHitTop
      Eval( Self:bGoTop )
      Self:lHitTop = .t.
      Self:lHitBottom = .f.
      Self:nRowPos = 1
      Self:Refresh( .f. )
      if Self:oVScroll != nil
	 Self:oVScroll:GoTop()
      endif
      if Self:bChange != nil
	 Eval( Self:bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_GoBottom(Self)

   local nSkipped
   local nLines := Self:nRowCount()
   local n

   if ( Self:nLen := Eval( Self:bLogicLen ) ) < 1
      return nil
   endif

   if ! Self:lHitBottom
      Self:lHitBottom = .t.
      Self:lHitTop    = .f.

      Eval( Self:bGoBottom )

      nSkipped = Self:Skip( -( nLines - 1 ) )
      Self:nRowPos = 1 - nSkipped

      Self:GetDC()
      for n = 1 to -nSkipped
	  Self:DrawLine( n )
	  Self:Skip( 1 )
      next
      Self:DrawSelect()
      Self:ReleaseDC()
      if Self:oVScroll != nil
	 Self:nLen = Eval( Self:bLogicLen )
	 if Self:oVScroll:nMax != Self:nLen
	    Self:oVScroll:SetRange( 1, Self:nLen )
	 endif
	 Self:oVScroll:GoBottom()
      endif
      if Self:bChange != nil
	 Eval( Self:bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_LDblClick( Self, nRow, nCol, nKeyFlags )

   local nClickRow := nWRow( Self:hWnd, Self:hDC, nRow,;
			     If( Self:oFont != nil, Self:oFont:hFont, 0 ) )
   local nBrwCol

   if nClickRow == Self:nRowPos .and. Self:nLen > 0
      nBrwCol = Self:nAtCol( nCol )
      if Self:lAutoEdit
	 Self:Edit( nBrwCol )
      else
	 return Self:super:LDblClick( nRow, nCol, nKeyFlags )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_LButtonDown( Self, nRow, nCol, nKeyFlags )

   local nClickRow, nSkipped
   local nColPos := 0, nColInit := Self:nColPos - 1
   local oRect, nAtCol

   if Self:lDrag
      return Self:super:LButtonDown( nRow, nCol, nKeyFlags )
   endif

   nClickRow = nWRow( Self:hWnd, Self:hDC, nRow,;
		      If( Self:oFont != nil, Self:oFont:hFont, 0 ) )

   if Self:nLen < 1 .and. nClickRow != 0
      return nil
   endif

   if Self:lMChange .and. AScan( Self:GetColSizes(),;
	     { | nColumn | nColPos += nColumn,;
			   nColInit++,;
			   nCol >= nColPos - 1 .and. ;
			   nCol <= nColPos + 1 }, Self:nColPos ) != 0
      if ! Self:lCaptured
	 Self:lCaptured = .t.
	 Self:Capture()
	 Self:VertLine( nColPos, nColInit )
      endif
      return nil
   endif

   Self:SetFocus()

   if nClickRow == 0 .and. Valtype(nKeyFlags) == "N"
      if Self:aActions != nil .and. ;
	 ( nAtCol := Self:nAtCol( nCol ) ) <= Len( Self:aActions )
	    if Self:aActions[ nAtCol ] != nil
	       wBrwLine( Self:hWnd, Self:GetDC(), 0, Self:aHeaders, Self:GetColSizes(),;
			 Self:nColPos, Self:nClrForeHead, Self:nClrBackHead,;
			 If( Self:oFont != nil, Self:oFont:hFont, 0 ),.f.,;
			 Self:aJustify, nAtCol, Self:nLineStyle )
	       Self:ReleaseDC()
	       Eval( Self:aActions[ nAtCol ], Self, nRow, nCol )
	       wBrwLine( Self:hWnd, Self:GetDC(), 0, Self:aHeaders, Self:GetColSizes(),;
			 Self:nColPos, Self:nClrForeHead, Self:nClrBackHead,;
			 If( Self:oFont != nil, Self:oFont:hFont, 0 ),.f.,;
			 Self:aJustify,, Self:nLineStyle )
	       Self:ReleaseDC()
	    else
	       MsgBeep()
	    endif
      else
	 MsgBeep()
      endif
   endif

   if nClickRow > 0 .and. nClickRow != Self:nRowPos .and. ;
      nClickRow < Self:nRowCount() + 1
      Self:DrawLine()
      nSkipped  = Self:Skip( nClickRow - Self:nRowPos )
      Self:nRowPos += nSkipped
      if Self:oVScroll != nil
	 Self:oVScroll:SetPos( Self:oVScroll:GetPos() + nSkipped )
      endif
      if Self:lCellStyle
	   Self:nColAct := Self:nAtCol( nCol )
	   if Self:oHScroll != nil
	      Self:oHScroll:SetPos(Self:nColAct)
	   endif
      endif
      Self:DrawSelect()
      Self:lHitTop = .f.
      Self:lHitBottom = .f.
      if Self:bChange != nil
	 Eval( Self:bChange, Self )
      endif
   else
      if Self:lCellStyle
	   Self:nColAct := Self:nAtCol( nCol )
	   if Self:oHScroll != nil
	      Self:oHScroll:SetPos(Self:nColAct)
	   endif
	   Self:Refresh(.f.)
      endif
   endif

   Self:super:LButtonDown( nRow, nCol, nKeyFlags )

return 0

//----------------------------------------------------------------------------//

static function fw_LButtonUp( Self, nRow, nCol, nFlags )

   if Self:lDrag
      return Self:super:LButtonUp( nRow, nCol, nFlags )
   endif

   if Self:lCaptured
      Self:lCaptured = .f.
      ReleaseCapture()
      Self:VertLine()
   endif

   Self:super:LButtonUp( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

static function fw_Default(Self)

   local n, aFields
   local cAlias := Alias()
   local nElements, nTotal := 0

   DEFAULT Self:aHeaders := {}, Self:aColSizes := {}

   if Self:bLine == nil
      if Empty( Self:cAlias )
	 Self:cAlias = cAlias
      else
	 cAlias = Self:cAlias
      endif
      Self:bLine  = { || _aFields( Self ) }
      if Self:aJustify == nil
	 Self:aJustify = Array( nElements := Len( Eval( Self:bLine ) ) )
	 for n = 1 to nElements
	     Self:aJustify[ n ] = ( ValType( ( cAlias )->( FieldGet( n ) ) ) == "N" )
	 next
      endif
   endif

   DEFAULT nElements := Len( Eval( Self:bLine ) )

   if Len( Self:aHeaders ) < nElements              //  == nil
      if Self:Cargo == nil
	 Self:aHeaders = Array( nElements )
	 for n = 1 to nElements
	     Self:aHeaders[ n ] = ( cAlias )->( FieldName( n ) )
	 next
      else
	 Self:aHeaders = { "" }
      endif
   endif

   if Len( Self:GetColSizes() ) < nElements
      Self:aColSizes = Afill(Array( nElements ), 0 )
      aFields = Eval( Self:bLine )
      for n = 1 to nElements
	  Self:aColSizes[ n ] := If( ValType( aFields[ n ] ) != "C",;
				   15,; // Bitmap handle
				   GetTextWidth( 0, Replicate( "B", ;
				   Max( Len( Self:aHeaders[ n ] ), ;
					Len( aFields[ n ] ) ) + 1 ),;
				   If( ! Empty( Self:oFont ), Self:oFont:hFont,) ) )
      next
   endif

   /* ??????????????
   if lAnd( eval(Selector:GetWindowLong, Self:hWnd, GWL_STYLE ), WS_VSCROLL ) .or. ;
      GetClassName( Self:hWnd ) == "ListBox"
      DEFINE SCROLLBAR Self:oVScroll VERTICAL OF Self ;
	 RANGE Min( 1, Self:nLen := Eval( Self:bLogicLen ) ), Eval( Self:bLogicLen )
      Self:oVScroll:SetPage( Min( Self:nRowCount(), Self:nLen - 1 ) )
   endif

   if lAnd( eval(Selector:GetWindowLong, Self:hWnd, GWL_STYLE ), WS_HSCROLL )
      if Self:Cargo == nil // it is not a tree
	 DEFINE SCROLLBAR Self:oHScroll HORIZONTAL OF Self ;
	    RANGE 1, Len( Self:GetColSizes() )
	 AEval( Self:GetColSizes(), { | nSize | nTotal += nSize } )
	 Self:oHScroll:SetPage( nTotal / Self:nWidth() )
      endif
   endif
   */

   if Self:oFont == nil
      Self:oFont = Self:oWnd:oFont
   endif

   if Self:uValue1 != nil
      Eval( Self:bGoTop )
   endif
   if Self:bChange != nil
      Eval( Self:bChange, Self )
   endif

return nil

//---------------------------------------------------------------------------//

static function fw_KeyDown( Self, nKey, nFlags )

   do case
      case nKey == VK_UP
	   Self:GoUp()

      case nKey == VK_DOWN
	   Self:GoDown()

      case nKey == VK_LEFT
	   Self:GoLeft()

      case nKey == VK_RIGHT
	   Self:GoRight()

      case nKey == VK_HOME
	   Self:GoTop()

      case nKey == VK_END
	   Self:GoBottom()

      case nKey == VK_PRIOR
	   if eval(Selector:GetKeyState, VK_CONTROL )
	      Self:GoTop()
	   else
	      Self:PageUp()
	   endif

      case nKey == VK_NEXT
	   if eval(Selector:GetKeyState, VK_CONTROL )
	      Self:GoBottom()
	   else
	      Self:PageDown()
	   endif

      otherwise
	   return Self:super:KeyDown( nKey, nFlags )
   endcase

return 0

//----------------------------------------------------------------------------//

static function fw_KeyChar( Self, nKey, nFlags )

   do case
      case nKey == K_PGUP
	   Self:oVScroll:PageUp()

      case nKey == K_PGDN
	   Self:oVScroll:PageDown()

      otherwise
	   return Self:super:KeyChar( nKey, nFlags )
   endcase

return 0

//----------------------------------------------------------------------------//

static function fw_PageUp( Self, nLines )

   local nSkipped

   DEFAULT nLines := Self:nRowCount()

   nSkipped = Self:Skip( -nLines )

   if ( Self:nLen := Eval( Self:bLogicLen ) ) < 1
      return nil
   endif

   if ! Self:lHitTop
      if nSkipped == 0
	 Self:lHitTop = .t.
      else
	 Self:lHitBottom = .f.
	 if -nSkipped < nLines
	    Self:nRowPos = 1
	    if Self:oVScroll != nil
	       Self:oVScroll:SetPos( 1 )
	    endif
	 else

	    nSkipped = Self:Skip( -nLines )
	    Self:Skip( -nSkipped )

	    if Self:oVScroll != nil
	       Self:oVScroll:SetPos( Self:oVScroll:GetPos() + nSkipped )
	    endif

	 endif
	 Self:Refresh( .f. )
	 if Self:bChange != nil
	    Eval( Self:bChange, Self )
	 endif

      endif

      // Self:oVScroll:PageUp()

   else
      if Self:oVScroll != nil
	 Self:oVScroll:GoTop()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_PageDown( Self, nLines )

   local nSkipped, n

   DEFAULT nLines := Self:nRowCount()

   if ( Self:nLen := Eval( Self:bLogicLen ) ) < 1
      return nil
   endif

   if ! Self:lHitBottom
      Self:DrawLine()
      nSkipped = Self:Skip( ( nLines * 2 ) - Self:nRowPos )

      if nSkipped != 0
	 Self:lHitTop = .f.
      endif

      do case
	 case nSkipped == 0 .or. nSkipped < nLines
	      if nLines - Self:nRowPos < nSkipped
		 Self:GetDC()
		 Self:Skip( -( nLines ) )
		 for n = 1 to ( nLines - 1 )
		     Self:Skip( 1 )
		     Self:DrawLine( n )
		 next
		 Self:ReleaseDC()
		 Self:Skip( 1 )
	      endif
	      Self:nRowPos = Min( Self:nRowPos + nSkipped, nLines )
	      Self:lHitBottom = .t.
	      if Self:oVScroll != nil
		 Self:oVScroll:GoBottom()
	      endif

	 otherwise
	      Self:GetDC()
	      for n = nLines to 1 step -1
		  Self:DrawLine( n )
		  Self:Skip( -1 )
	      next
	      Self:ReleaseDC()
	      Self:Skip( Self:nRowPos )
      endcase
      Self:DrawSelect()
      if Self:bChange != nil
	 Eval( Self:bChange, Self )
      endif

      if Self:oVScroll != nil
	 if ! Self:lHitBottom
	    Self:oVScroll:SetPos( Self:oVScroll:GetPos() + nSkipped - ( nLines - Self:nRowPos ) )
	 else
	    Self:oVScroll:GoBottom()
	 endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_VScroll( Self, nWParam, nLParam )

   local nLines := Self:nRowCount()
   local nLen

   if eval(Selector:GetFocus) != Self:hWnd
      eval(Selector:SetFocus, Self:hWnd )
   endif

   do case
      case nWParam == SB_LINEUP
	   Self:GoUp()

      case nWParam == SB_LINEDOWN
	   Self:GoDown()

      case nWParam == SB_PAGEUP
	   Self:PageUp()

      case nWParam == SB_PAGEDOWN
	   Self:PageDown()

      case nWParam == SB_TOP
	   Self:GoTop()

      case nWParam == SB_BOTTOM
	   Self:GoBottom()

      case nWParam == SB_THUMBPOSITION
	   if ( Self:nLen := Eval( Self:bLogicLen ) ) < 1
	      return 0
	   endif

	   if nLParam == 0
	      Self:GoTop()
	   elseif nLParam == Self:oVScroll:GetRange()[ 2 ]
	      Self:GoBottom()
	   else
	      CursorWait()
	      Self:Skip( nLParam - Self:oVScroll:GetPos() )
	      Self:lHitTop = .f.
	      Self:lHitBottom = .f.
	      CursorArrow()
	   endif
	   Self:oVScroll:SetPos( nLParam )

	   nLen = Eval( Self:bLogicLen )
	   if nLParam - Self:oVScroll:nMin < nLines
	      Self:nRowPos = 1
	   endif
	   if Self:oVScroll:nMax - nLParam < Min( nLines, nLen )
	      Self:nRowPos = Min( nLines, nLen ) - ( Self:oVScroll:nMax - nLParam )
	   endif
	   Self:Refresh( .f. )
	   if Self:bChange != nil
	      Eval( Self:bChange, Self )
	   endif

      otherwise
	   return nil
   endcase

return 0

//----------------------------------------------------------------------------//

static function fw_HScroll( Self, nWParam, nLParam )

   local nCol := Self:nColPos

   if Self:oGet != nil .and. ! Empty( Self:oGet:hWnd )
      Self:oGet:End()
   endif

   do case
      case nWParam == SB_LINEUP
	   Self:GoLeft()

      case nWParam == SB_LINEDOWN
	   Self:GoRight()

      case nWParam == SB_PAGEUP
	   while Self:nColPos > 1 .and. ;
		(Self:IsColVisible( nCol ) .or. Self:nColPos == nCol)
	      Self:nColPos--
	   end
	   Self:nColAct := Self:nColPos
	   Self:oHScroll:SetPos( Self:nColAct )
	   Self:Refresh( .f. )

      case nWParam == SB_PAGEDOWN
	   while nCol < Len( Self:GetColSizes() ) .and. ;
		(Self:IsColVisible( nCol ) .or. Self:nColPos == nCol)
	      nCol++
	   end
	   Self:nColPos := nCol
	   Self:nColAct := nCol
	   Self:oHScroll:SetPos( nCol )
	   Self:Refresh( .f. )

      case nWParam == SB_TOP
	   Self:nColPos = 1
	   Self:nColAct = 1
	   Self:oHScroll:SetPos( 1 )
	   Self:Refresh( .f. )

      case nWParam == SB_BOTTOM
	   Self:nColPos = Len( Self:GetColSizes() )
	   Self:nColAct = Self:nColPos
	   Self:oHScroll:SetPos( Self:nColPos )
	   Self:Refresh( .f. )

      case nWParam == SB_THUMBPOSITION
	   Self:nColPos = nLParam
	   Self:nColAct = Self:nColPos
	   Self:oHScroll:SetPos( nLParam )
	   Self:Refresh( .f. )

      otherwise
	   return nil
   endcase

return 0

//----------------------------------------------------------------------------//

static function fw_Skip( Self, n )

   if Self:bSkip != nil
      return Eval( Self:bSkip, n )
   endif

return ( Self:cAlias )->( _DBSkipper( n ) )

//----------------------------------------------------------------------------//

static function BrwGoBottom( Self, uExpr )

   local lSoftSeek := Set( _SET_SOFTSEEK, .t. )

   if ValType( uExpr ) == "C"
      DbSeek( SubStr( uExpr, 1, Len( uExpr ) - 1 ) + ;
	      Chr( Asc( SubStr( uExpr, Len( uExpr ) ) ) + 1 ) )
   else
      DbSeek( uExpr + 1 )
   endif
   DbSkip( -1 )

   Set( _SET_SOFTSEEK, lSoftSeek )

return nil

//----------------------------------------------------------------------------//

// To simulate Filters using INDEXES         -they go extremely fast!-

static function BuildSkip( cAlias, cField, uValue1, uValue2 )

   local bSkipBlock
   local cType := ValType( uValue1 )

   do case
      case cType == "C"
	   bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
	   &( "{||" + cField + ">= '" + uValue1 + "' .and." + ;
	   cField + "<= '" + uValue2 + "' }" ) ) ) }

      case cType == "D"
	   bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
	   &( "{||" + cField + ">= CToD( '" + DToC( uValue1 ) + "') .and." + ;
	    cField + "<= CToD( '" + DToC( uValue2 ) + "') }" ) ) ) }

      case cType == "N"
	   bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
	   &( "{||" + cField + ">= " + cValToChar( uValue1 ) + " .and." + ;
	   cField + "<= " + cValToChar( uValue2 ) + " }" ) ) ) }

      case cType == "L"
	   bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
	   &( "{||" + cField + ">= " + cValToChar( uValue1 ) + " .and." + ;
	   cField + "<= " + cValToChar( uValue2 ) + " }" ) ) ) }
   endcase

return bSkipBlock

//----------------------------------------------------------------------------//

static function BrwGoTo( n, bWhile )

   local nSkipped := 0, nDirection := If( n > 0, 1, -1 )

   while nSkipped != n .and. Eval( bWhile ) .and. ! EoF() .and. ! BoF()
      DbSkip( nDirection )
      nSkipped += nDirection
   enddo

   do case
      case EoF()
	 DbSkip( -1 )
	 nSkipped += -nDirection

      case BoF()
	 DbGoTo( RecNo() )
	 nSkipped++

      case ! Eval( bWhile )
	 DbSkip( -nDirection )
	 nSkipped += -nDirection
   endcase

return nSkipped

//----------------------------------------------------------------------------//
// Many thanks to Kathy Hayes

static function fw_RecCount( Self, uSeekValue )

   local nRecNo := ( Self:cAlias )->( RecNo() )
   local nRecs  := 1
   local bField := &( "{ || " + Self:cField + "}" )

   if .not. ( Self:cAlias )->( DbSeek( uSeekValue, .t. ) )
      if ( Self:cAlias )->( Eval( bField ) ) > Self:uValue2 ;
	 .or. ( Self:cAlias )->( EoF() )
	 nRecs := 0
      endif
   endif

   // When Filters show a lot of records, the application
   // may loose a lot of time counting. nMaxFilter controls this
   if Self:nMaxFilter == nil
      while Self:Skip( 1 ) == 1
	 nRecs++
      end
   else
      while Self:Skip( 1 ) == 1 .and. nRecs < Self:nMaxFilter
	 nRecs++
      end
   endif

   ( Self:cAlias )->( DbGoTo( nRecNo ) )

return nRecs

//----------------------------------------------------------------------------//

static function GenLocal( aArray, nPos )

return { || If( nPos <= Len( aArray ), aArray[ nPos ], "  " ) }

static function GenBlock( bLine, nPos ) ;  return { || Eval( bLine )[ nPos ] }

//----------------------------------------------------------------------------//

static function fw_Report( Self, cTitle, lPreview )

   local oRpt
   local nRecNo := If( Upper( Self:cAlias ) != "ARRAY", ( Self:cAlias )->( RecNo() ), 0 )
   local aData  := Eval( Self:bLine )
   local n
   local nCharWidth

   nCharWidth := GetTextWidth( 0, "B", If( Self:oFont != nil, Self:oFont:hFont, 0 ))

   DEFAULT cTitle := Self:oWnd:cTitle, lPreview := .t.

   Eval( Self:bGoTop )

   if lPreview
      REPORT oRpt TITLE cTitle PREVIEW ;
	 HEADER "Date: " + DToC( Date() ) + ", Time: " + Time() ;
	 FOOTER "Page: " + Str( oRpt:nPage, 3 )
   else

      REPORT oRpt TITLE cTitle ;
	 HEADER "Date: " + DToC( Date() ) + ", Time: " + Time() ;
	 FOOTER "Page: " + Str( oRpt:nPage, 3 )

   endif

   if Self:aColSizes == nil
      Self:aColSizes = Array( Len( aData ) )
      for n = 1 to Len( aData )
	 Self:aColSizes[ n ] = 80
      next
   else
      if Len( Self:aColSizes ) < Len( aData )
	 n = Len( Self:aColSizes )
	 while n++ < Len( aData )
	    AAdd( Self:aColSizes, 80 )
	 end
      endif
   endif

   for n = 1 to Len( aData )
      if ValType( aData[ n ] ) != "N"
	 oRpt:AddColumn( TrColumn():New( { GenLocal( Self:aHeaders, n ) },,;
			 { GenBlock( Self:bLine, n ) },;
			 Int( Self:aColSizes[ n ]/ nCharWidth ),,,,,,,,, oRpt ) )
      else
	 oRpt:AddColumn( TrColumn():New( { GenLocal( Self:aHeaders, n ) },,;
			 { { || "   " } },;
			 Int( Self:aColSizes[ n ] / nCharWidth ),,,,,,,,, oRpt ) )
      endif
   next
   ENDREPORT

   oRpt:bSkip = { || oRpt:Cargo := Self:Skip( 1 ) }
   oRpt:Cargo = 1

   ACTIVATE REPORT oRpt ;
      WHILE If( Upper( Self:cAlias ) == "ARRAY",;
		oRpt:nCounter < Eval( Self:bLogicLen ),;
		oRpt:Cargo == 1 )

   if Upper( Self:cAlias ) != "ARRAY"
      ( Self:cAlias )->( DbGoTo( nRecNo ) )
   endif
   Self:Refresh()

return nil

//----------------------------------------------------------------------------//

static function fw_UpStable(Self)

   local nRow   := Self:nRowPos
   local nRecNo := ( Self:cAlias )->( RecNo() )
   local nRows  := Self:nRowCount()
   local n      := 1
   local lSkip  := .t.

   Self:nRowPos    = 1
   Self:GoTop()
   Self:lHitTop    = .f.
   Self:lHitBottom = .f.

   while ! ( Self:cAlias )->( EoF() )
      if n > nRows
	 ( Self:cAlias )->( DbGoTo( nRecNo ) )
	 Self:nRowPos = nRow
	 lSkip     = .f.
	 exit
      endif
      if nRecNo == ( Self:cAlias )->( RecNo() )
	 Self:nRowPos = n
	 exit
      else
	 ( Self:cAlias )->( DbSkip() )
      endif
      n++
   end

   if lSkip
      ( Self:cAlias )->( DbSkip( -Self:nRowPos ) )
   endif

   if Self:bChange != nil
      Eval( Self:bChange, Self )
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_SetFilter( Self, cField, uVal1, uVal2 )

   local cIndexType

   DEFAULT uVal2 := uVal1

   Self:cField     = cField
   Self:uValue1    = uVal1
   Self:uValue2    = uVal2

   if uVal1 != nil
      cIndexType := ( Self:cAlias )->( ValType( &( IndexKey() ) ) )
      if ( Self:cAlias )->( ValType( &cField ) ) != cIndexType .or. ;
	 ValType( uVal1 ) != cIndexType .or. ;
	 ValType( uVal2 ) != cIndexType
	 MsgAlert( "TWBrowse SetFilter() types don't match with current Index Key type!" )
      endif
   endif

   // Posibility of using FILTERs based on INDEXES!!!

   if ! Empty( Self:cAlias )

      Self:bGoTop     = If( uVal1 != nil, { || ( Self:cAlias )->( DbSeek( uVal1, .t. ) ) },;
				    { || ( Self:cAlias )->( DbGoTop() ) } )

      Self:bGoBottom  = If( uVal2 != nil, { || ( Self:cAlias )->( BrwGoBottom( uVal2 ) ) },;
				    { || ( Self:cAlias )->( DbGoBottom() ) } )

      Self:bSkip      = If( uVal1 != nil, BuildSkip( Self:cAlias, cField, uVal1, uVal2 ),;
		      { | n | ( Self:cAlias )->( _DbSkipper( n ) ) } )

      Self:bLogicLen  = If( uVal1 != nil,;
		      { || ( Self:cAlias )->( Self:RecCount( uVal1 ) ) },;
		      { || ( Self:cAlias )->( RecCount() ) } )

      Self:nLen       = Eval( Self:bLogicLen )

      Self:lHitTop    = .f.
      Self:lHitBottom = .f.

      if uVal1 != nil
	 Eval( Self:bGoTop )
      endif
   else
      Self:bLogiclen = { || 0 }
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_MouseMove( Self, nRow, nCol, nKeyFlags )

   local nColPos := 0

   if Self:lDrag
      return Self:super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   if Self:lCaptured
      CursorWE()
      Self:VertLine( nCol )
      return 0
   endif

   if Self:lMChange .and. AScan( Self:GetColSizes(),;
	      { | nColumn | nColPos += nColumn,;
			    nCol >= nColPos - 1 .and. ;
			    nCol <= nColPos + 1 }, Self:nColPos ) != 0
      CursorWE()
   else
      Self:super:MouseMove( nRow, nCol, nKeyFlags )
   endif

return 0

//----------------------------------------------------------------------------//

static function fw_VertLine( Self, nColPos, nColInit )

   local oRect, aSizes, nFor

   static nCol, nWidth, nMin, nOldPos := 0

   if nColInit != nil
      nCol    = nColInit
      nWidth  = nColPos
      nOldPos = 0
      nMin := 0
      aSizes := Self:GetColSizes()

      FOR nFor := Self:nColPos TO nColInit - 1
	  nMin += aSizes[nFor]
      NEXT

      nMin += 5
   endif

   if nColPos == nil .and. nColInit == nil   // We have finish draging
      Self:aColSizes[ nCol ] -= ( nWidth - nOldPos )
      Self:Refresh()
   endif

   if nColPos != nil
     nColPos := Max(nColPos, nMin)
   endif

   oRect = Self:GetRect()
   Self:GetDC()
   if nOldPos != 0
      InvertRect( Self:hDC, { 0, nOldPos - 2, oRect:nBottom, nOldPos + 2 } )
      nOldPos = 0
   endif
   if nColPos != nil .and. ( nColPos - 2 ) > 0
      InvertRect( Self:hDC, { 0, nColPos - 2, oRect:nBottom, nColPos + 2 } )
      nOldPos = nColPos
   endif
   Self:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

static function fw_nAtCol( Self, nColPixel )

   local nColumn := Self:nColPos - 1
   local aSizes  := Self:GetColSizes()
   local nPos    := 0

   DEFAULT nColPixel := 0

   while nPos < nColPixel .and. nColumn < Len( aSizes )
      nPos += aSizes[ nColumn + 1 ]
      nColumn++
   end

return nColumn

//----------------------------------------------------------------------------//

static function fw_nAtIcon( Self, nRow, nCol )

   local nIconsByRow := Int( Self:nWidth() / 50 )

   nRow -= 9
   nCol -= 1

   if ( nCol % 50 ) >= 9 .and. ( nCol % 50 ) <= 41
      return Int( ( nIconsByRow * Int( nRow / 50 ) ) + Int( nCol / 50 ) ) + 1
   else
      return 0
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_Display(Self)

   local nRecs

   Self:BeginPaint()
   if Self:oVScroll != nil   // They generate WM_PAINT msgs when range 0
      nRecs := Eval( Self:bLogicLen )
      if Self:oVScroll:nMax != nRecs .or. nRecs != Self:nLen
	 Self:oVScroll:SetRange( 1, Self:nLen := nRecs )
	 Self:oVScroll:SetPage( Min( Self:nRowCount(), Self:nLen - 1 ), .t. )
      endif
   endif                  // so here we avoid 'flicking'
   if Self:oHScroll != nil
      Self:oHScroll:SetRange( 1, Len( Self:GetColSizes() ) )
   endif
   Self:Paint()
   Self:EndPaint()

return 0

//----------------------------------------------------------------------------//

static function fw_GetDlgCode( Self, nLastKey )

   // This function is very similar to TControl:GetDlgCode() but it is
   // necessary to have WHEN working

   if .not. Self:oWnd:lValidating
      if nLastKey == VK_UP .or. nLastKey == VK_DOWN ;
	 .or. nLastKey == VK_RETURN .or. nLastKey == VK_TAB
	 Self:oWnd:nLastKey = nLastKey
      else
	 Self:oWnd:nLastKey = 0
      endif
   endif

return If( IsWindowEnabled( Self:hWnd ), DLGC_WANTALLKEYS, 0 )

//----------------------------------------------------------------------------//

function _aFields( Self )

   local aFld, aSizes, cAlias := Self:cAlias
   local nCols, nFirstCol, nLastCol, nWidth, nBrwWidth
   local uVal

   if Empty( cAlias )
      return {}
   endif

   if Len( Self:aColSizes ) == 0
      return Array( ( cAlias )->( Fcount() ) )
   endif

  aSizes    = Self:aColSizes
  nCols     = Len( aSizes )
  nFirstCol = Self:nColPos
  nLastCol  = nFirstCol
  nWidth    = 0
  nBrwWidth = Self:nWidth()
  aFld      = Array( nCols )

  AFill( aFld, "" ) // , 1, nFirstCol - 1 )

  while nWidth < nBrwWidth .and. nLastCol <= nCols
     nWidth += aSizes[ nLastCol ]
     if ValType( ( cAlias )->( FieldGet( nLastCol ) ) ) == "M"
	aFld[ nLastCol ] = If( ! Empty( ( cAlias )->( ;
	      FieldGet( nLastCol ) ) ), "<Memo>", "<memo>" )
	nLastCol++   // Keep this here! XBase+ and Clipper difference!!!
     else
	aFld[ nLastCol ] = cValToChar( ( cAlias )->( FieldGet( nLastCol ) ) )
	nLastCol++   // Keep this here! XBase+ and Clipper difference!!!
     endif
  end

return aFld

//----------------------------------------------------------------------------//

static function fw_SetCols( Self, aData, aHeaders, aColSizes )

   local aFields
   local nElements, n

   nElements   := Len( aData )

   Self:aHeaders  := If( aHeaders  != nil, aHeaders, Self:aHeaders )
   Self:aColSizes := If( aColSizes != nil, aColSizes, {} )
   Self:bLine     := {|| _aData( aData ) }
   Self:aJustify  := AFill( Array( nElements ), .F. )

   if Len( Self:GetColSizes() ) < nElements
      Self:aColSizes = AFill( Array( nElements ), 0 )
      aFields = Eval( Self:bLine )
      for n = 1 to nElements
	  Self:aColSizes[ n ] := If( ValType( aFields[ n ] ) != "C",;
				   15,; // Bitmap handle
				   GetTextWidth( 0, Replicate( "B", ;
				   Max( Len( Self:aHeaders[ n ] ), ;
					Len( aFields[ n ] ) ) + 1 ),;
				   If( ! Empty( Self:oFont ), Self:oFont:hFont,) ) )
      next
   endif

   if Self:oHScroll != nil
      Self:oHScroll:nMax := Self:GetColSizes()
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_ShowSizes(Self)

   local cText := ""

   AEval( Self:aColSizes,;
	  { | v,e | cText += Self:aHeaders[ e ] + ": " + Str( v, 3 ) + CRLF } )

   MsgInfo( cText )

return nil

//----------------------------------------------------------------------------//

static function fw_DrawIcon( Self, nIcon, lFocused )

   local nIconsByRow := Int( Self:nWidth() / 50 )
   local nRow := Int( --nIcon / nIconsByRow )
   local nCol := If( nRow > 0, nIcon % ( nRow * nIconsByRow ), nIcon )

   DEFAULT lFocused := .f.

   if lFocused
      DrawIconFocus( Self:GetDC(), ( nRow * 50 ) + 10, ( nCol * 50 ) + 10,;
		     ExtractIcon( "user.exe" ) )
   else
      DrawIcon( Self:GetDC(), ( nRow * 50 ) + 10, ( nCol * 50 ) + 10,;
		ExtractIcon( "user.exe" ) )
   endif

return nil

//----------------------------------------------------------------------------//

static function fw_IsColVisible( Self, nCol )

   local nCols, nFirstCol, nLastCol, nWidth, nBrwWidth

   nCols     := Len( Self:GetColSizes() )
   nFirstCol := Self:nColPos
   nLastCol  := nFirstCol
   nWidth    := 0
   nBrwWidth := Self:nWidth - If( Self:oVScroll != nil, 16, 0 )

   if nCol < nFirstCol
      return .f.
   endif

   while nWidth < nBrwWidth .and. nLastCol <= nCol
      nWidth += Self:GetColSizes()[ nLastCol ]
      nLastCol++
   end

   if nCol <= --nLastCol

      // La columna es solo visible en parte por ser muy larga
      if nWidth > nBrwWidth
	  return .f.
      endif

      return .t.

   endif

return .F.

//----------------------------------------------------------------------------//

static function _aData( aFields )

  local aFld
  local nFor, nLen

  nLen = Len( aFields )
  aFld = Array( nLen )

  for nFor = 1 to nLen
     aFld[ nFor ] = Eval( aFields[ nFor ] )
  next

return aFld

//----------------------------------------------------------------------------//

