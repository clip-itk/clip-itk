oPrn:=txtprn():new()
? "step 1: empty object"
? oPrn:nPage,oPrn:nLine,oPrn:nPos
? oPrn:data
? "step 2: out small text"
oPrn:out("sdfsdfsd")
? oPrn:nPage,oPrn:nLine,oPrn:nPos
? oPrn:data
? "step 3: goto 3,4,5"
oPrn:goTo(3,4,5)
? oPrn:nPage,oPrn:nLine,oPrn:nPos
? oPrn:data
? "end testing"
?
