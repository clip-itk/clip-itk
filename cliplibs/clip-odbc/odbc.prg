#include "set.ch"
#include "odbc.ch"

FUNCTION ODBC2CLIP(rowset,fieldno)
	LOCAL type := SQLFieldTypeSQL(rowset,fieldno)
	LOCAL data := SQLGetValue(rowset,fieldno)
	LOCAL len := SQLFieldLen(rowset,fieldno)
	LOCAL dec := SQLFieldDec(rowset,fieldno)
	LOCAL nullable := SQLFieldNullable(rowset,fieldno)
	LOCAL unsigned := SQLFieldUnsigned(rowset,fieldno)

	IF data == NIL .AND. nullable
		RETURN NIL
	ENDIF

	SWITCH type
		CASE SQL_TINYINT
			IF data == NIL
				RETURN 0
			ENDIF
			IF unsigned
				RETURN SQLSetLenDec(ASC(data),len,dec)
			ELSE
				RETURN SQLSetLenDec(BIN2B(data),len,dec)
			ENDIF
		CASE SQL_SMALLINT
			IF data == NIL
				RETURN 0
			ENDIF
			IF unsigned
				RETURN SQLSetLenDec(BIN2W(data),len,dec)
			ELSE
				RETURN SQLSetLenDec(BIN2I(data),len,dec)
			ENDIF
		CASE SQL_INTEGER
			IF data == NIL
				RETURN 0
			ENDIF
			IF unsigned
				RETURN SQLSetLenDec(BIN2DW(data),len,dec)
			ELSE
				RETURN SQLSetLenDec(BIN2L(data),len,dec)
			ENDIF
		CASE SQL_BIGINT, SQL_DECIMAL
			IF data == NIL
				RETURN 0
			ENDIF
			RETURN SQLSetLenDec(VAL(data),len,dec)
		CASE SQL_DOUBLE, SQL_NUMERIC
			IF data == NIL
				RETURN 0
			ENDIF
			IF dec == 0
				dec := SET(_SET_DECIMALS)
			ENDIF
			RETURN SQLSetLenDec(ODBC_IN_DOUBLE(data),len,dec)
		CASE SQL_FLOAT, SQL_REAL
			IF data == NIL
				RETURN 0
			ENDIF
			IF dec == 0
				dec := SET(_SET_DECIMALS)
			ENDIF
			RETURN SQLSetLenDec(ODBC_IN_FLOAT(data),len,dec)
		CASE SQL_CHAR, SQL_VARCHAR, SQL_LONGVARCHAR
			IF data == NIL
				RETURN ""
			ENDIF
			RETURN data
		CASE SQL_DATE
			IF data == NIL
				RETURN STOD("        ")
			ENDIF
			RETURN ODBC_IN_DATE(data)
		CASE SQL_TIME
			IF data == NIL
				RETURN "00:00:00"
			ENDIF
			RETURN ODBC_IN_TIME(data)
		CASE SQL_TIMESTAMP
			IF data == NIL
				RETURN CTOT("00:00")
			ENDIF
			RETURN ODBC_IN_TIMESTAMP(data)
		CASE SQL_LONGVARBINARY
			IF data == NIL
				RETURN ""
			ENDIF
			RETURN ODBC_IN_BLOB(data)
		OTHERWISE
			OUTLOG("ODBC type not implemented : "+ALLTRIM(STR(type)))
	ENDSWITCH
RETURN NIL

FUNCTION CLIP2ODBC(rowset,fieldno,value,totext)
	LOCAL type := SQLFieldTypeSQL(rowset,fieldno)
	LOCAL nullable := SQLFieldNullable(rowset,fieldno)
	LOCAL len := SQLFieldLen(rowset,fieldno)
	LOCAL dec := SQLFieldDec(rowset,fieldno)

	IF value == NIL .AND. nullable
		RETURN IIF(totext,"null",NIL)
	ENDIF

	SWITCH type
		CASE SQL_TINYINT
			IF value == NIL
				RETURN IIF(totext,"0",CHR(0))
			ENDIF
			RETURN IIF(totext,ALLTRIM(STR(value)),CHR(value))
		CASE SQL_SMALLINT
			IF value == NIL
				RETURN IIF(totext,"0",CHR(0)+CHR(0))
			ENDIF
			RETURN IIF(totext,ALLTRIM(STR(value)),I2BIN(value))
		CASE SQL_INTEGER
			IF value == NIL
				RETURN IIF(totext,"0",REPLICATE(CHR(0),4))
			ENDIF
			RETURN IIF(totext,ALLTRIM(STR(value)),L2BIN(value))
		CASE SQL_BIGINT,SQL_DECIMAL
			IF value == NIL
				RETURN ALLTRIM(STR(0,len,dec))
			ENDIF
			RETURN ALLTRIM(STR(value,len,dec))
		CASE SQL_DOUBLE, SQL_NUMERIC
			IF value == NIL
				RETURN IIF(totext,"0",REPLICATE(CHR(0),8))
			ENDIF
			IF dec == 0
				dec := SET(_SET_DECIMALS)
			ENDIF
			RETURN IIF(totext,ALLTRIM(STR(value,len,dec)),ODBC_OUT_DOUBLE(value))
		CASE SQL_FLOAT, SQL_REAL
			IF value == NIL
				RETURN IIF(totext,"0",REPLICATE(CHR(0),4))
			ENDIF
			IF dec == 0
				dec := SET(_SET_DECIMALS)
			ENDIF
			RETURN IIF(totext,ALLTRIM(STR(value,len,dec)),ODBC_OUT_FLOAT(value))
		CASE SQL_CHAR, SQL_VARCHAR, SQL_LONGVARCHAR
			IF value == NIL
				RETURN ""
			ENDIF
			IF totext
				RETURN ADDSLASH(value)
			ENDIF
			RETURN value
		CASE SQL_DATE
			IF value == NIL
				RETURN IIF(totext,"0000-00-00",ODBC_OUT_DATE(value))
			ENDIF
			RETURN IIF(totext,STR(YEAR(value),4)+"-"+STR(MONTH(value),2)+;
				"-"+STR(DAY(value),2),ODBC_OUT_DATE(value))
		CASE SQL_TIME
			IF value == NIL
				RETURN IIF(totext,"00:00:00",ODBC_OUT_TIME(value))
			ENDIF
			RETURN IIF(totext,value,ODBC_OUT_TIME(value))
		CASE SQL_TIMESTAMP
			IF value == NIL
				RETURN IIF(totext,"",REPLICATE(CHR(0),8))
			ENDIF
			RETURN IIF(totext,TTOS(value),ODBC_OUT_TIMESTAMP(value))
		CASE SQL_LONGVARBINARY
			IF value == NIL
				RETURN ""
			ENDIF
			RETURN IIF(totext,value,ODBC_OUT_BLOB(value))
		OTHERWISE
			OUTLOG("ODBC type not implemented : "+ALLTRIM(STR(type)))
	ENDSWITCH
RETURN ""
