/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "button.ch"
#include "set.ch"

static aMenuStack := {}
static oLastItem



*************************************************
function iMenuBegin( lPopup, lSystem, oWnd )
	local oItem


	if len(aMenuStack)==0
        	oItem := topBar(0,0,maxcol() )
                aadd(aMenuStack,oItem)
        else
                oItem := popUp()
                aadd(aMenuStack,oItem )
        	oLastItem:data := oItem
        endif

return oItem

*************************************************
function iMenuAddItem( cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile,;
                      cResName, osMenu, bBlock, nVKState, nVirtKey, lHelp,;
                      nHelpId, bWhen, lBreak, nEvent )

	local oItem

	if pcount() == 0
      		oItem := menuItem( MENU_SEPARATOR )
        else
        	if len(aMenuStack)==1
        		oItem := menuItem ( cPrompt, popUp() )
		else
        		oItem := menuItem ( cPrompt )
                        if lChecked != NIL
        			oItem:checked := lChecked
                        endif
                        if lActive != NIL
        			oItem:enabled := lActive
                        endif
        		if cMsg != NIL
        			oItem:message := cMsg
        		endif
        		if nVirtKey != NIL
	        		oItem:shortCut := nVirtKey
	        	endif
	        	if bBlock != NIL
	        		oItem:data := bBlock
	        	endif
	        	if bAction != NIL
	        		oItem:data := bAction
	        	endif
	        	if nEvent != NIL
	        		oItem:id := nEvent
	        	endif
		endif
	endif
	oLastItem:=oItem
	aMenuStack[len(aMenuStack)]:addItem(oItem)

return oItem

*************************************************
function iMenuEnd()
	local ret := atail(aMenuStack)

        asize(aMenuStack, len(aMenuStack)-1 )

return ret

