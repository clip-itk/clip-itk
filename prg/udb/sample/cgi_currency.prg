
//select currency from MY00101 where '01' $ code to idList
local obj,idlist,err,rname,dict,oCurr
errorblock({|err|error2html(err)})
?? "Content-type: text/html"
?
?
? '<HTML> <BODY> <pre>'
dep := coDepository():new("MY00101")
? "init depository", dep:error
? "open depository",dep:open(), dep:error
dict:=dep:dictionary()
classes:=dict:select("CLASS")
? "classes in dictionary:"
for i=1 to len(classes)
	? classes[i],":",dict:getValue(classes[i]):name
next
? seconds()
oCurr := dict:classBodyByName("currency")
currency := dep:select(oCurr:id)
? seconds()
? "currency count:",len(currency)
? "loading all currency objects"
for i=1 to len(currency)
	c := dep:getValue(currency[i])
	? c:code,":",c:name
next
? seconds()
? dep:close()
? "end"
? '</BODY> </HTML>'
?
return
