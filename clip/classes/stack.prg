/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
function stackNew()
	local obj:=map()

        obj:data:={}

	obj:push:=@stack_push()
	obj:pop:=@stack_pop()
	obj:len:=@stack_len()
	obj:free:=@stack_free()

return obj

*******************************************
static  function stack_len()
return len(::data)
*******************************************
static  function stack_free()
	asize(::data,0)
return .t.

*******************************************
static  function stack_push(var_data)
	aadd(::data,var_data)
return len(::data)

*******************************************
static  function stack_pop()
	local var_data:=NIL
        if len(::data)>0
	   var_data:=atail(::data)
           asize(::data,len(::data)-1)
        endif
return var_data
