#include "r2d2lib.ch"


function r2d2_classes_rdf()
	local m1:={"GBL01","GBL02","ACC00","ACC01","ETC01"}
	local m2:={"Global","Common","Personnel department","Accounting","Settings"}

	cgi_xml_header()
//	put_rdf(m1,m2)
	put_tree(m1,m2)
return

******************
static function put_rdf(m1,m2)
	local oDict, dname:="docum"
	local s := space(15)
	local i,j,k,list,class,col,rname
	local aDicts := {}

	? '<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'
	? 'xmlns:DOCUM="http://itk.ru/aquarum/rdf#">'
	?

	for i=1 to len(m1)
		oDict := codb_dict_reference(m1[i])

		if empty(oDict)
			loop
		endif

		? '<RDF:Description about="urn:'+dname+':'+m1[i]+'">'
		? ' <DOCUM:firstname>'+m2[i]+'</DOCUM:firstname>'
		? ' <DOCUM:lastname>'+m1[i]+'</DOCUM:lastname>'
		? ' <DOCUM:typename>dictionary</DOCUM:typename>'
		? '</RDF:Description>'
		list := oDict:select("CLASS")
		for j=1 to len(list)
			class := oDict:getValue(list[j])
			if empty(class) .or. class:name=="void"
				loop
			endif
			col := NIL
			k:=oDict:select("TCOLUMN",,class:name)
			if !empty(k)
				col := oDict:getValue(k[1])
			endif
			rname := iif( empty(col), class:name, col:header)

			? '   <RDF:Description about="urn:'+dname+':'+m1[i]+':'+class:id+'">'
			? '      <DOCUM:firstname>'+rname+'</DOCUM:firstname>'
			? '      <DOCUM:lastname>'+class:name+'</DOCUM:lastname>'
			? '      <DOCUM:typename>'+class:id+'</DOCUM:typename>'
			? '   </RDF:Description>'
		next
	next
	? ''
	? ''
	? ''
	? '<RDF:Seq about="urn:'+dname+'">'
	? '<RDF:li>'
	for i=1 to len(m1)
		oDict := codb_dict_reference(m1[i])
		if empty(oDict)
			loop
		endif

		? '<RDF:Seq about="urn:'+dname+':'+m1[i]+'">'
		list := oDict:select("CLASS")
		for j=1 to len(list)
			class := oDict:getValue(list[j])
			if empty(class) .or. class:name=="void"
				loop
			endif
		 //	? '   <RDF:seq about="urn:'+dname+':'+class:id+'"/>'
			? '   <RDF:li resource="urn:'+dname+':'+m1[i]+':'+class:id+'"/>'
		next
		? '</RDF:Seq>'
	next
	? '</RDF:li>'
	? '</RDF:Seq>'
	? '</RDF:RDF>'
?
return


******************
static function put_tree(m1,m2)
local i, oDict

	?
	? '<classes '
	? 'xmlns="http://itk.ru">'



	for i=1 to len(m1)
		oDict := codb_dict_reference(m1[i])

		? '   <dictionary id="'+m1[i]+'" label="'+m2[i]+'">'

		put_classes(oDict)

		? '   </dictionary>'

	next
	? '</classes>'
?
return

***********************************
static function put_classes(oDict)
	local s := space(15)
	local i,j,k,list,class,col,rname

	list := oDict:select("CLASS")
	for i=1 to len(list)
		class := oDict:getValue(list[i])
		if empty(class) .or. class:name=="void"
			loop
		endif
		col := NIL
		k:=oDict:select("TCOLUMN",,class:name)
		if !empty(k)
			col := oDict:getValue(k[1])
		endif
		rname := iif( empty(col), class:name, col:header)
		? s+'<class id="'+class:id+'" label="'+rname+'" name="'+class:name+'"/>'
	next
return

