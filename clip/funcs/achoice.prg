/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "inkey.ch"
#include "achoice.ch"

memvar __ac_data

Func achoice( nT,nL,nB,nR,_massP,__lMass,FunName,nPos,nLine,color,BoxType,topMess,BotMess )
local retVal:=0,bb,column,lVal, i, oldCursor,oldcolor,_lmass:={}
local maxStrSS,__bbbb
local massp:=_massp
private __ac_data
for i=1 to len(massp)
	if len(massp[i])==0 .or. valtype(massp[i]) != "C"
		exit
	endif
next
i--
i:=max(i,1)
if i>len(massP) .and. len(massp)==0
	massp:=aclone(_massp)
	aadd(massP,"")
	__lMass:={.f.}
endif
__ac_data:=map()
__ac_data:lenMass:=i //len(massP)
__ac_data:nt:=nt
__ac_data:nl:=nl
__ac_data:nb:=min(nt+i-1+iif(pcount()>10,2,0),nb)
__ac_data:nr:=nr
__ac_data:massp:=massp
__ac_data:funname:=funname
__ac_data:nRowMass:=1
__ac_data:boxFlag:=.f.
__ac_data:flagUserF:=(!empty(FunName) .and. valtype(funname) $ "CB" )
__ac_data:x:=NIL
__ac_data:exit:=.t.
if empty(__ac_data:massP) .or. valtype(__ac_data:massP[1])!="C"
   return 0
endif
if empty(__ac_data:massP)
   return 0
endif
oldCursor:=setCursor(0)
oldcolor:=setcolor()
if valtype(color)=="C"
   setcolor(color)
else
  color:=setcolor()
end
if __lMass==NIL
   asize(_lMass,__ac_data:lenMass)
   afill(_lMass,.t.)
elseif valType(__lMass)=="L"
   asize(_lMass,__ac_data:lenMass)
   afill(_lMass,__lmass)
else
   _lmass=aclone(__Lmass)
endif
for i=len(_lMass) to __ac_data:lenMass
	aadd(_lMass,.t.)
next
for i=1 to __ac_data:lenMass
   if valtype(_lmass[i])=="C"
      __bbbb=_lmass[i]
      _lmass[i]=&__bbbb
   endif
   if valtype(_lmass[i])!="L"
      _lmass[i]=.t.
   endif
   if _lmass[i]
      __ac_data:exit:=.f.
      exit
   endif
next
__ac_data:_lmass:=_lmass
nPos:=max(iif(nPos==NIL, 1,nPos),1)
nPos:=min(__ac_data:lenMass,nPos)

if pcount()>10
   dBox(__ac_data:nT,__ac_data:nL,__ac_data:nB,__ac_data:nR,,BoxType,TopMess,BotMess)
   __ac_data:boxFlag:=.t.
else
    __ac_data:nT--; __ac_data:nL--; __ac_data:nB++; __ac_data:nR++
endif
bb := TBrowseNew(__ac_data:nT+1, __ac_data:nL+1, __ac_data:nB-1, __ac_data:nR-1)

if valtype(nLine)=="N"
	nLine++
endif
nLine:=max(iif(nLine==NIL, nPos,nLine),1)
if nLine > nPos
	nLine :=1
endif
nLine:=min( __ac_data:nB-__ac_data:nT-1,nLine)

bb:headSep :=""
bb:colSep := ""
bb:skipBlock := {|x| skipper(x)}
bb:goBottomBlock:={||__ac_data:nRowMass:=__ac_data:lenMass}
maxStrSS:=__ac_data:nR-__ac_data:nL+1
column := TBColumnNew( , {|| iif(memvar->__ac_data:nRowMass<=0,"",padr(memvar->__ac_data:massP[memvar->__ac_data:nRowMass],maxStrSS))})

column:cargo:=__ac_data:lenMass
column:colorBlock:={|x| iif( __ach_color_block() ,{1,2},{5,2})}
bb:addColumn(column)

eval(bb:skipBlock,npos-1)
bb:rowPos:=nLine
bb:forceStable()

RetVal:=runTBm( bb )
bb:deHilite()
setCursor(oldCursor)
setcolor(OLDcolor)
return RetVal

*****************************
static func runTBm(bb)
local vyb,i,nnn
local scr,curCol,CurRow
local retVal:=0,mode:=2
local nkey:=0, mKey:=0, lMore:=.t.
local nskip,xskip,oldlen
local bKeyBlock, scrTop:=savescreen(__ac_data:nT,__ac_data:nL,__ac_data:nT,__ac_data:nR)
local ufunc:=__ac_data:FunName
memvar __ac_data

    lMore := .t.
    scr:=savescreen(__ac_data:nT+1,__ac_data:nR,__ac_data:nT+1,__ac_data:nR)
    while ( lmore )

       //dispbegin()
       while ( !bb:stabilize() )
       enddo
       //dispend()

       mode:=4
       if __ac_data:exit
	   bb:dehilite()
	   oldLen := __ac_data:lenMass
	   if valtype(uFunc) == "C" .and. __ac_data:flagUserF
	      mode:=&uFunc.(mode,__ac_data:nRowMass,bb:rowpos-1,bb)
	   elseif valtype(uFunc) == "B" .and. __ac_data:flagUserF
	      mode:=eval(uFunc,mode,__ac_data:nRowMass,bb:rowpos-1, bb)
	   endif
	   __ac_data:lenMass:=min(__ac_data:lenMass,len(__ac_data:massp))
	   if oldLen != __ac_data:lenMass
	     bb:refreshAll()
	   endif
	   return 0
       endif
       for i=1 to __ac_data:lenMass
	   if __ach_color_block(i)
	      mode:=3
	      exit
	   endif
       next
       if  mode==4
	    lmore:=.f.
	    retVal:=0
       elseif !__ach_color_block(__ac_data:nRowMass)
	   if __ac_data:nRowMass==1
		 keyBoard chr(K_DOWN)
	   elseif __ac_data:nRowMass==__ac_data:lenMass
	       keyBoard chr(K_UP)
	   elseif lastkey()==K_ENTER .or. lastkey()==K_ESC
		 keyBoard chr(K_UP)
	   else
	       keyBoard chr(lastkey())
	   endif
       endif
       curCol:=col()
       curRow:=row()

       if ( bb:stable .and. mode!=4 )
	  if __ac_data:boxFlag==.t.
		restscreen(__ac_data:nT,__ac_data:nL,__ac_data:nT,__ac_data:nR,scrTop)
		NNN:=alltrim(str(__ac_data:nRowMass,4,0))+":"+alltrim(str(__ac_data:lenMass,4,0))
		dispOutAt( __ac_data:nT,__ac_data:nR-len(NNN), NNN  )
		if __ac_data:nRowMass!=1
		   dispOutAt( __ac_data:nT+1,__ac_data:nR, "*")
		else
		   restscreen(__ac_data:nT+1,__ac_data:nR,__ac_data:nT+1,__ac_data:nR,scr)
		endif
		if __ac_data:nRowMass!=__ac_data:lenMass
		   dispOutAt(__ac_data:nB-1,__ac_data:nR, "*" )
		else
		   restscreen(__ac_data:nB-1,__ac_data:nR,__ac_data:nB-1,__ac_data:nR,scr)
		endif
		//setPos(curRow, curCol)
		dispOutAt(curRow, curCol,"")
	   endif
	   mKey:=0
	   do while .t. //!__ac_data:exit
		   nKey := InKey(0)
		   bb:hitTop := bb:hitBottom := .f.
		   if ( (bKeyBlock:=setkey(nKey))!=NIL )
		      eval(bKeyBlock,procname(),procline(),readvar())
		   else
		      exit
		   endif
	   enddo

       endif

       do case
       case ( nKey == K_ENTER) .and. !__ac_data:flagUserF
	    bb:hitTop := bb:hitBottom := .f.
	    retVal:=__ac_data:nRowMass
	    mode:=0
	    lmore:=.f.
	    exit
       case ( nKey == K_ESC)  .and. !__ac_data:flagUserF
	    retVal:=0
	    mode:=0
	    lmore:=.f.
	    exit
       case ( nKey == K_LEFT .or. nkey==K_RIGHT )  .and. !__ac_data:flagUserF
	    retVal:=0
	    mode:=0
	    lmore:=.f.
	    exit
       case ( nKey == K_DOWN)
	    bb:down()
	    mode:=0
       case ( nKey == K_UP)
	    bb:up()
	    mode:=0
       case ( nKey == K_PGUP )
	    mode:=0
	    bb:hitTop := bb:hitBottom := .f.
	    xskip=0-(__ac_data:nB-__ac_data:nT-2)
	    nskip := eval(bb:skipBlock,xskip)
	    if nskip>xskip
		bb:rowPos:= max(1,bb:rowpos-nskip+xskip)
	    endif
	    bb:refreshAll()
	    if nskip == 0
		bb:hitTop := .t.
	    endif
       case ( nKey == K_PGDN )
	    mode:=0
	    bb:hitTop := bb:hitBottom := .f.
	    xskip := __ac_data:nB-__ac_data:nT-2
	    nskip := eval(bb:skipBlock,xskip+1)
	    nskip := eval(bb:skipBlock,0-nskip)
	    nskip := eval(bb:skipBlock,xskip)
	    if nskip<xskip
		bb:rowPos:=min(bb:rowpos+nskip-xskip,__ac_data:nRowMass)
	    endif
	    if __ac_data:nRowMass == len(__ac_data:massp)
		bb:rowPos := __ac_data:nB-__ac_data:nT-1
	    endif
	    bb:rowPos := max(1,bb:rowpos)
	    bb:refreshAll()
	    if nskip == 0
		bb:hitBottom := .t.
	    endif
       case ( nKey == K_CTRL_HOME ) .or. nKey==K_HOME .or. nKey==K_CTRL_PGUP
	    mode:=0
	    __ac_data:nRowMass:=1
	    bb:rowPos:=1
	    bb:refreshAll()
       case ( nKey == K_CTRL_END )  .or. nKey==K_END .or. nKey==K_CTRL_PGDN
	    mode:=0
	    bb:goBottom()
    //	    bb:refreshAll()
       case (nKey>32 .and. nKey<255) .and. !__ac_data:flagUserF
	    mode:=firstChr(nKey)
	    do case
		   case mode==2
		       bb:refreshCurrent()
		   case mode==3
		       bb:refreshAll()
	    endcase
       endcase
       if valtype(uFunc) $ "CB" .and. __ac_data:flagUserF //.and. nextkey()==0
	    bb:forceStable()
	    bb:dehilite()
	    IF bb:hitTop
	       mode:=1
	    ENDIF
	    IF bb:hitBottom
	       mode:=2
	    ENDIF
	    oldLen := __ac_data:lenMass
	    if valtype(uFunc) == "C"
		mode:=&uFunc.(mode,__ac_data:nRowMass,bb:rowpos-1,bb)
	    else
		mode:=eval(__ac_data:FunName,mode,__ac_data:nRowMass,bb:rowpos-1, bb)
	    endif
	    __ac_data:lenMass:=min(__ac_data:lenMass,len(__ac_data:massp))
	    if oldLen != __ac_data:lenMass
	      bb:refreshall()
	    endif
	    if mode==0
	       retval:=0
	       lmore:=.f.
	    endif
	    if mode==3
		 mode:=FirstChr(lastkey())
	    endif
	    if mode==1
	       retval:=__ac_data:nRowMass
	       lmore:=.f.
	    endif
	    do case
	      case mode==2 .or. mode==4
		   bb:refreshCurrent()
	      case mode==5 .or. mode==3
		   bb:refreshAll()
	   endcase
       endif
    enddo
return retVal
****
*       Skipper()

*****************************************************
static func Skipper(n)
    local i:=0
    i=__ac_data:nRowMass
    __ac_data:lenMass:=min(__ac_data:lenMass,len(__ac_data:massp))
    __ac_data:nRowMass:=max(1,__ac_data:nRowMass)
    __ac_data:nRowMass:=min(__ac_data:lenMass,__ac_data:nRowMass)
    __ac_data:nRowMass+=n
    __ac_data:nRowMass:=max(1,__ac_data:nRowMass)
    __ac_data:nRowMass:=min(__ac_data:lenMass,__ac_data:nRowMass)
return __ac_data:nRowmass-i
*****************************************************
* по 1-му символу
static func firstChr(chrKey)
local ccc,retVal
ccc:=upper(chr(chrKey))
retVal:=ascan(__ac_data:massP,{|elem|iif(upper(substr(ltrim(elem),1,1))==ccc,.t.,.f.)},__ac_data:nRowmass+1)
if retVal==0 .and. __ac_data:nRowMass >= 1
   retVal:=ascan(__ac_data:massP,{|elem|iif(upper(substr(ltrim(elem),1,1))==ccc,.t.,.f.)},1)
endif
if retVal!=0
   __ac_data:nrowMass:=retVal
endif
return 3

static function  __ach_color_block(x)
  local t, nrow
  nrow:=iif(x==NIL,__ac_data:nRowMass,x)
  if nrow<1 .or. nrow>__ac_data:lenmass
     return .f.
  endif
  t:=valtype(__ac_data:_lMass[nRow])
  if t=="C"
     return &(__ac_data:_lMass[nRow])
  endif
  if t=="L"
     return __ac_data:_lMass[nRow]
  endif
  if t=="B"
     return eval(__ac_data:_lMass[__ac_data:nRowMass])
  endif
return .f.
