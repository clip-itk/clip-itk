/*   MEDIT class						*/
/*   								*/
/*   Copyright (C) 2001  ITK					*/
/*   Author  : Elena Kornilova (alena@itk.ru)			*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/

#include "config.ch"
#include "set.ch"
#include "button.ch"   // Menu definitions
#include "inkey.ch"    // Key definitions
#include "edit.ch"
#include "box.ch"

#define FA_NORMAL	0
#define FA_READONLY	1
#define FA_HIDDEN	2
#define FA_SYSTEM	4
#define FA_VOLUME	8
#define FA_DIRECTORY	16
#define FA_ARCHIVE	32

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
	obj:className	:= "MEDIT"
	obj:tobj	:= {}
	obj:tobjinfo	:= {}
	obj:curwin	:= 0
	obj:b_tobj	:= .f.
	obj:Clipboard	:= {}
	//obj:SB		:= 0
	obj:Find	:= 0
	obj:FileD	:= 0
	obj:Opt		:= 0
	obj:GoHist	:= 0
	obj:templ	:= {}
	obj:tempmacro	:= {}
	obj:dirEdit	:= ""
	obj:fileOpt	:= ""
	obj:fileStatus	:= ""
	obj:fileTempl	:= ""
	obj:fileMacro	:= ""
	obj:userfunc	:= user_func
	obj:ntop	:= iif(ntop==NIL,0,ntop)
	obj:nbot	:= iif(nbot==NIL,maxrow(),nbot)
	obj:nright	:= iif(nright==NIL,maxcol(),nright)
	obj:nleft	:= iif(nleft==NIL,0,nleft)
	obj:param	:= iif(par==NIL .or. valtype(par)!="A", {}, par)
	obj:tab_size	:= iif(tab_size==NIL, TE_TABSIZE, tab_size)
	obj:bline	:= iif(bline==NIL,1,bline)
	obj:bpos	:= iif(bpos==NIL,1,bpos)
	obj:wline	:= iif(wline==NIL,1,wline)
	obj:wpos	:= iif(wpos==NIL,1,wpos)
	obj:mapKeys	:= -1
	obj:single_mode	:= .f.
	obj:double_mode	:= .f.
	obj:stline	:= [ESC -menu]
	obj:oMenu	:= NIL
	obj:autoIndent	:= .t.

	obj:initme	:= @me_initme()
	obj:drawhead	:= @me_drawhead()
	obj:getstatus	:= @me_getstatus()
	obj:set_options	:= @me_set_options()
	obj:runme	:= @me_runme()
	obj:saveFile	:= @me_saveFile()
	obj:save_options:= @me_save_options()
	obj:writestatus	:= @me_writestatus()
	obj:listfiles	:= @me_listfiles()
	obj:editopt	:= @me_editopt()
	obj:editKeys	:= @me_editKeys()
	obj:goto	:= @me_goto()
	obj:menu	:= @me_menu_create()
	obj:enableMenu	:= @me_enableMenu()
	obj:enableBlockMenu	:= @me_enableBlockMenu()
	obj:check_share	:= @me_check_share()
	obj:helpEdit	:= @me_helpEdit()
	obj:setReadOnly := @me_setReadOnly()
	obj:getReadOnly := @me_getReadOnly()
	obj:chooseCodePage := @me_chooseCodePage()
	obj:changeCharset:= @me_changeCharset()
	obj:__removeWindow := @me___removeWindow()
	obj:initme()
	//obj:runme()
return obj

********************
static function me_initme()
local nfile, str, spl, i, fd, curwin, oldwin, home, percent
	::ntop := min(max(0,::ntop),maxrow())
	::nbot := min(max(0,::nbot),maxrow())
	::nleft := min(max(0,::nleft),maxcol())
	::nright := min(max(0,::nright),maxcol())

	HK_load()
	::mapKeys	:= HK_get("edit")

	set("edit_margin_right","50") // длина строки
	set("edit_page_len","20")     // длина страницы
	set("edit_txtdir", curdir())   // где храняться документы
	set("edit_colors_edit",'11/1,0/2,0/3,0/7,1/3, 15/R') // цвет редактирования
	set("edit_colors_window",'14/1') // цвет окна редактирования
	set("edit_colors_view",'0/7,7/1,0/3,,1/3')  // цвет просмотра
	set("edit_colors_menu","0/7,0/2,r/7,g/rb,15/7,0/7") // цвет меню
	set("edit_colors_list","15/3,15/7,0/7,0/3,")   // цвет list объектов
	set("edit_colors_dialog","0/7,0/2,w+/b,g/rb,15/7,0/7")   // цвет диалогов
	set("edit_tabpack",'yes')   // сжимать пробелы в табуляции
	set(_SET_SCOREBOARD,.t.)
	setcursor(1)
	//setcancel(.f.)
	::oMenu := ::menu()

	home := getenv("HOME")
	::dirEdit := home+"/.clip"
	::fileOpt := home+"/.clip/.edit"
	::fileStatus := "edit."+getenv("USER")
	::fileTempl := home+"/.clip/.templ"
	::fileMacro := home+"/.clip/.macro"

	::set_options()

	::FileD := historyObj(,,,,set("edit_colors_list"))
	::FileD:setsize(::Opt:OHISTORY)
	::Find := findOptions(,,set("edit_colors_dialog"), set("edit_colors_list"))
	::Find:sethistorysize(::Opt:OHISTORY)
	::GoHist := historyObj(,,,,set("edit_colors_list"))
	::GoHist:setsize(::Opt:OHISTORY)

	setcolor(set("edit_colors_window"))

	@ ::nTop, ::nLeft clear to ::nBot, ::nRight
	@ ::nBot, ::nLeft say padr(::stline, ::nRight-::nLeft+1) color "0/w"
	//::SB := scrollBar(::nTop, ::nBot, ::nRight, NIL)


	if file(::fileTempl)
		nfile := fopen(::fileTempl)
		do while !fileeof(nfile)
			str := filegetstr(nfile, TE_MAX_LEN_STRING)
			spl := {}
			if search("[ &\t]+", str, spl)
				aadd(::templ, {substr(str, 1, spl[1][1]-1), substr(str, spl[1][2])})
			endif
		enddo
		fclose(nfile)
	endif

	if file(::fileMacro)
		nfile := fopen(::fileMacro)
		do while !fileeof(nfile)
			str := filegetstr(nfile, TE_MAX_LEN_STRING)
			spl := {}
			if search("[ &\t]+", str, spl)
				aadd(::tempmacro, {substr(str, 1, spl[1][1]-1), substr(str, spl[1][2])})
			endif
		enddo
		fclose(nfile)
	endif

	if len(::param)>0
		::tobjinfo := {}
		oldwin := 1
		for i:=1 to len(::param)
			fd := ::param[i]
			setcolor(set("edit_colors_window"))
			::curwin := wopen(::ntop,::nleft,::nbot-1,::nright)
			wbox()
			aadd(::tobjinfo, map())
			::tobjinfo[::curwin]:name := fd
			::tobjinfo[::curwin]:readOnly := .f.
			::tobjinfo[::curwin]:share := .f.
			::tobjinfo[::curwin]:curwin := ::curwin
			::drawhead()

			aadd(::tobj, textEditNew(0, 0, maxrow(), maxcol(),set("edit_colors_edit")))
			::tobj[::curwin]:modeFormat         := 2
			::tobj[::curwin]:line               := iif(::bline!=NIL, ::bline, ::tobj[::curwin]:line)
			::tobj[::curwin]:pos                := iif(::bpos!=NIL,  ::bpos,  ::tobj[::curwin]:pos)
			::tobj[::curwin]:rowWin             := iif(::wline!=NIL, ::wline, ::tobj[::curwin]:rowWin)
			::tobj[::curwin]:colWin             := iif(::wpos!=NIL,  ::wpos,  ::tobj[::curwin]:colWin)
			::tobj[::curwin]:marginRight        := ::Opt:OMARGINRIGHT
			::tobj[::curwin]:tabSize            := ::Opt:OTABSIZE
			if ::tobj[::curwin]:loadFile(fd)
				::b_tobj := .t.
			else
				alert([Can't open file;]+fd, "OK")
				asize(::tobj, len(::tobj)-1)
				asize(::tobjinfo, len(::tobj))
				wclose()
			endif
		next
	else
		::getstatus()
		oldwin := ::curwin
		for i:=1 to len(::tobjinfo)
			fd := ::tobjinfo[i]:name
			setcolor(set("edit_colors_window"))
			::curwin=wopen(::ntop,::nleft,::nbot-1,::nright)
			wbox()
			::drawhead()
			aadd(::tobj, textEditNew(0, 0, maxrow(), maxcol(),set("edit_colors_edit")))
			::tobj[::curwin]:modeFormat         := 2
			::tobj[::curwin]:line               := iif(::bline!=NIL, ::bline, ::tobj[::curwin]:line)
			::tobj[::curwin]:pos                := iif(::bpos!=NIL,  ::bpos,  ::tobj[::curwin]:pos)
			::tobj[::curwin]:rowWin             := iif(::wline!=NIL, ::wline, ::tobj[::curwin]:rowWin)
			::tobj[::curwin]:colWin             := iif(::wpos!=NIL,  ::wpos,  ::tobj[::curwin]:colWin)
			::tobj[::curwin]:marginRight        := ::Opt:OMARGINRIGHT
			::tobj[::curwin]:tabSize            := ::Opt:OTABSIZE
			if ::tobj[::curwin]:loadFile(fd)
				::b_tobj := .t.
				::tobj[::curwin]:pos                := ::tobjinfo[i]:pos
				::tobj[::curwin]:line               := ::tobjinfo[i]:line
				::tobj[::curwin]:colWin             := ::tobjinfo[i]:colwin
				::tobj[::curwin]:rowWin             := ::tobjinfo[i]:rowwin
				::tobj[::curwin]:refresh()
				dispbegin()
				percent := int(::tobj[::curwin]:line*100/::tobj[::curwin]:lines)
				str:=padr("<"+alltrim(str(::tobj[::curwin]:line))+"><"+alltrim(str(::tobj[::curwin]:pos))+"><"+alltrim(str(percent))+"%>", ::tobj[::curwin]:__leninfo, translate_charset( __CHARSET__,host_charset(), substr(B_SINGLE, 6, 1)))
				@ -1, 1 say str color set("edit_colors_window")
				dispend()
			else
				alert([Can't open file;]+fd, "OK")
				asize(::tobj, len(::tobj)-1)
				asize(::tobjinfo, len(::tobj))
				wclose()
			endif
		next
	endif
	if len(::tobj) == 0
		::b_tobj := .f.
		::curwin := 0
	else
		::curwin := oldwin
	endif
	if ::curwin > 0
		dispbegin()
		//wselect(0)
		//::SB:total := ::tobj[::curwin]:lines
		//::SB:current := ::tobj[::curwin]:line
		//::SB:display()
		//wselect(::tobjinfo[::curwin]:curwin)
		devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1,::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
		wselect(::curwin)
		dispend()
	endif
return

**************************
static function me_runme()
local hKey, oldrow, oldcol, oInfo, i, str, k, r, s, change, nchoice:=1, fd
local oldcolor, oldscreen, prevcursor,oldwin, symb, curw, sh, shnum
local __userfunc, status, percent

oldcolor := setcolor()
save screen to oldscreen
prevcursor := setcursor(1)
do while .t.
    hKey := inkey(0, INKEY_ALL)
    if hkey $ ::mapKeys
	hkey := ::mapKeys[hKey]
    endif
    if mLeftDown() .and. (mRow() == ::nBot .or. mRow() == ::nTop)
	hKey := HASH_CallMenu
    endif
    if !::b_tobj .and. (hKey != HASH_CallMenu .and. ;
			hKey != HASH_OpenFile .and. ;
			hKey != HASH_CreateNewFile .and. ;
			hKey != HASH_ExitSave .and. ;
			hKey != HASH_ExitNoSave .and. ;
			hKey != HASH_HelpEdit)
	loop
    endif
    /* run menu */
    if hKey == HASH_CallMenu
	    set( _SET_EVENTMASK, INKEY_ALL )
	    i := setcursor(0)
	    oldrow := row()
	    oldcol := col()
	    wopen(::nTop, ::nLeft, ::nbot, ::nright, .f.)
	    __keyboard(13)
	    ::enableMenu()
	    ::enableBlockMenu()
	    hKey := MenuModal(::oMenu,nchoice,maxrow(),0,maxcol(),"r/w")
	    wclose()
	    wselect(::curwin)
	    setpos(oldrow, oldcol)
	    nchoice := ::oMenu:current
	    setcursor(i)
	    if hKey == -1
		loop
	    endif
    endif

    do case
       case (::single_mode .or. ::double_mode) .and. numAnd(kbdstat(), 0x3)>0 .and. ::tobj[::curwin]:draw(::single_mode, hKey)
	    hKey := 0
       case hKey==K_DOWN
	    ::tobj[::curwin]:down()
       case hKey==K_UP
	    ::tobj[::curwin]:up()
       case hKey==K_LEFT
	    ::tobj[::curwin]:left()
       case hKey==K_RIGHT
	    ::tobj[::curwin]:right()
       case hKey==K_PGDN
	    ::tobj[::curwin]:pageDown()
       case hKey==K_PGUP
	    ::tobj[::curwin]:pageUp()
       case hKey==HASH_TopText
	    ::tobj[::curwin]:Top()
       case hKey==HASH_BottomText
	    ::tobj[::curwin]:Bottom()
       case hKey==K_HOME
	    ::tobj[::curwin]:home()
       case hKey==K_END
	    ::tobj[::curwin]:end()
       case hKey==K_CTRL_LEFT
	    ::tobj[::curwin]:wordLeft()
       case hKey==K_CTRL_RIGHT
	    ::tobj[::curwin]:wordRight()
       /* exit from editor */
       case hKey==HASH_ExitSave .or. hKey==HASH_ExitNoSave
	    k := 0
	    for i=1 to len(::tobj)
		if ::tobj[i] == NIL
			loop
		endif
		wselect(i)
		if ::tobj[i]:updated
			k := alert([File;]+::tobjinfo[i]:name+[;not saved. Save it?],{[Yes],[No],[Cancel] })
			if k==1
				::saveFile()
			elseif k==3 .or. k==0
				exit
			endif
			if empty(::tobjinfo[i]:name) .and. ::tobj[i]:updated
				::__removeWindow(i)
				if i == ::curwin
					::curwin --
				endif
			endif
		endif
		wclose()

	    next
	    ::curwin := max(0, ::curwin)
	    if k!=3 .and. hKey == HASH_ExitSave .and. ::Opt:OSAVESTATUS
		::save_options()
		::writestatus()
	    endif
	    exit
       /* create new window */
       case hKey == HASH_CreateNewFile
	    setcolor(set("edit_colors_window"))
	    ::curwin=wopen(::ntop, ::nleft, ::nbot-1, ::nright)
	    wbox()

	    aadd(::tobjinfo, map())
	    i := len(::tobjinfo)
	    ::tobjinfo[i]:name := ""
	    ::tobjinfo[i]:readOnly := .f.
	    ::tobjinfo[i]:share := .f.
	    ::tobjinfo[i]:curwin := ::curwin //number Window
	    ::drawhead()

	    aadd(::tobj, textEditNew(0, 0, maxrow(), maxcol(),set("edit_colors_edit")))
	    ::tobj[::curwin]:modeFormat             := 2
	    ::tobj[::curwin]:line                   := iif(::bline!=NIL, ::bline, ::tobj[::curwin]:line)
	    ::tobj[::curwin]:pos                    := iif(::bpos!=NIL,  ::bpos,  ::tobj[::curwin]:pos)
	    ::tobj[::curwin]:rowWin                 := iif(::wline!=NIL, ::wline, ::tobj[::curwin]:rowWin)
	    ::tobj[::curwin]:colWin                 := iif(::wpos!=NIL,  ::wpos,  ::tobj[::curwin]:colWin)
	    ::tobj[::curwin]:marginRight            := ::Opt:OMARGINRIGHT
	    ::tobj[::curwin]:tabSize                := ::Opt:OTABSIZE
	    ::tobj[::curwin]:loadString("")
	    ::b_tobj := .t.
       /* open window */
       case hKey == HASH_OpenFile
	    fd=filedialog("", "*", ::FileD)
	    sh := ::check_share(fd, @shnum)
	    if sh < 2
		loop
	    endif
	    if !empty(fd)
		setcolor(set("edit_colors_window"))
		oldwin := wnum()
		::curwin := wopen(::ntop, ::nleft, ::nbot-1, ::nright)
		wbox()
		aadd(::tobjinfo, map())
		//i := len(::tobjinfo)
		::tobjinfo[::curwin]:name := fd
		::tobjinfo[::curwin]:readOnly := .f.
		::tobjinfo[::curwin]:share := .f.
		::tobjinfo[::curwin]:curwin := ::curwin //number Window

		aadd(::tobj, textEditNew(0, 0, maxrow(), maxcol(),set("edit_colors_edit")))
		::tobj[::curwin]:modeFormat         := 2
		::tobj[::curwin]:line               := iif(::bline!=NIL, ::bline, ::tobj[::curwin]:line)
		::tobj[::curwin]:pos                := iif(::bpos!=NIL,  ::bpos,  ::tobj[::curwin]:pos)
		::tobj[::curwin]:rowWin             := iif(::wline!=NIL, ::wline, ::tobj[::curwin]:rowWin)
		::tobj[::curwin]:colWin             := iif(::wpos!=NIL,  ::wpos,  ::tobj[::curwin]:colWin)
		::tobj[::curwin]:marginRight        := ::Opt:OMARGINRIGHT
		::tobj[::curwin]:tabSize            := ::Opt:OTABSIZE
		if sh == 2
			::drawhead()
			if ::tobj[::curwin]:loadFile(fd)
				::b_tobj := .t.
			else
				alert([Can't open file;]+fd, "OK")
				asize(::tobj, len(::tobj)-1)
				asize(::tobjinfo, len(::tobj))
				wclose()
				::curwin := oldwin
				wselect(::curwin)
			endif
		else
			::tobjinfo[::curwin]:share := .t.
			::tobjinfo[shnum]:share := .t.
			::drawhead()
			::tobj[::curwin]:nullInit()
			::tobj[::curwin]:edbuffer := ::tobj[shnum]:edbuffer
			::tobj[::curwin]:lines := len(::tobj[::curwin]:edbuffer)
		endif
	    endif
       case hKey == HASH_HelpEdit
	   ::helpEdit()
       /* save file */
       case hKey == HASH_SaveFile
	   ::saveFile()
       /* save file as... */
       case hKey == HASH_SaveAsFile
	   ::saveFile(.t.)
       /* find word */
       case hKey == HASH_FindString
	   k := ::tobj[::curwin]:curWord()
	   ::Find:fstring := iif (empty(k), ::Find:fhistory:first(), k)
	   ::Find:replace := .f.
	   r := ::Find:get()
	   if ::Find:direct == 3
		::tobj[::curwin]:line := 1
		::tobj[::curwin]:pos := 1
	   endif
	   if ::Find:allw
		curw := ::curwin
		if !::tobj[::curwin]:find(::Find)
			do while .t.
				::curwin ++
				if ::curwin > len(::tobj)
					::curwin := 1
				endif
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
       /* find word and replace */
       case hKey == HASH_FindReplace
	   k := ::tobj[::curwin]:curWord()
	   ::Find:fstring := iif(empty(k), ::Find:fhistory:first(), k)
	   ::Find:rstring := ::Find:rhistory:first()
	   ::Find:replace := .t.
	   ::Find:get()
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
				::curwin ++
				i++
				if ::curwin > len(::tobj)
					::curwin := 1
				endif
				wselect(::tobjinfo[::curwin]:curwin)
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
       /* find next template to backward */
       case hKey == HASH_FindPrev
	   if empty(::Find:fstring)
		alert([Nothing to find!!!], "OK")
	   else
		if ::Find:allw
			curw := ::curwin
			if !::tobj[::curwin]:findPrev(::Find)
				do while .t.
					::curwin ++
					if ::curwin > len(::tobj)
						::curwin := 1
					endif
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
       /* find next template to forward */
       case hKey == HASH_FindNext
	   if empty(::Find:fstring)
		alert([Nothing to find!!!], "OK")
	   else
		if ::Find:allw
			curw := ::curwin
			if !::tobj[::curwin]:findNext(::Find)
				do while .t.
					::curwin ++
					if ::curwin > len(::tobj)
						::curwin := 1
					endif
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
       /* reload file */
       case hKey == HASH_Reload
	    if ::tobj[::curwin]:updated
		if alert([There is a change in the file.;]+::tobjinfo[::curwin]:name+[; Reload?], {[Yes], [No]}, set("edit_colors_menu")) == 1
			k := ::tobj[::curwin]:loadFile(::tobjinfo[::curwin]:name)
		endif
	    else
		k := ::tobj[::curwin]:loadFile(::tobjinfo[::curwin]:name)
	    endif
	    if !k
		alert([Can't open file;]+::tobjinfo[::curwin]:name, "OK")
	    endif
       /* next window */
       case hKey == HASH_NextWindow
	    do while .t.
		::curwin ++
		if ::curwin > len(::tobj)
			::curwin := 1
		endif
		if ::tobj[::curwin] != NIL
			exit
		endif
	    enddo
	    wselect(::tobjinfo[::curwin]:curwin)
	    if ::tobjinfo[::curwin]:share
		::tobj[::curwin]:lines := len(::tobj[::curwin]:edbuffer)
		::tobj[::curwin]:refresh()
	    endif
	    ::drawhead()
	    devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1, ::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
       /* prev window */
       case hKey == HASH_PrevWindow
	    do while .t.
		::curwin --
		if ::curwin == 0
			::curwin := len(::tobj)
		endif
		if ::tobj[::curwin] != NIL
			exit
		endif
	    enddo
	    wselect(::tobjinfo[::curwin]:curwin)
	    if ::tobjinfo[::curwin]:share
		::tobj[::curwin]:lines := len(::tobj[::curwin]:edbuffer)
		::tobj[::curwin]:refresh()
	    endif
	    ::drawhead()
	    devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1, ::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
       /* on/off insert mode */
       case (hKey == K_INS .or. hKey == HASH_InsMode) .and. !::tobjinfo[::curwin]:readOnly
	    set( _SET_INSERT, !Set(_SET_INSERT) )
	    ::oMenu:_status("CHECKED", HASH_InsMode, set(_SET_INSERT))
	    ::drawhead()
       /* match forward symbol */
       case hKey == HASH_MatchSymbolForward
	    if !::tobj[::curwin]:Identity(@symb)
		alert([Symbol ']+symb+[' not found!], "OK")
	    endif
       /* match backward symbol */
       case hKey == HASH_MatchSymbolBackward
	    if !::tobj[::curwin]:Identity(@symb, .f.)
		alert([Symbol ']+symb+[' not found!], "OK")
	    endif
       /* match forward structure */
       case hKey == HASH_MatchStructForward
	    symb := ::tobj[::curwin]:curword()
	    if !::tobj[::curwin]:matchStruct(symb, .t.)
		alert([Structure not found!], "OK")
	    endif
       /* match backward structure */
       case hKey == HASH_MatchStructBackward
	    symb := ::tobj[::curwin]:curword()
	    if !::tobj[::curwin]:matchStruct(symb, .f.)
		alert([Structure not found!], "OK")
	    endif
       /* copy block to Clipboard */
       case hKey==HASH_CopyClipboard
	    ::tobj[::curwin]:newClipboard(::Clipboard)
       /* save block to file */
       case hKey==HASH_SaveBlock
	    if !::tobj[::curwin]:strblock .and. !::tobj[::curwin]:rectblock
		alert([Block not marked!], "OK")
	    else
		fd=filedialog("", "*", ::FileD)
		r := file(fd)
		if r
			s:=alert([File;]+fd+[;already exists. Overwrite it?], {[Yes], [No]}, set("edit_colors_menu"))
		endif
		if !r .or. r .and. s == 1
			::tobj[::curwin]:saveBlock(fd, ::Opt:OCREATEBAK)
		endif
	    endif
       /* read only options on/off */
       case hKey == HASH_ReadOnly
	    ::tobjinfo[::curwin]:readOnly := !::tobjinfo[::curwin]:readOnly
	    ::drawhead()
       /* list opening files */
       case hKey == HASH_ListFiles
	    k := int(3*maxcol()/4)
	    r := int(3*maxrow()/4)
	    s := setcolor(set("edit_colors_menu"))
	    wopen(int((maxrow()-r)/2), int((maxcol()-k)/2), int((maxrow()-r)/2)+r, int((maxcol()-k)/2)+k)
	    wbox()
	    @ -1, (k-len([ Windows list ]))/2 say [ Windows list ]
	    ::curwin := ::listfiles()
	    wclose()
	    setcolor(s)
	    if len(::tobj) == 0
		::b_tobj := .f.
		::curwin := 0
	    else
		wselect(::tobjinfo[::curwin]:curwin)
		if ::tobjinfo[::curwin]:share
			::tobj[::curwin]:lines := len(::tobj[::curwin]:edbuffer)
			::tobj[::curwin]:refresh()
		endif
		devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1,::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
	    endif
       /* close current window */
       case hKey == HASH_CloseWindow
	    if ::tobj[::curwin]:updated
		i := alert([File;]+::tobjinfo[i]:name+[;not saved. Save it?],{[Yes],[No],[Cancel]})
		if i==0 .or. i==3
			loop
		elseif i==1
			::saveFile()
		endif
	    endif

	   wclose()
	   ::__removeWindow()
	   ::curwin --
	   do while len(::tobj)>0
		  if ::curwin==0
			  ::curwin := len(::tobj)
		  endif
		  if ::tobj[::curwin]!=NIL
			  exit
		  endif
		  ::curwin --
	   enddo

	   if len(::tobj) == 0
		  ::b_tobj := .f.
		  ::curwin := 0
	   endif
       /* edit options */
       case hKey == HASH_Options
	   i := setcursor()
	   ::editopt()
	   setcursor(i)
       /* change code page */
       case hKey == HASH_ChooseCodePage
	   ::chooseCodePage()
       /* goto line/pos */
       case hKey == HASH_GoTo
	    //::tobj[::curwin]:setNumstyle()
	    ::goto()
       /* save current line */
       case hKey == HASH_SavePos
	    ::goHist:insert(alltrim(toString(::tobj[::curwin]:line)))
       /* mark string block */
       case hKey == HASH_MarkBlockString
	    if ::tobj[::curwin]:mkblock
		::tobj[::curwin]:endBlock(.t.)    // start str block
	    else
		::tobj[::curwin]:beginBlock(.t.)  // stop str block
	    endif
       /* mark rectangle block */
       case hKey == HASH_MarkBlockRect
	    if ::tobj[::curwin]:mkblock
		::tobj[::curwin]:endBlock(.f.)    // start rect block
	    else
		::tobj[::curwin]:beginBlock(.f.)  // stop rect block
	    endif
       /* cancel block */
       case hKey == HASH_CancelBlock
	    ::tobj[::curwin]:cancelBlock()
       /* print text */
       case hKey == HASH_Print
	    ::tobj[::curwin]:print()
       /* print block */
       case hKey == HASH_PrintBlock
	    if !(::tobj[::curwin]:printBlock())
		alert([Block not marked!], "OK")
	    endif
       /* run undo */
       case hKey == HASH_Undo
	    ::tobj[::curwin]:undo()
       otherwise
	       if !::tobjinfo[::curwin]:readOnly .and. !::editKeys(hKey) .and. !empty(::userfunc)
		   status:=0
		   __userfunc:=::userfunc+"("+alltrim(str(status))+","+alltrim(str(::tobj[::curwin]:line))+","+alltrim(str(::tobj[::curwin]:pos))+",::tobj[::curwin])"
	       endif
       endcase
       if len(::tobj) == 0
		::b_tobj := .f.
       endif
       if ::curwin > 0

		dispbegin()
		percent := int(min(::tobj[::curwin]:line*100/::tobj[::curwin]:lines, 100))
		str:= replicate( translate_charset( __CHARSET__,host_charset(), substr(B_SINGLE, 6, 1)), ::tobj[::curwin]:__leninfo)
		@ -1, 1 say str color set("edit_colors_window")
		//str:=padr("<"+alltrim(str(::tobj[::curwin]:line))+"><"+alltrim(str(::tobj[::curwin]:pos))+"><"+alltrim(str(percent))+"%>"+iif(::tobj[::curwin]:updated, "*", ""), ::tobj[::curwin]:__leninfo, translate_charset( __CHARSET__,host_charset(), substr(B_SINGLE, 6, 1)))
		str:="<"+alltrim(str(::tobj[::curwin]:line))+"><"+alltrim(str(::tobj[::curwin]:pos))+"><"+alltrim(str(percent))+"%>"+iif(::tobj[::curwin]:updated, "*", "")
		@ -1, 1 say str color set("edit_colors_window")
		//wselect(0)
		//::SB:total := ::tobj[::curwin]:lines
		//::SB:current := ::tobj[::curwin]:line
		//::SB:display()
		//wselect(::tobjinfo[::curwin]:curwin)
		devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1,::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
		dispend()

       else
		//@ ::nTop, ::nLeft clear to ::nBot, ::nRight
       endif

enddo

setcolor(oldcolor)
restore screen from oldscreen
setcursor(prevcursor)
return

************************************
static function me_editKeys(hKey)
local ret:=.t., fd, r, obj, dm
    obj := ::tobj[::curwin]
    do case
       /* new line */
       case hKey==K_ENTER
	    if ( Set(_SET_INSERT) )
		obj:insertLine(, ::autoIndent)
	    else
		obj:newLine(, ::autoIndent)
	    endif
       /* delete current symbol */
       case hKey==K_DEL
	    obj:delRight()
       /* delete string from current pos to end */
       case hKey==HASH_DeleteEnd
	    obj:delEnd()
       /* delete syblol brom left */
       case hKey==K_BS
	    obj:backSpace()
       /* delete string from current pos to begin */
       case hKey==HASH_DeleteBack
	    obj:delHome()
       /* delete current line */
       case hKey == HASH_DeleteLine
	    obj:deleteLine()
       /* move string to the center */
       case hKey==HASH_MoveCenter
	    obj:centerLine()
       /* copy block */
       case hKey == HASH_CopyBlock
	    obj:copyBlock()
       /* move block */
       case hKey == HASH_MoveBlock
	    obj:moveBlock()
       /* remove block */
       case hKey == HASH_DeleteBlock
	    obj:deleteBlock()
       /* paste block from Clipboard */
       case hKey==HASH_PasteClipboard
	    obj:pasteClipboard(::Clipboard)
       /* load block from file */
       case hKey == HASH_LoadBlock
	    fd=filedialog("", "*", ::FileD)
	    r := file(fd)
	    if !r
		alert([File;]+fd+[;not found!],"OK", set("edit_colors_menu"))
	    else
		if !obj:loadBlock(fd)
			alert([Can't open file;]+fd, "OK")
		endif
	    endif
       /* insert template */
       case hKey == HASH_Template
	   obj:insTempl(::templ)
       /* insert macro */
       case hKey == HASH_Macro
	   obj:insMacro(::tempmacro)
       /* format line */
       case hKey == HASH_FormatLine
	    obj:formatLine(::Opt)
       /* format part */
       case hKey == HASH_FormatPart
	    obj:formatPart(::Opt)
       /* on/off single graphic mode */
       case hKey == HASH_SingleGraphic
	    ::double_mode := .f.
	    ::single_mode := !::single_mode
	    if ::single_mode
		setcursor(2)
		::stline := [ESC - menu          <SINGLE GRAPHIC>]
	    else
		setcursor(1)
		::stline := [ESC - menu ]
	    endif
	    dispbegin()
	    wselect(0)
	    ::oMenu:_status("CHECKED", HASH_SingleGraphic, ::single_mode)
	    @ ::nBot, ::nLeft say padr(::stline, ::nRight-::nLeft+1) color "0/w"
	    wselect(::tobjinfo[::curwin]:curwin)
	    devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1,::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
	    dispend()
       /* on/off double graphic mode */
       case hKey == HASH_DoubleGraphic
	    ::double_mode := !::double_mode
	    ::single_mode := .f.
	    if ::double_mode
		setcursor(2)
		::stline := [ESC - menu           <DOUBLE GRAPHIC>]
	    else
		setcursor(1)
		::stline := [ESC - menu ]
	    endif
	    dispbegin()
	    wselect(0)
	    ::oMenu:_status("CHECKED", HASH_DoubleGraphic, ::double_mode)
	    @ ::nBot, ::nLeft say padr(::stline, ::nRight-::nLeft+1) color "0/w"
	    wselect(::tobjinfo[::curwin]:curwin)
	    devpos(::tobj[::curwin]:nTop+::tobj[::curwin]:rowWin-1,::tobj[::curwin]:nLeft+::tobj[::curwin]:colWin-1)
	    dispend()
       otherwise
	 if (hKey>=32 .and. hKey<=256) .or. hKey==K_TAB
	    if ( Set(_SET_INSERT) )
	       obj:insert(chr(hKey))
	    else
	       obj:overStrike(chr(hKey))
	    endif
	 else
	    ret:=.f.
	 endif
    endcase
return ret
************************************

static function me_drawhead()
local nwin, l_nwin, ro, name, sh
	ro := ::tobjinfo[::curwin]:readOnly
	sh := ::tobjinfo[::curwin]:share
	name := ::tobjinfo[::curwin]:name
	nwin := iif(ro, [<R>], iif(sh, [<Link>], "")+"<"+iif(Set(_SET_INSERT), [I], [O])+">")+"["+alltrim(str(::curwin))+"]"
	l_nwin := len(nwin)
	@ -1, maxcol()-l_nwin say nwin color set("edit_colors_window")
	if !empty(name)
		@ -1, maxcol()-maxcol()*3/4 say alltrim(padl(name, maxcol()*3/4 - l_nwin)) color set("edit_colors_window")
	endif
return
**************************************

static function me_saveFile(asFile)
local fd, f, al:=0, crbak
   crbak := ::Opt:OCREATEBAK
   asFile := iif(asFile==NIL, .f., asFile)
   if empty(::tobjinfo[::curwin]:name) .or. asFile
	fd=filedialog("", "*", ::FileD)
	f := file(fd)
	if f
		al:=alert([File;]+fd+[;already exists. Overwrite it?], {[Yes], [No]}, set("edit_colors_menu"))
	endif
	if al == 3
		return .f.
	endif
	if !f .or. f .and. al == 1
		::tobjinfo[::curwin]:name := fd
		::tobj[::curwin]:saveFile(fd, crbak)
		::drawhead()
	endif
   else
	fd := ::tobjinfo[::curwin]:name
	::tobj[::curwin]:saveFile(fd, crbak)
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
      oTopBar:AddItem( MenuItem ( [&File],oPopUp) )

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
      oTopBar:AddItem( MenuItem ( [&Window],oPopUp) )

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
      oTopBar:AddItem( MenuItem ( [&Block],oPopUp) )

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
      oTopBar:AddItem( MenuItem ( [&Service],oPopUp) )

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

      kn:=key_name(HK_get_key(keys,HASH_FormatLine))
      oItem :=MenuItem( [Format &line    ]+kn ,{|| .t. },,[Format line], HASH_FormatLine)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_FormatPart))
      oItem :=MenuItem( [Format &part    ]+kn ,{|| .t. },,[Format part], HASH_FormatPart)
      oPopUp:AddItem( oItem)

**************************************************************************

      oPopUp := PopUp()
      oPopUp :ColorSpec:= set("edit_colors_menu")
      oTopBar:AddItem( MenuItem ( [O&therwise],oPopUp) )

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

   return ( oTopBar)

**********************************************************
static function me_listfiles()
local sv, fd, i, retvalue, scr, nKey:=1, listobj, length, cur


length := maxcol() - 1 //right - left
//save screen to scr

//set color to set("edit_colors_dialog")
//clear screen

retvalue := ::curwin
//listobj := listitemnew(top-1, left-1, bottom+1, right+1, 1, , set("edit_colors_list"))
listobj := listitemnew(0, 0, maxrow()+1, maxcol()+1, 1, , set("edit_colors_list"))
listobj:clear()
for i=1 to len(::tobjinfo)
	if ::tobjinfo[i] == NIL
		loop
	endif
	listobj:addItem(padr(alltrim(str(::tobjinfo[i]:curwin))+iif(::tobjinfo[i]:readOnly, [R:], " : ")+::tobjinfo[i]:name, length))
	if ::tobjinfo[i]:curwin == retvalue
		cur := i
	endif
next
listobj:setfocus()
listobj:setItem(cur)

do while nkey!=0
	nkey := Inkey(0)
	do case
		case nkey == K_UP
			listobj:up()
		case nkey == K_DOWN
			listobj:down()
		case nkey == K_HOME
			listobj:home()
		case nkey == K_END
			listobj:end()
		case nkey == K_PGUP
			listobj:pageup()
		case nkey == K_PGDN
			listobj:pagedown()
		case nkey == K_DEL
			if len(::tobj)>0 .and. ::tobj[listobj:buffer]:updated
				sv := alert(::tobjinfo[listobj:buffer]:name+[; not saved. Save?], {[Yes], [No], [Cancel]}, set("edit_colors_menu") )
				if sv == 1
				    if empty(::tobjinfo[listobj:buffer]:name)
					fd=filedialog("", "*", ::FileD)
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
			cur := &(substr(listobj:getItem(), 1, 2))
			wclose(cur)
			adel(::tobj, listobj:buffer)
			asize(::tobj, len(::tobj)-1)
			adel(::tobjinfo, listobj:buffer)
			asize(::tobjinfo, len(::tobjinfo)-1)
			listobj:delItem(listobj:buffer)
		case nkey == K_ESC
			nkey := 0
		case nkey == K_ENTER
			retvalue := &(substr(listobj:getItem(), 1, 2))
			nkey := 0
		otherwise
		    if nkey>=32 .and. nkey<=256
			listobj:find(chr(nkey))
			devpos(listobj:line, listobj:row)
		    endif
	endcase
enddo
//restore screen from scr
return retvalue

*************************************************************
static function me_editopt()
local get_color, color, dl, fl, r, k, getlist:={}, fullScr := .t.
local cbak, tab, asave, tsave, lang, ssave, hyp, autom, mleft, mright, aindent

//s := setcolor(set("edit_colors_menu"))
k := int(2*maxcol()/3)
r := int(2*maxrow()/3)
get_color := "0/7, 14/1, 11/1, 0/7, 0/7, 0/7"
color := setcolor()
setcolor(set("edit_colors_dialog"))
fl := 20
dl := fl+6
/* get locales */

dispbegin()
wopen(int((maxrow(fullScr)-r)/2), int((maxcol(fullScr)-k)/2), int((maxrow(fullScr)-r)/2)+10, int((maxcol(fullScr)-k)/2)+2*fl+15)
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
mleft := ::Opt:OMARGINLEFT
mright := ::Opt:OMARGINRIGHT
aindent := ::Opt:OAUTOINDENT

@ -1, (maxcol(fullScr)-len([ Options ]))/2 say [ Options ]
@ 1, 1 say padr([Create .bak files], fl) //color say_color
@ 1, fl+2 get cbak CHECKBOX color get_color
@ 2, 1 say padr([Tabulation size], fl)
@ 2, fl get tab picture "9999"  color get_color
@ 3, 1 say replicate("_", maxcol(fullScr)-2)
@ 4, 1 say padr([Autosave files], fl)
@ 4, fl+2 get asave CHECKBOX  color get_color
@ 5, 1 say padr([Autosave time], fl)
@ 5, fl get tsave picture "9999" color get_color
@ 6, 1 say replicate("_", maxcol(fullScr)-2)
//@ 7, 1 say padr([Language], fl)
//@ 7, fl get lang  picture "@KS10A" color get_color
//@ 7, 1 say padr("Length string", fl)
//@ 7, fl get Opt:OLENGTH picture "9999"  color get_color
@ 8, 1 say padr([Save status], fl)
@ 8, fl+2 get ssave CHECKBOX color get_color
@ 1, dl say padr([Hypen in word], fl)
@ 1, dl+fl+3 get hyp  CHECKBOX color get_color
@ 2, dl say padr([Auto margin left], fl)
@ 2, dl+fl+3 get autom  CHECKBOX color get_color
@ 4, dl say padr([Margin left], fl)
@ 4, dl+fl+3 get mleft  picture "9999" color get_color
@ 5, dl say padr([Margin right], fl)
@ 5, dl+fl+3 get mright  picture "9999" color get_color
@ 7, dl say padr("Auto indent", fl)
@ 7, dl+fl+3 get aindent CHECKBOX color get_color
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
::Opt:OMARGINLEFT   := mleft
::Opt:OMARGINRIGHT  := mright
::Opt:OAUTOINDENT   := aindent

::autoIndent   := aindent

putenv("LANG="+alltrim(lang))

wclose()
setcolor(color)

return

static function msg(mess, Opt)
return mess[Opt:OLANGUAGE]

*************************************
static function me_set_options()
local str, arr, i, nfile
memvar obj, options
private obj, Options
	Options:=map()
	Options:OTABSIZE := TE_TABSIZE
	Options:OAUTOSAVE := TE_AUTO_SAVE
	Options:OTIMEAUTOSAVE := TE_TIME_AUTO_SAVE
	Options:OCREATEBAK := TE_CREATE_BAK
	Options:OMARGINLEFT := TE_MARGIN_LEFT
	Options:OMARGINRIGHT := TE_MARGIN_RIGHT
	Options:OSAVESTATUS := TE_SAVE_STATUS
	Options:OLANGUAGE := TE_LANGUAGE
	Options:OSTEPUNDO := TE_STEP_UNDO
	Options:OHISTORY := TE_HISTORY_SIZE
	Options:OAUTOMARGIN := TE_AUTO_MARGIN
	Options:OHYPHEN := TE_HYPHEN
	Options:OAUTOINDENT := TE_AUTO_INDENT
	nfile := fopen(::fileOpt)
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
	::Opt := Options
return
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
	if !File(::fileStatus)
		return
	endif
	nfile := fopen(::fileStatus)
	str := fget(nfile, buflen)
	::curwin := str2var(str)
	? 'get curwin'
	str := fget(nfile, buflen)
	::FileD:set(str2var(str))
	? 'get fileD'
	str := fget(nfile, buflen)
	::Find:sethistfind(str2var(str))
	? 'get Find'
	str := fget(nfile, buflen)
	::Find:sethistrepl(str2var(str))
	? 'get Find repl'
	str := fget(nfile, buflen)
	::tobjinfo := str2var(str)
	? 'get info'
	fclose(nfile)

return

***************************
static function me_save_options()
local nfile, str
	dirmake(::dirEdit)
	nfile := fcreate(::dirEdit+"/.edit")

	str := "Options := "+varToString(::Opt)+"&\n"
	fwrite(nfile, str, len(str))
	fclose(nfile)
return
***************************
static function me_writestatus()
local str:="", nfile:="", buflen:=1024, i, _e:="&\n"
private len

	nfile := fcreate(::fileStatus)
	str := var2str(::curwin)+_e
	fwrite(nfile, str, len(str))
	str := var2str(::FileD:history)+_e
	fwrite(nfile, str, len(str))
	str := var2str(::Find:fhistory:history)+_e
	fwrite(nfile, str, len(str))
	str := var2str(::Find:rhistory:history)+_e
	fwrite(nfile, str, len(str))
	for i := 1 to len(::tobjinfo)
		::tobjinfo[i]:pos := ::tobj[i]:pos
		::tobjinfo[i]:line := ::tobj[i]:line
		::tobjinfo[i]:colwin := ::tobj[i]:colWin
		::tobjinfo[i]:rowwin := ::tobj[i]:rowWin
	next
	str := var2str(::tobjinfo)
	fwrite(nfile, str, len(str))
	fclose(nfile)
return
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
::GoHist:Lrow := top + 2
::GoHist:Lcol := left +len(str) +2
::GoHist:Rrow := top + 7
::GoHist:Rcol := right - 2

getstr := padl(val(::GoHist:first()), 8)

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
		newline := ::GoHist:run()
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
	::GoHist:insert(newline)
	if !::tobj[::curwin]:gotoLine(val(newline), .t.)
		alert([Bad line number!], "OK")
		::GoHist:delete(newline)
	endif
endif

return newline
********************************
static function me_check_share(fd, num)
local ret:=2, i, f:= .f.
	for i:= 1 to len(::tobjinfo)
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
local f:=getenv("CLIPROOT")
	if empty(f)
		f:=CLIPROOT()
	endif
	f="file:"+f+PATH_DELIM+"doc/edit.html" //+iif(!empty(cont),"#"+cont,"")
	hbrowse(,,,,f)
return
************************************
static function me_chooseCodePage()
local pathCP:=getenv("CLIPROOT"), a, b, lo, nkey:=-1, str
local i,k, r, nLeft, nRight, nTop, nBottom, cntc:=4, colors, item, oldcolor, scr
	if empty(pathCP)
		pathCP := CLIPROOT()
	endif
	pathCP += "/charsets"
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
	colors := "0/3,0/2,15/3,0/3,0/2,15/2,15/2"
	oldcolor := setcolor(colors)
	scr := savescreen()
	str := [ Source charset ]
	@ nTop-1, nLeft-1 TO nBottom, nRight
	@ nTop-1, nLeft+(nRight-nLeft-len(str))/2 say str
	lo := listitemnew(nTop, nLeft, nBottom, nRight, cntc, substr(B_SINGLE, 4, 1), colors)
	for i in b
		lo:addItem(i)
	next
	lo:setFocus()
	lo:refresh()
	do while nkey!=0
		nkey := Inkey(0)
		switch(nkey)
		case K_LEFT
			lo:left()
		case K_RIGHT
			lo:right()
		case K_UP
			lo:up()
		case K_DOWN
			lo:down()
		case K_HOME
			lo:home()
		case K_END
			lo:end()
		case K_PGUP
			lo:pageup()
		case K_PGDN
			lo:pagedown()
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
	restscreen(scr)
	if item == NIL
		return
	endif
	::tobj[::curwin]:charset := item
	for i=1 to ::tobj[::curwin]:lines
		::tobj[::curwin]:edbuffer[i] := translate_charset(::tobj[::curwin]:charset, ::tobj[::curwin]:hostcharset, ::tobj[::curwin]:edbuffer[i])
	next
	::tobj[::curwin]:refresh()
	setcolor(oldcolor)
return
************************************
static function me_changeCharset(nWin, charSet)
local pathCP:=getenv("CLIPROOT")
	if nWin==NIL .or. !between(nWin, 1, len(::tobj))
		return .f.
	endif
	if empty(pathCP)
		pathCP := CLIPROOT()
	endif
	pathCP += "/charsets"
	if charSet == NIL .or. !file(pathCP+"/"+charSet)
		return .f.
	endif
	::tobj[nWin]:setCharset(charSet)
return .t.
*********************
static function me___removeWindow(nWin)
   nWin := iif(nWin == NIL, ::curwin, nWin)
   adel(::tobj, nWin)
   asize(::tobj, len(::tobj)-1)
   adel(::tobjinfo, ::curwin)
   asize(::tobjinfo, len(::tobjinfo)-1)
return
*********************
static function me_setReadOnly(nWin, flag)
local i
	flag := iif(valtype(flag)!="L", .t., flag)
	if valtype(nWin) == "N" .and. between(nWin, 1, len(::tobjinfo))
		::tobjinfo[nWin]:readOnly := flag
		return
	endif

	for i=1 to len(::tobjinfo)
		::tobjinfo[i]:readOnly := flag
	next
return
*********************
static function me_getReadOnly(nWin)
	if valtype(nWin) == "N" .and. between(nWin, 1, len(::tobjinfo))
		return ::tobjinfo[nWin]:readOnly
	endif
return .f.
*********************
static function me_enableMenu()
local enable := ::b_tobj
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
return
*********************
static function me_enableBlockMenu()
local enable := iif(::b_tobj,::tobj[::curwin]:strblock .or. ::tobj[::curwin]:rectblock,.f.)
	::oMenu:enableStatus(HASH_MarkBlockString, enable)
	::oMenu:enableStatus(HASH_MarkBlockRect  , enable)
	::oMenu:enableStatus(HASH_CancelBlock    , enable)
	::oMenu:enableStatus(HASH_CopyBlock      , enable)
	::oMenu:enableStatus(HASH_MoveBlock      , enable)
	::oMenu:enableStatus(HASH_DeleteBlock    , enable)
	::oMenu:enableStatus(HASH_CopyClipboard  , enable)
	::oMenu:enableStatus(HASH_PasteClipboard , enable)
	::oMenu:enableStatus(HASH_SaveBlock      , enable)
	::oMenu:enableStatus(HASH_LoadBlock      , enable)
	::oMenu:enableStatus(HASH_PrintBlock     , enable)
return

