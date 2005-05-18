#include <gtk2-stock.ch>

function Main()
gtk_Init()

window := gtk_WindowNew(,"test")

vbox := gtk_VBoxNew()
gtk_ContainerAdd( window, vbox )


hb := {}
/*
stock :={{GTK_STOCK_DIALOG_INFO,GTK_STOCK_DIALOG_WARNING,GTK_STOCK_DIALOG_ERROR,GTK_STOCK_DIALOG_QUESTION ,GTK_STOCK_DND},;
         {GTK_STOCK_DND_MULTIPLE,GTK_STOCK_ADD,GTK_STOCK_APPLY,GTK_STOCK_BOLD,GTK_STOCK_CANCEL},;
         {GTK_STOCK_CDROM,GTK_STOCK_CLEAR,GTK_STOCK_CLOSE,GTK_STOCK_CONVERT,GTK_STOCK_COPY},;
         {GTK_STOCK_CUT,GTK_STOCK_DELETE,GTK_STOCK_EXECUTE,GTK_STOCK_FIND,GTK_STOCK_FIND_AND_REPLACE },;
	 {GTK_STOCK_FLOPPY,GTK_STOCK_GOTO_BOTTOM,GTK_STOCK_GOTO_FIRST,GTK_STOCK_GOTO_LAST,GTK_STOCK_GOTO_TOP},;
	 {GTK_STOCK_GO_BACK,GTK_STOCK_GO_DOWN,GTK_STOCK_GO_FORWARD,GTK_STOCK_GO_UP,GTK_STOCK_HELP},;
         {GTK_STOCK_HOME,GTK_STOCK_INDEX,GTK_STOCK_ITALIC,GTK_STOCK_JUMP_TO,GTK_STOCK_JUSTIFY_CENTER},;
         {GTK_STOCK_JUSTIFY_FILL,GTK_STOCK_JUSTIFY_LEFT,GTK_STOCK_JUSTIFY_RIGHT,GTK_STOCK_MISSING_IMAGE,GTK_STOCK_NEW},;
         {GTK_STOCK_NO,GTK_STOCK_OK,GTK_STOCK_OPEN,GTK_STOCK_PASTE,GTK_STOCK_PREFERENCES},;
         {GTK_STOCK_PRINT,GTK_STOCK_PRINT_PREVIEW,GTK_STOCK_PROPERTIES,GTK_STOCK_QUIT,GTK_STOCK_REDO},;
         {GTK_STOCK_REFRESH,GTK_STOCK_REMOVE,GTK_STOCK_REVERT_TO_SAVED,GTK_STOCK_SAVE,GTK_STOCK_SAVE_AS},;
         {GTK_STOCK_SELECT_COLOR,GTK_STOCK_SELECT_FONT,GTK_STOCK_SORT_ASCENDING,GTK_STOCK_SORT_DESCENDING,GTK_STOCK_SPELL_CHECK},;
         {GTK_STOCK_STOP,GTK_STOCK_STRIKETHROUGH,GTK_STOCK_UNDELETE,GTK_STOCK_UNDERLINE,GTK_STOCK_UNDO},;
         {GTK_STOCK_YES,GTK_STOCK_ZOOM_100,GTK_STOCK_ZOOM_FIT,GTK_STOCK_ZOOM_IN,GTK_STOCK_ZOOM_OUT}}

*/

stock := gtk_StockListIDs()

btn := {}
k := 1
i := 1
do while k<= len(stock)

	aadd(hb, gtk_HBoxNew())
        aadd(btn, {})

	for j=1 to 5
                if k>len(stock)
                	exit
                endif
        	aadd(btn[i], gtk_ButtonNewFromStock(, stock[k]))
                gtk_SignalConnect(btn[i][j], "clicked", {|wid,ev| action(wid)})
        	gtk_BoxPackStart(hb[i], btn[i][j])
                k++
	next
	gtk_BoxPackStart( vbox, hb[i] )
        i++

enddo

gtk_SignalConnect( window, "delete-event", {|wid,e|gtk_Quit()} )
gtk_WidgetShowAll( window )

gtk_Main()
return

static function action(button)
    ? "Clicked "+ gtk_buttonGetLabel(button)
return .f.
