clear screen
? taskversion()
? "begin"
nnn:=5
for i=1 to NNN
    ? "i=",i,""
    start(@asdf(),i)
    sleep(0.1)
next
?
? "end,waiting any key"
inkey(0)

static function asdf(n)
	sleep(0.01)
  	?? "c",n,"id=",taskid(),""
return