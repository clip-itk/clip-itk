#define NEW_VARIANTS
***********************
function cgi_an_make_data(beg_date,end_date,oDep,account,an_values,an_level,union)
	local oDict,an_info,an_balance,osb_class,anb_list:=map()
	local as,as1,s:="",s0,s1,s2,obj,aObj,tObj,tmp,data:={}
	local i,j,k,kk,x,y,z,itogCel,aOst:={},typeval,essvalue
	local max_date,min_date,variants:={},nFilled, call_an := .f.
	local an_obj,class,cId,tmpDict,tcol,tcol_list,err
	local classes:=map(), tCols := map()

	//outlog(__FILE__,__LINE__,an_level,an_values)
	oDict := oDep:dictionary()
	an_info := oDict:classBodyByName("an_info")
	if empty(an_info)
		outlog("Error: class AN_INFO not found in ACC01")
		return data
	endif
	if an_level < 1
		an_level := 1
	endif
	if an_level > len(an_values)
		an_level := len(an_values)
	endif
	nFilled := 0
	for i=1 to len(an_values)
		if !empty(an_values[i])
			nFilled ++
		endif
	next
	if nFilled == 0
		call_an := .t.
	elseif nFilled ==1 .and. !empty(an_values[1])
		call_an := .t.
	endif
	//outlog(__FILE__,__LINE__,
	if an_level <= 1 .and. call_an
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

	if nFilled == 0 //.or. empty(an_values[an_level])//if an_level>1 .and. empty(an_values[1])
		s := 'account=="'+account+'"'
		//s2:= '.and. beg_date>=stod("'+dtos(end_date)+'") .and. end_date>=stod("'+dtos(beg_date)+'") '
		s2:= '.and. end_date>=stod("'+dtos(beg_date)+'") '
		//s2:= '.and. beg_date>=stod("'+dtos(beg_date)+'") '
	//s2:=""
		s1:= '.and. an_level=='+alltrim(str(an_level,2,0))+' '
		tmp:=oDep:select(an_info:id,,,s+s1+s2)
		//outlog(__FILE__,__LINE__,s+s1+s2,tmp)
		//outlog("an_values=",an_values,s)
		//outlog("an_info",s+s1+s2,tmp)

		for i=1 to len(tmp)
			obj:=oDep:getValue(tmp[i])
			if empty(obj)
				outlog("Error: can`t load object:",tmp[i])
				loop
			endif
			//outlog("an_info",i,tmp[i],obj:an_value,obj:beg_date,obj:end_date,obj:accpost_list)
			anb_list[obj:an_value] := obj:an_value
		next
	else
		if an_level>0 .and. an_level<=len(an_values) ;
			.and. !empty(an_values[an_level])

			anb_list[an_values[an_level]] := an_values[an_level]
		endif

	endif
	//outlog("anb_list=",anb_list)
	//outlog("an_values=",an_values)

	variants := r2d2_calc_an_variants(oDep,account,an_level,beg_date,end_date,an_values,anb_list)
    /*
	outlog("var_params=",account,an_level,beg_date,end_date,an_values,anb_list)
	outlog("variants =",len(variants),variants)
	for i=1 to len(variants)
		outlog("variant",i,variants[i])
	next
    */

	for i=1 to len(variants)
		j := r2d2_calc_an_summ(oDep,an_balance,account,iif(call_an,an_level,2),beg_date,end_date,variants[i])
		//outlog("variant",i,variants[i])
		//outlog("summ=",j)
		aadd(aOst,j)
		tmp :=  variants[i][an_level]
		if !empty(tmp)
			anb_list[ tmp ] := tmp
		endif
	next

	for i in anb_list KEYS
		aObj := NIL
		aObj:=map()
		aObj:an_value := anb_list[i]
		//outlog(__FILE__,__LINE__,"AAAA",anb_list[i])
		***** calc tcol_list
		aObj:tCols := ""
		aObj:essence := anb_list[i]
		aObj:union := ""
		aObj:attr := ""		
		aObj:esse := ""				
		an_obj := cgi_getValue(anb_list[i])
		//outlog(__FILE__,__LINE__,"AAAA",anb_list[i])
		if empty(an_obj)
//			cgi_xml_error( "Object not readable:"+anb_list[i] )
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
			aObj:essence  := cgi_essence(anb_list[i])
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
				kk:=""
//*--------------------------------		

					typeval := valtype(an_obj[upper(class:tcol_list[j])])		
					essvalue:= an_obj[upper(class:tcol_list[j])]
//outlog( class:tcol_list[j] ,k, essvalue )					    					
					if typeval=="L"
					    essvalue:=iif(essvalue,'true','false')
					    kk:=toString(k)
					elseif  typeval=="D"
					    essvalue:=iif(empty(essvalue),"''","'"+dtos(essvalue)+"'")
					    KK:=toString(k)
					elseif  typeval=="N"
					    kk:=bal_summa(essvalue)					
					    essvalue:="'"+bal_summa(essvalue)+"'"
					else
					    essvalue:= alltrim(toString(an_obj[upper(class:tcol_list[j])]))
					    essvalue:=strtran(essvalue,"'","\'")
					    essvalue:=strtran(essvalue,'"','\"')
					    essvalue:=iif(len(essvalue)==0,' ',essvalue)
					    essvalue:="'"+essvalue+"'"
					    kk:=alltrim(toString(k))
					    kk:=strtran(kk,"'","\'")
					    kk:=strtran(kk,'"','\"')
					    
					endif 
//outlog( class:tcol_list[j] ,kk, essvalue )		
					aObj:esse  += class:tcol_list[j]+":"+essvalue+', '
					aObj:attr  += class:tcol_list[j]+":'"+kk+"',  "
					aObj:tCols += ' '+class:tcol_list[j]+'="'+alltrim(toString(k))+'" ' 
				endif
				if !empty(k) .and. union==class:tcol_list[j]
					aObj:union := k
				endif
			next
		else
			aObj:essence  := class:essence(an_obj)
		endif
		
//outlog(aObj:esse)			    												
//outlog(aObj:attr)			    												
		
		
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
	aObj:union    := "éÔÏÇÏ"
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
	//outlog(__FILE__,__LINE__,data)
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
	if !empty(union)
		for i=len(data) to 1 step -1
			for j=1 to len(data)
				if data[i]:union == data[j]:union .and. i!=j
				else
					loop
				endif
				exit
			next
			if j>len(data)
				loop
			endif
			aObj:=data[j]
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
			adel(data,i)
			asize(data,len(data)-1)
		next
	endif
return data

**********************************
function r2d2_calc_an_variants(oDep,account,an_level,beg_date,end_date,an_values,anb_list)
	local ret :={},ret2:={},lExit := .f.,m1:={}
	local oDict,an_info_full
	local tmp,i,j,k,s,s1,s2,s3
	local a,b,obj,an1,an2
	local _used := map()
	local x,y := {}

	oDict := oDep:dictionary()
	an_info_full := oDict:classBodyByName("an_info_full")
	if empty(an_info_full)
		outlog("Error: class AN_INFO_FULL not found in ACC01")
		return ret
	endif

	//outlog(__FILE__,__LINE__,anb_list)
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
	//outlog(__FILE__,__LINE__,"ret=",len(ret),ret)
	if an_level <= 1 .and. !empty(ret)
		return ret
	endif
	i := 0
	//outlog(__FILE__,__LINE__,"ret=",len(ret),ret)
	if empty(ret)
		x := {}
		asize(x,len(an_values))
		for j=1 to len(an_values)
			if !empty(an_values[j])
				x[j] := an_values[j]
				i++
			endif
		next
		aadd(ret,x)
	endif
	//outlog(__FILE__,__LINE__,"ret=",len(ret),ret)
	if empty(ret) //.or. i==0
		return ret
	endif
	//return ret


#ifdef NEW_VARIANTS
	s := 'account=="'+account+'"'+;
		' .and. beg_date<=stod("'+dtos(end_date)+'") .and. end_date>=stod("'+dtos(beg_date)+'") '
	tmp:=oDep:select(an_info_full:id,,,s)
	//outlog(__FILE__,__LINE__,len(tmp),s,tmp)
	for i=len(tmp) to 1 step -1
		obj := oDep:getValue(tmp[i])
		if empty(obj)
			loop
		endif
		k:=len(ret)+1
		//outlog(__FILE__,__LINE__,obj:an_value1,obj:an_value2,obj:an_value3,obj:an_value4,obj:an_value5,obj:an_value6)
		while ((k--)>1)
			a:= ret[k]
			j:=len(a)
			x := .t.
			if x .and. a[1]!=NIL .and. a[1] != obj:an_value1
				x := .f.
			endif
			if x .and. a[2]!=NIL .and. a[2] != obj:an_value2
				x := .f.
			endif
			if x .and. a[3]!=NIL .and. a[3] != obj:an_value3
				x := .f.
			endif
			if x .and. a[4]!=NIL .and. a[4] != obj:an_value4
				x := .f.
			endif
			if x .and. a[5]!=NIL .and. a[5] != obj:an_value5
				x := .f.
			endif
			if x .and. a[6]!=NIL .and. a[6] != obj:an_value6
				x := .f.
			endif
			if x
				b := aclone(a)
				b[1] := obj:an_value1
				b[2] := obj:an_value2
				b[3] := obj:an_value3
				b[4] := obj:an_value4
				b[5] := obj:an_value5
				b[6] := obj:an_value6
				aadd(ret2,b)
			endif
		end
	next
	//outlog(__FILE__,__LINE__,len(ret2),ret2)
#else
	for k=1 to len(ret)
		s2 := ""; a:= ret[k]
		for i=1 to len(a)
			if a[i] == NIL
				loop
			endif
			s2 += ' .and. an_value'+alltrim(str(i,2,0))+;
			      '=="'+a[i]+'"'
		next
		tmp:=oDep:select(an_info_full:id,,,s+s2)
		//outlog(__FILE__,__LINE__,s+s2,tmp)
		for i=1 to len(tmp)
			obj := oDep:getValue(tmp[i])
			if empty(obj)
				loop
			endif
			b := aclone(a)
			b[1] := obj:an_value1
			b[2] := obj:an_value2
			b[3] := obj:an_value3
			b[4] := obj:an_value4
			b[5] := obj:an_value5
			b[6] := obj:an_value6
			aadd(ret2,b)
		next
	next
#endif
	b:={}
	_used := map()
	for i=1 to len(ret2)
		a := ""
		for j=1 to len(ret2[i])
			a+=ret2[i][j]
		next
		if a $ _used
			aadd(b,i)
			loop
		endif
		_used[a] := a
	next
	//outlog(__FILE__,__LINE__,"after check",len(ret2))
	//outlog(__FILE__,__LINE__,b)
	for i=len(b) to 1 step -1
		adel(ret2,b[i])
	next
	asize(ret2,len(ret2)-len(b))
	//outlog(__FILE__,__LINE__,len(ret2),ret2)
return ret2
************************************
function r2d2_calc_an_summ(oDep,an_balance,account,an_level,beg_date,end_date,variant)
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

	s:= ""
	if an_level <= 1
		s += 'an_value=="'+variant[1]+'" .and. '
	else
		for i=len(variant) to 1 step -1
		//for i=1 to len(variant)
			if empty(variant[i])
				loop
			endif
			as1:="AN_VALUE"+alltrim(str(i,2,0))
			s+=as1+'=="'+variant[i]+'" .and. '
		next
	endif
	s += ' account="'+account+'" '
	s1 := ' .and. odate>=stod("'+dtos(beg_date)+'") .and. odate<=stod("'+dtos(end_date)+'")'
	s2 := ' .and. odate<=stod("'+dtos(beg_date)+'")'

	max_date:=stod("10010101")
	min_date:=stod("22010101")
	tmp := oDep:select(an_balance:id,,,s+s1)
	//outlog(__FILE__,__LINE__,s+s1,tmp)
	//outlog("an_balance",s+s1,tmp)
	if empty(tmp)
		tmp := oDep:select(an_balance:id,1,,s+s2,-1)
		//outlog(__FILE__,__LINE__,s+s2,tmp)
		z := .t.
		//outlog("an_balance",s+s2,tmp)
	endif
	for j=1 to len(tmp)
		tObj := oDep:getValue(tmp[j])
		//outlog(__FILE__,__LINE__,tObj:unit)
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
			//outlog(__FILE__,__LINE__,tobj:odate, max_date)
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
		//outlog(__FILE__,__LINE__,ret)
		//outlog(__FILE__,__LINE__,an_balance:name,tmp[j],tObj)
		for k=1 to len(tobj:accpost_list)
			aadd(ret:accpost_list,tobj:accpost_list[k])
		next
	next
return ret
************************************
function r2d2_amLastValue(oDep,_account,variant)
	local ret := 0.00
	local i, s := "", as1, tmp, obj
	local oDict, oDep02, oDict02
	local acc_chart,balance
	local account := ""

	oDict := oDep:dictionary()
	balance := oDict:classBodyByName("am_balance")
	if empty(balance)
		outlog(__FILE__,__LINE__,"Error: class AM_BALANCE not found")
		return ret
	endif

	oDep02 := codb_dep_reference("GBL0201")
	tmp := oDep02:getValue(_account)
	if !empty(tmp)
		account := _account
	else
		account := oDep02:id4primaryKey("acc_chart","code",_account)
	endif
	if empty(account)
		return ret
	endif

	********
	for i=len(variant) to 1 step -1
		as1:="AN_VALUE"+alltrim(str(i,2,0))
		s+=as1+'=="'+variant[i]+'" .and. '
	next

	s += ' account="'+account+'" '
	tmp := oDep:select(balance:id,1,,s,-1)

	if empty(tmp)
		return ret
	endif

	obj := oDep:getValue(tmp[1])
	ret := obj:ed_summa - obj:ek_summa

return ret

