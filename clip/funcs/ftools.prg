/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "clipcfg.h"
#include "directry.ch"
#include "fileio.ch"
**********************************************************
function fileIsScript(fName)
	local fh, cBuf := space(2)
	fh:=fopen(fName,FO_READ)
	fRead(fh,@cBuf,len(cBuf))
	fClose(fh)
return (cBuf == "#!")
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
function makeDirectory(path,mode)
	local curdir:=curDir()
	local r3, p:=path, i, s, q,qq

	if empty(mode)
		mode := "777"
	endif
	if dirChange(path) >= 0
		dirChange(PATH_DELIM+curDir)
		return .t.
	endif
	if left(p,1) == PATH_DELIM
#ifdef OS_CYGWIN
		qq := currDrive()+PATH_DELIM+"cygwin"+PATH_DELIM
#else
		qq := PATH_DELIM
#endif
		dirChange(qq)
	endif
	while !empty(p)
		i:=at(PATH_DELIM,p)
		i:=iif(i==0,len(p)+1,i)
		s:=substr(p,1,i-1)
		p:=substr(p,i+1)
		if dirMake(s)<0 .and. empty(p)
			dirChange(PATH_DELIM+curDir)
//			qq += PATH_DELIM+curDir
			return .f.
		endif
		//chmod(s,mode)
		q := s
		r3:=dirChange(s)
	enddo
//	outlog(__FILE__,__LINE__,q,mode)
//	if !empty(q)
//		chmod(q,mode)
//	endif
	chmod(path,mode)
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

	local tmpdir:=getenv("TMPDIR")
	if (tmpdir == "")
		tmpdir:=PATH_DELIM+"tmp"
	endif

	while .t.
#ifdef __CLIP__
		f=tmpdir+PATH_DELIM+"clip"+NTOC(PID(),10,4,'0')+NTOC(random(10000),10,4,'0')
#else
		f=currdrive()+"\"+curdir()+"\tmp\prom"+NTOC(PID(),10,4,'0')+NTOC(random(10000),10,4,'0')
#endif
		f=strtran(f," ","0")
		if !file(f+".dbf") .and. !file(f+".dbt") .and. !file(f+".txt");
		    .and. !file(f+".prg") .and. !file(f+".po")
			exit
		endif
	enddo
#ifdef __CLIP__
	 f=makepath(f)
#endif
return f
**********************************************************
function tempfile(cDir,cExt,nAttr)
	local ret:="",i,s1,s2
	if valtype(cDir)=="C"
		s1 := makepath(cDir)
	else
		s1 := makePath("")
	endif
	if ! (right(s1,1) $ "\/")
	     s1 += PATH_DELIM
	endif
	cExt := iif(valtype(cExt)=="C",cExt,"")
	do while .t.
		ret := "ctmp"+lower(ntoc(random(0xFFFF),32,4,"0"))+'.'+cExt
		s2 := s1+ret
		s2 := makepath(s2)
		if !file(s2)
			exit
		endif
	enddo
	i := fcreate(s2)
	if i<0
		s2 := ""
	else
		fclose(i)
	endif
	if valtype(cDir)=="C"
		i := atr(cDir+PATH_DELIM,s2)
		if i>0
			s2 := substr(s2,i)
		endif
	else
		s2 := ret
	endif
return  s2
**********************************************************
function recursiveDirectory(cMask, cPath)
local mDir, mD, i, j
	if empty(cPath)
		cPath := ""
	endif
	mDir := directory(cMask, "D")
	for i:= 1 to len(mDir)
		if mDir[i][5] == "D"
			if mDir[i][1] == "." .or. mDir[i][1] == ".."
				adel(mDir, i)
				asize(mDir, len(mDir)-1)
				i--
			else
				if dirChange(mDir[i][1])<0
					adel(mDir, i)
					asize(mDir, len(mDir)-1)
					i--
					loop
				endif
				mD := recursiveDirectory(cMask, cPath+mDir[i][1]+"/")
				dirChange("../")
				adel(mDir, i)
				asize(mDir, len(mDir)+len(mD)-1)
				for j:=1 to len(mD)
					ains(mdir, i, mD[j])
				next
				i+=len(mD)-1
			endif
		else
			mDir[i][1] := cPath+mDir[i][1]
		endif
	next
return mDir
**********************************************************
function fileCopy(f1, f2,lMode)
return __copyFile(f1,f2)
**********************************************************
function copyFile(f1, f2,lMode)
return __copyFile(f1,f2)
**********************************************************
FUNCTION FSize( nHandle )
  LOCAL nCurrent, nLength
  nCurrent := FPOS( nHandle )
  nLength := FGOBOTTOM( nHandle )
  FSEEK( nHandle, nCurrent, FS_SET )
  RETURN ( nLength )

