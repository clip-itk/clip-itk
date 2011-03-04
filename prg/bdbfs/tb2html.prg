/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
MEMVAR _Pole,_FType,_Flen,_Fdr,_FRType,_fc,_lexp_o2a,_lexp_o2aq,;
	_HtmlFile, _XlsFile, _XmlFile
**********
FUNC TB2Html(cHtmlFile, cTitle, aDesign)
LOCAL	i, cCell, cT, cLine, bEval, lConv

IF EMPTY(cHtmlFile)
	m->_HtmlFile:=ClearName()
	IF !GetName(m->_ZIF,'_Htmlfile') .OR.;
	   !TakeScopeFunc(COPYING,'_HtmlCond') THEN RETURN .F.
ELSE
	m->_HtmlFile:=cHtmlFile
	m->_HtmlCond:='.t.'
ENDIF

IF !TestWriteFile(@_HtmlFile,'.HTM');
	THEN RETURN .F.

lConv:= IF(EMPTY(_lexp_o2aq), _lexp_o2a, Continue(NEED_OEM2ANSI, 1))

bEval:=Compile(m->_HtmlCond)
CheckEsc(.T.)	//counter

SET(_SET_PRINTFILE,m->_HtmlFile)
SET DEVI TO PRINT

// header
HtmlHeader(@cTitle, @aDesign, lConv)

PSAY('<H2>'+cTitle)
/*define table*/;
PSAY(	'<TABLE BGCOLOR="'+ aDesign[2] + '" '+;
	'BORDER=8 FRAME=ALL CellPadding=4 CellSpacing=0 '+;
	'COLS=' + NTRIM(m->_fc)+'>')
PSAY()
FOR i := 1 TO m->_fc
	// Insert like break for multiline headers
	*DevOut("<TH COLSPAN=1 VALIGN=BOTTOM>"+;
	cLine:=StrTran(m->_Works[i], ';', '<BR>')
	IF lConv THEN cLine:=OemToAnsi(cLine)
	DEVOUT('<TH VALIGN=BOTTOM>'+cLine)
NEXT
// here table body
PSAY('<TBODY>')

DO WHILE !EOF() .AND. CheckEsc()
    IF EVAL(bEval)

      cLine:='<TR>'  // string

      FOR i := 1 TO m->_fc

	cCell := &(m->_Pole[i])
	cLine+='<TD ALIGN='

	DO CASE

	    CASE (cT:=ValType(cCell)) == 'N'
		*cCell:=IF(Empty(oCol:picture),Str(cCell),Trans(cCell, oCol:picture))
		cCell:=Str(cCell)
		cLine += 'Right'

		/*
		Align by decimal dot, if needed
		    IF "," $ cCell
			cAlign := "<TD Align=Char Char=,>"
		    ENDIF
		*/

	    CASE cT == 'L'
		cCell := IF(cCell, YESNO)
		cLine += 'Center'

	    CASE cT == 'D'
		cCell:=IF( Empty(cCell),'',DTOC(cCell))
		cLine += 'Center'

	    OTHER	// "CM"
		cLine += 'Left'
		IF _Ftype[i] =='M' .AND. !EMPTY(m->_MemoPrnt)
			cCell:=&(RealMemoryName(m->_Pole[i]))
		ENDIF

	ENDCASE

	IF lConv THEN cCell:=OemToAnsi(cCell)
	cLine+='>'+IF(DELETED(),'<FONT COLOR="' +aDesign[4]+'">','')+;
		IF(EMPTY(cCell),'&nbsp',cCell)	// empty cell

      NEXT
      PSAY(cLine)	//+'</TR>'//Optional
    ENDIF
    DBSKIP()
ENDDO
PSAY('</TABLE></BODY></HTML>')
//Say about ending
File_Dial(m->_HtmlFile)
GO m->_tmr

RETURN .t.

**********
PROC HtmlHeader(cTitle, aDesign, lConv)
IF_NIL cTitle IS m->_base
IF_NIL aDesign IS {	"navy",;	// background color
			"blue",;	// table background
			"white",;	// text color (for table and header text)
			"red";		// text color for dele()
			}
aDesign:=Ext_Arr(aDesign,4,"")
IF IsNilOrTrue(lConv) THEN cTitle:=OemToAnsi(cTitle)

DevOut('<HTML>')
PSAY('<HEAD>')
PSAY('	<TITLE>'+cTitle+'</TITLE>')
#IFDEF ENGLISH
	PSAY('	<META NAME="Author" CONTENT="">')
#ELSE
	PSAY('	<META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=cp')
	DevOut( IF(EMPTY(lConv),"866","1251")+'">' )
	PSAY('	<META NAME="Author" CONTENT="">')
#ENDIF
PSAY('	<META NAME="generator" CONTENT="' + BDBF_VERSION +'">')
PSAY('</HEAD>')
// set colors (exclude links)
PSAY('<BODY BGCOLOR="'+ aDesign[1]+ '" TEXT="' + aDesign[3] + '">')
PSAY('<CENTER>')


**********
FUNC TB2XLS(cXLSFile, cTitle, lYesNo)
LOCAL	i, cCell, cLine, bEval, _h, nRow, lConv

IF EMPTY(cXLSFile)
	m->_XLSFile:=ClearName()
	IF !GetName(m->_ZIF,'_XLSfile') .OR.;
	   !TakeScopeFunc(COPYING,'_XLSCond') THEN RETURN .F.
ELSE
	m->_XLSFile:=cXLSFile
	m->_XLSCond:='.t.'
ENDIF

IF !TestWriteFile(@_XLSFile,'.XLS');
	THEN RETURN .F.

lConv:= IF(EMPTY(_lexp_o2aq), _lexp_o2a, Continue(NEED_OEM2ANSI, 1))
bEval:=Compile(m->_XLSCond)
CheckEsc(.T.)	//counter

// header
//header OpenOffice.org excelfileformat.pdf, MSDN ID: Q178605
_h:=FCREATE(m->_XLSFile)
FWRITE(_h, CHR(9)+CHR(8)+I2Bin(8)+;
	I2Bin(0)+I2Bin(16)+L2Bin(0);
      )

nRow:=0
IF !EMPTY(cTitle)
	WriteCell(_h,cTitle, INT(m->_fc/2)+1, nRow, 0, lConv, lYesNo)
	nRow+=2
ENDIF

FOR i := 1 TO m->_fc
	// Insert like break for multiline headers
	cCell:=StrTran(m->_Works[i], ';', CHR(10))
	WriteCell(_h, cCell, i, nRow, 0, lConv, lYesNo)
NEXT
nRow++

DO WHILE !EOF() .AND. CheckEsc()
	IF EVAL(bEval)
		WriteCell(_h, IF(DELETED(), '*', ' '), 0,  nRow,  0, .F., .F.)
		FOR i := 1 TO m->_fc

			cCell:=IF( _Ftype[i] =='M' .AND. !EMPTY(m->_MemoPrnt),;
				&(RealMemoryName(m->_Pole[i])),;
				&(m->_Pole[i]))

		        WriteCell(_h, cCell, i, nRow, 0, lConv, lYesNo)
		NEXT
		nRow++
	ENDIF
	DBSKIP()
ENDDO
FWRITE(_h, I2Bin(10)+I2Bin(0))	//XLSEOF
FCLOSE(_h)
//Say about ending
File_Dial(m->_XLSFile)
GO m->_tmr

RETURN .t.
**********
STATIC PROC WriteCell(_h, xData, nCol, nRow, nIndex, lConv, lYesNo)
LOCAL nLen
IF ValType(xData)=='N'
	FWRITE(_h, I2Bin(515)+;	// Cell type
	   I2Bin(14)+;		// Cell size
	   I2Bin(nRow)+;	// Cell Row
	   I2Bin(nCol)+;	// Cell Col
	   I2Bin(nIndex)+;	// Index to the XF record
	   D2Bin(xData);	// Float point number
	)
ELSE
	xData:=IF(ValType(xData)='L' .AND. !EMPTY(lYesNo),;
		 IF(xData, YESNO), FT_XTOY(xData, 'C') )
	nLen:=Len(xData)
	IF nLen > 255
		nLen:=255
		xData:=LEFT(xData,255)
	ENDIF
	IF lConv THEN xData:=OemToAnsi(xData)
	FWRITE(_h, I2Bin(516)+;	// Cell type
	   I2Bin(8+nLen)+;	// Cell size
	   I2Bin(nRow)+;	// Cell Row
	   I2Bin(nCol)+;	// Cell Col
	   I2Bin(nIndex)+;	// Index to the XF record
	   I2Bin(nLen)+;	// Length of the string
	   xData;		// The string
	)
ENDIF
***********
FUNC TB2XML(cXMLFile, cTitle, lYesNo, cRecName)
LOCAL	i, cCell, cLine, bEval, cBase, cBaseTrue, lConv, aTypes, cTypes,;
	 aFlds

IF EMPTY(cXMLFile)
	m->_XMLFile:=ClearName()
	m->_XMLCond:='.t.'
	IF !GetName(m->_ZIF,'_XMLfile') .OR.;
	   !TakeScopeFunc(COPYING,'_XMLCond') THEN RETURN .F.
ELSE
	m->_XMLFile:=cXMLFile
	m->_XMLCond:='.t.'
ENDIF

IF !TestWriteFile(@_XMLFile,'.XML');
	THEN RETURN .F.

lConv:= IF(EMPTY(_lexp_o2aq), _lexp_o2a, Continue(NEED_OEM2ANSI, 1))
IF_NIL cRecName IS 'Record'

bEval:=Compile(m->_XMLCond)
CheckEsc(.T.)	//counter

SET(_SET_PRINTFILE,m->_XMLFile)
SET DEVI TO PRINT

// header
#IFDEF ENGLISH
	DevOut('<?xml version="1.0" ?>')
#ELSE
	DevOut('<?xml version="1.0" encoding="windows-1251"?>')
#ENDIF
cBase:=SX_FNameParser(m->_base)
cBaseTrue:=SX_FNameParser(m->_base,.F.,.T.)
IF lConv THEN cBase:=OemToAnsi(cBase)
IF cBase<'A'	//from number
	cBase:='_'+cBase
ENDIF
//DTD
PSAY('<!DOCTYPE '+cBase+' [')
PSAY('	<!ELEMENT '+cBase+' (Record)*>')
aTypes:={}
aFlds:={}
cLine:=''
FOR i:=1 TO _fc
	AADD(aFlds, {_Pole[i],})
	cCell:= RealFldName(_Pole[i])
	IF _Ftype[i] =='M'
		cCell:=RealMemoryName(cCell)
		IF !Empty(m->_MemoPrnt) THEN aFlds[i,1]:=cCell
	ENDIF
	cCell := Capitalz(cCell)
	IF lConv THEN cCell:=OemToAnsi(cCell)
	aFlds[i,2]:=cCell
	cLine+=cCell
	IF i<>_fc THEN cLine+=', '
	cTypes:=ShowTypeLen(_Ftype[i], _FLen[i], _Fdr[i], _FRType[i])
	AADD(aTypes, '<!ELEMENT ' + cCell + ' (#PCDATA) >' )
	AADD(aTypes, '<!ATTLIST ' + cCell + ' type CDATA #FIXED "'+LEFT(cTypes,1) +'"')
	AADD(aTypes, SPACE(LEN(cCell)+11) + 'len CDATA #FIXED "'+LTRIM(SUBSTR(cTypes,6,7)) +'"')
	IF _FDr[i]<>0 THEN ;
	AADD(aTypes, SPACE(LEN(cCell)+11) + 'dec CDATA #FIXED "'+LTRIM(SUBSTR(cTypes,13)) +'"')
	IF '(' $ cTypes THEN ;
	AADD(aTypes, SPACE(LEN(cCell)+11) + 'realtype CDATA #FIXED "'+SUBSTR(cTypes,3,1) +'"')
	IF IsVMemo(i) .OR. _FRType[i]=='X' THEN ;
		AADD(aTypes, SPACE(LEN(cCell)+11) + 'valtype CDATA #IMPLIED')
	AADD(aTypes,'>')
NEXT

PSAY()
PSAY('	<!ELEMENT '+cRecName+ ' ('+cLine+') >')
PSAY('	<!ATTLIST '+cRecName+ ' RecNo CDATA #IMPLIED')
PSAY('	'+SPACE(LEN(cRecName)+11)+'KeyNo CDATA #IMPLIED')
PSAY('	'+SPACE(LEN(cRecName)+11)+'Deleted CDATA #IMPLIED')
PSAY('	>')
AEVAL(aTypes, {|_el| PSAY('	'+_el)})

PSAY(']>')
//Database here
PSAY('<'+cBase+'>')
IF_NIL cTitle IS m->_base
cTitle+=' '+Description(cBaseTrue)
IF !EMPTY(IndexKey()) THEN cTitle+=_CRLF+'    Sort on: '+IndexKey()
IF lConv THEN cTitle:=OemToAnsi(cTitle)

PSAY('<!--'+_CRLF+'    '+cTitle+_CRLF+'-->')

// table here

DO WHILE !EOF() .AND. CheckEsc()
    IF EVAL(bEval)

      cLine:='	<'+cRecName+' RecNo="'+NTRIM(RecNo())+'"'
      IF !EMPTY(IndexKey()) THEN cLine+=' KeyNo="'+NTRIM(KeyNo())+'"'
      IF DELETED() THEN cLine+=' Deleted="1"'

      PSAY(cLine+' >')

      FOR i := 1 TO m->_fc

	cLine := aFlds[i,1]
	cCell := &(cLine)
	cTypes:=''
	IF IsVMemo(i) .OR. _FRType[i]=='X' THEN ;
		cTypes:=' valtype="'+VALTYPE(cCell) +'"'

	DO CASE
		CASE ValType(cCell)='L'
			IF EMPTY(lYesNo)
				cCell:=IF(cCell, "1","0")
			ELSE
				cCell:=IF(cCell, YESNO)
			ENDIF
		CASE ValType(cCell) $ 'CM'
			cCell:="<![CDATA["+cCell+']]>'
		CASE ValType(cCell) $ 'D'
			cCell:=DTOS(cCell)
		OTHER
			cCell:=FT_XTOY(cCell, 'C')
	ENDCASE

	IF lConv THEN cCell:=OemToAnsi(cCell)
	cLine := aFlds[i,2]


	PSAY('		<'+cLine+cTypes+'>'+cCell+'</'+cLine+'>')
      NEXT
      PSAY('	</'+cRecName+'>')
    ENDIF
    DBSKIP()
ENDDO
PSAY('</'+cBase+'>'+_CRLF)
//Say about ending
File_Dial(m->_XMLFile)
GO m->_tmr

RETURN .t.
