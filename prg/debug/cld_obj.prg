/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "config.ch"
#include "inkey.ch"
#include "debug.ch"
#include "imenu.ch"
#include "set.ch"
#include "ctwin.ch"
#include "box.ch"


************************************************
static com_names:={;
    {"rem","#", "*", "//" } ;
   ,{"I","ı","INPUT", "ıÚ·˜ÏÂÓÈÂ" } ;
   ,{"M","Ì","MONITOR","ÌÔÓÈÙÔÚ"} ;
   ,{ "?","??" } ;
   ,{"A","·","ANIMATE","·ÓÈÌ·„ÈÒ" } ;
   ,{"B","BP","ÙÔ","BREAKPOINT" } ;
   ,{"C","˜˘˙Ô˜","CALLSTACK" } ;
   ,{"D","‰","ı‰·ÏÈÙ¯","DELETE" } ;
   ,{"DOS","OS" } ;
   ,{"RUN" } ;
   ,{"F","FIND","ÔÈÛÎ" } ;
   ,{"GO","ıÛÎ" } ;
   ,{"G","GOTO","ÂÚÂËÔ‰" } ;
   ,{"H","HELP","ÔÌÔ˝¯" } ;
   ,{"L","LIST","ÛÈÛÔÎ" } ;
   ,{"N","NEXT","ÛÏÂ‰ı‡˝ÂÂ" } ;
   ,{"NUM","ÓıÌÂÚ·„ÈÒ" } ;
   ,{"O","OUTPUT","¸ÎÚ·Ó" } ;
   ,{"P","PREV","ÚÂ‰˘‰ı˝ÂÂ" } ;
   ,{"Q","QUIT","ÎÔÓÂ„" } ;
   ,{"R","RESTART","ÚÂÛÙ·ÚÙ" } ;
   ,{"RESUME","ÈÛËÔ‰ÓÔÂ" } ;
   ,{"SPEED","ÛÎÔÚÔÛÙ¯" } ;
   ,{"S","STEP","˚·Á" } ;
   ,{"T","TP","ÙÙ","TRACEPOINT" } ;
   ,{"V","VIEW","˙·ÁÚı˙ÈÙ¯" } ;
   ,{"W","WP","Ù˙","VIEWPOINT" } ;
   ,{"CONNECT","CO" } ;
   ,{"!","!!" } ;
   ,{"TABSIZE","TS","Ù·‚" } ;
   ,{"PATH","PATH","ıÙ¯" } ;
   ,{"CBTRACE","CB","‚ÏÔÎ" } ;
   ,{"PPVIEW","PP","" } ;
   ,{"SAVE","ÛÔËÚ·ÓÈÙ¯" } ;
   ,{"VIEWALIASES","VA","ÚÔ"} ;
   }

static mon_names:={ ;
    {"PU","PUBLIC","ı","ı‚ÏÈÛ"};
   ,{"PR","PRIVATE","Ú","ÚÈ˜¸ÍÙ"};
   ,{"ST","STATIC","ÛÙ","ÛÙ·ÙÈÎ"};
   ,{"LO","LOCAL","ÏÔ","ÏÔÎ·Ï"};
   ,{"FI","FIELD","ÊÈ","ÊÈÏ‰"};
   }

static point_names:={ ;
    {"B","BP","ÙÔ","BREAKPOINT" } ;
   ,{"T","TP","ÙÙ","TRACEPOINT" } ;
   ,{"W","WP","Ù˙","VIEWPOINT" } ;
   }


************************************************
procedure debugNew()

	local obj:=map()

	clear screen
	obj:classname	:= "DEBUG"
	obj:curWin	:= 0
	obj:curSrcWin	:= 0
	obj:aniSpeed	:= 5
	obj:animation	:= .f.
	obj:_tabSize	:= 8
	obj:_path	:= "."
	obj:findOptions	:= NIL
	obj:findHistory	:= NIL
	obj:color	:= set("debug_colors")
	obj:maxrow	:= maxrow()
	obj:maxcol	:= maxcol()
	obj:mapKeys	:= HK_get("debug")
	obj:windows	:= {}
	obj:BreakPoints	:= {}
	obj:TracePoints	:= {}
	*****
	obj:HandleKey	:= @HandleKey()
	obj:help	:= @command_help()
	obj:quit	:= @command_quit()
	obj:viewFile	:= @command_viewFile()
	obj:listWin	:= @command_listWin() // list of windows
	obj:addBP	:= @command_addBP()
	obj:addTP	:= @command_addTP()
	obj:listBP	:= @command_listBP()
	obj:listTP	:= @command_listTP()
	obj:listVP	:= @command_listVP()
	obj:find	:= @command_find()
	obj:gotoLine	:= @command_gotoLine()
	obj:tabSize	:= @command_tabSize()
	obj:srcPath	:= @command_srcPath()
	obj:statusLine	:= @statusLine()
	obj:viewVar	:= @dbg_viewVar()
	obj:monitor	:= @dbg_monitor()
	obj:viewSetValues:= @viewSetValues()
	obj:viewWorkSel := @viewWorkSel()
	obj:run		:= @command_run()  // run command from keyboard
	obj:setNumStyle	:= @command_setNumStyle()
	obj:setCbTrace	:= @command_setCbTrace()
	obj:saveOptions	:= @command_saveOptions()
	obj:loadOptions	:= @command_loadOptions()

	***
	obj:fileName	:= ""
	obj:funcName	:= ""
	obj:numStr	:= 0
	obj:dbgconnect	:= NIL
	obj:dbg_command	:= @dbg_command()
	obj:connect	:= @command_connect()
	obj:frame	:= @command_frame()
	obj:macro	:= @command_macro()
	obj:step	:= @command_step()
	obj:continue	:= @command_continue()
	obj:trace	:= @command_trace()
	obj:until	:= @command_until()
	obj:restart	:= @command_restart()
	obj:viewScreen	:= @command_viewScreen()
	obj:viewStack	:= @command_viewStack()
	obj:viewBp	:= @command_viewBp()
	***

	obj:destroy	:= @command_destroy()

	obj:menu:=make_debug_menu(obj)
	obj:winNo:=obj:menu:winNo
	//wclose()

	obj:command:=make_debug_command_window(obj:maxrow-COMMAND_SIZE,0,obj:maxrow-1,obj:maxcol,len(obj:windows)+1)
	aadd(obj:windows,obj:command)
	obj:curWin:=len(obj:windows)
	obj:command:setFocus()
	obj:values:=make_debug_values_window(obj,1,0,VALUES_SIZE,obj:maxcol,len(obj:windows)+1,obj:maxrow-1)
	aadd(obj:windows,obj:values)
	obj:values:redraw()

return  obj

************************************************
static function command_destroy()
	if ::dbgconnect!=NIL
		dbgclose(::dbgconnect)
	endif
return .t.
************************************************
static function command_setNumStyle(new_val)
	local i
	for i=1 to len(::windows)
		if ::windows[i]:classname=="DBG_SOURCE"
			::windows[i]:setNumStyle(new_val)
		endif
	next
return .t.
************************************************
static function command_setCbTrace(new_val)
	local r,s:="option codeblock "+iif(new_val,"1","0")
	r:=::dbg_command(s)
return
************************************************
static function command_Quit()
	local ret:=.f.,oldwin:=wselect()
	wopen(0,0,::maxrow,::maxcol,.f.)
	setcolor(set("debug_colors_menu"))
	ret=otvet([Exit from debugger ?])
	wclose()
	wselect(oldwin)
	if ::dbgconnect!=NIL
		dbgclose(::dbgconnect)
	endif
return ret
************************************************
static function command_listWin(x)
	if x==NIL
		dispbegin()
		wopen(0,0,::maxrow,::maxcol,.f.)
		setcolor(set("debug_colors_menu"))
		m:={}
		for x=1 to len(::windows)
			y:=str(::windows[x]:headWin,2,0)+":"
			y+=::windows[x]:name+":"
			y+=::windows[x]:header
			aadd(m,y)
		next
		x=(::maxrow-len(::windows)-2)/2
		x=max(2,x)
		save screen to scr
		dispend()
		//setcolor(set("debug_colors_menu"))
		x=achoice(x,15,::maxrow-x,65,m,,,::curWin,::curWin,,B_DOUBLE,[List Windows])
		dispbegin()
		restore screen from scr
		wclose()
		wselect(::winno)
	endif
	if x>0 .and. x<=len(::windows)
		::windows[::curWin]:killFocus()
		::windows[x]:setFocus()
		::curWin:=x
		if ::windows[::curWin]:classname=="DBG_SOURCE"
			::curSrcWin:=x
		endif
	endif
	dispend()
return .t.
************************************************
static function command_viewStack()
	local y,m
	dispbegin()
	wopen(0,0,::maxrow,::maxcol,.f.)
	setcolor(set("debug_colors_menu"))
	dispend()
	y:=::dbg_command("t")
	m:=split(y,"&\n")
	achoice(2,5,::maxrow-2,::maxcol-5,m,,,,,,B_DOUBLE,[Call stack])
	dispbegin()
	wclose()
	wselect(::winno)
	dispend()
return .t.
************************************************
static function command_viewBp()
	local y,m
	dispbegin()
	wopen(0,0,::maxrow,::maxcol,.f.)
	setcolor(set("debug_colors_menu"))
	dispend()
	y:=::dbg_command("b")
	m:=split(y,"&\n")
	adel(m,1)
	asize(m,len(m)-1)
	achoice(2,5,::maxrow-2,::maxcol-5,m,,,,,,B_DOUBLE,[Call stack])
	dispbegin()
	wclose()
	wselect(::winno)
	dispend()
return .t.
************************************************
static function command_help(cont)
	local f
	f=cliproot()+"file:"+f+[/doc/rus/debug.html] //+iif(!empty(cont),"#"+cont,"")
	wopen(0,0,::maxrow,::maxcol,.f.)
	hbrowse(,,,,f)
	wclose()
	wselect(::winno)
return .t.
************************************************
static function command_Restart()
return .t.
************************************************
static function command_Connect(_pid)
	local i,x,pid,in:=space(0), mp:={}
#ifdef __UNIX__
	syscmd("ps x","",@in)
	mp:=split(in,"&\n")
	adel(mp,1)
	asize(mp,len(mp)-1)
#else
	aadd(mp,[NonUnix is not supported !])
#endif
	if !empty(_pid)
		for i=1 to len(mp)
			if ! ("--debug" $ mp[i] .or. "--stop" $ mp[i])
				loop
			endif
			in := ltrim(mp[i])
			while "  " $ in
				in := strtran(in,"  "," ")
			enddo
			x := split(in," ")
			if val(_pid) == val(x[1])
				pid := val(mp[i])
				exit
			endif
			if _pid == x[5]
				pid := val(mp[i])
				exit
			endif
		next
		if empty(pid)
			::command:put([Process not found:]+_pid )
		endif
	endif

	if empty(pid)
		dispbegin()
		wopen(0,0,::maxrow,::maxcol,.f.)
		setcolor(set("debug_colors_menu"))
		x=max(2,(::maxrow-len(mp)-2)/2)
		save screen to scr
		dispend()
		//setcolor(set("debug_colors_menu"))
		x=achoice(x,15,::maxrow-x,65,mp,,,,,,B_DOUBLE,[Process List])
		dispbegin()
		restore screen from scr
		wclose()
		wselect(::winno)
		dispend()
		if x>0
			pid := val(mp[x])
		endif
	endif

	if !empty(pid)
		if ::dbgconnect!=NIL
			dbgclose(::dbgconnect)
		endif
		::dbgconnect:=dbgconnect(pid)
		::command:put([Process connection OK]+":"+alltrim(str(pid)) )
		::dbg_command("option codeblock "+iif(::menu:cbTraceStyle(),"1","0"))
		::frame()
		return .t.
	endif
	::command:put([Process connection error] )
return .f.
************************************************
static function command_frame()
	local r,s,i,j,f,_paths,flag:=.f.
	if ::dbgconnect==NIL
		return .f.
	endif
	if ::curSrcWin!=0 .and. ::numStr!=0
		::windows[::curSrcWin]:highLightDel(::numStr,4)
	endif
	r:=::dbg_command("f")
	if empty(r)
		return .f.
	endif
	r:=left(r,len(r)-1)
	r:=split(r," ")
	s:=r[2] // filename
	i=at(":",s)
	f:=substr(s,i+1)
	if !(f==::fileName)
		_paths:=split(::_path,DBG_DELIM)
		for i=1 to len(_paths)
		   flag := ::viewFile(alltrim(_paths[i])+PATH_DELIM+f)
		   if flag
			exit
		   endif
		next
		if !flag .and. !::viewFile(f)
				::fileName:=""
				::numStr:=0
				::funcName:=""
				return .f.
		endif
	endif
	s:=r[2] // filename
	i=at(":",s)
	::fileName:=substr(s,i+1)
	s:=r[3] // line
	i=at(":",s)
	::numStr:=val(substr(s,i+1))
	s:=r[4] // funcname
	i=at(":",s)
	::funcName:=substr(s,i+1)
	//::viewFile(::filename)
	if ::numStr!=0
		::gotoLine(::numStr)
	endif
	if ::curSrcWin!=0 .and. ::numStr!=0
		::windows[::curSrcWin]:highLightAdd(::numStr,4)
	endif
	::values:redraw()
	::command:put(::fileName+":"+::funcName+":"+str(::numStr))
return .t.
************************************************
static function command_macro(str,flag)
	local ret,h,i,s1:=""
	flag:=iif(flag==NIL,.f.,.t.)
	ret:=::dbg_command(iif(flag,"p","e")+" -binary "+str)
	ret:=strtran(ret,"&\n","")
	::frame()
	i:=at(DBG_DELIM,ret)
	s1:=s1+substr(ret,1,i)
	ret:=substr(ret,i+1)
	i:=at(DBG_DELIM,ret)
	s1:=s1+substr(ret,1,i)
	ret:=substr(ret,i+2)
	ret:=substr(ret,1,len(ret)-1)
	::command:put(s1+::viewvar(str,1,str2var(ret),.t.))
return ret
************************************************
function dbg_viewvar(vname,level,p,flag)
	local ret,i,m:={},mv:={},t:=valtype(p)
	local curWin:=wselect(), curPos:=1
	flag:=iif(flag==NIL,.t.,flag)
	do case
		case t=="A"
			ret:="{....}"
		case t=="B"
			ret:="{||...}"
		case t=="C"
			ret:=p
		case t=="D"
			ret:=dtoc(p)
		case t=="L"
			ret:=iif(p,".t.",".f.")
		case t=="M"
			ret:=p
		case t=="N"
			ret:=str(p)
		case t=="O"
			ret:="{object}"
		case t=="U"
			ret:="NIL"
	endcase
	ret:="("+t+"):"+ret
	if !flag
		return ret
	endif
	*********
	dispbegin()
	wopen(level,level,::maxrow-level,::maxcol-level,.f.)
	setcolor(set("debug_colors_dialog"))
	wbox()
	@ -1, (maxcol()-len(vname)-4)/2 say vname
	dispend()
	do case
		case t=="C" .and. len(p)>50
			memoedit(p)
		case t=="A"
			for i=1 to len(p)
				aadd(m,str(i,4,0)+"Å"+::viewVar(vname,level,p[i],.f.))
			next
			do while !empty(m)
				curPos=achoice(0,0,maxrow(),maxcol(),m,,,curPos,curPos)
				if lastkey()==27
					exit
				endif
				if lastkey()==13 .and. ( valtype(p[curPos]) $ "AOM" )
					t=vname+"["+alltrim(str(curPos))+"]"
					::viewvar(t,level+1,p[curPos],.t.)
				endif
			enddo
		case t=="M"
			memoedit(p)
		case t=="O"
			mv:=mapkeys(p)
			iii:=0
			for i=1 to len(mv)
				h=hashName(mv[i])
				if substr(h,1,2)=="0x"
					h=mv[i]
					h="e hashname("+alltrim(str(h))+")"
					h=::dbg_command(h)
					h=substr(h,at(DBG_DELIM,h)+1)
					h=substr(h,at(DBG_DELIM,h)+1)
					h=substr(h,at(DBG_DELIM,h)+2)
					h=substr(h,1,len(h)-1)
					hashstr(upper(h))  // ﬁ‘œ¬ ⁄ƒ≈”ÿ ⁄¡–œÕŒ…‘ÿ
				endif
				aadd(m,padr(h,15)+"Å"+::viewVar(vname,level,p[mv[i]],.f.) )
			next
			do while !empty(m)
				curPos=achoice(0,0,maxrow(),maxcol(),m,,,curPos,curPos)
				if lastkey()==27 .or. curPos<=0
					exit
				endif
				h=mv[curPos]
				if lastkey()==13 .and. ( valtype(p[h]) $ "AOM" )
					t=vname+"["+hashname(h)+"]"
					::viewvar(t,level+1,p[h],.t.)
				endif
			enddo
	endcase
	dispbegin()
	wclose()
	wselect(curWin)
	dispend()
return ret
************************************************
function dbg_monitor(self)
	local x
	if self:dbgconnect == NIL
		return NIL
	endif
	x:=make_debug_monitor_window(self,1,0,self:maxrow-1,self:maxcol,len(self:windows)+1)
	aadd(self:windows,x)
	if self:curwin>0 .and. self:curwin<=len(self:windows)
		self:windows[self:curwin]:killFocus()
	endif
	self:curwin:=len(self:windows)
	self:windows[self:curWin]:setFocus()
return x
************************************************
static function command_Step()
	local ret
	ret:=::dbg_command("s")
	::frame()
return .t.
************************************************
static function command_Trace()
	local ret
	ret:=::dbg_command("n")
	::frame()
return .t.
************************************************
static function command_continue()
	local ret
	ret:=::dbg_command("c")
	::frame()
return .t.
************************************************
static function command_until()
	local ret ,line, file
	if ::curSrcWin!=0
		line:=::windows[::curSrcWin]:edit:line
		file:=::windows[::curSrcWin]:edit:fileName
		ret:=::dbg_command("u "+file+":"+alltrim(str(line)) )
		::frame()
	endif
return .t.
************************************************
static function command_viewScreen()
	/*
	local y,curWin:=wselect(),scr
	wopen(0,0,::maxrow,::maxcol,.f.)
	scr:=savescreen()
	y:=::dbg_command("e -binary savescreen()")
	y=substr(y,at(DBG_DELIM,y)+1)
	y=substr(y,at(DBG_DELIM,y)+2)
	y=substr(y,1,len(y)-1)
	y=str2var(y)
	restore screen from y
	inkey(0)
	//restore screen from scr
	wselect(curWin)
	*/
	message("Sorry ! Not supported")
return .t.
************************************************
static function viewSetValues(self)
	local x
	x:=make_debug_viewSet_window(self,1,0,self:maxrow-1,self:maxcol,len(self:windows)+1)
	aadd(self:windows,x)
	if self:curwin>0 .and. self:curwin<=len(self:windows)
		self:windows[self:curwin]:killFocus()
	endif
	self:curwin:=len(self:windows)
	self:windows[self:curWin]:setFocus()
return x
************************************************
static function viewWorkSel(self)
	local x
	if self:dbgconnect == NIL
		return NIL
	endif
	x:=make_debug_viewAli_window(self,1,0,self:maxrow-1,self:maxcol,len(self:windows)+1)
	aadd(self:windows,x)
	if self:curwin>0 .and. self:curwin<=len(self:windows)
		self:windows[self:curwin]:killFocus()
	endif
	self:curwin:=len(self:windows)
	self:windows[self:curWin]:setFocus()
return x
************************************************
static function command_viewFile(filename)
	local x,y,fname,i,ccc:=::curWin
	if empty(filename)
		wopen(0,0,::maxrow,::maxcol,.f.)
		setcolor(set("debug_colors_menu"))
		filename=filedialog()
		wclose()
	endif
	if !empty(filename)
		fname=substr(filename,atr(PATH_DELIM,filename)+1)
		for x=1 to len(::windows)
			if ::windows[x]:classname=="DBG_SOURCE"
				y=::windows[x]:header
				if y!=NIL .and. y==fName
					::listWin(x)
					return .t.
				endif
			endif
		next
	endif
	if !file(filename)
		::command:put([File not found:]+fileName)
		//::curSrcWin:=0
		return .f.
	endif
	x:=make_debug_source_window(VALUES_SIZE+1,0,::maxrow-COMMAND_SIZE-1,::maxcol,fileName,len(::windows)+1,::maxrow-1)
	if !(valtype(x)=="O")
		fError(0)
		::command:put([error open "]+filename+'"')
		::command:put(fErrorStr())
		return .f.
	endif
	aadd(::windows,x)
	::curSrcWin:=len(::windows)
	::windows[::curSrcWin]:setNumStyle(::menu:numeration() )
	for i=1 to len(::breakpoints)
		if ::breakpoints[i][2]==filename
			::windows[::curSrcWin]:highLightAdd(::breakpoints[i][1],5)
		endif
	next
	if ccc>0 .and. ccc<=len(::windows)
			::windows[ccc]:killFocus()
	endif
	::curWin := ::curSrcWin
	::windows[::curWin]:setFocus()
	::command:put([open editor for "]+filename+'"')
return .t.
************************************************
static function command_find(str,where)
	local ret:=.t.,scr,oldwin:=wselect()
	if where==NIL
		where=0
	endif
	if ::curSrcWin==0
	   return
	endif
	if ::findOptions==NIL
		::findOptions := findOptions(,,set("debug_colors_dialog"), set("debug_colors_dialog"))
	endif
	if !empty(str)
		::findOptions:setFindStr(str)
	endif
	if where==0 .and. empty(str)
		wselect(::windows[::curSrcWin]:winNo)
		wopen(0,0,::maxrow,::maxcol,.f.)
		save screen to scr
		setcolor(set("debug_colors_menu"))
		::findOptions:get()
		restore screen from scr
		wclose()
		wselect(oldwin)
	endif
	wselect(::windows[::curSrcWin]:winno)
	do case
		case where==0
			ret=::windows[::curSrcWin]:edit:find(::findOptions)
		case where==1
			ret=::windows[::curSrcWin]:edit:findNext(::findOptions)
		case where==-1
			ret=::windows[::curSrcWin]:edit:findPrev(::findOptions)
	endcase
	wselect(oldWin)
	if !ret
		::command:put([string not found])
	endif
return ret
************************************************
static function command_gotoLine(num)
	local curWin:=wselect() ,scr
	if ::curSrcWin==0
		return .t.
	endif
	if valtype(num)!="N" .or. num==0
		num=0
		wselect(::windows[::curSrcWin]:winNo)
		save screen to scr
		setcolor(set("debug_colors_menu"))
		readkeyb(,,[Goto line number],@num)
		restore screen from scr
	endif
	wselect(::windows[::curSrcWin]:winNo)
	if !(::windows[::curSrcWin]:gotoLine(num))
	     ::command:put([error goto line: bad line number])
	endif
	wselect(curWin)
return .t.
************************************************
static function command_saveOptions()
	static file
	local curWin:=wselect(),hfile,i,f
	if file==NIL
		file:=space(256)
	endif
	dispbegin()
	wopen(0,0,::maxrow,::maxcol,.f.)
	setcolor(set("debug_colors_menu"))
	//save screen to scr
	dispend()
	readkeyb(,,[Filename for saving status],@file)
	dispbegin()
	//restore screen from scr
	wclose()
	wselect(curWin)
	dispend()
	f:=alltrim(file)
	if empty(f)
	   return .f.
	endif
	if !(".cld" $ f)
		f+=".cld"
	endif
	ferase(f)
	hfile:=fcreate(alltrim(f))
	if hfile<0
		message([Error create file:]+alltrim(f))
		return .f.
	endif
	fwrite(hfile,"tabsize "+alltrim(str(::_tabSize))+CRLF)
	fwrite(hfile,"path "+alltrim(::_path)+CRLF)
	fwrite(hfile,"cbtrace "+iif(::menu:cbTraceStyle(),"ON","OFF")+CRLF)
	fwrite(hfile,"ppview "+iif(::menu:preprocStyle(),"ON","OFF")+CRLF)
	fwrite(hfile,"num "+iif(::menu:numeration(),"ON","OFF")+CRLF)
	fwrite(hfile,"speed "+alltrim(str(::aniSpeed))+CRLF)
	for i=1 to len(::windows)
		if ::windows[i]:classname=="DBG_SOURCE"
			fwrite(hfile,"view "+;
				::windows[i]:edit:path+PATH_DELIM+;
				::windows[i]:edit:fileName+CRLF)
		endif
	next
	for i=1 to len(::breakPoints)
	    fwrite(hfile,"bp "+alltrim(str(::breakpoints[i][1]))+" ";
			+::breakpoints[i][2]+CRLF)
	next
	for i=1 to len(::values:points)
	    fwrite(hfile,"wp "+::values:points[i]+CRLF)
	next
	for i=1 to len(::tracePoints)
	    fwrite(hfile,"tp "+::tracepoints[i]+CRLF)
	next

	if ::dbgconnect!=NIL
		fwrite(hfile,"connect "+CRLF)
		for i=1 to len(::windows)
			if ::windows[i]:classname=="DBG_MONITOR"
				fwrite(hfile,"monitor "+CRLF)
				loop
			endif
			if ::windows[i]:classname=="DBG_VIEWALIASES"
				fwrite(hfile,"viewaliases "+CRLF)
				loop
			endif
		next
	endif

	fclose(hfile)
	message([Status saved to:]+alltrim(f))
return .t.
************************************************
static function command_loadOptions()
	static file
	local curWin:=wselect(),hfile,f
	if file==NIL
		file:=space(256)
	endif
	dispbegin()
	wopen(0,0,::maxrow,::maxcol,.f.)
	setcolor(set("debug_colors_menu"))
	//save screen to scr
	dispend()
	readkeyb(,,[Load options from file],@file)
	dispbegin()
	//restore screen from scr
	wclose()
	wselect(curWin)
	dispend()
	f:=alltrim(file)
	if empty(f)
	   return .f.
	endif
	if !(".cld" $ f)
		f+=".cld"
	endif
	::run("input "+f)
return
************************************************
static function command_tabSize(num)
	local i,curWin:=wselect() ,scr
	if valtype(num)!="N" .or. num==0
		dispbegin()
		wopen(0,0,::maxrow,::maxcol,.f.)
		setcolor(set("debug_colors_menu"))
		save screen to scr
		if num==NIL
			num=::_tabSize
		endif
		dispend()
		readkeyb(,,[new tabulation size],@num)
		dispbegin()
		restore screen from scr
		wclose()
		wselect(curWin)
		dispend()
	endif
	//if ::_tabSize!=num
		::_tabSize:=num
		for i=1 to len(::windows)
			if ::windows[i]:classname=="DBG_SOURCE"
				::windows[i]:setTabSize(::_tabSize)
			endif
		next
	//endif

return .t.
************************************************
static function command_srcPath(path)
	local curWin:=wselect() ,scr
	if valtype(path)!="C" .or. empty(path)
		dispbegin()
		wopen(0,0,::maxrow,::maxcol,.f.)
		setcolor(set("debug_colors_menu"))
		save screen to scr
		if path==NIL
			path=::_path
		endif
		path:=padr(path,256)
		dispend()
		readkeyb(,,[Search source files in directory],@path)
		dispbegin()
		restore screen from scr
		wclose()
		wselect(curWin)
		dispend()
	endif
	::_path:=alltrim(path)
return .t.
************************************************
static function command_listBP()
	local i
	for i=1 to len(::breakPoints)
		::command:put(str(i,2,0)+") line:"+alltrim(str(::breakPoints[i][1]))+" in file:"+::breakPoints[i][2])
	next
	if len(::breakPoints)==0
		::command:put([Break point list is empty])
	endif
return .t.
************************************************
static function command_listTP()
	local i
	for i=1 to len(::tracePoints)
		::command:put(str(i,2,0)+") expr:"+::tracePoints[i])
	next
	if len(::tracePoints)==0
		::command:put([Trace point list is empty])
	endif
return .t.
************************************************
static function command_listVP()
	local i
	for i=1 to len(::values:points)
		::command:put(str(i,2,0)+") expr:"+::values:points[i])
	next
	if len(::values:points)==0
		::command:put([Values list is empty])
	endif
return .t.
************************************************
static function command_addBP(numLine,fileName)
	local n, sss:=""
	if empty(fileName)
	   fileName:=::currentFile
	endif
	if empty(fileName)
	   ::command:put([error:invalid parameter <filename>])
	   return
	endif
	if (empty(numLine) .and. empty(filename) )
	   ::command:put([error:invalid parameter <line>])
	   return
	endif
	if at(".",filename)==0
		filename+=".prg"
	endif
	n=ascan(::breakPoints,{|x|x[1]==numLine .and. x[2]==fileName})
	if n==0
		// ƒ¡‘ÿ ÀœÕ¡Œƒ’ RT_CLIP
		if ::curSrcWin!=0
			::windows[::curSrcWin]:highLightAdd(numLine,5)
		endif
		aadd(::breakPoints,{numLine,fileName})
		::dbg_command("b "+filename+":"+alltrim(str(numLine)))
		sss:=[ADD ]
		n=len(::breakPoints)
	else
		// ƒ¡‘ÿ ÀœÕ¡Œƒ’ RT_CLIP
		::dbg_command("rm "+filename+":"+alltrim(str(numLine)))
		if ::curSrcWin!=0
			::windows[::curSrcWin]:highLightDel(numLine,5)
		endif
		adel(::breakPoints,n)
		asize(::breakPoints,len(::breakPoints)-1)
		sss:=[DELETE ]
	endif
	if !empty(sss)
	::command:put(sss+[break point for file "]+filename+'", line '+alltrim(str(numLine));
			 +', ('+alltrim(str(n))+'/'+alltrim(str(len(::breakpoints)))+')')
	endif
return .t.

************************************************
static function command_addTP(vstr)
	local n
	if empty(vstr)
	   ::command:put([error:invalid parameter <expr>])
	   return
	endif
	n=ascan(::TracePoints,vstr)
	if n==0
		// ƒ¡‘ÿ ÀœÕ¡Œƒ’ RT_CLIP
		aadd(::TracePoints,vstr)
		sss:="ADD "
		n=len(::TracePoints)
	else
		// ƒ¡‘ÿ ÀœÕ¡Œƒ’ RT_CLIP
		adel(::TracePoints,n)
		asize(::TracePoints,len(::TracePoints)-1)
		sss:="DELETE "
	endif
	if !empty(sss)
	::command:put(sss+[trace point "]+vstr+'"';
			 +', ('+alltrim(str(n))+'/'+alltrim(str(len(::tracePoints)))+')')
	endif
return .t.

************************************************
static function statusLine(str)
	local oldwin:=wselect(),ret
	static old_st:=""
	ret:=old_st
	old_st:=str
	wselect(::winNo)
	@ ::maxrow,0 say padr(str,::maxcol) color set("debug_colors_menu")
	wselect(oldwin)
return ret
************************************************
static function command_run(str,add_flag)
	local mcomm,com,ret:=.t.
	local script_name:="", n:=0, hfile:=-1, fstr
	local ncom, mcom, a,b,c

	if empty(str)
		return .f.
	endif
	::command:sayprompt(str)
	mcomm:=split(alltrim(str),"[ &\t]")
	//mcomm:=split(str," ")
	if len(mcomm)<1
		::command:put([error:unknown command:]+mcomm[1]+":"+len(mcomm))
		return .f.
	endif
	if substr(mcomm[1],1,1)== "#"
		return .f.
	endif
	com=upper(alltrim(mcomm[1]))
	for ncom=1 to len(com_names)
	    if ascan(com_names[ncom],{|xcom|,xcom==com})!=0
		exit
	    endif
	next
	do case
		case ncom==1    // comment
			return .f.
		case ncom==2    // "INPUT"
		     if len(mcomm)<2
			::command:put([error:usage "INPUT <filename>"])
		     else
			script_name:=mcomm[2]
		     endif
		     if empty(script_name)
			 ::command:put('error: unknown filename:'+script_name)
			 return .f.
		     else
			script_name:=mcomm[2]
		     endif
		     n=at(".",script_name)
		     if n==0
			script_name+=".cld"
		     endif
		     ferror(0)
		     hfile:=fopen(script_name)
		     if hfile<0
			::command:put([error:]+ferrorstr())
		     endif
		     while !fileeof(hfile)
			fstr:=filegetstr(hfile)
			::run(fstr,.f.)
		     enddo
		     fclose(hfile)
		     ::command:put("")
		     ::command:sayprompt()
		case ncom==3  // "MONITOR"
		     ::monitor()
		     /*
		     fstr:=""
		     if len(mcomm)<2
			::command:put([help:usage "MONITOR <public>|<private>|...."])
		     else
			fstr:=upper(mcomm[2])
			for mcom=1 to len(mon_names)
				if ascan(mon_names[mcom],{|xcom|xcom==fstr})!=0
					exit
				endif
			next
			do case
				case mcom==1  // "PUBLIC"
					::public:=!::public
				case mcom==2  // "PRIVATE"
					::private:=!::private
				case mcom==3  // "STATIC"
					::private:=!::private
				case mcom==4  // "LOCAL"
					::local:=!::local
				case mcom==5  // "FIELD"
					::field:=!::field
				otherwise
					::command:put([error:unknown variable type"]+fstr+'"')
			endcase
			fstr:=[monitor status: ]
			fstr+="public:"+iif(::public,"ON","OFF")+", "
			fstr+="private:"+iif(::private,"ON","OFF")+", "
			fstr+="static:"+iif(::static,"ON","OFF")+", "
			fstr+="local:"+iif(::local,"ON","OFF")+", "
			fstr+="field:"+iif(::field,"ON","OFF")
			::command:put(fstr)
		     endif
		     */
		case ncom==4   //"?"
		     fstr:=""
		     if len(mcomm)<2
			::command:put([error:usage "? <clipper macro construction>"])
			return .f.
		     else
			fstr:=mcomm[2]
		     endif
		     ::macro(fstr)
		case ncom==5  // "ANIMATE"
		     ::animation := ! ::animation
		case ncom==6  // "BREAKPOINT"
		     if len(mcomm)<2
			::command:put([error:usage "BREAKPOINT <line> <filename>"])
			return .f.
		     endif
		     a:=b:=fstr:=""
		     if len(mcomm)>1
			a=alltrim(mcomm[2])
		     endif
		     if len(mcomm)>2
			b=alltrim(mcomm[3])
		     endif
		     if isdigit(a)
			hfile:=val(a)
			fstr:=alltrim(b)
		     endif
		     if isdigit(b)
			hfile:=val(b)
			fstr:=alltrim(a)
		     endif
		     ::addBP(hfile,fstr)
		case ncom==7  // "CALLSTACK"
		     ::viewStack()
		case ncom==8  // "DELETE"
		     if len(mcomm)<3
			::command:put([error:usage "DELETE all BP|TP|WP" or "DELETE BP|TP|WP <number>"])
			return .f.
		     endif
		     fstr=alltrim(upper(mcomm[2]))
		     a=.f. ; b=0
		     if fstr=="ALL"
			a=.t.
			fstr=alltrim(upper(mcomm[3]))
		     else
			b=val(mcomm[3])
		     endif
		     if !a .and. b==0
			     ::command:put('Error: invalid parameter <number>')
			     return .f.
		     endif
		     for mcom=1 to len(point_names)
			  if ascan(point_names[mcom],{|xcom|xcom==fstr})!=0
			     exit
			  endif
		     next
		     c:=NIL
		     do case
			case mcom==1
				c:=::breakPoints
			case mcom==2
				c:=::tracePoints
			case mcom==3
				c:=::values:points
			otherwise
			     ::command:put([Error: unknown point type "]+fstr+'"')
			     return .f.
		     endcase
		     if !a .and. (b<1 .or. b>len(c))   // delete point with bad number
			::command:put('Error: invalid parameter <number>')
			return .f.
		     endif
		     if !a    // delete one point
			do case
				case mcom==1
					::addBP(::breakPoints[b][1],::breakPoints[b][2])
				case mcom==2
					::addTP(::tracePoints[b])
				case mcom==3
					::values:delete(b)
			endcase
		     else    // delete all points
			do case
				case mcom==1
					while len(::breakPoints)>0
						::addBP(::breakPoints[1][1],::breakPoints[1][2])
					enddo
				case mcom==2
					while len(::tracePoints)>0
						::addTP(::tracePoints[i])
					enddo
				case mcom==3
					::values:deleteAll()
			endcase
		     endif
		case ncom==9  // "DOS"
		     fstr:=OS_SHELL
		     if len(mcomm)>1
			fstr:=alltrim(mcomm[2])
		     endif
		     run fstr
		case ncom==10  // "RUN"
		     if len(mcomm)<2
			::command:put([error: usage "RUN <system_comand>"])
			return .f.
		     endif
		     fstr=alltrim(mcomm[2])
		     a:=space(0); b:=space(0)
		     syscmd(fstr,"",@a,@b)
		     if !empty(a)
			::command:put(a)
		     endif
		     if !empty(b)
			::command:put(b)
		     endif
		case ncom==11  // "FIND"
		     if len(mcomm)<2
			::find(,0)
		     else
			::find(mcomm[2],0)
		     endif
		case ncom==12  // "GO"
		     ::until()
		case ncom==13  // "GOTO number"
		     fstr:=0
		     if len(mcomm)>1
			fstr:=val(mcomm[2])
		     endif
		     ::gotoLine(fstr)
		case ncom==14  // "HELP"
		     fstr:=""
		     if len(mcomm)>1
			fstr=alltrim(mcomm[2])
		     endif
		     ::help(fstr)
		case ncom==15  // "LIST"
		     if len(mcomm)<2
			::command:put([error: usage "LIST BP|TP|WP"])
			return .f.
		     endif
		     fstr:=alltrim(upper(mcomm[2]))
		     for mcom=1 to len(point_names)
			  if ascan(point_names[mcom],{|xcom|xcom==fstr})!=0
			     exit
			  endif
		     next
		     do case
			case mcom==1
				::listBP()
			case mcom==2
				::listTP()
			case mcom==3
				::listVP()
			otherwise
			     ::command:put([Error: unknown point type "]+fstr+'"')
			     return .f.
		     endcase
		case ncom==16  // "NEXT"
		     ::find(,1)
		case ncom==17  // "NUM"
		     if len(mcomm)>1
			fstr=upper(alltrim(mcomm[2]))
			if fstr=="ON" .or. fstr=="˜ÎÏ"
				::menu:numeration(.t.)
			else
				::menu:numeration(.f.)
			endif
		     else
			::menu:numeration( !::menu:numeration() )
		     endif
		     ::command:put([NUMERATION lines status:]+iif(::menu:numeration(),"ON","OFF"))
		case ncom==18  // "OUTPUT"
		     ::viewScreen()
		case ncom==19  // "PREV"
		     ::find(,-1)
		case ncom==20  // "QUIT"
		     return HASH_Exit
		case ncom==21  // "RESTART"
		     ::restart()
		case ncom==22  // "RESTART"
		     // i don~t known
		case ncom==23  // "SPEED"
		     if len(mcomm)<2
			::command:put([error: usage "SPEED <timeout>", timeout in thenth of second])
			return .f.
		     endif
		     ::aniSpeed:=val(mcomm[2])
		     ::command:put([Current animation speed: ]+alltrim(str(::aniSpeed))+[/10 second])
		case ncom==24  // "STEP"
		     ::step()
		case ncom==25  // "TRACEPOINT"
		     if len(mcomm)<2
			::command:put([error:usage "TRACEPOINT <expr>"])
			return .f.
		     endif
		     ::addTP(mcomm[2])
		case ncom==26  // "VIEW"
		     if len(mcomm)<2
			::viewFile()
		     else
			::viewFile(mcomm[2])
		     endif
		case ncom==27  // "VIEWPOINT"
		     if len(mcomm)<2
			::values:add()
		     else
			::values:add(mcomm[2])
		     endif
		case ncom==28  // "CONNECT"
		     if len(mcomm)<2
			::connect()
		     else
			::connect(mcomm[2])
		     endif
		case ncom==29   //"!"
		     fstr:=""
		     if len(mcomm)<2
			::command:put([error:usage "! <variable name>"])
			return .f.
		     else
			fstr:=mcomm[2]
		     endif
		     ::macro(fstr,.t.)
		case ncom==30   //"Tabsize"
		     if len(mcomm)<2
			::command:put([error:usage "tabsize <num>"])
			return .f.
		     else
			::tabSize(val(mcomm[2]))
		     endif
		     ::command:put([New tabulation size:]+alltrim(str(::_tabSize)))
		case ncom==31   //"source path"
		     if len(mcomm)<2
			::command:put([error:usage "path <directory>"])
			return .f.
		     else
			::srcPath(mcomm[2])
		     endif
		     ::command:put([New source path:]+::_path)
		case ncom==32  // "CBTRACE"
		     if len(mcomm)>1
			fstr=upper(alltrim(mcomm[2]))
			if fstr=="ON" .or. fstr=="˜ÎÏ"
				::menu:cbTraceStyle(.t.)
			else
				::menu:cbTraceStyle(.f.)
			endif
		     else
			::menu:cbTraceStyle( !::menu:cbTraceStyle() )
		     endif
		     ::command:put([Code block trace status:]+iif(::menu:cbTraceStyle(),"ON","OFF"))
		case ncom==33  // "PPVIEW"
		     if len(mcomm)>1
			fstr=upper(alltrim(mcomm[2]))
			if fstr=="ON" .or. fstr=="˜ÎÏ"
				::menu:preprocStyle(.t.)
			else
				::menu:preprocStyle(.f.)
			endif
		     else
			::menu:preprocStyle( !::menu:preprocStyle() )
		     endif
		     ::command:put([Preprocessor source view status:]+iif(::menu:preprocStyle(),"ON","OFF"))
		case ncom==34  // "SAVE"
		     ::saveOptions()
		case ncom==35  // "VIEWALIASES"
		     ::viewWorkSel()
		otherwise
		     ::command:put([error:unknown command])
	endcase
return ret
*********************************************
static function HandleKey(nkey)
       local i,ret:=1,hkey:=0,x,y,m,scr,curWIn:=wselect(),st
       local nwindow:=0,mh
       if nkey $ ::mapKeys
		hkey=::mapKeys[nkey]
		nkey=0
       endif
       if hkey!=0
		hkey:=::menu:handleKey(hkey)
       endif
       if hkey==HASH_OpenFile
		::viewFile()
		hkey:=nkey:=0
       endif
       if hkey==HASH_Reload
		for x=1 to len(::windows)
		      ::windows[x]:reload()
		next
		hkey:=nkey:=0
       endif
       if hkey==HASH_CloseWindow
		if ::windows[::curWin]:close()
			adel(::windows,::curwin)
			asize(::windows,len(::windows)-1)
			for x=1 to len(::windows)
				::windows[x]:headWin:=x
				::windows[x]:redraw()
			next
		endif
		hkey:=HASH_NextWindow
		nkey:=0
       endif
       if hkey==HASH_NextWindow .or. hkey==HASH_PrevWindow
		x:=::curWin
		::curWin:=iif(hkey==HASH_NextWindow,::curWin++,::curWin--)
		if ::curWin > len(::windows)
			::curWin:=1
		endif
		if ::curWin<1
			::curWin:=len(::windows)
		endif
		if x>0 .and. x<=len(::windows)
			::windows[x]:killFocus()
		endif
		::windows[::curWin]:setFocus()
		if ::windows[::curWin]:classname=="DBG_SOURCE"
			::curSrcWin=::curWin
		endif
		nkey:=hkey:=0
       endif
       if hkey!=0
		do case
			case hkey==HASH_Help
				::help()
				hkey:=nkey:=0
			case hkey==HASH_ListWindow
				::listWin()
				hkey:=nkey:=0
			case hkey==HASH_ViewScreen
				::viewScreen()
				hkey:=nkey:=0
			case hkey==HASH_Values
				::values:add()
				hkey:=nkey:=0
			case hkey==HASH_MatchForward .or. hkey==HASH_MatchBackWard
				if ::curSrcWin!=0
					::windows[::curSrcWin]:Identity(hkey==HASH_MatchForward)
				endif
				hkey:=nkey:=0
			case hkey==HASH_FindStr
				::find(,0)
				hkey:=nkey:=0
			case hkey==HASH_FindNext
				::find(,1)
				hkey:=nkey:=0
			case hkey==HASH_FindPrev
				::find(,-1)
				hkey:=nkey:=0
			case hkey==HASH_GotoLine
				::gotoLine()
				hkey:=nkey:=0
			case hkey==HASH_TabSize
				::tabSize()
				hkey:=nkey:=0
			case hkey==HASH_Reload
				::tabSize(::_tabSize)
				hkey:=nkey:=0
			case hkey==HASH_SourcePath
				::srcPath()
				hkey:=nkey:=0
			case hkey==HASH_ViewStack
				::viewStack()
				hkey:=nkey:=0
			case hkey== HASH_ViewBreak
				::viewBp()
				hkey:=nkey:=0
			case hKey==HASH_ConnectProcess
				::connect()
				hkey:=0
			case hKey==HASH_Trace
				::trace()
				hkey:=0
			case hKey==HASH_Step
				::step()
				hkey:=0
			case hKey==HASH_GoCursor
				::until()
				hkey:=0
			case hKey==HASH_Animation
				::animation := ! ::animation
				hkey:=0
			case hKey==HASH_Break
				if ::curSrcWin!=0
					::addBp(::windows[::curSrcWin]:edit:line,::windows[::curSrcWin]:edit:fileName)
				endif
				hkey:=0
			case hKey==HASH_Continue
				::continue()
				hkey:=0
			case hkey==HASH_ViewSet
				::viewSetValues(1,0,::maxrow-1,::maxcol,len(::windows)+1)
				nkey:=hkey:=0
			case hkey==HASH_Monitor
				::monitor()
				nkey:=hkey:=0
			case hkey==HASH_ViewAliases
				//::viewWorkSel(1,0,::maxrow-1,::maxcol,len(::windows)+1)
				::viewWorkSel()
				nkey:=hkey:=0
			case hkey==HASH_SaveOptions
				::saveOptions()
				nkey:=hkey:=0
			case hkey==HASH_LoadOptions
				::loadOptions()
				nkey:=hkey:=0
		endcase
	endif
       ***********
	if hkey!=0
		nwindow:=0
		mh:={	HASH_Window1,HASH_Window2,HASH_Window3,HASH_Window4,;
			HASH_Window5,HASH_Window6,HASH_Window7,HASH_Window8,;
			HASH_Window9}
		nwindow:=ascan(mh,{|x|x==hkey})
		if nwindow!=0
			x:=0
			for i=1 to len(::windows)
				if ::windows[i]:headWin==nwindow
					x:=i
					exit
				endif
			next
			if x>0 .and. x<=len(::windows)
				::windows[::curWin]:killFocus()
				::curWin:=x
			endif
			if ::windows[::curWin]:classname=="DBG_SOURCE"
				::curSrcWin=::curWin
			endif
			::windows[::curWin]:setFocus()
			nkey:=hkey:=0
		endif
	endif
	***************
	/*
	if hkey!=0
		nwindow:=0
		mh:={	HASH_Monitor1,HASH_Monitor2,HASH_Monitor3,;
			HASH_Monitor4,HASH_Monitor5,HASH_Monitor6}
		nwindow:=ascan(mh,{|x|x==hkey})
		if nwindow!=0
			::monitor(nwindow)
			hkey:=nkey:=0
		endif
	endif
	*/
       ***************
       if nKey==K_ENTER
		while dispcount()>0
			dispend()
		enddo
		if ::windows[::curWin]:classname=="DBG_VALUES"
			hkey:=::values:handlekey(hkey)
		else
			hkey=::run(::command:command)
			if valtype(hkey)!="N"
				hkey=0
			endif
			dispbegin()
			::command:add()
			::command:command:=""
			::command:put("")
			::command:sayprompt()
			dispend()
			ret:=nkey
			nkey:=0
		endif
       endif
       if hKey==HASH_Exit
		if ::quit()
			for x=1 to len(::windows)
				y=::windows[x]:close(.t.)
			next
			wselect(::winNo)
			wclose()
			wselect(0)
			ret:=0
		endif
		nkey:=hkey:=0
       endif
       dispbegin()
       if hkey==HASH_ZoomWindow
		hkey:=::windows[::curWin]:handleKey(hkey)
		for x=1 to len(::windows)
			::windows[x]:redraw()
		next
       endif
       if hkey!=0
		hkey:=::windows[::curWin]:handleKey(hkey)
       endif
       if nkey!=0
		nkey:=::windows[::curWin]:handleKey(nkey)
       endif
       if hKey!=0
		hkey:=::command:handleKey(hkey)
       endif
       if nkey!=0
		nkey:=::command:handleKey(nkey)
       endif
       ************
       dispbegin()
       for i=1 to len(::windows)
	       wselect(::windows[i]:winNo)
       next
       wselect(::windows[::curWin]:winNo)
       while dispcount()>0
	   dispend()
       enddo
       /*
       if ::curWin!=1
	  ::windows[::curwin]:reDraw()
       endif
       */
       if nkey==0 .and. hkey==0  // animate
		while ::animation .and. nextkey()==0
		     ::command:put("Animate step:"+str(seconds()) )
		     ::dbg_command("s")
		     sleep(::aniSpeed/10)
		     ::frame()
		enddo
       endif
return ret

************************************************
static function dbg_command(p1,p2,p3,p4)
	local scr,ret:="",s,oldcol:=setcolor("W+/R"), col:=col(), row:=row()
	local olderror
	if ::dbgconnect==NIL
		::command:put([No connection !])
	else
		scr:=savescreen()
		s:=[Waiting signal from process.....]
		@ 0,0,2,len(s)+1 box B_DOUBLE
		@ 1,1 say s
		olderror=ERRORBLOCK({|x| break(x) })
		Begin Sequence
			outlog(__FILE__,__LINE__,"dbg_ call","!"+p1+"!")
			sleep(0.1)
			ret:=dbgcommand(p1)
			outlog(__FILE__,__LINE__,"dbg_ ret ","!"+ret+"!")
		recover using _error
			::command:put([Error sending signal to process])
			outlog(__FILE__,__LINE__,"dbg_ err ",ret)
		End Sequence
		ERRORBLOCK(olderror)
		restore screen from scr
		devpos(row,col)
	endif
	setcolor(oldcol)
return ret
