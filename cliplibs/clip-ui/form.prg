/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation 	           */
/*   Authors: 								   */
/*  	     Andrey Cherepanov <skull@eas.lrn.ru>			   */
/*           Igor Satsyuk <satsyuk@tut.by>                                 */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

static driver := getDriver()

/* Interface form class */
function UIForm( fileName, parent )
	local obj	:= map()
	obj:parent	:= parent
	obj:className	:= "UIForm"
	obj:fileName	:= fileName
	obj:root 	:= NIL
	obj:widgets	:= map()
	obj:names	:= array(0)
	obj:actions	:= array(0)
	obj:src		:= NIL
	obj:locale	:= map()
	_recover_UIFORM(obj)
return obj

function _recover_UIFORM( obj )
	obj:parseFile	:= @ui_parseFile()
	obj:parseString	:= @ui_parseString()
	obj:parse	:= @ui_parse()
	obj:createWidget := @ui_createWidget()
	obj:setProperty	:= @ui_setProperty()
	obj:getPropertyValue := @ui_getPropertyValue()
	obj:setAction	:= @ui_setAction()
	obj:setPreAction  := @ui_setPreAction()
	obj:actionHandler := @ui_actionHandler()
	obj:subActionHandler := @ui_subActionHandler()
	obj:i18n := @ui_form_i18n()
return obj

/* Parse form from file */
static function ui_parseFile(self)
	local fileName, hFile, oHtml

	fileName := self:fileName
	set translate path off
	hFile := fopen(fileName,0)
	if hFile < 0
		?? "ERROR: Cannot open form file '"+fileName+"':"+ferrorstr()+chr(10)
		return NIL
	endif
	oHtml := htmlParserNew()
	do while !fileeof(hFile)
		oHtml:put(freadstr(hFile,1024))
	enddo
	fclose(hFile)
	oHtml:end()
	self:src := @oHtml
return self:parse()

/* Parse form from string */
static function ui_parseString(self, str)
	local oHtml
	oHtml := htmlParserNew()
	oHtml:put( str )
	oHtml:end()
	self:src := @oHtml
return self:parse()

/* Parse form */
static function ui_parse(self)
	local oHtml, oTag, ct:=NIL, pt:=NIL, attrName, attrData
	local win := NIL, t, i

	oHtml := self:src

	/* Parse all tags */
	do while !oHtml:empty()
		oTag:=oHtml:get()
		if valtype(oTag)!='O' // Garbage, not tag
			loop
		endif
		if oTag:tagName == '!' // Comment
			loop
		endif

		if oTag:tagName == "?XML"
			//self:encoding := mapget(oTag:fields,"ENCODING",self:encoding)
			loop
		endif
		if oTag:tagName == "FORM"
			self:root := XMLTag(oTag:tagName)
			pt := self:root
			loop
		endif

		if substr(oTag:tagName,1,1) == "/"
			pt := pt:parent
			loop
		endif

		/* Regular tag */
		ct := XMLTag(oTag:tagName)
		ct:parent := pt
		for i=1 to len(oTag:fieldsOrder)
			attrName := oTag:fieldsOrder[i]
			attrData := strtran(oTag:fields[attrName],"&amp;","&")
			attrData := strtran(attrData,"&lt;","<")
			attrData := strtran(attrData,"&gt;",">")
			attrData := strtran(attrData,"&quot;",'"')
			aadd(ct:attrNames, attrName)
			ct:attr[attrName] := attrData
		next
		if valtype(pt) == "O" .and. "CHILDS" $ pt
			aadd(pt:childs, ct)
		else
			?? "ERROR parse XML: parent object is empty. Possible tag <FORM> doesn't found or it isn't root element.&\n"
		endif

		if .not. oTag:closed
			pt := ct
		endif
	enddo

	if self:root == NIL
		?? "ERROR: there isn't root element.&\n"
                return win
	endif

	/* Locale */
	self:locale := getLocaleStrings(self:root)
	
	
	/* Root widget */
	t := XMLGetTag(self:root, "INTERFACE.WIDGET")
	if empty(t)
		?? "ERROR: not root widget!&\n"
		return NIL
	endif
//	?? "PARENT window for form: ",valtype(self:parent),chr(10)
	win := ui_createWidget(self, t, self:parent)
	if empty(win)
		return NIL
	endif

	/* Set properties */
	t := XMLGetTag(self:root, "STYLE")
	for i in t:childs
		ui_setProperty(self, i, NIL)
	next

	/* Set actions */
	t := XMLGetTag(self:root, "ACTIONS")
	for i in t:childs
		ui_setAction(self, i, NIL)
	next
       	
	/* Set pre actions */
	t := XMLGetTag(self:root, "HEAD")
	self:setPreAction(t, NIL)

return win

/* Return created widget from tag */
static function ui_createWidget(self, tag, parent )
	local o:=NIL, class, name, label, c, i, a, e, w, box, t:=tag
	local add:=.F., gCol:=1, gRow:=1, gClass, rule

	class := mapget(t:attr,"CLASS","")
	name  := mapget(t:attr,"NAME","")
	label := self:i18n(mapget(t:attr,"LABEL",""))
	rule  := mapget(t:attr,"RULE",NIL)

	switch upper(class)
                /* Grid */
		case "HBOX"
			o := UIHBox()
			add := .T.
                case "VBOX"
			o := UIVBox()
			add := .T.
                case "HSPLITTER"
			o := UISplitter(SPLITTER_HORIZONTAL)
			add := .T.
                case "VSPLITTER"
			o := UISplitter(SPLITTER_VERTICAL)
			add := .T.
                case "GRID"
                        gCol := val(getProperty(self:root, t, "cols"))
                        gRow := val(getProperty(self:root, t, "rows"))
			o := UIGrid(, gRow, gCol)
			add := .T.
                case "LAYOUT"
			o := UILayout()
			add := .T.

		/* Widgets */
		case "MAINWINDOW"
			o := UIMainWindow(label,name)
			self:w := o
			if empty(o)
				return NIL
			endif
		case "WINDOW"
			o := UIWindow(label,parent,name,.F.)
			self:w := o
			if empty(o)
				return NIL
			endif
		case "CHILDWINDOW"
			o := UIChildWindow(label,parent,name)
			self:w := o
			if empty(o)
				return NIL
			endif
		case "DOCUMENT"
			o := UIDocument(label,parent,name)
			self:w := o
			if empty(o)
				return NIL
			endif
		case "MENUBAR"
			o := UIMenu()
			parent:setPanels(o,,)
		case "MENUITEM"
                	if ascan(t:childs,{|e| e:name == "WIDGET" }) == 0
				i := parent:add(,label,)
				o := parent:elem[i]
			endif
		case "MENUCHECKEDITEM"
			i := parent:addChecked(,label,NIL)
			o := parent:elem[i]
		case "POPUPMENU"
			o := UIPopupMenu()
			parent:add(,label,o)
		case "MENUSEPARATOR"
			parent:addSeparator()
			return NIL
		case "TOOLBAR"
			o := UIToolBar()
			parent:setPanels(,o,)
		case "TOOLBUTTON"
			i := parent:addButton(NIL,label,NIL)
			o := parent:elem[i]
		case "STATUSBAR"
			o := UIStatusBar()
			parent:setPanels(,,o)
			o:setText(label)
		case "TABLE"
			a := array(0)
			for e in t:childs
				if e:name == "COLUMN"
					aadd( a, self:i18n(e:attr["TITLE"]))
				endif
			next
			o := UITable( a )
			add = .T.
		case "TREE"
			a := array(0)
			for e in t:childs
				if e:name == "COLUMN"
					aadd( a, self:i18n(e:attr["TITLE"]))
				endif
			next
			o := UITree( 1, a )
			add = .T.
		case "SHEET"
			a := array(0)
			for e in t:childs
				if e:name == "COLUMN"
					aadd( a, self:i18n(e:attr["TITLE"]))
				endif
			next
			o := UISheet( a )
			add = .T.
		case "BUTTONBAR"
			//if "ACTIONS" $ self:w
			//	o := parent:actions
			//else
			o := UIButtonBar( parent )
			add = .T.
			//endif
		case "BUTTON"
			o := UIButton( label, NIL)
			add = .T.
		case "LABEL"
			o := UILabel(label)
			add = .T.
		case "EDIT"
			o := UIEdit()
			add = .T.
		case "EDITTEXT"
			o := UIEditText()
			add = .T.
		case "EDITDATE"
			o := UIEditDate()
			add = .T.
		case "EDITFILENAME"
			o := UIEditFileName()
			add = .T.
		case "EDITCOLOR"
			o := UIEditColor()
			add = .T.
		case "CHECKBOX"
			o := UICheckBox(,label)
			add = .T.
		case "COMBOBOX"
			o := UIComboBox()
			add = .T.
		case "RADIOGROUP"
			o := UIRadioGroup()
			o:box := parent
		case "RADIOBUTTON"
			if parent:className == "UIRadioGroup"
				o := parent:addButton(label)
				parent := parent:box
				add = .T.
			else
				?? "WARNING: radiobutton must be placed into radiogroup&\n"
			endif
		case "FRAME"
			o := UIFrame(label)
			add = .T.
		case "PROGRESSBAR"
			o := UIProgressBar(label)
			add = .T.
		case "SLIDER"
			o := UISlider()
			add = .T.
        	otherwise
			?? "WARNING: Unknown class:",class,chr(10)
	endswitch
	if .not. empty(name)
        	aadd(self:names,name)
		self:widgets[name] := o
		if "W" $ self
			w := self:w
			w:setName(name,o)
			w:valueTypes[name] := mapget(t:attr,"TYPE",NIL)
		endif
	endif
	if .not. empty(rule) .and. .not. empty(self:w) .and. "SYSMENUS" $ self:w
		self:w:sysMenus[rule] := o
//		?? "SYSMENU:",rule,"=",valtype(o),chr(10)
	endif

        /* Add to grid */
	if add == .T.
		gClass := iif("O" $ parent, parent:o, parent)
		box    := iif("USERSPACE" $ parent,parent:userSpace,parent)
		if gClass:className == "UIGrid" .or. gClass:className == "UILayout"
			gRow := mapget(t:attr, "POS", "")
			parent:add( o, gRow )
                elseif gClass:className == "UISplitter"
			if empty( parent:first )
				parent:add( o )
			else	
				parent:addEnd( o )
			endif
		else
			if class=="table" .or. o:className=="UISplitter" .or. o:className=="UIEditText"
				box:add( o, .T., .T. )
			else
				box:add( o, .F., iif(box:className=="UIButtonBar",.T.,.F.) )
			endif
		endif
	endif

	t:o := o
	/* Loop child widgets */
        if o == NIL
        	o := parent
	endif
	for c in t:childs
        	if c:name == "WIDGET"
			ui_createWidget(self, c, o)
		elseif c:name == "PROPERTY"
			ui_setProperty(self, c, o)
		elseif c:name == "RULE"
			ui_setAction(self, c, o)
		elseif ascan({"COLUMN"},{|ev| ev==c:name}) != 0
			// Nothing do
		else
			?? "WARNING: tag "+c:name+" is ignored&\n"
		endif
	next

return o

/* Set property for widget */
static function ui_setProperty(self, tag, obj, value)
	local class, name, widget, row, block, t:=tag, elem, node, nName, nParent, nSibling, nArr

        if t != NIL
		class  := mapget(t:attr,"CLASS","")
		name   := mapget(t:attr,"NAME","")
		widget := mapget(t:attr,"WIDGET","")
		value  := iif(value==NIL,mapget(t:attr,"VALUE",""),value)
		//?? name, value, chr(10)
		if ascan({"rows","cols"},{|ev| ev==name}) > 0
			return .F.
		endif
	endif

	obj := iif(obj==NIL,mapget(self:widgets,widget,NIL),obj)

	if obj == NIL
		return .F.
	endif
        switch name
		case "altColor"
 			if .not. "SETALTROWCOLOR" $ obj; return .F.; endif
			obj:setAltRowColor(value)
		case "label"
 			if .not. "SETTEXT" $ obj; return .F.; endif
			obj:setText(value)
                case "value"
 			if .not. "SETVALUE" $ obj; return .F.; endif
			if obj:className == "UICheckBox"
				if ascan({"YES","TRUE"}, {|ev| ev==upper(value)}) > 0
					value := .T.
				elseif ascan({"NO","FALSE"}, {|ev| ev==upper(value)}) > 0
					value := .F.
				else	
					return .F.
				endif
			endif
//			?? "VAL: ",value,chr(10)
			obj:setValue(value)
		case "geometry"
 			if .not. "SETGEOMETRY" $ obj; return .F.; endif
                	obj:setGeometry(splitGeom(value,4))
		case "geometry.width"
 			if .not. "SETGEOMETRY" $ obj; return .F.; endif
                        obj:setGeometry(val(value))
		case "geometry.height"
 			if .not. "SETGEOMETRY" $ obj; return .F.; endif
                        obj:setGeometry({,val(value)})
		case "MDI"
 			if .not. "SETMDI" $ obj; return .F.; endif
			if value == "true"
				obj:setMDI()
			endif
		case "spacing"
 			if .not. "SETSPACING" $ obj; return .F.; endif
			obj:setSpacing(val(value))
		case "padding"
 			if .not. "SETPADDING" $ obj; return .F.; endif
			obj:setPadding(val(value))
		case "position"
 			if .not. "SETPLACEMENT" $ obj; return .F.; endif
			if value == "center"
				obj:setPlacement( .T. )
			endif
		case "readOnly"
 			if .not. "READONLY" $ obj; return .F.; endif
			if value == "true"
				obj:readOnly( .T. )
			endif
		case "values"
 			if .not. "SETLIST" $ obj; return .F.; endif
			block := "{|| {"+value+"} }"
			row := eval(&block)
			obj:setList( row )
		case "selection"
			if obj:className != "UIComboBox"; return .F.; endif
			obj:setValue( val(value) )
		case "type"
 			if obj:className != "UIFrame"; return .F.; endif
			switch upper(value)
				case "PLAIN"
					obj:setType(FRAME_PLAIN)
				case "RAISED"
					obj:setType(FRAME_RAISED)
				case "SUNKEN"
					obj:setType(FRAME_SUNKEN)
				case "IN"
					obj:setType(FRAME_IN)
				case "OUT"
					obj:setType(FRAME_OUT)
			endswitch
		case "icon"
 			if .not. "SETICON" $ obj; return .F.; endif
			obj:setIcon(UIImage( iif(isfunction("GETRESOURCE"), ;
				clip("GETRESOURCE", value), value) ) )
		case "row"
			if obj:className != 'UITable' .and. obj:className != 'UITree'; return .F.; endif
			block := "{|| {"+value+"} }"
			row   := eval(&block)
			elem  := mapget(t:attr,"ELEMENT",NIL)
			if obj:className == 'UITable'
				obj:addRow( row, elem )
			else
				if .not. 'NODENAMES' $ obj
					obj:nodeNames := map()
				endif
				nArr     := split(elem, "\.")
				nName    := ''
				nParent  := NIL
				nSibling := NIL
				switch len(nArr)
					case 1
						nName := nArr[1]
					case 2
						nName := nArr[1]
						nParent := mapget(obj:nodeNames,nArr[2],NIL)
					case 3
						nName := nArr[1]
						nParent := mapget(obj:nodeNames,nArr[2],NIL)
						nSibling := mapget(obj:nodeNames,nArr[3],NIL)
				endswitch
				//?? nArr, nName, nParent, nSibling,chr(10)
				obj:nodeNames[nName] := obj:addNode (row, nName, nParent, nSibling) // (columns,id,parent,sibling)
								
			endif
		case "range"
 			if obj:className != "UISlider"; return .F.; endif
                        obj:setRange(value)
		case "step"
 			if obj:className != "UISlider"; return .F.; endif
                        obj:setStep(value)

		otherwise
			driver:setStyle(obj, name, value, mapget(t:attr,"ELEMENT",NIL))
	endswitch
return .T.

/* Get property value. Lookup under current tag and style */
static function getProperty(tree, obj, name, def)
	local e, widget, class, ret:=def

	if valtype(obj) != "O" .or. (.not. "ATTR" $ obj)
		?? "ERROR: object is broken&\n"
		return def
	endif
        // Child properties
        widget := mapget(obj:attr,"NAME","")
	for e in obj:childs
        	if mapget(e:attr,"NAME","")==name
         		ret := mapget(e:attr,"VALUE",def)
		endif
	next

	for e in XMLGetTag(tree, "STYLE")
		if valtype(e) == "O" .and. "attr" $ e
        		if mapget(e:attr,"WIDGET","") == widget .and. mapget(e:attr,"NAME","") == name
         			ret := mapget(e:attr,"VALUE",def)
			endif
		endif
	next

return ret

/* Return widget property value */
static function ui_getPropertyValue(self, tagObj)
        local val:=NIL, widget, prop, obj
	if valtype(tagObj) != "O" .or. (.not. "ATTR" $ tagObj)
		?? "ERROR: object is broken&\n"
		return def
	endif
        widget := mapget(tagObj:attr,"WIDGET","")
        prop   := mapget(tagObj:attr,"NAME","")
	obj    := mapget(self:widgets,widget,NIL)

        if empty(obj)
		?? "ERROR get property for widget '"+widget+"': widget not found&\n"
        	return NIL
	endif

	if prop == "object"
		return obj
	endif
	
	if obj:className == "UIMenuItem" .and. prop == "isChecked"
		return driver:isCheckedMenuItem( obj )
	endif

return val

/* Set action for widget */
static function ui_setAction(self, tag, lObj)
	local e, widget, signal, events, actions, j, id, labelRule, t:=tag

        if t:name != "RULE"
		?? "WARNING: rule tag must be <RULE>. Rule is ignored.&\n"
		return .F.
	endif
        if len(t:childs) == 0
		?? "WARNING: rule is empty. Ignored.&\n"
		return .F.
	endif

	// TODO: labelled form rule support on menu
        labelRule := self:i18n(mapget(t:attr,"LABEL",NIL))
	if .not. empty(labelRule)
//		?? "Action:",labelRule,chr(10)
	endif
	
	// Retrieve data
	events  := array(0)
	actions := array(0)
	for e in t:childs
		if e:name == "EVENT"
		        // Event condition
			widget := mapget(e:attr,"WIDGET","")
			signal := mapget(e:attr,"SIGNAL","")
			obj := iif(lObj==NIL,mapget(self:widgets,widget,NIL),lObj)
			if obj == NIL .or. empty(widget) .or. empty(signal)
				?? "WARNING: widget '"+widget+"' is not found. Ignored&\n"
				return .F.
			endif
			aadd(events,{ obj, signal })
		elseif e:name == "ACTION"
                	// Actions
			if len(events) == 0
				?? "WARNING: condition is not found. Ignored&\n"
				return .F.
			endif
                        for j in e:childs
				widget := mapget(j:attr,"WIDGET",NIL)
                                if .not. empty(widget)
					j:attr["WIDGET"] := mapget(self:widgets,widget,NIL)
				endif
				aadd(actions, j)
			next
		else
			?? "WARNING: unknown tag "+e:name+" in '"+self:fileName+"'. Ignored&\n"
		endif
	next

	// Set actions
        aadd(self:actions, actions)
	id := len(self:actions)
        for e in events
		obj := e[1]
		signal := e[2]
		if "SETACTION" $ obj
			obj:setAction(signal,{|| self:actionHandler( id ) })
		else
			?? "WARNING: cannot link action to widget class '",obj,"'&\n"
		endif
	next

return .T.

/* Set pre action for form */
static function ui_setPreAction(self, tag, lObj)
	local e, widget, actions, id, t:=tag

	// Retrieve data
	actions := array(0)
	for e in t:childs
		if e:name == "CALL"
			widget := mapget(e:attr,"WIDGET",NIL)
			if .not. empty(widget)
				e:attr["WIDGET"] := mapget(self:widgets,widget,NIL)
			endif
        		aadd(actions, e)
		endif
	next
        aadd(self:actions, actions)
	id := len(self:actions)
	self:actionHandler( id )
return .T.

/* Form action handler */
static function ui_actionHandler(self, id, addVal)
	local i, acts
/* DEBUG print
	if valtype(id) != "O"
		?? "Action handler:",valtype(id), id, addVal,chr(10)
	else
		?? "Action handler:",valtype(id), id:name, addVal,chr(10)
        endif
*/
	if valtype(id) == "N"
		acts := self:actions[id]
	else
		acts := id:childs
		//?? "returned:",addVal,chr(10)
	endif

	for i in acts
		self:subActionHandler(i, addVal)
	next
return NIL

/* Recursive action execution */
static function ui_subActionHandler(self, tag, addVal)
	local widget, method, ret, subItem, retAction, value, i, condVal, chkVal
	local iArr
	local c, p, params:=array(0)

	if tag:name == "RETURNEDVALUE"
//		?? "returned value:", addVal, chr(10)
		return addVal
	endif
	if tag:name == "PROPERTY"
		if len(tag:childs) > 0
//			?? "val ->",addVal,chr(10)
			value := self:subActionHandler(tag:childs[1],addVal)
//			?? "SET PROPERTY", valtype(value), chr(10)
			self:setProperty(tag, NIL, value)
			return NIL
		else
			return self:getPropertyValue( tag )
		endif
	endif
	if tag:name == "CONDITION"
		// Form condition
		condVal := NIL
		iArr := tag:childs
//		?? "CONDITION CHECK...&\n"
		for i=1 to len(iArr)
			e := iArr[i]
			if e:name == "PARAM" .and. len(e:childs) == 1
				condVal := self:subActionHandler(e:childs[1], addVal)
//				?? "checked value:",condVal,chr(10)
			endif
			if e:name == "CASE"
				chkVal := mapget(e:attr, "VALUE", NIL)
				if valtype(condVal) == "L"
					chkVal := iif(ascan({"TRUE",".T.","YES"},upper(chkVal))>0,.T.,.F.)
				endif
//				?? "case value:",condVal,"?",chkVal,chr(10)
				if chkVal == condVal
//					?? "CASE:",chkVal,"executing...&\n"
					return self:actionHandler(e,addVal)
				endif
			endif
		next
		return NIL
	endif
		
	widget 	:= mapget(tag:attr,"WIDGET",NIL)
	method 	:= upper(mapget(tag:attr,"METHOD",""))
	c := tag:childs
	for p in c
		switch p:name
		case "PARAM"
			if "VALUE" $ p:attr
				// Constant value
				aadd(params,p:attr["VALUE"])
			else
                        	// Recursive call
				if len(p:childs) > 0
					aadd(params, self:subActionHandler(p:childs[1],addVal))
				else
                                        ?? "WARNING: parameter has no value&\n"
					aadd(params, NIL)
				endif
			endif
		case "RETURN"
                        // Bind action on form creation
//                        ?? "SET RETURN HANDLER", self:fileName, ret, chr(10)
			retAction := {|ret| self:actionHandler(p,ret)}
                        if method == "OPEN"
				asize(params, 2)
			endif
                        if method == "DIALOGBOX"
				asize(params, 4)
			endif
			aadd(params, retAction)
		otherwise
			?? "WARNING: unknown tag",p:name,"&\n"
		endswitch
	next

        outlog("CALL", method, "...")
	if valtype(widget) == "C"
		widget := mapget(self:widgets, widget, NIL)
	endif

	if widget != NIL .and. valtype(widget) == "O"
		if method $ widget .and. valtype(widget[method]) == "B"
			/* TODO: use clipa() or similar function
			aadd( params, NIL )
			ains( params, 1 )
			params[1] := widget
			ret := clipa("func", params)
			*/
			switch len(params)
                               	case 1
					ret := eval(widget[method], widget, params[1])
                               	case 2
					ret := eval(widget[method], widget, params[1], params[2])
                               	case 3
					ret := eval(widget[method], widget, params[1], params[2], params[3])
                               	case 4
					ret := eval(widget[method], widget, params[1], params[2], params[3], params[4])
                               	case 5
					ret := eval(widget[method], widget, params[1], params[2], params[3], params[4], params[5])
                               	case 6
					ret := eval(widget[method], widget, params[1], params[2], params[3], params[4], params[5], params[6])
				otherwise
					ret := eval(widget[method], widget)
			endswitch
		else
			?? "ERROR: no method '"+method+"'&\n"
			return NIL
		endif
	else
		if isfunction( method )
			ret := clipA( method, params )
		else
			?? "ERROR: no function '"+method+"'&\n"
			return NIL
		endif
	endif
//	?? "RETURN:",iif(valtype(ret)=="O","<OBJECT>",ret),chr(10)
return ret

/* Try to localize current string */
static function ui_form_i18n(self, str)
	local lstr:=""
	if str == NIL
		return NIL
	endif
	if valtype(self:locale)=="O" .and. str $ self:locale
		lstr := self:locale[str]
	elseif .not. empty(str)
		// TODO: show untranslated string in debug mode
		//?? self:fileName+": untranslated '"+str+"'&\n"
		lstr := str
	endif
//	?? "i18n:",str,"=>",lstr,chr(10)
return lstr
