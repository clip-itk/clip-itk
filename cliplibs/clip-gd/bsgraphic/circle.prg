/*   Business graphics - circle-like diagram		     */
/*   Copyright (C) 2001  ITK                                 */
/*   Author  : Elena Kornilova (alena@itk.ru)                */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html  */

#include "gdinfo.ch"
#include "bggraph.ch"

function BgCircleNew(width, high)
local obj
	obj := BgBaseGraphic(width, high)
	obj:className	:= "BG_CIRCLE"
	obj:outFile	:= ""
	obj:typeFile	:= GDFILE_PNG
	obj:arr		:= {}
	obj:legend	:= {}
	obj:alignLeg	:= 0   // не надо легенду
	obj:signat	:= {}
	obj:title	:= ""
	obj:subTitle	:= ""
	obj:vrtTitle	:= ""
	obj:volume	:= .f.
	obj:average	:= 0   //1-показать среднее значение, 2-показать критическое значение,
			       //3-и среднее и критич, 0-ничего не показывать
	obj:valAverage	:= 0
	obj:valCritic	:= 0

	obj:summa	:= 0

	obj:onlyLegend	:= .t.
	obj:__isData	:= .f.
	obj:__datarow	:= 0
	obj:__isLegend	:= .f.
	obj:__isSignat	:= .f.
	obj:__isTitle	:= .f.
	obj:__isSubTitle:= .f.
	obj:__isVrtTitle:= .f.
	obj:__is3D	:= .f.
	obj:__isNorm	:= .f.
	obj:isPice	:= .f.

	_recover_bg_circle(obj)
return obj
************
function _recover_bg_circle(obj)
	obj:setData	:= @bg_setData()
	obj:setInfo	:= @bg_setInfo()
	obj:drawImage	:= @bg_drawImage()
	obj:setVolume	:= @bg_setVolume()
	obj:setAverage	:= @bg_setAverage()
	obj:setPiceMode	:= @bg_setPiceMode()
return obj
************
static function bg_setData(arr, legend, alignLeg)
local i, l
	if empty(arr) .or. !(valtype(arr)$"AM") .or. len(arr)==0 .or. valtype(arr[1])$"AM"
		return .f.
	endif
	::__isData := .t.
	::arr := arr
	::__datarow := len(::arr)
	::findVal(::arr)
	::max := iif(::plsmax>::decmax, ::plsmax, ::decmax)
	::min := iif(::plsmin<::decmin, ::plsmin, ::decmin)
	for i in ::arr
		::summa += abs(i)
	next
	::valAverage := (::max+::min)/2
	if valtype(legend)=="A" .and. !empty(legend)
		::legend := {}
		::alignLeg := iif(between(alignleg, 0, 4), alignleg, ::alignLeg)
		l := len(legend)
		for i=1 to ::__datarow
			aadd(::legend, iif(i<=l, legend[i], "Row"+ZSTR(i)))
		next
		::__isLegend := iif(::alignLeg>0, .t., .f.)
	endif
return .t.
************
static function bg_setInfo(title, subtitle, vrttitle)
	::title := iif(title!=NIL, title, "")
	::subtitle := iif(subtitle!=NIL, subtitle, "")
	::vrttitle := iif(vrttitle!=NIL, vrttitle, "")
return .t.
************
static function bg_drawImage()
local cx, cy, diametr1, diametr2, volume, radius1, radius2, i, k, av, cntColor
local angle:={}, begang, endang:=270, ug, pice:={}
local right:={}, left:={}, top:={}, bottom:={}
local x, y, sx, sy, s, v, len, l, summa:=0
	if !::__isData
		return .f.
	endif
	::createImage()
	::drawScale(__self__)
	for v in ::arr
		av := abs(v)
		summa += av
	next

	cx := ::X0+::X/2//+6*::font_scale_width
	cy := ::sY0-3*::Y/4
	volume := iif(::volume, 20, 0)
	cntColor := len(::legendColor)/3
	diametr1 := int(iif(::X>::Y, iif(volume>0,8,6.5)*::Y/10, iif(volume>0,8,6.5)*::X/10))  // % of X or Y
	radius1 := int(diametr1/2)
	if (volume>0)
		diametr2 := 55*diametr1/100
		radius2 := diametr2/2
	else
		diametr2 := diametr1
		radius2 := radius1
	endif
	len := len(::arr)
	for i=1 to len
		av := abs(::arr[i])
		aadd(pice, 100*av/summa)                 // доля в общем котле
		begang := endang
		endang := mod(endang+int(360*av/summa), 360)
		if (i==len)
			endang := 270
		endif
		if (endang<begang)
			ug := begang+mod(360, begang-endang)/2
		else
			ug := begang+abs(endang-begang)/2
		endif
		ug := mod(ug, 360)
		do case
		case ug<=255 .and. ug>=105  // надпись слева
			aadd(left, {i, ug})
		case ug<=285 .and. ug>=255  // надпись сверху
			aadd(top, {i, ug})
		case ug<=105 .and. ug>=75  // надпись снизу
			aadd(bottom, {i, ug})
		otherwise //case ug<=105 .and. ug>=75  // надпись справа
			aadd(right, {i, ug})
		endcase
		if (av!=0)
			aadd(angle, {begang, endang})
		endif
	next

	for k=1 to len(angle)
		v := angle[k]
		if ((v[2]>270 .and. v[2]<360) .or. v[2]<90)
			if (volume>0)
				for i=1 to volume-1
					::image:filledSector(cx, cy+i, diametr1, diametr2, v[1], v[2], ::legendColor[k+cntColor])
				next
			endif
			::image:filledSector(cx, cy, diametr1, diametr2, v[1], v[2], ::legendColor[k])
			::image:sector(cx, cy, diametr1, diametr2, v[1], v[2], ::scaleColor)
		else
			exit
		endif
	next

	for kk=len(angle) to k step -1
		if (volume>0)
			for i=1 to volume-1
				::image:filledSector(cx, cy+i, diametr1, diametr2, angle[kk][1], angle[kk][2], ::legendColor[kk+cntColor])
			next
		endif

		::image:filledSector(cx, cy, diametr1, diametr2, angle[kk][1], angle[kk][2], ::legendColor[kk])
		::image:sector(cx, cy, diametr1, diametr2, angle[kk][1], angle[kk][2], ::scaleColor)
	next

	radius1_5 := radius1-5
	radius2_5 := radius2-5
	l := 6*::font_scale_width

	len := 2*radius2/len(right)
	sx := cx+radius1+10
	sy := cy-radius2+len/2
	for v in right
		ug := v[2]
		radian := (pi()*ug)/180
		x := int(cos(radian)*radius1_5)+cx
		y := int(sin(radian)*radius2_5)+cy
		::image:line(sx, sy, x, y, ::scaleColor)
		::image:line(sx, sy, sx+l, sy, ::scaleColor)
		a := {{sx, sy-1}, {sx, sy-1-8}, {sx+6, sy-1-8}, {sx+6, sy-1}}
		::image:filledPolygon(a, ::legendColor[v[1]])
		::image:polygon(a, , ::scaleColor)
		if ::isPice     // доля
			::image:stringVector(ZSTR(pice[v[1]])+"%", sx+8, sy-1-::font_scale_width, ::font_scale, 0, ::scaleColor)
		else  // значение
			::image:stringVector(ZSTR(::arr[v[1]]), sx+8, sy-1-::font_scale_width, ::font_scale, 0, ::scaleColor)
		endif
		sy += len
	next
	len := 2*radius2/len(left)
	sx := cx-radius1-10
	sy := cy+radius2-len/2
	for v in left
		ug := v[2]
		radian := (pi()*ug)/180
		x := int(cos(radian)*radius1_5)+cx
		y := int(sin(radian)*radius2_5)+cy
		::image:line(sx, sy, x, y, ::scaleColor)
		::image:line(sx-l, sy, sx, sy, ::scaleColor)
		a := {{sx-l, sy-1}, {sx-l, sy-1-8}, {sx-l+6, sy-1-8}, {sx-l+6, sy-1}}
		::image:filledPolygon(a, ::legendColor[v[1]])
		::image:polygon(a, , ::scaleColor)
		if ::isPice     // доля
			::image:stringVector(ZSTR(pice[v[1]])+"%", sx-l+8, sy-1-::font_scale_width, ::font_scale, 0, ::scaleColor)
		else  // значение
			::image:stringVector(ZSTR(::arr[v[1]]), sx-l+8, sy-1-::font_scale_width, ::font_scale, 0, ::scaleColor)
		endif
		sy -= len
	next
	len := 2*radius2/len(top)
	ll := (diametr1+20)/len(top)
	sx := cx - radius1 - 10 + l
	sy := cy - radius2 - 10
	for v in top
		ug := v[2]
		radian := (pi()*ug)/180
		x := int(cos(radian)*radius1_5)+cx
		y := int(sin(radian)*radius2_5)+cy
		::image:line(sx, sy, x, y, ::scaleColor)
		::image:line(sx, sy, sx+l, sy, ::scaleColor)
		a := {{sx, sy-1}, {sx, sy-1-8}, {sx+6, sy-1-8}, {sx+6, sy-1}}
		::image:filledPolygon(a, ::legendColor[v[1]])
		::image:polygon(a, , ::scaleColor)
		if ::isPice     // доля
			::image:stringVector(ZSTR(pice[v[1]])+"%", sx+8, sy-1-::font_scale_width, ::font_scale, 0, ::scaleColor)
		else  // значение
			::image:stringVector(ZSTR(::arr[v[1]]), sx+8, sy-1-::font_scale_width, ::font_scale, 0, ::scaleColor)
		endif
		sx += ll
	next
	len := 2*radius2/len(bottom)
	ll := (diametr1+20)/len(bottom)
	sx := cx - radius1 - 10 + l
	sy := cy + radius2 + 10 + volume
	for v in bottom
		ug := v[2]
		radian := (pi()*ug)/180
		x := int(cos(radian)*radius1_5)+cx
		y := int(sin(radian)*radius2_5)+cy
		::image:line(sx, sy, x, y, ::scaleColor)
		::image:line(sx, sy, sx+l, sy, ::scaleColor)
		a := {{sx, sy+1}, {sx, sy+1+8}, {sx+6, sy+1+8}, {sx+6, sy+1}}
		::image:filledPolygon(a, ::legendColor[v[1]])
		::image:polygon(a, , ::scaleColor)
		if ::isPice     // доля
			::image:stringVector(ZSTR(pice[v[1]])+"%", sx+8, sy+1+::font_scale_width, ::font_scale, 0, ::scaleColor)
		else  // значение
			::image:stringVector(ZSTR(::arr[v[1]]), sx+8, sy+1+::font_scale_width, ::font_scale, 0, ::scaleColor)
		endif
		sx += ll
	next

	if ::average>0
		cx := iif(::alignLeg==BG_ALIGN_BOTTOM, cx - radius1 - volume , radius1+10)
		cy := iif(::alignLeg==BG_ALIGN_BOTTOM, cy - 2*radius2 - volume, ::LY-radius2-volume-10)
		cy := max(cy, 5)
		if ::isPice     // доля
			str := ZSTR(abs(::valAverage)*100/summa)+"%"
		else   // значение
			str := ZSTR(::valAverage)
		endif
		begang := 90
		endang := mod(begang+int(360*abs(::valAverage)/summa), 360)
		d := (endang-begang)/2
		begang -= d
		endang -= d
		color := ::image:exactColor(::AvColor[1], ::AvColor[2], ::AvColor[3])
		colorV := ::image:newColor(::AvColor[1], ::AvColor[2], 200)
		if (volume>0)
			for i=1 to volume-1
				::image:filledSector(cx, cy+i, diametr1, diametr2, begang, endang, colorV)
			next
		endif
		::image:filledSector(cx, cy, diametr1, diametr2, begang, endang, color)
		::image:sector(cx, cy, diametr1, diametr2, begang, endang, ::scaleColor)
		::image:stringVector(str, cx-(len(str)*::font_sign_width/2), cy+radius2-::font_sign_high, ::font_sign, 0, ::scaleColor)

	endif
return .t.
************
static function bg_setVolume(volume)
	if volume==NIL .or. valtype(volume)!="L"
		::volume := !::volume
	else
		::volume := volume
	endif
return .t.
************
static function bg_setPiceMode(pice)
	if pice==NIL .or. valtype(pice)!="L"
		::isPice := !::pice
	else
		::pice := pice
	endif
return .t.
************
static function bg_setAverage(type, value)
	if !::__isData
		return .f.
	endif
	do case
	case type == 1	//показать только среднее значение
		::average := 1
	case type == 2
		::average := 2 	//показать крит значение
		if value!=NIL .and. valtype(value)=="N"
			::valCritic := value
		endif
	case type == 3	//показать и среднее и критич знач
		::average := 3
		if value!=NIL .and. valtype(value)=="N"
			::valCritic := value
		endif
	otherwise
		::average := 0
	endcase
return .t.

