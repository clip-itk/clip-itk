/*                                                                            */
/*    Copyright (C) 2003  ITK                                                 */
/*    Author   : Alena Kornilova(alena@itk.ru)                                */
/*    Licence : (GPL) http://www.itk.ru/clipper/licence.html                  */
/*                                                                            */
/*	Convertor text classes descriptions to sgml format.                   */
/*                                                                            */

#define __FAST__LINK	1

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
qout("&\n Summary classes:"+toString(len(fs)))

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
			elseif s== "&"
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
static function writeClassDesc(fname, fsgml, fs, lang, ab_met)
local i, j, a, str, lStr, arr, lf

	qout( "Write to: "+fname+" function:"+fs:CLASSNAME)

	str := '<section id="class'+fs:SGMLID+'"><title>Class '+fs:CLASSNAME+' </title>&\n'
	fwrite(fsgml, str, len(str))

	str := '<section id="aboutClass'+fs:SGMLID+'"><title>About </title>&\n'
	fwrite(fsgml, str, len(str))
	str := '<para>&\n'
	if !empty(fs:ABOUT)
		if lang != "EN" .and. (lang $ fs)  .and. !empty(fs[lang]:ABOUT)
			a := split_str(fs[lang]:ABOUT, "&\n")
		else
			a := split_str(fs:ABOUT, "&\n")
		endif
		for j=1 to len(a)
			if empty(a[j])
				str += '</para><para>&\n'
			else
				str += a[j]
			endif
		next
	endif
	str += '&\n</para>&\n'
	fwrite(fsgml, str, len(str))

	str := '</section>&\n'
	fwrite(fsgml, str, len(str))


	str := '<section id="descrClass'+fs:SGMLID+'"><title>Description </title>&\n'
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

	str := '<section><title>Attributes</title>&\n'
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
	str += '</section><!-- ATTRS for '+fs:CLASSNAME+' -->&\n'
	fwrite(fsgml, str, len(str))


	str := '<section><title>Methods</title>&\n'
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
	str += '</section><!-- METHODS for '+fs:CLASSNAME+' -->&\n'
	fwrite(fsgml, str, len(str))


	str := '<section><title>Example</title>&\n'
	str += '<programlisting><![CDATA[&\n'
	if lang != "EN" .and. (lang $ fs) .and. !empty(fs[lang]:EXAMPLES)
		str += trans(fs[lang]:EXAMPLES, .f.)
	else
		str += trans(fs:EXAMPLES, .f.)
	endif
	str += ']]></programlisting>&\n'
	str += '</section><!-- EXAMPLE for '+fs:CLASSNAME+' -->&\n'
	fwrite(fsgml, str, len(str))



	str := '<section><title>See also</title>&\n'
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
	str += '&\n</para>&\n'
	str += '</section><!-- SEEALSO for '+fs:CLASSNAME+' -->&\n'
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
	str += '</section><!-- AUTHOR for '+fs:CLASSNAME+' -->&\n'
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
	str += '</section><!-- PLATFORMS for '+fs:CLASSNAME+' -->&\n'
	fwrite(fsgml, str, len(str))

	writeMethodDesc(fsgml, fs, lang, ab_met, alltrim(fs:CLASSNAME))

	str := '</section>&\n'
	fwrite(fsgml, str, len(str))

	str := '</section><!-- End function '+fs:CLASSNAME+' -->&\n'
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
		str := '<section id="class-'+clname+'-'+key+'"><title>Method '+clname+':'+key+'()</title>'
		fwrite(fsgml, str, len(str))

		val := trans(fs[x]:SUMMARY)
		if lang != "EN" .and. !empty(fsl[x]:SUMMARY)
			val := trans(fsl[x]:SUMMARY)
		endif

		str := '<para><command>'+val+'</command></para>&\n'
		fwrite(fsgml, str, len(str))

		str := '<programlisting><![CDATA['+fs[x]:SYNTAX+']]></programlisting>&\n'
		if lang != "EN" .and. !empty(fsl[x]:SYNTAX)
			str := '<programlisting><![CDATA['+fsl[x]:SYNTAX+']]></programlisting>&\n'
		endif
		fwrite(fsgml, str, len(str))

		str := '<section><title>Arguments</title>&\n'
		if empty(fs[x]:ARGS)
			str += '<para>No arguments</para>&\n'
		else
			str += '<informaltable frame="none"><tgroup cols="2"><tbody>&\n'
			if lang != "EN" .and. !empty(fsl[x]:ARGS)
				for i=1 to len(fsl[x]:ARGS)
					a := split_str(fsl[x]:ARGS[i][2], "&\n")

					str += '<row><entry align="right"><command><![CDATA['+fsl[x]:ARGS[i][1]+']]></command></entry>'
					str += '&\n'

					for j=1 to len(a)
						if j>1
							str += '<row><entry align="right"> </entry>'
						endif
						str += '<entry>'+a[j]+'</entry></row>&\n'
					next
//					str += '&\n</para></listitem></varlistentry>&\n'
				next
			else
				for i=1 to len(fs[x]:ARGS)
					a := split_str(fs[x]:ARGS[i][2], "&\n")
					str += '<row><entry align="right"><command><![CDATA['+fs[x]:ARGS[i][1]+']]></command></entry>'
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
		str += '</section><!-- ARGS for '+fs[x]:METHODNAME+' -->&\n'
		fwrite(fsgml, str, len(str))

		str := '<section><title>Returns</title>&\n'
		if empty(fs[x]:RETURNS)
			str += '<para>Returns NIL.</para>&\n'
		else
			str += '<para>&\n'
			a := split_str(fs[x]:RETURNS, "&\n")
			if lang != "EN" .and. !empty(fsl[x]:RETURNS)
				a := split_str(fsl[x]:RETURNS, "&\n")
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
		str += '</section><!-- RETURNS for '+fs[x]:METHODNAME+' -->&\n'
		fwrite(fsgml, str, len(str))

		str := '<section><title>Description</title>&\n'
		str += '<para>&\n'
		a := split_str(fs[x]:DESCRIPTION, "&\n")
		if lang != "EN" .and. !empty(fsl[x]:DESCRIPTION)
			a := split_str(fsl[x]:DESCRIPTION, "&\n")
		endif
		for j=1 to len(a)
			if empty(a[j])
				str += '</para><para>&\n'
			else
				str += a[j]
			endif
		next
		str += '&\n</para>&\n'
		str += '</section><!-- DESCRIPTION for '+fs[x]:METHODNAME+' -->&\n'
		fwrite(fsgml, str, len(str))

		str := '</section><!-- end method '+key+'() -->&\n'
		fwrite(fsgml, str, len(str))
	next

return

*******************************************************************************
static function WriteClassOrder(outfile, lang, fs, ab_order, categ)
local str, j, fsgml

fsgml := fcreate(outfile)
str := '<chapter id="classes"><title>CLIP Classes</title>&\n'
fwrite(fsgml, str, len(str))

for j := 1 to ab_order:len()
	str := "&class"+alltrim(tostring(j))+";&\n"
	fwrite(fsgml, str, len(str))
next


str := '</chapter>&\n'
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
local str, s, lang:="EN", argname, argdesc:="", x, fs
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

