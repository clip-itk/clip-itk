local i
public pub1:='pub1', pub2:='pub2'

? start(@f1(), 'p1', 'p2', 'p3')

for i=1 to 10
	? 'main:', i, 'pub2', pub2
	sleep(1)
next

?
return

static func f1(a,b,c)
local i

? 'f1: pub1', pub1
? 'f1: pub2', pub2
pub2:=22
? 'f1: a', a
? 'f1: b', b
? 'f1: c', c

taskstop()
? 'task switching stopped'
for i=1 to 10
	? 'f11:', i
	pub2:=i
	sleep(0.5)
next
taskstart()
? 'task switching started'

for i=1 to 10
	? 'f12:', i
	pub2:=i
	sleep(0.5)
next


return


