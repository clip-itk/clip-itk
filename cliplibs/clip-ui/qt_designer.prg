/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library									   */
/*																		   */
/*   Copyright (C) 2003-2006 by E/AS Software Foundation 				   */
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

#define DEBUG	.T.

static driver  := getDriver()
static styles  := NIL
static actions := NIL
static groups  := NIL
static s_icons := map()
static s_actions := map()
static nCounter	:= 0

/* Convert Qt Designer form (*.ui) to XFL form */

function ui_convertFromUI3( root )
	local r, h, i, l, pp, w
	
	// Create root and sections
	r := XMLTag('form')
	h := XMLTag('head')
	i := XMLTag('interface')
	styles  := XMLTag('style')
	actions := XMLTag('actions')
	groups  := map()
	
	r:addChild(h)
	r:addChild(i)
	r:addChild(styles)
	r:addChild(actions)
	
	nCounter := 0
	
	// Convert widgets
	pp := root:XPath("/widget")
	if valtype(pp) != 'A' .or. len(pp) == 0
		?? "ERROR: Unable to find root widget for UI form.&\n"
		return r
	endif
	
	//Extract icons and actions from Qt Designer .ui file
	ui_extractUI3( root )
	
	// Create widgets
	w := ui_createWidgetFromUI3( pp[1], i, NIL )
	
	if DEBUG
		?? r:dump()
	endif
	
return r

/* Return created widget from tag for UI forms */
static function ui_createWidgetFromUI3(w, parent, subtype)
	local cClass, name:=NIL, label := NIL, c, p
	local x, y, width, height, geom := NIL
	local node, rI, rClass, rName, sNode, t
	local rSubType:="", prop, a, i, j, pos, value
	local row, column, mW, slider:=map(), fixed:=.F., action
	local icon:="", it, itp

	if valtype(w) != 'O'
		return NIL
	endif


	slider:min := "0"
	slider:max := "100"
	slider:step := "10"
	slider:value := "0"

	row := w:attribute("row","")
	column := w:attribute("column","")
	cClass := w:attribute("class",w:getName())
	//?? "CLASS", cClass, row, column, chr(10)
	for c in w:getChilds()
		if upper(c:getName()) == "PROPERTY" .or. upper(c:getName()) == "ATTRIBUTE"
			do switch upper(c:attribute("name"))
				case "NAME"
					p := c:XPath("cstring")
					if valtype(p) == "A" .and. len(p) > 0
						name := p[1]:getText()
					endif
				case "GEOMETRY"
					p := c:XPath("rect")
					if valtype(p) == "A" .and. len(p) > 0
						x := p[1]:XPath("x")
						y := p[1]:XPath("y")
						width  := p[1]:XPath("width")
						height := p[1]:XPath("height")
						geom   := { width[1]:getText(), ;
									height[1]:getText(), ;
									x[1]:getText(), ;
									y[1]:getText() }
					endif
				case "CAPTION", "TEXT", "TITLE", "TEXTLABEL"
					p := c:XPath("string")
					if valtype(p) == "A" .and. len(p) > 0
						label := p[1]:getText()
					endif
				case "MARGIN"
				case "SPACING"
				case "NUMROWS", "NUMCOLS", "SELECTIONMODE", "FOCUSSTYLE"
				case "FRAMESHADOW"
					p := c:XPath("enum")
					if valtype(p) == "A" .and. len(p) > 0
						sNode := XMLTag("property")
						sNode:setAttribute("widget", ui_fixName(name))
						sNode:setAttribute("name",   "type")
						i := lower(p[1]:getText())
						switch i
							case "plain"
								value := "plain"
							case "sunken"
								value := "sunken"
							case "raised"
								value := "raised"
							otherwise
								value := "sunken"
						endswitch
						sNode:setAttribute("value",  value)
						styles:addChild( sNode )
					endif
				case "BUDDY"
					// TODO (link label accel to other widget)
				case "DATE"
					a := array(3)
					a[1] := c:XPath("date/year") 
					a[2] := c:XPath("date/month")
					a[3] := c:XPath("date/day")
					label := a[3][1]:getText() + '.' + a[2][1]:getText() + '.' + right(a[1][1]:getText(),2)
					// TODO: fix date format
				case "MAXIMUMSIZE"
				case "MINVALUE"
					a := c:XPath("number")
					if valtype(a) == "A" .and. len(a) > 0
						slider:min := a[1]:getText()
					endif
				case "MAXVALUE"
					a := c:XPath("number")
					if valtype(a) == "A" .and. len(a) > 0
						slider:max := a[1]:getText()
					endif
				case "LINESTEP"
					a := c:XPath("number")
					if valtype(a) == "A" .and. len(a) > 0
						slider:step := a[1]:getText()
					endif
				case "VALUE"
					a := c:XPath("number")
					if valtype(a) == "A" .and. len(a) > 0
						slider:value := a[1]:getText()
					endif
				case "PAGESTEP", "ORIENTATION"
					// Ignored for slider
 				case "CURRENTITEM" 
					a := c:XPath("number")
					if valtype(a) == "A" .and. len(a) > 0
						label := ltrim(str(val(a[1]:getText())+1))
					endif
 				case "PROGRESS"
					a := c:XPath("number")
					if valtype(a) == "A" .and. len(a) > 0
						label := a[1]:getText()
					endif
				case "EDITABLE", "AUTOCOMPLETION"
				case "WORDWRAP"
				case "MINIMUMSIZE", "FRAMESHAPE"
				case "SIZEPOLICY"
					a := c:XPath("sizepolicy/vsizetype")
					if valtype(a) == "A" .and. len(a) > 0 .and. a[1]:getText() == "0"
						fixed := .T.
					endif
				case "ACCEL"
				case "MOVINGENABLED"
				case "BASESIZE"
				case "SCALEDCONTENTS"
				case "LINEWIDTH"
				case "LABEL"
				case "CHECKED"
				case "ICON", "PIXMAP"
					a := c:XPath("pixmap")
					if valtype(a) == "A" .and. len(a) > 0
						icon := a[1]:getText()
					endif
				case "ICONSET"
					a := c:XPath("iconset")
					if valtype(a) == "A" .and. len(a) > 0
						icon := a[1]:getText()
					endif
				case "ENABLED"
				case "PALETTEFOREGROUNDCOLOR", "PALETTEBACKGROUNDCOLOR"
				case "FONT"
  				otherwise
					?? "Unsupported property:", c:attribute("name"), chr(10)
			end switch
		endif
	next

	// Fix tab widget
	if upper(cClass) == "QWIDGET" .and. parent:attribute("class","") == "tabArea"
		cClass := "QTab"
	endif

	do switch upper(cClass)
		case "QDIALOG", "QMAINWINDOW", "QWIZARD", "QWIDGET"
			node := XMLTag("widget")
			node:hasLayout := .T.
			rI := at('_', name)
			if rI > 0
				rClass := left(name, rI-1)
				rName  := substr(name, rI+1)
				switch lower(rClass)
					case "mainwindow"
						rClass := "mainWindow"
					case "window"
						rClass := "window"
					case "childWindow"
						rClass := "childWindow"
					case "document"
						rClass := "document"
					otherwise
						rClass := "window"  // Default class for window
						rName := name
				endswitch
			else
				rClass := "window"  // Default class for window
				rName := name
			endif
			node:setAttribute("class", rClass)
			node:setAttribute("name",  rName)
			node:setAttribute("label", label)
			
			// Append menu- and tool- bars
			mW := w:XPath("/menubar")
			ui_createWidgetFromUI3( mW[1], node, NIL )
			mW := w:XPath("/toolbars")
			ui_createWidgetFromUI3( mW[1], node, NIL )
			
		case "HBOX"
			if "HASLAYOUT" $ parent .and. parent:hasLayout
				node := NIL
			elseif name == "unnamed"
				node := NIL
				if parent:attribute("class","") == "qlayoutwidget"
					parent:setAttribute("class", "hbox")
				endif
			else		
				node := XMLTag("widget")
				node:setAttribute("class", "hbox")
				node:setAttribute("name",  name)
			endif
		case "VBOX"
			if "HASLAYOUT" $ parent .and. parent:hasLayout
				node := NIL
			elseif name == "unnamed" 
				node := NIL
				if parent:attribute("class","") == "qlayoutwidget"
					parent:setAttribute("class", "vbox")
				endif
			else
				node := XMLTag("widget")
				node:setAttribute("class", "vbox")
				node:setAttribute("name",  name)
			endif
		case "GRID"
			if "HASLAYOUT" $ parent .and. parent:hasLayout
				node := NIL
			elseif name == "unnamed" 
				node := NIL
				if parent:attribute("class","") == "qlayoutwidget"
					parent:setAttribute("class", "grid")
				endif
			else
				node := XMLTag("widget")
				node:setAttribute("class", "grid")
				node:setAttribute("name",  name)
			endif
		case "QPUSHBUTTON"
			node := XMLTag("widget")
			node:setAttribute("class", "button")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
		case "QLABEL"
			node := XMLTag("widget")
			node:setAttribute("name",  name)
			if .not. empty(icon)
				node:setAttribute("class", "image")
				node:setAttribute("label", icon)
			else
				node:setAttribute("class", "label")
 				node:setAttribute("label", label)
			endif
		case "QBUTTONGROUP"
			node := XMLTag("widget")
			node:setAttribute("class", "radioGroup")
			node:setAttribute("name",  name)
			node:hasLayout := .T.
		case "QRADIOBUTTON"
			node := XMLTag("widget")
			node:setAttribute("class", "radioButton")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
			//parent:setAttribute("class", "radioGroup")
		case "QCHECKBOX"
			node := XMLTag("widget")
			node:setAttribute("class", "checkBox")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
		case "QTEXTEDIT"
			node := XMLTag("widget")
			node:setAttribute("class", "editText")
			node:setAttribute("name",  name)
			sNode := XMLTag("property")
			sNode:setAttribute("name", "value")
			sNode:setAttribute("value",  label)
			node:addChild( sNode )
		case "QLINEEDIT"
			node := XMLTag("widget")
			rI := at('_', name)
			if rI > 0
				rClass := left(name, rI-1)
				name := substr(name, rI+1)
				switch lower(rClass)
					case "choice"
						rSubType := "choice"
					case "filename"
						rSubType := "editFilename"
					case "date"
						rSubType := "editDate"
					case "color"
						rSubType := "editColor"
					otherwise
						rSubType := "edit"  // Default subtype
				endswitch
				node:setAttribute("class", rSubType)
			else
				node:setAttribute("class", "edit")
			endif
			node:setAttribute("name",  name)
			sNode := XMLTag("property")
			sNode:setAttribute("name", "value")
			sNode:setAttribute("value",  label)
			node:addChild( sNode )
		case "QCOMBOBOX"
			node := XMLTag("widget")
			node:setAttribute("class", "comboBox")
			node:setAttribute("name",  name)
			a := w:XPath("item/property/string")
			if valtype(a) == "A" .and. len(a) > 0
				value := ""
				sNode := XMLTag("property")
				sNode:setAttribute("name",  "source")
				for i in a
					value += "'" + i:getText() + "', "
				next
				value := left(value, len(value)-2)
				sNode:setAttribute("value", value)
				node:addChild( sNode )
			endif
			sNode := XMLTag("property") 
			sNode:setAttribute("name",  "value")
			sNode:setAttribute("value", label) 
			node:addChild( sNode )
		case "QSLIDER"
			node := XMLTag("widget")
			node:setAttribute("class", "slider")
			node:setAttribute("name",  name)
			sNode := XMLTag("property") 
			sNode:setAttribute("name",  "range")
			sNode:setAttribute("value", slider:min + "-" + slider:max) 
			node:addChild( sNode )
			sNode := XMLTag("property") 
			sNode:setAttribute("name",  "step")
			sNode:setAttribute("value", slider:step) 
			node:addChild( sNode )
			sNode := XMLTag("property") 
			sNode:setAttribute("name",  "value")
			sNode:setAttribute("value", slider:value) 
			node:addChild( sNode )
		case "QDATEEDIT"
			node := XMLTag("widget")
			node:setAttribute("class", "editDate")
			node:setAttribute("name",  name)
			sNode := XMLTag("property")
			sNode:setAttribute("name", "value")
			sNode:setAttribute("value",  label)
			node:addChild( sNode )
		case "QPROGRESSBAR"
			node := XMLTag("widget")
			node:setAttribute("class", "progressBar")
			node:setAttribute("name",  name)
			sNode := XMLTag("property")
			sNode:setAttribute("name", "value")
			sNode:setAttribute("value", label)
			node:addChild( sNode )
		case "MENUBAR"
			node := XMLTag("widget")
			node:setAttribute("class", "menuBar")
			node:setAttribute("name",  name)
		case "TOOLBARS"
			// Nothing do
		case "TOOLBAR"
			node := XMLTag("widget")
			node:setAttribute("class", "toolBar")
			node:setAttribute("name",  name)
		case "QTOOLBUTTON"
			node := XMLTag("widget")
			node:setAttribute("class", "toolButton")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
			sNode := XMLTag("property")
			sNode:setAttribute("name", "icon")
			sNode:setAttribute("value", icon)
			node:addChild( sNode )
		case "ITEM"
			p := w:XPath("property/string")
			if .not. empty(w:attribute("text",""))
				node := XMLTag("widget")
				node:setAttribute("class", "popupMenu")
				node:setAttribute("name",  w:attribute("name",""))
				node:setAttribute("label", w:attribute("text",""))
			elseif valtype(p) == "A" .and. len(p) > 0
				if lower(parent:attribute("class","")) != "combobox"
					value := ""
					for i in p
						value += "'" + i:getText() + "', "
					next
					value := left(value, len(value)-2)
					nCounter++
					it := "node" + ltrim(str(nCounter))
					itp := ""
					if valtype(w:getParent()) == "O" .and. "_NODENAME" $ w:getParent()
						itp := w:getParent():_nodename
					endif
					//?? "NODE:", it, "parent:", itp, chr(10)
					sNode := XMLTag("property")
					sNode:setAttribute("name",    "row")
					sNode:setAttribute("element", it+iif(empty(itp),"","."+itp))
					w:_nodename := it
					sNode:setAttribute("value",   value)
					parent:addChild( sNode )
				endif
			endif
		case "ACTION"
			action := w:attribute("name","")
			mW  := mapget(s_actions, upper(action), NIL)
			if valtype(mW) == "O"
				node := XMLTag("widget")
				node:setAttribute("class", mW:class)
				node:setAttribute("name",  mW:name)
				node:setAttribute("label", mW:label)
				if .not. empty(mW:icon)
					sNode := XMLTag("property")
					sNode:setAttribute("name", "icon")
					sNode:setAttribute("value", mW:icon)
					node:addChild( sNode )
				endif
			endif
		case "SEPARATOR"
			node := XMLTag("widget")
			if lower(parent:attribute("class","")) == "popupmenu"
				node:setAttribute("class", "menuSeparator")
			elseif lower(parent:attribute("class","")) == "toolbar"
				node:setAttribute("class", "toolbarSeparator")
			endif
		case "QTABWIDGET"
			node := XMLTag("widget")
			node:setAttribute("class", "tabArea")
			node:setAttribute("name",  name)
		case "QTAB"
			node := XMLTag("widget")
			node:setAttribute("class", "tab")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
			node:hasLayout := .T.
		case "QSPLITTER"
			node := XMLTag("widget")
			node:setAttribute("class", "splitter")
			node:setAttribute("name",  name)
		case "QLISTVIEW"
			node := XMLTag("widget")
			rI := at('_', name)
			if rI > 0
				rClass := left(name, rI-1)
				name := substr(name, rI+1)
				switch lower(rClass)
					case "table"
						rSubType := "table"
					case "tree"
						rSubType := "tree"
					otherwise
						rSubType := "table"  // Default subtype
				endswitch
				node:setAttribute("class", rSubType)
			else
				node:setAttribute("class", "table")
			endif
			node:setAttribute("name",  name)
		case "QTABLE"
			node := XMLTag("widget")
			node:setAttribute("class", "editTable")
			node:setAttribute("name",  name)
		case "QFRAME"
			node := XMLTag("widget")
			if fixed
				node:setAttribute("class", "layout")
			else
				node:setAttribute("class", "frame")
				node:setAttribute("label", label)
			endif
			node:setAttribute("name",  name)
			node:hasLayout := .T.
		case "QGROUPBOX"
			node := XMLTag("widget")
			node:setAttribute("class", "frame")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
			node:hasLayout := .T.
		case "QLAYOUTWIDGET"
			node := XMLTag("widget")
			node:setAttribute("class", "qlayoutwidget")
			node:setAttribute("name",  name)
			rI := at('_', name)
			if rI > 0
				rClass := left(name, rI-1)
				switch lower(rClass)
					case "choice"
						rSubType := "choice"
					case "filename"
						rSubType := "editFilename"
					case "date"
						rSubType := "editDate"
					case "color"
						rSubType := "editColor"
					case "tree"
						rSubType := "tree"
					case "table"
						rSubType := "table"
					case "edittable"
						rSubType := "editTable"
					otherwise
						rSubType := ""  // Default subtype
				endswitch
				node:subtype := rSubType
			endif
		otherwise
			?? "WARNING: Unsupported tag: ",cClass,chr(10)
	end switch

	if valtype(node) == "O" .and. .not. empty(row) .and. .not. empty(column) 
		i := ltrim(str(val(row)+1))
		j := ltrim(str(val(column)+1))
		//?? "POS: ", valtype(node), i + ',' + j, chr(10)
		node:setAttribute("pos", i + ',' + j)
	endif

	// Add to tree
	if valtype(node) == 'O' .and. valtype(parent) == 'O'
		parent:addChild( node )
		
		if valtype(geom) == 'A'
			node:setAttribute("pos", geom[3] + "," + geom[4])
		endif
		
	endif

	// Loop child widgets
	for c in w:getChilds()
		if upper(c:getName()) == "COLUMN"
			// Columns
			a := c:XPath("property/string")
			if valtype(a) == 'A' .and. len(a) > 0
				sNode := XMLTag("column")
				sNode:setAttribute("name", lower(a[1]:getText()))
				sNode:setAttribute("title", a[1]:getText())
				node:addChild( sNode )
			endif
		elseif upper(c:getName()) == "PROPERTY" .or. upper(c:getName()) == "ATTRIBUTE"
			if valtype(node) != "O"
				node := parent
			endif
			// Other properties
			prop := map()
			prop:name := lower(c:attribute("name",""))
			a := c:getChilds()
			if len(a) > 0
				prop:value := a[1]:getText()
			else
				prop:value := NIL
			endif
			
			//?? prop:name, prop:value, chr(10)
			switch prop:name
				case "orientation"
					if node:attribute("class","") == "splitter"
						if lower(prop:value) == "horizontal"
							node:setAttribute("class", "vsplitter")
						else
							node:setAttribute("class", "hsplitter")
						endif
					endif
				case "checked"
					sNode := XMLTag("property")
					sNode:setAttribute("name", "value")
					sNode:setAttribute("value", prop:value)
					node:addChild( sNode )
				case "maximumsize"
					x := c:XPath("size/width")
					y := c:XPath("size/height")
					if len(x) > 0 .and. len(y) > 0
						x := val(x[1]:getText())
						y := val(y[1]:getText())
						sNode := XMLTag("property")
						if x < 32000
							sNode:setAttribute("name", "geometry.width")
							sNode:setAttribute("value", ltrim(str(x)))
							node:addChild( sNode )
						endif
						if y < 32000
							sNode:setAttribute("name", "geometry.height")
							sNode:setAttribute("value", ltrim(str(y)))
							node:addChild( sNode )
						endif
					endif
				case "margin"
					sNode := XMLTag("property")
					sNode:setAttribute("name",   "padding")
					sNode:setAttribute("value",  prop:value)
					mW := iif(valtype(node)=="O", node, parent)
					mW:addChild( sNode )
				case "spacing"
					sNode := XMLTag("property")
					sNode:setAttribute("name",   "spacing")
					sNode:setAttribute("value",  prop:value)
					mW := iif(valtype(node)=="O", node, parent)
					mW:addChild( sNode )
				case "basesize"
					a := array(2)
					a[1] := c:XPath("size/width")
					a[2] := c:XPath("size/height")
					sNode := XMLTag("property")
					sNode:setAttribute("name",   "geometry")
					value := a[1][1]:getText() + "," + a[2][1]:getText() + ",0,0"
					sNode:setAttribute("value",  value)
					mW := iif(valtype(node)=="O", node, parent)
					mW:addChild( sNode )
				case "paletteforegroundcolor", "palettebackgroundcolor"
					a := array(3)
					a[1] := c:XPath("color/red")
					a[2] := c:XPath("color/green")
					a[3] := c:XPath("color/blue")
					a[1] := ntoc(val(a[1][1]:getText()),16,2,"0")
					a[2] := ntoc(val(a[2][1]:getText()),16,2,"0")
					a[3] := ntoc(val(a[3][1]:getText()),16,2,"0")
					value := "#" + a[1] + a[2] + a[3]
					if prop:name == "paletteforegroundcolor"
						name := "color.fg"
					else
						name := "color.bg"
					endif
					//?? "color:", name, value, chr(10)
					sNode := XMLTag("property")
					sNode:setAttribute("name",   name)
					sNode:setAttribute("value",  value)
					mW := iif(valtype(node)=="O", node, parent)
					mW:addChild( sNode )
				case "font"
					a := c:XPath("font/*")
					for i in a
						switch lower(i:getName())
							case "bold"
								if i:getText() == "1"
									sNode := XMLTag("property")
									sNode:setAttribute("name",   "font.style")
									sNode:setAttribute("value",  "bold")
									mW := iif(valtype(node)=="O", node, parent)
									mW:addChild( sNode )
								endif
							case "italic"
								if i:getText() == "1"
									sNode := XMLTag("property")
									sNode:setAttribute("name",   "font.style")
									sNode:setAttribute("value",  "italic")
									mW := iif(valtype(node)=="O", node, parent)
									mW:addChild( sNode )
								endif
							case "family"
								sNode := XMLTag("property")
								sNode:setAttribute("name",   "font.family")
								sNode:setAttribute("value",  i:getText())
								mW := iif(valtype(node)=="O", node, parent)
								mW:addChild( sNode )
							case "pointsize"
								sNode := XMLTag("property")
								sNode:setAttribute("name",   "font.size")
								sNode:setAttribute("value",  i:getText())
								mW := iif(valtype(node)=="O", node, parent)
								mW:addChild( sNode )
							otherwise
								?? "Unsupported font property:", i:getName(), chr(10)
						endswitch
					next
				otherwise
					//?? "Unsupported property:", prop:name, chr(10)
			endswitch
		else
			// Widgets and layouts
			ui_createWidgetFromUI3(c, iif(valtype(node)=="O", node, parent), rSubType)
		endif
	next

return node

/* Extract icons and actions from Qt Designer .ui file */
static function ui_extractUI3( root )
	local a, aN, i, n, nodes, node, name, value, content, f, l
	local act
	
	// actions
	a := root:XPath("/actions/action")
	for i in a
		node       := map()
		node:name  := ""
		node:class := "menuItem"
		node:label := ""
		node:icon  := ""
		aN := i:XPath("property")
		for n in aN
			name := n:attribute("name","")
			value := n:getChilds()[1]:getText()
			switch name
				case "name"
					node:name := value
				case "toggleAction"
					if value == "true"
						node:class := "menuCheckedItem"
					endif
				case "text"
					node:label := value
				case "menuText"
					node:label := value
				case "iconSet"
					node:icon := value
			endswitch
		next
		s_actions[upper(node:name)] := node
		//?? node, chr(10)
	next
	
	// TODO: icons (need convert from PNG to XPM or native PNG support)
	/*a := root:XPath("/images/image")
	for i in a
		name := i:attribute("name","unnamed")
		node := i:getChild(1)
		content := node:getText()
		l := node:attribute("length",len(content))
		l := len(content)
		f := fcreate(name)
		?? "write image:", name, chr(10)
		fwrite(f, content, l)
		fclose(f)
	next
	*/
	
	// actions
	a := root:XPath("/connections/connection")
	for i in a
		act        := map()
		act:name   := ""
		act:signal := ""
		act:object := ""
		act:slot   := ""
		nodes      := i:getChilds()
		for node in nodes
			switch node:getName()
				case "sender"
					act:name := ui_fixName(node:getText())
				case "signal"
					act:signal := node:getText()
					f := at("(", act:signal)
					act:signal := left(act:signal, f-1)
				case "receiver"
					act:object := ui_fixName(node:getText())
				case "slot"
					act:slot := node:getText()
					f := at("(", act:slot)
					act:slot := left(act:slot, f-1)
			endswitch
		next
		act:rule   := XMLTag("rule")
		act:event  := XMLTag("event")
		act:action := XMLTag("action")
		act:call   := XMLTag("call")
		
		act:event:setAttribute("widget", act:name)
		act:event:setAttribute("signal", act:signal)
		if .not. empty(act:object)
			act:call:setAttribute("widget", act:object)
		endif
		act:call:setAttribute("method", act:slot)
		
		act:rule:addChild( act:event )
		act:rule:addChild( act:action )
		act:action:addChild( act:call )
		actions:addChild( act:rule )
		//?? act:rule:dump()
	next
	
return NIL

static function ui_fixName( name )
	local classes, i, class, real:=name
	
	classes := { 	;
					"mainwindow", ; 
					"window", ;
					"childwindow", ;
					"document", ;
					"choice", ;
					"filename", ;
					"date", ;
					"color", ;
					"tree", ;
					"table", ;
					"edittable" ;
				}

	i := at('_', name)
	if i > 0
		class := lower(left(name, i-1))
		if ascan(classes, {|e| e == class }) > 0
			real  := substr(name, i+1)
		endif
	endif
return real