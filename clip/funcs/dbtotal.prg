/******************************** */
/*
    Author   : stas (root@depot.pharm.sumy.ua)
    24.11.01 23:47
*/

#include "set.ch"
#include "error.ch"

FUNCTION __DBTOTAL( cFile, xKey, aFields,                 ;
                    xFor, xWhile, nNext, nRec, lRest, rdd ;
                  )

  LOCAL CurSelect, NewSelect, aNewDbStruct, aGetField, aFieldsSum, ;
   lDbTransRecord, xCurKey
  LOCAL __bKey, __bFor, __bWhile
  LOCAL cset, flag_err, err_block, __alias, wRec, err

  __alias:=tmpalias()
  err_block:=errorblock( { | x |BREAK( x ) } )
  flag_err:= .F.
  cset:=set( _SET_CANCEL, .f. )

  outlog( 3, "__dbTotal", cfile, alias(), xkey, "fields", aFields, "for", xfor, "while", xWhile, "next", nNext, "record", nRec, "rest", lRest, "rdd", rdd )

  IF ( valtype( xWhile )=="C" )
    __bWhile:="{||"+xWhile+"}"
    __bWhile:=&__bWhile
  ELSE
    IF ( valtype( xWhile )!="B" )
      __bWhile:={ ||.t. }
    ELSE
      __bWhile:=xWhile
      lRest:= .T.
    ENDIF

  ENDIF

  IF ( valtype( xFor )=="C" )
    __bFor:="{||"+xFor+"}"
    __bFor:=&xFor
  ELSE
    IF ( valtype( xFor )!="B" )
      __bFor:={ ||.t. }
    ELSE
      __bFor:=xFor
    ENDIF

  ENDIF

  Iif( lRest==NIL, .F., lRest )

  IF ( nRec != NIL )
    goto nRec
    nNext:= 1
  ELSE
    IF ( nNext==NIL )
      nNext:= -1
    ELSE
      lRest:= .T.
    ENDIF

    IF ( !lRest )
      goto top
    ENDIF

  ENDIF

  CurSelect:= Select()
  aNewDbStruct:= {}
  aeval( dbstruct(), { | _1 | iif( _1[ 2 ] == "M", NIL, AAdd( aNewDbStruct, _1 ) ) } )
  IF ( Empty( aNewDbStruct ) )
    RETURN ( .F. )
  ENDIF

  BEGIN SEQUENCE

    IF ( empty( xKey ) )
      xKey=indexkey()
    ENDIF

    IF ( empty( xKey ) )
      set( _SET_CANCEL, cset )
      err=errorNew()
      err:description:="invalid argument"
      err:genCode:=EG_ARG
      //err:operation:="__DBTOTAL"
      eval( errorblock(), err )
    //break(err)
    ENDIF

    IF ( valtype( xKey )=="C" )
      __bKey:="{||"+xKey+"}"
      __bKey:=&__bKey
    ELSE
      IF ( valtype( xKey )!="B" )
        __bKey:={ ||.t. }
      ELSE
        __bKey:=xKey
      ENDIF

    ENDIF

    aGetField:= {}
    aeval( aFields, { | _1 | AAdd( aGetField, getfield( _1 ) ) } )
    aFieldsSum:= array( Len( aGetField ) )

    dbcreate( cFile, aNewDbStruct, rdd )
    USE ( cFile ) NEW Exclusive alias ( __alias ) via ( rdd )

    NewSelect:= Select()
    select ( CurSelect )

    WHILE ( !EOF() .AND. nNext != 0 .AND. eval( __bWhile ) )
      lDbTransRecord:= .F.
      afill( aFieldsSum, 0 )
      xCurKey:= eval( __bKey )
      WHILE ( !EOF() .AND. nNext-- != 0 .AND. eval( __bWhile ) .AND. ;
              xCurKey == eval( __bKey )                              ;
            )
        IF ( eval( __bFor ) )
          IF ( !lDbTransRecord )

            wRec:=dbRead()
            select ( NewSelect )
            dbappend( , wRec )

            select ( CurSelect )

            lDbTransRecord:= .T.
          ENDIF

          aeval( aGetField, { | _1, _2 | aFieldsSum[ _2 ]:= aFieldsSum[ _2 ] + ;
                              eval( _1 )                                       ;
                            }                                                  ;
               )
        ENDIF

        skip
      ENDDO

      IF ( lDbTransRecord )
        select ( NewSelect )
        aeval( aGetField, { | _1, _2 | eval( _1, aFieldsSum[ _2 ] ) } )
        select ( CurSelect )
      ENDIF

    ENDDO

  RECOVER USING err
    flag_err:=.t.

  ENDSEQUENCE

  IF ( NewSelect != NIL )
    select ( NewSelect )
    CLOSE
  ENDIF

  select ( CurSelect )
  set( _SET_CANCEL, cset )
  errorblock( err_block )
  IF ( flag_err )
    err:operation+="/__DBTOTAL"
    eval( errorblock(), err )
  //break(err)
  ENDIF

  RETURN ( .t. )

/***********************************************************

    Author   : stas (root@depot.pharm.sumy.ua)
    24.11.01 23:47
*/

STATIC FUNCTION GETFIELD( cField )
  LOCAL nPos, SelectFromField, CurSelect, err, Local5
  CurSelect:= Select()

  IF ( ( nPos:= At( "->", cField ) ) > 0 )
    SelectFromField:= Left( cField, nPos - 1 )
    IF ( Select( SelectFromField ) != CurSelect )
      err:= ErrorNew()
      err:severity:=ES_ERROR
      err:gencode:=EG_SYNTAX
      err:subsystem:="DBCMD"
      err:candefaul:=.T.
      err:operation:=cField
      err:subcode:=1101
      Local5:= eval( errorblock(), err )
      IF ( ValType( Local5 ) != "L" .OR. Local5 )
      ENDIF

      BREAK ( err )
    ENDIF

    cField:= SubStr( cField, nPos + 2 )
  ENDIF

  RETURN ( fieldblock( cField ) )

**********************************************************
func tmpalias
local i, alias:="_tmp"
i:=1
while select(alias)!=0
  alias+=alltrim(str(i))
  i++
enddo
return alias

