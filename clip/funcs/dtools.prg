/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "lang.ch"
static monates
static days

************************************************

init procedure dtools_init
	monates:={}
	asize(monates,12)
	monates[1]=DATE_MONATE1
	monates[2]=DATE_MONATE2
	monates[3]=DATE_MONATE3
	monates[4]=DATE_MONATE4
	monates[5]=DATE_MONATE5
	monates[6]=DATE_MONATE6
	monates[7]=DATE_MONATE7
	monates[8]=DATE_MONATE8
	monates[9]=DATE_MONATE9
	monates[10]=DATE_MONATE10
	monates[11]=DATE_MONATE11
	monates[12]=DATE_MONATE12
	days:={}
	asize(days,7)
	days[1]=DATE_WEEK1
	days[2]=DATE_WEEK2
	days[3]=DATE_WEEK3
	days[4]=DATE_WEEK4
	days[5]=DATE_WEEK5
	days[6]=DATE_WEEK6
	days[7]=DATE_WEEK7
return

************************************************
function dmy(d,lMode)
local str
if valtype(d)="L"
  lMode:=d
  d:=NIL
endif
d:=iif(d==NIL,date(),d)
lMode:=iif(lMode==NIL,.f.,lMode)
str:=alltrim(monates[month(d)])
if "ru" $ lower(getenv("LANG")) .or. "ru" $ lower(getenv("CLIP_LANG"))
    if month(d)==3 .or. month(d)==8
      str:=str+"а"
    else
      str:=left(str,len(str)-1)+"я"
    endif
endif

str:=str(day(d),2,0)+;
iif(lMode,".","")+" "+;
str+" "+;
Right(str(year(d),4,0),iif(__SetCentury(),4,2))
return str
************************************************
function mdy(d)
local str
d:=iif(d==NIL,date(),d)
str:=alltrim(monates[month(d)])
if "ru" $ lower(getenv("LANG")) .or. "ru" $ lower(getenv("CLIP_LANG"))
    if month(d)==3 .or. month(d)==8
      str:=str+"а"
    else
      str:=left(str,len(str)-1)+"я"
    endif
endif
str:=str+" "+str(day(d),2,0)+", "+;
Right(str(year(d),4,0),iif(__SetCentury(),4,2))
return str
************************************************
function cmonth(d)
local ret:=''
if valtype(d)=="D"
   ret=monates[month(d)]
endif
return ret
*****************************************************************
function ntocmonth(d)
local ret:=''
if valtype(d)=="N" .and. d>0 .and. d<13
   ret=monates[d]
endif
return ret
*****************************************************************
function cdow(var)
local str:="",dn
if valtype(var)=='D'
   dn=dow(var)
   str=days[dn]
endif
if valtype(var)=='N' .and. var>0 .and. var<8
      str=days[var]
endif
return str
*****************************************************************
function ntocdow(var)
local str:="",dn
if valtype(var)=='N' .and. var>0 .and. var<8
      str=days[var]
endif
return str
********************************************************************
func dow_rus(var)
return cdow(var)
********************************************************************
function maxday(xxx)
return lastdayom(xxx)
********************************************************************
func last_day(dat)  //"D"-последний день месяца
return eom(dat)
********************************************************************
function maxdayg(xxx)
local i,x
if valtype(xxx)=="N"
   x=ctod("01/01/"+alltrim(str(xxx,4,0)))
endif
if valtype(xxx)=="D"
  x=xxx
endif
  for i=360 to 368
    if day(x+i)==day(x)
       return i
    endif
  next
return 0
************************************************
function date_rus(var)
local str:="",ccc,str_mon
if empty(var) .and. valtype(var)="D"
   return "___ ___________ _____"
endif

if valtype(var)=='N'
   if var<1 .or. var>12
      str=space(len(monates[1]))
   else
      str=monates[var]
   endif
endif
if valtype(var)=='D'
   str_mon=" "+alltrim(monates[month(var)])
   if month(var)==3 .or. month(var)==8
      ccc="а"
      str_mon=rtrim(str_mon)+ccc
   else
      ccc="я"
      str_mon=substr(str_mon,1,len(str_mon)-1)+ccc
   endif
   str=str(day(var),2,0)+" "+str_mon+" "+str(year(var),4,0)+" г."
endif
return str
********************************************************************
func date_r(dat)
return date_rus(month(dat))+str(year(dat))+" г."
********************************************************************
* test for sdtod()
******
*local i,m,d1,d2
*m:={"01.02.03","02/03/04","20050607","3k05","2к04","1q03","3m05","2м04","3n05","2н04","11w03"}
*? week(date())
*for i=1 to len(m)
*	? sdtod(m[i],@d1,@D2),d1,d2
*next
*?
********************************************************************
function sdtod(s,d1,d2)
	local i, forms:={"dd.mm.yy","yy.mm.dd","mm.dd.yy"}
	local s1,s2,s3
	d1:=stod("        ")
	d2:=stod("        ")
	s:=strtran(s," ","")
	s:=strtran(s,"/",".")
	s:=strtran(s,"-",".")
	d1 := stod(s)
	if !empty(d1) .and. d1==stod(dtos(d1))
		d2:=d1
		return .t.
	endif
	for i=1 to len(forms)
		d1 := ctod(s,forms[i])
		if !empty(d1) .and. d1==ctod(dtoc(d1,forms[i]),forms[i])
			d2:=d1
			exit
		endif
	next
	if !empty(d1)
		return .t.
	endif
	if !isdigit(s)
		return .f.
	endif
	for i=1 to len(s)
		if !isdigit(substr(s,i,1))
			exit
		endif
	next
	s1 := padl(substr(s,1,i-1),2,"0")
	s3 := substr(s,i)
	for i=1 to len(s3)
		if isdigit(substr(s3,i,1))
			exit
		endif
	next
	s2 := upper(substr(s3,1,i-1))
	s3 := substr(s3,i+1)
	if s2 $ [KQК]     /* quartel */
		s1 := val(s1)
		if s1<1 .or. s1>4
			return .f.
		endif
		s1 := (s1-1)*3+1
		d1 := ctod(s3+"."+str(s1,2,0)+".01","yy.mm.dd")
		d2 := ctod(s3+"."+str(s1+2,2,0)+".01","yy.mm.dd")
		d2 := eom(d2)
		return .t.
	elseif s2 $ [MМ]  /* month   */
		i := val(s1)
		if i<1 .or. i>12
			return .f.
		endif
		d1 := ctod(s3+"."+s1+".01","yy.mm.dd")
		d2 := eom(d1)
		return .t.
	elseif s2 $ [WNН] /* week    */
		s1 := val(s1)
		if s1<1 .or. s1>60
			return .f.
		endif
		d1 := ctod(s3+".01.01","yy.mm.dd")
		d1 += (s1-2)*7
		while week(d1)<s1
			d1++
		end
		d1++
		d2:=d1+6
		return .t.
	else
		return .f.
	endif
return .f.
********************************************************************
function ascDateTime(d,t)
	local dt,ret:=""
	local m := {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
	local w := {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"}
	if valtype(d) != "D"
		d := date()
	endif
	if valtype(t) != "C"
		t := time()
	endif
	dt:=dt_create(d,t)
	dt:=dt_add(dt,dt_create(0,0,0,0,timezone(),0,0))
	dt:=dt_normalize(dt)
	ret += w[dow(dt_date(dt))]+","
	ret += " "+ntoc(dt_day(dt),10,2,"0")
	ret += " "+m[dt_month(dt)]
	ret += " "+str(dt_year(dt),4,0)
	ret += " "+ntoc(dt_hour(dt),10,2,"0")
	ret += ":"+ntoc(dt_min(dt),10,2,"0")
	ret += ":"+ntoc(dt_sec(dt),10,2,"0")
	ret += " GMT"
return ret

