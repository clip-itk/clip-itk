/*
    Copyright (C) 2004  ITK
    Author  : Elena V. Kornilova  <alena@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "clip-gtk2.ch"
#include <inkey.ch>
#define __GET_TYPE	HASH__GET_TYPE

function gtk_GetNew(wObj, vVal, sTempl, bValid, bWhen)
local GetList:={}, sStr

 	if ( wObj == NIL )
        	wObj := map()
        endif

	wObj := gtk_EntryNew(wObj)
        wObj:destroy := @__gtk_GetDestroy()
        wObj:__Type := __GET_TYPE

        sStr := @vVal
	gtk_EntrySetText(wObj, toString(sStr))
	wObj:Get := __GET__( @sStr, "sStr", sTempl, bValid, bWhen )

        wObj:Get:_display := @__gtk_GetDisplay()
        wObj:Get:lPasswd := .f.
        wObj:Get:lValid := .t.
        wObj:Get:hWid := wObj:Handle
        if !( gtk_EntryGetVisibility(wObj) )
        	wObj:Get:__flags += "Q"
        	wObj:Get:lPasswd := .t.
        endif
        wObj:Get:KeyChar := @__gtk_KeyChar()
        wObj:sig := gtk_SignalConnect(wObj, GTK_EVENT, {|wgt, ev| wgt:Get:KeyChar(wgt:Get, ev) })
        gtk_SignalConnect(wObj, "focus-in-event", {|w, e| w:Get:SetFocus(), .f.})
        gtk_SignalConnect(wObj, "focus-out-event", {|w, e| w:Get:KillFocus(), .f.})
        if !empty( bWhen )
        	wObj:__When := bWhen
                wObj:__SigWhen := gtk_SignalConnect(wObj, "focus-in-event", {|w, e| __GetFocus(w, e)})
        endif
        if !empty( bValid )
        	wObj:__Valid := bValid
                wObj:__SigValid := gtk_SignalConnect(wObj, "focus-out-event", {|w, e| __KillFocus(w, e)})
        	endif
	wObj:Get:_display()

return wObj

function gtk_GetVarGet(wObj)
local vVal
	if !( "__TYPE" $ wObj .and. wObj:__TYPE == __GET_TYPE )
        	return
        endif
        wObj:Get:Assign()
//        wObj:Get:KillFocus()
//        wObj:Get:SetFocus()
	vVal := wObj:Get:VarGet()
//        wObj:Get:KillFocus()
//        wObj:Get:SetFocus()
return vVal

function gtk_GetVarPut(wObj, vVal)
local ret
	if !( "__TYPE" $ wObj .and. wObj:__TYPE == __GET_TYPE )
        	return
        endif
//        wObj:Get:KillFocus()
        wObj:Get:SetFocus()
	ret := wObj:Get:VarPut(vVal)
        wObj:Get:KillFocus()
        wObj:Get:SetFocus()
return ret
/****************************************************************************/

static function __gtk_GetDisplay(gObj)
local 	oGet, x, y, l:=.f.

	if ( "GET" $ gObj )
        	oGet := gObj:Get
        else
        	oGet := gObj
        endif

	if gtk_EditableHasSelection(oGet:hWid)
                gtk_EditableGetSelectionBounds(oGet:hWid, @x, @y)
                if x <> y
        		l := .t.
                endif
        endif
	if ( "Q" $ oGet:__flags .and. oGet:Type == "C" )
        	gtk_EntrySetText( oGet:hWid, Replicate( "*", len( trim(oGet:Buffer) ) ) )
        	gtk_EntrySetPosition( oGet:hWid, oGet:Pos )
        else
        	gtk_EntrySetText( oGet:hWid, oGet:Buffer )
        	gtk_EntrySetPosition( oGet:hWid, oGet:Pos )
        endif
        if (l)
        	gtk_EntrySelectRegion(oGet:hWid, x, y)
        endif
return

static function __gtk_KeyChar( self, oGet, Event )
local nHi, nLo
local lAccept
local nDefButton
local nKey, sStr
local nState, nFlags
static MouseEvent := .f.

	if Event:event != GTK_KEY_PRESS
        	if Event:event == GTK_BUTTON_RELEASE
                	MouseEvent := .t.
                endif
		return .f.
	endif

	nKey := Event:keyval
	nState := Event:state

	if MouseEvent
        	MouseEvent := .f.
        	oGet:GotoPos(gtk_EntryGetPosition(oGet:hWid))
        endif

        sStr := translate_charset("utf-8", __CHARSET__, gdk_KeyvalToUnicode(nKey))

	do case
	case nKey == K_LEFT
        	oGet:Left()
                return .t.
	case nKey == K_RIGHT
        	oGet:Right()
                return .t.
	case nKey == K_HOME
        	oGet:Home()
                return .t.
	case nKey == K_END
        	oGet:End()
                return .t.
	case nKey == K_DEL
		nLo := nHi := 0
		gtk_EditableGetSelectionBounds(oGet:hWid, @nLo, @nHi)

		// Delete selection
		if nHi != nLo
			gtk_EditableSelectRegion(oGet:hWid, nLo, nLo)
			oGet:buffer = Left( oGet:buffer, Min( nHi, nLo )-1 ) ;
		   		+ Right( oGet:buffer, ;
			    	Len( oGet:buffer ) - Max( nHi, nLo ) ) ;
		   		+ Space( Abs( nLo - nHi ) )

			oGet:Assign()
			oGet:Reset()
                	oGet:KillFocus()
                	oGet:SetFocus()
			oGet:SetPos(Min( nLo, nHi ))
		else
        		oGet:Delete()
		endif

                return .t.
	case nKey == K_BS
        	oGet:BackSpace()
                return .t.
   	case nKey == K_INS
      		SET( _SET_INSERT, !SET( _SET_INSERT ) )
                return .t.
	endcase
        nKey := asc(sStr)
	if  nKey >= 32 .and. nKey < 256
		nLo := nHi := 0
		gtk_EditableGetSelectionBounds(oGet:hWid, @nLo, @nHi)

		// Delete selection
		if nHi != nLo
                        gtk_EditableSelectRegion(oGet:hWid, nLo, nLo)
			oGet:buffer = Left( oGet:buffer, Min( nHi, nLo )-1 ) ;
		   		+ Right( oGet:buffer, ;
			    	Len( oGet:buffer ) - Max( nHi, nLo ) ) ;
		   		+ Space( Abs( nLo - nHi ) )

			oGet:Assign()
			oGet:Reset()
                	oGet:KillFocus()
                	oGet:SetFocus()
			oGet:SetPos(Min( nLo, nHi ))
		endif

		if oGet:Type == "N" .and. ;
			( sStr == "." .or. sStr == "," )
			oGet:ToDecPos()
		else

			if Set( _SET_INSERT )
				oGet:Insert( sStr )
			else
				oGet:Overstrike( sStr )
			end
		endif
		return .t.
	endif


return .f.

function __gtk_GetDestroy(wObj)

 	if !( wObj != NIL .and. gtk_WidgetGetType(wObj) == GTK_WIDGET_ENTRY )
        	gtk_ErrorMsgBox("The first parameter must be GTK_WIDGET_ENTRY")
                return .F.
        endif
        if !("GET" $ wObj)
        	return .T.
        endif

	gtk_SignalDisconnect(wObj, wObj:Sig)
        wObj:Get := NIL
       	adel(wObj, "GET")

	if ( "__WHEN" $ wObj .and. "__SIGWHEN" $ wObj )
        	gtk_SignalDisconnect(wObj, wObj:__SigWhen)
                wObj:__When := NIL
                wObj:__SigWhen := NIL
                adel(wObj, "__WHEN")
                adel(wObj, "__SIGWHEN")
        endif

	if ( "__VALID" $ wObj .and. "__SIGVALID" $ wObj )
        	gtk_SignalDisconnect(wObj, wObj:__SigValid)
                wObj:__Valid := NIL
                wObj:__SigValid := NIL
                adel(wObj, "__VALID")
                adel(wObj, "__SIGVALID")
        endif
return .T.



static function __GetFocus( wObj, Event )
local lRet, parent, oldFocus

        if !wObj:Get:lValid
        	return .T.
        endif

	parent := gtk_WidgetGetToplevel(wObj)
        oldFocus := gtk_WindowGetFocus(parent)

	lRet := eval(wObj:__When, wObj)

        if lRet
        	wObj:Get:Buffer := gtk_EntryGetText(wObj)
        	wObj:Get:Assign()
        	wObj:Get:KillFocus()
        	wObj:Get:SetFocus()
        else
             	gtk_WindowSetFocus(parent, oldFocus)
        endif

return  .T.

static function __KillFocus( wObj, Event )
local lRet, parent
	parent := gtk_WidgetGetToplevel(wObj)
	wObj:Get:lValid := eval(wObj:__Valid, wObj)
        if !( wObj:Get:lValid )
             	gtk_WindowSetFocus(parent, wObj)
		return  .T.
        endif

return  .F.

