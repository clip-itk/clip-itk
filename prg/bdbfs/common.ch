/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#define M_SHARED .T.
#define M_EXCL .F.

#xdefine ismouse mpresent
#xdefine mousex  mcol
#xdefine mousey  mrow
#xdefine hidemouse mhide
#xdefine showmouse mshow
#xdefine setmousexy  msetpos
#xdefine makerealstruct  makerealstr
#xdefine center centerb		//чтобы не  путать CTools
#xdefine FreezeFields FreezeField
#xdefine d2bin ftoc

#xtranslate GetPath() => StartPath()
#xtranslate TimeSlice() =>
#define K_EMP 0	
#define _EMP CHR(K_EMP)	

#define SCROLL_LEFT	translate_charset("cp866",host_charset(),CHR(17))
#define SCROLL_RIGHT	translate_charset("cp866",host_charset(),CHR(16))
#define SCROLL_UP	translate_charset("cp866",host_charset(),CHR(24))
#define SCROLL_DOWN	translate_charset("cp866",host_charset(),CHR(25))
#define SCROLL_MARK	translate_charset("cp866",host_charset(),CHR(219))
#define SCROLL_FILL	translate_charset("cp866",host_charset(),CHR(177))

#define L_A_SIGN	translate_charset("cp866",host_charset(),CHR(254))

#xdefine KeyNo OrdKeyNo
#xdefine KeyCount OrdKeyCount
#xdefine TagUnique OrdIsUnique


#define _ESC CHR(27)
#define _INS CHR(22)
#define _DEL CHR(7)
#define BELL CHR(7)
#define _ENTER CHR(13)
#define _RIGHT CHR(4)
#define _LEFT CHR(19)
#define _DOWN CHR(24)
#define _UP CHR(5)
#define _PGUP CHR(18)
#define _PGDN CHR(3)
#define _LF CHR(10)
#define _HOME CHR(1)
#define _END CHR(6)
#define _CTRLEND CHR(23)
#define _CTRLHOME CHR(29)
#define _CTRLPGUP CHR(31)
#define _CTRLPGDN CHR(30)
#define _CTRLLEFT CHR(26)
#define _CTRLRIGHT CHR(2)
#define _DUMMY CHR(1)
#define _CRLF CHR(13)+CHR(10)
#define FRAME1 '┌─┐│┘─└│ '
#define _HelpKey CHR(28)

#define _AltLeft 411
#define _AltRight 413
#define _AltDown 416
#define _AltUp 408
#define K_ALT_GMINUS 330
#define K_ALT_GDIV 420
#define K_ALT_GPLUS 334
#define K_ALT_GMULT 311
#define K_ALT_GENTER 422
#define K_CTRL_GMINUS 398
#define K_CTRL_GDIV 405
#define K_CTRL_GPLUS 400
#define K_CTRL_GMULT 406
#define K_CTRL_2 259


#xtranslate AMSCAN(<arr>,<nDim>,<xVal>) => (ASCAN(<arr>,{|x| x\[<nDim>\]==<xVal>}))
#xtranslate BreakMess(<mess>)=> Nfind(<mess>) ; Break
#xtranslate ChDir(<cPath>) => DirChange(<cPath>)
#xtranslate CHG_EXT(<name>,<rt>,<ext>)=> Substr(<name>,1,Len(<name>)-<rt>)+<ext>
#xtranslate DbfDskSize([<base>]) => Fseek(m->_MainHandle,0,2)
#xtranslate DbfSize() => (Header()+RecSize()*LastRec())
#xtranslate ExactEqual(<c1>,<c2>)=> (ALLTRIM(UPPER(<c1>))==ALLTRIM(Upper(<c2>)))
#xtranslate Exclude(<cStr>,<cExcl>) => StrTran(<cStr>,<cExcl>)
#xtranslate OpenFileSize(<_handle>) => (Fseek(<_handle>,0,2))
*#xtranslate First(<mess>)=> (Substr(<mess>,1,1))
#xtranslate First(<mess>)=> (CHR(ASC(<mess>)))
#xtranslate IsPArray(<var>)=> (TYPE(<var>)=='A')
#xtranslate IsPBlock(<var>)=> (TYPE(<var>)=='B')
#xtranslate IsPCharacter(<var>)=> (TYPE(<var>)=='C')
#xtranslate IsPDATE(<var>)=> (TYPE(<var>)=='D')
#xtranslate IsInFilter()=> ( Empty(DBFilter()) .or. &(DbFilter()) )
#xtranslate IsPLogical(<var>)=> (TYPE(<var>)=='L')
#xtranslate IsPNumeric(<var>)=> (TYPE(<var>)=='N')
#xtranslate IsPObject(<var>)=> (TYPE(<var>)=='O')
#xtranslate IsSuchProc(<name>)=> IsFunction(<name>)
#xtranslate MessBack(<mess>) =>  Nfind(<mess>) ; go _tmr
#xtranslate MouseInRegion(<top>,<left>,<bottom>,<right>)=>;
	    (Between(_mx,<left>,<right>) .AND. Between(_my,<top>,<bottom>))
#xtranslate Really(<var>)=> (TYPE(<'var'>)=='L' .AND. <var>)
#xtranslate IsNilOrTrue(<var>)=> ( (<var> == NIL) .OR. <var>)
#xtranslate RestPos()=> DevPos(_r,_c)
#xtranslate ReturnMess(<mess>) =>  Nfind(<mess>) ; RETURN
#xtranslate ReversColor()=> (Substr(SetColor(),At(",",SetColor())+1))
#xtranslate SavePos()=> _r:=Row() ; _c:=Col()
#xtranslate Strip(<cStr>,<nRight>) => LEFT(<cStr>,LEN(<cStr>)-<nRight>)
#xtranslate WaitMouse0()=> WHILE MLeftDown() .OR. MRightDown(); inkey(); ENDDO

#define PsevdoMemoryName(_memo) 'IF(EMPTY('+ _memo +'),"memo","MEMO")'
#define RealMemoryName(_memo)  Substr(_memo,10, at( ')' ,_memo) - 10)

#xtranslate GetMouseXY() =>  _mox=MouseX() ; _moy=MouseY()
#xtranslate MX8() => MouseX()
#xtranslate MY8() => MouseY()

// мин. значение поля базы
#translate FINDMIN(<p>)=>FindMax(<p>,.f.)

#xtranslate TimerOn()=>m->_Told:=SECONDS()
#xtranslate IsNTX() =>('NTX' $ RddSetDefault())
#xtranslate IsMDX() =>('MDX' $ RddSetDefault())
#xtranslate IsVFP() =>('VFP' $ RddSetDefault())
#xtranslate IsTags() =>IF 'NTX' $ RddSetDefault(); NFIND(DRV_NTX);RETURN;ENDIF
#xtranslate IsVMemo(<i>) => (_FType\[<i>\]=='V' .AND. _FLen\[<i>\]>5)

#command READMENU PROMPTS <aPrompt>	;
		  [MESSAGES <aMess>]	;
		  [TITLE <cTitle>]	;
		  [MAKE <aAktions>]	;
		  [ROW <nRow>]		;
		  [COL <nCol>]		;
		  [<nc: NEEDCENTR>]	;
		  [MESSAGEROW <nMrow>]	;
		  [<hdir: HORIZONTAL>]	;
		  [<vdir: VERTICAL>]	;
		  [<nb: WITHBORDER>]	;
		  [<nob:NOBORDER>]	;
		  [<st:MAXSTEP>]	;
		  [STEP <nStep>]	;
		  [START <nStart>]	;
		  [COLOR <cColor>]	;
		  [LEVEL <nLevel>]	;
		  [WHEN_NOT <acExpr>]	;
		  [<lMain: MAIN>];
	 TO <v> ;
         => <v>:=MakeMenu(<aPrompt>,<aMess>,<aAktions>,;
			<cTitle>,<nRow>,;
         		IF(<.nc.>,-1,<nCol>),;
			<nMrow>,IF(<.vdir.>,.F.,.T.),IF(<.nob.>,.F.,.T.),;
			IF(<.st.>,-1,<nStep>),<nStart>,<cColor>,<nLevel>,;
			<acExpr>,IF(<.lMain.>,.T.,.F.))

#command SCAN => WHILE !EOF()
#command SCAN <*cond*> => WHILE (<cond>)
#command ENDSCAN => DBSKIP();ENDDO

#command  GET_HERE <var>						;
		[PICTURE <pic>]						;
		[VALID <valid>]						;
		[WHEN <when>]						;
		[SEND <msg>]						;
									;
	=> AAdd(							;
		GetList,						;
		_GET_( <var>, <(var)>, <pic>, <{valid}>, <{when}> )	;
		:Display())						;
	[; ATail(GetList):<msg>]

#command GET_HERE <var>				;
			[<clauses,...>]		;
			COLOR <color>		;
			[<moreClauses,...>]	;
;
	=> GET_HERE <var>			;
			[<clauses>]		;
			SEND colorDisp(<color>) ;
			[<moreClauses>]

#command SAY_HERE <xpr>				;
			[PICTURE <pic>]		;
			[COLOR <color>]		;
						;
	=>  DevOutPict( <xpr>, <pic> [, <color>] )

#command SAY_HERE <xpr>				;
			[COLOR <color>]         ;
	=> DevOut( <xpr> [, <color>] )

#command IF <condition> THEN <*aktion*>		;
	=> IF <condition> ; <aktion> ; ENDIF

#command ELSEDO <aktion>		;
	=> ELSE ; <aktion> ; ENDIF

#command ELSEIF <condition> THEN <*aktion*>;
	=> ELSEIF <condition> ; <aktion> ; ENDIF

#command IFOp(<condition>,<akt1>,<akt2>) ;
	=> IF <condition> ; <akt1> ; ELSE; <akt2> ; ENDIF

#command FOR <start> TO <end> DO <*aktion*>     ;
	=> FOR <start> TO <end>; <aktion> ; NEXT

#command WHILE <condition> DO <aktion> => ;
	 WHILE <condition> ; <aktion> ; END

#command WITH <object> DO [<x1> [,<xn>]] => ;
	<object>:<x1> [;<object>:<xn>]

#command PUSH KEYS [<aMain>] => SaveAllKeys([<aMain>])
#command PUSH KEYS [<aMain>] COLOR <clr> => SaveAllKeys([<aMain>],<clr>)
#command POP  KEYS [<lNoFunc>]=> RestoreAllKeys([<lNoFunc>])

#command IF_NIL <v> IS <val>;
	=> IF <v> = NIL ;;
		 <v>:=<val> ;;
	   ENDIF

#command IF_EMPTY <v> IS <val> [,<vn> IS <valn>] ;
	=> ;
	  <v> :=IF(EMPTY(<v>), <val> , <v> );
	[;<vn> :=IF(EMPTY(<vn>), <valn> ,<vn> )]

*****************
#include 'six2clip.ch'

