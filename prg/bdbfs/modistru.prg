/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include "common.ch"
#include "inkey.ch"
#include "bdbfmsg.ch"
memvar _Pole,_was_changes,_im,_bm,_base,arAim
FIELD Field_name,Field_Type,Field_Dec,Field_LEN

**********
FUNC Modify_Stru(lChng)
LOCAL	cbClr:=ClearName(),;
	_tmpmemo:='____tmf'+Sx_memoExt(),_TmpBase:='____tmf.dbf',;
	_browBase:='_____tmf.dbf',errB,i,aBlock,lMemo

PRIVATE	_Pole[4],_was_changes:=.f.
PRIVATE	 arAim

arAim:={}
FOR i:=1 TO LEN(m->_aDBSTRUCT)
	aBlock:=m->_aDBSTRUCT[i, 1]
	IF aBlock>='A' THEN  AADD(arAim, {aBlock, aBlock} ) 
NEXT

PUSH KEYS Modi_M_Keys COLOR _im
COPY TO (_browBase) STRU EXTE

USE (_browBase) NEW EXCL
afields(_Pole)
setColor(_im)
cDbedit(5,m->_middlecol-23,m->__mrow-4,m->_middlecol+24,;
	_Pole,'ModiBrow',_Pole,HEAD_BROW)

IF  _Was_Changes
	aBlock:=MakeAim(arAim)
	lMemo:=__DbLocate(Compile("Field_Type $ 'MGP' .OR. (Field_Type=='V' .AND. Field_Len>5)" ) )
ENDIF

USE
SELE 1

IF  _Was_Changes
    IF lMemo THEN SetMemoBlock()
    BEGIN SEQU
	TimerOn()

	Meter(1,MODIFICATION)

	SELE 20
	CREATE &_tmpbase FROM (_browBase)
	dbUseArea( .F.,, (_tmpBase))
	SELE 1
	ErrorSys(.t.)
	SCAN
		SELE 20
		APPE BLANK
		BEGIN SEQU
			AEVAL(aBlock,{|_1|Eval(_1)})
		END
		IF 1->(DELETED()) THEN DELETE
		SELE 1
		IF !CheckEsc()
			_Was_Changes:=.F.	//Отменить
			EXIT
		ENDIF
	ENDSCAN
	ErrorSys()
*	(_tmpBase)->(dbclosearea())
	20->(dbclosearea())
	SELE 1
	USE

        IF _Was_Changes
		IF !('.' $ m->_MainMemoFile) THEN;
			 m->_MainMemoFile:=cbClr+m->_DefaultMemo
		IF lChng
			RENAME(_base,cbClr+'.BAK')
			RENAME(m->_MainMemoFile,cbClr+'.TBK')
		ENDIF
		RENAME(_tmpBase,_base)
		RENAME(_tmpMemo,m->_MainMemoFile)
	ENDIF
	Meter(3)

    END SEQU
ENDIF

FERASE(_browBase)
POP KEYS
RETU 0	// чтобы восстановить индексы
**********
FUNC MODIBROW(_ptr,_a)
LOCAL	GetList:={},;
	aType:={'Character','Numeric','Date','Logical','Memory',;
		'Float', 'Double', 'Integer',;
		'VariField','Variant',; 
		'DateTime',  'Currency',;
		'General', 'Picture';
	},;
	cTypes:='CNDLMFBIVXTYGP'
DO CASE
	CASE _a=K_ENTER
		SetPos( row(), col() )
		DO Case
			CASE _ptr==1
				m->_tmp=Field_Name
				AAdd( GetList, _GET_( _tmp, "_tmp", "@!K", {|| TrueName()} ):Display() )
			CASE _ptr==2
				Ch_Type(ForAch(9,FLD_TYPE,aType,AT(&(_Pole[_ptr]),cTypes)))
			CASE _ptr==3 .AND. Field_Type $ 'CNVFX'
				m->_tmp=IF(Field_Type == 'C',256*Field_dec+Field_Len,Field_Len)
				AAdd( GetList, _GET_( _tmp, "_tmp", IF(Field_type=="C","9999","999"), {|| TrueLen()} ) )
			CASE Field_Type $ 'NFB' .AND. Field_len>2
				m->_tmp=Field_DEC
				AAdd( GetList, _GET_( _tmp, "_tmp", "999", ;
						{||IF( Between(m->_tmp, 0, Field_len-2),;
							(_Field->Field_Dec:=m->_tmp,.T.),;
							(Nfind(BAD_LEN),.F.));
							} ) )
			OTHER
				__KeyBoard()	// от зацикливания
		EndCASE
		ReadModal(GetList)
		GetList:={} ; SetColor(_im)
		IF _ptr<>4 .AND. LastKey()=K_ENTER
			Keyb _RIGHT+_EMP+_ENTER
		ELSEIF Empty(Field_Name)
			A_Del(arAim,RECNO())
			DELE
			_a:=Max(Recno()-1,1)
			__DBPACK()
			go _a
			RETU 2
		ENDIF
		arAim[RECNO(),2]:=Field_Name

	CASE _a=K_ALT_X .OR. (_a=K_ESC .AND. Continue(BE_CANCEL))
		RETU 0

	CASE InList(_a,K_F3,K_INS,K_F5,K_CTRL_N)
		IF _a=K_F5 .OR. _a=K_CTRL_N
			Insert()
			A_Ins(arAim,{'',''},RECNO())
			SetColor(_im)
		ELSE
			APPE BLANK
			AADD(arAim,{'',''})
		ENDIF
		REPLACE field_name with '',;
			field_type WITH "C",;
			field_len WITH 10
		Keyb _HOME+_EMP+_ENTER
		RETU 2

	CASE InList(_a,K_F8,K_DEL,K_CTRL_Y) .AND.;
	     Continue(DEL_FIELD)
		A_Del(arAim,RECNO())
		DELE
		_a:=Max(Recno()-1,1)
		__DBPACK()
		go _a
		RETU 2

	CASE _a=K_F9 .AND. Continue(NEED_OPTIM)
		GO TOP
		_a:=LastRec()
		SCAN
			IF !VariFieldLen() THEN _a--
		ENDSCAN
		GO TOP
		NFIND(NTRIM(_a)+ FIELDS_OPTIM)
		RETU 2

	CASE _a=K_F10 .AND. Continue(MAKE_CHANGE)
		_Was_Changes=.T.
		RETU 0

	CASE _ptr=2 .AND. (_a:=AT(UPPER(chr(_a)),cTypes))<>0
		CH_TYPE(_a)

	CASE _a=K_CTRL_UP .AND. recno()<>1
		_a:=arAim[recno()]
		arAim[recno()]:=arAim[recno()-1]
		arAim[recno()-1]:=_a
		SWAP(recNO(),recno()-1)

	CASE _a=K_CTRL_DOWN .AND. recno()<>LastRec()
		_a:=arAim[recno()]
		arAim[recno()]:=arAim[recno()+1]
		arAim[recno()+1]:=_a
		SWAP(recNO(),recno()+1)

	CASE (BETWEEN(_a,65,255) .AND.  (_ptr = 1)).OR.;
	     (BETWEEN(_a,48,57) .AND.  (_ptr > 2))
		KEYBOARD _ENTER+CHR(_a)

EndCASE
RETU 1
**********
STATIC FUNC MakeAim(arAim)
/*
 Сделать массив выражений перевода для каждого поля
 и преобразовать в блок
*/
LOCAL i,_a,aBlock:={},aStr:=m->_aDBSTRUCT
*Nfind(ArAim)
FOR i:=1 TO LEN(arAim)
	IF (_a:=AMScan(aStr,1,arAim[i,1])) <>0 // было такое поле
		GO i
		IF (m->_dtype[_a]<>Field_type) .AND. !Field_Type $ 'VX'
			arAim[i,1]:='XTOY('+TRIM(arAim[i,1])+',['+Field_Type+'])'
		ENDIF
	ENDIF
NEXT
AEVAL(arAim,{|_1| IF(!EMPTY(_1[1]),;
		AADD(aBlock,Compile('20->'+TRIM(_1[2])+':=1->('+_1[1]+')')), NIL) })
RETURN aBlock
**********
STATIC PROC Ch_TYPE(_a)
#define _ML IF('VFP' $ RddSetDefault(), 4, 10)
LOCAL _ft:=substr('CNDLMFBIVXTYGP',_a,1)
IF _a>0 .AND. (Field_type<>_ft)
	IF _ft<>'V'
        	REPLACE Field_Type WITH _ft,;
			Field_Len WITH {field_len,field_len,8,1,_ML,;
					field_len,8,4,10,10,8,8,_ML,_ML}[_a]
	ELSE
		VariFieldLen(.t.)
	ENDIF
	IF _ft='Y'  
		REPL Field_dec WITH 4
	ELSEIF !(_ft $ 'NFB') 
		REPL Field_dec WITH 0
	ENDIF
ENDIF
**********
STATIC FUNC VariFieldLen(lObligate)
LOCAL lRes:=.T.
IF field_type=='D'
	REPLACE field_type WITH "V",;
		field_len WITH 3
ELSEIF	field_type $ 'NF' .AND. field_dec=0 .AND. Between(field_len,5,10)
	REPLACE field_type WITH "V",;
		field_len WITH 4,;
		field_dec WITH 0
ELSEIF	field_type=='M'
	REPLACE field_type WITH "V",;
		field_len WITH 6,;
		field_dec WITH 0
ELSEIF	!EMPTY(lObligate) .OR.;
	(field_type=='C' .AND. ((field_len > 16) .OR. (field_dec<>0)))
	REPLACE field_type WITH "V",;
		field_len WITH 10,;
		field_dec WITH 0
ELSE
	lRes:=.F.
ENDIF
RETURN lRes
**********
STATIC FUNC TrueName
LOCAL _badName:=BAD_NAME, cFld:=Trim(m->_tmp), _a, _tm, _tmprc:=RecNO()
BEGIN SEQU
  IF cFld <'A'
  	Break(_badname)
  ENDIF

  FOR _a=1 to Len(cFld)
	IF !(((_tm:=Substr(cFld,_a,1)) $ '0123456789_') .OR. IsAlpha(_tm))
		Break(_badName)
	ENDIF
  NEXT

  IF __DBLocate({|| Trim(Field_Name)=cFld .AND. Recno()<>_tmprc })
	Break(EXIST_NAME)
  ENDIF

RECOVER USING _a
	GO _tmprc
	NFIND(_a)
	RETU .F.
END
go _tmprc
REPL field_Name WITH cFld
RETU .T.
**********
STATIC FUNC  TrueLen
//Сюда попадают CNVFX
LOCAL _i:=.T., nS:=m->_tmp

IF (nS < 1) .OR. (nS>65534) .OR.;
   ((field_type $ 'NF') .AND. (nS>20)) .OR.;
   ((field_type = 'V') .AND. InList(nS,1,2,5)) .OR.;
   ((field_type = 'X') .AND. !Between(nS,10, 127))

	_i:=.F.
	Nfind(BAD_LEN)

ELSE

	REPL field_len WITH (nS % 256)

	IF field_type = "C"
		REPL Field_Dec WITH INT(nS / 256)
	ELSEIF field_type $ "VX" .OR. (Field_dec>=Field_len-2)
		REPL Field_Dec with 0
	ENDIF
ENDIF
RETU _i
