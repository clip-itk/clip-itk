/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "error.ch"
#include "inkey.ch"

**********
FUNC ErrorSys(lMini)
RETU ErrorBlock( IF(EMPTY(lMini),{|e| DefError(e)},;
				 {|e| BREAK(e)} ) )
**********
FUNC DefError(e)
LOCAL	gCode, cMessage, cOp, nLine, cArgs
IF VALTYPE(e)<>'O'
        cMessage:=[Not object in DefError]
	NFIND(cMessage)
	WriteLog(cMessage)
	QUIT
ENDIF
gCode:=e:genCode
cOp:=e:operation
// division by zero yields zero
IF gCode == EG_ZERODIV THEN RETURN 0
SET(_SET_DEVICE,"SCREEN")
IF gCode == EG_PRINT
	IF Continue(NOT_READY)
		SET DEVI TO PRINT
		RETU .t.
	ENDIF
ELSEIF ( gCode == EG_OPEN .AND. e:osCode == 32 .AND. e:canDefault )
	NFIND(NET_ERR)
	NetErr(.t.)
ELSEIF ( gCode=EG_CORRUPTION )
	MakeRealStr()

ELSEIF gCode == EG_NOFUNC
	IF EMPTY(e:args)
		cArgs:=')'
	ELSE
		cArgs:=Arr2Str(e:args)
		cArgs:=','+SUBSTR(cArgs,2,LEN(cArgs)-2)+')'
	ENDIF
	cMessage:=cOp+'.INI'
	IF FileOnPath(@cMessage)
		RETU &('RestoreIni("'+cMessage+'"' + cArgs)
	ELSE
		cMessage:=cOp+'.po'
		IF FileOnPath(@cMessage)
			Load(cMessage)
			IF First(cArgs)==',' THEN cArgs:=SUBSTR(cArgs, 2)
			RETU &(cOp+'(' + cArgs)
		ENDIF
	ENDIF
ENDIF

cMessage:=e:description+' '+cOp+' '+e:filename
IF TYPE('_nLines')=='N'	THEN nLine:=m->_nLines	//in ini-file
nLine:=IF(EMPTY(nLine),;
		  IF(Procname(2)=='MYREPL','RECNO(): '+NTRIM(RECNO()),''),;
		  m->_ini+' Line: '+NTRIM(nLine))
nLine:=NFIND(Exclude(cMessage, 'E_COMPILED'),,,nLine)

DO CASE
	CASE nLine==K_ALT_C .OR. nLine==K_ALT_X
		MakeRealStr()
		QUIT
	CASE nLine==K_ALT_G
		CalcExpr()
	CASE nLine==K_ALT_E
		WriteLog(cMessage)
ENDCASE
SELE 1
IF Type('_tmr')=='N' .AND. USED() THEN go m->_tmr

BREAK(gCode)
**********
STATIC PROC WriteLog(cMessage)
* When debugging - more detail
LOCAL i
cMessage:=_CRLF+DTOC(date())+' '+TIME()+_CRLF+cMessage
i:=2
WHILE !EMPTY(ProcName(i))
	cMessage += _CRLF+Procname(i)+' '+NTRIM(ProcLine(i))
	i++
END
SET ALTE TO Errlog.txt ADDI
SET ALTE ON
? cMessage

SET ALTE OFF
