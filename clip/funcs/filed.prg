/*
  All right reserved. (C) ITK,Izhevsk,Russia
  Author - Kornilova Elena
  E-mail - alena@itk.ru
  Home ftp - ftp.itk.ru/pub/clip
  Date  - 15/05/2000 year
  License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "inkey.ch"

#define FA_NORMAL	0
#define FA_READONLY	1
#define FA_HIDDEN	2
#define FA_SYSTEM	4
#define FA_VOLUME	8
#define FA_DIRECTORY	16
#define FA_ARCHIVE	32

#define HISTORY_SIZE	25
#define DOP		replicate(" ", 256)

#define HISTORY_COLORS	"15/3,15/7,0/7,0/3,0/2"
#define DIALOG_COLORS	"0/7"
#define LIST_COLORS	"0/3,0/2,15/3,0/3,0/2,15/2,15/2"
#define CNT_COLUMNS	3
#define DELIMITER	translate_charset(__CHARSET__, host_charset(), "")


/***********************************/
/* pDir  - current directory       */
/* pMask - files template 	   */
/* pHistory - history object       */
/***********************************/
function fileDialog(pDir, pMask, pHistory)
static __ST_HIST
local gi, retvalue, scr, k, item, lItem, r, f, s, nkey:=1, gfocus, i
local fdp:=map(), drv, mCol, mRow, ll, curCol, curRow, lenCol
local nLeft, nRight, nTop, nBottom

fdp:current := ""

k := int(2*maxcol(.t.)/3)
if (k-CNT_COLUMNS+1)%CNT_COLUMNS > 0
	k--
endif
r := int(3*maxrow(.t.)/6)
nLeft := int((maxcol(.t.)-k)/2)+1
nRight := nLeft + k - 1
nTop := int((maxrow(.t.)-r)/2)+1
nBottom := nTop + r - 1

setcolor(DIALOG_COLORS)

//@ nTop-3, nLeft-1 clear to nBottom+2, nRight+1
//@ fdp:nTop-3, fdp:nLeft-1 TO fdp:nBottom+2, fdp:nRight+1
wopen(nTop-3, nLeft-1, nBottom+2, nRight+1)
wbox()
fdp:nLeft   := 0
fdp:nRight  := maxcol()
fdp:nTop    := 2
fdp:nBottom := maxrow()-1


retvalue := ""
fdp:mask := iif(empty(pmask), "*", pMask)

if !empty(pDir)
	dirchange(pDir)
endif

if pHistory == NIL
	if empty(__ST_HIST)
		pHistory := historyObj()
		pHistory:setsize(HISTORY_SIZE)
		pHistory:colorSpec := HISTORY_COLORS
		__ST_HIST := pHistory
	else
		pHistory := clone(__ST_HIST)
	endif
endif

pHistory:Lrow := fdp:nTop-1
pHistory:Lcol := fdp:nLeft+1
pHistory:Rrow := fdp:nBottom-2
pHistory:Rcol := fdp:nRight-2

fdp:length   := k
gi := ""

fdp:getobj  := getnew(fdp:nTop-2, fdp:nLeft,{|_1| iif(_1==NIL, gi,gi:=_1)}, "gi", "@kS"+alltrim(str(fdp:length-1)), "w+/b")
fdp:listobj := listitemnew(fdp:nTop, fdp:nLeft, fdp:nBottom, fdp:nRight, CNT_COLUMNS, DELIMITER, LIST_COLORS)
initItem(fdp)
fdp:getobj:varPut(fdp:current+fdp:mask+DOP)

showview(fdp)
dispbegin()
@ fdp:nBottom, fdp:nLeft say "<" color "W+/W"
@ fdp:nBottom, fdp:nRight say ">" color "W+/W"
@ fdp:nTop-2, fdp:nRight say ">" color "W+/B"
dispend()

fdp:getobj:setFocus()
gfocus := .t.
lenCol := {}
lItem := fdp:ListObj
ll := nLeft
for i:=1 to CNT_COLUMNS
	aadd(lenCol, {ll, ll+lItem:LenCol[i]})
	ll += lItem:LenCol[i]+1
next

while nkey!=0
	nkey := Inkey(0, INKEY_ALL)
	if mRightDown()
		nKey := 0
		loop
	endif
	if mLeftDown()
		mCol := mCol()
		mRow := mRow()
		if !(between(mCol, nLeft-1, nRight+1) .and.;
		     between(mRow, nTop-2, nBottom+1))
			loop
		endif

		do case
		case mRow == nBottom .and. mCol == nLeft
			if gfocus
				fdp:getobj:assign()
				fdp:getobj:killFocus()
				fdp:listobj:setFocus()
				gFocus := .f.
			endif
			nKey := K_UP
		case mRow == nBottom .and. mCol == nRight
			if gfocus
				fdp:getobj:assign()
				fdp:getobj:killFocus()
				fdp:listobj:setFocus()
				gFocus := .f.
			endif
			nKey := K_DOWN
		case mRow == nTop-2 .and. mCol == nRight
			if !gfocus
				fdp:listobj:killFocus()
				fdp:getobj:setFocus()
				gfocus := .t.
			endif
			nKey := K_DOWN
		case mRow == nTop-2
			if gFocus   // getobj in focus
				nKey := K_ENTER
			else
				nKey := K_TAB
			endif
		case mCol == nLeft-1
			if gfocus
				nKey := K_TAB
			else
				nKey := K_LEFT
			endif
		case mCol == nRight+1
			if gFocus
				nKey := K_TAB
			else
				nKey := K_RIGHT
			endif
		case between(mRow, nTop, nBottom)
			curCol := lItem:Pos
			for i:=1 to CNT_COLUMNS
				if between(mCol, lenCol[i][1], lenCol[i][2])
					curCol := i
					exit
				endif
			next
			curRow := mRow - nTop

			if gFocus  // getobj in focus
				nKey := K_TAB
			elseif lItem:first + (curCol-1)*lItem:RowWin + curRow == lItem:buffer
				nKey := K_ENTER
			endif

			lItem:setItem(lItem:first + (curCol-1)*lItem:RowWin + curRow )
		endcase
	endif
	do case
		case nkey == K_LEFT
			if gfocus
				fdp:getobj:left()
			else
				fdp:listobj:left()
				showview(fdp)
			endif
		case nkey == K_RIGHT
			if gfocus
				fdp:getobj:right()
			else
				fdp:listobj:right()
				showview(fdp)
			endif
		case nkey == K_UP
			if gfocus
			else
				fdp:listobj:up()
				showview(fdp)
			endif
		case nkey == K_DOWN
			if gfocus
				s := pHistory:run()
				if !empty(s)
					pHistory:insert(s)
				else
					s := fdp:getobj:varGet()
				endif
				fdp:getobj:varPut(s)
				fdp:getobj:assign()
				fdp:getobj:setFocus()
				fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
			else
				fdp:listobj:down()
				showview(fdp)
			endif
		case nkey == K_HOME
			if gfocus
				fdp:getobj:home()
			else
				fdp:listobj:home()
				showview(fdp)
			endif
		case nkey == K_END
			if gfocus
				fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
			else
				fdp:listobj:end()
				showview(fdp)
			endif
		case nkey == K_PGUP
			fdp:listobj:pageup()
				showview(fdp)
		case nkey == K_PGDN
			fdp:listobj:pagedown()
				showview(fdp)
		case nkey == K_INS
			if gfocus
				fdp:getobj:Insert()
			endif
		case nkey == K_DEL
			if gfocus
				fdp:getobj:delRight()
			endif
		case nkey == K_BS
			if gfocus
				fdp:getobj:backSpace()
			endif
		case nkey == K_TAB
			gfocus := !gfocus
			if gfocus
				fdp:listobj:killFocus()
				fdp:getobj:setFocus()
				fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
			else
				fdp:getobj:assign()
				fdp:getobj:killFocus()
				fdp:listobj:setFocus()
			endif
		case nkey == K_ESC
			nkey := 0
		case nkey == K_ENTER
			if gfocus
				r := alltrim(fdp:getobj:buffer)
				r := strtran(r, '\', '/')
				f := fileattr(r)
				do case
				case rat("*", r) != 0
					f := substr(r, 1, rat("/", r)-1)
					drv := substr(f, 1, at(":", f))
					if drv != currdrive()
						diskchange(drv)
					endif
					f := substr(f, at(":", f)+1)
					dirchange(f)
					fdp:mask := substr(r, rat("/", r)+1)
					initItem(fdp)
				case f >= FA_ARCHIVE
					retvalue := r
					nkey := 0
				case f<FA_ARCHIVE .and. f>0
					drv := substr(r, 1, at(":", r))
					if drv != currdrive()
						diskchange(drv)
					endif
					r := substr(r, at(":", r)+1)
					if dirchange(r) == 0
						initItem(fdp)
					endif
				otherwise
					retvalue := r
					nkey := 0
					//messagep("Can't open;"+r)
				endcase
				s := rtrim(r)
				pHistory:insert(s)

				showview(fdp)
				fdp:getobj:killFocus()
				fdp:listobj:setFocus()
				gfocus := .f.
			else
				item = alltrim(fdp:listobj:getItem())
				k=rat("/", item)
				if k != 0
				    r:=lastdir(fdp:getobj:varGet())
				    dirchange(substr(item, 1, k-1))
				    initItem(fdp)
				    if item == "../"
					fdp:listobj:find(r)
					fdp:listobj:clearFindBuffer()
				    endif
				    showview(fdp)
				else
				    gfocus := .t.
				    fdp:listobj:killFocus()
				    fdp:getobj:varPut(padr(alltrim(fdp:current) + item, 256))
				    fdp:getobj:setFocus()
				    fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
				endif
			endif
		otherwise
		    if nkey>=32 .and. nkey<=256
		       if gfocus
				fdp:getobj:Insert(chr(nkey))
		       else
				fdp:listobj:find(chr(nkey))
				i := fdp:listobj:buffer
				@ fdp:nBottom, fdp:nLeft say padr(substr(fdp:viewitem[i], 1, at("|", fdp:viewitem[i])-1), fdp:length)
				@ fdp:nBottom+1, fdp:nLeft say padr(substr(fdp:viewitem[i], at("|", fdp:viewitem[i])+1), fdp:length)
				devpos(fdp:listobj:line, fdp:listobj:row)
		       endif
		    endif
	endcase
enddo
//restscreen(0, 0, maxrow(.t.), maxcol(.t.), scr)
wclose()
return retvalue

static function initItem(fdp)
    local s, c, a, b, i, cc[2]

    fdp:viewitem := {}
    fdp:listobj:clear()
    c := curdir()
    fdp:current := currdrive()+"/"+iif(empty(c), "", c+"/")
    //a := fileseek(current, 16)
    a := fileseek(fdp:current, FA_DIRECTORY)
    b := {}
    while !empty(a)
	if a == "."
		a := fileseek()
		loop
	endif
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

    fdp:getobj:varPut(fdp:current+fdp:mask+DOP)
    fdp:getobj:setFocus()
    fdp:listobj:refresh()
return

static func showview(fdp)
local i
dispbegin()
i := fdp:listobj:buffer
@ fdp:nBottom, fdp:nLeft+2 say padr(substr(fdp:viewitem[i], 1, at("|", fdp:viewitem[i])-1), fdp:length-4)
@ fdp:nBottom+1, fdp:nLeft say padr(substr(fdp:viewitem[i], at("|", fdp:viewitem[i])+1), fdp:length)
devpos(fdp:listobj:line, fdp:listobj:row)
dispend()
return

static func lastdir(str)
	str := substr(str, 1, rat("/", str)-1)
	str := substr(str, rat("/", str)+1)
return str

