/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
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
LOCAL	aDirs,aFiles,aFile,aTemp,aMain,i,nMaxLen,;
	nDirs,cTemp,aRet,cTop,aDscr,bEval,;
	bDefault:={|el|PAD(el[1],m->_DirShow)+;
			TRANSFORM(el[2],' 9,999,999,999  ')+;
			PAD(el[3],12)+LEFT(el[4],5)}

IF_NIL cMask IS FILE_MASK
IF_NIL cTopMess IS _MSG_FI_TOP
IF_NIL abAction IS Array(11)
IF_NIL bAction IS bDefault
IF_NIL bSearch IS {||1}
IF_NIL hTopic IS 'H2'
IF_NIL aAddLines IS {}

*#IFNDEF __UNIX__
	abAction[1]:={_MSG_FI_F2, {||ChgDisk(),cnMask:=cMask}}
*#ENDIF
abAction[4]:={_MSG_FI_F5, {||Cdd(HomeDir),lNeedChange:=.T.,;
					__KeyBoard(_ESC),cnMask:=cMask}}
abAction[8]:={_MSG_FI_F9, {||cnMask:=ChgMask(cMask)}}
abAction[9]:={_MSG_FI_F10,{|| ShowInfo(aRet[m->nItem],aDscr,aTemp[m->nItem])}}
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

FOR i:=1 TO nMaxLen
	aFile:=aTemp[i]
	cTemp:=aFile[1]
	IF 'D' $ aFile[5]
		IF cTemp<>'.'
			AADD(aMain,"  "+cTemp)
			AADD(aDirs,cTemp)
			nDirs++
		ENDIF
	ELSEIF LIKE(cMask,UPPER(cTemp))
		AADD(aMain,Eval(bAction,aFile))
		AADD(aFiles,cTemp)
	ENDIF
NEXT
bEval:={|x,y| Upper(x)<Upper(y)}
ASORT(aDirs,,,bEval)
ASORT(aFiles,,,bEval)
ASORT(aMain,,,bEval)

aTemp:=A_Join(aMain,aAddLines)
aRet:=Ext_Arr(A_Join(aDirs,aFiles),LEN(aTemp),'')

aDscr:={}
/*
IF !EMPTY(cTemp:=MemoRead("Descript.ion"))
	bEval:={|_1| AADD(aDscr, TRIM(Description(_1,cTemp)))}
	AEVAL(aDirs,  bEval)
	AEVAL(aFiles, bEval)
ENDIF
*/
IF !EMPTY(cTemp:=Description())
	bEval:={|_1| AADD(aDscr, Description(_1,cTemp)) }
	AEVAL(aDirs,  bEval)
	AEVAL(aFiles, bEval)
ENDIF
aDscr:=Ext_Arr(aDscr,LEN(aTemp),'')

cTop:=cTopMess+( ' ('+ CurrentDir()+')' )

IF (i:=ForAch(5,cTop,aTemp,EVAL(bSearch,aFiles)+LEN(aDirs),;
       hTopic,ACLONE(aKeys),aDscr))==0
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
STATIC PROC ShowInfo(cFile,aDscr,cFull)
LOCAL aInfo,aDir,lFile
IF EMPTY(cFile) THEN RETURN
aDir:=Directory(cFile,'RDHS')[1]
lFile:=!('D' $ aDir[5])

aInfo:={;
	IF(lFile,_MSG_FI_FILE,_MSG_FI_DIR) + cFile,;
	IF(lFile,_MSG_FI_SIZE + LTRIM(TRANSFORM(aDir[2],' 9,999,999,999'))+BYTE,''),;
	_MSG_FI_UPD + PAD(aDir[3],12)+aDir[4],;
	_MSG_FI_ATTR + aDir[5]}

IF lFile .AND. Really(m->_SetIndFiler)
	cFull:=_MSG_FI_IND+_MSG_FI_KEY+ALLTRIM(SUBSTR(cFull,m->_DirShow+3))

	AADD(aInfo,'')
	IF DivideStr(cFull,5,__mcol-20,'',@aDir,.T.)>1
		aInfo:=A_Join(aInfo,aDir)
	ELSE
		AADD(aInfo,cFull)
	ENDIF
ENDIF

cFile:=aDscr[m->nItem]

IF !EMPTY(cFile)
  AADD(aInfo,'')
  IF DivideStr(cFile,5,__mcol-20,'',@aDir,.T.)>1
	aInfo:=A_Join(aInfo,aDir)
  ELSE
	AADD(aInfo,cFile)
  ENDIF
ENDIF

Okey(aInfo)
**********
STATIC PROC ChgDisk
LOCAL	aDisk:={},old:=Name_Disk(),i,nT,;
	amDisk:={},;
	aType:={' Logical ',' Floppy ',' Hard ', ' Virtual '}

FOR i:=65 TO 90
	IF (nT:=DevType(CHR(i)) )>0
		AADD(aDisk,CHR(i))
		AADD(amDisk,aType[nT])
	ENDIF
NEXT

READMENU PROMPTS aDisk NEEDCENTR ROW m->_middlerow STEP 2 ;
	 MESSAGES amDisk;
	 COLOR {m->_im,'n/bg',m->_HdColor,} START 3 TO i
IF i<>0
	DiskChange(aDisk[i])
	ChDir(DirName(aDisk[i]))
ENDIF
lNeedChange:=.T.
KEYB _ESC
**********
FUNC DevType(cDisk)
LOCAL nDrive:=DriveType(cDisk), nDisk:=DiskType(cDisk)
IF nDrive=0 .AND. nDisk#0
	IF nDisk=248
		nDrive:=1
	ELSEIF nDisk=254
		nDrive:=4
	ENDIF
ENDIF

RETURN nDrive
**********
STATIC FUNC ChgMask(cMask)
PRIVATE _Mask:=PAD(cMask,12)
IF GetName(_MSG_FI_MASK,'_mask')
	cMask:=ALLTRIM(_Mask)
ENDIF
lNeedChange:=.T.
__KeyBoard(_ESC)
RETURN cMask
