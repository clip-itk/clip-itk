/*
    Copyright (C) 1998-2002 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
**********
FUNC TB2Html(cHtmlFile, cTitle, aDesign)
LOCAL	i, cCell, cT, cLine, bEval

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

bEval:=Compile(m->_HtmlCond)
CheckEsc(.T.)	//счетчик


SET(_SET_PRINTFILE,m->_HtmlFile)
SET DEVI TO PRINT

// header
HtmlHeader(@cTitle, @aDesign)

PSAY('<H2>'+cTitle)
/*определим таблицу*/;
PSAY(	'<TABLE BGCOLOR="'+ aDesign[2] + '" '+;
	'BORDER=8 FRAME=ALL CellPadding=4 CellSpacing=0 '+;
	'COLS=' + NTRIM(m->_fc)+'>')
PSAY()
FOR i := 1 TO m->_fc
	// Для многострочных заголовков вставляется line break
	*DevOut("<TH COLSPAN=1 VALIGN=BOTTOM>"+;
	DEVOUT('<TH VALIGN=BOTTOM>'+StrTran(m->_Works[i], ';', '<BR>'))
NEXT
// пошла сама таблица
PSAY('<TBODY>')

GO TOP
DO WHILE !EOF() .AND. CheckEsc()
    IF EVAL(bEval)

      cLine:='<TR>'  // строка

      FOR i := 1 TO m->_fc

	cCell := &(m->_Pole[i])
	cLine+='<TD ALIGN='

	DO CASE

	    CASE (cT:=ValType(cCell)) == 'N'
		*cCell:=IF(Empty(oCol:picture),Str(cCell),Trans(cCell, oCol:picture))
		cCell:=Str(cCell)
		cLine += 'Right'

		/*
		Если есть желание, можно aligning сделать по десятичной
		точке
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

	ENDCASE

	cLine+='>'+IF(DELETED(),'<FONT COLOR="' +aDesign[4]+'">','')+;
		IF(EMPTY(cCell),'&nbsp',cCell)	// пустая ячейка

      NEXT
      PSAY(cLine)	//+'</TR>'//Необязательно
    ENDIF
    DBSKIP()
ENDDO
PSAY('</TABLE></BODY></HTML>')
//свистнем о завершении
File_Dial(m->_HtmlFile)
GO m->_tmr

RETURN .t.

**********
PROC HtmlHeader(cTitle, aDesign)
IF_NIL cTitle IS m->_base
IF_NIL aDesign IS {	"navy",;	// background color
			"blue",;	// table background
			"white",;	// text color (for table and header text)
			"red";		// text color for deleted()
			}
aDesign:=Ext_Arr(aDesign,4,"")
DevOut( '<HTML>')
PSAY('<HEAD>')
PSAY('	<TITLE>'+cTitle+'</TITLE>')
#IFDEF ENGLISH
	PSAY('	<META NAME="Author" CONTENT="">')
*	PSAY('	<META NAME="Author" CONTENT="'+TRIM(DESCEND(&_o_1))+'">' )
#ELSE
	PSAY('	<META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=cp866">')
	PSAY('	<META NAME="Author" CONTENT="">')
#ENDIF
PSAY('	<META NAME="generator" CONTENT="' + BDBF_VERSION +'">')
PSAY('</HEAD>')
// установим цвета (кроме линков)
PSAY('<BODY BGCOLOR="'+ aDesign[1]+ '" TEXT="' + aDesign[3] + '">')
PSAY('<CENTER>')
