/*-------------------------------------------------------------------------*/
/*   This is part of console client for CODB database                      */
/*                                                                         */
/*   Copyright (C) 2005 by E/AS Software Foundation                        */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

#define FILE_BUFFER	4096
#include "inkey.ch"

static clientVersion := "0.1"
static db, dbname:="", fmt

/* 
    TODO:
	- connection string for connect via COBrA server (-u, -p, -s)
	- exit function for correct connection shutdown
	- 'set <param>=<mode>' command needed 
	- CODB daemon for query mode
*/

/* Main function */
function main(p1)
	local e, i, h, s:='', ss, params:=array(0), ret

	set cancel off

	// Read from pipe
	h := fopen("-|")
	while .T. 
	    ss := freadstr(h,256)
	    s := s + ss
	    if empty(ss)
		exit
	    endif
	end
	fclose(h)
	
	fmt := CODBFormatter()
	for i:=1 to pcount()
		if ascan({'-h','--help','-?'}, param(i)) > 0
			printUsage(1) // help
			return 0
		elseif param(i)=='--version'
			printUsage(2) // version
			return 0
		elseif param(i) == '--hide-titles'
			fmt:options:hide_titles := .T.
		elseif left(param(i),8) == "--delim="
			fmt:options:delim := substr(param(i),9)
		elseif left(param(i),1) == '-' .and. param(i) != '-c'
			?? "Unknown parameter: "+param(i),chr(10)
		else
			aadd(params, param(i))
		endif
	next
	
	for i:=1 to len(params)
		if params[i] == '-c' .and. i < len(params)
			s := params[i+1]
			if right(rtrim(s),1) != ';'
				s += ';'
			endif
			adel(params,i)
			adel(params,i)
			asize(params,len(params)-2)
		endif
	next
	
	// TODO: connect if needed
	db  := codb_connect()
	e := codb_get_error( db )
	if e != NIL
		?? "ERROR codb_connect(): " + e + chr(10)
		return 1
	endif

	//?? params, s,chr(10)
			
	if len(params) > 0 // Database name
		// possible use in form DB:DEP
		params[len(params)] := strtran(params[len(params)], ":", " ")

		//?? "USE",params[len(params)],";&\n"
		ret := codb_execute( db, "use "+params[len(params)]+";" )
		// Database name change
		e := codb_get_error( ret )
		if e == NIL
			dbname := codb_get_answer( ret )
		else
			?? "ERROR: " + e + "&\n"
			return 1
		endif
	endif
	
	if empty(s)
		printUsage(0)
		consoleMode()
	else
		executeCommand( s )
	endif
	
	// TODO: correct disconnect from database
	codb_close( db )

return 0

/* Print usage information */
static function printUsage(mode)
    // TODO: i18n for printUsage()
    if  mode == 0 // console mode
	?? "codb  Ver. " + clientVersion + " Console client for CODB database.&\n&\n"
	?? "Type 'help' for list of commands or 'quit' for exit&\n&\n"
    elseif mode == 2 // version
	?? clientVersion,"&\n"
    else // help
	?? "codb  Ver. " + clientVersion + " Console client for CODB database.&\n"
	?? "Copyright (C) 2005 E/AS Software Foundation&\n"
	?? "This software comes with ABSOLUTELY NO WARRANTY. This is free software,&\n"
	?? "and you are welcome to modify and redistribute it under the GPL license&\n"
	?? "&\n"
	
	// TODO: full list of command options
	?? "Usage: codb [OPTIONS] [dbname[:depository]]&\n&\n"
	?? "Options:&\n"
	?? "  -?, -h, --help   Display this help and exit.&\n"
	?? "  --version        Display program version and exit.&\n"
	?? "  -c 'command'     Run command and exit.&\n"
	?? "  --hide-titles    Suppress column names.&\n"
	?? "  --delim='DELIM'  Set columns delimiter.&\n"
	
    endif
return 

/* Console mode. Using readline library */
static function consoleMode()
	local comm:='', ret:='', prompt, buffer:='', cont:=.F., oErr
	
	// TODO: set key '\d' for exit
	prompt := dbname + "> "
	
	oErr := ErrorBlock({|e| break(e) })
	while .T.
	  begin sequence
		?? prompt
		ACCEPT TO comm // TODO: Ctrl+C safe handle!
		//?? "KEY:",chr(10)
		if .not. cont
			if alltrim(upper(comm)) == 'QUIT' .or. lastkey() == K_ESC
				exit
			elseif upper(comm) == 'HELP'
				ret := codb_execute( db, comm+";" )
				?? fmt:show( ret )
				// TODO: show console specific commands
				loop
			endif
		endif
		
		ret := executeCommand(buffer+comm)
		
		if empty(ret) .or. substr(ltrim(ret),1,1) == '#'
			prompt := dbname + "> "
			cont   := .F.
			buffer := ''
		else // Uncomplete command
			prompt := iif(.not. empty(dbname),replicate('-',len(dbname)),'-') + "> "
			cont   := .T.
			buffer := ret + ' '
		endif

	  recover using oErr
		?? "INTERNAL ERROR:", oErr:description+' ('+oErr:fileName+')', chr(10)
	  end sequence
	
	enddo
return

/* Execute command with check delimiters */
static function executeCommand(comm)
	local i:=0, pos, string:=.F., buffer:='', ret:=NIL, is_filename:=.F.
	local j, ampos, fileNames:=array(0), files, fH, s, ss
	local fBuf:=space(FILE_BUFFER), rTotal
	
//	?? 'EXECUTE:',comm,chr(10)
	while len(comm) > 0 .and. i<=len(comm)
		i := i + 1
		if comm[i]=="'" .and. (i==1 .or. comm[i-1]!='&\\')
			string := .not. string
		elseif .not. string .and. .not. is_filename .and. comm[i]=='@'
			ampos := i
			is_filename := .T.
		elseif .not. string .and. is_filename .and. comm[i]=='@'
			aadd( fileNames, substr(comm, ampos+1, i-ampos-1) )
			is_filename := .F.
		elseif .not. string .and. comm[i]==';' // command end
			
//			?? "EXEC:",left(comm,i-1),chr(10)
			
			// Process file names in command
			files := array(0)
			for j=1 to len(fileNames)
				fH := fopen(fileNames[j], 0)
				s := ''
				if ferror() == 0
					rTotal := 0
					while .T. 
						ss := fread(fH, @fBuf, FILE_BUFFER)
						s := s + left(fBuf, ss)
						rTotal += ss
						if ss == 0
							exit
						endif
					end
					fclose(fH)
					//?? "Append file '"+fileNames[j]+"':",rTotal,len(s),chr(10)
					aadd( files, { fileNames[j], s } )
				else
					?? "Error opening '"+fileNames[j]+"'.&\n"			
				endif
			next
			fileNames := array(0)

			//?? files,chr(10)
			ret := codb_execute( db, left(comm,i-1), NIL, files )
			?? fmt:show( ret )
			
			// Database name change
			if lower(left(comm, 4)) == 'use ' .and. .not. "ERROR" $ ret
				dbname := ret:answer
			endif
			
			if i<len(comm)
				comm := substr(comm,i+1)
				i := 0
			else
				return ''
			endif
		endif			
	enddo
return comm
