? "test for big numeric"
set rational on
? "set rational is:",set(_SET_RATIONAL)
x:=val("11/7")
? 'str("11/7")', str(x)
? 'str("11/7",100,97)', str(x,100,97)
x:=val("123456789012345678901234567890/1000000000000")
? 'val("123456789012345678901234567890/1000000000000")=',x
?

