/*
  All right reserved. (C) ITK,Izhevsk,Russia
  Author - Kornilova Elena
  E-mail - alena@itk.ru
  Home ftp - ftp.itk.ru/pub/clip
  Date  - 15/05/2000 year
  License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include <inkey.ch>
#include <config.ch>
#include <set.ch>
#include <box.ch>
#include <pgch.ch>

#define LIST_COLORS	"0/3,0/2,15/3,0/3,0/2,15/2,15/2"
#define DOP	replicate(" ", 256)
#define DRIVE_PATH	"/usr/home"
#define FA_NORMAL	0
#define FA_READONLY	1
#define FA_HIDDEN	2
#define FA_SYSTEM	4
#define FA_VOLUME	8
#define FA_DIRECTORY	16
#define FA_ARCHIVE	32
//#define FD_DELIM	translate_charset(__CHARSET__, host_charset(), "Å")
/*#define FD_DELIM 	chr(PGCH_VLINE)*/
#define FD_DELIM	iif(set(_SET_DISPBOX),translate_charset("cp437", host_charset(), CHR(179)),chr(PGCH_VLINE))


function DiskFileDialog(Driver, Curdrv, Curdir, pMask)
local i, gi, retvalue, scr, k, item, r, f, nkey:=1, gfocus, lbopen:=.f., c[2], s
local fdp:=map(), drv, old_dir:=curDir()

fdp:current := ""
k := int(3*maxcol()/4)
r := int(2*maxrow()/3)
fdp:nLeft := int((maxcol()-k)/2)
fdp:nRight := fdp:nLeft + k
fdp:nTop := int((maxrow()-r)/2)
fdp:nBottom := fdp:nTop+r

if empty(Driver)
	Driver := {}
	i_driver(@Driver)
endif
Curdrv := iif(Curdrv==NIL, 1, max(1, min(Curdrv, len(Driver))))

save screen to scr

set color to "0/7"
@ fdp:nTop-2, fdp:nLeft clear to fdp:nBottom+1, fdp:nRight+1
//@ fdp:nTop-3, fdp:nLeft-1, fdp:nBottom+2, fdp:nRight+1 box B_DOUBLE
@ fdp:nTop-3, fdp:nLeft-1 TO fdp:nBottom+2, fdp:nRight+1 DOUBLE

//set date format to "dd/mm/yyyy"

retvalue := ""
fdp:mask := iif(empty(pMask), "*", pMask)
if !empty(Curdir)
	dirchange(Curdir)
endif
fdp:length   := fdp:nRight-fdp:nLeft
gi := ""

fdp:getobj  := getnew(fdp:nTop-2, fdp:nLeft,{|_1| iif(_1==NIL, gi,gi:=_1)}, "gi", "@kS"+alltrim(str(fdp:length)), "w+/b")
fdp:lbobj   := _listbox_(fdp:nTop-3, fdp:nLeft-5, fdp:nBottom+2, fdp:nLeft-2, Driver[Curdrv], Driver,,, "15/7,0/2,0/7,0/7,0/7",,,.f., .t.)
fdp:listobj := listitemnew(fdp:nTop, fdp:nLeft, fdp:nBottom, fdp:nRight, 3, FD_DELIM, LIST_COLORS)

initItem(fdp)
fdp:lbobj:display()

showview(fdp)
fdp:getobj:setFocus()
fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
gfocus := 1

while nkey!=0
	nkey := Inkey(0)
	do case
		case nkey == K_LEFT
			do case
			case gfocus == 1
				fdp:getobj:left()
			case gfocus == 2
				fdp:listobj:left()
				showview(fdp)
			case gfocus == 3
				fdp:lbobj:killFocus()
				gfocus := 2
				fdp:listobj:setFocus()
			endcase
		case nkey == K_RIGHT
			do case
			case gfocus == 1
				fdp:getobj:right()
			case gfocus == 2
				fdp:listobj:right()
				showview(fdp)
			case gfocus == 3
				fdp:lbobj:killFocus()
				fdp:getobj:setFocus()
				gfocus := 1
			endcase
		case nkey == K_UP
			do case
			case gfocus == 1
				fdp:getobj:assign()
				fdp:getobj:killFocus()
				fdp:lbobj:setFocus()
				gfocus := 3
			case gfocus == 2
				fdp:listobj:up()
				showview(fdp)
			case gfocus == 3
				fdp:lbobj:prevItem()
			endcase
		case nkey == K_DOWN
			do case
			case gfocus == 1
				fdp:getobj:assign()
				fdp:getobj:killFocus()
				fdp:listobj:setFocus()
				gfocus := 2
			case gfocus == 2
				fdp:listobj:down()
				showview(fdp)
			case gfocus == 3
				fdp:lbobj:nextItem()
			endcase
		case nkey == K_HOME
			do case
			case gfocus == 1
				fdp:getobj:home()
			case gfocus == 2
				fdp:listobj:home()
				showview(fdp)
			case gfocus == 3
				fdp:lbobj:home()
			endcase
		case nkey == K_END
			do case
			case gfocus == 1
				fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
			case gfocus == 2
				fdp:listobj:end()
				showview(fdp)
			case gfocus == 3
				fdp:lbobj:end()
			endcase
		case nkey == K_PGUP
			do case
			case gfocus == 2
				fdp:listobj:pageup()
				showview(fdp)
			case gfocus == 3
				fdp:lbobj:pageup()
			endcase
		case nkey == K_PGDN
			do case
			case gfocus == 2
				fdp:listobj:pagedown()
				showview(fdp)
			case gfocus == 3
				fdp:lbobj:pagedown()
			endcase
		case nkey == K_INS
			if gfocus == 1
				fdp:getobj:Insert()
			endif
		case nkey == K_DEL
			if gfocus == 1
				fdp:getobj:delRight()
			endif
		case nkey == K_BS
			do case
			case gfocus == 1
				fdp:getobj:backSpace()
			endcase
		case nkey == K_TAB
			do case
			case gfocus == 3
				gfocus := 1
				fdp:lbobj:killFocus()
				fdp:getobj:setFocus()
				fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
			case gfocus == 1
				gfocus := 2
				fdp:getobj:assign()
				fdp:lbobj:killFocus()
				fdp:listobj:setFocus()
			case gfocus == 2
				gfocus := 3
				fdp:listobj:killFocus()
				fdp:lbobj:setFocus()
			endcase
		case nkey == K_ESC
			nkey := 0
		case nkey == K_ENTER
			do case
			case gfocus == 1
				r := alltrim(fdp:getobj:buffer)
				r := strtran(r, '\', '/')
				r := strtran(r, '//', '/')
				f := fileattr(r)
				do case
				case rat("*", r) != 0
					fdp:getobj:killFocus()
					gfocus := 2
					s := rat("/", r)
					if s <= 0
						fdp:mask:= substr(r, 3)
						r := substr(r, 1, 2)+"/"
					else
						fdp:mask:= substr(r, s+1)
						r := substr(r, 1, s)
					endif
					dirchange(r)
					initItem(fdp)
				case f >= FA_ARCHIVE
					retvalue := r
					nkey := 0
				case f<FA_ARCHIVE .and. f>0
					r += "/"
					r := strtran(r, "//", "/")
					if dirchange(r) == 0
						initItem(fdp)
						gfocus := 2
					endif
				otherwise
					messagep([Can't open;]+r)
				endcase
				showview(fdp)
				gfocus := 2
			case gfocus == 2
				item = alltrim(fdp:listobj:getItem())
				k=rat("/", item)
				if k != 0
				    r:=lastdir(fdp:getobj:varGet())
				    dirchange(substr(item, 1, k-1))
				    initItem(fdp)
				    if item == "../"
					fdp:listobj:find(r)
					fdp:listobj:findbuffer := ""
				    endif
				    showview(fdp)
				else
				    gfocus := 1
				    fdp:getobj:setFocus()
				    fdp:getobj:killFocus()
				    fdp:getobj:varPut(padr(alltrim(fdp:current) + item, 256))
				    fdp:getobj:setFocus()
				    fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
				endif
			case gfocus == 3
				diskchange(fdp:lbobj:__mtext[fdp:lbobj:value])
				gfocus := 2
				initItem(fdp)
				fdp:lbobj:killFocus()
				fdp:getobj:killFocus()
				fdp:listobj:setFocus()
				showview(fdp)
			endcase
		case gfocus == 3 .and. nkey == K_SPACE
			if lbopen
				fdp:lbobj:close()
			else
				fdp:lbobj:open()
			endif
			lbopen := !lbopen
		otherwise
		    if nkey>=32 .and. nkey<=256
		       do case
		       case gfocus == 1
				fdp:getobj:Insert(chr(nkey))
		       case gfocus == 2
				fdp:listobj:find(chr(nkey))
				@ fdp:nBottom, fdp:nLeft say padr(fdp:viewitem[fdp:listobj:buffer], fdp:length)
				devpos(fdp:listobj:line, fdp:listobj:row)
		       endcase
		    endif
	endcase
enddo
restore screen from scr
dirchange(PATH_DELIM+old_dir)
return retvalue

*************************************
static function initItem(fdp)
    local s, c, a, b, i, cc[2]

    fdp:viewitem := {}
    fdp:listobj:clear()
    c := curdir()
    fdp:current := strtran(currdrive()+"/"+iif(empty(c), "", c+"/"), "//", "/")

    //a := fileseek(current, 16)
    a := fileseek(fdp:current, FA_DIRECTORY)
    b := {}
    while !empty(a)
	#ifdef OS_CYGWIN
	if a == ".."
		a := fileseek()
		loop
	endif
	if a == "."
		a := ".."
	endif
	#else
	if a == "."
		a := fileseek()
		loop
	endif
	#endif
	cc[1] := a+"/"
	cc[2] := a+"|"+padr(padr(fileattrs(), 5)+"| "+str(filesize()), (fdp:nRight-fdp:nLeft)-23 )+"| "+filetime()+" | "+dtoc(filedate())
	aadd(b, aclone(cc))
	a := fileseek()
    enddo
    b := asort(b,,,{|x, y| x[1] < y[1]})
    for i=1 to len(b)
	fdp:listobj:addItem(b[i][1])
	aadd(fdp:viewitem, b[i][2])
    next

    b = {}
    a = fileseek(fdp:current+fdp:mask, FA_ARCHIVE+FA_VOLUME+FA_SYSTEM+FA_HIDDEN+FA_READONLY)
    //a = fileseek(current+mask, 32)
    while !empty(a)
	cc[1] := a
	cc[2] := a+"|"+padr(padr(fileattrs(), 5)+"| "+str(filesize()), (fdp:nRight-fdp:nLeft)-23 )+"| "+filetime()+" | "+dtoc(filedate())
	aadd(b, aclone(cc))
	a = fileseek()
    enddo
    b := asort(b,,,{|x, y| x[1] < y[1]})
    for i=1 to len(b)
	fdp:listobj:addItem(b[i][1])
	aadd(fdp:viewitem, b[i][2])
    next

    fdp:getobj:setFocus()
    fdp:getobj:killFocus()
    fdp:getobj:varPut(fdp:current+fdp:mask+DOP)
    fdp:getobj:setFocus()
    fdp:listobj:refresh()
return

*************************************
static func showview(fdp)
local i

i := fdp:listobj:buffer
@ fdp:nBottom, fdp:nLeft say padr(substr(fdp:viewitem[i], 1, at("|", fdp:viewitem[i])-1), fdp:length)
@ fdp:nBottom+1, fdp:nLeft say padr(substr(fdp:viewitem[i], at("|", fdp:viewitem[i])+1), fdp:length)
devpos(fdp:listobj:line, fdp:listobj:row)
return

*************************************
static func lastdir(str)
	str := substr(str, 1, rat("/", str)-1)
	str := substr(str, rat("/", str)+1)
return str

*************************************
static function i_driver(Driver)
	local i
	for i=67 to 90
		aadd(Driver, chr(i)+":")
	next
return


