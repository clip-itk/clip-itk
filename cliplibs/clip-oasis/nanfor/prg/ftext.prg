/*   Copyright (C) 2004  ITK					*/
/*   Author  : Uri (uri@itk.ru)					*/
/*   Licence : (GPL) http://www.itk.ru/clipper/licence.html	*/
/****************************************************************/
/*   Prototype: Nanfor library from www.the-oasis.net 		*/
/*   Author   : Brice de Ganahl and Steve Larsen 		*/
/*   License  : Public Domain					*/


#include "fileio.ch"
#define BUFFSIZE 4096
#define MAXLINES 64000

static areas:={nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}
static nArea := 1

**********************************************
function ft_fuse(sFile,nMode)
	local area := __fta_area()

	area:close()
	if valtype(sFile) == "C"
		area:open(sFile,nMode)
	endif

return area:nHandle
**********************************************
function ft_fselect(nSelect)
	local i,area,ret := nArea
	if ! (valtype(nSelect) == "N")
		return ret
	endif
	if nSelect == 0
		for i=1 to len(areas)
			area := areas[i]
			if empty(area) .or. area:nHandle < 0
				nArea := i
				exit
			endif
		next
		return ret
	endif
	if nSelect > 0 .and. nSelect <= len(areas)
		nArea := nSelect
		return ret
	endif
return ret
**********************************************
function ft_fgotop()
	local area := __fta_area()
return	area:gotop()
**********************************************
function ft_fgoto( nTarget )
	local area := __fta_area()
return	area:goto( nTarget )
**********************************************
function ft_fgobot()
	local area := __fta_area()
return	area:gobottom()
**********************************************
function ft_fgobottom()
	local area := __fta_area()
return	area:gobottom()
**********************************************
function ft_ferror()
	local area := __fta_area()
return	area:error()
function ft_ferrorStr()
	local area := __fta_area()
return	area:errorStr()
**********************************************
function ft_frecno()
	local area := __fta_area()
return	area:recno()
**********************************************
function ft_flastre()
	local area := __fta_area()
return	area:lastrec()
**********************************************
function ft_flastrec()
	local area := __fta_area()
return	area:lastrec()
**********************************************
function ft_fskip(nSkip)
	local area := __fta_area()
return	area:skip(nSkip)
**********************************************
function ft_feof()
	local area := __fta_area()
return	area:eof()
**********************************************
function ft_fbof()
	local area := __fta_area()
return	area:bof()
**********************************************
function ft_freadLn()
	local area := __fta_area()
return	area:readLn()
**********************************************
function ft_fread(nBytes)
	local area := __fta_area()
return	area:read(nBytes)
**********************************************
function ft_fwriteLn(cData,lInsert)
	local area := __fta_area()
return	area:writeLn(@cdata,lInsert)
**********************************************
function ft_fwriteL(cData,lInsert)
	local area := __fta_area()
return	area:writeLn(@cdata,lInsert)
**********************************************
function ft_fappend(nLines)
	local area := __fta_area()
return	area:append(nLines)
**********************************************
function ft_finsert(nLines)
	local area := __fta_area()
return	area:insert(nLines)
**********************************************
function ft_fwrite(cData)
	local area := __fta_area()
return	area:write(@cData)
**********************************************
function ft_fdelete(iNum)
	local area := __fta_area()
return	area:delete(iNum)
**********************************************
function ft_fzap()
	local area := __fta_area()
return	area:zap()

**********************************************
**********************************************
**********************************************
**********************************************
**********************************************
function ft_fileAreaNew()
	local obj:=map()

	obj:className	:= "FT_FILEAREA"
	obj:nHandle	:= -1

	obj:open	:=@ _fta_open()
	obj:close	:=@ _fta_close()
	obj:gotop	:=@ _fta_gotop()
	obj:goto	:=@ _fta_goto()
	obj:gobot	:=@ _fta_gobottom()
	obj:gobottom	:=@ _fta_gobottom()
	obj:error	:=@ _fta_error()
	obj:errorStr	:=@ _fta_errorStr()
	obj:recno	:=@ _fta_recno()
	obj:lastrec	:=@ _fta_lastrec()
	obj:skip	:=@ _fta_skip()
	obj:_skip	:=@ _fta__skip()
	obj:eof		:=@ _fta_eof()
	obj:bof		:=@ _fta_bof()
	obj:readLn	:=@ _fta_readLn()
	obj:read	:=@ _fta_read()
	obj:write	:=@ _fta_write()
	obj:writeLn	:=@ _fta_writeLn()
	obj:delete	:=@ _fta_delete()
	obj:append	:=@ _fta_append()
	obj:insert	:=@ _fta_insert()
	obj:zap		:=@ _fta_zap()

	obj:close()

return obj
**********************************************
static function _fta_open(self,sFile,nMode)
	if valtype(self) != "O"
		return -1
	endif
	if valtype(nMode) !="N"
		nMode := FO_READ+FO_SHARED
	endif
	if valtype(sFile) == "C"
		self:nHandle := fOpen( sFile, nMode)
		if self:nHandle <= 0
			self:error := ferror()
		endif
	endif
	self:nOffset := 0
	self:nRecno  := 1
	self:nLastbyte := fSeek( self:nHandle, 0, FS_END )
return  self:nHandle
**********************************************
static function _fta_close(self)
	if valtype(self) != "O"
		return -1
	endif
	if self:nHandle > 0
		fClose( self:nHandle )
	endif
	self:nRecno	:= 0
	self:nOffset	:= 0
	self:nHandle	:= -1
	self:nLastRec	:= 0
	self:nLastbyte	:= 0
	self:isBof	:= .f.
	self:isEof	:= .f.
	self:nError	:= 0

	self:aLines	:= {}
	self:nReaded    := 0
return 0

**********************************************
static function _fta_gotop(self)
	self:nError  := 0
	self:nOffset := 0
	self:nRecno  := 1
	self:isBof  := .f.
	self:isEof  := .f.
return
**********************************************
static function _fta_gobottom(self)
	self:nError  := 0
	if self:nLastrec == 0
		self:_skip( 0 )
	endif
	self:nRecno  := self:nLastrec
	//self:nOffset := fSeek(self:nHandle,0,FS_END)
	self:isBof   := .f.
	self:isEof   := .f.
return
**********************************************
static function _fta_goto(self, target )
	/* if a recno was passed, do a relative skip */
	if  target > 0
		/* skip relative */
		target -= self:nRecno
		if target > 0
			self:skip( target )
		endif
	else
		/* goto 0 passed, go top then skip back */
		target := self:nRecno
		self:nOffset := 0
		self:nRecno  := 1
		self:isBof   := .f.
		self:isEof   := .f.
		if ( --target ) > 0
			self:skip( target )
		endif
	endif
	self:nError := fError()
return
**********************************************
static function _fta_error(self)
return self:nError
**********************************************
static function _fta_errorStr(self)
return fErrorStr(self:nError)
**********************************************
static function _fta_recno(self)
return self:nRecno
static function _fta_lastrec(self)
   local ret
   local cur_rec := self:nRecno
   local cur_offset := self:nOffset
   self:gobottom()
   ret := self:nLastrec
   self:nRecno  := cur_rec
   self:nOffset := cur_offset
return ret
**********************************************
static function _fta_eof(self)
return self:isEof
**********************************************
static function _fta_bof(self)
return self:isBof
**********************************************
static function _fta_zap(self)
	local ret
	ret := ftrunc(self:nHandle,0)
	self:nError := fError()
return ret
**********************************************
static function _fta_readLn(self)
	local iByteCount,iBytesRead
	local cBuff := space(BUFFSIZE)

	self:nError := 0
	fSeek( self:nHandle, self:nOffset, FS_SET)
	iBytesRead  := fRead( self:nHandle, @cBuff, BUFFSIZE)
	if iBytesRead == 0
	       self:nError := fError()
	       return ""
	endif
	if iBytesRead != BUFFSIZE
		cBuff := left(@cBuff,iBytesRead)
	endif
	iByteCount = strFindEOL( @cBuff, 0 )
return strtran(left(@cBuff,iByteCount-2),"&\r","")
**********************************************
static function _fta_read(self,nBytes)
	local iByteCount,iBytesRead
	local needRead := iif(nBytes==NIL,BUFFSIZE,nBytes)
	local cBuff := space(needRead)

	self:nError := 0
	fSeek( self:nHandle, self:nOffset, FS_SET)
	iBytesRead  := fRead( self:nHandle, @cBuff, needRead)
	if iBytesRead == 0
	       self:nError := fError()
	       return ""
	endif
	if iBytesRead != needRead
		cBuff := left(@cBuff,iBytesRead)
	endif
	if nBytes == NIL
		iByteCount := strFindEOL( @cBuff, 0 )
		return left(@cBuff,iByteCount-1)
	endif
return cBuff
**********************************************
static function _fta_write(self,cData)
	local iBytesWrite
	self:nError := 0
	outlog(__FILE__,__LINE__)
	fSeek( self:nHandle, self:nOffset, FS_SET)
	iBytesWrite  := fWrite( self:nHandle, @cData)
	if iBytesWrite != len(cData)
	       self:nError := fError()
	endif
	self:nOffset += iBytesWrite
return iBytesWrite
**********************************************
static function _fta_writeLn(self,theData,lInsert)
	local crlf := set("PRINTER_EOL")
	local err  := .t.
	local iDataLen:=len(theData),iLineLen := 0
	local iRead, iEOL
	local buffer

	lInsert := iif( valtype(lInsert) == "L",lInsert,.f.)
	/* position file pointer to insertion point */
	fSeek( self:nHandle, self:nOffset, FS_SET )

	if lInsert
		/* insert mode, insert the length of new string + crlf */
		err = _ins_buff(self, iDataLen + 2 )
		if !err
			fSeek( self:nHandle, self:nOffset, FS_SET )
			err := _writeLine(self, theData )
		endif
		return err
	endif

	buffer := space(BUFFSIZE)
	/* find length of current line, loop if longer than buffer */
	while  iRead == BUFFSIZE
		iRead = fRead( self:nHandle, buffer, BUFFSIZE )
		iEOL  = strFindEOL( @buffer, 0 )
		if iEOL > iRead
			iLineLen += iRead
		else
			iLineLen += iEOL
			exit
		endif
	enddo
	if iDataLen+2 <= iLineLen
		/* delete excess bytes from current record */
		_del_buff(self, iLineLen - iDataLen - 2 )
	else
		/* insert extra bytes into current record */
		_ins_buff(self, iDataLen - iLineLen + 2 )
	endif
	/* write the new record's contents */
	fWrite( self:nHandle, theData )
	self:nError := fError()
	err := (self:nError == 0)
return err
**********************************************
static function _fta_delete(self, iNum )
	local iBytesRead := 1
	local srcPtr, destPtr
	local cur_rec := self:nRecno
	local cur_off := self:nOffset
	local Buff    := space(BUFFSIZE)

	/* save address to current record ( first record to be deleted ) */
	destPtr := self:nOffset
	/* skip over deleted records, point to first 'to be retained' record */
	iNum := iif(valtype(iNum) == "N", iNum, 1)
	self:skip( iNum )
	srcPtr := fSeek( self:nHandle, self:nOffset, FS_SET )
	/* buffer read retained data, write atop old data */
	while iBytesRead > 0
		fSeek( self:nHandle, srcPtr, FS_SET )
		/* now read in a big glob */
		iBytesRead := fRead( self:nHandle, Buff, BUFFSIZE )
		srcPtr  += iBytesRead
		fSeek( self:nHandle, destPtr, FS_SET )
		destPtr += fWrite( self:nHandle, Buff, iBytesRead )
	enddo
	/* move DOS EOF marker */
	//fSeek( self:nHandle, srcPtr, FS_SET )
	//fWrite( self:nHandle, "", 0 )
	ftrunc(self:nHandle,destPtr)
	self:nError := fError()
	/* restore pointers */
	self:nRecno := cur_rec
	self:nOffset := cur_off
	/* re_calc EOF */
	self:skip( 0 )
	/* restore pointers again */
	self:nRecno := cur_rec
	self:nOffset := cur_off
	/* if we've deleted to EOF, leave EOF flag set, otherwise clear it */
	if  self:nRecno != self:nLastrec
		self:isEof := .f.
	endif
return  self:nError == 0
**********************************************
static function _fta_append(self, no_lines )
	local iRead, iByteCount
	local crlf := set("PRINTER_EOL")
	local buff := space(BUFFSIZE)

	no_lines := iif(valtype(no_lines) == "N", no_lines, 1)
	self:nError := 0
	ft_fgobot()
	/* find end of record */
	fSeek( self:nHandle, self:nOffset, FS_SET )
	iRead := fRead( self:nHandle, buff, BUFFSIZE )
	/* determine if CRLF pair exists, if not, add one */
	/* get count of chars in this line */
	iByteCount = strFindEol( buff, 0 )
	if( iByteCount > iRead )
		fSeek( self:nHandle, 0, FS_END )
	else
		self:nOffset := fSeek( self:nHandle, self:nOffset + iByteCount, FS_SET )
		self:nRecno++
		no_lines--
	endif
	while ( no_lines-- ) > 0
		if fWrite( self:nHandle,crlf) != len(crlf)
			self:nError := fError()
			exit
		endif
		self:nRecno++
		self:nOffset := fSeek( self:nHandle, 0, FS_CUR )
		no_lines--
	enddo
	if self:nError == 0
		/* move DOS eof marker */
		fWrite( self:nHandle,"", 0 )
		//ftrunc( self:nHandle, self:nOffset )
		self:nError := fError()
	endif
	/* force recalc of last record/offset */
	self:nLastrec := 0
return self:nError==0
**********************************************
static function _fta_insert(self, no_lines)
	local	err := .t., no_bytes
	local crlf := set("PRINTER_EOL")

	no_lines := iif( valtype(no_lines) == "N", no_lines, 1 )
	no_bytes := no_lines * len(crlf)
	if _ins_buff(self, no_bytes )
		err := 0
	else
		while ( no_lines-- ) > 0
			if fWrite( self:nHandle, crlf ) != len(crlf)
				self:nError := fError()
				err := .f.
				exit
			endif
		enddo
	endif
return err
**********************************************
static function _fta_skip(self,nSkip)
	if valtype(nSkip) != "N"
		nSkip := 1
	endif
return self:_skip(nSkip)

**********************************************
static function _fta__skip(self,iRecs)
	local fpOffset := self:nOffset
	local cBuff := space(BUFFSIZE)
	local iBytesRead,iBytesRemaining,iByteCount
	local iSkipped := 0

	self:isBof  := .f.
	self:isEof  := .f.
	self:nError := 0

	/* iRecs is zero if they want to find the EOF, start a top of file */
	if iRecs == 0
		fpOffset     := 0
		self:nOffset := 0
		self:nRecno  := 1
	endif

	if iRecs >= 0
		iBytesRead := BUFFSIZE
		while iBytesRead == BUFFSIZE
			iByteCount := 0
			/* position file pointer to beginning of current record */
			fSeek( self:nHandle, self:nOffset, FS_SET )
			/* read a chunk */
			iBytesRead = fRead(self:nHandle, @cBuff, BUFFSIZE )
			if iBytesRead == 0
				/* buffer is empty thus EOF, set vars and quit */
				self:isEof     := .t.
				self:nLastrec  := self:nRecno
				self:nError    := fError()
				exit
			endif

			iBytesRemaining := iBytesRead
			/* parse the buffer while there's still stuff in it */
			while iBytesRemaining > 0
				/* get count of chars in this line */
				iByteCount := strFindEOL( @cBuff, iByteCount )
				//iByteCount := min(iByteCount,iBytesRead)
				if iByteCount > 0 .and. iByteCount <= iBytesRead
					/* found a CRLF, iByteCount points to
					   first char of next   record */
					fpOffset := self:nOffset+iByteCount
					self:nRecno++
					iSkipped++
					if  iRecs != 0 .and. iSkipped == iRecs
						iBytesRemaining := iBytesRead := 0
					endif
				else
					/* no more CRLFs in this buffer, or CRLF is last chars in the buffer */
					/* check for EOF */
					if( iBytesRead != BUFFSIZE )
						/* buffer was not full, thus EOF, set vars and quit */
						iBytesRemaining := 0
						self:nLastrec   := self:nRecno
						if iRecs != 0
							self:isEof := .t.
						endif
					else
						/* buffer was full, so probably not EOF,
						but maybe CRLF straddled end of buffer, so back up pointer a bit
						before doing the next read */
						fpOffset        := fSeek( self:nHandle, 0, FS_CUR ) - 1
						iBytesRemaining := 0
					endif
				endif
			enddo
			self:nOffset := fpOffset-1
		enddo
	else
		/* skip backwards */
		iRecs = -iRecs
		if  self:nRecno > iRecs
			iBytesRead := BUFFSIZE
			fpOffset := 1
			while ( fpOffset > 0 ) .and. ( iBytesRead == BUFFSIZE )
				/* calc offset to read area of file ahead of current pointer */
				fpOffset = max( self:nOffset - BUFFSIZE, 0 )
				/* move file pointer */
				fSeek( self:nHandle, fpOffset, FS_SET )
				/* read a chunk */
				iBytesRead := fRead( self:nHandle, cBuff, BUFFSIZE )
				if iBytesRead == 0
					/* buffer is empty thus file is zero len, set vars and quit */
					self:isBof        := .t.
					self:isEof        := .t.
					self:nRecno       := 0
					self:nOffset      := 0
					self:self:nLastrec:= 0
					self:nError       := fError()
					exit
				endif
				/* set pointer within buffer */
				iBytesRemaining := self:nOffset - fpOffset
				/* parse the buffer while there's still stuff in it */
				while iBytesRemaining > 0
					/* get count of chars in this line */
					iByteCount = strFindBOL( @cBuff, iBytesRemaining )
					if iByteCount > 0
						/* found a CRLF, iByteCount points to first char of next record */
						iBytesRemaining := iByteCount
						self:nOffset    := fpOffset+iByteCount-1
						self:nRecno     --
						iSkipped++
						if iSkipped == iRecs
							iBytesRemaining := iBytesRead := 0
						endif
					else
						/* no more CRLFs in this buffer so we're either at
						   BOF or record crosses buffer boundary */
						/* check for BOF */
						if iBytesRead != BUFFSIZE .or. fpOffset == 0
							/* buffer was not full, thus BOF, set vars and quit */
							iBytesRemaining := 0
							self:nOffset    := 0
							self:nRecno     := 1
							self:isBof      := .t.
						else
							/* buffer was full, so not BOF */
							iBytesRemaining  := 0
						endif
					endif
				enddo
			enddo
		else
			self:nOffset := 0
			self:nRecno  := 1
			self:isBof   := .t.
		endif
	endif
return iSkipped
**********************************************
/* inserts xxx bytes into the current file, beginning at the current record */
/* the contents of the inserted bytes are indeterminate, i.e. you'll have to
     write to them before they mean anything */
static function _ins_buff(self, iLen )
	local ReadBuff:=space(BUFFSIZE),WriteBuff:=space(BUFFSIZE),SaveBuff
	local fpRead, fpWrite
	local WriteLen, ReadLen, SaveLen
	local iLenRemaining := iLen

	/* set target move distance, this allows iLen to be greater than BUFFSIZE */
	iLen := min( iLenRemaining, BUFFSIZE )
	iLenRemaining -= iLen

	self:nError := 0

	/* initialize file pointers */
	fpRead  := self:nOffset
	fpWrite := self:nOffset + iLen

	/* do initial load of both buffers */
	fSeek( self:nHandle, fpRead, FS_SET )
	WriteLen = fRead( self:nHandle, WriteBuff, BUFFSIZE )
	fpRead += WriteLen

	ReadLen = fRead( self:nHandle, ReadBuff, BUFFSIZE )
	fpRead += ReadLen

	while  self:nError == 0 .and. iLen > 0
		while WriteLen > 0
			/* position to beginning of write area */
			if fSeek( self:nHandle, fpWrite, FS_SET ) != fpWrite
				self:nError := fError()
				exit
			endif
			SaveLen := fwrite( self:nHandle, WriteBuff, WriteLen )
			if SaveLen != WriteLen
				self:nError := fError()
				exit
			endif
			fpWrite += SaveLen
			/* swap buffers */
			SaveBuff  := WriteBuff
			WriteBuff := ReadBuff
			ReadBuff  := SaveBuff
			WriteLen  := ReadLen
			/* return to read area and read another buffer */
			fSeek( self:nHandle, fpRead, FS_SET )
			ReadLen = fRead( self:nHandle, ReadBuff, BUFFSIZE )
			fpRead += ReadLen
		enddo
		iLen = min( iLenRemaining, BUFFSIZE )
		iLenRemaining -= iLen
	enddo
	/* store length in bytes, set EOF marker for DOS */
	//fSeek( self:nHandle, fpWrite, FS_SET )
	//fWrite( self:nHandle, "", 0 )
	ftrunc(self:nHandle,fpWrite)
	/* clear last_rec so next gobot will recount the records */
	self:nLastrec := 0
	fSeek( self:nHandle, self:nOffset, FS_SET )
return self:nError != 0
**********************************************
static function _del_buff(self, iLen )
	local WriteBuff := space(BUFFSIZE)
	local fpRead, fpWrite
	local WriteLen,	SaveLen

	/* initialize file pointers */
	fpWrite := self:nOffset
	fpRead  := self:nOffset + iLen

	/* do initial load of buffer */
	fSeek( self:nHandle, fpRead, FS_SET )
	WriteLen := fRead( self:nHandle, WriteBuff, BUFFSIZE )
	fpRead += WriteLen

	self:nError := 0
	while( WriteLen > 0 )
		/* position to beginning of write area */
		fSeek( self:nHandle, fpWrite, FS_SET )
		SaveLen := fWrite( self:nHandle, WriteBuff, WriteLen )
		fpWrite += SaveLen
		if SaveLen != WriteLen
			/* error, fetch errcode and quit */
			self:nError := fError()
			exit
		endif
		/* return to read area and read another buffer */
		fSeek( self:nHandle, fpRead, FS_SET )
		WriteLen := fRead( self:nHandle, WriteBuff, BUFFSIZE )
		fpRead  += WriteLen
	enddo

	/* store length in bytes, set EOF marker for DOS */
	//fSeek( self:nHandle, fpWrite, FS_SET )
	//fWrite( self:nHandle, "", 0 )
	ftrunc(self:nHandle,fpWrite)
	self:nLastrec := 0
	fSeek( self:nHandle, self:nOffset, FS_SET )
return self:nError
**********************************************
/* writes a line of data to the file, including the terminating CRLF */
static function _writeLine(self, theData)
	local crlf := set("PRINTER_EOL"), err := .f.
	if fWrite( self:nHandle, theData ) != len(theData)
		err := .t.
		self:nError := fError()
	else
		if fWrite( self:nHandle, crlf) != len(crlf)
			err := .t.
			self:nError := fError()
		endif
	endif
return err
**********************************************
static function __fta_area()
	local area:=areas[nArea]

	if empty(area)
		areas[nArea] := ft_fileAreaNew()
		area := areas[nArea]
	endif
return area
