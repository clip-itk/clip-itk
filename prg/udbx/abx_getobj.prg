/*
    Copyright (C) 2003  ITK
    Author  : Alexey M. Tkachenko <alexey@itk.ru>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
* charset koi8-r
#include "clip-gtk.ch"
#include "inkey.ch"

function abx_getobj_new(Type,Picture,OnChange)
	local obj:=map()

	obj:widget	:= gtk_EntryNew()
	obj:changed	:= .F.
	obj:on_change	:= OnChange

	obj:__getobj	:= nil
	obj:__var	:= nil
	obj:__vartype	:= iif(!valtype(Type)=="C" .or. !Type$"NLCDM","C",Type)
	obj:__picture	:= iif(valtype(Picture)=="C",Picture,"")
	obj:range_set	:= .F.
	obj:range_lo	:= nil
	obj:range_hi	:= nil

	obj:init	:= @abx_getobj_init()
	obj:set_value	:= @abx_getobj_setvalue()
	obj:get_value	:= @abx_getobj_getvalue()
	obj:handle_key	:= @abx_getobj_handle_key()
	obj:focus_in	:= @abx_getobj_focus_in()
	obj:focus_out	:= @abx_getobj_focus_out()
	obj:en_changed	:= @abx_getobj_en_changed()
	obj:set_range	:= @abx_getobj_set_range()
	obj:valid	:= @abx_getobj_valid()
	obj:unset_range	:= {|self|self:range_set := .F.}

	obj:init()
return obj

static function abx_getobj_init(self)

	switch (self:__vartype)
		case "N"
		self:__var := 0

		case "C"
		self:__var := ""

		case "L"
		self:__var := .F.

		case "D"
		self:__var := ctod("")

		case "M"
		self:__var := ""
	end

	self:__getobj := GetNew(,,,,self:__picture)
	self:__getobj:_display := {|getobj|abx_getobj_display(self,getobj)}
	self:__block:={|_1|local(_2:=@self:__var), iif(_1==NIL,_2,_2:=_1)}
	self:__getobj:block := self:__block
//	self:__getobj:expand := self:__vartype $ "CM"

	self:__getobj:SetFocus()
	self:__getobj:KillFocus()

	gtk_SignalConnect(self:widget, GTK_EVENT, {|wgt, ev| self:handle_key(ev) })
	gtk_SignalConnect(self:widget, "focus-in-event", {|wgt, ev| self:focus_in(ev) })
	gtk_SignalConnect(self:widget, "focus-out-event", {|wgt, ev| self:focus_out(ev) })
	gtk_SignalConnect(self:widget, "changed", {|wgt, ev| self:en_changed() })
return .T.

static function abx_getobj_display(self,getobj)
	if "Q"$getobj:__flags .and. getobj:type == "C"
		gtk_EntrySetText(self:widget,replicate("*",len(trim(getobj:buffer))))
	else
		if getobj:type == "L"
			gtk_EntrySetText(self:widget,iif(self:__var,[Yes],[No]))
		else
			gtk_EntrySetText(self:widget,getobj:buffer)
		endif
	endif
	gtk_EntrySetPosition(self:widget,getobj:pos-1)
return .T.

static function abx_getobj_setvalue(self,new_val)
	self:__var := new_val
	self:__getobj:reload()
	self:__getobj:_display()
return .T.

static function abx_getobj_getvalue(self)
return self:__var

static function abx_getobj_focus_in(self,event)
	gtk_EditableSelectRegion(self:widget,0,-1)
return .F.

static function abx_getobj_focus_out(self,event)
	self:__getobj:display()
	gtk_EditableSelectRegion(self:widget,self:__getobj:pos-1,self:__getobj:pos-1)
return .F.

static function abx_getobj_handle_key(self,event)
local nHi, nLo
local lAccept
local nDefButton
local nKey
local nState, nFlags

	if event:event == GTK_2BUTTON_PRESS .and. self:__getobj:Type == "L"
		event:event := GTK_KEY_PRESS
		event:keyval := K_SPACE
	else
		if event:event != GTK_KEY_PRESS
			return .f.
		endif
	endif

	nKey := Event:keyval
	nState := Event:state

/*
	if nState == 1
		nState := VK_SHIFT
	elseif nState == 4
		nState := VK_CONTROL
	endif
*/
	self:__getobj:pos := gtk_EditableGetPosition(self:widget)+1
	if self:__getobj:pos > len(self:__getobj:buffer)
		self:__getobj:pos := len(self:__getobj:buffer)
	endif
	if self:__getobj:Type == "L"
		self:__getobj:pos := 1
	endif

	if between(nKey,0xFFB0,0xFFB9)
		nKey := nKey - 0xFF80
	endif

	nKey := abx_keyval_to_ascii(nKey)

	if nKey == K_DEL .or. nKey == K_BS .or. between(nKey,32,256)
		nLo := nHi := 0
		gtk_EditableGetSelection(self:widget, @nLo, @nHi )
		// Delete selection
		if nHi != nLo
			self:__getobj:buffer = stuff(self:__getobj:buffer, ;
				min(nLo,nHi)+1,abs(nHi-nLo),"")+ ;
				Space(Abs(nLo-nHi))
			if nKey == K_DEL .or. nKey == K_BS
				self:__getobj:Assign()
				nKey := 0
				gtk_EntrySetPosition(self:widget,Min(nLo,nHi))
			endif
//			self:__getobj:Reset()
			self:__getobj:pos := Min(nLo,nHi)+1
		endif
	endif

	do case

	case NumAnd(nState,4) == 1
		if nKey == K_LEFT; self:__getobj:WordLeft(); endif
		if nKey == K_RIGHT; self:__getobj:WordRight(); endif

	case nKey == K_INS
		Set(_SET_INSERT,!Set(_SET_INSERT))

	case nKey >= 32 .and. nKey < 256

		if self:__getobj:Type == "N" .and. ;
			( Chr( nKey ) == "." .or. Chr( nKey ) == "," )
			self:__getobj:ToDecPos()
		else
			if Set( _SET_INSERT )
				self:__getobj:__original := self:__getobj:buffer
				self:__getobj:Insert( Chr( nKey ) )
			else
				self:__getobj:__original := self:__getobj:buffer
				self:__getobj:Overstrike( Chr(nKey) )
			end
		endif

/*
		if self:__getobj:Type == "N" .and. ;
				nKey == K_SPACE
			self:__var := .not. self:__var
			self:__getobj:Reset()
		endif
*/

		if self:__getobj:Rejected()
			gdk_Beep()
		else
			self:__var := self:__getobj:unTransform()
			self:__getobj:_display()
//			self:EditUpdate()
		endif
/*
		if self:__getobj:TypeOut
			if ! Set( _SET_CONFIRM )
				self:oWnd:nLastKey = VK_RETURN  // VK_DOWN 17/10/95
				self:oWnd:GoNextCtrl( self:hWnd )
			else
				MsgBeep()
			endif
		endif
*/
		return .t.
	otherwise
		if self:__getobj:setKey(nKey) != NIL
			eval(self:__getobj:setKey(nKey), self:__getobj, nKey)
			self:__var := self:__getobj:unTransform()
			self:__getobj:_display()
			return .t.
		endif
	endcase

return .f.

static function abx_getobj_set_range(self,lo,hi)
	self:range_set := .T.
	self:range_lo := MIN(lo,hi)
	self:range_hi := MAX(lo,hi)
return .F.

static function abx_getobj_valid(self)
	if self:range_set
		if self:__var >= self:range_lo .and. self:__var <= self:range_hi
			return .T.
		else
			gtk_WidgetGrabFocus(self:widget)
			abx_msgbox([Value must be in interval:]+" ["+  ;
				alltrim(toString(self:range_lo))+","+  ;
				alltrim(toString(self:range_hi))+"]",  ;
				[Input error])
			return .F.
		endif
	endif
return .T.

static function abx_getobj_en_changed(self,event)
	if self:__getobj:changed
		self:changed := .T.
		if valtype(self:on_change) == "B"
			eval(self:on_change,self)
		endif
	endif
return .F.

/******************************************************************/

function abx_combo_new(List,ValList,OnChange)
	local obj:=map()

	obj:widget	:= gtk_ComboNew()
	obj:changed	:= .F.
	obj:on_change	:= OnChange
	obj:list	:= iif(valtype(List)=="A",List,{})
	obj:val_list	:= iif(valtype(ValList)=="A",ValList,{})
	obj:has_val_list:= valtype(ValList)=="A"

	obj:init	:= @abx_combo_init()
	obj:set_value	:= @abx_combo_set_value()
	obj:set_pos	:= @abx_combo_set_pos()
	obj:get_value	:= @abx_combo_get_value()
	obj:get_pos	:= @abx_combo_get_pos()
	obj:focus_in	:= @abx_combo_focus_in()
	obj:focus_out	:= @abx_combo_focus_out()
	obj:en_changed	:= @abx_combo_en_changed()

	obj:init()
return obj

static function abx_combo_init(self)
	gtk_ComboSetValueInList(self:widget,.T.)
	gtk_ComboSetUseArrows(self:widget,.F.)
	gtk_EditableSetEditable(self:widget:entry,.F.)
	gtk_ComboSetPopdownStrings(self:widget,self:list)

	gtk_SignalConnect(self:widget:entry, "focus-in-event", {|wgt, ev| self:focus_in(ev) })
	gtk_SignalConnect(self:widget:entry, "focus-out-event", {|wgt, ev| self:focus_out(ev) })
	gtk_SignalConnect(self:widget:entry, "changed", {|wgt, ev| self:en_changed() })
return .T.

static function abx_combo_set_value(self,value)
	local pos, val

//	val := gtk_EntryGetText(self:widget:entry)
	if self:has_val_list
		pos := ascan(self:val_list,value)
		if pos > 0
			val := self:list[pos]
		else
			val := value
		endif
	else
		val := value
	endif
	gtk_EntrySetText(self:widget:entry,val)
return val

static function abx_combo_set_pos(self,pos)
	local val

	val := gtk_EntryGetText(self:widget:entry)
	if pos >= 1 .and. pos <= len(self:list)
		gtk_EntrySetText(self:widget:entry,self:list[pos])
	endif
return val

static function abx_combo_get_value(self)
	local pos, val

	val := gtk_EntryGetText(self:widget:entry)
	if self:has_val_list
		pos := ascan(self:list,val)
		if pos > 0 .and. pos <= len(self:val_list)
			val := self:val_list[pos]
		endif
	endif
return val

static function abx_combo_get_pos(self)
	local pos := 0, val

	val := gtk_EntryGetText(self:widget:entry)
	if self:has_val_list
		pos := ascan(self:list,val)
	endif
return pos

static function abx_combo_focus_in(self,event)
	gtk_EditableSelectRegion(self:widget:entry,0,-1)
return .F.

static function abx_combo_focus_out(self,event)
	gtk_EditableSelectRegion(self:widget:entry,0,0)
return .F.

static function abx_combo_en_changed(self,event)
	self:changed := .T.
	if valtype(self:on_change) == "B"
		eval(self:on_change,self)
	endif
return .F.

static function abx_keyval_to_ascii(keyval)
	local ascii := keyval

	if keyval < 0x600; return keyval; endif

	switch (keyval)
		case GDK_Cyrillic_io	       , ;
		     GDK_Cyrillic_IO           , ;
		     GDK_Cyrillic_yu           , ;
		     GDK_Cyrillic_a            , ;
		     GDK_Cyrillic_be           , ;
		     GDK_Cyrillic_tse          , ;
		     GDK_Cyrillic_de           , ;
		     GDK_Cyrillic_ie           , ;
		     GDK_Cyrillic_ef           , ;
		     GDK_Cyrillic_ghe          , ;
		     GDK_Cyrillic_ha           , ;
		     GDK_Cyrillic_i            , ;
		     GDK_Cyrillic_shorti       , ;
		     GDK_Cyrillic_ka           , ;
		     GDK_Cyrillic_el           , ;
		     GDK_Cyrillic_em           , ;
		     GDK_Cyrillic_en           , ;
		     GDK_Cyrillic_o            , ;
		     GDK_Cyrillic_pe           , ;
		     GDK_Cyrillic_ya           , ;
		     GDK_Cyrillic_er           , ;
		     GDK_Cyrillic_es           , ;
		     GDK_Cyrillic_te           , ;
		     GDK_Cyrillic_u            , ;
		     GDK_Cyrillic_zhe          , ;
		     GDK_Cyrillic_ve           , ;
		     GDK_Cyrillic_softsign     , ;
		     GDK_Cyrillic_yeru         , ;
		     GDK_Cyrillic_ze           , ;
		     GDK_Cyrillic_sha          , ;
		     GDK_Cyrillic_e            , ;
		     GDK_Cyrillic_shcha        , ;
		     GDK_Cyrillic_che          , ;
		     GDK_Cyrillic_hardsign     , ;
		     GDK_Cyrillic_YU           , ;
		     GDK_Cyrillic_A            , ;
		     GDK_Cyrillic_BE           , ;
		     GDK_Cyrillic_TSE          , ;
		     GDK_Cyrillic_DE           , ;
		     GDK_Cyrillic_IE           , ;
		     GDK_Cyrillic_EF           , ;
		     GDK_Cyrillic_GHE          , ;
		     GDK_Cyrillic_HA           , ;
		     GDK_Cyrillic_I            , ;
		     GDK_Cyrillic_SHORTI       , ;
		     GDK_Cyrillic_KA           , ;
		     GDK_Cyrillic_EL           , ;
		     GDK_Cyrillic_EM           , ;
		     GDK_Cyrillic_EN           , ;
		     GDK_Cyrillic_O            , ;
		     GDK_Cyrillic_PE           , ;
		     GDK_Cyrillic_YA           , ;
		     GDK_Cyrillic_ER           , ;
		     GDK_Cyrillic_ES           , ;
		     GDK_Cyrillic_TE           , ;
		     GDK_Cyrillic_U            , ;
		     GDK_Cyrillic_ZHE          , ;
		     GDK_Cyrillic_VE           , ;
		     GDK_Cyrillic_SOFTSIGN     , ;
		     GDK_Cyrillic_YERU         , ;
		     GDK_Cyrillic_ZE           , ;
		     GDK_Cyrillic_SHA          , ;
		     GDK_Cyrillic_E            , ;
		     GDK_Cyrillic_SHCHA        , ;
		     GDK_Cyrillic_CHE          , ;
		     GDK_Cyrillic_HARDSIGN

		ascii := asc(translate_charset('koi8-r',host_charset(),chr(keyval - 0x600)))

	end
return ascii
