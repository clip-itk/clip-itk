#include "set.ch"
#include "mysql.ch"

FUNCTION MS2CLIP(rowset,fieldno)
	LOCAL type := SQLFieldTypeSQL(rowset,fieldno)
	LOCAL data := SQLGetValue(rowset,fieldno)
	LOCAL dec := SET(_SET_DECIMALS)

	IF data == NIL
		RETURN NIL
	ENDIF

	DO CASE
		CASE type==MST_DECIMAL;
			.OR. type==MST_FLOAT;
			.OR. type==MST_DOUBLE
			RETURN FLOATVAL(data,SQLFieldLen(rowset,fieldno),;
				SQLFieldDec(rowset,fieldno))
		CASE type==MST_TINY;
			.OR. type==MST_SHORT;
			.OR. type==MST_INT24;
			.OR. type==MST_LONG;
			.OR. type==MST_LONGLONG;
			.OR. type==MST_YEAR
			RETURN VAL(data)
		CASE type==MST_TIMESTAMP
			RETURN MS_IN_TIMESTAMP(data)
		CASE type==MST_DATE;
			.OR. type==MST_DATETIME
			RETURN MS_IN_DATE(data)
		CASE type==MST_TIME
			RETURN {NUMNO(data,1),NUMNO(data,2),NUMNO(data,3)}
		CASE type==MST_ENUM;
			.OR. type==MST_SET;
			.OR. type==MST_TINY_BLOB;
			.OR. type==MST_MEDIUM_BLOB;
			.OR. type==MST_LONG_BLOB;
			.OR. type==MST_BLOB;
			.OR. type==MST_VAR_STRING;
			.OR. type==MST_STRING
			RETURN data
	ENDCASE
RETURN

FUNCTION CLIP2MS(rowset,fieldno,value,totext)
	LOCAL type := SQLFieldTypeSQL(rowset,fieldno)
	LOCAL dec := SET(_SET_DECIMALS)

	IF value == NIL
		RETURN NIL
	ENDIF

	DO CASE
		CASE type==MST_DECIMAL;
			.OR. type==MST_FLOAT;
			.OR. type==MST_DOUBLE
			RETURN STR(value,0,dec)
		CASE type==MST_TINY;
			.OR. type==MST_SHORT;
			.OR. type==MST_INT24;
			.OR. type==MST_LONG;
			.OR. type==MST_LONGLONG;
			.OR. type==MST_YEAR
			RETURN STR(value)
		CASE type==MST_TIMESTAMP
			RETURN STRZERO(YEAR(value),4,0)+STRZERO(MONTH(value),2,0)+;
				STRZERO(DAY(value),2,0)
		CASE type==MST_DATE;
			.OR. type==MST_DATETIME
			RETURN STRZERO(YEAR(value),4,0)+"-"+;
				STRZERO(MONTH(value),2,0)+"-"+;
				STRZERO(DAY(value),2,0)
		CASE type==MST_TIME
			RETURN STRZERO(value[1],2,0)+":"+;
				STRZERO(value[2],2,0)+":"+;
				STRZERO(value[3],2,0)
		CASE type==MST_ENUM;
			.OR. type==MST_SET;
			.OR. type==MST_TINY_BLOB;
			.OR. type==MST_MEDIUM_BLOB;
			.OR. type==MST_LONG_BLOB;
			.OR. type==MST_BLOB;
			.OR. type==MST_VAR_STRING;
			.OR. type==MST_STRING
			IF totext
				RETURN ADDSLASH(value)
			ENDIF
			RETURN value
	ENDCASE
RETURN
