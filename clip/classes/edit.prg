/*   MEDIT class                                                */
/*                                                              */
/*   Copyright (C) 2001 - 2004  IT                              */
/*   Author  : Elena Kornilova (alena@itk.ru)                   */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html     */

#include "config.ch"
#include "set.ch"
#include "button.ch"   // Menu definitions
#include "inkey.ch"    // Key definitions
#include "edit.ch"
#include "box.ch"
#include <clipcfg.h>
#include <setcurs.ch>

#define FA_NORMAL       0
#define FA_READONLY     1
#define FA_HIDDEN       2
#define FA_SYSTEM       4
#define FA_VOLUME       8
#define FA_DIRECTORY    16
#define FA_ARCHIVE      32

#define ME_VERSION      5

static __CurrentDir

function medit(par, ntop, nleft, nbot, nright, user_func,;
		  tab_size, bline, bpos, wline, wpos)
local obj:=_medit(par, ntop, nleft, nbot, nright, user_func,;
			  tab_size, bline, bpos, wline, wpos)
	obj:runme()

return
******************
function medit_new(par, ntop, nleft, nbot, nright, user_func,;
		  tab_size, bline, bpos, wline, wpos)
local obj:=_medit(par, ntop, nleft, nbot, nright, user_func,;
			  tab_size, bline, bpos, wline, wpos)

return obj
******************
function _medit(par, ntop, nleft, nbot, nright, user_func,;
		  tab_size, bline, bpos, wline, wpos)
local obj:=map()
	obj:className   := "MEDIT"
	obj:tobj        := {}
	obj:tobjinfo    := {}
	obj:curwin      := 0
	obj:nWins       := 0
	obj:__l_tobj    := .f.
	obj:Clipboard   := {}
	//obj:SB                := 0
	obj:Find        := 0
	obj:__FileD     := 0
	obj:Opt         := 0
	obj:__Hist      := 0
	obj:templ       := map()
	obj:tempmacro   := map()
	obj:__dirEdit   := ""
	obj:__fileOpt   := ""
	obj:__fileStatus:= ""
	obj:__fileTempl := ""
	obj:__fileMacro := ""
	obj:userfunc    := user_func
	obj:ntop        := iif(ntop==NIL,0,ntop)
	obj:nbot        := iif(nbot==NIL,maxrow(),nbot)
	obj:nright      := iif(nright==NIL,maxcol(),nright)
	obj:nleft       := iif(nleft==NIL,0,nleft)
	obj:param       := iif(par==NIL .or. valtype(par)!="A", {}, par)
	obj:tab_size    := iif(tab_size==NIL, TE_TABSIZE, tab_size)
	obj:bline       := iif(bline==NIL,1,bline)
	obj:bpos        := iif(bpos==NIL,1,bpos)
	obj:wline       := iif(wline==NIL,1,wline)
	obj:wpos        := iif(wpos==NIL,1,wpos)
	obj:__mapKeys   := -1
	obj:single_mode := .f.
	obj:double_mode := .f.
	obj:stline      := [ESC -menu]
	obj:oMenu       := NIL
	obj:autoIndent  := .t.

	obj:__iniMacro  := NIL
	obj:__macroKeys := map()
	obj:__macroCmd  := map()
	obj:__hashKeys  := map()

	obj:__initMe    := @me_initme()
	obj:drawhead    := @me_drawhead()
	obj:getstatus   := @me_getstatus()
	obj:set_options := @me_set_options()
	obj:runme       := @me_runme()
	obj:saveFile    := @me_saveFile()
	obj:save_options:= @me_save_options()
	obj:writestatus := @me_writestatus()
	obj:listfiles   := @me_listfiles()
	obj:editopt     := @me_editopt()
	obj:goto        := @me_goto()
	obj:menu        := @me_menu_create()
	obj:enableMenu  := @me_enableMenu()
	obj:enableBlockMenu     := @me_enableBlockMenu()
	obj:__check_share       := @me___check_share()
	obj:helpEdit    := @me_helpEdit()
	obj:about       := @me_about()
	obj:setReadOnly := @me_setReadOnly()
	obj:getReadOnly := @me_getReadOnly()
	obj:chooseCodePage := @me_chooseCodePage()
	obj:changeCharset:= @me_changeCharset()
	obj:removeWindow := @me_removeWindow()
	obj:__setMacros := @me___setMacros()
	obj:__addMacroToMenu    := @me___addMacroToMenu()
	obj:initUserMacro:= @me__initUserMacro()

	obj:__setDefaultHash    := @me___setDefaultHash()
	obj:applyHash           := @me_applyHash()
	obj:setHash             := @me_setHash()
	obj:__checkWindow       := @me___checkWindow()
	obj:__setFocus          := @me___setFocus()

	obj:getFocus            := @me_getFocus()
	obj:saveWins            := @me_saveWins()
	obj:createNewWindow     := @me_createNewWindow()
	obj:openFile            := @me_openFile()
	obj:findString          := @me_findString()
	obj:findReplace         := @me_findReplace()
	obj:findPrev            := @me_findPrev()
	obj:findNext            := @me_findNext()
	obj:reloadFile          := @me_reloadFile()
	obj:prevWindow          := @me_prevWindow()
	obj:nextWindow          := @me_nextWindow()
	obj:setInsertMode       := @me_setInsertMode()
	obj:matchSymbol         := @me_matchSymbol()
	obj:matchStructure      := @me_matchStructure()
	obj:copyToClipboard     := @me_copyToClipboard()
	obj:saveBlock           := @me_saveBlock()
	obj:showFiles           := @me_showFiles()
	obj:closeWindow         := @me_closeWindow()
	obj:markBlock           := @me_markBlock()
	obj:cancelBlock         := @me_cancelBlock()
	obj:print               := @me_print()
	obj:undo                := @me_undo()
	obj:savePos             := @me_savePos()
	obj:callMenu            := @me_callMenu()
	obj:newLine             := @me_NewLine()
	obj:delete              := @me_delete()
	obj:deleteEnd           := @me_deleteEnd()
	obj:backspace           := @me_backspace()
	obj:deleteHome          := @me_deleteHome()
	obj:deleteLine          := @me_deleteLine()
	obj:centerLine          := @me_centerLine()
	obj:copyBlock           := @me_copyBlock()
	obj:deleteBlock         := @me_deleteBlock()
	obj:pasteFromClipboard  := @me_pasteFromClipboard()
	obj:loadBlock           := @me_loadBlock()
	obj:insTemplate         := @me_insTemplate()
	obj:insMacro            := @me_insMacro()
	obj:format              := @me_format()
	obj:setDraw             := @me_setDraw()

	obj:__initMe()
	//obj:runme()
return obj

********************
static function me_initme()
local nfile, str, spl, i, fd, curwin, oldwin, home, percent, nWin
	::ntop := min(max(0,::ntop),maxrow())
	::nbot := min(max(0,::nbot),maxrow())
	::nleft := min(max(0,::nleft),maxcol())
	::nright := min(max(0,::nright),maxcol())

	::__mapKeys     := HK_get("edit")

	set("edit_margin_right","50") // длина строки
	set("edit_page_len","20")     // длина страницы
	set("edit_txtdir", curdir())   // где храняться документы
	set("edit_colors_edit",'11/1,0/2,0/3,0/7,1/3, 15/R') // цвет редактирования
	set("edit_colors_window",'14/1') // цвет окна редактирования
	set("edit_colors_view",'0/7,7/1,0/3,,1/3')  // цвет просмотра
	set("edit_colors_menu","0/7,0/2,r/7,g/rb,15/7,0/7") // цвет меню
	set("edit_colors_list","0/3,0/2,15/7,15/3,14/3,14/2,0/2")   // цвет list объектов
	//set("edit_colors_dialog","0/7,0/2,w+/b,g/rb,15/7,0/7")   // цвет диалогов
	set("edit_colors_dialog","0/7,15/1,0/7,g/rb,15/3,0/7,0/7,15/7")   // цвет диалогов
	set("edit_tabpack",'yes')   // сжимать пробелы в табуляции
	set(_SET_SCOREBOARD,.t.)
	setcursor(1)
	//setcancel(.f.)
	::oMenu := ::menu()

	home := getenv("HOME")
	::__dirEdit := home+PATH_DELIM+".clip"
	::__fileOpt := home+PATH_DELIM+".clip"+PATH_DELIM+".edit"
	//::__fileStatus := "edit."+getenv("USER")
	::__fileStatus := home+PATH_DELIM+".clip"+PATH_DELIM+"we_status"+PATH_DELIM
	dirmake(::__fileStatus)
	::__fileStatus += strtran(currdrive()+"/"+curdir(), PATH_DELIM, ",")
	::__fileStatus += "."+getenv("USER")
	::__fileTempl := home+PATH_DELIM+".clip"+PATH_DELIM+".templ"
	::__fileMacro := home+PATH_DELIM+".clip"+PATH_DELIM+".macro"

	::set_options()

	::__FileD := historyObj(,,,,set("edit_colors_list"))
	::__FileD:setsize(::Opt:OHISTORY)
	::Find := findOptions(,,set("edit_colors_dialog"), set("edit_colors_list"), ;
		::Opt:FCASE, ::Opt:FWORDONLY, ::Opt:FREGEXP, ::Opt:FALLW, ::Opt:FDIRECT, ::Opt:FWHERE)
//      ::Find:sethistorysize(::Opt:OHISTORY)
	::__Hist := historyObj(,,,,set("edit_colors_list"))
	::__Hist:setsize(::Opt:OHISTORY)

	setcolor(set("edit_colors_window"))

	@ ::nTop, ::nLeft clear to ::nBot, ::nRight
	@ ::nBot, ::nLeft say padr(::stline, ::nRight-::nLeft+1) color "0/w"
	//::SB := scrollBar(::nTop, ::nBot, ::nRight, NIL)


	if !file(::__fileTempl)
		::__fileTempl := cliproot()+PATH_DELIM+"etc"+PATH_DELIM+".templ"
	endif
	if file(::__fileTempl)
		nfile := fopen(::__fileTempl)
		do while !fileeof(nfile)
			str := filegetstr(nfile, TE_MAX_LEN_STRING)
			spl := {}
			if search("[ &\t]+", str, spl)
				::templ[alltrim(upper(left(str, spl[1][1]-1)))] := substr(str, spl[1][2])
			endif
		enddo
		fclose(nfile)
	endif

	if !file(::__fileMacro)
		::__fileMacro := cliproot()+PATH_DELIM+"etc"+PATH_DELIM+".macro"
	endif
	if file(::__fileMacro)
		nfile := fopen(::__fileMacro)
		do while !fileeof(nfile)
			str := filegetstr(nfile, TE_MAX_LEN_STRING)
			spl := {}
			if search("[ &\t]+", str, spl)
				::tempmacro[alltrim(upper(substr(str, 1, spl[1][1]-1)))] := substr(str, spl[1][2])
			endif
		enddo
		fclose(nfile)
	endif

	__CurrentDir := currdrive()+PATH_DELIM+curdir()+PATH_DELIM

	dispbegin()
	if len(::param)>0
		::tobjinfo := {}
		for i:=1 to len(::param)
			fd := ::param[i]
			setcolor(set("edit_colors_window"))
			nWin := wopen(::ntop,::nleft,::nbot-1,::nright)
			wbox()
			aadd(::tobjinfo, map())
			::nWins ++
			::tobjinfo[nWin]:name := fd
			::tobjinfo[nWin]:readOnly := .f.
			::tobjinfo[nWin]:share := .f.
			::tobjinfo[nWin]:curwin := nWin

			aadd(::tobj, textEditNew(0, 0, maxrow(), maxcol(),set("edit_colors_edit")))
			::tobj[nWin]:modeFormat         := 2
			::tobj[nWin]:line               := iif(::bline!=NIL, ::bline, ::tobj[nWin]:line)
			::tobj[nWin]:pos                := iif(::bpos!=NIL,  ::bpos,  ::tobj[nWin]:pos)
			::tobj[nWin]:rowWin             := iif(::wline!=NIL, ::wline, ::tobj[nWin]:rowWin)
			::tobj[nWin]:colWin             := iif(::wpos!=NIL,  ::wpos,  ::tobj[nWin]:colWin)
			::tobj[nWin]:marginRight        := ::Opt:OMARGINRIGHT
			::tobj[nWin]:tabSize            := ::Opt:OTABSIZE
			::tobj[nWin]:maxStrings         := ::Opt:OMAXSTRINGS
			::tobj[nWin]:autoWrap           := ::Opt:OAUTOWRAP
			::tobj[nWin]:lEofString         := .t.
			if ::tobj[nWin]:loadFile(fd, .f.)
				::__l_tobj := .t.
				//::__setFocus(nWin)
				//::drawhead()
			else
				alert([Can't open file;]+fd, "OK")
				::nWins--
				asize(::tobj, ::nWins)
				asize(::tobjinfo, ::nWins)
				wclose()
			endif
		next
		oldwin := ::tobjinfo[1]:curwin
	else
		::getstatus()
		oldwin := ::curwin
		nWin := 0
		for i:=1 to ::nWins
			nWin ++
			fd := ::tobjinfo[i]:name
			setcolor(set("edit_colors_window"))
			::tobjinfo[nWin]:curwin := wopen(::ntop,::nleft,::nbot-1,::nright)
			wbox()
		     // ::drawhead()
			aadd(::tobj, textEditNew(0, 0, maxrow(), maxcol(),set("edit_colors_edit")))
			//::nWins ++
			::tobj[nWin]:modeFormat         := 2
			::tobj[nWin]:line               := iif(::bline!=NIL, ::bline, ::tobj[nWin]:line)
			::tobj[nWin]:pos                := iif(::bpos!=NIL,  ::bpos,  ::tobj[nWin]:pos)
			::tobj[nWin]:rowWin             := iif(::wline!=NIL, ::wline, ::tobj[nWin]:rowWin)
			::tobj[nWin]:colWin             := iif(::wpos!=NIL,  ::wpos,  ::tobj[nWin]:colWin)
			::tobj[nWin]:marginRight        := ::Opt:OMARGINRIGHT
			::tobj[nWin]:tabSize            := ::Opt:OTABSIZE
			::tobj[nWin]:maxStrings         := ::Opt:OMAXSTRINGS
			::tobj[nWin]:autoWrap           := ::Opt:OAUTOWRAP
			::tobj[nWin]:lEofString         := .t.
			if ::tobj[nWin]:loadFile(fd, .f.)
				::__l_tobj := .t.
				::tobj[nWin]:pos                := ::tobjinfo[i]:pos
				::tobj[nWin]:line               := ::tobjinfo[i]:line
				::tobj[nWin]:colWin             := ::tobjinfo[i]:colwin
				::tobj[nWin]:rowWin             := ::tobjinfo[i]:rowwin


				dispbegin()
				::tobj[nWin]:refresh()
				::drawhead()
				percent := int(::tobj[nWin]:line*100/::tobj[nWin]:lines)
				str:=padr("<"+alltrim(str(::tobj[nWin]:line))+"><"+alltrim(str(::tobj[nWin]:pos))+"><"+alltrim(str(percent))+"%>", ::tobj[nWin]:__leninfo, translate_charset( __CHARSET__,host_charset(), substr(B_SINGLE, 6, 1)))
				@ -1, 1 say str color set("edit_colors_window")
				devpos(::tobj[nWin]:nTop+::tobj[nWin]:rowWin-1,::tobj[nWin]:nLeft+::tobj[nWin]:colWin-1)
				setpos(::tobj[nWin]:rowwin-1, ::tobj[nWin]:colwin-1)
				dispend()
				//setpos(::tobj[nWin]:rowwin, ::tobj[nWin]:colwin)
			else
				alert([Can't open file;]+fd, "OK")
				adel(::tobj, nWin)
				adel(::tobjinfo, nWin)
				nWin --
				i --
				::nWins --
				asize(::tobj, len(::tobj)-1)
				asize(::tobjinfo, len(::tobjinfo)-1)
				wclose()
				if nWin > 0
					::curwin := nWin
					wselect(::tobjinfo[nWin]:curwin)
					::drawhead()
					devpos(::tobj[nWin]:nTop+::tobj[nWin]:rowWin-1,::tobj[nWin]:nLeft+::tobj[nWin]:colWin-1)
					setpos(::tobj[nWin]:rowwin-1, ::tobj[nWin]:colwin-1)
				endif
			endif
		next
	endif
	if valtype(::tobj) != "A"
		::tobj := {}
	endif
	if valtype(::tobjinfo) != "A"
		::tobjinfo := {}
	endif
	::nWins := len(::tobj)
	if ::nWins == 0
		::__l_tobj := .f.
		::curwin := 0
	else
		//::__setFocus(oldwin)
		::curwin := oldwin
	endif

	if ::curwin > 0 .and. ::curwin<=::nWins
		dispbegin()
		wselect(::tobjinfo[::curwin]:curwin)
		::__setFocus(::curwin)
		//::drawhead()
		percent := int(::tobj[nWin]:line*100/::tobj[nWin]:lines)
		str:=padr("<"+alltrim(str(::tobj[nWin]:line))+"><"+alltrim(str(::tobj[nWin]:pos))+"><"+alltrim(str(percent))+"%>", ::tobj[nWin]:__leninfo, translate_charset( __CHARSET__,host_charset(), substr(B_SINGLE, 6, 1)))
		@ -1, 1 say str color set("edit_colors_window")
		devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1,::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
		setpos(::tobj[::curwin]:rowwin-1, ::tobj[::curwin]:colwin-1)
		::tobj[::curwin]:refresh()
		dispend()
	else
		::curwin := 1
	endif
	dispend()
	::Find:sethistorysize(::Opt:OHISTORY)
	::__setDefaultHash()    // set default command by hash
	::initUserMacro()
	setCursor(SC_INSERT)

return
**************************
static function me___checkWindow(nWin)
	if nWin == NIL .or. valtype(nWin) != "N"
		nWin := ::curwin
	endif
	if !between(nWin, 1, ::nWins)
		nWin := ::curwin
	endif

return ::tobj[nWin]
**************************
static function me___setDefaultHash()
local m
	::__hashKeys := map()
	m := ::__hashKeys


       m[HASH_ExitSave]                 := {|oMe, hKey| iif(oMe:saveWins() , (oMe:save_options(), iif( oMe:Opt:OSAVESTATUS,  oMe:writeStatus(), .f.), ME_EXIT), ME_CONTINUE) }
       m[HASH_ExitNoSave]               := {|oMe, hKey| iif(oMe:saveWins(), (oMe:save_options(), ME_EXIT), ME_CONTINUE)}
       /* create new window */
	m[HASH_CreateNewFile]           := {|oMe, hKey| oMe:__l_tobj := oMe:createNewWindow(), ME_CONTINUE }
       /* open window */
	m[HASH_OpenFile]                := {|oMe, hKey| oMe:openFile(), ME_CONTINUE }
	m[HASH_HelpEdit]                := {|oMe, hKey| oMe:helpEdit(), ME_CONTINUE }
	m[HASH_About]                   := {|oMe, hKey| oMe:about(), ME_CONTINUE }
       /* save file */
	m[HASH_SaveFile]                := {|oMe, hKey| oMe:saveFile(), ME_CONTINUE }
       /* save file as... */
	m[HASH_SaveAsFile]              := {|oMe, hKey| oMe:saveFile(.t.), ME_CONTINUE }
       /* find word */
	m[HASH_FindString]              := {|oMe, hKey| oMe:findString(), ME_CONTINUE }
       /* find word and replace */
	m[HASH_FindReplace]             := {|oMe, hKey| iif(oMe:tobjinfo[oMe:curwin]:readOnly, oMe:findString(), oMe:findReplace()), ME_CONTINUE }
       /* find next template to backward */
	m[HASH_FindPrev]                := {|oMe, hKey| oMe:findPrev(), ME_CONTINUE }
       /* find next template to forward */
	m[HASH_FindNext]                := {|oMe, hKey| oMe:findNext(), ME_CONTINUE }
       /* reload file */
	m[HASH_Reload]                  := {|oMe, hKey| oMe:reloadFile(), ME_CONTINUE }
       /* next window */
	m[HASH_NextWindow]              := {|oMe, hKey| oMe:nextWindow(), ME_CONTINUE }
       /* prev window */
	m[HASH_PrevWindow]              := {|oMe, hKey| oMe:prevWindow(), ME_CONTINUE }
       /* on/off insert mode */
	m[K_INS]                        := {|oMe, hKey| oMe:setInsertMode(), ME_CONTINUE }
	m[HASH_InsMode]                 := {|oMe, hKey| oMe:setInsertMode(), ME_CONTINUE }
       /* match forward symbol */
	m[HASH_MatchSymbolForward]      := {|oMe, hKey| oMe:matchSymbol(), ME_CONTINUE }
       /* match backward symbol */
	m[HASH_MatchSymbolBackward]     := {|oMe, hKey| oMe:matchSymbol(,.f.), ME_CONTINUE }
       /* match forward structure */
	m[HASH_MatchStructForward]      := {|oMe, hKey| oMe:matchStructure(), ME_CONTINUE }
       /* match backward structure */
	m[HASH_MatchStructBackward]     := {|oMe, hKey| oMe:matchStructure(, .f. ), ME_CONTINUE }
       /* copy block to Clipboard */
	m[HASH_CopyClipboard]           := {|oMe, hKey| oMe:copyToClipboard(oMe:curwin), ME_CONTINUE }
       /* save block to file */
	m[HASH_SaveBlock]               := {|oMe, hKey| oMe:saveBlock(), ME_CONTINUE }
       /* read only options on/off */
	m[HASH_ReadOnly]                := {|oMe, hKey| oMe:setReadOnly(oMe:curwin, !oMe:getReadOnly(oMe:curwin)), ME_CONTINUE }
       /* list opening files */
	m[HASH_ListFiles]               := {|oMe, hKey| oMe:showFiles(), ME_CONTINUE }
       /* close current window */
	m[HASH_CloseWindow]             := {|oMe, hKey| oMe:closeWindow(), ME_CONTINUE }
       /* edit options */
	m[HASH_Options]                 := {|oMe, hKey| oMe:editopt(), ME_CONTINUE }
       /* change code page */
	m[HASH_ChooseCodePage]          := {|oMe, hKey| oMe:chooseCodePage(), ME_CONTINUE }
       /* goto line/pos */
	m[HASH_GoTo]                    := {|oMe, hKey| oMe:goto(), ME_CONTINUE }
       /* save current line */
	m[HASH_SavePos]                 := {|oMe, hKey| oMe:savePos(), ME_CONTINUE }
       /* mark string block */
	m[HASH_MarkBlockString]         := {|oMe, hKey| oMe:markBlock(,.t.), ME_CONTINUE }
       /* mark rectangle block */
	m[HASH_MarkBlockRect]           := {|oMe, hKey| oMe:markBlock(,.f.), ME_CONTINUE }
       /* cancel block */
	m[HASH_CancelBlock]             := {|oMe, hKey| oMe:cancelBlock(), ME_CONTINUE }
       /* print text */
	m[HASH_Print]                   := {|oMe, hKey| oMe:print(,.f.), ME_CONTINUE }
       /* print block */
	m[HASH_PrintBlock]              := {|oMe, hKey| oMe:print(,.t.), ME_CONTINUE }
       /* run undo */
	m[HASH_Undo]                    := {|oMe, hKey| oMe:undo(), ME_CONTINUE }

	m[K_ENTER]                      := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:newLine(), .f.), ME_CONTINUE }
       /* delete current symbol */
	m[K_DEL]                        := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:delete(), .f.), ME_CONTINUE }
       /* delete string from current pos to end */
	m[HASH_DeleteEnd]               := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:deleteEnd(), .f.), ME_CONTINUE }
       /* delete syblol brom left */
	m[K_BS]                         := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:backSpace(), .f.), ME_CONTINUE }
       /* delete string from current pos to begin */
	m[HASH_DeleteBack]              := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:deleteHome(), .f.), ME_CONTINUE }
       /* delete current line */
	m[HASH_DeleteLine]              := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:deleteLine(), .f.), ME_CONTINUE }
       /* move string to the center */
	m[HASH_MoveCenter]              := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:centerLine(), .f.), ME_CONTINUE }
       /* copy block */
	m[HASH_CopyBlock]               := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:copyBlock(), .f.), ME_CONTINUE }
       /* move block */
	m[HASH_MoveBlock]               := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:copyBlock(,.f.), .f.), ME_CONTINUE }
       /* remove block */
	m[HASH_DeleteBlock]             := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:deleteBlock(), .f.), ME_CONTINUE }
       /* paste block from Clipboard */
	m[HASH_PasteClipboard]          := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:pasteFromClipboard(), .f.), ME_CONTINUE }
       /* load block from file */
	m[HASH_LoadBlock]               := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:loadBlock(), .f.), ME_CONTINUE }
       /* insert template */
	m[HASH_Template]                := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:insTemplate(), .f.), ME_CONTINUE }
       /* insert macro */
	m[HASH_Macro]                   := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:insMacro(), .f.), ME_CONTINUE }
       /* format line */
	m[HASH_FormatLine]              := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:format(), .f.), ME_CONTINUE }
       /* format part */
	m[HASH_FormatPart]              := {|oMe, hKey| iif(!oMe:tobjinfo[oMe:curwin]:readOnly, oMe:format(,.f.), .f.), ME_CONTINUE }
       /* on/off single graphic mode */
	m[HASH_SingleGraphic]           := {|oMe, hKey| oMe:setDraw(,.t.), ME_CONTINUE }
       /* on/off double graphic mode */
	m[HASH_DoubleGraphic]           := {|oMe, hKey| oMe:setDraw(,.f.), ME_CONTINUE }

return .t.
**************************
static function me_applyHash(oMe, nHashCode)
local b, ret
	if !(nHashCode $ oMe:__hashKeys)
		ret := ME_EXCEPTION
		if oMe:tobj[oMe:curwin]:handleKey(nHashCode)
			ret := ME_CONTINUE
		endif
		return ret
	endif

	b := oMe:__hashKeys[nHashCode]
	ret :=  eval(b, oMe, nHashCode)
return ret
*************************************
static function me_setHash(hKey, vData)
local ret
	ret := vData
	if hKey $ ::__hashKeys
		ret := ::__hashKeys[hKey]
	endif
	::__hashKeys[hKey] := vData
	if vData == NIL
		adel(::__hashKeys, hKey)
	endif
return ret
**************************
static function me_runme()
local hKey, str, nchoice:=1, percent, mc, k

do while .t.
	hKey := inkey(0, INKEY_ALL)
	if hKey $ ::__macroKeys .and. ::__l_tobj
		mc := ::__macroKeys[hKey]
		if clip(mc:func, iif(mc:allWins, __SELF__, ::tobj[::curwin]))
			loop
		endif
	elseif hkey $ ::__mapKeys
		hkey := ::__mapKeys[hKey]
	endif


	if mLeftDown() .and. (mRow() == ::nBot .or. mRow() == ::nTop)
		hKey := ::CallMenu(@nChoice)

		if hKey == -1
			loop
		endif
	endif
	if !::__l_tobj .and. (hKey != HASH_CallMenu .and. ;
		hKey != HASH_OpenFile .and. ;
		hKey != HASH_CreateNewFile .and. ;
		hKey != HASH_ExitSave .and. ;
		hKey != HASH_ExitNoSave .and. ;
		hKey != HASH_HelpEdit)

		loop
	endif
	if ::__l_tobj .and. mLeftDown()
		if between(mRow(), ::nBot+1, ::nTop-1) .and. between(mCol(), ::nLeft+1, ::nRight-1)
			::tobj[::curwin]:mGoto(mRow(), mCol())
			loop
		endif
	endif
	/* run menu */
	if hKey == HASH_CallMenu
		hKey := ::CallMenu(@nChoice)

		if hKey == -1
			loop
		endif
	endif

	If hKey $ ::__macroCmd .and. !::__l_tobj
		loop
	elseif hKey $ ::__macroCmd .and. ::__l_tobj
		mc := ::__macroCmd[hKey]
		if clip(mc:func, iif(mc:allWins, __SELF__, ::tobj[::curwin]), @hKey)
			loop
		endif
	endif


	if (::single_mode .or. ::double_mode) .and. numAnd(kbdstat(), 0x3)>0 .and. ;
		!::tobjinfo[::curwin]:readOnly .and. ::tobj[::curwin]:draw(::single_mode, hKey)
		hKey := 0
		loop
	endif

	k := ::applyHash(hKey)
	if k == ME_EXIT
		exit
	//elseif k == ME_EXCEPTION  .and. ::tobj[::curwin]:handleKey(hKey)
		//loop
	elseif ((hKey>=32 .and. hKey<=256) .or. hKey==K_TAB) .and. !::tobjinfo[::curwin]:readOnly
	    if ( Set(_SET_INSERT) )
	       ::tobj[::curwin]:insert(chr(hKey))
	    else
	       ::tobj[::curwin]:overStrike(chr(hKey))
	    endif
	endif

	if ::nWins == 0
		::__l_tobj := .f.
	endif

	if ::curwin > 0 .and. ::__l_tobj
		dispbegin()
		percent := int(min(::tobj[::curwin]:line*100/::tobj[::curwin]:lines, 100))
		str:= replicate( translate_charset( __CHARSET__,host_charset(), substr(B_SINGLE, 6, 1)), ::tobj[::curwin]:__leninfo)
		@ -1, 1 say str color set("edit_colors_window")
		str:="<"+alltrim(str(::tobj[::curwin]:line))+"><"+alltrim(str(::tobj[::curwin]:pos))+"><"+alltrim(str(percent))+"%>"+iif(::tobj[::curwin]:updated, "*", "")
		@ -1, 1 say str color set("edit_colors_window")
		devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1,::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
		dispend()
	endif

enddo

return

************************************
static function me_saveWins()
local k, i, ret := .t.
	k := 0
	for i=1 to ::nWins
	if ::tobj[i] == NIL
		loop
	endif
	wselect(::tobjinfo[i]:curwin)
	if ::tobj[i]:updated
		k := alert([File;]+::tobjinfo[i]:name+[;not saved. Save it?],{[Yes],[No],[Cancel] })
		if k==1
			::saveFile(, i)
		elseif k==3 .or. k==0
			ret := .f.
			exit
		endif
		if empty(::tobjinfo[i]:name) .and. ::tobj[i]:updated
			::removeWindow(@i)
			if i == ::curwin
				::__setFocus(::curwin - 1)
			endif
		endif
	else
		if empty(::tobjinfo[i]:name)
			::removeWindow(@i)
			if i == ::curwin
				::__setFocus(::curwin - 1)
			endif
			::curwin --
		endif
	endif
	wclose()

next
::curwin := ::__setFocus(max(0, ::curwin))

return ret
************************************
static function me_createNewWindow()
local i, nWin

	setcolor(set("edit_colors_window"))
	i=wopen(::ntop, ::nleft, ::nbot-1, ::nright)
	wbox()

	aadd(::tobjinfo, map())
	::nWins++
	nWin := ::nWins
	::tobjinfo[nWin]:name := ""
	::tobjinfo[nWin]:readOnly := .f.
	::tobjinfo[nWin]:share := .f.
	::tobjinfo[nWin]:curwin := i //number Window
	::tobjinfo[nWin]:updated := .f.

	aadd(::tobj, textEditNew(0, 0, maxrow(), maxcol(),set("edit_colors_edit")))
	::tobj[nWin]:modeFormat             := 2
	::tobj[nWin]:line                   := iif(::bline!=NIL, ::bline, ::tobj[nWin]:line)
	::tobj[nWin]:pos                    := iif(::bpos!=NIL,  ::bpos,  ::tobj[nWin]:pos)
	::tobj[nWin]:rowWin                 := iif(::wline!=NIL, ::wline, ::tobj[nWin]:rowWin)
	::tobj[nWin]:colWin                 := iif(::wpos!=NIL,  ::wpos,  ::tobj[nWin]:colWin)
	::tobj[nWin]:marginRight            := ::Opt:OMARGINRIGHT
	::tobj[nWin]:tabSize                := ::Opt:OTABSIZE
	::tobj[nWin]:maxStrings             := ::Opt:OMAXSTRINGS
	::tobj[nWin]:autoWrap               := ::Opt:OAUTOWRAP
	::tobj[nWin]:lEofString             := .t.
	::tobj[nWin]:loadString("")
	::__setFocus(nWin)
return .t.
************************************
static function me_openFile()
local obj, nWin
local fd, sh, i, oldwin, shnum

	if  ::__l_tobj .and. (::Opt:OOPENFILES == 1)
		i := atr('.', ::tobj[::curwin]:fileName)
		sh := iif(i > 0, "*"+substr(::tobj[::curwin]:fileName, i), "*")
		fd = fileDialog(::tobj[::curwin]:path, sh, ::__FileD)
	else
		fd=filedialog(__CurrentDir, "*", ::__FileD)
	endif
	if !empty(fd)
		__CurrentDir := padr(fd, atr(PATH_DELIM, fd))
	endif
	sh := ::__check_share(fd, @shnum)
	if sh < 2
		return .f.
	endif
	if !empty(fd)
		setcolor(set("edit_colors_window"))
		oldwin := wselect()
		i := wopen(::ntop, ::nleft, ::nbot-1, ::nright)
		wbox()
		aadd(::tobjinfo, map())
		::nWins ++

		nWin := ::nWins
		::tobjinfo[nWin]:name := fd
		::tobjinfo[nWin]:readOnly := .f.
		::tobjinfo[nWin]:share := .f.
		::tobjinfo[nWin]:curwin := i //number Window

		aadd(::tobj, textEditNew(0, 0, maxrow(), maxcol(),set("edit_colors_edit")))
		obj := ::tobj[nWin]
		obj:modeFormat         := 2
		obj:line               := iif(::bline!=NIL, ::bline, obj:line)
		obj:pos                := iif(::bpos!=NIL,  ::bpos,  obj:pos)
		obj:rowWin             := iif(::wline!=NIL, ::wline, obj:rowWin)
		obj:colWin             := iif(::wpos!=NIL,  ::wpos,  obj:colWin)
		obj:marginRight        := ::Opt:OMARGINRIGHT
		obj:tabSize            := ::Opt:OTABSIZE
		obj:maxStrings         := ::Opt:OMAXSTRINGS
		obj:autoWrap           := ::Opt:OAUTOWRAP
		obj:lEofString         := .t.
		::__setFocus(nWin)
		if sh == 2
			::drawhead()
			if obj:loadFile(fd)
				::__l_tobj := .t.
			else
				alert([Can't open file;]+fd, "OK")
				asize(::tobj, ::nWins-1)
				asize(::tobjinfo, ::nWins-1)
				::nWins --
				wclose()
				::__setFocus(oldwin)
				wselect(::tobjinfo[::curwin]:curwin)
				::drawhead()
			endif
	else
		::tobjinfo[::curwin]:share := .t.
		::tobjinfo[shnum]:share := .t.
		::drawhead()
		::tobj[::curwin]:__nullInit()
		::tobj[::curwin]:edbuffer := ::tobj[shnum]:edbuffer
		::tobj[::curwin]:lines := len(::tobj[::curwin]:edbuffer)
		::tobj[::curwin]:refresh()
	endif
	endif
return
************************************
static function me_findString(nWin)
local k, r, curw
	::__checkWindow(@nWin)
	::__setFocus(nWin)
	k := ::tobj[::curwin]:curWord()
	::Find:fstring := iif (empty(k), ::Find:fhistory:first(), k)
	::Find:replace := .f.
	r := ::Find:get()
	if !r
		return .f.
	endif
	if ::Find:direct == 3
		::tobj[::curwin]:line := 1
		::tobj[::curwin]:pos := 1
	endif
	if ::Find:allw
		curw := ::curwin
		if !::tobj[::curwin]:find(::Find)
			do while .t.
				::__setFocus(::curwin + 1)
				::tobj[::curwin]:line := 1
				::tobj[::curwin]:pos := 0
				if iif(::Find:direct==2, ::tobj[::curwin]:findPrev(::Find), ::tobj[::curwin]:findNext(::Find))
					exit
				elseif ::curwin == curw
					alert([String;]+::Find:fstring+[;not found!], "OK", set("edit_colors_menu"))
					exit
				endif
			enddo
		endif
	   else
		if !::tobj[::curwin]:find(::Find)
			alert([String;]+::Find:fstring+[;not found!], "OK", set("edit_colors_menu"))
		endif
	endif
	setcursor(1)
return .t.
************************************
static function me_findReplace(nWin)
local k, i, change
	::__checkWindow(@nWin)
	::__setFocus(nWin)
	k := ::tobj[::curwin]:curWord()
	::Find:fstring := iif(empty(k), ::Find:fhistory:first(), k)
	::Find:rstring := ::Find:rhistory:first()
	::Find:replace := .t.

	if !::Find:get()
		return .f.
	endif
	setcursor(1)
	if !empty(::Find:fstring)
		i := 0
		change := 0
		do while .t.
			k := 0
			do while k >= 0
				k := ::tobj[::curwin]:replace(::Find)
				if k == 1
					change++
				endif
			enddo

			if ::Find:allw
				::__setFocus(::curwin + 1)
				i++
				wselect(::tobjinfo[::curwin]:curwin)
				::drawhead()
				::tobj[::curwin]:gotoPos(1)
				::tobj[::curwin]:gotoLine(1)
				if i > len(::tobj)
					alert([String;]+::Find:fstring+[;not found!], "OK", set("edit_colors_menu"))
					exit
				endif
			else
				exit
			endif
		enddo
		alert([Made ]+alltrim(str(change))+ [ changes], "OK")
	endif
return .t.
************************************
static function me_findPrev(nWin)
local curw
	::__checkWindow(@nWin)
	::__setFocus(nWin)
	if empty(::Find:fstring)
		alert([Nothing to find!!!], "OK")
	else
		if ::Find:allw
			curw := ::curwin
			if !::tobj[::curwin]:findPrev(::Find)
				do while .t.
					::__setFocus(::curwin + 1)
					::tobj[::curwin]:line := 1
					::tobj[::curwin]:pos := 0
					if ::tobj[::curwin]:findPrev(::Find)
						exit
					elseif ::curwin == curw
						alert([String;]+::Find:fstring+[;not found!], "OK", set("edit_colors_menu"))
						exit
					endif
				enddo
			endif
		else
			if !::tobj[::curwin]:findPrev(::Find)
				alert([String ]+::Find:fstring+[ not found!], "OK", set("edit_colors_menu"))
			endif
		endif
	endif
return .t.
************************************
static function me_findNext(nWin)
local curw
	::__checkWindow(@nWin)
	::__setFocus(nWin)
	if empty(::Find:fstring)
		alert([Nothing to find!!!], "OK")
	else
		if ::Find:allw
			curw := ::curwin
			if !::tobj[::curwin]:findNext(::Find)
				do while .t.
					::__setFocus(::curwin + 1)
					::tobj[::curwin]:line := 1
					::tobj[::curwin]:pos := 0
					if ::tobj[::curwin]:findNext(::Find)
						exit
					elseif ::curwin == curw
						alert([String;]+::Find:fstring+[;not found!], "OK", set("edit_colors_menu"))
						exit
					endif
				enddo
			endif
		else
			if !::tobj[::curwin]:findNext(::Find)
				alert([String;]+::Find:fstring+[;not found!], "OK", set("edit_colors_menu"))
			endif
		endif
	endif
return .t.
************************************
static function me_reloadFile(nWin)
local obj := ::__checkWindow(@nWin)
local k
	if obj:updated
		if alert([There is a change in the file.;]+::tobjinfo[nWin]:name+[; Reload?], {[Yes], [No]}, set("edit_colors_menu")) == 1
			k := obj:loadFile(::tobjinfo[nWin]:name)
		endif
	else
		k := obj:loadFile(::tobjinfo[nWin]:name)
	endif
	if !k
		alert([Can't open file;]+::tobjinfo[nWin]:name, "OK")
	endif
return .t.
************************************
static function me_prevWindow()

	do while .t.
		::__setFocus(::curwin - 1)
		if ::tobj[::curwin] != NIL
			exit
		endif
	enddo
	wselect(::tobjinfo[::curwin]:curwin)
	::drawhead()
	if ::tobjinfo[::curwin]:share
		::tobj[::curwin]:lines := len(::tobj[::curwin]:edbuffer)
		::tobj[::curwin]:refresh()
	endif
	devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1, ::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
return .t.
************************************
static function me_nextWindow()
	do while .t.
		::__setFocus(::curwin + 1)
		if ::tobj[::curwin] != NIL
			exit
		endif
	enddo
	wselect(::tobjinfo[::curwin]:curwin)
	::drawhead()
	if ::tobjinfo[::curwin]:share
		::tobj[::curwin]:lines := len(::tobj[::curwin]:edbuffer)
		::tobj[::curwin]:refresh()
	endif
	devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1, ::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
return .t.
************************************
static function me_setInsertMode(lMode)
	if lMode == NIL .or. valtype(lMode) != "L"
		lMode := !Set(_SET_INSERT)
	endif
	set( _SET_INSERT, lMode )
	if lMode
		setCursor( SC_INSERT )
	else
		setCursor( SC_NORMAL )
	endif
	::oMenu:_status("CHECKED", HASH_InsMode, lMode)
	::drawhead()
return  .t.
************************************
static function me_matchSymbol(nWin, lDirect)
local obj := ::__checkWindow(@nWin)
local symb
	lDirect := iif(lDirect == NIL, .t., lDirect)

	if !obj:Identity(@symb, lDirect)
		alert([Symbol ']+symb+[' not found!], "OK")
	endif
return .t.
************************************
static function me_matchStructure(nWin, lDirect)
local obj := ::__checkWindow(@nWin)
local symb
	lDirect := iif(lDirect == NIL, .t., lDirect)

	symb := obj:curword()
	if !obj:matchStruct(symb, lDirect)
		alert([Structure not found!], "OK")
	endif
return .t.
************************************
static function me_copyToClipboard(nWin)
local obj := ::__checkWindow(@nWin)
	obj:copyToClipboard(::Clipboard)
return .t.
************************************
static function me_saveBlock(nWin)
local obj := ::__checkWindow(@nWin)
local fd, r, s
	if !obj:strblock .and. !obj:rectblock
		alert([Block not marked!], "OK")
	else
		fd=filedialog(__CurrentDir, "*", ::__FileD)
		if !empty(fd)
			__CurrentDir := padr(fd, atr(PATH_DELIM, fd))
		endif
		r := file(fd)
		if r
			s:=alert([File;]+fd+[;already exists. Overwrite it?], {[Yes], [No]}, set("edit_colors_menu"))
		endif
		if !r .or. r .and. s == 1
			obj:saveBlock(fd, ::Opt:OCREATEBAK)
		endif
	endif
return .t.
************************************
static function me_showFiles()
local obj, nWin
local k, r, s
	k := int(3*maxcol()/4)
	r := int(3*maxrow()/4)
	s := setcolor("15/7")//set("edit_colors_list"))
	//obj := ::tobj[::curwin]
	wopen(int((maxrow()-r)/2), int((maxcol()-k)/2), int((maxrow()-r)/2)+r, int((maxcol()-k)/2)+k)
	wbox()
	@ -1, (k-len([ Windows list ]))/2 say [ Windows list ]
	nWin := ::listfiles()
	wclose()
	::__setFocus(nWin)
	setcolor(s)
	if ::nWins == 0
		::__l_tobj := .f.
		::curwin := 0
	else
		obj := ::tobj[::curwin]
		wselect(::tobjinfo[::curwin]:curwin)
		::drawhead()
		if ::tobjinfo[::curwin]:share
			obj:lines := len(obj:edbuffer)
			obj:refresh()
		endif
		devpos(obj:nTop+obj:rowWin-1,obj:nLeft+obj:colWin-1)
	endif
return .t.
************************************
static function me_closeWindow(nWin)
local obj := ::__checkWindow(@nWin)
local i
	if obj:updated
		i := alert([File;]+::tobjinfo[nWin]:name+[;not saved. Save it?],{[Yes],[No],[Cancel]})
		if i==0 .or. i==3
			return .f.
		elseif i==1
			::saveFile()
		endif
	endif
	//::tobj[::curwin]:setFocus(.f.)
	obj:setFocus(.f.)
	wclose()

	::removeWindow(@nWin)
	do while ::nWins>0
		if ::tobj[nWin]!=NIL
			::__setFocus(nWin)
			wselect(::tobjinfo[::curwin]:curwin)
			::drawhead()
			//::tobj[::curwin]:refresh()
			exit
		endif
		nWin --
	enddo

	if len(::tobj) == 0
		::__l_tobj := .f.
		::curwin := 0
	endif
return .t.
************************************
static function me_markBlock(nWin, lMode)
local obj := ::__checkWindow(@nWin)
	lMode := iif(lMode==NIL, .t., lMode)
	if obj:mkblock
		obj:endBlock(lMode)    // start block
	else
		obj:beginBlock(lMode)  // stop block
	endif

return .t.
************************************
static function me_cancelBlock(nWin)
local obj := ::__checkWindow(@nWin)
	obj:cancelBlock()
return .t.
************************************
static function me_print(nWin, lprintBlock)
local obj := ::__checkWindow(@nWin)
	lPrintBlock := iif(lPrintBlock==NIL, .f., lPrintBlock)
	if !lPrintBlock
		obj:print()
	elseif !(obj:printBlock())
		alert([Block not marked!], "OK")
	endif

return .t.
************************************
static function me_undo(nWin)
local obj := ::__checkWindow(@nWin)
	obj:undo()
return .t.
************************************
static function me_newLine(nWin)
local obj := ::__checkWindow(@nWin)
	if ( Set(_SET_INSERT) )
		obj:insertLine(, ::autoIndent)
	else
		obj:newLine(, ::autoIndent)
	endif
return .t.
************************************
static function me_delete(nWin)
* delete current symbol
local obj := ::__checkWindow(@nWin)
	obj:delRight()
return .t.
************************************
static function me_deleteEnd(nWin)
* delete string from current pos to end
local obj := ::__checkWindow(@nWin)
	obj:delEnd()
return .t.
************************************
static function me_backspace(nWin)
* delete syblol brom left
local obj := ::__checkWindow(@nWin)
	obj:backSpace()
return .t.
************************************
static function me_deleteHome(nWin)
* delete string from current pos to begin
local obj := ::__checkWindow(@nWin)
	obj:delHome()
return .t.
************************************
static function me_deleteLine(nWin)
* delete current line
local obj := ::__checkWindow(@nWin)
	obj:deleteLine()
return .t.
************************************
* move string to the center
static function me_centerLine(nWin)
local obj := ::__checkWindow(@nWin)
	obj:centerLine()
return .t.
************************************
* copy block
static function me_copyblock(nWin, lCopy)
local obj := ::__checkWindow(@nWin)
	lcopy := iif(lCopy==NIL, .T., lCopy)
	if lCopy
		obj:copyBlock()
	else
		obj:moveBlock()
	endif
return .t.
************************************
* remove block
static function me_deleteBlock(nWin)
local obj := ::__checkWindow(@nWin)
	obj:deleteBlock()
return .t.
* paste block from Clipboard
************************************
* paste block from Clipboard
static function me_pasteFromClipboard(nWin)
local obj := ::__checkWindow(@nWin)
	obj:pasteFromClipboard(::Clipboard)
return .t.
* load block from file
************************************
* load block from file
static function me_loadBlock(nWin)
local obj := ::__checkWindow(@nWin), fd, r
	fd=filedialog(__CurrentDir, "*", ::__FileD)
	if !empty(fd)
		__CurrentDir := padr(fd, atr(PATH_DELIM, fd))
	endif
	r := file(fd)
	if !r
		alert([File;]+fd+[;not found!],"OK", set("edit_colors_menu"))
	else
		if !obj:loadBlock(fd)
			alert([Can't open file;]+fd, "OK")
		endif
	endif
return .t.
************************************
* insert template
static function me_insTemplate(nWin)
local obj := ::__checkWindow(@nWin)
	obj:insTempl(::templ)
return .t.
************************************
* insert macro
static function me_insMacro(nWin)
local obj := ::__checkWindow(@nWin)
	obj:insMacro(::tempmacro)
return .t.
************************************
* format line/part
static function me_format(nWin, lFrmt)
local obj := ::__checkWindow(@nWin)
	lFrmt := iif(lFrmt==NIL, .T., lFrmt)
	if lFrmt
		obj:formatLine(::Opt:OAUTOMARGIN, ::Opt:OMARGINLEFT, ::Opt:OMARGINRIGHT, ::Opt:OTABSIZE, ::Opt:OHYPHEN)
	else
		obj:formatPart(::Opt:OAUTOMARGIN, ::Opt:OMARGINLEFT, ::Opt:OMARGINRIGHT, ::Opt:OTABSIZE, ::Opt:OHYPHEN)
	endif
return .t.
************************************
static function me_setDraw(nWin, lMode)
* on/off single graphic mode
local obj := ::__checkWindow(@nWin)
	lMode := iif(lMode == NIL, .T., lMode)
	if lMode
		::double_mode := .f.
		::single_mode := !::single_mode
		if ::single_mode
			setcursor(2)
			::stline := [ESC - menu          <SINGLE GRAPHIC>]
		else
			setcursor(1)
			::stline := [ESC - menu ]
		endif
	else
		::double_mode := !::double_mode
		::single_mode := .f.
		if ::double_mode
			setcursor(2)
			::stline := [ESC - menu           <DOUBLE GRAPHIC>]
		else
			setcursor(1)
			::stline := [ESC - menu ]
		endif
	endif
	dispbegin()
	wselect(0)
	::oMenu:_status("CHECKED", HASH_SingleGraphic, ::single_mode)
	@ ::nBot, ::nLeft say padr(::stline, ::nRight-::nLeft+1) color "0/w"
	wselect(::tobjinfo[nWin]:curwin)
	::drawhead()
	devpos(obj:nTop+obj:rowWin-1,obj:nLeft+obj:colWin-1)
	dispend()
return .t.
************************************
static function me_savePos(nWin)
local obj := ::__checkWindow(@nWin)
	::__Hist:insert(alltrim(toString(obj:line)))
return .t.
************************************
static function me_callMenu(nChoice)
local i, oldrow, oldcol, hKey

	set( _SET_EVENTMASK, INKEY_ALL )
	i := setcursor(0)
	oldrow := row()
	oldcol := col()
	wopen(::nTop, ::nLeft, ::nbot, ::nright, .f.)
	__keyboard(13)
	::enableMenu()
	::enableBlockMenu()
	hKey := MenuModal(::oMenu,nChoice,maxrow(),0,maxcol(),"r/w")
	wclose()
	wselect(::tobjinfo[::curwin]:curwin)
	setpos(oldrow, oldcol)
	setcursor(i)
	nChoice := ::oMenu:current

return hKey
************************************

static function me_drawhead()
local nwin, l_nwin, ro, name, sh
	ro := ::tobjinfo[::curwin]:readOnly
	sh := ::tobjinfo[::curwin]:share
	name := ::tobjinfo[::curwin]:name
	nwin := iif(ro, [<R>], iif(sh, [<Link>], "")+"<"+iif(Set(_SET_INSERT), [I], [O])+">")+"["+alltrim(str(::tobjinfo[::curwin]:curwin))+"]"
	l_nwin := len(nwin)
	@ -1, maxcol()-l_nwin say  nwin color set("edit_colors_window")
	if !empty(name)
		dispbegin()
		name := right(name, maxcol()*3/4 - l_nwin)
		@ -1, maxcol()-maxcol()*3/4 say padc(name, maxcol()*3/4 - l_nwin, substr(B_SINGLE, 6, 1)) color set("edit_colors_window")
		dispend()
	endif
return .t.
**************************************

static function me_saveFile(asFile, nWin)
local fd, f, al:=0, crbak
   crbak := ::Opt:OCREATEBAK
   asFile := iif(asFile==NIL, .f., asFile)
   nWin := iif(nWin==NIL, ::curwin, nWin)

   if empty(::tobjinfo[nWin]:name) .or. asFile
	fd=filedialog(__CurrentDir, "*", ::__FileD)
	if !empty(fd)
		__CurrentDir := padr(fd, atr(PATH_DELIM, fd))
	endif
	if empty(fd)
		return .f.
	endif
	f := file(fd)
	if f
		al:=alert([File;]+fd+[;already exists. Overwrite it?], {[Yes], [No]}, set("edit_colors_menu"))
	endif
	if al == 3
		return .f.
	endif
	if !f .or. f .and. al == 1
		if ::tobj[nWin]:saveFile(fd, crbak)
			::tobjinfo[nWin]:name := fd
			::drawhead()
		else
			alert([Can't save file ;]+fd)
		endif
	endif
   else
	fd := ::tobjinfo[nWin]:name
	::tobj[nWin]:saveFile(fd, crbak)
   endif
return .t.

************************************************
static function me_menu_Create()
local oTopBar, oPopUp, oPopUp1, oItem
local keys:=HK_get("edit"),kn

      oTopBar := TopBar( 0, 0, maxcol())
      oTopBar:ColorSpec := set("edit_colors_menu")

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("edit_colors_menu")
      oTopBar:AddItem( MenuItem ( [&File],oPopUp,,,HASH_ItemFile) )

      kn:=key_name(HK_get_key(keys,HASH_CreateNewFile))
      oItem :=MenuItem( [&New                ]+kn ,{|| .t. }, ,[Create a new file], HASH_CreateNewFile)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_OpenFile))
      oItem :=MenuItem( [&Open...            ]+kn ,{|| .t. }, ,[Open a file], HASH_OpenFile)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_SaveFile))
      oItem :=MenuItem( [&Save               ]+kn ,{|| .t. }, ,[Save a file], HASH_SaveFile)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_SaveAsFile))
      oItem :=MenuItem( [&Save as...         ]+kn ,{|| .t. }, ,[Save a file as...], HASH_SaveAsFile)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_Reload))
      oItem :=MenuItem( [&Reload file        ]+kn ,{|| .t. }, ,[Reload a file], HASH_Reload)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_ReadOnly))
      oItem :=MenuItem( [Read on&ly          ]+kn ,{|| .t. }, ,[Read only options], HASH_ReadOnly)
      oPopUp:AddItem( oItem)

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(keys,HASH_Print))
      oItem :=MenuItem( [&Print...           ]+kn ,{|| .t. }, ,[Print a file], HASH_Print)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_PrintBlock))
      oItem :=MenuItem( [Print &block...     ]+kn ,{|| .t. }, ,[Print marked block], HASH_PrintBlock)
      oPopUp:AddItem( oItem)

      oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )

      kn:=key_name(HK_get_key(keys,HASH_ExitSave))
      oItem :=MenuItem( [E&xit with save     ]+kn ,{|| .t. }, ,[End of application and save options], HASH_ExitSave)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_ExitNoSave))
      oItem :=MenuItem( [Exit with-out sa&ve ]+kn ,{|| .t. }, ,[End of application and not save options], HASH_ExitNoSave)
      oPopUp:AddItem( oItem)

**************************************************************************

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("edit_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Window],oPopUp,,,HASH_ItemWindow) )

      kn:=key_name(HK_get_key(keys,HASH_ListFiles))
      oItem :=MenuItem( [&List    ]+kn ,{|| .t. }, ,[List of windows], HASH_ListFiles)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_NextWindow))
      oItem :=MenuItem( [&Next    ]+kn ,{|| .t. }, ,[Next window], HASH_NextWindow)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_PrevWindow))
      oItem :=MenuItem( [&Prev    ]+kn ,{|| .t. }, ,[Prevoice window], HASH_PrevWindow)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_CloseWindow))
      oItem :=MenuItem( [&Close   ]+kn ,{|| .t. }, ,[Close window], HASH_CloseWindow)
      oPopUp:AddItem( oItem)

**************************************************************************

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("edit_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Block],oPopUp,,, HASH_ItemBlock) )

      kn:=key_name(HK_get_key(keys,HASH_MarkBlockString))
      oItem :=MenuItem( [&Line block marker    ]+kn ,{|| .t. }, ,[Start/stop line block marker], HASH_MarkBlockString)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_MarkBlockRect))
      oItem :=MenuItem( [&Column block marker  ]+kn ,{|| .t. }, ,[Start/stop columns block marker], HASH_MarkBlockRect)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_CancelBlock))
      oItem :=MenuItem( [&Unmark               ]+kn ,{|| .t. }, ,[Unmark block marker], HASH_CancelBlock)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_CopyBlock))
      oItem :=MenuItem( [Co&py                 ]+kn ,{|| .t. }, ,[Copy block ], HASH_CopyBlock)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_MoveBlock))
      oItem :=MenuItem( [&Move                 ]+kn ,{|| .t. }, ,[Move block ], HASH_MoveBlock)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_DeleteBlock))
      oItem :=MenuItem( [&Delete               ]+kn ,{|| .t. }, ,[Delete block], HASH_DeleteBlock)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_CopyClipboard))
      oItem :=MenuItem( [Copy to clip&board    ]+kn ,{|| .t. }, ,[Copy block to clipboard], HASH_CopyClipboard)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_PasteClipboard))
      oItem :=MenuItem( [Pa&ste from clipboard ]+kn ,{|| .t. }, ,[Paste block from clipboard], HASH_PasteClipboard)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_SaveBlock))
      oItem :=MenuItem( [&Save to file         ]+kn ,{|| .t. }, ,[Save block to file], HASH_SaveBlock)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_LoadBlock))
      oItem :=MenuItem( [&Load from file       ]+kn ,{|| .t. }, ,[Load block from file], HASH_LoadBlock)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_PrintBlock))
      oItem :=MenuItem( [&Print...           ]+kn ,{|| .t. }, ,[Print marked block], HASH_PrintBlock)
      oPopUp:AddItem( oItem)


      //oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
**************************************************************************

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("edit_colors_menu")
      oTopBar:AddItem( MenuItem ( [&Service],oPopUp,,, HASH_ItemService) )

      kn:=key_name(HK_get_key(keys,HASH_InsMode))
      oItem :=MenuItem( [&Insert mode    ]+kn ,{|| .t. },,[On/off insert mode ], HASH_InsMode)
      oItem:Checked := Set(_SET_INSERT)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_FindString))
      oItem :=MenuItem( [Find &string    ]+kn ,{|| .t. }, ,[Find string ], HASH_FindString)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_FindNext))
      oItem :=MenuItem( [Find &next      ]+kn ,{|| .t. }, ,[Find next ], HASH_FindNext)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_FindPrev))
      oItem :=MenuItem( [Find pre&vious  ]+kn ,{|| .t. }, ,[Find previous ], HASH_FindPrev)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_FindReplace))
      oItem :=MenuItem( [&Replace        ]+kn ,{|| .t. }, ,[Find and replace string ], HASH_FindReplace)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_MatchSymbolForward))
      oItem :=MenuItem( [&Match symbol forward  ]+kn ,{|| .t. }, ,[Match identity symbol in forward ], HASH_MatchSymbolForward)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_MatchSymbolBackward))
      oItem :=MenuItem( [Match symbol &backward ]+kn ,{|| .t. }, ,[Match identity symbol in backward ], HASH_MatchSymbolBackward)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_MatchStructForward))
      oItem :=MenuItem( [Match structure forward  ]+kn ,{|| .t. }, ,[Match Clipper structure to forward ], HASH_MatchStructForward)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_MatchStructBackward))
      oItem :=MenuItem( [Match structure backward ]+kn ,{|| .t. }, ,[Match Clipper structure to backward ], HASH_MatchStructBackward)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_Undo))
      oItem :=MenuItem( [&Undo           ]+kn ,{|| .t. },,[Undo operation], HASH_Undo)
      oPopUp:AddItem( oItem)


**************************************************************************

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("edit_colors_menu")
      oTopBar:AddItem( MenuItem ( [Forma&t],oPopUp,,, HASH_ItemFormat) )

      kn:=key_name(HK_get_key(keys,HASH_FormatLine))
      oItem :=MenuItem( [Format &line    ]+kn ,{|| .t. },,[Format line], HASH_FormatLine)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_FormatPart))
      oItem :=MenuItem( [Format &part    ]+kn ,{|| .t. },,[Format part], HASH_FormatPart)
      oPopUp:AddItem( oItem)

**************************************************************************

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("edit_colors_menu")
      oTopBar:AddItem( MenuItem ( [O&therwise],oPopUp,,, HASH_ItemOtherwise) )

      kn:=key_name(HK_get_key(keys,HASH_Template))
      oItem :=MenuItem( [&Template       ]+kn ,{|| .t. }, ,[Template ], HASH_Template)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_Macro))
      oItem :=MenuItem( [Template &macro ] ,{|| .t. }, ,[Template macro ], HASH_Macro)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_SingleGraphic))
      oItem :=MenuItem( [&Single graphic ]+kn ,{|| .t. }, ,[On/Off single graphic mode ], HASH_SingleGraphic)
      oItem:Checked := ::single_mode
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_DoubleGraphic))
      oItem :=MenuItem( [&Double graphic ]+kn ,{|| .t. }, ,[On/Off double graphic mode  ], HASH_DoubleGraphic)
      oItem:Checked := ::double_mode
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_ChooseCodePage))
      oItem :=MenuItem( [&Choose code page ]+kn ,{|| .t. }, ,[Choose code page  ], HASH_ChooseCodePage)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_Options))
      oItem :=MenuItem( [&Options...     ]+kn ,{|| .t. },,[Set options], HASH_Options)
      oPopUp:AddItem( oItem)

**************************************************************************

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("edit_colors_menu")
      oTopBar:AddItem( MenuItem ( [Info],oPopUp,,, HASH_ItemInfo) )

      kn:=key_name(HK_get_key(keys,HASH_HelpEdit))
      oItem :=MenuItem( [&Help       ]+kn ,{|| .t. }, ,[Help page], HASH_HelpEdit)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_About))
      oItem :=MenuItem( [&About ] ,{|| .t. }, ,[About program ], HASH_About)
      oPopUp:AddItem( oItem)

   return ( oTopBar)

**********************************************************
static function me_listfiles()
local sv, fd, i, retvalue, scr, nKey:=1, listobj, length, cur, aa


length := maxcol() - 1

retvalue := ::curwin
listobj := listitemnew(0, 0, maxrow()+1, maxcol()+1, 1, , set("edit_colors_list"))
listobj:clear()
for i=1 to ::nWins
	if ::tobjinfo[i] == NIL
		loop
	endif
	listobj:addItem(padr(alltrim(str(::tobjinfo[i]:curwin))+ ;
	    iif(::tobjinfo[i]:readOnly, [R:], iif(::tobj[i]:updated, "*: ", " : "))+ ;
	    ::tobjinfo[i]:name, length))

	if ::tobjinfo[i]:curwin == retvalue
		cur := i
	endif
next
listobj:setfocus()
listobj:setItem(::curwin)

do while nkey!=0
	nkey := Inkey(0)
	i := listobj:handleKey(nKey)
	if i == -1
		i := 0
		nKey := 0
	endif
	if i + nKey == 0
		loop
	endif

	do case
		case nkey == K_DEL
			if listobj:itemCount < 1
				loop
			endif
			if ::nWins>0 .and. ::tobj[listobj:buffer]:updated
				sv := alert(::tobjinfo[listobj:buffer]:name+[; not saved. Save?], {[Yes], [No], [Cancel]}, set("edit_colors_menu") )
				if sv == 1
				    if empty(::tobjinfo[listobj:buffer]:name)
					fd=filedialog(__CurrentDir, "*", ::__FileD)
					if !empty(fd)
						__CurrentDir := padr(fd, atr(PATH_DELIM, fd))
					endif
					if !file(fd) .or. ;
					   (file(fd) .and. alert([File;]+fd+[;already exists. Overwrite it?], {[Yes], [No]}, set("edit_colors_menu")) == 1)
						::tobjinfo[listobj:buffer]:name := fd
						::tobj[listobj:buffer]:saveFile(fd)
					endif
				    endif
				endif
				if sv == 3
					loop
				endif
			endif
			cur := listobj:buffer
			dispbegin()
			aa:=wselect()
			wselect(::tobjinfo[cur]:curwin)
			wclose()
			wselect(aa)
			//::drawhead()
			dispend()

			adel(::tobj, listobj:buffer)
			asize(::tobj, ::nWins-1)
			adel(::tobjinfo, listobj:buffer)
			asize(::tobjinfo, ::nWins-1)
			::nWins--
			if ::curwin >= listobj:buffer
				::curwin --
			endif

			listobj:delItem(listobj:buffer)
			retvalue := listobj:buffer
		case nkey == K_ENTER
			if listobj:itemCount < 1
				retvalue := 0
			else
				retvalue := listobj:buffer
			endif
			nkey := 0
		otherwise
		    if nkey>=32 .and. nkey<=256
			listobj:find(chr(nkey))
			devpos(listobj:line, listobj:col)
		    endif
	endcase
enddo
//restore screen from scr
return retvalue

*************************************************************
static function me_editopt()
local get_color, color, dl, fl, getlist:={}, fullScr := .t., i, y
local cbak, tab, asave, tsave, lang, ssave, hyp, autom, mleft, mright, aindent
local tabpack, maxstrings, autowrap, nopen, buttons := {}
local oWin

i := setcursor()
get_color := "11/1, 14/1, 11/1, 11/1, 11/1, 0/7"
color := setcolor()
setcolor(set("edit_colors_dialog"))
fl := 25
dl := fl+6
/* get locales */

dispbegin()
oWin := wselect()
wopen(int((maxrow())/2)-5, int((maxcol())/2)-(2*fl+17)/2, int((maxrow())/2)+11, int((maxcol())/2)+(2*fl+17)/2)
wbox()
clear screen
cbak := ::Opt:OCREATEBAK
tab := ::Opt:OTABSIZE
lang := ::Opt:OLANGUAGE
asave := ::Opt:OAUTOSAVE
tsave := ::Opt:OTIMEAUTOSAVE
ssave := ::Opt:OSAVESTATUS
hyp := ::Opt:OHYPHEN
autom := ::Opt:OAUTOMARGIN
autowrap := ::Opt:OAUTOWRAP
mleft := ::Opt:OMARGINLEFT
mright := ::Opt:OMARGINRIGHT
aindent := ::Opt:OAUTOINDENT
maxstrings := ::Opt:OMAXSTRINGS
nopen      := ::Opt:OOPENFILES
tabpack := iif(lower(set("edit_tabpack"))=="yes", .t., .f.)

@ -1, maxcol()/2-len([ Options ]) say [ Options ]
y := 1
@ y, 1 say padr([Create .bak files], fl) //color say_color
@ y, fl+2 get cbak CHECKBOX color get_color
y++
@ y, 1 say padr([Tabulation size], fl)
@ y, fl get tab picture "9999"  color get_color
y++
@ y, 1 say padr([Tabulation packing], fl)
@ y, fl+1 get tabpack  picture "XXX" color get_color
y++
@ y, 1 say padr([Open files in ], fl)
y++
aadd(buttons, RadioButton(y+1, 4, [current directory]))
aadd(buttons, RadioButton(y+2, 4, [last directory]))
@ y, 1, y+3, fl+4 get nopen RADIOGROUP buttons //color get_color
y+=4
@ y, 1 say replicate("_", maxcol(fullScr)-2)
y++
@ y, 1 say padr([Autosave files], fl)
@ y, fl+2 get asave CHECKBOX  color get_color
y++
@ y, 1 say padr([Autosave time], fl)
@ y, fl get tsave picture "9999" color get_color
y++
y++
@ y, 1 say replicate("_", maxcol(fullScr)-2)
y++
//@ 7, 1 say padr([Language], fl)
//@ 7, fl get lang  picture "@KS10A" color get_color
//@ 7, 1 say padr("Length string", fl)
//@ 7, fl get Opt:OLENGTH picture "9999"  color get_color
y++
@ y, 1 say padr([Save status], fl)
@ y, fl+2 get ssave CHECKBOX color get_color
y := 1
@ y, dl say padr([Hypen in word], fl)
@ y, dl+fl+7 get hyp  CHECKBOX color get_color
y++
@ y, dl say padr([Auto wrap], fl)
@ y, dl+fl+7 get autowrap  CHECKBOX color get_color
y++
@ y, dl say padr([Auto margin left], fl)
@ y, dl+fl+7 get autom  CHECKBOX color get_color
y+=6
y++
@ y, dl say padr([Margin left], fl)
@ y, dl+fl+5 get mleft  picture "9999" color get_color
y++
@ y, dl say padr([Margin right], fl)
@ y, dl+fl+5 get mright  picture "9999" color get_color
y++
@ y, dl say padr([Max strings], fl)
@ y, dl+fl+3 get maxstrings  picture "999999" color get_color
y++
y++
y++
@ y, dl say padr("Auto indent", fl)
@ y, dl+fl+7 get aindent CHECKBOX color get_color
//@ 4, dl say padr("Page length", fl)
//@ 4, dl+fl+3 get Opt:OPAGELEN  picture "9999" color get_color
//@ 7, dl say padr("Language", fl)
//@ 7, dl+fl get Opt:OLANGUAGE  picture "@KS10A" color get_color
dispend()
read

::Opt:OCREATEBAK    := cbak
::Opt:OTABSIZE      := tab
::Opt:OLANGUAGE     := lang
::Opt:OAUTOSAVE     := asave
::Opt:OTIMEAUTOSAVE := tsave
::Opt:OSAVESTATUS   := ssave
::Opt:OHYPHEN       := hyp
::Opt:OAUTOMARGIN   := autom
::Opt:OAUTOWRAP     := autowrap
::Opt:OMARGINLEFT   := mleft
::Opt:OMARGINRIGHT  := mright
::Opt:OAUTOINDENT   := aindent
::Opt:OMAXSTRINGS   := maxstrings
::Opt:OOPENFILES    := nopen

::autoIndent   := aindent
set("edit_tabpack", iif(tabpack, "yes", "no"))
::Opt:OTABPACK   := set("edit_tabpack")

putenv("LANG="+alltrim(lang))

wclose()
wselect(oWin)
setcolor(color)
::save_options()
for i=1 to ::nWins
	::tobj[i]:TabPack := tabpack
next
setcursor(i)
return .t.

static function msg(mess, Opt)
return mess[Opt:OLANGUAGE]

*************************************
static function me_set_options()
local str, arr, i, nfile
memvar obj, options
private obj, Options
	::Opt:=map()
	::Opt:OTABSIZE          := TE_TABSIZE
	::Opt:OAUTOSAVE         := TE_AUTO_SAVE
	::Opt:OTIMEAUTOSAVE     := TE_TIME_AUTO_SAVE
	::Opt:OCREATEBAK        := TE_CREATE_BAK
	::Opt:OMARGINLEFT       := TE_MARGIN_LEFT
	::Opt:OMARGINRIGHT      := TE_MARGIN_RIGHT
	::Opt:OSAVESTATUS       := TE_SAVE_STATUS
	::Opt:OLANGUAGE         := TE_LANGUAGE
	::Opt:OSTEPUNDO         := TE_STEP_UNDO
	::Opt:OHISTORY          := TE_HISTORY_SIZE
	::Opt:OAUTOMARGIN       := TE_AUTO_MARGIN
	::Opt:OHYPHEN           := TE_HYPHEN
	::Opt:OAUTOINDENT       := TE_AUTO_INDENT
	::Opt:OTABPACK          := set("edit_tabpack")
	::Opt:OMAXSTRINGS       := TE_MAXSTRINGS
	::Opt:OAUTOWRAP         := TE_AUTO_WRAP
	::Opt:OOPENFILES        := 1
	::Opt:FCASE             := .f.
	::Opt:FWORDONLY         := .f.
	::Opt:FREGEXP           := .f.
	::Opt:FALLW             := .f.
	::Opt:FDIRECT           := 1
	::Opt:FWHERE            := 1
	nfile := fopen(::__fileOpt)
	if nfile >= 0
		do while !fileeof(nfile)
			str := filegetstr(nfile, 1024)
			arr := split(str, ";")
			if len(arr)>0
				for i:= 1 to len(arr)
					&(arr[i])
				next
			else
				&str
			endif
		enddo
		fclose(nfile)
	endif
	//::Opt := Options
	o2self(::Opt, Options)
	set("edit_tabpack", ::Opt:OTABPACK)
	//::Opt:OTABPACK := set("edit_tabpack")
	::autoIndent := ::Opt:OAUTOINDENT
return .T.
*************************************
static function fget(nfile, buflen)
local ret:="", str
	str := filegetstr(nfile, buflen)
	if len(str) != buflen
		return str
	endif
	do while len(str) == buflen .and. !fileeof(nfile)
		ret += str
		str := filegetstr(nfile, buflen)
	enddo
return ret
*************************************
static function me_getstatus()
local str, arr, nfile, i, buflen:=1024
private obj
	if !File(::__fileStatus)
		return .f.
	endif
	nfile := fopen(::__fileStatus)
	str := fget(nfile, buflen)
	::curwin := str2var(str)
	//? 'get curwin'
	str := fget(nfile, buflen)
	::__FileD:set(str2var(str))
	//? 'get fileD'
	str := fget(nfile, buflen)
	::Find:sethistfind(str2var(str))
	//? 'get Find'
	str := fget(nfile, buflen)
	::Find:sethistrepl(str2var(str))
	//? 'get Find repl'
	str := fget(nfile, buflen)
	::tobjinfo := str2var(str)
	::nWins := len(::tobjinfo)

	//? 'get info'
	fclose(nfile)

return .t.

***************************
static function me_save_options()
local nfile, str
	::Opt:FCASE             := ::Find:case
	::Opt:FWORDONLY         := ::Find:wordonly
	::Opt:FREGEXP           := ::Find:regexp
	::Opt:FALLW             := ::Find:allw
	::Opt:FDIRECT           := ::Find:direct
	::Opt:FWHERE            := ::Find:where
	dirmake(::__dirEdit)
	nfile := fcreate(::__dirEdit+PATH_DELIM+".edit")

	str := "Options := "+varToString(::Opt)+"&\n"
	fwrite(nfile, str, len(str))
	fclose(nfile)
return .t.
***************************
static function me_writestatus()
local str:="", nfile:="", buflen:=1024, i, _e:="&\n"
private len

	nfile := fcreate(::__fileStatus)
	if nfile < 0
		return .f.
	endif
	str := var2str(::curwin)+_e
	fwrite(nfile, str, len(str))
	str := var2str(::__FileD:history)+_e
	fwrite(nfile, str, len(str))
	str := var2str(::Find:fhistory:history)+_e
	fwrite(nfile, str, len(str))
	str := var2str(::Find:rhistory:history)+_e
	fwrite(nfile, str, len(str))
	for i := 1 to ::nWins
		::tobjinfo[i]:pos := ::tobj[i]:pos
		::tobjinfo[i]:line := ::tobj[i]:line
		::tobjinfo[i]:colwin := ::tobj[i]:colWin
		::tobjinfo[i]:rowwin := ::tobj[i]:rowWin
	next
	str := var2str(::tobjinfo)
	fwrite(nfile, str, len(str))

	fclose(nfile)
return .t.
***************************
static function me_goto()
local scr, top, bottom, left, right, str, getstr, oldcolor, getobj, getlist:={}
local nKey, newline

save screen to scr
oldcolor=setcolor(set("edit_colors_menu"))

str := [Line ]
top := maxrow()/2 - 1
bottom := top + 2
left := maxcol()/2 - len(str) - 10
right := left + len(str) + 10
@ top, left clear to bottom, right
@ top, left to bottom, right
::__Hist:Lrow := top + 2
::__Hist:Lcol := left +len(str) +2
::__Hist:Rrow := top + 7
::__Hist:Rcol := right - 2

getstr := padl(val(::__Hist:first()), 8)

@ top+1, left + 1 say str// get getstr picture "@kS89"
getobj := getnew(top+1, left + len(str) +1, {|_1| iif(_1==NIL, padr(getstr, 10),getstr:=_1)}, "getstr", "@kS8", setcolor())
getobj:setFocus()
do while .t.
	nKey := Inkey(0)
	do case
	case nKey == K_ESC
		newline := 0
		exit
	case nKey == K_DOWN
		newline := ::__Hist:run()
		if !empty(newline)
			getobj:varPut(newline)
			getobj:assign()
		endif
		getobj:setFocus()
		getobj:home()
	case nKey == K_ENTER .or. nKey == K_PGDN
		 getobj:assign()
		 newline := getobj:varGet()
		 exit
	case nKey == K_HOME
		getobj:home()
	case nKey == K_END
		getobj:end()
	case nKey == K_DEL
		getobj:delete()
	case nKey == K_BS
		getobj:backspace()
	otherwise
		if nkey>=32 .and. nkey<=256
			if set(_SET_INSERT)
				getobj:Insert(chr(nKey))
			else
				getobj:overStrike(chr(nKey))
			endif
		endif
	endcase
enddo
setcolor(oldcolor)
restore screen from scr
setcursor(1)

if !empty(newline)
	::__Hist:insert(newline)
	if !::tobj[::curwin]:gotoLine(val(newline), .t.)
		alert([Bad line number!], "OK")
		::__Hist:delete(newline)
	endif
endif

return newline
********************************
static function me___check_share(fd, num)
local ret:=2, i, f:= .f.
	if empty(fd)
		return 0
	endif
	for i:= 1 to ::nWins
		if ::tobjinfo[i]:name == fd
			f := .t.
			num := i
			exit
		endif
	next
	if f
		ret := alert("Window exist:;"+fd, {[Cancel], [New], [Link]})
	endif
return ret
*********************************
static function me_helpEdit()
	hbrowse(,,,,"file:"+cliproot()+PATH_DELIM+"doc"+PATH_DELIM+"edit.html")
return
*********************************
static function me_about()
local w, color
	w := wselect()
	color := setcolor("0/7")
	wopen(7, 8, 18, 69)
	wbox()
	@ 1, 2 say padc("TEXT EDITOR", 56)
	@ 2, 2 say padc("Copyright (C) 2001-2004  ITK", 56)
	@ 3, 2 say padc("----------", 56)
	@ 4, 2 say padc("written by CLIP version "+CLIP_VERSION+"-"+alltrim(str(ME_VERSION)), 56)
	@ 6, 2 say padc("Licence : (GPL) http://www.itk.ru/clipper/licence.html", 56)
	@ 7, 2 say padc("Author  : Elena Kornilova <alena@itk.ru>              ", 56)
	@ 8, 2 say padc("< OK >", 56)
	inkey(0)
	wclose()
	wselect(w)
	setcolor(color)
return
************************************
static function me_chooseCodePage()
local pathCP:="", a, b, lo, nkey:=-1, str
local i,k, r, nLeft, nRight, nTop, nBottom, cntc:=4, item, oldcolor, owin

	pathCP += CLIPROOT()+PATH_DELIM+"charsets"
	b = {}
	a = fileseek(pathCP+PATH_DELIM+"*.tbl", FA_ARCHIVE+FA_VOLUME+FA_SYSTEM+FA_HIDDEN+FA_READONLY)
	while !empty(a)
		a := left(a, len(a)-4)
		aadd(b, a)
		a = fileseek()
	enddo
	b := asort(b,,,{|x, y| x < y})
	k := int(2*maxcol(.t.)/3)
	if (k-cntc+1)%cntc > 0
		k--
	endif
	r := int(3*maxrow(.t.)/6)
	nLeft := int((maxcol(.t.)-k)/2)+1
	nRight := nLeft + k - 1
	nTop := int((maxrow(.t.)-r)/2)+1
	nBottom := nTop + r - 1
	oldcolor := setcolor("15/7")
	owin := wselect()
	wopen(nTop, nLeft, nBottom, nRight)
	wbox()
	str := [ Source charset ]
	@ -1, (maxcol()-len(str))/2 say str
	lo := listitemnew(0, 0, maxrow(), maxcol(), cntc, substr(B_SINGLE, 4, 1), set("edit_colors_list"))
	for i in b
		lo:addItem(i)
	next
	lo:setFocus()
	lo:refresh()
	do while nkey!=0
		nkey := Inkey(0)
		i := lo:handleKey(nKey)
		if i == -1
			i := 0
			nKey := 0
		endif
		if i + nKey == 0
			loop
		endif
		switch(nkey)
		case K_ESC
			nkey := 0
		case K_ENTER
			item = alltrim(lo:getItem())
			nkey := 0
		otherwise
		    if nkey>=32 .and. nkey<=256
			lo:find(chr(nkey))
		    endif
	endswitch
	enddo
	wclose()
	wselect(owin)
	if item == NIL
		return
	endif
	::tobj[::curwin]:charset := item
	for i=1 to ::tobj[::curwin]:lines
		::tobj[::curwin]:edbuffer[i] := translate_charset(::tobj[::curwin]:charset, ::tobj[::curwin]:__hostcharset, ::tobj[::curwin]:edbuffer[i])
	next
	::tobj[::curwin]:refresh()
	setcolor(oldcolor)
return
************************************
static function me_changeCharset(nWin, charSet)
local pathCP:=cliproot()+PATH_DELIM+"charsets"
	if nWin==NIL .or. !between(nWin, 1, ::nWins)
		return .f.
	endif
	if charSet == NIL .or. !file(pathCP+PATH_DELIM+charSet)
		return .f.
	endif
	::tobj[nWin]:setCharset(charSet)
return .t.
*********************
static function me_removeWindow(nWin)
   nWin := iif(nWin == NIL, ::curwin, nWin)
   if !between(nWin, 1, ::nWins)
	return
   endif
   adel(::tobj, nWin)
   asize(::tobj, ::nWins-1)
   adel(::tobjinfo, nWin)
   asize(::tobjinfo, ::nWins-1)
   nWin --
   ::nWins --
   if ::nWins > 0 .and. nWin < 1
	nWin := 1
   endif
return
*********************
static function me_setReadOnly(nWin, flag)
local i

	flag := iif(valtype(flag)!="L", .t., flag)
	if valtype(nWin) == "N" .and. between(nWin, 1, ::nWins)
		::tobjinfo[nWin]:readOnly := flag
	endif
	::drawHead()
return
*********************
static function me_getReadOnly(nWin)
	if valtype(nWin) == "N" .and. between(nWin, 1, ::nWins)
		return ::tobjinfo[nWin]:readOnly
	endif
return .f.
*********************
static function me_enableMenu()
local enable := ::__l_tobj
	::oMenu:enableStatus(HASH_SaveFile            , enable)
	::oMenu:enableStatus(HASH_Reload              , enable)
	::oMenu:enableStatus(HASH_ReadOnly            , enable)
	::oMenu:enableStatus(HASH_ListFiles           , enable)
	::oMenu:enableStatus(HASH_NextWindow          , enable)
	::oMenu:enableStatus(HASH_PrevWindow          , enable)
	::oMenu:enableStatus(HASH_CloseWindow         , enable)
	::oMenu:enableStatus(HASH_InsMode             , enable)
	::oMenu:enableStatus(HASH_SaveAsFile          , enable)
	::oMenu:enableStatus(HASH_LoadBlock           , enable)
	::oMenu:enableStatus(HASH_FindString          , enable)
	::oMenu:enableStatus(HASH_FindNext            , enable)
	::oMenu:enableStatus(HASH_FindPrev            , enable)
	::oMenu:enableStatus(HASH_FindReplace         , enable)
	::oMenu:enableStatus(HASH_MatchSymbolForward  , enable)
	::oMenu:enableStatus(HASH_MatchSymbolBackward , enable)
	::oMenu:enableStatus(HASH_MatchStructForward  , enable)
	::oMenu:enableStatus(HASH_MatchStructBackward , enable)
	::oMenu:enableStatus(HASH_Undo                , enable)
	::oMenu:enableStatus(HASH_FormatLine          , enable)
	::oMenu:enableStatus(HASH_FormatPart          , enable)
	::oMenu:enableStatus(HASH_Template            , enable)
	::oMenu:enableStatus(HASH_Macro               , enable)
	::oMenu:enableStatus(HASH_SingleGraphic       , enable)
	::oMenu:enableStatus(HASH_DoubleGraphic       , enable)
	::oMenu:enableStatus(HASH_ChooseCodePage      , enable)
	::oMenu:enableStatus(HASH_Print               , enable)
return .t.
*********************
static function me_enableBlockMenu()
local enable := iif(::__l_tobj,::tobj[::curwin]:strblock .or. ::tobj[::curwin]:rectblock,.f.)
	::oMenu:enableStatus(HASH_MarkBlockString, ::__l_tobj)
	::oMenu:enableStatus(HASH_MarkBlockRect  , ::__l_tobj)
	::oMenu:enableStatus(HASH_CancelBlock    , enable)
	::oMenu:enableStatus(HASH_CopyBlock      , enable)
	::oMenu:enableStatus(HASH_MoveBlock      , enable)
	::oMenu:enableStatus(HASH_DeleteBlock    , enable)
	::oMenu:enableStatus(HASH_CopyClipboard  , enable)
	::oMenu:enableStatus(HASH_PasteClipboard , !empty(::Clipboard))
	::oMenu:enableStatus(HASH_SaveBlock      , enable)
	::oMenu:enableStatus(HASH_LoadBlock      , ::__l_tobj)
	::oMenu:enableStatus(HASH_PrintBlock     , enable)
return
****************************
/* get ini file and set user macroses if it specified */
static function me__initUserMacro(iniFileName)
local i, home
	home := getEnv("HOME")
	if iniFileName == NIL
		i := strtran(startpath(), ".exe", "")
		i := substr(i, atr(PATH_DELIM, i)+1)
		iniFileName := home+PATH_DELIM+".clip"+PATH_DELIM+i+".ini"
		if !file(iniFileName)
			iniFileName := cliproot()+PATH_DELIM+'etc'+PATH_DELIM+i+'.ini'
		endif
	endif
	if file(iniFileName)
		::__iniMacro := iniFileNew(iniFileName)
		::__iniMacro:Load()
		::__setMacros()
		return .T.
	endif
return .F.
****************************
static function me___setMacros()
local sect, par, key, val, fl, i, fnc, hk, mnu, cmd
	if empty(::__iniMacro)
		return .f.
	endif
	sect := ::__iniMacro:Sections()
	for i=1 to len(sect)
		par := sect[i]
		val := ::__iniMacro:getValue(par, "UCOMMAND")
		if empty(val)
			loop
		endif
		fl := ::__iniMacro:getValue(par, "UFILE")
		if empty(fl) .or. !file(fl)
			loop
		endif

		load(fl)

		if "UCOMMAND" $ ::__iniMacro:data[par] .and. (::__iniMacro:data[par]:UCOMMAND != NIL)
			cmd := hashStr(::__iniMacro:getValue(par, "UCOMMAND"))
			fnc := ::__iniMacro:getValue(par, "UFUNC")
			if empty(fnc) .or. !isFunction(fnc)
				loop
			endif
			hk := keycodeByName(::__iniMacro:getValue(par, "UHOTKEY"))
			if !(hk $ ::__macroKeys)
				::__macroKeys[hk] := map()
			endif
			::__macroKeys[hk]:func := fnc
			::__macroKeys[hk]:allWins := ::__iniMacro:getValue(par, "UALLWINS")
			::__macroKeys[hk]:command := cmd

			if empty(::__macroKeys[hk]:allWins)
				::__macroKeys[hk]:allWins := .f.
			endif

			if !(cmd $ ::__macroCmd)
				::__macroCmd[cmd] := map()
			endif
			::__macroCmd[cmd]:func := fnc
			::__macroCmd[cmd]:command := cmd
			::__macroCmd[cmd]:allWins := ::__macroKeys[hk]:allWins

			mnu := ::__iniMacro:getValue(par, "UMENUSTR")
			if !empty(mnu)
				::__addMacroToMenu(par, mnu, fnc, cmd, hk)
			endif
		endif
	next
return .t.
*********************************
static function me___addMacroToMenu(par, mstr, fnc, cmd, hk)
static l_m := .f.
static pitem
local mitem, kn
	if empty(mstr)
		mstr := fnc
	endif
	if !l_m
		pitem := PopUp()
		pitem :ColorSpec:= set("edit_colors_menu")
		::oMenu:AddItem( MenuItem ( [Macros],pitem,,,HASH_ItemMacros) )
		l_m := .t.
	endif

	kn:=key_name(hk)
	mItem :=MenuItem( mstr+" "+kn ,{|| .t. }, ,::__iniMacro:getValue(par, "UMENUMSG"), cmd)
	pitem:AddItem( mItem)
return .t.
**********************************
static function me_getFocus()
return ::curWin
**********************************
static function me___setFocus(nWin)
	*if ::curwin > 0 .and. ::nWins > 0 .and. ::curwin <= ::nWins
	*       ::tobj[::curwin]:setFocus(.F.)
	*endif
	if nWin < 1
		nWin := ::nWins
	endif
	if nWin > ::nWins
		nWin := 1
	endif
	if nWin >0 .and. ::nWins > 0
		::curwin := nWin
		::tobj[::curwin]:setFocus(.T.)
		::drawhead()
	endif
return ::curWin

