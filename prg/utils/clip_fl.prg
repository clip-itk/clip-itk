/*
    Copyright (C) 2002  ITK
    Autor   : Uri (uri@itk.ru)
    Licence : (GPL) http://www.itk.ru/clipper/licence.html
*/

/*
	calculate function list in directory
*/

#include "fileio.ch"

local _path:=param(1),mf:={},ms:={0,0},i
if empty(_path) //.or. ("-" $ _file)
	?  "This is calculator exporting functions list in C & PRG files"
	?  "usage: clip_fl <path> "
        ?
        return
endif

run_recursive(_path,mf,ms)

asort(mf,,,{|x,y| padr(upper(x[1]),5) < padr(upper(y[1]),5)})

for i=1 to len(mf)
	if "test" $ mf[i][2]
        else
		? padr(mf[i][1],30), mf[i][2]
        endif
next
? replicate("-",70)
? "total files:",ms[2],"total lines:",ms[1]
?
return

static function run_recursive(_path,mf,ms)
	local m,mp:={},md:={},i
	m:=directory(_path+PATH_DELIM+"*","D")
	for i=1 to len(m)
        	if left(m[i][1],1)=="."
                	loop
                endif
        	if glob(m[i][1],"*.prg") >=0
			aadd(mp,m[i][1])
                endif
        	if glob(m[i][1],"*.c") >= 0
			aadd(mp,m[i][1])
                endif
        	if m[i][5]=="D"
			aadd(md,m[i][1])
                endif
	next
        for i=1 to len(md)
        	run_recursive(_path+PATH_DELIM+md[i],mf,ms)
        next
        for i=1 to len(mp)
        	if glob(mp[i],"*.prg") >=0
        		run_calc_prg(_path+PATH_DELIM+mp[i],mf,ms)
                else
        		run_calc_c(_path+PATH_DELIM+mp[i],mf,ms)
                endif
        next
return

static function run_calc_prg(_file,mf,ms)
	local fh,buf,i
	fh := fopen(_file,FO_READ)
        if fh<0
        	outlog(1,"Can`t open file:",_file)
        	return
        endif
        while !fileeof(fh)
               buf:=alltrim(filegetstr(fh))
               if "=" $ buf
               		loop
               endif
               i := at("func", lower(buf) )
               if i == 1
               		buf := substr(buf,i+1)
                        i := at(" ", buf)
                        if i > 0
                        	buf := substr(buf,i+1)
               			i := at("(",buf)
                                if i<=0
               				i := at(" ",buf)
                                endif
                                if i<=0
                                	i := len (buf)+1
                                endif
                                buf := alltrim(substr(buf,1,i-1))
                        endif
                        aadd(mf,{buf,_file})
               endif
               ms[1]++
        enddo
        ms[2]++
        fclose(fh)
return

static function run_calc_c(_file,mf,ms)
	local fh,buf,i
	fh := fopen(_file,FO_READ)
        if fh<0
        	outlog(1,"Can`t open file:",_file)
        	return
        endif
        while !fileeof(fh)
               buf:=alltrim(filegetstr(fh))
               if "=" $ buf
               		loop
               endif
               i := at("clip_", lower(buf) )
               if i > 0 .and. at("clipmachine", lower(buf) ) > 0
               		buf := substr(buf,i+5)
               		i := at("(",buf)
                        if i<=0
                        	i := len (buf)+1
                        endif
                        buf := alltrim(substr(buf,1,i-1))
                        if asc(left(buf,1)) < 97 // upper case
                        	aadd(mf,{buf,_file})
                        endif
               endif
               ms[1]++
        enddo
        ms[2]++
        fclose(fh)
return

