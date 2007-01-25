/**
	Test program for XMLTree
*/
#define SPACER	'    '
#define VERBOSE	.F.

/* TODO: decorated output for XPath result */

function main( cmd, path )
	local f, tm, c, t1, t2, t3, i, node, tstr, attr, tr, tr2

	tm := seconds()

	// Create XMLTree object
	f := XMLTree() // "koi8-r" )
	if cmd != 'dump' .and. cmd != 'create'
		if VERBOSE; ?? "XMLTree() created&\n"; endif
	endif
	
 	if cmd != 'create'
		// Parse file
		if .not. f:parseFile( "component.xml" )
			// Output error description and exit
			?? "ERROR:", f:getError(), chr(10)
			return 1
		endif
	else
		// Create root tag
		t1 := XMLTag( "languages" )
		f:setRoot( t1 )
		
		// Create two child tags and fill texts and attributes
		t2 := XMLTag( "lang" )
		t2:setAttribute( "code", "en" )
		t2:setText( "English" )
		
		t3 := XMLTag( "lang" )
		t3:setAttribute( "code", "ru" )
		t3:setText( "Русский" )
		
		// Create empty tag
		tr := XMLTag("to-remove")
		tr:pos := 5
		tr2 := XMLTag("to-remove2")
		tr2:pos := 15
		tr:addChild( tr2 )
		
		// Add child tags
		t1:addChild( t2 )
		t1:addChild( t3 )
		t1:addChild( tr )
		tr:remove()

	endif
	
	if cmd != 'dump' .and. cmd != 'create'
		if VERBOSE; ?? "parseFile(&\"component.xml&\") done&\n"; endif
	endif
	
	switch cmd
		
		case 'count'
			c := map()
			c:tags := 0
			c:text := 0
			countTags( f:getRoot(), c )
			?? "Tags:", c:tags, chr(10)
			?? "Text:", c:text, "characters", chr(10)
		
		case 'dump'
			?? f:dump()
		
		case 'create'
			?? f:dump()
		
		case 'path'
			c := f:XPath( path )
			if .not. empty( xml_XPathError() )
				?? "ERROR:", xml_XPathError(),chr(10)
				return 1
			endif
			if valtype(c) == 'A'
				for i:=1 to len(c)
					node := c[i]
					if valtype(node) == 'O'
						tstr := "<" + node:getName()
						for attr in node:getAttributes()
							tstr += " " + attr[1] + '="' + attr[2] + '"'
						next
						tstr += ">" + node:getText() + "</" + node:getName() + ">"
						?? tstr + chr(10)
					else
						?? c,chr(10)
					endif
				next
			else
				?? c,chr(10)
			endif
		
		otherwise
			?? "Available commands:&\n"
			?? "    count           Count all tags and text characters&\n"
			?? "    create          Manually create simple XML file &\n"
			?? "    dump            Dump tree as XML file&\n"
			?? "    path <XPath>    Show elements selected by XPath&\n"
	endswitch

	if cmd != 'dump' .and. cmd != 'create'
		if VERBOSE; ?? "Processed time:", alltrim(str(seconds()-tm)), "sec&\n"; endif
	endif
return 0

function countTags( tag, counter )
	local i
	counter:tags++
	counter:text += len(tag:text)
	for i in tag:childs
		countTags( i, counter )
	next
return
