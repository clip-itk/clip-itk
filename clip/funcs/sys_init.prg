/*
	Copyright (C) 2001  ITK
	Author   : Uri (uri@itk.ru)
	License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "clipcfg.h"
#include "set.ch"
#include "inkey.ch"
#include "ulimit.ch"
#include "fileio.ch"

init procedure sys_init
  local l,x,i,c,cliproot:=cliproot()
  local file

  public GETLIST:={}
  errorSys()

#ifndef OS_CYGWIN
	setTxlat(16, "><")
#endif

  // englisg dow() return 1 for Saturday
  // russian dow() return 1 for Monday
  // for english - chr(1), for russin - chr(0)
  set("FIRST_DAY_WEEK",chr(1))

  set date format to _DDATEFMT()
  set century off
  set(_SET_EVENTMASK, INKEY_ALL)
  set("PRINTER_EOL",chr(13)+chr(10))
  SET KEY K_F1 TO Help

#ifdef CLIPPER50_COMPATIBLE
  // set autopen off
#else
  set autopen on
#endif

  if !dbf_charset_init(cliproot)
	l := [cp437]
	set("DBF_CHARSET",l)
	outlog(2,"set DBF_CHARSET:",l)
	if "ru" $ lower(getenv("LANG")) .or. "ru" $ lower(getenv("CLIP_LANG")) .or. empty(getenv("LANG"))
		// it`s Russian DOS codepage
		set("DBF_CHARSET","cp866")
		outlog(2,"set DBF_CHARSET:","cp866")
	endif
  endif

#ifdef OS_CYGWIN
  for i=asc("A") to asc("Z")
		set(chr(i)+":","/cygdrive/"+chr(i))
		outlog(2,"add drive "+chr(i)+": as "+"/cygdrive/"+lower(chr(i)))
  next
  drives_init(cliproot)
#else
  if !drives_init(cliproot)
	outlog(2,"add drive C: as /")
	set("C:","/")
	//outlog(2,"add drive D: as /usr")
	//set("D:","/usr")
	//outlog(2,"add drive E: as /home")
	//set("E:","/home")
  endif
#endif

  file:=cliproot+PATH_DELIM+"etc"+PATH_DELIM+"def_sets"
  if file(file)
	loadsets(file)
  endif
  file:=PATH_DELIM+"home"+PATH_DELIM+getenv("USER")+PATH_DELIM+".clip"+PATH_DELIM+"def_sets"
  if file(file)
	loadsets(file)
  endif

//  diskchange("C:")
//  INI__CTOOLS_DISKFUNC()

  randomize() // start random functions

  //? ulimit(ULIMIT_CORE,0) // max size core files == 0
  l:=ulimit(ULIMIT_AS)
  x:=0x7fffffff
  for i=1 to 10
	ulimit(ULIMIT_AS,x)
	l:=ulimit(ULIMIT_AS)
		if l>=x
			exit
		endif
		x=int(x/2)
  next
  outlog(2,"set ulimit -v =",l)

  l:=ulimit(ULIMIT_DATA)
  x:=0x7fffffff
  for i=1 to 10
	ulimit(ULIMIT_DATA,x)
	l:=ulimit(ULIMIT_DATA)
	if l>=x
		exit
	endif
	x=int(x/2)
  next
  outlog(2,"set ulimit -d =",l)

  HK_init()           // default hot keys for editor, debugger, ... more
  HK_load()           // load users hot keys

return

**********************************************
static function drives_init(path)
	local ret:=.f., fh, buf, d,p,f
	f:=path+PATH_DELIM+"etc"+PATH_DELIM+"drives"
	if !file(f)
		outlog(2,"$CLIPROOT/etc don`t have file 'drives'")
		return .f.
	endif
	fh:=fopen(f,FO_READ)
	if fh<0
		outlog(2,"$CLIPROOT/etc/drives: open error:",ferrorstr())
		return .f.
	endif
	while !fileeof(fh)
		   buf:=filegetstr(fh)
		   buf:=alltrim(buf)
		   if left(buf,1)=="#" .or. empty(buf)
			loop
		   endif
		   if substr(buf,2,1)==":"
			d:=upper(substr(buf,1,1))+":"
			p:=alltrim(substr(buf,3))
			outlog(2,"add drive "+d+" as "+p)
			set(d,p)
			ret:=.t.
		   endif
	enddo
	fclose(fh)
return ret

**********************************************
static function dbf_charset_init(path)
	local ret:=.f., fh, buf,f
	f:=path+PATH_DELIM+"etc"+PATH_DELIM+"dbfcharset"
	if !file(f)
		outlog(2,"$CLIPROOT/etc don`t have file 'dbfcharset'")
		return .f.
	endif
	fh:=fopen(f,FO_READ)
	if fh<0
		outlog(2,"$CLIPROOT/etc/dbfcharset: open error:",ferrorstr())
		return .f.
	endif
	while !fileeof(fh)
		   buf:=filegetstr(fh)
		   buf:=alltrim(buf)
		   if left(buf,1)=="#" .or. empty(buf)
				loop
		   endif
		   if !empty(buf)
				exit
		   endif
	enddo
	if !empty(buf)
		set("DBF_CHARSET",lower(buf))
		outlog(2,"set DBF_CHARSET:",lower(buf))
		ret:=.t.
	endif
	fclose(fh)
return ret

**********************************************
function loadsets(file)
	local fh, buf,i,n,nn,d,p, __set_names:=setNames()
	local error,eblock:=errorblock({|e|break(e)})
	fh:=fopen(file,FO_READ)
	if fh<0
		outlog(2,file+": open error:",ferrorstr())
		return .f.
	endif
	while !fileeof(fh)
		buf:=filegetstr(fh)
		buf:=alltrim(buf)
		if left(buf,1)=="#" .or. empty(buf)
			loop
		endif
		i := at(":",buf)
		if i==0
			outlog(2,file+": format error:",buf)
			loop
		endif
		d:=alltrim(substr(buf,1,i-1))
		p:=alltrim(substr(buf,i+1))
		if upper(substr(d,1,5))=="_SET_"
			n:=upper(substr(d,6))
			nn:=0
			for i in __set_names KEYS
				if __set_names[i]==n
					nn:=i
					exit
				endif
			next
			if nn > 0
				begin sequence
					outlog(2,"add set "+d+" as "+p)
					set(nn, &p)
				recover using error
					outlog(2,file+":error setting:",buf)
					end sequence
					loop
			endif
		endif
		outlog(2,"add set '"+d+"' as '"+toString(p)+"'")
		set(d,p)
	enddo
	fclose(fh)
	errorBlock(eblock)
return .t.

**********************************************
function version()
return "CLIP:"+CLIP_VERSION
