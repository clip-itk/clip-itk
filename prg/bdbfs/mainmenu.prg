/*
    Copyright (C) 1998-2002 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
MEMVAR _MenuColor,HiddenColor,_im,_bm,_c_f
STATIC nLevel:=0, _Finish:=.F.
**********
PROC MainMenu(lShow)
STATIC ch1:=1,aClip,aStart
LOCAL cTypWhen,i
LOCAL	_SysF,_FileF,_FileW,_BaseF,_BaseW,;
	_FieldF,_FieldW,_RecordF,_RecordW,;
	_FindF,_FindW,_InfoF,_OtherF,_OtherW,;
	_CfF,_CfW,_TagF,_SetF,_CpbF,;
	_ReplAF,_ReplCF,_ReplRF,_ReplM,_TransF

LOCAL	mP:=_MM_MAINMENU,;
	mF:={{||SecondMenu(_MM_SYSMENU,_SysF)},;
	     {||SecondMenu(_MM_FILEMENU,_FileF,,,_FileW)},;
	     {||SecondMenu(_MM_BASEMENU,_BaseF,,,_BaseW)},;
	     {||SecondMenu(_MM_FIELDMENU,_FieldF,,,_FieldW)},;
	     {||SecondMenu(_MM_RECORDMENU,_RecordF,,,_RecordW)},;
	     {||SecondMenu(_MM_FINDMENU,_FindF,,,_FindW)},;
	     {||SecondMenu(_MM_INFOMENU,_InfoF)},;
	     {||SecondMenu(_MM_OTHERMENU,_OtherF,,,_OtherW)}}


@ 1,76 SAY 'F10' COLOR IF(EMPTY(lShow),_bm,_im)
IF !EMPTY(lShow)
	i:=1
	aStart:={}
	AEval(mP,{|_el| AADD(aStart,i),;
			DevPos(1,i),;
			DevOut(Exclude(_el,'~')),;
			i:=col()+4})
	AADD(aStart,i-3)
	RETURN
ENDIF
_Finish:=.F.

_SysF:={{||SelectRdd()},;
	{||SecondMenu(_MM_SETMENU,_SetF)},;
	{||SaveIni()},;
	{||CalcExpr()},;
	{||SetVar()},;
	{||Help('MAIN')},;
	{||Okey(_MSG_H_OKEY)},;
	{||m->_req:=0,m->_base:=''};
	}

_SetF:={{||Configure()},;
	{||Colors()},;
	{||Sets()},;
	{||OtherConf()};
}

_FileF:={{||SelectBase()},;
	 {||ReOpenPrev()},;
	 {||ModiStru()},;
	 {||NewBase()},;
	 {||CheckDbfSize()},;
	 {||SaveEnv()},;
	 {||RestEnv()},;
	 {||RestIni()},;
	 {||SaveAutoOpen()},;
	 {||BliRun()},;
	 {||ChangeDir()},;
	 {||MFiler()},;
	 {||ModiFile()},;
	 {||Tb2Html()};
}
_FileW:={.F.,EMPTY(m->__aPrev[2])}

_BaseF:={{||AppeFrom()},;
	 {||CopyTo()},;
	 {||CopyRdd()},;
	 {||RestFor(DELETING,{||dbDelete()})},;
	 {||RestFor(RECALLING,{||dbRecall()})},;
	 {||RestFor(INVERTING,{|| IF(DELETED(),dbRecall(),dbDelete())})},;
	 {||PackProg()},;
	 {||SortFor()},;
	 {||TotalFor()},;
	 {||IndexFor()},;
	 {||Reindex()},;
	 {||SetIndex()},;
	 {||SecondMenu(_MM_TAGMENU, _TagF)},;
	 {||SX_Descend(),m->_req:=2},;
	 {||SetFilter()},;
	 {||CountFor()},;
	 {||Prt()},;
	 {||RestPrintIni()};
}
_BaseW:={.F.,;
	 .F.,;
	 !m->lWasMemo,;
	 .F.,;
	 .F.,;
	 .F.,;
	 .F.,;
	 .F.,;
	 EMPTY(IndexKey(0)),;		//Total
	 .F.,;
	 IndexCount()=0,;		//Reindex
	 .F.,;
	 [NTX] $ m->_DefaultRdd,;	//TAGMENU
	 EMPTY(IndexKey(0));		//Sx_Descend
}

_RecordF:={{||NewRec()},;
	   {||InsRec()},;
	   {||CopyRec()},;
	   {||ClearRec()},;
	   {||Scatter(@aClip)},;
	   {||SX_Rlock(),Gather(aClip)},;
	   {||Chg_recs(-1)},;
	   {||Chg_Recs(1)},;
	   {||GotoRec(1)},;
	   {||FullEdit()/*, _BdbfBrow:RefreshAll()*/},;
	   {||PrintEdit()};
}

_RecordW:={,!EMPTY(IndexKey(0));
}
_TransF:={{||MyRepl(_C_F,Upper(m->__Content))},;
	  {||MyRepl(_C_F,Lower(m->__Content))},;
	  {||MyRepl(_C_F,Capitalz(m->__Content))},;
	  {||MyRepl(_C_F,Proper(m->__Content))},;
	  {||MyRepl(_C_F,OemToAnsi(m->__Content))},;
	  {||MyRepl(_C_F,AnsiToOem(m->__Content))},;
	  {||MyRepl(_C_F,Usa2Nation(m->__Content))},;
	  {||MyRepl(_C_F,Nation2Usa(m->__Content))};
	  }

_CfF:={ {||CopyField(1)},;
	{||CopyField(2)},;
	{||CopyField(3)},;
	{||CopyField(4)},;
	{||CopyField(5)},;
	{||ClipField(1)},;
	{||CopyField(6)},;
	{||CopyField(7)};
}
_CfW:={.F.,.F.,.F.,.F.,.F.,.F.,;
	!Is_ClipBrd(),!Is_ClipBrd()}

_ReplM:=_MM_REPLMENU
_ReplAF:={{||ReplFor(K_ALT_F4,.T.)},{||ReplFor(K_ALT_F4,.F.)}}
_ReplCF:={{||ReplFor(K_CTRL_F4,.T.)},{||ReplFor(K_CTRL_F4,.F.)}}
_ReplRF:={{||ReplFor(K_ALT_R,.T.)},{||ReplFor(K_ALT_R,.F.)}}

_FieldF:={{||SumFor()},;
	  {||SecondMenu(_ReplM,_ReplAF)},;
	  {||SecondMenu(_ReplM,_ReplCF)},;
	  {||SecondMenu(_ReplM,_ReplRF)},;
	  {||MakeEmpty(_C_F)},;
	  {||Undo()},;
	  {||SecondMenu(_MM_TRANSMENU, _TransF)},;
	  {||MyRepl(_C_F,CryptStr(m->__Content))},;
	  {||MyRepl(_C_F,DeCryptStr(m->__Content))},;
	  {||MyRepl(_C_F,Crc_All(_C_F))},;
	  {||MyRepl(_C_F,SX_SlimFast(m->__Content))},;
	  {||MyRepl(_C_F,Compress(m->__Content))},;
	  {||MyRepl(_C_F,DeCompress(m->__Content))},;
	  {||SecondMenu(_MM_COPYMENU,_CfF,,,_CfW)},;
	  {||FreezeFields()},;
	  {||NewColor(.F.)},;
	  {||NewColor(.T.)};
}
cTypWhen:=!(m->__ContentType == [C])
_FieldW:={!(m->__ContentType $ [NC]),;
	  .F.,;
	  .F.,;
	  .F.,;
	  .F.,;
	  .F.,;
	  cTypWhen,;
	  cTypWhen,;
	  cTypWhen,;
	  cTypWhen,;
	  cTypWhen,;
	  cTypWhen,;
	  cTypWhen,;
	  .F.,;
	  .F.,;
	  .F.;
}

_FindF:={{||GotoRec()},;
	 {||SeekInd()},;
	 {||LocateFor()},;
	 {||ContLocate()},;
	 {||LocateFor(.T.)},;
	 {||ContLocate(.T.)},;
	 {||GlobFind()},;
	 {||SimpleLoc()},;
	 {||Extremum(1)},;
	 {||Extremum(2)},;
	 {||FindLong()},;
	 {||FindDouble()},;
	 {||SeekWild()},;
	 {||SeekWild(.T.)},;
}
cTypWhen:=EMPTY(IndexKey(0))
_FindW:={.F.,;
	cTypWhen,;
	.F.,;
	EMPTY(__DbSetLoc()),;
	.F.,;
	EMPTY(__DbSetLoc()),;
	.F.,;
	.F.,;
	.F.,;
	.F.,;
	m->_CurType $ [NLFD],;
	cTypWhen,;
	cTypWhen,;
	cTypWhen;
}

_InfoF:={{||Information()},;
	 {||DispStru()};
}

_OtherF:={{||PlayMacro()},;
	  {||SetField()},;
	  {||SecondMenu(_MM_CLIPBDMENU, _CpbF)},;
	  {||SecondMenu(m->UserMenuPrompt,m->UserMenuAct)};
}
_OtherW:={EMPTY(m->_macro),.F.,.F.,;
	  Type("m->UserMenuPrompt")+Type("m->UserMenuAct")<>"AA",;
	  .F.}

#IFNDEF ENGLISH
	cTypWhen:='Контрольный разряд '
	AADD(_OtherF,{||SecondMenu(;
				{cTypWhen+"счета в банке Украины",;
				 cTypWhen+"счета в банке России",;
				 cTypWhen+"МФО",;
				 cTypWhen+"ОКПО"},;
				{{||TakeKR(1)},;
				 {||TakeKR(2)},;
				 {||TakeKR(3)},;
				 {||TakeKR(4)}};
			)};
	)
#ENDIF

_TagF:={{||SetTag()},;
	{||DelTag()},;
	{||AddTag()},;
	{||SetCdx()};
}

_CpbF:={{||ClipField(1)},;
	{||ClipField(2)},;
	{||ClipField(3)},;
	{||ClipField(4)},;
	{||ClipField(5)},;
	{||ClipField(6)},;
	{||ClipField(7)},;
	{||Scatter(@aClip)},;
	{||Sx_Rlock(),Gather(aClip)};
}

PUSH KEYS
nLevel:=1
DO WHILE ch1<>0 .AND. !_Finish
	IF !EMPTY(m->__Menu_Col)
		ch1:=MAX(ASCAN(aStart,{|el|el>m->__Menu_Col})-1,1)
		KEYBOARD _DOWN	//Сразу раскрыть
	ENDIF
	READMENU PROMPTS Mp;
		 MAKE mf STEP 4 ROW 1 COL 1 NOBORDER ;
		 COLOR {_MenuColor,'n/bg','w+/b',HiddenColor};
		 MAIN;
		 START ch1 TO ch1
ENDDO
*nLevel:=0
IF ch1=0 THEN ch1:=1
POP KEYS
@ 1,76 SAY 'F10' COLOR  _im
**********
PROC SecondMenu(mp,mf,column,_row,aWhenNot,cTitle,lNoSetLR)
LOCAL	ch1:=1,aMp:={}
PUSH KEYS
IF_NIL _row IS m->__Menu_Row+2
IF EMPTY(column)
	ch1:=A_MaxLen(mp)
	column:=m->__Menu_Col
	IF column+ch1>=m->__mcol-1 THEN;
		 column:=m->__Menu_Col+LEN(m->__Menu_Prom)-ch1-2
	ch1:=1
ENDIF
IF _row+LEN(mp) >= m->__mrow-2 THEN _row:=m->__mrow-LEN(mp)-3

AEVAL(mp,{|_el,i| AADD(aMp,Num_S36(i)+'-'+_el)})

nLevel++
DO WHILE ch1<>0 .AND. !_Finish
	BEGIN SEQUENCE
	READMENU PROMPTS aMp VERTICAL ;
		MAKE mf ROW _row COL column  ;
		COLOR {_MenuColor,'n/bg','w+/b',HiddenColor};
		LEVEL IF(EMPTY(lNoSetLR), nlevel, 0);
		WHEN_NOT aWhenNot;
		TITLE cTitle;
		start ch1 to ch1
	END SEQUENCE
	IF ch1<>0 .AND. (LASTKEY()<>K_ESC)
		SetColor(_MenuColor)
		_Finish:=.T.
	ENDIF
ENDDO
POP KEYS
nLevel--
