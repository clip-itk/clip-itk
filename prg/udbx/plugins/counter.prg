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
			ret := {|card|abx_counter_init_card(card)}
		case query_key == "GTK_FILL_CARD"
			ret := {|card,obj|abx_counter_fill_card(card,obj)}
		case query_key == "GTK_SAVE_CARD"
			ret := {|card|abx_counter_save_card(card)}
		otherwise
			ret:=[COUNTER plugin does not supports function:]+query_key
	endcase
return ret

static function abx_counter_init_card(card)
	local i, tmp
	local vbox,frm,tbl,vTypes,sTypes,aTypes

	card:widget	:= vbox := gtk_VBoxNew()

	gtk_BoxPackStart(vbox,gtk_LabelNew(,[Counter parameters]))
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
	aTypes := codb_info("CODB_COUNTER_TYPES")
	for i := 1 to len(aTypes)
		aadd(vTypes,aTypes[i,1])
		aadd(sTypes,aTypes[i,2])
	next
	abx_tbl_new_label(tbl, 3,1, [Type])
	card:cbType := abx_combo_new(sTypes,vTypes,card:on_change)
	abx_tbl_put_widget(tbl, card:cbType:widget, 3,2,)

	abx_tbl_new_label(tbl, 4,1, [Depository])
	card:lblDep := abx_tbl_new_label(tbl, 4,2, "", 0.01)

	abx_tbl_new_label(tbl, 5,1, [MAX value])
	card:edMaxVal := abx_tbl_new_getobj(tbl,"N",, 5,2, card:on_change)

	abx_tbl_new_label(tbl, 6,1, [LAST value])
	card:edLastVal := abx_tbl_new_getobj(tbl,"N",, 6,2, card:on_change)

return card

static function abx_counter_fill_card(card,obj)
	local s, maperr

	if valtype(obj) != "O"
		obj := map()
	else
		card:data := obj
	endif

	codb_padrbody(card:data,codb_info("CODB_COUNTER_BODY"))

	maperr := set(_SET_MAPERR,.t.)
	if !empty(obj:id)
		card:edId:set_value(obj:id)
	else
		card:edId:set_value([Automatically generating])
	endif

	card:edName:set_value(obj:name)
	card:cbType:set_value(alltrim(obj:type))
	gtk_LabelSetText(card:lblDep,obj:depository)
	card:edMaxVal:set_value(obj:max_value)
	card:edLastVal:set_value(obj:last_value)

	set(_SET_MAPERR,maperr)
return .t.

static function abx_counter_save_card(card)
	local i, rows, id

	card:data:name		:= card:edName:get_value()
	card:data:type 		:= card:cbType:get_value()
	card:data:max_value	:= card:edMaxVal:get_value()
	card:data:last_value	:= card:edLastVal:get_value()
return .t.
