#INCLUDE "button.ch"
#INCLUDE "browsys.ch"
#INCLUDE "inkey.ch"
#INCLUDE "Set.ch"
#INCLUDE "SetCurs.ch"
#INCLUDE "tbrowse.ch"
#INCLUDE "llibg.ch"

#DEFINE NVALTYPE_CHAR      67
#DEFINE NVALTYPE_DATE      68
#DEFINE NVALTYPE_LOGICAL   76
#DEFINE NVALTYPE_NUMERIC   78
#DEFINE NVALTYPE_BLOCK     66
#DEFINE NVALTYPE_ARRAY     65
#DEFINE NVALTYPE_NIL       85


/*****************************************************************************
*  tbCreate( <uOwner>, <nTop>, <nLeft>, <nBottom>, <nRight>
*              [, <cColorInfo>] ) -> aTBinfo
*  create and initialize a browse window.
*
*****************************************************************************/
FUNCTION tbCreate( uOwner, nTop, nLeft, nBottom, nRight, cColorInfo, cBorder, lAppend, lUpdate )
   LOCAL oBrowse, aTBinfo

      oBrowse := tBrowseNew( nTop, nLeft, nBottom, nRight )
      oBrowse:AutoLite      := .F.
      oBrowse:HeadSep       := "Ä" //utf-8: "‚îÄ"
      oBrowse:ColSep        := "Å"//utf-8: "‚îÇ"
      oBrowse:SkipBlock     := { | x | tbSkip( aTBInfo, x ) }

      IF ( ValType( uOwner ) == "A" )
         oBrowse:GoTopBlock    := { || aTBinfo[ TBR_POSITION ] := 1 }
         oBrowse:GoBottomBlock := { || aTBinfo[ TBR_POSITION ] := Len( aTBinfo[ TBR_REFERENCE ] ) }

      ELSE
         oBrowse:GoTopBlock    := { || tbGoTop( aTBInfo ) }
         oBrowse:GoBottomBlock := { || tbGoBot( aTBInfo ) }

      ENDIF

      IF ( ValType( cColorInfo ) == "C" )
         oBrowse:ColorSpec := cColorInfo
      ENDIF

      IF ( ValType( cBorder ) == "C" )
         oBrowse:Border := cBorder
      ENDIF

      IF ( ValType( lAppend ) == "L" )
         oBrowse:SetStyle( TBR_APPEND, lAppend )

      ELSE
         lAppend := .F.

      ENDIF

      IF ( ValType( lUpdate ) == "L" )
         oBrowse:SetStyle( TBR_MODIFY, lUpdate )

      ELSE
         lUpdate := .F.

      ENDIF

      IF ( lUpdate )
         oBrowse:SetKey( 0, { | oB, nK | tbEditCell( oB, nK ) } )
      ENDIF

      aTBinfo := ARRAY( TBR_ELEMENTS )

      aTBinfo[ TBR_BROWSE      ] := oBrowse
      aTBinfo[ TBR_SAVESCREEN  ] := ""
      aTBinfo[ TBR_REFERENCE   ] := uOwner
      aTBinfo[ TBR_COLINFO     ] := {}
      aTBinfo[ TBR_FILTERBLOCK ] := { || .T. }

      IF ( ( SET( _SET_VIDEOMODE ) == LLG_VIDEO_TXT ) .OR.;
           ( SET( _SET_VIDEOMODE ) == NIL ) )

         aTBinfo[ TBR_SAVESCREEN ] := CHR( oBrowse:nTop    )     + ;
                                      CHR( oBrowse:nLeft   )     + ;
                                      CHR( oBrowse:nBottom )     + ;
                                      CHR( oBrowse:nRight  )     + ;
                                      SAVESCREEN( oBrowse:nTop   , ;
                                                  oBrowse:nLeft  , ;
                                                  oBrowse:nBottom, ;
                                                  oBrowse:nRight )
      ELSE     // Graphic mode

         aTBinfo[ TBR_SAVESCREEN ] := SaveScreen( oBrowse:nTop,    ;
                                                  oBrowse:nLeft,   ;
                                                  oBrowse:nBottom, ;
                                                  oBrowse:nRight )
         AADD( aTBinfo[ TBR_SAVESCREEN ], oBrowse:nTop )
         AADD( aTBinfo[ TBR_SAVESCREEN ], oBrowse:nLeft )
         AADD( aTBinfo[ TBR_SAVESCREEN ], oBrowse:nBottom )
         AADD( aTBinfo[ TBR_SAVESCREEN ], oBrowse:nRight )

      ENDIF

  RETURN ( aTBinfo )


/*****************************************************************************
*  tbClose( <aTBinfo> ) -> aTBinfo
*  close a browse window.
*
*****************************************************************************/
FUNCTION tbClose( aTBinfo )

   LOCAL nLen, n1, n2, n3, n4

      IF ( ( SET( _SET_VIDEOMODE ) == LLG_VIDEO_TXT ) .OR.;
           ( SET( _SET_VIDEOMODE ) == NIL ) )

          RESTSCREEN( ASC( SUBSTR( aTBinfo[ TBR_SAVESCREEN ], 1, 1 ) ), ;
                      ASC( SUBSTR( aTBinfo[ TBR_SAVESCREEN ], 2, 1 ) ), ;
                      ASC( SUBSTR( aTBinfo[ TBR_SAVESCREEN ], 3, 1 ) ), ;
                      ASC( SUBSTR( aTBinfo[ TBR_SAVESCREEN ], 4, 1 ) ), ;
                           SUBSTR( aTBinfo[ TBR_SAVESCREEN ], 5    ) )

      ELSE      // Graphic mode

          nLen := LEN( aTBinfo[ TBR_SAVESCREEN ] )
          n1 := aTBinfo[ TBR_SAVESCREEN ][ nLen - 3 ]
          n2 := aTBinfo[ TBR_SAVESCREEN ][ nLen - 2 ]
          n3 := aTBinfo[ TBR_SAVESCREEN ][ nLen - 1 ]
          n4 := aTBinfo[ TBR_SAVESCREEN ][ nLen ]

          RESTSCREEN( n1, n2, n3, n4, aTBinfo[ TBR_SAVESCREEN ] )

      ENDIF

   RETURN ( NIL )


/*****************************************************************************
*  tbDisplay( <aTBinfo>, <lMode> ) -> aTBinfo
*  display a browse window.
*
*****************************************************************************/
FUNCTION tbDisplay( aTBinfo, lMode )


      IF ( ! ValType( lMode ) == "L" )
         lMode := .F.
      ENDIF

      IF ( lMode )
         aTBinfo[ TBR_BROWSE ]:Invalidate()

      ELSE
         aTBinfo[ TBR_BROWSE ]:RefreshAll()

      ENDIF

      aTBinfo[ TBR_BROWSE ]:ForceStable()

   RETURN ( aTBInfo )


/*****************************************************************************
*  tbAddCol( <aTBinfo>, <aColInfo> ) -> aTBinfo
*  add a column to a browse.
*
*****************************************************************************/
FUNCTION tbAddCol( aTBinfo, aColInfo )
   RETURN ( MakeColumn( aTBinfo, aColInfo, NIL ) )


/*****************************************************************************
*  tbInsCol( <aTBinfo>, <aColInfo>, <nPosition> ) -> aTBinfo
*  insert a column into a browse.
*
*****************************************************************************/
FUNCTION tbInsCol( aTBinfo, aColInfo, nPosition )
   RETURN ( MakeColumn( aTBinfo, aColInfo, nPosition ) )


/*****************************************************************************
*  MakeColumn( <aTBinfo>, <aColInfo>, <nPosition> ) -> aTBinfo
*  create a new tBrowse column.
*
*****************************************************************************/
static FUNCTION MakeColumn( aTBinfo, aColInfo, nPosition )
   LOCAL oColumn

/*--- determine if the column is being appended or inserted. */
      IF ( ! VALTYPE( nPosition ) == "N" )
         nPosition := LEN( aTBinfo[ TBR_COLINFO ] ) + 1

      ELSEIF ( nPosition < 1 )
         RETURN ( aTBinfo )

      ELSEIF ( nPosition > LEN( aTBinfo[ TBR_COLINFO ] ) )
         RETURN ( aTBinfo )

      ENDIF

      AADD( aTBinfo[ TBR_COLINFO ], aColInfo[ TBC_OWNERCOL ] )

      IF ( ValType( aTBinfo[ TBR_REFERENCE ] ) == "A" )

         oColumn := tbColumnNew( aColInfo[ TBC_HEADING ], ;
                    { | x | IIF( x == NIL,                                              ;
                    aTBinfo[ TBR_REFERENCE, aTBinfo[ TBR_POSITION ] ],       ;
                    aTBinfo[ TBR_REFERENCE, aTBinfo[ TBR_POSITION ] ] := x ) } )
      ELSE
         oColumn := tbColumnNew( aColInfo[ TBC_HEADING ], ;
         FieldWblock( aColInfo[ TBC_OWNERCOL ], Select( aTBinfo[ TBR_REFERENCE ] ) ) )

      ENDIF

      aColInfo := aSize( aColInfo, TBC_ELEMENTS )

      oColumn:ColorBlock   := aColInfo[ TBC_COLORBLOCK ]
      oColumn:ColSep       := aColInfo[ TBC_COLSEP     ]
      oColumn:DefColor     := aColInfo[ TBC_DEFCOLOR   ]
      oColumn:Footing      := aColInfo[ TBC_FOOTING    ]
      oColumn:FootSep      := aColInfo[ TBC_FOOTSEP    ]
      oColumn:Heading      := aColInfo[ TBC_HEADING    ]
      oColumn:HeadSep      := aColInfo[ TBC_HEADSEP    ]
      oColumn:Width        := aColInfo[ TBC_WIDTH      ]
      oColumn:Picture      := aColInfo[ TBC_PICTURE    ]
      oColumn:PreBlock     := aColInfo[ TBC_PREBLOCK   ]
      oColumn:PostBlock    := aColInfo[ TBC_POSTBLOCK  ]

      IF ( ValType( aColInfo[ TBC_CANWRITE ] ) == "L" )
         oColumn:SetStyle( TBC_READWRITE, aColInfo[ TBC_CANWRITE ] )
      ENDIF

      aTBinfo[ TBR_BROWSE ]:AddColumn( oColumn )


   RETURN ( aTBinfo )


/*****************************************************************************
*  tbDelCol( <aTBinfo>, <nPosition> ) -> aTBinfo
*  delete a column from a browse.
*
*****************************************************************************/
FUNCTION tbDelCol( aTBinfo, nPosition )
   local aColInfo

      IF ( nPosition <= aTBinfo[ TBR_BROWSE ]:ColCount )
         aTBinfo[ TBR_BROWSE ]:DelColumn( nPosition )
         aColInfo := aTBInfo[ TBR_COLINFO ]
         aDel( aColInfo, nPosition )
         aSize( aColInfo, Len( aColInfo ) - 1 )
      ENDIF

   RETURN ( aTBinfo )


/*****************************************************************************
*  tbSblock( <aTBinfo>, <bBlock> ) -> bBlock
*  get/set the seek block.
*
*****************************************************************************/
FUNCTION tbSblock( aTBinfo, bBlock )
   LOCAL bReturn

      bReturn := aTBinfo[ TBR_SEEKBLOCK ]

      IF ( ValType( bBlock ) == "B" )
         aTBinfo[ TBR_SEEKBLOCK ] := bBlock
      ENDIF

   RETURN ( bReturn )


/*****************************************************************************
*  tbFblock( <aTBinfo>, <bBlock> ) -> bBlock
*  get/set the filter block.
*
*****************************************************************************/
FUNCTION tbFblock( aTBinfo, bBlock )
   LOCAL bReturn

      bReturn := aTBinfo[ TBR_FILTERBLOCK ]

      IF ( ValType( bBlock ) == "B" )
         aTBinfo[ TBR_FILTERBLOCK ] := bBlock
      ENDIF

   RETURN ( bReturn )


/*****************************************************************************
*  tbBblock( <aTBinfo>, <bBlock> ) -> bBlock
*  get/set the gobottom block.
*
*****************************************************************************/
FUNCTION tbBblock( aTBinfo, bBlock )
   LOCAL nPosition, bReturn

      bReturn := aTBinfo[ TBR_BBLOCK ]

      IF ( ValType( bBlock ) == "B" )
         aTBinfo[ TBR_BBLOCK ] := bBlock
      ENDIF

   RETURN ( bReturn )


/*****************************************************************************
*  tbGoTop( <aTBinfo> ) -> aTBinfo
*  go to the top of a browse.
*
*****************************************************************************/
FUNCTION tbGoTop( aTBinfo )
   LOCAL bSeek
      bSeek   := aTBinfo[ TBR_SEEKBLOCK ]
      IF ( bSeek == NIL )
         ( aTBinfo[ TBR_REFERENCE ] )->( dbGoTop() )
      ELSE
         Eval( bSeek, aTBinfo )
      ENDIF

   RETURN ( aTBinfo )


/*****************************************************************************
*  tbGoBot( <aTBinfo> ) -> aTBinfo
*  go to the bottom of a browse.
*
*****************************************************************************/
FUNCTION tbGoBot( aTBinfo )
   LOCAL bBot, bSeek, bFilter, cAlias
      bBot   := aTBinfo[ TBR_BBLOCK ]
      IF ( bBot == NIL )
        bSeek   := aTBinfo[ TBR_SEEKBLOCK ]
        IF (bSeek != NIL )
          Eval( bSeek, aTBinfo )
          cAlias  := aTBinfo[ TBR_REFERENCE ]
          bFilter   := aTBinfo[ TBR_FILTERBLOCK ]
			    IF ( ! ( cAlias )->( eof() ) )
		        WHILE ( .T. )
   		        ( cAlias ) -> ( dbSkip( 1 ) )
			        IF ( ( ( cAlias )->( eof() ) ) .OR. ;
                      ( ! Eval( bFilter, aTBinfo ) ) )
      			        ( cAlias )->( dbSkip( -1 ) )
                    EXIT
			        ENDIF
		        ENDDO
          ENDIF
        ELSE
          ( aTBinfo[ TBR_REFERENCE ] )->( dbGoBottom() )
        ENDIF
      ELSE
         Eval( bBot, aTBinfo )
      ENDIF

   RETURN ( aTBinfo )


/*****************************************************************************
*  tbSkip( <aTBinfo>, <nRows> ) -> nRowsMoved
*  skip one or more rows in a browse.
*
*****************************************************************************/
FUNCTION tbSkip( aTBinfo, nAmount )
   LOCAL nPos, nLength, nReturn, nDirection, cAlias, bFilter, lIsAppend

      bFilter   := aTBinfo[ TBR_FILTERBLOCK ]
      lIsAppend := aTBinfo[ TBR_BROWSE ]:SetStyle( TBR_APPENDING )

      IF ( ValType( aTBinfo[ TBR_REFERENCE ] ) == "A" )
         nPos := aTBInfo[ TBR_POSITION ] + nAmount

         IF ( nPos < 1 )
            nAmount += ( ABS( nPos ) + 1 )
            nPos := 1

         ELSEIF ( nPos > ( nLength := LEN( ( aTBInfo[ TBR_REFERENCE ] ) ) ) )
            nAmount -= ( nLength - nPos )
            nPos := nLength

         ENDIF

         aTBInfo[ TBR_POSITION ] := nPos

      ELSE
	      nReturn := 0
         cAlias  := aTBinfo[ TBR_REFERENCE ]

	      IF ( LastRec() != 0 )
		      IF ( nAmount == 0 )
		         ( cAlias )->( dbSkip( 0 ) )

		      ELSEIF ( ( nAmount > 0 ) .AND. ( ! ( cAlias )->( Eof() ) ) )
		         WHILE ( nReturn < nAmount )
   		         ( cAlias )->( dbSkip( 1 ) )

			         IF ( ( ( cAlias )->( eof() ) ) .OR. ;
                       ( ! Eval( bFilter, aTBinfo ) ) )

                     IF ( lIsAppend )
			                  IF ( ! ( cAlias )->( eof() ) )
         			            ( cAlias )->( dbGoBottom() )
         			            ( cAlias )->( dbSkip( 1 ) )
                        ENDIF
                        nReturn ++

                     ELSE
      			         ( cAlias )->( dbSkip( -1 ) )

                     ENDIF

				         EXIT
			         ENDIF

			         nReturn ++
		         ENDDO

		      ELSEIF ( nAmount < 0 )
               IF ( ( cAlias )->( Eof() ) )
                  Eval( aTBinfo[ TBR_BROWSE ]:GoBottomBlock )
                  nReturn --
               ENDIF
   		      WHILE ( nReturn > nAmount )
      		      ( cAlias )->( dbSkip( -1 ) )
		   	      IF ( ( cAlias )->( bof() ) )
				         EXIT

		   	      ELSEIF ( ! Eval( bFilter, aTBinfo ) )
         			   ( cAlias )->( dbSkip( 1 ) )
				         EXIT

			         ENDIF

			         nReturn --
   		      ENDDO
		      ENDIF
	      ENDIF

         aTBInfo[ TBR_POSITION ] := ( cAlias )->( RECNO() )
      ENDIF

   RETURN ( nReturn )


/*****************************************************************************
*  tbModal( <oBrowse> ) -> nKey
*  give input focus to a browse.
*
*****************************************************************************/
FUNCTION tbModal( oBrowse )
   LOCAL nKey, nSaveCursor, lAutoLite

      nSaveCursor      := SetCursor( SC_NONE )
      lAutoLite        := oBrowse:AutoLite
      oBrowse:AutoLite := .T.

      WHILE ( .T. )
         WHILE ( ( ( nKey := Inkey() ) == 0 ) .AND. ( ! oBrowse:Stabilize() ) )
         ENDDO

         IF ( nKey == 0 )
            /* nKey is 0, so the browse must be stable. */
            IF ( ( oBrowse:hitBottom ) .AND. ;
                 ( oBrowse:SetStyle( TBR_APPEND ) ) .AND. ;
                 ( ! oBrowse:SetStyle( TBR_APPENDING ) ) )
               oBrowse:SetStyle( TBR_APPENDING, .T. )
               nKey := K_DOWN

            ELSE
               nKey := Inkey( 0 )

            ENDIF
         ENDIF

         IF ( ( nKey == K_CTRL_PGDN ) .OR. ( nKey == K_CTRL_PGUP ) )
            oBrowse:SetStyle( TBR_APPENDING, .F. )

         ELSEIF ( ( nKey == K_UP ) .OR. ( nKey == K_PGUP ) )
            IF ( oBrowse:SetStyle( TBR_APPENDING ) )
               oBrowse:SetStyle( TBR_APPENDING, .F. )
               oBrowse:refreshAll()
            ENDIF

         ELSEIF ( ( nKey == K_LBUTTONDOWN ) .AND. ;
                  ( oBrowse:mRowPos != oBrowse:RowPos ) .AND. ;
                  ( oBrowse:HitTest( mRow(), mCol() ) == HTCELL ) )
            IF ( oBrowse:SetStyle( TBR_APPENDING ) )
               oBrowse:SetStyle( TBR_APPENDING, .F. )
               oBrowse:refreshAll()
            ENDIF
         ENDIF

         IF ( oBrowse:ApplyKey( nKey ) == TBR_EXIT )
            EXIT
         ENDIF
      ENDDO

      oBrowse:AutoLite := lAutoLite
      oBrowse:deHilite()

      SetCursor( nSaveCursor )

   RETURN ( nKey )


/*****************************************************************************
*  tbEditCell( <oBrowse>, <nKey> ) -> uNewValue
*  modify the current cell.
*
*****************************************************************************/
FUNCTION tbEditCell( oBrowse, nKey )
   LOCAL bSaveInsert, GetList, lAppend, nLength, nSaveCursor, oColumn, ;
         uNewKey, uSavKey
      IF ( ! oBrowse:SetStyle( TBR_MODIFY ) )
         RETURN ( TBR_EXCEPTION )
      ENDIF

      oColumn  := oBrowse:GetColumn( oBrowse:ColPos )

      IF ( ! oColumn:SetStyle( TBC_READWRITE ) )
         RETURN ( TBR_EXCEPTION )
      ENDIF

      IF ( nKey == K_ENTER )
      ELSEIF ( nKey < 32 )
         RETURN ( TBR_EXCEPTION )

      ELSEIF ( nKey > 255 )
         RETURN ( TBR_EXCEPTION )

      ENDIF

      IF ( Eof() )
         lAppend := .T.

      ELSE
         lAppend := oBrowse:SetStyle( TBR_APPENDING )

      ENDIF

      oBrowse:ForceStable()

      IF ( lAppend )
         dbAppend()
      ENDIF

      uSavKey := iif( Empty( IndexKey() ), NIL, &( IndexKey() ) )
      nLength := oBrowse:colWidth( oBrowse:colPos )

      KeyBoard( Chr( nKey ) )

      /* Create a corresponding GET. */
      GetList := { getnew( row(), col(),        ;
                           oColumn:block,       ;
                           oColumn:heading,     ;
                           oColumn:picture,     ;
                           oBrowse:colorSpec ) }

      GetList[ 1 ]:PreBlock  := oColumn:PreBlock
      GetList[ 1 ]:PostBlock := oColumn:PostBlock

      bSaveInsert  := setkey( K_INS, { || InsToggle() } )
      nSaveCursor := SetCursor( iif( ReadInsert(), SC_INSERT, SC_NORMAL ) )

      ReadModal( GetList )

      setcursor( nSaveCursor )
      setkey( K_INS, bSaveInsert )

      oBrowse:SetStyle( TBR_APPENDING, .F. )

      // Get the record's key value (or NIL) after the GET
      uNewKey := if( empty( indexkey() ), NIL, &( indexkey() ) )

      oBrowse:Invalidate()
      oBrowse:RefreshAll():ForceStable()

      IF ( ! ( uNewKey == uSavKey ) .or. ( lAppend .and. uNewKey != NIL ) )
         /* perform a complete refresh. */
         oBrowse:refreshAll():forceStable()

      ENDIF

      /* Check the exit key from the read. */
      nKey := LastKey()
      IF ( ( nKey == K_UP   ) .OR. ;
           ( nKey == K_DOWN ) .OR. ;
           ( nKey == K_PGUP ) .OR. ;
           ( nKey == K_PGDN )      )

         /* Yea, yea. What's a guy to do? */
         keyboard( chr( nKey ) )
      ENDIF

   RETURN ( TBR_CONTINUE )


/*****************************************************************************
*   InsToggle()
*
*   Toggle the global insert mode and the cursor shape.
*
*****************************************************************************/
STATIC FUNCTIOn InsToggle()

      IF ( ReadInsert() )
         ReadInsert( .F. )
         SetCursor( SC_NORMAL )

      ELSE
         ReadInsert( .T. )
         SetCursor( SC_INSERT )

      ENDIF

   RETURN ( NIL )


/*****************************************************************************
*  tbMouse ( <oBrowse>, <nRow>, <nColumn> ) -> oBrowse
*  perform mouse related activities on a tBrowse object.
*
*****************************************************************************/
FUNCTION tbMouse( oBrowse, nRow, nCol )
   LOCAL nCount

      IF ( oBrowse:HitTest( nRow, nCol ) == HTCELL )

         nCount := oBrowse:mRowPos - oBrowse:RowPos
         WHILE ( nCount < 0 )
            nCount ++
            oBrowse:Up()
         ENDDO

         WHILE ( nCount > 0 )
            nCount --
            oBrowse:Down()
         ENDDO

         nCount := oBrowse:mColPos - oBrowse:ColPos
         WHILE ( nCount < 0 )
            nCount ++
            oBrowse:Left()
         ENDDO

         WHILE ( nCount > 0 )
            nCount --
            oBrowse:Right()
         ENDDO

         RETURN ( TBR_CONTINUE )
      ENDIF

   RETURN ( TBR_EXCEPTION )


/*****************************************************************************
*  FieldNBlock( <cAlias>, <cField> ) -> bGetSet
*  create a network aware get/set block.
*
*****************************************************************************/
FUNCTION FieldNBlock( cAlias, cField )
   LOCAL nField

      IF ( Select( cAlias ) == 0 )
         RETURN ( NIL )

      ELSEIF ( ( cAlias )->( ( nField := FieldPos( cField ) ) ) == 0 )
         RETURN ( NIL )

      ENDIF

   RETURN ( { | x | IIF( x == NIL, ( cAlias )->( FieldGet( nField ) ), ;
                                   FieldNPut( cAlias, cField, x ) ) } )


/*****************************************************************************
*  FieldNPut( <cAlias>, <cField>, <uData> ) -> lSuccess
*  create a network aware fieldput() function.
*
*****************************************************************************/
FUNCTION FieldNPut( cAlias, cField, uData )
   LOCAL nField, nSeconds

      IF ( Select( cAlias ) == 0 )
         RETURN ( .F. )

      ELSEIF ( ( cAlias )->( ( nField := FieldPos( cField ) ) ) == 0 )
         RETURN ( .F. )

      ENDIF

      nSeconds := Seconds()

      WHILE ( ! ( cAlias )->( dbRlock() ) )
         IF ( Seconds() < nSeconds )
         ELSEIF ( Alert( "ERROR: Unable to Save Information", ;
                         { "Retry", "Cancel" } ) != 1 )
            RETURN ( .F. )

         ELSE
            nSeconds := Seconds() + 20

         ENDIF

         Inkey( .2 )
      ENDDO

      ( cAlias )->( FieldPut( nField, uData ) )
      ( cAlias )->( dbrUnlock( ( cAlias )->( Recno() ) ) )


   RETURN ( .T. )

