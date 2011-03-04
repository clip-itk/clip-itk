/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
***************************************************************
function getClrPair(color, num )
  local beg,end
  beg:=iif(num==0,0,at(",",color,num))
  end:=at(",",color,num+1)
  end:=iif(end==0,len(color), end)
return substr(color, beg+1, end-beg)
*****************************
*  getSayColor( number, color ) - Returns the desired color set from the
*                                 strings of colors
*  number - desired color number ( 1 by default )
*  color  - from which line to take ( SetColor() by default )
*****************************
FUNC getSayColor( number,color )
local mass[0], pos
IIF ( number==NIL, number:=1,)
IIF ( color==NIL, color:=setColor(), )
pos=1
do while !(color=="")
   if (pos:=at( "," ,color))!=0
      aadd( mass, substr( color,1, pos-1 ) )
      color=substr ( color,pos+1 )
   else
      aadd( mass, substr( color,1) )
      color=""
   endif
enddo
return IIF ( number > len( mass ), "", mass[number] )
*
*****************************
*  getDrawColor( chrColor ) - Change in the line of colors the first element by chrColor
* * * * * * *
*  chrColor  - symbol's color
*  color
*****************************
FUNC getDrawColor( chrColor, color )
local ret:="", pos
IIF ( color==NIL, color:=setColor(), )
IIF (type("chrColor")=="N", chrColor:=alltrim(str(chrColor)), )
if (pos:=at("/", color))!=0
    color=chrColor+substr(color, pos)
endif
return color
***************************************************************
