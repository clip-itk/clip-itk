#include <clip-gtk2.ch>

function main()
local window, buffer, view, vbox, sw, e, s
	gtk_init()
	window = gtk_WindowNew(, " Test List Store Object ")
	gtk_WidgetSetSizeRequest( window, 300, 300 )
	gtk_WindowSetPosition( window, GTK_WIN_POS_CENTER)
	gtk_SignalConnectAfter( window, "delete-event", {|| gtk_quit() } )
        vbox := gtk_VboxNew()
	gtk_BoxSetSpacing(vbox, 5)

        gtk_ContainerAdd(window, vbox)

	columns := {"First", "Second"}
	types := {TREE_TYPE_STRING, TREE_TYPE_NUMERIC}

	cc := len(columns)
	store := gtk_ListStoreNew(, cc, types )

	model := gtk_TreeModel(store)
	o  := gtk_TreeViewNewWithModel(,model)
	o:store := store
  	gtk_TreeViewSetRulesHint (o, .t.)
  	gtk_TreeViewSetHeadersVisible (o, .t.)


	// Append columns
	for i:=1 to cc
		//c := gtk_TreeViewColumnNewWithAttributes(,columns[i],renderer, "text", i)
		c := gtk_TreeViewColumnNew()
		gtk_TreeViewColumnSetTitle(c, columns[i])
		gtk_TreeViewColumnSetResizable(c, .T.)
		gtk_TreeViewAppendColumn(o, c)
  		renderer = gtk_CellRendererTextNew ()
		gtk_TreeViewColumnPackStart(c, renderer, .f.)
		gtk_TreeViewColumnAddAttribute(c, renderer, "text", i)
	next
	// Insert rows...
	data := {"f", 55.0}
	// Set values
	row := gtk_ListStoreAppend(store)
	for i:=1 to len(data)
		gtk_ListStoreSetValue(store, row, i, data[i])
	next

	row2 := gtk_ListStoreAppend(store,1,"f2", 2, -1)
	row3 := gtk_ListStoreAppend(store)
	gtk_ListStoreSet(store, row3, 1, "f3", 2, 57)



	gtk_BoxPackStart(vbox,o,.T.,.T.)

	gtk_WidgetShowAll(window)
	gtk_main()
return .t.
