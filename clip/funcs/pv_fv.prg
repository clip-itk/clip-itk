/*
    Copyright (C) 2001  ITK
    Author   : Yevgen Bondar (elb@lg.bank.gov.ua)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
Наращенная сумма обычной ренты (Future value investment)
R_FVI(постоянный платеж,процент,число платежей)

Наращенная сумма при N начислениях и M выплатах в год
R_FVI(годовой платеж,процент,всего лет,начислений в год,выплат в год)

Современная величина ренты (Present value investment)
R_PVI(постоянный платеж,процент,число платежей)

Современная величина при N начислениях и M выплатах в год
R_PVI(годовой платеж,процент,всего лет,начислений в год,выплат в год)

Величина постоянной выплаты (Investment Payment)
R_Payment(сумма,процент,всего лет,начислений в год,выплат в год)
*/

**********
FUNC R_FVI(nConst,nPercent,nNumber,nPay,nInv,lPrenumerando,lSimple)
LOCAL res
DEFAULT nPay TO 1,nInv TO 1,lSimple TO 0,lPrenumerando TO 0
nPercent:=nPercent*0.01
IF lSimple==1
	res:=nInv*nNumber
	res:=res*nConst*(1+(res-1)*nPercent/(2*nInv))
ELSE
	res:=1+nPercent/nPay
	res:=nConst*(res^(nNumber*nPay) - 1)/((res^(nPay/nInv)-1)*nInv)
	IF lPrenumerando=1
		res:=res * (1+nPercent/nInv)^(nInv/nPay)
	ENDIF
ENDIF
RETURN res
**********
FUNC R_PVI(nConst,nPercent,nNumber,nPay,nInv,lPrenumerando,lSimple)
LOCAL res
DEFAULT nPay TO 1,nInv TO 1,lSimple TO 0,lPrenumerando TO 0
nPercent:=nPercent*0.01
IF lSimple==1
	res:=nInv*nNumber
	res:=res*nConst*(1+res*nPercent/nInv)**-1
ELSE
	res:=1+nPercent/nPay
	res:=nConst*(1- res^(-nNumber*nPay))/((res^(nPay/nInv)-1)*nInv)
	IF lPrenumerando=1
		res:=res * (1+nPercent/nInv)^(nInv/nPay)
	ENDIF
ENDIF
RETURN res
**********
FUNC R_Payment(nTotal,nPercent,nNumber,nPay,nInv)
//обратное от FV()
LOCAL res
DEFAULT nPay TO 1,nInv TO 1
nPercent:=nPercent*0.01
res:=1+nPercent/nPay
res:=nTotal/((res^(nNumber*nPay) - 1)/((res^(nPay/nInv)-1)*nInv))
RETURN res

