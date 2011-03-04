/*
+--------------------------------------------------------------------------+
|         Name: RTFDemo.prg                                                |
|  Description: Demo of RichText() Class                                   |
|     Language: Clipper/Fivewin                                            |
|      Version: 0.90                                                       |
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


#ifdef __CLIP__
#include "objects.ch"
#else
#include "fiveWin.ch"
#endif
#include "richtext.ch"


RTFDemo()

FUNCTION RTFDemo()
*********************************************************************
* Description:  Demo of selected features of RichText() Class.
*               This demo will create a multi-page RTF file with
*               various fonts, page orientations, layouts, etc.
*               Requires files FLOWERS.DBF & DBT and VEGGIES.DBF
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/28/97   TRM         Creation
*
*********************************************************************
LOCAL cOutFile := "RTFDEMO.RTF",cErr
//LOCAL bMeter := { |oMeter| GardenDoc( oMeter, cOutFile ) }
IF FILE( "FLOWERS.DBF" ) .AND. FILE( "VEGGIES.DBF" )

	qout("Generating sample report...")
	GardenDoc( , cOutFile )



ELSE

	qout("Files FLOWERS.DBF & DBT and VEGGIES.DBF are required for demo.")

ENDIF
/*
IF FILE( "FLOWERS.DBF" ) .AND. FILE( "VEGGIES.DBF" )

	MsgMeter( bMeter, "Generating sample report...", "RichText() Demo" )


     cErr:=winexec("start winword.exe rtfdemo.rtf",0)

ELSE

	MsgInfo( "Files FLOWERS.DBF & DBT and VEGGIES.DBF are required for demo." )
	qout("Files FLOWERS.DBF & DBT and VEGGIES.DBF are required for demo.")

ENDIF
*/
RETURN NIL
************************  END OF RTFDemo()  *************************







STATIC FUNCTION GardenDoc( oMeter, cOutFile)
*********************************************************************
* Description:  Demo of selected features of RichText() Class
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/28/97   TRM         Creation
*
*********************************************************************
LOCAL oRTF, n := 0

//oMeter:nTotal := 5

//      Open the output file & set some defaults

	oRTF := SetupRTF( cOutFile )
	//oMeter:Set( ++n )
	//SysRefresh()


//      Demonstrate basics -- fonts, text appearance, hanging indents, etc.

	CoverPage( oRTF )
	//oMeter:Set( ++n )
	//SysRefresh()

//      Demonstrate a simple DBF output

	DBFToRTF( oRTF, "VEGGIES.DBF", .F. )
	//oMeter:Set( ++n )
	//SysRefresh()

//      Demonstrate mixed orientation (i.e, change to landscape)
// and a DBF with memos.

	DBFToRTF( oRTF, "FLOWERS.DBF", .T. )
	//oMeter:Set( ++n )
	//SysRefresh()


//      Demonstrate same memo text formatted in snaked columns
//      in portrait orientation

	FlowerColumns( oRTF, "FLOWERS.DBF" )
	//oMeter:Set( ++n )
	//SysRefresh()


//      Close the output file
	CLOSE RTF oRTF

RETURN NIL
**********************  END OF GardenDoc()  **********************







STATIC FUNCTION SetupRTF( cOutFile)
*********************************************************************
* Description:
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/28/97   TRM         Creation
*
*********************************************************************
LOCAL oRTF

DEFINE RTF oRTF FILE cOutFile ;
	FONTS "Times New Roman Cyr", "Arial Cyr", "Courier New Cyr" ;
	FONTSIZE 12 ;
	TWIPFACTOR 1440

// Trim trailing spaces from data, to save file space.
oRTF:lTrimSpaces := .T.

DEFINE PAGESETUP oRTF MARGINS 1.75, 1.75, 1, 1 ;
	TABWIDTH .5 ;
	ALIGN CENTER

BEGIN HEADER oRTF
	NEW PARAGRAPH oRTF TEXT "Sample RTF Output" ;
		FONTSIZE 14 ;
		ALIGN CENTER
END HEADER oRTF

BEGIN FOOTER oRTF
	NEW PARAGRAPH oRTF TEXT DTOC( DATE() ) ;
		FONTSIZE 12 ;
		ALIGN CENTER
END HEADER oRTF

RETURN oRTF
**********************  END OF SetupRTF()  ***********************







STATIC FUNCTION CoverPage( oRTF )
*********************************************************************
* Description:  Generate a cover page.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/28/97   TRM         Creation
*
*********************************************************************
LOCAL i
LOCAL aTitle[3]
LOCAL aBullet[5]

//      First, load some text...

aTitle[1] := "Garden Example Summary"
aTitle[2] := "Spring is almost here!"
aTitle[3] := "(...in the north hemisphere)"

aBullet[1] := "This report is a  some possibilites demonstration " + ;
			"of class RichText() for Clipper & Fivewin.  Written by" + ;
			" Tom Marchione (73313,3626@compuserve.com).  Contact with hem by e-mail," + ;
			" if you have any sugressions or comments."

aBullet[2] := "RichText() lets you generate reports to RTF files, like this " + ;
			"one.  RTF files can be read by most word processors, so this " + ;
			"is a way to move fully-formatted information into word processor " + ;
			"format, without lots of extraneous spaces and carriage returns."

aBullet[3] := "RichText() isn't meant to be a front-line report engine, in " + ;
			"its current form.  But it can be very useful for meeting specialized, " + ;
			"custom reporting requirements.  If your app needs to generate " + ;
			"true word processing files, this can be a useful, if " + ;
			"slightly off-the-wall, approach."

aBullet[4] := "In its current form, the system is very quirky (read: full " + ;
			"of bugs), but it has reached a point where I think it can be " + ;
			"useful to someone, so I chose to offer it publicly now."

aBullet[5] := "The pages that follow contain some examples of the types of " + ;
			"things that can be done with RichText().  Remember, RichText() " + ;
			"is designed to link to a word processor, so its capabilities " + ;
			"focus on standard word processing features, rather than the " + ;
			"kinds of things that are important in a standard report " + ;
			"generator.  Hope you find it useful!"


// Write the title lines

NEW PARAGRAPH oRTF TEXT aTitle[1] ;
	FONTNUMBER 1 ;
	FONTSIZE 18 ;
	APPEARANCE BOLD_ON ;
	ALIGN CENTER ;
	SETDEFAULT

NEW PARAGRAPH oRTF TEXT aTitle[2] ;
	FONTSIZE 14 ;
	APPEARANCE BOLD_OFF + ITALIC_ON ;
	ALIGN CENTER

NEW PARAGRAPH oRTF TEXT aTitle[3] ;
	FONTSIZE 8 ;
	ALIGN CENTER

NEW PARAGRAPH oRTF TEXT "" ;
	APPEARANCE ITALIC_OFF ;
	SETDEFAULT


// Write the bullet items

FOR i := 1 TO LEN( aBullet )

	NEW PARAGRAPH oRTF TEXT aBullet[i] ;
		FONTNUMBER 2 ;
		FONTSIZE 11 ;
		ALIGN LEFT ;
		INDENT .25 ;
		FIRSTINDENT -.25 ;
		BULLETED ;
		SPACEBEFORE .4 ;
		SETDEFAULT

NEXT

NEW PARAGRAPH oRTF TEXT "" SETDEFAULT

RETURN NIL
************************  END OF CoverPage()  ***********************









STATIC FUNCTION DBFToRTF( oRTF, cFile, lLandScape )
*********************************************************************
* Description:  Format specified DBF into an RTF Table
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/28/97   TRM         Creation
*
*********************************************************************
LOCAL i, nWidth, aStruc
LOCAL aFldNames := {}, aColWidth := {}
LOCAL nTotWidth := 0, cName

USE (cFile) ALIAS MyFile NEW EXCLUSIVE

aStruc := DBSTRUCT()

FOR i := 1 TO LEN( aStruc )

	IF LEFT(aStruc[i][2], 1) == "M"
		// Default memo Columns to 4 inches wide
		nWidth := 4
	ELSE
		// Default non-memo columns to 1/10th of field width
		nWidth := (aStruc[i][3] + aStruc[i][4])/10

		// Stretch column width to width of header, if necessary
		nWidth := MAX( nWidth, LEN(ALLTRIM(aStruc[i][1]))/9 )

		// Place a limit of 5 inches on the width of any single column
		nWidth := MIN( nWidth, 5 )
	ENDIF

	nTotWidth += nWidth
	IF nTotWidth <= 10
		AADD( aFldNames, ALLTRIM( aStruc[i][1] ) )
		AADD( aColWidth, nWidth )
	ELSE
		EXIT // For demo, only include enough columns as will fit
	ENDIF

NEXT
aStruc := NIL


// Begin a new section of the document

IF lLandScape
	NEW SECTION oRTF ;
		LANDSCAPE ;
		PAGEWIDTH 11 ;
		PAGEHEIGHT 8.5 ;
		MARGINS .5, .5, .5, .5 ;
		ALIGN CENTER ;
		SETDEFAULT
ELSE
	NEW SECTION oRTF ;
		PAGEWIDTH 8.5 ;
		PAGEHEIGHT 11 ;
		MARGINS .5, .5, .5, .5 ;
		ALIGN CENTER ;
		SETDEFAULT
ENDIF

// Define the table

DEFINE TABLE oRTF ;              // Specify the RTF object
	ALIGN CENTER ;                // Center table horizontally on page
	FONTNUMBER 2 ;                // Use font #2 for the body rows
	FONTSIZE 9 ;                  // Use 9 Pt. font for the body rows
	CELLAPPEAR BOLD_OFF ;         // Normal cells unbolded
	CELLHALIGN LEFT ;             // Text in normal cells aligned left
	COLUMNS LEN(aFldNames) ;      // Table has n Columns
	CELLWIDTHS aColWidth ;        // Array of column widths
	ROWHEIGHT .25 ;               // Minimum row height is .25"
	CELLBORDERS SINGLE ;          // Outline cells with thin border
	HEADERROWS 1 ;                // One row to be treated as the header
		HEADERHEIGHT .5 ;          // Header rows are min. .5" high
		HEADERSHADE 25 ;           // Header shading is 25%
		HEADERFONT 1 ;             // Use font #1 for the header
		HEADERFONTSIZE 10 ;        // Use 10 Pt. font for the header
		HEADERAPPEAR BOLD_ON ;     // Header cells are bold
		HEADERHALIGN CENTER        // Text in header cells is centered

// Write the header row, using field names as titles
FOR i := 1 TO oRTF:nTblColumns

	// Abbreviate column headers that are disproportionately long
	cName := aFldNames[i]
	IF LEN( cName ) > aColWidth[i]
		cName := LEFT( cName, aColWidth[i]-1 ) + "."
	ENDIF
	WRITE CELL oRTF TEXT aFldNames[i]

NEXT

// Write the data rows
DO WHILE !EOF()
	FOR i := 1 TO oRTF:nTblColumns
		WRITE CELL oRTF TEXT FIELDGET(i)
	NEXT
	DBSKIP()
ENDDO

// Close the table
CLOSE TABLE oRTF

MyFile->(DBCLOSEAREA())

RETURN NIL
***********************  END OF DBFToRTF()  *********************





STATIC FUNCTION FlowerColumns( oRTF, cFile )
*********************************************************************
* Description:  Format FLOWERS.DBF memo data as prose in snaking
*               columns.
* Arguments:
* Return:
*
*--------------------------------------------------------------------
* Date       Developer   Comments
* 01/28/97   TRM         Creation
*
*********************************************************************
LOCAL cText, i := 0

USE (cFile) ALIAS MyFile NEW EXCLUSIVE

oRTF:lTrimSpaces := .F.

// Begin a new section of the document, in order
// to switch page orientation back to portrait.

NEW SECTION oRTF ;
	COLUMNS 2 ;
	PAGEWIDTH 8.5 ;
	PAGEHEIGHT 11 ;
	MARGINS .75, .75, 1, 1 ;
	ALIGN TOP ;
	SETDEFAULT

DO WHILE !EOF()

	++i
	IF i > 1
		NEW PARAGRAPH oRTF TEXT ""
	ENDIF

	NEW PARAGRAPH oRTF TEXT RTRIM(MyFile->Name) + ".  " ;
		FONTNUMBER 1 ;
		FONTSIZE 14 ;
		APPEARANCE BOLD_ON + ITALIC_ON ;
		ALIGN JUSTIFY ;
		SPACEBEFORE IIF( i == 1, 0, .4 ) ;
		SETDEFAULT ;
		NORETURN

	cText := MyFile->Descriptio

	NEW PARAGRAPH oRTF TEXT cText ;
		APPEARANCE BOLD_OFF + ITALIC_OFF ;
		NORETURN

	DBSKIP()

ENDDO

MyFile->(DBCLOSEAREA())

RETURN NIL
***********************  END OF FlowerColumns()  *********************






