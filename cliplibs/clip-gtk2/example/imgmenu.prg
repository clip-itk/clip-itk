#include <clip-gtk2.ch>
#include <gtk2-stock.ch>
function main()
local mask, tb

gtk_init()
win := gtk_windowNew(, "Test Image Menu item")
qout()
gtk_WindowSetPosition(win, GTK_WIN_POS_CENTER)
gtk_WindowSetDefaultSize(win, 300, 200)
gtk_signalConnect(win, "delete-event", {|w| gtk_WidgetDestroy(win), gtk_quit()})

vbox := gtk_vboxNew()

menu := gtk_MenuBarNew()

pic := gtk_ImageNewFromFile(, "x.xpm")
m1 := gtk_ImageMenuItemNewWithLabel(, "MenuWithLabel")
gtk_ImageMenuItemSetImage(m1, pic)
gtk_SignalConnect(m1, "activate", {|| qout("Clicked MenuWithLabel")})

pic1 = gtk_ImageNewFromFile(, "gnome-foot.xpm")
m2 := gtk_ImageMenuItemNewWithMnemonic(, "MenuWith_Mnemonic")
gtk_ImageMenuItemSetImage(m2, pic1)
gtk_SignalConnect(m2, "activate", {|| qout("Clicked MenuWith_Mnemonic")})

m3 := gtk_ImageMenuItemNewFromStock(, GTK_STOCK_CLOSE, NIL)
gtk_SignalConnect(m3, "activate", {|| qout("Clicked GTK_STOCK_CLOSE")})

gtk_MenuBarAppend( menu, m1 )
gtk_MenuBarAppend( menu, m2 )
gtk_MenuBarAppend( menu, m3 )

gtk_BoxPackstart(vBox, menu)
gtk_containerAdd(win, vBox)


gtk_WidgetShowAll(win)

gtk_main()
return





