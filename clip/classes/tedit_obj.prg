/*   TEXTEDIT class                                             */
/*                                                              */
/*   Copyright (C) 2001-2204  ITK                               */
/*   Author  : Elena Kornilova (alena@itk.ru)                   */
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html     */

#include "edit.ch"
#include "box.ch"
#include "fileio.ch"

#define U_CMD           1
#define U_CYCLE         2
#define U_POS           3
#define U_LINE          4
#define U_LINES         5
#define U_COL           6
#define U_ROW           7
#define U_VALUE         8
#define U_BLOCK         9  //{type_block[0-no_block|1-str_block|2-rect_block], nt, nl, nb, nr}
#define U_MKBLOCK       10
#define U_FIND          11

#define FA_NORMAL       0
#define FA_READONLY     1
#define FA_HIDDEN       2
#define FA_SYSTEM       4
#define FA_VOLUME       8
#define FA_DIRECTORY    16
#define FA_ARCHIVE      32

function textEditNew(Lrow, Lcol, Rrow, Rcol, color)
local obj
       obj:=map()

       obj:classname    := "TEXTEDIT"
       obj:path         := ""  // –’‘ÿ À ∆¡ Ã’
       obj:filename     := ""  // …Õ— ∆¡ Ã¡
       obj:lines        := 0
       obj:colorSpec    := iif(empty(color),setcolor(),color)
       obj:line         := 1
       obj:pos          := 1
       obj:colWin       := 1
       obj:rowWin       := 1
       obj:nTop         := Lrow
       obj:nLeft        := Lcol
       obj:nBottom      := Rrow
       obj:nRight       := Rcol
       obj:updated      := .f.
       obj:marginLeft   := TE_MARGIN_LEFT
       obj:marginRight  := TE_MARGIN_RIGHT
       obj:tabSize      := TE_TABSIZE
       obj:maxStrings   := TE_MAXSTRINGS
       obj:Hyphen       := TE_HYPHEN
       obj:tabPack      := iif(lower(set("edit_tabpack"))=='yes',.t.,.f.)
       obj:inFocus      := .f.
       obj:autoWrap     := TE_AUTO_WRAP

       obj:mkblock      := .f.
       obj:strblock     := .f.          // ”‘“œﬁŒŸ  ¬ÃœÀ
       obj:rectblock    := .f.          // –“—Õœ’«œÃÿŒŸ  ¬ÃœÀ
       obj:koordblock   := {NIL, NIL, NIL, NIL} // Àœœ“ƒ…Œ¡‘Ÿ ¬ÃœÀ¡

       obj:__findR      := {}
       obj:__regSearch  := {}
       obj:__undobuffer := {}
       obj:lenundo      := 100
       obj:__curundo    := 0
       obj:__startundo  := 0
       obj:charset      := NIL
       obj:lEofString   := .f.      // show eof string
       obj:eofString    := [<EOF>]
       obj:__hostcharset:= host_charset()
       obj:__keys       := map()

       obj:highLightColor       := map()

       obj:Nstyle       := .f.
       obj:__LNstyle    := 0

       obj:edbuffer     := {}
       obj:__colors     := {}      // –¡Ã…‘“Ÿ √◊≈‘œ◊
       obj:__leninfo    := maxcol()-maxcol()*3/4 - 1

       _recover_textedit(obj)

       obj:__setcolor()
       obj:__setDefaultKey()
       obj:__nullInit()

return obj
*************************************
function _recover_textedit(obj)
       obj:__nullInit   := @__te_nullInit()

       obj:down         := @te_down()
       obj:up           := @te_up()
       obj:left         := @te_cleft()
       obj:right        := @te_cright()
       obj:wordLeft     := @te_wordLeft()
       obj:wordRight    := @te_wordRight()
       obj:Bottom       := @te_goBottom()
       obj:Top          := @te_goTop()
       obj:home         := @te_home()
       obj:end          := @te_end()
       obj:pageDown     := @te_pageDown()
       obj:pageUp       := @te_pageUp()
       obj:prevPage     := @te_prevPage()
       obj:nextPage     := @te_nextPage()

       //obj:panHome      := @te_panHome()
       //obj:panEnd       := @te_panEnd()
       //obj:panLeft      := @te_panLeft()
       //obj:panRight     := @te_panRight()
       //obj:panUp        := @te_panUp()
       //obj:panDown      := @te_panDown()

       obj:handleKey    := @te_handleKey()

       obj:gotoLine     := @te_gotoLine()
       obj:gotoPos      := @te_gotoPos()
       obj:find         := @te_find()
       obj:findNext     := @te_findNext()
       obj:findPrev     := @te_findPrev()
       obj:replace      := @te_replace()
       obj:curWord      := @te_curWord()
       obj:prevWord     := @te_prevWord()
       obj:nextWord     := @te_nextWord()
       obj:Identity     := @te_Identity()
       obj:matchStruct  := @te_matchStruct()

       obj:clear        := @te_clear()
       obj:loadString   := @te_loadString()
       obj:loadFile     := @te_loadFile()
       obj:reLoadFile   := @te_reLoadFile()
       obj:saveFile     := @te_saveFile()
       obj:saveString   := @te_saveString()

       obj:loadBlock    := @te_loadBlock()
       obj:saveBlock    := @te_saveBlock()
       obj:beginBlock   := @te_beginBlock()
       obj:endBlock     := @te_endBlock()
       obj:cancelBlock  := @te_cancelBlock()
       obj:copyBlock    := @te_copyBlock()
       obj:moveBlock    := @te_moveBlock()
       obj:deleteBlock  := @te_deleteBlock()
       obj:setTabSize   := @te_setTabSize()
       obj:setFocus     := @te_setFocus()

       obj:copyToClipboard      := @te_copyToClipboard()
       obj:addToClipboard       := @te_addToClipboard()
       obj:moveToClipboard      := @te_moveToClipboard()
       obj:pasteFromClipboard   := @te_pasteFromClipboard()

       obj:refresh      := @te_refresh()
       //obj:refreshStr   := @te_refreshStr()

       obj:backSpace    := @te_backSpace()
       obj:delLeft      := @te_backSpace()
       obj:delHome      := @te_delHome()
       obj:delRight     := @te_delRight()
       obj:delete       := @te_delRight()
       obj:deleteLine   := @te_deleteLine()
       obj:delEnd       := @te_delEnd()
       //obj:delWordLeft  := @te_delWordLeft()
       //obj:delWordRight := @te_delWordRight()

       obj:Insert       := @te_Insert()
       obj:overStrike   := @te_overStrike()
       obj:__autoWrap   := @te___autoWrap()
       obj:insertLine   := @te_insertLine()
       obj:newLine      := @te_newLine()

       obj:draw         := @te_draw()
       obj:__Frmt       := @te_Frmt()
       obj:formatLine   := @te_formatLine()
       obj:formatPart   := @te_formatPart()
       obj:centerLine   := @te_centerLine()
       obj:insTempl     := @te_insTempl()
       obj:insMacro     := @te_insMacro()

       obj:__check_line := @te_check_line()

       obj:undo         := @te_undo()
       obj:writeundo    := @te_writeundo()

       obj:print        := @te_print()
       obj:printBlock   := @te_printBlock()

       obj:__around_check       := @te_around_check()
       obj:highLightAdd := @te_highLightAdd()
       obj:highLightDel := @te_highLightDel()

       obj:setNumStyle  := @te_setNumStyle()
       obj:killNumStyle := @te_killNumStyle()

       obj:setNewColor  := @te_setNewColor()
       obj:__setColor   := @__te_setcolor()

       obj:setCharset   := @te_setCharset()
       obj:__check_clipchs := @te_check_clipchs()
       obj:__setDefaultKey      := @te___setDefaultKey()
       obj:setKey       := @te_setKey()
       obj:applyKey     := @te_applyKey()
return obj
*************************************
static function te___setDefaultKey()
local m
	::__keys := map()
	m := ::__keys

	m[K_DOWN]       := {|oTe, nkey| oTe:down(), TE_CONTINUE }
	m[K_PGDN]       := {|oTe, nkey| oTe:pageDown(), TE_CONTINUE }
	m[K_CTRL_PGDN]  := {|oTe, nkey| oTe:bottom(), TE_CONTINUE }
	m[K_UP]         := {|oTe, nkey| oTe:up(), TE_CONTINUE }
	m[K_PGUP]       := {|oTe, nkey| oTe:pageUp(), TE_CONTINUE }
	m[K_CTRL_PGUP]  := {|oTe, nkey| oTe:top(), TE_CONTINUE }
	m[K_HOME]       := {|oTe, nkey| oTe:home(), TE_CONTINUE }
	m[K_END]        := {|oTe, nkey| oTe:end(), TE_CONTINUE }
	m[K_LEFT]       := {|oTe, nkey| oTe:left(), TE_CONTINUE }
	m[K_RIGHT]      := {|oTe, nkey| oTe:right(), TE_CONTINUE }
	m[K_CTRL_LEFT]  := {|oTe, nkey| oTe:wordLeft(), TE_CONTINUE }
	m[K_CTRL_RIGHT] := {|oTe, nkey| oTe:wordRight(), TE_CONTINUE }

	m[K_BS]         := {|oTe, nkey| oTe:backSpace(), TE_CONTINUE }
	m[K_CTRL_BS]    := {|oTe, nkey| oTe:delHome(), TE_CONTINUE }
	m[K_DEL]        := {|oTe, nkey| oTe:delRight(), TE_CONTINUE }
return
*************************************
static function te_setKey(nKey, vData)
local ret
	ret := vData
	if nKey $ ::__keys
		ret := ::__keys[nKey]
	endif
	::__keys[nKey] := vData
	if vData == NIL
		adel(::__keys, nKey)
	endif
return ret
*************************************
static function te_applyKey(oTe, nKey)
local ret := TE_EXCEPTION, m
	m := oTe:__keys
	if nKey $ m
		ret := eval(m[nKey], oTe, nKey)
	endif
return ret
*************************************
static function te_handleKey(nkey)
local ret:=.t.
    do case
       case nkey==K_DOWN
	    ::down()
       case nkey==K_PGDN
	    ::pageDown()
       case nkey==HASH_BottomText//K_CTRL_PGDN
	    ::Bottom()
       case nkey==K_UP
	    ::up()
       case nkey==K_PGUP
	    ::pageUp()
       case nkey==HASH_TopText//K_CTRL_PGUP
	    ::Top()
       case nkey==K_HOME
	    ::home()
       case nkey==K_END
	    ::end()
       case nkey==K_LEFT
	    ::left()
       case nkey==K_RIGHT
	    ::right()
       case nkey==K_CTRL_LEFT
	    ::wordLeft()
       case nkey==K_CTRL_RIGHT
	    ::wordRight()
       otherwise
	    ret:=.f.
    endcase
return ret
*************************************
static function te_check_line(line, undo)
local i:=len(::edbuffer), oldLine
   undo := iif(undo==NIL, .t., undo)
   if line<=0
      return 1
   endif

/*
   if undo
	::writeundo(HASH_CHECKLINE)
   endif
*/
   oldLine := ::line
   for i=i to line-1
       aadd(::edbuffer,"")
	if undo
		::line := i+1
	    //  ::pos := 1
		::writeundo(HASH_INSLINE)
	endif
   next
  ::lines:=len(::edbuffer)
return oldLine
*********** initialisation
static function __te_nullInit()
  asize(::__undobuffer, ::lenundo)
  afill(::__undobuffer, NIL)
  asize(::edbuffer,0)
  afill(::koordblock, NIL)
  asize(::__findR, 3)
  afill(::__findR, NIL)
  ::strblock := .f.
  ::rectblock := .f.
  ::mkblock := .f.
return

*********** –≈“≈⁄¡«“’⁄À¡ ∆¡ Ã¡ ” ƒ…”À¡
static function te_reLoadFile()
return .t.

*********** ⁄¡«“’⁄À¡ ∆¡ Ã¡ ” ƒ…”À¡
static function te_loadFile(filename, lRefresh)
local nfile, scr, i
  lRefresh := iif(empty(lRefresh), .t., lRefresh)

  save screen to scr
  @ maxrow(), 0 say padr([Load file...], maxcol()) color "0/7"
  inkey()

  nfile:=fopen(filename)
  if nfile<0
     restore screen from scr
     return .f.
  endif

  *if !empty(fileseek(filename, FA_ARCHIVE+FA_VOLUME+FA_SYSTEM+FA_HIDDEN+FA_READONLY))
  *     alert(fileattrs()+';'+tostring(fileattr()))
  *endif
  i:=atr(PATH_DELIM,filename)
  if i!=0
	::path:=left(filename,i-1)
  endif
  ::fileName:=substr(filename,i+1)
  ::__nullInit()
  ::lines := 0
  if ::charset == NIL
	::__check_clipchs(::path)
  endif
  if ::charset != NIL
	while !fileeof(nfile)
		::lines ++
		/**/
		if ::lines > ::maxStrings
			::lines --
			alert([The size of file ;]+filename+[; most maximum size!;Last strings may be lost], [OK])
			exit
		endif
		/**/
		aadd(::edbuffer, translate_charset(::charset, ::__hostcharset, tabexpand(filegetstr(nfile,TE_MAX_LEN_STRING),::tabSize)) )
	enddo
  else
	while !fileeof(nfile)
		::lines ++
		/**/
		if ::lines > ::maxStrings
			::lines --
			alert([The size of file ;]+filename+[; most maximum size!;Last strings may be lost], [OK])
			exit
		endif
		/**/
		aadd(::edbuffer, tabexpand(filegetstr(nfile,TE_MAX_LEN_STRING),::tabSize) )
	enddo
  endif
  fclose(nfile)
  ::lines:=len(::edbuffer)
  ::line:=1
  ::pos:=1
  ::updated:=.f.
  restore screen from scr
  if lRefresh
	::refresh()
  endif
RETURN .t.

*********** ⁄¡«“’⁄À¡ ‘≈À”‘¡ …⁄ ”‘“œÀ…
static function te_loadString(str)
local i
	if str==NIL .or. (valtype(str)!="C" .and. valtype(str)!="M")
		return .f.
	endif

	::__nullInit()
	if ::charset != NIL
		str := translate_charset(::charset, ::__hostcharset, str)
	endif
	::edbuffer := split(str, "&\r?&\n")
	//tab := ::tabSize
	for i=1 to len(::edbuffer)
		::edbuffer[i] := tabexpand(::edbuffer[i], ::tabSize)
	next
	::lines:=len(::edbuffer)
	::refresh()
RETURN  .t.

***********
static function __te_setcolor()
local i, s
       s:=::colorSpec
       while len(s)>0
	   i:=at(",",s)
	   i=iif(i==0,len(s)+1,i)
	   aadd(::__colors,substr(s,1,i-1) )
	   s:=substr(s,i+1)
       enddo
return


***********
static function te_setNewColor(newColor)
local i, oldcolor
       if newColor == NIL
		return
       endif
       oldcolor := ::__colors
       asize(::__colors, 0)
       ::colorSpec := iif(newColor!=NIL, newColor, ::colorSpec)
       ::__setcolor()
       i := len(::__colors)
       if i < len(oldcolor)
	  asize(::__colors, len(oldcolor))
	  for i:=i+1 to len(oldcolor)
		::__colors[i] := oldcolor[i]
	  next
       endif
       ::refresh()
return
*********** ⁄¡–œÃŒ≈Œ…≈ ‹À“¡Œ¡ ‘≈À”‘œÕ
static function te_refresh()
local bp,bl,l,i,dev, str, str1, block, min, max, fnd, clr_st

       ::line   := max(1, ::line)
       ::pos    := max(1, ::pos)

       ::rowWin := min(min(max(1,::rowWin),::nBottom-::nTop+1),::line)
       ::colWin := min(min(max(1,::colWin),::nRight-::nLeft+1),::pos)

       if ::mkblock
	   ::koordblock[3] := ::line
	   ::koordblock[4] := ::pos
       endif
       if ::lines > ::maxStrings
		alert([The size of file is a most maximum size!;Last strings may be lost; Please check MAXSTRINGS options], [OK])
		::lines := ::maxStrings
		asize(::edbuffer, ::lines)
       endif

       fnd := iif(::__findR[1]!=NIL, .t., .f.)

       bl := ::line-::rowWin
       bp := ::pos-::colWin
       l  := ::nRight-::nLeft+1//iif(::nLeft<1, 1, 0)
       dispbegin()
       block :=  ::strblock .or. ::rectblock

       if ::rectblock
	   if ::koordblock[2]<=::koordblock[4]
	       min := ::koordblock[2]-bp
	       max := ::koordblock[4]-bp
	   else
	       min := ::koordblock[4]-bp
	       max := ::koordblock[2]-bp
	   endif
	   min := max(min, 1)
	   max := max(max, 0)
       endif
       if fnd .and. !between(::__findR[1], bl+1, bl+1+::nbottom-::ntop+1)
	   fnd := .f.
	   afill(::__findR, NIL)
       endif
       for i=1 to ::nbottom-::ntop+1
	   if (bl+i) <= ::lines
	      str=padr(substr(::edbuffer[bl+i],bp+1,bp+l),l)
	      if (bl+i)$::highLightColor
		@ ::ntop+i-1, ::nLeft say str color ::__colors[::highLightColor[bl+i][1]]
		clr_st := ::__colors[::highLightColor[bl+i][1]]
	      elseif !block .or. (block .and. !between(bl+i, ::koordblock[1], ::koordblock[3]))
		   clr_st := ::__colors[1]
		   if fnd .and. ::__findR[1] == bl+i
			@ ::ntop+i-1, ::nLeft say substr(str, 1, ::__findR[2]-1) color ::__colors[1]
			@ ::ntop+i-1, ::nLeft+::__findR[2]-1 say substr(str, ::__findR[2], ::__findR[3]) color ::__colors[4]
			@ ::ntop+i-1, ::nLeft+::__findR[2]+::__findR[3]-1 say substr(str, ::__findR[2]+::__findR[3]) color ::__colors[1]
		   else
			@ ::ntop+i-1, ::nLeft say str color ::__colors[1]
		   endif
	      else
		   if ::strblock
			@ ::ntop+i-1, ::nLeft say str color ::__colors[3]
			clr_st := ::__colors[3]
		   else

			if max >0
				dev := max(0, min)
				str1=substr(str, 1, dev-1)
				@ ::ntop+i-1, ::nLeft say str1 color ::__colors[1]
				str1=substr(str, dev, max-min+1)
				@ ::ntop+i-1, ::nLeft+max(dev-1, 0) say str1 color ::__colors[3]
				dev += max-min+1
				str1=substr(str, dev)
				@ ::ntop+i-1, ::nLeft+max(dev-1, 0) say str1 color ::__colors[1]
				clr_st := ::__colors[1]
			else
				@ ::ntop+i-1, ::nLeft say str color ::__colors[1]
				clr_st := ::__colors[1]
			endif
		   endif
	      endif
	   endif
	   if (bl+i) == ::lines+1
	      if ::lEofString
		@ ::ntop+i-1, ::nLeft say padr(::eofString,l) color ::__colors[2]
	      endif
	      clr_st := ::__colors[2]
	   endif
	   if ::Nstyle .and. (bl+i) < ::lines+iif(::lEofString,1,0)
		@ ::ntop+i-1, ::nLeft-::__LNstyle say str(bl+i, ::__LNstyle-1, 0)+"Å" color clr_st
	   endif
	   if (bl+i) > ::lines+iif(::lEofString,1,0)
	      @ ::ntop+i-1, ::nLeft-::__LNstyle say space(l) color ::__colors[1]
	   endif
       next
       devpos(::nTop+::rowWin-1,::nLeft+::colWin-1)
       dispend()
return

*********** ⁄¡–œÃŒ≈Œ…≈ ”‘“œÀ…
static function te_refreshStr(Step)
return

************
static function te_clear()
       ::__nullInit()
       asize(::edbuffer,1)
       ::edbuffer[1]=''
       ::lines=1
       ::FlagEnd=.t.
       ::refresh()
return

*********** –≈“≈Õ≈›≈Œ…≈ Œ¡ œƒŒ’ ”‘“œÀ’ ◊Œ…⁄
static function te_down( undo )
    undo := iif(undo==NIL, .t., undo)
    if undo
	::writeundo(HASH_DOWN)
    endif

    ::line++
    ::rowWin++
    if undo
	if (::rowWin > (::nBottom-::nTop+1)) .or. ::mkblock
		::refresh()
	else
		devpos(::nTop+::rowWin-1,::nLeft+::colWin-1)
	endif
    endif
RETURN

*********** –≈“≈Õ≈›≈Œ…≈ Œ¡ œƒŒ’ ”‘“œÀ’ ◊◊≈“»
static function te_up( undo )
     undo := iif(undo==NIL, .t., undo)
     if undo
	::writeundo(HASH_UP)
     endif

     ::line--
     ::rowWin--
     if undo
	 if ::rowWin < ::nTop+1 .or. ::mkblock
		::refresh()
	 else
		devpos(::nTop+::rowWin-1,::nLeft+::colWin-1)
	 endif
     endif
RETURN

*********** –≈“≈Õ≈›≈Œ…≈ –œ PgDn
static function te_PageDown( undo )
    undo := iif(undo==NIL, .t., undo)
    if undo
	::writeundo(HASH_PGDOWN)
    endif
    ::line := min(::line+::nbottom-::ntop, ::lines)
    if undo
	::refresh()
    endif
return

*********** –≈“≈Õ≈›≈Œ…≈ –œ PgUp
static function te_PageUp( undo )
    undo := iif(undo==NIL, .t., undo)
    if undo
	::writeundo(HASH_PGUP)
    endif
    ::line=::line-::nbottom-::ntop
    if undo
	::refresh()
    endif
RETURN

*********** –≈“≈Õ≈›≈Œ…≈ –œ ”‘“≈ÃÀ¡Õ ◊Ã≈◊œ-◊–“¡◊œ
static function te_cleft( undo )
    undo := iif(undo==NIL, .t., undo)
    if undo
	::writeundo(HASH_CLEFT)
    endif
    ::pos--
    ::colWin--
    if undo
	if ::colWin <= 1 .or. ::mkblock
		::refresh()
	else
		devpos(::nTop+::rowWin-1,::nLeft+::colWin-1)
	endif
    endif
return

static function te_cright( undo )
    undo := iif(undo==NIL, .t., undo)
    if undo
	::writeundo(HASH_CRIGHT)
    endif
    ::pos++
    ::colWin++
    if undo
	if ::colWin > (::nRight-::nLeft+1) .or. ::mkblock
		::refresh()
	else
		devpos(::nTop+::rowWin-1,::nLeft+::colWin-1)
	endif
    endif
return

*********** ◊ Œ¡ﬁ¡Ãœ ‘≈À”‘¡
static function te_goTop( undo )
   undo := iif(undo==NIL, .t., undo)
   if undo
	::writeundo(HASH_BOTOP)
   endif
   ::line:=1
   ::rowWin:=1
   if undo
	::refresh()
   endif
RETURN

*********** ◊ ÀœŒ≈√ ‘≈À”‘¡
static function te_goBottom( undo )
   undo := iif(undo==NIL, .t., undo)
   if undo
	::writeundo(HASH_BOTOP)
   endif
   ::line:=::lines+1
   ::rowWin:=::nbottom-::ntop
   if undo
	::refresh()
   endif
RETURN

*********** ◊ Œ¡ﬁ¡Ãœ ”‘“œÀ…
static function te_Home( undo )
local homepos:=0, lt
  undo := iif(undo==NIL, .t., undo)
  if ::line<=::lines
	lt := len(ltrim(::edbuffer[::line]))
	if lt == 0
		homepos := 1
	else
		homepos := len(::edbuffer[::line]) - lt + 1
	endif

  endif
  if undo
	::writeundo(HASH_HOME)
  endif
  if ::pos <= homepos
      ::pos := 1
      ::colWin := 1
  else
      ::colWin -= ::pos-homepos
      ::pos := homepos
  endif
  if undo
	::refresh()
  endif
return

*********** ◊ ÀœŒ≈√ ”‘“œÀ…
static function te_end( undo )
   undo := iif(undo==NIL, .t., undo)
   if undo
	::writeundo(HASH_END)
   endif
   //::gotoPos(len(::edBuffer[::line])+1, .f.)
   if ::line<=::lines
	::pos := len(::edBuffer[::line])+1
	::colWin := len(::edBuffer[::line])+1
   else
	::pos := 1
	::colWin := 1
   endif
   if undo
	::refresh()
   endif
return

*********** Œ¡ ”Ãœ◊œ ◊–“¡◊œ
static function te_wordRight()
   local s,str, p:=::pos, fl:=.f.
   if ::line>::lines
	return
   endif
   str:=::edBuffer[::line]
   while p<len(str)
	s=substr(str,p,1)
	if s!=" " .and. (isalpha(s) .or. isdigit(s) .or. s=="_")
	   if fl
	      exit
	   endif
	else
	   fl:=.t.
	endif
	p++
   enddo
   ::pos:=p
   ::colWin:=(::nRight-::nLeft)*5/6
   ::refresh()
RETURN

*********** Œ¡ ”Ãœ◊œ ◊Ã≈◊œ
static function te_wordLeft()
   local s,str, p:=::pos, fl:=.f., pl:=.f.
   if ::line>::lines
	return
   endif
   str:=::edBuffer[::line]
   while p>0
	s=substr(str,p,1)
	if s!=" " .and. (isalpha(s) .or. isdigit(s) .or. s=="_")
	   pl:=.t.
	else
	   if fl .and. pl
	      exit
	   endif
	   fl:=.t.
	endif
	p--
   enddo
   ::pos:=p+1
   ::colWin:=max((::nRight-::nLeft)*1/6,::colWin)
   ::refresh()
RETURN

*********** –≈“≈»œƒ Œ¡ ”‘“œÀ’
static function te_gotoLine(ln, undo)
  if ln==NIL .or. ln < 1 .or. ln > ::lines
	return .f.
  endif

  undo := iif(undo==NIL, .t., undo)

  if undo
	::writeundo(HASH_GOLINE)
  endif
  ::line := ln
  ::rowWin := int((::nBottom-::nTop)*2/3)
  if undo
	::refresh()
  endif
return .t.

*********** –≈“≈»œƒ Œ¡ –œ⁄…√…¿
static function te_gotoPos(pos, undo)
local len

  if pos==NIL .or. pos < 1
	return .f.
  endif

   undo := iif(undo==NIL, .t., undo)
   if undo
	::writeundo(HASH_GOPOS)
   endif
   if ::line>::lines
	::line := ::lines
   endif
   len := len(::edbuffer[::line])
   /*
   if pos > len
	pos := len
   endif
   */
   ::pos:=pos
   ::colWin:=pos
   if undo
	::refresh()
   endif
return .t.

*********** ENTER with one set insert
static function te_newLine(undo, autoIndent)
    undo := iif(undo==NIL, .t., undo)
    autoIndent := iif(autoIndent==NIL, .t., autoIndent)
    if undo
	::writeundo(HASH_NEWLINE)
    endif
    if ::line+1<=::lines
	::line++
	::rowWin++
	if autoIndent
		::pos := iif(::line-1 >= 1, len(::edbuffer[::line-1])-len(ltrim(::edbuffer[::line-1]))+1, 1)
	else
		::pos := 1
	endif
	::colWin := ::marginLeft
    else
	::pos := 1
    endif
    if undo
	::refresh()
    endif
return

*********** ◊”‘¡◊…‘ÿ ”‘“œÀ’
static function te_insertLine(undo, autoIndent)
local str, mrL, ol
   undo := iif(undo==NIL, .t., undo)
   autoIndent := iif(autoIndent==NIL, .t., autoIndent)
   ol := ::lines
   ::__check_line(::line, undo)
   if undo
	::writeundo(HASH_INSLINE, ::edbuffer[::line])
   endif
   if ol < ::lines  // ‘.≈. ”‘“œÀ¡ ’÷≈ ƒœ¬¡◊Ã≈Œ¡ ∆’ŒÀ√…≈  check_line()
	if undo
		::refresh()
	endif
	return
   endif
   mrL := iif(::line >= 1, ;
		iif(autoindent, len(::edbuffer[::line])-len(ltrim(::edbuffer[::line]))+1, ::marginLeft),;
		1)
   str:=space(mrL-1)+substr(::edbuffer[::line],::pos)
   ::edbuffer[::line] := substr(::edbuffer[::line],1,::pos-1)
   aadd(::edBuffer,"")
   ::line++
   ::rowWin++
   ::pos:=::marginLeft
   ains(::edBuffer,::line)
   ::edBuffer[::line]:=str
   ::updated:=.t.
   ::lines:=len(::edbuffer)
   ::pos := mrL
   ::colWin := ::pos
   //::gotoPos(::pos)
   if undo
	::refresh()
   endif
return

*********** ◊”‘¡◊…‘ÿ ”…Õ◊œÃ
static function te_insert(str, undo)
   local expstr, p, pos, colWin, tailstr
   undo := iif(undo==NIL, .t., undo)
   str := iif(str==NIL, "", str)
   if ::line > ::lines
	::__check_line(::line)
   endif

   expstr := tabexpand(padr(::edbuffer[::line],::pos-1)+str, ::tabSize)
   tailstr := substr(::edbuffer[::line], ::pos)
   if str == chr(K_TAB)
       p := ::pos-1
       pos := ::pos+len(expstr)-p
       colWin := ::colWin+len(expstr)-p
   else
       pos := ::pos + len(str)
       colWin := ::colWin + len(str)
   endif

   if ::autoWrap .and. pos > ::marginRight
	return ::__autoWrap(undo, HASH_INSAUTOWRAP, expstr, tailstr, pos, colWin)
   endif

   if undo
	   if str == chr(K_TAB)
		::writeundo(HASH_INSTAB, ::edbuffer[::line])
	   else
		::writeundo(HASH_INS, str)
	   endif
   endif
   ::edbuffer[::line]=expstr+substr(::edbuffer[::line],::pos)

   ::pos := pos
   ::colWin := colWin

   ::updated:=.t.
   if undo
	::refresh()
   endif
return
*********** ⁄¡Õ≈Œ…‘ÿ ”…Õ◊œÃ
static function te_overStrike(str, undo)
   local expstr, p, k, pos, colWin, tailstr, srcchr
   undo := iif(undo==NIL, .t., undo)
   ::__check_line(::line)
   str := iif(str==NIL, "", str)
   if str == chr(K_TAB)
	if undo
		::writeundo(HASH_OVRTAB, "")
	endif
	p := int(::pos / ::tabSize)
	k := ::pos - p
	::colWin += (p+1) * ::tabSize - ::pos + 1
	::pos := (p+1) * ::tabSize + 1

	if undo
		::refresh()
	endif
	return
   endif
   expstr := tabexpand(padr(::edbuffer[::line],::pos-1)+str, ::tabSize)
   tailstr := substr(::edbuffer[::line], ::pos+1)
   srcchr := substr(::edbuffer[::line], ::pos, len(str))
   if undo
	::writeundo(HASH_OVR, srcchr)
   endif
   pos := ::pos + len(str)
   colWin := ::colWin + len(str)

   if ::autoWrap .and. pos > ::marginRight
	return ::__autoWrap(undo, HASH_OVRAUTOWRAP, expstr, tailstr, pos, colWin)
   endif


   ::edbuffer[::line]=expstr+tailstr

   ::pos := pos
   ::colWin := colWin

   ::updated:=.t.
   if undo
	::refresh()
   endif
return

static function te___autoWrap(undo, undocmd, expstr, tailstr, pos, colWin)
   /* auto margin right */
local i, m, p, l, srcstr, parr
   undo := iif(undo==NIL, .t., undo)

   m:={}
   if int(::pos/::marginRight) == 1
	if undo
		aadd(m, 1)
		aadd(m, ::edbuffer[::line])
		::writeundo(undocmd, m)
	endif
	::edbuffer[::line]=expstr+tailstr

	::pos := pos
	::colWin := colWin
	p := 0
	do while (::pos > 1)
		::pos --
		::colWin --
		p ++
		if (::pos <= ::marginRight) .and. ;
		(substr(::edbuffer[::line], ::pos, 1) == " ")
			::pos ++
			::colWin ++
			::insertLine(.f., .t.)
			::pos += p - 1
			::colWin += p - 1
			exit
		endif
	enddo
   else
	srcstr := ::edbuffer[::line]

	l := 0
	parr := {}
	do while len (expstr) > ::marginRight
		p := ::marginRight
		do while p > 1
			if substr(expstr, p, 1) == " "
				exit
			endif
			p --
		enddo
		aadd(parr, substr(expstr, 1, p) )
		expstr := /*::space(::marginLeft -1)+*/substr(expstr, p+1)
		l ++
	enddo

	aadd(parr, expstr + tailstr )

	if undo
		aadd(m, l)
		aadd(m, srcstr)
		::writeundo(undocmd, m)
	endif
	::lines += l
	asize(::edbuffer, ::lines)
	::edbuffer[::line] := parr[1]
	for i=2 to len(parr)
		ains(::edbuffer, ::line + i - 1)
		::edbuffer[::line + i - 1] := parr[i]
	next
	::line += l
	::rowWin += l
	::pos := ::colWin := len(expstr) + 1

   endif
   ::updated:=.t.
   if undo
	::refresh()
   endif
return
*********** ’ƒ¡Ã≈Œ…≈ ”…Õ◊œÃ¡ ”Ã≈◊¡
static function te_backSpace( undo )
local min
   undo := iif(undo==NIL, .t., undo)
   if ::line > ::lines
	return
   endif
   ::__check_line(::line)
   if undo
	if ::pos == 1
	    ::writeundo(HASH_BS, chr(K_ENTER))
	else
	    ::writeundo(HASH_BS, substr(::edbuffer[::line], ::pos-1, 1))
	endif
   endif
   if ::pos != 1
       ::edbuffer[::line]=substr(::edbuffer[::line],1,::pos-2)+substr(::edbuffer[::line],::pos)
       ::pos --
       ::colWin --
   else
       if ::line == 1
	   return
       endif
	if ::rectblock .and. ::line == ::koordblock[1] .and. ::line == ::koordblock[3]
		::cancelBlock(.f.)
	endif
       ::lines--
       ::colWin := len(::edbuffer[::line-1])+1
       ::edbuffer[::line-1] += ::edbuffer[::line]
       adel(::edbuffer, ::line)
       asize(::edbuffer, ::lines)
       ::line--
       ::pos := ::colWin
   endif
   if ::rectblock .and. ::line == ::koordblock[1] .and. ::line == ::koordblock[3]
     min := min(::koordblock[2], ::koordblock[4])
     if ::pos+1 <= min
	::koordblock[2] --
	::koordblock[4] --
     else
	  if between(::pos+1, ::koordblock[2], ::koordblock[4])
		::koordblock[4] := max(::koordblock[2], ::koordblock[4])-1
		::koordblock[2] := min
		if ::koordblock[2]>::koordblock[4]
			::cancelBlock(.f.)
		endif
	  endif
     endif
   endif
   ::updated:=.t.
   if undo
	::refresh()
   endif
RETURN

*********** ’ƒ¡Ã≈Œ…≈ ”…Õ◊œÃ¡ ”–“¡◊¡
static function te_delRight( undo )
local min
   if ::line > ::lines
	return
   endif
   undo := iif(undo==NIL, .t., undo)
   ::__check_line(::line)
   if ::pos<=len(::edbuffer[::line])
       if undo
	   ::writeundo(HASH_DEL, substr(::edbuffer[::line], ::pos, 1))
       endif
       ::edbuffer[::line]=substr(::edbuffer[::line],1,::pos-1)+substr(::edbuffer[::line],::pos+1)
   else
       if undo
	   ::writeundo(HASH_DEL, chr(K_ENTER))
       endif
       if ::line+1 <= ::lines
		::edbuffer[::line]=::edbuffer[::line]+::edbuffer[::line+1]
		adel(::edbuffer, ::line+1)
		::lines--
		asize(::edbuffer, ::lines)
       elseif ::line<=::lines .and. (len(::edbuffer[::line])==0)
		adel(::edbuffer, ::line)
		::lines--
		asize(::edbuffer, ::lines)
       endif
   endif
   if ::rectblock .and. ::line == ::koordblock[1] .and. ::line == ::koordblock[3]
     min := min(::koordblock[2], ::koordblock[4])
     if ::pos < min
	::koordblock[2] --
	::koordblock[4] --
     else
	if between(::pos, ::koordblock[2], ::koordblock[4])
		::koordblock[4] := max(::koordblock[2], ::koordblock[4])-1
		::koordblock[2] := min
		if ::koordblock[2]>::koordblock[4]
			::cancelBlock(.f.)
		endif
	endif
     endif
   endif
   ::updated:=.t.
   if undo
	::refresh()
   endif
RETURN

*********** ’ƒ¡Ã≈Œ…≈ ”‘“œÀ…
static function te_deleteLine(undo)
local min, max
   undo := iif(undo==NIL, .t., undo)
   ::__check_line(::line)
   if undo
	::writeundo(HASH_DELINE, ::edbuffer[::line])
   endif
   adel(::edbuffer,::line)
   asize(::edBuffer,len(::edBuffer)-1)
   ::lines:=len(::edbuffer)
   ::updated:=.t.
   if ::strblock .or. ::rectblock
	max := max(::koordblock[1], ::koordblock[3])
	min := min(::koordblock[1], ::koordblock[3])
	if ::line < min
		::koordblock[1] := min-1
		::koordblock[3] := max-1
	else
		if between(::line, min, max)
			::koordblock[1] := min
			::koordblock[3] := max-1
			if ::koordblock[1] > ::koordblock[3]
				::cancelblock(undo)
			endif
		endif
	endif
   endif
   if undo
	::refresh()
   endif
return

*********** √≈Œ‘“…“œ◊¡‘ÿ ”‘“œÀ’
static function te_centerLine()
   ::__check_line(::line)
   ::edbuffer[::line]=center(alltrim(::edbuffer[::line]),::marginRight,32,.f.)
   ::updated:=.t.
   ::refresh()
return

*********** ’ƒ¡Ã≈Œ…≈ œ‘ À’“”œ“¡ ƒœ Œ¡ﬁ¡Ã¡ ”‘“œÀ…
static function te_delHome(undo)
   undo := iif(undo==NIL, .t., undo)
   ::__check_line(::line)
   if undo
	::writeundo(HASH_DELHOME, substr(::edbuffer[::line], 1, ::pos-1))
   endif
   ::edbuffer[::line]=substr(::edbuffer[::line],::pos)
   ::updated:=.t.
   ::pos := 1
   ::colWin := 1
   if undo
	::refresh()
   endif
RETURN

*********** ’ƒ¡Ã≈Œ…≈ œ‘ À’“”œ“¡ ƒœ ÀœŒ√¡ ”‘“œÀ…
static function te_delEnd(undo)
   undo := iif(undo==NIL, .t., undo)
   ::__check_line(::line)
   if undo
	::writeundo(HASH_DELEND, substr(::edbuffer[::line], ::pos))
   endif
   ::edbuffer[::line]=substr(::edbuffer[::line],1,::pos-1)
   ::updated:=.t.
   if undo
	::refresh()
   endif
RETURN

*********** ◊ Œ¡ﬁ¡Ãœ –“≈ƒŸƒ’›≈  ”‘“¡Œ…√Ÿ
static function te_prevPage()
RETURN

************ ◊ Œ¡ﬁ¡Ãœ ”Ã≈ƒ’¿›≈  ”‘“¡Œ…√Ÿ
static function te_nextPage()
RETURN

*********** ”À“œÃÃ…Œ«… ◊ “¡⁄ŒŸ≈ ”‘œ“œŒŸ
static function te_panHome()
return

static function te_panEnd()
return

static function te_panLeft()
return

static function te_panRight()
return

static function te_panUp()
return

static function te_panDown()
return

*********** –œ…”À –œƒ”‘“œÀ…
static function te_find(Find, undo)
local str, scr
local i, p, f, found:=.f., rr, st, en, _step

	undo := iif(undo==NIL, .t., undo)
	if undo
		::writeundo(HASH_FIND, Find)
	endif
	//save screen to scr
	//@ maxrow(), 0 say padr([Find string...], maxcol()) color "0/7"
	//inkey()
	str := Find:fstring
	p := ::pos
	if Find:where == 2
		if !(::strBlock .or. ::rectBlock)
			//messagep("Block not found!")
			restore screen from scr
			return .f.
		endif
		if Find:direct == 2  // backward
			st := max(::koordBlock[1], ::koordBlock[3])
			en := min(::koordBlock[1], ::koordBlock[3])
			_step := -1
		else
			st := min(::koordBlock[1], ::koordBlock[3])
			en := max(::koordBlock[1], ::koordBlock[3])
			_step := 1
		endif
	else
		if Find:direct == 2  // backward
			st := min(::line, ::lines)
			en := 1
			_step := -1
		else
			st := min(::line, ::lines)
			en := ::lines
			_step := 1
		endif
	endif

	if !Find:case // ignore case
		str := upper(str)
	endif


	if Find:regexp
		for i = st to en step _step
			::__regSearch := {}
			f := search(str, iif(!Find:case, upper(::edbuffer[i]), ::edbuffer[i]), ::__regSearch, p)
			if f
				if Find:wordonly .and. (isalpha(substr(::edbuffer[i], ::__regSearch[1][1]-1, 1)) .or. isalpha(substr(::edbuffer[i], ::__regSearch[1][2], 1)))
					loop
				endif
				::__findR[1] := i               //line
				::__findR[2] := ::__regSearch[1][1]     //start pos
				::__findR[3] := ::__regSearch[1][2]-::__regSearch[1][1]//length
				::rowWin += i-(::line*_step)
				::line := i
				::gotoPos(::__regSearch[1][1], .f.)
				found := .t.
				exit
			endif
			p := 1
		next
	else
		for i = st to en step _step
			f := atl(str, substr(iif(!Find:case, upper(::edbuffer[i]), ::edbuffer[i]), p))
			if f > 0
				if Find:wordonly .and. (isalpha(substr(::edbuffer[i], p+f-2, 1)) .or. isalpha(substr(::edbuffer[i], p+f+len(str)-1, 1)))
					loop
				endif
				::__findR[1] := i       //line
				::__findR[2] := p+f-1   //start pos
				::__findR[3] := len(str)        //length
				::rowWin += i-(::line*_step)
				::line := i
				::gotoPos(p+f-1, .f.)
				found := .t.
				exit
			endif
			p := 1
		next
	endif
	/*
	if !found .and. !Find:allw .and. !(Find:rstring == NIL) .and. !Find:replace
		messagep([String;]+str+[;not found],,,"0/7")
	endif
	*/
	//restore screen from scr
	if undo
		::refresh()
	endif

RETURN found

*********** ⁄¡Õ≈Œ¡ –œƒ”‘“œÀ Œ…÷≈ À’“”œ“¡
static function te_replace(Find, undo)
local found:=.t., cstr:="", nkey, i, ret:=-1

	undo := iif(undo==NIL, .t., undo)
	cstr := iif(Find:rstring==NIL, cstr, Find:rstring)
	found := ::find(Find, .f.)
	if found
		ret := 1
		::refresh()
		nkey := iif (undo, inkey(0), K_ENTER)
		do case
			case nkey == K_ESC
				ret := -1
				return ret
			case nkey != K_ENTER
				ret := 0
				return ret
		endcase
		if Find:regexp
			if len(::__regSearch) == 1
				cstr := strtran(cstr, "\1", substr(::edbuffer[::__findR[1]], ::__regSearch[1][1], ::__regSearch[1][2]-::__regSearch[1][1]))
			else
				for i=1 to len(::__regSearch)-1
					cstr := strtran(cstr, "\"+alltrim(tostring(i)), substr(::edbuffer[::__findR[1]], ::__regSearch[i+1][1], ::__regSearch[i+1][2]-::__regSearch[i+1][1]))
				next
			endif
		endif
		if undo
			::writeundo(HASH_REPLACE, Find)// {substr(::edbuffer[::__findR[1]], ::__findR[2], ::__findR[3]), cstr})
		endif
		::edbuffer[::__findR[1]] := substr(::edbuffer[::__findR[1]], 1, ::__findR[2]-1)+;
					  cstr + substr(::edbuffer[::__findR[1]], ::__findR[2]+::__findR[3])
		::cancelBlock(.f.)
		if undo
			::refresh()
		endif
		::updated := .t.
		::gotoPos(::pos + len(cstr), .f. )
	endif
RETURN ret

********************* Œ¡ ‘… ”Ã≈ƒ’¿›’¿
static function te_findNext(Find, undo)
local ret:=.f., oldDirect
	undo:=iif(undo==NIL, .t., undo)
	if undo
		::writeundo(HASH_FIND, Find)//:fstring)
	endif
	oldDirect := Find:direct
	Find:direct := 1
	if !empty(Find:fstring)
		::gotoPos(::pos+1, .f.)
		ret := ::find(Find, .f.)
	endif

	Find:direct := oldDirect
	if undo
		::refresh()
	endif
return ret

********************* Œ¡ ‘… –“≈ƒŸƒ’¿›’¿
static function te_findPrev(Find, undo)
local ret:=.f., oldDirect
	undo:=iif(undo==NIL, .t., undo)
	if undo
		::writeundo(HASH_FIND, Find)//:fstring)
	endif

	oldDirect := Find:direct
	Find:direct := 2
	if !empty(Find:fstring)
		::gotoPos(::pos-1, .f.)
		ret := ::find(Find)
	endif

	Find:direct := oldDirect
	if undo
		::refresh()
	endif
return ret

*********** "‘≈À’›≈≈" ”Ãœ◊œ
static function te_curWord(pos, line)
local ret:="", x, y, i, str, alpha, digit, ch
	pos := iif(pos==NIL, ::pos, pos)
	line := iif(line==NIL, ::line, line)
	if valtype(line) == "N"
		::__check_line(line)
		str := ::edbuffer[line]
	else
		str := line
	endif
	ch := substr(str, pos, 1)
	alpha := isalpha(ch)
	digit := isdigit(ch)
	if alpha .or. digit .or. !digit .and. (ch == '.' .or. ch == ',');
	   .and. isdigit(substr(str, pos+1, 1)) .or. ch =='_'
		x := pos
		y := pos
		for i:=pos-1 to 0 step -1
			ch := substr(str, i, 1)
			alpha := isalpha(ch)
			digit := isdigit(ch)
			if !alpha .and. !digit .and. ch != '_' .or. i==0
				x := i+1
				exit
			endif
		next
		for i:=pos+1 to len(str)+1
			ch := substr(str, i, 1)
			alpha := isalpha(ch)
			digit := isdigit(ch)
			if !alpha .and. !digit .and. ch != '_'
				y := i-1
				exit
			endif
		next
		ret := substr(str, x, y-x+1)
	endif
RETURN ret

*********** "–“≈ƒŸƒ’›≈≈" ”Ãœ◊œ
static function te_prevWord(pos, line, newpos)
local ret:="", x, y, i, str, e:=.f., ch
	pos := iif(pos==NIL, ::pos, pos)
	line := iif(line==NIL, ::line, line)
	if valtype(line) == "N"
		::__check_line(line)
		str := ::edbuffer[line]
	else
		str := line
	endif
	x := pos
	for i:=pos to 1 step -1
		ch:= substr(str, i, 1)
		if !isalpha(ch) .and. !isdigit(ch) .and. ch != "_"
			pos := i
			e := .t.
			exit
		endif
	next
	if x == pos .and. pos == 1
		return ret
	endif
	x := 1
	y := 0
	for i:=pos to 1 step -1
		ch:= substr(str, i, 1)
		if e .and. (isalpha(ch) .or. isdigit(ch) .or. ch == "_")
			y := i
			e := .f.
		elseif !e .and. !(isalpha(ch) .or. isdigit(ch) .or. ch == "_")
			x := i+1
			exit
		endif
	next
	ret := substr(str, x, y-x+1)
	pos := x
	newpos := x
RETURN ret

*********** "”Ã≈ƒ’¿›≈≈" ”Ãœ◊œ
static function te_nextWord(pos, line, newpos)
local ret:="", x, y, i, str, e:=.t., ch
	pos := iif(pos==NIL, ::pos, pos)
	line := iif(line==NIL, ::line, line)
	if valtype(line) == "N"
		::__check_line(line)
		str := ::edbuffer[line]
	else
		str := line
	endif
	for i:=pos to len(str)
		ch:= substr(str, i, 1)
		if !isalpha(ch) .and. !isdigit(ch) .and. ch != "_"
			pos := i
			exit
		endif
	next
	x := len(str)
	y := len(str)
	for i:=pos+1 to len(str)
		ch:= substr(str, i, 1)
		if e .and. (isalpha(ch) .or. isdigit(ch) .or. ch == "_")
			x := i
			y := len(str)+1
			e := .f.
		elseif !e .and. !(isalpha(ch) .or. isdigit(ch) .or. ch == "_")
			y := i
			exit
		endif
	next
	ret := substr(str, x, y-x)
	newpos := x
RETURN ret

****************** –œ…”À ”‘“’À‘’“Ÿ –œ –“¡◊…Ã¡Õ Clipper
static function te_matchStruct(curword, forward, undo)
local found:=.f., f_found, prevword, nextword, ind:=0, arr:={}, i, cnt:=0, cntoth:=0
local clip_synt_beg, clip_synt_end, clip_synt_loop, word
local si, ei, ss, is_beg:=.f., is_end:=.f., is_loop:=.f., is, o_com:=0
local pat_beg:="", pat_end:="", pat_loop:="", str, ch, r
memvar st
private st
	forward := iif(forward==NIL, .t., forward)
	undo := iif(undo==NIL, .t., .f.)
	if undo
		::writeundo(HASH_FIND, -1)
	endif
	clip_synt_beg := {"(DO WHILE)|(WHILE)",;
			  "(BEGIN SEQUENCE)",;
			  "(FOR)",;
			  "(IF)",;
			  "(DO CASE)"}
	clip_synt_end := {"(END)|(ENDDO)", ;
			  "(END SEQUENCE)",;
			  "(NEXT)",;
			  "(END)|(ENDIF)",;
			  "(END)|(ENDCASE)"}
	clip_synt_loop := {"(EXIT)|(LOOP)",;
			   "(BREAK)|(RECOVER)",;
			   "(EXIT)|(LOOP)",;
			   "(ELSEIF)|(ELSE)",;
			   "(CASE)|(OTHERWISE)|(EXIT)"}
	::__check_line(::line)
	st := ::pos
	curword := upper(curword)
	prevword := upper(::prevWord())
	nextword := upper(::nextWord())
	if empty(curword) .and. ! empty(prevword)
		curword := prevword
	endif
	do case
		case curword == "DO"
			curword += " "+nextword
			st += len(nextword)
		case curword == "WHILE"
			curword := "DO "+curword
		case curword == "CASE" .and. prevword == "DO"
			curword := "DO "+curword
		case curword == "BEGIN" .and. nextword == "SEQUENCE"
			curword += " "+nextword
			st += len(nextword)
		case curword == "SEQUENCE" .and. prevword == "BEGIN"
			curword := prevword+" "+curword
	endcase
	for i=1 to len(clip_synt_beg)
		is := search(clip_synt_beg[i], curword) .and. search(curword, clip_synt_beg[i])
		pat_beg += clip_synt_beg[i] + "|"
		if is
			ind := i
			is_beg := .t.
		endif
	next
	for i=1 to len(clip_synt_end)
		is := search(clip_synt_end[i], curword) .and. search(curword, clip_synt_end[i])
		pat_end += clip_synt_end[i] + "|"
		if is
			ind := i
			is_end := .t.
		endif
	next
	for i=1 to len(clip_synt_loop)
		is := search(clip_synt_loop[i], curword) .and. search(curword, clip_synt_loop[i])
		pat_loop += clip_synt_loop[i] + "|"
		if is .and. !(is_beg .or. is_end)
			ind := i
			is_loop := .t.
		endif
	next
	pat_beg := left(pat_beg, len(pat_beg)-1)
	pat_end := left(pat_end, len(pat_end)-1)
	pat_loop := left(pat_loop, len(pat_loop)-1)

	if !(is_beg .or. is_end .or. is_loop)
		return found
	endif

	if is_beg
		forward := .t.
		cnt ++
	elseif is_end
		forward := .f.
		cnt --
		if curword == "END"
			ind := 1
			clip_synt_beg[ind] := "(DO WHILE)|(WHILE)|(DO CASE)|(IF)"
			clip_synt_end[ind] := "(END)|(ENDDO)|(ENDIF)|(ENDCASE)"
			clip_synt_loop[ind] := "(EXIT)|(LOOP)|(ELSE)|(ELSEIF)"
		endif
	else
		cnt += iif(forward, 1, -1)
		do case
		case curword == "EXIT"
			ind := 1
			clip_synt_beg[ind] := "(DO WHILE)|(WHILE)|(FOR)|(DO CASE)"
			clip_synt_end[ind] := "(END)|(ENDDO)|(NEXT)|(ENDCASE)"
			clip_synt_loop[ind] := "(EXIT)|(LOOP)|(CASE)|(OTHERWISE)"
		case curword == "LOOP"
			ind := 1
			clip_synt_beg[ind] := "(DO WHILE)|(FOR)"
			clip_synt_end[ind] := "(END)|(ENDDO)|(NEXT)"
			clip_synt_loop[ind] := "(EXIT)|(LOOP)"
		endcase
	endif
	if forward
		si := ::line
		ei := ::lines
		ss := 1
	else
		si := ::line
		ei := 1
		ss := -1
	endif
	f_found := .f.
	for i:=si to ei step ss
		if !forward
			r := -(len(::edbuffer[i]) - st + 1)
		else
			r := len(::edbuffer[i])
		endif
		asize(arr, 0)

		str := upper(::edbuffer[i])

		if search("//", str, arr, st, r)
			str := substr(str, 1, arr[1][1])
			asize(arr, 0)
		endif
		do while search('".+"', str, arr)
			str := substr(str, 1, arr[1][1])+replicate(".", arr[1][2]-arr[1][1])+substr(str, arr[1][2])
			asize(arr, 0)
		enddo
		do while search("'.+'", str, arr)
			str := substr(str, 1, arr[1][1])+replicate(".", arr[1][2]-arr[1][1])+substr(str, arr[1][2])
			asize(arr, 0)
		enddo
		if search("/[*]", str, arr, st, r)
			o_com ++
			if search("[*]/", str, arr, arr[1][1]+1, r+arr[1][1])
				o_com --
				str := substr(str, 1, arr[1][1]-1)+padl(substr(str, arr[2][2]), arr[2][2]-arr[1][1])
			else
				str := substr(str, 1, arr[1][1]-1)
			endif
		elseif search("[*]/", str, arr, st, r)
			o_com --
			if search("/[*]", str, arr, arr[1][1], r+arr[1][1])
				o_com ++
				str := substr(str, 1, arr[2][1])+padl(substr(str, arr[1][1]), arr[1][1]-arr[2][1]+1)
			else
				str := padl(substr(str, arr[1][2]), len(str))
			endif
		endif
		asize(arr, 0)

		if substr(alltrim(str), 1, 1) == "*"
			st := 0
			loop
		endif

		if len(alltrim(str)) == 0// .or. o_com > 0
			st := 0
			loop
		endif
		if !forward .and. st == 0
			st := len(str)+1
		endif
		word := upper(iif(forward, ::nextWord(st, str, @st), ::prevWord(st, str, @st)))
		while !empty(word)
			found := .f.
			do case
				case word == "DO"
					nextword := upper(::nextWord(st,str))
					word += " "+nextword
					st += iif(forward, len(nextword)-1, -1)
				case word == "WHILE"
					word := "DO "+word
					st += iif(upper(::prevWord(st, str)) == "DO", -3, 0)
				case word == "CASE" .and. upper(::prevWord(st, str)) == "DO"
					word := "DO "+word
					st -= 3
				case word == "BEGIN" .and. upper(::nextWord(st, str)) == "SEQUENCE"
					word += " SEQUENCE"
					st += 8
				case word == "SEQUENCE" .and. upper(::prevWord(st, str)) == "BEGIN"
					word := "BEGIN "+word
					st -= 6
			endcase
			if search(clip_synt_beg[ind], word) .and. search(word, clip_synt_beg[ind])
				cnt ++
				found := .t.
			elseif search(clip_synt_end[ind], word) .and. search(word, clip_synt_end[ind])
				cnt --
				found := .t.
			elseif search(clip_synt_loop[ind], word) .and. search(word, clip_synt_loop[ind])
				if cntoth == 0 .and. between(cnt, -1, 1)
					cnt += iif(forward, -1, 1)
				endif
				found := .t.
			elseif search(pat_beg, word) .and. search(word, pat_beg)
				cntoth ++
			elseif search(pat_end, word) .and. search(word, pat_end)
				cntoth --
			elseif search(pat_loop, word) .and. search(word, pat_loop)
				found := .t.
			endif

			if found .and. cntoth == 0 .and. cnt == 0 .and. o_com == 0
				f_found := .t.
				exit
			endif
			st += iif(forward, len(word), -1)
			word := upper(iif(forward, ::nextWord(st, str, @st), ::prevWord(st, str, @st)))
		enddo
		if f_found
			::__findR[1]:= i
			::__findR[2]:= st
			::__findR[3]:= len(word)
			found := .t.
			::rowWin += i - ::line
			::line := i
			::colWin += st - ::pos
			::pos := st
			exit
		endif
		st := 0
	next


	if undo
		::refresh()
	endif
return found

*********** –œ…”À –¡“Œœ«œ/…ƒ≈Œ‘…ﬁŒœ«œ ”…Õ◊œÃ¡
static function te_Identity(symb, forward, undo)
local found := .f., dbl:=.f.
local i, j:=0, x, str1, str2, cnt:=0, ipos, iline, char, invchar, c
	symb := ""
	if ::line > ::lines
		return .f.
	endif
	forward := iif(forward==NIL, .t., forward)
	undo := iif(undo==NIL, .t., undo)
	if undo
		::writeundo(HASH_FIND, -1)
	endif
	i := ::pos
	str1 := "({[<"
	str2 := ")}]>"

	char := substr(::edbuffer[::line], ::pos, 1)

	j := at(char, str1)
	if j > 0
		invchar := substr(str2, j, 1)
		dbl := .t.
		cnt := 1
	else
		j := at(char, str2)
		if j > 0
			invchar := substr(str1, j, 1)
			dbl := .t.
			forward := !forward
			cnt := 1
		else
			invchar := char
		endif
	endif
	symb := invchar
	if dbl
		if forward
			i ++
			for j:=::line to ::lines
				for x:=i to len(::edbuffer[j])
					c := substr(::edbuffer[j], x, 1)
					if c == char
						cnt ++
						loop
					endif
					if c == invchar
						cnt --
					endif
					if cnt == 0
						ipos := x
						iline := j
						found := .t.
						exit
					endif
				next
				if found
					exit
				endif
				i := 1
			next
		else
			i--
			for j:=::line to 1 step -1
				for x:=i to 1 step -1
					c := substr(::edbuffer[j], x, 1)
					if c == char
						cnt ++
						loop
					endif
					if c == invchar
						cnt --
					endif
					if cnt == 0
						ipos := x
						iline := j
						found := .t.
						exit
					endif
				next
				if found
					exit
				endif
				if j-1 > 0
					i := len(::edbuffer[j-1])
				endif
			next
		endif
	else
		if forward
			i ++
			for j:=::line to ::lines
				for x:=i to len(::edbuffer[j])
					if substr(::edbuffer[j], x, 1) == char
						ipos := x
						iline := j
						found := .t.
						exit
					endif
				next
				if found
					exit
				endif
				i := 1
			next
		else
			i --
			for j:=::line to 1 step -1
				for x:=i to 1 step -1
					if substr(::edbuffer[j], x, 1) == char
						ipos := x
						iline := j
						found := .t.
						exit
					endif
				next
				if found
					exit
				endif
				if j-1 > 0
					i := len(::edbuffer[j-1])
				endif
			next
		endif
	endif
	if found
		::__findR[1] := iline   //line
		::__findR[2] := ipos    //start pos
		::__findR[3] := 1               //length
		::gotoPos(ipos, .f.)
		::gotoLine(iline, .f.)
		if undo
			::refresh()
		endif
	endif
return found
**********************************
static function stripSpace(str, pos)
local arr:={}
	while search("  ", str, arr, pos)
		if arr[1][2] - arr[1][1] > 1
			str := substr(str, 1, arr[1][1]-1)+" "+substr(str, arr[1][2])
		endif
		arr := {}
	enddo
return str

**********************************
static function te_Frmt(str, len, s1, s2, spl, firstPos)
local x, y, a1, a2, let, p, i
	x := len
	y := len
	let := "[¡≈…œ’Ÿ‹¿—aeiouy]"
	spl := iif(spl==NIL, .f., .t.)
	firstPos := iif(firstPos==NIL, 0, firstPos)
	if isalpha(substr(str, len, 1)) .or. isdigit(substr(str, len, 1)) .or. isdigit(::curword(len, str))
		/* ≈”Ã… Œ’÷≈Œ –≈“≈Œœ” ◊ ”Ãœ◊¡» */
		if spl .and. !isdigit(::curword(len, str))
			p := .t.
		else
			p := .f.
		endif
		s1 := substr(str, 1, len-1)
		s2 := substr(str, len)
		x := len(s1)
		for i:=len-1 to 1 step -1
			if !isalpha(substr(s1, i, 1)) .and. !isdigit(substr(s1, i, 1)) .and. !isdigit(::curword(len, s1))
				x := i
				exit
			endif
		next
		y := 0
		for i:=1 to len(s2)
			if !isalpha(substr(s2, i, 1)) .and. !isdigit(substr(s2, i, 1)) .and. !isdigit(::curword(len, s2))
				y := i
				exit
			endif
		next
		a1 := {}
		a2 := {}
		while (y < 1 .or. !(search(let, substr(s2, 1, y), a2) .and. search("([a-z]+)([¡-—]+)", substr(s2, 1, y), a2) )) .and. (len(s1)-x > 1)//(len(s1)-x >= 2)
			s2 := substr(s1, len(s1), 1) + s2
			s1 := substr(s1, 1, len(s1)-1)
			y ++
		enddo
		p := p .and. (len(s1)-x>1)
		p := p .and. search(let, substr(s1, x), a1)
		//p := p .and. search(let, substr(s2, 1, y), a2)

		if p
			s1 += "-"
		else
			s2 := substr(s1, x+1) + s2
			s1 := substr(s1, 1, x)
		endif
	else
		s1 := substr(str, 1, len)
		s2 := ltrim(substr(str, len+1))
	endif
	x := len - len(s1)
	s1 := rtrim(s1)
	/* ◊”‘¡◊…‘ÿ –“œ¬≈ÃŸ ƒÃ— ◊Ÿ“¡◊Œ…◊¡Œ…— ƒÃ…ŒŸ ”‘“œÀ… */
	if spl .and. x > 0 .and. !empty(s2)
		y := len(s1)
		for i:= 1 to x
			y := rat(" ", substr(s1, 1, y))
			if y > firstPos .and. y > 0
				y --
				s1 := substr(s1, 1, y)+" "+substr(s1, y+1)
			else
				y := len(s1)
			endif
		next
	endif
	s2 := alltrim(s2)
return


*********** ∆œ“Õ¡‘…“œ◊¡Œ…≈ ”‘“œÀ…
static function te_formatLine(lAutoMargin, nMarginLeft, nMarginRight, nTabSize, lHyphen, undo)
local s1, s2, firstPos
	undo := iif(undo==NIL, .t., undo)

	lAutoMargin := iif(lAutoMargin==NIL, .t., lAutoMargin)
	nMarginLeft := iif(nMarginLeft==NIL, ::MarginLeft, nMarginLeft)
	nMarginRight := iif(nMarginRight==NIL, ::MarginRight, nMarginRight)
	nTabSize := iif(nTabSize==NIL, ::TabSize, nTabsize)
	lHyphen := iif(lHyphen==NIL, ::Hyphen, lHyphen)

	::__check_line(::line+1)
	if undo
		::writeundo(HASH_FRLINE, ::edbuffer[::line])
	endif

	if lAutoMargin
		firstPos := nMarginLeft
	else
		firstPos := len(::edbuffer[::line])-len(ltrim(::edbuffer[::line]))
		firstPos := iif(firstPos == 1, nTabSize, firstPos)
	endif

	::edbuffer[::line] := stripSpace(::edbuffer[::line], 1)
	::edbuffer[::line] := replicate(" ", FirstPos) + ltrim(::edbuffer[::line])
	::__Frmt(::edbuffer[::line], nMarginRight, @s1, @s2, lHyphen, firstPos)

	::lines += 1
	asize(::edbuffer, ::lines)
	ains(::edbuffer, ::line+1)
	::edbuffer[::line] := s1
	::edbuffer[::line+1] := s2

	::updated := .t.
	if undo
		::refresh()
	endif
RETURN

*********** ∆œ“Õ¡‘…“œ◊¡Œ…≈ ¡¬⁄¡√¡
static function te_formatPart(lAutoMargin, nMarginLeft, nMarginRight, nTabSize, lHyphen, undo)
local i, s1, s2, line, st, en, arr:={}, firstPos1, firstPos2, len

	undo := iif(undo==NIL, .t., undo)

	lAutoMargin := iif(lAutoMargin==NIL, .t., lAutoMargin)
	nMarginLeft := iif(nMarginLeft==NIL, ::MarginLeft, nMarginLeft)
	nMarginRight := iif(nMarginRight==NIL, ::MarginRight, nMarginRight)
	nTabSize := iif(nTabSize==NIL, ::TabSize, nTabsize)
	lHyphen := iif(lHyphen==NIL, ::Hyphen, lHyphen)

	line := ::line
	::__check_line(line+1)
	len := nMarginRight     //length string
	/* start part */
	st := ::line

	firstPos1 := len(::edbuffer[::line])-len(ltrim(::edbuffer[::line]))
	firstPos2 := len(::edbuffer[::line+1])-len(ltrim(::edbuffer[::line+1]))

	/* end part */
	en := ::line
	while en+1 <= ::lines
		if firstPos2 != len(::edbuffer[en+1])-len(ltrim(::edbuffer[en+1]))
			exit
		endif
		aadd(arr, ::edbuffer[en])
		::edbuffer[line] += " " + ::edbuffer[en+1]
		en ++
	enddo
	aadd(arr, ::edbuffer[en])

	if undo
		::writeundo(HASH_FRPART, arr)
	endif

	if lAutoMargin
		firstPos1 := nMarginLeft
		firstPos2 := 0
	endif

	line := st
	::edbuffer[line] := stripSpace(::edbuffer[line], firstPos1)
	while line <= en
		s1 := ""
		s2 := ""
		if line == st
			::edbuffer[line] := replicate(" ", firstPos1) + ltrim(::edbuffer[line])
			::__Frmt(::edbuffer[line], nMArginRight, @s1, @s2, lHyphen, firstPos1)
		else
			::edbuffer[line] := replicate(" ", firstPos2) + ltrim(::edbuffer[line])
			::__Frmt(::edbuffer[line], nMarginRight, @s1, @s2, lHyphen, firstPos2)
		endif
		::__Frmt(::edbuffer[line], nMarginRight, @s1, @s2, lHyphen)
		::__check_line(line+1)
		::edbuffer[line] := s1
		if line == en
			::lines ++
			asize(::edbuffer, ::lines)
			ains(::edbuffer, line+1)
			::edbuffer[line+1] := replicate(" ", firstPos2) + s2
		else
			::edbuffer[line+1] := ltrim(s2)
		endif
		line ++
		if (line > en) .and. (len(::edbuffer[line]) > len)
			en ++
		endif
	enddo

	::pos := 1
	::line := line
	::updated := .t.
	if undo
		::refresh()
	endif
RETURN

*********** ∆œ“Õ¡‘…“œ◊¡Œ…≈  –œ –“¡◊…Ã¡Õ clipper
static function te_insTempl(targ, undo)
local i, j, p, target, start, en, spl
	undo := iif(undo==NIL, .t., undo)

	if ::line > ::lines
		::__check_line(::line)
	endif
	p := ::pos
	while p>0 .and. empty(substr(::edbuffer[::line], p, 1))
		p--
	enddo
	start := p
	en := p
	for i:= start-1 to 1 step -1
		if substr(::edbuffer[::line], i, 1) == " "
			exit
		endif
	next
	start := i+1
	for i:= en+1 to len(::edbuffer[::line])
		if substr(::edbuffer[::line], i, 1) == " "
			exit
		endif
	next
	en := i+1
	target := upper(alltrim(substr(::edbuffer[::line], start, en-start+1)))
	if empty(target)
		return
	endif
	if target $ targ
		spl := split(targ[target], "/")
		if undo
			::writeundo(HASH_INSTEMPL, {::edbuffer[::line], len(spl)})
		endif
		::edbuffer[::line] := substr(::edbuffer[::line], 1, start-1) + spl[1] + substr(::edbuffer[::line], en)

		for j := 2 to len(spl)
			::lines++
			asize(::edbuffer, ::lines)
			ains(::edbuffer, ::line+j-1)
			::edbuffer[::line+j-1] := replicate(" ", start-1) + spl[j]
		next
		::gotoPos(len(::edbuffer[::line])+1, .f.)
		::refresh()
	endif
RETURN

***********
static function te_insMacro(targ, undo)
local i, j, p, target, start, en
	undo := iif (undo==NIL, .t., undo)
	if ::line > ::lines
		::__check_line(::line)
	endif
	p := ::pos
	while p>0 .and. empty(substr(::edbuffer[::line], p, 1))
		p--
	enddo
	start := p
	en := p
	for i:= start-1 to 1 step -1
		if substr(::edbuffer[::line], i, 1) == " "
			exit
		endif
	next
	start := i+1
	for i:= en+1 to len(::edbuffer[::line])
		if substr(::edbuffer[::line], i, 1) == " "
			exit
		endif
	next
	en := i+1
	target := upper(alltrim(substr(::edbuffer[::line], start, en-start+1)))
	if empty(target)
		return
	endif
	if target $ targ
			if undo
				::writeUndo(HASH_INSMACRO, ::edbuffer[::line])
			endif
			::edbuffer[::line] := left(::edbuffer[::line], start-1);
			    + ToString(&(targ[target])) + substr(::edbuffer[::line], en)
			::gotoPos(start+len(ToString(&(targ[target])))+1, .f.)
			::refresh()
	endif
RETURN


***********
static function te_delWordLeft()
RETURN

***********
static function te_delWordRight()
RETURN


***************************************************
static function te_saveFile( filename, createbak )
local nfile, nbakfile, i, n, str, scr, newf, error
  //save screen to scr
  scr := saveScreen(0,0,maxRow(),maxCol(),.F.)
  if empty(filename)
	filename := ::FileName
  endif
  filename := alltrim(filename)
  createbak := iif(createbak==NIL, .f., createbak)
  @ maxrow(), 0 say padr([Save file...], maxcol()) color "0/7"
  inkey()
  newf := !(file(filename))
  /* create new or truncate to 0 exists file */

  BEGIN SEQUENCE

  ERRORBLOCK({|e| alert(e:description+";"+[file ;]+e:args[2])})

  if !empty(createbak) .and. createbak .and. !newf
	nbakfile := __copyFile(filename, filename+".bak")
	if !nbakfile
		alert([Can't create ;]+filename+[.bak file], "OK")
	endif
  endif
  RECOVER USING error
	outlog(__FILE__, __LINE__, error:description, error:operation, error:args)
  ENDSEQUENCE
  if newf
	nfile:=fcreate(filename, FO_READWRITE)
  else
	nfile:=fopen(filename, FO_READWRITE+FO_TRUNC)
  endif
  if nfile<0
     //restore screen from scr
     restScreen(0, 0, maxRow(), maxCol(), scr)
     return .f.
  endif
  if ::charset == NIL
	if ::tabPack
	for i=1 to ::lines
		n := len(::edbuffer[i])-len(ltrim(::edbuffer[i]))
		str := tabpack(padr(::edbuffer[i], n), ::tabSize)+ ;
			ltrim(::edbuffer[i])+"&\n"
		fwrite(nfile, str, len(str))
	next
	else
	for i=1 to ::lines
		str := ::edbuffer[i]+"&\n"
		fwrite(nfile, str, len(str))
	next
	endif
  else
	if ::tabPack
	for i=1 to ::lines
		//str := tabpack(::edbuffer[i], ::tabSize)
		n := len(::edbuffer[i])-len(ltrim(::edbuffer[i]))
		str := tabpack(padr(::edbuffer[i], n), ::tabSize)+ ;
			ltrim(::edbuffer[i])
		str := translate_charset(::__hostcharset, ::charset, str)+"&\n"
		fwrite(nfile, str, len(str))
	next
	else
	for i=1 to ::lines
		str := ::edbuffer[i]
		str := translate_charset(::__hostcharset, ::charset, str)+"&\n"
		fwrite(nfile, str, len(str))
	next
	endif
  endif
  fclose(nfile)
  ::updated:=.f.
  restore screen from scr
  //restScreen(0, 0, maxRow(), maxCol(), scr)
RETURN .t.

***************************************************
static function te_saveString()
  local i, n, str:=""
  if ::charset == NIL
	if ::tabPack
	for i=1 to ::lines
		n := len(::edbuffer[i])-len(ltrim(::edbuffer[i]))
		str += tabpack(padr(::edbuffer[i], n), ::tabSize)+ ;
			ltrim(::edbuffer[i])+"&\n"
	next
	else
	for i=1 to ::lines
		str += ::edbuffer[i]+"&\n"
	next
	endif
  else
	if ::tabPack
	for i=1 to ::lines
		n := len(::edbuffer[i])-len(ltrim(::edbuffer[i]))
		str += translate_charset(::__hostcharset, ::charset, ;
			    tabpack(padr(::edbuffer[i], n), ::tabSize)+ ;
			    ltrim(::edbuffer[i]))+"&\n"
	next
	else
	for i=1 to ::lines
		str += translate_charset(::__hostcharset, ::charset, ::edbuffer[i])+"&\n"
	next
	endif
  endif
  ::updated:=.f.
RETURN str

*********** ⁄¡–…”ÿ ¬ÃœÀ¡ Œ¡ ƒ…”À
static function te_saveBlock( fileName, createbak )
local nfile, nbakfile, i, n, str, scr, ps, pl
  save screen to scr
  filename := alltrim(filename)
  createbak := iif(createbak==NIL, .f., createbak)
  @ maxrow(), 0 say padr([Save block to file...], maxcol()) color "0/7"
  inkey()
  /* create new or truncate to 0 exists file */
  if !empty(createbak) .and. createbak
	nbakfile := frename(filename, filename+".bak")
	if nbakfile < 0
		alert([Can't create ;]+filename+[.bak file], "OK")
	endif
  endif
  nfile:=fcreate(filename, 1)
  if nfile<0
     restore screen from scr
     return .f.
  endif
  if ::strblock
	if ::charset ==NIL
		if ::tabPack
		for i=min(::koordblock[1], ::koordblock[3]) to max(::koordblock[1], ::koordblock[3])
			n := len(::edbuffer[i])-len(ltrim(::edbuffer[i]))
			str := tabpack(padr(::edbuffer[i], n), ::tabSize)+ ;
				ltrim(::edbuffer[i])+"&\n"
			fwrite(nfile, str, len(str))
		next
		else
		for i=min(::koordblock[1], ::koordblock[3]) to max(::koordblock[1], ::koordblock[3])
			str := ::edbuffer[i]+"&\n"
			fwrite(nfile, str, len(str))
		next
		endif
	else
		if ::tabPack
		for i=min(::koordblock[1], ::koordblock[3]) to max(::koordblock[1], ::koordblock[3])
			n := len(::edbuffer[i])-len(ltrim(::edbuffer[i]))
			str := tabpack(padr(::edbuffer[i], n), ::tabSize)+ ;
				ltrim(::edbuffer[i])
			str := translate_charset(::__hostcharset, ::charset, str)+"&\n"
			fwrite(nfile, str, len(str))
		next
		else
		for i=min(::koordblock[1], ::koordblock[3]) to max(::koordblock[1], ::koordblock[3])
			str := translate_charset(::__hostcharset, ::charset, ::edbuffer[i])+"&\n"
			fwrite(nfile, str, len(str))
		next
		endif
	endif
  else
	ps := min(::koordblock[2], ::koordblock[4])
	pl := max(::koordblock[2], ::koordblock[4]) - ps +1
	if ::charset == NIL
		for i=min(::koordblock[1], ::koordblock[3]) to max(::koordblock[1], ::koordblock[3])
			//str := tabpack(::edbuffer[i], ::tabSize)
			str := substr(::edbuffer[i], ps, pl)+"&\n"
			fwrite(nfile, str, len(str))
		next
	else
		for i=min(::koordblock[1], ::koordblock[3]) to max(::koordblock[1], ::koordblock[3])
			//str := tabpack(::edbuffer[i], ::tabSize)
			str := translate_charset(::__hostcharset, ::charset, substr(::edbuffer[i], ps, pl))+"&\n"
			fwrite(nfile, str, len(str))
		next
	endif
  endif
  fclose(nfile)
  ::updated:=.f.
  restore screen from scr
RETURN .t.

*********** ⁄¡«“’⁄À¡ ¬ÃœÀ¡ ” ƒ…”À¡
static function te_loadBlock(filename, undo)
local nfile, i, path
	undo := iif(undo==NIL, .t., undo)
	filename := alltrim(filename)
	nfile := fopen(filename)
	if nfile < 0
		//messagep("Can't open file ;"+filename)
		return .f.
	endif
	if ::charset==NIL
		i:=atr(PATH_DELIM,filename)
		if i!=0
			path:=left(filename,i-1)
		endif
		::__check_clipchs(path)
	endif
	i := ::line
	if ::charset == NIL
		while !fileeof(nfile)
			::lines ++
			asize(::edbuffer, ::lines)
			ains(::edbuffer, i)
			::edbuffer[i] := tabexpand(filegetstr(nfile, TE_MAX_LEN_STRING), ::tabSize)
			i++
		enddo
	else
		while !fileeof(nfile)
			::lines ++
			asize(::edbuffer, ::lines)
			ains(::edbuffer,  i)
			::edbuffer[i] := translate_charset(::charset, ::__hostcharset,tabexpand(filegetstr(nfile, TE_MAX_LEN_STRING), ::tabSize), i)
			i++
		enddo
	endif
	fclose(nfile)
	if undo
		::writeundo(HASH_LOADBLOCK, {::line, i-1})
	endif
	::strblock := .t.
	::rectblock := .f.
	::koordblock[1] := ::line
	::koordblock[3] := i - 1
	::updated := .t.
	if undo
		::refresh()
	endif
RETURN .t.

*********** Àœ–…“œ◊¡‘ÿ ¬ÃœÀ
static function te_copyBlock(mov, undo)
local i, lenbuf, stbl, endbl, rightbl, leftbl, rowblock, buf, colblock

    undo := iif(undo==NIL, .t., undo)
    if !::strblock .and. !::rectblock
	 return .F.
    endif
    if mov == NIL   // –≈“≈Õ≈”‘…‘ÿ ¬ÃœÀ
	mov := .f.
    endif
    if ::strblock
	stbl := min(::koordblock[1], ::koordblock[3])
	endbl := min(max(::koordblock[1], ::koordblock[3]), ::lines)
	rowblock := endbl-stbl+1

	buf := {}
	for i=stbl to endbl
		aadd(buf, ::edbuffer[i])
	next

	if undo
		::writeundo(iif(mov, HASH_MVBL, HASH_CPBL), buf)
	endif
	::line := ::__check_line(::line, .f.)

	if mov
	    for i=stbl to endbl
		adel(::edbuffer, stbl)
	    next
	    //::lines -= rowblock
	    //asize(::edbuffer, ::lines)
	    if ::line > stbl
		::line -= rowblock
	    endif
	else
	   if ::line>::lines
		::lines := rowblock+::line-1
	   else
		::lines += rowblock
	   endif
	   //::lines += rowblock+iif(::line>=::lines, -1, 0)
	   asize(::edbuffer, ::lines)
	endif


	for i=rowblock to 1 step -1
	    ains(::edbuffer, ::line)
	    ::edbuffer[::line] := buf[i]
	next

	::koordblock[1] := ::line
	::koordblock[3] := ::line+rowblock-1
    else
	stbl := min(::koordblock[1], ::koordblock[3])
	endbl := min(max(::koordblock[1], ::koordblock[3]), ::lines)
	::koordblock[1] := stbl
	::koordblock[3] := endbl
	rowblock := endbl-stbl+1

	leftbl := min(::koordblock[2], ::koordblock[4])
	rightbl := max(::koordblock[2], ::koordblock[4])
	::koordblock[2] := leftbl
	::koordblock[4] := rightbl
	colblock := rightbl-leftbl+1

	buf := {}
	for i=stbl to endbl
	    aadd(buf, padr(substr(::edbuffer[i], leftbl, colblock), colblock))
	    if mov
		::edbuffer[i] := substr(::edbuffer[i], 1, leftbl-1);
			       + substr(::edbuffer[i], rightbl+1)
	    endif
	next

	if undo
		::writeundo(iif(mov, HASH_MVBL, HASH_CPBL), buf)
	endif

	lenbuf := len(buf)-1
	::line := ::__check_line(::line+rowblock-1, .f.)
	if ::pos > leftbl .and. mov
		::pos -= iif( ::pos-leftbl < colblock, -(::pos-leftbl-1), colblock)
	endif
	for i=0 to lenbuf
	     ::__check_line(::line+i, .f.)
	     ::edbuffer[::line+i] := padr(substr(::edbuffer[::line+i], 1, ::pos-1), ::pos-1) ;
				     + buf[i+1];
				     + substr(::edbuffer[::line+i], ::pos)
	next

	::koordblock[1] := ::line
	::koordblock[3] := ::line+rowblock-1
	::koordblock[2] := ::pos
	::koordblock[4] := ::pos+colblock-1
    endif
    ::updated := .t.
    if undo
	::refresh()
    endif
RETURN .T.

*********** –≈“≈Õ≈”‘…‘ÿ ¬ÃœÀ
static function te_moveBlock(undo)
    undo := iif(undo==NIL, .t., undo)

RETURN ::copyBlock(.t., undo)

*********** ’ƒ¡Ã…‘ÿ ¬ÃœÀ
static function te_deleteBlock(undo)
local rowblock, rightbl, leftbl, stbl, endbl, i, unarr:={}
    undo := iif(undo==NIL, .t., undo)
    if !::strblock .and. !::rectblock
	 return .f.
    endif
    if ::strblock
	stbl := min(::koordblock[1], ::koordblock[3])
	endbl := max(::koordblock[1], ::koordblock[3])
	if endbl>::lines
		endbl := ::lines
	endif
	rowblock := endbl-stbl+1
	if undo
		for i=stbl to endbl
			aadd(unarr, ::edbuffer[i])
		next
		::writeundo(HASH_DELBL, unarr)
	endif
	for i=stbl to endbl
	    adel(::edbuffer, stbl)
	next
	::lines -= rowblock
	asize(::edbuffer, ::lines)
	if ::line-::rowWin > stbl
		::rowWin := 1
	else
		::rowWin -= ::line-stbl
	endif
	::line := stbl
	::pos := 1
    else
	stbl := min(::koordblock[1], ::koordblock[3])
	endbl := max(::koordblock[1], ::koordblock[3])
	leftbl := min(::koordblock[2], ::koordblock[4])
	rightbl := max(::koordblock[2], ::koordblock[4])
	if endbl>::lines
		endbl := ::lines
	endif
	if undo
		for i=stbl to endbl
			aadd(unarr, substr(::edbuffer[i], leftbl, rightbl-leftbl+1))
		next
		::writeundo(HASH_DELBL, unarr)
	endif

	for i=stbl to endbl
	    ::edbuffer[i] := substr(::edbuffer[i], 1, leftbl-1);
			   + substr(::edbuffer[i], rightbl+1)
	next

	if ::line-::rowWin > stbl
		::rowWin := 1
	else
		::rowWin -= ::line - stbl
	endif
	::line := stbl
	::pos := leftbl
    endif
    ::cancelblock()
    ::updated := .t.
    if undo
	::refresh()
    endif
RETURN .t.

*********** Œ¡ﬁ¡‘ÿ œ‘Õ≈‘À’ ¬ÃœÀ¡
static function te_beginBlock( vid, undo )
    undo := iif(undo==NIL, .t., undo)
    vid := iif(vid==NIL, .t., vid)
    if undo
	::writeundo(HASH_BEGBLOCK)
    endif
    afill(::koordblock, NIL)
    ::cancelBlock()
    ::mkblock := .t.
    if vid
	::strblock := .t.
    else
	::rectblock := .t.
    endif
    ::koordblock[1] := ::line
    ::koordblock[2] := ::pos
    ::koordblock[3] := ::line
    ::koordblock[4] := ::pos
    if undo
	::refresh()
    endif
RETURN

*********** ⁄¡ÀœŒﬁ…‘ÿ œ‘Õ≈‘À’ ¬ÃœÀ¡
static function te_endBlock( vid )
    ::mkblock := .f.
    ::koordblock[3] := min(::koordblock[3], ::lines)
RETURN

*********** œ‘Õ≈Œ…‘ÿ œ‘Õ≈‘À’ ¬ÃœÀ¡
static function te_cancelBlock( undo )
    undo := iif (undo==NIL, .t., undo)
    ::mkblock := .f.
    ::strblock := .f.
    ::rectblock := .f.
    afill(::koordblock, NIL)
    asize(::__findR, 3)
    afill(::__findR, NIL)
    if undo
	::refresh()
    endif
RETURN

*********** œﬁ…”‘…‘ÿ ¬’∆≈“ … ƒœ¬¡◊…‘ÿ ‘’ƒ¡ ¬ÃœÀ
static function te_copyToClipboard( Clipboard )
    asize(Clipboard, 0)
    ::addToClipboard(@Clipboard)
RETURN

*********** ƒœ¬¡◊…‘ÿ ¬ÃœÀ ◊ ¬’∆∆≈“
static function te_addToClipboard(Clipboard)
    local i, j:=0, cb[2], nT, nL, nB, nR
    if ::strblock .or. ::rectblock
	cb[1] := iif(::strblock, .t., .f.)
	cb[2] := {}
	nT := min(::koordblock[1], ::koordblock[3])
	nB := max(::koordblock[1], ::koordblock[3])
	nL := min(::koordblock[2], ::koordblock[4])
	nR := max(::koordblock[2], ::koordblock[4])
	asize(cb[2], nB-nT+1)
	for i=nT to nB
		j++
		ains(cb[2], j)
		cb[2][j] := iif(::strblock, ::edbuffer[i], substr(::edbuffer[i], nL, nR-nL+1))
	next
	aadd(Clipboard, aclone(cb))
    endif
RETURN

*********** –≈“≈Œ≈”‘… ¬ÃœÀ ◊ ¬’∆∆≈“
static function te_moveToClipboard(Clipboard)
	::copyToClipboard(@Clipboard)
	::deleteBlock()
RETURN

*********** ◊”‘¡◊…‘ÿ ¬ÃœÀ …⁄ ¬’∆∆≈“¡
static function te_pasteFromClipboard( Clipboard, it, undo )
local i, j
	if empty(Clipboard)
		return .f.
	endif
	it := iif(it==NIL, 1, it)
	undo := iif(undo==NIL, .t., undo)
	if undo
		::writeundo(HASH_PASTCLB, Clipboard[it])
	endif
	::line := ::__check_line(::line, .f.)
	/* ◊”‘¡◊…‘ÿ ”‘“œﬁŒŸ  ¬ÃœÀ */
	if Clipboard[it][1]
		::lines += len(Clipboard[it][2])
		asize(::edbuffer, ::lines)
		::strblock := .t.
		::rectblock := .f.
		afill(::koordblock, NIL)
		::koordblock[1] := ::line
		::koordblock[2] := ::pos
		::koordblock[3] := ::line+len(Clipboard[it][2])-1
		::koordblock[4] := ::pos
		for i=1 to len(Clipboard[it][2])
			ains(::edbuffer, ::line+i-1)
			::edbuffer[::line+i-1] := Clipboard[it][2][i]
		next
	else /* ◊”‘¡◊…‘ÿ –“—Õœ’«œÃÿŒŸ  ¬ÃœÀ */
		::strblock := .f.
		::rectblock := .t.
		afill(::koordblock, NIL)
		::koordblock[1] := ::line
		::koordblock[2] := ::pos
		::koordblock[3] := ::line+len(Clipboard[it][2]) - 1
		::koordblock[4] := ::pos + len(Clipboard[it][2][1]) - 1
		for i=1 to len(Clipboard[it][2])
			::__check_line(::line+i-1)
			::edbuffer[::line+i-1] := padr(::edbuffer[::line+i-1], ::pos-1)+;
					Clipboard[it][2][i]+;
					substr(::edbuffer[::line+i-1], ::pos)
		next
	endif
	::updated := .t.
	if undo
		::refresh()
	endif
RETURN .t.

************ œ‘À¡‘ –œ”Ã≈ƒŒ…» ƒ≈ ”‘◊… 
static function te_undo()
local i, j, cmd, len, line, p
	if ::__curundo == ::__startundo
		return
	endif
	cmd := ::__undobuffer[::__curundo][U_CMD]
	for i=1 to ::__undobuffer[::__curundo][U_CYCLE]
		do case
		case cmd == HASH_UP
			::down(.f.)
		case cmd == HASH_DOWN
			::up(.f.)
		case cmd == HASH_CLEFT
			::right(.f.)
		case cmd == HASH_CRIGHT
			::left(.f.)
		case cmd == HASH_PGUP
			::pageDown(.f.)
		case cmd == HASH_PGDOWN
			::pageUp(.f.)
		case cmd == HASH_HOME
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_END
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_BOTOP
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_GOPOS
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_GOLINE
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
		case cmd == HASH_INS
			for j=1 to len(::__undobuffer[::__curundo][U_VALUE])
				::backspace(.f.)
			next
			//::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_OVR
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			::overStrike(::__undobuffer[::__curundo][U_VALUE],.f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_INSTAB
			::edbuffer[::__undobuffer[::__curundo][U_LINE]] := ::__undobuffer[::__curundo][U_VALUE]
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			//::overStrike(::__undobuffer[::__curundo][U_VALUE],.f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_OVRTAB
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_BS
			if ::__undobuffer[::__curundo][U_VALUE] == chr(K_ENTER)
				::insertLine(.f.)
			else
				::insert(::__undobuffer[::__curundo][U_VALUE], .f.)
			endif
		case cmd == HASH_DEL
			if ::__undobuffer[::__curundo][U_VALUE] == chr(K_ENTER)
				::insertLine(.f.)
				::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
				::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			else
				::insert(::__undobuffer[::__curundo][U_VALUE], .f.)
				::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			endif
		case cmd == HASH_DELEND
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			::edbuffer[::line] += ::__undobuffer[::__curundo][U_VALUE]
		case cmd == HASH_DELHOME
			::line := ::__undobuffer[::__curundo][U_LINE]
			::pos := ::__undobuffer[::__curundo][U_POS]
			::edbuffer[::line] := ::__undobuffer[::__curundo][U_VALUE]+::edbuffer[::line]
		case cmd == HASH_DELINE
			::insertLine(.f.)
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			::edbuffer[::__undobuffer[::__curundo][U_LINE]] := ::__undobuffer[::__curundo][U_VALUE]
		case cmd == HASH_INSLINE
			if len(::edbuffer) > 0
				::edbuffer[::__undobuffer[::__curundo][U_LINE]] := ::__undobuffer[::__curundo][U_VALUE]
				::deleteLine(.f.)
				::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
				::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			endif
		case cmd == HASH_NEWLINE
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_BEGBLOCK
			::cancelBlock(.f.)
		case cmd == HASH_DELBL .or. cmd == HASH_MVBL .or. cmd == HASH_CPBL
			if cmd != HASH_DELBL
				::deleteBlock(.f.)
			endif
			len := len(::__undobuffer[::__curundo][U_VALUE])
			line := min(::__undobuffer[::__curundo][U_BLOCK][2], ::__undobuffer[::__curundo][U_BLOCK][4])
			::gotoLine(line, .f.)
			if ::__undobuffer[::__curundo][U_BLOCK][1] == 1
				for j=1 to len
					::insertLine(.f.)
					::edbuffer[line+j-1] := ::__undobuffer[::__curundo][U_VALUE][j]
				next
			else
				for j=1 to len
					::__check_line(line+j-1)
					::edbuffer[line+j-1] := substr(::edbuffer[line+j-1], 1, ::__undobuffer[::__curundo][U_BLOCK][3]-1)+;
								::__undobuffer[::__curundo][U_VALUE][j] + substr(::edbuffer[line+j-1], ::__undobuffer[::__curundo][U_BLOCK][3])
				next
			endif
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			::lines := ::__undobuffer[::__curundo][U_LINES]
			asize(::edbuffer, ::__undobuffer[::__curundo][U_LINES])
		case cmd == HASH_PASTCLB
			::deleteBlock(.f.)
			::lines := ::__undobuffer[::__curundo][U_LINES]
			asize(::edbuffer, ::__undobuffer[::__curundo][U_LINES])
		case cmd == HASH_FIND
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_REPLACE
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			p := ::__undobuffer[::__curundo][U_VALUE]:fstring
			::__undobuffer[::__curundo][U_VALUE]:fstring := ::__undobuffer[::__curundo][U_VALUE]:rstring
			::__undobuffer[::__curundo][U_VALUE]:rstring := p
			::replace(::__undobuffer[::__curundo][U_VALUE], .f.)
		case cmd == HASH_CHECKLINE
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			asize(::edbuffer, ::__undobuffer[::__curundo][U_VALUE])
			::lines := ::__undobuffer[::__curundo][U_VALUE]
		case cmd == HASH_LOADBLOCK
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			for j=::__undobuffer[::__curundo][U_VALUE][1] to ::__undobuffer[::__curundo][U_VALUE][2]
				adel(::edbuffer, j)
			next
			::lines -= ::__undobuffer[::__curundo][U_VALUE][2] - ::__undobuffer[::__curundo][U_VALUE][1] + 1
			asize(::edbuffer, ::lines)
			::strblock := .f.
			::rectblock := .f.
		case cmd == HASH_FRLINE
			::lines -= 1
			::edbuffer[::__undobuffer[::__curundo][U_LINE]] := ::__undobuffer[::__curundo][U_VALUE]
			adel(::edbuffer, ::__undobuffer[::__curundo][U_LINE]+1)
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			asize(::edbuffer, ::lines)
		case cmd == HASH_FRPART
			p := 0
			for j:= ::line to ::__undobuffer[::__curundo][U_LINE] step -1
				adel(::edbuffer, j)
				p++
			next
			::lines -= p
			::lines += len(::__undobuffer[::__curundo][U_VALUE])
			asize(::edbuffer, ::lines)
			for j:=1 to len(::__undobuffer[::__curundo][U_VALUE])
				ains(::edbuffer, ::__undobuffer[::__curundo][U_LINE]+j-1)
				::edbuffer[::__undobuffer[::__curundo][U_LINE]+j-1] := ::__undobuffer[::__curundo][U_VALUE][j]
			next
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_DRAW
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			::edbuffer[::line] := stuff(::edbuffer[::line], ::pos+1, 1, ::__undobuffer[::__curundo][U_VALUE][1])
			::edbuffer[::line] := stuff(::edbuffer[::line], ::pos-1, 1, ::__undobuffer[::__curundo][U_VALUE][2])
			::edbuffer[::line-1] := stuff(::edbuffer[::line-1], ::pos, 1, ::__undobuffer[::__curundo][U_VALUE][3])
			::edbuffer[::line+1] := stuff(::edbuffer[::line+1], ::pos, 1, ::__undobuffer[::__curundo][U_VALUE][4])
			::edbuffer[::line] := stuff(::edbuffer[::line], ::pos, 1, ::__undobuffer[::__curundo][U_VALUE][5])
			::rowWin := ::__undobuffer[::__curundo][U_ROW]
			::colWin := ::__undobuffer[::__curundo][U_COL]
		case cmd == HASH_INSMACRO
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::edbuffer[::line] := ::__undobuffer[::__curundo][U_VALUE]
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_INSTEMPL
			for j=2 to ::__undobuffer[::__curundo][U_VALUE][2]
				::gotoLine(::__undobuffer[::__curundo][U_LINE]+1, .f.)
				::deleteLine(.f.)
			next
			::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
			::edbuffer[::line] := ::__undobuffer[::__curundo][U_VALUE][1]
			::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
		case cmd == HASH_INSAUTOWRAP .or. cmd == HASH_OVRAUTOWRAP
			if len(::edbuffer) > 0
				::gotoLine(::__undobuffer[::__curundo][U_LINE], .f.)
				for j=1 to ::__undobuffer[::__curundo][U_VALUE][1]
					::deleteLine(.f.)
				next
				::edbuffer[::__undobuffer[::__curundo][U_LINE]] := ::__undobuffer[::__curundo][U_VALUE][2]
				::gotoPos(::__undobuffer[::__curundo][U_POS], .f.)
			endif

		endcase
		//::rowWin := ::__undobuffer[::__curundo][U_ROW]
		//::colWin := ::__undobuffer[::__curundo][U_COL]
		if ::__undobuffer[::__curundo][U_BLOCK][1] > 0   //block
			if ::__undobuffer[::__curundo][U_BLOCK][1] == 1
				::strblock := .t.
			else
				::rectblock := .t.
			endif
			::koordblock[1] := ::__undobuffer[::__curundo][U_BLOCK][2]
			::koordblock[2] := ::__undobuffer[::__curundo][U_BLOCK][3]
			::koordblock[3] := ::__undobuffer[::__curundo][U_BLOCK][4]
			::koordblock[4] := ::__undobuffer[::__curundo][U_BLOCK][5]
		endif
		::mkblock := ::__undobuffer[::__curundo][U_MKBLOCK]
		::__findR[1] := ::__undobuffer[::__curundo][U_FIND][1]
		::__findR[2] := ::__undobuffer[::__curundo][U_FIND][2]
		::__findR[3] := ::__undobuffer[::__curundo][U_FIND][3]
	next
	::__curundo --
	if ::__curundo == 1 .and. ::__startundo > 0
		::__curundo := ::lenundo
	endif
	::refresh()
return

************ ”œ»“¡Œ≈Œ…≈ –œ”Ã≈ƒŒ…» ƒ≈ ”‘◊… 
static function te_writeundo( cmd, val )
local st[11], prev

	prev:=max(1, ::__curundo)
	if ::__undobuffer[prev] != NIL .and. ::__undobuffer[prev][U_CMD] == cmd .and. val==NIL//(val==NIL .or. val==::__undobuffer[prev][U_VALUE])
		::__undobuffer[prev][U_CYCLE] ++
		return
	endif
	if ::__curundo < 1
		::__curundo := 1
	else
		::__curundo ++
	endif
	if ::__curundo > ::lenundo
		::__curundo := 1
		::__startundo ++
	endif
	::__startundo += iif(::__startundo>0, 1, 0)
	if ::__startundo > ::lenundo
		::__startundo := 0
	endif
	st[U_CMD] := cmd
	st[U_CYCLE] := 1
	st[U_POS] := ::pos
	st[U_LINE] := ::line
	st[U_LINES] := ::lines
	st[U_COL] := ::colWin
	st[U_ROW] := ::rowWin
	st[U_VALUE] := ""
	st[U_BLOCK] := {0, 0, 0, 0, 0}
	st[U_FIND] := aclone(::__findR)
	st[U_MKBLOCK] := ::mkblock

	do case
	case cmd == HASH_INS
		if ::__undobuffer[prev] != NIL .and. !valtype(::__undobuffer[prev][U_VALUE]) $ "AO" .and. ::__undobuffer[prev][U_VALUE] == val
			::__undobuffer[prev][U_CYCLE] ++
			::__curundo := prev
			return
		endif
		st[U_VALUE] := val
	case cmd == HASH_OVR
		/*
		if ::__undobuffer[prev] != NIL .and. !valtype(::__undobuffer[prev][U_VALUE]) $ "AO" .and. ::__undobuffer[prev][U_VALUE] == val
			::__undobuffer[prev][U_CYCLE] ++
			::__curundo := prev
			return
		endif
		*/
		st[U_VALUE] := val
	case cmd == HASH_INSAUTOWRAP .or. cmd == HASH_OVRAUTOWRAP
		st[U_VALUE] := aclone(val)
	case cmd == HASH_BS .or. cmd == HASH_DEL
		st[U_VALUE] := val
	case cmd == HASH_DELINE .or. cmd == HASH_INSLINE
		st[U_VALUE] := val
	case cmd == HASH_DELEND .or. cmd == HASH_DELHOME
		st[U_VALUE] := val
	case cmd == HASH_DELBL .or. cmd == HASH_MVBL
		st[U_VALUE] := aclone(val)
	case cmd == HASH_PASTCLB
		st[U_VALUE] := aclone(val)
	case cmd == HASH_FIND
		st[U_VALUE] := val
	case cmd == HASH_REPLACE
		st[U_VALUE] := val
	case cmd == HASH_CHECKLINE
		st[U_VALUE] := val
	case cmd == HASH_LOADBLOCK
		st[U_VALUE] := aclone(val)
	case cmd == HASH_FRLINE
		st[U_VALUE] := val
	case cmd == HASH_FRPART
		st[U_VALUE] := aclone(val)
	case cmd == HASH_DRAW
		st[U_VALUE] := aclone(val)
	case cmd == HASH_INSMACRO
		st[U_VALUE] := val
	case cmd == HASH_INSTEMPL
		st[U_VALUE] := aclone(val)
	case cmd == HASH_INSTAB .or. cmd == HASH_OVRTAB
		st[U_VALUE] := val
	endcase
	if ::strblock .or. ::rectblock
		st[U_BLOCK][1] := iif(::strblock, 1, 2)
		st[U_BLOCK][2] := ::koordblock[1]
		st[U_BLOCK][3] := ::koordblock[2]
		st[U_BLOCK][4] := ::koordblock[3]
		st[U_BLOCK][5] := ::koordblock[4]
	endif
	if len(::__undobuffer)<1 .or. len(::__undobuffer)<::__curundo
	   aadd(::__undobuffer, aclone(st) )
	else
	   ::__undobuffer[::__curundo] := aclone(st)
	endif
return

****************** –”≈◊ƒœ«“¡∆…À¡ *********************************
static function te_around_check(around_char, R_Mode, L_Mode, U_Mode, D_Mode)
local ch, p
	::__check_line(::line)
	//::__check_line(::line-1)
	//::__check_line(::line+1)

	/* right */
	around_char[1] := substr(::edbuffer[::line], ::pos+1, 1)
	p := at(around_char[1], "á¥ß≠ÉâàÄä∫∑ΩÖ≤¶µ®Æ¨ª∏†æπ∂º")
	if p>=1 .and. p<14
		R_Mode=1
	endif
	if p >13
		R_Mode=2
	endif
	/* left */
	if ::pos-1 < 1
		around_char[2] := ""
	else
		around_char[2] := substr(::edbuffer[::line], ::pos-1, 1)
	endif
	p = at(around_char[2], "ÑâàÜÄä∞∫∑™§ΩÇØ´•ª∏±†æπ∂©¢º")
	if p >=1 .and. p<14
		L_Mode=1
	endif
	if p >13
		L_Mode=2
	endif
	/* up */
	if ::line-1 < 1
		around_char[3] := " "
	else
		around_char[3] := substr(::edbuffer[::line-1], ::pos, 1)
	endif
	p := at(around_char[3], "Åá≤¶ÉàÜäØ∂¢ºÇ¥ßµ°®∞•∏±æ∑§Ω")
	if p >=1 .and. p <14
		U_Mode = 1
	endif
	if p >13
		U_Mode = 2
	endif
	/* down */
	if ::line+1 > ::lines
		around_char[4] := " "
	else
		around_char[4] := substr(::edbuffer[::line+1], ::pos, 1)
	endif
	p := at(around_char[4], "Åá≤¨ÑâÜäØ©ºÖπ¥µ°Æ≠∞´ª±æ∫™Ω")
	if p >=1 .and. p < 14
		D_Mode=1
	endif
	if p >13
		D_Mode=2
	endif

return
static function te_draw(Draw_Mode, nkey, undo)
local draw_char, around_char[4], back_cur_ch, back_new_ch, string, direction
local A_Right:=1, A_Left:=2, A_Up:=3, A_Down:=4
local R_Mode, L_Mode, U_Mode, D_Mode
local p, ch_ret, line, pos, old_direction:=0, str, ch, i, j
	undo := iif(undo == NIL, .t., undo)
	draw_char := {{"Ä", "†"}, {"Å", "°"}}
	back_cur_ch := {"Éß¶®Ö¨≠Æá¥µ≤",;
			"Ç§¢•Ñ©™´Ü∞±Ø",;
			"É¶ß®Ç§¢•à∂∏∑",;
			"Ö¨≠ÆÑ™©´âπª∫"}
	back_new_ch := {"à∑à∑ââ∫∫äΩΩä∏∏∂∏ªπªªæææº",;
			"à∑à∑ââ∫∫äΩΩä∏∏∂∏ªπªªæææº",;
			"á≤á≤ÜÜØØäººäµµ¥µ±∞±±æææΩ",;
			"á≤á≤ÜÜØØäººäµµ¥µ±∞±±æææΩ"}
	string :={;
   /* present_derection=A_Right*/;
   /*up   */       {{"Ñ©Ñ©Ö¨Ñ©ÖÆâªÖÆÑ©Ö¨Ñ¨âπ","™´™´™´™´≠Æ∫ª≠Æ™´≠Æ™Æ∫ª"},;
   /*down */        {"Ç¢Ç¢É¶Ç¢É®à∏É®Ç¢É¶Ç¶à∂","§•§•§•§•ß®∑∏ß®§•ß®§®∑∏"},;
   /*up down*/      {"ÜØÜØØ±ÜØáµäæáµÜØ≤≤≤≤ºæ","∞±∞±∞±∞±¥µΩæ¥±∞±áµáµäæ"};
		     },;
   /* present_derection=A_Left*/;
		   {{"Ö¨Ñ´Ñ©Ö¨Ö¨âªÖ©Ö¨Ö¨Ñ´âπ","≠Æ™´™´≠Æ≠Æ∫ª≠´≠Æ≠Æ™´∫ª"},;
		    {"É¶Ç•Ç¢É¶É¶à∏É¢É¶Ç¢Ç•à∂","ß®§•§•ß®ß®∑∏ß•ß®ß®§•∑∏"},;
		    {"á≤Ü±ØØá≤á≤äæáØá≤≤µÜ±ºæ","¥µ∞±Ü±¥µ¥µΩæÜ±¥µ¥µ∞µäæ"};
		     },;
   /* present_derection=A_Up*/;
   /*left   */     {{"Ö≠É®ÉßÖ≠Ö≠áµÖßÖ≠Ö≠É®á¥","¨Æ¶®¶®¨Æ¨Æ≤µ¨®¨Æ¨Æ¶®≤µ"},;
   /*right  */      {"Ñ™Ç•Ç§Ñ™Ñ™Ü±Ñ§Ñ™Ñ™Ç•Ü∞","©´¢•¢•©´©´Ø±©•©´©´¢•Ø±"},;
   /*left right*/   {"â∫à∏∑∑â∫â∫äæâ∑â∫∫ªà∏æΩ","πª∂∏à∏πªπªºæà∏πªπª∂ªäæ"};
		     },;
   /* present_derection=A_Down*/;
		   {{"ÉßÉßÉßÉßÖÆáµÖÆÉßÖ≠É≠á¥","¶®¶®¶®¶®¨Æ≤µ¨Æ¶®¨Æ¶Æ≤µ"},;
		    {"Ç§Ç§Ç§Ç§Ñ´Ü±Ñ´Ç§Ñ™Ç™Ü∞","¢•¢•¢•¢•©´Ø±©´¢•©´¢´Ø±"},;
		    {"à∑à∑∑∏à∑âªäæâªà∑∫∫à∫Ωæ","∂∏∂∏∂∏∂∏πªºæπ∏∂∏âªâªäæ"};
		    };
		   }
	Draw_Mode := iif(Draw_Mode, 1, 2)
	R_Mode:=0; L_Mode:=0; U_Mode:=0; D_Mode:=0
	afill(around_char, NIL)

	do case
	case nkey == K_RIGHT
		direction := 1
	case nkey == K_LEFT
		direction := 2
	case nkey == K_UP
		direction := 3
	case nkey == K_DOWN
		direction := 4
	otherwise
		return .f.
	endcase
	line := ::line
	pos := ::pos
	::__check_line(line)
	ch_ret := substr(::edbuffer[line], pos, 1)
	::__around_check(@around_char, @R_Mode, @L_Mode, @U_Mode, @D_Mode)
	if undo
		aadd(around_char, ch_ret)
		::writeundo(HASH_DRAW, around_char)
	endif

	if direction == A_Right
		::right(.f.)
		ch := substr(::edbuffer[::line], ::pos-1, 1)
		p = at(ch, back_cur_ch[direction])
		if p>=1
			ch_ret := substr(back_new_ch[direction], (Draw_Mode-1) * 12 + p, 1)
		else
			if ((L_Mode > 0) .and. (D_Mode + U_Mode + R_Mode) == 0)
				ch_ret := draw_char[1][Draw_Mode]
			elseif ((D_Mode == 1 .and. U_Mode == 1 ) .or. (D_Mode == 2 .and. U_Mode == 2))
				ch_ret := substr(string[direction][3][D_Mode], L_Mode*8 + R_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::left(.f.)
				endif
			elseif (D_Mode == 1 .or. D_Mode == 2)
				ch_ret := substr(string[direction][2][D_Mode], L_Mode*8 + R_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::left(.f.)
				endif
			elseif (U_Mode == 2 .or. U_Mode==1)
				ch_ret := substr(string[direction][1][U_Mode], L_Mode*8 + R_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::left(.f.)
				endif
			else
				ch_ret := draw_char[1][Draw_Mode]
			endif
		endif
	endif

	if direction == A_Left
		  ::left(.f.)
		  ch := substr(::edbuffer[::line], ::pos+1, 1)
		  p := at(ch, back_cur_ch[direction])
		  if p>=1
			ch_ret := substr(back_new_ch[direction], (Draw_Mode-1) * 12 + p, 1)
		  else
			if ((R_Mode > 0) .and. (D_Mode + U_Mode + R_Mode) == 0)
				ch_ret := draw_char[1][Draw_Mode]
			elseif (((D_Mode == 1) .and. (U_Mode == 1) ) .or. (D_Mode == 2 .and. U_Mode == 2))
				ch_ret := substr(string[direction][3][D_Mode], L_Mode*8 + R_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::right(.f.)
				endif
			elseif (D_Mode == 1 .or. D_Mode == 2)
				ch_ret := substr(string[direction][2][D_Mode], L_Mode*8 + R_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::right(.f.)
				endif
			elseif (U_Mode == 2 .or. U_Mode==1)
				ch_ret := substr(string[direction][1][U_Mode], L_Mode*8 + R_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::right(.f.)
				endif
			else
				ch_ret := draw_char[1][Draw_Mode]
			endif
		  endif
	    endif
	 if direction == A_Up
	      ::up(.f.)
	      ch := substr(::edbuffer[::line+1], ::pos, 1)
	      p := at(ch, back_cur_ch[direction])
	      if p>=1
		   ch_ret := substr(back_new_ch[direction], (Draw_Mode-1) * 12 + p, 1)
	      else
			if (D_Mode > 0 .and. (R_Mode + U_Mode + L_Mode) == 0)
				ch_ret := draw_char[2][Draw_Mode]
			elseif ((L_Mode == 1 .and. R_Mode == 1) .or. L_Mode==2 .and. R_Mode==2)
				ch_ret := substr(string[direction][3][L_Mode], U_Mode*8 + D_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::down(.f.)
				endif
			elseif (L_Mode == 1 .or. L_Mode==2)
				ch_ret := substr(string[direction][1][L_Mode], U_Mode*8 + D_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::down(.f.)
				endif
			elseif (R_Mode == 2 .or. R_Mode==1)
				ch_ret := substr(string[direction][2][R_Mode], U_Mode*8 + D_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::down(.f.)
				endif
			else
				ch_ret := draw_char[2][Draw_Mode]
			endif
	      endif
	endif
	if direction == A_Down
	      ::down(.f.)
	      ch := substr(::edbuffer[::line-1], ::pos, 1)
	      p := at(ch, back_cur_ch[direction])
	      if p>=1
		   ch_ret := substr(back_new_ch[direction], (Draw_Mode-1) * 12 + p, 1)
	      else
			if (D_Mode > 0 .and. (R_Mode + U_Mode + L_Mode) == 0)
				ch_ret := draw_char[2][Draw_Mode]
			elseif ((R_Mode == 1 .and. L_Mode == 1) .or. L_Mode==2 .and. R_Mode==2)
				ch_ret := substr(string[direction][3][R_Mode], U_Mode*8 + D_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::up(.f.)
				endif
			elseif (L_Mode == 1 .or. L_Mode==2)
				ch_ret := substr(string[direction][1][L_Mode], U_Mode*8 + D_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::up(.f.)
				endif
			elseif (R_Mode == 2 .or. R_Mode==1)
				ch_ret := substr(string[direction][2][R_Mode], U_Mode*8 + D_Mode*2 + Draw_Mode, 1)
				if ch != ch_ret
					::up(.f.)
				endif
			else
				ch_ret := draw_char[2][Draw_Mode]
			endif
	      endif
	endif

	for i in around_char
		i := translate_charset( __CHARSET__,host_charset(), i)
	next
	if around_char[1] != NIL
		::edbuffer[line] := padr(substr(::edbuffer[line], 1, pos), pos) + around_char[1] + substr(::edbuffer[line], pos+2)
	endif
	if around_char[2] != NIL
		::edbuffer[line] := padr(substr(::edbuffer[line], 1, pos-2), pos-2) + around_char[2] + substr(::edbuffer[line], pos)
	endif
	if around_char[3] != NIL .and. line - 1 > 0
		::edbuffer[line-1] := padr(substr(::edbuffer[line-1], 1, pos-1), pos-1) + around_char[3] + substr(::edbuffer[line-1], pos+1)
	endif
	if around_char[4] != NIL .and. line + 1 <= ::lines
		::edbuffer[line+1] := padr(substr(::edbuffer[line+1], 1, pos-1), pos-1) + around_char[4] + substr(::edbuffer[line+1], pos+1)
	endif
	::edbuffer[line] := padr(substr(::edbuffer[line], 1, pos-1), pos-1) + ch_ret + substr(::edbuffer[line], pos+1)
	::updated := .t.
	if undo
		::refresh()
	endif
RETURN .t.
************
static function te_setNumStyle(st)
	st := iif(st==NIL, .t., st)
	if ::Nstyle == st
		return
	endif
	::Nstyle := st
	if st
		::__LNstyle := int(log10(::lines))+2
		::nLeft+=::__LNstyle
		::refresh()
	else
		::killNumStyle()
	endif
return
************
static function te_killNumStyle()
	::Nstyle := .f.
	::nLeft-=::__LNstyle
	::__LNstyle := 0
	::refresh()
return
************
static function te_highLightAdd(line, color)
	if !between(line, 1, ::lines)
		return .f.
	endif
	if line$::highLightColor
		aadd(::highLightColor[line], color)
		::highLightColor[line] := asort(::highLightColor[line],,, {|x, y| x<y})
	else
		::highLightColor[line] := {}
		aadd(::highLightColor[line], color)
		::highLightColor[line] := asort(::highLightColor[line],,, {|x, y| x<y})
	endif
	::refresh()
return .t.
************
static function te_highLightDel(line, color)
local ret := .f., i
	if line$::highLightColor
		for i=1 to len(::highLightColor[line])
			if ::highLightColor[line][i] == color
				ret := adel(::highLightColor[line], i)
				asize(::highLightColor[line], len(::highLightColor[line])-1)
				exit
			endif
		next
		if empty(::highLightColor[line])
			ret := adel(::highLightColor, line)
		endif
	endif
	::refresh()
return ret
*************
static function te_setTabSize(tabsize)
local i, n, str
	for i=1 to ::lines
		n := len(::edbuffer[i])-len(ltrim(::edbuffer[i]))
		str := tabpack(padr(::edbuffer[i], n), ::tabSize)+ ;
			ltrim(::edbuffer[i])
		::edbuffer[i] := tabexpand(str, tabsize)
	next
	::tabsize := iif(tabsize==NIL, ::tabsize, tabsize)
	::refresh()
return
*************
static function te_setFocus(lFocus)
	lFocus := iif(lFocus==NIL, !::InFocus, lFocus)
	::Infocus := lFocus
return ::InFocus
***************
static function te_setCharset(newchs)
local i
	::charset := newchs
	for i=1 to ::lines
		::edbuffer[i] := translate_charset(::charset, ::__hostcharset, ::edbuffer[i])
	next
	::refresh()
return
**************
static function te_check_clipchs(path)
local file:=path+"/.clipcharset"
	if file(file)
		::charset := memoread(file)
		::charset := charrepl("&\t&\n", ::charset, "  ")
		::charset := alltrim(::charset)
	endif
return ::charset
**************
static function te_print()
local i, str

  printBegin()
  for i=1 to ::lines
	str := ::edbuffer[i]
	qout(str)
  next
  printEnd()
return .t.
**************
static function te_printBlock()
local i, str, x1, x2, y1, y2, l
	if !(::strblock .or. ::rectBlock)
		return .f.
	endif
	y1 := min(::koordblock[1], ::koordblock[3])
	y2 := max(::koordblock[1], ::koordblock[3])
	x1 := min(::koordblock[2], ::koordblock[4])
	x2 := max(::koordblock[2], ::koordblock[4])

	if ::strblock
		printBegin()
		for i=y1 to y2
			str := ::edbuffer[i]
			qout(str)
		next
		printEnd()
		return .t.
	endif
	l := x2-x1+1
	printBegin()
	for i=y1 to y2
		str := substr(::edbuffer[i], x1, l)
		qout(str)
	next
	printEnd()
return .t.

