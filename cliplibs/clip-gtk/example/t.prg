#include <clip-gtk.ch>

//#define DEBUG

#ifdef DEBUG
	#define D_MSG(t)        qout(t)
#else
	#define D_MSG(t)
#endif


function Main()
	local w, vb, hb, sw, f, tt
	local menubar, menu1i, menu1, item1, save_item, item2, en3, item3, item4, item5
	local rmg, radioitem1, radioitem2, radioitem3, checkitem1, tearoffitem1
	local menu2i, menu2, hitem, menubar2
	local BFrame, BFx, rg, en, trbtn
	local EFrame, EFx, en2, cb
	local TFrame, TFx, vscr, text, txt, edbtn, wwbtn
	local DFrame, DFx, dialog, dbtn, btn6, btn10, btn11
	local MFrame, MFx, check1, opt_menu, optmenu, focbtn, cal
	local CLFrame, CLFx, clscr, clist
	local CTFrame, CTFx, ctree, node1, node2, node3, node4, ctscr
	local PBFrame, PBFx, qbtn
	local PxmFrame, PxmFx, pix, bmppix

	gtk_Init()


	// Create main window
	/***************************************************/
	D_MSG("Create window")
	w:= gtk_WindowNew(,"CLIP-GTK test")
	gtk_WidgetSetPosition(w,50,50)
	gtk_WidgetSetSize(w,300,300)
	gtk_WindowSetPolicy(w,.f.,.t.,.t.)
	gtk_ContainerSetBorderWidth(w,0)
	gtk_ContainerSetResizeMode(w, GTK_RESIZE_QUEUE)
	gtk_SignalConnect(w,"delete-event",{|wid,e|qout("delete-event")})
	gtk_SignalConnect(w,"delete-event",{|wid,e|gtk_WidgetDestroy(w),gtk_Quit()})


	// CList
	/***************************************************/
	D_MSG("Create frame for CList")

	D_MSG("Scrolled window for clist")
	clscr:=gtk_ScrolledWindowNew()
	gtk_WidgetSetSize(clscr, 300,200)
	gtk_ContainerAdd(w,clscr)

	D_MSG("Create clist widget")
	clist:= gtk_CListNew(,3,{"Column1","Column2","Column3"})
	gtk_ContainerAdd (clscr, clist)
	gtk_CListColumnTitlesShow(clist)
	gtk_CListSetReorderable(clist, .t.)
	gtk_CListSetUseDragIcons(clist, .t.)
	gtk_CListSetSelectionMode(clist, GTK_SELECTION_EXTENDED)

	gtk_CListSetColumnTitle(clist,1,"Column1")
	gtk_CListSetColumnTitle(clist,2,"Column2")
	gtk_CListSetColumnTitle(clist,3,"Column3")

	gtk_CListSetColumnAutoResize(clist,2,.t.)
	gtk_ClistAppend(clist,{"1","2","3"})
	gtk_ClistAppend(clist,{"2","2","3"})
	gtk_ClistAppend(clist,{"3","2","3"})
	gtk_ClistAppend(clist,{"4","2","3"})
	gtk_ClistAppend(clist,{"5","2","3"})
	gtk_ClistAppend(clist,{"6","2","3"})
	gtk_ClistAppend(clist,{"7","2","3"})
	gtk_ClistAppend(clist,{"8","2","3"})
	gtk_ClistAppend(clist,{"9","2","3"})
	gtk_ClistAppend(clist,{"10","2","3"})
	gtk_ClistAppend(clist,{"11","2","3"})
	gtk_ClistAppend(clist,{"12","2","3"})
	gtk_ClistAppend(clist,{"13","2","3"})
	gtk_ClistAppend(clist,{"14","2","3"})
	gtk_ClistAppend(clist,{"15","2","3"})
	gtk_ClistAppend(clist,{"16","2","3"})
	gtk_ClistPrepend(clist,{"17","2","3"})
	gtk_ClistInsert(clist,8,{"20","2","3"})

	gtk_CListSetForeground(clist, 3, ColorNew(65535))
	gtk_CListSetBackground(clist, 3, ColorNew(,65535))


	// Show main window
	/***************************************************/
	D_MSG("Show main window")
	gtk_WidgetShowAll( w )
	gtk_WindowSetIconName(w, "G U I   t e s t");

	gtk_Main()
return


////////////////////////////////////////////////////
//////// Color class definition ////////////////////
////////////////////////////////////////////////////

function ColorNew(r, g, b, op)
  local obj := map()

  r  = iif(r ==nil,0,r)
  g  = iif(g ==nil,0,g)
  b  = iif(b ==nil,0,b)
  op = iif(op==nil,65535,op)

  obj:Red = r
  obj:Green = g
  obj:Blue = b
  obj:Opacity = op
return obj

////////////////////////////////////////////////////










