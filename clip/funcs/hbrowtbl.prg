***********************************************
** Class HTable
function HTableNew(selfDoc, width, border, parse)
local obj := selfDoc//map()
	obj:className	:= "HTABLE"
	obj:caption	:= NIL
	obj:Titems	:= {}
	obj:Tcolumns	:= {}
	obj:Trows	:= {}
	obj:curCol	:= 0
	obj:curRow	:= 0
	obj:Twidth	:= 0
	obj:Theight	:= 0
	obj:posDoc	:= 0
	obj:rowDoc	:= 0
	obj:alignRow	:= HASH_LEFT
	obj:border	:= iif(border==NIL, .f., border)
	obj:PosInTable	:= 1

	_recover_HTABLE(obj)

return obj
*************
function _recover_HTABLE(obj)
	obj:addCellToTable	:= @tt_addCellToTable()
	obj:addRowToTable	:= @tt_addRowToTable()
	obj:addItemToCell	:= @tt_addItemToCell()
	obj:setCell		:= @tt_setCell()
	obj:drawTable		:= @tt_drawTable()
return obj
***************
static function tt_addRowToTable(tag, incRow)
local iRow := map(), i
	incRow := iif(incRow==NIL, .t., incRow)
	if incRow
		::curRow ++
		::curCol := 0
	endif
	iRow:align  := ::alignRow
	iRow:row    := 1
	iRow:height := 1
	if tag != NIL
		if "ALIGN"$tag:fields
			::alignRow := hashstr(upper(tag:fields:ALIGN))
		endif
	endif
	if (len(::Titems) < ::curRow) .or. (!incRow .and. (len(::Titems) == ::curRow))
		aadd(::Titems, {})
		aadd(::Trows, clone(iRow))
	else
		if len(::Titems[::curRow]) > 0 .and. ::Titems[::curRow][1]!=NIL
			::curCol := len(::Titems[::curRow])
		endif

	endif
return
****************
static function tt_addCellToTable(tag)
local newCell, i, j, factCol

	::curCol ++
	 if ::curCol < len(::Titems[::curRow])
		for i=::curCol to len(::Titems[::curRow])
			if ::Titems[::curRow][i] == NIL
				exit
			endif
			::curCol ++
		next
	 endif

	newCell := HCellNew(tag, ::alignRow)
	factCol := ::curCol
	if len(::Tcolumns) < ::curCol
		aadd(::Tcolumns, 1)
	endif
	if len(::Titems[::curRow]) < ::curCol
		aadd(::Titems[::curRow], clone(newCell))
	else
		::Titems[::curRow][::curCol] := clone(newCell)
	endif

	for i=2 to newCell:colspan
		::curCol ++
		aadd(::Titems[::curRow], clone(newCell))
		if len(::Tcolumns) < ::curCol
			aadd(::Tcolumns, 1)
		endif
	next

	if newCell:colspan > 1
		::Titems[::curRow][::curCol]:colspan := 1
	endif

	**********

	for i=2 to newCell:rowspan
		if len(::Titems) < ::curRow+i-1
			::addRowToTable(,.f.)
		endif

		if len(::Titems[::curRow+i-1])<factCol
			asize(::Titems[::curRow+i-1], factCol+newCell:colspan-1)
		endif
		for j=1 to newCell:colspan
			::Titems[::curRow+i-1][factCol+j-1] := HCellNew()
			::Titems[::curRow+i-1][factCol+j-1]:rowspan := 0
			::Titems[::curRow+i-1][factCol+j-1]:colspan := 0
		next
		::Titems[::curRow+i-1][factCol]:colspan := newCell:colspan
		if newCell:colspan > 1
			::Titems[::curRow+i-1][newCell:colspan+factCol-1]:colspan := 1
		endif
	next
	if newCell:rowspan > 1
		for i=1 to newCell:colspan
			::Titems[newCell:rowspan+::curRow-1][factCol+i-1]:rowspan := 1
		next
	endif

return
***********************
static function tt_addItemToCell(item, isTag)
	isTag := iif(isTag==NIL, .f., isTag)
	if isTag
		aadd(::Titems[::curRow][::curCol]:items, {clone(item), ::parseTag(item, .f.)})
	else
		::Titems[::curRow][::curCol]:addItem(item)
	endif
	if ::Titems[::curRow][::curCol]:minWidth > ::Tcolumns[::curCol]
		::Tcolumns[::curCol] := ::Titems[::curRow][::curCol]:maxWidth
	endif
return
***********************
static function tt_setCell(item, isTag)
	::Titems[::curRow][::curCol]:addItem(item, isTag)

	if ::Titems[::curRow][::curCol]:minWidth > ::Tcolumns[::curCol]
		::Tcolumns[::curCol] := ::Titems[::curRow][::curCol]:maxWidth
	endif
return
***********************
static function tt_drawTable()//Doc, Color) //::doc, ::clr
local i, j, s, s1, w, t, k, arr, c_repl, e_str, c_str, cell, ctbl, celine
local tcolor, wfact, symb, x, y, dc, elem, spos, kx,dataOk
local box:={"┌","─","┬","┐","│","├","┤","┼","└","┴","┘"}
      //     1   2   3   4   5   6   7   8   9   0   1

	// write caption
	s := box[1]

	for i=1 to len(::Tcolumns)
		w := ::Tcolumns[i]
		for k=2 to ::Titems[1][i]:colspan
			w += ::Tcolumns[i+k-1]
		next
		w += ::Titems[1][i]:colspan-1
		i += (::Titems[1][i]:colspan)-1

		s += box[2]:replicate(w)+box[3]
	next
	s := s:left(s:len()-1) + box[4]
	if !empty(::caption)
		j := len(s)
		arr := split_string(::caption, j)
		for i in arr
			::doc:Text(padc(i, j),,,,,::clr)
		next
	endif
	tcolor := ::clr // цвет таблицы
	::doc:n_Pos := ::doc:marginLeft
	::doc:Text(s,,,,,tcolor)

	//::newLine(, .t.)
	::doc:n_Line ++
	::doc:n_Pos := ::doc:marginLeft
	::posInTable := ::doc:marginLeft
	// write body
	c_repl := .f.
	for i=1 to len(::Titems)
		::doc:n_Line := ::doc:lines+1
		::doc:n_Pos := ::posInTable
		::TblNewLine := .f.
		do while .t.
		dataOk := .t.
		for j=1 to len(::Titems[i])
			elem := ::Titems[i][j]
			if elem:colspan>1
				elem:items := ::Titems[i][j+elem:colspan-1]:items
			endif

			w := ::Tcolumns[j] //ширина ячейки
			// нижняя граница ячеек
			if j==1
				s1 := symb_tbl(::Titems, i, j-1)
			endif
			s1 += replicate(iif(elem:rowspan>1 .and. i!=len(::Titems), " ", box[2]), ::Tcolumns[j])
			// ширина текущей ячейки/ячеек, если col > 1
			for k=2 to elem:colspan
				w += ::Tcolumns[j+k-1]
				s1 += symb_tbl(::Titems, i, j+k-2)
				s1 += replicate(iif(elem:rowspan>1 .and. i!=len(::Titems), " ", box[2]), ::Tcolumns[j+k-1])
			next
			j += elem:colspan-1
			w += elem:colspan-1

			wfact := 0 // фактическая ширина n-столбцов
			y := 0
			for x=1 to len(elem:items)
				if ::tblNewLine
					exit
				endif
				if wfact +elem:items[x][2] <= w
					y++
					wfact += elem:items[x][2]
				elseif wfact == 0 .and. elem:items[x][2] > w

					y++
					asize(elem:items, len(elem:items)+1)
					ains(elem:items, x)
					elem:items[x] := {"", 0}
					spos := splitSpaceFrom(elem:items[x+1][1], w-wfact)
					elem:items[x][1] := substr(elem:items[x+1][1], 1, spos-1)
					elem:items[x+1][1] := ltrim(substr(elem:items[x+1][1], spos))
					elem:items[x][2] := len(elem:items[x][1])
					elem:items[x+1][2] := len(elem:items[x+1][1])
					wfact += elem:items[x][2]

					exit
				endif
			next
			if j-elem:colspan == 0
				::doc:Text(iif(::border, box[5], " "),::doc:n_Line, ::doc:n_Pos,,,::clr)
			endif
			kx := 0
			for x=1 to y
				if valtype(elem:items[x][1])=="O"
					::parseTag(elem:items[x][1])
					kx := x
					loop
				endif
				if !::tblNewLine .and. len(elem:items)>0
					do switch (elem:align)
					case HASH_LEFT
						::addObject(padr(elem:items[x][1], w), ::clr,,,,,::doc:n_Line, ::doc:n_Pos)
					case HASH_RIGHT
						::addObject(padl(elem:items[x][1], w), ::clr,,,,,::doc:n_Line, ::doc:n_Pos)
					case HASH_CENTER
						::addObject(padc(elem:items[x][1], w), ::clr,,,,,::doc:n_Line, ::doc:n_Pos)
					endswitch
				endif
			next
			if ::tblNewLine
				::tblNewLine := .f.
				y := kx // first elements to newLine
			endif
			for x=1 to y
				adel(elem:items, 1)
			next
			asize(elem:items, len(elem:items)-y)
			dataOk := dataOk .and. empty(elem:items)
			::doc:Text(iif(::border, box[5], " "), ::doc:n_Line, ::doc:n_Pos+iif(y==0, w, 0),,,::clr)

			::doc:refresh()
			s1 += symb_tbl(::Titems, i, j)
		next
		::doc:n_Line ++
		::doc:n_Pos := ::posInTable
		if dataOk
			exit
		endif

		enddo
		::doc:Text(s1,::doc:n_Line,::doc:n_Pos,,,tcolor)
				::doc:refresh()
	next
return
***********************************************
** Class HCell
function HCellNew(tag, align)
local obj:=map()
	obj:className	:= "HCELL"
	obj:items	:= {}
	obj:maxWidth	:= 1
	obj:minWidth	:= 1
	obj:Width	:= 1
	obj:colspan	:= 1
	obj:rowspan	:= 1
	obj:Height	:= 1
	obj:type	:= nil
	obj:align	:= iif(align==NIL, HASH_LEFT, align)
	obj:new		:= @tc_new_cell()
	obj:addItem	:= @tc_addCellItem()
	obj:setWidth	:= @tc_setWidthCell()

	if valtype(tag)!="U"
		obj:new(tag)
	endif
return obj
************
static function tc_new_cell(tag)
	::type := hashstr(tag:tagName)
	if "COLSPAN"$tag:fields
		::colspan := &(tag:fields:COLSPAN)
	endif
	if "ROWSPAN"$tag:fields
		::rowspan := &(tag:fields:ROWSPAN)
		::Theight := ::rowspan
	endif
	if "ALIGN"$tag:fields
		::align := hashstr(upper(tag:fields:ALIGN))
	endif
return
static function tc_addCellItem(item)
local lastItem, arr, val
	aadd(::items, {item, len(item)})
	lastItem := atail(::items)
	::maxWidth += lastItem[2]
	arr := split(lastItem[1], " ")
	for val in arr
		if len(val) > ::minWidth
			::minWidth := len(val)
		endif
	next
return
static function tc_setWidthCell(width)
	if ::minWidth > width
		::width := ::minWidth
	else
		::width := width
	endif
return ::width
