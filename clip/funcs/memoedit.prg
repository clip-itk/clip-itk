/*
    Copyright (C) 2001  ITK
    Author   : Alena (alena@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "edit.ch"
#include "memoedit.ch"


function memoedit(str, ntop, nleft, nbot, nright, mode, user_func,;
		  str_len, tab_size, bline, bpos, wline, wpos)

	local tobj,i,nkey,oldcolor:=setcolor(), status
	local user_ret,row,col

	if !(valtype(str) $ "CM")
		str=""
	endif

	ntop=iif(ntop==NIL,0,min(ntop, maxrow()))
	nbot=iif(nbot==NIL,maxrow(),min(nbot, maxrow()))
	nleft=iif(nleft==NIL,0,min(nleft, maxcol()))
	nright=iif(nright==NIL,maxcol(),min(nright, maxcol()))
	str_len=iif(str_len==NIL, TE_MAX_LEN_STRING, str_len)
	tab_size=iif(tab_size==NIL, TE_TABSIZE, tab_size)
	bline=iif(bline==NIL,1,bline)
	bpos=iif(bpos==NIL,1,bpos)
	wline=iif(wline==NIL,1,wline)
	wpos=iif(wpos==NIL,1,wpos)
	mode=iif(mode==NIL,.t.,mode)

	tobj=textEditNew(ntop,nleft,nbot,nright,setcolor())

	tobj:modeFormat := 2
	tobj:line   := iif(bline!=NIL, bline, tobj:line)
	tobj:pos    := iif(bpos!=NIL,  bpos,  tobj:pos)
	tobj:rowWin := iif(wline!=NIL, wline, tobj:rowWin)
	tobj:colWin := iif(wpos!=NIL,  wpos,  tobj:colWin)
	tobj:marginRight := str_len
	tobj:autoWrap := .t.
	tobj:tabSize:= iif(tab_size!=NIL,tab_size,tobj:tabSizw)
	tobj:idletime:=60
	tobj:loadString(@str)

	if !empty( user_func ) .and. valtype( user_func ) == "C"
		user_ret := 1
		while   user_ret # 0
			row := row(); col:=col()
			user_ret:=clip(user_func, ME_INIT, tobj:line, tobj:pos-1, tobj, nil)
			setpos(row,col)
			user_action(tobj, user_ret, mode)
		enddo
	else
		user_func := NIL
	endif

	ShowScoreboard()

	while .t.
		if nextkey() = 0
			if !empty( user_func )
				row := row(); col:=col()
				user_ret := clip(user_func, ME_IDLE, tobj:line , tobj:pos-1, tobj, nil)
				setpos(row,col)
				user_ret:=user_action(tobj, user_ret, mode)
				if user_ret
					exit
				endif
			endif
		endif
		if (nKey:=inkey(tobj:idletime)) == 0
			loop
		endif
		if setkey(nKey)!=NIL
			eval(setkey(nKey),procname(),procline(),readvar())
			loop
		endif
		if empty(user_func)
		    if ! viewKeys(nKey,tobj,@user_ret) .and. mode
			editKeys(nKey,tobj,@user_ret)
		    endif
		else
		    tobj:cargo:=NIL
		    /* comment - if !empty(user_func) --> simple chars not writen*/
		    /* => status will be = ME_IDLE */
		    /* status:=ME_IDLE */
		      /* uncomment for Bondar */
		    status:=if(tobj:updated, ME_UNKEYX, ME_UNKEY)
		    row := row(); col:=col()
		    status:=clip(user_func, status, tobj:line , tobj:pos-1, tobj)
		    setpos(row,col)
		    if tobj:cargo<>NIL
			nkey:=tobj:cargo
		    endif
		    user_ret:=user_action(tobj, status, mode, nkey)
		endif
		if valtype(user_ret)=='C'
			str:=user_ret
			user_ret:=.t.
		endif
		if user_ret
			exit
		endif
	enddo
	setcolor(oldcolor)
return str

********************************************************
function viewFile(fName, ntop, nleft, nbot, nright, mode, user_func,;
		  str_len, tab_size, bline, bpos, wline, wpos)

	local tobj,i,nkey,oldcolor:=setcolor(),scr:=savescreen(), lExit

	if !(valtype(fName) $ "CM")
		return .f.
	endif

	setcolor("0/7")

	ntop=iif(ntop==NIL,0,min(ntop, maxrow()))
	nbot=iif(nbot==NIL,maxrow(),min(nbot, maxrow()))
	nleft=iif(nleft==NIL,0,min(nleft, maxcol()))
	nright=iif(nright==NIL,maxcol(),min(nright, maxcol()))
	str_len=iif(str_len==NIL, TE_MAX_LEN_STRING, str_len)
	tab_size=iif(tab_size==NIL, TE_TABSIZE, tab_size)
	bline=iif(bline==NIL,1,bline)
	bpos=iif(bpos==NIL,1,bpos)
	wline=iif(wline==NIL,1,wline)
	wpos=iif(wpos==NIL,1,wpos)
	mode=iif(mode==NIL,.t.,mode)

	dbox(ntop,nleft,nbot,nright,,,fname,[Esc: Cancel])

	tobj=textEditNew(ntop+1,nleft+1,nbot-1,nright-1,setcolor())

	tobj:modeFormat := 2
	tobj:line   := iif(bline!=NIL, bline, tobj:line)
	tobj:pos    := iif(bpos!=NIL,  bpos,  tobj:pos)
	tobj:rowWin := iif(wline!=NIL, wline, tobj:rowWin)
	tobj:colWin := iif(wpos!=NIL,  wpos,  tobj:colWin)
	tobj:marginRight := str_len
	tobj:autoWrap := .t.
	tobj:tabSize:= iif(tab_size!=NIL,tab_size,tobj:tabSizw)
	tobj:loadFile(fName)
	ShowScoreboard()

	while .t.
		nKey:=inkey(0)
		if setkey(nKey)!=NIL
			eval(setkey(nKey),procname(),procline(),readvar())
			loop
		endif
		viewKeys(nkey,tobj,@lExit)
		if lExit
			exit
		endif
	enddo

	setcolor(oldcolor)
	restscreen(,,,,scr)
return .t.

static func viewKeys(nkey,tobj,lExit)
    local ln,pos,oldcolor, ret:=.t.
    lExit:=.F.
    do case
       case (nkey==K_ESC .OR. nkey=K_CTRL_W) .AND. !tobj:updated
	    lExit:=.T.
       case nkey==K_DOWN
	    tobj:down()
       case nkey==K_PGDN
	    tobj:pageDown()
       case nkey==K_CTRL_PGDN
	    tobj:Bottom()
       case nkey==K_UP
	    tobj:up()
       case nkey==K_PGUP
	    tobj:pageUp()
       case nkey==K_CTRL_PGUP
	    tobj:top()
       case nkey==K_HOME
	    tobj:home()
       case nkey==K_END
	    tobj:end()
       case nkey==K_LEFT
	    tobj:left()
       case nkey==K_RIGHT
	    tobj:right()
       case nkey==K_CTRL_LEFT
	    tobj:wordLeft()
       case nkey==K_CTRL_RIGHT
	    tobj:wordRight()
       /*
       case nkey==K_F4
	    oldcolor=setcolor(set("edit_colors_menu"))
	    ln:=val(str(tobj:line,6,0))
	    pos:=val(str(tobj:pos,3,0))
	    ln=readkeyb(,,[Goto line],@ln,[Goto position],@pos)
	    tobj:gotoLine(ln)
	    tobj:gotoPos(pos)
	    setcolor(oldcolor)

       case nkey==K_ALT_F4
	    oldcolor=setcolor(set("edit_colors_menu"))
	    ln:=val(str(tobj:marginLeft,6,0))
	    pos:=val(str(tobj:marginRight,3,0))
	    ln=readkeyb(,,[Margin left],@ln,[Margin Right],@pos)
	    tobj:marginLeft:=ln
	    tobj:marginRight:=pos
	    setcolor(oldcolor)
       */
       otherwise
	    ret:=.f.
    endcase
return ret

static func editKeys(nkey,tobj,lExit, lData)
    local ret:=.t.,i, str, crlf
    lExit:=.f.
    do case

       case !EMPTY(lData)
	    if ( Set(_SET_INSERT) )
	       tobj:insert(chr(nkey))
	    else
	       tobj:overStrike(chr(nkey))
	    endif

       case nkey==K_ESC .and. tobj:updated

	     lExit:= .t. //alert([Exit from memoedit; Don~t save ?],{[Yes],[No ]})==1

       case nkey==K_CTRL_W .and. tobj:updated
	     crlf := set("CRLF_MEMOEDIT")
	     if empty(crlf)
		crlf := "&\r&\n"
	     endif
	     str:=""
	     for i=1 to tobj:lines
		if tobj:tabPack
			str+=tabPack(tobj:edBuffer[i],tobj:tabSize)
		else
			str+=tobj:edBuffer[i]
		endif
		if i<>tobj:lines
			str+="&\r&\n" //CRLF
		endif
	     next

	     lExit := str

       case nkey==K_ENTER
	    //if ( Set(_SET_INSERT) )
		tobj:insertLine()
	    //else
	    //	tobj:newLine()
	    //endif
       case nkey==K_DEL
	    tobj:delRight()
       case nkey==K_CTRL_T
	    tobj:delEnd()
       case nkey==K_BS
	    tobj:backSpace()
       case nkey==K_CTRL_BS
	    tobj:delHome()
       case nkey==K_CTRL_Y
	    tobj:deleteLine()
       case nkey==K_CTRL_F7
	    tobj:centerLine()
       case nkey==K_INS
	    set( _SET_INSERT, !Set(_SET_INSERT) )
	    ShowScoreboard()
       otherwise
	 if nkey>=0 .and. nkey<256
	    if ( Set(_SET_INSERT) )
	       tobj:insert(chr(nkey))
	    else
	       tobj:overStrike(chr(nkey))
	    endif
	 else
	    ret:=.f.
	 endif
    endcase
return ret

static proc ShowScoreboard()
    local nRow, nCol
    if ( Set(_SET_SCOREBOARD) )
	nRow := Row()
	nCol := Col()
	SetPos(TE_SCORE_ROW, TE_SCORE_COL)
	DispOut( if(Set(_SET_INSERT), [<Ins>], [<Ovr>]) )
	SetPos(nRow, nCol)
     end
return

static func user_action(tobj, user_ret, mode, nkey)
local lExit:=.f.
    if user_ret = ME_TOGGLEWRAP
// not supported
    elseif user_ret = ME_TOGGLESCROLL
// not supported
    elseif user_ret = ME_WORDRIGHT
	tobj:wordRight()
    elseif user_ret = ME_BOTTOMRIGHT
	tobj:Bottom()
    elseif user_ret = ME_DEFAULT .and. nkey # nil
	if ! viewKeys(nkey,tobj, @lExit) .and. mode
	    editKeys(nkey,tobj, @lExit)
	endif
    elseif user_ret = ME_IGNORE
    elseif user_ret = ME_DATA .and. mode .and. nkey # nil .and. nkey >= 0
	editKeys(nkey,tobj, @lExit, .t.)
    elseif user_ret >= 1 .and. user_ret <= 31
	if ! viewKeys(user_ret,tobj, @lExit) .and. mode
	    editKeys(user_ret,tobj, @lExit)
	endif
    endif
return lExit
