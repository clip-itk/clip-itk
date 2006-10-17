/*
    Copyright (C) 2005-2006  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
********************************
/**********************************************/
static function __ocmng_init_simbols()
	local test :=map()
	local x,y

	ocMngSetMessager(@__ocMngDefMessager())
	/* it`s only for readable hash strings */
	test["?XML"] 	:= ""
	test:classname	:= ""
	test:cVersion	:= ""
	test:error 	:= ""
	test:encoding 	:= ""
	test:VERSION 	:= ""
	test:DESCRIPTION:= ""
	test:LICENSE 	:= ""
	test:CREATED 	:= ""
	test:MODIFIED 	:= ""
	test:AUTHOR 	:= ""
	test:REQUIRES 	:= ""
	test:COMMANDS 	:= ""
	test:LOCALE	:= ""
	test:INSTALL 	:= ""
	test:UNINSTALL 	:= ""
	test:DICTIONARY	:= ""
	test:RULES	:= ""
	test:DEPOSITORY	:= ""
	test:EXTENT	:= ""
	test:INDEX	:= ""
	test:CLASS	:= ""
	test:COUNT	:= ""
	test:CODE	:= ""
	test:PLUGIN	:= ""
	test:TCOLUMN 	:= ""
	test:TVIEW	:= ""
	/* it`s only for readable hash strings */
	test:CATEGORY 	:= ""
	test:OBJECTS 	:= ""
	test:VALUE 	:= ""
	test:ID 	:= ""
	test:path 	:= ""
	test:dbuser 	:= ""
	test:name 	:= ""
	test:type 	:= ""
	test:form 	:= ""
	test:cdata 	:= ""
	test:memosize 	:= ""
	test:Property	:= ""
	test:Dependence := ""
	test:Attribute 	:= ""
	test:lenType   	:= ""
	test:len	:= ""
	test:dec	:= ""
	test:mask	:= ""
	test:defValue	:= ""
	test:notNull	:= ""
	test:notEmpty	:= ""
	test:counter	:= ""
	test:refto	:= ""
	test:expression := ""
	test:expr	:= ""
	test:superClass	:= ""
	test:essence	:= ""
	test:uniqueKey	:= ""
	test:mainIdx	:= ""
	test:attributes := ""
	test:indices	:= ""
	test:findAttrs	:= ""
	test:tcolList	:= ""
	test:logNeed	:= ""
	test:header	:= ""
	test:footer	:= ""
	test:width	:= ""
	test:columns	:= ""
	test:function	:= ""
	test:file	:= ""
	test:sourcefile	:= ""
	test:object	:= ""
	test:objects	:= ""
	test:attr	:= ""
	test:meta	:= ""

return
****************************
static function __ocMngDefMessager(cMess,nLevel)
	nLevel := iif(valtype(nLevel)=="N" ,nLevel, 0)
	? "ocMng["+str(nLevel,2,0)+"]>",cMess
return
