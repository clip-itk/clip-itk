/*   Тест библиотеки gd					     */
/*   Copyright (C) 2001  ITK                                 */
/*   Author  : Alena Kornilova (alena@itk.ru)                */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html  */

#define PI		3.14159265358979323846	/* pi */
#include "gdinfo.ch"

local gd, red, white, black, blue, yellow, fon
clear screen

im=GdImageNew(200, 200)
// создать цвет
white=im:newColor(255, 255, 255) // белый
black=im:newColor() // черный
red=im:newColor(255) // красный
blue=im:newColor(,,255) // синий
? im:info( GDINFO_COLORRED, blue)
? im:info( GDINFO_COLORGREEN, blue)
? im:info( GDINFO_COLORBLUE, blue)
?
yellow=im:newColor(255, 255)
fon=im:newColor(0xDE,0xEF,0xF5)
// заполнить все белым цветом
im:fill(0, 0, fon)
im:filledArc(100, 100, 45, 45, yellow)
// создать brush
luch=GdImageNew(3, 3)
luch:fill(0, 0, luch:newColor(255, 255))
im:setBrush(luch)
cx =100
cy = 100
for i=0 to 180 step 45
	x1 = cos(PI*i/180) * 60 + cx
	y1 = sin(PI*i/180) * 60 + cy
	x2 = cos(PI*(i+180)/180) * 60 + cx
	y2 = sin(PI*(i+180)/180) * 60 + cy
	im:line(x1, y1, x2, y2, GDSTYLE_BRUSHED)
next
im:filledArc(93, 90, 6, 6, blue)
im:filledArc(107, 90, 6, 6, blue)
im:string("Hello world!", 50, 50, GDFONT_LARGE, black)
im:stringVector("Привет мир!", 50, 150, 300, 0, black)
im:filledTruncSector(100, 100, 30, 30, 26, 26, 40, 140, red)
im:toPNG("asdf.png")
im:toJPEG("|-")

return .t.
