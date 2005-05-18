/*
    Copyright (C) 2004  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "codbcfg.ch"

/*****************************************************/
function codb_unify(cCmd,args,oAnswer)
	if left(cCmd,4) == "DICT"
		_unify_dict(substr(cCmd,6),args,oAnswer)
	elseif left(cCmd,3) == "DEP"
		_unify_dep(substr(cCmd,5),args,oAnswer)
	elseif left(cCmd,8) == "CODBLIST"
		_unify_list(substr(cCmd,10),args,oAnswer)
	else
	endif
return
/*****************************************************/
static function _unify_list(cCmd,args,oAnswer)
	local oList,ret,bl,len
	local p1,p2,p3,p4,p5,p6,p7,p8,p9,p10
	/*
	if ! __check_args(args,1,{"C"}) //.or. len(args[1]) != DICT_ID_LEN+DEP_ID_LEN
		oAnswer:error := codb_error(1007)
		return
	endif
	*/
	oList := codbList():new()

	if !(cCmd $ oList)
		oAnswer:error := codb_error(1045)+":"+cCmd
		return
	endif

	len := len(args)
	iif( len>0,p1 := args[1],NIL)
	iif( len>1,p2 := args[2],NIL)
	iif( len>2,p3 := args[3],NIL)
	iif( len>3,p4 := args[4],NIL)
	iif( len>4,p5 := args[5],NIL)
	iif( len>5,p6 := args[6],NIL)
	iif( len>6,p7 := args[7],NIL)
	iif( len>7,p8 := args[8],NIL)
	iif( len>8,p9 := args[9],NIL)

	bl :=  oList[cCmd]
	ret := eval(bl,oList,p1,p2,p3,p4,p5,p6,p7,p8,p9)
	oAnswer:error := oList:error
	oAnswer:return := ret
	oList:close()
return
/*****************************************************/
static function _unify_dep(cCmd,args,oAnswer)
	local oDep,ret,bl,len
	local p1,p2,p3,p4,p5,p6,p7,p8,p9,p10
	if ! __check_args(args,1,{"C"}) .or. len(args[1]) != DICT_ID_LEN+DEP_ID_LEN
		oAnswer:error := codb_error(1007)
		return
	endif
	oDep := codb_needDepository(args[1])
	if empty(oDep)
		oAnswer:error := codb_error(1006)+":"+args[1]
		return
	endif
	if cCmd=="OPEN"
		oAnswer:return := .t.
		return
	endif

	if !(cCmd $ oDep)
		oAnswer:error := codb_error(1045)+":"+cCmd
		return
	endif

	len := len(args)
	iif( len>1,p1 := args[2],NIL)
	iif( len>2,p2 := args[3],NIL)
	iif( len>3,p3 := args[4],NIL)
	iif( len>4,p4 := args[5],NIL)
	iif( len>5,p5 := args[6],NIL)
	iif( len>6,p6 := args[7],NIL)
	iif( len>7,p7 := args[8],NIL)
	iif( len>8,p8 := args[9],NIL)
	iif( len>9,p9 := args[10],NIL)

	bl :=  oDep[cCmd]
	ret := eval(bl,oDep,p1,p2,p3,p4,p5,p6,p7,p8,p9)
	oAnswer:error := oDep:error
	oAnswer:return := ret
return
/*****************************************************/
static function _unify_dict(cCmd,args,oAnswer)
	local oDict,ret,bl,len
	local p1,p2,p3,p4,p5,p6,p7,p8,p9,p10
	if ! __check_args(args,1,{"C"}) .or. len(args[1]) != DICT_ID_LEN
		oAnswer:error := codb_error(1007)
		return
	endif
	oDict := codb_needDepository(args[1])
	if empty(oDict)
		oAnswer:error := codb_error(1006)+":"+args[1]
		return
	endif
	if cCmd=="OPEN"
		oAnswer:return := .t.
		return
	endif

	if !(cCmd $ oDict)
		oAnswer:error := codb_error(1045)+":"+cCmd
		return
	endif

	len := len(args)
	iif( len>1,p1 := args[2],NIL)
	iif( len>2,p2 := args[3],NIL)
	iif( len>3,p3 := args[4],NIL)
	iif( len>4,p4 := args[5],NIL)
	iif( len>5,p5 := args[6],NIL)
	iif( len>6,p6 := args[7],NIL)
	iif( len>7,p7 := args[8],NIL)
	iif( len>8,p8 := args[9],NIL)
	iif( len>9,p9 := args[10],NIL)

	bl :=  oDict[cCmd]
	ret := eval(bl,oDict,p1,p2,p3,p4,p5,p6,p7,p8,p9)
	oAnswer:error := oDict:error
	oAnswer:return := ret
return
/******************************/
static function __check_args(qArgs,nLen,aTypes)
	local i
	if valtype(qArgs) != "A"
		return .f.
	endif
	if len(qArgs) < nLen
		return .f.
	endif
	for i=1 to len(qArgs)
		if len(aTypes) < i
			return .t.
		endif
		if empty(aTypes[i])
			loop
		endif
		if ! (valtype(qArgs[i]) $ aTypes[i])
			return .f.
		endif
	next
return .t.

