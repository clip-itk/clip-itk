/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "box.ch"

**************************************
*  DBox - рисует box с тенью
*  TypeBox  - символы рамки
*  ColorOsn - осноной цвет
*  StrTop   - верхняя подсказка
*  StrBot   - нижняя  подсказка
*  ColorDop - цвет тени
**************************************
procedure sbox(t,l,b,r,p1,p2,p3,p4,p5)
return dbox(t,l,b,r,p1,,p3,p4,p5)
**************************************

procedure DBox(T,L,B,R,ColorOsn,TypeBox,StrTop,StrBot,ColorDop)
	local old,len,chr,str, oldCur:=setCursor(0)
	local _maxRowN:=maxRow()
	if ColorOsn==NIL
   		ColorOsn=setcolor()
	endif
	if ColorDop==NIL
   		ColorDop=7
	endif
	old=setcolor(ColorOsn)
        if typeBox==NIL
		@ T,L TO B,R DOUBLE
                @ T+1,L+1 clear to B-1,R-1
        else
		@ T,L,B,R Box TypeBox
                @ T+1,L+1 clear to B-1,R-1
        endif
	if B < _maxrowN
#ifndef __CLIP__
     		draw_rect(B+1,iif(L+2>0,L+2,0),B+1,iif(R<79,R+1,79),ColorDop)
#else
     		dispattr(B+1,iif(L+2>0,L+2,0),B+1,iif(R<79,R+1,79),ColorDop)
#endif
	endif
	if R<79
#ifndef __CLIP__
   		draw_rect(iif(T+1>0,T+1,0),R+1,iif(B<_maxRowN,B+1,B),R+iif(R==78,1,2),ColorDop)
#else
   		dispattr(iif(T+1>0,T+1,0),R+1,iif(B<_maxRowN,B+1,B),R+iif(R==78,1,2),ColorDop)
#endif
	endif
	if StrTop!=NIL
   		str=alltrim(padc(StrTop,R-L))
   		len=len(StrTop)
   		@ T,L+(R-L-len)/2 say StrTop
	endif
	if StrBot!=NIL
   		str=alltrim(padc(StrBot,R-L))
   		len=len(StrBot)
   		@ B,L+(R-L-len)/2 say StrBot
	endif
	setcolor(old)
	setcursor(oldCur)
return
**************************************
function draw_rect(x1,y1,x2,y2,color)
	dispattr(x1,y1,x2,y2,color)
return 0
