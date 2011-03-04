dispbox(1,1,5,40,1)
//set loglevel to 4
private w1
set color to 15/7
mopen()
? 'w1qwerty=', w1
set color to 15/3
w2:=wopen(7,15,19,60)
wbox(2)
? 'w2=', w2
w3:=wopen(9,20,22,65)
wbox(4)
? 'w3=', w3
inkey(0)
? 'try close w1=',w1
//wselect(w2)
wclose(w1)
@ 3,3 say 'end:3,3'
inkey(0)
//wselect(w3)
//inkey(0)

func mopen
local l1:="l1_value"
w1 = wopen(5,5,15,50)
wbox(1)
inkey(0)

return
