/*
    Copyright (C) 2001-2005  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "inkey.ch"

init procedure ab_init
	local k

	//set("ab_colors","1/2,0/2,r/7,g/rb,15/7,0/7")
	set("ab_colors","w+/b,0/b,r/7,g/rb,15/7,0/7")
	set("ab_colors_menu","b/w,gr+/rb,r/w,g/rb,n+/w,w+/b")
	set("ab_colors_browse","N/W, N/BG, B/W, B/BG, B/W, B/BG, R/W, B/R")
	set("ab_colors_dialog","w+/bg,1/3,14/3,15/3,0/3,0/7")

	/* hot keys default */
	k:=hk_get("ab")
	if !empty(k)
		return
	endif

	k:=map()

	k[ K_ESC ]	:=HASH_CallMenu
	k[ K_F1 ] 	:=HASH_Help
	k[ K_F2 ] 	:=HASH_Append
	k[ K_F3 ] 	:=HASH_ViewCard
	k[ K_F4 ] 	:=HASH_Edit
	k[ K_F8 ] 	:=HASH_Delete
	k[ K_ALT_F8 ]	:=HASH_DeleteAll
	k[ K_ALT_U ] 	:=HASH_UnDelete
	k[ K_CTRL_U ] 	:=HASH_UnDeleteAll
	k[ K_F9 ]	:=HASH_Erase
	k[ K_ALT_F9 ] 	:=HASH_EraseAll
	//k[ K_F10] 	:=HASH_CloseWin
	k[ K_ALT_X ]	:=HASH_Exit
	//k[ K_F3 ] 	:=HASH_OpenDict
	//k[ K_ALT_F3 ] 	:=HASH_OpenDep
	//k[0]		:=HASH_ViewAttrs
	//k[0]		:=HASH_ViewExtents
	//k[0]		:=HASH_ViewClasses
	//k[0]		:=HASH_ViewCounters
	//k[0]		:=HASH_ViewUsers
	//k[0]		:=HASH_ViewGroups
	/*
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
	*/

	do case
		case "ru" $ lower( getenv("LANG") )
			k[ K_ALT_O ]	:=HASH_MenuItem1
			k[ K_ALT_C ]	:=HASH_MenuItem2
			k[ K_ALT_T ]	:=HASH_MenuItem3
			k[ K_ALT_G ]	:=HASH_MenuItem4
			k[ K_ALT_N ]	:=HASH_MenuItem5
			k[ K_ALT_V ]	:=HASH_MenuItem6
			k[ K_ALT_H ]	:=HASH_MenuItem7
			k[ K_ALT_J ]	:=HASH_MenuItem8
		otherwise
			k[ K_ALT_O ]	:=HASH_MenuItem1
			k[ K_ALT_S ]	:=HASH_MenuItem2
			k[ K_ALT_V ]	:=HASH_MenuItem3
			k[ K_ALT_R ]	:=HASH_MenuItem4
			k[ K_ALT_P ]	:=HASH_MenuItem5
			k[ K_ALT_M ]	:=HASH_MenuItem6
			k[ K_ALT_O ]	:=HASH_MenuItem7
			k[ K_ALT_W ]	:=HASH_MenuItem8
	endcase

	hk_add("ab",k)

return
