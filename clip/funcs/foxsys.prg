#include "clipcfg.h"
#include "setcurs.ch"
function sys(nVal,p1,p2)
	static dir:={},nCount:=0
	local ret:="",s
        local x1,x2,x3,x4
        do switch nVal
        	case 0
                	ret:= padr(getenv("HOSTNAME"),15)+"# 0"
        	case 1
        		ret:=str( dtoj() )
        	case 2
        		ret:=str(seconds() % 86400,5)
        	case 3
        		ret:=padr("t"+alltrim(str(pid()))+alltrim(str(random(100000))),8,"0")
        	case 5
                        s:=set(_SET_DEFAULT)
                        if substr(s,2,1)==":"
                        	ret := substr(s,1,2)
                        else
                        	ret := currDrive()
                        endif
        	case 6
                	ret := set(_SET_PRINTFILE)
                        if empty(ret)
                        	ret:= "PRN:"
                        endif
        	case 7
                	ret := _procreq_()
        	case 9
                	ret := "GPL; (C) E&T Company;"
        	case 10
                	if empty(p1)
                        	p1 := dtoj()
                        endif
                	ret := dtoc( jtod(p1) )
        	case 11
                	if valtype( p1 ) == "C"
                        	p1 := ctod(p1)
                        endif
        		ret:=str( dtoj(p1) )
        	case 12
                	ret :="640000"
        	case 13
                	ret :="READY"
        	case 14
                	x1:=select()
                        if valtype(p2) == "C"
                        	select(select(p2))
                        endif
                        if valtype(p2) == "N"
                        	select(p2)
                        endif
                        if used()
                        	ret:=ordkey(p1)
                        endif
			select(x1)
        	case 15
                	ret := p1
        	case 16
                	x1  := strtran(startpath(),"/","\")
                        x2  := rat("\",x1)
                        ret := substr(x1,x2+1)
        	case 17
                	ret := ARCH
        	case 18
                	ret := readvar()
        	case 20
                	ret := p1
        	case 21
                	ret := ordBagname()
        	case 23,24
                	ret := "0"
        	case 100
                	ret := iif(set(_SET_CONSOLE),"ON","OFF")
        	case 101
                	ret := set(_SET_DEVICE)
        	case 102
                	ret := iif(set(_SET_PRINTER),"ON","OFF")
        	case 103
                	//ret := iif(set(_SET_TALK),"ON","OFF")
                        ret := "OFF"
        	case 1001,1016
                	ret := "1000000"
        	case 2000
                        if len(dir) == 0
                               	aadd(dir, {"","",0,0})
                        endif
                	if !empty(p2) .and. nCount < len(dir)
                        	nCount ++
                        	ret:=dir[nCount][1]
                        elseif empty(p2)
                        	dir:=directory(p1)
                                if len(dir) == 0
                               		aadd(dir, {"","",0,0})
                                endif
                                nCount := 1
                        	ret:=dir[nCount][1]
                        endif
        	case 2001
                	x4:=map()
                        x4:near := "SOFTSEEK"
                        if empty(p2)
                        	x4:PRINTER := "PRINTFILE"
                        endif
                        if p1 $ x4
                        	p1 := x4[p1]
                        endif
                	x3:=0
                        x1:=setNames()
                        for x2 in x1 KEYS
                        	if x1[x2] == p1
                                	x3 := x2
                                endif
                        next
                        if x3 != 0
                        	ret := set(x3)
                        endif
        	case 2002
                	ret := setcursor(empty(p1))
        	case 2003
                	ret := PATH_DELIM+curdir()
        	case 2004
                	x1  := strtran(startpath(),"/","\")
                        x2  := at("\",x1)
                        ret := substr(x1,1,x2-1)
        	case 2005
                	ret := clip("fx_setResource")
        	case 2006
                	ret := "VGA/Color"
        	case 2007
                	ret := str(hashstr(p1))
        	case 2008
                	x1:=SC_NORMAL
                	if valtype(p1) == "C"
                        	x1:= iif ( p1 =="I", SC_INSERT, SC_SPECIAL1)
                        endif
                	if valtype(p2) == "N"
                        	x1 := p2+1
                        endif
                        setcursor(x1)
        	case 2009
        	case 2010
                	ret:="255"
        	case 2011
        	case 2012
                	ret:=alltrim(str( set( _SET_MBLOCKSIZE) ))
        	case 2013
        	case 2014
                	ret := p1
        	case 2015
                	ret:="_"+alltrim(str(random(1000000)))
        	case 2016
                	ret:= clip("fx_lastShowWindow")
        	case 2017
        	case 2018
        	case 2019
        	case 2020
                	ret := alltrim(str(disktotal()))
        	case 2021
                	ret := ordFor(p2,p1)
        	case 2022
                	ret := "1024"
        	case 2023
                	ret := currDrive()
        endswitch
return ret
