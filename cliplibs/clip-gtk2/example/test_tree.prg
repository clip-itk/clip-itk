
#include <clip-gtk2.ch>

static view, tview, list, tree

function Main()
local win, layout, btn, iter, model, renderer
local i


	gtk_Init()

	win = gtk_WindowNew(, " Test List Store ")

	gtk_WindowSetDefaultSize(win, 280, 435)


        list = gtk_ListStoreNew(, 5, TREE_TYPE_STRING, TREE_TYPE_LOGICAL, TREE_TYPE_NUMERIC, TREE_TYPE_DATE, TREE_TYPE_STRING)

        for i=1 to 10
                iter := NIL

                gtk_ListStoreAppend(list, 1, "str строка"+alltrim(str(i)), ;
                                          2, .t., ;
                		          3, (111.0*i), ;
                                          4, date(), ;
                                          5, "red", ;
                		          -1)

        next

	gtk_ListStoreSet(list, "3", 3, 23.2323)
	gtk_ListStoreSet(list, "9", 3, 11.0)

	model = gtk_TreeModel(list)
	view = gtk_TreeViewNewWithModel(,model)
  	gtk_TreeViewSetRulesHint (view, .t.)
  	gtk_TreeViewSetHeadersVisible (view, .t.)

  	/*****************************************************************/
	/************ FIRST VARIANT CREATE VIEW COLUMN  *****************/
  	/*****************************************************************/

  	*** create text cell
  	renderer = gtk_CellRendererTextNew ()
        gtk_SignalConnect(renderer, "edited", {|w, e| edited(w, e, model, 1)})

  	*** insert new column to view
  	col1 = gtk_TreeViewInsertColumnWithAttributes(view, -1, "Строка 1", renderer, ;
  		"text", 1, ;
  		"editable", 2, ;
  		"background", 5)

        column1 = gtk_TreeViewGetColumn(view, col1)
        gtk_TreeViewColumnSetSortColumnId(column1, col1)



  	*** create toggle cell
  	renderer = gtk_CellRendererToggleNew ()
        gtk_SignalConnect(renderer, "toggled", {|w, e| toggle(w, e, model)})

  	gtk_TreeViewInsertColumnWithAttributes(view, -1, "bool", renderer, ;
  		"active", 2, "radio", 2)


  	*** create next text cell
  	renderer = gtk_CellRendererTextNew ()
        gtk_SignalConnect(renderer, "edited", {|w, e| edited(w, e, model, 3)})

  	col3 = gtk_TreeViewInsertColumnWithAttributes(view, -1, "А вот и число", renderer, ;
  		"text", 3, "editable", 2)
        column3 = gtk_TreeViewGetColumn(view, 3)
        gtk_TreeViewColumnSetSortColumnId(column3, 3)

  	*** create next text cell
  	renderer = gtk_CellRendererTextNew ()
        gtk_SignalConnect(renderer, "edited", {|w, e| edited(w, e, model, 4)})

  	gtk_TreeViewInsertColumnWithAttributes(view, -1, "Sys date", renderer, ;
  		"text", 4, "editable", 2)


  	/*****************************************************************/
	/************ SECOND VARIANT CREATE VIEW COLUMN  *****************/
        /******************* use TreeViewColumn **************************/
  	/*****************************************************************/

/****
  	*** create text cell
  	renderer = gtk_CellRendererTextNew ()
        gtk_SignalConnect(renderer, "edited", {|w, e| edited(w, e, model, 1)})

  	*** create column1
  	column1 = gtk_TreeViewColumnNew()
        gtk_TreeViewColumnSetTitle(column1, "Строка 1")
        gtk_TreeViewColumnPackStart(column1, renderer, .t.)
        //gtk_TreeViewAppendColumn(view, column1)
        gtk_TreeViewInsertColumn(view, column1, 1)
        gtk_TreeViewColumnSetVisible(column1, .t.)

	gtk_TreeViewColumnSetSortColumnId(column1, 1)

        gtk_TreeViewColumnAddAttribute(column1, renderer, "text", 1)
        gtk_TreeViewColumnAddAttribute(column1, renderer, "editable", 2)

  	*** create toggle renderer
  	renderer = gtk_CellRendererToggleNew ()
        gtk_SignalConnect(renderer, "toggled", {|w, e| toggle(w, e, model)})


  	*** create column2
  	column2 = gtk_TreeViewColumnNew()
        gtk_TreeViewColumnSetTitle(column2, "bool")
        gtk_TreeViewColumnPackStart(column2, renderer, .t.)
        gtk_TreeViewAppendColumn(view, column2)
        gtk_TreeViewColumnAddAttribute(column2, renderer, "active", 2)

  	*** create next text cell
  	renderer = gtk_CellRendererTextNew ()
        gtk_SignalConnect(renderer, "edited", {|w, e| edited(w, e, model, 3)})


  	*** create column3
  	column3 = gtk_TreeViewColumnNew()
        gtk_TreeViewColumnSetTitle(column3, "А вот и число")
        gtk_TreeViewColumnPackStart(column3, renderer, .t.)
        gtk_TreeViewColumnAddAttribute(column3, renderer, "text", 3)
        gtk_TreeViewColumnAddAttribute(column3, renderer, "editable", 2)
	gtk_TreeViewInsertColumn(view, column3, -1)

  	*** create column4
  	column4 = gtk_TreeViewColumnNew()
        gtk_TreeViewColumnSetTitle(column4, "SYS date")
        gtk_TreeViewColumnPackStart(column4, renderer, .t.)
        gtk_TreeViewColumnAddAttribute(column4, renderer, "text", 4)
        gtk_TreeViewColumnAddAttribute(column4, renderer, "editable", 2)
	gtk_TreeViewInsertColumn(view, column4, -1)
****/

	gtk_SignalConnect(view, "cursor-changed", {|w, e| selectRow(w, e, model)})

	box := gtk_VBoxNew()
        sw := gtk_ScrolledWindowNew()
	gtk_ContainerAdd(sw, view)

	stbar := gtk_ToolbarNew()
        gtk_ToolbarAppendElement(stbar, GTK_TOOLBAR_CHILD_WIDGET, gtk_LabelNew(,"Click to column headers"))
        gtk_ToolbarAppendSpace(stbar)
        gtk_ToolbarAppendItem(stbar, " Append ","Append new item", NIL, , @AppendListItem())
        gtk_ToolbarAppendSpace(stbar)
        gtk_ToolbarAppendItem(stbar, " Prepend ","Prepend new item", NIL, , @PrependListItem())
        gtk_ToolbarAppendSpace(stbar)
        gtk_ToolbarAppendItem(stbar, " Delete ","Delete item from list", NIL, , @deleteListItem())


        gtk_BoxPackStart(box, sw, .t., .t.)
	gtk_BoxPackEnd(box, stbar)
	gtk_ContainerAdd(win, box)

	gtk_WidgetShowAll(win)
	gtk_SignalConnect(win, "delete-event", {|| gtk_Quit()})



/*****************************************************************************
*                            TREE STORE TEST                                 *
*****************************************************************************/

	twin = gtk_WindowNew(, " Test Tree Store ")

	gtk_WindowSetDefaultSize(twin, 280, 435)


        tree = gtk_TreeStoreNew(, 5, TREE_TYPE_STRING , TREE_TYPE_LOGICAL, TREE_TYPE_NUMERIC, TREE_TYPE_DATE, TREE_TYPE_STRING)

        for i=1 to 10
                path = gtk_TreeStoreAppend(tree, NIL, 1, "tree строка"+alltrim(str(i)), ;
                                          2, .t. , ;
                		          3, (111.0*i), ;
                                          4, date(), ;
                                          5, "red", ;
                		          -1)
        	for j=1 to 10
                	path1 = gtk_TreeStoreAppend(tree, path)
                	gtk_TreeStoreSetValue(tree, path1, 1, "iter"+path1)
        	next
        next
	tmodel = gtk_TreeModel(tree)
	tview = gtk_TreeViewNewWithModel(,tmodel)
  	gtk_TreeViewSetRulesHint (tview, .t.)
  	gtk_TreeViewSetHeadersVisible (tview, .t.)

  	*** create text cell
  	renderer = gtk_CellRendererTextNew ()
        gtk_SignalConnect(renderer, "edited", {|w, e| edited(w, e, tmodel, 1, .f.)})

  	*** insert new column to view
  	col1 = gtk_TreeViewInsertColumnWithAttributes(tview, -1, "Строка 1", renderer, ;
  		"text", 1, ;
  		"editable", 2)

        tcolumn1 = gtk_TreeViewGetColumn(tview, col1)
        gtk_TreeViewColumnSetSortColumnId(tcolumn1, col1)

  	*** create toggle cell
  	renderer = gtk_CellRendererToggleNew ()
        gtk_SignalConnect(renderer, "toggled", {|w, e| toggle(w, e, tmodel, .f.)})

  	gtk_TreeViewInsertColumnWithAttributes(tview, -1, "bool", renderer, ;
  		"active", 2, "radio", 2)


  	*** create next text cell
  	renderer = gtk_CellRendererTextNew ()
        gtk_SignalConnect(renderer, "edited", {|w, e| edited(w, e, tmodel, 3, .f.)})

  	col3 = gtk_TreeViewInsertColumnWithAttributes(tview, -1, "А вот и число", renderer, ;
  		"text", 3, "editable", 2)
        tcolumn3 = gtk_TreeViewGetColumn(tview, 3)
        gtk_TreeViewColumnSetSortColumnId(tcolumn3, 3)

  	*** create next text cell
  	renderer = gtk_CellRendererTextNew ()
        gtk_SignalConnect(renderer, "edited", {|w, e| edited(w, e, tmodel, 4, .f.)})

  	gtk_TreeViewInsertColumnWithAttributes(tview, -1, "Sys date", renderer, ;
  		"text", 4, "editable", 2)


	gtk_SignalConnect(tview, "cursor-changed", {|w, e| selectRow(w, e, tmodel)})

	tbox := gtk_VBoxNew()
        tsw := gtk_ScrolledWindowNew()
	gtk_ContainerAdd(tsw, tview)

	tstbar := gtk_ToolbarNew()
        gtk_ToolbarAppendElement(tstbar, GTK_TOOLBAR_CHILD_WIDGET, gtk_LabelNew(,"Click to column headers"))
        gtk_ToolbarAppendSpace(tstbar)
        gtk_ToolbarAppendItem(tstbar, " Append ","Append new item", NIL, , @AppendTreeItem())
        gtk_ToolbarAppendSpace(tstbar)
        gtk_ToolbarAppendItem(tstbar, " Delete ","Delete item from tree", NIL, , @deleteTreeItem())

        gtk_BoxPackStart(tbox, tsw, .t., .t.)
	gtk_BoxPackEnd(tbox, tstbar)
	gtk_ContainerAdd(twin, tbox)
	gtk_WidgetShowAll(twin)
	gtk_SignalConnect(twin, "delete-event", {|| gtk_Quit()})



	gtk_main()
return .t.

static function selectRow(wid, ev, data)

local model, value, iter, path, pathstr, log, num, dat

	model = GTK_TREEMODEL (data)

	selection := gtk_TreeViewGetSelection(wid)
        if selection != NIL .and. gtk_TreeSelectionGetSelected(selection, NIL, @iter)
        	path := gtk_TreeModelGetPath(model, iter)
        	pathstr := gtk_TreePathToString(path)
  	 	gtk_TreeModelGetFromPathString (model, pathstr, 1, @value, 2, @log, ;
  	 	3, @num, 4, @dat, -1)

        	? value, log, num, dat
	        ?
        	gtk_TreePathFree(path)
        endif
return .F.

static function toggle(wid, ev, data, isListStore)

local model, value

	model = GTK_TREEMODEL (data)
        isListStore := iif(isListStore == NIL, .t., isListStore)

  	gtk_TreeModelGetFromPathString (model, ev:PATHSTRING, 2, @value, -1)


	value = !value
  	if isListStore
  		gtk_ListStoreSetValue(model, ev:PATHSTRING, 2, value)
        else
  		gtk_TreeStoreSetValue(model, ev:PATHSTRING, 2, value)
        endif

return .F.


static function edited(wid, ev, data, num, isListStore)

local model, value

	model = GTK_TREEMODEL (data)
        isListStore := iif(isListStore == NIL, .t., isListStore)

  	if isListStore
  		gtk_ListStoreSetValue(model, ev:PATHSTRING, num, ev:NEWTEXT)
        else
  		gtk_TreeStoreSetValue(model, ev:PATHSTRING, num, ev:NEWTEXT)
        endif


return .F.

static function deleteListItem()
local selection, iter, path, pathstr
	selection := gtk_TreeViewGetSelection(view)
        if gtk_TreeSelectionGetSelected(selection, NIL, @iter)
        	path := gtk_TreeModelGetPath(list, iter)
        	pathstr := gtk_TreePathToString(path)
        	gtk_ListStoreRemove(list, pathstr)
        	gtk_TreePathFree(path)
        else
        	? "Please select row"
                ?
        endif
return

static function deleteTreeItem()
local selection, iter, path, pathstr
	selection := gtk_TreeViewGetSelection(tview)
        if gtk_TreeSelectionGetSelected(selection, NIL, @iter)
        	path := gtk_TreeModelGetPath(tree, iter)
        	pathstr := gtk_TreePathToString(path)
        	gtk_TreeStoreRemove(tree, pathstr)
        	gtk_TreePathFree(path)
        else
        	? "Please select row"
                ?
        endif
return

static function AppendTreeItem()
local path, path1, j
	path = gtk_TreeStoreAppend(tree, NIL, 1, "new item"+alltrim(time()), ;
                                          2, .t. , ;
                		          3, (0.0), ;
                                          4, date(), ;
                                          5, "red", ;
                		          -1)
        for j=1 to 10
               	path1 = gtk_TreeStoreAppend(tree, path)
               	gtk_TreeStoreSetValue(tree, path1, 1, "iter"+path1)
        next
return

static function AppendListItem()
local path
	path = gtk_ListStoreAppend(list,  1, "new item"+alltrim(time()), ;
                                          2, .t. , ;
                		          3, (0.0), ;
                                          4, date(), ;
                                          5, "red", ;
                		          -1)
return

static function PrependListItem()
local path
	path = gtk_ListStorePrepend(list,  1, "new item"+alltrim(time()), ;
                                          2, .t. , ;
                		          3, (0.0), ;
                                          4, date(), ;
                                          5, "red", ;
                		          -1)
	? path
        ?
return .f.


