#ifndef _ORD_DEFINED

#define _ORD_DEFINED

#command INDEX ON <key> [TAG <(cOrder)>] TO <(cBag)>                    ;
	    [FOR <for>]                                                 ;
	    [WHILE <while>]                                             ;
	    [<lUnique: UNIQUE>]                                         ;
	    [<ascend: ASCENDING>]                                       ;
	    [<descend: DESCENDING>]                                     ;
	    [<lUsecurrent: USECURRENT>]                                 ;
	    [<lAdditive: ADDITIVE>]                                     ;
	    [EVAL <eval> [ EVERY <nEvery> ]]                            ;
	    [<lCustom: CUSTOM>]                                         ;
	    [<lNoOpt: NOOPTIMIZE>]                                                                          ;
    =>  ordCondSet( <"for">, <{for}>,                                   ;
		     nil,                                               ;
		     <{while}>,                                         ;
		     <{eval}>, <nEvery>,                                ;
		     nil, nil, nil,                                     ;
		     nil, [<.descend.>],                                ;
		     nil, <.lAdditive.>, <.lUsecurrent.>, <.lCustom.>,  ;
		     <.lNoOpt.>)                                        ;
	;  ordCreate(<(cBag)>, <(cOrder)>, <"key">, <{key}>, [<.lUnique.>])

#command INDEX ON <key> TAG <(cOrder)> [TO <(cBag)>]                    ;
	    [FOR <for>]                                                 ;
	    [WHILE <while>]                                             ;
	    [<lUnique: UNIQUE>]                                         ;
	    [<ascend: ASCENDING>]                                       ;
	    [<descend: DESCENDING>]                                     ;
	    [<lUsecurrent: USECURRENT>]                                 ;
	    [<lAdditive: ADDITIVE>]                                     ;
	    [EVAL <eval> [ EVERY <nEvery> ]]                            ;
	    [<lCustom: CUSTOM>]                                         ;
	    [<lNoOpt: NOOPTIMIZE>]                                                                          ;
    =>  ordCondSet( <"for">, <{for}>,                                   ;
		     nil,                                               ;
		     <{while}>,                                         ;
		     <{eval}>, <nEvery>,                                ;
		     nil, nil, nil,                                     ;
		     nil, [<.descend.>],                                ;
		     nil, <.lAdditive.>, <.lUsecurrent.>, <.lCustom.>,  ;
		     <.lNoOpt.>)                                        ;
	;  ordCreate(<(cBag)>, <(cOrder)>, <"key">, <{key}>, [<.lUnique.>])


#command REINDEX                                                        ;
	    [EVAL <eval>]                                               ;
	    [EVERY <every>]                                             ;
	    [<lNoOpt: NOOPTIMIZE>]                                      ;
      => ordCondSet(,,,, <{eval}>, <every>,,,,,,,,,, <.lNoOpt.>)        ;
	 ; ordListRebuild()

#command SET RELATION                                                   ;
	 [<add:ADDITIVE>]                                               ;
	 TO <key1> INTO <(alias1)> [, [TO] <keyn> INTO <(aliasn)>]      ;
	 SCOPED                                                         ;
									;
      => if ( !<.add.> )                                                ;
       ;    dbClearRel()                                                ;
       ; end                                                            ;
									;
       ; ordSetRelation( <(alias1)>, <{key1}>, <"key1"> )               ;
      [; ordSetRelation( <(aliasn)>, <{keyn}>, <"keyn"> )]


#define TOPSCOPE                        0
#define BOTTOMSCOPE                     1


#include "ordinfo.ch"

// SCOPE and related SETtings:
#command SET SCOPETOP TO                => OrdScope( 0, nil )
#command SET SCOPETOP TO <x>            => OrdScope( 0, <x> )

#command SET SCOPEBOTTOM TO             => OrdScope( 1, nil )
#command SET SCOPEBOTTOM TO <x>         => OrdScope( 1, <x> )

#command SET SCOPE TO                   => OrdScope( 0, nil );
					 ; OrdScope( 1, nil )
#command SET SCOPE TO <x>, <y>          => OrdScope( 0, <x> );
					 ; OrdScope( 1, <y> )
#command SET SCOPE TO <x>               => OrdScope( 0, <x> );
					 ; OrdScope( 1, <x> )
#command SET SCOPE TO ,<x>              => OrdScope( 1, <x> )

// Memo RDD SETtings:
#command SET MBLOCKSIZE TO <x>          => Set( _SET_MBLOCKSIZE, <x> )
#command SET MEMOBLOCK TO <x>           => Set( _SET_MBLOCKSIZE, <x> )
#command SET MFILEEXT TO <x>            => Set( _SET_MFILEEXT, <x> )

// _DBFCDX RDD SETtings:
#command SET STRICTREAD <x:ON,OFF,&>    => Set( _SET_STRICTREAD, <(x)> )
#command SET STRICTREAD (<x>)           => Set( _SET_STRICTREAD, <x> )

#command SET OPTIMIZE <x:ON,OFF,&>      => Set( _SET_OPTIMIZE, <(x)> )
#command SET OPTIMIZE (<x>)             => Set( _SET_OPTIMIZE, <x> )

#command SET AUTOPEN <x:ON,OFF,&>       => Set( _SET_AUTOPEN, <(x)> )
#command SET AUTOPEN (<x>)              => Set( _SET_AUTOPEN, <x> )
#command SET AUTOOPEN <x:ON,OFF,&>      => Set( _SET_AUTOPEN, <(x)> )
#command SET AUTOOPEN (<x>)             => Set( _SET_AUTOPEN, <x> )

#command SET AUTORDER TO                => Set( _SET_AUTORDER,  0  )
#command SET AUTORDER TO <x>            => Set( _SET_AUTORDER, <x> )
#command SET AUTOORDER TO               => Set( _SET_AUTORDER,  0  )
#command SET AUTOORDER TO <x>           => Set( _SET_AUTORDER, <x> )

#command SET AUTOSHARE TO               => Set( _SET_AUTOSHARE,  0  )
#command SET AUTOSHARE TO <x>           => Set( _SET_AUTOSHARE, <x> )

#command SET DESCENDING ON              => OrdDescend( ,, .T. )
#command SET DESCENDING OFF             => OrdDescend( ,, .F. ) */

#endif
