#include <clip-gtk2.ch>

function main()
local window, label, vbox
	gtk_init()
	window = gtk_WindowNew(, " Test Resources ")

	gtk_WindowSetDefaultSize(window, 400, 300)


        gtk_RCParseString('style "my-label-style" { '       + ;
                          '   fg[NORMAL] = "#ff0000"&\n'    + ;
                          '   font_name = "Sans 18"&\n'     + ;
                          '}&\n'                            + ;
                          'widget "*.mystyle" style "my-label-style"')


        gtk_RCParseString('style "my-2-style" { '       + ;
                          '   fg[NORMAL] = "#ff0000"&\n'    + ;
                          '   fg[ACTIVE] = "#00ff00"&\n'    + ;
                          '   fg[PRELIGHT] = "#0000ff"&\n'  + ;
                          '   bg[NORMAL] = "#990000"&\n'    + ;
                          '   bg[ACTIVE] = "#009900"&\n'    + ;
                          '   bg[PRELIGHT] = "#000099"&\n'  + ;
                          '   text[NORMAL] = "#aaaaaa"&\n'  + ;
                          '   base[NORMAL] = "#aaaaaa"&\n'  + ;
                          '   font_name = "Sans 18"&\n'     + ;
                          '}&\n'                            + ;
                          'widget_class "*GtkButton*" style "my-2-style"')

        gtk_RCParseString('pixmap_path "//home/alena/cliplibs/clip-gtk2/example/"&\n' + ;
        		  'style "my-entry-style" { '       + ;
                          '   bg[NORMAL] = "#0000ff"&\n'    + ;
                          '   base[NORMAL] = "#0000ff"&\n'    + ;
                          '   text[NORMAL] = "#ff0000"&\n'    + ;
                          '   bg_pixmap[NORMAL] = "x.xpm"&\n'    + ;
                          '   font_name = "Sans 18"&\n'     + ;
                          '}&\n'                            + ;
                          'widget_class "*GtkEntry*" style "my-entry-style"')

	vbox := gtk_VBoxNew()
        gtk_ContainerAdd(window, vbox)

	label := gtk_LabelNew(, 'Label with style "my-label-style"')
        gtk_BoxPackStart(vbox, label)
        gtk_WidgetSetName(label, "mystyle")

	button := gtk_ButtonNew(, 'Button with style "my-2-style"')
        gtk_BoxPackStart(vbox, button)
        gtk_WidgetSetName(button, "mystyle")

	entry := gtk_EntryNew()
        gtk_EntrySetText(entry, 'Entry with style "my-entry-style"')
        gtk_WidgetSetName(entry, "my-entry-style")
        gtk_BoxPackStart(vbox, entry)

	gtk_SignalConnect(window, "delete-event", {|| gtk_Quit()})
        gtk_WidgetShowAll(window)
        gtk_main()

return .t.

