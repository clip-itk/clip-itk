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
			ret := {|card|abx_class_init_card(card)}
		case query_key == "GTK_FILL_CARD"
			ret := {|card,obj|abx_class_fill_card(card,obj)}
		case query_key == "GTK_SAVE_CARD"
			ret := {|card|abx_class_save_card(card)}
		otherwise
			ret:=[CLASS plugin does not supports function:]+query_key
	endcase
return ret

static function abx_class_init_card(card)
	local i, tmp
	local vbox,frm,tbl,hbox, attr_swin, ind_swin, vbox2
	local sExt,vExt,aExt, sCls,vCls,aCls

	card:widget	:= vbox := gtk_VBoxNew()

	gtk_BoxPackStart(vbox,gtk_LabelNew(,[CLASS parameters]))
	frm := gtk_FrameNew()
	gtk_BoxPackStart(vbox,frm,.T.,.T.)
	tbl := gtk_TableNew(,8,2)
	gtk_ContainerAdd(frm,vbox2 := gtk_VBoxNew())
	gtk_BoxPackStart(vbox2,tbl)

	abx_tbl_new_label(tbl, 1,1, [Identification])
	card:edId := abx_tbl_new_getobj(tbl,"C",, 1,2)
	gtk_WidgetSetSensitive(card:edId:widget,.F.)

	abx_tbl_new_label(tbl, 2,1, [Name])
	card:edName := abx_tbl_new_getobj(tbl,"C",, 2,2, {||card:on_change()})

	card:dict := card:dep:dictionary()

	sExt := {}; vExt := {}
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
	aCls := card:dict:Select("CLASS")
	for i := 1 to len(aCls)
		tmp := card:dict:getvalue(aCls[i])
		if valtype(tmp) == "O"
			aadd(sCls,alltrim(tmp:name)+" ("+alltrim(aCls[i])+")")
			aadd(vCls,aCls[i])
		endif
	next
	abx_tbl_new_label(tbl, 4,1, [Super class])
	card:cbSuper := abx_combo_new(sCls,vCls,{||card:on_change()})
	abx_tbl_put_widget(tbl,card:cbSuper:widget, 4,2)

	abx_tbl_new_label(tbl, 5,1, [Essence])
	card:edEssence := abx_tbl_new_getobj(tbl,"C",, 5,2, {||card:on_change()})

	abx_tbl_new_label(tbl, 6,1, [Log need])
	card:edLogNeed := abx_tbl_new_getobj(tbl,"L",, 6,2, {||card:on_change()})

	card:StatLabel := abx_tbl_new_label(tbl, 7,1, [Status]+": ")
	card:CounterLabel := abx_tbl_new_label(tbl, 7,2, [Have counters]+": ",0.5)

	attr_swin := gtk_ScrolledWindowNew()
	card:AttrList := gtk_ClistNew(,5)
	gtk_SignalConnect(card:AttrList,"key-press-event", ;
		{|wid,ev|attr_list_key_handler(card,ev)})
	gtk_CListSetSelectionMode(card:AttrList,GTK_SELECTION_BROWSE)
	gtk_CListSetColumnTitle(card:AttrList,1,[Attribute])
	gtk_CListSetColumnTitle(card:AttrList,2,[Name])
	gtk_CListSetColumnTitle(card:AttrList,3,[Type])
	gtk_CListSetColumnTitle(card:AttrList,4,[Len])
	gtk_CListSetColumnTitle(card:AttrList,5,[Dec])
	gtk_CListSetColumnAutoResize(card:AttrList,1)
	gtk_CListSetColumnAutoResize(card:AttrList,2)
	gtk_CListSetColumnAutoResize(card:AttrList,3)
	gtk_CListSetColumnAutoResize(card:AttrList,4)
	gtk_CListSetColumnAutoResize(card:AttrList,5)
	gtk_CListColumnTitlesShow(card:AttrList)
	gtk_ContainerAdd(attr_swin,card:AttrList)
	gtk_BoxPackStart(vbox2,attr_swin,.T.,.T.)

	ind_swin := gtk_ScrolledWindowNew()
	card:IndList := gtk_ClistNew(,3)
	gtk_SignalConnect(card:IndList,"key-press-event", ;
		{|wid,ev|index_list_key_handler(card,ev)})
	gtk_CListSetSelectionMode(card:IndList,GTK_SELECTION_BROWSE)
	gtk_CListSetColumnTitle(card:IndList,1,[Index])
	gtk_CListSetColumnTitle(card:IndList,2,[Name])
	gtk_CListSetColumnTitle(card:IndList,3,[Expression])
	gtk_CListSetColumnAutoResize(card:IndList,1)
	gtk_CListSetColumnAutoResize(card:IndList,2)
	gtk_CListSetColumnAutoResize(card:IndList,3)
	gtk_CListColumnTitlesShow(card:IndList)
	gtk_ContainerAdd(ind_swin,card:IndList)
	gtk_BoxPackStart(vbox2,ind_swin,.T.,.T.)

return card

static function abx_class_fill_card(card,obj)
	local s, maperr, tmp, i

	if valtype(obj) != "O"
		obj := map()
	else
		card:data := obj
	endif

	codb_padrbody(card:data,codb_info("CODB_CLASS_BODY"))

	maperr := set(_SET_MAPERR,.t.)
	if !empty(obj:id)
		card:edId:set_value(obj:id)
	else
		card:edId:set_value([Automatically generating])
	endif

	card:edName:set_value(obj:name)
	card:cbExtent:set_value(alltrim(obj:extent_id))
	card:cbSuper:set_value(alltrim(obj:super_id))
	card:edEssence:set_value(obj:expr_essence)
	card:edLogNeed:set_value(obj:log_need)

	gtk_LabelSetText(card:StatLabel, ;
		[Status]+": "+iif(HASH_UNSTABLE $ obj .and. ;
		obj:unstable,[Unstable],[Stable]))
	gtk_LabelSetText(card:CounterLabel, ;
		[Have counters]+": "+iif(HASH_HAVE_COUNTERS $ obj .and. ;
		obj:have_counters,[Yes],[No]))

	gtk_CListFreeze(card:AttrList)
	gtk_CListClear(card:AttrList)
	for i := 1 to len(obj:attr_list)
		tmp := card:dict:GetValue(obj:attr_list[i])
		s := {obj:attr_list[i]}
		if !empty(tmp)
			aadd(s,tmp:name)
			aadd(s,tmp:type)
			aadd(s,str(tmp:len,5,0))
			aadd(s,str(tmp:dec,2,0))
		else
			aadd(s,[Error loading attribute metadata])
		endif
		gtk_CListAppend(card:AttrList,s)
		gtk_CListSetRowData(card:AttrList,i,obj:attr_list[i])
	next
	if empty(obj:attr_list)
		gtk_CListAppend(card:AttrList,"")
	endif
	gtk_CListThaw(card:AttrList)

	gtk_CListFreeze(card:IndList)
	gtk_CListClear(card:IndList)
	for i := 1 to len(obj:idx_list)
		tmp := card:dict:GetValue(obj:idx_list[i])
		s := {obj:idx_list[i]}
		aadd(s,tmp:name)
		aadd(s,tmp:expr)
		gtk_CListAppend(card:IndList,s)
		gtk_CListSetRowData(card:IndList,i,obj:idx_list[i])
	next
	if empty(obj:idx_list)
		gtk_CListAppend(card:IndList,"")
	endif
	gtk_CListThaw(card:IndList)

	set(_SET_MAPERR,maperr)
return .t.

static function attr_list_key_handler(card,event)
	local attr, sel

	switch (event:keyval)
		case K_INS,K_F2
		attr := abx_attr_choice(card:dict)
		if !empty(attr)
			if empty(gtk_CListGetRowData(card:AttrList,1))
				gtk_CListClear(card:AttrList)
			endif
			gtk_CListAppend(card:AttrList, ;
				{attr:id,attr:name,attr:type,str(attr:len,5,0),str(attr:dec,2,0)})
			gtk_CListSetRowData(card:AttrList, gtk_CListGetRowCount(card:AttrList), attr:id)
			eval(card:on_change,card)
		endif

		case K_DEL,K_F8
		sel := gtk_CListGetSelection(card:AttrList)
		if len(sel) > 0
			gtk_CListRemove(card:AttrList,sel[1])
			eval(card:on_change,card)
			if empty(gtk_CListGetRowData(card:AttrList,1))
				gtk_CListAppend(card:AttrList,"")
			endif
		endif
	end
return

static function index_list_key_handler(card,event)
	local idx, sel

	switch (event:keyval)
		case K_INS,K_F2
		idx := abx_index_choice(card:dict)
		if !empty(idx)
			if empty(gtk_CListGetRowData(card:IndList,1))
				gtk_CListClear(card:IndList)
			endif
			gtk_CListAppend(card:IndList, ;
				{idx:id,idx:name,idx:expr})
			gtk_CListSetRowData(card:IndList, gtk_CListGetRowCount(card:IndList), idx:id)
			eval(card:on_change,card)
		endif

		case K_DEL,K_F8
		sel := gtk_CListGetSelection(card:IndList)
		if len(sel) > 0
			gtk_CListRemove(card:IndList,sel[1])
			eval(card:on_change,card)
			if empty(gtk_CListGetRowData(card:IndList,1))
				gtk_CListAppend(card:IndList,"")
			endif
		endif
	end
return

static function abx_class_save_card(card)
	local i, rows, id

	card:data:name		:= card:edName:get_value()
	card:data:extent_id	:= card:cbExtent:get_value()
	card:data:super_id	:= card:cbSuper:get_value()
	card:data:expr_essence	:= card:edEssence:get_value()
	card:data:log_need	:= card:edLogNeed:get_value()

	card:data:attr_list := {}
	rows := gtk_CListGetRowCount(card:AttrList)
	for i := 1 to rows
		id := gtk_CListGetRowData(card:AttrList,i)
		aadd(card:data:attr_list,id)
	next

	card:data:idx_list := {}
	rows := gtk_CListGetRowCount(card:IndList)
	for i := 1 to rows
		id := gtk_CListGetRowData(card:IndList,i)
		aadd(card:data:idx_list,id)
	next
return .t.
