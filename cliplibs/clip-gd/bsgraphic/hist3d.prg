/*   Business graphics - Histogram                           */
/*   Copyright (C) 2001  ITK                                 */
/*   Author  : Elena Kornilova (alena@itk.ru)                */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html  */

#include "gdinfo.ch"
#include "bggraph.ch"

function BgHist3DNew(width, high)
local obj
	obj := BgBaseGraphic(width, high)
	obj:classname	:= "BG_HIST_3D"
	obj:outFile     := ""
	obj:typeFile    := GDFILE_PNG
	obj:arr         := {}
	obj:legend      := {}
	obj:alignLeg    := 0  // legend no needed
	obj:signat      := {}
	obj:title       := ""
	obj:subTitle    := ""
	obj:vrtTitle    := ""
	obj:volume      := .t.
	obj:valVolume   := 0
	obj:average     := 0   //1-show average value, 2-show critical value,
			       //3-average and critical, 0-don't show anything
	obj:valAverage  := 0
	obj:valCritic   := 0

	obj:totalSumma  := 0

	obj:onlyLegend  := .f.
	obj:__isData    := .f.
	obj:__datarow  := 0
	obj:__category    := 0
	obj:__isLegend  := .f.
	obj:__isSignat  := .f.
	obj:__isTitle   := .f.
	obj:__isSubTitle:= .f.
	obj:__isVrtTitle:= .f.
	obj:__is3D      := .t.
	_recover_hist_3d(obj)

return obj
************
function _recover_hist_3d(obj)
	obj:setData     := @bg_setData()
	obj:setInfo     := @bg_setInfo()
	obj:drawImage   := @bg_drawImage()
	obj:setAverage  := @bg_setAverage()
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
static function bg_setAverage(type, value)
	if !::__isData
		return .f.
	endif
	do case
	case type == 1  //show  average value
		::average := 1
	case type == 2
		::average := 2  //show critical value
		if value!=NIL .and. valtype(value)=="N"
			::valCritic := value
		endif
	case type == 3  //show average and critical values
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
local yav, yav0, rmin, i, j, key, wCol, dx, dy, vdy, lendy, kl
local x, y, sx, sy, kdy, volume, colwidth, arrx:={}, ymin, cntColor, x1, x2, a, b
	if !::__isData
		return .f.
	endif
	::createImage()
	::drawScale(__self__)
	cntColor := len(::legendColor)/3

	if ::log
		rmin := log10(max(1, int(10^(len(ZSTR(int(::min)))-1))))
		//yav0 := int(::Y0-(log10(max(1, abs(::valAverage)))-rmin)*iif(::valAverage<0, -1, 1)*::dskl)
		yav0 := int(::Y0-(log10(max(1, abs(::valAverage))))*iif(::valAverage<0, -1, 1)*::dskl)
	else
		yav0 := int(::Y0-::valAverage*::dskl)
	endif
	volume := ::valVolume
	wCol := ::X/::__category
	colwidth := BG_DEF_WIDTH

	do while (wCol<=(colwidth+2))
		colwidth--
	enddo
	for i=1 to ::__category
		x := ::X0+((i-1)*wCol)+3
		aadd(arrx, x)
	next

	dx := (wCol-colwidth)/2
	lendy := volume/::__datarow
	dy := min(colwidth, lendy)
	vdy := dy/2
	if ::log
		//ymin := ::Y0-(log10(MAX(1, abs(::min)))-rmin)*iif(::min<0, -1, 1)*::dskl
		ymin := ::Y0-(log10(MAX(1, abs(::min))))*iif(::min<0, -1, 1)*::dskl
	else
		ymin := ::Y0-::min*::dskl
	endif

	/* put categori head*/
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
			::image:line(arrx[i], ::sY0, arrx[i]+volume, ::sY0-volume, ::scaleColor)
		endif
		if ::__isSignat
			::image:stringVector(::signat[i], arrx[i]+(wCol-len(::signat[i])*::font_sign_width)/2, y+3+::font_sign_high, ::font_sign, 0, ::scaleColor)
		endif
	next

	for key=::__datarow to 1 step -1
		kl := iif(key<=10, key, &(right(alltrim(str(key)),1)))
		kl := iif(kl==0, 10, kl)

		kdy := (key-1)*lendy
		::image:line(::X0+::X+kdy-2, ::Y0-kdy, ::X0+::X+kdy+2, ::Y0-kdy, ::scaleColor)
		sy := ::Y0-kdy-(lendy-vdy)/2
		sx := ::X0+kdy+(lendy-vdy)/2
		if ::log
			//yav := int(sy-(log10(max(1, abs(::valAverage)))-rmin)*iif(::valAverage<0, -1, 1)*::dskl)
			yav := int(sy-(log10(max(1, abs(::valAverage))))*iif(::valAverage<0, -1, 1)*::dskl)
		else
			yav := int(sy-::valAverage*::dskl)
		endif
		for i=1 to ::__category
			j := ::arr[key][i]
			if ::log
				//y := int(sy-(log10(max(1, abs(j)))-rmin)*iif(j<0, -1, 1)*::dskl)
				y := int(sy-(log10(max(1, abs(j))))*iif(j<0, -1, 1)*::dskl)
			else
				y := int(sy-j*::dskl)
			endif
			x1 := arrx[i]+sx-::X0
			x2 := x1+colwidth

			if j>=0
				a := {{x1, sy-1}, {x1, y}, {x1+vdy, y-vdy}, {x2+vdy, y-vdy}, {x2+vdy, sy-1-vdy}, {x2, sy-1}}
				::image:filledPolygon(a, ::legendColor[kl])
				::image:polygon(a, ::scaleColor)
			else
				a := {{x1, y}, {x1, sy}, {x1+vdy, sy-vdy}, {x2+vdy, sy-vdy}, {x2+vdy, y-vdy}, {x2, y}}
				b := {{x1, sy}, {x1+vdy, sy-vdy}, {x2+vdy, sy-vdy}, {x2, sy}}
				::image:filledPolygon(a, ::legendColor[kl])
				::image:filledPolygon(b, ::legendColor[kl+cntColor])
				::image:polygon(a, ::scaleColor)

				::image:line(::X0, ::Y0, ::X0+::X, ::Y0, ::scaleColor)
				::image:line(::X0+::X, ::Y0, ::X0+::X+volume, ::Y0-volume, ::scaleColor)
				::image:fill(x2+vdy/2, sy+1, ::legendColor[kl+cntColor])
			endif
			if ::average>0
				if ::valAverage>0 .and. j>0
					if j >= ::valAverage
						::image:line(::X0, yav0, ::X0+::X, yav0, ::scaleColor)
						::image:line(::X0+::X, yav0, ::X0+::X+volume, yav0-volume, ::scaleColor)
						::image:fill(x1+colwidth/2, y-2, ::legendColor[kl+2*cntColor])
						::image:line(x2, yav, x2+vdy, yav-vdy, ::scaleColor)
						::image:line(x1, yav, x2, yav, ::scaleColor)
						::image:fill(x1+colwidth/2, y-2, ::legendColor[kl])
					else
						::image:filledPolygon(a, ::legendColor[kl+2*cntColor])
						::image:polygon(a, ::scaleColor)
						::image:line(::X0, yav0, ::X0+::X, yav0, ::scaleColor)
						::image:line(::X0+::X, yav0, ::X0+::X+volume, yav0-volume, ::scaleColor)
						if sy-2 > yav0
							::image:fill(x1+colwidth/2, sy-2, ::legendColor[kl])
						endif
					endif
				elseif j<0 .and. ::valAverage<0
					if j<::valAverage
						::image:line(x2, yav, x2+vdy, yav-vdy, ::scaleColor)
						::image:line(x1, yav, x2, yav, ::scaleColor)
						::image:fill(x1+colwidth/2, y-2, ::legendColor[kl+2*cntColor])
						::image:line(::X0, yav0, ::X0+::X, yav0, ::scaleColor)
						::image:line(::X0+::X, yav0, ::X0+::X+volume, yav0-volume, ::scaleColor)
						if y-2>yav0
							::image:fill(x1+colwidth/2, y-2, ::legendColor[kl])
						endif
					else
						::image:line(::X0, yav0, ::X0+::X, yav0, ::scaleColor)
						::image:line(::X0+::X, yav0, ::X0+::X+volume, yav0-volume, ::scaleColor)
					endif
				endif

			endif
			if j>=0
				::image:line(x1, y, x2, y, ::scaleColor)
				::image:line(x2, y, x2+vdy, y-vdy, ::scaleColor)
				::image:line(x2, y, x2, sy-1, ::scaleColor)
			else
				::image:line(x1, sy, x2, sy, ::scaleColor)
				::image:line(x2, sy, x2+vdy, sy-vdy, ::scaleColor)
				::image:line(x2, y, x2, sy+1, ::scaleColor)
			endif

		next

	next
return .t.


