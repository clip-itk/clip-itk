#include "set.ch"
#include "postgres.ch"


FUNCTION PG2CLIP(rowset,fieldno)
	LOCAL type := SQLFieldType(rowset,fieldno)
	LOCAL data := SQLGetValue(rowset,fieldno)
	LOCAL dec := SET(_SET_DECIMALS)
	LOCAL ar
	LOCAL tmp
	LOCAL I,J,K

	IF data == NIL
		RETURN NIL
	ENDIF

	SWITCH (type)
		CASE PGT_INT4,PGT_CID,PGT_OID,PGT_XID
			RETURN PG_IN_INT4(rowset,data)
		CASE PGT_INT2
			RETURN PG_IN_INT2(rowset,data)
		CASE PGT_MONEY
			IF PG_ISBINARY(rowset)
				RETURN SQLSetlendec(PG_IN_INT4(rowset,data)/100,11,2)
			ELSE
				data := STRTRAN(STRTRAN(data,"$",""),",","")
				RETURN VAL(data)
			ENDIF
		CASE PGT_INT8
			RETURN PG_IN_INT8(rowset,data)
		CASE PGT_INT28
			IF PG_ISBINARY(rowset)
				RETURN {PG_IN_INT2(rowset,SUBSTR(data,1,2)),;
					PG_IN_INT2(rowset,SUBSTR(data,3,2)),;
					PG_IN_INT2(rowset,SUBSTR(data,5,2)),;
					PG_IN_INT2(rowset,SUBSTR(data,7,2)),;
					PG_IN_INT2(rowset,SUBSTR(data,9,2)),;
					PG_IN_INT2(rowset,SUBSTR(data,11,2)),;
					PG_IN_INT2(rowset,SUBSTR(data,13,2)),;
					PG_IN_INT2(rowset,SUBSTR(data,15,2))}
			ELSE
				RETURN {PG_IN_INT2(rowset,NUMNO(data,1)),;
					PG_IN_INT2(rowset,NUMNO(data,2)),;
					PG_IN_INT2(rowset,NUMNO(data,3)),;
					PG_IN_INT2(rowset,NUMNO(data,4)),;
					PG_IN_INT2(rowset,NUMNO(data,5)),;
					PG_IN_INT2(rowset,NUMNO(data,6)),;
					PG_IN_INT2(rowset,NUMNO(data,7)),;
					PG_IN_INT2(rowset,NUMNO(data,8))}
			ENDIF
		CASE PGT_FLOAT4
			RETURN PG_IN_FLOAT(rowset,data,dec)
		CASE PGT_FLOAT8
			RETURN PG_IN_DOUBLE(rowset,data,dec)
		CASE PGT_NUMERIC
			IF PG_ISBINARY(rowset)
				tmp := BIN2B(SUBSTR(data,1,1))
				dec := BIN2B(SUBSTR(data,3,1))
				J := 0
				K := LEN(data)-6
				FOR I:=1 TO K
					J += INT(ASC(SUBSTR(data,I+6,1))/16)*(10**tmp)
					J += INT(ASC(SUBSTR(data,I+6,1))%16)*(10**(tmp-1))
					tmp -= 2
				NEXT
				J := SQLSetlendec(J,0,dec)
				RETURN IF(ASC(SUBSTR(data,6,1))==64,-J,J)
			ELSE
				RETURN VAL(data)
			ENDIF
		CASE PGT_OID8
			IF PG_ISBINARY(rowset)
				RETURN {PG_IN_INT4(rowset,SUBSTR(data,1,4)),;
					PG_IN_INT4(rowset,SUBSTR(data,5,4)),;
					PG_IN_INT4(rowset,SUBSTR(data,9,4)),;
					PG_IN_INT4(rowset,SUBSTR(data,13,4)),;
					PG_IN_INT4(rowset,SUBSTR(data,17,4)),;
					PG_IN_INT4(rowset,SUBSTR(data,21,4)),;
					PG_IN_INT4(rowset,SUBSTR(data,25,4)),;
					PG_IN_INT4(rowset,SUBSTR(data,29,4))}
			ELSE
				RETURN {PG_IN_INT4(rowset,NUMNO(data,1)),;
					PG_IN_INT4(rowset,NUMNO(data,2)),;
					PG_IN_INT4(rowset,NUMNO(data,3)),;
					PG_IN_INT4(rowset,NUMNO(data,4)),;
					PG_IN_INT4(rowset,NUMNO(data,5)),;
					PG_IN_INT4(rowset,NUMNO(data,6)),;
					PG_IN_INT4(rowset,NUMNO(data,7)),;
					PG_IN_INT4(rowset,NUMNO(data,8))}
			ENDIF
		CASE PGT_VARCHAR,PGT_TEXT,PGT_BYTEA,PGT_CHAR
			RETURN data
		CASE PGT_FILENAME,PGT_NAME
			IF PG_ISBINARY(rowset)
				IF (tmp := AT(CHR(0),data)) > 0
					RETURN SUBSTR(data,1,tmp-1)
				ELSE
					RETURN data
				ENDIF
			ELSE
				RETURN data
			ENDIF
		CASE PGT_ABSTIME
			RETURN PG_IN_ABSTIME(rowset,data)
		CASE PGT_TIMESTAMP
			RETURN PG_IN_TIMESTAMP(rowset,data)
		CASE PGT_DATE
			RETURN PG_IN_DATE(rowset,data)
		CASE PGT_DATETIME
			RETURN PG_IN_DATETIME(rowset,data)
		CASE PGT_BOOL
			RETURN IF(SUBSTR(data,1,1)=="t" .OR.;
				SUBSTR(data,1,1)==CHR(1),.T.,.F.)
		CASE PGT_POINT
			IF PG_ISBINARY(rowset)
				RETURN {PG_IN_DOUBLE(rowset,SUBSTR(data,1,8),dec),;
					PG_IN_DOUBLE(rowset,SUBSTR(data,9,8),dec)}
			ELSE
				RETURN {PG_IN_DOUBLE(rowset,NUMNO(data,1),dec),;
					PG_IN_DOUBLE(rowset,NUMNO(data,2),dec)}
			ENDIF
		CASE PGT_BOX,PGT_LSEG
			IF PG_ISBINARY(rowset)
				RETURN {{PG_IN_DOUBLE(rowset,SUBSTR(data,1,8),dec),;
					PG_IN_DOUBLE(rowset,SUBSTR(data,9,8),dec)},;
					{PG_IN_DOUBLE(rowset,SUBSTR(data,17,8),dec),;
					PG_IN_DOUBLE(rowset,SUBSTR(data,25,8),dec)}}
			ELSE
				RETURN {{PG_IN_DOUBLE(rowset,NUMNO(data,1),dec),;
					PG_IN_DOUBLE(rowset,NUMNO(data,2),dec)},;
					{PG_IN_DOUBLE(rowset,NUMNO(data,3),dec),;
					PG_IN_DOUBLE(rowset,NUMNO(data,4),dec)}}
			ENDIF
		CASE PGT_CIDR
			IF PG_ISBINARY(rowset)
				tmp := ASC(SUBSTR(data,2,1))/8
				ar := ARRAY(tmp)
				FOR I:=1 TO tmp
					ar[I] := ASC(SUBSTR(data,4+I,1))
				NEXT
			ELSE
				data := STRTRAN(data,".",",")
				I := VAL(NUMNO(data,-1))/8
				ar := ARRAY(I)
				FOR J:=1 TO I
					ar[J] := VAL(NUMNO(data,J))
				NEXT
			ENDIF
			RETURN ar
		CASE PGT_CIRCLE
			IF PG_ISBINARY(rowset)
				RETURN {PG_IN_DOUBLE(rowset,SUBSTR(data,1,8),dec),;
					PG_IN_DOUBLE(rowset,SUBSTR(data,9,8),dec),;
					PG_IN_DOUBLE(rowset,SUBSTR(data,17,8),dec)}
			ELSE
				RETURN {PG_IN_DOUBLE(rowset,NUMNO(data,1),dec),;
					PG_IN_DOUBLE(rowset,NUMNO(data,2),dec),;
					PG_IN_DOUBLE(rowset,NUMNO(data,3),dec)}
			ENDIF
		CASE PGT_PATH
			IF PG_ISBINARY(rowset)
				tmp := PG_IN_INT4(rowset,SUBSTR(data,1,4))
				ar := ARRAY(tmp)
				FOR I:=1 TO tmp
					ar[I] := {PG_IN_DOUBLE(rowset,SUBSTR(data,-3+I*16,8),dec),;
						PG_IN_DOUBLE(rowset,SUBSTR(data,5+I*16,8),dec)}
				NEXT
			ELSE
				I := 1; ar := ARRAY(0)
				DO WHILE (tmp:=NUMNO(data,I))!=NIL
					AADD(ar,{PG_IN_DOUBLE(rowset,tmp,dec),;
						PG_IN_DOUBLE(rowset,NUMNO(data,I+1),dec)})
					I += 2
				ENDDO
			ENDIF
			RETURN ar
		CASE PGT_POLYGON
			IF PG_ISBINARY(rowset)
				tmp := PG_IN_INT4(rowset,SUBSTR(data,1,4))
				ar := ARRAY(tmp)
				FOR I:=1 TO tmp
					ar[I] := {PG_IN_DOUBLE(rowset,SUBSTR(data,21+I*16,8),dec),;
						PG_IN_DOUBLE(rowset,SUBSTR(data,29+I*16,8),dec)}
				NEXT
			ELSE
				I := 1; ar := ARRAY(0)
				DO WHILE (tmp:=NUMNO(data,I))!=NIL
					AADD(ar,{PG_IN_DOUBLE(rowset,tmp,dec),;
						PG_IN_DOUBLE(rowset,NUMNO(data,I+1),dec)})
					I += 2
				ENDDO
			ENDIF
			RETURN ar
		CASE PGT_INET
			IF PG_ISBINARY(rowset)
				RETURN {ASC(SUBSTR(data,5,1)),ASC(SUBSTR(data,6,1)),;
					ASC(SUBSTR(data,7,1)),ASC(SUBSTR(data,8,1)),;
					ASC(SUBSTR(data,2,1))}
			ELSE
				data := STRTRAN(data,".",",")
				RETURN {VAL(NUMNO(data,1)),VAL(NUMNO(data,2)),;
					VAL(NUMNO(data,3)),VAL(NUMNO(data,4)),;
					IF(NUMNO(data,5)==NIL,VAL("32"),VAL(NUMNO(data,5)))}
			ENDIF
		CASE PGT_RELTIME
			IF PG_ISBINARY(rowset)
				RETURN PG_IN_INT4(rowset,data)
			ELSE
				RETURN VAL(NUMNO(data,-1))+VAL(NUMNO(data,-2))*60+;
					VAL(NUMNO(data,-3))*60*60+VAL(NUMNO(data,-4))*60*60*24+;
					VAL(NUMNO(data,-5))*60*60*24*30+;
					VAL(NUMNO(data,-6))*60*60*24*365
			ENDIF
		CASE PGT_TIME
			IF PG_ISBINARY(rowset)
				// To be implemented
			ELSE
				RETURN {VAL(NUMNO(data,1)),VAL(NUMNO(data,2)),VAL(NUMNO(data,3))}
			ENDIF
		CASE PGT_TIMESPAN
			IF PG_ISBINARY(rowset)
				// To be implemented
			ELSE
				RETURN VAL(NUMNO(data,-1))+VAL(NUMNO(data,-2))*60+;
					VAL(NUMNO(data,-3))*60*60+VAL(NUMNO(data,-4))*60*60*24
			ENDIF
	ENDSWITCH

RETURN

FUNCTION CLIP2PG(rowset,fieldno,value,totext)
	LOCAL type := SQLFieldType(rowset,fieldno)
	LOCAL dec := SET(_SET_DECIMALS)
	LOCAL I,J,res,tmp
	LOCAL year,mon,day,hour,min,sec

	IF value==NIL
		RETURN NIL
	ENDIF

	SWITCH (type)
		CASE PGT_CID,PGT_INT4,PGT_OID,PGT_XID
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_INT4(value)
			ELSE
				RETURN LTRIM(STR(value))
			ENDIF
		CASE PGT_INT2
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_INT2(value)
			ELSE
				RETURN LTRIM(STR(value))
			ENDIF
		CASE PGT_INT8
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_INT8(value)
			ELSE
				RETURN LTRIM(STR(value))
			ENDIF
		CASE PGT_INT28
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_INT2(value[1])+PG_OUT_INT2(value[2])+;
					PG_OUT_INT2(value[3])+PG_OUT_INT2(value[4])+;
					PG_OUT_INT2(value[5])+PG_OUT_INT2(value[6])+;
					PG_OUT_INT2(value[7])+PG_OUT_INT2(value[8])
			ELSE
				RETURN LTRIM(STR(value[1]))+" "+LTRIM(STR(value[2]))+" "+;
					LTRIM(STR(value[3]))+" "+LTRIM(STR(value[4]))+" "+;
					LTRIM(STR(value[5]))+" "+LTRIM(STR(value[6]))+" "+;
					LTRIM(STR(value[7]))+" "+LTRIM(STR(value[8]))
			ENDIF
		CASE PGT_OID8
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_INT4(value[1])+PG_OUT_INT4(value[2])+;
					PG_OUT_INT4(value[3])+PG_OUT_INT4(value[4])+;
					PG_OUT_INT4(value[5])+PG_OUT_INT4(value[6])+;
					PG_OUT_INT4(value[7])+PG_OUT_INT4(value[8])
			ELSE
				RETURN LTRIM(STR(value[1]))+" "+LTRIM(STR(value[2]))+" "+;
					LTRIM(STR(value[3]))+" "+LTRIM(STR(value[4]))+" "+;
					LTRIM(STR(value[5]))+" "+LTRIM(STR(value[6]))+" "+;
					LTRIM(STR(value[7]))+" "+LTRIM(STR(value[8]))
			ENDIF
		CASE PGT_FLOAT4
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_FLOAT(value)
			ELSE
				RETURN LTRIM(STR(value,0,dec))
			ENDIF
		CASE PGT_FLOAT8
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_DOUBLE(value)
			ELSE
				RETURN LTRIM(STR(value,0,dec))
			ENDIF
		CASE PGT_NUMERIC
			IF !totext .AND. PG_ISBINARY(rowset)
				tmp := STRTRAN(LTRIM(STR(value)),"-","")
				K := AT(".",tmp)
				dec := IF(K==0,0,LEN(tmp)-K)
				K := IF(K==0,LEN(tmp)-1,K-2)
				res := CHR(K)+CHR(0)+CHR(dec)+CHR(0)+CHR(dec)+;
					CHR(IF(value<0,64,0))
				tmp := STRTRAN(tmp,".","")
				tmp += IF(LEN(tmp)%2==1,"0","")
				I := 1
				DO WHILE I<LEN(tmp)
					K := VAL(SUBSTR(tmp,I,1))*16+VAL(SUBSTR(tmp,I+1,1))
					res += CHR(K)
					I += 2
				ENDDO
				RETURN res
			ELSE
				RETURN LTRIM(STR(value))
			ENDIF
		CASE PGT_MONEY
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_INT4(value*100)
			ELSE
				RETURN LTRIM(STR(value,0,2))
			ENDIF
		CASE PGT_ABSTIME
			RETURN PG_OUT_ABSTIME(rowset,value,totext)
		CASE PGT_DATE
			RETURN PG_OUT_DATE(rowset,value,totext)
		CASE PGT_DATETIME
			RETURN PG_OUT_DATETIME(rowset,value,totext)
		CASE PGT_RELTIME
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_INT4(rowset,value)
			ELSE
				year := INT(value/(60*60*24*365))
				value %= 60*60*24*365
				mon := INT(value/(60*60*24*30))
				value %= 60*60*24*30
				day := INT(value/(60*60*24))
				value %= 60*60*24
				hour := INT(value/(60*60))
				value %= 60*60
				min := INT(value/60)
				sec := value%60
				res := ""
				IF year>0;res += LTRIM(STR(year))+" year"
					res += IF(year==1," ","s ");ENDIF
				IF mon>0;res += LTRIM(STR(mon))+" mon"
					res += IF(mon==1," ","s ");ENDIF
				IF day>0;res += LTRIM(STR(day))+" day"
					res += IF(day==1," ","s ");ENDIF
				IF hour>0;res += LTRIM(STR(hour))+" hour"
					res += IF(hour==1," ","s ");ENDIF
				IF min>0;res += LTRIM(STR(min))+" min"
					res += IF(min==1," ","s ");ENDIF
				IF sec>0;res += LTRIM(STR(sec))+" sec"
					res += IF(sec==1," ","s ");ENDIF
				res := LEFT(res,LEN(res)-1)
				res += IF(LEN(res)==1," 0","")
				RETURN res
			ENDIF
		CASE PGT_TIME
			IF !totext .AND. PG_ISBINARY(rowset)
				// To be implemented
			ELSE
				RETURN STRZERO(value[1],2)+":"+STRZERO(value[2],2)+":"+;
					STRZERO(value[3],2)
			ENDIF
		CASE PGT_TIMESPAN
			IF !totext .AND. PG_ISBINARY(rowset)
				// To be implemented
			ELSE
				day := INT(value/(60*60*24))
				value %= 60*60*24
				hour := INT(value/(60*60))
				value %= 60*60
				min := INT(value/60)
				sec := value%60
				res := ""
				IF day>0;res += LTRIM(STR(day))+" day"
					res += IF(day==1," ","s ");ENDIF
				IF hour>0;res += LTRIM(STR(hour))+" hour"
					res += IF(hour==1," ","s ");ENDIF
				IF min>0;res += LTRIM(STR(min))+" min"
					res += IF(min==1," ","s ");ENDIF
				IF sec>0;res += LTRIM(STR(sec))+" sec"
					res += IF(sec==1," ","s ");ENDIF
				res := LEFT(res,LEN(res)-1)
				res += IF(LEN(res)==1," 0","")
				RETURN res
			ENDIF
		CASE PGT_TIMESTAMP
			RETURN PG_OUT_TIMESTAMP(rowset,value,totext)
		CASE PGT_BOOL
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN IF(value,CHR(1),CHR(0))
			ELSE
				RETURN IF(value,"t","f")
			ENDIF
		CASE PGT_VARCHAR,PGT_TEXT,PGT_BPCHAR,PGT_BYTEA,PGT_FILENAME,PGT_NAME
			RETURN value
		CASE PGT_BOX
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_DOUBLE(value[1][1])+PG_OUT_DOUBLE(value[1][2])+;
					PG_OUT_DOUBLE(value[2][1])+PG_OUT_DOUBLE(value[2][2])
			ELSE
				RETURN "("+LTRIM(STR(value[1][1]))+","+;
					LTRIM(STR(value[1][2]))+"),("+;
					LTRIM(STR(value[2][1]))+","+;
					LTRIM(STR(value[2][2]))+")"
			ENDIF
		CASE PGT_CIRCLE
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_DOUBLE(value[1])+PG_OUT_DOUBLE(value[2])+;
					 PG_OUT_DOUBLE(value[3])
			ELSE
				RETURN "<("+LTRIM(STR(value[1]))+","+LTRIM(STR(value[2]))+"),"+;
					LTRIM(STR(value[3]))+">"
			ENDIF
		CASE PGT_LSEG
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_DOUBLE(value[1][1])+PG_OUT_DOUBLE(value[1][2])+;
					PG_OUT_DOUBLE(value[2][1])+PG_OUT_DOUBLE(value[2][2])
			ELSE
				RETURN "[("+LTRIM(STR(value[1][1]))+","+;
					LTRIM(STR(value[1][2]))+"),"+;
					"("+LTRIM(STR(value[1][1]))+","+;
					LTRIM(STR(value[1][2]))+")]"
			ENDIF
		CASE PGT_PATH
			IF !totext .AND. PG_ISBINARY(rowset)
				res := PG_OUT_INT4(LEN(value)) + PG_OUT_DOUBLE(0)
				FOR I:=1 TO LEN(value)
					res += PG_OUT_DOUBLE(value[I][1])+PG_OUT_DOUBLE(value[I][2])
				NEXT
			ELSE
				res := "("
				FOR I:=1 TO LEN(value)
					res += "("+LTRIM(STR(value[I][1]))+","+;
					LTRIM(STR(value[I][2]))+"),"
				NEXT
				res := LEFT(res,LEN(res)-1)+")"
			ENDIF
			RETURN res
		CASE PGT_POINT
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN PG_OUT_DOUBLE(value[1])+PG_OUT_DOUBLE(value[2])
			ELSE
				RETURN "("+LTRIM(STR(value[1]))+","+LTRIM(STR(value[2]))+")"
			ENDIF
		CASE PGT_POLYGON
			IF !totext .AND. PG_ISBINARY(rowset)
				res := PG_OUT_INT4(LEN(value))+PG_OUT_DOUBLE(value[1][1])+;
					PG_OUT_DOUBLE(value[1][2])+PG_OUT_DOUBLE(value[LEN(value)][1])+;
					PG_OUT_DOUBLE(value[LEN(value)][2])
				FOR I:=1 TO LEN(value)
					res += PG_OUT_DOUBLE(value[I][1])+PG_OUT_DOUBLE(value[I][2])
				NEXT
			ELSE
				res := "("
				FOR I:=1 TO LEN(value)
					res += "("+LTRIM(STR(value[I][1]))+","+;
					LTRIM(STR(value[I][2]))+"),"
				NEXT
				res := LEFT(res,LEN(res)-1)+")"
			ENDIF
			RETURN res
		CASE PGT_CIDR
			IF !totext .AND. PG_ISBINARY(rowset)
				res := CHR(0)+CHR(LEN(value)*8)+CHR(0)+CHR(0)
				FOR I:=1 TO LEN(value)
					res += CHR(value[I])
				NEXT
				FOR I:=I TO 4
					res += CHR(0)
				NEXT
				RETURN res
			ELSE
				res := ""
				FOR I:=1 TO LEN(value)
					res += LTRIM(STR(value[I]))+"."
				NEXT
				res := LEFT(res,LEN(res)-1) + "/" + LTRIM(STR(LEN(value)*8))
				RETURN res
			ENDIF
		CASE PGT_INET
			IF !totext .AND. PG_ISBINARY(rowset)
				RETURN CHR(0)+CHR(value[5])+CHR(0)+CHR(0)+;
					CHR(value[1])+CHR(value[2])+CHR(value[3])+CHR(value[4])
			ELSE
				RETURN LTRIM(STR(value[1]))+"."+LTRIM(STR(value[2]))+"."+;
					LTRIM(STR(value[3]))+"."+LTRIM(STR(value[4]))+"/"+;
					LTRIM(STR(value[5]))
			ENDIF
	ENDSWITCH
RETURN
