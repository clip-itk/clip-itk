/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/* install procedure all CODB dictionaries and default data objects */
//#include "codbcfg.ch"

#include "six2clip.ch"
#include "codbcfg.ch"
#include "codb_dbf.ch"

local dList,list
local i,j,k,l,id, paths:={},all:={},dir
local name,obj,fname
local hdb,dbfile,str
local h,version,vFile,dFile1,dFile2
local remake,dStr1,dStr2
local mFiles := {;
	{"dataidx",CODB_IDXTABLE_STRUCTURE},;
	{"metaidx",CODB_DICTINDEX_STRUCTURE},;
	{"metadata",CODB_DICT_STRUCTURE},;
	{"counters",CODB_COUNTER_STRUCTURE};
	}

	k := mFiles[1][2]
	for i=1 to CODB_IDX_PER_CLASS
		str:="DATA"+alltrim(str(i,2,0))
		if i<=2
			aadd(k,{str,"X",CODB_IDX_DATALENGTH+12,0} )
		elseif i<=5
			aadd(k,{str,"X",CODB_IDX_DATALENGTH+2,0} )
		else
			aadd(k,{str,"X",CODB_ID_LEN+2,0} )
		endif
	next

	set exclusive on
	set translate path off
	set autopen on
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
		name := left(list[i],j-1)
		obj := dList:getValue(name)
		if !empty(obj:path)
			aadd(paths,obj:path)
		endif
	next
	set autopen off
	set deleted on
	for i=1 to len(paths)
		dir := directory(paths[i]+PATH_DELIM+"*","D")
		aadd(all,paths[i])
		for j=1 to len(dir)
			if len(dir[j][1]) == 2 .and. ! ("." $ dir[j][1])
				aadd(all,paths[i]+PATH_DELIM+dir[j][1])
			endif
		next
	next
	/* remake version 0.5.1 to 0.5.2*/
	for i=1 to len(all)
		vFile := all[i]+PATH_DELIM+".version"
		h := fopen(vFile)
		if h<0 .or. !file(vFile)
			loop
		endif
		version := filegetstr(h)
		fclose(h)
		? all[i],"",version,codb_version(),""
		/*
		if version==codb_version()
			loop
		endif
		*/
		for l=1 to len(mFiles)
			dFile1:= all[i]+PATH_DELIM+mfiles[l][1]
			dFile2:= all[i]+PATH_DELIM+"_"+mfiles[l][1]
			remake := .f.
			//if codb_version() > "0.5.1" .and. file(dFile1+".dbf")
			if file(dFile1+".dbf")
				select 0
				use (dFile1)
				dStr1 := dbstruct()
				use
				dStr2 := mfiles[l][2]
				for j=1 to len(dStr2)
					k := ascan(dStr1,{|x|x[1]==dStr2[j][1]})
					if k>0 .and. dstr2[j][3] > dStr1[k][3]
						remake := .t.
						dStr1[k] := aclone(dStr2[j])
					endif
					if k < 0
						remake := .t.
						aadd(dStr1,"")
						ains(dStr1,j)
						dStr1[j] := aclone(dStr2[j])
					endif
				next
			endif
			//?? version, codb_version(), codb_version() > "0.5.1", remake
			if remake
				?? "remake structure "+mfiles[l][1]
				frename(dFile1+".dbf",dFile2+".dbf")
				frename(dFile1+".fpt",dFile2+".fpt")
				dbCreate(dFile1,dStr1)
				use
				use (dFile1)
				append from (dFile2)
				use
				ferase(dFile2+".dbf")
				ferase(dFile2+".fpt")
				?? "","OK",""
			endif
		next
		********************
		dir := directory(all[i]+PATH_DELIM+"*.dbf")
		for l=1 to len(dir)
			fname := dir[l][1]
			k := atl(".",fname)
			if k>0
				fName := left(fname,k-1)
			endif
			if !(substr(fname,codb_info("DICT_ID_LEN")+1,codb_info("DEPOSIT_ID_LEN")) == "00")
				loop
			endif
			if "_" $ fname
				loop
			endif
			remake := .f.
			select 0
			use (all[i]+PATH_DELIM+fname+".dbf")
			dStr1 := dbstruct()
			use
			dStr2 := codb_info("CODB_EXTENT_STRUCTURE")
			for j=1 to len(dStr2)
				k := ascan(dStr1,{|x|x[1]==dStr2[j][1]})
				if k>0
					loop
				endif
				remake := .t.
				aadd(dStr1,"")
				ains(dStr1,j)
				dStr1[j] := aclone(dStr2[j])
			next
			//?? version, codb_version(), codb_version() > "0.5.1", remake
			if remake
				?? "remake structure "+dir[l][1]
				frename(all[i]+PATH_DELIM+fname+".dbf",all[i]+PATH_DELIM+"_"+fname+".dbf")
				frename(all[i]+PATH_DELIM+fname+".fpt",all[i]+PATH_DELIM+"_"+fname+".fpt")
				dbCreate(all[i]+PATH_DELIM+fname+".dbf",dStr1)
				use
				use (all[i]+PATH_DELIM+fname+".dbf")
				append from (all[i]+PATH_DELIM+"_"+fname+".dbf")
				use
				ferase(all[i]+PATH_DELIM+"_"+fname+".dbf")
				ferase(all[i]+PATH_DELIM+"_"+fname+".fpt")
				?? "","OK",""
			endif
		next
		h := fcreate(vFile)
		if h<0 .or. !file(vFile)
			?? "Error create file:"+vFile+":"+str(ferror())+":"+ferrorstr()
		endif
		fwrite(h,codb_version())
		fclose(h)
	next
	set autopen on
	/* remake index for dataidx */
	for i=1 to len(all)
		dir := directory(all[i]+PATH_DELIM+"*.dbf")
		for j=1 to len(dir)
			fname := all[i]+PATH_DELIM+dir[j][1]
			if ! (dir[j][1] == "dataidx.dbf" )
				loop
			endif
			? fname,""
			?? "remake indexes for dataidx.dbf",""
			ferase (all[i]+PATH_DELIM+"dataidx.cdx")
			dbfile:=all[i]+PATH_DELIM+"dataidx"
			hdb:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,.f.,.f.)
			rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"object_id","object_id")
			rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"extent_id","extent_id")
			rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"class_id" ,"class_id")
			for k=1 to CODB_IDX_PER_CLASS
				str:="data"+alltrim(str(k,2,0))
				//rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,str,str,,.t.,str+"!=NIL")
				rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,str,str,,.t.)
			next
			rddCloseArea(hDB)
			?? "","OK",""
		next
	next
	for i=1 to len(all)
		dir := directory(all[i]+PATH_DELIM+"*.dbf")
		for j=1 to len(dir)
			fname := all[i]+PATH_DELIM+dir[j][1]
			? fname,""
			if dir[j][1] == "dataidx.dbf"
				?? "dataidx",""
				ferase (all[i]+PATH_DELIM+"dataidx.cdx")
				dbfile:=all[i]+PATH_DELIM+"dataidx"
				hdb:=rddUseArea(CODB_DDRIVER_DEFAULT,dbfile,.f.,.f.)
				rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"object_id","object_id")
				rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"extent_id","extent_id")
				rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,"class_id" ,"class_id")
				for k=1 to CODB_IDX_PER_CLASS
					str:="data"+alltrim(str(k,2,0))
					//rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,str,str,,.t.,str+"!=NIL")
					rddCreateIndex(hdb,CODB_IDRIVER_DEFAULT,dbfile,str,str,,.t.)
				next
				rddCloseArea(hDB)
			endif
			use (fname)
			?? "pack",""
			pack
			?? "memopack",""
			memopack
			?? "reindex",""
			reindex
			use
			?? "","OK",""
		next
	next
return

