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
			ret := {|card|abx_deposit_init_card(card)}
		case query_key == "GTK_FILL_CARD"
			ret := {|card,obj|abx_deposit_fill_card(card,obj)}
		case query_key == "GTK_SAVE_CARD"
			ret := {|card|abx_deposit_save_card(card)}
		otherwise
			ret:=[DEPOSIT plugin does not supports function:]+query_key
	endcase
return ret

static function abx_deposit_init_card(card)
	local i, tmp
	local vbox,frm,tbl

	card:widget	:= vbox := gtk_VBoxNew()

	gtk_BoxPackStart(vbox,gtk_LabelNew(,[Depository parameters]))
	frm := gtk_FrameNew()
	gtk_BoxPackStart(vbox,frm)
	tbl := gtk_TableNew(,6,2)
	gtk_ContainerAdd(frm,tbl)

	abx_tbl_new_label(tbl, 1,1, [Identification])
	card:edId := abx_tbl_new_getobj(tbl,"C",, 1,2)
	gtk_WidgetSetSensitive(card:edId:widget,.F.)

	abx_tbl_new_label(tbl, 2,1, [Name])
	card:edName := abx_tbl_new_getobj(tbl,"C",, 2,2, card:on_change)

	abx_tbl_new_label(tbl, 3,1, [Cluster size])
	card:edMemoSize := abx_tbl_new_getobj(tbl,"N",, 3,2, card:on_change)
	card:edMemoSize:set_range(8,1024)

	abx_tbl_new_label(tbl, 4,1, [Number])
	card:edNumber := abx_tbl_new_getobj(tbl,"N",, 4,2, card:on_change)
	gtk_WidgetSetSensitive(card:edNumber:widget,.F.)

return card

static function abx_deposit_fill_card(card,obj)
	local s, maperr, tmp, i

	if valtype(obj) != "O"
		obj := map()
	else
		card:data := obj
	endif

	codb_padrbody(card:data,codb_info("CODB_DEPOSIT_BODY"))

	maperr := set(_SET_MAPERR,.t.)
	if !empty(obj:id)
		card:edId:set_value(obj:id)
	else
		card:edId:set_value([Automatically generating])
	endif

	card:edName:set_value(obj:name)
	card:edMemoSize:set_value(obj:memosize)
	card:edNumber:set_value(obj:number)

	set(_SET_MAPERR,maperr)
return .T.

static function abx_deposit_save_card(card)
	local i, rows, id

	if !card:edMemoSize:valid()
		return .F.
	endif

	card:data:name		:= card:edName:get_value()
	card:data:memosize	:= card:edMemoSize:get_value()
return .T.
