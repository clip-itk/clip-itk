/*
 * Source     : DBFCDXAX.CH for CA-Clipper 5.2
 * Description: Header file for the Advantage CDX/IDX RDD (DBFCDXAX).
 *              Include this file in your application if you want to
 *              use any of the commands defined below with the Advantage
 *              CDX/IDX RDD (DBFCDXAX).  Also link DBFCDXAX.OBJ into your
 *              application if you want DBFCDXAX to be the default RDD.
 *              If you want to use DBFCDX and DBFCDXAX in the same
 *              application, you must also 'REQUEST DBFCDX' somewhere in
 *              your source code.
 *
 * Copyright 1994-1998 - Extended Systems, Inc.
 */

REQUEST DBFCDXAX


#command APPEND [FROM <(file)>]                                            ;
         [VIA <rdd>]                                                       ;
         [ALL]                                                             ;
      => AX_AppendFrom( <(file)>, <rdd> )

#command COPY [TO <(file)>]                                                ;
         [VIA <rdd>]                                                       ;
         [ALL]                                                             ;
      => AX_CopyTo( <(file)>, <rdd> )

#command SET PASSWORD TO <(password)>                                      ;
      => AX_SetPass( <(password)>, .T. )

#command SET PASSWORD TO                                                   ;
      => AX_SetPass( "", .T. )

#command BEGIN TRANSACTION                                                 ;
      => dbCommitAll()                                                     ;
       ; AX_Transaction( 1 )

#command COMMIT TRANSACTION                                                ;
      => dbCommitAll()                                                     ;
       ; AX_Transaction( 2 )

#command ROLLBACK TRANSACTION                                              ;
      => dbCommitAll()                                                     ;
       ; AX_Transaction( 3 )

#command SET RIGHTS CHECKING <x:ON,OFF>                                    ;
      => AX_RightsCheck( if( upper( <(x)> ) == "ON", .t., .f. ) )

#command SET EXPRESSION ENGINE <x:ON,OFF>                                  ;
      => AX_ExprEngine( if( upper( <(x)> ) == "ON", .t., .f. ) )

#command SET AXS LOCKING <x:ON,OFF>                                        ;
      => AX_AXSLocking( if( upper( <(x)> ) == "ON", .t., .f. )  )

#command SET TAGORDER TO <order>                                           ;
      => ordSetFocus( <order> )

#command SET TAGORDER TO                                                   ;
      => ordSetFocus( 0 )

#command SET ORDER TO TAG <(tag)>                                          ;
         [OF <(bag)>]                                                      ;
         [IN <(bag)>]                                                      ;
      => ordSetFocus( <(tag)> [, <(bag)>] )

#command SET TAG TO <(tag)>                                                ;
         [OF <(bag)>]                                                      ;
         [IN <(bag)>]                                                      ;
      => ordSetFocus( <(tag)> [, <(bag)>] )

#command SET TAG TO                                                        ;
      => ordSetFocus( 0 )

#command INDEX ON <key> TO <(file)>                                        ;
         [FOR       <for>]                                                 ;
         [<all:     ALL>]                                                  ;
         [WHILE     <while>]                                               ;
         [NEXT      <next>]                                                ;
         [RECORD    <rec>]                                                 ;
         [<rest:    REST>]                                                 ;
         [EVAL      <eval> [EVERY  <every>]]                               ;
         [OPTION    <eval> [STEP   <every>]]                               ;
         [<unique:  UNIQUE>]                                               ;
         [<ascend:  ASCENDING>]                                            ;
         [<descend: DESCENDING>]                                           ;
         [<cur:     USECURRENT>]                                           ;
         [<cur:     SUBINDEX>]                                             ;
         [<add:     ADDITIVE>]                                             ;
         [<custom:  CUSTOM>]                                               ;
         [<custom:  EMPTY>]                                                ;
         [<non:     NONCOMPACT>]                                           ;
      => ordCondSet( <"for">, <{for}>,                                     ;
                     if( <.all.>, .t., NIL ),                              ;
                     <{while}>,                                            ;
                     <{eval}>, <every>,                                    ;
                     RECNO(), <next>, <rec>,                               ;
                     if( <.rest.>, .t., NIL ),                             ;
                     if( (<.descend.> .AND. !<.ascend.>), .t., NIL ),      ;
                     .f., NIL, <.cur.>, <.custom.>, <.non.>, <.add.>, NIL, ;
                     <"while"> )                                           ;
       ; dbCreateIndex( <(file)>, <"key">, <{key}>,                        ;
                        if( <.unique.>, .t., NIL )  )

#command INDEX ON <key> TAG <(tag)>                                        ;
         [OF <(bag)>]                                                      ;
         [TO <(bag)>]                                                      ;
         [FOR        <for>]                                                ;
         [<all:      ALL>]                                                 ;
         [WHILE      <while>]                                              ;
         [NEXT       <next>]                                               ;
         [RECORD     <rec>]                                                ;
         [<rest:     REST>]                                                ;
         [EVAL       <eval> [EVERY  <every>]]                              ;
         [OPTION     <eval> [STEP   <every>]]                              ;
         [<unique:   UNIQUE>]                                              ;
         [<ascend:   ASCENDING>]                                           ;
         [<descend:  DESCENDING>]                                          ;
         [<cur:      USECURRENT>]                                          ;
         [<cur:      SUBINDEX>]                                            ;
         [<add:      ADDITIVE>]                                            ;
         [<custom:   CUSTOM>]                                              ;
         [<custom:   EMPTY>]                                               ;
      => ordCondSet( <"for">, <{for}>,                                     ;
                     if( <.all.>, .t., NIL ),                              ;
                     <{while}>,                                            ;
                     <{eval}>, <every>,                                    ;
                     RECNO(), <next>, <rec>,                               ;
                     if( <.rest.>, .t., NIL ),                             ;
                     if( (<.descend.> .AND. !<.ascend.>), .t., NIL ),      ;
                     .t., <(bag)>, <.cur.>, <.custom.>, .f., <.add.>, NIL, ;
                     <"while"> )                                           ;
       ; ordCreate( <(bag)>, <(tag)>, <"key">, <{key}>, [<.unique.>] )

#command SUBINDEX ON <key> TO <(file)>                                     ;
         [FOR       <for>]                                                 ;
         [<all:     ALL>]                                                  ;
         [WHILE     <while>]                                               ;
         [NEXT      <next>]                                                ;
         [RECORD    <rec>]                                                 ;
         [<rest:    REST>]                                                 ;
         [EVAL      <eval> [EVERY  <every>]]                               ;
         [OPTION    <eval> [STEP   <every>]]                               ;
         [<unique:  UNIQUE>]                                               ;
         [<ascend:  ASCENDING>]                                            ;
         [<descend: DESCENDING>]                                           ;
         [<non:     NONCOMPACT>]                                           ;
         [<add:     ADDITIVE>]                                             ;
         [<custom:  CUSTOM>]                                               ;
         [<custom:  EMPTY>]                                                ;
                                                                           ;
      => ordCondSet( <"for">, <{for}>,                                     ;
                     if( <.all.>, .t., NIL ),                              ;
                     <{while}>,                                            ;
                     <{eval}>, <every>,                                    ;
                     RECNO(), <next>, <rec>,                               ;
                     if( <.rest.>, .t., NIL ),                             ;
                     if( (<.descend.> .AND. !<.ascend.>), .t., NIL ),      ;
                     .f., NIL, .t., <.custom.>, <.non.>, <.add.>, NIL,     ;
                     <"while"> )                                           ;
       ; dbCreateIndex( <(file)>, <"key">, <{key}>,                        ;
                        if( <.unique.>, .t., NIL )  )

#command SUBINDEX ON <key> TAG <(tag)>                                     ;
         [OF <(bag)>]                                                      ;
         [TO <(bag)>]                                                      ;
         [FOR        <for>]                                                ;
         [<all:      ALL>]                                                 ;
         [WHILE      <while>]                                              ;
         [NEXT       <next>]                                               ;
         [RECORD     <rec>]                                                ;
         [<rest:     REST>]                                                ;
         [EVAL       <eval> [EVERY  <every>]]                              ;
         [OPTION     <eval> [STEP   <every>]]                              ;
         [<ascend:   ASCENDING>]                                           ;
         [<descend:  DESCENDING>]                                          ;
         [<unique:   UNIQUE>]                                              ;
         [<add:      ADDITIVE>]                                            ;
         [<custom:   CUSTOM>]                                              ;
         [<custom:   EMPTY>]                                               ;
                                                                           ;
      => ordCondSet( <"for">, <{for}>,                                     ;
                     if( <.all.>, .t., NIL ),                              ;
                     <{while}>,                                            ;
                     <{eval}>, <every>,                                    ;
                     RECNO(), <next>, <rec>,                               ;
                     if( <.rest.>, .t., NIL ),                             ;
                     if( (<.descend.> .AND. !<.ascend.>), .t., NIL ),      ;
                     .t., <(bag)>, .t., <.custom.>, .f., <.add.>, NIL,     ;
                     <"while"> )                                           ;
       ; ordCreate( <(bag)>, <(tag)>, <"key">, <{key}>, [<.unique.>] )


#command REINDEX                                                           ;
         [EVAL       <eval> [EVERY  <every>]]                              ;
         [OPTION     <eval> [STEP   <every>]]                              ;
      => ordCondSet(,,,, <{eval}>, <every>,,,,,,,,,,,,,)                   ;
       ; ordListRebuild()

#command DELETE TAG <(tag1)> [OF <(bag1)>]                                 ;
         [, <(tagn)> [OF <(bagn)>]]                                        ;
      => ordDestroy( <(tag1)>, <(bag1)> )                                  ;
      [; ordDestroy( <(tagn)>, <(bagn)> )]

#command DELETE TAG <(tag1)> [IN <(bag1)>]                                 ;
         [, <(tagn)> [IN <(bagn)>]]                                        ;
      => ordDestroy( <(tag1)>, <(bag1)> )                                  ;
      [; ordDestroy( <(tagn)>, <(bagn)> )]

#command DELETE TAG ALL                                                    ;
         [OF <(bag)>]                                                      ;
         [IN <(bag)>]                                                      ;
      => AX_KillTag( .t., <(bag)> )

#command CLEAR SCOPE                                                       ;
      => AX_ClrScope( 0 )                                                  ;
       ; AX_ClrScope( 1 )

#xcommand SET SCOPETOP TO <value>                                          ;
      => AX_SetScope( 0, <value> )

#xcommand SET SCOPETOP TO                                                  ;
      => AX_ClrScope( 0 )

#xcommand SET SCOPEBOTTOM TO <value>                                       ;
      => AX_SetScope( 1, <value> )

#xcommand SET SCOPEBOTTOM TO                                               ;
      => AX_ClrScope( 1 )

#command SET SCOPE TO                                                      ;
      => AX_ClrScope( 0 )                                                  ;
       ; AX_ClrScope( 1 )

#command SET SCOPE TO <value>                                              ;
      => AX_SetScope( 0, <value> )                                         ;
       ; AX_SetScope( 1, <value> )

#command SET MEMOBLOCK TO <value>                                          ;
      => AX_SetMemoBlock( <value> )

#command SORT [TO <(file)>] [ON <fields,...>]                              ;
         [FOR    <for>]                                                    ;
         [WHILE  <while>]                                                  ;
         [NEXT   <next>]                                                   ;
         [RECORD <rec>]                                                    ;
         [<rest: REST>]                                                    ;
         [ALL]                                                             ;
         [<cur:  USECURRENT>]                                              ;
                                                                           ;
      => AX_SortOption(<.cur.>)                                            ;
       ; __dbSort( <(file)>, { <(fields)> },                               ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.>)

#command AUTOUSE <(db)> VIA <rdd> ALTERNATE <altrdd>                       ;
         [ALIAS <a>]                                                       ;
         [<new: NEW>]                                                      ;
         [<ex: EXCLUSIVE>]                                                 ;
         [<sh: SHARED>]                                                    ;
         [<ro: READONLY>]                                                  ;
         [INDEX <(index1)> [, <(indexn)>]]                                 ;
                                                                           ;
      => if AX_Loaded( AX_GetDrive( <(db)> ) )                             ;
       ;    dbUseArea(                                                     ;
                      <.new.>, <rdd>, <(db)>, <(a)>,                       ;
                      if (<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>        ;
                     )                                                     ;
            [; dbSetIndex( <(index1)> )]                                   ;
            [; dbSetIndex( <(indexn)> )]                                   ;
       ; else                                                              ;
       ;    dbUseArea(                                                     ;
                      <.new.>, <altrdd>, <(db)>, <(a)>,                    ;
                      if (<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>        ;
                     )                                                     ;
            [; dbSetIndex( <(index1)> )]                                   ;
            [; dbSetIndex( <(indexn)> )]                                   ;
       ; endif

/* Redefinition of USE for PASSWORDs */
#command USE <(db)>                                                        ;
             [VIA <rdd>]                                                   ;
             [ALIAS <a>]                                                   ;
             [<new: NEW>]                                                  ;
             [<ex: EXCLUSIVE>]                                             ;
             [<sh: SHARED>]                                                ;
             [<ro: READONLY>]                                              ;
             [INDEX <(index1)> [, <(indexn)>]]                             ;
             [PASSWORD <(password)>]                                       ;
                                                                           ;
      => dbUseArea(                                                        ;
                    <.new.>, <rdd>, <(db)>, <(a)>,                         ;
                    if(<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>           ;
                  )                                                        ;
                                                                           ;
      [; AX_SetPass( <(password)>, .T. )]                                  ;
      [; dbSetIndex( <(index1)> )]                                         ;
      [; dbSetIndex( <(indexn)> )]


/*
 * Constants for AX_GetServerType()
 */
#define ADS_MGMT_NETWARE_SERVER        1
#define ADS_MGMT_NT_SERVER             2
#define ADS_MGMT_LOCAL_SERVER          3

/*
 * Constants for AX_LockOwner()
 */
#define ADS_MGMT_NO_LOCK               1
#define ADS_MGMT_RECORD_LOCK           2
#define ADS_MGMT_FILE_LOCK             3

/*
 * Constants for AX_OpenTables()
 */
#define ADS_MGMT_PROPRIETARY_LOCKING   1
#define ADS_MGMT_CDX_LOCKING           2
#define ADS_MGMT_NTX_LOCKING           3
