/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "mset.ch"
*-----------------*
* MSET() подобна SET()
*-----------------*
func mSet( par1, par2 )
static mset:={.f.,80,1,"PRN",.f.}
local ret
private varName
do case
   case par1==_MSET_DELETE
        ret=mSet[1]
        if par2!=NIL
           mSet[1]=par2
        endif
   case par1==_MSET_RIGHTBANK
        ret=mSet[2]
        if par2!=NIL
           mSet[2]=par2
        endif
   case par1==_MSET_PRINTNUM
        ret=mSet[3]
        if par2!=NIL
           mSet[3]=par2
        endif
   case par1==_MSET_PRINTNAME
        ret=mSet[4]
        if par2!=NIL
           mSet[4]=par2
        endif
   case par1==_MSET_PROGRESS
        ret=mSet[5]
        if par2!=NIL
           mSet[5]=par2
        endif
endcase
return ret
