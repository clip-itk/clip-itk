#include "gdinfo.ch"
#include "bggraph.ch"

function BgBaseGraphic(width, high)
local obj:= map()
	obj:image	:= -1
	obj:classname	:= "BG_TOOLS"
	obj:LX		:= iif(width==NIL, BG_DEFX, width)
	obj:LY		:= iif(high==NIL, BG_DEFY, high)
	obj:plsmin	:= NIL
	obj:plsmax	:= NIL
	obj:decmin	:= NIL
	obj:decmax	:= NIL
	obj:max		:= NIL
	obj:min		:= NIL

	obj:desc	:= NIL
	obj:Y		:= 0 	// startpoint
	obj:X		:= 0    //    graphic
	obj:X0		:= 0    // startpoint zero(x0, y0)
	obj:Y0		:= 0    //    graphic
	obj:sY0		:= 0
	obj:sX0		:= 0

	obj:backgrColor	:= NIL
	obj:scaleColor	:= NIL
	obj:legendColor	:= {}
	obj:arrColor	:= {}
	obj:avColor	:= {}

	obj:font_scale	:= 0
	obj:font_scale_width	:= 0
	obj:font_scale_high	:= 0
	obj:font_legend	:= 0
	obj:font_legend_width	:= 0
	obj:font_legend_high	:= 0
	obj:font_sign	:= 0
	obj:font_sign_width	:= 0
	obj:font_sign_high	:= 0
	obj:font_title	:= 0
	obj:font_title_width	:= 0
	obj:font_title_high	:= 0
	obj:font_subtitle	:= 0
	obj:font_subtitle_width	:= 0
	obj:font_subtitle_high	:= 0

	obj:log		:= .f.
	_recover_bg_tools(obj)
return obj
**************
function _recover_bg_tools(obj)
	obj:findVal	:= @bg_findVal()
	obj:drawScale	:= @bg_drawScale()
	obj:drawScale2	:= @bg_drawScale2()
	obj:createImage	:= @bg_createImage()
	obj:storeImage 	:= @bg_storeImage()
	obj:runVal	:= @bg_runVal()
	obj:__cleanVal	:= @bg_cleanValue()
	obj:__createColors:= @__bg_createColors()
	obj:__createFonts:= @__bg_createFonts()
return obj
**************
* ищет max/min положительные и отрицательные значения в одномерном массиве/мапе
*
static function bg_findVal(arr)
local j
	if arr == NIL .or. !(valtype(arr)$"AM") .or. empty(arr)
		return .f.
	endif
	if ::plsmin==NIL
		::plsmin := arr[1]
	endif
	if ::plsmax==NIL
		::plsmax := arr[1]
	endif
	if ::decmin==NIL
		::decmin := arr[1]
	endif
	if ::decmax==NIL
		::decmax := arr[1]
	endif
	for j in arr
		if j>=0
			if j<::plsmin
				::plsmin := j
			endif
			if j>::plsmax
				::plsmax := j
			endif
		else
			if ::decmin>=0 .or. j<::decmin
				::decmin := j
			endif
			if ::decmax>=0 .or. j>::decmax
				::decmax := j
			endif
		endif
	next
return .t.
*************
static function bg_createImage()
	::image := GdImageNew()
	if valtype(::image)=="N" .and. ::image == -1
		return .f.
	endif
	::image:create(::LX, ::LY)
	::backgrColor := ::image:newColor(0xFF, 0xFF, 0xFF)
	::scaleColor := ::image:newColor()
	::image:fill(0, 0, ::backgrColor)
	::__createColors()
	::__createFonts()
return .t.
************
static function __bg_createColors()
local color, i, dark
	color := { {255,   0,   0},;  // т красный
		   {  0, 170, 255},;  // голубой
		   {  0, 255,   0},;  // зеленый
		   {255, 255,   0},;  // желтый
		   {  0,   0, 255},;  // синий
		   {255,   0, 250},;  // розовый
		   {255, 150,   0},;  // оранжевый
		   {  0, 255, 255},;  // св голубой
		   {255,   0, 170},;  // яр розовый
		   {200, 255,   0};  // св зеленый
		}
	::avColor := {160, 160, 255}   // цвет среднего и крит знач значения
	for i=1 to len(color)
		aadd(::arrColor, ::image:newColor(color[i][1], color[i][2], color[i][3]))
	next
	dark := 150
	for i:=1 to len(color)
		aadd(::arrColor, ::image:newColor(iif(color[i][1]>0, color[i][1]+dark, 0), iif(color[i][2]>0, color[i][2]+dark, 0), iif(color[i][3]>0, color[i][3]+dark, 0)))
	next
	for i:=1 to len(color)
		aadd(::arrColor, ::image:newColor(iif(color[i][1]>0, color[i][1]+::avColor[1], 0), iif(color[i][2]>0, color[i][2]+::avColor[2], 0), iif(color[i][3]>0, color[i][3]+::avColor[3], 0)))
	next
	::legendColor := aclone(::arrColor)
return .t.
************
static function __bg_createFonts()
	::font_scale := 200
	::font_scale_width := (28 + 28/5)*GdCos(0)*::font_scale/1000
	::font_scale_high  := (28 + 28/5)*::font_scale/1000
	::font_title := 250
	::font_title_width := (28 + 28/5)*GdCos(0)*::font_title/1000
	::font_title_high  := (28 + 28/5)*::font_title/1000
	::font_subtitle := 250
	::font_subtitle_width := (28 + 28/5)*GdCos(0)*::font_subtitle/1000
	::font_subtitle_high  := (28 + 28/5)*::font_subtitle/1000
	::font_legend := 200
	::font_legend_width := (28 + 28/5)*GdCos(0)*::font_legend/1000
	::font_legend_high  := (28 + 28/5)*::font_legend/1000
	::font_sign := 200
	::font_sign_width := (28 + 28/5)*GdCos(0)*::font_sign/1000
	::font_sign_high  := (28 + 28/5)*::font_sign/1000
return .t.
****************
* ищет ближайшее целое кратное step, начиная с val
* d 1/-1 - ищет в сторону увеличения/уменьшения исходного значения val
static function bg_runVal(self, val, step, d)
local ret
	d := iif(d==NIL, 1, d)
	ret := int(val)
	do while (ret % step) != 0
		ret += d
	enddo
return ret
****************
static function bg_drawScale(selfs)
local fonColor, darkFonColor, colorAverage, mixedColor
local smax, smin, skl, _step, decmin, highTitle, highSubTitle, xx, yy
local lsign, widthLegend, highLegend
	fonColor  := ::image:newColor(230, 230, 230)
	darkFonColor := ::image:newColor(150, 150, 150)
	colorAverage := ::image:newColor(::avColor[1], ::avColor[2], ::avColor[3])
	mixedColor := ::image:newColor(::avColor[1]+100, ::avColor[2]+100, ::avColor[3]+100)

	if ::max-::min>1000 .or. ::log
		::log := .t. 	// логарифмическая шкала
		smax := int(10^(log10(int(max(1, ::max)))+1))
		if ::min<0
			smin := -int(10^(log10(int(abs(::min)))+1))
		else
			smin := 1
		endif

		skl := smax-int(::min)
		decmin := ::min
		if (smax>10000000 .or. smin<-10000000)
			_step := 100
		else
			_step := 10
		endif

	else
		::log := .f. 	// обычная шкала, не логаифмическая
		smax := int(::runVal(::max, 5, iif(::max<=0, -1, 1)))
		smin := int(::runval(::min, 5, -1))

		skl=smax-smin

		if (skl<=1)
			_step := 0.2
		elseif (skl<=10)
			_step := 2
		elseif (skl<=50)
			_step := 5
		elseif (skl<=100)
			_step := 10
		elseif (skl<=500)
			_step := 25
		else
			_step := 50
		endif
	endif
	if selfs:valAverage!=NIL .and. (selfs:valAverage>smax .or. selfs:valAverage<smin)
		selfs:valAverage := NIL
	endif
	if selfs:valCritic!=NIL .and. (selfs:valCritic>smax .or. selfs:valCritic<smin)
		selfs:valCritic := NIL
	endif

	//* width grade scale
	lsign := max(len(ZSTR(smax)), len(ZSTR(smin)))+iif("__ISNORM" $ selfs .and. selfs:__isNorm, 1, 0)
	/* координаты оси Х и размер в пикселах обеих осей зависят от места */
	/* заголовок к графику */
	highTitle=10
	if "title"$selfs
		symb := int(::LX/::font_title_width)
		m := splitLen(selfs:title, symb)
		highTitle := len(m)*(::font_title_high+5)+6
		yy := 0
		for i in m
			::image:stringVector(padc(i, symb), 0, yy+::font_title_high+3, ::font_title, 0, ::scaleColor)
			yy += ::font_title_high+5
		next
	endif

	::X0 := lsign*::font_scale_width
	::Y := ::LY-highTitle // длина шкалы y в пикселах
	::X := ::LX-::X0-10                         // длина шкалы x в пикселах

	if selfs:average>0
		::X -= ::font_scale_width*len(ZSTR(selfs:valAverage))
	endif
	/* положения легенды */
	widthLegend=0  // 20% of LX, max size for legend
	highLegend=0  // 20% of LY, max size for legend
	t := 0
	if selfs:__isLegend           // если есть легенда
		if empty(selfs:legend)
			for i=1 to selfs:__datarow
				aadd(selfs:legend, "Row "+ZSTR(i))
			next
		endif
		widthLegend := 20*::LX/100  // 20% LX
		highLegend := 20*::LY/100  // 20% LY
		do case
		case selfs:alignLeg == BG_ALIGN_LEFT      // left
			::X0 += widthLegend
			::X -= widthLegend     // длина шкалы x в пикселах
		case selfs:alignLeg == BG_ALIGN_TOP       // top
			t := highLegend
			::Y -= highLegend     // длина шкалы y в пикселах
		case selfs:alignLeg == BG_ALIGN_BOTTOM    // bottom
			t := highLegend
			::Y -= highLegend     // длина шкалы y в пикселах
		case selfs:alignLeg == BG_ALIGN_RIGHT    // right - default
			::X -= widthLegend     // длина шкалы x в пикселах
		endcase
	endif

	/* подвал к графику */
	highSubTitle := 10
	if !selfs:onlyLegend
		if "subtitle"$selfs
			symb := int(::LX/::font_subtitle_width)
			m := splitLen(selfs:subtitle, symb)
			highSubTitle := len(m)*(::font_subtitle_high+5)
			yy := ::LY-highSubTitle
			for i in m
				::image:stringVector(padc(i, symb), 0, yy+::font_subtitle_high, ::font_subtitle, 0, ::scaleColor)
				yy += ::font_subtitle_high+5
			next
		endif
	endif
	::Y -= highSubTitle
    /* подпись к шкале Y */
	highVrtTitle=0
	if !selfs:onlyLegend
		if "vrtTitle"$selfs .and. !empty(selfs:vrtTitle)
			symb := int(::Y/::font_sign_width)
			m := splitLen(selfs:vrtTitle, symb)
			highVrtTitle := len(m)*(::font_sign_high+5)+5  // ширина в пикселах подписи к оси Y
			xx := iif(selfs:alignLeg==0, widthLegend+5, 0)  // 0-left
			yy := highTitle+::Y+t
			for i in m
				::image:stringVector(padc(i, symb), xx+::font_sign_high+3, yy, ::font_sign, 270, ::scaleColor)
				xx += ::font_sign_width+5
			next
		endif
	endif

	::X -= highVrtTitle
	::X0 += highVrtTitle


	if selfs:volume
		if "__IS3D"$selfs .and. selfs:__is3D   // 3D
			selfs:valVolume := ::Y/4   // 1/3 of Y
		else
			selfs:valVolume := 10
		endif
	else
		selfs:valVolume=0
	endif
	volume := selfs:valVolume
	::Y -= volume; ::X -= volume
	if ::__isSignat
		::Y -= ::font_sign_high + 6
	endif

	if ::log
		if ::min>=0
			::dskl = ::Y/(log10(smax)-log10(10^(len(ZSTR(::min))-1)))
		else
			/*
			sk1 := log10(smax)-log10(10^(len(ZSTR(::plsmin))-1))
			sk2 := log10(10^(len(ZSTR(abs(::decmax)))))-log10(10^(len(ZSTR(abs(::decmin)))-1))
			*/
			sk1 := log10(10^(len(ZSTR(abs(smax)))-1))
			sk2 := log10(10^(len(ZSTR(abs(smin)))-1))

			::dskl := ::Y/(sk1+sk2)
		endif
	else
		::dskl = ::Y/skl
	endif

	::sY0 := highTitle+::Y+volume+t
	if ::min>=0 .and. ::max>0
		::Y0 := ::sY0
	elseif ::min<0 .and. ::max>0
		if ::log
			sk = -log10(10^(len(ZSTR(abs(::decmax)))-1))
			//::Y0 := ::sY0+(-log10(abs(::min))-sk)*::dskl
			::Y0 := ::sY0-log10(10^(len(ZSTR(abs(smin)))-1))*::dskl
			//::Y0 := ::sY0+(sk)*::dskl
		else
			::Y0 := ::sY0+smin*::dskl
		endif
	elseif ::min<0 .and. ::max<=0
		::Y0 := highTitle+t+volume
	endif
    /* drow оси координат */
	if !selfs:onlyLegend
		if !selfs:volume
			::image:filledRectangle(::X0, ::sY0-::Y, ::X0+::X, ::sY0, fonColor)
		endif
		::image:line(::X0, highTitle+t+volume, ::X0, highTitle+t+::Y+volume, ::scaleColor)        // y
		::image:line(::X0, ::Y0, ::X0+::X-volume, ::Y0, ::scaleColor)                     // x
		::image:line(::X0, highTitle+t+::Y+volume, ::X0+::X, highTitle+t+::Y+volume, ::scaleColor)  // -x
		if ::average>0
			if ::log
				yav := int(::Y0-log10(abs(::valAverage))*iif(::valAverage<0, -1, 1)*::dskl)
				va := int(log10(abs(::valAverage))*iif(::valAverage<0, -1, 1)*::dskl)
			else
				yav := int(::Y0-::valAverage*::dskl)
				va := int(::valAverage*::dskl)
			endif
		endif
		if selfs:volume
			x1=::X0; y1=highTitle+t+volume
			x2=::X0+volume; y2=highTitle+t
			x3=::X0+::X+volume; y3=y2
			x4=x3; y4=highTitle+t+::Y
			x5=x2; y5=y4
			x6=x1; y6=y1+::Y
			::image:filledPolygon({{x1,y1},{x2,y2},{x3,y3},{x4,y4},{x5,y5},{x6,y6}}, fonColor)
			::image:polygon({{x6,y6},{x5,y5},{x4,y4},{x4-volume,y6}}, ::scaleColor)

			::image:filledPolygon({{x6,::Y0},{x5,::Y0-volume},{x4,::Y0-volume},{x4-volume,::Y0}}, darkFonColor)
			::image:polygon({{x1,y1},{x2,y2},{x3,y3},{x4,y4},{x5,y5},{x6,y6}}, ::scaleColor)
			if ::average>0 .and. ::valAverage<0
				a := {{::X0, yav}, {::X0+volume, yav-volume}, {::X0+::X+volume, yav-volume}, {::X0+::X, yav}}
				::image:filledPolygon(a, colorAverage)
				::image:polygon(a, ::scaleColor)
				if between(yav-volume, ::Y0, ::Y0-volume)
					a := {{::X0-va, yav+va}, {::X0+volume, yav-volume}, {::X0+::X+volume+va, yav-volume}, {::X0+::X, yav+va}}
					::image:filledPolygon(a, mixedColor)
					::image:polygon(a, ::scaleColor)
				endif
			endif
			if ::average>0 .and. ::valAverage>0
				a := {{::X0, yav}, {::X0+volume, yav-volume}, {::X0+::X+volume, yav-volume}, {::X0+::X, yav}}
				::image:filledPolygon(a, colorAverage)
				::image:polygon(a, ::scaleColor)
				if between(yav, ::Y0,  ::Y0-volume)
					a := {{::X0+va, yav}, {::X0+volume, yav-volume+va}, {::X0+::X+volume-va, yav-volume+va}, {::X0+::X, yav}}
					::image:filledPolygon(a, mixedColor)
					::image:polygon(a, ::scaleColor)
				endif
			endif

			::image:line(x2, y2, x5, y5, ::scaleColor)
			::image:polygon({{x1,::Y0},{x2,::Y0-volume},{x3,::Y0-volume},{x3-volume,::Y0}}, ::scaleColor)
		endif
		z := iif("__ISNORM" $ selfs .and. selfs:__isNorm, "%", "")
		/*шкала справа
		if (element(set, "sc_right"))
			scx=X0+X;
			elf\gd\line(im, scx, highTitle+t+volume, scx, highTitle+t+Y+volume, color);
			scl=scx+2;
		}
		else{
		*/
			scx := ::X0
			scl := scx-2-lsign*::font_scale_width
		//endif
		if !::log
			::image:stringVector('0', ::X0-2-::font_scale_width, ::Y0, ::font_scale, 0, ::scaleColor)
		endif

		if ::log	//если шкала логарифмическая
			i :=_step
			/*
			i := int(10^(len(ZSTR(int(::min)))-1))
			if i<_step
				i := _step
			endif
			*/
			//rmin := log10(i)
			rmin=0
			do while i<=smax
				kj := i/_step
				for j=kj to i step kj
					y := int(::Y0-(log10(max(1, j))-rmin)*::dskl)
					if (y<::Y0)
						::image:line(scx-2, y, scx+2, y, ::scaleColor)
					endif
				next
				y := int(::Y0-(log10(i)-rmin)*::dskl)
				::image:stringVector(padl(ZSTR(i)+z, lsign), scl, y-::font_scale_width, ::font_scale, 0, ::scaleColor)

				::image:line(::X0+volume, y-volume, ::X0+::X+volume, y-volume, ::scaleColor)
				::image:line(scx-2, y, scx+2, y, ::scaleColor)
				::image:line(::X0, y, ::X0+volume, y-volume, ::scaleColor)
				i *= _step
			enddo
			i := _step
			do while i<=abs(smin)
				kj := i/_step
				for j=kj to i step kj
					y := int(::Y0+(log10(max(1, j))-rmin)*::dskl)
					::image:line(scx-2, y, scx+2, y, ::scaleColor)
				next
				y := int(::Y0+(log10(i)-rmin)*::dskl)
				::image:stringVector(padl(ZSTR(-i)+z, lsign), scl, y+::font_scale_width, ::font_scale, 0, ::scaleColor)
				::image:line(::X0+volume, y-volume, ::X0+::X+volume, y-volume, ::scaleColor)
				::image:line(scx-2, y, scx+2, y, ::scaleColor)
				::image:line(::X0, y, ::X0+volume, y-volume, ::scaleColor)
				i *= _step
			enddo
		else	// обычная шкала
			i := _step
			do while i<=smax
				y := int(::Y0-i*::dskl)
				::image:stringVector(padl(ZSTR(i)+z, lsign), scl, y, ::font_scale, 0, ::scaleColor)
				::image:line(::X0+volume, y-volume, ::X0+::X+volume, y-volume, ::scaleColor)
				::image:line(scx-2, y, scx+2, y, ::scaleColor)
				::image:line(::X0, y, ::X0+volume, y-volume, ::scaleColor)
				i += _step
			enddo
			i := -_step
			do while i>=smin
				y := int(::Y0-i*::dskl)
				::image:stringVector(padl(ZSTR(i)+z, lsign), scl, y, ::font_scale, 0, ::scaleColor)
				::image:line(::X0+volume, y-volume, ::X0+::X+volume, y-volume, ::scaleColor)
				::image:line(scx-2, y, scx+2, y, ::scaleColor)
				::image:line(::X0, y, ::X0+volume, y-volume, ::scaleColor)
				i -= _step
			enddo
		endif
	endif

	if !::log
		::min := smin
	endif
	::max := smax
    /* нарисовать легенду, eсли есть */
	if selfs:__isLegend .and. selfs:alignLeg > BG_ALIGN_NONE
		do case
		case selfs:alignLeg == BG_ALIGN_LEFT //left
			x1=0; yy=10+highTitle; maxy=::LY
		case selfs:alignLeg == BG_ALIGN_TOP //top
			x1=0; yy=5+highTitle; maxy=highLegend
		case selfs:alignLeg == BG_ALIGN_BOTTOM //bottom
			x1=0; yy=::Y+20+highTitle+volume; maxy=::LY-highSubTitle
		case selfs:alignLeg == BG_ALIGN_RIGHT //right
			x1=::LX-widthLegend; yy=10+highTitle; maxy=::LY
		endcase
		lenstr := int(widthLegend/::font_legend_width)
		y1 := yy
		for i=1 to ::__datarow
			::image:filledRectangle(x1, y1, x1+5, y1+10, ::legendColor[i])
			::image:rectangle(x1, y1, x1+5, y1+10, ::scaleColor)
			str := selfs:legend[i]
			do while len(str)>0
				::image:stringVector(substr(str, 1, lenstr), x1+10, y1+::font_legend_high, ::font_legend, 0, ::scaleColor)
				y1 += ::font_legend_high+3
				str := substr(str, lenstr+1)
				if y1+::font_legend_high>=maxy
					y1=yy; x1+=widthLegend+5
				endif
			enddo
			y1+=5
			if (y1+::font_legend_high) >= maxy
				y1=yy; x1+=widthLegend+15
			endif
		next
	endif
return .t.
****************
static function bg_drawScale2(selfs)
local fonColor, darkFonColor, colorAverage, mixedColor
local smax, smin, skl, _step, decmin, highTitle, highSubTitle, xx, yy
local lsign, widthLegend, highLegend
	fonColor  := ::image:newColor(230, 230, 230)
	darkFonColor := ::image:newColor(150, 150, 150)
	colorAverage := ::image:newColor(::avColor[1], ::avColor[2], ::avColor[3])
	mixedColor := ::image:newColor(::avColor[1]+100, ::avColor[2]+100, ::avColor[3]+100)

	::__cleanVal()
	if ::max-::min>1000
		::log := .t. 	// логарифмическая шкала
		smax := int(10^(log10(int(max(1, ::max)))+1))
		if ::min<0
			smin := -int(10^(log10(int(abs(::min)))+1))
		else
			smin := 1
		endif

		skl := smax-int(::min)
		decmin := ::min
		if (smax>10000000 .or. smin<-10000000)
			_step := 100
		else
			_step := 10
		endif

	else
		::log := .f. 	// обычная шкала, не логаифмическая
		smax := int(::runVal(::max, 5, iif(::max<=0, -1, 1)))
		smin := int(::runval(::min, 5, -1))

		skl=smax-smin

		if (skl<=1)
			_step := 0.2
		elseif (skl<=10)
			_step := 2
		elseif (skl<=50)
			_step := 5
		elseif (skl<=100)
			_step := 10
		elseif (skl<=500)
			_step := 25
		else
			_step := 50
		endif
	endif
	if selfs:valAverage!=NIL .and. (selfs:valAverage>smax .or. selfs:valAverage<smin)
		selfs:valAverage := NIL
	endif
	if selfs:valCritic!=NIL .and. (selfs:valCritic>smax .or. selfs:valCritic<smin)
		selfs:valCritic := NIL
	endif

	//* width grade scale
	lsign := max(len(ZSTR(smax)), len(ZSTR(smin)))+iif("__ISNORM" $ selfs .and. selfs:__isNorm, 1, 0)
	/* координаты оси Х и размер в пикселах обеих осей зависят от места */
	/* заголовок к графику */
	highTitle=10
	if "title"$selfs
		symb := int(::LX/::font_title_width)
		m := splitLen(selfs:title, symb)
		highTitle := len(m)*(::font_title_high+5)+6
		yy := 0
		for i in m
			::image:stringVector(padc(i, symb), 0, yy+::font_title_high+3, ::font_title, 0, ::scaleColor)
			yy += ::font_title_high+5
		next
	endif

	::X0 := lsign*::font_scale_width
	::Y := ::LY-highTitle // длина шкалы y в пикселах
	::X := ::LX-::X0-10                         // длина шкалы x в пикселах

	if selfs:average>0
		::Y -= ::font_scale_width*len(ZSTR(selfs:valAverage))
	endif
	/* положения легенды */
	widthLegend=0  // 20% of LX, max size for legend
	highLegend=0  // 20% of LY, max size for legend
	t := 0
	if selfs:__isLegend           // если есть легенда
		if empty(selfs:legend)
			for i=1 to selfs:__datarow
				aadd(selfs:legend, "Row "+ZSTR(i))
			next
		endif
		widthLegend := 20*::LX/100  // 20% LX
		highLegend := 20*::LY/100  // 20% LY
		do case
		case selfs:alignLeg == BG_ALIGN_LEFT      // left
			::X0 += widthLegend
			::X -= widthLegend     // длина шкалы x в пикселах
		case selfs:alignLeg == BG_ALIGN_TOP       // top
			t := highLegend
			::Y -= highLegend     // длина шкалы y в пикселах
		case selfs:alignLeg == BG_ALIGN_BOTTOM    // bottom
			t := highLegend
			::Y -= highLegend     // длина шкалы y в пикселах
		case selfs:alignLeg == BG_ALIGN_RIGHT    // right - default
			::X -= widthLegend     // длина шкалы x в пикселах
		endcase
	endif

	/* подвал к графику */
	highSubTitle := 10
	if !selfs:onlyLegend
		if "subtitle"$selfs
			symb := int(::LX/::font_subtitle_width)
			m := splitLen(selfs:subtitle, symb)
			highSubTitle := len(m)*(::font_subtitle_high+5)
			yy := ::LY-highSubTitle
			for i in m
				::image:stringVector(padc(i, symb), 0, yy+::font_subtitle_high, ::font_subtitle, 0, ::scaleColor)
				yy += ::font_subtitle_high+5
			next
		endif
	endif
	::Y -= highSubTitle
    /* подпись к шкале Y */
	highVrtTitle=0
	if !selfs:onlyLegend
		if "vrtTitle"$selfs .and. !empty(selfs:vrtTitle)
			symb := int(::Y/::font_sign_width)
			m := splitLen(selfs:vrtTitle, symb)
			highVrtTitle := len(m)*(::font_sign_high+5)+5  // ширина в пикселах подписи к оси Y
			xx := iif(selfs:alignLeg==0, widthLegend+5, 0)  // 0-left
			yy := highTitle+::Y+t
			for i in m
				::image:stringVector(padc(i, symb), xx+::font_sign_high+3, yy, ::font_sign, 270, ::scaleColor)
				xx += ::font_sign_width+5
			next
		endif
	endif

	::X -= highVrtTitle
	::X0 += highVrtTitle


	if selfs:volume
		if "__IS3D"$selfs .and. selfs:__is3D   // 3D
			selfs:valVolume := ::Y/4   // 1/3 of Y
		else
			selfs:valVolume := 10
		endif
	else
		selfs:valVolume=0
	endif
	volume := selfs:valVolume
	::Y -= volume; ::X -= volume
	if ::__isSignat
		::Y -= ::font_sign_high + 6
	endif

	if ::log
		if ::min>=0
			//::dskl = ::X/(log10(smax)-log10(10^(len(ZSTR(::min))-1)))
			::dskl = ::X/log10(10^(len(ZSTR(abs(smax)))-1))
		else
			/*
			sk1 := log10(smax)-log10(10^(len(ZSTR(plsmin))-1))
			sk2 := log10(10^(len(ZSTR(abs(decmax)))))-log10(10^(len(ZSTR(abs(decmin)))-1))
			*/
			sk1 := log10(10^(len(ZSTR(abs(smax)))-1))
			sk2 := log10(10^(len(ZSTR(abs(smin)))-1))
			::dskl := ::X/(sk1+sk2)
		endif
	else
		::dskl = ::X/skl
	endif

	::Y0 := highTitle+::Y+volume+t
	::sX0 := ::X0
	if ::min<0 .and. ::max>0
		if ::log
			sk = -log10(10^(len(ZSTR(abs(::decmax)))-1))
			//::X0 := ::sX0+(-log10(abs(::min))-sk)*::dskl
			::X0 := ::sX0+log10(10^(len(ZSTR(abs(smin)))-1))*::dskl
		else
			::X0 := ::sX0-smin*::dskl
		endif
	elseif ::min<0 .and. ::max<=0
		::X0 += ::X
	endif
    /* drow оси координат */
	if !selfs:onlyLegend
		if !selfs:volume
			::image:filledRectangle(::sX0, ::Y0-::Y, ::sX0+::X, ::Y0, fonColor)
		endif
		::image:line(::X0, highTitle+t+volume, ::X0, highTitle+t+::Y+volume, ::scaleColor)        // y
		::image:line(::sX0, ::Y0, ::sX0+::X-volume, ::Y0, ::scaleColor)                     // x

		if ::average>0
			if ::log
				xav := int(::X0+log10(abs(::valAverage))*iif(::valAverage<0, -1, 1)*::dskl)
				va := int(log10(abs(::valAverage))*iif(::valAverage<0, -1, 1)*::dskl)
			else
				xav := int(::X0+::valAverage*::dskl)
				va := int(::valAverage*::dskl)
			endif
			//::image:stringVector(ZSTR(int(::valAverage)), xav+volume, ::Y0-::Y-volume-::font_scale_high, ::font_scale, 0, ::scaleColor)
		endif

		if selfs:volume
			x1=::sX0; y1=::Y0
			x2=::sX0; y2=::Y0-::Y
			x3=::sX0+volume; y3=y2-volume
			x4=x3+::X; y4=y3
			x5=x4; y5=::Y0-volume
			x6=::sX0+::X; y6=::Y0

			::image:filledPolygon({{x1,y1},{x2,y2},{x3,y3},{x4,y4},{x5,y5},{x6,y6}}, fonColor)
			::image:polygon({{x1,y1},{x1+volume,y1-volume},{x5,y5},{x6,y6}}, ::scaleColor)

			a := {{::X0,::Y0},{::X0+volume,::Y0-volume},{::X0+volume,::Y0-::Y-volume},{::X0,::Y0-::Y}}
			::image:filledPolygon(a, darkFonColor)
			::image:polygon(a, ::scaleColor)
			if ::average>0 .and. ::valAverage<0
				a := {{xav, ::Y0}, {xav+volume, ::Y0-volume}, {xav+volume, ::Y0-::Y-volume}, {xav, ::Y0-::Y}}
				::image:filledPolygon(a, colorAverage)
				::image:polygon(a, ::scaleColor)

				if between(xav+volume, ::X0, ::X0+volume)
					va :=::X0-xav
					a := {{xav+va, ::Y0-va}, {xav+volume, ::Y0-volume}, {xav+volume, ::Y0-::Y-volume+va}, {xav+va, ::Y0-::Y}}
					::image:filledPolygon(a, mixedColor)
					::image:polygon(a, ::scaleColor)
				endif
			endif
			if ::average>0 .and. ::valAverage>0
				a := {{xav, ::Y0}, {xav+volume, ::Y0-volume}, {xav+volume, ::Y0-::Y-volume}, {xav, ::Y0-::Y}}
				::image:filledPolygon(a, colorAverage)
				::image:polygon(a, ::scaleColor)
				if between(xav, ::X0,  ::X0+volume)
					va := xav-::X0
					a := {{xav, ::Y0-va}, {xav, ::Y0-::Y}, {::X0+volume, ::Y0-::Y-va}, {::X0+volume, ::Y0-volume}}
					::image:filledPolygon(a, mixedColor)
					::image:polygon(a, ::scaleColor)
				endif
			endif

			::image:line(x1+volume, y1-volume, x5, y5, ::scaleColor)
			::image:polygon({{x1,y1},{x2,y2},{x3,y3},{x1+volume,::Y0-volume}}, ::scaleColor)
		endif
		z := iif("__ISNORM" $ selfs .and. selfs:__isNorm, "%", "")
		/*шкала справа
		if (element(set, "sc_right"))
			scx=X0+X;
			elf\gd\line(im, scx, highTitle+t+volume, scx, highTitle+t+Y+volume, color);
			scl=scx+2;
		}
		else{
		*/
			scx := ::X0
			scl := scx-2-lsign*::font_scale_width
		//endif
		y := ::Y0// + ::font_scale_high
		if !::log
			::image:stringVector('0', ::X0, y+::font_scale_high+2, ::font_scale, 0, ::scaleColor)
		endif

		if ::log	//если шкала логарифмическая
			i :=_step
			/*
			i := int(10^(len(ZSTR(int(::min)))-1))
			if i<_step
				i := _step
			endif
			rmin := log10(i)
			*/
			rmin=0
			do while i<=smax
				kj := i/_step
				for j=kj to i step kj
					x := int(::X0+(log10(max(1, j))-rmin)*::dskl)
					if (x>::X0)
						::image:line(x, ::Y0+2, x, ::Y0-2, ::scaleColor)
					endif
				next
				x := int(::X0+(log10(i)-rmin)*::dskl)
				::image:stringVector(padl(ZSTR(i)+z, lsign), x, y+::font_scale_high+2, ::font_scale, 0, ::scaleColor)

				::image:line(x+volume, y-::Y-volume, x+volume, y-volume, ::scaleColor)
				::image:line(x, ::Y0+2, x, ::Y0-2, ::scaleColor)
				::image:line(x, y, x+volume, y-volume, ::scaleColor)
				i *= _step
			enddo
			i := _step
			do while i<=abs(smin)
				kj := i/_step
				for j=kj to i step kj
					x := int(::X0-(log10(max(1, j))-rmin)*::dskl)
					::image:line(x, ::Y0+2, x, ::Y0-2, ::scaleColor)
				next
				x := int(::X0-(log10(i)-rmin)*::dskl)
				::image:stringVector(padl(ZSTR(-i)+z, lsign), x, y+::font_scale_high+2, ::font_scale, 0, ::scaleColor)
				::image:line(x+volume, y-::Y-volume, x+volume, y-volume, ::scaleColor)
				::image:line(x, ::Y0+2, x, ::Y0-2, ::scaleColor)
				::image:line(x, y, x+volume, y-volume, ::scaleColor)
				i *= _step
			enddo
		else	// обычная шкала
			i := _step
			do while i<=smax
				x := int(::X0+i*::dskl)
				::image:stringVector(padl(ZSTR(i)+z, lsign), x, y+::font_scale_high+2, ::font_scale, 0, ::scaleColor)
				::image:line(x+volume, y-::Y-volume, x+volume, y-volume, ::scaleColor)
				::image:line(x, ::Y0+2, x, ::Y0-2, ::scaleColor)
				::image:line(x, y, x+volume, y-volume, ::scaleColor)
				i += _step
			enddo
			i := -_step
			do while i>=smin
				x := int(::X0+i*::dskl)
				::image:stringVector(padl(ZSTR(i)+z, lsign), x, y+::font_scale_high+2, ::font_scale, 0, ::scaleColor)
				::image:line(x+volume, y-::Y-volume, x+volume, y-volume, ::scaleColor)
				::image:line(x, ::Y0+2, x, ::Y0-2, ::scaleColor)
				::image:line(x, y, x+volume, y-volume, ::scaleColor)
				i -= _step
			enddo
		endif
	endif

	if !::log
		::min := smin
	endif
	::max := smax
    /* нарисовать легенду, eсли есть */
	if selfs:__isLegend  .and. selfs:alignLeg > BG_ALIGN_NONE
		do case
		case selfs:alignLeg == BG_ALIGN_LEFT //left
			x1=0; yy=10+highTitle; maxy=::LY
		case selfs:alignLeg == BG_ALIGN_TOP //top
			x1=0; yy=5+highTitle; maxy=highLegend
		case selfs:alignLeg == BG_ALIGN_BOTTOM //bottom
			x1=0; yy=::Y+20+highTitle+volume; maxy=::LY-highSubTitle
		 case selfs:alignLeg == BG_ALIGN_RIGHT //right
			x1=::LX-widthLegend; yy=10+highTitle; maxy=::LY
		endcase
		lenstr := int(widthLegend/::font_legend_width)
		y1 := yy
		for i=1 to ::__datarow
			::image:filledRectangle(x1, y1, x1+5, y1+10, ::legendColor[i])
			::image:rectangle(x1, y1, x1+5, y1+10, ::scaleColor)
			str := selfs:legend[i]
			do while len(str)>0
				::image:stringVector(substr(str, 1, lenstr), x1+10, y1+::font_legend_high, ::font_legend, 0, ::scaleColor)
				y1 += ::font_legend_high+3
				str := substr(str, lenstr+1)
				if y1+::font_legend_high>=maxy
					y1=yy; x1+=widthLegend+5
				endif
			enddo
			y1+=5
			if (y1+::font_legend_high) >= maxy
				y1=yy; x1+=widthLegend+15
			endif
		next
	endif
return .t.
***************
static function bg_cleanValue()
	::plsmin := NIL
	::plsmax := NIL
	::decmin := NIL
	::decmax := NIL
return .t.
***************
static function bg_storeImage(typ, filename)
	if valtype(::image)=="N" .and. ::image == -1
		return .f.
	endif
	typ := iif(typ==NIL, GDFILE_PNG, typ)
	filename := iif(filename==NIL, tmpfile()+".png", filename)
	::image:toFile(filename, typ)
return .t.

