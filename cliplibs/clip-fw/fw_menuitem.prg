/*   FiveWin likely classes					*/
/*   TMenuItem							*/
/*   Copyright (C) 2002  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include "fwin/FiveWin.ch"

#define MF_BYCOMMAND  0
#define MF_ENABLED    0
#define MF_UNCHECKED  0
#define MF_GRAYED     1
#define MF_DISABLED   2
#define MF_CHECKED    8
#define MF_POPUP     16   // 0x0010
#define MF_BREAK     64
#define MF_HELP   16384   // 0x4000

static Selector := GetSelector()

function TMenuItem()
local obj := map()

	obj:ClassName	:= "FWIN_TMENUITEM"
	obj:cPrompt	:= ""
	obj:cMsg	:= ""
	obj:cVarName	:= ""
	obj:nId		:= NIL
	obj:nHelpId	:= NIL
	obj:bAction	:= NIL
	obj:bWhen	:= NIL
	obj:cWebAction	:= NIL
	obj:lActive	:= .t.
	obj:lBreak	:= .f.
	obj:lChecked	:= .f.
	obj:lHelp	:= .f.
	obj:oMenu	:= NIL
	obj:hBitmap	:= NIL
	obj:nInitId	:= 20000  // To avoid conflicts with MDI automatic MenuItems
	obj:aProperties	:= { "cCaption", "cMsg", "cVarName", "lActive", "lBreak",;
				"lChecked", "nId" }

	obj:aEvents	:= { "OnActivate", "OnClick" }
	obj:nVKState	:= NIL // Accelerator values
	obj:nVirtKey  	:= NIL // Accelerator values

	_recover_FWIN_TMENUITEM(obj)
return obj
****************
function _recover_FWIN_TMENUITEM(obj)

	obj:New		:= @fw_New()
	obj:ReDefine	:= @fw_ReDefine()
	obj:cCaption	:= {|| nil}//BSETGET
	obj:SetCheck	:= {| self, lOnOff | ;
				self:lChecked := lOnOff, eval(Selector:CheckMenuItem, self:oMenu:hMenu,;
				self:nId, numOR( MF_BYCOMMAND, If( lOnOff, MF_CHECKED, MF_UNCHECKED ) ) )}
	obj:Enable	:= {| self | self:lActive := .t.,;
				eval(Selector:EnableMenuItem, self:oMenu:hMenu, self:nId, MF_ENABLED ),;
				If( ValType( self:bAction ) == "O", self:bAction:Enable(),)}
//   MESSAGE HelpTopic METHOD __HelpTopic()

	obj:Disable	:= {| self | self:lActive := .f.,;
				eval(Selector:EnableMenuItem, self:oMenu:hMenu, self:nId, numOR( MF_DISABLED, MF_GRAYED ) ),;
				If( ValType( self:bAction ) == "O", self:bAction:Disable(),)}
	obj:End		:= {| self | If( self:hBitmap != 0, DeleteObject( self:hBitmap ),)}
	obj:SetPrompt	:= @fw_SetPrompt()
	obj:PropCount	:= {| self | Len( self:aProperties )}
	obj:EveCount	:= {| self | Len( self:aEvents )}
	obj:Inspect	:= {| self, cDataName | }// VIRTUAL
	obj:Property	:= {| self, n | self:aProperties[ n ]}
	obj:Event	:= {| self, n | self:aEvents[ n ]}
	//obj:Destroy	:= @fw_Destroy()
	obj:Save	:= @fw_Save()
	obj:Load	:= @fw_Load()
	obj:Refresh	:= {|| }// VIRTUAL

return obj

//----------------------------------------------------------------------------//

static function fw_New( self, cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile, cResName,;
	    nVKState, nVirtKey, lHelp, nHelpId, bWhen, lBreak )

   DEFAULT lChecked := .f., lActive := .t., cBmpFile := "",;
	   lHelp := .f., lBreak := .f.

   self:bAction  = bAction
   self:cPrompt  = cPrompt
   self:cMsg     = cMsg
   self:lChecked = lChecked
   self:lActive  = lActive
   self:lHelp    = lHelp
   self:lBreak   = lBreak
   self:hBitmap  = 0
   self:nHelpId  = nHelpId
   self:bWhen    = bWhen

/*
   while eval(Selector:IsMenu, self:nInitId )   // A popup could already own the ID !!!
      self:nInitId++
   end
   self:nId = self:nInitId++
*/

   if ! Empty( cBmpFile ) .and. File( cBmpFile )
      self:hBitmap = eval(Selector:ReadBitmap, 0, cBmpFile )
   endif
   if ! Empty( cResName )
      self:hBitmap = eval(Selector:LoadBitmap, eval(Selector:GetResources), cResName )
   endif

   if nVirtKey != nil
      self:nVKState = nVKState
      self:nVirtKey = nVirtKey
   endif

return Self

//----------------------------------------------------------------------------//

static function fw_ReDefine( self, cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile,;
		 cResName, oMenu, bBlockAction, nId, nVKState,;
		 nVirtKey, nHelpId, bWhen )

   local oItem

   DEFAULT oMenu := self:oMenu

   if oMenu != nil
      if ( oItem := oMenu:GetMenuItem( nId ) ) != nil
	 self:bAction  = oItem:bAction
	 self:cPrompt  = oItem:cPrompt
	 self:cMsg     = oItem:cMsg
	 self:nId      = oItem:nId
	 self:lChecked = oItem:lChecked
	 self:lActive  = oItem:lActive
	 self:lBreak   = oItem:lBreak
	 self:lHelp    = oItem:lHelp
	 self:hBitmap  = oItem:hBitmap
	 self:nHelpId  = oItem:nHelpId
	 self:oMenu    = oItem:oMenu
	 self:bWhen    = oItem:bWhen
      endif
   endif

   if lChecked != nil
      if lChecked != self:lChecked
	 self:lChecked = lChecked
	 if oMenu != nil .and. nId != nil
	    eval(Selector:CheckMenuItem, oMenu:hMenu, nId, numOr( MF_BYCOMMAND,;
			   If( lChecked, MF_CHECKED, MF_UNCHECKED ) ) )
	 endif
      endif
   endif

   if lActive != nil
      if lActive != self:lActive
	 self:lActive = lActive
	 if oMenu != nil .and. nId != nil
	    eval(Selector:EnableMenuItem, oMenu:hMenu, nId, numOr( MF_BYCOMMAND,;
			    If( lActive, MF_ENABLED,;
			    numOr( MF_DISABLED, MF_GRAYED ) ) ) )
	 endif
      endif
   endif

   if ! Empty( cPrompt )
      self:SetPrompt( cPrompt )
   endif

   if cMsg != nil
      self:cMsg = cMsg
   endif

   if bAction != nil
      self:bAction = bAction
   endif

   if oMenu != nil
      self:oMenu = oMenu
   endif

   if nHelpId != nil
      self:nHelpId  = nHelpId
   endif

   if bBlockAction != nil
      self:bAction = bBlockAction
   endif

   if bWhen != nil
      self:bWhen = bWhen
   endif

   if ! Empty( cBmpFile )
      self:hBitmap = eval(Selector:ReadBitmap, 0, cBmpFile )
   endif
   if ! Empty( cResName )
      self:hBitmap = eval(Selector:LoadBitmap, eval(Selector:GetResources), cResName )
   endif

   if nVirtKey != nil
      self:nVKState = nVKState
      self:nVirtKey = nVirtKey
   endif

   if oItem != nil
      oItem:bAction  = self:bAction
      oItem:cPrompt  = self:cPrompt
      oItem:cMsg     = self:cMsg
      oItem:nId      = self:nId
      oItem:lChecked = self:lChecked
      oItem:lActive  = self:lActive
      oItem:lHelp    = self:lHelp
      oItem:lBreak   = self:lBreak
      oItem:hBitmap  = self:hBitmap
      oItem:nHelpId  = self:nHelpId
      oItem:bWhen    = self:bWhen
   endif

return

//----------------------------------------------------------------------------//

static function fw_SetPrompt( self, cPrompt )

   local nNewId, nFlags

   self:cPrompt = cPrompt

   if ValType( self:bAction ) == "O" .and. ;
      self:bAction:ClassName == "TMENU"
      nNewId := self:bAction:hMenu
      nFlags := MF_POPUP
   else
      nNewId := self:nId
      nFlags := numOR( If( self:lActive, MF_ENABLED,;
		numOR( MF_DISABLED, MF_GRAYED ) ),;
		If( self:lChecked, MF_CHECKED, 0 ),;
		If( self:lHelp, MF_HELP, 0 ),;
		If( self:lBreak, MF_BREAK, 0 ) )
   endif

   if self:oMenu != nil
      eval(Selector:ModifyMenu, self:oMenu:hMenu, self:nId, nFlags, nNewId, cPrompt )

      if self:oMenu:oWnd != nil
	 eval(Selector:DrawMenuBar, self:oMenu:oWnd:hWnd )
      endif
   endif

return

//----------------------------------------------------------------------------//

static function fw___HelpTopic(self)

   if Empty( self:nHelpId )
      if self:oMenu != nil
	 self:oMenu:HelpTopic()
      else
	 HelpIndex()
      endif
   else
      HelpTopic( self:nHelpId )
   endif

return

//----------------------------------------------------------------------------//

static function fw_Destroy(self)

   local nAt := AScan( self:oMenu:aItems,;
		       { | oItem | oItem:nId == self:nId } )

   if ValType( self:bAction ) == "O"
      self:bAction:End()
   endif

   if nAt != 0
      ADel( self:oMenu:aItems, nAt )
      ASize( self:oMenu:aItems, Len( self:oMenu:aItems ) - 1 )
   endif

return eval(Selector:RemoveMenu, self:oMenu:hMenu, self:nId, MF_BYCOMMAND )

//----------------------------------------------------------------------------//

static function fw_Save(self)

   local n
   local cType, cInfo := ""
   local oWnd  := &( self:ClassName + "()" )
   local uData, nProps := 0

   oWnd:New()

   for n = 1 to Len( self:aProperties )
       if ! ( uData := OSend( Self, self:aProperties[ n ] ) ) == ;
	  OSend( oWnd, self:aProperties[ n ] )
	  cInfo += ( I2Bin( Len( self:aProperties[ n ] ) ) + ;
		     self:aProperties[ n ] )
	  nProps++
	  cType = ValType( uData )
	  do case
	     case cType == "A"
		  cInfo += ASave( uData )

	     case cType == "O"
		  cInfo += uData:Save()

	     otherwise
		  cInfo += ( cType + I2Bin( Len( uData := cValToChar( uData ) ) ) + ;
			     uData )
	  endcase
       endif
   next

   oWnd:End()

return "O" + I2Bin( 2 + Len( self:ClassName ) + 2 + Len( cInfo ) ) + ;
       I2Bin( Len( self:ClassName ) ) + ;
       self:ClassName + I2Bin( nProps ) + cInfo

//----------------------------------------------------------------------------//

static function ASave( self, aArray )

   local n, cType, uData
   local cInfo := ""

   for n = 1 to Len( aArray )
      cType = ValType( aArray[ n ] )
      do case
	 case cType == "A"
	      cInfo += ASave( aArray[ n ] )

	 case cType == "O"
	      cInfo += aArray[ n ]:Save()

	 otherwise
	      cInfo += ( cType + I2Bin( Len( uData := cValToChar( uData ) ) ) + ;
			 uData )
      endcase
   next

return "A" + I2Bin( 2 + Len( cInfo ) ) + I2Bin( Len( aArray ) ) + cInfo

//----------------------------------------------------------------------------//

static function ARead( self, cInfo )

   local nPos := 1, nLen, n
   local aArray, cType, cBuffer

   nLen   = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos  += 2
   aArray = Array( nLen )

   for n = 1 to Len( aArray )
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      do case
	 case cType == "A"
	      aArray[ n ] = ARead( cBuffer )

	 case cType == "O"
	      aArray[ n ] = ORead( cBuffer )

	 case cType == "C"
	      aArray[ n ] = cBuffer

	 case cType == "D"
	      aArray[ n ] = CToD( cBuffer )

	 case cType == "L"
	      aArray[ n ] = ( cBuffer == "T" )

	 case cType == "N"
	      aArray[ n ] = Val( cBuffer )
      endcase
   next

return aArray

//----------------------------------------------------------------------------//

static function fw_Load( self, cInfo )

   local nPos := 1, nProps, n, nLen
   local cData, cType, cBuffer

   nProps = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos += 2

   for n = 1 to nProps
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cData = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      do case
	 case cType == "A"
	      OSend( Self, "_" + cData, ARead( cBuffer ) )

	 case cType == "O"
	      OSend( Self, "_" + cData, ORead( cBuffer ) )

	 case cType == "C"
	      OSend( Self, "_" + cData, cBuffer )

	 case cType == "L"
	      OSend( Self, "_" + cData, cBuffer == "T" )

	 case cType == "N"
	      OSend( Self, "_" + cData, Val( cBuffer ) )
      endcase
   next

return

//----------------------------------------------------------------------------//

static function fw_cCaption( self, cText )

   if PCount() > 1
      self:SetPrompt( cText )
   else
      return self:cPrompt
   endif

return

//----------------------------------------------------------------------------//
