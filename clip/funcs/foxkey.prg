/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "inkey.ch"

static stack_setKeys:={}

***************************************
* on key label <x> do <proc>
***************************************
function fx_setkey(cKey,bBlock)
	local nKey := fx_keyLabel2Num(cKey)
        if nKey != 0
      		SetKey( nKey, bBlock )
        endif
return nKey

***************************************
* push key
***************************************
function fx_pushKeys(lClear)
	local i, keys := saveSetKey()
        aadd(stack_setKeys,keys)
        if lClear
        	for i=MIN_KEY_CODE to MAX_KEY_CODE
        		setkey(i, NIL)
        	next
        endif
return keys

***************************************
* pop key
***************************************
function fx_popKeys(lAll)
	local keys
        if len(stack_setKeys) > 0
        	keys := atail(stack_setKeys)
                restSetKey(keys)
                asize(stack_setKeys,len(stack_setKeys)-1)
        endif
return keys

***************************************
static function fx_keyLabel2Num(cKey)
	local nKey:=0, ch1,ch2,ch3
        cKey := alltrim(upper(cKey))
        ch1:=asc(substr(cKey,1,1))
        if (nKey := val(cKey) ) != 0
                return nKey
        endif
        do switch ch1
		case K_I
                	nKey := K_INS
		case K_H
                	nKey := K_HOME
		case K_T
                	nKey := K_TAB
		case K_U
                	nkey := K_UP
                case K_D
                	if cKey == "DEL"
                        	nKey := K_DEL
                        endif
                	if cKey == "DNARROW"
                		nKey := K_DOWN
                        endif
        	case K_P
                	if cKey=="PGDN"
                        	nKey := K_PGDN
                        endif
                	if cKey=="PGUP"
                        	nKey := K_PGUP
                        endif
        	case K_L
                	if cKey=="LEFTARROW"
                        	nKey := K_LEFT
                        endif
                	if cKey=="LBRACE"
                        	nKey := asc("{")
                        endif
        	case K_R
                	if cKey=="RIGHTARROW"
                        	nKey := K_RIGHT
                        endif
                	if cKey=="RBRACE"
                        	nKey := asc("}")
                        endif
        	case K_E
                	if cKey=="END"
                        	nKey := K_END
                        endif
                	if cKey=="ENTER"
                        	nKey := K_ENTER
                        endif
        	case K_B
                	if cKey=="BACKSPACE"
                        	nKey := K_BS
                        endif
                	if cKey=="BACKTAB"
                        	nKey := K_SH_TAB
                        endif
        	case K_F
                	ch2:=val(substr(cKey,2))
                        if ch2==1
                        	nKey := K_F1
                        endif
                        if ch2==11
                        	nKey := K_F11
                        endif
                        if ch2==12
                        	nKey := K_F12
                        endif
                        if ch2>1 .and. ch2 <11
                        	nKey := K_F2+2-ch2
                        endif
        	case K_S
                	ch2 := substr(cKey,8)
                        if ch2==11
                        	nKey := K_SH_F11
                        endif
                        if ch2==12
                        	nKey := K_SH_F12
                        endif
                        if ch2>0 .and. ch2 < 11
                        	nKey := K_SH_F1+1-ch2
                        endif
        	case K_A
                	if len(cKey) > 5
                		ch2 := val(substr(cKey,6))
                        	if ch2==11
                        		nKey := K_ALT_F11
                        	endif
                        	if ch2==12
                        		nKey := K_ALT_F12
                        	endif
                        	if ch2>0 .and. ch2 < 11
                        		nKey := K_ALT_F1+1-ch2
                        	endif
                        else
                        	ch2:=asc(substr(cKey,5,1))
                                if ch2 < asc("A")
                                        nKey := K_ALT_1-1+ch2-asc("1")
                                else
					//ch2 := substr(cKey,5,1)
					do switch ch2
                                        	case K_A
                                                	nKey := K_ALT_A
                                        	case K_B
                                                	nKey := K_ALT_B
                                        	case K_C
                                                	nKey := K_ALT_C
                                        	case K_D
                                                	nKey := K_ALT_D
                                        	case K_E
                                                	nKey := K_ALT_E
                                        	case K_F
                                                	nKey := K_ALT_F
                                        	case K_G
                                                	nKey := K_ALT_G
                                        	case K_H
                                                	nKey := K_ALT_H
                                        	case K_I
                                                	nKey := K_ALT_I
                                        	case K_J
                                                	nKey := K_ALT_J
                                        	case K_K
                                                	nKey := K_ALT_K
                                        	case K_L
                                                	nKey := K_ALT_L
                                        	case K_M
                                                	nKey := K_ALT_M
                                        	case K_N
                                                	nKey := K_ALT_N
                                        	case K_O
                                                	nKey := K_ALT_O
                                        	case K_P
                                                	nKey := K_ALT_P
                                        	case K_Q
                                                	nKey := K_ALT_Q
                                        	case K_R
                                                	nKey := K_ALT_R
                                        	case K_S
                                                	nKey := K_ALT_S
                                        	case K_T
                                                	nKey := K_ALT_T
                                        	case K_U
                                                	nKey := K_ALT_U
                                        	case K_V
                                                	nKey := K_ALT_V
                                        	case K_W
                                                	nKey := K_ALT_W
                                        	case K_X
                                                	nKey := K_ALT_X
                                        	case K_Y
                                                	nKey := K_ALT_Y
                                        	case K_Z
                                                	nKey := K_ALT_Z
                                        endswitch

                                endif

                        endif
        	case K_C
                	ch2 := asc(substr(cKey,6,1))
                        do switch ch2
                        	case K_A
                                	nKey := K_CTRL_A
                        	case K_B
                                	nKey := K_CTRL_B
                        	case K_C
                                	nKey := K_CTRL_C
                        	case K_D
                                	nKey := K_CTRL_D
                        	case K_E
 					if cKey == "CTRL-END"
                                        	nKey := K_CTRL_END
                                        else
                                		nKey := K_CTRL_E
                                        endif
                        	case K_F
                			if len(cKey) > 6
                				ch3 := val(substr(cKey,7))
                        			if ch3==11
                        				nKey := K_CTRL_F11
                        			endif
                        			if ch3==12
                        				nKey := K_CTRL_F12
                        			endif
                        			if ch3>0 .and. ch3 < 11
                        				nKey := K_CTRL_F1+1-ch3
                        			endif
                                        else
                                		nKey := K_CTRL_F
                                        endif
                        	case K_G
                                	nKey := K_CTRL_G
                        	case K_H
 					if cKey == "CTRL-HOME"
                                        	nKey := K_CTRL_HOME
                                        else
                                		nKey := K_CTRL_H
                                        endif
                        	case K_I
                                	nKey := K_CTRL_I
                        	case K_J
                                	nKey := K_CTRL_J
                        	case K_K
                                	nKey := K_CTRL_K
                        	case K_L
 					if cKey == "CTRL-LEFTARROW"
                                        	nKey := K_CTRL_LEFT
                                        else
                                		nKey := K_CTRL_L
                                        endif
                        	case K_M
                                	nKey := K_CTRL_M
                        	case K_N
                                	nKey := K_CTRL_N
                        	case K_O
                                	nKey := K_CTRL_O
                        	case K_P
                                	if cKey=="CTRL-PGDN"
                                        	nKey := K_CTRL_PGDN
                                        elseif cKey=="CTRL-PGUP"
                                        	nKey := K_CTRL_PGUP
                                        else
                                        	nkey := K_CTRL_P
                                        endif
                        	case K_Q
                                	nKey := K_CTRL_Q
                        	case K_R
 					if cKey == "CTRL-RIGHTARROW"
                                        	nKey := K_CTRL_RIGHT
                                        else
                                		nKey := K_CTRL_R
                                        endif
                        	case K_S
                                	nKey := K_CTRL_S
                        	case K_T
                                	nKey := K_CTRL_T
                        	case K_U
                                	nKey := K_CTRL_U
                        	case K_V
                                	nKey := K_CTRL_V
                        	case K_W
                                	nKey := K_CTRL_W
                        	case K_X
                                	nKey := K_CTRL_X
                        	case K_Y
                                	nKey := K_CTRL_Y
                        	case K_Z
                                	nKey := K_CTRL_Z
                        endswitch
        endswitch
return nKey

