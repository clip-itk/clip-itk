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
			ret := {|card|abx_tcolumn_init_card(card)}
		case query_key == "GTK_FILL_CARD"
			ret := {|card,obj|abx_tcolumn_fill_card(card,obj)}
		case query_key == "GTK_SAVE_CARD"
			ret := {|card|abx_tcolumn_save_card(card)}
		otherwise
			ret:=[TCOLUMN plugin does not supports function:]+query_key
	endcase
return ret

static function abx_tcolumn_init_card(card)
	local i, tmp
	local vbox,frm,tbl,hbox, ref_swin, vbox2
	local sExt,vExt,aExt, sCls,vCls,aCls

	card:widget	:= vbox := gtk_VBoxNew()
	card:dict := card:dep:dictionary()

	gtk_BoxPackStart(vbox,gtk_LabelNew(,[TCOLUMN parameters]))
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

	abx_tbl_new_label(tbl, 3,1, [Width])
	card:edWidth := abx_tbl_new_getobj(tbl,"N",, 3,2, card:on_change)

	abx_tbl_new_label(tbl, 4,1, [Header])
	card:edHeader := abx_tbl_new_getobj(tbl,"C",, 4,2, card:on_change)

	abx_tbl_new_label(tbl, 5,1, [Footer])
	card:edFooter := abx_tbl_new_getobj(tbl,"C",, 5,2, card:on_change)

	abx_tbl_new_label(tbl, 6,1, [Expression])
	card:edExpr := abx_tbl_new_getobj(tbl,"C",, 6,2, card:on_change)

	abx_tbl_new_label(tbl, 7,1, [Depends of])
	card:lblDepend := abx_tbl_new_label(tbl, 7,2, [], 0.01)

	abx_tbl_new_label(tbl, 8,1, [References to])

	ref_swin := gtk_ScrolledWindowNew()
	card:RefList := gtk_ClistNew(,2)
	gtk_SignalConnect(card:RefList,"key-press-event", ;
		{|wid,ev|ref_list_key_handler(card,ev)})
	gtk_CListSetSelectionMode(card:RefList,GTK_SELECTION_BROWSE)
	gtk_CListSetColumnTitle(card:RefList,1,[Class])
	gtk_CListSetColumnTitle(card:RefList,2,[Name])
	gtk_CListSetColumnAutoResize(card:RefList,1)
	gtk_CListSetColumnAutoResize(card:RefList,2)
	gtk_CListColumnTitlesShow(card:RefList)
	gtk_ContainerAdd(ref_swin,card:RefList)
	gtk_BoxPackStart(vbox2,ref_swin,.T.,.T.)

return card

static function abx_tcolumn_fill_card(card,obj)
	local s, maperr, tmp, i

	if valtype(obj) != "O"
		obj := map()
	else
		card:data := obj
	endif

	codb_padrbody(card:data,codb_info("CODB_TCOLUMN_BODY"))

	maperr := set(_SET_MAPERR,.t.)
	if !empty(obj:id)
		card:edId:set_value(obj:id)
	else
		card:edId:set_value([Automatically generating])
	endif

	card:edName:set_value(obj:name)
	card:edWidth:set_value(obj:width)
	card:edHeader:set_value(obj:header)
	card:edFooter:set_value(obj:footer)
	gtk_LabelSetText(card:lblDepend,obj:depend_of)
	card:edExpr:set_value(obj:expr)

	gtk_CListFreeze(card:RefList)
	gtk_CListClear(card:RefList)
	for i := 1 to len(obj:refs)
		tmp := card:dict:GetValue(obj:refs[i])
		s := {obj:refs[i]}
		aadd(s,tmp:name)
		gtk_CListAppend(card:RefList,s)
		gtk_CListSetRowData(card:RefList,i,obj:refs[i])
	next
	if empty(obj:refs)
		gtk_CListAppend(card:RefList,"")
	endif
	gtk_CListThaw(card:RefList)

	set(_SET_MAPERR,maperr)
return .t.

static function ref_list_key_handler(card,event)
	local cls, sel

	switch (event:keyval)
		case K_INS,K_F2
		cls := abx_class_choice(card:dict)
		if !empty(cls)
			if empty(gtk_CListGetRowData(card:RefList,1))
				gtk_CListClear(card:RefList)
			endif
			gtk_CListAppend(card:RefList, ;
				{cls:id,cls:name})
			gtk_CListSetRowData(card:RefList, gtk_CListGetRowCount(card:RefList), cls:id)
			eval(card:on_change,card)
		endif

		case K_DEL,K_F8
		sel := gtk_CListGetSelection(card:RefList)
		if len(sel) > 0
			gtk_CListRemove(card:RefList,sel[1])
			eval(card:on_change,card)
			if empty(gtk_CListGetRowData(card:RefList,1))
				gtk_CListAppend(card:RefList,"")
			endif
		endif
	end
return

static function abx_tcolumn_save_card(card)
	local i, rows, id

	card:data:name		:= card:edName:get_value()
	card:data:width		:= card:edWidth:get_value()
	card:data:header	:= card:edHeader:get_value()
	card:data:footer	:= card:edFooter:get_value()
	card:data:expr		:= card:edExpr:get_value()

	card:data:refs := {}
	rows := gtk_CListGetRowCount(card:RefList)
	for i := 1 to rows
		id := gtk_CListGetRowData(card:RefList,i)
		aadd(card:data:refs,id)
	next

return .t.
