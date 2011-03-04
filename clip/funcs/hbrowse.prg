/*
    Copyright (C) 2001  ITK
    Author   : Alena (alena@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <inkey.ch>
#include <clipcfg.h>
#include <box.ch>
#define __CHARSET	"cp437"
#define COLOR_BROWSER	"0/3,  14/3, 1/3, 14/3, 14/1, 11/3, 0/7, 15/1, 15/3,   1/3"
#define COLOR_MENU 	"0/7,0/2,4/7,2/5,15/7,0/7"
/*                      ____   ________  __________  ____   _________  _____   _____ */
/*                      backgr links     buttons     header getobj 0/1 <i></i> <code>  */
#define COLOR_DIALOG	"0/7, 15/1"
#define COLOR_TEXTAREA	"11/1,11/1,0/2,0/3,0/7,1/3"
#define TAB_SIZE	8
#define DELIMITER	"Ä" //utf-8: "‚îÄ"
#define LISTDELTA	4
#define LIST_TYPE	1
#define LIST_DEEP	2
#define LIST_START	3
#define LIST_VID	4
#define MARGIN_LEFT	2

#define _BUTTON_	1
#define _GET_		2
#define _CHECK_		3
#define _RADIO_		4
#define _GETTEXT_	5

function hbrowse(nTop, nLeft, nBottom, nRight, url, color)
static __STORY__
local obj
	obj := map()
	obj:className	:= "BROWSER"
	obj:nTop 	:= iif(nTop==NIL, 0, nTop)
	obj:nLeft 	:= iif(nLeft==NIL, 0, nLeft)
	obj:nBottom 	:= iif(nBottom==NIL, maxrow(), nBottom)
	obj:nRight 	:= iif(nRight==NIL, maxcol(), nRight)
	obj:colorSpec	:= iif(color==NIL, COLOR_BROWSER, color)
	obj:width	:= obj:nRight - obj:nLeft - 2
	obj:rows	:= obj:nBottom-obj:nTop-1
	obj:frames	:= {}
	obj:state	:= {}
	obj:doc		:= ""
	obj:url		:= 0
	obj:urlName	:= url
	obj:center	:= .f.
	obj:clrHist	:= {}
	obj:clr		:= 0
	obj:lists	:= {}
	obj:pre		:= .f.
	obj:parser	:= 0
	obj:startHtml	:= .f.
	obj:cnt_t	:= 0
	obj:Story	:= {}//iif(__STORY__!=NIL, aclone(__STORY__), {})
	obj:indStory	:= iif(empty(obj:Story), 0, 1)
	obj:mapKeys	:= HK_get("htmlBrowser")
	obj:str		:= ""
	obj:newStr	:= .f.
	obj:form	:= {}
	obj:ndxForm	:= 0
	obj:isForm	:= .f.
	obj:isDt	:= 0
	obj:numTable	:= 0
	obj:tbl		:= {}
	obj:tblCol	:= {}
	obj:tblRow	:= {}
	obj:tblNewLine	:= .f.
	obj:isRefer	:= .f.
	obj:hRefer	:= ""
	obj:nRefer	:= ""
	obj:iRefer	:= ""
	obj:charset	:= __CHARSET
	obj:charsetOrig	:= __CHARSET

	obj:open	:= @openBrowser()
	obj:runing	:= @runing()
	obj:getUrl	:= @br_getUrl()
	obj:parseTag	:= @parseTag()
	obj:parseNewUrl	:= @parseNewUrl()
	obj:newLine	:= @newLine()
	obj:goBack	:= @goBack()
	obj:goNext	:= @goNext()
	obj:addObject	:= @br_addObject()
	obj:SetCodePage	:= @br_SetCodePage()
	obj:reload	:= @br_reload()

	obj:parse_H	:= @parse_H()
	obj:parse_Head	:= @parse_Head()
	obj:newRefer	:= @newRefer()
	obj:parse_A	:= @parse_A()
	obj:parse_Font	:= @parse_Font()
	obj:parse_Title	:= @parse_Title()
	obj:parse_Hr	:= @parse_Hr()
	obj:parse_Ol	:= @parse_Ol()
	obj:parse_Ul	:= @parse_Ul()
	obj:parse_Li	:= @parse_Li()
	obj:parse_Dt	:= @parse_Dt()
	obj:parse_Dd	:= @parse_Dd()
	obj:parse_Image	:= @parse_Image()
	obj:parse_Table	:= @parse_Table()
	obj:parse_Col_Table := @parse_Col_Table()
	obj:parse_Tbl_Caption := @parse_Tbl_Caption()
	obj:add_Table	:= @add_Table()
	obj:parse_Form	:= @parse_Form()
	obj:parse_Input	:= @parse_Input()
	obj:parse_TextArea:= @parse_TextArea()

	obj:parse_Meta	:= @parse_Meta()

	obj:Browse_File := @Browse_File()

	obj:indTabCol	:= stackNew()
	obj:indTabRow	:= stackNew()

//	obj:close	:= @closeBrowser()
//	obj:runing	:= @runBrowser()
	obj:htmlColors	:= map()
	obj:getHcolor	:= @getHcolor()
	obj:new_clr	:= @new_clr()
	obj:rest_clr	:= @rest_clr()
	obj:__colors 	:= {}      // colors palettes
	obj:__setColor 	:= @__setcolor()
	obj:__setcolor()

	obj:menu	:= br_menu_create()
	obj:open()
return 0

***************
static function openBrowser()
local h, buf, s, scr, tag, i
	clear screen
	save screen to scr
	::doc := dialogBox(::nTop, ::nLeft, ::nBottom-1, ::nRight)
	::doc:marginLeft := MARGIN_LEFT
	::width -= ::doc:marginLeft
	if !empty(::urlName)
		::url := urlNew()
		::url:parseUrl(::urlName)
	else
		::url := urlNew("http","last","/itk/clipper","index.html")
	endif
	aadd(::Story, map())
	::indStory++
	::Story[::indStory]:url := ::url:makeUrl()
	::Story[::indStory]:line := 1
	::Story[::indStory]:pos := 1
	::Story[::indStory]:row := 1
	::Story[::indStory]:col := 1

	::url:open()
	::parser:=htmlParserNew()
	::getUrl()
	::parseNewUrl()
	//::doc:handleKey(::doc, __self__)
	::doc:drawBox()
	@ ::nBottom, 0 say padr([<   >-go next item  i-info  <F5>-go line  <F6>-find  <F9>-menu  <ESC>,<F10>-exit], ::nRight) color "0/w"
	@ ::nBottom, 1 say "Tab" color "r/w"
	@ ::nBottom, 20 say "i" color "r/w"
	@ ::nBottom, 29 say "F5" color "r/w"
	@ ::nBottom, 43 say "F6" color "r/w"
	@ ::nBottom, 54 say "F9" color "r/w"
	@ ::nBottom, 65 say "ESC" color "r/w"
	@ ::nBottom, 71 say "F10" color "r/w"
	::runing()
	::doc:close()
	::url:close()
	restore screen from scr
return
********************
static function runing()
local hKey, wn, oldcursor, oldcolor, scr, oldrow, oldcol
local i, j, num, oInfo, nchoice:=1, old_translate_path, k

	old_translate_path := set(_SET_TRANSLATE_PATH, .f.)
	do while .t.
		hKey := inkey(0)
		if hkey $ ::mapKeys
			//if !::doc:item:hasFocus .or. ;
			//   (::doc:item:hasFocus .and. !search("[a-zA-Z/-]", chr(hKey)))
				hKey := ::mapKeys[hKey]
			//endif
		endif
		if hKey == HASH_CallMenu
			set( _SET_EVENTMASK, INKEY_ALL )
			i := setcursor(0)
			oldrow := row()
			oldcol := col()
			wopen(::nTop , ::nLeft, ::nBottom, ::nRight, .f.)
			oInfo := ::menu
			hKey := MenuModal(oInfo,nchoice,maxrow(),0,maxcol(),"r/w")
			wclose()
			setpos(oldrow, oldcol)
			nchoice := oInfo:current
			setcursor(i)
			if hKey == -1
				loop
			endif
		endif
		do case
		case hKey == HASH_Exit
		     //	::doc:close()
			exit
		case hKey == K_UP
			::doc:up()
		case hKey == K_DOWN
			::doc:down()
		case hKey == K_LEFT
			::doc:left()
		case hKey == K_RIGHT
			::doc:right()
		case hKey == K_HOME
			::doc:home()
		case hKey == K_END
			::doc:end()
		case hKey == K_PGDN
			::doc:pageDown()
		case hKey == K_PGUP
			::doc:pageUp()
		case hKey == K_INS
			set(_SET_INSERT, !set(_SET_INSERT))
		case hKey == K_DEL
			::doc:delete()
		case hKey == K_BS
			if !::doc:item:hasFocus
				::goBack()
			else
				::doc:backspace()
			endif
		case hKey == HASH_NextItem
			::doc:select()
		case hKey == HASH_PrevItem
			::doc:select(.f.)
		case hKey == K_ENTER
			::doc:enter(::doc, __self__)
		case hKey == K_F5
			num := ::doc:line
			alert("Das ist Gluck into Screen!!!")
			readkeyb((::nBottom-::nTop)/2, ((::nRight-::nLeft)/2)-len([Where are you going?]), [Where are you going?], @num,,,"0/7,14/1", B_DOUBLE)
			setcursor(1)
			::doc:goto(num)
			/*
		case hKey == HASH_Find
			num := 0
			alert("Das ist Gluck into Screen!!!")
			readkeyb((::nBottom-::nTop)/2, ((::nRight-::nLeft)/2)-len([Where are you going?]), [Where are you going?], @num,,,"0/7,14/1", B_DOUBLE)
			setcursor(1)
			if !::goItem(num)
				alert("Oblomaiz!!!")
			endif
			*/
		case hKey == HASH_Find
			k := ::doc:curWord()
			::doc:Find:fstring := iif (empty(k), ::doc:Find:fhistory:first(), k)
			::doc:Find:replace := .f.
			if ::doc:Find:get()
				if !::doc:findStr()
					alert([String;]+::doc:Find:fstring+[;not found!], "OK", set("dbox_colors_menu"))
				endif
			endif
			setcursor(1)
		case hKey == HASH_ResumeFind
			::doc:right()
			if !::doc:findStr()
				alert([String;]+::doc:Find:fstring+[;not found!], "OK", set("dbox_colors_menu"))
			endif
		case hKey == HASH_UnmarkBlock
			::doc:cancelBlock()
		case hKey == HASH_NextUrl
			::goNext()
		case hKey == HASH_PrevUrl
			::goBack()
		case hKey == HASH_InfoUrl
			if !::doc:item:hasFocus
				alert("document reference:;"+::url:makeUrl(.f.), "OK", COLOR_DIALOG)
			elseif  ::doc:item_type == _BUTTON_
				alert("document reference:;"+::url:makeUrl(.f.)+";"+;
				      "current reference:;"+::doc:item:info, "OK", COLOR_DIALOG)
			else
				::doc:insert(chr(hKey))
			endif
		case hKey == HASH_SetCodePage
			::SetCodePage()
		otherwise
			::doc:insert(hKey)

		endcase
	enddo
	set(_SET_TRANSLATE_PATH, old_translate_path)

return
********************
static function br_getUrl()
local buf, timeout:=60
	do while !::url:eof()
		::url:kick()
		if (seconds()-::url:start) > timeout
			exit
		endif
		if !::url:eof()
			sleep(1)
		endif
	enddo
	/* skip header */
	sleep(0.1)
	while  !::url:fileeof()
	    if upper(::url:protocol) == "FILE"
		exit
	    endif
	    buf:=::url:getstr()
		//alert(buf)
	    if len(buf)==0
	       exit
	    endif
	enddo

	sleep(0.1)
	do while !::url:fileEof()
		::url:kick()
		buf:=::url:readstr(10000)
		if empty(buf)
			sleep(0.1)
			loop
		endif
		::parser:put(buf)
		//outlog(buf)
	enddo
	::parser:end(::url:readStr(10000))
	::url:close()
return
*******************
static function parseNewUrl()
local s, arr, i, str:=""
	do while !::parser:empty()
		s := ::parser:get()
		if valtype(s) == "O"
			if !empty(str)
				if !empty(::str) .and. ::newStr
					::addObject(::str)
					::newLine()
					::str := ""
					::newStr := .f.
				endif
				if !empty(::str)
					str := ::str + str
					::str := ""
				endif
				arr := split_string(str, ::width, ::width-(::doc:n_Pos-::doc:marginLeft))

				if ::center
					::doc:n_Pos := (::width-len(arr[1]))/2+::doc:marginLeft
				endif
				//str := iif(::center, padc(arr[1], ::width), arr[1])
				str := arr[1]
				::addObject(str)
				for i=2 to len(arr)
					::newLine()
					if ::center
						::doc:n_Pos := (::width-len(arr[i]))/2+::doc:marginLeft
					endif
					str := arr[i]
					::addObject(str)
				next
				arr:={}
				str := ""
			endif
			if !empty(::str) .and. ::newStr
				::addObject(::str)
				::newLine()
				::str := ""
				::newStr := .f.
			endif
			if !empty(::str)
				str := ::str + str
				::str := ""
			endif
			::parseTag(s)
			loop
		endif
		if !::startHtml
			loop
		endif
		if empty(s) //.and. !isRefer
			loop
		endif
		s=tabexpand(s, TAB_SIZE)
		if ::pre
			arr := split(s, "[&\n]")
			for i=1 to len(arr)
				::addObject(replace_symbols(arr[i], .f.))
				::newLine()
			next
			loop
		endif
		//str += iif(!empty(str), " ", "")+ltrim(s)
		//str += iif(!empty(str), " ", "")+s
		str += s
	enddo
return
******************
static function br_addObject(str, color, type, fnc, size, name, line, pos)
local numb
	line := iif(line==NIL, ::doc:n_Line, line)
	pos := iif(pos==NIL, ::doc:n_Pos, pos)
	if valtype(str)=="C"
		str := translate_charset(::charset, host_charset(), str)
	endif
	if ::isRefer .and. type==NIL
		::doc:Button(str, ::hRefer, line, pos, , , ::clr, ::nRefer, ::iRefer)
		return .t.
	endif
	if type==NIL
		::doc:Text(str,line,pos,,,::clr)
		return .t.
	endif
	color := iif(color==NIL, ::clr, color)
	do case
	case type == "Get"
		::doc:Get(line,pos,str,size,color,,,,name)
	case type == "Button"
		color := ::__colors[4]+"/"+::__colors[5]
		::doc:Button(str, fnc, line, pos+2,,,color,name)
	case type == "Check"
		::doc:Check(line,pos,str,,color,,, name)
	case type == "Radio"
		::doc:Radio(line,pos,str, fnc,"",color,,, name)
	case type == "Textarea"
	case type == "Password"
		::doc:Get(line,pos,str,size,color,fnc,,,name)
	case type == "Browse"
		numb := ::doc:Get(line,pos,str,size,color,,,,name)
		color := ::__colors[4]+"/"+::__colors[5]
		::doc:Button("Browse", {|s, self| self:Browse_File(numb)}, line, ::doc:n_Pos+2,,,color,name)
	endcase
return
******************
static function newLine(step, real)
local col, ind
	//::doc:lines++
	step := iif(step==NIL, 1, step)
	real := iif(real==NIL, .f., real)
	if ::numTable<1 .or. real
		::doc:n_Line := ::doc:lines+step
		::doc:n_Pos := ::doc:marginLeft
	else
		::tblNewLine := .t.
	endif
return
******************
static function parseTag(tag, insTag)
local typ:=upper(tag:tagname), ret:=0
	insTag := iif(insTag==NIL, .t., insTag)
	do case
	case typ == "HTML" .or. typ == "BODY"
		::startHtml := .t.
	case typ == "/HTML" .or. typ == "/BODY"
		::startHtml := .f.
	case typ == "TITLE"
		::startHtml := .t.
		ret := ::parse_Title()
	case typ == "HEAD"
		::newLine()
		::parse_Head(tag)
	case typ == "/HEAD"
		::newLine()
		::rest_clr()
	case search("/[Hh][12345]", typ)
		::rest_clr()
		::newLine()
	case search("[Hh][12345]", typ)
		::newLine()
		::new_clr(::__colors[6])
		::parse_H(&(substr(typ, 2)))
	case typ == "CENTER"
		::center := .t.
	case typ == "/CENTER"
		::center := .f.
	case typ == "FONT"
		::parse_Font(tag)
	case typ == "/FONT"
		::rest_clr()
	case typ == "A"
		::parse_A(tag)
	case typ == "/A"
		/*
		if !empty(::hRefer) .or. !empty(::nRefer)
			::addObject("")
		endif
		*/
		::isRefer := .f.
		::hRefer := ""
		::nRefer := ""
		::iRefer := ""
		::rest_clr()
	case typ == "PRE"
		::newLine()
		::pre := .t.
	case typ == "/PRE"
		::pre := .f.
		::newLine()
	case typ == "HR"
		::newLine()
		ret := ::parse_Hr(tag)
		::newLine()
	case typ == "BR"
		::newLine()
	case typ == "P"
		::newLine(2)
	case typ == "I"
		::new_clr(::__colors[9])
	case typ == "/I"
		::rest_clr()
	case typ == "CODE"
		::new_clr(::__colors[10])
	case typ == "/CODE"
		::rest_clr()
	case typ == "VAR"
		::new_clr(::__colors[9])
	case typ == "/VAR"
		::rest_clr()
	case typ == "UL"
		::newLine(2)
		::parse_Ul()
	case typ == "OL"
		::newLine(2)
		::parse_Ol(tag)
	case typ == "/UL" .or. typ == "/OL"
		::width += iif(len(::lists)>0, LISTDELTA, 0)
		::doc:marginLeft -= iif(len(::lists)>0, LISTDELTA, 0)
		::doc:marginLeft := max(::doc:marginLeft, MARGIN_LEFT)
		if len(::lists) != 0
			asize(::lists, len(::lists)-1)
		endif
		::rest_clr()
		 ::newLine()
	case typ == "LI"
		::newLine()
		ret := ::parse_Li(tag)
	case typ == "/LI"
		abs(1)
	case typ == "DT"
		if ::isDt > 0
			::isDt --
			::width += TAB_SIZE
			::doc:marginLeft -= TAB_SIZE
		endif
		::doc:marginLeft := max(::doc:marginLeft, MARGIN_LEFT)
		::newLine()
	case typ == "DD"
		if ::isDt == 0
			::isDt ++
			::width -= TAB_SIZE
			::doc:marginLeft += TAB_SIZE
		endif
		::newLine()
	case typ == "/DD"
		if ::isDt > 0
			::isDt --
			::width += TAB_SIZE
			::doc:marginLeft -= TAB_SIZE
		endif
		::doc:marginLeft := max(::doc:marginLeft, MARGIN_LEFT)
	case typ == "TABLE"
		::newLine()
		ret := ::parse_Table(tag, ::width)
	case typ == "FORM"
		::isForm := ::parse_Form(tag)
		::newLine()
	case typ == "/FORM"
		::isForm := .f.
	case typ == "INPUT"
		if ::isForm
			ret := ::parse_Input(tag, insTag)
		endif
	case typ == "IMG"
		ret := ::parse_Image(tag)
	case typ == "TEXTAREA"
		if ::isForm
			ret := ::parse_TextArea(tag, ::width)
		endif
	case typ == "META"
		::parse_Meta(tag)
	endcase
return ret
*****************
static function parse_Title()
local s, t:=" "
	do while !::parser:empty()
		s=::parser:get()
		if valtype(s) == "O" .or. upper(s) == "/TITLE"
			exit
		endif
		t += s+" "
	enddo
	::doc:header := t
return len(t)
*****************
static function parse_Font(tag)
	if "COLOR" $ tag:fields
		::new_clr(::getHcolor(::clr, tag:fields:COLOR))
	endif
return
*************
static function parse_H(typ)
	::str := ""//"*":replicate(typ)
	//::doc:Text(s,::doc:n_Line,::doc:n_Pos,,,::clr)
return .t.
*************
static function parse_Head(tag)
	::new_clr(::__colors[6])
return
*************
static function parse_A(tag)
local name, target, title, href, txt
	::isRefer := .t.
	::hRefer := {|| alert("Ups!!")}
	::nRefer := ""
	if "NAME"$tag:fields
		::nRefer := tag:fields:NAME
	endif
	if "TARGET"$tag:fields
		target := tag:fields:TARGET
	endif
	if "TITLE"$tag:fields
		title := tag:fields:TITLE
	endif
	if "HREF"$tag:fields
		href := tag:fields:HREF
		::iRefer := href
		::hRefer := {|s, self| self:newRefer(href)}
	endif

	if ::center
		::doc:n_Pos := (::width-len(txt))/2+::doc:marginLeft
	endif

	::new_clr(::__colors[2]+","+::__colors[3])
return
*************
static function newRefer(href, newR)
local i, st, oldf
	newR := iif(newR==NIL, .t., newR)
	if newR
		::Story[::indStory]:line := ::doc:line
		::Story[::indStory]:pos := ::doc:pos
		::Story[::indStory]:row := ::doc:rowWin
		::Story[::indStory]:col := ::doc:colWin
	endif


	oldf := ::url:file
	if newR
		i := "//":at(href)
		if i >0
			::url:parseUrl(href)
		else
			i := "/":rat(href)
			if i <= 0
				if left(href, 1) == "#"
					i := at("#", ::url:file)
					if i>0
						::url:file := substr(::url:file, 1, i-1)
					endif
					::url:file += href
					::url:parseUrl(::url:file)
				else
					::url:file := href
				endif
			else
				::url:file := substr(href, i+1)
				::url:path := substr(href, 1, i-1)
				::url:path := substr(::url:path, "/":at(::url:path))
			endif
			::url:parseUrl(::url:makeUrl())
		endif
		aadd(::Story, map())
		::indStory++
		::Story[::indStory]:url := ::url:makeUrl()
		::Story[::indStory]:line := 1
		::Story[::indStory]:pos := 1
		::Story[::indStory]:row := 1
		::Story[::indStory]:col := 1
	else
		::url:path := ""
		::url:file := ""
		::url:parseUrl(href)
	endif
	st := ::Story[::indStory]
	if ::url:file != oldf
		::doc:close()
		::startHtml := .f.
		(::lists):asize(0)
		i:=::url:open()
		::url:goTop()

		::getUrl()
		::doc:marginLeft := MARGIN_LEFT
		::parseNewUrl()
		::doc:drawBox(.f.)
	endif
	if ::url:anchor==NIL .or. !::doc:goItem(::url:anchor, .t.)
		::doc:goTo(st:line, st:pos, st:row, st:col)
	endif
return
*************
static function parse_Hr(tag)
local align:="CENTER", size:=::width
	if "ALIGN"$tag:fields
		align := upper(tag:fields:ALIGN)
	endif
	if "SIZE"$tag:fields
		size := tag:fields:SIZE
	endif

	if align == "LEFT"
		::str := padl(replicate(DELIMITER, size), ::width)
	elseif align == "RIGHT"
		::str := padr(replicate(DELIMITER, size), ::width)
	else
		::str := padc(replicate(DELIMITER, size), ::width)
	endif
	::newStr := .t.
return size
*************
static function parse_Ol(tag)
local typ:="1", start:=1
	if "TYPE"$tag:fields
		typ := tag:fields:TYPE
	endif
	if "START"$tag:fields
		start := max(start, &(tag:fields:START))
	endif
	::new_clr(::__colors[1])
	aadd(::lists, {1, LISTDELTA+iif(len(::lists)==0, 0, ::lists[len(::lists)][LIST_DEEP]), start, typ})
	::width -= iif(len(::lists)>1, LISTDELTA, 0)
	::doc:marginLeft += iif(len(::lists)>1, LISTDELTA, 0)
return .t.
*************
static function parse_Ul()
local typ:="1", start:=1
	::new_clr(::__colors[1])
	aadd(::lists, {0, LISTDELTA+iif(len(::lists)==0, 0, ::lists[len(::lists)][LIST_DEEP]), 0})
	::width -= iif(len(::lists)>1, LISTDELTA, 0)
	::doc:marginLeft += iif(len(::lists)>1, LISTDELTA, 0)
return .t.
*************
static function parse_Li(tag)
local typ:="1", value:=0, item
	if len(::lists) == 0
		return 0
	endif
	item := atail(::lists)
	typ := iif(len(item)>=4,item[LIST_VID],"")
	if "TYPE"$tag:fields
		typ := tag:fields:TYPE
	endif
	if "VALUE"$tag:fields
		value := tag:fields:VALUE
	endif
	if item[LIST_TYPE] == 0 // unordered lists
		::str := "-":padl(item[LIST_DEEP])
		return len(::str)
	endif
	do case
	case typ == "A"
		::str := (upper(chr(97+item[LIST_START]-1))+"."):padl(item[LIST_DEEP])
	case typ == "a"
		::str := (chr(97+item[LIST_START]-1)+"."):padl(item[LIST_DEEP])
	case typ == "I"
	case typ == "i"
	otherwise
		::str := (alltrim(toString(item[LIST_START]))+"."):padl(item[LIST_DEEP])
	endcase
	item[LIST_START] ++
return len(::str)
*************
static function parse_Dt()

return
*************
static function parse_Dd()

return
*************
static function parse_Tbl_Caption(tt)
local caption:=""
	do while !::parser:empty()
		tt := ::parser:get()
		if valtype(tt) == "C"
			caption += tt
		endif
		if valtype(tt)=="O" .and. tt:tagname == "/CAPTION"
			exit
		endif

	enddo
return caption
**************
static function parse_Table(tag, widthtab)
local i, j, tt, col, row, cnt:=1, align, caption := "", border, width
local arr:={}, isCell, ind, maxwidth:={}, minwidth:={}, ct, fact, mmn, k
local nCol, item
/*
tblCol - columns array:
	minWidth
	maxWidth
	realWidth

tblRow - rows array:
	height

tbl - items array
	body - array:{item , len(item)} item  - text or html's tag
*/

	widthtab := iif(widthtab==NIL, 0, widthtab)
	width := 0
	if "WIDTH"$tag:fields
		k:="%":at(tag:fields:WIDTH)
		if k>0
			k := &(substr(tag:fields:WIDTH, 1, k-1))
			width := int(widthtab*k)/100
		else
			width:=&(tag:fields:WIDTH)/8
		endif
	endif
	border := .f.
	if "BORDER"$tag:fields
		border := .t.
	endif
	aadd(::tbl, HTableNew(__self__, width, border))
	::numTable++
	isCell := .f.
	//aadd(::tblRow, {})
	//aadd(::tblCol, {})
	do while !::parser:empty()
		tt := ::parser:get()
		if empty(tt)
			loop
		endif
		if valtype(tt)=="C" .and. isCell
			// add to table new cell string
			::tbl[::numTable]:addItemToCell(tt)
			loop
		endif
		if tt:tagname == "CAPTION"
		     if "ALIGN" $ (tt:fields)
			::tbl[::numtable]:captionAlign := tt:fields:ALIGN
		     endif
		     ::tbl[::numTable]:caption := ::parse_Tbl_Caption(@tt)
		endif
		do case
		case tt:tagname == "TABLE"
			cnt ++
			aadd(arr, {})
		case tt:tagname == "/TABLE"
			::numTable--
			isCell := .f.
			if ::numTable == 0
				exit
			endif
		case tt:tagname == "TR"
			isCell := .f.
			::tbl[::numTable]:addRowToTable(tt)
		case tt:tagname == "TH" .or. tt:tagname == "TD"
			::tbl[::numTable]:addCellToTable(tt)
			isCell := .t.
		case tt:tagname == "/TH" .or. tt:tagname == "/TD" .or. tt:tagname == "/TR"
			isCell := .f.
		otherwise
			if tt:tagname != "/CAPTION"
				::tbl[::numTable]:addItemToCell(tt, .t.)
			endif
		endcase
		if (valtype(tt) == "O" .and. (tt:tagname == "/TABLE")) .and. ::numTable == 1
			exit
		endif
	enddo

	::numTable := 1
	item := ::tbl[::numTable]

	width -= len(::tbl[::numTable]:TColumns)-1

	// if table width is specified
	if width>0
		// real width
		fact := 0
		for i=1 to len(item:Tcolumns)
			fact += item:Tcolumns[i]
		next
		for j=1 to len(item:Tcolumns)
			tt := int((item:Tcolumns[j]*100)/fact)
			item:Tcolumns[j] := int((width*tt)/100)
		next
	endif

	k := 0
	for i=1 to len(item:Tcolumns)
		k += item:Tcolumns[i]
	next
	if width<0 .and. k>(::width-k+1)
		width := ::width-len(item:Tcolumns)+1
	else
		width := k + len(item:Tcolumns) + 1
	endif

	j := 0
	k := len(item:Tcolumns)
	for i=1 to k
		if item:Tcolumns[i]>int(width/k)
			item:Tcolumns[i] := (int(i*width/k))-j
		endif
		j += item:Tcolumns[i]
	next
	::tbl[::numTable]:drawTable()//::doc, ::clr)
	::numTable --
/*
	for i=1 to len(item:rows)
		for j=1 to len(item:Tcolumns)
			? 'items   ', item:items[1][j]:items
			? 'maxWidth', item:items[1][j]:maxWidth
			? 'minWidth', item:items[1][j]:minWidth
			? 'Width   ', item:items[1][j]:Width
			? 'colspan ', item:items[1][j]:colspan
			? 'rowspan ', item:items[1][j]:rowspan
			? 'Height  ', item:items[1][j]:Height

		next
		? '-------------------------------------------------'
		exit
	next
*/
//	::add_table(caption)
return .t.
*************
static function parse_Meta(tag)
local arr, i
	if "CONTENT"$tag:fields
		arr := split(tag:fields:CONTENT, ";")
		for i in arr
			if lower(alltrim(i)) = "charset="
				::charset := substr(i, at('=', i)+1)
				exit
			endif
		next
	endif
return
********************
static function br_SetCodePage()
	::charset := set("HV_CHARSET")
	::reload()
return .t.
**********************
static function br_reload()
	::doc:close()
	::doc:init()
	::startHtml := .f.
	(::lists):asize(0)
	::url:open()
	::url:goTop()

	::getUrl()
	::doc:marginLeft := MARGIN_LEFT
	::parseNewUrl()
	::doc:drawBox(.f.)
	::doc:refresh()
return
*******************
static function parse_Col_Table(tag, align)
local curtag:=map()
	curtag:col := 1
	curtag:row := 1
	curtag:align := align
	if "COLSPAN"$tag:fields
		curtag:col := &(tag:fields:COLSPAN)
	endif
	if "ROWSPAN"$tag:fields
		curtag:row := &(tag:fields:ROWSPAN)
	endif
	if "ALIGN"$tag:fields
		curtag:align := upper(tag:fields:ALIGN)
	endif
return curtag
**********************
function replace_symbols(str, space_charone)
local lsp
	lsp := len(str)-len(ltrim(str))
	space_charone := iif(space_charone==NIL, .t., space_charone)
	if space_charone
		str :=  " ":replicate(lsp)+charone(" ", ltrim(str))
	endif
	str := str:strtran("&#060;", "<")
	str := str:strtran("&lt;", "<")
	str := str:strtran("&gt;", ">")
	str := str:strtran("&#062;", ">")
	str := str:strtran("&nbsp;", " ")
	str := str:strtran("&quot;", '"')
	str := str:strtran("&#169;", "(C)")
	str := str:strtran("&#169", "(C)")
return str
**********************
function split_string(str, width, prewidth)
local arr:={}, i, pr, s, es, rs
	prewidth := iif(prewidth==NIL, width, prewidth)
	str := replace_symbols(str)
	if len(str)<=prewidth
		aadd(arr, str)
		return arr
	endif
	pr := str:split(" ")
	s := ""
	rs := " ":replicate(len(str)-len(rtrim(str)))
	es := " ":replicate(len(str)-len(ltrim(str)))
	for i=1 to len(pr)
		if empty(pr[i])
			loop
		endif
		if len(s+es+pr[i])>prewidth
			arr:aadd(s)
			s := pr[i]
			prewidth := width
		else
			s += es+pr[i]
		endif
		es := " "
	next
	arr:aadd(s+rs)
return arr
**********************
function split_cell(cell, width)
local arr:={}, i, s:="", es:=""
	for i=1 to len(cell)
		if len(s+es)+cell[i][2]>width
			arr:aadd(s)
			s += es+iif(valtype(cell[i][1])=="O", " ":replicate(cell[i][2]), cell[i][1])
		else
			s += es+iif(valtype(cell[i][1])=="O", " ":replicate(cell[i][2]), cell[i][1])
		endif
		es := " "
	next
	arr:aadd(s)
return arr
*********************
function splitSpaceFrom(str, spos)
local ret:=0
	str := substr(str, 1, spos)
	ret := atr(" ", str)
	if ret == 0
		ret := spos
	endif
return ret
**********************
static function add_Table( caption, border)
local i, j, s, s1, w, t, k, arr, c_repl, e_str, c_str, cell, ctbl, celine
local tcolor, wfact, rl, symb, x, y, dc, rc, rtbl, elem, hcls, ls, spos
local cell_pos:={}
local box:={"Ç","Ä","à","É","Å","Ü","á","ä","Ñ","â","Ö"} //utf-8: {"‚îå","‚îÄ","‚î¨","‚îê","‚îÇ","‚îú","‚î§","‚îº","‚îî","‚î¥","‚îò"}
      //     1   2   3   4   5   6   7   8   9   0   1
	border := iif(border==NIL, .f., .t.)
	caption := iif(caption==NIL, "", caption)

	// write caption
	s := box[1]
	ctbl := ::tbl[::numTable]

	for i=1 to len(ctbl[1])
		w := ctbl[1][i]:WIDTH
		for k=2 to ctbl[1][i]:COL
			w += ctbl[1][i+k-1]:WIDTH
		next
		w += ctbl[1][i]:COL-1
		i += (ctbl[1][i]:COL)-1

		s += box[2]:replicate(w)+box[3]
	next
	s := s:left(s:len()-1) + box[4]
	if !empty(caption)
		j := len(s)
		arr := split_string(caption, j)
		for i=1 to len(arr)
			::doc:Text(padc(arr[i], j),,,,,::clr)
		next
	endif
	tcolor := ::clr // table color
	::doc:Text(s,,,,,tcolor)
	::newLine(, .t.)
	// write body
	c_repl := .f.
	for i=1 to len(ctbl)
		// left symbol
		ls := box[5]
		::doc:Text(ls,,,,,tcolor)
		// height of cells in a row
		hcls := 1
		// initial row of the table
		rtbl := ::doc:n_Line
		rc := ::doc:n_Pos
		for j=1 to len(ctbl[i])
			elem := ctbl[i][j]
			w := elem:WIDTH // cell width
			if len(cell_pos) < j
				aadd(cell_pos, rc)
			else
				cell_pos[j] := rc
			endif
			// bottom cell border
			if j==1
				s1 := symb_tbl(ctbl, i, j-1)
			endif
			s1 += replicate(iif(elem:ROW>1 .and. i!=len(ctbl), " ", box[2]), elem:WIDTH)
			// Current ceil(s) width, if col > 1
			for k=2 to elem:COL
				w += ctbl[i][j+k-1]:WIDTH
				s1 += symb_tbl(ctbl, i, j+k-2)
				s1 += replicate(iif(elem:ROW>1 .and. i!=len(ctbl), " ", box[2]), ctbl[i][j+k-1]:WIDTH)
				if len(cell_pos) < j+k-1
					aadd(cell_pos, rc)
				else
					cell_pos[j+k-1] := rc
				endif
			next
			j += elem:COL-1
			w += elem:COL-1

			// text placement in a cell line
			if !"ALIGN"$elem
				elem:ALIGN := ""
			endif

			// now all cell text
			// if cell is empty
			if !("text"$elem) .or. len(elem:text)==0
				::doc:Text(" ":replicate(w),rtbl,rc,,,tcolor)
				::doc:refresh()
				for x=1 to hcls
					dc := -1
					for y=1 to j
						if ctbl[i][y]:high <= hcls
							ctbl[i][y]:high ++
							symb := iif(y==1 .or. ctbl[i][y-1]:COL<=1, box[5], " ")
							::doc:Text(symb,rtbl,rc+dc,,,tcolor)
				::doc:refresh()
							symb := iif(y==len(ctbl[i]) .or. ctbl[i][y]:COL<=1, box[5], " ")
							::doc:Text(symb,rtbl,rc+dc+ctbl[i][y]:WIDTH+1,,,tcolor)
				::doc:refresh()
							dc += ctbl[i][y]:WIDTH+1
						endif
					next
				next
				//highs[j] := hcls
				rc += w+1
				s1 += symb_tbl(ctbl, i, j)
				loop
			endif
			// id cell isn't empty
			rl := 0

			do while (len(elem:text) > 0)
				// how many items fit in one row of the cell
				wfact := 0 // actual width of the data in table
				y := 0
				for x=1 to len(elem:text)
					if wfact +elem:text[x][2] <= w
						y++
						wfact += elem:text[x][2]
					elseif wfact == 0 .and. elem:text[x][2] > w

						y++
						asize(elem:text, len(elem:text)+1)
						ains(elem:text, x)
						elem:text[x] := {"", 0}
						spos := splitSpaceFrom(elem:text[x+1][1], w-wfact)
						elem:text[x][1] := substr(elem:text[x+1][1], 1, spos-1)
						elem:text[x+1][1] := ltrim(substr(elem:text[x+1][1], spos))
						elem:text[x][2] := len(elem:text[x][1])
						elem:text[x+1][2] := len(elem:text[x+1][1])
						wfact += elem:text[x][2]
						//elem:high ++

						exit
					endif
				next
				::doc:n_Line := rtbl+rl
				::doc:n_Pos := rc
				for x=1 to y
					if valtype(elem:text[x][1])=="O"
						::parseTag(elem:text[x][1])
					else
						::doc:Text(elem:text[x][1], ::doc:n_Line, ::doc:n_Pos,,,::clr)
				::doc:refresh()
					endif
				next
				for x=1 to y
					adel(elem:text, 1)
				next
				asize(elem:text, len(elem:text)-y)
				rl++
			enddo
			/*
			if rl>hcls
				hcls := rl
			endif
			*/
			//highs[j] := rl
			//for x=rl to hcls
			for x=hcls to rl
				dc := -1
				for y=1 to j
					if ctbl[i][y]:high <= rl
						ctbl[i][y]:high ++
						symb := iif(y==1 .or. ctbl[i][y-1]:COL==1, box[5], " ")
						//::doc:Text(symb,rtbl+x-1,rc+dc,,,tcolor)
						::doc:Text(symb,rtbl+x-1,cell_pos[y]-1,,,tcolor)
						::doc:refresh()
						symb := iif(y==len(ctbl[i]) .or. ctbl[i][y]:COL==1, box[5], " ")
						//::doc:Text(symb,rtbl+x-1,rc+dc+ctbl[i][y]:WIDTH+1,,,tcolor)
						::doc:Text(symb,rtbl+x-1,cell_pos[y]+ctbl[i][y]:WIDTH,,,tcolor)
						::doc:refresh()
						dc += ctbl[i][y]:WIDTH+1
					endif
				next
			next
			if rl>hcls
				hcls := rl
			endif
			rc += w+1
			s1 += symb_tbl(ctbl, i, j)
		next
		::doc:n_Line := rtbl+hcls
		::doc:n_Pos := ::doc:marginleft
		::doc:Text(s1,::doc:n_Line,::doc:n_Pos,,,tcolor)
				::doc:refresh()
	next
return
*************
static function parse_Form(tag)
local item:=map()
	item:action := ::url:makeUrl()
	item:enctype := ""
	item:method := "GET"
	item:target := ""
	item:index := len(::form)+1
	item:items := {}
	if "ACTION"$tag:fields
		item:action := tag:fields:ACTION
	endif
	if "ENCTYPE"$tag:fields
		item:enctype := tag:fields:ENCTYPE
	endif
	if "METHOD"$tag:fields
		item:method := tag:fields:METHOD
	endif
	if "TARGET"$tag:fields
		item:target := tag:fields:TARGET
	endif
	aadd(::form, item)
	::ndxForm := len(::form)
return .t.
*************
static function parse_Input(tag, insTag)
local item:=map(), ind, clr, clrh, s_file, numb, str
	ind := len(::form)
	item:type := "TEXT"
	item:value := replicate(" ", 10)
	item:name := ""
	item:size := 0
	item:maxlength := 0
	item:checked := .f.
	insTag := iif(insTag==NIL, .t., insTag)
	if "TYPE"$tag:fields
		item:type := upper(tag:fields:TYPE)
	endif
	if "VALUE"$tag:fields
		item:value := tag:fields:VALUE
	endif
	if "NAME"$tag:fields
		item:name := upper(tag:fields:NAME)
	endif
	if "SIZE"$tag:fields
		item:size := &(tag:fields:SIZE)
	endif
	if "MAXLENGTH"$tag:fields
		item:maxlength := &(tag:fields:MAXLENGTH)
	endif
	if "CHECKED"$tag:fields
		item:checked := .t.
	endif
	if item:size == 0
		item:size := len(item:value)
	endif
	if item:maxlength == 0
		item:maxlength := max(len(item:value), int(::width/3))
	endif
	item:value := padr(item:value, item:maxlength)
	clr:=::__colors[7]+","+::__colors[8]
	if !insTag
		return item:maxlength
	endif
	do case
	case item:type == "TEXT"
		::addObject(item:value, clr, "Get", , item:size, item:name)
	case item:type == "CHECKBOX"
		::addObject(item:checked, clr, "Check",,,item:name)
	case item:type == "FILE"
		s_file := " ":replicate(256)
		::addObject(s_file, clr, "Browse", "", int(::width/3), item:name)
	case item:type == "HIDDEN"
	case item:type == "IMAGE"
		::parse_Image()
	case item:type == "PASSWORD"
		::addObject(item:value, clr, "Password", "@Q", item:size, item:name)
	case item:type == "RADIO"
		::addObject(item:checked, clr, "Radio", item:name,, item:name)
	case item:type == "RESET"
	case item:type == "SUBMIT"
		item:name := iif(empty(item:name), "SUBMIT", item:name)
		str := ::form[::ndxForm]:action
		::addObject(item:name,,"Button", {|s, self| self:newRefer(str)},,item:name )

	endcase
return item:maxlength
*************
static function parse_Image(tag)
	if "ALT"$tag:fields
		::str := "["+tag:fields:ALT+"]"
	else
		::str := "[IMG]"
	endif
	if "SRC"$tag:fields
	endif
return len(::str)
*************
static function parse_TextArea(tag, width)
local item:=map(), ind, clr, str:="", s, vt
	ind := len(::form)
	item:name := ""
	item:cols := 0
	item:rows := 0
	item:wrap := "OFF"
	if "NAME"$tag:fields
		item:name := upper(tag:fields:NAME)
	endif
	if "COLS"$tag:fields
		item:cols := &(tag:fields:COLS)
	endif
	if "ROWS"$tag:fields
		item:rows := &(tag:fields:ROWS)
	endif
	if "WRAP"$tag:fields
		item:wrap := upper(tag:fields:WRAP)
	endif
	clr:=COLOR_TEXTAREA
	if item:cols==0
		item:cols := max(item:cols, int(::width/3))
	endif
	if item:rows==0
		item:rows := max(item:rows, int(::rows/3))
	endif
	do while !::parser:empty()
		s := ::parser:get()
		vt := valtype(s)
		if vt=="O"
			exit
		endif
		if vt == "C"
			str += s+"&\n"
		endif
	enddo
	str := left(str, len(str)-1)
	::doc:GetText(::doc:n_Line,::doc:n_Pos,::doc:n_Line+item:rows,::doc:n_Pos+item:cols,str,clr,,,,item:name)
return item:cols
***********
static function Browse_File(numb)
local str := ""
	str := fileDialog()
	::doc:setValue(numb, iif(len(str)>256, str, padr(str, 256)))
return
***********
static func __setcolor()
local i, s
       s:=::colorSpec
       while len(s)>0
	   i:=at(",",s)
	   i=iif(i==0,len(s)+1,i)
	   aadd(::__colors,substr(s,1,i-1) )
	   s:=substr(s,i+1)
       enddo
       ::new_clr(::__colors[1])
       ::htmlColors:LIGHT_YELLOW := ::htmlColors:LIGHTYELLOW  := ::htmlColors["#FFFFFC0"] := "GR+"
       ::htmlColors:DARK_YELLOW  := ::htmlColors:DARKYELLOW   := ::htmlColors["#FFFFFCC"] := "GR+"
       ::htmlColors:DARKER_YELLOW:= ::htmlColors:DARKERYELLOW := ::htmlColors["#FFFFF80"] := "GR+"
       ::htmlColors:LIGHT_BLUE   := ::htmlColors:LIGHTBLUE    := ::htmlColors["#DEEFEF"] := "BG+"
       ::htmlColors:LIGHT_GRAY   := ::htmlColors:LIGHTGRAY    := ::htmlColors["#F0F0F0"] := "W"

	::htmlColors:ALICEBLUE           := ::htmlColors["#A0CF00"] := "BG+"
	::htmlColors:ANTIQUEWHITE        := ::htmlColors["#FFE8D0"] := "W"
	::htmlColors:AQUA                := ::htmlColors["#00FFFF"] :=	"BG+"
	::htmlColors:AQUAMARINE          := ::htmlColors["#7FFFD0"] :=	"G+"
	::htmlColors:AZURE               := ::htmlColors["#F0FFFF"] := "W+"
	::htmlColors:BEIGE               := ::htmlColors["#F0F7DF"] := "W"
	::htmlColors:BISQUE              := ::htmlColors["#FFE7C0"] := "GR"
	::htmlColors:BLACK               := ::htmlColors["#000000"] := "N"
	::htmlColors:BLANCHEDALMOND      := ::htmlColors["#FFE8CF"] := "GR"
	::htmlColors:BLUE                := ::htmlColors["#0000FF"] := "B"
	::htmlColors:BLUEVIOLET          := ::htmlColors["#8F28E0"] := "B"
	::htmlColors:BROWN               := ::htmlColors["#A0282F"] := "GR"
	::htmlColors:BURLYWOOD           := ::htmlColors["#DFB880"] := "GR"
	::htmlColors:CADETBLUE           := ::htmlColors["#5F9FA0"] := "G"
	::htmlColors:CHARTREUSE          := ::htmlColors["#7FFF00"] := "G+"
	::htmlColors:CHOCOLATE           := ::htmlColors["#D0861F"] := "GR"
	::htmlColors:CORAL               := ::htmlColors["#FF7F50"] := "R+"
	::htmlColors:CORNFLOWERBLUE      := ::htmlColors["#6097EF"] := "B+"
	::htmlColors:CORNSILK            := ::htmlColors["#FFF8DF"] := "W"
	::htmlColors:CRIMSON             := ::htmlColors["#DF173F"] := "R"
	::htmlColors:CYAN                := ::htmlColors["#00FFFF"] := "BG"
	::htmlColors:DARKBLUE            := ::htmlColors["#00008F"] := "B"
	::htmlColors:DARKCYAN            := ::htmlColors["#00888F"] := "BG"
	::htmlColors:DARKGOLDENROD       := ::htmlColors["#BF87F0"] := "B"
	::htmlColors:DARKGRAY            := ::htmlColors["#AFA8AF"] := "N"
	::htmlColors:DARKGREEN           := ::htmlColors["#006700"] := "G"
	::htmlColors:DARKKHAKI           := ::htmlColors["#BFB76F"] := "G"
	::htmlColors:DARKMAGENTA         := ::htmlColors["#8F008F"] := "RB"
	::htmlColors:DARKOLIVEGREEN      := ::htmlColors["#50682F"] := "G"
	::htmlColors:DARKORANGE          := ::htmlColors["#FF8F00"] := "GR"
	::htmlColors:DARKORCHID          := ::htmlColors["#9F30CF"] := "RB"
	::htmlColors:DARKRED             := ::htmlColors["#8F0000"] :=	"R"
	::htmlColors:DARKSALMON          := ::htmlColors["#EF977F"] := "R+"
	::htmlColors:DARKSEAGREEN        := ::htmlColors["#8FBF8F"] := "G+"
	::htmlColors:DARKSLATEBLUE       := ::htmlColors["#4F3F8F"] := "W"
	::htmlColors:DARKSLATEGRAY       := ::htmlColors["#2F4F4F"] := "W"
	::htmlColors:DARKTURQUOISE       := ::htmlColors["#00CFD0"] := "G+"
	::htmlColors:DARKVIOLET          := ::htmlColors["#9000D0"] := "B"
	::htmlColors:DEEPPINK            := ::htmlColors["#FF1790"] := "RB"
	::htmlColors:DEEPSKYBLUE         := ::htmlColors["#00BFFF"] := "B+"
	::htmlColors:DIMGRAY             := ::htmlColors["#6F686F"] := "W"
	::htmlColors:DODGERBLUE          := ::htmlColors["#1F90FF"] := "B+"
	::htmlColors:FIREBRICK           := ::htmlColors["#B02020"] := "R"
	::htmlColors:FLORALWHITE         := ::htmlColors["#FFF8F0"] := "W+"
	::htmlColors:FORESTGREEN         := ::htmlColors["#208820"] := "G"
	::htmlColors:FUCHSIA             := ::htmlColors["#FF00FF"] := "RB"
	::htmlColors:GAINSBORO           := ::htmlColors["#DFDFDF"] := "W"
	::htmlColors:GHOSTWHITE          := ::htmlColors["#FFF8FF"] := "W"
	::htmlColors:GOLD                := ::htmlColors["#FFD700"] := "GR+"
	::htmlColors:GOLDENROD           := ::htmlColors["#DFA720"] := "GR+"
	::htmlColors:GRAY                := ::htmlColors["#808080"] := "W"
	::htmlColors:GREEN               := ::htmlColors["#008000"] := "G"
	::htmlColors:GREENYELLOW         := ::htmlColors["#AFFF2F"] := "G+"
	::htmlColors:HONEYDEW            := ::htmlColors["#F0FFF0"] := "W"
	::htmlColors:HOTPINK             := ::htmlColors["#FF68B0"] := "R+"
	::htmlColors:INDIANRED           := ::htmlColors["#CF5F5F"] := "R"
	::htmlColors:INDIGO              := ::htmlColors["#4F0080"] := "B"
	::htmlColors:IVORY               := ::htmlColors["#FFFFF0"] := "W+"
	::htmlColors:KHAKI               := ::htmlColors["#F0E78F"] := "G"
	::htmlColors:LAVENDER            := ::htmlColors["#E0E7FF"] := "W"
	::htmlColors:LAVENDERBLUSH       := ::htmlColors["#FFF0F0"] := "W+"
	::htmlColors:LAWNGREEN           := ::htmlColors["#7FFF00"] := "G+"
	::htmlColors:LEMONCHIFFON        := ::htmlColors["#FFF8CF"] := "GR+"
	::htmlColors:LIGHTBLUE           := ::htmlColors["#AFD8E0"] := "B+"
	::htmlColors:LIGHTCORAL          := ::htmlColors["#F08080"] := "R+"
	::htmlColors:LIGHTCYAN           := ::htmlColors["#E0FFFF"] := "BG+"
	::htmlColors:LIGHTGOLDENRODYELLOW:= ::htmlColors["#FFF8D0"] := "W"
	::htmlColors:LIGHTGREEN          := ::htmlColors["#90EF90"] := "G+"
	::htmlColors:LIGHTGREY           := ::htmlColors["#D0D0D0"] := "W+"
	::htmlColors:LIGHTPINK           := ::htmlColors["#FFB7C0"] := "R+"
	::htmlColors:LIGHTSALMON         := ::htmlColors["#FFA07F"] := "R+"
	::htmlColors:LIGHTSEAGREEN       := ::htmlColors["#20B0AF"] := "BG+"
	::htmlColors:LIGHTSKYBLUE        := ::htmlColors["#80CFFF"] := "B+"
	::htmlColors:LIGHTSLATEGRAY      := ::htmlColors["#70889F"] := "W+"
	::htmlColors:LIGHTSTEELBLUE      := ::htmlColors["#B0C7DF"] := "B+"
	::htmlColors:LIGHTYELLOW         := ::htmlColors["#FFFFE0"] := "GR+"
	::htmlColors:LIME                := ::htmlColors["#00FF00"] := "G+"
	::htmlColors:LIMEGREEN           := ::htmlColors["#30CF30"] := "G+"
	::htmlColors:LINEN               := ::htmlColors["#FFF0E0"] := "W"
	::htmlColors:MAGENTA		 := ::htmlColors["#FF00FF"] := "RB"
	::htmlColors:MAROON              := ::htmlColors["#800000"] := "GR"
	::htmlColors:MEDIUMAQUAMARINE    := ::htmlColors["#60CFAF"] := "G+"
	::htmlColors:MEDIUMBLUE          := ::htmlColors["#0000CF"] := "B+"
	::htmlColors:MEDIUMORCHID        := ::htmlColors["#BF57D0"] := "R+"
	::htmlColors:MEDIUMPURPLE        := ::htmlColors["#9070DF"] := "R+"
	::htmlColors:MEDIUMSEAGREEN      := ::htmlColors["#3FB070"] := "G+"
	::htmlColors:MEDIUMSLATEBLUE     := ::htmlColors["#7F68EF"] := "B+"
	::htmlColors:MEDIUMSPRINGGREEN   := ::htmlColors["#00F89F"] := "G+"
	::htmlColors:MEDIUMTURQUOISE     := ::htmlColors["#4FD0CF"] := "G+"
	::htmlColors:MEDIUMVIOLETRED     := ::htmlColors["#C01780"] := "R"
	::htmlColors:MIDNIGHTBLUE        := ::htmlColors["#1F1870"] := "B"
	::htmlColors:MINTCREAM           := ::htmlColors["#F0FFFF"] := "W"
	::htmlColors:MISTYROSE           := ::htmlColors["#FFE7E0"] := "W"
	::htmlColors:MOCCASIN            := ::htmlColors["#FFE7B0"] := "GR+"
	::htmlColors:NAVAJOWHITE         := ::htmlColors["#FFDFAF"] := "GR+"
	::htmlColors:NAVY                := ::htmlColors["#000080"] := "B"
	::htmlColors:OLDLACE             := ::htmlColors["#FFF7E0"] := "W"
	::htmlColors:OLIVE               := ::htmlColors["#808000"] := "G"
	::htmlColors:OLIVEDRAB           := ::htmlColors["#6F8F20"] := "G"
	::htmlColors:ORANGE              := ::htmlColors["#FFA700"] := "GR"
	::htmlColors:ORANGERED           := ::htmlColors["#FF4700"] := "GR"
	::htmlColors:ORCHID 		 := ::htmlColors["#DF70D0"] := "R+"
	::htmlColors:PALEGOLDENROD       := ::htmlColors["#EFE8AF"] := "GR+"
	::htmlColors:PALEGREEN           := ::htmlColors["#9FF89F"] := "G+"
	::htmlColors:PALETURQUOISE       := ::htmlColors["#AFEFEF"] := "G+"
	::htmlColors:PALEVIOLETRED       := ::htmlColors["#DF7090"] := "R+"
	::htmlColors:PAPAYAWHIP          := ::htmlColors["#FFEFD0"] := "GR"
	::htmlColors:PEACHPUFF           := ::htmlColors["#FFD8BF"] := "GR"
	::htmlColors:PERU                := ::htmlColors["#CF873F"] := "GR"
	::htmlColors:PINK                := ::htmlColors["#FFC0CF"] := "R+"
	::htmlColors:PLUM                := ::htmlColors["#DFA1DF"] := "B"
	::htmlColors:POWDERBLUE          := ::htmlColors["#B0E0E0"] := "BG+"
	::htmlColors:PURPLE              := ::htmlColors["#800080"] := "RB"
	::htmlColors:RED                 := ::htmlColors["#FF0000"] := "R"
	::htmlColors:ROSYBROWN           := ::htmlColors["#BF8F8F"] := "GR"
	::htmlColors:ROYALBLUE           := ::htmlColors["#4068E0"] := "B"
	::htmlColors:SADDLEBROWN         := ::htmlColors["#8F4710"] := "GR"
	::htmlColors:SALMON              := ::htmlColors["#FF8070"] := "R+"
	::htmlColors:SANDYBROWN          := ::htmlColors["#F0A760"] := "GR+"
	::htmlColors:SEAGREEN            := ::htmlColors["#2F8850"] := "G"
	::htmlColors:SEASHELL            := ::htmlColors["#FFF7EF"] := "W"
	::htmlColors:SIENNA              := ::htmlColors["#A0502F"] := "GR"
	::htmlColors:SILVER              := ::htmlColors["#C0C0C0"] := "W+"
	::htmlColors:SKYBLUE             := ::htmlColors["#80CFEF"] := "B+"
	::htmlColors:SLATEBLUE           := ::htmlColors["#6F58CF"] := "B"
	::htmlColors:SLATEGRAY           := ::htmlColors["#708090"] := "W"
	::htmlColors:SNOW                := ::htmlColors["#FFF8FF"] := "W+"
	::htmlColors:SPRINGGREEN         := ::htmlColors["#00FF7F"] := "G+"
	::htmlColors:STEELBLUE           := ::htmlColors["#4080B0"] := "B+"
	::htmlColors:TAN                 := ::htmlColors["#D0B78F"] := "GR"
	::htmlColors:TEAL                := ::htmlColors["#008080"] := "G"
	::htmlColors:THISTLE             := ::htmlColors["#DFBFDF"] := "RB+"
	::htmlColors:TOMATO              := ::htmlColors["#FF6040"] := "R"
	::htmlColors:TURQUOISE           := ::htmlColors["#40E0D0"] := "BG+"
	::htmlColors:VIOLET              := ::htmlColors["#EF80EF"] := "RB+"
	::htmlColors:WHEAT               := ::htmlColors["#F0DFB0"] := "GR+"
	::htmlColors:WHITE               := ::htmlColors["#FFFFFF"] := "W+"
	::htmlColors:WHITESMOKE          := ::htmlColors["#F0F7F0"] := "W+"
	::htmlColors:YELLOW              := ::htmlColors["#FFFF00"] := "GR+"
	::htmlColors:YELLOWGREEN         := ::htmlColors["#9FCF30"] := "G+"
return
***************
static function getHcolor(oldcolor, newcolor)
	newcolor := upper(newcolor)
	if newcolor$::htmlColors
		return (::htmlColors[newcolor]+substr(oldcolor, at("/", oldcolor)))
	endif
return oldcolor
***************
static function rest_clr()
local l:=len(::clrHist)-1
	if l<=0
		aadd(::clrHist, ::__colors[1])
	else
		asize(::clrHist, l)
	endif
	::clr := atail(::clrHist)
return
***************
static function new_clr(newColor)
	aadd(::clrHist, newColor)
	::clr := atail(::clrHist)
return
***********
static function goBack()
	::indStory --
	if ::indStory<1
		alert("It is the first document!")
		::indStory ++
	else
		::newRefer(::Story[::indStory]:url, .f.)
	endif
return
***********
static function goNext()
	::indStory ++
	if ::indStory>len(::Story)
		alert("It is the last document!")
		::indStory --
	else
		::newRefer(::Story[::indStory]:url, .f.)
	endif
return
************************************************
static function br_menu_Create(enable)
#define FA_NORMAL	0
#define FA_READONLY	1
#define FA_HIDDEN	2
#define FA_SYSTEM	4
#define FA_VOLUME	8
#define FA_DIRECTORY	16
#define FA_ARCHIVE	32
local oTopBar, oPopUp, oPopUp1, oItem
local keys:=HK_get("htmlBrowser"),kn
local fchs:="", a, b:={}, i, oPopUp2
	#ifdef OS_CYGWIN
	fchs := "C:/cygwin"
	#endif
	fchs += cliproot()+"/charsets/"+"*.tbl"
	a = fileseek(fchs, FA_ARCHIVE+FA_VOLUME+FA_SYSTEM+FA_HIDDEN+FA_READONLY)
	while !empty(a)
		a := left(a, len(a)-4)
		aadd(b, a)
		a = fileseek()
	enddo
	b := asort(b,,,{|x, y| x < y})

      oTopBar := TopBar( 0, 0, maxcol())
      oTopBar:ColorSpec := COLOR_MENU

      oPopUp := PopUp()
      oPopUp :ColorSpec:= COLOR_MENU
      oTopBar:AddItem( MenuItem ( [&File],oPopUp) )

      //oPopUp:AddItem( MenuItem( MENU_SEPARATOR ) )
      /*
      kn:=key_name(HK_get_key(keys,HASH_OpenNew))
      oItem :=MenuItem( [Load New URL   ]+kn ,{|| .t. }, ,[Load new URL], HASH_OpenNew)
      oPopUp:AddItem( oItem)
      */


      oPopUp2 := PopUp()
      oPopUp2:ColorSpec:= COLOR_MENU
      for i=1 to len(b)
	oItem :=MenuItem( b[i] ,{|| local(_1:=@b[i]), set("HV_CHARSET", _1) }, ,, HASH_SetCodePage)
	oPopUp2:AddItem( oItem)
      next
      oPopUp:AddItem( MenuItem([&Charset], oPopUp2) )

      kn:=key_name(HK_get_key(keys,HASH_Exit))
      oItem :=MenuItem( [E&xit   ]+kn ,{|| .t. }, ,[End of application], HASH_Exit)
      oPopUp:AddItem( oItem)

      oPopUp := PopUp()
      oPopUp :ColorSpec:= COLOR_MENU
      oTopBar:AddItem( MenuItem ( [&Control],oPopUp) )

      kn:=key_name(HK_get_key(keys,HASH_NextItem))
      oItem :=MenuItem( [&Next   ]+kn ,{|| .t. }, ,[Go next item], HASH_NextItem)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_PrevItem))
      oItem :=MenuItem( [&Prev   ]+kn ,{|| .t. }, ,[Go previous item], HASH_PrevItem)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_PrevUrl))
      oItem :=MenuItem( [P&revUrl   ]+kn ,{|| .t. }, ,[Go previous URL document], HASH_PrevUrl)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_NextUrl))
      oItem :=MenuItem( [Nex&tUrl   ]+kn ,{|| .t. }, ,[Go next URL document], HASH_NextUrl)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_InfoUrl))
      oItem :=MenuItem( [&InfoUrl   ]+kn ,{|| .t. }, ,[Get information about URL document], HASH_InfoUrl)
      oPopUp:AddItem( oItem)


      oPopUp := PopUp()
      oPopUp :ColorSpec:= COLOR_MENU
      oTopBar:AddItem( MenuItem ( [&Options],oPopUp) )

      kn:=key_name(HK_get_key(keys,HASH_Find))
      oItem :=MenuItem( [&Find   ]+kn ,{|| .t. }, ,[Find string], HASH_Find)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_ResumeFind))
      oItem :=MenuItem( [&Resume   ]+kn ,{|| .t. }, ,[Resume find string], HASH_ResumeFind)
      oPopUp:AddItem( oItem)

      kn:=key_name(HK_get_key(keys,HASH_UnmarkBlock))
      oItem :=MenuItem( [&Unmark   ]+kn ,{|| .t. }, ,[Unmark selected block], HASH_UnmarkBlock)
      oPopUp:AddItem( oItem)

   return ( oTopBar)
