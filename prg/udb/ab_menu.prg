/*
    Copyright (C) 2002-2005  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "inkey.ch"
#include "imenu.ch"
#include "set.ch"

************************************************
function make_ab_menu()
	local obj:=map()

	obj:classname	:= "AB_MENU"
	obj:activate	:= @menu_activate()
	obj:handleKey	:= @menu_key()
	obj:create	:= @menu_create()
	obj:enableMeta	:= @menu_EnableMeta()
	obj:disableMeta	:= @menu_DisableMeta()
	obj:enableData	:= @menu_EnableData()
	obj:disableData	:= @menu_DisableData()
	obj:enableChoice:= @menu_EnableChoice()
	obj:disableChoice:= @menu_DisableChoice()

	obj:menu := obj:create()
	setcolor(set("ab_colors_menu"))
	obj:disableMeta()
	obj:menu:select(0)
	obj:menu:display()
	obj:menu:select(1)

return obj
************************************************
static function menu_enableMeta()
	::__itemDep:enabled:=.t.
	::__itemDeps:enabled:=.t.
	::__itemCols:enabled:=.t.
	::__itemTviews:enabled:=.t.
	::__itemReports:enabled:=.t.
	::__itemPlugins:enabled:=.t.
	::__itemAttrs:enabled:=.t.
	::__itemIndexes:enabled:=.t.
	::__itemCounters:enabled:=.t.
	::__itemExtents:enabled:=.t.
	::__itemClasses:enabled:=.t.
	::__itemUsers:enabled:=.t.
	::__itemGroups:enabled:=.t.
	//::__MetaLoadFromXml:enabled:=.t.
	::__MetaSaveToXml:enabled:=.t.
return
************************************************
static function menu_disableMeta()
	::__itemDep:enabled:=.f.
	::__itemDeps:enabled:=.f.
	::__itemCols:enabled:=.f.
	::__itemTviews:enabled:=.f.
	::__itemPlugins:enabled:=.f.
	::__itemAttrs:enabled:=.f.
	::__itemIndexes:enabled:=.f.
	::__itemCounters:enabled:=.f.
	::__itemExtents:enabled:=.f.
	::__itemClasses:enabled:=.f.
	::__itemUsers:enabled:=.f.
	::__itemGroups:enabled:=.f.
	//::__MetaLoadFromXml:enabled:=.f.
	::__MetaSaveToXml:enabled:=.f.
	::disableData()
return
************************************************
static function menu_enableData()
	::__itemObjects:enabled:=.t.
return
************************************************
static function menu_disableData()
	::__itemObjects:enabled:=.f.
	::disableChoice()
return
************************************************
static function menu_enableChoice()
	::__chReport:enabled:=.t.
	::__chTview:enabled:=.t.
	::__chOrder:enabled:=.t.
return
************************************************
static function menu_disableChoice()
	::__chReport:enabled:=.f.
	::__chTview:enabled:=.f.
	::__chOrder:enabled:=.f.
return
************************************************
static function menu_activate(nMenu)
	local ret,curr,curWin:=wselect()
	curr:=iif(nMenu==NIL,::menu:current,nMenu)
	while dispcount()>0
	   dispend()
	enddo
	__keyboard(13)
	ret := MenuModal(::menu,curr,maxrow(),0,maxcol(),set("ab_colors_menu"))
	curr := ::menu:current
	dispbegin()
	::menu:Select(0)
	::menu:Display()
	::menu:Select(curr)
	wselect(curWin)
	dispend()
return ret
************************************************
static function menu_key(hkey)
	local nMenu:=0
	if hkey==HASH_CallMenu
		hkey:=::activate()
	endif
	if hkey==HASH_MenuItem1
		nMenu:=1
	endif
	if hkey==HASH_MenuItem2
		nMenu:=2
	endif
	if hkey==HASH_MenuItem3
		nMenu:=3
	endif
	if hkey==HASH_MenuItem4
		nMenu:=4
	endif
	if hkey==HASH_MenuItem5
		nMenu:=5
	endif
	if hkey==HASH_MenuItem6
		nMenu:=6
	endif
	if hkey==HASH_MenuItem7
		nMenu:=7
	endif
	if hkey==HASH_MenuItem8
		nMenu:=8
	endif
	if hkey==HASH_MenuItem9
		nMenu:=9
	endif
	if nMenu!=0
		hkey:=::activate(nmEnu)
	endif
return hkey

************************************************
static function menu_create()
   local oTopBar, oPopUp, oPopUp1, oItem
   local mapkeys:=HK_get("ab"),kn

      oTopBar := TopBar( 0, 0, maxcol())
      oTopBar:ColorSpec := set("ab_colors_menu")

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("ab_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Open],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,HASH_OpenDict))
      oItem :=MenuItem( [&Dictionary        ]+kn ,{|| .t. }, ,[Open CODB dictionary], HASH_OpenDict)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys, HASH_OpenDep))
      oItem :=MenuItem( [&Depository       ]+kn ,{|| .t. }, ,[Open CODB depository], HASH_OpenDep)
      oItem:enabled:=.f.
      ::__itemDep:=oItem
      oPopUp:AddItem( oItem)

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(mapkeys,HASH_OpenOqlQuery))
      oItem :=MenuItem( [&OQL query        ]+kn ,{|| .t. }, ,[Open result of OQL query], HASH_OpenOqlQuery)
      oPopUp:AddItem( oItem)

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_Exit))
      oItem :=MenuItem( [E&xit             ]+kn ,{|| .t. }, ,[Exit to OS], HASH_Exit)
      oPopUp:AddItem( oItem)

**************************************************************************
      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("ab_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Meta],oPopUp) )


      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewAttrs))
      oItem :=MenuItem( [&Attributes    ]+kn ,{|| .t. }, ,[View and edit attributes information], HASH_ViewAttrs)
      oItem:enabled:=.f.
      ::__itemAttrs:=oItem
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewIndexes))
      oItem :=MenuItem( [&Indexes       ]+kn ,{|| .t. }, ,[View and edit data indexes information], HASH_ViewIndexes)
      oItem:enabled:=.f.
      ::__itemIndexes:=oItem
      oPopUp:AddItem( oItem)


      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewClasses))
      oItem :=MenuItem( [&Classes       ]+kn ,{|| .t. }, ,[View and edit classes information], HASH_ViewClasses)
      oItem:enabled:=.f.
      ::__itemClasses:=oItem
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewExtents))
      oItem :=MenuItem( [&Extents       ]+kn ,{|| .t. }, ,[View and edit extents information], HASH_ViewExtents)
      oItem:enabled:=.f.
      ::__itemExtents:=oItem
      oPopUp:AddItem( oItem)

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewPlugins))
      oItem :=MenuItem( [&Plugins     ]+kn ,{|| .t. }, ,[View and edit plugin information], HASH_ViewPlugins)
      oItem:enabled:=.f.
      ::__itemPlugins:=oItem
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewCounters))
      oItem :=MenuItem( [&Counters      ]+kn ,{|| .t. }, ,[View and edit data counters information], HASH_ViewCounters)
      oItem:enabled:=.f.
      ::__itemCounters:=oItem
      oPopUp:AddItem( oItem)

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewGroups))
      oItem :=MenuItem( [&Groups        ]+kn ,{|| .t. }, ,[View and edit groups information], HASH_ViewGroups)
      oItem:enabled:=.f.
      ::__itemGroups:=oItem
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewUsers))
      oItem :=MenuItem( [&Users         ]+kn ,{|| .t. }, ,[View and edit users information], HASH_ViewUsers)
      oItem:enabled:=.f.
      ::__itemUsers:=oItem
      oPopUp:AddItem( oItem)

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewDeps))
      oItem :=MenuItem( [&Depositories  ]+kn ,{|| .t. }, ,[View and edit depositories information], HASH_ViewDeps)
      oItem:enabled:=.f.
      ::__itemDeps:=oItem
      oPopUp:AddItem( oItem)

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewColumns))
      oItem :=MenuItem( [&Columns       ]+kn ,{|| .t. }, ,[View and edit columns information], HASH_ViewColumns)
      oItem:enabled:=.f.
      ::__itemCols:=oItem
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewTviews))
      oItem :=MenuItem( [&Table views   ]+kn ,{|| .t. }, ,[View and edit table views information], HASH_ViewTviews)
      oItem:enabled:=.f.
      ::__itemTviews:=oItem
      oPopUp:AddItem( oItem)

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewReports))
      oItem :=MenuItem( [&Reports       ]+kn ,{|| .t. }, ,[View and edit reports information], HASH_ViewReports)
      oItem:enabled:=.f.
      ::__itemReports:=oItem
      oPopUp:AddItem( oItem)

**************************************************************************
      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("ab_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Data],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewObjects))
      oItem :=MenuItem( [&View Objects   ]+kn ,{|| .t. },,[View objects in one class ], HASH_ViewObjects)
      oPopUp:AddItem( oItem)
      oItem:enabled:=.f.
      ::__itemObjects:=oItem

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_ChoiceTview))
      oItem :=MenuItem( [&Table view    ]+kn ,{|| .t. }, ,[Choice table view], HASH_ChoiceTview)
      oItem:enabled:=.f.
      ::__chTview:=oItem
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_ChoiceOrder))
      oItem :=MenuItem( [&Order by      ]+kn ,{|| .t. }, ,[Choice data order], HASH_ChoiceOrder)
      oItem:enabled:=.f.
      ::__chOrder:=oItem
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_ChoiceReport))
      oItem :=MenuItem( [&Report run    ]+kn ,{|| .t. }, ,[Choice report], HASH_ChoiceReport)
      oItem:enabled:=.f.
      ::__chReport:=oItem
      oPopUp:AddItem( oItem)

**************************************************************************
      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("ab_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Service],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_TextEdit))
      oItem :=MenuItem( [&Text Editor    ]+kn ,{|| .t. },,[Call text editor ], HASH_TextEdit)
      oPopUp:AddItem( oItem)
      oItem:enabled:=.t.

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_MetaLoadFromXml))
      oItem :=MenuItem( [&Load meta XML ]+kn ,{|| .t. }, ,[Load meta data from XML file], HASH_MetaLoadFromXml)
      //oItem:enabled:=.f.
      //::__MetaLoadFromXml:=oItem
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_MetaSaveToXml))
      oItem :=MenuItem( [&Save meta XML ]+kn ,{|| .t. }, ,[Save meta data to XML file], HASH_MetaSaveToXml)
      oItem:enabled:=.f.
      ::__MetaSaveToXml:=oItem
      oPopUp:AddItem( oItem)

/*
      kn:=key_name(HK_get_key(mapkeys,  HASH_ChoiceOrder))
      oItem :=MenuItem( [&Order by      ]+kn ,{|| .t. }, ,[Choice data order], HASH_ChoiceOrder)
      oItem:enabled:=.f.
      ::__chOrder:=oItem
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_ChoiceReport))
      oItem :=MenuItem( [&Report run    ]+kn ,{|| .t. }, ,[Choice report], HASH_ChoiceReport)
      oItem:enabled:=.f.
      ::__chReport:=oItem
      oPopUp:AddItem( oItem)
      */

return ( oTopBar)

