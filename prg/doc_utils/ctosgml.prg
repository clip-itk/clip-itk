/*                                                                            */
/*    Copyright (C) 2003  ITK                                                 */
/*    Author   : Alena Kornilova(alena@itk.ru)                                */
/*    Licence : (GPL) http://www.itk.ru/clipper/licence.html                  */
/*                                                                            */
/*	Convertor text classes descriptions to sgml format.                   */
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
local argn, argd, ab_order, ab_met, fs, ii, jj, key, val, lang
local outdir, s, outlang:={"EN"},alang:={"EN"}, lEnd, l_l, lMet, nMet

//clear screen
for i=1 to pcount()
	j := upper(param(i))
	if ascan(alang, j) < 1
		//aadd(alang, j)
		aadd(outlang, j)
	endif
next

outfile := "classes.sgml"
outdir := "sgml"

dirchange("classes")
par := RecursiveDirectory("*", "classes/")
dirchange("../")

ab_order := tSortedArrayNew()
ab_met := {}   // array of sorted array

fs := {}
x := 0
lMet := .f.
nMet := 0
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
	j := 0
	do while !fileeof(fsrc)
		str := alltrim(filegetstr(fsrc))
		s := upper(str)
		if s == "$CLASSNAME$"
			aadd(fs, ClassObjNew(fname))
			aadd(ab_met, tSortedArrayNew())
			x++
			for i=2 to len(aLang)
				fs[x][aLang[i]] := ClassObjNew(fname)
			next
			nMet := 0
			lMet := .f.
			lEnd := .f.
		endif

		if s == "$ATTRIBUTES$"
			str := parseArguments(fsrc, fs[x], alang)
			s := upper(str)
		endif

		if s == "$ARGUMENTS$" .and. lMet
//			str := parseArguments(fsrc, fs[x]:METHODS[nMet], alang, .f.)
			str := parseArguments(fsrc, fs[x], alang, nMet)
			s := upper(str)
		endif

		if s == "$METHODNAME$"
			lMet := .t.
			nMet++
			aadd(fs[x]:METHODS, MethodObjNew())
			for i=2 to len(aLang)
				aadd(fs[x][aLang[i]]:METHODS, MethodObjNew())
			next
		endif

		do case
		case s == "$ENDMETHOD$"  .and. lMet
			addMetToClass(fs[x]:METHODS, @nMet, ab_met[x], fname)
			lMet := .f.
		case s == "$END$"
			addToOrder(fs, @x, ab_order, fname)
			lEnd := .t.
		case left(s, 6) == "$LANG_"
			lang := .t.
			str := upper(substr(s, 7))
			str := substr(str, 1, len(str)-1)
			if ascan(alang, str) < 1
				aadd(alang, str)
			endif
			l_l := str
		case left(s, 1) == "$" .and. right(s, 1) == "$"
			lang := .f.
			l_l := "EN"
			key := strtran(s, "$", "")
			if key == "ONELINER"
				key := "SUMMARY"
			endif
		otherwise
			if !lang
				if !lMet // item is not methods item
					if key $ fs[x]
						fs[x][key] += iif(!empty(fs[x][key]), "&\n ", " ")+str
					else
						fs[x][key] := str
					endif
				else
					if key $ fs[x]:METHODS[nMet]
						fs[x]:METHODS[nMet][key] += iif(!empty(fs[x]:METHODS[nMet][key]), "&\n ", " ")+str
					else
						fs[x]:METHODS[nMet][key] := str
					endif
				endif
			else
				if !(l_l $ fs[x])
					fs[x][l_l] := ClassObjNew()
				endif
				if !lMet
					if key $ fs[x][l_l]
						fs[x][l_l][key] += iif(!empty(fs[x][l_l][key]), "&\n ", " ")+str
					else
						fs[x][l_l][key] := str
					endif
				else
					do while len(fs[x][l_l]:METHODS)<nMet
						aadd(fs[x][l_l]:METHODS, MethodObjNew())
					enddo
					if key $ fs[x][l_l]:METHODS[nMet]
						fs[x][l_l]:METHODS[nMet][key] += iif(!empty(fs[x][l_l]:METHODS[nMet][key]), "&\n ", " ")+str
					else
						fs[x][l_l]:METHODS[nMet][key] := str
					endif
				endif
			endif
		endcase
	enddo
	fclose(fsrc)
	if !lEnd
		addToOrder(fs, @x, ab_order, fname)
	endif
next
qout("&\nTotal classes:"+ltrim(toString(len(fs))))

for i=1 to len(alang)
	if ascan(outlang, alang[i]) > 0
	makeDirectory(outdir+"/"+lower(alang[i])+"/clip-classes")
	writeClassOrder(outdir+'/'+lower(alang[i])+"/clip-classes/"+outfile, alang[i], fs, ab_order)

	writeMethods(outdir+'/'+lower(alang[i])+"/clip-classes/", alang[i], fs, ab_order, ab_met)
	endif
next

asize(fs, 0)
asize(ab_order, 0)
asize(ab_met, 0)

qqout("&\n")

return

*******************************************************************************
static function ClassObjNew()
local obj := map()

	obj:ClassName	:= ""
	obj:Summary	:= ""
	obj:Syntax	:= ""
	obj:Attribs	:= {}
	obj:Methods	:= {}
	obj:Examples	:= ""
	obj:Platforms	:= ""
	obj:SeeAlso	:= ""
	obj:Author	:= ""
	obj:LastDate	:= ""
	obj:About	:= ""

return obj

*******************************************************************************
static function MethodObjNew()
local obj := map()

	obj:MethodName	:= ""
	obj:Summary	:= ""
	obj:Syntax	:= ""
	obj:Args	:= {}
	obj:Returns	:= ""
	obj:Description	:= ""

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
						i = at('>', str )
						tag := substr(str, len(docbook_tags[j])+iif(substr(str,2,1)=='/',3,2), 1 )
						if i > 0 .and. ( tag == '>' .or. tag == ' ' .or. tag == "&\t" )
							tag := left(str, i)
							if tag == '<listitem>'
								tag := tag + '<para>'
							elseif tag == '</listitem>'
								tag := '</para>' + tag
							endif
							newstr += tag
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
			elseif s== "&" .and. substr(str,2,1) == ' '
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
static function writeClassDesc(fname, fsgml, fs, lang, ab_met)
local i, j, a, str, lStr, arr, lf, val

	qout( "Write to: "+fname+" function:"+fs:CLASSNAME)

	str := '<refentry id="class'+fs:SGMLID+'">&\<refmeta><refentrytitle>Class '+fs:CLASSNAME+' </refentrytitle>&\n</refmeta>&\n'
	fwrite(fsgml, str, len(str))

	str := '<refnamediv>&\n<refname>'+fs:CLASSNAME+' </refname>&\n'
	fwrite(fsgml, str, len(str))

	str := '<refpurpose>&\n'
	fwrite(fsgml, str, len(str))
	str := ''
	if !empty(fs:ABOUT)
		if lang != "EN" .and. (lang $ fs)  .and. !empty(fs[lang]:ABOUT)
			str += fs[lang]:ABOUT
		else
			str += fs:ABOUT
		endif
	endif
	str += ' &\n</refpurpose>&\n'
	fwrite(fsgml, str, len(str))

	str := '</refnamediv>&\n'
	fwrite(fsgml, str, len(str))

	str := '<refsynopsisdiv><title>Synopsis</title>&\n<synopsis>&\n'
	fwrite(fsgml, str, len(str))
	if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:SYNTAX)
		str := '<![CDATA['+fs[lang]:SYNTAX+']]>&\n'
	else
		str := '<![CDATA['+fs:SYNTAX+']]>&\n'
	endif
	fwrite(fsgml, str, len(str))

	str := '</synopsis>&\n</refsynopsisdiv>&\n'
	fwrite(fsgml, str, len(str))

	str := '<refsect1 id="descrClass'+fs:SGMLID+'"><title>Description </title>&\n'
	fwrite(fsgml, str, len(str))

	str := "<para> &\n"
	if !empty(fs:SUMMARY)
		if lang != "EN" .and. (lang $ fs)  .and. !empty(fs[lang]:SUMMARY)
			a := split_str(fs[lang]:SUMMARY, "&\n")
		else
			a := split_str(fs:SUMMARY, "&\n")
		endif
		for i:=1 to len(a)
			if empty(a[i])
				str += "&\n</para>&\n<para>&\n"
			endif
			str += a[i]
		next
	endif
	str += "&\n</para>&\n</refsect1>"
	fwrite(fsgml, str, len(str))


	str := '<refsect1>&\n<title>Attributes</title>&\n'
	if empty(fs:ATTRIBS)
		str += '<para>No attributes</para>&\n'
	else
		str += '<informaltable frame="none"><tgroup cols="2"><tbody>&\n'
		if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:ATTRIBS)
			for i=1 to len(fs[lang]:ATTRIBS)
				a := split_str(fs[lang]:ATTRIBS[i][2], "&\n")

				str += '<row><entry align="right"><command><![CDATA['+fs[lang]:ATTRIBS[i][1]+']]></command></entry>'
				str += '&\n'
				for j=1 to len(a)
					if j>1
						str += '<row><entry align="right"> </entry>'
					endif
					str += '<entry>'+a[j]+'</entry></row>&\n'
				next
			next
		else
			for i=1 to len(fs:ATTRIBS)
				a := split_str(fs:ATTRIBS[i][2], "&\n")
				str += '<row><entry align="right"><command><![CDATA['+fs:ATTRIBS[i][1]+']]></command></entry>'
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
	str += '</refsect1>'
	fwrite(fsgml, str, len(str))


	str := '<refsect1><title>Methods</title>&\n'
	fwrite(fsgml, str, len(str))
	if empty(fs:METHODS)
		str := '<para>No methods</para>&\n'
	else
			str := '<informaltable frame="none"><tgroup cols="2"><tbody>&\n'
			fwrite(fsgml, str, len(str))
			for i=1 to ab_met:len()
				a := ab_met:getKey(i)
				j := ab_met:getData(i)
				str := '<row><entry><link linkend="class-'+alltrim(fs:CLASSNAME)+'-'+a+'">'+a+'</link></entry>&\n'
				val := trans(fs:METHODS[j]:SUMMARY)
				if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:METHODS[j]:SUMMARY)
					val := trans(fs[lang]:METHODS[j]:SUMMARY)
				endif
				str += '<entry>'+val+'</entry></row>&\n'
				fwrite(fsgml, str, len(str))
			next
			str := '</tbody></tgroup></informaltable>&\n'
			fwrite(fsgml, str, len(str))
			str := ""
	endif
	fwrite(fsgml, str, len(str))

	if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:EXAMPLES)
		j := trans(fs[lang]:EXAMPLES, .f.)
	else
		j := trans(fs:EXAMPLES, .f.)
	endif

	writeMethodDesc(fsgml, fs, lang, ab_met, alltrim(fs:CLASSNAME))

	str := '&\n</refsect1>&\n'
	fwrite(fsgml, str, len(str))

	if !empty(j)
		str := '<refsect1><title>Example:</title>&\n'
		str += '<informalexample>&\n'
		str += '<programlisting><![CDATA[&\n'
		str += j
		str += ']]></programlisting>&\n'
		str += '</informalexample><!-- EXAMPLE for '+fs:CLASSNAME+' -->&\n'
		fwrite(fsgml, str, len(str))
		str := '</refsect1>&\n'
		fwrite(fsgml, str, len(str))
	endif

	if !empty(fs:SEEALSO)
		str := '<refsect1><title>See also</title>&\n'
		str += '<para>&\n'
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
			str += '<link linkend="'+iif(lf,'function', 'class')+i+'">'+a[j]+'</link> '
		next
		str += '&\n</para>&\n</refsect1>'
		fwrite(fsgml, str, len(str))
	endif

	arr := {}
	a:= ""
	str := ""
	do while search("[a-zA-Z0-9\.\_]*@[a-zA-Z0-9\.\_]*", a, arr, 1)
		str += substr(a, 1, arr[1][1]-1)
		str += '<email>'
		str += substr(a, arr[1][1], arr[1][2]-arr[1][1])
		str += '</email>'
		a := substr(a, arr[1][2])
		arr := {}
	enddo
	if !empty(a)
		str += '<para><command>Author of documentation</command></para>&\n'
		str += '<para>&\n'
		str += a
		str += '&\n</para>&\n'
	endif

	if lang != "EN" .and. (lang $ fs)  .and. !empty(fs[lang]:PLATFORMS)
		a := trans(fs[lang]:PLATFORMS)
	else
		a := trans(fs:PLATFORMS)
	endif
	if !empty(a)

		str += '<para><command>Platforms</command></para>&\n<para>&\n'+a
		str += '&\n</para>&\n'
	endif

	if !empty(str)
		str := '<refsect1><title> </title>&\n' + str + '</refsect1>&\n'
		fwrite(fsgml, str, len(str))
	endif

	str := '</refentry><!-- End function '+fs:CLASSNAME+' -->&\n'
	fwrite(fsgml, str, len(str))


	qqout("..... done")
	fs := NIL
return

*******************************************************************************
static function writeMethodDesc(fsgml, fsc, lang, ab_met, clname)
local i, j, key, val, str, a, x, ii, fs, fsl
	fs := fsc:METHODS
	if lang != "EN"
		fsl:= fsc[lang]:METHODS
	endif

	for ii=1 to ab_met:len()
		key := ab_met:getKey(ii)
		x := ab_met:getData(ii)
		str := '<refsect2>&\n<title><anchor id="class-'+clname+'-'+key+'">Method '+clname+':'+key+'()</title>&\n'
		fwrite(fsgml, str, len(str))

		str := '<programlisting><![CDATA['+fs[x]:SYNTAX+']]></programlisting>&\n'
		if lang != "EN" .and. !empty(fsl[x]:SYNTAX)
			str := '<programlisting><![CDATA['+fsl[x]:SYNTAX+']]></programlisting>&\n'
		endif
		fwrite(fsgml, str, len(str))

		a := NIL
		str := '<para>&\n'
		a := split_str(fs[x]:DESCRIPTION, "&\n")
		if lang != "EN" .and. !empty(fsl[x]:DESCRIPTION)
			a := split_str(fsl[x]:DESCRIPTION, "&\n")
		endif
		if empty(a)
			a := split_str(fs[x]:SUMMARY, "&\n")
			if empty(a) .and. lang != "EN" .and. !empty(fsl[x]:SUMMARY)
				a := split_str(fsl[x]:SUMMARY)
			endif
		endif
		for j=1 to len(a)
			if empty(a[j])
				str += '&\n</para>&\n<para>&\n'
			else
				str += a[j]
			endif
		next
		str += '&\n</para>&\n'
		fwrite(fsgml, str, len(str))

		str := '<informaltable pgwide="1" frame="none" role="params"><tgroup cols="2">&\n<colspec colwidth="2*">&\n<colspec colwidth="8*">&\n<tbody>&\n'
		if lang != "EN" .and. !empty(fsl[x]:ARGS)
			for i=1 to len(fsl[x]:ARGS)
				if empty(fsl[x]:ARGS[i][2])
					loop
				endif

				str += '<row><entry align="right" valign="top"><parameter><![CDATA['+fsl[x]:ARGS[i][1]+']]></parameter></entry>&\n'

				str += '<entry><para>'+trans(fsl[x]:ARGS[i][2])+'</para></entry></row>&\n'
			next
		else
			for i=1 to len(fs[x]:ARGS)
				if empty(fs[x]:ARGS[i][2])
					loop
				endif
				str += '<row><entry align="right" valign="top"><parameter><![CDATA['+fs[x]:ARGS[i][1]+']]></parameter></entry>&\n'
				str += '<entry><para>'+trans(fs[x]:ARGS[i][2])+'</para></entry></row>&\n'
			next
		endif
		fwrite(fsgml, str, len(str))

		str := '<row><entry align="right" valign="top"><emphasis>Returns :</emphasis></entry>&\n'
		if lang != "EN" .and.  !empty(fsl[x]:RETURNS)
			str += '<entry><para>'+trans(fsl[x]:RETURNS)+'</para></entry></row>&\n'
		else
			if !empty(fs[x]:RETURNS)
				str += '<entry><para>'+trans(fs[x]:RETURNS)+'</para></entry></row>&\n'
			else
				str += '<entry>NIL</entry></row>&\n'
			endif

		endif
		fwrite(fsgml, str, len(str))

		str := '</tbody></tgroup></informaltable>&\n'

		fwrite(fsgml, str, len(str))


		str := '</refsect2><!-- end method '+key+'() -->&\n'
		fwrite(fsgml, str, len(str))
	next

return

*******************************************************************************
static function WriteClassOrder(outfile, lang, fs, ab_order, categ)
local str, j, fsgml

fsgml := fcreate(outfile)
str := '<part id="classes"><title>CLIP Classes</title>&\n'
fwrite(fsgml, str, len(str))

for j := 1 to ab_order:len()
	str := "&class"+alltrim(tostring(j))+";&\n"
	fwrite(fsgml, str, len(str))
next


str := '</part>&\n'
fwrite(fsgml, str, len(str))
fclose(fsgml)
return

*******************************************************************************
static function writeMethods(fname, lang, fs, ab_order, ab_met)
local x, i, key, val, fsec, fn
	x := 1
	for i=1 to ab_order:len()
		fn := fname+"class"+alltrim(toString(x))+".sgml"
		x++
		fsec := fcreate(fn)
		key := ab_order:getKey(i)
		val := ab_order:getData(i)

		writeClassDesc(fn, fsec, fs[val], lang, ab_met[val])

		fclose(fsec)
	next
return

*******************************************************************************
static function addToOrder(fs, x, ab_order, fname)
local i, a, s
	fs[x]:CLASSNAME := strtran(upper(fs[x]:CLASSNAME), '*', '')
	fs[x]:SGMLID := alltrim(strtran(fs[x]:CLASSNAME, "_", ""))
	if empty(fs[x]:CLASSNAME)
		qout("!!! File "+fname+" have empty CLASSNAME")
		adel(fs, x)
		x--
		asize(fs, x)
		return 0
	endif
	ab_order:Add(fs[x]:SGMLID, x)
return 1


*******************************************************************************
static function addMetToClass(fs, x, ab_met, fname)
local i, a, s
	fs[x]:METHODNAME := strtran(upper(fs[x]:METHODNAME), '*', '')
	fs[x]:SGMLID := alltrim(strtran(strtran(strtran(fs[x]:METHODNAME, "(", ""), ")", ""), "_", ""))
	fs[x]:SGMLID := strtran(strtran(fs[x]:SGMLID, "/", ""), " ", "")
	if empty(fs[x]:METHODNAME)
		qout("!!! File "+fname+" have empty METHODNAME")
		adel(fs, x)
		x--
		asize(fs, x)
		return 0
	endif
	ab_met:Add(fs[x]:SGMLID, x)
return 1


*******************************************************************************
static function parseArguments(fsrc, fsx, alang, nMet)
local str, s, lang:="EN", argname, argdesc:="", x, fs, lCls
	lCls := iif(nMet == NIL, .t., .f.)
	do while !fileeof(fsrc)
		str := alltrim(filegetstr(fsrc))
		s := upper(str)
		if lang == "EN"
			if lCls
				fs := fsx
			else
				fs := fsx:METHODS[nMet]
			endif
		else
			if lCls
				fs := fsx[lang]
			else
				fs := fsx[lang]:METHODS[nMet]
			endif
		endif
		if left(s, 6) == "$LANG_"
			if !empty(argname)
				writeArgs(fs, argname, argdesc, lCls)
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
				writeArgs(fs, argname, argdesc,  lCls)
			endif
			exit
		endif

		if left(str, 1) == "<"
			if !empty(argname)
				writeArgs(fs, argname, argdesc, lCls)
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
static function writeArgs(fs, argname, argdesc, lCls)
	if lCls
		aadd(fs:ATTRIBS, {argname, argdesc})
	else
		aadd(fs:ARGS, {argname, argdesc})
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

