/*   Business graphics - ring-like diagram      	     */
/*   Copyright (C) 2001  ITK                                 */
/*   Author  : Elena Kornilova (alena@itk.ru)                */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html  */

#include "gdinfo.ch"
#include "bggraph.ch"

function BgRingNew(width, high)
local obj
	obj := BgBaseGraphic(width, high)
	obj:classname	:= "BG_RING"
	obj:outFile	:= ""
	obj:typeFile	:= GDFILE_PNG
	obj:arr		:= {}
	obj:legend	:= {}
	obj:alignLeg	:= 0   // legend no needed
	obj:signat	:= {}
	obj:title	:= ""
	obj:subTitle	:= ""
	obj:vrtTitle	:= ""
	obj:volume	:= .f.
	obj:average	:= 0   //1-show average value, 2-show critical value,
			       //3-average and critical, 0-don't show anything
	obj:valAverage	:= 0
	obj:valCritic	:= 0

	obj:summa	:= {}

	obj:onlyLegend	:= .t.
	obj:__isData	:= .f.
	obj:__datarow	:= 0
	obj:__category	:= 0
	obj:__isLegend	:= .f.
	obj:__isSignat	:= .f.
	obj:__isTitle	:= .f.
	obj:__isSubTitle:= .f.
	obj:__isVrtTitle:= .f.
	obj:isPice	:= .f.
	_recover_bg_ring(obj)
return obj
************
function _recover_bg_ring(obj)
	obj:setData	:= @bg_setData()
	obj:setInfo	:= @bg_setInfo()
	obj:drawImage	:= @bg_drawImage()
	obj:setVolume	:= @bg_setVolume()
	obj:setAverage	:= @bg_setAverage()
	obj:setPiceMode	:= @bg_setPiceMode()
return obj
************
static function bg_setData(arr, legend, alignLeg)
local i, j, l, lll, ts

	if empty(arr) .or. !(valtype(arr)$"AM") .or. len(arr)==0
		return .f.
	endif
	::__isData := .t.
	if valtype(arr[1])!="A"
		aadd(::arr, arr)
	else
		::arr := aclone(arr)
	endif
	::__datarow := len(::arr)

	::totalSumma := 0
	asize(::summa, ::__datarow)
	lll := ::__datarow
	lll := len(::summa)
	for i=1 to ::__datarow
		l:= len(::arr[i])
		if l>=::__category
			::__category := l
		endif
		ts := 0
		aeval(::arr[i], {|x| ts += abs(x)})
		::summa[i] := ts
		::totalSumma += ts
	next

	for i=1 to ::__datarow
		l:= len(::arr[i])
		if l>=::__category
			::__category := l
		else
			asize(::arr[i], ::__category)
			afill(::arr[i], 0, l+1)
		endif
		::findval(::arr[i])
	next

	::max := iif(::plsmax>::decmax, ::plsmax, ::decmax)
	::min := iif(::plsmin<::decmin, ::plsmin, ::decmin)
	::valAverage := (::totalSumma)/(::__datarow*::__category)

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
local angle:={}, value:={}, begang, endang:=270, ug, pice:={}
local right:={}, left:={}, top:={}, bottom:={}
local x, y, sx, sy, s, v, len, l, summa:=0, kl
local color,colorV,d,d1,d2,kk,str,isumma,valo,key
local radian,val,colwidth1,colwidth2,center1,center2
local diametr1_o,diametr2_o

	if !::__isData
		return .f.
	endif
	if !::createImage()
		outlog(__FILE__, __LINE__, "Can't create image.")
		return .f.
	endif

	::drawScale(__self__)

	/*
	cx := ::X0+::X/2
	cy := ::sY0-3*::Y/4
	*/
	cx := ::X/2
	cy := ::Y/2
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

	diametr1_o := diametr1
	diametr2_o := diametr2
	center1 := 40*diametr1/100
	center2 := 40*diametr2/100
	colwidth1 := (diametr1-center1)/::__datarow/2
	colwidth2 := (diametr2-center2)/::__datarow/2

	asize(angle, ::__datarow)
	asize(value, ::__datarow)
	for key=::__datarow to 1 step -1
	//for key=1 to ::__datarow
		val := ::arr[key]
		angle[key] := {}
		value[key] := {}
		endang := 270
		for k=1 to ::__category
			av := abs(val[k])
			begang := endang
			//endang := mod(endang+int(360*av/::summa[key]), 360)
			endang := mod(endang+360*av/::summa[key], 360)
			if k==::__category
				endang := 270
			endif
			if av!=0
				aadd(angle[key], {begang, endang})
				aadd(value[key], av)
				loop
			endif
		next
		/* draw 3D sector */
		if ::volume
			d1 := diametr1-2*colwidth1
			d2 := diametr2-2*colwidth2
			for k=1 to len(angle[key])
				kl := iif(k<=10, k, &(right(alltrim(str(k)),1)))
				kl := iif(kl==0, 10, kl)
				v := angle[key][k]
				if (v[2]>270 .and. v[2]<360) .or. v[2]<90
					for i=1 to volume
						::image:filledTruncSector(cx, cy+i, diametr1, diametr2, d1, d2, v[1], v[2], ::legendColor[kl+cntColor])
					next
				else
					exit
				endif
			next

			for kk=len(angle[key]) to k step -1
				kl := iif(kk<=10, kk, &(right(alltrim(str(kk)),1)))
				kl := iif(kl==0, 10, kl)
				v := angle[key][kk]
				for i=1 to volume
					::image:filledTruncSector(cx, cy+i, diametr1, diametr2, d1, d2, v[1],v[2], ::legendColor[kl+cntColor])
				next
			next
		endif

		diametr1 -= 2*colwidth1
		radius1 := diametr1/2
		diametr2 -= 2*colwidth2
		radius2 := diametr2/2
	next

	/* draw main sector */
	diametr1 := diametr1_o
	radius1 := int(diametr1/2)
	diametr2 := diametr2_o
	if ::volume
		radius2 := diametr2/2
	else
		radius2 := radius1
	endif

	for key=::__datarow to 1 step -1
		d1 := diametr1-2*colwidth1
		d2 := diametr2-2*colwidth2
		for k=1 to len(angle[key])
			kl := iif(k<=10, k, &(right(alltrim(str(k)),1)))
			kl := iif(kl==0, 10, kl)
			v := angle[key][k]
			av := value[key][k]
			::image:filledTruncSector(cx, cy, diametr1, diametr2, d1, d2, v[1], v[2], ::legendColor[kl])
			::image:truncSector(cx, cy, diametr1, diametr2, d1, d2, v[1], v[2], ::scaleColor)

			ug := abs(v[2]-v[1])/2
			radian := (pi()*(mod(v[1]+min(ug, 30), 360)))/180
			//x := int(cos(radian)*(radius1/2))+cx
			//y := int(sin(radian)*(radius2/2))+cy
			//x := int(cos(radian)*radius1)+cx
			//y := int(sin(radian)*radius2)+cy
			x := cos(radian)*(radius1/2)+cx
			y := sin(radian)*(radius2/2)+cy
			x := cos(radian)*radius1+cx
			y := sin(radian)*radius2+cy
			if (::isPice)      // slice
				//str := ZSTR(int(100*av/::summa[key]))+'%'
				str := ZSTR(100*av/::summa[key])+'%'
			else 	 // value
				str := ZSTR(av)
			endif
			if v[1]<270 .and. v[1]>90  // caption at left
				x -= len(str)*::font_sign_width
			else
				x -= 2*::font_sign_width
			endif
			if v[1]+ug>0 .and. v[1]+ug<180
				y -= ::font_sign_high
			endif
			::image:stringVector(str, x, y, ::font_sign, 0, ::scaleColor)

		next

		diametr1-=2*colwidth1
		radius1 := diametr1/2
		diametr2-=2*colwidth2
		radius2 := diametr2/2
	next

	/* draw average value */
	if ::average>0
		diametr1 := diametr1_o
		radius1 := int(diametr1/2)
		diametr2 := diametr2_o
		if ::volume
			radius2 := diametr2/2
		else
			radius2 := radius1
		endif
		isumma := 0
		for val in ::summa
			isumma += val
		next
		cx := radius1+10
		cy := ::LY-radius2-volume-10
		begang := 90
		//endang := mod(begang+int(360*abs(::valAverage)/isumma), 360)
		endang := mod(begang+360*abs(::valAverage)/isumma, 360)
		d := (endang-begang)/2
		begang-=d
		endang-=d

		if ::isPice     // slice
			str := ZSTR(abs(::valAverage)*100/isumma)+"%"
		else  // value
			str := ZSTR(::valAverage)
		endif
		color := ::image:exactColor(::AvColor[1], ::AvColor[2], ::AvColor[3])
		colorV := ::image:newColor(::AvColor[1], ::AvColor[2], 200)
		if ::volume
			for i=1 to volume
				::image:filledTruncSector(cx, cy+i, diametr1, diametr2, diametr1/2, diametr2/2, begang, endang, colorV)
			next
		endif
		::image:filledTruncSector(cx, cy, diametr1, diametr2, diametr1/2, diametr2/2, begang, endang, color)
		::image:truncSector(cx, cy, diametr1, diametr2, diametr1/2, diametr2/2, begang, endang, ::scaleColor)
		::image:stringVector(str, cx-(len(str)/2)*::font_sign_width, cy+radius2-::font_sign_high, ::font_sign, 0, ::scaleColor)

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
	case type == 1	//show  average value
		::average := 1
	case type == 2
		::average := 2 	//show critical value
		if value!=NIL .and. valtype(value)=="N"
			::valCritic := value
		endif
	case type == 3	//show average and critical values
		::average := 3
		if value!=NIL .and. valtype(value)=="N"
			::valCritic := value
		endif
	otherwise
		::average := 0
	endcase
return .t.


