/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "config.ch"
#include "inkey.ch"
#include "imenu.ch"
#include "set.ch"
#include "box.ch"


************************************************
procedure abNew(par1,par2)

	local obj:=map()

	setcolor(set("ab_colors"))
	clear screen
	obj:classname	:= "AB_DBU"
	obj:winNo	:= 0
	obj:maxrow	:= maxrow()
	obj:maxcol	:= maxcol()
	obj:mapkeys	:= HK_get("ab")
	obj:dictArray	:= NIL
	obj:dictionary	:= NIL
	obj:depository	:= NIL
	obj:browse	:= NIL
	obj:__statusLine:= [Esc-menu F1-help F2-add F3-card F4-edit F8-delete F10-closeWin]
	*****
	obj:HandleKey	:= @HandleKey()
	obj:statusLine	:= @statusLine()
	obj:quit	:= @ab_quit()
	obj:openDict	:= @ab_openDict()
	obj:openOqlQuery:= @ab_openOqlQuery()
	obj:editDict	:= @ab_editDict()
	obj:openDeposit	:= @ab_openDeposit()

	obj:menu	:= make_ab_menu(obj)

	if valtype(par1)=="C"
		if len(par1)==codb_info("DICT_ID_LEN")
			obj:dictionary := coDictionary():new(par1)
			if !empty(obj:dictionary:error)
				alert(obj:dictionary:error)
				obj:dictionary:close()
				obj:dictionary:=NIL
			else
				obj:dictionary:open()
				if !empty(obj:dictionary:error)
					alert(obj:dictionary:error)
					obj:dictionary:close()
					obj:dictionary:=NIL
				else
					obj:menu:enableMeta()
				endif
			endif
		else
			obj:depository := coDepository():new(par1)
			if !empty(obj:Depository:error)
				alert(obj:Depository:error)
				obj:Depository:close()
				obj:Depository:=NIL
			else
				obj:Depository:open()
				if !empty(obj:Depository:error)
					alert(obj:dictionary:error)
					obj:Depository:close()
					obj:Depository:=NIL
				else
					obj:dictionary:=obj:depository:dictionary()
					obj:menu:enableMeta()
					obj:menu:enableData()
				endif
			endif
		endif
	endif

	ab_sayCopyRight()
	obj:statusLine()
	obj:handleKey(0)

return  obj

************************************************
static function ab_sayCopyRight()
	@ 2,50, 8,maxcol() box B_DOUBLE+" "
	@ 3,52 say "Object DB Utility"
	@ 4,52 say "(C) ITK, 2002"
	@ 5,52 say "Author: Uri V. Hnykin"
	@ 6,52 say "Licence: GPL"
	@ 7,52 say "Home: www.itk.ru"

return
************************************************
static function ab_quit()
return otvet("Exit from object base utility ?")
************************************************
static function statusLine(str)
	local oldwin:=wselect(),ret
	static old_st:=""
	ret:=old_st
	str:=iif(str==NIL,::__statusLine,str)
	old_st:=str
	wselect(::winNo)
	@ ::maxrow,0 say padr(str,::maxcol) color set("ab_colors_menu")
	wselect(oldwin)
return ret
*********************************************
static function ab_openOqlQuery()
   local scr:=savescreen(),idList
   local getlist:={},pic:="@S35"
   local x1:=6,y1:=10,x2,y2
   local sSelect := padr("currency",50), sFrom:=padr("GBL0101",50)
   local sWhere := space(150)
   x2:=x1+12; y2:=y1+60
   @ x1,y1,x2,y2 box B_DOUBLE+" "
   @ x1, y1+3 say [Please fill data for query]
   @ x1+1 , y1+1 say [Select.<classname>..] get sSelect		picture pic
   @ x1+2 , y1+1 say [From <depository_id>] get sFrom 		picture pic
   @ x1+3 , y1+1 say [Where <expr>........] get sWhere 		picture pic
   read
   restore screen from scr
   if lastkey()==27
	return NIL
   endif
   if ::browse!=NIL
	::browse:close()
	::menu:enableChoice()
	::browse:=NIL
   endif
   idList := codb_oql_select(alltrim(sSelect), alltrim(sFrom), alltrim(sWhere) )
   if !empty(idList:error)
	alert(idList:error)
	idlist:close()
	return
   endif
   dispbegin()
   ::browse := ab_make_data_browse(::depository,sSelect,idList)
   dispend()
   if empty(::browse:error)
   else
	alert(::browse:error)
	::browse:close()
	::browse:=NIL
   endif
return
*********************************************
static function ab_openDict()
	local i,scr,m,mlen:=0,vlen:=0,newDict:=NIL,x1,x2,y1,y2
	local tmp,new:=.f.
	if ::dictArray==NIL
		::dictArray:=codbList():new()
		if val(::dictArray:error)>0
			messagep([Error open dictionary list!]+";"+::dictArray:error)
			::dictArray:close()
			return
		endif
	endif
	m:=::dictArray:list()
	aadd(m,[Create new dictionary     ])
	for i=1 to len(m)
		mlen:=max(mlen,len(m[i]))
	next
	mlen:=min(mlen,maxcol()-8)
	mlen+=2
	x1:=int((maxcol()-mlen)/2)
	x2:=maxcol()-x1
	vlen:=min(len(m)+1,maxrow()-6)
	vlen:=int(max(vlen,maxrow()/4))
	y1:=int((maxrow()-vlen)/2)
	y2:=maxrow()-y1
	scr:=savescreen(y1,x1,y2+2,x2+2)
	i=achoice(y1,x1,y2,x2,m,,,1,1,,B_DOUBLE,[Choice Dictionary])
	restscreen(y1,x1,y2+2,x2+2,scr)
	if i==0
		return .f.
	endif

	x1:=""
	if i>0 .and. i<len(m)
		x1:=substr(m[i],1,at(":",m[i])-1)
	endif

	if i==len(m) // create new dictionary
		tmp=::dictArray:padrBody(map())
		while .t.
			x1:=""
			::editDict(10,10,tmp)
			if empty(tmp) .or. lastkey()==K_ESC //edit error
				exit
			endif
			x1:=::dictArray:append(tmp)
			if val(::dictArray:error)!=0
				message(::dictArray:error)
			else
				exit
			endif
		enddo
		new:=.t.
	endif

	if empty(x1)
		return .f.
	endif
	if ::browse!=NIL
		::browse:close()
		::browse:=NIL
	endif
	if ::depository!=NIL
		::depository:close()
		::depository:=NIL
	endif
	if ::dictionary!=NIL
		::dictionary:close()
		::dictionary:=NIL
	endif
	::menu:disableData()
	::dictionary:=::dictArray:connect(x1)
	if val(::dictionary:error)!=0
		message(::dictionary:error)
		::dictionary:=NIL
		return .f.
	endif
	if new
		::dictionary:create()
	endif
	::dictionary:open()
	if val(::dictionary:error)!=0
		message(::dictionary:error)
		::dictionary:close()
		return .f.
	endif
	::menu:enableMeta()
return
*********************************************
static function ab_editDict(self,x1,y1,data)
   local scr:=savescreen(),tmp:=codb_info("CODB_DICTLIST_STRUCTURE")
   local getlist:={},pic:="@S35",x2,y2
   local dtypes:=codb_info("CODB_DICT_TYPES"),t
   local ddtypes:=codb_info("CODB_DICT_DTYPES"),dt
   x2:=x1+12; y2:=y1+60
   @ x1,y1,x2,y2 box B_DOUBLE+" "
   @ x1, y1+3 say [Please fill data of dictionary]
   @ x1+1 , y1+1 say [Ident...............] get data:id		picture pic
   @ x1+2 , y1+1 say [Name................] get data:name	picture pic

   t:=ascan(dtypes,{|x|alltrim(x)==alltrim(data:type)})
   t:=iif(t<=0,1,t)
   @ x1+3 , y1+1 say [Type................] //get data:type	picture pic
   @ x1+3 , y1+22, x1+10, y1+41 get t list dtypes dropDown

   dt:=ascan(dtypes,{|x|alltrim(x)==alltrim(data:dtype)})
   dt:=iif(dt<=0,1,dt)
   /*
   @ x1+4 , y1+1 say [Data type...........] //get data:type	picture pic
   @ x1+4 , y1+22, x1+10, y1+41 get dt list ddtypes dropDown
   */

   @ x1+5 , y1+1 say [Path................] get data:path	picture pic
   @ x1+6 , y1+1 say [Host name...........] get data:host   	picture pic
   @ x1+7 , y1+1 say [SQL port............] get data:port
   @ x1+8 , y1+1 say [User name...........] get data:user   	picture pic
   @ x1+9 , y1+1 say [SQL DB name.........] get data:dbname 	picture pic
   read
   data:type:=dtypes[t]
   data:dtype:=ddtypes[dt]
   restore screen from scr
   if lastkey()==27
	return NIL
   endif
return data
*********************************************
static function ab_openDeposit()
	local i,tmp,oTmp,scr,m:={}
	local mlen:=0,vlen:=0
	local newDict:=NIL,x1,x2,y1,y2
	if ::dictionary==NIL
		return
	endif
	tmp:=::dictionary:select("DEPOSIT")
	for i=1 to len(tmp)
		oTmp := ::dictionary:getValue(tmp[i])
		aadd(m,oTmp:name)
	next
	for i=1 to len(m)
		mlen:=max(mlen,len(m[i]))
	next
	mlen:=max(25,min(mlen,maxcol()-8))
	mlen+=2
	x1:=int((maxcol()-mlen)/2)
	x2:=maxcol()-x1
	vlen:=min(len(m)+1,maxrow()-6)
	vlen:=int(max(vlen,maxrow()/4))
	y1:=int((maxrow()-vlen)/2)
	y2:=maxrow()-y1
	scr:=savescreen(y1,x1,y2+2,x2+2)
	i=achoice(y1,x1,y2,x2,m,,,1,1,,B_DOUBLE,[Choice Depository])
	restscreen(y1,x1,y2+2,x2+2,scr)

	if i==0
		return
	endif

	if ::depository!=NIL
		::depository:close()
		::depository:=NIL
	endif

	::menu:disableData()

	::depository := ::dictionary:depository(tmp[i])
	::depository:name := m[i]
	if empty(::depository:error)
		::depository:open()
	endif
	if !empty(::depository:error)
		message(::depository:error)
		::depository:close()
		::depository:=NIL
		return .f.
	endif
	::menu:enableData()
return
*********************************************
static function HandleKey(nkey)
	static vKeys := {HASH_ViewExtents, HASH_ViewAttrs, HASH_ViewClasses,;
			HASH_ViewUsers, HASH_ViewGroups, HASH_ViewDeps,;
			HASH_ViewColumns,HASH_ViewTviews,HASH_ViewIndexes,;
			HASH_ViewReports,HASH_ViewPlugins,HASH_ViewCounters}
	static vMeta := {"EXTENT","ATTR","CLASS","USER","GROUP","DEPOSIT",;
			 "TCOLUMN","TVIEW","INDEX","REPORT","PLUGINS","COUNTER"}
	local hkey:=0,ret:=1,vKey ,s:="",tmp1,tmp2
	local fName

	if nkey $ ::mapKeys
		hkey=::mapKeys[nkey]
		nkey=0
	else
		hkey:=nkey; nkey:=0
	endif
	if hkey!=0
		s:=::__statusline
		hkey:=::menu:handleKey(hkey)
		::statusLine(s)
	endif
	if hkey==HASH_TextEdit
		fName = filedialog()
		if !empty(fName)
			tmp1 := savescreen()
			medit({fname})
			restscreen(,,,,tmp1)
		endif
		hkey:=nkey:=0
	endif
	if hkey==HASH_MetaLoadFromXml
		fName = filedialog()
		if !empty(fName)
			tmp1 := atr(PATH_DELIM,fname)
			tmp2 := atr(".",fname)
			s := padr(substr(fname,tmp1+1,tmp2-tmp1-1),5)
			tmp1 := savescreen()
			codb_install(s,fname)
			?
			? [Press any key to continue]
			inkey(0)
			restscreen(,,,,tmp1)
		endif
		hkey:=nkey:=0
	endif
	if hkey==HASH_MetaSaveToXml
		fName = filedialog()
		if !empty(fName)
			tmp2 := ab_metaToXml(::dictionary,fname)
			if !empty(tmp2)
				alert(tmp2)
			endif
		endif
		hkey:=nkey:=0
	endif
	if hkey==HASH_OpenDict
		::openDict()
		hkey:=nkey:=0
	endif
	if hkey==HASH_OpenOqlQuery
		::openOqlQuery()
		hkey:=nkey:=0
	endif
	if hkey==HASH_OpenDep .and. ::dictionary != NIL
		::openDeposit()
		hkey:=nkey:=0
	endif
	if hkey==HASH_ViewObjects .and. ::depository != NIL
		tmp1 := ab_choice_class(::dictionary)
		if ! empty(tmp1)
			dispbegin()
			if ::browse!=NIL
				::browse:close()
				::browse:=NIL
			endif
			::browse := ab_make_data_browse(::depository,tmp1)
			dispend()
			if empty(::browse:error)
				::menu:enableChoice()
			else
				alert(::browse:error)
				::browse:close()
				::browse:=NIL
			endif
		endif
		hkey:=nkey:=0
	endif
	vKey := ascan(vKeys,hKey)
	if vKey > 0
		dispbegin()
		if ::browse!=NIL
			::browse:close()
			::browse:=NIL
		endif
		::browse := ab_make_meta_browse(::dictionary,vMeta[vKey])
		dispend()
		if !empty(::browse:error)
			alert(::browse:error)
			::browse:close()
			::browse:=NIL
		endif
		hkey:=0
	endif
	if hkey!=0
		if ::browse!=NIL
			hkey:=::browse:handleKey(hKey)
			if hKey == NIL
				::browse := NIL
				hkey := 0
			endif
			if hKey==0
				return ret
			endif
		endif
	endif
	if hKey==HASH_Exit
		if ::quit()
			ret:=0
		endif
		nkey:=0
	endif
	s:=""
	if ::dictionary!=NIL
		s:=s+[Dictionary:]+alltrim(::dictionary:name)+space(5)
	endif
	if ::depository!=NIL
		s:=s+[Depository:]+alltrim(::depository:name)+space(5)
	endif
	@ maxrow()-1, 0 say padr(s,maxcol()+1) color "14/b"
return ret
