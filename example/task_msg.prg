local i,id1, id2

id1:=start("f1")
id2:=start("f2")

for i=1 to 10
	? 'main: send to ', id1, i, TaskSendMsg(id1, i)
	? 'main: send to ', id2, i, TaskSendMsg(id2, i)
	sleep(1)
next

?
return

func f1
local m

while .t.
	m:=TaskGetMsg()
	? 'f1: got', m
end

func f2
local m

while .t.
	m:=TaskPeekMsg()
	? 'f2: got', m
	sleep(0.5)
end

