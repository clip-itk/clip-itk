/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "inkey.ch"

static key_maps

/********************************************
* func HK_load()
* читает переназначение клавиш для пользовательских программ
* типа "редактор", "отладчик", .........
* из файла keymaps, который может лежать в:
* 1. в /usr/local/lib/clip/
* 2. по пути, указанному в setenv("RTCLIP_PATH")
* 3. в $HOME/.clip
*/
function HK_load()
local nfile
	nfile := getenv("HOME")+"/.clip/keymaps.po"
	if file(nfile)
		load(nfile)
		if isFunction("init_user_key")
			key_maps := clip("init_user_key",key_maps)
//			key_maps := eval(init_user_key, key_maps)
		endif
	endif
return


***********************************************
function HK_init
	local k
	key_maps:=map()

	/* for debug */
	key_maps:debug:=map()
	k:=key_maps:debug

	#include "debug.ch"
	k[ K_ESC ]	:=HASH_CallMenu
	k[ K_F1 ] 	:=HASH_Help
	k[ K_F2 ]	:=HASH_ZoomWindow

	k[ K_F3 ] 	:=HASH_OpenFile
	k[ K_ALT_R ]	:=HASH_Reload
	k[ K_ALT_X ]	:=HASH_Exit
	k[ K_CTRL_U ]	:=HASH_SwitchPanel

	k[ K_CTRL_Q ]	:=HASH_FindStr
	k[ K_CTRL_L ]	:=HASH_FindNext
	k[ K_CTRL_P ]	:=HASH_FindPrev
	k[ K_CTRL_G ]	:=HASH_GotoLine
	//k[0]		:=HASH_MatchForward
	//k[0]		:=HASH_MatchBackWard
	//k[0]		:=HASH_Options
	k[ K_ALT_0 ]	:=HASH_ListWindow
	k[ K_ALT_1 ]	:=HASH_Window1
	k[ K_ALT_2 ]	:=HASH_Window2
	k[ K_ALT_3 ]	:=HASH_Window3
	k[ K_ALT_4 ]	:=HASH_Window4
	k[ K_ALT_5 ]	:=HASH_Window5
	k[ K_ALT_6 ]	:=HASH_Window6
	k[ K_ALT_7 ]	:=HASH_Window7
	k[ K_ALT_8 ]	:=HASH_Window8
	k[ K_ALT_9 ]	:=HASH_Window9
	k[ K_ALT_C ]	:=HASH_CloseWindow
	k[ K_TAB ]	:=HASH_NextWindow
	k[ K_SH_TAB ]	:=HASH_PrevWindow

	do case
		case "ru" $ lower( getenv("LANG") ) .or. "ru" $ lower( getenv("CLIP_LANG") )
			k[ K_ALT_A ]	:=HASH_MenuItem1
			k[ K_ALT_C ]	:=HASH_MenuItem2
			k[ K_ALT_T ]	:=HASH_MenuItem3
			k[ K_ALT_G ]	:=HASH_MenuItem4
			k[ K_ALT_N ]	:=HASH_MenuItem5
			k[ K_ALT_V ]	:=HASH_MenuItem6
			k[ K_ALT_H ]	:=HASH_MenuItem7
			k[ K_ALT_J ]	:=HASH_MenuItem8
		otherwise
			k[ K_ALT_F ]	:=HASH_MenuItem1
			k[ K_ALT_S ]	:=HASH_MenuItem2
			k[ K_ALT_V ]	:=HASH_MenuItem3
			k[ K_ALT_R ]	:=HASH_MenuItem4
			k[ K_ALT_P ]	:=HASH_MenuItem5
			k[ K_ALT_M ]	:=HASH_MenuItem6
			k[ K_ALT_O ]	:=HASH_MenuItem7
			k[ K_ALT_W ]	:=HASH_MenuItem8
	endcase
	//k[0]		:=HASH_ViewSet
	//k[0]		:=HASH_ViewStack
	k[ K_F4 ]	:=HASH_ViewScreen
	k[ K_F6 ]	:=HASH_ViewAliases
	//k[0]		:=HASH_AnimationSpeed
	//k[0]		:=HASH_Animation
	//k[0]		:=HASH_LoadPO
	//k[0]		:=HASH_ConnectTask
	//k[0]		:=HASH_ConnectProcess
	k[ K_F8 ]	:=HASH_Step
	k[ K_F7 ]	:=HASH_GoCursor
	k[ K_F10 ]	:=HASH_Trace
	k[ K_F5 ]	:=HASH_Continue

	//k[0]		:=HASH_Values
	//k[0]		:=HASH_TracePoint
	k[ K_F9 ]	:=HASH_Break
	k[ K_CTRL_Y]  	:=HASH_DeletePoint
	k[ K_ALT_M]	:=HASH_Monitor
	//k[0]		:=HASH_Monitor
	//k[0]		:=HASH_Preproc
	//k[0]		:=HASH_StrNumber
	//k[0]		:=HASH_TraceCB
	//k[0]		:=HASH_TabSize
	//k[0]		:=HASH_SourcePath
	//k[0]		:=HASH_SaveOptions
	//k[0]		:=HASH_LoadOptions


	/* for text editor */
	key_maps:edit:=map()
	k:=key_maps:edit

	/* Код клавиши 	  Команда */
	k[ K_ESC ]	:=HASH_CallMenu		// call Menu
	k[ K_ALT_X ]	:=HASH_ExitSave		// exit from editor witch save
	k[ K_ALT_B ]	:=HASH_ExitNoSave	// exit from editor witchout save
	k[ K_F1 ]	:=HASH_HelpEdit		// help

	/* file/window function */
	k[ K_F2 ]	:=HASH_SaveFile		// save File
	k[ K_F3 ]	:=HASH_OpenFile		// open file
	k[ K_CTRL_F3 ]	:=HASH_CreateNewFile	// create new file
	k[ K_ALT_N ]	:=HASH_NextWindow	// open next window
	k[ K_ALT_P ]  	:=HASH_PrevWindow	// open previous window

	/* find function */
	k[ K_F6 ]	:=HASH_FindString	// find string
	k[ K_CTRL_F6]	:=HASH_FindReplace	// find and replace string
	k[ K_CTRL_L ]	:=HASH_FindNext		// find string to forward
	k[ K_CTRL_O ]	:=HASH_MatchSymbolForward // matching symbol to forward
	k[ K_CTRL_T ]	:=HASH_MatchSymbolBackward // matching symbol to backward

	/* move function */
	k[ K_F4 ]	:=HASH_GoTo		// goto string
	k[ K_CTRL_F4 ]	:=HASH_SavePos		// save current string
	k[ K_CTRL_PGUP ]:=HASH_TopText		// go top text
	k[ K_CTRL_PGDN ]:=HASH_BottomText	// go bottom text

	/* edit function */
	k[ K_F5 ]	:=HASH_Template		// insert template
	k[ K_CTRL_F5 ]	:=HASH_Macro		// insert macro
	k[ K_CTRL_Q ]	:=HASH_DeleteEnd	// delete string from current position to end
	k[ K_CTRL_BS ]	:=HASH_DeleteBack	// delete string from current position to begin string
	k[ K_CTRL_Y ]	:=HASH_DeleteLine	// delete line

	/* block function */
	k[ K_F7 ]	:=HASH_MarkBlockString	// mark/unmark strings block
	k[ K_F8 ]	:=HASH_MarkBlockRect	// mark/unmark rectangle block
	k[ K_F9 ]	:=HASH_CopyBlock	// copy marked block
	k[ K_F10 ]	:=HASH_MoveBlock	// move marked block
	k[ K_CTRL_P ]	:=HASH_CancelBlock	//unmark block
	k[ K_ALT_Y ]	:=HASH_DeleteBlock	// delete marked block


	k[ K_CTRL_U ]	:=HASH_Undo		// undo operation

	/* for dialog box */
	key_maps:dialog:=map()
	k:=key_maps:dialog

	/* Код клавиши 	  Команда */
	k[ K_ESC ]	:=HASH_CallMenu		// call Menu
	k[ K_ALT_X ]	:=HASH_Exit		// exit from dialog box
	k[ K_F6 ]	:=HASH_Find		// find string
	k[ K_CTRL_L ]	:=HASH_ResumeFind	// resume find
	k[ K_CTRL_P ]	:=HASH_UnmarkBlock	// unmark block

	/* for my commander */
	key_maps:commander:=map()
	k:=key_maps:commander

	/* Код клавиши 	  Команда */
	k[ K_F9 ]	:=HASH_CallMenu		// call Menu
	k[ K_ESC ]	:=HASH_CallMenu		// call Menu

	k[ K_F1 ]	:=HASH_Help		// help
	k[ K_F5 ]	:=HASH_Copy		// copy
	k[ K_F6 ]	:=HASH_Move		// move
	k[ K_F10 ]  	:=HASH_Quit		// quit
	k[ K_CTRL_L ]  	:=HASH_Info		// info panel
	k[ K_CTRL_J ]  	:=HASH_GetItem		// get item
	k[ K_CTRL_ENTER]:=HASH_GetItem		// get item

	/* for html browser */
	key_maps:htmlBrowser:=map()
	k:=key_maps:htmlBrowser

	/* Код клавиши 	  Команда */
	k[ K_F9 ]	:=HASH_CallMenu		// call Menu
	k[ K_F2 ]	:=HASH_CallMenu		// call Menu
	k[ K_ESC ]	:=HASH_Exit		// call Menu

	k[ K_F1 ]	:=HASH_Help		// help
	k[ K_F6 ]	:=HASH_Find		// find
	k[ K_F10 ]  	:=HASH_Exit		// exit
	k[ K_CTRL_L ]  	:=HASH_ResumeFind	// resume find
	k[ K_CTRL_P ]	:=HASH_UnmarkBlock	// unmark block
	k[ K_TAB ]	:=HASH_NextItem		// next item
	k[ K_SH_TAB ]	:=HASH_PrevItem		// previous item

	k[ asc('N') ]	:=HASH_NextUrl		// next site from history
	k[ asc('n') ]	:=HASH_NextUrl		// next site from history
	k[ asc('P') ]	:=HASH_PrevUrl		// previous site from history
	k[ asc('p') ]	:=HASH_PrevUrl		// previous site from history
//	k[ K_BS ]	:=HASH_PrevUrl		// previous site from history
	k[ asc('-') ]	:=HASH_PrevUrl		// previous site from history
	k[ asc('I') ]	:=HASH_InfoUrl		// information about Url
	k[ asc('i') ]	:=HASH_InfoUrl		// information about Url
	k[ asc('S') ]	:=HASH_SourceUrl	// view source Url
	k[ asc('s') ]	:=HASH_SourceUrl	// view source Url
	k[ asc('/') ]	:=HASH_InfoUrl		// information about Url

return
***********************************************
function HK_get(name)

   name=upper(name)

   if name $ key_maps
      name=hashstr(name)
      return key_maps[name]
   endif

return map()
***********************************************
function HK_add(name,data)

   name=upper(name)
   name=hashstr(name)
   key_maps[name] := data

return map()

***********************************************
* по массиву назначенных клавиш и хеш-коду
* возвращает активную клавишу
***********************************************
function HK_get_key(keymap,hashKey)
   local ret:=0,i,m
   m=mapkeys(keymap)
   for i=1 to len(m)
	if keymap[m[i]]==hashKey
	   ret=m[i]
	   exit
	endif
   next
return ret

