* sample for creating MY001 and append few objects
*
d:=codbList():new()
? "open dictionary list", d:error
list:=d:list()
for i=1 to len(list)
	? i, list[i]
next
? "Total",len(list),"dictionaries"
*
my001      := map()
my001:id   := "MY001"
my001:name := "my first dictionary"
my001:type := "DBF"
my001:path := "/home/"+getenv("USER")+"/codb/"+my001:id
if d:existId(my001:id)
	d:update(my001)
	? "updated MY001",d:error
else
	d:append(my001)
	? "added MY001",d:error
endif
*
list:=d:list()
for i=1 to len(list)
	? i, list[i]
next
? "Total",len(list),"dictionaries"
d:close()
*
? "Begin of dictionary methods demonstration"
* open dictionary MY001
oDict:=coDictionary():new("MY001")
if !empty(oDict:error)
   ? "Error:",oDict:error
   quit
endif
oDict:open()
if !empty(oDict:error)
   ? "Error:",oDict:error
   quit
endif
*
* create depository
depBody := map()
depBody:name := "depository1"
tmp:=oDict:select("DEPOSIT",,depBody:name)
if empty( tmp )
	dep_id := oDict:append(depBody,"DEPOSIT")
else
	dep_id := depBody:id := tmp[1]
	oDict:UPDATE(depBody)
endif
? tmp, dep_id, depBody:id
if !empty(oDict:error)
   ? "Error:",oDict:error
   quit
endif
? "depository added"
*
* create extent
extBody := map()
extBody:name := "statedep"
extBody:help := "information from state department of statistic"
tmp:=oDict:select("EXTENT",,extBody:name)
if empty(tmp)
	ext_id := oDict:append(extBody,"EXTENT")
else
	ext_id := extBody:id := tmp[1]
	oDict:update(extBody)
endif
? "extent 'statedep' added"
*
* create two attributes
attr:=map()
attr:name := "code"
attr:type := "C"
attr:len  := 7
attr:lentype := 3
tmp:=oDict:select("ATTR",,attr:name)
if empty(tmp)
	code_id := oDict:append(attr,"ATTR")
else
	code_id := attr:id := tmp[1]
	oDict:update(attr)
endif
? "attribute 'code' added"
*
attr:=map()
attr:name := "name"
attr:type := "C"
attr:len  := 20
attr:lentype := 2
tmp:=oDict:select("ATTR",,attr:name)
if empty(tmp)
	name_id := oDict:append(attr,"ATTR")
else
	name_id := attr:id := tmp[1]
	oDict:update(attr)
endif
? "attribute 'name' added"
*
* create two index
indBody := map()
indBody:name := "code"
indBody:expr := "code"
tmp:=oDict:select("INDEX",,indBody:name)
if empty(tmp)
	ind1_id := oDict:append(indBody,"INDEX")
else
	ind1_id := indBody:id := tmp[1]
	oDict:update(indBody)
endif
? "index 'code' added"
*
indBody := map()
indBody:name := "name"
indBody:expr := "name"
tmp:=oDict:select("INDEX",,indBody:name)
if empty(tmp)
	ind2_id := oDict:append(indBody,"INDEX")
else
	ind2_id := indBody:id := tmp[1]
	oDict:update(indBody)
endif
? "index 'name' added"
*
* create class CURRENCY
classBody:=map()
/* information about coding world currencies */
classBody:name := "currency"
/* from state department of statistic */
classBody:extent_id := ext_id
/* return via "USD:USA dollar" */
classBody:expr_essence := "code+':'+name"
/* two attributes "code" and "name" */
classBody:attr_list := {code_id,name_id}
/* two index "code" and "name" */
classBody:idx_list := {ind1_id,ind2_id}
tmp:=oDict:select("CLASS",,classBody:name)
if empty(tmp)
	currency_id := oDict:append(classBody,"CLASS")
else
	currency_id := classBody:id := tmp[1]
	oDict:update(classBody)
endif
if !empty(oDict:error)
   ? "Error:",oDict:error
   quit
endif
? "class 'currency' added"
oDict:close()
? "End of dictionary methods demonstration"
? "Begin of depository methods demonstration"
* open first depository from MY001
oDep:=coDepository():new("MY00101")
oDep:open()
oDict:=oDep:dictionary()
* get currency metadata
currBody:=oDict:classBodyByName("currency")
if empty(currBody)
   ? "Class 'currency' not found in dictionary"
   quit
endif
*this data may be load from txt or dbf source file
#ifdef ______0
data:={;
	{"001","USA dollar","USD","",""},;
	{"002","UUU dollar","UUU","",""},;
	{"003","Russian rubl","RUR","",""},;
	{"004","Ukraina rubl :)","RUA","",""};
      }
#else
data := loadFromFile("currency.txt")
#endif

* add currency objects
for i=1 to len(data)
	data[i][5] := oDep:id4primaryKey("currency","code",data[i][1])
next
tm := seconds()
for i=1 to len(data)
	obj:=map()
	obj:code := data[i][1]
	obj:name := data[i][2]
	obj:unit := data[i][3]
	obj_id := data[i][5] //oDep:id4primaryKey("currency","code",obj:code)
	if empty(obj_id)
		oDep:append(obj,currBody:id)
	else
		/* object exist in depository */
		obj:id := obj_id
		oDep:update(obj)
	endif
	if !empty(oDep:error)
		? "Error:",oDep:error
	else
		//? "currency object '"+obj:code+"' added to depository"
	endif
next
? "To depository added (updated) ",len(data)," objects in", alltrim(str(seconds()-tm))," sec"
c_list:=oDep:select(currBody:id,,,'code="01"')
? "Select currency objects with code='01':",c_list
c_list:=oDep:select(currBody:id)
//? "Select all currency objects:",c_list
? "Loading objects body:"
tm := seconds()
for i=1 to len(c_list)
	obj:=oDep:getValue(c_list[i])
//	? "code=",obj:code, "name=",obj:name
next
? "From depository loaded ",len(c_list)," objects in", alltrim(str(seconds()-tm))," sec"
? "End of depository methods demonstration"
?


static function loadFromFile(fname)
	local ret:={}
	local tmp,tmp1,buf, hFile

	hFile := fopen(fName,0)
	if hFile<0
		? "Error open file:",fName
		return .f.
	endif

	tmp1:=map()
	tm:=seconds()
	while !fileeof(hFile)
		buf:=filegetstr(hFile,1024)
		tmp:=split(buf,",")
		if len(tmp) < 7 .or. empty(tmp[1]).or. empty(tmp[2])
			loop
		endif
		aadd(ret,{tmp[1],tmp[5],tmp[2],tmp[6],""})
	end
	fClose(hFile)
return ret

