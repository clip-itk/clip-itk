#include <clip-gtk2.ch>

function main()
local window, buffer, view, layout, bins
	gtk_init()
	window = gtk_WindowNew(, " Test item factory ")

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
	{ "/Settings/Wrap _Off", NIL, {|| qout("do_wrap_changed")},  0, "<RadioItem>" }, ;
	{ "/Settings/Wrap _Words", NIL, {|| qout("do_wrap_changed")},  2, "/Settings/Wrap Off" }, ;
	{ "/Settings/Wrap _Chars", NIL, {|| qout("do_wrap_changed")},  1, "/Settings/Wrap Off" }, ;
	{ "/Settings/sep1", NIL, 0, 0, "<Separator>" }, ;
	{ "/Settings/Editable", NIL, {||qout("do_editable_changed")},  1, "<RadioItem>" }, ;
	{ "/Settings/Not editable", NIL, {||qout("do_editable_changed")},  0, "/Settings/Editable" }, ;
	{ "/Settings/sep1", NIL,0, 0, "<Separator>" }, ;
	{ "/Settings/Cursor visible",    NIL, {||qout("do_cursor_visible_changed")},  1, "<RadioItem>" }, ;
	{ "/Settings/Cursor not visible", NIL, {||qout("do_cursor_visible_changed")}, 0, "/Settings/Cursor visible" }, ;
	{ "/Settings/sep1", NIL, 0, 0, "<Separator>" } ;
	}
	gtk_ItemFactoryCreateItems(ifactory, imenu, window)


	/* добавить accel_group в объект window */
	gtk_WindowAddAccelGroup (window, accel)

	vbox := gtk_vboxNew()
	layout := gtk_LayoutNew()
	gtk_ContainerAdd(window, vbox)
	gtk_BoxPackStart(vbox, gtk_ItemFactoryGetWidget(ifactory, "<main>"))
	gtk_BoxPackEnd(vbox, layout, .t., .t.)

	gtk_SignalConnect(window, "delete-event", {|| gtk_Quit()})
	gtk_WidgetShowAll(window)
	gtk_main()

return .t.

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
