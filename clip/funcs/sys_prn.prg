/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html

    functions for printing
*/

#include "set.ch"
#include "inkey.ch"
#include "fileio.ch"

static print_desc
static print_queue

*************************************
/* class Printer */
function printerNew(sName,sType,sDescription,sCharset,sScript,xBlock)
	local obj := map(), tmpErr, _err
        obj:classname := "PRINTER"
        obj:name      := upper(sName)
        obj:type      := iif( valtype(sType) !="C", "epson", sType)
        obj:description := sDescription
        obj:charset   := iif(sCharset==NIL, host_charset(), sCharset)
        obj:script    := sScript
        obj:block     := NIL
	if valtype(xBlock) == "B"
        	obj:block     := xBlock
        elseif valType(xBlock) == "C"
               if "{" $ xBlock .and. "|" $ xBlock
               else
               		xBlock := "{|fname|"+xBlock+"}"
               endif
               tmpErr:=errorBlock({|err|break(err)})
               begin sequence
               		xBlock:=&xBlock
               recover using _err
               end sequence
               errorBlock(tmpErr)
               if !empty(_err)
               		outlog(3,"Error compile:",xBlock,_err)
               else
               		obj:block := xBlock
               endif
        endif
return obj

****************************************
/* class Print Queue */
function printQueueNew(sPrinter,nCopies,sPaperSize,sOrientation,nBpage,nEpage)
	local obj := map()
        obj:classname := "PRINTQUEUE"
        obj:name      := upper(sPrinter)
        obj:copies    := iif(valtype(nCopies)=="N",nCopies,1)
        obj:psize     := iif(sPaperSize==NIL,"A4",upper(sPaperSize))
        obj:sOrientation := iif(sOrientation == NIL, "PARTRAIT",upper(sOrientation))
        obj:begPage   := iif(valtype(nBpage) != "N", 1, nBpage)
        obj:endPage   := iif(valtype(nEpage) != "N", 9999, nEpage)
return obj

**********************************************
* load CLIPROOT/etc/printers.ini and return data
**********************************************
function loadPrinters()
	local oIni,ret:=map()
	local f,p,mIni,i,cliproot:=getenv("CLIPROOT")

  	if empty(cliproot)
  		cliproot:=cliproot()
  	endif
	f:=cliproot+PATH_DELIM+"etc"+PATH_DELIM+"printers.ini"
        if !file(f)
        	outlog(3,"file not found:",f)
  		f:=PATH_DELIM+"home"+PATH_DELIM+getenv("USER")+PATH_DELIM+".clip"+PATH_DELIM+"printers.ini"
        	if !file(f)
        		outlog(3,"file not found:",f)
                        ret:queue := printQueueNew("view",1,"A4")
                        ret:printers := {}
                        *
                        p := printerNew("view",,[View printer output in text editor],;
                        	host_charset(),,"{|filename|medit(fileName)}" )
                        aadd(ret:printers,p)
                        *
                        p := printerNew("lpr",,[Printing to main printer on your host],;
                        	host_charset(),"lpr" )
                        aadd(ret:printers,p)
                        return ret
                endif
        endif
        ret:printers := {}
	oIni := iniFileNew(f)
        oIni:load()
        mIni := oIni:sections()
        for i=1 to len(mIni)
        	if mIni[i] == "DEFAULT"
                	ret:queue := ;
			printQueueNew( 	oIni:getValue(mIni[i],"name"),;
                        		oIni:getValue(mIni[i],"copies"),;
                                        oIni:getValue(mIni[i],"psize"),;
                                        oIni:getValue(mIni[i],"orientation"), ;
                                        oIni:getValue(mIni[i],"begpage"), ;
                                        oIni:getValue(mIni[i],"endpage") ;
			)
                	loop
                endif
                p := printerNew ( ;
                     oIni:getValue(mIni[i],"name"),;
                     oIni:getValue(mIni[i],"type"),;
                     oIni:getValue(mIni[i],"description"),;
                     oIni:getValue(mIni[i],"charset"),;
                     oIni:getValue(mIni[i],"script"),;
                     oIni:getValue(mIni[i],"block") ;
                )
                aadd(ret:printers, p)
        next
        for i=1 to len(ret:printers)
        	if ret:printers[i]:name == ret:queue:name
                	exit
                endif
        next
        /* move default printer to first position in list*/
        if i<=len(ret:printers)
        	p := ret:printers[i]
                adel(ret:printers,i)
                ains(ret:printers,1)
                ret:printers[1] := p
        endif
return ret
***********************************************
* choice printer
***********************************************
function printChoice(oQueue, aPrinters)
	local oldcol:=col(),oldrow:=row()
	local ret:=0, nT, nL, nB, nR
	local cp:=1,bl:=1,el:=9999,i,s,x1,x2,x3
	local nkey:=0,scr,oldcolor,getlist:={}
	save screen to scr
	oldcolor=setcolor("W/R")
	do while .t.
                nb:= maxrow()- 2
		nT:= nb - len(aprinters) - 6
		nL:= 15
		nR:= maxcol()-nl
		dbox(nT, nL-1, nB, nR,,, [choice printer], [Esc: Cancel] )
                nt++
                bl:=oQueue:begPage
                el:=oQueue:endPage
                cp:=oQueue:copies
                for i=1 to len(aPrinters)
			@ ++nT,nL+1 say str(i,3,0) color "W+/R"
			dispout(": "+padr(aPrinters[i]:description, nr-nl-6))
                next
		@ ++nT,nL+1 say replicate("-",nr-nl-2)
		@ ++nT,nL+1 say "Ins" color "W+/R"
                s:=[: Printing pages range: from XXXX to YYYY]
                x1:=col()+at("XXXX",s)-1
                x2:=col()+at("YYYY",s)-1
                s:=strtran(s,"XXXX",str(bl,4,0))
                s:=strtran(s,"YYYY",str(el,4,0))
                dispout(s)
		@ ++nT,nL+1 say "Del" color "W+/R"
                s:=[: Printing copies: XXXX ]
                x3:=col()+at("XXXX",s)-1
                s:=strtran(s,"XXXX",str(cp,4,0))
                dispout(s)
		nkey:=inkey(0)
	    	if setkey(nKey) != NIL
		    	eval(setkey(nKey),procname(),procline(),readvar())
        	    	loop
	    	endif
                if nKey==K_ENTER
                	nkey := asc("1")
                endif
		if nkey==K_INS
   			@ nT-1, x1 get bl picture "9999"
   			@ nT-1, x2 get el picture "9999"
   			read
                	oQueue:begPage := bl
                	oQueue:endPage := el
   			clearkey()
   			loop
		endif
		if nkey==K_DEL
   			@ nT, x3 get cp picture "9999"
   			read
                	oQueue:copies := cp
   			clearkey()
   			loop
		endif
		if nkey==K_ESC
   			exit
		endif
                if nKey >= asc("1") .and. nkey <= asc("9")
                	ret:= nKey - asc("0")
                        exit
                endif
	enddo
	keyboard chr(0)
	inkey(0.1)
	restore screen from scr
	setcolor(oldcolor)
	setpos(oldrow,oldcol)
return ret
**********************************************
* begin printing
**********************************************
function printBegin()
	local cp,pfile, oData, prn
        oData := loadPrinters()
        if print_queue != NIL
        	alert([Printbegin(): printing already in process])
                return .f.
        endif
        prn:=printChoice(oData:queue, oData:printers)
        if prn <= 0
        	return .f.
        endif
	pfile:=tmpfile()+".txt"
	ferase(pfile)
        oData:queue:outfile := pFile
        oData:queue:pageCount := 1
        print_queue := oData:queue
        print_desc  := oData:printers[prn]
	set(_SET_CONSOLE,.f.)
	set(_SET_PRINTER,.t.)
        if print_queue:begPage<=1
		set(_SET_PRINTFILE,pfile)
        else
		set(_SET_PRINTFILE,"/dev/null")
        endif
	setprc(0,0)
return .t.
**********************************************
* Begin new page printing
**********************************************
function printEject()
	qout("\eject\")
	setprc(0,0)
        print_queue:pageCount++
        /* begin real printing */
        if print_queue:begPage == print_queue:pageCount
		set(_SET_PRINTFILE,print_queue:outfile)
        endif
        /* end real printing */
        if print_queue:endPage == print_queue:pageCount
		set(_SET_PRINTFILE,"/dev/null")
        endif
return
**********************************************
* end printing
**********************************************
function printEnd()
	local prnIni,vCodes, cliproot:=getenv("CLIPROOT")
        local newFile, nCopy
	local sysOut:=space(0), sysErr:=space(0)

  	if empty(cliproot)
  		cliproot:=cliproot()
  	endif
        if print_queue == NIL
        	alert([PrintEnd(): printing process not actived])
                return .f.
        endif

	qout("\RESET\")
	set(_SET_CONSOLE,.t.)
	set(_SET_PRINTER,.f.)
	set(_SET_PRINTFILE,"")

	if upper(print_desc:type) == "VIRTUAL"
        	vCodes:={}
        else
		prnIni:=iniFileNew(cliproot+PATH_DELIM+"print"+PATH_DELIM+lower(print_desc:type))
                prnIni:Load()
                vCodes := prnIni:keys("vcodes")
        endif
        newFile := print_queue:outfile+".1"

	if empty(vCodes) .and. lower(host_charset()) == lower(print_desc:charset)
        	newFile := print_queue:outfile
        else
		/* translate virtual codes to real printer codes */
        	/* and charsets too */
        	__translatePrintFile(print_queue:outfile, newFile, prnIni,print_desc:charset)
        endif

	for nCopy=1 to print_queue:copies
		if !empty(print_desc:block)
        		eval(print_desc:block,newFile)
        	endif
		if !empty(print_desc:script)
        		if syscmd(print_desc:script+" "+newFile,"",@sysOut,@sysErr)!=0
                        	outlog(3,"Printing error",sysOut,sysErr)
                        	exit
                        endif
                endif
        next

        fErase(print_queue:outfile)
        fErase(newFile)
	print_queue := NIL
        print_desc  := NIL
return  .t.

************************
static function __translatePrintFile(infile, outFile, oPrn, charset)
	local nFin, nFout,buf,i1,i2,s1,s2,vcode,rCode
        nFin := fopen(inFile,FO_READ)
        if nFin < 0
        	outlog(3,"Error open source printing file:",ferror(),ferrorstr())
                return .f.
        endif
        nFout := fcreate(outFile)
        if nFout < 0
        	outlog(3,"Error open target printing file:",ferror(),ferrorstr())
                fclose(nFin)
                return .f.
        endif
        while !fileeof(nFin)
               buf:=filegetstr(nFin)
               buf:=translate_charset(host_charset(),charset,buf)
               while .t.
               		i1 := at("\",buf)
                        if i1 <=0
                        	exit
                        endif
                        s1 := substr(buf,1,i1-1)
                        s2 := substr(buf,i1+1)
               		i2 := at("\",s2)
                        if i2 <=0
                        	exit
                        endif
                        vCode := substr(s2,1,i2-1)
                        s2:= substr(s2,i2+1)
         		rCode := oPrn:getValue("vcodes",vCode)
                        buf:=s1
                        for i1=1 to len(rCode)
                        	buf += chr(rCode[i1])
                        next
                        buf+=s2
               end
               fwrite(nFout,buf+CRLF)
	end
	fclose(nFin)
	fclose(nFout)
return
