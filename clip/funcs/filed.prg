/*
  All right reserved. (C) ITK,Izhevsk,Russia
  Author - Kornilova Elena
  E-mail - alena@itk.ru
  Home ftp - ftp.itk.ru/pub/clip
  Date  - 15/05/2000 year
  License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "inkey.ch"
#include <clipcfg.h>
#include <pgch.ch>

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
/*#define DELIMITER	translate_charset(__CHARSET__, host_charset(), "")*/

#define DELIMITER 	chr(PGCH_VLINE)


/***********************************/
/* pDir  - current directory       */
/* pMask - files template 	   */
/* History - history object        */
/***********************************/
static nLeft, nRight, nTop, nBottom, lItem, lenCol, pHistory, fdp:=map()
function fileDialog(pDir, pMask, history)
static __ST_HIST
local gi, retvalue, scr, k, r, f, s, nkey:=1, gfocus, i
local drv, ll, curCol, old_dir := curDir()

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

pHistory := history

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
	nKey := iif(gfocus, __get_handler(nKey, @gfocus, @retvalue), __list_handler(nKey, @gfocus, @retvalue))
enddo
//restscreen(0, 0, maxrow(.t.), maxcol(.t.), scr)
wclose()
dirchange(PATH_DELIM+old_dir)
return retvalue

*******************************************************************************
* handler for get-object
static function __get_handler(nKey, gfocus, retvalue)
local mCol, mRow, i, curCol, curRow, f, r, s, k, error
	if mLeftDown()
		mCol := mCol()
		mRow := mRow()
		if !(between(mCol, nLeft-1, nRight+1) .and.;
		     between(mRow, nTop-2, nBottom+1))
			return
		endif

		do case
		case mRow == nBottom .and. mCol == nLeft
			fdp:getobj:assign()
			fdp:getobj:killFocus()
			fdp:listobj:setFocus()
			gFocus := .f.
			nKey := K_UP
		case mRow == nBottom .and. mCol == nRight
			fdp:getobj:assign()
			fdp:getobj:killFocus()
			fdp:listobj:setFocus()
			gFocus := .f.
			nKey := K_DOWN
		case mRow == nTop-2 .and. mCol == nRight
			nKey := K_DOWN
		case mRow == nTop-2
			nKey := K_ENTER
		case mCol == nLeft-1
			nKey := K_TAB
		case mCol == nRight+1
			nKey := K_TAB
		case between(mRow, nTop, nBottom)
			curCol := lItem:Pos
			for i:=1 to CNT_COLUMNS
				if between(mCol, lenCol[i][1], lenCol[i][2])
					curCol := i
					exit
				endif
			next
			curRow := mRow - nTop

			nKey := K_TAB

			lItem:setItem(lItem:first + (curCol-1)*lItem:RowWin + curRow )
		endcase
	endif
	do case
		case nkey == K_CTRL_Y
			fdp:getobj:delEnd()
		case nkey == K_LEFT
			fdp:getobj:left()
		case nkey == K_RIGHT
			fdp:getobj:right()
		case nkey == K_DOWN
			s := pHistory:run()
			if !empty(s)
				pHistory:insert(s)
			else
				s := fdp:getobj:varGet()
			endif
			fdp:getobj:varPut(padr(s, 256))
			//fdp:getobj:assign()
			fdp:getobj:setFocus()
			fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
		case nkey == K_HOME
			fdp:getobj:home()
		case nkey == K_END
			fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
		case nkey == K_INS
			fdp:getobj:Insert()
		case nkey == K_DEL
			fdp:getobj:delRight()
		case nkey == K_BS
			fdp:getobj:backSpace()
		case nkey == K_TAB
			gfocus := !gfocus
			fdp:getobj:assign()
			fdp:getobj:killFocus()
			fdp:listobj:setFocus()
		case nkey == K_ESC
			nkey := 0
		case nkey == K_ENTER
			r := alltrim(fdp:getobj:buffer)
			r := strtran(r, '\', '/')
			r := strtran(r, '//', '/')
			BEGIN SEQUENCE
			ERRORBLOCK({|e| alert(e:description+";"+e:args[1], break(e))})
			f := fileattr(r)
			RECOVER USING error
			END SEQUENCE
			do case
			case rat("*", r) != 0
				s := rat("/", r)
				if s <= 0
					fdp:mask:= substr(r, 3)
					r := substr(r, 1, 2)+"/"
				else
					fdp:mask:= substr(r, s+1)
					r := substr(r, 1, s)
				endif
			    BEGIN SEQUENCE
			    ERRORBLOCK({|e| alert(e:description+";"+e:args[1])})
			    dirchange(r)
			    RECOVER USING error
				do while !file(r)
				dirchange("../")
				enddo
				r := curdir()
			    END SEQUENCE
				initItem(fdp)
			case f >= FA_ARCHIVE
				retvalue := r
				nkey := 0
			case f<FA_ARCHIVE .and. f>0
				r += "/"
				r := strtran(r, "//", "/")
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
		otherwise
		    if nkey>=32 .and. nkey<=256
			fdp:getobj:Insert(chr(nkey))
		    endif
	endcase
return nKey

*******************************************************************************
* handler for list-object
static function __list_handler(nKey, gfocus, retvalue)
local mCol, mRow, i, curCol, curRow, f, r, s, k, item, error
	if mLeftDown()
		mCol := mCol()
		mRow := mRow()
		if !(between(mCol, nLeft-1, nRight+1) .and.;
		     between(mRow, nTop-2, nBottom+1))
			return
		endif

		do case
		case mRow == nBottom .and. mCol == nLeft
			nKey := K_UP
		case mRow == nBottom .and. mCol == nRight
			nKey := K_DOWN
		case mRow == nTop-2 .and. mCol == nRight
			fdp:listobj:killFocus()
			fdp:getobj:setFocus()
			gfocus := .t.
			nKey := K_DOWN
		case mRow == nTop-2
			nKey := K_TAB
		case mCol == nLeft-1
			nKey := K_LEFT
		case mCol == nRight+1
			nKey := K_RIGHT
		case between(mRow, nTop, nBottom)
			curCol := lItem:Pos
			for i:=1 to CNT_COLUMNS
				if between(mCol, lenCol[i][1], lenCol[i][2])
					curCol := i
					exit
				endif
			next
			curRow := mRow - nTop

			if lItem:first + (curCol-1)*lItem:RowWin + curRow == lItem:buffer
				nKey := K_ENTER
			endif

			lItem:setItem(lItem:first + (curCol-1)*lItem:RowWin + curRow )
		endcase
	endif
	do case
		case nkey == K_LEFT
			fdp:listobj:left()
			showview(fdp)
		case nkey == K_RIGHT
			fdp:listobj:right()
			showview(fdp)
		case nkey == K_UP
			fdp:listobj:up()
			showview(fdp)
		case nkey == K_DOWN
			fdp:listobj:down()
			showview(fdp)
		case nkey == K_HOME
			fdp:listobj:home()
			showview(fdp)
		case nkey == K_END
			fdp:listobj:end()
			showview(fdp)
		case nkey == K_PGUP
			fdp:listobj:pageup()
			showview(fdp)
		case nkey == K_PGDN
			fdp:listobj:pagedown()
			showview(fdp)
		case nkey == K_TAB
			gfocus := !gfocus
			fdp:listobj:killFocus()
			fdp:getobj:setFocus()
			fdp:getobj:gotopos(len(alltrim(fdp:getobj:varGet()))+1)
		case nkey == K_ESC
			nkey := 0
		case nkey == K_ENTER
			item = alltrim(fdp:listobj:getItem())
			k=rat("/", item)
			if k != 0
			    r:=lastdir(fdp:getobj:varGet())

			    if dirchange(substr(item, 1, k-1)) < 0
				alert([Bad directory name!])
				dirchange("/")
			    endif
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
		otherwise
		    if nkey>=32 .and. nkey<=256
			fdp:listobj:find(chr(nkey))
			i := fdp:listobj:buffer
			@ fdp:nBottom, fdp:nLeft say padr(substr(fdp:viewitem[i], 1, at("|", fdp:viewitem[i])-1), fdp:length)
			@ fdp:nBottom+1, fdp:nLeft say padr(substr(fdp:viewitem[i], at("|", fdp:viewitem[i])+1), fdp:length)
			devpos(fdp:listobj:line, fdp:listobj:col)
		    endif
	endcase
return nKey

*******************************************************************************
* initiation list items
static function initItem(fdp)
local s, c, a, b, i, error

	BEGIN SEQUENCE
	ERRORBLOCK({|e| alert(e:description+';'+e:operation), break(e)})
	c := curdir()
	fdp:current := strtran(currdrive()+"/"+iif(empty(c), "", c+"/"), "//", "/")
	fdp:viewitem := {}
	fdp:listobj:clear()

	//a := fileseek(current, 16)
	a := fileseek(fdp:current, FA_DIRECTORY)
	b := tSortedArrayNew()
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
	b:add(a+"/", a+"|"+padr(padr(fileattrs(), 5)+"| "+str(filesize()), (fdp:nRight-fdp:nLeft)-23 )+"| "+filetime()+" | "+dtoc(filedate()))
	a := fileseek()
    enddo
    for i=1 to b:len()
	fdp:listobj:addItem(b:getKey(i))
	aadd(fdp:viewitem, b:getData(i))
    next

    b = tSortedArrayNew()
    a = fileseek(fdp:current+fdp:mask, FA_ARCHIVE+FA_VOLUME+FA_SYSTEM+FA_HIDDEN+FA_READONLY)
    //a = fileseek(current+mask, 32)
    while !empty(a)
	b:add(a, a+"|"+padr(padr(fileattrs(), 5)+"| "+str(filesize()), (fdp:nRight-fdp:nLeft)-23 )+"| "+filetime()+" | "+dtoc(filedate()))
	a = fileseek()
    enddo
    for i=1 to b:len()
	fdp:listobj:addItem(b:getKey(i))
	aadd(fdp:viewitem, b:getData(i))
    next

    fdp:getobj:varPut(fdp:current+fdp:mask+DOP)
    fdp:getobj:setFocus()
    fdp:listobj:refresh()
    END SEQUENCE
return

static func showview(fdp)
local i
if fdp:listobj:itemCount > 0
	dispbegin()
	i := fdp:listobj:buffer
	@ fdp:nBottom, fdp:nLeft say padr(substr(fdp:viewitem[i], 1, at("|", fdp:viewitem[i])-1), fdp:length-4)
	@ fdp:nBottom+1, fdp:nLeft say padr(substr(fdp:viewitem[i], at("|", fdp:viewitem[i])+1), fdp:length)
	devpos(fdp:listobj:line, fdp:listobj:col)
	dispend()
endif
return

static func lastdir(str)
	str := substr(str, 1, rat("/", str)-1)
	str := substr(str, rat("/", str)+1)
return str

