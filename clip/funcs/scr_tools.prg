/*
	Copyright (C) 2002  ITK
	Author  : Tsarenko P  <tpe@dongu.donetsk.ua>
	License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "config.ch"

***************************************************************
Function SaySpread(cStr, nDelay, nRow, nCol)
	Local n1 := Int(len(cStr)/2), n2, nSleep
	if n1 = 0
		n1 := 1
	endif
	n2 := n1 + 1
	if nDelay == nil
		nDelay := 4
	endif
	nSleep := nDelay * 0.001
	if nRow == nil
		nRow := Row()
	endif
	if nCol == nil
		nCol := Col()
	endif
	nCol -= n1
	while .t.
		if n1 > 0
			DispOutAt(nRow, nCol + n1, Substr(cStr, n1, 1))
		endif
		if n2 <= len(cStr)
			DispOutAt(nRow, nCol + n2, Substr(cStr, n2, 1))
		endif
		Sleep(nSleep)
		n1 --
		n2 ++
		if n1 < 1 .and. n2 > Len(cStr)
			exit
		endif
	enddo
	SetPos(nRow, nCol)
Return ''

***************************************************************
Function SayMoveIn(cStr, nDelay, nRow, nCol, lDir)
	Local n1 := 1, nSleep
	if nDelay == nil
		nDelay := 4
	endif
	if lDir == nil
		lDir := .f.
	endif
	nSleep := nDelay * 0.001
	if nRow == nil
		nRow := Row()
	endif
	if nCol == nil
		nCol := Col()
	endif
	while n1 <= len(cStr)
		DispOutAt(nRow, if(lDir, nCol+len(cStr)-n1, nCol),;
		iif(lDir, Left(cStr, n1), Right(cStr, n1)))
			Sleep(nSleep)
			n1 ++
	enddo
	SetPos(nRow, nCol)
Return ''

***************************************************************
Function SayDown(cStr, nDelay, nRow, nCol)
	Local ser, nSleep
	if nDelay == nil
		nDelay := 4
	endif
	nSleep := nDelay * 0.001
	if nRow == nil
		nRow := Row()
	endif
	if nCol == nil
		nCol := Col()
	endif
	for ser := 1 to len(cStr)
		DispOutAt(nRow+ser-1, nCol, Substr(cStr, ser, 1))
		Sleep(nSleep)
	next
	SetPos(nRow, nCol)
Return ''

***************************************************************
Function CharWin(nTop, nLeft, nBottom, nRight, xNewChar, xOldChar)
	Local cScr, cNewChar, cOldChar, ser
	if nTop == nil
		nTop := 0
	endif
	if nLeft == nil
		nLeft := 0
	endif
	if nBottom == nil
		nBottom := MaxRow()
	endif
	if nRight == nil
		nRight := MaxCol()
	endif
	if xNewChar == nil
		cNewChar := GetClearB()
	elseif ValType(xNewChar) = 'N'
		cNewChar := Chr(xNewChar)
	else
		cNewChar := xNewChar
	endif
	if xOldChar # nil
		cOldChar := if(ValType(xOldChar)='N', Chr(xOldChar), xOldChar)
	endif
	cScr := SaveScreen(nTop, nLeft, nBottom, nRight)
	for ser := 1 to len(cScr) / 3
		if cOldChar == nil .or. Substr(cScr, (ser-1)*3+1, 1) == cOldChar
			cScr := Stuff(cScr, (ser-1)*3+1, 1, cNewChar)
		endif
	next
	RestScreen(nTop, nLeft, nBottom, nRight, cScr)
Return ''

***************************************************************
Function ClearEOL(nRow, nCol, xAttr, xChar)
	Local cAttr, cChar, cScr
	if nRow == nil
		nRow := Row()
	endif
	if nCol == nil
		nCol := Col()
	endif
	if xAttr == nil
		cAttr := chr(GetClearA())
	elseif ValType(xAttr) = 'N'
		cAttr := Chr(xAttr)
	else
		cAttr := xAttr
	endif
	if xChar == nil
		cChar := chr(GetClearB())
	elseif ValType(xChar) = 'N'
		cChar := Chr(xChar)
	else
		cChar := xChar
	endif
	cScr := Replicate(cChar+cAttr+Chr(0), MaxCol()-nCol+1)
	RestScreen(nRow, nCol, nRow, MaxCol(), cScr)
Return ''

***************************************************************
Function ClEOL(nRow, nCol)
	Local cScr
	if nRow == nil
		nRow := Row()
	endif
	if nCol == nil
		nCol := Col()
	endif
	cScr := Replicate(' '+Chr(0)+Chr(0), MaxCol()-nCol+1)
	RestScreen(nRow, nCol, nRow, MaxCol(), cScr)
Return ''

***************************************************************
Function ClearSlow(nDelay, nTop, nLeft, nBottom, nRight, xChar)
	Local cChar, nt, nl, nb, nr, ser
	if nTop == nil
		nTop := 0
	endif
	if nLeft == nil
		nLeft := 0
	endif
	if nBottom == nil
		nBottom := MaxRow()
	endif
	if nRight == nil
		nRight := MaxCol()
	endif
	if xChar == nil
		cChar := GetClearB()
	elseif ValType(xChar) = 'N'
		cChar := Chr(xChar)
	else
		cChar := xChar
	endif
	nt := nTop
	nl := nLeft
	nb := nBottom
	nr := nRight
	while nt < nb .or. nl < nr
		if nl < nr
			DispOutAt(nt, nl, Replicate(cChar, nr-nl+1))
			DispOutAt(nb, nl, Replicate(cChar, nr-nl+1))
		endif
		if nt < nb
			nt ++
			nb --
		endif
		if nt <= nb
			for ser := nt to nb
				DispOutAt(ser, nl, cChar)
				DispOutAt(ser, nr, cChar)
			next
		endif
		Sleep(nDelay*0.001)
		if nl < nr
			nl ++
			nr --
		endif
	enddo
Return ''

***************************************************************
Function ClWin(nTop, nLeft, nBottom, nRight)
	Local cScr
	if nTop == nil
		nTop := Row()
	endif
	if nLeft == nil
		nLeft := Col()
	endif
	if nBottom == nil
		nBottom := MaxRow() - 1
	endif
	if nRight == nil
		nRight := MaxCol() - 1
	endif
	cScr := Replicate(' ' + Chr(0) + Chr(0), (nRight-nLeft+1)*(nBottom-nTop+1))
	RestScreen(nTop, nLeft, nBottom, nRight, cScr)
Return ''

***************************************************************
Function ColorRepl(xNewAttr, xOldAttr)
	Local cNewAttr, cOldAttr, cScr, ser, np
	if xNewAttr == nil
		cNewAttr := GetClearA()
	elseif ValType(xNewAttr) = 'N'
		cNewAttr := Chr(xNewAttr)
	else
		cNewAttr := xNewAttr
	endif
	if xOldAttr # nil
		cOldAttr := if(ValType(xOldAttr)='N', Chr(xOldAttr), xOldAttr)
	endif
	cScr := SaveScreen(0, 0, MaxRow(), MaxCol())
	for ser := 1 to len(cScr) / 3
		np := (ser - 1)*3 + 2
		if cOldAttr == nil .or. Substr(cScr, np, 1) == cOldAttr
			cScr := Stuff(cScr, np, 1, cNewAttr)
		endif
	next
	RestScreen(0, 0, MaxRow(), MaxCol(), cScr)
Return ''

/*
***************************************************************
Function ScreenMix(cStr, cAttr, nRow, nCol)
	Local nLen := Min(len(cStr), len(cAttr))
	Local cScr := '', ser
	if nRow == nil
		nRow := Row()
	endif
	if nCol == nil
		nCol := Col()
	endif
	for ser := 1 to nLen
		cScr += Substr(cStr, ser, 1) + Substr(cAttr, ser, 1) + Chr(0)
	next
	RestScreen(nRow, nCol, nRow, nCol+nLen-1, cScr)
Return ''
*/

***************************************************************
func ClearWin(nTop, nLeft, nBottom, nRight, xAttr, xChar)
	Local cChar, nAttr, cScr
	if nTop == nil
		nTop := Row()
	endif
	if nLeft == nil
		nLeft := Col()
	endif
	if nBottom == nil
		nBottom := MaxRow()
	endif
	if nRight == nil
		nRight := MaxCol()
	endif

	if xChar == nil
		cChar := GetClearB()
	elseif ValType(xChar) = 'N' .and. xChar >= 0 .and. xChar <= 255
		cChar := Chr(xChar)
	else
		cChar := xChar
	endif

	if xAttr == nil
		nAttr := GetClearA()
	elseif ValType(xAttr) = 'C'
		nAttr := ColorToN(xAttr)
	else
		nAttr := xAttr
	endif
	cScr := Replicate(cChar + Chr(nAttr) + Chr(0),;
		(nRight-nLeft+1)*(nBottom-nTop+1))
	RestScreen(nTop, nLeft, nBottom, nRight, cScr)
Return ''

***********************************
func ColorWin(nTop, nLeft, nBottom, nRight, xAttr, xOld)
	Local cScr, nAttr, cAttr, nOld, ser, np,x:=3

#ifdef CLIP_DOS_SCRBUF
	x:=2
#endif

	if nTop == nil
		nTop := Row()
	endif
	if nLeft == nil
		nLeft := Col()
	endif
	if nBottom == nil
		nBottom := MaxRow()
	endif
	if nRight == nil
		nRight := MaxCol()
	endif
	if xAttr == nil
		nAttr := GetClearA()
	elseif ValType(xAttr) = 'C'
		nAttr := ColorToN(xAttr)
	else
		nAttr := xAttr
	endif
	if xOld # nil
		nOld := if(ValType(xOld) = 'C', ColorToN(xOld), xOld)
	endif

	cScr := SaveScreen(nTop, nLeft, nBottom, nRight)

	for ser := 1 to len(cScr) / x
		np := (ser-1)*x + 2
		cAttr := Substr(cScr, np, 1)
		if nOld == nil .or. nOld == Asc(cAttr)
			cScr := Stuff(cScr, np, 1, Chr(nAttr))
		endif
	next

	RestScreen(nTop, nLeft, nBottom, nRight, cScr)
Return ''

***********************************
Function SayScreen(cStr, nRow, nCol)
	Local cScr, ser
	if nRow == nil
		nRow := Row()
	endif
	if nCol == nil
		nCol := Col()
	endif
	cScr := SaveScreen(nRow, nCol, nRow, nCol + Len(cStr) - 1)
	for ser := 1 to len(cStr)
		cScr := Stuff(cScr, (ser-1)*3+1, 1, Substr(cStr, ser, 1))
	next
	RestScreen(nRow, nCol, nRow, nCol + Len(cStr) - 1, cScr)
Return ''
