***********************
function cgi_an_make_data(beg_date,end_date,oDep,account,an_values,an_level)
	local oDict,an_info,an_info2,an_balance,osb_class,anb_list:=map()
	local as,as1,s:="",s0,s1,s2,obj,aObj,tObj,tmp,data:={}
	local i,j,k,x,y,z,itogCel,aOst:={}
	local max_date,min_date,variants
	local an_obj,class,cId,tmpDict,tcol,tcol_list,err
	local classes:=map(), tCols := map()

	oDict := oDep:dictionary()
	an_info := oDict:classBodyByName("an_info")
	if empty(an_info)
		outlog("Error: class AN_INFO not found in ACC01")
		return data
	endif
	an_info2 := oDict:classBodyByName("an_info2")
	if empty(an_info2)
		outlog("Error: class AN_INFO2 not found in ACC01")
		return data
	endif
	if an_level <= 1
		an_balance := oDict:classBodyByName("an_balance")
		if empty(an_balance)
			outlog("Error: class AN_BALANCE not found in ACC01")
			return data
		endif
	else
		an_balance := oDict:classBodyByName("am_balance")
		if empty(an_balance)
			outlog("Error: class AM_BALANCE not found in ACC01")
			return data
		endif
	endif

	s := 'account=="'+account+'"'
	//s2:= '.and. beg_date>=stod("'+dtos(end_date)+'") .and. end_date>=stod("'+dtos(beg_date)+'") '
	s2:= '.and. end_date>=stod("'+dtos(beg_date)+'") '
	//s2:= '.and. beg_date>=stod("'+dtos(beg_date)+'") '
	//outlog(__FILE__,__LINE__,an_level,an_values)
	if an_level>1 .and. !empty(an_values[an_level-1])//.and. an_values[an_level-1] != NIL
		s1:= '.and. an_level=='+alltrim(str(an_level-1,2,0))+' '
		s1+= '.and. an_value1=="'+an_values[an_level-1]+'" '
		tmp:=oDep:select(an_info2:id,,,s+s1+s2)
		//outlog("an_values=",an_values,s)
		//outlog("an_info",s+s1+s2,tmp)
		for i=1 to len(tmp)
			obj:=oDep:getValue(tmp[i])
			if empty(obj)
				outlog("Error: can`t load object:",tmp[i])
				loop
			endif
			anb_list[obj:an_value2] := obj:an_value2
		next
	else
		s1:= '.and. an_level=='+alltrim(str(an_level,2,0))+' '
		tmp:=oDep:select(an_info:id,,,s+s1+s2)
		//outlog("an_values=",an_values,s)
		//outlog("an_info",s+s1+s2,tmp)

		for i=1 to len(tmp)
			obj:=oDep:getValue(tmp[i])
			if empty(obj)
				outlog("Error: can`t load object:",tmp[i])
				loop
			endif
			anb_list[obj:an_value] := obj:an_value
		next
	endif
	//outlog("anb_list=",anb_list)

	variants := calc_variants(oDep,account,an_level,beg_date,end_date,an_values,anb_list)
	//outlog("variants =",variants)
	for i=1 to len(variants)
		j := calc_summ(oDep,an_balance,account,an_level,beg_date,end_date,variants[i])
		//outlog("summ=",j)
		aadd(aOst,j)
	next

	for i in anb_list KEYS
		aObj := NIL
		aObj:=map()
		aObj:an_value := anb_list[i]
		//outlog(__FILE__,__LINE__,"AAAA",anb_list[i])
		***** calc tcol_list
		aObj:tCols := ""; aObj:essence := anb_list[i]
		an_obj := codb_getValue(anb_list[i])
		//outlog(__FILE__,__LINE__,"AAAA",anb_list[i])
		if empty(an_obj)
			cgi_xml_error( "Object not readable:"+anb_list[i] )
			//loop
		endif
		class := NIL; tmpDict := NIL
		/*
		if !("CLASS_ID" $ an_obj)
			//quit
		endif
		*/
		if !empty(an_obj) .and. "CLASS_ID" $ an_obj .and. an_obj:class_id $ classes
			class := classes[an_obj:class_id]
		else
			if !empty(an_obj)
				cId := substr(an_obj:class_id,1,codb_info("DICT_ID_LEN"))
				tmpDict := codb_dict_reference(cId)
				if !empty(tmpDict)
					class := tmpDict:getValue(an_obj:class_id)
				endif
			endif
			if !empty(class)
				aObj:essence  := class:essence(an_obj)
				if "TCOL_LIST" $ class
					for j=1 to len(class:tcol_list)
						tcol_list:=tmpDict:select("TCOLUMN",,class:tcol_list[j])
						if empty(tcol_list)
							loop
						endif
						tcol := NIL
						tcol := tmpDict:getValue(tcol_list[1])
						if empty(tcol)
							loop
						endif
						tCols[class:tcol_list[j]] := tCol
					next
				endif
				classes[class:id] := class
			endif
		endif
		if empty(class)
			aObj:essence  := codb_essence(anb_list[i])
		elseif "TCOL_LIST" $ class
			aObj:essence  := class:essence(an_obj)
			for j=1 to len(class:tcol_list)
				tCol := NIL; k:=""
				if class:tcol_list[j] $ tCols
					tCol := tCols[class:tcol_list[j]]
				endif
				err := errorBlock({|oErr|break(oErr)})
				begin sequence
					if "EXPR_BLOCK" $ tCol
						k := mapEval(an_obj,tCol:expr_block)
					else
						x := "{||"+tCol:expr+"}"
						tCol:expr_block := &x
						k := mapEval(an_obj,tCol:expr_block)
					endif
				recover
					  k:= "error in tcolumn expr:"+tCol:expr
				end sequence
				errorBlock(err)
				if !empty(k)
					aObj:tCols += ' '+class:tcol_list[j]+'="'+toString(k)+'" '
				endif
			next
		else
			aObj:essence  := class:essence(an_obj)
		endif
		aObj:bd_summa := 0
		aObj:bk_summa := 0
		aObj:od_summa := 0
		aObj:ok_summa := 0
		aObj:ed_summa := 0
		aObj:ek_summa := 0
		aObj:beg_num  := 0
		aObj:in_num  := 0
		aObj:out_num  := 0
		aObj:end_num  := 0
		aObj:unit_num := ""
		aObj:accpost_list := {}
		for j=1 to len(variants)
			//outlog(__FILE__,__LINE__, variants[j][an_level], anb_list[i])
			if !(variants[j][an_level] == anb_list[i])
				loop
			endif
			aObj:bd_summa += aOst[j]:bd_summa
			aObj:bk_summa += aOst[j]:bk_summa
			aObj:od_summa += aOst[j]:od_summa
			aObj:ok_summa += aOst[j]:ok_summa
			aObj:ed_summa += aOst[j]:ed_summa
			aObj:ek_summa += aOst[j]:ek_summa
			aObj:beg_num  += aOst[j]:beg_num
			aObj:in_num   += aOst[j]:in_num
			aObj:out_num  += aOst[j]:out_num
			aObj:end_num  += aOst[j]:end_num
			if !empty(aOst[j]:unit_num)
				aObj:unit_num  := aOst[j]:unit_num
			endif
		//outlog(__FILE__,__LINE__,"add aOst",j,aOst[j])
			for k=1 to len(aOst[j]:accpost_list)
				aadd(aObj:accpost_list,aOst[j]:accpost_list[k])
			next
		next
		//outlog(__FILE__,__LINE__,"add data",aObj)
		aadd(data,aObj)
	next
	aObj:=NIL; aObj:=map()
	aObj:an_value := "total"
	aObj:essence  := "éÔÏÇÏ"
	aObj:tcols    := ""
	aObj:bd_summa := 0
	aObj:bk_summa := 0
	aObj:od_summa := 0
	aObj:ok_summa := 0
	aObj:ed_summa := 0
	aObj:ek_summa := 0
	aObj:beg_num  := 0
	aObj:in_num   := 0
	aObj:out_num  := 0
	aObj:end_num  := 0
	aObj:unit_num := "all"
	aObj:accpost_list := {}
	if len(data) == 0
		aObj:an_value := "EMPTY"
		aObj:essence  := "ðõóôï"
		aObj:unit_num := "EMPTY"
	else
		for i=1 to len(data)
			aObj:bd_summa += data[i]:bd_summa
			aObj:bk_summa += data[i]:bk_summa
			aObj:od_summa += data[i]:od_summa
			aObj:ok_summa += data[i]:ok_summa
			aObj:ed_summa += data[i]:ed_summa
			aObj:ek_summa += data[i]:ek_summa
			aObj:beg_num  += data[i]:beg_num
			aObj:end_num  += data[i]:end_num
			aObj:in_num   += data[i]:in_num
			aObj:out_num  += data[i]:out_num
		next
	endif
	//outlog(__FILE__,__LINE__,"data=",data)
	aadd(data,aObj)
return data

**********************************
static function calc_variants(oDep,account,an_level,beg_date,end_date,an_values,anb_list)
	local ret :={},lExit := .f.,m1:={}
	local oDict,an_info2
	local tmp,i,j,k,x,s,s1,s2,s3
	local a,b,obj,an1,an2
	local _used := map()

	oDict := oDep:dictionary()
	an_info2 := oDict:classBodyByName("an_info2")
	if empty(an_info2)
		outlog("Error: class AN_INFO2 not found in ACC01")
		return ret
	endif

	//outlog(__FILE__,__LINE__,len(anb_list),anb_list)
	if an_level <= 1
		for i in anb_list
			aadd(ret,{i})
		next
		return ret
	endif
	//outlog(__FILE__,__LINE__,len(ret),ret)
	//outlog(__FILE__,__LINE__,len(anb_list),anb_list)

	for i in anb_list
		x := {}
		asize(x,len(an_values))
		x[an_level] := i
		for j=1 to len(an_values)
			if !empty(an_values[j])
				x[j] := an_values[j]
			endif
		next
		aadd(ret,x)
	next
	if empty(ret)
		return ret
	endif
	//outlog(__FILE__,__LINE__,len(ret),ret)


	s := 'account=="'+account+'"'
	s2 := ''
	s2:= ' .and. beg_date<=stod("'+dtos(end_date)+'") .and. end_date>=stod("'+dtos(beg_date)+'") '
	k :=1; a := ret[k]
	while !lExit
		m1:={}
		for i=an_level to 2 step -1
			an1:=a[i-1]
			if an1 == NIL
				exit
			endif
		next
		if i > 1
			an2:=a[i]
			s1 := ' .and. an_level=='+alltrim(str(i-1,2,0))+' '
			s3 := ' .and. an_value2=="'+an2+'"'
			tmp:=oDep:select(an_info2:id,,,s+s1+s2+s3)
			//outlog("an_info2",s+s1+s2+s3,tmp)
			for j=1 to len(tmp)
				obj := oDep:getValue(tmp[j])
				if empty(obj)
					loop
				endif
				aadd(m1,obj:an_value1)
				b := aclone(a)
				b[i-1] := obj:an_value1
	//outlog(__FILE__,__LINE__,"aadd",b)
				aadd(ret,b)
			next
			/*
			for j=1 to len(m1)
				b := aclone(a)
				b[i-1] := m1[j]
	//outlog(__FILE__,__LINE__,"aadd",b)
				aadd(ret,b)
			next
			*/
		else
			for i=1 to len(an_values)-1
				an1:=a[i]
				an2:=a[i+1]
				if an2 != NIL
					loop
				endif
				//outlog("a2=",i,a)
				s1 := ' .and. an_level=='+alltrim(str(i,2,0))+' '
				s3 := ' .and. an_value1=="'+an1+'"'
				tmp:=oDep:select(an_info2:id,,,s+s1+s2+s3)
				//outlog("an_info2",s+s1+s2+s3,tmp)
				for j=1 to len(tmp)
					obj := oDep:getValue(tmp[j])
					if empty(obj)
						loop
					endif
					aadd(m1,obj:an_value2)
					b := aclone(a)
					b[i+1] := obj:an_value2
	//outlog(__FILE__,__LINE__,"aadd",b)
					aadd(ret,b)
				next
				/*
				for j=1 to len(m1)
					b := aclone(a)
					b[i+1] := m1[j]
	//outlog(__FILE__,__LINE__,"aadd",b)
					aadd(ret,b)
				next
				*/
				if len(m1)==0
					b := aclone(a)
					b[i+1] := ""
	//outlog(__FILE__,__LINE__,"aadd",b)
					aadd(ret,b)
				endif
				exit
			next
		endif
		*****
		adel(ret,k); asize(ret,len(ret)-1)
	//outlog(__FILE__,__LINE__,ret)
		*****

		_used := map()
		b:={}
		for i=len(ret) to 1 step -1 //len(ret)
			a := ""
			for j=len(ret[i]) to 1 step -1
				a+=iif(ret[i][j]==NIL,"NIL",ret[i][j])
			next
		//outlog(__FILE__,__LINE__,a,_used)
			if a $ _used
				aadd(b,i)
				loop
			endif
			_used[a] := a
		next
		//outlog(__FILE__,__LINE__,b)
		for i=len(b) to 1 step -1
			adel(ret,b[i])
		next
		asize(ret,len(ret)-len(b))

		lExit := .t.
		for i=len(ret) to 1 step -1 //to len(ret)
			for j=1 to len(ret[i])
				if ret[i][j] == NIL
					lExit := .f.
					a := ret[i]
					k := i
					exit
				endif
			next
			if !lExit
				exit
			endif
		next
	enddo
	//outlog(__FILE__,__LINE__,len(ret))
	s := 'account=="'+account+'"'
	s += ' .and. an_level=='+alltrim(str(an_level-1,2,0))+' '
	b:={}
	_used := map()
	for i=1 to len(ret)
		a := ""
		for j=1 to len(ret[i])
			a+=ret[i][j]
		next
		if a $ _used
			aadd(b,i)
			loop
		endif
		_used[a] := a
		s2 := ' .and. an_value1=="'+ret[i][an_level-1]+'"'
		s3 := ' .and. an_value2=="'+ret[i][an_level]+'"'
		tmp:=oDep:select(an_info2:id,,,s+s2+s3)
		//outlog(__FILE__,__LINE__,s+s2+s3,tmp)
		if empty(tmp)
		   aadd(b,i)
		endif
	next
	//outlog(__FILE__,__LINE__,b)
	for i=len(b) to 1 step -1
		adel(ret,b[i])
	next
	asize(ret,len(ret)-len(b))
	//outlog(__FILE__,__LINE__,len(ret),ret)
return ret
************************************
static function calc_summ(oDep,an_balance,account,an_level,beg_date,end_date,variant)
	local ret:=map()
	local s,s1,s2,as1
	local i,j,k,y,z:=.f.
	local max_date,min_date
	local tobj,tmp


	ret:an_value := vartostring(variant,,,.f.)
	ret:tCols := ""
	ret:essence  := ""
	ret:bd_summa := 0
	ret:bk_summa := 0
	ret:od_summa := 0
	ret:ok_summa := 0
	ret:ed_summa := 0
	ret:ek_summa := 0
	ret:beg_num  := 0
	ret:in_num   := 0
	ret:out_num  := 0
	ret:end_num  := 0
	ret:unit_num := ""
	ret:accpost_list := {}

	s := 'account="'+account+'" '
	if an_level <= 1
		s += ' .and. an_value=="'+variant[1]+'"'
	else
		for i=1 to len(variant)
			if empty(variant[i])
				loop
			endif
			as1:=".and. AN_VALUE"+alltrim(str(i,2,0))
			s+=as1+'=="'+variant[i]+'" '
		next
	endif
	s1 := ' .and. odate>=stod("'+dtos(beg_date)+'") .and. odate<=stod("'+dtos(end_date)+'")'
	s2 := ' .and. odate<=stod("'+dtos(beg_date)+'")'

	max_date:=stod("10010101")
	min_date:=stod("22010101")
	tmp := oDep:select(an_balance:id,,,s+s1)
	//outlog("an_balance",s+s1,tmp)
	if empty(tmp)
		tmp := oDep:select(an_balance:id,1,,s+s2,-1)
		z := .t.
		//outlog("an_balance",s+s2,tmp)
	endif
	for j=1 to len(tmp)
		tObj := oDep:getValue(tmp[j])
		//outlog(__FILE__,__LINE__,an_balance:name,tmp[j],tObj)
		if empty(tObj)
			outlog("Error: can`t load object:",tmp[i])
			loop
		endif
		if tobj:odate > end_date
			loop
		endif
		if tobj:odate < min_date
			if z
				ret:bd_summa := tobj:ed_summa
				ret:bk_summa := tobj:ek_summa
				ret:beg_num  := tobj:ed_quantity
			else
				ret:bd_summa := tobj:bd_summa
				ret:bk_summa := tobj:bk_summa
				ret:beg_num  := tobj:bd_quantity
			endif
			if empty(ret:unit_num)
				ret:unit_num  := tobj:unit
			endif
			min_date := tobj:odate
		endif
		if tobj:odate > max_date
			ret:ed_summa := tobj:ed_summa
			ret:ek_summa := tobj:ek_summa
			ret:end_num  := tobj:ed_quantity
			if empty(ret:unit_num)
				ret:unit_num  := tobj:unit
			endif
			max_date := tobj:odate
		endif
		if tObj:odate >= beg_date .and. tObj:odate <= end_date
			ret:od_summa += tobj:od_summa
			ret:ok_summa += tobj:ok_summa
			ret:in_num   += tobj:od_quantity
			ret:out_num  += tobj:ok_quantity
			if empty(ret:unit_num)
				ret:unit_num  := tobj:unit
			endif
		endif
		//outlog(__FILE__,__LINE__,an_balance:name,tmp[j],tObj)
		for k=1 to len(tobj:accpost_list)
			aadd(ret:accpost_list,tobj:accpost_list[k])
		next
	next
return ret

