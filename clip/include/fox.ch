#ifndef _FOX_DEFINED

#define _FOX_DEFINED

#xdefine AND .and.
#xdefine OR  .or.

#command SCATTER FIELDS <f1> [,<fn>]    ;
		 [<mm: MEMO>]           ;
		 [TO] MEMVAR         => ;
		 [ private <f1>:=iif(!<.mm.> .and. fieldtype(fieldpos(<"f1">))=="M","",field-><f1>)];
		 [;private <fn>:=iif(!<.mm.> .and. fieldtype(fieldpos(<"fn">))=="M","",field-><fn>)]

#command SCATTER FIELDS <f1> [,<fn>]    ;
		 [MEMO]                 ;
		 [TO] MEMVAR BLANK   => ;
		 [private <f1>:=fieldblank(<f1>)];
		 [;private <fn>:=fieldblank(<fn>)];

#command SCATTER [TO] MEMVAR ;
		[<mm: MEMO>]            ;
		[<bb: BLANK>]       =>  ;
		;for ___i:=1 to fcount() 			;
		;	 ___m:=fieldname(___i)        		;
		;        private &___m                   	;
		;        if <.bb.>                              ;
		;        	&___m:=fieldBlank(___i)         ;
		;        else                                   ;
		;        if !<.mm.> .and. fieldType(___i)=="M"  ;
		;        	&___m:=""                       ;
		;        else                                   ;
		;        	&___m:=fieldGet(___i)           ;
		;        endif                                  ;
		;        endif                                  ;
		;next

#command SCATTER FIELDS <f1> [,<fn>]         ;
		 TO <arr>            =>      ;
		 <arr>:={ 		     ;
		 [iif( fieldtype(fieldpos(<"f1">))=="M","",field-><f1>) ]              ;
		 [,iif( fieldtype(fieldpos(<"fn">))=="M","",field-><fn>)] }

#command SCATTER FIELDS <f1> [,<fn>]         ;
		 MEMO			     ;
		 TO <arr>            =>      ;
		 <arr>:={ 		     ;
		 [field-><f1> ]              ;
		 [,field-><fn>] }

#command SCATTER TO <arr>;
		[<mm: MEMO>]            ;
		[<bb: BLANK>]       =>  ;
		<arr>:={} ;
		;for ___i:=1 to fcount() 			;
		;        if <.bb.>                              ;
		;        	aadd(<arr>,fieldBlank(___i))    ;
		;        else                                   ;
		;        if !<.mm.> .and. fieldType(___i)=="M"  ;
		;        	aadd(<arr>,"")                  ;
		;        else                                   ;
		;        	aadd(<arr>,fieldGet(___i))      ;
		;        endif                                  ;
		;        endif                                  ;
		;next

#command GATHER MEMVAR ;
		[<mm: MEMO>]        =>  ;
		;for ___i:=1 to fcount() 			;
		;	 ___m:="m->"+fieldname(___i)            ;
		;        if type(___m)!="U"  			;
		;           if <.mm.> .or. fieldType(___i)!="M" ;
		;        	fieldPut(___i,&___m)            ;
		;           endif                               ;
		;        endif                                  ;
		;next

#command GATHER MEMVAR ;
		 FIELDS <f1> [,<fn>]    ;
		 [MEMO]              => ;
		 [field-><f1>:=&("m->"+<"f1">)];
		 [;field-><fn>:=&("m->"+<"fn">)]

#command GATHER FROM <arr> ;
		 FIELDS <f1> [,<fn>]    ;
		 [<mm: MEMO>]        => ;
		 ___i:=1		;
		 [ fieldput( fieldpos(<"f1">),<arr> \[___i\]); ___i++ ];
		 [ ;fieldput( fieldpos(<"fn">),<arr> \[___i\]); ___i++ ]

#command GATHER FROM <arr> ;
		[<mm: MEMO>]        =>  ;
		;for ___i:=1 to len(<arr>)		     ;
		;        if <.mm.> .or. fieldType(___i)!="M" ;
		;        	fieldPut(___i,<arr>\[___i\])   ;
		;        endif                               ;
		;next

#command SCAN 								;
	 [FOR <for>]                                                    ;
	 [WHILE <while>]                                                ;
	 [NEXT <next>]                                                  ;
	 [RECORD <rec>]                                                 ;
	 [<rest:REST>]                                                  ;
	 [<all:ALL>]                                                    ;
	 [<nooptimize:NOOPTIMIZE>]                                      ;
	 =>								;
	 fx_scopeBegin([codestr( <for> )], <{for}>, <{while}>, 		;
			<next>, <rec>, <.rest.>, <.nooptimize.>)	;
	 ; while !eof() 						;
	 ; 	if !fx_scopeNext() 					;
	 ;		exit 						;
	 ; 	endif


#command ENDSCAN => ;
	; end ;
	; fx_scopeEnd()

#command USE <(db)>                                                     ;
	     [VIA <rdd>]                                                ;
	     [IN  <in>]                                                 ;
	     [ALIAS <a>]                                                ;
	     [<new: NEW>]                                               ;
	     [<ex: EXCLUSIVE>]                                          ;
	     [<sh: SHARED>]                                             ;
	     [<ro: READONLY>]                                           ;
	     [ASCENDING]                                                ;
	     [<desc: DESCENDING>]                                       ;
	     [<noUpdate: NOUPDATE>]                                     ;
	     [INDEX <ilist,...>]                                        ;
	     [ORDER  <(xOrder)>]                                        ;
	     [TAG    <cTag>]                                            ;
	     [OF     <xOf>]                                             ;
	     =>;
	     fx_useArea(<(db)>,<(a)>,<rdd>,<in>,NIL , 			;
			<.new.>,iif(<.sh.> .or. <.ex.>, !<.ex.>, NIL),	;
			<.ro.>, <.noUpdate.>, <.desc.>,  		;
			{ <(ilist)> },<(xOrder)>,<"cTag">,<"xOf">)
//	     [<again: AGAIN>]                                           ;

#command ON KEY  =>
#command ON KEY <*x*> =>

#command ON KEY LABEL <label> DO <proc> => 				;
		fx_setKey(<"label">,{ |p1,p2,p3| <proc>(p1,p2,p3) })

#command PUSH KEY [<lClear: CLEAR>] => fx_pushKeys(<.lClear.>)

#command POP  KEY [<lAll: ALL>]     => fx_popKeys(<.lAll.>)

#command DEFINE WINDOW <cName> ;
	 [AT <(x1)>,<(y1)>];
	 [SIZE <(x2)>,<(y2)>] ;
	 [TITLE <(title)>] ;
	 [FOOTER <(footer)>] ;
	 [<system: SYSTEM>] ;
	 [<double: DOUBLE>] ;
	 [<panel:  PANEL>] ;
	 [<none:  NONE>] ;
	 [<shadow: SHADOW>] ;
	 [<zoom: ZOOM>] ;
	 [<float: FLOAT>] ;
	 [COLOR <(color)>] ;
	 => ;
	 fx_wDefine(<"cName">,<x1>,<y1>,<x2>,<y2>,<title>,<footer>,;
		<.system.>,<.double.>,<.panel.>,<.none.>, ;
		<.shadow.>,<.zoom.>,<(color)>)

#command ACTIVATE WINDOW <(cName)> => fx_wActivate( <(cName)> )

#command DEACTIVATE WINDOW <(cName)> => fx_wDeactivate( <(cName)> )

#command RELEASE WINDOW  <(cName)> => fx_wrelease( <(cName)> )
#command RELEASE WINDOWS  <(cName)> => fx_wrelease( <(cName)> )

#command BROWSE <*x*> => fx_browse(\[ <x> \])

#command RETURN TO <proc> => return <proc>()
#command RETURN TO MASTER => return

#endif
