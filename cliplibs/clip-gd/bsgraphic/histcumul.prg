/*   Business graphics - Histogram with cumulation	     */
/*   Copyright (C) 2001  ITK                                 */
/*   Author  : Elena Kornilova (alena@itk.ru)                */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html  */

#include "gdinfo.ch"
#include "bggraph.ch"

function BgHistCumulNew(width, high)
local obj
	obj := BgBaseGraphic(width, high)
	obj:classname	:= "BG_HIST_CUMUL"
	obj:outFile	:= ""
	obj:typeFile	:= GDFILE_PNG
	obj:arr		:= {}
	obj:legend	:= {}
	obj:alignLeg	:= 0  // не надо легенду
	obj:signat	:= {}
	obj:title	:= ""
	obj:subTitle	:= ""
	obj:vrtTitle	:= ""
	obj:volume	:= .f.
	obj:valVolume	:= 0
	obj:average	:= 0   //1-показать среднее значение, 2-показать критическое значение,
			       //3-и среднее и критич, 0-ничего не показывать
	obj:valAverage	:= 0
	obj:valCritic	:= 0

	obj:totalSumma	:= 0
	obj:summa	:= {}
	obj:lowsumma	:= {}
	obj:newarr	:= {}

	obj:onlyLegend	:= .f.
	obj:__isData	:= .f.
	obj:__datarow	:= 0
	obj:__category	:= 0
	obj:__isLegend	:= .f.
	obj:__isSignat	:= .f.
	obj:__isTitle	:= .f.
	obj:__isSubTitle:= .f.
	obj:__isVrtTitle:= .f.
	_recover_hist_cumul(obj)
return obj
************
function _recover_hist_cumul(obj)
	obj:setData	:= @bg_setData()
	obj:setInfo	:= @bg_setInfo()
	obj:drawImage	:= @bg_drawImage()
	obj:setVolume	:= @bg_setVolume()
	obj:setAverage	:= @bg_setAverage()
return obj
************
static function bg_setData(arr, legend, alignLeg, signat)
local i, j, l, ts
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

	::__cleanVal()
	::totalSumma := 0
	for i=1 to ::__datarow
		l:= len(::arr[i])
		if l>=::__category
			::__category := l
		endif
		ts := 0
		aeval(::arr[i], {|x| ts += x})
		::totalSumma += ts
	next

	::summa := {}
	::lowsumma:= {}
	asize(::summa, ::__category)
	afill(::summa, 0)
	asize(::lowsumma, ::__category)
	afill(::lowsumma, 0)
	for i=1 to ::__datarow
		l:= len(::arr[i])
		if l<::__category
			asize(::arr[i], ::__category)
			afill(::arr[i], 0, l+1)
		endif
		::findval(::arr[i])
		for j=1 to ::__category
			if ::arr[i][j] >= 0
				::summa[j] += ::arr[i][j]
			else
				::lowsumma[j] += ::arr[i][j]
			endif
		next
	next
	::findval(::summa)
	::findval(::lowsumma)
	::max := iif(::plsmax>::decmax, ::plsmax, ::decmax)
	::min := iif(::plsmin<::decmin, ::plsmin, ::decmin)
	if (::max-::min<1000)
		::max := iif(::max>0, ::max, 0)
		::min := iif(::min<0, ::min, 0)
	endif

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

	if valtype(signat)=="A" .and. !empty(signat)
		::signat := {}
		l := len(signat)
		for i=1 to ::__category
			aadd(::signat, iif(i<=l, signat[i], "Col"+ZSTR(i)))
		next
		::__isSignat := .t.
	endif

return .t.
************
static function bg_setInfo(title, subtitle, vrttitle)
	::title := iif(title!=NIL, title, "")
	::subtitle := iif(subtitle!=NIL, subtitle, "")
	::vrttitle := iif(vrttitle!=NIL, vrttitle, "")
return .t.
************
static function bg_setVolume(volume)
	if volume==NIL .or. valtype(volume)!="L"
		::volume := !::volume
	else
		::volume := volume
	endif
return ::volume
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
************
static function bg_drawImage()
local i, j, key, va, colwidth, dx, x, y, arrx, arry, wCol, volume
local yav, rmin, x1, x2, a, cntColor, kl
	if !::__isData
		return .f.
	endif
	::createImage()
	::drawScale(__self__)
	if ::log
		rmin := log10(max(1, ::min))
		yav := int(::Y0-(log10(max(1, abs(::valAverage))))*iif(::valAverage<0, -1, 1)*::dskl)
		//yav := int(::Y0-(log10(max(1, abs(::valAverage)))-rmin)*iif(::valAverage<0, -1, 1)*::dskl)
	else
		yav := int(::Y0-::valAverage*::dskl)
	endif
	cntColor := len(::legendColor)/3
	colwidth := BG_DEF_WIDTH
	volume := ::valVolume
	::X -= volume
	/* максимально возможная ширина одной колонки */
	wCol := ::X/::__category
	do while (wCol-6<=colwidth)
		colwidth-- // реальная ширина колонки
	enddo
	/* координаты по Х & Y для каждой категории */
	arrx := {}
	arry := {}
	for i=1 to ::__category
		x := ::X0+((i-1)*wCol)+3
		aadd(arrx, x)
		aadd(arry, {::Y0, ::Y0})
	next
	/* put category head */
	if ::log
		y := ::sY0
	else
		y := ::sY0-abs(::min)*iif(::min<0, -1, 1)*::dskl
	endif
	for i=1 to ::__category
		if i>1
			::image:line(arrx[i], y-2, arrx[i], y+2, ::scaleColor)
			::image:line(arrx[i], ::sY0-2, arrx[i], ::sY0+2, ::scaleColor)
			::image:line(arrx[i], ::Y0-2, arrx[i], ::Y0+2, ::scaleColor)
			::image:line(arrx[i], y, arrx[i]+volume, y-volume, ::scaleColor)
		endif
		if ::__isSignat
			::image:stringVector(::signat[i], arrx[i]+(wCol-len(::signat[i])*::font_sign_width)/2, y+3+::font_sign_high, ::font_sign, 0, ::scaleColor)
		endif
	next
	dx := (wCol-colwidth)/2
	afill(::summa, 0)
	afill(::lowsumma, 0)
	for i=1 to ::__category
		for key=1 to ::__datarow
			kl := iif(key<=10, key, &(right(alltrim(str(key)),1)))
			kl := iif(kl==0, 10, kl)
			val := ::arr[key]
			j := val[i]
			x1 := arrx[i]+dx
			x2 := x1+colwidth
			if j>=0
				y2 := arry[i][1]
				if ::log
					::summa[i] += j
					//y1 := ::Y0-int((log10(max(1, ::summa[i]))-rmin)*::dskl)
					y1 := ::Y0-int((log10(max(1, ::summa[i])))*::dskl)
				else
					y1 := y2-int(j*::dskl)
				endif
				arry[i][1] := y1
			else
				y2 := arry[i][2]
				if ::log
					::lowsumma[i] += j
					//y1 := ::Y0+int((log10(max(1, abs(::lowsumma[i])))-rmin)*::dskl)
					y1 := ::Y0+int((log10(max(1, abs(::lowsumma[i]))))*::dskl)
				else
					y1 := y2-int(j*::dskl)
				endif
				arry[i][2] := y1
			endif
			if ::volume
				if j>=0
					a := {{x1, y1}, {x1, y2}, {x2, y2}, {x2+volume, y2-volume}, {x2+volume, y1-volume}, {x1+volume, y1-volume}}
					::image:filledPolygon(a, ::legendColor[kl])
					::image:polygon(a, ::scaleColor)
				else
					a := {{x1, y2}, {x1, y1}, {x2, y1}, {x2+volume, y1-volume}, {x2+volume, y2-volume}, {x2, y2}}
					::image:filledPolygon(a, ::legendColor[kl])
					::image:polygon(a, ::scaleColor)
					if arry[i][1] == ::Y0 .and. y2 == ::Y0
						a := {{x1, y2}, {x2+volume, y2}, {x2+volume, y2-volume}, {x1+volume, y2-volume}}
						::image:filledPolygon(a, ::legendColor[kl+cntColor])
						::image:polygon(a, ::scaleColor)
					elseif y2 == ::Y0
						a := {{x2, y2}, {x2+volume, y2-volume}, {x2+volume, y2}}
						::image:filledPolygon(a, ::legendColor[kl+cntColor])
						::image:polygon(a, ::scaleColor)
					endif
					::image:line(x2, y2, x2, y1, ::scaleColor)
				endif
				if ::average>0
					::image:line(::X0, yav, ::X0+::X, yav, ::scaleColor)
					if ::valAverage>0 .and. j>0
						if  between(y1-volume, yav, yav-volume)
							va := y1 - yav
							a := {{x2+va, yav}, {x2+volume, y1-volume}, {x2+volume, yav}}
							::image:filledPolygon(a, ::legendColor[kl+2*cntColor])
							::image:polygon(a, ::scaleColor)
						elseif  between(y2-volume, yav, yav-volume)
							va := y2-yav
							a := {{x2, yav}, {x2+volume, yav-volume}, {x2+volume, y2-volume}, {x2+va, yav}}
							::image:filledPolygon(a, ::legendColor[kl+2*cntColor])
							::image:polygon(a, ::scaleColor)
						elseif y2>yav-volume
							a := {{x2, yav}, {x2+volume, yav-volume}, {x2+volume, yav}}
							::image:filledPolygon(a, ::legendColor[kl+2*cntColor])
							::image:polygon(a, ::scaleColor)
						endif
					elseif ::valAverage<0 .and. j<0
						if  y1 >= yav .and. between(y1-volume, yav, yav-volume)
							va := y1 - yav
							a := {{x2, yav}, {x2+volume, yav-volume}, {x2+volume, y1-volume}, {x2+va, yav}}
							::image:filledPolygon(a, ::legendColor[kl+2*cntColor])
							::image:polygon(a, ::scaleColor)
						elseif  y1 >= yav .and. between(y2-volume, yav, yav-volume)
							va := y2 - yav
							a := {{x2+va, yav}, {x2+volume, y2-volume}, {x2+volume, yav}}
							::image:filledPolygon(a, ::legendColor[kl+2*cntColor])
							::image:polygon(a, ::scaleColor)
						elseif y1 >= yav .and. y2<=yav
							a := {{x2, yav}, {x2+volume, yav-volume}, {x2+volume, yav}}
							::image:filledPolygon(a, ::legendColor[kl+2*cntColor])
							::image:polygon(a, ::scaleColor)
						endif
					endif
				endif
				if j>=0
					::image:line(x1, y1, x2, y1, ::scaleColor)
					::image:line(x2, y1, x2+volume, y1-volume, ::scaleColor)
					::image:line(x2, y1, x2, y2-1, ::scaleColor)
				else
					::image:line(x1, y2, x2, y2, ::scaleColor)
					::image:line(x2, y2, x2+volume, y2-volume, ::scaleColor)
					::image:line(x2, y1, x2, y2+1, ::scaleColor)
				endif
			else
				if (j>=0)
					::image:filledRectangle(x1, y1,  x2, y2-1, ::legendColor[kl])
					::image:rectangle(x1, y1,  x2, y2-1, ::scaleColor)
				else
					::image:filledRectangle(x1, y2+1, x2, y1, ::legendColor[kl])
					::image:rectangle(x1, y2+1, x2, y1, ::scaleColor)
				endif
			endif
		next
	next
return .t.
