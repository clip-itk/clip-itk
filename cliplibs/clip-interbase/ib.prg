#include "set.ch"
#include "interbase.ch"

FUNCTION IB2CLIP(rowset,fieldno)
	LOCAL type := SQLFieldType(rowset,fieldno)
	LOCAL data := SQLGetValue(rowset,fieldno)
	LOCAL dec := SQLFieldDec(rowset,fieldno)
	LOCAL sd := SET(_SET_DECIMALS)

	IF data == NIL
		RETURN NIL
	ENDIF

	SWITCH(type)
		CASE IBT_TEXT
			RETURN data
		CASE IBT_INT64
			RETURN SQLSetLenDec(IB_IN_INT64(data)/(10^dec),0,dec)
		CASE IBT_LONG
			RETURN SQLSetLenDec(IB_IN_LONG(data)/(10^dec),0,dec)
		CASE IBT_SHORT
			RETURN SQLSetLenDec(IB_IN_SHORT(data)/(10^dec),0,dec)
		CASE IBT_FLOAT
			RETURN SQLSetLenDec(IB_IN_FLOAT(data),0,sd)
		CASE IBT_DOUBLE
			RETURN SQLSetLenDec(IB_IN_DOUBLE(data),0,sd)
		CASE IBT_TYPE_DATE
			RETURN IB_IN_DATE(data)
		CASE IBT_TYPE_TIME
			RETURN IB_IN_TIME(data)
		CASE IBT_TIMESTAMP
			RETURN IB_IN_DATETIME(data)
		CASE IBT_VARYING
			RETURN IB_IN_VARYING(data)
		CASE IBT_BLOB
			RETURN data
		CASE IBT_ARRAY
			RETURN IB_IN_ARRAY(rowset,data,fieldno)
	ENDSWITCH
RETURN

FUNCTION CLIP2IB(rowset,fieldno,value,totext)
	LOCAL type := SQLFieldType(rowset,fieldno)
	LOCAL dec := SQLFieldDec(rowset,fieldno)

	IF value == NIL
		RETURN NIL
	ENDIF

	IF totext .AND. type != IBT_ARRAY
		RETURN value
	ENDIF

	SWITCH(type)
		CASE IBT_TEXT
			RETURN value
		CASE IBT_INT64
			RETURN IB_OUT_INT64(value*(10^dec))
		CASE IBT_LONG
			RETURN IB_OUT_LONG(value*(10^dec))
		CASE IBT_SHORT
			RETURN IB_OUT_SHORT(value*(10^dec))
		CASE IBT_FLOAT
			RETURN IB_OUT_FLOAT(value)
		CASE IBT_DOUBLE
			RETURN IB_OUT_DOUBLE(value)
		CASE IBT_TYPE_DATE
			RETURN IB_OUT_DATE(value)
		CASE IBT_TYPE_TIME
			RETURN IB_OUT_TIME(value)
		CASE IBT_TIMESTAMP
			RETURN IB_OUT_DATETIME(value)
		CASE IBT_VARYING
			RETURN IB_OUT_SHORT(LEN(value))+value
		CASE IBT_BLOB
			RETURN value
		CASE IBT_ARRAY
			RETURN IB_OUT_ARRAY(rowset,value,fieldno)
	ENDSWITCH
RETURN
