/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "clipcfg.h"

static time_close:=.f.

**********************************************
function showtime(x,y,lSeconds,cColor,n12,lAm)

        if pcount()==0
                time_close:=.t.
        else
                time_close:=.f.
#ifdef USE_TASKS
                start(@ct_showtime(),x,y,lSeconds,cColor,n12,lAm)
#endif
        endif

return

**********************************************
function setclock()

        if pcount()==0
                time_close:=.t.
        else
                time_close:=.f.
#ifdef USE_TASKS
                start(@ct_showtime(),0,1,.t.)
#endif
        endif

return

**********************************************
function unsetclock()
        time_close:=.t.
return

**********************************************
static function ct_showtime(x,y,lSeconds,cColor,l12,lAm)
        local row,col,str,ap
        while !time_close
                str:=time()
                ap:=.f.
                if !( lSeconds==NIL .or. !lSeconds )
                        str:=substr(str,1,5)
                endif
                if l12!=NIL .and. l12
                        if val(str)>12
                                str:=padl(str(val(str)-12,2,0),2,"0")+substr(str,3)
                                ap:=.t.
                        endif
                endif
                if lAm!=NIL .and. lAm
                        str+=iif(ap,"p","a")
                endif
                //taskstop()
                dispbegin()
                row:=row(); col:=col()
                @ x,y say str color cColor
                devpos(row,col)
                //taskstart()
                dispend()
                sleep(1)
        end
return
**********************************************
