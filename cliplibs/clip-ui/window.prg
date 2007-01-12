/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library                                     */
/*                                                                         */
/*   Copyright (C) 2003-2007 by E/AS Software Foundation                   */
/*   Authors:                                                              */
/*               Andrey Cherepanov <skull@eas.lrn.ru>                      */
/*           Igor Satsyuk <satsyuk@tut.by>                                 */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

#define COMPARE_DEBUG	.F.

static driver := getDriver()
static _mainWindow := NIL

/* TODO: setAction() for UIWindow (close), UIChildWindow (close and changed focus), l10n rules for date/time formatting */

/* Window class */
function UIWindow( caption, parent, name, close, resizeable )
	local obj		:= driver:createWindow( caption, parent, resizeable )
	obj:closeFlag	:= close
	obj:className	:= "UIWindow"
	obj:parent		:= parent
	obj:name		:= name
	obj:menu		:= NIL
	obj:toolbar		:= NIL
	obj:statusbar	:= NIL
	obj:value		:= map()
	obj:valueNames	:= array(0)
	obj:valueTypes	:= map()
	obj:valueTypes2	:= array(0)
	obj:objId		:= NIL
	obj:origObj		:= NIL
	obj:creator		:= NIL
	obj:returnAction := NIL
	obj:objClass	:= ""
	obj:objDep		:= ""
	obj:caption		:= caption
	obj:timers		:= array(0)

	obj:childs		:= array(0)
	obj:childCount	:= 0
	obj:childSpace	:= NIL
	obj:menuChildWindow := NIL
	obj:widget		:= map()

	obj:menu 		:= NIL
	obj:toolbar		:= NIL
	obj:statusbar	:= NIL

	obj:keyEvents 	:= array(0)

	_recover_UIWINDOW(obj)
	_recover_UIWINDOWCOMMON(obj)
return obj

function UIMainWindow(caption, name)
	local obj		:= UIWindow(caption, NIL, name, .T., .T.)
	obj:className	:= "UIMainWindow"
	obj:sysMenus	:= map()
	_mainWindow	:= obj
return obj

function getMainWindow()
return _mainWindow

function _recover_UIWINDOW( obj )
	obj:close			:= @ui_mainWindowClose()
	obj:childClose    	:= @ui_childClose()
	obj:childCloseAll 	:= @ui_childCloseAll()
	obj:setCaption  	:= @ui_setCaption()
	obj:getGeometry 	:= @ui_getGeometry()
	obj:setGeometry 	:= @ui_setGeometry()
	obj:setPlacement  	:= @ui_setPlacement()
	obj:setMDI			:= @ui_setMDI()
	obj:setIcon			:= @ui_setIcon()
	obj:setDefault		:= @ui_setDefault()
	obj:setKeyEvent 	:= @ui_setKeyEvent()
	obj:unSetKeyEvent 	:= @ui_unSetKeyEvent()
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
	obj:name		:= name
	obj:widget		:= map()
	obj:value		:= map()
	obj:valueNames	:= array(0)
	obj:valueTypes	:= map()
	obj:valueTypes2	:= array(0)
	obj:objId		:= NIL
	obj:origObj		:= NIL
	obj:creator		:= NIL
	obj:returnAction := NIL
	obj:objClass	:= ""
	obj:objDep		:= ""
	obj:caption		:= caption
	obj:timers		:= array(0)

	obj:menu 		:= NIL
	obj:toolbar		:= NIL
	obj:statusbar	:= NIL

	obj:parent		:= parent
	parent:childCount += 1
	obj:idWindow	:= "#"+alltrim(str(parent:childCount))
	aadd(parent:childs, obj )

	_recover_UICHILDWINDOW(obj)
	_recover_UIWINDOWCOMMON(obj)
return obj

function _recover_UICHILDWINDOW( obj )
	obj:add			:= @ui_add()
	obj:addEnd		:= @ui_addEnd()
	obj:close		:= @ui_close()
	obj:setCaption  := @ui_setChildCaption()
return obj

function _recover_UIWINDOWCOMMON( obj )
	obj:setObj		:= @ui_setObj()
	obj:getObj		:= @ui_getObj()
	obj:dialogBox	:= @ui_dialogBox()
	obj:show    	:= @ui_show()
	obj:setPanels	:= @ui_setPanels()
	obj:setName		:= @ui_setName()
	obj:val			:= @ui_val()
	obj:setFormat	:= @ui_setFormat()
	obj:setValues	:= @ui_setValues()
	obj:getValues	:= @ui_getValues()
	obj:return		:= @ui_return()
	obj:select		:= @ui_select()
	obj:isChanged	:= @ui_isChanged()
	obj:setId		:= @ui_setId()
	obj:setFocus	:= @ui_setFocus()
	obj:setPadding	:= @ui_setPadding()
	obj:setSpacing	:= @ui_setSpacing()
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
	local win:=NIL, g, vb, lside, hb, a, b, label, m, i, gI
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

	/*
	// Auto icon
	if valtype(icon) == 'U'
		if len(buttons) == 1
			icon := IMG_OK
		else
			icon := IMG_QUESTION
		endif

	endif
	*/
	// Add icon if specified
	if valtype(icon) == 'N'
		lside:add(UIImage(icon))
	endif

	lside:add( UILabel(text), .T., .T. )
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
	win:setPlacement( .T. )
	driver:setModal( win, .T. )
	win:show()
return win

/* Internal function for correct dialogbox codeblock creation */
static function iDialogBoxCodeblock( win, action, gId)
return {|| win:close(), eval(action, gId) }

/* Set values to form fields */
static function ui_setObj(self, obj)
	local i, w, val, a, refObj, tref, ref, vfl, rn

	if valtype(obj) != 'O'
		return NIL
	endif

	/* Store original object */
	self:origObj := map()

	for i in self:valueNames
		vfl := ascan(self:valueTypes2, {|e| upper(i)==upper(e[1]) })
		if vfl > 0
			rn := self:valueTypes2[2]
		else
			rn := i
		endif
		if at("\.",i) != 0
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
				elseif .not. empty(tref) .and. valtype(tref) == "C"
					refObj := tref:getObject(tref)
				else
					loop
				endif
			next
			val := tref
		elseif upper(rn) $ obj
			val := obj[upper(rn)]
		else
			?? "window:setObj(): item '"+rn+"' doesn't exist as object attribute&\n"
			loop
		endif
		w := self:value[i]
		if .not. empty(w)
//			?? "&\tset",i,rn,"=",valtype(val),val,chr(10)
			self:origObj[upper(i)] := val
			if vfl > 0
				val := _val2w( val, self:valueTypes2[vfl][3], w:className )
			endif
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
		v := i[2]
		if self:valueTypes[i[1]] == "number" .and. valtype(v) == "C"
			v := val(v)
		elseif self:valueTypes[i[1]] == "date" .and. valtype(v) == "C"
			dateFormat := iif(len(v)==10,"dd.mm.yyyy",dateFormat)
			v := ctod(v, dateFormat)
		endif
		obj[upper(i[1])] := v
		//?? "&\tget",upper(i[1]),"=",valtype(v),v,chr(10)
	next
return obj

/* Close main window */
static function ui_mainWindowClose(self)
	_stopTimers(self)
	driver:closeMainWindow(self)
return NIL

/* Close current child window */
static function ui_childClose(self)
	local w, n
	_stopTimers(self)
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
	_stopTimers(self)
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
	self:caption := caption
	driver:setCaption( self, caption )
return NIL

/* Set caption for child window */
static function ui_setChildCaption(self, caption)
	// TODO: BUG #230: child window caption should be show in main window caption
	self:caption := caption
	driver:setChildCaption( self, caption )
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
	self:menu 		:= iif(empty(self:menu),menu,self:menu)
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

/* Set window icon */
static function ui_setIcon( self, pic )
	if empty(pic)
		pic := UIImage()
	endif
	driver:setWindowIcon( self, pic )
return NIL

static function ui_setName(self, name, o)
	local i, nArr, vType:='string'
	if valtype(o) != "O" .or. .not. "CLASSNAME" $ o
		return NIL
	endif
	
	// Extract type from name
	nArr := split(name,':')
	if len(nArr) > 1
		name  := nArr[1]
		vType := lower(nArr[2])
	endif

	self:value[name] := o
	self:valueTypes[name] := vType
	aadd( self:valueNames, name )
	//?? 'NAME:',name, vType, chr(10)

return o

/* Set format for named widget */
static function ui_setFormat(self, widget, name, type, length, decLen, format, flags)
	local fDesc:=map()
	if empty(widget) .or. empty(name)
		return NIL
	endif
	fDesc:type 		:= iif(.not. empty(type), lower(type), "string")
	fDesc:length 	:= iif(valtype(length)=="N", length, iif(valtype(length)=="C", val(length), 0))
	fDesc:decLen 	:= iif(valtype(decLen)=="N", decLen, iif(valtype(decLen)=="C", val(decLen), 0))
	fDesc:format 	:= iif(empty(format), "", format)
	fDesc:flags		:= iif(empty(flags), "", flags)
	aadd(self:valueTypes2, { widget, name, fDesc })
return NIL

/* Set all values to widgets defined by function setName() */
static function ui_setValues(self, values)
	local i, w, v, vfl
	for i in values
		if valtype(i) != 'A' .or. len(i) < 2
			loop
		endif
		vfl := ascan(self:valueTypes2, {|e| upper(i[1])==upper(e[2]) })
		if vfl > 0
			w := mapget(self:value, self:valueTypes2[vfl][1], NIL)
			v := _val2w( i[2], self:valueTypes2[vfl][3] )
		elseif len(self:valueTypes2) > 0
			loop
		else
			w := mapget(self:value, i, NIL)
			v := i[2]
		endif
		
		if "SETVALUE" $ w
			w:setValue( v )
		endif
	next
return 0

/* Get all values from widgets defined by function setName() */
static function ui_getValues(self)
	local i, w, v, values := array(0), rn, vfl
	for i in self:valueNames
		rn := i
		vfl := ascan(self:valueTypes2, {|e| upper(i)==upper(e[1]) })
		if vfl > 0
			w := mapget(self:value, self:valueTypes2[vfl][1], NIL)
			rn := self:valueTypes2[vfl][2]
		elseif len(self:valueTypes2) > 0
			loop
		else
			//?? "valtype:", valtype(i), i, valtype(self:value), len(mapkeys(self:value)), chr(10)
			w := mapget(self:value, i, NIL)
		endif
		if valtype(w) == "O" .and. "GETVALUE" $ w ;
					.and. w:className != 'UIButton' ; // Only object's field, without buttons
					.and. w:className != 'UITable' ;
					.and. w:className != 'UITree'
			v := w:getValue()
			aadd(values, { rn, iif(vfl==0, v, _w2val(v, self:valueTypes2[vfl][3])) } )
		endif
	next
return values

/* Get value from widget defined by its name */
static function ui_val(self, name)
	local o:=mapget(self:value,name,NIL)
	if o == NIL .or. .not. 'GETVALUE' $ o
		return NIL
	endif
return o:getValue()

/* Set focus to specified widget */
static function ui_setFocus(self, obj)
	if self:className == 'UIChildWindow' .or. self:className == "UIDocument"
		driver:setFocus(self:parent, obj)
	else
		driver:setFocus(self, obj)
	endif
return NIL

/* Set default pushbutton */
static function ui_setDefault(self, obj)
	driver:setDefault(self, obj)
return NIL

/* Return values to another form */
static function ui_return(self, val)
	local act
    //?? "RETURN value:",valtype(val), val,"|", "RETURNACTION" $ self, valtype(self:returnAction), chr(10)
	if "RETURNACTION" $ self .and. valtype(self:returnAction) == "B"
		act := self:returnAction
		eval(act, val)
	endif
return NIL

/* Return id and context from table to another form */
static function ui_select(self, table, column)
	local act, obj:=NIL, val:=''
    
    //?? "RETURN value:","RETURNACTION" $ self, valtype(self:returnAction), chr(10)
	if "RETURNACTION" $ self .and. valtype(self:returnAction) == "B"
		act := self:returnAction
		obj := mapget(self:value, table, NIL)
		
		//?? valtype(obj), "GETSELECTIONID" $ obj , "GETSELECTIONFIELD" $ obj, chr(10)
		if .not. empty(obj) .and. "GETVALUE" $ obj
			val := obj:getValue()
		endif
		
		// Append context if exist
		if "CONTEXT" $ self .and. .not. empty(self:context)
			val := { val, self:context }
		endif
		
		//?? "RETURNED:", val,chr(10)
		eval(act, val)
	
	endif

return NIL

/* Compare values in windows with original object */
static function ui_isChanged(self)
	local orig, frm, i, mk, e, name, ind

	orig := self:origObj
	frm  := self:getObj()

	// Check compared objects
	if "ID" $ frm
		orig:id := frm:id
	endif
	if COMPARE_DEBUG
		?? "FORM:", frm, chr(10)
		?? "ORIGINAL:", orig, chr(10)
	endif

	if self:objId == NIL
		// object never is been stored
		// check non-empty fields
		mk := mapkeys(frm)
		for i=1 to len(mk)
			name := mk[i]
			if .not. empty(frm[name])
				if COMPARE_DEBUG; ?? "CHANGED:",name,frm[name],chr(10);endif
				return .T.
			endif
		next
		return .F.
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
	if COMPARE_DEBUG; ?? "COMPARE:",mk,"&\n";endif
	for i=1 to len(mk)
		e := mk[i]
		if COMPARE_DEBUG
			ind := alltrim(str(i))+"/"+alltrim(str(len(mk)))
			?? "    "+ind+":", e
			?? "", e $ frm
			?? "", valtype(orig[e]), orig[e]
			?? "", valtype(frm[e]), frm[e]
			?? "", compareAnyValue(orig[e], frm[e])
			?? chr(10)
		endif
		if .not. e $ frm
			if COMPARE_DEBUG; ?? "compare: no key from original in checked form&\n"; endif
			return .T.
		elseif .not. compareAnyValue(orig[e], frm[e])
			if COMPARE_DEBUG; ?? "compare: value",orig[e],"is changed, new:",frm[e],"&\n"; endif
			return .T.
		endif
	next
	if COMPARE_DEBUG; ?? "compare: objects are equivalent.&\n";endif
return .F.

static function compareAnyValue(a, b)
	if valtype(a) == valtype(b)
		return a == b
	endif
	if valtype(a)=='D'
		b := ctod(b)
	endif
	if valtype(a)=='N'
		b := val(b)
	endif
return a == b

static function ui_setId(self, id)
	self:objId := id
return

/* Set action to shortcut in specified window  */
static function ui_setkeyEvent(self, cKey, action)
	local oKey,i
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

/* Stop any active timers of window */
static function _stopTimers(self)
	local i, timer
	if .not. "TIMERS" $ self .or. len(self:timers) == 0
		return NIL
	endif
	for i:=1 to len(self:timers)
		timer := self:timers[i]
		timer:stop()
	next
return NIL

/* Set window padding */
static function ui_setPadding(self, padding)
	if "USERSPACE" $ self
		self:userSpace:setPadding( padding )
	endif
return NIL

/* Set window spacing */
static function ui_setspacing(self, spacing)
	if "USERSPACE" $ self
		self:userSpace:setspacing( spacing )
	endif
return NIL

/* Raw widget value -> Formatted value */
static function _w2val(v, format)
	local nv:=v, fmt
	
	if valtype(format) != 'O'
		return v
	endif
	switch valtype(v)
		case 'O', 'A'
			// As is
		case 'L'
			// Boolean
			if format:type == 'string'
				nv := iif(v, 'true', 'false')
			elseif format:type == 'number'
				nv := iif(v, 1, 0)
			elseif format:type == 'boolean' .or. format:type == 'logical'
				nv := v
			elseif format:type == 'date'
				nv := ''
			elseif format:type == 'array'
				nv := { v }
			else
				nv := v
			endif
		case 'N'
			// Number
			if format:type == 'string'
				nv := str(v, format:length, format:decLen)
			elseif format:type == 'number'
				nv := v
			elseif format:type == 'boolean' .or. format:type == 'logical'
				nv := (v != 0)
			elseif format:type == 'date'
				nv := ''
			elseif format:type == 'array'
				nv := { v }
			else
				nv := v
			endif
		case 'C'
			// String
			if format:type == 'string'
				nv := v
			elseif format:type == 'number'
				nv := val(v)
			elseif format:type == 'boolean' .or. format:type == 'logical'
				nv := lower(v) == 'true'
			elseif format:type == 'date'
				fmt := iif(len(format:format) > 0, format:format, iif(len(v)==10,"dd.mm.yyyy","dd.mm.yy"))
				nv := ctod(v, fmt)
			elseif format:type == 'array'
				nv := { v }
			else
				nv := v
			endif
		case 'D'
			// Date
			if format:type == 'string'
				fmt := iif(len(format:format) > 0, format:format, iif(len(v)==10,"dd.mm.yyyy","dd.mm.yy"))
				nv := dtoc(v, fmt)
			elseif format:type == 'number'
				nv := ''
			elseif format:type == 'boolean' .or. format:type == 'logical'
				nv := ''
			elseif format:type == 'date'
				nv := v
			elseif format:type == 'array'
				nv := { v }
			else
				nv := ''
			endif
		case 'U'
			// NIL
			if format:type == 'string'
				nv := ''
			elseif format:type == 'number'
				nv := 0
			elseif format:type == 'boolean' .or. format:type == 'logical'
				nv := .F.
			elseif format:type == 'date'
				nv := ''
			elseif format:type == 'array'
				nv := {}
			else
				nv := v
			endif
		otherwise
			?? 'Unsupported type of value: ', valtype(v), chr(10)
	endswitch
return nv

/* Formatted value -> Raw widget value */
static function _val2w(v, format, class)
	local nv:=v, fmt

	if valtype(format) == 'O'
		if valtype(v) == 'N'
			nv := str(v, format:length, format:decLen)
		elseif valtype(v) == 'D'
			fmt := iif(len(format:format) > 0, format:format, iif(len(v)==10,"dd.mm.yyyy","dd.mm.yy"))
			nv := dtoc(v, fmt)
		endif
	endif

return nv
