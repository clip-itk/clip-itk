/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "error.ch"

function errorNew()
	local obj:=map()

        obj:args:={}
        obj:canDefault:=.f.
        obj:canRetry:=.f.
        obj:canSubstitute:=.f.
        obj:cargo:=NIL
        obj:description:="errornew"
        obj:filename:=NIL
        obj:genCode:=0
        obj:operation:=""
        obj:osCode:=NIL
        obj:severity:=ES_ERROR
        obj:subCode:=0
        obj:Subsystem:=""
        obj:tries:=0
        obj:syserr:=""

return obj
