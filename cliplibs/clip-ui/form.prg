/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library									   */
/*																		   */
/*   Copyright (C) 2003-2007 by E/AS Software Foundation 				   */
/*   Authors: 															   */
/*  	     Andrey Cherepanov <skull@eas.lrn.ru>						   */
/*           Igor Satsyuk <satsyuk@tut.by>                                 */
/*   																	   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include "clip-ui.ch"

#define DEBUG	.F.

static driver := getDriver()

/* Interface form class */
function UIForm( fileName, parent, context )
	local obj	:= map()
	obj:parent	:= parent
	obj:className	:= "UIForm"
	obj:fileName	:= fileName
	obj:oXml 	:= NIL
	obj:widgets	:= map()
	obj:names	:= array(0)
	obj:actions	:= array(0)
	obj:src		:= NIL
	obj:locale	:= map()
	obj:context := context
	_recover_UIFORM(obj)
return obj

function _recover_UIFORM( obj )
	obj:parseFile		:= @ui_parseFile()
	obj:parseString		:= @ui_parseString()
	obj:parse			:= @ui_parse()
	obj:createWidget 	:= @ui_createWidget()
	obj:setProperty		:= @ui_setProperty()
	obj:getPropertyValue := @ui_getPropertyValue()
	obj:setAction		:= @ui_setAction()
	obj:setPreAction  	:= @ui_setPreAction()
	obj:actionHandler 	:= @ui_actionHandler()
	obj:subActionHandler := @ui_subActionHandler()
	obj:i18n 			:= @ui_form_i18n()
	obj:setValues		:= @ui_setValues()
return obj

/* Parse form from file */
static function ui_parseFile(self)
	local fileName

	fileName := self:fileName
	set translate path off
	
	if DEBUG
		?? "UIForm: file parsing...&\n"
	endif
	// Parse file
	self:oXml := XMLTree()
	if .not. self:oXml:parseFile( fileName )
		?? "ERROR: Cannot open form file '"+fileName+"': "+self:oXml:getError()+chr(10)
		return NIL
	endif
	if DEBUG
		?? "UIForm: file parsing complete&\n"
	endif

return self:parse()

/* Parse form from string */
static function ui_parseString(self, str)

	if DEBUG
		?? "UIForm: string parsing...&\n"
	endif
	// Parse string
	self:oXml := XMLTree()
	if .not. self:oXml:parseString( str )
		?? "ERROR: Cannot open form file: "+self:oXml:getError()+chr(10)
		return NIL
	endif

	if DEBUG
		?? "UIForm: string parsing complete&\n"
	endif

return self:parse()

/* Parse form */
static function ui_parse(self)
	local win := NIL, res, t, i

	if DEBUG
		?? "UIForm: form parsing...&\n"
	endif
	if self:oXml:getRoot() == NIL
		?? "ERROR: there isn't root element.&\n"
		return NIL
	else
		self:root := self:oXml:getRoot()
	endif

	// Check version
	if lower(self:root:getName()) == "glade-interface"
		
		// Clade 3.x form support
		self:root := ui_convertFromGlade3( self:root )
	
	elseif lower(self:root:getName()) == "ui" .and. left(self:root:attribute("version",""), 2) == "3."
		
		// Qt Designer 3.x form support
		self:root := ui_convertFromUI3( self:root )
	
	elseif lower(self:root:getName()) == "form"
	
		// Noting do: native format
		
	else
		?? "ERROR: Unknown form format.&\n"
		return NIL
	endif

	/* Locale */
	self:locale := getLocaleStrings(self:root)

	/* Root widget */
	res := self:root:XPath("/interface/widget")
	if empty(res) .or. len(res) == 0
		?? "ERROR: no root widget!&\n"
		return NIL
	endif
	t := res[1]
	//?? "PARENT window for form: ",valtype(self:parent),chr(10)
	if DEBUG
		?? "UIForm: create widgets...&\n"
	endif
	win := ui_createWidget(self, t, self:parent)
	if empty(win)
		return NIL
	endif
	if DEBUG
		?? "UIForm: set properties...&\n"
	endif

	/* Set properties */
	t := self:root:XPath("/style/*")
	for i in t
		ui_setProperty(self, i, NIL)
	next

	if DEBUG
		?? "UIForm: set value names...&\n"
	endif

	/* Set value format */
	t := self:root:XPath("/data/*")
	for i in t
		ui_setValues(self, win, i)
	next

	if DEBUG
		?? "UIForm: set actions...&\n"
	endif
	/* Set actions */
	t := self:root:XPath("/actions/*")
	for i in t
		ui_setAction(self, i, NIL)
	next

	if DEBUG
		?? "UIForm: set preliminary actions...&\n"
	endif
	/* Set pre actions */
	res := self:root:XPath("/head")
	if empty(res) .or. len(res) == 0
		?? "ERROR: no <head> tag!&\n"
		return NIL
	endif
	
	self:setPreAction(res[1], NIL)
	if DEBUG
		?? "UIForm: form parsing complete&\n"
	endif

return win

/**/
static function ui_TableColumns(self, t)
	local a, e, i, o
	local p_a, p_col, p_name, p_value, p_block
	
	// Get columns
	a := array(0)
	for e in t:getChilds()
		if e:getName() == "column"
			aadd( a, UITableColumn( e:attribute("name"), self:i18n(e:attribute("title","")), TABLE_COLUMN_TEXT)  )
		endif
	next
	
	// Get column attributes
	for e in t:getChilds()
		if e:getName() == "property"
			if .not. "." $ e:attribute("name")
				loop
			endif
			p_a     := split(e:attribute("name"), '\.')
			p_col   := p_a[1]
			p_name  := p_a[2]
			p_value := e:attribute("value")
			i := ascan(a, {|e| e:name == p_col })
			if i>0
				o := a[i]
				switch lower(p_name)
					case 'caption'
						o:caption := self:i18n(p_value)
					case "type"
						switch lower(p_value)
							case 'text'
								o:type := TABLE_COLUMN_TEXT
							case 'choice'
								o:type := TABLE_COLUMN_CHOICE
							case 'combobox'
								o:type := TABLE_COLUMN_COMBO
							case 'number'
								o:type := TABLE_COLUMN_NUMBER
								o:default := iif(empty(o:default), 0, o:default)
								o:format := iif(empty(o:format), "%'.2f", o:format)
							case 'date'
								o:type := TABLE_COLUMN_DATE
							case 'boolean'
								o:type := TABLE_COLUMN_CHECK
								o:default := iif(empty(o:default), .F., o:default)
							case 'counter'
								o:type := TABLE_COLUMN_COUNTER
								o:default := iif(empty(o:default), 0, o:default)
							otherwise
								?? "EditTable widget doesn't support column type '"+p_value+"'.&\n"
						endswitch
					case 'editable'
						o:editable := iif( lower(p_value)=='false' .or. lower(p_value)=='no', .F., .T. )
					case 'format'
						o:format := p_value
					case 'source'
						if "," $ p_value
							p_value := strtran(p_value, chr(10), "")
							p_block := "{|| {"+p_value+"} }"
							p_value := eval(&p_block)
						endif
						o:source := UISource(p_value)
					case 'lookup'
						o:lookup := iif( lower(p_value)=='false' .or. lower(p_value)=='no', .F., .T. )
					case 'default'
						o:default := p_value
					otherwise
						?? "EditTable widget doesn't support property '"+p_name+"'.&\n"
				endswitch
			endif
		endif
	next
return a


/* Return created widget from tag */
static function ui_createWidget(self, tag, parent )
	local o:=NIL, class, name, label, c, i, a, e, w, box, t:=tag
	local add:=.F., gCol:=1, gRow:=1, gClass, rule, expanded:=.F.

	class := t:attribute("class","")
	name  := t:attribute("name","")
	label := self:i18n( t:attribute("label","") )
	rule  := t:attribute("rule",NIL)

	if right(name,1) == '+' // Widget should be expanded
		name := substr(name,1,len(name)-1)
		expanded := .T.
	endif

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
			if ascan(t:childs,{|e| e:getName() == "widget" }) == 0
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
		case "TOOLBARSEPARATOR"
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
			// Get columns
			a := ui_TableColumns(self, t)
			// Create table
			if len(a) > 0
				o := UITable( a )
				add = .T.
			else
				?? "No defined columns for UITable widget&\n"
			endif
		case "TREE"
			// Get columns
			a := ui_TableColumns(self, t)
			// Create tree
			if len(a) > 0
				o := UITree( a, 1 )
				add = .T.
			else
				?? "No defined columns for UITree widget&\n"
			endif
		case "EDITTABLE"
			// Get columns
			a := ui_TableColumns(self, t)
			// Create table
			if len(a) > 0
				o := UIEditTable( a )
				add = .T.
			else
				?? "No defined columns for UIEditTable widget&\n"
			endif
		case "BUTTONBAR"
			if "ACTIONS" $ parent
				o := parent:actions
			else
				o := UIButtonBar( parent )
				add = .T.
			endif
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
		case "CHOICE"
			o := UIChoice()
			add := .T.
		case "CHECKBOX"
			o := UICheckBox(,label)
			add = .T.
		case "COMBOBOX"
			o := UIComboBox(label)
			add = .T.
		case "IMAGE"
			o := UIImage( iif(isfunction("GETRESOURCE"), ;
				clip("GETRESOURCE", label), label) )
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
		case "TABAREA"
			o := UITabArea()
			add = .T.
		case "TAB"
			o := UITab(label, name)
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
			w:valueTypes[name] := t:attribute("type",NIL)
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
		if "ADD" $ box
			if gClass:className == "UIGrid" .or. gClass:className == "UILayout"
				gRow := t:attribute("pos","")
				parent:add( o, gRow )
			elseif gClass:className == "UISplitter"
				if empty( parent:first )
					parent:add( o )
				else
					parent:addEnd( o )
				endif
			else
				if 	     o:className=="UISplitter" ;
					.or. o:className=="UITabArea" ;
					.or. o:className=="UIEditText" ;
					.or. o:className=="UITable" ;
					.or. o:className=="UITree" ;
					.or. o:className=="UIEditTable" ;
					.or. expanded
					box:add( o, .T., .T. )
				else
					box:add( o, .F., iif(box:className=="UIButtonBar",.T.,.F.) )
				endif
			endif
		endif
	endif

	t:o := o
	/* Loop child widgets */
	if o == NIL
		o := parent
	endif
	for c in t:getChilds()
		if c:getName() == "widget"
			ui_createWidget(self, c, o)
		elseif c:getName() == "property"
			ui_setProperty(self, c, o)
		elseif c:getName() == "rule"
			ui_setAction(self, c, o)
		elseif ascan({"column", "msg"},{|ev| ev==c:getName()}) != 0
			// Nothing do
		else
			?? "WARNING: tag "+c:getName()+" is ignored&\n"
		endif
	next

return o

/* Set property for widget */
static function ui_setProperty(self, tag, obj, value)
	local class, name, widget, row, block, t:=tag, elem, node, nName, nParent, nSibling, nArr

	if t != NIL
		class  := t:attribute("class","")
		name   := t:attribute("name","")
		widget := t:attribute("widget","")
		value  := iif(value==NIL,t:attribute("value",""),value)
		//?? name, value, chr(10)
		if ascan({"rows","cols"},{|ev| ev==name}) > 0
			return .F.
		endif
	endif
	if DEBUG
		?? "UIForm: setProperty() for "+widget+':'+name+' = '+value,chr(10)
	endif

	obj := iif(obj==NIL,mapget(self:widgets,widget,NIL),obj)

	if obj == NIL
		return .F.
	endif
	
	if (obj:className == "UITable" .or. obj:className == "UIEditTable") .and. lower(name) != 'row'
		return .F.
	endif
	
	switch name
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
			if "SETPLACEMENT" $ obj .and. value == "center"
				obj:setPlacement( .T. )
			elseif "SETPOSITION" $ obj
				obj:setPosition(val(value))
			else
				return .F.
			endif
		case "readOnly"
			if .not. "READONLY" $ obj; return .F.; endif
			if value == "true"
				obj:readOnly( .T. )
			endif
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
			if obj:className != 'UITable' .and. obj:className != 'UITree' .and. obj:className != 'UIEditTable'; return .F.; endif
			block := "{|| {"+value+"} }"
			row   := eval(&block)
			elem  := t:attribute("element",NIL)
			if obj:className == 'UITable' .or. obj:className == 'UIEditTable'
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
		case "source"
			if .not. "SETSOURCE" $ obj; return .F.; endif
			if "," $ value
				value := strtran(value, chr(10), "")
				block := "{|| {"+value+"} }"
				value := eval(&block)
			endif
			obj:setSource(value)

		otherwise
			driver:setStyle(obj, name, value, t:attribute("element",NIL))
	endswitch
return .T.

/* Get property value. Lookup under current tag and style */
static function getProperty(tree, obj, name, def)
	local e, widget, class, ret:=def

	if valtype(obj) != "O" .or. obj:className != "XMLTag"
		?? "ERROR: object is broken&\n"
		return def
	endif
	// Child properties
	widget := obj:attribute("name","")
	for e in obj:getChilds()
		if e:attribute("name","")==name
			ret := e:attribute("value",def)
		endif
	next
return ret

/* Return widget property value */
static function ui_getPropertyValue(self, tagObj)
	local val:=NIL, widget, prop, obj

	if valtype(tagObj) != "O" .or. tagObj:className != "XMLTag"
		?? "ERROR: object is broken&\n"
		return NIL
	endif

	widget := tagObj:attribute("widget","")
	prop   := tagObj:attribute("name","")
	obj    := mapget(self:widgets,widget,NIL)
	if DEBUG; ?? 'GET PROPERTY:', prop, chr(10); endif 

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
	
	if prop == "context"
		if DEBUG; ?? 'CONTEXT:', self:context, chr(10); endif
		return self:context
	endif

	if prop == "value" .and. "GETVALUE" $ obj
		if DEBUG; ?? 'VALUE:', obj:getValue(), chr(10); endif
		return obj:getValue()
	endif


return val

/* Set action for widget */
static function ui_setAction(self, tag, lObj)
	local e, obj, widget, signal, events, actions, j, id, labelRule, t:=tag
	local cWidget, a, column

	if t:getName() != "rule"
		?? "WARNING: rule tag must be <rule>. Rule is ignored.&\n"
		return .F.
	endif
	if len(t:getChilds()) == 0
		?? "WARNING: rule is empty. Ignored.&\n"
		return .F.
	endif

	// TODO: labelled form rule support on menu
	labelRule := self:i18n( t:attribute("label",NIL) )
	if .not. empty(labelRule)
//		?? "Action:",labelRule,chr(10)
	endif

	// Retrieve data
	events  := array(0)
	actions := array(0)
	for e in t:getChilds()
		if e:getName() == "event"
			// Event condition
			column := NIL
			widget := e:attribute("widget","")
			if ':' $ widget
				a := split(widget, '\:')
				widget := a[1]
				column := a[2]
			endif
			signal := e:attribute("signal","")
			obj := iif(lObj==NIL,mapget(self:widgets,widget,NIL),lObj)
			if obj == NIL .or. empty(widget) .or. empty(signal)
				?? "WARNING: widget '"+widget+"' is not found. Ignored&\n"
				return .F.
			endif
			aadd(events,{ obj, signal, column })
		elseif e:getName() == "action"
			// Actions
			if len(events) == 0
				?? "WARNING: condition is not found. Ignored&\n"
				return .F.
			endif
			for j in e:getChilds()
				widget := j:attribute("widget",NIL)
				/*if valtype(widget) == 'C'
					cWidget := widget
				elseif valtype(widget) == 'O'
					cWidget := '{'+widget:className+'}'
				else
					cWidget := '<unknown>'
				endif
				//?? "set action for widget "+cWidget,chr(10)
				if .not. empty(widget)
					j:setAttribute( "widget", mapget(self:widgets,widget,NIL) )
				endif*/
				aadd(actions, j)
			next
		else
			?? "WARNING: unknown tag "+e:getName()+" in '"+self:fileName+"'. Ignored&\n"
		endif
	next

	// Set actions
	aadd(self:actions, actions)
	id := len(self:actions)
	for e in events
		obj := e[1]
		signal := e[2]
		if "SETACTION" $ obj
			if empty(e[3])
				obj:setAction(signal,{|| self:actionHandler( id ) })
			else
				obj:setAction(signal,{|| self:actionHandler( id ) }, e[3])
			endif
		else
			//?? "WARNING: cannot link action to widget class '"+obj:className+"'&\n"
		endif
	next

return .T.

/* Set pre action for form */
static function ui_setPreAction(self, tag, lObj)
	local e, widget, actions, id, t:=tag, cWidget

	// Retrieve data
	actions := array(0)
	for e in t:getChilds()
		if e:getName() == "call"
			widget := e:attribute("widget",NIL)
			/*if valtype(widget) == 'C'
				cWidget := widget
			elseif valtype(widget) == 'O'
				cWidget := '{'+widget:className+'}'
			else
				cWidget := '<unknown>'
			endif
			//?? "set pre action for widget "+cWidget,chr(10)
			if .not. empty(widget)
				e:setAttribute( "widget", mapget(self:widgets,widget,NIL) )
			endif*/
			//?? "post widget:",valtype(e:attribute("widget")),chr(10)
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
		acts := id:getChilds()
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
	local e, c, p, params:=array(0), tmp

	if tag:getName() == "returnedvalue"
		if DEBUG; ?? "returned value:", addVal, chr(10); endif
		return addVal
	endif
	if tag:getName() == "property"
		if len(tag:getChilds()) > 0
//			?? "val ->",addVal,chr(10)
			value := self:subActionHandler(tag:getChild(1),addVal)
//			?? "SET PROPERTY", valtype(value), chr(10)
			self:setProperty(tag, NIL, value)
			return NIL
		else
			return self:getPropertyValue( tag )
		endif
	endif
	if tag:getName() == "condition"
		// Form condition
		condVal := NIL
		iArr := tag:getChilds()
//		?? "CONDITION CHECK...&\n"
		for i=1 to len(iArr)
			e := iArr[i]
			if e:getName() == "param" .and. len(e:getChilds()) == 1
				condVal := self:subActionHandler(e:getChild(1), addVal)
//				?? "checked value:",condVal,chr(10)
			endif
			if e:getName() == "case"
				chkVal := e:attribute("value", NIL)
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

	widget := tag:attribute("widget","")
	method 	:= upper(tag:attribute("method",""))
	
	//?? "call "+iif(valtype(widget)=='C',widget,"")+":"+method+"()",tag:getAttributes(),"&\n"
	
	c := tag:getChilds()
	for p in c
		switch p:getName()
		case "param"
			if p:attribute("value") != NIL
				// Constant value
				aadd(params,p:attribute("value"))
			else
				// Recursive call
				if len(p:getChilds()) > 0
					aadd(params, self:subActionHandler(p:getChild(1),addVal))
				else
					?? "WARNING: parameter has no value&\n"
					aadd(params, NIL)
				endif
			endif
		case "return"
			// Bind action on form creation
//          ?? "SET RETURN HANDLER", self:fileName, ret, chr(10)
			retAction := {|ret| self:actionHandler(p,ret)}
			if method == "OPEN"
				asize(params, 2)
			endif
			if method == "DIALOGBOX"
				asize(params, 4)
			endif
			aadd(params, retAction)
		otherwise
			?? "WARNING: Illegal tag <"+str(p:name)+">'&\n"
		endswitch
	next

	outlog("CALL", method, "...")
	if valtype(widget) == "C"
		widget := mapget(self:widgets, widget, NIL)
	endif

	//?? "call widget: ", valtype(widget), iif(valtype(widget)=='O',widget:className,""),chr(10)
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

/* Set value format */
static function ui_setValues(self, win, t)
	if valtype(win) != 'O' .or. .not. 'SETFORMAT' $ win .or. valtype(t) != 'O'
		return NIL
	endif
	// name, type, length, decLen, format, add
	win:setFormat( 	t:attribute('widget'), ;
					t:attribute('name'), ;
					t:attribute('type'), ;
					t:attribute('length'), ;
					t:attribute('decLen'), ;
					t:attribute('format'), ;
					t:attribute('flags') ;
				 )
return NIL
