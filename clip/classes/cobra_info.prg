/*
	COBrA is CLIP Object Broker & Application Server.
	cobraInfo - class for information about client settings
	cobraQuery - class for description query
	cobraAnswer - class for description answer
*/
/*   Copyright (C) 2003  ITK
     Author  : Uri (uri@itk.ru)
     Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/

#include "cobra.ch"

static query_counter := 1

/*******************************************/
function cobraInfoNew()
	local lang,ch,obj:=map()
	obj:classname	:= "COBRAINFO"
	obj:version	:= COBRA_VERSION
	obj:user	:= getenv("USER")
	obj:passwd	:= ""
	obj:lang	:= "en_EN"
	obj:langs	:= {"en_EN"}
	obj:charset	:= "CP437"
	obj:charsets	:= {"CP437"}
	obj:crypto	:= COBRA_CRYPTO
	obj:crypts	:= {COBRA_CRYPTO}
	obj:auth	:= COBRA_AUTH_SCRIPT

	obj:fromIni	:=@ ci_fromIni()

	/* lang environment detecting*/
	lang := getenv("CLIP_LANG")
	if empty(lang)
		lang := getenv("LANG")
	endif
	if !empty(lang)
		ch := atr(".",lang)
		if ch > 0
			obj:charset := substr(lang,ch+1)
			obj:lang := left(lang,ch-1)
			aadd(obj:charsets,obj:charset)
		else
			obj:lang := lang
		endif
		aadd(obj:langs,obj:lang)
	endif

return obj
/*******************************************/
static function ci_fromIni(oIni)
	local s
	if valtype(oIni) != "O"
		return
	endif
	if !(oIni:className == "INIFILE")
		return
	endif

	s := oIni:getValue("INFO","LANGS")
	if !empty(s)
		if valtype(s)=="A"
			::langs := s
		elseif valtype(s)=="C"
			::langs := {}
			aadd(::langs,s)
		endif
	endif
	s := oIni:getValue("INFO","CHARSETS")
	if !empty(s)
		if valtype(s)=="A"
			::charsets := s
		elseif valtype(s)=="C"
			::charsets := {}
			aadd(::charsets,s)
		endif
	endif
	s := oIni:getValue("INFO","CRYPTS")
	if !empty(s)
		if valtype(s)=="A"
			::crypts := s
		elseif valtype(s)=="C"
			::crypts := {}
			aadd(::crypts,s)
		endif
	endif
return

/*******************************************/
function cobraQueryNew()
	local obj:=map()
	obj:classname	:= "COBRAQUERY"
	obj:id		:= (query_counter++)
	obj:command	:= ""
	obj:args	:= {}
	obj:answer	:= NIL
	obj:return	:= NIL
return obj
/*******************************************/
function cobraAnswerNew()
	local obj:=map()
	obj:classname	:= "COBRAANSWER"
	obj:id		:= 0
	obj:errno	:= ""
	obj:error	:= ""
	obj:warning	:= ""
	obj:return	:= NIL
return obj

