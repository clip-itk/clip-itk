/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "set.ch"

#define HOT_KEYS "1234567890абвгдежзиклмнопрст"

static massPrompt[0]
static massHotKey[0]
static nhotkey:=1
***************************************
function __AtPrompt(row,col,prompt,msg)
	local pos, colDop, colDop1 ,i
	colDop:= setcolor()
	colDop:=substr(colDop,at('/',colDop))
	colDop1:=substr(colDop,at(',',colDop)+1)
	colDop1:=substr(colDop1,1,at('/',colDop1)-1)
	if colDop1==substr(colDop,2,at(',',colDop)-2)
		colDop:="14"+colDop
	else
		colDop:=colDop1+colDop
	endif
	pos:=at('~',prompt)
	if pos>0
		prompt:=substr(prompt,1,pos-1)+substr(prompt,pos+1)
		aadd(massHotkey,{pos,lower(substr(prompt,pos,1))})
	else
		aadd(massHotkey,{0,substr(HOT_KEYS,nhotkey,1)})
		nhotkey++
	endif
	aadd(massPrompt,{int(row),int(col),prompt,msg})
	dispOutAt(row, col, prompt )
	i=len(masshotkey)
	if pos>0
		dispOutAt( row, col+pos-1, massHotkey[len(massHotkey)][2], colDop)
	endif
return .f.
***************************************
static function sayPromptVyd(n,colVyb)
	local row:=set(_SET_MESSAGE)
	dispOutAt( massPrompt[n][1],massPrompt[n][2], massPrompt[n][3], colVyb )
	if !empty(massprompt[n][4]) .and. row>0
		if set(_SET_MCENTER)
			dispOutAt( row,0, padc(massprompt[n][4],maxcol()), colvyb )
		else
			dispOutAt( row,0, padr(massprompt[n][4],maxcol()), colvyb )
		endif
	endif
	//setpos(massPrompt[n][1],massPrompt[n][2])
	dispOutAt(massPrompt[n][1],massPrompt[n][2],"")
return
***************************************
static function sayPrompt(n,colosn)
	local colDop, colDop1
	colDop:= colosn
	colDop:=substr(colDop,at('/',colDop))
	colDop1:=substr(colDop,at(',',colDop)+1)
	colDop1:=substr(colDop1,1,at('/',colDop1)-1)
	if colDop1==substr(colDop,2,at(',',colDop)-2)
		colDop:="14"+colDop
	else
		colDop:=colDop1+colDop
	endif
	dispOutAt(massPrompt[n][1],massPrompt[n][2], massPrompt[n][3], colosn)
	if masshotkey[n][1]>0
		dispOutAt(massPrompt[n][1],massPrompt[n][2]+massHotkey[n][1]-1, massHotkey[n][2], colDop)
	endif
return
***************************************
function __menuTo(choice,_varname)
	local oldcur, colDop, colOsn
	local nChoice:=0, i:=0, j
	local oldChoice,PrevChoice:=-1,lWrap:=set(_SET_WRAP)
	local nKey:=0, flagSeek:=.f.
	local bKeyBlock, oldErrBlock,err
	local _massp,_masshk
	local chr, lenMass:=len(massPrompt)
	local mI, mCol, mChoice
	//parameters choice,_varname
	set("__readvar",_varname)
	oldcur:=setcursor(0)
	colOsn:=colDop:=setcolor()
	colDop:=substr(colDop,at(',',colDop)+1)
	colDop:=substr(colDop,1,at(',',colDop)-1)
	if valtype(choice)=="B"
		oldErrBlock:=errorBlock({ |e| break(e) } )
		begin sequence
			nchoice=eval(choice)
		recover using err
			nchoice:=1
		end sequence
		errorBlock(oldErrBlock)
	else
		nchoice=1
	endif
	if valtype(nchoice)!="N"
		nchoice=1
	endif
	if nchoice==NIL .or. nchoice<=0 .or. nchoice>len(massprompt)
		nchoice=1
	endif
	sayPromptVyd(nChoice,colDop)
	do while nKey!=27 .and. nKey!=13
		do while .t.
			nKey := InKey(0, 255) //INKEY_ALL)
			if ( (bKeyBlock:=setkey(nKey))!=NIL )
				_massp=aclone(massprompt)
				_masshk=aclone(masshotkey)
				asize(massprompt,0)
				asize(masshotkey,0)
				eval(bKeyBlock,procname(),procline(),_varname)
				set("__readvar",_varname)
				massprompt=aclone(_massp)
				masshotkey=aclone(_masshk)
			else
				exit
			endif
		enddo
		dispbegin()
		if mRightDown()
			nKey := 27
			loop
		endif
		if mLeftDown() .and. mRow() == massprompt[1][1]
			mChoice := 0
			mCol := mCol()
			for mI=1 to len(massprompt)
				if between(mCol, massprompt[mI][2], massprompt[mI][2]+len(massprompt[mI][3]))
					mChoice := mI
					exit
				endif
			next
			if mChoice > 0
				if nChoice == mChoice
					nKey := 13
				else
					sayPrompt(nChoice,colOsn)
					nChoice:=mChoice
					sayPromptVyd(nChoice,colDop)
					nKey := -1
				endif
			endif
		endif
		do case
			case nKey==5 .or. nKey==19
				sayPrompt(nChoice,colOsn)
				nChoice:=iif(nChoice > 1, nChoice-1, iif( lWrap, lenMass, nChoice))
				sayPromptVyd(nChoice,colDop)
			case nKey==24 .or. nKey==4
				sayPrompt(nChoice,colOsn)
				nChoice:=iif(nChoice < lenMass, nChoice+1,  iif( lWrap, 1, nChoice))
				sayPromptVyd(nChoice,colDop)
			case nKey==1
				sayPrompt(nChoice,colOsn)
				nChoice:=1
				sayPromptVyd(nChoice,colDop)
			case nKey==6  //End
				sayPrompt(nChoice,colOsn)
				nChoice:=lenMass
				sayPromptVyd(nChoice,colDop)
			case nKey >= 32 .and. nKey <= 259
				oldChoice:=nChoice
				chr:=alltrim(lower(chr(lastKey())))
				i:=iif(nChoice<lenMass,nChoice+1,1)
			do while i!=nChoice
				if chr==massHotkey[i][2]
					flagSeek:=.t.
					sayPrompt(nChoice,colOsn)
					nChoice:=i
					sayPromptVyd(nChoice,colDop)
					exit
				endif
				i:=(iif(i==lenMass, 1, i+1))
			enddo
		endcase
		dispend()
		PrevChoice:=nChoice
	enddo
	sayPrompt(nChoice,colOsn)
	if nKey==27
		nChoice:=0
	endif
	asize(massPrompt,0)
	asize(massHotkey,0)
	nhotkey:=1
	setcursor(oldcur)
	set("__varname","")
return nChoice

