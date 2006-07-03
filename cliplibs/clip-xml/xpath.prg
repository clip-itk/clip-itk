/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-XML library                                    */
/*                                                                         */
/*   Copyright (C) 2003-2005 by E/AS Software Foundation                   */
/*   Author: Andrey Cherepanov <skull@eas.lrn.ru>                          */
/*                                                                         */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/

/* 
	This function support Xpath by following version:

	XML Path Language (XPath)
	Version 1.0
	W3C Recommendation 16 November 1999

	This version: 
		http://www.w3.org/TR/1999/REC-xpath-19991116 


TODO:
- process nodeset
- full support of full and abbreviated syntax
- logical operators
- subexpression support ( '() op ()' )
- completely functions support

*/

/* Print debug information */
#define XPATH_DEBUG		.F.

/* Tokens */
#define XPATH_TOKEN_UNDEF	0
#define XPATH_TOKEN_SYMBOL	1
#define XPATH_TOKEN_NAME	2
#define XPATH_TOKEN_NODETYPE	3
#define XPATH_TOKEN_OPERATOR	4
#define XPATH_TOKEN_FUNCTION	5
#define XPATH_TOKEN_AXIS	6
#define XPATH_TOKEN_LITERAL	7
#define XPATH_TOKEN_NUMBER	8
#define XPATH_TOKEN_VARREF	9

/* Blocks */
#define XPATH_BLOCK_NODESET	20
#define XPATH_BLOCK_NODES	21
#define XPATH_BLOCK_FUNCTION	22
#define XPATH_BLOCK_EXPRESSION	23

static lastError := ""

/* Symbols and operators */
static _xpath_symbols := { ;
	{ '(',	XPATH_TOKEN_SYMBOL }, ;
	{ ')',	XPATH_TOKEN_SYMBOL }, ;
	{ '[',	XPATH_TOKEN_SYMBOL }, ;
	{ ']',	XPATH_TOKEN_SYMBOL }, ;
	{ '..',	XPATH_TOKEN_SYMBOL }, ;
	{ '.',	XPATH_TOKEN_SYMBOL }, ;
	{ '@',	XPATH_TOKEN_SYMBOL }, ;
	{ ',',	XPATH_TOKEN_SYMBOL }, ;
	{ '::',	XPATH_TOKEN_SYMBOL }, ;
	{ '//',	XPATH_TOKEN_OPERATOR }, ;
	{ '/',	XPATH_TOKEN_OPERATOR }, ;
	{ '|',	XPATH_TOKEN_OPERATOR }, ;
	{ '+',	XPATH_TOKEN_OPERATOR }, ;
	{ '-',	XPATH_TOKEN_OPERATOR }, ;
	{ '=',	XPATH_TOKEN_OPERATOR }, ;
	{ '!=',	XPATH_TOKEN_OPERATOR }, ;
	{ '<=',	XPATH_TOKEN_OPERATOR }, ;
	{ '<',	XPATH_TOKEN_OPERATOR }, ;
	{ '>=',	XPATH_TOKEN_OPERATOR }, ;
	{ '>',	XPATH_TOKEN_OPERATOR }, ;
	{ '*',	XPATH_TOKEN_OPERATOR } ;
}

/* Symbols */
static _xpath_functions := { ;
	{ 'last',		XPATH_TOKEN_FUNCTION }, ;
	{ 'position',		XPATH_TOKEN_FUNCTION }, ;
	{ 'count',		XPATH_TOKEN_FUNCTION }, ;
	{ 'id',			XPATH_TOKEN_FUNCTION }, ;
	{ 'local-name',		XPATH_TOKEN_FUNCTION }, ;
	{ 'namespace-uri', 	XPATH_TOKEN_FUNCTION }, ;
	{ 'name',		XPATH_TOKEN_FUNCTION }, ;
	{ 'string',		XPATH_TOKEN_FUNCTION }, ;
	{ 'concat',		XPATH_TOKEN_FUNCTION }, ;
	{ 'starts-with', 	XPATH_TOKEN_FUNCTION }, ;
	{ 'contains',		XPATH_TOKEN_FUNCTION }, ;
	{ 'substring-before',	XPATH_TOKEN_FUNCTION }, ;
	{ 'substring-after',	XPATH_TOKEN_FUNCTION }, ;
	{ 'substring',		XPATH_TOKEN_FUNCTION }, ;
	{ 'string-length',	XPATH_TOKEN_FUNCTION }, ;
	{ 'normalize-space',	XPATH_TOKEN_FUNCTION }, ;
	{ 'translate',		XPATH_TOKEN_FUNCTION }, ;
	{ 'boolean',		XPATH_TOKEN_FUNCTION }, ;
	{ 'not',		XPATH_TOKEN_FUNCTION }, ;
	{ 'true',		XPATH_TOKEN_FUNCTION }, ;
	{ 'false',		XPATH_TOKEN_FUNCTION }, ;
	{ 'lang',		XPATH_TOKEN_FUNCTION }, ;
	{ 'number',		XPATH_TOKEN_FUNCTION }, ;
	{ 'sum',		XPATH_TOKEN_FUNCTION }, ;
	{ 'floor',		XPATH_TOKEN_FUNCTION }, ;
	{ 'ceiling',		XPATH_TOKEN_FUNCTION }, ;
	{ 'round',		XPATH_TOKEN_FUNCTION } ;
}

/* Special operators */
static _xpath_operators := { 'and', 'or', 'mod', 'div' }

static _xpath_axis := { ;
	'ancestor', ;
	'ancestor-or-self', ;
  	'attribute', ;
  	'child', ;
  	'descendant', ;
  	'descendant-or-self', ;
  	'following', ;
  	'following-sibling', ;
  	'namespace', ;
  	'parent', ;
  	'preceding', ;
  	'preceding-sibling', ;
  	'self' ;
}


/* xml_XPath() */
function xml_XPath( context, path )
	local i, res, b, t, n
	
	// Split to tokens
	res := _xpath_splitToken( path )
	
	// Normalize XPATH_TOKEN_UNDEF elements
	res := _xpath_normalize( @res )
	
	if XPATH_DEBUG
	    for i:=1 to len( res )
		switch res[i]:type
			case XPATH_TOKEN_UNDEF
				t := 'undef   '
			case XPATH_TOKEN_SYMBOL
				t := 'symbol  '
			case XPATH_TOKEN_NAME
				t := 'name    '
			case XPATH_TOKEN_NODETYPE
				t := 'nodetype'
			case XPATH_TOKEN_OPERATOR
				t := 'operator'
			case XPATH_TOKEN_FUNCTION
				t := 'function'
			case XPATH_TOKEN_AXIS
				t := 'axis    '
			case XPATH_TOKEN_LITERAL
				t := 'string  '
			case XPATH_TOKEN_NUMBER
				t := 'number  '
			case XPATH_TOKEN_VARREF
				t := 'varref  '
			otherwise
				t := 'unknown '
		endswitch
		?? res[i]:token, "&\t", t, "  ", ltrim( str( res[i]:pos ) ), chr(10)
	    next
	    ?? "&\n"
	endif
	
	// Parse tokens to blocks
	b := _xpath_compile( @res )
	
	if XPATH_DEBUG
		//?? res, chr(10)
		for n in b
			_xpath_dumpBlock( n, 0 )
		next
	endif

	// Evaluate expression
	res := _xpath_evaluate( @b, context )

return res


/* Return last parse error */
function xml_XPathError()
return lastError


/* Split XPath expression by tokens */
static function _xpath_splitToken( path )
	local i:=1, a:=array(0), literal:=.F., s:="", lp
	local ce:=NIL, c, fc, ap
	
	lastError := ""

	lp := len(path)
	while i <= lp
		c := path[i]
		
		// Check literal string
		if c == '"' .or. c == "'"
			if .not. literal
				literal := .T.
				s := c
			else
				if len(s) > 1 .and. s[ len( s ) ] == "&\\"
					// ignore escaped quote
					s += c
				elseif c == left( s, 1 )
					// End literal
					ce := map()
					ce:token := substr( s, 2 )
					ce:pos	 := i - len( s )
					ce:token := strtran( ce:token, '&\\"', '"' )
					ce:token := strtran( ce:token, "&\\'", "'" )
					ce:type  := XPATH_TOKEN_LITERAL
					literal  := .F.
					s := ""
					aadd( a, ce )
				else
					s += c
				endif
			endif
			i++
			loop
		endif
		
		// Ignore all whitespaces except using in literal
		// ExprWhitespace ::= (#x20 | #x9 | #xD | #xA)+ 
		if .not. literal .and. c $ " &\t&\n&\r"
			if .not. empty( s )  // Append previous string in XPATH_TOKEN_UNDEF
				ce := map()
				ce:token := s
				ce:pos	 := i - len( s )
				ce:type  := XPATH_TOKEN_UNDEF
				s := ""
				aadd( a, ce )
			endif
			i++
			loop
		endif
		
		// Define symbols
		if .not. literal .and. (ap := ascan( _xpath_symbols, ;
				{|e| e[1] == substr( path, i, len( e[ 1 ] ) ) } ) ) > 0
			if .not. empty( s ) // Append previous string in XPATH_TOKEN_UNDEF
				ce := map()
				ce:token := s
				ce:pos	 := i - len( s )
				ce:type  := XPATH_TOKEN_UNDEF
				s := ""
				aadd( a, ce )
			endif
			ce := map()
			ce:token := _xpath_symbols[ ap ][ 1 ]
			ce:pos	 := i
			ce:type  := _xpath_symbols[ ap ][ 2 ]
			i += len( ce:token )
			aadd( a, ce )
			loop
		endif
		//?? c,'s=',s,chr(10)
		// Put other set of characters to XPATH_TOKEN_UNDEF
		s += c
		i++		
	enddo
	if literal
		// Unclosed literal string
		lastError := "Unclosed string at "+ ltrim( str( i - len( s ) ) )
		return NIL
	elseif .not. empty(s)
		ce := map()
		ce:token := s
		ce:pos	 := i - len( s )
		ce:type  := XPATH_TOKEN_UNDEF
		aadd( a, ce )
	endif
	
return a


/* Normalize UNDEF elements */
static function _xpath_normalize( res )
	local i, totalNodes, node, isNumber
	local rN, reg:={}, j, func, func2
	
	// Prepare regexp
	rN := rgcomp("^[0-9]+$")

	i := 1
	totalNodes := len(res)
	while i <= totalNodes
		node := res[i]
		//?? node:token, "&\t", node:type, chr(10)
		if node:type == XPATH_TOKEN_UNDEF
			
			// Number
			if rgexec( rN, node:token, @reg )
				if i < totalNodes .and. res[i+1]:token == '.'
					node:token += '.'
					adel( res, i+1 )
					totalNodes--
					if i < totalNodes .and. ;
					    rgexec( rN, res[i+1]:token, @reg )
						node:token += res[i+1]:token
						adel( res, i+1 )
						totalNodes--
					endif
				endif
				node:token := val( node:token )
				node:type  := XPATH_TOKEN_NUMBER
				
				if i > 1 .and. res[i-1]:token == '-'
					node:token := -node:token
					adel( res, i-1 )
					totalNodes--
				endif
				
				i++
				loop
			endif
			
			// Function name
			j := ascan( _xpath_functions, ;
			    {|e| iif('-' $ e[1], left(e[1],at(e[1],'-')-1)==node:token, e[1]==node:token) } )
			if j > 0  // Function found
				func := _xpath_functions[ j ][ 1 ]
				if func == node:token
					if i < totalNodes .and. res[i+1]:token == '('
						node:type := _xpath_functions[ j ][ 2 ]
						adel( res, i+1 )
						totalNodes--
					endif
				else // part of name
					if i < totalNodes-2 .and. ;
					    res[i+1]:token == '-' .and. res[i+3]:token == '('
						func2 := node:token + "-" + res[i+2]:token
						if func2 == func
							adel( res, i+1 )
							adel( res, i+1 )
							totalNodes -= 2
							node:type := _xpath_functions[ j ][ 2 ]
						endif
						adel( res, i+1 )
						totalNodes--
					endif
				endif
			endif
			
		endif
		
		// Fix numbers with preciding dot (.5)
		if node:token == '.' .and. i < totalNodes .and. ;
		    rgexec( rN, res[i+1]:token, @reg )
		   	node:token := val( "0."+res[i+1]:token )
			node:type  := XPATH_TOKEN_NUMBER
			adel( res, i+1 )
			totalNodes--
			
			if i > 1 .and. res[i-1]:token == '-'
				node:token := -node:token
				adel( res, i-1 )
				totalNodes--
			endif
			
			i++
			loop
		endif			
		
		i++
	enddo
	asize( res, totalNodes )

return res


/* Final parse tokens to blocks for evaluation */
static function _xpath_compile( res )
	local a:={}
	local isNodeset:=.F.
	local isAlternative:=.F.
	local i, total, b, n, k, ce:=NIL, p, name, parent:=NIL, ct, expr:=NIL, t
	
	// Init counters
	i := 1
	total := len( res )
	
	// Check elements
	if valtype(res) != 'A' .or. total == 0
		lastError := "Empty expression"
		return NIL
	endif
	
	// Check root and abbreviated begin
	if res[1]:type == XPATH_TOKEN_OPERATOR
		// TODO: need more abbreviated syntax ( p.9 )
		if res[1]:token == '/'
			b := _xpath_createNode( "root", "" )
			ce     := b
			aadd( a, b )
			i++
			isNodeset := .T.
		endif
	elseif res[1]:type == XPATH_TOKEN_UNDEF
		isNodeset := .T.
	endif
	
	// Iterate all tokens
	while i <= total
		t := res[i]
		
		// Nodeset mode
		if isNodeset
		    
		    // axisname::name
		    if i < total-1 .and. res[i+1]:token == '::'
			// well-formed axis name
			p := ascan( _xpath_axis, {|e| e == t:token } )
			if p == 0
				lastError := "Unknown axis name: '"+t:token+"' at "+ltrim( str( t:pos ) )
				return NIL
			else
				name := res[i+2]
				if name:type != XPATH_TOKEN_UNDEF
					lastError := "Illegal node name: '"+name:token+"' at "+ltrim( str( t:pos ) )
					return NIL
				endif
				if isAlternative
					isAlternative := .F.
					k:type  := XPATH_BLOCK_NODES
					k:axis  := t:token
					k:name  := name:token
					k:pos	:= t:pos
					aadd( ce:set, k )
				else
					b  := _xpath_createNode( t:token, name:token, name:pos )
					ce := b
					aadd( a, b )
				endif
				i += 3
			endif
		    elseif t:type != XPATH_TOKEN_UNDEF
		    	if t:type == XPATH_TOKEN_SYMBOL .or. t:type == XPATH_TOKEN_OPERATOR
					if t:token == '|'
						// check alternatives
						if empty(ce) .or. isAlternative
							lastError := "Syntax error at "+ltrim( str( t:pos ) )+": illegal use of '|'"
							return NIL
						else
							i++
							isAlternative := .T.
							loop
						endif
					elseif t:token == '/'
						// check delimiter
						i++
						loop
					elseif t:token == '*'
						// check abbreviated * for any tags
						b := _xpath_createNode( 'child', t:token, t:pos )
						ce := b
						aadd( a, b )
						i++
						loop
					elseif t:token == '['
						if empty(ce)
						lastError := "Syntax error at "+ltrim( str( t:pos ) )+": undefined node set before '['"
						return NIL
						endif
						isNodeset := .F.
						expr := NIL
						i++
						loop
					else
						lastError := "Unexpected node name: '"+t:token+"' at "+ltrim( str( t:pos ) )
						return NIL
					endif		    	
		    	else
					lastError := "Unexpected node name: '"+t:token+"' at "+ltrim( str( t:pos ) )
					return NIL
		    	endif
		    else // Abbreviated name
			if isAlternative
				isAlternative := .F.
				k:type  := XPATH_BLOCK_NODES
				k:axis  := 'child'
				k:name  := t:token
				k:pos   := t:pos
				aadd( ce:set, k )
			else
				b := _xpath_createNode( 'child', t:token, t:pos )
				ce := b
				aadd( a, b )
			endif
			i++
		    endif
		    
		// Expression mode
		else
			if empty( expr )
				expr := map()
				expr:type   := XPATH_BLOCK_EXPRESSION
				expr:childs := {}
				expr:parent := NIL
				
				if empty(ce)
					aadd( a, expr )
				endif
				
				ct := expr
			endif
			
			// String and number
			if t:type == XPATH_TOKEN_LITERAL .or. ;
					t:type == XPATH_TOKEN_NUMBER .or. ;
					t:type == XPATH_TOKEN_OPERATOR
				aadd( ct:childs, t )
				i++
				loop
			endif
			
			// Variables
			if t:type == XPATH_TOKEN_SYMBOL
			    	
			    switch t:token
				    
				// Terminate scope
				case ']'
					if empty(ce)
						lastError := "Syntax error at "+ltrim( str( t:pos )+": undefined node set before ']'")
						return NIL
					endif
					isNodeset := .T.
					n := ce:set[ len( ce:set ) ]
					
					// Add last expression
					if "SCOPE" $ n
						aadd( n:scope, expr )
					else
						n:scope := { expr }
					endif
					expr := NIL
					i++
					loop
				
				// Attribute
				case '@'
					if i < total .and. res[i+1]:type == XPATH_TOKEN_UNDEF
						aadd( ct:childs, res[i+1] )
					else
						lastError := "Syntax error at "+ltrim( str( t:pos )+": missing attribute name" )
						return NIL
					endif
					i += 2
					loop
			
				// End argument
				case ','
					if ct:parent:type == XPATH_BLOCK_FUNCTION
						n := map()
						n:type   := XPATH_BLOCK_EXPRESSION
						n:childs := {}
						n:parent := ct:parent
						aadd( ct:parent:childs, n )
						ct := n
						i++
						loop
					else
						lastError := "Syntax error at "+ltrim( str( t:pos )+": using ',' outside function call" )
						return NIL
					endif
				
				// Start eval block
				case '('
					n := map()
					n:type   := XPATH_BLOCK_EXPRESSION
					n:childs := {}
					n:parent := ct
					aadd( ct:childs, n )
					ct := n
					i++
					loop

				// End function (or eval block) parameters
				case ')'
					//?? ct:parent,chr(10)
					if 'PARENT' $ ct
						if ct:parent:type == XPATH_BLOCK_FUNCTION
							ct := ct:parent:parent
						else
							ct := ct:parent
						endif
						i++
						loop
					else
						lastError := "Undefine function at "+ltrim( str( t:pos ) )
						return NIL
					endif
					
			    endswitch
			
			endif 
			
			// Operators
			if t:type == XPATH_TOKEN_UNDEF
				if ascan( _xpath_operators, t:token ) > 0
					t:type := XPATH_TOKEN_OPERATOR
					aadd( ct:childs, t )
					i++
					loop
				else
					lastError := "Unknown operator '"+t:token+"' at "+ltrim( str( t:pos ) )
					return NIL
				endif
			
			endif
			
			// Function
			if t:type == XPATH_TOKEN_FUNCTION
				
				// Function object
				n := map()
				n:type   := XPATH_BLOCK_FUNCTION
				n:name   := t:token
				n:pos	 := t:pos
				n:childs := {}
				n:parent := ct
				
				// First argument
				k := map()
				k:type   := XPATH_BLOCK_EXPRESSION
				k:childs := {}
				k:parent := n
	
				// Add function to parent child and set 
				// first argument as current
				aadd( ct:childs, n )
				aadd( n:childs, k )
				ct := k
				i++
				loop
				
			endif
			
		
			?? "WARNING: unknown",t:token,t:type,chr(10)
			i++
		endif
	enddo
		
return a


/* Fill nodeset block */
static function _xpath_createNode( axis, name, pos )
	local n, k
	n     := map()
	n:type := XPATH_BLOCK_NODESET
	k      := map()
	k:type := XPATH_BLOCK_NODES
	k:axis := axis
	k:name := name
	k:pos  := pos
	n:set  := { k }
return n


/* Evaluate XPath expression */
static function _xpath_evaluate( res, context )
	local v:=NIL, n, i
	
	if empty(res)
		return NIL
	endif
	
	// Evaluate expression or function
	if res[1]:type == XPATH_BLOCK_EXPRESSION .or. res[1]:type == XPATH_BLOCK_FUNCTION
		v := _xpath_evalExpr( res[1] )
	else // TODO: make nodeset and filter it
		if valtype(context) == 'O' .and. "CLASSNAME" $ context .and. context:className == "XMLTag"
			v := { context }
			for i=1 to len(res)
				v := _xpath_set( res[i], @v )
				if empty(v) .or. len(v) == 0
					return {}
				endif
			next
		else
			lastError := "Bad context object"
			return NIL
		endif
	endif

return v

/* Define nodeset */
static function _xpath_set( s, a )
	local v:={}, i, e, cond, c, name
	
	// Check for nodeset block, s:set is array of nodes definition
	if valtype(s) != 'O' .or. s:type != XPATH_BLOCK_NODESET
		return v
	endif
	
	// Filter all items
	for i:=1 to len(a)
		e := a[i]
		for cond in s:set
			if XPATH_DEBUG
				?? "XPath: get list for "+cond:axis+':'+cond:name,chr(10)
			endif
			switch cond:axis
				case 'root'
					c := e
					while c:parent != NIL
						c := e:getParent()
					enddo
					aadd( v, c )
				
				case 'child'
					name := cond:name
					for c in e:getChilds()
						if name == '*' .or. name == c:getName()
							aadd( v, c )
						endif
					next
				otherwise
					lastError := "Axis '"+cond:axis+"' isn't yet implemented."
					return NIL
			endswitch
		next
	next
	if XPATH_DEBUG
		?? "XPath: list:", chr(10)
		for c in v
			?? '    <'+c:name+'>'+chr(10)			
		next
	endif
	
return v

/* Evaluate expression or function */
static function _xpath_evalExpr( expr, context )
	local v:=NIL, tv:=NIL, e, args:={}, s, i, lastOp:=NIL
	local fi, se, logics:={} 
	
	if expr:type == XPATH_BLOCK_FUNCTION
		// Function
		for e in expr:childs
			tv := _xpath_evalExpr( e, context )
			if tv == NIL .and. .not. empty( lastError )
				return NIL
			else
				aadd( args, tv )
			endif
		next
		if XPATH_DEBUG
			s := "Call " + expr:name + "("
			for e in args
				switch valtype( e )
					case 'C'
						s += '"' + e + '"'
					case 'N'
						s += alltrim( str( e ) )
					case 'L'
						s += iif( e, '.T.', '.F.' )
					otherwise
						s += 'NIL'
				endswitch
				s += ','
			next
			s := left( s, len( s ) - 1 ) + ')...' + chr(10)
			?? s
			
		endif
		tv   := _xpath_callFunction( expr:name, args, context, expr:pos )
		if XPATH_DEBUG
			?? "_xpath_callFunction() =", tv, chr(10)
		endif
		if tv == NIL
			return NIL
		endif
			
	elseif expr:type == XPATH_BLOCK_EXPRESSION
		
		// Expression
		for e in expr:childs
			if e:type == XPATH_BLOCK_FUNCTION
				tv := _xpath_evalExpr( e, context )
				if tv == NIL
					return NIL
				endif	
			elseif e:type == XPATH_TOKEN_OPERATOR
				if lastOp != NIL
					lastError := "Syntax error at "+ltrim( str( e:pos )+": unexpected operator '"+e:token+"'" )
					return NIL
				endif
				lastOp := e
				loop
			else // Ordinary value
				//?? "Token:", "TOKEN" $ e, e:type, chr(10)
				if lastOp == NIL
					v := e:token
				else
					tv := e:token
				endif
			endif
			
			// Calculation
			if lastOp != NIL
				//?? "last:", lastOp, chr(10)
				//?? "VAL =", v, lastOp:token, tv, chr(10)
				fi := v
				se := tv
				
				if ascan( { '+','-','*','/','mod','div' }, {|e| e == lastOp:token } ) > 0
				    	if valtype(fi) == valtype(se) .and. valtype(fi) == 'N' 
					    
				    	    // Zero divide check
					    if ascan( { '/','mod','div' }, {|e| e == lastOp:token } ) > 0 .and. se == 0
					    	lastError := 'Zero divide at '+ltrim( str( e:pos ) )
						return NIL
					    endif
				    	    
				    	    // Operation
				    	    switch lastOp:token
				    	    	case '+'; v := fi + se
				    	    	case '-'; v := fi - se
				    	    	case '*'; v := fi * se
				    	    	case '/'; v := fi / se
						case 'mod'; v := fi % se
						case 'div'; v := fi/se - int(fi/se)
				    	    endswitch
				    	else
					    lastError := "Illegal type for operator '"+lastOp:token+"' at "+ltrim( str( e:pos ) )
					    return NIL
					endif
				
				elseif ascan( { '=','!=','<=','<','>=','>','and','or' }, {|e| e == lastOp:token } ) > 0
					lastOp:predicate := v
					v := NIL
					aadd( logics, lastOp )
				
				else
					    lastError := "Unknown operator '"+lastOp:token+"' at "+ltrim( str( e:pos ) )
					    return NIL
				endif
				lastOp := NIL
				
				?? "Result:", v, chr(10)
			endif
		next
		
		// TODO: Process queued logical instructions
		for i in logics
			?? "LOGIC:", i:predicate, i:token, chr(10)
		next
		
	endif
	
	if v == NIL .and. tv != NIL
		v := tv
	endif

return v

/* TODO: Call XPath function */
static function _xpath_callFunction( name, args, pos, context, cPos )
	local v, i
	
	switch name
	    
	    case 'last'
	    	if valtype( context) == 'A'
	    		return len( context )
		else
			return 0
		endif
	    
	    case 'position'
	    	if valtype( context) == 'A'
	    		return cPos
		else
			return 0
		endif
	    
	    // TODO case 'count'
	    // TODO case 'id'
	    // TODO case 'local-name'
	    // TODO case 'namespace-uri'
	    // TODO case 'name'
	    
	    case 'string'
    	    	if len(args) < 1
	    		lastError := 'Insufficient arguments for '+name+'()'; return NIL
		elseif .not. valtype(args[1]) $ 'CNOL'
	    		lastError := 'Illegal type for first argument in '+name+'()'; return NIL
	    	else
	    		switch valtype(args[1])
				case 'C'
	    				v := args[1]
	    			case 'N'
	    				v := ltrim( str( args[1] ) )
	    			//TODO case 'O'
	    				//v := len(args[1]) > 0
	    			case 'L'
	    				v := iif(args[1], 'true', 'false')
	    		endswitch	    	
		endif	    
	    
	    case 'concat'
	    	if len(args) < 2
	    		lastError := 'Insufficient arguments for '+name+'()'; return NIL
	    	else
	    		v := ''
	    		for i:=1 to len( args )
	    			if valtype( args[i] ) == 'C'
	    				v += args[i]
				else
					lastError := 'Illegal type for argument '+ltrim( str( i ) )+' in '+name+'()'
					return NIL
				endif
	    		next
			return v
		endif
	    
	    case 'starts-with'
	    	if len(args) < 2
	    		lastError := 'Insufficient arguments for '+name+'()'; return NIL
		elseif valtype(args[1]) != 'C'
	    		lastError := 'Illegal type for first argument in '+name+'()'; return NIL
		elseif valtype(args[2]) != 'C'
	    		lastError := 'Illegal type for second argument in '+name+'()'; return NIL
		else
			v := left( args[1], len( args[2] ) )
			return v == args[2]
		endif
	    
	    case 'contains'
	    	if len(args) < 2
	    		lastError := 'Insufficient arguments for '+name+'()'; return NIL
		elseif valtype(args[1]) != 'C'
	    		lastError := 'Illegal type for first argument in '+name+'()'; return NIL
		elseif valtype(args[2]) != 'C'
	    		lastError := 'Illegal type for second argument in '+name+'()'; return NIL
		else
			return args[2] $ args[1]
		endif
	    
	    // TODO case 'substring-before'
	    // TODO case 'substring-after'
	    // TODO case 'substring'
	    case 'string-length'
	    	if len(args) < 1
	    		lastError := 'Insufficient arguments for '+name+'()'; return NIL
		elseif valtype(args[1]) != 'C'
	    		lastError := 'Illegal type for first argument in '+name+'()'; return NIL
	    	else
	    		return len( args[1] )
		endif	    
	    
	    // TODO case 'normalize-space'
	    // TODO case 'translate'
	    
	    case 'boolean'
    	    	if len(args) < 1
	    		lastError := 'Insufficient arguments for '+name+'()'; return NIL
		elseif .not. valtype(args[1]) $ 'CNOL'
	    		lastError := 'Illegal type for first argument in '+name+'()'; return NIL
	    	else
	    		switch valtype(args[1])
				case 'C'
	    				v := .not. empty(args[1])
	    			case 'N'
	    				v := args[1] <> 0
	    			case 'O'
	    				v := len(args[1]) > 0
	    			case 'L'
	    				v := args[1]
	    		endswitch	    	
		endif	    
	    
	    case 'not'
	    	if len(args) < 1
	    		lastError := 'Insufficient arguments for '+name+'()'; return NIL
		elseif valtype(args[1]) != 'L'
	    		lastError := 'Illegal type for first argument in '+name+'()'; return NIL
	    	else
	    		return .not. args[1]
		endif	    
	    
	    case 'true'
	    	return .T.
	    
	    case 'false'
	    	return .F.
	    
	    // TODO case 'lang'
	    
	    case 'number'
    	    	if len(args) < 1
	    		lastError := 'Insufficient arguments for '+name+'()'; return NIL
		elseif .not. valtype(args[1]) $ 'CNOL'
	    		lastError := 'Illegal type for first argument in '+name+'()'; return NIL
	    	else
	    		switch valtype(args[1])
				case 'C'
	    				v := val(args[1])
	    			case 'N'
	    				v := args[1]
	    			//TODO case 'O'
	    				//v := len(args[1]) > 0
	    			case 'L'
	    				v := iif(args[1], 1, 0)
	    		endswitch	    	
		endif	    
	    
	    // TODO case 'sum'
	    // TODO case 'floor'
	    // TODO case 'ceiling'
	    
	    case 'round'
	    	if len(args) < 1
	    		lastError := 'Insufficient arguments for '+name+'()'; return NIL
		elseif valtype(args[1]) != 'N'
	    		lastError := 'Illegal type for first argument in '+name+'()'; return NIL
	    	else
	    		return round( args[1], 0 )
		endif	    
	    
	    
	    otherwise
	    	lastError := "Unknown function '" + name + "' at " + ltrim( str( pos ) )
	    	return NIL
	
	endswitch
return NIL

/* Dump XPatch expression block */
static function _xpath_dumpBlock( b, level )
	local l, s:='', childs:={}, cN
	
	l := replicate( '    ', level )
	switch b:type
		case XPATH_BLOCK_NODESET
			s := '[NODESET]'
			childs := b:set
		case XPATH_BLOCK_NODES
			s := '<' + b:axis + ':' + b:name + '>'
			if 'SCOPE' $ b
				childs := b:scope
			endif
		case XPATH_BLOCK_FUNCTION
			s := b:name + '()'
			childs := b:childs
		case XPATH_BLOCK_EXPRESSION
			s := '[EVAL]'
			childs := b:childs
		otherwise
			s := '[UNKNOWN]'
			if 'TOKEN' $ b
				switch valtype( b:token )
					case 'C'
						s := '"' + b:token + '"'
					case 'N'
						s := alltrim( str( b:token ) )
					case 'L'
						s := iif( b:token, '.T.', '.F.' )
				endswitch
			endif
	endswitch
	?? l + s + chr( 10 )
	for cN in childs
		_xpath_dumpBlock( cN, level + 1 )
	next
	
return NIL
