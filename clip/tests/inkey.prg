procedure main
clear screen
showtime(0,maxcol()-8,.f.,"0/w")
? "Press key or ESC"
nkey:=0
while nkey !=27
	nkey:=inkey(0,255)
	? nkey,'"'+chr(nkey)+'"'
end
?
return

