/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
***************************************************
function compileFile(Fname,flags,error)
	local cmd,out:=space(0), err:=space(0), path
        flags:=iif(flags==NIL,"-p",flags)
        path:=getenv("CLIPROOT")
        if empty(path)
        	path:=CLIPROOT()
        endif
        cmd:=path+PATH_DELIM+"bin"+PATH_DELIM+"clip "+flags+" "+fname
        if syscmd(cmd,"",@out,@err)!=0
        	error:=out+err
                return .f.
        endif
        if !empty(err)
        	error:=err
                return .f.
        endif
        error:=""
return .t.
***************************************************
function compileString(str,error)
	local block:={|| NIL }, file:=tmpfile(),err
        err:=atr("/",file)
        err:=iif(err<=0,0,err)
        file:=substr(file,err+1)
        memowrit(file+".prg",str)
        compileFile(file+".prg","-p",@err)
        ferase(file+".prg")
        if !empty(err)
        	error:=err
        else
        	block:=loadBlock(file+".po")
        endif
        ferase(file+".po")
return block

