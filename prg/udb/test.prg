set date format to "dd/mm/yyyy"
set optimize on
set optimize level to 2
set exclusive off

oDep01 := coDepository():new("ACC0101","sdfsd")
oDep01:open()
oDict := oDep01:dictionary()
class:=oDict:classBodyByName("an_info2")
? class
//tmp:= oDep01:select(class:id,,,'account=="GBL02010008F" .and. an_level==1  .and. beg_date<=stod("20050119") .and. end_date>=stod("20050101")  .and. an_value1=="GBL0201015AS"')
tmp:= oDep01:select(class:id,,,'account=="GBL02010008F" .and. beg_date<=stod("20050119") .and. end_date>=stod("20050101")  .and. an_value1=="GBL0201015AS"')
//tmp:= oDep01:select(class:id)
? len(tmp),tmp
for i=1 to len(tmp)
	obj:=oDep01:getValue(tmp[i])
	? obj
next
?
return


? seconds()
tmp:=oDep01:getValue("ACC010101B2U")
? tmp
? '"'+tmp:owner_id+'"'
?
return
s:='account=="GBL02010006A" .and. odate>stod("20040802") .and. an_value1=="GBL02010000F" .and. an_value2=="" .and. an_value3=="" .and. an_value4=="" .and. an_value5=="" .and. an_value6=="" .and. an_public1=="" .and. an_public2==""'
//s:='account=="GBL02010006A" .and. odate>stod("20040802")'// .and. an_value1=="GBL02010000F" .and. an_value2=="" .and. an_value3=="" .and. an_value4=="" .and. an_value5=="" .and. an_value6=="" .and. an_public1=="" .and. an_public2==""'
tmp:= oDep01:select("ACC01000008I",,,s)
? tmp
? seconds()
?
return
/*
for i=1 to 3000
	//tmp:= oDep01:select(am_bal:id,,,s)
	tmp:= oDep01:select(am_bal:id)
	//outlog(__FILE__,__LINE__,oDep01:getValue(tmp[1]):account)
	//tmp:= oDep01:select(,,,,10)
next
? len(tmp)
? seconds()
?
return
*/
tmp:= oDep01:select(am_bal:id,,,s,10)
//tmp:= oDep01:select(am_bal:id)
for i=1 to 300
	for j=1 to len(tmp)
		tmp2 := oDep01:getValue(tmp[j])
		//oDep01:checkObjBody(tmp2,am_bal:id)
		//codb_info("CODB_ID_LEN")
		//oDep01:update(tmp2)
		//adel(tmp2,"ID")
		oDep01:append(tmp2,am_bal:id)
	next
next
? seconds()
?
return

/*
tmp:=oDict01:select("CLASS")
for i=1 to 10000
	for j=1 to len(tmp)
		tmp2 := oDict01:getValue(tmp[j])
	next
next
? len(tmp),seconds()
?
return
*/

/*
name :="c"
oDep02 := coDepository():new("GBL0201","sdfsd")
oDep02:open()
oDict02 := oDep02:dictionary()
oDep03 := coDepository():new("ACC0101","sdfsd")
oDep03:open()
oDict03 := oDep03:dictionary()
empl := oDict03:classBodyByName("employee")
obj:=map()
obj:empl_name := name
obj:id := oDep03:append(obj,empl:id)
? obj:id,oDep03:error
man := oDict02:classBodyByName("man")
//? "man=",man
obj2:=map()
obj2:name := name
obj2:employee := obj:id
obj2:id := oDep02:append(obj2,man:id)
? obj2:id,obj2:employee,oDep02:error
obj3:=oDep03:getValue(obj:id)
? obj3:id,obj3:man,oDep03:error

?
return
*/

/*
oDep := coDepository():new("GBL0101","sdfsd")
oDep:open()
oDict := oDep:dictionary()
//oDict := coDictionary():new("GBL01")
//oDict:open()
? oDict:user
? "b1",codb_openLog()
o:=map()
o:id := "LOG04010010"
? "b2",codb_outLog("asdas","add",o)
?
return
*/

/*
dict:=d:connect("GBL01")
? "open dictionary",dict:open(), dict:error
dep := coDepository():new("GBL0101")
//dep := codb_depDbfNew(dict,"01")
? "open depository",dep:open(), dep:error
//dict:=dep:dictionary()
classes:=dict:select("CLASS")
? "classes in dictionary:"
for i=1 to len(classes)
	? classes[i],":",dict:getValue(classes[i]):name
next
? seconds()
currency := dep:select("GBL01000000R")
? seconds()
? "currency count:",len(currency)
? "loading all currency objects"
for i=1 to len(currency)
	c := dep:getValue(currency[i])
next
? seconds()
for i=1 to len(currency)
	c := dep:getValue(currency[i])
next
? seconds()
? dep:close()
? dict:close()
? d:close()
? "end"
?
return
*/



/*
oDep:=coDepository():new("ACC0101")
oDep:open()
oDict:=oDep:dictionary()
class:=oDict:classBodyByName("os_balance")
? class:id
tmp:=oDep:select("ACC01000002H",1,,'account=="GBL02010000A"')
? tmp,""
tmp2:=oDep:getValue(tmp[1])
? tmp2:class_id,tmp2:account,tmp2:odate
tmp:=oDep:select("ACC01000002H",1,,'account=="GBL02010000A" .and. odate<stod("20021003")')
? tmp
tmp:=oDep:select("ACC01000002H",,,'account=="GBL02010000A" .and. odate<stod("20021003")')
? tmp
//tmp:=oDep:select(class:id,1,,'account=="GBL02010000A" .and. an_value="" .and. odate<stod("20021003")')
//? tmp
?
return
*/


/*
idList:=codb_oql_select("shop_section","GBL0201")
? len(idList:aId)
? idList:getValue()
? idList:locate("code='01'")
? idList:getValue()
? idList:skip()
? idList:locateRest()
? idList:getValue()
? idList:skip()
? idList:locateRest("code='01'")
? idList:getValue()
?
return
*/

/*
odep:=coDepository():new("GBL0101")
odep:open()
odict:=odep:dictionary()
country := oDict:classBodyByName("country")
? country
tmp:=Odep:select(country:id)
? tmp[1]
obj := oDep:getValue(tmp[1])
? obj
? country:essence(obj)
? "end"
?
return
*/

/*
odep:=coDepository():new("ETC0101")
odep:open()
odict:=odep:dictionary()
class:=oDict:classBodyByName("acc_component")
//idList:=oDep:idList(class:id,1,,"!empty(owner_id)")
//idList:=oDep:idList(class:id,1)
//? idList:aId
? class:id
//idList:=oDep:idList(class:id,1,,"!empty(owner_id)")
//? idList:aId
idList:=oDep:select(class:id,,,'code=="trade"')
? idList
? oDep:getValue(idList[1])
?
return

idList:=oDep:select(class:id,,,"!empty(owner_id)")
? idList
idList:=oDep:select(class:id,,,'!(owner_id=="")')
? idList
idList:=oDep:select(class:id,,,"empty(owner_id)")
? len(idList)
? oDep:getValue(idList[1]):owner_id
? oDep:getValue(idList[2]):owner_id
? oDep:getValue(idList[3]):owner_id
//idList:=oDep:idList(class:id,1,,"!empty(owner_id")
//? idList:aId
?
return
*/
/*
? "-2",oDep:id4PrimaryKey("man","firm_no",val("    -2"))
? "-3",oDep:id4PrimaryKey("man","firm_no",val("    -3"))
?
return

u:=odict:classBodyByName("units")
? odep:select(u:id,,,,2)
? odep:select(u:id,,,,-2)
? odep:select(u:id,,,,1)
? odep:select(u:id,,,,-1)
?
return
? "003",oDep:id4PrimaryKey("units","code","003")
? "004",oDep:id4PrimaryKey("units","code","004")
? "050",oDep:id4PrimaryKey("units","code","050")
? "051",oDep:id4PrimaryKey("units","code","051")
?
return
*/


/*
set exclusive off
set optimize on
oDep:=coDepository():new("GBL0201")
oDep:open()
oDict:=oDep:dictionary()
class:=oDict:classBodyByName("firm")
tmp := oDep:select(class:id)
? len(tmp)
tm:=seconds()
for i=1 to len(tmp)
	obj:=oDep:getValue(tmp[1])
next
? seconds()-tm
?
return

tmp:=oDep:select("ACC010000027",1,,'account=="GBL02010000B" .and. odate>=stod("20020821") .and. odate<=stod("20020821")')
? "a",len(tmp),tmp
tmp:=oDep:select("ACC010000027",,,'account=="GBL02010000B" .and. odate>=stod("20020821") .and. odate<=stod("20020821")')
? "b",len(tmp),tmp
set optimize off
tmp:=oDep:select("ACC010000027",1,,'account=="GBL02010000B" .and. odate>=stod("20020821") .and. odate<=stod("20020821")')
? "c",len(tmp),tmp
tmp:=oDep:select("ACC010000027",,,'account=="GBL02010000B" .and. odate>=stod("20020821") .and. odate<=stod("20020821")')
? "d",len(tmp),tmp

?
return

d:=codbList():new()
? "open dictionary list",d, d:error
dict:=d:connect("GBL01")
? "open dictionary",dict:open(), dict:error
dep := coDepository():new("GBL0101")
//dep := codb_depDbfNew(dict,"01")
? "open depository",dep:open(), dep:error
//dict:=dep:dictionary()
classes:=dict:select("CLASS")
? "classes in dictionary:"
for i=1 to len(classes)
	? classes[i],":",dict:getValue(classes[i]):name
next
? seconds()
currency := dep:select("GBL01000000R")
? seconds()
? "currency count:",len(currency)
? "loading all currency objects"
for i=1 to len(currency)
	c := dep:getValue(currency[i])
next
? seconds()
for i=1 to len(currency)
	c := dep:getValue(currency[i])
next
? seconds()
? dep:close()
? dict:close()
? d:close()
? "end"
?
return
*/
