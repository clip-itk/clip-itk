/*                                                                            */
/*    Copyright (C) 2003  ITK                                                 */
/*    Author   : Alena Kornilova(alena@itk.ru)                                */
/*    Licence : (GPL) http://www.itk.ru/clipper/licence.html                  */
/*                                                                            */
/*	Convertor text functions descriptions to sgml format.                 */
/*                                                                            */

#define __FAST__LINK	1

function main()
local fsrc, fsgml, str, outfile, i, j, par, fname, t, x
local argn, argd, categ, ab_order, ab_part, fs, ii, jj, key, val, lang
local outdir, s, outlang:={"EN"},alang:={"EN"}, lEnd, l_l

//clear screen

for i=1 to pcount()
	j := upper(param(i))
	if ascan(alang, j) < 1
		//aadd(alang, j)
		aadd(outlang, j)
	endif
next
outfile := "funcs.sgml"
outdir := "sgml"

dirchange("funcs")
par := RecursiveDirectory("*", "funcs/")
dirchange("../")

categ := map() // listing functions by category
ab_order := tSortedArrayNew()


fs := {}
x := 0
for ii=1 to len(par)
	fname := par[ii][1]
	if !(right(fname, 4) == ".txt")
		loop
	endif
	if !file(fname)
		qout("File not found "+fname)
	endif
	qout("Parse "+fname)
	fsrc := fopen(fname, 0)
	t := .f.
	j := 0
	do while !fileeof(fsrc)
		str := alltrim(filegetstr(fsrc))
		s := upper(str)
		if s == "$ABOUTCATEG$"
			str := parseCateg(fsrc, categ, alang)
			s := upper(str)
		endif
		if s == "$FUNCNAME$"
			aadd(fs, FuncsObjNew(fname))
			x++
			argn := .f.
			argd := .f.
			t := .f.
			lEnd := .f.
		endif
		if s == "$ARGUMENTS$"
			str := parseArguments(fsrc, fs[x], alang)
			s := upper(str)
		endif
		do case
		case s == "$END$"
			addToOrder(fs, @x, ab_order, categ, fname)
			lEnd := .t.
		case s == "$ARGNAME$"
			argn := .t.
			argd := .f.
			t := .f.
			lang := .f.
			l_l := "EN"
			j++
		case s == "$ARGDESC$"
			argd := .t.
			lang := .f.
			l_l := "EN"
		case left(s, 6) == "$LANG_"
			lang := .t.
			str := upper(substr(s, 7))
			str := substr(str, 1, len(str)-1)
			if ascan(alang, str) < 1
				aadd(alang, str)
			endif
			l_l := str
		case left(s, 1) == "$" .and. right(s, 1) == "$"
			t := .t.
			argn := .f.
			argd := .f.
			lang := .f.
			l_l := "EN"
			key := strtran(s, "$", "")
			if key == "ONELINER"
				key := "SUMMARY"
			endif
		otherwise
			if !lang
				if argn .and. !argd
					key := str
				elseif argn .and. argd
					if len(fs[x]:ARGS)<j
						aadd(fs[x]:ARGS, {key, str})
					else
						fs[x]:ARGS[j][2] += " "+str
					endif
				elseif t
					if key $ fs[x]
						fs[x][key] += iif(!empty(fs[x][key]), "&\n ", " ")+str
					else
						fs[x][key] := str
					endif
				endif
			else
				if !(l_l $ fs[x])
					fs[x][l_l] := FuncsObjNew()
				endif
				if argn .and. !argd
					key := str
				elseif argn .and. argd
					if len(fs[x][l_l]:ARGS)<j
						aadd(fs[x][l_l]:ARGS, {key, str})
					else
						fs[x][l_l]:ARGS[j][2] += " "+str
					endif
				elseif t
					if key $ fs[x][l_l]
						fs[x][l_l][key] += iif(!empty(fs[x][l_l][key]), "&\n ", " ")+str
					else
						fs[x][l_l][key] := str
					endif
				endif
			endif
		endcase
	enddo
	fclose(fsrc)
	if !lEnd
		addToOrder(fs, @x, ab_order, categ, fname)
	endif
next
qout("&\n Summary functions:"+toString(len(fs)))

for i=1 to len(alang)
	if ascan(outlang, alang[i]) > 0
	makeDirectory(outdir+"/"+lower(alang[i])+"/clip-funcs")
	writeFuncsOrder(outdir+'/'+lower(alang[i])+"/clip-funcs/"+outfile, alang[i], fs, ab_order, categ)

	writeSection(outdir+'/'+lower(alang[i])+"/clip-funcs/", alang[i], fs, categ)
	endif
next

asize(fs, 0)
asize(ab_order, 0)
asize(categ, 0)

return

*******************************************************************************
static function FuncsObjNew()
local obj := map()

	obj:Args	:= {}
	obj:FuncName	:= ""
	obj:SGMLid	:= ""
	obj:Category	:= ""
	obj:Summary	:= ""
	obj:Syntax	:= ""
	obj:Returns	:= ""
	obj:Description	:= ""
	obj:Examples	:= ""
	obj:Peculiarities:= ""
	obj:Platforms	:= ""
	obj:Conforms	:= ""
	obj:SeeAlso	:= ""
	obj:Author	:= ""
	obj:LastDate	:= ""

return obj

*******************************************************************************
static function trans(str, all)
local newstr, l, i, j
	newstr := ""
	all := iif(all==NIL, .t., all)

	if all
		l := len(str)
		for i:= 1 to l
			s := left(str, 1)
			if s == "<"
				/*if left(lower(str), 5) == "<pre>"
					newstr += "&\n<programlisting>"
					j := atl("</pre>", lower(str))
					newstr += substr(str, 6, j-11) + "</programlisting>&\n"
					str := substr(str, j+6)
					loop
				else*/
				if left(lower(str), 5) == "<pre>"
					j := atl("</pre>", lower(str))
					newstr += substr(str, 1, j+5)
					str := substr(str, j+6)
					loop
				elseif  left(lower(str), 9) == "<command>"
					j := atl("</command>", lower(str))
					newstr += substr(str, 1, j+9)
					str := substr(str, j+10)
					loop
				elseif  left(lower(str), 5) == "<link"
					j := atl("</link>", lower(str))
					newstr += substr(str, 1, j+6)
					str := substr(str, j+7)
					loop
				else
					newstr += '<![CDATA['+s+']]>'
				endif
			elseif s== ">"
				newstr += '<![CDATA['+s+']]>'
			else
				newstr += s
			endif
			str := substr(str, 2)
		next
	else
		newstr := str
	endif

	newstr := strtran(newstr, chr(27), " ")
	newstr := strtran(newstr, chr(28), " ")
	newstr := strtran(newstr, chr(128), "-")
	newstr := strtran(newstr, chr(129), "|")
	newstr := strtran(newstr, chr(132), " ")
	newstr := strtran(newstr, chr(136), " ")
	newstr := strtran(newstr, chr(145), " ")
	newstr := strtran(newstr, chr(148), " ")
return newstr


*******************************************************************************
static function writefncdesc(fname, fsgml, fs, lang)
local i, j, a, str, lStr, arr

	qout( "Write to: "+fname+" function:"+fs:FUNCNAME)

	str := '<section id="function'+fs:SGMLID+'"><title>Function '+fs:FUNCNAME+' </title>&\n'
	fwrite(fsgml, str, len(str))

	if !empty(fs:LASTDATE)
		a := fs:LASTDATE
		if lang != "EN" .and. (lang $ fs)
			a := fs[lang]:LASTDATE
		endif
		if !empty(a) .and. a < fs:LASTDATE
			str := '<warning><para>The text of documentation not equal english variant!</para></warning>&\n'
			fwrite(fsgml, str, len(str))
		endif
	endif

	if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:SYNTAX)
		str := '<programlisting><![CDATA['+fs[lang]:SYNTAX+']]></programlisting>&\n'
	else
		str := '<programlisting><![CDATA['+fs:SYNTAX+']]></programlisting>&\n'
	endif
	fwrite(fsgml, str, len(str))

	str := '<section><title>Arguments</title>&\n'
	if empty(fs:ARGS)
		str += '<para>No arguments</para>&\n'
	else
		str += '<informaltable frame="none"><tgroup cols="2"><tbody>&\n'
		if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:ARGS)
			for i=1 to len(fs[lang]:ARGS)
				a := split_str(fs[lang]:ARGS[i][2], "&\n")

				str += '<row><entry align="right"><command><![CDATA['+fs[lang]:ARGS[i][1]+']]></command></entry>'
				str += '&\n'

				for j=1 to len(a)
					if j>1
						str += '<row><entry align="right"> </entry>'
					endif
					str += '<entry>'+a[j]+'</entry></row>&\n'
				next
			next
		else
			for i=1 to len(fs:ARGS)
				a := split_str(fs:ARGS[i][2], "&\n")
				str += '<row><entry align="right"><command><![CDATA['+fs:ARGS[i][1]+']]></command></entry>'
				str += '&\n'
				for j=1 to len(a)
					if j>1
						str += '<row><entry align="right"> </entry>'
					endif
					str += '<entry>'+a[j]+'</entry></row>&\n'
				next
			next
		endif

		str += '</tbody></tgroup></informaltable>&\n'

	endif
	str += '</section><!-- ARGS for '+fs:FUNCNAME+' -->&\n'
	fwrite(fsgml, str, len(str))

	str := '<section><title>Returns</title>&\n'
	if empty(fs:RETURNS)
		str += '<para>Returns NIL.</para>&\n'
	else
		str += '<para>&\n'
		if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:RETURNS)
			a := split_str(fs[lang]:RETURNS, "&\n")
		else
			a := split_str(fs:RETURNS, "&\n")
		endif
		for j=1 to len(a)
			if empty(a[j])
				str += '</para><para>&\n'
			else
				str += a[j]
			endif
		next
		str += '&\n</para>&\n'
	endif
	str += '</section><!-- RETURNS for '+fs:FUNCNAME+' -->&\n'
	fwrite(fsgml, str, len(str))

	str := '<section><title>Description</title>&\n'

	/*
	str += '<programlisting><![CDATA[&\n'
	if lang != "EN" .and. (lang $ fs)  .and. !empty(fs[lang]:DESCRIPTION)
		str += trans(fs[lang]:DESCRIPTION, .f.)
	else
		str += trans(fs:DESCRIPTION, .f.)
	endif
	str += ']]></programlisting>&\n'
	*/
	str += '<para>&\n'
	if lang != "EN" .and. (lang $ fs)  .and. !empty(fs[lang]:DESCRIPTION)
		a := split_str(fs[lang]:DESCRIPTION, "&\n")
	else
		a := split_str(fs:DESCRIPTION, "&\n")
	endif
	for j=1 to len(a)
		if empty(a[j])
			str += '</para><para>&\n'
		else
			str += a[j]
		endif
	next
	str += '&\n</para>&\n'

	str += '</section><!-- DESCRIPTION for '+fs:FUNCNAME+' -->&\n'
	fwrite(fsgml, str, len(str))


	str := '<section><title>Example</title>&\n'
	str += '<programlisting><![CDATA[&\n'
	if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:EXAMPLES)
		str += trans(fs[lang]:EXAMPLES, .f.)
	else
		str += trans(fs:EXAMPLES, .f.)
	endif
	str += ']]></programlisting>&\n'
	str += '</section><!-- EXAMPLE for '+fs:FUNCNAME+' -->&\n'
	fwrite(fsgml, str, len(str))



	str := '<section><title>Peculiarities</title>&\n'
	str += '<para>&\n'
	if lang != "EN" .and. (lang $ fs)  .and. !empty(fs[lang]:PECULIARITIES)
		a := split_str(fs[lang]:PECULIARITIES, "&\n")
	else
		a := split_str(fs:PECULIARITIES, "&\n")
	endif
	for j=1 to len(a)
		if empty(a[j])
			str += '</para><para>&\n'
		else
			str += a[j]
		endif
	next
	str += '&\n</para>&\n'
	str += '</section><!-- PECULIARITIES for '+fs:FUNCNAME+' -->&\n'
	fwrite(fsgml, str, len(str))


	str := '<section><title>See also</title>&\n'
	str += '<para>&\n'
	a := split(fs:SEEALSO, ",")
	for j=1 to len(a)
		if empty(a[j])
			loop
		endif
		i := strtran(a[j], "(", "")
		i := strtran(i, ")", "")
		i := strtran(i, "_", "")
		i := strtran(i, "*", "")
		i := alltrim(i)
		str += '<link linkend="function'+i+'">'+a[j]+'</link> '
	next
	str += '&\n</para>&\n'
	str += '</section><!-- SEEALSO for '+fs:FUNCNAME+' -->&\n'
	fwrite(fsgml, str, len(str))


	str := '<section><title>Author of documentation</title>&\n'
	str += '<para>&\n'
	if lang != "EN" .and. (lang $ fs).and. !empty(fs[lang]:AUTHOR)
		a := fs[lang]:AUTHOR
	else
		a := fs:AUTHOR
	endif
	arr := {}
	do while search("[a-zA-Z0-9\.\_]*@[a-zA-Z0-9\.\_]*", a, arr, 1)
		str += substr(a, 1, arr[1][1]-1)
		str += '<email>'
		str += substr(a, arr[1][1], arr[1][2]-arr[1][1])
		str += '</email>'
		a := substr(a, arr[1][2])
		arr := {}
	enddo
	str += a
	str += '&\n</para>&\n'
	str += '</section><!-- AUTHOR for '+fs:FUNCNAME+' -->&\n'
	fwrite(fsgml, str, len(str))

	str := '<section><title>Platforms</title>&\n'
	str += '<para>&\n'
	if lang != "EN" .and. (lang $ fs)  .and. !empty(fs[lang]:PLATFORMS)
		a := split(trans(fs[lang]:PLATFORMS), "&\n")
	else
		a := split(trans(fs:PLATFORMS), "&\n")
	endif
	for j=1 to len(a)
		if empty(a[j])
			str += '</para><para>&\n'
		else
			str += a[j]
		endif
	next
	str += '&\n</para>&\n'
	str += '</section><!-- PLATFORMS for '+fs:FUNCNAME+' -->&\n'
	fwrite(fsgml, str, len(str))


	str := '</section><!-- End function '+fs:FUNCNAME+' -->&\n'
	fwrite(fsgml, str, len(str))

	qqout("..... done")
	fs := NIL
return

*******************************************************************************
static function WriteFuncsOrder(outfile, lang, fs, ab_order, categ)
local str, i, j, x, key, val, nam, ab_part, key1, key2, fsgml

fsgml := fcreate(outfile)
str := '<chapter id="functions"><title>CLIP Functions</title>&\n'
str += '<section id="abfunctions"><title>Functions in alhabetic order</title>&\n'
ab_part := {}
for i=1 to ab_order:len()
	key1 := ab_order:getkey(i)
	i += 49
	if i > ab_order:len()
		i := ab_order:len()
	endif
	key2 := ab_order:getkey(i)
	aadd(ab_part, {key1+key2, key1+'()-'+key2+'()'})
next
fwrite(fsgml, str, len(str))
/* write order functions by 50 into part */
for j := 1 to len(ab_part)
	str := '<section id="functions'+ab_part[j][1]+'"><title>'+ab_part[j][2]+'</title>&\n'
	fwrite(fsgml, str, len(str))

	str := '<informaltable frame="none"><tgroup cols="2"><tbody>&\n'
	fwrite(fsgml, str, len(str))
	for i:=1 to 50
		if i+((j-1)*50) > ab_order:len()
			exit
		endif
		x := ab_order:getdata(i+((j-1)*50))
		key := ab_order:getkey(i+((j-1)*50))
		val := fs[x]:FUNCNAME
		str := '<row><entry><link linkend="function'+key+'">'+val+'</link></entry>&\n'
		val := trans(fs[x]:SUMMARY)
		if lang != "EN" .and. (lang $ fs[x]) .and. ("SUMMARY" $ fs[x][lang]) .and. !empty(fs[x][lang]:SUMMARY)
			val := trans(fs[x][lang]:SUMMARY)
		endif
		str += '<entry>'+val+'</entry></row>&\n'
		fwrite(fsgml, str, len(str))
	next
	str := '</tbody></tgroup></informaltable>&\n'
	fwrite(fsgml, str, len(str))

	str := '</section><!-- '+ab_part[j][2]+' functions -->&\n'
	fwrite(fsgml, str, len(str))
next

str := '</section>&\n'
#ifndef __FAST__LINK
str += '<section id="ctfunctions"><title>Functions by categories</title>&\n'
#endif
fwrite(fsgml, str, len(str))
str := ""
/* write categories */
for i=1 to len(categ)
	str += "&fncsect"+alltrim(tostring(i))+";&\n"
next
fwrite(fsgml, str, len(str))
#ifndef __FAST__LINK
str := '</section>&\n'
fwrite(fsgml, str, len(str))
#endif
str := '</chapter>&\n'
fwrite(fsgml, str, len(str))
fclose(fsgml)
return ab_part

*******************************************************************************
static function writeSection(fname, lang, fs, categ)
local x, i, j, key, val, nam, str, fsec, awr, fn, cat, ii
	awr:={}
	asize(awr, len(fs))
	afill(awr, .f.)
	x := 1
	for i in categ keys
		fn := fname+"fncsect"+alltrim(toString(x))+".sgml"
		x++
		fsec := fcreate(fn)
		key := categ[i][1]
		str := '<section id="categ'+categ[i][3]+'"><title>'+key+'</title>&\n'
		fwrite(fsec, str, len(str))
		#ifdef __FAST__LINK
		str := '<informaltable frame="none"><tgroup cols="1"><tbody>&\n'
		str += '<row><entry><link linkend="about'+categ[i][3]+'">About</link></entry></row>&\n'
		str += '<row><entry><link linkend="order'+categ[i][3]+'">Functions order</link></entry></row>&\n'
		str += '</tbody></tgroup></informaltable>&\n'
		fwrite(fsec, str, len(str))

		str := '<section id="about'+categ[i][3]+'"><title>About '+key+'</title>'
		str += '<para>' // start write about category
		val := categ[i][4]
		if !empty(val)
			if lang $ val
				cat := categ[i][4][lang]
			elseif "EN" $ val
				cat := categ[i][4]:EN
			endif
			if !empty(cat)
				for ii=1 to len(cat)
					if ii!=1
						str += "</para><para>&\n"
					endif
					str += trans(cat[ii])
				next
			endif
		endif
		str += '</para>&\n'	//stop write about category
		str += '</section>&\n'
		str += '<section id="order'+categ[i][3]+'"><title>'+key+' functions order</title>&\n'
		fwrite(fsec, str, len(str))
		#endif

		str := '<informaltable frame="none"><tgroup cols="2"><tbody>&\n'
		fwrite(fsec, str, len(str))
		for j=1 to categ[i][2]:len()
			key := categ[i][2]:getkey(j)
			val := categ[i][2]:getdata(j)
			nam := fs[val]:FUNCNAME
			if lang != "EN" .and. (lang $ fs[val]) .and. ("SUMMARY" $ fs[val][lang])
				val := trans(iif(!empty(fs[val][lang]:SUMMARY), fs[val][lang]:SUMMARY, fs[val]:SUMMARY))
			else
				val := trans(fs[val]:SUMMARY)
			endif
			str := '<row><entry><link linkend="function'+key+'">'+nam+'</link></entry><entry>'+val+'</entry></row>&\n'
			fwrite(fsec, str, len(str))
		next
		str := '</tbody></tgroup></informaltable>&\n'
		fwrite(fsec, str, len(str))
		for j=1 to categ[i][2]:len()
			val := categ[i][2]:getdata(j)
			if !awr[val]
				writeFncDesc(fn, fsec, fs[val], lang)
				awr[val] := .t.
			endif
		next
		str := '</section><!-- '+categ[i][1]+' categories -->&\n'
		#ifdef __FAST__LINK
		str += '</section>'
		#endif
		fwrite(fsec, str, len(str))
		fclose(fsec)
	next
return

*******************************************************************************
static function addToOrder(fs, x, ab_order, categ, fname)
local i, a, s
	fs[x]:FUNCNAME := strtran(upper(fs[x]:FUNCNAME), '*', '')
	fs[x]:SGMLID := alltrim(strtran(strtran(strtran(fs[x]:FUNCNAME, "(", ""), ")", ""), "_", ""))
	fs[x]:SGMLID := strtran(strtran(fs[x]:SGMLID, "/", ""), " ", "")
	if empty(fs[x]:FUNCNAME)
		qout("!!! File "+fname+" have empty FUNCNAME")
		adel(fs, x)
		x--
		asize(fs, x)
		return 0
	endif
	ab_order:Add(fs[x]:SGMLID, x)
	if !empty(fs[x]:CATEGORY)
		a := split(upper(fs[x]:CATEGORY), ",")
		for i=1 to len(a)
			a[i] := alltrim(a[i])
			s := strtran(strtran(a[i], "/", ""), " ", "")
			if !(s $ categ)
				categ[s]:= {a[i], tSortedArrayNew(), s, map()}
			endif
			categ[s][2]:Add(fs[x]:SGMLID, x)
		next
	endif
return 1

*******************************************************************************
static function parseArguments(fsrc, fs, alang)
local str, s, lang:="EN", argname, argdesc:="", x, lpre := .f.
local instr
	do while !fileeof(fsrc)
		instr := alltrim(filegetstr(fsrc))
		if !lpre .and. atl("<pre>", lower(instr))>0
			lpre := .t.
			str := ""
		endif
		if lpre
		       str += "&\n"+instr
		       if atl("</pre>", lower(instr))>0
				lpre := .f.
				s := upper(str)
		       else
				loop
		       endif
		else
			str := instr
			s := upper(str)
		endif
		if left(s, 6) == "$LANG_"
			if !empty(argname)
				writeArgs(fs, argname, argdesc, lang)
			endif
			str := upper(substr(s, 7))
			str := substr(str, 1, len(str)-1)
			if ascan(alang, str) < 1
				aadd(alang, str)
			endif
			lang := str
			argname := ""
			argdesc := ""
			loop
		endif
		if left(s, 1) == "$" .and. right(s, 1) == "$"
			if !empty(argname)
				writeArgs(fs, argname, argdesc, lang)
			endif
			exit
		endif

		if left(str, 1) == "<" .and. (lower(left(str, 5)) != "<pre>" .and. lower(left(str, 6)) != "</pre>")
			if !empty(argname)
				writeArgs(fs, argname, argdesc, lang)
			endif
			x := atl(">", str)
			argname := substr(str, 1, x)
			argdesc := substr(str, x+1)
		elseif !empty(argname)
			argdesc += "&\n "+str
		endif
	enddo
return str

*******************************************************************************
static function parseCateg(fsrc, categ, alang)
local str, s, lang:="EN", cname, cidname, descr := {}, lDesc := .f.
	do while !fileeof(fsrc)
		str := alltrim(filegetstr(fsrc))
		s := upper(str)
		if s == "$DESCRIPTION$"
			lDesc := .t.
			loop
		endif
		if left(s, 6) == "$LANG_"

			if !empty(descr)
				if !(cidname $ categ)
					categ[cidname]:= {cname, tSortedArrayNew(), cidname, map()}
				endif
				categ[cidname][4][lang] := descr
			endif
			str := upper(substr(s, 7))
			str := substr(str, 1, len(str)-1)
			if ascan(alang, str) < 1
				aadd(alang, str)
			endif
			lang := str
			descr := {}
			loop
		endif
		if left(s, 1) == "$" .and. right(s, 1) == "$"
			exit
		endif

		if !lDesc
			cname := s
			cidname := strtran(strtran(cname, "/", ""), " ", "")
			lCn := .f.
			loop
		endif

		aadd(descr, str)

	enddo
	if !empty(descr)
		if !(cidname $ categ)
			categ[cidname]:= {cname, tSortedArrayNew(), cidname, map()}
		endif
		categ[cidname][4][lang] := descr
	endif
return str

*******************************************************************************
static function writeArgs(fs, argname, argdesc, lang)
	if lang == "EN"
		aadd(fs:ARGS, {argname, argdesc})
	else
		aadd(fs[lang]:ARGS, {argname, argdesc})
	endif
return
*******************************************************************************
static function split_str(str, delim)
local arr, i, sp, ep, x, y
	arr := split(trans(str), delim)
	for i=1 to len(arr)
		x := atl("<pre>", lower(arr[i]))

		if  x == 0
			loop
		endif
		sp = i
		do while (y := atl("</pre>", lower(arr[i]))) == 0
			if x > 0
				arr[i] := substr(arr[i], 1, x-1)+"<programlisting><![CDATA["+substr(arr[i], x+5)
				i ++
				x := 0
			elseif (i-1>0)
				arr[i-1] += delim+arr[i]
				adel(arr, i)
				asize(arr, len(arr)-1)
			endif
		enddo
		if sp == i
			arr[i] := substr(arr[i], 1, x-1)+"<programlisting><![CDATA["+substr(arr[i], y-1)+"]]></programlisting>"+substr(arr[i], y+6)
		else
			arr[i-1] += delim+substr(arr[i], 1, y-1)+"]]></programlisting>"+substr(arr[i], y+6)
			adel(arr, i)
			asize(arr, len(arr)-1)
		endif
	next
return arr
