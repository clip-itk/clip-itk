/*
    Copyright (C) 2001  ITK
    Author  : Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
#include 'common.ch'
#include 'inkey.ch'
#include 'bdbfmsg.ch'

STATIC lNeedChange:=.F.,cnMask,nLevel:=0,HomeDir,aKeys
MEMVAR _mask
**********
FUNC Filer(cMask,cTopMess,bAction,aAddLines,abAction,bSearch,hTopic)
/*
  Параметры (все необязательные):
	cMask - маска вызова [*.*].
	cTopMess - сообщение на рамке [Выбирайте файл].
	bAction - блок кода,выполняющийся при считывании файла
		  (для дополнительного описания) [{||bDefault(имя файла)}]
		  по умолчанию - не добавляется ничего. Блоку передается
		  соответствующий элемент Directory.
	aAddLines - массив строк,которые надо добавить к массиву файлов.
	abAction - двумерный массив клавиша/ее действие (F2-F10).
	bSearch - блок поиска в полученном массиве
	hTopic - имя главы в Help

	Возвращает {0,''} (при ESC) или
		   {номер выбранного элемента,имя файла,выбран доп.элемент}
		   (при ENTER)
*/
LOCAL	aDirs,aFiles,aFile,aTemp:={},aMain,i,nMaxLen,;
	nDirs,cTemp,aRet,cTop,;
	bDefault:={|el|PAD(el[1],m->_DirShow)+;
			TRANSFORM(el[2],' 9,999,999,999  ')+;
			PAD(el[3],10)+'  '+LEFT(el[4],5)}

IF_NIL cMask IS FILE_MASK
IF_NIL cTopMess IS _MSG_FI_TOP
IF_NIL abAction IS Array(11)
IF_NIL bAction IS bDefault
IF_NIL bSearch IS {||1}
IF_NIL hTopic IS 'H2'
IF_NIL aAddLines IS {}

abAction[1]:={_MSG_FI_F2, {||ChgDisk(),cnMask:=cMask}}
abAction[8]:={_MSG_FI_F9, {||cnMask:=ChgMask(cMask)}}
abAction[4]:={_MSG_FI_F5, {||Cdd(HomeDir),lNeedChange:=.T.,;
					__KeyBoard(_ESC),cnMask:=cMask}}
cMask:=UPPER(cMask)
IF nLevel++ == 0
	aKeys:=AchKeys(.T.,abAction)
	HomeDir:=CurrentDir()
ENDIF

aTemp:=Directory(FILE_MASK,'RDHS')
aFiles:={}
aDirs:={}
aMain:={}
nMaxLen:=LEN(aTemp)
nDirs:=0

FOR i:=1 TO nMaxLen		// с 2 -> 1-й=='.'
	aFile:=aTemp[i]
	cTemp:=aFile[1]
	IF 'D' $ aFile[5] .AND. cTemp<>'.'
		AADD(aMain,"  "+cTemp)
		AADD(aDirs,cTemp)
		nDirs++
	ELSEIF LIKE(cMask,UPPER(cTemp))
		AADD(aMain,Eval(bAction,aFile))
		AADD(aFiles,cTemp)
	ENDIF
NEXT
ASORT(aDirs,,,{|x,y| Upper(x)<Upper(y)})
ASORT(aFiles,,,{|x,y| Upper(x)<Upper(y)})
ASORT(aMain,,,{|x,y| Upper(x)<Upper(y)})

aTemp:=A_Join(aMain,aAddLines)

cTop:=cTopMess+( ' ('+ CurrentDir()+')' )

IF (i:=ForAch(5,cTop,aTemp,EVAL(bSearch,aFiles)+LEN(aDirs),;
      hTopic,ACLONE(aKeys)))==0
	IF lNeedChange
		lNeedChange:=.F.
		aRet:=Filer(cnMask,cTopMess,bAction,aAddLines,abAction,bSearch)
	ELSE
		aRet:={0,''}
	ENDIF
ELSEIF i<=nDirs
	ChDir(aDirs[i])
	aRet:=Filer(cMask,cTopMess,bAction,aAddLines,abAction,bSearch)
ELSEIF i>LEN(aMain)
	aRet:={i,aTemp[i],.T.}
ELSE
	HomeDir := IF( CurrentDir()==HomeDir,	'',;
						CurrentDir()+PATH_DELIM)
	aRet:={i,HomeDir+aFiles[i-LEN(aDirs)],.F.}
ENDIF
IF --nLevel==0 THEN AchKeys(.F.)

RETURN aRet
**********
STATIC PROC ChgDisk
LOCAL cLd:=' Local '
LOCAL	aDisk:={'A','B'},old:=Name_Disk(),i,nT,;
	amDisk:={cLd,cLd},;
	aType:={cLd,' Remote ',' Substed '}
FOR i:=3 TO 26
	IF (nT:=FN_DevType(i))>0
		AADD(aDisk,CHR(i+64))
		AADD(amDisk,aType[nT])
	ENDIF
NEXT
READMENU PROMPTS aDisk NEEDCENTR ROW m->_middlerow STEP 2 ;
	 MESSAGES amDisk;
	 COLOR {m->_im,'n/bg',m->_HdColor,} START 3 TO i
ChDisk(IF(i==0,CHR(old),aDisk[i]))
lNeedChange:=.T.
KEYB _ESC
**********
STATIC FUNC ChgMask(cMask)
PRIVATE _Mask:=PAD(cMask,12)
IF GetName(_MSG_FI_MASK,'_mask')
	cMask:=ALLTRIM(_Mask)
ENDIF
lNeedChange:=.T.
__KeyBoard(_ESC)
RETURN cMask
