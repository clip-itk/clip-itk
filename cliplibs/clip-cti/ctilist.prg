/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_LIST multi-column list */

#include "cti.ch"

#include "inkey.ch"

#define	SUPERCLASS	CTI_CONTROL

function cti_list_new(nColumns)
	local obj := cti_inherit(cti_control_new(),"CTI_LIST")
	local i

	obj:auto_lose_focus	:= FALSE

	obj:__ncolumns		:= iif(valtype(nColumns)=="N",nColumns,0)
	obj:__columns		:= {}
	obj:__list_width	:= 0

	obj:__nrows		:= 0
	obj:__rows		:= {}

	obj:__selection		:= map()

	obj:__show_titles	:= FALSE
	obj:__auto_sort		:= FALSE

	obj:__buf_title		:= ""
	obj:__buf_title_sep	:= ""

	obj:__vis_top		:= 1
	obj:__vis_left		:= 1
	obj:__vis_rows		:= 0

	obj:__cur_row		:= 0
	obj:__cur_col		:= 0

	obj:__col_separator	:=  ""  // utf-8:  "â”‚"
	obj:__title_separator	:= "€Š€" // utf-8: "â”€â”¼â”€"

	obj:__real_draw			:= @cti_list_real_draw()
	obj:__refresh_columns		:= @cti_list_refresh_columns()
	obj:__get_new_row		:= @cti_list_get_new_row()
	obj:__calc_vis_rows		:= @cti_list_calc_vis_rows()
	obj:__col_pos			:= @cti_list_col_pos()

	obj:__set_default_keys		:= @cti_list_set_default_keys()

//	obj:set_selection_mode		:= @cti_list_set_selection_mode()
	obj:clear			:= @cti_list_clear()
	obj:column_titles_show		:= @cti_list_column_titles_show()
	obj:set_col_separator		:= @cti_list_set_col_separator()
	obj:set_title_separator		:= @cti_list_set_title_separator()

	obj:visible_rows		:= {|_obj|_obj:__vis_rows}
	obj:first_visible_row		:= {|_obj|_obj:__vis_top}
	obj:last_visible_row		:= {|_obj|min(obj:__vis_top + obj:__vis_rows,obj:__nrows)}
	obj:num_rows			:= {|_obj|_obj:__nrows}

	obj:set_row_selectable		:= @cti_list_set_row_selectable()
	obj:select_row			:= @cti_list_select_row()
	obj:toggle_row			:= @cti_list_toggle_row()
	obj:clear_selection		:= @cti_list_clear_selection()
	obj:select_rows			:= @cti_list_select_rows()
	obj:select_rows_by_data		:= @cti_list_select_rows_by_data()

	obj:row_is_visible		:= @cti_list_row_is_visible()
	obj:row_is_disabled		:= @cti_list_row_is_visible()
	obj:row_selected		:= @cti_list_row_selected()

	obj:set_column_title		:= @cti_list_set_column_title()
	obj:set_column_justification	:= @cti_list_set_column_justification()
	obj:set_column_title_justification	:= @cti_list_set_column_title_justification()
	obj:set_column_visibility	:= @cti_list_set_column_visibility()
	obj:set_column_auto_resize	:= @cti_list_set_column_auto_resize()
	obj:set_column_width		:= @cti_list_set_column_width()
	obj:set_column_min_width	:= @cti_list_set_column_min_width()
	obj:set_column_max_width	:= @cti_list_set_column_max_width()

	obj:append			:= @cti_list_append()
	obj:prepend			:= @cti_list_prepend()
	obj:insert			:= @cti_list_insert()
	obj:remove			:= @cti_list_remove()

	obj:scroll_vertical		:= @cti_list_scroll_vertical()
	obj:scroll_horizontal		:= @cti_list_scroll_horizontal()
	obj:move_vertical		:= @cti_list_move_vertical()
	obj:move_horizontal		:= @cti_list_move_horizontal()
	obj:move_to			:= @cti_list_move_to()

	obj:up				:= {|_obj|_obj:move_vertical(1)}
	obj:down			:= {|_obj|_obj:move_vertical(-1)}
	obj:left			:= {|_obj|_obj:scroll_horizontal(-1)}
	obj:right			:= {|_obj|_obj:scroll_horizontal(1)}
	obj:page_up			:= {|_obj|_obj:move_vertical(- _obj:__vis_rows)}
	obj:page_down			:= {|_obj|_obj:move_vertical(_obj:__vis_rows)}
	obj:home			:= {|_obj|_obj:move_to(1)}
	obj:end				:= {|_obj|_obj:move_to(_obj:__nrows)}

	obj:get_cur_row			:= @cti_list_get_cur_row()
	obj:get_cell			:= @cti_list_get_cell()

	obj:find			:= @cti_list_find()
	obj:find_by_data		:= @cti_list_find_by_data()

	obj:realize_real		:= @cti_list_realize_real()

/********************************************************/
	for i:=1 to obj:__ncolumns
		aadd(obj:__columns,cti_list_column_new())
	next
	obj:__refresh_columns()

	obj:__set_default_keys()
return obj

/******************************************************************/
function cti_list_column_new()
	local obj := cti_inherit(cti_object_new(),"CTI_LIST_COLUMN")

	obj:width	:= 0
	obj:minwidth	:= nil
	obj:maxwidth	:= nil
	obj:title	:= ""
	obj:justification	:= CTI_JUSTIFY_LEFT
	obj:title_justification	:= CTI_JUSTIFY_LEFT

	obj:visible	:= TRUE
	obj:width_set	:= FALSE
	obj:auto_resize	:= FALSE
return obj
/******************************************************************/
/******************************************************************/

function cti_list_row_new()
	//local obj := clone(cti_inherit(cti_object_new(),"CTI_LIST_ROW"))
	local obj := map()

	obj:classname := "CTI_LIST_ROW"

	obj:__text	:= {}
	obj:__data	:= nil
	obj:selectable	:= TRUE
	obj:__is_selected	:= FALSE
return obj
/******************************************************************/

function cti_list_clear(obj)
	obj:__nrows		:= 0
	obj:__rows		:= {}

	obj:__selection		:= {}

	obj:__vis_top		:= 1
	obj:__vis_left		:= 1
	obj:__vis_rows		:= 0

	obj:__cur_row		:= 0
	obj:__cur_col		:= 0
	obj:draw_queue()
return TRUE

static function cti_list_realize_real(obj)
	local height, width

	height := obj:__uheight; width := obj:__uwidth
	obj:__refresh_columns()
	height := iif(height==nil,3,height)
	width  := iif(width==nil,obj:__list_width,width)
	obj:set_size(height,width)

	CALL SUPER obj:realize_real()
return TRUE

/* Sets the title for the specified column. */
static function cti_list_set_column_title(obj,nColumn,cTitle)
	cti_return_if_fail(nColumn>0 .and. nColumn<=obj:__ncolumns)
	obj:__columns[nColumn]:title := cTitle
	obj:__refresh_columns()
	obj:draw_queue()
return TRUE

/* Sets the justification to be used for all text in the specified column. */
static function cti_list_set_column_justification(obj,nColumn,nJustification)
	cti_return_if_fail(nColumn>0 .and. nColumn<=obj:__ncolumns)
	obj:__columns[nColumn]:justification := nJustification
	obj:__refresh_columns()
	obj:draw_queue()
return TRUE

/* Sets the justification to be used for title of the specified column. */
static function cti_list_set_column_title_justification(obj,nColumn,nJustification)
	cti_return_if_fail(nColumn>0 .and. nColumn<=obj:__ncolumns)
	obj:__columns[nColumn]:title_justification := nJustification
	obj:__refresh_columns()
	obj:draw_queue()
return TRUE

/* Allows you to set whether a specified column in the GtkCList should be hidden
   or shown. Note that at least one column must always be showing, so attempting
   to hide the last visible column will be ignored. */
static function cti_list_set_column_visibility(obj,nColumn,lVisible)
	cti_return_if_fail(nColumn>0 .and. nColumn<=obj:__ncolumns)
	obj:__columns[nColumn]:visible := lVisible
	if ascan(obj:__columns,{|col|col:visible}) == 0
		obj:__columns[nColumn]:visible := TRUE
	endif
	obj:__refresh_columns()
	obj:draw_queue()
return TRUE

/* Lets you specify whether a column should be automatically resized by the
   widget when data is added or removed. */
static function cti_list_set_column_auto_resize(obj,nColumn,lAutoResize)
	cti_return_if_fail(nColumn>0 .and. nColumn<=obj:__ncolumns)
	obj:__columns[nColumn]:auto_resize := lAutoResize
	obj:__refresh_columns()
	obj:draw_queue()
return TRUE

/* Causes the column specified for the GtkCList to be set to a specified width. */
static function cti_list_set_column_width(obj,nColumn,nWidth)
	cti_return_if_fail(nColumn>0 .and. nColumn<=obj:__ncolumns)
	obj:__columns[nColumn]:width := nWidth
	obj:__columns[nColumn]:width_set := TRUE
	obj:__refresh_columns()
	obj:draw_queue()
return TRUE

/* Causes the column specified to have a minimum width, preventing the user from
   resizing it smaller than that specified. */
static function cti_list_set_column_min_width(obj,nColumn,nWidth)
	cti_return_if_fail(nColumn>0 .and. nColumn<=obj:__ncolumns)
	obj:__columns[nColumn]:min_width := nWidth
	obj:__refresh_columns()
	obj:draw_queue()
return TRUE

/* Causes the column specified to have a maximum width, preventing the user from
   resizing it larger than that specified. */
static function cti_list_set_column_max_width(obj,nColumn,nWidth)
	cti_return_if_fail(nColumn>0 .and. nColumn<=obj:__ncolumns)
	obj:__columns[nColumn]:max_width := nWidth
	obj:__refresh_columns()
	obj:draw_queue()
return TRUE

static function cti_list_set_row_selectable(obj,nRow,lSelectable)
	cti_return_if_fail(nRow>0 .and. nRow<=obj:__nrows)
	obj:__rows[nRow]:selectable := lSelectable
	obj:draw_queue()
return TRUE

static function cti_list_select_row(obj,nRow,lSelect)
	local signal
	cti_return_if_fail(nRow==nil .or. valtype(nRow)=="N" .and. nRow>0 .and. nRow<=obj:__nrows)
	cti_return_if_fail(valtype(lSelect)=="L" .or. lSelect==nil)

	if nRow==nil; nRow:=obj:__cur_row; endif
	if lSelect==nil; lSelect:=TRUE; endif

	if nRow==0; return FALSE; endif

	if obj:__rows[nRow]:selectable
		obj:__rows[nRow]:__is_selected := lSelect
		if lSelect
			signal := cti_signal_new(HASH_CTI_SELECT_ROW_SIGNAL)
		else
			signal := cti_signal_new(HASH_CTI_UNSELECT_ROW_SIGNAL)
		endif
		signal:row := nRow
		obj:signal_emit(signal)
		obj:draw_queue()
	endif
return TRUE

static function cti_list_toggle_row(obj,nRow)
	cti_return_if_fail(nRow==nil .or. nRow>0 .and. nRow<=obj:__nrows)

	if nRow==nil; nRow:=obj:__cur_row; endif
	if nRow==0; return FALSE; endif

	if obj:__rows[nRow]:selectable
		obj:__rows[nRow]:__is_selected := .not. obj:__rows[nRow]:__is_selected
		obj:draw_queue()
	endif
return TRUE

static function cti_list_select_rows(obj,nRow,bCriteria)
	local lselect_row, i

	cti_return_if_fail(nRow>0 .and. nRow<=obj:__nrows)
	cti_return_if_fail(valtype(bCriteria)=="B")

	for i:=1 to obj:__nrows
		if obj:__rows[i]:selectable
			lselect_row := eval(bCriteria,obj:__rows[i]:__text)
			obj:__rows[i]:__is_selected := valtype(lselect_row)=="L" .and. lselect_row
		endif
	next
	obj:draw_queue()
return TRUE

static function cti_list_select_rows_by_data(obj,nRow,bCriteria)
	local lselect_row, i

	cti_return_if_fail(nRow>0 .and. nRow<=obj:__nrows)
	cti_return_if_fail(valtype(bCriteria)=="B")

	for i:=1 to obj:__nrows
		if obj:__rows[i]:selectable
			lselect_row := eval(bCriteria,obj:__rows[i]:__data)
			obj:__rows[i]:__is_selected := valtype(lselect_row)=="L" .and. lselect_row
		endif
	next
	obj:draw_queue()
return TRUE

static function cti_list_clear_selection(obj)
	local i

	for i:=1 to obj:__nrows
		obj:__rows[i]:__is_selected := FALSE
	next
return TRUE

/* Recreate list`s title */
static function cti_list_refresh_columns(obj)
	local i, col, s, st, w

	s := ""; st := ""; w := 0
	for i:=1 to obj:__ncolumns
		col := obj:__columns[i]
		if col:visible
			s += cti_text_justify(col:title,col:width,col:title_justification) + ;
				obj:__col_separator
			st += replicate(left(obj:__title_separator,1),col:width) + ;
				substr(obj:__title_separator,2,1)
			w += col:width
		endif
	next
	obj:__buf_title := s
	obj:__buf_title_sep := st
	obj:__list_width := w
	obj:__calc_vis_rows()
return

/* Calculates, how many rows may be displayed */
static function cti_list_calc_vis_rows(obj)
	obj:__vis_rows := cti_cnum(obj:height)
	if obj:__show_titles
		obj:__vis_rows --
		if .not. empty(obj:__title_separator)
			obj:__vis_rows --
		endif
	endif
return

/* Turn on/off show column titles */
static function cti_list_column_titles_show(obj,show)
	obj:__show_titles := show
	obj:draw_queue()
return

/* Sets columns separator */
static function cti_list_set_col_separator(obj,sep)
	obj:__col_separator := iif(valtype(sep)=="C",padr(sep,1),"")
	obj:__refresh_columns()
return

/* Sets title separator */
static function cti_list_set_title_separator(obj,sep)
	obj:__title_separator := iif(valtype(sep)=="C",padr(sep,1),"")
	obj:__refresh_columns()
return

static function cti_list_scroll_vertical(obj,rows)
	local row := obj:__vis_top + rows

	/* Scroll down */
	if rows > 0
		if row > obj:__nrows; row := obj:__nrows; endif
	endif

	/* Scroll up */
	if rows < 0
		if row < 1; row := 1; endif
	endif

	if row != obj:__vis_top
		obj:__vis_top := row
		obj:draw_queue()
	endif
return

static function cti_list_scroll_horizontal(obj,cols)
	local col := obj:__vis_left + cols

	/* Scroll right */
	if cols > 0
		col := min(col,obj:__list_width - obj:width)
	endif

	/* Scroll left */
	if cols < 0
		col := max(col,1)
	endif

	if col != obj:__vis_left
		obj:__vis_left := col
		obj:draw_queue()
	endif
return

static function cti_list_move_vertical(obj,rows)
	local row := obj:__cur_row + rows
	local lastvis := obj:__vis_top + obj:__vis_rows - 1

	/* Move down */
	if rows > 0
		if row > obj:__nrows
			row := obj:__nrows
		endif

		do while row < obj:__nrows .and. !obj:__rows[row]:selectable
			row ++
		enddo

		do while row > obj:__cur_row .and. !obj:__rows[row]:selectable
			row --
		enddo
	endif

	/* Move up */
	if rows < 0
		if row < 1
			row := min(1,obj:__nrows)
		endif

		do while row > 1 .and. !obj:__rows[row]:selectable
			row --
		enddo

		do while row < obj:__cur_row .and. row>0 .and. !obj:__rows[row]:selectable
			row ++
		enddo
	endif

	if row == obj:__cur_row; return FALSE; endif

	obj:__cur_row := row
	if row < obj:__vis_top
		obj:scroll_vertical(row - obj:__vis_top)
	endif
	if row > lastvis
		obj:scroll_vertical(row - lastvis)
	endif
	obj:draw_queue()

return TRUE

static function cti_list_move_horizontal(obj,cols)
return

/* Tells the CTI_LIST widget to visually move to the specified row and column. */
static function cti_list_move_to(obj,nRow,nCol,nRowAlign,nColAlign)
	/* Checking parameters */
	cti_return_if_fail(valtype(nRow)=="N")
	nRow := cti_bound(nRow, 1, obj:__nrows)

	cti_return_if_fail(nRowAlign==nil .or. valtype(nRowAlign)=="N")
	cti_return_if_fail(nColAlign==nil .or. valtype(nColAlign)=="N")

	nRowAlign := cti_cnum(nRowAlign)
	nRowAlign := cti_bound(nRowAlign,0,1)

	nColAlign := cti_cnum(nColAlign)
	nColAlign := cti_bound(nColAlign,0,1)

	/* Move to new row */
	obj:__cur_row := nRow
	obj:__vis_top := nRow - round(obj:__vis_rows * nRowAlign)
	obj:__vis_top := cti_bound(obj:__vis_top, 1, obj:__nrows)

	if nCol!=nil
		/* Move to new column, if need */
		cti_return_if_fail(valtype(nCol)=="N")
		nCol := cti_bound(nCol, 1, obj:__ncols)
		obj:__vis_left := obj:__col_pos(nCol)
		obj:__vis_left := obj:__vis_left - round(obj:__vis_left * nColAlign)
		obj:__vis_left := cti_bound(obj:__vis_left, 1, obj:__list_width)
	endif

	/* Redraw widget */
	obj:draw_queue()
return TRUE

static function cti_list_col_pos(obj,nCol)
	local i, width := 0

	cti_return_if_fail(valtype(nCol)=="N")
	nCol := cti_bound(nCol, 1, obj:__ncols)
	for i:=1 to nCol
		width += obj:__columns[i]:width
	next
return width

static function cti_list_row_is_visible(obj,row)
	if row < 1 .or. row > obj:__nrows; return FALSE; endif
	if row < obj:__vis_top .or. row > obj:__vis_top + obj:__vis_rows
		return FALSE
	endif
return TRUE

static function cti_list_row_selected(obj,row)
	if row < 1 .or. row > obj:__nrows; return FALSE; endif
	if row < obj:__vis_top .or. row > obj:__vis_top + obj:__vis_rows
		return obj:__rows[row]:__is_selected
	endif
return TRUE

/* Drawing list */
static function cti_list_real_draw(obj)
	local color, cur_color, title_color, row_color, dis_color
	local i, top,left, bottom, start_row, end_row
	local start_col, end_col, w, s, scell
	local row, col, nrow, ncol

	title_color := obj:Palette:ListTitle
	cur_color := iif(obj:__is_focused,obj:Palette:ListFocusCurrent,obj:Palette:ListNoFocusCurrent)
	color := obj:Palette:Control
	dis_color := obj:Palette:ListDisabledRow
	if .not. obj:__is_enabled
		dis_color := title_color := cur_color := color := obj:Palette:DisabledControl
	endif

	/* Draw title */
	top := 0
	if obj:__show_titles
		s := padr(substr(obj:__buf_title,obj:__vis_left),obj:width)
		winbuf_out_at(obj:__buffer,top,0,s,title_color)
		top ++
		if .not. empty(obj:__title_separator)
			s := padr(substr(obj:__buf_title_sep,obj:__vis_left),obj:width,substr(obj:__title_separator,3,1))
			winbuf_out_at(obj:__buffer,top,0,s,title_color)
			top ++
		endif
	endif

	obj:__calc_vis_rows()

	start_row := obj:__vis_top
	end_row := start_row + obj:height - top
	end_row := min(end_row,obj:__nrows)

	start_col := 1
	end_col := obj:__ncolumns

	/* Draw visible rows */
	nrow:=start_row
	do while nrow<=end_row .or. top<=obj:height
		row := iif(nrow<=end_row, obj:__rows[nrow], nil)
		s := ""
		for ncol:=start_col to end_col
			col := obj:__columns[ncol]
			scell := iif(row!=nil,row:__text[ncol],"")
			s += cti_text_justify(scell,col:width,col:justification) + ;
				obj:__col_separator
		next
		s := padr(substr(s,obj:__vis_left),obj:width)
		row_color := obj:Palette:Control
//		if nrow==obj:__cur_row; row_color := cur_color; endif
		if row!=nil
			if .not. row:selectable; row_color := dis_color; endif
			if obj:__is_focused
				if row:__is_selected
					if nrow==obj:__cur_row
						row_color := obj:Palette:ListCurSelected
					else
						row_color := obj:Palette:ListSelected
					endif
				else
					if nrow==obj:__cur_row
						row_color := obj:Palette:ListFocusCurrent
					else
						row_color := obj:Palette:Control
					endif
				endif
			else
				if row:__is_selected
					if nrow==obj:__cur_row
						row_color := obj:Palette:ListNoFocusCurSelected
					else
						row_color := obj:Palette:ListSelected
					endif
				else
					if nrow==obj:__cur_row
						row_color := obj:Palette:ListNoFocusCurrent
					else
						row_color := obj:Palette:Control
					endif
				endif
			endif
		endif
		winbuf_out_at(obj:__buffer,top,0,s,row_color)
		top ++
		nrow ++
	enddo
return TRUE

/* Create new list row from array of elements */
static function cti_list_get_new_row(obj,aText)
	local row,i,l

	row := cti_list_row_new()
	row:__text := array(obj:__ncolumns)
	afill(row:__text,"")
	l := iif(valtype(aText)=="A",len(aText),0)
	l := cti_min(l,obj:__ncolumns)
	for i:=1 to l
		row:__text[i] := iif(valtype(aText[i])=="C",aText[i],"")
	next
return row

/* Append row to end of list */
static function cti_list_append(obj,aText)
	aadd(obj:__rows,obj:__get_new_row(aText))
	obj:__nrows ++
	obj:draw_queue()
return TRUE

/* Insert row to start of list */
static function cti_list_prepend(obj,aText)
	asize(obj:__rows,obj:__nrows+1)
	ains(obj:__rows,1)
	obj:__rows[1] := obj:__get_new_row(aText)
	obj:__nrows ++
	obj:draw_queue()
return TRUE

/* Insert row to the list into position pos */
static function cti_list_insert(obj,aText,pos)
	pos := iif(valtype(pos)=="N",pos,1)
	asize(obj:__rows,obj:__nrows+1)
	ains(obj:__rows,pos)
	obj:__rows[pos] := obj:__get_new_row(aText)
	obj:__nrows ++
	obj:draw_queue()
return TRUE

/* Remove row from the list */
static function cti_list_remove(obj,nPos)
	nPos := iif(valtype(nPos)=="N",nPos,obj:__cur_row)
	cti_return_if_fail2(between(nPos,1,obj:__nrows))
	cti_return_if_fail2(obj:__nrows>0)

	adel(obj:__rows,nPos)
	asize(obj:__rows,obj:__nrows-1)
	obj:__nrows --

	if obj:__cur_row > nPos .or. obj:__cur_row > obj:__nrows
		obj:__cur_row --
		if obj:__cur_row < obj:__vis_top
			obj:scroll_vertical(-1)
		endif
	endif

	obj:draw_queue()
return TRUE

/* Alena                             */
/* Get current row -> array of cells */
static function cti_list_get_cur_row(obj)
local aRow := {}, i
	if len(obj:__rows)==0
		return aRow
	endif
	for i=1 to obj:__ncolumns
		aadd(aRow, obj:__rows[obj:__cur_row]:__text[i])
	next
return aRow

/* Alena                             */
/* Get cell                          */
static function cti_list_get_cell(obj, nCol)
	if !between(nCol, 1, obj:__ncolumns) .or. len(obj:__rows)==0
		return nil
	endif
return obj:__rows[obj:__cur_row]:__text[nCol]

/* Search in row's text */
static function cti_list_find(obj, bCompareCode, start_row, rows)
	local i, end_row

	cti_return_if_fail(valtype(bCompareCode)=="B")
	start_row := iif(valtype(start_row)=="N",start_row,1)
	rows := iif(valtype(rows)=="N",rows,obj:__nrows)
	end_row := min(obj:__nrows,start_row+rows-1)

	for i:=start_row to end_row
		if eval(bCompareCode,obj,obj:__rows[i]:__text)
			return i
		endif
	next
return -1

/* Search in row's data */
static function cti_list_find_by_data(obj, bCompareCode, start_row, rows)
	local i, end_row

	cti_return_if_fail(valtype(bCompareCode)=="B")
	start_row := iif(valtype(start_row)=="N",start_row,1)
	rows := iif(valtype(rows)=="N",rows,obj:__nrows)
	end_row := min(obj:__nrows,start_row+rows-1)

	for i:=start_row to end_row
		if eval(bCompareCode,obj,obj:__rows[i]:__data)
			return i
		endif
	next
return -1

static function cti_list_set_default_keys(obj)
	obj:set_key(K_UP,    {|_obj|_obj:move_vertical(-1), !_obj:auto_lose_focus} )
	obj:set_key(K_DOWN,  {|_obj|_obj:move_vertical(1), !_obj:auto_lose_focus} )
	obj:set_key(K_LEFT,  {|_obj|_obj:scroll_horizontal(-1)} )
	obj:set_key(K_RIGHT, {|_obj|_obj:scroll_horizontal(1)} )
	obj:set_key(K_PGUP,  {|_obj|_obj:move_vertical(- _obj:__vis_rows)} )
	obj:set_key(K_PGDN,  {|_obj|_obj:move_vertical(_obj:__vis_rows)} )
	obj:set_key(K_HOME,  {|_obj|_obj:move_to(1)} )
	obj:set_key(K_END,   {|_obj|_obj:move_to(_obj:__nrows)} )
	obj:set_key(K_INS,   {|_obj|_obj:toggle_row(),_obj:move_vertical(1)} )
return TRUE
