/*
    Copyright (C) 2002  ITK
    Author   : Alexey (alexey@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
function queueNew()
	local obj:=map()

        obj:data:={}

	obj:put:=@queue_put()
	obj:get:=@queue_get()
	obj:head:=@queue_head()
	obj:tail:=@queue_tail()
	obj:len:=@queue_len()
	obj:free:=@queue_free()
	obj:empty:=@queue_empty()

return obj

*******************************************
static  function queue_len()
return len(::data)

*******************************************
static  function queue_empty()
return len(::data)==0

*******************************************
static  function queue_free()
	asize(::data,0)
return .t.

*******************************************
static  function queue_put(var_data)
	aadd(::data,var_data)
return len(::data)

*******************************************
static  function queue_get()
	local var_data:=NIL
        if len(::data)>0
	   var_data:=::data[1]
           adel(::data,1)
           asize(::data,len(::data)-1)
        endif
return var_data

*******************************************
static  function queue_head()
	local var_data:=NIL
        if len(::data)>0
	   var_data:=::data[1]
        endif
return var_data

*******************************************
static  function queue_tail()
	local var_data:=NIL
        if len(::data)>0
	   var_data:=atail(::data)
        endif
return var_data
