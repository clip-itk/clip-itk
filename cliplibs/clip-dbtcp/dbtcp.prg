#include "set.ch"

FUNCTION DBTCP2CLIP(rowset,fieldno)
	LOCAL type := SQLFieldTypeSQL(rowset,fieldno)
	LOCAL data := SQLGetValue(rowset,fieldno)
	LOCAL dec := SET(_SET_DECIMALS)
	LOCAL ret := NIL

	IF data == NIL
		RETURN NIL
	ENDIF

	SWITCH CHR(type)
		CASE 'N'
			ret := VAL(data)
		CASE 'C'
			ret := data
		CASE 'd'
			IF !EMPTY(data)
				ret := STOT(data)
			ENDIF
		CASE 'D'
			IF !EMPTY(data)
				ret := CTOT(data)
			ENDIF
		OTHERWISE
			ret := NIL
	ENDSWITCH

RETURN ret

FUNCTION CLIP2DBTCP(rowset,fieldno,value,totext)
	LOCAL type := SQLFieldTypeSQL(rowset,fieldno)

	IF value == NIL
		RETURN NIL
	ENDIF

	SWITCH CHR(type)
		CASE 'N'
			ret := STR(value)
		CASE 'C'
			IF totext
				ret := ADDSLASH(value)
			ELSE
				ret := value
			ENDIF
		CASE 'd'
			ret := TTOS(value)
		CASE 'D'
			ret := DTOC(value,"yyyy-mm-dd")
		OTHERWISE
			ret := NIL
	ENDSWITCH
RETURN ret
