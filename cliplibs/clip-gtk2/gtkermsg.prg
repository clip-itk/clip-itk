/*
    Copyright (C) 2003-2004  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "clip-gtk2.ch"

function gtk_ErrorMsgBox(cMsg, aButton, cTitle, activeWnd)
local nWidth, nHeight
local Button, Label
local Dialog, inFocus, i, ret:=.f., pos, str, ames
local BtnWidth:=40, BtnHeight:=25, hbox, vbox

/* XPM stop */
static stopXPM := { ;
"26 26 16 1",	;
"  c Gray0",    ;
". c #bf0000",  ;
"X c #00bf00",  ;
"o c #bfbf00",  ;
"O c #0000bf",  ;
"+ c #bf00bf",  ;
"@ c #00bfbf",  ;
"# c Transparent",  ;
"$ c #808080",  ;
"% c Red",      ;
"& c Green",    ;
"* c Yellow",   ;
"= c Blue",     ;
"- c Magenta",  ;
"; c Cyan",     ;
": c Gray100",  ;
"##########################",;
"##########################",;
"##########################",;
"##########:::::###########",;
"########::%%%%%::#########",;
"######::%%%%%%%%%@########",;
"#####:#%%%%%%%%%%%%#######",;
"#####:%%%%%%%%%%%%%$######",;
"####:%%%%%%%%%%%%%%%$#####",;
"####:%%%%%%%%%%%%%%%$#####",;
"###:%%%%%%%%%%%%%%%%%$####",;
"###:%%%:::::::::::%%%$####",;
"###:%%%:::::::::::%%%$####",;
"###:%%%:::::::::::%%%$####",;
"###:%%%%%%%%%%%%%%%%%$####",;
"####:%%%%%%%%%%%%%%%$#####",;
"####:%%%%%%%%%%%%%%%$#####",;
"#####@%%%%%%%%%%%%%$######",;
"######%%%%%%%%%%%%%@######",;
"#######$%%%%%%%%%$@#######",;
"########$$%%%%%$$#########",;
"##########$$$$$###########",;
"##########################",;
"##########################",;
"##########################",;
"##########################" ;
}

	Dialog := gtk_DialogNew(, cTitle)

	gtk_SignalConnect(Dialog, GTK_DELETE, {|| gtk_WidgetHideOnDelete(Dialog)})
	gtk_SignalConnect(Dialog, GTK_HIDE_SIGNAL, {|| gtk_WidgetDestroy(Dialog), gtk_Quit()})

	gtk_WindowSetModal(Dialog, .t.)
	gtk_WindowSetPosition(Dialog, GTK_WIN_POS_CENTER)

	gtk_ContainerSetBorderWidth(Dialog:VBox, 5)
	hbox := gtk_HBoxNew()
	gtk_ContainerSetBorderWidth(hBox, 10)
	vbox := gtk_VBoxNew()

//	if aReturn != NIL .and. !empty(aReturn)
//		ret := iif(valtype(aReturn[1])=="N", 0, .f.)
//	endif

	gtk_BoxPackStart(hbox, gdk_PixmapCreateFromXPMd(, stopXPM))

	/*
	pos := at(';',cMsg)

	if pos==0; pos := len(cMsg)+1; endif
	do while pos > 0
		str := left(cMsg,pos-1)
		label := gtk_LabelNew(, str)
		gtk_LabelSetLineWrap(Label, .T.)
		gtk_BoxPackStart(vbox, Label)
		cMsg := substr(cMsg,pos+ 1)
		pos := at(';',cMsg)
		//if pos==0; pos := len(cMsg)+1; endif
	enddo
        */
        ames := split(cMsg, ";")
        for i=1 to len(ames)
		label := gtk_LabelNew(, ames[i])
		gtk_LabelSetLineWrap(Label, .T.)
		gtk_BoxPackStart(vbox, Label)
        next

	gtk_BoxPackStart(hbox, vbox)
	gtk_ContainerAdd(Dialog:VBox, hbox)

	gtk_BoxSetHomogeneous(Dialog:ActionArea, .t.)

	if aButton == NIL
		Button := gtk_ButtonNew(, [&Ok], "&")
		gtk_WidgetSetSizeRequest(Button, BtnWidth, BtnHeight)
		gtk_SignalConnect(Button,"clicked",{|w,e| ret:=.t., gtk_WidgetHide(Dialog)})
		gtk_WidgetAddAccelerator(Button, GTK_CLICKED_SIGNAL, Dialog, ;
			Button:AccelKey)
		gtk_WidgetAddAccelerator(Button, GTK_CLICKED_SIGNAL, Dialog, ;
			Button:AccelKey, GDK_CONTROL_MASK)

		gtk_ContainerAdd(Dialog:ActionArea, Button)
		inFocus := Button:handle
	else
		ret := 0
		Button := {}
//		asize(aReturn, len(aButton))
		for i=1 to len(aButton)
			aadd(Button, gtk_ButtonNew(, aButton[i], "&"))
//			Button[i]:nResult := iif(aReturn[i]==NIL, i, aReturn[i])
			Button[i]:nResult := i
			gtk_WidgetSetSizeRequest(Button[i], BtnWidth, BtnHeight)
			gtk_SignalConnect(Button[i],"clicked",{|w,e| ret:=w:nResult, gtk_WidgetHide(Dialog)})
			gtk_WidgetAddAccelerator(Button[i], GTK_CLICKED_SIGNAL, Dialog, ;
				Button[i]:AccelKey)
			gtk_WidgetAddAccelerator(Button[i], GTK_CLICKED_SIGNAL, Dialog, ;
				Button[i]:AccelKey, GDK_CONTROL_MASK)

			gtk_ContainerAdd(Dialog:ActionArea, Button[i])
			if i==1
				inFocus := Button[i]:handle
			endif
		next
	endif

        if activeWnd != NIL
		gtk_WindowSetTransientFor(Dialog, activeWnd)
		gtk_WindowSetPosition(Dialog, GTK_WIN_POS_CENTER_ON_PARENT)
        endif

	gtk_WidgetSetFocus(inFocus)
	gtk_WidgetRealize(Dialog)
	gtk_WindowSetFunctions(Dialog, GDK_FUNC_CLOSE + GDK_FUNC_MOVE + GDK_FUNC_RESIZE)
	gtk_WindowSetDecorations(Dialog, NUMOR(GDK_DECOR_TITLE, GDK_DECOR_BORDER))
	gtk_WidgetShowAll(Dialog)

	gtk_Main()

return ret
********************
function gtk_ColorNew(r, g, b, op)
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

