/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "dbedit.ch"
#include "box.ch"

/* mode`s for tbrowse objects */
#define AB_BROWSE_MODE_CARD 	1
#define AB_BROWSE_MODE_TABLE 	2
#define AB_BROWSE_WIDTH 	21

************************************************************
function ab_make_meta_browse(oDict,metaName)
	local tmp:=map(), oIdList:=NIL
	oIdList := oDict:idList(metaName,,,,,.t.)
	if oIdList != NIL .and. empty(oDict:error)
		return meta_browse(oIdList)
	endif
	tmp:error:=oDict:error
	tmp:close:=@empty_method()
return tmp
************************************************************
* browse object for list attributes/extents/classes/.....
************************************************************
static function meta_browse(oIdList,ntop,nleft,nbottom,nright,color)
	local n,ver,oldcol,scr,tmp:=map(),pi,bp,oBrowse,oBox:=map(),oControl:=map()

	pi := ab_loadPlugIns("plugins"+PATH_DELIM+lower(oIdList:metaName))
	if valtype(pi) == "C"
		tmp:error := pi
		tmp:close := @empty_method()
		return tmp
	endif
	bp := eval(pi,"VIEW_CARD")
	if valtype(bp) == "C"
		tmp:error := bp
		tmp:close := @empty_method()
		return tmp
	endif
	oControl:view_card := bp
	bp := eval(pi,"EDIT_CARD")
	if valtype(bp) == "C"
		bp := {|| [Edit card not found !] }
	endif
	oControl:edit_Card := bp

	nTop   :=iif(nTop   ==NIL, 1,          nTop)
	nLeft  :=iif(nLeft  ==NIL, 0,          nLeft)
	nBottom:=iif(nBottom==NIL, maxrow()-2, nBottom)
	nRight :=iif(nRight ==NIL, maxcol(),   nRight)
	color  :=iif(color  ==NIL, set("ab_colors_browse"),   color)

	oBox:nTop    := nTop
	oBox:nLeft   := nLeft + 23
	oBox:nBottom := nBottom
	oBox:nRight  := nRight
	*
	oldcol:=setcolor(color)
	scr:=savescreen(nTop,nLeft,nBottom,nRight)
	@ nTop,nLeft,nBottom,nRight box B_DOUBLE+" "
	@ nTop,nLeft+23,nBottom,nRight box B_DOUBLE+" "
	@ ntop,nLeft+2 say oIdList:metaname
	oBrowse			:= TBrowseNew(nTop+1,nLeft+1,nBottom-1,nLeft+AB_BROWSE_WIDTH)
	oBrowse:nRight_saved	:= oBrowse:nRight

	oBrowse:oIdList		:= oIdList
	oBrowse:metaName	:= @ oIdList:metaName
	oBrowse:oInfoBox	:= oBox
	oBrowse:oControl	:= oControl

	oBrowse:screen		:= scr
	oBrowse:error		:= ""
	oBrowse:screenSize	:= {ntop,nLeft,nBottom,nRight}
	oBrowse:skipBlock 	:= { |x| Skipper(oBrowse:oIdList, x) }
	oBrowse:goBottomBlock	:= {||oIdList:gobottom() }
	oBrowse:goTopBlock	:= {||oIdList:goTop() }
	oBrowse:bofBlock	:= {||oIdList:bof() }
	oBrowse:eofBlock	:= {||oIdList:eof() }
	oBrowse:headSep 	:= DE_HEADSEP
	oBrowse:colSep 		:= DE_COLSEP
	oBrowse:freeze		:= 1
	oBrowse:colorSpec	:= color
	oBrowse:close		:= @browse_close()
	oBrowse:HandleKey	:= @browse_handleKey()
	oBrowse:mode		:= AB_BROWSE_MODE_CARD
	oBrowse:reportWin	:= NIL
	*
	n:=TBColumnNew([MetaData name], {|fName|oBrowse:oIdList:getValue(fName)},"NAME")
	n:width:=20
	n:colorBlock:={||ver:=oBrowse:oIdList:getValue("__VERSION"),iif(ver!=NIL .and. ver<0,{3,4},{1,2}) }
	oBrowse:addcolumn(n)
	oBrowse:configure()
	oBrowse:invalidate()
	oBrowse:handleKey(0)
	setcolor(oldcol)
return oBrowse
************************************************************
static function browse_handleKey(self,hkey)
	local ret:=hkey,expr,obj
	local ret1,tmp,i,data,Odict,oDep
	local n,col, oBox
	local nRow,nCol
	if self:reportWin != NIL
		ret := self:reportWin:handlekey(hKey)
		do case
			case hkey==HASH_CloseWin
				self:reportWin:close()
				self:reportWin := NIL
				ret := 0
		endcase
		return ret
	endif
	do case
		case hkey==HASH_CloseWin
			self:close()
			self := NIL
			return NIL
		case hkey==HASH_ChoiceOrder
			oDict := self:oIdList:dictionary()
			data := oDict:select("INDEX")
			ret1 := ab_choice_index(oDict,data)
			if !empty(ret1)
				if !self:oIdList:setIndex(ret1)
					if !empty(self:oIdList:error)
						alert(self:oIdList:error)
					endif
				endif
				self:refreshAll()
			endif
			ret:=0
		case hkey==HASH_ChoiceTview
			oDict := self:oIdList:dictionary()
			data := oDict:select("TVIEW")
			ret1 := ab_choice_tview(oDict,data)
			if !empty(ret1)
				data := oDict:getValue(ret1)
				if !empty(data:col_list)
					self:__delAllColumns()
					for i=1 to len(data:col_list)
						col:=oDict:getValue(data:col_list[i])
						expr:=alltrim(col:expr)
						begin sequence
							if isWord(expr)
								n:=TBColumnNew(col:header, {|fName|self:oIdList:getValue(fName)},expr)
							else
								if left(expr,2)=="{|"
								else
									expr:="{||"+expr+"}"
								endif
								col:expr_block := &(expr)
								n:=TBColumnNew(col:header, {|fName|self:oIdList:getExpr(fName)},col:expr_block)
							endif
							n:width := col:width
							n:footing := col:footer
							self:addColumn(n)
						end sequence

					next
					self:configure()
					self:invalidate()
				endif
			endif
			ret:=0
		case hkey==HASH_ChoiceReport
			oDict := self:oIdList:dictionary()
			data := oDict:select("REPORT")
			ret1 := ab_choice_report(oDict,data)
			ret1 := oDict:getValue(ret1)
			obox := map()
			oBox :nTop    := self:nTop
			oBox :nLeft   := self:nLeft
			oBox :nBottom := self:nBottom
			oBox :nRight  := self:nRight
			obox := ab_run_report(ret1,oBox,self:oIdList)
			if valtype(oBox) == "O"
				self:reportWin := oBox
			endif
			ret:=0
		case hkey==HASH_DeleteAll .or. hkey==HASH_EraseAll
			if alert([Delete all objects, are you sure ?]) == 1
				oDep := self:oIdList:depository()
				tmp := self:oIdList:aID
				for i=1 to len(tmp)
					oDep:delete(tmp[i],hkey==HASH_EraseAll)
				next
				self:oIdList:refresh()
				self:refreshAll()
			endif
			self:forceStable()

		case hkey==HASH_Delete .or. hkey==HASH_Erase
			oDep := self:oIdList:depository()
			obj:=self:oIdList:getValue()
			tmp:=""
			if "NAME" $ obj
				tmp := obj:name
			elseif "SMALLNAME" $ obj
				tmp := obj:smallname
			elseif "FULLNAME" $ obj
				tmp:=obj:fullname
			endif

			if alert([Delete, are you sure ?]+";("+tmp+")") == 1
				if ! oDep:delete(obj:id,hkey==HASH_Erase)
					alert(oDep:error)
				endif
				self:refreshAll()
			endif
			ret:=0
		case hkey==HASH_UnDelete
			if ! self:oIdList:undelete()
				alert(self:oIdList:error)
			endif
			self:refreshAll()
			ret:=0
		case hkey==HASH_Append
			data:=self:oIdList:getInfo(.t.)
			if self:mode != AB_BROWSE_MODE_CARD
				self:mode := AB_BROWSE_MODE_CARD
				self:nRight := self:nLeft + AB_BROWSE_WIDTH
				self:configure()
				self:invalidate()
			endif
			begin sequence
				if eval(self:oControl:edit_card,self:oIdList:depository(),@data,self:oInfoBox,self:colorSpec)
					self:oIdList:add(data)
					if !empty(self:oIdList:error)
						message(self:oIdList:error)
					endif
				endif
			end sequence
			self:refreshAll()
			ret:=0
		case hkey==HASH_Edit
			data:=self:oIdList:getInfo()
			if self:mode != AB_BROWSE_MODE_CARD
				self:mode := AB_BROWSE_MODE_CARD
				self:nRight := self:nLeft + AB_BROWSE_WIDTH
				self:configure()
				self:invalidate()
			endif
			begin sequence
				if eval(self:oControl:edit_card,self:oIdList:depository(),@data,self:oInfoBox,self:colorSpec)
					if !self:oIdList:update(data)
						message(self:oIdList:error)
					endif
				endif
			end sequence
			self:refreshAll()
			ret:=0
		case hkey==HASH_ViewCard
			do case
				case self:mode == AB_BROWSE_MODE_TABLE
					self:mode := AB_BROWSE_MODE_CARD
					self:nRight := self:nLeft + AB_BROWSE_WIDTH
				case self:mode == AB_BROWSE_MODE_CARD
					self:mode := AB_BROWSE_MODE_TABLE
					self:nRight := self:nRight_saved
			endcase
			self:configure()
			self:invalidate()
			ret := 0
		case hkey == 32 // space pressed
			self:oIdList:setWhere()
			self:refreshAll()
		case hkey > 32 .and. hkey<255
			i := self:getColumn(self:colpos)
			if !empty(i:fieldName)
				tmp := i:fieldName+'="'+chr(hKey)+'"'
				self:oIdList:setWhere(tmp)
				self:refreshAll()
			endif
			ret := 0
		otherwise
			ret1=self:applykey(hkey)
			if ret1==0
				ret:=0
			endif
	endcase

	dispbegin()
	do while !self:stabilize()
	enddo
	while dispcount()>0
	   dispend()
	enddo

	nRow := row(); nCol := col()
	if self:mode == AB_BROWSE_MODE_CARD
		data:=self:oIdList:getInfo()
		begin sequence
			eval(self:oControl:view_card,self:oIdList:depository(),data,self:oInfoBox,self:colorSpec)
		end sequence
	endif
	setpos(nRow,nCol)
return  ret
************************************************************
static function empty_method()
return
************************************************************
static function browse_close(self)
	if self!=NIL
		restScreen(self:screenSize[1],self:screenSize[2],self:screenSize[3],self:screenSize[4],self:screen)
	endif
	self:oIdList:close()
	self:=NIL
return
************************************************************
STATIC FUNCTION Skipper(obj, n)
    LOCAL i
    i := 0
    IF n == 0
	obj:skip(0)
    ELSEIF n > 0
	DO WHILE i < n
	    obj:skip(1)
	    if obj:Eof()
		obj:Skip(-1)
		exit
	    endif
	    i++
	ENDDO
    ELSEIF n < 0
	DO WHILE i > n
	    obj:skip(-1)
	    IF  obj:bof()
		exit
	    ENDIF
	    i--
	ENDDO
    ENDIF
RETURN i

************************************************************
function ab_make_data_browse(oDeposit,objId,idList)
	local tmp:=map(), oIdList:=NIL
	if valtype(idList)=="O"
		oIdList:=idList
	else
		oIdList := oDeposit:idList(objId,,,,,.t.)
	endif
	//if oIdList != NIL .and. empty(oDeposit:error)
	if oIdList != NIL .and. empty(oIdList:error)
		return data_browse(oIdList)
	endif
	tmp:error:=oDeposit:error
	tmp:close:=@empty_method()
return tmp
************************************************************
* browse object for list DATA objects
************************************************************
static function data_browse(oIdList,ntop,nleft,nbottom,nright,color)
	local n,oldcol,scr,tmp:=map(),pi,bp,oBrowse,oBox:=map()
	local i,ver,oControl:=map(), oDict, class_desc, attr_desc

	oDict:=oIdList:dictionary()
	class_desc := oDict:getValue(oIdList:metaName)
	pi := ab_loadPlugIns("plugins"+PATH_DELIM+lower(oIdList:metaName))
	if valtype(pi) == "C" // error loading plugins
		if "NAME" $ class_desc
			pi := ab_loadPlugIns("plugins"+PATH_DELIM+lower(class_desc:name))
		endif
		if valtype(pi) == "C" // error loading plugins
			pi := ab_loadPlugIns("plugins"+PATH_DELIM+"default")
			if valtype(pi) == "C" // error loading default plugins
				tmp:error := [Can`t load default plugins or plugins for subject:]+oIdList:metaName
				tmp:close := @empty_method()
				return tmp
			endif
		endif
	endif
	bp := eval(pi,"VIEW_CARD")
	if valtype(pi) == "C"
		tmp:error := pi
		tmp:close := @empty_method()
		return tmp
	endif
	oControl:view_card := bp
	bp := eval(pi,"EDIT_CARD")
	if valtype(pi) == "C"
		pi := {|| [Edit card not found !] }
	endif
	oControl:edit_Card := bp

	nTop   :=iif(nTop   ==NIL, 1,          nTop)
	nLeft  :=iif(nLeft  ==NIL, 0,          nLeft)
	nBottom:=iif(nBottom==NIL, maxrow()-2, nBottom)
	nRight :=iif(nRight ==NIL, maxcol(),   nRight)
	color  :=iif(color  ==NIL, set("ab_colors_browse"),   color)

	oBox:nTop    := nTop
	oBox:nLeft   := nLeft + 23
	oBox:nBottom := nBottom
	oBox:nRight  := nRight
	*
	oldcol:=setcolor(color)
	scr:=savescreen(nTop,nLeft,nBottom,nRight)
	@ nTop,nLeft,nBottom,nRight box B_DOUBLE+" "
	@ nTop,nLeft+2 say oDict:getValue(oIdList:metaname):name
	oBrowse			:= TBrowseNew(nTop+1,nLeft+1,nBottom-1,nRight-1)
	oBrowse:nRight_saved	:= oBrowse:nRight
	oBrowse:chop 		:= .t.

	oBrowse:oIdList		:= oIdList
	oBrowse:oInfoBox	:= oBox
	oBrowse:oControl	:= oControl
	oBrowse:metaName	:= @ oIdList:metaName

	oBrowse:screen		:= scr
	oBrowse:error		:= ""
	oBrowse:screenSize	:= {ntop,nLeft,nBottom,nRight}
	oBrowse:skipBlock 	:= { |x| Skipper(oBrowse:oIdList, x) }
	oBrowse:goBottomBlock	:= {||oIdList:gobottom() }
	oBrowse:goTopBlock	:= {||oIdList:goTop() }
	oBrowse:bofBlock	:= {||oIdList:bof() }
	oBrowse:eofBlock	:= {||oIdList:eof() }
	oBrowse:headSep 	:= DE_HEADSEP
	oBrowse:colSep 		:= DE_COLSEP
	oBrowse:freeze		:= 1
	oBrowse:colorSpec	:= color
	oBrowse:close		:= @browse_close()
	oBrowse:HandleKey	:= @browse_handleKey()
	oBrowse:mode		:= AB_BROWSE_MODE_TABLE
	oBrowse:reportWin	:= NIL
	*
	for i=1 to len(class_desc:attr_list)
		attr_desc:=oDict:getValue(class_desc:attr_list[i])
		if empty(attr_desc)
			outlog("Error load object:",class_desc:attr_list[i])
			loop
		endif
		n:=TBColumnNew(alltrim(attr_desc:name), {|fName|oBrowse:oIdList:getValue(fName)},alltrim(upper(attr_desc:name)))
		n:width := max(attr_desc:len,len(alltrim((attr_desc:name))))
		n:colorBlock:={||ver:=oBrowse:oIdList:getValue("__VERSION"),iif(ver!=NIL .and. ver<0,{3,4},{1,2}) }
		oBrowse:addcolumn(n)
	next
	n:=TBColumnNew("id", {|fName|oBrowse:oIdList:getValue(fName)},"ID")
	n:width:=codb_info("CODB_ID_LEN")
	oBrowse:addcolumn(n)
	n:=TBColumnNew("class_id", {|fName|oBrowse:oIdList:getValue(fName)},"CLASS_ID")
	n:width:=codb_info("CODB_ID_LEN")
	oBrowse:addcolumn(n)
	oBrowse:configure()
	oBrowse:invalidate()
	oBrowse:handleKey(0)
	setcolor(oldcol)
return oBrowse



