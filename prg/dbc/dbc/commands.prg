/*
 * DBC - Database Control Utility
 * Commands implementation
 *
 * Author: Alexander S.Kresin <alex@belacy.belgorod.su>
 *         www - http://www.geocities.com/alkresin/
 * Released to Public Domain
*/
*+≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤
*+
*+    Source Module => D:\MYAPPS\SOURCE\MYDBU\COMMANDS.PRG
*+
*+    Functions: Function C_REPL()
*+               Function C_DELE()
*+               Function C_COUN()
*+               Function C_SUM()
*+               Function C_APPE()
*+               Function C_COPY()
*+               Function C_REIN()
*+               Function C_PACK()
*+               Function C_ZAP()
*+               Function C_SETR()
*+               Function Vldareas()
*+               Function VvScope()
*+               Function VldScope()
*+               Function VvType()
*+               Function VldType()
*+               Function Vldfield()
*+               Function RUnLock()
*+               Function MemoFuncs()
*+
*+       Tables: DBUSEAREA(, msdriv[ msmsf[ improc, 7 ] ], msfile[ improc ],, !msmode[ improc, 1 ], msmode[ improc, 2 ] )
*+
*+    Reformatted by Click! 2.00 on Jun-20-2001 at 12:58 pm
*+
*+≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤≤

#command DELETE                                   ;
         [FOR <for>]                              ;
         [WHILE <while>]                          ;
         [NEXT <next>]                            ;
         [RECORD <rec>]                           ;
         [<rest:REST>]                            ;
         [ALL]                                    ;
                                                  ;
 => DBEval(                                       ;
     {|| iif(.not.set(_SET_EXCLUSIVE),rlock(),""),dbDelete(),;
     iif(.not.set(_SET_EXCLUSIVE),runlock(),"")},   ;
     <{for}>, <{while}>, <next>, <rec>, <.rest.>                     ;
        )
#command REPLACE [ <f1> WITH <x1> [, <fn> WITH <xn>] ]         ;
         [FOR <for>]                                           ;
         [WHILE <while>]                                       ;
         [NEXT <next>]                                         ;
         [RECORD <rec>]                                        ;
         [<rest:REST>]                                         ;
         [ALL]                                                 ;
      => DBEval(                                               ;
                 {||iif(.not.set(_SET_EXCLUSIVE),rlock(),""),  ;
                 _FIELD-><f1> := <x1> [, _FIELD-><fn> := <xn>],;
                 iif(.not.set(_SET_EXCLUSIVE),runlock(),"")},  ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.>   ;
               )

#ifdef RDD_AX
#ifdef __HARBOUR__
#include "ads.ch"
#else
#include "axntxcdx.ch"
#endif
#endif
#include "deflist.ch"

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function C_REPL()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION C_REPL

LOCAL bufsc, oldc, nrec, blsum, blfor, i
PRIVATE strfor := SPACE( 120 ), finame := SPACE( 8 ), expstr := SPACE( 80 ), afiel[ FCOUNT() ], nrez
PRIVATE prall, prnext, prrest, nrest, msknop := { "X", " ", " " }
   bufsc := SAVESCREEN( 6, 20, 14, 70 )
   oldc  := SETCOLOR()
   SET COLOR TO +W/GR,N+/W,,,+W/GR
   @  6, 20, 14, 70 BOX ORAMKA
   AFIELDS( afiel )
   DO WHILE .T.
#ifdef ENGLISH
      @  7, 22 SAY "Replace field" GET finame WHEN VLDFIELD( @finame )       
      @  8, 22 SAY "with"          GET expstr PICTURE "@S42"                 
#else
      @  7, 22 SAY "á†¨•≠®‚Ï ØÆ´•" GET finame WHEN VLDFIELD( @finame )       
      @  8, 22 SAY "≠†"            GET expstr PICTURE "@S42"                 
#endif
      VvScope( 9, 22 )
      @ 12, 22 SAY "FOR"                        
      @ 13, 22 GET strfor PICTURE "@S46"        
      READ
      IF LASTKEY() <> 27
         IF .NOT. EMPTY( strfor ) .AND. TYPE( strfor ) <> "L"
#ifdef ENGLISH
            MsgSay( "Wrong expression!" )
#else
            MsgSay( "ç•¢•‡≠Æ• ¢Î‡†¶•≠®•!" )
#endif
         ELSE
            IF EMPTY( strfor )
               strfor := ".T." + SPACE( 117 )
            ENDIF
#ifdef ENGLISH
            MsgInf( "Wait ..." )
#else
            MsgInf( "Ü§®‚• ..." )
#endif
            DO CASE
            CASE prall = "X"
               REPLACE ALL &finame WITH &expstr FOR &strfor
            CASE prnext = "X"
               REPLACE NEXT nrest &finame WITH &expstr FOR &strfor
            CASE prrest = "X"
               REPLACE REST &finame WITH &expstr FOR &strfor
            ENDCASE
#ifdef ENGLISH
            MsgInf( "Done !" )
#else
            MsgInf( "ÉÆ‚Æ¢Æ !" )
#endif
         ENDIF
      ELSE
         EXIT
      ENDIF
   ENDDO
   RESTSCREEN( 6, 20, 14, 70, bufsc )
   SETCOLOR( oldc )
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function C_DELE()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION C_DELE( prdel )

LOCAL bufsc, oldc, nrec, fname := SPACE( 45 )
PRIVATE strfor := SPACE( 120 )
PRIVATE prall, prnext, prrest, nrest, msknop := { "X", " ", " " }
   bufsc := SAVESCREEN( 7, 20, 14, 70 )
   oldc  := SETCOLOR()
   SET COLOR TO +W/GR,N+/W,,,+W/GR
   @  7, 20, 14, 70 BOX ORAMKA
#ifdef ENGLISH
   @  8, 25 SAY IIF( prdel, "Delete", "Recall" ) + " records"         
#else
   @  8, 25 SAY IIF( prdel, "ì§†´®‚Ï", "ÇÆ··‚†≠Æ¢®‚Ï" ) + " ß†Ø®·®"         
#endif
   VvScope( 9, 22 )
   @ 12, 22 SAY "FOR"                        
   @ 13, 22 GET strfor PICTURE "@S46"        
   READ
   IF LASTKEY() <> 27
      IF .NOT. EMPTY( strfor ) .AND. TYPE( strfor ) <> "L"
#ifdef ENGLISH
         MsgSay( "Wrong expression" )
#else
         MsgSay( "ç•¢•‡≠Æ• ¢Î‡†¶•≠®•!" )
#endif
      ELSE
         IF EMPTY( strfor )
            strfor := ".T."
         ENDIF
#ifdef ENGLISH
         MsgInf( "Wait ..." )
#else
         MsgInf( "Ü§®‚• ..." )
#endif
         DO CASE
         CASE prall = "X"
            IF prdel
               DELETE ALL FOR &strfor
            ELSE
               RECALL ALL FOR &strfor
            ENDIF
         CASE prnext = "X"
            IF prdel
               DELETE NEXT nrest FOR &strfor
            ELSE
               RECALL NEXT nrest FOR &strfor
            ENDIF
         CASE prrest = "X"
            IF prdel
               DELETE REST FOR &strfor
            ELSE
               RECALL REST FOR &strfor
            ENDIF
         ENDCASE
#ifdef ENGLISH
         MsgInf( "Done !" )
#else
         MsgInf( "ÉÆ‚Æ¢Æ !" )
#endif
      ENDIF
   ENDIF
   RESTSCREEN( 7, 20, 14, 70, bufsc )
   SETCOLOR( oldc )
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function C_COUN()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION C_COUN

LOCAL bufsc, oldc, nrec, nrez
PRIVATE strfor := SPACE( 120 )
PRIVATE prall, prnext, prrest, nrest, msknop := { "X", " ", " " }
   bufsc := SAVESCREEN( 6, 20, 14, 70 )
   oldc  := SETCOLOR()
   SET COLOR TO +W/GR,N+/W,,,+W/GR
   @  6, 20, 14, 70 BOX ORAMKA
   DO WHILE .T.
#ifdef ENGLISH
      @  8, 22 SAY "Count records:"         
#else
      @  8, 22 SAY "èÆ·Á®‚†‚Ï ™Æ´®Á•·‚¢Æ ß†Ø®·•©:"         
#endif
      VvScope( 9, 22 )
      @ 12, 22 SAY "FOR"                        
      @ 13, 22 GET strfor PICTURE "@S46"        
      READ
      IF LASTKEY() <> 27
         IF .NOT. EMPTY( strfor ) .AND. TYPE( strfor ) <> "L"
#ifdef ENGLISH
            MsgSay( "Wrong expression!" )
#else
            MsgSay( "ç•¢•‡≠Æ• ¢Î‡†¶•≠®•!" )
#endif
         ELSE
            IF EMPTY( strfor )
               strfor := ".T." + SPACE( 117 )
            ENDIF
#ifdef ENGLISH
            MsgInf( "Wait ..." )
#else
            MsgInf( "Ü§®‚• ..." )
#endif
            DO CASE
            CASE prall = "X"
               COUNT TO nrez ALL FOR &strfor
            CASE prnext = "X"
               COUNT TO nrez NEXT nrest FOR &strfor
            CASE prrest = "X"
               COUNT TO nrez REST FOR &strfor
            ENDCASE
#ifdef ENGLISH
            MsgInf( "Done !" )
            MsgSay( STR( nrez, 10 ) + " records." )
#else
            MsgInf( "ÉÆ‚Æ¢Æ !" )
            MsgSay( STR( nrez, 10 ) + " ß†Ø®·•©." )
#endif
         ENDIF
      ELSE
         EXIT
      ENDIF
   ENDDO
   RESTSCREEN( 6, 20, 14, 70, bufsc )
   SETCOLOR( oldc )
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function C_SUM()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION C_SUM

LOCAL bufsc, oldc, nrec, blsum, blfor
PRIVATE strfor := SPACE( 120 ), expstr := SPACE( 80 ), nrez
PRIVATE prall, prnext, prrest, nrest, msknop := { "X", " ", " " }
   bufsc := SAVESCREEN( 6, 20, 14, 70 )
   oldc  := SETCOLOR()
   SET COLOR TO +W/GR,N+/W,,,+W/GR
   @  6, 20, 14, 70 BOX ORAMKA
   DO WHILE .T.
#ifdef ENGLISH
      @  7, 22 SAY "Calculate sum:"                                 
      @  8, 22 SAY "of"             GET expstr PICTURE "@S42"       
#else
      @  7, 22 SAY "éØ‡•§•´®‚Ï ·„¨¨„:"                                 
      @  8, 22 SAY "§´Ô"               GET expstr PICTURE "@S42"       
#endif
      VvScope( 9, 22 )
      @ 12, 22 SAY "FOR"                        
      @ 13, 22 GET strfor PICTURE "@S46"        
      READ
      IF LASTKEY() <> 27
         IF ( .NOT. EMPTY( strfor ) .AND. TYPE( strfor ) <> "L" ) .OR. TYPE( expstr ) <> "N"
#ifdef ENGLISH
            MsgSay( "Wrong expression!" )
#else
            MsgSay( "ç•¢•‡≠Æ• ¢Î‡†¶•≠®•!" )
#endif
         ELSE
            IF EMPTY( strfor )
               strfor := ".T." + SPACE( 117 )
            ENDIF
            nrez  := 0
            blsum := &( "{||nrez:=nrez+" + expstr + "}" )
            blfor := &( "{||" + strfor + "}" )
#ifdef ENGLISH
            MsgInf( "Wait ..." )
#else
            MsgInf( "Ü§®‚• ..." )
#endif
            DO CASE
            CASE prall = "X"
               DBEVAL( blsum, blfor )
            CASE prnext = "X"
               DBEVAL( blsum, blfor,, nrest )
            CASE prrest = "X"
               DBEVAL( blsum, blfor,,,, .T. )
            ENDCASE
#ifdef ENGLISH
            MsgInf( "Done !" )
            MsgSay( "Rezult:" + STR( nrez, 18, 4 ) )
#else
            MsgInf( "ÉÆ‚Æ¢Æ !" )
            MsgSay( "ê•ß„´Ï‚†‚:" + STR( nrez, 18, 4 ) )
#endif
         ENDIF
      ELSE
         EXIT
      ENDIF
   ENDDO
   RESTSCREEN( 6, 20, 14, 70, bufsc )
   SETCOLOR( oldc )
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function C_APPE()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION C_APPE

LOCAL bufsc, oldc, nrec, fname := SPACE( 45 ), fielname := SPACE( 200 ), msfi, blfor, sword
PRIVATE strfor := SPACE( 120 ), finame := SPACE( 8 ), expstr := SPACE( 80 )
PRIVATE stroka, poz1
PRIVATE prdbf, prsdf, prdelim, cdelim := " ", msknop1 := { "X", " ", " " }
   bufsc := SAVESCREEN( 6, 20, 14, 70 )
   oldc  := SETCOLOR()
   SET COLOR TO +W/GR,N+/W,,,+W/GR
   @  6, 20, 14, 70 BOX ORAMKA
   @  7, 22 SAY "ÑÆ°†¢®‚Ï ®ß" GET fname PICTURE REPLICATE( 'X', 35 )       
#ifdef ENGLISH
   @  8, 22 SAY "Fields:" GET fielname PICTURE "@S30"       
#else
   @  8, 22 SAY "èÆ´Ô:" GET fielname PICTURE "@S30"       
#endif
   VvType( 9, 22 )
   @ 12, 22 SAY "FOR"                        
   @ 13, 22 GET strfor PICTURE "@S46"        
   READ
   IF LASTKEY() <> 27
      IF .NOT. EMPTY( strfor ) .AND. TYPE( strfor ) <> "L"
#ifdef ENGLISH
         MsgSay( "Wrong expression" )
#else
         MsgSay( "ç•¢•‡≠Æ• ¢Î‡†¶•≠®•!" )
#endif
      ELSE
         IF EMPTY( strfor )
            strfor := ".T." + SPACE( 117 )
         ENDIF
#ifdef ENGLISH
         MsgInf( "Wait ..." )
#else
         MsgInf( "Ü§®‚• ..." )
#endif
         IF AT( '\', fname ) = 0
            fname := mypath + IIF( .NOT. EMPTY( mypath ) .AND. RIGHT( mypath, 1 ) <> '\', '\', "" ) + fname
         ENDIF
         blfor := &( "{||" + TRIM( strfor ) + "}" )
         msfi  := Nil
         IF .NOT. EMPTY( fielname )
            stroka := TRIM( fielname )
            poz1   := 1
            msfi   := {}
            DO WHILE VALTYPE( sword := EL_NEXT() ) == "C"
               AADD( msfi, UPPER( LTRIM( RTRIM( sword ) ) ) )
            ENDDO
         ENDIF
         DO CASE
         CASE prdbf = "X"
            __dbApp( TRIM( fname ), msfi, blfor,,,, .F. )
         CASE prsdf = "X"
            __dbSdf( .F., TRIM( fname ), msfi, blfor,,,, .F. )
         CASE prdelim = "X"
            __dbDelim( .F., TRIM( fname ), IIF( cdelim = " ", "blank", cdelim ), msfi, blfor,,,, .F. )
         ENDCASE
#ifdef ENGLISH
         MsgInf( "Done !" )
#else
         MsgInf( "ÉÆ‚Æ¢Æ !" )
#endif
         GO TOP
         LI_NSTR := 1
      ENDIF
   ENDIF
   RESTSCREEN( 6, 20, 14, 70, bufsc )
   SETCOLOR( oldc )
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function C_COPY()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION C_COPY

LOCAL bufsc, oldc, nrec, fname := SPACE( 45 ), fielname := SPACE( 200 ), msfi, blfor, sword
PRIVATE strfor := SPACE( 120 ), finame := SPACE( 8 ), expstr := SPACE( 80 )
PRIVATE prall, prnext, prrest, nrest, msknop := { "X", " ", " " }
PRIVATE prdbf, prsdf, prdelim, cdelim := " ", msknop1 := { "X", " ", " " }
PRIVATE stroka, poz1
   bufsc := SAVESCREEN( 6, 20, 14, 70 )
   oldc  := SETCOLOR()
   SET COLOR TO +W/GR,N+/W,,,+W/GR
   @  6, 20, 14, 70 BOX ORAMKA
   @  7, 22 SAY "äÆØ®‡Æ¢†‚Ï ¢" GET fname PICTURE REPLICATE( 'X', 35 )       
#ifdef ENGLISH
   @  8, 22 SAY "Fields:" GET fielname PICTURE "@S30"       
#else
   @  8, 22 SAY "èÆ´Ô:" GET fielname PICTURE "@S30"       
#endif
   VvType( 9, 22 )
   VvScope( 9, 45 )
   @ 12, 22 SAY "FOR"                        
   @ 13, 22 GET strfor PICTURE "@S46"        
   READ
   IF LASTKEY() <> 27
      IF .NOT. EMPTY( strfor ) .AND. TYPE( strfor ) <> "L"
#ifdef ENGLISH
         MsgSay( "Wrong expression" )
#else
         MsgSay( "ç•¢•‡≠Æ• ¢Î‡†¶•≠®•!" )
#endif
      ELSE
         IF EMPTY( strfor )
            strfor := ".T." + SPACE( 117 )
         ENDIF
#ifdef ENGLISH
         MsgInf( "Wait ..." )
#else
         MsgInf( "Ü§®‚• ..." )
#endif
         IF AT( '\', fname ) = 0
            fname := mypath + IIF( .NOT. EMPTY( mypath ) .AND. RIGHT( mypath, 1 ) <> '\', '\', "" ) + fname
         ENDIF
         blfor := &( "{||" + TRIM( strfor ) + "}" )
         msfi  := Nil
         IF .NOT. EMPTY( fielname )
            stroka := TRIM( fielname )
            poz1   := 1
            msfi   := {}
            DO WHILE VALTYPE( sword := EL_NEXT() ) == "C"
               AADD( msfi, UPPER( LTRIM( RTRIM( sword ) ) ) )
            ENDDO
         ENDIF
         DO CASE
         CASE prdbf = "X" .AND. prall = "X"
            __dbCopy( TRIM( fname ), msfi, blfor,,,, .F. )
         CASE prdbf = "X" .AND. prnext = "X"
            __dbCopy( TRIM( fname ), msfi, blfor,, nrest,, .F. )
         CASE prdbf = "X" .AND. prrest = "X"
            __dbCopy( TRIM( fname ), msfi, blfor,,,, .T. )
         CASE prsdf = "X" .AND. prall = "X"
            __dbSdf( .T., TRIM( fname ), msfi, blfor,,,, .F. )
         CASE prsdf = "X" .AND. prnext = "X"
            __dbSdf( .T., TRIM( fname ), msfi, blfor,, nrest,, .F. )
         CASE prsdf = "X" .AND. prrest = "X"
            __dbSdf( .T., TRIM( fname ), msfi, blfor,,,, .T. )
         CASE prdelim = "X" .AND. prall = "X"
            __dbDelim( .T., TRIM( fname ), IIF( cdelim = " ", "blank", cdelim ), msfi, blfor,,,, .F. )
         CASE prdelim = "X" .AND. prnext = "X"
            __dbDelim( .T., TRIM( fname ), IIF( cdelim = " ", "blank", cdelim ), msfi, blfor,, nrest,, .F. )
         CASE prdelim = "X" .AND. prrest = "X"
            __dbDelim( .T., TRIM( fname ), IIF( cdelim = " ", "blank", cdelim ), msfi, blfor,,,, .T. )
         ENDCASE
#ifdef ENGLISH
         MsgInf( "Done !" )
#else
         MsgInf( "ÉÆ‚Æ¢Æ !" )
#endif
         GO TOP
         LI_NSTR := 1
      ENDIF
   ENDIF
   RESTSCREEN( 6, 20, 14, 70, bufsc )
   SETCOLOR( oldc )
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function C_REIN()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION C_REIN

   IF .NOT. msmode[ improc, 1 ]
      IF .NOT. FileLock()
         KEYBOARD CHR( 27 )
         RETURN Nil
      ENDIF
   ENDIF
#ifdef ENGLISH
   MsgInf( "Wait ..." )
#else
   MsgInf( "Ü§®‚• ..." )
#endif
   REINDEX
#ifdef ENGLISH
   MsgInf( "Done !" )
#else
   MsgInf( "ÉÆ‚Æ¢Æ !" )
#endif
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function C_PACK()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION C_PACK

#ifdef ENGLISH
LOCAL cPrompt := "Really pack ?"
#else
LOCAL cPrompt := "ìØ†™Æ¢†‚Ï ?"
#endif
   IF MsgYesNo( cPrompt )
      IF .NOT. msmode[ improc, 1 ]
         IF .NOT. FileLock()
            KEYBOARD CHR( 27 )
            RETURN Nil
         ENDIF
      ENDIF
#ifdef ENGLISH
      MsgInf( "Wait ..." )
#else
      MsgInf( "Ü§®‚• ..." )
#endif
      PACK
#ifdef ENGLISH
      MsgInf( "File packed." )
#else
      MsgInf( "î†©´ „Ø†™Æ¢†≠." )
#endif
   ENDIF
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function C_ZAP()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION C_ZAP

#ifdef ENGLISH
LOCAL cPrompt := "Really Zap ?"
#else
LOCAL cPrompt := "éÁ®·‚®‚Ï ‰†©´ ?"
#endif
   IF MsgYesNo( cPrompt )
      IF .NOT. msmode[ improc, 1 ]
         IF .NOT. FileLock()
            KEYBOARD CHR( 27 )
            RETURN Nil
         ENDIF
      ENDIF
      ZAP
   ENDIF
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function C_SETR()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION C_SETR

LOCAL bufsc, oldc, i, j, expstr := SPACE( 80 ), bexp, fname := SPACE( 10 )
   bufsc := SAVESCREEN( 6, 20, 13, 70 )
   oldc  := SETCOLOR()
   SET COLOR TO +W/GR,N+/W,,,+W/GR
   @  6, 20, 13, 70 BOX ORAMKA
   FOR i := 1 TO 3
      @  6 + i, 22 SAY "TO "                                                                                      
      @  6 + i, 25 SAY PADR( DBRELATION( i ), 30 )                                           COLOR "+W/RB"        
      @  6 + i, 55 SAY " INTO "                                                                                   
      @  6 + i, 61 SAY IIF( ( j := DBRSELECT( i ) ) = 0, SPACE( 9 ), PADR( ALIAS( j ), 9 ) ) COLOR "+W/RB"        
   NEXT
   @ 10, 22 TO 10, 68
   @ 11, 22 SAY "TO  " GET expstr PICTURE "@S40"                
   @ 12, 22 SAY "INTO" GET fname  WHEN Vldareas( @fname )       
   READ
   IF LASTKEY() <> 27
      expstr := TRIM( expstr )
      IF EMPTY( expstr )
#ifdef __HARBOUR__
         DBCLEARRELATION()
#else
         DBCLEARREL()
#endif
      ELSE
         bexp := &( "{||" + expstr + "}" )
         DBSETRELATION( fname, bexp, expstr )
      ENDIF
   ENDIF
   RESTSCREEN( 6, 20, 13, 70, bufsc )
   SETCOLOR( oldc )
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function Vldareas()
*+
*+    Called from ( commands.prg )   1 - function c_setr()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION Vldareas( varget )

LOCAL i, j, bufsc, msalias[ lenmsf ], rez
   bufsc := SAVESCREEN( 7, 32, 14, 48 )
   @  7, 32, 14, 48 BOX ORAMKA
   j := 1
   FOR i := 1 TO lenmsf
      IF msfile[ i ] <> Nil
         msalias[ j ] = ALIAS( i )
         j ++
      ENDIF
   NEXT
   rez := MainMenu( 8, 33, 13, 47, msalias )
   IF rez = 0
      IF TYPE( "varget" ) = "C"
         KEYBOARD CHR( 27 )
      ENDIF
   ELSE
      j := 1
      FOR i := 1 TO lenmsf
         IF msfile[ i ] <> Nil
            IF j = rez
               IF TYPE( "varget" ) = "C"
                  varget := msalias[ j ]
               ELSE
                  varget := i
               ENDIF
               EXIT
            ENDIF
            j ++
         ENDIF
      NEXT
   ENDIF
   RESTSCREEN( 7, 32, 14, 48, bufsc )
RETURN .F.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function VvScope()
*+
*+    Called from ( commands.prg )   1 - function c_repl()
*+                                   1 - function c_dele()
*+                                   1 - function c_coun()
*+                                   1 - function c_sum()
*+                                   1 - function c_copy()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION VvScope( y, x )

   prall  := "X"
   prnext := prrest := " "
   nrest  := 1
   @ y, x          SAY "[ ] All"                                                           
   @ y + 1, x      SAY "[ ] Next"                                                          
   @ y + 2, x      SAY "[ ] Rest"                                                          
   @ y, x + 1      GET prall      PICTURE "X"      VALID VldScope( prall, 1, y, x )        
   @ y + 1, x + 1  GET prnext     PICTURE "X"      VALID VldScope( prnext, 2, y, x )       
   @ y + 1, x + 10 GET nrest      PICTURE "999999" WHEN prnext == "X"                      
   @ y + 2, x + 1  GET prrest     PICTURE "X"      VALID VldScope( prrest, 3, y, x )       
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function VldScope()
*+
*+    Called from ( commands.prg )   3 - function vvscope()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION VldScope( knopka, iknop, y, x )

   IF .NOT. ( knopka $ " X" )
      RETURN .F.
   ENDIF
   IF LASTKEY() = 32
      AFILL( msknop, " " )
      msknop[ iknop ] = "X"
      prall  := msknop[ 1 ]
      prnext := msknop[ 2 ]
      prrest := msknop[ 3 ]
      @ y, x + 1     SAY prall          
      @ y + 1, x + 1 SAY prnext         
      @ y + 2, x + 1 SAY prrest         
   ENDIF
RETURN .T.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function VvType()
*+
*+    Called from ( commands.prg )   1 - function c_appe()
*+                                   1 - function c_copy()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION VvType( y, x )

   prdbf := "X"
   prsdf := prdelim := " "
   @ y, x          SAY "[ ] DBF"                                                                              
   @ y + 1, x      SAY "[ ] SDF"                                                                              
   @ y + 2, x      SAY "[ ] Delimited"                                                                        
   @ y, 23         GET prdbf           PICTURE "X" VALID VldType( prdbf, 1, y, x )                            
   @ y + 1, x + 1  GET prsdf           PICTURE "X" VALID VldType( prsdf, 2, y, x )                            
   @ y + 2, x + 1  GET prdelim         PICTURE "X" VALID VldType( prdelim, 3, y, x )                          
   @ y + 2, x + 14 SAY "With"          GET cdelim  PICTURE "X"                       WHEN prdelim == "X"      
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function VldType()
*+
*+    Called from ( commands.prg )   3 - function vvtype()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION VldType( knopka, iknop, y, x )

   IF .NOT. ( knopka $ " X" )
      RETURN .F.
   ENDIF
   IF LASTKEY() = 32
      AFILL( msknop1, " " )
      msknop1[ iknop ] = "X"
      prdbf   := msknop1[ 1 ]
      prsdf   := msknop1[ 2 ]
      prdelim := msknop1[ 3 ]
      @ y, x + 1     SAY prdbf           
      @ y + 1, x + 1 SAY prsdf           
      @ y + 2, x + 1 SAY prdelim         
   ENDIF
RETURN .T.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function Vldfield()
*+
*+    Called from ( commands.prg )   2 - function c_repl()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION Vldfield( varget )

LOCAL i, bufsc
   bufsc := SAVESCREEN( 8, 32, 17, 48 )
   @  8, 32, 17, 48 BOX ORAMKA
   i := MainMenu( 9, 33, 16, 47, afiel )
   IF i = 0
      KEYBOARD CHR( 27 )
   ELSE
      varget := afiel[ i ]
   ENDIF
   RESTSCREEN( 8, 32, 17, 48, bufsc )
RETURN .F.

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function RUnLock()
*+
*+    Called from ( commands.prg )   2 - 
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION RUnLock

   UNLOCK
RETURN Nil

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function MemoFuncs()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
FUNCTION MemoFuncs

LOCAL choic   := 1, bufscr
LOCAL submenu := { " PACK", " CONVERT TO DBT" }
LOCAL aDostup := { .T., .T. }
LOCAL kolf    := FCOUNT(), m1, m2
LOCAL fpath   := FilePath( msfile[ improc ] )
LOCAL fname   := fpath + "____dbc.dbf", memoname
   m1 := ARRAY( kolf )
   m2 := ARRAY( kolf )
   AFIELDS( m1, m2 )
   IF !msmode[ improc, 1 ] .OR. ASCAN( m2, "M" ) == 0
      aDostup[ 1 ] := aDostup[ 2 ] := .F.
   ENDIF
   IF msmode[ improc, 3 ] == 2
      submenu[ 2 ] = Stufmy( submenu[ 2 ], 13, 3, "FPT" )
   ENDIF
   DO WHILE .T.
      SET COLOR TO +GR/B,N/BG,,,N/B
      @ 16, 50, 19, 67 BOX ORAMKA
      choic := MainMenu( 17, 51, 18, 66, submenu, aDostup,, 1, 1 )
      IF choic = 0 .OR. lenmsf = 0 .OR. choic = 501
         RETURN choic
      ENDIF
      DO CASE
      CASE choic = 1
         IF FILE( fname ) .AND. FERASE( fname ) == - 1
            ALERT( "Can't create temporary file" )
         ELSE
            __dbCopy( fname,, { || !DELETED() },,,, .F. )
            DBCLOSEAREA()
            IF FERASE( msfile[ improc ] ) == - 1
               ALERT( "Can't erase file " + msfile[ improc ] + " : " + STR( FERROR(), 2 ) )
            ELSEIF FRENAME( fname, msfile[ improc ] ) == - 1
               ALERT( "Can't rename file to " + msfile[ improc ] + " : " + STR( FERROR(), 2 ) )
            ELSE
               memoname := CutExten( msfile[ improc ] ) + ;
                                     IIF( msmode[ improc, 3 ] == 1, ".FPT", ".DBT" )
               IF FERASE( memoname ) == - 1
                  ALERT( "Can't erase file " + memoname + " : " + STR( FERROR(), 2 ) )
               ELSEIF FRENAME( fpath + "____dbc." + IIF( msmode[ improc, 3 ] == 1, "FPT", "DBT" ), memoname ) == - 1
                  ALERT( "Can't rename file to " + memoname + " : " + STR( FERROR(), 2 ) )
               ENDIF
            ENDIF
            DBUSEAREA(, msdriv[ msmode[ improc, 3 ] ], msfile[ improc ],, !msmode[ improc, 1 ], msmode[ improc, 2 ] )
         ENDIF
      CASE choic = 2
      ENDCASE
      KEYBOARD CHR( 27 )
      EXIT
   ENDDO
RETURN Nil

*+ EOF: COMMANDS.PRG
