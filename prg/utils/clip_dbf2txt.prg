/*
    Copyright (C) 2001  ITK
    Autor   : Uri (uri@itk.ru)
    Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/
#include "set.ch"
#include "inkey.ch"

local i,aStru,nField, nFields, tFile,hFile, tHeader,hHeader,str, sRec
parameters dbFile,delim
	if empty(dbFile)
        	? "Converter DBF to text file with ',' delimiter "
        	? "Usage: clip_dbf2txt <filename>[.dbf] [delimiter]"
                ?
                return
        endif
        if empty(delim)
        	delim:=','
        endif

	set translate off
        set date format to "YYYYMMDD"
        i := atr(".dbf", dbFile)
        if i>0
        	tFile   := substr(dbFile,1,i-1)+".txt"
        	tHeader := substr(dbFile,1,i-1)+".hdr"
        else
        	tFile   := dbFile+".txt"
        	tHeader := dbFile+".hdr"
        	dbFile += ".dbf"
        endif
        ? "Converting "+dbfile+" to "+tFile
        if !file(dbfile)
        	? "Error: file not found:",dbFile
                ?
                return
        endif
        hFile := fcreate( tFile )
        if hFile < 0
        	? "Error creating file:",tFile,ferrorstr()
                ?
                return 1
        endif
        hHeader := fcreate( tHeader )
        if hHeader < 0
        	? "Error creating header file:",tHeader,ferrorstr()
                ?
                return 2
        endif
        use (dbfile)
        aStru := dbStruct()
        for i=1 to len(aStru)
        	str := ""
                str += alltrim(aStru[i][1])+","
                str += alltrim(aStru[i][2])+","
                str += alltrim(str(aStru[i][3]))+","
                str += alltrim(str(aStru[i][4]))
                if len(aStru[i]) > 4
                	str += ","
                	str += iif(aStru[i][5],"Y","N")+","
                	str += iif(aStru[i][6],"Y","N")
                endif
                str += "&\r&\n"
                fWrite(hHeader,str)
        next
        fClose(hHeader)
        goto top
        i := 0
        nFields := fcount()
        ? "Record N:"
        do while !eof()
        	if recno() % 100 ==0
        		srec := str(recno(),6,0)
                	?? srec
                endif
        	str:=""
            	for nField = 1 to nFields
                	if aStru[nField][2] == "L"
                	str += iif(fieldGet(nField),"T","F")+delim
                        else
                	str += alltrim(toString(fieldGet(nField)))+delim
                        endif
            	next
                str := left(str,len(str)-1)+"&\r&\n"
                fwrite(hFile,str)
                i++
        	if recno() % 100 ==0
                	?? replicate(chr(K_BS),6)
                endif
        	skip
        enddo
        fclose(hFile)
	? "Converted "+alltrim(str(i))+" records"
	? "OK"
        ?
return 0
