/*
 * Source file: AOF.CH (CA-Clipper 5.2)
 * Description: Header file for Advantage Optimized Filter commands.
 *              Include this file (#include "AOF.CH") in your source
 *              code if you want to use the Advantage Optimized
 *              Filter commands or constants.
 *              If you only wish to use Advantage Optimized Filter
 *              functions, you do not need to include this header file
 *              in your source code.  Instead, you do need to add the
 *              AOF.OBJ file to your link script to guarantee the
 *              Advantage Optimized Filter library is linked into your
 *              application.
 * Notice     : Copyright 1993-1997 - Extended Systems, Inc.
 */

REQUEST AOFINIT

#translate NO OPTIMIZE  =>  NOOPTIMIZE

//=============================================================================
// Return Values From aofIsOptimizable()
//-----------------------------------------------------------------------------

#define OPT_FULL          2
#define OPT_PARTIAL       1
#define OPT_NONE          0


//=============================================================================
// aofSet() Definitions
//-----------------------------------------------------------------------------

#define AOF_SET_TYPECHECK    1
#define AOF_SET_OPTIMIZE     2
#define AOF_SET_RECHECK      4


//=============================================================================
// Filter Ownership Definitions
//-----------------------------------------------------------------------------

#define OWN_SYSTEM        1
#define OWN_USER          2


//=============================================================================
// aofFilterInfo() Return Array Element Definitions
//-----------------------------------------------------------------------------

#define INFO_EXPR         1  // Complete filter expression
#define INFO_NONEXPR      2  // Non-optimized part of the expression
#define INFO_OPTLVL       3  // Optimization level: 0=None, 1=Partial, 2=Full
#define INFO_COUNT        4  // Number of records in filter
#define INFO_SIZE         5  // Maximum record number possible in filter
#define INFO_OWNER        6  // Filter Owner: 1=System, 2=User
#define INFO_POS          7  // Current record positioned to in filter


//=============================================================================
// Specify "NOOPTIMIZE" to Override Automatic Optimization
//-----------------------------------------------------------------------------

#command AVERAGE [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                   ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => M->__Avg := <v1> := [ <vn> := ] 0                              ;
       ; DBEval( { || M->__Avg := M->__Avg + 1,                         ;
                 <v1> := <v1> + <x1> [, <vn> := <vn> + <xn>] },         ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.> )          ;
       ; <v1> := <v1> / M->__Avg [; <vn> := <vn> / M->__Avg ]


#command COUNT [TO <var>]                                               ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => <var> := 0                                                     ;
       ; DBEval( { || <var> := <var> + 1 },                             ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.> )


#command COPY [TO <(file)>]                                             ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
         [DELIMITED [WITH <*delim*>]]                                   ;
                                                                        ;
      => __dbDelim( .T.,                                                ;
                    <(file)>, <(delim)>, { <(fields)> },                ;
                    <{for}>, <{while}>, <next>, <rec>, <.rest.> )


#command COPY [TO <(file)>] [SDF]                                       ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => __dbSDF( .T.,                                                  ;
                  <(file)>, { <(fields)> },                             ;
                  <{for}>, <{while}>, <next>, <rec>, <.rest.> )


#command COPY [TO <(file)>]                                             ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [VIA <rdd>]                                                    ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => __dbCopy( <(file)>, { <(fields)> },                            ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.>, <rdd> )


#command DELETE                                                         ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => DBEval( { || dbDelete() },                                     ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.> )


#command DISPLAY [<list,...>]                                           ;
         [<off:OFF>]                                                    ;
         [<toPrint: TO PRINTER>]                                        ;
         [TO FILE <(toFile)>]                                           ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [<all:ALL>]                                                    ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => __DBList( <.off.>, { <{list}> }, <.all.>,                      ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.>,         ;
                   <.toPrint.>, <(toFile)> )


#command LABEL FORM <lbl>                                               ;
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
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => __LabelForm( <(lbl)>, <.print.>, <(toFile)>, <.noconsole.>,    ;
                      <{for}>, <{while}>, <next>, <rec>, <.rest.>,      ;
                      <.sample.> )


#command LIST [<list,...>]                                              ;
         [<off:OFF>]                                                    ;
         [<toPrint: TO PRINTER>]                                        ;
         [TO FILE <(toFile)>]                                           ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => __dbList( <.off.>, { <{list}> }, .t.,                          ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.>,         ;
                   <.toPrint.>, <(toFile)> )


#command REPLACE [ <f1> WITH <x1> [, <fn> WITH <xn>] ]                  ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => DBEval( {|| _FIELD-><f1> := <x1> [, _FIELD-><fn> := <xn>]},    ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.> )


#command REPORT FORM <frm>                                              ;
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
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => __ReportForm( <(frm)>, <.print.>, <(toFile)>, <.noconsole.>,   ;
                       <{for}>, <{while}>, <next>, <rec>, <.rest.>,     ;
                       <.plain.>, <heading>, <.noeject.>, <.summary.> )


#command SET FILTER TO <xpr>                                            ;
         [NOOPTIMIZE]                                                   ;
      => dbSetFilter( <{xpr}>, <"xpr"> )


#command SET FILTER TO <x:&>                                            ;
         [NOOPTIMIZE]                                                   ;
      => if ( Empty(<(x)>) )                                            ;
       ;    dbClearFilter()                                             ;
       ; else                                                           ;
       ;    dbSetFilter( <{x}>, <(x)> )                                 ;
       ; endif


#command SUM [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                       ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => <v1> := [ <vn> := ] 0                                          ;
       ; DBEval( { || <v1> := <v1> + <x1> [, <vn> := <vn> + <xn> ] },   ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.> )


#command SORT [TO <(file)>] [ON <fields,...>]                           ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => __dbSort( <(file)>, { <(fields)> },                            ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.> )


#command TOTAL [TO <(file)>] [ON <key>]                                 ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => __dbTotal( <(file)>, <{key}>, { <(fields)> },                  ;
                    <{for}>, <{while}>, <next>, <rec>, <.rest.> )


#command RECALL                                                         ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [NOOPTIMIZE]                                                   ;
                                                                        ;
      => DBEval( { || dbRecall() },                                     ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.> )


//=============================================================================
// Advantage Optimized Filter Commands
//-----------------------------------------------------------------------------

#command AVERAGE [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                   ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => M->__Avg := <v1> := [ <vn> := ] 0                              ;
       ; aofDbEval( { || M->__Avg := M->__Avg + 1,                      ;
                    <v1> := <v1> + <x1> [, <vn> := <vn> + <xn>] },      ;
                    <"for">, <{for}> )                                  ;
       ; <v1> := <v1> / M->__Avg [; <vn> := <vn> / M->__Avg ]


#command COPY [TO <(file)>] [FIELDS <fields,...>]                       ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
         [DELIMITED [WITH <*delim*>]]                                   ;
                                                                        ;
      => aofCopyDelim( <(file)>, <(delim)>, { <(fields)> },             ;
                       <"for">, <{for}> )


#command COPY [TO <(file)>] [SDF]                                       ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => aofCopySdf( <(file)>, { <(fields)> }, <"for">, <{for}> )


#command COPY [TO <(file)>]                                             ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [VIA <rdd>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => aofCopy( <(file)>, { <(fields)> }, <"for">, <{for}>, <rdd> )


#command COPY TO ARRAY <var>                                            ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         [<x:OFF>]                                                      ;
                                                                        ;
      => <var>:={}                                                      ;
       ; aofCopyToArray( @<var>, { <(fields)> }, <"for">, <{for}>,      ;
                         <{while}>, <next>, <rec>, <.rest.>, !<.x.> )   ;


#command COUNT [TO <var>] [FOR <for>] [ALL]                             ;
      => <var> := aofCountFor( <"for">, <{for}> )


#command DELETE [FOR <for>] [ALL]                                       ;
      => aofDbEval( { || dbDelete() }, <"for">, <{for}> )


#command DELETE                                                         ;
      => dbDelete()


#command DISPLAY [<list,...>]                                           ;
         [<off:OFF>]                                                    ;
         [<toPrint: TO PRINTER>]                                        ;
         [TO FILE <(toFile)>]                                           ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => aofListFor( <.off.>, { <{list}> }, .T.,                        ;
                     <"for">, <{for}>, <.toPrint.>, <(toFile)> )


#command INDEX ON <key> TO <(file)>                                     ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
         [ASCENDING]                                                    ;
         [<dec:    DESCENDING>]                                         ;
         [<u:      UNIQUE>]                                             ;
         [<cur:    USECURRENT>]                                         ;
         [<cur:    SUBINDEX>]                                           ;
         [EVAL     <opt> [EVERY <step>]]                                ;
         [OPTION   <opt> [STEP <step>]]                                 ;
         [<non:    NONCOMPACT>]                                         ;
         [<add:    ADDITIVE>]                                           ;
         [<custom: CUSTOM>]                                             ;
         [<custom: EMPTY>]                                              ;
                                                                        ;
      => aofOrdCondSet( <"for">, <{for}>, NIL, NIL, <{opt}>,            ;
                        <step>, RECNO(), NIL, NIL, NIL, [<.dec.>],      ;
                        .F., NIL, <.cur.>, <.custom.>, <.non.>, <.add.>,;
                        NIL, NIL )                                      ;
       ; aofCreateIndex( <(file)>, <"key">, <{key}>, [<.u.>] )


#command INDEX ON <key> TAG <(tag)>                                     ;
         [OF <(cdx)>]                                                   ;
         [TO <(cdx)>]                                                   ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
         [ASCENDING]                                                    ;
         [<dec:    DESCENDING>]                                         ;
         [<u:      UNIQUE>]                                             ;
         [<cur:    USECURRENT>]                                         ;
         [<cur:    SUBINDEX>]                                           ;
         [EVAL     <opt> [EVERY <step>]]                                ;
         [OPTION   <opt> [STEP <step>]]                                 ;
         [<add:    ADDITIVE>]                                           ;
         [<custom: CUSTOM>]                                             ;
         [<custom: EMPTY>]                                              ;
                                                                        ;
      => aofOrdCondSet( <"for">, <{for}>, NIL, NIL, <{opt}>,            ;
                        <step>, RECNO(), NIL, NIL, NIL, [<.dec.>],      ;
                        .T., <(cdx)>, <.cur.>, <.custom.>, NIL, <.add.>,;
                        NIL, NIL)                                       ;
       ; aofOrdCreate( <(cdx)>, <(tag)>, <"key">, <{key}>, [<.u.>] )


#command LABEL FORM <lbl>                                               ;
         [<sample: SAMPLE>]                                             ;
         [<noconsole: NOCONSOLE>]                                       ;
         [<print: TO PRINTER>]                                          ;
         [TO FILE <(toFile)>]                                           ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => aofLabelForm( <(lbl)>, <.print.>, <(toFile)>, <.noconsole.>,   ;
                       <"for">, <{for}>, <.sample.> )


#command LIST [<list,...>]                                              ;
         [<off:OFF>]                                                    ;
         [<toPrint: TO PRINTER>]                                        ;
         [TO FILE <(toFile)>]                                           ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => aofListFor( <.off.>, { <{list}> }, .t.,                        ;
                     <"for">, <{for}>, <.toPrint.>, <(toFile)> )


#command RECALL [FOR <for>] [ALL]                                       ;
      => aofDbEval( { || dbRecall() }, <"for">, <{for}> )


#command RECALL                                                         ;
      => dbRecall()


#command REFRESH FILTER                                                 ;
      => aofRebuildFilter()


#command REPLACE [ <f1> WITH <x1> [, <fn> WITH <xn>] ]                  ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => aofDbEval( {|| _FIELD-><f1> := <x1> [, _FIELD-><fn> := <xn>]}, ;
                    <"for">, <{for}> )


#command REPLACE <f1> WITH <v1> [, <fN> WITH <vN> ]                     ;
      => _FIELD-><f1> := <v1> [; _FIELD-><fN> := <vN>]


#command REPORT FORM <frm>                                              ;
         [HEADING <heading>]                                            ;
         [<plain: PLAIN>]                                               ;
         [<noeject: NOEJECT>]                                           ;
         [<summary: SUMMARY>]                                           ;
         [<noconsole: NOCONSOLE>]                                       ;
         [<print: TO PRINTER>]                                          ;
         [TO FILE <(toFile)>]                                           ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => aofReportForm( <(frm)>, <.print.>, <(toFile)>, <.noconsole.>,  ;
                        <"for">, <{for}>, <.plain.>, <heading>,         ;
                        <.noeject.>, <.summary.> )


#command SEARCH [FOR <for>] [TO <var>]                                  ;
      => <var>:={}                                                      ;
       ; aofSearch( <"for">, <{for}>, @<var> )


#command SET FILTER TO <xpr>                                            ;
      => aofSetFilter( <"xpr"> )


#command SET FILTER TO <x:&>                                            ;
      => if ( Empty( <(x)>) )                                           ;
       ;    dbClearFilter()                                             ;
       ; else                                                           ;
       ;    aofSetFilter( <(x)> )                                       ;
       ; endif


#command SUBINDEX ON <key> TO <(file)>                                  ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
         [ASCENDING]                                                    ;
         [<dec:    DESCENDING>]                                         ;
         [<u:      UNIQUE>]                                             ;
         [EVAL     <opt> [EVERY <step>]]                                ;
         [OPTION   <opt> [STEP <step>]]                                 ;
         [<non:    NONCOMPACT>]                                         ;
         [<add:    ADDITIVE>]                                           ;
         [<custom: CUSTOM>]                                             ;
         [<custom: EMPTY>]                                              ;
                                                                        ;
      => aofOrdCondSet( <"for">, <{for}>, NIL, NIL, <{opt}>,            ;
                        <step>, RECNO(), NIL, NIL, NIL, [<.dec.>],      ;
                        .F., NIL, .T., <.custom.>, <.non.>, <.add.>,    ;
                        NIL, NIL )                                      ;
       ; aofCreateIndex( <(file)>, <"key">, <{key}>, [<.u.>] )


#command SUBINDEX ON <key> TAG <(tag)>                                  ;
         [OF <(cdx)>]                                                   ;
         [TO <(cdx)>]                                                   ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
         [ASCENDING]                                                    ;
         [<dec:    DESCENDING>]                                         ;
         [<u:      UNIQUE>]                                             ;
         [EVAL     <opt> [EVERY <step>]]                                ;
         [OPTION   <opt> [STEP <step>]]                                 ;
         [<add:    ADDITIVE>]                                           ;
         [<custom: CUSTOM>]                                             ;
         [<custom: EMPTY>]                                              ;
                                                                        ;
      => aofOrdCondSet( <"for">, <{for}>, NIL, NIL, <{opt}>,            ;
                        <step>, RECNO(), NIL, NIL, NIL, [<.dec.>],      ;
                        .T., <(cdx)>, .T., <.custom.>, NIL, <.add.>,    ;
                        NIL, NIL )                                      ;
       ; aofOrdCreate( <(cdx)>, <(tag)>, <"key">, <{key}>, [<.u.>] )


#command SUM [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                       ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => <v1> := [ <vn> := ] 0                                          ;
       ; aofDbEval( {|| <v1> := <v1> + <x1> [, <vn> := <vn> + <xn> ]},  ;
                    <"for">, <{for}> )


#command SORT [TO <(file)>] [ON <fields,...>]                           ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => aofSortFor( <(file)>, { <(fields)> }, <"for">, <{for}> )


#command TOTAL [TO <(file)>] [ON <key>]                                 ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => aofTotalFor( <(file)>, <{key}>, { <(fields)> },                ;
                      <"for">, <{for}> )


#command SET TYPECHECK <x:ON,OFF,&>                                     ;
      => aofSet( AOF_SET_TYPECHECK, <(x)> )


#command SET TYPECHECK (<x>)                                            ;
      => aofSet( AOF_SET_TYPECHECK, <x> )


#command SET OPTIMIZE <x:ON,OFF,&>                                      ;
      => aofSet( AOF_SET_OPTIMIZE, <(x)> )


#command SET OPTIMIZE (<x>)                                             ;
      => aofSet( AOF_SET_OPTIMIZE, <x> )


#command SET RECHECK <x:ON,OFF,&>                                       ;
      => aofSet( AOF_SET_RECHECK, <(x)> )


#command SET RECHECK (<x>)                                              ;
      => aofSet( AOF_SET_RECHECK, <x> )


//=============================================================================
// Conversion for Obsolete Advantage Optimized Filter Functions
//-----------------------------------------------------------------------------

#xtranslate a6_Copy           => aofCopy
#xtranslate a6_CopyDelim      => aofCopyDelim
#xtranslate a6_CopySdf        => aofCopySdf
#xtranslate a6_CopyToArray    => aofCopyToArray
#xtranslate a6_CountFor       => aofCountFor
#xtranslate a6_CreateIndex    => aofCreateIndex
#xtranslate a6_IsOptimize     => aofIsOptimizable
#xtranslate a6_LabelForm      => aofLabelForm
#xtranslate a6_ListFor        => aofListFor
#xtranslate a6_RefreshFilter  => aofRebuildFilter
#xtranslate a6_ReportForm     => aofReportForm
#xtranslate a6_Search         => aofSearch
#xtranslate a6_Set            => aofSet
#xtranslate a6_SetFilter      => aofSetFilter
#xtranslate a6_SortFor        => aofSortFor
#xtranslate a6_TotalFor       => aofTotalFor
#xtranslate a6_Version        => aofGetVersion
#xtranslate a6_dbEval         => aofDbEval
#xtranslate a6_ordCondSet     => aofOrdCondSet
#xtranslate a6_ordCreate      => aofOrdCreate
