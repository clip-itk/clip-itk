/*   FiveWin likely classes					*/
/*   TScrollBar							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include <fwin/FiveWin.ch>
#include <fwin/constant.ch>

#define SB_HORZ         0
#define SB_VERT         1
#define SB_CTL          2

#define COLOR_SCROLLBAR 0
#define COLOR_WINDOW    5

static Selector := GetSelector()

function TScrollBar()
local obj := InHerit( TControl() )

	obj:className	:= "FWIN_TSCROLLBAR"
	obj:lVertical	:= .f.
	obj:lReDraw	:= .f.
	obj:lIsChild	:= .f.
	obj:nMin	:= 0
	obj:nMax	:= 0
	obj:nPgStep	:= 0
	obj:bGoUp	:= NIL
	obj:bGoDown	:= NIL
	obj:bGoTop	:= NIL
	obj:bGoBottom	:= NIL
	obj:bPageUp	:= NIL
	obj:bPageDown	:= NIL
	obj:bPos	:= NIL
	obj:bTrack	:= NIL
	obj:aProperties := { "cVarName", "nMin", "nMax",;
			     "nPgStep", "nTop", "nLeft", "Cargo" }

	_recover_FWIN_TSCROLLBAR(obj)

return obj

function _recover_FWIN_TSCROLLBAR(obj)


	obj:new		:= @fw_new()
	obj:WinNew	:= @fw_WinNew()
	obj:ReDefine	:= @fw_ReDefine()
	obj:cToChar	:= {| self | self:cToChar( "SCROLLBAR" ) }
	obj:GetPos	:= {| self | eval(Selector:GetScrollPos, If( self:lIsChild, self:oWnd:hWnd, self:hWnd ),;
				If( self:lIsChild, If( self:lVertical, SB_VERT, SB_HORZ ), SB_CTL ) )}
	obj:GetRange	:= {| self | eval(Selector:GetScrollRange, If( self:lIsChild, self:oWnd:hWnd, self:hWnd ),;
				If( self:lIsChild, If( self:lVertical, SB_VERT, SB_HORZ ), SB_CTL ) )}
	obj:HandleEvent	:= @fw_HandleEvent()
	obj:Initiate	:= {| self, hDlg |  self:self:super:Initiate( hDlg ), ;
			       self:SetRange( self:nMin, self:nMax ),;
			       self:SetPos( self:nMin )}

	// These two have to be BLOCK
	obj:GoUp	:= { | Self, nPos | nPos := self:GetPos(),;
					  if( nPos > self:GetRange()[ 1 ],;
					      self:SetPos( --nPos ), ),;
				If( self:bGoUp != nil, Eval( self:bGoUp ),) }
	obj:GoDown	:= { | Self, nPos | nPos := self:GetPos(),;
					  if( nPos < self:nMax,;
					      self:SetPos( ++nPos ), ),;
				If( self:bGoDown != nil, Eval( self:bGoDown ),) }
	obj:GoTop	:= {| self | self:SetPos( self:nMin ),;
				If( self:bGoTop != nil, Eval( self:bGoTop ),)}
	obj:GoBottom	:= {| self | self:SetPos( self:nMax ),;
				If( self:bGoBottom != nil, Eval( self:bGoBottom ),)}
	obj:PageUp	:= {| self | If( self:bPageUp != nil, Eval( self:bPageUp ),),;
				self:SetPos( self:GetPos() - self:nPgStep )}
	obj:PageDown	:= {| self | If( self:bPageDown != nil, Eval( self:bPageDown ),),;
				self:SetPos( self:GetPos() + self:nPgStep )}
	obj:SetPage	:= @fw_SetPage()
	obj:SetPos	:= {| self, nPos | ;
				eval(Selector:SetScrollPos, if( self:lIsChild, self:oWnd:hWnd, self:hWnd ),;
				If( self:lIsChild, If( self:lVertical, SB_VERT, SB_HORZ ), SB_CTL ),;
				nPos, self:lReDraw )}
	obj:SetRange	:= {| self, nMin, nMax | ;
				self:nMin := nMin, self:nMax := nMax, ;
				eval(Selector:SetScrollRange, if( self:lIsChild, self:oWnd:hWnd, self:hWnd ), ;
				if( self:lIsChild, If( self:lVertical, SB_VERT, SB_HORZ ), SB_CTL ), ;
				nMin, nMax, self:lReDraw )}
	obj:ThumbPos	:= {| self, nPos | If( self:bPos != nil, Eval( self:bPos, nPos ),)}
	obj:MouseMove	:= {|| }
	obj:ThumbTrack	:= {| self, nPos | If( self:bTrack != nil, Eval( self:bTrack, nPos ),)}

return obj

//----------------------------------------------------------------------------//

static function fw_New( self, nRow, nCol, nMin, nMax, nPgStep, lVertical, oWnd, nWidth, nHeight,;
	    bUpAct, bDownAct, bPgUp, bPgDown, bPos, lPixel, nClrText,;
	    nClrBack, cMsg, lUpdate, bWhen, bValid, lDesign )

   DEFAULT nRow := 0, nCol := 0,;
	   nMin := 0, nMax := 0, nPgStep := 1,;
	   oWnd := GetWndDefault(),;
	   lVertical := .t., nWidth := If( lVertical, 16, 100 ),;
	   nHeight   := If( lVertical, 100, 17 ),;
	   lPixel    := .f.,;
	   nClrText  := GetSysColor( COLOR_WINDOW ),;
	   nClrBack  := GetSysColor( COLOR_SCROLLBAR ),;
	   lUpdate   := .f., lDesign := .f.

   self:cCaption   = ""
   self:nTop       = nRow * If( lPixel, 1, SCRL_CHARPIX_H ) //14
   self:nLeft      = nCol * If( lPixel, 1, SCRL_CHARPIX_W )	// 8
   self:nBottom    = self:nTop + nHeight - 1
   self:nRight     = self:nLeft + nWidth - 1
   self:nWidth 	   = self:nRight - self:nLeft + 1
   self:nHeight    = self:nBottom - self:nTop + 1
   self:nMin       = nMin
   self:nMax       = nMax
   self:nPgStep    = nPgStep
   self:lVertical  = lVertical
   self:lReDraw    = .t.
   self:nStyle     = numOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP,;
		       If( lVertical, SBS_VERT, SBS_HORZ ),;
		       If( lDesign, WS_CLIPSIBLINGS, 0 ) )
   self:bGoUp      = bUpAct
   self:bGoDown    = bDownAct
   self:bPageUp    = bPgUp
   self:bPageDown  = bPgDown
   self:bPos       = bPos
   self:oWnd       = oWnd
   self:lIsChild   = .f.
   self:lDrag      = lDesign
   self:lCaptured  = .f.
   self:cMsg       = cMsg
   self:lUpdate    = lUpdate
   self:bWhen      = bWhen
   self:bValid     = bValid


   if ! Empty( oWnd:hWnd )
      eval(Selector:CreateScrollBar,self)
      self:SetRange( self:nMin, self:nMax )
      self:SetPos( self:nMin )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   self:SetColor( nClrText, nClrBack )

   if lDesign
      self:CheckDots()
   endif

return Self

//---------------------------------------------------------------------------//

// Constructor for non-true ScrollBar Controls
// ( when using WS_VSCROLL, WS_HSCROLL styles in a Window )
// They are NOT controls but we consider them as real Objects!

static function fw_WinNew( self, nMin, nMax, nPgStep, lVertical, oWnd, bUpAction,;
	       bDownAction, bPgUp, bPgDown, bPos, nClrText, nClrBack,;
	       lUpdate, bWhen, bValid )

   DEFAULT nMin := 1, nMax := 2, nPgStep := 1, lVertical := .t.,;
	   nClrText  := GetSysColor( COLOR_WINDOW ),;
	   nClrBack  := GetSysColor( COLOR_SCROLLBAR ),;
	   lUpdate   := .f.

   self:oWnd      = oWnd
   self:lVertical = lVertical
   self:lReDraw   = .t.
   self:lIsChild  = .t.
   self:nMin      = nMin
   self:nMax      = nMax
   self:nPgStep   = nPgStep
   self:bGoUp     = bUpAction
   self:bGoDown   = bDownAction
   self:bPageUp   = bPgUp
   self:bPageDown = bPgDown
   self:bPos      = bPos
   self:lUpdate   = lUpdate
   self:bWhen     = bWhen
   self:bValid    = bValid
   self:hWnd      = 0

   self:SetColor( nClrText, nClrBack )
   self:SetRange( nMin, nMax )
   self:SetPos( nMin )

return Self

//----------------------------------------------------------------------------//

static function fw_Redefine( self, nID, nMin, nMax, nPgStep, oWnd, bUpAction, bDownAction, ;
		 bPgUp, bPgDown, bPos, nClrText, nClrBack, cMsg,;
		 lUpdate, bWhen, bValid )

   DEFAULT nMin := 0, nMax := 0, nPgStep := 1,;
	   nClrText  := GetSysColor( COLOR_WINDOW ),;
	   nClrBack  := GetSysColor( COLOR_SCROLLBAR ),;
	   lUpdate   := .f.

   self:nID        = nID
   self:nMin       = nMin
   self:nMax       = nMax
   self:nPgStep    = nPgStep
   self:lVertical  = .f.
   self:lReDraw    = .t.
   self:bGoUp      = bUpAction
   self:bGoDown    = bDownAction
   self:bPageUp    = bPgUp
   self:bPageDown  = bPgDown
   self:bPos       = bPos
   self:oWnd       = oWnd
   self:lIsChild   = .f. // .t. only for Windows with WS_HSCROLL × WS_VSCROLL style
   self:lRedraw    = .t.
   self:oWnd       = oWnd
   self:lDrag      = .f.
   self:lCaptured  = .f.
   self:cMsg       = cMsg
   self:lUpdate    = lUpdate
   self:bWhen      = bWhen
   self:bValid     = bValid

   self:SetColor( nClrText, nClrBack )
   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

static function fw_HandleEvent( self, nMsg, nWParam, nLParam )

   do case
      case nMsg == FM_SCROLLUP
	   self:GoUp()
	   return 0

      case nMsg == FM_SCROLLDOWN
	   self:GoDown()
	   return 0

      case nMsg == FM_SCROLLPGUP
	   self:PageUp()
	   return 0

      case nMsg == FM_SCROLLPGDN
	   self:PageDown()
	   return 0

      case nMsg == FM_THUMBPOS
	   self:ThumbPos( nWParam )
	   return 0

      case nMsg == FM_THUMBTRACK
	   self:ThumbTrack( nWParam )
	   return 0
   endcase

return self:super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

static function fw_MouseMove( self, nRow, nCol, nKeyFlags )

   local nResult := self:super:MouseMove( nRow, nCol, nKeyFlags )

return If( self:lDrag, nResult, nil )    // We want standard behavior !!!

//----------------------------------------------------------------------------//

static function fw_SetPage( self, nSize, lReDraw )

/*
   local nFlags

   DEFAULT lRedraw := .f.

   if ! Empty( self:hWnd )
      nFlags = SB_CTL
   else
      if self:lVertical
	 nFlags = SB_VERT
      else
	 nFlags = SB_HORZ
      endif
   endif
   SetScrollInfo( If( ! Empty( self:hWnd ), self:hWnd, self:oWnd:hWnd ),;
		  nFlags, nSize, lReDraw )
*/

return nil

//----------------------------------------------------------------------------//
