/*-------------------------------------------------------------------------*/
/*   This is main part of library libcodb_query                            */
/*                                                                         */
/*   Copyright (C) 2005-2007 by E/AS Software Foundation                   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include <codb_dbf.ch>

/** Library for database manipulation in console mode */
/*
    TODO:
	- WHERE in SELECT statement: translate logical operation and quotes
	- export/import
	- use file content as command list
	- SET DBF CHARSET TO <>
	- Error updating name of metaobject in codb
	- Different docs about codb utility
	- usage of ';' in strings
	- DROP DATABASE <db>
	
	- FIXME: Got all records while searching by non-indexing fields (but in codb_ab search as well!)
*/

/* First key list */
static cmdList := { ;
	{ "help", 		@ec_help(), 	"Help about database commands" }, ;
	{ "create", 	@ec_create(),   "Create metaobject" }, ;
	{ "delete", 	@ec_delete(),   "Delete object or metaobject" }, ;
	{ "describe", 	@ec_describe(), "Show class structure" }, ;
	{ "drop", 		@ec_drop(), 	"Delete metaobject by its name" }, ;
	{ "get", 		@ec_get(),  	"Get object from depository" }, ;
	{ "metaget", 	@ec_metaget(), 	"Get metaobject" }, ;
	{ "metaput", 	@ec_metaput(), 	"Create or update metaobject" }, ;
	{ "put", 		@ec_put(),  	"Create or update object in depository" }, ;
	{ "select", 	@ec_select(), 	"Query object attributes" }, ;
	{ "show", 		@ec_show(), 	"Show list of metaobjects" }, ;
	{ "use",  		@ec_use(),  	"Open database" } ;
}
	
/* Metaclasses types */
static aMClasses := { ;
	{'databases', 	'', 	   'Show all available databases'} , ; 
	{'depositories', 'DEPOSIT', 'Show all depositories'} , ; 
	{'extents', 	'EXTENT',  'Show all extended attributes'} , ; 
	{'attributes', 	'ATTR',    'Show all attributes for classes'} , ; 
	{'counters',	'COUNTER', 'Show all counters'} , ; 
	{'indexes', 	'INDEX',   'Show all indexes'} , ; 
	{'classes', 	'CLASS',   'Show all classes'} , ; 
	{'tcolumns', 	'TCOLUMN', 'Show all columns for views'} , ; 
	{'tviews', 		'TVIEW',   'Show all views'} , ; 
	{'reports', 	'REPORT',  'Show all reports'} , ; 
	{'plugins', 	'PLUGINS', 'Show all database plugins'} , ; 
	{'users', 		'USER',    'Show all database users'} , ; 
	{'groups', 		'GROUP',   'Show all database user groups'},  ; 
	{'statistics', 	'',        'Counts all metaclass objects'}  ; 
}

/* Metaclasses name for 'DESCRIBE' */
static aMClassesDesc := { ;
	{'depository', 	'DEPOSIT', 'Show depository metaclass structure'} , ; 
	{'extent', 		'EXTENT',  'Show extended attribute metaclass structure'} , ; 
	{'attribute', 	'ATTR',    'Show attribute metaclass structure'} , ; 
	{'counter',		'COUNTER', 'Show counter metaclass structure'} , ; 
	{'index', 		'INDEX',   'Show index metaclass structure'} , ; 
	{'class', 		'CLASS',   'Show class metaclass structure'} , ; 
	{'tcolumn', 	'TCOLUMN', 'Show column for view metaclass structure'} , ; 
	{'tview', 		'TVIEW',   'Show view metaclass structure'} , ; 
	{'report', 		'REPORT',  'Show report metaclass structure'} , ; 
	{'plugin', 		'PLUGINS', 'Show database plugin metaclass structure'} , ; 
	{'user', 		'USER',    'Show database user metaclass structure'} , ; 
	{'group', 		'GROUP',   'Show database user group metaclass structure'}  ; 
}

/* Attributes of metaclasses */
static codbMetaAttr := { ;
	{ "GROUP", 		CODB_GROUP_BODY }, ;
	{ "USER",		CODB_USER_BODY }, ;
	{ "EXTENT",		CODB_EXTENT_BODY }, ;
	{ "DEPOSIT",	CODB_DEPOSIT_BODY }, ;
	{ "ATTR",		CODB_ATTR_BODY }, ;
	{ "CLASS",		CODB_CLASS_BODY }, ;
	{ "TVIEW",		CODB_TVIEW_BODY }, ;
	{ "TCOLUMN",	CODB_TCOLUMN_BODY }, ;
	{ "REPORT",		CODB_REPORT_BODY }, ;
	{ "PLUGINS",	CODB_PLUGINS_BODY }, ;
	{ "INDEX",		CODB_INDEX_BODY }, ;
	{ "COUNTER",	CODB_COUNTER_BODY } ;
}

function CODB_Client( connect_string )
	local obj
	
	obj := map()
	obj:className := "CODB_Client"
	obj:error := NIL
	
	obj:connect_string := connect_string
	obj:dict := NIL
	obj:dep  := NIL
	
	obj:dict_list := array(0)
	obj:dep_list  := array(0)

return obj

function CODB_Result( data )
	local obj
	
	obj := map()
	obj:className := "CODB_Result"
	
	obj:answer    := "OK"
	obj:fields    := array(0)
	obj:data      := data
	
	obj:error     := NIL 
	obj:columns   := 0
	obj:rows      := 0
	obj:affected  := map() // Affected records
	obj:affected:type  := 'N' // N - none, C - created, D - deleted, M - modified
	obj:affected:class := ''
	obj:affected:list  := array(0)
	obj:affected:db    := ''
	
return obj

/* Connect to server */
function codb_connect( connect_string )
	local oErr, o, dbh, dbl, i, pos, cDB, cDBPath, cDBDesc, curDB
	local dict, depl, j, dep, dep_new, dep_content, name
	
	o := CODB_Client(connect_string)
	set deleted on
	set translate path off
	
	oErr := ErrorBlock({|e| break(e) })

	if .not. isFunction("codb_needDepository")
                o:error := 'CODB library not linked'
                return o
        endif
	
	begin sequence
		dbh := codbListNew()
		if val(dbh:error) > 0
			o:error = "Cannot open database list: "+dbh:error
			return o
		endif
		dbl := dbh:list()
		for i in dbl
			pos := at(':',i)
			cDB := left(i,pos-1)
			dict := dbh:connect(cDB)

			if .not. val(dict:error) > 0 .and. dict:open()
				cDBPath := iif(empty(dict),"",dict:path)
				cDBDesc := substr(i,pos+1)
				
				// Append to databases list
				dep_new := NIL
				aadd(o:dict_list, { cDB, dict, dep_new, cDBPath, cDBDesc } )
				curDB := len(o:dict_list)
			
				// Fill depositories list
				depl := dict:select("DEPOSIT")
				for j in depl
					dep_content := dict:getValue( j )
					name = cDB + dep_content:number
					dep := coDepository():new(j)
					if val(dict:error) <= 0 .and. dep:open()
						if dep_new == NIL
							dep_new := dep
						endif
						aadd(o:dep_list, { name, dep, curDB } )
						// Open all extents for safe thread
						dep:extentOpenAll()
						//?? "Opened depository:", name, chr(10)
					endif
				next
				o:dict_list[curDB][3] := dep_new
			//else
			//	?? dict:error,chr(10)
			endif
		next
	recover using oErr
		o:error = "Error open database list: "+errorMessage(oErr)
		return o
	end sequence
	
return o

/* Internal function for setting up db by its name */
static function __set_db(self, db)
	local p, i

//	?? "Set DB:", db, chr(10)
	
	if empty(db)
		return .F.
	endif

	p := ascan(self:dict_list, {|e| e[1] == db })
	if p > 0
		self:dict := self:dict_list[p][2]
		self:dep  := self:dict_list[p][3] // Use default depository
	else
		p := ascan(self:dep_list, {|e| e[1] == db })
		if p > 0
			self:dict := self:dict_list[self:dep_list[p][3]][2]
			self:dep  := self:dep_list[p][2]
		else
			?? "ERROR: unknown DB or depository name:", db, chr(10)
		endif
	endif
//	?? "DICT:", self:dict, chr(10)
//	?? "DEP: ", self:dep,chr(10)
return .F.

/* Close connection to server */
function codb_close( self )
	local i
	//?? "CLOSE DATABASE.&\n"	
	if valtype(self) != 'O' .or. ( "CLASSNAME" $ self .and. self:className != "CODB_Client")
		return .F.		
	endif

	// Close depositories if open
	for i=1 to len(self:dep_list)
		self:dep_list[i][2]:close()
	next

	// Close dictionaries if open
	for i=1 to len(self:dict_list)
		self:dict_list[i][2]:close()
	next
	
	set deleted off

return .T.

/* Execute database command */
function codb_execute( self, cmd, db, files )
	local oErr, a:=array(0), r, i, key, ret, is_string:=.F., is_comment:=.F., p, part:= '', pos
	
	// Create result object
	r := CODB_Result()
	r:affected:db := db

	if valtype(self) != 'O' .or. ( "CLASSNAME" $ self .and. self:className != "CODB_Client")
		r:answer := "ERROR"
		r:error  := "Connection is not open. Use 'codb_connect()' first."
		return r		
	endif

	// Set database
	__set_db(self, db)
		
	oErr := ErrorBlock({|e| break(e) })
	
	begin sequence
		if empty(cmd)
			r:answer := "ERROR"
			r:error  := NIL
			return r		
		endif
		
		if right(cmd,1) == ';'
			cmd := left(cmd,len(cmd)-1) // Remove trailing ';'
		endif
		
		cmd  := alltrim(cmd)
		//?? "CMD(C):",cmd,chr(10)
		for i:=1 to len(cmd)
			if cmd[i]=="'" .and. (i==1 .or. cmd[i-1]!='&\\')
				is_string := .not. is_string
				if .not. is_string
					aadd( a, part )
					part := ''
				endif
				loop
			endif
			
			if is_string
				part := part + cmd[i]
				loop
			endif
			
			// Process comments
			if cmd[i] == '#' 
				is_comment := .T.
			endif
			if cmd[i] == "&\n" .and. is_comment
				is_comment := .F.
			endif
			
			if cmd[i] $  " &\t&\n,"
				if i>1 .and. .not. cmd[i-1] $  " &\t&\n,"
					aadd( a, part )
					part := ''
				endif
				pos := i+1
			elseif .not. is_comment
				part := part + cmd[i]
			endif
		next
		if len(part) > 0
			aadd( a, part )
		endif
		//?? "CMD(A):",a,chr(10)
		for i:=1 to len(a)
			if left(a[i],1) == "'" .and. right(a[i],1) == "'"
				a[i] := substr(a[i],2,len(a[i])-2)
			endif
		next
		
		key := a[1]
		
		// Lookup command
		for i in cmdList
			if lower(key) == i[1]
				ret := eval( i[2], self, a, r, files )
				if ret != NIL
					r:answer := "ERROR"
					r:error  := ret
				endif
				//?? "RESULT:", r, chr(10)
				return r
			endif
		next
		r:answer := "ERROR"
		r:error  := "Unknown command '"+key+"'."
	recover using oErr
		//?? oErr,chr(10)
		r:answer := "ERROR"
		r:error  := "Cannot parse '"+cmd+"': "+oErr:description
		return r
	end sequence
return r

/* Get error description or NIL if no error */
function codb_get_error( self )
return iif(valtype(self)=='O' .and. "ERROR" $ self, self:error, "Bad object for codb_get_error()")

/* Get answer string */
function codb_get_answer( self )
return iif(valtype(self)=='O' .and. "ANSWER" $ self, self:answer, NIL)

/* Get real array of values */
function codb_get_result( self )
return iif(valtype(self)=='O' .and. "DATA" $ self, self:data, NIL)

/* Get object content */
function codb_get_object( self, id, db )
	local r, ret

	r := CODB_Result()

	if valtype(self) != 'O' .or. ( "CLASSNAME" $ self .and. self:className != "CODB_Client")
		r:answer := "ERROR"
		r:error  := "Connection is not open. Use 'codb_connect()' first."
		return r		
	endif

	// Set database
	__set_db(self, db)
	
	ret := ec_get_object( self, id, r)

	if ret != NIL
		r:answer := "ERROR"
		r:error  := ret
	endif
return r

/* Put object content */
function codb_put_object( self, obj, db, class )
	local r, ret

	r := CODB_Result()

	if valtype(self) != 'O' .or. ( "CLASSNAME" $ self .and. self:className != "CODB_Client")
		r:answer := "ERROR"
		r:error  := "Connection is not open. Use 'codb_connect()' first."
		return r		
	endif

	// Set database
	__set_db(self, db)
	
	// Translate class name to its ID
	class := clip("codb_metaIdByName", self:dep, class, "CLASS")

	ret := ec_put_object( self, obj, r, , , class)

	if ret != NIL
		r:answer := "ERROR"
		r:error  := ret
	endif
return r

/* Get metaobject content */
function codb_get_metaobject( self, id, db )
	local r, ret

	r := CODB_Result()

	if valtype(self) != 'O' .or. ( "CLASSNAME" $ self .and. self:className != "CODB_Client")
		r:answer := "ERROR"
		r:error  := "Connection is not open. Use 'codb_connect()' first."
		return r		
	endif

	// Set database
	__set_db(self, db)
	
	ret := ec_get_metaobject( self, id, r)

	if ret != NIL
		r:answer := "ERROR"
		r:error  := ret
	endif
return r

/* Put metaobject content */
function codb_put_metaobject( self, obj, db, class )
	local r, ret

	r := CODB_Result()

	if valtype(self) != 'O' .or. ( "CLASSNAME" $ self .and. self:className != "CODB_Client")
		r:answer := "ERROR"
		r:error  := "Connection is not open. Use 'codb_connect()' first."
		return r		
	endif

	// Set database
	__set_db(self, db)
	
	ret := ec_put_metaobject( self, obj, r, , class)

	if ret != NIL
		r:answer := "ERROR"
		r:error  := ret
	endif
return r

/* Return number of value rows or number of rows affected by query */
function codb_num_rows( self )
return iif(valtype(self)=='O' .and. "ROWS" $ self, self:rows, NIL)

/* Return number of value columns */
function codb_num_columns( self )
return iif(valtype(self)=='O' .and. "COLUMNS" $ self, self:columns, NIL)

/* Get column title */
function codb_get_column( self, num )
return iif(valtype(self)=='O' .and. "FIELDS" $ self .and. ;
	valtype(self:fields)=='A' .and. num>0 .and. num<len(self:fields), ;
	self:fields[num], NIL)



/*========================== INTERNAL FUNCTIONS =================================*/
/* 'HELP' command */
static function ec_help( self, cmd, res, files )
	local i
	res:fields := {"Command","Description"}
	if len(cmd) == 1 // top level commands
		res:data   := array(0)
		for i in cmdList
			aadd( res:data, { i[1], i[3] } )
		next
		
	else
		switch lower(cmd[2])
			case 'help'
				res:data := {{'help <command>','Help about specified <command>'}}
			case 'create'
				res:data := {{'create <metaobject> (<param1>=<value1>[,...])','Create metaobject'}, ;
				   	     {'create database <dbname> <path> [<desc>]', ;
					      'Create new database <dbname> at location <path> with description <desc>'}}
			case 'use'
				res:data := {{'use <db_name> [<dep_name>]','Open database <db_name> and depository <dep_name> if specified' }}
			case 'get'
				res:data := {{'get <id>','Get object content specified by <id>'}}
			case 'put'
				res:data := {{'put <class> (<param1>=<value1>[, ...])','Create (id is NULL) or update object in depository. <class> is class name for new object or id of changed object'}}
			case 'metaget'
				res:data := {{'metaget <id>','Get metaobject content specified by <id>'}}
			case 'metaput'
				res:data := {{'metaput (<param1>=<value1>[, ...])','Create (id is NULL) or update metaobject'}}
			case 'delete'
				res:data := {{'delete <id>; delete from <class>','Delete object or metaobject specified by <id> or delte all objects of class name <class>'}}
			case 'drop'
				res:data := {{'drop <class> <name>','Drop metaobject class <class> and name <name>'}}
			case 'select'
				res:data := {{'select <attributes> from <classes> [where <conditions>]','Query object attributes <attributes> from classes <classes> which are saticfied given <conditions>'}}
			case 'show'
				res:data   := array({"show metaclasses","Show all meta types"})
				for i in aMClasses
					aadd( res:data, { "show "+i[1], i[3] } )
				next
			case 'describe'
				res:data   := array({'describe <classname>','Show <classname> structure'})
				for i in aMClassesDesc
					aadd( res:data, { "describe "+i[1], i[3] } )
				next
			otherwise
				return "Help for '"+cmd[2]+"' isn't implemented yet"
		endswitch
	endif
return NIL

/* 'SHOW' command */
static function ec_show( self, cmd, res, files )
	local oErr, dbh, dbl, i, j, pos, d:=self:dict, o, class, c_db
	
	if len(cmd) == 1
		return "Metaclass name is missed"
	endif
	
	if lower(cmd[2]) != 'databases' .and. empty(d)
		return "Select database first ('use <DBNAME>')"
	endif

	oErr := ErrorBlock({|e| break(e) })
	
	begin sequence
		if lower(cmd[2]) == 'databases'	// TODO: Show all databases
			if len(self:dict_list) > 0
				res:fields := {"Name","Path","Description"}
				res:data   := array(0)
				
				for i in self:dict_list
					aadd( res:data, { i[1], i[4], i[5] } )
				next
			else
				return NIL
			endif
		elseif lower(cmd[2]) == 'statistics'	// Show statistics
			res:fields := {"Metaclass","Total"}
			res:data   := array(0)
			for j:=1 to len(aMClasses)
				class := aMClasses[j]
				if .not. empty(class[2])
					dbl := d:select(class[2])
					if val(d:error) > 0
						return "Cannot open "+class[1]+" list: "+d:error
					endif
					c_db := upper(left(class[1],1))+substr(class[1],2)
					aadd( res:data, { c_db, len(dbl) } )
				endif
			next
		elseif lower(cmd[2]) == 'metaclasses' // Meta types
			res:fields := {"Name"}
			res:data   := array(0)
			for i in aMClassesDesc
				aadd( res:data, { i[1] } )
			next
			return NIL
		else 	// Meta class
			for j:=1 to len(aMClasses)
				class := aMClasses[j]
				if lower(cmd[2]) == class[1]
					// Show metaclass
					dbl := d:select(class[2])
					if val(d:error) > 0
						return "Cannot open "+class[1]+" list: "+d:error
					endif
					res:fields := {"Id","Name"}
					res:data   := array(0)
					for i in dbl
						o := d:getValue(i)
						aadd( res:data, { i, o:name } )
					next
					return NIL
				endif
			next
			return "Unknown metaclass name: '"+cmd[2]+"'"
		endif
	recover using oErr
		return "Error show '"+cmd[2]+"': "+oErr:description
	end sequence

return NIL

/* 'DESCRIBE' command */
static function ec_describe( self, cmd, res, files )
	local oErr, dbh, dbl, i, j, pos, d:=self:dict, o, class
	
	if len(cmd) == 1
		return "Class name is missed"
	endif
	
	if empty(d)
		return "Select database first ('use <DBNAME>')"
	endif

	oErr := ErrorBlock({|e| break(e) })
	
	begin sequence
		// Scan metaclass names
		j := ascan(aMClassesDesc, {|e| e[1]==lower(cmd[2]) })
		if j > 0
			// Show metaclass structure
			pos := ascan(codbMetaAttr, {|e| e[1]==aMClassesDesc[j][2] })
			res:fields := {"Name","Type","Length","Transform","Default"}
			res:data   := array(0)
			class := codbMetaAttr[pos][2]
			
			for i in class
				aadd( res:data, {i[1], i[2], i[3], i[5], i[6]} )
			next
			return
		endif
		
		// Scan ordinary classes
		dbl := d:select("CLASS",,cmd[2])
		if val(d:error) > 0
			return "Cannot open class list: "+d:error
		endif
		if len(dbl) < 1
			return "Unknown class name: '"+cmd[2]+"'"
		endif
		j := d:getValue(dbl[1])
		if val(d:error) > 0
			return "Error get class '"+cmd[2]+"' attributes: "+d:error
		endif
		res:fields := {"Name","Type","Length","Transform","Default"}
		res:data   := array(0)
		
		for i in j:attr_list
			o := d:getValue(i)
			// TODO: need more ordinary class structure information
			aadd( res:data, { o:name, o:type, o:len, o:lentype, o:defValue } )
		next
	recover using oErr
		return "Error describe '"+cmd[2]+"': "+oErr:description
	end sequence

return NIL

/* Get raw object*/
static function ec_get_object( self, id, res, files, d )
	local oErr, cEnt, dbl
	
	if valtype(d) == 'O'
		cEnt := 'metaobject'
	else
		d := self:dep
		cEnt := 'object'
	endif
	
	if empty(d)
		return "Select database first ('use <DBNAME>')"
	endif

	oErr := ErrorBlock({|e| break(e) })
	
	begin sequence
		// Get object content
		dbl := d:getValue(id)
		if val(d:error) > 0
			return "Cannot get "+cEnt+" with id "+id+": "+d:error
		endif
		res:fields := array(0)
		res:data   := iif(valtype(dbl) != 'O', NIL, dbl)

	recover using oErr
		return "Error get '"+id+"': "+oErr:description
	end sequence

return NIL

/* Get raw metaobject*/
static function ec_get_metaobject( self, id, res, files )
	
	ec_get_object( self, id, res, files, self:dict )

return NIL

/* Put raw object*/
static function ec_put_object( self, obj, res, files, d, class )
	local oErr, id, cEnt

	if valtype(d) == 'O'
		cEnt := 'metaobject'
	else
		d := self:dep
		cEnt := 'object'
	endif
	
	if empty(d)
		return "Select database first ('use <DBNAME>')"
	endif

	oErr := ErrorBlock({|e| break(e) })
	
	begin sequence
		if "ID" $ obj .and. .not. empty(obj:id)
			// Update content
			if d:update(obj)
				id := obj:id
			else 
				id := NIL
			endif
			res:affected:type  := 'M'
			res:affected:class := obj:class_id
		else
			// Create object
			id := d:append(obj, class)
			res:affected:type  := 'C'
			res:affected:class := class
		endif
		if .not. empty(d:error)
			return "Cannot put "+cEnt+": "+d:error
		endif
		res:fields := array(0)
		res:data   := id
		if .not. empty(id)
			res:affected:list := { id }
		endif

	recover using oErr
		return "Error put '"+class+"': "+oErr:description
	end sequence

return NIL

/* Put raw metaobject*/
static function ec_put_metaobject( self, obj, res, files, class )
return ec_put_object( self, obj, res, files, self:dict, class )

/* 'GET' command */
static function ec_get( self, cmd, res, files, d )
	local oErr, k, p, v, class:="", attr, cEnt, oClass, j, oAttr, dbl
	local aKeys, aNames, i
	
	if valtype(d) == 'O'
		cEnt := 'metaobject'
	else
		d := self:dep
		cEnt := 'object'
	endif
	
	if len(cmd) == 1
		return "ID is missed"
	endif
	
	if empty(d)
		return "Select database first ('use <DBNAME>')"
	endif

	oErr := ErrorBlock({|e| break(e) })
	
	begin sequence
		// Show object content
		dbl := d:getValue(cmd[2])
		
		//?? dbl,chr(10)
		
		if val(d:error) > 0
			return "Cannot get "+cEnt+" with id "+cmd[2]+": "+d:error
		endif
		
		if '__VERSION' $ dbl .and. dbl:__version < 0
			return "Cannot get "+cEnt+" with id "+cmd[2]+": "+cEnt+" was deleted"
		endif
		
		res:fields := {"Attribute","Value"}
		res:data   := array(0)
		
		//?? dbl,chr(10)
		
		aKeys := mapkeys(dbl)
		aNames := { "__version","__meta","__crc32" }

		if "__META" $ dbl	// metaobject
			class := dbl:__meta
			p := ascan(codbMetaAttr, {|e| class == e[1] })
			if p > 0	// Metaclass
				aadd( res:data, { "__meta", class } )
				for i:=1 to len(codbMetaAttr[p][2])
				    attr := codbMetaAttr[p][2][i]
				    if attr[1] $ dbl	
					aadd( res:data, { lower(attr[1]), dbl[attr[1]] } )
				    endif
				next
			endif
		else
			// ordinary object
			if .not. "CLASS_ID" $ dbl
				return "Internal error: no 'class_id' in object"
			endif
			
			// Append to aNames real attribute names
			oClass := self:dict:getValue(dbl:class_id)
			for j in oClass:attr_list
				oAttr := self:dict:getValue(j)
				if valtype(oAttr) == 'O' .and. "NAME" $ oAttr
					aadd(aNames, oAttr:name)
				endif
			next
			
			// Process all keys
			for i:=1 to len(aNames) //aKeys)
				p := ascan(aKeys, {|e| e == hashstr(upper(aNames[i])) })		
				if p > 0
					k := aNames[i]
					v := dbl[upper(k)]
					adel(aKeys, p)
					asize(aKeys, len(aKeys)-1)
					aadd( res:data, { k, v } )
				endif
			next
			for i:=1 to len(aKeys)
				k := aKeys[i]
				v := dbl[k]
				k := "<"+lower(hashname(k))+">"
				aadd( res:data, { k, v } )
			next
		endif
			
		// Sort fields
		res:data := asort(res:data,,, {|a,b| a[1] < b[1] })
		
	recover using oErr
		return "Error get '"+cmd[2]+"': "+oErr:description
	end sequence

return NIL

/* 'METAGET' command */
static function ec_metaget( self, cmd, res, files )
	
	ec_get( self, cmd, res, files, self:dict )
	
return NIL

/* 'PUT' command */
static function ec_put( self, cmd, res, files, d, metaclass )
	local oErr, cEnt, obj:=map(), i, e, name, value, shift:=0
	local pos, pos2, class_id, class_name, j, cClass, cValue, cFile, nId
	
	if valtype(d) == 'O'
		cEnt := 'metaobject'
	else
		d := self:dep
		cEnt := 'object'
	endif
	
	if len(cmd) == 1
		return cEnt+" is empty"
	endif
	
	if empty(d)
		return "Select database first ('use <DBNAME>')"
	endif

	oErr := ErrorBlock({|e| break(e) })
	
	begin sequence
		//?? cmd,chr(10)
		for i=3 to len(cmd)
			
			e := cmd[i]
			
			// Ignore decorations
			if e == '=' .or. e == '(' .or. e == ')'
				shift := shift + 1
				loop
			endif
			if e[1] == '=' .or. e[1] == '('
				e := substr(e, 2, len(e)-1)
			endif
			if e[len(e)] == '=' .or. e[len(e)] == ')'
				e := substr(e, 1, len(e)-1)
			endif
			
			//?? '<'+e+'>'+chr(10)
			
			// Split words by '='
			pos  := at("=",e)
			pos2 := at("'",e)
			if pos > 0 .and. pos < len(e) .and. (pos2 == 0 .or. pos < pos2)
				name := upper(left(e,pos-1))
				value := substr(e,pos+1)
				if left(value,1) == "'" .and. right(value,1) == "'" .and. len(value) >= 2
					value = substr(value, 2, len(value)-2)
				endif
				//?? "'"+name+"' = '"+value+"'&\n"
				if value[1] == "{"
					if right(value,1) <> '}'
						return "ERROR: unclosed parenthesis in '"+name+"' = '"+value+"'&\n"
					endif
					value = split(substr(value,2,len(value)-2),",")
					if cEnt == 'metaobject'
						if lower(name) == 'attr_list'
							cClass := 'ATTR'
						elseif lower(name) == 'idx_list'
							cClass := 'INDEX'
						else
							loop
						endif
						for j=1 to len(value)
							cValue := alltrim(strtran(value[j],chr(10),' '))
							value[j] := codb_metaIdByName(d,cValue,cClass)
							if value[j] == ''
								return "WARNING: cannot find ID of "+cClass+" '"+cValue+"'"+chr(10)
								//value[j] := cValue
							endif
						next
						//?? cClass,":",value,chr(10)
					endif
				elseif value[1] == '@' .and. value[len(value)] == '@'
						cFile := substr(value, 2, len(value)-2)
						j := ascan(files, {|e| e[1]==cFile })
						if j > 0
							value := files[j][2]
						else
							return "WARNING: file '"+cFile+"' is not attached to query"
						endif
				endif
				obj[name] := value
				name := NIL
				shift := shift + 1
				loop
			endif
			
			//?? i+shift, (i+shift) % 2, chr(10)
			if (i+shift) % 2 == 0 // Value
				value := e
				if left(value,1) == "'" .and. right(value,1) == "'" .and. len(value) >= 2
					value = substr(value, 2, len(value)-2)
				endif
				if .not. empty(name)
					//?? "'"+name+"' = '"+value+"'&\n"
					if value[1] == "{"
						value = split(substr(value,2,len(value)-2),",")
						if cEnt == 'metaobject'
							if lower(name) == 'attr_list'
								cClass := 'ATTR'
							elseif lower(name) == 'idx_list'
								cClass := 'INDEX'
							else
								loop
							endif
							for j=1 to len(value)
								cValue := value[j]
								value[j] := codb_metaIdByName(d,value[j],cClass)
								if value[j] == ''
									return "WARNING: cannot find ID of "+cClass+" '"+cValue+"'"+chr(10)
									//value[j] := cValue
								endif
							next
						endif
						//?? "array: ",value,chr(10)
					elseif value[1] == '@' .and. value[len(value)] == '@'
						cFile := substr(value, 2, len(value)-2)
						?? ">>>",cFile,len(files),chr(10)
						j := ascan(files, {|e| e[1]==cFile })
						if j > 0
							value := files[j][2]
						else
							return "WARNING: file '"+cFile+"' is not attached to query"
						endif
					endif
					obj[name] := value
					name := NIL
				endif
				name := ""
			else // Name
				name := upper(e)
			endif
			
		next
		
		//res:fields := array(0)
		//res:data   := NIL
		//return NIL
		
		//?? obj, chr(10)
		// Update content
		if .not. "ID" $ obj .or. valtype(metaclass) == 'C'
			if valtype(metaclass) == 'C'
				class_name := metaclass
				if "NAME" $ obj
					class_id := clip("codb_metaIdByName",d,obj:name,metaclass)
					if .not. empty(class_id)
						return "Metaobject with name '"+obj:name+"' is already exist"
					endif
				endif
				class_id := metaclass
			elseif cEnt == 'metaobject'
				class_name := cmd[2]
				if "NAME" $ obj
					class_id := clip("codb_metaIdByName",d,obj:name,class_name)
					if .not. empty(class_id)
						return "Metaobject with name '"+obj:name+"' is already exist"
					endif
				endif
				class_id := cmd[2]
			else
				class_name := cmd[2]
				class_id := clip("codb_metaIdByName",d,cmd[2],"CLASS")
			endif
			
			if empty(class_id)
				return "No class '"+class_name+"'"
			endif
			
			//?? "append",obj,class_id,"&\n"
			//d:padrbody(obj, class_id)
			
			// TODO: error in '.NOT.' on extents appended
			nId := d:append(obj, class_id)
			res:affected:type  := 'C'
			res:affected:class := class_id
			res:affected:list  := { nId }
			
			//?? d:error,chr(10)
			if .not. empty(d:error)
				return "Cannot put "+cEnt+": "+d:error
			endif
		else
			if "CLASS_ID" $ obj
				obj := d:padrbody(obj, obj:class_id)
			endif
			
			d:update(obj)
			res:affected:type  := 'M'
			res:affected:class := obj:class_id
			res:affected:list  := { obj:id }
			if .not. empty(d:error)
				return "Cannot put "+cEnt+": "+d:error
			endif
		endif
		res:fields := array(0)
		res:data   := NIL

	recover using oErr
		//?? oErr,chr(10)
		return "Error put "+cEnt+": "+oErr:description
	end sequence

return NIL

/* 'METAPUT' command */
static function ec_metaput( self, cmd, res, files )
return ec_put( self, cmd, res, files, self:dict )


/* 'DELETE' command */
static function ec_delete( self, cmd, res, files )
	local oErr, d:=self:dep, aKeys, k, p, v, dbl, class:="", oList, i
	
	if len(cmd) == 1
		return "Id is missed"
	endif
	
	if empty(d)
		return "Select database first ('use <DBNAME>')"
	endif

	oErr := ErrorBlock({|e| break(e) })
	
	//?? "delete",cmd[2],chr(10)
	begin sequence
		if len(cmd) > 2 .and. lower(cmd[2]) == 'from'
			// DELETE FROM <className>
			class := codb_metaIdByName( d, cmd[3], 'CLASS' )
			if class == ''
				return "Cannot find ID of "+cmd[3]
			endif
			oList := d:select( class )
		else
			// Get object content
			class := d:getValue(cmd[2])
			if valtype(class) != 'O'
				class := self:dict:getValue(cmd[2])
			endif
			if valtype(class) == 'O'
				class := class:class_id
			endif
			oList := { cmd[2] }
		endif
		
		// Check values
		if valtype(oList) != 'A' .or. len(oList) == 0
			return 'Nothing delete'
		endif
		
		res:affected:type  := 'D'
		res:affected:class := class
		res:affected:list  := oList
		
		// Real delete
		for i in oList
			dbl := d:delete(i)
			//?? 'delete from depository:', dbl, d:error,chr(10)
			if .not. empty(d:error)
				dbl := self:dict:delete(i)
				//?? 'delete from dictionary:', dbl, self:dict:error,chr(10)
				if .not. empty(self:dict:error)
					return "Cannot delete object with id "+i+": object not found"
				endif
			endif
		next
		
	recover using oErr
		return "Error delete '"+cmd[2]+"': "+oErr:description
	end sequence
return NIL

/* 'DROP' command */
static function ec_drop( self, cmd, res, files )
	local dbl, oErr, d:=self:dict, j, class, id, dep, aObj:=array(0), o
	
	if len(cmd) == 1
		return "Metaobject class is missed"
	endif
	
	if len(cmd) < 3
		return "Type or name is missed"
	endif
	
	if empty(d)
		return "Select database first ('use <DBNAME>')"
	endif

	oErr := ErrorBlock({|e| break(e) })
	
	//?? "delete",cmd[2],cmd[3],chr(10)
	begin sequence
		// Lookup metaobject
		j := ascan(aMClassesDesc, {|e| e[1]==lower(cmd[2]) })
		if j == 0
			return "Cannot drop object: class not found"
		endif
		class := aMClassesDesc[j][2]
		//?? "CLASS:", class, chr(10)
		
		dbl := d:select(class,,cmd[3])
		//?? "OBJECT:", dbl,chr(10)
				
		if len(dbl) == 0
			return "Cannot drop "+cmd[2]+" '"+cmd[3]+"': metaobject was not found"
		else
			id := dbl[1]
		endif
		
		// Delete metaobject
		dbl := d:delete( id )
		
		// For class delete all its objects 
		if class == 'CLASS'
			dep := self:dep
			if .not. empty(dep)
				aObj := dep:select( id )
				//?? 'Deleted objects:', aObj, chr(10)
				for o in aObj
					dbl := dep:delete( o )
				next
			endif
		endif
		
		aadd(aObj, id)
		
		res:affected:type  := 'D'
		res:affected:class := id
		res:affected:list  := aObj
		
		//?? dbl, d:error,chr(10)
		if .not. empty(d:error)
			return "Cannot drop object '"+cmd[2]+' '+cmd[3]+"': object not found"
		endif
	recover using oErr
		return "Error drop '"+cmd[2]+' '+cmd[3]+"': "+oErr:description
	end sequence
return NIL


/* 'CREATE' command */
static function ec_create( self, cmd, res, files )
	local oErr, dbh, d:=map(), dict, desc:='', i

	if len(cmd) < 2 
		return "Unknown metaclass name for creation"
	endif
	
	i := ascan(aMClassesDesc, {|e| lower(cmd[2]) == e[1] })
	// Create any metaobject
	if i > 0
		return ec_put( self, cmd, res, files, self:dict, aMClassesDesc[i][2] )
	endif
	
	if lower(cmd[2]) != "database"
		return "Unknown type of created metaobject"
	endif

	if len(cmd) < 3
		return "Database name is missing"
	elseif len(cmd) < 4
		return "Database location is missing"
	elseif len(cmd) > 4
		desc := cmd[5]
	endif

	if len(cmd[3]) <> 5
		return "Database name must be 5 symbols (ex. TST01)"
	endif
		
	oErr := ErrorBlock({|e| break(e) })
	
	begin sequence
		dbh := codbList():new()
		if val(dbh:error) > 0
			return "Cannot open database list: "+dbh:error
		endif
	
		d:id   := cmd[3]
		d:name := desc
		d:type := "DBF"
		d:path := cmd[4]
		
		//?? d, chr(10)
		if dbh:existId(d:id)
			return "Database with name '"+d:id+"' is already exists"
		else
			if .not. dbh:append(d)
				return "Cannot create database: "+dbh:error
			endif
		endif
		
		// Open created database. 
		dict := dbh:connect(d:id)
		
		if .not. val(dict:error) > 0 .and. dict:open()
			// Append to databases list
			aadd(self:dict_list, { d:id, dict, NIL, d:path, d:name } )
		endif
				
	recover using oErr
		return "Error create "+cmd[2]+": "+oErr:description
	end sequence

return NIL

/* 'USE' command */
static function ec_use( self, cmd, res, files )
	local db, p, r
	if len(cmd) == 1
		return "Database name is missed"
	endif

	db:=cmd[2]
	if .not. empty(db)
		p := ascan(self:dict_list, {|e| e[1] == db })
		if p > 0
			self:dict := self:dict_list[p][2]
			res:answer := db
			self:dep := self:dict_list[p][3]
			if len(cmd) > 2 .and. .not. empty(cmd[3])
				r := ascan(self:dep_list, {|e| self:dict_list[e[3]][1]==cmd[2] .and. e[1]==cmd[3] })
				if r > 0
					self:dep := self:dep_list[p][2]
					res:answer += ":"+cmd[3]
				endif
			endif
		else
			return "No database '"+db+"' or database is locked by another application."
		endif
	endif

return NIL

/* 'SELECT' command */
static function ec_select( self, cmd, res, files )
	local oErr, dbl, d:=self:dep, dict:=self:dict, i, j
	local attrs:=array(0), classes:=array(0), where:=array(0)
	local status:=1, part, o, row, elem, classIds:=array(0)
	local value, where_condition, field
	local item, adAttrs:=array(0), oClass, oAttr, z, oId
	
	if dict == NIL
		return "Open database first"
	endif
	
	if d == NIL
		return "Open or create depository first"
	endif
	
	if len(cmd) < 2
		return "Attribute list is empty"
	endif

	// Parse statement
	for i=2 to len(cmd)
		if lower(cmd[i]) == 'from' 
			status := 2 // classes
			loop
		endif
		if lower(cmd[i]) == 'where' 
			status := 3 // where condition(s)
			loop
		endif
		part := cmd[i]
		switch status
			case 1
				aadd(attrs, part)
			case 2
				aadd(classes, part)
			case 3
				aadd(where, part)
		endswitch
	next

//?? "ATTRS:", attrs, chr(10)
//?? "CLASSES:", classes, chr(10)
//?? "WHERE:", where, chr(10)
	
	if len(classes) == 0
		return "Class(es) is not defined"
	endif
	
	oErr := ErrorBlock({|e| break(e) })
	
	begin sequence
		// First: expand class names if '*'
		if classes[1] = '*' // All classes
			classes := array(0)
			dbl := dict:select("CLASS")
			if val(dict:error) > 0
				return "Cannot get class list: "+dict:error
			endif
			classIds := dbl
		else
			for i in classes
				oId := codb_metaIdByName(dict,i,"CLASS")
				//?? "CLASS ID:", oId, i, empty(oId), valtype(oId), chr(10)
				if empty(oId) // Check if class exist
					return "Class '"+i+"' is not found"
				else
					aadd(classIds, oId)
				endif
			next
		endif
		
		// Second: insert all fields instead '*'
		for i=1 to len(attrs)
			if attrs[i] == '*'
				if len(adAttrs) == 0
					for j:=1 to len(classIds)
						oClass := dict:getValue( classIds[j] )
						//?? "CLASS:", classIds[j], valtype(oClass), 'ATTR_LIST' $ oClass
						if valtype(oClass) != 'O'
							return "Class '"+classes[j]+"' is not found"
						endif
						for item in oClass:attr_list
							oAttr := dict:getValue( item )
							if ascan(adAttrs, {|e| oAttr:name==e }) == 0
								aadd(adAttrs, oAttr:name)
							endif
						next
					next
				endif
				attrs[i] := adAttrs
			endif
		next
		adAttrs := array(0)
		for i in attrs
			if valtype(i) == 'A'
				for j in i
					aadd(adAttrs, j)
				next
			else
				aadd(adAttrs, i)
			endif
		next
		attrs := adAttrs
		//?? "ATTR+:",attrs,chr(10)
		
		// Third: fill result with 'where' condition check
		res:fields := attrs
		res:data   := array(0)		
	
		// WHERE preparing, TODO: translate logical operation and quotes
		where_condition := ''
		for part in where
			where_condition += part
		next
		//?? where_condition,chr(10)
		
		for part in classIds
			//?? "d:select:", part, where_condition, chr(10)
			dbl := d:select(part,,,where_condition)
			
			//?? part,":",len(dbl), dbl,chr(10)
			
			if val(d:error) > 0
				return "Cannot get object list for class id '"+part+"': "+d:error
			endif
		
			// Fill attributes columns
			for i in dbl
				row := array(len(attrs))
				//?? "open",i,chr(10)
				o := d:getValue(i)
				//?? "opened",chr(10)
				if val(d:error) > 0
					?? "Error fetch object '"+i+"' content: "+d:error+chr(10)
					loop
				endif
				//?? "got", o, chr(10)
				for j:=1 to len(attrs)
					field := attrs[j]
					if upper(field) $ o
						value := o[upper(field)]
					else
						value := NIL
					endif
					row[j] := value
				next
				aadd( res:data, row )
			next
		next

	recover using oErr
		return "Error select: "+errorMessage(oErr)
	end sequence

return NIL
