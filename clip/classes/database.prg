#include "set.ch"

function TDataBase()

	local obj 	:= map()
        obj:classname	:= "TDATABASE"
        obj:nArea	:= 0
        obj:lBuffer	:= NIL
        obj:lShared	:= .t.
        obj:lReadOnly	:= .f.
        obj:lTenChars	:= .t.
   	obj:lOemAnsi	:= NIL
        obj:aBuffer	:= NIL
        obj:aFldNames	:= {}
        obj:cAlias	:= ""
        obj:cFile	:= ""
        obj:cDriver	:= ""
   	obj:bBoF      	:= { || MsgStop( [Beginning of file] ) }
   	obj:bEoF      	:= { || MsgStop( [End of file] ) }
   	obj:bNetError 	:= { || MsgStop( [Record in use, Please, retry] ) }

        obj:new		:= @tdb_new()
	obj:Activate	:= @tdb_activate()
	obj:addIndex	:= @tdb_addIndex()
        obj:append	:= @tdb_append()
        obj:blank	:= @tdb_blank()
        obj:bof		:= @tdb_bof()
        obj:eof		:= @tdb_eof()
        obj:close	:= @tdb_close()
        obj:closeIndex	:= @tdb_closeIndex()
        obj:commit	:= @tdb_commit()
        obj:create	:= @tdb_create()
        obj:createIndex	:= @tdb_createIndex()
        obj:clearRelation:=@tdb_clearRel()
        obj:dbCreate	:= @tdb_dbCreate()
        obj:deActivate	:= @tdb_deActivate()
        obj:eval	:= @tdb_eval()
        obj:deleted	:= @tdb_deleted()
        obj:deleteIndex	:= @tdb_deleteIndex()
        obj:fcount	:= @tdb_fcount()
        obj:fieldName	:= @tdb_fieldName()
        obj:fieldPos	:= @tdb_fieldPos()
        obj:found	:= @tdb_found()
        obj:goto	:= @tdb_goto()
        obj:goTop	:= @tdb_gotop()
        obj:goBottom	:= @tdb_goBottom()
        obj:indexKey	:= @tdb_indexKey()
        obj:indexName	:= @tdb_indexName()
        obj:indexBagName:= @tdb_indexBagName()
        obj:indexorder	:= @tdb_indexOrder()
        obj:lastrec	:= @tdb_lastrec()
        obj:lock	:= @tdb_lock()
        obj:pack	:= @tdb_pack()
        obj:recall	:= @tdb_recall()
        obj:recCount	:= @tdb_recCount()
        obj:recLock	:= @tdb_rLock()
        obj:recno	:= @tdb_recno()
        obj:setOrder	:= @tdb_setOrder()
        obj:setRelation	:= @tdb_setRel()
        obj:unLock	:= @tdb_unLock()
        obj:used	:= @tdb_used()
        obj:zap		:= @tdb_zap()
        obj:skip	:= @tdb_skip()
        obj:load	:= @tdb_load()
        obj:skipper	:= @tdb_skipper()
        obj:modified	:= @tdb_modified()
        obj:save	:= @tdb_save()
        obj:setbuffer	:= @tdb_setBuffer()
        obj:seek	:= @tdb_seek()
        obj:fieldPut	:= @tdb_fieldPut()
        obj:_fieldPut	:= @tdb_fieldPut()
        obj:fieldGet	:= @tdb_fieldGet()
        obj:_fieldGEt	:= @tdb_fieldGet()
        obj:delete	:= @tdb_delete()
        obj:_delete	:= @tdb_delete()
        obj:ansiToOem	:= @tdb_ansi2oem()
        obj:_ansiToOem	:= @tdb_ansi2oem()
        obj:oemToAnsi	:= @tdb_oem2ansi()
        obj:_oemToAnsi	:= @tdb_oem2ansi()
        obj:onError	:= @tdb_onError()
return obj

******************************************************************
static function tdb_activate( )
   local OldArea:= Select()
   Select ( ::nArea )
   if ! Used()
      DbUseArea( .f., ::cDriver, ::cFile, ::cAlias, ::lShared, ::lReadOnly )
   endif
   Select ( OldArea )
return nil
******************************************************************
static function tdb_addIndex( cFile, cTag )
return ( ::nArea )->( OrdListAdd( cFile, cTag ) )
******************************************************************
static function tdb_append()
return ( ::nArea )->( DbAppend() )
******************************************************************
static function tdb_blank()
	local nrecno
( ::nArea )->( nRecNo := RecNo(), DBGoBottom(), DBSkip( 1 ), ;
               ::Load(), DBGoTo( nRecNo ) )
return nil
******************************************************************
static function tdb_bof()
return ( ::nArea )->( boF() )
******************************************************************
static function tdb_eof()
return ( ::nArea )->( eoF() )
******************************************************************
static function tdb_close()
return ( ::nArea )->( DbCloseArea() )
******************************************************************
static function tdb_closeIndex()
return ( ::nArea )->( OrdListClear() )
******************************************************************
static function tdb_commit()
return ( ::nArea )->( DBCommit() )
******************************************************************
static function tdb_create( File, Struct, Driver )
return DbCreate( File, Struct, Driver )
******************************************************************
static function tdb_createIndex( File, Tag, Key, block, Unique)
return ( ::nArea )->( OrdCreate( File, Tag, Key, block, Unique ) )
******************************************************************
static function tdb_clearRel()
return ( ::nArea )->( DbClearRelation() )
******************************************************************
static function tdb_dbCreate(struct)
return DbCreate( ::cFile, struct, ::cDriver )
******************************************************************
static function tdb_deActivate()
	local ret
	 ret:= ( ::nArea )->( DbCloseArea() )
	 ::nArea := 0
return ret
******************************************************************
static function tdb_eval( Block, For, While, Next, Record, Rest )
return ( ::nArea )->( DBEval( Block, For, While, Next, Record, Rest ) )
******************************************************************
static function tdb_deleted()
return ( ::nArea )->( Deleted() )
******************************************************************
static function tdb_deleteIndex( Tag, File )
return ( ::nArea )->( OrdDestroy( Tag, File ) )
******************************************************************
static function tdb_fcount()
return ( ::nArea )->( FCount() )
******************************************************************
static function tdb_fieldName( num )
return ( ::nArea )->( FieldName( num ) )
******************************************************************
static function tdb_fieldPos( cfieldName )
return ( ::nArea )->( FieldPos( cFieldName ) )
******************************************************************
static function tdb_found()
return ( ::nArea )->( Found() )
******************************************************************
static function tdb_goto( RecNo )
 	( ::nArea )->( DBGoTo( RecNo ) )
	If  ::lBuffer
		 ::Load()
        endif
return
******************************************************************
static function tdb_gotop( )
 	( ::nArea )->( DBGoTop() )
	If  ::lBuffer
		 ::Load()
        endif
return
******************************************************************
static function tdb_goBottom( )
 	( ::nArea )->( DBGoBottom() )
	If  ::lBuffer
		 ::Load()
        endif
return
******************************************************************
static function tdb_indexKey( Tag, File )
return ( ::nArea )->( OrdKey( Tag, File ) )
******************************************************************
static function tdb_indexName( Tag, File )
return ( ::nArea )->( OrdName( Tag, File ) )
******************************************************************
static function tdb_indexBagName( ind )
return ( ::nArea )->( OrdBagName( ind ) )
******************************************************************
static function tdb_indexOrder( Tag, File )
return ( ::nArea )->( OrdNumber( Tag, File ) )
******************************************************************
static function tdb_lastrec( )
return ( ::nArea )->( LastRec() )
******************************************************************
static function tdb_lock( )
return ( ::nArea )->( FLock() )
******************************************************************
static function tdb_pack( )
return ( ::nArea )->( __DbPack() )
******************************************************************
static function tdb_recall( )
return ( ::nArea )->( DBRecall() )
******************************************************************
static function tdb_recCount( )
return ( ::nArea )->( RecCount() )
******************************************************************
static function tdb_rLock( )
return ( ::nArea )->( RLock() )
******************************************************************
static function tdb_recno( )
return ( ::nArea )->( RecNo() )
******************************************************************
static function tdb_setOrder( Tag, File )
return ( ::nArea )->( OrdSetFocus( Tag, File ) )
******************************************************************
static function tdb_setRel( Area, Exp )
return ( ::nArea )->( DbSetRelation( Area, Compile( Exp ), Exp ) )
******************************************************************
static function tdb_unLock( )
return ( ::nArea )->( DBUnLock() )
******************************************************************
static function tdb_used( )
return ( ::nArea )->( Used() )
******************************************************************
static function tdb_zap( )
return ( ::nArea )->( __DbZap() )
******************************************************************
static function tdb_skip(self, nRec )
   nRec := iif(nRec==NIL, 1, nRec)
   ( self:nArea )->( DbSkip( nRec ) )
   if self:lBuffer
      self:Load()
   endif

   if self:Eof()
      if self:bEoF != nil
         Eval( self:bEoF, Self )
      endif
   endif

   if self:BoF()
      if self:bBoF != nil
         Eval( self:bBoF, Self )
      endif
   endif

return nil
******************************************************************
static func tdb_load()
   local n
   if ::lBuffer
      if Empty( ::aBuffer )
         ::aBuffer = Array( ::FCount() )
      endif
      for n = 1 to Len( ::aBuffer )
         ::aBuffer[ n ] = ( ::nArea )->( FieldGet( n ) )
      next
      if ::lOemAnsi
         ::OemToAnsi()
      endif
   endif
return nil
******************************************************************
static function tdb_new(self, wa )
   local n
   wa := iif(wa==NIL, Select(), wa)
   self:nArea     = wa
   self:cAlias    = Alias( wa )
   self:cFile     = Alias( wa )
   self:cDriver   = ( Alias( wa ) )->( DbSetDriver() )
   self:lShared   = .t.
   self:lReadOnly = .f.
   self:lBuffer   = .t.
   self:lOemAnsi  = .f.
   self:Load()
   self:aFldNames = {}
   for n = 1 TO ( self:cAlias )->( FCount() )
      AAdd( self:aFldNames, ( self:cAlias )->( FieldName( n ) ) )
   next
return Self
******************************************************************
static function tdb_skipper( nrec )
   local nSkip
   nRec := iif( nrec==NIL, 1, nrec)
   nSkip = ( ::nArea )->( DbSkipper( nRec ) )
   if ::lBuffer
      ::Load()
   endif
return nSkip
******************************************************************
static function tdb_Modified()
   local i, cField
   for i := 1 to Len( ::aFldNames )
      cField = ( ::cAlias )->( FieldName( i ) )
      if ( ::cAlias )->( FieldGet( i ) ) != ::aBuffer[ i ]
         return .t.
      endif
   next
return .f.
******************************************************************
static function tdb_save(self)
   local n
   if self:lBuffer
      if ! ( self:nArea )->( EoF() )
         if self:lShared
            if self:RecLock()
               for n := 1 to Len( self:aBuffer )
                  if self:lOemAnsi .and. ValType( self:aBuffer[ n ] ) == "C"
                     ( self:nArea )->( FieldPut( n, AnsiToOem( self:aBuffer[ n ] ) ) )
                  else
                     ( self:nArea )->( FieldPut( n, self:aBuffer[ n ] ) )
                  endif
               next
               self:UnLock()
            else
               if ! Empty( self:bNetError )
                  return Eval( self:bNetError, Self )
               else
                  MsgAlert( "Record in use", "Please, retry" )
               endif
            endif
         else
            for n := 1 to Len( self:aBuffer )
               if self:lOemAnsi .and. ValType( self:aBuffer[ n ] ) == "C"
                  ( self:nArea )->( FieldPut( n, AnsiToOem( self:aBuffer[ n ] ) ) )
               else
                  ( self:nArea )->( FieldPut( n, self:aBuffer[ n ] ) )
               endif
            next
         endif
      endif
   endif
return nil
******************************************************************
static function tdb_setBuffer( flag )
	flag:=iif( flag==NIL, .t., flag )
	::lBuffer = flag
   	if ::lBuffer
      		::Load()
   	else
      		::aBuffer := nil
   	endif
return ::lBuffer
******************************************************************
static function tdb_seek( Exp, flag )
   local Found
   flag := iif( flag==NIL, Set( _SET_SOFTSEEK ), flag )
   Found = ( ::nArea )->( DbSeek( Exp, flag ) )
   if ::lBuffer
      ::Load()
   endif
return Found
******************************************************************
static function tdb_fieldPut(self, pos, val )
   if self:lBuffer
      self:aBuffer[ pos ] := val
   else
      if self:lShared
         if self:RecLock()
            ( self:nArea )->( FieldPut( pos, val ) )
            self:UnLock()
         else
            if ! Empty( self:bNetError )
               return Eval( self:bNetError, Self )
            endif
         endif
      else
         ( self:nArea )->( FieldPut( pos, val ) )
      endif
   endif
return nil
******************************************************************
static function tdb_fieldGet( Pos )
   if ::lBuffer
      return ::aBuffer[ Pos ]
   else
      return ( ::nArea )->( FieldGet( Pos ) )
   endif
return nil
******************************************************************
static function tdb_delete()
   if ::lShared
      if ::Lock()
         ( ::nArea )->( DbDelete() )
         ::UnLock()
      else
         MsgAlert( [Can~t lock dataBase ! Please try again] )
      endif
   else
      ( ::nArea )->( DbDelete() )
   endif
return nil
******************************************************************
static function tdb_ansi2oem()
   local n
   for n = 1 to Len( ::aBuffer )
      if ValType( ::aBuffer[ n ] ) == "C"
         ::aBuffer[ n ] = AnsiToOem( ::aBuffer[ n ] )
      endif
   next
return nil
******************************************************************
static function tdb_oem2ansi()
   local n
   for n = 1 to Len( ::aBuffer )
      if ValType( ::aBuffer[ n ] ) == "C"
         ::aBuffer[ n ] = OemToAnsi( ::aBuffer[ n ] )
      endif
   next
return nil
******************************************************************
static function tdb_onError( msg, error )
	msgAlert([Called Error:]+";"+msg)
return nil

******************************************************************
static function Compile( Exp )
return &( "{||" + Exp + "}" )

