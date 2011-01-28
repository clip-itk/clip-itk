/*
+--------------------------------------------------------------------------+
|        Class: RichText                                                   |
|  Description: System for generating simple RTF files.                    |
|     Language: Clipper/Fivewin                                            |
|      Version: 0.90 -- This is a usable, but incomplete, version that is  |
|               being distributed in case anyone cares to use it as-is,    |
|               or wants to comment on it.                                 |
|         Date: 01/28/97                                                   |
|       Author: Tom Marchione                                              |
|     Internet: 73313,3626@compuserve.com                                  |
|                                                                          |
|    Copyright: (C) 1997, Thomas R. Marchione                              |
|       Rights: Use/modify freely for applicaton work, under the condition |
|               that you include the original author's credits (i.e., this |
|               header), and you do not offer the source code for sale.    |
|               The author may or may not supply updates and revisions     |
|               to this code as "freeware".                                |
|                                                                          |
|   Warranties: None. The code has not been rigorously tested in a formal  |
|               development environment, and is offered as-is.  The author |
|               assumes no responsibility for its use.                     |
|                                                                          |
|    Revisions:                                                            |
|                                                                          |
|    DATE       AUTHOR  COMMENTS                                           |
+--------------------------------------------------------------------------+
|    01/28/97   TRM     Date of initial release                            |
|                                                                          |
|                                                                          |
|                                                                          |
|                                                                          |
|                                                                          |
+--------------------------------------------------------------------------+
*/


#define INCH_TO_TWIP 1440

// Text Styles
// These are special cases, defined with the RTF backslash, so that
// they can be easily concatenated at the application level.

#define BOLD_ON       "\b"
#define ITALIC_ON     "\i"
#define UNDERLINE_ON  "\ul"
#define CAPS_ON       "\caps"

#define STYLE_OFF     "0"
#define BOLD_OFF      BOLD_ON + STYLE_OFF
#define ITALIC_OFF    ITALIC_ON + STYLE_OFF
#define UNDERLINE_OFF UNDERLINE_ON + STYLE_OFF
#define CAPS_OFF      CAPS_ON + STYLE_OFF


// DEFAULTS:

// Font:        Courier New
// Font Size:   12 Point
// Units:       Inches (i.e., same as "TWIPFACTOR INCH_TO_TWIP")
// Page Setup:  Standard RTF file format defaults


#xcommand DEFINE RTF [<oRTF>] ;
		[ <filename: FILE, FILENAME> <cFileName> ] ;
		[ <fontname: FONTS, FONTNAMES> <aFontData,...> ] ;
		[ FONTSIZE <nFontSize> ] ;
		[ TWIPFACTOR <nScale> ] ;
		[ HIGHORDERMAP <aHigh> ] ;
	=> ;
		[ <oRTF> := ] RichText():New( <cFileName>, [\{<aFontData>\}], ;
					<nFontSize>, <nScale>, <aHigh> )

#xcommand CLOSE RTF <oRTF> => <oRTF>:End()


// If used, DEFINE PAGESETUP should come immediately after DEFINE RTF
// NOTE: Page numbering is not supported yet in base class

#xcommand DEFINE PAGESETUP <oRTF> ;
		[ MARGINS <nLeft>, <nRight>, <nTop>, <nBottom> ] ;
		[ PAGEWIDTH <nWidth> ] ;
		[ PAGEHEIGHT <nHeight> ] ;
		[ TABWIDTH <nTabWidth> ] ;
		[ <landscape: LANDSCAPE> ] ;
		[ <lNoWidow: NOWIDOW> ] ;
		[ ALIGN <vertalign: TOP, BOTTOM, CENTER, JUSTIFY> ] ;
		[ PAGENUMBERS <cPgnumPos: LEFT, RIGHT, CENTER> ] ; // not supported
		[ <lPgnumTop: PAGENUMBERTOP> ] ; // not supported
	=> ;
		<oRTF>:PageSetup( <nLeft>, <nRight>, <nTop>, <nBottom>, ;
				 <nWidth>, <nHeight>, <nTabWidth>, <.landscape.>, <.lNoWidow.>, ;
				 <"vertalign"> , <cPgnumPos>, <.lPgnumTop.> )


// Use these to enclose data to be included in headers & footers
#xcommand BEGIN HEADER <oRTF> => <oRTF>:BeginHeader()
#xcommand END HEADER <oRTF> => <oRTF>:EndHeader()

#xcommand BEGIN FOOTER <oRTF> => <oRTF>:BeginFooter()
#xcommand END FOOTER <oRTF> => <oRTF>:EndFooter()


// Use this to write formatted text within a paragraph
#xcommand WRITE TEXT <oRTF> ;
		[ TEXT <cText> ] ;
		[ FONTNUMBER <nFontNumber> ] ;
		[ FONTSIZE <nFontSize> ] ;
		[ APPEARANCE <cAppear> ] ;
		[ <lDefault: SETDEFAULT > ] ;
	=> ;
		<oRTF>:Paragraph( <cText>, <nFontNumber>, <nFontSize>, <cAppear>, ;
				,,,,,,,,,,,,,, <.lDefault.>, .T. )

// Use this to write an entire paragraph, with optional formatting.
#xcommand NEW PARAGRAPH <oRTF> ;
		[ TEXT <cText> ] ;
		[ FONTNUMBER <nFontNumber> ] ;
		[ FONTSIZE <nFontSize> ] ;
		[ APPEARANCE <cAppear> ] ;
		[ ALIGN <cHorzAlign: LEFT, RIGHT, CENTER, JUSTIFY> ] ;
		[ TABSTOPS <aTabPos,...> ] ;
		[ <indent: INDENT, LEFTINDENT> <nIndent> ] ;
		[ FIRSTINDENT <nFIndent> ] ;
		[ RIGHTINDENT <nRIndent> ] ;
		[ LINESPACE <nSpace> [ <lSpExact: ABSOLUTE>] ] ;
		[ SPACEBEFORE <nBefore> ] ;
		[ SPACEAFTER <nAfter> ] ;
		[ <lNoWidow: NOWIDOW> ] ;
		[ <lBreak: NEWPAGE > ] ;
		[ <lBullet: BULLET, BULLETED > [ BULLETCHAR <cBulletChar> ];
			[ HANGING <lHang> ] ] ;
		[ <lDefault: SETDEFAULT > ] ;
		[ <lNoPar: NORETURN> ] ;
	=> ;
		<oRTF>:Paragraph( <cText>, <nFontNumber>, <nFontSize>, <cAppear>, ;
				<"cHorzAlign">, [\{<aTabPos>\}], <nIndent>, ;
				<nFIndent>, <nRIndent>, <nSpace>, <.lSpExact.>, ;
				<nBefore>, <nAfter> , <.lNoWidow.>, <.lBreak.>, ;
				<.lBullet.>, <cBulletChar>, <.lHang.>, <.lDefault.>, <.lNoPar.> )


// Use this to begin a new table
#xcommand DEFINE TABLE <oRTF> ;
		[ ALIGN <cHorzAlign: LEFT, RIGHT, CENTER> ] ;
		[ FONTNUMBER <nFontNumber> ] ;
		[ FONTSIZE <nFontSize> ] ;
		[ CELLAPPEAR <cCellAppear> ] ;
		[ CELLHALIGN <cCellHAlign: LEFT, RIGHT, CENTER> ] ;
		[ ROWS <nRows> ] ;
		[ COLUMNS <nColumns> ] ;
		[ CELLWIDTHS <aColWidths,...> ] ;
		[ ROWHEIGHT <nHeight> ] ;
		[ ROWBORDERS <cRowBorder: SINGLE, DOUBLETHICK, SHADOW, DOUBLE, ;
			DOTTED, DASHED, HAIRLINE > ] ;
		[ CELLBORDERS <cCellBorder: SINGLE, DOUBLETHICK, SHADOW, DOUBLE, ;
			DOTTED, DASHED, HAIRLINE > ] ;
		[ CELLSHADE <nCellPct> ] ;
		[ <lNoSplit: NOSPLIT> ] ;
		[ HEADERROWS <nHeadRows> ;
			[ HEADERHEIGHT <nHeadHgt> ] ;
			[ HEADERSHADE <nHeadPct> ] ;
			[ HEADERFONT <nHeadFont> ] ;
			[ HEADERFONTSIZE <nHFontSize> ] ;
			[ HEADERAPPEAR <cHeadAppear> ] ;
			[ HEADERHALIGN <cHeadHAlign: LEFT, RIGHT, CENTER> ] ;
		] ;
	=> ;
		<oRTF>:DefineTable( <"cHorzAlign">, <nFontNumber>, <nFontSize>, ;
				<cCellAppear>, <"cCellHAlign">, <nRows>, ;
				<nColumns>, <nHeight>, [\{<aColWidths>\}], <"cRowBorder">, ;
				<"cCellBorder">, <nCellPct>, <.lNoSplit.>, <nHeadRows>, ;
				<nHeadHgt>, <nHeadPct>, <nHeadFont>, <nHFontSize>, ;
				<cHeadAppear>, <"cHeadHAlign"> )


#xcommand CLOSE TABLE oRTF => oRTF:EndRow() ; oRTF:TextCode("pard")


// Use this to begin/end a row of the table
// NOTE: After the first row, the class will automatically
// start new rows as necessary, based on # of columns

#xcommand BEGIN ROW oRTF => oRTF:BeginRow()
#xcommand END ROW oRTF => oRTF:EndRow()


// Use this to write the next cell in a table
#xcommand WRITE CELL <oRTF> ;
		[ TEXT <cText> ] ;
		[ FONTNUMBER <nFontNumber> ] ;
		[ FONTSIZE <nFontSize> ] ;
		[ APPEARANCE <cAppear> ] ;
		[ ALIGN <cHorzAlign: LEFT, RIGHT, CENTER, JUSTIFY> ] ;
		[ LINESPACE <nSpace> [ <lSpExact: ABSOLUTE>] ] ;
		[ CELLBORDERS <cCellBorder: SINGLE, DOUBLETHICK, SHADOW, DOUBLE, ;
			DOTTED, DASHED, HAIRLINE > ] ;
		[ CELLSHADE <nCellPct> ] ;
		[ <lDefault: SETDEFAULT > ] ;
	=> ;
		<oRTF>:WriteCell( <cText>, <nFontNumber>, <nFontSize>, <cAppear>, ;
				<"cHorzAlign">, <nSpace>, <lSpExact>, <"cCellBorder">, ;
				<nCellPct>, <.lDefault.> )


// Use this to begin a new section -- for example, to change the page
// orientation, or the paper size, or the number of columns.

#xcommand NEW SECTION oRTF ;
		[ <landscape: LANDSCAPE> ] ;
		[ COLUMNS <nColumns> ] ;
		[ MARGINS <nLeft>, <nRight>, <nTop>, <nBottom> ] ;
		[ PAGEWIDTH <nWidth> ] ;
		[ PAGEHEIGHT <nHeight> ] ;
		[ ALIGN <vertalign: TOP, BOTTOM, CENTER, JUSTIFY> ] ;
		[ <lDefault: SETDEFAULT > ] ;
	=> ;
		oRTF:NewSection( <.landscape.>, <nColumns>, ;
				<nLeft>, <nRight>, <nTop>, <nBottom>, ;
				<nWidth>, <nHeight>, <"vertalign">, <.lDefault.> )


