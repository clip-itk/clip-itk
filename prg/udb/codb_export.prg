/*
    Copyright (C) 2002-2005  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "codb.ch"
#include "codbcfg.ch"

local oDep,oDict
/*
not_null -> notNull
not_empty -> notEmpty
log_need -> logNeed
defvalue -> defValue
extent_id -> extent
super_id -> superClass
expr_essence -> essence
unique_key -> uniqueKey
idx_main -> mainIdx
attr_list -> attributes
idx_list -> indices
attr_find -> findAttrs
ref_to -> refTo
class_id -> class
depend_of -> dependOf
group_id -> group
user_id -> user
col_list -> columns
*/

parameters sDep, className, sData

local s :="",s1:="",s2:="",s3:="",s4:=""
local s5:="",s6:="",s7:="",s8:=""
local isDict := .f.

private files := {}, depends := {}
memvar files, depends

if empty(sDep) //.or. empty(classname) //.or. empty(sData)
	? 'Usage: codb_export depository|dictionary ["classname"] ["expression"]'
	?
	return
endif

	set exclusive off
	set("PRINTER_EOL","&\n")

	sData := iif(sData == NIL, "", sData)

	if len(sDep) == DICT_ID_LEN
		oDict := coDictionary():new(sDep)
		if !empty(oDict:error)
			? oDict:error
			?
			return
		endif
		oDict:open()
		if !empty(oDict:error)
			? oDict:error
			?
			return
		endif
		oDep := oDict
		isDict := .t.
	else
		oDep:=coDepository():new(sDep)
		if !empty(oDep:error)
			? oDep:error
			?
			return
		endif
		oDep:open()
		if !empty(oDep:error)
			? oDep:error
			?
			return
		endif
	endif

	?? __header(oDep,className,sData)
	? component_data(oDep,className)

	if !empty(classname)
		s1 := codb_exportMeta(oDep,className,sData)
	endif

	if !isDict .and. !empty(className) // oDep:className == "CODBDEPOSITORY"
		s2 := codb_exportData(oDep,className,sData)
	endif

	if isDict  .and. empty(className)
		s3 := codb_exportDeps(oDep)
	endif

	? __exportDepend()
	? __exportFiles()

	if !empty(s1)
		? s1
		?
	endif
	if !empty(s2)
		? s2
		?
	endif
	if !empty(s3)
		? s3
		?
	endif
	? __footer(oDep,className,sData)

	?
return

/**********************/
static function codb_exportDeps(oDict)
	local i, s1, ret := "", n:= "&\n", s:= "&\t"
	local tmp, obj
	local m:={"ID","NAME","DTYPE","HOST","PORT","DBUSER","PASSWD","DBNAME"}

	ret := s+'<dictionary rules="appendOnly">'+n
	for i=1 to len(m)
		s1 := m[i]
		s1 := lower(s1)
		if m[i] $ oDict  .and. !empty(oDict[ m[i] ])
			ret += s+s+'<'+s1+'>'+oDict[ m[i] ]+'</'+s1+'>'+n
		endif
	next
	ret += s+s+'<type>$CODBTYPE$</type>'+n
	if "PATH" $ oDict  .and. !empty(oDict:path)
		ret += s+s+'<path>$CODBROOT$</path>'+n
	endif
	ret += s+'</dictionary>'+n+n

	ret += s+'<meta dictionary="'+oDict:id+'" rules="appendOnly">'+n
	tmp := oDict:select("DEPOSIT")
	for i=1 to len(tmp)
		obj := oDict:getValue(tmp[i])
		if empty(obj)
			loop
		endif
		ret += s+s+'<depository name="'+obj:name+'" memoSize="'+alltrim(toString(obj:memoSize))+'" />'+n
	next
	tmp := oDict:select("EXTENT")
	for i=1 to len(tmp)
		obj := oDict:getValue(tmp[i])
		if empty(obj)
			loop
		endif
		ret += s+s+'<extent name="'+obj:name+'">'+obj:help+'</extent>'+n
	next
	ret += s+'</meta>'+n+n

return ret
/**********************/
static function __exportDepend()
	local i, s1, ret := "", n:= "&\n", s:= "&\t"
	local x:=map()

	ret := s+'<requires>'+n
	for i=1 to len(depends)
		if depends[i][2] $ x
			loop
		endif
		ret += s+s+'<dependence type="'+depends[i][1]+'">'+depends[i][2]+'</dependence>'+n
		x[ depends[i][2] ] := depends[i][2]
	next
	ret += s+'</requires>'+n
return ret

/**********************/
static function __exportFiles()
	local i, s1, ret := "", n:= "&\n", s:= "&\t"

	ret := s+'<files>'+n

	for i=1 to len(files)
		s1 := s+s+'<file name="'+files[i][1]+'" type="'+files[i][2]+'">'
		s1 += files[i][3]+'</file>'+n
		memowrite(files[i][1],files[i][4])
		ret += s1
	next
	ret += s+'</files>'+n+n
return ret
/**********************/
static function component_data(oDep,classname)
	local ret := "", n:= "&\n", s:= "&\t"
	local oDict,classDesc,extent

	oDict := oDep:dictionary()
	classDesc := oDict:classBodyByName(className)


	if empty(className)
		ret += s+'<name>'+oDep:id+'</name>'+n
		ret += s+'<category>CORE/DB</category>'+n
	else
		ret += s+'<name>'+classname+'-ru</name>'+n
		if !empty(classDesc)
			extent := oDict:getValue(classDesc:extent_id)
		endif
		/*
		if !empty(extent)
			ret += s+'<category>'+extent:name+'</category>'+n
		endif
		*/
		ret += s+'<category>REFS/ru</category>'+n
	endif
	ret += s+'<version>1.0</version>'+n
	ret += s+'<description></description>'+n
	ret += s+'<license>GNU/GPL</license>'+n
	//ret += s+'<created>'+dtoc(date(),"yyyy-mm-dd")+'</created>'+n
	ret += s+'<created>2006-04-24</created>'+n
	ret += s+'<modified>'+dtoc(date(),"yyyy-mm-dd")+'</modified>'+n
	ret += s+'<author>Uri</author>'+n
	ret += s+'<property name="policy">ru</property>'+n

return ret

/**********************/
static function codb_exportMeta(oDep,className,expr)
	local oDict,ret := ""
	local classDesc

	oDict:=oDep:dictionary()

	classDesc := oDict:classBodyByName(className)
	if empty(classDesc)
		ret += __error([Class description not found:]+' '+toString(classname))
		return ret
	endif

	aadd(depends,{"component","void.xml"})
	//aadd(depends,{"component",oDep:id+"/"+CORE+".xml"}})
	ret += __exportMeta(oDict,classDesc)

return ret

/**********************/
static function codb_exportData(oDep,className,expr)
	local  s:="&\t",n:="&\n",ret :=""
	local i,j,tmp,obj,objs,attrs:={},m:={}
	local name,attr,type,data,s2,s3,s4,s5
	local oDict := oDep:dictionary()
	local classDesc

	classDesc := oDict:classBodyByName(className)

	for i=1 to len(classDesc:attr_list)
		tmp := oDict:getValue(classDesc:attr_list[i])
		if empty(tmp)
			loop
		endif
		aadd(attrs,tmp)
	next
	if "EXPORT_LIST" $ classDesc .and. !empty(classDesc:export_list)
		for i=1 to len(attrs)
			if ascan(classDesc:export_list,attrs[i]:name) <=0
				aadd(m,i)
			endif
		next
		for i=len(m) to 1 step -1
		    adel(attrs,m[i])
		next
		asize(attrs,len(attrs)-len(m))
	endif
	objs :=  __makeObjsTree(oDep,classDesc,expr)
	ret += s+'<data>'+n
	ret += s+'  <objects depository="'+oDep:id+'" class="'+className+'" rules="appendOnly">'+n
	for i=1 to len(objs)
		obj := oDep:getValue(objs[i])
		if empty(obj)
			ret += __error([Object not found:]+objs[i])
			loop
		endif
		ret += s+s+'<object>'+n
		s3:=""
		for j=1 to len(attrs)
			name := attrs[j]:name
			type := attrs[j]:type
			s2 := upper(name)
			if !(s2 $ obj)
				loop
			endif
			data := obj[s2]
			s4:=s5:=""
			do case
				case type == "C"
					s4 := data
				case type == "N"
					s4 := alltrim(str(data))
				case type == "D"
					s4 := dtos(data)
				case type == "L"
					s4 := iif(data,"true","false")
				case type == "R"
					if !empty(data)
						__metaGetValue(data)
						s4 := codb_getKeyValue(data)
						s5 := codb_getRefTo(data)
					else
						s4 := s5 := ""
					endif
				case type == "S"
					if !empty(data)
						__metaGetValue(data)
						s4 := codb_getRefTo(data)
						aadd(depends,{"component",strtran(s4,":","/")+".xml"})
					else
						s4 := ""
					endif
				case type == "A"
					s4 := __exportDataArray(oDep,data,3)
				otherwise
					s4 := toString(data)
			endcase
			s3 += s+s+s+'<attr name="'+name+'"'
			if !empty(s5)
				s3 += ' refTo="'+s5+'"'
			endif
			s3 += '>'+s4+'</attr>'+n
		next
		ret += s3+s+s+'</object>'+n
	next
	ret += s+'  </objects>'+n
	ret += s+'</data>'+n
return ret
/**********************/
static function  __makeObjsTree(oDep,classDesc,expr)
	local name := "",tmp, tmp1,objs:={}
	local i,j,x,y, xRef:= map(), owners:={}, members:={}, oDict
	local id,owner
	oDict := oDep:dictionary()
	for i=1 to len(classDesc:attr_list)
		tmp := oDict:getValue(classDesc:attr_list[i])
		if empty(tmp)
			loop
		endif
		if tmp:ref_to == classDesc:id
			tmp1 := tmp:ref_to
			exit
		endif
		if upper(tmp:name) == "OWNER_ID"
			name := tmp:name
			exit
		endif
	next
	if !empty(tmp1)
		tmp := oDict:getValue(tmp1)
		if !empty(tmp)
			name := tmp:name
		endif
	endif
	if empty(expr)
		tmp := oDep:select(classDesc:id)
	else
		tmp := oDep:select(classDesc:id,,,expr)
	endif
	if empty(name)
		return tmp
	endif
	name := upper(name)
	for i=1 to len(tmp)
		tmp1 := oDep:getValue(tmp[i])
		if empty(tmp1)
			loop
		endif
		/*
		j := ascan(owners, {|x| x==tmp1[name]})
		if j==0
			aadd(owners, tmp1[name])
			aadd(members, {})
			j := len(owners)
		endif
		aadd(members[j],{tmp1:id,tmp1[name]})
		*/
		//xRef[ tmp1:id ] := tmp1[name]
		aadd(members,{tmp1:id,tmp1[name]})
	next
	outlog(__FILE__,__LINE__,owners)
	//tmp := oDep:select(classDesc:id,,,name+'==""'+iif(empty(expr),""," .and. "+expr))
	//__checkObjsTree(oDep,objs,name)
	for i=1 to 10
		for j=1 to len(members)
			x := -1
			id := members[j][1]
			owner := members[j][2]
			y := ascan(objs,owner)
			if empty(owner)
				x := ascan(objs,id)
			else
				y := ascan(objs,owner)
				if y>0
					x := ascan(objs,id)
				endif
			endif
			if x == 0
				aadd(objs,id)
			endif
			if x > 0
				adel(members,j)
				asize(members,len(members)-1)
			endif
		next
	next
return objs
/**********************/
static function __exportDataArray(oDep,_data,kol)
	local _s:="&\t",s,n:="&\n",ret :=""
	local  i,j,k,type,s1,s2,s3,s4,s5, data, obj
	local types := codb_info("CODB_ATTR_TYPES")
	s := replicate(_s,kol+1)
	ret := n
	for i=1 to len(_data)
		data := _data[i]
		type := valtype(data)
		s1:=s2:=s3:=s4:=s5:=""
		do case
			case type == "N"
				s2 := alltrim(str(data))
			case type == "D"
				s2 := dtos(data)
			case type == "L"
				s2 := iif(data,"true","false")
			case type == "A"
				s2 := __exportDataArray(oDep,data,kol+1)
			case type == "C"
				s2 := data
				obj := codb_getValue(data)
				if valtype(obj) == "O" .and. "CLASS_ID" $ obj
					type := "R"
					__metaGetValue(data)
					s5 := codb_getRefTo(data)
					s2 := codb_getKeyValue(data)
				endif
				if valtype(obj) == "O" .and. "__META" $ obj
					type := "S"
					s4 := obj:__meta
					s2 := left(obj:id,codb_info("DICT_ID_LEN"))+":"+obj:name
				endif
			otherwise
				s2 := toString(data)
		endcase
		k :=""
		j := ascan(types,{|x| x[1] == type})
		if j > 0
			k := types[j][3]
		endif
		ret += s+'<value type="'+k+'"'
		if !empty(s5)
		     ret += ' refTo="'+s5+'"'
		endif
		if !empty(s4)
		     ret += ' meta="'+s4+'"'
		endif
		ret +='>'+s2+'</value>'+n
	next
	ret += replicate(_s,kol)

return ret

/**********************/
static function __toString(attr,data)
	local ret,type
	type := attr:type
	do case
		case type == "C"
			ret := data
		case type == "N"
			ret := alltrim(str(data))
		case type == "D"
			ret := dtos(data)
		case type == "L"
			ret := iif(data,"true","false")
		otherwise
			ret := toString(data)
	endcase
return  ret
/**********************/
static function __exportMeta(oDict,classDesc)
	local  s:="&\t",n:="&\n",ret :=""
	local tmp,i,s2,s3,attr,idx
	ret += s+'<meta dictionary="'+oDict:id+'" rules="appendOnly">'+n
	//ret += s+'<attributes>'+n
	for i=1 to len(classDesc:attr_list)
		attr := oDict:getValue(classDesc:attr_list[i])
		if empty(attr)
			ret += __error([Object not found:]+classDesc:attr_list[i])
			loop
		endif
		if !empty(attr:counter)
			ret += __exportCounter(oDict,attr:counter)
		endif
		ret += __exportAttr(oDict,attr)
	next
	//ret += s+'</attributes>'+n
	for i=1 to len(classDesc:idx_list)
		idx := oDict:getValue(classDesc:idx_list[i])
		if empty(idx)
			ret += __error([Object not found:]+classDesc:idx_list[i])
			loop
		endif
		ret += __exportIndex(oDict,idx)
	next
	ret += n+s+s+'<class name="'+classDesc:name+'"'
	ret += s+s+'logNeed="'+iif(classDesc:log_need,"true","false")+'"'+n
	tmp := oDict:getValue(classDesc:extent_id)
	ret += s+s+s+'extent="'+iif(empty(tmp),"",tmp:name)+'" '+n
	tmp := oDict:getValue(classDesc:super_id)
	ret += s+s+s+'superClass="'+iif(empty(tmp),"",tmp:name)+'"'+n
	ret += s+s+s+'essence="'+__entityTran(classDesc:expr_essence)+'"'+n
	if "UNIQUE_KEY" $ classDesc .and. !empty(classDesc:unique_key)
		ret += s+s+s+'uniqueKey="'+classDesc:unique_key+'"'+n
	endif
	if "IDX_MAIN" $ classDesc .and. !empty(classDesc:idx_main)
		ret += s+s+s+'mainIdx="'+classDesc:idx_main+'"'+n
	endif
	**
	s2 := ""
	for i=1 to len(classDesc:attr_list)
		tmp := oDict:getValue(classDesc:attr_list[i])
		if empty(tmp)
			ret += __error([Object not found:]+classDesc:attr_list[i])
			loop
		endif
		s2+=tmp:name+","
	next
	s2 := left(s2,len(s2)-1)
	ret += s+s+s+'attributes="'+s2+'"'+n
	**
	s2 := ""
	for i=1 to len(classDesc:idx_list)
		tmp := oDict:getValue(classDesc:idx_list[i])
		if empty(tmp)
			ret += __error([Object not found:]+classDesc:idx_list[i])
			loop
		endif
		s2+=tmp:name+","
	next
	s2 := left(s2,len(s2)-1)
	ret += s+s+s+'indices="'+s2+'"'+n
	**
	s2 := ""
	if "ATTR_FIND" $ classDesc .and. !empty(classDesc:attr_find)
		for i=1 to len(classDesc:attr_find)
			/*
			tmp := oDict:getValue(classDesc:attr_find[i])
			if empty(tmp)
				ret += __error([Object not found:]+classDesc:attr_find[i])
				loop
			endif
			s2 += tmp:name+","
			*/
			s2 += classDesc:attr_find[i]+","
		next
		s2 := left(s2,len(s2)-1)
		ret += s+s+s+'findAttrs="'+s2+'"'+n
	endif
	**
	s2 := ""
	if "TCOL_LIST" $ classDesc .and. !empty(classDesc:tcol_list)
		for i=1 to len(classDesc:tcol_list)
			/*
			tmp := oDict:getValue(classDesc:tcol_list[i])
			if empty(tmp)
				ret += __error([Object not found:]+classDesc:tcol_list[i])
				loop
			endif
			s2 += tmp:name+","
			*/
			s2 += classDesc:tcol_list[i]+","
		next
		s2 := left(s2,len(s2)-1)
		ret += s+s+s+'tcolList="'+s2+'"'+n
	endif
	**
	ret += s+s+'/>'+n+n+n
	ret += __exportPlugins(oDict,classDesc)
	ret += __exportTviews(oDict,classDesc)
	ret += s+'</meta>'+n
return ret
/**********************/
static function __exportPlugins(oDict,classDesc)
	local  s:="&\t&\t",n:="&\n",ret :=""
	local types := codb_info("CODB_PLUGINS_TYPES")
	local i,j,k,x,tmp, tmp2, fname
	tmp := oDict:select("PLUGINS",,,'class_id=="'+classDesc:id+'"')
	for i=1 to len(tmp)
		tmp2 := oDict:getValue(tmp[i])
		if empty(tmp2)
			ret += __error([Object not found:]+tmp[i])
			loop
		endif
		ret += s+'<plugin name="'+tmp2:name+'"'+n
		ret += s+s+'class="'+classDesc:name+'"'+n
		k := tmp2:type
		j := ascan(types,{|x| x[1] == k})
		if j > 0
			k := types[j][3]
		endif
		ret += s+s+'type="'+k+'"'+n
		fname := tmp2:filename
		ret += s+s+'file="'+fname+'"'+n
		ret += s+s+'function="'+tmp2:mainfunc+'"'+n
		if empty(tmp2:source)
			loop
		endif
		if empty(fname)
			fname := classDesc:name+"-"+substr(tmp2:id,codb_info("DICT_ID_LEN")+codb_info("DEPOSIT_ID_LEN"))+".prg"
		endif
		aadd(files,{fname,"text/clip-source","ODB trigger for class "+classDesc:name,tmp2:source})
		ret += s+'/>'+n+n
	next
		//{"SOURCE"    ,"M",0            ,0,CODB_LENTYPE_NONE,""};
return ret
/**********************/
static function __exportTviews(oDict,classDesc)
	local ret := "", class_id := classDesc:id
	local i,j,k,tmp, tmp2, tcols:={}
	tmp := oDict:select("TVIEW",,,'class_id=="'+class_id+'"')
	for i=1 to len(tmp)
		tmp2 := oDict:getValue(tmp[i])
		if empty(tmp2)
			ret += __error([Object not found:]+tmp[i])
			loop
		endif
		for j=1 to len(tmp2:col_list)
			k := ascan(tcols,tmp2:col_list[j])
			if k > 0
				loop
			endif
			aadd(tcols,tmp2:col_list[j])
		next
	next
	tmp2 := oDict:select("TCOLUMN",,classDesc:name)
	for i=1 to len(tmp2)
		aadd(tCols,tmp2[i])
	next
	for i=1 to len(tcols)
		ret += __exportTcol(oDict,tcols[i])
	next
	for i=1 to len(tmp)
		tmp2 := oDict:getValue(tmp[i])
		if empty(tmp2)
			ret += __error([Object not found:]+tmp[i])
			loop
		endif
		ret += __exportTview(oDict,tmp2)
	next
return ret
/**********************/
static function __exportTview(oDict,tview)
	local  s:="&\t&\t",n:="&\n",ret :=""
	local i,s2,tmp
	ret += s+'<tview name="'+tview:name+'"'+n
	if "HEADER" $ tview .and. !empty(tview:header)
		ret += s+s+'header="'+tview:header+'"'+n
	endif
	if "FOOTER" $ tview .and. !empty(tview:footer)
		ret += s+s+'footer="'+tview:footer+'"'+n
	endif
	tmp := oDict:getValue(tview:class_id)
	if !empty(tmp)
		ret += s+s+'class="'+tmp:name+'"'+n
	endif
	tmp := oDict:getValue(tview:extent_id)
	if !empty(tmp)
		ret += s+s+'extent="'+tmp:name+'"'+n
	endif
	tmp := oDict:getValue(tview:group_id)
	if !empty(tmp)
		ret += s+s+'group="'+tmp:name+'"'+n
	endif
	tmp := oDict:getValue(tview:user_id)
	if !empty(tmp)
		ret += s+s+'user="'+tmp:name+'"'+n
	endif
	s2 := ""
	for i=1 to len(tview:col_list)
		tmp := oDict:getValue(tview:col_list[i])
		if empty(tmp)
			ret += __error([Object not found:]+tview:col_list[i])
			loop
		endif
		s2+=tmp:name+","
	next
	s2 := left(s2,len(s2)-1)
	ret += s+s+'columns="'+s2+'"'+n
	ret += s+'/>'+n

return ret
/**********************/
static function __exportTcol(oDict,tcol_id)
	local  s:="&\t&\t",n:="&\n",ret :=""
	local i,s2,tcol := oDict:getValue(tcol_id)
	if empty(tcol)
		ret += __error([Object not found:]+tcol_id)
		return ret
	endif
	ret += s+'<tcolumn name="'+tcol:name+'"'
	ret += s+'width="'+alltrim(str(tcol:width,5,0))+'"'+n
	ret += s+s+'header="'+tcol:header+'"'+n
	ret += s+s+'footer="'+tcol:footer+'"'+n
	ret += s+s+'expression="'+tcol:expr+'"'+n
	if !empty(tcol:depend_of)
		ret += s+s+'dependOf="'+tcol:depend_of+'"'+n
	endif
	if !empty(tcol:refs)
		s2 := ""
		for i=1 to len(tcol:refs)
			s2+=tcol:refs[i]+","
		next
		s2 := left(s2,len(s2)-1)
		ret += s+s+'refs="'+s2+'"'+n
	endif
	ret += s+'/>'+n
return ret
/**********************/
static function __exportCounter(oDict,counter_name)
	local  s:="&\t&\t",n:="&\n",ret :=""
	local tmp,tmp2
	tmp := oDict:select("COUNTER",,counter_name)
	if empty(tmp)
		ret += __error([Counter name not found:]+counter_name)
	else
		tmp2 := oDict:getValue(tmp[1])
		if empty(tmp2)
		ret += __error([Object not found:]+tmp[1])
		else
		ret += s+'<counter name="'+tmp2:name+'" type="'+tmp2:type+'" />'+n
		endif
	endif
return ret
/**********************/
static function __attrType2String(aType)
	local types := codb_info("CODB_ATTR_TYPES")
	local i,x, ret := "Bad type"

	i := ascan(types,{|x|x[1] == aType})
	if i<=0
		return ret
	endif
	ret := types[i][3]
return ret
/**********************/
static function __exportAttr(oDict,attr)
	local  s:="&\t&\t",ss:="&\t",n:="&\n",ret :=""
	local tmp,i,x,s2,s3:=""
	local m :={"ignore","rtrim","alltrim","fill"}

	ret += s+'<attribute name="'+attr:name+'"'+n
	ret += s+ss+'type="'+__attrType2String(attr:type)+'"'
	if attr:lentype > 0 .and. attr:lentype <= len(m)
		x := m [ attr:lentype ]
	else
		x := m[1]
	endif
	ret += ss+'lenType="'+x+'"'+n
	ret += s+ss+'len="'+alltrim(str(attr:len))+'"'
	ret += ss+ss+'dec="'+alltrim(str(attr:dec))+'"'+n
	ret += s+ss+'mask="'+attr:mask+'"'
	ret += s+ss+'defValue="'+attr:defvalue+'"'+n
	if !empty(attr:counter)
		ret += s+ss+'counter="'+attr:counter+'"'+n
	endif
	ret += s+ss+'notNull="'+iif(attr:not_null,"true","false")+'"'
	ret += s+'notEmpty="'+iif(attr:not_empty,"true","false")+'"'+n
	if !empty(attr:source)
		ret += s+ss+'source="'+var2str(attr:source)+'"'+n
	endif
	if !empty(attr:code)
		ret += s+ss+'code="'+var2str(attr:code)+'"'+n
	endif
	if !empty(attr:help)
		ret += s+ss+'help="'+var2str(attr:help)+'"'+n
	endif
	if !empty(attr:ref_to)
		s2 := left(attr:ref_to,codb_info('DICT_ID_LEN'))+':'
		tmp := __metagetValue(attr:ref_to)
		if empty(tmp)
			s3 += __error([Object not found:]+attr:ref_to)
		else
			s2+=tmp:name
		endif
		aadd(depends,{"component",strtran(s2,":","/")+".xml"})
		ret += s+ss+'refTo="'+s2+'"'+n
	endif
	ret += n+s+'/>'+n
	//ret += s+'>'+attr:name+'</attribute>'+n
	if !empty(s3)
		ret += s3
	endif
return ret
/**********************/
static function __exportIndex(oDict,idx)
	local  s:="&\t&\t",n:="&\n",ret :=""
	local tmp,i,s2,s3:=""

	ret += s+'<index name="'+idx:name+'"'
	ret += s+'expression="'+idx:expr+'"'
	ret += '/>'+n
return ret
/**********************/
static function __header(oDep,className,expr)
	local ret := ""
	ret+='<?xml version="1.0" encoding="'+host_charset()+'" ?>&\n'
	/*
	ret+='<?codb version="'+CODB_VERSION+'" knowledge="'+CODB_KNOWLEDGE+'"'
	ret+=' date="'+dtos(date())+'" time="'+time()+'" ?/>&\n'
	ret+='<?export from="'+getHostName()+'.'+getDomainName() +'" depository="'+oDep:id +'" classname="'+classname+'" expr="'+expr+'" ?/>&\n'
	*/
	ret+='&\n'
	ret+= '<component>'+'&\n'
return ret
static function __footer(oDep,className,expr)
	local ret := ""
	ret+= '</component>'+'&\n'
return ret
/**********************/
static function __error(s)
return  '<error decription="'+s+'"/>&\n'

/**********************/
static function __metaGetValue(cID)
	local oDict, dict_id:=left(cID,codb_info('DICT_ID_LEN'))
	oDict := codb_dict_reference(dict_id)
	if valtype(oDict) != "O"
		oDict := coDictionary():new(dict_id)
		if empty(oDict:error)
			oDict:open()
			if !empty(oDict:error)
				oDict:close()
				oDict := NIL
			endif
		else
			oDict := NIL
		endif
	endif
	if valtype(oDict) != "O"
		return  cId
	endif
return  oDict:getValue(cId)
/**********************/
static function __entityTran(str)
	local ret := str
	local j, e := {{"&amp;","&"},{"&gt;",">"},{"&lt;","<"}}

	for j=1 to len(e)
		ret := strtran(ret,e[j][2],e[j][1])
	next
return ret

