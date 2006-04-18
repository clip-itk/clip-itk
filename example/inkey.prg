//clear screen
local nkey
? "Press key or ESC"
nkey:=0
while nkey !=27
	nkey:=inkey(0,128)
	? nkey,'"'+chr(nkey)+'"'
end
?
return

