/*
‚€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€ƒ
        Class: RichText                                                   
  Description: System for generating simple RTF files.                    
     Language: Clipper/Fivewin                                            
      Version: 0.90 -- This is a usable, but incomplete, version that is  
               being distributed in case anyone cares to use it as-is,    
               or wants to comment on it.                                 
         Date: 01/28/97                                                   
       Author: Tom Marchione                                              
     Internet: 73313,3626@compuserve.com                                  
                                                                          
    Copyright: (C) 1997, Thomas R. Marchione                              
       Rights: Use/modify freely for applicaton work, under the condition 
               that you include the original author's credits (i.e., this 
               header), and you do not offer the source code for sale.    
               The author may or may not supply updates and revisions     
               to this code as "freeware".                                
                                                                          
   Warranties: None. The code has not been rigorously tested in a formal  
               development environment, and is offered as-is.  The author 
               assumes no responsibility for its use.                     
                                                                          
    Revisions:                                                            
                                                                          
    DATE       AUTHOR  COMMENTS                                           
€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€
    01/28/97   TRM     Date of initial release                            
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
„€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€…
*/


#ifdef __CLIP__
#include "Objects.ch"
#else
#include "FiveWin.ch"
#endif

#include "Richtext.ch"

CLASS RichText
	DATA cFileName, hFile
	DATA nFontSize
	DATA aTranslate
	DATA nFontNum
	DATA nScale
	DATA lTrimSpaces

	// Table Management
	DATA cTblHAlign, nTblFntNum, nTblFntSize, nTblRows, nTblColumns
	DATA nTblRHgt, aTableCWid, cRowBorder, cCellBorder, nCellPct
	DATA lTblNoSplit, nTblHdRows, nTblHdHgt, nTblHdPct, nTblHdFont
	DATA nTblHdFSize
	DATA cCellAppear, cHeadAppear
	DATA cCellHAlign, cHeadHAlign
	DATA nCurrRow, nCurrColumn


	// Methods for opening & closing output file, and setting defaults
	METHOD New( cFileName, aFontData, nFontSize, nScale, aTrans ) CONSTRUCTOR
	METHOD End() INLINE ::TextCode( "par\pard" ), ::CloseGroup(), FCLOSE(::hFile)


	// Core methods for writing control codes & data to the output file
	METHOD TextCode( cCode ) INLINE FWRITE(::hFile, FormatCode(cCode) )
	METHOD NumCode( cCode, nValue, lScale )
	METHOD LogicCode( cCode, lTest )
	METHOD Write( xData. lCodesOK )


	// Groups and Sections (basic RTF structures)
	METHOD OpenGroup() INLINE FWRITE( ::hFile, "{" )
	METHOD CloseGroup() INLINE FWRITE( ::hFile, "}" )

	METHOD NewSection( lLandscape, nColumns, nLeft, nRight, nTop, nBottom, ;
				nWidth, nHeight, cVertAlign, lDefault )


	// Higher-level page setup methods
	METHOD PageSetup( nLeft, nRight, nTop, nBottom, nWidth, nHeight, ;
				nTabWidth, lLandscape, cVertAlign, cPgNumPos, lPgNumTop, ;
				lNoWidow )

	METHOD BeginHeader() INLINE ::OpenGroup(), ::TextCode("header \pard")
	METHOD EndHeader() INLINE ::TextCode("par"), ::CloseGroup()
	METHOD BeginFooter() INLINE ::OpenGroup(), ::TextCode("footer \pard")
	METHOD EndFooter() INLINE ::TextCode("par"), ::CloseGroup()

	METHOD Paragraph( cText, nFontNumber, nFontSize, cAppear, ;
				cHorzAlign, aTabPos, nIndent, nFIndent, nRIndent, nSpace, ;
				lSpExact, nBefore, nAfter, lNoWidow, lBreak, ;
				lBullet, cBulletChar, lHang, lDefault, lNoPar )


	// Table Management
	METHOD DefineTable( cTblHAlign, nTblFntNum, nTblFntSize, ;
		cCellAppear, cCellHAlign, nTblRows, ;
		nTblColumns, nTblRHgt, aTableCWid, cRowBorder, cCellBorder, nCellPct, ;
		lTblNoSplit, nTblHdRows, nTblHdHgt, nTblHdPct, nTblHdFont, ;
		nTblHdFSize, cHeadAppear, cHeadHAlign )

	METHOD BeginRow() INLINE ::TextCode( "trowd" ), ::nCurrRow += 1
	METHOD EndRow()   INLINE ::TextCode( "row" )

	METHOD WriteCell( cText, nFontNumber, nFontSize, cAppear, cHorzAlign, ;
				nSpace, lSpExact, cCellBorder, nCellPct, lDefault )


	// Methods for formatting data

	METHOD Appearance( cAppear )
	METHOD HAlignment( cAlign )
	METHOD LineSpacing( nSpace, lSpExact )
	METHOD Borders( cEntity, cBorder )
	METHOD NewFont( nFontNumber )
	METHOD SetFontSize( nFontSize )
	METHOD NewLine() INLINE FWRITE(::hFile, CRLF), ::TextCode( "par")
	METHOD NewPage() INLINE ::TextCode( "page" + CRLF )


	// General service methods

	METHOD BorderCode( cBorderID )

	// Someday maybe we'll handle:
	// Styles
	// Alternating shading of table rows
	// Footnotes & Endnotes
	// Shaded text
	// Frames
	// Font Colors
	// Lines, Bitmaps & Graphics
	// Lots of other cool stuff
ENDCLASS



METHOD New( cFileName, aFontData, nFontSize, nScale, aHigh ) CLASS RichText
*********************************************************************
* Description:  Initialize a new RTF object, and create an associated
*               file, with a valid RTF header.
*
* Arguments:
*
* Return: Self
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/06/97   TRM         Creation
*
*********************************************************************
LOCAL i
LOCAL cTopFile  := "rtf1\ansi\deff0\deftab720\deflang1033"
LOCAL cColors   := "colortbl\red0\green0\blue0;"

DEFAULT ;
	cFileName := "REPORT.RTF", ;
	aFontData := { "Courier New Cyr" }, ;
	nFontSize := 12
	nScale    := INCH_TO_TWIP

::cFileName := cFileName
::nFontSize := nFontSize
::nScale    := nScale

::lTrimSpaces := .F.

IF VALTYPE(aHigh) == "A"
	::aTranslate := aHigh
ENDIF

// If no extension specified in file name, use ".RTF"
IF !("." $ ::cFileName)
   ::cFileName += ".RTF"
ENDIF

// Create/open a file for writing
::hFile := FCREATE(::cFileName)

IF ::hFile >= 0

	// Generate RTF file header

	// This opens the top-most level group for the report
	// This group must be explicitly closed by the application!

	::OpenGroup()

		::TextCode( cTopFile )

		// Generate a font table, and write it to the header
		::nFontNum := LEN(aFontData)
		::OpenGroup()
		::TextCode( "fonttbl" )
		FOR i := 1 TO ::nFontNum
			::OpenGroup()
			::NewFont( i )
			::TextCode( "fnil" )
			::Write( aFontData[i] + ";" )
			::CloseGroup()
		NEXT
		::CloseGroup()

		// Use default color info, for now...
		::OpenGroup()
			::TextCode( cColors )
		::CloseGroup()

	// NOTE:  At this point, we have an open group (the report itself)
	// that must be closed at the end of the report.

ENDIF

#ifdef __CLIP__
RETURN Self
#else
RETURN NIL
#endif
**************************  END OF New()  ***************************






METHOD PageSetup( nLeft, nRight, nTop, nBottom, nWidth, nHeight, ;
				nTabWidth, lLandscape, lNoWidow, cVertAlign, ;
				cPgNumPos, lPgNumTop ) CLASS RichText
*********************************************************************
* Description:  Define default page setup info for file
*               This information is placed in the "document formatting
*               group" of the RTF file, except for vertical alignment,
*               which, if supplied, is treated as a new section.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/06/97   TRM         Creation
*
*********************************************************************

DEFAULT lLandscape := .F.
DEFAULT lNoWidow := .F.
DEFAULT lPgNumTop := .F.


// Note -- "landscape" should not be specified here if landscape and
// portrait orientations are to be mixed.  If "landscape' is specified,
// the paper width and height should also be specified, and consistent
// (i.e., with landscape/letter, width==11 and height==8.5)

::LogicCode( "landscape", lLandscape )
::NumCode( "paperw", nWidth )
::NumCode( "paperh", nHeight )

::LogicCode( "widowctrl", lNoWidow )
::NumCode( "margl", nLeft )
::NumCode( "margr", nRight )
::NumCode( "margt", nTop )
::NumCode( "margb", nBottom )
::NumCode( "deftab", nTabWidth )


// Vertical alignment and page number position are "section-specific"
// codes.  But we'll put them here anyway for now...

IF !EMPTY( cVertAlign )
	::TextCode( "vertal" + LOWER( LEFT(cVertAlign,1) ) )
ENDIF

// Set the initial font size
::SetFontSize(::nFontSize)

// Forget page numbers for now...


RETURN NIL
**********************  END OF PageSetup()  *************************







METHOD Paragraph( cText, nFontNumber, nFontSize, cAppear, ;
				cHorzAlign, aTabPos, nIndent, nFIndent, nRIndent, nSpace, ;
				lSpExact, nBefore, nAfter, lNoWidow, lBreak, ;
				lBullet, cBulletChar, lHang, lDefault, lNoPar ) CLASS RichText
*********************************************************************
* Description:  Write a new, formatted paragraph to the output file.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/12/97   TRM         Creation
*
*********************************************************************
DEFAULT ;
	lDefault := .F., ;
	lNoWidow := .F., ;
	lBreak := .F., ;
	lBullet := .F., ;
	lHang := .F., ;
	cAppear := "", ;
	cHorzAlign := "", ;
	cBulletChar := "\bullet", ;
	lNoPar := .F.

::LogicCode("pagebb", lBreak)

IF !lNoPar
	::TextCode( "par" )
ENDIF

::LogicCode( "pard", lDefault )
::NewFont( nFontNumber )
::SetFontSize( nFontSize )
::Appearance( cAppear )
::HAlignment( cHorzAlign )

IF VALTYPE( aTabPos ) == "A"
	AEVAL( aTabPos, { |x| ::NumCode("tx", x) } )
ENDIF

::NumCode( "li", nIndent )
::NumCode( "fi", nFIndent )
::NumCode( "ri", nRIndent )
::LineSpacing( nSpace, lSpExact )

::NumCode( "sb", nBefore )
::NumCode( "sa", nAfter )

::LogicCode("keep", lNoWidow)

IF lBullet
	::OpenGroup()
		::TextCode( "*" )
		::TextCode( "pnlvlblt" )
		::LogicCode( "pnhang", lHang )
		::TextCode( "pntxtb " + cBulletChar )
	::CloseGroup()
ENDIF

::Write( cText )

RETURN NIL
**********************  END OF Paragraph()  *************************









METHOD SetFontSize( nFontSize ) CLASS RichText
*********************************************************************
* Description:    Size in points -- must double value because
*                 RTF font sizes are expressed in half-points
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/06/97   TRM         Creation
*
*********************************************************************

IF VALTYPE( nFontSize ) == "N"
	::nFontSize := nFontSize
	::NumCode( "fs", ::nFontSize*2, .F. )
ENDIF

RETURN NIL
**********************  END OF SetFontSize()  ***********************










METHOD Write( xData, lCodesOK ) CLASS RichText
*********************************************************************
* Description:  Write data to output file, accounting for any characters
*               above ASCII 127 (RTF only deals with 7-bit characters
*               directly) -- 8-bit characters must be handled as hex data.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/06/97   TRM         Creation
*********************************************************************
LOCAL cWrite := ""
LOCAL i, cChar, nChar
LOCAL cString := cValToChar( xData )
LOCAL aCodes := { "\", "{", "}" }
LOCAL aReturn := { CHR(13), CHR(10) }

DEFAULT lCodesOK := .F.

IF ::lTrimSpaces
	cString := RTRIM( cString )
ENDIF

#ifdef __CLIP__
cString := translate_charset(host_charset(), "CP1251", cString)
#else
cString := OEMTOANSI(cString)
#endif

FOR i := 1 TO LEN(cString)

	cChar := SUBSTR(cString, i, 1)
	nChar := ASC(cChar)

	IF nChar < 128

		IF nChar > 91

			// Process special RTF symbols
			IF !lCodesOK
				IF ASCAN( aCodes, cChar ) > 0
					cChar := "\" + cChar
				ENDIF
			ENDIF

		ELSEIF nChar < 33
			IF nChar == 13 // Turn carriage returns into new paragraphs
				cChar := "\par "
			ELSEIF nChar == 10 // Ignore line feeds
				LOOP
			ENDIF
		ENDIF

		cWrite += cChar


	ELSE

		// We have a high-order character, which is a no-no in RTF.
		// If no international translation table for high-order characters
		// is specified, write data verbatim in hex format.  If a
		// translation table is specified, look up the appropriate
		// hex value to write.

		IF EMPTY( ::aTranslate )
			// Ignore soft line breaks
			IF nChar == 141
				LOOP
			ELSE
				cWrite += "\'" + LOWER( NewBase( nChar, 16 ) )
			ENDIF
		ELSE
			cWrite += ::aTranslate[ ASC(cChar)-127 ]
		ENDIF

	ENDIF

NEXT

::OpenGroup()
FWRITE(::hFile, cWrite )
::CloseGroup()

RETURN NIL
*************************  END OF Write()  **************************









METHOD NumCode( cCode, nValue, lScale ) CLASS RichText
*********************************************************************
* Description:  Write an RTF code with a numeric parameter
*               to the output file,
*
*               NOTE: Most RTF numeric measurements must be specified
*               in "Twips" (1/20th of a point, 1/1440 of an inch).
*               However, the interface layer of the RichText class
*               defaults to accept inches.  Therefore, all such
*               measurements must be converted to Twips.
*
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/12/97   TRM         Creation
*
*********************************************************************
LOCAL cWrite := ""

IF VALTYPE(cCode) == "C" .AND. VALTYPE(nValue) == "N"

	cCode := FormatCode(cCode)

	cWrite += cCode

	DEFAULT lScale := .T.
	IF lScale
		nValue := INT( nValue * ::nScale )
	ENDIF
	cWrite += ALLTRIM(STR(nValue)) //+ " "

	FWRITE(::hFile, cWrite )

ENDIF

RETURN NIL
***********************  END OF NumCode()  *************************







METHOD LogicCode( cCode, lTest ) CLASS RichText
*********************************************************************
* Description:  Write an RTF code if the supplied value is true
*
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/12/97   TRM         Creation
*
*********************************************************************

IF VALTYPE(cCode) == "C" .AND. VALTYPE(lTest) == "L"
	IF lTest
		::TextCode( cCode )
	ENDIF
ENDIF

RETURN NIL
***********************  END OF LogicCode()  *************************









FUNCTION FormatCode( cCode )
*********************************************************************
* Description:  Remove extraneous spaces from a code, and make sure
*               that it has a leading backslash ("\").
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/12/97   TRM         Creation
*
*********************************************************************
cCode := ALLTRIM(cCode)
IF !( LEFT(cCode, 1) == "\" )
	cCode := "\" + cCode
ENDIF

RETURN cCode
***********************  END OF FormatCode()  ***********************






METHOD DefineTable( cTblHAlign, nTblFntNum, nTblFntSize, ;
		cCellAppear, cCellHAlign, nTblRows, ;
		nTblColumns, nTblRHgt, aTableCWid, cRowBorder, cCellBorder, nCellPct, ;
		lTblNoSplit, nTblHdRows, nTblHdHgt, nTblHdPct, nTblHdFont, ;
		nTblHdFSize, cHeadAppear, cHeadHAlign ) CLASS RichText
*********************************************************************
* Description:  Define the default setup for a table.
*               This simply saves the parameters to the object's
*               internal instance variables.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/18/97   TRM         Creation
*
*********************************************************************
LOCAL i
DEFAULT ;
	cTblHAlign := "CENTER", ;
	nTblFntNum := 1, ;
	nTblFntSize := ::nFontSize, ;
	nTblRows := 1, ;
	nTblColumns:= 1, ;
	nTblRHgt := NIL, ;
	aTableCWid := ARRAY(nTblColumns), ; // see below
	cRowBorder := "NONE", ;
	cCellBorder := "SINGLE", ;
	nCellPct := 0, ;
	lTblNoSplit := .F., ;
	nTblHdRows := 0, ;
	nTblHdHgt := nTblRHgt, ;
	nTblHdPct := .1, ;
	nTblHdFont := nTblFntNum, ;
	nTblHdFSize := ::nFontSize + 2

	IF aTableCWid[1] == NIL
		AFILL( aTableCWid, 6.5/nTblColumns )
	ELSEIF VALTYPE(aTableCWid[1]) == "A"
		aTableCWid := ACLONE(aTableCWid[1])
	ENDIF

	// Turn independent column widths into "right boundary" info...
	FOR i := 2 TO LEN( aTableCWid )
		aTableCWid[i] += aTableCWid[i-1]
	NEXT

::cTblHAlign := LOWER( LEFT(cTblHAlign, 1) )
::nTblFntNum := nTblFntNum
::nTblFntSize := nTblFntSize
::cCellAppear := cCellAppear
::cCellHAlign := cCellHAlign
::nTblRows := nTblRows
::nTblColumns:= nTblColumns
::nTblRHgt := nTblRHgt
::aTableCWid := aTableCWid
::cRowBorder := ::BorderCode( cRowBorder )
::cCellBorder := ::BorderCode( cCellBorder )
::nCellPct := IIF( nCellPct < 1, nCellPct*10000, nCellPct*100 )
::lTblNoSplit := lTblNoSplit
::nTblHdRows := nTblHdRows
::nTblHdHgt := nTblHdHgt
::nTblHdPct := IIF( nTblHdPct < 1, nTblHdPct*10000, nTblHdPct*100 )
::nTblHdFont := nTblHdFont
::nTblHdFSize := nTblHdFSize
::cHeadAppear := cHeadAppear
::cHeadHAlign := cHeadHAlign

::nCurrColumn := 0
::nCurrRow    := 0

RETURN NIL
**********************  END OF DefineTable()  ***********************











METHOD WriteCell( cText, nFontNumber, nFontSize, cAppear, cHorzAlign, ;
				nSpace, lSpExact, cCellBorder, nCellPct, lDefault ) CLASS RichText
*********************************************************************
* Description:  Write a formatted cell of data to the current row
*               of the current table.  Also takes care of the logic
*               required for headers & header formatting.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/19/97   TRM         Creation
*
*********************************************************************
LOCAL i

DEFAULT ;
	cText := "", ;
	lDefault := .F.

// Increment/reset the column #
IF ::nCurrColumn == ::nTblColumns
	::nCurrColumn := 1
ELSE
	::nCurrColumn += 1
ENDIF


// Apply any one-time formatting for header/body

IF ::nCurrColumn == 1

	IF ::nCurrRow == 0 .AND. ::nTblHdRows > 0

		// Start a separate group for the header rows
		::OpenGroup()
		::BeginRow()

		// We need to apply header formats
		// The "\trgaph108" & "trleft-108" are the defaults used by MS-Word,
		// so if it's good enough for Word, it's good enough for me...

		::TextCode( "trgaph108\trleft-108" )
		::TextCode( "trq" + ::cTblHAlign )
		::Borders( "tr", ::cRowBorder )
		::NumCode( "trrh", ::nTblHdHgt )
		::TextCode( "trhdr" )
		::LogicCode( "trkeep", ::lTblNoSplit )

		// Set the default border & width info for each header cell
		FOR i := 1 TO LEN( ::aTableCWid )
			::NumCode( "clshdng", ::nTblHdPct, .F. )
			::Borders( "cl", ::cCellBorder )
			::NumCode("cellx", ::aTableCWid[i] )
		NEXT

		// Identify the header-specific font
		::NewFont( ::nTblHdFont )
		::SetFontSize( ::nTblHdFSize )
		::Appearance( ::cHeadAppear )
		::HAlignment( ::cHeadHAlign )

		::TextCode( "intbl" )

	ELSEIF ::nCurrRow == ::nTblHdRows

		// The header rows are over,
		// so we need to apply formats to the body of the table.

		// First close the header section, if one exists
		IF ::nTblHdRows > 0
			::EndRow()
			::CloseGroup()
		ENDIF

		::BeginRow()
		::TextCode( "trgaph108\trleft-108" )
		::TextCode( "trq" + ::cTblHAlign )
		::Borders( "tr", ::cRowBorder )
		::NumCode( "trrh", ::nTblRHgt )
		::LogicCode( "trkeep", ::lTblNoSplit )

		// Set the default shading, border & width info for each body cell
		FOR i := 1 TO LEN( ::aTableCWid )
			::NumCode( "clshdng", ::nCellPct, .F. )
			::Borders( "cl", ::cCellBorder )
			::NumCode("cellx", ::aTableCWid[i] )
		NEXT

		// Write the body formatting codes
		::NewFont( ::nTblFntNum )
		::SetFontSize( ::nTblFntSize )
		::Appearance( ::cCellAppear )
		::HAlignment( ::cCellHAlign )

		::TextCode( "intbl" )

	ELSE

		// End of a row of the table body.
		::EndRow()

		// Prepare the next row for inclusion in table
		::TextCode( "intbl" )

	ENDIF

ENDIF



// Apply any cell-specific formatting, and write the text

::OpenGroup()

	::LogicCode( "pard", lDefault )
	::NewFont( nFontNumber )
	::SetFontSize( nFontSize )
	::Appearance( cAppear )
	::HAlignment( cHorzAlign )
	::LineSpacing( nSpace, lSpExact )
	::Borders( "cl", cCellBorder )
	::NumCode( "clshdng", nCellPct, .F. )

	// Now write the text
	::Write( cText )

::CloseGroup()

// Close the cell
::TextCode( "cell" )

RETURN NIL
***********************  END OF WriteCell()  ************************









METHOD NewSection( lLandscape, nColumns, nLeft, nRight, nTop, nBottom, ;
				nWidth, nHeight, cVertAlign, lDefault ) CLASS RichText
*********************************************************************
* Description:  Open a new section, with optional new formatting
*               properties.
*
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/26/97   TRM         Creation
*********************************************************************
DEFAULT lDefault := .F.

//::OpenGroup()
::TextCode( "sect" )

IF lDefault
	::TextCode( "sectd" )
ENDIF

::LogicCode( "lndscpsxn", lLandscape )
::NumCode( "cols", nColumns, .F. )
::NumCode( "marglsxn", nLeft )
::NumCode( "margrsxn", nRight )
::NumCode( "margtsxn", nTop )
::NumCode( "margbsxn", nBottom )
::NumCode( "pgwsxn", nWidth )
::NumCode( "pghsxn", nHeight )

IF !EMPTY( cVertAlign )
	::TextCode( "vertal" + LOWER( LEFT(cVertAlign,1) ) )
ENDIF

RETURN NIL
***********************  END OF NewSection()  **********************







METHOD NewFont( nFontNumber ) CLASS RichText
*********************************************************************
* Description:  Change the current font.
*               Converts app-level font number into RTF font number.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/19/97   TRM         Creation
*
*********************************************************************

IF !EMPTY(nFontNumber) .AND. nFontNumber <= ::nFontNum
	::NumCode( "f", nFontNumber-1, .F. )
ENDIF

RETURN NIL
************************  END OF NewFont()  *************************








METHOD Appearance( cAppear ) CLASS RichText
*********************************************************************
* Description:  Change the "appearance" (bold, italic, etc.)
*               Appearance codes are concatenable at the app-level
*               and already contain backslashes.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/19/97   TRM         Creation
*
*********************************************************************

// Special case (see .CH file) -- first remove leading slash ...ugh.
IF !EMPTY(cAppear)
	::TextCode( SUBSTR(cAppear, 2) )
ENDIF

RETURN NIL
***********************  END OF Appearance()  ***********************







METHOD HAlignment( cAlign ) CLASS RichText
*********************************************************************
* Description:  Change the horizontal alignment
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/19/97   TRM         Creation
*
*********************************************************************
IF !EMPTY(cAlign)
	::TextCode( "q" + LOWER(LEFT(cAlign,1)) )
ENDIF

RETURN NIL
**********************  END OF HAlignment()  ************************








METHOD LineSpacing( nSpace, lSpExact ) CLASS RichText
*********************************************************************
* Description:  Change the line spacing (spacing can either be "exact"
*               or "multiple" (of single spacing).  If exact, the units
*               of the supplied value must be converted to twips.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/19/97   TRM         Creation
*
*********************************************************************
DEFAULT lSpExact := .F.

::NumCode( "sl", nSpace, lSpExact )
IF !EMPTY( nSpace )
	::NumCode( "slmult", IIF( lSpExact, 0, 1 ), .F. )
ENDIF


RETURN NIL
**********************  END OF LineSpacing()  ***********************








METHOD Borders( cEntity, cBorder ) CLASS RichText
*********************************************************************
* Description:  Apply borders to rows or cells.  Currently limited to
*               one type of border per rectangle.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/19/97   TRM         Creation
*
*********************************************************************
LOCAL i, aBorder := { "t", "b", "l", "r" }

IF VALTYPE( cBorder ) == "C"
	FOR i := 1 TO 4
		::TextCode( cEntity + "brdr" + aBorder[i] + "\brdr" + cBorder )
	NEXT
ENDIF

RETURN NIL
************************  END OF Borders()  *************************






METHOD BorderCode( cBorderID ) CLASS RichText
*********************************************************************
* Description:  Convert an application-level border ID into
*               a valid RTF border code.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/19/97   TRM         Creation
*
*********************************************************************
LOCAL cBorderCode := "", n
LOCAL aBorder := ;
	{ ;
	{ "NONE",        NIL   }, ;
	{ "SINGLE",      "s"   }, ;
	{ "DOUBLETHICK", "th"  }, ;
	{ "SHADOW",      "sh"  }, ;
	{ "DOUBLE",      "db"  }, ;
	{ "DOTTED",      "dot" }, ;
	{ "DASHED",      "dash"}, ;
	{ "HAIRLINE",    "hair"}  ;
	}

cBorderID := UPPER( RTRIM(cBorderID) )

n := ASCAN( aBorder, { |x| x[1] == cBorderID } )

IF n > 0
	cBorderCode := aBorder[n][2]
ENDIF

RETURN cBorderCode
************************  END  OF BorderCode()  *********************








FUNCTION IntlTranslate()
*********************************************************************
* Description:  Example of an array that could be used to map
*               high-order characters.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/06/97   TRM         Creation
*
*********************************************************************
LOCAL i
LOCAL aTranslate[128]
LOCAL aHighTable := ;
	{ ;
	"\'fc", "\'e9", "\'e2", "\'e4", "\'e0", "\'e5", "\'e7", "\'ea", ;
	"\'eb", "\'e8", "\'ef", "\'ee", "\'ec", "\'c4", "\'c5", "\'c9", ;
	"\'e6", "\'c6", "\'f4", "\'f6", "\'f2", "\'fb", "\'f9", "\'ff", ;
	"\'d6", "\'dc", "\'a2", "\'a3", "\'a5", "\'83", "\'ed", "\'e1", ;
	"\'f3", "\'fa", "\'f1", "\'d1", "\'aa", "\'ba", "\'bf" ;
	}

AFILL( aTranslate, "" )

FOR i := 1 TO LEN( aHighTable )
	aTranslate[i] := aHighTable[i]
NEXT

RETURN aTranslate
**********************  END OF IntlTranslate()  *********************








FUNCTION NewBase( nDec, nBase )
*********************************************************************
* Description:  Convert a decimal numeric to a string in another
*               base system
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/12/97   TRM         Creation
*
*********************************************************************
LOCAL cNewBase := "", nDividend, nRemain, lContinue := .T., cRemain

DO WHILE lContinue

	nDividend := INT( nDec / nBase )
	nRemain := nDec % nBase

	IF nDividend >= 1
		nDec := nDividend
	ELSE
		lContinue := .F.
	ENDIF

	IF nRemain < 10
		cRemain := ALLTRIM(STR(nRemain,2,0))
	ELSE
		cRemain := CHR( nRemain + 55 )
	ENDIF

	cNewBase := cRemain + cNewBase

ENDDO

RETURN cNewBase
************************  END OF NewBase()  *************************

