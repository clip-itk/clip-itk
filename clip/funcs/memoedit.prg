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
	local user_ret

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
	tobj:tabSize:= iif(tab_size!=NIL,tab_size,tobj:tabSizw)

	if user_func # nil
		while (user_ret:=clip(user_func, ME_INIT, tobj:line, tobj:pos)) # 0
			user_action(tobj, user_ret, mode)
		enddo
	endif

	tobj:loadString(@str)
	ShowScoreboard()

	while .t.
		if nextkey() = 0
                	if user_func != NIL
				user_action(tobj, clip(user_func, ME_IDLE, tobj:line , tobj:pos), mode)
                        endif
		endif
    		nKey:=inkey(0)
    		do case
       		case nKey==K_ESC
	    		if !tobj:updated .or. alert([Exit from memoedit; Don~t save ?],{[Yes],[No ]})==1
	       			exit
	    		endif
       		case nkey==K_CTRL_W
	    		str:=""
	    		for i=1 to tobj:lines
				if tobj:tabPack
		   			str+=tabPack(tobj:edBuffer[i],tobj:tabSize)+"&\r&\n" //CRLF
				else
		   			str+=tobj:edBuffer[i]+"&\r&\n" //CRLF
				endif
	    		next
	    		exit
       		case (nkey == K_INS)
	    		set( _SET_INSERT, !Set(_SET_INSERT) )
	    		ShowScoreboard()
       		otherwise
	    		if ! if(mode, viewkeys(nkey,tobj) .or. editKeys(nkey,tobj), viewKeys(nkey,tobj)) .and. !empty(user_func)
		   	    status:=if(tobj:updated, ME_UNKEYX, ME_UNKEY)
			    user_action(tobj, clip(user_func, status, tobj:line , tobj:pos), mode, nkey)
	    		endif
       		endcase
	enddo
	setcolor(oldcolor)
return str

********************************************************
function viewFile(fName, ntop, nleft, nbot, nright, mode, user_func,;
		  str_len, tab_size, bline, bpos, wline, wpos)

	local tobj,i,nkey,oldcolor:=setcolor(),scr:=savescreen()

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
	tobj:tabSize:= iif(tab_size!=NIL,tab_size,tobj:tabSizw)
	tobj:loadFile(fName)
	ShowScoreboard()

	while .t.
    		nKey:=inkey(0)
    		do case
       		case nKey==K_ESC
	       		exit
       		otherwise
	    		viewKeys(nkey,tobj)
       		endcase
	enddo

	setcolor(oldcolor)
	restscreen(,,,,scr)
return .t.

static func viewKeys(nkey,tobj)
    local ln,pos,oldcolor, ret:=.t.
    do case
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

static func editKeys(nkey,tobj)
    local ret:=.t.
    do case
       case nkey==K_ENTER
	    if ( Set(_SET_INSERT) )
		tobj:insertLine()
	    else
		tobj:newLine()
	    endif
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
       otherwise
	 if nkey>=32 .and. nkey<=256
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

static proc user_action(tobj, user_ret, mode, nkey)
    if user_ret = ME_TOGGLEWRAP
// not supported
    elseif user_ret = ME_TOGGLESCROLL
// not supported
    elseif user_ret = ME_WORDRIGHT
	tobj:wordRight()
    elseif user_ret = ME_BOTTOMRIGHT
	tobj:Bottom()
    elseif user_ret = ME_DEFAULT .and. nkey # nil
	if ! viewKeys(nkey,tobj) .and. mode
	    editKeys(nkey,tobj)
	endif
    elseif user_ret = ME_DATA .and. mode .and. nkey # nil .and. nkey >=1 .and. nkey < 256
	editKeys(nkey,tobj)
    elseif user_ret >= 1 .and. user_ret <= 31
	if ! viewKeys(user_ret,tobj) .and. mode
	    editKeys(user_ret,tobj)
	endif
    elseif user_ret = ME_IGNORE
    endif
return
