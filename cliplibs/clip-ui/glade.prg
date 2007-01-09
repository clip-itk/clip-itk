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

/* Convert GLADE form (*.glade) to XFL form */

function ui_convertFromGlade3( root )
	local r, h, i, l, pp
	
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
	
	// Convert widgets
	pp := root:XPath("/widget")
	if valtype(pp) != 'A' .or. len(pp) == 0
		?? "ERROR: Unable to find root widget for Glade form.&\n"
		return r
	endif
	
	ui_createWidgetFromGlade3( pp[1], i, NIL )
	if DEBUG
		?? r:dump()
	endif
	
return r

/* Create widget in XFL format */
static function ui_createWidgetFromGlade3(w, parent, subtype)
	local cClass, name, label:='', c, p, pk, lUnderLine := .F.
	local expand:=.T., fill:=.T., padding, spacing, group, icon:=""
	local x:='', y:='', adjustment, cols:='0', rows:='0'
	local value, rName, rClass, rI, node:=NIL, rSubType:=""
	local sNode:=NIL, rValue, a, i, wValue:="", pos:="", tNode, act
	
	if w == NIL
		return NIL
	endif
	
	cClass := w:attribute("class","")
	name  := w:attribute("id","")

	//?? '>', cClass, name, chr(10)
	for c in w:getChilds()
		
		// Properties
		if lower(c:getName()) == "property"
			value := c:getText()
			do switch lower( c:attribute("name","") )
				case "adjustment"
					adjustment := value
				case "title"
					//label := self:i18n(c:value)
					label := value
				case "visible"
				case "type"
				case "window_position"
				case "modal"
				case "resizable"
				case "destroy_with_parent"
				case "decorated"
				case "skip_taskbar_hint"
				case "skip_pager_hint"
				case "type_hint"
				case "gravity"
				case "focus_on_map"
				case "homogeneous"
				case "spacing"
					sNode := XMLTag("property")
					sNode:setAttribute("widget", ui_fixName( name ) )
					sNode:setAttribute("name",   "spacing")
					sNode:setAttribute("value",  value)
					styles:addChild( sNode )				
				case "label"
					label := value
					//label := self:i18n(c:value)
				case "use_underline"
					// Accel support
					if upper(value) == "TRUE"
						lUnderLine := .T.
					endif
				case "use_stock"
				case "stock"
				case "text"
					sNode := XMLTag("property")
					sNode:setAttribute("widget", ui_fixName( name ) )
					sNode:setAttribute("name",   "value")
					sNode:setAttribute("value",  value)
					styles:addChild( sNode )				
				case "icon_size"
				case "xalign"
				case "yalign"
				case "ypad"
				case "xpad"
				case "orientation"
				case "toolbar_style"
				case "tooltips"
				case "show_arrow"
				case "stock_id"
				case "visible_horizontal"
				case "visible_vertical"
				case "is_important"
				case "use_markup"
				case "justify"
				case "wrap"
				case "selectable"
				case "ellipsize"
				case "width_chars"
				case "single_line_mode"
				case "angle"
				case "can_focus"
				case "editable"
				case "visibility"
				case "max_length"
				case "has_frame"
				case "invisible_char"
				case "activates_default"
				case "hscrollbar_policy"
				case "vscrollbar_policy"
				case "shadow_type"
					switch upper(value)
						case "GTK_SHADOW_NONE"
							value := "plain"
						case "GTK_SHADOW_IN"
							value := "sunken"
						case "GTK_SHADOW_OUT"
							value := "raised"
						case "GTK_SHADOW_ETCHED_IN"
							value := "in"
						case "GTK_SHADOW_ETCHED_OUT"
							value := "out"
						otherwise
							value := "sunken"
					endswitch
					sNode := XMLTag("property")
					sNode:setAttribute("widget", ui_fixName( name ))
					sNode:setAttribute("name",   "type")
					sNode:setAttribute("value",  value)
					styles:addChild( sNode )				
				case "window_placement"
				case "overwrite"
				case "accepts_tab"
				case "justification"
				case "wrap_mode"
				case "cursor_visible"
				case "pixels_above_lines"
				case "pixels_below_lines"
				case "pixels_inside_wrap"
				case "left_margin"
				case "right_margin"
				case "indent"
				case "has_resize_grip"
				case "relief"
				case "focus_on_click"
				case "items"
					//?? "values:", value, chr(10)
					if upper(cClass) == "GTKCOMBOBOX"
						rValue := strtran(value, chr(10), "'},{'")
						rValue := "{'" + rValue + "'}"
						
						sNode := XMLTag("property")
						sNode:setAttribute("widget", ui_fixName( name ))
						sNode:setAttribute("name",   "source")
						sNode:setAttribute("value",  rValue)
						styles:addChild( sNode )				
					endif
				case "add_tearoffs"
				case "active"
					//?? "active:", cClass, chr(10)
					if upper(cClass) != "GTKRADIOBUTTON"
						sNode := XMLTag("property")
						sNode:setAttribute("widget", ui_fixName( name ))
						sNode:setAttribute("name",   "value")
						sNode:setAttribute("value",  value)
						styles:addChild( sNode )				
					endif
				case "inconsistent"
				case "draw_indicator"
				case "group"
					group := value
				case "headers_visible"
				case "rules_hint"
				case "reorderable"
				case "enable_search"
				case "fixed_height_mode"
				case "hover_selection"
				case "hover_expand"
				case "width_request"
					sNode := XMLTag("property")
					sNode:setAttribute("widget", ui_fixName( name ))
					sNode:setAttribute("name",   "geometry.width")
					sNode:setAttribute("value",  value)
					styles:addChild( sNode )				
				case "height_request"
					sNode := XMLTag("property")
					sNode:setAttribute("widget", ui_fixName( name ))
					sNode:setAttribute("name",   "geometry.height")
					sNode:setAttribute("value",  value)
					styles:addChild( sNode )				
				case "draw_value"
				case "layout_style"
				case "n_rows"
					rows := value
				case "n_columns"
					cols := value
				case "icon", "pixbuf"
					icon := value
				case "label_xalign"
				case "events"
				case "show_text"
				case "border_width"
					sNode := XMLTag("property")
					sNode:setAttribute("widget", ui_fixName( name ))
					sNode:setAttribute("name",   "padding")
					sNode:setAttribute("value",  value)
					styles:addChild( sNode )				
				case "column_spacing"
					sNode := XMLTag("property")
					sNode:setAttribute("widget", ui_fixName( name ))
					sNode:setAttribute("name",   "spacing")
					sNode:setAttribute("value",  value)
					styles:addChild( sNode )				
				case "row_spacing"
					sNode := XMLTag("property")
					sNode:setAttribute("widget", ui_fixName( name ))
					sNode:setAttribute("name",   "spacing")
					sNode:setAttribute("value",  value)
					styles:addChild( sNode )				
				case "fraction"
					if left(getenv("LANG"),2) == "ru"
						value := strtran(value, ",", ".")
					endif
					wValue := value
				case "urgency_hint"
				case "pack_direction"
				case "child_pack_direction"
				case "show_tabs"
				case "show_border"
				case "tab_pos"
				case "scrollable"
				case "enable_popup"
				case "position"
				case "value_pos"
				case "digits"
				case "update_policy"
				case "inverted"
				case "label_yalign"
				case "xscale"
				case "yscale"
				case "top_padding"
				case "bottom_padding"
				case "left_padding"
				case "right_padding"
				case "pulse_step"
				case "draw"
				case "default_width"
					x := value
				case "default_height"
					y := value
				otherwise
					?? "WARNING: property tag " + c:attribute("name") + " for class " + cClass + " is ignored&\n"
			end switch
		elseif lower(c:getName()) == "signal"
			// Signal support
			//<signal name="clicked" handler="close" object="mainWindow"
			/*<rule>
				<event widget="close" signal="clicked" />
				<action><call widget="mainWindow" method="close" /></action>
			</rule> */
			//?? "rule...&\n"
			act        := map()
			act:name   := name
			act:signal := c:attribute("name","")
			act:object := c:attribute("object","")
			act:slot   := c:attribute("handler","")
			
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
	
		endif
	next

	if lUnderLine .and. !empty(label)
		label := strtran(label, "_", "&")
	endif
	
	// Widgets
	switch upper(cClass)
		/* Widgets */
		case "GTKWINDOW"
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
					case "childwindow"
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
			if .not. empty(x)
				value := x + iif(.not. empty(y), ','+y, '')
				tNode := XMLTag("property")
				tNode:setAttribute("widget", rName)
				tNode:setAttribute("name",  "geometry")
				tNode:setAttribute("value", value)
				styles:addChild( tNode )
			endif			
		case "GTKHBOX"
			if "HASLAYOUT" $ parent .and. parent:hasLayout
				node := NIL
			else		
				node := XMLTag("widget")
				node:setAttribute("class", "hbox")
				node:setAttribute("name",  name)
			endif
		case "GTKVBOX"
			rI := at('_', name)
			if "HASLAYOUT" $ parent .and. parent:hasLayout
				node := NIL
			else			
				node := XMLTag("widget")
				node:setAttribute("class", "vbox")
				node:setAttribute("name",  name)
			endif
		case "GTKFRAME"
			node := XMLTag("widget")
			node:hasLayout := .T.
			node:setAttribute("class", "frame")
			node:setAttribute("name",  name)
		case "GTKHPANED"
			node := XMLTag("widget")
			node:setAttribute("class", "vsplitter")
			node:setAttribute("name",  name)
		case "GTKVPANED"
			node := XMLTag("widget")
			node:setAttribute("class", "hsplitter")
			node:setAttribute("name",  name)
		case "GTKNOTEBOOK"
			node := XMLTag("widget")
			node:setAttribute("class", "tabArea")
			node:setAttribute("name",  name)
		case "GTKTABLE"
			node := XMLTag("widget")
			node:setAttribute("class", "grid")
			node:setAttribute("name",  name)
			node:setAttribute("cols",  cols)
			node:setAttribute("rows",  rows)
		case "GTKMENUBAR"
			node := XMLTag("widget")
			node:setAttribute("class", "menuBar")
			node:setAttribute("name",  name)
		case "GTKMENUITEM"
			node := XMLTag("widget")
			p := w:XPath("child/widget")
			if !empty(p)
				node:setAttribute("class", "popupMenu")
				node:setAttribute("name",  name)
				node:setAttribute("label", label)
			else
				node:setAttribute("class", "menuItem")
				node:setAttribute("name",  name)
				node:setAttribute("label", label)
			endif
		case "GTKCHECKMENUITEM"
			node := XMLTag("widget")
			node:setAttribute("class", "menuCheckedItem")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
		case "GTKMENU"
			// Nothing do
		case "GTKIMAGEMENUITEM" 
			node := XMLTag("widget")
			node:setAttribute("class", "menuItem")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
			if .not. empty(icon)
				sNode := XMLTag("property")
				sNode:setAttribute("name",  "icon")
				sNode:setAttribute("value", icon)
				node:addChild( sNode )
			endif
		case "GTKSEPARATORMENUITEM"
			node := XMLTag("widget")
			node:setAttribute("class", "menuSeparator")
		case "GTKTOOLBAR"
			node := XMLTag("widget")
			node:setAttribute("class", "toolBar")
			node:setAttribute("name",  name)
		case "GTKTOOLBUTTON"
			node := XMLTag("widget")
			node:setAttribute("class", "toolButton")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
			if .not. empty(icon)
				sNode := XMLTag("property")
				sNode:setAttribute("name",  "icon")
				sNode:setAttribute("value", icon)
				node:addChild( sNode )
			endif
		case "GTKSEPARATORTOOLITEM"
			node := XMLTag("widget")
			node:setAttribute("class", "toolbarSeparator")
		case "GTKLABEL"
			node := XMLTag("widget")
			node:setAttribute("class", "label")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
		case "GTKENTRY"
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
		case "GTKTEXTVIEW"
			node := XMLTag("widget")
			node:setAttribute("class", "editText")
			node:setAttribute("name",  name)
		case "GTKSTATUSBAR"
			node := XMLTag("widget")
			node:setAttribute("class", "statusBar")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
		case "GTKBUTTON"
			node := XMLTag("widget")
			node:setAttribute("class", "button")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
		case "GTKCOMBOBOX"
			node := XMLTag("widget")
			node:setAttribute("class", "comboBox")
			node:setAttribute("name",  name)
		case "GTKCHECKBUTTON"
			node := XMLTag("widget")
			node:setAttribute("class", "checkBox")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
		case "GTKVBUTTONBOX"
			node := XMLTag("widget")
			node:setAttribute("class", "radioGroup")
			node:setAttribute("name",  name)
		case "GTKRADIOBUTTON"
			node := XMLTag("widget")
			node:setAttribute("class", "radioButton")
			node:setAttribute("name",  name)
			node:setAttribute("label", label)
			parent:setAttribute("class", "radioGroup")
		case "GTKTREEVIEW"
			node := XMLTag("widget")
			rI := at('_', name)
			if rI > 0
				rClass := left(name, rI-1)
				name := substr(name, rI+1)
				switch lower(rClass)
					case "tree"
						rSubType := "tree"
					case "table"
						rSubType := "table"
					case "edittable"
						rSubType := "editTable"
					otherwise
						rSubType := "table"  // Default subtype
				endswitch
				node:setAttribute("class", rSubType)
			else
				node:setAttribute("class", "edit")
			endif
			node:setAttribute("name",  name)
			sNode := XMLTag("column")
			sNode:setAttribute("name",  "name")
			sNode:setAttribute("title", "Name")
			node:addChild( sNode )
		case "GTKFIXED"
			node := XMLTag("widget")
			node:setAttribute("class", "layout")
			node:setAttribute("name",  name)
		case "GTKHSCALE"
			node := XMLTag("widget")
			node:setAttribute("class", "slider")
			node:setAttribute("name",  name)
			a := split(adjustment, " ")
			if len(a) >= 6 
				sNode := XMLTag("property") 
				sNode:setAttribute("name",  "range")
				sNode:setAttribute("value", a[1] + "-" + a[3]) 
				node:addChild( sNode )
				sNode := XMLTag("property") 
				sNode:setAttribute("name",  "step")
				sNode:setAttribute("value", a[6]) 
				node:addChild( sNode )
				sNode := XMLTag("property") 
				sNode:setAttribute("name",  "value")
				sNode:setAttribute("value", a[5]) 
				node:addChild( sNode )
			endif
		case "GTKPROGRESSBAR"
			node := XMLTag("widget")
			node:setAttribute("class", "progressBar")
			node:setAttribute("name",  name)
			sNode := XMLTag("property")
			sNode:setAttribute("name",  "value")
			sNode:setAttribute("value", wValue)
			node:addChild( sNode )
		case "GTKIMAGE"
			if valtype(parent) == 'O' .and. lower(parent:attribute("class","")) == "menuitem"
				node := XMLTag("property")
				node:setAttribute("name",  "icon")
				node:setAttribute("value", icon)
			else
				node := XMLTag("widget")
				node:setAttribute("class", "image")
				node:setAttribute("name",  name)
			endif
		case "GTKALIGNMENT"
			node := NIL
		otherwise
			?? "ERROR: Unsupported class: " + cClass + "&\n"
	end switch

	// Add to tree
	if valtype(node) == 'O' .and. valtype(parent) == 'O'
		if lower(parent:attribute("class")) == "tabarea"
			// TabArea widget
			
			// Check empty tab in this area
			i := parent:countChilds()
			if i == 0
				sNode := XMLTag("widget")
				sNode:setAttribute("class", "tab")
				parent:addChild( sNode )
				i++
			endif
			
			sNode := parent:getChild(i)
			if lower(node:attribute("class")) == "label"
				// Label == Tab
				sNode:setAttribute("name", node:attribute("name"))
				sNode:setAttribute("label", node:attribute("label"))
				sNode := XMLTag("widget")
				sNode:setAttribute("class", "tab")
				parent:addChild( sNode )
				i++
			else
				// Other widgets
				sNode:addChild( node )
			endif
		elseif lower(parent:attribute("class","")) == "frame"
			// Caption for frame 
			if lower(node:attribute("class")) == "label"
				parent:setAttribute("label", node:attribute("label","")) 
			else
				// Other widgets
				parent:addChild( node )
			endif
		else
			parent:addChild( node )
		endif
	endif
	
	// Process child widgets
	for c in w:getChilds()
		sNode  := NIL
		fill   := .T.
		expand := .T.
		x := NIL
		y := NIL
		do switch upper(c:getName())
			case "CHILD"
				for p in c:getChilds()
					do switch upper(p:getName())
						case "WIDGET"
							// Recursive create widgets
							if valtype(node) != 'O'
								node := parent
							endif
							sNode := ui_createWidgetFromGlade3(p, node, rSubType)
						case "PACKING"
							//?? p:attribute("name"), ch:attribute("name"), chr(10)
							for pk in p:getChilds()
								if upper(pk:getName()) == "PROPERTY"
								  do switch upper(pk:attribute("name",""))
									case "PADDING"
										padding := pk:getText()
									case "EXPAND"
										if upper(pk:getText()) == "FALSE"
											expand := .F.
										endif
									case "FILL"
										if upper(pk:getText()) == "FALSE"
											fill := .F.
										endif
									case "HOMOGENEOUS"
										// Nothing do
									case "X"
										x := pk:getText()
									case "Y"
										y := pk:getText()
									case "LEFT_ATTACH"
											x := ltrim(str(val(pk:getText())+1))
									case "TOP_ATTACH"
											y := ltrim(str(val(pk:getText())+1))
									otherwise
										//?? "WARNING: unknown packing tag <" + pk:getName() + ">&\n"
								  end switch
								else
									//?? "WARNING: unknown packing tag <" + pk:getName() + ">&\n"
								endif
							next
						otherwise
							?? "WARNING: child tag " + p:getName() + " for widget is ignored&\n"
					end switch
				next
				
				// Set properties
				//?? sNode:attribute("class"), x, y, chr(10)
				if valtype(sNode) == "O" .and. valtype(sNode:parent) == "O"
					//?? sNode:attribute('class'),chr(10)
					if lower(sNode:parent:attribute("class","")) == "grid"
						if empty(x)
							x := "1"
						endif
						if empty(y)
							y := "1"
						endif
						sNode:setAttribute("pos", y + "," + x)
					elseif lower(sNode:parent:attribute("class","")) == "layout"
						if empty(x)
							x := "0"
						endif
						if empty(y)
							y := "0"
						endif
						sNode:setAttribute("pos", x + "," + y)
					endif
					if expand .and. fill
						//sNode:setAttribute("name", sNode:attribute("name","") + "+")
					endif
				endif
			
			case "PROPERTY"
				// Nothing do
			case "SIGNAL"
				// attr:
				//name="activate"
				//handler="name_function"
				//last_modification_time="..."
			otherwise
				?? "WARNING: tag <" + c:getName() + "> is ignored&\n"
		end switch
	next
	
	//?? "NODE:", node:attribute("class"), chr(10)
	
	// Remove last tab in tab area
	if valtype(node) == 'O' .and. lower(node:attribute("class","")) == "tabarea"
		node:removeChild( node:countChilds() )
	endif
	
	// Return actual tag
	if valtype(node) != "O"
		return sNode
	endif
	
return node

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