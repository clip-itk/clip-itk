/*
 * File......: NETTO.CH
 * Author....: Clipper Netware API Group
 * CIS ID....: 71620,1521
 * Date......: $Date$
 * Revision..: $Revision$
 * Log file..: $Logfile$
 * 
 * This is an original work by the Clipper Netware API working group
 * and is placed in the public domain.
 *
 * Modification history:
 * ---------------------
 *
 * $Log$
 * Revision 1.1  2006/06/22 20:12:13  itk
 * uri: init sf.net
 *
 * Revision 1.1  2002/03/09 13:58:11  clip
 * uri: start :) "netto" library
 *
 *
 */

#ifndef __NETTO_CH__
#define __NETTO_CH__


// ---------------------------------------------------------------------
// Bindery object types (decimal)
// ---------------------------------------------------------------------

#define OT_WILD                         (-1)
#define OT_UNKNOWN                       0   
#define OT_USER                          1  
#define OT_USER_GROUP                    2  
#define OT_PRINT_QUEUE                   3  
#define OT_FILE_SERVER                   4  
#define OT_JOB_SERVER                    5
#define OT_GATEWAY                       6
#define OT_PRINT_SERVER                  7
#define OT_ARCHIVE_QUEUE                 8
#define OT_ARCHIVE_SERVER                9  
#define OT_JOB_QUEUE                    10
#define OT_ADMINISTRATION               11
#define OT_NAS_SNA_GATEWAY              33
#define OT_REMOTE_BRIDGE_SERVER         36
#define OT_TIME_SYNCHRONIZATION_SERVER  45
#define OT_ARCHIVE_SERVER_DYNAMIC_SAP   46
#define OT_ADVERTISING_PRINT_SERVER     71
#define OT_BTRIEVE_VAP                  80
#define OT_PRINT_QUEUE_USER             83

// ---------------------------------------------------------------------

#define INT21            33

// ---------------------------------------------------------------------
// Error codes
// ---------------------------------------------------------------------

#define ESUCCESS      0
#define EINT86        (-501)
#define ENOSLOTS      (-502)
#define EBADPARM      (-503)

/* errors for connection and workstation services functions */

// the following errors will be returned by fn_attchFS() only

#define EALREADY_ATTACHED		(-510)
#define ENOFREE_SLOTS			(-511)
#define ENOMORE_SLOTS			(-512)
#define EUNKNOWN_SERVER			(-513)
#define ESERVER_BINDERY_LOCKED	        (-514)
#define ESERVER_NOT_RESPONDING	        (-515)

// the following error will be set by fn_StaAddr()

#define ENO_SHELL			(-520)

// the following error will be set by fn_detchFS()

#define ENOT_ATTACHED			(-530)

// the following errors will be returned by fn_MhsSndM()

#define EMHS_PARAM                      (-540)
#define EMHS_MV                         (-541)
#define EMHS_MAILSND                    (-542)
#define EMHS_CREATE                     (-543)
#define EMHS_SEND                       (-544)
#define EMHS_LIST                       (-545)

// ---------------------------------------------------------------------
// Converters
// ---------------------------------------------------------------------


#define UNSIGNED(n)   (n)                       // Temp fix til source is edited
#define L2HILO(n)     (l2bin(ft_lswap((n)))) 
#define W2HILO(n)     (i2bin(ft_iswap((n))))
#define HILO2L(c)     (ft_lswap(bin2l((c))))
#define HILO2W(c)     (ft_iswap(bin2i((c))))
#define I2BYTE(n)     (chr((n)))
#define BYTE2I(c)     (asc((c)))

// ---------------------------------------------------------------------
// Commands
// ---------------------------------------------------------------------

#xcommand DEFAULT <p> TO <val>;
               [,<pn> TO <valn>] ;
         =>;
               IF( <p> = NIL, <p> := <val>, ) ;
               [;IF(<pn> = NIL, <pn> := <valn>, )]

// ---------------------------------------------------------------------


#xcommand	CREATE JOBSTRUCT <aJob> ;
        [ QUEUE SERVER          <nTarg>   ] ;
        [ STARTDATE             <dXdate>  ] ;
        [ STARTTIME             <cXtime>  ] ;
        [ JOB TYPE              <nType>   ] ;
        [ <lAutoStart: AUTOSTART >        ] ;
        [ <lReStart:   RESTART   >        ] ;
        [ <lUHold:     USERHOLD  >        ] ;
        [ <lOHold:     OPERATORHOLD >     ] ;
        [ JOB DESCRIPTION       <cDesc>   ] ;
        [ CLIENT RECORD AREA    <cCliRec> ] ;
        => ;
            <aJob> := _fnqjob( ,,, <nTarg>, <dXdate>, <cXtime>,,,, <nType>,, ;
                               <.lAutoStart.>, <.lReStart.>,, <.lUHold.>, ;
                               <.lOHold.>,,,,,, <cDesc>, <cCliRec> )

// ---------------------------------------------------------------------

#xcommand CREATE PRINTJOB <cPrtJob> ;
  [ VERSION      <nVersion>   ] ;
  [ TAB SIZE     <nTabSz>     ] ;
  [ COPIES       <nCopies>    ] ;
  [ <lNoBanner: NOBANNER >    ] ;
  [ <lTxtStr:   TEXT >        ] ;
  [ <lBinStr:   BINARY >      ] ;
  [ <lNFF:    NOFORMFEED >    ] ;
  [ <lInt:    INTERRUPT >     ] ;
  [ MAXLINES     <nMaxLn>     ] ;
  [ MAXCHARS     <nMaxCh>     ] ;
  [ FORM NAME    <cForm>      ] ;
  [ BANNER NAME  <cBanNam>    ] ;
  [ BANNER FILE  <cBanFil>    ] ;
  [ HEADER FILE  <cHdrFil>    ] ;
  [ DIRPATH      <cDirPath>   ] ;
  => ;
      <cPrtJob> := _fnprtjob( <nVersion>, <nTabSz>, <nCopies>, <.lNoBanner.>, ;
                              <.lTxtStr.>, <.lBinStr.>, <.lNFF.>, <.lInt.>, <nMaxLn>,;
                              <nMaxCh>, <cForm>, <cBanNam>, <cBanFil>,;
                              <cHdrFil>, <cDirPath> )

// ---------------------------------------------------------------------

#xcommand CAPTURE                                              ;
                    [<jr: JOBRELEASE>]  [<njr: NOJOBRELEASE>]  ;
                    [<ff: FORMFEED>]    [<ff: FF>]             ;
                    [<nff: NOFORMFEED>] [<nff: NFF>]           ;
                    [<ntb: NOTABS>]     [<ntb: NT>]            ;
                    [TABS <nTabs>]      [T <nTabs>]            ;
                    [SERVERPRINTER <nPrinter>]                 ;
                    [COPIES <nCopies>]  [C <nCopies>]          ;
                    [TIMEOUT <nSec>]    [TI <nSec>]            ;
                    [<fd: FLUSHDEVICE>] [<nfd: NOFLUSHDEVICE>] ;
                    [<fd: AUTOENDCAP>]  [<nfd: NOAUTOENDCAP>]  ;
                    [<fd: A>]           [<nfd: NA>]            ;
                    [MAXLINES <nLines>]                        ;
                    [MAXCHARS <nChars>]                        ;
                    [FORM <cnForm>]     [F <cnForm>]           ;
                    [<nbn: NOBANNER>]   [<nbn: NB>]            ;
                    [BANNER <(cBanner)>][B <(cBanner)>]        ;
                    [NAM <(cName)>]                            ;
                    [QUEUE <(cPQ)>] [Q <(cPQ)>]                ;
                    [CREATE <(cPath)>] [CR <(cPath)>]          ;
                                                               ;
   =>  [ fn_printq(fn_gdeflpt(),<(cPQ)>) ;]                    ;
       [ fn_sBanUnm(<(cName)>) ;]                              ;
       [ fn_speCapF(<(cPath)>,0) ;]                            ;
       fn_SLptCap()                                            ;
     ; fn_sDefCpF({nil                                         ;
                      ,{ [<.jr.>][!<.njr.>]                    ;
                       , [!<.ff.>][<.nff.>]                    ;
                       , Iif(<.nTabs.>,.T.,[!<.ntb.>])         ;
                       , Iif(<.cBanner.>,.T.,[!<.nbn.>]) }     ;
                   ,[<nTabs>]                                  ;
                   ,[<nPrinter>]                               ;
                   ,[<nCopies>]                                ;
                   ,[Iif(ValType(<cnForm>)=="N",<cnForm>,)]    ;
                   ,nil                                        ;
                   ,[<(cBanner)>]                              ;
                   ,nil,nil                                    ;
                   ,[<nSec>*18]                                ;
                   ,[<.fd.>][!<.nfd.>]                         ;
                   ,[<nLines>],[<nChars>]                      ;
                   ,[Iif(ValType(<cnForm>)=="C",<cnForm>,)]  })

// ---------------------------------------------------------------------

#xcommand CAPTURE [<x>] L <nPort> [<clauses,...>] ;
                 => CAPTURE ON <nPort> [ <clauses>]


// ---------------------------------------------------------------------

#command CAPTURE ON <nDevice>                                  ;
                     [<jr: JOBRELEASE>]  [<njr: NOJOBRELEASE>] ;
                     [<ff: FORMFEED>]    [<ff: FF>]            ;
                     [<nff: NOFORMFEED>] [<nff: NFF>]          ;
                     [<ntb: NOTABS>]     [<ntb: NT>]           ;
                     [TABS <nTabs>]      [T <nTabs>]           ;
                     [SERVERPRINTER <nPrinter>]                ;
                     [COPIES <nCopies>]  [C <nCopies>]         ;
                     [TIMEOUT <nSec>]    [TI <nSec>]           ;
                     [<fd: FLUSHDEVICE>] [<nfd: NOFLUSHDEVICE>];
                     [<fd: AUTOENDCAP>]  [<nfd: NOAUTOENDCAP>] ;
                     [<fd: A>]           [<nfd: NA>]           ;
                     [MAXLINES <nLines>]                       ;
                     [MAXCHARS <nChars>]                       ;
                     [FORM <cnForm>]     [F <cnForm>]          ;
                     [<nbn: NOBANNER>]   [<nbn: NB>]           ;
                     [BANNER <(cBanner)>][B <(cBanner)>]       ;
                     [NAM <(cName)>]                           ;
                     [QUEUE <(cPQ)>] [Q <(cPQ)>]               ;
                                                               ;
   =>  Iif((<.cPQ.>), fn_printq(<nDevice>[,<(cPQ)>]),nil) ;    ;
       [ fn_sBanUnm(<(cName)>) ;]                              ;
       fn_sSplptC(<nDevice>)                                   ;
     ; fn_sSPCapF({nil                                         ;
                      ,{ [<.jr.>][!<.njr.>]                    ;
                       , [!<.ff.>][<.nff.>]                    ;
                       , Iif(<.nTabs.>,.T.,[!<.ntb.>])         ;
                       , Iif(<.cBanner.>,.T.,[!<.nbn.>]) }     ;
                   ,[<nTabs>]                                  ;
                   ,[<nPrinter>]                               ;
                   ,[<nCopies>]                                ;
                   ,[Iif(ValType(<cnForm>)=="N",<cnForm>,)]    ;
                   ,nil                                        ;
                   ,[<(cBanner)>]                              ;
                   ,nil,nil                                    ;
                   ,[<nSec>*18]                                ;
                   ,[<.fd.>][!<.nfd.>]                         ;
                   ,[<nLines>],[<nChars>]                      ;
                   ,[Iif(ValType(<cnForm>)=="C",<cnForm>,)]  } ;
                  , <nDevice>)

// ---------------------------------------------------------------------

#command ENABLE LOGIN	=> fn_enalog()
#command DISABLE LOGIN  => fn_dislog()

#command CASTOFF	=> fn_setbmod( 1 )
#command CASTOFF ALL    => fn_setbmod( 2 )
#command CASTON         => fn_setbmod( 0 )

// ---------------------------------------------------------------------


#command CAPTURE PRN   [<captureclauses,...>] => CAPTURE [<captureclauses>]
#command CAPTURE LPT1  [<captureclauses,...>] => CAPTURE ON 1 [<captureclauses>]
#command CAPTURE LPT2  [<captureclauses,...>] => CAPTURE ON 2 [<captureclauses>]
#command CAPTURE LPT3  [<captureclauses,...>] => CAPTURE ON 3 [<captureclauses>]

#command ENDCAP      => fn_eLPTcap()

#command ENDCAP <nDevice> => fn_eSpLPTc(<nDevice>)
#command ENDCAP PRN  => fn_eLPTcap()
#command ENDCAP LPT1 => fn_eSpLPTc(1)
#command ENDCAP LPT2 => fn_eSpLPTc(2)
#command ENDCAP LPT3 => fn_eSpLPTc(3)

#command SAVE CAPTURE      TO <save> => <save> := fn_gDefCpf()
#command SAVE CAPTURE PRN  TO <save> => <save> := fn_gDefCpf()
#command SAVE CAPTURE LPT1 TO <save> => <save> := fn_gSPCapf(1)
#command SAVE CAPTURE LPT2 TO <save> => <save> := fn_gSPCapf(2)
#command SAVE CAPTURE LPT3 TO <save> => <save> := fn_gSPCapf(3)

#command RESTORE CAPTURE      FROM <save>  => fn_sDefCpf(<save>)   ; Iif(<save>\[CF_PRINTQUEUEID\] == 0,nil,fn_printq(fn_gdeflpt(),<save>\[CF_PRINTQUEUEID\]))
#command RESTORE CAPTURE PRN  FROM <save>  => fn_sDefCpf(<save>)   ; Iif(<save>\[CF_PRINTQUEUEID\] == 0,nil,fn_printq(fn_gdeflpt(),<save>\[CF_PRINTQUEUEID\]))
#command RESTORE CAPTURE LPT1 FROM <save>  => fn_sSPCapf(<save>,1) ; Iif(<save>\[CF_PRINTQUEUEID\] == 0,nil,fn_printq(1,<save>\[CF_PRINTQUEUEID\]))
#command RESTORE CAPTURE LPT2 FROM <save>  => fn_sSPCapf(<save>,2) ; Iif(<save>\[CF_PRINTQUEUEID\] == 0,nil,fn_printq(2,<save>\[CF_PRINTQUEUEID\]))
#command RESTORE CAPTURE LPT3 FROM <save>  => fn_sSPCapf(<save>,3) ; Iif(<save>\[CF_PRINTQUEUEID\] == 0,nil,fn_printq(3,<save>\[CF_PRINTQUEUEID\]))

// ---------------------------------------------------------------------
// Errors for Bindery Functions [to be cleaned up]
// ---------------------------------------------------------------------

#define SERVER_OUT_OF_MEMORY         150
#define NOT_ITEM_PROPERTY            232
#define MEMBER_ALREADY_EXISTS        233
#define NO_SUCH_MEMBER               234
#define NOT_GROUP_PROPERTY           235
#define NO_SUCH_SEGMENT              236
#define PROPERTY_ALREADY_EXISTS      237
#define OBJECT_ALREADY_EXISTS        238
#define INVALID_NAME                 239
#define WILDCARD_NOT_ALLOWED         240
#define INVALID_BINDERY_SECURITY     241
#define NO_OBJECT_RENAME_PRIVILEGE   243
#define NO_OBJECT_DELETE_PRIVILEGE   244
#define NO_OBJECT_CREATE_PRIVILEGE   245
#define NO_PROPERTY_DELETE_PRIVILEGE 246
#define NO_PROPERTY_CREATE_PRIVILEGE 247
#define NO_PROPERTY_WRITE_PRIVILEGE  248
#define NO_PROPERTY_READ_PRIVILEGE   249
#define NO_SUCH_PROPERTY             251
#define NO_SUCH_OBJECT               252
#define SERVER_BINDERY_LOCKED        254
#define BINDERY_FAILURE              255

// ---------------------------------------------------------------------
// Security rights levels
// ---------------------------------------------------------------------

#define SEC_ANYONE         0
#define SEC_LOGGED         1
#define SEC_OBJECT         2
#define SEC_SUPERVISOR     3
#define SEC_NETWARE        4

// ---------------------------------------------------------------------
// Queue job entry structure array indices
// ---------------------------------------------------------------------

#define QJ_CLIENT_STATION      1
#define QJ_CLIENT_TASK         2
#define QJ_CLIENT_ID           3
#define QJ_TARGET_SERVER       4
#define QJ_TARGET_EXEC_DATE    5
#define QJ_TARGET_EXEC_TIME    6
#define QJ_JOB_ENTRY_DATE      7
#define QJ_JOB_ENTRY_TIME      8
#define QJ_JOB_NUMBER          9
#define QJ_JOB_TYPE           10
#define QJ_JOB_POSITION       11
#define QJ_AUTOSTART          12
#define QJ_RESTART            13
#define QJ_ENTRYOPEN          14
#define QJ_USERHOLD           15
#define QJ_OPERATORHOLD       16
#define QJ_JOB_FILE_NAME      17
#define QJ_JOB_FILE_HANDLE    18
#define QJ_SERVER_STATION     19
#define QJ_SERVER_TASK        20
#define QJ_SERVER_ID          21
#define QJ_JOB_DESCRIPTION    22
#define QJ_CLIENT_RECORD_AREA 23

// ---------------------------------------------------------------------
// Capture Flags Structure
// ---------------------------------------------------------------------


#define CF_FLAGCOUNT            26
#define CF_PRINTFLAGCOUNT        4

#define CF_STATUSFLAG            1

#define CF_PRINTFLAGS            2
  #define CF_PRINTRELEASE        1
  #define CF_SUPPRESSFORMFEED    2
  #define CF_INTERPRETCTRLSEQ    3
  #define CF_PRINTBANNER         4

#define CF_TABSIZE               3
#define CF_SERVERPRINTER         4
#define CF_NUMBERCOPIES          5
#define CF_FORMTYPE              6
#define CF_RESERVEDFLAG1         7
#define CF_BANNERTEXT            8
#define CF_RESERVEDFLAG2         9
#define CF_LOCALLPTDEVICE       10
#define CF_FLUSHCAPTIMEOUT      11
#define CF_FLUSHCAPONDEVCLOSE   12
#define CF_MAXLINES             13
#define CF_MAXCHARS             14
#define CF_FORMNAME             15
#define CF_LPTCAPTUREFLAG       16
#define CF_FILECAPTUREFLAG      17
#define CF_TIMINGOUTFLAG        18
#define CF_PRTRSETBUFFERADD     19
#define CF_PRTRESETBUFFADD      20
#define CF_CONIDQUEPRTJOB       21
#define CF_CAPTUREINPROG        22
#define CF_PRINTQUEUEFLAG       23
#define CF_PRINTJOBVALID        24
#define CF_PRINTQUEUEID         25
#define CF_PRINTJOBNUMBER       26

// ---------------------------------------------------------------------

#define FA_TRANSACTIONAL 5      // Don't change these defines
#define FA_INDEX         6
#define FA_READ_AUDIT    7
#define FA_WRITE_AUDIT   8

#endif // __NETTO_CH__
