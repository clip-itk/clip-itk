/*
    Copyright (C) 2003  ITK
    Author   : Alexey M. Tkachenko (alexey@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "abx.ch"
#include "clip-gtk.ch"

function abx_menu_new()
	local obj := map()

	obj:init	:= @abx_menu_init()

	obj:make_menuitem:= @abx_menu_make_menuitem()

	obj:enable_item	:= @abx_menu_enable_item()

	obj:enable_meta		:= {|self|self:enable_item(self:mi_Meta,TRUE)}
	obj:disable_meta	:= {|self|self:enable_item(self:mi_Meta,FALSE)}
	obj:enable_data		:= {|self|self:enable_item(self:mi_Data,TRUE)}
	obj:disable_data	:= {|self|self:enable_item(self:mi_Data,FALSE)}
	obj:enable_open_dep	:= {|self|self:enable_item(self:mi_OpenDep,TRUE)}
	obj:disable_open_dep	:= {|self|self:enable_item(self:mi_OpenDep,FALSE)}
	obj:enable_save_xml	:= {|self|self:enable_item(self:mi_SrvSaveXml,TRUE)}
	obj:disable_save_xml	:= {|self|self:enable_item(self:mi_SrvSaveXml,FALSE)}

	obj:init()

return obj

static function abx_menu_init(self)
//	local menubar, menubar2
//	local mi_Open, mi_Meta, mi_Data, mi_Service
//	local m_Open, m_Meta, m_Data, m_Service
	memvar MainWindow
/*
	local menu1i, menu2i, menu1, menu2
	local item1, item2, item3, item4, item5, hitem
	local rmg, radioitem1, radioitem2, radioitem3, checkitem
*/

	/***************************************************/
	/* Prepare menu bar */
	self:menubar:=gtk_MenuBarNew()

//	gtk_MenuBarSetShadowType(menubar, GTK_SHADOW_IN)
//	gtk_BoxPackStart (hb, menubar)

	/* Create submenu items */
	self:mi_Open:=self:make_menuitem([&Open]); gtk_MenuBarAppend(self:menubar,self:mi_Open)
	gtk_WidgetAddAccelerator(self:mi_Open, "activate-item", MainWindow, GDK_o, GDK_MOD1_MASK)

	self:mi_Meta:=self:make_menuitem([&Meta]); gtk_MenuBarAppend(self:menubar,self:mi_Meta)
	gtk_WidgetAddAccelerator(self:mi_Meta, "activate-item", MainWindow, GDK_m, GDK_MOD1_MASK)

	self:mi_Data:=self:make_menuitem([&Data]); gtk_MenuBarAppend(self:menubar,self:mi_Data)
	gtk_WidgetAddAccelerator(self:mi_Data, "activate-item", MainWindow, GDK_d, GDK_MOD1_MASK)

	self:mi_Service:=self:make_menuitem([&Services]); gtk_MenuBarAppend(self:menubar,self:mi_Service)
	gtk_WidgetAddAccelerator(self:mi_Service, "activate-item", MainWindow, GDK_s, GDK_MOD1_MASK)

	/* Create submenu */
	self:m_Open := gtk_MenuNew(); gtk_MenuItemSetSubmenu(self:mi_Open,self:m_Open)
	gtk_MenuAppend(self:m_Open, self:make_menuitem([Dictio&nary],HASH_OpenDict))
	gtk_MenuAppend(self:m_Open, self:mi_OpenDep := self:make_menuitem([&Depository],HASH_OpenDep))
	gtk_MenuAppend(self:m_Open, self:make_menuitem())
	gtk_MenuAppend(self:m_Open, self:mi_RunOql := self:make_menuitem([&Oql query],HASH_RunOql))
	gtk_MenuAppend(self:m_Open, self:make_menuitem())
	gtk_MenuAppend(self:m_Open, self:mi_Exit := self:make_menuitem([E&xit],HASH_AbxExit))
	gtk_WidgetAddAccelerator(self:mi_Exit, "activate", MainWindow, GDK_x, GDK_MOD1_MASK,GTK_ACCEL_VISIBLE)
	gtk_WidgetAddAccelerator(self:mi_Exit, "activate", MainWindow, GDK_q, GDK_CONTROL_MASK)

	self:m_Meta := gtk_MenuNew(); gtk_MenuItemSetSubmenu(self:mi_Meta,self:m_Meta)
	gtk_MenuAppend(self:m_Meta, self:mi_MetaAttr := self:make_menuitem([&Attributes],HASH_MetaAttr))
	gtk_MenuAppend(self:m_Meta, self:mi_MetaIndexes := self:make_menuitem([&Indexes],HASH_MetaIndexes))
	gtk_MenuAppend(self:m_Meta, self:mi_MetaClasses := self:make_menuitem([&Classes],HASH_MetaClasses))
	gtk_MenuAppend(self:m_Meta, self:mi_MetaExtents := self:make_menuitem([&Extents],HASH_MetaExtents))
	gtk_MenuAppend(self:m_Meta, self:make_menuitem())
	gtk_MenuAppend(self:m_Meta, self:mi_MetaPlugins := self:make_menuitem([&Plugins],HASH_MetaPlugins))
	gtk_MenuAppend(self:m_Meta, self:mi_MetaCounters := self:make_menuitem([&Counters],HASH_MetaCounters))
	gtk_MenuAppend(self:m_Meta, self:make_menuitem())
	gtk_MenuAppend(self:m_Meta, self:mi_MetaGroups := self:make_menuitem([&Groups],HASH_MetaGroups))
	gtk_MenuAppend(self:m_Meta, self:mi_MetaUsers := self:make_menuitem([&Users],HASH_MetaUsers))
	gtk_MenuAppend(self:m_Meta, self:make_menuitem())
	gtk_MenuAppend(self:m_Meta, self:mi_MetaDeps := self:make_menuitem([&Depositiories],HASH_MetaDeps))
	gtk_MenuAppend(self:m_Meta, self:make_menuitem())
	gtk_MenuAppend(self:m_Meta, self:mi_MetaColumns := self:make_menuitem([&Columns],HASH_MetaColumns))
	gtk_MenuAppend(self:m_Meta, self:mi_MetaTblViews := self:make_menuitem([&Table view],HASH_MetaTblViews))
	gtk_MenuAppend(self:m_Meta, self:make_menuitem())
	gtk_MenuAppend(self:m_Meta, self:mi_MetaReports := self:make_menuitem([&Reports],HASH_MetaReports))

	self:m_Data := gtk_MenuNew(); gtk_MenuItemSetSubmenu(self:mi_Data,self:m_Data)
	gtk_MenuAppend(self:m_Data, self:mi_DataViewObjects := self:make_menuitem([&View Objects],HASH_DataViewObjects))
	gtk_MenuAppend(self:m_Data, self:make_menuitem())
	gtk_MenuAppend(self:m_Data, self:mi_DataTableView := self:make_menuitem([&Table view],HASH_DataTableView))
	gtk_MenuAppend(self:m_Data, self:mi_DataOrderBy := self:make_menuitem([&Order by],HASH_DataOrderBy))
	gtk_MenuAppend(self:m_Data, self:mi_DataRunReport := self:make_menuitem([&Run report],HASH_DataRunReport))

	self:m_Service := gtk_MenuNew(); gtk_MenuItemSetSubmenu(self:mi_Service,self:m_Service)
	gtk_MenuAppend(self:m_Service, self:mi_SrvTextEditor := self:make_menuitem([&Text editor],HASH_SrvTextEditor))
	gtk_MenuAppend(self:m_Service, self:make_menuitem())
	gtk_MenuAppend(self:m_Service, self:mi_SrvLoadXML := self:mi_SrvSaveXml := self:make_menuitem([&Load XML Meta],HASH_SrvLoadXML))
	gtk_MenuAppend(self:m_Service, self:mi_SrvSaveXML := self:make_menuitem([&Save XML Meta],HASH_SrvSaveXML))
/*
	mi_Dict := gtk_MenuItemNew(,[&Dictionary],"&"); gtk_MenuAppend(m_Open, mi_Dict)
	mi_Dep := gtk_MenuItemNew(,[&Depository],"&"); gtk_MenuAppend(m_Open, mi_Dep)
	mi_Divider := gtk_MenuItemNew(); gtk_MenuAppend(m_Open, mi_Divider)
	mi_Oql := gtk_MenuItemNew(,[&Oql],"&"); gtk_MenuAppend(m_Open, mi_Oql)
	mi_Exit := gtk_MenuItemNew(,[E&xit],"&"); gtk_MenuAppend(m_Open, mi_Exit)
*/

/*
	/* Create submenu */
	menu1:=gtk_MenuNew()

	/* Create menu items */
	item1:=gtk_MenuItemNew(,"Item 1")
	item2:=gtk_MenuItemNew(,"Item 2")
	item3:=gtk_MenuItemNew(,"Item 3")
	item4:=gtk_MenuItemNew(,"Item 4")
	item5:=gtk_MenuItemNew(,"Item 5")

	/* Create radio menu group */
	rmg:=gtk_RadioMenuGroupNew()

	/* Create radio menu items */
	radioitem1:=gtk_RadioMenuItemNew(,rmg,"RadioItem1")
	radioitem2:=gtk_RadioMenuItemNew(,rmg,"RadioItem2")
	gtk_CheckMenuItemSetActive(radioitem2)
	radioitem3:=gtk_RadioMenuItemNew(,,"RadioItem3")
	gtk_RadioMenuItemSetGroup(radioitem3,rmg)

	/* Create check menu item */
	checkitem:=gtk_CheckMenuItemNew(,"Check Item")
	gtk_CheckMenuItemSetActive(checkitem)

	/* Create submenu 2 item */
	menu2i = gtk_MenuItemNew(,"menu2")

	/* Create submenu 2 */
	menu2:=gtk_MenuNew()
	gtk_MenuAppend(menu2, item4)
	gtk_MenuAppend(menu2, item5)

	/* Create menubar */
	gtk_MenuAppend(menu1, item1)
	gtk_MenuAppend(menu1, item2)
	gtk_MenuAppend(menu1, radioitem1)
	gtk_MenuAppend(menu1, radioitem2)
	gtk_MenuAppend(menu1, radioitem3)
	gtk_MenuAppend(menu1, checkitem)
	gtk_MenuAppend(menu1, menu2i)
	gtk_MenuItemSetSubmenu(menu2i,menu2)
	gtk_MenuBarAppend(menubar,menu1i)
	gtk_MenuItemSetSubmenu(menu1i,menu1)
	gtk_MenuBarAppend(menubar,item3)

	/* Create help menu item */
	hitem:=gtk_MenuItemNew(,"Help")

	/* Create menu bar 2 */
	menubar2:=gtk_MenuBarNew()
	gtk_MenuBarAppend(menubar2,hitem)
	gtk_BoxPackEnd (hb, menubar2)
*/
return TRUE

static function abx_menu_make_menuitem(self,Name,Event)
	local item := gtk_MenuItemNew(,Name,"&")
	memvar MainWindow

	if !empty(Event)
		item:__event := Event
		gtk_SignalConnect(item,"activate",{|wid,e|abx_event_put(wid:__event)})
	endif

	if empty(Name)
		gtk_WidgetSetState(item, GTK_STATE_INSENSITIVE)
	endif

	if item:AccelKey != 0
//? __FILE__,__LINE__,procname(),Name,ntoc(item:AccelKey,16)
		gtk_WidgetAddAccelerator(item, "activate", self, item:AccelKey)
	endif
return item

static function abx_menu_enable_item(self,item,Enable)
	if valtype(Enable)=="L" .and. Enable == FALSE
		gtk_WidgetSetSensitive(item,FALSE)
	else
		gtk_WidgetSetSensitive(item,TRUE)
	endif
return TRUE
