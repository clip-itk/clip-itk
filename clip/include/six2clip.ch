#ifndef __SIX2CLIP_DEFINED
#define __SIX2CLIP_DEFINED

#include "six.ch"

#xdefine SETRDD             RDDSETDEFAULT

#xdefine SX_AUTOOPEN(bMode)			SET(_SET_AUTOPEN,bMode)
#xdefine SX_AUTOSHARE(nMod)			SET(_SET_AUTOSHARE,nMod)
#xdefine SX_CLRSCOPE(which)			ORDSCOPE(which,NIL)
#xdefine SX_DBCREATE				DBCREATE
#xdefine SX_DTOP(x)    				x
#xdefine SX_GETLOCKS				DBRLOCKLIST
#xdefine SX_INDEXFILTER				ORDFOR
#xdefine SX_ISDBT()					.F.
#xdefine SX_KEYADD     				ORDKEYADD
#xdefine SX_KEYCOUNT				ORDKEYCOUNT
#xdefine SX_KEYDATA    				ORDKEYVAL
#xdefine SX_KEYDROP    				ORDKEYDEL
#xdefine SX_KEYSKIP    				DBSKIP
#xdefine SX_KEYNO					ORDKEYNO
#xdefine SX_PTOD(x)    				x
#xdefine SX_SETSCOPE				ORDSCOPE
#xdefine SX_SKIPUNIQUE				ORDSKIPUNIQUE
#xdefine SX_TAGNAME    				ORDNAME
#xdefine SX_TAGORDER				ORDNUMBER
#xdefine SX_VFGET(expr,len)			PADR(&(expr),len)

#xtranslate SX_SETMEMOBLOCK([<x>])      =>	;
		SET(_SET_MBLOCKSIZE,<x>)

#command PACK                   => __dbPack(); sx_MemoPack()

#command MEMOPACK [BLOCK <size>] [OPTION <opt>] [STEP <step>]       ;
	=> sx_MemoPack(<size>,<{opt}>,<step>)

#command USE <(db)>                                                 ;
		 [VIA <rdd>]                                                ;
		 [ALIAS <a>]                                                ;
		 [<new: NEW>]                                               ;
		 [<ex: EXCLUSIVE>]                                          ;
		 [<sh: SHARED>]                                             ;
		 [<ro: READONLY>]                                           ;
		 [<tmp: TEMPORARY>]                                         ;
		 [INDEX <(index1)> [, <(indexn)>]]                          ;
		 [TRIGGER <trig>]                                           ;
																	;
	  => dbUseArea(                                                 ;
			<.new.>, <rdd>, <(db)>, <(a)>,                          ;
			iif(<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>,<.tmp.>   ;
		  )                                                         ;
		 ; sx_setTrigger(TRIGGER_INSTALL,<trig>)                    ;
																	;
	  [; dbSetIndex( <(index1)> )]                                  ;
	  [; dbSetIndex( <(indexn)> )]

#xcommand WILDSEEK <str>                                            ;
	=> sx_WildSeek( <str> )

#xcommand WILDSEEKNEXT <str>                                        ;
	=> sx_WildSeek( <str>, .T. )

#command SET TAGORDER TO <order>                                    ;
	  => ordSetFocus( <order> )

#command SET TAGORDER TO                                            ;
	  => ordSetFocus( 0 )

#command SET TAG TO <tag> [OF <(cdx)>]                                     ;
	  => ordSetFocus( <(tag)> [, <(cdx)>] )

#command SET TAG TO                                                        ;
	  => ordSetFocus( 0 )

#command REINDEX                                                    ;
		[EVAL   <opt> [EVERY <step>]]                               ;
		[OPTION <opt> [STEP  <step>]]                               ;
	  => ordCondSet(,,,, <{opt}>, <step>,,,,,,,,,,)                 ;
	   ; dbReindex()

#command INDEX ON <key> [TAG <(cOrderName)> ] TO <(cOrderBagName)>  ;
	 [FOR <for>]                                                    ;
	 [<all:ALL>]                                                    ;
	 [WHILE <while>]                                                ;
	 [NEXT <next>]                                                  ;
	 [RECORD <rec>]                                                 ;
	 [<rest:REST>]                                                  ;
	 [EVAL <eval>]                                                  ;
	 [EVERY <every>]                                                ;
	 [<unique: UNIQUE>]                                             ;
	 [<ascend: ASCENDING>]                                          ;
	 [<descend: DESCENDING>]                                        ;
	 [<custom: EMPTY>]                                              ;
	  => ordCondSet( <"for">, <{for}>,                              ;
			 [<.all.>],                                             ;
			 <{while}>,                                             ;
			 <{eval}>, <every>,                                     ;
			 RECNO(), <next>, <rec>,                                ;
			 [<.rest.>], [<.descend.>],,,, [<.custom.>] )            ;
	  ;  ordCreate(<(cOrderBagName)>, <(cOrderName)>,               ;
		   <"key">, <{key}>, [<.unique.>]    )

#command INDEX ON <key> TAG <(cOrderName)> [TO <(cOrderBagName)>]   ;
	 [FOR <for>]                                                    ;
	 [<all:ALL>]                                                    ;
	 [WHILE <while>]                                                ;
	 [NEXT <next>]                                                  ;
	 [RECORD <rec>]                                                 ;
	 [<rest:REST>]                                                  ;
	 [EVAL <eval>]                                                  ;
	 [EVERY <every>]                                                ;
	 [<unique: UNIQUE>]                                             ;
	 [<ascend: ASCENDING>]                                          ;
	 [<descend: DESCENDING>]                                        ;
	 [<custom: EMPTY>]                                              ;
	  => ordCondSet( <"for">, <{for}>,                              ;
			 [<.all.>],                                             ;
			 <{while}>,                                             ;
			 <{eval}>, <every>,                                     ;
			 RECNO(), <next>, <rec>,                                ;
			 [<.rest.>], [<.descend.>],,,, [<.custom.>])             ;
	  ;  ordCreate(<(cOrderBagName)>, <(cOrderName)>,               ;
		   <"key">, <{key}>, [<.unique.>]    )

#endif

