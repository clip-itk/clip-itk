/*
	install currency data
*/

local class_id,tmp,tmp1,buf
local hFile,ret := .t.,count:=0,tm
local dict,id
parameters oDep,fName

	dict:=oDep:dictionary()
	tmp:=dict:select("CLASS",0,"currency")
	class_id:=tmp[1]

	hFile := fopen(fName,0)
	if hFile<0
		? "Error open file:",fName
		return .f.
	endif

	tmp1:=map()
	? "Loading CURRENCY objects:"
	tm:=seconds()
	while !fileeof(hFile)
		buf:=filegetstr(hFile,1024)
		//? buf
		tmp:=split(buf,",")
		if len(tmp) < 7 .or. empty(tmp[1]).or. empty(tmp[2])
			loop
		endif
		tmp1:code := tmp[1]
		tmp1:unit := tmp[2]
		tmp1:name := tmp[5]
		tmp1:smallname := tmp[6]
		if !empty(id:=oDep:id4primaryKey(class_id,"code",tmp1:code))
			tmp1:id := id
			oDep:update(tmp1)
		else
			oDep:append(tmp1,class_id)
		endif
		if !empty(oDep:error)
			? "Error append object:",oDep:error
			ret:=.f.
			exit
		endif
		count++

	end
	tm:=seconds()-tm
	fClose(hFile)
	if ret
		?? "OK, loaded",alltrim(str(count)),"objects, time ",alltrim(str(tm)),"seconds"
		return count
	endif

return -1
