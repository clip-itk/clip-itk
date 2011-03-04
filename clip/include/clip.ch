/*  for new Clipper */
#ifndef _CLIP_DEFINED
#define _CLIP_DEFINED

#include "set.ch"

#command @ <row>, <col> GET <var>                                       ;
			CHECKBOX                                        ;
			[VALID <valid>]                                 ;
			[WHEN <when>]                                   ;
			[CAPTION <caption>]                             ;
			[MESSAGE <message>]                             ;
			[COLOR <color>]                                 ;
			[FOCUS <fblock>]                                ;
			[STATE <sblock>]                                ;
			[STYLE <style>]                                 ;
			[SEND <msg>]                                    ;
			[GUISEND <guimsg>]                              ;
			[BITMAPS <aBitmaps>]                            ;
									;
	  => aadd(GetList,getnew(<row>,<col>,                           ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },          ;
		  <(var)>,NIL,<color>,<var>,<{valid}>,<{when}>) )       ;
	   ; ATail(GetList):Control := _CheckBox_( <var>, <caption>,    ;
			<message>, <color>, <{fblock}>, <{sblock}>,     ;
			<style>, <aBitmaps>,<row>,<col>-1 )             ;
	   ; ATail(GetList):reader  := { | a, b, c, d |                 ;
					GuiReader( a, b, c, d ) }       ;
	  [; ATail(GetList):<msg>]                                      ;
	  [; ATail(GetList):Control:<guimsg>]                           ;
	   ; ATail(GetList):Control:Display()


#command @ <top>, <left>, <bottom>, <right> GET <var>                   ;
			TEXT						;
			[VALID <valid>]                                 ;
			[WHEN <when>]                                   ;
			[SEND <msg>]                                    ;
									;
	  => aadd(GetList,textgetnew(<top>,<left>,<bottom>,<right>,     ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },          ;
		  <(var)>,setcolor(),<var>,<{valid}>,<{when}>) )        ;
	   [; ATail(GetList):<msg>]

#command SET LOGLEVEL TO <n>                                         ;
	  => Set( _SET_LOGLEVEL, <n> )

#command SET LOGLEVEL <n>                                            ;
	  => Set( _SET_LOGLEVEL, <n> )

#command SET LOGFILE TO <(fname)>                                    ;
	  => Set( _SET_LOGFILE, <(fname)> )

#command SET DBF CHARSET TO <(csname)>                               ;
	  => Set( "DBF_CHARSET", <(csname)> )

#command SET PRINTER CHARSET TO <(csname)>                                       ;
	  => Set( "PRINTER_CHARSET", <(csname)> )

#command SET CANCEL <x:ON,OFF,&>      => Set( _SET_CANCEL, <(x)> )
#command SET CANCEL (<x>)             => Set( _SET_CANCEL, <x> )

#command SET RATIONAL <x:ON,OFF,&>      => Set( _SET_RATIONAL, <(x)> )
#command SET RATIONAL (<x>)             => Set( _SET_RATIONAL, <x> )

#command SET NEAR <x:ON,OFF,&>      => Set( _SET_SOFTSEEK, <(x)> )
#command SET NEAR (<x>)             => Set( _SET_SOFTSEEK, <x> )

#command SET TRANSLATE <x:ON,OFF,&>      => Set( _SET_TRANSLATE_PATH, <(x)> )
#command SET TRANSLATE (<x>)             => Set( _SET_TRANSLATE_PATH, <x> )
#command SET TRANSLATE PATH <x:ON,OFF,&>      => Set( _SET_TRANSLATE_PATH, <(x)> )
#command SET TRANSLATE PATH (<x>)             => Set( _SET_TRANSLATE_PATH, <x> )

#command SET FILE CREATE MODE <n>      => Set( _SET_FILECREATEMODE, <"n"> )
#command SET DIRECTORY CREATE MODE <n> => Set( _SET_DIRCREATEMODE, <"n"> )


#command DEFAULT <p> TO <v> [, <p2> TO <v2> ] => ;
				 <p> := IIF(<p> == NIL, <v>, <p>) ;
				 [; <p2> := IF (<p2> == NIL, <v2>, <p2>) ]

#command DEF <p> RANGE <x1> [,<x2>] TO <v> =>;
				 <p> := if(<p> == NIL, <v>,;
				 if( <p> \< <x1> [.or. <p> \> <x2> ], <v>, <p>))

#command REPEAT => while .t.

#command UNTIL <val> => if !<val>; exit; endif; enddo

#command REQUEST  <vars,...>             =>

#command EXTERNAL <vars,...>             =>

#command SELECT <whatever>              => dbSelectArea( <(whatever)> )
#command SELECT <f>([<list,...>])       => dbSelectArea( <f>(<list>) )

#command REPLACE [ <f1> WITH <x1> [, <fn> WITH <xn>] ]                 ;
		[FOR <for>]                                            ;
		[WHILE <while>]                                        ;
		[NEXT <next>]                                          ;
		[RECORD <rec>]                                         ;
		[<rest:REST>]                                          ;
		[ALL]                                                  ;
		[<noopt:NOOPTIMIZE>]                                   ;
	=>                                                             ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.>)              ;
		; DBEvalOptimize(                                      ;
			{|| _FIELD-><f1> := <x1> [, _FIELD-><fn> := <xn>]},    ;
			[codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
			)                                                      ;
		; else                                                         ;
		;	DBEval(                                                ;
			{|| _FIELD-><f1> := <x1> [, _FIELD-><fn> := <xn>]},    ;
			 <{for}>, <{while}>, <next>, <rec>, <.rest.>           ;
			)                                                      ;
		; end

#command REPLACE <f1> WITH <v1> [, <fN> WITH <vN> ]                    ;
	  => _FIELD-><f1> := <v1> [; _FIELD-><fN> := <vN>]

#command DELETE                                                      ;
		[FOR <for>]                                          ;
		[WHILE <while>]                                      ;
		[NEXT <next>]                                        ;
		[RECORD <rec>]                                       ;
		[<rest:REST>]                                        ;
		[ALL]                                                ;
		[<noopt:NOOPTIMIZE>]                                 ;
	=>                                                           ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.>)            ;
		; DBEvalOptimize(                                    ;
			{|| dbDelete()},                             ;
			[codestr( <for> )], 				 ;
			<{while}>, <next>, <rec>, <.rest.>           ;
			)                                            ;
		; else                                               ;
		; DBEval(                                            ;
			{|| dbDelete()},                             ;
			<{for}>, <{while}>, <next>, <rec>, <.rest.>  ;
			)                                            ;
		; end

#command DELETE                 =>  dbDelete()

#command RECALL                                                        ;
		[FOR <for>]                                            ;
		[WHILE <while>]                                        ;
		[NEXT <next>]                                          ;
		[RECORD <rec>]                                         ;
		[<rest:REST>]                                          ;
		[ALL]                                                  ;
	=>                                                             ;
		if ( set(_SET_OPTIMIZE) )                              ;
		; DBEvalOptimize(                                      ;
			{|| dbRecall()},                               ;
			[codestr( <for> )],				   ;
			<{while}>, <next>, <rec>, <.rest.>             ;
			)                                              ;
		; else                                                 ;
		; DBEval(                                              ;
			{|| dbRecall()},                               ;
			<{for}>, <{while}>, <next>, <rec>, <.rest.>    ;
			)                                              ;
		; end

#command RECALL                 =>  dbRecall()

#command COUNT [TO <var>]                                               ;
		 [FOR <for>]                                            ;
		 [WHILE <while>]                                        ;
		 [NEXT <next>]                                          ;
		 [RECORD <rec>]                                         ;
		 [<rest:REST>]                                          ;
		 [ALL]                                                  ;
									;
	  => <var> := 0                                                 ;
	   ; if ( set(_SET_OPTIMIZE) )                                  ;
	   ; DBEvalOptimize(                                            ;
		 {|| local( _count :=@ <var>), _count := _count + 1},   ;
		 [codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
		   )                                                    ;
	   ; else                                                       ;
	   ;  DBEval(                                                   ;
		 {|| local( _count :=@ <var>), _count := _count + 1},   ;
		 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
		)                                                       ;
	   ; end

#command SUM [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                       ;
		 [FOR <for>]                                            ;
		 [WHILE <while>]                                        ;
		 [NEXT <next>]                                          ;
		 [RECORD <rec>]                                         ;
		 [<rest:REST>]                                          ;
		 [ALL]                                                  ;
									;
	  => <v1> := [ <vn> := ] 0                                      ;
	   ; if ( set(_SET_OPTIMIZE) )                                  ;
	   ;    DBEvalOptimize(                                         ;
			{|| local( <#v1#>:=@<v1> [, <#vn#>:=@<vn>]),	;
			<#v1#> := <#v1#> + <x1> [, <#vn#> := <#vn#> + <xn> ]}, ;
			[codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
			   )                                                   ;
	   ; else                                                           ;
	   ;    DBEval(                                                     ;
			{|| local( <#v1#>:=@<v1> [, <#vn#>:=@<vn>]),        ;
			<#v1#> := <#v1#> + <x1> [, <#vn#> := <#vn#> + <xn> ]}, ;
			<{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
			   )                                                   ;
	   ; end

#command AVERAGE [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                   ;
		 [FOR <for>]                                            ;
		 [WHILE <while>]                                        ;
		 [NEXT <next>]                                          ;
		 [RECORD <rec>]                                         ;
		 [<rest:REST>]                                          ;
		 [ALL]                                                  ;
									;
	  => M->__Avg := <v1> := [ <vn> := ] 0                          ;
	   ; if ( set(_SET_OPTIMIZE) )                                  ;
	   ;    DBEvalOptimize(                                         ;
			{|| local( <#v1#>:=@<v1> [, <#vn#>:=@<vn>]),	;
			M->__Avg := M->__Avg + 1,                       ;
			<#v1#> := <#v1#> + <x1> [, <#vn#> := <#vn#> + <xn>] }, ;
			[codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
			   )                                                   ;
										;
	   ; else                                                           ;
	   ;    DBEval(                                                     ;
			{|| local( <#v1#>:=@<v1> [, <#vn#>:=@<vn>]),		;
			M->__Avg := M->__Avg + 1,                           ;
			<#v1#> := <#v1#> + <x1> [, <#vn#> := <#vn#> + <xn>] }, ;
			<{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
			   )                                                   ;
	   ; end                                                            ;
	   ; <v1> := <v1> / M->__Avg [; <vn> := <vn> / M->__Avg ]

#command LOCATE                                                         ;
		 [FOR <for>]                                                    ;
		 [WHILE <while>]                                                ;
		 [NEXT <next>]                                                  ;
		 [RECORD <rec>]                                                 ;
		 [<rest:REST>]                                                  ;
		 [ALL]                                                          ;
		 [<noopt:NOOPTIMIZE>]                                           ;
																		;
	  => if ( set(_SET_OPTIMIZE) .and. !<.noopt.> )                     ;
	   ;    __dbLocateOptimize( [codestr( <for> )], <{for}>, <{while}>, ;
			   <next>, <rec>, <.rest.> )                                ;
	   ; else                                                           ;
	   ;    __dbLocate( <{for}>, <{while}>, <next>, <rec>, <.rest.> )   ;
	   ; end

#command DO SWITCH <exp>         => switch <exp>
#command ENDSWITCH <*x*>         => end

#command SET FILTER TO <xpr>                                            ;
		[<noopt:NOOPTIMIZE>]                                            ;
	=>                                                                  ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.>)                       ;
	   ;    dbSetFilter( <{xpr}>, codestr( <xpr> ) )                    ;
	   ; else                                                           ;
	   ;    dbSetFilter( <{xpr}>, <"xpr">, .t. )                        ;
	   ; end

#command SET FILTER TO <x:&>                                            ;
	  => if ( Empty(<(x)>) )                                            ;
	   ;    dbClearFilter()                                             ;
	   ; else                                                           ;
	   ;    dbSetFilter( <{x}>, <(x)> )                                 ;
	   ; end

#command SET OPTIMIZE LEVEL [TO] <x>             => Set( _SET_OPTIMIZELEVEL, <x> )

#command SET LOCKSTYLE [TO] CLIPPER              => Set( _SET_LOCKSTYLE, 0 )
#command SET LOCKSTYLE [TO] CLIPPER53            => Set( _SET_LOCKSTYLE, 0 )
#command SET LOCKSTYLE [TO] CLIPPER50            => Set( _SET_LOCKSTYLE, 0 )
#command SET LOCKSTYLE [TO] FOXPRO               => Set( _SET_LOCKSTYLE, 1 )
#command SET LOCKSTYLE [TO] SIX                  => Set( _SET_LOCKSTYLE, 1 )
#command SET LOCKSTYLE [TO] CLIPPER52            => Set( _SET_LOCKSTYLE, 1 )

#command SET DISPBOX <x:ON,OFF,&>      => Set( _SET_DISPBOX, <(x)> )
#command SET DISPBOX (<x>)             => Set( _SET_DISPBOX, <x> )

#command SET UTF8TERM <x:ON,OFF,&>      => Set( _SET_UTF8TERM, <(x)> )
#command SET UTF8TERM (<x>)             => Set( _SET_UTF8TERM, <x> )

#command SET MACRO_IN_STRING <x:ON,OFF,&>      => Set( _SET_MACRO_IN_STRING, <(x)> )
#command SET MACRO_IN_STRING (<x>)             => Set( _SET_MACRO_IN_STRING, <x> )

/* Visual FoxPro */
#command SET HOURS [TO] 12                       => Set( _SET_HOURS, 0 )
/* usa */
#command SET HOURS [TO] 24                       => Set( _SET_HOURS, 1 )
/* euro */
#command SET SECONDS OFF                         => Set( _SET_SECONDS, .f. )
#command SET SECONDS ON                          => Set( _SET_SECONDS, .t. )

#command SET FOPEN MODE <x:ON,OFF,&>      => Set( _SET_FOPENMODE, <(x)> )
#command SET FOPEN MODE (<x>)             => Set( _SET_FOPENMODE, <x> )
#command SET FOPEN MODE [TO] DOS          => Set( _SET_FOPENMODE, .f. )
#command SET FOPEN MODE [TO] POSIX        => Set( _SET_FOPENMODE, .t. )
#command SET FOPEN MODE [TO] UNIX         => Set( _SET_FOPENMODE, .t. )

#command SET BUFFERING <x:ON,OFF,&>      => Set( _SET_BUFFERING, <(x)> )
#command SET BUFFERING (<x>)             => Set( _SET_BUFFERING, <x> )
#command SET FILEIO MODE RAW             => Set( _SET_BUFFERING, .f. )
#command SET FILEIO MODE BUFFERING       => Set( _SET_BUFFERING, .t. )
#command SET FILEIO MODE BUFFERED        => Set( _SET_BUFFERING, .t. )

#command SET INDEX BUFFER LIMIT [TO] <x> => Set( _SET_INDEX_BUFFER_LIMIT, <x> )

#command SET MAP FILE [TO] <x:ON,OFF,&>  => Set( _SET_MAP_FILE, <(x)> )

#command SET MULTILOCKS [TO] <x:ON,OFF,&> => Set(_SET_MULTILOCKS, <(x)> )

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
	 [<custom: CUSTOM>]                                             ;
	  => ordCondSet( <"for">, <{for}>,                              ;
			 [<.all.>],                                             ;
			 <{while}>,                                             ;
			 <{eval}>, <every>,                                     ;
			 RECNO(), <next>, <rec>,                                ;
			 [<.rest.>], [<.descend.>],,, [<.custom.>] )            ;
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
	 [<custom: CUSTOM>]                                             ;
	  => ordCondSet( <"for">, <{for}>,                              ;
			 [<.all.>],                                             ;
			 <{while}>,                                             ;
			 <{eval}>, <every>,                                     ;
			 RECNO(), <next>, <rec>,                                ;
			 [<.rest.>], [<.descend.>],,, [<.custom.>])             ;
	  ;  ordCreate(<(cOrderBagName)>, <(cOrderName)>,               ;
		   <"key">, <{key}>, [<.unique.>]    )

#command COPY [TO <(file)>] [DELIMITED [WITH <*delim*>]]               ;
		[FIELDS <fields,...>]                                          ;
		[FOR <for>]                                                    ;
		[WHILE <while>]                                                ;
		[NEXT <next>]                                                  ;
		[RECORD <rec>]                                                 ;
		[<rest:REST>]                                                  ;
		[ALL]                                                          ;
		[<noopt:NOOPTIMIZE>]                                           ;
	=>                                                                 ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.> )                     ;
	  ;		__dbDelimOptimize(.t.,<(file)>, <(delim)>, { <(fields)> }, ;
			[codestr( <for> )], <{for}>, <{while}>, <next>, <rec>,     ;
			<.rest.> )                                                 ;
	  ;	else                                                           ;
	  ;		__dbDelim(.t.,<(file)>, <(delim)>, { <(fields)> },         ;
			<{for}>, <{while}>, <next>, <rec>, <.rest.>	)              ;
	  ;	endif

#command COPY [TO <(file)>] [SDF]                                      ;
		[FIELDS <fields,...>]                                          ;
		[FOR <for>]                                                    ;
		[WHILE <while>]                                                ;
		[NEXT <next>]                                                  ;
		[RECORD <rec>]                                                 ;
		[<rest:REST>]                                                  ;
		[ALL]                                                          ;
		[<noopt:NOOPTIMIZE>]                                           ;
	=>                                                                 ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.> )                     ;
	  ;		__dbSDFOptimize(.t.,<(file)>, { <(fields)> },              ;
				[codestr( <for> )], <{for}>, <{while}>, <next>, <rec>, ;
				<.rest.> )                                             ;
	  ;	else                                                           ;
	  ;		__dbSDF(.t.,<(file)>, { <(fields)> },                      ;
				<{for}>, <{while}>, <next>, <rec>, <.rest.> )          ;
	  ;	endif

#command COPY [TO <(file)>]                                            ;
		[FIELDS <fields,...>]                                          ;
		[FOR <for>]                                                    ;
		[WHILE <while>]                                                ;
		[NEXT <next>]                                                  ;
		[RECORD <rec>]                                                 ;
		[<rest:REST>]                                                  ;
		[VIA <rdd>]                                                    ;
		[ALL]                                                          ;
		[<noopt:NOOPTIMIZE>]                                           ;
	=>                                                                 ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.> )                     ;
	  ;		__dbCopyOptimize(<(file)>, { <(fields)> },                 ;
				[codestr( <for> )], <{for}>, <{while}>, <next>, <rec>, ;
				<.rest.>, <rdd> )                                      ;
	  ;	else                                                           ;
	  ;		__dbCopy(<(file)>, { <(fields)> },                         ;
				<{for}>, <{while}>, <next>, <rec>, <.rest.>, <rdd> )   ;
	  ;	endif

#command COPY TO ARRAY <var>                                           ;
		[FIELDS <fields,...>]                                          ;
		[FOR <for>]                                                    ;
		[WHILE <while>]                                                ;
		[NEXT <next>]                                                  ;
		[RECORD <rec>]                                                 ;
		[<rest:REST>]                                                  ;
		[ALL]                                                          ;
		[<x:OFF>]                                                      ;
	=>                                                                 ;
		<var>:={}                                                      ;
	  ;	m6_CopyToArray( @<var>, { <(fields)> }, <"for">, <{for}>,      ;
			<{while}>, <next>, <rec>, <.rest.>, !<.x.>)

#command SORT [TO <(file)>] [ON <fields,...>]                          ;
		[FOR <for>]                                                    ;
		[WHILE <while>]                                                ;
		[NEXT <next>]                                                  ;
		[RECORD <rec>]                                                 ;
		[<rest:REST>]                                                  ;
		[ALL]                                                          ;
		[<noopt:NOOPTIMIZE>]                                           ;
	=>                                                                 ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.> )                     ;
	  ;		__dbSortOptimize( <(file)>, { <(fields)> },                ;
				[codestr( <for> )], <{for}>, <{while}>, <next>, <rec>, ;
				<.rest.> )                                             ;
	  ;	else                                                           ;
	  ;		__dbSort(  <(file)>, { <(fields)> },                       ;
				<{for}>, <{while}>, <next>, <rec>, <.rest.> )          ;
	  ;	endif

#command TOTAL [TO <(file)>] [ON <key>]                                ;
		[FIELDS <fields,...>]                                          ;
		[FOR <for>]                                                    ;
		[WHILE <while>]                                                ;
		[NEXT <next>]                                                  ;
		[RECORD <rec>]                                                 ;
		[<rest:REST>]                                                  ;
		[ALL]                                                          ;
		[<noopt:NOOPTIMIZE>]                                           ;
	=>                                                                 ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.> )                     ;
	  ;		__dbTotalOptimize( <(file)>, <{key}>, { <(fields)> },      ;
				[codestr( <for> )], <{for}>, <{while}>, <next>, <rec>, ;
				<.rest.> )                                             ;
	  ;	else                                                           ;
	  ;		__dbTotal( <(file)>, <{key}>, { <(fields)> },              ;
				<{for}>, <{while}>, <next>, <rec>, <.rest.> )          ;
	  ;	endif

#command LIST [<list,...>]                                             ;
		[<off:OFF>]                                                    ;
		[<toPrint: TO PRINTER>]                                        ;
		[TO FILE <(toFile)>]                                           ;
		[FOR <for>]                                                    ;
		[WHILE <while>]                                                ;
		[NEXT <next>]                                                  ;
		[RECORD <rec>]                                                 ;
		[<rest:REST>]                                                  ;
		[ALL]                                                          ;
		[<noopt:NOOPTIMIZE>]                                           ;
	=>                                                                 ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.> )                     ;
	  ;		__dbListOptimize(<.off.>, { <{list}> }, .t.,               ;
				[codestr( <for> )], <{for}>, <{while}>, <next>,        ;
				<rec>, <.rest.>, <.toPrint.>, <(toFile)> )             ;
	  ;	else                                                           ;
	  ;		__dbList(<.off.>, { <{list}> }, .t.,                       ;
				<{for}>, <{while}>, <next>, <rec>, <.rest.>,           ;
				<.toPrint.>, <(toFile)> )                              ;
	  ;	endif

#command DISPLAY [<list,...>]                                          ;
		[<off:OFF>]                                                    ;
		[<toPrint: TO PRINTER>]                                        ;
		[TO FILE <(toFile)>]                                           ;
		[FOR <for>]                                                    ;
		[WHILE <while>]                                                ;
		[NEXT <next>]                                                  ;
		[RECORD <rec>]                                                 ;
		[<rest:REST>]                                                  ;
		[<all:ALL>]                                                    ;
		[<noopt:NOOPTIMIZE>]                                           ;
	=>                                                                 ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.> )                     ;
	  ;		__dbListOptimize(<.off.>, { <{list}> }, <.all.>,           ;
				[codestr( <for> )], <{for}>, <{while}>, <next>,        ;
				<rec>, <.rest.>, <.toPrint.>, <(toFile)> )             ;
	  ;	else                                                           ;
	  ;		__dbList(<.off.>, { <{list}> }, <.all.>,                   ;
				<{for}>, <{while}>, <next>, <rec>, <.rest.>,           ;
				<.toPrint.>, <(toFile)> )                              ;
	  ;	endif

#command REPORT FORM <frm>                                             ;
		[HEADING <heading>]                                            ;
		[<plain: PLAIN>]                                               ;
		[<noeject: NOEJECT>]                                           ;
		[<summary: SUMMARY>]                                           ;
		[<noconsole: NOCONSOLE>]                                       ;
		[<print: TO PRINTER>]                                          ;
		[TO FILE <(toFile)>]                                           ;
		[FOR <for>]                                                    ;
		[WHILE <while>]                                                ;
		[NEXT <next>]                                                  ;
		[RECORD <rec>]                                                 ;
		[<rest:REST>]                                                  ;
		[ALL]                                                          ;
		[<noopt:NOOPTIMIZE>]                                           ;
	=>                                                                 ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.> )                     ;
	  ;		__ReportFormOptimize(                                      ;
				<(frm)>, <.print.>, <(toFile)>, <.noconsole.>,         ;
				[codestr( <for> )], <{for}>, <{while}>, <next>, <rec>, ;
				<.rest.>, <.plain.>, <heading>,                        ;
				<.noeject.>, <.summary.>                               ;
			)                                                          ;
	  ;	else                                                           ;
	  ;		__ReportForm(                                              ;
				<(frm)>, <.print.>, <(toFile)>, <.noconsole.>,         ;
				<{for}>, <{while}>, <next>, <rec>, <.rest.>,           ;
				<.plain.>, <heading>,                                  ;
				<.noeject.>, <.summary.>                               ;
			)                                                          ;
	  ;	endif
/*
#command LABEL FORM <lbl>                                              ;
		[<sample: SAMPLE>]                                             ;
		[<noconsole: NOCONSOLE>]                                       ;
		[<print: TO PRINTER>]                                          ;
		[TO FILE <(toFile)>]                                           ;
		[FOR <for>]                                                    ;
		[WHILE <while>]                                                ;
		[NEXT <next>]                                                  ;
		[RECORD <rec>]                                                 ;
		[<rest:REST>]                                                  ;
		[ALL]                                                          ;
		[<noopt:NOOPTIMIZE>]                                           ;
	=>                                                                 ;
		if ( set(_SET_OPTIMIZE) .and. !<.noopt.> )                     ;
	  ;		__LabelFormOptimize(                                       ;
				<(lbl)>, <.print.>, <(toFile)>, <.noconsole.>,         ;
				[codestr( <for> )], <{for}>, <{while}>, <next>, <rec>, ;
				<.rest.>, <.sample.>                                   ;
			)                                                          ;
	  ;	else                                                           ;
	  ;		__LabelForm(                                               ;
				<(lbl)>, <.print.>, <(toFile)>, <.noconsole.>,         ;
				<{for}>, <{while}>, <next>, <rec>, <.rest.>,           ;
				<.sample.>                                             ;
			)                                                          ;
	  ;	endif
*/

#command SEARCH [FOR <for>] [TO <var>]                                 ;
	=>                                                                 ;
		<var> := {}                                                    ;
	  ;	m6_Search( <"for">, <{for}>, @<var> )

#command CONNECT                                                        ;
		[RDBMS <rdbms>]                                                 ;
		[USER <user>]                                                   ;
		[PASSWORD <password>]                                           ;
		[DATABASE <(db)>]                                               ;
		[CHARSET <cs>]                                                  ;
		[ISOLATION LEVEL <trans>]                                       ;
		[HOST <host>]                                                   ;
		[PORT <port>]                                                   ;
		[DUMP <tty>]                                                    ;
		[OPTIONS <opts>]                                                ;
		TO <conn>                                                       ;
	=>                                                                  ;
		<conn> := ConnectNew(<"rdbms">,<"host">,<"port">,<"user">,      ;
			<"password">,<(db)>,<"tty">,<"opts">,<"cs">,<"trans">)

#command CREATE ROWSET [FOR [CONNECT]] <conn>                           ;
		[QUERY <select>]                                                ;
		[PARAMETERS <pars>]                                             ;
		[ON INSERT <insert>]                                            ;
		[ON DELETE <delete>]                                            ;
		[ON UPDATE <update>]                                            ;
		[ON REFRESH <refresh>]                                          ;
		[ID <id>]                                                       ;
		[ORDERS <orders>]                                               ;
		[ID_GENERATOR <idgen>]                                          ;
		[<nofetch:NOFETCH>]                                             ;
		[EVAL <eval>]                                                   ;
		[EVERY <every>]                                                 ;
		[TO <rs>]                                                       ;
	=>                                                                  ;
		<rs> := <conn>:createrowset(<select>,<pars>,                    ;
			<insert>,<delete>,<update>,<refresh>,                       ;
			<"id">,<orders>,<idgen>,<.nofetch.>,<{eval}>,<every>)

#command SEEK EVAL <expB>                                               ;
	=> clip_evalseek( <expB> )

#command SEEK REGULAR <regexp>                                          ;
		[<next:NEXT>]                                                   ;
	=> clip_regexseek( <regexp>, <.next.> )

#command SET PRINTER TO MEMBUF			=> Set( _SET_PRINTFILE, "MEMBUF" )

#command WINEXEC <*cmd*>            => __winexec( #<cmd> )
#command WINEXEC ( <c> )            => __winexec( <c> )

#translate millisec( <v1> )         => sleep(<v1>/1000)

#command SET IDLE INKEY <x:ON,OFF,&>      => Set( _SET_IDLE_INKEY, <(x)> )
#command SET INKEY IDLE <x:ON,OFF,&>      => Set( _SET_IDLE_INKEY, <(x)> )

#endif
