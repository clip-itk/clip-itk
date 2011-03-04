/*   GD - class                                              */
/*   Copyright (C) 2001  ITK                                 */
/*   Author  : Elena Kornilova (alena@itk.ru)                */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html  */

#include "gdinfo.ch"

function GdImageNew(p1, p2)
local obj:=map()
	obj:classname	:= "GDIMAGE"
	if valtype(p1) == "C"
		obj:fileName 	:= p1
		obj:fileType 	:= p2
		obj:image	:= gdImageCreateFromFILE(obj:fileName, obj:fileType)
		obj:sizeX	:= gdColorInfo(obj:image, GDINFO_SIZEX)
		obj:sizeY	:= gdColorInfo(obj:image, GDINFO_SIZEY)
	elseif valtype(p1) == "N" .and. valtype(p2) == "N"
		obj:sizeX	:= p1
		obj:sizeY	:= p2
		obj:fileName 	:= ""
		obj:fileType 	:= ""
		obj:image	:= gdImageCreate(obj:sizeX, obj:sizeY)
	else
		obj:sizeX	:= 0
		obj:sizeY	:= 0
		obj:fileName 	:= ""
		obj:fileType 	:= ""
		obj:image	:= -1
	endif
	obj:color	:= -1
	_recover_gdimage(obj)
return obj
***********
function _recover_gdimage(obj)
	obj:setColor	:= @__gd_setColor()
	obj:getColor	:= @__gd_getColor()

	obj:create	:= @gd_create()
	obj:fromFile	:= @gd_fromFile()
	obj:fromPNG	:= @gd_fromPNG()
	obj:fromGD	:= @gd_fromGD()
	obj:fromGD2	:= @gd_fromGD2()
	obj:fromXBM	:= @gd_fromXBM()
	obj:fromJPEG	:= @gd_fromJPEG()

	obj:destroy	:= @gd_destroy()

	obj:toFile	:= @gd_toFile()
	obj:toPNG	:= @gd_toPNG()
	obj:toGD	:= @gd_toGD()
	obj:toGD2	:= @gd_toGD2()
	obj:toJPEG	:= @gd_toJPEG()

	obj:newColor	:= @gd_newColor()
	obj:exactColor	:= @gd_exactColor()
	obj:transparent	:= @gd_transparent()
	obj:interlace	:= @gd_interlace()
	obj:compare	:= @gd_compare()
	obj:info	:= @gd_info()
	obj:getPixel	:= @gd_getPixel()
	obj:setPixel	:= @gd_setPixel()
	obj:bound	:= @gd_bound()

	obj:line	:= @gd_line()
	obj:dashedLine	:= @gd_dashedLine()
	obj:rectangle	:= @gd_rectangle()
	obj:filledRectangle	:= @gd_filledRectangle()
	obj:arc		:= @gd_arc()
	obj:filledArc	:= @gd_filledArc()
	obj:sector	:= @gd_sector()
	obj:filledSector:= @gd_filledSector()
	obj:truncSector	:= @gd_truncSector()
	obj:filledTruncSector	:= @gd_filledTruncSector()
	obj:polygon	:= @gd_polygon()
	obj:filledPolygon	:= @gd_filledPolygon()

	obj:fill	:= @gd_fill()
	obj:fillToBorder:= @gd_fillToBorder()

	obj:setBrush	:= @gd_setBrush()
	obj:setTile	:= @gd_setTile()
	obj:setStyle	:= @gd_setStyle()

	obj:char	:= @gd_char()
	obj:charUP	:= @gd_charUp()
	obj:string	:= @gd_string()
	obj:stringUP	:= @gd_stringUp()
	obj:charRotate	:= @gd_charRotate()
	obj:stringRotate:= @gd_stringRotate()
	obj:charVector	:= @gd_charVector()
	obj:stringVector:= @gd_stringVector()

	obj:cos		:= @gd_cos()
	obj:sin		:= @gd_sin()
return obj
***********
static function __gd_setColor(color)
	::color := color
return
***********
static function __gd_getColor(color)
return ::color
***********
static function gd_create(sizeX, sizeY)
	::image := gdImageCreate(sizeX, sizeY)
	if ::image < 0
		return .f.
	endif
	::sizeX	:= gdColorInfo(::image, GDINFO_SIZEX)
	::sizeY	:= gdColorInfo(::image, GDINFO_SIZEY)
return .t.
***********
static function gd_fromFile(fileName, fileType)
local ret:=.t.
	::fileName := fileName
	::fileType := fileType
	::image := gdImageCreateFromFILE(::fileName, ::fileType)
	if ::image < 0
		return .f.
	endif
	::sizeX	:= gdColorInfo(::image, GDINFO_SIZEX)
	::sizeY	:= gdColorInfo(::image, GDINFO_SIZEY)
return ret
***********
static function gd_fromPNG(fileName)
local ret:=.t.
	::fileName := fileName
	::fileType := GDFILE_PNG
	::image := gdImageCreateFromPNG(::fileName)
	if ::image < 0
		return .f.
	endif
	::sizeX	:= gdColorInfo(::image, GDINFO_SIZEX)
	::sizeY	:= gdColorInfo(::image, GDINFO_SIZEY)
return ret
***********
static function gd_fromGD(fileName)
local ret:=.t.
	::fileName := fileName
	::fileType := GDFILE_GD
	::image := gdImageCreateFromGD(::fileName)
	if ::image < 0
		return .f.
	endif
	::sizeX	:= gdColorInfo(::image, GDINFO_SIZEX)
	::sizeY	:= gdColorInfo(::image, GDINFO_SIZEY)
return ret
***********
static function gd_fromGD2(fileName)
local ret:=.t.
	::fileName := fileName
	::fileType := GDFILE_GD2
	::image := gdImageCreateFromGD2(::fileName)
	if ::image < 0
		return .f.
	endif
	::sizeX	:= gdColorInfo(::image, GDINFO_SIZEX)
	::sizeY	:= gdColorInfo(::image, GDINFO_SIZEY)
return ret
***********
static function gd_fromXBM(fileName)
local ret:=.t.
	::fileName := fileName
	::fileType := GDFILE_XBM
	::image := gdImageCreateFromXBM(::fileName)
	if ::image < 0
		return .f.
	endif
	::sizeX	:= gdColorInfo(::image, GDINFO_SIZEX)
	::sizeY	:= gdColorInfo(::image, GDINFO_SIZEY)
return ret
***********
static function gd_fromJPEG(fileName)
local ret:=.t.
	::fileName := fileName
	::fileType := GDFILE_JPEG
	::image := gdImageCreateFromJPEG(::fileName)
	if ::image < 0
		return .f.
	endif
	::sizeX	:= gdColorInfo(::image, GDINFO_SIZEX)
	::sizeY	:= gdColorInfo(::image, GDINFO_SIZEY)
return ret
***********
static function gd_destroy()
	if ::image > -1
		gdImageDestroy(::image)
		::sizeX	:= 0
		::sizeY	:= 0
		::fileName 	:= ""
		::fileType 	:= ""
		::image	:= -1
	endif
return .t.
***********
static function gd_toFile(fileName, fileType)
local ret:=.t.
	ret := gdImageToFILE(::image, fileName, fileType)
return ret
***********
static function gd_toPNG(fileName)
local ret:=.t.
	ret := gdImagePNG(::image, fileName)
return ret
***********
static function gd_toGD(fileName)
local ret:=.t.
	ret := gdImageGD(::image, fileName)
return ret
***********
static function gd_toGD2(fileName)
local ret:=.t.
	ret := gdImageGD2(::image, fileName)
return ret
***********
static function gd_toJPEG(fileName)
local ret:=.t.
	ret := gdImageJPEG(::image, fileName)
return ret
***********
static function gd_newColor(Red, Green, Blue)
	Red := iif(Red == NIL, 0, Red)
	Green := iif(Green == NIL, 0, Green)
	Blue := iif(Blue == NIL, 0, Blue)
	::color := gdColorCreate(::image, Red, Green, Blue)
return ::color
***********
static function gd_exactColor(Red, Green, Blue)
	Red := iif(Red == NIL, 0, Red)
	Green := iif(Green == NIL, 0, Green)
	Blue := iif(Blue == NIL, 0, Blue)
	::color := gdColorCreate(::image, Red, Green, Blue)
return ::color
***********
static function gd_transparent(color_index)
local color
	color := gdColorTransparent(::image, color_index)
return color
***********
static function gd_interlace(interlace)
local ret
	ret := gdImageInterlace(::image, interlace)
return ret
***********
static function gd_compare(item)
local ret
	if valtype(item) == "O" .and. item:classname == "GDIMAGE"
		ret := gdImageCompare(::image, item:image)
	else
		ret := gdImageCompare(::image, item)
	endif
return ret
***********
static function gd_info(index, colorNum)
local ret
	ret := gdColorInfo(::image, index, colorNum)
return ret
***********
static function gd_getPixel(x, y)
local ret
	ret := gdImageGetPixel(::image, x, y)
return ret
***********
static function gd_setPixel(x, y, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageSetPixel(::image, x, y, color)
return ret
***********
static function gd_bound(x, y)
local ret
	ret := gdImageBoundsSafe(::image, x, y)
return ret
***********
static function gd_line(x1, y1, x2, y2, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageLine(::image, x1, y1, x2, y2, color)
return ret
***********
static function gd_dashedLine(x1, y1, x2, y2, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageDashedLine(::image, x1, y1, x2, y2, color)
return ret
***********
static function gd_rectangle(x1, y1, x2, y2, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageRectangle(::image, x1, y1, x2, y2, color)
return ret
***********
static function gd_filledRectangle(x1, y1, x2, y2, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageFilledRectangle(::image, x1, y1, x2, y2, color)
return ret
***********
static function gd_arc(cx, cy, width, high, begangle, endangle, color)
local ret
	color := iif(color==NIL, ::color, color)
	high := iif(high==NIL, width, high)
	begangle := iif(begangle==NIL, 0, begangle)
	endangle := iif(endangle==NIL, 360, endangle)
	ret := gdImageArc(::image, cx, cy, width, high, begangle, endangle, color)
return ret
***********
static function gd_filledArc(cx, cy, width, high, color)
local ret
	color := iif(color==NIL, ::color, color)
	high := iif(high==NIL, width, high)
	ret := gdImageFilledArc(::image, cx, cy, width, high, color)
return ret
***********
static function gd_sector(cx, cy, width, high, begangle, endangle, color)
local ret
	color := iif(color==NIL, ::color, color)
	high := iif(high==NIL, width, high)
	begangle := iif(begangle==NIL, 0, begangle)
	endangle := iif(endangle==NIL, 360, endangle)
	ret := gdImageSector(::image, cx, cy, width, high, begangle, endangle, color)
return ret
***********
static function gd_filledSector(cx, cy, width, high, begangle, endangle, color)
local ret
	color := iif(color==NIL, ::color, color)
	high := iif(high==NIL, width, high)
	begangle := iif(begangle==NIL, 0, begangle)
	endangle := iif(endangle==NIL, 360, endangle)
	ret := gdImageFilledSector(::image, cx, cy, width, high, begangle, endangle, color)
return ret
***********
static function gd_truncSector(cx, cy, width, high, widthtrunc, hightrunc, begangle, endangle, color)
local ret
	color := iif(color==NIL, ::color, color)
	high := iif(high==NIL, width, high)
	hightrunc := iif(hightrunc==NIL, widthtrunc, hightrunc)
	begangle := iif(begangle==NIL, 0, begangle)
	endangle := iif(endangle==NIL, 360, endangle)
	ret := gdImageTruncSector(::image, cx, cy, width, high, widthtrunc, hightrunc, begangle, endangle, color)
return ret
***********
static function gd_filledTruncSector(cx, cy, width, high, widthtrunc, hightrunc, begangle, endangle, color)
local ret
	color := iif(color==NIL, ::color, color)
	high := iif(high==NIL, width, high)
	hightrunc := iif(hightrunc==NIL, widthtrunc, hightrunc)
	begangle := iif(begangle==NIL, 0, begangle)
	endangle := iif(endangle==NIL, 360, endangle)
	ret := gdImageFilledTruncSector(::image, cx, cy, width, high, widthtrunc, hightrunc, begangle, endangle, color)
return ret
***********
static function gd_polygon(bounds, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImagePolygon(::image, bounds, color)
return ret
***********
static function gd_filledPolygon(bounds, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageFilledPolygon(::image, bounds, color)
return ret
***********
static function gd_fill(x, y, color)
local ret
	x := iif(x==NIL, 0, x)
	y := iif(y==NIL, 0, y)
	color := iif(color==NIL, ::color, color)
	ret := gdImageFill(::image, x, y, color)
return ret
***********
static function gd_fillToBorder(x, y, bordercolor, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageFillToBorder(::image, x, y, bordercolor, color)
return ret
***********
static function gd_setBrush(imagePtrBrush)
local ret
	if valtype(imagePtrBrush) == "O" .and. imagePtrBrush:classname == "GDIMAGE"
		ret := gdImageSetBrush(::image, imagePtrBrush:image)
	else
		ret := gdImageSetBrush(::image, imagePtrBrush)
	endif
return ret
***********
static function gd_setTile(imagePtrTile)
local ret
	if valtype(imagePtrTile) == "O" .and. imagePtrTile:classname == "GDIMAGE"
		ret := gdImageSetTile(::image, imagePtrTile:image)
	else
		ret := gdImageSetTile(::image, imagePtrTile)
	endif
return ret
***********
static function gd_setStyle(colorsArray)
local ret
	ret := gdImageSetTile(::image, colorsArray)
return ret
***********
static function gd_char(str, x, y, font, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageChar(::image, str, x, y, color, font)
return ret
***********
static function gd_charUp(str, x, y, font, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageCharUP(::image, str, x, y, color, font)
return ret
***********
static function gd_string(str, x, y, font, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageString(::image, str, x, y, color, font)
return ret
***********
static function gd_stringUp(str, x, y, font, color)
local ret
	color := iif(color==NIL, ::color, color)
	ret := gdImageStringUP(::image, str, x, y, color, font)
return ret
***********
static function gd_charRotate(str, x, y, font, angle, color)
local ret
	color := iif(color==NIL, ::color, color)
	angle := iif(angle==NIL, 0, angle)
	ret := gdImageCharRotate(::image, str, x, y, color, font, angle)
return ret
***********
static function gd_stringRotate(str, x, y, font, angle, color)
local ret
	color := iif(color==NIL, ::color, color)
	angle := iif(angle==NIL, 0, angle)
	ret := gdImageStringRotate(::image, str, x, y, color, font, angle)
return ret
***********
static function gd_charVector(str, x, y, fontSize, angle, color)
local ret
	color := iif(color==NIL, ::color, color)
	angle := iif(angle==NIL, 0, angle)
	ret := gdImageCharVector(::image, str, x, y, angle, color, fontSize)
return ret
***********
static function gd_stringVector(str, x, y, fontSize, angle, color)
local ret
	color := iif(color==NIL, ::color, color)
	angle := iif(angle==NIL, 0, angle)
	ret := gdImageStringVector(::image, str, x, y, angle, color, fontSize)
return ret
***********
static function gd_cos(angle)
	angle := iif(angle==NIL, 0, angle)
return gdCos(::image, angle)
***********
static function gd_sin(angle)
	angle := iif(angle==NIL, 0, angle)
return gdSin(::image, angle)

