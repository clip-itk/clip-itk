/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/
local _file,i,func_str,func_list:={}

set translate off

_file:=param(1)
if empty(_file) //.or. ("-" $ _file)
	?  "This is executor PO-files"
	?  "usage: clip_run filename.po params,....."
        ?
        return
endif
if !(".po" $ _file)
   _file+=".po"
endif
if !file(_file)
  	? "Can~t open file:"+_file
        ?
        return
endif
load(_file,func_list)
//? func_list
func_str=func_list[1]+"("
for i=2 to pcount()
	if i==pcount()
		func_str+='"'+param(i)+'"'
        else
		func_str+='"'+param(i)+'",'
        endif
next
func_str+=")"
&func_str
?
