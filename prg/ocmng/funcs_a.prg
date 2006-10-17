/*
    Copyright (C) 2005-2006  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
********************************

static bMess := NIL

*************************************
function ocMngSetMessager(cBlock)
	local ret := bMess
	if valtype(cBlock) == "B"
		bMess := cBlock
	else
		bMess := NIL
	endif
return ret
*************************************
function ocMngMessage(xData,nLevel)
	local s,str := toString(xData)
	if bMess == NIL
		return
	endif
	s := set("COMPONENT_FILENAME")
	if !empty(s)
		str+=" ("+s+")"
	endif
return	eval(bMess,str,nLevel)
