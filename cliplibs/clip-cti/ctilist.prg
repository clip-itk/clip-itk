/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_LIST - */

#include "cti.ch"
#include "ctievents.ch"

#include "inkey.ch"

#define	SUPERCLASS	CTI_CONTROL

function cti_list_new(nColumns)
	local obj := cti_inherit(cti_control_new(),"CTI_LIST")
	local i

	obj:__items		:= nil
	obj:__current		:= nil

	obj:__ncolumns		:= iif(valtype(nColumns)=="N",nColumns,1)
	obj:__columns		:= {}
	obj:__list_width	:= 0

	obj:__nrows		:= 0
	obj:__rows		:= {}

	obj:__selection		:= {}

	obj:__show_titles	:= FALSE
	obj:__auto_sort		:= FALSE

	obj:__buf_title		:= ""
	obj:__buf_title_sep	:= ""

	obj:__vis_top		:= 1
	obj:__vis_left		:= 1
	obj:__vis_rows		:= 0

	obj:__cur_row		:= 1
	obj:__cur_col		:= 1

	obj:__col_separator	:=  ""
	obj:__title_separator	:= "€Š€"

	obj:__real_draw			:= @cti_list_real_draw()
	obj:__handle_event		:= @cti_list_handle_event()
	obj:__refresh_columns		:= @cti_list_refresh_columns()
	obj:__get_new_row		:= @cti_list_get_new_row()
	obj:__calc_vis_rows		:= @cti_list_calc_vis_rows()

//	obj:set_selection_mode		:= @cti_list_set_selection_mode()
	obj:column_titles_show		:= @cti_list_column_titles_show()
	obj:set_col_separator		:= @cti_list_set_col_separator()
	obj:set_title_separator		:= @cti_list_set_title_separator()

	obj:get_visible_rows		:= @cti_list_get_visible_rows()
	obj:first_visible_row		:= @cti_list_first_visible_row()
	obj:last_visible_row		:= @cti_list_last_visible_row()

	obj:row_is_visible		:= @cti_list_row_is_visible()

	obj:set_column_title		:= @cti_list_set_column_title()
	obj:set_column_justification	:= @cti_list_set_column_justification()
	obj:set_column_title_justification	:= @cti_list_set_column_title_justification()
	obj:set_column_visibility	:= @cti_list_set_column_visibility()
	obj:set_column_auto_resize	:= @cti_list_set_column_auto_resize()
	obj:set_column_width		:= @cti_list_set_column_width()
	obj:set_column_min_width	:= @cti_list_set_column_min_width()
	obj:set_column_max_width	:= @cti_list_set_column_max_width()

	obj:set_row_selectable		:= @cti_list_set_row_selectable()

	obj:append			:= @cti_list_append()
	obj:prepend			:= @cti_list_prepend()
	obj:insert			:= @cti_list_insert()
	obj:remove			:= @cti_list_remove()

	obj:scroll_vertical		:= @cti_list_scroll_vertical()
	obj:scroll_horizontal		:= @cti_list_scroll_horizontal()
	obj:move_vertical		:= @cti_list_move_vertical()
	obj:move_horizontal		:= @cti_list_move_horizontal()

/********************************************************/
	for i:=1 to obj:__ncolumns
		aadd(obj:__columns,cti_list_column_new())
	next
	obj:__refresh_columns()

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

function cti_list_row_new()
	local obj := cti_inherit(cti_object_new(),"CTI_LIST_ROW")

	obj:__text	:= {}
	obj:__data	:= nil
	obj:selectable	:= TRUE
return obj
/******************************************************************/

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
	obj:__vis_rows := obj:height
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

	/* Scroll up */
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

		if .not. obj:__rows[row]:selectable
			do while row < obj:__nrows .and. .not. obj:__rows[row]:selectable
				row ++
			enddo

			do while row > obj:__cur_row .and. .not. obj:__rows[row]:selectable
				row --
			enddo
		endif
	endif

	/* Move up */
	if rows < 0
		if row < 1
			row := 1
		endif

		if .not. obj:__rows[row]:selectable
			do while row > 1 .and. .not. obj:__rows[row]:selectable
				row --
			enddo

			do while row < obj:__cur_row .and. .not. obj:__rows[row]:selectable
				row ++
			enddo
		endif
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

static function cti_list_get_visible_rows(obj)
return obj:__vis_rows

static function cti_list_first_visible_row(obj)
return obj:__vis_top

static function cti_list_last_visible_row(obj)
	local row := obj:__vis_top + obj:__vis_rows
return iif(row<=obj:__nrows,row,obj:__nrows)

static function cti_list_row_is_visible(obj,row)
	if row < 1 .or. row > obj:__nrows; return FALSE; endif
	if row < obj:__vis_top .or. row > obj:__vis_top + obj:__vis_rows
		return FALSE
	endif
return TRUE

/* Drawing list */
static function cti_list_real_draw(obj)
	local color, cur_color, title_color, row_color, dis_color
	local i, top,left, bottom, start_row, end_row
	local start_col, end_col, w, s, scell
	local row, col, nrow, ncol

/*
	if obj:__control_focused != obj:__is_focused
		if obj:__is_focused
			obj:__list:setfocus()
		else
			obj:__list:killfocus()
		endif
		obj:__control_focused := obj:__is_focused
	endif
*/

	title_color := obj:Palette:ListTitle
	cur_color := iif(obj:__is_focused,obj:Palette:Selection,obj:Palette:Control)
	color := obj:Palette:Control
	dis_color := obj:Palette:DisabledRow
	if .not. obj:__is_enabled
		dis_color := title_color := cur_color := color := obj:Palette:DisabledControl
	endif

	/* Draw title */
	top := 0
	if obj:__show_titles
/*
		w := 0
		for i:=1 to obj:__vis_left
			w += obj:__columns[i]:width + len(obj:__col_separator)
		next
*/
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

/*
	start_col := obj:__vis_left
	w := 0
	for i:=start_col to obj:__ncolumns
		w += obj:__columns[i]:width+len(obj:__col_separator)
		if w >= obj:width .or. i == obj:__ncolumns
			end_col := i
			exit
		endif
	next
*/
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
//outlog(__FILE__,__LINE__,procname(),s)
		row_color := color
		if nrow==obj:__cur_row; row_color := cur_color; endif
		if row!=nil .and. .not. row:selectable; row_color := dis_color; endif
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
static function cti_list_remove(obj,pos)
	pos := iif(valtype(pos)=="N",pos,1)
	adel(obj:__rows,pos)
	asize(obj:__rows,obj:__nrows-1)
	obj:__nrows --
	obj:draw_queue()
return TRUE

static function cti_list_handle_event(obj,event)
	local row

	if event:type != CTI_KEYBOARD_EVENT; return .F.; endif

//outlog(__FILE__,__LINE__,procname(),event:keycode, K_CTRL_T)

	switch (event:keycode)
		case K_DOWN
		obj:move_vertical(1)

		case K_UP
		obj:move_vertical(-1)

		case K_LEFT
		obj:scroll_horizontal(-1)

		case K_RIGHT
		obj:scroll_horizontal(1)

		case K_PGDN
		obj:move_vertical(obj:__vis_rows)

		case K_PGUP
		obj:move_vertical(-obj:__vis_rows)
	end
return TRUE
