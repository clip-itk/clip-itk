/*                                                                            */
/*    Copyright (C) 2003  ITK                                                 */
/*    Author   : Alena Kornilova(alena@itk.ru)                                */
/*    Licence : (GPL) http://www.itk.ru/clipper/licence.html                  */
/*                                                                            */
/*	Convertor text functions descriptions to sgml format.                 */
/*                                                                            */

#define __FAST__LINK	1

static docbook_tags := { ;
	'command', ;
	'link', ;
	'itemizedlist', ;
	'orderedlist', ;
	'simplelist', ;
	'variablelist', ;
	'listitem', ;
	'emphasis' ;
}

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
	argn := .f.
	argd := .f.
	lang := .f.
	lEnd := .t.
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
qout("&\nTotal functions: "+ltrim(toString(len(fs))))

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

qqout("&\n")

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
static function trans(pstr, all)
local str, newstr, l, i, j, s, tag, reg
	str := pstr
	newstr := ""
	all := iif(all==NIL, .t., all)

	if all
		while len(str) > 0
			reg := {}
			if search('[<&>]', str, @reg)
				i := reg[1][1]
				newstr += left(str, i-1)
				str := substr(str, i)
			else
				newstr += str
				str := ''
				loop
			endif			
			s := left(str, 1)
			if s == "<"
				if left(lower(str), 5) == "<pre>"
					newstr += "<programlisting><![CDATA["
					str := substr(str, 6)
					loop
				elseif left(lower(str), 6) == "</pre>"
					newstr += "]]></programlisting>"
					str := substr(str, 7)
					loop
				elseif left(str,9) == '<![CDATA['
					j := at(']]>', str)
					if j==0
						newstr += str
						str := ''
						loop
					else
						newstr += left(str, j+2)
						str := substr(str, j+3)
					endif
				else
					// Check allowed tags
					j := ascan(docbook_tags, {|e| left(lower(str),len(e)+1) == '<'+e .or. left(lower(str),len(e)+2) == '</'+e })
					if j > 0
						tag := docbook_tags[j]
						i = at('>', str )
						if i > 0
							newstr += left(str, i)
							str := substr(str, i+1)
							loop
						else
							newstr += '&lt;'
						endif
					else
						newstr += '&lt;'
					endif
				endif
			elseif s== ">"
				newstr += '&gt;'
			elseif s== "&"
				newstr += '&amp;'
			else
				newstr += s
			endif
			str := substr(str, 2)
		enddo
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
local i, j, a, str, lStr, arr, lf

	qout( "Write to: "+fname+" function:"+fs:FUNCNAME)

	str := '<refsect2>&\n<title><anchor id="function'+fs:SGMLID+'">Function '+fs:FUNCNAME+' </title>&\n'
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

	str := "<programlisting>&\n"

	if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:SYNTAX)
		str += '<![CDATA['+fs[lang]:SYNTAX+']]>&\n'
	else
		str += '<![CDATA['+fs:SYNTAX+']]>&\n'
	endif
	str += "&\n</programlisting>&\n"
	fwrite(fsgml, str, len(str))

	a:=NIL
	if lang != "EN" .and. (lang $ fs)  .and. !empty(fs[lang]:DESCRIPTION)
		a := split_str(fs[lang]:DESCRIPTION, "&\n")
	else
		a := split_str(fs:DESCRIPTION, "&\n")
	endif
	if empty(a)
		if lang != "EN" .and. (lang $ fs)  .and. !empty(fs[lang]:SUMMARY)
			a := split_str(fs[lang]:SUMMARY, "&\n")
		else
			a := split_str(fs:SUMMARY, "&\n")
		endif
	endif
	str := "<para>&\n"
	for i=1 to len(a)
		if empty(a[i])
			str += "</para>&\n<para>&\n"
		endif
		str += a[i]+"&\n"
	next
	fwrite(fsgml, str, len(str))
	str := "</para>&\n"

	fwrite(fsgml, str, len(str))

	str := '<informaltable pgwide="1" frame="none" role="params"><tgroup cols="2">&\n<colspec colwidth="2*">&\n<colspec colwidth="8*">&\n<tbody>&\n'
	if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:ARGS)
		for i=1 to len(fs[lang]:ARGS)
			if empty(fs[lang]:ARGS[i][2])
				loop
			endif
			str += '<row><entry align="right" valign="top"><parameter><![CDATA['+fs[lang]:ARGS[i][1]+']]></parameter></entry>&\n'
			str += '<entry><para>'+trans(fs[lang]:ARGS[i][2])+'</para></entry></row>&\n'
		next
	else
		for i=1 to len(fs:ARGS)
			if empty(fs:ARGS[i][2])
				loop
			endif
			str += '<row><entry align="right" valign="top"><parameter><![CDATA['+fs:ARGS[i][1]+']]></parameter></entry>&\n'
			str += '<entry><para>'+trans(fs:ARGS[i][2])+'</para></entry></row>&\n'
		next
	endif
	fwrite(fsgml, str, len(str))

	str := '<row><entry align="right" valign="top"><emphasis>Returns :</emphasis></entry>&\n'
	if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:RETURNS)
		str += '<entry><para>'+trans(fs[lang]:RETURNS)+'</para></entry></row>&\n'
	else
		if !empty(fs:RETURNS)
			str += '<entry><para>'+trans(fs:RETURNS)+'</para></entry></row>&\n'
		else
			str += '<entry>NIL</entry></row>&\n'
		endif

	endif
	fwrite(fsgml, str, len(str))

	if !empty(fs:SEEALSO)
		str := '<row><entry align="right" valign="top"><emphasis>See also :</emphasis></entry><entry>&\n'
		a := split(fs:SEEALSO, ",")
		for j=1 to len(a)
			if empty(a[j])
				loop
			endif
			lf := .f.
			if atr("(",a[j])>0
				lf := .t.
			endif
			i := strtran(a[j], "(", "")
			i := strtran(i, ")", "")
			i := strtran(i, "_", "")
			i := strtran(i, "*", "")
			i := alltrim(i)
			str += '<link linkend="'+iif(lf, 'function', 'class')+i+'">'+a[j]+'</link> '
		next
		str += '</entry></row>&\n'
	endif
	str += '</tbody></tgroup></informaltable>&\n'
	fwrite(fsgml, str, len(str))
	
	str := ""
	if !empty(fs:PECULIARITIES)
		str += '<para>&\n<command>Peculiarities: </command>&\n'
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
	endif

	if !empty(fs:AUTHOR)
		str += '<para>&\n<command>Author: </command>&\n'
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
	endif

	if !empty(fs:PLATFORMS)
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
	endif

	if !empty(fs:EXAMPLES)
		str := '<informalexample><para><command>Example :</command></para>&\n'
		str += '<programlisting><![CDATA[&\n'
		if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:EXAMPLES)
			str += trans(fs[lang]:EXAMPLES, .f.)
		else
			str += trans(fs:EXAMPLES, .f.)
		endif
		str += ']]></programlisting>&\n'
		str += '</informalexample><!-- EXAMPLE for '+fs:FUNCNAME+' -->&\n'
		fwrite(fsgml, str, len(str))
	endif

	str := '</refsect2><!-- End function '+fs:FUNCNAME+' -->&\n'
	fwrite(fsgml, str, len(str))

	qqout("..... done")
	fs := NIL
return

*******************************************************************************
static function WriteFuncsOrder(outfile, lang, fs, ab_order, categ)
local str, i, j, x, key, val, nam, ab_part, key1, key2, fsgml

fsgml := fcreate(outfile)
str := '<part id="abfunctions"><title>CLIP Functions in alhabetic order</title>&\n'
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
	str := '<article id="functions'+ab_part[j][1]+'"><title>'+ab_part[j][2]+'</title>&\n'
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

	str := '</article><!-- '+ab_part[j][2]+' functions -->&\n'
	fwrite(fsgml, str, len(str))
next

str := "</part> <!-- CLIP funcs in alphabetical order -->&\n"
fwrite(fsgml, str, len(str))
//str := '</article>&\n'
//#ifndef __FAST__LINK
str := '<part id="ctfunctions"><title>CLIP Functions by categories</title>&\n'
fwrite(fsgml, str, len(str))
/* write categories */
for i=1 to len(categ)
	str := "&fncsect"+alltrim(tostring(i))+";&\n"
	fwrite(fsgml, str, len(str))
next
str := '</part><!-- CLIP funcs by categories -->&\n'
//#endif
fwrite(fsgml, str, len(str))
fclose(fsgml)
return ab_part

*******************************************************************************
// TODO: make sections as table

static function writeSection(fname, lang, fs, categ)
local x, i, j, key, val, nam, str, fsec, awr, fn, cat, ii, syn, s, lpre
	awr:={}
	asize(awr, len(fs))
	afill(awr, .f.)
	x := 1
	for i in categ keys
		fn := fname+"fncsect"+alltrim(toString(x))+".sgml"
		x++
		fsec := fcreate(fn)
		key := categ[i][1]
		str := '<refentry id="categ'+categ[i][3]+'">&\n<refmeta><refentrytitle>'+key+'</refentrytitle>&\n</refmeta>&\n'
		fwrite(fsec, str, len(str))
		str := '<refnamediv>&\n<refname>'+key+'</refname>&\n'
		fwrite(fsec, str, len(str))
		str := "<refpurpose>&\n"
		val := categ[i][5]
		if !empty(val)
			if lang $ val
				cat := categ[i][5][lang]
			elseif "EN" $ val
				cat := categ[i][5]:EN
			endif
			if !empty(cat)
				for ii=1 to len(cat)
					str += " "+trans(cat[ii])
				next
			else
				str += " "
			endif
		endif
		str += "&\n</refpurpose>&\n"
		fwrite(fsec, str, len(str))
		str := "</refnamediv>&\n"
		fwrite(fsec, str, len(str))

		str := '<refsynopsisdiv><title>Function</title>&\n<synopsis>&\n'
		fwrite(fsec, str, len(str))
		for j=1 to categ[i][2]:len()
			key := categ[i][2]:getkey(j)
			val := categ[i][2]:getdata(j)
			//nam := fs[val]:FUNCNAME
			nam := strtran(alltrim(fs[val]:SYNTAX), "&\n", "")
			s := atr("-->", nam)
			if s > 0
				syn := "<![CDATA["+padr(alltrim(substr(nam, s+3)), 20)+"]]>"
				nam := substr(nam, 1, s-1)
				nam := "<![CDATA["+alltrim(nam)+"]]>"
			else
				syn := "<![CDATA["+padr(" ", 20)+"]]>"
				nam := "<![CDATA["+alltrim(nam)+"]]>"
			endif
			if lang != "EN" .and. (lang $ fs[val]) .and. ("SUMMARY" $ fs[val][lang])
				val := trans(iif(!empty(fs[val][lang]:SUMMARY), fs[val][lang]:SUMMARY, fs[val]:SUMMARY))
			else
				val := trans(fs[val]:SUMMARY)
			endif
			if empty(val)
				loop
			endif
			str := syn+'<link linkend="function'+key+'">'+nam+'</link>&\n'
			fwrite(fsec, str, len(str))
		next
		str := '</synopsis>&\n</refsynopsisdiv>&\n'
		fwrite(fsec, str, len(str))

		str := "<refsect1>&\n<title>Description </title>&\n"
		str += "<para>&\n"
		val := categ[i][4]
		if !empty(val)
			cat := NIL
			if lang $ val
				cat := categ[i][4][lang]
			elseif "EN" $ val
				cat := categ[i][4]:EN
			endif
			if !empty(cat)
				lPre := .f.
				for ii=1 to len(cat)
					if empty(cat[ii]) .and. !lPre
						str += "</para>&\n<para>&\n"
					endif
					str += trans(cat[ii])+"&\n"
					if atl("<pre>", lower(cat[ii])) > 0
						lPre := .t.
					endif
					if atl("</pre>", lower(cat[ii])) > 0
						lPre := .f.
					endif
				next
			endif
		endif
		str += "&\n</para>&\n"
		fwrite(fsec, str, len(str))
		for j=1 to categ[i][2]:len()
			val := categ[i][2]:getdata(j)
			if !awr[val]
				writeFncDesc(fn, fsec, fs[val], lang)
				awr[val] := .t.
			endif
		next
		str := "</refsect1>&\n</refentry>&\n"
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
				categ[s]:= {a[i], tSortedArrayNew(), s, map(), map()}
			endif
			categ[s][2]:Add(fs[x]:SGMLID, x)
		next
	endif
return 1

*******************************************************************************
static function parseArguments(fsrc, fs, alang)
local str, s, lang:="EN", argname, argdesc:="", x, lpre := .f., llist := .f., litem := .f.
local instr, j
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
		if  llist
			j := atl("</itemizedlist>", lower(str))
			if j>0
				llist := .f.
				argdesc += substr(str, 1, j+15)
				str := substr(str, j+16)
				s := upper(str)
			else
				llist := .t.
				argdesc += str
				str := ""
				loop
			endif
		endif
		if  litem
			j := atl("</listitem>", lower(str))
			if j>0
				litem := .f.
				argdesc += substr(str, 1, j+11)
				str := substr(str, j+12)
				s := upper(str)
			else
				llist := .t.
				argdesc += str
				str := ""
				loop
			endif
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


		if  left(lower(str), 13) == "<itemizedlist"
			j := atl("</itemizedlist>", lower(str))
			if j>0
				llist := .f.
				argdesc += substr(str, 1, j+15)
				str := substr(str, j+16)
				loop
			else
				llist := .t.
				argdesc += str
				str := ""
				loop
			endif
		elseif  left(lower(str), 9) == "<listitem"
			j := atl("</listitem>", lower(str))
			if j>0
				litem := .f.
				argdesc += substr(str, 1, j+11)
				str := substr(str, j+12)
				loop
			else
				litem := .t.
				argdesc += str
				str := ""
				loop
			endif
		elseif left(str, 1) == "<" .and. (lower(left(str, 5)) != "<pre>" .and. lower(left(str, 6)) != "</pre>")
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
local str, s, lang:="EN", cname, cidname, descr := {}, lDesc := .f., lSumm := .f., lCn:=.f.
local summ := {}
	do while !fileeof(fsrc)
		str := alltrim(filegetstr(fsrc))
		s := upper(str)
		if s == "$DESCRIPTION$"
			lDesc := .t.
			lSumm := .f.
			lang := "EN"
			loop
		endif
		if s == "$SUMMARY$"
			lSumm := .t.
			lDesc := .f.
			lang := "EN"
			loop
		endif
		if left(s, 6) == "$LANG_"

			if lDesc
				if !empty(descr)
					if !(cidname $ categ)
						categ[cidname]:= {cname, tSortedArrayNew(), cidname, map(), map()}
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

			if lSumm
				if !empty(summ)
					if !(cidname $ categ)
						categ[cidname]:= {cname, tSortedArrayNew(), cidname, map(), map()}
					endif
					categ[cidname][5][lang] := summ
				endif
				str := upper(substr(s, 7))
				str := substr(str, 1, len(str)-1)
				if ascan(alang, str) < 1
					aadd(alang, str)
				endif
				lang := str
				summ := {}
				loop
			endif
		endif
		if left(s, 1) == "$" .and. right(s, 1) == "$"
			exit
		endif

		if !lDesc .and. !lSumm
			cname := s
			cidname := strtran(strtran(cname, "/", ""), " ", "")
			lCn := .f.
			loop
		endif

		if lDesc
			aadd(descr, str)
		else
			aadd(summ, str)
		endif

	enddo
	if !empty(descr)
		if !(cidname $ categ)
			categ[cidname]:= {cname, tSortedArrayNew(), cidname, map(), map()}
		endif
		categ[cidname][4][lang] := descr
	endif
	if !empty(summ)
		if !(cidname $ categ)
			categ[cidname]:= {cname, tSortedArrayNew(), cidname, map(), map()}
		endif
		categ[cidname][5][lang] := summ
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
