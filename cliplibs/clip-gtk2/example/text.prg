#include <clip-gtk2.ch>

function main()
local window, buffer, view, layout, bins
	gtk_init()
	window = gtk_WindowNew(, " Test Text ")

	gtk_WindowSetDefaultSize(window, 400, 300)

        /* create menu */
        accel := gtk_AccelGroupNew()
        ifactory := gtk_ItemFactoryNew(CLIP_GTK_TYPE_MENU_BAR, "<main>", accel)

        imenu := { ;
  	{ "/_File",            NIL,         0,           0, "<Branch>" }, ;
  	{ "/File/_New",        "<control>N", {|w,e|do_new(w,e)},      0, NIL }, ;
  	{ "/File/New _View",   NIL,         @do_new_view(), 0, NIL }, ;
  	{ "/_Edit", NIL, 0, 0, "<Branch>" }, ;
  	{ "/Edit/Find...", NIL, {||qout("do_search")}, 0, NIL }, ;
  	{ "/_Settings", NIL, 0, 0, "<Branch>" }, ;
  	{ "/Settings/Wrap _Off", NIL, {|| qout("do_wrap_changed")},  GTK_WRAP_NONE, "<RadioItem>" }, ;
  	{ "/Settings/Wrap _Words", NIL, {|| qout("do_wrap_changed")},  GTK_WRAP_WORD, "/Settings/Wrap Off" }, ;
  	{ "/Settings/Wrap _Chars", NIL, {|| qout("do_wrap_changed")},  GTK_WRAP_CHAR, "/Settings/Wrap Off" }, ;
  	{ "/Settings/sep1", NIL, 0, 0, "<Separator>" }, ;
  	{ "/Settings/Editable", NIL, {||qout("do_editable_changed")},  1, "<RadioItem>" }, ;
  	{ "/Settings/Not editable", NIL, {||qout("do_editable_changed")},  0, "/Settings/Editable" }, ;
  	{ "/Settings/sep1", NIL,0, 0, "<Separator>" }, ;
  	{ "/Settings/Cursor visible",    NIL, {||qout("do_cursor_visible_changed")},  1, "<RadioItem>" }, ;
  	{ "/Settings/Cursor not visible", NIL, {||qout("do_cursor_visible_changed")}, 0, "/Settings/Cursor visible" }, ;
  	{ "/Settings/sep1", NIL, 0, 0, "<Separator>" } ;
        }
        gtk_ItemFactoryCreateItems(ifactory, imenu, window)


        /* * то же самое, но поэлементно добавляет
        gtk_ItemFactoryCreateItem(ifactory, ;
        	{ "/_File",    NIL,          0,                 0,"<Branch>" }, 1)
        gtk_ItemFactoryCreateItem(ifactory, ;
  		{ "/File/_New","<control>N", {|w,e|do_new(w,e)},0, NIL }, 1)
        gtk_ItemFactoryCreateItem(ifactory, ;
	  	{ "/File/New _View",   NIL, @do_new_view(), 0, NIL }, 1)
        */
  	/* добавить accel_group в объект window */
  	gtk_WindowAddAccelGroup (window, accel)

        vbox := gtk_vboxNew()
        layout := gtk_LayoutNew()
        gtk_ContainerAdd(window, vbox)
        gtk_BoxPackStart(vbox, gtk_ItemFactoryGetWidget(ifactory, "<main>"))
        gtk_BoxPackEnd(vbox, layout, .t., .t.)

        buffer = create_buffer()
	view := gtk_TextViewNewWithBuffer( , buffer:buffer )
	gtk_TextViewSetWrapMode (view, GTK_WRAP_WORD)
        gtk_WidgetSetSizeRequest(view, 300, 50)

        gtk_LayoutPut(layout, view, 10, 10)

	bins := gtk_ButtonNewWithMnemonic(, "_Ins editable string")
        gtk_SignalConnect(bins, "clicked", {|| InsertEditable(view, buffer)})

	binsNot := gtk_ButtonNewWithMnemonic(, "Ins _not editable string")
        gtk_SignalConnect(binsNot, "clicked", {|| InsertNotEditable(view, buffer)})

        gtk_LayoutPut(layout, bins, 10, 70)
        gtk_LayoutPut(layout, binsNot, 150, 70)

	gtk_SignalConnect(window, "delete-event", {|| gtk_Quit()})
        gtk_WidgetShowAll(window)
        gtk_main()

return .t.

***************************************
static function create_buffer()
local buffer, tabs, i
local tag

	buffer := map()
	buffer:buffer = gtk_TextBufferNew ()

	buffer:refcount = 1
	buffer:filename = NIL
	buffer:untitled_serial = -1

	buffer:color_tags = NIL
	buffer:color_cycle_timeout = 0
	buffer:start_hue = 0.0

	i = 0

  	buffer:not_editable_tag = ;
    		gtk_TextBufferCreateTag (buffer:buffer, NIL, ;
                                "editable", .f., ;
                                "foreground", "purple", NIL)

  	buffer:found_text_tag = gtk_TextBufferCreateTag (buffer:buffer, NIL, ;
                                "foreground", "red", NIL)

return buffer
***********************************************
static function insertNotEditable(view, buffer)
local str, textiter
	str := time() + " " + dtoc(date())

        gtk_TextBufferGetIterAtMark (buffer:buffer, @textiter,;
                                             gtk_TextBufferGetMark (buffer:buffer,  ;
                                             "insert"))
        gtk_TextBufferInsertWithTags(buffer:buffer, textIter, str, len(str), buffer:not_editable_tag)
        gtk_WidgetSetFocus(view)
return .f.
***********************************************
static function insertEditable(view, buffer)
local str
	str := time() + " " + dtoc(date())
        gtk_TextBufferInsertAtCursor(buffer:buffer, str, len(str))

        gtk_WidgetSetFocus(view)
return .f.
***********************************************
static function do_new(w, e)
	? "do_new"
        ? gtk_WidgetGetTypeName(w)
        ?
return .f.
*********************************************
static function do_new_view(w, e)
	? "do_new_view"
        ? gtk_WidgetGetTypeName(w)
        ?
return .f.
