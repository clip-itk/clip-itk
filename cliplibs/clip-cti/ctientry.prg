/*
	Copyright (C) 2002  ITK
	CLIP text interface library
	Author	: Alexey M. Tkachenko (alexey@itk.ru)
	License	: (GPL) http://www.itk.ru/clipper/license.html
*/

/* CTI_ENTRY - object, that use to edit data of variable types: N, C, L, D, M */

#include "cti.ch"

#include "setcurs.ch"
#include "inkey.ch"

#define	SUPERCLASS	CTI_CONTROL

function cti_entry_new(VarType,Picture)
	local obj := cti_inherit(cti_control_new(),"CTI_ENTRY")

	obj:__getobj		:= nil
	obj:__block		:= nil
	obj:__var		:= nil
	obj:__vartype		:= iif(!valtype(VarType)$"NLCDM","C",VarType)
	obj:__picture		:= iif(valtype(Picture)=="C",Picture,"")
	obj:__initialized	:= FALSE
	obj:__first_key		:= FALSE
	obj:__control_focused	:= FALSE
	obj:__editable		:= TRUE

	obj:__real_draw		:= @cti_entry_real_draw()
	obj:__set_cursor	:= @cti_entry_set_cursor()
	obj:__set_color		:= @cti_entry_set_color()
	obj:__handle_event	:= @cti_entry_handle_event()
	obj:__init		:= @cti_entry_init()
	obj:__make_buffer	:= @cti_entry_make_buffer()
	obj:__set_focus		:= @cti_entry_set_focus()
	obj:__kill_focus	:= @cti_entry_kill_focus()
	obj:__set_getobj_size	:= @cti_entry_set_getobj_size()

	obj:set_default_keys	:= @cti_entry_set_default_keys()
	obj:get_value		:= {|_obj|iif(.not. _obj:__initialized,nil,_obj:__var)}
	obj:set_value		:= @cti_entry_set_value()
	obj:set_pos		:= @cti_entry_set_pos()
	obj:get_pos		:= {|_obj|iif(_obj:__initialized,_obj:__getobj:pos,-1)}
	obj:set_editable	:= @cti_entry_set_editable()

	obj:realize_real	:= @cti_entry_realize_real()

	obj:__initialized	:= obj:__init()

	obj:set_default_keys()
return obj

static function cti_entry_make_buffer(obj)
	CALL SUPER obj:__make_buffer()
	obj:__getobj:winbuffer := obj:__buffer
return

static function cti_entry_set_focus(obj)
	obj:__first_key := FALSE
	if obj:__is_realized
		obj:__getobj:setFocus()
	endif
return TRUE

static function cti_entry_kill_focus(obj)
//	CALL SUPER obj:__set_focus()
//	obj:__first_key := FALSE
	if obj:__is_realized
		obj:__getobj:killFocus()
	endif
return TRUE

static function cti_entry_set_getobj_size(obj)
	local w := cti_cnum(obj:width)

	switch (obj:__vartype)
		case "C", "M"
		if len(obj:__var) < w
			obj:__getobj:assign()
		endif
		if len(obj:__var) < w
			obj:__var := padr(obj:__var,w)
		endif
	end
//	obj:__getobj:picture := "@S"+cti_cstr(w)+iif("@"$+obj:__getobj:picture,""," ")+obj:__getobj:picture
	obj:__getobj:picture := "@S"+cti_cstr(w)+iif("@"$obj:__picture,""," ")+obj:__picture
return TRUE

static function cti_entry_set_cursor(obj)
	if obj:__initialized .and. ;
		obj:__abs_top!=nil .and. obj:__abs_left!=nil .and. ;
		obj:__abs_top>=0 .and. obj:__abs_top<=maxrow() .and. ;
		obj:__abs_left>=0 .and. obj:__abs_left<=maxcol()

	//obj:__cursor_visible(0,obj:__getobj:cursorPos)

		obj:__calc_abs_coords()
		setpos(cti_cnum(obj:__abs_top),cti_cnum(obj:__abs_left) + obj:__getobj:cursorPos - 1)
		setcursor(SC_NORMAL)
	else
		CALL SUPER obj:__set_cursor()
		return FALSE
	endif
return TRUE

static function cti_entry_init(obj)
	local pic_default

	if .not. obj:__vartype $ "NLCDM"; return .F.; endif

	switch (obj:__vartype)
		case "N"
		obj:__var := 0

		case "C"
		obj:__var := ""

		case "L"
		obj:__var := .F.

		case "D"
		obj:__var := ctod("")

		case "M"
		obj:__var := ""
	end

	if .not. "@K" $ obj:__picture
		obj:__picture := "@K"+iif("@"$obj:__picture,""," ")+obj:__picture
//		obj:__getobj:__flags += "K"
	endif

	obj:__getobj := getNew(0,0,,,obj:__picture,obj:palette:Control+","+obj:palette:Control+","+obj:palette:ActiveControl)
	obj:__block:={|_1|local(_2:=@obj:__var), iif(_1==NIL,_2,_2:=_1)}
	obj:__getobj:block := obj:__block
	obj:__getobj:expand := obj:__vartype $ "CM"
//	obj:__getobj:__firstKey := FALSE
	obj:signal_connect(HASH_CTI_WIDGET_SET_FOCUS_SIGNAL,{|_obj,_sig|_obj:__set_focus()})
//	obj:signal_connect(HASH_CTI_WIDGET_LOST_FOCUS_SIGNAL,{|_obj,_sig|_obj:__kill_focus(),_obj:__getobj:assign()})
	obj:signal_connect(HASH_CTI_WIDGET_LOST_FOCUS_SIGNAL,{|_obj,_sig|_obj:__getobj:assign()})
	obj:signal_connect(HASH_CTI_SET_SIZE_SIGNAL,obj:__set_getobj_size)
return TRUE

static function cti_entry_real_draw(obj)
	local color

	CALL SUPER obj:__real_draw()

	if .not. obj:__initialized; return .F.; endif

	if obj:__is_focused
		if obj:__first_key
			color := obj:Palette:ActiveControl
		else
			color := obj:Palette:Selection
			obj:__getobj:__firstKey := obj:__first_key
		endif
	else
		color := obj:Palette:Control
	endif
	if !obj:__is_enabled; color := obj:Palette:DisabledControl; endif

/*
	if obj:__control_focused != obj:__is_focused
		if obj:__is_focused
			obj:__getobj:setfocus()
		else
			obj:__getobj:killfocus()
		endif
		obj:__control_focused := obj:__is_focused
	endif
*/

	obj:__getobj:setcolor(color)
	if obj:__is_enabled
		winbuf_out_at(obj:__buffer,0,0,space(obj:width),obj:Palette:ActiveControl)
	else
		winbuf_out_at(obj:__buffer,0,0,space(obj:width),obj:Palette:Window)
	endif
	obj:__getobj:display()
return TRUE

static function cti_entry_realize_real(obj)
	local height, width

	if .not. obj:__initialized; return FALSE; endif

//	height := obj:height; width := obj:width
//	obj:set_size(0,0)
	obj:__getobj:setfocus()
//	obj:__getobj:killfocus()
	if obj:height==nil
		obj:height := 1
	endif
	if obj:width==nil
		obj:width := obj:__getobj:width()
	endif
//	height := iif(height==nil,1,height)
//	width  := iif(width==nil,obj:__getobj:width(),width)
//	obj:set_size(height,width)

	CALL SUPER obj:realize_real()
return TRUE

static function cti_entry_set_value(obj,value)
	local sig, old_value

	old_value := obj:__var
	obj:__var := value
	if .not. obj:__initialized; return .F.; endif
	obj:__getobj:reload()
	sig := cti_signal_new(HASH_CTI_CHANGED_SIGNAL)
	sig:old_value := old_value
	sig:value := obj:__var
	obj:signal_emit(sig)

	obj:draw_queue()
return TRUE

static function cti_entry_handle_event(obj,event)
***********************************************
	local cKey, old_value, sig, old_pos
	local not_changed := FALSE, ret

	if .not. obj:__initialized; return .F.; endif
	if event:type != CTI_KEYBOARD_EVENT; return .F.; endif

	old_pos := obj:__getobj:pos

	ret := obj:apply_key(event:keycode)

	if ret == FALSE
		if  event:keycode >= 32 .AND. event:keycode <= 255
			cKey := CHR( event:keycode )
			if ( obj:__getobj:type == "N" .AND. ( cKey == "." .OR. cKey == "," ) )
				obj:__getobj:toDecPos()
			else
				if set( _SET_INSERT )
					obj:__getobj:Insert( cKey )
				else
					obj:__getobj:OverStrike( cKey )
				endif

				if ( obj:__getobj:typeOut )
					if ( set( _SET_BELL ) )
						?? CHR(7)
					endif
				endif
			endif
		else
			not_changed := TRUE
		endif
	endif

	if obj:__getobj:changed
		old_value := obj:__getobj:varGet()
		obj:__var := obj:__getobj:unTransform()
		sig := cti_signal_new(HASH_CTI_CHANGED_SIGNAL)
		sig:old_value := old_value
		sig:value := obj:__var
		obj:signal_emit(sig)
		obj:draw_queue()
		ret := TRUE
		obj:__getobj:changed := FALSE
	endif
	if not_changed
		// nothing
	else
		obj:__first_key := obj:__editable
		obj:draw_queue()
//		obj:repaint()
		if obj:__getobj:pos != old_pos
			ret := TRUE
		endif
	endif
return ret

static function cti_entry_set_color(obj,color)
	if .not. obj:__initialized; return FALSE; endif
	obj:__getobj:color := color
return TRUE

static function cti_entry_set_pos(obj,nPos)
	if .not. obj:__initialized; return FALSE; endif
	obj:__getobj:setpos(nPos)
	obj:repaint()
return TRUE

static function cti_entry_set_editable(obj,lEditable)
	if .not. obj:__initialized; return FALSE; endif
	cti_return_if_fail(valtype(lEditable) $ "UL")
	if lEditable==nil; lEditable==TRUE; endif
	obj:__editable := lEditable
	obj:__getobj:readonly := !lEditable
return TRUE

static function cti_entry_set_default_keys(obj)
	obj:set_key(K_CTRL_U, 	{|_obj|_obj:__getobj:Undo()})
	obj:set_key(K_HOME, 	{|_obj|_obj:__getobj:Home()})
	obj:set_key(K_END, 	{|_obj|_obj:__getobj:End()})
	obj:set_key(K_RIGHT, 	{|_obj|_obj:__getobj:Right()})
	obj:set_key(K_LEFT, 	{|_obj|_obj:__getobj:Left()})
	obj:set_key(K_CTRL_RIGHT,{|_obj|_obj:__getobj:wordRight()})
	obj:set_key(K_CTRL_LEFT,{|_obj|_obj:__getobj:wordLeft()})
	obj:set_key(K_BS, 	{|_obj|_obj:__getobj:BackSpace()})
	obj:set_key(K_DEL, 	{|_obj|_obj:__getobj:Delete()})
	obj:set_key(K_CTRL_T, 	{|_obj|_obj:__getobj:delWordRight()})
	obj:set_key(K_CTRL_Y, 	{|_obj|_obj:__getobj:delEnd()})
	obj:set_key(K_CTRL_BS, 	{|_obj|_obj:__getobj:delWordLeft()})
return TRUE

