//clear screen
? "aaa"
? taskversion()
? "begin"
nnn:=5
for i=1 to NNN
    ? "i=",i,""
    start(@asdf(),i)
    sleep(0.1)
next
?
? "end,waiting 1 sec"
sleep(1)
? "quit"
?

static function asdf(n)
	sleep(0.01)
  	?? "c",n,"id=",taskid(),""
return
