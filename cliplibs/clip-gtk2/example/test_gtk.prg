function Main()

gtk_Init()

window := gtk_WindowNew(,"test")

vbox := gtk_VBoxNew()
gtk_ContainerAdd( window, vbox )


menu := gtk_MenuBarNew()
popup := gtk_MenuNew()

o := gtk_MenuItemNew( , "&File", "&" )
oo := gtk_MenuItemNew( , "&Help", "&" )


o1 := gtk_MenuItemNew( , "&Open", "&" )
o2 := gtk_MenuItemNew()
o3 := gtk_MenuItemNew( , "E&xit", "&" )
gtk_SignalConnect(o3, "activate", {|| gtk_Quit()})

gtk_MenuAppend( popup, o1 )
gtk_MenuAppend( popup, o2 )
gtk_MenuAppend( popup, o3 )

gtk_MenuItemSetSubmenu(o, popup)
gtk_MenuBarAppend( menu, o )
gtk_MenuBarAppend( menu, oo )

gtk_BoxPackStart( vbox, menu )


tb := gtk_ToolBarNew()
pic := gdk_PixmapFromXPMNew(, "x.xpm")
pic1 = gdk_PixmapFromXPMNew(, "x.xpm")
gtk_ToolBarAppendItem(tb,NIL, "Button 1", NIL, pic, @action())
gtk_ToolBarAppendItem(tb,NIL, "Button 2", NIL, pic1, @action())

gtk_BoxPackStart( vbox, tb )


gtk_SignalConnect( window, "delete-event", {|wid,e|gtk_Quit()} )
gtk_WidgetShowAll( window )

gtk_Main()
return

static function action()
    ? "Button clicked!"
return 0

