/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "clipcfg.h"
#include "directry.ch"
**********************************************************
function diskspace(xDisk)
        if valtype(xDisk)=="N"
		return  diskfree(chr(asc("A")+xDisk-1))
        endif
return diskfree(xDisk)
************************************************************
function isDrive(c)
	c:=upper(c)
	if !empty(set(c+":"))
        	return .t.
        endif
return .f.
************************************************************
function makeDirectory(path)
	local curdir:=curDir()
        local r1,r3, p:=path, i, s
        if dirChange(path) >= 0
        	dirChange(PATH_DELIM+curDir)
 		return .t.
 	endif
        if left(p,1) == PATH_DELIM
#ifdef OS_CYGWIN
        	dirChange(currDrive()+PATH_DELIM+"cygwin"+PATH_DELIM)
#else
        	dirChange(PATH_DELIM)
#endif
        endif
 	while !empty(p)
        	i:=at(PATH_DELIM,p)
                i:=iif(i==0,len(p)+1,i)
                s:=substr(p,1,i-1)
                p:=substr(p,i+1)
                r1:=curDir(s)
                if dirMake(s)<0 .and. empty(p)
        		dirChange(PATH_DELIM+curDir)
                        return .f.
                endif
                r3:=dirChange(s)
        enddo
        dirChange(PATH_DELIM+curDir)
return .t.
**********************************************************
function adir(mask,files,lens,dates,times,atrs)
	local len,m,i
	m=directory(mask, iif(pcount()>5,"D","") )
	len=len(m)
	if pcount()==1
   		return len
	endif
	len=min(len,len(files))
	//asize(files,len)
	if lens==NIL
   		lens:={}
	endif
	if dates==NIL
   		dates:={}
	endif
	if times==NIL
   		times:={}
	endif
	if atrs==NIL
   		atrs:={}
	endif
	asize(lens,len)
	asize(dates,len)
	asize(times,len)
	asize(atrs,len)
	for i=1 to len
   		files[i]=m[i][F_NAME]
   		lens[i] =m[i][F_SIZE]
   		dates[i]=m[i][F_DATE]
   		times[i]=m[i][F_TIME]
   		atrs[i] =m[i][F_ATTR]
	next
return len(m)

**********************************************************
function __Dir ( mask )
	local i, j, bflag:=.f., files, fname:={}
	local maxlen:=11, maxname:=11, cset:=csetatmupa(), eblock:=errorBlock({|x|break(x)})

	if empty(mask)
   		mask="*.dbf"
   		bflag=.t.
	endif

	files=directory(mask)

	for i=1 to len(files)
    		maxlen=max(maxlen, len(files[i][1]) )
	next

	maxlen=min(maxlen, maxcol()-40)
	maxlen-=3
	for i=1 to len(files)
    		aadd( fname, atadjust(".", files[i][1],maxlen) )
    		maxname=max(maxname,len(fname[i]))
	next

	if !bflag
   		for i=1 to len(files)
   			? fname[i],str(files[i][2],10,0), dtoc(files[i][3]), files[i][4]
   		next
   		csetatmupa(cset)
   		errorBlock(eblock)
   		return
	endif

	? padc([Database files],maxname),[  # records],[ last update], [  size ]
	for i=1 to len(files)
    		use (files[i][1]) new shared
    		j= iif(neterr(),"   error  ",str(lastrec(),10,0) )
    		? fname[i], j, dtoc(lupdate()), str(files[i][2],10,0)
    		close
	next

	csetatmupa(cset)
	errorBlock(eblock)
return

**********************************************************
function __typeFile(fname,print)
	local sPrint:=set(_SET_PRINTER)
	local sDevice:=set(_SET_DEVICE)
        if print
        	set device to printer
                set printer on
        endif

        ? memoread(fname)

	set(_SET_PRINTER,sPrint)
	set(_SET_DEVICE,sDevice)
return
**********************************************************
function tmpfile()
	local f:=""
	while .t.
#ifdef __CLIP__
  		f=PATH_DELIM+"tmp"+PATH_DELIM+"clip"+alltrim(str(random(10000),4,0))
#else
  		f=currdrive()+"\"+curdir()+"\tmp\prom"+alltrim(str(random(10000),4,0))
#endif
  		f=strtran(f," ","0")
  		if !file(f+".dbf") .and. !file(f+".dbt") .and. !file(f+".txt")
     			exit
  		endif
	enddo
#ifdef __CLIP__
	 f=makepath(f)
#endif
return f

