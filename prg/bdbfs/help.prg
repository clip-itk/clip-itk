/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
MEMVAR _hdColor, _im, _abort,__tagnom,_iv
#define MYSELF 'Mailto: '+EMAIL+', '+EMAIL2
#define CheckOsVer Os
**********
PROC HELP(_prg,_line,_var,cDefault)
LOCAL _handle,_HlpFile:=Sx_FnameParser(GetPath(),.t.),_r,_c, lTrans:=.F.,;
	cHost:=host_charset(), cLang:=GETE('LANG')
STATIC lInstance
PRIVATE _MemoPrnt:=80
IF_NIL _prg IS ProcName(1)
IsFileExist(@_HlpFile,'.HLP', , .T.)
IF File(_HlpFile+'.'+cHost)
	_HlpFile+='.'+cHost
ELSEIF '_RU' $ cLang .OR. '_UA' $ cLang
	IF File(Strtran(_HlpFile, '.', 'r.'))
		_HlpFile:=Strtran(_HlpFile, '.', 'r.')
		lTrans:=.t.
	ENDIF
ENDIF
SavePos()
IF EMPTY(lInstance) .AND. IsFileExist(@_HlpFile,'.HLP', , !EMPTY(cDefault))
  lInstance:=.T.

  _line:=MemoRead(_HlpFile)
  IF (_handle:=At('~'+_prg,_line))==0
	_var:=2
	WHILE !EMPTY(_prg:=PROCNAME(_var++)) .AND.;
	      (_handle:=AT('~'+_prg,_line))==0 .AND. _var<8
	END
  ENDIF
  IF _handle#0
	Parce(Substr(_line,_handle+1+Len(_prg)),_CRLF+'~',@_line)
	IF lTrans THEN _line:=Translate_charset("cp866", cHost, _line)
	Memo_Edit(_line,;
		  'Up Down PgUp PgDn'+_ABORT,;
		  MYSELF,;
		  .F.,,'BDBFS: Help topic '+_prg)
  ELSEIF !EMPTY(cDefault)
	NFind(cDefault)
  ELSE
	NFind(_MSG_H_NO, , ,  _prg)
  ENDIF
  IF PROCNAME(2)<>'NFIND' .AND. !('MEM' $ PROCNAME(4)) THEN FT_PutKey(K_EMP)
  lInstance:=.F.
ELSEIF !EMPTY(cDefault)
	NFind(cDefault)
ENDIF
RestPos()
**********
PROC Information(aFileStr)
// Got information by reference in aFileStr for File in DispStru
LOCAL _a,aTagInfo,aTag,_i,nCnt,_ndb
dbcommit()
_Ndb:= {DATE_UPDATE+DTOC(LUpdate()),;
	IF(EMPTY(aFileStr),TOTAL_FIELDS +NTRIM(LEN(m->__adbStruct)),' '),;
	HEAD_SIZE +NTRIM(Header())+BYTE,;
	REC_SIZE +NTRIM(RecSize())+BYTE,;
	FILE_SIZE +SpaceString(FileSize(m->_base))+BYTE,;
	DRV_CURRENT+m->__aDrv[ASCAN(m->__aRdd,RddSetDefault())],;
	CODEPAGE+NTRIM(CpDBF()),;
	Description(m->_base)}
IF m->lWasMemo

	AADD(_ndb,MEMO_FILE_SIZE + '('+m->_MainMemoFile+'): '+;
		SpaceString(FileSize(m->_MainMemoFile))+BYTE)
	AADD(_ndb, MEMO_B_SIZE_C + IF( EMPTY(m->_MemoBlSize), '512',;
				      NTRIM(m->_MemoBlSize)) + BYTE);

ENDIF
IF !EMPTY(aFileStr)
	aFileStr:=_ndb
	RETURN
ENDIF

_ndb:=A_JOIN(_ndb,;
	{'',;
	FREE_MEM +NTRIM(Memory())+KBYTE,;
	FREE_SPACE +SpaceString(DiskSpace())+BYTE,;
	CURR_DIR +Currentdir(),;
	MEMO_BLOCK_SIZE +NTRIM(Sx_SetMemoBlock())+BYTE,;
	OS_VER +CheckOsVer()})

nCnt:=2
_i:=(Min(A_MaxLen(_ndb),m->__mcol-3))/2+2
PUSH KEYS COLOR m->_im
Panel(nCnt,m->_middlecol-_i,nCnt+4+Len(_Ndb),m->_middlecol+_i,GetPath(),;
	{m->_im,_HdColor, m->_im})

nCnt+=2
aEval(_ndb,{|_handle| Hi_String(PADC(_handle,_i*2-3),++nCnt,_middlecol-_i+2)})
IF Waitkey(0)<>K_ESC

  IF (_a:=Sx_TagCount(1))<>0
	aTagInfo := TagInfo(1)	// Get information about tags for current .CDX
				// now draw display
	DispBegin()
	Panel(4,2,18,77,_MSG_H_TITLE+Rdd_Info(1)[1] + ')',;
			{_im,_HdColor,_im},2)
	@  7, 4 SAY PADR(IND_FILE,18)+m->_IndexFile
	@  7,40 SAY _MSG_H_TAGS+Str(_a,2)
	@  9, 4 SAY PADR(_MSG_H_TAGN,18)
	@ 10, 4 SAY PADR(_IV,18)
	@ 11, 4 SAY _MSG_H_FE
	@ 12, 4 SAY PADR(_MSG_H_ISU,18)
	@ 13, 4 SAY PADR(_MSG_H_ISD,18)
	@ 14, 4 SAY PADR(_MSG_H_RYO,18)
	@ 15, 4 SAY PADR(_MSG_H_KEYS,18)
	@ 15,40 SAY _MSG_H_CK

	Center(17," PgUp  PgDn "+_Abort,,_HdColor)
	DispEnd()

	nCnt := 1	// Begins from first tag

			//Show info about tags

	DO WHILE (.T.)
	        DispBegin()
		aTag:=aTagInfo[nCnt]
		@  7,45 SAY nCnt pict '99' color _HdColor
		@  9,23 SAY PADR(aTag[1], 10) color _HdColor
		DEVOUT(IF(__TagNom==nCnt,' *','  '))
		@ 10,23 SAY PADR(aTag[2], 52) color _HdColor
		@ 11,23 SAY PADR(aTag[3], 52) color _HdColor

		@ 12,23 SAY IF(aTag[4], YESNO)  color _HdColor
		@ 13,23 SAY IF(aTag[5], YESNO)  color _HdColor
		@ 14,23 SAY IF(aTag[6], YESNO)  color _HdColor

		@ 15,23 SAY KeyCount(nCnt) pict '99999999' color _HdColor
		@ 15,57 SAY KeyNo(nCnt) pict '99999999'    color _HdColor
		DispEnd()
		DO CASE

			CASE (_i :=WaitKey(0)) == K_PGDN .OR. _i==K_ENTER
				IF nCnt < _a THEN nCnt++

			CASE _i == K_PGUP
				IF nCnt > 1 THEN nCnt--

			CASE _i == K_ESC //.OR. _i==K_ALT_X
				EXIT

		ENDCASE

	ENDDO
  ENDIF
ENDIF
POP KEYS

IF !Empty(m->_IndexFile)
	ordListClear(); ordListAdd( m->_IndexFile )
	go _tmr
ELSEIF __tagNom<>0
	Sx_SetTagNo(__tagNom)
ENDIF

**********
FUNC Description(cFile, cDscr)
LOCAL i,aDscr,cLine,cDs,cDlm
IF EMPTY(cDscr)
	cDscr:=StrTran(MemoRead('Descript.ion'),CHR(9),' ')
	aDscr:={}
	DO WHILE !EMPTY(cDscr)
		i:=Parce( cDscr, CHR(10), @cLine, @cDscr)
		cLine:=Exclude(cLine, CHR(13))
		cDlm:=' '
		IF First(cLine)=='"'
			cLine=SUBSTR(cLine,2)
			cDlm:='" '
		ENDIF
		Parce( cLine, cDlm, @cLine, @cDs)
		AADD(aDscr, {ALLTRIM(cLine), ALLTRIM(cDs)})
	ENDDO
ELSE
	aDscr:=cDscr
ENDIF

IF EMPTY(cFile)
	cDscr:=aDscr
ELSE
	cDscr:=''
	IF (i:=AMSCAN(aDscr, 1, cFile))<>0
		cDscr:=aDscr[i,2]
		#IFDEF ENGLISH
			cDscr:=Translate_charset("cp437", host_charset(), cDscr)
		#ELSE
			cDscr:=Translate_charset("cp866", host_charset(), cDscr)
		#ENDIF
	ENDIF
ENDIF

RETURN cDscr