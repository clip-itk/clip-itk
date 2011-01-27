#include <clip-gtk2.ch>
//#include <tbrow.xpm>


function main()
local window, browse

clear screen

set translate path off

//base = fileDialog()
base = "C:/home/alena/prg/bdbfs/test.dbf"
if !empty(base)
	USE &base
endif

//browse(1,1, maxRow(), maxCol())

//columns := {"FIRST", "LAST", "AGE", "MARRIED"}
//headers := {"Имя", "Фамилия", "Возраст", "Семейное положение" }
columns := {"FIRST", "LAST", "CITY", "STATE", "STREET", "AGE", "MARRIED" }
//defHeaders := {"Имя", "Фамилия", "Улица", "Город", "Штат", "Zip", "Hiredate", "Семейное положение", "Возраст", "Жалование", "Заметки"}
headers := {"First name", "Last name", "City", , "Street", "Age", "Marital status" }

gtk_Init()
window := gtk_WindowNew(, "sdfsdf")//, alias())
gtk_SignalConnect(window, "delete-event", {|w| gtk_WidgetDestroy(w), gtk_Quit()})
gtk_WindowSetDefaultSize(window, 800, 600)


sw := gtk_ScrolledWindowNew()

browse := gtk_BrowseNew(, columns, headers)

gtk_ContainerAdd(sw, browse)
gtk_ContainerAdd(window, sw)


gtk_WidgetShowAll(window)

rect := gtk_TreeViewGetVisibleRect(browse)
? "4 x:", rect:X, "y:", rect:Y, "width:", rect:WIDTH, "height:", rect:HEIGHT


?

gtk_Main()

return
