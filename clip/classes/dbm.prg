#include "dbms.ch"

******************************************************************
function tDbm()
	local obj	:= map()
        obj:classname	:= "TDBM"
        obj:afields	:= {}
        obj:aindexes	:= {}

        obj:new		:= @tdb_new()
        obj:create	:= @tdb_create()
        obj:redefine	:= @tdb_redefine()
        obj:addField	:= @tdb_addField()
        obj:addIndex	:= @tdb_addIndex()
        obj:readFields	:= @tdb_readFields()
 //       obj:readIndexes	:= @tdb_readIndexes()
        obj:writeFields	:= @tdb_writeFields()
//        obj:writeIndexes:= @tdb_writeIndexes()

return 	obj
******************************************************************
static function tdb_redefine(self)
	self:oDict:Update( Self )
return Self
******************************************************************
static function tdb_new(self, cAlias, cFile, cDriver, lShared, lReadOnly,;
		 aFields, aIndexes, oDict )
	local n
        self:cFile:=cFile
        self:cAlias:=cAlias
        self:cDriver:=cDriver
        self:lShared:=lShared
        self:lReadonly:=lReadonly
	self:odict:=odict
//        self:database:=tdatabase():new(cAlias)
   	if aFields != nil
		for n = 1 to len( aFields )
                	self:AddField( aFields[n] )
   	  	next
   	end
   	if aIndexes != nil
          	for n = 1 to len( aIndexes )
                  	self:AddIndex( aIndexes[n] )
   	  	next
   	end
	oDict:AddDb( Self )
	self:WriteFields()
Return Self
******************************************************************
static function tdb_addField(f)
	local n
	if ValType( F ) == "C"
        	n:=aScan( ::oDict:aFields,{ |e| e:cName == Upper( F ) } )
                if n>0
   			AAdd( ::aFields, aClone( ::oDict:aFields[ n ] ) )
                else
                	msgAlert([Field not found in dictonary])
                endif
	else
		AAdd( ::aFields, F )
	endif
return nil
******************************************************************
static function tdb_AddIndex( xIndex )
	local n
   	if ValType( xIndex ) == "C"
      		n:=aScan( ::oDict:aIndexes,{ |e| e:cName == Upper( xIndex ) } )
                if n>0
      			AAdd( ::aIndexes, aClone( ::oDict:aIndexes[ n ] ) )
                else
                	msgAlert([Index not found in dictonary])
                endif
   	else
      		AAdd( ::aIndexes, xIndex )
   	endif
return nil
******************************************************************
static function tdb_ReadFields()
   local nOldArea := Select()
   USE (::cFile + EXT_FLD) NEW READONLY
   While ! Eof()
      ::AddField( TField():New( Upper( FieldGet( 1 ) ),;  // Name.
                                Upper( FieldGet( 2 ) ),;  // Type.
                                FieldGet( 3 ),;           // Len.
                                FieldGet( 4 ) ) )         // Dec.
      SKIP
   end
   CLOSE
   Select ( nOldArea )
return nil
******************************************************************
static function tdb_WriteFields()
   local n, o, nLen := len( ::aFields ), nOldArea:= Select()
   DbCreate( ::cFile + EXT_FLD, aSTRU_FIELD )
   USE (::cFile + EXT_FLD) NEW
   for n = 1 to nLen
       o:= ::aFields[n]
       APPEND BLANK
       FieldPut( 1, o:cName )
       FieldPut( 2, o:cType )
       FieldPut( 3, o:nLen )
       FieldPut( 4, o:nDec )
   next
   CLOSE
   Select ( nOldArea )
Return nil
******************************************************************
static function tdb_Create()
   local oField, i, aStruct:= Array( Len( ::aFields ) )
   for i:= 1 to len( ::aFields )
       oField:= ::aFields[ i ]
       aStruct[i] := { oField:cName, oField:cType, oField:nLen, oField:nDec }
   next
   ::DbCreate( aStruct )
return nil
******************************************************************
