/*
    Copyright (C) 2003  ITK
    Author   : Alexey M. Tkachenko (alexey@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include <clip-gtk.ch>

static mtype, atype, ltype, itype, aCls, aNCls, aRef, aSRef, aOCnt, aSCnt, aVCnt

local ret := NIL
parameters query_key

	query_key := alltrim(upper(query_key))
	do case
		case query_key == "GTK_INIT_CARD"
			ret := {|card|abx_attr_init_card(card)}
		case query_key == "GTK_FILL_CARD"
			ret := {|card,obj|abx_attr_fill_card(card,obj)}
		case query_key == "GTK_SAVE_CARD"
			ret := {|card|abx_attr_save_card(card)}
		otherwise
			ret:=[ATTR plugin does not supports function:]+query_key
	endcase
return ret

static function abx_attr_init_card(Card)
	local i, ctype
	local dict, tmp
	local vbox,frm,tbl

	atype:=codb_info("CODB_ATTR_TYPES")
	ltype:=codb_info("CODB_ATTR_LENTYPES")
	itype:=codb_info("CODB_ATTR_INDEXTYPES")

	card:widget	:= vbox := gtk_VBoxNew()
	card:data	:= nil
	card:dict	:= card:dep:dictionary()

	mtype := {}; ctype := {}
	for i=1 to len(atype)
		aadd(mtype,atype[i][2])
		aadd(ctype,atype[i][1])
	next

	gtk_BoxPackStart(vbox,gtk_LabelNew(,[Attribute parameters]))
//	gtk_LayoutPut(l,gtk_LabelNew(,[Attribute parameters]),10,10)
	//gtk_LayoutPut(l,gtk_HSeparatorNew(),50,50)
	frm := gtk_FrameNew()
	gtk_BoxPackStart(vbox,frm)
	tbl := gtk_TableNew(,7,2)
	gtk_ContainerAdd(frm,tbl)

	card_new_label(tbl, 1,1, [Identification])
	card:edId := card_new_getobj(tbl,"C",, 1,2)
//	card:edId:on_change := {||card:on_change()}
	gtk_WidgetSetSensitive(card:edId:widget,.F.)

	card_new_label(tbl, 2,1, [Name])
	card:edName := card_new_getobj(tbl,"C",, 2,2)
	card:edName:on_change := {||card:on_change()}

	card_new_label(tbl, 3,1, [Type])
	card:cbType := abx_combo_new(mtype,ctype)
	card_put_widget(tbl,card:cbType:widget, 3,2)
	card:cbType:on_change := {||card:on_change()}

	card_new_label(tbl, 4,1, [Length])
	card:edLength := card_new_getobj(tbl,"N",, 4,2)
	card:edLength:on_change := {||card:on_change()}
	card:edLength:set_range(1,codb_info("CODB_MAX_LEN_STRING"))

	card_new_label(tbl, 5,1, [Type length])
	card:edTypeLen := card_new_getobj(tbl,"N",, 5,2)
	card:edTypeLen:on_change := {||card:on_change()}

	card_new_label(tbl, 6,1, [Decimals])
	card:edDec := card_new_getobj(tbl,"N",, 6,2)
	card:edDec:on_change := {||card:on_change()}
	card:edDec:set_range(codb_info("CODB_MIN_DECIMALS"),codb_info("CODB_MAX_DECIMALS"))

	aCls := card:dict:select("CLASS")
	aRef := {[ANY OBJECT]}; aSRef := {""}

	for i := 1 to len(aCls)
		tmp := card:dict:GetValue(aCls[i])
		if valtype(tmp) == "O"
			aadd(aRef, alltrim(tmp:name)+" ("+alltrim(aCls[i])+")")
			aadd(aSRef,aCls[i])
		endif
	next
	card_new_label(tbl, 7,1, [Reference to])
	card:cbRef := abx_combo_new(aRef,aSRef)
	card_put_widget(tbl,card:cbRef:widget, 7,2)
	card:cbRef:on_change := {||card:on_change()}

	card_new_label(tbl, 8,1, [Picture mask])
	card:edPic := card_new_getobj(tbl,"C",, 8,2)
	card:edPic:on_change := {||card:on_change()}

	card_new_label(tbl, 9,1, [Default value])
	card:edDefVal := card_new_getobj(tbl,"C",, 9,2)
	card:edDefVal:on_change := {||card:on_change()}

	aOCnt := card:dict:select("COUNTER")
	aSCnt:= {[NONE COUNTER]}; aVCnt := {""}
	for i := 1 to len(aOCnt)
		tmp := card:dict:GetValue(aOCnt[i])
		if valtype(tmp) == "O"
			aadd(aSCnt, alltrim(tmp:name)+" ("+alltrim(aOCnt[i])+")")
			aadd(aVCnt,aOCnt[i])
		endif
	next
	card_new_label(tbl, 10,1, [Counter name])
	card:cbCnt := abx_combo_new(aSCnt,aVCnt)
	card_put_widget(tbl,card:cbCnt:widget, 10,2)
	card:cbCnt:on_change := {||card:on_change()}

	/*
	card_new_label(tbl, 11,1, [Unique key])
	card:edUnique := card_new_getobj(tbl,"C",, 11,2)
	card:edUnique:on_change := {||card:on_change()}
	*/

	card_new_label(tbl, 12,1, [Not null])
	card:edNotNull := card_new_getobj(tbl,"L",, 12,2)
	card:edNotNull:on_change := {||card:on_change()}

	card_new_label(tbl, 13,1, [Not empty])
	card:edNotEmpty := card_new_getobj(tbl,"L",, 13,2)
	card:edNotEmpty:on_change := {||card:on_change()}

	card_new_label(tbl, 14,1, [Source code])
	card:edSrc := card_new_getobj(tbl,"L",, 14,2)
	card:edSrc:on_change := {||card:on_change()}

	card:lbRefCount := gtk_LabelNew()
	gtk_BoxPackStart(vbox,card:lbRefCount,.t.,.t.)

	***************************************************
return card

static function abx_attr_fill_card(card,obj)
	local s, maperr

	if valtype(obj) != "O"
		abx_attr_clear_card(card)
		return .f.
	endif

	card:data := obj
	codb_padrbody(card:data,codb_info("CODB_ATTR_BODY"))

	maperr := set(_SET_MAPERR,.t.)
	if !empty(obj:id)
		card:edId:set_value(obj:id)
	else
		card:edId:set_value([Automatically generating])
	endif

	card:edName:set_value(obj:name)
	card:cbType:set_value(alltrim(obj:type))
	card:edLength:set_value(obj:len)
	card:edTypeLen:set_value(obj:LenType)
	card:edDec:set_value(obj:dec)
	card:cbRef:set_value(alltrim(obj:ref_to))
	card:edPic:set_value(obj:mask)
	card:edDefVal:set_value(obj:defValue)
	if HASH_COUNTER $ obj
		card:cbCnt:set_value(alltrim(obj:counter))
	endif
	//card:edUnique:set_value(obj:unique)
	card:edNotNull:set_value(obj:not_null)
	card:edNotEmpty:set_value(obj:not_empty)
	card:edSrc:set_value(!empty(obj:source))

	s := [This attribute has ###### references from classes]
	s:=strtran(s,"######",alltrim(str(obj:count,6,0)))
	gtk_LabelSetText(card:lbRefCount,s)

	set(_SET_MAPERR,maperr)
return .t.

static function abx_attr_save_card(card)
	local valid, event

	valid := card:edLength:valid()
	valid := valid .and. card:edDec:valid()

	if !valid
		return .f.
	endif

	card:data:name     := card:edName:get_value()
	card:data:type     := card:cbType:get_value()
	card:data:len      := card:edLength:get_value()
	card:data:LenType  := card:edTypeLen:get_value()
	card:data:Dec      := card:edDec:get_value()
	card:data:ref_to   := card:cbRef:get_value()
	card:data:mask     := card:edPic:get_value()
	card:data:DefValue := card:edDefVal:get_value()
	card:data:counter  := card:cbCnt:get_value()
	//card:data:unique   := card:edUnique:get_value()
	card:data:not_null := card:edNotNull:get_value()
	card:data:not_empty:= card:edNotEmpty:get_value()
return .t.

static function abx_attr_clear_card(card)
	card:edId:set_value("")
	card:edName:set_value("")
	card:cbType:set_value("")
	card:edLength:set_value(0)
	card:edTypeLen:set_value(0)
	card:edDec:set_value(0)
	card:cbRef:set_value("")
	card:edPic:set_value("")
	card:edDefVal:set_value("")
	//card:edUnique:set_value("")
	card:edNotNull:set_value(.F.)
	card:edNotEmpty:set_value(.F.)
	card:edSrc:set_value(.F.)
	gtk_LabelSetText(card:lbRefCount,"")
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

static function card_new_getobj(tbl,Type,Picture,Row,Col)
	local getobj

	getobj := abx_getobj_new(Type,Picture)
	gtk_TableAttachDefaults(tbl,getobj:widget,Col,Col+1,Row,Row+1)
return getobj

static function card_put_widget(tbl,wid,Row,Col)
	gtk_TableAttachDefaults(tbl,wid,Col,Col+1,Row,Row+1)
return wid
