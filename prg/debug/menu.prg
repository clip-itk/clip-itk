/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "inkey.ch"
#include "debug.ch"
#include "imenu.ch"
#include "set.ch"
#include "ctwin.ch"

************************************************
function make_debug_menu(dbg_obj)
	local obj:=map()

        obj:classname	:= "DBG_MENU"
        obj:dbg		:= dbg_obj
        obj:activate	:= @menu_activate()
        obj:handleKey	:= @menu_key()
        obj:create	:= @menu_create()
        obj:numeration	:= @menu_numeration()
        obj:cbTraceStyle:= @menu_cbTraceStyle()
        obj:preprocStyle:= @menu_preprocStyle()

	obj:menu := obj:create()
        setcolor(set("debug_colors_menu"))
        obj:winNo:=wopen(0,0,dbg_obj:maxrow,dbg_obj:maxcol,.f.)
        setcolor(set("debug_colors_menu"))
        //clear screen
        obj:menu:select(0)
        obj:menu:display()
        obj:menu:select(1)

return obj
************************************************
static function menu_activate(nMenu)
	local ret,st,y,curr,curWin:=wselect()
        curr:=iif(nMenu==NIL,::menu:current,nMenu)
	dispbegin()
	st:=::dbg:statusLine([Call menu])
	setcolor(set("debug_colors_menu"))
	wopen(0,0,::dbg:maxrow,::dbg:maxcol,.f.)
	setcolor(set("debug_colors_menu"))
        while dispcount()>0
           dispend()
        enddo
        //__keyboard(13)
	ret := MenuModal(::menu,curr,maxrow(),0,maxcol(),set("debug_colors_menu"))
	dispbegin()
	wclose()
	wselect(::winno)
	y=::menu:current
	::menu:Select(0)
	::menu:Display()
	::menu:Select(y)
	wselect(curWin)
	::dbg:statusLine(st)
	dispend()
return ret
************************************************
static function menu_numeration(new_val)
	local ret:=::number_item:checked
        if new_val != NIL
		::number_item:checked := new_val
		::dbg:setNumStyle(new_val)
        endif
return ret
************************************************
static function menu_cbTraceStyle(new_val)
	local ret:=::cbTrace_item:checked
        if new_val != NIL
		::cbTrace_item:checked := new_val
		::dbg:setCbTrace(new_val)
        endif
return ret
************************************************
static function menu_preprocStyle(new_val)
	local ret:=::preproc_item:checked
        if new_val != NIL
		::preproc_item:checked := new_val
		//::dbg:preprocStyle(new_val)
                //message("Sorry ! Not supported")
        endif
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
        if hkey==HASH_StrNumber
        	::numeration( ! ::numeration() )
                hkey:=0
        endif
        if hkey==HASH_TraceCB
        	::cbTraceStyle( ! ::cbTraceStyle() )
                hkey:=0
        endif
        if hkey==HASH_Preproc
        	::preprocStyle( ! ::preprocStyle() )
                hkey:=0
        endif
return hkey

************************************************
static function menu_create()
   local oTopBar, oPopUp, oPopUp1, oItem
   local mapkeys:=HK_get("debug"),kn

      oTopBar := TopBar( 0, 0, maxcol())
      oTopBar:ColorSpec := set("debug_colors_menu")

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("debug_colors_menu")
      oTopBar:AddItem( MenuItem ( [&File],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,HASH_OpenFile))
      oItem :=MenuItem( [&Open         ]+kn ,{|| .t. }, ,[Open source file to text editor], HASH_OpenFile)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys, HASH_Reload))
      oItem :=MenuItem( [&Reload files ]+kn ,{|| .t. }, ,[Reload a file], HASH_Reload)
      oPopUp:AddItem( oItem)

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_Exit))
      oItem :=MenuItem( [E&xit         ]+kn ,{|| .t. }, ,[Exit to OS], HASH_Exit)
      oPopUp:AddItem( oItem)
**************************************************************************
      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("debug_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Service],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_FindStr))
      oItem :=MenuItem( [&Find           ]+kn ,{|| .t. },,[Find string ], HASH_FindStr)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_FindNext))
      oItem :=MenuItem( [Find &next      ]+kn ,{|| .t. },,[Find next string ], HASH_FindNext)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_FindPrev))
      oItem :=MenuItem( [Find &prev      ]+kn ,{|| .t. },,[Find prev string ], HASH_FindPrev)
      oPopUp:AddItem( oItem)
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_GotoLine))
      oItem :=MenuItem( [&Goto line      ]+kn ,{|| .t. },,[Goto string number], HASH_GotoLine)
      oPopUp:AddItem( oItem)
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_MatchForward))
      oItem :=MenuItem( [Match &forward  ]+kn ,{|| .t. },,[Math identity symbol in forward ], HASH_MatchForward)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_MatchBackWard))
      oItem :=MenuItem( [Match &backward ]+kn ,{|| .t. },,[Math identity symbol in backward ], HASH_MatchBackWard)
      oPopUp:AddItem( oItem)
**************************************************************************
      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("debug_colors_menu")
      oTopBar:AddItem( MenuItem ( [&View],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewSet))
      oItem :=MenuItem( [&Set values     ]+kn ,{|| .t. },,[View set(....) values ], HASH_ViewSet)
      oPopUp:AddItem( oItem)
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewAliases))
      oItem :=MenuItem( [&Work aliases   ]+kn ,{|| .t. },,[View aliases], HASH_ViewAliases)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewScreen))
      oItem :=MenuItem( [work &Screen    ]+kn ,{|| .t. },,[View screen of program], HASH_ViewScreen)
      oPopUp:AddItem( oItem)
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewStack))
      oItem :=MenuItem( [&Call stack    ]+kn ,{|| .t. },,[View program call stack], HASH_ViewStack)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_ViewBreak))
      oItem :=MenuItem( [&Break points   ]+kn ,{|| .t. },,[View program break points], HASH_ViewBreak)
      oPopUp:AddItem( oItem)
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_Monitor))
      oItem :=MenuItem( [&Monitor        ]+kn ,{|| .t. },,[View public,private,local,static variables], HASH_Monitor)
      oPopUp:AddItem( oItem)
**************************************************************************
      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("debug_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Run],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_ConnectProcess))
      oItem :=MenuItem( [&Connect process]+kn ,{|| .t. },,[Connect to external process], HASH_ConnectProcess)
      oPopUp:AddItem( oItem)
      /*
      kn:=key_name(HK_get_key(mapkeys,  HASH_ConnectTask))
      oItem :=MenuItem( [&Connect task ]+kn ,{|| .t. },,[Connect to internal task], HASH_ConnectTask)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_LoadPO))
      oItem :=MenuItem( [&Load PO-file    ]+kn ,{|| .t. },,[Load po-file for debugging], HASH_LoadPO)
      oPopUp:AddItem( oItem)
      */
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_Step))
      oItem :=MenuItem( [&Step            ]+kn ,{|| .t. },,[Step program], HASH_Step)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_GoCursor))
      oItem :=MenuItem( [&Go cursor       ]+kn ,{|| .t. },,[Run progran and stop for cursor], HASH_GoCursor)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_Trace))
      oItem :=MenuItem( [&Trace           ]+kn ,{|| .t. },,[Run progran as trace], HASH_Trace)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_Continue))
      oItem :=MenuItem( [&Run, no wait    ]+kn ,{|| .t. },,[Run progran, no wait], HASH_Continue)
      oPopUp:AddItem( oItem)
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_AnimationSpeed))
      oItem :=MenuItem( [Animation speed  ]+kn ,{|| .t. },,[Set speed for animation mode], HASH_AnimationSpeed)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_Animation))
      oItem :=MenuItem( [&Animation       ]+kn ,{|| .t. },,[View aliases], HASH_Animation)
      oPopUp:AddItem( oItem)
**************************************************************************
      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("debug_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Points],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_Values))
      oItem :=MenuItem( [&Values     ]+kn ,{|| .t. },,[Add values to view window], HASH_Values)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_TracePoint))
      oItem :=MenuItem( [&Trace      ]+kn ,{|| .t. },,[Add trace variable], HASH_TracePoint)
      oPopUp:AddItem( oItem)
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_Break))
      oItem :=MenuItem( [&Stop       ]+kn ,{|| .t. },,[Stop point program], HASH_Break)
      oPopUp:AddItem( oItem)
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_DeletePoint))
      oItem :=MenuItem( [&Delete     ]+kn ,{|| .t. },,[Delete point from view window], HASH_DeletePoint)
      oPopUp:AddItem( oItem)
**************************************************************************
/*
      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("debug_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Monitor],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_Monitor1))
      oItem :=MenuItem( [&Public     ]+kn ,{|| .t. },,[View public variables], HASH_Monitor1)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_Monitor2))
      oItem :=MenuItem( [p&Rivate    ]+kn ,{|| .t. },,[View private variables], HASH_Monitor2)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_Monitor3))
      oItem :=MenuItem( [&Static     ]+kn ,{|| .t. },,[View static variables], HASH_Monitor3)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_Monitor4))
      oItem :=MenuItem( [&Local      ]+kn ,{|| .t. },,[View local variables], HASH_Monitor4)
      oPopUp:AddItem( oItem)
      /*
      kn:=key_name(HK_get_key(mapkeys,  HASH_Monitor5))
      oItem :=MenuItem( [&Field      ]+kn ,{|| .t. },,[View field variables], HASH_Monitor5)
      oPopUp:AddItem( oItem)
      */
*/
**************************************************************************
      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("debug_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Options],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_Preproc))
      oItem :=MenuItem( [&Proprocesor text  ]+kn ,{|| .t. },,[Say prerocessor text in source window], HASH_Preproc)
      oItem:Checked := .f.
      oPopUp:AddItem( oItem)
      ::preproc_item:=oItem
      kn:=key_name(HK_get_key(mapkeys,  HASH_StrNumber))
      oItem :=MenuItem( [&Number of strings ]+kn ,{|| .t. },,[Say number source strings], HASH_StrNumber)
      oItem:Checked := .t.
      oPopUp:AddItem( oItem)
      ::number_item:=oItem
      kn:=key_name(HK_get_key(mapkeys,  HASH_TraceCB))
      oItem :=MenuItem( [&Code blocks trace ]+kn ,{|| .t. },,[Trace code blocks source], HASH_TraceCB)
      oItem:Checked := .t.
      oPopUp:AddItem( oItem)
      ::cbTrace_item:=oItem
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_TabSize))
      oItem :=MenuItem( [&Tab size         ]+kn ,{|| .t. },,[Set tab size for view source], HASH_TabSize)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_SourcePath))
      oItem :=MenuItem( [source &Path      ]+kn ,{|| .t. },,[Set path for search source files], HASH_SourcePath)
      oPopUp:AddItem( oItem)
      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      kn:=key_name(HK_get_key(mapkeys,  HASH_SaveOptions))
      oItem :=MenuItem( [&Save options     ]+kn ,{|| .t. },,[Save current options], HASH_SaveOptions)
      oPopUp:AddItem( oItem)
      kn:=key_name(HK_get_key(mapkeys,  HASH_LoadOptions))
      oItem :=MenuItem( [&Load Options     ]+kn ,{|| .t. },,[Load saved options], HASH_LoadOptions)
      oPopUp:AddItem( oItem)
**************************************************************************
      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("debug_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Window],oPopUp) )

      kn:=key_name(HK_get_key(mapkeys,  HASH_ListWindow))
      oItem :=MenuItem( [&List      ]+kn ,{|| .t. }, ,[List of windows], HASH_ListWindow)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_NextWindow))
      oItem :=MenuItem( [&Next      ]+kn ,{|| .t. }, ,[Select next window], HASH_NextWindow)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_PrevWindow))
      oItem :=MenuItem( [&Prev      ]+kn ,{|| .t. }, ,[Select prevoice window], HASH_PrevWindow)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_ZoomWindow))
      oItem :=MenuItem( [&Zoom      ]+kn ,{|| .t. }, ,[Switch window size], HASH_ZoomWindow)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(mapkeys,  HASH_CloseWindow))
      oItem :=MenuItem( [&Close     ]+kn ,{|| .t. }, ,[Close current window], HASH_CloseWindow)
      oPopUp:AddItem( oItem)

      oTopBar:current:=1

return ( oTopBar)

