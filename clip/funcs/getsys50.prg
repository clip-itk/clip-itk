/*
    Copyright (C) 2001  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "Set.ch"
#include "Inkey.ch"
#include "Getexit.ch"
#include "config.ch"

#define K_UNDO          K_CTRL_U

#ifdef LANG_RUSSIAN
      #define MSG_INSERT     "Вст"
      #define MSG_OVERWRITE  "Зам"
      #define MSG_DATE_ERROR "Ошибка Даты "
      #define MSG_RANGE_ERROR "Диапазон: "
#else
      #define MSG_INSERT    "Ins"
      #define MSG_OVERWRITE "Ovr"
      #define MSG_DATE_ERROR " Date error "
      #define MSG_RANGE_ERROR "In range: "
#endif

// Координаты SCOREBOARD - области состояния на экране
#define SCORE_ROW		0
#define SCORE_COL		60

// Глобальные переменные состояния для активации READ
static status
static __getlist

****************************************
func ReadModal( GetList )
	local get,ret , pos:=1, savedGetSysVars
	__getlist:=getList
	if status==NIL
	   __getSysInit()
	endif
	if ( ValType(status:Format) == "B" )
		Eval(status:Format)
	end
	if ( Empty(getList) )
	     SetPos( MaxRow()-1, 0 )
	     return (.f.)
	end
	savedGetSysVars := ClearGetSysVars()
	status:ReadProcName := ProcName(1)
	status:ReadProcLine := ProcLine(1)
	pos := Settle( Getlist, 0 )
	status:currentGet := pos

	while ( pos <> 0 )
		get := GetList[pos]
		PostActiveGet( get )
		if ( ValType( get:reader ) == "B" )
		      Eval( get:reader, get )
		else
		      GetReader( get )
		end
		pos := Settle( GetList, pos )
		status:currentGet=pos
	end
	ret:=status:updated
	RestoreGetSysVars(savedGetSysVars)
	SetPos( MaxRow()-1, 0 )
return (status:updated)

****************************************
proc GetReader( get )
	if ( GetPreValidate(get) )
		get:SetFocus()
		while ( get:exitState == GE_NOEXIT )
			if ( get:typeOut )
				get:exitState := GE_ENTER
			end
			while ( get:exitState == GE_NOEXIT )
				GetApplyKey( get, Inkey(0) )
			end
			if ( !GetPostValidate(get) )
				get:exitState := GE_NOEXIT
			end
		end
		get:KillFocus()
	end
return



****************************************
proc GetApplyKey(get, key)

local cKey
local bKeyBlock


	if ( (bKeyBlock := SetKey(key)) <> NIL )
		GetDoSetKey(bKeyBlock, get)
		return
	end
	//dispbegin()
	do case
	case ( key == K_UP )
		get:exitState := GE_UP

	case ( key == K_SH_TAB )
		get:exitState := GE_UP

	case ( key == K_DOWN )
		get:exitState := GE_DOWN

	case ( key == K_TAB )
		get:exitState := GE_DOWN

	case ( key == K_ENTER )
		get:exitState := GE_ENTER

	case ( key == K_ESC )
		if ( Set(_SET_ESCAPE) )
			get:undo()
			get:exitState := GE_ESCAPE
		end

	case ( key == K_PGUP )
		get:exitState := GE_WRITE

	case ( key == K_PGDN )
		get:exitState := GE_WRITE

	case ( key == K_CTRL_HOME )
		get:exitState := GE_TOP


	case (key == K_CTRL_END)
		get:exitState := GE_BOTTOM

	case (key == K_CTRL_W)
		get:exitState := GE_WRITE

	case (key == K_INS)
		Set( _SET_INSERT, !Set(_SET_INSERT) )
		ShowScoreboard()

	case (key == K_HOME)
		get:Home()

	case (key == K_END)
		get:End()

	case (key == K_RIGHT)
		get:Right()
	case (key == K_CTRL_RIGHT)
		get:WordRight()

	case (key == K_LEFT)
		get:Left()
	case (key == K_CTRL_LEFT)
		get:WordLeft()

	case (key == K_BS)
		get:BackSpace()

	case (key == K_DEL)
		get:Delete()

	case (key == K_CTRL_Y)
		get:DelEnd()

	case (key == K_UNDO)
		get:Undo()

	case (key == K_CTRL_T)
		get:DelWordRight()

	case (key == K_CTRL_BS)
		get:DelWordLeft()

	otherwise

		if (key >= 32 .and. key <= 255)

			cKey := Chr(key)

			if (get:type == "N" .and. (cKey == "." .or. cKey == ","))
				/*
				IF ('- ' $ get:Buffer).OR.('-0' $ get:Buffer)
					get:ToDecPos()
					get:Left()
					get:Left()
					get:Insert(CHR(45))
					get:Insert(CHR(48))
				ELSE
					get:ToDecPos()
				ENDIF
				*/
				get:ToDecPos()
			else
				if ( Set(_SET_INSERT) )
					get:Insert(cKey)
				else
					get:Overstrike(cKey)
				end

				if (get:typeOut .and. !Set(_SET_CONFIRM) )
					if ( Set(_SET_BELL) )
						?? Chr(7)
					end

					get:exitState := GE_ENTER
				end

			end

		end
	endcase
	//dispend()
return

****************************************
func GetPreValidate(get)
	local saveUpdated
	local when := .t.
	if ( get:preBlock <> NIL )
		saveUpdated := status:Updated
		when := Eval(get:preBlock, get)
		get:Display()
		ShowScoreBoard()
		status:Updated := saveUpdated
	end
	if ( status:KillRead )
		when := .f.
		get:exitState := GE_ESCAPE
	elseif ( !when )
		get:exitState := GE_WHEN
	else
		get:exitState := GE_NOEXIT
	end
return (when)


****************************************
func GetPostValidate(get)
	local saveUpdated
	local changed, valid := .t.
	if ( get:exitState == GE_ESCAPE )
	    return (.t.)
	end
	get:Reset()
	if ( get:BadDate() )
		get:Home()
		DateMsg()
		ShowScoreboard()
		return (.f.)
	end
	if ( get:changed )
		get:Assign()
		status:Updated := .t.
	end
	get:Reset()
	if ( get:postBlock <> NIL )
		saveUpdated := status:Updated
		SetPos( get:row, get:col + Len(get:buffer) )
		valid := Eval(get:postBlock, get)
		SetPos( get:row, get:col )
		ShowScoreBoard()
		get:UpdateBuffer()
		status:Updated := saveUpdated
		if ( status:KillRead )
			get:exitState := GE_ESCAPE  // вызвать выход из ReadModal()
			valid := .t.
		end
	end
return (valid)

****************************************
proc GetDoSetKey(keyBlock, get)
	local saveUpdated
	if ( get:changed )
		get:Assign()
		status:Updated := .t.
	end
	saveUpdated := status:Updated
	Eval(keyBlock, status:ReadProcName, status:ReadProcLine, ReadVar())
	ShowScoreboard()
	get:UpdateBuffer()
	status:Updated := saveUpdated
	if ( status:KillRead )
	     get:exitState := GE_ESCAPE    // вызвать выход из ReadModal()
	end
return

****************************************
static func Settle(GetList, pos)
	local exitState
	status:LastPos := pos
	if ( pos == 0 )
		exitState := GE_DOWN
	else
		exitState := GetList[pos]:exitState
	end
	if ( exitState == GE_ESCAPE .or. exitState == GE_WRITE )
	    return ( 0 )
	end
	if ( exitState <> GE_WHEN )
		status:LastPos := pos
		status:BumpTop := .f.
		status:BumpBot := .f.

	else
		exitState := status:LastExit
	end
	do case
	case ( exitState == GE_UP )
		pos --
	case ( exitState == GE_DOWN )
		pos ++
	case ( exitState == GE_TOP )
		pos := 1
		status:BumpTop := .T.
		exitState := GE_DOWN
	case ( exitState == GE_BOTTOM )
		pos := Len(GetList)
		status:BumpBot := .T.
		exitState := GE_UP
	case ( exitState == GE_ENTER )
		pos ++
	endcase

	if ( pos == 0 )             // слишком резко вверх
		if ( !ReadExit() .and. !status:BumpBot )
			status:BumpTop := .T.
			pos := status:LastPos
			exitState := GE_DOWN
		end
	elseif ( pos == Len(GetList) + 1 )    // слишком резко вниз
		if ( !ReadExit() .and. exitState <> GE_ENTER .and. !status:BumpTop )
			status:BumpBot := .T.
			pos := status:LastPos
			exitState := GE_UP
		else
			pos := 0
		end
	end
	status:LastExit := exitState
	if ( pos <> 0 )
		GetList[pos]:exitState := exitState
	end
return (pos)



****************************************
static proc PostActiveGet(get)
	GetActive( get )
	ReadVar( GetReadVar(get) )
	ShowScoreBoard()
return



****************************************
static func ClearGetSysVars()
	local saved:=map()

	saved:=clone(status)
	saved:readVar:= ReadVar( "" )

	status:KillRead := .f.
	status:BumpTop := .f.
	status:BumpBot := .f.
	status:LastExit := 0
	status:LastPos := 0
	status:ReadProcName := ""
	status:ReadProcLine := 0
	status:Updated := .f.
	status:countgets:=0
return (saved)

****************************************
static func SaveGetSysVars()
	local saved:=map()
	saved:=clone(status)
return (saved)

****************************************
static proc RestoreGetSysVars(saved)
	local up:=status:updated
	status:=clone(saved)
	GetActive( saved:ActiveGet )
	ReadVar( saved:readVar )
	status:updated:=up
return

****************************************
static func GetReadVar(get)
	local name := Upper(get:name)
	local i
	if ( get:subscript <> NIL )
		for i := 1 to len(get:subscript)
			name += "[" + ltrim(str(get:subscript[i])) + "]"
		next
	end
return (name)


****************************************
func __SetFormat(b)
	status:Format := if ( ValType(b) == "B", b, NIL )
return (NIL)


****************************************
proc __KillRead()
	status:KillRead := .t.
return


****************************************
func GetActive(g)
local oldActive := status:ActiveGet
	if ( PCount() > 0 )
		status:ActiveGet := g
	end
return ( oldActive )


****************************************
func Updated()
return (status:Updated)

****************************************
func ReadExit(lNew)
return ( Set(_SET_EXIT, lNew) )


****************************************
func ReadInsert(lNew)
return ( Set(_SET_INSERT, lNew) )


****************************************
static proc ShowScoreboard()
    local nRow, nCol
    if ( Set(_SET_SCOREBOARD) )
	nRow := Row()
	nCol := Col()
	SetPos(SCORE_ROW, SCORE_COL)
	DispOut( if(Set(_SET_INSERT), MSG_INSERT, MSG_OVERWRITE) )  // "Ins","   "
	SetPos(nRow, nCol)
     end
return

****************************************
static proc DateMsg()
    local nRow, nCol
    if ( Set(_SET_SCOREBOARD) )
      nRow := Row()
      nCol := Col()

      SetPos(SCORE_ROW, SCORE_COL)
      DispOut(MSG_DATE_ERROR)
	  SetPos(nRow, nCol)

      while ( Nextkey() == 0 )
	    sleep(0.1)
      end

      SetPos(SCORE_ROW, SCORE_COL)
      DispOut("            ")
      SetPos(nRow, nCol)
   end

return

****************************************
func RangeCheck(get, junk, lo, hi)

   local cMsg, nRow, nCol
   local xValue
   if ( !get:changed )
	return (.t.)
   end
   xValue := get:VarGet()
   if ( xValue >= lo .and. xValue <= hi )
	    return (.t.)
   end
   if ( Set(_SET_SCOREBOARD) )
	 cMsg := MSG_RANGE_ERROR + Ltrim(Transform(lo, "")) + ;
		" - " + Ltrim(Transform(hi, ""))
	if ( Len(cMsg) > MaxCol() )
		cMsg := Substr( cMsg, 1, MaxCol() )
	end
	nRow := Row()
	nCol := Col()
	SetPos( SCORE_ROW, Min(60, MaxCol() - Len(cMsg)) )
	DispOut(cMsg)
	SetPos(nRow, nCol)

	while ( NextKey() == 0 )
	      sleep(0.1)
	end

	SetPos( SCORE_ROW, Min(60, MaxCol() - Len(cMsg)) )
	DispOut( Space(Len(cMsg)) )
	SetPos(nRow, nCol)
   end
return (.f.)
****************************************
init procedure getSysInit()
   if status != NIL
      return
   endif
   __getSysInit()
return
****************************************
static function __getSysInit()
   if status != NIL
      return
   endif
   status:=map()
   status:Format:=NIL
   status:Updated := .f.
   status:KillRead := .f.
   status:BumpTop:=NIL
   status:BumpBot:=NIL
   status:LastExit:=NIL
   status:LastPos:=NIL
   status:ActiveGet:=NIL
   status:ReadProcName:=NIL
   status:ReadProcLine:=NIL
return

****************************************
function countGets
return len(__getList)

****************************************
function currentGet
return status:currentGet

****************************************
function getFldCol(num)
  num=iif(num==NIL,status:currentGet,num)
  if num>0 .and. num<=len(__getList)
	return  __getList[num]:col
  endif
return -1

****************************************
function getFldRow(num)
  num=iif(num==NIL,status:currentGet,num)
  if num>0 .and. num<=len(__getList)
	return  __getList[num]:row
  endif
return -1

****************************************
function getFldVar(num)
  num=iif(num==NIL,status:currentGet,num)
  if num>0 .and. num<=len(__getList)
	return  __getList[num]:name
  endif
return ""

****************************************
function saveGets
return status

****************************************
function restGets(obj)
return RestoreGetSysVars(obj)

