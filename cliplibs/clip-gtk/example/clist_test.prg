#include <clip-gtk.ch>
#include <inkey.ch>
	#define D_MSG(t)        qout(t)

static hb, uTmp1 := 'no1', uTmp2 := 'no2', st, nEntry_ := {0,0}, uEntry_ := {0,0}, bEntry_ := {.F.,.F.}, sEntry_ := {"Enter a access code","Enter a parol"}, ;
coun := 3

function main()
	local aTmp := {}, ;
	w,  ;	// pointer to WINDOW widget (main application window)
	f,  ;	//
	vb,  ;	//
	sw,  ;	//
	qbtn, en

DO WHILE .T.
	/* Initialize GTK+ system */
	gtk_init()

	/* Create main window */
	/***************************************************/
	w:= gtk_WindowNew(,"main application window")
	gtk_SignalConnect(w,"delete-event",{|wid,e|gtk_Quit()})

	/* Create vertical box container */
	vb:= gtk_VBoxNew()
	gtk_ContainerAdd (w, vb)

	// CList
	/***************************************************/
	D_MSG("Create frame for CList")
	CLFrame:=gtk_FrameNew(,"CList")
*	gtk_BoxPackStart(vb,CLFrame,.T.,.T.,2)
*	CLFx:=gtk_FixedNew()

	D_MSG("Scrolled window for clist")
	clscr:=gtk_ScrolledWindowNew()
	gtk_WidgetSetSize(clscr, 300, 400)
*	gtk_FixedPut(CLFx,clscr)
	gtk_ContainerAdd(CLFrame,clscr)
		gtk_BoxPackStart(vb,CLFrame,.T.,.T.,2)
// in fact, when asked about the hierarchy, had in mind the need of any
// "intermediate layers" to display graphical information.
// in this example (taken from clipgtktest) threw all of the above-mentioned
// by asterisk and program isn't crashed. I'm on the eye from noticing the 
// changes in her behavior.

//RE: Layers - give to programmer for review. All depends, in any form or manner
// you want to see those or other widgets: vertical, horizontal or strictly in
// the specified location... That is based on the final form and have to use
// different containers

// second question is that if such construction does not apply automatically
// sizing the window containing the Clist. Without discarding commented
// fragments clist window was generally small. In this case a program can
// determine the horizontal dimension, as it seems to me the size of the buttons.
// And vertical allocate only one row. I guess, I have not removed all
// unnecessary:) ; or program is stupid - programmer is cool; or is still unknown
// to me a method or property(?).

//RE: Here, I think, a program to determine the width of one single widget with
// a specific size. This statusBar, All other widgets - containers that are
// larger flies and depends on what's inside. And since the window size is not
// specified, then the program has established minimum from her point of view.
// For each widget, highlighting the height as long as necessary for the minimum
// information content. If you want to see this example shows the entire list,
// then You can remove intermediate window 'scrolledwindow', or specify the size
// of the main window 'w' or scrollable window 'clscr'.

	D_MSG("Create clist widget")
	clist:= gtk_CListNew(,3,{"Column1","Column2","Column3"})
	gtk_ContainerAdd (clscr, clist)
	//gtk_BoxPackStart(vb, clist, .t., .t.,2)
	gtk_CListColumnTitlesShow(clist)
	gtk_CListSetReorderable(clist, .t.)
	gtk_CListSetUseDragIcons(clist, .t.)
	gtk_CListSetSelectionMode(clist, GTK_SELECTION_EXTENDED)

	gtk_CListSetColumnTitle(clist,1,"Column1")
	gtk_CListSetColumnTitle(clist,2,"Column2")
	gtk_CListSetColumnTitle(clist,3,"Column3")

	gtk_CListSetColumnAutoResize(clist,2,.t.)
  FOR nTmp = 1 TO 10
	gtk_ClistAppend(clist,{'field 1 string '+ntoc(nTmp),'field 2 string '+ntoc(nTmp),'field 3 string '+ntoc(nTmp)})
  NEXT

	hb2 := gtk_HBoxNew()
	gtk_BoxPackStart(vb,hb2,.T.,.T.,2)

	bn2 :=gtk_ButtonNew(,"Cancel")
	gtk_SignalConnect(bn2,GTK_CLICKED_SIGNAL,{||gtk_Quit()})
	gtk_BoxPackStart(hb2,bn2,.T.,.T.,2)

	st := gtk_StatusBarNew()
	gtk_BoxPackEnd(vb,st,.F.,.F.)
	gtk_StatusBarSetText(st,"Enter a access code and parol")

	/* Show main window */
	/***************************************************/
	gtk_WidgetShowAll( w )

	/* Do GTK+ events */
	gtk_main()
  EXIT
ENDDO
return
