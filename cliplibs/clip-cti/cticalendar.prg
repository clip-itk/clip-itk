/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	CTI_CALENDAR
	Author	: Elena Kornilova (alena@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/


#include "cti.ch"
#include "ctievents.ch"

#include "setcurs.ch"
#include "inkey.ch"

#define	SUPERCLASS	CTI_WINDOW

static amonths:= {[jan], [feb], [mar], [apr], [may], [jun], [jul], [aug], [sep], [oct], [nov], [dec]}
static aweek := {[sun], [mon], [tue], [wed], [thu], [fri], [sat]}

function cti_calendar_new(dDate)
	local obj := cti_inherit(cti_window_new([Calendar],1,1, 10, 32),"CTI_CALENDAR")

	obj:__items	:= array(6, 7)

	obj:__date	:= iif(dDate==NIL .or. valtype(dDate)!="D", date(), dDate)

	obj:__lHeading		:= .t.  // show header - month name, year
	obj:__lDayNames		:= .t.  // show weekday names
	obj:__lNoChange		:= .f.  // change months & years by button
	obj:__lWeekNumbers 	:= .t.  // show week numbers
	obj:__lStartMonday 	:= .t.  // week start monday
	obj:__lReminder		:= .t.  // check reminder events
	obj:__lRemList		:= .f.  // choose reminder from list

	obj:__grayColor		:= "W/B,R/W"
	obj:__currColor		:= "GR+/B"
	obj:__baseColor		:= "W+/B,R/W"
	obj:__baseColorDis	:= "N/BG"
	obj:__baseColorSel	:= "W+/G"
	obj:__headColor		:= obj:palette:ActiveBorder//"R/B"
	obj:__infoColor		:= "R/B"
	obj:__btnColor		:= "R/B"
	obj:__redDayColor 	:= "R+/R"
	obj:__redDayColorSel 	:= "R/G"

	obj:__layout		:= nil

	obj:__reminder		:= nil
	obj:__floatReminder	:= nil
	obj:__floatRules	:= nil
	obj:__remList		:= nil

	obj:__inFocus	:= nil
	obj:__x		:= 1
	obj:__y		:= 1

	obj:__Months	:= {[January], [February], [March], [April], [May], ;
			    [June], [July], [August], [September], [October], ;
			    [November], [December]}

	obj:__Days	:= array(7)
	obj:__weekNumb	:= array(6)

	obj:__headMonth	:= nil
	obj:__headYear	:= nil
	obj:__lenHeadMonth := 0

	obj:__prevMonth	:= nil
	obj:__nextMonth	:= nil
	obj:__prevYear	:= nil
	obj:__nextYear	:= nil

	obj:set_size		:= @cti_calendar_set_size()
//	obj:set_position	:= @cti_calendar_set_position()
	obj:show		:= @cti_calendar_show()
	obj:get_date		:= @cti_calendar_get_date()

	obj:show_heading	:= @cti_calendar_show_heading()
	obj:show_day_names	:= @cti_calendar_show_day_names()
	obj:no_month_change	:= @cti_calendar_no_month_change()
	obj:show_week_numbers	:= @cti_calendar_show_week_numbers()
	obj:week_start_monday	:= @cti_calendar_week_start_monday()
	obj:set_reminder	:= @cti_calendar_set_reminder()
	obj:set_reminder_list	:= @cti_calendar_set_reminder_list()

	obj:__init		:= @cti_calendar_init()
	obj:__set_items		:= @cti_calendar_set_items()
	obj:__set_header	:= @cti_calendar_set_header()
	obj:__set_focus		:= @cti_calendar_set_focus()
	obj:__set_cursor	:= {||setcursor(0)}

	obj:put			:= {|self, ctiobj, y, x| self:__layout:add(ctiobj, y, x)}

	obj:__change_month	:= @cti_calendar_change_month()
	obj:__month_inc		:= {|self| self:__change_month(1)}
	obj:__month_dec		:= {|self| self:__change_month(-1)}
	obj:__change_year	:= @cti_calendar_change_year()
	obj:__year_inc		:= {|self| self:__change_year(1)}
	obj:__year_dec		:= {|self| self:__change_year(-1)}
	obj:__day_selected	:= @cti_calendar_day_selected()
	obj:__clicked		:= {|self| self:signal_emit(HASH_DAY_SELECTED_SIGNAL)}


	obj:__left		:= @cti_calendar_left()
	obj:__right		:= @cti_calendar_right()
	obj:__up		:= @cti_calendar_up()
	obj:__down		:= @cti_calendar_down()

	obj:__init_reminder	:= @cti_calendar_init_reminder()
	obj:__init_reminder_list:= @cti_calendar_init_reminder_list()
	obj:__parse_reminder_str:= @cti_calendar_parse_reminder_str()
	obj:__check_reminder_date:= @cti_calendar_check_reminder_date()
	obj:__get_reminder	:= @cti_calendar_get_reminder()
	obj:__activate_list	:= {|self| iif(self:__lRemList, self:__remList:set_focus(), )}
	obj:__choose_day_by_list:= @cti_calendar_choose_day_by_list()

	obj:realize_real	:= @cti_calendar_realize_real()

	obj:__init()

return obj
*******************************************************************************
* Init
static function cti_calendar_init(self)
local i, j

	self:__layout := cti_layout_new()
	self:__layout:show()
	self:add(self:__layout)

	/* init reminder */
	if self:__lReminder
		self:__init_reminder()
	endif

	/* init signals */
	self:signal_connect(HASH_PREV_MONTH_SIGNAL, {|w, e| w:__change_month(-1)})
	self:signal_connect(HASH_NEXT_MONTH_SIGNAL, {|w, e| w:__change_month(1)})
	self:signal_connect(HASH_PREV_YEAR_SIGNAL, {|w, e| w:__change_year(-1)})
	self:signal_connect(HASH_NEXT_YEAR_SIGNAL, {|w, e| w:__change_year(1)})
	self:signal_connect(HASH_DAY_SELECTED_SIGNAL, {|w, e| w:__day_selected()})
	self:signal_connect(HASH_CHOOSE_DAY_BY_LIST_SIGNAL, {|w, e| w:__choose_day_by_list()})

	/* init operation */
	self:set_key(K_LEFT, self:__left)
	self:set_key(K_RIGHT, self:__right)
	self:set_key(K_UP, self:__up)
	self:set_key(K_DOWN, self:__down)
	self:set_key(K_CTRL_T, self:__get_reminder)
	self:set_key(K_PGUP, self:__month_dec)
	self:set_key(K_PGDN, self:__month_inc)
	self:set_key(K_CTRL_Y, self:__year_dec)
	self:set_key(K_CTRL_U, self:__year_inc)
	self:set_key(K_CTRL_L, self:__activate_list)
	//self:set_key(K_ENTER, self:__clicked)
	self:set_key(K_ENTER, self:__clicked)


	/*
	self:palette:window := self:__baseColor
	self:palette:ActiveBorder := self:__baseColor
	self:palette:ActiveCaption := self:__baseColor
	*/
	/* init day names */
	if self:__lDayNames
		for i=1 to 7
			self:__Days[i] := cti_label_new("")
			self:__Days[i]:palette:label := self:__headColor
			self:__Days[i]:set_size(1, 3)
		next
	endif
	self:week_start_monday(self:__lStartMonday)

	/* init week numbers */
	if self:__lWeekNumbers
		for i=1 to 6
			self:__weekNumb[i] := cti_label_new("")
			self:__weekNumb[i]:palette:label := self:__headColor
			self:__weekNumb[i]:set_size(1, 2)
		next
	endif

	/* init items */
	for i=1 to 6
		for j=1 to 7
			self:__items[i][j] := cti_entry_new("C","99")
			self:__items[i][j]:set_editable(.f.)
			self:__items[i][j]:palette:control := self:__baseColor
			self:__items[i][j]:palette:DisabledControl := self:__baseColorDis
			self:__items[i][j]:set_size(1, 2)
			self:__items[i][j]:month := 0
			self:__items[i][j]:set_key(K_LEFT,nil)
			self:__items[i][j]:set_key(K_RIGHT,nil)
			self:__items[i][j]:set_key(K_CTRL_Y,nil)
			self:__items[i][j]:set_key(K_CTRL_U,nil)
			self:__items[i][j]:set_key(K_CTRL_T,nil)
			self:__items[i][j]:set_key(K_ENTER,nil)
			/*
			self:__items[i][j]:signal_connect(HASH_CTI_CHANGED_SIGNAL, ;
			     {|w, e, oCal| oCal:signal_emit(cti_signal_new(HASH_DAY_SELECTED_SIGNAL))}, self)
			*/
		next
	next
	self:__set_items()

	/* take length headMonth */
	self:__lenHeadMonth := len(self:__Months[1])
	for i=2 to 12
		j := len(self:__Months[i])
		if j>self:__lenHeadMonth
			self:__lenHeadMonth := j
		endif
	next

	/* init header */
	self:__headMonth:= cti_label_new()
	self:__headMonth:palette:label := self:__infoColor
	self:__headMonth:set_size(1, self:__lenHeadMonth)
	self:__headYear	:= cti_label_new()
	self:__headYear:palette:label := self:__infoColor
	self:__headYear:set_size(1, 4)

	self:__prevMonth:= cti_pushbutton_new("<")
	self:__prevMonth:set_style()
	self:__prevMonth:palette:control := self:__btnColor
	self:__prevMonth:signal_connect(HASH_CTI_CLICKED_SIGNAL, ;
		{|w, e, oCal| oCal:signal_emit(cti_signal_new(HASH_PREV_MONTH_SIGNAL))}, self)
	self:__nextMonth:= cti_pushbutton_new(">")
	self:__nextMonth:set_style()
	self:__nextMonth:palette:control := self:__btnColor
	self:__nextMonth:signal_connect(HASH_CTI_CLICKED_SIGNAL, ;
		{|w, e, oCal| oCal:signal_emit(cti_signal_new(HASH_NEXT_MONTH_SIGNAL))}, self)
	self:__prevYear	:= cti_pushbutton_new("<")
	self:__prevYear:set_style()
	self:__prevYear:palette:control := self:__btnColor
	self:__prevYear:signal_connect(HASH_CTI_CLICKED_SIGNAL, ;
		{|w, e, oCal| oCal:signal_emit(cti_signal_new(HASH_PREV_YEAR_SIGNAL))}, self)
	self:__nextYear	:= cti_pushbutton_new(">")
	self:__nextYear:set_style()
	self:__nextYear:palette:control := self:__btnColor
	self:__nextYear:signal_connect(HASH_CTI_CLICKED_SIGNAL, ;
		{|w, e, oCal| oCal:signal_emit(cti_signal_new(HASH_NEXT_YEAR_SIGNAL))}, self)

	self:__set_header()


return
*******************************************************************************
* set items
static function cti_calendar_set_items(self, curDate)
local i, j, first, day, month, year, dw, lastPrev, lastd, endm, curDay, description

	curDate := iif(curDate==nil, self:__date, curDate)
	curDay := day(curDate)
	day := day(curDate)
	month := month(curDate)
	year := year(curDate)
	first := date(year, month, 1)
	lastPrev :=date(year-iif(month-1==0, 1, 0), iif(month-1==0, 12, month-1), 1)

	dw := dow(first)-iif(self:__lStartMonday, 1, 0)
	/* add last days of prev month */
	lastd := lastDayOM(lastPrev)
	i := 1

	self:freeze()

	//dw := iif(dw==0, 7, dw)
	if dw > 0
		for j=dw-1 to 1 step -1
			self:__items[1][i]:set_value(Lastd-j+1)
			self:__items[1][i]:palette:control:= self:__grayColor
			self:__items[1][i]:month := -1
			i++
		next
	elseif dw ==0
		for j=6 to 1 step -1
			self:__items[1][i]:set_value(Lastd-j+1)
			self:__items[1][i]:palette:control:= self:__grayColor
			self:__items[1][i]:month := -1
			i++
		next
	endif

	/* add first days of month */
	day := 1
	self:__weekNumb[1]:set_text(str(week(first),2))
	self:__sId := self:__items[1][i]:id
	for i=i to 7
		self:__items[1][i]:set_value(day)
		self:__items[1][i]:palette:control := self:__baseColor
		self:__items[1][i]:palette:selection := self:__baseColorSel

		if curDay == day
			self:__inFocus := self:__items[1][i]
			self:__x := i
			self:__y := 1
		endif
		/* for reminder */
		self:__items[1][i]:remstr := ""
		day ++
	next
	/* add days of month */
	endm := .f.
	lastd := lastDayOM(curDate)
	i := 1
	for i=2 to 6
		self:__weekNumb[i]:set_text(str(week(date(year, month, day)),2))
		for j=1 to 7
			if day<=lastd .and. !endm
				self:__items[i][j]:set_value(day)
				self:__items[i][j]:palette:control := self:__baseColor
				self:__items[i][j]:palette:selection := self:__baseColorSel
				if curDay == day
					self:__inFocus := self:__items[i][j]
					self:__x := j
					self:__y := i

				endif
				/* for reminder */
				self:__items[i][j]:remstr := ""
			else
				if !endm
					endm := .t.
					day := 1
					month ++
					if month>12
						month := 1
					endif
				endif
				self:__items[i][j]:set_value(day)
				self:__items[i][j]:palette:control := self:__grayColor
			endif
			day ++
		next
	next
	if self:__lReminder
		self:__check_reminder_date(curDate)
	endif
	/* add first days of next month */
	day := 1
	for j=j to 7
		self:__items[i][j]:set_value(day)
		self:__items[i][j]:palette:control := self:__grayColor
		self:__items[i][j]:month := 1
		day ++
	next

	self:thaw()
return
*******************************************************************************
* set size
static function cti_calendar_set_size(self, nHeight, nWidth)
local i, j


	CALL SUPER self:set_size(nHeight, nWidth)

	if !self:__is_realized; return TRUE; endif

/*
	/* set size for reminder list */
	if self:__lReminder .and. self:__lRemList
		self:__remList:set_size(3, nWidth-2)
		nHeight += 3
	endif
*/
return
*******************************************************************************
* set position
static function cti_calendar_set_position(self, nTop, nLeft)
//	nTop := iif(nTop==nil, self:top, nTop)
//	nLeft := iif(nLeft==nil, self:left, nLeft)

	CALL SUPER self:set_position(nTop, nLeft)
return
*******************************************************************************
* show calendar
static function cti_calendar_show(self)
local i, j, sx, sy

	CALL SUPER self:show()

	/* show header */
	if self:__lHeading
		sy := 0
		sx := 0
		self:__prevMonth:show()
		self:put(self:__prevMonth, sy, sx)
		self:__headMonth:show()
		sx += 2
		self:put(self:__headMonth, sy, sx)
		self:__nextMonth:show()
		self:put(self:__nextMonth, sy, sx+self:__lenHeadMonth+1)

		sx := 22
		self:__prevYear:show()
		self:put(self:__prevYear, sy, sx)
		self:__headYear:show()
		self:put(self:__headYear, sy, sx+2)
		self:__nextYear:show()
		self:put(self:__nextYear, sy, sx+7)
	endif


	sy := 1

	/* show name days */
	if self:__lDayNames
		sx := 3
		for i=1 to 7
			self:__Days[i]:show()
			self:put(self:__Days[i], sy, sx)
			sx += 4
		next
		sy ++
	endif

	/* show week numbers */
	if self:__lWeekNumbers
		j := sy
		for i=1  to 6
			self:__weekNumb[i]:show()
			self:put(self:__weekNumb[i], j, 0)
			j++
		next
	endif

	/* show days */
	for i=1 to 6
		sx := 3
		for j=1 to 7
			self:__items[i][j]:show()
			self:put(self:__items[i][j], sy, sx)
			sx += 4
		next
		sy ++
	next

	self:__inFocus:set_focus()

	/* show reminder list */
	if self:__lRemList
		sy ++
		self:__remList:show()
		self:put(self:__remList, sy, 0)
	endif
return
*******************************************************************************
* get date
static function cti_calendar_get_date(self)
return self:__date
*******************************************************************************
* set lShowHead
static function cti_calendar_show_heading(self, lShow)
	self:__lHeading := iif(lShow==nil, .t., lShow)
	self:draw()
return
*******************************************************************************
* set lShowDayNames
static function cti_calendar_show_day_names(self, lShow)
	self:__lDayNames := iif(lShow==nil, .t., lShow)
	self:draw()
return
*******************************************************************************
* set lnoMonth_change
static function cti_calendar_no_month_change(self)
return
*******************************************************************************
* set lShowWeekNumbers
static function cti_calendar_show_week_numbers(self, lShow)
	self:__lWeekNumbers := iif(lShow==nil, .t., lShow)
	self:draw()
return
*******************************************************************************
* set lWeekStartMonday
static function cti_calendar_week_start_monday(self, lStart)
local i, nameDays

	lStart := iif(lStart==nil, .t., lStart)
	if lStart
		nameDays := {[Mon], [Tue], [Wed], [Thu], [Fri], [Sat], [Sun]}
	else
		nameDays := {[Sun], [Mon], [Tue], [Wed], [Thu], [Fri], [Sat]}
	endif

	for i=1 to 7
		self:__Days[i]:set_text(nameDays[i])
	next

return

*******************************************************************************
* set header
static function cti_calendar_set_header(self)

	self:__headMonth:set_text(self:__Months[month(self:__date)])
	self:__headYear:set_text(str(year(self:__date),4))
return
*******************************************************************************
* set focus
static function cti_calendar_set_focus(self)
	CALL SUPER self:__set_focus()
	self:__inFocus:set_focus()
return
*******************************************************************************
* change month
static function cti_calendar_change_month(self, nM)
local day, month, year
	nM := iif(nM==nil, 0, nM)

	day := day(self:__date)
	month := month(self:__date)
	year := year(self:__date)
	month += nM

	if month<1
		month := 12
		year --
	endif
	if month>12
		month := 1
		year ++
	endif

	self:__date := date(year, month, day)

	self:__set_header()
	self:__set_items()
	self:__inFocus:set_focus()
return self:__date
*******************************************************************************
* change year
static function cti_calendar_change_year(self, nM)
local day, month, year
	nM := iif(nM==nil, 0, nM)

	day := day(self:__date)
	month := month(self:__date)
	year := year(self:__date)

	year += nM

	self:__date := date(year, month, day)
	self:__set_header()
	self:__set_items()
	self:__inFocus:set_focus()
return self:__date
*******************************************************************************
* change year
static function cti_calendar_day_selected(self)
	if self:__items[self:__y][self:__x]:month != 0
		self:__change_month(self:__items[self:__y][self:__x]:month)
		return
	endif
return
********************************************************************************
*
static function cti_calendar_left(self)
	self:__x--
	if self:__x <1
		self:__date := addmonth(self:__date, -1)
		self:__set_items()
		self:__set_header()
	else
		self:__date --
		self:__inFocus := self:__items[self:__y][self:__x]
	endif
	self:__inFocus:set_focus()
return
********************************************************************************
*
static function cti_calendar_right(self)
	self:__x++
	if self:__x > 7
		self:__date := addmonth(self:__date,1)
		self:__set_items()
		self:__set_header()
	else
		self:__date ++
		self:__inFocus := self:__items[self:__y][self:__x]
	endif
	self:__inFocus:set_focus()
return

********************************************************************************
*
static function cti_calendar_up(self)
	self:__y--
	self:__date -= 7
	if self:__y < 1
		self:__set_items()
		self:__set_header()
	else
		self:__inFocus := self:__items[self:__y][self:__x]
	endif
	self:__inFocus:set_focus()
return
********************************************************************************
*
static function cti_calendar_down(self)
	self:__y++
	self:__date += 7
	if self:__y > 6
		self:__set_items()
		self:__set_header()
	else
		self:__inFocus := self:__items[self:__y][self:__x]
	endif
	self:__inFocus:set_focus()
return
********************************************************************************
* set reminder
static function cti_calendar_set_reminder(self, lReminder)
local old_lReminder
	old_lReminder := self:__lReminder
	self:__lReminder := iif(lReminder==nil, !self:__lReminder, lReminder)

	if self:__lReminder
		self:__init_reminder()
	endif
return old_lReminder
********************************************************************************
* reminder initiation
static function cti_calendar_init_reminder(self)
local nFileEtc, nFileHome, fid, str, fe, fh

	nFileEtc := getenv("CLIPROOT")+"/etc/.calendar"
	nFileHome := getenv("HOME")+"/.clip/.calendar"
	fe := file(nFileEtc)
	fh := file(nFileHome)
	if !fe .and. !fh
		if self:__lRemList
			self:__remList:destroy()
		endif
		self:__lReminder := .f.
		self:__lRemList := .f.
		return .f.
	endif
	self:__reminder := map()
	self:__floatReminder := map()
	self:__floatRules := map()

	if fe
		fid := fopen(nFileEtc)
		do while !fileeof(fid)
			str := alltrim(filegetstr(fid, 1024))
			if empty(str) .or. substr(alltrim(str), 1, 2)=="/*"
				loop
			endif
			self:__parse_reminder_str(str)
		enddo
		fclose(fid)
	endif
	if fh
		fid := fopen(nFileHome)
		do while !fileeof(fid)
			str := alltrim(filegetstr(fid, 1024))
			if empty(str) .or. substr(alltrim(str), 1, 2)=="/*"
				loop
			endif
			self:__parse_reminder_str(str)
		enddo
		fclose(fid)
	endif
	self:__init_reminder_list()
return .t.
********************************************************************************
* init reminder list
static function cti_calendar_init_reminder_list(self)
	if self:__lRemList
		self:__remList := cti_list_new(2)
		self:__remList:set_column_width(1, 2)
		self:__remList:set_column_width(2, self:width-4)
		self:__remList:set_column_auto_resize(2,.T.)
		self:__remList:column_titles_show(.f.)
		self:__remList:set_key(K_ENTER, self:__choose_day_by_list)
		self:__remList:show()
	endif
return
********************************************************************************
* reminder parse string
static function cti_calendar_parse_reminder_str(self, str)
local k, description:="", arr, month, day, dayOfWeek, weekOfWeek, arrOfDay
local i, j,si, ei, sj, ej
	if empty(str)
		return .f.
	endif
	k := at("&\t", str)
	if k>0
		description := alltrim(substr(str, k+1))
		str := alltrim(substr(str, 1, k-1))
	endif

	arr := split(str, " ")
	month := nil
	day := nil
	dayOfWeek := nil
	weekOfWeek := nil
	arrOfDay := nil
	for i=1 to len(arr)
		arr[i] := lower(alltrim(arr[i]))
		if empty(arr[i])
			loop
		endif
		if arr[i]=="*"
			if day==nil
				day := "*"
			elseif month==nil
				month := "*"
			elseif dayOfWeek==nil
				dayOfWeek := "*"
			endif
			loop
		endif

		/* search mm/dd */
		k := at("/", arr[i])
		if k>0 .and. month == nil
			month := amonths[val(substr(arr[i],1, k-1))]
			arr[i] := substr(arr[i], k+1)
			if val(arr[i])!=0
				day := alltrim(arr[i])
				loop
			endif

		endif

		if val(arr[i]) != 0 .and. day == nil
			day := arr[i]
			loop
		endif

		k := ascan(amonths, substr(arr[i], 1, 3))
		if k>0 .and. month == nil
			month := arr[i]
			loop
		endif

		k := ascan(aweek, arr[i])
		if k>0
			dayOfWeek := arr[i]
			loop
		endif

		/* check first[mon|thu|...] */
		k := at("first", arr[i])
		if k>0
			weekOfWeek := 1
			arr[i] := strtran(arr[i], "first", "")
			k := ascan(aweek, arr[i])
			if k>0
				dayOfWeek := arr[i]
				loop
			endif
			weekOfWeek := 0
		endif

		/* check second[mon|thu|...] */
		k := at("second", arr[i])
		if k>0
			weekOfWeek := 2
			arr[i] := strtran(arr[i], "second", "")
			k := ascan(aweek, arr[i])
			if k>0
				dayOfWeek := arr[i]
				loop
			endif
			weekOfWeek := 0
		endif


		/* check third[mon|thu|...] */
		k := at("third", arr[i])
		if k>0
			weekOfWeek := 3
			arr[i] := strtran(arr[i], "third", "")
			k := ascan(aweek, arr[i])
			if k>0
				dayOfWeek := arr[i]
				loop
			endif
			weekOfWeek := 0
		endif


		/* check last[mon|thu|...] */
		k := at("last", arr[i])
		if k>0
			weekOfWeek := 4
			arr[i] := strtran(arr[i], "last", "")
			k := ascan(aweek, arr[i])
			if k>0
				dayOfWeek := arr[i]
				loop
			endif
			weekOfWeek := 0
		endif
	next

	/* create rulers for float events */
	if dayOfWeek!=nil
		iif(month==nil, month:="*", )
		iif(month=="*", (si := 1, ei := 12), (si := ascan(aMonths, month), ei := iif(si==0, -1, si)))
		iif(dayOfWeek=="*", (sj := 1, ej := 7), (sj := ascan(aWeek, dayOfWeek), ej := iif(sj==0, -1, sj)))
		iif(weekOfWeek==nil, weekOfWeek := 0, )
		for i=si to ei
			for j:=sj to ej
				k := i*100+j
				if k$self:__floatRules
					aadd(self:__floatRules[k], {iif(day==nil, "*", day), weekOfWeek, arrOfDay, description})
				else
					self:__floatRules[k] := {{iif(day==nil, "*", day), weekOfWeek, arrOfDay, description}}
				endif
			next
		next
		return
	endif

	/* add event to reminder and floatReminder */
	iif(day==nil, day:="1", )
	iif( month=="*", (si := 1, ei := 12), (si := ascan(aMonths, month), ei := iif(si==0, -1, si)))
	iif(day=="*", (sj := 1, ej := 31), (sj := val(day), ej := iif(sj==0, -1, sj)))

	for i=si to ei
		k := i*100
		for j=sj to ej
			if (k+j)$self:__reminder
				aadd(self:__reminder[k+j], description)
			else
				self:__reminder[k+j] := {description}
			endif
		next
	next
return .t.
********************************************************************************
* reminder check date
static function cti_calendar_check_reminder_date(self, curDate)
local i, k, day, _dom, month, monthx, item, j, week, sweek, rules, s
	if !self:__lReminder
		return
	endif
	month := month(curDate)
	sweek := dow(date(year(curDate), month(curDate), 1))
	_dom  := lastDayom(curDate)
	monthx := month*100
	week  := sweek
	Rules := {}
	if self:__lRemList
		self:__remList:clear()
	endif

	for i=1 to _dom
		if (monthx+week)$self:__floatRules .and. !empty(self:__floatRules[monthx+week])
			Rules := self:__floatRules[monthx+week]
		endif
		for k=1 to len(Rules)
			if !( val(Rules[k][1])==i ) .and. Rules[k][1]!="*"
				loop
			endif
			if (Rules[k][1]=="*" .and.  ;
				int((i-1)/7)+1 != Rules[k][2])
				loop
			endif
			item := cti_get_object_by_id(self:__sId+i-1)
			item:remstr += Rules[k][4]+";"
			item:palette:control := self:__redDayColor
			item:palette:selection := self:__redDayColorSel
		next
			//item:remstr := left(item:remstr, len(item:remstr)-1)
		if (monthx+i)$self:__reminder
			item := cti_get_object_by_id(self:__sId+i-1)
			for k=1 to len(self:__reminder[monthx+i])
				item:remstr += self:__reminder[monthx+i][k]+";"
				item:palette:control := self:__redDayColor
				item:palette:selection := self:__redDayColorSel
			next
			//item:remstr := left(item:remstr, len(item:remstr)-1)
		endif
		week ++
		if week==8; week:=1; endif
		if self:__lRemList .and. !empty(item)
			s:= left(item:remstr, len(item:remstr)-1)
			self:__remList:append({str(i,2), s})
			self:__remList:move_to(1)
		endif
		Rules := {}
		item := {}
	next
return
********************************************************************************
* get reminder message
static function cti_calendar_get_reminder(self, i, j)
	if empty(self:__inFocus:remstr)
		message([Nothing to reminder!!])
	else
		message(self:__inFocus:remstr)
	endif
return
********************************************************************************
* Realize widget
static function cti_calendar_realize_real(self)
	if self:__is_realized; return TRUE; endif

	CALL SUPER self:realize_real()

	self:set_reminder_list(self:__lRemList)
return TRUE
********************************************************************************
* set reminder list
static function cti_calendar_set_reminder_list(self, enable)
local oldRemList := self:__lRemList
	if !self:__lReminder
		return
	endif
	if enable == nil
		enable := !oldRemList
	endif

	self:__lRemList := enable

	if self:__lRemList .and. self:__is_realized
		self:__init_reminder_list()

		self:set_size(self:height+4)

		self:put(self:__remList, self:height-5, 0)

		self:__check_reminder_date(self:__date)
	else
		if oldRemList
			self:set_size(self:height - self:__remList:height)
			self:__remList:destroy()
		endif
	endif
return oldRemList
********************************************************************************
* choose day by list
static function cti_calendar_choose_day_by_list(self)
local day, parent
//	parent := self:parent:parent
	parent := self:get_toplevel()
	day := val(self:get_cell(1))
	/* ::sId - id entry-object - first day of month */
	parent:__InFocus := cti_get_object_by_id(parent:__sId+day-1)
	parent:__inFocus:set_focus()
return
