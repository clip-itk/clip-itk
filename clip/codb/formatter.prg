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

/** Class for CODB_Result object formatted for show in console */

/* TODO:
	- --format (text, csv, xml)
	- use only codb_* functions, not class hack
*/

#define DEF_DELIMITER	'   '

function CODBFormatter()
	local obj
	
	obj := map()
	obj:className := "CODBFormatter"
	obj:options := map()
	
	obj:options:hide_titles	:= .F.
	obj:options:delim 	:= DEF_DELIMITER
		
	_recover_CODBFORMATTER(obj)
return obj

function _recover_CODBFORMATTER(obj)
	obj:show	:= @c_show()
return

/* Show formatted output */
static function c_show(self, res)
	local e, d, s:="", c_len, k, j, total:=0, val, s_val, s_str
	
	if valtype(res) != "O" .or. .not. "ANSWER" $ res .or. .not. "DATA" $ res
		return "ERROR: bad returned object.&\n"
	endif
	
	// Check error
	e := codb_get_error(res)
	if e != NIL
		return "ERROR: " + e + chr(10)
	endif
	
	// Check empty data
	d := codb_get_result( res )
	if d == NIL .or. (valtype(d)=="A" .and. len(d)==0)
		return ""
	endif
	
	// Generate value length for each columns of data
	c_len := array(len(d[1]))
	afill(c_len, 0)
	
	for k:=1 to len(d)
		for j:=1 to len(d[k])
			if len(d[k][j]) > c_len[j]
				c_len[j] := len(d[k][j])
			endif
		next
	next
	// Print fields if exists
	if .not. self:options:hide_titles .and. "FIELDS" $ res .and. valtype(res:fields)=="A" .and. len(res:fields)==len(c_len)
		for k:=1 to len(res:fields)
			c_len[k] := iif(c_len[k]<=len(res:fields[k]),len(res:fields[k]),c_len[k])
			s += res:fields[k] + space(c_len[k]-len(res:fields[k])) + self:options:delim
			total += c_len[k] + len(self:options:delim)
		next
		s = left(s,len(s)-len(self:options:delim)) + chr(10) + replicate('-', total-len(self:options:delim)) + chr(10)
	endif
	
	// Output data
	for k:=1 to len(d)
		s_str := ""
		for j:=1 to len(d[k])
			val := d[k][j]
			s_val := f_val2str(val)
			if c_len[j] > len(s_val)
				s_val := s_val + space(c_len[j]-len(s_val))
			endif
			s_str += s_val + self:options:delim
		next
		s += left(s_str,len(s_str)-len(self:options:delim)) + chr(10)
	next

return s

/* f_val2str() - convert value to string */
static function f_val2str(val)
	local i, s_val
	switch valtype(val)
		case 'U'
			s_val := "<NIL>"
		case 'B'
			s_val := "<NIL>"
		case 'C'
			s_val := val
		case 'N'
			s_val := alltrim(str(val))
		case 'L'
			s_val := iif(val,'.T.','.F.')
		case 'D'
			s_val := dtoc(val)
		case 'A'
			s_val := "{"
			for i:=1 to len(val)
				s_val += f_val2str(val[i])+","
			next
			s_val := iif(len(val)>0,left(s_val,len(s_val)-1),s_val)+"}"
		case 'O'
			s_val := '<OBJECT>'
		otherwise
			s_val := '<UNKNOWN ('+valtype(val)+')='+varToString(val)+">"
	endswitch
return s_val
