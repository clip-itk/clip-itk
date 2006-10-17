/*
    Copyright (C) 2005  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/* install procedure all CODB dictionaries and default data objects */
//#include "codbcfg.ch"

#include "six2clip.ch"
#include "codbcfg.ch"
#include "codb_dbf.ch"

public mFiles
memvar mFiles

local dList,list
local oDict,oDep
local i,j,k,l,tmp,id, paths:={}
local all:={},all1:={},all2:={},dir
local name,obj,fname
local hdb,dbfile,str,isDep:=.f.


	set exclusive on
	set translate path off
	set autopen on
	rddsetdefault("DBFCDX")

	fill_mfiles()

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
		if obj:type=="DBF" .and. !empty(obj:path)
			aadd(paths,obj:path)
		endif
	next
	set autopen off
	set deleted on
	for i=1 to len(paths)
		dir := directory(paths[i]+PATH_DELIM+"*","D")
		aadd(all,paths[i])
		aadd(all1,paths[i])
		for j=1 to len(dir)
			if len(dir[j][1]) == 2 .and. ! ("." $ dir[j][1])
				aadd(all,paths[i]+PATH_DELIM+dir[j][1])
				aadd(all2,paths[i]+PATH_DELIM+dir[j][1])
			endif
		next
	next

	/* check especial versions 06 -> 0.7 */
	check_60to70_version(all1,all2)
	//return

	/* check tables structures */
	check_table_stru(all)

	/* pack and memopack */
	for i=1 to len(all)
		isDep:=.f.
		dir := directory(all[i]+PATH_DELIM+"*.dbf")
		for j=1 to len(dir)
			if dir[j][1] == "dataidx.dbf"
			else
				loop
			endif
			isDep := .t.
			adel(dir,j)
			asize(dir,len(dir)-1)
			exit
		next
		if isDep
			fname := all[i]+PATH_DELIM+"dataidx"
			? fname,""
			use (fname) index (fname)
			?? "pack",""
			pack
			?? "memopack",""
			memopack
			?? "reindex",""
			reindex
			use
			fname := strtran(fname,".dbf","")
			chmod(fname+".dbf","666")
			chmod(fname+".fpt","666")
			?? "","OK",""
			*****
			select 0
			fname := all[i]+PATH_DELIM+"dataidx"
			use (fname) alias dataidx index (fname)
			set order to "object_id"
		endif
		for j=1 to len(dir)
			select 0
			fname := all[i]+PATH_DELIM+dir[j][1]
			? fname,""
			use (fname) alias extent
			if isDep  .and. !(dir[j][1] == "counters.dbf")
				?? "checking ID`s",""
				goto top
				do while !eof()
					select dataidx
					seek extent->object_id
					if dataidx->object_id==extent->object_id
					else
						select extent
						delete
						?? "delete",extent->object_id,""
					endif
					select extent
					skip
				enddo
				select extent
			endif
			?? "pack",""
			pack
			?? "memopack",""
			memopack
			use
			fname := strtran(fname,".dbf","")
			chmod(fname+".dbf","666")
			chmod(fname+".fpt","666")
			?? "","OK",""
		next
		if isDep
			select dataidx
			use
		endif
	next
	/* reindex */
	for i=1 to len(list)
		j := at(":",list[i])
		name := left(list[i],j-1)
		obj := dList:getValue(name)
		if obj:type=="DBF" .and. !empty(obj:path)
			aadd(paths,obj:path)
		endif
		oDict:=dList:connect(name)
		oDict:makeIndies(.t.)
		oDict:open()
		if !empty(oDict:error)
			? oDict:error
			return
		endif
		tmp:=oDict:select("DEPOSIT")
		for j=1 to len(tmp)
			oDep:=oDict:depository(tmp[j])
			oDep:makeIndies(.t.)
			oDep:close()
		next
		oDict:close()
	next
return

********** check
static function check_table_stru(all)
local i,j,k,x,l,h,version,vFile,dFile1,dFile2
local dir,fname
local remake,dStr1,dStr2

	for i=1 to len(all)
		vFile := all[i]+PATH_DELIM+".version"
		version := get_version(vFile)
		if empty(version)
			loop
		endif
		? all[i],"",version,codb_version(),""
		/*
		if version==codb_version()
			loop
		endif
		*/
		for l=1 to len(m->mFiles)-1
			dFile1:= all[i]+PATH_DELIM+mfiles[l][1]
			dFile2:= all[i]+PATH_DELIM+"_"+mfiles[l][1]
			remake := .f.
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
				chmod(dFile1+".dbf","666")
				chmod(dFile1+".fpt","666")
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
			dStr2 := atail(mfiles)[2]  //codb_info("CODB_EXTENT_STRUCTURE")
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
				chmod(all[i]+PATH_DELIM+fname+".dbf","666")
				chmod(all[i]+PATH_DELIM+fname+".fpt","666")
				?? "","OK",""
			endif
		next
		save_version(vFile)
	next
return
********** check
static function check_60to70_version(all1,all2)
field id,object_id,version,crc32,extent_id

	local i,j,k,l,dir,ext_id
	local hFile,vFile,oldVer
	local dFile1,dFile2,dFile3
	local rec,str

	for i=1 to len(all2)
		vFile := all2[i]+PATH_DELIM+".version"
		oldver := get_version(vFile)
		if empty(oldVer)
			loop
		endif
		? all2[i],"",oldver,codb_version(),""
		if left(oldver,5) =="0.6.5" .and. left(codb_version(),3)=="0.7"
		else
			loop
		endif
		? "Redisign data from 0.6.x to 0.7.x"
		dFile1:=all2[i]+PATH_DELIM+"reftable"
		fErase(dFile1+".cdx")
		fErase(dFile1+".dbf")

		dir := directory(all2[i]+PATH_DELIM+"*.dbf")
		for j=1 to len(dir)
			dFile3:=dir[j][1]
			dFile3 := substr(dFile3,1,len(dFile3)-4)
			if dFile3 $ "counters dataidx"
				loop
			endif
			if "_" $ dFile3
				loop
			endif
			dFile1:=all2[i]+PATH_DELIM+dFile3
			?
			fErase(dFile1+".cdx")
			remake_table(dFile1,atail(m->mfiles)[2])
		next
		? "Importing data from old structure"
		dFile2:=all2[i]+PATH_DELIM+"dataidx"
		select 0
		fErase(dFile2+".cdx")
		//outlog(dFile2+".cdx",file(dFile2+".cdx"))
		use (dFile2) alias dataidx exclusive
		//outlog(indexkey())
		index on object_id+extent_id+str(version,6,0) tag object_id to (dFile2)
		//outlog(__FILE__,__LINE__,indexkey())
		for j=1 to len(dir)
			dFile3:=dir[j][1]
			dFile3 := substr(dFile3,1,len(dFile3)-4)
			if dFile3 $ "counters dataidx"
				loop
			endif
			if "_" $ dFile3
				loop
			endif
			ext_id := dFile3
			dFile1:=all2[i]+PATH_DELIM+dFile3
			? "Import data to",dFile1
			fErase(dFile1+".cdx")
			select 0
			use (dFile1) alias extent exclusive
			//outlog(__FILE__,__LINE__, dFile1)
			do while !eof()
				str := extent->object_id+ext_id+str(extent->version,6,0)
				select dataidx
				seek  str
				if found() .and. dataidx->object_id == extent->object_id ;
					.and. dataidx->version == extent->version ;
					.and. dataidx->extent_id == ext_id

					//outlog(__FILE__,__LINE__,indexkey(), found(), extent->(recno()), dataidx->(recno()))
					//outlog(__FILE__,__LINE__, dataidx->object_id, extent->object_id, dataidx->version,extent->version,dataidx->extent_id, ext_id)
					rec := dbRead()
					if rec:version > 0
						rec:version := 0
					endif
					if rec:version < 0
						rec:version := -1
					endif
					select extent
					dbWrite(rec)
					select dataidx
					replace version with rec:version
					replace crc32 with "XXXXXXXX"
					select extent
				else
					select extent
					delete
				endif
				skip
			enddo
			?? "","OK"
			select extent
			use
		next
		select dataidx
		delete for crc32 != "XXXXXXXX"
		/*
		goto top
		dbeval({|| version := 0})
		*/
		use
		**********
		dFile2:=all2[i]+PATH_DELIM+"dataidx"
		fErase(dFile2+".cdx")
		?
		remake_table(dFile2,CODB_DEPIDX_STRUCTURE)
		**********
		save_version(vFile)
	next
	for i=1 to len(all1)
		vFile := all1[i]+PATH_DELIM+".version"
		oldver := get_version(vFile)
		if empty(oldVer)
			loop
		endif
		? all1[i],"",oldver,codb_version(),""
		if left(oldver,5) =="0.6.5" .and. left(codb_version(),3)=="0.7"
		else
			loop
		endif
		? "Redisign data from 0.6.x to 0.7.x"
		?
		dFile1:=all1[i]+PATH_DELIM+"metadata"
		remake_table(dFile1,CODB_DICT_STRUCTURE)
		dFile2:=all1[i]+PATH_DELIM+"metaidx"
		*
		? "Importing data from old structure"
		select 0
		fErase(dFile1+".cdx")
		use (dFile1) alias metadata exclusive
		select 0
		fErase(dFile2+".cdx")
		use (dFile2) alias metaidx exclusive
		index on id+str(version,6,0) tag id to (dFile2)

		select metadata
		go top
		do while !eof()
			str := metadata->id+str(metadata->version,6,0)
			select metaidx
			seek  str
			if found() .and. metaidx->id == metadata->id ;
				.and. metaidx->version == metadata->version

				rec := dbRead()
				if rec:version > 0
					rec:version := 0
				endif
				if rec:version < 0
					rec:version := -1
				endif
				select metadata
				dbWrite(rec)
			else
				select metadata
				delete
			endif
			skip
		enddo

		select metadata
		use
		select metaidx
		use
		fErase(dFile2+".cdx")
		fErase(dFile2+".dbf")

		save_version(vFile)
	next
return
*********************
static function get_version(vFile)
	local ret:="", hFile

	hFile := fopen(vFile)
	if hFile<0 .or. !file(vFile)
		return ret
	endif
	ret := filegetstr(hFile)
	fClose(hFile)
return ret
*********************
static function save_version(vFile)
	local hFile

	hFile := fcreate(vFile)
	if hFile<0 .or. !file(vFile)
		?? "Error create file:"+vFile+":"+str(ferror())+":"+ferrorstr()
		return .f.
	endif
	fwrite(hFile,codb_version())
	fclose(hFile)
	chmod(vFile,"666")
return .t.

********************* remake table
static function remake_table(dbFile,dbStru)
	local dFile1,dFile2

	dFile1:= dbFile
	dFile2:= dbFile+"_"

	ferase(dFile1+".cdx")
	ferase(dFile2+".cdx")
	?? "remake structure "+dbFile
	frename(dFile1+".dbf",dFile2+".dbf")
	frename(dFile1+".fpt",dFile2+".fpt")
	dbCreate(dFile1,dbStru)
	use
	chmod(dFile1+".dbf","666")
	chmod(dFile1+".fpt","666")
	use (dFile1)
	append from (dFile2)
	use
	ferase(dFile2+".dbf")
	ferase(dFile2+".fpt")
	?? "","OK",""
return .t.
*********************************
static function fill_mfiles()
memvar mfiles

	local i,k,x,str

	mfiles:= {;
	{"dataidx",CODB_DEPIDX_STRUCTURE},;
	{"metadata",CODB_DICT_STRUCTURE},;
	{"counters",CODB_COUNTER_STRUCTURE},;
	{"XXXXXXXX",CODB_EXTENT_STRUCTURE};
	}

	k := atail(mFiles)[2]
	x := atail(k)
	adel(k,len(k))
	asize(k,len(k)-1)
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
	aadd(k,x)
return
