/*
    Copyright (C) 2003  ITK
    Author   : Alexey M. Tkachenko (alexey@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include <clip-gtk.ch>
#include <inkey.ch>

local ret := NIL
parameters query_key

	query_key := alltrim(upper(query_key))
	do case
		case query_key == "GTK_INIT_CARD"
			ret := {|card|abx_tview_init_card(card)}
		case query_key == "GTK_FILL_CARD"
			ret := {|card,obj|abx_tview_fill_card(card,obj)}
		case query_key == "GTK_SAVE_CARD"
			ret := {|card|abx_tview_save_card(card)}
		otherwise
			ret:=[TVIEW plugin does not supports function:]+query_key
	endcase
return ret

static function abx_tview_init_card(card)
	local i, tmp
	local vbox,frm,tbl,hbox, swin, vbox2
	local sExt,vExt,aExt, sCls,vCls,aCls
	local sGrp,vGrp,aGrp, sUsr,vUsr,aUsr

	card:widget	:= vbox := gtk_VBoxNew()
	card:dict := card:dep:dictionary()

	gtk_BoxPackStart(vbox,gtk_LabelNew(,[TVIEW parameters]))
	frm := gtk_FrameNew()
	gtk_BoxPackStart(vbox,frm,.T.,.T.)
	tbl := gtk_TableNew(,8,2)
	gtk_ContainerAdd(frm,vbox2 := gtk_VBoxNew())
	gtk_BoxPackStart(vbox2,tbl)

	abx_tbl_new_label(tbl, 1,1, [Identification])
	card:edId := abx_tbl_new_getobj(tbl,"C",, 1,2)
	gtk_WidgetSetSensitive(card:edId:widget,.F.)

	abx_tbl_new_label(tbl, 2,1, [Name])
	card:edName := abx_tbl_new_getobj(tbl,"C",, 2,2, card:on_change)

	sExt := {[none]}; vExt := {""}
	aExt := card:dict:Select("EXTENT")
	for i := 1 to len(aExt)
		tmp := card:dict:getvalue(aExt[i])
		if valtype(tmp) == "O"
			aadd(sExt,alltrim(tmp:name)+" ("+alltrim(aExt[i])+")")
			aadd(vExt,aExt[i])
		endif
	next
	abx_tbl_new_label(tbl, 3,1, [Extent])
	card:cbExtent := abx_combo_new(sExt,vExt,{||card:on_change()})
	abx_tbl_put_widget(tbl,card:cbExtent:widget, 3,2)

	sCls := {[none]}; vCls := {""}
	aCls := card:dep:dictionary():Select("CLASS")
	for i := 1 to len(aCls)
		tmp := card:dep:dictionary():getvalue(aCls[i])
		if valtype(tmp) == "O"
			aadd(sCls,alltrim(tmp:name)+" ("+alltrim(aCls[i])+")")
			aadd(vCls,aCls[i])
		endif
	next
	abx_tbl_new_label(tbl, 4,1, [Class])
	card:cbClass := abx_combo_new(sCls,vCls,card:on_change)
	abx_tbl_put_widget(tbl,card:cbClass:widget, 4,2)

	sGrp := {[none]}; vGrp := {""}
	aGrp := card:dep:dictionary():Select("GROUP")
	for i := 1 to len(aGrp)
		tmp := card:dep:dictionary():GetValue(aGrp[i])
		if valtype(tmp) == "O"
			aadd(vGrp,aGrp[i])
			aadd(sGrp,alltrim(tmp:name)+" ("+alltrim(aGrp[i])+")")
		endif
	next
	abx_tbl_new_label(tbl, 5,1, [Group])
	card:cbGroup := abx_combo_new(sGrp,vGrp,card:on_change)
	abx_tbl_put_widget(tbl, card:cbGroup:widget, 5,2)

	sUsr := {[none]}; vUsr := {""}
	aUsr := card:dep:dictionary():Select("USER")
	for i := 1 to len(aUsr)
		tmp := card:dep:dictionary():GetValue(aUsr[i])
		if valtype(tmp) == "O"
			aadd(vUsr,aUsr[i])
			aadd(sUsr,alltrim(tmp:name)+" ("+alltrim(aUsr[i])+")")
		endif
	next
	abx_tbl_new_label(tbl, 6,1, [User])
	card:cbUser := abx_combo_new(sUsr,vUsr,card:on_change)
	abx_tbl_put_widget(tbl, card:cbUser:widget, 6,2)

	swin := gtk_ScrolledWindowNew()
	card:ColList := gtk_ClistNew(,3)
	gtk_SignalConnect(card:ColList,"key-press-event", ;
		{|wid,ev|list_key_handler(card,ev)})
	gtk_CListSetSelectionMode(card:ColList,GTK_SELECTION_BROWSE)
	gtk_CListSetColumnTitle(card:ColList,1,[Column])
	gtk_CListSetColumnTitle(card:ColList,2,[Name])
	gtk_CListSetColumnTitle(card:ColList,3,[Header])
	gtk_CListSetColumnAutoResize(card:ColList,1)
	gtk_CListSetColumnAutoResize(card:ColList,2)
	gtk_CListSetColumnAutoResize(card:ColList,3)
	gtk_CListColumnTitlesShow(card:ColList)
	gtk_ContainerAdd(swin,card:ColList)
	gtk_BoxPackStart(vbox2,swin,.T.,.T.)

return card

static function abx_tview_fill_card(card,obj)
	local s, maperr, tmp, i

	if valtype(obj) != "O"
		obj := map()
	else
		card:data := obj
	endif

	codb_padrbody(card:data,codb_info("CODB_TVIEW_BODY"))

	maperr := set(_SET_MAPERR,.t.)
	if !empty(obj:id)
		card:edId:set_value(obj:id)
	else
		card:edId:set_value([Automatically generating])
	endif

	card:edName:set_value(obj:name)
	card:cbExtent:set_value(alltrim(obj:extent_id))
	card:cbClass:set_value(alltrim(obj:class_id))
	card:cbGroup:set_value(alltrim(obj:group_id))
	card:cbUser:set_value(alltrim(obj:user_id))

	gtk_CListFreeze(card:ColList)
	gtk_CListClear(card:ColList)
	for i := 1 to len(obj:col_list)
		tmp := card:dict:GetValue(obj:col_list[i])
		s := {obj:col_list[i]}
		aadd(s,tmp:name)
		aadd(s,tmp:header)
		gtk_CListAppend(card:ColList,s)
		gtk_CListSetRowData(card:ColList,i,obj:col_list[i])
	next
	if empty(obj:col_list)
		gtk_CListAppend(card:ColList,"")
	endif
	gtk_CListThaw(card:ColList)

	set(_SET_MAPERR,maperr)
return .t.

static function list_key_handler(card,event)
	local col, sel

	switch (event:keyval)
		case K_INS,K_F2
		col = abx_column_choice(card:dict)
		if !empty(col)
			if empty(gtk_CListGetRowData(card:ColList,1))
				gtk_CListClear(card:ColList)
			endif
			gtk_CListAppend(card:ColList, ;
				{col:id,col:name,col:header})
			gtk_CListSetRowData(card:ColList, gtk_CListGetRowCount(card:ColList), col:id)
			eval(card:on_change,card)
		endif

		case K_DEL,K_F8
		sel := gtk_CListGetSelection(card:ColList)
		if len(sel) > 0
			gtk_CListRemove(card:ColList,sel[1])
			eval(card:on_change,card)
			if empty(gtk_CListGetRowData(card:ColList,1))
				gtk_CListAppend(card:ColList,"")
			endif
		endif
	end
return

static function abx_tview_save_card(card)
	local i, rows, id

	card:data:name		:= card:edName:get_value()
	card:data:extent_id	:= card:cbExtent:get_value()
	card:data:class_id	:= card:cbClass:get_value()
	card:data:group_id	:= card:cbGroup:get_value()
	card:data:user_id	:= card:cbUser:get_value()

	card:data:col_list := {}
	rows := gtk_CListGetRowCount(card:ColList)
	for i := 1 to rows
		id := gtk_CListGetRowData(card:ColList,i)
		aadd(card:data:col_list,id)
	next

return .t.
