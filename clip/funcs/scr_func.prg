/*
    Copyright (C) 2001  ITK
    Authors : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#define NO_PGCH

#include "box.ch"
#include "lang.ch"

#ifdef __CLIP__
  #define mprompt prompt
  #define MPROMPT PROMPT
  #define MMENU   MENU
#endif

static __Xscreen:={} // for __XsaveScreen
***************************************************************
//#command SAVE SCREEN            => __XSaveScreen()
function __XSaveScreen()
   aadd(__Xscreen,{ savescreen(), row() ,col() } )
return

***************************************************************
//#command RESTORE SCREEN         => __XRestScreen()
function __XRestScreen()
   local scr
   if len(__Xscreen)==0
      return
   endif
   scr:=atail(__Xscreen)
   restscreen(,,,,scr[1])
   setpos(scr[2], scr[3])
   asize(__Xscreen,len(__Xscreen)-1)
return

***************************************************************
function setrc(row,col)
  devpos(row,col)
return ""
***************************************************************
function alert(sMsg,mmes,colorp)
local str,i,j,k,m,n,x,y,oldcolor, scr, win:=wselect(), nwin
local row,col,mas[0],lenMas,lenMes
local color:="W+/R,W+/B,,0,N/W"
local pName, __ret:=0

if pcount()==0
   return 0
endif

while dispcount()>0
      dispend()
enddo


dispbegin()
if win!=0
	nwin:=wopen(0, 0, maxrow(.t.), maxcol(.t.), .f.)
endif
row:=row(); col:=col()
oldcolor:=setcolor()
save screen to scr
if colorp!=NIL
   color=colorp
endif

if valtype(mmes)!="A"
   mmes={"OK"}
endif

str:=sMsg
do while !empty(str)
   k=at(";",str)
   j=k
   if k==0
      j:=len(str)+1
   endif
   j=min(j,maxcol()-2)
   aadd(mas, substr(str,1,j-1) )
   str:=substr(str,j+iif(k!=0,1,0))
enddo
lenmes=len(mmes)
k=2;n=0
for i=1 to lenmes
   k+=len(mmes[i])+4
   n+=len(mmes[i])+2
next
lenMas=len(mas)
j=k
for i=1 to lenMas
   j=max(j,len(mas[i])+2)
next
setcolor(color)
x=int((maxcol()-j)/2) // -1
y=int((maxrow()-lenMas)/2) //-1

   DISPBOX( y , x , y+3+lenMas , x+j+1 , B_SINGLE+" "  )
   for i=1 to lenMas
	dispOutAt(y+i,x+1, padc(mas[i],j))
   next
   y+=i+1
   m=int((j-n)/(lenmes+1))
   x+=m+1 //+(j-m*lenmes-n)/2
   for j=1 to lenmes
      @ y,x PROMPT " "+mmes[j]+" "
      x+=len(mmes[j])+m+2
   next
dispend()
   MENU TO __ret
dispbegin()
setcolor(oldcolor)
restore screen from scr
setpos(row,col)
if nwin!=NIL
	wclose(nwin)
	wselect(win)
endif
dispend()
return __ret
****************************************************************
function messagep
local i,j,oldcolor,scr,oldCur,row,col
local mas[0],__colors:={},s
local _maxRowN:=maxRow()/2-2
local strmess:=LANG_ANYKEY_STRING
oldCur=setCursor(0)
parameters str,y,x,color
if color!=NIL
       s:=color
       while len(s)>0
	   i:=at(",",s)
	   i=iif(i==0,len(s)+1,i)
	   aadd(__colors,substr(s,1,i-1) )
	   s:=substr(s,i+1)
       enddo
else
   aadd(__colors,"w/r")
   aadd(__colors,"w+/r")
endif
if funcname("PROV_BLANK")
   return .t.
endif
if y==NIL
    y=_maxRowN
endif
do while .t.
   j=at(";",str)
   if j!=0
     aadd(mas,substr(str,1,j-1))
     str:=substr(str,j+1)
   else
    aadd(mas,str)
    exit
   endif
enddo
 row=row()
 col=col()
 save screen to scr
 j:=len(strMess)
 for i=1 to len(mas)
   j=max(j,len(mas[i]))
 next
 oldcolor=setcolor(__colors[1])
 y-=(len(mas)+1)/2
 x=iif(x==NIL,(80-j-2)/2,x)
 @ y,x clear to y+1+len(mas), x+y+3
 Dbox(y,x,y+1+len(mas),x+j+3)
   for i=1 to len(mas)
      dispOutAt( y+i,x+2, padr(mas[i],j), __colors[2] )
   next
   dispOutAt( y+1+len(mas),x+(j-len(strMess))/2+2, strMess, __colors[1] )
   inkey(0)
 setcolor(oldcolor)
 restore screen from scr
 setpos(row,col)
 setCursor(oldCur)
return .t.
****************************************************************
function message(str,y,x)
	local _maxRowN:=maxRow()/2-2
	local j,oldcolor,scr, row,col
	local oldCur:=setCursor(0)
	if funcname("PROV_BLANK")
		return .t.
	endif
	if y==NIL
		y=_maxRowN
	endif
	row=row()
	col=col()
	save screen to scr
	j=len(str)
	oldcolor=setcolor("W/R")
	x=iif(x==NIL,(80-j-2)/2,x)
	Dbox(y,x,y+2,x+j+3)
	dispOutAt( y+1,x+2, str, "W+/R")
	inkey(max(len(str)/30,1))
	clearkey()
	setcolor(oldcolor)
	restore screen from scr
	setpos(row,col)
	setcursor(oldCur)
return .t.
****************************************************************
function ColorMess(y,x,str2,colorP,mass)
local prom,x1,y1,y2,len:=1,lenStr,SPpos,chr,i,EndChoice:=.t.
local colOsn,colDop
local lenchoice
//parameters y,x,str2,colorP,mass
lenStr:=len(str2)
if mass==NIL
   mass:={}
endif
i:=len(mass)
lenchoice:=x
if colorP==NIL
   colorP:=setcolor()
endif
colOsn:=colorP
*setcolor(colorP)
dispOutAt( y,x, str2, colOsn)
x1=substr(colorP,1,at("/",colorP)-1)    && "x1/y2,y1/ "
colorP=substr(colorP,at("/",colorP)+1)
y2=  substr(colorP,1,at(",",colorP)-1)
colorP=substr(colorP,at(",",colorP)+1)
y1=   substr(colorP,1,at("/",colorP)-1)
y1=iif(y1==x1,y2,y1)
y1=iif(y1==y2,iif(x1=="W+","GR+","W+"),y1)
*setcolor(y1+"/"+y2)
colDop:=y1+"/"+y2
do while len<=lenStr
   chr=substr(str2,len,1)
   if chr==" " .and. !EndChoice
      mass[i][3]:=Len+x-2
      EndChoice:=.t.
   endif
   if !(chr==" ") .and. EndChoice
      aadd(mass,{0,0,0,0})
      i++    // Счетчик эл-ов массива
      mass[i][1]:=y
      mass[i][2]:=Len+x-1
      EndChoice:=.f.
   endif
   if (chr>="A" .and. chr<="Z") .or. (chr>="a" .and. chr<="z") .or. (chr>="0" .and. chr<="9")
      dispOutAt( y,x+len-1, chr, colDop )
   endif
   len++
enddo
if i!=0 .and. mass[i][3]=0
   mass[i][3]=Len+x-2
endif
*setcolor(old)
return mass



****************************************************************
* function otvet
* parameters str - строка сообщения
*            y,x - координаты левого верхнего угла
*            EscExit - .t. - нет зацикливания при нажатии ESC без очистки lastkey()
*            color
* ****
// OTVET() ....
// EscExit==.f. .or. NIL - не реагировать на нажатие ESC
//        ==.t. - выход
function otvet
local i,j,otv,oldcolor,scr
local row,col,mas[0],lenMas
local blD1,blD2,blN1,blN2
local _maxRowN:=maxRow()/2-2
local LenLastStr,color
local pName
parameters str,y,x,EscExit,colorP
//private __nm
local __nm
if funcname("PROV_BLANK")
   return .t.
endif
i:=1
iif(EscExit==NIL, EscExit:=.f., )
if funcname("OTVET")
   return .f.
endif
iif(y==NIL, y:=_maxRowN,)
blD1:=setkey(asc(LANG_YES_CHAR)       ,{|| in_key(__nm,.t.)})    // Д || Y
blD2:=setkey(asc(lower(LANG_YES_CHAR)),{|| in_key(__nm,.t.)})    // д || y
blN1:=setkey(asc(LANG_NO_CHAR)        ,{|| in_key(__nm,.f.)})    // Н || N
blN2:=setkey(asc(lower(LANG_NO_CHAR)) ,{|| in_key(__nm,.f.)})    // н || n
do while .t.
   j=at(";",str)
   if j!=0
     aadd(mas,substr(str,1,j-1))
     str:=substr(str,j+1)
   else
    aadd(mas,str)
    exit
   endif
enddo
row=row()
col=col()
save screen to scr
otv=.t.
lenMas:=len(mas)
 for i=1 to lenMas
   j=max(j,len(mas[i]))
 next
j=max(j,len(mas[len(mas)])+8)
color=IIF(colorP=NIL, "W/R,W+/R,,0,N/W", colorP)
oldcolor=setcolor(color)
x=iif(x==NIL,(80-j-7)/2,x)
y-=lenMas/2
LenLastStr=len(mas[lenMas])
do while .t.
   IIF(colorP=NIL, setcolor("W/R"), setcolor(color) )
   Dbox(y,x,y+1+lenMas,x+j+3)
   if EscExit
      colorMess ( y, x+3, " Esc - none " )
   endif
   IIF(colorP=NIL,setcolor("W+/R,N/W,,0,W+/R"), )
   for i=1 to lenMas
     dispOutAt( y+i,x+2, mas[i] )
   next
   i--
   @ y+i,x+2+LenLastStr+1 MPROMPT LANG_YES_STRING
   @ y+i,x+2+LenLastStr+5 MPROMPT LANG_NO_STRING
   MMENU TO __NM
   do case
      case __nm=0 .and. EscExit
	  keyboard chr(27)
	  otv:=.f.
      case __nm=1
	  otv=.t.
      case __nm=2
	  otv=.f.
   endcase
   if lastkey()=13
      exit
   endif
   if lastkey()=27 .and. EscExit
      exit
   else
      clearkey()
   endif
enddo
setkey(asc("Y")       ,blD1)    // Д || Y
setkey(asc("y"),blD2)    // д || y
setkey(asc("N")        ,blN1)    // Н || N
setkey(asc("n") ,blN2)    // н || n
if !EscExit
   clearkey()
endif
setcolor(oldcolor)
restore screen from scr
setpos(row,col)
return otv
******


static proc in_key(nm,otv)
do case
case (nm=1.and.otv) .or. (nm=2.and.!otv)
     keyboard chr(13)
case nm=1.and.!otv
     keyboard chr(4)+chr(13)
case nm=2.and.otv
     keyboard chr(19)+chr(13)
endcase
return
*******************************************************************
function readkeyb(x1,x2,str,var,str2,var2,colors,stringBox,TopMess, BotMess)
local getlist:={},scr:=savescreen(),old
local oldcol:=col(),oldrow:=row(),oldconf:=set(27,.t.)
local lenstr,lenvar,x
memvar _var
private _var
//old_fixed:=set(2,.f.)
old=iif( colors==NIL,setcolor(),setcolor(colors))
set cursor on
lenstr=len(str)
if valtype(str2)!="U"
  lenstr=max(len(str),len(str2))
endif
iif( topMess==NIL, topMess:='', )
iif( botMess==NIL, botMess:='', )
if len(topMess)>lenstr .or. len(botMess)>lenstr
   lenstr=max( len(topMess), len(botMess) )
endif
if valtype(x1)=="U" .or. valtype(x2)=="U"
   x1=int(maxrow()/2)-2
   x2=int((maxcol()-lenstr)/2)
endif
if valtype(str2)=="U"
  dbox(x1,x2,x1+3,x2+lenstr+1,,stringBox,TopMess,BotMess)
else
  dbox(x1,x2,x1+5,x2+lenstr+1,,stringBox,TopMess,BotMess)
endif
dispOutAt( x1+1,x2+1, padc(alltrim(str),lenstr) )
if valtype(str2)!="U"
  dispOutAt( x1+3,x2+1, padc(alltrim(str2),lenstr) )
endif
if funcname("PROV_BLANK") .or. funcname("PRINTBLANK")
  dispOutAt( x1+2,x2+1, padc(var,lenstr) )
  if valtype(var2)!="U"
     dispOutAt( x1+4,x2+1, padc(var2,lenstr) )
  endif
else
  _var=var
  lenvar=slen("_var")
  x=int(max(1,(lenstr-lenvar)/2+1))
  if valtype(var)=="C" .and. "->"$var
    @ x1+2,x2+x get &var picture "@K@S"+alltrim(str(lenstr))
  else
    @ x1+2,x2+x get var picture "@K@S"+alltrim(str(lenstr))
  endif
  if valtype(var2)!="U"
     _var=var2
     lenvar=slen("_var")
*     lenvar=slen(var2)
     x=int(max(1,(lenstr-lenvar)/2+1))
     @ x1+4,x2+x get var2 picture "@K@S"+alltrim(str(lenstr))
   endif
  read
endif
setpos(oldrow,oldcol)
set(27,oldconf)
setcolor(old)
restore screen from scr
return var

*****************************************************
function Say( Row, Col, string, pict, colors)
	iif ( colors==NIL, colors:=setcolor(), )
	if pict==NIL
		DevPos( Row, Col ) ; DevOut( string , colors )
	else
		DevPos( Row, Col ) ; DevOutPict( string, pict , colors )
	endif
return .t.

*****************************************************
function copy_scr(x1,x2,x3,x4,x5,x6,x7,x8)
	local scr
	scr=SAVESCREEN(x1,x2,x3,x4)
	RESTSCREEN(x5,x6,x7,x8,scr)
RETURN

***********************************
function machoice(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20)
return achoice(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20)
***********************************
function savecursor()
	local ret:=map()
	ret:row:=row()
	ret:col:=row()
	ret:cursor:=setcursor()
	ret:ccursor:=csetcurs()
return ret
***********************************
function restcursor(m)
	if valtype(m)=="O"
		if "ROW" $ m .and. "COL" $ m
			devpos(m:row,m:col)
		endif
		if "CURSOR" $ m
			setcursor(m:cursor)
		endif
		if "CCURSOR" $ m
			csetcurs(m:ccursor)
		endif
	endif
return
***********************************
function screenstr(nRow,nCol,nCount)
	nRow  :=iif(nRow  ==NIL,0,nRow)
	nCol  :=iif(nCol  ==NIL,0,nCol)
	nCount:=iif(nCount==NIL,0,maxcol()-nCol+1)
return  savescreen(nRow,nCol,nRow,nCol+nCount )

***********************************
function __WAIT(xMsg)
   local nKey, bBlock
   if xMsg==NIL
      ? "Press any key to continue..."
   else
      ? xMsg
   endif
   do while (.T.)
      nKey:= InKey(0)
      if ((bBlock:= SetKey(nKey)) != Nil)
	 eval(bBlock, procname(1), procline(1), "")
	 loop
      endif
      if (nKey >= 32 .AND. nKey <= 255)
	 ?? Chr(nKey)
      else
	 nKey:= 0
      endif
      exit
   enddo
   return Chr(nKey)

***********************************

***********************************
Function dispbox(top, left, bottom, right, xType,color)
	if !set(_SET_DISPBOX)
		return dispboxTerm(top, left, bottom, right, xType,color)
	else
		return dispboxSay(top, left, bottom, right, xType,color)
	endif
return

***********************************
Function dispboxSay(top, left, bottom, right, xType,color)
	local ch,ch1,ch2,x,y,sStyle
	local row:=row(),col:=col()
	local d_string :=[╔═╗║╝═╚║], s_string :=[┌─┐│┘─└│]
	dispbegin()
	if valtype(xType)=="N"
		sStyle:=iif(xType==1,s_string,d_string)
	else
		sStyle:=iif(valtype(xType)=="C",xType,B_SINGLE)
		sStyle := strtran(sStyle,B_DOUBLE,d_string)
		sStyle := strtran(sStyle,B_SINGLE,s_string)
	endif
	bottom:=max(top,bottom)
	right:=max(left,right)
	if len(sStyle)<8
		padr(sStyle,8,left(sStyle,1))
	endif
	if len(sStyle)>8
		ch:=replicate(substr(sStyle,9,1),right-left+1)
		for x=top to bottom
			dispoutat(x,left,ch,color)
		next
	endif
	if top==bottom
		dispoutat(top,left,replicate(substr(sStyle,2,1),right-left+1),color)
	elseif left==right
		ch:=substr(sStyle,8,1)
		for x=top to bottom
			dispoutat(x,left,ch,color)
		next
	else
		ch1:=substr(sStyle,8,1)
		ch2:=substr(sStyle,4,1)
		for x=top to bottom
			dispoutat(x,left,ch1,color)
			dispoutat(x,right,ch2,color)
		next
		dispoutat(top,left,replicate(substr(sStyle,2,1),right-left+1),color)
		dispoutat(bottom,left,replicate(substr(sStyle,6,1),right-left+1),color)
		dispoutat(top,left,substr(sStyle,1,1),color)
		dispoutat(top,right,substr(sStyle,3,1),color)
		dispoutat(bottom,left,substr(sStyle,7,1),color)
		dispoutat(bottom,right,substr(sStyle,5,1),color)
	endif
	setpos(row,col)
	dispend()
return

***********************************
Function winbuf_dispbox(winbuffer,top, left, bottom, right, xType,color)
	local ch,ch1,ch2,x,y,sStyle
	local d_string :=[╔═╗║╝═╚║], s_string :=[┌─┐│┘─└│]
	if valtype(xType)=="N"
		sStyle:=iif(xType==1,s_string,d_string)
	else
		sStyle:=xType
		sStyle := strtran(sStyle,B_DOUBLE,d_string)
		sStyle := strtran(sStyle,B_SINGLE,s_string)
	endif
	bottom:=max(top,bottom)
	right:=max(left,right)
	if len(sStyle)<8
		padr(sStyle,8,left(sStyle,1))
	endif
	if len(sStyle)>8
		ch:=replicate(substr(sStyle,9,1),right-left+1)
		for x=top to bottom
			winbuf_out_at(winbuffer,x,left,ch,color)
		next
	endif
	if top==bottom
		winbuf_out_at(winbuffer,top,left,replicate(substr(sStyle,2,1),right-left+1),color)
	elseif left==right
		ch:=substr(sStyle,8,1)
		for x=top to bottom
			winbuf_out_at(winbuffer,x,left,ch,color)
		next
	else
		ch1:=substr(sStyle,8,1)
		ch2:=substr(sStyle,4,1)
		for x=top to bottom
			winbuf_out_at(winbuffer,x,left,ch1,color)
			winbuf_out_at(winbuffer,x,right,ch2,color)
		next
		winbuf_out_at(winbuffer,top,left,replicate(substr(sStyle,2,1),right-left+1),color)
		winbuf_out_at(winbuffer,bottom,left,replicate(substr(sStyle,6,1),right-left+1),color)
		winbuf_out_at(winbuffer,top,left,substr(sStyle,1,1),color)
		winbuf_out_at(winbuffer,top,right,substr(sStyle,3,1),color)
		winbuf_out_at(winbuffer,bottom,left,substr(sStyle,7,1),color)
		winbuf_out_at(winbuffer,bottom,right,substr(sStyle,5,1),color)
	endif
return

***********************************
function dbgshadow(x1,y1,x2,y2,attrib)
	attrib := iif(attrib==NIL,7,attrib)
	dispattr(x1+1,y2+1,x2+1,y2+2,attrib)
	dispattr(x2+1,y1+2,x2+1,y2+2,attrib)
return

