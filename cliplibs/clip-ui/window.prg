/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation 	           */
/*   Authors: 								   */
/*  	     Andrey Cherepanov <sibskull@mail.ru>			   */
/*           Igor Satsyuk <satsyuk@tut.by>                                 */
/*   Last change: 10 Jan 2005						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

static driver := getDriver()

/* TODO: setAction() for UIWindow (close), UIChildWindow (close and changed focus) */

/* Window class */
function UIWindow( caption, parent, name, close, resizeable )
	local obj	:= driver:createWindow( caption, parent, resizeable )
	obj:closeFlag	:= close
	obj:className	:= "UIWindow"
	obj:parent	:= parent
 	obj:name	:= name
	obj:menu	:= NIL
	obj:toolbar	:= NIL
	obj:statusbar	:= NIL
	obj:value	:= map()
	obj:valueNames	:= array(0)
	obj:valueTypes	:= map()
	obj:objId	:= NIL
	obj:origObj	:= NIL
        obj:creator	:= NIL
	obj:returnAction := NIL
	obj:objClass	:= ""
	obj:objDep	:= ""

	obj:childs	:= array(0)
	obj:childCount	:= 0
	obj:childSpace	:= NIL
	obj:menuChildWindow := NIL
	obj:widget	:= map()
	
	obj:menu 	:= NIL
	obj:toolbar	:= NIL
	obj:statusbar	:= NIL

	obj:keyEvents 	:= array(0)

	_recover_UIWINDOW(obj)
	_recover_UIWINDOWCOMMON(obj)
return obj

function UIMainWindow(caption, name)
	local obj	:= UIWindow(caption, NIL, name, .T., .T.)
	obj:className	:= "UIMainWindow"
	obj:sysMenus	:= map()
return obj

function _recover_UIWINDOW( obj )
	obj:close	:= @ui_mainWindowClose()
	obj:childClose    := @ui_childClose()
	obj:childCloseAll := @ui_childCloseAll()
	obj:setCaption  := @ui_setCaption()
	obj:getGeometry := @ui_getGeometry()
	obj:setGeometry := @ui_setGeometry()
	obj:setPlacement  := @ui_setPlacement()
	obj:setMDI	:= @ui_setMDI()
	obj:setIcon	:= @ui_setIcon()
	obj:setFocus	:= @ui_setFocus()
	obj:setDefault	:= @ui_setDefault()
	obj:setKeyEvent := @ui_setKeyEvent()
	obj:unSetKeyEvent := @ui_unSetKeyEvent()
return obj

/* MDI child window */
function UIChildWindow( caption, parent, name )
	local obj
	if empty(parent)
		?? "ERROR: empty parent for child window.&\n"
		return NIL
	endif
	obj := driver:createChildWindow( caption, parent )
	obj:className	:= "UIChildWindow"
        obj:name	:= name
	obj:widget	:= map()
	obj:value	:= map()
	obj:valueNames	:= array(0)
	obj:valueTypes	:= map()
	obj:objId	:= NIL
	obj:origObj	:= NIL
        obj:creator	:= NIL
	obj:returnAction := NIL
	obj:objClass	:= ""
	obj:objDep	:= ""

	obj:menu 	:= NIL
	obj:toolbar	:= NIL
	obj:statusbar	:= NIL

	obj:parent	:= parent
	parent:childCount += 1
	obj:idWindow	:= "#"+alltrim(str(parent:childCount))
	aadd(parent:childs, obj )

	_recover_UICHILDWINDOW(obj)
	_recover_UIWINDOWCOMMON(obj)
return obj

function _recover_UICHILDWINDOW( obj )
        obj:add		:= @ui_add()
        obj:addEnd	:= @ui_addEnd()
	obj:close	:= @ui_close()
return obj

function _recover_UIWINDOWCOMMON( obj )
	obj:setObj	:= @ui_setObj()
	obj:getObj	:= @ui_getObj()
	obj:dialogBox	:= @ui_dialogBox()
	obj:show    	:= @ui_show()
	obj:setPanels	:= @ui_setPanels()
	obj:setName	:= @ui_setName()
	obj:val		:= @ui_val()
	obj:setValues	:= @ui_setValues()
	obj:getValues	:= @ui_getValues()
	obj:return	:= @ui_return()
	obj:isChanged	:= @ui_isChanged()
	obj:setId	:= @ui_setId()
return obj

function UIDocument(caption, parent, name)
	local us
	local obj
	if empty(parent)
		?? "ERROR: empty parent for document window.&\n"
		return NIL
	endif
	obj := UIChildWindow(caption, parent, name)
	us := obj:userSpace
	obj:actions	:= UIButtonBar(us)
	obj:className	:= "UIDocument"
	us:addEnd(obj:actions,.F.,.F.)
	obj:userSpace	:= driver:createScrolledRegion(us)
return obj

/* Open dialog box */
static function ui_dialogBox(self, caption, text, buttons, buttonNames, action, icon )
	local win:=NIL, g, vb, lside, hb, a, label, m, i, gI
	win := UIWindow( caption, self, "dialogBox", .F. )
	if win == NIL
		return NIL
	endif
        win:creator 	 := self
	win:returnAction := action
	if valtype(buttons) != "A"
		buttons := iif(buttons==NIL,"{|| {'OK'} }","{|| {"+buttons+"} }")
	endif
	a := eval(&buttons)
	m := len( a )
	if empty(buttonNames)
		buttonNames := array(m)
		for i=1 to m
			buttonNames[i] := .F.
		next
		buttonNames[1] := .T.
	else
		buttonNames := "{|| {"+buttonNames+"} }"
		buttonNames := eval(&buttonNames)
	endif
	asize( buttonNames, m )
	g := win:userSpace
	vb := UIVBox( , 10, 10 )
	g:add(vb)
	lside := UIHBox()
	vb:add(lside)
	lside:setSpacing(10)
	if valtype(icon) == 'N'
		lside:add(UIImage(icon))
	endif
	lside:add(UILabel(text),.T.,.T.)
	hb := UIButtonBar( , 10, 10 )
	hb:setAlignment( ALIGN_CENTER )
	b := array(m)
	for i=1 to m
		label := strtran(a[i],"&amp;","&")
		b[i] := UIButton( label, iDialogBoxCodeblock(win,action,buttonNames[i]) )
		hb:add( b[i], .T., .T. )
	next
	vb:addEnd( hb )
	win:setDefault( b[1] ) // Make first button default
	win:setPlacement( .t. )
	win:show()
return win

/* Internal function for correct dialogbox codeblock creation */
static function iDialogBoxCodeblock( win, action, gId)
return {|| win:close(), eval(action, gId) }

/* Set values to form fields */
static function ui_setObj(self, obj)
        local w, val, a, refObj, tref, ref
	
	if valtype(obj) != 'O'
        	return NIL
	endif
	
	/* Store original object */
	self:origObj := map()
	
	for i in self:valueNames
                if at(i,"\.") != 0
			a := split(i,"\.")
			//?? "set foreign object attribute:",a,chr(10)
			refObj := obj
			for ref in a
				if valtype(refObj) != "O" .or. .not. upper(ref) $ refObj
					?? "ERROR: no attribute name:",ref,chr(10)
					tref := ""
					exit
				endif
				tref := refObj[upper(ref)]
				if valtype(tref) == "O"
					refObj := tref
				elseif .not. empty(s) .and. valtype(tref) == "C"
					refObj := s:getObject(tref)
				else
					loop
				endif
			next
			val := tref
		elseif upper(i) $ obj
			val := obj[upper(i)]
		else
			?? "window:setObj(): item '"+i+"' doesn't exist as object attribute&\n"
			loop
		endif
               	w := self:value[i]
		if .not. empty(w)
//			?? "&\tset",i,"=",valtype(val),val,chr(10)
			self:origObj[upper(i)] := val
			w:setValue( val )
		endif
	next
	self:objId := mapget(obj, "ID", NIL)
return NIL

/* Get object from form fields */
static function ui_getObj(self)
        local a, i, obj := map(), v, dateFormat:="dd.mm.yy"
	obj:id := self:objId
	a := self:getValues()
	for i in a
                if at(i[1],"\.") != 0
			loop
		endif
		v := i[2]
		if self:valueTypes[i[1]] == "number"
			v := val(v)
		elseif self:valueTypes[i[1]] == "date" .and. valtype(v) == "C"
			dateFormat := iif(len(v)==10,"dd.mm.yyyy",dateFormat)
			v := ctod(v, dateFormat)
		endif
		obj[upper(i[1])] := v
//		?? "&\tget",upper(i[1]),"=",valtype(v),v,chr(10)
	next
return obj

/* Close main window */
static function ui_mainWindowClose(self)
	driver:closeMainWindow(self)
return NIL

/* Close current child window */
static function ui_childClose(self)
	local w, n
	if len(self:childs) > 0
		n := driver:getCurrentChild(self)
		w := self:childs[n]
		w:close()
	endif
return NIL

/* Close all child windows */
static function ui_childCloseAll(self)
	local i, w, ln
	ln := len(self:childs)
	for i=1 to ln
		w := self:childs[1]
		w:close()
	next
return

/* Close window */
static function ui_close(self)
	local n
	n := driver:closeWindow( self )
	adel(self:parent:childs, n)
	asize(self:parent:childs, len(self:parent:childs)-1)
return NIL

/* Add widget on window user space */
static function ui_add(self, o, expand, fill, padding)
	driver:addBox( self:userSpace, o, expand, fill, padding )
return NIL

/* Add widget at end of window user space */
static function ui_addEnd(self, o, expand, fill, padding)
	driver:addBoxEnd( self:userSpace, o, expand, fill, padding )
return NIL

/* Show window */
static function ui_show(self)
	driver:showWindow( self )
return NIL

/* Set window caption */
static function ui_setCaption(self, caption)
	driver:setCaption( self, caption )
return NIL

/* Get window geometry: position and size */
static function ui_getGeometry( self )
return driver:getGeometry( self )

/* Set window geometry: position and size */
static function ui_setGeometry( self, geom )
	driver:setGeometry( self, geom )
return NIL

/* Set window placement: .T. if centered, .F. - if not */
static function ui_setPlacement( self, centered )
	if .not. empty(centered)
        	driver:setWindowPlacement( self, centered )
	endif
return NIL

/* Set menu, toolbar and statusbar for window */
static function ui_setPanels( self, menu, toolBar, statusBar )
	self:menu 	:= iif(empty(self:menu),menu,self:menu)
	self:toolbar	:= iif(empty(self:toolbar),toolBar,self:toolbar)
	self:statusbar	:= iif(empty(self:statusbar),statusBar,self:statusbar)
	driver:setPanels( self, menu, toolbar, statusBar )
return NIL

/* Set window space for MDI interface */
static function ui_setMDI( self )
	if self:className == "UIMainWindow"
		self:childSpace := driver:createChildSpace( self:userSpace )
	endif
return NIL

/* TODO: Set window icon */
static function ui_setIcon( self, pic )
	if empty(pic)
        	pic := UIImage()
	endif
	driver:setWindowIcon( self, pic )
return NIL

static function ui_setName(self, name, o)
	local i
        if valtype(o) != "O" .or. .not. "CLASSNAME" $ o
		return NIL
	endif
	if ascan({"UIEdit","UIEditText","UIComboBox","UICheckBox","UIButton","UILabel"},o:className) != 0
		self:value[name] := o
		self:valueTypes[name] := "string"
		aadd( self:valueNames, name )
	else
//		?? "ERROR: couldn't set name for non-valued widget "+o:className+CHR(10)
		return NIL
	endif
return o

/* Set all values to widgets defined by function SetName */
static function ui_setValues(self, values)
	local i, w, v
	for i in values
		w := i[1]
                v := i[2]
		w:setValue( v )
	next
return 0

/* Get all values from widgets defined by function SetName */
static function ui_getValues(self)
	local i, w, v, values := array(0)
	for i in self:valueNames
		w := self:value[i]
                v := w:getValue()
                if at(i,"\.") == 0	// Only object's field
			aadd(values, { i, v } )
		endif
	next
return values

/* Get value from widget defined by its name */
static function ui_val(self, name)
        local o:=mapget(self:value,name,NIL)
	if o == NIL
        	return NIL
	endif
return o:getValue()

/* Set focus to specified widget */
static function ui_setFocus(self, obj)
	driver:setFocus(self, obj)
return NIL

/* Set default pushbutton */
static function ui_setDefault(self, obj)
	// TODO: setDefault() doesn't work
	driver:setDefault(self, obj)
return NIL

/* Return values to another form */
static function ui_return(self, val)
        local act
//        ?? "RETURN value:",valtype(val), val,"|", "RETURNACTION" $ self, valtype(self:returnAction), chr(10)
	if "RETURNACTION" $ self .and. valtype(self:returnAction) == "B"
		act := self:returnAction
		eval(act, val)
	endif
return NIL

/* Compare values in windows with original object */
static function ui_isChanged(self)
	local orig, frm, i, mk, e
	
	orig := self:origObj
	frm  := self:getObj()
	
	// Check compared objects
	if self:objId == NIL
		// object never is been stored
		return .T.
	endif
	if valtype(orig) != "O"
		?? "ERROR: original object doesn't stored.&\n"
		return .T.
	endif
	if valtype(frm) != "O"
		?? "ERROR: cannot retrieve values from window.&\n"
		return .T.
	endif

	mk := mapkeys(orig)
//	?? "COMPARE:&\n"
	for i=1 to len(mk)
		e := mk[i]
//		?? "&\t",e,e $ frm,orig[e],frm[e],orig[e]==frm[e],chr(10)
		if .not. e $ frm
//			?? "compare: no key from original in checked form&\n"
			return .T.
		elseif .not. orig[e] == frm[e]
//			?? "compare: value",orig[e],"is changed, new:",frm[e],"&\n"
			return .T.
		endif
	next
//	?? "compare: objects are equivalent.&\n"
return .F.

static function ui_setId(self, id)
	self:objId := id
return

/* Set action to shortcut in specified window  */
static function ui_setkeyEvent(self, cKey, action)
	local oKey
	if valtype(cKey) == "C" .or. valtype(cKey) == "N"
		oKey := driver:getKeyCode(cKey, action)
	else
		oKey := cKey
	endif
	
	// TODO: compare mods too 
	if (i := ascan(self:keyEvents, {|ev| ev:keyval == oKey:keyval})) <> 0
		self:keyEvents[i]:action := action
	else
		aadd(self:keyEvents, oKey)
		if len(self:keyEvents) == 1
			driver:setkeyEvent(self)
		endif
	endif

return .t.

/* Unset action from shortcut in specified window  */
static function ui_unSetKeyEvent(self, cKey)
	local oKey, i

	oKey := driver:getKeyCode(cKey)
	
	if (i := ascan(self:keyEvents, {|ev| ev:keyval == oKey:keyval})) <> 0
		adel(self:keyEvents, i)
		asize(self:keyEvents, len(self:keyEvents)-1)
	endif
return .t.
