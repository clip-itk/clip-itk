local i,data,oDict,mKeys,sKey
local recno
parameters oWin,oIdList
	oWin:put("Card report of:"+oIdlIst:metaname)
	oWin:newLine()
	oWin:put("Current object identification:"+oIdlIst:currId)
	oWin:newLine()
	oWin:put(replicate("-",80))

	oDict:=oIdList:dictionary()
	data:=oIdList:getInfo()
	mkeys:=mapkeys(data)
	oWin:newLine()
	for i=1 to len(mKeys)
		oWin:put(padr(oDict:hashName(mKeys[i]),20,"."))
		oWin:put(data[mKeys[i]])
		oWin:newLine()
	next

	oWin:put(replicate("-",80))
	oWin:newLine()
	oWin:put("List of all names :")
	oWin:newLine()
	oWin:put(replicate("-",80))
	oWin:newLine()

	recno := oIdList:recno()
	oIdList:gotoTop()
	while !oIdList:eof()
		oWin:put(oIdList:getValue("NAME"))
		oWin:newLine()
		oIdList:skip()
	enddo
	oIdList:goto(recno)

return .t.

