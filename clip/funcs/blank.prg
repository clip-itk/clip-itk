/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
memvar vk, ___s1,___s2,___s3, _pfile,_pnumber, _usl, _nesc
**********************************************************
function run_blank(file,stdin)
	local s

	private vk:=CRLF

	s:=memoread(file)
	s:=strtran(s,"&\r","")

return _run_blank(s,stdin)

**********************************************************
static function _run_blank(tex,stdin,tipv,sbros)
static pfile:=""
local str,f1xx,str1,retstr:="",i:=0,n:=0,scr,nsel:=select()
local ret
local prevFlProm
iif(stdin==NIL .or. valtype(stdin)!="L" ,stdin:=.f.,stdin)
private _pfile,_pnumber,_nesc:=0

if stdin
	_pfile:="|-"
	_pnumber=fopen(_pfile,1)
else
	set console off
	if tipv!=NIL .and. tipv="add" .and. empty(pfile)
		pfile=tmpfile()+".txt"
		_pnumber=fcreate(pfile)
		ret:=fclose(_pnumber)
	endif
	if tipv!=NIL .and. tipv="add"
		_pfile=pfile
		_pnumber=fopen(_pfile,2)
		fseek(_pnumber,0,2)
	else
		pfile=""
		_pfile=tmpfile()+".txt"
		_pnumber=fcreate(_pfile)
		ret=fclose(_pnumber)
		_pnumber=fopen(_pfile,2)
		fseek(_pnumber,0,0)
	endif
	save screen to scr
endif
if _pnumber==-1
   if stdin
	outlog(__FILE__,__LINE__,[cannot open file:],_pfile)
   else
	message([cannot open file:]+_pfile)
   endif
   return ""
endif

// чтобы правильно работали bSkip(), bGoTop()....
if type("__flHaveProm")!="U"
   prevFlProm:=m->__flHaveProm
   if type("__flprom")=="L"
      m->__flHaveProm:=m->__flProm
   endif
endif

str=hardcr(tex)
do while !empty(str)
   f1xx=at(vk,str)
   str1=iif(f1xx!=0,substr(str,1,f1xx+len(vk)-1),str)
   str=iif(f1xx!=0,substr(str,f1xx+len(vk)),"")
   if substr(alltrim(str1),1,1)=="*"
      i++
      loop
   else
      n++
      retstr+=str1
   endif
enddo
if select("blank")!=0
	aaaaaaaaaa(,,,,blank->progress)
endif
if stdin
	aaaaaaaaaa(,,,,.t.)
endif
aaaaaaaaaa(, n+1,"Интерпретация Бланка")
_run_blank2(retstr,stdin)
ret=fclose(_pnumber)
commit
if stdin
else
	restore screen from scr
	frename(_pfile, strtran(_pfile, "txt", "xtx"))
	frename(strtran(_pfile, "txt", "xtx"), _pfile)
	select(nsel)
endif
IIF (prevFlProm!=NIL, m->__flHaveProm:=prevFlProm,)
return _pfile
***********************************************************
static function _run_blank2(_s1,stdin)
local str,_s2,f1xx,f2xx,scr,obr:=.f.
local promstr ,nstr,buffer
local oldError, _error
private ___s3,_usl
olderror=ERRORBLOCK({|x| _error:=x, mybreak(_error)})
do while !(_s1=="")
   aaaaaaaaaa()
   Begin Sequence
       obr:=.f.
       promstr=get_end(@_s1,"#if","#endif")
       if !empty(promstr)
	  aaaaaaaaaa()
	  f1xx=at(memvar->vk,promstr)
	  _usl=substr(promstr,1,f1xx-1)
	  promstr=substr(promstr,f1xx+len(vk))
	  if &_usl
	     _run_blank2(promstr,stdin)
	  endif
	  obr:=.t.
	  //break
       endif
       promstr=get_end(@_s1,"#while","#endwhile")
       if !empty(promstr)
	  aaaaaaaaaa()
	  f1xx=at(memvar->vk,promstr)
	  _usl=substr(promstr,1,f1xx-1)
	  promstr=substr(promstr,f1xx+len(vk))
	  nstr=1
	  do while (&_usl)
	     if nstr==1
		_run_blank2(promstr,stdin)
	     else
		aaaaaaaaaa(,,,mlcount(promstr,250))
		_run_blank2(promstr,stdin)
	     endif
	     nstr++
	     if !stdin
		inkey()
	     endif
	     if lastkey()==27
		_nesc++
	     elseif lastkey()!=0
		_nesc=0
	     endif
	     if _nesc=2
	       buffer=" Цикл прекращен по клавише <ESC>! "+vk
	       fwrite(_pnumber,buffer,len(buffer))
	       exit
	     endif
	  enddo
	  obr:=.t.
	  //break
       endif
       if !obr
	  f1xx=at(memvar->vk,_s1)
	  _s2=iif(f1xx!=0,substr(_s1,1,f1xx-1),_s1)
	  _s1=iif(f1xx!=0,substr(_s1,f1xx+len(vk)),"")
	  if at(":=",_s2)!=0
	     ___s3:=alltrim(_s2)
	     _s2:=&___s3
	     _s2:=""
	     obr:=.t.
	  endif
       else
	  _s2 := ""
       endif
       do while !(_s2=="")
	   f1xx=at("#",_s2)
	   if f1xx!=0
	      ___s3=substr(_s2,f1xx)
	      do while substr(___s3,1,1)="#"
		 ___s3=substr(___s3,2)
	      enddo
	      buffer=substr(_s2,1,f1xx-1)
	      //? "a1",buffer
	      fwrite(_pnumber,buffer,len(buffer))
	      f2xx=atalpha(___s3)
	      _s2=iif(f2xx=0,"",substr(___s3,f2xx))
	      ___s3=iif(f2xx=0,___s3,substr(___s3,1,f2xx-1))
	   else
	      buffer=_s2
	      //? "a2",buffer
	      fwrite(_pnumber,_s2,len(_s2))
	      exit
	   endif
	   if !isdigit(___s3)
	      if select("blank")!=0
		 if blank->what==0
		    str=alltrim(sstr(&___s3))
		    fwrite(_pnumber,str,len(str))
		 elseif blank->what<0          //KP,PL...,Q_OBOR
		    str=sstr(&___s3)
		    fwrite(_pnumber,str,len(str))
		 else                          //BALANS-15,EKON1-11
		    str=sstr(&___s3,blank->what,val(blank->decim))
		    fwrite(_pnumber,str,len(str))
		 endif
	      else
		    str=sstr(&___s3)
		    fwrite(_pnumber,str,len(str))
	      endif
	      buffer=str
	   endif
       enddo
       if !obr
	  fwrite(_pnumber,vk,len(vk))
       endif
    End Sequence
    if !stdin
       inkey()
    endif
    if _nesc=2
      buffer=" Заполнение Бланка прервано клавишей <ESC>! "+vk
      fwrite(_pnumber,buffer,len(buffer))
      exit
    endif
enddo
ERRORBLOCK(olderror)
return
***************************************************
static function  get_end (str,begstr,endstr)
* str передавать по указателю, она будет обкушена
* возвращает строку без начальной #if и конечной #endif
local promstr,begpos,endpos,nlspace
local countv,begz,i,retstr,a,b
promstr=upper(ltrim(str))
nlspace=len(str)-len(promstr)
begstr=upper(begstr)
endstr=upper(endstr)
if !(substr(promstr,1,len(begstr))==begstr)
   return ""
endif
begpos=at(begstr,promstr)+len(begstr)
promstr=strtran(promstr,begstr,space(len(begstr)),1,1)
countv=1
do while countv>0
  a=at(begstr,promstr)
  b=at(endstr,promstr)
  do case
    case (a!=0 .and. a<b) .or. (a!=0 .and. b=0)
     promstr=strtran(promstr,begstr,space(len(begstr)),1,1)
     countv++
    case (b!=0 .and. b<a) .or. (a=0 .and. b!=0)
     promstr=strtran(promstr,endstr,space(len(endstr)),1,1)
     countv--
    case a=0 .and. b=0
     exit
  endcase
enddo
endpos=b
endpos=iif(endpos==0,len(promstr)+1,endpos)
retstr=rtrim(substr(str,begpos+nlspace,endpos-begpos))
str=substr(str,endpos+nlspace+len(endstr))
i=at(vk,str)
i=iif(i=0,0,i+len(vk))
str:=substr(str,i)
return retstr

****************************************************
static function myBreak(_error,flagm)
if _error:gencode==5
  return(0)
endif
if flagm==NIL
messagep("Вы работаете с Бланком, в котором есть ошибки. Наверняка получите;"+;
	 " что-то не то. Отредактируйте Бланк, иначе это сообщение Вам надоест.;"+;
	 " Ошибка : "+_error:description+" "+iif(empty(_error:operation),"",_error:operation)+";";
	 +iif(!empty(_error:filename),_error:filename,"") )
endif
Break(_error)
return

*****************************************************
static function sstr
parameters per,nect,dec
local n:=""
 do case
    case stype("per")=="C"
	n=per
    case stype("per")=="D"
	n=dtoc(per)
    case stype("per")=="N"
	 if valtype(nect)=="U" .or. valtype(dec)=="U"
	   n=str(per)
	 else
	   n=str(per,nect,dec)
	 endif
 endcase
return n

#include "mset.ch"
*************************************************************
*     используется для вывода на экран процента
*     выполнения в цикле DO REPEAT
*
static func aaaaaaaaaa(v,x,str,div,set)
static x1:=0,x2:=0
local _maxR,t,l,b,r,i,j
if set!=NIL .and. valtype(set)=="L"
    mset(_MSET_PROGRESS,set)
    return 0
endif
if mset(_MSET_PROGRESS)
	return 0
endif
_maxR:=maxRow()-2
T:=_maxR-2; L:=10; B:=_maxR+2; R:=70
do case
   case v<>NIL .and. v
       return 0
   case pcount()=0 .or. (pcount()=1 .and. v<>NIL .and. !v)
       x2++
       i:=(x2/x1)*100
       i:=abs(i)
       j:=iif(i>100,100,i)
       j:=int(j/2.5)
       dispOutAt( T+1,L+20, "Выполнено "+alltrim(str(i))+"%" )
       dispOutAt( T+3,L+10, replicate("█",j) )
   case pcount()==4 .and. div<>NIL
       x1+=div
       return 0
   case pcount()>1 .and. pcount()<4
       x1:=x
       x2:=0
       dbox(T,L,B,R)
       dispOutAt( T+2,L+10, padc(alltrim(str),40) )
       dispOutAt( T+3,L+10, replicate("░",40) )
endcase
return 0

***********************************
static func addScroll( x, col )
	local str:="", len, xType, mmm
	xType=valType(x)
	do case
		case xType=="L"
			len= 3
		case xType=="D"
			len= len( dtoc(x) )
		case xType=="N"
			len= len( str(x) )
		otherwise             // "C" | "M"
			len= len(x)
	endcase
	if len+col > (mmm:=mset( _MSET_RIGHTBANK ))
		str="@S"+alltrim(str(mmm-col+1))
	endif
return str

