/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "config.ch"
#include "inkey.ch"

/* for trapshift */
static tp_proc := NIL
static tp_mode := 0

/* for trapanykey */
static ta_proc := NIL

/* trap recursive control */
static t_recursive := 0

/* keysend() buffer */
static t_buffer := ""

*****************************************************
function trapshift(proc_name,mode)
	local ret := tp_proc
	tp_proc := proc_name
	if valtype(mode) == "N"
		tp_mode := mode
	else
		tp_mode := 0
	endif
return ret
*****************************************************
function trapanykey(proc_name)
	local ret := ta_proc
	ta_proc := proc_name
return ret

*****************************************************
function inkey(time,mask)
	local ret:=0, skey:=0,stat := 0
	if nextkey() != 0
		ret := _inkey(time,mask)
		return ret
	endif
	if !empty(t_buffer)
		ret:=asc(left(t_buffer,1))
		t_buffer := substr(t_buffer,2)
		return ret
	endif
	if time == NIL  .or. time != 0 .or. t_recursive != 0
		ret := _inkey(time,mask)
		return ret
	endif
	if ta_proc == NIL .and. tp_proc == NIL // .or. tp_mode == NIL
#ifdef ___1
		ret := _inkey(time,mask)
#else
		/* keyboard(data) from paralell task */
		while ret==0
			ret := _inkey(0.1,mask)
		end
#endif
		return ret
	endif
	while .t. //nextkey() == 0
		sKey := scankey(time)
		switch skey
			case 29
			case 42
			case 54
			case 56
			case 58
			case 69
			case 70
			otherwise
				ret:=_inkey(0.5)
				if ret != 0
					if ta_proc != NIL .and. t_recursive==0
						t_recursive ++
						clip(ta_proc,ret)
						t_recursive --
					else
						exit
					endif
				endif
				if nextkey() != 0 .or. !empty(t_buffer)
					exit
				endif
		end
		stat := kbdstat()
		if tp_proc != NIL .and. numand(stat,tp_mode) != 0 .and. t_recursive==0
			t_recursive ++
			clip(tp_proc,stat)
			t_recursive --
			loop
		endif
	end
return ret
*****************************************************
function keysend(sData,lAppend)
	lAppend := iif(valtype(lAppend) != "L", .f., lAppend )
	if lAppend
		t_buffer += sData
	else
		t_buffer := sData
		__keyboard("")
	endif
return .t.
*****************************************************
function sh_stat()
	local key:=kbdstat()
	if key==1 .or. key==2
		return .f.
	endif
return .t.

*****************************************************
function lsh_stat()
return kbdstat()!=1

*****************************************************
function sh_l_stat()
return kbdstat()!=1

*****************************************************
function rsh_stat()
return kbdstat()!=2

*****************************************************
function sh_r_stat()
return kbdstat()!=2

***************************************************************
function savesetkey()
	local i,ret:=map()
	for i=MIN_KEY_CODE to MAX_KEY_CODE
		ret[i]:=setkey(i)
	next
return ret

***************************************************************
function restsetkey(savedkeys)
	local i
	if savedKeys==NIL
		return .f.
	endif
	for i=MIN_KEY_CODE to MAX_KEY_CODE
		setkey(i,savedKeys[i])
	next
return .t.

***************************************************************
function clearkey
	keyboard chr(0)
	inkey()
	inkey()
return .t.

***************************************************************
function key_name(nkey)

	local _key_names,ret:="",i

	#include "key_name.ch"

	for i=1 to len(_key_names)
		if nkey>=_key_names[i][1] .and. nkey<=_key_names[i][2]
			if nkey>=0
				nkey=nkey-_key_names[i][1]+1
			else
				nkey=abs(_key_names[i][2]-nkey)+1
			endif
			ret=_key_names[i][3][nkey]
			exit
		endif
	next
return ret


***************************************************************
function __setfunction(nKey,cStr)
	local fKey
	if nKey < 1 .or. nKey >40
		return .f.
	endif
	nkey--
	if nkey==0
		fkey:=K_F1
	else
		fkey:=0-nKey
	endif

	setkey(fkey,{||__keyboard(cStr) })

return .t.

***************************************************************
function inkeytrap(nDelay)
	local ret:=0, bkey
	do while .t.
		ret  := inkey(nDelay)
		bKey := setKey(ret)
		if bKey != NIL
			eval(bKey,procname(1),procline(1),readvar())
			loop
		endif
		exit
	enddo
return ret

