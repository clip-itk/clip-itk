/*
    Copyright (C) 2001-2005  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "set.ch"
#include "debug.ch"
#include "box.ch"

local i,j, ddd, ret, nkey, inifile
local params:={"","",""}

	i:=1; j:=1
	while .t.
		ddd := param(i)
		if empty(ddd)
			exit
		endif
		i++
		if file(ddd)
			inifile := ddd
			loop
		endif
		if j <= len(params)
			params[j] := ddd
			j++
		endif
	end

	setcolor(set("ab_colors_menu"))
	clear screen
	set deleted on
	//showtime(0,maxcol()-8,.f.,"0/w")
	if !empty(iniFile)
		ab_connect_cobra(inifile)
	endif

	ddd:=abNew(params[1],params[2])
	do while .t.
		nkey:=inkey(0)
		ret=ddd:handleKey(nkey)
		if ret==0
		   exit
		endif
	enddo
	if !empty(iniFile)
		codb_cobraQuit()
	endif
	showtime()
	? "Good bye"
	?
return

****************************************
static function ab_connect_cobra(iniFile)
	local ret1,ret2,x,y
	local cUser:=space(30),cPass:=space(30)
	local GetList:={}
	x := (maxrow()-6)/2
	y := (maxcol()-50)/2
	@ x,y, x+6,y+60 box B_DOUBLE+" "
	@ x,y+5  say [Please enter COBrA user data]
	@ x+2,y+1 say [User name...........] get cUser
	@ x+4,y+1 say [Password............] get cPass
	read
	cUser := alltrim(cUser)
	cPass := alltrim(cPass)
	ret1 := codb_CobraInit(iniFile,cUser,cPass)
	if !empty(ret1)
		alert([Error connection to COBrA server:]+";"+ret1)
		quit
	endif
	ret2 := codb_CobraWarning()
	if !empty(ret2)
		alert(ret2)
	endif
return
