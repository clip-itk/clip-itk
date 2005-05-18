#include <clip-gtk2.ch>
#include <gtk2-stock.ch>

#define TRUE	.T.
#define FALSE	.F.

#define FOLDER_NAME "gnome-fs-directory.png"
#define FILE_NAME "gnome-fs-regular.png"

#define  COL_PATH		1
#define  COL_DISPLAY_NAME	2
#define  COL_PIXBUF		3
#define  COL_IS_DIRECTORY	4

#define FA_NORMAL	0
#define FA_READONLY	1
#define FA_HIDDEN	2
#define FA_SYSTEM	4
#define FA_VOLUME	8
#define FA_DIRECTORY	16
#define FA_ARCHIVE	32


static file_pixbuf, folder_pixbuf

public up_button, parent

function Main()
local win, sw, vbox, icon_view, store, tool_bar, home_button, major, minor

	gtk_Init()

	gtk_Version(@major, @minor)
	if  (major < 2) .or. (minor < 6)
		gtk_ErrorMsgBox("For run this test you must install gtk2.0 version 2.6 or above",,"Gtk Version")
		return
	endif

	set translate path off

	win = gtk_WindowNew(, " Test Icon View widget ")

	gtk_WindowSetDefaultSize(win, 650, 400)

	file_pixbuf := gdk_PixbufNewFromFile(FILE_NAME)
	folder_pixbuf := gdk_PixbufNewFromFile(FOLDER_NAME)

	vbox := gtk_VBoxNew()
        gtk_ContainerAdd(win, vbox)

	tool_bar := gtk_ToolBarNew()
        gtk_BoxPackStart(vbox, tool_bar)

        up_button := gtk_ToolButtonNewFromStock(, GTK_STOCK_GO_UP)
        gtk_ToolItemSetIsImportant(up_button, TRUE)

	//gtk_WidgetSetSensitive (up_button, FALSE)
	gtk_ToolBarInsert (tool_bar, up_button, -1)

	home_button := gtk_ToolButtonNewFromStock (, GTK_STOCK_HOME)
	gtk_ToolItemSetIsImportant (home_button, TRUE)
	gtk_ToolbarInsert (tool_bar, home_button, -1)

	sw := gtk_ScrolledWindowNew ()
	gtk_ScrolledWindowSetShadowType (sw, GTK_SHADOW_ETCHED_IN)
	gtk_ScrolledWindowSetPolicy (sw, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)

	gtk_BoxPackStart (vbox, sw, TRUE, TRUE, 0)

	  /* Create the store and fill it with the contents of '/' */
	parent = ""

	store = create_store ()

	fill_store (store)

	icon_view = gtk_IconViewNewWithModel (,store)
	gtk_IconViewSetSelectionMode (icon_view, GTK_SELECTION_MULTIPLE)
	  /*g_object_unref (store);*/

	  /* Connect to the "clicked" signal of the "Up" tool button */
	gtk_SignalConnect (up_button, "clicked", {|w, e| up_clicked(w, e, store)})

	  /* Connect to the "clicked" signal of the "Home" tool button */
	gtk_SignalConnect (home_button, "clicked", {|w, e|home_clicked(w, e, store)});

	  /* We now set which model columns that correspont to the text
	   * and pixbuf of each item
	   */
	gtk_IconViewSetTextColumn (icon_view, COL_DISPLAY_NAME)
	gtk_IconViewSetPixbufColumn (icon_view, COL_PIXBUF)

	  /* Connect to the "item_activated" signal */
	gtk_SignalConnect (icon_view, "item-activated", {|w, e|item_activated(w, e, store)})
	gtk_ContainerAdd (sw, icon_view)

  	gtk_WidgetGrabFocus (icon_view)

	gtk_WidgetShowAll(win)

	gtk_SignalConnect(win, "delete-event", {|w| gtk_WidgetDestroy(w),gtk_Quit()})

	gtk_main()
return .t.


/******************************************/
static function create_store ()
local store

  	store := gtk_ListStoreNew (, 4, TREE_TYPE_STRING, TREE_TYPE_STRING, TREE_TYPE_PIXBUF, TREE_TYPE_LOGICAL)
//  	store := gtk_ListStoreNew (, 3, TREE_TYPE_STRING, TREE_TYPE_STRING,  TREE_TYPE_LOGICAL)

  /* Set sort column and function */
  	/*gtk_TreeSortableSetDefaultSortFunc (store, sort_func, NULL, NULL)*/
  	/*gtk_TreeSortableSetSortColumnID (store, ;
					GTK_TREE_SORTABLE_DEFAULT_SORT_COLUMN_ID, ;
					GTK_SORT_ASCENDING)*/

return store

static function fill_store (store)
local a, b, i, current
  	gtk_ListStoreClear (store)
	dirchange(parent)

	c := curdir()
	current := strtran(currdrive()+"/"+iif(empty(c), "", c+"/"), "//", "/")

	a := fileseek(current, FA_DIRECTORY)

	b := tSortedArrayNew()
	while !empty(a)
#ifdef OS_CYGWIN
		if a == ".."
			a := fileseek()
			loop
		endif
		if a == "."
			a := ".."
		endif
#else
		if a == "."
			a := fileseek()
			loop
		endif
#endif
		b:add(a+"/", a)
		a := fileseek()
    	enddo
    	path := curdir()
    	path := left(path, atr("/", path))
    	for i=1 to b:len()
    		gtk_ListStoreAppend (store, ;
			COL_PATH, path + b:getData(i), ;
			COL_DISPLAY_NAME, b:getData(i), ;
			COL_IS_DIRECTORY, TRUE,	;
			COL_PIXBUF, folder_pixbuf, ;
			-1)
    	next

    	b = tSortedArrayNew()
    	a = fileseek(current, FA_ARCHIVE+FA_VOLUME+FA_SYSTEM+FA_HIDDEN+FA_READONLY)
    	while !empty(a)
		b:add(a, a)
		a = fileseek()
    	enddo
    	for i=1 to b:len()
    		gtk_ListStoreAppend (store, ;
			COL_PATH, path + b:getData(i), ;
			COL_DISPLAY_NAME, b:getData(i), ;
			COL_IS_DIRECTORY, FALSE,	;
			COL_PIXBUF, file_pixbuf, ;
			-1)
    	next
return

static function item_activated (icon_view, event, store)
local path, is_dir

  	pathstr := gtk_TreePathToString(event:TREEPATH)
  	gtk_TreeModelGetFromPathString (store, pathstr,;
		      COL_DISPLAY_NAME, @path, ;
		      COL_IS_DIRECTORY, @is_dir, ;
		      -1)

  	if !is_dir
      		return
    	endif

  /* Replace parent with path and re-fill the model*/
  	parent = path

  	fill_store (store)

return


static function up_clicked (item, event, store)

  parent = "../"

  fill_store (store)

return

static function home_clicked (item, event, store)

  parent := getenv("HOME")
  fill_store (store)

return
