/*
    Copyright (C) 1998-2002 Yevgen Bondar <elb@lg.bank.gov.ua>
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
LOCAL	gCode, cMessage, nLine, cArgs,i
IF VALTYPE(e)<>'O'
/*
	cMessage:='e='+FT_XTOY(e, 'C')
	i:=2
	WHILE !EMPTY(ProcName(i))
		cMessage += _CRLF+Procname(i)+' '+NTRIM(ProcLine(i))
		i++
	END
	SET ALTE TO Errlog.txt ADDI
	SET ALTE ON
	? cMessage

	SET ALTE OFF
*/
	outlog(__FILE__,__LINE__,e)
	i := 1
	while ( !Empty(ProcName(i)) )
		outlog("Called from", Trim(ProcName(i)) + ;
			"(" + NTRIM(ProcLine(i)) + ")  ")

		i++
	end
	NFIND('В DefError передан не объект')
	QUIT
ENDIF
gCode:=e:genCode
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
/*
ELSEIF gCode == EG_NOFUNC
	IF EMPTY(e:args)
		cArgs:=')'
	ELSE
		cArgs:=Arr2Str(e:args)
		cArgs:=','+SUBSTR(cArgs,2,LEN(cArgs)-2)+')'
	ENDIF
	cMessage:=e:operation
	IF TYPE(cMessage)=='B'
		RETU &('Eval('+cMessage+cArgs)
	ELSE
		cMessage+='.INI'
		IF FileOnPath(@cMessage)
			RETU &('RestoreIni("'+cMessage+'"' + cArgs)
		ENDIF
	ENDIF
*/
ELSE
	cMessage:=e:description+' '+e:operation+' '+e:filename
	IF TYPE('_nLines')=='N'	THEN nLine:=m->_nLines	//in ini-file
	nLine:=IF(EMPTY(nLine),;
		  IF(Procname(2)=='MYREPL','RECNO(): '+NTRIM(RECNO()),''),;
		  m->_ini+' Line: '+NTRIM(nLine))
	nLine:=NFIND(cMessage,,,nLine)

	DO CASE
		CASE nLine==K_ALT_C .OR. nLine==K_ALT_X
			QUIT
		CASE nLine==K_ALT_G
			CalcExpr()
		CASE nLine==K_ALT_E
*
* При отладке - более подробно
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
	ENDCASE
	SELE 1
	IF Type('_tmr')=='N' .AND. USED() THEN go m->_tmr
END
BREAK(gCode)
**********
