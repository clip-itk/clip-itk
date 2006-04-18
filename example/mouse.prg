#include <inkey.ch>

local key:=0
local flags:=0

set color to "g+/b"
clear screen

while .t.
	dispbegin()
	@ 0,0 clear
	@ 5,0 say 'inkey()'
	@ 5,10 say key
	@ 6,0 say 'kbdstat()'
	@ 6,10 say flags

	@ 1,40 say 'mpresent()'
	@ 1,60 say mpresent()
	@ 2,40 say 'mrow()'
	@ 2,60 say mrow() picture '999'
	@ 3,40 say 'mcol()'
	@ 3,60 say mcol() picture '999'
	@ 4,40 say 'mleftdown()'
	@ 4,60 say mleftdown()
	@ 5,40 say 'mrightdown()'
	@ 5,60 say mrightdown()
	@ 6,40 say 'mmiddledown()'
	@ 6,60 say mmiddledown()
	@ 10,0 say 'mstate()'
	@ 11,0 say mstate()
	dispend()

	key:=inkey(0, INKEY_ALL)
	flags:=kbdstat()

	if  chr(key)=="q"
		quit
	endif
	if key==1
		quit
	endif
end

