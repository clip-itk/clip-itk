/*
    Copyright (C) 2001  ITK
    Author  : Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

#include "common.ch"
#include "bdbfmsg.ch"
#include "inkey.ch"
MEMVAR _hdColor, _im, _abort,__tagnom,_iv
#define MYSELF 'Support: elb@lg.bank.gov.ua, Bondar_Eugen@yahoo.com'
**********
PROC HELP( _prg,_line,_var)
LOCAL _handle,_HlpFile:=Sx_FnameParser(GetPath(),.t.),_r,_c
STATIC lInstance
PRIVATE _MemoPrnt:=80
IF_NIL _prg IS ProcName(1)
IF EMPTY(lInstance) .AND. IsFileExist(@_HlpFile,'.HLP')
  lInstance:=.T.

  SavePos()

  _line:=MemoRead(_HlpFile)
  IF (_handle:=At('~'+_prg,_line))==0
	_var:=2
	WHILE !EMPTY(_prg:=PROCNAME(_var++)) .AND.;
	      (_handle:=AT('~'+_prg,_line))==0 .AND. _var<6
	END
  ENDIF
  IF _handle#0
	Parce(Substr(_line,_handle+1+Len(_prg)),_CRLF+'~',@_line)
	Memo_Edit(_line,;
		  'Up Down PgUp PgDn'+_ABORT,;
		  MYSELF,;
		  .F.,,'BDBFS: Help topic '+_prg)
  ELSE
	NFind(_MSG_H_NO)
  ENDIF
  IF PROCNAME(2)<>'NFIND' .AND. !('MEM' $ PROCNAME(2)) THEN FT_PutKey(255)
  RestPos()
  lInstance:=.F.
ENDIF
**********
FUNC Information(aFileStr)
// В aFileStr по ссылке передается информация для File в DispStru
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
aEval(_ndb,{|_handle| Center(++nCnt,_handle)})
Waitkey(0)

IF (_a:=Sx_TagCount(1))<>0
	aTagInfo := TagInfo(1)	// Получить информацию о тегах для текущего .CDX
				// Теперь нарисуем дисплей
	Panel(4,2,18,77,_MSG_H_TITLE+Rdd_Info(1)[1] + ' )',;
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

	nCnt := 1      // Начать с первого тега

			//Отобразить информацию о тегах,

	DO WHILE (.T.)

		aTag:=aTagInfo[nCnt]
		@  7,45 SAY nCnt pict '99' color _HdColor
		@  9,23 SAY PADR(aTag[1], 10) color _HdColor
		DEVOUT(IF(__TagNom==nCnt,' *','  '))
		@ 10,23 SAY PADR(aTag[2], 52) color _HdColor
		@ 11,23 SAY PADR(aTag[3], 52) color _HdColor

		@ 12,23 SAY IF(aTag[4], YESNO)  color _HdColor
		@ 13,23 SAY IF(aTag[5], YESNO)  color _HdColor
		@ 14,23 SAY IF(aTag[6], YESNO)  color _HdColor

		*Sx_SetTagNo(nCnt)
		OrdSetFocus(nCnt)
		SKIP 0
		@ 15,23 SAY KeyCount() pict '99999999' color _HdColor
		@ 15,57 SAY KeyNo() pict '99999999'    color _HdColor

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

POP KEYS

IF !Empty(m->_IndexFile)
	ordListClear(); ordListAdd( m->_IndexFile )
	*SET INDEX TO &_IndexFile
ELSEIF __tagNom<>0
	Sx_SetTagNo(__tagNom)
ENDIF
**********
FUNC CheckOsVer()
#IFDEF __CLIP__
	RETURN OS()
#ELSE
LOCAL cVer,nCnt,cBuf:=''

cVer:=Ft_DosVer()
FT_GETE(@cBuf)
DO CASE
	CASE '20.' $ cVer
		nCnt:=VAL(SUBSTR(cVer,4,1))
		cVer:='OS/2 '+ IF (Between(nCnt,3,5),;
				{'WARP','MERLIN','AURORA'}[nCnt-2],;
				'2.'+NTRIM(nCnt) )

	CASE Is_Linux()
		cVer:='LINUX'

	CASE Is_Nt()
		cVer += '(WIN '+ IF ('5.' $ cVer, '2000/Xp)',;
					 	  'NT)' )

	CASE 'WINDIR' $ UPPER(cBuf)
		cVer += ' (WINDOWS-'+IF('7.' $ cVer,'9x','Me')+')'
ENDCASE
IF Is_4DOS() THEN cVer+=' (UNDER 4DOS)'
RETURN cVer
#ENDIF
**********
FUNC Description(cFile/*,cDscr*/)
LOCAL cDscr
/*IF EMPTY(cDscr) THEN*/ cDscr:=MemoRead('Descript.ion')
IF !EMPTY(cDscr) .AND.  Parce(cDscr,UPPER(cFile)+' ',,@cDscr)#0	//нашли!
	Parce(cDscr,_CRLF,@cDscr)
ELSE
	cDscr:=' '	//чтобы в ACH было видно
ENDIF
RETURN cDscr
