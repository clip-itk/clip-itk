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

