/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/* metaData "select" ( ID list) manager */

#include "codbcfg.ch"
#include "codb_dbf.ch"

************************************************************
function codb_IdList(oDbm,metaName,nIndex,sName,whereExpr,nCount,deleted)
	local obj:=map()

	obj:classname	:= "CODBIDLIST"
	obj:oDbm	:= oDbm
	obj:metaName	:= alltrim(upper(metaName))
	obj:sName	:= sName
	obj:nCount	:= nCount
	obj:deleted	:= deleted
	obj:bof		:= .f.
	obj:eof		:= .f.
	obj:error	:= ""
	obj:currPos	:= 0
	obj:currId	:= ""
	obj:nIndex	:= iif(valtype(nIndex)=="A",NIL,nIndex)
	obj:DbmClosing  := .f.

	obj:__cacheBody:= NIL
	obj:__locateExpr:= NIL


	obj:close	:= @list_close()
	obj:getValue	:= @list_getValue()
	obj:getExpr	:= @list_getExpr()
	obj:getInfo	:= @list_getInfo()
	obj:getBlank	:= @list_getInfo()

	obj:setIndex	:= @list_setIndex()

	obj:delete	:= @list_delete()
	obj:undelete	:= @list_undelete()
	obj:add		:= @list_add()
	obj:append	:= @list_add()
	obj:update	:= @list_update()
	obj:refresh	:= @list_refresh()
	obj:idExist	:= @list_idExist()

	obj:skip	:= @list_skip()
	obj:goto	:= @list_goto()
	obj:gotoID	:= @list_gotoID()
	obj:gotoTop	:= @list_gotoTop()
	obj:goTop	:= @list_gotoTop()
	obj:gotoBottom	:= @list_gotoBottom()
	obj:goBottom	:= @list_gotoBottom()
	obj:recno	:= @list_recno()
	obj:bof		:= @list_bof()
	obj:eof		:= @list_eof()
	obj:_locate	:= @list__locate()
	obj:locate	:= @list_locate()
	obj:locateRest	:= @list_locateRest()
	obj:setWhere	:= @list_setWhere()

	obj:dictionary	:= @list_dict()
	obj:depository	:= @list_dep()

	/* initial select */
	obj:setWhere(whereExpr)
	if valtype(nIndex)=="A"
		obj:aId		:= nIndex
	else
		obj:aId		:= oDbm:select(metaName,obj:nIndex,sName,obj:sWhere,obj:nCount,obj:deleted)
	endif
	//outlog(__FILE__,__LINE__,metaName,obj:nIndex,sName,obj:sWhere)
	//obj:aId		:= oDbm:selectDebug(metaName,obj:nIndex,sName,obj:sWhere)
	obj:skip(1)
	obj:skip(-1)

return obj
************************************************************
static function list_setWhere(whereExpr)
	local errBl, wblock,s
	if !empty(whereExpr)
		if left(whereExpr,2) == "{|"
		else
			s:="{||"+whereExpr+"}"
		endif
		errBl := errorBlock({|err|break(err)})
		begin sequence
			wblock := &s
		recover
			::error := [Error compiling WHERE expression:]+s
		end sequence
		errorBlock(errBl)
	endif
	::sWhere	:= whereExpr
	::wBlock	:= wBlock // codeblock for where expr
return
************************************************************
static function list_dict()
return ::oDbm:dictionary()
static function list_dep()
return ::oDbm
************************************************************
static function list_locate(cExpr)
	::__locateExpr := cExpr
return ::_locate(cExpr,.f.)
************************************************************
static function list_locateRest(cExpr)
return ::_locate(cExpr,.t.)
************************************************************
static function list__locate(cExpr,lRest)
	local ret :=.f.,block, odata, _cExpr
	lRest := iif(lRest == NIL, .f., lRest)
	if ! lRest
		::goTop()
	endif
	if ! empty(cExpr)
		::__locateExpr := cExpr
	endif
	_cExpr := ::__locateExpr
	if empty(_cExpr)
		return .t.
	endif
	if valtype(_cExpr) == "B"
		block := _cExpr
	else
		block := "{||"+_cExpr+"}"
		block := &block
	endif
	while !::eof()
		odata := ::getValue()
		if mapEval(oData,block,::oDbm)
			ret:= .t.
			exit
		endif
		::skip()
	end
return ret
************************************************************
static function list_setIndex(ordId)
	local i,oDict,class_desc, oldIndex:= ::nIndex
	if valtype(ordId) == "N"
		::nIndex := ordId
	else
		oDict := ::oDbm:dictionary()
		class_desc := oDict:getValue(::metaName)
		if !("IDX_LIST" $ class_desc)
			return .f.
		endif
		::nIndex := ascan(class_desc:idx_list,ordId)
	endif
	if oldIndex != ::nIndex
		::refresh()
	endif
return (::nIndex != 0)
************************************************************
static function list_refresh()
	::aId	:= ::oDbm:select(::metaName,::nIndex,::sName,::sWhere,::nCount,::deleted)
	::skip(0)
return
************************************************************
static function list_getValue(fieldName)
	local oBody,i,k, ret
	if ::__cacheBody == NIL
		oBody := ::oDbm:getValue(::currId)
		if empty(::oDbm:error)
			::__cacheBody := oBody
		endif
	else
		oBody := ::__cacheBody
	endif
	::error := ::oDbm:error
	if fieldName==NIL
		return oBody
	endif
	if valtype(fieldName) == "N"
		i :=1
		for k in oBody
			if i == fieldName
			     ret := k
			     exit
			endif
			i++
		next
	else
		fieldName := upper(fieldName)
		if fieldName $ oBody
			ret := oBody[fieldName]
		endif
       endif
return ret
************************************************************
static function list_getExpr(expr)
	local ret,oBody,bErr:=errorBlock({|err|break(err)})
	if ::__cacheBody == NIL
		oBody := ::oDbm:getValue(::currId)
	else
		oBody := ::__cacheBody
	endif
	begin sequence
		ret := mapEval(oBody,expr,::oDbm,oBody)
	end
	::error := ::oDbm:error
	errorblock(bErr)
return ret
************************************************************
static function list_getInfo(lBlank)
	local oBody:=map()
	lBlank := iif( lBlank==NIL,.f.,.t.)
	::error:=""
	if lBlank
		oBody := ::oDbm:checkBody(oBody,::metaName)
	else
		oBody := ::oDbm:getValue(::currId)
	endif
return  oBody
************************************************************
static function list_delete()
	local ret := ::oDbm:delete(::currId)
	::error := ::oDbm:error
	::refresh()
return ret
************************************************************
static function list_undelete()
	local ret := ::oDbm:undelete(::currId)
	::error := ::oDbm:error
	::refresh()
return ret
************************************************************
static function list_add(oData)
	local ret := ::oDbm:append(oData,::metaName)
	::error := ::oDbm:error
	::refresh()
return ret
************************************************************
static function list_idExist(id)
	local oBody
	oBody := ::oDbm:getValue(Id)
return  !empty(oBody)
************************************************************
static function list_update(oData)
	local ret := ::oDbm:update(oData,::metaName)
	::error := ::oDbm:error
	::refresh()
return ret
************************************************************
static function list_skip(nSkip)
	local nSkipped:=0,oData
	local oldpos:=::currPos
	::__cacheBody := NIL
	nSkip := iif(nSkip==NIL,1,nSkip)
	if !empty(::wblock) .and. nSkip!=0
	  ::currPos += iif(nSkip>=0,1,-1)
	   do while ::currPos>0 .and. ::currPos<=len(::aid)
		odata := ::oDbm:getValue(::aId[ ::currPos ])
		if mapEval(oData,::wBlock,::oDbm)
			nSkipped += iif(nSkip>=0,1,-1)
			oldPos:=::currPos
		endif
		if nSkipped == nSkip
			exit
		endif
		::currPos += iif(nSkip>=0,1,-1)
	   enddo
	else
	  ::currPos += nSkip
	  nSkipped := nSkip
	endif
	::bof := (::currPos<1)
	if (nSkip < 0 .and. nSkipped > nSkip) .or. nSkip==0
		::currPos := oldPos
	endif
	::eof := (::currPos>len(::aid))
	::currPos := max(1,::currPos)
	::currPos := min(::currPos,len(::aId)+1)
	if ::currPos >0 .and. ::currPos<=len(::aId)
		::currId := ::aId[ ::currPos ]
	else
		::currId := ""
	endif
	if empty(::aId)
		::bof := ::eof := .t.
	endif
return
************************************************************
static function list_bof()
return  ::bof
************************************************************
static function list_eof()
return  ::eof
************************************************************
static function list_recno()
return  ::currPos
************************************************************
static function list_gotoID(objID)
	local i
	if empty(objID)
		return .f.
	endif
	i := ascan(::aId,objId)
	if i>0
		::currPos := i
	else
		return .f.
	endif
	::skip(1)
	::skip(-1)
return .t.
************************************************************
static function list_goto(nRecno)
	if nRecno != NIL
		::currPos := nRecno
		::skip(1)
		::skip(-1)
		return .t.
	endif
return .f.
************************************************************
static function list_gotoTop()
	::goto(1)
return .f.
************************************************************
static function list_gotoBottom()
	::goto(len(::aID))
return .f.
************************************************************
static function list_close()
	if ::DbmClosing
		::oDbm:close()
	endif
return .t.
