/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
*********************************************************
 /* time format "hh:mm:ss" convert to numeric seconds " */
function ssec(t)
	local h:=0,m:=0,s:=0,x
        h:=val(t)
        x:=at(":",t)
        if x>0
        	m:=val(substr(t,x+1))
        endif
        x:=at(":",t,2)
        if x>0
        	s:=val(substr(t,x+1))
        endif
return s+m*60+h*3600

*********************************************************
 /* convert seconds value to time format "hh:mm:ss" */
function tstring(sec)
return  ntoc((sec/3600)%24,10,2,"0")+":"+;
	ntoc((sec/60)%60,10,2,"0")+":"+;
	ntoc(sec%60,10,2,"0")

*********************************************************
 /* from clipper S`87 */
function elaptime(time1,time2)
	local t1,t2

        t1:=iif(valtype(time1)=="C", ssec(time1),time1)
        t2:=iif(valtype(time2)=="C", ssec(time2),time2)

return tstring(iif(t2<t1,86400,0)+t2-t1)
