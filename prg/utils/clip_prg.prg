/*
    Copyright (C) 2001  ITK
    Autor   : Uri (uri@itk.ru)
    Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/
local _file,f1,f2,c:=.f.,i,func_str,sError:="",func_list:={}

set translate off

_file:=param(1)
if empty(_file) //.or. ("-" $ _file)
	?  "This is executor PRG-files"
	?  "usage: clip_prg filename.prg params,....."
        ?
        return
endif
i=rat(".",_file)
_file:=substr(_file,1,i-1)
f1:=directory(_file+".prg")
f2:=directory(_file+".po")
if len(f1) < 1
	? "File not found:",_file+".prg"
        ?
        return
else
        if len(f2) < 1
        	c:=.t.
        else
        	// mini make
        	if f1[1][3] > f2[1][3] .or. f1[1][4] > f2[1][4]
                	c:=.t.
                endif
        endif

endif
if c  // compile ?
	compileFile(_file+".prg","-p",@sError)
endif
if !empty(sError)
	? "compile error:"
        ? sError
        return
endif
load(_file+".po",func_list)
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
