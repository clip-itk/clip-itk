/*
    Copyright (C) 2003  ITK
    Author   : Alexey M. Tkachenko (alexey@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include <clip-gtk.ch>

local ret := NIL
parameters query_key

	query_key := alltrim(upper(query_key))
	do case
		case query_key == "GTK_INIT_CARD"
			ret := {|card|abx_index_init_card(card)}
		case query_key == "GTK_FILL_CARD"
			ret := {|card,obj|abx_index_fill_card(card,obj)}
		case query_key == "GTK_SAVE_CARD"
			ret := {|card|abx_index_save_card(card)}
		otherwise
			ret:=[INDEX plugin does not supports function:]+query_key
	endcase
return ret

static function abx_index_init_card(card)
	local i, ctype
	local vbox,frm,tbl

	card:widget	:= vbox := gtk_VBoxNew()

	gtk_BoxPackStart(vbox,gtk_LabelNew(,[Index parameters]))
	frm := gtk_FrameNew()
	gtk_BoxPackStart(vbox,frm)
	tbl := gtk_TableNew(,3,2)
	gtk_ContainerAdd(frm,tbl)

	card_new_label(tbl, 1,1, [Identification])
	card:edId := card_new_getobj(tbl,"C",, 1,2)
	gtk_WidgetSetSensitive(card:edId:widget,.F.)

	card_new_label(tbl, 2,1, [Name])
	card:edName := card_new_getobj(tbl,"C",, 2,2, {||card:on_change()})

	card_new_label(tbl, 3,1, [Expression])
	card:edExpr := card_new_getobj(tbl,"C",, 3,2, {||card:on_change()})

return card

static function abx_index_fill_card(card,obj)
	local s, maperr

	if valtype(obj) != "O"
		abx_index_clear_card(card)
		return .f.
	endif

	card:data := obj
	codb_padrbody(card:data,codb_info("CODB_INDEX_BODY"))

	maperr := set(_SET_MAPERR,.t.)
	if !empty(obj:id)
		card:edId:set_value(obj:id)
	else
		card:edId:set_value([Automatically generating])
	endif

	card:edName:set_value(obj:name)
	card:edExpr:set_value(obj:expr)

	set(_SET_MAPERR,maperr)
return .t.

static function abx_index_save_card(card)
	local event

	card:data:name     := card:edName:get_value()
	card:data:expr     := card:edExpr:get_value()
	adel(card:data,"EXPR_BLOCK")
return .t.

static function abx_index_clear_card(card)
	card:edId:set_value("")
	card:edName:set_value("")
	card:edExpr:set_value("")
return .t.

/********************************************************************/
static function card_new_label(tbl,Row,Col,LblText)
	local label

	label := gtk_LabelNew(,"  "+LblText+"  ")
	gtk_TableAttach(tbl,label,Col,Col+1,Row,Row+1, GTK_FILL)
	gtk_MiscSetAlignment(label,1,0)
return label

static function card_new_entry(tbl,Row,Col)
	local entry

	entry := gtk_EntryNew()
	gtk_TableAttachDefaults(tbl,entry,Col,Col+1,Row,Row+1)
return entry

static function card_new_getobj(tbl,Type,Picture,Row,Col,OnChgBlock)
	local getobj

	getobj := abx_getobj_new(Type,Picture,OnChgBlock)
	gtk_TableAttachDefaults(tbl,getobj:widget,Col,Col+1,Row,Row+1)
return getobj

static function card_put_widget(tbl,wid,Row,Col)
	gtk_TableAttachDefaults(tbl,wid,Col,Col+1,Row,Row+1)
return wid
