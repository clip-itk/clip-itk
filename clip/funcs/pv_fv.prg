/*
    Copyright (C) 2001  ITK
    Author   : Yevgen Bondar (elb@lg.bank.gov.ua)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/
/*
Accrued amount of ordinary rent (Future value investment)
R_FVI(permanent payment, percentage, the number of payments)

Accrued amount for N accrual and M payments per year
R_FVI"(Annual fee, percentage, all years,  accruals per year , payments per year)

Modern amount of rent (Present value investment)
R_PVI(permanent payment, percentage, the number of payments)

Modern amount for N accrual and M payments per year
R_PVI(Annual fee, percentage, all years,  accruals per year , payments per year)

Amount of constant payment (Investment Payment)
R_Payment(sum,percentage, all years,  accruals per year , payments per year)
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
//the opposite of FV ()
LOCAL res
DEFAULT nPay TO 1,nInv TO 1
nPercent:=nPercent*0.01
res:=1+nPercent/nPay
res:=nTotal/((res^(nNumber*nPay) - 1)/((res^(nPay/nInv)-1)*nInv))
RETURN res

