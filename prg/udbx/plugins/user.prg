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
			ret := {|card|abx_user_init_card(card)}
		case query_key == "GTK_FILL_CARD"
			ret := {|card,obj|abx_user_fill_card(card,obj)}
		case query_key == "GTK_SAVE_CARD"
			ret := {|card|abx_user_save_card(card)}
		otherwise
			ret:=[USER plugin does not supports function:]+query_key
	endcase
return ret

static function abx_user_init_card(card)
	local i, tmp
	local vbox,frm,tbl
	local sGrp,vGrp,aGrp

	card:widget	:= vbox := gtk_VBoxNew()

	gtk_BoxPackStart(vbox,gtk_LabelNew(,[User parameters]))
	frm := gtk_FrameNew()
	gtk_BoxPackStart(vbox,frm)
	tbl := gtk_TableNew(,6,2)
	gtk_ContainerAdd(frm,tbl)

	abx_tbl_new_label(tbl, 1,1, [Identification])
	card:edId := abx_tbl_new_getobj(tbl,"C",, 1,2)
	gtk_WidgetSetSensitive(card:edId:widget,.F.)

	abx_tbl_new_label(tbl, 2,1, [Name])
	card:edName := abx_tbl_new_getobj(tbl,"C",, 2,2, card:on_change)

	sGrp := {[none]}; vGrp := {""}
	aGrp := card:dep:dictionary():Select("GROUP")
	for i := 1 to len(aGrp)
		tmp := card:dep:dictionary():GetValue(aGrp[i])
		if valtype(tmp) == "O"
			aadd(vGrp,aGrp[i])
			aadd(sGrp,alltrim(tmp:name)+" ("+alltrim(aGrp[i])+")")
		endif
	next
	abx_tbl_new_label(tbl, 3,1, [Group])
	card:cbGroup := abx_combo_new(sGrp,vGrp,card:on_change)
	abx_tbl_put_widget(tbl, card:cbGroup:widget, 3,2,)

	abx_tbl_new_label(tbl, 4,1, [Access rules])
	card:edAccess := abx_tbl_new_getobj(tbl,"C",, 4,2, card:on_change)

return card

static function abx_user_fill_card(card,obj)
	local s, maperr, tmp, i

	if valtype(obj) != "O"
		obj := map()
	else
		card:data := obj
	endif

	codb_padrbody(card:data,codb_info("CODB_USER_BODY"))

	maperr := set(_SET_MAPERR,.t.)
	if !empty(obj:id)
		card:edId:set_value(obj:id)
	else
		card:edId:set_value([Automatically generating])
	endif

	card:edName:set_value(obj:name)
	card:cbGroup:set_value(alltrim(obj:group_id))
	card:edAccess:set_value(obj:access)

	set(_SET_MAPERR,maperr)
return .t.

static function abx_user_save_card(card)
	local i, rows, id

	card:data:name		:= card:edName:get_value()
	card:data:group_id	:= card:cbGroup:get_value()
	card:data:access	:= card:edAccess:get_value()
return .t.
