/*
    Copyright (C) 2003  ITK
    Author   : Alexey M. Tkachenko (alexey@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include <clip-gtk.ch>
#include "abx.ch"

static hb
static idle_descr

function abx_new()
	local obj := map()

	obj:menu	:= nil
	obj:statbar	:= nil
	obj:w		:= nil

	obj:depository	:= nil
	obj:dep_name	:= [Not opened]
	obj:dictionary	:= nil
	obj:dict_name	:= [Not opened]
	obj:dict_list	:= nil

	obj:set_status	:= @abx_set_status()

	obj:init	:= @abx_init()
	obj:run		:= @abx_run()
	obj:quit	:= @abx_quit()
	obj:ask_quit	:= @abx_ask_quit()
	obj:set_events	:= @abx_set_events()
	obj:done	:= @abx_done()

	obj:open_dict	:= @abx_open_dict()
	obj:close_dict	:= @abx_close_dict()
	obj:edit_dict	:= @abx_edit_dict()
	obj:open_dep	:= @abx_open_dep()
	obj:close_dep	:= @abx_close_dep()

	obj:browse_meta	:= @abx_browse_meta()
	obj:browse_data	:= @abx_browse_data()

	obj:load_xml	:= @abx_load_xml()
	obj:save_xml	:= @abx_save_xml()

return obj

static function abx_init(self)
	local f,vb,sw,qbtn
	local menu
	memvar MainWindow

	public MainWindow

	/* Initialize GTK+ system */
	gtk_init()

	Set(_SET_INSERT,TRUE)

	/* Create main window */
	/***************************************************/
	self:w := gtk_WindowNew(,[Object Database Administration Tool])
	MainWindow := self:w
//	gtk_WidgetSetPosition(w,50,50)
	gtk_WidgetSetSize(self:w,500,300)
	gtk_WindowSetPolicy(self:w,.f.,.t.,.t.)
	gtk_SignalConnect(self:w,"delete-event",{||abx_event_put(HASH_AbxExit)})

	/* Create vertical box container */
	vb := gtk_VBoxNew()
	gtk_ContainerAdd (self:w, vb)

	/* Create horizontal box container */
	hb := gtk_HBoxNew()
	gtk_WidgetSetSize(hb,600,25)
	gtk_BoxPackStart(vb,hb)

	/* Create scrolled window container */
	sw := gtk_ScrolledWindowNew()
	gtk_ScrolledWindowSetPlacement(sw,GTK_CORNER_TOP_LEFT)
	gtk_BoxPackStart(vb,sw,.t.,.t.)

	/* Create layout container */
	f := gtk_LayoutNew()
//	gtk_WidgetSetSize(f,700,1000)
	gtk_ContainerSetBorderWidth(f,20)
	gtk_ScrolledWindowAddWithViewport (sw, f)

	/* Create quit button */
//	qbtn := gtk_ButtonNew(,"Quit from application")
//	gtk_WidgetSetPosition(qbtn,160,110)
//	gtk_LayoutPut (f, qbtn)
//	gtk_WindowSetDefault(w, qbtn)
//	gtk_SignalConnect(qbtn,GTK_CLICKED_SIGNAL,{||gtk_Quit()})
//	gtk_WidgetAddAccelerator( qbtn, "clicked", w, GDK_q, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE )

	/* Menu */
	self:menu := abx_menu_new()
	gtk_MenuBarSetShadowType(self:menu:menubar, GTK_SHADOW_NONE)
	gtk_BoxPackStart (hb, self:menu:menubar)

	self:menu:disable_meta()
	self:menu:disable_data()
	self:menu:disable_open_dep()
	self:menu:disable_save_xml()

	/* Statusbar */
	self:statbar := gtk_StatusBarNew()
	gtk_BoxPackEnd(vb,self:statbar,.F.,.F.)
//	gtk_StatusBarSetText(self:statbar,"This is a status bar")

	/* Show main window */
	/***************************************************/
	gtk_WidgetShowAll( self:w )

//	gtk_WidgetHide(self:statbar)
	self:set_status()

	abx_events_init()

	self:set_events()

	abx_event_put(HASH_OpenDict)

return TRUE

static function abx_set_events(self)
	abx_event_add_handler(HASH_OpenDict,{||self:open_dict()})
	abx_event_add_handler(HASH_OpenDep,{||self:open_dep()})

	abx_event_add_handler(HASH_MetaAttr,{||self:browse_meta("ATTR")})
	abx_event_add_handler(HASH_MetaIndexes,{||self:browse_meta("INDEX")})
	abx_event_add_handler(HASH_MetaClasses,{||self:browse_meta("CLASS")})
	abx_event_add_handler(HASH_MetaExtents,{||self:browse_meta("EXTENT")})
	abx_event_add_handler(HASH_MetaPlugins,{||self:browse_meta("PLUGINS")})
	abx_event_add_handler(HASH_MetaCounters,{||self:browse_meta("COUNTER")})
	abx_event_add_handler(HASH_MetaGroups,{||self:browse_meta("GROUP")})
	abx_event_add_handler(HASH_MetaUsers,{||self:browse_meta("USER")})
	abx_event_add_handler(HASH_MetaDeps,{||self:browse_meta("DEPOSIT")})
	abx_event_add_handler(HASH_MetaColumns,{||self:browse_meta("TCOLUMN")})
	abx_event_add_handler(HASH_MetaTblViews,{||self:browse_meta("TVIEW")})
	abx_event_add_handler(HASH_MetaReports,{||self:browse_meta("REPORT")})

	abx_event_add_handler(HASH_DataViewObjects,{||self:browse_data()})

	abx_event_add_handler(HASH_SrvLoadXML,{||self:load_xml()})
	abx_event_add_handler(HASH_SrvSaveXML,{||self:save_xml()})

	*********************************************************************
	self:menu:enable_item(self:menu:mi_RunOql,FALSE)

//	self:menu:enable_item(self:menu:mi_DataViewObjects,FALSE)
	self:menu:enable_item(self:menu:mi_DataTableView,FALSE)
	self:menu:enable_item(self:menu:mi_DataOrderBy,FALSE)
	self:menu:enable_item(self:menu:mi_DataRunReport,FALSE)

	self:menu:enable_item(self:menu:mi_SrvTextEditor,FALSE)

	abx_event_add_handler(HASH_AbxExit,{||self:ask_quit()})
	abx_event_add_handler(HASH_AbxQuit,{||self:quit()})
return

static function abx_run(self)

	idle_descr := gtk_IdleAdd(,{||abx_run_queue(),gtk_MainIterationDo(FALSE),TRUE})

	/* Do GTK+ events */
	gtk_main()

return

static function abx_quit(self)

	gtk_IdleRemove(idle_descr)

	while gtk_MainLevel() > 1
		gtk_Quit()
	enddo
	if gtk_MainLevel() > 0
		gtk_Quit()
	endif
return

static function abx_done(self)
	self:close_dep()
	self:close_dict()
return TRUE

static function abx_close_dep(self)
	if self:depository != nil
		self:depository:close()
		self:depository := nil
		self:dep_name := [Not opened]
	endif
return TRUE

static function abx_close_dict(self)
	if self:dictionary != nil
		self:dictionary:close()
		self:dictionary := nil
		self:dict_name := [Not opened]
	endif
return TRUE

static function abx_ask_quit(self)
	local dlg, btn_Ok, btn_Cancel

	dlg := gtk_DialogNew(,[Exit])
	gtk_WindowSetModal(dlg, TRUE)
	gtk_WidgetSetSize(dlg,400,100)
	gtk_ContainerAdd(dlg:VBox,gtk_LabelNew(,[Do you want to exit ?]))
	gtk_WindowSetTransientFor(dlg,self:w)
	gtk_WindowSetPosition(dlg, GTK_WIN_POS_CENTER)
	gtk_SignalConnect(dlg,"delete-event",{||abx_quit_dlg_cancel(dlg)})

	btn_Ok := gtk_ButtonNew(,[Ok])
	gtk_SignalConnect(btn_Ok,"clicked",{||abx_quit_dlg_ok(dlg)})
	gtk_ContainerAdd(dlg:ActionArea,btn_Ok)

	btn_Cancel := gtk_ButtonNew(,[Cancel])
	gtk_SignalConnect(btn_Cancel,"clicked",{||abx_quit_dlg_cancel(dlg)})
	gtk_ContainerAdd(dlg:ActionArea,btn_Cancel)

	gtk_WindowSetDefault(dlg,btn_Ok)
	gtk_WidgetAddAccelerator(btn_Cancel, "clicked", dlg, GDK_Escape)

	gtk_WidgetShowAll(dlg)
	gtk_WindowSetFocus(dlg,btn_Ok)
	gtk_Main()
return

static function abx_quit_dlg_ok(dlg)
	gtk_WidgetDestroy(dlg)
	abx_event_put(HASH_AbxQuit)
	gtk_Quit()
return

static function abx_quit_dlg_cancel(dlg)
	gtk_WidgetDestroy(dlg)
	gtk_Quit()
return

static function abx_set_status(self,stat_text)
	local text

	if empty(stat_text)
		stat_text := [Dictionary]+": "+self:dict_name+"  "
		stat_text += [Depository]+": "+self:dep_name
	endif
	gtk_StatusBarSetText(self:statbar,stat_text)
return

static function abx_open_dict(self)
	local m, i, Selected, dict_name
	local err, dict, tmp, new := FALSE

	if self:dict_list == nil
		self:dict_list := codbList():new()
		if val(self:dict_list:error) > 0
			abx_msgbox([Error open dictionary list]+"!;"+self:dict_list:error)
			self:dict_list:close()
			return FALSE
		endif
	endif

	m := self:dict_list:list()
	aadd(m,[Create new dictionary     ])

	Selected := abx_achoice(m,[Choice Dictionary],400,250)

	if Selected == 0; return FALSE; endif

	dict_name := substr(m[Selected],1,at(":",m[Selected])-1)

	self:close_dep()
	self:close_dict()

	self:menu:disable_data()

	if Selected == len(m)
		tmp := self:dict_list:PadrBody(map())
		if self:edit_dict(tmp)
			dict_name := self:dict_list:append(tmp)
			if !empty(self:dict_list:error)
				abx_msgbox(self:dict_list:error,[Error creating dictionary])
			endif
		endif
		new := TRUE
	endif

	if !empty(dict_name)
		self:dictionary := self:dict_list:connect(dict_name)
		if val(self:dictionary:error) != 0
			abx_msgbox(self:dictionary:error,[Error connect to dictionary])
			self:dictionary := nil
			return FALSE
		endif
	endif

	if new .and. self:dictionary != nil
		self:dictionary:create()
	endif

	if self:dictionary != nil
		self:dictionary:open()
		if val(self:dictionary:error) != 0
			abx_msgbox(self:dictionary:error,[Error opening dictionary])
			self:dictionary := nil
			return FALSE
		endif
		self:menu:enable_meta()
		self:menu:enable_save_xml()
		self:menu:enable_item(self:menu:mi_OpenDep)

		self:dict_name := self:dictionary:name
	endif

	self:set_status()

	abx_event_put(HASH_OpenDep)
return TRUE

static function abx_edit_dict(self,data)
	local dstru, aTypes, aDTypes, vTypes, sTypes
	local dlg, tbl, btn_Save, btn_Cancel
	local edId, edName, cbType, cbDType, edPath
	local edHost, edPort, edUserName, edDBName
	local tmp, i, cancelled := TRUE

	dstru := codb_info("CODB_DICTLIST_STRUCTURE")

	dlg := gtk_DialogNew(,[Please fill dictionary parameters])
	gtk_WindowSetModal(dlg, TRUE)
//	gtk_WidgetSetSize(dlg,400,100)
	gtk_WindowSetTransientFor(dlg,self:w)
	gtk_WindowSetPosition(dlg, GTK_WIN_POS_CENTER)
	gtk_ContainerSetBorderWidth(dlg, 20)
	gtk_SignalConnect(dlg,"delete-event",{||abx_quit_dlg_cancel(dlg)})
	tbl := gtk_TableNew(,9,2)
	gtk_ContainerAdd(dlg:VBox,tbl)

	abx_tbl_new_label(tbl, 1,1, [Ident]+":")
	edId := abx_tbl_new_getobj(tbl,"C",, 1,2)

	abx_tbl_new_label(tbl, 2,1, [Name])
	edName := abx_tbl_new_getobj(tbl,"C",, 2,2)

	aTypes := codb_info("CODB_DICT_TYPES")
	sTypes := {}; vTypes := {}
	for i := 1 to len(aTypes)
	  aadd(sTypes,aTypes[i])
	  aadd(vTypes,aTypes[i])
	next
	abx_tbl_new_label(tbl, 3,1, [Type])
	cbType := abx_combo_new(sTypes,vTypes)
	abx_tbl_put_widget(tbl,cbType:widget, 3,2)

	aDTypes := codb_info("CODB_DICT_DTYPES")
	abx_tbl_new_label(tbl, 4,1, [Data type])
	cbDType := abx_combo_new(aDTypes,aDTypes)
	abx_tbl_put_widget(tbl,cbDType:widget, 4,2)

	abx_tbl_new_label(tbl, 5,1, [Path])
	edPath := abx_tbl_new_getobj(tbl,"C",, 5,2)

	abx_tbl_new_label(tbl, 6,1, [Host name])
	edHost := abx_tbl_new_getobj(tbl,"C",, 6,2)

	abx_tbl_new_label(tbl, 7,1, [SQL port])
	edPort := abx_tbl_new_getobj(tbl,"N",, 7,2)

	abx_tbl_new_label(tbl, 8,1, [User name])
	edUserName := abx_tbl_new_getobj(tbl,"C",, 8,2)

	abx_tbl_new_label(tbl, 9,1, [SQL DB name])
	edDBName := abx_tbl_new_getobj(tbl,"C",, 9,2)

	************

	btn_Save := gtk_ButtonNew(,[Save])
	gtk_SignalConnect(btn_Save,"clicked",{||cancelled := FALSE, ;
		gtk_WidgetHide(dlg),gtk_Quit(),})
	gtk_ContainerAdd(dlg:ActionArea,btn_Save)

	btn_Cancel := gtk_ButtonNew(,[Cancel])
	gtk_SignalConnect(btn_Cancel,"clicked",{||cancelled := TRUE, ;
		gtk_WidgetHide(dlg),gtk_Quit(),})
	gtk_ContainerAdd(dlg:ActionArea,btn_Cancel)

	gtk_WindowSetDefault(dlg,btn_Save)
	gtk_WidgetAddAccelerator(btn_Cancel, "clicked", dlg, GDK_Escape)

	edId:set_value(data:id)
	edName:set_value(data:name)
	cbType:set_value(alltrim(data:type))
	cbDType:set_value(alltrim(data:dtype))
	edPath:set_value(data:path)
	edHost:set_value(data:host)
	edPort:set_value(data:port)
	edUserName:set_value(data:user)
	edDBName:set_value(data:dbname)

	gtk_WidgetShowAll(dlg)
	gtk_WindowSetFocus(dlg,edId:widget)
	gtk_Main()

	if .not. cancelled
		data:id :=     edId:get_value()
		data:name :=   edName:get_value()
		data:type :=   cbType:get_value()
		data:dtype :=  cbDType:get_value()
		data:path :=   edPath:get_value()
		data:host :=   edHost:get_value()
		data:port :=   edPort:get_value()
		data:user :=   edUserName:get_value()
		data:dbname := edDBName:get_value()
	endif

	gtk_WidgetDestroy(dlg)

return !cancelled

static function abx_open_dep(self)
	local i, m := {}, Selected
	local dep_list, dep

	if self:dictionary == nil
		abx_msgbox([Dictionary is not opened],[Error])
		return FALSE
	endif

	dep_list := self:dictionary:select("DEPOSIT")
	for i:=1 to len(dep_list)
		dep := self:dictionary:GetValue(dep_list[i])
		aadd(m,dep:name)
	next

	Selected := abx_achoice(m,[Choice Depository],400,250)

	if Selected == 0
		return FALSE
	endif

	self:close_dep()

	self:menu:disable_data()

	self:depository := self:dictionary:depository(dep_list[Selected])
	self:depository:name := m[Selected]
	if empty(self:depository:error)
		self:depository:open()
	endif
	if !empty(self:depository:error)
		abx_msgbox(self:depository:error,[Error opening depository])
		self:close_dep()
		return FALSE
	endif

	self:dep_name := self:depository:name

	self:set_status()

	self:menu:enable_data()
return TRUE

static function abx_browse_meta(self,MetaName)
	local oIdList := nil, mbr

	oIdList := self:dictionary:IdList(MetaName)
	if oIdList != nil .and. empty(self:dictionary:error)
		mbr := abx_meta_browse_new(oIdList)
		if empty(mbr:error)
			mbr:run()
			return TRUE
		else
			abx_msgbox(mbr:error,[Error browsing meta]+" "+MetaName)
			return FALSE
		endif
	endif

	abx_msgbox(self:dictionary:error,[Error browsing meta]+" "+MetaName)
return FALSE

static function abx_browse_data(self)
	local oIdList := nil, br, class, name, id

	class := abx_class_choice(self:dictionary)
	if empty(class)
		return FALSE
	endif

	name := iif("NAME" $ class, class:name, "")
	id := iif("ID" $ class, class:id, "")

	oIdList := self:depository:IdList(class:id)

	if oIdList != nil .and. empty(oIdList:error)
		br := abx_data_browse_new(oIdList)
		if empty(br:error)
			br:run()
			return TRUE
		else
			abx_msgbox(br:error,[Error browsing data]+" "+alltrim(name)+;
				" ("+alltrim(id)+")")
			return FALSE
		endif
	endif

	abx_msgbox(oIdList:error,[Error browsing data]+" "+alltrim(name)+" ("+alltrim(id)+")")
return FALSE

static function abx_load_xml(self)
	local fsdlg, filename := nil, ftmp
	local pos1, pos2, s

	fsdlg := gtk_FileSelectionNew(,[Select XML file to load metadata])
	gtk_SignalConnect(fsdlg:OkButton,"clicked", ;
		{||filename := gtk_FileSelectionGetFilename(fsdlg), ;
		gtk_WidgetDestroy(fsdlg), gtk_Quit()})
	gtk_SignalConnect(fsdlg:CancelButton,"clicked", ;
		{||gtk_WidgetDestroy(fsdlg), ;
		gtk_Quit()})

	gtk_WidgetShow(fsdlg)
	gtk_Main()

	if !empty(filename)
		pos1 := atr(PATH_DELIM,filename)
		pos2 := atr(".",filename)
		s := padr(substr(filename,pos1+1,pos2-pos1-1),5)
		ftmp := tmpfile()+".log"
//		fcreate(ftmp)
//		fclose(ftmp)
//? __FILE__,__LINE__,ftmp
//		SET CONSOLE OFF
//		SET PRINTER ON
//		SET PRINTER TO (ftmp)
//		SET DEVICE TO PRINTER
//? __FILE__,__LINE__,ftmp
		codb_install(s,filename)
//		SET CONSOLE ON
//		SET PRINTER OFF
//		SET PRINTER TO
//		SET DEVICE TO SCREEN
	endif
return

static function abx_save_xml(self)
	local fsdlg, filename := nil, err

	fsdlg := gtk_FileSelectionNew(,[Select XML file to save metadata])
	gtk_SignalConnect(fsdlg:OkButton,"clicked", ;
		{||filename := gtk_FileSelectionGetFilename(fsdlg), ;
		gtk_WidgetDestroy(fsdlg), gtk_Quit()})
	gtk_SignalConnect(fsdlg:CancelButton,"clicked", ;
		{||gtk_WidgetDestroy(fsdlg), ;
		gtk_Quit()})

	gtk_WidgetShow(fsdlg)
	gtk_Main()

	if !empty(filename)
		err := abx_meta_to_xml(self:dictinoary,filename)
		if !empty(err)
			abx_msgbox(err)
		endif
	endif
return

