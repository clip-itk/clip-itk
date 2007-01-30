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
sleep(1)
? "quit"
?

static function asdf(n)
	local i
	for i=1 to 5
	  	? "n=",n,"id=",taskid(),"i=",i,""
		sleep(0.01)	
	next		
return
