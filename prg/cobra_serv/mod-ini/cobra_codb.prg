parameters oIni

	local dList,List
	local dictId,dictList:={},oDicts:={}
	local depId,depList:={}, oDeps:={}
	local i,j,k,tmp,key
	local use_all := .f.

	i:=oIni:getValue("CODB","POLICY")
	if empty(i) .or. "ALL" $ upper(i)
		use_all := .t.
	endif

	i := oIni:sections()
	j := ascan(i,"CODB")
	if j<=0 /* not open CODB data */
		? "Warning:ini-file not have section CODB"
		return
	endif
	i := oIni:getValue("CODB","open_mode")
	if !empty(i)
		if left(upper(i),4)=="EXCL"
			set exclusive on
		else
			set exclusive off
		endif
	endif

	set translate path off
	set autopen on
	set deleted on
	rddsetdefault("DBFCDX")

	dList:=codbList():new()
	if val(dList:error)!=0
		? [Error open dictionaries list:]+dList:error
		?
		return
	endif

	list := dList:list()
	for i=1 to len(list)
		j := at(":",list[i])
		aadd(dictList,left(list[i],j-1))
	next
	? "Detected dictionaries:",dictList

	for i=1 to len(dictList)
		dictId := dictList[i]
		aadd(oDicts,NIL)
		? "Open dictionary:",dictId,""
		key := oIni:getValue("CODB",dictId)
		if use_all
			if !empty(key) .and. left(upper(key),2)=="DI" /* disabled */
				?? "disabled"
				loop
			endif
		else
			if empty(key) .or. !(left(upper(key),2)=="EN") /* enabled */
				?? "disabled"
				loop
			endif
		endif
		?? "opening "
		oDicts[i] := coDictionary():new(dictId)
		if !empty(oDicts[i]:error)
			?? oDicts[i]:error
			loop
		endif
		tmp := oDicts[i]:select("CLASS")
		for j=1 to len(tmp)
			oDicts[i]:loadPlugInses(tmp[j])
		next
		tmp := oDicts[i]:select("DEPOSIT")
		for j=1 to len(tmp)
			key := oDicts[i]:getValue(tmp[j])
			if empty(key)
				loop
			endif
			aadd(depList,dictId+key:number)
		next
		?? "OK"
	next
	? "Detected depositories:",depList
	for i=1 to len(depList)
		depId := depList[i]
		aadd(oDeps,NIL)
		? "Open depository:",depId,""
		key := oIni:getValue("CODB",depId)
		if use_all
			if !empty(key) .and. left(upper(key),2)=="DI" /* disabled */
				?? "disabled"
				loop
			endif
		else
			if empty(key) .or. !(left(upper(key),2)=="EN") /* enabled */
				loop
			endif
		endif
		?? "opening "
		oDeps[i] := coDepository():new(depId)
		if !empty(oDeps[i]:error)
			?? oDeps[i]:error
			loop
		endif
		oDeps[i]:open()
		if !empty(oDeps[i]:error)
			?? oDeps[i]:error
			loop
		endif
		oDeps[i]:extentOpenAll()
		if !empty(oDeps[i]:error)
			?? oDeps[i]:error
			loop
		endif
		?? "OK"
	next

return

