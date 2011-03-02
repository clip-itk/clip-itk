/*
    Copyright (C) 1998-2003 Yevgen Bondar <elb@lg.bank.gov.ua>
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
Special "banking" functions
*/
#define BIT(n) (VAL(SUBSTR(N0,n,1)))

**********
FUNC Vkrz1(n0)
n0:=PADL(n0,5)
RETU n0+ SUBSTR(STR ( (BIT(1)+BIT(2)*3+BIT(3)*7+BIT(4)+BIT(5)*3) * 7 ), -1)
**********
FUNC Vkrz14(account,Amf)     && account,6(5)-digit MFI
LOCAL n0
n0:=Padl(amf,5)+(Account:=PadR(Account,14))
Amf:= Str(  (	BIT(1)+(BIT(2)*3) % 10+(BIT(3)*7) % 10+BIT(4)+(BIT(5)*3) % 10+;
		(BIT(6)*3) % 10 + (BIT(7)*7) % 10 +BIT(8)+(BIT(9)*3) % 10 +;
		BIT(11)+(BIT(12)*3) % 10 + (BIT(13)*7) % 10 +BIT(14)+;
		(BIT(15)*3) % 10 + (BIT(16)*7) % 10 +BIT(17)+;
		(BIT(18)*3) % 10 + (BIT(19)*7) % 10 + LEN(TRIM(Account));
	    ) % 10 *7,2,0)

RETU LEFT(Account,4)+SUBSTR(Amf,-1)+SUBSTR(Account,6)
**********
FUNC Vkrz20(account,Amf)     && account,3(2)-digit RKC number
LOCAL n0,cAcc,aRz:={7,1,3},i,kr:=0

Account:=PadR(Account,20)
cAcc:=SUBSTR(Account,6,1)
IF (i:=AT(cAcc,'ÄÇëÖçäåêíïABCEHKMPTX'))<>0 // utf-8: '–ê–í–°–ï–ù–ö–ú–†–¢–•ABCEHKMPTX'
     cAcc:=STR((i-1) % 10,1)
ENDIF

cAcc:=	LEFT(Account,5)+cAcc+;
	SUBSTR(Account,7,2)+'0'+SUBSTR(Account,10)

n0:=Padl(amf,3)+cAcc
FOR i:=1 TO 23
	kr+=( (BIT(i)*(aRz[((i-1) % 3)+1])) % 10 )
NEXT
kr:=( ( kr % 10 ) * 3 ) % 10

RETU LEFT(Account,8)+STR(kr,1)+SUBSTR(Account,10)
**********
FUNC OKPOTST(n0)
LOCAL nKr,j,i,aVk

n0:=ALLTRIM(FT_XTOY(n0,'C'))
IF LEN(n0) > 8
	RETURN n0
ENDIF
n0:=PADL(n0,7)
aVk:=IF(BETWEEN(n0,'3000000','6000000'),;
	{7,1,2,3,4,5,6},;
	{1,2,3,4,5,6,7})
nKr:=10
j:=0
DO WHILE nKr>9 .AND. j < 3
	nKr=0
	FOR i=1 TO 7
		nKr += BIT(i) * (aVk[i] + j)
	NEXT
	j += 2
	nKr=MOD(nKr,11)
ENDDO
IF nKr>9
	nKr:=0
ENDIF
RETURN n0+STR(nKr,1)
