/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

function codb_oql_select(classname,fromDep,whereExpr,orderBy)
   local ret:=map(),oDict,tmp,class_id
   local oDep:=coDepository():new(fromDep)

   ret:close := {||.t.}
   ret:error := ""

   if !empty(oDep:error)
	ret:error := oDep:error
	return ret
   endif

   oDep:open()
   oDict:=oDep:dictionary()

   if !empty(oDep:error)
	ret:error := oDep:error
	return ret
   endif

   if !empty(oDict:error)
	ret:error := oDict:error
	return ret
   endif

   if classname=="*"
   else
	tmp := oDict:getvalue(classname)
	if empty(tmp)  // classname  != classID
		tmp := oDict:select("CLASS",0,classname)
		if  empty(tmp) // name not found
			ret:error := codb_error(1300)+":"+classname
			return ret
		else
			class_id := tmp[1]
		endif
	else
		class_id := classname
	endif
   endif

   ret := codb_idList(oDep,class_id,,,whereExpr)
   ret:DbmClosing := .t.
return ret
