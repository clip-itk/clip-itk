/*  для нового клиппера */
#ifndef _CLIP_DEFINED
#define _CLIP_DEFINED

#include "set.ch"

/*
#command SAVE SCREEN            => private __XScreen:=savescreen()
#command RESTORE SCREEN         => RestScreen(,,,,__XScreen)
*/


#command @ <row>, <col> GET <var>                                       ;
			[PICTURE <pic>]                                 ;
			[VALID <valid>]                                 ;
			[WHEN <when>]                                   ;
			[SEND <msg>]                                    ;
			[<ro: READONLY>]                                ;
									;
	  => aadd(GetList,getnew(<row>,<col>,                           ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },          ;
		  <(var)>,<pic>,setcolor(),<var>,<{valid}>,<{when}>) )  ;
	   [; ATail(GetList):<msg>]                                     ;
	   [; ATail(GetList):readOnly:=<.ro.>]				;
			; ATail(GetList):Display()

#command @ <row>, <col> GET <var>                                       ;
			[PICTURE <pic>]                                 ;
			[VALID <valid>]                                 ;
			[WHEN <when>]                                   ;
			[CAPTION <caption>]                             ;
			[MESSAGE <message>]                             ;
			[SEND <msg>]                                    ;
			[<ro: READONLY>]                                ;
									;
	  => aadd(GetList,getnew(<row>,<col>,                               ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },          ;
		  <(var)>,<pic>,setcolor(),<var>,<{valid}>,<{when}>) )  ;
	  [; ATail(GetList):Caption := <caption>]                           ;
	  [; ATail(GetList):CapRow  := ATail(Getlist):row                   ;
	   ; ATail(GetList):CapCol  := ATail(Getlist):col -                 ;
				  __CapLength(<caption>) - 1]               ;
	  [; ATail(GetList):message := <message>]                           ;
	  [; ATail(GetList):<msg>]                                          ;
	  [; ATail(GetList):readOnly:=<.ro.>]                               ;
	   ; ATail(GetList):Display()


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
	  => aadd(GetList,getnew(<row>,<col>,                               ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },          ;
		  <(var)>,NIL,<color>,<var>,<{valid}>,<{when}>) )       ;
	   ; ATail(GetList):Control := _CheckBox_( <var>, <caption>,        ;
			<message>, <color>, <{fblock}>, <{sblock}>,     ;
			<style>, <aBitmaps>,<row>,<col>-1 )             ;
	   ; ATail(GetList):reader  := { | a, b, c, d |                     ;
					GuiReader( a, b, c, d ) }           ;
	  [; ATail(GetList):<msg>]                                          ;
	  [; ATail(GetList):Control:<guimsg>]                               ;
	   ; ATail(GetList):Control:Display()

#command @ <top>, <left>, <bottom>, <right> GET <var>                    ;
			LISTBOX    <items>                               ;
			[VALID <valid>]                                  ;
			[WHEN <when>]                                    ;
			[CAPTION <caption>]                              ;
			[MESSAGE <message>]                              ;
			[COLOR <color>]                                  ;
			[FOCUS <fblock>]                                 ;
			[STATE <sblock>]                                 ;
			[<drop: DROPDOWN>]                               ;
			[<notarrow: NOTUSEARROW>]                        ;
			[<scroll: SCROLLBAR>]                            ;
			[SEND <msg>]                                     ;
			[GUISEND <guimsg>]                               ;
			[BITMAP <cBitmap>]                               ;
									 ;
	  => aadd(GetList,getnew(<top>,<left>,				 ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },           ;
		  <(var)>,NIL,<color>,<var>,<{valid}>,<{when}>) )        ;
	   ; ATail(GetList):Control := _ListBox_( ATail(Getlist):row,    ;
						  ATail(Getlist):col,    ;
		<bottom>, <right>, <var>, <items>, <caption>, <message>, ;
			  <color>, <{fblock}>, <{sblock}>, <.drop.>,     ;
				   <.scroll.>, <cBitmap> )               ;
	   ; ATail(GetList):reader  := { | a, b, c, d |                      ;
					GuiReader( a, b, c, d ) }            ;
	  [; ATail(GetList):<msg>]                                           ;
	  [; ATail(GetList):control:usearrow := !<.notarrow.>]                       ;
	  [; ATail(GetList):Control:<guimsg>]                                ;
	   ; ATail(GetList):Control:Display()
	   //; SetPos( <top>, <left> )                                         ;

#command @ <row>, <col> GET <var>                                           ;
			PUSHBUTTON                                          ;
			[VALID <valid>]                                     ;
			[WHEN <when>]                                       ;
			[CAPTION <caption>]                                 ;
			[MESSAGE <message>]                                 ;
			[COLOR <color>]                                     ;
			[FOCUS <fblock>]                                    ;
			[STATE <sblock>]                                    ;
			[STYLE <style>]                                     ;
			[SEND <msg>]                                        ;
			[GUISEND <guimsg>]                                  ;
			[SIZE X <sizex> Y <sizey>]                          ;
			[CAPOFF X <capxoff> Y <capyoff>]                    ;
			[BITMAP <bitmap>]                                   ;
			[BMPOFF X <bmpxoff> Y <bmpyoff>]                    ;
										;
	  => aadd(GetList,getnew(<row>,<col>,                                   ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },          ;
		  <(var)>,NIL,<color>,<var>,<{valid}>,<{when}>) )           ;
	   ; ATail(GetList):Control := _PushButt_( <caption>, <message>,        ;
			   <color>, <{fblock}>, <{sblock}>, <style>,            ;
			   <sizex>, <sizey>, <capxoff>, <capyoff>,              ;
			   <bitmap>, <bmpxoff>, <bmpyoff>, <row>, <col> -1 )    ;
	   ; ATail(GetList):reader  := { | a, b, c, d |                         ;
					GuiReader( a, b, c, d ) }               ;
	  [; ATail(GetList):<msg>]                                              ;
	  [; ATail(GetList):Control:<guimsg>]                                   ;
	   ; ATail(GetList):Control:Display()

#command @ <top>, <left>, <bottom>, <right> GET <var>                     ;
			RADIOGROUP <buttons>                              ;
			[VALID <valid>]                                   ;
			[WHEN <when>]                                     ;
			[CAPTION <caption>]                               ;
			[MESSAGE <message>]                               ;
			[COLOR <color>]                                   ;
			[FOCUS <fblock>]                                  ;
			[STYLE <style>]                                   ;
			[SEND <msg>]                                      ;
			[GUISEND <guimsg>]                                ;
									  ;
	  => aadd(GetList,getnew(<top>,<left>,                                ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },          ;
		  <(var)>,NIL,<color>,<var>,<{valid}>,<{when}>) )         ;
	   ; SetPos( <top>, <left> )                                         ;
	   ; ATail(GetList):Control := _RadioGrp_( ATail(Getlist):row,        ;
						   ATail(Getlist):col,        ;
	   <bottom>, <right>, <var>, <buttons>, <caption>, <message>,     ;
			 <color>, <{fblock}>, <style> )                       ;
	   ; ATail(GetList):reader  := { | a, b, c, d |                       ;
					GuiReader( a, b, c, d ) }             ;
	  [; ATail(GetList):<msg>]                                            ;
	  [; ATail(GetList):Control:<guimsg>]                                 ;
	   ; ATail(GetList):Control:Display()
//       ; SetPos( <top>, <left> )                                         ;

#command @ <top>, <left>, <bottom>, <right> GET <var>                   ;
			TBROWSE <oBrowse>                               ;
			[VALID <preBlock>]                              ;
			[WHEN <postBlock>]                              ;
			[MESSAGE <message>]                             ;
			[SEND <msg>]                                    ;
			[GUISEND <guimsg>]                              ;
									;
	  => aadd(GetList,getnew(<top>,<left>,                              ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },          ;
	  <(var)>,NIL,setcolor(),<var> , <{preBlock}> , <{postBlock}>) )    ;
	   ; <oBrowse>:ntop         := ATail(Getlist):row                   ;
	   ; <oBrowse>:nleft        := ATail(Getlist):col                   ;
	   ; <oBrowse>:nbottom      := <bottom>                             ;
	   ; <oBrowse>:nright       := <right>                              ;
	   ; <oBrowse>:Configure()                                          ;
	   ; ATail(GetList):Control := <oBrowse>                            ;
									;
	   ; ATail(GetList):reader  := { | a, b, c, d |                     ;
					TBReader( a, b, c, d ) }            ;
	  [; ATail(GetList):Control:Message := <message>]                   ;
	  [; ATail(GetList):<msg>]                                          ;
	  [; ATail(GetList):Control:<guimsg>]

#command @ <top>, <left>, <bottom>, <right> GET <var>                   ;
			TBROWSE <oBrowse>                               ;
			ALIAS <alias>                                   ;
			[VALID <preBlock>]                              ;
			[WHEN <postBlock>]                              ;
			[MESSAGE <message>]                             ;
			[SEND <msg>]                                    ;
			[GUISEND <guimsg>]                              ;
									;
	  => aadd(GetList,getnew(<top>,<left>,                              ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },          ;
	  <(var)>,NIL,setcolor(),<var> , <{preBlock}> , <{postBlock}>) )    ;
	   ; <oBrowse>:ntop         := ATail(Getlist):row                   ;
	   ; <oBrowse>:nleft        := ATail(Getlist):col                   ;
	   ; <oBrowse>:nbottom      := <bottom>                             ;
	   ; <oBrowse>:nright       := <right>                              ;
	   ; <oBrowse>:Configure()                                          ;
	   ; ATail(GetList):Control := <oBrowse>                            ;
									;
	   ; ATail(GetList):reader  := { | a, b, c, d |                     ;
			   <alias>->( TBReader( a, b, c, d ) ) }            ;
	  [; ATail(GetList):Control:Message := <message>]                   ;
	  [; ATail(GetList):<msg>]                                          ;
	  [; ATail(GetList):Control:<guimsg>]

#command @ <top>, <left>, <bottom>, <right> GET <var>                   ;
			TEXT						;
			[VALID <valid>]                                 ;
			[WHEN <when>]                                   ;
			[SEND <msg>]                                    ;
									;
	  => aadd(GetList,textgetnew(<top>,<left>,<bottom>,<right>,            ;
	   {|_1| local(_p:=@<var>), iif(_1==NIL,_p,_p:=_1 ) },          ;
		  <(var)>,setcolor(),<var>,<{valid}>,<{when}>) )  ;
	   [; ATail(GetList):<msg>]

#xdefine __get(b,v,pic,valid,when)		(___get(__field__ b __field__,v,pic,valid,when) )
#translate _GET_(<x1>,<x2>[,<x3>][,<x4>][,<x5>]) => __GET__(@<x1>,<x2>[,<x3>][,<x4>][,<x5>])


#command SET LOGLEVEL TO <n>                                            ;
	  => Set( _SET_LOGLEVEL, <n> )

#command SET LOGLEVEL <n>                                            ;
	  => Set( _SET_LOGLEVEL, <n> )

#command SET LOGFILE TO <(fname)>                                       ;
	  => Set( _SET_LOGFILE, <(fname)> )

#command SET DBF CHARSET TO <(csname)>                                       ;
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
				 <p> := IF(<p> == NIL, <v>, <p>) ;
				 [; <p2> := IF (<p2> == NIL, <v2>, <p2>) ]

#command DEF <p> RANGE <x1> [,<x2>] TO <v> =>;
				 <p> := if(<p> == NIL, <v>,;
				 if( <p> \< <x1> [.or. <p> \> <x2> ], <v>, <p>))

#command REPEAT => while .t.

#command UNTIL <val> => if !<val>; exit; endif; enddo

#command REQUEST  <vars,...>             =>

#command EXTERNAL <vars,...>             =>

#command SELECT <whatever>              => dbSelectArea( <(whatever)> )

#command REPLACE [ <f1> WITH <x1> [, <fn> WITH <xn>] ]                  ;
		 [FOR <for>]                                                    ;
		 [WHILE <while>]                                                ;
		 [NEXT <next>]                                                  ;
		 [RECORD <rec>]                                                 ;
		 [<rest:REST>]                                                  ;
		 [ALL]                                                          ;
																		;
	  => if ( set(_SET_OPTIMIZE) )                                      ;
	   ;    DBEvalOptimize(                                             ;
				 {|| _FIELD-><f1> := <x1> [, _FIELD-><fn> := <xn>]},    ;
				 [codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
			   )                                                        ;
	   ; else                                                           ;
	   ;    DBEval(                                                     ;
				 {|| _FIELD-><f1> := <x1> [, _FIELD-><fn> := <xn>]},    ;
				 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
			   )                                                        ;
	   ; end

#command REPLACE <f1> WITH <v1> [, <fN> WITH <vN> ]                     ;
	  => _FIELD-><f1> := <v1> [; _FIELD-><fN> := <vN>]

#command DELETE                                                         ;
		 [FOR <for>]                                                    ;
		 [WHILE <while>]                                                ;
		 [NEXT <next>]                                                  ;
		 [RECORD <rec>]                                                 ;
		 [<rest:REST>]                                                  ;
		 [ALL]                                                          ;
																		;
	  => if ( set(_SET_OPTIMIZE) )                                      ;
	   ;    DBEvalOptimize(                                             ;
				 {|| dbDelete()},                                       ;
				 [codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
			   )                                                        ;
	   ; else                                                           ;
	   ;    DBEval(                                                     ;
				 {|| dbDelete()},                                       ;
				 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
			   )                                                        ;
	   ; end

#command DELETE                 =>  dbDelete()

#command RECALL                                                         ;
		 [FOR <for>]                                                    ;
		 [WHILE <while>]                                                ;
		 [NEXT <next>]                                                  ;
		 [RECORD <rec>]                                                 ;
		 [<rest:REST>]                                                  ;
		 [ALL]                                                          ;
																		;
	  => if ( set(_SET_OPTIMIZE) )                                      ;
	   ;    DBEvalOptimize(                                             ;
				 {|| dbRecall()},                                       ;
				 [codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
			   )                                                        ;
	   ; else                                                           ;
	   ;    DBEval(                                                     ;
				 {|| dbRecall()},                                       ;
				 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
			   )                                                        ;
	   ; end

#command RECALL                 =>  dbRecall()

#command COUNT [TO <var>]                                               ;
		 [FOR <for>]                                                    ;
		 [WHILE <while>]                                                ;
		 [NEXT <next>]                                                  ;
		 [RECORD <rec>]                                                 ;
		 [<rest:REST>]                                                  ;
		 [ALL]                                                          ;
																		;
	  => <var> := 0                                                     ;
	   ; if ( set(_SET_OPTIMIZE) )                                      ;
	   ;    DBEvalOptimize(                                             ;
				 {|| local( _count :=@ <var>), _count := _count + 1},                               ;
				 [codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
			   )                                                        ;
	   ; else                                                           ;
	   ;    DBEval(                                                     ;
				 {|| local( _count :=@ <var>), _count := _count + 1},                               ;
				 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
			   )                                                        ;
	   ; end

#command SUM [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                       ;
		 [FOR <for>]                                                    ;
		 [WHILE <while>]                                                ;
		 [NEXT <next>]                                                  ;
		 [RECORD <rec>]                                                 ;
		 [<rest:REST>]                                                  ;
		 [ALL]                                                          ;
																		;
	  => <v1> := [ <vn> := ] 0                                          ;
	   ; if ( set(_SET_OPTIMIZE) )                                      ;
	   ;    DBEvalOptimize(                                             ;
			{|| local( <#v1#>:=@<v1> [, <#vn#>:=@<vn>]),		;
			<#v1#> := <#v1#> + <x1> [, <#vn#> := <#vn#> + <xn> ]},     ;
			[codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
			   )                                                        ;
	   ; else                                                           ;
	   ;    DBEval(                                                     ;
			{|| local( <#v1#>:=@<v1> [, <#vn#>:=@<vn>]),		;
			<#v1#> := <#v1#> + <x1> [, <#vn#> := <#vn#> + <xn> ]},     ;
			<{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
			   )                                                        ;
	   ; end

#command AVERAGE [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                   ;
		 [FOR <for>]                                                    ;
		 [WHILE <while>]                                                ;
		 [NEXT <next>]                                                  ;
		 [RECORD <rec>]                                                 ;
		 [<rest:REST>]                                                  ;
		 [ALL]                                                          ;
																		;
	  => M->__Avg := <v1> := [ <vn> := ] 0                              ;
	   ; if ( set(_SET_OPTIMIZE) )                                      ;
	   ;    DBEvalOptimize(                                             ;
			{|| local( <#v1#>:=@<v1> [, <#vn#>:=@<vn>]),		;
			M->__Avg := M->__Avg + 1,                           ;
			<#v1#> := <#v1#> + <x1> [, <#vn#> := <#vn#> + <xn>] },         ;
			[codestr( <for> )], <{while}>, <next>, <rec>, <.rest.> ;
			   )                                                        ;
																		;
	   ; else                                                           ;
	   ;    DBEval(                                                     ;
			{|| local( <#v1#>:=@<v1> [, <#vn#>:=@<vn>]),		;
			M->__Avg := M->__Avg + 1,                           ;
			<#v1#> := <#v1#> + <x1> [, <#vn#> := <#vn#> + <xn>] },         ;
			<{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
			   )                                                        ;
	   ; end                                                            ;
	   ; <v1> := <v1> / M->__Avg [; <vn> := <vn> / M->__Avg ]

#command LOCATE                                                         ;
		 [FOR <for>]                                                    ;
		 [WHILE <while>]                                                ;
		 [NEXT <next>]                                                  ;
		 [RECORD <rec>]                                                 ;
		 [<rest:REST>]                                                  ;
		 [ALL]                                                          ;
																		;
	  => if ( set(_SET_OPTIMIZE) )                                      ;
	   ;    __dbLocateOptimize( [codestr( <for> )], <{for}>, <{while}>, ;
			   <next>, <rec>, <.rest.> )                                ;
	   ; else                                                           ;
	   ;    __dbLocate( <{for}>, <{while}>, <next>, <rec>, <.rest.> )   ;
	   ; end

#command DO SWITCH <exp>         => switch <exp>
#command ENDSWITCH <*x*>         => end

#command SET FILTER TO <xpr>                                            ;
	  => if ( set(_SET_OPTIMIZE) )                                      ;
	   ;    dbSetFilter( <{xpr}>, codestr( <xpr> ) )                    ;
	   ; else                                                           ;
	   ;    dbSetFilter( <{xpr}>, <"xpr"> )                             ;
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

#command SET MACRO_IN_STRING <x:ON,OFF,&>      => Set( _SET_MACRO_IN_STRING, <(x)> )
#command SET MACRO_IN_STRING (<x>)             => Set( _SET_MACRO_IN_STRING, <x> )

/* Visual FoxPro */
#command SET HOURS [TO] 12                       => Set( _SET_HOURS, 0 )
/* usa */
#command SET HOURS [TO] 24                       => Set( _SET_HOURS, 1 )
/* euro */
#command SET SECONDS OFF                         => Set( _SET_SECONDS, 0 )
#command SET SECONDS ON                          => Set( _SET_SECONDS, 1 )

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

#endif
