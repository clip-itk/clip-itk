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
			ret := {|card|abx_plugins_init_card(card)}
		case query_key == "GTK_FILL_CARD"
			ret := {|card,obj|abx_plugins_fill_card(card,obj)}
		case query_key == "GTK_SAVE_CARD"
			ret := {|card|abx_plugins_save_card(card)}
		otherwise
			ret:=[PLUGINS plugin does not supports function:]+query_key
	endcase
return ret

static function abx_plugins_init_card(card)
	local i, tmp
	local vbox,frm,tbl,vTypes,sTypes,aTypes
	local sCls,vCls,aCls

	card:widget	:= vbox := gtk_VBoxNew()

	gtk_BoxPackStart(vbox,gtk_LabelNew(,[Plugin parameters]))
	frm := gtk_FrameNew()
	gtk_BoxPackStart(vbox,frm)
	tbl := gtk_TableNew(,6,2)
	gtk_ContainerAdd(frm,tbl)

	abx_tbl_new_label(tbl, 1,1, [Identification])
	card:edId := abx_tbl_new_getobj(tbl,"C",, 1,2)
	gtk_WidgetSetSensitive(card:edId:widget,.F.)

	abx_tbl_new_label(tbl, 2,1, [Name])
	card:edName := abx_tbl_new_getobj(tbl,"C",, 2,2, card:on_change)

	vTypes := {}; sTypes := {}
	aTypes := codb_info("CODB_PLUGINS_TYPES")
	for i := 1 to len(aTypes)
		aadd(vTypes,aTypes[i,1])
		aadd(sTypes,aTypes[i,2])
	next
	abx_tbl_new_label(tbl, 3,1, [Type])
	card:cbType := abx_combo_new(sTypes,vTypes,card:on_change)
	abx_tbl_put_widget(tbl, card:cbType:widget, 3,2,)

	abx_tbl_new_label(tbl, 4,1, [File name])
	card:edFileName := abx_tbl_new_getobj(tbl,"C",, 4,2, card:on_change)

	abx_tbl_new_label(tbl, 5,1, [Main function])
	card:edMainFunc := abx_tbl_new_getobj(tbl,"C",, 5,2, card:on_change)

	sCls := {[none]}; vCls := {""}
	aCls := card:dep:dictionary():Select("CLASS")
	for i := 1 to len(aCls)
		tmp := card:dep:dictionary():getvalue(aCls[i])
		if valtype(tmp) == "O"
			aadd(sCls,alltrim(tmp:name)+" ("+alltrim(aCls[i])+")")
			aadd(vCls,aCls[i])
		endif
	next
	abx_tbl_new_label(tbl, 6,1, [Class])
	card:cbClass := abx_combo_new(sCls,vCls,card:on_change)
	abx_tbl_put_widget(tbl,card:cbClass:widget, 6,2)
return card

static function abx_plugins_fill_card(card,obj)
	local s, maperr, tmp, i

	if valtype(obj) != "O"
		obj := map()
	else
		card:data := obj
	endif

	codb_padrbody(card:data,codb_info("CODB_PLUGINS_BODY"))

	maperr := set(_SET_MAPERR,.t.)
	if !empty(obj:id)
		card:edId:set_value(obj:id)
	else
		card:edId:set_value([Automatically generating])
	endif

	card:edName:set_value(obj:name)
	card:cbType:set_value(alltrim(obj:type))
	card:edFileName:set_value(obj:filename)
	card:edMainFunc:set_value(obj:mainfunc)
	card:cbClass:set_value(alltrim(obj:class_id))

	set(_SET_MAPERR,maperr)
return .t.

static function abx_plugins_save_card(card)
	local i, rows, id

	card:data:name		:= card:edName:get_value()
	card:data:type 		:= card:cbType:get_value()
	card:data:filename	:= card:edFileName:get_value()
	card:data:mainfunc	:= card:edMainFunc:get_value()
	card:data:class_id	:= card:cbClass:get_value()
return .t.
