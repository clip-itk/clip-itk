/*
    Copyright (C) 1998-2004 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
// Немножечко оптимизированные функции Nantucket Forum

#include "common.ch"

EXTERNAL FT_LASTKEY, FT_ELAPSED, FT_Fday, FT_Hex2Dec
EXTERNAL FT_ISPrint
EXTERNAL FT_ORIGIN
**********
FUNC FT_DosVer
RETURN NTRIM(OsVer())
**********
FUNC DosMajor
RETU INT(OsVer())
**********
FUNC DosMinor
RETU (OsVer()-INT(OsVer()))*100
**********
#define FORCE_BETWEEN(x,y,z)	(y := MAX(MIN(y,z),x))
#define BLOCKIFY(x)		{ || x }
#define IS_CHAR(x)		(VALTYPE(x) $ "CM")
#define IS_DATE(x)		(VALTYPE(x) == "D")
#define IS_LOGICAL(x)		(VALTYPE(x) == "L")
#define IS_NUMERIC(x)		(VALTYPE(x) $ "NF")
#define IS_DATETIME(x)		(VALTYPE(x) == "T")
#define NULL			""
#define CASE_AT(x,y,z)		z[AT(x,y)+1]
#define IS_NOT_CHAR(x)		!(VALTYPE(x) $ "CM")
#define IS_NOT_DATE(x)		(VALTYPE(x) <> "D")
#define EARLIEST_DATE		CTOD("01/01/0100")
#define BLANK_DATE		CTOD(NULL)
#define IS_NOT_ARRAY(x)		(VALTYPE(x) <> "A")
#define IS_NOT_LOGICAL(x)	(VALTYPE(x) <> "L")
#define IS_NOT_NUMERIC(x)	!(VALTYPE(x) $ "NF")
#define IS_NOT_CODE_BLOCK(x)	(VALTYPE(x) <> "B")
#define IS_NOT_DATETIME(x)	(VALTYPE(x) <> "T")

**********
FUNC Arr2Str(aX)
LOCAL i,cRes:='{',item
FOR i:=1 TO LEN(aX)
	item:=aX[i]

	DO SWITCH  VALTYPE(item)
		CASE 'C'
			item:=IF( FT_NOOCCUR('"',item)>1,;
				"["+item+"]",;
				'"'+item+'"')
		CASE 'N', 'F'
			item:=NTRIM(item)
		CASE 'D'
			item:='CTOD("'+DTOC(item)+'")'
		CASE 'T'
			item:='CTOT("'+TTOC(item)+'")'
		CASE 'L'
			item:=IF(item,'.T.','.F.')
		CASE 'A'
			item:=Arr2Str(item)
		OTHER
			item:='NIL'
	END
	cRes+=item
	IF i<LEN(aX) THEN cRes+=','
NEXT
RETURN cRes+'}'
*********
FUNC XTOY(xValueToConvert, cTypeToConvertTo, lWantYesNo)
cTypeToConvertTo:=UPPER(cTypeToConvertTo)
RETURN IF(IS_NUMERIC(xValueToConvert) .AND. cTypeToConvertTo=='D',;
	  FT_STOD(NTRIM(xValueToConvert)),;
	  IF(cTypeToConvertTo $ 'NF' .AND. IS_DATE(xValueToConvert),;
		DTOS(xValueToConvert),;
		FT_XTOY(xValueToConvert, cTypeToConvertTo, lWantYesNo));
	 )
*********
FUNC FT_XTOY(xValueToConvert, cTypeToConvertTo, lWantYesNo)
LOCAL i
cTypeToConvertTo:=UPPER(cTypeToConvertTo)

DO CASE
      CASE cTypeToConvertTo == 'V'	//и так хорошо
	IF xValueToConvert==NIL THEN xValueToConvert:=''

      CASE cTypeToConvertTo == 'X'	//и так хорошо

      CASE cTypeToConvertTo $ "CM" .AND.; // They Want a Character String
	   IS_NOT_CHAR(xValueToConvert)

	DO SWITCH  VALTYPE(xValueToConvert)
		CASE "A"
			xValueToConvert:=Arr2Str(xValueToConvert)
		CASE "N", "F"
			xValueToConvert:=NTRIM(xValueToConvert)
		CASE "D"
			xValueToConvert:=DTOC(xValueToConvert)
		CASE "T"
			xValueToConvert:=TTOC(xValueToConvert)
		CASE "L"
			xValueToConvert:=IF(xValueToConvert, ".T.",".F.")
		OTHER
			xValueToConvert:=""
        END

      CASE cTypeToConvertTo == "D" .AND.; // They Want a Date
	   IS_NOT_DATE(xValueToConvert)

	xValueToConvert := IF(IS_CHAR(xValueToConvert), ;
				      ; // Convert from a Character
			       CTOD(xValueToConvert), ;
			       IF(IS_NUMERIC(xValueToConvert), ;
				      ; // Convert from a Number
				  EARLIEST_DATE+xValueToConvert, ;
				  IF(IS_LOGICAL(xValueToConvert), ;
				      ; // Convert from a Logical
				     IF(xValueToConvert, DATE(), BLANK_DATE), ;
				      ; // Unsupported Type
				     BLANK_DATE)))

      CASE cTypeToConvertTo $ "NF" .AND.; // They Want a Number
	   IS_NOT_NUMERIC(xValueToConvert)

	xValueToConvert := IF(IS_CHAR(xValueToConvert), ;
				      ; // Convert from a Character
			       VAL(xValueToConvert), ;
			       IF(IS_DATE(xValueToConvert), ;
				      ; // Convert from a Date
				  xValueToConvert - EARLIEST_DATE, ;
				  IF(IS_LOGICAL(xValueToConvert), ;
				      ; // Convert from a Logical
				     IF(xValueToConvert, 1, 0), ;
				      ; // Unsupported Type
				     0)))

      CASE cTypeToConvertTo == "L" .AND.; // They Want a Logical
	   IS_NOT_LOGICAL(xValueToConvert)

	xValueToConvert := IF(IS_CHAR(xValueToConvert), ;
				      ; // Convert from a Character
			       UPPER(xValueToConvert) == IF(!EMPTY(lWantYesNo),"Y",".T."), ;
			       IF(IS_DATE(xValueToConvert), ;
				      ; // Convert from a Date
				  ! EMPTY(xValueToConvert), ;
				  IF(IS_NUMERIC(xValueToConvert), ;
				      ; // Convert from a Number
				     xValueToConvert != 0, ;
				      ; // Unsupported Type
				     .F.)))

      CASE cTypeToConvertTo == "A" .AND.; // They Want an Array
	   IS_NOT_ARRAY(xValueToConvert)

	xValueToConvert := { xValueToConvert }

      CASE cTypeToConvertTo == "B" .AND.; // They Want a Code Block
	   IS_NOT_CODE_BLOCK(xValueToConvert)

	xValueToConvert := BLOCKIFY(xValueToConvert)

      CASE cTypeToConvertTo == "T" .AND.; // They Want a DateTime
	   IS_NOT_DATETIME(xValueToConvert)

	xValueToConvert := IF(IS_CHAR(xValueToConvert),;
				CTOT(xValueToConvert),;
				CTOT("  /  /  00:00"))
     	

ENDCASE

RETURN xValueToConvert		// XToY
**********
FUNC FT_AADDITION( aList1, aList2, lTrimmer, lCaseSens )
LOCAL nElement, nPos, bScanCode, aNewArray := ACLONE( aList1 ), cEl

// Set default parameters as necessary.
IF_NIL lTrimmer IS .T.		// Ignore spaces.

// Assign code blocks according to case sensitivity and trim.
IF lCaseSens==NIL .OR. lCaseSens

	bScanCode :=IF( lTrimmer,;
			{ |x| ALLTRIM( x ) == ALLTRIM( cEl ) },;
			{ |x| ( cEl ) })
ELSE	// Ignore case.

	bScanCode :=IF( lTrimmer,;
			{ |x| UPPER( ALLTRIM( x )) == UPPER( ALLTRIM( cEl )) },;
			{ |x| UPPER( x ) == UPPER( cEl ) })
ENDIF

// Add the unique elements of aList2 to aList1.
FOR nElement := 1 TO LEN( aList2 )
	cEl:=aList2[ nElement ]

	nPos := ASCAN( aList1, bScanCode )

// If unique, then add element to new array.
	IF nPos = 0 THEN  AADD( aNewArray, cEl )

NEXT

RETURN aNewArray
**********
STATIC PROC FT_APARS(aArray, nStart, nEnd)
*IF VALTYPE(aArray)<>'A' .OR. LEN(aArray)==0 THEN RETURN 0
IF_NIL nStart IS 1
IF_NIL nEnd   IS LEN(aArray)

// Make Sure Bounds are in Range

FORCE_BETWEEN(1, nEnd,   LEN(aArray))
FORCE_BETWEEN(1, nStart, nEnd)
**********
FUNC FT_AAVG(aArray, nStart, nEnd)
FT_APARS(aArray, @nStart, @nEnd)
RETURN FT_ASUM(aArray, nStart, nEnd) / (nEnd - nStart + 1)
**********
FUNC FT_ADESSORT(aArray, nStart, nEnd)
FT_APARS(aArray, @nStart, @nEnd)
RETURN ASORT(aArray, nStart, nEnd, ;
		{ | xElement1, xElement2 | xElement1 > xElement2 } )
**********
FUNC FT_ANOMATCHES(aArray, bCompareBlock, nStart, nEnd)
LOCAL nNoOfMatches := 0		// Number of Matches Found
FT_APARS(aArray, @nStart, @nEnd)
AEVAL(aArray, { | xElement | ;
		IF(EVAL(bCompareBlock, xElement), nNoOfMatches++, NIL) }, ;
			nStart, nEnd - nStart + 1)

RETURN nNoOfMatches
**********
FUNC FT_ASUM(aArray, nStart, nEnd)
LOCAL nSumTotal := 0		// Array Sum
FT_APARS(aArray, @nStart, @nEnd)
AEVAL(aArray, { | xElement | ;
		nSumTotal += ;
		CASE_AT(VALTYPE(xElement), "NC", ;
			{ 0, xElement, ;
				IF(IS_CHAR(xElement),LEN(xElement),0) }) }, ;
			nStart, nEnd - nStart + 1)

RETURN nSumTotal
**********
FUNC FT_AMEDIAN( aArray, nStart, nEnd )
LOCAL nTemplen, aTemparray
FT_APARS(aArray, @nStart, @nEnd)

// Length of aTemparray
nTemplen := ( nEnd - nStart ) + 1

// Initialize & Sort aTemparray
aTemparray := ASORT(ACOPY( aArray, ARRAY( nTemplen ), nStart, nTemplen ))

// Determine middle value(s)
nStart:=ROUND( nTemplen / 2, 0)

RETURN IF( ( nTemplen % 2 ) == 0,;
		INT(( aTemparray[nStart] + aTemparray[nStart +1]) / 2 ),;
		aTemparray[ nStart ];
	 )
**********
FUNC FT_LDAY( dDate )
IF_NIL dDate IS DATE()
RETURN ( dDate+= 45 - Day( dDate ) ) - Day( dDate )
**********
FUNC FT_MADD( dDate, nAddMonths, lMakeEOM)
LOCAL nAdjDay, dTemp, i

IF VALTYPE(dDate) <> 'D' THEN dDate := DATE()
IF VALTYPE(nAddMonths) <> 'N' THEN nAddMonths := 0

dTemp := dDate - (nAdjDay:= DAY( dDate ) - 1)	// first of month

// Work with 1st of months.
FOR i := 1 TO ABS(nAddMonths)
	dTemp += IF( nAddMonths > 0, 31, -1 )
	dTemp += 1 - DAY( dTemp )
NEXT

i:=dTemp + 31 - DAY( dTemp + 31 )
RETURN IF(EMPTY(lMakeEom), MIN((dTemp + nAdjday), i),;
			   FT_LDAY(i))
**********
FUNC FT_WorkDays( dStart, dStop )
LOCAL nWorkDays := 0, nDays, nAdjust

IF dStart # NIL .AND. dStop # NIL
   IF dStart # dStop
	IF dStart > dStop	// Swap the values
		nAdjust:= dStop
		dStop  := dStart
		dStart := nAdjust
	ENDIF

	IF ( nDays := Dow( dStart ) ) == 1 // Sunday (change to next Monday)
		dStart ++
	ELSEIF nDays == 7 // Saturday (change to next Monday)
		dStart += 2
	ENDIF

	IF ( nDays := Dow( dStop ) ) == 1 // Sunday (change to prev Friday)
		dStop -= 2
	ELSEIF nDays == 7 // Saturday (change to prev Friday)
		dStop --
	ENDIF

	nAdjust := ( nDays := dStop - dStart + 1 ) % 7

	IF Dow( dStop ) + 1 < Dow( dStart ) // Weekend adjustment
		nAdjust -= 2
	ENDIF

	nWorkDays := Int( nDays / 7 ) * 5 + nAdjust

   ELSEIF Between( Dow( dStart ), 2, 6 )

	nWorkDays := 1

   ENDIF

ENDIF
RETURN MAX(nWorkDays,0)
**********
FUNC FT_SQZN(nValue,nSize,nDecimals)
LOCAL tmpstr,cCompressed,k

IF_NIL nSize IS 10
IF_NIL nDecimals IS 0
nValue := nValue * (10**nDecimals)

IF nSize % 2 <> 0  THEN nSize++

tmpstr      := strtran(str( abs(nValue),nSize ), ' ','0')
cCompressed := chr( val(LEFT(tmpstr,2))+if(nValue<0,128,0) )

FOR k := 3 TO len(tmpstr) STEP 2
	cCompressed += chr(val(substr(tmpstr,k,2)))
NEXT
RETURN cCompressed
**********
FUNC FT_UNSQZN(cCompressed,nSize,nDecimals)
LOCAL tmp:="",k,cValue,multi:=1

IF_NIL nSize IS 10
IF_NIL nDecimals IS 0

IF nSize % 2 <> 0  THEN nSize++

IF asc(cCompressed) > 127
	tmp:= str(asc(cCompressed)-128,2)
	multi := -1
ELSE
	tmp:= str(asc(cCompressed),2)
ENDIF

FOR k := 2 TO len(cCompressed)
	tmp += str(asc(substr(cCompressed,k,1)),2)
NEXT

tmp := strtran(tmp," ","0")
cValue := LEFT(tmp,nSize-nDecimals)+"."+substr(tmp,nSize-nDecimals+1)

RETURN val(cValue) * multi
**********
FUNC FT_RAND1(nMax)
STATIC nSeed
LOCAL m := 100000000

IF_NIL nSeed IS seconds()	// init_seed()

RETURN( nMax * ( ( nSeed := mod( nSeed*31415621+1, m ) ) / m ) )
**********
FUNC FT_AT2( cSearch, cSubstr, nOccurs, lCaseSens )
LOCAL nCount, nPos, nPos2 := 0

// Set default parameters as necessary.
IF_NIL nOccurs IS 1
IF !IsNilOrTrue(lCaseSens)
	cSearch:=UPPER(cSearch)
	cSubstr:=UPPER(cSubstr)
ENDIF

FOR nCount := 1 TO nOccurs

	// Store position of next occurrence of cSearch and Resize cSubstr.
	IF (nPos := Parce(cSubstr, cSearch, , @cSubstr))==0 THEN EXIT

	// Store position of cSearch relative to original string.
	nPos2 += nPos

NEXT

RETURN nPos2
**********
FUNC FT_FINDITH( cSearch, cSubstr, nOccurs, lCaseSens )
RETURN FT_AT2( cSearch, cSubstr, nOccurs, !EMPTY(lCaseSens) )
**********
FUNC FT_NOOCCUR( cSubstr, cSearch, lIgnoreCase)
IF IsNilOrTrue(lIgnoreCase)
	cSearch:=UPPER(cSearch)
	cSubstr:=UPPER(cSubstr)
ENDIF
RETURN INT((LEN(cSearch) - LEN(STRTRAN(cSearch, cSubstr))) / ;
			LEN(cSubstr))
**********
FUNC FT_METAPH ( cMeta, nSize )
//  Calculates the metaphone of a character string, default size: 4-bytes

LOCAL x, cConv, ch

IF_NIL cMeta IS ""
IF_NIL nSize IS 4

//  Remove non-alpha characters and make upper case.
//  The string is padded with 1 space at the beginning & end.
//  Spaces, if present inside the string, are not removed until all
//  the prefix/suffix checking has been completed.
cMeta:= UPPER( ALLTRIM( cMeta ) )
cConv:=' '
FOR x := 1 to LEN( cMeta )
	IF (ch:=SUBSTR( cMeta, x, 1 )) == " " .OR. ISALPHA( ch )
		cConv +=  ch
	ENDIF
NEXT
cMeta:= cConv+' '

//  prefixes which need special consideration
TransMeta(@cmeta,{;
		{ " KN",	" N" },;
		{ " GN",	" N" },;
		{ " PN",	" N" },;
		{ " AE",	" E" },;
		{ " X",		" S" },;
		{ " WR",	" R" },;
		{ " WHO",	" H" },;
		{ " WH",	" W" },;
		{ " MCG",	" MK"},;
		{ " MC",	" MK"},;
		{ " MACG",	" MK"},;
		{ " MAC",	" MK"},;
		{ " GI",	" K" },;
/*  Suffixes which need special consideration */;
		{ "MB ",	"M " },;
		{ "NG ",	"N " };
		})

//  Remove inner spaces (1st and last byte are spaces)
cMeta := " " + Exclude(cMeta," ") + " "

//  Double consonants sound much the same as singles
TransMeta(@cmeta,{;
		{ "BB", "B" },;
		{ "CC", "CH"},;
		{ "DD", "T" },;
		{ "FF", "F" },;
		{ "GG", "K" },;
		{ "KK", "K" },;
		{ "LL", "L" },;
		{ "MM", "M" },;
		{ "NN", "N" },;
		{ "PP", "P" },;
		{ "RR", "R" },;
		{ "SS", "S" },;
		{ "TT", "T" },;
		{ "XX", "KS"},;
		{ "ZZ", "S" },;
/*  J sounds */;
		{ "DGE", "J"},;
		{ "DGY", "J"},;
		{ "DGI", "J"},;
		{ "GI" , "J"},;
		{ "GE" , "J"},;
		{ "GY" , "J"},;
/*  X sounds (KS) */;
		{ "X",	 "KS"},;
/* special consideration for SCH */;
		{ "ISCH","IX"},;
		{ "SCH", "SK"},;
/*  sh sounds (X) */;
		{ "CIA", "X"},;
		{ "SIO", "X"},;
		{ "SIA", "X"},;
		{ "SH" , "X"},;
		{ "TIA", "X"},;
		{ "TIO", "X"},;
		{ "TCH", "X"},;
		{ "CH" , "X"},;
/* hissing sounds (S) */;
		{ "SCI", "S"},;
		{ "SCE", "S"},;
		{ "SCY", "S"},;
		{ "CI" , "S"},;
		{ "CE" , "S"},;
		{ "CY" , "S"},;
		{ "Z"  , "S"},;
/*  th sound (0) */;
		{ "TH",	 "0"};
		})

//  Convert all vowels to 'v' from 3rd byte on
cConv := LEFT( cMeta, 2 )
FOR x := 3 to LEN( cMeta )
	cConv += IF( (ch:=SUBSTR( cMeta, x, 1 )) $ "AEIOU", "v", ch )
NEXT
cMeta:=cConv

// Make Y's silent if not followed by vowel
TransMeta(@cmeta,{;
		{ "Yv",	"#" },;  // Y followed by vowel
		{ "Y",	""  },;  // not followed by vowel
		{ "#",	"Yv"},;  // restore Y and vowel
/*  More G sounds, looking at surrounding vowels */;
		{ "GHv", "G"},;
		{ "vGHT","T"},;
		{ "vGH", "W"},;
		{ "GN",	 "N"},;
		{ "G",	 "K"},;
/*  H sounds, looking at surrounding vowels */;
		{ "vHv", "H"},;
		{ "vH",	 "" },;
/*  F sounds */;
		{ "PH", "F"},;
		{ "V",	"F"},;
/*  D sounds a bit like T */;
		{ "D",	"T"},;
/*  K sounds */;
		{ "CK", "K"},;
		{ "Q",	"K"},;
		{ "C",	"K"},;
/*  Remove vowels */;
		{ "v",	"" };
		})

RETURN PadR( LTRIM( cMeta ), nSize )
**********
STATIC PROC TransMeta(cMeta,aTran)
AEVAL(aTran,{|_1|cMeta:=STRTRAN(cMeta,_1[1],_1[2])})

**********
FUNC FT_BYT2BIT(cByte)
LOCAL nCounter, xBitstring

IF valtype(cByte) == "C"
	xBitString := ""
	FOR nCounter := 7 TO 0 step -1
		xBitString += IF(FT_ISBIT(cByte, nCounter), "1", "0")
	NEXT
ENDIF

RETURN xBitString
**********
FUNC FT_BYT2HEX(cByte)
LOCAL cHexTable := "0123456789ABCDEF", xHexString

IF valtype(cByte) == "C"
    xHexString := substr(cHexTable, int(asc(cByte) / 16) + 1, 1) ;
		+ substr(cHexTable, int(asc(cByte) % 16) + 1, 1) ;
		+ "h"
ENDIF

RETURN xHexString
**********
FUNC FT_BITCLR(cInbyte, nBitpos)
LOCAL cByte
cByte:=FT_ISBIT(cInByte, nBitpos)
IF cByte<>NIL
	cByte := IF( cByte,;
			chr(asc(cInByte) - (2 ^ nBitpos)),;
			cInByte;
			)
ENDIF
RETURN cByte
**********
FUNC FT_BITSET(cInByte, nBitpos)
LOCAL cByte

cByte:=FT_ISBIT(cInByte, nBitpos)
IF cByte<>NIL
	cByte := IF( cByte,;
			cInByte,;
			chr(asc(cInByte) + (2 ^ nBitpos));
			)
ENDIF

RETURN cByte
**********
FUNC FT_ISBIT(cInbyte,nBitPos)
LOCAL lBitStat

IF VALTYPE(cInbyte)+VALTYPE(nBitPos) == "CN"  // parameter check
     IF Between(nBitPos,0,7) .AND. (nBitPos == int(nBitPos))
	lBitStat := int(((asc(cInByte) * (2 ^ (7 - nBitPos))) % 256) / 128) == 1
     ENDIF
ENDIF

RETURN lBitStat
**********
FUNC FT_ISBITON( nWord, nBit )
IF (nWord < 0) THEN nWord += 65536

RETURN (INT( INT( INT(nWord * (2 ^ (15 - nBit))) % 65536) / 32768) == 1)
**********
FUNC FT_BYTEAND(cByte1, cByte2, bEval)
LOCAL i, cNewByte
IF_NIL bEval IS {|x,y| x .AND. y }

IF VALTYPE(cByte1)+VALTYPE(cByte2) == "CC"	// parameter check
     cNewByte := chr(0)
     FOR i := 0 to 7	// test each bit position
	IF EVAL(bEval, FT_ISBIT(cByte1, i), FT_ISBIT(cByte2, i))
		cNewByte := FT_BITSET(cNewByte, i)
	ENDIF
     NEXT
ENDIF

RETURN cNewByte
**********
FUNC FT_BYTEOR(cByte1, cByte2)
RETURN FT_BYTEAND(cByte1, cByte2, {|x,y| x .OR. y })
**********
FUNC FT_BYTEXOR(cByte1, cByte2)
RETURN FT_BYTEAND(cByte1, cByte2,{|x,y| !x .AND. y })
**********
FUNC FT_BYTENEG(cByte)
RETURN  IF(valtype(cByte) == "C", chr((256 - asc(cByte)) % 256), )
**********
FUNC FT_BYTENOT(cByte)
RETURN  IF(valtype(cByte) == "C", chr(255 - asc(cByte)) , )
**********
#define log10( num )	log( num ) / log( 10 )

FUNC ft_d2e( nDec, nPrecision )
LOCAL nExp
IF_NIL nPrecision IS 6

IF nDec == 0
	nExp := 0
ELSEIF abs( nDec ) < 1
	nExp := int( log10( abs(nDec) ) ) - 1
ELSE
	nExp := int( log10( abs(nDec)+0.00001 ) )	&& 0.00001 == kludge
ENDIF							&& for imprecise logs

nDec /= 10 ^ nExp

IF ROUND( abs(nDec), nPrecision ) >= 10
	nDec /= 10
	nExp++
ENDIF another kludge for stuff like '999999999'

RETURN LTRIM( STR( nDec, nPrecision + 3, nPrecision ) ) +;
	'E' + LTRIM( STR( nExp, 5) )
**********
FUNC FT_DEC2BIN(x)
LOCAL i,  cRet:='', n
FOR i := 8 to 1 step -1
  IF x >= (n:=2 ^ (i - 1))
	x -= n
	cRet+='1'
  ELSE
	cRet+='0'
  ENDIF
NEXT
RETURN cRet
**********
FUNC ft_e2d( sNumE )
LOCAL nMant, nExp
Parce(sNumE,'E',@nMant,@nExp)
RETURN VAL(nMant) * 10 ^ VAL(nExp)
**********
FUNC FT_GCD(n1, n2)
LOCAL	nHold1,;	// Temporarily Hold the Maximum Number
	nHold2,;	// 			Minimum Number
	nResult 	// GCD

nHold1 := MAX(ABS(n1), ABS(n2))
nHold2 := MIN(ABS(n1), ABS(n2))

DO WHILE .T.
	nResult := nHold1 % nHold2	// Get the Remainder
	nHold1  := nHold2		// Which Makes a New Maximum Number
	nHold2  := nResult		// and it's the Minimum Number

	IF nResult <= 0 THEN EXIT
ENDDO

RETURN nHold1	// Maximum Number Should Be the Answer
**********
FUNC FT_ROUND(nNumber, nRoundToAmount, cRoundType, cRoundDirection, ;
		nAcceptableError)

LOCAL nResult := ABS(nNumber)	// The Result of the Rounding

nRoundToAmount:=IF(nRoundToAmount==NIL, 2, INT(nRoundToAmount) )
cRoundType:=IF(cRoundType==NIL, "D", First(cRoundType) )
cRoundDirection:=IF(cRoundDirection==NIL, "N", First(cRoundDirection))
IF_NIL nAcceptableError IS 1 / (nRoundToAmount ** 2)

// Are We Rounding to the Nearest Whole  Number or to Zero Decimal Places??
IF (cRoundType <> "W") .AND. (nRoundToAmount <> 0)

	// No, Are We Rounding to the Nearest Decimal Place??
	IF cRoundType == "D"
		// Yes, Convert to Nearest Fraction
		nRoundToAmount := 10 ** nRoundToAmount
	ENDIF

	// Are We Already Within the Acceptable Error Factor??
	IF (ABS(INT(nResult * nRoundToAmount) - (nResult * nRoundToAmount)) > ;
	   nAcceptableError)
		// No, Are We Rounding Down??
		nResult -= IF(cRoundDirection == "D", ;
				; // Yes, Make Downward Adjustment
				0.5 / nRoundToAmount, ;
				; // Are We Rounding Up??
				IF(cRoundDirection == "U", ;
					; // Yes, Make Upward Adjustment
					-0.5 / nRoundToAmount, ;
					; // No, Rounding Normal, No Adjustment
					0))
		//Do the Actual Rounding
		nResult := INT((nRoundToAmount * nResult) + 0.5 + nAcceptableError) / ;
				nRoundToAmount

	ENDIF

ELSE	// Yes, Round to Nearest Whole Number or to Zero Places

	nRoundToAmount := MAX(nRoundToAmount, 1)

	// Do "Whole" Rounding
	IF cRoundDirection $ "UD"

		nResult := INT(nResult / nRoundToAmount) * nRoundToAmount
		IF  cRoundDirection == "U"  THEN nResult += nRoundToAmount

	ELSE	// Round Normally

		nResult := INT((nResult + nRoundToAmount / 2) / nRoundToAmount) *;
			   nRoundToAmount

	ENDIF

ENDIF

RETURN IF(nNumber < 0, -nResult, nResult)
**********
FUNC FT_AEmaxlen( aArray, nDimension, nStart, nCount, lMin)
LOCAL i, nLast, nMaxlen := IF( EMPTY(lMin), 0, 65519),aEl

// Set default parameters as necessary.
IF_NIL nDimension IS 1
IF_NIL nStart IS 1
IF_NIL nCount IS LEN( aArray ) - nStart + 1

nLast := MIN( nStart +nCount -1, LEN( aArray ))

FOR i := nStart TO nLast
   aEl:=aArray[i]

   nCount:=LEN(IF( VALTYPE( aEl ) == "C",;
		aEl,;
		LTRIM( TRANSFORM( IF(VALTYPE( aEl )  == "A",;
					aEl[nDimension], aEl),;
				"@X" ) ) ;
		 );
	      )
   nMaxLen := IF(EMPTY(lMin), MAX( nMaxLen, nCount),;
			      MIN( nMaxLen, nCount))

NEXT

RETURN nMaxlen
**********
FUNC FT_AEminlen( aArray, nDimension, nStart, nCount )
RETURN FT_AEmaxlen( aArray, nDimension, nStart, nCount, .T.)
**********

FUNC FT_TEMPFILE( cPath, lHide )
// в отличие от оригинальной функции допускает числовой атрибут
IF valType(lHide) = "L" .AND. lHide
	lHide:=1
ENDIF

RETURN TEMPFILE(cPath, , lHide)
