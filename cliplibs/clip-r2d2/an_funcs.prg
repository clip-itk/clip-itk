function cgi_an_make_data(beg_date,end_date,oDep,account,an_values,an_level,union,total)
	local oDict,an_info,an_balance,am_balance,osb_class
	local anb_list:=map(),an_level2,an_values2,anb_list2
	local as,as1,s:="",s0,s1,s2,obj,aObj,tObj,tmp,data:={}
	local i,j,k,kk,x,y,z,itogCel,oOst,aOst:={},typeval,essvalue
	local max_date,min_date,variants:={},nFilled, call_an := .f.
	local an_obj,class,cId,tmpDict,tcol,tcol_list,err
	local classes:=map(), tCols := map()
	local acc_data, tattrib:={}, attr_list


	acc_data := cgi_getValue(account)
	if empty(acc_data)
		acc_data := map()
	endif
	
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
	am_balance := oDict:classBodyByName("am_balance")
	if empty(am_balance)
		outlog("Error: class AM_BALANCE not found in ACC01")
		return data
	endif
	if an_level <= 1 .and. call_an
		an_balance := oDict:classBodyByName("an_balance")
		if empty(an_balance)
			outlog("Error: class AN_BALANCE not found in ACC01")
			return data
		endif
	else
		an_balance := am_balance
	endif

	//outlog(__FILE__,__LINE__,'nFilled',nFilled)
	if nFilled == 0
		s := 'account=="'+account+'"'
		s2:= '.and. end_date>=stod("'+dtos(beg_date)+'") '
		s1:= '.and. an_level=='+alltrim(str(an_level,2,0))+' '
		tmp:=oDep:select(an_info:id,,,s+s1+s2)
		for i=1 to len(tmp)
			obj:=oDep:getValue(tmp[i])
			if empty(obj)
				outlog("Error: can`t load object:",tmp[i])
				loop
			endif
			anb_list[obj:an_value] := obj:an_value
		next
	else
		if an_level>0 .and. an_level<=len(an_values) ;
			.and. !empty(an_values[an_level])
			anb_list[an_values[an_level]] := an_values[an_level]
		endif

	endif



	variants := r2d2_calc_an_variants(oDep,account,an_level,beg_date,end_date,an_values,anb_list)

	for i=1 to len(variants)
		oOst:= r2d2_calc_an_summ(oDep,an_balance,account,iif(call_an,an_level,2),beg_date,end_date,variants[i])
		tmp :=  variants[i][an_level]
		if !empty(tmp)
			anb_list[ tmp ] := tmp
		endif
		aadd(aOst,oOst)
	next
 
 	//outlog(__FILE__,__LINE__,'len_aOst',len(aOst))
	for i in anb_list KEYS
		aObj:= NIL
		aObj:=map()
		aObj:an_value := anb_list[i]
		//outlog(__FILE__,__LINE__,"AAAA",anb_list[i])
		***** calc tcol_list
		aObj:tCols:= ""
		aObj:essence:= anb_list[i]
		aObj:union:= ""
		aObj:attr:= ""
		aObj:esse:= ""
		class:=NIL; tmpDict:=NIL

		aObj:essence  := cgi_essence(anb_list[i])
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

		for j=1 to len(variants)
		
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
		
		next
		//outlog(__FILE__,__LINE__,"add data",aObj)
		if ( aObj:od_summa==0 .and. aObj:ok_summa==0 .and. aObj:ed_summa==0 .and. aObj:ek_summa==0 .and. aObj:in_num==0 .and. aObj:out_num==0 .and. aObj:end_num==0 )
		else	
		    aadd(data,aObj)
		endif    
	next
	if !(empty(total))
	    return data
	endif    
	aObj:=NIL; aObj:=map()
	aObj:an_value := "total"
	aObj:essence  := "�����"
	aObj:union    := "�����"
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

	if len(data) == 0 
		aObj:an_value := "EMPTY"
		aObj:essence  := "�����"
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
	//outlog(__FILE__,__LINE__,"len(data)===",len(data))
return data

*********************************
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
	if empty(ret) 
		return ret
	endif

	s := 'account=="'+account+'"'+;
		' .and. beg_date<=stod("'+dtos(end_date)+'") .and. end_date>=stod("'+dtos(beg_date)+'") '

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
		for i=1 to len(tmp)
			obj := oDep:getValue(tmp[i])
			if empty(obj)
				loop
			endif
			aadd(ret2,{obj:an_value1,obj:an_value2,obj:an_value3,obj:an_value4,obj:an_value5,obj:an_value6})
		next
	next

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

	s:= ""
	//outlog(__FILE__,__LINE__,an_level,variant)
	if an_level <= 1
		s += 'an_value=="'+variant[1]+'" .and. '
	else
		for i=len(variant) to 1 step -1
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

	
	if empty(tmp)
		tmp := oDep:select(an_balance:id,1,,s+s2,-1)
		z := .t.
	endif
	
	for j=1 to len(tmp)
		tObj := oDep:getValue(tmp[j])
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
	next
return ret
************************************

