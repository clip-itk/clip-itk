/*
    Copyright (C) 2003  ITK
    Author   : Alexey M. Tkachenko (alexey@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include <clip-gtk.ch>
#include <inkey.ch>
#include "abx.ch"

function abx_meta_browse_new(oIdList)
	local obj := map()

	obj:win		:= nil
	obj:error 	:= nil

	obj:IdList	:= oIdList
	obj:init	:= @abx_meta_browse_init()
	obj:run		:= @abx_meta_browse_run()
	obj:done	:= @abx_meta_browse_done()

	obj:init()
return obj

static function abx_meta_browse_init(self)
	local win, lst, swin, hpaned, l, vbox, hbox, btnAdd, btnDel, vbox2, hbox2
	local i
	local MetaPlugin, InitCard, FillCard
	local SaveCard
	local Card

	self:win := win := gtk_WindowNew(,self:IdList:MetaName)
	gtk_WindowSetDefaultSize(win,600,400)
	gtk_SignalConnect(win,"delete-event",{||self:done()})

	hpaned := gtk_HPanedNew()
	gtk_ContainerAdd(win,hpaned)

	/* Left side - list of meta */
	swin := gtk_ScrolledWindowNew()
	self:list := lst := gtk_CListNew(,1,[Metadata name])
	gtk_CListColumnTitlesShow(lst)
	gtk_CListSetSelectionMode(lst,GTK_SELECTION_BROWSE)
	gtk_SignalConnect(win,"key-press-event",{|wid,ev|iif(ev:keyval==K_ESC,abx_meta_browse_done(self),nil)})
	gtk_SignalConnect(lst,"key-press-event",{|wid,ev|iif(ev:keyval==K_ESC,abx_meta_browse_done(self),nil)})

	gtk_ContainerAdd(swin,lst)

	vbox := gtk_VBoxNew()
	gtk_PanedAdd1(hpaned,vbox)
	gtk_BoxPackStart(vbox,swin,TRUE,TRUE)

	i := 1
	do while !self:IdList:eof()
		gtk_CListAppend(lst,self:IdList:GetValue("NAME"))
		gtk_CListSetRowData(lst,i,self:IdList:currId)
		self:IdList:skip()
		i ++
	enddo

	gtk_WindowSetFocus(win,lst)

	/* Right side - view/edit card */
	MetaPlugin := abx_load_plugin(self:IdList:MetaName)
	if valtype(MetaPlugin) == "C"
		abx_msgbox(MetaPlugin,[Error loading plugin])
		return TRUE
	endif

	InitCard := eval(MetaPlugin,"GTK_INIT_CARD")
	if valtype(InitCard) == "C"
		abx_msgbox(InitCard,[Error initialising edit card])
		return TRUE
	endif

	FillCard := eval(MetaPlugin,"GTK_FILL_CARD")
	if valtype(FillCard) == "C"
		FillCard := {||abx_msgbox([Can`t fill edit card],[Error filling card])}
		return TRUE
	endif

	SaveCard := eval(MetaPlugin,"GTK_SAVE_CARD")
	if valtype(SaveCard) == "C"
		SaveCard := {||abx_msgbox([Can`t save object],[Error])}
		return TRUE
	endif

	Card := EditCardNew()
	Card:dep := self:IdList:depository()
	Card:on_init := {||gtk_WidgetSetSensitive(self:btnSave,FALSE), ;
		gtk_WidgetSetSensitive(self:btnCancel,FALSE) }
	Card:on_change := {||gtk_WidgetSetSensitive(self:btnSave,TRUE), ;
		gtk_WidgetSetSensitive(self:btnCancel,TRUE) }

	eval(InitCard,Card)

	vbox2 := gtk_VBoxNew()
	gtk_PanedAdd2(hpaned,vbox2)
	gtk_BoxPackStart(vbox2,Card:widget,TRUE,TRUE)

	hbox2 := gtk_HBoxNew()
	gtk_BoxPackEnd(vbox2,hbox2,.F.)
	self:btnSave := gtk_ButtonNew(,[Save])
	gtk_WidgetSetSensitive(self:btnSave,.F.)
	gtk_BoxPackStart(hbox2,self:btnSave,.T.,.T.,5)
	gtk_SignalConnect(self:btnSave,"clicked",{|wid|abx_meta_browse_save(self,SaveCard,Card)})

	self:btnCancel := gtk_ButtonNew(,[Cancel])
	gtk_BoxPackStart(hbox2,self:btnCancel,.T.,.T.,5)
	gtk_SignalConnect(self:btnCancel,"clicked",{|wid|abx_meta_browse_cancel(self,FillCard,Card)})
	gtk_WidgetSetSensitive(self:btnCancel,.F.)
//	gtk_PanedAdd2(hpaned,Card:widget)
	gtk_PanedSetPosition(hpaned,200)
//	abx_event_add_handler(HASH_DataChanged,{|ev|self:data_updated(ev)})

	gtk_SignalConnect(lst,"select-row", ;
		{|wid,ev|abx_meta_browse_row_selected(wid,ev,self,FillCard,Card)})

	gtk_SignalConnect(lst,"unselect-row", ;
		{|wid,ev|abx_meta_browse_row_unselected(wid,ev,self,FillCard,Card)})

	gtk_CListSelectRow(lst,1)

	hbox := gtk_HBoxNew()
	gtk_BoxSetSpacing(hbox,5)

	btnAdd := gtk_ButtonNew(,[Add])
	gtk_BoxPackStart(hbox,btnAdd,TRUE,TRUE)
	gtk_SignalConnect(btnAdd,"clicked", ;
		{|wid,ev|abx_meta_browse_add(wid,ev,self,FillCard,Card)})

	btnDel := gtk_ButtonNew(,[Delete])
	gtk_BoxPackStart(hbox,btnDel,TRUE,TRUE)
	gtk_SignalConnect(btnDel,"clicked", ;
		{|wid,ev|abx_meta_browse_del(wid,ev,self)})

	gtk_BoxPackStart(vbox,hbox,FALSE,FALSE)
return TRUE

static function abx_meta_browse_row_selected(lst,ev,MBr,FillCard,Card)
	local data, id

	id := gtk_CListGetRowData(lst,ev:row)
	MBr:IdList:GotoID(id)
	data := MBr:IdList:GetValue()

	eval(FillCard,Card,data)
	card:on_init()
return TRUE

static function abx_meta_browse_row_unselected(lst,ev,MBr,FillCard,Card)
	eval(FillCard,Card,nil)
	card:on_init()
return TRUE

static function abx_meta_browse_cancel(self,FillCard,Card)
	eval(FillCard,Card,Card:data)
	card:on_init()
	gtk_WidgetGrabFocus(self:list)
return TRUE

static function abx_meta_browse_save(self,SaveCard,Card)
	local sel, id, row, data

	if empty(Card:data)
		card:on_init()
		return FALSE
	endif

	if eval(SaveCard,Card) == FALSE
		return FALSE
	endif

	data := Card:data
	if !HASH_ID$data .or. empty(data:id)
		self:IdList:add(data)
		if !empty(self:IdList:error)
			abx_msgbox(self:IdList:error,[Error adding new object])
			return FALSE
		endif
		gtk_CListAppend(self:list,data:name)
		row := gtk_CListGetRowCount(self:list)
		gtk_CListSetRowData(self:list,row,data:Id)
		gtk_CListSelectRow(self:list,row)
	else
		if !self:IdList:Update(data)
			abx_msgbox(self:IdList:error,[Error updating data])
			return FALSE
		endif
		sel := gtk_CListGetSelection(self:list)
		if len(sel) > 0
			gtk_CListSetText(self:list,sel[1],1,data:name)
		endif
	endif
	card:on_init()
return TRUE

static function abx_meta_browse_add(btn,ev,MBr,FillCard,Card)
	local data, sel

	data := MBr:IdList:GetInfo(FALSE)
	sel := gtk_CListGetSelection(MBr:list)
	if len(sel) > 0
		gtk_CListUnselectRow(MBr:list,sel[1])
	endif
	eval(FillCard,Card,data)
	card:on_init()
return TRUE

static function abx_meta_browse_del(btn,ev,MBr)
	local data, id, sel, name, rows, row

	sel := gtk_CListGetSelection(MBr:list)
	if len(sel) == 0
		return FALSE
	endif
	row := sel[1]

	id := gtk_CListGetRowData(MBr:list,row)
	data := MBr:IdList:depository():GetValue(id)

	name := ""
	if HASH_NAME $ data
		name := data:name
	elseif HASH_SMALLNAME $ data
		name := data:smallname
	elseif HASH_FULLNAME $ data
		name := data:fullname
	endif
	if abx_msgbox([Delete, are you sure?]+";"+[Object]+' "'+alltrim(name) ;
		+'", ID='+data:id, ;
		[Delete],{[Yes],[No]},MBr:win) != 1
		return FALSE
	endif

	gtk_CListUnselectRow(MBr:list,row)

	if !MBr:IdList:GotoID(id) .or. MBr:IdList:CurrID != id
		abx_msgbox([Object identificator]+" "+id+";"+;
		[not found in IdList],[Delete error])
		return FALSE
	endif

	if !MBr:IdList:delete()
		abx_msgbox(MBr:IdList:Error,[Delete error])
		return FALSE
	endif

	gtk_CListRemove(MBr:list,row)
	rows := gtk_CListGetRowCount(MBr:list)
	if row > rows; row--; endif
	gtk_CListSelectRow(MBr:list,row)
return TRUE

static function abx_meta_browse_run(self)
	if self:win != nil
		gtk_WidgetShowAll(self:win)
	endif
return TRUE

static function abx_meta_browse_done(self)
	gtk_WidgetDestroy(self:win)
	self:win := nil
return TRUE

****************************************************************

static function EditCardNew()
	local obj := map()

	obj:dep		:= nil
	obj:widget	:= nil
	obj:data	:= nil
	obj:dict	:= nil
	obj:changed	:= FALSE
	obj:on_change	:= {||FALSE}
	obj:on_init	:= {||FALSE}
return obj
