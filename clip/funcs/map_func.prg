/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
static maps
static mapsList
static names	:= {}
static map_count:= 0
************************************
function mapRegister(className)
	local obj:=map()

        if empty(className) .or. valType(classname)!="C"
        	return obj
        endif
        if maps==NIL
        	maps:=map()
        endif
        if mapsList==NIL
        	mapsList:=MAP()
        endif
        className	:= upper(className)
        obj:className	:= className
        map_count++
        obj:map_ident	:= map_count
        maps[map_count]	:= obj
        obj:Destroy	:= @map_destroy()
        if !(className $ mapsList)
            aadd(names, className)
            mapsList[className]:={}
        endif
        aadd(mapsList[className],map_count)

return obj

************************************
function mapUnRegister(m)
        local map_ident, cname, ret
        if valtype(m)=="N"
        	map_ident=m
        endif
        if valtype(m)=="O"
               if "MAP_IDENT" $ m
                   map_ident:=m:map_ident
               endif
        endif
        if map_ident==NIL
        	return .f.
        endif
        cname:=maps[map_ident]:className
        adel(maps,map_ident)
        if empty(cname)
        	return .f.
        endif
        if cname $ mapsList
             ret:=ascan(mapsList[cname],{|x|x==map_ident})
             if ret!=0
                adel(mapsList[cname],ret)
                asize(mapsList[cname],len(mapsList[cname])-1)
             endif
             if len(mapsList[cname])==0
             	ret:=ascan(names,{|x|x==cName})
                if ret !=0
             	   adel(names,ret)
                   asize(names,len(names)-1)
                endif
             endif
        endif
return

************************************
function mapNames()
return names

************************************
function mapList(cname)
	local i,n,m,ret:={}
	if empty(cname) .or. valtype(cname)==NIL
        	return map()
        endif
        cname=upper(cname)
        m=mapKeys(maps)
        for i=1 to len(m)
        	if maps[m[i]]:classname==cname
                	aadd(ret,maps[m[i]])
                endif
        next
return ret

************************************
static function map_destroy(self)
return	mapUnRegister(self)

