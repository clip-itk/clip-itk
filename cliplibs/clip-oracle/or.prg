#include "set.ch"
#include "oracle.ch"

FUNCTION OR2CLIP(rowset,fieldno)
	LOCAL type := SQLFieldTypeSQL(rowset,fieldno)
	LOCAL data := SQLGetValue(rowset,fieldno)
	LOCAL dec := SET(_SET_DECIMALS)

	IF data == NIL
		RETURN NIL
	ENDIF

	DO CASE
	CASE type==2
		RETURN OR_IN_DOUBLE(data,SQLFieldDec(rowset,fieldno))
		CASE type==12
		RETURN OR_IN_DATE(data)
//		CASE type==104
//        	RETURN OR_IN_ROWID(data)
	OTHERWISE
		RETURN data
	END CASE
RETURN

FUNCTION CLIP2OR(rowset,fieldno,value)
	LOCAL type := SQLFieldTypeSQL(rowset,fieldno)
	LOCAL dec := SET(_SET_DECIMALS)

	IF value == NIL
		RETURN NIL
	ENDIF

RETURN value
