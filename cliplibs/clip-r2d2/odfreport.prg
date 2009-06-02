#include "r2d2lib.ch"
#include "fileio.ch"

function r2d2_odfreport(_queryArr)

local err, _query, connect_id
local data,file:="",c_type:="",locale:=""
local prg1:="", prg2:="", par1:={}, par2:={}
local i,j,s1,s2

	errorblock({|err|error2html(err)})

	set translate path off

	_query:=d2ArrToMap(_queryArr)
	outlog(__FILE__,__LINE__, _query)

	if "CONNECT_ID" $ _query
		connect_id := _query:connect_id
	endif

	if "FILE" $ _query
		file := _query:file
	endif
	if "LOCALE" $ _query
		locale := _query:locale
	endif
	if "PRG1" $ _query
		prg1 := _query:prg1
	endif
	if "PRG2" $ _query
		prg2 := _query:prg2
	endif

	for i=1 to 9
		s1 := "P1"+str(i,1,0)
		s2 := NIL
		if s1 $ _query
			s2 := _query[s1]
		endif
		aadd(par1,s2)
	next
	for i=1 to 9
		s1 := "P2"+str(i,1,0)
		s2 := NIL
		if s1 $ _query
			s2 := _query[s1]
		endif
		aadd(par2,s2)
	next

	if empty(file)
		?? "Content-type: text/html"
		?
		?
		? "Error: bad parameters ! "
		? "Usage:"
		? "    odfreport?file=<file_name>;prg1=;p11=;p12=;...;prg2=;p21=;p22=..."
		?
		return
	endif
//	c_type = get_contentType(file)

	?? "Content-type: application/vnd.oasis.opendocument.spreadsheet"
	//?? "Content-type: application/xml"//+c_type
	?
	data = odf_make_report(file,prg1,par1,prg2,par2)
	
return
*******************
static function odf_make_report(file,prg1,par1,prg2,par2)
	local eBlock, data
	local i, j, x, y
	local tPath, fname
	local cmd,out:=space(0), err:=space(0)
	local bl1,bl2,pars1,pars2
	tPath := PATH_DELIM+"tmp"+PATH_DELIM+"r2d2"+;
		PATH_DELIM+"odfreport"+PATH_DELIM+alltrim(str(pid()))
		
	if !makeDirectory(tPath)
		data:="<error>Can`t create tmp directory."+tPath+"</error>"
		return data
	endif
	x := split(file, "/")
	fName:=x[len(x)]

	cmd := 'cp '+file+" "+tPath
	cmd += "; cd "+tPath
	cmd += '; unzip -x '+fname
	cmd += '; rm -f '+fname
	
	outlog(__FILE__,__LINE__, cmd) 	
	syscmd(cmd,"",@out,@err)
	if !empty(err)
		data:="<error>"+err+"</error>"
		return data
	endif

	eBlock := errorBlock({ |err| break(err) })
	begin sequence
			bl1 := loadBlock(prg1+".po")
			bl2 := loadBlock(prg2+".po")
	recover
	end sequence
	errorBlock(eBlock)

	if !empty(bl1)
		x := evala(bl1,par1)
		
	endif
	/*
	if !empty(bl2)
		pars2 := aclone(par2)
		aadd(pars2,"")
		ains(pars2,1)
		pars2[1] = x
		y := evala(bl2,pars2)
		
	endif
	*/	
	data := memoread(tPath+PATH_DELIM+"content.xml")
outlog(__FILE__,__LINE__, tPath+PATH_DELIM+"content.xml")	
	if empty(data)
		data:="<error>file not found:"+tPath+PATH_DELIM+"content.xml </error>"
		return data
	endif

	i := at("<office:spreadsheet>",data)
	j := at("</office:spreadsheet>",data)

	if y==NIL
	    y:=""
	endif
//	data := substr(data,1,i+19)+CRLF+y+CRLF+substr(data,j)

	data := substr(data,1,i+19)+x+substr(data,j)
	memowrit(tPath+PATH_DELIM+"content",data)



	cmd := " cd "+tPath
	cmd += "; iconv -f koi8-r -t utf-8 -o content.xml content"
	cmd += "; rm content"
	cmd += "; zip -r "+fname+" *"
outlog(__FILE__,__LINE__, cmd)
	syscmd(cmd,"",@out,@err)
	if !empty(err)
		data:="<error>"+err+"</error>"
		return data
	endif
outlog(__FILE__,__LINE__, tPath+PATH_DELIM+fname)
	data := memoread(tPath+PATH_DELIM+fname)
	if empty(data)
		data:="<error>file not found:"+tPath+PATH_DELIM+fname+" </error>"
		return data
	endif



	cmd := " rm -rf "+tPath
outlog(__FILE__,__LINE__, cmd)	
//	syscmd(cmd,"",@out,@err)
	if !empty(err)
		data:="<error>"+err+"</error>"
		return data
	endif

return data

