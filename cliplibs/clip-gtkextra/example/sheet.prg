#include <inkey.ch>
#include <clip-gtk.ch>
#include <clip-gtkextra.ch>
#include "pixmaps.ch"

#define FALSE	.F.
#define TRUE	.T.

#define DEFAULT_PRECISION 3
#define DEFAULT_SPACE 8
#define NUM_SHEETS 3

static window
static main_vbox
static notebook
static sheets
static scrolled_windows
static show_hide_box
static status_box
static location
static entry
static fgcolorcombo
static bgcolorcombo
static bordercombo
static pixmap
static mask
static bg_pixmap
static fg_pixmap
static toolbar
static left_button
static center_button
static right_button
static tpixmap
static bullet:=array(6)
static smile
static curve
static popup

function Main()
	local label
	local request
	local hide_row_titles
	local hide_column_titles
	local show_row_titles
	local show_column_titles
	local font_combo
	local toggle_combo
	local colormap
	local i, height
        local title, folder

	gtk_Init()

	sheets := {}
        scrolled_windows:={}

  	title  := {"Example 1", "Example 2", "Example 3", "Example 4"}
  	folder := {"Folder 1", "Folder 2", "Folder 3", "Folder 4"}

	window = gtk_WindowNew(,"Sheet Demo")
	gtk_WidgetSetSize(window, 900, 600)

	gtk_SignalConnect(window, GTK_DELETE,{||gtk_Quit()})

	main_vbox=gtk_VBoxNew(,.F.,1)
	gtk_ContainerSetBorderWidth(main_vbox,0) 
	gtk_ContainerAdd(window, main_vbox)
	gtk_WidgetShow(main_vbox)

	show_hide_box = gtk_HBoxNew(,.F., 1) 
	hide_row_titles = gtk_ButtonNew(,"Hide Row Titles") 
	hide_column_titles = gtk_ButtonNew(,"Hide Column Titles") 
	show_row_titles = gtk_ButtonNew(,"Show Row Titles") 
	show_column_titles = gtk_ButtonNew(,"Show Column Titles")

	gtk_BoxPackStart(show_hide_box, hide_row_titles, .T., .T., 0) 
	gtk_BoxPackStart(show_hide_box, hide_column_titles, .T., .T., 0)
	gtk_BoxPackStart(show_hide_box, show_row_titles, .T., .T., 0)
	gtk_BoxPackStart(show_hide_box, show_column_titles, .T., .T., 0)

	gtk_WidgetShow(hide_row_titles) 
	gtk_WidgetShow(hide_column_titles)
	gtk_WidgetShow(show_row_titles) 
	gtk_WidgetShow(show_column_titles)

	gtk_SignalConnect(hide_row_titles, "clicked", @do_hide_row_titles())
	gtk_SignalConnect(hide_column_titles, "clicked", @do_hide_column_titles())
	gtk_SignalConnect(show_row_titles, "clicked", @do_show_row_titles())
	gtk_SignalConnect(show_column_titles, "clicked", @do_show_column_titles())

	gtk_BoxPackStart(main_vbox, show_hide_box, .F., .T., 0)
	gtk_WidgetShow(show_hide_box)

	toolbar=gtk_ToolbarNew(,GTK_ORIENTATION_HORIZONTAL, GTK_TOOLBAR_ICONS)

	gtk_ToolbarAppendSpace(toolbar)

  	font_combo = gtk_FontComboNew()
	gtk_ToolbarAppendWidget(toolbar, font_combo, "font", "font")

	gtk_WidgetSetSize(font_combo:ItalicButton, 32, 32)
	gtk_WidgetSetSize(font_combo:BoldButton, 32, 32)
	gtk_WidgetShow(font_combo)
	gtk_SignalConnect(font_combo, "changed", @new_font())

	gtk_ToolbarAppendSpace(toolbar)

	left_button = gtk_ToggleButtonNew()
	gtk_ToolbarAppendWidget(toolbar, left_button, "justify left", "justify left")
	gtk_WidgetShow(left_button)
	gtk_SignalConnect(left_button,"released", @justify_left())

	center_button = gtk_ToggleButtonNew()
	gtk_ToolbarAppendWidget(toolbar, center_button, "justify center", "justify center")
	gtk_WidgetShow(center_button)
	gtk_SignalConnect(center_button, "released", @justify_center())

	right_button = gtk_ToggleButtonNew()
	gtk_ToolbarAppendWidget(toolbar, right_button, "justify right", "justify right")
	gtk_WidgetShow(right_button)
	gtk_SignalConnect(right_button, "released", @justify_right())

	gtk_ToolbarAppendSpace(toolbar)

	gtk_WidgetSetSize(left_button, 32, 32)
	gtk_WidgetSetSize(center_button, 32, 32)
	gtk_WidgetSetSize(right_button, 32, 32)

	bordercombo=gtk_BorderComboNew()
	gtk_ToolbarAppendWidget(toolbar, bordercombo, "border", "border")
	gtk_WidgetSetSize(bordercombo:button, 32, 32)
	gtk_WidgetShow(bordercombo)

	gtk_SignalConnect(bordercombo, "changed", @change_border())

	gtk_ToolbarAppendSpace(toolbar)

	fgcolorcombo=gtk_ColorComboNew()
	gtk_ToolbarAppendWidget(toolbar, fgcolorcombo, "font color", "font color")
	gtk_WidgetShow(fgcolorcombo)
	gtk_SignalConnect(fgcolorcombo, "changed", @change_fg())

	gtk_ToolbarAppendSpace(toolbar)

	bgcolorcombo=gtk_ColorComboNew()
	gtk_ToolbarAppendWidget(toolbar, bgcolorcombo, "background color", "background color")
	gtk_WidgetShow(bgcolorcombo)
	gtk_SignalConnect(bgcolorcombo, "changed", @change_bg())

	gtk_ToolbarAppendSpace(toolbar)

	toggle_combo = gtk_ToggleComboNew(, 5, 5)
	gtk_ToolbarAppendWidget(toolbar, toggle_combo, "test", "test")
	gtk_WidgetSetSize(toggle_combo:button, 32, 32)
	gtk_WidgetShow(toggle_combo)

	gtk_BoxPackStart(main_vbox, toolbar, FALSE, TRUE, 0)
	gtk_WidgetShow(toolbar)

	status_box=gtk_HBoxNew(, FALSE, 1)
	gtk_ContainerSetBorderWidth(status_box,0)
	gtk_BoxPackStart(main_vbox, status_box, FALSE, TRUE, 0)
	gtk_WidgetShow(status_box)

	location = gtk_LabelNew(,"")
        height:=0
	gtk_WidgetGetSize(location, , @height)
	gtk_WidgetSetSize(location, 160, height)
	gtk_BoxPackStart(status_box, location, FALSE, TRUE, 0)
	gtk_WidgetShow(location)

	entry=gtk_EntryNew()
	gtk_BoxPackStart(status_box, entry, TRUE, TRUE, 0)
	gtk_WidgetShow(entry)

	notebook=gtk_NotebookNew()
	gtk_NotebookSetTabPos(notebook, GTK_POS_BOTTOM)
	gtk_BoxPackStart(main_vbox, notebook, TRUE, TRUE, 0)
	gtk_WidgetShow(notebook)

	for i:=1 to NUM_SHEETS
		aadd(sheets, gtk_SheetNew(,1000,26,title[i]))
		aadd(scrolled_windows, gtk_ScrolledWindowNew())

		gtk_ContainerAdd(scrolled_windows[i], sheets[i])
		gtk_WidgetShow(sheets[i])

		gtk_WidgetShow(scrolled_windows[i])

		label=gtk_LabelNew(, folder[i])
		gtk_NotebookAppendPage(notebook, scrolled_windows[i], label)

		gtk_SignalConnect(gtk_SheetGetEntry(sheets[i]), "changed", @show_entry())

		gtk_SignalConnect(sheets[i], "activate", @activate_sheet_cell())
	next

	gtk_SignalConnect(entry, "changed", @show_sheet_entry())
	gtk_SignalConnect(entry, "activate", @activate_sheet_entry())

	build_example1(sheets[1])
  	build_example2(sheets[2])
  	build_example3(sheets[3])

	gtk_SignalConnect(gtk_SheetGetEntry(sheets[3]), "changed", @show_entry())

	tpixmap = gtk_PixmapCreateFromXpmD(, left_just)
  	gtk_ContainerAdd(left_button, tpixmap)
  	gtk_WidgetShow(tpixmap)

	tpixmap=gtk_PixmapCreateFromXpmD(, center_just)
	gtk_ContainerAdd(center_button, tpixmap)
	gtk_WidgetShow(tpixmap)

	tpixmap=gtk_PixmapCreateFromXpmD(, right_just)
	gtk_ContainerAdd(right_button, tpixmap)
	gtk_WidgetShow(tpixmap)

	bg_pixmap=gtk_PixmapCreateFromXpmD(, paint)
	gtk_ContainerAdd(bgcolorcombo:Button, bg_pixmap)
	gtk_WidgetShow(bg_pixmap)

	fg_pixmap=gtk_PixmapCreateFromXpmD(, font)
	gtk_ContainerAdd(fgcolorcombo:Button, fg_pixmap)
	gtk_WidgetShow(fg_pixmap)

	gtk_WidgetShow(window)

	gtk_Main()

return

***********************************

function do_hide_row_titles() 
	local current, cur_page

	cur_page = gtk_NotebookGetCurrentPage(notebook)
  	current = sheets[cur_page]

	gtk_SheetHideRowTitles(current)
return

function do_hide_column_titles()
	local current, cur_page

	cur_page = gtk_NotebookGetCurrentPage(notebook)
  	current = sheets[cur_page]

	gtk_SheetHideColumnTitles(current)
return

function do_show_row_titles()
	local current, cur_page

	cur_page = gtk_NotebookGetCurrentPage(notebook)
  	current = sheets[cur_page]

	gtk_SheetShowRowTitles(current)
return

function do_show_column_titles()
	local current, cur_page

	cur_page = gtk_NotebookGetCurrentPage(notebook)
  	current = sheets[cur_page]

	gtk_SheetShowColumnTitles(current)
return

function show_entry(widget, event)
	local text, sheet, sheet_entry, cur_page

	if .not. gtk_WidgetHasFocus(widget); return; endif

	cur_page = gtk_NotebookGetCurrentPage(notebook)
	sheet=sheets[cur_page]
	sheet_entry = gtk_SheetGetEntry(sheet)

	if !empty(text:=gtk_EntryGetText (sheet_entry))
		gtk_EntrySetText(entry, text)
	endif
return

function activate_sheet_cell(sheet, event)
	local sheet_entry, cell, text, attributes, col

	sheet_entry = gtk_SheetGetEntry(sheet)

	col := gtk_SheetGetColumn(sheet,event:Col)
	if !empty(col) .and. HASH_NAME $ col
        	cell = "  "+alltrim(col:Name)+":"+alltrim(str(event:Row-1))+"  "
  	else
        	cell = " ROW: "+alltrim(str(event:Row-1))+" COLUMN: "+alltrim(str(event:Col-1))+" "
        endif

	gtk_LabelSetText(location, cell)

	gtk_EntrySetMaxLength(entry, gtk_EntryGetMaxLength(sheet_entry))

	gtk_EntrySetText(entry,gtk_EntryGetText(gtk_SheetGetEntry(sheet)))

	attributes := gtk_SheetGetAttributes(sheet,gtk_SheetGetActiveCell(sheet):row, ;
				gtk_SheetGetActiveCell(sheet):col)

	gtk_EntrySetEditable(entry, attributes:IsEditable)

	switch (attributes:Justification)
    		case GTK_JUSTIFY_LEFT
         		justify_left()
    		case GTK_JUSTIFY_CENTER
         		justify_center()
    		case GTK_JUSTIFY_RIGHT
         		justify_right()
    		otherwise
         		justify_left()
  	endswitch
return TRUE

function new_font(font_combo)
	local current, cur_page

	cur_page=gtk_NotebookGetCurrentPage(notebook)
	current=sheets[cur_page]

	gtk_SheetRangeSetFont(current, gtk_SheetGetRange(current), gtk_FontComboGetFont(font_combo))
return

function justify_left()
	local current, cur_page

	cur_page=gtk_NotebookGetCurrentPage(notebook)
	current=sheets[cur_page]

	gtk_ToggleButtonSetActive(left_button, TRUE)
	gtk_ToggleButtonSetActive(right_button, FALSE)
	gtk_ToggleButtonSetActive(center_button, FALSE)

	gtk_SheetRangeSetJustification(current, gtk_SheetGetRange(current), GTK_JUSTIFY_LEFT)
return

function justify_center()
	local current, cur_page

	cur_page=gtk_NotebookGetCurrentPage(notebook)
	current=sheets[cur_page]

	gtk_ToggleButtonSetActive(left_button, .F.)
	gtk_ToggleButtonSetActive(right_button, .F.)
	gtk_ToggleButtonSetActive(center_button, .T.)

	gtk_SheetRangeSetJustification(current, gtk_SheetGetRange(current), GTK_JUSTIFY_CENTER)
return

function justify_right()
	local current, cur_page

	cur_page=gtk_NotebookGetCurrentPage(notebook)
	current=sheets[cur_page]

	gtk_ToggleButtonSetActive(left_button, FALSE)
	gtk_ToggleButtonSetActive(right_button, TRUE)
	gtk_ToggleButtonSetActive(center_button, FALSE)

	gtk_SheetRangeSetJustification(current, gtk_SheetGetRange(current), GTK_JUSTIFY_RIGHT)
return

function change_border (widget, event)
	local current, cur_page, range, auxrange:=map()
	local border_mask, border_width:=3
	local auxcol, auxrow
	local i,j

	cur_page=gtk_NotebookGetCurrentPage(notebook)
	current=sheets[cur_page]

	range=gtk_SheetGetRange(current)

	gtk_SheetRangeSetBorder(current, range, 0, 0, 0)

	switch(event:Selection)
		case 0
       			break
     		case 1
       			border_mask = GTK_SHEET_TOP_BORDER
       			range:rowi = range:row0
       			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
     		case 2
       			border_mask = GTK_SHEET_BOTTOM_BORDER
       			range:row0 = range:rowi
       			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
		case 3
       			border_mask = GTK_SHEET_RIGHT_BORDER
       			range:col0 = range:coli
       			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
		case 4
       			border_mask = GTK_SHEET_LEFT_BORDER
       			range:coli = range:col0
       			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
		case 5
       			if range:col0 == range:coli
	   			border_mask = GTK_SHEET_LEFT_BORDER + GTK_SHEET_RIGHT_BORDER
				gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
				break
                        endif
			border_mask = GTK_SHEET_LEFT_BORDER
			auxcol=range:coli
			range:coli = range:col0
			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
			border_mask = GTK_SHEET_RIGHT_BORDER
			range:col0 := range:coli:=auxcol
			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
		case 6
       			if(range:row0 == range:rowi)
	   			border_mask = GTK_SHEET_TOP_BORDER + GTK_SHEET_BOTTOM_BORDER
	   			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
				break
			endif
			border_mask = GTK_SHEET_TOP_BORDER
			auxrow=range:rowi
			range:rowi = range:row0
			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
			border_mask = GTK_SHEET_BOTTOM_BORDER
			range:row0:=range:rowi:=auxrow
			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
		case 7
			border_mask = GTK_SHEET_RIGHT_BORDER + GTK_SHEET_LEFT_BORDER
			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
     		case 8
       			border_mask = GTK_SHEET_BOTTOM_BORDER + GTK_SHEET_TOP_BORDER
       			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
		case 9
			gtk_SheetRangeSetBorder(current, range, 15, border_width, 0)
       			for i:=range:row0 to range:rowi
        			for j:=range:col0 to range:coli
          				border_mask = 15
          				auxrange:row0 = i
          				auxrange:rowi = i
          				auxrange:col0 = j
          				auxrange:coli = j
          				iif (i == range:rowi, border_mask := NumXor(border_mask, GTK_SHEET_BOTTOM_BORDER), nil)
          				iif (i == range:row0, border_mask := NumXor(border_mask, GTK_SHEET_TOP_BORDER), nil)
          				iif (j == range:coli, border_mask := NumXor(border_mask, GTK_SHEET_RIGHT_BORDER), nil)
          				iif (j == range:col0, border_mask := NumXor(border_mask, GTK_SHEET_LEFT_BORDER), nil)
          				if border_mask != 15
						gtk_SheetRangeSetBorder(current, auxrange, border_mask, border_width, 0)
                                        endif
                                 next
			next
		case 10
       			for i:=range:row0 to range:rowi
        			for j:=range:col0 to range:coli
          				border_mask = 0
          				auxrange:row0 = i
          				auxrange:rowi = i
          				auxrange:col0 = j
          				auxrange:coli = j
          				iif (i == range:rowi, border_mask := NumOr(border_mask, GTK_SHEET_BOTTOM_BORDER),nil)
          				iif (i == range:row0, border_mask := NumOr(border_mask, GTK_SHEET_TOP_BORDER),nil)
          				iif (j == range:coli, border_mask := NumOr(border_mask, GTK_SHEET_RIGHT_BORDER),nil)
          				iif (j == range:col0, border_mask := NumOr(border_mask, GTK_SHEET_LEFT_BORDER),nil)
          			       	if border_mask != 0
            					gtk_SheetRangeSetBorder(current, auxrange, border_mask, border_width, 0)
                                        endif
       				next
                        next
		case 11
       			border_mask = 15
       			gtk_SheetRangeSetBorder(current, range, border_mask, border_width, 0)
	endswitch
return

function change_fg(widget, event)
	local current, color, cur_page, tmp_gc

	cur_page=gtk_NotebookGetCurrentPage(notebook)
	current=sheets[cur_page]

	color = gdk_ColorParse(event:ColorName)
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetForeground(current, gtk_SheetGetRange(current), color)

	tmp_gc=gdk_GCNew(,window)
	gdk_GCSetForeground(tmp_gc, color)
	gdk_DrawRectangle(fg_pixmap, tmp_gc, TRUE, 5,20,16,4)
	gtk_WidgetQueueDraw(fg_pixmap)
        gdk_GCUnref(tmp_gc)
return

function change_bg(widget, event)
	local current, color, cur_page
	local tmp_gc

	cur_page=gtk_NotebookGetCurrentPage(notebook)
	current=sheets[cur_page]

	color = gdk_ColorParse(event:ColorName)
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
   	gtk_SheetRangeSetBackground(current, gtk_SheetGetRange(current), color)

	tmp_gc=gdk_GCNew(,window)
	gdk_GCSetForeground(tmp_gc,color)
	gdk_DrawRectangle(bg_pixmap, tmp_gc, TRUE, 4,20,18,4)
	gtk_WidgetQueueDraw(bg_pixmap)
	gdk_GCUnref(tmp_gc)
return

function show_sheet_entry(widget)
	local text, sheet, sheet_entry, cur_page

	if !GTK_WidgetHasFocus(widget); return; endif

	cur_page = gtk_NotebookGetCurrentPage(notebook)
	sheet=sheets[cur_page]
	sheet_entry = gtk_SheetGetEntry(sheet)

	gtk_EntrySetText(sheet_entry, gtk_EntryGetText(entry))
return

function activate_sheet_entry(widget)
	local sheet, sheet_entry, cur_page, row, col
	local justification:=GTK_JUSTIFY_LEFT

	cur_page = gtk_NotebookGetCurrentPage(notebook)
	sheet=sheets[cur_page]
  	row=gtk_SheetGetActiveCell(sheet):row
  	col=gtk_SheetGetActiveCell(sheet):col

	sheet_entry = gtk_SheetGetEntry(sheet)

	if gtk_WidgetGetType(sheet_entry) == GTK_WIDGET_ITEM_ENTRY
		justification = gtk_ItemEntryGetJustification(sheet_entry)
        endif

	gtk_SheetSetCell(sheet, row, col,justification, gtk_EntryGetText (sheet_entry))
return

function show_child(widget)
	if .not. GTK_WIDGET_MAPPED(curve)
		gtk_SheetAttach(sheets[1], curve, 3, 8, 0., 0.)
	endif
/*         gtk_sheet_put(GTK_SHEET(sheets[0]), curve, 550, 120);
*/
return

function clipboard_handler(sheet, Event)
	if NumAnd(Event:state, GDK_CONTROL_MASK)!=0 .or. ;
		Event:keyval==GDK_Control_L .or. Event:keyval == GDK_Control_R

    		if (Event:keyval==K_ALT_C)
//    		if (Event:keyval==0x043 .or. Event:keyval == 0x063)// .and. ;
//    		if (Event:keyval==asc('c') .or. Event:keyval == asc('C'))// .and. ;
//    				gtk_SheetGetState(sheet) != GTK_STATE_NORMAL
            		if (GTK_SHEET_IN_CLIP(sheet))
            			gtk_SheetUnclipRange(sheet)
			endif
            		gtk_SheetClipRange(sheet, gtk_SheetGetRange(sheet))
/*            gtk_sheet_unselect_range(sheet);
*/
    		endif
//    		if Event:keyval == asc('x') .or. Event:keyval == asc('X')
    		if Event:keyval == K_ALT_X
            		gtk_SheetUnclipRange(sheet)
                endif
	endif
return

function resize_handler(widget, event)
  ? "OLD SELECTION: ",alltrim(str(event:OldRange:Row0))," ",;
  	alltrim(str(event:OldRange:Col0))," ",;
  	alltrim(str(event:OldRange:RowI))," ",;
  	alltrim(str(event:OldRange:ColI))

  ? "NEW SELECTION: ",alltrim(str(event:NewRange:Row0))," ",;
  	alltrim(str(event:NewRange:Col0))," ",;
  	alltrim(str(event:NewRange:RowI))," ",;
  	alltrim(str(event:NewRange:ColI))
return

function move_handler(widget, event)
  ? "OLD SELECTION: ",alltrim(str(event:OldRange:Row0))," ",;
  	alltrim(str(event:OldRange:Col0))," ",;
  	alltrim(str(event:OldRange:RowI))," ",;
  	alltrim(str(event:OldRange:ColI))

  ? "NEW SELECTION: ",alltrim(str(event:NewRange:Row0))," ",;
  	alltrim(str(event:NewRange:Col0))," ",;
  	alltrim(str(event:NewRange:RowI))," ",;
  	alltrim(str(event:NewRange:ColI))
return

static function alarm_change(widget, event)
	? "CHANGE CELL: ",alltrim(str(event:Row))," ",alltrim(str(event:Col))
return

static function alarm_activate(widget, event)
	local range:=map()

	? "ACTIVATE CELL: ",alltrim(str(event:Row))," ",alltrim(str(event:Col))

	range:row0 := range:rowi := event:Row
 	range:col0 := range:coli := event:Col
/*
 gtk_sheet_range_set_justification(GTK_SHEET(widget), &range, GTK_JUSTIFY_LEFT);
*/
return

static function alarm_deactivate(widget, event)
	local range:=map()

	? "DEACTIVATE CELL: ",alltrim(str(event:Row))," ",alltrim(str(event:Col))

	range:row0 := range:rowi := event:Row
 	range:col0 := range:coli := event:Col
/*
 gtk_sheet_range_set_justification(GTK_SHEET(widget), &range, GTK_JUSTIFY_RIGHT);
*/
return

static function alarm_traverse(widget, event)
	? "TRAVERSE: ",alltrim(str(event:Row))," ",alltrim(str(event:Col)), ;
        	alltrim(str(event:NewRow))," ",alltrim(str(event:NewCol))
return TRUE

function build_example1(sheet)
	local show_button, range:=map()
	local area, color, colormap, font

	local font_name1 := "-bitstream-charter-bold-r-normal--36-360-72-72-p-0-iso8859-1"
	local font_name2 := "-bitstream-charter-bold-r-normal--28-280-72-72-p-0-iso8859-1";

	local name, i

//	colormap = gdk_colormap_get_system()


	for i:=1 to gtk_SheetGetMaxCol(sheet)
   		name := chr(asc('A')+i-1)
   		gtk_SheetColumnButtonAddLabel(sheet, i, name)
   		gtk_SheetSetColumnTitle(sheet, i, name)
 	next

	gtk_SheetRowButtonAddLabel(sheet, 1, "This is&\na multiline&\nlabel")
	gtk_SheetRowButtonJustify(sheet, 1, GTK_JUSTIFY_RIGHT)

	range:row0=2
 	range:rowi=3
	range:col0=2
	range:coli=4

	gtk_SheetClipRange(sheet, range)

	font=gdk_FontLoad(, font_name2)
 	if font == nil
   		? "Couldn't load " + font_name2
	else
		gtk_SheetRangeSetFont(sheet, range, font)
        endif

	color = gdk_ColorParse("red")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(sheet), color)
	gtk_SheetRangeSetForeground(sheet, range, color)

	gtk_SheetSetCell(sheet, 2,3, GTK_JUSTIFY_CENTER, "Welcome to")

	range:row0=3

	font=gdk_FontLoad(, font_name1)
	if font == NIL
   		? "Couldn't load " + font_name1
	else
		gtk_SheetRangeSetFont(sheet, range, font)
        endif

	color = gdk_ColorParse("blue")
//	gdk_Color_alloc(gtk_widget_get_colormap(widget), &color);
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(sheet), color)
	gtk_SheetRangeSetForeground(sheet, range, color)

	gtk_SheetSetCell(sheet, 3,3, GTK_JUSTIFY_CENTER, "GtkSheet")

	range:row0=4
	range:rowi=4
	range:col0=1
	range:coli=5
	color = gdk_ColorParse("dark gray")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(sheet), color)
	gtk_SheetRangeSetBackground(sheet, range, color)
	color = gdk_ColorParse("green")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(sheet), color)
	//gtk_SheetRangeSetForeground(sheet, range, color)

	gtk_SheetSetCell(sheet,4,3,GTK_JUSTIFY_CENTER,"a Matrix widget for Gtk+")
	gtk_SheetSetCell(sheet,5,2,GTK_JUSTIFY_LEFT,"GtkSheet is a matrix where you can allocate cells of text.")
	gtk_SheetSetCell(sheet,6,2,GTK_JUSTIFY_LEFT,"Cell contents can be edited interactively with an specially designed entry")
	gtk_SheetSetCell(sheet,7,2,GTK_JUSTIFY_LEFT,"You can change colors, borders, and many other attributes")
	gtk_SheetSetCell(sheet,8,2,GTK_JUSTIFY_LEFT,"Drag & drop or resize the selection clicking the corner or border")
	gtk_SheetSetCell(sheet,9,2,GTK_JUSTIFY_LEFT,"Store the selection on the clipboard pressing Ctrl-C")
	gtk_SheetSetCell(sheet,10,2,GTK_JUSTIFY_LEFT,"(The selection handler has not been implemented yet)")
	gtk_SheetSetCell(sheet,11,2,GTK_JUSTIFY_LEFT,"You can add buttons, charts, pixmaps, and other widgets")


 	gtk_SignalConnect(sheet,"key-press-event", @clipboard_handler())
	gtk_SignalConnect(sheet,"resize-range", @resize_handler())
	gtk_SignalConnect(sheet,"move-range", @move_handler())
 	gtk_SignalConnect(sheet,"changed", @alarm_change())
	gtk_SignalConnect(sheet,"activate", @alarm_activate())
	gtk_SignalConnect(sheet,"deactivate", @alarm_deactivate())
	gtk_SignalConnect(sheet,"traverse", @alarm_traverse())

	curve=gtk_CurveNew()
	gtk_CurveSetRange(curve, 0, 200, 0, 200)
	gtk_WidgetShow(curve)

	for i:=1 to 5
      		bullet[i] = gtk_PixmapCreateFromXpmD(, bullet_xpm)
      		gtk_WidgetShow(bullet[i])
      		area = gtk_SheetGetCellArea(sheets[1], 4+i, 1)
/*      gtk_sheet_put(GTK_SHEET(sheets[0]), bullet[i], 
                    area.x+area.width/2-8, area.y+area.height/2-8);
*/
      		gtk_SheetAttach(sheets[1], bullet[i], 4+i, 1, .5, .5)
 	next

 	bullet[6] = gtk_PixmapCreateFromXpmD(, bullet_xpm)
 	gtk_WidgetShow(bullet[6])
 	area = gtk_SheetGetCellArea(sheets[1], 11, 1)
/* gtk_sheet_put(GTK_SHEET(sheets[0]), bullet[i], 
               area.x+area.width/2-8, area.y+area.height/2-8);
*/
	gtk_SheetAttach(sheets[1], bullet[6], 11, 1, .5, .5)

	smile = gtk_PixmapCreateFromXpmD(, smile_xpm)
	gtk_WidgetShow(smile)
 	gtk_SheetButtonAttach(sheets[1], smile, 0, 6, .5, .5)


 	show_button=gtk_ButtonNew(,"Show me a plot")
 	gtk_WidgetShow(show_button)
	gtk_WidgetSetSize(show_button, 100,60)
	area = gtk_SheetGetCellArea(sheets[1], 13, 3)
/* gtk_sheet_put(GTK_SHEET(sheets[0]), show_button, area.x, area.y);
*/
	gtk_SheetAttach(sheets[1], show_button, 13, 3, .5, .5)

	gtk_SignalConnect(show_button, "clicked", @show_child())
/*
 gtk_signal_connect(GTK_OBJECT(sheet),
                    "button_press_event",
                    (GtkSignalFunc) do_popup, 
                    NULL);
*/

return

static function popup_activated(menuitem)
	local sheet, cur_page, range, item:=menuitem:Name

	cur_page = gtk_NotebookGetCurrentPage(notebook)
	sheet=sheets[cur_page]

	if item == "Add Column"
		gtk_SheetAddColumn(sheet,1)
	endif

	if item == "Add Row"
		gtk_SheetAddRow(sheet,1)
	endif

	if item == "Insert Row"
   		if gtk_SheetGetState(sheet) == GTK_SHEET_ROW_SELECTED
     			sheet:range = gtk_SheetGetRange(sheet)
     			gtk_SheetInsertRows(sheet,sheet:range:row0, ;
                               sheet:range:rowi-sheet:range:row0+1)
		endif
        endif

	if item == "Insert Column"
   		if gtk_SheetGetState(sheet) == GTK_SHEET_COLUMN_SELECTED
     			sheet:range = gtk_SheetGetRange(sheet)
     			gtk_SheetInsertColumns(sheet,sheet:range:col0, ;
                              sheet:range:coli - sheet:range:col0+1)
		endif
	endif

	if item == "Delete Row"
   		if gtk_SheetGetState(sheet) == GTK_SHEET_ROW_SELECTED
     			sheet:range = gtk_SheetGetRange(sheet)
     			gtk_SheetDeleteRows(sheet,sheet:range:row0, ;
                              sheet:range:rowi - sheet:range:row0+1)
		endif
	endif

	if item == "Delete Column"
   		if gtk_SheetGetState(sheet) == GTK_SHEET_COLUMN_SELECTED
     			sheet:range = gtk_SheetGetRange(sheet)
     			gtk_SheetDeleteColumns(sheet,sheet:range:col0, ;
                              sheet:range:coli - sheet:range:col0+1)
		endif
	endif

	if item == "Clear Cells"
   		if gtk_SheetGetState(sheet) != GTK_SHEET_NORMAL
     			gtk_SheetRangeClear(sheet, gtk_SheetGetRange(sheet))
		endif
	endif

	gtk_WidgetDestroy(popup)
        popup := nil
return TRUE

function build_menu(sheet)
	static items:={			;
		"Add Column",		;
		"Add Row",		;
		"Insert Row",		;
		"Insert Column",	;
		"Delete Row",		;
                "Delete Column",	;
                "Clear Cells"		;
	}
	local menu, item, i

	menu=gtk_MenuNew()

	for i=1 to len(items)
		item=gtk_MenuItemNew(,items[i])
                item:Name:=items[i]
	 	gtk_SignalConnect(item,"activate", @popup_activated())
                GTK_WIDGET_SET_FLAGS (item, GTK_SENSITIVE + GTK_CAN_FOCUS)
                switch (i)
                    case 3
                    	if gtk_SheetGetState(sheet) != GTK_SHEET_ROW_SELECTED
                     		GTK_WIDGET_UNSET_FLAGS (item, GTK_SENSITIVE + GTK_CAN_FOCUS)
                        endif
                    case 4
                    	if gtk_SheetGetState(sheet) != GTK_SHEET_COLUMN_SELECTED
                     		GTK_WIDGET_UNSET_FLAGS (item, GTK_SENSITIVE + GTK_CAN_FOCUS)
                    	endif
                    case 5
                    	if gtk_SheetGetState(sheet) != GTK_SHEET_ROW_SELECTED
                     		GTK_WIDGET_UNSET_FLAGS (item, GTK_SENSITIVE + GTK_CAN_FOCUS)
                    	endif
                    case 6
                    	if gtk_SheetGetState(sheet) != GTK_SHEET_COLUMN_SELECTED
                     		GTK_WIDGET_UNSET_FLAGS (item, GTK_SENSITIVE + GTK_CAN_FOCUS)
                    	endif
                endswitch

		gtk_WidgetShow(item)
	    	gtk_MenuAppend(menu,item)
	next

return menu

function do_popup(widget, event)
	local mods, sheet

	sheet=widget

	if event:Button == 3
		popup=build_menu(sheet)

		gtk_MenuPopup(popup)
	endif
return TRUE

function format_text (sheet, text, justification, label)
	local auxval, digspace:=0, cell_width, char_width, val := 0.0
	local format, space, intspace, nonzero:=FALSE, ipos, nchar
	local fEMPTY:=0, fTEXT:=1, fNUMERIC:=2

//	cell_width = sheet->column[sheet->active_cell.col].width
        cell_width = gtk_SheetGetColumn(sheet,gtk_SheetGetActiveCell(sheet):col):Width
//	char_width = gdk_CharWidth (GTK_WIDGET(sheet)->style->font,(gchar)'X')
	char_width = gdk_CharWidth (gtk_WidgetGetStyle(sheet):font,"X")
	space = int(cell_width / char_width)

	intspace = MIN(space, DEFAULT_SPACE)

	format = fEMPTY
	if (len(text) != 0)
		for ipos:=1 to len(text)

			switch (nchar:=substr(text,ipos,1))
           			case '.', ' ', ',', '-', '+', 'd', 'D', 'E', 'e', '1', '2', '3', '4', '5', '6', '7', '8', '9'
           				nonzero := TRUE
           			case '0'
//            				break
           			otherwise
            				format:=fTEXT
          		endswitch
          		if format != fEMPTY; break; endif
		next
        	val := val(text)
        	if  format!=fEMPTY .or. (val==0 .and. nonzero)
             		format = fTEXT
        	else
             		format = fNUMERIC
                endif
	endif

	switch (format)
    		case 0,1
      			label := text
      			return
    		case 2
      			val = val(text)
      			justification = GTK_JUSTIFY_RIGHT
	endswitch

	auxval= iif(val < 0, -val , val)

	do while auxval<1 .and. auxval != 0
   		auxval=auxval*10
   		digspace += 1
  	enddo

	if digspace+DEFAULT_PRECISION+1>intspace .or. digspace > DEFAULT_PRECISION
    		label := str(val, intspace+DEFAULT_PRECISION+1, DEFAULT_PRECISION)
  	else
//		intspace=MIN(intspace, len(text)-digspace-1)
                label := str(val, intspace+DEFAULT_PRECISION+1, DEFAULT_PRECISION)
		if len(label) > space
                        label := str(val, intspace+DEFAULT_PRECISION+1, DEFAULT_PRECISION)
                endif
	endif
return

function parse_numbers(widget)
	local sheet, label, justification, attr

	sheet=widget

	sheet:ActiveCell := gtk_SheetGetActiveCell(sheet)
	attr = gtk_SheetGetAttributes(sheet, sheet:ActiveCell:row, ;
					sheet:ActiveCell:col)

	justification = attr:Justification
	format_text(sheet, gtk_EntryGetText(gtk_SheetGetEntry(sheet)), @justification, @label)

	gtk_SheetSetCell(sheet, sheet:ActiveCell:row, ;
			   sheet:ActiveCell:col, justification, label)
return

function build_example2(widget)
	local sheet, range:=map(), color

	sheet=widget
	GTK_SheetUnsetFlags(sheet, flg_GTK_SHEET_AUTO_SCROLL)
/*
 GTK_SHEET_UNSET_FLAGS(sheet, GTK_SHEET_JUSTIFY_ENTRY)
*/
	gtk_SheetSetSelectionMode(sheet, GTK_SELECTION_SINGLE)

	range:row0=1
	range:rowi=3
	range:col0=1
	range:coli=gtk_SheetGetMaxCol(sheet)
	gtk_SheetRangeSetEditable(sheet, range, FALSE)
	color = gdk_ColorParse("light gray")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetBackground(sheet, range, color)
	color = gdk_ColorParse("blue")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetForeground(sheet, range, color)
	range:row0=2
	color = gdk_ColorParse("red")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetForeground(sheet, range, color)
	range:row0=3
	color = gdk_ColorParse("black")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetForeground(sheet, range, color)

	gtk_SheetRowSetSensitivity(sheet, 1, FALSE)
	gtk_SheetRowSetSensitivity(sheet, 2, FALSE)
	gtk_SheetRowSetSensitivity(sheet, 3, FALSE)
	gtk_SheetSetCell(sheet, 1,3, GTK_JUSTIFY_CENTER, ;
                    "Click the right mouse button to display a popup")
	gtk_SheetSetCell(sheet, 2,3, GTK_JUSTIFY_CENTER, ;
                    "You can connect a parser to the 'set cell' signal")
	gtk_SheetSetCell(sheet, 3,4, GTK_JUSTIFY_CENTER, ;
                    "(Try typing numbers)")
	gtk_SheetSetActiveCell(sheet, 4, 1)
/*
 gtk_sheet_set_update_policy(sheet, GTK_UPDATE_CONTINUOUS, GTK_UPDATE_CONTINUOUS)
*/
	gtk_SignalConnect(sheet, "button-press-event", @do_popup())
	gtk_SignalConnect(sheet, "set-cell", @parse_numbers())
return

static function change_entry(sheet, event)

	if event:NewCol == 1 .and. event:Col != 1
		gtk_SheetChangeEntry(sheet, GTK_WIDGET_COMBO)
	endif

	if event:NewCol == 2 .and. event:Col != 2
		gtk_SheetChangeEntry(sheet, GTK_WIDGET_ENTRY)
	endif

	if event:NewCol == 4 .and. event:Col != 3
		gtk_SheetChangeEntry(sheet, GTK_WIDGET_SPIN_BUTTON)
	endif

	if event:NewCol == 4 .and. event:Col != 4
		gtk_SheetChangeEntry(sheet, GTK_WIDGET_ITEM_ENTRY)
	endif

return TRUE

function build_example3(widget)
	local sheet, range:=map(), color

	sheet=widget

	range:row0=1
	range:rowi=11
	range:col0=1
	range:coli=7
	color = gdk_ColorParse("orange")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetBackground(sheet, range, color)
	color = gdk_ColorParse("violet")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetForeground(sheet, range, color)
	range:row0=2
	color = gdk_ColorParse("blue")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetBackground(sheet, range, color)
	range:coli=1
	color = gdk_ColorParse("dark green")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetBackground(sheet, range, color)

	range:row0=1
	color = gdk_ColorParse("dark blue")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetBorderColor(sheet, range, color)
	gtk_SheetRangeSetBorder(sheet, range, GTK_SHEET_RIGHT_BORDER, 4, 1)
	range:coli=1
	range:col0=1
	range:rowi=1
	color = gdk_ColorParse("red")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetBackground(sheet, range, color)
	gtk_SheetRangeSetBorder(sheet, range, GTK_SHEET_RIGHT_BORDER+GTK_SHEET_BOTTOM_BORDER, 4, 0)
	range:rowi=1
	range:col0=2
	range:coli=7
	color = gdk_ColorParse("dark blue")
	gdk_ColormapAllocColor(gtk_WidgetGetColormap(widget), color)
	gtk_SheetRangeSetBorderColor(sheet, range, color)
	gtk_SheetRangeSetBorder(sheet, range, GTK_SHEET_BOTTOM_BORDER, 4, 1)

	GTK_SheetSetFlags(sheet, flg_GTK_SHEET_AUTORESIZE)

	gtk_SheetChangeEntry(sheet, GTK_WIDGET_COMBO)

	gtk_SignalConnect(sheet, "traverse", @change_entry())
return
