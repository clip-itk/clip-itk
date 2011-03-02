/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
#include "set.ch"
MEMVAR __mrow,__mcol,_HdColor,_cLookText

* This is the default maximum line length
#define MAXBROWSELENGTH 600
**********
PROC ShowFile(cFile)
LOCAL i
PRIVATE _TextViewer
IF Type('__aExt')=='A' .AND. (i:=ASCAN(m->__aExt,{|_1|LIKE(_1[1],cFile)}))#0
	m->_TextViewer:=m->__aExt[i,2]
ENDIF
ViewFiles(cFile)
**********
PROC ViewFiles(cFile,bApply,lCheckExist)
/*
Lightweight version for bdbf.
Show file cFile.
May use internal viewer (with printing, syntax highlighting etc).
or external defined in _TextViewer variable.
If used internal viewer, you may specify 'bApply' code block
for transform strings.

Examples:
	_TextViewer:='WpView'
	ViewFiles('MyFile.prn')
	ViewFiles('Help.txt',{|_1|StrTran(_1,chr(K_TAB),SPACE(8))})
*/
LOCAL oldc:=SetCursor(0)
IF_NIL bApply IS {|_1|RemoveTabs(_1)}

SET DEVI TO SCRE
SET PRINTER TO
IF EMPTY(lCheckExist) .OR. IsFileExist(@cFile,'')

  IF !IsPCharacter('_textViewer') .OR. Empty(m->_TextViewer)
	FileBrowse(cFile,0,0,__mrow-1,__mcol,;
		   'w+/b','b+/b','b+/w','r+/bg',;
		   bApply,{  { '~~R', 'W+/R'  }, { '~~7', 'W/N' },;
			{ '~~N', 'N/R'   }, { '~~D', NIL   } })
  ELSE
	BliRun(m->_TextViewer+' '+cFile)
  ENDIF
ENDIF

SetCursor(oldc)
**********
FUNC RemoveTabs(cOrigin)
LOCAL cOut:='', nLen:=0, nPos:=1, cDo
DO WHILE nPos<>0
	nPos:=Parce(cOrigin,chr(K_TAB),@cDo,@cOrigin)
	cOut+=cDo
	nLen+=LEN(cDo)
	IF nPos>0
		nPos := m->_nMemoTab - (nLen % m->_nMemoTab)  //+ 1
		nLen+=nPos
		cOut+=SPACE(nPos)
	ENDIF
ENDDO
RETURN cOut
/*************************************************************************
 Browse Function By: Tom Claffy  March 1993
 Adopted for BDBF by ELB :-)

*/

/*************************************************************************
 Syntax	FileBrowse( <cFileName>, [<nTop>], [<nLeft>],
			[<nBottom>], [<nRight>], [<cWinColor>],
			[<cBoxColor>], [<cBarColor>], [<cButtonColor>],
			[<bApplyText>], [<aDispColors>] )

 Arguments	<cFileName> DOS file to browse. Provide your own
			error trapping prior to calling FileBrowse().
			This function assumes a valid, readable file.
		<nTop>, <nLeft>, <nBottom>, <nRight> browse window
			coordinates; If not specified, defaults to 0,0,
			MaxRow(),MaxCol()
		<cWinColor>, <cBoxColor>, <cBarColor>, <cButtonColor>
			Clipper color strings; If not specified, defaults to
			SetColor(), Setcolor(), "W/N", "N/W" respectively.
		<bApplyText>	An optional code block which will be
			applied to each line of text as it is extracted
			from the file allowing control codes, etc. to be
			removed prior to display
		<aDispColors> An optional array of codes and Clipper color
			strings to affect the display colors. Each element of
			the array contains { cCode, cColorString }. Each
			cCode used must begin with a common delimiter and
			contain a unique identifier. Example:
			 { { '~~WR', 'W+/R' }, { ~~BW, 'B/W' } } where
			~~ is the common delimiter and WR or BW is the
			unique identifier portion of each cCode.
			Imbed the cCode in the text file to display the text
			in the corresponding color. Each color change is
			only applicable to the end of the  current line or
			another cCode is encountered; subsequent lines revert
			to the default cWinColor. If not specified, all
			output will be in the cWinColor.
**************************************************************************/

PROC FILEBROWSE(cFileName,nTop,nLeft,nBottom,nRight,cWinColor,;
		cBoxColor,cBarColor,cButtonColor,bApplyText,aDispColors)
// the browse variables
LOCAL	aLines,;
	lApplyBlock := (valtype(bApplyText) == "B"),;
	lHitBottom := .f.,;
	nHandle := FOPEN( cFileName, 64 ),;
	nKey := 0,nLastOffset := 0,;
	nLastLine := 0,nLeftBrowse := 1,nLengthBrowse,nMaxRight := 0
LOCAL	nSize := FSEEK( nHandle, 0, 2 )
// for the ScrollBar
LOCAL	nRow,nBarTop,nBarBottom
// for the search function
LOCAL	nHighliteLine := 0, nHighliteOffset := 0, nLength,;
	nLastFind, nTotalFound, i
// ELB For showing row
LOCAL nCurrRow:=1,nTemp,nEndest:=1
LOCAL _mX,_mY,bOrigin,lWasF8:=.F.,_r,_c, nStart
PRIVATE _CodePage
SavePos()

_cLookText:='' 	//need for Getname()
bOrigin:=bApplyText	//switch by F8

// move back to the top of the file
FSEEK(nHandle,0)
// set the defaults
IF_NIL nTop IS 0
IF_NIL nLeft IS 0
IF_NIL nBottom IS m->__mrow-1
IF_NIL nRight IS m->__mcol
IF_NIL cWinColor IS setcolor()
IF_NIL cBoxColor IS setcolor()
IF_NIL cBarColor IS 'W/N'
IF_NIL cButtonColor IS 'N/W'
// Set other vars; NOTE: if you change the window look at these carefully
nRow = nTop+1
nBarTop = nTop+1
nBarBottom = nBottom-1
nLastLine = nBarBottom - nTop
nLengthBrowse = (nRight - nLeft - 2 )
// declare and fill the array
aLines:=Ext_arr(,nLastLine,{'',0,0})
DownFillArray(nHandle,aLines,1,nLastLine,lApplyBlock,bApplyText)

PUSH KEYS COLOR cWinColor
m->Main_keys:=FB_M_Keys
m->Alt_keys[7]:=FB_A_Key
m->Alt_keys[8]:=FB_C_Key
// paint the screen
DISPBEGIN()
//Scroll(nTop,nLeft,nBottom,nRight)
DISPBOX(nTop,nLeft,nBottom,nRight,FRAME1,cBoxColor)
@ nTop,nLeft+1 SAY cFileName COLOR cBarColor
*@ nTop,nRight SAY '' COLOR cBoxColor
*@ nBottom,nRight SAY '' COLOR cBoxColor

// Primary ScrollBar
FOR i := nBarTop TO nBarBottom
	@ i,nRight SAY '°' COLOR cBarColor // utf-8: 'â–‘'
NEXT

DISPEND()

WHILE .t.
   // reset default values
   nMaxRight := nLastOffset := 0
   // display the screen
   DISPBEGIN()
   LineDisp(aLines,nTop,nLeft,nLeftBrowse,nLengthBrowse,;
		@nMaxRight,@nLastOffset,aDispColors,nLastLine,cWinColor)
   IF nHighliteLine # 0  // highlight the search text
	nHighliteLine = HIGHLIGHT(_cLookText,nHighliteOffset-nLeftBrowse+1,;
				  nTop+nHighliteLine,nLeft+1)
   ENDIF

//ScrollBar refresh
   // erase the old button - where's the whiteout
   @ nRow,nRight SAY '°' COLOR cBarColor // utf-8: 'â–‘'
   IF (nStart:=aLines[1,2]) = 0		// figger out the new row
	nRow = nBarTop
   ELSEIF nLastOffset >= nSize -1
	nRow = nBarBottom
   ELSE
	i = nStart + ((nLastOffset - nStart) / 2 )
	nRow = nBarTop + INT( (nBarBottom - nBarTop) * i/nSize )
   ENDIF
   // display the button
   @ nRow,nRight SAY L_A_SIGN COLOR cButtonColor
//End ScrollBar()

   @ nTop,nRight-23 SAY 'L:'+STR(nCurrRow,6) +'  C:'+STR(nLeftBrowse,3)
   DISPEND()

   nKey:=WaitKey(0)
   _mX:=MX8();_mY:=MY8()
   DO CASE
   CASE ASCAN({K_ESC,K_ALT_X,nKey==K_F10},nKey)<>0
	EXIT
   CASE nKey == K_DOWN
	nCurrRow+=SkipDown(nHandle,aLines,nLastLine,1,nSize,lApplyBlock,bApplyText);

   CASE nKey == K_UP
	IF SkipUp(nHandle,aLines,lApplyBlock,bApplyText);
		THEN nCurrRow--

   CASE nKey == K_PGUP
	IF !UPFILLARRAY(nHandle,aLines,nLastLine,nSize,lApplyBlock,bApplyText)
		Fseek( nHandle, 0 )
		AFill( aLines, {'',0,0} )
		DOWNFILLARRAY(nHandle,aLines,1,nLastLine,lApplyBlock,bApplyText)
		nCurrRow:=1
	ELSEIF aLines[1,2]==0
		nCurrRow:=1
	ELSE
		nCurrRow-=nLastLine
	ENDIF

   CASE nKey == K_PGDN
	nTemp:=SkipDown(nHandle,aLines,nLastLine,nLastLine,nSize,;
		 	lApplyBlock,bApplyText)
	nCurrRow+=nTemp
	nEndest:=MAX(nEndest,nCurrRow)
	IF nTemp<nLastLine .AND. nCurrRow<nEndest THEN nCurrRow:=nEndest

   CASE nKey == K_LEFT .AND. nLeftBrowse > 1
	nLeftBrowse --
   CASE nKey == K_RIGHT .AND. nLeftBrowse < ( nMaxRight - nLengthBrowse )
	nLeftBrowse ++
   CASE nKey == K_HOME //.AND. nLeftBrowse > 1
	nLeftBrowse = 1
   CASE nKey == K_END .AND. nLeftBrowse < ( nMaxRight - nLengthBrowse )
	nLeftBrowse = ( nMaxRight - nLengthBrowse )
   CASE nKey == K_CTRL_PGUP //.AND. aLines[1,2] # 0
	FSEEK( nHandle, 0 )
	DownFillArray(nHandle,aLines,1,nLastLine,lApplyBlock,bApplyText)
	nCurrRow:=1

   CASE nKey == K_CTRL_PGDN
	WHILE (nTemp:=SkipDown(nHandle,aLines,nLastLine,nLastLine,nSize,;
		lApplyBlock,bApplyText))==nLastLine
		nCurrRow+=nTemp
		__KEYBOARD(_PGDN)
	END
	nCurrRow+=nTemp
	nEndest:=MAX(nEndest,nCurrRow)

   CASE (nKey == K_TAB .OR. (nKey ==K_ENTER .AND. _mY==nBottom .AND. _mX==nRight));
		.AND. nLeftBrowse < ( nMaxRight - nLengthBrowse )
	nLeftBrowse = min(nLeftBrowse+nLengthBrowse,nLeftBrowse+8)
   CASE (nKey == K_SH_TAB .OR. (nKey ==K_ENTER .AND. _mY==nBottom .AND. _mX==nLeft));
		.AND. nLeftBrowse > 1
	nLeftBrowse = max(0,nLeftBrowse-8)

   CASE ASCAN({K_ALT_F, K_ALT_R, K_F7, K_ALT_F7},nKey)<>0
     nTemp:=nCurrRow
     IF (nLastOffset := SEARCH(nHandle,(nKey==K_ALT_F .OR. nKey==K_F7),;
		@nLastFind,@nHighliteOffset,;
		nBottom,@nTotalFound,@nCurrRow) ) > 0
	i:=DOWNFILLARRAY(nHandle,aLines,1,nLastLine,@lHitBottom,;
			lApplyBlock,bApplyText)
	IF i<nLastLine THEN Afill( aLines, {'',0,0},i+1)

/*CheckDisp()
* Justify the display before displaying the found text
* The find column may be out of view left or right
*/
	nLength:=LEN(ALLTRIM(_cLookText)) + nHighliteOffset
	IF nHighliteOffset < nLeftBrowse  // the find text is out of scope left
		nLeftBrowse = nHighliteOffset
	ELSEIF	nLeftBrowse+nLength > ;
		nLeftBrowse+nLengthBrowse // the find text is out of scope right
			nLeftBrowse = (nLength-nLengthBrowse )
	ENDIF

	nHighliteLine:=(Ascan(aLines,;
			{ |X| x[2] <= nLastOffset .AND. x[3] > nLastOffset}))
//END CheckDisp()

     ELSE
	nCurrRow:=nTemp
     ENDIF

   CASE nKey == K_F2
	i:=Menu2({FB_PRINT2,FB_PRINT3,FB_PRINT4},;
		1,FB_PRINT1)
	IF i % 3 <> 0 THEN;
		ListFile(cFileName,IF(i==1,0,nCurrRow),0,bApplyText)

   CASE nKey == K_F8
#IFDEF ENGLISH
	bApplyText:= IF(lWasF8, bOrigin,;
				{|_1| RemoveTabs(Translate_Charset("cp437", host_charset(), _1))})
#ELSE
	bApplyText:= IF(lWasF8, bOrigin,;
				{|_1| RemoveTabs(Translate_Charset("cp866", host_charset(), _1))})
#ENDIF
	lWasF8:=!lWasF8
	KEYBOARD _CTRLPGUP

   CASE nKey == K_ALT_F8
	i:=.T.
	IF SelectCP(@i)
		m->_CodePage:=LEFT(i,RAT('.', i)-1)
		bApplyText:= {|_1| RemoveTabs(;
				   Translate_Charset( m->_CodePage, host_charset(), _1))}
		KEYBOARD _CTRLPGUP
	ENDIF

   ENDCASE
END
FCLOSE( nHandle )
POP KEYS
RestPos()

/*************************************************************************
 These defines are used by the LineDisp function to define the
 elements of the display color as written by Todd C. MacDonald.
**************************************************************************/
#define CODE_LEN    3
#define COLOR_CODE  1
#define COLOR_SET   2
#define COLOR_DELIM '~~'
/*************************************************************************
 Displays the lines of text contained in the array
**************************************************************************/
STATIC PROC LineDisp(aLines,nTop,nLeft,nLeftBrowse,nLengthBrowse,;
			nMaxRight,nLastOffset,aDispColors,nLastLine,;
			cWinColor)
// The LOCAL vars for Todd's part of this function
LOCAL	cColorCode,cColorSet,cLine, cOutPut, nColorCode,nCodePos, nDiff,;
	nKey,nLength,nLine, nLinePos

nLeft ++ // this needs to be incremented for both display methods
nTop ++

FOR nLine = 1 to nLastLine
  SETPOS( nTop++, nLeft )
  cLine = aLines[ nLine, 1 ]
  nLinePos = 1
  cColorSet = cWinColor
  nLength = LEN( cLine )
  WHILE (COLOR_DELIM $ cLine)
	nCodePos = at( COLOR_DELIM, cLine )
	cOutPut = left( cLine, nCodePos - 1 )
/*
	strip the beginning of the line IF we are panned right
	this must be done as a color code may be in this part
	of the line so we must process the characters but cannot
	display any characters until we reach the first virtual column
	of the display window
*/
	IF nLinePos < nLeftBrowse
		nDiff = min( len( cOutPut ), nLeftBrowse - nLinePos )
		nLinePos += nDiff
		cOutPut = substr( cOutPut, nDiff + 1 )
	ENDIF
	// output line up to code position in current color
	DEVOUT( cOutPut, cColorSet )
	// strip off text just displayed
	cLine =  substr( cLine, nCodePos )
/*
	Set new color based on color code.	IF the color code
	is not found in the array, the code is not stripped out
	(therefore the code itself gets displayed in the output
	text).  IF the code is found but the color value is nil,
	the color is set to the default.
*/
	cColorCode = LEFT( cLine, CODE_LEN )
	IF ( nColorCode := Ascan( aDispColors, ;
		{ | a | a[ COLOR_CODE ] == cColorCode } ) ) # 0
	    IF ( cColorSet := aDispColors[ nColorCode, COLOR_SET ] ) = NIL;
		THEN cColorSet = cWinColor
	    // strip off color code
	    cLine = substr( cLine, CODE_LEN + 1 )
	    // keep track of the line length
	    nLength -= (CODE_LEN +1)
	ELSE
	    // strip off color code prefix
	    cLine = substr( cLine, CODE_LEN )
	    // keep track of the line length
	    nLength -= CODE_LEN
	ENDIF
   END
   // cut to the left column IF we are not already there
   IF nLinePos < nLeftBrowse  THEN;
	cLine = substr( cLine, nLeftBrowse - nLinePos + 1)

   // output remainder of line
   DEVOUT( PAD( cLine, nLeft + nLengthBrowse - col() ), cColorSet )
   // set the system counters
   nMaxRight   = max(nMaxRight,nLength)
   nLastOffset = max(nLastOffset,aLines[nLine,3])
NEXT

/*************************************************************************
 Highlight the found text
**************************************************************************/
STATIC FUNC HighLight(_cLookText,nOffset,nRow,nCol)
LOCAL nLength := LEN(ALLTRIM(_cLookText))
nCol+=(nOffset-1)
dispattr(nRow,nCol,nRow,nCol+nLength-1,7)

RETURN 0

/*************************************************************************
 Clean up the line by removing control characters and apply the
 user-defined block IF applicable cLine is passed to this function
 by reference thus no return value
**************************************************************************/
STATIC PROC LineClean( cLine, lApplyBlock, bApplyText )
cLine = StrTran(Strtran( cLine, chr(10), ' ' ),chr(13), ' ' )   // LFCR
IF lApplyBlock THEN cLine = EVAL( bApplyText, cLine )

/*************************************************************************
 Search for line-feed or form-feed mark - return the first offset
 The extraordinary error trapping is included here to prevent
 lock-up when a binary file is browsed, i.e. a loop can be
 caused by the eof mark not being found
**************************************************************************/
STATIC FUNC FirstEOLMark(cBuffer)
LOCAL	nLFMark := AT(chr(10),cBuffer)
RETURN IF( nLFMark > 0,;
		MIN( nLFMark, MAXBROWSELENGTH ),;
		IF( len( cBuffer ) >= MAXBROWSELENGTH,;
			MAXBROWSELENGTH,;
			0))

/*************************************************************************
 fill the array traversing down the file
**************************************************************************/
STATIC FUNC DownFillArray(nHandle,aLines,nStart,nEnd,;
			  lApplyBlock,bApplyText,lHitBottom)
LOCAL nBlock := 1024,cBuffer,cLine,nEol,;
	nCounter := nStart - 1,;
	nFilePos := FSEEK( nHandle, 0, 1 ),;
	nLoopCounter := 0,nBytesRead

lHitBottom = .f.
// WHILE the array is not full
WHILE nCounter < nEnd
   // reposition to current file position
   FSEEK( nHandle, nFilePos )
   // assign a buffer and read the file
   cBuffer = SPACE( nBlock )
   IF (nBytesRead := FREAD( nHandle, @cBuffer, nBlock )) # nBlock;
	THEN nLoopCounter ++

   // check for eof
   IF nBytesRead < 1 .OR. nLoopCounter > 2
	lHitBottom = .t.
	exit
   ELSE
	WHILE nCounter < nEnd .AND. (nEol := FIRSTEOLMARK( cBuffer )) # 0
		nCounter ++
	// extract the line
		cLine = left( cBuffer, nEol )
	// strip the line from the buffer
		cBuffer = substr(cBuffer,nEol+1)
	// clean it up
		LINECLEAN( @cLine, lApplyBlock, bApplyText )
	// store it in the array
		aLines[nCounter] = { cLine, nFilePos, nFilePos + nEol }
	// keep the pointer current
		nFilePos += nEol
	END
	// test for eof
	lHitBottom = (nCounter < nEnd)
   ENDIF
END
RETURN nCounter
/**************************************************************************
 add one line to the bottom the array
**************************************************************************/
STATIC FUNC SkipDown(nHandle,aLines,nLastLine,nNumLines,nSize,;
			lApplyBlock,bApplyText)
LOCAL lHitBottom := .f.,nCounter:=0
IF aLines[ nLastLine, 3 ] # 0
   // position file to last line offset
   Fseek( nHandle, aLines[ nLastLine, 3 ] )
   ADEL( aLines, 1 )
   aLines[nLastLine] = {'',0,0}
   // get the next line
   nCounter:=DownFillArray(nHandle,aLines,nLastLine+1-nNumLines,nLastLine,;
		 	lApplyBlock,bApplyText,@lHitBottom)
   IF lHitBottom
	// we hit bottom or no text in any line
	aLines[1,2] = nSize	//FSEEK( nHandle, 0, 2 )
	UpFillArray(nHandle,aLines,nLastLine,nSize,lApplyBlock,bApplyText)
   ENDIF
ENDIF
IF nNumLines==1
	nCounter:=IF(nCounter<nLastLine,0,1)
ELSEIF nCounter<nLastLine .AND. nCounter>0
	nCounter--
ENDIF
RETURN nCounter
/*************************************************************************
 fill the array traversing up ... the tricky one ...
 This function was originally coded with the RAT function
 Tests show the AT func to be about 10 times faster than RAT
 thus the overhead of the aTemp with the AT function as an offset map
**************************************************************************/
STATIC FUNC UpFillArray(nHandle,aLines,nEnd,nSize,lApplyBlock,bApplyText)
LOCAL	aOffsets,cBuffer,cLine := '',nBlock := 1024,nCounter := 0,;
	nEol,nFilePos := FSEEK( nHandle, 0, 1 ),nTempCount
LOCAL lEof :=  (nSize = nFilePos ), lReturn := .t., aOfs
WHILE nCounter < nEnd
	// assign some defaults and read the file
   nBlock = min(nBlock,aLines[1,2])
   nFilePos = aLines[1,2] - nBlock
   Fseek( nHandle, nFilePos )
   cBuffer = space( nBlock )
   IF Fread( nHandle, @cBuffer, nBlock ) = 0
	exit
   ELSE
      aOffsets:=IF( nFilePos = 0, { 0 }, {/* it is a fragment*/} )
	// map the lines into a temp array
      nTempCount = 0
      WHILE (nEol := FirstEOLMark( SUBSTR( cBuffer, nTempCount + 1 ))) # 0
	 nTempCount += nEol
	 AADD( aOffsets, nTempCount )
      END
	// pick up the last line IF eof and it does not end w/ LF CR etc.
      IF lEof .AND. nTempCount < nBlock THEN  AADD( aOffsets, nBlock )
      nTempCount = LEN( aOffsets )

      IF !lEof .AND. nTempCount==1
	//One long string in binary file
	nTempCount:=2
	AADD( aOffsets, nBlock )
      ENDIF

	// fill the array
      WHILE nCounter < nEnd .AND. nTempCount > 1
	 nCounter ++
	 nTempCount --
	 aOfs:=aOffsets[nTempCount]
	 cLine = substr(cBuffer,aOfs+1)
	 // strip the first char IF it is a control char
	 // going down we don't have this problem as it is at the end and
	 // we don't care
	 IF First(cLine) $ _CRLF;
	 	THEN cLine := substr( cLine, 2 )

	 // clean it up
	 LINECLEAN( @cLine, lApplyBlock, bApplyText )
	 // store the line and it's parameters
	 A_Ins( aLines,{cLine,;
	 		nFilePos+aOfs,;
	 		nFilePos+aOffsets[nTempCount+1]})

	// strip the line from the buffer
	 cBuffer = left(cBuffer,aOfs)
      END
	// IF nCounter < nEnd we ran out of lines
	// return .f. and fill the array from the top
      lReturn = (nCounter = nEnd )
      IF nFilePos = 0
	 IF aLines[1,2] = 1 // assign BOF status explicitly for the other
	    aLines[1,2] = 0 // functions
	 ENDIF
	 EXIT  // we're done here
      ENDIF
   ENDIF
END
RETURN lReturn

/*************************************************************************
 add one line to the top of the array
**************************************************************************/
STATIC FUNC SkipUP(nHandle,aLines,lApplyBlock,bApplyText)
LOCAL nBlock,cBuffer, cLine := '', lBof := .f., nEol, nFilePos, nLength,;
	_ret:=.F.,nlBuf:=aLines[1,2]

IF nlBuf #0
   nBlock = min(512,nlBuf)
   nFilePos = nlBuf - nBlock
   lBof = (nFilePos <= 1 )
   Fseek( nHandle, nFilePos )
   cBuffer = space( nBlock )
   IF Fread( nHandle, @cBuffer, nBlock ) # 0
	// get past the first eol mark
	IF (nEol:=Rat(chr(10),cBuffer)) # 0
		cLine = SUBSTR(cBuffer, nEol+1 )
		cBuffer = left(cBuffer,nEol-1)
	ENDIF
	// get the last line in the buffer
	IF (nEol:=Rat(chr(10),cBuffer)) == 0 .AND. !lBof
		nEol = MIN(nBlock,MAXBROWSELENGTH)
	ELSEIF len(cBuffer) - nEol > MAXBROWSELENGTH
		nEol = MAXBROWSELENGTH
	ENDIF
	// update the file position
	nFilePos += nEol
	// get the line
	cLine = SUBSTR(cBuffer,nEol+1) + cLine
	// save the real length of the line in the file
	nLength = LEN( cLine )
	// clean it up
	LineClean( @cLine, lApplyBlock, bApplyText )
	// store the line and it's parameters
	A_INS( aLines, {cLine,nFilePos,nFilePos+nLength})
	_ret:=.T.
   ENDIF
ENDIF
RETURN _ret

/*************************************************************************
 Search Routine By: Phil Barnett  April 3, 1993
 Search and repeat last find
**************************************************************************/
STATIC FUNC Search(nHandle,lInit,nLastFind,;
			nHighliteOffset,nBottom,nTotalFound,nCurrRow)
LOCAL	cBuffer, nBytesRead,nLookLen,;
	nThisOffset,nOffset := 0, nLoop := 0, cMiniBuff,;
	nMbSize,nEolAT,cHoldBack := ''

#define nBlock 4096  // Bigger is probably faster up to ~10000 bytes
IF lInit	// initiate search (ALT_F)ind
	nTotalFound = 0
	nLastFind = -1
	nCurrRow := 1
	IF !GetName(FB_SRCH,'_cLookText') THEN RETURN 0
	_cLookText = UPPER(ALLTRIM(_cLookText))
ENDIF
IF EMPTY(_cLookText) THEN RETURN 0
nLookLen := LEN(_cLookText)

FSEEK(nHandle,nLastFind+1,0)	// Position filepointer to starting location
nBytesRead = nBlock		// setup loop entry
DO WHILE nBytesRead == nBlock
	// Get and prepare the Character Buffer
   cBuffer = SPACE(nBlock)
   IF (nBytesRead := FREAD(nHandle,@cBuffer,nBlock)) < nBlock;
	THEN cBuffer = LEFT(cBuffer,nBytesRead)

   cBuffer = cHoldBack + UPPER(cBuffer)
   nThisOffset = AT(_cLookText,cBuffer)
   IF !EMPTY(nThisOffset)
	// position the File Pointer to the find.
      nCurrRow+=FT_NOOCCUR(chr(10),LEFT(cBuffer,nThisOffset),.F.)
      nLastFind += ( nLoop * nBlock ) + nThisOffset - len( cHoldBack )
	// Now, locate the beginning of the line
	// ( It might not be in current buffer, so make a new minibuffer )
      nMbSize = min( nLastFind, 512 )

      cMiniBuff:=ReadBin(nHandle,nLastFind-nMbSize,nMbSize)
      nEolAT = RAT(chr(10),cMiniBuff)
      IF nEolAT > 0 THEN Fseek( nHandle, nEolAT-nMbSize,1)

      nOffset = Fseek(nHandle,0,1)
      nHighliteOffset = (nLastFind - nOffset + 1)
      nTotalFound ++
	// We found one so...
      EXIT
   ELSE
      nCurrRow+=FT_NOOCCUR(chr(10),cBuffer,.F.)
   ENDIF
   cHoldBack = RIGHT(cBuffer,nLookLen - 1)
   nLoop ++
ENDDO
IF nOffset == 0 THEN NFind(NTRIM(nTotalFound)+FB_ALSO)

RETURN nOffset
**********
PROC ListFile(FileName,FromLine,ToLine,bApply)
LOCAL	_handle,_line:='',scr,lbApply,_Missed:=0,;
	_corrupted:=_MSG_VF_CORRUPTED

IF (_handle:=FOpen(FileName,64))<=0 THEN;
	ReturnMess(FileName+CORRUPT_OR_LOCKED)

ScrSave(@scr)

Waiting(_MSG_VF_PRWAIT)
Set(_SET_PRINTFILE,m->_Printer)
SET PRINTER ON
SET CONSOLE OFF
lbApply:=(VALTYPE(bApply)=='B')
BEGIN SEQUENCE
  DO WHILE FreadLn(_handle,@_line,2048) .AND. Inkey()<>K_ESC .AND.;
	 (ToLine=0 .OR. _missed<=ToLine)
	CENTER(m->_Middlerow+2,NTRIM(_missed)+_MSG_VF_PRINTED,,_HDColor)
	IF (++_missed >= FromLine)
		IF lbApply THEN _line:=EVAL(bApply,_line)
		? _line
	ENDIF
  ENDDO
  ?
END SEQUENCE
SET PRINTER TO
SET CONSOLE ON
SET PRINTER OFF
ScrRest(scr)
FClose(_handle)
**********
FUNC FreadLn(_handle,_string,_max_len)
LOCAL _eol,_num_read,_save_pos

_save_pos:=Fseek(_handle,0,1)
_string:=SPACE(_max_len)

IF (_num_read:=Fread(_handle,@_string,_max_len) )#0

	IF (_eol:=AT(CHR(10),LEFT(_string,_num_read))) = 0 THEN;
		_eol:=_num_read+1

	_string:=STRTRAN(LEFT(_string,_eol-1),CHR(13))

	Fseek(_handle,_save_pos+_eol)

ENDIF

RETURN (_num_read#0)
