local a:=333

use test

private last:=4234
last=234
#define _VARBLOCK_(a) {|_p| iif(pcount()==0, a, __field__  a :=_p  ) __field__  }
cb:=_VARBLOCK_(last)
? cb
? eval(cb)
eval(cb, "rqwer")
? eval(cb)
?

a:="last"
//? &a
__FIELD__
? &a := "3333331"
__FIELD__
?

?
