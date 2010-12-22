/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "fileio.ch"
#include "foxsql.ch"
#include "error.ch"


//#define DEBUG_WHERE
//#define DEBUG_OPTIMIZE_WHERE
//#define DEBUG_FILTERS
//#define DEBUG_GROUP
//#define DEBUG_ORDER

function sqlQueryNew()
	local obj:=map()

        obj:classname	:= "SQLSELECT"
        obj:subQuery	:= .f. //it`s called as subquery for EXIST,ALL,ANY ?
        obj:subQueryType:= 0   // EXIST | ANY | ALL | ...
        obj:externalData:= .f. //in query expr exist access for external values
        obj:fields	:= {}  // fields info of result columns
        obj:All		:= .T. // select ALL or DISCINT
        obj:allFields	:= .T. // select ALL or DISCINT for fields list
        obj:from	:= {}  // tables info
        obj:into	:= .F.
        obj:to		:= 0   // file,printer,screen,rdd,array
        obj:filename	:= ""  // for TO operation
        obj:hFile	:= NIL // result fopen(::filename)
        obj:additive	:= .f.  // for TO operation
        obj:console	:= .T.
        obj:plain	:= .F.
        obj:wait	:= .T.
        obj:where	:= ""
        obj:filter	:= {||.t.} // codeblock as filter expessions for result table
        obj:filters	:= NIL     // filter expessions for tables
        obj:hfilter	:= {||.t.} // codeblock as filter HAVING
        obj:constants	:= {}      // constant value for IN and EXIST,ANY,ALL
        obj:group	:= ""
        obj:groupBlocks := {}	   // codeblocks for get value of fields
        obj:groupKeys   := {}	   // groups key data
        obj:having	:= ""
        obj:order	:= NIL     // list of column names for ORDER BY
        obj:functions	:= .f.  // have functions in expressions ?
        obj:gFunctions	:= .f.  // have group functions in expressions ? (SUM,COUNT,...)
        obj:heading	:= .t.  // output header with column names

        obj:__sets	:= NIL  // SET() saved values
        obj:__havingProcess := .f.

 	obj:parse	:= @sql_parse()
 	obj:parseFrom	:= @sql_parseFrom()
 	obj:parseFields	:= @sql_parseFields()
 	obj:parseGroup	:= @sql_parseGroup()
 	obj:parseOrder	:= @sql_parseOrder()
 	obj:parseTo	:= @sql_parseTo()
 	obj:parseExpr	:= @sql_parseExpr()
 	obj:logicalOptimizeExpr:= @sql_logicalOptimizeExpr()
 	obj:makeFilters	:= @sql_makeFilters()

 	obj:openDB	:= @sql_openDB()

 	obj:run		:= @sql_run()

        obj:buffer	:= {}   // buffer for result dataBase or Groups
        obj:__bufferLine:= 0    // index in buffer for group of current record
 	obj:append	:= @sql_append()     // append new result record
 					     // and update group information
 	obj:toBuffer	:= @sql_toBuffer()  // out to bufferred result record

        obj:outBuffer	:= NIL  // buffer for output
        obj:__curLine	:= -1   // output lines
 	obj:initOut	:= @sql_initOut()
 	obj:outResult	:= @sql_outResult()
 	obj:newLine	:= @dev_newLine() //CRLF or aadd() to output
 	obj:out		:= @dev_out()
 	obj:closeOut	:= @sql_closeOut()

 	obj:closeDB	:= @sql_closeDB()
        obj:destroy	:= @sql_destroy()

return obj
**************************************************************
static function sql_destroy()
	local i
	::closeOut()
        ::closeDB()
        for i in ::constants
        	if "CLASSNAME" $ i .and. i:classname=="SQLSELECT"
                	i:closeOut()
                	i:closeDB()
                endif
        next
return
**************************************************************
static function sql_parse(sQuery)
	local i,j,k,x,s,ch1,ch2,m:={}
        local keyWords:={"from","into","to","noconsole","plain","nowait",;
        		 "where","group by","having","order by"}
        /*
        i:=1
        while at("  ",sQuery)!=0 .and. i<30
        	sQuery:=strtran(sQuery,"  "," ")
                i++
        enddo
        */
        sQuery:=strtran(sQuery,";&\n","")
        sQuery:=strtran(sQuery,"&\t"," ")
        sQuery:=alltrim(sQuery)
        if lower(substr(sQuery,1,7))=="select "
        	sQuery:=alltrim(substr(sQuery,8))
        else
        	fx_sql_error("bad expression in SELECT:"+s,__LINE__)
        endif
        s:=lower(sQuery)
        for i=len(keyWords) to 1 step -1
        	k:=1
        	while .t.
        		j:=at(keyWords[i],s,k)
                	if j<=0
                        	exit
                        endif
                	ch1:=substr(s,j-1,1)
                        ch2:=substr(s,j+len(keyWords[i]),1)
                        if ch1==" " .and. (ch2==" " .or. j+len(keyWords[i]) > len(s) )
        			aadd(m,{keyWords[i],j})
                                exit
                        else
                        	k++
                        endif
                enddo
        next
        if len(m)==0
        	fx_sql_error("bad expression in SELECT:"+s,__LINE__)
        endif
        asort(m,,,{|x,y|x[2]<y[2]})
        j:=m[1][2]; s:=m[1][1]
        ::fields:=alltrim(substr(sQuery,1,j-1))
        for i=2 to len(m)+1
            x:=iif(i>len(m),len(sQuery)+2,m[i][2])
            do case
            	case s=="from"
                	::from:=substr(sQuery,j+5,x-j-6)
            	case s=="where"
                	::where:=substr(sQuery,j+6,x-j-7)
            	case s=="order by"
                	::order:=substr(sQuery,j+9,x-j-10)
            	case s=="group by"
                	::group:=substr(sQuery,j+9,x-j-10)
            	case s=="to"
                	::to:=substr(sQuery,j+3,x-j-4)
            	case s=="noconsole"
                	::console:=.f.
            	case s=="having"
                	::having:=substr(sQuery,j+7,x-j-8)
            	case s=="nowait"
                	::wait:=.f.
            	case s=="plain"
                	::plain:=.t.
            	case s=="into"
                	::into:=.t.
                	::to:=substr(sQuery,j+5,x-j-4)
            endcase
            if i>len(m)
            	exit
            endif
            j:=m[i][2]; s:=m[i][1]
        next
        if ::into
        	::plain:=.f.
        endif
return
**************************************************************
static function sql_parseFrom()
	local a,s,i,j,m
        if valtype(::from)!="C"
        	return
        endif
        if empty(::from)
        	fx_sql_error("Sql parse FROM description",__LINE__)
        endif
        s:=alltrim(::from); ::from:={}
        m:=split(s,",")
        for i=1 to len(m)
               	s:=alltrim(m[i])
               	a:=map()
               	a:hDb:=NIL
               	a:order:=i
               	j:=at(" ",s)
               	if j<=0
               		a:file:=s
                        a:alias:=upper(s)
               	else
               		a:file:=substr(s,1,j-1)
                        a:alias:=upper(substr(s,j+1))
               	endif
                j := atr("/",a:alias)
                if j<=0
                	j := atr("\",a:alias)
                endif
                if j>0
                	a:alias := substr(a:alias,j+1)
                endif
               	a:order:=len(::from)+1
               	aadd(::from,a)
        	if ::subQuery  // only first field
                	exit
                endif
        next
return
**************************************************************
static function sql_parseGroup()
	local a,s,d,x,i,j,m,tmp:={}
        if valtype(::group)!="C" .or. empty(::group)
        	return
        endif
        m:=split(alltrim(::group),",")
        if len(m) > 0
        	::groupBlocks:={}
        endif

        for i=1 to len(m)
               	s:=alltrim(m[i])
               	a:=map()
               	a:hDb:=NIL
               	a:direction:=SQL_DIRECTION_ASC
               	j:=at(".",s)
               	if j<=0
               		a:file:=::from[1]:alias
                       	a:field:=upper(s)
               	else
               		a:file:=alltrim(upper(substr(s,1,j-1)))
                       	a:field:=alltrim(upper(substr(s,j+1)))
               	endif
                d:=val(a:field)
                if d >0
                	if d > len(::fields)
                        	fx_sql_error("Error number column in GROUP BY",__LINE__)
                        endif
                        a:column := ::fields[d]:xname
                        a:file   := ::fields[d]:aname
                        a:field  := ::fields[d]:fname
                	j:=ascan(::from,{|x|x:alias==a:file})
                	if j<=0
                		fx_sql_error("Undefine table reference in GROUP BY",__LINE__)
                	endif
                        a:hDB	 := ::from[j]:hDB
                else
                	j:=ascan(::from,{|x|x:alias==a:file})
                	if j<=0
                		fx_sql_error("Undefine table reference in GROUP BY",__LINE__)
                	endif
                	d:=::from[j]
                	j:=ascan(d:dbStruct,{|x|x[1]==a:field})
                	if j<=0
	                	fx_sql_error("Undefine field name in GROUP BY",__LINE__)
        	        endif
                	j:=ascan(::fields,{|x|x:aname==a:file .and. x:fname==a:field})
                	if j>0
                		a:column := ::fields[j]:xname
                	endif
                	a:hDb:=d:hdb
                endif
                if i==1 .and. empty(::order)
                	::order:={}
                        aadd(::order,a)
                endif
                aadd(tmp,a)
        next
#ifdef DEBUG_GROUP
        ? "group tmp=",tmp
#endif
	for i in tmp
        	s:="{|x|rddGetValue("+alltrim(str(i:hDb))+",'"+i:field+"')}"
                aadd(::groupBlocks,&s)
        next
return
**************************************************************
static function sql_parseOrder()
	local a,s,d,x,i,j,m,tmp:={}
        if valtype(::order)!="C" .or. empty(::order)
        	return
        endif
        m:=split(alltrim(::order),",")
        for i=1 to len(m)
               	s:=alltrim(m[i])
               	a:=map()
               	j:=at(" ",s)
               	if j<=0
               		a:direction:=SQL_DIRECTION_ASC
                        a:field:=upper(s)
               	else
                	d:=upper(alltrim(substr(s,1,j-1)))
               		a:direction:=iif(d=="DESC",SQL_DIRECTION_DESC,SQL_DIRECTION_ASC)
                        a:field:=alltrim(upper(substr(s,j+1)))
               	endif
                // numeric value of order field
                d:=val(a:field)
                if d >0
                	if d > len(::fields)
                        	fx_sql_error("Error number column in GROUP BY",__LINE__)
                        endif
                        a:column:=::fields[d]:xname
                else
                	// name table and name field -> table.field
                	j:=at(".",a:field)
               		if j<=0
               			a:file:=::from[1]:alias
                        	a:field:=upper(a:field)
               		else
               			a:file:=alltrim(upper(substr(a:field,1,j-1)))
                        	a:field:=alltrim(upper(substr(a:field,j+1)))
               		endif
                	// search field name in ::fields
                	j:=ascan(::fields,{|x|x:aname==a:file .and. x:xname==a:field})
                        if j<=0
                        	fx_sql_error("Undefined field name in ORDER BY")
                        endif
                        a:column:=::fields[j]:xname
                endif
                aadd(tmp,a)
        next
        /*
        // generate codeblock for asort
	s:="{|x1,x2| "
	for i in tmp
        	s+="x1:"+i:column
                s+=iif(i:direction==SQL_DIRECTION_ASC,"<",">")
                s+="x2:"+i:column
                s+=" .or. "
        next
        s:=substr(s,1,len(s)-6)+"}"
        ::order:=&s
        */
        ::order:=tmp
#ifdef DEBUG_ORDER
        ? "order tmp=",tmp
        //? "codeblock=",s
#endif
return
**************************************************************
static function sql_parseTo()
	local i,s,w,fname:=""
        ::__sets:=savesets()
        if valtype(::to)!="C"
        	return
        endif
        s:=::to
        ::to:=SQL_TO_NONE
        i:=at(" ",s)
        i:=iif(i<=0,len(s)+1,i)
        w:=upper(substr(s,1,i-1))  // TO word
        s:=alltrim(substr(s,i+1))
        i:=at(" ",s)
        i:=iif(i<=0,len(s)+1,i)
        ::filename:=substr(s,1,i-1)     // if exist - filename
        s:=upper(alltrim(substr(s,i+1))) // if exist - additive
        if s=="ADDITIVE"
        	::additive:=.t.
        endif
        do case
        	case w=="FILE"
                	::to:=SQL_TO_FILE
        	case w=="CURSOR"
                	::to:=SQL_TO_CURSOR
        	case w=="DBF"
                	::to:=SQL_TO_DBF
        	case w=="TABLE"
                	::to:=SQL_TO_TABLE
        	case w=="PRINTER"
                	::to:=SQL_TO_PRINTER
        	case w=="ARRAY"
                	::to:=SQL_TO_ARRAY
        	case w=="MAP"
                	::to:=SQL_TO_MAP
        	case w=="OBJECT"
                	::to:=SQL_TO_OBJECT
        endcase
return
**************************************************************
static function sql_openDB()
	local i,j
        for i in ::from
        	if i:hDB==NIL
                	if (j:=getalias(i:file)) > 0
				i:hDB:=rddHandle(j)
				i:Open:=.f.
                        else
        			i:hDB:=rddUseArea(,i:file,.t.,.f.)
				i:Open:=.t.				
                        	if file(i:file+memoext())
        				rddSetMemo(i:hDB,,i:file)
                        	endif
                        	if file(i:file+indexext())
        				rddSetIndex(i:hDB,,i:file)
                        	endif
                        endif
                        i:dbstruct:=rddStruct(i:hDB)
                endif
        next
return
**************************************************************
static function sql_closeDB()
	local i
        if valtype(::from)=="C"
        	return
        endif
        for i in ::from
        	if i:hDB!=NIL.and.i:Open
        		rddCloseArea(i:hDB)
                        i:hDB:=NIL
                endif
        next
return
**************************************************************
static function sql_parseFields()
	local i,j,k,x,y, s, m, fname,aname,nAlias
        local hdb,xname,xnames:=map()
        local table
        if valtype(::fields)!="C"
        	return
        endif
        s:=alltrim(::fields); ::fields:={}
        if upper(substr(s,1,3))=="ALL"
        	::all:=.t.
                s:=alltrim(substr(s,4))
        endif
        if upper(substr(s,1,8))=="DISTINCT"
        	::all:=.f.
                s:=alltrim(substr(s,9))
        endif
        m:=split(s,",")
        for i=1 to len(m)
        	s:=m[i]
                while cscount("(",s) != cscount(")",s)
                	i++
                        if i<=len(m)
                		s+=","+ m[i]
                        else
                        	exit
                        endif
                enddo
                s := alltrim(s)
        	xname:=""; fname:=""; aname:=""
                if empty(s)
                	loop
                endif
                if "(" $ s  // call functions
                       	::functions:=.t.
                        s:=strtran(s,".",":")
                endif
        	j:=at(" AS ",upper(s))
        	if j>0
        		xname:=alltrim(substr(s,j+4))
                	s:=alltrim(substr(s,1,j))
        	endif
                if substr(s,1,1) == "{"
                	s:='dtoc("'+substr(s,2,len(s)-2)+'")'
                endif
                if isdigit(s)
                	j:=0
                else
        		j:=at(".",s)
                endif
        	if j>0
        		aname:=upper(alltrim(substr(s,1,j-1)))
                	fname:=alltrim(substr(s,j+1))
        	else
        		fname:=alltrim(s)
        	endif
                if !empty(aname)
                       	nAlias:=ascan(::from,{|x|x:alias==aname})
                        if nAlias<=0
        			fx_sql_error("Alias "+aname+" not found",__LINE__)
                        endif
                else
                	nAlias := 0
                endif
                if fname=="*"
                	if !empty(aname)
                        	y := { ::from[nAlias] }
                        else
                        	y := ::from
                        endif
        		for table in y
				x:=table:dbStruct
                        	for j=1 to len(x)
                        		xname:=x[j][1]
                			if ( xname $ xnames ) .and. !::allFields
                   				loop
                			endif
                			if ( xname $ xnames )
                				xnames[xname][1]++
                			else
                				xnames[xname]:={1,0}
                			endif
                                        k:=map()
                                        k:xname:=xname
                                        k:fname:=xname
                                        k:aname:=table:alias
                                        k:len  :=x[j][3]
                                        k:dec  :=x[j][4]
                                        k:order:=len(::fields)+1
                        		aadd(::fields,k)
                        	next
        		next
                        loop
                endif
                xname:=upper(xname)
        	if empty(xname)
        		xname:=upper(fname)
        	endif
        	if ( xname $ xnames ) .and. !::allFields
           		loop
        	endif
        	if ( xname $ xnames )
        		xnames[xname][1]++
        	else
        		xnames[xname]:={1,0}
        	endif
                fname:=upper(fname)
                //aname:=upper(aname)
                k:=map()
                k:xname:=upper(xname)
                k:fname:=fname
                k:aname:=aname
                k:order:=len(::fields)+1
                k:len  :=0
                k:dec  :=0
                aadd(::fields,k)
        next
        for i in ::fields      // duplicate names
        	xname:=i:xname
                if empty(i:aname) // default table
                	i:aname:=::from[1]:alias
                endif
                if "(" $ xname
                	loop
                endif
                if xnames[xname][1]>1
                      xname:=substr(xname,1,8)
             	      xname+="_"+chr(64+xnames[i:xname][2]++)
                endif
                i:xname:=xname
        next
        if !( "EXP" $ xnames )
        	xnames:exp:={1,0}
        endif
        for i in ::fields // check tables, fields, functions
                aname:=i:aname
                table:=ascan(::from,{|x|x:alias==aname})
                if table<=0
                	loop
                endif
                hdb:=::from[table]:hDB
                if hDB==NIL // error open this alias
                	loop
                endif
                xname:=i:xname
                fname:=i:fname
                m:=::from[table]:dbstruct
                j:=ascan(m,{|x|x[1]==upper(fname)})
                if j>0
                	// code block for get field data
                	s:="{|| __sql_GetValue("+;
                		alltrim(str(hDB))+;
                        	",'"+fname+"','"+xname+"')}"
                	i:len  :=m[j][3]
                	i:dec  :=m[j][4]
                	i:sblock:=s
                	i:block:=&s
                        loop
                endif

                if Upper(xname)==upper(fname)
                	i:xname:="EXP_"+chr(64+xnames:exp[2]++) //fields[i][1]
                else
                       	i:xname:=xname
                endif
                if (x:=at("(",fname))>0         // call functions
                	s:=Upper(substr(fname,1,x-1))  // function name
                        fname:=substr(fname,x+1, len(fname)-x-1)
                	j:=ascan(m,{|x|x[1]==upper(fname)})
                        if j>0
                		i:len  :=m[j][3]
                		i:dec  :=m[j][4]
                		fname:="__sql_GetValue("+;
                			alltrim(str(hDB))+;
                			",'"+fname+"','"+xname+"')"
                        endif
                        do case
                        	case s=="COUNT"
                                	if "*" $ fname
                                		::gFunctions:=.t.
                                		fname:="__sql_count(x,y,1)"
                                                i:len:=10
                                        	i:count:={}
                                        	i:enable:=.t.
                				s:="{|x,y| "+fname+"}"
                                                ::groupBlocks:={{||"count"}}
                                        else
                                		::gFunctions:=.t.
                                		fname:="__sql_count(x,y,"+fname+")"
                                                i:len:=10
                                        	i:count:={}
                                        	i:enable:=.t.
                				s:="{|x,y| "+fname+"}"
                				s:="{|x,y| "+fname+"}"
                                        endif
                        	case s=="SUM"
                                	::gFunctions:=.t.
                                	fname:="__sql_sum(x,y,"+fname+")"
                                        i:len:=max(i:len,16)
                                        i:sum:={}
                                        i:enable:=.t.
                			s:="{|x,y| "+fname+"}"
                        	case s=="MAX"
                                	::gFunctions:=.t.
                                	fname:="__sql_max(x,y,"+fname+")"
                                        i:len:=max(i:len,16)
                                        i:max:={}  //0-infinity()
                                        i:enable:=.t.
                			s:="{|x,y| "+fname+"}"
                        	case s=="MIN"
                                	::gFunctions:=.t.
                                	fname:="__sql_min(x,y,"+fname+")"
                                        i:len:=max(i:len,16)
                                        i:min:={} //infinity()
                                        i:enable:=.t.
                			s:="{|x,y| "+fname+"}"
                        	case s=="AVG"
                                	::gFunctions:=.t.
                                	fname:="__sql_avg(x,y,"+fname+")"
                                        i:len:=max(i:len,16)
                                        i:enable:=.t.
                                        i:count:={}
                                        i:sum:={}
                			s:="{|x,y| "+fname+"}"
                                otherwise
                                	fname:=s+"("+fname+")"
                			s:="{|| "+fname+"}"
                        endcase
                else 				// constant
                	s:="{|| "+fname+"}"
                endif
                i:sblock:=s
                i:block:=&s
        next
return

**************************************************************
**************************************************************
static function sql_parseExpr(self,expr)
	local fexit:=.f.,s , ch, word:="",x,y,ret:={}
        local fs1:=.f., fs2:=.f., fs3:=0, fs4:=0
        local opers:=" ( ) < <= = == >= > % ! != # <> $ ' "+' " '
        local words:=" LIKE NOT .NOT. EXIST ALL ANY SOME BETWEEN AND OR .OR. .AND. XOR .XOR. IN "
        if valtype(expr)!="C"
        	return expr
        endif
        if empty(expr)
        	return {}
        endif
        s:=alltrim(expr)+" "
#ifdef DEBUG_WHERE
        ? "w_s=",s
#endif
        while   !fexit
        	if empty(s) //.and. empty(word)
                	fexit:=.t.
                endif
        	ch:=substr(s,1,1)
                s:=substr(s,2)
#ifdef DEBUG_WHERE
                ? "w_1:",s,":",ch,":",word,":",ret
#endif
                if ! (ch $ opers) .and. ! (word $ opers ) .and. len(s)!=0
                	word+=ch
                        loop
                endif
#ifdef DEBUG_WHERE
                ? "w_2:",s,":",ch,":",word,":",ret
#endif
                if fs3>0  // function expr
                	word+=ch
                        if ch==")"
                        	fs3 --
                        endif
                        if ch=="("
                        	fs3 ++
                        endif
                        if fs3 == 0
                        	aadd(ret,word)
                                word:=""
                        endif
                       	loop
                endif
                if fs4>0  // sub query "select expr"
                        if ch==")"
                        	fs4--
                        endif
                        if ch=="("
                        	fs4++
                        endif
                        if fs4==0
                        	aadd(ret,word)
                               	word:=""
                        else
                		word+=ch
                        endif
                        loop
                endif
                /* end of string */
                if (fs1 .and. ch=='"') .or. (fs2 .and. ch=="'")
                     	aadd(ret,word+ch)
                        word:=""
                        fs1:=fs2:=.f.
                        if len(s)==0
                        	s:=""
                                fExit:=.f.
                        endif
                        loop
		endif
#ifdef DEBUG_WHERE
                ? "w_31:",s,":",ch,":",word,":",ret
#endif
                /* symbol in string */
                if fs1 .or. fs2
                	word+=ch
                        loop
                endif
#ifdef DEBUG_WHERE
                ? "w_32:",s,":",ch,":",word,":",ret
#endif
		if ch=='"'
       			fs1:=.t.
                        if empty(word)
                        	word:=ch
                        	loop
                        endif
                endif
#ifdef DEBUG_WHERE
                ? "w_33:",s,":",ch,":",word,":",ret
#endif
		if ch=="'"
       			fs2:=.t.
                        word:=ch
                        loop
                endif
#ifdef DEBUG_WHERE
                ? "w_4",":",ch,":",word,":",ret
#endif
                /* space between oper symbols "< =", "< >", "< =", "= =" */
                if !empty(word) .and. !empty(ch) .and. (alltrim(word)+ch $ opers)
                       	word=alltrim(word)+ch
                        if !empty(s)
                        	loop
                        endif
                endif
#ifdef DEBUG_WHERE
                ? "w_5",":",ch,":",'"'+word+'"',":",ret
#endif
                if !empty(word) .and. (word $ opers)
                	x:=0
                        word:=alltrim(word)
                	do case
                        	case word=="="
                                	x:=SQL_OPER_EQUAL
                        	case word=="=="
                                	x:=SQL_OPER_EXACTEQUAL
                        	case word=="!="
                                	x:=SQL_OPER_NOTEQUAL
                        	case word=="<>"
                                	x:=SQL_OPER_NOTEQUAL
                        	case word=="#"
                                	x:=SQL_OPER_NOTEQUAL
                        	case word==">"
                                	x:=SQL_OPER_GREAT
                        	case word==">="
                                	x:=SQL_OPER_GREATEQUAL
                        	case word=="<"
                                	x:=SQL_OPER_LESS
                        	case word=="%"
                                	x:=SQL_OPER_PERCENT
                        	case word=="<="
                                	x:=SQL_OPER_LESSEQUAL
                        	case word=="$"
                                	x:=SQL_OPER_IN
                                        fs4:=1
                        	case word=="("
                                	x:=SQL_OPER_GROUPOPEN
                        	case word==")"
                                	x:=SQL_OPER_GROUPCLOSE
                                otherwise
                                	? "What is it in sql query:",word
                        endcase
                        if x==SQL_OPER_GROUPOPEN .and. !empty(ret)
                        	y=atail(ret)
                                if valtype(y)=="N"
                                	// sub query
                                	if y>=SQL_OPER_EXIST .and. y<=SQL_OPER_SOME ;
                                           .or. y==SQL_OPER_IN
                                        	fs4:=1
                                        	word:=ch
                                        	loop
                                        else  // sub group
		                        	aadd(ret,x)
                                        endif

                                else  // call function
                                     	asize(ret,len(ret)-1)
                                     	word:=y+"("+ch
                                       	fs3 ++
                                        loop
                                endif
			else
                        	aadd(ret,x)
                        endif
                        word:=iif(word==ch,"",ch)
			if ch=='"'
       				fs1:=.t.
                        	word:=ch
                        	loop
                	endif
			if ch=="'"
       				fs2:=.t.
                        	word:=ch
                        	loop
                	endif
                        loop
                endif
#ifdef DEBUG_WHERE
                ? "w_6",":",ch,":",word,":",ret
#endif
		y:=" "+upper(alltrim(word))+" "
                if !empty(y) .and. upper(y) $ words
                	word:=alltrim(upper(word))
                        x:=0
                	do case
                        	case word=="NOT"
                                	x:=SQL_OPER_NOT
                        	case word==".NOT."
                                	x:=SQL_OPER_NOT
                        	case word=="AND"
                                	x:=SQL_OPER_AND
                        	case word==".AND."
                                	x:=SQL_OPER_AND
                        	case word=="OR"
                                	x:=SQL_OPER_OR
                        	case word==".OR."
                                	x:=SQL_OPER_OR
                        	case word=="XOR"
                                	x:=SQL_OPER_XOR
                        	case word==".XOR."
                                	x:=SQL_OPER_XOR
                        	case word=="LIKE"
                                	x:=SQL_OPER_LIKE
                        	case word=="BETWEEN"
                                	x:=SQL_OPER_BETWEEN

                        	case word=="EXIST"
                                	x:=SQL_OPER_EXIST
                        	case word=="ALL"
                                	x:=SQL_OPER_ALL
                        	case word=="ANY"
                                	x:=SQL_OPER_ANY
                        	case word=="SOME"
                                	x:=SQL_OPER_SOME
                        	case word=="IN"
                                	x:=SQL_OPER_IN

                                otherwise
                                	fx_sql_error("Not supported constructions:"+word,__LINE__)
                        endcase
                        aadd(ret,x)
                        word:=ch
			if ch=='"'
       				fs1:=.t.
                        	word:=ch
                        	loop
                	endif
			if ch=="'"
       				fs2:=.t.
                        	word:=ch
                        	loop
                	endif
                        loop
                endif
                if !empty(word)
                	aadd(ret,word)
                endif
#ifdef DEBUG_WHERE
                ? "w_7",":",ch,":",word,":",ret
#endif
                word:=ch
        enddo
#ifdef DEBUG_WHERE
        ? fs1,fs2,fs3,fs4
        ? "where=",ret
        quit
#endif
        if fs1 .or. fs2 .or. fs3!=0 .or. fs4!=0
        	fx_sql_error("bad expression in WHERE or HAVING:",__LINE__)
        endif
return ret
**************************************************************
static function sql_logicalOptimizeExpr(data)
	local i,j,k,x, tags:={},ltags:={}
        local word,aname,fname
        local beg,end,lexit:=.f.
        local lVal,rVal,lOper,rOper
        local onlyAnd,onlyOr
#ifdef DEBUG_OPTIMIZE_WHERE
        ? "opt data=",data
#endif
        for i=1 to len(data)
        	word:=data[i]
                // compare operation
        	if valtype(word)=="N" .and. word==SQL_OPER_BETWEEN
                	if (len(data)-i)<3
                        	fx_sql_error("Error in BETWEEN",__LINE__)
                        endif
                	if valtype(data[i+2])!="N" .or. ;
                	   data[i+2] != SQL_OPER_AND
                        	fx_sql_error("Error in BETWEEN",__LINE__)
                        endif
                        lVal:=data[i+1]
                        lVal:=&lVal
                        rVal:=data[i+3]
                        rVal:=&rVal
                        if lVal == rVal
                        	lVal:=rVal:=data[i+1]
                        else
                        	if lVal>rVal
                        		rVal:=data[i+1]
                        		lVal:=data[i+3]
                                else
                        		lVal:=data[i+1]
                        		rVal:=data[i+3]
                                endif
                        endif
                        if lVal==rVal
                     		x:=map()
                        	x:type=SQL_TAG_OPER
                        	x:oper:=SQL_OPER_EXACTEQUAL
                        	x:not:=.f.
                        	aadd(tags,x)
                                *
                     		x:=map()
                        	x:type=SQL_TAG_CONST
                                x:value:=lVal
                        	x:not:=.f.
                        	aadd(tags,x)
                        else
                        	k:=atail(tags)
                                asize(tags,len(tags)-1)
                     		x:=map()
                        	x:type=SQL_TAG_GROUP
                        	x:oper:=SQL_OPER_GROUPOPEN
                        	x:not:=.f.
                        	aadd(tags,x)
                                *
                        	aadd(tags,k)
                                *
                     		x:=map()
                        	x:type=SQL_TAG_OPER
                        	x:oper:=SQL_OPER_GREATEQUAL
                        	x:not:=.f.
                        	aadd(tags,x)
                                *
                     		x:=map()
                        	x:type=SQL_TAG_CONST
                                x:value:=lVal
                        	x:not:=.f.
                        	aadd(tags,x)
                                *
                     		x:=map()
                        	x:type=SQL_TAG_LOGICAL
                                x:oper:=SQL_OPER_AND
                        	x:not:=.f.
                        	aadd(tags,x)
                                *
                        	aadd(tags,k)
                                *
                     		x:=map()
                        	x:type=SQL_TAG_OPER
                        	x:oper:=SQL_OPER_LESSEQUAL
                        	x:not:=.f.
                        	aadd(tags,x)
                                *
                     		x:=map()
                        	x:type=SQL_TAG_CONST
                                x:value:=rVal
                        	x:not:=.f.
                        	aadd(tags,x)
                                *
                     		x:=map()
                        	x:type=SQL_TAG_GROUP
                        	x:oper:=SQL_OPER_GROUPCLOSE
                        	x:not:=.f.
                        	aadd(tags,x)
                        endif
                        i+=3
                	loop
                endif
        	if valtype(word)=="N" .and. word<=SQL_OPER_IN
                     	x:=map()
                        x:type=SQL_TAG_OPER
                        x:oper:=word
                        x:not:=.f.
                        aadd(tags,x)
                        loop
                endif
                // subquery
        	if valtype(word)=="N" .and.;
		   word >= SQL_OPER_EXIST .and. word <= SQL_OPER_SOME
                   	if i>=len(data)
                        	fx_sql_error("bad expression in WHERE:",__LINE__)
                        endif
                     	x:=map()
                        x:type=SQL_TAG_OPER
                        x:oper:=word
                        x:not:=.f.
                        aadd(tags,x)
                     	x:=map()
                        x:type=SQL_TAG_SUBQUERY
                        x:value:=data[i+1]
                        x:not:=.f.
                        aadd(tags,x)
                        i++  // next tag
                        loop
                endif
                // logical operation
        	if valtype(word)=="N" .and. ;
                   (word==SQL_OPER_GROUPOPEN .or. word==SQL_OPER_GROUPCLOSE)
                     	x:=map()
                        x:type=SQL_TAG_GROUP
                        x:oper:=word
                        x:not:=.f.
                        aadd(tags,x)
                        loop
                endif
        	if valtype(word)=="N"
                     	x:=map()
                        x:type=SQL_TAG_LOGICAL
                        x:oper:=word
                        x:not:=.f.
                        aadd(tags,x)
                        loop
                endif
                // call function
        	if valtype(word)=="C" .and. "(" $ word
                	::functions:=.t.
                     	x:=map()
                        x:type=SQL_TAG_FUNC
                        x:func:=word
                        x:not:=.f.
                        aadd(tags,x)
                        loop
                endif
        		// data for IN,ANY,ALL,SOME
        	if valtype(word)=="C"
                	if i>1 .and. valtype(data[i-1])=="N"
                		x:=data[i-1]
                                if x>=SQL_OPER_IN .and. x<=SQL_OPER_SOME
                                        if x==SQL_OPER_IN .and. "select" $ lower(word)
                                        	data[i-1]:=SQL_OPER_ANY
                                        endif
                     			x:=map()
                        		x:type=SQL_TAG_CONST
                        		x:value:=word
                        		x:not:=.f.
                        		aadd(tags,x)
                                        // it`s not IN - it`s ANY
                        		loop
                                endif
                        endif
                endif
                	// field & table names
        	if valtype(word)=="C" .and. "." $ word
                	// check for table.field
                        aname:=""; fname:=""
                	j:=at(".",word)
                        aname:=alltrim(upper(substr(word,1,j-1)))
                        fname:=alltrim(upper(substr(word,j+1)))
                        // check table in FROM
                        j:=ascan(::from,{|x|x:alias==aname} )
                        if j<=0
                        	fx_sql_error("bad table reference in WHERE:"+word,__LINE__)
                        endif
                        // check field name in table
                        k:=ascan(::from[j]:dbStruct,{|x|x[1]==fname})
                        if k<=0
                        	fx_sql_error("bad table or field reference in WHERE:"+word,__LINE__)
                        endif
                     	x:=map()
                        x:type=SQL_TAG_FIELD
                        x:table:=aname
                        x:field:=fname
                        x:hDB:=::from[j]:hDB
                        x:not:=.f.
                        x:xname := NIL
                        for k in ::fields
                               	if k:aname==aname .and. k:fname==fname
                                       	x:xname := k:xname
                                endif
                        next
                        aadd(tags,x)
                        loop
                endif
                // field name one table name
        	if valtype(word)=="C"
                	fname:=alltrim(upper(word))
                        aname:=::from[1]:alias
                        k:=ascan(::from[1]:dbStruct,{|x|x[1]==fname})
			if k>0  // field name one table name
                     		x:=map()
                        	x:type=SQL_TAG_FIELD
                        	x:table:=aname
                        	x:field:=fname
                                x:hDB:=::from[1]:hDB
                                x:not:=.f.
                                x:xname := NIL
                                for k in ::fields
                                	if k:aname==aname .and. k:fname==fname
                                        	x:xname := k:xname
                                        endif
                                next
                        	aadd(tags,x)
                                loop
                        endif
                        // constant
                     	x:=map()
                        x:type=SQL_TAG_CONST
                        x:value:=word
                        x:not:=.f.
                        aadd(tags,x)
                endif
        next
#ifdef DEBUG_OPTIMIZE_WHERE
        ? "tags="
        for i in tags
        	? i
        next
#endif
	// converting NOT and compare operation
	ltags:={}
	for i=1 to len(tags)
        	k:=tags[i]
        	if k:type!=SQL_TAG_OPER
                	aadd(ltags,k)
                	loop
                endif
                lVal:=rVal:=NIL
                if i>1
                	lVal:=tags[i-1]
                else
        		lVal:=map(); lVal:type:=SQL_TAG_CONST; lVal:value:=".t."
                endif
                if i<len(tags)
                	rVal:=tags[i+1]
                else
        		rVal:=map(); rVal:type:=SQL_TAG_CONST; rVal:value:=".t."
                endif
                if lVal:type>=SQL_TAG_FUNC
                	asize(lTags,len(lTags)-1)
                else
        		lVal:=map(); lVal:type:=SQL_TAG_CONST; lVal:value:=".t."
                endif
                if rVal:type>=SQL_TAG_FUNC
                	i++
                else
        		rVal:=map(); rVal:type:=SQL_TAG_CONST; rVal:value:=".t."
                endif
                x:=map()
                x:type:=SQL_TAG_COMPARE
                x:lvalue:=lVal
                x:rValue:=rVal
                x:oper:=k:oper
                x:not:=.f.
                aadd(lTags,x)
        next
#ifdef DEBUG_OPTIMIZE_WHERE
        ? "ltags="
        for i in ltags
        	? i
        next
#endif
        // converting logical bulev operation and delete GROUP operation
        lexit:=.f.
        while !lExit
        	lexit:=.t.
        	beg:=end:=j:=x:=0
                onlyAnd:=onlyOr:=.t.
        	for i=1 to len(ltags)
                	k:=lTags[i]
                        if k:type==SQL_TAG_COMPARE
                                if lVal:type==SQL_TAG_CONST
                        		lVal := k:rValue
                        		rVal := k:lValue
                        		k:lValue:=lVal
                        		k:rValue:=rVal
                                        k:not:= !k:not
                                endif
                        endif
                        if k:type==SQL_TAG_LOGICAL .and. k:oper==SQL_OPER_NOT
                        	if i<len(lTags)
                                	if lTags[i+1]:type!=SQL_TAG_GROUP
                                		lTags[i+1]:not:=!(lTags[i+1]:not)
                                        	adel(lTags,i)
                                        	asize(lTags,len(lTags)-1)
                                        	i--
                                        	lExit:=.f.
                                        	loop
                                        endif
                                endif
                        endif
                        if k:type!=SQL_TAG_GROUP
                        	if j!=1
                                	loop
                                endif
                                if k:type!=SQL_TAG_LOGICAL
                                	loop
                                endif
                                if k:oper!=SQL_OPER_NOT
                        		x++
                                endif
                                if k:oper==SQL_OPER_AND
                                	onlyOr:=.f.
                                endif
                                if k:oper==SQL_OPER_OR
                                	onlyAnd:=.f.
                                endif
                        endif
                        if k:oper==SQL_OPER_GROUPCLOSE
                        	j--
                                if j!=0
					loop
                                endif
                                end=i
                                if (end-beg)==2 .or. x<=1
                                	adel(lTags,end)
                                	adel(lTags,beg)
                                        asize(lTags,len(lTags)-2)
                                        i-=2
                                        lExit:=.f.
                                	beg:=end:=j:=x:=0
                                	onlyAnd:=onlyOr:=.t.
                                        loop
                                endif
                                if !onlyAnd .and. !onlyOr
                                	beg:=end:=j:=x:=0
                                	loop
                                endif
                                lOper:=rOper:=iif(onlyAnd,SQL_OPER_OR,SQL_OPER_AND)
                                if beg>1
                                	lOper:=lTags[beg-1]
                                        if lOper:type==SQL_TAG_LOGICAL
                                        	lOper:=lOper:oper
                                        else
                                        	lOper:=SQL_OPER_AND
                                        endif
                                endif
                                if end<len(ltags)
                                	rOper:=lTags[end+1]
                                        if rOper:type==SQL_TAG_LOGICAL
                                        	rOper:=rOper:oper
                                        else
                                        	rOper:=SQL_OPER_AND
                                        endif
                                endif
                                if onlyAnd .and. ;
                                  (lOper==SQL_OPER_AND .or. rOper==SQL_OPER_AND)
                                	adel(lTags,end)
                                	adel(lTags,beg)
                                        asize(lTags,len(lTags)-2)
                                        i-=2
                                        lExit:=.f.
                                endif
                                if onlyOR .and. ;
                                  (lOper==SQL_OPER_OR .or. rOper==SQL_OPER_OR)
                                	adel(lTags,end)
                                	adel(lTags,beg)
                                        asize(lTags,len(lTags)-2)
                                        i-=2
                                        lExit:=.f.
                                endif
                                onlyAnd:=onlyOr:=.t.
                                beg:=end:=j:=x:=0
                                loop
                        endif
                        if k:oper==SQL_OPER_GROUPOPEN
                        	if beg==0
                        		beg:=i
                                endif
                                j++
                        endif
        	next
        enddo
        *
#ifdef DEBUG_OPTIMIZE_WHERE
        ? "ltags1="
        for i in ltags
        	? i
        next
#endif
return ltags

**************************************************************
static function sql_makeFilters(data,onlyMain)
	local i,j,s,k,x,y,ss,ss1,ss2,fname
        local ret:={}, lValGet
        local onlyAnd:=.t.,onlyOR:=.t., functions:=.f.
        local allInOneTable:=0
        local lVal,rVal
        *
	// make filter expression for tables
        j:=0
        for k in data
                if k:type==SQL_TAG_FUNC .and. j==0
                	functions:=.t.
                endif
                if k:type==SQL_TAG_COMPARE .and. j==0
                	if k:lValue:type==SQL_TAG_FUNC
                		functions:=.t.
                        endif
                	if k:rValue:type==SQL_TAG_FUNC
                		functions:=.t.
                        endif
                endif
                if k:type==SQL_TAG_LOGICAL .and. j==0
                	if k:oper==SQL_OPER_AND
                        	onlyOr:=.f.
                        endif
                	if k:oper==SQL_OPER_OR
                        	onlyAnd:=.f.
                        endif
                endif
                if k:type==SQL_TAG_GROUP
                	if k:oper==SQL_OPER_GROUPOPEN
                        	j++
                        endif
                	if k:oper==SQL_OPER_GROUPCLOSE
                        	j--
                        endif
                endif
        next
#ifdef DEBUG_FILTERS
	? "filter data="
	for i in data
        	? i
        next
        ? "and=",onlyAnd,"or=",onlyOr, "func=",functions
#endif
        for i in ::from
        	if onlyOr .and. functions .or. onlyMain
                	aadd(ret,"")
                	exit
                endif
        	j:=0 ; s:=""
        	for k in data
                	if k:type==SQL_TAG_GROUP
                             	if k:oper==SQL_OPER_GROUPOPEN
                                	j++
                                endif
                             	if k:oper==SQL_OPER_GROUPCLOSE
                                	j--
                                endif
                                loop
                        endif
                        if j>0
                        	loop
                        endif
                        if k:type==SQL_TAG_FIELD
                        	if k:table==i:alias
                                	s+=iif(k:not,"!","")
                                        /*
                        		s+="__sql_GetValue("+alltrim(str(k:hDB))+;
                            			",'"+k:field+"','"+k:xname+"',x)"+;
                                		iif(onlyAnd," .and. "," .or.  ")
                                        */
                                        s+=k:field
                                        allInOneTable++
                                        loop
                                endif
                        endif
                        if k:type==SQL_TAG_COMPARE
                        	lVal := k:lValue
                        	rVal := k:rValue
                                if rVal:type!=SQL_TAG_CONST .or.;
				   lVal:type!=SQL_TAG_FIELD
                                   	loop
                                endif
                        	if !(lVal:table==i:alias)
                                	loop
                                endif
                                /*
                                lValGet:="__sql_GetValue("+alltrim(str(lVal:hDB))+;
                            			",'"+lval:field+"','"+lVal:xname+"',x)"
                                */
                                lValGet:=lVal:field
                                do case
                                	case k:oper==SQL_OPER_EXACTEQUAL
                                		s+=iif(k:not,"!","")+lValGet+"=="
                                        case k:oper==SQL_OPER_EQUAL
                                		s+=lValGet+iif(k:not,"!=","=")
                                        case k:oper==SQL_OPER_NOTEQUAL
                                		s+=lValGet+iif(k:not,"=","!=")
                                        case k:oper==SQL_OPER_GREAT
                                		s+=lValGet+iif(k:not,"<=",">")
                                        case k:oper==SQL_OPER_GREATEQUAL
                                		s+=lValGet+iif(k:not,"<",">=")
                                        case k:oper==SQL_OPER_LESS
                                		s+=lValGet+iif(k:not,">=","<")
                                        case k:oper==SQL_OPER_LESSEQUAL
                                		s+=lValGet+iif(k:not,">","<=")
                                        otherwise
                                        	loop
                                endcase
                                allInOneTable++
                                s+=rVal:value //+iif(onlyAnd," .and. ","  .or. ")
                        endif
                        if !empty(s)
                		if k:oper == SQL_OPER_AND
                			s+=" .and. "
                		endif
                		if k:oper == SQL_OPER_OR
                			s+=" .or.  "
                		endif
                        endif
                next
                //s:=substr(s,1,len(s)-7)
                aadd(ret,s)
#ifdef DEBUG_FILTERS
                ? "filter",i:alias,"set filter=",s
#endif
        next
        allInOneTable := (len(::from)==1 .and. allInOneTable==len(data))
        /*
        if allInOneTable .and. !onlyMain
        	ret:={}
                asize(ret,len(::from)+1)
                afill(ret,"")
                ret[len(ret)]:={||.t.}
        	return ret
        endif
        */
        *
        // make codeblock as filter for result table
        s:=""
        for k in data
        	if k:type==SQL_TAG_GROUP
                     	if k:oper==SQL_OPER_GROUPOPEN
                        	s+="("
                        endif
                     	if k:oper==SQL_OPER_GROUPCLOSE
                        	s+=")"
                        endif
                        loop
                endif
                if k:type==SQL_TAG_FIELD
                       	s+=iif(k:not,"!","")
                        s+="__sql_GetValue("+alltrim(str(k:hDB))+;
                            ",'"+k:field+"','"+iif(k:xname==NIL,"",k:xname)+"',x)"+;
                       	    iif(onlyAnd," .and. "," .or.  ")
                        loop
                endif

                if k:type==SQL_TAG_COMPARE
                	lVal := k:lValue
                	rVal := k:rValue
                        ss:=""; ss1:=""; ss2:=""
                	if lVal:type==SQL_TAG_FIELD
                        	ss1:="__sql_GetValue("+alltrim(str(lVal:hDB))+;
                            	   ",'"+lVal:field+"','"+iif(lVal:xname==NIL,"",lVal:xname)+"',x)"
                        endif
                	if lVal:type==SQL_TAG_CONST
				ss1=lVal:value
                	endif
                	if lVal:type==SQL_TAG_FUNC
				ss1=lVal:func
                        	fname:=upper(substr(ss1,1,at("(",ss1)-1))
                                if fname $ "COUNT SUM AVG MAX MIN"
					for j in ::fields
                                        	if upper(ss1)==upper(j:fname)
                                                	ss1:='__sql_getValue(NIL,NIL,"'+j:xname+'",x)'
                                                        exit
                                                endif
                                        next
                                endif
                	endif
                	if rVal:type==SQL_TAG_FIELD
                        	ss2="__sql_GetValue("+alltrim(str(rVal:hDB))+;
                            	   ",'"+rVal:field+"','"+iif(rVal:xname==NIL,"",rVal:xname)+"',x)"
                        else // SQL_TAG_CONST
				ss2=rVal:value
                	endif
                        do case
                        	case k:oper==SQL_OPER_EXACTEQUAL
                        		ss=iif(k:not,"!","")+ss1+"=="+ss2
                                case k:oper==SQL_OPER_EQUAL
                        		ss=ss1+iif(k:not,"!=","=")+ss2
                                case k:oper==SQL_OPER_NOTEQUAL
                        		ss=ss1+iif(k:not,"=","!=")+ss2
                                case k:oper==SQL_OPER_GREAT
                        		ss=ss1+iif(k:not,"<=",">")+ss2
                                case k:oper==SQL_OPER_GREATEQUAL
                        		ss=ss1+iif(k:not,"<",">=")+ss2
                                case k:oper==SQL_OPER_LESS
                        		ss=ss1+iif(k:not,">=","<")+ss2
                        	case k:oper==SQL_OPER_PERCENT
                        		ss=iif(k:not,"!","")+ss1+"%"+ss2
                                case k:oper==SQL_OPER_LESSEQUAL
                        		ss=ss1+iif(k:not,">","<=")+ss2
				case k:oper==SQL_OPER_LIKE
                        		ss=iif(k:not,"!","")+"search("+ss2+","+ss1+")"
				case k:oper==SQL_OPER_IN
                                	// make constant
                                	x:=split(rVal:value,",")
                                        y:=map()
                                        for j=1 to len(x)
                                        	x[j]:=&(x[j])
                                                y[ x[j] ]:=x[j]
                                        next
                                        aadd(::constants,y)
                        		//ss=iif(k:not,"!","")+ss1+" $ __self:constants["+alltrim(str(len(::constants)))+"]"
                        		ss=iif(k:not,"!","")+"__sql_run_subQuery(__self:constants["+alltrim(str(len(::constants)))+"],"+ss1+")"
				case k:oper==SQL_OPER_EXIST
                                	y:=makeSqlSubSelect(SQL_OPER_EXIST,ss2,ss1)
                                        aadd(::constants,y)
                        		ss=iif(k:not,"!","")+"__sql_run_subQuery(__self:constants["+alltrim(str(len(::constants)))+"],"+ss1+")"
				case k:oper==SQL_OPER_ALL
                                	y:=makeSqlSubSelect(SQL_OPER_ALL,ss2,ss1)
                                        aadd(::constants,y)
                        		ss=iif(k:not,"!","")+"__sql_run_subQuery(__self:constants["+alltrim(str(len(::constants)))+"],"+ss1+")"
				case k:oper==SQL_OPER_ANY
                                	y:=makeSqlSubSelect(SQL_OPER_ANY,ss2,ss1)
                                        aadd(::constants,y)
                        		ss=iif(k:not,"!","")+"__sql_run_subQuery(__self:constants["+alltrim(str(len(::constants)))+"],"+ss1+")"
				case k:oper==SQL_OPER_SOME
                                	y:=makeSqlSubSelect(SQL_OPER_SOME,ss2,ss1)
                                        aadd(::constants,y)
                        		ss=iif(k:not,"!","")+"__sql_run_subQuery(__self:constants["+alltrim(str(len(::constants)))+"],"+ss1+")"
                                otherwise
                                /*
                                	error ???
                                // between converted to AND
				case k:oper==SQL_OPER_NOTBETWEEN
				case k:oper==SQL_OPER_BETWEEN
                                */
                        endcase
                        s+=ss//+iif(onlyAnd .or. k:oper==SQL_OPER_AND," .and. ","  .or. ")
                endif
                if "OPER" $ k
                	if k:oper == SQL_OPER_AND
                		s+=" .and. "
                	endif
                	if k:oper == SQL_OPER_OR
                		s+=" .or.  "
                	endif
                endif
                //s+=iif(onlyAnd .or. k:oper==SQL_OPER_AND," .and. ","  .or. ")
        next
        //s:=substr(s,1,len(s)-7)
        if empty(s)
        	s:="{|| .t. }"
        else
        	s:="{|x,y|"+s+"}"
        endif
        aadd(ret,&s)
#ifdef DEBUG_FILTERS
        ? "filter for result table=",s
#endif

return ret

**************************************************************
**************************************************************
**************************************************************
static function sql_initOut()
	local i,ii,iii,aname,data,fname,mstru:={}
        local s
        i:=::to
        if i==SQL_TO_CURSOR .or. i==SQL_TO_DBF
        	for ii=1 to len(::from)
        		aname:=::from[ii]
        		rddGoTop(aname:hDb)
                        data:=rddRead(aname:hDB)
                	private &(aname:file):=data
                	s:=aname:dbStruct
                        for iii in s
                        	private &(iii[1]):=data[ iii[1] ]
                        next
        	next
        	for i in ::fields
			data:=eval(i:block)
                	//aadd(mstru,{i:xname,valtype(data),len(data),dec(data)})
                        i:len := max(i:len,len(data))
                        i:dec := max(i:dec,dec(data))
                	aadd(mstru,{i:xname,valtype(data),i:len,i:dec})
        	next
        endif
        set console (::console)
	do case
                case ::to==SQL_TO_NONE
                        ::outBuffer:=""
        	case ::to==SQL_TO_PRINTER
                	set device to printer
                        set printer on
                        ::outBuffer:=""
        	case ::to==SQL_TO_FILE
                	if ::additive .and. file(::filename)
                		::hfile:=fopen(::filename,FO_WRITE)
                        else
                        	::hfile:=fcreate(::filename,FC_NORMAL)
                        endif
                        if ::hfile<0
                        	fx_sql_error("Cannot open output file:"+::filename,__LINE__)
                        endif
                        if ::additive
                        	fseek(::hFile,0,FS_END)
                        endif
                        ::newLine :=@file_newLine()
                        ::out    :=@file_out()
                        ::heading:=.f.
                        ::outBuffer:=""
        	case ::to==SQL_TO_CURSOR
                	fname:=tmpfile()
                        dbcreate(fname,mstru)
                        use (fname) alias (::fileName) exclusive temporary new
                        ::newLine :=@tbl_newLine()
                        ::out    :=@tbl_out()
                        ::heading:=.f.
                        ::outBuffer:=map()
        	case ::to==SQL_TO_DBF
                        dbcreate(::filename,mstru)
                        use (::filename) new
                        ::newLine :=@tbl_newLine()
                        ::out    :=@tbl_out()
                        ::heading:=.f.
                        ::outBuffer:=map()
        	case ::to==SQL_TO_TABLE
                        dbcreate(::filename,mstru)
                        use (::filename) new
                        ::newLine :=@tbl_newLine()
                        ::out    :=@tbl_out()
                        ::heading:=.f.
                        ::outBuffer:=map()
        	case ::to==SQL_TO_ARRAY
                	&(::filename):={}
                        ::newLine  :=@arr_newLine()
                        ::out     :=@arr_out()
                        ::heading :=.f.
                        ::outBuffer  :={}
        	case ::to==SQL_TO_MAP
                	&(::filename):=map()
                        data:=&(::filename)
        		for i in ::fields
				data[i:xname]:={}
                        next
                        ::newLine  :=@map_newLine()
                        ::out     :=@map_out()
                        ::heading :=.f.
                        ::outBuffer  :=map()
        	case ::to==SQL_TO_ANYMAP
                        ::newLine  :=@anymap_newLine()
                        ::out     :=@anymap_out()
                        ::heading :=.f.
                	::outBuffer  :=map()
        endcase
return
**************************************************************
static function sql_closeOut()
	if ::hFile!=NIL
        	fclose(::hFile)
                ::hFile:=NIL
        endif
        if ::__sets!=NIL
        	restoreSets(::__sets)
                ::__sets:=NIL
        endif
return
**************************************************************
**************************************************************
static function empty_newLine()
return
**************************************************************
static function empty_out(colInfo,value)
return
**************************************************************
**************************************************************
static function dev_newLine()
	::__curLine++
	if ::console .and. ::wait ;
		.and. ( ::__curLine % (maxrow()-1)==0 ) ;
                .and. ::__curLine>0
        	wait [Press any key to continue]
        endif
        if ::__curLine==0
        	if !::plain //.and. !::into
			?
        	endif
        else
        	? ::outBuffer
                ::outBuffer:=""
        endif
return
**************************************************************
static function dev_out(colInfo,value)
	::outBuffer+=padr(toString(value,colInfo:len,colInfo:dec),colInfo:len)+" "
return
**************************************************************
**************************************************************
static function file_newLine()
	::__curLine++
        if ::__curLine==0
        	if !::plain //.and. !::into
       			fwrite(::hfile,CRLF)
        	endif
        else
       		fwrite(::hfile,CRLF+::outBuffer)
                ::outBuffer:=""
        endif
return
**************************************************************
static function file_out(colInfo,value)
	::outBuffer+=padr(toString(value,colInfo:len,colInfo:dec),colInfo:len)+" "
return
**************************************************************
**************************************************************
static function tbl_newLine()
	if !empty(::outBuffer)
		append blank
        	dbWrite(::outBuffer)
        	::outBuffer:=map()
        endif
return
**************************************************************
static function tbl_out(colInfo,value)
        ::outBuffer[colInfo:xname]:=value
return
**************************************************************
**************************************************************
static function arr_newLine()
	local s
	::__curLine++
        if ::__curLine<=0
        	return
        endif
        s:="m->"+::filename
        aadd(&s,::outBuffer)
        ::outBuffer:={}
return
**************************************************************
static function arr_out(colInfo,value)
	aadd(::outBuffer,value)
return
**************************************************************
**************************************************************
static function map_newLine()
	local s,i
	::__curLine++
        if ::__curLine<=0
        	return
        endif
        s:="m->"+::filename
        s:=&s
        for i in s  KEYS
		aadd(s[i],::outBuffer[i])
        next
        ::outBuffer:=map()
return
**************************************************************
static function map_out(colInfo,value)
        ::outBuffer[colInfo:xname]:=value
return
**************************************************************
**************************************************************
static function anymap_newLine(self)
	/*
        	noting to do
        */
return
**************************************************************
static function anymap_out(colInfo,value)
        ::outBuffer[value]:=value
return
**************************************************************
static function sql_append()
	local i,j,m,tmp:={}
	if len(::groupBlocks)>0
        	// get data for group fields
        	for i in ::groupBlocks
                	aadd(tmp,eval(i))
                next
                // search group key and number of record
                ::__bufferLine:=0
                for i=1 to len(::groupKeys)
                	m:=::groupKeys[i]
                 	for j=1 to len(tmp)
                        	if ! (m[j]==tmp[j])
                                	exit
                                endif
                        next
                        if j>len(tmp)
                        	::__bufferLine:=i
                                exit
                        endif
                next
                if ::__bufferLine==0
                	aadd(::groupKeys,tmp)
                        aadd(::buffer,map())
                        ::__bufferLine:=len(::groupKeys)
                endif
        else
        	if ::gFunctions
                	::__bufferLine:=1
                        if len(::groupKeys)==0
                        	aadd(::groupKeys,.t.)
                                aadd(::buffer,map() )
                        endif
                else
                	//outlog(__FILE__,__LINE__,len(::groupKeys))//,::groupKeys)
                        aadd(::groupKeys,.t.)
                	//outlog(__FILE__,__LINE__,len(::groupKeys),len(::buffer))//,::groupKeys)
                        aadd(::buffer,map() )
                	//outlog(__FILE__,__LINE__,len(::buffer))//,::groupKeys)
                	::__bufferLine:=len(::groupKeys)
                	//outlog(__FILE__,__LINE__,len(::__bufferLine))//,::groupKeys)
                endif
        endif
        //outlog(__FILE__,__LINE__,len(::__bufferLine))//,::groupKeys)
return
**************************************************************
static function sql_toBuffer(colInfo,value)
        ::buffer[::__bufferLine][colInfo:xname]:=value
return
**************************************************************
static function sql_run(self)
	local aname,i,ii,s,data

 	private __self:=self // for use self in subqueries

        if self:subQuery .and. !self:externalData .and. !empty(self:outBuffer)
        	return
        endif

        for ii=1 to len(self:from)
        	aname:=self:from[ii]
                if !empty(self:filters[ii])
        		rddSetFilter(aname:hDb,self:filters[ii])
                endif
        	rddGoTop(aname:hDb)
                if self:functions  // create private variables for fields
                        data:=rddRead(aname:hDB)
                	private &(aname:file):=data
                	s:=aname:dbStruct
                        for i in s
                        	private &(i[1]):=data[ i[1] ]
                        next
                endif
        next
        for s in self:fields
		data:=eval(s:block)
               	s:len:=max(s:len, max(len(data), iif(self:to == SQL_TO_DBF,1,len(s:xname) ) ) )
               	s:dec:=max(dec(data),s:dec)
        next

	out_recursive(self,1)

	if !empty(self:order)
		asort(self:buffer,,,{|x1,x2|__sql_order_by(self:order,x1,x2)})
        endif

return
**************************************************************
static function out_recursive(self,level)
	local data,idata,stru,i,j,maxLevel:=len(self:from)
        local hdb:=self:from[level]:hDB

        rddGotop(hdb)

       	while !rddEof(hdb)
                if self:functions
                       	data:=rddread(hdb)
                       	memvarSet(self:from[level]:file,data)
                        for i in self:from[level]:dbStruct
                        	memvarSet(i[1],data[ i[1] ])
                        next
                endif
                if level==maxLevel .and. eval(self:filter) //.and. eval(self:hFilter)
       			self:append()
       			for i in self:fields
                        	idata:=eval(i:block,i,self:__bufferLine)
	                	i:len:=max(len(idata),i:len)
	                	i:dec:=max(dec(idata),i:dec)
               			self:toBuffer(i,idata)
       			next
                endif
                if level<maxLevel
			out_recursive(self,Level+1)
                endif
               	rddSkip(hdb)
       	enddo
return
**************************************************************
static function sql_outResult(self)
	local i,iii,ii,s,data
        /*
        	don`t remake result of query and return old data
                for subQueries as EXIST,ANY,ALL
        */
        if self:subQuery .and. !self:externalData .and. !empty(self:outBuffer)
        	return self:outBuffer
        endif

	self:initOut()
        self:__havingProcess:=.t.

        if self:heading .and. !self:plain //.and. !self:into
		self:newLine()  // out header
        endif

        for s in self:fields
        	s:enable:=.f.
                if self:heading .and. !self:plain //.and. !self:into
                	self:out(s,s:xname)
                endif
        next

	iii:=1
        self:__bufferLine:=0
        for i in self:buffer

        	self:__bufferLine++
                if !eval(self:hFilter,self,self:__bufferLine)
                	loop
                endif
        	self:newLine()
        	for ii in self:fields
                	self:out(ii,i[ii:xname])
                next
        next

	if !empty(self:outBuffer)
		self:newLine()
        endif

	self:closeOut()

        if self:subQuery
        	return self:outBuffer
        endif
return

*********************************************
* internal function for SQL query
*********************************************
function __sql_sum(self,group_id,value)
	local i
        if valtype(self)!="O" .or. group_id==NIL .or. group_id<=0
        	return 0.00
        endif
        if len(self:sum)<group_id
               	for i=len(self:sum) to group_id
                	aadd(self:sum,0.00)
                next
        endif
	if valType(value)=="N" .and. self:enable
        	self:sum[group_id]+=value
        endif
return self:sum[group_id]
*********************************************
function __sql_count(self,group_id,value)
	local i
        if valtype(self)!="O" .or. group_id==NIL .or. group_id<=0
        	return 0.00
        endif
        if len(self:count)<group_id
               	for i=len(self:count) to group_id
                	aadd(self:count,0.00)
                next
        endif
	//if valType(value)=="N" .and. self:enable
	if !empty(value) .and. self:enable
        	self:count[group_id]++
        endif
return self:count[group_id]
*********************************************
function __sql_max(self,group_id,value)
	local i
        if valtype(self)!="O" .or. group_id==NIL .or. group_id<=0
        	return 0.00
        endif
        if len(self:max)<group_id
               	for i=len(self:max) to group_id
                	aadd(self:max,0.00-infinity())
                next
        endif
	if valType(value)=="N" .and. self:enable
        	self:max[group_id]=max(self:max[group_id],value)
        endif
return self:max[group_id]
*********************************************
function __sql_min(self,group_id,value)
	local i
        if valtype(self)!="O" .or. group_id==NIL .or. group_id<=0
        	return 0.00
        endif
        if len(self:min)<group_id
               	for i=len(self:min) to group_id
                	aadd(self:min,infinity())
                next
        endif
	if valType(value)=="N" .and. self:enable
        	self:min[group_id]=min(self:min[group_id],value)
        endif
return self:min[group_id]
*********************************************
function __sql_avg(self,group_id,value)
	local i
        if valtype(self)!="O" .or. group_id==NIL .or. group_id<=0
        	return 0.00
        endif
        if len(self:count)<group_id
               	for i=len(self:count) to group_id
                	aadd(self:count,0.00)
                	aadd(self:sum,0.00)
                next
        endif
	if valType(value)=="N" .and. self:enable
        	self:count[group_id]++
        	self:sum[group_id]+=value
        endif
return self:sum[group_id]/self:count[group_id]
*********************************************
static function fx_sql_error(message,line)
	local i:=errorNew()
        outlog(3,__FILE__,__LINE__,procname(1),procline(1))
        outlog(3,__FILE__,__LINE__,procname(2),procline(2))
        outlog(3,__FILE__,__LINE__,procname(3),procline(3))
	i:description:="Sql syntax error "
        i:genCode:=EG_SYNTAX
        i:operation:=message
        i:filename:=__FILE__
        i:subSystem:="SQL"
        i:subCode:=line
        //break(i)
        eval(errorblock(),i)
return
*********************************************
static function __sql_order_by(orderInfo,x1,x2)
	local i,c
        for i in orderInfo
        	c:=i:column
		if x1[c]==x2[c]
                else
                	if i:direction==SQL_DIRECTION_ASC
                        	return x1[c]<x2[c]
                        else
                        	return x1[c]>x2[c]
                        endif
                endif
        next
return .f.
*********************************************
function __sql_fieldDesc(self,xname)
	local f
        for f in self:fields
        	if f:xname == xname
                	return f
                endif
        next
return NIL
*********************************************
function __sql_getValue(hDB,fname,xname,self)
	if self!=NIL .and. self:__havingProcess
        	return self:buffer[self:__bufferLine][xname]
        endif
return rddGetValue(hDb,fname)
*********************************************
*********************************************
*********************************************
function __sql_run_subQuery(data,value)
	local m, oper:=SQL_OPER_IN
        local i,ret:=.f.
	if data==NIL .or. empty(data)
        	return ret
        endif
        if valtype(data)=="O"
        	if "CLASSNAME" $ data .and. data:classname=="SQLSELECT"
                	data:run()
                	m:=data:outResult()
                        oper:=data:subQueryType
                else
                	m:=data
                endif
        else
        	return value==data
        endif
        do case
        	case oper==SQL_OPER_IN
                	ret:= ( value $ m)
                	for i in m
                        	if i==value
                                   	ret:=.t.
                                        exit
                                endif
                        next
        	case oper==SQL_OPER_ANY
                	ret:= ( value $ m)
                	for i in m
                        	if i==value
                                   	ret:=.t.
                                        exit
                                endif
                        next
        	case oper==SQL_OPER_SOME
                	ret:= ( value $ m)
                	for i in m
                        	if i==value
                                   	ret:=.t.
                                        exit
                                endif
                        next
        	case oper==SQL_OPER_EXIST
                	ret:= empty(m)
        	case oper==SQL_OPER_ALL
                	ret:=.t.
                        for i in m
                        	if !(i==value)
                                	ret:=.f.
                                        exit
                                endif
                        next
        endcase
return ret
*********************************************
static function makeSqlSubSelect(type,sQuery,value)
	local oQuery:=sqlQueryNew()
        local tmp
        oQuery:subQuery:=.t.
        oQuery:subQueryType:=type
        oQuery:parse(sQuery)
        oQuery:parseFrom()
        oQuery:parseTo()
        oQuery:openDB()
        oQuery:parseFields()
        oQuery:parseGroup()
        oQuery:parseOrder()
        oQuery:where:=oQuery:parseExpr(oQuery:where)
        oQuery:where:=oQuery:logicalOptimizeExpr(oQuery:where)
        tmp:=oQuery:makeFilters(oQuery:where,.f.)
        oQuery:filter:=atail(tmp)
        asize(tmp,len(tmp)-1)
        oQuery:filters:=tmp
        oQuery:having:=oQuery:parseExpr(oQuery:having)
        oQuery:having:=oQuery:logicalOptimizeExpr(oQuery:having)
        tmp:=oQuery:makeFilters(oQuery:having,.t.)
        oQuery:hFilter:=atail(tmp)

        oQuery:header:=.f.
        oQuery:to:=SQL_TO_ANYMAP
return oQuery


