#include "FileIO.ch"

#define SEEK_FORWARD   0
#define SEEK_BACKWARD  1

#define SEEK_NOCASE    0
#define SEEK_UPCASE    1
#define SEEK_LOCASE    2

******************************************************************
function TFile()

	local obj	:= map()
	obj:classname	:= "TFILE"
        obj:new		:= @tf_new()

return obj

******************************************************************
static function tf_new(self, cFileName, nMode )

   self:cName := cFileName
   if File( cFileName )
      self:nMode := iif(nMode==NIL, FO_READWRITE, nMode)
      self:hFile = FOpen( cFileName, self:nMode )
      self:nLen  = FSeek( self:hFile, 0, FS_END )
      FSeek( self:hFile, 0, FS_SET )
   else
      self:nMode := iif(nMode==NIL, FC_NORMAL, nMode)
      self:hFile = FCreate( cFileName, nMode )
      self:nLen  = 0
   endif
   self:nBufferLen := 2048

   self:create	:= @tf_create()
   self:open	:= @tf_open()
   self:close	:= @tf_close()
   self:end	:= @tf_close()
   self:skip	:= @tf_skip()
   self:goto	:= @tf_goto()
   self:goTop	:= @tf_goTop()
   self:goBottom:= @tf_goBottom()
   self:lEof	:= @tf_eof()
   self:Eof	:= @tf_eof()
   self:lBof	:= @tf_bof()
   self:Bof	:= @tf_bof()
   self:nRecno	:= @tf_recno()
   self:Recno	:= @tf_recno()
   self:nGetByte:= @tf_getByte()
   self:GetByte	:= @tf_getByte()
   self:nGetWord:= @tf_getWord()
   self:GetWord	:= @tf_getWord()
   self:cGetStr	:= @tf_getStr()
   self:GetStr	:= @tf_getStr()
   self:putByte	:= @tf_putByte()
   self:putWord	:= @tf_putWord()
   self:putStr	:= @tf_putStr()
   self:appByte	:= @tf_appByte()
   self:appWord	:= @tf_appWord()
   self:appStr	:= @tf_appStr()
   self:count	:= @tf_count()
   self:seek	:= @tf_seek()
   self:delBytes:= @tf_delBytes()
   self:insBytes:= @tf_insBytes()

return self

******************************************************************
static function tf_Create( cFileName, nMode )
   FErase( cFileName )
   ::New( cFileName, nMode )
return nil
******************************************************************
static function tf_Open()
return  ::hFile >= 0
******************************************************************
static function tf_close()
  FClose( ::hFile )
  ::hFile := -1
return NIL
******************************************************************
static function tf_skip( nBytes )
return FSeek( ::hFile, nBytes, FS_RELATIVE )
******************************************************************
static function tf_goto( nRecno )
return FSeek( ::hFile, nRecno, FS_SET )
******************************************************************
static function tf_goTop( )
return  FSeek( ::hFile, 0, FS_SET )
******************************************************************
static function tf_goBottom( )
return  ::nLen := FSeek( ::hFile, 0, FS_END )
******************************************************************
static function tf_eof( )
return FSeek( ::hFile, 0, FS_RELATIVE ) >= ::nLen
******************************************************************
static function tf_bof( )
return  FSeek( ::hFile, 0, FS_RELATIVE ) == 0
******************************************************************
static function tf_recno( )
return FSeek( ::hFile, 0, FS_RELATIVE )
******************************************************************
static function tf_GetByte()
       local cByte := " "
return iif( FRead( ::hFile, @cByte, 1 ) == 1, Asc( cByte ), -1 )
******************************************************************
static function tf_GetWord()
	local cWord := "  "
return If( FRead( ::hFile, @cWord, 2 ) == 2, Bin2I( cWord ), -1 )
******************************************************************
static function tf_GetStr( nLen )
   local cStr := Space(nLen)
   local nRead
   nRead := FRead( ::hFile, @cStr, nLen )
return Left(cStr, nRead)
******************************************************************
static function tf_PutByte( nByte )
   local cByte := Chr( nByte )
return FWrite( ::hFile, @cByte, 1 )
******************************************************************
static functio tf_PutWord( nWord )
   local cWord := I2Bin( nWord )
return FWrite( ::hFile, @cWord, 2 )
******************************************************************
static functio tf_putStr(cStr)
return FWrite( ::hFile, cStr, len(cStr) )
******************************************************************
static function tf_AppByte( nByte )
	Fseek( ::hFile, 0, FS_END )
        ::PutByte( nByte )
        ::nLen++
return ::nLen
******************************************************************
static function tf_AppWord( nWord )
	Fseek( ::hFile, 0, FS_END )
	::PutWord( nWord )
	::nLen += 2
return ::nLen
******************************************************************
static function tf_AppStr( cStr )
	Fseek( ::hFile, 0, FS_END )
        ::PutStr( cStr )
        ::nLen += len( cStr )
return ::nLen
******************************************************************
static function tf_Count( cStr )
   local cBuffer
   local nCounter, nRecno, nAt
   cStr := iif(cStr==NIL, CRLF, cStr)
   IF ::nLen == 0
     	RETURN 0
   ENDIF
   nCounter := 0
   nRecno   := Fseek( ::hFile, 0, FS_RELATIVE )
   FSeek( ::hFile, 0, FS_SET )
   while ! ::lEof()
     cBuffer := ::cGetStr( ::nBufferLen )
     while ( nAt := At( cStr, cBuffer ) ) > 0
        nCounter++
        cBuffer := Substr( cBuffer, nAt + Len( cStr ) )
     end
   end
   Fseek( ::hFile, nRecno, FS_SET )
return nCounter
******************************************************************
static function tf_Seek( cStr, nDirection, nCase )
   local cBuffer
   local nRecno, nOffset, nAt, nBufferLen, nCounter
   nDirection := iif(nDirection==NIL, SEEK_FORWARD, nDirection)
   nCase      := iif(nCase==NIL, SEEK_NOCASE, nCase)
   nRecno     := Fseek( ::hFile, 0, FS_RELATIVE )
   nBufferLen := ::nBufferLen
   nCounter   := 0
   cBuffer    := space(nBufferLen)
   While len(cBuffer) == ::nBufferLen
     IF nDirection == SEEK_BACKWARD
          nRecno     :=Fseek( ::hFile, 0, FS_RELATIVE )
          nBufferLen := Min(nBufferLen, nRecno)
          Fseek( ::hFile, -nBufferLen, FS_RELATIVE )
     ENDIF
     nOffset := Fseek( ::hFile, 0, FS_RELATIVE )
     cBuffer := ::cGetStr(nBufferLen)
     Do Case
     Case nCase == SEEK_UPCASE
          cBuffer := Upper(cBuffer)
     Case nCase == SEEK_LOCASE
          cBuffer := Lower(cBuffer)
     EndCase
     If nDirection == SEEK_FORWARD
          nAt := At(cStr,cBuffer)
     Else
          nAt := Rat(cStr,cBuffer)
     Endif
     If nAt > 0
          Fseek( ::hFile, nOffset + nAt - 1 , FS_SET )
          retu .T.
     Endif
     IF nDirection == SEEK_FORWARD
          Fseek( ::hFile, -len(cStr), FS_RELATIVE )
     ELSE
          Fseek( ::hFile, len(cStr), FS_RELATIVE )
     ENDIF
   Enddo
   Fseek( ::hFile, nRecno, FS_SET )
return .F.

******************************************************************
static function tf_DelBytes( nLen )
     LOCAL cTmpFile, cBuffer
     LOCAL nHandle, nRecno, nCopy, nRead
     IF nLen == NIL .OR. empty(nLen)
          RETURN .F.
     ENDIF
     cTmpFile := NoExt(::cName)+".#$#"
     cBuffer  := space(::nBufferLen)
     nHandle  := Fcreate(cTmpFile)
     nRecno   := Fseek( ::hFile, 0, FS_RELATIVE )
     nCopy    := 0
     IF nHandle < 0
          RETURN .F.
     ENDIF
     Fseek( ::hFile, 0, FS_SET )
     DO WHILE nRecno > 0 .AND. Fseek( ::hFile, 0, FS_RELATIVE ) < nRecno
          nRead := FRead( ::hFile, @cBuffer, ::nBufferLen )
          nCopy := Min(nRead, nRecno - FSeek( nHandle, 0, FS_RELATIVE ) )
          FWrite(nHandle, cBuffer, nCopy)
     ENDDO
     Fseek( ::hFile, nRecno + nLen, FS_SET )
     nRead := ::nBufferLen
     DO WHILE nRead == ::nBufferLen
          nRead := FRead( ::hFile, @cBuffer, ::nBufferLen )
          FWrite(nHandle, cBuffer, nRead)
     ENDDO
     Fclose(nHandle)
     Fclose(::hFile)
     Ferase(::cName)
     Frename(cTmpFile, ::cName)
     ::nMode := FO_READWRITE + FO_EXCLUSIVE
     ::hFile = FOpen( ::cName, ::nMode )
     nRecno++
     IF nRecno >= ::nLen
          ::nLen := Fseek( ::hFile, 0, FS_END )
     ELSE
          Fseek( ::hFile, nRecno+1, FS_SET )
     ENDIF
     ::nLen -= nLen
RETURN .T.

******************************************************************
static function tf_InsBytes( nLen )
     LOCAL cTmpFile, cBuffer
     LOCAL nHandle, nRecno, nCopy, nRead
     IF nLen == NIL .OR. empty(nLen)
          RETURN .F.
     ENDIF
     IF ::lEof()
          ::AppStr( Space(nLen) )
          RETURN .T.
     ENDIF
     cTmpFile := NoExt(::cName)+".#$#"
     cBuffer  := space(::nBufferLen)
     nHandle  := Fcreate(cTmpFile)
     nRecno   := Fseek( ::hFile, 0, FS_RELATIVE )
     nCopy    := 0
     IF nHandle < 0
          RETURN .F.
     ENDIF
     Fseek( ::hFile, 0, FS_SET )
     DO WHILE nRecno > 0 .AND. Fseek( ::hFile, 0, FS_RELATIVE ) < nRecno
          nRead := FRead( ::hFile, @cBuffer, ::nBufferLen )
          nCopy := Min(nRead, nRecno - FSeek( nHandle, 0, FS_RELATIVE ) )
          FWrite(nHandle, cBuffer, nCopy)
     ENDDO
     Fseek( ::hFile, nRecno, FS_SET )
     Fwrite(nHandle, space(nLen), nLen)
     nRead := ::nBufferLen
     DO WHILE nRead == ::nBufferLen
          nRead := FRead( ::hFile, @cBuffer, ::nBufferLen )
          FWrite(nHandle, cBuffer, nRead)
     ENDDO
     Fclose(nHandle)
     Fclose(::hFile)
     Ferase(::cName)
     Frename(cTmpFile, ::cName)
     ::nMode := FO_READWRITE + FO_EXCLUSIVE
     ::hFile := FOpen( ::cName, ::nMode )
     Fseek( ::hFile, nRecno, FS_SET )
     ::nLen += nLen
RETURN .T.
******************************************************************
STATIC FUNCTION NoExt( cFile )
    local i := at( ".", cFile )
RETURN alltrim( if( i > 0, left( cFile, i-1 ), cFile ) )
