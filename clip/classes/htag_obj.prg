/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

function html_tagNew(tagname, other, title, style, class, event, id, lang, language)

	local mlang	:={"JAVASCRIPT","JSCRIPT","VBSCRIPT"}
	local i
	local obj	:=map()

	tagname=upper(tagName)
	obj:classname	:= "HTML_TAG"
	obj:tagName     := tagname	//

	obj:fields	:= map()           // list of fields this tag
	obj:fieldsOrder	:= {}           // list of fields this tag
        obj:hashes	:= map()

	obj:toString	:= @tag_toString()
	obj:closeString	:= @tag_closeString()
	obj:addField	:= @tag_addField()
	obj:hashname	:= @tag_hashname()
	*********
	if title!=NIL
		obj:addField("TITLE",title) // TITLE=string
	endif
	if style!=NIL
		obj:addField("STYLE",style) // STYLE=string
	endif
	if class!=NIL
		obj:addField("CLASS",class) // CLASS=string
	endif
	if event!=NIL
		obj:addField("EVENT",event) // <название_события>=название_сценария
	endif
	if id!=NIL
		obj:addField("ID",id)       // ID=string
	endif
	if valtype(language)=="N"
		if language<1 .or. language>len(mlang)
			language:=1
		endif
		language:=mlang[language]
	endif
	if language!=NIL
		obj:addField("LANGUAGE",language)
					   // LANGUAGE=JAVASCRIPT,JSCRIPT,VBSCRIPT
	endif

	if valtype(other)=="A"
		for i=1 to len(other)
			if len(other[i])==2
				obj:addField(other[i][1],other[i][2])
			endif
		next
		obj:other	:= ""
	else
		obj:other	:= other // прочие поля
	endif


return obj
*******************************************
static function tag_hashname(hashstr)
	local fff
        if valtype(hashstr)=="C"
		fff:=alltrim(upper(hashstr))
        else
        	fff:=hashstr
        endif
        if fff $ ::hashes
        	return ::hashes[fff]
        endif
return hashstr

*******************************************
static function tag_addField(fname,fdata)
	local fff:=alltrim(upper(fname))
	if valtype(fname)=="C"
        	if fff $ ::fields
                else
                	aadd(::fieldsOrder,fff)
                endif
		::fields[fff]:=fdata
		::hashes[fff]:=fff
		return len(::fields)
	endif
return 0

*******************************************
static function tag_toString()
	local ret,i, arr
	ret:="<"+::tagName+" "
	if !empty(::other)
		ret+=alltrim(toString(::other))+' '
	endif
	arr := mapkeys(::fields)
	for i=1 to len(arr)
		if ::fields[arr[i]]==NIL
			ret+=hashname(arr[i])+' '
			loop
		else
			ret+=hashname(arr[i])+'='
		endif
		if valtype(::fields[arr[i]])=="N"
			ret+=alltrim(toString(::fields[arr[i]]))+' '
		else
			ret+='"'+alltrim(toString(::fields[arr[i]]))+'" '
		endif
	next
	ret:=left(ret,len(ret)-1)
	ret+=">"
return ret

*******************************************
static function tag_closeString()
return "</"+::tagname+">"
