/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html

    class SORTEDARRAY
*/

#include "set.ch"

*****************************************
function tSortedArray()
	local obj:=map()
        obj:new	:=@ __SA_New()
return obj

*****************************************
function tSortedArrayNew()
return  __SA_New(map())

*****************************************
static function __SA_New(self)
	self:className	:="SORTEDARRAY"
        self:items	:={}
        self:error	:=""
	_recover_sortedarray(self)
return self

*****************************************
function _recover_sortedArray(obj)
	obj:len		:=@ __SA_len()

	obj:add		:=@ __SA_Add()
	obj:del		:=@ __SA_DelKey()
	obj:delete	:=@ __SA_DelKey()
	obj:delKey	:=@ __SA_delkey()
	obj:delItem	:=@ __SA_delItem()

	obj:seek	:=@ __SA_Seek()
	obj:hardSeek	:=@ __SA_hardSeek()
	obj:softSeek	:=@ __SA_SoftSeek()

	obj:getKey	:=@ __SA_getkey()
	obj:getData	:=@ __SA_getData()
	obj:getItem	:=@ __SA_getItem()
	obj:__bound	:=@ __SA_bound()
return obj

*****************************************
static function __SA_len()
return len(::items)
*****************************************
static function __SA_bound(pos)
	::error:=""
        if pos<0 .or. pos > len(::items)
        	::error:=[Out from bound in sorted array]
                return .f.
        endif
return .t.
*****************************************
static function __SA_getKey(pos)
        if !::__bound(pos)
                return NIL
        endif
        return ::items[pos][1]
return .t.

*****************************************
static function __SA_getData(pos)
        if !::__bound(pos)
                return NIL
        endif
        return ::items[pos][2]
return .t.

*****************************************
static function __SA_getItem(pos)
        if !::__bound(pos)
                return NIL
        endif
        return ::items[pos]
return .t.

*****************************************
static function __SA_Add(key,value)
	local lExact:=set(_SET_EXACT,.t.)
        local nLen:=len(::items)
        local nPos,bPos:=1, ePos:=nLen
	::error:=""
	if key == NIL .or. value == NIL
        	::error:=[Unknown values for key or data]
                set(_SET_EXACT,lExact)
        	return .f.
        endif
        if nLen==0
        	aadd(::items,{key,value})
        elseif key<::items[1][1]
                aadd(::items,"")
                ains(::items,1,{key,value})
        elseif key>=::items[nLen][1]
        	aadd(::items,{key,value})
        else
        	nPos:=int(nLen/2)
                do while .t.
                	if key>=::items[nPos][1]
                        	bPos=nPos-1
                                nPos:=bPos+int((ePos-bPos)/2)
                        else
                        	ePos=nPos+1
                                nPos:=bPos+int((ePos-bPos)/2)
                        endif
                	if ePos-bpos < 5
                        	for nPos=ePos to bPos step -1
                                    if key>=::items[nPos][1]
                                    	nPos++
                                    	exit
                                    endif
                                next
                                exit
                        endif
                enddo
                aadd(::items,"")
                ains(::items,nPos,{key,value})
        endif
        set(_SET_EXACT,lExact)
return .t.

*****************************************
static function __SA_delItem(pos)
	::error:=""
        if pos<0 .or. pos > len(::items)
        	::error:=[Out bounds in sorted array]
                return .f.
        endif
        adel(::items,pos)
        asize(::items,len(::items)-1)
return .t.
*****************************************
static function __SA_delKey(key,value)
	local lExact:=set(_SET_EXACT,.t.)
        local nLen:=len(::items), ret:=.f.
        local nPos:=-1,bPos:=1, ePos:=nLen
	::error:=""
	if key == NIL .or. value == NIL
        	::error:=[Unknown values for key or data]
                set(_SET_EXACT,lExact)
        	return .f.
        endif
        if nLen==0
        elseif key <  ::items[1][1]
        elseif key >= ::items[nLen][1]
        else
        	nPos:=int(nLen/2)
                do while .t.
                	if key>=::items[nPos][1]
                        	bPos=nPos-1
                                nPos:=bPos+int((ePos-bPos)/2)
                        else
                        	ePos=nPos+1
                                nPos:=bPos+int((ePos-bPos)/2)
                        endif
                	if ePos-bpos < 5
                        	for nPos=bPos to ePos
                                    if key==::items[nPos][1] .and. value==::items[nPos][2]
                                    	exit
                                    endif
                                next
                                exit
                        endif
                enddo
        endif
        if nPos>0 .and. nPos<=nLen .and. key==::items[nPos][1] .and. value==::items[nPos][2]
        	adel(::items, nPos)
                asize(::items, nlen-1)
                return .t.
        endif
        set(_SET_EXACT,lExact)
        ::error:=[Key value not found in sorted array]
return .f.
*****************************************
static function __SA_hardSeek(key)
return ::seek(key,.f.)
*****************************************
static function __SA_softSeek(key)
return  ::seek(key,.t.)
*****************************************
static function __SA_Seek(key,lSoft)
	local lExact:=set(_SET_EXACT,.t.)
        local nLen:=len(::items),kLen:=len(key), ret:=.f.
        local nPos:=-1,bPos:=1, ePos:=nLen
        lSoft:=iif(lSoft==NIL,.f.,lSoft)
	::error:=""
	if key == NIL
        	::error:=[Unknown values for key]
                set(_SET_EXACT,lExact)
        	return -1
        endif
        if nLen==0
        elseif key <  ::items[1][1]
        	nPos:=iif(lSoft,1,-1)
        elseif key >= ::items[nLen][1]
        else
        	nPos:=int(nLen/2)
                do while .t.
                	if key>=::items[nPos][1]
                        	bPos=nPos-1
                                nPos:=bPos+int((ePos-bPos)/2)
                        else
                        	ePos=nPos+1
                                nPos:=bPos+int((ePos-bPos)/2)
                        endif
                	if ePos-bpos < 5
                		if !lSoft .or. valtype(key) != "C"
                        		for nPos=bPos to ePos
                                    		if key==::items[nPos][1]
                                    			exit
                                    		endif
                                	next
                                else
                        		for nPos=bPos to ePos
                                    		if key<=left(::items[nPos][1],kLen)
                                    			exit
                                    		endif
                                	next
                                endif
                                exit
                        endif
                enddo
        endif
        set(_SET_EXACT,lExact)
        if nPos<1 .or. nPos>nLen
        	return nLen+1
        endif
        if !lSoft .and. key!=::items[nPos][1]
        	return nLen+1
        endif
return nPos

