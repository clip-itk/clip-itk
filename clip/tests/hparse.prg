	local oHtml,hFile
	local i, oTag
	oHtml := htmlParserNew()
	hFile := fopen("hparse.xml")
	do while !fileeof(hFile)
		oHtml:put(freadstr(hFile,20))
	enddo
	fclose(hFile)
	oHtml:end()

	do while !oHtml:empty()
		oTag := oHtml:get()
		if valtype(oTag)=="O" .and. oTag:classname=="HTML_TAG"
		else
			? oTag
			loop
		endif
		if oTag:tagname=="!"
			? oTag
			loop
		endif
		? oTag:tagname
		?
		for i in oTag:fields KEYS
			attrName := oTag:hashname(i)
			attrData := oTag:fields[i]
			?? "",attrname+"="+attrdata
		next
	enddo
	?
return

