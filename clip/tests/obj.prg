//local o
local olocal
o:=map()
o:destroy := @des()
o:a := 0
? o
o:a += 2
? o
? 'фыва'
o:a += 2
? o
//o:destroy()
?
//o:=0

? 'o3:'
o3()
? 'o2:'
o2()
? 'a1:'
a1()
? 'o4:'
o4()
?


function a1()
? "a1"
return

function o2()
? 'o2'
return


function o3()
? 'o3'
return


function o4()
? 'o4'
return

static function des(o)
	? "call destroy"
        ?  'o', o
        ?  ::a
	? 'self', __self__
return

init procedure iii()
	? 'iii'
return
