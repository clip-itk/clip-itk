//clear screen
? "aaa"
? taskversion()
? "begin"
nnn:=5
for i=1 to NNN
    ? "i=",i,""
    start(@asdf(),i)
    sleep(0.01)
next
?
? "end,waiting 1 sec"
for i=1 to nnn+5
    taskSendMsg(i,"msg N "+alltrim(str(i)),.t.)
next
sleep(1)
? "quit"
?

static function asdf(n)
	local i,msg
	? "task",taskid(),"waiting message"
	/*
	while .t.
	    ?? taskPeekMsg()
	    sleep(0.1)
	end
	*/
	msg=TASKGETMSG()
	? "task",taskid(),"received message",msg
	for i=1 to 5
	  	? "n=",n,"id=",taskid(),"i=",i,""
		sleep(0.01)	
	next		
return
