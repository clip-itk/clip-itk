/*   Business graphics - Histogram     			     */
/*   Copyright (C) 2001  ITK                                 */
/*   Author  : Elena Kornilova (alena@itk.ru)                */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html  */

#include "gdinfo.ch"
#include "bggraph.ch"

function BgHistNew(width, high)
local obj
	obj := BgBaseGraphic(width, high)
	obj:classname	:= "BG_HIST"
	obj:outFile	:= ""
	obj:typeFile	:= GDFILE_PNG
	obj:arr		:= {}
	obj:legend	:= {}
	obj:alignLeg	:= 0  // legend no needed
	obj:signat	:= {}
	obj:title	:= ""
	obj:subTitle	:= ""
	obj:vrtTitle	:= ""
	obj:volume	:= .f.
	obj:valVolume	:= 0
	obj:average	:= 0   //1-show average value, 2-show critical value,
			       //3-average and critical, 0-don't show anything
	obj:valAverage	:= 0
	obj:valCritic	:= 0

	obj:totalSumma	:= 0

	obj:onlyLegend	:= .f.
	obj:__isData	:= .f.
	obj:__datarow	:= 0
	obj:__category	:= 0
	obj:__isLegend	:= .f.
	obj:__isSignat	:= .f.
	obj:__isTitle	:= .f.
	obj:__isSubTitle:= .f.
	obj:__isVrtTitle:= .f.
	_recover_hist(obj)

return obj
************
function _recover_hist(obj)
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
************
static function bg_drawImage()
local i, j, key, v, colwidth, dx, x, y, arrx:={}, wCol, volume
local va,yav, rmin, x1, x2, a, cntColor, kl
	if !::__isData
		return .f.
	endif
	::createImage()
	::drawScale(__self__)

	cntColor := len(::legendColor)/3
	if ::log
		rmin=log10(max(1, int(10^(len(ZSTR(int(::min)))-1))))
	endif
	//yav := int(::Y0-iif(::log, (log10(max(1, abs(::valAverage)))-rmin)*iif(::valAverage<0, -1, 1), ::valAverage)*::dskl)
	yav := int(::Y0-iif(::log, (log10(max(1, abs(::valAverage))))*iif(::valAverage<0, -1, 1), ::valAverage)*::dskl)
	colwidth := BG_DEF_WIDTH
	volume := ::valVolume
	::X -= volume
	/* maximum possible width of one column */
	wCol := ::X/::__category
	do while (wCol-6<=colwidth*::__datarow)
		colwidth-- // real column width
	enddo
	for i=1 to ::__category
		x := ::X0+((i-1)*wCol)+3
		aadd(arrx, x)
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
	dx := int((wCol-colwidth*::__datarow)/2)
	if ::volume
		for i=1 to ::__category
			for key=1 to ::__datarow
				kl := iif(key<=10, key, &(right(alltrim(str(key)),1)))
				kl := iif(kl==0, 10, kl)
				j := ::arr[key][i]
				if ::log
					//y := int(::Y0-(log10(max(1,abs(j)))-rmin)*iif(j<0, -1, 1)*::dskl)
					y := int(::Y0-(log10(max(1,abs(j))))*iif(j<0, -1, 1)*::dskl)
				else
					y := int(::Y0-j*::dskl)
				endif
				x1 := arrx[i]+dx+(key-1)*colwidth+1
				x2 := x1+colwidth
				if (j>=0)
					a := {{x1, ::Y0-1}, {x1, y}, {x1+volume, y-volume}, {x2+volume, y-volume}, {x2+volume, ::Y0-1-volume}, {x2, ::Y0-1}}
					::image:filledPolygon(a, ::legendColor[kl])
					::image:polygon(a, ::scaleColor)
				else
					a := {{x1, y}, {x1, ::Y0}, {x1+volume, ::Y0-volume}, {x2+volume, ::Y0-volume}, {x2+volume, y-volume}, {x2, y}}
					::image:filledPolygon(a, ::legendColor[kl])
					::image:polygon(a, ::scaleColor)
					a := {{x1, ::Y0}, {x1+volume, ::Y0-volume}, {x2+volume, ::Y0-volume}, {x2+volume, ::Y0}}
					::image:filledPolygon(a, ::legendColor[kl+cntColor])
					::image:polygon(a, ::scaleColor)
				endif

				if ::average>0
					::image:line(::X0, yav, ::X0+::X+volume, yav, ::scaleColor)
					::image:line(::X0+::X, yav, ::X0+::X+volume, yav-volume, ::scaleColor)
					if ::valAverage>0
						if j>=::valAverage
							a := {{x2, yav}, {x2+volume, yav-volume}, {x2+volume, yav}}
							::image:filledPolygon(a, ::legendColor[kl+2*cntColor])
							::image:polygon(a, ::scaleColor)
						elseif yav>y-volume
							va := y-yav
							a := {{x1+va, y-va}, {x1+volume, y-volume}, {x2+volume, y-volume}, {x2+volume, y-va}}
							::image:filledPolygon(a, ::legendColor[kl+2*cntColor])
							::image:polygon(a, ::scaleColor)
						endif
					else
						if j<=::valAverage
							if y-volume > yav
								::image:filledPolygon({{x2, yav}, {x2+volume, yav-volume}, {x2+volume, yav}}, ::legendColor[kl+2*cntColor])
								::image:polygon({{x2, yav}, {x2+volume, yav-volume}, {x2+volume, yav}}, ::scaleColor)
							else
								va := y-yav
								a := {{x2, yav}, {x2+volume, y-volume-va}, {x2+volume, y-volume}, {x2+va, yav}}
								::image:filledPolygon(a, ::legendColor[kl+2*cntColor])
								::image:polygon(a, ::scaleColor)
							endif
						endif
					endif
				endif
				if j>=0
					::image:line(x1, y, x2, y, ::scaleColor)
					::image:line(x2, y, x2+volume, y-volume, ::scaleColor)
					::image:line(x2, y, x2, ::Y0-1, ::scaleColor)
				else
					::image:line(x1, ::Y0, x2, ::Y0, ::scaleColor)
					::image:line(x2, ::Y0, x2+volume, ::Y0-volume, ::scaleColor)
					::image:line(x2, y, x2, ::Y0+1, ::scaleColor)
				endif
			next
		next
	else  //!::volume
		for key=1 to ::__datarow
			kl := iif(key<=10, key, &(right(alltrim(str(key)),1)))
			kl := iif(kl==0, 10, kl)

			for i=1 to ::__category
				j := ::arr[key][i]
				if ::log
					//y := int(::Y0-(log10(max(1, abs(j)))-rmin)*iif(j<0, -1, 1)*::dskl)
					y := int(::Y0-(log10(max(1, abs(j))))*iif(j<0, -1, 1)*::dskl)
				else
					y := int(::Y0-j*::dskl)
				endif
				x1 := arrx[i]+dx+(key-1)*colwidth+1
				x2 := x1+colwidth
				if j>=0
					::image:filledRectangle(x1, y,  x2, ::Y0-1, ::legendColor[kl])
				else
					::image:filledRectangle(x1, ::Y0+1, x2, y, ::legendColor[kl])
				endif
			next
		next
		if ::average>0
			::image:line(::X0, yav, ::X0+::X, yav, ::image:exactColor(::AvColor[1], ::AvColor[2], ::AvColor[3]))
		endif
	endif
return .t.
