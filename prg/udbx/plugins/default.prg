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
			ret := {|card|abx_default_init_card(card)}
		case query_key == "GTK_FILL_CARD"
			ret := {|card,obj|abx_default_fill_card(card,obj)}
		case query_key == "GTK_SAVE_CARD"
			ret := {|card|abx_default_save_card(card)}
		otherwise
			ret:=[DEFAULT plugin does not supports function:]+query_key
	endcase
return ret

static function abx_default_init_card(card,class_id)
	local vbox, frm, fvbox, lhbox
	local cattr, i, class_desc

	card:__last_row	:= 2

	card:widget := vbox := gtk_VBoxNew()
	gtk_BoxPackStart(vbox,gtk_LabelNew(,[OBJECT attributes]))
	frm := gtk_FrameNew()
	fvbox := gtk_VBoxNew()
	gtk_BoxPackStart(vbox,frm,.T.,.T.)
	gtk_ContainerAdd(frm,fvbox)

	cattr := card_attribute_new(card)
	cattr:set_value("")
	card:attr_ClassName := cattr

	lhbox := gtk_HBoxNew()
	gtk_BoxPackStart(fvbox,lhbox)
	gtk_BoxPackStart(lhbox,cattr:label)
	gtk_BoxPackStart(lhbox,cattr:widget)

	card:tbl := gtk_TableNew(,2,2)
	gtk_TableSetColSpacing(card:tbl,1,7)
	gtk_BoxPackStart(fvbox,card:tbl)

	card:dict := card:dep:dictionary()

	if ! HASH_ATTRIBUTES $ card
		card:attributes := map()
	endif

	for cattr in card:attributes
		cattr:hide()
	next

return card

static function abx_default_fill_card(card,data)
	local class_desc := map(), k, attr, i, tmp
	local maperr, cattr, sKey, attr_to_hide

	if data != nil .and. HASH_CLASS_ID $ data
		class_desc := card:dict:GetValue(data:class_id)
		card:dict:PadrBody(data,data:class_id)
	endif

	card:data := data

	maperr := set(_SET_MAPERR,.T.)

	if empty(class_desc)
		if empty(data)
			card:attr_ClassName:set_caption([Can`t display information])
		else
			card:attr_ClassName:set_caption([This object don`t have CLASS description])
		endif
	else
		card:attr_ClassName:set_caption([This is an object of class:])
		card:attr_ClassName:set_value(upper(class_desc:name))

		attr_to_hide := map()
		for sKey in card:attributes keys
			attr_to_hide[sKey] := sKey
		next

		for i := 1 to len(class_desc:attr_list)
			tmp := card:dict:GetValue(class_desc:attr_list[i])
			sKey := alltrim(upper(tmp:name))
			if ! sKey $ card:attributes
				cattr := card_attribute_new(card,tmp)
				card_attribute_put(card,cattr)
				card:attributes[sKey] := cattr
			endif
			cattr := card:attributes[sKey]
			if sKey $ data
				cattr:set_value(data[sKey])
			else
				cattr:set_value_to_label([(Error ! Attribute absent in data object)])
			endif

			card:attributes[sKey]:show()
			adel(attr_to_hide,sKey)
		next
		// Here we must hide all unused attributes
		for sKey in attr_to_hide
			card:attributes[sKey]:hide()
		next
	endif

	set(_SET_MAPERR,maperr)

return card

static function abx_default_save_card(card)
	local attr

	for attr in card:attributes
		do case
			case attr:attr_desc:type $ "_C_N_L_D_"
			card:data[attr:attr_name] := attr:__getobj:get_value()

			case attr:attr_desc:type $ "_R_S_"
			card:data[attr:attr_name] := attr:value
		endcase
	next

return .t.

static function card_attribute_new(Card,AttrDesc)
	local obj := map()
	local Name, Caption

	Name := iif(!empty(AttrDesc),upper(alltrim(AttrDesc:name)),"")
	Caption := iif(!empty(AttrDesc),AttrDesc:name,"")

	obj:card	:= Card
	obj:attr_name	:= Name
	obj:attr_desc	:= AttrDesc
	obj:caption	:= Caption
	obj:label	:= gtk_LabelNew(,Caption)
	obj:widget	:= nil
	obj:value_label	:= gtk_LabelNew(,"")
	obj:value	:= nil
	obj:widget_shown:= .T.


	obj:show		:= @card_attribute_show()
	obj:hide		:= @card_attribute_hide()
	obj:init		:= @card_attribute_init()
	obj:set_value		:= @card_attribute_set_value()
	obj:set_value_to_label	:= @card_attribute_set_value_to_label()
	obj:set_caption		:= @card_attribute_set_caption()

	gtk_MiscSetAlignment(obj:label,1)

	obj:init()
return obj

static function card_attribute_show(obj)
	gtk_WidgetShow(obj:label)
	if obj:widget_shown
		if gtk_IsWidget(obj:widget); gtk_WidgetShow(obj:widget); endif
		gtk_WidgetHide(obj:value_label)
	else
		gtk_WidgetShow(obj:value_label)
		if gtk_IsWidget(obj:widget); gtk_WidgetHide(obj:widget); endif
	endif
return

static function card_attribute_hide(obj)
	gtk_WidgetShow(obj:label)
	gtk_WidgetHide(obj:value_label)
	gtk_WidgetHide(obj:widget)
return

static function card_attribute_init(self)
	if !empty(self:attr_desc)
		do case
			case self:attr_desc:type $ "_C_N_L_D_"
			self:__getobj := abx_getobj_new(self:attr_desc:type)
			self:widget := self:__getobj:widget

			case self:attr_desc:type == "R"
			self:widget := gtk_ButtonNew(,"")
			gtk_MiscSetAlignment(self:widget:label,0)
			gtk_SignalConnect(self:widget,"clicked",{|_btn,_ev|ref_button_clicked(_btn,self)})

			case self:attr_desc:type == "S"
			self:widget := gtk_ButtonNew(,"")
			gtk_MiscSetAlignment(self:widget:label,0)
			gtk_SignalConnect(self:widget,"clicked",{|_btn,_ev|sref_button_clicked(_btn,self)})

			otherwise
			self:widget := gtk_LabelNew()
			gtk_MiscSetAlignment(self:widget,0)
		endcase
	else
		self:widget := gtk_LabelNew()
	endif
return

static function ref_button_clicked(btn,attr)
	local obj
	obj := abx_object_choice(attr:card:dict,attr:card:dep,attr:attr_desc:ref_to)
	if !empty(obj)
		attr:set_value(obj:id)
	endif
return

static function sref_button_clicked(btn,attr)
	local obj
	obj := abx_class_choice(attr:card:dict)
	if !empty(obj)
		attr:set_value(obj:id)
	endif
return

static function card_attribute_set_value(self,Value)
	local cDesc, cRef, tmp
	local card := self:card

	self:widget_shown := .T.

	self:value := Value

	if !empty(self:attr_desc)
		do case
			case self:attr_desc:type $ "_C_N_L_D_"
			self:__getobj:set_value(Value)

			case self:attr_desc:type $ "_R_S_"
			cRef := Value
			if self:attr_desc:type == "R"
				tmp := card:dep:GetValue(Value)
			else
				tmp := card:dict:GetValue(Value)
			endif
			if !empty(tmp)
				if HASH_NAME $ tmp
					cRef := Value+" ("+alltrim(tmp:name)+")"
				elseif HASH_SMALLNAME $ tmp
					cRef := Value+" ("+alltrim(tmp:smallname)+")"
				elseif HASH_FULLNAME $ tmp
					cRef := Value+" ("+alltrim(tmp:fullname)+")"
				endif
			endif
			gtk_ButtonSetLabel(self:widget,cRef)

			otherwise
			gtk_LabelSetText(self:widget,alltrim(ToString(Value)))
		endcase
	else
		gtk_LabelSetText(self:widget,alltrim(ToString(Value)))
	endif
return

static function card_attribute_set_value_to_label(self,Value)

	self:widget_shown := .F.

	self:value := Value

	gtk_LabelSetText(self:value_label,alltrim(Value))
return

static function card_attribute_set_caption(self,Caption)
	self:Caption := Caption
	gtk_LabelSetText(self:label,Caption)
return

static function card_attribute_put(Card,CAttr)
	abx_tbl_put_widget(Card:tbl,CAttr:label,Card:__last_row,1)
	abx_tbl_put_widget(Card:tbl,CAttr:value_label,Card:__last_row,2)
	abx_tbl_put_widget(Card:tbl,CAttr:widget,Card:__last_row,2)
	Card:__last_row++
return

