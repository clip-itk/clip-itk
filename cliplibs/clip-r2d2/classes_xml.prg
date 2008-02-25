#include "r2d2lib.ch"

function r2d2_classes_xml(flag)

	local m1:={"ACC01","ACC00","GBL02","GBL01","ETC01"}
	local m2:={"Глобальные","Общие","Отдел кадров","Бухгалтерские","Настройки"}
	local i
	//local meta:= {"tcolumn","attr","class","index","deposit","extent","plugins","counter"}

	if  flag =='cls3'
			?? "Content-type: application/x-javascript;charset="+host_charset()
			?
			for i=1 to len(m1)
				put_json(m1[i],m2[i])
			next
			?
			?? 'ATTRIBUT["id"]={id:"", name:"id", label:"ID",datatype:"C",datalen:"12",datadec:"0",datamask:"",dataisindex:true,defvalue:"",dataRefTo:""};'
	elseif flag == 'cls2'
			cgi_xml_header()
			? '<metadata>'
			for i=1 to len(m1)
				put_xml(m1[i],m2[i])
			next
	    ? '</metadata>'	
	elseif flag == 'cls4'
			?? "Content-type: application/x-javascript;charset="+host_charset()
			?
			for i=1 to len(m1)
				put_json2(m1[i])
			next
			?

	endif

return


static function put_json2(m1,m2)
	
	local i, oDict, list, class2, atrib, tcol, index2, extent,counter
	local j,tmp
	oDict := codb_dict_reference(m1)
	if empty(oDict)
		return
	endif

	list := oDict:select("CLASS")
	for i=1 to len(list)
		class2 := oDict:getValue(list[i])
			? 'CLASS["'+class2:id+'"]={id:"'+class2:id
			?? '",name:"'+class2:name
			?? '",expr_essence:"'+class2:expr_essence
			?? '",super_id:"'+class2:super_id
			?? '",unique_key:"'+class2:unique_key
			?? '",extent_id:"'+class2:extent_id
			?? '",idx_list:['
				tmp := class2:idx_list
				for j=1 to len(tmp)
					?? iif(j==1,'',',')+'"'+tmp[j]+'"'
				next
			?? '], tcol_list:['
				tmp := class2:tcol_list
				for j=1 to len(tmp)
					?? iif(j==1,'',',')+'"'+tmp[j]+'"'
				next
			??'], attr_list:['
				tmp := class2:attr_list
				for j=1 to len(tmp)
					?? iif(j==1,'',',')+'"'+tmp[j]+'"'
				next
	    ??']};'
	next

	list := oDict:select("ATTR")
	for i=1 to len(list)
		atrib := oDict:getValue(list[i])
		? 'ATTRIBUT["'+atrib:id+'"]={id:"'+atrib:id
		?? '",name:"'+atrib:name
		?? '",type:"'+atrib:type
		?? '",lentype:'+alltrim(str(atrib:lentype))
		?? ',len:'+alltrim(str(atrib:len))
		?? ',dec:'+alltrim(str(atrib:dec))
		?? ',mask:"'+atrib:mask
		?? '",counter:"'+atrib:counter
		?? '",defvalue:"'+atrib:defvalue
		?? '",ref_to:"'+atrib:ref_to+'"};'
	next

	list := oDict:select("TCOLUMN")
	for i=1 to len(list)
		tcol := oDict:getValue(list[i])
		? 'TCOLUMN["'+tcol:name+'"]={name:"'+tcol:name
		?? '",header:"'+tcol:header
		?? '",width:'+alltrim(str(tcol:width))
		?? ',expr:"'+tcol:expr
		??'"};'
	next

	list := oDict:select("INDEX")
	for i=1 to len(list)
		index2 := oDict:getValue(list[i])
		? 'INDEX["'+index2:id+'"]={name:"'+index2:name
		?? '",expr:"'+index2:expr
		??'"};'
	next

	list := oDict:select("EXTENT")
	for i=1 to len(list)
		extent := oDict:getValue(list[i])
		? 'EXTENT["'
		?? extent:id
		?? '"]={name:"'
		?? extent:name
		??'"};'
	next

	list := oDict:select("counter")
	for i=1 to len(list)
		counter:= oDict:getValue(list[i])
		? 'COUNTER["'
		?? counter:name
		?? '"]={name:"'
		?? counter:name
		?? '",type:"'
		?? counter:type
		??'"};'
	next

	?
return

******************
static function put_json(m1,m2)
	
	local i,oDict,list,class2
	local tColumns,tIndexes
	local j,tmp,col,atrib
	oDict := codb_dict_reference(m1)
	if empty(oDict)
		return
	endif


	tcolumns := map()
	tindexes := map()
	make_tcolumns(oDict,tcolumns)
	make_indexes(oDict,tIndexes)


	list := oDict:select("CLASS")
	for i=1 to len(list)
		class2 := oDict:getValue(list[i])
			? 'CLASS["'+class2:id+'"]={id:"'+class2:id+'",name:"'+class2:name+'",label:"'+iif( class2:name $ tColumns, tColumns[class2:name]:header, class2:name)
			??'",unique_key:"'+ iif('unique_key' $ class2, class2:unique_key,'')+'",'
			??'attr_list:['
			tmp := class2:attr_list
			for j=1 to len(tmp)
				?? iif(j==1,'',',')+'"'+tmp[j]+'"'
	    next
	    ??']};'
	next


	list := oDict:select("ATTR")
	for i=1 to len(list)
		atrib := oDict:getValue(list[i])
		? 'ATTRIBUT["'+atrib:id+'"]={id:"'+atrib:id+'", name:"'+atrib:name
		?? '",label:"'+iif( atrib:name $ tColumns, tColumns[atrib:name]:header, atrib:name)
		?? '",datatype:"'+atrib:type
		?? '",datalen:"'+iif( atrib:name $ tColumns, alltrim(toString(tColumns[atrib:name]:width)), "12")
		?? '",datadec:"'+alltrim(str(atrib:dec))+'",datamask:"'+atrib:mask
		?? '",dataisindex:'+iif(atrib:name $ tIndexes,'true' , 'false')
		?? ',defvalue:"'+atrib:defvalue+'",dataRefTo:"'+atrib:ref_to+'"};'
	next


	list := oDict:select("TVIEW")
	for i=1 to len(list)
		tmp := oDict:getValue(list[i])
		? 'TVIEW["'+tmp:name+'"]={id:"'+tmp:id+'", tcol_list:['				
		for j=1 to len(tmp:col_list)
    		    col := oDict:getValue(tmp:col_list[j]) 
		    if !empty(col)
			?? iif(j==1,'',',')+'"'+col:name+'"'
		    endif
		next
		??']};'
	next
	
	?
return



******************
static function put_xml(m1,m2)
	local i,oDict,list,class
	local tColumns,tIndexes

	oDict := codb_dict_reference(m1)
	if empty(oDict)
		return
	endif

	tcolumns := map()
	tindexes := map()
	make_tcolumns(oDict,tcolumns)
	make_indexes(oDict,tIndexes)
	? '<dictionary id="'+m1+'" name="'+m2+'">'

	list := oDict:select("CLASS")
	for i=1 to len(list)
		class := oDict:getValue(list[i])
		if empty(class) .or. class:name=="void"
			loop
		endif
		//put_class(oDict,class,tColumns)
		put_class2(oDict,class,tColumns,tIndexes)
	next

	? '</dictionary>'
	? '<!-- ************************* end of "'+m1+'" -->'
	?
return
**************************
static function make_tcolumns(oDict,tColumns)
	local i,tmp,col
	tmp := oDict:select("TCOLUMN")
	for i=1 to len(tmp)
		col := oDict:getValue(tmp[i])
		if empty(col)
			loop
		endif
		tColumns[col:name] := col
	next
return
**************************
static function make_indexes(oDict,tIndexes)
	local i,tmp,col
	tmp := oDict:select("INDEX")
	for i=1 to len(tmp)
		col := oDict:getValue(tmp[i])
		if empty(col)
			loop
		endif
		tIndexes[col:expr] := col
	next
return

**************************
static function put_class2(oDict,class,tColumns,tIndexes)
	local i,j,k,l,tmp,s1:="&\t",s2:="&\t&\t"
	local columns,col,attr,nIndex,lIndex
	local attr_list,oEmp,tmp2,attrEmp
	//columns := cgi_make_columns(oDict,class:name)
	//if empty(columns)
	//	cgi_xml_error("Empty table description for "+class)
	//	return
	//endif
	if "UNIQUE_KEY" $ class
	else
		class:unique_key := ""
	endif
	j := iif( class:name $ tColumns, tColumns[class:name]:header, class:name)
	? s1+'<class id="'+class:id+'" name="'+class:name+'" label="'+j+'" unique_key="'+class:unique_key+'">'

#ifdef ___1
	columns := cgi_make_columns(oDict,class:name)
	for i=1 to len(columns)
		attr := columns[i]
		col := iif( attr:name $ tColumns, tColumns[attr:name]:header, map())
		//? s2+'<attribute id="'+attr:id+'" '
		? s2+'<attribute id="'+attr:attr_id+'" '
		? s1+s2+'name="'+attr:name+'" '
		? s1+s2+'label="'+iif(!empty(col),col,attr:name)+'" '
		if "DATALEN" $ attr
			? s1+s2+'datalen="'+alltrim(toString(attr:datalen))+'" '
			? s1+s2+'datadec="'+alltrim(toString(attr:datadec))+'" '
			? s1+s2+'datatype="'+attr:datatype+'"'
			? s1+s2+'datamask="'+attr:datamask+'"'
			? s1+s2+'dataisindex="'+iif( !empty(attr:isIndex),"true","false")+'"'
		endif
		if "DEFVALUE" $ attr
			? s1+s2+'defvalue="'+toString(attr:defvalue)+'"'
		endif
		if "REFS" $ attr .and. !empty(attr:refs)
			k:=""
			for j=1 to len(attr:refs)
			    k+=attr:refs[j]+","
			next
			k := left(k,len(k)-1)
			? s1+s2+'dataRefTo="'+k+'"'
		else
			if "DATAREFTO" $ attr
				? s1+s2+'dataRefTo="'+attr:dataRefTo+'"'
			endif
		endif
		? s2+'/>'
	next


#else
	oEmp := oDict:padrBody(map(),class:id,.t.)
	attr_list := class:attr_list
	for i=1 to len(attr_list)
		attr := oDict:getValue(attr_list[i])
		if empty(attr)
			outlog(__FILE__,__LINE__, "can`t load attribute description:",attr_list[i],class:name)
			loop
		endif
		col := iif( attr:name $ tColumns, tColumns[attr:name]:header, map())
		? s2+'<attribute id="'+attr:id+'" '
		? s1+s2+'name="'+attr:name+'" '
		? s1+s2+'label="'+iif(!empty(col),col,attr:name)+'" '
		? s1+s2+'datalen="'+alltrim(toString(attr:len))+'" '
		? s1+s2+'datadec="'+alltrim(toString(attr:dec))+'" '
		? s1+s2+'datatype="'+attr:type+'"'
		? s1+s2+'datamask="'+attr:mask+'"'
		lIndex := attr:name $ tIndexes
		nIndex := iif(lIndex,tIndexes[attr:name]:id,"")
		if !empty(nIndex)
			nIndex := ascan(class:idx_list,nIndex)
		endif
		? s1+s2+'dataisindex="'+iif( !empty(nIndex),"true","false")+'"'
		if "DEFVALUE" $ attr
			tmp2 := upper(attr:name)
			attrEmp := ""
			if tmp2 $ oEmp
				attrEmp := toString(oEmp[tmp2])
				l := len(attrEmp)
				if (attr:type $ "SR" )
					attrEmp := attr:defvalue
				endif
				if l > 0
					attrEmp := padr(attrEmp,l)
				endif
			endif
			? s1+s2+'defvalue="'+attrEmp+'"'
		endif
		if "REFS" $ attr .and. !empty(attr:refs)
			k:=""
			for j=1 to len(attr:refs)
			    k+=attr:refs[j]+","
			next
			k := left(k,len(k)-1)
			? s1+s2+'dataRefTo="'+k+'"'
		else
//			if "DATAREFTO" $ col
				? s1+s2+'dataRefTo="'+attr:Ref_To+'"'
//			endif
		endif
		? s2+'/>'
	next
	? s2+'<attribute id="'+class:id+'idattr" '
	? s1+s2+'name="id" '
	? s1+s2+'label="id" '
	/*
	? s1+s2+'datalen="'+alltrim(str(codb_info("CODB_ID_LEN")))+'" '
	? s1+s2+'datatype="C"'
	? s1+s2+'datamask=""'
	? s1+s2+'dataRefTo=""'
	*/
	? s2+'/>'
#endif

	? s1+'<tcol_list value="'
	if "TCOL_LIST" $ class
		tmp:=varToString( class:tcol_list,,, .f.)
		tmp := strtran(substr(tmp,2,len(tmp)-2),'"',"")
		?? tmp
	endif
	?? '"/>'
	? s1+'</class>'
return

**************************
static function put_class(oDict,class,tColumns)
	local i,j,k,s1:="&\t",s2:="&\t&\t"
	local columns,col
	columns := cgi_make_columns(oDict,class:name)
	if empty(columns)
//		cgi_xml_error("Empty table description for "+class)
		return
	endif
	j:=class:name
#ifdef _____1
	k := oDict:select("TCOLUMN",,class:name)
	if !empty(k)
		k := oDict:getValue(k[1])
		if !empty(k)
			j := k:header
		endif
	endif
#else
	if class:name $ tColumns
		j := tColumns[class:name]:header
	endif
#endif
	if "UNIQUE_KEY" $ class
	else
		class:unique_key := ""
	endif
	? s1+'<class id="'+class:id+'" name="'+class:name+'" label="'+j+'" unique_key="'+class:unique_key+'">'
	for i=1 to len(columns)
		col:=columns[i]
		? s2+'<attribute id="'+col:id+'" '
		? s1+s2+'name="'+col:name+'" '
		? s1+s2+'label="'+col:header+'" '
		if "DATALEN" $ col
			? s1+s2+'datalen="'+alltrim(toString(col:datalen))+'" '
			? s1+s2+'datatype="'+col:datatype+'"'
			? s1+s2+'datamask="'+col:datamask+'"'
			? s1+s2+'dataisindex="'+iif(col:isindex,"true","false")+'"'
		endif
		if "DEFVALUE" $ col
			? s1+s2+'defvalue="'+toString(col:defvalue)+'"'
		endif
		if "REFS" $ col .and. !empty(col:refs)
			k:=""
			for j=1 to len(col:refs)
			    k+=col:refs[j]+","
			next
			k := left(k,len(k)-1)
			? s1+s2+'dataRefTo="'+k+'"'
		else
			if "DATAREFTO" $ col
				? s1+s2+'dataRefTo="'+col:dataRefTo+'"'
			endif
		endif
		? s2+'/>'
	next
	? s1+'</class>'
return

