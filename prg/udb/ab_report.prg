/*
    Copyright (C) 2002-2005  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "box.ch"
****************************************
function ab_run_report(oRep,oBox,oIdList)
	local ret,block,oWin
	do case
		case oRep:type == "C"
			block := ab_loadPlugIns("reports"+PATH_DELIM+orep:filename)
			if valtype(block) == "C"
				alert(block)
				return
			endif
			oWin := ab_reportWin(oBox,oRep)
			ret := eval(block,oWin,oIdList)
			if ret != NIL
				oWin:top()
				return oWin
			else
				oWin:close()
				return
			endif
		case oRep:type == "P"
		case oRep:type == "L"

	endcase
return ret
****************************************
function ab_reportWin(oBox,oRep)
	local obj := map(),s,x

	obj:classname	:= "AB_REPORT_WINDOW"
	obj:handleKey	:= @_rwin_handleKey()
	obj:close	:= @_rwin_close()
	obj:put		:= @_rwin_put()
	obj:top		:= @_rwin_top()
	obj:newLine	:= @_rwin_newLine()
	obj:oBox	:= oBox
	obj:scr		:= savescreen(oBox:nTop, oBox:nLeft, oBox:nBottom, oBox:nRight)

	@ oBox:nTop,oBox:nLeft,oBox:nBottom,oBox:nRight box B_DOUBLE+" " color set("ab_colors_browse")

	s:=alltrim([Report:]+oRep:name)
	x:=(oBox:nRight-oBox:nLeft-2-len(s))/2
	@ oBox:nTop, oBox:nLeft+x say s

	obj:tedit	:= textEditNew(oBox:nTop+1, oBox:nLeft+1, oBox:nBottom-1, oBox:nRight-1, set("ab_colors_browse"))
return obj

****************************************
static function _rwin_close(self)
	local oBox := self:oBox
	restscreen(oBox:nTop, oBox:nLeft, oBox:nBottom, oBox:nRight,self:scr)
return

****************************************
static function _rwin_newLine(self)
	self:tedit:insertLine()
return
****************************************
static function _rwin_put(self,str)
	self:tedit:insert(str)
	self:tedit:end()
return
****************************************
static function _rwin_top(self)
	self:tedit:top()
return
****************************************
static function _rwin_handleKey(self, hKey)
	local ret:=hkey
	if self:tedit:handleKey(hKey)
		ret:=0
	endif
return	ret
