#include <inkey.ch>
#include <clip-gtk.ch>
#include <fwin/msgxpm.ch>

static sItem:=1, rwin:=1, cWin:=1, rows:=1, cols := 6, hideCol:=0
static items, entry, header, footHeader, headerWidth
static headerName, footHeaderName
static frame, box, itemBox, headBox, footHeadBox, vBox
static frameHb, frameFb
static style, baseStyle, headstyle, footHeadstyle
static hAdj, vAdj, vScroll, hScroll
static paned, sw_width, sw_height
static heightHeadBox:=0, heightfootHeadBox:=0, heightScroll:=0, heightItemBox:=0

static fr_cWin:=0, fr_cols:=0 // frozen columns
static fr_items, fr_entry, fr_header, fr_footHeader, fr_headerWidth
static fr_headerName, fr_footHeaderName
static fr_frame, fr_box, fr_itemBox, fr_headBox, fr_footHeadBox, fr_vBox
static fr_frameHb, fr_frameFb
static fr_hAdj, fr_hScroll   	// horizontal scroll for frozen columns
				// vertical scroll - one of both
static fr_Style

static blue,yellow,red,magenta

local nW, nH,  w, da, sx, sy
local green:=nil, pixel:=nil

//static pixmap
local pixmap

set(_SET_MAPERR,.T.)
gtk_init()

w := gtk_windowNew(, 'Testing window')
gtk_SignalConnect(w, 'delete-event', {|w| gtk_WidgetHideOnDelete(w)})
gtk_SignalConnect(w, GTK_HIDE_SIGNAL, {|w| gtk_quit()})
gtk_SignalConnect(w, GTK_EVENT, {|w, e| handler(w, e)})


gtk_WIdgetSetPosition(w, 100, 100)
gtk_WidgetSetSize(w, 550, 300)
gtk_WidgetRealize(w)

frame := array(cols)
frameHb := array(cols)
frameFb := array(cols)
items := array(100, cols)
entry := array(rows, cols)
box := array(cols)
header := array(cols)
headerWidth := array(cols)
headerName := array(cols)
footHeaderName := array(cols)
footHeader := array(cols)

itemBox := gtk_HboxNew()
headBox := gtk_HboxNew()
footHeadBox := gtk_HboxNew()

vBox := gtk_VboxNew()
hBox := gtk_HboxNew()


colormap := gtk_WidgetGetColormap(w)
basestyle:= gtk_WidgetGetDefaultStyle()
basestyle:colormap := colormap
white := gdk_ColorParse("white")
red := gdk_ColorParse("red")
gray := gdk_ColorParse("gray")
yellow := gdk_ColorParse("yellow")
blue := gdk_ColorParse("blue")
gdk_colormapAllocColor(basestyle:colormap, white)
gdk_colormapAllocColor(basestyle:colormap, red)
gdk_colormapAllocColor(basestyle:colormap, gray)
gdk_colormapAllocColor(basestyle:colormap, yellow)
gdk_colormapAllocColor(basestyle:colormap, blue)

style := clone(baseStyle)
style:fg_color := {red, red, red, red,red}

footHeadstyle := clone(baseStyle)
footHeadstyle:bg_color := {gray, gray, gray, gray, gray}

headstyle := clone(baseStyle)
headstyle:bg_color := {gray, gray, gray, gray, gray}

gtk_WidgetSetDefaultStyle(basestyle)

/* init items */
for j:= 1 to cols
	/* init header boxes */
	frameHb[j] := gtk_frameNew()
	gtk_frameSetShadowType(frameHb[j], GTK_SHADOW_NONE)
	header[j] := gtk_ButtonNew()
	header[j]:id := j
	gtk_SignalConnect(header[j], GTK_CLICKED_SIGNAL, {|btn| freez(btn)})
	vb := gtk_vBoxNew()
	headerWidth[j] := 80
	if j==1
		headerWidth[j] := 120
	endif
	gtk_ButtonSetRelief(header[j], GTK_RELIEF_NONE)
	gtk_ContainerAdd(header[j], vb)
	headerName[j] := "Head"+str(j,2)+";"
	if j==3
		headerName[j] += "next string"
	endif

	header[j]:label := array(2)
	r := split(headerName[j], ";")
	for k=1 to 2
		header[j]:label[k] := gtk_LabelNew(, r[k])
		gtk_BoxPackStart(vb, header[j]:label[k])
	next

	gtk_WidgetSetSize(header[j], headerWidth[j])
	gtk_WidgetSetStyle(header[j], headstyle)

	gtk_ContainerAdd(frameHb[j], header[j])
	gtk_BoxPackStart(headBox, frameHb[j])

	/* init footHeader boxes */
	frameFb[j] := gtk_frameNew()
	gtk_frameSetShadowType(frameFb[j], GTK_SHADOW_IN)
	footHeader[j] := gtk_vBoxNew()
	footHeader[j]:label := array(1)
	footHeaderName[j] := "footHead"+str(j,2)+";"
	r := split(footHeaderName[j], ";")
	for k=1 to 1
		footHeader[j]:label[k] := gtk_LabelNew(, r[k])
		gtk_BoxPackStart(footHeader[j], footHeader[j]:label[k])
	next
	gtk_widgetsetSize(footHeader[j], headerWidth[j])
	gtk_WidgetSetStyle(footHeader[j], footHeadstyle)
	gtk_ContainerAdd(frameFb[j], footHeader[j])
	gtk_BoxPackStart(footHeadBox, frameFb[j])

	frame[j] := gtk_frameNew()
	box[j] := gtk_vBoxNew()
	gtk_frameSetShadowType(frame[j], GTK_SHADOW_IN)
	gtk_ContainerAdd(frame[j], box[j])
	gtk_boxPackStart(itemBox, frame[j])
next

for i=1 to 100


	for j:= 1 to cols
		items[i][j] := "item["+alltrim(tostring(i))+"]["+alltrim(tostring(j))+"]"
	next
next

hAdj := gtk_AdjustmentNew(, 1.0, 1.0, cols+1.0, 1.0, 1.0, 1.0)
hScroll := gtk_HScrollBarNew(, hAdj)
gtk_SignalConnect(hAdj, "value-changed", {|w, e| local (v:=-1, l:=-1, u:=-1), gtk_AdjustmentGetValue(w, @v, @l, @u),  changeCols(v), qout(v, l, u)},)


paned := gtk_HpanedNew()//ospsd
gtk_BoxPackStart(vbox, headBox)
gtk_BoxPackStart(vbox, itemBox, .t., .t.)
gtk_BoxPackEnd(vbox, hScroll)
gtk_BoxPackEnd(vbox, footHeadBox)
gtk_PanedPack2(paned, vbox, .f., .t.)
//gtk_PanedAdd2(paned, vbox)
gtk_BoxPackStart(hBox, paned, .t., .t.)

gtk_containerAdd(w, hBox)



initTable()
setTable(1)
gtk_WidgetSetFocus(entry[rWin][cWin]:handle)

size := len(items)
vAdj := gtk_AdjustmentNew(, 1.0, 1.0, size+1.0, 1.0, rows*1.0, 1.0)
vScroll := gtk_VScrollBarNew(, vAdj)
gtk_SignalConnect(vAdj, "value-changed", {|w, e| local (v:=-1, l:=-1, u:=-1), gtk_AdjustmentGetValue(w, @v, @l, @u),  changeRows(v), qout(v, l, u)},)

vb := gtk_VBoxNew()

hFrame := gtk_FrameNew()
hfbox := gtk_VBoxNew()
bpgup := gtk_ButtonNew()
gtk_SignalConnect(bpgup, GTK_CLICKED_SIGNAL, {|btn| page_up()})
gtk_ContainerAdd(bpgup, gtk_PixmapCreateFromXPMd(, pgupXPM))
bgotop := gtk_ButtonNew()
gtk_SignalConnect(bgotop, GTK_CLICKED_SIGNAL, {|btn| go_top()})
gtk_ContainerAdd(bgotop, gtk_PixmapCreateFromXPMd(, gotopXPM))
gtk_ContainerAdd(hFrame, hfbox)
gtk_BoxPackStart(hfbox, bgotop)
gtk_BoxPackStart(hfbox, bpgup)
gtk_FrameSetShadowType(hFrame, GTK_SHADOW_NONE)

shFrame := gtk_FrameNew()
shfbox := gtk_VBoxNew()
bpgdn := gtk_ButtonNew()
gtk_SignalConnect(bpgdn, GTK_CLICKED_SIGNAL, {|btn| page_down()})
gtk_ContainerAdd(bpgdn, gtk_PixmapCreateFromXPMd(, pgdnXPM))
bgobottom := gtk_ButtonNew()
gtk_SignalConnect(bgobottom, GTK_CLICKED_SIGNAL, {|btn| go_bottom()})
gtk_ContainerAdd(bgobottom, gtk_PixmapCreateFromXPMd(, gobottomXPM))
gtk_ContainerAdd(shFrame, shfbox)
gtk_BoxPackStart(shfbox, bpgdn)
gtk_BoxPackStart(shfbox, bgobottom)
gtk_FrameSetShadowType(shFrame, GTK_SHADOW_NONE)

gtk_BoxPackStart(vb, hFrame)
gtk_boxPackStart(vb, vScroll, .t., .t.)
gtk_boxPackEnd(vb, shFrame)

gtk_boxPackEnd(hBox, vb)
//gtk_WidgetShowAll(vb)

gtk_WidgetShowAll(w)

gtk_WidgetGetSize(paned, @sw_width, @sw_height)
gtk_WidgetGetSize(headBox,,@heightHeadBox)
gtk_WidgetGetSize(itemBox, ,@heightItemBox)
gtk_WidgetGetSize(footHeadBox,,@heightfootHeadBox)

heightScroll := sw_height - heightHeadBox - heightItemBox - heightfootHeadBox + 1


size_allocate(paned)


gtk_SignalConnect(paned, 'size-allocate', {|w| size_allocate(w)})
gtk_SignalConnect(hAdj, "value-changed", {|w, e| local (v:=-1, l:=-1, u:=-1), gtk_AdjustmentGetValue(w, @v, @l, @u),  qout(v, l, u)},)

qout()
gtk_main()
return
***************************************************************************
static function initTable(startR, startC, frRedraw)
local i, j
startR := iif(startR == NIL, 1, startR)
startC := iif(startC==NIL, 1, startC)
frRedraw := iif(frRedraw==NIL, .t., frRedraw)
for i=startR to rows
	for j:= startC to cols
		entry[i][j] := gtk_ButtonNew(, "")
		entry[i][j]:i := i
		entry[i][j]:j := j
		gtk_SignalConnect(entry[i][j], GTK_CLICKED_SIGNAL, {|w| rWin := w:i, cWin := w:j, qout(gtk_buttonGetText(w))})
		gtk_buttonsetrelief(entry[i][j], GTK_RELIEF_NONE)
		gtk_boxpackStart(box[j], entry[i][j])
		gtk_WidgetSetSize(box[j], headerWidth[j])
		gtk_WidgetShow(entry[i][j])
	next
next
if fr_cols > 0 .and. frRedraw
	InitFrozenPart(startR, 1)
endif
return

static function setTable(sI, startR, frRedraw)
local i, j, c, r, k
startR := iif(startR == NIL, 1, startR)
frRedraw := iif(frRedraw==NIL, .t., frRedraw)
for i=startR to rows
	for j:= 1 to cols
		c := j+hideCol
		if (i+sI-1)<=len(items) .and. c<=cols
			gtk_ButtonSetLabel(entry[i][j], items[i+sI-1][c])

			header[j]:id := c
			r := split(headerName[c], ";")
			for k=1 to 2
				gtk_LabelSetText(header[j]:label[k], r[k])
			next

			r := split(footHeaderName[c], ";")
			for k=1 to 1
				gtk_LabelSetText(footHeader[j]:label[k], r[k])
			next
			/*
			if i==startR
				gtk_widgetsetSize(box[j], headerWidth[c])
				gtk_widgetsetSize(header[j], headerWidth[c])
				gtk_widgetsetSize(footHeader[j], headerWidth[c])
			endif
			*/

		else
			gtk_ButtonSetLabel(entry[i][j] , "")
			for k=1 to 2
				gtk_LabelSetText(header[j]:label[k], "")
			next
			for k=1 to 1
				gtk_LabelSetText(footHeader[j]:label[k], "")
			next
		endif

if i+sI-1==2
	gtk_buttonSetStyle(entry[i][j], style)
else
	gtk_buttonSetStyle(entry[i][j], basestyle)
endif

	next
next
if fr_cols >0 .and. frRedraw
	setFrozenPart(sI, startR)
endif
return
*******************************************************************************
static function changeRows(value)
	if between(value, sItem, sItem+rows-1)
		rWin := value - sItem + 1
		gtk_WidgetSetFocus(entry[rWin][cWin])
	elseif value < sItem .and. value > 0
		if value <= rows
			rWin := value
			sItem := 1
		else
			rWin := 1
			sItem := value//-rows+1
		endif
		setTable(sItem)
		gtk_WidgetSetFocus(entry[rWin][cWin])
	elseif value >= sItem+rows-1
		if value+rows-1 <= len(items)
			rWin := rows
			sItem := value-rows+1
		else
			sItem := len(items) - rows + 1
			rWin := value - sItem + 1
		endif
		setTable(sItem)
		gtk_WidgetSetFocus(entry[rWin][cWin])
	endif
return
*******************************************************************************
static function changeCols(value)
local c1, r1, c2, r2
	gtk_WidgetGetPosition(entry[rWin][1], @c1, @r1)
	if value-hideCol<1
		hideCol --
		setTable(sItem)
		changeCols(value)
	endif
	gtk_WidgetGetPosition(entry[rWin][value-hideCol], @c2, @r2)
	if ( c1 <= c2 ) .and. ;
		(c2 < sw_width .and. c2 + headerWidth[value-hideCol]<sw_width)
		cWin := value-hideCol
		gtk_WidgetSetFocus(entry[rWin][cWin])
	elseif value <= hideCol
		hideCol --
		setTable(sItem)
		changeCols(value)
	else
		hideCol ++
		setTable(sItem)
		changeCols(value)
	endif
return
*******************************************************************************
static function handler(win, event)
local nKey, nState
	if event:event!= GTK_KEY_PRESS
		return .f.
	endif
	nKey := Event:keyval
	nState := Event:state

	if nState == 1
		nState := 1//VK_SHIFT
	elseif nState == 4
		nState := 4//VK_CONTROL
	endif

	do case
	case nKey == K_CTRL_PGDN
		go_bottom()
	case nKey == K_CTRL_PGUP
		go_top()
	case nKey == K_PGDN
		page_down()
	case nKey == K_PGUP
		page_up()
	case nKey == K_DOWN
		rWin ++
		if rWin>rows
			rwin := rows
			sItem ++
			sItem := min(sItem, len(items)-rows+1)
			setTable(sItem)
		else
			gtk_WidgetSetFocus(entry[rwin][cWin])
		endif
		gtk_AdjustmentSetValue(vAdj, sItem+rWin-1)
	case nKey == K_UP
		rWin --
		if rWin<1
			rwin := 1
			sItem --
			sItem := max(sItem, 1)
			setTable(sItem)
		else
			gtk_WidgetSetFocus(entry[rwin][cWin])
		endif
		gtk_AdjustmentSetValue(vAdj, sItem+rWin-1)
	case nKey == K_RIGHT
		if cWin+hideCol==cols
			return .t.
		endif
		cWin ++
		cWin := min(cols, cWin)
		gtk_WidgetGetPosition(entry[rWin][cWin], @c, @r)
		if c>sw_width .or. c+headerWidth[cWin]>sw_width
			hideCol ++
			hideCol := min(hideCol, cols-1)
			cWin--

			setTable(sItem)
		endif
		gtk_WidgetSetFocus(entry[rWin][cWin])
		gtk_AdjustmentSetValue(hAdj, cWin+hideCol)
		return .t.
	case nKey == K_LEFT
		if cWin == 1 .and. hideCol == 0
			return .t.
		endif
		cWin --
		if cWin == 0
			cWin ++
			hideCol --
			setTable(sItem)
		endif
		gtk_WidgetSetFocus(entry[rwin][cWin])

		gtk_AdjustmentSetValue(hAdj, cWin+hideCol)
	endcase

return
*******************************************************************************
static function go_bottom()
	sItem := len(items)-rows+1
	setTable(sItem)
	gtk_AdjustmentSetValue(vAdj, len(items))
	gtk_WidgetSetFocus(entry[len(entry)][cWin])
return
*******************************************************************************
static function	go_top()
	sItem := 1
	setTable(sItem)
	gtk_AdjustmentSetValue(vAdj, 1)
	gtk_WidgetSetFocus(entry[1][cWin])
return
*******************************************************************************
static function	page_down()
	sItem += rows-1
	sItem := min(sItem, len(items)-rows+1)
	setTable(sItem)
	gtk_AdjustmentSetValue(vAdj, sItem+rWin-1)
	gtk_WidgetSetFocus(entry[rwin][cWin])
return
*******************************************************************************
static function	page_up()
	sItem -= rows-1
	sItem := max(1, sItem)
	setTable(sItem)
	gtk_AdjustmentSetValue(vAdj, sItem+rWin-1)
	gtk_WidgetSetFocus(entry[rwin][cWin])
return
*******************************************************************************
static function size_allocate(win)
local oldrows := rows, w, h, w1, h1, i, r
	/* width and height paned */
	gtk_WidgetGetSize(win, @sw_width, @sw_height)

	//gtk_WidgetGetSize(itemBox, @w, @h)

	h := sw_height - heightHeadBox -heightfootHeadBox - heightScroll + 1
	qout('itemBox height', h, sw_height)
	w1:=0; h1:=0
	gtk_WidgetGetSize(entry[1][1], @w1, @h1)
	r := int(h/h1)
	if r > oldrows
		rows := r
		asize(entry, rows)
		for i=oldrows+1 to rows
			entry[i] := array(cols)
		next
		if fr_cols>0
			asize(fr_entry, rows)
			for i=oldrows+1 to rows
				fr_entry[i] := array(fr_cols)
			next
		endif
		initTable(oldrows+1)
		setTable(sItem, oldrows+1)
		//gtk_WidgetShowAll(itemBox)
		gtk_WidgetShow(Paned)
	elseif r < oldrows
		rows := r
		for i=oldrows to rows+1 step -1
			for j=1 to cols
				gtk_WidgetDestroy(entry[i][j])
			next
		next
		asize(entry, rows)
		if fr_cols>0
			for i=oldrows to rows+1 step -1
				for j=1 to fr_cols
					gtk_WidgetDestroy(fr_entry[i][j])
				next
			next
			asize(fr_entry, rows)
		endif
		if rWin > rows
			rWin := rows
			gtk_WidgetSetFocus(entry[rWin][cWin])
		endif
	endif
qout('size-allocate rows=', rows, len(entry))
return
**************************************************************************
* freez columns
static function freez(oBtn)
local cln

	if cols==1
		qout("Can't freez last column!")
		return .f.
	endif
	cln := oBtn:id
	fr_cols ++
	AddFrozenPart(cln)
	InitFrozenPart()
	setTable(sItem)
	gtk_WidgetSetFocus(entry[rWin, cWin])
return .t.
**************************************************************************
*
static function AddFrozenPart(cln)

if fr_cols == 1
	fr_itemBox := gtk_HboxNew()
	fr_headBox := gtk_HboxNew()
	fr_footHeadBox := gtk_HboxNew()

	fr_vBox := gtk_VboxNew()

endif

if fr_entry==NIL
	fr_frame := array(fr_cols)
	fr_frameHb := array(fr_cols)
	fr_frameFb := array(fr_cols)
	fr_items := array(100, fr_cols)
	fr_entry := array(rows, fr_cols)
	fr_box := array(fr_cols)
	fr_header := array(fr_cols)
	fr_headerWidth := array(fr_cols)
	fr_headerName := array(fr_cols)
	fr_footHeaderName := array(fr_cols)
	fr_footHeader := array(fr_cols)

	fr_style := clone(baseStyle)
	fr_style:fg_color := {blue, blue, blue, blue}
else
	asize(fr_frame, fr_cols)
	asize(fr_frameHb, fr_cols)
	asize(fr_frameFb, fr_cols)
	for j=1 to 100
		asize(fr_items[j], fr_cols)
	next
	for j=1 to rows
		asize(fr_entry[j], fr_cols)
	next
	asize(fr_box, fr_cols)
	asize(fr_header, fr_cols)
	asize(fr_headerWidth, fr_cols)
	asize(fr_headerName, fr_cols)
	asize(fr_footHeaderName, fr_cols)
	asize(fr_footHeader, fr_cols)
endif

/* init items */
j:= fr_cols

/* init header boxes */
fr_frameHb[j] := gtk_frameNew()
gtk_frameSetShadowType(fr_frameHb[j], GTK_SHADOW_NONE)
fr_header[j] := gtk_ButtonNew()
fr_header[j]:id := j
gtk_SignalConnect(fr_header[j], GTK_CLICKED_SIGNAL, {|btn| antifreez(btn)})
vb := gtk_vBoxNew()
fr_headerWidth[j] := headerWidth[cln]
/* remove item from headerWidth */
adel(headerWidth, cln)
asize(headerWidth, cols-1)

gtk_ButtonSetRelief(fr_header[j], GTK_RELIEF_NONE)
gtk_ContainerAdd(fr_header[j], vb)
fr_headerName[j] := headerName[cln]
/* remove item from headerName */
adel(headerName, cln)
asize(headerName, cols-1)

fr_header[j]:label := array(2)
r := split(fr_headerName[j], ";")
for k=1 to 2
	fr_header[j]:label[k] := gtk_LabelNew(, r[k])
	gtk_BoxPackStart(vb, fr_header[j]:label[k])
next

gtk_WidgetSetSize(fr_header[j], fr_headerWidth[j])
gtk_WidgetSetStyle(fr_header[j], headstyle)

gtk_ContainerAdd(fr_frameHb[j], fr_header[j])
gtk_BoxPackStart(fr_headBox, fr_frameHb[j])

/* init footHeader boxes */
fr_frameFb[j] := gtk_frameNew()
gtk_frameSetShadowType(fr_frameFb[j], GTK_SHADOW_IN)
fr_footHeader[j] := gtk_vBoxNew()
fr_footHeader[j]:label := array(1)
fr_footHeaderName[j] := footHeaderName[cln]
/* remove item from footHeaderName */
adel(footHeaderName, cln)
asize(footHeaderName, cols - 1)

for k=1 to 1
	fr_footHeader[j]:label[k] := gtk_LabelNew(, r[k])
	gtk_BoxPackStart(fr_footHeader[j], fr_footHeader[j]:label[k])
next
gtk_widgetsetSize(fr_footHeader[j], fr_headerWidth[j])
gtk_WidgetSetStyle(fr_footHeader[j], footHeadstyle)
gtk_ContainerAdd(fr_frameFb[j], fr_footHeader[j])
gtk_BoxPackStart(fr_footHeadBox, fr_frameFb[j])

fr_frame[j] := gtk_frameNew()
fr_box[j] := gtk_vBoxNew()
gtk_frameSetShadowType(fr_frame[j], GTK_SHADOW_IN)
gtk_ContainerAdd(fr_frame[j], fr_box[j])
gtk_boxPackStart(fr_itemBox, fr_frame[j])


for i=1 to 100
	fr_items[i][fr_cols] := items[i][cln]
	/* remove from items */
	adel(items[i], cln)
	asize(items[i], cols - 1)
next

//fr_hAdj := gtk_AdjustmentNew(, 1.0, 1.0, fr_cols+1.0, 1.0, 1.0, 1.0)
if fr_cols==1
	fr_hAdj := gtk_AdjustmentNew(, 1.0, 1.0, fr_cols+1.0, 1.0, 1.0, 1.0)
	fr_hScroll := gtk_HScrollBarNew(, fr_hAdj)
	gtk_SignalConnect(fr_hAdj, "value-changed", {|w, e| local (v:=-1, l:=-1, u:=-1), gtk_AdjustmentGetValue(w, @v, @l, @u),  fr_changeCols(v), qout(v, l, u)},)
	gtk_BoxPackStart(fr_vbox, fr_headBox)
	gtk_BoxPackStart(fr_vbox, fr_itemBox, .t., .t.)
	gtk_BoxPackEnd(fr_vbox, fr_hScroll)
	gtk_BoxPackEnd(fr_vbox, fr_footHeadBox)
	gtk_PanedPack1(paned, fr_vbox, .t., .f.)
endif

/* remove widget */
for j=1 to rows
	gtk_WidgetDestroy(entry[j][cln])
	adel(entry[j], cln)
	asize(entry[j], cols-1)
next
gtk_WidgetDestroy(frameHb[cln])
gtk_WidgetDestroy(frame[cln])
gtk_WidgetDestroy(frameFb[cln])
cols --
hAdj := gtk_AdjustmentNew(, 1.0, 1.0, cols+1.0, 1.0, 1.0, 1.0)
adel(header, cln)
asize(header, cols)
adel(footHeader, cln)
asize(footHeader, cols)
adel(box, cln)
asize(box, cols)
adel(frame, cln)
asize(frame, cols)
adel(frameHb, cln)
asize(frameHb, cols)
adel(frameFb, cln)
asize(frameFb, cols)
if cWin+hideCol > cln
	cWin --
endif
//gtk_WidgetShowAll(itemBox)

//gtk_WidgetShowAll(paned)
gtk_WidgetShowAll(fr_vBox)
return
**************************************************************************
*
static function setFrozenPart(sI, startR)
local i, j, r, k
startR := iif(startR == NIL, 1, startR)
for i=startR to rows
	for j:= 1 to fr_cols
		if (i+sI-1)<=len(fr_items) .and. j<=fr_cols
			gtk_ButtonSetLabel(fr_entry[i][j], fr_items[i+sI-1][j])

			fr_header[j]:id := j
			r := split(fr_headerName[j], ";")
			for k=1 to 2
				gtk_LabelSetText(fr_header[j]:label[k], r[k])
			next

			r := split(fr_footHeaderName[j], ";")
			for k=1 to 1
				gtk_LabelSetText(fr_footHeader[j]:label[k], r[k])
			next
			if i==startR
				gtk_widgetsetSize(fr_box[j], fr_headerWidth[j])
				gtk_widgetsetSize(fr_header[j], fr_headerWidth[j])
				gtk_widgetsetSize(fr_footHeader[j], fr_headerWidth[j])
			endif

		else
			gtk_ButtonSetLabel(fr_entry[i][j] , "")
			for k=1 to 2
				gtk_LabelSetText(fr_header[j]:label[k], "")
			next
			for k=1 to 1
				gtk_LabelSetText(fr_footHeader[j]:label[k], "")
			next
		endif

if i+sI-1==2
	gtk_buttonSetStyle(fr_entry[i][j], style)
else
	gtk_buttonSetStyle(fr_entry[i][j], fr_style)
endif

	next
next
return
**************************************************************************
*
static function InitFrozenPart(startR, startC)
local i, j
startR := iif(startR == NIL, 1, startR)
startC := iif(startC==NIL, fr_cols, startC)
for i=startR to rows
	for j := startC to fr_cols
		fr_entry[i][j] := gtk_ButtonNew(, "")
		fr_entry[i][j]:i := i
		fr_entry[i][j]:j := j
		gtk_SignalConnect(fr_entry[i][j], GTK_CLICKED_SIGNAL, {|w| rWin := w:i, cWin := w:j, qout(gtk_buttonGetText(w))})
		gtk_buttonsetrelief(fr_entry[i][j], GTK_RELIEF_NONE)
		gtk_boxpackStart(fr_box[j], fr_entry[i][j])
		gtk_WidgetSetSize(fr_box[j], fr_headerWidth[j])
		gtk_WidgetShow(fr_entry[i][j])
	next
next
return
**************************************************************************
* antifreez columns
static function antiFreez(oBtn)
local cln

	cln := oBtn:id
	cols ++
	DelFrozenPart(cln)
	InitTable(,cols, .f.)
	setTable(sItem,,.t.)
	gtk_WidgetSetFocus(entry[rWin, cWin])
return .t.

**************************************************************************
*
static function DelFrozenPart(cln)

	asize(frame, cols)
	asize(frameHb, cols)
	asize(frameFb, cols)
	for j=1 to 100
		asize(items[j], cols)
	next
	for j=1 to rows
		asize(entry[j], cols)
	next
	asize(box, cols)
	asize(header, cols)
	asize(headerWidth, cols)
	asize(headerName, cols)
	asize(footHeaderName, cols)
	asize(footHeader, cols)

qout('new col is', cols)
/* init items */
j:= cols

/* init header boxes */
frameHb[j] := gtk_frameNew()
gtk_frameSetShadowType(frameHb[j], GTK_SHADOW_NONE)
header[j] := gtk_ButtonNew()
header[j]:id := j
gtk_SignalConnect(header[j], GTK_CLICKED_SIGNAL, {|btn| freez(btn)})
vb := gtk_vBoxNew()
headerWidth[j] := fr_headerWidth[cln]
/* remove item from fr_headerWidth */
adel(fr_headerWidth, cln)
asize(fr_headerWidth, fr_cols-1)

gtk_ButtonSetRelief(header[j], GTK_RELIEF_NONE)
gtk_ContainerAdd(header[j], vb)
headerName[j] := fr_headerName[cln]
/* remove item from fr_headerName */
adel(fr_headerName, cln)
asize(fr_headerName, fr_cols-1)

header[j]:label := array(2)
r := split(headerName[j], ";")
for k=1 to 2
	header[j]:label[k] := gtk_LabelNew(, r[k])
	gtk_BoxPackStart(vb, header[j]:label[k])
next

gtk_WidgetSetSize(header[j], headerWidth[j])
gtk_WidgetSetStyle(header[j], headstyle)

gtk_ContainerAdd(frameHb[j], header[j])
gtk_BoxPackStart(headBox, frameHb[j])

/* init footHeader boxes */
frameFb[j] := gtk_frameNew()
gtk_frameSetShadowType(frameFb[j], GTK_SHADOW_IN)
footHeader[j] := gtk_vBoxNew()
footHeader[j]:label := array(1)
footHeaderName[j] := fr_footHeaderName[cln]
/* remove item from fr_footHeaderName */
adel(fr_footHeaderName, cln)
asize(fr_footHeaderName, fr_cols - 1)

for k=1 to 1
	footHeader[j]:label[k] := gtk_LabelNew(, r[k])
	gtk_BoxPackStart(footHeader[j], footHeader[j]:label[k])
next
gtk_widgetsetSize(footHeader[j], headerWidth[j])
gtk_WidgetSetStyle(footHeader[j], footHeadstyle)
gtk_ContainerAdd(frameFb[j], footHeader[j])
gtk_BoxPackStart(footHeadBox, frameFb[j])

frame[j] := gtk_frameNew()
box[j] := gtk_vBoxNew()
gtk_frameSetShadowType(frame[j], GTK_SHADOW_IN)
gtk_ContainerAdd(frame[j], box[j])
gtk_boxPackStart(itemBox, frame[j])


for i=1 to 100
	items[i][cols] := fr_items[i][cln]
	/* remove from fr_items */
	adel(fr_items[i], cln)
	asize(fr_items[i], fr_cols - 1)
next


/* remove widget */
for j=1 to rows
	gtk_WidgetDestroy(fr_entry[j][cln])
	adel(fr_entry[j], cln)
	asize(fr_entry[j], fr_cols-1)
next
gtk_WidgetDestroy(fr_frameHb[cln])
gtk_WidgetDestroy(fr_frame[cln])
gtk_WidgetDestroy(fr_frameFb[cln])
fr_cols --
adel(fr_header, cln)
asize(fr_header, fr_cols)
adel(fr_footHeader, cln)
asize(fr_footHeader, fr_cols)
adel(fr_box, cln)
asize(fr_box, fr_cols)
adel(fr_frame, cln)
asize(fr_frame, fr_cols)
adel(fr_frameHb, cln)
asize(fr_frameHb, fr_cols)
adel(fr_frameFb, cln)
asize(fr_frameFb, fr_cols)

if fr_cols==0
	gtk_WidgetDestroy(fr_hScroll)
	gtk_WidgetDestroy(fr_headBox)
	gtk_WidgetDestroy(fr_itemBox)
	gtk_WidgetDestroy(fr_footHeadBox)
	gtk_WidgetDestroy(fr_vBox)
	gtk_WidgetShowAll(paned)
else
	gtk_WidgetShow(fr_vBox)
	gtk_WidgetShowAll(vBox)
endif

return

